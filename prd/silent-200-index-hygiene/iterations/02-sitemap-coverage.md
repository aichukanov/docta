# Итерация 2 — Sitemap: статьи и карточки лекарств

**Статус: ✅ сделано 2026-07-28.** Все AC проверены на dev-сервере, typecheck/prettier/unit-тесты зелёные.

**Даёт:** 15 статей и 33 карточки лекарств получают канал обнаружения. Подтверждено данными: в индексе Яндекса ровно те две статьи, что есть в sitemap, и ни одной больше — значит для этого раздела sitemap и есть канал, а листинг `/articles` не работает.

## 2.1. Статьи — выводить список, а не хардкодить

Файл: [`server/common/sitemap/sitemap.ts`](../../../server/common/sitemap/sitemap.ts), строки 102-105.

```js
const articleList = [
	'russian-speaking-doctors-in-montenegro',
	'clinics-with-language-support',
];
```

В `pages/articles/` при этом 17 статей:

```
birth-in-montenegro                     lab-tests-and-checkups
child-healthcare-in-montenegro          medications-not-available-in-montenegro
clinics-with-language-support ✓         mental-health-in-montenegro
dentistry-in-montenegro                 pharmacies-and-medications
health-insurance-for-residence-permit   russian-speaking-doctors-in-montenegro ✓
healthcare-in-bar                       tourist-healthcare-in-montenegro
healthcare-in-budva                     weekend-medical-help-in-montenegro
healthcare-in-kotor
healthcare-in-podgorica
healthcare-system-in-montenegro
```

**Список обязан выводиться автоматически, а не дописываться руками** — иначе разъедется снова ровно так же. Статьи — это файлы `pages/articles/*.vue`, то есть статические роуты; взять их из роутера/манифеста Nuxt, а не читать файловую систему в рантайме sitemap-хендлера.

Если автоматический вывод по какой-то причине невозможен (не нашлось надёжного API) — допустимо оставить массив, но тогда **рядом обязателен тест или проверка, которая падает при расхождении** массива с содержимым `pages/articles/`. Молча расходящийся хардкод — то, что уже один раз стоило 15 страниц.

## 2.2. `/medications` — списка и карточек нет в sitemap вообще

В том же файле: генератор выдаёт `/clinics/*/medications`-подстраницы (`sitemap.ts:310`), но ни `/medications` (листинг), ни `/medications/[slug]` (33 карточки). Яндекс нашёл и держит 32 таких URL сам.

Добавить по образцу того, как это уже сделано для `medicines` (`sitemap.ts:224-231`): листинг + карточки. Источник данных — тот же, что у `pages/medications/index.vue`; посмотреть, какой эндпоинт он использует, и переиспользовать хелпер, а не писать новый SQL.

## Что сделано

- **`common/articles.ts`** — добавлен `ARTICLE_SLUGS` (17 слагов). Положен рядом с уже существующим `CLINIC_SUPPORT_LANGUAGE_IDS`, отдельный файл не заводился.
- **`server/common/sitemap/sitemap.ts`** — локальный `articleList` из двух слагов заменён на `ARTICLE_SLUGS`; добавлены `medicationsPageLink` и `medicationLinks`.
- **`server/common/sitemap/filters/medications.ts`** (новый) — слаги лекарств, у которых есть хотя бы одна опубликованная клиника. Тот же принцип, что у `clinic-subpages`: в sitemap попадает только то, что стоит индексировать (карточка без цен в выдаче бесполезна).
- **`tests/unit/article-slugs.spec.ts`** (новый) — три проверки: список совпадает с `pages/articles/*.vue`, нет дублей, каждая статья присутствует ссылкой на листинге `/articles`. **Тест проверен на способность падать:** удаление `healthcare-in-kotor` из списка даёт `1 failed`.

## Acceptance Criteria

Проверено на dev-сервере 2026-07-28.

- ✅ **AC-2.1:** Все 17 статей в `/sitemap.xml`, у `articles/birth-in-montenegro` 7 × `xhtml:link` (6 локалей + `x-default`) — как у существующих записей.
- ✅ **AC-2.2:** Список не захардкожен в генераторе; живёт в `common/articles.ts` под присмотром unit-теста, который падает при расхождении в любую сторону.
- ✅ **AC-2.3:** `/medications` и 33 карточки `/medications/[slug]` присутствуют, у `medications/analgin` тоже 7 `xhtml:link`.
- ✅ **AC-2.4:** 5 статей (`birth-in-montenegro`, `healthcare-in-kotor`, `child-healthcare-in-montenegro`, `pharmacies-and-medications`, `medications-not-available-in-montenegro`) и 5 лекарств (`analgin`, `furosemide`, `lendacin`, `bedoxin`, `bensedin`) + листинг `/medications` — все 200.
- ✅ **AC-2.5:** 13 592 → 13 642 `<loc>`. Диффом множеств URL против прод-sitemap: добавилось ровно 15 статей + 33 лекарства + 1 листинг = 49; **ни один класс URL не исчез.** Остаток (4 слага клиник в обе стороны + 1 фасетная комбинация) — расхождение локальной и прод-БД, к правке не относится.
- ✅ **AC-2.6:** 13,48 МБ, 13 642 URL — с большим запасом внутри лимитов 50 000 / 50 МБ.
- ✅ **AC-2.7:** `npm run typecheck` зелёный, `prettier --check` чистый, `playwright --project=unit` — 27 passed.

## Ловушка, на которой это застряло

`*/` внутри бэктиков в блочном комментарии **закрывает комментарий**. Строка

```
 * `/clinics/*/medications`-подстраницы
```

досрочно завершала `/** … */`, дальше текст комментария становился кодом, «висячий» бэктик открывал шаблонную строку, и настоящий бэктик SQL-запроса её закрывал вместо того, чтобы открыть. esbuild ругался `Expected ";" but found "SELECT"` — то есть указывал на SQL, а причина была за 12 строк выше, в комментарии. Полчаса ушло на подозрение в кэше esbuild. В комментариях путь писать как `/clinics/<slug>/medications`.

## Риски

- Sitemap собирается запросами к БД на каждый запрос `/sitemap.xml` (13,4 МБ). Добавление 49 URL ничего не меняет по нагрузке, но **не** добавлять сюда новых тяжёлых запросов: карточек лекарств всего 33, брать их одним простым `SELECT slug`.
- `/terms` и `/privacy` в sitemap отсутствуют — **это не трогать.** Скорее всего осознанно (служебные страницы, и при этом `/privacy` — топ-получатель внутренних ссылок с 40k). Если решим добавлять — отдельным решением, не в этой итерации.
