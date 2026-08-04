import { validateBody, validateNonNegativeInteger } from '~/common/validation';
import { requireAdmin } from '~/server/common/auth';
import { getConnection } from '~/server/common/db-mysql';
import { fetchClinicAdmins } from '~/server/common/clinic-admins';
import type { ClinicAdmin } from '~/interfaces/clinic-admin';

/**
 * Отзыв доступа к кабинету клиники. Снимать можно и создателя записи
 * (clinics.created_by): колонка осталась историей и прав не даёт — иначе
 * ушедшего из клиники сотрудника нельзя было бы отключить.
 */
export default defineEventHandler(
	async (event): Promise<{ admins: ClinicAdmin[] } | null> => {
		try {
			await requireAdmin(event);

			const body = await readBody(event);

			if (!validateBody(body, 'api/clinics/admins/delete')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (
				!validateNonNegativeInteger(body.clinicId) ||
				!validateNonNegativeInteger(body.userId)
			) {
				setResponseStatus(event, 400, 'Invalid clinic or user id');
				return null;
			}

			const clinicId = Number(body.clinicId);

			const connection = await getConnection();
			try {
				await connection.execute(
					'DELETE FROM clinic_admins WHERE clinic_id = ? AND user_id = ?',
					[clinicId, Number(body.userId)],
				);

				const admins = await fetchClinicAdmins(connection, clinicId);
				return { admins };
			} finally {
				await connection.end();
			}
		} catch (error) {
			console.error('API Error - clinic admin delete:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to remove clinic admin',
			});
		}
	},
);
