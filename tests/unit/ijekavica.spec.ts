import { test, expect } from '@playwright/test';
import { readdirSync, readFileSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

// Сербский на сайте — иекавица (черногорский стандарт), конвенция зафиксирована
// в docs/audit/i18n-texts-2026-06.md.
//
// Проверка «sr и sr-cyrl совпадают» такие ошибки не ловит: экавица заводится
// сразу в обоих скриптах (Pretraga lekara / Претрага лекара), расхождения между
// близнецами не возникает. Поэтому нужен отдельный сторож — блоклист экавица-форм
// по блокам локалей sr и sr-cyrl.
//
// В блоклисте только формы с ятом, различающиеся между стандартами. Слова, которые
// в иекавице пишутся так же (vremena, zdravstveni, savremeni, privremeno, potreba),
// сюда не попадают — иначе тест шумит на корректных текстах.

const HERE = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(HERE, '../..');

const SKIP_DIRS = new Set([
	'node_modules',
	'.git',
	'.nuxt',
	'.output',
	'dist',
	'data',
	'storage',
	'public',
	'playwright-report',
	'test-results',
	// В tests/ живёт фикстура сторожа — она обязана содержать экавицу.
	'tests',
]);

const LATIN_EKAVICA = [
	'lekar',
	'lekara',
	'lekare',
	'lekari',
	'lekarima',
	'lekarom',
	'lekaru',
	'lek',
	'leka',
	'leku',
	'lekom',
	'lekovi',
	'lekova',
	'lekove',
	'lekovima',
	'cena',
	'cene',
	'cenu',
	'cenama',
	'cenimo',
	'cenovnik',
	'cenovnika',
	'cenovnici',
	'mesto',
	'mesta',
	'mestu',
	'mestima',
	'mesec',
	'meseca',
	'meseci',
	'mesecu',
	'mera',
	'mere',
	'meru',
	'merama',
	'merenje',
	'merenja',
	'deo',
	'dete',
	'deteta',
	'detetom',
	'decu',
	'deci',
	'decom',
	'dečije',
	'dečiji',
	'dečijim',
	'odeljenje',
	'odeljenja',
	'odeljenju',
	'odeljenjem',
	'odeljenjima',
	'ovde',
	'gde',
	'pre',
	'posle',
	'poslednji',
	'poslednja',
	'poslednje',
	'poslednjim',
	'sledeći',
	'sledeća',
	'sledeće',
	'sledećim',
	'sledećih',
	'savet',
	'saveta',
	'savete',
	'saveti',
	'savetom',
	'savetujte',
	'posavetujte',
	'provera',
	'provere',
	'proveri',
	'proverite',
	'proveriti',
	'promena',
	'promene',
	'promenu',
	'promenite',
	'promeniti',
	'zamena',
	'zamene',
	'zamenite',
	'zameniti',
	'zamenjuje',
	'zamenjuju',
	'uspeh',
	'uspeha',
	'uspehu',
	'uspešno',
	'uspešna',
	'uspešan',
	'uvek',
	'vest',
	'vesti',
	'vrednost',
	'vrednosti',
	'bezbedan',
	'bezbedno',
	'bezbednost',
	'bezbednosne',
	'bezbednosni',
	'obezbeđuje',
	'obezbeđuju',
	'zastareo',
	'zastareti',
	'zahtev',
	'zahteva',
	'zahtevi',
	'zahtevu',
	'nega',
	'nege',
	'negu',
	'delimo',
	'delite',
	'obaveštenje',
	'obaveštenja',
	'obavestiti',
	'obavestićemo',
	'mleko',
	'telo',
];

const CYRILLIC_EKAVICA = [
	'лекар',
	'лекара',
	'лекаре',
	'лекари',
	'лекарима',
	'лекаром',
	'лекару',
	'лек',
	'лека',
	'леку',
	'леком',
	'лекови',
	'лекова',
	'лекове',
	'лековима',
	'цена',
	'цене',
	'цену',
	'ценама',
	'ценимо',
	'ценовник',
	'ценовника',
	'ценовници',
	'место',
	'места',
	'месту',
	'местима',
	'месец',
	'месеца',
	'месеци',
	'месецу',
	'мера',
	'мере',
	'меру',
	'мерама',
	'мерење',
	'мерења',
	'део',
	'дете',
	'детета',
	'дететом',
	'децу',
	'деци',
	'децом',
	'дечије',
	'дечији',
	'дечијим',
	'одељење',
	'одељења',
	'одељењу',
	'одељењем',
	'одељењима',
	'овде',
	'где',
	'пре',
	'после',
	'последњи',
	'последња',
	'последње',
	'последњим',
	'следећи',
	'следећа',
	'следеће',
	'следећим',
	'следећих',
	'савет',
	'савета',
	'савете',
	'савети',
	'саветом',
	'саветујте',
	'посаветујте',
	'провера',
	'провере',
	'провери',
	'проверите',
	'проверити',
	'промена',
	'промене',
	'промену',
	'промените',
	'променити',
	'замена',
	'замене',
	'замените',
	'заменити',
	'замењује',
	'замењују',
	'успех',
	'успеха',
	'успеху',
	'успешно',
	'успешна',
	'успешан',
	'увек',
	'вест',
	'вести',
	'вредност',
	'вредности',
	'безбедан',
	'безбедно',
	'безбедност',
	'безбедносне',
	'безбедносни',
	'обезбеђује',
	'обезбеђују',
	'застарео',
	'застарети',
	'захтев',
	'захтева',
	'захтеви',
	'захтеву',
	'нега',
	'неге',
	'негу',
	'делимо',
	'делите',
	'обавештење',
	'обавештења',
	'обавестити',
	'обавестићемо',
	'млеко',
	'тело',
];

// \b в JS работает по ASCII, поэтому границы слова задаём через \p{L}.
function blocklistRegex(words: string[]) {
	const alternatives = [...words].sort((a, b) => b.length - a.length).join('|');
	return new RegExp(`(?<!\\p{L})(?:${alternatives})(?!\\p{L})`, 'giu');
}

const LATIN_RE = blocklistRegex(LATIN_EKAVICA);
const CYRILLIC_RE = blocklistRegex(CYRILLIC_EKAVICA);

const LOCALE_OPEN = /^\s*['"]?([a-z]{2}(?:-[a-z]{4})?)['"]?\s*:\s*\{\s*$/i;
const KNOWN_LOCALES = new Set(['en', 'ru', 'sr', 'sr-cyrl', 'de', 'tr']);

function listSources(dir: string, acc: string[] = []) {
	for (const entry of readdirSync(dir, { withFileTypes: true })) {
		if (entry.name.startsWith('.') || SKIP_DIRS.has(entry.name)) continue;
		const full = join(dir, entry.name);
		if (entry.isDirectory()) listSources(full, acc);
		else if (/\.(ts|vue)$/.test(entry.name)) acc.push(full);
	}
	return acc;
}

// Убираем содержимое строковых литералов, чтобы {count} и прочие фигурные
// скобки внутри текстов не сбивали подсчёт глубины блока.
function stripStringContents(line: string) {
	let out = '';
	let quote: string | null = null;
	let escaped = false;
	for (const char of line) {
		if (quote) {
			if (escaped) {
				escaped = false;
				continue;
			}
			if (char === '\\') {
				escaped = true;
				continue;
			}
			if (char === quote) {
				quote = null;
				out += char;
			}
			continue;
		}
		if (char === '"' || char === "'" || char === '`') quote = char;
		out += char;
	}
	return out;
}

// Строки-значения без ключей и комментариев: иначе сторож спотыкается о ключи
// вида BimWhereList1Pre и о `// Poruke o uspehu`, где экавицы быть и не может.
function valueLiterals(line: string) {
	const literals: { text: string; start: number }[] = [];
	let quote: string | null = null;
	let escaped = false;
	let buffer = '';
	let start = 0;
	let keyColon = -1;

	for (let i = 0; i < line.length; i++) {
		const char = line[i];
		if (quote) {
			if (escaped) {
				buffer += char;
				escaped = false;
				continue;
			}
			if (char === '\\') {
				escaped = true;
				continue;
			}
			if (char === quote) {
				literals.push({ text: buffer, start });
				buffer = '';
				quote = null;
				continue;
			}
			buffer += char;
			continue;
		}
		if (char === '"' || char === "'" || char === '`') {
			quote = char;
			start = i;
			continue;
		}
		if (char === ':' && keyColon === -1) keyColon = i;
	}

	return literals
		.filter((literal) => keyColon === -1 || literal.start > keyColon)
		.map((literal) => literal.text);
}

type Finding = { file: string; line: number; locale: string; word: string };

function scan(file: string): Finding[] {
	const findings: Finding[] = [];
	const stack: { locale: string; depth: number }[] = [];
	let depth = 0;

	readFileSync(file, 'utf-8')
		.split('\n')
		.forEach((line, index) => {
			const opened = LOCALE_OPEN.exec(line)?.[1]?.toLowerCase();
			const current = stack.at(-1)?.locale;
			const pattern =
				current === 'sr'
					? LATIN_RE
					: current === 'sr-cyrl'
						? CYRILLIC_RE
						: null;

			if (pattern) {
				for (const value of valueLiterals(line)) {
					pattern.lastIndex = 0;
					for (const match of value.matchAll(pattern)) {
						findings.push({
							file: file.replace(ROOT, '').replace(/\\/g, '/'),
							line: index + 1,
							locale: current as string,
							word: match[0],
						});
					}
				}
			}

			const stripped = stripStringContents(line);
			if (opened && KNOWN_LOCALES.has(opened))
				stack.push({ locale: opened, depth });
			depth +=
				(stripped.match(/[{[]/g)?.length ?? 0) -
				(stripped.match(/[}\]]/g)?.length ?? 0);
			while (stack.length && depth <= stack.at(-1)!.depth) stack.pop();
		});

	return findings;
}

test('в локалях sr и sr-cyrl нет экавицы', () => {
	const findings = listSources(ROOT).flatMap(scan);
	const report = findings
		.map((f) => `${f.file}:${f.line} [${f.locale}] ${f.word}`)
		.join('\n');
	expect(report, `экавица вместо иекавицы:\n${report}`).toBe('');
});

test('сторож видит блоки sr и sr-cyrl', () => {
	// Если парсер блоков сломается, предыдущий тест станет зелёным на пустоте.
	const probe = scan(resolve(ROOT, 'tests/unit/fixtures/ekavica-probe.ts'));
	expect(probe.map((f) => `${f.locale}:${f.word}`)).toEqual([
		'sr:lekara',
		'sr-cyrl:лекара',
	]);
});
