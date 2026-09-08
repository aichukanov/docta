# Lighthouse: render-blocking CSS, JS и DOM — план исправления (2026-09-08)

Исходный отчёт: страница `/clinics/dr-filimanovic-stomatoloska-ordinacija-podgorica?lang=ru`.
Жалобы Lighthouse: render-blocking CSS (860 мс), цепочка критических запросов
(995 мс), JS execution 1,6 с, main-thread 3,4 с, unused JS 196 KiB, bfcache.

Всё ниже проверено на проде (`curl` HTML двух страниц + сборка `.output`
от 2026-09-03), а не по одному отчёту.

---

## 1. Диагноз

### 1.1 CSS: стили инлайнятся И подключаются ссылками одновременно

В `<head>` каждой страницы лежит 25–36 `<link rel="stylesheet">` и рядом
39 инлайновых `<style>` (60–70 КБ). Сверка содержимого ссылок с инлайном:

| Страница | Ссылок | Полный дубль инлайна | Частичный | Не в инлайне |
|---|---|---|---|---|
| `/clinics/<slug>` | 25 | 13 (22,6 КБ) | 4 | 8 |
| `/clinics` | 36 | 14 (21,8 КБ) | 4 | 18 |

Что не в инлайне — почти целиком CSS Element Plus (`el-button`, `el-input`,
`el-popper`, `base`…): 16 файлов, 109 КБ raw / 16 КБ brotli на всю сборку.
Остаток «не в инлайне» — стили компонентов, которые на этой странице не
отрендерились, но лежат в общем чанке (skeleton, show-more-button).

Механика (Nuxt 3.21, `features.inlineStyles: true` по умолчанию):

- Nuxt инлайнит стили каждого отрендеренного `.vue` через `styles.mjs`.
- Ссылки `<link>` рендерятся из клиентского манифеста: `css` у каждого чанка
  в графе модулей страницы (`vue-bundle-renderer/getRequestDependencies`).
- Плагин `SSRStylesPlugin` обнуляет `css` у чанка компонента, а у импортируемых
  общих чанков — только если имя CSS-файла начинается с имени компонента.
  Rollup именует общий чанк по первому модулю (`_KitAvatar`, `use-in-viewport`,
  `use-missing-entity-status`) — эвристика не срабатывает, ссылка остаётся.
- CSS Element Plus подключается через `@element-plus/nuxt`
  (`importStyle: 'css'`, по компоненту) — в `styles.mjs` не попадает, поэтому
  не инлайнится вовсе и идёт отдельными файлами по 0,5–20 КБ.

Итог: ~30 блокирующих запросов, из них половина отдаёт байты, которые уже в
HTML.

### 1.2 Network dependency tree

Та же CSS-россыпь плюс два запроса Cloudflare, не из кода:

- `static.cloudflareinsights.com/beacon.min.js` + `/cdn-cgi/rum` — Cloudflare
  Web Analytics, инжектится на edge (упомянуто в комментарии
  `layouts/default.vue`).
- `/cdn-cgi/challenge-platform/…/jsd/main.js` — Bot Fight Mode → «JavaScript
  Detections». 231 мс CPU на каждом визите.

### 1.3 JavaScript

| Чанк | Что это | Transfer | CPU |
|---|---|---|---|
| `BPL_6XrQ.js` | entry: Vue, Router, Pinia, vue-i18n, Nuxt runtime, popper | 100 КБ (327 raw) | 587 мс |
| `CYtZM7PJ.js` | `mixpanel-browser` целиком | 124 КБ (423 raw), 94 KiB unused | — |
| `CLXzrMqa.js` | `NuxtLink` (5 КБ) | — | 158 мс |
| `gtag/js` | Google Analytics | 166 КБ, 71 KiB unused | 199 мс |
| `jsd/main.js` | Cloudflare bot detection | 10 КБ | 231 мс |

- Mixpanel грузится динамическим импортом, но сразу при гидрации, как только
  есть cookie `ncc_c=accepted` (`layouts/default.vue`, watch с
  `immediate: true`). У принявшего cookies посетителя — а именно так стоит
  профиль, в котором снимался отчёт — 124 КБ уезжают в критический путь.
