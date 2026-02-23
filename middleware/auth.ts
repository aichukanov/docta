export default defineNuxtRouteMiddleware(async (to) => {
	const { requireAuth } = useAuth();

	const redirectTo = await requireAuth(to);

	if (redirectTo) {
		return navigateTo(redirectTo);
	}
});
