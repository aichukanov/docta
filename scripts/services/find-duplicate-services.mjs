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

import { readFileSync, existsSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import mysql from 'mysql2/promise';

const __dirname = dirname(fileURLToPath(import.meta.url));
// Скрипт лежит в scripts/services/, до корня репозитория два уровня.
const ROOT = resolve(__dirname, '../..');

const DRY_RUN = process.argv.includes('--dry-run');

// ---------------------------------------------------------------------------
// Load .env
// ---------------------------------------------------------------------------
const envPath = resolve(ROOT, '.env');
if (existsSync(envPath)) {
	for (const line of readFileSync(envPath, 'utf-8').split('\n')) {
		const m = line.match(/^\s*([A-Z_][A-Z0-9_]*)\s*=\s*(.*)/);
		if (m) process.env[m[1]] = m[2].trim();
	}
} else {
	console.warn(`WARN: .env not found at ${envPath}, falling back to defaults`);
}

const LANGS = [
	'name_en',
	'name_sr',
	'name_sr_cyrl',
	'name_ru',
	'name_de',
	'name_tr',
];

// ---------------------------------------------------------------------------
// Нормализация
// ---------------------------------------------------------------------------

// Сербская кириллица → латиница, чтобы name_sr_cyrl сравнивался с name_sr.
// Порядок важен: диграфы (љ, њ, џ) раскрываются в две буквы.
const CYR_TO_LAT = {
	а: 'a', б: 'b', в: 'v', г: 'g', д: 'd', ђ: 'dj', е: 'e', ж: 'z', з: 'z',
	и: 'i', ј: 'j', к: 'k', л: 'l', љ: 'lj', м: 'm', н: 'n', њ: 'nj', о: 'o',
	п: 'p', р: 'r', с: 's', т: 't', ћ: 'c', у: 'u', ф: 'f', х: 'h', ц: 'c',
	ч: 'c', џ: 'dz', ш: 's',
};

function transliterate(str) {
	let out = '';
	for (const ch of str) out += CYR_TO_LAT[ch] ?? ch;
	return out;
}

// đ не разлагается через NFD, снимаем явно. Остальную диакритику — нормализацией.
function foldDiacritics(str) {
	return str
		.replace(/đ/g, 'dj')
		.replace(/ć|č/g, 'c')
		.replace(/š/g, 's')
		.replace(/ž/g, 'z')
		.normalize('NFD')
		.replace(/[̀-ͯ]/g, '');
}

// Служебные слова, не несущие смысла при сравнении названий.
// Союзы and/or сюда НЕ входят: «верхнее ИЛИ нижнее веко» и «верхнее И нижнее» —
// разные услуги с разной ценой, они разводятся вето-правилом.
const NOISE_TOKENS = new Set([
	'the', 'of', 'a', 'an', 'in', 'on', 'to', 'for', 'with',
	'sa', 'za', 'u', 'na', 'od', 'iz',
	'mit', 'der', 'die', 'das', 'des', 'von', 'fur',
	'ile',
]);

// Маркеры отрицания. Если сегмент названия содержит любой из них, все его
// значимые токены помечаются префиксом neg: — иначе мультимножество токенов
// схлопывает «МРТ кисти (без запястья)» и «МРТ запястья (без кисти)» в один
// отпечаток. Это реальный false positive, проходивший сразу по двум языкам.
// Работаем на уровне сегмента, а не позиции: в турецком «hariç» стоит после
// исключаемого слова, а не перед ним.
const NEGATION_MARKERS = [
	'not including', 'not include', 'excluding', 'without',
	'ne ukljucujuci', 'ne ukljucuje', 'bez',
	'ne vkljuchaya', 'без', 'не включая',
	'ohne', 'ausser',
	'haric', 'dahil degil',
];

function splitSegments(str) {
	// Скобки, тире и запятые ограничивают уточнения вида «(без кисти)».
	return str
		.split(/[()\[\],;]|—|–|\s-\s/)
		.map((s) => s.trim())
		.filter(Boolean);
}

function rawTokens(segment) {
	return segment
		.replace(/[^a-z0-9Ѐ-ӿ]+/g, ' ')
		.split(' ')
		.filter(Boolean);
}

/**
 * Токены названия с пометкой отрицания.
 * Возвращает массив вида ['mr', 'sake', 'neg:rucni', 'neg:zglob'].
 */
function tokenize(raw, { translit = false } = {}) {
	if (!raw) return [];
	let s = raw.toLowerCase();
	if (translit) s = transliterate(s);
	s = foldDiacritics(s);

	const out = [];
	for (const segment of splitSegments(s)) {
		const negated = NEGATION_MARKERS.some((m) => segment.includes(m));
		for (const t of rawTokens(segment)) {
			if (NOISE_TOKENS.has(t)) continue;
			// Сам маркер отрицания в отпечаток не попадает — важна область,
			// а не формулировка («без» / «ohne» / «hariç» дали бы разные токены).
			if (NEGATION_MARKERS.some((m) => m === t)) continue;
			out.push(negated ? `neg:${t}` : t);
		}
	}
	return out;
}

function fingerprint(raw, opts) {
	const t = tokenize(raw, opts);
	if (!t.length) return '';
	return [...t].sort().join(' ');
}

// ---------------------------------------------------------------------------
// Вето: признаки, по которым услуги заведомо различаются
// ---------------------------------------------------------------------------

const LATERALITY = new Set([
	'left', 'right', 'bilateral',
	'lijevi', 'lijeva', 'lijevo', 'levi', 'leva', 'desni', 'desna', 'desno',
	'obostrano', 'oba', 'obje',
	'links', 'rechts', 'beidseitig',
	'sol', 'sag',
	'левый', 'левая', 'правый', 'правая', 'оба',
]);

const CONJUNCTIONS = new Set(['and', 'or', 'i', 'ili', 'und', 'oder', 'и', 'или', 've', 'veya']);

const ROMAN = new Set(['i', 'ii', 'iii', 'iv', 'v', 'vi', 'vii', 'viii']);

// Приставки степени: «полуинтенсивная» ≠ «интенсивная», «реампутация» ≠ «ампутация».
const DEGREE_PREFIXES = ['polu', 'semi', 're', 'pseudo', 'sub', 'mikro', 'micro'];

function numberMultiset(tokens) {
	return tokens
		.filter((t) => /^\d+$/.test(t.replace(/^neg:/, '')))
		.map((t) => t.replace(/^neg:/, ''))
		.sort()
		.join(',');
}

function conjunctionMultiset(tokens) {
	return tokens
		.filter((t) => CONJUNCTIONS.has(t.replace(/^neg:/, '')))
		.sort()
		.join(',');
}

function lateralitySet(tokens) {
	return [...new Set(tokens.filter((t) => LATERALITY.has(t.replace(/^neg:/, ''))))]
		.sort()
		.join(',');
}

function negationSet(tokens) {
	return [...new Set(tokens.filter((t) => t.startsWith('neg:')))].sort().join(',');
}

/**
 * Хвостовой перечислитель: «Wound Dressing I», «Procedure A», «Tier II».
 * Одиночная римская цифра или одиночная буква в конце названия — это номер
 * варианта услуги, а не слово. Внутри строки 'i' в сербском значит «и»,
 * поэтому смотрим только на последний токен.
 */
function trailingEnumerator(tokens) {
	if (!tokens.length) return '';
	const last = tokens[tokens.length - 1].replace(/^neg:/, '');
	if (ROMAN.has(last) || /^[a-z]$/.test(last)) return last;
	return '';
}

/**
 * Одно название получается из другого добавлением приставки степени
 * («intenzivna» → «poluintenzivna», «amputacija» → «reamputacija»).
 */
function differsByDegreePrefix(setA, setB) {
	const onlyA = [...setA].filter((t) => !setB.has(t));
	const onlyB = [...setB].filter((t) => !setA.has(t));
	for (const [from, to] of [
		[onlyA, setB],
		[onlyB, setA],
	]) {
		for (const t of from) {
			for (const p of DEGREE_PREFIXES) {
				if (to.has(p + t)) return true;
			}
		}
	}
	return false;
}

/**
 * Пара заведомо разных услуг? Вето сильнее любого совпадения отпечатков:
 * лучше не показать настоящий дубль, чем предложить слить «Tier I» с «Tier II».
 */
function isVetoed(a, b) {
	const ta = a.enTokens;
	const tb = b.enTokens;

	if (numberMultiset(ta) !== numberMultiset(tb)) return 'numbers';
	if (conjunctionMultiset(ta) !== conjunctionMultiset(tb)) return 'conjunction';
	if (lateralitySet(ta) !== lateralitySet(tb)) return 'laterality';
	if (negationSet(ta) !== negationSet(tb)) return 'negation-scope';
	if (trailingEnumerator(ta) !== trailingEnumerator(tb)) return 'enumerator';
	if (differsByDegreePrefix(a.enTokenSet, b.enTokenSet)) return 'degree-prefix';

	return null;
}

// ---------------------------------------------------------------------------
// Нечёткое сравнение по английскому (генерация кандидатов для тира C)
// ---------------------------------------------------------------------------

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
		const bare = t.replace(/^neg:/, '');
		const mapped = EN_SYNONYMS.has(bare) ? EN_SYNONYMS.get(bare) : bare;
		if (!mapped) continue;
		out.push(t.startsWith('neg:') ? `neg:${mapped}` : mapped);
	}
	return out;
}

