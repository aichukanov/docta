import { getConnection } from '~/server/common/db-mysql';

const MS_PER_DAY = 86_400_000;

/**
 * Полупериод затухания свежести — 365 дней.
 * Через год последний отзыв теряет 50% веса по свежести.
 * Сигнал актуальности: клиника со свежим отзывом скорее всего работает,
 * а с последним отзывом 3 года назад — может быть уже закрыта.
 */
const DECAY_LAMBDA = Math.LN2 / 365;

/**
 * Bayesian prior: C = 5 «фантомных» отзывов со средней оценкой m = 4.0.
 *
 * C = 5 (а не 10): у большинства врачей мало отзывов,
 * с C=10 реальные оценки начнут влиять слишком поздно.
 *
 * m = 4.0: типичный глобальный средний рейтинг в медицине.
 * Врач с 0 отзывами получит 4.0 — нейтральную позицию,
 * а не попадёт в топ (как было бы с 5.0) или на дно (как с 1.0).
 */
const BAYESIAN_C = 5;
const BAYESIAN_M = 4.0;

/**
 * Потолок количества отзывов для нормализации.
 * 50 — текущий максимум на платформе.
 * log2(51) ≈ 5.67 — делитель для нормализации в 0-1.
 */
const VOLUME_CAP = 50;
const VOLUME_LOG_DIVISOR = Math.log2(1 + VOLUME_CAP);

/**
 * Веса компонентов формулы ранжирования врачей и клиник.
 *
 * bayesianRating (0.35): скорректированный рейтинг — первое, на что смотрит пользователь.
 *   Bayesian average не даёт единичным отзывам искажать картину.
 *
 * reviewVolume (0.25): количество отзывов — сигнал доверия.
 *   Врач с 50 отзывами вызывает больше доверия, чем врач с 2.
 *   Логарифм выравнивает: разница между 30 и 50 отзывами невелика.
 *
 * profileCompleteness (0.20): заполненность профиля — сигнал полезности.
 *   Пустой профиль без фото и описания бесполезен для пользователя,
 *   даже если рейтинг хороший.
 *
 * reviewFreshness (0.10): свежесть последнего отзыва — сигнал актуальности.
 *   Клиника со вчерашним отзывом — точно работает.
 *   Клиника без отзывов 3 года — может уже закрылась.
 *
 * engagement (0.10): доля отзывов с ответом клиники/врача.
 *   Показывает заботу и вовлечённость. Второстепенный сигнал.
 */
const W = {
	bayesianRating: 0.35,
	reviewVolume: 0.25,
	profileCompleteness: 0.2,
	reviewFreshness: 0.1,
	engagement: 0.1,
} as const;

interface ReviewStats {
	entityId: number;
	totalReviews: number;
	avgRating: number | null;
	latestReviewAt: Date | null;
	reviewsWithReply: number;
}

interface DoctorProfile {
	id: number;
	hasPhoto: boolean;
	hasDescription: boolean;
	hasSpecialty: boolean;
	hasContact: boolean;
	hasClinic: boolean;
}

interface ClinicProfile {
	id: number;
	hasDescription: boolean;
	hasAddress: boolean;
	hasContact: boolean;
	hasService: boolean;
	hasDoctor: boolean;
}

function bayesianRating(avgRating: number | null, totalReviews: number): number {
	const avg = avgRating ?? BAYESIAN_M;
	const bayesian = (BAYESIAN_C * BAYESIAN_M + totalReviews * avg) / (BAYESIAN_C + totalReviews);
	// Нормализация 1-5 → 0-1
	return (bayesian - 1) / 4;
}

function reviewVolume(totalReviews: number): number {
	return Math.min(1, Math.log2(1 + totalReviews) / VOLUME_LOG_DIVISOR);
}

function reviewFreshness(latestReviewAt: Date | null): number {
	if (!latestReviewAt) return 0;
	const daysOld = (Date.now() - latestReviewAt.getTime()) / MS_PER_DAY;
	return Math.exp(-DECAY_LAMBDA * Math.max(0, daysOld));
}

function engagement(reviewsWithReply: number, totalReviews: number): number {
	if (totalReviews === 0) return 0;
	return reviewsWithReply / totalReviews;
}

function computeScore(
	stats: ReviewStats | undefined,
	completeness: number,
): number {
	const s = stats ?? { totalReviews: 0, avgRating: null, latestReviewAt: null, reviewsWithReply: 0 };
	return (
		W.bayesianRating * bayesianRating(s.avgRating, s.totalReviews) +
		W.reviewVolume * reviewVolume(s.totalReviews) +
		W.profileCompleteness * completeness +
		W.reviewFreshness * reviewFreshness(s.latestReviewAt) +
		W.engagement * engagement(s.reviewsWithReply, s.totalReviews)
	);
}

/**
 * Пересчитывает rank_score для всех врачей и клиник.
 * Вызывается при старте сервера и по расписанию.
 */
export async function recalculateEntityRankScores(): Promise<void> {
	const connection = await getConnection();
	try {
		await recalculateDoctorScores(connection);
		await recalculateClinicScores(connection);
	} finally {
		await connection.end();
	}
}

