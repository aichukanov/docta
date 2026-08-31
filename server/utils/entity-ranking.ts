import { OUTDATED_PRICE_FACTOR } from '~/common/ranking';
import { type Conn, withConnection } from '~/server/common/medicines/helpers';

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
 * 200 — практический максимум на платформе.
 * log2(201) ≈ 7.65 — делитель для нормализации в 0-1.
 */
const VOLUME_CAP = 200;
const VOLUME_LOG_DIVISOR = Math.log2(1 + VOLUME_CAP);

/**
 * Веса компонентов формулы ранжирования врачей и клиник.
 *
 * bayesianRating (0.40): скорректированный рейтинг — первое, на что смотрит пользователь.
 *   Bayesian average не даёт единичным отзывам искажать картину.
 *   Высокая оценка по большому числу отзывов — главный сигнал качества.
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
 * engagement (0.05): доля отзывов с ответом клиники/врача.
 *   Показывает заботу и вовлечённость. Вторичный сигнал —
 *   не должен перевешивать реальную оценку пользователей.
 */
const W = {
	bayesianRating: 0.4,
	reviewVolume: 0.25,
	profileCompleteness: 0.2,
	reviewFreshness: 0.1,
	engagement: 0.05,
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
	currentScore: unknown;
	hasPhoto: boolean;
	hasDescription: boolean;
	hasSpecialty: boolean;
	hasContact: boolean;
	hasClinic: boolean;
}

interface ClinicProfile {
	id: number;
	currentScore: unknown;
	hasDescription: boolean;
	hasAddress: boolean;
	hasContact: boolean;
	hasService: boolean;
	hasDoctor: boolean;
}

function bayesianRating(
	avgRating: number | null,
	totalReviews: number,
): number {
	const avg = avgRating ?? BAYESIAN_M;
	const bayesian =
		(BAYESIAN_C * BAYESIAN_M + totalReviews * avg) /
		(BAYESIAN_C + totalReviews);
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
	const s = stats ?? {
		totalReviews: 0,
		avgRating: null,
		latestReviewAt: null,
		reviewsWithReply: 0,
	};
	return (
		W.bayesianRating * bayesianRating(s.avgRating, s.totalReviews) +
		W.reviewVolume * reviewVolume(s.totalReviews) +
		W.profileCompleteness * completeness +
		W.reviewFreshness * reviewFreshness(s.latestReviewAt) +
		W.engagement * engagement(s.reviewsWithReply, s.totalReviews)
	);
}

/**
 * Веса компонентов формулы ранжирования услуг.
 *
 * clinicCount (0.60): сколько клиник предлагают услугу — главный индикатор спроса.
 *   Если 20 клиник предлагают УЗИ — это популярная услуга.
 *   Логарифм выравнивает: разница между 5 и 50 клиниками не 10x.
 *
 * doctorCount (0.30): сколько врачей выполняют — дополняет спрос.
 *   Много врачей = востребованная процедура.
 *
 * hasPricing (0.10): есть ли хотя бы одна цена — сигнал полезности.
 *   Услуга с ценами полезнее для пользователя, чем без.
 *   Устаревшая цена засчитывается частично — см. OUTDATED_PRICE_FACTOR в common/ranking.ts.
 */
const SW = {
	clinicCount: 0.6,
	doctorCount: 0.3,
	hasPricing: 0.1,
} as const;

/**
 * Ценовой сигнал услуги/анализа: 1 — есть актуальная цена хотя бы в одной
 * клинике, OUTDATED_PRICE_FACTOR — все цены помечены устаревшими, 0 — цен нет.
 * Хватает одной актуальной цены, чтобы получить полный вес.
 */
function pricingScore(
	hasFreshPricing: boolean,
	hasAnyPricing: boolean,
): number {
	if (hasFreshPricing) return 1;
	return hasAnyPricing ? OUTDATED_PRICE_FACTOR : 0;
}

/**
 * Потолки для нормализации количества клиник и врачей.
 * 30 клиник / 50 врачей — практический максимум на платформе.
 */
const SERVICE_CLINIC_CAP = 30;
const SERVICE_CLINIC_LOG_DIVISOR = Math.log2(1 + SERVICE_CLINIC_CAP);
const SERVICE_DOCTOR_CAP = 50;
const SERVICE_DOCTOR_LOG_DIVISOR = Math.log2(1 + SERVICE_DOCTOR_CAP);

/**
 * Веса компонентов формулы ранжирования анализов.
 *
 * У анализов нет врачей (в отличие от услуг), поэтому формула проще.
 *
 * clinicCount (0.80): сколько клиник предлагают анализ — основной сигнал спроса.
 *   Общий анализ крови в 15 клиниках популярнее редкого маркера в 1 клинике.
 *
 * hasPricing (0.20): есть ли хотя бы одна цена — сигнал полезности.
 *   Вес выше чем у услуг (10%), потому что для анализов цена — ключевой
 *   фактор выбора (пользователи сравнивают цены между лабораториями).
 *   Устаревшая цена засчитывается частично — см. OUTDATED_PRICE_FACTOR в common/ranking.ts.
 */
