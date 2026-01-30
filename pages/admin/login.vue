<script setup lang="ts">
definePageMeta({
	layout: false,
});

const form = reactive({
	email: '',
	password: '',
});

const loading = ref(false);
const errorMessage = ref('');

async function handleLogin() {
	if (!form.email || !form.password) {
		errorMessage.value = 'Заполните все поля';
		return;
	}

	loading.value = true;
	errorMessage.value = '';

	try {
		const { data, error } = await useFetch('/api/admin/auth/login', {
			method: 'POST',
			body: {
				email: form.email,
				password: form.password,
			},
		});

		if (error.value) {
			errorMessage.value = 'Неверный email или пароль';
		} else if (data.value?.success) {
			// Успешный вход - перенаправляем на админку
			navigateTo('/admin');
		}
	} catch (err) {
		console.error('Login error:', err);
		errorMessage.value = 'Произошла ошибка при входе';
	} finally {
		loading.value = false;
	}
}
</script>

<template>
	<div class="admin-login">
		<div class="login-container">
			<div class="login-card">
				<h1 class="login-title">Вход для администраторов</h1>
				<p class="login-subtitle">docta.me</p>

				<el-form
					@submit.prevent="handleLogin"
					:model="form"
					class="login-form"
				>
					<el-form-item>
						<el-input
							v-model="form.email"
							type="email"
							placeholder="Email"
							size="large"
							:prefix-icon="'Message'"
							required
						/>
					</el-form-item>

					<el-form-item>
						<el-input
							v-model="form.password"
							type="password"
							placeholder="Пароль"
							size="large"
							:prefix-icon="'Lock'"
							show-password
							required
						/>
					</el-form-item>

					<el-alert
						v-if="errorMessage"
						:title="errorMessage"
						type="error"
						:closable="false"
						class="error-alert"
					/>

					<el-button
						type="primary"
						native-type="submit"
						size="large"
						:loading="loading"
						class="login-button"
					>
						Войти
					</el-button>
				</el-form>

				<div class="login-footer">
					<p class="info-text">
						Доступ только для администраторов платформы
					</p>
				</div>
			</div>
		</div>
	</div>
</template>

<style scoped>
.admin-login {
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	padding: 20px;
}

.login-container {
	width: 100%;
	max-width: 400px;
}

.login-card {
	background: white;
	border-radius: 12px;
	padding: 40px 32px;
	box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}

.login-title {
	font-size: 24px;
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
	font-weight: 500;
}

.login-form {
	margin-bottom: 24px;
}

.error-alert {
	margin-bottom: 16px;
}

.login-button {
	width: 100%;
	margin-top: 8px;
}

.login-footer {
	text-align: center;
	padding-top: 24px;
	border-top: 1px solid #ecf0f1;
}

.info-text {
	font-size: 13px;
	color: #95a5a6;
	margin: 0;
}

@media (max-width: 480px) {
	.login-card {
		padding: 32px 24px;
	}

	.login-title {
		font-size: 20px;
	}
}
</style>
