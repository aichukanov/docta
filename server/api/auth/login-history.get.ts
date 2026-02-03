import { getCurrentUser } from '~/server/common/auth';
import {
	getUserLoginHistory,
	getLoginMethodStats,
} from '~/server/utils/login-history';

export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);

	if (!user) {
		throw createError({
			statusCode: 401,
			statusMessage: 'Unauthorized',
		});
	}

	const query = getQuery(event);
	const limit = Number(query.limit) || 50;

	// Получаем историю входов
	const history = await getUserLoginHistory(user.id, limit);

	// Получаем статистику по методам входа
	const stats = await getLoginMethodStats(user.id);

	return {
		history,
		stats,
		total: history.length,
	};
});
