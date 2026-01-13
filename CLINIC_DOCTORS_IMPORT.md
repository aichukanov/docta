# Промпт для добавления врачей клиники

## Задача

Добавить врачей в базу данных и привязать к клиникам `clinic_id = {ID1}, {ID2}, ...`.

## Входные данные

### 1. Специальности врачей

- **Enum**: `enums/specialty.ts`
- **Переводы**: `i18n/specialty.ts`

### 2. Языки

- **Enum**: `enums/language.ts` — `LanguageId`

### 3. Список врачей клиники

Любой формат: HTML, текст, таблица. Обычно содержит:

- Имя врача (часто с титулом Dr, Prof)
- Специальность
- Фото (URL)

---

## Структура базы данных

```
doctors (id, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url,
         phone, email, website, facebook, instagram, telegram, whatsapp, viber)

doctor_specialties (doctor_id, specialty_id)  -- специальности врача
doctor_clinics (doctor_id, clinic_id, position)  -- привязка к клиникам
doctor_languages (doctor_id, language_id)  -- языки консультаций
```

---

## Правила создания SQL

### Структура файла

```sql
-- Insert doctors for clinics ID = {ID1}, {ID2}, ...
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/scripts/add-{clinic-name}-doctors.sql

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- ═══════════════════════════════════════════════════════════════
-- {SPECIALTY_NAME} (specialty_id = {ID})
-- ═══════════════════════════════════════════════════════════════

-- Для каждого врача:
-- 1. Найти существующего или создать нового
-- 2. Добавить специальность (INSERT IGNORE)
-- 3. Добавить язык (INSERT IGNORE)
-- 4. Добавить связи с клиниками (INSERT IGNORE)
```

---

## Шаблон для каждого врача

### Логика: найти или создать

```sql
-- Поиск врача по имени (Имя Фамилия)
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Ime Prezime' LIMIT 1);
-- Если не найден — поиск по перевёрнутому имени (Фамилия Имя)
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Prezime Ime' LIMIT 1));
-- Если всё равно не найден — создаём нового
INSERT INTO doctors (name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'Ime Prezime', 'Име Презиме', '', '', 'Dr', 'https://example.com/photo.png', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, {SPECIALTY_ID});
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id) VALUES (@doctor_id, 70), (@doctor_id, 71), (@doctor_id, 72);
```

### Логика работы

1. **Поиск по имени**: ищем врача по `name_sr` (Имя Фамилия)
2. **Поиск по перевёрнутому имени**: если не найден — ищем по "Фамилия Имя"
3. **Создание**: если не найден — `INSERT ... SELECT ... FROM dual WHERE @doctor_id IS NULL`
4. **ID**: `COALESCE(@doctor_id, LAST_INSERT_ID())` — существующий или новый
5. **Связи**: `INSERT IGNORE` предотвращает дубликаты
6. **Язык**: сербский (`language_id = 1`) добавляется **всем** врачам, остальные — только если указано

> ⚠️ **Важно**: в БД врачи могут быть записаны как "Ime Prezime" или "Prezime Ime". Всегда проверять оба варианта!

---

## Транслитерация сербского

Сербский язык имеет взаимно-однозначное соответствие между латиницей и кириллицей.

### Диграфы (обрабатывать первыми!)

| Латиница | Кириллица |
| -------- | --------- |
| Lj / lj  | Љ / љ     |
| Nj / nj  | Њ / њ     |
| Dž / dž  | Џ / џ     |

### Специальные буквы

| Латиница | Кириллица |
| -------- | --------- |
| Đ / đ    | Ђ / ђ     |
| Ž / ž    | Ж / ж     |
| Č / č    | Ч / ч     |
| Ć / ć    | Ћ / ћ     |
| Š / š    | Ш / ш     |

### Остальные буквы

| Lat | Cyr | Lat | Cyr | Lat | Cyr | Lat | Cyr |
| --- | --- | --- | --- | --- | --- | --- | --- |
| A   | А   | B   | Б   | V   | В   | G   | Г   |
| D   | Д   | E   | Е   | Z   | З   | I   | И   |
| J   | Ј   | K   | К   | L   | Л   | M   | М   |
| N   | Н   | O   | О   | P   | П   | R   | Р   |
| S   | С   | T   | Т   | U   | У   | F   | Ф   |
| H   | Х   | C   | Ц   |     |     |     |     |

### Примеры

| Латиница                  | Кириллица                |
| ------------------------- | ------------------------ |
| Đorđe Radak               | Ђорђе Радак              |
| Marjana Đorđević          | Марјана Ђорђевић         |
| Biljana Georgievski Brkić | Биљана Георгиевски Бркић |
| Nataša Prvulović Bunović  | Наташа Првуловић Буновић |
| Draško Vuković            | Драшко Вуковић           |
| Vladan Ćipović            | Владан Ћиповић           |

