import { combineI18nMessages } from '~/i18n/utils';

type Messages = Record<string, Record<string, string>>;

/**
 * Справочники каталога для глобального поиска, подгружаемые по требованию.
 *
 * Статический импорт клал их в чанк главной: specialty (81 КБ raw), packaging
 * (21,8), labtest-category (21,5), medical-service-category (15,9), city (8,7)
 * плюс clinic-common и search-match — около 150 КБ raw / 24 КБ gzip на первом
 * экране. Нужны они только когда в поле поиска что-то ввели: до этого дропдаун
 * закрыт (и на SSR тоже, так что рассинхрона гидрации нет), а подписи внутри
 * него — единственное место, где эти ключи вообще используются.
 *
 * Кэш модульный: словари статические, второй раз качать их незачем. При
 * неудаче кэш сбрасывается, чтобы следующий ввод повторил загрузку, а не залип
 * на отказавшем промисе.
 */
let messagesPromise: Promise<Messages> | null = null;

export function loadSearchCatalogMessages(): Promise<Messages> {
	if (!messagesPromise) {
		messagesPromise = Promise.all([
			import('~/i18n/specialty'),
			import('~/i18n/city'),
			import('~/i18n/packaging'),
			import('~/i18n/clinic-common'),
			import('~/i18n/medical-service-category'),
			import('~/i18n/labtest-category'),
			import('~/i18n/search-match'),
		])
			.then((modules) =>
				combineI18nMessages(modules.map((module) => module.default)),
			)
			.catch((error) => {
				messagesPromise = null;
				throw error;
			});
	}

	return messagesPromise;
}
