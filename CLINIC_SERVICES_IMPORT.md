# Промпт для добавления услуг и анализов клиники

## Задача

Добавить медицинские услуги и/или лабораторные анализы в базу данных для клиники `clinic_id = {ID}`.

## Входные данные

### 1. Списки существующих записей

- **Услуги**: `service-list.txt` — формат: `category | id | name_en`
- **Анализы**: `labtest-list.txt` — формат: `category | id | name_en`

### 2. Категории

- **Услуги**: `enums/medical-service-category.ts`
- **Анализы**: `enums/labtest-category.ts`

### 3. Прейскурант клиники

Любой формат: текст, HTML, таблица. Может содержать **вперемешку** услуги и анализы.

---

## ⚠️ Критерии разделения: услуга или анализ?

| Тип                          | Примеры                                                               | Таблица            |
| ---------------------------- | --------------------------------------------------------------------- | ------------------ |
| **Анализ (lab_test)**        | Анализ крови, биохимия, гормоны, маркеры, ПЦР-тесты, антитела, посевы | `lab_tests`        |
| **Услуга (medical_service)** | Осмотры, УЗИ, операции, процедуры, терапия, диагностика (кроме лаб.)  | `medical_services` |

### Пограничные случаи — это УСЛУГИ, не анализы:

| Название                                    | Почему услуга                   |
| ------------------------------------------- | ------------------------------- |
| Забор крови / Blood Draw                    | Процедура, не результат анализа |
| Быстрая гликемия / Rapid Blood Glucose Test | Point-of-care тест, процедура   |
| Экспресс-тесты у постели                    | Процедура                       |
| Биопсия                                     | Хирургическая процедура         |
| Мазок/соскоб (взятие)                       | Процедура взятия материала      |

---

## Структура базы данных

### Услуги

```
medical_services (id, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
medical_service_categories_relations (medical_service_id, medical_service_category_id)
medical_services_specialties (medical_service_id, specialty_id)  -- связь со специальностями врачей
```

### Анализы

```
lab_tests (id, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code)  -- price_max редко используется
lab_test_categories_relations (lab_test_id, category_id)
lab_test_synonyms (lab_test_id, another_name, language)  -- альтернативные названия для поиска
```

---

## Правила создания SQL

### Структура файла

```sql
-- Insert services and lab tests for clinic ID = {ID}
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < d:/pet/docta.me/nuxt/server/sql/insert-clinic-{ID}-services.sql

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: ADD NEW CATEGORIES (if needed)
-- ═══════════════════════════════════════════════════════════════

-- Step 0.1: Insert new categories into medical_service_categories

-- ═══════════════════════════════════════════════════════════════
-- PART 1: MEDICAL SERVICES
-- ═══════════════════════════════════════════════════════════════

-- Step 1.1: Insert new medical services
-- Step 1.2: Set variables
-- Step 1.3: Insert clinic_medical_services (prices) — INSERT IGNORE
-- Step 1.4: Insert category relations — INSERT IGNORE
-- Step 1.5: Insert specialty relations — INSERT IGNORE (auto for matching categories)

-- ═══════════════════════════════════════════════════════════════
-- PART 2: LAB TESTS
-- ═══════════════════════════════════════════════════════════════

-- Step 2.1: Insert new lab tests
-- Step 2.2: Set variables
-- Step 2.3: Insert clinic_lab_tests (prices) — INSERT IGNORE
-- Step 2.4: Insert category relations — INSERT IGNORE
-- Step 2.5: Insert synonyms — INSERT IGNORE
```

---

## PART 0: Новые категории (при необходимости)

Если услуги требуют новую категорию, которой нет в `enums/medical-service-category.ts`:

### 0.1 Добавление в базу данных

```sql
INSERT INTO medical_service_categories (id, name) VALUES
(34, 'Orthodontics'),
(35, 'Pediatric Dentistry')
ON DUPLICATE KEY UPDATE name = name;
```

### 0.2 Обновление кода

После успешного импорта добавить категорию в:

1. `enums/medical-service-category.ts` — enum
2. `i18n/medical-service-category.ts` — переводы (все 6 языков)
3. Этот документ — справочник категорий

---

## PART 1: Медицинские услуги

### 1.0 sort_order для осмотров

