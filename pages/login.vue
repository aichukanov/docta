<script setup lang="ts">
import loginMessages from '~/i18n/login';
import { getRegionalQuery } from '~/common/url-utils';
import { ERROR_CODES } from '~/server/utils/api-codes';

definePageMeta({
	layout: 'minimal',
});

const { t, locale } = useI18n({
	useScope: 'local',
	messages: loginMessages.messages,
});
const { t: $t } = useI18n({ useScope: 'global' });

const seoTitle = computed(
	() => t('loginTitle') + ' | ' + $t('ApplicationName'),
);

useSeoMeta({
	title: () => seoTitle.value,
});

const userStore = useUserStore();
const { user, isUserLoading } = storeToRefs(userStore);
const route = useRoute();
const router = useRouter();
const authError = ref<ERROR_CODES | null>(null);

const authMode = ref<'login' | 'register'>('login');

const isLoading = ref(false);
const formError = ref<ERROR_CODES | null>(null);

const regionalQuery = computed(() => getRegionalQuery(locale.value));

const oauthError = computed(() => {
	return authError.value || (route.query.error as ERROR_CODES) || null;
});

async function handleLogout() {
	try {
		await userStore.logout();
	} catch (error) {
		console.error('Logout error:', error);
	}
}

async function handleEmailLogin(payload: { email: string; password: string }) {
	formError.value = null;

	if (!payload.email || !payload.password) {
		formError.value = ERROR_CODES.ALL_FIELDS_REQUIRED;
		return;
	}

	try {
		isLoading.value = true;
		const response = await userStore.loginWithEmail(
			payload.email,
			payload.password,
		);

		if (response.redirectTo) {
			await router.push(response.redirectTo);
		} else {
			await router.push({ path: '/', query: regionalQuery.value });
		}
	} catch (error: any) {
		console.error('Login error:', error);
		formError.value =
			(error.data?.statusMessage as ERROR_CODES) ||
			ERROR_CODES.ERROR_DURING_LOGIN;
	} finally {
		isLoading.value = false;
	}
}

async function handleRegister(payload: {
	email: string;
	password: string;
	name?: string;
}) {
	formError.value = null;

	if (!payload.email || !payload.password) {
		formError.value = ERROR_CODES.ALL_FIELDS_REQUIRED;
		return;
	}

	try {
		isLoading.value = true;
		const response = await userStore.register(
			payload.email,
			payload.password,
			payload.name || undefined,
			locale.value,
		);

		if (response.redirectTo) {
			await router.push(response.redirectTo);
		} else {
			await router.push({ path: '/', query: regionalQuery.value });
		}
	} catch (error: any) {
		console.error('Registration error:', error);
		formError.value =
			(error.data?.statusMessage as ERROR_CODES) ||
			ERROR_CODES.ERROR_CREATING_ACCOUNT;
	} finally {
		isLoading.value = false;
	}
}

function switchMode() {
	authMode.value = authMode.value === 'login' ? 'register' : 'login';
	formError.value = null;
}

onMounted(async () => {
	const user = await userStore.fetchUser();

	if (user) {
		const redirectTo = sessionStorage.getItem('auth_redirect');
		if (redirectTo && redirectTo !== '/login') {
			sessionStorage.removeItem('auth_redirect');
			await router.push(redirectTo);
		} else {
			await router.push({ path: '/profile', query: regionalQuery.value });
		}
		return;
	}

	const errorCookie = useCookie('auth_error');
	if (errorCookie.value) {
		authError.value = errorCookie.value as ERROR_CODES;
		errorCookie.value = null;
	}
});
</script>

<template>
	<div>
		<LoginUserInfoCard
			v-if="user"
			:user="user"
			:regional-query="regionalQuery"
			@logout="handleLogout"
		/>

		<div v-else class="login-form">
			<h1 class="login-title">
				{{ authMode === 'login' ? t('loginTitle') : t('registerTitle') }}
			</h1>
			<p class="login-subtitle">
				{{
					authMode === 'login' ? t('chooseLoginMethod') : t('createNewAccount')
				}}
			</p>

			<ApiErrorAlert :error="oauthError" style="margin-bottom: 24px" />
			<ApiErrorAlert
				:error="formError"
				closable
				style="margin-bottom: 24px"
				@close="formError = null"
			/>

			<div class="login-options">
				<div class="oauth-buttons">
					<LoginGoogleButton />
					<LoginFacebookButton />
					<LoginTelegramButton />
				</div>

				<div class="divider">
					<span>{{ t('orContinueWith') }}</span>
				</div>

				<LoginEmailLoginForm
					v-if="authMode === 'login'"
					:loading="isLoading"
					:regional-query="regionalQuery"
					@submit="handleEmailLogin"
					@switch-mode="switchMode"
				/>

				<LoginRegisterForm
					v-else
					:loading="isLoading"
					@submit="handleRegister"
					@switch-mode="switchMode"
				/>
			</div>
		</div>
	</div>
</template>

<style scoped>
.login-title {
	font-size: 28px;
	font-weight: 600;
	text-align: center;
	margin: 0 0 8px 0;
	color: #2c3e50;
}

.login-subtitle {
	font-size: 16px;
	text-align: center;
	margin: 0 0 32px 0;
	color: #7f8c8d;
}

.login-options {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.oauth-buttons {
	display: flex;
	justify-content: center;
	gap: 16px;
}

.divider {
	display: flex;
	align-items: center;
	text-align: center;
	color: #95a5a6;
	margin: 8px 0;
}

.divider::before,
.divider::after {
	content: '';
	flex: 1;
	border-bottom: 1px solid #ecf0f1;
}

.divider span {
	padding: 0 12px;
	font-size: 14px;
}

@media (max-width: 480px) {
	.login-title {
		font-size: 24px;
	}
}
</style>
