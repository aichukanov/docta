# Pricelist OCR — сводный VERIFY checklist

Документ покрывает **все** прайслисты (FZOCG + KBKotor), не только SEKUNDARNA OSTALO. Обновлён после paddle-merge всех документов (2026-05-13).

> ## ✅ РЕЗОЛЮЦИЯ 2026-06-11 (сверка с PDF, исправления применены)
>
> Все 🔴 HIGH сверены с исходными PDF (рендер сканов + визуальная вычитка) и исправлены прямо в `*-FINAL.json`. Источник в `_sources` помечен `verified-pdf`.
>
> | Категория | Что сделано |
> |---|---|
> | **sekundarna-ostalo** | D02241=325/65/390, D02252=130/26/156 (+имя ć→đ), D05065=32.5/9.1/41.6 (+имя). Все три — колонки Operacija/Anestezija/Ukupno. |
> | **PZZ** | X01021=1.03 подтверждён (3 инстанса, «3-я цена» — OCR-мусор). X01022: **обе цены реальны** — 1.03 (TBC centar) + **добавлена** 0.90 (Jedinica za patronažu). items 492→493. ⚠️ дубль кода X01022 (разнесён по `section`). |
> | **DRG** | I24Z=0.75/570.14 подтверждён (3.68/2797.46 — это I25A, сдвиг строки). **Удалены** I22Z, I25Z, O65Z (нет в источнике). Сняты флаги `_review` с 23 реальных I/O-кодов (I21Z **реален**). Имена I23Z/I25A/I25B → диакритика. Остаются `E76Z`, `801C` (главы не оцифрованы). items 697→694. |
> | **transfuziologija** | Исправлены имена G05005 («…davaoca, trudnice»), X12021 («Eluciona»), X12060 («Izdvajanje»). X12026/X12042/X12050/X12051/X12053/X12066 — подтверждены как есть. |
> | **apotekarska** | code «50» — **обе услуги реальны** (секции USLUGE и RADNE TAKSE, нумерация перезапускается). Массив перестроен из источника: 37→**40** (добавлены code «1», «607», 2-й «50»; «do 100g»→«do 1000 g»; диакритика; поле `section`). ⚠️ дубль «50» (разнесён по `section`). |
> | **medicinsko-pomagala** | Цены: AA1201=210, AA1204=221.39, AB3111=117.07, AC1110=142.10, AC1112=196. AA2813=«Zamjena zgloba kuka»=150 + **добавлен** AA2814=«Zamjena dezartikulacionog koljena»=150. AC1110/AC1117 имена расцеплены. DA1101-1104 — цена `null` + `price_note: "stvarni trošak"` (в источнике так). items 415→416. |
> | **van-mreze** | J09007=80 (амендмент 01.12.2023; base было 90), J09026=«MR toraksa/medijastinuma - sa kontrastom»=107, D07012=«Laser trabekuloplastika»=291.28 (+секция), X04042=«Ultrazvučni pregled žene»=16.68. |
>
> **НЕ закрыто (требует решения/ресурсов):**
> - ⚠️ **Дубли кодов** X01022 (PZZ) и «50» (apotekarska) — это реальные разные услуги в разных секциях. В JSON оставлены обе строки, разнесены по `section`. Если импорт в БД использует `code` как уникальный ключ — нужно решить, как дизамбигуировать (например `code+section`).
> - 🟡 **defektolog-logoped** (KBKotor §8/§9): в данных FZOCG sekundarna нет ни одного кода I03xxx и ни слова «logoped/defektolog». В PDF нет оглавления (стр.1 — титул, стр.2 пустая). Подтверждение «paddle пропустил секцию» требует полного re-OCR всех 120 стр. — низкая ценность (имена KBKotor-кодов уже есть в KBKotor-файлах). Отложено.
> - 🟢 Массовые `name_disagreements` (диакритика) и `llm-only`/`paddle-only` информационные пункты — не трогались (один источник уже выбран канонически).
>
> Детали ниже по секциям помечены как «✅ РЕШЕНО».

---
PRE-RESOLUTION SNAPSHOT (исходный чеклист, оставлен для истории):

**Где смотреть PDF-источники:**
- FZOCG: `e:/pet/docta.me/прейскуранты/fzocg/<категория>/`
- KBKotor: `e:/pet/docta.me/прейскуранты/kbkotor/`

