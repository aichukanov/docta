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
-- PART 1: MEDICAL SERVICES
-- ═══════════════════════════════════════════════════════════════

-- Step 1.1: Insert new medical services
-- Step 1.2: Set variables
-- Step 1.3: Insert clinic_medical_services (prices) — INSERT IGNORE
-- Step 1.4: Insert category relations — INSERT IGNORE
-- Step 1.5: Insert specialty relations (optional) — INSERT IGNORE

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

## PART 1: Медицинские услуги

### 1.1 Новые услуги — все 6 языков

```sql
INSERT INTO medical_services (name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('English Name', 'Serbian Latin', 'Српски ћирилица', 'Русский', 'Deutsch', 'Türkçe'),
('Another Service', 'Druga usluga', 'Друга услуга', 'Другая услуга', 'Andere Dienstleistung', 'Başka Hizmet')
ON DUPLICATE KEY UPDATE name_en = name_en;
```

### 1.2 Переменные

```sql
SET @clinic_id = {ID};
SET @cat_general_medicine = 1;
SET @cat_cardiology = 2;
-- ... другие категории по необходимости
```

### 1.3 Цены для клиники — INSERT IGNORE

| Ситуация               | price | price_min | price_max |
| ---------------------- | ----- | --------- | --------- |
| `100€` (фикс.)         | 100   | NULL      | NULL      |
| `od 100€` (от)         | NULL  | 100       | NULL      |
| `100-120€` (диапазон)  | 100   | NULL      | 120       |
| `na upit` (по запросу) | NULL  | NULL      | NULL      |

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

### 1.5 Привязка к специальностям (опционально) — INSERT IGNORE

Связь услуги со специальностями врачей для фильтрации:

```sql
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, @spec_cardiology FROM medical_services WHERE name_en IN (
    'Cardiologist Examination',
    'ECG',
    'Echocardiography'
);
```

#### Мульти-категории (добавлять во все подходящие!)

| Услуга                         | Категории                                  |
| ------------------------------ | ------------------------------------------ |
| Ринопластика, отопластика      | PLASTIC_SURGERY + ENT                      |
| Блефаропластика, птоз          | PLASTIC_SURGERY + OPHTHALMOLOGY            |
| Ботокс, филлеры, дермабразия   | PLASTIC_SURGERY + DERMATOLOGY              |
| Биопсии любые                  | основная + LABORATORY_SERVICES             |
| Инъекции, инфузии, IV терапия  | основная + INJECTIONS_INFUSIONS            |
| Перевязки, раны, снятие швов   | основная + WOUND_CARE                      |
| Лапароскопические операции     | специализированная + GENERAL_SURGERY       |
| Вагинопластика, гименопластика | PLASTIC_SURGERY + GYNECOLOGY               |
| Урологические пластики         | PLASTIC_SURGERY + UROLOGY                  |
| Эпидуральные инъекции          | PAIN_THERAPY + ORTHOPEDICS                 |
| Забор крови, экспресс-тесты    | LABORATORY_SERVICES + INJECTIONS_INFUSIONS |

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

| Ситуация                   | Примеры                                       |
| -------------------------- | --------------------------------------------- |
| Аббревиатуры               | KKS, CBC, CRP, TSH, HbA1c, PSA                |
| Сокращения                 | ОАК (общий анализ крови), БАК (биохимический) |
| Альтернативные названия    | "Krvna slika" = "Complete Blood Count"        |
| Локальные названия клиники | Если клиника использует своё название теста   |
| Разные языки               | sr, en, ru, de, tr                            |

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
42 = PHYSICAL_MEDICINE
44 = AESTHETIC_MEDICINE
45 = GENERAL_MEDICINE
46 = NEPHROLOGY
47 = ONCOLOGY
48 = EMERGENCY_MEDICINE
52 = INFECTIOUS_DISEASES
75 = NEUROSURGERY
78 = DENTISTRY
79 = ALLERGOLOGY
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
33 = OPHTHALMIC_SURGERY
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
