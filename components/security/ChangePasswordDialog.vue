<script setup lang="ts">
import securityMessages from '~/i18n/security-section';
import { ERROR_CODES } from '~/server/utils/api-codes';

const props = defineProps<{
	modelValue: boolean;
	userHasPassword: boolean;
	userEmail?: string | null;
}>();

const emit = defineEmits<{
	'update:modelValue': [value: boolean];
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: securityMessages.messages,
});

const show = computed({
	get: () => props.modelValue,
	set: (value) => emit('update:modelValue', value),
});

const isLoading = ref(false);
const isForgotPasswordLoading = ref(false);
const forgotPasswordSent = ref(false);
const passwordErrors = ref<ERROR_CODES[]>([]);
const passwordForm = ref({
	currentPassword: '',
	newPassword: '',
	confirmPassword: '',
});

watch(
	() => props.modelValue,
	(val) => {
		if (val) {
			forgotPasswordSent.value = false;
			passwordErrors.value = [];
			passwordForm.value = { currentPassword: '', newPassword: '', confirmPassword: '' };
		}
	},
);

async function handleChangePassword() {
	passwordErrors.value = [];

	if (!passwordForm.value.newPassword || !passwordForm.value.confirmPassword) {
		passwordErrors.value = [ERROR_CODES.ALL_FIELDS_REQUIRED];
		return;
	}

	if (passwordForm.value.newPassword !== passwordForm.value.confirmPassword) {
		passwordErrors.value = [ERROR_CODES.PASSWORDS_DO_NOT_MATCH];
		return;
	}

	try {
		isLoading.value = true;
		await $fetch('/api/auth/change-password', {
			method: 'POST',
			body: {
				currentPassword: passwordForm.value.currentPassword,
				newPassword: passwordForm.value.newPassword,
				confirmPassword: passwordForm.value.confirmPassword,
			},
		});
		ElMessage.success(t('passwordChanged'));
		show.value = false;
	} catch (error: any) {
		const details = error.data?.data?.details;
		if (Array.isArray(details) && details.length) {
			passwordErrors.value = details as ERROR_CODES[];
		} else {
			passwordErrors.value = [
				(error.data?.statusMessage as ERROR_CODES) ||
					ERROR_CODES.ERROR_CHANGING_PASSWORD,
			];
		}
	} finally {
		isLoading.value = false;
	}
}

async function handleForgotPassword() {
	if (!props.userEmail) return;

	try {
		isForgotPasswordLoading.value = true;
		await $fetch('/api/auth/forgot-password', {
			method: 'POST',
			body: { email: props.userEmail },
		});
		forgotPasswordSent.value = true;
	} catch {
		ElMessage.error(t('forgotPasswordError'));
	} finally {
		isForgotPasswordLoading.value = false;
	}
}
</script>

<template>
	<el-dialog
		v-model="show"
		:title="userHasPassword ? t('changePasswordTitle') : t('setPasswordTitle')"
		width="460px"
		class="profile-dialog"
	>
		<template v-if="passwordErrors.length">
			<ApiErrorAlert
				v-for="(err, i) in passwordErrors"
				:key="err"
				:error="err"
				:closable="i === 0"
				:style="
					i === 0
						? 'margin-bottom: 4px'
						: i === passwordErrors.length - 1
							? 'margin-bottom: 20px'
							: 'margin-bottom: 4px'
				"
				@close="passwordErrors = []"
			/>
		</template>

		<template v-if="forgotPasswordSent">
			<el-result
				icon="success"
				:title="t('forgotPasswordSentTitle')"
				:sub-title="t('forgotPasswordSentSubtitle')"
			/>
		</template>

		<template v-else>
			<el-form @submit.prevent="handleChangePassword" label-position="top">
				<el-form-item v-if="userHasPassword" :label="t('currentPassword')">
					<el-input
						v-model="passwordForm.currentPassword"
						type="password"
						:placeholder="t('currentPasswordPlaceholder')"
						:disabled="isLoading"
						show-password
					/>
					<div class="password-dialog__forgot">
						<el-button
							link
							type="primary"
							size="small"
							:loading="isForgotPasswordLoading"
							@click="handleForgotPassword"
						>
							{{ t('forgotPassword') }}
						</el-button>
					</div>
				</el-form-item>
				<el-form-item :label="t('newPassword')">
					<el-input
						v-model="passwordForm.newPassword"
						type="password"
						:placeholder="t('newPasswordPlaceholder')"
						:disabled="isLoading"
						show-password
					/>
				</el-form-item>
				<el-form-item :label="t('confirmPassword')">
					<el-input
						v-model="passwordForm.confirmPassword"
						type="password"
						:placeholder="t('confirmPasswordPlaceholder')"
						:disabled="isLoading"
						show-password
					/>
				</el-form-item>
			</el-form>
		</template>

		<template #footer>
			<div class="profile-dialog__footer">
				<el-button :disabled="isLoading" @click="show = false">
					{{ t('cancel') }}
				</el-button>
				<el-button
					v-if="!forgotPasswordSent"
					type="primary"
					:loading="isLoading"
					@click="handleChangePassword"
				>
					{{ t('save') }}
				</el-button>
			</div>
		</template>
	</el-dialog>
</template>

<style scoped>
.password-dialog__forgot {
	margin-top: var(--spacing-xs);
	text-align: right;
}
</style>
