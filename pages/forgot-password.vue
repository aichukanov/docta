<script setup lang="ts">
import forgotPasswordMessages from '~/i18n/forgot-password';

definePageMeta({
	layout: 'minimal',
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
	<div>
			<h1 class="page-title">{{ t('pageTitle') }}</h1>

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
	</div>
</template>

<style scoped>
.page-title {
	margin: 0 0 8px 0;
	font-size: 24px;
	font-weight: 600;
	color: #2c3e50;
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
	.page-title {
		font-size: 20px;
	}
}
</style>
