# Врачи: решения и хвосты по карте 2026-10-02

Что решено и что отложено по итогам `map.json`. Отложенное разбираем после
того, как закончатся сверки прайсов (`data/clinic-pricelists/`).

## Сделано (решение юзера 2026-10-02)

### SQL — `server/sql/update-doctors-2026-10-team-map.sql`

Применён локально и на проде 2026-10-02, проверено на сайте (301 со старых slug, 410 у Karličić).

- **Опечатки в именах:**
  - Blaćo → Blažo Varagić;
  - Miljenjka Tamara → Tamara Milenkaya;
  - Jusković → Nataša Jušković;
  - Kujundžić → Tarik Kojundžić.

  Сменившиеся slug сохранены в `slug_redirects`.
- **Имена основных записей перед слиянием:** Mehmet Gjenashi, Marina Simashova.
- **Специальности:**
  - Petar Popović — ортодонт вместо оральной и челюстно-лицевой хирургии;
  - Ana Bulatović (Apolonia) — dentistry вместо orthodontist.
- **Aleksandar Babović разделён:** психиатр КЦЦГ остался в `aleksandar-babovic`, кардиолог ОБ Беране вынесен в `aleksandar-babovic-2`.
- **Rajko Karličić** (умер) — сначала скрыт с 410, потом решено иначе: миграция 049 снимает скрытие и отвязывает его от ОБ Беране, страница остаётся.

### Слияния — миграция `server/sql/migrations/049-merge-duplicate-doctors.sql`

Те же шаги, что у `api/doctors/merge`, по slug. Прогнана локально с ROLLBACK (дважды, второй прогон — 0 строк), применяет юзер.

| Основной (остаётся) | Вторичный (вливается) | Доказательство |
|---|---|---|
| `marko-albijanic` | `marko-abijanic` | Опечатка со страницы «Hirurgija» Konzilijum. На всех остальных сайтах — Albijanić, уролог. |
| `mehmet-gjenashi` | `gjenasi-mehmet` | Один врач ДЗ Бар. На сайте «Gjenashi Mehmet». |
| `marina-simashova` | `simasova-marina` | Один врач ДЗ Бар. На сайте «Simashova Marina». |
| `jelena-terzic-miranovic` | `jelena-miranovic` | Гинеколог. У Kerber и ДЗ Подгорица «Jelena Miranović», у SmartMed полное имя «Jelena Terzić Miranović». |
| `ljiljana-cirkovic-natalic` | `ljljana-cirkovic` | В биографии Ćirković Natalić: КЦЦГ, «Načelnica preoperativne pripreme». КЦЦГ указывает Ljiljana Ćirković в отделении предоперационной подготовки. Кардиолог в обоих местах. |

### Проверено, не сливать

- **Senad Kalač — два разных человека.** `senad-kalac` — хирург (эндокринная хирургия), КЦЦГ и Konzilijum. `senad-kalac-2` — психиатр, КЦЦГ и Vaše zdravlje.
- **Ana Bulatović — две разные:** `ana-bulatovic` — ревматолог (КЦЦГ, Luca), `ana-bulatovic-2` — стоматолог (Apolonia).
- **Milenko Tadić — один врач, анестезиолог:** Danilo, Moj Lab, Humana. «Internista i kardiolog» на сайте Humana считаем ошибкой сайта: ЭКО-клинике нужен анестезиолог. Специальность не трогаем.

## Синхронизация составов 2026-10-06 — сделано

Семь групп клиник, по агенту на группу. Правила — `docs/import/DOCTOR_SYNC_AGENT.md`.
SQL лежит в `server/sql/update-doctors-2026-10-<группа>.sql`, решения — в
`data/clinic-teams/decisions/<группа>.md`. Применено локально и на проде 2026-10-06.
Сверено: по 40 клиникам число врачей на проде совпадает с локальной БД.

| Группа | Отвязано | Привязано существующих | Создано |
|---|---|---|---|
| kccg | 0 | 18 | 47 |
| hospitals | 0 | 10 | 39 |
| domovi-zdravlja | 18 | 2 | 73 |
| dz-podgorica | 0 | 35 | 142 |
| networks (Milmedika, Moj Lab, Hipokrat) | 46 + перепривязки | 82 | 52 |
| private-pg | 75 | 30 | 32 |
| private-other | 14 | 20 | 25 |

Итог: врачей 1327 → 1726, привязок 1855 → 2321. Около 54 врачей остались без клиник:
ушли, а нового места не нашлось. Их не удаляли и не скрывали (решение юзера).

**Закрыто попутно:**

- **Все 7 сомнительных пар:**
  - Račeta → **Mašić**: переименовано, со старого slug 301;
  - Ryzhov = `mihail-rizov`;
  - Jovo = `jovan-djedovic`, имя не меняли;
  - Veselin — правильное имя, «Velimir» — опечатка в перепечатке;
  - Nerić — разные люди, Jelena заведена психологом;
  - Bobić и Anjuta — без изменений.
- **Olivera Miketić** — эндокринолог SmartMed Podgorica, привязана.
- **ОБ Котор** — website → https://kbckotor.me.
- **Spa Medica и ДЗ Колашин** — заведены их врачи (в Колашине — штатные).
- **Senad Kalač** — хирург привязан к Konzilijum, психиатр — к Vaše zdravlje.
- **Violeta Manović** (Беране) не отвязана: страница показывает только руководителей. Снята только должность.

## Осталось

- **Специальности (решение 2026-10-07):** добавлены пародонтология (95), спортивная медицина (96), дефектология (97) — код (`enums/specialty.ts`, `i18n/specialty.ts`, schema.org) + `migrations/052-specialties-periodontology-sports-defectology.sql` (3 + 5 + 2 врача, 9 + 4 + 13 услуг). Судебная медицина и эмбриолог — не заводятся: нет пациентского выбора (Ivana Čurović Šoškić, эмбриологи Humana/Moj Lab/Ars Medica — без записи).

- **Не заведены до прояснения:**
  - Goran Batrićević / Šoković (КЦЦГ);
  - лаборатория Brezovik (Matić, Perović, Lučić);
  - Andrijana Kostić (Normedica, страница 2023 года).
- **Сайты с неполным списком** — отвязку не делали:
  - Dukley — две Olga;
  - Viller — Civkina, Vaganova;
  - Medical Vraneš — Antipina, Dejeva, Nesterova;
  - ОБ Котор — 22 врача, проверить нечем.
- **Опечатка:** у `bozovic-bjanka` в `name_sr` «Božovic» без диакритики.
- **Повторная сверка составов** — журнал готов 2026-10-07: `scripts/clinics/check-doctor-teams.mjs`, отчёт `journal.md` (см. README). Открыто: регулярный запуск раз в месяц вместе с журналом прайсов.
