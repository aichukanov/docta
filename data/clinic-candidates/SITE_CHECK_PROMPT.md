# Промпт субагента: проверка сайтов кандидатов

Этим промптом 2026-10-08 заполнен `site-checks.json`: 8 субагентов, по ~16 сайтов на каждого. Батчи собираются из `candidates.json` — домены без записи в `site-checks.json`. Каждый субагент пишет в свой файл (общий файл при параллельной работе теряет правки), потом файлы склеиваются в `site-checks.json` с полем `checkedAt`.

Для мест без сайта к промпту добавлялось: сначала найти собственный сайт клиники через WebSearch (агрегаторы, Facebook и Instagram — не сайт); не нашёл — запись `siteState: "no_site"` с `placeId`.

---

## Задача

Мы решаем, какие клиники добавлять в каталог docta.me первыми. Порядок: (1) есть прейскурант И список врачей → (2) есть хотя бы список услуг → (3) только отзывы в Google. Для этого по каждому сайту из твоего батча нужно установить ФАКТЫ.

Вход: `{DIR}/batch-{N}.json` — массив `{domain, site, places[] ("название | адрес | rc=число отзывов Google"), sheetNotes[]}`.
Выход: `{DIR}/site-check-{N}.json` — массив объектов по схеме ниже, по одному на домен, в том же порядке. Пиши файл через Write (не через bash-строку). Перезаписывай его по мере продвижения (каждые 3–4 сайта), чтобы работа не терялась.

## Как проверять

- Только curl через Bash: `curl -sL -m 25 -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/128 Safari/537.36" URL`. НЕ используй WebFetch для извлечения фактов — его пересказ достраивает отсутствующие поля. Если curl не берёт (TLS) — попробуй `-k` и http://.
- Обходи: главную, меню/ссылки, `/sitemap.xml`, `/sitemap_index.xml`, `/wp-json/wp/v2/pages?per_page=100&_fields=link,title,modified` (WordPress), страницы со словами cjenovnik / cijene / cenovnik / cjenik / price / prices / цены / usluge / services / tim / nas-tim / ljekari / doktori / ekipa / osoblje / team / o-nama / about.
- Цены: ищи «€», «EUR», «eur», а также числа вида «25,00» / «40.00» рядом с названиями услуг. Прайс может быть PDF/картинкой — тогда запиши URL файла и `kind`.
- Если сайт пустой в сыром HTML (JS-приложение) — посмотри JSON в странице (__NEXT_DATA__, __NUXT__), API-запросы в бандле. Если не вышло — так и напиши.
- Если сайт мёртв / домен свободен / припаркован / чужой контент — попробуй найти новый сайт клиники через WebSearch (название + город). Найденный новый сайт тоже проверь и запиши в `newSite`.
- Instagram и Facebook не читаются — не трать на них время, просто отметь, если сайт ведёт только туда.
- Не больше ~8 минут на сайт. Не выдумывай: чего не видел своими глазами в ответе curl — пиши null и `"NOT STATED"` в notes. Числа (кол-во позиций, врачей) — посчитанные, а не оценка на глаз; если оценка — пометь `~`.

## Схема записи

```json
{
  "domain": "example.me",
  "checkedUrl": "https://example.me/",
  "alive": true,
  "siteState": "ok | dead | parked | foreign_content | facebook_only | js_unreadable",
  "newSite": null,
  "isMedical": true,
  "kind": "dental | polyclinic | physio | gyn | ophtho | derm | aesthetic | lab | radiology | pediatric | psych | hospital | dom_zdravlja | public_institute | other",
  "cities": ["Podgorica"],
  "branches": ["адрес филиала 1", "адрес 2"],
  "pricelist": { "status": "full | partial | on_request | none", "urls": ["..."], "kind": "html | pdf | image | json-api | docx | null", "approxItems": 0, "dateHint": "дата прайса и откуда она (modified в wp-json, дата в PDF, ...)", "currencyFormat": "напр. «25€», «25,00 EUR»" },
  "doctors": { "status": "list | partial | single | none", "urls": ["..."], "count": 0, "names": ["Ime Prezime — специальность", "..."] },
  "services": { "status": "list | partial | none", "urls": ["..."], "approxCount": 0 },
  "languages": "языки сайта (me/en/ru/...); упоминания русскоязычных врачей — дословно",
  "notes": "только факты: что видел, где; что не удалось прочитать"
}
```

- `pricelist.status`: `full` — отдельная страница/файл с ценами на большинство услуг; `partial` — 1–15 цен (акции, пакеты); `on_request` — прямо написано «цена после консультации»; `none` — цен нет.
- `doctors.status`: `list` — страница команды с ≥2 врачами; `single` — сайт одного врача; `partial` — врачи упоминаются на страницах услуг, без общего списка; `none` — имён нет. Медсёстры/админы — не врачи, но физиотерапевты и стоматологи — да. В `names` — все врачи (если больше 60 — первые 60 и пометка).
- `services.status`: `list` — есть перечень услуг (хотя бы названия).

В финальном ответе — 3–5 строк: сколько сайтов проверено, у скольких full-прайс + list врачей, что не удалось проверить.
