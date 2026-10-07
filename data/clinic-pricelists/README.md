# Карта прайс-листов на сайтах клиник

Где на сайтах клиник из нашей БД опубликованы цены, а где их нет. Карта нужна
для периодической перепроверки цен; журнал актуальности строится поверх неё.

Срез: **2026-10-02**, локальная БД, 140 клиник.

## Файлы

- `map.json` — сама карта. По записи на сайт; клиники, у которых один сайт на
  несколько филиалов, сгруппированы. Клиники без сайта идут отдельными записями
  со статусом `no_website`. Поля записи:
  - `clinics[].db` — сколько у нас услуг и анализов и сколько из них с ценой (на дату среза);
  - `status` — см. легенду ниже;
  - `pricelists[]` — `url`, `kind` (html/pdf/image/json-api/docx), `scope`,
    `approx_items`, `date_hint` (дата прайса и откуда она взята);
  - `flags` — что выявила проверка и что нужно сделать (см. «Выводы»);
  - `recheckHint` — подводный камень при повторной проверке (UA, TLS, формат цен);
  - `lastChecked`;
  - `localSource` — папка с оригиналом прайса в `data/pricelists/`, если он есть
    (у восьми клиник; у четырёх из них публичного URL нет вовсе).
- `sources/<slug>/<YYYY-MM-DD>.<ext>` — снимки прайсов с сайтов на дату проверки,
  для будущих перепроверок. Оригиналы, полученные вручную, лежат не здесь, а в
  `data/pricelists/` (см. её README).
- `scan-<дата>.json` — сырой вывод краулера `scripts/clinics/scan-clinic-pricelists.mjs`.

## Как собиралась

1. Краулер прошёл главную, sitemap и ссылки со словами «cjenovnik / cijene /
   price». Как самостоятельный источник он ненадёжен, ошибается в обе стороны:
   - не видит цены без знака € («15.00», «40,oo», «3400 / eur»);
   - не видит JS-сайты и страницы прайса, на которые нет ссылки из меню;
   - ложно срабатывает на донации, ваучеры, отчёты, спам на взломанном сайте
     и старый прайс в HTML-комментарии (normedica).
2. Поэтому все 104 сайта проверили вручную, curl'ом по сырому HTML,
   с wp-json, sitemap, Wayback и JSON API.

Итог: **46 сайтов с прайсом** (34 страницы, 11 файлов, 1 — цены по страницам услуг),
9 с отдельными ценами, 44 без цен, 3 сайта лежат, 1 «цена по
запросу», 30 клиник без сайта.

## Статусы

| status | Значение |
|---|---|
| `pricelist_page` | Отдельная HTML-страница (или API) с полным прайсом. |
| `pricelist_file` | PDF, картинка или doc с прайсом. |
| `prices_on_service_pages` | Цены разбросаны по страницам услуг. |
| `partial_prices` | 1–15 цен: акции, пакеты, одна цена в FAQ. Для сверки не годится. |
| `price_on_request` | На сайте прямо написано «цена после осмотра». |
| `site_down` | Сайт не работает: заглушка, 503 или припаркованный домен. |
| `no_prices` | Цен на сайте нет. |
| `no_website` | В БД нет сайта. |

## Выводы

Хвосты каталога и процесса после импортов — в [BACKLOG.md](BACKLOG.md).

### 1. На сайте есть прайс, а у нас цен нет или их заметно меньше

