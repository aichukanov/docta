import { validateBody } from '~/common/validation';
import {
	localizedNameSql,
	nameFieldFor,
	withConnection,
} from '~/server/common/medicines/helpers';

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
				return {
					atcGroups: [],
					substances: [],
					pharmaForms: [],
					manufacturers: [],
				};
			}

			return getFilterOptions(body);
		} catch (error) {
			console.error('API Error - medicine filter-options:', error);
			return {
				atcGroups: [],
				substances: [],
				pharmaForms: [],
				manufacturers: [],
			};
		}
	},
);

async function getFilterOptions(
	body: { locale?: string } = {},
): Promise<MedicineFilterOptionsResponse> {
	const nameField = nameFieldFor(body.locale);

	// Все справочники — параллельно на одном соединении.
	const [atcGroupRows, substanceRows, pharmaFormRows, manufacturerRows] =
		await withConnection((connection) =>
			Promise.all([
				connection.execute(
					`SELECT id, code, ${localizedNameSql('med_atc_groups', nameField)} as label
				 FROM med_atc_groups
				 ORDER BY code`,
				),
				connection.execute(
					`SELECT s.id, ${localizedNameSql('s', nameField)} as label
				 FROM med_substances s
				 WHERE EXISTS (
					SELECT 1 FROM med_medicine_substances mms
					JOIN med_medicines m ON m.id = mms.medicine_id
					WHERE mms.substance_id = s.id AND m.is_active = 1
				 )
				 ORDER BY label`,
				),
				connection.execute(
					`SELECT pf.id, ${localizedNameSql('pf', nameField)} as label
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
			]),
		);

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
