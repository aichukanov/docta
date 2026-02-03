/**
 * Global middleware для инициализации локали
 * Приоритет:
 * 1. Локаль из профиля пользователя (если залогинен)
 * 2. Локаль из cookie
 * 3. Локаль из query параметра (?lang=ru)
 * 4. Локаль по умолчанию
 */
export default defineNuxtRouteMiddleware(async (to, from) => {
	// Только на клиенте
	if (process.server) return;

	const { locale } = useI18n();
	const auth = useAuth();

	// Получаем локаль из cookie
	const cookieLocale = useCookie<string>('locale', {
		maxAge: 1000 * 60 * 60 * 24 * 365,
	});

	// Приоритет 1: Локаль из профиля пользователя (если залогинен)
	if (auth.isAuthenticated.value && auth.user.value?.id) {
		try {
			const response = await $fetch('/api/auth/user-locale', {
				method: 'GET',
			});

			if (response && (response as any).data?.locale) {
				const userLocale = (response as any).data.locale;
				locale.value = userLocale;
				cookieLocale.value = userLocale;
				return;
			}
		} catch (error) {
			// Игнорируем ошибку, продолжаем с другими источниками
			console.debug('Failed to fetch user locale:', error);
		}
	}

	// Приоритет 2: Локаль из cookie
	if (cookieLocale.value && cookieLocale.value !== locale.value) {
		locale.value = cookieLocale.value;
		return;
	}

	// Приоритет 3: Локаль из query параметра
	const queryLang = to.query.lang;
	if (queryLang && typeof queryLang === 'string') {
		locale.value = queryLang;
		cookieLocale.value = queryLang;
		return;
	}

	// Приоритет 4: Локаль уже установлена по умолчанию
});
