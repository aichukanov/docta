# 4. База данных: Самостоятельная покупка платных услуг для клиник

[← Назад к оглавлению](index.md)

---

## 4.1 Существующие таблицы

### `billing_paid_services`

**Назначение:** Справочник платных услуг

**Схема:**

```sql
CREATE TABLE billing_paid_services (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Текущие данные:**
| id | name | description |
|----|-----------|-----------------------------------|
| 1 | DOFOLLOW | Dofollow links for SEO |
| 2 | HIGHLIGHT | Highlighted in clinic lists |
| 3 | APPROVED | Verified clinic badge |

**Изменения:** Нет

---

### `billing_clinic_service_purchases`

**Назначение:** Покупки услуг клиниками

**Схема:**

```sql
CREATE TABLE billing_clinic_service_purchases (
  id INT PRIMARY KEY AUTO_INCREMENT,
  clinic_id INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  purchased_at DATETIME NOT NULL,
  valid_until DATETIME NOT NULL,
  deleted BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (clinic_id) REFERENCES clinics(id)
);
```

**Изменения:** Нет (эта таблица используется и для покупок через админку, и для self-service покупок)

---

### `billing_clinic_service_purchase_items`

**Назначение:** Элементы покупок (связь покупка → услуга)

**Схема:**

```sql
CREATE TABLE billing_clinic_service_purchase_items (
  id INT PRIMARY KEY AUTO_INCREMENT,
  purchase_id INT NOT NULL,
  service_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (purchase_id) REFERENCES billing_clinic_service_purchases(id),
  FOREIGN KEY (service_id) REFERENCES billing_paid_services(id)
);
```

**Изменения:** Нет

---

## 4.2 Новые таблицы

### `billing_service_prices`

**Назначение:** Хранение цен на услуги для разных периодов

**Схема:**

```sql
CREATE TABLE billing_service_prices (
  id INT PRIMARY KEY AUTO_INCREMENT,
  service_id INT NOT NULL,
  months INT NOT NULL COMMENT 'Период: 1, 3, 6, 12 месяцев',
  price DECIMAL(10,2) NOT NULL COMMENT 'Цена в EUR',
  currency VARCHAR(3) DEFAULT 'EUR',
  active BOOLEAN DEFAULT TRUE COMMENT 'Активная цена',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (service_id) REFERENCES billing_paid_services(id),
  UNIQUE KEY unique_service_months (service_id, months, active),
  INDEX idx_service_active (service_id, active)
);
```

**Обоснование:**

- Отделяем ценообразование от справочника услуг
- Позволяет гибко менять цены без изменения кода
- Поддерживает скидки на длительные периоды
- История цен через `active` флаг

**Пример данных:**

```sql
INSERT INTO billing_service_prices (service_id, months, price, currency) VALUES
  -- DOFOLLOW
  (1, 1, 10.00, 'EUR'),   -- 10 EUR / месяц
  (1, 3, 27.00, 'EUR'),   -- 27 EUR / 3 месяца (10% скидка)
  (1, 6, 48.00, 'EUR'),   -- 48 EUR / 6 месяцев (20% скидка)
  (1, 12, 84.00, 'EUR'),  -- 84 EUR / год (30% скидка)

  -- HIGHLIGHT
  (2, 1, 20.00, 'EUR'),   -- 20 EUR / месяц
  (2, 3, 54.00, 'EUR'),   -- 54 EUR / 3 месяца (10% скидка)
  (2, 6, 96.00, 'EUR'),   -- 96 EUR / 6 месяцев (20% скидка)
  (2, 12, 168.00, 'EUR'), -- 168 EUR / год (30% скидка)

  -- APPROVED
  (3, 1, 15.00, 'EUR'),   -- 15 EUR / месяц
  (3, 3, 40.50, 'EUR'),   -- 40.50 EUR / 3 месяца (10% скидка)
  (3, 6, 72.00, 'EUR'),   -- 72 EUR / 6 месяцев (20% скидка)
  (3, 12, 126.00, 'EUR'); -- 126 EUR / год (30% скидка)
