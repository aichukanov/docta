/**
 * Ищет потенциальные дубликаты лабораторных анализов и складывает их в
 * lab_test_duplicate_candidates — очередь на ручное ревью в админке.
 *
 * Ничего не сливает сам: слияние удаляет анализ и заводит 301, это решение
 * человека.
 *
 * Отличия от детектора услуг
 * --------------------------
 * 1. Есть четвёртый сигнал — синонимы. Если синоним одного анализа совпал с
 *    названием другого, это почти приговор: синонимы заводились руками.
 *
 * 2. Другой набор вето. Анализы различаются не стороной тела и номером варианта,
 *    а тем, ЧТО именно измеряется:
 *      - класс иммуноглобулина    IgG / IgM / IgA  (перенесённая инфекция ≠ острая)
 *      - серотип и группа         Salmonella Group A / B, Influenza A / B, O- / H-антиген
 *      - материал                 кровь / моча / суточная моча / кал / ликвор
 *      - фракция                  свободный / общий, прямой / непрямой билирубин
 *      - условия культивирования  аэробно / анаэробно
 *      - объект                   бактерии / грибы / вирусы
 *      - метод учёта              культура / активность / антиген / генотипирование
 *      - количественность         quantitative / qualitative
 *
 * 3. Союз «и» здесь соединяет компоненты панели («ККС + ЦРП» = «КККС и ЦРП»),
 *    поэтому он шум, а не различитель — в отличие от услуг, где «верхнее ИЛИ
 *    нижнее веко» ≠ «верхнее И нижнее». Разделительное «или» вето сохраняет.
 *    Исключение: висящее в конце «I» — это уже не союз, а обозначение
 *    («Troponin I» ≠ «Troponin»), см. panelJoiners в общем модуле.
 *
 * Спорные решения, которые стоит знать
 * ------------------------------------
 * «culture» отнесён к различителям, хотя из-за этого теряются пары вида
 * «Urine Fungi» / «Urine Culture Fungi». Причина: без этого рядом встанут
 * «Urine» (общий анализ мочи) и «Urine Culture» (урокультура) — разные анализы,
 * и такую подсказку легко принять за дубль. «swab» наоборот оставлен мягким:
 * материал обычно и так подразумевается, а систематических семейств он не плодит.
 *
 * Тиры
 * ----
 *   A — совпали ≥2 языка, либо синоним вместе с одним языком
 *   B — совпал 1 язык, либо только синоним
 *   C — только нечёткое совпадение по английскому
 *
 * Usage:
 *   node scripts/labtests/find-duplicate-labtests.mjs            # записать в БД
 *   node scripts/labtests/find-duplicate-labtests.mjs --dry-run  # только отчёт
 */

import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import mysql from 'mysql2/promise';
import {
	NAME_COLUMNS,
	createTokenizer,
	dbConfigFromEnv,
	differsByDegreePrefix,
	findFuzzyPairs,
	findLanguageAgreements,
	fingerprintOf,
	lateralitySet,
	loadEnv,
	negationSet,
	numberMultiset,
	romanMultiset,
	singleLetterMultiset,
	trailingEnumerator,
	vocabularyMultiset,
} from '../common/dedup-text.mjs';

const __dirname = dirname(fileURLToPath(import.meta.url));
// Скрипт лежит в scripts/labtests/, до корня репозитория два уровня.
const ROOT = resolve(__dirname, '../..');

const DRY_RUN = process.argv.includes('--dry-run');

loadEnv(ROOT);

// ---------------------------------------------------------------------------
// Нормализация под каталог анализов
// ---------------------------------------------------------------------------

