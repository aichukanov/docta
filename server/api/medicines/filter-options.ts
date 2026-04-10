import { getConnection } from '~/server/common/db-mysql';
import { getLocalizedNameField } from '~/server/common/utils';
import { validateBody } from '~/common/validation';

interface FilterOption {
	value: number;
	label: string;
}

interface MedicineFilterOptionsResponse {
	atcGroups: FilterOption[];
	substances: FilterOption[];
	pharmaForms: FilterOption[];
	manufacturers: FilterOption[];
}

export default defineEventHandler(
	async (event): Promise<MedicineFilterOptionsResponse> => {
		try {
			const body = await readBody(event);

			if (!validateBody(body, 'api/medicines/filter-options')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return { atcGroups: [], substances: [], pharmaForms: [], manufacturers: [] };
			}

			return getFilterOptions(body);
		} catch (error) {
			console.error('API Error - medicine filter-options:', error);
			return { atcGroups: [], substances: [], pharmaForms: [], manufacturers: [] };
		}
	},
);

async function getFilterOptions(
	body: { locale?: string } = {},
): Promise<MedicineFilterOptionsResponse> {
	const locale = body.locale || 'en';
	const nameField = getLocalizedNameField(locale) || 'name_en';

	const connection = await getConnection();

	// Run all queries in parallel
	const [atcGroupRows, substanceRows, pharmaFormRows, manufacturerRows] =
		await Promise.all([
			connection.execute(
				`SELECT id, code, COALESCE(${nameField}, name_en, name) as label
			 FROM med_atc_groups
			 ORDER BY code`,
			),
			connection.execute(
				`SELECT s.id, COALESCE(s.${nameField}, s.name_en, s.name) as label
			 FROM med_substances s
			 WHERE EXISTS (
				SELECT 1 FROM med_medicine_substances mms
				JOIN med_medicines m ON m.id = mms.medicine_id
				WHERE mms.substance_id = s.id AND m.is_active = 1
			 )
			 ORDER BY label`,
			),
			connection.execute(
				`SELECT pf.id, COALESCE(pf.${nameField}, pf.name_en, pf.name) as label
			 FROM med_pharma_forms pf
			 WHERE EXISTS (
				SELECT 1 FROM med_medicines m
				WHERE m.pharmaceutical_form_id = pf.id AND m.is_active = 1
			 )
			 ORDER BY label`,
			),
			connection.execute(
				`SELECT mfg.id, mfg.name as label
			 FROM med_manufacturers mfg
			 WHERE EXISTS (
				SELECT 1 FROM med_medicines m
				WHERE m.manufacturer_id = mfg.id AND m.is_active = 1
			 )
			 ORDER BY label`,
			),
		]);

	await connection.end();

	const atcGroups = (atcGroupRows[0] as any[]).map((row) => ({
		value: row.id,
		label: `${row.code} — ${row.label}`,
	}));

	const substances = (substanceRows[0] as any[]).map((row) => ({
		value: row.id,
		label: row.label,
	}));

	const pharmaForms = (pharmaFormRows[0] as any[]).map((row) => ({
		value: row.id,
		label: row.label,
	}));

	const manufacturers = (manufacturerRows[0] as any[]).map((row) => ({
		value: row.id,
		label: row.label,
	}));

	return { atcGroups, substances, pharmaForms, manufacturers };
}
