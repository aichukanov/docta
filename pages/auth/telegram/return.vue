<script setup lang="ts">
import { KitIconSpinner } from '@ach/ui-kit/icons';
/**
 * Технический экран возврата из Telegram (top-level redirect-поток).
 *
 * Telegram возвращает браузер на этот адрес и кладёт данные авторизации
 * в hash-фрагмент: `#tgAuthResult=<base64url(JSON)>`. Фрагмент до сервера
 * не доходит, поэтому распаковываем его здесь и передаём поля в серверный
 * callback обычными query-параметрами — там они проверяются по HMAC.
 *
 * Формат фрагмента повторяет `haveTgAuthResult()` из telegram-widget.js.
 * Часть встроенных браузеров переносит его в query-строку, поэтому query
 * тоже разбираем.
 */
import { ERROR_CODES } from '~/server/utils/api-codes';

definePageMeta({
	layout: false,
});

useSeoMeta({
	robots: 'noindex, nofollow',
});

const CALLBACK_URL = '/api/auth/callback/telegram';
const TG_AUTH_RESULT_RE = /[#?&]tgAuthResult=([A-Za-z0-9\-_=]*)/;

/**
 * Поля, которые Telegram присылает в авторизационных данных. Нужны только для
 * разбора query-строки: подпись считается по всем переданным полям, поэтому
 * любой посторонний параметр в URL (utm-метки, lang после редиректа) её сломает.
 * В hash-фрагменте посторонних параметров быть не может — там ровно то, что
 * подписал Telegram, поэтому его поля не фильтруем и новое поле не потеряем.
 */
const TELEGRAM_QUERY_FIELDS = new Set([
	'id',
	'first_name',
	'last_name',
	'username',
	'photo_url',
	'auth_date',
	'hash',
]);

function decodeAuthResult(encoded: string): Record<string, unknown> | null {
	try {
		let base64 = encoded.replace(/-/g, '+').replace(/_/g, '/');
		const pad = base64.length % 4;
		if (pad > 1) {
			base64 += '='.repeat(4 - pad);
		}

		// atob отдаёт байты, а не символы: имена с кириллицей нужно раскодировать
		// как UTF-8, иначе подпись не сойдётся
		const bytes = Uint8Array.from(atob(base64), (char) => char.charCodeAt(0));
		const parsed = JSON.parse(new TextDecoder().decode(bytes));

		return parsed && typeof parsed === 'object' ? parsed : null;
	} catch {
		return null;
	}
}

function collectAuthFields(): URLSearchParams | null {
	const params = new URLSearchParams();

	const match = window.location.hash.match(TG_AUTH_RESULT_RE);
	if (match?.[1]) {
		const data = decodeAuthResult(match[1]);
		if (!data) return null;

		for (const [key, value] of Object.entries(data)) {
			if (value !== null && value !== undefined) {
				params.set(key, String(value));
			}
		}
	} else {
		// Фрагмента нет — данные могли приехать в query-строке
		const query = new URLSearchParams(window.location.search);
		for (const [key, value] of query.entries()) {
			if (TELEGRAM_QUERY_FIELDS.has(key)) {
				params.set(key, value);
			}
		}
	}

	return params.has('hash') ? params : null;
}

onMounted(() => {
	const params = collectAuthFields();

	if (!params) {
		// Данные пришли, но распаковать не удалось — показываем ошибку.
		// Если их нет вовсе (пользователь отменил вход) — молча возвращаем
		// на страницу входа, без ложной ошибки.
		if (window.location.hash.includes('tgAuthResult')) {
			// Пишем cookie напрямую: useCookie ставит её асинхронно и не успеет
			// до навигации
			document.cookie = `auth_error=${ERROR_CODES.TELEGRAM_INVALID_DATA}; path=/; max-age=10; SameSite=Lax`;
		}
		window.location.replace('/login');
		return;
	}

	window.location.replace(`${CALLBACK_URL}?${params.toString()}`);
});
</script>

<template>
	<div class="telegram-return">
		<KitIconSpinner class="telegram-return__spinner" />
	</div>
</template>

<style scoped>
.telegram-return {
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	color: var(--kit-color-primary);
}

/* Размер спиннера — CSS: KitIconSpinner рисуется в 1em и наследует цвет */
.telegram-return__spinner {
	font-size: 40px;
}
</style>