Поле `sort_order` в таблице `medical_services` используется для сортировки услуг внутри категории:

| Тип осмотра        | sort_order |
| ------------------ | ---------- |
| Первичный осмотр   | 1          |
| Контрольный осмотр | 2          |
| Остальные услуги   | NULL       |

```sql
-- Устанавливать ПОСЛЕ INSERT INTO medical_services
UPDATE medical_services SET sort_order = 1 WHERE name_en = 'First Gastroenterologist Examination';
UPDATE medical_services SET sort_order = 2 WHERE name_en = 'Follow-up Gastroenterologist Examination';
```

> ⚠️ Ставить sort_order только для осмотров (Examination). Процедуры, операции и т.д. — оставлять NULL.

### 1.1 Новые услуги — все 6 языков

```sql
INSERT INTO medical_services (name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('English Name', 'Serbian Latin', 'Српски ћирилица', 'Русский', 'Deutsch', 'Türkçe'),
('Another Service', 'Druga usluga', 'Друга услуга', 'Другая услуга', 'Andere Dienstleistung', 'Başka Hizmet')
ON DUPLICATE KEY UPDATE name_en = name_en;
```

#### Правила мультиязычных названий

**1. Английское название (`name_en`) — использовать самые частотные медицинские термины:**

- Избегать редких синонимов, выбирать стандартные названия
- Альтернативные названия → добавлять в `lab_test_synonyms`

**2. Латинские биологические названия — НЕ переводить:**

- Названия микроорганизмов остаются на латинице во всех языках: `Mycoplasma`, `Chlamydia`, `Ureaplasma`, `Leishmania`, `Candida`, `Helicobacter`, `Borrelia`, `Toxoplasma` и т.д.
- Пример: `Chlamydia trachomatis PCR` — одинаково на sr, sr_cyrl, ru, de, tr

**3. Международные аббревиатуры — НЕ переводить:**

| Аббревиатура | Значение                       | Оставлять как есть               |
| ------------ | ------------------------------ | -------------------------------- |
| NIPT         | Non-Invasive Prenatal Testing  | ✓ (не "НИПТ" для сербского)      |
| PCR          | Polymerase Chain Reaction      | ✓ (только в русском можно "ПЦР") |
| CRP          | C-Reactive Protein             | ✓                                |
| MxA          | Myxovirus resistance protein A | ✓                                |
| IHC          | Immunohistochemistry           | ✓ (в русском можно "ИГХ")        |
| LEEP/LLETZ   | Loop Electrosurgical Excision  | ✓                                |
| TUR/TRUS     | Трансуретральная резекция      | ✓                                |
| A, B (грипп) | Типы вируса гриппа             | ✓ латинские (не "А, Б")          |

**4. Немецкий и турецкий — ОБЯЗАТЕЛЬНО переводить:**

- Нельзя копировать английское название
- Немецкий: `Histopathologie Magenbiopsie`, не `Histopathology Stomach Biopsy`
- Турецкий: `Histopatoloji mide biyopsisi`, не `Histopathology Stomach Biopsy`

**5. Сербский кириллический — использовать сербские формы:**

- `антитијела` (сербский), не `антитела` (русский)
- `биопсија` (сербский), не `биопсия` (русский)

**Примеры правильных названий:**

```sql
-- ✓ Правильно: латинские названия сохранены
('Chlamydia Trachomatis PCR', 'Chlamydia trachomatis PCR', 'Chlamydia trachomatis PCR', 'Chlamydia trachomatis ПЦР', 'Chlamydia trachomatis PCR', 'Chlamydia trachomatis PCR')

-- ✓ Правильно: немецкий и турецкий переведены
('Histopathology Liver Biopsy', 'PH Biopsija jetre', 'ПХ биопсија јетре', 'Патогистологическое исследование биопсии печени', 'Histopathologie Leberbiopsie', 'Histopatoloji karaciğer biyopsisi')

-- ✗ Неправильно: немецкий и турецкий скопированы с английского
('Histopathology Liver Biopsy', '...', '...', '...', 'Histopathology Liver Biopsy', 'Histopathology Liver Biopsy')
```

### 1.2 Переменные

