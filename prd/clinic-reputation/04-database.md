# 04. База данных

[← index](index.md)

Одна миграция: `server/sql/migrations/059-clinic-reputation.sql`.
Номер сверить перед созданием файла: на 2026-10-19 последняя — 057, **058 зарезервирована**
PRD doctor-titles. Шапка и COLLATE — по `docs/rules/SQL_COLLATIONS.md` (вся база
`utf8mb4_unicode_ci` с миграции 044, но явный COLLATE в новых DDL обязателен).

## 1. Отзывы: закрепление

```sql
ALTER TABLE reviews
  ADD COLUMN is_pinned TINYINT(1) NOT NULL DEFAULT 0 AFTER is_verified,
  ADD COLUMN pinned_at DATETIME NULL AFTER is_pinned;
```

Индекс не нужен: закреплённых единицы, выборка и так идёт по `clinic_id`.

## 2. Журнал модерации: новые действия

```sql
ALTER TABLE review_moderation_logs
  MODIFY action ENUM(
    'approved', 'rejected',
    'verification_uploaded', 'verification_approved', 'verification_rejected',
    'pinned', 'unpinned',
    'editorial_verified', 'editorial_unverified'
  ) NOT NULL;
```

Порядок существующих значений ENUM не менять (хранится по индексу).

## 3. Жалобы

```sql
CREATE TABLE clinic_complaints (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  clinic_id INT NOT NULL,
  complaint_type TINYINT UNSIGNED NOT NULL,          -- enums/clinic-complaint-type.ts
  status ENUM('confirmed', 'unconfirmed') NOT NULL DEFAULT 'unconfirmed',
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  review_id INT NULL,                                -- закреплённый отзыв-основание
  article_slug VARCHAR(128) NULL,                    -- статья-разбор
  incident_date DATE NULL,
  source_note TEXT NULL,                             -- ВНУТРЕННЕЕ: источник/документы, наружу не отдаётся
  clinic_response TEXT NULL,                         -- официальный ответ клиники (публичный)
  created_by INT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_clinic_complaint (clinic_id, complaint_type),
  KEY idx_complaints_active (is_active, status, clinic_id),
  CONSTRAINT fk_complaints_clinic FOREIGN KEY (clinic_id) REFERENCES clinics (id),
  CONSTRAINT fk_complaints_review FOREIGN KEY (review_id) REFERENCES reviews (id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
```

Решения:

- **Одна строка на пару (клиника, тип)** — формулировки стандартные, повторные обращения того же
  типа не плодят строк, а повышают статус `unconfirmed → confirmed` и дополняют `source_note`.
  Счётчик обращений не вводим (YAGNI; понадобится — добавим `reports_count`).
- `clinic_response` лежит на жалобе, а не на клинике: ответ обычно адресует конкретную претензию.
  Если клиника отвечает «на всё сразу» — положить один и тот же текст в релевантные строки или
  в самую тяжёлую.
- Типы колонок (`clinic_id INT`, `review_id INT`) сверить с дампом перед написанием DDL —
  FK не создастся при несовпадении типов/знаковости.
- `complaint_type` — tinyint-код; словарь и переводы живут на фронте
  (конвенция: маленькие статичные списки не кладём в БД).

## 3.1. `doctor_complaints` (миграция 060, итерация 5)

Зеркало `clinic_complaints` для врачей: те же колонки, те же решения, тот же
словарь типов. Отличия ровно два — FK на `doctors` вместо `clinics` и колонка
публичного ответа `doctor_response` вместо `clinic_response`.

Почему отдельная таблица, а не `entity_type` + `entity_id` в одной: при общей
таблице внешний ключ на сущность становится невозможен, и каскадное удаление
жалоб вместе с врачом или клиникой пришлось бы держать в коде. Таблицы
крошечные, дублирование DDL дешевле потери ссылочной целостности.
Разницу между ними прячет `server/common/reputation.ts` — весь код работает
через параметр `entity: 'clinic' | 'doctor'`, прямых упоминаний таблиц вне
этого модуля нет.

## 4. Прод/локалка

Применение — командами из навыка migration-commands, **сначала локально, потом прод, прод
применяет пользователь**. ID клиник и врачей на проде и локалке расходятся — в контентных INSERT'ах
(итерации 4 и 5) сущность только через `(SELECT id FROM ... WHERE slug = '...')`.
