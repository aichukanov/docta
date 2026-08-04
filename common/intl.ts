import { Language } from '~/enums/language';

/**
 * Код локали приложения → тег BCP 47 для Intl.
 *
 * Наши коды живут в URL (`?lang=sr-cyrl`) и потому строчные, а Intl ждёт
 * канонический тег. Две поправки:
 *
 * - `sr` → `sr-Latn`. Без уточнения скрипта Intl считает сербский кириллическим
 *   (`sr` = `sr-Cyrl`), и на латинской странице вылезали кириллические названия
 *   месяцев и кириллические относительные даты.
 * - `sr-cyrl` → `sr-Cyrl`. Регистр Intl прощает, но канонический тег дешевле,
 *   чем полагаться на нормализацию.
 *
 * Это НЕ то же самое, что `getHreflangTag()` из composables/use-locale.ts: там
 * `sr` намеренно остаётся `sr` (решение по SEO, «сербский без уточнения
 * скрипта»). Здесь скрипт указывать обязательно — от него зависит,
 * какими буквами Intl отрисует дату.
 */
const INTL_TAGS: Partial<Record<Language | string, string>> = {
	[Language.SR]: 'sr-Latn',
	[Language.SR_CYRILLIC]: 'sr-Cyrl',
};

export function toIntlLocale(locale: string): string {
	return INTL_TAGS[locale] ?? locale;
}

// CLDR-категории в том порядке, в котором формы перечислены через «;»
// в словарях. Русский — one/few/many, сербский — one/few/other, en/de —
// one/other, tr — одна форма (без склонения по числу).
// Разделитель именно «;», а не «|»: pipe vue-i18n парсит как собственный
// синтаксис множественного числа и до selectForm строка не доходит целиком.
const PLURAL_FAMILIES: Record<string, string[]> = {
	[Language.RU]: ['one', 'few', 'many'],
	[Language.SR]: ['one', 'few', 'other'],
	[Language.SR_CYRILLIC]: ['one', 'few', 'other'],
	[Language.EN]: ['one', 'other'],
	[Language.DE]: ['one', 'other'],
	[Language.TR]: ['other'],
};

/**
 * Выбирает форму из строки «one; few; many» по числу n. Значения без
 * склонения («саше», tr-формы) хранятся одной формой — она и вернётся.
 */
export function selectForm(raw: string, locale: string, n: number): string {
	const forms = raw.split(';').map((s) => s.trim());
	if (forms.length === 1) return forms[0];
	const family = PLURAL_FAMILIES[locale] || ['one', 'other'];
	const cat = new Intl.PluralRules(toIntlLocale(locale)).select(n);
	const idx = family.indexOf(cat);
	// нет формы под категорию — берём последнюю (самую «множественную»)
	return forms[idx >= 0 && idx < forms.length ? idx : forms.length - 1];
}
