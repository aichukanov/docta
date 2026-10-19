# Состояние и как продолжить

Последнее обновление: **2026-10-09**. Начинать отсюда. Общий план и подволны — [PLAN.md](PLAN.md),
очередь — [candidates.md](candidates.md).

## Где мы

- **В проде 85 новых карточек клиник** (прод-id 163–247), всё сверено локально и через API. **Волна 2
  закрыта 2026-10-09.**
  - Волна 1, прайс + врачи: MOA, OrthoExpert, Obradović, Lopičić, DentArt, Prima Dent.
  - 2a, прайс без врачей: Stojanović, Feniks, Cirkon.
  - 2b, дома здоровья: Никшич, Цетинье, Беране, Ульцинь, Рожае.
  - 2c, 5+ врачей, 13 клиник (17 карточек с филиалами): Da Vinci, AK Medica, Mela Sana,
    Internos, Mićunović, Moj Doktor, V Dental ×2, Fatić, Vuleković ×2, Vuksanović ×2, Fizio PG,
    Fizio Centar Nikšić, Axon.
  - 2d, первые 6 (8 карточек): Dental Protection, Dentix ×2, Vukotić ×2, Dental Montenegro,
    Ana Medica, Mercur Nera.
  - 2d, вторая порция (9 карточек, прод-id 201–209, 2026-10-09): Dentalux, Ševaljević, Dent-ES,
    Ortholine, K-med ×2 (Бар, Štoj), PhysioCare, Vrmac, Tafica.
  - 2d, третья порция (13 карточек, прод-id 210–222, 2026-10-09): Pržno, Dental Smile, Mitranić,
    Vivadent, Janković, Radunović, SeaStars, Fizio Tim, Vita Feminae, Filia, Kavarić Medical, Oftalens,
    Pat Lab; хвосты второй порции (врачи Tafica, pulmonary-rehabilitation / hifem-therapy / thermotherapy,
    стразы у Ševaljević) — тоже в проде. **Подволна 2d закрыта.**
  - 2e (25 карточек, прод-id 223–247, 2026-10-09): Stefanija, Polident, Keković, Numanović, Omnidental,
    Dental&Estetic, Ital-Dent, Đurović; IMC Fizio, Pollex, OssPhysio, Medcontour, Fontis, Todorović;
    Diagnost, Abramović, Rahović, Sanicard, Kaluđerović, Nova Medicina Rada ×2; Integra, Zobin, MonteRehab,
    ИЗЗ. Плюс дополнение Poliklinika Dr Fatić (привязки хирурга). Timeless Beauty исключён.
- **Каталог почищен миграциями 054–057, всё в проде:**
  - 054 — привязки тарифов ФЗОЦГ PZZ и 27 названий;
  - 055 — слияния, сироты, K- и D-тарифы;
  - 056 — ДЗ Херцег-Нови и Мойковац по оригиналам PDF;
  - 057 — 42 записи-сироты с переадресацией 301.
- **Локальная БД = прод.** Миграция 044 (коллация) теперь применена и локально.
- **Очередь** (сборка 2026-10-09): волны 1 и 2 пусты, в 3-й 103, в 4-й 310.

## Что дальше, по порядку

1. **Волна 3 — только отзывы (≥10 в Google).** Карточка строится из места Google, отзывы
   выгружает юзер. Перед волной обновить число отзывов: выгрузке мест до полугода, а Places
   API — только с разрешения юзера.
2. **Отзывы уже импортированных клиник.** Список ниже: юзер выгружает приложением, импорт —
   по `docs/import/REVIEWS_IMPORT.md`.
3. **Домены.** Раз в месяц: `node scripts/clinics/check-clinic-domains.mjs`, отчёт —
   `data/clinic-domains/report.md`. Ссылки на домены вручную — в
   `data/clinic-domains/decisions.json → research`.

## Цикл одной подволны

1. **Выбрать клиники.** Факты по каждой — в `candidates.json` (места Google, проверка сайта).
2. **Раздать агентам.** Агентам давать общий промпт [WAVE1_IMPORT_PROMPT.md](WAVE1_IMPORT_PROMPT.md)
   (для домов здоровья — плюс [WAVE2B_DZ_ADDENDUM.md](WAVE2B_DZ_ADDENDUM.md)), а в тексте задачи:
   - букву агента и номер волны — для файла `_wave<N>-new-catalog-<X>.json` и папки
     `scratchpad/<X>/`;
   - факты по клиникам: сайт, ссылки на прайс и врачей, файл места Google;
   - кто из врачей встречается у нескольких клиник — таких одному агенту;
   - правило о врачах (см. «Решения юзера»).
