# Итерация 3 — Canonical для параметров

**Статус: ✅ сделано 2026-07-28.** Все AC проверены, sitemap побайтово не изменился, typecheck/prettier/unit зелёные.

**Даёт:** снимает два воспроизводимых класса дублей. Оба подтверждены на проде 2026-07-28 и присутствуют в индексе Яндекса.

## Главное решение: нормализовать К СУЩЕСТВУЮЩЕЙ форме, а не алфавитно

Изначальный план говорил «сортировать параметры». **Это было бы ошибкой.** Замер по прод-sitemap показал, что сайт уже использует осмысленный и последовательный порядок — фильтр сущности перед `cityIds`, `substanceIds` перед `atcGroupIds`, `specialtyIds` перед `languageIds`:

| Комбинация в sitemap | URL |
|---|---|
| 798 | `substanceIds&atcGroupIds` |
| 399 | `specialtyIds&cityIds` |
| 310 | `serviceCategoryIds&cityIds` |
| 151 | `categoryIds&cityIds` |
| 127 | `specialtyIds&languageIds` |
| 26 | `clinicTypeIds&cityIds` |
| + 6 одиночных | `specialtyIds`, `serviceCategoryIds`, `categoryIds`, `cityIds`, `clinicTypeIds`, `atcGroupIds` |

**Алфавитная сортировка сломала бы все 12 форм**, то есть переселила бы на новые URL весь фасетный слой, который даёт 29% показов в Google. Цена такого переезда заведомо выше исправляемого дубля (реальных дублирующих пар в индексе Яндекса вообще не нашлось — только 25 фасетных URL всего).

Поэтому введён явный `CANONICAL_QUERY_ORDER`, который **воспроизводит текущий порядок**. Перестановки нормализуются к уже проиндексированной форме, а ни один существующий URL не меняется.

Точка входа одна — `getCanonicalUrl` / `getRegionalUrl` в [`common/url-utils.ts`](../../../common/url-utils.ts). Сейчас `getCanonicalUrl` — тонкая обёртка:

```js
export function getCanonicalUrl(path, query, lang) {
	return getRegionalUrl(`${SITE_URL}${path}`, query, lang);
}
```

`lang` при этом уже нормализуется корректно (всегда уезжает в конец: `?lang=ru&specialtyIds=4` → canonical `?specialtyIds=4&lang=ru`). То есть механизм нормализации есть, ему не хватает двух правил.

## 3.1. Сортировать параметры

Сейчас порядок параметров сохраняется как пришёл:

```
/doctors?specialtyIds=4&cityIds=1&lang=ru  → canonical …?specialtyIds=4&cityIds=1&lang=ru
/doctors?cityIds=1&specialtyIds=4&lang=ru  → canonical …?cityIds=1&specialtyIds=4&lang=ru
```

Два self-canonical на идентичный контент. Нужен **детерминированный порядок**: параметры сортируются, `lang` остаётся последним (как сейчас — это уже работает и на это опираются существующие ссылки и sitemap).

**Важно:** порядок в canonical должен совпасть с тем, в котором URL порождает сам сайт и sitemap — иначе canonical будет указывать на URL, на который никто не ссылается. Сверить с `menuItemToLinks` в `server/common/sitemap/` и с тем, как формируются ссылки в `related-filters.vue`-компонентах. **Если внутренние ссылки и sitemap уже используют один устойчивый порядок — привести canonical к нему, а не вводить третий.**

## 3.2. Вырезать `tab` из canonical

`?tab=clinics` — чисто UI-параметр (переключение таба на detail-странице). Его нет ни в sitemap, ни в серверном HTML — Яндекс нашёл его, исполнив JS, и проиндексировал 6 URL:

```
/labtests/alkaline-phosphatase?tab=clinics&lang={en,ru}
/labtests/cholesterol?tab=clinics&lang={en,ru}
/labtests/ck?tab=clinics&lang={en,ru}
```

Каждый — self-canonical, то есть дубль базовой страницы. `tab` должен вырезаться из canonical: `/labtests/cholesterol?tab=clinics&lang=ru` → canonical `/labtests/cholesterol?lang=ru`.

