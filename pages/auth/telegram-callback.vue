<script setup lang="ts">
/**
 * Клиентская страница-посредник для Telegram OAuth.
 *
 * Telegram при redirect-авторизации отдаёт данные в URL-фрагменте:
 *   /auth/telegram-callback#tgAuthResult=<base64_json>
 *
 * Сервер фрагменты не видит, поэтому эта страница:
 * 1. Извлекает tgAuthResult из хеша
 * 2. Декодирует base64 JSON
 * 3. Перенаправляет на серверный callback с данными как query-параметры
 */

import { getRegionalQuery } from '~/common/url-utils';

definePageMeta({
	layout: 'minimal',
});

const { t, locale } = useI18n({
	useScope: 'local',
});

const profileLink = computed(() => ({
	path: '/profile',
	query: getRegionalQuery(locale.value),
}));

const error = ref<string | null>(null);

onMounted(() => {
	try {
		const hash = window.location.hash;
		const search = window.location.search;

		console.log('[TG Callback] hash:', hash);
		console.log('[TG Callback] search:', search);
		console.log('[TG Callback] full URL:', window.location.href);

		// Пробуем извлечь из фрагмента (#tgAuthResult=base64)
		if (hash) {
			const match = hash.match(/tgAuthResult=([^&]+)/);
			if (match) {
				const decoded = JSON.parse(atob(match[1]));
				console.log('[TG Callback] decoded tgAuthResult:', decoded);
				redirectToCallback(decoded);
				return;
			}
		}

		// Пробуем из query-параметров (на случай если Telegram отдал так)
		const params = new URLSearchParams(search);
		if (params.get('id') && params.get('hash')) {
			const callbackUrl = `/api/auth/callback/telegram?${params.toString()}`;
			console.log('[TG Callback] redirecting with query params:', callbackUrl);
			window.location.href = callbackUrl;
			return;
		}

		console.error('[TG Callback] No tgAuthResult in hash and no id/hash in query');
		error.value = t('errorNoData');
	} catch (err) {
		console.error('[TG Callback] Error:', err);
		error.value = t('errorProcessing');
	}
});

function redirectToCallback(data: Record<string, unknown>) {
	const params = new URLSearchParams();
	for (const [key, value] of Object.entries(data)) {
		if (value !== undefined && value !== null) {
			params.set(key, String(value));
		}
	}
	window.location.href = `/api/auth/callback/telegram?${params.toString()}`;
}
</script>

<template>
	<div class="telegram-callback">
		<div v-if="error" class="telegram-callback__error">
			<p>{{ error }}</p>
			<NuxtLink :to="profileLink">{{ t('backToProfile') }}</NuxtLink>
		</div>
		<div v-else class="telegram-callback__loading">
			<div class="telegram-callback__spinner"></div>
			<p>{{ t('loading') }}</p>
		</div>
	</div>
</template>

<i18n lang="json">
{
	"en": {
		"loading": "Signing in with Telegram...",
		"errorNoData": "Failed to get data from Telegram",
		"errorProcessing": "Error processing Telegram response",
		"backToProfile": "Back to profile"
	},
	"ru": {
		"loading": "Авторизация через Telegram...",
		"errorNoData": "Не удалось получить данные от Telegram",
		"errorProcessing": "Ошибка при обработке ответа Telegram",
		"backToProfile": "Назад в профиль"
	},
	"sr": {
		"loading": "Prijavljivanje preko Telegrama...",
		"errorNoData": "Nije moguće dobiti podatke od Telegrama",
		"errorProcessing": "Greška pri obradi odgovora Telegrama",
		"backToProfile": "Nazad na profil"
	},
	"sr-cyrl": {
		"loading": "Пријављивање преко Телеграма...",
		"errorNoData": "Није могуће добити податке од Телеграма",
		"errorProcessing": "Грешка при обради одговора Телеграма",
		"backToProfile": "Назад на профил"
	},
	"de": {
		"loading": "Anmeldung über Telegram...",
		"errorNoData": "Daten von Telegram konnten nicht abgerufen werden",
		"errorProcessing": "Fehler bei der Verarbeitung der Telegram-Antwort",
		"backToProfile": "Zurück zum Profil"
	},
	"tr": {
		"loading": "Telegram ile giriş yapılıyor...",
		"errorNoData": "Telegram'dan veri alınamadı",
		"errorProcessing": "Telegram yanıtı işlenirken hata oluştu",
		"backToProfile": "Profile geri dön"
	}
}
</i18n>

<style scoped>
.telegram-callback {
	display: flex;
	align-items: center;
	justify-content: center;
	min-height: 200px;
	text-align: center;
	color: var(--color-text-secondary, #475569);
	font-size: 15px;
}

.telegram-callback__error {
	display: flex;
	flex-direction: column;
	gap: 12px;
}

.telegram-callback__error a {
	color: var(--color-primary, #4f46e5);
}

.telegram-callback__loading {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 16px;
}

.telegram-callback__spinner {
	width: 32px;
	height: 32px;
	border: 3px solid var(--color-border-secondary, #e5e7eb);
	border-top-color: var(--color-primary, #4f46e5);
	border-radius: 50%;
	animation: spin 0.8s linear infinite;
}

@keyframes spin {
	to { transform: rotate(360deg); }
}
</style>