| id | Клиника | На сайте | У нас | Замечание |
|---|---|---|---|---|
| 62 | Diagnostica | 634 (469 анализов + 165 услуг) | 0 → 447 анализов + 129 услуг | Открытый JSON: `api.diagnostica.me/api/public/pricelist`, с кодами. Импортировано 2026-10-05, в проде; спорные позиции разобраны 2026-10-06 (+7 услуг, +13 анализов, в проде). |
| 65 | КЦЦГ | 2975 (2277 амбулаторных + 698 групп DRG) | 0 → 2199 услуг + 658 анализов | Прайс для неосигуранных 2019 + изменения 2025, сканы (OCR + транскрипция). Импортировано 2026-10-06, в проде; стационар — DRG 2025, 963 новые записи каталога. |
| 39 | Vaše zdravlje | 255 (107 услуг + 148 анализов) | 0 → 88 услуг + 148 анализов | HTML, правка страницы 2026-04-22 (wp-json). Импортировано 2026-10-05, в проде; спорные позиции разобраны 2026-10-06 (в проде). |
| 54 | Natal | 130 (112 поликлиника + 18 педиатрия) | 112 → 92 услуги (2 is_obsolete) + 26 анализов | wp-json CPT `cjenovnik`, у каждой позиции дата правки. Синхронизировано 2026-10-05, в проде. Раздел pedijatrija — отдельная локация Natal Kids: клиника 161 (pedijatrija-natal-kids-podgorica), 25 строк, в проде 2026-10-06. |
| 86 | Tesla Medical | 119 услуг + ~1000 строк лаборатории | 77 / 0 → 121 услуга + 900 анализов | PDF лаборатории 2019 с пометкой «radna verzija» (черновик). Импортировано 2026-10-05, в проде; без outdated по решению юзера. 30 спорных разобраны 2026-10-06 (в проде). |
| 28 | Codra | 95 анализов | 0 → 81 анализ + забор крови | Картинка JPG 2022 года. Импортировано 2026-10-05, в проде; всё с `is_price_outdated`. |
| 26 | Svjetlost Budva | 69 | 0 → 66 | HTML, изменена 2026-04. Импортировано 2026-10-02, в проде. |
| 25 | Optimal | 70 | 0 → 67 из 70 услуг + 8 анализов без цены | PDF 2016, `is_price_outdated` по решению юзера. Импортировано 2026-10-02, в проде. |
| 140 | ДЗ Подгорица | 36 + 3 | 0 → 38 | Справки, систематические осмотры, спортивная медицина. Импортировано 2026-10-02, в проде. |
| 69 | Balans | 35 | 0 → 34 | HTML. Импортировано 2026-10-02, в проде. |
| 35 | Naša medicina | 33 | 6 → 31 | HTML. Синхронизировано 2026-10-02, в проде. |
| 40 | Primus | 19 | 0 → 20 | Три PDF по отделениям. Импортировано 2026-10-02, в проде; урология и нефрология — без outdated (решение юзера). |
| 24 | Dr Viller | 13 | 0 → 12 | По-русски, цены «от». Импортировано 2026-10-02, в проде. |
| 127 | ДЗ Мойковац | + справки и санитарные осмотры | 274 → 297 услуг | Два отдельных PDF (2019, сканы), 23 позиции с `is_price_outdated`. Импортировано 2026-10-02, в проде. |

Отдельно — **ДЗ Подгорица** выложил `Cijenovnik-PZZ-2026-1.pdf`, тарифник FZOCG
по ПЗЗ. Сверено 2026-10-02: побайтно та же редакция, что у нас (от 01.05.2026).
Попутно исправлен наш импорт — блок H01, D17003 и 5 названий
(`update-tariff-fzocg-pzz-2026.sql`, в проде).

### 2. У нас есть цены, а перепроверить их на сайте нельзя

| id | Клиника | У нас | Что с источником |
|---|---|---|---|
| 88 | Bolnica Danilo I | 2296 / 387 | Страница прайса в Maintenance Mode, данные из локальных PDF. |
| 141 | ОБ Никшич | 2358 / 385 | Данные из PDF, публичного URL не найдено. |
| 64 | Novi Standard | 107 / 938 | На сайте только акции, наши цены из PDF или фото. |
| 48 | Dr Zejnilović | 8 / 352 | На сайте цен нет. |
| 15 | A3 Medical | 384 / 4 | **Цены сняты с сайта**: /me/pricelist/ теперь без цен. В Wayback 2026-05-14 было ~400 цен. Осталось ~50 на страницах специальностей. 348 услуг + 3 анализа — `is_price_outdated` (в проде 2026-10-02). |
| 68 | Konzilijum | 215 | Цены сняты: были до 2022 года (Wayback), сейчас страницы /cjenovnik-* без цен. Все 215 — `is_price_outdated` (в проде 2026-10-06). |
| 60 | Buntić | 145 | Домен припаркован и продаётся, прайс только в Wayback 2026-02-16. |
| 122 | Vučetić | 29 | На сайте цен нет. |
| 41, 42, 47 | Debelja, Just Dental, Dental Expert | 7 / 16 / 15 | Сайта нет. |