**Где смотреть JSON-результаты:**
- `data/fzocg/<категория>/<категория>-FINAL.json`
- `data/kbkotor/<slug>/<slug>-FINAL.json`

В каждом item:
- `_sources` — откуда взяты name/price/section (paddle / llm-* / paddle-as-*-via-llm-hint / llm-fallback / llm-only / paddle-single-rescue / llm-substantive)
- `_review` — флаг подозрительности (на сегодня используется только в DRG: `"suspicious-llm-drift"`)
- `name_paddle` — присутствует когда LLM и paddle дали разные имена (substantive)

Легенда:
- 🔴 **HIGH** — реальные дыры в данных или конфликты, требуют сверки с PDF
- 🟡 **MED** — нужна выборочная сверка (1-2 примеров на категорию)
- 🟢 **INFO** — расхождения зафиксированы, но один из источников выбран канонически

---

## 1. SEKUNDARNA OSTALO

**Файл:** [sekundarna-ostalo-FINAL.json](sekundarna-ostalo-FINAL.json) (4031 items, 14 поправок применены хронологически)
**LLM-источник:** [sekundarna-ostalo-LATEST.json](sekundarna-ostalo-LATEST.json) (3941 items с user-fixes)

### 🔴 HIGH: 3 items без цены

| Код | Имя | Секция | Откуда |
|---|---|---|---|
| `D02241` | Desna lobektomija jetre - laparoskopska op. | 36. OPERACIJE - HIRURGIJA | base PDF p.60+ |
| `D02252` | Izvođenje derivacione stome kolona bez resekcije | 36. OPERACIJE - HIRURGIJA | base PDF p.60+ |
| `D05065` | Fraktura distalne epifize radiusa - otvorena/zatvorena, manipulativna | 48. OPERACIJE - ORTOPEDIJA | base PDF p.97+ |

Paddle scheme=unknown для всех трёх. LLM (LATEST) их не имеет. Найти в PDF, дописать цену вручную.

### 🟡 MED: 91 paddle-only код (paddle нашёл, LLM пропустил)

Топ-секций:

| #  | Секция |
|----|----|
| 18 | 41. OPERACIJE - NEUROHIRURGIJA |
| 18 | 49. OPERACIJE - GINEKOLOGIJA I AKUŠERSTVO |
| 9  | 7. INTERVENCIJE I PROCEDURE U SPECIJALISTIČKO-KONSULTATIVNOJ |
| 8  | 36. OPERACIJE - HIRURGIJA |
| 6  | 30. OTORINOLARINGOLOGIJA |
| 4  | 31. OFTALMOLOGIJA, 48. OPERACIJE - ORTOPEDIJA |

Полный список: `merge_info.paddle_only_codes`. Имена без диакритики (paddle). Проверить выборочно 3-5 кодов из каждой большой секции по PDF.

### 🟢 INFO: 172 LLM-only код (LLM нашёл, paddle пропустил)

В основном — amendment-introduced услуги (W04001-W04007 reproduction, K03181 PCR, D07001-D07011 oftalmologija, D24025 stomatologija). Имена и цены из LLM. См. `merge_info.llm_only_codes`.

### 🟢 INFO: 1765 name disagreements

Paddle и LLM дали разные имена. В 99% случаев — paddle пропустил диакритику (š/č/ć/ž/đ), LLM имя принято как канон. Paddle-имя сохранено в поле `name_paddle` где есть substantive разница.

### 🟢 INFO: ранее в этом списке (resolved by paddle pipeline)

Резолюции старых VERIFY-items:
- `X01059`, `Z02098` дубликаты — paddle подтвердил оба varianta в base PDF (источник действительно содержит дубликаты). Только 1 instance в FINAL.
- `J07007←J07014`, `B01001←B01003` OCR_FIX — paddle подтвердил оригинальные коды (resolved).
- `Y04010` vs `Y04014` — оба найдены paddle как разные коды.
- `W04001-W04007` reproduction services — теперь имеют цены через llm-fallback.
- `D07001-D07011` ophthalmology amendments — теперь имеют scheme=ambulanta через LLM hint.
- `D24025` — имеет цену 43.29 EUR amb.
- `J09001-J09003` MR — теперь correctly в Odjeljenje column для амендмента 2023-12-01.
- 16 paddle base дубликатов автоматически dedup'нуто.

---

## 2. PZZ (primarna-zdravstvena-zastita)

**Файл:** [../primarna-zdravstvena-zastita/primarna-zdravstvena-zastita-FINAL.json](../primarna-zdravstvena-zastita/primarna-zdravstvena-zastita-FINAL.json) (492 items)

