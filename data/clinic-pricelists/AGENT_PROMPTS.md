# Промпты для агентов: сбор прайсов по карте

Каждый блок — готовый промпт для отдельного окна Claude Code, запущенного в
`E:\pet\docta.me\nuxt`. Общие правила лежат в
`docs/import/PRICE_COLLECTION_AGENT.md`, промпты на них ссылаются.

Как применять результаты: агенты пишут SQL без номеров миграций и сами ничего
не применяют. Новые записи каталога у параллельных агентов могут совпасть по
смыслу, поэтому перед применением сверь их списки из отчётов между собой.
Применяй файлы по одному.

| # | Клиника | Режим | Объём | Сложность |
|---|---|---|---|---|
| 1 | Diagnostica (62) | новый | 634 | JSON API, много анализов |
| 2 | КЦЦГ (65) | новый | ~2500 | OCR сканов, коды FZOCG |
| 3 | Vaše zdravlje (39) | новый | ~245 | HTML |
| 4 | Natal (54) | синхронизация | 130 / 112 | HTML + wp-json |
| 5 | Tesla Medical (86) | синхр. + лаборатория | 119 / 77 + PDF лаборатории | HTML + PDF |
| 6 | Codra (28) | новый | ~95 анализов | OCR картинки |
| 7 | Svjetlost Budva (26) | новый | ~69 | HTML |
| 8 | Optimal (25) | цены к готовым услугам | ~70 | PDF со сдвигом кодировки |
| 9 | ДЗ Подгорица (140) | новый | ~39 | HTML + скан |
| 10 | Balans (69) | новый | ~35 | HTML |
| 11 | Naša medicina (35) | синхронизация | 33 / 19 | HTML |
| 12 | Primus Medical (40) | новый | ~19 | 3 PDF, один скан |
| 13 | DrViller (24) | новый | 13 | Tilda |
| 14 | ДЗ Мойковац (127) | дополнение | справки + санитарные осмотры | 2 скана |
| 15 | Moj Lab (5–9) | проверка сайта и адресов | — | — |
| 16 | Nova Medic (101) | синхронизация | ~115 / 162 | HTML |
| 17 | FZOCG ПЗЗ 2026 | сверка тарифника | 28 стр. | OCR, не клиника |

---

## 1. Diagnostica

```
Собери прайс клиники Poliklinika Diagnostica (slug `poliklinika-diagnostica-podgorica`, Подгорица) и подготовь SQL.
Сначала прочитай docs/import/PRICE_COLLECTION_AGENT.md — правила обязательны.

Режим: новый прайс. В БД у клиники 0 услуг и 0 анализов.
Источник: открытый JSON https://api.diagnostica.me/api/public/pricelist (HTML-страница https://diagnostica.me/cjenovnik — пустая SPA-оболочка).
В JSON два departments:
- lab — 14 групп, 469 позиций, у 467 есть цена; это анализы → clinic_lab_tests;
- clinic — 9 групп, 165 позиций; осмотры и диагностика → clinic_medical_services.
Поля позиции: code, name, price, note, group. Лабораторные коды 4-значные («0001») — пиши их в `code` строки клиники.
Даты в данных нет; на сайте сказано, что цены «orijentacioni karakter». Дата среза = дата запроса, ETag запиши в запись импорта.

Особенности:
- Объём большой. Анализы сопоставляй с каталогом lab_tests по названию и синонимам. Для сверки годятся лаборатории с большими прайсами: Milmedika, Novi Standard, Invitro.
- Пакеты и панели анализов — отдельные записи каталога, только если такие уже есть; иначе в «Спорные».
- Поле note может содержать условия (подготовка, сроки) — в цену не входит, но если там «od» или диапазон, учитывай.
- Это будущий источник автосверки: в записи импорта опиши структуру JSON, чтобы следующий прогон сравнивал машинно.
```

## 2. КЦЦГ

