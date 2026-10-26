import { requireAdmin } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';
import { getComplaintTable } from '~/server/common/reputation';
import { isComplaintType, type ReputationEntity } from '~/enums/complaint-type';
import type { User } from '~/server/utils/session';
import {
	ERROR_CODES,
	SUCCESS_CODES,
	createErrorResponse,
	createSuccessResponse,
} from '~/server/utils/api-codes';

/** Таблица сущности и код ошибки «не найдено» — по той же паре ключей */
const ENTITY_TABLES: Record<
	ReputationEntity,
	{ table: string; notFound: ERROR_CODES }
> = {
	clinic: { table: 'clinics', notFound: ERROR_CODES.CLINIC_NOT_FOUND },
	doctor: {
		table: 'doctors',
		notFound: ERROR_CODES.DOCTOR_PROFILE_NOT_FOUND,
	},
};

/**
 * Upsert жалобы по (clinic_id|doctor_id, complaint_type) — одна строка на пару,
 * повторные обращения того же типа меняют статус/поля, а не плодят строки.
 * POST { entity, entityId, complaintType, status, isActive, reviewId?,
 *        articleSlug?, incidentDate?, sourceNote?, response? }
 */
export default defineEventHandler(async (event) => {
	await requireAdmin(event);
	const moderator = event.context.user as User;

	const body = await readBody(event);
	const entity = String(body?.entity || '') as ReputationEntity;
	const entityId = parseInt(String(body?.entityId || ''), 10);
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
	const response =
		typeof body?.response === 'string' && body.response.trim()
			? body.response.trim()
			: null;

	if (
		!['clinic', 'doctor'].includes(entity) ||
		!entityId ||
		entityId <= 0 ||
		!isComplaintType(complaintType) ||
		!['confirmed', 'unconfirmed'].includes(status)
	) {
		createErrorResponse(400, ERROR_CODES.COMPLAINT_INVALID_DATA);
	}

	const { table: entityTable, notFound } = ENTITY_TABLES[entity];
	const entities = await executeQuery<{ id: number }>(
		`SELECT id FROM ${entityTable} WHERE id = ?`,
		[entityId],
	);
	if (entities.length === 0) {
		createErrorResponse(404, notFound);
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

	const { table, idColumn, responseColumn } = getComplaintTable(entity);

	await executeQuery(
		`INSERT INTO ${table}
			(${idColumn}, complaint_type, status, is_active, review_id, article_slug,
			 incident_date, source_note, ${responseColumn}, created_by)
		VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
		ON DUPLICATE KEY UPDATE
			status = VALUES(status),
			is_active = VALUES(is_active),
			review_id = VALUES(review_id),
			article_slug = VALUES(article_slug),
			incident_date = VALUES(incident_date),
			source_note = VALUES(source_note),
			${responseColumn} = VALUES(${responseColumn})`,
		[
			entityId,
			complaintType,
			status,
			isActive,
			reviewId,
			articleSlug,
			incidentDate,
			sourceNote,
			response,
			moderator.id,
		],
	);

	return createSuccessResponse(SUCCESS_CODES.COMPLAINT_SAVED);
});
