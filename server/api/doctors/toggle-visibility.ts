import { getConnection } from '~/server/common/db-mysql';
import { getCurrentUser } from '~/server/common/auth';

export default defineEventHandler(async (event): Promise<{ hidden: boolean }> => {
	const user = await getCurrentUser(event);
	if (!user) {
		throw createError({
			statusCode: 401,
			statusMessage: 'Unauthorized',
		});
	}

	const connection = await getConnection();
	try {
		const [rows]: any = await connection.execute(
			'SELECT id, hidden, is_draft FROM doctors WHERE user_id = ?',
			[user.id],
		);

		if (!rows.length) {
			throw createError({
				statusCode: 404,
				statusMessage: 'Doctor profile not found',
			});
		}

		const doctor = rows[0];

		if (doctor.is_draft) {
			throw createError({
				statusCode: 403,
				statusMessage: 'Cannot change visibility of a draft profile',
			});
		}

		const newHidden = !doctor.hidden;
		await connection.execute(
			'UPDATE doctors SET hidden = ? WHERE id = ?',
			[newHidden ? 1 : 0, doctor.id],
		);

		return { hidden: Boolean(newHidden) };
	} finally {
		await connection.end();
	}
});
