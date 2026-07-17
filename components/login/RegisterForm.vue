<script setup lang="ts">
import { Message, Lock, User } from '@element-plus/icons-vue';
import loginMessages from '~/i18n/login';
import { ERROR_CODES } from '~/server/utils/api-codes';
import { getRegionalQuery } from '~/common/url-utils';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: loginMessages.messages,
});

const termsLink = computed(() => ({
	name: 'terms',
	query: getRegionalQuery(locale.value),
}));

const privacyLink = computed(() => ({
	name: 'privacy',
	query: getRegionalQuery(locale.value),
}));

defineProps<{
	loading: boolean;
}>();

const emit = defineEmits<{
	submit: [
		payload: {
			email: string;
			password: string;
			name?: string;
			termsAccepted: true;
			analyticsConsent: boolean;
		},
	];
	switchMode: [];
}>();

const form = ref({
	email: '',
	name: '',
	password: '',
	confirmPassword: '',
	termsAccepted: false,
	analyticsConsent: false,
});

const validationError = ref<ERROR_CODES | null>(null);

function handleSubmit() {
	validationError.value = null;

	if (form.value.password !== form.value.confirmPassword) {
		validationError.value = ERROR_CODES.PASSWORDS_DO_NOT_MATCH;
		return;
	}

	if (!form.value.termsAccepted) {
		validationError.value = ERROR_CODES.TERMS_ACCEPTANCE_REQUIRED;
		return;
	}

	emit('submit', {
		email: form.value.email,
		password: form.value.password,
		...(form.value.name.trim() ? { name: form.value.name.trim() } : {}),
		termsAccepted: true,
		analyticsConsent: form.value.analyticsConsent,
	});
}
</script>

<template>
	<div class="email-form">
		<el-form @submit.prevent="handleSubmit">
			<el-form-item>
				<el-input
					v-model="form.email"
					type="email"
					:placeholder="t('email')"
					size="large"
					:disabled="loading"
				>
					<template #prefix>
						<el-icon><Message /></el-icon>
					</template>
				</el-input>
			</el-form-item>
			<el-form-item>
				<el-input
					v-model="form.name"
					:placeholder="t('nameOptional')"
					size="large"
					:disabled="loading"
				>
					<template #prefix>
						<el-icon><User /></el-icon>
					</template>
				</el-input>
			</el-form-item>
			<el-form-item>
				<el-input
					v-model="form.password"
					type="password"
					:placeholder="t('passwordPlaceholder')"
					size="large"
					:disabled="loading"
					show-password
				>
					<template #prefix>
						<el-icon><Lock /></el-icon>
					</template>
				</el-input>
			</el-form-item>
			<el-form-item>
				<el-input
					v-model="form.confirmPassword"
					type="password"
					:placeholder="t('confirmPasswordPlaceholder')"
					size="large"
					:disabled="loading"
					show-password
				>
					<template #prefix>
						<el-icon><Lock /></el-icon>
					</template>
				</el-input>
			</el-form-item>
			<ApiErrorAlert
				:error="validationError"
				closable
				style="margin-bottom: 12px"
				@close="validationError = null"
			/>

			<el-checkbox
				v-model="form.termsAccepted"
				:disabled="loading"
				class="register-checkbox"
			>
				<span class="register-checkbox__text">
					{{ t('registerConsentBefore') }}
					<NuxtLink :to="termsLink" class="register-consent__link" @click.stop>
						{{ t('registerConsentTerms') }}
					</NuxtLink>
					{{ t('registerConsentAnd') }}
					<NuxtLink
						:to="privacyLink"
						class="register-consent__link"
						@click.stop
					>
						{{ t('registerConsentPrivacy') }}
					</NuxtLink>
				</span>
			</el-checkbox>

			<el-checkbox
				v-model="form.analyticsConsent"
				:disabled="loading"
				class="register-checkbox"
			>
				<span class="register-checkbox__text">
					{{ t('registerAnalyticsConsent') }}
				</span>
			</el-checkbox>

			<el-button
				type="primary"
				size="large"
				native-type="submit"
				:loading="loading"
				class="submit-button"
			>
				{{ t('btnRegister') }}
			</el-button>
		</el-form>

		<div class="form-footer">
			<el-button link type="primary" @click="emit('switchMode')">
				{{ t('haveAccount') }}
			</el-button>
		</div>
	</div>
</template>

<style scoped>
.email-form {
	width: 100%;
}

.submit-button {
	width: 100%;
	margin-top: 8px;
}

.register-checkbox {
	display: flex;
	align-items: flex-start;
	height: auto;
	margin: 0 0 10px;
	white-space: normal;
}

.register-checkbox__text {
	font-size: 12px;
	color: var(--color-text-secondary, #8a94a6);
	line-height: 1.5;
}

.register-consent__link {
	color: var(--color-primary, #4a7c59);
	text-decoration: underline;
	text-underline-offset: 2px;

	&:hover {
		color: var(--color-primary-dark, #2d5a3d);
	}
}

.form-footer {
	text-align: center;
	margin-top: 16px;
}
</style>