```
Собери прайс Kliničkog centra Crne Gore (slug `klinicki-centar-crne-gore-podgorica`) и подготовь SQL.
Сначала прочитай docs/import/PRICE_COLLECTION_AGENT.md и docs/import/PRICELIST_FROM_PDF.md.

Режим: новый прайс. В БД у клиники 0 услуг и 0 анализов.
Источники (сканы без текстового слоя, нужен OCR):
- https://www.kccg.me/wp-content/uploads/2026/08/Cjenovnik-2019.pdf — основной прайс для неосигуранных, 78 страниц, ~2500+ позиций, амбулатории + стационар (DRG);
- https://www.kccg.me/wp-content/uploads/2026/08/Cjenovnik-izmjene-i-dopune-2025.pdf — изменения по Odluka Odbora direktora от 01.08.2025 (согласие Минздрава 18.08.2025), 27 страниц.
Актуальная цена = прайс 2019 + изменения 2025, наложенные по коду.
Старая копия 2019 (uploads/2019/08/…_compressed.pdf) не нужна.

Особенности:
- Коды услуг вида Y01004 похожи на коды FZOCG. Сопоставляй по коду через medical_service_tariffs (учти, что код уникален только в паре с tariff_source — см. DATABASE_SCHEMA) и через строки больниц, у которых уже есть эти коды: Danilo (88), ОБ Никшич (141), Рисан (131).
- Проверь гипотезу кратности: у Danilo цена = 3 × price_ambulanta_eur, у 88/137 — 2.5 × price_odjeljenje_eur. Если у КЦЦГ своя стабильная кратность к тарифу FZOCG — это сильная проверка OCR, опиши её в отчёте.
- Цены с копейками («16,68»). Лабораторные разделы (K01/K02, L01, Z01) — анализы, не услуги.
- Работа большая: делай батчами (по разделам), промежуточные результаты храни в data/clinic-services-import/kccg/ (свой каталог, как у bolnica-danilo-cetinje). Можно параллелить OCR/разбор через субагентов, каждый батч в свой файл.
- Прайс 2019 года, но с изменениями 2025 — is_price_outdated НЕ ставь для позиций, затронутых изменениями 2025; для остальных реши по правилу «старше 2 лет» и вынеси решение в вопросы юзеру.
```

## 3. Vaše zdravlje

```
Собери прайс клиники Vaše zdravlje (slug `vase-zdravlje-podgorica`, Подгорица) и подготовь SQL.
Сначала прочитай docs/import/PRICE_COLLECTION_AGENT.md — правила обязательны.

Режим: новый прайс. В БД у клиники 0 услуг и 0 анализов.
Источник: https://vasezdravlje.me/cjenovnik/ (HTML), ~245 цен. Разделы: семейная медицина, терапия, медицина труда / справки, специалисты, УЗИ / радиология, большой лабораторный раздел (гормоны, онкомаркеры, моча).
Даты нет: wp-json и sitemap отдают 403, в футере «Copyright © 2020», но список выглядит поддерживаемым.

Особенности:
- Формат «– 20€». Встречаются двойные цены без пояснения («produženje vozačke … – 25 € 20€») — такие в «Спорные», не угадывай.
- Лабораторный раздел → clinic_lab_tests, остальное → clinic_medical_services.
```

## 4. Natal

```
Синхронизируй цены клиники Poliklinika Natal (slug `poliklinika-natal-podgorica`, Подгорица) с сайтом и подготовь SQL.
Сначала прочитай docs/import/PRICE_COLLECTION_AGENT.md — правила обязательны.

Режим: синхронизация. В БД 86 услуг и 26 анализов, все с ценами. На сайте 130 позиций.
Источники:
- https://poliklinikanatal.me/cjenovnik/ — HTML с ценами (страница не в меню);
- https://poliklinikanatal.me/wp-json/wp/v2/cjenovnik?per_page=100 (2 страницы, X-WP-Total=130) — названия, категория, modified каждой позиции, БЕЗ цен (цены в мета-полях JetEngine, бери из HTML).
Позиции правились с 2025-12-01 по 2026-04-21.

Особенности:
- Разделы: ginekologija (27), PCR-brisevi (26), pedijatrija (18), interna (13), radiologija (13), dermatologija, hirurgija, ORL (по 7), ostalo (5), neurologija (4), nuklearna (3).
- PCR-мазки — это анализы (clinic_lab_tests), проверь, где они у нас сейчас.
- Формат «40,00 €».
- Сдай сравнение data/clinic-imports/poliklinika-natal-podgorica-prices-2026-10.md в формате Milmedika.
```

## 5. Tesla Medical

