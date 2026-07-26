// Авто-факты на страницах услуг/анализов: подписи к цифрам, которые уже есть
// в БД (клиники, города, прайсы) — см. docs/audit/seo-2026-07.md, пункт 4.
// Сами значения собирает common/entity-auto-facts.ts.
export default {
	messages: {
		'en': {
			AutoFactsClinics: 'Clinics',
			AutoFactsCities: 'Cities',
			AutoFactsPrice: 'Price',
			// Подпись под крупной ценой, поэтому строчная и без двоеточия
			AutoFactsAvgInline: 'average {avg}',
		},
		'ru': {
			AutoFactsClinics: 'Клиники',
			AutoFactsCities: 'Города',
			AutoFactsPrice: 'Цена',
			AutoFactsAvgInline: 'в среднем {avg}',
		},
		'sr': {
			AutoFactsClinics: 'Klinike',
			AutoFactsCities: 'Gradovi',
			AutoFactsPrice: 'Cijena',
			AutoFactsAvgInline: 'u prosjeku {avg}',
		},
		'sr-cyrl': {
			AutoFactsClinics: 'Клинике',
			AutoFactsCities: 'Градови',
			AutoFactsPrice: 'Цијена',
			AutoFactsAvgInline: 'у просјеку {avg}',
		},
		'de': {
			AutoFactsClinics: 'Kliniken',
			AutoFactsCities: 'Städte',
			AutoFactsPrice: 'Preis',
			AutoFactsAvgInline: 'im Schnitt {avg}',
		},
		'tr': {
			AutoFactsClinics: 'Klinikler',
			AutoFactsCities: 'Şehirler',
			AutoFactsPrice: 'Fiyat',
			AutoFactsAvgInline: 'ortalama {avg}',
		},
	},
};
