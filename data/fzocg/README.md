# FZOCG — государственные тарифы Черногории

**Fond za zdravstveno osiguranje Crne Gore** — государственный фонд медицинского страхования. Публикует обязательные тарифы, по которым гос. учреждения выставляют счёт фонду за услуги. На сайте — используется как референс рядом с ценами клиник на странице услуги.

**Источник:** https://fzocg.me/cjenovnici/
**В проде с 2026-05-18.**

## Что в БД

Таблица `medical_service_tariffs` — отдельная от `clinic_medical_services` (FZOCG не клиника, а национальный референс). Связывается с `medical_services` через `medical_service_id` (по кодам + по именам).

7 категорий, 5820 строк:

| Категория | tariff_source | Items | Linked к medical_services |
|---|---|---|---|
| Primarna ZZ (PZZ) | `fzocg-pzz` | 492 | ~43% |
| Sekundarna ostalo | `fzocg-sekundarna` | 4031 | ~59% |
| DRG | `fzocg-drg` | 697 | 0 (ожидаемо — эпизоды госпитализации) |
| Transfuziologija | `fzocg-transfuziologija` | 67 | ~37% |
| Apotekarska | `fzocg-apotekarska` | 37 | 0 (ожидаемо — лекарства) |
| Medicinsko-pomagala | `fzocg-medicinsko-pomagala` | 415 | 0 (ожидаемо — изделия) |
| Van mreže | `fzocg-van-mreze` | 81 | ~79% |

Несвязанные строки остаются в БД и ищутся напрямую по `code` через `/services` (см. `server/api/services/list.ts`).

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
2. `py -3.12 server/scripts/paddleocr_all_fzocg.py` — добавит новые PDF в paddleocr/, старые пропустит (idempotent).
3. Прогнать LLM-OCR (мультимодальный Claude — кидать страницы PDF, на выходе `batch-N-base-pages-*.json` + `amendments-raw/*.json`). Для больших документов разбивать на батчи — см. `sekundarna-ostalo/_PLAN.md` как пример.
4. `py -3.12 server/scripts/paddle_to_items.py`
5. `py -3.12 server/scripts/merge_to_final.py` (для DRG: `drg_merge.py`)
6. `py -3.12 server/scripts/generate_tariff_sql.py` — перегенерирует все 7 SQL-файлов.
7. Применить на проде (см. ниже).

## SQL для прода

10 файлов, всё идемпотентно (`ON DUPLICATE KEY UPDATE` + WHERE `medical_service_id IS NULL`):

```bash
# Схема — один раз для нового окружения
mysql -u <user> -p --default-character-set=utf8mb4 docta_me < server/sql/create-medical-service-tariffs.sql

# Данные — 7 файлов
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

**Скрипты** (`server/scripts/`):
- `paddleocr_all_fzocg.py` — batch PaddleOCR через PP-StructureV3
- `paddle_to_items.py` — paddle JSON → flat items
- `merge_to_final.py` — основной merger (6 категорий)
- `drg_merge.py` — DRG (отдельная схема)
- `kbkotor_merge.py` + `kbkotor_to_items.py` — KBKotor
- `generate_tariff_sql.py` — FINAL.json → SQL

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

## Исторические артефакты

В `sekundarna-ostalo/`:
- `_PLAN.md` — первоначальный LLM-only план обработки sekundarna (до того, как добавили paddle); полезен как референс структуры (8 батчей, 67 секций, 14 поправок)
- `_PROMPTS.md` — промпты для LLM-OCR sekundarna
- `_SECTIONS.md` — каталог секций
- `batch-*.json`, `amendments-raw/*.json` — intermediate LLM-OCR результаты
- `paddleocr/*.json` — raw OCR (тяжёлые, 41MB)
- `*-LATEST.json` — состояние до merge с paddle

Всё это можно удалить если FZOCG переиздаст sekundarna и придётся переделывать с нуля, но пока — оставляем для traceability.
