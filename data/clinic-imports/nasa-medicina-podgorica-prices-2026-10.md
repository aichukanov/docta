# Naša medicina: обновление цен с сайта (2026-10-02)

Источник — nasa-medicina.me/usluge/ (одна страница-прайс), снят 2026-10-02,
снимок `data/clinic-pricelists/sources/nasa-medicina-podgorica/2026-10-02.html`.
Дата прайса — lastmod /usluge/ в `wp-sitemap-posts-page-1.xml`: 2026-06-15.
Сверено с продом (clinic id 35, `/api/services/list`): прод = локальная, 19 строк, цены у 6.
SQL — `server/sql/insert-clinic-prices-nasa-medicina-podgorica.sql`.

На сайте 30 позиций, 33 цены: у строки «za sportiste» их четыре.

| | Строк | |
|---|---|---|
| Меняется цена | 3 | раздел 1 |
| Совпадает | 3 | не трогаем |
| Цена появилась (было NULL) | 13 | раздел 1 |
| Спорные | 0 | раздел 2 — решено 2026-10-02 |
| У нас есть, на сайте нет | 0 | раздел 3 |
| На сайте есть, у нас нет | 12 | раздел 4 — в этом же SQL (7 новых записей каталога) |

Оговорка под прайсом: «PZU Naša Medicina zadrzava pravo da odobri popust kao i gratis ljekarsko» —
клиника может дать скидку или выдать справку бесплатно. Цены — без учёта этого.

## 1. Меняется цена

| # | Запись каталога | Название на сайте | Было | Стало |
|---|---|---|---|---|
| 1 | `medical-certificate-for-high-risk-and-difficult-working-conditions` | sposobnosti za rad na radnim mjestima sa povećanim rizikom i otežanim uslovima rada – prethodni/periodični/vanredni/sistematski | 40 | **45** |
| 2 | `medical-certificate-for-difficult-working-conditions-without-high-risk` | sposobnosti za rad na radnim mjestima bez povećanih rizika i otežanim uslovima rada – prethodni/periodični/vanredni | 35 | **45** |
| 3 | `medical-certificate-for-professional-drivers` | za upravljanje vozilom, C,D i E kategorije, specijalnim vozilima i taxi | 40 | **45** |
| 4 | `medical-certificate-for-driving-instructor-category-b-c-d-e` | za posao instruktora B,C,D i E kategorije | — | **45** |
| 5 | `medical-certificate-for-boat-operation-up-to-12-meters` | za upravljanje čamcom do 12 metara | — | **45** |
| 6 | `medical-certificate-for-firearms-possession` | za posjedovanje vatrenog oružja | — | **45** |
| 7 | `medical-certificate-for-military-service` | za obavljanje službe u Vojsci Crne Gore | — | **45** |
| 8 | `medical-certificate-for-underage-marriage` | za sklapanje braka za maloljetne osobe | — | **25** |
| 9 | `medical-certificate-for-child-adoption` | za podobnost za usvajanje djeteta | — | **25** |
| 10 | `medical-certificate-for-court-expert` | za posao sudskog vještaka | — | **25** |
| 11 | `medical-certificate-for-study-abroad-and-visa` | za dalji nastavak školovanja i boravak u inostranstvu/viza | — | **25** |
| 12 | `medical-certificate-for-life-insurance` | za životno osiguranje | — | **45** |
| 13 | `medical-certificate-for-collective-accommodation` | za kolektivni smještaj | — | **10** |
| 14 | `medical-certificate-for-athletes` | za sportiste (do 14 god.-15€, do 18 god.-20 €, do 25 god. – 25 €) | — | **15–25** |
| 15 | `medical-certificate-for-residence-and-work-in-montenegro` | za boravak i rad u Crnoj Gori | — | **25** |
| 16 | `medical-certificate-for-maritime-workers` | za rad u vodenom saobraćaju (pomorci) | — | **120** |

Совпадают (не трогаем): `medical-certificate-for-general-work` 20,
`medical-certificate-for-driving-license-category-a-b-c-d-e` 20,
`medical-certificate-for-driving-license-renewal-category-a-b-c-d-e` 25.

**Спортсмены.** В каталоге справки по возрасту не делятся: у всех пяти клиник
с `medical-certificate-for-athletes` одна запись и одна цена. Поэтому три
возрастные цены — диапазоном `price` 15 / `price_max` 25. Судьи (40 €) — на
отдельную запись `medical-certificate-for-sports-referees` (раздел 4).

