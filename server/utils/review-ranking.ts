import type { Review } from '~/interfaces/review';

const MS_PER_DAY = 86_400_000;

/**
 * Полупериод затухания свежести — 365 дней.
 * Через год отзыв теряет 50% веса по свежести,
 * через 2 года — 75%, через 3 — 87%.
 * Для медицины свежесть критична: врачи меняют клиники,
 * персонал меняется, качество услуг нестабильно.
 */
const DECAY_LAMBDA = Math.LN2 / 365;

/**
 * Длина текста (в символах), при которой score за текст достигает 1.0.
 * ~300 символов — это 2-4 предложения, достаточно для содержательного отзыва.
 * Исследования показывают: длина текста — лучший предиктор полезности отзыва.
 */
const TEXT_PLATEAU_LENGTH = 300;

/**
 * Нормализатор для лайков: LOG2(1 + likes) / 5.
 * 31+ лайков даёт максимальный score.
 * Логарифм сглаживает: 1 отзыв с 100 лайками не доминирует бесконечно
 * над отзывом с 10 лайками — разница всего 30% вместо 10x.
 */
const LIKES_LOG_DIVISOR = 5;

/**
 * Доверие к источнику отзыва.
 * - docta_me (1.0): верифицированные пользователи платформы
 * - facebook (0.90): реальный профиль с фото, друзьями, историей — сложно подделать
 * - telegram (0.85): привязка к номеру телефона, но профиль менее публичный
 * - google_maps (0.75): легко создать анонимный аккаунт, много спамных отзывов
 */
const PROVIDER_TRUST: Record<string, number> = {
	docta_me: 1.0,
	facebook: 0.9,
	telegram: 0.85,
	google_maps: 0.75,
};
const DEFAULT_PROVIDER_TRUST = 0.7;

/**
 * Веса компонентов формулы ранжирования.
 *
 * recency (0.30): свежесть — для медицинских отзывов критична
 * textQuality (0.30): подробность текста — главный признак полезного отзыва;
 *   отзывы без текста автоматически уходят вниз
 * likes (0.20): голоса пользователей — прямой сигнал полезности
 * hasRating (0.10): наличие звёздного рейтинга — помогает быстрее сканировать
 * providerTrust (0.10): доверие к источнику — верифицированные > анонимные
 */
const W = {
	recency: 0.3,
	textQuality: 0.3,
	likes: 0.2,
	hasRating: 0.1,
	providerTrust: 0.1,
} as const;

/** Небольшой бонус за наличие ответа клиники/врача — показывает вовлечённость */
const REPLY_BONUS = 0.03;

/** Возраст по умолчанию (дни) для отзывов без даты — эквивалент 2 годам */
const DEFAULT_AGE_DAYS = 730;

function reviewRankScore(review: Review): number {
	const daysOld = review.publishedAt
		? (Date.now() - new Date(review.publishedAt).getTime()) / MS_PER_DAY
		: DEFAULT_AGE_DAYS;

	const recency = Math.exp(-DECAY_LAMBDA * Math.max(0, daysOld));
	// text — всегда заполнен (локализованный или оригинальный),
	// а originalText может быть null после обработки в эндпоинте
	const textQuality = Math.min(
		1,
		(review.text?.length ?? 0) / TEXT_PLATEAU_LENGTH,
	);
	const likes = Math.min(
		1,
		Math.log2(1 + review.likesCount) / LIKES_LOG_DIVISOR,
	);
	const hasRating = review.rating != null ? 1 : 0;
	const providerTrust =
		PROVIDER_TRUST[review.provider] ?? DEFAULT_PROVIDER_TRUST;
	const replyBonus = (review.replies?.length ?? 0) > 0 ? REPLY_BONUS : 0;

	return (
		W.recency * recency +
		W.textQuality * textQuality +
		W.likes * likes +
		W.hasRating * hasRating +
		W.providerTrust * providerTrust +
		replyBonus
	);
}
