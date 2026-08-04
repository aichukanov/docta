import { validateBody, validateNonNegativeInteger } from '~/common/validation';
import { requireAdmin } from '~/server/common/auth';
import { getConnection } from '~/server/common/db-mysql';
import { fetchClinicAdmins } from '~/server/common/clinic-admins';
import type { ClinicAdmin } from '~/interfaces/clinic-admin';

/**
 * Выдача пользователю доступа к кабинету клиники. Повторное добавление —
 * не ошибка: UNIQUE(clinic_id, user_id) гасит дубли, отвечаем текущим списком.
 */
export default defineEventHandler(
	async (event): Promise<{ admins: ClinicAdmin[] } | null> => {
		try {
			await requireAdmin(event);

			const body = await readBody(event);

			if (!validateBody(body, 'api/clinics/admins/add')) {
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
			const userId = Number(body.userId);

			const connection = await getConnection();
			try {
				// Проверяем существование обеих сторон отдельно: FK вернул бы одну
				// ошибку на оба случая, а админу надо знать, что именно не нашлось
				const [clinicRows]: any = await connection.execute(
					'SELECT 1 FROM clinics WHERE id = ? LIMIT 1',
					[clinicId],
				);
				if (!(clinicRows as any[]).length) {
					setResponseStatus(event, 404, 'Clinic not found');
					return null;
				}

				const [userRows]: any = await connection.execute(
					'SELECT 1 FROM auth_users WHERE id = ? LIMIT 1',
					[userId],
				);
				if (!(userRows as any[]).length) {
					setResponseStatus(event, 404, 'User not found');
					return null;
				}

				await connection.execute(
					'INSERT IGNORE INTO clinic_admins (clinic_id, user_id) VALUES (?, ?)',
					[clinicId, userId],
				);

				const admins = await fetchClinicAdmins(connection, clinicId);
				return { admins };
			} finally {
				await connection.end();
			}
		} catch (error) {
			console.error('API Error - clinic admin add:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to add clinic admin',
			});
		}
	},
);
