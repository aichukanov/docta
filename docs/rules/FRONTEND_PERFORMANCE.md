# Производительность фронтенда: что настроено и что не ломать

Итог перф-аудита 2026-09 (`docs/audit/lighthouse-perf-2026-09.md`): Lighthouse
mobile на странице клиники 55 → 90. Здесь — инварианты, которые дали результат,
и как проверять, что они живы. Разбор и цифры — в аудите, здесь только правила.

## 1. В SSR-HTML ровно один `<link rel="stylesheet">`

Это `entry.css`: токены ui-kit, стили Element Plus, мост EP → токены.
Стили `.vue`-компонентов инлайнятся в `<style>`. Держится на трёх вещах в
`nuxt.config.ts`:

| Настройка | Зачем |
|---|---|
| `features.inlineStyles: (id) => id.includes('.vue')` | инлайнить только компоненты; глобальный CSS остаётся кэшируемой ссылкой |
| хук `build:manifest` обнуляет `css` у не-entry чанков | Nuxt оставляет `<link>` на CSS общих чанков (`_KitAvatar`, `use-in-viewport`…), дублируя инлайн байт в байт |
| `elementPlus: { importStyle: false }` + `assets/css/element-plus.css` | иначе каждый el-компонент приносит свой CSS отдельным блокирующим файлом |

**Новый el-компонент требует строки в `assets/css/element-plus.css`**, иначе
выйдет без стилей. У части компонентов свой файл пустой (tooltip → popper,
dropdown-menu/-item → dropdown, tab-pane → tabs). Файл удаляется вместе с
Element Plus (prd/element-plus-removal, итерация 5); хук и `inlineStyles`
при этом остаются — они про Nuxt, не про EP.

Побочный эффект, осознанный: после гидрации Vite сам догружает CSS чанков
(~20–30 мелких запросов, `link[rel=stylesheet]` в DOM становится 20–30).
Это не регресс: раньше те же файлы стояли блокирующими в `<head>`.

## 2. Мало чанков: `experimentalMinChunkSize: 20000`

Стоит в хуке `vite:extendConfig`, а не в `vite.build.rollupOptions.output`:
сборку делает Vite 7 на Rollup 4, а типы конфига Nuxt берёт из вложенного
Vite 8 на Rolldown, где опции нет — поле не проходит typecheck. Дало
353 → 234 чанка и 96 → 46 `modulepreload` на страницу при том же весе, и
именно это опустило симулированный FCP с 5,8 до 1,35 с (см. §5).
При переезде на Vite 8 опцию пересмотреть.

## 3. Аналитика — после гидрации, в простое

- `startAnalytics()` из `composables/use-analytics.ts` вызывается в
  `layouts/default.vue`: `onNuxtReady` → `requestIdleCallback` (таймаут 3 с,
  фолбэк `setTimeout` 2 с) → `initialize()` gtag и Mixpanel по согласию.
- `gtag.enabled: false` в конфиге: скрипт вставляет только `initialize()`,
  и только при `public.gtagEnabled` (production). dataLayer и
  consent-default модуль заводит сразу, команды до загрузки не теряются.
- Первое событие раньше idle само запускает загрузку SDK (`withMixpanel`).
- Согласие живёт в `useState('cookie-consent')`, cookie — только хранилище
  (`use-cookie-control.ts`). Причина: у каждого `useCookie()` свой ref, и
  Nuxt синхронизирует их асинхронно через `cookieStore`; на старом коде клик
  «Разрешить аналитику» включал GA, но не Mixpanel до перезагрузки.
- Watch на согласие в layout — без `immediate`; вернуть `immediate: true`
  значит снова грузить 290 КБ SDK в критическом пути.

## 4. Листинги: что рендерится, а что нет

- В `ClinicSummary` секция «Контакты» рендерится после первого раскрытия
  (`el-collapse-item` прячет содержимое через `v-show`, и 20 карточек уносили
  ~100 КБ скрытых копи-кнопок с тултипами). У контактов в свёрнутой карточке
  нет SEO-ценности — они есть на странице клиники.
- Секции «Услуги» и «Врачи» **остаются в SSR-HTML**: ссылки на врачей в
  карточках клиник на `/services/<slug>` — намеренная перелинковка
  (prd/service-page-doctor-links). Для них ленивая гидрация
  `hydrate-on-visible`, не `v-if`.
- Prefetch `NuxtLink` — по наведению (`experimental.defaults.nuxtLink`).
  На листинге ~100 внутренних ссылок; дефолтный `visibility` префетчил
  чанки и payload всех видимых страниц.

## 5. Как мерить, чтобы не обманываться

- **Смотреть `observed*` метрики и число запросов, а не только score.**
  Lighthouse в режиме simulate строит FCP по графу Lantern: любой ресурс с
  приоритетом High, доехавший до реального FCP, считается блокирующим. На
  быстрой сети это все `modulepreload` — поэтому число чанков влияет на
  симулированный FCP сильнее, чем их вес. Реальный FCP на проде ~0,4–0,6 с.
- Отчёты хранить в `data/lighthouse/*.json` (в git не коммитить без нужды),
  сравнивать скриптом по `audits.metrics`, `network-requests`,
  `render-blocking-insight` (Lighthouse 13 переименовал аудиты в `*-insight`).
- Проверять прод только браузером или `curl` с браузерными заголовками:
  без `Accept: text/html` и UA Cloudflare не инжектит свои скрипты, и картина
  неполная. Десятки `curl` подряд включают challenge («Just a moment...») —
  см. память про Cloudflare и e2e.
- HTML на проде Cloudflare не кэширует (`cf-cache-status: DYNAMIC`), поэтому
  «не поменялось после релиза» — не кэш; сверять `buildId` в HTML.
- Локальная проверка: `nuxt build` → `PORT=3999 NODE_ENV=production node
  --env-file=.env .output/server/index.mjs` → Playwright из папки проекта.
  Гидрацию сравнивать по computed styles после клиентской навигации против
  прямой загрузки той же страницы; побайтовое сравнение HTML врёт на
  `viewBox`/`viewbox`, `&nbsp;` и фолбэках картинок, которых нет локально.

## 6. Что в отчёте не наше и что решено оставить

`beacon.min.js` + `/cdn-cgi/rum` (Cloudflare Web Analytics) и
`challenge-platform/.../jsd/main.js` (JavaScript Detections из Bot Fight Mode)
Cloudflare вписывает в HTML на edge; в коде и в `.output` их нет. Это ~430 мс
CPU и вся «критическая цепочка» в отчёте. **Решение 2026-09-08: оставить как
есть.** Управляется только в панели Cloudflare (Web Analytics; Security →
Bots), менять по одной настройке и проверять WebView Telegram.

## 7. Что ещё можно снять (не сделано)

- Спрайт иконок: `/services` — 647 КБ HTML и 308 inline-SVG, `/doctors` —
  579 КБ. Правка в `@ach/ui-kit` и `components/icon/`, с превью.
- Фото врачей 25–50 КБ под 40–120 px — уменьшенные варианты.
- Entry-чанк (~475 мс eval) — уменьшится только с выносом Element Plus.
- Тонкий клиент вместо `mixpanel-browser` (124 КБ) — решение.
