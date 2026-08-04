import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

// Колонка названия → код языка в lab_test_synonyms.
// Коды совпадают с локалями приложения ('sr-cyrl', не 'sr_cyrl') — по ним
// фильтрует выдача синонимов на странице анализа.
const SYNONYM_LANGUAGE_COLUMNS: ReadonlyArray<readonly [string, string]> = [
	['name_en', 'en'],
	['name_sr', 'sr'],
	['name_sr_cyrl', 'sr-cyrl'],
	['name_ru', 'ru'],
	['name_de', 'de'],
	['name_tr', 'tr'],
];

export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		await requireAdmin(event);

		const body = await readBody(event);

		if (!validateBody(body, 'api/labtests/merge')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return false;
		}

		if (!validateNonNegativeInteger(body.primaryLabTestId)) {
			setResponseStatus(event, 400, 'Invalid primary lab test id');
			return false;
		}

		if (!validateNonNegativeInteger(body.secondaryLabTestId)) {
			setResponseStatus(event, 400, 'Invalid secondary lab test id');
			return false;
		}

		if (body.primaryLabTestId === body.secondaryLabTestId) {
			setResponseStatus(event, 400, 'Cannot merge lab test with itself');
			return false;
		}

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			// Проверяем существование обоих анализов
			const [labTestRows]: any = await connection.execute(
				`SELECT id, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr
				 FROM lab_tests WHERE id IN (?, ?)`,
				[body.primaryLabTestId, body.secondaryLabTestId],
			);

			if (labTestRows.length !== 2) {
				throw createError({
					statusCode: 400,
					statusMessage: 'One or both lab tests not found',
				});
			}

			const secondaryLabTest = labTestRows.find(
				(r: any) => r.id === body.secondaryLabTestId,
			);

			// 1. Переносим связи с клиниками (только те, которых ещё нет)
			await connection.execute(
				`INSERT IGNORE INTO clinic_lab_tests (lab_test_id, clinic_id, price, price_max, code, is_price_outdated)
				 SELECT ?, clinic_id, price, price_max, code, is_price_outdated
				 FROM clinic_lab_tests
				 WHERE lab_test_id = ?`,
				[body.primaryLabTestId, body.secondaryLabTestId],
			);

			// 1.1 Клиника могла быть привязана к обоим анализам — тогда INSERT IGNORE
			// выше ничего не вставил. Дозаполняем пустые поля основного анализа
			// данными дубликата, чтобы не потерять цену.
			// is_price_outdated присваивается ПЕРВЫМ: MySQL вычисляет SET слева
			// направо, и после присвоения p.price условие уже не сработает.
			await connection.execute(
				`UPDATE clinic_lab_tests p
				 JOIN clinic_lab_tests s
				   ON s.clinic_id = p.clinic_id AND s.lab_test_id = ?
				 SET p.is_price_outdated = CASE
					     WHEN p.price IS NULL AND s.price IS NOT NULL THEN s.is_price_outdated
					     ELSE p.is_price_outdated
				     END,
				     p.price = COALESCE(p.price, s.price),
				     p.price_max = COALESCE(p.price_max, s.price_max),
				     p.code = COALESCE(p.code, s.code)
				 WHERE p.lab_test_id = ?`,
				[body.secondaryLabTestId, body.primaryLabTestId],
			);

			// 2. Переносим категории (только те, которых ещё нет)
			await connection.execute(
				`INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id)
				 SELECT ?, category_id
				 FROM lab_test_categories_relations
				 WHERE lab_test_id = ?`,
				[body.primaryLabTestId, body.secondaryLabTestId],
			);

			// 3. Переносим синонимы. UNIQUE стоит на (another_name, language), а
			// смена lab_test_id его не задевает, поэтому обычного UPDATE достаточно.
			await connection.execute(
				`UPDATE lab_test_synonyms SET lab_test_id = ? WHERE lab_test_id = ?`,
				[body.primaryLabTestId, body.secondaryLabTestId],
			);

			// 4. Сохраняем названия удаляемого анализа как синонимы основного —
			// иначе формулировка, под которой анализ знает клиника (и по которой
			// его ищут), после слияния перестала бы находиться.
			if (secondaryLabTest) {
				const primaryLabTest = labTestRows.find(
					(r: any) => r.id === body.primaryLabTestId,
				);
				for (const [column, language] of SYNONYM_LANGUAGE_COLUMNS) {
					const value = secondaryLabTest[column]?.trim();
					// Совпало с названием основного анализа — синоним не нужен.
					if (!value || value === primaryLabTest?.[column]?.trim()) {
						continue;
					}
					await connection.execute(
						`INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
						 VALUES (?, ?, ?)`,
						[body.primaryLabTestId, value, language],
					);
				}
			}

			// 4.1 Переносим справочный контент. На lab_test_id стоит UNIQUE,
			// поэтому UPDATE IGNORE перенесёт справку только если у основного
			// анализа её ещё нет; иначе она останется на дубликате и уйдёт по CASCADE.
			await connection.execute(
				`UPDATE IGNORE lab_test_reference_info
				 SET lab_test_id = ?
				 WHERE lab_test_id = ?`,
				[body.primaryLabTestId, body.secondaryLabTestId],
			);

			// 5. Удаляем связи удаляемого анализа
			await connection.execute(
				'DELETE FROM clinic_lab_tests WHERE lab_test_id = ?',
				[body.secondaryLabTestId],
			);
			await connection.execute(
				'DELETE FROM lab_test_categories_relations WHERE lab_test_id = ?',
				[body.secondaryLabTestId],
			);

			// 6. Обновляем существующие редиректы и добавляем новый
			await connection.execute(
				`UPDATE lab_test_redirects SET new_id = ? WHERE new_id = ?`,
				[body.primaryLabTestId, body.secondaryLabTestId],
			);
			await connection.execute(
				`INSERT IGNORE INTO lab_test_redirects (old_id, new_id) VALUES (?, ?)`,
				[body.secondaryLabTestId, body.primaryLabTestId],
			);

			// 6.1 Сохраняем слаг удаляемого анализа в slug_redirects
			const [slugRows]: any = await connection.execute(
				'SELECT slug FROM lab_tests WHERE id = ?',
				[body.secondaryLabTestId],
			);
			const oldSlug = slugRows[0]?.slug;
			if (oldSlug) {
				await connection.execute(
					`INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id) VALUES ('labtests', ?, ?)`,
					[oldSlug, body.primaryLabTestId],
				);
			}

			// 7. Удаляем анализ
			const [result]: any = await connection.execute(
				'DELETE FROM lab_tests WHERE id = ?',
				[body.secondaryLabTestId],
			);

			await connection.commit();
			await connection.end();

			return result.affectedRows > 0;
		} catch (err) {
			await connection.rollback();
			await connection.end();
			throw err;
		}
	} catch (error) {
		console.error('API Error - lab test merge:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to merge lab tests',
		});
	}
});
