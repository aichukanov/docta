# Кросс-страновые аналоги лекарств — реализация (актуально на 2026-07-24)

Фича: на карточке препарата (`/medicines/[slug]`) блок **«Аналоги в других странах»** —
зарубежные торговые названия того же действующего вещества по рынкам RU/UA/TR/DE/PL/US,
с сопоставлением состава, дозы и формы против текущей карточки. Плюс — те же бейджи
веществ в секции аналогов ЧГ.

История решений — в PRD.md. Здесь — итоговая архитектура «как есть».

## 1. Модель данных

Рынки (`market_code`): **RU** (Россия/Беларусь/Казахстан), **UA** (Украина), **TR** (Турция),
**DE**, **PL**, **US**. Порядок вывода тот же.

Продукт = **(рынок, бренд, форма)** — ОДНА запись на форму, со своей дозой. Форма
нормализована ссылкой на `med_pharma_forms` (переводы + категория для иконки).

```
med_foreign_products (миграция 017-med-foreign-products-forms.sql)
  id, market_code, brand_name,
  pharma_form_id  -> FK med_pharma_forms.id (NULL = форма не определена)
  strength        -- нормализованная доза ИМЕННО этой формы («200/400 мг», «100 мг/5 мл», «5%»)
  note, sort_order (флагман первым)
  UNIQUE (market_code, brand_name, pharma_form_id)

med_foreign_product_substances
  product_id -> med_foreign_products, substance_id -> med_substances   (many-to-many)
```

«Есть/нет в ЧГ» НЕ хранится — выводится из наличия активного `med_medicines` (см. PRD §5.3).
Комбинированные препараты = продукт с >1 substance (напр. Ибуклин = paracetamol+ibuprofen).

### Эволюция схемы (миграции)
- `015-med-foreign-brands.sql` — старая одно-веществная таблица. **Устарела.**
- `016-med-foreign-products.sql` — продукты + связки (free-text форма/доза). **Устарела.**
- `017-med-foreign-products-forms.sql` — **актуальная**: пересоздаёт таблицы с `pharma_form_id`.
  DROP старых. Данные регенерятся из `insert-med-foreign-products.sql` (идемпотентно).

## 2. Сбор данных (батчи в data/med-foreign-brands/)

Собрано параллельными субагентами ([[feedback_parallel_subagents_bulk_content]],
[[feedback_data_accuracy]]). Форматы батчей:

- `batch-norm-1..19.json` — **нормализованные per-form МОНО-записи** (14-18 — доп. волна:
  восстановление RU/DE/PL/US-моно для 58 туристических OTC-веществ, потерянных из-за бага
  seed-сборки: старые batch-001..007 без поля `src` пропускались; исправлено резолвом src по БД;
  **19 — добор ещё 8 веществ, пропущенных волной 14-18** (aciklovir/heparin/hidrokortizon/
  hipromeloza/lidokain/ofloksacin/tetrizolin/gliceriltrinitrat): показывались только UA/TR
  из trua-волны, RU/DE/PL/US из старых batch-005/006/007 не были перенесены):
  `{market, brand, substances:[src], form:<vocab-key>, strength, note, confidence}`.
  Один объект на (бренд × форма); мультиформенные бренды разбиты (Нурофен → таблетки/суспензия/гель).
- `batch-combo-<ru|ua|tr|de|pl|us>.json` — **комбинированные препараты** (product-form):
  `{market, brand, substances:[src...], form:<free-text>, strength, note}`.
- `batch-combo-enrich.json` — добавляет co-ingredients к бренду:
  `{src, markets:{MK:[{brand, also:[src...]}]}}` (гесперидин→Детралекс, гестоден→Логест).
- (устаревшие исходники: `batch-001..014`, `batch-trua-01..10` — из них построены norm-seed;
  напрямую в сборку НЕ идут.)

`src` = точный `med_substances.name` (натуральный ключ). Компоненты комбо (kofein, propifenazon,
pseudoefedrin, kodein, fenilefrin, hlorfenamin, feniramin, dekstrometorfan, askorbinska kiselina,
hesperidin, gestoden) — уже есть в `med_substances`, курирование не потребовалось.

## 3. Сборка SQL — scripts/medicines/build-foreign-products-sql.mjs

Читает `batch-norm-*` + `batch-combo-<mk>` + `batch-combo-enrich`. Мерджит продукты по
`(market, brandKey, form_id)`, ОБЪЕДИНЯЯ множества веществ (контрацептивы, продублированные
под каждым гормоном в seed, так становятся комбо). Форма: моно `form` = ключ из словаря
(`FORM_KEY_TO_ID`), комбо `form` = free-text → `classifyFormText` → ключ → id. Доза чистится
(`cleanStrength`: убирает «(OTC)/(Rx)»). Эмитит идемпотентный
`server/sql/migrations/insert-med-foreign-products.sql`.

