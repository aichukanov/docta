import { getConnection } from '~/server/common/db-mysql';
import type { MedicalServiceList } from '~/interfaces/medical-service';
import { validateBody, validateName } from '~/common/validation';

export default defineEventHandler(
	async (event): Promise<MedicalServiceList> => {
		try {
			const body = await readBody(event);

			if (!validateBody(body, 'api/medical-services/list')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			return getMedicalServiceList(body);
		} catch (error) {
			console.error('API Error - medical-services:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch medical services',
			});
		}
	},
);

export async function getMedicalServiceList(
	body: {
		clinicIds?: number[];
		name?: string;
	} = {},
) {
	const whereFilters = [];

	if (body.clinicIds?.length > 0) {
		whereFilters.push(`cms.clinic_id IN (${body.clinicIds.join(',')})`);
	}
	if (body.name && validateName(body, 'api/medical-services/list')) {
		whereFilters.push(`ms.name LIKE '%${body.name}%'`);
	}

	const whereFiltersString =
		whereFilters.length > 0 ? 'WHERE ' + whereFilters.join(' AND ') : '';

	const medicalServicesQuery = `
		SELECT DISTINCT
			ms.id,
			ms.name,
			GROUP_CONCAT(DISTINCT cms.clinic_id ORDER BY cms.clinic_id) as clinicIds,
			GROUP_CONCAT(
				DISTINCT CONCAT(cms.clinic_id, ':', COALESCE(cms.price, 0), ':', COALESCE(cms.code, ''))
				ORDER BY cms.clinic_id
			) as clinicPricesData
		FROM medical_services ms
		LEFT JOIN clinic_medical_services cms ON ms.id = cms.medical_service_id
		${whereFiltersString}
		GROUP BY ms.id, ms.name 
		ORDER BY ms.name ASC;
	`;

	const connection = await getConnection();
	const [medicalServiceRows] = await connection.execute(medicalServicesQuery);
	await connection.end();

	// Преобразуем данные о ценах в массив объектов
	const medicalServices = medicalServiceRows.map((row) => {
		const clinicPrices = [];
		if (row.clinicPricesData) {
			const pricesData = row.clinicPricesData.split(',');
			for (const priceData of pricesData) {
				const [clinicId, price, code] = priceData.split(':');
				clinicPrices.push({
					clinicId: Number(clinicId),
					price: Number(price) || null,
					code: code || null,
				});
			}
		}

		return {
			id: row.id,
			name: row.name,
			clinicIds: row.clinicIds,
			clinicPrices,
		};
	});

	return {
		medicalServices,
		totalCount: medicalServices.length,
	};
}