const LW = {
	clinicCount: 0.8,
	hasPricing: 0.2,
} as const;

const LAB_CLINIC_CAP = 20;
const LAB_CLINIC_LOG_DIVISOR = Math.log2(1 + LAB_CLINIC_CAP);

/**
 * Округление скора до 4 знаков — ровно столько хранит колонка
 * rank_score DECIMAL(5,4). Вынесено в функцию, чтобы все четыре пересчёта
 * округляли одинаково (раньше `Math.round(score * 10000) / 10000` был
 * скопирован в каждый цикл).
 */
function round4(score: number): number {
	return Math.round(score * 10000) / 10000;
}

type RankScoreTable = 'doctors' | 'clinics' | 'medical_services' | 'lab_tests';

interface ScoreUpdate {
	id: number;
	score: number;
}

/**
 * Сколько строк уходит в один UPDATE. 500 пар — это 1000 плейсхолдеров и
 * ~12 КБ текста запроса: пакет уже амортизирует круговой рейс, но ещё далеко
 * и от max_allowed_packet, и от лимита плейсхолдеров протокола (65535).
 * Число фиксированное, поэтому в LRU подготовленных выражений mysql2
 * (maxPreparedStatements: 200, см. db-mysql.ts) оседает не больше двух
 * вариантов текста на таблицу: полный пакет и остаток.
 */
const SCORE_BATCH_SIZE = 500;

/**
 * Пакетная запись посчитанных скоров.
 *
 * Раньше на каждую строку уходил свой `UPDATE ... WHERE id = ?`: 1318 врачей +
 * 138 клиник + 5237 услуг + 1591 анализ = 8284 последовательных круговых
 * рейса. Замер на копиях таблиц в локальной БД — 5.2 с чистых ожиданий
 * (с удалённой БД будет кратно больше), и всё это время пересчёт держал
 * 1 из 10 соединений пула, конкурируя с холодным трафиком на старте сервера.
 *
 * Теперь тот же объём — не больше 19 UPDATE'ов по 500 строк, 0.15 с на том же
 * замере: значения приезжают производной таблицей из литералов, а джойн по
 * первичному ключу даёт eq_ref (EXPLAIN UPDATE: `<derived2>` ALL 500 строк →
 * `t` eq_ref PRIMARY). Сверка старого и нового пути на копиях всех четырёх
 * таблиц: 0 расхождений в rank_score.
 *
 * Формула не меняется: скоры считает тот же JS-код, что и раньше, здесь
 * только их доставка в БД.
 */
async function applyRankScores(
	connection: Conn,
	table: RankScoreTable,
	updates: ScoreUpdate[],
): Promise<void> {
	for (let offset = 0; offset < updates.length; offset += SCORE_BATCH_SIZE) {
		const batch = updates.slice(offset, offset + SCORE_BATCH_SIZE);

		// Производная таблица через UNION ALL, а не через `VALUES ROW(...)`:
		// табличный конструктор появился только в MySQL 8.0.19, а план у обоих
		// вариантов одинаковый.
		// CAST в первой ветке задаёт тип колонки id для всего UNION — без него
		// id сравнивался бы с PRIMARY как double.
		const derived = batch
			.map((_, index) =>
				index === 0
					? 'SELECT CAST(? AS UNSIGNED) AS id, ? AS score'
					: 'UNION ALL SELECT ?, ?',
			)
			.join(' ');
		const params = batch.flatMap(({ id, score }) => [id, score]);

		// Имя таблицы — из union-типа выше, а не из входных данных.
		await connection.execute(
			`UPDATE ${table} t JOIN (${derived}) v ON t.id = v.id SET t.rank_score = v.score`,
			params,
		);
	}
}

/**
 * Отбрасывает строки, у которых скор не изменился.
 *
 * Скор услуг и анализов не зависит от времени: между двумя прогонами он
 * меняется только там, где поменялись данные (обычно — единицы строк из 6653).
 * Отсев экономит и трафик пакета, и работу InnoDB.
 */
function changedOnly(
	rows: Array<{ id: number; currentScore: unknown }>,
	scoreOf: (row: any) => number,
): ScoreUpdate[] {
	const updates: ScoreUpdate[] = [];

	for (const row of rows) {
		const score = round4(scoreOf(row));

		if (Number(row.currentScore) !== score) {
			updates.push({ id: row.id, score });
		}
	}

	return updates;
}

/**
 * Пересчитывает rank_score для всех врачей, клиник, услуг и анализов.
 * Вызывается при старте сервера и по расписанию.
 */