```
Синхронизируй цены клиники Tesla Medical (slug `tesla-medical-berane`, Беране) с сайтом и подготовь SQL.
Сначала прочитай docs/import/PRICE_COLLECTION_AGENT.md — правила обязательны.

Режим: синхронизация услуг + новый прайс лаборатории. В БД 77 услуг с ценами, анализов 0.
Источники:
- https://www.teslamedical.me/cene/ — ~119 услуг (кардиология, гастро, неврология, терапия, физикальная, УЗИ, рентген, ГБО); wp modified 2020-01-13;
- https://www.teslamedical.me/wp-content/uploads/2019/11/cenovnik-biohemija-radna-verzija.pdf — биохимия, гормоны, аллергия, ~890 строк (оценка сверху: повторяются заголовки);
- https://www.teslamedical.me/wp-content/uploads/2019/11/cenovnik-mikrobiologija.pdf — микробиология, ~121 строка.
Laboratorija-Usluge.pdf — сроки выдачи, не цены.

Особенности:
- Цены без € в формате «30.00».
- Прайс 2020, лаборатория 2019 → is_price_outdated = 1 на всё, что заводишь или меняешь.
- Лабораторные PDF помечены «radna verzija» (черновик). Анализы вынеси в ОТДЕЛЬНЫЙ файл server/sql/insert-clinic-prices-tesla-medical-berane-lab.sql — юзер решит, применять ли черновик.
- Сдай сравнение data/clinic-imports/tesla-medical-berane-prices-2026-10.md.
```

## 6. Codra

```
Собери прайс лаборатории Codra Hospital (slug `codra-hospital-podgorica`, Подгорица) и подготовь SQL.
Сначала прочитай docs/import/PRICE_COLLECTION_AGENT.md — правила обязательны.

Режим: новый прайс. В БД у клиники 0 услуг и 0 анализов.
Источник: одна картинка https://www.codra.me/wp-content/uploads/2022/02/Cenovnik_Laboratorija-02.jpg — ~95 анализов (гематология, биохимия, гормоны, онкомаркеры, вирусы, COVID). wp media date 2022-02-14.

Особенности:
- Распознай картинку (прочитай её Read-ом как изображение, при сомнениях — увеличь фрагменты); каждую строку сверяй глазами.
- Прайс 2022 → is_price_outdated = 1.
- COVID-позиции заводи, только если в каталоге уже есть соответствующие записи; иначе в excluded с причиной.
- Других цен у больницы на сайте нет (хирургия, IVF, PET CT без цен) — не ищи.
```

## 7. Svjetlost Budva

```
Собери прайс клиники Svjetlost Eye Clinic (slug `svjetlost-eye-clinic-budva`, Будва) и подготовь SQL.
Сначала прочитай docs/import/PRICE_COLLECTION_AGENT.md — правила обязательны.

Режим: новый прайс. В БД у клиники 0 услуг.
Источник: https://svjetlostbudva.me/cjenovnik/ (HTML), ~69 позиций, wp-json modified 2026-04-07.
Разделы: осмотры, диагностика, пластика век, глаукома, катаракта, витрэктомия, анти-VEGF, лазерная коррекция, ICL, CXL.

Особенности:
- Формат «80,00 €», тысячи через точку («1.400,00 €»). Один диапазон: Pterygium 300,00–500,00 €.
- «за глаз» / «za oba oka» — разные позиции, если в каталоге они различаются; проверь, как заведено у офтальмологий 115 (dr Jovović) и 93 (Raonić).
```

## 8. Optimal

```
Проставь цены услугам клиники Dnevna bolnica Optimal (slug `dnevna-bolnica-optimal-podgorica`, Подгорица) и подготовь SQL.
Сначала прочитай docs/import/PRICE_COLLECTION_AGENT.md — правила обязательны.

Режим: цены к уже заведённым услугам. В БД 69 услуг, все без цены.
Источник: https://optimalmed.me/wp-content/uploads/2016/02/Cjenovnik.pdf — ~70 позиций офтальмологии (диагностика, лазеры, LASIK/PRK, катаракта…). PDF от 2016-02-19.

Особенности:
- Текст PDF извлекается со сдвигом кодировки шрифта (Caesar +29) — декодируй обратным сдвигом и проверь на нескольких строках.
- Цены 2016 года → is_price_outdated = 1 на все строки.
- Сайт заброшен (шаблон 2016). Позиции из PDF, которых нет среди наших 69, — в отчёт, новых записей не заводи без явной пользы; наши услуги без пары в PDF оставь без цены.
```

## 9. ДЗ Подгорица

