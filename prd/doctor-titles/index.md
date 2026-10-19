# Титулы врачей: стандартизация и тултипы

> Статус: **📝 PRD написан 2026-10-09, к разработке не приступали.**
> Срез данных — локальная БД 2026-10-09 (2001 врач, 1901 с титулом, 71 вариант написания).

## Проблема

`doctors.professional_title` — свободный текст, заполнявшийся «как на сайте клиники»
([DOCTOR_SYNC_AGENT.md](../../docs/import/DOCTOR_SYNC_AGENT.md):47). В результате:

- **Зоопарк написаний.** Одно и то же звание записано до 17 способами:
  `dr mr sci. med.` / `mr sc. med. dr` / `dr, mr sc` / `Mr dr` / `mr med.sci` — это всё
  «магистр медицинских наук». Аналогично `prof. dr` / `prof dr` / `prof. dr.`.
- **Пользователь не понимает, что это значит.** `prim.`, `doc.`, `mr sci. med.` — локальная
  черногорско-сербская система званий, незнакомая ни русскоязычным, ни англоязычным
  посетителям. Нигде не расшифровывается.
- **Титул попадает в SEO-строки** (meta description страницы врача, `<title>` страницы
  отзывов, breadcrumbs, JSON-LD `reviewedEntity.name`) в грязном виде.

## Что есть сейчас (инвентаризация)

**Хранение:** `doctors.professional_title varchar(255)`, без валидации на всех путях записи:
[server/api/doctors/add.ts:74](../../server/api/doctors/add.ts) (даже без trim),
[update.ts:97](../../server/api/doctors/update.ts), [update-my-profile.ts:82](../../server/api/doctors/update-my-profile.ts) (trim есть).
Админка и кабинет врача — free-text инпуты
([admin/doctor-add.vue:174](../../components/admin/doctor-add.vue),
[admin/doctor-info.vue:497](../../components/admin/doctor-info.vue),
[profile/DoctorEditForm.vue:223](../../components/profile/DoctorEditForm.vue)).

**Показ пользователю** — единственный публичный рендерер
[components/doctor/info.vue:97-102](../../components/doctor/info.vue): div
`.doctor-professional-title` внутри заголовка (h1/h2), скрывается пропом `short`:

| Место | Компонент | Титул виден |
|---|---|---|
| Hero страницы врача | doctor/hero.vue:30 (`isMainHeading`) | ✅ внутри h1 |
| Каталог `/doctors` | pages/doctors/index.vue:296 | ✅ внутри h2 карточки |
| Команда на странице клиники, попап карты, карточки клиник | `short` | ❌ |
| Кабинет врача | profile/DoctorCard.vue:134 | ✅ `.doctor-card__subtitle` |

**Конкатенация в строки:**

- meta description страницы врача: `doctorNameFull = professionalTitle + ' ' + name`
  ([pages/doctors/[doctorSlug]/index.vue:299](../../pages/doctors/%5BdoctorSlug%5D/index.vue));
- страница отзывов: `entityName = professionalTitle + ' ' + name` →
  `<title>`, description, JSON-LD, breadcrumbs, заголовок
  ([pages/doctors/[doctorSlug]/reviews/index.vue:92](../../pages/doctors/%5BdoctorSlug%5D/reviews/index.vue));
- в schema.org сами значения НЕ попадают: `getSchemaType()` игнорирует аргумент,
  `honorificPrefix`/`jobTitle` сознательно не используются
  ([common/schema-org-builders.ts:389-419](../../common/schema-org-builders.ts)).

Нормализация эти строки слегка поменяет (например `prof dr Ime` → `prof. dr Ime`) — это
ожидаемо и безопасно.

## Решение

Три слоя, три итерации:

1. **Канонический словарь** значений + SQL-миграция нормализации существующих данных.
2. **Тултипы** с расшифровкой каждого компонента титула на 6 локалях.
3. **Защита на входе:** выбор из словаря в админке/кабинете вместо free text, конвенция в
   import-доках.

БД остаётся varchar — никакого enum/справочника: значения редактируются редко, словарь
маленький и статичный, расшифровки — frontend-i18n (конвенция
[локализации малых статичных списков](../../docs/rules/)).

## Канонический словарь

### Токены (атомы, из которых собирается титул)

Титул — комбинация из 12 токенов. Тултип расшифровывает каждый токен титула отдельной строкой.

