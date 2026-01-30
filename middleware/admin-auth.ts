export default defineNuxtRouteMiddleware(async (to, from) => {
	// Проверяем авторизацию через API
	const { data } = await useFetch('/api/admin/auth/me');

	if (!data.value?.authenticated || !data.value?.user?.is_admin) {
		// Если не авторизован или не админ - редирект на страницу входа
		return navigateTo('/admin/login');
	}
});
