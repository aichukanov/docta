<script setup lang="ts">
/**
 * Клиентская страница-посредник для Telegram OAuth.
 *
 * Telegram OAuth (oauth.telegram.org) доставляет данные тремя способами:
 * 1. postMessage — когда задан origin, Telegram шлёт {event:'auth_result', result:{...}}
 * 2. URL-фрагмент — #tgAuthResult=<base64_json>
 * 3. Query-параметры — ?id=...&hash=... (fallback)
 *
 * Эта страница слушает все три и перенаправляет на серверный callback.
 */

import { getRegionalQuery } from '~/common/url-utils';

definePageMeta({
	layout: 'minimal',
});

const { t, locale } = useI18n({
	useScope: 'local',
});
const { t: $t } = useI18n({ useScope: 'global' });

useSeoMeta({
	title: () => t('pageTitle') + ' | ' + $t('ApplicationName'),
});

const profileLink = computed(() => ({
	path: '/profile',
	query: getRegionalQuery(locale.value),
}));

const error = ref<string | null>(null);
let redirected = false;

function redirectToCallback(data: Record<string, unknown>) {
	if (redirected) return;
	redirected = true;

	const params = new URLSearchParams();
	for (const [key, value] of Object.entries(data)) {
		if (value !== undefined && value !== null) {
			params.set(key, String(value));
		}
	}
	window.location.href = `/api/auth/callback/telegram?${params.toString()}`;
}

function handleTelegramMessage(evt: MessageEvent) {
	if (evt.origin !== 'https://oauth.telegram.org') return;

	let parsed: any;
	if (typeof evt.data === 'string') {
		try {
			parsed = JSON.parse(evt.data);
		} catch {
			return;
		}
	} else {
		parsed = evt.data;
	}

	console.log('[TG Callback] postMessage from Telegram:', parsed);

	if (parsed?.event === 'auth_result' && parsed.result) {
		redirectToCallback(parsed.result);
	}
}

onMounted(() => {
	window.addEventListener('message', handleTelegramMessage);

	try {
		const hash = window.location.hash;
		const search = window.location.search;

		console.log('[TG Callback] hash:', hash);
		console.log('[TG Callback] search:', search);
		console.log('[TG Callback] full URL:', window.location.href);

		// Способ 2: фрагмент (#tgAuthResult=base64)
		if (hash) {
			const match = hash.match(/tgAuthResult=([^&]+)/);
			if (match) {
				const decoded = JSON.parse(atob(match[1]));
				console.log('[TG Callback] decoded tgAuthResult:', decoded);
				redirectToCallback(decoded);
				return;
			}
		}

		// Способ 3: query-параметры
		const params = new URLSearchParams(search);
		if (params.get('id') && params.get('hash')) {
			console.log('[TG Callback] redirecting with query params');
			redirectToCallback(Object.fromEntries(params));
			return;
		}

		// Даём время на получение postMessage (Telegram может слать с задержкой)
		console.log('[TG Callback] Waiting for postMessage from Telegram...');
		setTimeout(() => {
			if (!redirected) {
				console.error('[TG Callback] Timeout: no data received from Telegram');
				error.value = t('errorNoData');
			}
		}, 5000);
	} catch (err) {
		console.error('[TG Callback] Error:', err);
		error.value = t('errorProcessing');
	}
});

onUnmounted(() => {
	window.removeEventListener('message', handleTelegramMessage);
});
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
		"pageTitle": "Telegram Authorization",
		"loading": "Signing in with Telegram...",
		"errorNoData": "Failed to get data from Telegram",
		"errorProcessing": "Error processing Telegram response",
		"backToProfile": "Back to profile"
	},
	"ru": {
		"pageTitle": "Авторизация через Telegram",
		"loading": "Авторизация через Telegram...",
		"errorNoData": "Не удалось получить данные от Telegram",
		"errorProcessing": "Ошибка при обработке ответа Telegram",
		"backToProfile": "Назад в профиль"
	},
	"sr": {
		"pageTitle": "Telegram autorizacija",
		"loading": "Prijavljivanje preko Telegrama...",
		"errorNoData": "Nije moguće dobiti podatke od Telegrama",
		"errorProcessing": "Greška pri obradi odgovora Telegrama",
		"backToProfile": "Nazad na profil"
	},
	"sr-cyrl": {
		"pageTitle": "Телеграм ауторизација",
		"loading": "Пријављивање преко Телеграма...",
		"errorNoData": "Није могуће добити податке од Телеграма",
		"errorProcessing": "Грешка при обради одговора Телеграма",
		"backToProfile": "Назад на профил"
	},
	"de": {
		"pageTitle": "Telegram-Autorisierung",
		"loading": "Anmeldung über Telegram...",
		"errorNoData": "Daten von Telegram konnten nicht abgerufen werden",
		"errorProcessing": "Fehler bei der Verarbeitung der Telegram-Antwort",
		"backToProfile": "Zurück zum Profil"
	},
	"tr": {
		"pageTitle": "Telegram Yetkilendirmesi",
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
