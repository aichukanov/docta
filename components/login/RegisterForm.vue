<script setup lang="ts">
import { Message, Lock, User } from '@element-plus/icons-vue';
import loginMessages from '~/i18n/login';
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
	submit: [payload: { email: string; password: string; name?: string }];
	switchMode: [];
}>();

const form = ref({
	email: '',
	name: '',
	password: '',
	confirmPassword: '',
});

function handleSubmit() {
	emit('submit', {
		email: form.value.email,
		password: form.value.password,
		...(form.value.name.trim() ? { name: form.value.name.trim() } : {}),
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

		<p class="register-consent">
			{{ t('registerConsentBefore') }}
			<NuxtLink :to="termsLink" class="register-consent__link">{{
				t('registerConsentTerms')
			}}</NuxtLink>
			{{ t('registerConsentAnd') }}
			<NuxtLink :to="privacyLink" class="register-consent__link">{{
				t('registerConsentPrivacy')
			}}</NuxtLink>
		</p>

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

.register-consent {
	font-size: 12px;
	color: var(--color-text-secondary, #8a94a6);
	text-align: center;
	margin: 10px 0 0;
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
