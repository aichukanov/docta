// Локализация единиц в строке дозировки реестра: «500mg + 200mg» → «500 мг + 200 мг»,
// «370mg/ml» → «370 мг/мл». Используются переводы pack_vol_* из i18n/packaging,
// поэтому поведение по локалям совпадает с подписью упаковки (ru — кириллица,
// sr-cyrl — латиница). Переводится только связка «число + единица (+ /единица)»;
// редкие хвосты (i.j., %, mmol, CFU и т.п.) остаются как есть целиком,
// чтобы не получить смесь алфавитов внутри одного токена («mmol/мл»).

type TFn = (key: string) => string;

const UNIT_KEYS: Record<string, string> = {
	mcg: 'pack_vol_mcg',
	µg: 'pack_vol_mcg',
	mg: 'pack_vol_mg',
	ml: 'pack_vol_ml',
	g: 'pack_vol_g',
	l: 'pack_vol_l',
};

const UNIT = '(?:mcg|µg|mg|ml|g|l)';
// «500mg», «100 mg/5ml», «370mg/ml»
const UNIT_RE = new RegExp(
	`(\\d)\\s*(${UNIT})\\b(?:\\s*/\\s*(\\d+(?:[.,]\\d+)?)?\\s*(${UNIT})\\b)?`,
	'gi',
);

// Между числом и единицей — неразрывный пробел
const NBSP = '\u00a0';

export function localizeStrength(
	strength: string | null | undefined,
	t: TFn,
): string {
	if (!strength) return '';
	return strength.replace(
		UNIT_RE,
		(_, digit: string, unit: string, num2?: string, unit2?: string) => {
			let out = `${digit}${NBSP}${t(UNIT_KEYS[unit.toLowerCase()])}`;
			if (unit2) {
				const denom = num2 ? `${num2}${NBSP}` : '';
				out += `/${denom}${t(UNIT_KEYS[unit2.toLowerCase()])}`;
			}
			return out;
		},
	);
}

// ---- Dose signature: сравнение дозировок карточки и зарубежного продукта ----
// Строка strength (грязный free-text: «200/400 мг», «325+400 мг», «325 mg + 400 mg»,
// «500 мг») превращается в МНОЖЕСТВО нормализованных токенов «значение+единица»
// (кириллица→латиница). Списки с общей единицей («200/400 мг») и повторной единицей
// разбираются одинаково → {200mg, 400mg}. Правило совпадения — дозы карточки ⊆ доз
// продукта: моно 400 ∈ {200,400}; комбо {325,400} ⊆ {325,400}. Единый ключ и там, и там.
const DOSE_UNIT_CANON: Record<string, string> = {
	mg: 'mg',
	мг: 'mg',
	mcg: 'mcg',
	µg: 'mcg',
	мкг: 'mcg',
	ml: 'ml',
	мл: 'ml',
	g: 'g',
	г: 'g',
	l: 'l',
	л: 'l',
};
// число или список чисел через / + - – с общей завершающей единицей
// \b не работает после кириллицы в JS-regex → граница через lookahead (не буква следом)
const DOSE_LIST_RE =
	/(\d+(?:[.,]\d+)?(?:\s*[/+\-–]\s*\d+(?:[.,]\d+)?)*)\s*(mg|мг|mcg|µg|мкг|ml|мл|g|г|l|л)(?![a-zа-яё])/gi;

export function doseSignature(
	strength: string | null | undefined,
): Set<string> {
	const out = new Set<string>();
	if (!strength) return out;
	const text = strength.toString().toLowerCase();
	let m: RegExpExecArray | null;
	DOSE_LIST_RE.lastIndex = 0;
	while ((m = DOSE_LIST_RE.exec(text)) !== null) {
		const unit = DOSE_UNIT_CANON[m[2].toLowerCase()] || m[2].toLowerCase();
		for (const raw of m[1].split(/[/+\-–]/)) {
			const n = Number(raw.replace(',', '.').trim());
			if (!Number.isNaN(n)) out.add(`${n}${unit}`);
		}
	}
	return out;
}

// true, если ВСЕ дозы карточки присутствуют среди доз продукта (page ⊆ product).
// Нераспознаваемая дозировка с любой стороны → false (не поднимаем и не подсвечиваем).
export function doseMatches(
	pageStrength: string | null | undefined,
	productStrength: string | null | undefined,
): boolean {
	const page = doseSignature(pageStrength);
	if (page.size === 0) return false;
	const prod = doseSignature(productStrength);
	if (prod.size === 0) return false;
	for (const token of page) if (!prod.has(token)) return false;
	return true;
}
