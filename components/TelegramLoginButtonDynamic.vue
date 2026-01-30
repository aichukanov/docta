<script setup lang="ts">
import { onMounted, ref } from 'vue';

const props = defineProps<{
	size?: 'large' | 'medium' | 'small';
}>();

const buttonSize = props.size || 'large';
const loading = ref(false);

// Определяем bot username в зависимости от окружения
const isDev = process.dev;
const botUsername = isDev ? 'docta_localhost_login_bot' : 'doctame_login_bot';

// Telegram Login Widget загружается асинхронно
onMounted(() => {
	// Загружаем скрипт Telegram Login Widget
	if (!document.getElementById('telegram-login-script')) {
		const script = document.createElement('script');
		script.id = 'telegram-login-script';
		script.src = 'https://telegram.org/js/telegram-widget.js?22';
		script.async = true;
		script.setAttribute('data-telegram-login', botUsername);
		script.setAttribute('data-size', 'large');
		script.setAttribute('data-auth-url', '/api/auth/callback/telegram');
		script.setAttribute('data-request-access', 'write');

		const wrapper = document.querySelector('.telegram-login-wrapper');
		if (wrapper) {
			wrapper.appendChild(script);
		}
	}
});
</script>

<template>
	<div class="telegram-login-wrapper">
		<!-- Telegram Login Widget загружается динамически -->
	</div>
</template>

<style scoped>
.telegram-login-wrapper {
	width: 100%;
	display: flex;
	justify-content: center;
	min-height: 40px;
}

/* Стилизация под наш дизайн */
:deep(iframe) {
	width: 100% !important;
	max-width: 100% !important;
}
</style>