- 158 мс на чанке `NuxtLink` — это `prefetchOn: { visibility: true }` по
  умолчанию: на листинге 99 внутренних ссылок, на каждую IntersectionObserver
  и префетч чанков + payload страницы при попадании в вьюпорт.
- Entry без тяжёлых сторонних библиотек (dayjs, async-validator, leaflet в
  нём нет) — это базовая стоимость стека; уменьшится только с выносом Element
  Plus (prd/element-plus-removal).

### 1.4 Main thread: «Other 1006 мс», «Style & Layout 501 мс» — размер DOM

HTML `/clinics`: **431 КБ** несжатого, 2810 тегов, 1982 `data-v-*`.
Из них **300 inline-SVG = 143 КБ (33 % документа)**. Кто их даёт:

| Повторов | Что | Байт |
|---|---|---|
| 94 | иконка «копировать» в `CopyButton` (+ `ElTooltip` на каждой) | 47 КБ |
| 53 | иконка мессенджера в `contact-link` (+ `ElTooltip`) | 30 КБ |
| 33 | иконка `channel-btn` (tel:/…) | 18 КБ |
| 21 | стрелка `el-collapse-item__arrow` | 7 КБ |

Всё это — содержимое **свёрнутых** секций «Контакты» в `ClinicSummary`
(`components/clinic/summary.vue`): `el-collapse-item` рендерит содержимое
через `v-show`, так что 21 закрытая карточка отдаёт в HTML и гидрирует ~100 КБ
кнопок, тултипов и телепортов, которых никто не видит.

Плюс 95–104 `<link rel="modulepreload">` на страницу — следствие 351 JS-чанка
в сборке.

### 1.5 bfcache «Internal error»

Причина на стороне Chrome, Lighthouse сам помечает как not actionable.
Ничего не делаем.

---

## 2. План

Порядок — по соотношению эффект/стоимость. Каждый этап замеряется отдельно
(Lighthouse mobile, две страницы: `/clinics/<slug>` и `/clinics`, метрики
FCP / LCP / TBT / размер HTML). Базовый замер — до начала.

### Этап 1. CSS: одна блокирующая ссылка вместо 30

1. **Element Plus в один глобальный файл.** В `nuxt.config.ts`:
   `elementPlus: { importStyle: false }`, а в `css:` — свой
   `assets/css/element-plus.css`, который импортирует `theme-chalk/base.css`
   и CSS только используемых компонентов (в коде 31 компонент: button, input,
   tabs, radio-button, tag, form, tooltip, table, alert, result, checkbox,
   switch, input-number, time-picker, pagination, collapse, card, radio, link,
   dropdown, divider, dialog, badge). Порядок в `css:`: tokens (ui-kit) →
   element-plus.css → `element-plus-bridge.css` — мост переопределяет
   переменные EP и обязан идти после него.
   Ожидаемо ~16 КБ brotli, один запрос, `immutable`-кэш, общий для всех
   страниц. Список временный — уйдёт вместе с EP по PRD.
2. **Инлайнить только `.vue`, а не entry.** `features.inlineStyles:
   (id) => !!id && id.includes('.vue')` (это дефолт Nuxt 4). Сейчас
   `entry.css` (токены + мост + глобальные стили app.vue) и инлайнится, и
   линкуется; после п. 1 в него добавится ~110 КБ EP-стилей — инлайнить такое
   на каждой странице нельзя, ссылка на кэшируемый файл дешевле.
3. **Убрать ссылки на чанки, чей CSS уже в инлайне.** После п. 1 весь CSS
   вне entry — это стили `.vue`, и все они инлайнятся. Хук в `nuxt.config.ts`:
   ```ts
   hooks: {
     'build:manifest'(manifest) {
       for (const chunk of Object.values(manifest)) {
         if (!chunk.isEntry) chunk.css = [];
       }
     },
   },
   ```
   Клиентская навигация от этого не страдает: CSS чанков подтягивает
   собственный preload-helper Vite (`__vite__mapDeps` в entry уже содержит
   `.css`), манифест Nuxt используется только для SSR-`<link>` и prefetch-хинтов.
   Единственное исключение из «весь CSS вне entry инлайнится» —
   `md-editor-v3/lib/style.css` в `markdown-editor.client.vue`: компонент
   client-only и только в админке, ссылка ему не нужна.
