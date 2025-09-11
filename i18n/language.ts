import { Language } from '~/enums/language';

const sr = {
	ConsultationLanguage: 'Jezik konsultacije',
	Languages: 'Jezici',
	AnyLanguage: 'Bilo koji jezik',

	[Language.SR]: 'srpski',
	[Language.BA]: 'bosanski',
	[Language.ME]: 'crnogorski',
	[Language.DE]: 'nemački',
	[Language.EN]: 'engleski',
	[Language.RU]: 'ruski',
	[Language.TR]: 'turski',
};

export default {
	messages: {
		en: {
			ConsultationLanguage: 'Consultation Language',
			Languages: 'Languages',
			AnyLanguage: 'Any language',

			[Language.SR]: 'serbian',
			[Language.BA]: 'bosnian',
			[Language.ME]: 'montenegrin',
			[Language.DE]: 'german',
			[Language.EN]: 'english',
			[Language.RU]: 'russian',
			[Language.TR]: 'turkish',
		},
		ru: {
			ConsultationLanguage: 'Язык приема',
			Languages: 'Языки',
			AnyLanguage: 'Любой язык',

			[Language.SR]: 'сербский',
			[Language.BA]: 'боснийский',
			[Language.ME]: 'черногорский',
			[Language.DE]: 'немецкий',
			[Language.EN]: 'английский',
			[Language.RU]: 'русский',
			[Language.TR]: 'турецкий',
		},
		sr,
		ba: sr,
		me: sr,
		de: {
			ConsultationLanguage: 'Beratungssprache',
			Languages: 'Sprachen',
			AnyLanguage: 'Beliebiger Sprache',

			[Language.SR]: 'Serbisch',
			[Language.BA]: 'Bosnisch',
			[Language.ME]: 'Montenegrinisch',
			[Language.DE]: 'Deutsch',
			[Language.EN]: 'Englisch',
			[Language.RU]: 'Russisch',
			[Language.TR]: 'Türkisch',
		},
		tr: {
			ConsultationLanguage: 'Görüşme dili',
			Languages: 'Diller',
			AnyLanguage: 'Herhangi bir dil',

			[Language.SR]: 'Sırpça',
			[Language.BA]: 'Boşnakça',
			[Language.ME]: 'Karadağlı',
			[Language.DE]: 'Almanca',
			[Language.EN]: 'İngilizce',
			[Language.RU]: 'Rusça',
			[Language.TR]: 'Türkçe',
		},
	},
};
