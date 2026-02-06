<script setup lang="ts">
import { Loading } from '@element-plus/icons-vue';
import confirmEmailChangeMessages from '~/i18n/confirm-email-change';

definePageMeta({
	layout: 'minimal',
});

const { t } = useI18n({
	useScope: 'local',
	messages: confirmEmailChangeMessages.messages,
});

const route = useRoute();
const router = useRouter();

const token = ref((route.query.token as string) || '');
const isLoading = ref(true);
const success = ref(false);
const error = ref<string | null>(null);

onMounted(async () => {
	if (!token.value) {
		error.value = t('tokenNotFound');
		isLoading.value = false;
		return;
	}

	try {
		await $fetch(`/api/auth/confirm-email-change?token=${token.value}`);
		success.value = true;

		// Через 3 секунды редирект
		setTimeout(() => {
			router.push('/profile');
		}, 3000);
	} catch (err: any) {
		console.error('Email change confirmation error:', err);
		error.value = err.data?.statusMessage || t('errorChanging');
	} finally {
		isLoading.value = false;
	}
});
</script>

<template>
	<div>
		<h1 class="page-title">{{ t('pageTitle') }}</h1>

		<!-- Загрузка -->
		<div v-if="isLoading" class="loading-section">
			<el-icon class="is-loading" :size="40" color="#667eea">
				<Loading />
			</el-icon>
			<p>{{ t('processing') }}</p>
		</div>

		<!-- Успех -->
		<div v-else-if="success" class="success-section">
			<el-result
				icon="success"
				:title="t('successTitle')"
				:sub-title="t('successDescription')"
			>
				<template #extra>
					<el-button type="primary" @click="navigateTo('/profile')">
						{{ t('btnGoToProfile') }}
					</el-button>
				</template>
			</el-result>
		</div>

		<!-- Ошибка -->
		<div v-else-if="error" class="error-section">
			<el-result icon="error" :title="t('errorTitle')" :sub-title="error">
				<template #extra>
					<el-button type="primary" @click="navigateTo('/profile')">
						{{ t('btnGoToProfile') }}
					</el-button>
					<el-button @click="navigateTo('/login')">
						{{ t('btnHome') }}
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

.loading-section {
	text-align: center;
	padding: 40px 20px;
}

.loading-section p {
	margin-top: 20px;
	color: var(--el-text-color-secondary);
}

.success-section,
.error-section {
	padding: 20px 0;
}

@media (max-width: 480px) {
	.page-title {
		font-size: 20px;
	}
}
</style>