// Служебные слова и слова-пустышки. «test», «analysis», «level» ничего не
// добавляют к названию аналита: «Vitamin D» и «Vitamin D Level» — одно и то же.
//
// Артиклей «a» и «an» здесь намеренно нет: в названиях анализов одиночная буква
// почти всегда обозначение, а не артикль — «Vitamin A», «Hepatitis A»,
// «Strep A», «Salmonella Group A». Выбросив её как служебную, мы бы сравняли
// «Rapid Strep A» с «Rapid Strep Test».
const NOISE_TOKENS = new Set([
	'the', 'of', 'in', 'on', 'to', 'for', 'with',
	'sa', 'za', 'u', 'na', 'od', 'iz',
	'mit', 'der', 'die', 'das', 'des', 'von', 'fur',
	'ile',
	'test', 'tests', 'testing', 'analysis', 'analiza', 'analize',
	'level', 'levels', 'nivo', 'determination', 'odredjivanje', 'nalaz',
]);

const NEGATION_MARKERS = [
	'not including', 'not include', 'excluding', 'without',
	'ne ukljucujuci', 'ne ukljucuje', 'bez',
	'ne vkljuchaya', 'без', 'не включая',
	'ohne', 'ausser',
	'haric', 'dahil degil',
];

// Соединители перечислений: в названиях панелей «+» и «и» взаимозаменяемы.
const PANEL_JOINERS = new Set(['and', 'i', 'und', 've', 'и']);

// Разделительное «или» смысл меняет и остаётся различителем.
const DISJUNCTIONS = new Set(['or', 'ili', 'oder', 'veya', 'или']);

/**
 * Слова, определяющие ЧТО измеряется. Их набор обязан совпасть — иначе это
 * разные анализы, как бы похожи ни были названия.
 */
const ANALYTE_DISCRIMINATORS = new Set([
	// класс иммуноглобулина
	'igg', 'igm', 'iga', 'ige', 'igd',
	// материал
	'urine', 'urin', 'urina', '24h', 'blood', 'krv', 'krvi', 'serum', 'plasma',
	'plazma', 'stool', 'stolica', 'feces', 'saliva', 'pljuvacka', 'sputum',
	'csf', 'likvor', 'liquor', 'semen', 'sperm', 'sperma',
	// объект исследования
	'bacteria', 'bakterije', 'fungi', 'gljivice', 'virus', 'virusi',
	'parasites', 'paraziti', 'mycobacteria',
	// условия культивирования
	'aerobic', 'anaerobic', 'aerobni', 'anaerobni', 'aerobne', 'anaerobne',
	// фракция
	'free', 'total', 'slobodni', 'ukupni', 'direct', 'indirect',
	'conjugated', 'unconjugated', 'konjugovani',
	// количественность
	'quantitative', 'qualitative', 'kvantitativno', 'kvalitativno',
	'kvantitativni', 'kvalitativni',
	// метод учёта / что именно определяют
	'culture', 'kultura', 'activity', 'aktivnost', 'antigen', 'antigeni',
	'antibodies', 'antibody', 'antitijela', 'antitela',
	'genotyping', 'genotip', 'genotipizacija', 'avidity', 'aviditet',
	'mutation', 'mutacija', 'resistance', 'rezistencija', 'confirmation',
	'konfirmacija', 'immunophenotyping',
	// условия сбора
	'fasting', 'nataste', 'postprandial', 'tolerance', 'load',
	// охват панели
	'extended', 'prosireni', 'basic', 'osnovni', 'screening', 'skrining',
]);

// Отпечатки делаются разрешающим токенизатором (соединители панелей выброшены,
// чтобы «ККС + ЦРП» совпало с «ККС и ЦРП»)…
const tokenize = createTokenizer({
	noise: NOISE_TOKENS,
	negationMarkers: NEGATION_MARKERS,
	panelJoiners: PANEL_JOINERS,
});

// …а вето — строгим, который не выбрасывает ничего лишнего. Иначе «Herpes
// Simplex I IgM» теряет свою «I» как союз и становится похож на «Herpes Simplex
// II IgM», то есть на другой вирус. Вето считается только по name_en, где «i» —
// это всегда римская единица, а не сербское «и».
const vetoTokenize = createTokenizer({
	noise: NOISE_TOKENS,
	negationMarkers: NEGATION_MARKERS,
});