4. **Проверка:** `nuxt build`, `node .output/server/index.mjs`, в HTML ровно
   один `<link rel="stylesheet">`; открыть листинг → детальную → назад без
   FOUC; сверить, что стили EP на месте (кнопки, инпуты, тултипы, пагинация,
   табы в кабинете, таблица и time-picker в админке).

Эффект: render-blocking 25–36 → 1 запрос; ~30 КБ дублей исчезают.

### Этап 2. Аналитика вне критического пути

1. **Отложить `initMixpanel()` и `initGTag()`** до простоя после гидрации:
   `onNuxtReady(() => requestIdleCallback(init, { timeout: 3000 }))`, с
   фолбэком `setTimeout` где `requestIdleCallback` нет (Safari). Событие
   `track_pageview` уйдёт на 1–2 с позже — для аналитики это ничто, для LCP и
   TBT это минус 290 КБ JS из критического пути. Watch на `isConsentGiven`
   остаётся: клик «принять» на баннере инициализирует сразу, как сейчас.
2. **Отдельное решение (не в этом заходе):** `mixpanel-browser` весит 423 КБ
   raw ради `track`/`identify`/`register`. Тонкий клиент над HTTP API
   (`api-eu.mixpanel.com/track`, `/engage`) — ~2 КБ. Теряются автотреки и
   session replay, которые не используются. Стоит обсудить после этапа 1–3.
3. **Панель Cloudflare, не код:**
   - Web Analytics (beacon + `/cdn-cgi/rum`) — есть GA и Mixpanel; если отчёты
     CF никто не смотрит, отключить.
   - Bot Fight Mode → JavaScript Detections (`jsd/main.js`, 231 мс CPU на
     каждом визите). Оставить только если реально режет ботов в логах; иначе
     отключить. Помнить про [[project_cloudflare_speed_brain]] — настройки CF
     уже однажды ломали сайт, менять по одной и проверять WebView Telegram.

### Этап 3. DOM листингов

1. **Свёрнутые секции `ClinicSummary` не рендерить закрытыми.**
   Секция «Контакты» — `v-if` на раскрытии вместо `v-show` от
   `el-collapse-item`: у копи-кнопок и тултипов нет SEO-ценности, а это ~100 КБ
   HTML и сотни экземпляров `ElTooltip`/`ElButton` на гидрации.
   **Секции «Услуги» и «Врачи» трогать нельзя**: блок «Врачи» в `ClinicSummary`
   на `/services/<slug>` — намеренная SEO-перелинковка
   ([[project_service_page_doctor_links]]), ссылки должны оставаться в SSR-HTML.
   Для них — ленивая гидрация: `<LazyClinicServiceSectionContent hydrate-on-visible>`
   (Nuxt ≥ 3.16), HTML остаётся, JS-работа переезжает под скролл.
2. **Prefetch ссылок по наведению, а не по видимости.**
   `experimental.defaults.nuxtLink.prefetchOn: { visibility: false, interaction: true }`.
   Убирает 99 observer'ов и веер префетчей на листинге (158 мс чанка
   `NuxtLink` + сетевой шум, конкурирующий с LCP-картинкой).
3. **Иконки — спрайт вместо inline-SVG.** 300 SVG = 143 КБ на листинге.
   После п. 1 повторов станет в разы меньше, поэтому — третьим. Вариант:
   один `<svg><symbol id=…>` в `app.vue` + `<use href="#…">` в компонентах
   иконок; это правка в `@ach/ui-kit` (иконки общие с svad) и в
   `components/icon/`. Делать отдельным заходом с превью
   ([[feedback_visual_decisions]]).
4. **modulepreload ×100** — следствие 351 чанка; отдельно не лечить, замерить
   после п. 1–3 и этапа 1. Если останется заметным — рассмотреть укрупнение
   через `manualChunks` для `components/icon/*` и `@ach/ui-kit`.

### Этап 4. Entry-чанк

Отдельного шага нет: entry — базовая стоимость Vue + Router + Pinia + i18n +
Nuxt + ядро EP (popper). Единственный реальный рычаг — вынос Element Plus по
prd/element-plus-removal. После этапов 1–3 снять `nuxi analyze` и приложить к
тому PRD как аргумент.

---

## 3. Что НЕ делать

