/**
 * Общие примитивы для детекторов дубликатов каталога (услуги, анализы).
 *
 * Здесь только текст и вето-хелперы — сигналы, скоринг и запись в БД у каждого
 * каталога свои, потому что различают их разные вещи: услуги — сторона тела и
 * номер варианта, анализы — класс иммуноглобулина, серотип и материал.
 *
 * Ключевая идея нормализации: отпечаток названия — это мультимножество токенов,
 * то есть сравнение не зависит от порядка слов. У этого есть одна ловушка,
 * ради которой существует вся возня с сегментами и neg:-префиксами:
 * «X (без Y)» и «Y (без X)» дают одинаковый набор слов. Без пометки области
 * отрицания такая пара выглядит идеальным дублем сразу в нескольких языках.
 */

import { readFileSync, existsSync } from 'node:fs';
import { resolve } from 'node:path';

// ---------------------------------------------------------------------------
// .env
// ---------------------------------------------------------------------------

/**
 * Читает .env из корня репозитория в process.env.
 * ROOT передаётся вызывающим: скрипты лежат в подпапках scripts/*, и путь до
 * корня у них не общий.
 */
export function loadEnv(root) {
	const envPath = resolve(root, '.env');
	if (!existsSync(envPath)) {
		console.warn(`WARN: .env not found at ${envPath}, falling back to defaults`);
		return;
	}
	for (const line of readFileSync(envPath, 'utf-8').split('\n')) {
		const m = line.match(/^\s*([A-Z_][A-Z0-9_]*)\s*=\s*(.*)/);
		if (m) process.env[m[1]] = m[2].trim();
	}
}

export function dbConfigFromEnv() {
	return {
		host: process.env.DB_HOST || 'localhost',
		user: process.env.DB_USER || 'root',
		password: process.env.DB_PASSWORD || '',
		database: process.env.DB_NAME || 'docta_me',
		port: Number(process.env.DB_PORT) || 3306,
		charset: 'utf8mb4',
	};
}

// ---------------------------------------------------------------------------
// Нормализация
// ---------------------------------------------------------------------------

export const NAME_COLUMNS = [
	'name_en',
	'name_sr',
	'name_sr_cyrl',
	'name_ru',
	'name_de',
	'name_tr',
];

// Сербская кириллица → латиница, чтобы name_sr_cyrl сравнивался с name_sr.
// Порядок важен: диграфы (љ, њ, џ) раскрываются в две буквы.
const CYR_TO_LAT = {
	а: 'a', б: 'b', в: 'v', г: 'g', д: 'd', ђ: 'dj', е: 'e', ж: 'z', з: 'z',
	и: 'i', ј: 'j', к: 'k', л: 'l', љ: 'lj', м: 'm', н: 'n', њ: 'nj', о: 'o',
	п: 'p', р: 'r', с: 's', т: 't', ћ: 'c', у: 'u', ф: 'f', х: 'h', ц: 'c',
	ч: 'c', џ: 'dz', ш: 's',
};

export function transliterate(str) {
	let out = '';
	for (const ch of str) out += CYR_TO_LAT[ch] ?? ch;
	return out;
}

// đ не разлагается через NFD, снимаем явно. Остальную диакритику — нормализацией.
export function foldDiacritics(str) {
	return str
		.replace(/đ/g, 'dj')
		.replace(/ć|č/g, 'c')
		.replace(/š/g, 's')
		.replace(/ž/g, 'z')
		.normalize('NFD')
		.replace(/[̀-ͯ]/g, '');
}

