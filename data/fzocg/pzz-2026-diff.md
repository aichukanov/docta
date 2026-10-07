# FZOCG PZZ 2026: сверка с `medical_service_tariffs` (2026-10-02)

## Итог

1. **Новой редакции нет.** PDF с сайта ДЗ Подгорица (`dzpg.me/wp-content/uploads/2026/04/Cijenovnik-PZZ-2026-1.pdf`) побайтно совпадает с тем, из которого залит `fzocg-pzz`: тот же размер (1 183 444 байта) и тот же SHA-256 `4f006d7a4fb292d23c26546174b5107fa00f73bf5bf0250967fea7077b742808`. Метаданные: RICOH IM 3000, создан 2026-04-17. Это FZOCG-овский «Cjenovnik … PZZ od 01.05.2026», который ДЗ просто выложил у себя. Новых, исчезнувших или переоценённых кодов нет.
2. **Зато нашлись ошибки нашего собственного импорта этого PDF**: 20 неверных цен и 5 неверных названий. Исправления — в `server/sql/update-tariff-fzocg-pzz-2026.sql`, те же правки внесены в `primarna-zdravstvena-zastita-FINAL.json` (`_sources.* = "pdf-fix-2026-10"`), чтобы полная пересборка их не откатила.
3. **Цены клиник**: ни одна цена дома здоровья не равна тарифу один к одному: ДЗ публикуют цены для самоплательщиков с наценкой. Устаревшие цены видны только у Мойковца: его прайс — это ровно 3 × тариф **прошлой** редакции, а действующая на 2–11% выше.

## 1. Версия у нас

| поле | значение |
|---|---|
| `source_pdf` | `Cjenovnik-zdravstvenih-usluga-na-primarnom-nivou-zdravstvene-zastite-PZZ-od-01.05.2026.pdf` (все 493 строки) |
| `effective_from` | `2026-05-01` |
| `amended_from`, `source_signed_number` | NULL |
| `notes` | только у `X01022-JZP` (суффикс дубля кода) |
| исходник | `e:/pet/docta.me/прейскуранты/fzocg/primarna zdravsvena zastita/`, FINAL собран 2026-05-15 |

## 2. Что не так в нашем импорте

Сверка: цена в FINAL против LLM-источника `_intermediate/pzz-2026-05-01.json`, а все расхождения и все 92 строки «только LLM» (без перекрёстной проверки PaddleOCR) — по самим страницам PDF.

### Цены: блок H01, психиатр (стр. 13), 19 строк

В скане цена напечатана чуть выше линии своей строки. PaddleOCR отнёс каждую цену к коду выше, а `merge_to_final.py` взял цену OCR (`_sources.price = paddle-single`), хотя LLM прочитал её верно. Имена в БД правильные: README говорил «в H01 сдвинут OCR, а БД права», но это верно только для имён. H01006, H01009, H01021 и H01023 совпали случайно (у соседей та же цена).

| код | услуга | в БД | по PDF |
|---|---|---:|---:|
| H01001 | Prvi pregled (specijalistički) | 18,77 | 28,15 |
| H01002 | Ponovni pregled (kontrolni) | 9,38 | 18,77 |
| H01003 | Kratka posjeta bez ponovnog pregleda | 18,77 | 9,38 |
| H01004 | Površna individualna terapija | 28,15 | 18,77 |
| H01005 | Dubinska individualna terapija | 75,07 | 28,15 |
| H01007 | Grupna psihoterapija, zavisnosti | 56,30 | 75,07 |
| H01008 | Porodična psihoterapija | 37,54 | 56,30 |
| H01010 | Psihoterapija ponašanja | 31,28 | 37,54 |
| H01011 | Tehnika relaksacije | 9,38 | 31,28 |
| H01012 | Kraći psihodijagnostički intervju | 56,30 | 9,38 |
| H01013 | Procjena psihomotornog razvoja djeteta | 28,15 | 56,30 |
| H01014 | Kratki klinički test, djeca do 15 | 18,77 | 28,15 |
| H01015 | Kratki klinički test, odrasli | 50,05 | 18,77 |
| H01016 | Procjena strukture ličnosti, djeca | 31,28 | 50,05 |
| H01017 | Procjena strukture ličnosti, odrasli | 15,64 | 31,28 |
| H01018 | Kliničko ispitivanje funkcija, djeca | 8,83 | 15,64 |
| H01019 | Kliničko ispitivanje funkcija, odrasli | 75,07 | 8,83 |
| H01020 | Obrada rezultata, pisanje nalaza | 9,38 | 75,07 |
| H01022 | Savjet roditeljima | 18,77 | 9,38 |

Независимое подтверждение по ценам клиник на тех же кодах: у ДЗ Херцег-Нови (80) цена ≈ 1,78 × исправленный тариф в 21 из 23 строк, у ДЗ Мойковац (127) база = 0,965 × исправленный тариф в 22 из 23. С текущими ценами БД не сходится ни одна из двух клиник.

На странице услуги показывались 18 из 19 (H01005 ни к чему не привязан): `first-psychiatrist-examination`, `brief-psychodiagnostic-interview`, `relaxation-technique` и т.д.