```sql
SET @clinic_id = {ID};

-- Категории услуг
SET @cat_dentistry = 20;
SET @cat_orthodontics = 34;
SET @cat_pediatric_dentistry = 35;
-- ... другие категории по необходимости

-- Специальности врачей (для категорий, совпадающих со специальностями)
SET @spec_dentistry = 78;
SET @spec_orthodontist = 93;
SET @spec_pediatric_dentistry = 87;
-- ... другие специальности по необходимости
```

> ⚡ Для категорий из таблицы соответствий (см. раздел 1.5) **обязательно** объявлять переменную специальности!

### 1.3 Цены для клиники — INSERT IGNORE

| Ситуация                              | price | price_min | price_max |
| ------------------------------------- | ----- | --------- | --------- |
| `100€` (фикс.)                        | 100   | NULL      | NULL      |
| `od 100€` (от)                        | NULL  | 100       | NULL      |
| `100-120€` (диапазон)                 | 100   | NULL      | 120       |
| `na upit` (по запросу)                | NULL  | NULL      | NULL      |
| **NULL по дизайну** (цена не указана) | NULL  | NULL      | NULL      |

> 💡 **NULL по дизайну**: если пользователь явно говорит "цены не ставь" или "оставь NULL" — цены будут установлены позже вручную. Это отличается от "по запросу".

```sql
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, id, price, price_min, price_max, NULL FROM (
    SELECT id, 100.00 as price, NULL as price_min, NULL as price_max FROM medical_services WHERE name_en = 'Fixed Price Service'
    UNION ALL SELECT id, NULL, 100.00, NULL FROM medical_services WHERE name_en = 'From Price Service'
    UNION ALL SELECT id, 100.00, NULL, 120.00 FROM medical_services WHERE name_en = 'Range Price Service'
    UNION ALL SELECT id, NULL, NULL, NULL FROM medical_services WHERE name_en = 'On Request Service'
) AS service_prices;
```

> **Поле `code`** — внутренний код услуги в клинике (если есть в прейскуранте). Обычно NULL при импорте.

### 1.4 Привязка к категориям — INSERT IGNORE

```sql
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, @cat_general_medicine FROM medical_services WHERE name_en IN (
    'General Practitioner Examination',
    'Specialist Examination'
);
```

### 1.5 Привязка к специальностям — INSERT IGNORE

Связь услуги со специальностями врачей для фильтрации. **Автоматически добавлять для категорий, совпадающих со специальностями!**

> **⚠️ PROCTOLOGY**: категория PROCTOLOGY = 33, специальность PROCTOLOGY = 14

```sql
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, @spec_cardiology FROM medical_services WHERE name_en IN (
    'Cardiologist Examination',
    'ECG',
    'Echocardiography'
);
```

#### ⚡ Автоматическая привязка: категория → специальность

Если услуга привязана к категории из таблицы ниже — **обязательно** привязать к соответствующей специальности:

| Категория (Category) | ID  | Специальность (Specialty) | ID  |
| -------------------- | --- | ------------------------- | --- |
| CARDIOLOGY           | 8   | CARDIOLOGY                | 1   |
| GASTROENTEROLOGY     | 6   | GASTROENTEROLOGY          | 13  |
| GYNECOLOGY           | 7   | GYNECOLOGY_OBSTETRICS     | 5   |
| GENERAL_MEDICINE     | 9   | GENERAL_MEDICINE          | 45  |
| ORTHOPEDICS          | 10  | ORTHOPEDICS_TRAUMATOLOGY  | 17  |
| ENT                  | 11  | OTORHINOLARYNGOLOGY       | 11  |
| PULMONOLOGY          | 12  | PULMONOLOGY               | 14  |
| NEUROLOGY            | 21  | NEUROLOGY                 | 8   |
| UROLOGY              | 22  | UROLOGY                   | 9   |
| OPHTHALMOLOGY        | 23  | OPHTHALMOLOGY             | 6   |
| DERMATOLOGY          | 24  | DERMATOVENEROLOGY         | 7   |
| PEDIATRICS           | 25  | PEDIATRICS                | 4   |
| ENDOCRINOLOGY        | 26  | ENDOCRINOLOGY             | 12  |
| ALLERGOLOGY          | 27  | ALLERGOLOGY               | 79  |
| DENTISTRY            | 20  | DENTISTRY                 | 78  |
| ORTHODONTICS         | 34  | ORTHODONTIST              | 93  |
| PEDIATRIC_DENTISTRY  | 35  | PEDIATRIC_DENTISTRY       | 87  |
| PLASTIC_SURGERY      | 18  | PLASTIC_SURGERY           | 18  |
| GENERAL_SURGERY      | 17  | GENERAL_SURGERY           | 3   |
| PHYSIOTHERAPY        | 5   | PHYSICAL_MEDICINE         | 42  |
| OPHTHALMIC_SURGERY   | 36  | OPHTHALMIC_SURGERY        | 81  |
| PROCTOLOGY           | 33  | PROCTOLOGY                | 36  |
| ABDOMINAL_SURGERY    | 32  | GASTROINTESTINAL_SURGERY  | 90  |
| VASCULAR_SURGERY     | 22  | VASCULAR_SURGERY          | 34  |

