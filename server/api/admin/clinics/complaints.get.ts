import { requireAdmin } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';
import type { ClinicComplaintAdmin } from '~/interfaces/clinic-reputation';
import {
	ERROR_CODES,
	createErrorResponse,
} from '~/server/utils/api-codes';

/**
 * Полный список жалоб клиники для админки — включая неактивные и внутреннюю
 * заметку об источнике. GET ?clinicId=
 */
export default defineEventHandler(
	async (event): Promise<{ complaints: ClinicComplaintAdmin[] }> => {
		await requireAdmin(event);

		const query = getQuery(event);
		const clinicId = parseInt(String(query.clinicId || ''), 10);
		if (!clinicId || clinicId <= 0) {
			createErrorResponse(400, ERROR_CODES.COMPLAINT_INVALID_DATA);
		}

		const rows = await executeQuery<any>(
			`SELECT
				id,
				clinic_id as clinicId,
				complaint_type as type,
				status,
				is_active as isActive,
				review_id as reviewId,
				article_slug as articleSlug,
				incident_date as incidentDate,
				source_note as sourceNote,
				clinic_response as clinicResponse,
				created_at as createdAt,
				updated_at as updatedAt
			FROM clinic_complaints
			WHERE clinic_id = ?
			ORDER BY complaint_type ASC`,
			[clinicId],
		);

		return {
			complaints: rows.map((row) => ({
				id: row.id,
				clinicId: row.clinicId,
				type: row.type,
				status: row.status,
				isActive: Boolean(row.isActive),
				reviewId: row.reviewId ?? undefined,
				articleSlug: row.articleSlug ?? undefined,
				incidentDate: row.incidentDate
					? new Date(row.incidentDate).toISOString().slice(0, 10)
					: undefined,
				sourceNote: row.sourceNote ?? undefined,
				clinicResponse: row.clinicResponse ?? undefined,
				createdAt: row.createdAt,
				updatedAt: row.updatedAt,
			})),
		};
	},
);
