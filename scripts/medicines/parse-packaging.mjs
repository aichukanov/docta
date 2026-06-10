#!/usr/bin/env node
/**
 * Парсер строки упаковки реестра CInMED в структурированные поля.
 *
 * Пример: "Ukupno 10 film tableta u blisteru (1x10) u kartonskoj kutiji"
 *   → { total: 10, unit: 'tablet', container: 'blister',
 *       containerCount: 1, perContainer: 10, volume: null, volumeUnit: null,
 *       status: 'ok' }
 *
 * Принцип: total берётся ТОЛЬКО из числа сразу после "ukupno" (якорь —
 * однозначно, не путается с числами в скобках/объёме). Скобки (AxB)
 * используются как контроль целостности: при countable-единице и
 * A*B !== total строка помечается 'manual' и не считается надёжной.
 *
 * Используется и в разовой миграции (generate-packaging-sql.mjs),
 * и в пайплайне импорта будущих выгрузок.
 */

// Сербское существительное (нормализованная основа) → код единицы.
// Коды локализуются на фронте через i18n (мелкий статичный список).
const UNIT_RULES = [
	[/^tablet/, 'tablet'],
	[/^kaplet/, 'tablet'],
	[/^kapsul/, 'capsule'],
	[/^lozeng|^pastil/, 'lozenge'],
	[/^liofilizat/, 'lyophilisate'],
	[/^supozitorij|^čepić/, 'suppository'],
	[/^vagitorij/, 'pessary'],
	[/^kesic|^kesa|^kese|^vrećic|^sašet|^saše/, 'sachet'],
	[/^ampul/, 'ampoule'],
	[/^špric/, 'syringe'],
	[/^pen|^penkal/, 'pen'],
	[/^inhalator|^inhaler/, 'inhaler'],
	[/^uloža?k|^uloška/, 'cartridge'],
	[/^bočic/, 'vial'],
	[/^boca|^boce|^boci/, 'bottle'],
	[/^tuba|^tube|^tubi/, 'tube'],
	[/^kontejner/, 'container'],
	[/^sud|^kriogen/, 'cryo_vessel'],
];

// Тип контейнера из части "u <container>".
const CONTAINER_RULES = [
	[/blister/, 'blister'],
	[/bočic/, 'vial'],
	[/\bb  ?oci\b|\bboci\b/, 'bottle'],
	[/kontejner/, 'container'],
	[/\btub/, 'tube'],
	[/ampul/, 'ampoule'],
	[/kesic|vrećic/, 'sachet'],
];

// Числительные словами (low-frequency в реестре, но встречаются).
const WORD_NUM = {
	jedna: 1,
	jedan: 1,
	jedno: 1,
	dva: 2,
	dvije: 2,
	dve: 2,
	tri: 3,
	četiri: 4,
};

// Прилагательные/материалы, которые надо пропустить, ища существительное-единицу.
const SKIP_WORDS = new Set([
	'film',
	'gastrorezistentnih',
	'gastrorezistentna',
	'gastrorezistentne',
	'gastrorezistentni',
	'obloženih',
	'obložene',
	'obložena',
	'obloženi',
	'šumećih',
	'šumeće',
	'šumeća',
	'šumeći',
	'tvrdih',
	'tvrde',
	'tvrda',
	'tvrdi',
	'mekih',
	'meke',
	'meka',
	'meki',
	'sublingvalnih',
	'sublingvalne',
	'oralnih',
	'oralne',
	'vaginalnih',
	'vaginalne',
	'dispergujućih',
	'disperzibilnih',
	'disperzibilne',
	'komprimovanih',
	'napunjen',
	'napunjeni',
	'napunjenih',
	'napunjena',
	'napunjene',
	'napunjenu',
	'pun',
	'punjen',
	'punjeni',
	'staklena',
	'staklene',
	'staklenih',
	'stakleni',
	'plastična',
	'plastične',
	'plastičnih',
	'plastični',
	'injekciona',
	'injekcioni',
	'injekcionih',
	'injekcione',
	'višedozni',
	'višedozne',
	'višedoznih',
]);

const VOLUME_UNITS = ['ml', 'mcg', 'mg', 'kg', 'g', 'l', 'm3', 'litara', 'litar', 'litra'];

function normalizeVolumeUnit(u) {
	if (u === 'litar' || u === 'litra' || u === 'litara') return 'l';
	return u;
}

function mapByRules(token, rules) {
	for (const [re, code] of rules) {
		if (re.test(token)) return code;
	}
	return null;
}

