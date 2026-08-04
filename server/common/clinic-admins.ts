import type { Connection } from 'mysql2/promise';
import type { ClinicAdmin } from '~/interfaces/clinic-admin';

/**
 * Администраторы клиники (`clinic_admins`) — единственный источник прав на
 * кабинет клиники. `clinics.created_by` остался только как история «кто
 * создал запись» и в проверках доступа не участвует.
 */

/**
 * Есть ли у пользователя доступ к кабинету клиники. Оба id принимаются
 * необязательными: на публичных страницах клиника может не найтись, а
 * пользователь — быть анонимом, и в обоих случаях ответ «нет».
 */
export async function isClinicAdmin(
	connection: Connection,
	clinicId: number | null | undefined,
	userId: number | null | undefined,
): Promise<boolean> {
	if (clinicId == null || userId == null) return false;

	const [rows]: any = await connection.execute(
		'SELECT 1 FROM clinic_admins WHERE clinic_id = ? AND user_id = ? LIMIT 1',
		[clinicId, userId],
	);
	return (rows as any[]).length > 0;
}

/** Список администраторов клиники для админки. */
export async function fetchClinicAdmins(
	connection: Connection,
	clinicId: number,
): Promise<ClinicAdmin[]> {
	const [rows]: any = await connection.execute(
		`SELECT
			ca.id,
			ca.user_id AS userId,
			ca.created_at AS createdAt,
			u.email,
			COALESCE(u.name, '') AS name,
			(c.created_by = ca.user_id) AS isCreator
		FROM clinic_admins ca
		JOIN auth_users u ON u.id = ca.user_id
		JOIN clinics c ON c.id = ca.clinic_id
		WHERE ca.clinic_id = ?
		ORDER BY isCreator DESC, ca.created_at, ca.id`,
		[clinicId],
	);

	return (rows as any[]).map((row) => ({
		id: row.id,
		userId: row.userId,
		email: row.email || null,
		name: row.name,
		createdAt:
			row.createdAt instanceof Date
				? row.createdAt.toISOString()
				: row.createdAt || null,
		isCreator: Boolean(Number(row.isCreator)),
	}));
}
