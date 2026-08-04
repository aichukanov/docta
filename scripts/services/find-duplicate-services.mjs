/**
 * Ищет потенциальные дубликаты медицинских услуг и складывает их в
 * medical_service_duplicate_candidates — очередь на ручное ревью в админке.
 *
 * Ничего не сливает сам: слияние удаляет услугу и заводит 301, это решение
 * человека.
 *
 * Как ищем
 * --------
 * Основной сигнал — согласие языков. У услуги 6 названий; если отпечатки
 * (мультимножество токенов) совпали в двух и более языковых колонках, это почти
 * наверняка одна услуга, записанная разными импортами.
 *
 * Нечёткое сравнение по английскому — только генератор кандидатов, отдельным
 * тиром C. Порог схожести здесь принципиально не работает: в полосе 0.7–1.0
 * сидят осмысленные различия («Tier I» / «Tier II», «Procedure A» / «B»,
 * «до 5 км» / «5–15 км»), и любой порог, ловящий перестановку слов, зацепит и их.
 *
 * Поэтому поверх всего стоят вето-правила (isVetoed): пара с расхождением по
 * различающему признаку выбрасывается независимо от схожести.
 *
 * Тиры
 * ----
 *   A — совпали ≥2 языка
 *   B — совпал 1 язык
 *   C — только нечёткое совпадение по английскому
 *
 * Usage:
 *   node scripts/services/find-duplicate-services.mjs            # записать в БД
 *   node scripts/services/find-duplicate-services.mjs --dry-run  # только отчёт
 */

import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import mysql from 'mysql2/promise';
import {
	createTokenizer,
	dbConfigFromEnv,
	differsByDegreePrefix,
	findFuzzyPairs,
	findLanguageAgreements,
	lateralitySet,
	loadEnv,
	negationSet,
	numberMultiset,
	trailingEnumerator,
	vocabularyMultiset,
} from '../common/dedup-text.mjs';

const __dirname = dirname(fileURLToPath(import.meta.url));
// Скрипт лежит в scripts/services/, до корня репозитория два уровня.
const ROOT = resolve(__dirname, '../..');

const DRY_RUN = process.argv.includes('--dry-run');

loadEnv(ROOT);

// ---------------------------------------------------------------------------
// Нормализация под каталог услуг
// ---------------------------------------------------------------------------

// Служебные слова, не несущие смысла при сравнении названий.
// Союзы and/or сюда НЕ входят: «верхнее ИЛИ нижнее веко» и «верхнее И нижнее» —
// разные услуги с разной ценой, они разводятся вето-правилом.
const NOISE_TOKENS = new Set([
	'the', 'of', 'a', 'an', 'in', 'on', 'to', 'for', 'with',
	'sa', 'za', 'u', 'na', 'od', 'iz',
	'mit', 'der', 'die', 'das', 'des', 'von', 'fur',
	'ile',
]);

const NEGATION_MARKERS = [
	'not including', 'not include', 'excluding', 'without',
	'ne ukljucujuci', 'ne ukljucuje', 'bez',
	'ne vkljuchaya', 'без', 'не включая',
	'ohne', 'ausser',
	'haric', 'dahil degil',
];

const CONJUNCTIONS = new Set([
	'and', 'or', 'i', 'ili', 'und', 'oder', 'и', 'или', 've', 'veya',
]);

const tokenize = createTokenizer({
	noise: NOISE_TOKENS,
	negationMarkers: NEGATION_MARKERS,
});

/**
 * Пара заведомо разных услуг? Вето сильнее любого совпадения отпечатков:
 * лучше не показать настоящий дубль, чем предложить слить «Tier I» с «Tier II».
 */