**Строка 2.** «bez povećanih rizika i otežanim uslovima rada» — формулировка
кривая: читается и как «без повышенного риска, но в тяжёлых условиях», и как
«без риска и без тяжёлых условий». Строка уже стояла на
`…-without-high-risk`, сопоставление оставлено. Альтернатива —
`medical-certificate-for-low-risk-work`. Цена у обеих позиций сайта одинаковая
(45 €), поэтому на результат это не влияет.

## 2. Спорные

Была одна, решена 2026-10-02: «za smještaj u ustanove socijalne zaštite» (25 €) —
новая запись `medical-certificate-for-social-care-institution-accommodation`. Запись
дома престарелых (`medical-certificate-for-elderly-home-accommodation`) не подошла:
учреждения соцзащиты шире.

**Строка 2 раздела 1** остаётся на `…-without-high-risk`, тоже по решению от 2026-10-02.

## 3. У нас есть, на сайте нет

Нет. Все 19 строк БД есть на сайте, `is_obsolete` не ставится.

## 4. На сайте есть, у нас нет

| # | Запись каталога | Название на сайте | Цена | |
|---|---|---|---|---|
| 1 | `medical-certificate-for-sports-referees` | za sportiste (… sportske sudije- 40 €) | 40 | |
| 2 | `medical-certificate-copy` | prepis ljekarskog uvjerenja | 5 | **новая** |
| 2a | `medical-certificate-for-social-care-institution-accommodation` | za smještaj u ustanove socijalne zaštite | 25 | **новая** |
| 3 | `first-psychiatrist-examination` | Prvi pregled specijaliste psihijatra | 40 | |
| 4 | `follow-up-psychiatrist-examination` | Kontrolni pregled specijaliste psihijatra | 35 | |
| 5 | `first-psychological-examination` | Psihološki pregled | 40 | |
| 6 | `psychological-counseling` | Psihološko savjetovanje (individualno/partnersko/porodično) | 40 | **новая** |
| 7 | `neuropsychological-examination-with-cognitive-assessment-for-adults` | Psihološko testiranje 1 (baterija testova – kognitivno funkcionisanje komb. 4/6 testova za svrhe psihijatra/neurologa; za odrasle) | 150 | |
| 8 | `psychological-mental-status-assessment` | Psihološko testiranje 2 (baterija testova – procjena mentalnog stanja/psihičkog statusa komb. 3/6 testa za svrhe psihijtra/psihologa; za djecu i odrasle) | 130 | **новая** |
| 9 | `iq-test` | Psihološko testiranje 3 (procjena inteligencije 1 test različite svrhe; za djecu i odrasle) | 100 | **новая** |
| 10 | `cognitive-function-assessment-for-school-or-work` | Psihološko testiranje 4 (procjena kognitivnih funkcija u svrhu školovanja, rada i td komb. 2/3 testa; za djecu i odrasle) | 100 | **новая** |
| 11 | `psychological-testing-for-suspected-dementia` | Psihološko testiranje 5 (sumnja na demenciju – komb.4 testa bez testa inteligencije) | 60 | **новая** |

Почему сопоставлено именно так:

- **5.** «Psihološki pregled» без деления на первичный и контрольный. В каталоге
  общей записи нет, есть только пара Konzilijum: первичный 70 / контроль 40.
  Единственный приём — это первичный.
- **6.** Общей записи «психологическое консультирование» в каталоге нет: есть
  только консультирование беременных и консультирование при бесплодии (GEA).
  `individual-supportive-psychotherapy-and-counseling` — это психотерапия
  психиатра по FZOCG, а `family-counseling` — совет родителям.
- **7.** Описание совпадает с FZOCG-записью: батарея когнитивных тестов для
  психиатра или невролога, для взрослых.
- **8–11.** Четыре разных батареи тестов, у каждой своя цена. Под одну
  `psychological-testing` их не свести, потому что у клиники на одну запись
  каталога одна строка. `psychological-testing-single-test` и
  `complete-psychological-testing` (Konzilijum) по объёму не совпадают ни с одной
  из них. Детские тесты интеллекта (Goodenough, Binet-Simon и др.) — только для
  детей с особыми потребностями, по FZOCG.

Новые психологические записи — без категории, со специальностью PSYCHOLOGY (22).
Так же заведены `first-psychological-examination` и FZOCG-записи психолога.
`medical-certificate-copy` и `…-social-care-institution-accommodation` — категория General Medicine (9), специальность 45,
как у остальных справок.

Попутно в том же SQL: `clinics.google_place_id` = `ChIJn8uW797rTRMRrS2RaFjJif0` из
`data/google-places/podgorica/nasa-medicina.json` (телефон, сайт и 58 отзывов совпадают с клиникой).