- `vite.build.cssCodeSplit: false` — один CSS-файл на всё приложение, включая
  админку: 523 КБ raw / 81 КБ brotli на первом визите вместо 16 КБ EP. Хуже.
- `features.inlineStyles: false` без хука — дубли исчезнут, но 30 блокирующих
  ссылок останутся.
- Выключать SSR у карточек ради размера HTML — листинги индексируются.
- Трогать `/services/**` ClinicSummary «Врачи» — см. этап 3, п. 1.

## 4. Порядок работ

1 → 2.1 → 3.2 → 3.1 → 2.3 (панель CF, по одной настройке) → 3.3 → 4.
Замер после каждого пункта, результат — в этот файл.

---

## 5. Сделано 2026-09-08 (локальная сборка, в прод не выкатано)

Реализованы этапы 1, 2.1, 3.1, 3.2. Проверка — production-сборка
(`nuxt build` + `node .output/server/index.mjs`) и Playwright.

| Метрика | Прод до | Локально после |
|---|---|---|
| `<link rel="stylesheet">` в SSR-HTML, любая страница | 25–36 | **1** (`entry.css`, 20 КБ brotli, immutable) |
| HTML `/clinics` | 431 КБ | **233 КБ** |
| HTML `/services` | 1 254 КБ | **647 КБ** |
| inline-SVG на `/clinics` | 300 | 106 |
| Mixpanel-чанк (124 КБ) | вместе с гидрацией | через ~400 мс после `load`, в idle |
| `gtag.js` (166 КБ) | из `<head>` у всех | через ~400 мс после `load`, в idle |
| prefetch payload'ов на листинге | по всем видимым ссылкам | 0 (только по наведению) |

Что изменено:

- `assets/css/element-plus.css` — 36 файлов theme-chalk только для
  используемых компонентов и их зависимостей (список получен обходом
  `es/components/*/style/css.mjs`); `elementPlus.importStyle: false`.
- `nuxt.config.ts` — `features.inlineStyles: id.includes('.vue')`, хук
  `build:manifest` обнуляет `css` у не-entry чанков,
  `experimental.defaults.nuxtLink.prefetchOn: { interaction: true }`,
  `gtag.enabled: false` + `public.gtagEnabled`.
- `composables/use-analytics.ts` — `startAnalytics()`: `onNuxtReady` →
  `requestIdleCallback` (таймаут 3 с, фолбэк `setTimeout` 2 с) → `initialize()`
  gtag + Mixpanel по согласию. `withMixpanel` сам стартует загрузку SDK, если
  событие пришло раньше idle. `layouts/default.vue` — watch без `immediate`.
- `components/clinic/summary.vue` — `ContactsList` рендерится после первого
  раскрытия; `LazyClinicServiceSectionContent` и `LazyDoctorInfo` с
  `hydrate-on-visible` (HTML и ссылки в SSR остаются).
- **Попутно найден и исправлен баг** (`composables/use-cookie-control.ts`):
  клик «Разрешить аналитику» на проде не запускал Mixpanel до следующей
  полной загрузки — GA включался, Mixpanel нет. У каждого `useCookie()` свой
  ref, значение между ними Nuxt разносит асинхронно через `cookieStore`;
  `initMixpanel()` читал ещё старое. Теперь значение согласия в `useState`,
  cookie — только хранилище. Проверено: после клика SDK грузится сразу,
  после «Отклонить» — не грузится.

Проверено Playwright: стили EP на месте (кнопки, инпуты, селекты,
пагинация, теги, тултипы, collapse); клиентская навигация без FOUC
(computed styles после перехода совпадают с SSR-загрузкой); «показать ещё»
внутри лениво гидрируемой секции работает; секция «Врачи» раскрывается;
консоль чистая; typecheck зелёный.

Побочный эффект, осознанный: CSS чанков теперь догружается после гидрации
хелпером Vite (≈50 мелких запросов на первом заходе, потом из кэша). Раньше
они же стояли в `<head>` блокирующими; общее число запросов не выросло
(на проде после гидрации было 66 stylesheet, стало 53).

### Замер на проде после релиза (2026-09-08 12:55, `data/lighthouse/docta.me-20260908T125523.json`)