**Пример:** все услуги с категорией DENTISTRY (20) → привязать к специальности DENTISTRY (78)

#### Мульти-категории (добавлять во все подходящие!)

| Услуга                         | Категории                                        |
| ------------------------------ | ------------------------------------------------ |
| Ринопластика, отопластика      | PLASTIC_SURGERY + ENT                            |
| Блефаропластика, птоз          | PLASTIC_SURGERY + OPHTHALMOLOGY                  |
| Ботокс, филлеры, дермабразия   | PLASTIC_SURGERY + DERMATOLOGY                    |
| Биопсии любые                  | основная + LABORATORY_SERVICES                   |
| Инъекции, инфузии, IV терапия  | основная + INJECTIONS_INFUSIONS                  |
| Перевязки, раны, снятие швов   | основная + WOUND_CARE                            |
| Лапароскопические операции     | специализированная + GENERAL_SURGERY             |
| Вагинопластика, гименопластика | PLASTIC_SURGERY + GYNECOLOGY                     |
| Урологические пластики         | PLASTIC_SURGERY + UROLOGY                        |
| Эпидуральные инъекции          | PAIN_THERAPY + ORTHOPEDICS                       |
| Забор крови, экспресс-тесты    | LABORATORY_SERVICES + INJECTIONS_INFUSIONS       |
| Детские стомат. услуги         | PEDIATRIC_DENTISTRY (не DENTISTRY + PEDIATRICS!) |
| Ортодонтические услуги         | ORTHODONTICS (не DENTISTRY!)                     |
| Брекеты, ретейнеры, трейнеры   | ORTHODONTICS                                     |

---

## PART 1.6: Личные услуги врачей (clinic_medical_service_doctors)

Когда у разных врачей **разные цены** на одну услугу — используем `clinic_medical_service_doctors`:

```sql
-- Структура таблицы
clinic_medical_service_doctors (
    clinic_medical_service_id,  -- ID из clinic_medical_services
    doctor_id,
    price,
    price_min,
    price_max
)
```

### Сценарий: разные цены у врачей

```sql
-- 1. Услуга клиники с диапазоном цен (min-max от всех врачей)
SET @cms_id = (SELECT id FROM clinic_medical_services
    WHERE clinic_id = @clinic_id
    AND medical_service_id = (SELECT id FROM medical_services WHERE name_en = 'Urologist Examination'));

-- 2. Личная цена врача
INSERT IGNORE INTO clinic_medical_service_doctors (clinic_medical_service_id, doctor_id, price, price_min, price_max)
VALUES (@cms_id, @doctor_id, 40, NULL, NULL);
```

### Определение цены клиники при разных ценах врачей

| Цены врачей   | clinic_medical_services.price | clinic_medical_services.price_max |
| ------------- | ----------------------------- | --------------------------------- |
| 40€, 60€      | 40 (min)                      | 60 (max)                          |
| 50€, 50€      | 50 (фикс.)                    | NULL                              |
| 40€, 50€, 60€ | 40 (min)                      | 60 (max)                          |

---

## PART 1.7: Сценарий "Только услуги" (врачи уже добавлены)

Когда пользователь говорит "врачи уже добавлены, их не трогаем" — создаём упрощённый SQL:

