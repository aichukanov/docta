import { getConnection } from '~/server/common/db-mysql';
import { getCurrentUser } from '~/server/common/auth';
import { syncDoctorRelation } from '~/server/common/doctor-relations';
import {
	validateSpecialtyIds,
	validateDoctorLanguageIds,
} from '~/common/validation';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';

interface UpdateMyProfileBody {
	nameSr: string;
	nameSrCyrl: string;
	nameRu: string;
	nameEn: string;
	professionalTitle: string;
	descriptionSr: string;
	descriptionSrCyrl: string;
	descriptionRu: string;
	descriptionEn: string;
	descriptionDe: string;
	descriptionTr: string;
	specialtyIds: number[];
	languageIds: number[];
}

export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);
	if (!user) {
		createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}

	const body: UpdateMyProfileBody = await readBody(event);

	if (!body.nameSr?.trim()) {
		createErrorResponse(400, ERROR_CODES.DOCTOR_NAME_REQUIRED);
	}

	if (
		!validateSpecialtyIds(body, 'api/doctors/update-my-profile') ||
		!validateDoctorLanguageIds(body, 'api/doctors/update-my-profile')
	) {
		createErrorResponse(400, ERROR_CODES.DOCTOR_INVALID_DATA);
	}

	const connection = await getConnection();
	try {
		const [rows]: any = await connection.execute(
			'SELECT id, is_draft FROM doctors WHERE user_id = ?',
			[user.id],
		);

		if (!rows.length) {
			createErrorResponse(404, ERROR_CODES.DOCTOR_PROFILE_NOT_FOUND);
		}

		const doctor = rows[0];
		if (doctor.is_draft) {
			createErrorResponse(403, ERROR_CODES.DOCTOR_PROFILE_IS_DRAFT);
		}

		const doctorId = doctor.id;

		await connection.beginTransaction();

		await connection.execute(
			`UPDATE doctors 
			 SET name_sr = ?, name_sr_cyrl = ?, name_ru = ?, name_en = ?,
			     professional_title = ?,
			     description_sr = ?, description_sr_cyrl = ?, description_ru = ?,
			     description_en = ?, description_de = ?, description_tr = ?
			 WHERE id = ?`,
			[
				body.nameSr.trim(),
				body.nameSrCyrl?.trim() || '',
				body.nameRu?.trim() || '',
				body.nameEn?.trim() || '',
				body.professionalTitle?.trim() || '',
				body.descriptionSr?.trim() || '',
				body.descriptionSrCyrl?.trim() || '',
				body.descriptionRu?.trim() || '',
				body.descriptionEn?.trim() || '',
				body.descriptionDe?.trim() || '',
				body.descriptionTr?.trim() || '',
				doctorId,
			],
		);

		await syncDoctorRelation({
			connection,
			doctorId,
			table: 'doctor_specialties',
			column: 'specialty_id',
			newIds: body.specialtyIds,
		});

		await syncDoctorRelation({
			connection,
			doctorId,
			table: 'doctor_languages',
			column: 'language_id',
			newIds: body.languageIds,
		});

		await connection.commit();
		return createSuccessResponse(SUCCESS_CODES.DOCTOR_PROFILE_UPDATED);
	} catch (err: any) {
		await connection.rollback();
		if (err.statusCode) throw err;
		createErrorResponse(500, ERROR_CODES.DOCTOR_PROFILE_UPDATE_FAILED);
	} finally {
		await connection.end();
	}
});
