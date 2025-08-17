import { locales, defaultLocale } from '~/composables/use-locale';

const sr = {};

export default defineI18nConfig(() => ({
	locales,
	defaultLocale,
	fallbackLocale: 'en',
	locale: defaultLocale,
	legacy: false,
	strategy: 'no_prefix',
	messages: {
		en: {},
		ru: {},
		sr,
		ba: Object.assign({}, sr, {}),
		me: Object.assign({}, sr, {}),
		de: {},
		tr: {},
	},
}));
