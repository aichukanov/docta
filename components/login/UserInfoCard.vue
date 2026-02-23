<script setup lang="ts">
import type { User } from '~/server/utils/session';
import loginMessages from '~/i18n/login';

const { t } = useI18n({
	useScope: 'local',
	messages: loginMessages.messages,
});

defineProps<{
	user: User;
	regionalQuery: Record<string, string>;
}>();

const emit = defineEmits<{
	logout: [];
}>();
</script>

<template>
	<div class="user-info">
		<h1>{{ t('welcomeBack') }}</h1>

		<div class="user-card">
			<img
				v-if="user.photo_url"
				:src="user.photo_url"
				:alt="user.name"
				class="user-avatar"
			/>
			<div class="user-details">
				<h2>{{ user.name }}</h2>
				<p>{{ user.username ? `@${user.username}` : user.email }}</p>
				<el-tag v-if="user.is_admin" type="danger">
					{{ t('administrator') }}
				</el-tag>
				<el-tag v-else type="success">{{ t('user') }}</el-tag>
			</div>
		</div>

		<div class="actions">
			<el-button
				type="primary"
				size="large"
				@click="navigateTo({ path: '/', query: regionalQuery })"
			>
				{{ t('btnHome') }}
			</el-button>
			<el-button type="default" size="large" @click="emit('logout')">
				{{ t('btnLogout') }}
			</el-button>
		</div>
	</div>
</template>

<style scoped>
.user-info {
	text-align: center;
}

.user-info h1 {
	font-size: 28px;
	margin: 0 0 24px 0;
	color: #2c3e50;
}

.user-card {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 16px;
	padding: 24px;
	background: #f8f9fa;
	border-radius: 8px;
	margin-bottom: 24px;
}

.user-avatar {
	width: 80px;
	height: 80px;
	border-radius: 50%;
	border: 3px solid white;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.user-details {
	text-align: center;
}

.user-details h2 {
	font-size: 20px;
	margin: 0 0 4px 0;
	color: #2c3e50;
}

.user-details p {
	font-size: 14px;
	color: #7f8c8d;
	margin: 0 0 8px 0;
}

.actions {
	display: flex;
	flex-direction: column;
	gap: 12px;

	.el-button {
		margin-left: 0;
	}
}
</style>
