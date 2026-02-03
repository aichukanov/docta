<script setup lang="ts">
import forgotPasswordMessages from '~/i18n/forgot-password';

definePageMeta({
	layout: false,
});

const { t } = useI18n({
	useScope: 'local',
	messages: forgotPasswordMessages.messages,
});

const email = ref('');
const isLoading = ref(false);
const error = ref<string | null>(null);
const success = ref(false);
const resetUrl = ref<string | null>(null);

async function handleSubmit() {
	error.value = null;
	
	if (!email.value) {
		error.value = t('enterEmail');
		return;
	}

	try {
		isLoading.value = true;
		const response = await $fetch('/api/auth/forgot-password', {
			method: 'POST',
			body: { email: email.value },
		});

		success.value = true;
		
		// В development режиме показываем ссылку для тестирования
		if (response.resetUrl) {
			resetUrl.value = response.resetUrl;
		}
	} catch (err: any) {
		console.error('Forgot password error:', err);
		error.value = err.data?.statusMessage || t('errorSending');
	} finally {
		isLoading.value = false;
	}
}
</script>

<template>
	<div class="forgot-password-page">
		<div class="forgot-password-container">
		<el-card class="forgot-password-card">
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
							v-model="email"
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

					<el-button
						type="primary"
						size="large"
						native-type="submit"
						:loading="isLoading"
						class="submit-button"
					>
						{{ t('btnSendLink') }}
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
					:title="t('requestSent')"
					:sub-title="t('requestSentDescription')"
				>
					<template #extra>
						<el-button type="primary" @click="navigateTo('/login')">
							{{ t('btnBackToLoginSuccess') }}
						</el-button>
					</template>
				</el-result>

				<!-- Для разработки показываем ссылку -->
				<div v-if="resetUrl" class="dev-info">
					<el-alert
						:title="t('devMode')"
						type="info"
						:closable="false"
					>
						<p style="margin: 8px 0 0 0; font-size: 14px;">
							{{ t('resetLinkLabel') }}<br>
							<a :href="resetUrl" target="_blank" style="color: var(--el-color-primary)">
								{{ resetUrl }}
							</a>
						</p>
					</el-alert>
				</div>
			</div>
		</el-card>
		</div>
	</div>
</template>

<style scoped>
.forgot-password-page {
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	padding: 20px;
}

.forgot-password-container {
	width: 100%;
	max-width: 500px;
}

.forgot-password-card {
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

.dev-info {
	margin-top: 24px;
}

@media (max-width: 480px) {
	.forgot-password-card {
		padding: 24px 16px;
	}

	.card-header h1 {
		font-size: 20px;
	}
}
</style>
