<script setup lang="ts">
definePageMeta({
	layout: false,
});

// Проверяем авторизован ли пользователь
const { data: authData } = await useFetch('/api/admin/auth/me');
const isAuthenticated = computed(() => authData.value?.authenticated);
const currentUser = computed(() => authData.value?.user);

// Проверяем ошибки OAuth
const route = useRoute();
const oauthError = computed(() => {
	const error = route.query.error as string;
	if (!error) return null;

	const errorMessages: Record<string, string> = {
		oauth_failed: 'Не удалось выполнить вход через Google',
		no_code: 'Код авторизации не получен',
		state_mismatch: 'Ошибка безопасности (state mismatch)',
		email_not_verified: 'Email не подтвержден в Google',
		oauth_callback_failed: 'Ошибка при обработке ответа от Google',
	};

	return errorMessages[error] || 'Произошла ошибка при авторизации';
});

async function handleLogout() {
	try {
		await $fetch('/api/admin/auth/logout', { method: 'POST' });
		// Перезагружаем страницу
		window.location.reload();
	} catch (error) {
		console.error('Logout error:', error);
	}
}
</script>

<template>
	<div class="login-page">
		<div class="login-container">
			<div class="login-card">
				<!-- Если пользователь авторизован -->
				<div v-if="isAuthenticated" class="user-info">
					<h1>Добро пожаловать! 👋</h1>

					<div class="user-card">
						<img
							v-if="currentUser?.photo_url"
							:src="currentUser.photo_url"
							:alt="currentUser.name"
							class="user-avatar"
						/>
						<div class="user-details">
							<h2>{{ currentUser?.name }}</h2>
							<p>{{ currentUser?.email }}</p>
							<el-tag v-if="currentUser?.is_admin" type="danger"
								>Администратор</el-tag
							>
							<el-tag v-else type="success">Пользователь</el-tag>
						</div>
					</div>

					<div class="actions">
						<el-button type="primary" size="large" @click="navigateTo('/')">
							На главную
						</el-button>
						<el-button
							v-if="currentUser?.is_admin"
							type="warning"
							size="large"
							@click="navigateTo('/admin')"
						>
							Админ-панель
						</el-button>
						<el-button type="default" size="large" @click="handleLogout">
							Выйти
						</el-button>
					</div>
				</div>

				<!-- Если пользователь не авторизован -->
				<div v-else class="login-form">
					<h1 class="login-title">Вход в docta.me</h1>
					<p class="login-subtitle">Войдите с помощью Google</p>

					<el-alert
						v-if="oauthError"
						:title="oauthError"
						type="error"
						:closable="false"
						style="margin-bottom: 24px"
					/>

					<div class="login-options">
						<GoogleSignInButton />
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<style scoped>
.login-page {
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	padding: 20px;
}

.login-container {
	width: 100%;
	max-width: 450px;
}

.login-card {
	background: white;
	border-radius: 12px;
	padding: 40px 32px;
	box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}

/* Login form */
.login-title {
	font-size: 28px;
	font-weight: 600;
	text-align: center;
	margin: 0 0 8px 0;
	color: #2c3e50;
}

.login-subtitle {
	font-size: 16px;
	text-align: center;
	margin: 0 0 32px 0;
	color: #7f8c8d;
}

.login-options {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.divider {
	display: flex;
	align-items: center;
	text-align: center;
	color: #95a5a6;
	margin: 8px 0;
}

.divider::before,
.divider::after {
	content: '';
	flex: 1;
	border-bottom: 1px solid #ecf0f1;
}

.divider span {
	padding: 0 12px;
	font-size: 14px;
}

.divider {
	display: flex;
	align-items: center;
	text-align: center;
	color: #95a5a6;
	margin: 8px 0;
}

.divider::before,
.divider::after {
	content: '';
	flex: 1;
	border-bottom: 1px solid #ecf0f1;
}

.divider span {
	padding: 0 12px;
	font-size: 14px;
}

/* User info */
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
}

@media (max-width: 480px) {
	.login-card {
		padding: 32px 24px;
	}

	.login-title {
		font-size: 24px;
	}
}
</style>
