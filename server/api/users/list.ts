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

		const body = await readBody(event).catch(() => null);
		const query = (body?.query || '').trim();

		const connection = await getConnection();

		let rows: any[];
		if (query) {
			// Remote search: по id, email или имени, LIMIT 20
			const isNumeric = /^\d+$/.test(query);
			const pattern = `%${query}%`;
			const [result]: any = await connection.execute(
				`SELECT id, email, COALESCE(name, '') as name FROM auth_users
				WHERE ${isNumeric ? 'id = ? OR' : ''} email LIKE ? OR name LIKE ?
				ORDER BY id LIMIT 20`,
				isNumeric ? [Number(query), pattern, pattern] : [pattern, pattern],
			);
			rows = result;
		} else {
			const [result]: any = await connection.execute(
				`SELECT id, email, COALESCE(name, '') as name FROM auth_users ORDER BY id`,
			);
			rows = result;
		}

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
