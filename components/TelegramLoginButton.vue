<script setup lang="ts">
import { onMounted, ref, onUnmounted } from 'vue';

const props = defineProps<{
	size?: 'large' | 'medium' | 'small';
}>();

const widgetContainer = ref<HTMLElement | null>(null);
const isLoading = ref(true);
const widgetFailed = ref(false);
const widgetId = `telegram-widget-${Date.now()}`;

// Получаем bot username из runtime config
const config = useRuntimeConfig();
const botUsername = config.public.telegramBotUsername || 'doctame_login_bot';

// Callback функция для обработки авторизации
const handleTelegramAuth = (user: any) => {
	console.log('[Telegram Auth] User authorized:', user);
	
	// Собираем параметры для редиректа на наш callback
	const params = new URLSearchParams();
	params.set('id', String(user.id));
	params.set('first_name', user.first_name);
	if (user.last_name) params.set('last_name', user.last_name);
	if (user.username) params.set('username', user.username);
	if (user.photo_url) params.set('photo_url', user.photo_url);
	params.set('auth_date', String(user.auth_date));
	params.set('hash', user.hash);
	
	// Редирект на наш API
	window.location.href = `/api/auth/callback/telegram?${params.toString()}`;
};

// Открыть авторизацию через всплывающее окно
const openTelegramAuth = () => {
	const origin = encodeURIComponent(window.location.origin);
	const callbackUrl = encodeURIComponent(`${window.location.origin}/api/auth/callback/telegram`);
	
	// URL для авторизации через Telegram
	const authUrl = `https://oauth.telegram.org/auth?bot_id=${botUsername}&origin=${origin}&embed=0&request_access=write&return_to=${callbackUrl}`;
	
	console.log('[Telegram Auth] Opening auth URL:', authUrl);
	
	// Открываем в том же окне (редирект)
	window.location.href = authUrl;
};

onMounted(() => {
	if (!widgetContainer.value) return;
	
	console.log('[Telegram Widget] Initializing...');
	console.log('[Telegram Widget] Bot username:', botUsername);
	console.log('[Telegram Widget] Current origin:', window.location.origin);
	
	// Регистрируем глобальный callback
	const callbackName = `TelegramLoginCallback_${widgetId.replace(/-/g, '_')}`;
	(window as any)[callbackName] = handleTelegramAuth;
	
	// Создаем script элемент для виджета
	const script = document.createElement('script');
	script.src = 'https://telegram.org/js/telegram-widget.js?22';
	script.async = true;
	script.setAttribute('data-telegram-login', botUsername);
	script.setAttribute('data-size', props.size || 'large');
	script.setAttribute('data-onauth', `${callbackName}(user)`);
	script.setAttribute('data-request-access', 'write');
	
	script.onload = () => {
		console.log('[Telegram Widget] Script loaded successfully');
		isLoading.value = false;
		
		// Проверяем создался ли iframe виджета
		setTimeout(() => {
			const iframe = widgetContainer.value?.querySelector('iframe');
			if (!iframe) {
				console.warn('[Telegram Widget] Widget iframe not created, showing fallback button');
				widgetFailed.value = true;
			}
		}, 2000);
	};
	
	script.onerror = (e) => {
		console.error('[Telegram Widget] Script failed to load:', e);
		isLoading.value = false;
		widgetFailed.value = true;
	};
	
	// Добавляем скрипт в контейнер
	widgetContainer.value.appendChild(script);
	
	// Таймаут на случай если виджет не загрузится
	setTimeout(() => {
		if (isLoading.value) {
			console.warn('[Telegram Widget] Loading timeout, showing fallback');
			isLoading.value = false;
			widgetFailed.value = true;
		}
	}, 5000);
});

onUnmounted(() => {
	// Удаляем глобальный callback
	const callbackName = `TelegramLoginCallback_${widgetId.replace(/-/g, '_')}`;
	delete (window as any)[callbackName];
});
</script>

<template>
	<div class="telegram-login-container">
		<!-- Загрузка -->
		<div v-if="isLoading" class="telegram-loading">
			<IconTelegram :size="20" color="#54a9eb" class="telegram-icon-loading" />
			<span class="loading-text">Загрузка...</span>
		</div>
		
		<!-- Telegram Widget -->
		<div 
			ref="widgetContainer" 
			class="telegram-widget" 
			:class="{ 'is-hidden': isLoading || widgetFailed }"
		>
			<!-- Telegram widget script будет добавлен сюда -->
		</div>
		
		<!-- Fallback кнопка если виджет не загрузился -->
		<button 
			v-if="widgetFailed && !isLoading" 
			class="telegram-fallback-btn"
			@click="openTelegramAuth"
		>
			<svg class="telegram-icon" viewBox="0 0 24 24" fill="currentColor">
				<path d="M11.944 0A12 12 0 0 0 0 12a12 12 0 0 0 12 12 12 12 0 0 0 12-12A12 12 0 0 0 12 0a12 12 0 0 0-.056 0zm4.962 7.224c.1-.002.321.023.465.14a.506.506 0 0 1 .171.325c.016.093.036.306.02.472-.18 1.898-.962 6.502-1.36 8.627-.168.9-.499 1.201-.82 1.23-.696.065-1.225-.46-1.9-.902-1.056-.693-1.653-1.124-2.678-1.8-1.185-.78-.417-1.21.258-1.91.177-.184 3.247-2.977 3.307-3.23.007-.032.014-.15-.056-.212s-.174-.041-.249-.024c-.106.024-1.793 1.14-5.061 3.345-.48.33-.913.49-1.302.48-.428-.008-1.252-.241-1.865-.44-.752-.245-1.349-.374-1.297-.789.027-.216.325-.437.893-.663 3.498-1.524 5.83-2.529 6.998-3.014 3.332-1.386 4.025-1.627 4.476-1.635z"/>
			</svg>
			<span>Войти через Telegram</span>
		</button>
	</div>
</template>

<style scoped>
.telegram-login-container {
	width: 100%;
	display: flex;
	flex-direction: column;
	align-items: center;
	min-height: 40px;
}

.telegram-widget {
	display: flex;
	justify-content: center;
}

.telegram-widget.is-hidden {
	display: none;
}

.telegram-loading {
	display: flex;
	align-items: center;
	gap: 8px;
	height: 40px;
	color: #666;
}

.telegram-icon-loading {
	animation: pulse 1.5s ease-in-out infinite;
}

.loading-text {
	font-size: 14px;
	color: #54a9eb;
}

@keyframes pulse {
	0%, 100% { opacity: 1; transform: scale(1); }
	50% { opacity: 0.5; transform: scale(0.95); }
}

/* Fallback кнопка */
.telegram-fallback-btn {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 10px;
	width: 100%;
	max-width: 280px;
	padding: 12px 24px;
	background: #54a9eb;
	color: white;
	border: none;
	border-radius: 8px;
	font-size: 16px;
	font-weight: 500;
	cursor: pointer;
	transition: background-color 0.2s;
}

.telegram-fallback-btn:hover {
	background: #4a96d1;
}

.telegram-fallback-btn:active {
	background: #3d7db3;
}

.telegram-icon {
	width: 24px;
	height: 24px;
}
</style>
