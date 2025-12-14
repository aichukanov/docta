import { locales, defaultLocale } from '~/composables/use-locale';

const sr = {
	ApplicationName: 'omeda.me | Svi lekari Crne Gore',
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
			ApplicationName: 'omeda.me | All doctors of Montenegro',
		},
		ru: {
			ApplicationName: 'omeda.me | Все врачи Черногории',
		},
		sr,
		de: {
			ApplicationName: 'omeda.me | Alle Ärzte Montenegros',
		},
		tr: {
			ApplicationName: "omeda.me | Karadağ'ın tüm doktorları",
		},
	},
}));
