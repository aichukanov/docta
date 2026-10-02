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
import { PROTECTED_LATIN_TOKENS, LATIN_GENERA } from './sr-cyrl-protected.mjs';
import { EKAVICA, mixedScriptWords, tokens } from './service-name-rules.mjs';

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '..', '..');
const { toCyrillic, toLatin } = await createJiti(import.meta.url).import(resolve(ROOT, 'common/serbian-transliteration.ts'));

const MARK = String.fromCharCode(1);
const MARK_RE = new RegExp(`${MARK}(\\d+)${MARK}`, 'g');
const WORD = /[\p{L}\p{N}][\p{L}\p{N}-]*/gu;
const ASCII_WORD = /^[A-Za-z0-9-]+$/;
/**
 * Не бывает в сербском слове: x y w q, диграфы th ph ch sh ck, латинское
 * окончание -ae (popliteae, pneumoniae) и удвоенные согласные (Monteggia,
 * Caldwell, Straumann). «dd» и «jj» не входят — они законно возникают на стыке
 * приставки: poddijafragmalni, najjači. «ae»/«oe» внутри слова — тоже сербские
 * (aerobni, gastroenterolog, apikoektomija, eritropoetin), их транслитерируем.
 */
const FOREIGN = /[xywq]|th|ph|ch|sh|ae$|ck|([bcfgklmnprstvz])\1/i;
/** Римские цифры в названиях («Herpes simplex I IgG»): toCyrillic сделал бы из I «И». */
const ROMAN = /^(?:I|II|III|IV|V|VI|VII|VIII|IX|X)$/;

/** Латинские обороты в названиях: транслитерация ломает их в «ex темпоре». */
const LATIN_PHRASES = ['ex tempore', 'in situ', 'vena cava', 'Roux-en-Y', 'per os', 'ductus thoracicus', 'sectio caesarea', 'cavum uterusa', 'cavum uteri', 'E. coli', 'C. difficile', 'H. pylori'];
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

/**
 * Только для названий (в справочных текстах этим словам латиница не нужна):
 * английские слова брендов и наборов анализов — «NIPT Panorama Basic»,
 * «Femoflor Screen», «SARS-CoV-2 IgG Spike protein».
 */
const NAME_ONLY_PROTECTED = ['Panorama', 'Basic', 'Full', 'Plus', 'Screen', 'Femoflor', 'Androflor', 'Spike', 'Sentis', 'Loop', 'Silver', 'Ultra', 'Protia'];
/**
 * Обозначения, которые каталог пишет латиницей и в кириллице: одиночная буква
 * варианта («Протеин C», «Имуноглобулин G» — «Протеин С» из S читался бы как C),
 * двухбуквенные «Ag», «Ab», коды аллергенов «f44», «d2».
 */
const LATIN_DESIGNATION = /^(?:[A-Z]|[A-Z][a-z]|[a-z]{1,2}\d{1,3})$/;
const MULTIWORD_PROTECTED = [...LATIN_PHRASES, ...PROTECTED_LATIN_TOKENS.filter((t) => /\s/.test(t))];
const SINGLE_PROTECTED = new Set([...PROTECTED_LATIN_TOKENS.filter((t) => !/\s/.test(t)), ...NAME_ONLY_PROTECTED]);
/** «Род вид» (вид — строчными, может быть сокращён «spp.»): латиницей целиком, см. LATIN_GENERA. */
const BINOMIAL = new RegExp(`(^|[^\\p{L}])((?:${LATIN_GENERA.join('|')})(?:\\s+(?:spp?\\.|[a-z][a-z-]+))?)(?=$|[^\\p{L}])`, 'gu');
const GENERA = new Set(LATIN_GENERA);