Для этих клиник журнал актуальности вести не по сайту, а по дате нашего
импорта. A3 и Konzilijum: `is_price_outdated` (решение юзера).

### 3. На сайте позиций меньше, чем у нас: кандидаты в `is_obsolete`

- **101 Nova Medic** — синхронизировано 2026-10-02, в проде: 103 активных позиции, снятые разделы — `is_obsolete`, 6 ушедших врачей отвязаны.
- **20 Pavlin** — на сайте 15–18 цен, у нас 30. Не трогаем: хозяева следят сами (решение юзера).

### 4. Нужно поправить `website` в БД

| id | Сейчас | Нужно |
|---|---|---|
| 5–9 | mojlab.me/… (404) | **Сделано** (в проде): новые адреса /lokacije/*, сеть расширена до 17 клиник |
| 126 | www.dzkotor.me (припаркован у Sedo) | **Сделано** (в проде): https://domzdravljakotor.me/ |
| 12 | страница SmartMed Kotor — «Page Not Found» | теперь только лаборатория: врачи отвязаны, тип — Diagnostic Laboratory, поле сайта очищено (в проде) |
| 60 | montenegrodentistry.me (продаётся) | **Сделано** (в проде): поле очищено |
| 59 | cenexmedical.com | сайт взломан (спам казино на главной); оставить, но не ссылаться |

### 5. Устаревшие прайсы на сайтах

Цены на этих сайтах сами по себе старые, и наши совпадают с ними. Сайт не
поможет понять, актуальны ли цены, поэтому кандидаты на `is_price_outdated`:

- drraznatovic (102) — 2015;
- Bellavista (110) — 2018;
- ДЗ Херцег-Нови (80) — 2019;
- ДЗ Даниловград (85) — 2019;
- Tesla (86) — 2020;
- ДЗ Тиват (134) — 2022;
- Prlja (109) — 2023;
- Рисан (131) — 2023;
- Milmedika Tivat (3) — 2025-03.

### 6. Прайс может пропасть

- **ДЗ Колашин (128)** — пункт меню «Cjenovnik» после пересборки сайта ведёт на `#`. PDF пока открывается по прямой ссылке.
- **ДЗ Мойковац (127)** — часть старых прайсов прилинкована на мёртвый домен `mojkovac.mojmail.me`, рабочие копии лежат на dzmojkovac.me.

## Журнал актуальности

Карта показывает, где лежит прайс. Журнал показывает, изменился ли прайс с прошлой проверки.

```
node scripts/clinics/check-pricelists.mjs                  # все клиники
node scripts/clinics/check-pricelists.mjs --only=<slug,slug>
```

**Что делает скрипт:**

- Обходит `pricelists[].url` из `map.json` у записей с собственным прайсом
  (статусы pricelist_page, pricelist_file, prices_on_service_pages, partial_prices).
  Это около 94 URL, прогон занимает пару минут.
- Снимает отпечатки:
  - HTML и JSON — по ценовым токенам («40 €», «€50», «15.00», «40,oo», поля `price*` в
    JSON) и отдельно по тексту;
  - PDF, картинки, doc — sha256 байтов.
- Пропускает:
  - Wayback;
  - PDF Invitro — он генерируется на лету, сверяется HTML;
  - записи со статусом `no_prices`.
- Изменившийся источник сохраняет снимком в `sources/<slug>/<дата>-<хэш>.<ext>` (до 5 МБ),
  чтобы по нему готовить обновление цен.

**Результат** — `journal.md`, состояние хранится в `journal.json`. В отчёте:

- что изменилось — с примерами появившихся и пропавших цен;
- что недоступно;
- правки текста без изменения цен;
- таблица по клиникам: последняя проверка, последнее изменение источника, дата нашего
  импорта (из записи импорта или из отметки «в проде …» во `flags` карты).

**Как работать.** Прогон — раз в месяц, руками или по расписанию. По клиникам из раздела
«Изменились» готовится SQL обновления цен по `docs/import/PRICE_COLLECTION_AGENT.md`.

Базовая линия снята 2026-10-06. Повторный прогон дал 0 ложных изменений.

## Повторная проверка: подводные камни

У тех, кому нужен особый подход, это записано в поле `recheckHint` в `map.json`.
Основное:

- bonomedica.com и kbcberane.me отдают 406 на короткий User-Agent, нужен полный браузерный UA и `Accept`;
- у drkukoljac.com битый TLS-сертификат, нужен `curl -k`;
- у dzmojkovac.me wp-json работает только через `?rest_route=`;
- у Invitro PDF генерируется на лету (хэш каждый раз новый), сверять HTML;
- у Milmedika дата обновления лежит в поле `lastUpdated` в RSC-данных страницы;
- у normedica.me на /cjenovnik.html в HTML-комментарии спрятан старый прайс 2023 года, сверять только PDF;
- форматы цен, которые ломают простой парсинг: «5 0€» (drmedan), «40,oo» (prlja), цены, разорванные тегами (dukley).

## Таблицы по статусам

Колонка «У нас» — услуги / анализы с ценой в БД на дату среза. «Позиций» —
примерная оценка проверяющего, по первому из прайсов клиники. «(+N)» — у
клиники ещё N прайсов, все URL есть в `map.json`.

### pricelist_page (34)

| id | Клиника | Прайс | Позиций | Дата | У нас (усл/анализы) |
|---|---|---|---|---|---|
| 1 | milmedika-podgorica | [milmedika.com/cjenovnik/milmedika-podgorica](https://milmedika.com/cjenovnik/milmedika-podgorica) (+1) | 449 | 2026-02-06 | 139 / 311 |
| 2 | milmedika-niksic | [milmedika.com/cjenovnik/milmedika-niksic](https://milmedika.com/cjenovnik/milmedika-niksic) (+1) | 594 | 2026-09-08 | 264 / 325 |
| 3 | milmedika-tivat | [milmedika.com/cjenovnik/milmedika-porto-montenegro](https://milmedika.com/cjenovnik/milmedika-porto-montenegro) | 493 | 2025-03-25 | 183 / 308 |
| 4 | milmedika-budva | [milmedika.com/cjenovnik/milmedika-budva](https://milmedika.com/cjenovnik/milmedika-budva) (+1) | 334 | 2026-02-06 | 71 / 264 |
| 17 | bonomedica-budva | [bonomedica.com/mne-cjenovnik](https://bonomedica.com/mne-cjenovnik/) (+3) | 78 | 2025 | 71 / 5 |
| 20 | pavlin-dental-clinic-bar | [dental-clinic-pavlin.me](https://www.dental-clinic-pavlin.me/) (+3) | 13 | 2026 | 30 / 0 |
| 24 | drviller-reheart-tivat | [doctor-viller.com/servises](https://doctor-viller.com/servises) | 13 | — | 0 / 0 |
| 26 | svjetlost-eye-clinic-budva | [svjetlostbudva.me/cjenovnik](https://svjetlostbudva.me/cjenovnik/) | 69 | 2026-04-07 | 0 / 0 |
| 35 | nasa-medicina-podgorica | [nasa-medicina.me/usluge](https://nasa-medicina.me/usluge/) | 33 | 2026-06-15 | 6 / 0 |
| 39 | vase-zdravlje-podgorica | [vasezdravlje.me/cjenovnik](https://vasezdravlje.me/cjenovnik/) | 255 | 2026-04-22 | 88 / 147 |
| 45 | dukley-dental-clinic-budva | [dukleydentalclinic.com/me/cijene](https://www.dukleydentalclinic.com/me/cijene) | 68 | — | 65 / 0 |
| 54 | poliklinika-natal-podgorica | [poliklinikanatal.me/cjenovnik](https://poliklinikanatal.me/cjenovnik/) (+1) | 130 | 2026-04 | 86 / 26 |
| 62 | poliklinika-diagnostica-podgorica | [diagnostica.me/cjenovnik](https://diagnostica.me/cjenovnik) (+1) | 634 | — | 0 / 0 |
| 69 | ordinacija-balans-niksic | [drbalans.me/cjenovnik](https://drbalans.me/cjenovnik/) | 35 | 2025-12-01 | 0 / 0 |
| 73, 74, 75 | in-vitro-podgorica | [invitro.co.me/cjenovnik.php](https://www.invitro.co.me/cjenovnik.php) (+1) | 352 | — | 0 / 1062 |
| 76 | lab-medical-laboratorija-podgorica | [labmedical.me/cjenovnik](https://www.labmedical.me/cjenovnik/) (+1) | 156 | 2024-11-16 | 0 / 155 |
| 77 | gea-medical-ginekoloska-ordinacija | [geamedical.me/usluge-i-cijene](https://geamedical.me/usluge-i-cijene/) | 46 | 2026-07-14 | 45 / 0 |
| 78 | imc-international-medical-center-orl-ambulanta | [ambulanta.me/cjenovnik](https://www.ambulanta.me/cjenovnik) | 11 | — | 11 / 0 |
| 81 | spa-medica-podgorica | [spamedica.me/cjenovnik](https://spamedica.me/cjenovnik/) (+1) | 49 | 2026-01-26 | 49 / 0 |
| 86 | tesla-medical-berane | [teslamedical.me/cene](https://www.teslamedical.me/cene/) (+2) | 119 | 2020-01-13 | 77 / 0 |
| 95 | dr-filimanovic-stomatoloska-ordinacija-podgorica | [drfilimanovic.com/stomatoloskeordinacijepodgoricacjenovnik](https://www.drfilimanovic.com/stomatoloskeordinacijepodgoricacjenovnik/) | 87 | 2026-04-23 | 82 / 0 |
| 99 | kulusic-dental-clinic-niksic | [drkulusic.me/mne/cjenovnik](https://www.drkulusic.me/mne/cjenovnik/) (+2) | 36 | 2026-06-08 | 43 / 0 |
| 100 | dr-boskovic-ginekolosko-akuserska-ordinacija | [ordinacijaboskovic.me/cjenovnik.html](https://ordinacijaboskovic.me/cjenovnik.html) | 33 | 2025 | 30 / 3 |
| 101 | nova-medic-poliklinika | [novamedic.me/cjenovnik](https://novamedic.me/cjenovnik/) | 115 | 2026-09-30 | 162 / 0 |
| 102 | dr-raznatovic-stomatoloska-ordinacija | [drraznatovic.me/cjenovnik](https://drraznatovic.me/cjenovnik/) | 107 | 2015-09-25 | 104 / 0 |
| 109 | dr-prlja-medical | [prlja-medical.me/cjenovnik.htm](https://prlja-medical.me/cjenovnik.htm) | 82 | 03.03.2023 | 82 / 0 |
| 110 | bellavista-stomatoloska-ordinacija | [ordinacijabellavista.me/#employement](http://ordinacijabellavista.me/#employement) (+1) | 27 | 2018 | 27 / 0 |
| 111 | dr-kukoljac-stomatoloska-ordinacija | [drkukoljac.com/index.php/me/cjenovnik-zubar-stomatolog-hercg](https://drkukoljac.com/index.php/me/cjenovnik-zubar-stomatolog-hercg-novi-crna-gora) | 28 | — | 27 / 0 |
| 112 | ordinacija-medan | [drmedan.me/me/cijenovnik/cijenovnik](https://www.drmedan.me/me/cijenovnik/cijenovnik/) | 24 | — | 22 / 0 |
| 113 | doktorica-mica-pedijatrijski-centar | [doktoricamica.com/cjenovnik](https://doktoricamica.com/cjenovnik/) | 17 | 2026-04-27 | 17 / 0 |
| 115 | dr-jovovic-oftalmoloska-ordinacija | [oftalmologija.drjovovic.me/cjenovnik](https://oftalmologija.drjovovic.me/cjenovnik/) | 57 | 2025-09-29 | 56 / 0 |
| 126 | dom-zdravlja-kotor | [domzdravljakotor.me/izdavanje-uvjerenja-dom-zdravlja-kotor](https://domzdravljakotor.me/izdavanje-uvjerenja-dom-zdravlja-kotor/) (+1) | 19 | 2025-07-30 | 19 / 0 |
| 134 | dom-zdravlja-tivat | [dztivat.com/cijenovnik-usluga](https://dztivat.com/cijenovnik-usluga/) | 21 | 2022-11-08 | 21 / 0 |
| 140 | dom-zdravlja-podgorica | [dzpg.me/medicina-rada](https://www.dzpg.me/medicina-rada/) (+2) | 36 | 08.07.2021 | 0 / 0 |

### pricelist_file (11)

| id | Клиника | Прайс | Позиций | Дата | У нас (усл/анализы) |
|---|---|---|---|---|---|
| 25 | dnevna-bolnica-optimal-podgorica | [optimalmed.me/wp-content/uploads/2016/02/Cjenovnik.pdf](https://optimalmed.me/wp-content/uploads/2016/02/Cjenovnik.pdf) | 70 | 2016-02-19 | 67 / 0 |
| 27 | normedica-herceg-novi | [normedica.me/normedica_cjenovnik.pdf](https://www.normedica.me/normedica_cjenovnik.pdf) | 35 | 28.10.2024 | 33 / 3 |
| 28 | codra-hospital-podgorica | [codra.me/wp-content/uploads/2022/02/Cenovnik_Laboratorija-02](https://www.codra.me/wp-content/uploads/2022/02/Cenovnik_Laboratorija-02.jpg) | 95 | 2022-02-14 | 0 / 0 |
| 40 | primus-medical-podgorica | [primus-medical.me/wp-content/uploads/2023/03/Cjenovnik-vene-](https://primus-medical.me/wp-content/uploads/2023/03/Cjenovnik-vene-2023.pdf) (+2) | 10 | 01.09.2025 | 0 / 0 |
| 65 | klinicki-centar-crne-gore-podgorica | [kccg.me/wp-content/uploads/2026/08/Cjenovnik-2019.pdf](https://www.kccg.me/wp-content/uploads/2026/08/Cjenovnik-2019.pdf) (+2) | 2274 | 2019 + 01.08.2025 | 2199 / 658 |
| 80 | dom-zdravlja-herceg-novi | [domzdravljahn.me/wp-content/uploads/2019/03/CJENOVNIK.pdf](http://domzdravljahn.me/wp-content/uploads/2019/03/CJENOVNIK.pdf) | ? | 2019 | 365 / 109 |
| 85 | dom-zdravlja-dimitrije-dika-marenic-danilovgrad | [domzdravljadg.me/images/Cjenovnikusluga.pdf](http://www.domzdravljadg.me/images/Cjenovnikusluga.pdf) | 28 | 2019 | 61 / 0 |
| 87 | dom-zdravlja-bijelo-polje | [domzdravljabp.me/images/2018/CJENOVNIK_2026.pdf](https://www.domzdravljabp.me/images/2018/CJENOVNIK_2026.pdf) | 26 | 2026 | 26 / 0 |
| 127 | dom-zdravlja-bosko-dedeic-mojkovac | [dzmojkovac.me/wp-content/uploads/2019/03/02.10.2025.pdf](https://dzmojkovac.me/wp-content/uploads/2019/03/02.10.2025.pdf) (+3) | 310 | 02.10.2025 | 274 / 36 |
| 128 | dom-zdravlja-kolasin | [dzkolasin.me/wp-content/uploads/2019/02/Cjenovnik-licima-koj](https://dzkolasin.me/wp-content/uploads/2019/02/Cjenovnik-licima-koja-nisu-osiguranici.pdf) | 26 | 2020-10-07 | 26 / 0 |
| 131 | specijalna-bolnica-za-ortopediju-neurohirurgiju-i-neurologiju-vaso-cukovic-risan | [bolnicarisan.me/index.php?option=com_phocadownload&view=cate](https://www.bolnicarisan.me/index.php?option=com_phocadownload&view=category&download=191:cjenovnik-ambulanta&id=56:2023&Itemid=575) (+2) | ? | 2023-05-11 | 681 / 103 |

### prices_on_service_pages (1)

| id | Клиника | Прайс | Позиций | Дата | У нас (усл/анализы) |
|---|---|---|---|---|---|
| 15 | a3-medical-sutomore | [a3medical.org/me/specialty/gynecology](https://a3medical.org/me/specialty/gynecology/) (+4) | 41 | 2026-06-12 | 331 / 4 |

### partial_prices (9)

| id | Клиника | Прайс | Позиций | Дата | У нас (усл/анализы) |
|---|---|---|---|---|---|
| 10 | smartmed-podgorica | [poliklinikasmartmed.me/aktuelno/specijalne-ponude](https://www.poliklinikasmartmed.me/aktuelno/specijalne-ponude) (+2) | 5 | — | 0 / 0 |
| 29 | rezidencija-zdravlja-kerber-podgorica | [rzkerber.com/mart-je-novi-oktobar](https://rzkerber.com/mart-je-novi-oktobar/) | 8 | 2025-09-22 | 0 / 0 |
| 63 | dr-nenezic-podgorica | [drnenezic.me/cijene-usluga](https://drnenezic.me/cijene-usluga/) (+1) | 3 | 2023-08-22 | 0 / 0 |
| 64 | novi-standard-poliklinika | [novistandard.me/api/novistandard/posts](https://www.novistandard.me/api/novistandard/posts) | 15 | 2025-10-14 | 107 / 938 |
| 89 | medikid-podgorica | [medikid.me/me/service/baby-start](https://www.medikid.me/me/service/baby-start) | 4 | — | 0 / 0 |
| 108 | aesthetic-medical-centar-barovic-dr-aleksandra-barovic | [estetikadrbarovic.me/sites/default/files/popup/baner-dr-baro](https://estetikadrbarovic.me/sites/default/files/popup/baner-dr-barovic_1.webp) | 2 | 2026 | 0 / 0 |
| 114 | medtim-privatna-bolnica | [medtim.me/usluge/poliklinika/dermatologija-podgorica](https://medtim.me/usluge/poliklinika/dermatologija-podgorica/) (+1) | 1 | — | 0 / 0 |
| 116, 117 | ars-medica-specijalna-bolnica | [arsmedica.co.me/ginekologija](https://arsmedica.co.me/ginekologija/) | 1 | — | 0 / 0 |
| 125 | dr-veselinovic-stomatoloska-klinika | [drveselinovic.com/cenovnik-2](https://drveselinovic.com/cenovnik-2/) (+1) | 4 | 2023-09-29 | 0 / 0 |

### price_on_request (1)

| id | Клиника | Сайт | У нас (усл/анализы) |
|---|---|---|---|
| 107 | barovic-aesthetic-dental-centar | drbarovic.me | 0 / 0 |

### site_down (3)

| id | Клиника | Сайт | У нас (усл/анализы) |
|---|---|---|---|
| 23 | poliklinika-filipovic-podgorica | poliklinikafilipovic.me | 0 / 0 |
| 33 | vadis-stomatologija-podgorica | vadis.me | 0 / 0 |
| 60 | buntic-stomatoloska-ordinacija-bar | montenegrodentistry.me | 145 / 0 |

### no_prices (44)

| id | Клиника | Сайт | У нас (усл/анализы) |
|---|---|---|---|
| 5 | moj-lab-podgorica-1 | mojlab.me/poliklinika/podgorica | 0 / 0 |
| 7 | moj-lab-budva | mojlab.me/poliklinika/budva | 0 / 0 |
| 8 | moj-lab-ulcinj | mojlab.me/poliklinika/ulcinj | 0 / 0 |
| 9 | moj-lab-pedijatria-podgorica | mojlab.me/pedijatrijska-poliklinika/podgorica | 0 / 0 |
| 12 | smartmed-kotor | poliklinikasmartmed.me/usluge/poliklinika-smart-med-kotor | 0 / 0 |
| 16 | alpha-gr-ordinacija-za-bolesti-uha-grla-i-nosa-bar | orlalphagr.com | 0 / 0 |
| 18 | medical-vranes-bar | medicalvranes.me | 0 / 0 |
| 22 | orl-klinika-dr-barjaktarovic-herceg-novi | drbarjaktarovic.me | 0 / 0 |
| 31 | fizikalna-terapija-vertebra-podgorica | fizikalnavertebra.me | 0 / 0 |
| 36 | humana-reprodukcija-budva | humanreproduction.com | 0 / 0 |
| 38 | sumedica-podgorica | sumedica.me | 0 / 0 |
| 43 | dom-zdravlja-budva | dzbudva.me | 0 / 0 |
| 46 | apolonia-rasovic-stomatoloska-ordinacija-podgorica | apoloniarasovic.com | 0 / 0 |
| 48 | dr-zejnilovic-pzu-dnevna-bolnica | drzejnilovic.me | 8 / 352 |
| 49 | dom-zdravlja-bar | domzdravljabar.com | 0 / 0 |
| 56 | zecevic-dental-budva | dental-tourism.me | 0 / 0 |
| 57 | medical-centar-budva | medicalcentarbudva.com | 0 / 0 |
| 58 | poliklinika-dr-masonicic-bar | drmasonicic.com | 0 / 0 |
| 59 | novi-cenex-medical-podgorica | cenexmedical.com | 0 / 0 |
| 68 | konzilijum-poliklinika-i-bolnica-podgorica | konzilijum.me | 214 / 0 |
| 70, 71, 72 | hipokrat-poliklinika-podgorica | hipokrat.me | 0 / 0 |
| 82 | luca-medical-podgorica | lucamedical.me | 0 / 0 |
| 88 | bolnica-danilo-i-cetinje | daniloprvi.me | 2296 / 387 |
| 90 | a-medic-plasticna-i-estetska-hirurgija | amedic.me | 0 / 0 |
| 92 | opsta-bolnica-blazo-orlandic | bolnicabar.me | 0 / 0 |
| 93 | oftalmoloski-centar-dr-raonic-podgorica | oftalmoloskicentar.me | 0 / 0 |
| 94 | teo-med-pedijatrijska-ambulanta-podgorica | teomed.me | 0 / 0 |
| 103, 104, 105, 106 | endorfin-fizio-centar-podgorica | endorfin.me | 0 / 0 |
| 118 | mansa-medica-tivat | mansamedica.com | 0 / 0 |
| 119 | laserfocus-centar-za-mikrohirurgiju-oka | laserfocus.me | 0 / 0 |
| 120 | ortho-centar | orthocentar.com | 0 / 0 |
| 122 | dental-studio-vucetic | dentistmontenegro.com | 29 / 0 |
| 129 | dom-zdravlja-andrijevica | domzdravljaandrijevica.com | 0 / 0 |
| 130 | opsta-bolnica-bijelo-polje | bpbolnica.me | 0 / 0 |
| 133 | opsta-bolnica-kotor | kbckotor.me; jzuobkotor.me (только тарифник FZOCG 2015) | 0 / 0 |
| 135 | specijalna-bolnica-za-psihijatriju-dobrota-kotor | psihijatrijakotor.com | 0 / 0 |
| 137 | opsta-bolnica-berane | kbcberane.me | 0 / 0 |
| 138 | opsta-bolnica-pljevlja | bolnicapv.com | 0 / 0 |
| 139 | specijalna-bolnica-za-plucne-bolesti-dr-jovan-bulajic-brezovik | brezovik.me | 0 / 0 |
| 141 | opsta-bolnica-niksic | bolnica-nk.com | 2358 / 385 |
| 142 | stomatoloska-ordinacija-musura | musura.me | 0 / 0 |
| 143 | ipodo-centar-za-podologiju-budva | ipodo.pro | 0 / 0 |
| 144 | radio-medic | radiomedic.me | 1 / 0 |
