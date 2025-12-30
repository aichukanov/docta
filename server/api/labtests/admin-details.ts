import { getConnection } from '~/server/common/db-mysql';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

interface ClinicPrice {
	clinicId: number;
	price: number | null;
	code: string | null;
}

interface LabTestAdminDetails {
	id: number;
	name: string;
	name_sr: string;
	name_ru: string;
	name_de: string;
	name_tr: string;
	categoryIds: number[];
	clinicPrices: ClinicPrice[];
	synonyms: { language: string; values: string[] }[];
}

export default defineEventHandler(
	async (event): Promise<LabTestAdminDetails | null> => {
		try {
			const adminCookie = getCookie(event, 'adm');
			if (adminCookie !== 'xpycm') {
				throw createError({ statusCode: 404, statusMessage: 'Not found' });
			}

			const body = await readBody(event);

			if (!validateBody(body, 'api/labtests/admin-details')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!validateNonNegativeInteger(body.labTestId)) {
				setResponseStatus(event, 400, 'Invalid lab test id');
				return null;
			}

			const connection = await getConnection();

			// Получаем основные данные анализа
			const [labTestRows]: any = await connection.execute(
				`SELECT id, name, name_sr, name_ru, name_de, name_tr FROM lab_tests WHERE id = ?`,
				[body.labTestId],
			);

			if (!labTestRows.length) {
				await connection.end();
				return null;
			}

			const labTest = labTestRows[0];

			// Получаем категории
			const [categoryRows]: any = await connection.execute(
				`SELECT category_id FROM lab_test_categories_relations WHERE lab_test_id = ?`,
				[body.labTestId],
			);

			// Получаем цены клиник
			const [clinicPriceRows]: any = await connection.execute(
				`SELECT clinic_id, price, code FROM clinic_lab_tests WHERE lab_test_id = ? ORDER BY clinic_id`,
				[body.labTestId],
			);

			// Получаем синонимы на всех языках
			const [synonymRows]: any = await connection.execute(
				`SELECT another_name, language FROM lab_test_synonyms WHERE lab_test_id = ? ORDER BY language, another_name`,
				[body.labTestId],
			);

			await connection.end();

			// Группируем синонимы по языкам
			const synonymsByLanguage: Record<string, string[]> = {};
			for (const row of synonymRows) {
				if (!synonymsByLanguage[row.language]) {
					synonymsByLanguage[row.language] = [];
				}
				synonymsByLanguage[row.language].push(row.another_name);
			}

			const synonyms = Object.entries(synonymsByLanguage).map(
				([language, values]) => ({
					language,
					values,
				}),
			);

			const clinicPrices: ClinicPrice[] = clinicPriceRows.map((r: any) => ({
				clinicId: r.clinic_id,
				price: r.price,
				code: r.code,
			}));

			return {
				id: labTest.id,
				name: labTest.name || '',
				name_sr: labTest.name_sr || '',
				name_ru: labTest.name_ru || '',
				name_de: labTest.name_de || '',
				name_tr: labTest.name_tr || '',
				categoryIds: categoryRows.map((r: any) => r.category_id),
				clinicPrices,
				synonyms,
			};
		} catch (error) {
			console.error('API Error - lab test admin details:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch lab test details',
			});
		}
	},
);