> **Функция в коде**: `common/serbian-transliteration.ts` — `toCyrillic()`

---

## Личные услуги врачей

Когда у врача есть **персональные цены** на услуги клиники — используем `clinic_medical_service_doctors`:

```sql
-- После добавления врача и услуги клиники
SET @cms_id = (SELECT id FROM clinic_medical_services
    WHERE clinic_id = @clinic_id
    AND medical_service_id = (SELECT id FROM medical_services WHERE name_en = 'Urologist Examination'));

INSERT IGNORE INTO clinic_medical_service_doctors (clinic_medical_service_id, doctor_id, price, price_min, price_max)
VALUES (@cms_id, @doctor_id, 40, NULL, NULL);
```

### Цены при нескольких врачах

| Цены врачей       | clinic_medical_services | clinic_medical_service_doctors |
| ----------------- | ----------------------- | ------------------------------ |
| Dr A: 40€         | price=40                | Dr A: price=40                 |
| Dr A: 40€, B: 60€ | price=40, price_max=60  | Dr A: 40, Dr B: 60             |

> 💡 Цена клиники `clinic_medical_services.price` = минимальная среди врачей, `price_max` = максимальная

---

## Сценарий: врачи без личных услуг

Если врач просто работает в клинике без персональных цен:

```sql
-- Только привязка к клинике, без clinic_medical_service_doctors
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id) VALUES (@doctor_id, 68);
```

---

## Команда запуска

```bash
mysql -u root -p --default-character-set=utf8mb4 docta_me < server/scripts/add-{clinic-name}-doctors.sql
```

⚠️ **Важно**: флаг `--default-character-set=utf8mb4` обязателен для корректной записи кириллицы!

---

## Формат ответа

1. **Сводка**:
   - Врачи: X по специальности Y
   - Клиники: ID1, ID2, ...
2. **SQL файл**: полный скрипт
3. **Команда запуска**
4. **Замечания**: врачи без фото, неоднозначные специальности

---

## Справочники

### Специальности врачей (основные)

```
1  = CARDIOLOGY (Кардиология)
2  = INTERNAL_MEDICINE (Интерна медицина)
3  = GENERAL_SURGERY (Општа хирургија)
4  = PEDIATRICS (Педијатрија)
5  = GYNECOLOGY_OBSTETRICS (Гинекологија)
6  = OPHTHALMOLOGY (Офталмологија)
7  = DERMATOVENEROLOGY (Дерматологија)
8  = NEUROLOGY (Неурологија)
9  = UROLOGY (Урологија)
10 = RADIOLOGY (Радиологија)
11 = OTORHINOLARYNGOLOGY (ОРЛ)
12 = ENDOCRINOLOGY (Ендокринологија)
13 = GASTROENTEROLOGY (Гастроентерологија)
14 = PULMONOLOGY (Пулмологија)
15 = HEMATOLOGY (Хематологија)
16 = RHEUMATOLOGY (Реуматологија)
17 = ORTHOPEDICS_TRAUMATOLOGY (Ортопедија)
18 = PLASTIC_SURGERY (Пластична хирургија)
19 = ANESTHESIOLOGY (Анестезиологија)
20 = FAMILY_MEDICINE (Породична медицина)
21 = PSYCHIATRY (Психијатрија)
22 = PSYCHOLOGY (Психологија)
34 = VASCULAR_SURGERY (Васкуларна хирургија)
36 = PROCTOLOGY (Проктологија)
42 = PHYSICAL_MEDICINE (Физикална медицина)
44 = AESTHETIC_MEDICINE (Естетска медицина)
45 = GENERAL_MEDICINE (Општа медицина)
46 = NEPHROLOGY (Нефрологија)
47 = ONCOLOGY (Онкологија)
48 = EMERGENCY_MEDICINE (Ургентна медицина)
51 = PSYCHOTHERAPY (Психотерапија)
52 = INFECTIOUS_DISEASES (Инфективне болести)
74 = ORAL_SURGERY (Орална хирургија)
75 = NEUROSURGERY (Неурохирургија)
76 = MAMMOLOGY (Мамологија)
77 = ONCOLOGIC_SURGERY (Онколошка хирургија)
78 = DENTISTRY (Стоматологија)
79 = ALLERGOLOGY (Алергологија)
80 = IMMUNOLOGY (Имунологија)
81 = OPHTHALMIC_SURGERY (Офталмолошка хирургија)
82 = OSTEOPATHY (Остеопатија)
87 = PEDIATRIC_DENTISTRY (Дечја стоматологија)
88 = NUCLEAR_MEDICINE (Нуклеарна медицина)
89 = GENETICS (Генетика)
90 = GASTROINTESTINAL_SURGERY (Абдоминална хирургија / Гастроинтестинална хирургија)
91 = MAXILLOFACIAL_SURGERY (Максилофацијална хирургија)
92 = CARDIAC_SURGERY (Кардиохирургија)
93 = ORTHODONTIST (Ортодонција)
```

