import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import type { User } from '~/server/utils/session';
import { getRegionalQuery } from '~/common/url-utils';

export const useUserStore = defineStore('user', () => {
	const user = ref<User | null>(null);
	const isUserLoading = ref(true);
	const fetchPromise = ref<Promise<User | null> | null>(null);

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
		if (returnTo && returnTo !== '/login') {
			sessionStorage.setItem('auth_redirect', returnTo);
		}

		window.location.href = '/api/auth/google';
	};

	const register = async (
		email: string,
		password: string,
		name?: string,
		locale?: string,
	) => {
		try {
			const response = await $fetch('/api/auth/register', {
				method: 'POST',
				body: {
					email,
					password,
					...(name ? { name } : {}),
					...(locale ? { locale } : {}),
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
