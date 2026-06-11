# FZOCG — государственные тарифы Черногории

**Fond za zdravstveno osiguranje Crne Gore** — государственный фонд медицинского страхования. Публикует обязательные тарифы, по которым гос. учреждения выставляют счёт фонду за услуги. На сайте — используется как референс рядом с ценами клиник на странице услуги.

**Источник:** https://fzocg.me/cjenovnici/
**В проде с 2026-05-18.**

## Что в БД

Таблица `medical_service_tariffs` — отдельная от `clinic_medical_services` (FZOCG не клиника, а национальный референс). Связывается с `medical_services` через `medical_service_id` (по кодам + по именам).

7 категорий, 5822 строки (после PDF-сверки 2026-06-11; было 5820):

| Категория | tariff_source | Items | Linked к medical_services |
|---|---|---|---|
| Primarna ZZ (PZZ) | `fzocg-pzz` | 493 | ~43% |
| Sekundarna ostalo | `fzocg-sekundarna` | 4031 | ~59% |
| DRG | `fzocg-drg` | 694 | 0 (ожидаемо — эпизоды госпитализации) |
| Transfuziologija | `fzocg-transfuziologija` | 67 | ~37% |
| Apotekarska | `fzocg-apotekarska` | 40 | 0 (ожидаемо — лекарства) |
| Medicinsko-pomagala | `fzocg-medicinsko-pomagala` | 416 | 0 (ожидаемо — изделия) |
| Van mreže | `fzocg-van-mreze` | 81 | ~79% |

Несвязанные строки остаются в БД и ищутся напрямую по `code` через `/services` (см. `server/api/services/list.ts`).

**Дубли кодов:** UNIQUE KEY = `(tariff_source, code)`. Исходник иногда легитимно переиспользует код в разных секциях (PZZ `X01022`: TBC-центр vs патронаж; apotekarska `50`: USLUGE vs RADNE TAKSE). `FINAL.json` хранит реальный код; `generate_tariff_sql.py` оставляет первое вхождение как есть, а последующим даёт суффикс-акроним секции (`X01022-JZP`, `50-RT`) и пишет реальный код в `notes`. Схему не меняем.

## Архитектура

```
PDF (fzocg.me)
  │
  ├─► PaddleOCR (paddleocr_all_fzocg.py)
  │     → paddleocr/*.json (raw PP-StructureV3 layout)
  │     → paddle_to_items.py → paddleocr/*.items.json (flat list)
  │
  └─► LLM-OCR (Claude мультимодальный)
        → batch-*.json (база, по страницам)
        → amendments-raw/*.json (поправки)
  │
  ▼
merge_to_final.py  (cross-validate paddle ↔ LLM, dedup, apply amendments)
  │
  ▼
data/fzocg/<категория>/<категория>-FINAL.json
  │
  ▼
generate_tariff_sql.py
  │
  ▼
server/sql/insert-tariff-fzocg-*.sql  (ON DUPLICATE KEY UPDATE — re-runnable)
  │
  ▼
mysql → medical_service_tariffs
  │
  ▼
update-medical-service-tariffs-linkage.sql     (code-based)
update-medical-service-tariffs-name-match.sql  (name-based fallback)
  │
  ▼
API: server/api/services/details.ts  → tariffs[] на странице услуги
     server/api/services/list.ts     → поиск по коду (`X02011`)
UI:  components/medical-service/fzocg-tariff-card.vue
```

DRG имеет особую схему (`coefficient × base_rate`), поэтому у него отдельный merger — `drg_merge.py`. Для KBKotor (Risan) — `kbkotor_merge.py` + `kbkotor_to_items.py`.

## Как обновить, если FZOCG выпустил новую редакцию

