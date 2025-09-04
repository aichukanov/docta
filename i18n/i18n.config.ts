import { locales, defaultLocale } from '~/composables/use-locale';
import { DoctorSpecialty } from '~/enums/specialty';
import { CityId } from '~/enums/cities';

const sr = {
	ApplicationName: 'docta.me | Svi lekari Crne Gore',

	sr: 'srpski',
	ba: 'bosanski',
	me: 'crnogorski',
	de: 'nemački',
	en: 'engleski',
	ru: 'ruski',
	tr: 'turski',

	Languages: 'Jezici',
	Contacts: 'Kontakti',
	NoContacts: 'Kontakti nisu pronađeni',

	BuildRoute: 'Napravi rutu',
	MapLoading: 'Učitava mapa',
	ShowOnMap: 'Prikaži na mapi',
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

			sr: 'serbian',
			ba: 'bosnian',
			me: 'montenegrin',
			de: 'german',
			en: 'english',
			ru: 'russian',
			tr: 'turkish',

			Languages: 'Languages',
			Contacts: 'Contacts',
			NoContacts: 'No contacts found',

			BuildRoute: 'Build Route',
			MapLoading: 'Loading map',
			ShowOnMap: 'Show on map',
		},
		ru: {
			ApplicationName: 'docta.me | Все врачи Черногории',

			sr: 'сербский',
			ba: 'боснийский',
			me: 'черногорский',
			de: 'немецкий',
			en: 'английский',
			ru: 'русский',
			tr: 'турецкий',

			Languages: 'Языки',
			Contacts: 'Контакты',
			NoContacts: 'Контакты не найдены',

			BuildRoute: 'Построить маршрут',
			MapLoading: 'Загрузка карты',
			ShowOnMap: 'Показать на карте',
		},
		sr,
		ba: sr,
		me: sr,
		de: {
			ApplicationName: 'docta.me | Alle Ärzte Montenegros',

			sr: 'Serbisch',
			ba: 'Bosnisch',
			me: 'Montenegrinisch',
			de: 'Deutsch',
			en: 'Englisch',
			ru: 'Russisch',
			tr: 'Türkisch',

			Languages: 'Sprachen',
			Contacts: 'Kontakte',
			NoContacts: 'Keine Kontakte gefunden',

			BuildRoute: 'Route erstellen',
			MapLoading: 'Karte wird geladen',
			ShowOnMap: 'Auf Karte zeigen',
		},
		tr: {
			ApplicationName: "docta.me | Karadağ'ın tüm doktorları",

			sr: 'Sırpça',
			ba: 'Boşnakça',
			me: 'Karadağlı',
			de: 'Almanca',
			en: 'İngilizce',
			ru: 'Rusça',
			tr: 'Türkçe',

			Languages: 'Diller',
			Contacts: 'İletişim',
			NoContacts: 'İletişim bilgisi bulunamadı',

			BuildRoute: 'Rota Oluştur',
			MapLoading: 'Harita yükleniyor',
			ShowOnMap: 'Haritada göster',
		},
	},
}));
