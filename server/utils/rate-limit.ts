import type { H3Event } from 'h3';
import { getClientIp } from './client-ip';
import { ERROR_CODES, createErrorResponse } from './api-codes';

export interface RateLimitRule {
	/** Пространство счётчиков: у разных групп эндпоинтов — своё */
	bucket: string;
	/** Максимум запросов с одного IP за окно (на процесс, см. ниже) */
	limit: number;
	/** Длина окна в миллисекундах */
	windowMs: number;
}

/**
 * Счётчики живут в памяти процесса, а прод — pm2-кластер
 * (ecosystem.config.cjs, instances: 4) с round-robin между воркерами,
 * поэтому фактический потолок на IP — до limit × instances. Числа ниже
 * выбраны с этим запасом ×4; легитимный пользователь размазывается по
 * воркерам и до лимита не доходит.
 */
export const RATE_LIMITS = {
	/** Вход по паролю: от перебора. ≤5 попыток за 15 минут на воркер. */
	login: { bucket: 'login', limit: 5, windowMs: 15 * 60 * 1000 },
	/**
	 * Эндпоинты, каждый вызов которых отправляет письмо через Mailgun:
	 * register, forgot-password, resend-verification, request-email-change.
	 * Bucket общий — ограничивает суммарную отправку с одного IP.
	 */
	email: { bucket: 'email', limit: 5, windowMs: 60 * 60 * 1000 },
} satisfies Record<string, RateLimitRule>;

interface WindowEntry {
	count: number;
	resetAt: number;
}

const counters = new Map<string, WindowEntry>();

// Истёкшие окна вычищаются лениво, не чаще раза в минуту, чтобы не
// обходить Map на каждом запросе. Размер и так ограничен числом
// уникальных IP за окно.
const SWEEP_INTERVAL_MS = 60 * 1000;
let nextSweepAt = 0;

function sweepExpired(now: number): void {
	if (now < nextSweepAt) {
		return;
	}
	nextSweepAt = now + SWEEP_INTERVAL_MS;
	for (const [key, entry] of counters) {
		if (entry.resetAt <= now) {
			counters.delete(key);
		}
	}
}

/**
 * Засчитать попытку по ключу. Если лимит окна превышен — вернуть, через
 * сколько секунд окно сбросится; иначе null. Чистая часть без H3 —
 * ради юнит-тестов.
 */
export function registerAttempt(
	key: string,
	rule: RateLimitRule,
	now: number = Date.now(),
): number | null {
	sweepExpired(now);

	const entry = counters.get(key);
	if (!entry || entry.resetAt <= now) {
		counters.set(key, { count: 1, resetAt: now + rule.windowMs });
		return null;
	}

	entry.count += 1;
	if (entry.count > rule.limit) {
		return Math.ceil((entry.resetAt - now) / 1000);
	}
	return null;
}

/**
 * Отбить запрос кодом 429, если с этого IP в окне rule уже исчерпан лимит.
 * Вызывать первой строкой обработчика, до readBody и до проверки сессии.
 */
export function enforceRateLimit(event: H3Event, rule: RateLimitRule): void {
	const key = `${rule.bucket}:${getClientIp(event)}`;
	const retryAfterSec = registerAttempt(key, rule);

	if (retryAfterSec !== null) {
		setResponseHeader(event, 'Retry-After', retryAfterSec);
		createErrorResponse(429, ERROR_CODES.TOO_MANY_REQUESTS);
	}
}
