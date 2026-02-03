<script setup lang="ts">
import loginMessages from '~/i18n/login';

definePageMeta({
	layout: false,
});

const { t } = useI18n({
	useScope: 'local',
	messages: loginMessages.messages,
});

const { isAuthenticated, currentUser, fetchUser, logout, loginWithEmail, register } = useAuth();

// Проверяем ошибки OAuth
const route = useRoute();
const router = useRouter();
const authError = ref<string | null>(null);

// Режимы: 'login' | 'register'
const authMode = ref<'login' | 'register'>('login');

// Форма входа
const loginForm = ref({
	email: '',
	password: '',
});

// Форма регистрации
const registerForm = ref({
	email: '',
	password: '',
	confirmPassword: '',
	name: '',
});

const isLoading = ref(false);
const formError = ref<string | null>(null);

// При монтировании проверяем авторизацию и ошибки
onMounted(async () => {
	// Обновляем данные о пользователе
	await fetchUser();

	// Если пользователь авторизован, проверяем редирект
	if (isAuthenticated.value) {
		const redirectTo = sessionStorage.getItem('auth_redirect');
		if (redirectTo && redirectTo !== '/login') {
			sessionStorage.removeItem('auth_redirect');
			await router.push(redirectTo);
			return;
		}
	}

	// Проверяем cookie с ошибкой
	const errorCookie = useCookie('auth_error');
	if (errorCookie.value) {
		authError.value = errorCookie.value as string;
		// Удаляем cookie после прочтения
		errorCookie.value = null;
	}
});

const oauthError = computed(() => {
	// Сначала проверяем flash сообщение из cookie
	if (authError.value) {
		return authError.value;
	}

	// Затем проверяем URL параметры (для Google OAuth)
	const error = route.query.error as string;
	if (!error) return null;

	const errorMessages: Record<string, string> = {
		oauth_failed: t('oauthFailed'),
		no_code: t('noCode'),
		state_mismatch: t('stateMismatch'),
		email_not_verified: t('emailNotVerified'),
		email_not_provided: t('emailNotProvided'),
		oauthCallbackFailed: t('oauthCallbackFailed'),
	};

	return errorMessages[error] || t('authError');
});

async function handleLogout() {
	try {
		await logout();
	} catch (error) {
		console.error('Logout error:', error);
	}
}

async function handleEmailLogin() {
	formError.value = null;
	
	if (!loginForm.value.email || !loginForm.value.password) {
		formError.value = t('fillAllFields');
		return;
	}

	try {
		isLoading.value = true;
		const response = await loginWithEmail(
			loginForm.value.email,
			loginForm.value.password
		);

		// Редиректим
		if (response.redirectTo) {
			await router.push(response.redirectTo);
		} else {
			await router.push('/');
		}
	} catch (error: any) {
		console.error('Login error:', error);
		formError.value = error.data?.statusMessage || t('errorLogin');
	} finally {
		isLoading.value = false;
	}
}

async function handleRegister() {
	formError.value = null;

	if (!registerForm.value.email || !registerForm.value.password || !registerForm.value.name) {
		formError.value = t('fillAllFields');
		return;
	}

	if (registerForm.value.password !== registerForm.value.confirmPassword) {
		formError.value = t('passwordsNotMatch');
		return;
	}

	try {
		isLoading.value = true;
		const response = await register(
			registerForm.value.email,
			registerForm.value.password,
			registerForm.value.name
		);

		// Редиректим
		if (response.redirectTo) {
			await router.push(response.redirectTo);
		} else {
			await router.push('/');
		}
	} catch (error: any) {
		console.error('Registration error:', error);
		formError.value = error.data?.statusMessage || t('errorRegister');
	} finally {
		isLoading.value = false;
	}
}

function switchMode() {
	authMode.value = authMode.value === 'login' ? 'register' : 'login';
	formError.value = null;
}
</script>