Релиз на месте: в отчёте `entry.Cfe2MLvI.css`, HTML 195 КБ, один блокирующий
ресурс. Cloudflare HTML не кэширует (`cf-cache-status: DYNAMIC`), кэш ни при
чём.

| Аудит | Было (отчёт из постановки) | Стало |
|---|---|---|
| Render-blocking | 25 файлов, 860 мс | 1 файл (`entry.css`), 80 мс |
| Критическая цепочка | 995 мс, 25 CSS | 869 мс: HTML → beacon CF → `/cdn-cgi/rum` |
| JS execution | 1,6 с | 1,4 с |
| Main thread | 3,4 с | 2,7 с |
| TBT | — | 380 мс |
| FCP = LCP (simulated) | — | **5,8 с**, perf score 55 |
| FCP = LCP (observed, реальная сеть) | — | **608 мс**, load 772 мс |

Почему score не сдвинулся. Lighthouse в режиме `simulate` считает FCP
не по реальному рендеру, а по графу Lantern: в него попадает всякий ресурс с
приоритетом High/VeryHigh, который в наблюдаемой трассе успел загрузиться
до реального FCP. На быстрой сети 96 `<link rel="modulepreload">` (High,
326 КБ transfer) плюс entry-чанк 101 КБ доезжают раньше первой отрисовки
(608 мс) — и симулятор объявляет их всех «блокирующими», раскатывая на
1,6 Мбит/с и RTT 150 мс в 5,8 с. Реальный браузер рисует после CSS, не
дожидаясь модулей, но в лабораторной метрике это не видно. Раньше на том же
месте стояли 25 CSS — цифра FCP почти не изменилась, потому что узкое место
графа переехало с CSS на JS.

Следствие: следующий рычаг для лаборатории — **число и размер чанков**, а не
CSS. Проверено локальной сборкой с
`vite.build.rollupOptions.output.experimentalMinChunkSize: 20000` (Rollup
сливает мелкие чанки с общими зависимыми, семантика не меняется):

| | Сейчас | С minChunkSize 20 КБ |
|---|---|---|
| JS-чанков в сборке | 353 | 234 |
| `modulepreload` на `/clinics/<slug>` | 96 | 46 |
| `modulepreload` на `/clinics` | 104 | 58 |

**Внедрено 2026-09-08** хуком `vite:extendConfig` в `nuxt.config.ts` (в поле
`vite.build.rollupOptions.output` не проходит typecheck: типы конфига Nuxt
берёт из вложенного Vite 8 на Rolldown, а собирает Vite 7 на Rollup 4).
Проверено на сборке: суммарный вес preload-чанков страницы клиники не вырос
(318 КБ сжатых против 326 КБ в отчёте с прода — те же байты, но в 46 файлах
вместо 96), entry-чанк 101 → 117 КБ за счёт влитых мелких модулей,
клиентская навигация листинг → клиника → врач → услуга → лекарства без
расхождений в стилях и без ошибок, typecheck зелёный. После деплоя —
перемерить, ожидание: симулированный FCP/LCP заметно ниже 5,8 с.

Остальное из отчёта:

- `bf-cache`: главный документ пришёл с `cache-control: no-store` — это
  серверный плагин приватного кэша для залогиненных (другая задача, работает
  как задумано); в профиле замера была авторизация.
- `unused-css` 18 КБ из 20 в `entry.css` — плата за общий EP-файл; уйдёт с
  Element Plus.
- `image-delivery` 197 КБ — фото врачей 25–50 КБ каждое при отображении
  в 40 px: отдавать уменьшенные варианты (отдельная задача).
- Мусор от Cloudflare `jsd/main.js`: 3 deprecation-warning, `third-party-cookies`
  от Mixpanel — решения из этапа 2.3.

### Осталось

- **Выкатить `experimentalMinChunkSize` и перемерить** Lighthouse на проде.
- 2.2 — тонкий клиент вместо `mixpanel-browser` (решение).
- 2.3 — панель Cloudflare: Web Analytics, JavaScript Detections (решение).
- 3.3 — спрайт иконок: `/services` всё ещё 647 КБ и 308 SVG, `/doctors`
  579 КБ и 128 SVG — следующий по размеру рычаг.
- 4 — `nuxi analyze` entry-чанка как аргумент к prd/element-plus-removal.
