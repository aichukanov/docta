import { locales, defaultLocale } from '~/composables/use-locale';
import { SITE_NAME } from '~/common/constants';

const datetimeFormat = {
	short: {
		year: 'numeric',
		month: '2-digit',
		day: '2-digit',
		hour: '2-digit',
		minute: '2-digit',
	},
} satisfies Record<string, Intl.DateTimeFormatOptions>;

export default defineI18nConfig(() => ({
	locales,
	defaultLocale,
	fallbackLocale: 'sr',
	locale: defaultLocale,
	legacy: false,
	datetimeFormats: Object.fromEntries(locales.map((l) => [l, datetimeFormat])),
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
}));