<template>
	<div class="login-page">
		<div class="login-container">
			<div class="login-card">
			<!-- Если пользователь авторизован -->
			<div v-if="isAuthenticated" class="user-info">
				<h1>{{ t('welcomeBack') }}</h1>

				<div class="user-card">
					<img
						v-if="currentUser?.photo_url"
						:src="currentUser.photo_url"
						:alt="currentUser.name"
						class="user-avatar"
					/>
					<div class="user-details">
						<h2>{{ currentUser?.name }}</h2>
						<p>{{ currentUser?.username ? `@${currentUser.username}` : currentUser?.email }}</p>
						<el-tag v-if="currentUser?.is_admin" type="danger">{{ t('administrator') }}</el-tag>
						<el-tag v-else type="success">{{ t('user') }}</el-tag>
					</div>
				</div>

				<div class="actions">
					<el-button type="primary" size="large" @click="navigateTo('/')">
						{{ t('btnHome') }}
					</el-button>
					<el-button
						v-if="currentUser?.is_admin"
						type="warning"
						size="large"
						@click="navigateTo('/admin')"
					>
						{{ t('btnAdminPanel') }}
					</el-button>
					<el-button type="default" size="large" @click="handleLogout">
						{{ t('btnLogout') }}
					</el-button>
				</div>
			</div>

			<!-- Если пользователь не авторизован -->
			<div v-else class="login-form">
				<h1 class="login-title">
					{{ authMode === 'login' ? t('loginTitle') : t('registerTitle') }}
				</h1>
				<p class="login-subtitle">
					{{ authMode === 'login' ? t('chooseLoginMethod') : t('createNewAccount') }}
				</p>

					<el-alert
						v-if="oauthError"
						:title="oauthError"
						type="error"
						:closable="false"
						style="margin-bottom: 24px"
					/>

					<el-alert
						v-if="formError"
						:title="formError"
						type="error"
						:closable="true"
						@close="formError = null"
						style="margin-bottom: 24px"
					/>

					<div class="login-options">
						<!-- Форма входа по Email -->
						<div v-if="authMode === 'login'" class="email-form">
							<el-form @submit.prevent="handleEmailLogin">
					<el-form-item>
						<el-input
							v-model="loginForm.email"
							type="email"
							:placeholder="t('email')"
							size="large"
							:disabled="isLoading"
						>
							<template #prefix>
								<el-icon><Message /></el-icon>
							</template>
						</el-input>
					</el-form-item>
					<el-form-item>
						<el-input
							v-model="loginForm.password"
							type="password"
							:placeholder="t('password')"
							size="large"
							:disabled="isLoading"
							show-password
						>
							<template #prefix>
								<el-icon><Lock /></el-icon>
							</template>
						</el-input>
					</el-form-item>
					<el-button
						type="primary"
						size="large"
						native-type="submit"
						:loading="isLoading"
						class="submit-button"
					>
						{{ t('btnLogin') }}
					</el-button>
							</el-form>

					<div class="form-footer">
						<el-button link type="primary" @click="navigateTo('/forgot-password')">
							{{ t('forgotPassword') }}
						</el-button>
						<el-divider direction="vertical" />
						<el-button link type="primary" @click="switchMode">
							{{ t('noAccount') }}
						</el-button>
					</div>
						</div>

						<!-- Форма регистрации -->
				<div v-else class="email-form">
					<el-form @submit.prevent="handleRegister">
						<el-form-item>
							<el-input
								v-model="registerForm.name"
								:placeholder="t('name')"
								size="large"
								:disabled="isLoading"
							>
								<template #prefix>
									<el-icon><User /></el-icon>
								</template>
							</el-input>
						</el-form-item>
						<el-form-item>
							<el-input
								v-model="registerForm.email"
								type="email"
								:placeholder="t('email')"
								size="large"
								:disabled="isLoading"
							>
								<template #prefix>
									<el-icon><Message /></el-icon>
								</template>
							</el-input>
						</el-form-item>
						<el-form-item>
							<el-input
								v-model="registerForm.password"
								type="password"
								:placeholder="t('passwordPlaceholder')"
								size="large"
								:disabled="isLoading"
								show-password
							>
								<template #prefix>
									<el-icon><Lock /></el-icon>
								</template>
							</el-input>
						</el-form-item>
						<el-form-item>
							<el-input
								v-model="registerForm.confirmPassword"
								type="password"
								:placeholder="t('confirmPasswordPlaceholder')"
								size="large"
								:disabled="isLoading"
								show-password
							>
								<template #prefix>
									<el-icon><Lock /></el-icon>
								</template>
							</el-input>
						</el-form-item>
						<el-button
							type="primary"
							size="large"
							native-type="submit"
							:loading="isLoading"
							class="submit-button"
						>
							{{ t('btnRegister') }}
						</el-button>
					</el-form>

					<div class="form-footer">
						<el-button link type="primary" @click="switchMode">
							{{ t('haveAccount') }}
						</el-button>
					</div>
				</div>

				<div class="divider">
					<span>{{ t('or') }}</span>
				</div>

					<!-- OAuth кнопки -->
					<div class="oauth-buttons">
						<GoogleSignInButton />
						<FacebookLoginButton />
						<TelegramLoginButton />
					</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<style scoped>
.login-page {
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	padding: 20px;
}

.login-container {
	width: 100%;
	max-width: 450px;
}

.login-card {
	background: white;
	border-radius: 12px;
	padding: 40px 32px;
	box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}

/* Login form */
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

.email-form {
	width: 100%;
}

.submit-button {
	width: 100%;
	margin-top: 8px;
}

.form-footer {
	text-align: center;
	margin-top: 16px;
}

.oauth-buttons {
	display: flex;
	flex-direction: column;
	gap: 12px;
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

/* User info */
.user-info {
	text-align: center;
}

.user-info h1 {
	font-size: 28px;
	margin: 0 0 24px 0;
	color: #2c3e50;
}

.user-card {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 16px;
	padding: 24px;
	background: #f8f9fa;
	border-radius: 8px;
	margin-bottom: 24px;
}

.user-avatar {
	width: 80px;
	height: 80px;
	border-radius: 50%;
	border: 3px solid white;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.user-details {
	text-align: center;
}

.user-details h2 {
	font-size: 20px;
	margin: 0 0 4px 0;
	color: #2c3e50;
}

.user-details p {
	font-size: 14px;
	color: #7f8c8d;
	margin: 0 0 8px 0;
}

.actions {
	display: flex;
	flex-direction: column;
	gap: 12px;
}

@media (max-width: 480px) {
	.login-card {
		padding: 32px 24px;
	}

	.login-title {
		font-size: 24px;
	}
}
</style>