```
Собери собственные цены самооплаты Dom zdravlja Glavnog grada (slug `dom-zdravlja-podgorica`) и подготовь SQL.
Сначала прочитай docs/import/PRICE_COLLECTION_AGENT.md — правила обязательны.

Режим: новый прайс. В БД у клиники 0 услуг.
Источники:
- https://www.dzpg.me/medicina-rada/ — «CJENOVNIK usluga i pregleda iz oblasti Medicine rada», ~36 цен: ljekarska uvjerenja (трудоспособность, работа на высоте, водители A/B и C/D/E, оружие, моряки, гражданство/ВНЖ и др.) и sistematski pregled для женщин и мужчин. Прайс принят 08.07.2021, страница изменена 2026-04-30;
- https://www.dzpg.me/wp-content/uploads/2025/09/cjenovnik.pdf — спортивная медицина, 3 цены (скан): спортсмены до 18 лет 10 €, старше 15 €, судьи и тренеры 30 €. Odluka от 15.01.2025.
НЕ бери Cijenovnik-PZZ-2026-1.pdf из /dokumenti/ — это тарифник FZOCG, не их прайс (для него отдельный агент).

Особенности:
- Формат «20,00 eur-a». Примечание «zadržava pravo da odobri popust do 30%» — в notes записи импорта.
- Справки сопоставляй с теми, что уже заведены у других домов здоровья (Тиват 134, Котор 126, Бело-Поле 87, Мойковац 127) и у Naša medicina (35), — не плоди дублей.
- Прайс medicina rada 2021 → по правилу «старше 2 лет» is_price_outdated = 1; но страница правилась в 2026 — вынеси это противоречие в вопросы юзеру и поставь флаг по его умолчанию (ставить).
```

## 10. Balans

```
Собери прайс клиники Ordinacija Balans (slug `ordinacija-balans-niksic`, Никшич) и подготовь SQL.
Сначала прочитай docs/import/PRICE_COLLECTION_AGENT.md — правила обязательны.

Режим: новый прайс. В БД у клиники 0 услуг.
Источник: https://drbalans.me/cjenovnik/ (HTML), ~35 цен, wp modified 2025-12-01.
Разделы: специалистические осмотры, интерна, УЗИ, физикальная терапия, нутрициология.

Особенности:
- Формат «40,00 €».
- Примечание: в нерабочие дни и вне рабочего времени +10,00 € — в notes записи импорта, отдельными позициями не заводи.
```

## 11. Naša medicina

```
Синхронизируй цены клиники Naša medicina (slug `nasa-medicina-podgorica`, Подгорица) с сайтом и подготовь SQL.
Сначала прочитай docs/import/PRICE_COLLECTION_AGENT.md — правила обязательны.

Режим: синхронизация. В БД 19 услуг, цены только у 6. На сайте ~33 цены.
Источник: https://nasa-medicina.me/usluge/ — одна страница-прайс: медицинские справки (работа, вождение, оружие, моряки, спорт…), психиатр, психолог. page-sitemap lastmod 2026-06-15.

Особенности:
- Формат «– 20 €».
- Справки спортсменам по возрасту: до 14 лет 15 €, до 18 — 20 €, до 25 — 25 €, судьи 40 €. Посмотри, как такие градации заведены в каталоге (у ДЗ Подгорица похожие, но там отдельный агент — сверяйся только с БД, не с его файлами).
- Оговорка «zadržava pravo da odobri popust» — в notes.
- Сдай сравнение data/clinic-imports/nasa-medicina-podgorica-prices-2026-10.md.
```

## 12. Primus Medical

```
Собери прайс клиники Primus Medical (slug `primus-medical-podgorica`, Подгорица) и подготовь SQL.
Сначала прочитай docs/import/PRICE_COLLECTION_AGENT.md — правила обязательны.

Режим: новый прайс. В БД у клиники 0 услуг.
Источники — три PDF по отделениям, ~19 цен:
- https://primus-medical.me/wp-content/uploads/2023/03/Cjenovnik-vene-2023.pdf — флебология (допплер, EVLA, склеротерапия, осмотры). Имя файла 2023, но внутри «Podgorica 01.09.2025», Last-Modified 2026-04-17 — файл обновлён на месте, он актуальный;
- https://primus-medical.me/wp-content/uploads/2023/01/cjenovnik-urologija.pdf — урология, 7 позиций, СКАН без текста (распознай), Last-Modified 2023-01-11;
- https://primus-medical.me/wp-content/uploads/2022/01/cjenovnik-nefrologija.pdf — нефрология, 2 позиции, 2022-01-27.

Особенности:
- В медиатеке есть устаревшие файлы без ссылок (2022/01/cjenovnik-primus.pdf, 2022/02/cjenovnik-vene.pdf, 2023/10/Vene-cijene.png) — НЕ бери их.
- Урология 2023 и нефрология 2022 → is_price_outdated = 1; вены — без флага.
- Кнопка «Cjenovnik» на /opsta-medicina/ и /radiologija/ ведёт на PDF урологии по ошибке — у этих отделений своих цен нет.
```