/**
 * @param {string} raw — исходная строка упаковки (любой регистр)
 * @returns {{total:number|null, unit:string|null, container:string|null,
 *   containerCount:number|null, perContainer:number|null,
 *   volume:number|null, volumeUnit:string|null, status:'ok'|'manual'}}
 */
export function parsePackaging(raw) {
	const empty = {
		total: null,
		unit: null,
		container: null,
		containerCount: null,
		perContainer: null,
		volume: null,
		volumeUnit: null,
		status: 'manual',
	};
	if (!raw || typeof raw !== 'string') return empty;

	// Нормализация: нижний регистр, частые опечатки, схлопывание пробелов.
	let s = raw
		.toLowerCase()
		.replace(/\bukupo\b/, 'ukupno')
		.replace(/\bukupno(\d)/, 'ukupno $1')
		.replace(/×/g, 'x')
		.replace(/\s+/g, ' ')
		.trim();

	// "Мульти-флаконные" комбо (две разные ёмкости через " i ") — не парсим.
	if (/\bbočic\w*\b.*\bi\b.*\bbočic\w*\b/.test(s)) return empty;

	// total: число или числительное словом сразу после "ukupno".
	const head = s.match(/^ukupno\s+([\d.,]+|[a-zčćžšđ]+)\s+(.*)$/);
	if (!head) return empty;

	let total = null;
	const numTok = head[1];
	if (/^[\d.,]+$/.test(numTok)) {
		total = parseInt(numTok.replace(',', '.'), 10);
	} else if (WORD_NUM[numTok] != null) {
		total = WORD_NUM[numTok];
	}
	if (total == null || !Number.isFinite(total)) return empty;

	const rest = head[2];

	// unit: первое значимое существительное после числа. Пропускаем
	// прилагательные, одиночный "x" и токены из скобок-разбивки типа "(3x10)".
	let unit = null;
	for (const tok of rest.split(' ')) {
		const t = tok.replace(/[^a-zčćžšđ]/g, '');
		if (!t || t === 'x' || t.length < 2 || SKIP_WORDS.has(t)) continue;
		unit = mapByRules(t, UNIT_RULES);
		break; // первое значимое слово определяет единицу (или manual, если не в словаре)
	}

	// container: часть "u <container>".
	let container = null;
	const contMatch = s.match(/\bu ([a-zčćžšđ]+)/g);
	if (contMatch) {
		for (const c of contMatch) {
			const code = mapByRules(c.replace('u ', ''), CONTAINER_RULES);
			if (code) {
				container = code;
				break;
			}
		}
	}

	// breakdown: сначала вложенный unit-dose "(Ax(BxC))" (A полосок по B
	// ячеек, C=1 — индивидуальная доза), затем простой "(AxB)".
	let containerCount = null;
	let perContainer = null;
	const nested = s.match(/\(\s*(\d+)\s*x\s*\(\s*(\d+)\s*x\s*(\d+)\s*\)\s*\)/);
	const brk = s.match(/\(\s*(\d+)\s*x\s*(\d+)\s*\)/);
	if (nested) {
		containerCount = parseInt(nested[1], 10);
		perContainer = parseInt(nested[2], 10) * parseInt(nested[3], 10);
	} else if (brk) {
		containerCount = parseInt(brk[1], 10);
		perContainer = parseInt(brk[2], 10);
	}

	// volume/mass: "sa Nml" / "N ml".
	let volume = null;
	let volumeUnit = null;
	const volRe = new RegExp(
		`(\\d+(?:[.,]\\d+)?)\\s*(${VOLUME_UNITS.join('|')})\\b`,
		'i',
	);
	const volM = s.match(volRe);
	if (volM) {
		volume = parseFloat(volM[1].replace(',', '.'));
		volumeUnit = normalizeVolumeUnit(volM[2].toLowerCase());
	}

	// Контроль целостности: для счётных единиц A*B должно давать total.
	const countable = new Set([
		'tablet',
		'capsule',
		'lozenge',
		'lyophilisate',
		'suppository',
		'pessary',
		'ampoule',
		'sachet',
	]);
	let status = 'ok';
	if (!unit) status = 'manual';
	if (
		containerCount != null &&
		perContainer != null &&
		countable.has(unit) &&
		containerCount * perContainer !== total
	) {
		status = 'manual';
	}

	return {
		total,
		unit,
		container,
		containerCount,
		perContainer,
		volume,
		volumeUnit,
		status,
	};
}