### 🔴 HIGH: 2 paddle-conflicting кода (один и тот же код встречается с разными ценами)

| Код | Имя | Цены paddle base |
|---|---|---|
| `X01021` | Lokalno apliciranje lijeka (subkutano i intramuskularno) | 1.03, 1.03, garbage "cYantaGYlo 15,05" |
| `X01022` | Direktno opservirana terapija za TBC (DOTs) | 1.03 vs 0.9 |

X01021 — третий instance явный paddle-парсинг-фейл (garbage row). Реальный конфликт только в X01022. Сверить с PDF p.5+.

### 🟢 INFO: 18 paddle базовых дубликатов автоматически удалены

Paddle прочитал одну и ту же строку несколько раз через page breaks (resolved).

### 🟡 MED: 92 LLM-only кода — amendment-introduced или paddle missed

См. `merge_info.llm_only_codes`. Большая часть — LLM enriched data.

### 🟢 INFO: 145 name disagreements

Diacritics. Paddle name в `name_paddle`.

---

## 3. DRG (akutno bolničko)

**Файл:** [../drg-akutno-bolnicko/drg-akutno-bolnicko-FINAL.json](../drg-akutno-bolnicko/drg-akutno-bolnicko-FINAL.json) (697 items)
**Cross-validation:** все 697 проходят `coefficient × 760.18 ≈ price_eur`.

### 🔴 HIGH: 1 numeric disagreement

| Код | Имя | Paddle | LLM | Решение |
|---|---|---|---|---|
| `I24Z` | Artroskopija | coef=0.75 / price=570.14 | coef=3.68 / price=2797.46 | Paddle победил (LLM имел row shift в I20-I25 области) |

Сверить с DRG PDF в области MDC 08 (musculoskeletal).

### 🟡 MED: 13 high-confidence "suspicious LLM-only" кодов

LLM нашёл код, paddle нет — но цены и имя дублируют ближайший paddle-код. Помечены `_review: "suspicious-llm-drift"`:

| LLM код | возможный = paddle | имя |
|---|---|---|
| `I01B` | paddle I01A | Obostrani ili višestruki veliki zahvati na zglobovima |
| `I05B` | paddle I05A | Zamjene ostalih zglobova bez vrlo teškim KK |
| `I08B` | paddle I08A | Ostali zahvati na kuku i femuru bez vrlo teškim KK |
| `I13A` | paddle I13B | Zahvati na humerusu, tibiji, fibuli i skočnom zglobu |
| `I17B` | paddle I17A | Maksilofacijalni hirurški zahvati bez KK |
| **`I21Z`** | **paddle I23Z** | Lokalna ekscizija i odstranjenje unutrašnjeg fiksatora — **NOT a real DRG code** |
| **`I22Z`** | **paddle I23Z** | Same name — **NOT a real DRG code** |
| **`I25Z`** | paddle I25A | Dijagnostičke procedure na kostima i zglobovima — возможно реальный code (no-severity-split вариант) |
| `I28B` | paddle I28A | Ostali zahvati na mišićno-skeletnom sistemu bez KK |
| `I71A` | paddle I71B | Ostali mišićno-tetivni poremećaji |
| `I73B` | paddle I73A | Naknadna njega dijela tijela sa mišićno-skeletnim implantatom |
| `O04A` | paddle O04B | Period nakon porođaja sa operat. zahvatom |
| **`O65Z`** | paddle O64Z | Lažni trudovi — **NOT a real DRG code** |

I21Z, I22Z, O65Z — не существуют в AR-DRG standard, вероятно LLM hallucinations от row shift. Жирным выделены наиболее уверенные drift-кандидаты для удаления.

Остальные 15 (из 28 общих) suspicious — имена правдоподобные, цена совпадает случайно с другим кодом (общие DRG-коэффициенты повторяются). См. `merge_info.suspicious_llm_only_details`.

### 🟡 MED: 4 paddle-only кода — реальные находки

| Код | Имя | Секция |
|---|---|---|
| `I23Z` | Lokalna ekscizija i odstranjenje unutrašnjeg fiksatora | MDC 08 (inferred) |
| `I25A` | Dijagnostičke procedure na kostima i zglobovima | MDC 08 |
| `I25B` | Same | MDC 08 |
| `O64Z` | Lažni trudovi | MDC 14 |

