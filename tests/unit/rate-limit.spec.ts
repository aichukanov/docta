import { test, expect } from '@playwright/test';
import {
	registerAttempt,
	RATE_LIMITS,
	type RateLimitRule,
} from '../../server/utils/rate-limit';

// Лимитер прикрывает перебор паролей на auth/login и отправку писем через
// Mailgun (register, forgot-password, resend-verification,
// request-email-change). Тестируется чистая оконная логика: сам отказ 429
// и заголовок Retry-After живут в enforceRateLimit, который требует H3Event.
//
// Счётчики — общий Map модуля, поэтому каждый тест работает в своём bucket
// и время во всех тестах только растёт.

const T0 = 1_000_000_000_000;

function rule(bucket: string, limit: number, windowMs: number): RateLimitRule {
	return { bucket, limit, windowMs };
}

test.describe('registerAttempt', () => {
	test('пропускает до лимита включительно, отбивает следующий', () => {
		const r = rule('t-basic', 3, 60_000);
		for (let i = 0; i < 3; i++) {
			expect(registerAttempt('t-basic:1.2.3.4', r, T0 + i)).toBeNull();
		}
		expect(registerAttempt('t-basic:1.2.3.4', r, T0 + 3)).not.toBeNull();
	});

	test('возвращает секунды до сброса окна', () => {
		const r = rule('t-retry', 1, 60_000);
		expect(registerAttempt('t-retry:ip', r, T0)).toBeNull();
		// Превышение через 15 секунд после начала окна: до сброса осталось 45
		expect(registerAttempt('t-retry:ip', r, T0 + 15_000)).toBe(45);
	});

	test('после истечения окна счётчик начинается заново', () => {
		const r = rule('t-window', 1, 60_000);
		expect(registerAttempt('t-window:ip', r, T0)).toBeNull();
		expect(registerAttempt('t-window:ip', r, T0 + 1)).not.toBeNull();
		expect(registerAttempt('t-window:ip', r, T0 + 60_000)).toBeNull();
	});

	test('ключи независимы: лимит одного IP не задевает другой', () => {
		const r = rule('t-keys', 1, 60_000);
		expect(registerAttempt('t-keys:a', r, T0)).toBeNull();
		expect(registerAttempt('t-keys:a', r, T0 + 1)).not.toBeNull();
		expect(registerAttempt('t-keys:b', r, T0 + 2)).toBeNull();
	});

	test('заблокированный ключ остаётся заблокированным до конца окна', () => {
		const r = rule('t-sticky', 2, 60_000);
		registerAttempt('t-sticky:ip', r, T0);
		registerAttempt('t-sticky:ip', r, T0 + 1);
		// Дальнейшие попытки внутри окна не продлевают его, но и не проходят
		expect(registerAttempt('t-sticky:ip', r, T0 + 10_000)).not.toBeNull();
		expect(registerAttempt('t-sticky:ip', r, T0 + 30_000)).not.toBeNull();
		expect(registerAttempt('t-sticky:ip', r, T0 + 60_000)).toBeNull();
	});

	test('профили прода: login жёстче и короче, email реже и длиннее', () => {
		// Страховка от случайной правки чисел: 5 попыток входа за 15 минут,
		// 5 писем в час — на процесс; в pm2-кластере фактически ×4
		expect(RATE_LIMITS.login).toEqual({
			bucket: 'login',
			limit: 5,
			windowMs: 15 * 60 * 1000,
		});
		expect(RATE_LIMITS.email).toEqual({
			bucket: 'email',
			limit: 5,
			windowMs: 60 * 60 * 1000,
		});
	});
});
