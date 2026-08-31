export const getClinicMarkerId = (clinicId: number) => {
	return `clinic-marker-${clinicId}`;
};

/**
 * Получает локализованное имя для сущности (клиника, врач и т.д.)
 * @param entity - объект с полями name, name_ru, name_sr_cyrl
 * @param locale - текущая локаль (sr, sr-cyrl, ru, en и т.д.)
 * @returns локализованное имя или базовое имя как fallback
 */
export function getLocalizedName<
	T extends { name: string; name_ru?: string; name_sr_cyrl?: string },
>(entity: T | null | undefined, locale: string): string {
	if (!entity) {
		return '';
	}

	// Преобразуем 'sr-cyrl' в 'sr_cyrl' для доступа к полю
	const fieldName = `name_${locale.replace('-', '_')}` as keyof T;

	return (entity[fieldName] as string) || entity.name;
}

/**
 * Буквы с перечёркиванием — самостоятельные кодовые точки, а не «буква plus
 * диакритик», поэтому NFD их не разбирает и `\p{M}` не снимает. Поисковая
 * коллация БД их складывает, значит клиент обязан складывать тот же набор.
 *
 * Набор синхронизирован с `SEARCH_COLLATION` (`server/common/search-collation.ts`,
 * `utf8mb4_unicode_520_ci`) и сверен запросами к БД 2026-08-31. Намеренно НЕ
 * входят `ß`→`ss`, `æ`→`ae`, `œ`→`oe`, турецкая `ı`→`i`: их коллация не
 * складывает, и складывать их здесь значило бы находить/подсвечивать то, чего
 * сервер не нашёл. Все пары 1:1 по длине — на этом держится карта индексов
 * в `common/search-highlight.ts`.
 */
export const SEARCH_FOLDED_LETTERS: Readonly<Record<string, string>> = {
	đ: 'd',
	ł: 'l',
	ø: 'o',
	ð: 'd',
	ħ: 'h',
};

const FOLDED_LETTERS_RE = new RegExp(
	`[${Object.keys(SEARCH_FOLDED_LETTERS).join('')}]`,
	'g',
);

/**
 * Нормализует строку для поиска по подстроке на клиенте: нижний регистр,
 * без диакритики, со складыванием перечёркнутых букв. Зеркалит поведение
 * MySQL LIKE с поисковой коллацией, чтобы «musura» находило «Mušura»,
 * а «odredivanje» — «Određivanje».
 */
export function normalizeForSearch(value: string | null | undefined): string {
	return (value || '')
		.normalize('NFD')
		.replace(/\p{M}/gu, '')
		.toLowerCase()
		.replace(FOLDED_LETTERS_RE, (char) => SEARCH_FOLDED_LETTERS[char]);
}

/**
 * Перевод по ключу или пустая строка, если ключа нет.
 *
 * vue-i18n при отсутствующем ключе возвращает сам ключ, и он утекает в
 * интерфейс: `?category=99999` на подстранице клиники выводил в заголовок
 * `medical_service_category_99999`. Страница при этом noindex (7e), то есть
 * баг косметический, но выглядит как поломка. Проверка `=== key` надёжнее
 * прежней `startsWith(prefix)`: не требует повторять префикс на каждом вызове.
 */
export function translateOrEmpty(
	t: (key: string) => string,
	key: string,
): string {
	const value = t(key);
	return value === key ? '' : value;
}
