import { getConnection } from '~/server/common/db-mysql';
import { getLocalizedNameField } from '~/server/common/utils';
import { validateBody } from '~/common/validation';

export default defineEventHandler(async (event) => {
	try {
		const body = await readBody(event);

		if (!validateBody(body, 'api/medicines/details')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}

		if (!body.slug || typeof body.slug !== 'string') {
			setResponseStatus(event, 400, 'Invalid slug');
			return null;
		}

		const locale = body.locale || 'en';
		const nameField = getLocalizedNameField(locale) || 'name_en';

		const connection = await getConnection();

		// Main medicine data
		const [medRows] = await connection.execute(
			`
			SELECT
				m.id,
				m.cinmed_id,
				m.slug,
				m.name,
				m.strength,
				m.packaging,
				m.detail_packaging,
				m.authorization_number,
				m.authorization_date,
				m.atc_code,
				m.is_active,
				m.detail_url,
				m.updated_at,
				pf.name as pharmaFormSrc,
				pf.${nameField} as pharmaForm,
				pf.name_en as pharmaFormEn,
				mfg.name as manufacturer,
				mfg.full_address as manufacturerAddress,
				c.${nameField} as country,
				c.name_en as countryEn,
				ah.name as authorizationHolder,
				m.dispensing_mode_id,
				ag.${nameField} as atcGroup,
				ag.name_en as atcGroupEn,
				ag.code as atcGroupCode
			FROM med_medicines m
			LEFT JOIN med_pharma_forms pf ON pf.id = m.pharmaceutical_form_id
			LEFT JOIN med_manufacturers mfg ON mfg.id = m.manufacturer_id
			LEFT JOIN countries c ON c.id = mfg.country_id
			LEFT JOIN med_auth_holders ah ON ah.id = m.authorization_holder_id
			LEFT JOIN med_atc_groups ag ON ag.id = m.atc_group_id
			WHERE m.slug = ?
			LIMIT 1
		`,
			[body.slug],
		);

		const med = (medRows as any[])[0];
		if (!med) {
			await connection.end();
			return null;
		}

		// Substances for this medicine
		const [subRows] = await connection.execute(
			`
			SELECT
				s.id,
				s.name as src,
				s.${nameField} as name,
				s.name_en as nameEn
			FROM med_medicine_substances mms
			JOIN med_substances s ON s.id = mms.substance_id
			WHERE mms.medicine_id = ?
		`,
			[med.id],
		);

		// Analogs: other active medicines with the same substances
		const substances = subRows as any[];
		let analogs: any[] = [];

		if (substances.length > 0) {
			const substanceIds = substances.map((s: any) => s.id);
			const placeholders = substanceIds.map(() => '?').join(',');
			const [analogRows] = await connection.execute(
				`
				SELECT DISTINCT
					m2.id,
					m2.slug,
					m2.name,
					m2.strength,
					pf2.${nameField} as pharmaForm,
					pf2.name_en as pharmaFormEn,
					m2.dispensing_mode_id,
					mfg2.name as manufacturer
				FROM med_medicine_substances mms2
				JOIN med_medicines m2 ON m2.id = mms2.medicine_id
				LEFT JOIN med_pharma_forms pf2 ON pf2.id = m2.pharmaceutical_form_id
				LEFT JOIN med_manufacturers mfg2 ON mfg2.id = m2.manufacturer_id
				WHERE mms2.substance_id IN (${placeholders})
					AND m2.id != ?
					AND m2.is_active = 1
				ORDER BY m2.name ASC
				LIMIT 20
			`,
				[...substanceIds, med.id],
			);
			analogs = (analogRows as any[]).map((row: any) => ({
				id: row.id,
				slug: row.slug,
				name: row.name,
				strength: row.strength,
				pharmaForm: row.pharmaForm || row.pharmaFormEn || null,
				dispensingModeId: row.dispensing_mode_id || null,
				manufacturer: row.manufacturer,
			}));
		}

		await connection.end();

		return {
			id: med.id,
			cinmedId: med.cinmed_id,
			slug: med.slug,
			name: med.name,
			strength: med.strength,
			packaging: med.packaging,
			detailPackaging: med.detail_packaging,
			authorizationNumber: med.authorization_number,
			authorizationDate: med.authorization_date,
			atcCode: med.atc_code,
			isActive: !!med.is_active,
			detailUrl: med.detail_url,
			updatedAt: med.updated_at,
			pharmaForm: med.pharmaForm || med.pharmaFormEn || null,
			manufacturer: med.manufacturer,
			manufacturerAddress: med.manufacturerAddress,
			country: med.country || med.countryEn || null,
			authorizationHolder: med.authorizationHolder,
			dispensingModeId: med.dispensing_mode_id || null,
			atcGroup: med.atcGroup || med.atcGroupEn || null,
			atcGroupCode: med.atcGroupCode,
			substances: substances.map((s: any) => ({
				id: s.id,
				name: s.name || s.nameEn || s.src,
			})),
			analogs,
		};
	} catch (error) {
		console.error('API Error - medicine details:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch medicine data',
		});
	}
});
