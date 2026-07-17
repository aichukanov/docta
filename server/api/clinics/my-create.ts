import { getConnection } from '~/server/common/db-mysql';
import {
	requireUser,
	validateClinicCabinetBody,
	clinicFieldParams,
	upsertClinicWorkingHours,
	type ClinicCabinetBody,
} from '~/server/common/clinic-cabinet';
import { generateSlug } from '~/common/slug-utils';
import { ensureUniqueSlug } from '~/server/common/slug-db';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';

export default defineEventHandler(async (event) => {
	const user = await requireUser(event);

	const body: ClinicCabinetBody = await readBody(event);
	validateClinicCabinetBody(body, 'api/clinics/my-create');

	const connection = await getConnection();
	try {
		await connection.beginTransaction();

		const baseSlug = generateSlug(body.nameSr.trim() || 'clinic');
		const slug = await ensureUniqueSlug(connection, 'clinics', baseSlug);

		const { columns, values } = clinicFieldParams(body);
		const placeholders = columns.map(() => '?').join(', ');

		const [insertResult]: any = await connection.execute(
			`INSERT INTO clinics (slug, created_by, status, ${columns.join(', ')})
			 VALUES (?, ?, 'draft', ${placeholders})`,
			[slug, user.id, ...values],
		);

		const clinicId: number = insertResult.insertId;

		for (const languageId of body.languageIds) {
			await connection.execute(
				'INSERT INTO clinic_languages (clinic_id, language_id) VALUES (?, ?)',
				[clinicId, languageId],
			);
		}

		for (const typeId of body.clinicTypeIds || []) {
			await connection.execute(
				'INSERT INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (?, ?)',
				[clinicId, typeId],
			);
		}

		if (body.workingHours) {
			await upsertClinicWorkingHours(connection, clinicId, body.workingHours);
		}

		await connection.commit();
		return createSuccessResponse(SUCCESS_CODES.CLINIC_CREATED, {
			id: clinicId,
			slug,
		});
	} catch (err: any) {
		await connection.rollback();
		if (err.statusCode) throw err;
		console.error('API Error - clinic my-create:', err);
		createErrorResponse(500, ERROR_CODES.CLINIC_SAVE_FAILED);
	} finally {
		await connection.end();
	}
});