const escapeRe = (s) => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
const hasLetter = (s) => /[A-Za-z]/.test(s);
const isAsciiWord = (s) => ASCII_WORD.test(s) && hasLetter(s);
const hasCyrillic = (s) => /\p{Script=Cyrillic}/u.test(s);
/** Слово, которое в кириллице законно остаётся латиницей. */
const foreignWord = (w) => {
	const bare = w.replace(/^[^\p{L}\p{N}]+|[^\p{L}\p{N}]+$/gu, '');
	// аббревиатура (две заглавные и больше, в т.ч. HBc, dsDNA), обозначение с цифрой
	// из коротких букв (B12, IA-2, F24 — но не «Beta-2»), защищённый токен, род, x/y/w/th
	const letters = bare.replace(/[^A-Za-z]/g, '');
	const abbr = bare.split('-').some((part) => (part.match(/[A-Z]/g) || []).length >= 2);
	return abbr || (/\d/.test(bare) && letters.length <= 3) ||
		SINGLE_PROTECTED.has(bare) || bare.split('-').some((p) => SINGLE_PROTECTED.has(p)) ||
		(bare.includes('-') && bare.split('-').every((p) => SINGLE_PROTECTED.has(p) || LATIN_DESIGNATION.test(p))) ||
		GENERA.has(bare) || FOREIGN.test(bare) || ROMAN.test(bare) || LATIN_DESIGNATION.test(bare);
};
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
		if (learned.has(token)) {
			// Регистр первой буквы — из исходного слова: «PH Pregled» в каталоге
			// записан «PH преглед», и выученное «преглед» не должно сносить заглавную.
			const v = learned.get(token);
			return /^[A-Z]/.test(token) ? v.charAt(0).toUpperCase() + v.slice(1) : v;
		}
		if (SINGLE_PROTECTED.has(token) || FOREIGN.test(token) || ROMAN.test(token) || LATIN_DESIGNATION.test(token)) return token;
		// «Rh-D», «Anti-HCV»: защищённая часть через дефис защищает токен целиком
		// «Rh-D», «Ag-Ab»: токен через дефис, все части которого — защищённые слова или обозначения
		if (token.includes('-') && token.split('-').every((p) => SINGLE_PROTECTED.has(p) || LATIN_DESIGNATION.test(p))) return token;
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
		masked = masked.replace(BINOMIAL, (_, before, match) => `${before}${park(match)}`);
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
		// Слова латинских биномов («Trichinella spiralis») — только у генератора:
		// старая кириллица записывала вид кириллицей («Trichinella спиралис»).
		const inBinomial = new Set();
		sw.forEach((w, i) => {
			if (GENERA.has(w)) {
				inBinomial.add(i);
				if (/^(?:spp?\.|[a-z][a-z-]+)$/.test(sw[i + 1] || '')) inBinomial.add(i + 1);
			}
		});
		return cw
			.map((c, i) => {
				const g = gw[i];
				const s = sw[i];
				if (c === g) return c;
				if (mixedScriptWords(c).length) return g;
				if (!unchanged || ow[i] !== s) return g;
				if (inBinomial.has(i)) return g;
				// Отличие только в регистре («преглед» при «Pregled», «Simplex» при «simplex») — регистр берём из sr
				if (c.toLowerCase() === g.toLowerCase()) return g;
				if (!hasCyrillic(c) && c.toLowerCase() === s.toLowerCase() && c !== s) return g;
				// Латинское слово — решение, только если оно и правда иностранное:
				// аббревиатура, защищённый токен, род микроорганизма, x/y/w/th и т.п.
				// Обычное сербское слово латиницей («aerobne», «Karcinoembrionalni») —
				// недопереведённая старая кириллица, её берём у генератора.
				// Латинское слово с заглавной не в начале названия или перед другим
				// латинским словом — бренд или эпоним («NIPT Silver», «Parvo B19»).
				const next = cw[i + 1];
				const brandLike = /^[A-Z][a-z]/.test(c) && (i > 0 || (next && !hasCyrillic(next) && !LATIN_DESIGNATION.test(next)));
				if (!hasCyrillic(c)) return foreignWord(c) || brandLike || !hasCyrillic(g) ? c : g;
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
