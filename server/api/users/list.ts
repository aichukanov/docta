import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';

interface UserListItem {
	id: number;
	email: string;
	name: string;
}

export default defineEventHandler(async (event): Promise<UserListItem[]> => {
	try {
		await requireAdmin(event);

		const connection = await getConnection();

		const [rows]: any = await connection.execute(
			`SELECT id, email, COALESCE(name, '') as name FROM auth_users ORDER BY id`,
		);

		await connection.end();

		return rows.map((r: any) => ({
			id: r.id,
			email: r.email,
			name: r.name,
		}));
	} catch (error) {
		console.error('API Error - users list:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch users list',
		});
	}
});
