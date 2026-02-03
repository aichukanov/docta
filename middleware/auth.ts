/**
 * Middleware для защиты маршрутов, требующих авторизации
 * Проверяет, что пользователь авторизован
 */
export default defineNuxtRouteMiddleware(async (to, from) => {
	const { requireAuth } = useAuth();
	
	const isAuthorized = await requireAuth();
	
	if (!isAuthorized) {
		// requireAuth уже выполнит редирект
		return;
	}
});