| Токен | Что значит (основа для i18n, здесь ru) |
|---|---|
| `dr` | доктор медицины (doktor medicine) — базовое звание врача |
| `dr stom.` | доктор стоматологии (doktor stomatologije) |
| `mr ph.` | магистр фармации (magistar farmacije) — фармацевт |
| `prim.` | примариус (primarijus) — почётное звание Минздрава за многолетнюю выдающуюся клиническую работу |
| `prof.` | профессор медицинского факультета |
| `doc.` | доцент медицинского факультета |
| `ass.` | ассистент медицинского факультета |
| `dr sci. med.` | доктор медицинских наук — учёная степень (аналог PhD) |
| `mr sci. med.` | магистр медицинских наук — учёная степень между врачом и доктором наук (доболонская) |
| `mr sci. stom.` | магистр стоматологических наук |
| `mr psih.` | магистр психологии |
| `dr sci. psih.` | доктор наук в области психологии |

Порядок токенов в каноническом значении (региональная конвенция написания):
`[prof.|doc.|ass.] [prim.] [mr sci. …] [dr|dr stom.|mr ph.|mr psih.] | [… dr sci. …]`.
Всё в нижнем регистре («prof. dr Ime Prezime» — обычное написание в сербском).
У обладателя `dr sci. med.` базовое `dr` не дублируется (так принято и так в данных).

### Маппинг нормализации (71 → 20)

Срез локальной БД 2026-10-09, 1901 врач с титулом. Сопоставление в миграции —
**case-insensitive + TRIM** (в данных есть `Dr med`/`dr med`, `mr sc.stom dr ` с хвостовым
пробелом).

| Канон | Врачей | Исходные варианты |
|---|---|---|
| `dr` | 1637 | dr (1630), dr med (4), dr spec. (3) |
| `prof. dr` | 100 | prof. dr (84), prof dr (8), prof. dr. (8) |
| `dr sci. med.` | 35 | dr sci. med. (10), dr sc. med. (8), dr sci med (6), Dr sci. (2), dr. sc. med. (2), dr med sci, dr med. sci., dr. med. sci., Dr sc., dr. sc., dr. sc. med, dr. sci. med. |
| `mr sci. med. dr` | 34 | dr mr sci. med. (10), dr, mr sc (3), mr sc. dr (3), mr sc. med. dr (3), dr, mr. sc. med. (2), mr sci. med. dr (2), dr mr sci, dr, mr sc. med., dr., mr. sci. med., Mr dr, Mr med sci dr, mr med.sci, mr sc. med., mr sci dr, mr sci med, mr sci. dr, mr. sc. dr |
| `prim. dr` | 31 | prim. dr (25), prim dr (6) |
| `prim. dr sci. med.` | 10 | Prim. dr sci. med. (3), prim. dr sc. med. (2), Prim. dr med. sci (2), prim dr sci med, prim. dr sc., Prim. dr sci. |
| `doc. dr` | 10 | doc. dr (6), doc. dr. (2), doc dr, docent dr |
| `mr ph.` | 8 | mr ph |
| `prof. dr sci. med.` | 8 | prof. dr sci med (4), prof dr sci (2), prof. dr sc med., prof. dr. sc. |
| `doc. dr sci. med.` | 6 | doc dr sci (2), doc. dr sci. med, doc. dr sci. med., doc.dr sci., docent dr sc med |
| `dr stom.` | 6 | Dr stom. |
| `ass. dr sci. med.` | 3 | ass. dr sci. med. (2), ass. dr sc. med. |
| `prim. mr sci. med. dr` | 3 | prim. dr, mr sc. med. (2), prim. mr sc.med.dr |
| `ass. dr` | 2 | Ass. dr, ass. dr. |
| `doc. prim. dr` | 2 | Doc. prim. dr, prim. doc. dr |
| `doc. prim. dr sci. med.` | 2 | doc. prim. dr sci. med. (2) |
| `ass. prim. dr sci. med.` | 1 | prim. asist. dr sc. med. |
| `mr sci. stom. dr` | 1 | mr sc.stom dr␣ |
| `mr psih.` | 1 | mr psihologije |
| `doc. dr sci. psih.` | 1 | doc., dr. sc. kliničke psihologije |

Решённые без обсуждения (по принципу «очевидное решать самому»):

- **`dr spec.` → `dr`.** «Специалист» виден из бейджей специальностей рядом с именем
  (у всех троих специальности в `doctor_specialties` проверены) — в титуле это дубль
  информации на странице.
- **`dr med` → `dr`.** То же звание.
- **Психологи** (2 записи) получают собственные токены `mr psih.` / `dr sci. psih.`, а не
  втискиваются в медицинские: специальность «психолог» — не врач.
- **Порядок `doc. prim.`** (а не `prim. doc.`) — академическое звание первым, как в
  преобладающем региональном написании.
- **Не-врачам титул не положен**: физиотерапевты, хиропрактики и т.п. — `NULL`
  (конвенция уже стихийно есть в импортах, фиксируем в доках).

## Итерация 1: нормализация данных

