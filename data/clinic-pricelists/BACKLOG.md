# Прайсы: хвосты после импортов по карте

Что осталось после импортов 2026-10-02…06. Решения по клиникам лежат в
`data/clinic-imports/<slug>.json` (`excluded`, `openQuestions`). Здесь — то, что
относится не к одной клинике, а к каталогу или к процессу.

## Каталог: кандидаты в слияние (не слиты)

Сливать отдельной миграцией по образцу `migrations/050-labtest-dedup-moj-lab.sql`.
Пару нельзя сливать, если одна клиника держит обе записи с разными кодами или ценами:
решает код прайса, а не похожесть названия.

**Источники:**

- **Diagnostica** — около 40 пар с обоснованием по каждой, в отчёте по спорным
  позициям 2026-10-06. Ключевые:
  - NT-proBNP / Pro-BNP;
  - Microalbumin (моча, 24 ч);
  - VMA, 5-HIAA в моче;
  - Urine Culture;
  - мазки «Bacteriological Examination…» и «… Swab for Bacteria / Fungi» по локусам (горло, уретра, влагалище, вульва, сперма);
  - перианальный отпечаток;
  - N. gonorrhoeae;
  - дерматофиты (кожа, ноготь);
  - TPHA;
  - Influenza A+B;
  - ANA / ANA HEp-2;
  - QuantiFERON / TB test;
  - Chlamydia PCR;
  - аллергопанели 30 (пищевая, ингаляционная, детская);
  - услуги: в/м инъекция, УЗИ яичек, допплер нижних конечностей, CTG, справки для работы и вождения.
- **Tesla** (`data/clinic-imports/tesla-medical-berane-prices-2026-10.md`, раздел 6):
  - `beta-2-glycoprotein-i-*` / `-1-*`;
  - `free-metanephrine` / `-in-plasma`;
  - `penicilloyl-g/v` (`-ige` / `-hsa`);
  - `fish-mix-fx74` / `fish-mix-fp2`;
  - допплер верхних и нижних конечностей (`*-color-doppler` / `doppler-*-blood-vessels`).
- **Vaše zdravlje:**
  - Medical Certificate for Low-Risk Work / for General Work — кандидат в слияние;
  - панели ПАВ — сначала решить, какая из частных панелей основная.

**Слить нельзя** (одна клиника держит обе записи):

- Drug Panel 10 / 10 II — Novi Standard;
- `aquaporin-4-antibodies` / `aquaporin-antibodies` — Novi Standard;
- `diamine-oxidase` / `-dao-histamine` — Novi Standard;
- справки High-Risk Work / повышенный риск — у Diagnostica разные коды.

## Каталог: ошибки в записях

- **Перепутаны коды аллергенов:** d1 стоит у `house-dust-mite-ige-h2`, хотя это код
  `storage-mite-ige-d1`. Также неверные коды у g12 («ljulj»), g6 (`cat-hair-ige-g6`), e1, c2 и f4.
- **Тропонин:** код FZOCG Z02053 «Troponin» у КЦЦГ, Danilo и Рисана лежит на Troponin I,
  а у ОБ Никшич — на общей записи Troponin. Это хвост «тропонин I/T» из аудита названий.

## Процесс

- **Журнал актуальности** — готов 2026-10-06: `scripts/clinics/check-pricelists.mjs`, отчёт `journal.md` (см. README). Открыто: регулярный запуск (раз в месяц).
