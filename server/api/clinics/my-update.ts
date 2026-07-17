import { getConnection } from '~/server/common/db-mysql';
import {
	requireUser,
	validateClinicCabinetBody,
	getOwnedClinic,
	clinicFieldParams,
	syncClinicRelation,
	upsertClinicWorkingHours,
	type ClinicCabinetBody,
} from '~/server/common/clinic-cabinet';
import { generateSlug } from '~/common/slug-utils';
import { ensureUniqueSlug, saveSlugRedirect } from '~/server/common/slug-db';
import { validateNonNegativeInteger } from '~/common/validation';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';

interface UpdateBody extends ClinicCabinetBody {
	clinicId: number;
}

export default defineEventHandler(async (event) => {
	const user = await requireUser(event);

	const body: UpdateBody = await readBody(event);
	if (!body || !validateNonNegativeInteger(body.clinicId)) {
		createErrorResponse(400, ERROR_CODES.CLINIC_INVALID_DATA);
	}
	validateClinicCabinetBody(body, 'api/clinics/my-update');

	const connection = await getConnection();
	try {
		const clinic = await getOwnedClinic(connection, body.clinicId, user);

		await connection.beginTransaction();

		// Слаг следует за названием: при переименовании сохраняем redirect со старого.
		const baseSlug = generateSlug(body.nameSr.trim() || 'clinic');
		const slug = await ensureUniqueSlug(
			connection,
			'clinics',
			baseSlug,
			clinic.id,
		);
		await saveSlugRedirect(connection, 'clinics', clinic.id, slug);

		const { columns, values } = clinicFieldParams(body);
		const setClause = columns.map((col) => `${col} = ?`).join(', ');

		await connection.execute(
			`UPDATE clinics SET slug = ?, ${setClause} WHERE id = ?`,
			[slug, ...values, clinic.id],
		);

		await syncClinicRelation(
			connection,
			clinic.id,
			'clinic_languages',
			'language_id',
			body.languageIds,
		);

		if (body.clinicTypeIds !== undefined) {
			await syncClinicRelation(
				connection,
				clinic.id,
				'clinic_clinic_types',
				'clinic_type_id',
				body.clinicTypeIds,
			);
		}

		if (body.workingHours) {
			await upsertClinicWorkingHours(connection, clinic.id, body.workingHours);
		}

		await connection.commit();
		return createSuccessResponse(SUCCESS_CODES.CLINIC_UPDATED, {
			id: clinic.id,
			slug,
		});
	} catch (err: any) {
		await connection.rollback();
		if (err.statusCode) throw err;
		console.error('API Error - clinic my-update:', err);
		createErrorResponse(500, ERROR_CODES.CLINIC_SAVE_FAILED);
	} finally {
		await connection.end();
	}
});
