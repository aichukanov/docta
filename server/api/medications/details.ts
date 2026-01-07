import { getConnection } from '~/server/common/db-mysql';
import {
	parseClinicPricesData,
	getPriceOrderBySQL,
	processLocalizedNameForClinicOrDoctor,
} from '~/server/common/utils';
import type { ClinicServiceWithPrices } from '~/interfaces/clinic';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(
	async (event): Promise<ClinicServiceWithPrices> => {
		try {
			const body = await readBody(event);

			if (!validateBody(body, 'api/medications/details')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!validateNonNegativeInteger(body.medicationId)) {
				setResponseStatus(event, 400, 'Invalid medication id');
				return null;
			}

			const locale = body.locale || 'en';

			const priceOrder = getPriceOrderBySQL();
			const medicationQuery = `
			SELECT DISTINCT
				m.id,
				m.name_en,
				m.name_sr,
				m.name_sr_cyrl,
				m.name_ru,
				m.name_de,
				m.name_tr,
				(
					SELECT GROUP_CONCAT(clinic_id ORDER BY ${priceOrder})
					FROM clinic_medications
					WHERE medication_id = m.id
				) as clinicIds,
				(
					SELECT GROUP_CONCAT(
						CONCAT(clinic_id, ':', COALESCE(price, 0), ':', COALESCE(price_max, 0), ':', COALESCE(code, ''))
						ORDER BY ${priceOrder}
					)
					FROM clinic_medications
					WHERE medication_id = m.id
				) as clinicPricesData
			FROM medications m
			WHERE m.id = ?
			GROUP BY m.id, m.name_en, m.name_sr, m.name_sr_cyrl, m.name_ru, m.name_de, m.name_tr;
		`;

			const connection = await getConnection();
			const [medicationRows] = await connection.execute(medicationQuery, [
				body.medicationId,
			]);
			await connection.end();

			const row = medicationRows[0];
			if (!row) {
				return null;
			}

			// Обрабатываем локализованные имена
			const { name, localName } = processLocalizedNameForClinicOrDoctor(
				row,
				locale,
			);
			// Удаляем избыточные поля локализации
			const {
				name_en,
				name_sr,
				name_sr_cyrl,
				name_ru,
				name_de,
				name_tr,
				...rest
			} = row;

			return {
				...rest,
				id: row.id,
				name,
				localName,
				clinicIds: row.clinicIds,
				clinicPrices: parseClinicPricesData(row.clinicPricesData),
			};
		} catch (error) {
			console.error('API Error - medication data:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch medication data',
			});
		}
	},
);
