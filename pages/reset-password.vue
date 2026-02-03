<script setup lang="ts">
import resetPasswordMessages from '~/i18n/reset-password';

definePageMeta({
	layout: false,
});

const { t } = useI18n({
	useScope: 'local',
	messages: resetPasswordMessages.messages,
});

const route = useRoute();
const router = useRouter();

const token = ref(route.query.token as string || '');
const password = ref('');
const confirmPassword = ref('');
const isLoading = ref(false);
const error = ref<string | null>(null);
const success = ref(false);

// Проверяем наличие токена
onMounted(() => {
	if (!token.value) {
		error.value = t('tokenNotFound');
	}
});

async function handleSubmit() {
	error.value = null;
	
	if (!password.value || !confirmPassword.value) {
		error.value = t('fillAllFields');
		return;
	}

	if (password.value !== confirmPassword.value) {
		error.value = t('passwordsNotMatch');
		return;
	}

	try {
		isLoading.value = true;
		await $fetch('/api/auth/reset-password', {
			method: 'POST',
			body: {
				token: token.value,
				password: password.value,
				confirmPassword: confirmPassword.value,
			},
		});

		success.value = true;
		
		// Через 3 секунды редирект на страницу входа
		setTimeout(() => {
			router.push('/login');
		}, 3000);
	} catch (err: any) {
		console.error('Reset password error:', err);
		error.value = err.data?.statusMessage || t('errorResetting');
	} finally {
		isLoading.value = false;
	}
}
</script>

<template>
	<div class="reset-password-page">
		<div class="reset-password-container">
		<el-card class="reset-password-card">
			<template #header>
				<div class="card-header">
					<h1>{{ t('pageTitle') }}</h1>
				</div>
			</template>

			<div v-if="!success" class="form-section">
				<p class="description">
					{{ t('description') }}
				</p>

				<el-alert
					v-if="error"
					:title="error"
					type="error"
					:closable="true"
					@close="error = null"
					style="margin-bottom: 24px"
				/>

				<el-form @submit.prevent="handleSubmit">
					<el-form-item>
						<el-input
							v-model="password"
							type="password"
							:placeholder="t('newPasswordPlaceholder')"
							size="large"
							:disabled="isLoading || !token"
							show-password
						>
							<template #prefix>
								<el-icon><Lock /></el-icon>
							</template>
						</el-input>
					</el-form-item>

					<el-form-item>
						<el-input
							v-model="confirmPassword"
							type="password"
							:placeholder="t('confirmPasswordPlaceholder')"
							size="large"
							:disabled="isLoading || !token"
							show-password
						>
							<template #prefix>
								<el-icon><Lock /></el-icon>
							</template>
						</el-input>
					</el-form-item>

					<div class="password-requirements">
						<p>{{ t('passwordRequirements') }}</p>
						<ul>
							<li>{{ t('min8Chars') }}</li>
							<li>{{ t('min1Digit') }}</li>
							<li>{{ t('min1Letter') }}</li>
						</ul>
					</div>

					<el-button
						type="primary"
						size="large"
						native-type="submit"
						:loading="isLoading"
						:disabled="!token"
						class="submit-button"
					>
						{{ t('btnSetPassword') }}
					</el-button>
				</el-form>

				<div class="form-footer">
					<el-button link type="primary" @click="navigateTo('/login')">
						{{ t('btnBackToLogin') }}
					</el-button>
				</div>
			</div>

			<div v-else class="success-section">
				<el-result
					icon="success"
					:title="t('successTitle')"
					:sub-title="t('successDescription')"
				>
					<template #extra>
						<el-button type="primary" @click="navigateTo('/login')">
							{{ t('btnLoginNow') }}
						</el-button>
					</template>
				</el-result>
			</div>
		</el-card>
		</div>
	</div>
</template>

<style scoped>
.reset-password-page {
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	padding: 20px;
}

.reset-password-container {
	width: 100%;
	max-width: 500px;
}

.reset-password-card {
	border-radius: 12px;
	box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}

.card-header h1 {
	margin: 0;
	font-size: 24px;
	font-weight: 600;
	color: var(--el-text-color-primary);
	text-align: center;
}

.form-section {
	width: 100%;
}

.description {
	text-align: center;
	color: var(--el-text-color-secondary);
	margin: 0 0 24px 0;
	line-height: 1.6;
}

.password-requirements {
	background: var(--el-fill-color-light);
	padding: 12px 16px;
	border-radius: 6px;
	margin-bottom: 16px;
}

.password-requirements p {
	margin: 0 0 8px 0;
	font-size: 14px;
	font-weight: 500;
	color: var(--el-text-color-primary);
}

.password-requirements ul {
	margin: 0;
	padding-left: 20px;
	font-size: 13px;
	color: var(--el-text-color-secondary);
}

.password-requirements li {
	margin: 4px 0;
}

.submit-button {
	width: 100%;
	margin-top: 8px;
}

.form-footer {
	text-align: center;
	margin-top: 16px;
}

.success-section {
	text-align: center;
}

@media (max-width: 480px) {
	.reset-password-card {
		padding: 24px 16px;
	}

	.card-header h1 {
		font-size: 20px;
	}
}
</style>