Словарь форм `FORM_KEY_TO_ID` — ключ → представитель `med_pharma_forms.id`
(tablet:125, film_tablet:6, capsule:24, syrup:109, oral_suspension:49, gel:10, suppository:117,
nasal_spray:112, injection:94, … other:null). Полный список — в скрипте.

**Запуск:** `node scripts/medicines/build-foreign-products-sql.mjs`.

**Важно (2026-08-29): файл — ПОЛНАЯ ПЕРЕСБОРКА, а не upsert.** `START TRANSACTION` +
`DELETE FROM med_foreign_product_substances` + `DELETE FROM med_foreign_products` + вставки +
`COMMIT`. Прежний идемпотентный upsert был дырявым: UNIQUE `(market_code, brand_name,
pharma_form_id)` не дедуплицирует строки с NULL-формой (в MySQL NULL != NULL), поэтому каждый
повторный прогон добавлял ещё одну копию продукта без распознанной формы, а связка веществ
(`WHERE ... pharma_form_id IS NULL`) цеплялась ко ВСЕМ копиям. На проде это дало «Salofalk»
11 раз в одном блоке. Побочно upsert не умел удалять продукты, выпавшие из батчей.
В конце файла — VERIFICATION с `duplicate_brand_form`, который обязан быть 0. Отчёт печатает
кол-во продуктов/комбо/связей и `unresolvedSubstances` (должен быть пуст).

## 4. Бэкенд — структура (рефакторинг DRY/KISS/SOLID 2026-07-24)

Хендлеры тонкие; логика и SQL — в `server/common/medicines/`:
- `helpers.ts` — `nameFieldFor(locale)`, `localizedNameSql(alias, field)` (COALESCE+NULLIF),
  `placeholders(n)`, `withConnection(fn)` (пул + гарантированный release в finally),
  `mapPack(row)` (структурные поля упаковки), `localizedField(row, base)` («base/baseEn»).
- `substance-match.ts` — `matchSubstanceSet(pageIdSet, pageNameById, items)` → {substances
  (matched первыми, затем extra), missing, matchedCount, extraCount, fullMatch}. ЕДИНАЯ логика
  сет-матчинга для аналогов И foreign-блока (была продублирована).
- `details-service.ts` — `getMedicineDetails(slug, locale)`: `fetchMedicine` / `fetchSubstances` /
  `fetchAnalogs` / `fetchForeignBrands` / `assembleDetails` (SRP). Хендлер
  `api/medicines/details.ts` (28 строк) только валидирует и вызывает сервис.
- `api/medicines/list.ts` и `filter-options.ts` переведены на те же хелперы (withConnection,
  nameFieldFor, localizedNameSql, mapPack, localizedField).

### foreignBrands (в details-service.fetchForeignBrands)

Тянет продукты, делящие ≥1 вещество с составом карточки (JOIN med_pharma_forms для формы).
В JS на продукт считает:
- `substances`: matched (∈ карточка) первыми, затем extra (лишние);
- `missing`: вещества карточки, которых нет в продукте;
- `fullMatch`: наборы веществ полностью совпали;
- `doseMatch`: `doseMatches(med.strength, product.strength)` — доза карточки ⊆ доз продукта;
- `formMatch`: `getPharmaFormCategory(product.pharma_form_id) === getPharmaFormCategory(med.pharmaFormId)`
  (категория ≠ 'other'). Сопоставление по id формы (см. §5, enums/pharma-form.ts).
- `exactMatch = fullMatch && formMatch && doseMatch` — **условие галочки ✓** (см. §6). Совпадение
  только по веществам галочку НЕ даёт (это и так видно по бейджам); ✓ — редкий полный аналог.

**Ранжирование по рынку:** matched↓, extra↑, **formMatch↓**, **doseMatch↓**, missing↑, sort_order↑.
Форма важнее дозы (крупнее категориальное отличие). **Топ-5 на рынок.**

## 5. Общие утилиты (DRY/SOLID)
- `common/strength-label.ts`: `localizeStrength` + `doseSignature`/`doseMatches`
  (парсинг дозы в множество токенов «значение+единица», кириллица→латиница, граница через
  lookahead; правило page⊆product — моно 400∈{200,400}, комбо {325,400}⊆{325,400}).
- `enums/pharma-form.ts` — `PHARMA_FORM_CATEGORY` (med_pharma_forms.id → категория) +
  `getPharmaFormCategory(id)`. **Сопоставление формы по стабильному id, не по тексту.**
  Карта сгенерирована из справочника, правится вручную. Категории: tablet/capsule/syrup/
  injection/drops/topical/spray/patch/powder/**suppository**/other.
