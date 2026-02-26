import { getRegionalQuery } from '~/common/url-utils';

export default defineNuxtRouteMiddleware(async (to) => {
	const { fetchUser } = useUserStore();

	const user = await fetchUser();

	if (!user?.is_admin) {
		const { fullPath, query } = to;
		if (import.meta.client) {
			sessionStorage.setItem('auth_redirect', fullPath);
		}

		return navigateTo({
			name: 'login',
			query: getRegionalQuery(query.lang as string),
		});
	}
});
