import { getCurrentUser } from '~/server/common/auth';

export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);

	if (!user) {
		return {
			authenticated: false,
			user: null,
		};
	}

	return {
		authenticated: true,
		user: {
			id: user.id,
			email: user.email,
			name: user.name || user.email,
			username: user.username,
			photo_url: user.photo_url,
			is_admin: user.is_admin,
		},
	};
});