```sql
-- Insert services for clinic ID = 68 (doctors already added)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-68-{category}.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @clinic_id = 68;

-- PART 1: INSERT NEW MEDICAL SERVICES
-- PART 2: CATEGORY RELATIONS
-- PART 3: SPECIALTY RELATIONS
-- PART 4: ADD SERVICES TO CLINIC (clinic_medical_services)
-- VERIFICATION
```

> ⚠️ **Не добавляем**: INSERT INTO doctors, doctor_specialties, doctor_languages, doctor_clinics, clinic_medical_service_doctors

---

## PART 2: Лабораторные анализы

### 2.1 Новые анализы — все 6 языков

```sql
INSERT INTO lab_tests (name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Complete Blood Count', 'KKS', 'ККС', 'Общий анализ крови', 'Blutbild', 'Tam Kan Sayımı'),
('C-Reactive Protein', 'CRP', 'ЦРП', 'С-реактивный белок', 'CRP', 'CRP')
ON DUPLICATE KEY UPDATE name_en = name_en;
```

### 2.2 Переменные

```sql
SET @clinic_id = {ID};
SET @cat_hematology = 1;
SET @cat_inflammatory_markers = 7;
SET @cat_profiles_panels = 24;
-- ... другие категории
```

### 2.3 Цены — INSERT IGNORE

⚠️ **У анализов цена обычно фиксированная** — `price_max` используется редко (только для диапазонов).

```sql
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code)
SELECT @clinic_id, id, price, NULL, NULL FROM (
    SELECT id, 10.00 as price FROM lab_tests WHERE name_en = 'Complete Blood Count'
    UNION ALL SELECT id, 15.00 FROM lab_tests WHERE name_en = 'C-Reactive Protein'
    UNION ALL SELECT id, 20.00 FROM lab_tests WHERE name_en = 'COVID-19 Antigen Test'
) AS lab_test_prices;
```

> **Поле `code`** — внутренний код анализа в клинике (если есть). Обычно NULL при импорте.

### 2.4 Привязка к категориям — INSERT IGNORE

```sql
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id)
SELECT id, @cat_hematology FROM lab_tests WHERE name_en IN (
    'Complete Blood Count',
    'Hemoglobin'
);

INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id)
SELECT id, @cat_inflammatory_markers FROM lab_tests WHERE name_en IN (
    'C-Reactive Protein',
    'ESR'
);
```

#### Мульти-категории для анализов

Комбинированные тесты привязывать ко всем составляющим категориям:

| Анализ      | Категории                                                   |
| ----------- | ----------------------------------------------------------- |
| KKS + CRP   | HEMATOLOGY + INFLAMMATORY_MARKERS + PROFILES_PANELS         |
| Lipid Panel | BIOCHEMISTRY + PROFILES_PANELS                              |
| Liver Panel | BIOCHEMISTRY + PROFILES_PANELS                              |
| TORCH Panel | INFECTIOUS_DISEASES + PREGNANCY_FERTILITY + PROFILES_PANELS |

### 2.5 Синонимы анализов — INSERT IGNORE

Синонимы нужны для поиска: аббревиатуры, альтернативные названия, сокращения на разных языках.

```sql
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
SELECT id, 'KKS', 'sr' FROM lab_tests WHERE name_en = 'Complete Blood Count'
UNION ALL SELECT id, 'ККС', 'sr' FROM lab_tests WHERE name_en = 'Complete Blood Count'
UNION ALL SELECT id, 'CBC', 'en' FROM lab_tests WHERE name_en = 'Complete Blood Count'
UNION ALL SELECT id, 'ОАК', 'ru' FROM lab_tests WHERE name_en = 'Complete Blood Count'
UNION ALL SELECT id, 'Kompletna krvna slika', 'sr' FROM lab_tests WHERE name_en = 'Complete Blood Count';
```

#### Когда добавлять синонимы:

| Ситуация                   | Примеры                                             |
| -------------------------- | --------------------------------------------------- |
| Аббревиатуры               | KKS, CBC, CRP, TSH, HbA1c, PSA, LBC, LEEP           |
| Сокращения                 | ОАК (общий анализ крови), БАК (биохимический)       |
| Альтернативные названия    | "Krvna slika" = "Complete Blood Count"              |
| Бренды/торговые названия   | "ThinPrep" = "Liquid-Based Cytology"                |
| Локальные названия клиники | Если клиника использует своё название теста         |
| Разные языки               | sr, en, ru, de, tr                                  |
| Менее частотные термины    | Если основное название заменено на более популярное |

