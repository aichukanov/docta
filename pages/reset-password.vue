<script setup lang="ts">
import { Lock } from '@element-plus/icons-vue';
import resetPasswordMessages from '~/i18n/reset-password';
import { ERROR_CODES } from '~/server/utils/api-codes';
import { getRegionalQuery } from '~/common/url-utils';

definePageMeta({
	layout: 'minimal',
});

const { t, locale } = useI18n({
	useScope: 'local',
	messages: resetPasswordMessages.messages,
});
const { t: $t } = useI18n({ useScope: 'global' });

useSeoMeta({
	title: () => t('pageTitle') + ' | ' + $t('ApplicationName'),
});

const route = useRoute();
const router = useRouter();

const token = ref((route.query.token as string) || '');
const password = ref('');
const confirmPassword = ref('');
const isLoading = ref(false);
const error = ref<ERROR_CODES | null>(null);
const success = ref(false);

if (!token.value) {
	error.value = ERROR_CODES.TOKEN_NOT_FOUND;
}

async function handleSubmit() {
	error.value = null;

	if (!password.value || !confirmPassword.value) {
		error.value = ERROR_CODES.ALL_FIELDS_REQUIRED;
		return;
	}

	if (password.value !== confirmPassword.value) {
		error.value = ERROR_CODES.PASSWORDS_DO_NOT_MATCH;
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
			router.push(loginPageLink.value);
		}, 3000);
	} catch (err: any) {
		console.error('Reset password error:', err);
		error.value =
			(err.data?.statusMessage as ERROR_CODES) ||
			ERROR_CODES.ERROR_RESETTING_PASSWORD;
	} finally {
		isLoading.value = false;
	}
}

const loginPageLink = computed(() => ({
	name: 'login',
	query: getRegionalQuery(locale.value),
}));
</script>

<template>
	<div>
		<h1 class="page-title">{{ t('pageTitle') }}</h1>

		<div v-if="!success" class="form-section">
			<p class="description">
				{{ t('description') }}
			</p>

			<ApiErrorAlert :error="error" style="margin-bottom: 24px" />

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
				<el-button link type="primary" @click="navigateTo(loginPageLink)">
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
					<el-button type="primary" @click="navigateTo(loginPageLink)">
						{{ t('btnLoginNow') }}
					</el-button>
				</template>
			</el-result>
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
	.page-title {
		font-size: 20px;
	}
}
</style>
