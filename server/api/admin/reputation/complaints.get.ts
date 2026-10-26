import { requireAdmin } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';
import { getComplaintTable } from '~/server/common/reputation';
import type { ReputationEntity } from '~/enums/complaint-type';
import type { ComplaintAdmin } from '~/interfaces/reputation';
import { ERROR_CODES, createErrorResponse } from '~/server/utils/api-codes';

/**
 * Полный список жалоб клиники или врача для админки — включая неактивные и
 * внутреннюю заметку об источнике. GET ?entity=clinic|doctor&entityId=
 */
export default defineEventHandler(
	async (event): Promise<{ complaints: ComplaintAdmin[] }> => {
		await requireAdmin(event);

		const query = getQuery(event);
		const entity = String(query.entity || '') as ReputationEntity;
		const entityId = parseInt(String(query.entityId || ''), 10);
		if (!['clinic', 'doctor'].includes(entity) || !entityId || entityId <= 0) {
			createErrorResponse(400, ERROR_CODES.COMPLAINT_INVALID_DATA);
		}

		const { table, idColumn, responseColumn } = getComplaintTable(entity);

		const rows = await executeQuery<any>(
			`SELECT
				id,
				${idColumn} as entityId,
				complaint_type as type,
				status,
				is_active as isActive,
				review_id as reviewId,
				article_slug as articleSlug,
				incident_date as incidentDate,
				source_note as sourceNote,
				${responseColumn} as response,
				created_at as createdAt,
				updated_at as updatedAt
			FROM ${table}
			WHERE ${idColumn} = ?
			ORDER BY complaint_type ASC`,
			[entityId],
		);

		return {
			complaints: rows.map((row) => ({
				id: row.id,
				entityId: row.entityId,
				type: row.type,
				status: row.status,
				isActive: Boolean(row.isActive),
				reviewId: row.reviewId ?? undefined,
				articleSlug: row.articleSlug ?? undefined,
				incidentDate: row.incidentDate
					? new Date(row.incidentDate).toISOString().slice(0, 10)
					: undefined,
				sourceNote: row.sourceNote ?? undefined,
				response: row.response ?? undefined,
				createdAt: row.createdAt,
				updatedAt: row.updatedAt,
			})),
		};
	},
);
