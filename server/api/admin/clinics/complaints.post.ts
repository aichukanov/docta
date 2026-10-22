import { requireAdmin } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';
import { isClinicComplaintType } from '~/enums/clinic-complaint-type';
import type { User } from '~/server/utils/session';
import {
	ERROR_CODES,
	SUCCESS_CODES,
	createErrorResponse,
	createSuccessResponse,
} from '~/server/utils/api-codes';

/**
 * Upsert жалобы по (clinic_id, complaint_type) — одна строка на пару, повторные
 * обращения того же типа меняют статус/поля, а не плодят строки.
 * POST { clinicId, complaintType, status, isActive, reviewId?, articleSlug?,
 *        incidentDate?, sourceNote?, clinicResponse? }
 */
export default defineEventHandler(async (event) => {
	await requireAdmin(event);
	const moderator = event.context.user as User;

	const body = await readBody(event);
	const clinicId = parseInt(String(body?.clinicId || ''), 10);
	const complaintType = parseInt(String(body?.complaintType || ''), 10);
	const status = body?.status;
	const isActive = body?.isActive !== false;
	const reviewId = body?.reviewId ? parseInt(String(body.reviewId), 10) : null;
	const articleSlug =
		typeof body?.articleSlug === 'string' && body.articleSlug.trim()
			? body.articleSlug.trim().slice(0, 128)
			: null;
	const incidentDate =
		typeof body?.incidentDate === 'string' &&
		/^\d{4}-\d{2}-\d{2}$/.test(body.incidentDate)
			? body.incidentDate
			: null;
	const sourceNote =
		typeof body?.sourceNote === 'string' && body.sourceNote.trim()
			? body.sourceNote.trim()
			: null;
	const clinicResponse =
		typeof body?.clinicResponse === 'string' && body.clinicResponse.trim()
			? body.clinicResponse.trim()
			: null;

	if (
		!clinicId ||
		clinicId <= 0 ||
		!isClinicComplaintType(complaintType) ||
		!['confirmed', 'unconfirmed'].includes(status)
	) {
		createErrorResponse(400, ERROR_CODES.COMPLAINT_INVALID_DATA);
	}

	const clinics = await executeQuery<{ id: number }>(
		'SELECT id FROM clinics WHERE id = ?',
		[clinicId],
	);
	if (clinics.length === 0) {
		createErrorResponse(404, ERROR_CODES.CLINIC_NOT_FOUND);
	}
	if (reviewId) {
		const reviews = await executeQuery<{ id: number }>(
			'SELECT id FROM reviews WHERE id = ?',
			[reviewId],
		);
		if (reviews.length === 0) {
			createErrorResponse(404, ERROR_CODES.REVIEW_NOT_FOUND);
		}
	}

	await executeQuery(
		`INSERT INTO clinic_complaints
			(clinic_id, complaint_type, status, is_active, review_id, article_slug,
			 incident_date, source_note, clinic_response, created_by)
		VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
		ON DUPLICATE KEY UPDATE
			status = VALUES(status),
			is_active = VALUES(is_active),
			review_id = VALUES(review_id),
			article_slug = VALUES(article_slug),
			incident_date = VALUES(incident_date),
			source_note = VALUES(source_note),
			clinic_response = VALUES(clinic_response)`,
		[
			clinicId,
			complaintType,
			status,
			isActive,
			reviewId,
			articleSlug,
			incidentDate,
			sourceNote,
			clinicResponse,
			moderator.id,
		],
	);

	return createSuccessResponse(SUCCESS_CODES.COMPLAINT_SAVED);
});
