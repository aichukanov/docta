# Локаль и кэш HTML на Cloudflare

## Зачем

Замер на проде (2026-08-31): листинг отдаётся за 1,9–2,5 с, и это **рендер Vue,
а не база** — те же данные через API приходят за 23–66 мс. На сервере 4 ядра,
которые docta делит с тремя соседними приложениями. Значит главный рычаг —
не трогать рендер вовсе, то есть кэшировать HTML.

Кэшировать HTML можно только тогда, когда один адрес отдаёт всем одно и то же.
Раньше это было не так: локаль выбиралась по cookie, и голый URL отвечал разным
людям по-разному.

## Что уже сделано в коде

`server/common/redirect/regional-settings.ts` — **сервер определяет локаль
только по адресу**: голый URL это дефолтная локаль (`sr`), `?lang=X` это X.
Cookie на ответ не влияет. Все редиректы постоянные и зависят только от URL.

`nuxt.config.ts` — на кэшируемые маршруты выставлен
`Cache-Control: public, max-age=0, s-maxage=…, stale-while-revalidate=86400`.
`max-age=0` оставляет за браузером перепроверку (правка контента видна сразу),
`s-maxage` работает только на общих кэшах.

**Не кэшируются** `/clinics/**` и `/doctors/<slug>`: там в серверную разметку
попадает баннер владельца (`isOwner`), то есть ответ зависит от того, кто
смотрит. Границы правил проверены прогоном набора через radix3 — при правке
списка проверку повторить, цена ошибки здесь утечка чужого блока, а не
медленная страница.

`plugins/locale-preference.client.ts` — возвращает посетителю его язык уже
после гидратации, читая cookie. Это фолбэк: работает всегда, но первый экран
успевает показаться на дефолтной локали.

## Что нужно сделать в панели Cloudflare

### 1. Cache Rule на HTML

Без правила Cloudflare не кэширует HTML даже с нашими заголовками —
`cf-cache-status` останется `DYNAMIC`, и заголовки будут безвредны, но
бесполезны.

Rules → Cache Rules → Create:

- **When:** `(http.request.uri.path eq "/") or (starts_with(http.request.uri.path, "/articles/")) or (starts_with(http.request.uri.path, "/services")) or (starts_with(http.request.uri.path, "/labtests")) or (starts_with(http.request.uri.path, "/medicines")) or (starts_with(http.request.uri.path, "/medications")) or (starts_with(http.request.uri.path, "/insurance-companies")) or (http.request.uri.path eq "/doctors") or (http.request.uri.path eq "/clinics") or (http.request.uri.path in {"/about" "/terms" "/privacy"})`
- **Then:** Eligible for cache, Edge TTL → «Use cache-control header if present»

Отдельным правилом стоит закэшировать `/sitemap.xml` и `/sitemaps/*`: сейчас
они отдаются с `Cache-Control: public, max-age=3600`, но `cf-cache-status`
показывает `DYNAMIC`, то есть каждый заход бота доходит до origin.

### 2. Воркер, возвращающий выбор по cookie

Скрипт — `cloudflare-locale-worker.js` рядом с этим файлом.

Он делает на краю сети ровно то, что раньше делал сервер: если в адресе нет
`?lang=`, а в cookie лежит непустая локаль, отдаёт 302 на адрес с языком.
Разница принципиальная — редирект обслуживается на краю, до кэша и без
обращения к origin, а все адреса остаются кэшируемыми.

Итог для посетителя: возвращающийся человек с cookie `ru` получает русскую
версию из кэша за один лишний хоп (~10 мс на краю), а не рендер на origin за
две секунды. Краулер приходит без cookie, видит голый URL и дефолтную локаль —
ровно то, что объявлено в canonical и sitemap.

Установка: Workers & Pages → Create Worker → вставить скрипт → Deploy →
добавить Route `docta.me/*` (и `www.docta.me/*`, если он проксируется).

## Альтернатива, которую не выбрали

Можно было не редиректить, а варьировать **ключ кэша** по cookie: воркер
подмешивает локаль в ключ, ходит на origin за `?lang=X` и отдаёт результат по
голому адресу. Тогда URL остаётся чистым и лишнего хопа нет.

Не выбрано по двум причинам. Во-первых, страница, отданная по голому адресу,
объявляла бы `canonical` на `?lang=X` — для краулера это не видно (он без
cookie), но расхождение неприятное и его легко забыть. Во-вторых, весь проект
уже держит локаль в URL: canonical, hreflang и sitemap построены на `?lang=`,
и редирект приводит посетителя на тот адрес, который эту версию и представляет.

`Vary: Cookie` не рассматривался вовсе: ключом стало бы всё содержимое cookie,
включая идентификатор сессии, и кэш выродился бы в пустой.

## Как проверить, что работает

```sh
# Заголовки на месте (origin)
curl -sI https://docta.me/services | grep -i cache-control

# Cloudflare кэширует (после правила): ожидается HIT на втором запросе
curl -sI https://docta.me/services | grep -i cf-cache-status
curl -sI https://docta.me/services | grep -i cf-cache-status

# Локаль не зависит от cookie на origin
curl -s -H 'Cookie: locale=de' https://docta.me/ | grep -o '<html[^>]*lang="[^"]*"'   # sr
curl -s -H 'Cookie: locale=de' 'https://docta.me/?lang=ru' | grep -o '<html[^>]*lang="[^"]*"' # ru

# Воркер редиректит по cookie (после установки)
curl -sI -H 'Cookie: locale=de' https://docta.me/ | grep -iE '^(HTTP|location)'  # 302 -> /?lang=de
```

## Чего нельзя делать

Возвращать выбор локали по cookie на сервер. Это снова сделает один адрес
зависящим от посетителя и выключит кэш целиком — вместе со всем выигрышем.
Если понадобится изменить приоритет, менять его надо в воркере.