## 13. DrViller

```
Собери прайс амбулатории DrViller Reheart (slug `drviller-reheart-tivat`, Тиват) и подготовь SQL.
Сначала прочитай docs/import/PRICE_COLLECTION_AGENT.md — правила обязательны.

Режим: новый прайс. В БД у клиники 0 услуг.
Источник: https://doctor-viller.com/servises — сайт на Tilda, по-русски, 13 позиций (приёмы, ЭКГ, капельницы, озонотерапия, инъекции). Даты нет.

Особенности:
- Цены в таблице Tilda t431: данные лежат в сыром HTML в div.t431__data-part2 («Услуга;Стоимость, EUR»).
- «от 70» → price_min. Пример: приём профессора от 70 €, приём врача 60 €, ЭКГ с расшифровкой 20 €.
- Названия русские — сопоставляй по смыслу с каталогом, name_ru в каталоге поможет. «Приём профессора» и «приём врача» — проверь, есть ли в каталоге различие по статусу врача; если нет, в «Спорные».
```

## 14. ДЗ Мойковац

```
Дополни прайс Dom zdravlja "Boško Dedeić" Mojkovac (slug `dom-zdravlja-bosko-dedeic-mojkovac`) справками и санитарными осмотрами и подготовь SQL.
Сначала прочитай docs/import/PRICE_COLLECTION_AGENT.md — правила обязательны.

Режим: дополнение. Основной прайс (274 услуги + 36 анализов из PDF 02.10.2025) уже в БД — его НЕ трогай.
Источники (сканы без текстового слоя):
- https://dzmojkovac.me/wp-content/uploads/2019/03/cjenovnik_ljekarskih_uvjerenja.pdf — медицинские справки, 2 стр.;
- https://dzmojkovac.me/wp-content/uploads/2019/03/Cjenovnik_za_sanitarne_preglede.pdf — санитарные осмотры, 1 стр.
Файлы из 2019/03, на сайт перенесены 2022-04-28. Страница прайсов: https://dzmojkovac.me/?p=147 (ссылки там ведут на мёртвый mojkovac.mojmail.me — бери копии на dzmojkovac.me).

Особенности:
- Сначала проверь, нет ли этих позиций уже среди 274 услуг (в основном PDF могли быть и справки).
- Справки и санитарные осмотры сопоставляй с уже заведёнными у других ДЗ (Тиват 134, Котор 126, Бело-Поле 87).
- Прайсы 2019 → is_price_outdated = 1.
- Обнови существующую запись data/clinic-imports/ (если её нет — заведи) и раздел sources.
- wp-json у сайта работает только через ?rest_route=.
```

## 15. Moj Lab — проверка

```
Проверь сеть Moj Lab на сайте и подготовь SQL с правками каталога клиник. Цены не собираем — их на сайте нет; задача — адреса, филиалы и подтверждение, что цен нет.
Прочитай docs/rules/SQL_COLLATIONS.md до первой строки SQL. SQL не применяй, команды — по skill `migration-commands`. Клиники только по slug (id локально и на проде расходятся).

Что известно (проверка 2026-10-02):
- Сайт переехал на Webflow, все URL из нашей БД отдают 404:
  - 5 `moj-lab-podgorica-1` → https://mojlab.me/lokacije/poliklinika-podgorica
  - 7 `moj-lab-budva` → https://mojlab.me/lokacije/poliklinika-budva
  - 8 `moj-lab-ulcinj` → https://mojlab.me/lokacije/poliklinika-ulcinj
  - 9 `moj-lab-pedijatria-podgorica` → https://mojlab.me/lokacije/pedijatrija-podgorica
- У 6 `moj-lab-podgorica-2` сайта в БД нет. На новом сайте есть локация https://mojlab.me/lokacije/poliklinika-donja-gorica — проверь, не она ли это.
- Цены только в редких новостях-акциях в процентах; PDF на сайте — политика ИМС и подготовка к анализам.

Сделай:
1. curl'ом пройди все /lokacije/* (список возьми из sitemap/меню нового сайта). Для каждой: название, адрес, телефон, часы работы, какие услуги/отделения перечислены.
2. Сопоставь с нашими 5 клиниками (name_sr, address_sr, phone, website, часы в clinic_working_hours). Найди: какая наша клиника = какая локация; локации, которых у нас нет; наши клиники, которых на сайте больше нет.
3. Ещё раз убедись, что цен нет нигде: страницы услуг, онлайн-запись/корзина анализов, JSON в бандлах Webflow, PDF. Если найдёшь — опиши источник, но не импортируй.
4. SQL server/sql/update-clinics-moj-lab-2026-10.sql: UPDATE website (и адресов/телефонов, только где расхождение подтверждено сайтом), по slug, с условием на старое значение. Новые локации и закрытые клиники — НЕ в SQL, а в отчёт с вопросом юзеру.
Не трогай data/clinic-pricelists/map.json и код. Не коммить.

В финальном ответе: таблица «наша клиника ↔ локация», что меняет SQL, вопросы юзеру, команды применения.
```

