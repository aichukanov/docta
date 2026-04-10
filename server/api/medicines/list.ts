import { getConnection } from '~/server/common/db-mysql';
import { getLocalizedNameField } from '~/server/common/utils';
import { validateBody, validateName } from '~/common/validation';
import { LIST_PAGE_SIZE } from '~/common/constants';

interface MedicineListItem {
	id: number;
	slug: string;
	name: string;
	strength: string | null;
	pharmaForm: string | null;
	manufacturer: string | null;
	country: string | null;
	dispensingMode: string | null;
	isActive: boolean;
	atcCode: string | null;
}

interface MedicineListResponse {
	items: MedicineListItem[];
	totalCount: number;
}

export default defineEventHandler(
	async (event): Promise<MedicineListResponse> => {
		try {
			const body = await readBody(event);

			if (!validateBody(body, 'api/medicines/list')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return { items: [], totalCount: 0 };
			}

			return getMedicineList(body);
		} catch (error) {
			console.error('API Error - medicines:', error);
			return { items: [], totalCount: 0 };
		}
	},
);

async function getMedicineList(
	body: {
		name?: string;
		dispensingMode?: 'otc' | 'prescription' | 'all';
		atcGroupId?: number;
		activeOnly?: boolean;
		locale?: string;
		page?: number;
	} = {},
): Promise<MedicineListResponse> {
	const whereFilters: string[] = [];
	const queryParams: Array<number | string> = [];
	const locale = body.locale || 'en';
	const usePagination = body.page != null;
	const pageRaw = Number(body.page);
	const pageSize = LIST_PAGE_SIZE;
	const page = Math.max(Number.isFinite(pageRaw) ? pageRaw : 1, 1);
	const offset = Math.max(Math.trunc((page - 1) * pageSize), 0);

	// Active only (default: true)
	if (body.activeOnly !== false) {
		whereFilters.push('m.is_active = 1');
	}

	// Dispensing mode filter
	if (body.dispensingMode === 'otc') {
		whereFilters.push(
			`m.dispensing_mode_id = (SELECT id FROM med_dispensing_modes WHERE name LIKE '%bez ljekarskog recepta%' LIMIT 1)`,
		);
	} else if (body.dispensingMode === 'prescription') {
		whereFilters.push(
			`m.dispensing_mode_id != (SELECT id FROM med_dispensing_modes WHERE name LIKE '%bez ljekarskog recepta%' LIMIT 1)`,
		);
	}

	// ATC group filter
	if (body.atcGroupId) {
		whereFilters.push('m.atc_group_id = ?');
		queryParams.push(body.atcGroupId);
	}

	// Name search — search in medicine name + substance names across all languages
	if (body.name && validateName(body, 'api/medicines/list')) {
		const nameField = getLocalizedNameField(locale) || 'name_en';
		const p = `%${body.name}%`;
		whereFilters.push(`(
			m.name LIKE ? OR
			EXISTS (
				SELECT 1 FROM med_medicine_substances mms
				JOIN med_substances s ON s.id = mms.substance_id
				WHERE mms.medicine_id = m.id AND (
					s.name LIKE ? OR s.name_en LIKE ? OR s.${nameField} LIKE ?
					OR s.name_ru LIKE ? OR s.name_sr LIKE ? OR s.name_sr_cyrl LIKE ?
				)
			)
		)`);
		queryParams.push(p, p, p, p, p, p, p);
	}

	const where =
		whereFilters.length > 0 ? 'WHERE ' + whereFilters.join(' AND ') : '';
	const pagination = usePagination
		? `LIMIT ${pageSize} OFFSET ${offset}`
		: '';

	const nameField = getLocalizedNameField(locale) || 'name_en';

	const countQuery = `
		SELECT COUNT(*) as totalCount FROM med_medicines m ${where};
	`;

	const listQuery = `
		SELECT
			m.id,
			m.slug,
			m.name,
			m.strength,
			m.is_active,
			m.atc_code,
			pf.${nameField} as pharmaForm,
			pf.name_en as pharmaFormEn,
			mfg.name as manufacturer,
			c.${nameField} as country,
			c.name_en as countryEn,
			dm.${nameField} as dispensingMode,
			dm.name_en as dispensingModeEn
		FROM med_medicines m
		LEFT JOIN med_pharma_forms pf ON pf.id = m.pharmaceutical_form_id
		LEFT JOIN med_manufacturers mfg ON mfg.id = m.manufacturer_id
		LEFT JOIN countries c ON c.id = mfg.country_id
		LEFT JOIN med_dispensing_modes dm ON dm.id = m.dispensing_mode_id
		${where}
		ORDER BY m.is_active DESC, m.name ASC
		${pagination};
	`;

	const connection = await getConnection();

	let totalCount = 0;
	if (usePagination) {
		const [countRows] = await connection.execute(countQuery, queryParams);
		totalCount = Number((countRows as any[])?.[0]?.totalCount || 0);
	}

	const [rows] = await connection.execute(listQuery, queryParams);
	await connection.end();

	const items = (rows as any[]).map((row) => ({
		id: row.id,
		slug: row.slug,
		name: row.name,
		strength: row.strength,
		pharmaForm: row.pharmaForm || row.pharmaFormEn || null,
		manufacturer: row.manufacturer || null,
		country: row.country || row.countryEn || null,
		dispensingMode: row.dispensingMode || row.dispensingModeEn || null,
		isActive: !!row.is_active,
		atcCode: row.atc_code,
	}));

	return {
		items,
		totalCount: usePagination ? totalCount : items.length,
	};
}
