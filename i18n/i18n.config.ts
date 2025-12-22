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
		en: {
			ApplicationName: `${SITE_NAME} | All doctors of Montenegro`,
		},
		ru: {
			ApplicationName: `${SITE_NAME} | Все врачи Черногории`,
		},
		sr: {
			ApplicationName: `${SITE_NAME} | Svi lekari Crne Gore`,
		},
		de: {
			ApplicationName: `${SITE_NAME} | Alle Ärzte Montenegros`,
		},
		tr: {
			ApplicationName: `${SITE_NAME} | Karadağ'ın tüm doktorları`,
		},
	},
}));
