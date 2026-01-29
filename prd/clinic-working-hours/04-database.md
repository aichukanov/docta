# 4. База данных

[← Назад к оглавлению](index.md)

---

## 4.1 Схема базы данных

### Новая таблица: clinic_working_hours

Хранит график работы для каждой клиники.

```sql
CREATE TABLE clinic_working_hours (
  id INT AUTO_INCREMENT PRIMARY KEY,
  clinic_id INT NOT NULL,

  -- График для каждого дня недели (JSON)
  -- Структура: { "type": "regular|24/7|closed|on_demand|not_specified", "intervals": [{"start": "HH:mm", "end": "HH:mm"}] }
  monday JSON NOT NULL,
  tuesday JSON NOT NULL,
  wednesday JSON NOT NULL,
  thursday JSON NOT NULL,
  friday JSON NOT NULL,
  saturday JSON NOT NULL,
  sunday JSON NOT NULL,

  -- Метаданные
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  -- Индексы
  UNIQUE KEY unique_clinic (clinic_id),

  -- Ограничения
  CONSTRAINT fk_working_hours_clinic FOREIGN KEY (clinic_id)
    REFERENCES clinics(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Пояснения:**

- **Один график на клинику** - UNIQUE constraint на `clinic_id`
- **JSON формат** - гибкое хранение разных типов графика
- **ON DELETE CASCADE** - удаление графика при удалении клиники
- **NOT NULL** - каждый день должен иметь значение (хотя бы `{"type": "not_specified"}`)

---

## 4.2 Структура JSON данных

### Примеры данных в JSON полях

**Обычный рабочий день (regular):**

```json
{
	"type": "regular",
	"intervals": [{ "start": "08:00", "end": "20:00" }]
}
```

**День с несколькими интервалами (перерыв на обед):**

```json
{
	"type": "regular",
	"intervals": [
		{ "start": "09:00", "end": "13:00" },
		{ "start": "15:00", "end": "19:00" }
	]
}
```

**Круглосуточная работа:**

```json
{
	"type": "24/7"
}
```

**Выходной день:**

```json
{
	"type": "closed"
}
```

**По требованию:**

```json
{
	"type": "on_demand"
}
```

**Не указано:**

```json
{
	"type": "not_specified"
}
```

---

## 4.3 Пример полной записи

```sql
INSERT INTO clinic_working_hours (
  clinic_id,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
) VALUES (
  123,
  '{"type": "regular", "intervals": [{"start": "08:00", "end": "20:00"}]}',
  '{"type": "regular", "intervals": [{"start": "08:00", "end": "20:00"}]}',
  '{"type": "regular", "intervals": [{"start": "08:00", "end": "20:00"}]}',
  '{"type": "regular", "intervals": [{"start": "08:00", "end": "20:00"}]}',
  '{"type": "regular", "intervals": [{"start": "08:00", "end": "20:00"}]}',
  '{"type": "regular", "intervals": [{"start": "09:00", "end": "15:00"}]}',
  '{"type": "closed"}'
);
```

---

## 4.4 Queries примеры

### Получение графика работы клиники

```sql
SELECT
  clinic_id,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