1. Миграция `server/sql/migrations/058-doctor-titles-normalize.sql`:
   - `UPDATE ... SET professional_title = CASE LOWER(TRIM(professional_title)) WHEN ... END`
     по таблице маппинга; идемпотентна (канонические значения в левой части не встречаются
     или маппятся сами в себя);
   - `''` → `NULL` (50 пустых строк);
   - контрольный `SELECT DISTINCT` значений, не входящих в канонический словарь, — на
     проде могут быть значения, которых нет локально; хвост разобрать руками до применения
     кода итерации 2.
2. Конвенция в доках:
   - [CLINIC_DOCTORS_IMPORT.md](../../docs/import/CLINIC_DOCTORS_IMPORT.md) — таблица
     канонических значений, правка шаблона SQL (`'Dr'` → `'dr'`), правило «не-врачам NULL»;
   - [DOCTOR_SYNC_AGENT.md](../../docs/import/DOCTOR_SYNC_AGENT.md) — «как на сайте» →
     «нормализовать по словарю CLINIC_DOCTORS_IMPORT.md»;
   - [docs/DATABASE_SCHEMA.md](../../docs/DATABASE_SCHEMA.md) — пометка у колонки.

Критерии приёмки: контрольный SELECT на проде пуст; `SELECT COUNT(*) GROUP BY` даёт ≤20
значений; страница врача с `prof dr` показывает `prof. dr`.

## Итерация 2: тултипы

1. Словарь `i18n/professional-title.ts` — 12 токенов × 6 локалей (sr, sr-cyrl, ru, en, de,
   tr), формат как в остальных файлах `i18n/`. Каждая расшифровка — **одно короткое
   предложение** (конвенция тултипов). В sr/sr-cyrl токены почти самоописательны — там
   расшифровка минимальная («primarijus — počasno zvanje…»).
2. Компонент `components/doctor/professional-title.vue`:
   - проп `title: string`, проп `interactive: boolean` (default false);
   - парсер: жадное сопоставление канонической строки токенам словаря (по убыванию длины);
     если строка распарсилась не целиком — показать как есть **без тултипа** (graceful
     degradation для ненормализованных значений);
   - `interactive` → `<el-tooltip effect="light" placement="top">`, контент — список
     «токен — расшифровка» построчно; триггер: пунктирное подчёркивание, `cursor: help`,
     `tabindex="0"`, `:aria-label` с полным текстом — паттерн
     [clinic/coupon-badge.vue:76-94](../../components/clinic/coupon-badge.vue);
   - не `interactive` → просто текст (ноль стоимости гидрации).
3. Подключение:
   - [doctor/info.vue:97-102](../../components/doctor/info.vue) — заменить div на компонент,
     `interactive` только при `isMainHeading` (hero страницы врача). **В каталоге `/doctors`
     тултипы не вешаем**: сотни el-tooltip в карточках списка — известная стоимость
     гидрации (docs/audit/lighthouse-perf-2026-09.md, прецедент с контактами в
     clinic/summary.vue:57);
   - [profile/DoctorCard.vue:134](../../components/profile/DoctorCard.vue) — `interactive`
     (кабинет, карточек мало).

Критерии приёмки: на странице врача с титулом `prim. dr` ховер/тап/фокус показывает две
строки расшифровки на языке интерфейса; у врача без титула и с неканоническим титулом
ничего не ломается; каталог `/doctors` не получил новых el-tooltip (проверить число
`.el-popper` в DOM до/после); typecheck зелёный.

## Итерация 3: защита на входе (опционально, дёшево)

1. Админка ([doctor-add.vue](../../components/admin/doctor-add.vue),
   [doctor-info.vue](../../components/admin/doctor-info.vue)) и кабинет врача
   ([DoctorEditForm.vue](../../components/profile/DoctorEditForm.vue)): free text →
   `el-select` со списком канонических значений, `allow-create filterable clearable`
   (новое значение ввести можно — жёсткий whitelist не нужен, но дефолтный путь — словарь).
   Список значений — константой в `common/` (или в том же `i18n/professional-title.ts`),
   сами значения не локализуются.
2. `server/api/doctors/add.ts` — добавить `trim()` (сейчас пишет как есть).

Критерии приёмки: в админке титул выбирается из списка; произвольное значение по-прежнему
можно создать; пустой выбор пишет NULL/''.

## Вне скоупа

- Перенос титула в структуру (отдельные колонки/флаги) — не нужно, пока титул только
  отображается и не участвует в фильтрах/сортировках.
- schema.org `honorificPrefix` — сознательно не используется (см.
  schema-org-builders.ts:389), решение не пересматриваем.
- Тултипы в каталоге `/doctors` — вернуться, если появится ленивый тултип-паттерн
  (рендер el-tooltip по первому mouseenter).