function isVetoed(a, b) {
	const ta = a.enTokens;
	const tb = b.enTokens;

	if (numberMultiset(ta) !== numberMultiset(tb)) return 'numbers';
	if (
		vocabularyMultiset(ta, CONJUNCTIONS) !== vocabularyMultiset(tb, CONJUNCTIONS)
	) {
		return 'conjunction';
	}
	if (lateralitySet(ta) !== lateralitySet(tb)) return 'laterality';
	if (negationSet(ta) !== negationSet(tb)) return 'negation-scope';
	if (trailingEnumerator(ta) !== trailingEnumerator(tb)) return 'enumerator';
	if (differsByDegreePrefix(a.enTokenSet, b.enTokenSet)) return 'degree-prefix';

	return null;
}

// Медицинские синонимы: разные импорты называли одно и то же по-разному.
const EN_SYNONYMS = new Map(
	Object.entries({
		xray: 'rtg', rendgen: 'rtg', roentgen: 'rtg', radiography: 'rtg',
		teleradiography: 'rtg', snimanje: 'rtg', snimak: 'rtg',
		mri: 'mr', magnetic: 'mr', resonance: 'mr',
		ct: 'msct', skener: 'msct',
		ultrasound: 'uz', ultrasonography: 'uz', uzv: 'uz', ultrazvuk: 'uz',
		exam: 'examination', pregled: 'examination',
		ent: 'orl', otorhinolaryngology: 'orl', otorhinolaryngologist: 'orl',
		removal: 'extraction', excision: 'extraction', vadjenje: 'extraction',
		therapy: 'treatment', terapija: 'treatment',
		followup: 'control', kontrolni: 'control', repeat: 'control',
		specialist: '', specijaliste: '',
	}),
);

function foldSynonyms(tokens) {
	const out = [];
	for (const t of tokens) {
		const isNegated = t.startsWith('neg:');
		const raw = isNegated ? t.slice(4) : t;
		const mapped = EN_SYNONYMS.has(raw) ? EN_SYNONYMS.get(raw) : raw;
		if (!mapped) continue;
		out.push(isNegated ? `neg:${mapped}` : mapped);
	}
	return out;
}

const FUZZY_THRESHOLD = 0.72;

// ---------------------------------------------------------------------------
// Основной проход
// ---------------------------------------------------------------------------

const connection = await mysql.createConnection(dbConfigFromEnv());