async function recalculateDoctorScores(connection: any): Promise<void> {
	// Статистика отзывов по врачам
	const [statsRows] = await connection.execute(`
		SELECT
			r.doctor_id AS entityId,
			COUNT(*) AS totalReviews,
			AVG(r.rating) AS avgRating,
			MAX(r.published_at) AS latestReviewAt,
			SUM(
				EXISTS(SELECT 1 FROM review_replies rr WHERE rr.review_id = r.id)
			) AS reviewsWithReply
		FROM reviews r
		WHERE r.doctor_id IS NOT NULL AND r.rating IS NOT NULL
		GROUP BY r.doctor_id
	`);
	const statsMap = new Map<number, ReviewStats>();
	for (const row of statsRows as any[]) {
		statsMap.set(row.entityId, {
			entityId: row.entityId,
			totalReviews: Number(row.totalReviews),
			avgRating: row.avgRating != null ? Number(row.avgRating) : null,
			latestReviewAt: row.latestReviewAt ? new Date(row.latestReviewAt) : null,
			reviewsWithReply: Number(row.reviewsWithReply),
		});
	}

	// Полнота профиля врачей: фото, описание, специальность, контакт, клиника
	const [profileRows] = await connection.execute(`
		SELECT
			d.id,
			(d.photo_url IS NOT NULL AND d.photo_url != '') AS hasPhoto,
			(d.description_sr IS NOT NULL AND d.description_sr != '') AS hasDescription,
			EXISTS(SELECT 1 FROM doctor_specialties ds WHERE ds.doctor_id = d.id) AS hasSpecialty,
			(
				(d.phone IS NOT NULL AND d.phone != '')
				OR (d.email IS NOT NULL AND d.email != '')
				OR (d.website IS NOT NULL AND d.website != '')
			) AS hasContact,
			EXISTS(SELECT 1 FROM doctor_clinics dc WHERE dc.doctor_id = d.id) AS hasClinic
		FROM doctors d
	`);

	for (const doc of profileRows as DoctorProfile[]) {
		const filled = Number(doc.hasPhoto) + Number(doc.hasDescription) +
			Number(doc.hasSpecialty) + Number(doc.hasContact) + Number(doc.hasClinic);
		const completeness = filled / 5;
		const score = computeScore(statsMap.get(doc.id), completeness);

		await connection.execute(
			'UPDATE doctors SET rank_score = ? WHERE id = ?',
			[Math.round(score * 10000) / 10000, doc.id],
		);
	}
}

async function recalculateClinicScores(connection: any): Promise<void> {
	// Статистика отзывов по клиникам
	const [statsRows] = await connection.execute(`
		SELECT
			r.clinic_id AS entityId,
			COUNT(*) AS totalReviews,
			AVG(r.rating) AS avgRating,
			MAX(r.published_at) AS latestReviewAt,
			SUM(
				EXISTS(SELECT 1 FROM review_replies rr WHERE rr.review_id = r.id)
			) AS reviewsWithReply
		FROM reviews r
		WHERE r.clinic_id IS NOT NULL AND r.rating IS NOT NULL
		GROUP BY r.clinic_id
	`);
	const statsMap = new Map<number, ReviewStats>();
	for (const row of statsRows as any[]) {
		statsMap.set(row.entityId, {
			entityId: row.entityId,
			totalReviews: Number(row.totalReviews),
			avgRating: row.avgRating != null ? Number(row.avgRating) : null,
			latestReviewAt: row.latestReviewAt ? new Date(row.latestReviewAt) : null,
			reviewsWithReply: Number(row.reviewsWithReply),
		});
	}

	// Полнота профиля клиник: описание, адрес+координаты, контакт, услуга, врач
	const [profileRows] = await connection.execute(`
		SELECT
			c.id,
			(c.description_sr IS NOT NULL AND c.description_sr != '') AS hasDescription,
			(
				c.address_sr IS NOT NULL AND c.address_sr != ''
				AND c.latitude IS NOT NULL AND c.longitude IS NOT NULL
			) AS hasAddress,
			(
				(c.phone IS NOT NULL AND c.phone != '')
				OR (c.email IS NOT NULL AND c.email != '')
				OR (c.website IS NOT NULL AND c.website != '')
			) AS hasContact,
			EXISTS(SELECT 1 FROM clinic_medical_services cms WHERE cms.clinic_id = c.id) AS hasService,
			EXISTS(SELECT 1 FROM doctor_clinics dc WHERE dc.clinic_id = c.id) AS hasDoctor
		FROM clinics c
	`);

	for (const clinic of profileRows as ClinicProfile[]) {
		const filled = Number(clinic.hasDescription) + Number(clinic.hasAddress) +
			Number(clinic.hasContact) + Number(clinic.hasService) + Number(clinic.hasDoctor);
		const completeness = filled / 5;
		const score = computeScore(statsMap.get(clinic.id), completeness);

		await connection.execute(
			'UPDATE clinics SET rank_score = ? WHERE id = ?',
			[Math.round(score * 10000) / 10000, clinic.id],
		);
	}
}
