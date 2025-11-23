import { locales, defaultLocale } from '~/composables/use-locale';

const sr = {
	ApplicationName: 'docta.me | Svi lekari Crne Gore',
};

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
			ApplicationName: 'docta.me | All doctors of Montenegro',
		},
		ru: {
			ApplicationName: 'docta.me | Все врачи Черногории',
		},
		sr,
		de: {
			ApplicationName: 'docta.me | Alle Ärzte Montenegros',
		},
		tr: {
			ApplicationName: "docta.me | Karadağ'ın tüm doktorları",
		},
	},
}));