Заодно посмотреть, нет ли других таких же UI-параметров (что-то вроде сортировки, раскрытых блоков). **Белый список индексируемых параметров надёжнее чёрного**, но переход на белый список рискованнее — можно случайно убить canonical у фасетов, которые в Google дают 29% показов. Решение на усмотрение реализующего: если делать белый список, то в него точно входят `cityIds`, `specialtyIds`, `categoryIds`, `substanceIds`, `atcGroupIds`, `languageIds`, `page`, `lang` — и проверить по коду `filtersStore`, что список полный, а не по памяти.

## Что сделано

- **`common/url-utils.ts`** — `CANONICAL_QUERY_ORDER` + стабильная сортировка в `updateQueryInUrl` (known-параметры в каноническом порядке, неизвестные сохраняют относительный порядок, `lang` по-прежнему последним). Плюс `NON_CANONICAL_QUERY_KEYS = ['tab']`, вырезаемый в `getCanonicalUrl`.
- **`components/list-page.vue`** — свой самописный `buildUrl` для `rel=prev/next` заменён на `getCanonicalUrl`. Это была третья реализация сборки URL в проекте, и именно она давала расхождение: `rel=next` отдавал `?lang=ru&page=3`, тогда как сама третья страница канонизировалась в `?page=3&lang=ru`. Заодно убран ставший ненужным импорт `SITE_URL`.
- **`tests/unit/canonical-url.spec.ts`** (новый, 17 тестов) — фиксирует все 12 форм из прод-sitemap, вырезание `tab`, сохранение `sort`/`page`/массивов и, отдельным блоком, «регрессы, которые нельзя допустить» (фасет не сворачивается на листинг).

**`sort` сознательно НЕ вырезается:** на страницах отзывов он меняет порядок, а значит и состав конкретной страницы пагинации — канонизировать `?sort=X&page=2` в `?page=2` было бы неправдой. `tab` вырезать безопасно: `components/entity-page/tab-bar.vue` читает его только в `onMounted`, серверная разметка от него не зависит.

## Acceptance Criteria

Проверено на dev-сервере 2026-07-28.

- ✅ **AC-3.1:** Обе перестановки дают `https://docta.me/doctors?specialtyIds=4&cityIds=1&lang=ru`.
- ✅ **AC-3.2:** Совпадает с формой sitemap. **Сильная проверка:** множество URL в `/sitemap.xml` после итерации 3 **побайтово совпало** с тем, что было до неё (пустой `comm -3`), и все 12 частот комбинаций сохранились.
- ✅ **AC-3.3:** `lang` последний.
- ✅ **AC-3.4:** `/labtests/cholesterol?tab=clinics&lang=ru` → canonical `…/cholesterol?lang=ru`.
- ✅ **AC-3.5:** `/doctors?specialtyIds=5`, `/doctors?specialtyIds=20&cityIds=3`, `/labtests?categoryIds=1&cityIds=2` — self-canonical на свою комбинацию, схлопывания нет. Продублировано unit-тестом.
- ✅ **AC-3.6:** `/doctors?page=2&lang=ru` → canonical `?page=2&lang=ru`, `rel=prev` на первую, `rel=next` на `?page=3&lang=ru` (раньше `?lang=ru&page=3`). На фасете `?specialtyIds=5&page=2` prev/next тоже консистентны.
- ✅ **AC-3.7:** Проверено на `?lang=ru` и дефолтной локали; hreflang генерируется тем же `getCanonicalUrl`, поэтому расхождения быть не может по построению.
- ✅ **AC-3.8:** `typecheck` зелёный, `prettier` чистый, unit — 45 passed. Плюс sweep по 10 корневым страницам — все 200.

## Риски

- **Схлопывание фасетов — самый дорогой возможный регресс во всей PRD.** `doctors?specialtyIds=*` даёт 29% показов в Google при CTR выше среднего. Если canonical начнёт указывать с фасета на базовый листинг, эта треть видимости уйдёт. AC-3.5 существует именно для этого; при малейшем сомнении — не переходить на белый список, ограничиться сортировкой и вырезанием `tab`.
- `getCanonicalUrl` используется и для hreflang-альтернатив, и в JSON-LD (`schema-org-builders.ts`). Правка затрагивает все три места — это скорее плюс (консистентность), но проверять надо все три.
