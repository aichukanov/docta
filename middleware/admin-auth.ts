/**
 * Middleware для защиты админ-панели
 * Проверяет, что пользователь авторизован и является администратором
 */
export default defineNuxtRouteMiddleware(async (to, from) => {
	const { requireAdmin } = useAuth();
	
	const isAuthorized = await requireAdmin();
	
	if (!isAuthorized) {
		// requireAdmin уже выполнит редирект на /login
		return;
	}
});