**Примеры синонимов для новых тестов:**

```sql
-- Liquid-Based Cytology (основное название)
UNION ALL SELECT id, 'LBC', 'en' FROM lab_tests WHERE name_en = 'Liquid-Based Cytology'
UNION ALL SELECT id, 'ThinPrep', 'en' FROM lab_tests WHERE name_en = 'Liquid-Based Cytology'
UNION ALL SELECT id, 'Tečna PAPA', 'sr' FROM lab_tests WHERE name_en = 'Liquid-Based Cytology'

-- LEEP Cervical Conization (основное название)
UNION ALL SELECT id, 'LLETZ', 'en' FROM lab_tests WHERE name_en = 'LEEP Cervical Conization'
UNION ALL SELECT id, 'Loop ekscizija', 'sr' FROM lab_tests WHERE name_en = 'LEEP Cervical Conization'

-- NIPT тесты (Panorama — бренд)
UNION ALL SELECT id, 'Panorama Basic', 'en' FROM lab_tests WHERE name_en = 'NIPT Panorama Basic'
```

#### Коды языков для синонимов:

- `sr` — сербский (латиница и кириллица)
- `en` — английский
- `ru` — русский
- `de` — немецкий
- `tr` — турецкий

---

## Миграция между таблицами

Если нужно перенести запись из `lab_tests` в `medical_services` (или наоборот):

```sql
-- 1. Скопировать в целевую таблицу
INSERT INTO medical_services (name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
SELECT lt.name_en, lt.name_sr, lt.name_sr_cyrl, lt.name_ru, lt.name_de, lt.name_tr
FROM lab_tests lt
WHERE lt.name_en IN ('Blood Draw', 'Rapid Blood Glucose Test')
ON DUPLICATE KEY UPDATE name_en = VALUES(name_en);

-- 2. Перенести все цены
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT clt.clinic_id, ms.id, clt.price, NULL, NULL
FROM clinic_lab_tests clt
JOIN lab_tests lt ON clt.lab_test_id = lt.id
JOIN medical_services ms ON ms.name_en = lt.name_en
WHERE lt.name_en IN ('Blood Draw', 'Rapid Blood Glucose Test');

-- 3. Удалить из исходных таблиц
DELETE clt FROM clinic_lab_tests clt
JOIN lab_tests lt ON clt.lab_test_id = lt.id
WHERE lt.name_en IN ('Blood Draw', 'Rapid Blood Glucose Test');

DELETE ltcr FROM lab_test_categories_relations ltcr
JOIN lab_tests lt ON ltcr.lab_test_id = lt.id
WHERE lt.name_en IN ('Blood Draw', 'Rapid Blood Glucose Test');

DELETE FROM lab_tests WHERE name_en IN ('Blood Draw', 'Rapid Blood Glucose Test');
```

---

## Именные услуги

Услуги с именами врачей (напр. "Pregled dr Jovanovića") **выводить отдельно** для ручного добавления.

---

## Команда запуска

```bash
mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-{ID}-services.sql
```

---

## Формат ответа

1. **Сводка**:
   - Услуги: X существующих / Y новых
   - Анализы: X существующих / Y новых
2. **SQL файл**: полный скрипт (услуги + анализы)
3. **Команда запуска**
4. **Именные услуги**: список для ручного добавления (если есть)

---

## Полезные SQL запросы

### Услуги без привязки к клинике

```sql
SELECT ms.id, ms.name_en, ms.name_sr
FROM medical_services ms
LEFT JOIN clinic_medical_services cms ON ms.id = cms.medical_service_id
WHERE cms.id IS NULL
ORDER BY ms.name_en;
```

### Анализы без привязки к клинике

```sql
SELECT lt.id, lt.name_en, lt.name_sr
FROM lab_tests lt
LEFT JOIN clinic_lab_tests clt ON lt.id = clt.lab_test_id
WHERE clt.id IS NULL
ORDER BY lt.name_en;
```

### Найти возможные дубликаты

