import { defineStore } from 'pinia';
import { ref, shallowRef, computed } from 'vue';
import type { User } from '~/server/utils/session';
import { getRegionalQuery, isLoginPath } from '~/common/url-utils';

export const useUserStore = defineStore('user', () => {
	// shallowRef: объект пользователя приходит из /api/auth/active-user и всегда
	// заменяется целиком (fetchUser/logout) — ни одно поле не правится точечно.
	const user = shallowRef<User | null>(null);
	const isUserLoading = ref(true);
	// shallowRef: здесь лежит промис, а не данные. ref() пытался бы обернуть его
	// в reactive() на каждой записи (для Promise это no-op, но и смысла нет).
	const fetchPromise = shallowRef<Promise<User | null> | null>(null);

	const isAdmin = computed(() => user.value?.is_admin || false);

	const fetchUser = async (force = false) => {
		if (!fetchPromise.value || force) {
			isUserLoading.value = true;

			const headers = import.meta.server
				? useRequestHeaders(['cookie'])
				: undefined;

			fetchPromise.value = $fetch('/api/auth/active-user', { headers });
		}

		user.value = await fetchPromise.value;
		isUserLoading.value = false;
		return user.value;
	};

	const loginWithEmail = async (email: string, password: string) => {
		try {
			const response = await $fetch('/api/auth/login', {
				method: 'POST',
				body: { email, password },
			});

			await fetchUser(true);

			return response;
		} catch (error: any) {
			console.error('Email login error:', error);
			throw error;
		}
	};

	const loginWithGoogle = () => {
		// Сохраняем текущий URL для редиректа после авторизации
		const returnTo = useRoute().fullPath;
		if (returnTo && !isLoginPath(returnTo)) {
			sessionStorage.setItem('auth_redirect', returnTo);
		}

		window.location.href = '/api/auth/google';
	};

	const register = async (
		email: string,
		password: string,
		name?: string,
		locale?: string,
		termsAccepted?: boolean,
		analyticsConsent?: boolean,
	) => {
		try {
			const response = await $fetch('/api/auth/register', {
				method: 'POST',
				body: {
					email,
					password,
					...(name ? { name } : {}),
					...(locale ? { locale } : {}),
					termsAccepted,
					analyticsConsent,
				},
			});

			await fetchUser(true);

			return response;
		} catch (error: any) {
			console.error('Registration error:', error);
			throw error;
		}
	};

	const logout = async () => {
		try {
			await $fetch('/api/auth/logout', { method: 'POST' });
			fetchPromise.value = null;
			user.value = null;

			await useRouter().push({
				name: 'index',
				query: getRegionalQuery(useRoute().query.lang as string),
			});
		} catch (error) {
			console.error('Logout error:', error);
			throw error;
		}
	};

	return {
		user,
		isUserLoading,
		isAdmin,
		fetchUser,
		loginWithEmail,
		loginWithGoogle,
		register,
		logout,
	};
});
