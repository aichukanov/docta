<script setup lang="ts">
import { Message, Lock } from '@element-plus/icons-vue';
import loginMessages from '~/i18n/login';

const { t } = useI18n({
	useScope: 'local',
	messages: loginMessages.messages,
});

defineProps<{
	loading: boolean;
	regionalQuery: Record<string, string>;
}>();

const emit = defineEmits<{
	submit: [payload: { email: string; password: string }];
	switchMode: [];
}>();

const form = ref({
	email: '',
	password: '',
});

function handleSubmit() {
	emit('submit', { email: form.value.email, password: form.value.password });
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
					v-model="form.password"
					type="password"
					:placeholder="t('password')"
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
				{{ t('btnLogin') }}
			</el-button>
		</el-form>

		<div class="form-footer">
			<el-button
				link
				type="primary"
				@click="navigateTo({ path: '/forgot-password', query: regionalQuery })"
			>
				{{ t('forgotPassword') }}
			</el-button>
			<el-divider direction="vertical" />
			<el-button link type="primary" @click="emit('switchMode')">
				{{ t('noAccount') }}
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

.form-footer {
	text-align: center;
	margin-top: 16px;
}
</style>
