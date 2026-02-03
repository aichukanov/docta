<script setup lang="ts">
import loginMessages from '~/i18n/login';

const { t } = useI18n({
	useScope: 'local',
	messages: loginMessages.messages,
});

const loading = ref(false);

function signInWithFacebook() {
	loading.value = true;
	// Переходим на наш OAuth endpoint
	window.location.href = '/api/auth/facebook';
}
</script>

<template>
	<el-button
		type="primary"
		size="large"
		:loading="loading"
		@click="signInWithFacebook"
		class="facebook-button"
	>
		<template #icon>
			<IconFacebook :size="18" />
		</template>
		<span style="margin-left: 8px">{{ t('btnFacebook') }}</span>
	</el-button>
</template>

<style scoped>
.facebook-button {
	width: 100%;
	background: #1877f2;
	color: white;
	border: none;
	font-weight: 500;
}

.facebook-button:hover {
	background: #166fe5;
	border-color: #166fe5;
	color: white;
}

.facebook-button:focus {
	background: #1877f2;
	border-color: #1877f2;
	color: white;
}
</style>
