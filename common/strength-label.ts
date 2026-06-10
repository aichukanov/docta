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