3. **Сверить новые записи каталога.** Сравнить `_wave<N>-new-catalog-*.json` между агентами
   (одинаковые slug и name_en), затем с каталогом (`SELECT … WHERE name_en LIKE`). Дубли
   поправить до применения.
4. **Холостой прогон**, если агент не сделал его сам:

   ```
   node scripts/sql/dryrun-import.mjs <in.sql> <out.sql> [shadow]
   ```

   Затем `<out.sql>` в mysql. Ошибок быть не должно, счётчики до и после совпадают.
5. **Команды юзеру.** Одним списком — локально, потом прод, без пропусков — в
   `APPLY-<дата>.md` (образец [APPLY-2026-10-08.md](APPLY-2026-10-08.md)) и тем же текстом в
   ответе. Формат команд — скилл `migration-commands`.
6. **После «применил» — сверить.** Локально — SELECT по slug: врачи, услуги, анализы,
   координаты. Прод:

   ```
   node scripts/clinics/check-prod-clinics.mjs <slug> … --services=<новые slug>
   ```

7. **Отметки:**

   ```
   node scripts/clinics/mark-imported-clinics.mjs <config.json>
   node scripts/clinics/build-clinic-candidates.mjs
   ```

   Формат конфига — в README.md. Затем обновить статус подволны в PLAN.md.

## Решения юзера (2026-10-08, дополнены 2026-10-09)

- **Врачи.** Тот же человек в БД и специальность примерно совпадает — привязка. Иначе —
  отдельная карточка с новым slug, например `dejan-maras-2` или `sasa-uskokovic` при
  существующем `uskokovic-sasa`.
- **Цены.**
  - `is_price_outdated` не ставить, даже у прайсов 2016–2022 годов.
  - Явные опечатки в ценах исправлять, с комментарием в SQL (пример: MOA «10 процедур — 350 €»
    при цене 1150 € за 7 → 1350).
- **Каталог.**
  - Пакеты процедур — отдельные услуги каталога, по схеме `…-package-N-treatments`.
  - Материал или бренд, названный клиникой, не терять: композитная пломба ≠ просто пломба.
    Но брендовый дубль той же сути не заводить: Valplast = flexible-denture.
- **Филиалы** в разных городах — отдельные клиники.
- **Координаты.** Нет места Google — юзер присылает ссылку Google Maps. Не нашёл —
  примерная точка, с пометкой в SQL.
- **Языки.** Клиника — только SR, если приём на другом языке прямо не заявлен. Русская версия
  сайта таким заявлением не считается.
- **Источники.** Альтернативную медицину (Healing Centar) не заводить. Сайты 2013–2022 годов
  импортировать с пометкой «состав мог устареть».
- **Тарифы ФЗОЦГ** ценами клиники не ставить, если у клиники нет собственного прайса.
- **2026-10-09:** врачей можно заводить по косвенным признакам (email отделения, блок на странице, отзыв) —
  с обоснованием в SQL. Почти пустые карточки публиковать можно. Новую запись каталога — если услуга общая
  или не похожа на существующие. Спорные мелочи («остальное») решает координатор сам, юзеру — только
  то, что меняет картину.
- **Часы работы:** если на сайте два графика — брать тот, что не из шаблона темы; не разрешается — не
  заполнять.
- **Wellness-программы** (детокс, антистресс, «healthy aging») и комплементарные техники (рефлексология,
  Yumeiho, висцеральные манипуляции) не заводить. Хиропрактику — заводить, запись уже у 7 клиник.

## Открытые хвосты

- **Отзывы ждут выгрузки** — число в Google на дату выгрузки места; в файлах мест лежит по 5:

  | Отзывов | Клиника (slug) |
  |---|---|
  | 74 | micunovic-medical-podgorica |
  | 61 | lopicic-stomatoloska-ordinacija-podgorica |
  | 49 | ana-medica-podgorica |
  | 43 | dental-montenegro-budva |
  | 39 | fizio-centar-niksic |
  | 36 | v-dental-centar-budva |
  | 35 | axon-fizikalna-terapija-podgorica |
  | 31 | dental-protection-podgorica |
  | 31 | dentix-djurkovic-niksic (+8 у дубля места «Đurković Dent», ChIJkQJkUJupTRMROd69naruGTw — сводить сюда) |
  | 29 | poliklinika-dr-vuksanovic-bar |
  | 28 | stomatoloska-poliklinika-vukotic-herceg-novi |
  | 25 | poliklinika-stojanovic-medical-berane |
  | 24 | poliklinika-feniks-medika-podgorica |
  | 24 | poliklinika-mela-sana-podgorica |
  | 23 | dentart-tivat |
  | 23 | poliklinika-mercur-nera-podgorica |
  | 18 | fizio-pg-podgorica |
  | 17 | internos-medical-podgorica |
  | 14 | orthoexpert-physio-podgorica |
  | 14 | poliklinika-da-vinci-podgorica |
  | 13 | dom-zdravlja-ulcinj |
  | 13 | dom-zdravlja-niksic |
  | 13 | v-dental-centar-podgorica |
  | 12 | poliklinika-dr-fatic-medical-podgorica |
  | 9 | pedijatrijska-ordinacija-vulekovic-podgorica |
  | 7 | dom-zdravlja-cetinje |
  | 6 | ordinacija-obradovic-medical-podgorica |

  Остальные: у AK Medica 5 отзывов — все уже в файле; у ДЗ Рожае, Moj Doktor, ДЗ Беране и
  Vukotić Podgorica 1–3; у MOA, Prima Dent и Dentix Podgorica 0; у Cirkon и двух филиалов
  (Vuleković Sutomore, Vuksanović Ulcinj) места в Google нет.