## 16. Nova Medic

```
Синхронизируй цены клиники Nova Medic Poliklinika (slug `nova-medic-poliklinika`, Подгорица) с сайтом и подготовь SQL.
Сначала прочитай docs/import/PRICE_COLLECTION_AGENT.md — правила обязательны. Образец синхронизации — Milmedika (data/clinic-imports/milmedika-prices-2026-10.md, миграции 045/048).

Режим: синхронизация. В БД 162 услуги, все с ценой. На сайте ~115 цен.
Источник: https://novamedic.me/cjenovnik/ — wp-json modified 2026-09-30 (обновлён только что). Дерматовенерология, эстетическая медицина, лазеры, процедуры для тела.

Главный вопрос: почему у нас на ~47 позиций больше. Варианты:
- позиции сняты с прайса → is_obsolete = 1;
- позиции взяты со страниц отдельных услуг, а не с /cjenovnik/ (например, Lola tretman, BTL Exilis — страницы правились 2026-07-30) → проверь страницы услуг из sitemap и wp-json (/wp-json/wp/v2/pages?per_page=100&_fields=link,title,modified), цена со страницы услуги — тоже источник;
- у нас одна позиция сайта разбита на несколько (зоны, количество процедур, пакеты) → не obsolete, сопоставь.
Не ставь is_obsolete, пока не проверил страницы услуг.

Особенности:
- Формат «€50» (символ перед числом).
- Сначала сверь, совпадает ли локальная БД с продом (POST /api/services/list по prod id клиники) — сравнивай с продом.
- Сдай сравнение data/clinic-imports/nova-medic-poliklinika-prices-2026-10.md: меняется цена / спорные / у нас есть, на сайте нет (с пометкой, проверены ли страницы услуг) / на сайте есть, у нас нет.
```

## 17. FZOCG ПЗЗ 2026 — сверка тарифника (по желанию)

```
Сверь тарифник FZOCG по первичной помощи 2026 года с нашей таблицей medical_service_tariffs (tariff_source = 'fzocg-pzz').
Прочитай docs/DATABASE_SCHEMA.md (раздел medical_service_tariffs), data/fzocg/README.md, docs/import/PRICELIST_FROM_PDF.md, docs/rules/SQL_COLLATIONS.md.

Источник: https://www.dzpg.me/wp-content/uploads/2026/04/Cijenovnik-PZZ-2026-1.pdf — скан «Cjenovnik usluga primarne zdravstvene zaštite», 28 стр., на титуле «Podgorica, 2026. godine», PDF создан 2026-04-17. Выложен на сайте ДЗ Подгорица в /dokumenti/.

Сделай:
1. Выясни, какой версии наш fzocg-pzz (source_pdf, source_signed_number, notes, data/fzocg/) и новее ли этот PDF.
2. Если новее — OCR (PaddleOCR → LLM по PRICELIST_FROM_PDF.md), сравни по коду: изменившиеся цены, новые коды, исчезнувшие коды. Помни, что коды ПЗЗ пересекаются с кодами вторичной помощи — сравнивай строго внутри fzocg-pzz.
3. Отчёт data/fzocg/pzz-2026-diff.md. SQL обновления — server/sql/update-tariff-fzocg-pzz-2026.sql, без номера миграции, не применять, команды по skill `migration-commands`.
4. Отдельно отметь: цены клиник, привязанные к PZZ-кодам (домы здоровья — коды HN_, MO_, _KO, DZ 80/85), которые совпадали со старым тарифом и, значит, могли устареть.
Не трогай data/clinic-pricelists/map.json и код. Не коммить.
```