1. Положить новый PDF в `e:/pet/docta.me/прейскуранты/fzocg/<категория>/`.
2. `py -3.12 scripts/fzocg/paddleocr_all_fzocg.py` — добавит новые PDF в paddleocr/, старые пропустит (idempotent).
3. Прогнать LLM-OCR (мультимодальный Claude — кидать страницы PDF, на выходе `batch-N-base-pages-*.json` + `amendments-raw/*.json`). Для больших документов разбивать на батчи — см. `sekundarna-ostalo/_intermediate/_PLAN.md` как пример.
4. `py -3.12 scripts/fzocg/paddle_to_items.py`
5. `py -3.12 scripts/fzocg/merge_to_final.py` (для DRG: `drg_merge.py`)
6. `py -3.12 scripts/fzocg/generate_tariff_sql.py` — перегенерирует все 7 SQL-файлов.
7. Применить на проде (см. ниже).

## SQL для прода

Два сценария — **новое окружение** (полный импорт) и **апдейт работающей базы** (только дельта).

### A. Новое окружение / полный реимпорт

7 insert-файлов — это полные снапшоты, точно соответствующие `FINAL.json`. Всё идемпотентно (`ON DUPLICATE KEY UPDATE`):

```bash
# Схема — один раз
mysql -u <user> -p --default-character-set=utf8mb4 docta_me < server/sql/create-medical-service-tariffs.sql

# Данные — 7 полных снапшотов
mysql ... < server/sql/insert-tariff-fzocg-pzz.sql
mysql ... < server/sql/insert-tariff-fzocg-sekundarna.sql
mysql ... < server/sql/insert-tariff-fzocg-drg.sql
mysql ... < server/sql/insert-tariff-fzocg-transfuziologija.sql
mysql ... < server/sql/insert-tariff-fzocg-apotekarska.sql
mysql ... < server/sql/insert-tariff-fzocg-medicinsko-pomagala.sql
mysql ... < server/sql/insert-tariff-fzocg-van-mreze.sql

# Линковка (порядок важен: сначала по коду, потом по имени)
mysql ... < server/sql/update-medical-service-tariffs-linkage.sql
mysql ... < server/sql/update-medical-service-tariffs-name-match.sql
```

### B. Апдейт работающей базы (инкрементально)

Если прод уже залит — **НЕ гонять 7 полных файлов заново**. Применить только дельту:

```bash
# Только изменившиеся строки (UPDATE/INSERT/DELETE), напр. сверка 2026-06-11
mysql ... < server/sql/update-tariff-fzocg-2026-06-11-verify.sql

# Перелинковать (новые/изменённые строки)
mysql ... < server/sql/update-medical-service-tariffs-linkage.sql
mysql ... < server/sql/update-medical-service-tariffs-name-match.sql
```

> ⚠️ `ON DUPLICATE KEY UPDATE` обновляет и добавляет, но **никогда не удаляет**. Инкрементальный файл `update-tariff-fzocg-*.sql` содержит и `DELETE` для выбывших кодов. Генерируется как diff между прод-состоянием (git-ревизия) и текущим `FINAL.json` — см. как был собран `update-tariff-fzocg-2026-06-11-verify.sql` (27 точечных операций).

## Verification

Каждый `FINAL.json` содержит `merge_info` с подсчётами конфликтов:
- `paddle_only_codes` — paddle нашёл, LLM пропустил
- `llm_only_codes` — LLM нашёл, paddle пропустил
- `name_disagreement_codes` — paddle и LLM расходятся в имени
- `paddle_duplicates_dropped` — дедуп paddle между page-break'ами
- `xval_mismatch_sample` (DRG/KBKotor) — расхождение cross-validation

Сводный VERIFY-чеклист по всем 9 документам (7 FZOCG + 2 KBKotor) — в [sekundarna-ostalo/_VERIFY_LIST.md](sekundarna-ostalo/_VERIFY_LIST.md). 19 HIGH-priority items требуют ручной сверки с PDF, ~1100 INFO — зафиксированные расхождения с выбранным каноном.

## Схемы цен (`scheme` column)

