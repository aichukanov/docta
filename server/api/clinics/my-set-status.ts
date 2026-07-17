import { getConnection } from '~/server/common/db-mysql';
import { requireUser, getOwnedClinic } from '~/server/common/clinic-cabinet';
import { validateNonNegativeInteger } from '~/common/validation';
import type { ClinicStatus } from '~/interfaces/clinic';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';

interface SetStatusBody {
	clinicId: number;
	action: 'publish' | 'hide';
}

export default defineEventHandler(async (event) => {
	const user = await requireUser(event);

	const body: SetStatusBody = await readBody(event);
	if (
		!body ||
		!validateNonNegativeInteger(body.clinicId) ||
		!['publish', 'hide'].includes(body.action)
	) {
		createErrorResponse(400, ERROR_CODES.CLINIC_INVALID_DATA);
	}

	const connection = await getConnection();
	try {
		const clinic = await getOwnedClinic(connection, body.clinicId, user);

		let newStatus: ClinicStatus;
		if (body.action === 'publish') {
			if (clinic.status === 'published') {
				return createSuccessResponse(SUCCESS_CODES.CLINIC_STATUS_UPDATED, {
					status: clinic.status,
				});
			}
			// Публикуем только заполненный профиль: название, адрес с индексом,
			// точка на карте и хотя бы один контакт.
			const hasContact = [
				clinic.phone,
				clinic.email,
				clinic.website,
				clinic.facebook,
				clinic.instagram,
				clinic.telegram,
				clinic.whatsapp,
				clinic.viber,
			].some((value) => value?.trim());
			if (
				!clinic.name_sr?.trim() ||
				!clinic.address_sr?.trim() ||
				!clinic.postal_code?.trim() ||
				clinic.latitude == null ||
				clinic.longitude == null ||
				!hasContact
			) {
				createErrorResponse(400, ERROR_CODES.CLINIC_INCOMPLETE);
			}
			newStatus = 'published';
		} else {
			if (clinic.status === 'draft') {
				return createSuccessResponse(SUCCESS_CODES.CLINIC_STATUS_UPDATED, {
					status: clinic.status,
				});
			}
			newStatus = 'draft';
		}

		await connection.execute('UPDATE clinics SET status = ? WHERE id = ?', [
			newStatus,
			clinic.id,
		]);

		return createSuccessResponse(SUCCESS_CODES.CLINIC_STATUS_UPDATED, {
			status: newStatus,
		});
	} catch (err: any) {
		if (err.statusCode) throw err;
		console.error('API Error - clinic my-set-status:', err);
		createErrorResponse(500, ERROR_CODES.CLINIC_SAVE_FAILED);
	} finally {
		await connection.end();
	}
});