export async function recalculateEntityRankScores(): Promise<void> {
	await withConnection(async (connection) => {
		await recalculateDoctorScores(connection);
		await recalculateClinicScores(connection);
		await recalculateServiceScores(connection);
		await recalculateLabTestScores(connection);
	});
}

async function recalculateDoctorScores(connection: Conn): Promise<void> {
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
		WHERE r.doctor_id IS NOT NULL AND r.rating IS NOT NULL AND r.status != 'rejected'
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
			d.rank_score AS currentScore,
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

	const updates = changedOnly(
		profileRows as DoctorProfile[],
		(doc: DoctorProfile) => {
			const filled =
				Number(doc.hasPhoto) +
				Number(doc.hasDescription) +
				Number(doc.hasSpecialty) +
				Number(doc.hasContact) +
				Number(doc.hasClinic);
			const completeness = filled / 5;
			return computeScore(statsMap.get(doc.id), completeness);
		},
	);

	await applyRankScores(connection, 'doctors', updates);
}

async function recalculateClinicScores(connection: Conn): Promise<void> {
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
		WHERE r.clinic_id IS NOT NULL AND r.rating IS NOT NULL AND r.status != 'rejected'
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
			c.rank_score AS currentScore,
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

	const updates = changedOnly(
		profileRows as ClinicProfile[],
		(clinic: ClinicProfile) => {
			const filled =
				Number(clinic.hasDescription) +
				Number(clinic.hasAddress) +
				Number(clinic.hasContact) +
				Number(clinic.hasService) +
				Number(clinic.hasDoctor);
			const completeness = filled / 5;
			return computeScore(statsMap.get(clinic.id), completeness);
		},
	);

	await applyRankScores(connection, 'clinics', updates);
}

async function recalculateServiceScores(connection: Conn): Promise<void> {
	const [rows] = await connection.execute(`
		SELECT
			ms.id,
			ms.rank_score AS currentScore,
			(SELECT COUNT(DISTINCT cms.clinic_id) FROM clinic_medical_services cms WHERE cms.medical_service_id = ms.id) AS clinicCount,
			(SELECT COUNT(DISTINCT cmsd.doctor_id) FROM clinic_medical_service_doctors cmsd WHERE cmsd.medical_service_id = ms.id) AS doctorCount,
			EXISTS(
				SELECT 1 FROM clinic_medical_services cms
				WHERE cms.medical_service_id = ms.id AND cms.price IS NOT NULL
					AND COALESCE(cms.is_price_outdated, 0) = 0
			) AS hasFreshPricing,
			EXISTS(
				SELECT 1 FROM clinic_medical_services cms
				WHERE cms.medical_service_id = ms.id AND cms.price IS NOT NULL
			) AS hasAnyPricing
		FROM medical_services ms
	`);

	const updates = changedOnly(rows as any[], (row: any) => {
		const clinicScore = Math.min(
			1,
			Math.log2(1 + Number(row.clinicCount)) / SERVICE_CLINIC_LOG_DIVISOR,
		);
		const doctorScore = Math.min(
			1,
			Math.log2(1 + Number(row.doctorCount)) / SERVICE_DOCTOR_LOG_DIVISOR,
		);
		const priceScore = pricingScore(
			Boolean(Number(row.hasFreshPricing)),
			Boolean(Number(row.hasAnyPricing)),
		);

		return (
			SW.clinicCount * clinicScore +
			SW.doctorCount * doctorScore +
			SW.hasPricing * priceScore
		);
	});

	await applyRankScores(connection, 'medical_services', updates);
}

async function recalculateLabTestScores(connection: Conn): Promise<void> {
	const [rows] = await connection.execute(`
		SELECT
			lt.id,
			lt.rank_score AS currentScore,
			(SELECT COUNT(DISTINCT clt.clinic_id) FROM clinic_lab_tests clt WHERE clt.lab_test_id = lt.id) AS clinicCount,
			EXISTS(
				SELECT 1 FROM clinic_lab_tests clt
				WHERE clt.lab_test_id = lt.id AND clt.price IS NOT NULL
					AND COALESCE(clt.is_price_outdated, 0) = 0
			) AS hasFreshPricing,
			EXISTS(
				SELECT 1 FROM clinic_lab_tests clt
				WHERE clt.lab_test_id = lt.id AND clt.price IS NOT NULL
			) AS hasAnyPricing
		FROM lab_tests lt
	`);

	const updates = changedOnly(rows as any[], (row: any) => {
		const clinicScore = Math.min(
			1,
			Math.log2(1 + Number(row.clinicCount)) / LAB_CLINIC_LOG_DIVISOR,
		);
		const priceScore = pricingScore(
			Boolean(Number(row.hasFreshPricing)),
			Boolean(Number(row.hasAnyPricing)),
		);

		return LW.clinicCount * clinicScore + LW.hasPricing * priceScore;
	});

	await applyRankScores(connection, 'lab_tests', updates);
}