/**
 * Пара заведомо разных анализов? Вето сильнее любого совпадения отпечатков:
 * предложить слить IgG с IgM хуже, чем не найти настоящий дубль.
 */
function isVetoed(a, b) {
	const ta = a.vetoTokens;
	const tb = b.vetoTokens;

	if (
		vocabularyMultiset(ta, ANALYTE_DISCRIMINATORS) !==
		vocabularyMultiset(tb, ANALYTE_DISCRIMINATORS)
	) {
		return 'analyte';
	}
	if (numberMultiset(ta) !== numberMultiset(tb)) return 'numbers';
	// Одиночные буквы и римские цифры — серотипы, типы и группы:
	// Group A / B, Influenza A / B, O- / H-антиген, Herpes Simplex I / II.
	if (singleLetterMultiset(ta) !== singleLetterMultiset(tb)) return 'serotype';
	if (romanMultiset(ta) !== romanMultiset(tb)) return 'serotype';
	if (
		vocabularyMultiset(ta, DISJUNCTIONS) !== vocabularyMultiset(tb, DISJUNCTIONS)
	) {
		return 'disjunction';
	}
	if (lateralitySet(ta) !== lateralitySet(tb)) return 'laterality';
	if (negationSet(ta) !== negationSet(tb)) return 'negation-scope';
	if (trailingEnumerator(ta) !== trailingEnumerator(tb)) return 'enumerator';
	if (differsByDegreePrefix(a.enTokenSet, b.enTokenSet)) return 'degree-prefix';

	return null;
}

