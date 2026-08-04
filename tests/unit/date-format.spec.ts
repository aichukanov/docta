import { test, expect } from '@playwright/test';
import {
	formatRelativeDate,
	getReviewDateFormat,
} from '../../common/date-format';
import { toIntlLocale } from '../../common/intl';
import dateI18n, { datetimeFormats } from '../../i18n/date';

// Относительные даты собираются из словаря, а не из Intl.RelativeTimeFormat:
// CLDR знает сербский только в экавице и отдавал «пре 4 месеца» вместо
// иекавицы, причём кириллицей даже на латинской странице. Тест сторожит обе
// половины механизма — формы в словаре и выбор формы по числу.

type Locale = 'ru' | 'sr' | 'sr-cyrl' | 'en' | 'de' | 'tr';

const LOCALES: Locale[] = ['ru', 'sr', 'sr-cyrl', 'en', 'de', 'tr'];
const KEYS = [
	'date_today',
	'date_days_ago',
	'date_weeks_ago',
	'date_months_ago',
	'date_years_ago',
];

const messages = dateI18n.messages as unknown as Record<
	string,
	Record<string, string>
>;

// Мини-замена vue-i18n: подставляет {count} во все формы сразу, как это делает
// t(key, { count }) до того, как строку разберёт selectForm.
function tFor(locale: Locale) {
	return (key: string, named?: Record<string, unknown>) => {
		const raw = messages[locale]?.[key] ?? key;
		return named
			? raw.replace(/\{(\w+)\}/g, (_, name) => String(named[name] ?? ''))
			: raw;
	};
}

const NOW = Date.UTC(2026, 7, 4);
const daysAgo = (days: number) => NOW - days * 86_400_000;

test.describe('словарь относительных дат', () => {
	for (const locale of LOCALES) {
		test(`${locale}: все ключи на месте`, () => {
			for (const key of KEYS) {
				expect(messages[locale]?.[key], `${locale}.${key}`).toBeTruthy();
			}
		});

		test(`${locale}: формы разделены «;», а не «|»`, () => {
			for (const key of KEYS) {
				expect(messages[locale][key], `${locale}.${key}`).not.toContain('|');
			}
		});

		test(`${locale}: у всех форм есть {count}, кроме «сегодня»`, () => {
			for (const key of KEYS.filter((k) => k !== 'date_today')) {
				for (const form of messages[locale][key].split(';')) {
					expect(form, `${locale}.${key}`).toContain('{count}');
				}
			}
		});
	}
});

test.describe('выбор формы по числу', () => {
	const cases: [Locale, number, string][] = [
		// Сербский: «prije» требует родительного падежа — у дней форма одна,
		// у месяцев one/few совпадают и отличаются от other.
		['sr', 1, 'prije 1 dana'],
		['sr', 3, 'prije 3 dana'],
		['sr', 6, 'prije 6 dana'],
		['sr-cyrl', 3, 'прије 3 дана'],
		['ru', 1, '1 день назад'],
		['ru', 3, '3 дня назад'],
		// 6, а не 10: с седьмого дня ступень переключается на недели
		['ru', 6, '6 дней назад'],
		['en', 1, '1 day ago'],
		['en', 3, '3 days ago'],
		['de', 1, 'vor 1 Tag'],
		['de', 3, 'vor 3 Tagen'],
		['tr', 3, '3 gün önce'],
	];

	for (const [locale, days, expected] of cases) {
		test(`${locale}, ${days} дн. → «${expected}»`, () => {
			expect(formatRelativeDate(daysAgo(days), tFor(locale), locale, NOW)).toBe(
				expected,
			);
		});
	}

	const months: [Locale, number, string][] = [
		['sr', 1, 'prije 1 mjeseca'],
		['sr', 4, 'prije 4 mjeseca'],
		['sr', 5, 'prije 5 mjeseci'],
		['sr-cyrl', 4, 'прије 4 мјесеца'],
		['sr-cyrl', 5, 'прије 5 мјесеци'],
		['ru', 5, '5 месяцев назад'],
	];

	for (const [locale, count, expected] of months) {
		test(`${locale}, ${count} мес. → «${expected}»`, () => {
			expect(
				formatRelativeDate(daysAgo(count * 30 + 1), tFor(locale), locale, NOW),
			).toBe(expected);
		});
	}
});

test.describe('ступени', () => {
	test('сегодня — без числа', () => {
		expect(formatRelativeDate(NOW, tFor('sr'), 'sr', NOW)).toBe('danas');
	});

	test('неделя раньше дней', () => {
		expect(formatRelativeDate(daysAgo(8), tFor('en'), 'en', NOW)).toBe(
			'1 week ago',
		);
	});

	test('год раньше месяцев', () => {
		expect(formatRelativeDate(daysAgo(400), tFor('en'), 'en', NOW)).toBe(
			'1 year ago',
		);
	});
});

test.describe('иекавица не потерялась', () => {
	// Ровно тот дефект, ради которого CLDR заменили словарём: экавское «пре»
	// вместо «prije/прије».
	for (const locale of ['sr', 'sr-cyrl'] as Locale[]) {
		test(`${locale}: без экавских форм`, () => {
			for (const key of KEYS) {
				const value = messages[locale][key];
				expect(value, `${locale}.${key}`).not.toMatch(
					/(?<!\p{L})(pre|пре|mesec\w*|месец\w*|nedelj\w*|недељ\w*)(?!\p{L})/giu,
				);
			}
		});
	}
});

test('тег локали для Intl уточняет сербский скрипт', () => {
	// Без этого Intl считает `sr` кириллическим и латинская страница получает
	// кириллические названия месяцев.
	expect(toIntlLocale('sr')).toBe('sr-Latn');
	expect(toIntlLocale('sr-cyrl')).toBe('sr-Cyrl');
	expect(toIntlLocale('ru')).toBe('ru');
});

test('именованные форматы дат объявлены', () => {
	expect(Object.keys(datetimeFormats).sort()).toEqual([
		'dateTime',
		'long',
		'monthYear',
		'short',
	]);
});

test('дата отзыва: Google — относительная, своя — точная', () => {
	expect(getReviewDateFormat('google_maps')).toBe('relative');
	expect(getReviewDateFormat('docta_me')).toBe('long');
});
