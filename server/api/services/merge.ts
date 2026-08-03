import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

// Колонка названия → код языка в medical_service_synonyms.
// Коды совпадают с локалями приложения ('sr-cyrl', не 'sr_cyrl') — по ним
// фильтрует выдача синонимов на странице услуги.
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

		if (!validateBody(body, 'api/services/merge')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return false;
		}

		if (!validateNonNegativeInteger(body.primaryServiceId)) {
			setResponseStatus(event, 400, 'Invalid primary service id');
			return false;
		}

		if (!validateNonNegativeInteger(body.secondaryServiceId)) {
			setResponseStatus(event, 400, 'Invalid secondary service id');
			return false;
		}

		if (body.primaryServiceId === body.secondaryServiceId) {
			setResponseStatus(event, 400, 'Cannot merge service with itself');
			return false;
		}

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			// Проверяем существование обеих услуг
			const [serviceRows]: any = await connection.execute(
				`SELECT id, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr
				 FROM medical_services WHERE id IN (?, ?)`,
				[body.primaryServiceId, body.secondaryServiceId],
			);

			if (serviceRows.length !== 2) {
				throw createError({
					statusCode: 400,
					statusMessage: 'One or both services not found',
				});
			}

			// 1. Переносим связи с клиниками (только те, которых ещё нет)
			await connection.execute(
				`INSERT IGNORE INTO clinic_medical_services (medical_service_id, clinic_id, price, price_min, price_max, code, is_price_outdated)
				 SELECT ?, clinic_id, price, price_min, price_max, code, is_price_outdated
				 FROM clinic_medical_services
				 WHERE medical_service_id = ?`,
				[body.primaryServiceId, body.secondaryServiceId],
			);

			// 1.1 Клиника могла быть привязана к обеим услугам — тогда INSERT IGNORE
			// выше ничего не вставил. Дозаполняем пустые поля основной услуги
			// данными дубликата, чтобы не потерять цену.
			// is_price_outdated присваивается ПЕРВЫМ: MySQL вычисляет SET слева
			// направо, и после присвоения p.price условие уже не сработает.
			await connection.execute(
				`UPDATE clinic_medical_services p
				 JOIN clinic_medical_services s
				   ON s.clinic_id = p.clinic_id AND s.medical_service_id = ?
				 SET p.is_price_outdated = CASE
					     WHEN p.price IS NULL AND s.price IS NOT NULL THEN s.is_price_outdated
					     ELSE p.is_price_outdated
				     END,
				     p.price = COALESCE(p.price, s.price),
				     p.price_min = COALESCE(p.price_min, s.price_min),
				     p.price_max = COALESCE(p.price_max, s.price_max),
				     p.code = COALESCE(p.code, s.code)
				 WHERE p.medical_service_id = ?`,
				[body.secondaryServiceId, body.primaryServiceId],
			);

			// 2. Переносим специальности (только те, которых ещё нет)
			await connection.execute(
				`INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
				 SELECT ?, specialty_id
				 FROM medical_services_specialties
				 WHERE medical_service_id = ?`,
				[body.primaryServiceId, body.secondaryServiceId],
			);

			// 3. Переносим категории (только те, которых ещё нет)
			await connection.execute(
				`INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
				 SELECT ?, medical_service_category_id
				 FROM medical_service_categories_relations
				 WHERE medical_service_id = ?`,
				[body.primaryServiceId, body.secondaryServiceId],
			);

			// 4. Переносим связь услуг с врачами в клиниках (только те, которых ещё нет)
			await connection.execute(
				`INSERT IGNORE INTO clinic_medical_service_doctors (clinic_id, medical_service_id, doctor_id, price, price_max)
				 SELECT clinic_id, ?, doctor_id, price, price_max
				 FROM clinic_medical_service_doctors
				 WHERE medical_service_id = ?`,
				[body.primaryServiceId, body.secondaryServiceId],
			);

			// 4.1 Переносим справочный контент. На medical_service_id стоит UNIQUE,
			// поэтому UPDATE IGNORE перенесёт справку только если у основной услуги
			// её ещё нет; иначе справка останется на дубликате и уйдёт по CASCADE.
			await connection.execute(
				`UPDATE IGNORE medical_service_reference_info
				 SET medical_service_id = ?
				 WHERE medical_service_id = ?`,
				[body.primaryServiceId, body.secondaryServiceId],
			);

			// 4.2 Переносим связь с тарифами ФЗОЦГ (FK стоит на SET NULL —
			// без переноса коды молча отвязались бы от каталога)
			await connection.execute(
				`UPDATE medical_service_tariffs
				 SET medical_service_id = ?
				 WHERE medical_service_id = ?`,
				[body.primaryServiceId, body.secondaryServiceId],
			);

			// 4.3 Переносим отзывы (FK стоит на CASCADE — без переноса удалились бы)
			await connection.execute(
				`UPDATE reviews
				 SET medical_service_id = ?
				 WHERE medical_service_id = ?`,
				[body.primaryServiceId, body.secondaryServiceId],
			);

			// 4.4 Переносим синонимы дубликата. UPDATE IGNORE — у основной услуги
			// такой синоним мог уже быть, тогда строка дубликата уйдёт по CASCADE.
			await connection.execute(
				`UPDATE IGNORE medical_service_synonyms
				 SET medical_service_id = ?
				 WHERE medical_service_id = ?`,
				[body.primaryServiceId, body.secondaryServiceId],
			);

			// 4.5 Сохраняем названия удаляемой услуги как синонимы основной —
			// иначе формулировка, под которой услугу знает клиника (и по которой
			// её ищут), после слияния перестала бы находиться.
			const secondaryNames = serviceRows.find(
				(s: any) => s.id === body.secondaryServiceId,
			);
			if (secondaryNames) {
				const primaryNames = serviceRows.find(
					(s: any) => s.id === body.primaryServiceId,
				);
				for (const [column, language] of SYNONYM_LANGUAGE_COLUMNS) {
					const value = secondaryNames[column]?.trim();
					// Совпало с названием основной услуги — синоним не нужен.
					if (!value || value === primaryNames?.[column]?.trim()) {
						continue;
					}
					await connection.execute(
						`INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
						 VALUES (?, ?, ?)`,
						[body.primaryServiceId, value, language],
					);
				}
			}

			// 5. Удаляем связи удаляемой услуги
			await connection.execute(
				'DELETE FROM clinic_medical_services WHERE medical_service_id = ?',
				[body.secondaryServiceId],
			);
			await connection.execute(
				'DELETE FROM medical_services_specialties WHERE medical_service_id = ?',
				[body.secondaryServiceId],
			);
			await connection.execute(
				'DELETE FROM medical_service_categories_relations WHERE medical_service_id = ?',
				[body.secondaryServiceId],
			);
			await connection.execute(
				'DELETE FROM clinic_medical_service_doctors WHERE medical_service_id = ?',
				[body.secondaryServiceId],
			);

			// 6. Обновляем существующие редиректы и добавляем новый
			await connection.execute(
				`UPDATE medical_service_redirects SET new_id = ? WHERE new_id = ?`,
				[body.primaryServiceId, body.secondaryServiceId],
			);
			await connection.execute(
				`INSERT IGNORE INTO medical_service_redirects (old_id, new_id) VALUES (?, ?)`,
				[body.secondaryServiceId, body.primaryServiceId],
			);

			// 6.1 Сохраняем слаг удаляемой услуги в slug_redirects
			const secondaryService = serviceRows.find(
				(s: any) => s.id === body.secondaryServiceId,
			);
			if (secondaryService) {
				const [slugRows]: any = await connection.execute(
					'SELECT slug FROM medical_services WHERE id = ?',
					[body.secondaryServiceId],
				);
				const oldSlug = slugRows[0]?.slug;
				if (oldSlug) {
					await connection.execute(
						`INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id) VALUES ('services', ?, ?)`,
						[oldSlug, body.primaryServiceId],
					);
				}
			}

			// 7. Удаляем услугу
			const [result]: any = await connection.execute(
				'DELETE FROM medical_services WHERE id = ?',
				[body.secondaryServiceId],
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
		console.error('API Error - service merge:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to merge services',
		});
	}
});