```

---

### `billing_orders`

**Назначение:** Заказы до оплаты (временное состояние)

**Схема:**

```sql
CREATE TABLE billing_orders (
  id VARCHAR(36) PRIMARY KEY COMMENT 'UUID заказа',
  clinic_id INT NOT NULL,
  status ENUM('pending_payment', 'processing', 'completed', 'failed', 'cancelled')
    DEFAULT 'pending_payment',
  total_amount DECIMAL(10,2) NOT NULL COMMENT 'Итоговая сумма',
  currency VARCHAR(3) DEFAULT 'EUR',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (clinic_id) REFERENCES clinics(id),
  INDEX idx_clinic_status (clinic_id, status),
  INDEX idx_created (created_at)
);
```

**Статусы:**

- `pending_payment` - ожидает оплаты (начальный статус)
- `processing` - оплата обрабатывается
- `completed` - оплата завершена, услуги активированы
- `failed` - оплата не прошла
- `cancelled` - заказ отменен пользователем

**Обоснование:**

- UUID для безопасности (нельзя угадать ID другого заказа)
- Отдельная таблица для отделения процесса покупки от активированных услуг
- Позволяет хранить историю всех попыток покупки

---

### `billing_order_items`

**Назначение:** Элементы заказа (что заказано)

**Схема:**

```sql
CREATE TABLE billing_order_items (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id VARCHAR(36) NOT NULL,
  service_id INT NOT NULL,
  months INT NOT NULL COMMENT 'Период: 1, 3, 6, 12',
  price DECIMAL(10,2) NOT NULL COMMENT 'Цена на момент заказа',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (order_id) REFERENCES billing_orders(id) ON DELETE CASCADE,
  FOREIGN KEY (service_id) REFERENCES billing_paid_services(id),
  INDEX idx_order (order_id)
);
```

**Обоснование:**

- Сохраняем цену на момент заказа (цены могут измениться)
- ON DELETE CASCADE - при удалении заказа удаляются и элементы
- Связь order_id → service_id + months

---

### `billing_payment_transactions`

**Назначение:** Логирование всех платежных транзакций

**Схема:**

```sql
CREATE TABLE billing_payment_transactions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id VARCHAR(36) NOT NULL,
  transaction_id VARCHAR(255) NOT NULL COMMENT 'ID транзакции от платежной системы',
  payment_provider VARCHAR(50) NOT NULL COMMENT 'stripe, paypal, etc',
  amount DECIMAL(10,2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'EUR',
  status ENUM('pending', 'success', 'failed', 'refunded') DEFAULT 'pending',
  payment_url TEXT COMMENT 'URL платежной формы',
  session_id VARCHAR(255) COMMENT 'ID сессии (Stripe Session ID)',
  metadata JSON COMMENT 'Дополнительные данные от платежной системы',
  error_message TEXT COMMENT 'Сообщение об ошибке (если failed)',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (order_id) REFERENCES billing_orders(id),
  UNIQUE KEY unique_transaction (transaction_id),
  INDEX idx_order (order_id),
  INDEX idx_status (status)
);
```

**Статусы:**

- `pending` - ожидает обработки
- `success` - успешная оплата
- `failed` - оплата не прошла
- `refunded` - оплата возвращена (для будущего)

**Обоснование:**

- Полное логирование всех транзакций для audit
- `metadata` JSON хранит raw данные от платежной системы
- `error_message` для отладки неудачных платежей
- Уникальный `transaction_id` предотвращает дубликаты

---

## 4.3 Миграции

### Миграция 1: Создание таблицы `billing_service_prices`

```sql
-- migration: 001_create_billing_service_prices.sql

