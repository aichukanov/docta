# КЦЦГ (Klinički centar Crne Gore): рабочие файлы импорта прайса

Запись об импорте — `data/clinic-imports/klinicki-centar-crne-gore-podgorica.json`,
SQL — `server/sql/insert-clinic-prices-klinicki-centar-crne-gore-podgorica.sql`.
Снимки PDF — `data/clinic-pricelists/sources/klinicki-centar-crne-gore-podgorica/`.

## Конвейер

Все скрипты запускаются из этого каталога (`py -3.12 _scripts/…`), кроме OCR.

1. OCR: `py -3.12 scripts/fzocg/paddleocr_pdf.py <pdf> paddleocr/<name>.json` (из корня nuxt),
   затем `_scripts/kccg_to_items.py paddleocr/<name>.json paddleocr/<name>.items.json`.
2. `_scripts/clean_2019.py` → `ambulanta-2019.json` (paddle + восстановленные склеенные строки).
3. `llm/pages-*.json` — независимая постраничная транскрипция стр. 3–59 (рендер: `_scripts/render_pages.py 3 59`).
4. `_scripts/merge_llm.py` → `ambulanta-2019-final.json`, `_VERIFY_LIST.md`. Ручные решения по скану — `manual-fixes.json`.
5. `_scripts/izmjene2025_manual.py` → `izmjene-2025-ambulanta.json` (амбулаторная часть изменений 2025, ручная транскрипция).
6. DRG 2025: `_scripts/drg_validate.py paddleocr/izmjene-2025.items.json 1900.45 drg-2025.json`, независимая транскрипция
   `llm-drg/pages-*.json`, слияние `_scripts/merge_drg.py` → `drg-2025-final.json` (698 групп).
7. `_scripts/build_matched.py` → `matched.json`: цена (2019 + 2025 по коду), сверки, соответствие по коду больниц.
8. `match/in/*.json` → субагенты по `match/INSTRUCTIONS.md` → `match/out/*.json`; DRG — `match-drg/` по своей
   `INSTRUCTIONS.md`; правки — `match/overrides.json` (DRG, которые нельзя сливать с амбулаторной ценой, —
   `_scripts/drg_split_overrides.py`). Сверка новых записей с каталогом, выросшим после сопоставления, — `recheck/`.
9. `_scripts/build_sql.py` → SQL, `final.json`, `new-entries.json` (кириллица — `_scripts/sr_cyrl.mjs`).
10. `_scripts/build_record.py` → запись об импорте и `new-catalog.md`.

`ref/*.tsv` — выгрузки локальной БД на 2026-10-06 (тарифы FZOCG, коды больниц 88/141/131/137, связи DRG, каталог).
Перед пересборкой их стоит перевыгрузить: сопоставление по коду идёт через них.

## Проверки, на которые можно опереться при перепроверке

- Цена 2019 = 3,0 × `price_ambulanta_eur` FZOCG (или 3,0 × odjeljenje) — ~1900 кодов; = прайсу Danilo — ~1450.
- Осмотры 2025: 33,36 / 16,68 = 3 × текущий FZOCG (11,12 / 5,56).
- DRG 2025: цена = коэффициент × 1900,45 (= 2,5 × 760,18 FZOCG), коэффициенты = FZOCG; та же база у DRG ДЗ Мойковац.