Paddle нашёл реальные DRG-коды которые LLM пропустил.

### 🟢 INFO: 332 name disagreements

Diacritics. См. `merge_info.name_disagreement_codes`.

---

## 4. TRANSFUZIOLOGIJA

**Файл:** [../transfuziologija/transfuziologija-FINAL.json](../transfuziologija/transfuziologija-FINAL.json) (67 items)

### 🟡 MED: 9 name disagreements

Коды: G05005, X12050, X12051, X12053, X12021, X12026, X12060, X12042, X12066

Paddle и LLM расходятся по имени — выборочно проверить. См. `name_paddle` поле.

---

## 5. APOTEKARSKA DJELATNOST

**Файл:** [../apotekarska-djelatnost/apotekarska-djelatnost-FINAL.json](../apotekarska-djelatnost/apotekarska-djelatnost-FINAL.json) (37 items)
**LLM-источник:** нет (paddle-only).

### 🔴 HIGH: 1 conflicting код "50"

В paddle 2 разных услуги с code "50":
- "Izdavanje medicinskog pomagala" — price 0.67 (kept in FINAL)
- "Mjerenje jedne supstance do 100g" — price 0.64 (dropped as conflicting)

Скорее всего одно из имён имеет реальный другой код (paddle прочитал "50" вместо настоящего). Сверить с PDF.

### 🟡 MED: все 37 items — paddle-only

Имена без диакритики. Если важна Serbian-Latin корректность — пройти LLM-fallback.

---

## 6. MEDICINSKO POMAGALA

**Файл:** [../medicinsko-pomagala/medicinsko-pomagala-FINAL.json](../medicinsko-pomagala/medicinsko-pomagala-FINAL.json) (415 items)
**LLM-источник:** нет.

### 🔴 HIGH: 10 items без цены

| Код | Имя |
|---|---|
| `AA1201` | Lezište proteze za šaku, mehaničke |
| `AA1204` | Lezište za pasivnu podlakatnu protezu, plastično |
| `AA2813` | Zamjena zgloba kuka / Zamjena dezartikulacionog koljena |
| `AB3111` | Aparat za Pectus carinatum |
| `AC1110` | (paddle прочитал "142,10" в name) |
| `AC1112` | Ortopedske cipele za deformaciju stopala |
| `DA1101` | Vještački nos |
| `DA1102` | Vještačka ušna školjka |
| `DA1103` | Naočare za retenciju vještačkog nosa |
| `DA1104` | Vještački dio lica |

Paddle scheme=single но `single_eur=None`. Найти в PDF.

### 🟡 MED: все 415 items — paddle-only

---

## 7. VAN MREŽE

**Файл:** [../van-mreze/van-mreze-FINAL.json](../van-mreze/van-mreze-FINAL.json) (81 items, 3 поправки применены)
**LLM-источник:** нет.

### 🔴 HIGH: 4 items без цены

| Код | Имя | Заметка |
|---|---|---|
| `J09007` | MR pregled lumbosakralne kičme - bez kontrasta | paddle scheme=dual, оба столбца None |
| `J09026` | (paddle прочитал "J09025" в name) | paddle row mangled |
| `D07012` | (paddle прочитал "D07011" в name) | section 4 OFTALMOLOGIJA |
| `X04042` | (paddle прочитал "L01059" в name) | section 9 USLUGE ASISTIRANE REPRODUKCIJE |

Все 4 — paddle parse errors (row mangled, или scheme misclassified). Найти в исходных PDF (base + 3 амендмента).

### 🟡 MED: все 81 items — paddle-only

---

## 8. KBKotor / Specijalna bolnica Risan — ambulanta (treca lica)

**Файл:** [../../kbkotor/ambulanta-treca-lica/ambulanta-treca-lica-FINAL.json](../../kbkotor/ambulanta-treca-lica/ambulanta-treca-lica-FINAL.json) (368 items)
**Базовое правило:** KBKotor price ≈ FZOCG sekundarna ambulanta × 3.0 (приказ Минздрава 011-25/2019-2 от 14.02.2019).

### 🟡 MED: 8 кодов не в FZOCG sekundarna

`I03017`, `I03018`, `I03019`, `I03020`, `I03021`, `I03022` — секция "USLUGE DEFEKTOLOGA-LOGOPEDA". Возможно эти коды есть в FZOCG, но paddle их пропустил при OCR sekundarna базы.

`X01063`, `X02046` — изолированные коды.