- **Splendid Dental** (Бечичи, филиал Dental Montenegro) не применён: страница на сайте пустая,
  скорее всего закрыт. Файлы `insert-clinic-splendid-dental-budva*.sql` лежат готовые.
- **Каталог.**
  - 48 стоматологических тарифов ФЗОЦГ (D) без кандидата: лабораторные этапы протезов,
    справки.
  - Guna-коллаген (OrthoExpert, Fizio PG) — записи нет, решено не заводить.
  - «Хирургия синусов» у Vukotić — не заведена: неясно, синус-лифт или что-то другое.
  - Пара `chest-ribs-or-sternum-x-ray-per-view` / `x-ray-sternum` осознанно не слита.
- **Медицинский центр Зобина** использует адрес Vita Feminae в Доброте — разобрать в 2e (Vita Feminae
  заведена в третьей порции 2d, Зобин в неё не смешан).
- **Дубль в каталоге:** `stimulative-exercises-for-at-risk-infants` ≈ `high-risk-infant-stimulation-exercises` —
  в следующую миграцию слияний.
- **K-med:** у точки Čanj есть своё место Google (42.1592681, 19.0036109), в `data/google-places` его нет;
  отдельной карточки нет — тот же город Бар.
- **Stefanija Pantović** привязана и к Sotir, и к своей Stefanija Dental: сайт пишет только «nakon
  višegodišnjeg rada u privatnoj praksi … osnovala sopstvenu ordinaciju», Sotir не назван — привязку к
  Sotir не снимали; проверить в журнале составов.
- **Poliklinika Dr Fatić:** стационарные процедуры с vaskularnahirurgija.me (TEVAR, EVAR, шунтирования,
  ампутации, ангиографии) не заводить — страницы 2017 года, операции в КЦЦГ (решение O подтверждено).
- **Не заведено осознанно:** «gummy smile» у Mitranić (метод не назван), кондиломы у Kavarić (6 кандидатов),
  5 wellness-программ Vrmac, Neurocinetic у PhysioCare (страница-заглушка), белградские ортодонты-партнёры
  Mitranić (2018).
- **Тарифы ФЗОЦГ.** `server/sql/insert-tariff-fzocg-*.sql` перегенерированы 2026-10-08 из
  FINAL.json и совпадают с БД. Если правишь названия тарифов — править FINAL.json и
  перегенерировать (`py -3.12 scripts/fzocg/generate_tariff_sql.py`), иначе повторный прогон
  откатит правку.
- **Врачи с прод-id не выписаны** в записях импорта 2b–2d (только clinicId). Если понадобятся —
  `/api/doctors/list` по clinicIds.

## Грабли сегодняшнего дня

- **Место Google с чужим сайтом.** Место «Nikšić General Hospital» указывает сайт ДЗ Никшич —
  такие случаи разводить в `overrides.json → inDb`.
- **Битые и сменившиеся домены.** `bolnicaberane.com` перекуплен под казино. На medicusplus.me —
  чужой API. Сайт ДЗ Никшич взломан: в страницах скрытые казино-блоки.
- **Сайт режет curl.** domzdravljaberane.me без браузерного User-Agent отдаёт 406,
  micunovicmedical.me на короткий UA — 403.
- **Пароль к проду.** Если команда на проде дала «Access denied», это опечатка в пароле —
  повторить ту же команду.
- **Пробелы в данных.** В именах врачей бывают хвостовые пробелы и табуляция (vukovic-marko) —
  вычищены `update-trim-names-2026-10.sql`.
- **Агенты в одном scratchpad.** Параллельные агенты перезаписывали чужие скрипты в общем
  scratchpad — у каждого должна быть своя подпапка.
- **Длинная переписка.** Юзер просит одну сводку на запуск — команды в одном месте, а не
  разбросанными по сообщениям.
