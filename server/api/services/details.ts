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

			if (!validateBody(body, 'api/services/details')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!validateNonNegativeInteger(body.serviceId)) {
				setResponseStatus(event, 400, 'Invalid medical service id');
				return null;
			}

			const locale = body.locale || 'en';

			const priceOrder = getPriceOrderBySQL();
			const medicalServiceQuery = `
			SELECT DISTINCT
				ms.id,
				ms.name_en,
				ms.name_sr,
				ms.name_sr_cyrl,
				ms.name_ru,
				ms.name_de,
				ms.name_tr,
				(
					SELECT GROUP_CONCAT(clinic_id ORDER BY ${priceOrder})
					FROM clinic_medical_services
					WHERE medical_service_id = ms.id
				) as clinicIds,
				(
					SELECT GROUP_CONCAT(
						CONCAT(clinic_id, ':', COALESCE(price, 0), ':', COALESCE(code, ''))
						ORDER BY ${priceOrder}
					)
					FROM clinic_medical_services
					WHERE medical_service_id = ms.id
				) as clinicPricesData
			FROM medical_services ms
			WHERE ms.id = ?
			GROUP BY ms.id, ms.name_en, ms.name_sr, ms.name_sr_cyrl, ms.name_ru, ms.name_de, ms.name_tr;
		`;

			const connection = await getConnection();
			const [medicalServiceRows] = await connection.execute(
				medicalServiceQuery,
				[body.serviceId],
			);
			await connection.end();

			const row = medicalServiceRows[0];
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
			console.error('API Error - medical service data:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch medical service data',
			});
		}
	},
);