// Морфологические варианты, которыми разные импорты называли один материал.
const EN_SYNONYMS = new Map(
	Object.entries({
		nasal: 'nose', nose: 'nose',
		vulvar: 'vulva',
		umbilical: 'umbilicus',
		oropharyngeal: 'throat', pharyngeal: 'throat', pharynx: 'throat',
		cervix: 'cervical',
		vagina: 'vaginal',
		complete: '', count: '', kks: 'cbc',
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
			lt.id,
			lt.name_en, lt.name_sr, lt.name_sr_cyrl, lt.name_ru, lt.name_de, lt.name_tr,
			(SELECT GROUP_CONCAT(ltcr.category_id)
			   FROM lab_test_categories_relations ltcr
			  WHERE ltcr.lab_test_id = lt.id) AS cats,
			(SELECT GROUP_CONCAT(clt.clinic_id)
			   FROM clinic_lab_tests clt
			  WHERE clt.lab_test_id = lt.id) AS clinics
		FROM lab_tests lt
		ORDER BY lt.id
	`);

	const labTests = rows.map((r) => {
		const enTokens = tokenize(r.name_en);
		const vetoTokens = vetoTokenize(r.name_en);
		return {
			id: r.id,
			names: r,
			enTokens,
			vetoTokens,
			enTokenSet: new Set(vetoTokens),
			fuzzySet: new Set(foldSynonyms(enTokens)),
			cats: new Set((r.cats || '').split(',').filter(Boolean)),
			clinics: new Set((r.clinics || '').split(',').filter(Boolean)),
		};
	});
	const byId = new Map(labTests.map((t) => [t.id, t]));

	console.log(`Loaded ${labTests.length} lab tests`);

	const pairKey = (a, b) => (a < b ? `${a}|${b}` : `${b}|${a}`);

	// --- Сигнал 1: согласие языковых колонок ------------------------------
	const candidates = findLanguageAgreements(labTests, tokenize);

	// --- Сигнал 2: нечёткое совпадение по английскому ---------------------
	for (const [idA, idB, score] of findFuzzyPairs(labTests, FUZZY_THRESHOLD)) {
		const key = pairKey(idA, idB);
		if (!candidates.has(key)) candidates.set(key, new Set());
		candidates.get(key).add(`fuzzy-en:${score.toFixed(2)}`);
	}

	// --- Сигнал 3: синоним одного анализа = название другого --------------
	// Синонимы заводились руками, поэтому такое совпадение сильнее любого
	// автоматического.
	const fingerprintToIds = new Map();
	for (const t of labTests) {
		for (const column of NAME_COLUMNS) {
			const fp = fingerprintOf(
				tokenize(t.names[column], { translit: column === 'name_sr_cyrl' }),
			);
			if (!fp) continue;
			if (!fingerprintToIds.has(fp)) fingerprintToIds.set(fp, new Set());
			fingerprintToIds.get(fp).add(t.id);
		}
	}

	const [synonymRows] = await connection.execute(
		`SELECT lab_test_id, another_name, language FROM lab_test_synonyms
		 WHERE another_name IS NOT NULL AND lab_test_id IS NOT NULL`,
	);
	for (const s of synonymRows) {
		const fp = fingerprintOf(
			tokenize(s.another_name, { translit: s.language === 'sr-cyrl' }),
		);
		if (!fp) continue;
		for (const otherId of fingerprintToIds.get(fp) || []) {
			if (otherId === s.lab_test_id) continue;
			const key = pairKey(s.lab_test_id, otherId);
			if (!candidates.has(key)) candidates.set(key, new Set());
			candidates.get(key).add('synonym-match');
		}
	}

	// --- Оценка, вето, тиры -----------------------------------------------
	const vetoStats = new Map();
	const accepted = [];

	for (const [key, signalSet] of candidates) {
		const [idA, idB] = key.split('|').map(Number);
		const a = byId.get(idA);
		const b = byId.get(idB);
		if (!a || !b) continue;

		const veto = isVetoed(a, b);
		if (veto) {
			vetoStats.set(veto, (vetoStats.get(veto) || 0) + 1);
			continue;
		}

		const signals = [...signalSet];
		const langHits = signals.filter((s) => s.startsWith('lang:'));
		const hasSynonymMatch = signals.includes('synonym-match');

		// Одна клиника не сдаёт один анализ дважды: если обе половинки висят
		// на общей клинике, они пришли из разных проходов импорта.
		const sharedClinics = [...a.clinics].filter((c) => b.clinics.has(c));
		if (sharedClinics.length) signals.push(`same-clinic:${sharedClinics.length}`);

		const sharedCats = [...a.cats].filter((c) => b.cats.has(c));
		if (sharedCats.length) signals.push(`same-category:${sharedCats.join('/')}`);

		// Синоним сам по себе в тир A не поднимает. Синонимы в базе включают и
		// родовые термины («Опиаты» ← «Морфин»), и совпадающие аббревиатуры
		// (AST — и аспартатаминотрансфераза, и antimicrobial susceptibility
		// testing), так что в одиночку он даёт ложные пары. В паре с языковым
		// совпадением — уже надёжно.
		const tier =
			langHits.length >= 2 || (hasSynonymMatch && langHits.length >= 1)
				? 'A'
				: langHits.length === 1 || hasSynonymMatch
					? 'B'
					: 'C';

		const score =
			langHits.length * 10 +
			(hasSynonymMatch ? 6 : 0) +
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
	console.log(`  tier A (>=2 languages, or synonym + 1): ${byTier.A}`);
	console.log(`  tier B (1 language, or synonym alone):  ${byTier.B}`);
	console.log(`  tier C (fuzzy English only):            ${byTier.C}`);
	console.log('');
	console.log('Vetoed pairs (deliberately different tests):');
	for (const [reason, n] of [...vetoStats].sort((x, y) => y[1] - x[1])) {
		console.log(`  ${reason.padEnd(16)} ${n}`);
	}

	console.log('');
	console.log('--- top 25 by score ---');
	for (const p of accepted.slice(0, 25)) {
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
				`INSERT INTO lab_test_duplicate_candidates
					(lab_test_id_a, lab_test_id_b, tier, score, signals)
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
			`SELECT COUNT(*) AS pending FROM lab_test_duplicate_candidates WHERE status = 'pending'`,
		);
		console.log(`\nWritten to lab_test_duplicate_candidates.`);
		console.log(`  new pairs: ${inserted}`);
		console.log(`  pending review overall: ${pending}`);
	}
} finally {
	await connection.end();
}