CREATE TABLE IF NOT EXISTS billing_service_prices (
  id INT PRIMARY KEY AUTO_INCREMENT,
  service_id INT NOT NULL,
  months INT NOT NULL COMMENT 'Период: 1, 3, 6, 12 месяцев',
  price DECIMAL(10,2) NOT NULL COMMENT 'Цена в EUR',
  currency VARCHAR(3) DEFAULT 'EUR',
  active BOOLEAN DEFAULT TRUE COMMENT 'Активная цена',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (service_id) REFERENCES billing_paid_services(id),
  UNIQUE KEY unique_service_months (service_id, months, active),
  INDEX idx_service_active (service_id, active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Добавляем начальные цены
INSERT INTO billing_service_prices (service_id, months, price, currency) VALUES
  -- DOFOLLOW (id: 1)
  (1, 1, 10.00, 'EUR'),
  (1, 3, 27.00, 'EUR'),
  (1, 6, 48.00, 'EUR'),
  (1, 12, 84.00, 'EUR'),

  -- HIGHLIGHT (id: 2)
  (2, 1, 20.00, 'EUR'),
  (2, 3, 54.00, 'EUR'),
  (2, 6, 96.00, 'EUR'),
  (2, 12, 168.00, 'EUR'),

  -- APPROVED (id: 3)
  (3, 1, 15.00, 'EUR'),
  (3, 3, 40.50, 'EUR'),
  (3, 6, 72.00, 'EUR'),
  (3, 12, 126.00, 'EUR');
```

---

### Миграция 2: Создание таблицы `billing_orders`

```sql
-- migration: 002_create_billing_orders.sql

CREATE TABLE IF NOT EXISTS billing_orders (
  id VARCHAR(36) PRIMARY KEY COMMENT 'UUID заказа',
  clinic_id INT NOT NULL,
  status ENUM('pending_payment', 'processing', 'completed', 'failed', 'cancelled')
    DEFAULT 'pending_payment',
  total_amount DECIMAL(10,2) NOT NULL COMMENT 'Итоговая сумма',
  currency VARCHAR(3) DEFAULT 'EUR',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (clinic_id) REFERENCES clinics(id),
  INDEX idx_clinic_status (clinic_id, status),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### Миграция 3: Создание таблицы `billing_order_items`

```sql
-- migration: 003_create_billing_order_items.sql

CREATE TABLE IF NOT EXISTS billing_order_items (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id VARCHAR(36) NOT NULL,
  service_id INT NOT NULL,
  months INT NOT NULL COMMENT 'Период: 1, 3, 6, 12',
  price DECIMAL(10,2) NOT NULL COMMENT 'Цена на момент заказа',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (order_id) REFERENCES billing_orders(id) ON DELETE CASCADE,
  FOREIGN KEY (service_id) REFERENCES billing_paid_services(id),
  INDEX idx_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### Миграция 4: Создание таблицы `billing_payment_transactions`

```sql
-- migration: 004_create_billing_payment_transactions.sql

CREATE TABLE IF NOT EXISTS billing_payment_transactions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id VARCHAR(36) NOT NULL,
  transaction_id VARCHAR(255) NOT NULL COMMENT 'ID транзакции от платежной системы',
  payment_provider VARCHAR(50) NOT NULL COMMENT 'stripe, paypal, etc',
  amount DECIMAL(10,2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'EUR',
  status ENUM('pending', 'success', 'failed', 'refunded') DEFAULT 'pending',
  payment_url TEXT COMMENT 'URL платежной формы',
  session_id VARCHAR(255) COMMENT 'ID сессии (Stripe Session ID)',
  metadata JSON COMMENT 'Дополнительные данные от платежной системы',
  error_message TEXT COMMENT 'Сообщение об ошибке (если failed)',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (order_id) REFERENCES billing_orders(id),
  UNIQUE KEY unique_transaction (transaction_id),
  INDEX idx_order (order_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

## 4.4 Диаграмма связей

```
┌──────────────────────┐
│ billing_paid_services│
│ ─────────────────────│
│ id (PK)              │
│ name                 │◄─────────┐
│ description          │          │
└──────────────────────┘          │
                                  │
                        ┌─────────┴────────────┐
                        │                       │
              ┌─────────────────────┐  ┌───────────────────┐
              │billing_service_prices│  │billing_order_items│
              │ ────────────────────│  │ ─────────────────│
              │ id (PK)             │  │ id (PK)          │
              │ service_id (FK) ────┘  │ order_id (FK) ───┐
              │ months              │  │ service_id (FK) ─┘
              │ price               │  │ months           │
              │ currency            │  │ price            │
              │ active              │  └──────────────────┘
              └─────────────────────┘           │
                                                │
                                      ┌─────────┴────────┐
                                      │ billing_orders   │
                                      │ ────────────────│
                                      │ id (PK/UUID)    │◄──┐
                                      │ clinic_id (FK)  │   │
                                      │ status          │   │
                                      │ total_amount    │   │
                                      │ currency        │   │
                                      └──────────────────┘   │
                                                             │
                                    ┌────────────────────────┴──────────────┐
                                    │ billing_payment_transactions          │
                                    │ ─────────────────────────────────────│
                                    │ id (PK)                              │
                                    │ order_id (FK) ───────────────────────┘
                                    │ transaction_id (UNIQUE)              │
                                    │ payment_provider                     │
                                    │ amount                               │
                                    │ status                               │
                                    │ session_id                           │
                                    │ metadata (JSON)                      │
                                    └──────────────────────────────────────┘

┌──────────────────────────────────┐
│ billing_clinic_service_purchases │  (существующая таблица)
│ ────────────────────────────────│
│ id (PK)                          │
│ clinic_id (FK)                   │◄──┐
│ price                            │   │
│ purchased_at                     │   │
│ valid_until                      │   │
│ deleted                          │   │
└──────────────────────────────────┘   │
                                       │
        ┌──────────────────────────────┴──────────────┐
        │ billing_clinic_service_purchase_items       │  (существующая)
        │ ───────────────────────────────────────────│
        │ id (PK)                                    │
        │ purchase_id (FK) ──────────────────────────┘
        │ service_id (FK) ───────────────────────────┐
        └────────────────────────────────────────────┘
                                                      │
                                                      │
                                      (связь с billing_paid_services)
```

---

## 4.5 Примеры запросов

### Получить каталог услуг с ценами

```sql
SELECT
  s.id,
  s.name,
  s.description,
  JSON_OBJECTAGG(p.months, p.price) as pricing
FROM billing_paid_services s
LEFT JOIN billing_service_prices p
  ON s.id = p.service_id
  AND p.active = TRUE
GROUP BY s.id;
```

**Результат:**

```json
[
  {
    "id": 1,
    "name": "DOFOLLOW",
    "description": "...",
    "pricing": {
      "1": 10.00,
      "3": 27.00,
      "6": 48.00,
      "12": 84.00
    }
  },
  ...
]
```

---

### Получить активные покупки клиники

```sql
SELECT
  p.id,
  p.price,
  p.purchased_at,
  p.valid_until,
  p.deleted,
  GROUP_CONCAT(s.name) as services,
  CASE
    WHEN p.valid_until > NOW() AND p.deleted = FALSE THEN TRUE
    ELSE FALSE
  END as is_active
FROM billing_clinic_service_purchases p
LEFT JOIN billing_clinic_service_purchase_items i ON p.id = i.purchase_id
LEFT JOIN billing_paid_services s ON i.service_id = s.id
WHERE p.clinic_id = ?
GROUP BY p.id
ORDER BY p.purchased_at DESC;
```

---

### Создать заказ

```sql
-- 1. Создать заказ
INSERT INTO billing_orders (id, clinic_id, total_amount, currency, status)
VALUES (UUID(), ?, ?, 'EUR', 'pending_payment');

-- 2. Добавить элементы заказа
INSERT INTO billing_order_items (order_id, service_id, months, price)
VALUES
  (?, 1, 3, 27.00),
  (?, 2, 1, 20.00);
```

---

### Активировать услуги после оплаты

```sql
-- 1. Создать покупку
INSERT INTO billing_clinic_service_purchases
  (clinic_id, price, purchased_at, valid_until)
SELECT
  o.clinic_id,
  o.total_amount,
  NOW(),
  DATE_ADD(NOW(), INTERVAL MAX(oi.months) MONTH)
FROM billing_orders o
JOIN billing_order_items oi ON o.id = oi.order_id
WHERE o.id = ?
GROUP BY o.clinic_id, o.total_amount;

-- 2. Добавить элементы покупки
INSERT INTO billing_clinic_service_purchase_items
  (purchase_id, service_id)
SELECT
  LAST_INSERT_ID(),
  oi.service_id
FROM billing_order_items oi
WHERE oi.order_id = ?;

-- 3. Обновить статус заказа
UPDATE billing_orders
SET status = 'completed', updated_at = NOW()
WHERE id = ?;
```

---

**Следующая секция:** [5. Риски и метрики →](05-risks-and-metrics.md)
