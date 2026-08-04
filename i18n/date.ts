// Относительные даты («prije 4 mjeseca») — единственная часть форматирования,
// которую нельзя отдать Intl.RelativeTimeFormat: CLDR для сербского отдаёт
// экавицу («пре 4 месеца»), а конвенция проекта — иекавица
// (docs/audit/i18n-texts-2026-06.md). Поэтому фразы живут здесь, а склонение по
// числу берёт на себя selectForm() из common/intl.ts.
//
// Формы через «;» в порядке CLDR-категорий локали (ru: one; few; many —
// sr/sr-cyrl: one; few; other — en/de: one; other — tr: одна форма).
// Разделитель именно «;», а не «|»: pipe vue-i18n перехватывает как собственный
// синтаксис множественного числа, и до selectForm строка не доходит целиком.
//
// Сербский: «prije» требует родительного падежа, поэтому у дней все три формы
// совпадают («prije 1 dana», «prije 2 dana», «prije 5 dana»), а у остальных
// единиц one и few совпадают между собой и отличаются от other
// («prije 1 mjeseca», «prije 2 mjeseca», «prije 5 mjeseci»).
// «sedmica», а не «nedjelja»: «Nedjelja» в интерфейсе уже занята днём недели
// (расписание клиник), и «prije 3 nedjelje» читалось бы двусмысленно.
//
// Абсолютные даты идут через datetimeFormats vue-i18n (ниже) — набор именованных
// форматов, зарегистрированный в i18n.config.ts. Отдельные названия месяцев в
// словаре не нужны: их Intl отдаёт правильно для обоих сербских скриптов, если
// ему передан тег со скриптом (см. toIntlLocale в common/intl.ts).
//
// Ключи форматов:
//   short     — «04.08.2026»
//   long      — «4. avgust 2026»
//   monthYear — «avgust 2026»
//   dateTime  — «04.08.2026, 14:30» (журналы)
export const datetimeFormats = {
	short: { year: 'numeric', month: '2-digit', day: '2-digit' },
	long: { year: 'numeric', month: 'long', day: 'numeric' },
	monthYear: { year: 'numeric', month: 'long' },
	dateTime: {
		year: 'numeric',
		month: '2-digit',
		day: '2-digit',
		hour: '2-digit',
		minute: '2-digit',
	},
} satisfies Record<string, Intl.DateTimeFormatOptions>;

export type DateFormatKey = keyof typeof datetimeFormats;

export default {
	messages: {
		'en': {
			date_today: 'today',
			date_days_ago: '{count} day ago; {count} days ago',
			date_weeks_ago: '{count} week ago; {count} weeks ago',
			date_months_ago: '{count} month ago; {count} months ago',
			date_years_ago: '{count} year ago; {count} years ago',
		},
		'ru': {
			date_today: 'сегодня',
			date_days_ago:
				'{count} день назад; {count} дня назад; {count} дней назад',
			date_weeks_ago:
				'{count} неделю назад; {count} недели назад; {count} недель назад',
			date_months_ago:
				'{count} месяц назад; {count} месяца назад; {count} месяцев назад',
			date_years_ago:
				'{count} год назад; {count} года назад; {count} лет назад',
		},
		'sr': {
			date_today: 'danas',
			date_days_ago: 'prije {count} dana',
			date_weeks_ago:
				'prije {count} sedmice; prije {count} sedmice; prije {count} sedmica',
			date_months_ago:
				'prije {count} mjeseca; prije {count} mjeseca; prije {count} mjeseci',
			date_years_ago:
				'prije {count} godine; prije {count} godine; prije {count} godina',
		},
		'sr-cyrl': {
			date_today: 'данас',
			date_days_ago: 'прије {count} дана',
			date_weeks_ago:
				'прије {count} седмице; прије {count} седмице; прије {count} седмица',
			date_months_ago:
				'прије {count} мјесеца; прије {count} мјесеца; прије {count} мјесеци',
			date_years_ago:
				'прије {count} године; прије {count} године; прије {count} година',
		},
		'de': {
			date_today: 'heute',
			date_days_ago: 'vor {count} Tag; vor {count} Tagen',
			date_weeks_ago: 'vor {count} Woche; vor {count} Wochen',
			date_months_ago: 'vor {count} Monat; vor {count} Monaten',
			date_years_ago: 'vor {count} Jahr; vor {count} Jahren',
		},
		'tr': {
			date_today: 'bugün',
			date_days_ago: '{count} gün önce',
			date_weeks_ago: '{count} hafta önce',
			date_months_ago: '{count} ay önce',
			date_years_ago: '{count} yıl önce',
		},
	},
};