FROM clinic_working_hours
WHERE clinic_id = 123;
```

### Создание/обновление графика работы

**Использовать `REPLACE INTO` для упрощения логики:**

```sql
REPLACE INTO clinic_working_hours (
  clinic_id,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
) VALUES (
  ?,
  ?,
  ?,
  ?,
  ?,
  ?,
  ?,
  ?
);
```

**Или использовать `INSERT ... ON DUPLICATE KEY UPDATE`:**

```sql
INSERT INTO clinic_working_hours (
  clinic_id,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
ON DUPLICATE KEY UPDATE
  monday = VALUES(monday),
  tuesday = VALUES(tuesday),
  wednesday = VALUES(wednesday),
  thursday = VALUES(thursday),
  friday = VALUES(friday),
  saturday = VALUES(saturday),
  sunday = VALUES(sunday),
  updated_at = CURRENT_TIMESTAMP;
```

### Удаление графика работы

```sql
DELETE FROM clinic_working_hours
WHERE clinic_id = 123;
```

---

## 4.5 Миграция

### Миграция: Создание таблицы clinic_working_hours

**Файл:** `server/database/migrations/XXX_create_clinic_working_hours_table.sql`

```sql
-- Создание таблицы clinic_working_hours
CREATE TABLE clinic_working_hours (
  id INT AUTO_INCREMENT PRIMARY KEY,
  clinic_id INT NOT NULL,

  -- График для каждого дня недели (JSON)
  monday JSON NOT NULL,
  tuesday JSON NOT NULL,
  wednesday JSON NOT NULL,
  thursday JSON NOT NULL,
  friday JSON NOT NULL,
  saturday JSON NOT NULL,
  sunday JSON NOT NULL,

  -- Метаданные
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  -- Индексы
  UNIQUE KEY unique_clinic (clinic_id),

  -- Ограничения
  CONSTRAINT fk_working_hours_clinic FOREIGN KEY (clinic_id)
    REFERENCES clinics(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Миграция: Заполнение дефолтными данными (опционально)

Если нужно заполнить дефолтные данные для всех существующих клиник:

```sql
-- Заполнение дефолтными данными для всех клиник
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
SELECT
  id,
  '{"type": "not_specified"}',
  '{"type": "not_specified"}',
  '{"type": "not_specified"}',
  '{"type": "not_specified"}',
  '{"type": "not_specified"}',
  '{"type": "not_specified"}',
  '{"type": "not_specified"}'
FROM clinics
WHERE id NOT IN (SELECT clinic_id FROM clinic_working_hours);
```

---

## 4.6 Индексы и производительность

### Ключевые индексы

- **unique_clinic (clinic_id)** - уникальный индекс для быстрого поиска по clinic_id

### Оценка размера данных

**Предположения:**

- 10,000 клиник
- JSON данные для одного дня: ~100 bytes (в среднем)
- 7 дней × 100 bytes = ~700 bytes на клинику
- Метаданные (id, created_at, updated_at): ~50 bytes

**Оценка:**

- 10,000 клиник × ~750 bytes = ~7.5 MB

**Итого:** ~7.5 MB для 10,000 клиник (очень компактно)

### Производительность запросов

- **Получение графика:** O(1) - индекс по clinic_id
- **Обновление графика:** O(1) - индекс по clinic_id
- **Удаление графика:** O(1) - индекс по clinic_id

**Ожидаемое время запросов:**

- SELECT: < 1ms
- INSERT/UPDATE: < 5ms
- DELETE: < 5ms

---

## 4.7 Альтернативные варианты хранения (отклонены)

### Вариант 1: Нормализованная структура (отклонен)

**Идея:** Создать отдельную таблицу `clinic_working_intervals` с записями для каждого интервала.

```sql
-- НЕ ИСПОЛЬЗУЕТСЯ
CREATE TABLE clinic_working_intervals (
  id INT PRIMARY KEY,
  clinic_id INT,
  day_of_week TINYINT,  -- 0-6
  interval_order TINYINT,
  start_time TIME,
  end_time TIME
);
```

**Причины отклонения:**

- Сложнее запросы (нужно JOIN и GROUP BY)
- Больше строк в таблице (3-7× больше)
- Сложнее обработка специальных типов (24/7, closed, on_demand)
- Нет преимуществ в производительности для наших запросов

### Вариант 2: Один JSON объект (отклонен)

**Идея:** Хранить весь график в одном JSON поле.

```sql
-- НЕ ИСПОЛЬЗУЕТСЯ
CREATE TABLE clinic_working_hours (
  id INT PRIMARY KEY,
  clinic_id INT,
  schedule JSON  -- { "monday": {...}, "tuesday": {...}, ... }
);
```

**Причины отклонения:**

- Невозможно использовать JSON функции MySQL для отдельных дней
- Неудобно для потенциальных поисковых запросов (например, "найти клиники, открытые в субботу")
- Менее читаемая структура в БД

### Выбранный вариант: JSON для каждого дня

**Преимущества:**

✅ Баланс между гибкостью и читаемостью  
✅ Простые запросы (SELECT все дни за один запрос)  
✅ Компактное хранение  
✅ Легко добавлять новые типы дней  
✅ Возможность использовать MySQL JSON функции для отдельных дней  
✅ Читаемая структура в БД

---

## 4.8 Проверка целостности данных

### Constraints

- **FOREIGN KEY (clinic_id)** - гарантирует, что график связан с существующей клиникой
- **ON DELETE CASCADE** - автоматически удаляет график при удалении клиники
- **UNIQUE KEY (clinic_id)** - гарантирует, что у клиники только один график

### Валидация JSON

MySQL поддерживает валидацию JSON на уровне БД, но для более детальной валидации (формат времени, пересечения интервалов) используется валидация на уровне API.

**Опционально:** можно добавить CHECK constraints для MySQL 8.0+:

```sql
ALTER TABLE clinic_working_hours
ADD CONSTRAINT chk_monday_json CHECK (JSON_VALID(monday)),
ADD CONSTRAINT chk_tuesday_json CHECK (JSON_VALID(tuesday)),
-- ... для всех дней
```

---

**Предыдущий раздел:** [← 3. Архитектура](03-architecture.md)  
**Следующий раздел:** [5. Риски и метрики →](05-risks-and-metrics.md)
