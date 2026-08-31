// Подписи группы «Статьи» в глобальном поиске.
//
// Названия самих статей здесь НЕ хранятся: строка выдачи печатает заголовок
// статьи (`ARTICLE_SEARCH.titleKey`, common/articles.ts) — тот же, что на самой
// странице и на карточке в списке `/articles`. Короткие ярлыки жили тут до
// 2026-08-31 и убраны: в выдаче статья называлась не так, как страница, на
// которую ведёт ссылка, и это читалось как другой материал.
export default {
	messages: {
		'en': {
			Articles: 'Articles',
			MoreArticles: 'More articles ({count})',
		},
		'ru': {
			Articles: 'Статьи',
			MoreArticles: 'Ещё статьи ({count})',
		},
		'sr': {
			Articles: 'Članci',
			MoreArticles: 'Još članaka ({count})',
		},
		'sr-cyrl': {
			Articles: 'Чланци',
			MoreArticles: 'Још чланака ({count})',
		},
		'de': {
			Articles: 'Artikel',
			MoreArticles: 'Mehr Artikel ({count})',
		},
		'tr': {
			Articles: 'Makaleler',
			MoreArticles: 'Daha fazla makale ({count})',
		},
	},
};
