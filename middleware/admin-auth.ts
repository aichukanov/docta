export default defineNuxtRouteMiddleware(async (to) => {
	const { requireAdmin } = useAuth();

	const redirectTo = await requireAdmin(to);

	if (redirectTo) {
		return navigateTo(redirectTo);
	}
});