function jaccard(setA, setB) {
	let shared = 0;
	for (const t of setA) if (setB.has(t)) shared++;
	const union = setA.size + setB.size - shared;
	return union === 0 ? 0 : shared / union;
}

const FUZZY_THRESHOLD = 0.72;

// ---------------------------------------------------------------------------
// Основной проход
// ---------------------------------------------------------------------------

const connection = await mysql.createConnection({
	host: process.env.DB_HOST || 'localhost',
	user: process.env.DB_USER || 'root',
	password: process.env.DB_PASSWORD || '',
	database: process.env.DB_NAME || 'docta_me',
	port: Number(process.env.DB_PORT) || 3306,
	charset: 'utf8mb4',
});

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

	// pairKey -> Set<signal>
	const candidates = new Map();
	const pairKey = (a, b) => (a < b ? `${a}|${b}` : `${b}|${a}`);
	const addSignal = (a, b, signal) => {
		const k = pairKey(a, b);
		if (!candidates.has(k)) candidates.set(k, new Set());
		candidates.get(k).add(signal);
	};

	// --- Сигнал 1: согласие языковых колонок ------------------------------
	for (const lang of LANGS) {
		const buckets = new Map();
		for (const s of services) {
			const fp = fingerprint(s.names[lang], { translit: lang === 'name_sr_cyrl' });
			if (!fp) continue;
			if (!buckets.has(fp)) buckets.set(fp, []);
			buckets.get(fp).push(s.id);
		}
		for (const ids of buckets.values()) {
			if (ids.length < 2) continue;
			for (let i = 0; i < ids.length; i++) {
				for (let j = i + 1; j < ids.length; j++) {
					addSignal(ids[i], ids[j], `lang:${lang}`);
				}
			}
		}
	}

	// --- Сигнал 2: нечёткое совпадение по английскому ---------------------
	// Блокируем по редкому токену, иначе 5231² пар.
	const docFreq = new Map();
	for (const s of services) {
		for (const t of s.fuzzySet) docFreq.set(t, (docFreq.get(t) || 0) + 1);
	}
	const blocks = new Map();
	for (const s of services) {
		if (!s.fuzzySet.size) continue;
		const rarest = [...s.fuzzySet]
			.sort((x, y) => (docFreq.get(x) || 0) - (docFreq.get(y) || 0))
			.slice(0, 3);
		for (const t of rarest) {
			if (!blocks.has(t)) blocks.set(t, []);
			blocks.get(t).push(s);
		}
	}
	const comparedPairs = new Set();
	for (const bucket of blocks.values()) {
		// Слишком крупные корзины — общий токен, ничего не отсекает.
		if (bucket.length > 400) continue;
		for (let i = 0; i < bucket.length; i++) {
			for (let j = i + 1; j < bucket.length; j++) {
				const a = bucket[i];
				const b = bucket[j];
				const k = pairKey(a.id, b.id);
				if (comparedPairs.has(k)) continue;
				comparedPairs.add(k);
				const j2 = jaccard(a.fuzzySet, b.fuzzySet);
				if (j2 >= FUZZY_THRESHOLD) {
					addSignal(a.id, b.id, `fuzzy-en:${j2.toFixed(2)}`);
				}
			}
		}
	}

	// --- Оценка, вето, тиры -----------------------------------------------
	const vetoStats = new Map();
	const accepted = [];

	for (const [k, signalSet] of candidates) {
		const [idA, idB] = k.split('|').map(Number);
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
