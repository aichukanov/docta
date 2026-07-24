import { CONTAINER_UNITS } from '~/i18n/packaging';

export interface PackagingFields {
	pack_total?: number | null;
	pack_unit?: string | null;
	pack_container?: string | null;
	pack_container_count?: number | null;
	pack_per_container?: number | null;
	pack_volume?: number | null;
	pack_volume_unit?: string | null;
	pack_parse_status?: string | null;
}

type TFn = (key: string) => string;

// Аккуратное число: «0.5» вместо «0.50», запятая как десятичный разделитель.
function fmtVolume(v: number): string {
	return String(v).replace(/\.0+$/, '').replace('.', ',');
}

// CLDR-категории в том порядке, в котором формы единиц перечислены через «;»
// в i18n/packaging.ts. Русский — one/few/many, сербский — one/few/other,
// en/de — one/other, tr — одна форма (без склонения по числу).
// Разделитель именно «;», а не «|»: pipe vue-i18n парсит как собственный
// синтаксис множественного числа и до selectForm строка не доходит целиком.
const PLURAL_FAMILIES: Record<string, string[]> = {
	'ru': ['one', 'few', 'many'],
	'sr': ['one', 'few', 'other'],
	'sr-cyrl': ['one', 'few', 'other'],
	'en': ['one', 'other'],
	'de': ['one', 'other'],
	'tr': ['other'],
};

// Locale → BCP-47 тег для Intl.PluralRules (совпадает, кроме кириллицы)
const INTL_TAG: Record<string, string> = { 'sr-cyrl': 'sr-Cyrl' };

// Выбирает форму из строки «one; few; many» по числу n. Единицы без
// склонения («саше», tr-формы) хранятся одной формой — она и вернётся.
function selectForm(raw: string, locale: string, n: number): string {
	const forms = raw.split(';').map((s) => s.trim());
	if (forms.length === 1) return forms[0];
	const family = PLURAL_FAMILIES[locale] || ['one', 'other'];
	const cat = new Intl.PluralRules(INTL_TAG[locale] || locale).select(n);
	const idx = family.indexOf(cat);
	// нет формы под категорию — берём последнюю (самую «множественную»)
	return forms[idx >= 0 && idx < forms.length ? idx : forms.length - 1];
}

// Именительный ед.ч. (первая форма) — для контейнера в записи «3 × шприц 0,5 мл»
function nominative(raw: string): string {
	return raw.split(';')[0].trim();
}

/**
 * Собирает локализованную подпись упаковки из структурных полей.
 * @param withBreakdown — добавлять «(2 × 10)» (для детальной страницы).
 * Возвращает '' для неразобранных (manual) записей — сырой текст не показываем.
 */
export function buildPackagingLabel(
	med: PackagingFields,
	t: TFn,
	locale: string,
	withBreakdown = false,
): string {
	if (med.pack_parse_status !== 'ok' || med.pack_total == null) return '';

	const total = med.pack_total;
	const unit = med.pack_unit;
	const volLabel =
		med.pack_volume != null && med.pack_volume_unit
			? `${fmtVolume(med.pack_volume)} ${t(`pack_vol_${med.pack_volume_unit}`)}`
			: '';

	// Контейнер с объёмом: «флакон 100 мл», «3 × шприц 0,5 мл» — после «×»
	// единица в именительном ед.ч., склонять не нужно.
	if (unit && CONTAINER_UNITS.has(unit) && volLabel) {
		const name = nominative(t(`pack_unit_${unit}`));
		return total > 1 ? `${total} × ${name} ${volLabel}` : `${name} ${volLabel}`;
	}

	// Контейнер без объёма: «1 флакон», «3 флакона».
	if (unit && CONTAINER_UNITS.has(unit)) {
		return `${total} ${selectForm(t(`pack_unit_${unit}`), locale, total)}`;
	}

	// Только объём, без единицы (например, раствор): «100 мл».
	if (!unit && volLabel) return volLabel;

	if (!unit) return '';

	// Счётные единицы: «3 таблетки», «20 таблеток» + опциональная разбивка «(2 × 10)».
	let label = `${total} ${selectForm(t(`pack_unit_${unit}`), locale, total)}`;
	if (
		withBreakdown &&
		med.pack_container_count != null &&
		med.pack_per_container != null
	) {
		label += ` (${med.pack_container_count} × ${med.pack_per_container})`;
	}
	return label;
}