### 🟢 INFO: 81 xval mismatch

KBKotor's цена ≠ FZOCG × 3.0 в пределах допуска. В основном — FZOCG поправлен после 2022-03-01 (KBKotor effective date — он frozen на 2022-03-01). См. `merge_info.xval_mismatch_sample`. Не требует исправления.

---

## 9. KBKotor / Specijalna bolnica Risan — odjeljenja (treca lica)

**Файл:** [../../kbkotor/odjeljenja-treca-lica/odjeljenja-treca-lica-FINAL.json](../../kbkotor/odjeljenja-treca-lica/odjeljenja-treca-lica-FINAL.json) (773 items)
**Базовое правило:** KBKotor price ≈ FZOCG sekundarna odjeljenje × 2.5.

### 🟡 MED: 30 кодов не в FZOCG sekundarna

Список: `D26146`, `I03001-I03022` (8 кодов defektolog-logoped), `J06060`, `J10013`, `J10016`, `J10044`, `X09007`, `X12063-X12065`, `X13002-X13004`, `Y12001`, `Y13002`, `Y13003`, `Z02054`, `Z02055`, `Z02085`, `Z02086`

Эти коды паркуются в `name_kbkotor_paddle` form (без диакритики). Если найти их в FZOCG sekundarna PDF в секциях которые paddle пропустил — можно обогатить.

### 🟢 INFO: 96 xval mismatch — same as ambulanta (FZOCG amended после 2022-03-01).

---

## Команды для проверки

```powershell
# Items без цены в категории
$f = Get-Content data/fzocg/sekundarna-ostalo/sekundarna-ostalo-FINAL.json | ConvertFrom-Json
$f.items | Where-Object { -not ($_.price_eur -or $_.price_odjeljenje_eur -or $_.price_ambulanta_eur -or $_.price_operacija_eur) } | Format-Table code, name

# DRG items с _review флагом
$d = Get-Content data/fzocg/drg-akutno-bolnicko/drg-akutno-bolnicko-FINAL.json | ConvertFrom-Json
$d.items | Where-Object { $_._review } | Format-Table code, name, _review

# Все merge_info по категории
(Get-Content data/fzocg/<кат>/<кат>-FINAL.json | ConvertFrom-Json).merge_info
```

или bash:

```bash
jq '.items[] | select((.price_eur // .price_odjeljenje_eur // .price_ambulanta_eur // .price_operacija_eur) == null)' data/fzocg/sekundarna-ostalo/sekundarna-ostalo-FINAL.json
jq '.items[] | select(._review)' data/fzocg/drg-akutno-bolnicko/drg-akutno-bolnicko-FINAL.json
jq '.merge_info' data/fzocg/<кат>/<кат>-FINAL.json
```

---

## Сводка по всем категориям

| Категория | Items | 🔴 HIGH | Статус | Примечание |
|---|---|---|---|---|
| **sekundarna-ostalo** | 4031 | 3 no-price | ✅ решено | цены вписаны (Operacija/Anestezija/Ukupno) |
| **primarna-zdravstvena (PZZ)** | 492→**493** | X01022 | ✅ решено | обе цены реальны, добавлена 0.90 patronaža; ⚠️ дубль кода |
| **DRG** | 697→**694** | I24Z + I21Z/I22Z/O65Z | ✅ решено | I24Z=0.75 верно; удалены I22Z/I25Z/O65Z; 23 флага сняты |
| **transfuziologija** | 67 | — | ✅ решено | 3 имени исправлены, 6 подтверждены |
| **apotekarska** | 37→**40** | code "50" | ✅ решено | обе реальны; +3 пропущенных строки; ⚠️ дубль кода |
| **medicinsko-pomagala** | 415→**416** | 10 no-price | ✅ решено | 6 цен; 4×DA110x = «stvarni trošak»; +AA2814 |
| **van-mreze** | 81 | 4 no-price | ✅ решено | цены+имена из base/амендмента |
| **kbkotor ambulanta** | 368 | — | 🟡 info | 8 not-in-FZOCG (см. defektolog ниже) |
| **kbkotor odjeljenja** | 773 | — | 🟡 info | 30 not-in-FZOCG (defektolog отложен) |
| **ИТОГО** | **~6964** | **19 high → 0** | | дубли кодов X01022/«50» — на решение по импорту |

Старый LLM-OCR список из 132 верификационных items — почти все resolved через paddle pipeline (см. §1 → 🟢 INFO).
