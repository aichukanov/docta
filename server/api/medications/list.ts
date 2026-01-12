import { getConnection } from '~/server/common/db-mysql';
import {
	parseClinicPricesData,
	getPriceOrderBySQL,
	processLocalizedNameForClinicOrDoctor,
	getLocalizedNameField,
} from '~/server/common/utils';
import type { ClinicServiceList } from '~/interfaces/clinic';
import {
	validateBody,
	validateName,
	validateCityIds,
} from '~/common/validation';

export default defineEventHandler(async (event): Promise<ClinicServiceList> => {
	try {
		const body = await readBody(event);

		if (!validateBody(body, 'api/medications/list')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return { items: [], totalCount: 0 };
		}
		if (body.cityIds && !validateCityIds(body, 'api/medications/list')) {
			setResponseStatus(event, 400, 'Invalid city');
			return { items: [], totalCount: 0 };
		}

		return getMedicationList(body);
	} catch (error) {
		console.error('API Error - medications:', error);
		return { items: [], totalCount: 0 };
	}
});

export async function getMedicationList(
	body: {
		clinicIds?: number[];
		cityIds?: number[];
		name?: string;
		locale?: string;
	} = {},
) {
	const whereFilters = [];
	const locale = body.locale || 'en';

	if (body.clinicIds?.length > 0) {
		whereFilters.push(`cm.clinic_id IN (${body.clinicIds.join(',')})`);
	}
	if (body.cityIds?.length > 0) {
		whereFilters.push(`cities.id IN (${body.cityIds.join(',')})`);
	}
	if (body.name && validateName(body, 'api/medications/list')) {
		const nameField = getLocalizedNameField(locale) || 'name_en';
		whereFilters.push(
			`(m.name_en LIKE '%${body.name}%' OR m.${nameField} LIKE '%${body.name}%' OR m.name_sr LIKE '%${body.name}%' OR m.name_sr_cyrl LIKE '%${body.name}%' OR m.name_ru LIKE '%${body.name}%' OR m.name_de LIKE '%${body.name}%' OR m.name_tr LIKE '%${body.name}%')`,
		);
	}

	const whereFiltersString =
		whereFilters.length > 0 ? 'WHERE ' + whereFilters.join(' AND ') : '';

	const priceOrder = getPriceOrderBySQL('cm');
	const medicationsQuery = `
		SELECT DISTINCT
			m.id,
			m.name_en,
			m.name_sr,
			m.name_sr_cyrl,
			m.name_ru,
			m.name_de,
			m.name_tr,
			GROUP_CONCAT(DISTINCT cm.clinic_id ORDER BY ${priceOrder}) as clinicIds,
			GROUP_CONCAT(
				DISTINCT CONCAT(cm.clinic_id, ':', IFNULL(cm.price, ''), ':', '', ':', IFNULL(cm.price_max, ''), ':', COALESCE(cm.code, ''))
				ORDER BY ${priceOrder}
			) as clinicPricesData
		FROM medications m
		LEFT JOIN clinic_medications cm ON m.id = cm.medication_id
		LEFT JOIN clinics ON cm.clinic_id = clinics.id
		LEFT JOIN cities ON clinics.city_id = cities.id
		${whereFiltersString}
		GROUP BY m.id, m.name_en, m.name_sr, m.name_sr_cyrl, m.name_ru, m.name_de, m.name_tr 
		ORDER BY m.name_en ASC;
	`;

	const connection = await getConnection();
	const [medicationRows] = await connection.execute(medicationsQuery);
	await connection.end();

	const items = medicationRows.map((row: any) => {
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
			name: name || '',
			localName: localName || '',
			clinicIds: row.clinicIds,
			clinicPrices: parseClinicPricesData(row.clinicPricesData),
		};
	});

	return {
		items,
		totalCount: items.length,
	};
}