- `common/medicine-form-icon.ts` + `components/medicine-form-icon.vue`: иконка по категории.
  `MedicineFormIcon` принимает `formId` (предпочтительно, id-based) или `formSrc` (текстовый
  фолбэк `getMedicineFormCategory`). Используется у карточки, аналогов, foreign, списка.
  formMatch в API — тоже по `getPharmaFormCategory(pharma_form_id)`. Все ответы API
  (details/analogs/foreign/list) отдают `pharmaFormId`. Свечи получили свою иконку
  (`icon/med/suppository.vue`) и категорию — раньше падали в 'other' и не матчились.
- `components/medicine/substance-badges.vue`: бейджи веществ (matched=акцент, extra=пунктир+тултип,
  missing=перечёркнут). Переиспользуется в foreign-блоке и в карточках аналогов.

## 6. Фронт — pages/medicines/[medicineSlug]/index.vue
Секция `sectionId="foreign"` (scroll-spy таб, весь контент в SSR-DOM для SEO). Широкая сетка
карточек-рынков (`repeat(auto-fill, minmax(320px,1fr))`), флаг-эмодзи, счётчик. На продукт:
бренд + ✓ (`exactMatch` = вещества+форма+доза, тултип) → `MedicineSubstanceBadges` → мета-строка
(`MedicineFormIcon` + локализованное имя формы + доза, зелёная подсветка при form/dose-match).
Аналоги ЧГ: `analog.substanceList`/`missingSubstances` → тот же `MedicineSubstanceBadges`.
schema.org: `alternateName` = зарубежные бренды.

## 7. i18n — i18n/medicine.ts (6 локалей)
`ForeignBrandsTitle`, `ForeignBrandsDisclaimer`, `ForeignFullMatch {name}`,
`ForeignExtraSubstance {name}`, `MarketRU/UA/TR/DE/PL/US` (RU = «Россия, Беларусь, Казахстан»).

## 8. Применение (SQL — вручную, [[feedback_sql_apply]])
```
mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/017-med-foreign-products-forms.sql
mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/insert-med-foreign-products.sql
```
Идемпотентно. Старые 015/016 и `insert-med-foreign-brands.sql` — НЕ применять (устарели; 017 дропает те таблицы).

## 9. На потом
- Ручная вычитка low-confidence записей (доза/наличие) носителем/фармацевтом.
- Часть per-form доз пустые (агенты не угадывали) → показывается иконка+форма без дозы.
- Фаза 2: поиск по зарубежным брендам как синонимам; страницы веществ + «нет в ЧГ».
- Фаза 3: SEO-лендинги по данным GSC.

## 10. Текущее состояние (для продолжения в новом чате)
- **Код готов, typecheck 0.** Актуальный билд: **2683 продукта, 102 комбо, 2874 связи,
  0 unresolved** (`node scripts/medicines/build-foreign-products-sql.mjs`, перегенерация 2026-07-26;
  прежние цифры в этом файле — 2612/121/2802 — устарели). По рынкам: RU 586, UA 473, TR 350,
  DE 446, PL 493, US 335; `nullForm` 61.
- **ПРОД: актуален, переприменять ничего не нужно** (проверено 2026-07-26). Прежняя пометка
  «переприменить insert из-за +694 RU/DE/PL/US-моно» **снята**: сверка всех 156 веществ
  сгенерированного SQL с живыми страницами `https://docta.me/medicines/<slug>?lang=ru`
  дала 154/156 полного совпадения по составу рынков. Оба расхождения —
  `dekstrometorfan` (`caffetin-cold`) и `hlorfenamin` (`rapidex-cold`) — не пробелы в данных,
  а следствие сет-матчинга: обе позиции комбинированные (4 и 3 вещества), точного зарубежного
  комбо-аналога для их набора нет. Скрипт сверки: `scratchpad/check-prod-foreign.mjs`.
- **Как повторить сверку.** Локаль на проде — `?lang=ru`, не префикс пути. Node `fetch` (undici)
  прод режет по TLS-fingerprint (403 после ~76 запросов) — качать `curl` с браузерным
  User-Agent. Вывод `mysql -B` на Windows приходит с CRLF: без `tr -d '\r'` слаг уезжает в URL
  вместе с `\r` и curl отдаёт код 000.
- **Локально применить SQL нельзя** — auto-mode classifier блокирует `mysql`-мутации. Проверка:
  офлайн-тесты (сет-матчинг/доза/форма) + `npx vue-tsc --noEmit`. Локальная dev-БД: creds в `.env`
  (root / docta_me), read-only запросы через `mysql` работают.
