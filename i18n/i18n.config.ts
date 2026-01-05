import { locales, defaultLocale } from '~/composables/use-locale';
import { SITE_NAME } from '~/common/constants';

export default defineI18nConfig(() => ({
	locales,
	defaultLocale,
	fallbackLocale: 'sr',
	locale: defaultLocale,
	legacy: false,
	strategy: 'no_prefix',
	detectBrowserLanguage: {
		useCookie: true,
		cookieKey: 'i18n_redirected',
		redirectOn: 'root',
	},
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