try {
	const [rows] = await connection.execute(`
		SELECT
			ms.id,
			ms.name_en, ms.name_sr, ms.name_sr_cyrl, ms.name_ru, ms.name_de, ms.name_tr,
			(SELECT GROUP_CONCAT(mscr.medical_service_category_id)
			   FROM medical_service_categories_relations mscr
			  WHERE mscr.medical_service_id = ms.id) AS cats,
			(SELECT GROUP_CONCAT(cms.clinic_id)
			   FROM clinic_medical_services cms
			  WHERE cms.medical_service_id = ms.id) AS clinics
		FROM medical_services ms
		ORDER BY ms.id
	`);

	const services = rows.map((r) => {
		const enTokens = tokenize(r.name_en);
		return {
			id: r.id,
			names: r,
			enTokens,
			enTokenSet: new Set(enTokens),
			fuzzySet: new Set(foldSynonyms(enTokens)),
			cats: new Set((r.cats || '').split(',').filter(Boolean)),
			clinics: new Set((r.clinics || '').split(',').filter(Boolean)),
		};
	});
	const byId = new Map(services.map((s) => [s.id, s]));

	console.log(`Loaded ${services.length} services`);

	// --- Сигнал 1: согласие языковых колонок ------------------------------
	const candidates = findLanguageAgreements(services, tokenize);

	// --- Сигнал 2: нечёткое совпадение по английскому ---------------------
	for (const [idA, idB, score] of findFuzzyPairs(services, FUZZY_THRESHOLD)) {
		const key = idA < idB ? `${idA}|${idB}` : `${idB}|${idA}`;
		if (!candidates.has(key)) candidates.set(key, new Set());
		candidates.get(key).add(`fuzzy-en:${score.toFixed(2)}`);
	}

	// --- Оценка, вето, тиры -----------------------------------------------
	const vetoStats = new Map();
	const accepted = [];

	for (const [key, signalSet] of candidates) {
		const [idA, idB] = key.split('|').map(Number);
		const a = byId.get(idA);
		const b = byId.get(idB);

		const veto = isVetoed(a, b);
		if (veto) {
			vetoStats.set(veto, (vetoStats.get(veto) || 0) + 1);
			continue;
		}

		const signals = [...signalSet];
		const langHits = signals.filter((s) => s.startsWith('lang:'));

		// Одна клиника не продаёт одну услугу дважды: если обе половинки висят
		// на общей клинике, они пришли из разных проходов импорта.
		const sharedClinics = [...a.clinics].filter((c) => b.clinics.has(c));
		if (sharedClinics.length) signals.push(`same-clinic:${sharedClinics.length}`);

		const sharedCats = [...a.cats].filter((c) => b.cats.has(c));
		if (sharedCats.length) signals.push(`same-category:${sharedCats.join('/')}`);

		const tier = langHits.length >= 2 ? 'A' : langHits.length === 1 ? 'B' : 'C';

		const score =
			langHits.length * 10 +
			(sharedClinics.length ? 5 + sharedClinics.length : 0) +
			(sharedCats.length ? 3 : 0) +
			Math.max(
				0,
				...signals
					.filter((s) => s.startsWith('fuzzy-en:'))
					.map((s) => parseFloat(s.split(':')[1]) * 4),
			);

		accepted.push({
			idA,
			idB,
			tier,
			score: Number(score.toFixed(2)),
			signals: signals.sort().join(','),
			a,
			b,
		});
	}

	accepted.sort((x, y) => y.score - x.score);

	// --- Отчёт -------------------------------------------------------------
	const byTier = { A: 0, B: 0, C: 0 };
	for (const p of accepted) byTier[p.tier]++;

	console.log('');
	console.log(`Candidate pairs after veto: ${accepted.length}`);
	console.log(`  tier A (>=2 languages agree): ${byTier.A}`);
	console.log(`  tier B (1 language agrees):   ${byTier.B}`);
	console.log(`  tier C (fuzzy English only):  ${byTier.C}`);
	console.log('');
	console.log('Vetoed pairs (deliberately different services):');
	for (const [reason, n] of [...vetoStats].sort((x, y) => y[1] - x[1])) {
		console.log(`  ${reason.padEnd(16)} ${n}`);
	}

	console.log('');
	console.log('--- top 20 by score ---');
	for (const p of accepted.slice(0, 20)) {
		console.log(`  [${p.tier}] ${String(p.score).padStart(6)}  ${p.signals}`);
		console.log(`         ${String(p.idA).padStart(5)}  ${p.a.names.name_en}  |  ${p.a.names.name_sr}`);
		console.log(`         ${String(p.idB).padStart(5)}  ${p.b.names.name_en}  |  ${p.b.names.name_sr}`);
	}

	// --- Запись в очередь ---------------------------------------------------
	if (DRY_RUN) {
		console.log('\n--dry-run: nothing written');
	} else {
		let inserted = 0;
		for (const p of accepted) {
			// Решённые пары не трогаем: отклонённый однажды кандидат не должен
			// всплывать при каждом прогоне.
			const [res] = await connection.execute(
				`INSERT INTO medical_service_duplicate_candidates
					(service_id_a, service_id_b, tier, score, signals)
				 VALUES (?, ?, ?, ?, ?)
				 ON DUPLICATE KEY UPDATE
					tier    = IF(status = 'pending', VALUES(tier), tier),
					score   = IF(status = 'pending', VALUES(score), score),
					signals = IF(status = 'pending', VALUES(signals), signals)`,
				[p.idA, p.idB, p.tier, p.score, p.signals],
			);
			if (res.affectedRows === 1) inserted++;
		}

		const [[{ pending }]] = await connection.query(
			`SELECT COUNT(*) AS pending FROM medical_service_duplicate_candidates WHERE status = 'pending'`,
		);
		console.log(`\nWritten to medical_service_duplicate_candidates.`);
		console.log(`  new pairs: ${inserted}`);
		console.log(`  pending review overall: ${pending}`);
	}
} finally {
	await connection.end();
}