// Скобки, тире и запятые ограничивают уточнения вида «(без кисти)».
export function splitSegments(str) {
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
 * Собирает токенизатор под конкретный каталог.
 *
 * @param {object} config
 * @param {Set<string>} config.noise           служебные слова, выбрасываются всегда
 * @param {string[]}    config.negationMarkers маркеры отрицания; сегмент с любым из
 *                      них помечает свои токены префиксом neg:
 * @param {Set<string>} [config.panelJoiners]  соединители перечислений («and», «i»,
 *                      «+»): выбрасываются, КРОМЕ случая, когда стоят последним
 *                      токеном названия — там это уже номер варианта, а не союз
 *                      («Troponin I» ≠ «Troponin»).
 */
export function createTokenizer({ noise, negationMarkers, panelJoiners }) {
	return function tokenize(raw, { translit = false } = {}) {
		if (!raw) return [];
		let s = raw.toLowerCase();
		if (translit) s = transliterate(s);
		s = foldDiacritics(s);

		// Последний значимый токен нужен заранее: по нему решается судьба
		// висящего в конце «i».
		const flat = rawTokens(s.replace(/[()\[\],;]|—|–/g, ' '));
		const lastToken = flat.length ? flat[flat.length - 1] : '';

		const out = [];
		for (const segment of splitSegments(s)) {
			const negated = negationMarkers.some((m) => segment.includes(m));
			for (const t of rawTokens(segment)) {
				if (noise.has(t)) continue;
				// Сам маркер отрицания в отпечаток не попадает — важна область,
				// а не формулировка («без» / «ohne» / «hariç» дали бы разные токены).
				if (negationMarkers.includes(t)) continue;
				if (panelJoiners?.has(t) && t !== lastToken) continue;
				out.push(negated ? `neg:${t}` : t);
			}
		}
		return out;
	};
}

export function fingerprintOf(tokens) {
	if (!tokens.length) return '';
	return [...tokens].sort().join(' ');
}

export function jaccard(setA, setB) {
	let shared = 0;
	for (const t of setA) if (setB.has(t)) shared++;
	const union = setA.size + setB.size - shared;
	return union === 0 ? 0 : shared / union;
}

// ---------------------------------------------------------------------------
// Вето-хелперы
// ---------------------------------------------------------------------------

export const LATERALITY = new Set([
	'left', 'right', 'bilateral',
	'lijevi', 'lijeva', 'lijevo', 'levi', 'leva', 'desni', 'desna', 'desno',
	'obostrano', 'oba', 'obje',
	'links', 'rechts', 'beidseitig',
	'sol', 'sag',
	'левый', 'левая', 'правый', 'правая', 'оба',
]);

export const ROMAN = new Set(['i', 'ii', 'iii', 'iv', 'v', 'vi', 'vii', 'viii']);

// Приставки степени: «полуинтенсивная» ≠ «интенсивная», «реампутация» ≠ «ампутация».
export const DEGREE_PREFIXES = ['polu', 'semi', 're', 'pseudo', 'sub', 'mikro', 'micro'];

const bare = (t) => t.replace(/^neg:/, '');

/** Числа различают дозы, объёмы, границы диапазонов и размеры панелей. */
export function numberMultiset(tokens) {
	return tokens
		.filter((t) => /^\d+$/.test(bare(t)))
		.map(bare)
		.sort()
		.join(',');
}

/**
 * Одиночные буквы: серотипы и группы («Salmonella Group A» / «Group B»,
 * «Influenza A» / «Influenza B», O- и H-антигены). Совпадающий набор вето не даёт,
 * поэтому «Vitamin D» с «Vitamin D» не пострадает.
 */
export function singleLetterMultiset(tokens) {
	return tokens
		.filter((t) => /^[a-z]$/.test(bare(t)))
		.map(bare)
		.sort()
		.join(',');
}

/**
 * Римские цифры в любом месте названия: «Herpes Simplex I» ≠ «Herpes Simplex II»,
 * «Factor VIII» ≠ «Factor IX». Одного trailingEnumerator тут мало — обозначение
 * типа часто стоит в середине («Herpes Simplex II IgG»).
 */
export function romanMultiset(tokens) {
	return tokens
		.filter((t) => ROMAN.has(bare(t)))
		.map(bare)
		.sort()
		.join(',');
}

export function lateralitySet(tokens) {
	return [...new Set(tokens.filter((t) => LATERALITY.has(bare(t))))].sort().join(',');
}

export function negationSet(tokens) {
	return [...new Set(tokens.filter((t) => t.startsWith('neg:')))].sort().join(',');
}

/** Набор токенов из заданного словаря — то, что обязано совпадать. */
export function vocabularyMultiset(tokens, vocabulary) {
	return tokens
		.filter((t) => vocabulary.has(bare(t)))
		.map(bare)
		.sort()
		.join(',');
}

/**
 * Хвостовой перечислитель: «Wound Dressing I», «Procedure A», «Tier II».
 * Одиночная римская цифра или буква в конце — номер варианта, а не слово.
 * Внутри строки 'i' в сербском значит «и», поэтому смотрим только последний токен.
 */
export function trailingEnumerator(tokens) {
	if (!tokens.length) return '';
	const last = bare(tokens[tokens.length - 1]);
	if (ROMAN.has(last) || /^[a-z]$/.test(last)) return last;
	return '';
}

/**
 * Одно название получается из другого добавлением приставки степени
 * («intenzivna» → «poluintenzivna», «amputacija» → «reamputacija»).
 */
export function differsByDegreePrefix(setA, setB) {
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

// ---------------------------------------------------------------------------
// Генерация пар-кандидатов
// ---------------------------------------------------------------------------

/**
 * Нечёткие пары по мешку токенов. Полный обход квадратичен (у услуг это 13 млн
 * пар), поэтому сначала блокируем по редким токенам: сравниваем только тех, кто
 * делит хотя бы один из своих трёх самых редких токенов.
 *
 * @param {Array<{id:number, fuzzySet:Set<string>}>} items
 * @param {number} threshold минимальный Жаккар
 * @param {number} [maxBucket] корзины крупнее считаем бесполезными — общий токен
 *                 ничего не отсекает, а пар даёт квадратично много
 * @returns {Array<[number, number, number]>} [idA, idB, jaccard]
 */
export function findFuzzyPairs(items, threshold, maxBucket = 400) {
	const docFreq = new Map();
	for (const it of items) {
		for (const t of it.fuzzySet) docFreq.set(t, (docFreq.get(t) || 0) + 1);
	}

	const buckets = new Map();
	for (const it of items) {
		if (!it.fuzzySet.size) continue;
		const rarest = [...it.fuzzySet]
			.sort((x, y) => (docFreq.get(x) || 0) - (docFreq.get(y) || 0))
			.slice(0, 3);
		for (const t of rarest) {
			if (!buckets.has(t)) buckets.set(t, []);
			buckets.get(t).push(it);
		}
	}

	const seen = new Set();
	const pairs = [];
	for (const bucket of buckets.values()) {
		if (bucket.length > maxBucket) continue;
		for (let i = 0; i < bucket.length; i++) {
			for (let j = i + 1; j < bucket.length; j++) {
				const a = bucket[i];
				const b = bucket[j];
				const key = a.id < b.id ? `${a.id}|${b.id}` : `${b.id}|${a.id}`;
				if (seen.has(key)) continue;
				seen.add(key);
				const score = jaccard(a.fuzzySet, b.fuzzySet);
				if (score >= threshold) pairs.push([a.id, b.id, score]);
			}
		}
	}
	return pairs;
}

/**
 * Пары, у которых совпал отпечаток хотя бы в одной языковой колонке.
 * @returns {Map<string, Set<string>>} 'idA|idB' → набор колонок
 */
export function findLanguageAgreements(items, tokenize) {
	const agreements = new Map();
	for (const column of NAME_COLUMNS) {
		const buckets = new Map();
		for (const it of items) {
			const fp = fingerprintOf(
				tokenize(it.names[column], { translit: column === 'name_sr_cyrl' }),
			);
			if (!fp) continue;
			if (!buckets.has(fp)) buckets.set(fp, []);
			buckets.get(fp).push(it.id);
		}
		for (const ids of buckets.values()) {
			if (ids.length < 2) continue;
			for (let i = 0; i < ids.length; i++) {
				for (let j = i + 1; j < ids.length; j++) {
					const a = ids[i];
					const b = ids[j];
					const key = a < b ? `${a}|${b}` : `${b}|${a}`;
					if (!agreements.has(key)) agreements.set(key, new Set());
					agreements.get(key).add(`lang:${column}`);
				}
			}
		}
	}
	return agreements;
}
