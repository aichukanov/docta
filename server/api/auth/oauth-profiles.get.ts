import { getCurrentUser } from '~/server/common/auth';
import {
	getUserOAuthProfiles,
	getPrimaryOAuthProfile,
} from '~/server/utils/oauth-profiles';

export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);

	if (!user) {
		throw createError({
			statusCode: 401,
			statusMessage: 'Unauthorized',
		});
	}

	// Получаем все OAuth профили (google и telegram отдельно)
	const profiles = await getUserOAuthProfiles(user.id);

	// Получаем приоритетный профиль
	const primaryProfile = await getPrimaryOAuthProfile(user.id);

	return {
		google: profiles.google,
		telegram: profiles.telegram,
		facebook: profiles.facebook,
		primaryProvider: primaryProfile?.provider || null,
	};
});