> Полный список: `enums/specialty.ts`

### Соответствие специальностей (сербский → ID)

| Сербское название     | ID  | Английское название      |
| --------------------- | --- | ------------------------ |
| Radiologija           | 10  | RADIOLOGY                |
| Ortopedija            | 17  | ORTHOPEDICS_TRAUMATOLOGY |
| Neurologija           | 8   | NEUROLOGY                |
| Hirurgija             | 3   | GENERAL_SURGERY          |
| Kardiologija          | 1   | CARDIOLOGY               |
| Ginekologija          | 5   | GYNECOLOGY_OBSTETRICS    |
| Urologija             | 9   | UROLOGY                  |
| Dermatologija         | 7   | DERMATOVENEROLOGY        |
| Pedijatrija           | 4   | PEDIATRICS               |
| Oftalmologija         | 6   | OPHTHALMOLOGY            |
| Endokrinologija       | 12  | ENDOCRINOLOGY            |
| Gastroenterologija    | 13  | GASTROENTEROLOGY         |
| Pulmologija           | 14  | PULMONOLOGY              |
| Psihijatrija          | 21  | PSYCHIATRY               |
| Stomatologija         | 78  | DENTISTRY                |
| Anesteziologija       | 19  | ANESTHESIOLOGY           |
| Interna medicina      | 2   | INTERNAL_MEDICINE        |
| Fizikalna medicina    | 42  | PHYSICAL_MEDICINE        |
| Vaskularna hirurgija  | 34  | VASCULAR_SURGERY         |
| Plasticna hirurgija   | 18  | PLASTIC_SURGERY          |
| ORL                   | 11  | OTORHINOLARYNGOLOGY      |
| Proktologija          | 36  | PROCTOLOGY               |
| Abdominalna hirurgija | 90  | GASTROINTESTINAL_SURGERY |
| Neurohirurgija        | 75  | NEUROSURGERY             |
| Hematologija          | 15  | HEMATOLOGY               |
| Estetska medicina     | 44  | AESTHETIC_MEDICINE       |

### Языки врачей

```
1 = SR (Сербский)      ← добавлять ВСЕМ врачам по умолчанию
2 = RU (Русский)
3 = EN (Английский)
6 = DE (Немецкий)
7 = TR (Турецкий)
8 = IT (Итальянский)
9 = FR (Французский)
```

> Полный список: `enums/language.ts` — `LanguageId`

⚠️ **Правило**: Сербский язык (`language_id = 1`) добавляется **всем врачам** автоматически. Остальные языки — только если явно указано в источнике данных.

---

## Полезные SQL запросы

### Врачи клиники

```sql
SELECT d.id, d.name_sr, d.name_sr_cyrl, s.name as specialty
FROM doctors d
JOIN doctor_clinics dc ON d.id = dc.doctor_id
JOIN doctor_specialties ds ON d.id = ds.doctor_id
JOIN specialties s ON ds.specialty_id = s.id
WHERE dc.clinic_id = 70
ORDER BY s.name, d.name_sr;
```

### Врачи без привязки к клинике

```sql
SELECT d.id, d.name_sr, d.name_sr_cyrl
FROM doctors d
LEFT JOIN doctor_clinics dc ON d.id = dc.doctor_id
WHERE dc.id IS NULL
ORDER BY d.name_sr;
```

### Проверить кодировку

```sql
SELECT id, name_sr, name_sr_cyrl, HEX(name_sr_cyrl) as hex_cyrl
FROM doctors
WHERE id > 100
ORDER BY id DESC
LIMIT 10;
```

### Найти дубликаты

```sql
SELECT name_sr, COUNT(*) as cnt
FROM doctors
GROUP BY name_sr
HAVING cnt > 1;
```

### Врачи со сломанной кодировкой

```sql
-- Найти записи с некорректными символами
SELECT id, name_sr, name_sr_cyrl
FROM doctors
WHERE name_sr_cyrl LIKE '%?%'
   OR name_sr_cyrl LIKE '%─%'
   OR name_sr LIKE '%─%';
```