### Цена: D17003 (стр. 11), строка только от LLM

| код | в БД | по PDF |
|---|---:|---:|
| D17003 Laboratorijska izrada mobilnog ortodontskog aparata bez konstrukcijskog zagriza do 4 elementa | 38,15 | 32,50 |

LLM подставил цену соседа D17004. Каталожной привязки нет.

### Названия: 5 строк только от LLM

| код | в БД | по PDF |
|---|---|---|
| K01051 | Mikroskopski pregled stolice na helminte (ljepljivim celofanom) | Mikroskopski pregled perianalnog otiska (ljepljivim celofanom) |
| D18001 | Laboratorijska izrada livene metalne krunice | Laboratorijska izrada livene nadogradnje |
| D18005 | Laboratorijska izrada livene fasetiranog međučlana | Laboratorijska izrada fasetiranog međučlana |
| D18010 | Laboratorijska izrada totalne polimer proteze s metalnom bazom | Laboratorijska izrada totalne zubne proteze s metalnom bazom |
| D17005 | …aparata bez konstr. zagriza sa pet ili više elemenata pored baze izrađenog na podlozi konstr. zagriza | …aparata sa pet ili više elemenata pored baze izrađenog bez konstrukc. zagriza |

Мелкие расхождения не трогал (D17002 «podbradne»/«podbradak», M01027 «deformacijama»/«deformacijom»).

### Что проверено и верно

- 9 стоматологических строк (D11006, D13008, D13022, D13041–D13046, D13050), H02018, J07004 и X01022, где paddle и LLM расходились: везде права БД, ошибался LLM.
- Все остальные 92 строки «только LLM» (K01023–K01052, M01018–M02011, D15010–D15013, D17/D18, X…_GYN, X…_TBC, L04003, X01022_PATR) сверены по страницам 6, 10–12, 19–23: цены верны.
- Строки, где paddle и LLM дали одну цену, не перепроверялись.

## 3. SQL

`server/sql/update-tariff-fzocg-pzz-2026.sql`: 20 UPDATE цены и 5 UPDATE имени. Каждый UPDATE с условием на старое значение: повторный прогон ничего не меняет, а строку, которая на проде уже отличается, не тронет. Локально под условия попадает ровно по одной строке на каждый из 25 UPDATE. В конце файла — контрольный SELECT. Коды не меняются, перелинковка не нужна. Полный снапшот `insert-tariff-fzocg-pzz.sql` не перегенерирован (`generate_tariff_sql.py` пересобирает все 7 файлов) — при следующей полной сборке он подтянется из FINAL.

## 4. Цены домов здоровья против PZZ

Сопоставление по голому коду внутри `fzocg-pzz` (префиксы `HN_`, `MO_`, `MO_HN_` и суффикс `_KO` сняты), строки `is_obsolete = 0`.

**Совпадений один к одному нет ни у одной клиники**, поэтому нет и цен, которые «совпадали со старым тарифом». К тому же тариф не менялся: PDF тот же.

**ДЗ Мойковац (127): цены устарели.** Источник — их прайс от 02.10.2025 (`прейскуранты/mojkovac dz/02.10.2025.pdf`), импортирована колонка «Cijena × 3». База этого прайса (цена / 3) — тариф PZZ **предыдущей** редакции. Действующая редакция от 01.05.2026 выше:

| раздел | строк | новый / старый |
|---|---:|---|
| A01, A02 (izabrani doktor) | 26 | +4,9 % (A02 частично +2,5 %) |
| C01, C02 (ginekolog) | 10 | +4,9 % |
| G01, G02 (TBC) | 6 | +2,6 % |
| H01 (psihijatar, по исправленному тарифу) | 23 | +3,6 % (H01013 — выброс: у них 72,47, в тарифе 56,30) |
| H02 (psiholog) | 25 | +1,8…4,9 % |
| H09 | 6 | +2,1 % |
| J06 (RTG) | 15 | +11,2 % |
| J07 (UZ) | 8 | +4,0 % |
| J11 | 3 | 0…+7,6 % |
| K01 | 2 | +11,1 % |
| L01–L04 (patronaža) | 21 | +7,9 % |
| M01, M02 (fizikalna) | 38 | 0…+6,5 % (большинство без изменений) |
| X01–X03 | 35 | неоднозначно: коды X переиспользуются в разных секциях с разной ценой |

Если ДЗ Мойковац пересчитал прайс по правилу «× 3» от нового тарифа, наши цены ниже реальных на 2–11%. Кандидат на `is_price_outdated` или на проверку их сайта. Ничего не менял.

**ДЗ Херцег-Нови (80), Даниловград (85), Колашин (128)** — единого множителя нет. У Херцег-Нови по разделам от 1,7 до 3,5 × тариф, целые евро. У Даниловграда J06 ровно 2,61 ×, J07 2,22 ×. У Колашина 2,09 × в A/C. По одному тарифу нельзя сказать, от какой редакции они посчитаны. Даты их прайсов в `_progress.json` не записаны.