```sql
-- В услугах
SELECT name_en, COUNT(*) as cnt FROM medical_services GROUP BY name_en HAVING cnt > 1;

-- В анализах
SELECT name_en, COUNT(*) as cnt FROM lab_tests GROUP BY name_en HAVING cnt > 1;
```

---

## Справочники

### Specialties (специальности врачей)

Основные специальности, используемые при привязке услуг:

```
1  = CARDIOLOGY
2  = INTERNAL_MEDICINE
3  = GENERAL_SURGERY
4  = PEDIATRICS
5  = GYNECOLOGY_OBSTETRICS
6  = OPHTHALMOLOGY
7  = DERMATOVENEROLOGY
8  = NEUROLOGY
9  = UROLOGY
10 = RADIOLOGY
11 = OTORHINOLARYNGOLOGY (ENT)
12 = ENDOCRINOLOGY
13 = GASTROENTEROLOGY
14 = PULMONOLOGY
15 = HEMATOLOGY
16 = RHEUMATOLOGY
17 = ORTHOPEDICS_TRAUMATOLOGY
18 = PLASTIC_SURGERY
19 = ANESTHESIOLOGY
20 = FAMILY_MEDICINE
21 = PSYCHIATRY
22 = PSYCHOLOGY
34 = VASCULAR_SURGERY
36 = PROCTOLOGY
42 = PHYSICAL_MEDICINE
44 = AESTHETIC_MEDICINE
45 = GENERAL_MEDICINE
46 = NEPHROLOGY
47 = ONCOLOGY
48 = EMERGENCY_MEDICINE
52 = INFECTIOUS_DISEASES
74 = ORAL_SURGERY
75 = NEUROSURGERY
78 = DENTISTRY
79 = ALLERGOLOGY
81 = OPHTHALMIC_SURGERY
87 = PEDIATRIC_DENTISTRY
91 = MAXILLOFACIAL_SURGERY
92 = CARDIAC_SURGERY
93 = ORTHODONTIST
```

> Полный список: `enums/specialty.ts`

### Medical Service Categories

```
1  = MRI
2  = MSCT
3  = XRAY
4  = ULTRASOUND
5  = PHYSIOTHERAPY
6  = GASTROENTEROLOGY
7  = GYNECOLOGY
8  = CARDIOLOGY
9  = GENERAL_MEDICINE
10 = ORTHOPEDICS
11 = ENT
12 = PULMONOLOGY
13 = MEDICAL_TRANSPORT
14 = SURGICAL_EXAMINATION
15 = AMBULATORY_SURGERY
16 = GYNECOLOGICAL_SURGERY
17 = GENERAL_SURGERY
18 = PLASTIC_SURGERY
19 = PAIN_THERAPY
20 = DENTISTRY
21 = NEUROLOGY
22 = UROLOGY
23 = OPHTHALMOLOGY
24 = DERMATOLOGY
25 = PEDIATRICS
26 = ENDOCRINOLOGY
27 = ALLERGOLOGY
28 = LABORATORY_SERVICES
29 = INJECTIONS_INFUSIONS
30 = HOME_VISITS
31 = WOUND_CARE
32 = ABDOMINAL_SURGERY
33 = PROCTOLOGY
34 = ORTHODONTICS
35 = PEDIATRIC_DENTISTRY
36 = OPHTHALMIC_SURGERY
```

### Lab Test Categories

```
1  = HEMATOLOGY
2  = COAGULATION
3  = BIOCHEMISTRY
4  = ELECTROLYTES
5  = HORMONES
6  = TUMOR_MARKERS
7  = INFLAMMATORY_MARKERS
8  = URINALYSIS
9  = STOOL_TESTS
10 = INFECTIOUS_DISEASES
11 = DRUG_TESTING
12 = IMMUNOLOGY
13 = ALLERGY_TESTS
14 = AUTOIMMUNE_ANTIBODIES
15 = VITAMINS
16 = TRACE_ELEMENTS_HEAVY_METALS
17 = THERAPEUTIC_DRUG_MONITORING
18 = CARDIAC_MARKERS
19 = PREGNANCY_FERTILITY
20 = GENETICS
21 = MICROBIOLOGY
22 = PCR_TESTS
23 = PROTEIN_ELECTROPHORESIS
24 = PROFILES_PANELS
```
