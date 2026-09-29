/**
 * sr → sr_cyrl для названий услуг.
 *
 * Голый `toCyrillic` (common/serbian-transliteration.ts) для названий не годится:
 *   - `x y w q` в сербском алфавите нет, и он оставляет их латиницей ВНУТРИ
 *     кириллического слова: `Botox` → «Ботоx», `Swim-Up` → «Сwим-Уп». Такое слово
 *     не находится кириллическим запросом — поиск алфавит не складывает;
 *   - `nj` на стыке приставки он читает как «њ»: `injekcija` → «ињекција»,
 *     а по правопису «инјекција» (так же «конјунктива»);
 *   - аббревиатуру он транслитерирует по буквам: `MSCT` → «МСЦТ», а в каталоге
 *     принято «МСКТ» (компјутеризована — через «к»);
 *   - латинские термины и эпонимы он разбирает по буквам: `thoracicusa` →
 *     «тхорацицуса», `Asherman` → «Асхерман».
 *
 * Решения каталога выучиваются из него же: в name_sr_cyrl уже есть
 * «МСКТ», «Ботокс», латинские `RTG` и `Ivoclar`. Выучиваются только
 * «иностранные» токены — аббревиатуры, слова с x/y/w/q/th/ph/ch/sh/ae/oe/ck,
 * имена с заглавной не в начале названия. Обычные сербские слова не
 * выучиваются: иначе словарь впитал бы экавицу («lijeka» → «лека») и
 * повторяющиеся опечатки партии FZOCG («Torakoskopska» → «Тораскопска»).
 */

import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { createJiti } from 'jiti';
import { PROTECTED_LATIN_TOKENS } from './sr-cyrl-protected.mjs';
import { EKAVICA, mixedScriptWords, tokens } from './service-name-rules.mjs';

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '..', '..');
const { toCyrillic, toLatin } = await createJiti(import.meta.url).import(resolve(ROOT, 'common/serbian-transliteration.ts'));

const MARK = String.fromCharCode(1);
const MARK_RE = new RegExp(`${MARK}(\\d+)${MARK}`, 'g');
const WORD = /[\p{L}\p{N}][\p{L}\p{N}-]*/gu;
const ASCII_WORD = /^[A-Za-z0-9-]+$/;
/**
 * Не бывает в сербском слове: x y w q, диграфы th ph ch sh ae oe ck и удвоенные
 * согласные (Monteggia, Caldwell, Straumann). «dd» и «jj» не входят — они
 * законно возникают на стыке приставки: poddijafragmalni, najjači.
 */
const FOREIGN = /[xywq]|th|ph|ch|sh|ae|oe|ck|([bcfgklmnprstvz])\1/i;

/** Латинские обороты в названиях: транслитерация ломает их в «ex темпоре». */
const LATIN_PHRASES = ['ex tempore', 'in situ', 'vena cava', 'Roux-en-Y', 'per os', 'ductus thoracicus'];
/** Сколько раз и с какой долей каталог должен записать токен одинаково, чтобы это считалось решением. */
const MIN_SUPPORT = 2;
const MIN_SHARE = 0.6;
/** Слово sr, которое в каталоге встречается реже, считается редким: его ручную транскрипцию не трогаем. */
const RARE = 3;

/** «nj» на стыке приставки (in-, kon-) — это «н» + «ј», а не «њ». */
const NJ_EXCEPTIONS = [
	[/ињек/g, 'инјек'], [/Ињек/g, 'Инјек'], [/ИЊЕК/g, 'ИНЈЕК'],
	[/ињиц/g, 'инјиц'], [/Ињиц/g, 'Инјиц'],
	[/коњункт/g, 'конјункт'], [/Коњункт/g, 'Конјункт'],
];

const MULTIWORD_PROTECTED = [...LATIN_PHRASES, ...PROTECTED_LATIN_TOKENS.filter((t) => /\s/.test(t))];
const SINGLE_PROTECTED = new Set(PROTECTED_LATIN_TOKENS.filter((t) => !/\s/.test(t)));

const escapeRe = (s) => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
const hasLetter = (s) => /[A-Za-z]/.test(s);
const isAsciiWord = (s) => ASCII_WORD.test(s) && hasLetter(s);
const hasCyrillic = (s) => /\p{Script=Cyrillic}/u.test(s);
const fold = (s) => s.toLowerCase().normalize('NFD').replace(/\p{M}/gu, '').replace(/đ/g, 'dj');

/**
 * Одно и то же слово в разной орфографии: диакритика, «ij» перед гласной
 * («radijus» / «radius»), «ps» / «bs» («apscesa» / «abscesa»).
 */
const variantKey = (s) => fold(s).replace(/ij(?=[aeiou])/g, 'i').replace(/bs/g, 'ps');

/** Отличие только в яте: «cevčice» против «cjevčice». Такое не выучиваем — это экавица. */
const jatOnly = (lat, sr) => lat !== sr && fold(lat) === fold(sr).replace(/ije/g, 'e').replace(/(?<=[^aeiou])je/g, 'e');
const isEkavian = (lat) => tokens(lat).some((t) => EKAVICA.has(t));

