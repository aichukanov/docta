import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import {
	downloadAndSaveImage,
	isExternalUrl,
} from '~/server/utils/image-processing';
import { generateSlug } from '~/common/slug-utils';
import { ensureUniqueSlug, saveSlugRedirect } from '~/server/common/slug-db';
import {
	validateBody,
	validateCityId,
	validateClinicTypeIds,
	validateDoctorLanguageIds,
	validateNonNegativeInteger,
} from '~/common/validation';

export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		await requireAdmin(event);

		const body = await readBody(event);

		if (!validateBody(body, 'api/clinics/update')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}

		if (!validateNonNegativeInteger(body.id)) {
			setResponseStatus(event, 400, 'Invalid clinic id');
			return null;
		}

		if (!validateCityId(body, 'api/clinics/update')) {
			setResponseStatus(event, 400, 'Invalid city');
			return null;
		}
		if (!validateDoctorLanguageIds(body, 'api/clinics/update')) {
			setResponseStatus(event, 400, 'Invalid clinic language');
			return null;
		}
		if (
			body.clinicTypeIds &&
			!validateClinicTypeIds(body, 'api/clinics/update')
		) {
			setResponseStatus(event, 400, 'Invalid clinic type');
			return null;
		}

		if (body.logoUrl && isExternalUrl(body.logoUrl)) {
			body.logoUrl = await downloadAndSaveImage(body.logoUrl, 'clinics');
		}

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			const clinicName = body.name_sr || body.name || '';
			const baseSlug = body.slug || generateSlug(clinicName || 'clinic');
			const slug = await ensureUniqueSlug(
				connection,
				'clinics',
				baseSlug,
				body.clinicId,
			);

			await saveSlugRedirect(connection, 'clinics', body.clinicId, slug);

			const updateClinicQuery = `
				UPDATE clinics
				SET slug = ?, name_sr = ?, name_sr_cyrl = ?, name_ru = ?, city_id = ?, address_sr = ?, address_sr_cyrl = ?, town_sr = ?, town_sr_cyrl = ?, postal_code = ?, latitude = ?, longitude = ?,
				    phone = ?, email = ?, website = ?, facebook = ?, instagram = ?,
				    telegram = ?, whatsapp = ?, viber = ?,
				    description_sr = ?, description_sr_cyrl = ?, description_en = ?, description_ru = ?, description_de = ?, description_tr = ?,
				    logo_url = ?
				WHERE id = ?;
			`;

			await connection.execute(updateClinicQuery, [
				slug,
				body.name_sr || body.name || '',
				body.name_sr_cyrl || '',
				body.name_ru || '',
				body.cityId,
				body.address_sr || body.address || '',
				body.address_sr_cyrl || '',
				body.town_sr || body.town || '',
				body.town_sr_cyrl || '',
				body.postalCode || '',
				body.latitude || 0,
				body.longitude || 0,
				body.phone || '',
				body.email || '',
				body.website || '',
				body.facebook || '',
				body.instagram || '',
				body.telegram || '',
				body.whatsapp || '',
				body.viber || '',
				body.description_sr || '',
				body.description_sr_cyrl || '',
				body.description_en || '',
				body.description_ru || '',
				body.description_de || '',
				body.description_tr || '',
				body.logoUrl || '',
				body.id,
			]);

			// Handle languages
			const [existingLanguages]: any = await connection.execute(
				'SELECT language_id FROM clinic_languages WHERE clinic_id = ?',
				[body.id],
			);
			const existingLanguageIds = existingLanguages.map(
				(row: any) => row.language_id,
			);
			const newLanguageIds = body.languageIds;

			const languagesToRemove = existingLanguageIds.filter(
				(id: number) => !newLanguageIds.includes(id),
			);
			const languagesToAdd = newLanguageIds.filter(
				(id: number) => !existingLanguageIds.includes(id),
			);

			if (languagesToRemove.length > 0) {
				const placeholders = languagesToRemove.map(() => '?').join(',');
				await connection.execute(
					`DELETE FROM clinic_languages WHERE clinic_id = ? AND language_id IN (${placeholders})`,
					[body.id, ...languagesToRemove],
				);
			}

			for (const languageId of languagesToAdd) {
				await connection.execute(
					'INSERT INTO clinic_languages (clinic_id, language_id) VALUES (?, ?)',
					[body.id, languageId],
				);
			}

			// Handle clinic types
			if (body.clinicTypeIds) {
				const [existingTypes]: any = await connection.execute(
					'SELECT clinic_type_id FROM clinic_clinic_types WHERE clinic_id = ?',
					[body.id],
				);
				const existingTypeIds = existingTypes.map(
					(row: any) => row.clinic_type_id,
				);
				const newTypeIds = body.clinicTypeIds;

				const typesToRemove = existingTypeIds.filter(
					(id: number) => !newTypeIds.includes(id),
				);
				const typesToAdd = newTypeIds.filter(
					(id: number) => !existingTypeIds.includes(id),
				);

				if (typesToRemove.length > 0) {
					const placeholders = typesToRemove.map(() => '?').join(',');
					await connection.execute(
						`DELETE FROM clinic_clinic_types WHERE clinic_id = ? AND clinic_type_id IN (${placeholders})`,
						[body.id, ...typesToRemove],
					);
				}

				for (const typeId of typesToAdd) {
					await connection.execute(
						'INSERT INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (?, ?)',
						[body.id, typeId],
					);
				}
			}

			await connection.commit();
			await connection.end();

			return true;
		} catch (err) {
			await connection.rollback();
			await connection.end();
			throw err;
		}
	} catch (error) {
		console.error('API Error - clinic update:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to update clinic',
		});
	}
});
