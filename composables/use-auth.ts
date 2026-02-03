import type { User } from '~/server/utils/session';

export interface AuthState {
	authenticated: boolean;
	user: User | null;
	loading: boolean;
}

/**
 * Композабл для работы с авторизацией
 */
export function useAuth() {
	const authState = useState<AuthState>('auth', () => ({
		authenticated: false,
		user: null,
		loading: true,
	}));

	/**
	 * Загрузить информацию о текущем пользователе
	 */
	const fetchUser = async () => {
		authState.value.loading = true;
		try {
			const response = await $fetch('/api/admin/auth/me');
			authState.value.authenticated = response.authenticated;
			authState.value.user = response.user;
		} catch (error) {
			console.error('Failed to fetch user:', error);
			authState.value.authenticated = false;
			authState.value.user = null;
		} finally {
			authState.value.loading = false;
		}
	};

	/**
	 * Выполнить вход через Google
	 */
	const loginWithGoogle = () => {
		// Сохраняем текущий URL для редиректа после авторизации
		const returnTo = useRoute().fullPath;
		if (returnTo && returnTo !== '/login') {
			sessionStorage.setItem('auth_redirect', returnTo);
		}
		
		window.location.href = '/api/auth/google';
	};

	/**
	 * Выполнить вход через Email и пароль
	 */
	const loginWithEmail = async (email: string, password: string) => {
		try {
			const response = await $fetch('/api/auth/login', {
				method: 'POST',
				body: { email, password },
			});

			// Обновляем состояние
			await fetchUser();

			return response;
		} catch (error: any) {
			console.error('Email login error:', error);
			throw error;
		}
	};

	/**
	 * Регистрация через Email и пароль
	 */
	const register = async (email: string, password: string, name: string) => {
		try {
			const response = await $fetch('/api/auth/register', {
				method: 'POST',
				body: { email, password, name },
			});

			// Обновляем состояние
			await fetchUser();

			return response;
		} catch (error: any) {
			console.error('Registration error:', error);
			throw error;
		}
	};

	/**
	 * Выход из системы
	 */
	const logout = async () => {
		try {
			await $fetch('/api/admin/auth/logout', { method: 'POST' });
			authState.value.authenticated = false;
			authState.value.user = null;
			
			// Редиректим на главную
			await navigateTo('/');
		} catch (error) {
			console.error('Logout error:', error);
			throw error;
		}
	};

	/**
	 * Проверить авторизацию (для middleware)
	 */
	const requireAuth = async () => {
		if (!authState.value.user && !authState.value.loading) {
			await fetchUser();
		}

		if (!authState.value.authenticated) {
			// Сохраняем URL для редиректа после авторизации
			const returnTo = useRoute().fullPath;
			sessionStorage.setItem('auth_redirect', returnTo);
			
			await navigateTo('/login');
			return false;
		}

		return true;
	};

	/**
	 * Проверить права администратора (для middleware)
	 */
	const requireAdmin = async () => {
		if (!authState.value.user && !authState.value.loading) {
			await fetchUser();
		}

		if (!authState.value.authenticated || !authState.value.user?.is_admin) {
			await navigateTo('/login');
			return false;
		}

		return true;
	};

	// Computed свойства для удобства
	const isAuthenticated = computed(() => authState.value.authenticated);
	const currentUser = computed(() => authState.value.user);
	const isAdmin = computed(() => authState.value.user?.is_admin || false);
	const isLoading = computed(() => authState.value.loading);

	return {
		// State
		authState,
		isAuthenticated,
		currentUser,
		isAdmin,
		isLoading,

		// Methods
		fetchUser,
		loginWithGoogle,
		loginWithEmail,
		register,
		logout,
		requireAuth,
		requireAdmin,
	};
}
