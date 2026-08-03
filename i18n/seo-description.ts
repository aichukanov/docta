// Сегменты meta description карточек: вилка цен, рейтинг, замыкающий призыв.
// Собирает их common/seo-meta.ts (buildSeoDescription), значения — авто-факты из
// common/entity-auto-facts.ts и рейтинг из отзывов.
//
// Ключи общие для услуг, анализов, врачей, клиник и лекарств: формулировка
// цены и рейтинга обязана совпадать во всех разделах, иначе выдача выглядит
// собранной из разных сайтов. Бренд Docta.me латиницей во всех локалях,
// включая кириллические, — так он написан в логотипе и домене.
export default {
	messages: {
		'en': {
			SeoDescPriceRangeAvg: 'Price from {min} to {max}, average {avg}',
			SeoDescPriceRange: 'Price from {min} to {max}',
			SeoDescPriceFromValue: 'Price from {min}',
			SeoDescServicesFrom: 'Services from {min}',
			SeoDescRating: 'Rating {rating} ★ ({count} reviews)',
			SeoDescCtaCompare: 'Compare clinic prices and contacts on Docta.me',
			SeoDescCtaDoctor: 'Contacts and consultation locations on Docta.me',
			SeoDescCtaMedicine: 'Composition, form and packaging on Docta.me',
		},
		'ru': {
			SeoDescPriceRangeAvg: 'Цена от {min} до {max}, в среднем {avg}',
			SeoDescPriceRange: 'Цена от {min} до {max}',
			SeoDescPriceFromValue: 'Цена от {min}',
			SeoDescServicesFrom: 'Цены на услуги от {min}',
			SeoDescRating: 'Оценка {rating} ★ ({count} отзывов)',
			SeoDescCtaCompare: 'Сравните цены и контакты клиник на Docta.me',
			SeoDescCtaDoctor: 'Контакты и адреса приёма на Docta.me',
			SeoDescCtaMedicine: 'Состав, форма и упаковки на Docta.me',
		},
		'sr': {
			SeoDescPriceRangeAvg: 'Cijena od {min} do {max}, u prosjeku {avg}',
			SeoDescPriceRange: 'Cijena od {min} do {max}',
			SeoDescPriceFromValue: 'Cijena od {min}',
			SeoDescServicesFrom: 'Cijene usluga od {min}',
			SeoDescRating: 'Ocjena {rating} ★ ({count} recenzija)',
			SeoDescCtaCompare: 'Uporedite cijene i kontakte klinika na Docta.me',
			SeoDescCtaDoctor: 'Kontakti i lokacije prijema na Docta.me',
			SeoDescCtaMedicine: 'Sastav, oblik i pakovanja na Docta.me',
		},
		'sr-cyrl': {
			SeoDescPriceRangeAvg: 'Цијена од {min} до {max}, у просјеку {avg}',
			SeoDescPriceRange: 'Цијена од {min} до {max}',
			SeoDescPriceFromValue: 'Цијена од {min}',
			SeoDescServicesFrom: 'Цијене услуга од {min}',
			SeoDescRating: 'Оцјена {rating} ★ ({count} рецензија)',
			SeoDescCtaCompare: 'Упоредите цијене и контакте клиника на Docta.me',
			SeoDescCtaDoctor: 'Контакти и локације пријема на Docta.me',
			SeoDescCtaMedicine: 'Састав, облик и паковања на Docta.me',
		},
		'de': {
			SeoDescPriceRangeAvg: 'Preis von {min} bis {max}, im Schnitt {avg}',
			SeoDescPriceRange: 'Preis von {min} bis {max}',
			SeoDescPriceFromValue: 'Preis ab {min}',
			SeoDescServicesFrom: 'Leistungen ab {min}',
			SeoDescRating: 'Bewertung {rating} ★ ({count} Bewertungen)',
			SeoDescCtaCompare: 'Preise und Kontakte der Kliniken auf Docta.me',
			SeoDescCtaDoctor: 'Kontakt und Sprechstunden-Standorte auf Docta.me',
			SeoDescCtaMedicine: 'Zusammensetzung, Form und Packungen auf Docta.me',
		},
		'tr': {
			SeoDescPriceRangeAvg: 'Fiyat {min} – {max}, ortalama {avg}',
			SeoDescPriceRange: 'Fiyat {min} – {max}',
			SeoDescPriceFromValue: 'Fiyat {min} ve üzeri',
			SeoDescServicesFrom: 'Hizmetler {min} ve üzeri',
			SeoDescRating: 'Puan {rating} ★ ({count} değerlendirme)',
			SeoDescCtaCompare: 'Klinik fiyatları ve iletişim bilgileri Docta.me’de',
			SeoDescCtaDoctor: 'İletişim ve muayene yerleri Docta.me’de',
			SeoDescCtaMedicine: 'İçerik, form ve ambalajlar Docta.me’de',
		},
	},
};