/** Токен, решение по которому имеет смысл выучить: аббревиатура, иностранное слово, имя. */
const learnable = (token, position) =>
	isAsciiWord(token) &&
	(/^[A-Z0-9-]+$/.test(token) && (token.match(/[A-Z]/g) || []).length >= 2 ||
		FOREIGN.test(token) ||
		(position > 0 && /^[A-Z][a-z]/.test(token)));

/**
 * @param {{ name_sr: string, name_sr_cyrl: string }[]} rows — весь каталог
 */
export function createNameTransliterator(rows) {
	// ── Словарь решений каталога по «иностранным» токенам.
	const seen = new Map();
	const srWordFreq = new Map();
	for (const { name_sr: sr, name_sr_cyrl: cyr } of rows) {
		if (!sr) continue;
		for (const w of sr.match(WORD) || []) srWordFreq.set(w, (srWordFreq.get(w) || 0) + 1);
		if (!cyr) continue;
		const sTok = sr.match(WORD) || [];
		const cTok = cyr.match(WORD) || [];
		if (sTok.length !== cTok.length) continue;
		sTok.forEach((s, i) => {
			if (!learnable(s, i)) return;
			const c = cTok[i];
			if (mixedScriptWords(c).length) return;
			if (!seen.has(s)) seen.set(s, new Map());
			seen.get(s).set(c, (seen.get(s).get(c) || 0) + 1);
		});
	}
	const learned = new Map();
	for (const [s, variants] of seen) {
		const total = [...variants.values()].reduce((a, b) => a + b, 0);
		const [best, n] = [...variants].sort((a, b) => b[1] - a[1])[0];
		if (n >= MIN_SUPPORT && n / total >= MIN_SHARE) learned.set(s, best);
	}

	const render = (token) => {
		if (learned.has(token)) return learned.get(token);
		if (SINGLE_PROTECTED.has(token) || FOREIGN.test(token)) return token;
		return null;
	};

	function transliterate(text) {
		if (!text) return text;
		const parked = [];
		const park = (match) => {
			parked.push(match);
			return `${MARK}${parked.length - 1}${MARK}`;
		};
		let masked = text;
		for (const phrase of MULTIWORD_PROTECTED) {
			masked = masked.replace(
				new RegExp(`(^|[^\\p{L}\\p{N}])(${escapeRe(phrase)})(?=$|[^\\p{L}\\p{N}])`, 'gu'),
				(_, before, match) => `${before}${park(match)}`,
			);
		}
		masked = masked.replace(WORD, (token) => {
			if (!isAsciiWord(token)) return token;
			const fixed = render(token);
			return fixed === null ? token : park(fixed);
		});
		let out = toCyrillic(masked);
		for (const [re, to] of NJ_EXCEPTIONS) out = out.replace(re, to);
		return out.replace(MARK_RE, (_, i) => parked[+i]);
	}

	/**
	 * Кириллица, синхронная с латиницей, без потери ручной работы.
	 *
	 * Сравнение пословное (по пробелам). Слово текущей кириллицы остаётся, если:
	 *   - оно латиницей — это сознательное решение (`vena cava inferior`, `RTG`);
	 *   - оно та же лексема, что слово sr, с точностью до орфографии
	 *     (диграф, «ij», «ps/bs», диакритика): «Субконјунктивална», «радијус», «апсцеса»;
	 *   - слово sr редкое или иностранное и в sr не менялось — ручная
	 *     транскрипция («Ашерман», «Мејковер», «Политцеру»).
	 * Слово генератора берётся, если в текущем смешаны алфавиты, в нём экавица
	 * при иекавской латинице, или это частое сербское слово с опечаткой
	 * («Тораскопска», «урасолог»). Не совпало число слов (кириллица обрублена,
	 * sr переписан) — берётся генератор целиком: латиница главнее.
	 */
	function mergeCyrillic(cyr, sr, oldSr = sr) {
		const gen = transliterate(sr);
		if (!cyr) return gen;
		const cw = cyr.split(' ');
		const gw = gen.split(' ');
		const sw = sr.split(' ');
		const ow = oldSr.split(' ');
		if (cw.length !== gw.length || gw.length !== sw.length) return gen;
		const unchanged = ow.length === sw.length;
		return cw
			.map((c, i) => {
				const g = gw[i];
				const s = sw[i];
				if (c === g) return c;
				if (mixedScriptWords(c).length) return g;
				if (!unchanged || ow[i] !== s) return g;
				if (!hasCyrillic(c)) return c;
				// Генератор оставил латиницей то, что люди уже записали кириллицей
				// («Фејс лифт» против «Face лифт»): латиница — стиль, не исправление.
				if (!hasCyrillic(g)) return c;
				const lat = toLatin(c);
				if (isEkavian(lat) || jatOnly(lat, s)) return g;
				if (variantKey(lat) === variantKey(s)) return c;
				const bare = s.match(WORD) || [];
				if (bare.some((w) => isAsciiWord(w) && (FOREIGN.test(w) || (srWordFreq.get(w) || 0) < RARE))) return c;
				return g;
			})
			.join(' ');
	}

	return { transliterate, mergeCyrillic, learned };
}
