/**
 * Composable для работы с локалью пользователя
 */
import type { Language } from '~/enums/language';

export const useUserLocale = () => {
	const auth = useAuth();
	const { locale } = useI18n();
	const cookieLocale = useCookie<string>('locale', {
		maxAge: 1000 * 60 * 60 * 24 * 365,
	});

	/**
	 * Получить локаль пользователя из профиля
	 */
	const fetchUserLocale = async (): Promise<Language | null> => {
		if (!auth.isAuthenticated.value) return null;

		try {
			const response = await $fetch('/api/auth/user-locale', {
				method: 'GET',
			});

			if (response && (response as any).data?.locale) {
				return (response as any).data.locale;
			}
		} catch (error) {
			console.error('Failed to fetch user locale:', error);
		}

		return null;
	};

	/**
	 * Обновить локаль пользователя
	 */
	const updateUserLocale = async (newLocale: Language): Promise<boolean> => {
		// Обновляем локально
		locale.value = newLocale;
		cookieLocale.value = newLocale;

		// Если залогинен - сохраняем в БД
		if (auth.isAuthenticated.value) {
			try {
				await $fetch('/api/auth/update-locale', {
					method: 'POST',
					body: { locale: newLocale },
				});
				return true;
			} catch (error) {
				console.error('Failed to update user locale:', error);
				return false;
			}
		}

		return true;
	};

	return {
		fetchUserLocale,
		updateUserLocale,
	};
};
