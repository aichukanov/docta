import { locales, defaultLocale } from '~/composables/use-locale';
import { toIntlLocale } from '~/common/intl';
import { combineI18nMessages } from '~/i18n/utils';
import dateI18n, { datetimeFormats } from '~/i18n/date';
import { SITE_NAME } from '~/common/constants';

// Форматы дат регистрируем и под кодами локалей приложения, и под тегами BCP 47,
// которые уходят в Intl: composables/use-localized-date.ts зовёт d() с
// locale: toIntlLocale(...), иначе сербская латиница получает кириллические
// месяцы. Без этих ключей d() уходил бы в fallbackLocale за форматом.
const datetimeLocales = [
	...new Set([...locales, ...locales.map((l) => toIntlLocale(l))]),
];

const applicationName = {
	messages: {
		'en': {
			ApplicationName: `${SITE_NAME} | Medicine in Montenegro`,
		},
		'ru': {
			ApplicationName: `${SITE_NAME} | Медицина в Черногории`,
		},
		'sr': {
			ApplicationName: `${SITE_NAME} | Medicina u Crnoj Gori`,
		},
		'de': {
			ApplicationName: `${SITE_NAME} | Medizin in Montenegro`,
		},
		'tr': {
			ApplicationName: `${SITE_NAME} | Karadağ'da Tıp`,
		},
		'sr-cyrl': {
			ApplicationName: `${SITE_NAME} | Медицина у Црној Гори`,
		},
	},
};

export default defineI18nConfig(() => ({
	locales,
	defaultLocale,
	fallbackLocale: 'sr',
	locale: defaultLocale,
	legacy: false,
	datetimeFormats: Object.fromEntries(
		datetimeLocales.map((l) => [l, datetimeFormats]),
	),
	// Даты нужны в разных местах, поэтому их словарь — глобальный, как и название
	// приложения, а не подключается компонентами поимённо.
	messages: combineI18nMessages([applicationName, dateI18n]),
}));