| Scheme | Колонки | Где встречается |
|---|---|---|
| `single` | `price_eur` | PZZ, apotekarska, medicinsko-pomagala, transfuziologija |
| `dual` | `price_odjeljenje_eur` + `price_ambulanta_eur` | sekundarna, van-mreze |
| `operacija` | `price_operacija_eur` + `price_anestezija_eur` + `price_ukupno_eur` | хирургические секции sekundarna |
| `coefficient` | `coefficient` + `base_coefficient_eur` (760.18) → `price_eur` | только DRG |

## Карта файлов

**Скрипты** FZOCG (`scripts/fzocg/`):
- `paddleocr_all_fzocg.py` — batch PaddleOCR через PP-StructureV3
- `paddleocr_pdf.py` — generic single-PDF OCR wrapper
- `paddle_to_items.py` — paddle JSON → flat items
- `merge_to_final.py` — основной merger (6 категорий)
- `drg_merge.py` — DRG (отдельная схема)
- `generate_tariff_sql.py` — FINAL.json → SQL

**Скрипты** KBKotor (`scripts/kbkotor/`):
- `paddleocr_kbkotor.py`, `kbkotor_to_items.py`, `kbkotor_merge.py` — параллельный пайплайн для Risan (использует FZOCG sekundarna FINAL для обогащения имён)

**SQL** (`server/sql/`):
- `create-medical-service-tariffs.sql` — DDL
- `insert-tariff-fzocg-*.sql` — данные (7)
- `update-medical-service-tariffs-linkage.sql` / `-name-match.sql` — линковка

**API** (`server/api/services/`):
- `details.ts` — отдаёт `tariffs[]`
- `list.ts` — поиск по коду (regex `^[A-Z0-9]{2,8}$`)

**Frontend**:
- `interfaces/medical-service-tariff.ts` — типы
- `i18n/medical-service-tariff.ts` — 6 локалей (en/ru/sr/sr-cyrl/de/tr)
- `components/medical-service/fzocg-tariff-card.vue` — карточка
- `pages/services/[serviceSlug]/index.vue` — секция «FZOCG tariff» после «Clinics» + info-баннер

## Структура папки категории

```
data/fzocg/<category>/
├── <category>-FINAL.json     ← каноническая выгрузка для DB
├── _VERIFY_LIST.md           ← актуальный QA (только в sekundarna-ostalo, по всем 9 документам)
├── paddleocr/                ← raw paddle output + parsed *.items.json (~50MB суммарно)
└── _intermediate/            ← все остальные intermediate-данные (см. ниже)
```

`apotekarska`, `medicinsko-pomagala`, `van-mreze` не имеют `_intermediate/` — у них не было LLM-источника, только paddle.

## Зачем нужен `_intermediate/`

Хранит входы для `merge_to_final.py` и исторические заметки. Используется в трёх сценариях:

1. **FZOCG публикует новую поправку** (≈1-2 раза в год) — добавляешь новый PDF в paddleocr, ре-OCR'ишь только новое, пересобираешь merge без потери старых LLM-данных.
2. **Меняешь логику merge'а** — re-run на сохранённых OCR-данных без повторного OCR (paddle ~40min/документ; LLM-OCR ~$ + время).
3. **Дебажишь конкретный item в FINAL** — сравниваешь, что paddle vs LLM выдали по этому коду.

Что лежит:

| Категория | Файлы в `_intermediate/` |
|---|---|
| sekundarna-ostalo | `_PLAN.md`, `_PROMPTS.md`, `_SECTIONS.md`, `_merge.cjs`, `batch-1..8`, `batch-amendments-all.json`, `amendments-raw/`, `sekundarna-ostalo-LATEST.json` |
| primarna-zdravstvena-zastita | `pzz-2026-05-01.json` (LLM-источник) |
| drg-akutno-bolnicko | `drg-2025-01-01.json` (LLM-источник) |
| transfuziologija | `transfuziologija-2015-05-21.json` (LLM-источник) |

Если FZOCG переиздаст базовый прейскурант целиком — содержимое `_intermediate/` устареет, можно удалить и стартовать с нуля.
