import { selectForm } from '~/common/intl';
import { toIntlLocale } from '~/common/intl';
import type { DateFormatKey } from '~/i18n/date';

/**
 * Форматирование дат. Чистые функции: `t`/`d` из vue-i18n приходят параметром,
 * потому что useI18n() зовут только компоненты. Для шаблонов есть готовая
 * обёртка — components/localized-date.vue.
 *
 * Зачем это вообще понадобилось. Раньше каждое место звало Intl напрямую и
 * передавало код локали как есть, из-за чего сербский ломался дважды:
 * - тег `sr` без скрипта Intl считает кириллическим, и на латинской странице
 *   выходили кириллические названия месяцев;
 * - Intl.RelativeTimeFormat знает сербский только в экавице и отдавал
 *   «пре 4 месеца» вместо иекавицы (docs/audit/i18n-texts-2026-06.md).
 *
 * Поэтому абсолютные даты идут штатным d() по именованным форматам из
 * i18n/date.ts с тегом из toIntlLocale(), а относительные — не из CLDR,
 * а из словаря.
 */

type TFn = (key: string, named?: Record<string, unknown>) => string;
type DFn = (
	value: Date,
	options: { key: DateFormatKey; locale: string },
) => string;

const DAY_MS = 86_400_000;

/** Абсолютная дата именованным форматом: «04.08.2026», «4. avgust 2026». */
export function formatDate(
	value: string | number | Date,
	d: DFn,
	locale: string,
	key: DateFormatKey = 'short',
): string {
	return d(new Date(value), { key, locale: toIntlLocale(locale) });
}

/**
 * Относительная дата: «prije 4 mjeseca», «4 months ago», «данас».
 *
 * Ступени грубые (неделя = 7 дней, месяц = 30, год = 365): единственный
 * источник таких дат — Google Maps, который сам отдаёт возраст отзыва
 * с точностью до месяца.
 *
 * `now` параметром — чтобы функция оставалась чистой и проверяемой тестом.
 */
export function formatRelativeDate(
	value: string | number | Date,
	t: TFn,
	locale: string,
	now: number = Date.now(),
): string {
	const days = Math.floor((now - new Date(value).getTime()) / DAY_MS);
	const pick = (key: string, count: number) =>
		selectForm(t(key, { count }), locale, count);

	const years = Math.floor(days / 365);
	if (years > 0) return pick('date_years_ago', years);

	const months = Math.floor(days / 30);
	if (months > 0) return pick('date_months_ago', months);

	const weeks = Math.floor(days / 7);
	if (weeks > 0) return pick('date_weeks_ago', weeks);

	if (days > 0) return pick('date_days_ago', days);

	return t('date_today');
}

/**
 * Google Maps отдаёт возраст отзыва, а не дату («4 месяца назад»), поэтому для
 * него — относительный формат; у собственных отзывов дата точная.
 */
export function getReviewDateFormat(
	provider: string,
): DateFormatKey | 'relative' {
	return provider === 'google_maps' ? 'relative' : 'long';
}