- **Регенерация данных:** правишь `batch-norm-*` / `batch-combo-*` → `node scripts/medicines/
  build-foreign-products-sql.mjs` → переприменяешь insert. Старые `batch-001..014`/`batch-trua-*`
  в сборку НЕ идут (наследие; norm-seed для агентов строился из них скриптом в scratchpad).
- **Файлы фичи:** миграции `015..017` + `insert-med-foreign-products.sql`; данные
  `data/med-foreign-brands/batch-{norm-1..18,combo-*,combo-enrich}.json`; билд
  `scripts/medicines/build-foreign-products-sql.mjs`; бэк `server/common/medicines/*` +
  `server/api/medicines/{details,list,filter-options}.ts`; утилиты `common/strength-label.ts`,
  `enums/pharma-form.ts`, `common/medicine-form-icon.ts` + `components/medicine-form-icon.vue` +
  `components/icon/med/*`; UI `pages/medicines/[medicineSlug]/index.vue` + `components/medicine/
  substance-badges.vue`; i18n `i18n/medicine.ts`. Превью `e:\tmp\foreign-brands-preview.html`.
- **Открытый UX-вопрос** (не решён): топ-5 на рынок может показывать один бренд в нескольких
  формах; хард-фильтра по форме страницы нет — только ранжирование (formMatch поднимает нужную
  форму выше). Anton пока согласовал ранжирование, не фильтр.

## 11. Поиск по зарубежному аналогу (2026-08-31)

Таблица `med_foreign_products` работает не только на карточку препарата: по ней ищет
`/api/medicines/list?name=`. «супрастин» → SYNOPEN, «нурофен» → ибупрофены ЧГ.

- **Фильтр** — третья ветка в OR текстового поиска: полу-соединение
  `m.id IN (SELECT mms.medicine_id … JOIN med_foreign_products fp ON … fp.brand_name LIKE ?)`.
  Именно полу-соединение, а не коррелированный EXISTS: LIKE по ~3 тыс. брендов должен
  отработать один раз, а не на каждый препарат (замер: 18 мс на худшем запросе `%a%`).
- **Ранжирование**: своё название важнее аналога — `CASE WHEN m.name LIKE ? …` (точное /
  с начала / вхождение / прочее) перед прежними клаузами. Параметры ORDER BY уходят ТОЛЬКО
  в списочный запрос (у count-запроса нет ORDER BY, плейсхолдеры позиционные).
- **Подпись «почему это в выдаче»** — `server/common/medicines/name-match.ts`: два лёгких
  запроса (совпавшие вещества + совпавшие продукты с их составом) собирают индекс, из него
  на каждую строку считается `MedicineMatch {byName, substances, foreignBrands[{brand,
  fullMatch}]}`. `fullMatch` = наборы веществ бренда и препарата совпали → ярлык
  «Зарубежный аналог»; частичное пересечение → «Похож по составу» (BRUFEN ≠ Nurofen Cold &
  Flu). Совпадение по веществу подписи НЕ получает: вещество и так в карточке, и там
  подсвечивается совпадение ([[feedback_page_data_duplication]]).
- **Где выводится**: дропдаун главной (`components/global-search.vue` +
  `components/search/*`) и карточки `/medicines` — ярлыки в `i18n/search-match.ts`,
  логика в `common/medicine-search-groups.ts::medicineMatchHint`.
- **Зонтичной страницы бренда нет и не нужно**: её роль играет вкладка «Другие дозировки»
  на карточке любого варианта. В дропдауне записи одного названия сводятся в одну строку,
  различия — ярлыками-вариантами со ссылкой на свою фасовку.

### Граница фичи: бренд, вещества которого в реестре нет

`med_foreign_products` ссылается на `med_substances` по FK, а там ТОЛЬКО вещества
зарегистрированных в ЧГ лекарств (сирот — 0 на 2026-08-31). Значит бренд, чьего вещества
здесь нет, в этой таблице представить нельзя — и поиск по нему обязан молчать. Проверено
на «Zyrtec»: цетиризина в реестре нет ни в активных, ни в снятых позициях (`atc_code LIKE
'R06AE%'` → 0 строк), сопоставлять не с чем.

Ответ на такой запрос даёт не каталог, а контент: группа **«Статьи»** в глобальном поиске
(`ARTICLE_SEARCH` в `common/articles.ts` + короткие ярлыки `i18n/article-search.ts`).
У каждой статьи список ключевых слов — торговые названия, которых нет в ярлыке; «Zyrtec»
→ «Лекарства, которых здесь нет» с подписью «Упоминается: zyrtec». Подпись намеренно
слабее, чем «не зарегистрирован»: утверждение об отсутствии делает вычитанный текст
статьи, а не автомат. Синхронность реестра со `ARTICLE_SLUGS` и i18n проверяет
`tests/unit/article-slugs.spec.ts`.
