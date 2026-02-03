/**
 * Plugin для инициализации локали при загрузке страницы
 * Приоритет:
 * 1. Локаль из профиля пользователя (если залогинен)
 * 2. Локаль из cookie
 * 3. Локаль из query параметра (?lang=ru)
 * 4. Локаль по умолчанию (Serbian)
 */
export default defineNuxtPlugin(async (nuxtApp) => {
	const { locale } = useI18n();
	const route = useRoute();
	const auth = useAuth();

	// Получаем локаль из cookie
	const cookieLocale = useCookie<string>('locale', {
		maxAge: 1000 * 60 * 60 * 24 * 365,
	});

	// Приоритет 1: Локаль из профиля пользователя
	if (auth.isAuthenticated.value && auth.user.value?.id) {
		try {
			const response = await $fetch('/api/auth/user-locale', {
				method: 'GET',
			});

			if (response && (response as any).locale) {
				locale.value = (response as any).locale;
				cookieLocale.value = (response as any).locale;
				return;
			}
		} catch (error) {
			console.error('Failed to fetch user locale:', error);
		}
	}

	// Приоритет 2: Локаль из cookie
	if (cookieLocale.value) {
		locale.value = cookieLocale.value;
		return;
	}

	// Приоритет 3: Локаль из query параметра
	const queryLang = route.query.lang;
	if (queryLang && typeof queryLang === 'string') {
		locale.value = queryLang;
		cookieLocale.value = queryLang;
		return;
	}

	// Приоритет 4: Локаль по умолчанию (уже установлена в i18n.config)
});
