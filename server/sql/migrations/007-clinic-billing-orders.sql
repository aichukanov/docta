-- Self-service покупка платных услуг клиник (PRD clinic-billing, итерации 1-4).
--
-- Существующие таблицы billing_paid_services / billing_clinic_service_purchases /
-- billing_clinic_service_purchase_items НЕ меняются (их использует и админка).
--
-- Новые таблицы:
--   billing_service_prices       — прайс по периодам (1/3/6/12 мес) + сид цен
--   billing_orders               — заказы до оплаты (UUID, статусы)
--   billing_order_items          — состав заказа с зафиксированной ценой
--   billing_payment_transactions — лог платёжных транзакций (Stripe)
--
-- Деньги: суммы в центах (INT), валюта EUR.
-- (В legacy-таблице purchases цена остаётся DECIMAL в евро — туда пишем cents/100.)
--
-- Apply:
--   mysql -u docta_admin -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/007-clinic-billing-orders.sql

CREATE TABLE IF NOT EXISTS billing_service_prices (
	id INT PRIMARY KEY AUTO_INCREMENT,
	service_id INT NOT NULL,
	months INT NOT NULL COMMENT 'Период: 1, 3, 6, 12 месяцев',
	price_cents INT NOT NULL COMMENT 'Цена в центах EUR',
	currency VARCHAR(3) NOT NULL DEFAULT 'EUR',
	active BOOLEAN NOT NULL DEFAULT TRUE COMMENT 'Активная цена',
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

	FOREIGN KEY (service_id) REFERENCES billing_paid_services (id),
	UNIQUE KEY unique_service_months (service_id, months, active),
	INDEX idx_service_active (service_id, active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO billing_service_prices (service_id, months, price_cents, currency) VALUES
	-- DOFOLLOW (id: 1)
	(1, 1, 1000, 'EUR'),
	(1, 3, 2700, 'EUR'),
	(1, 6, 4800, 'EUR'),
	(1, 12, 8400, 'EUR'),
	-- HIGHLIGHT (id: 2)
	(2, 1, 2000, 'EUR'),
	(2, 3, 5400, 'EUR'),
	(2, 6, 9600, 'EUR'),
	(2, 12, 16800, 'EUR'),
	-- APPROVED (id: 3)
	(3, 1, 1500, 'EUR'),
	(3, 3, 4050, 'EUR'),
	(3, 6, 7200, 'EUR'),
	(3, 12, 12600, 'EUR');

CREATE TABLE IF NOT EXISTS billing_orders (
	id VARCHAR(36) PRIMARY KEY COMMENT 'UUID заказа',
	clinic_id INT NOT NULL,
	created_by INT NULL COMMENT 'Пользователь, создавший заказ',
	status ENUM('pending_payment', 'processing', 'completed', 'failed', 'cancelled')
		NOT NULL DEFAULT 'pending_payment',
	total_amount_cents INT NOT NULL COMMENT 'Итоговая сумма в центах EUR',
	currency VARCHAR(3) NOT NULL DEFAULT 'EUR',
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

	FOREIGN KEY (clinic_id) REFERENCES clinics (id),
	FOREIGN KEY (created_by) REFERENCES auth_users (id) ON DELETE SET NULL,
	INDEX idx_clinic_status (clinic_id, status),
	INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS billing_order_items (
	id INT PRIMARY KEY AUTO_INCREMENT,
	order_id VARCHAR(36) NOT NULL,
	service_id INT NOT NULL,
	months INT NOT NULL COMMENT 'Период: 1, 3, 6, 12',
	price_cents INT NOT NULL COMMENT 'Цена в центах на момент заказа',
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

	FOREIGN KEY (order_id) REFERENCES billing_orders (id) ON DELETE CASCADE,
	FOREIGN KEY (service_id) REFERENCES billing_paid_services (id),
	INDEX idx_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS billing_payment_transactions (
	id INT PRIMARY KEY AUTO_INCREMENT,
	order_id VARCHAR(36) NOT NULL,
	transaction_id VARCHAR(255) NOT NULL COMMENT 'Stripe Checkout Session id (cs_...)',
	payment_provider VARCHAR(50) NOT NULL COMMENT 'stripe',
	amount_cents INT NOT NULL,
	currency VARCHAR(3) NOT NULL DEFAULT 'EUR',
	status ENUM('pending', 'success', 'failed', 'refunded') NOT NULL DEFAULT 'pending',
	payment_url TEXT COMMENT 'URL платёжной формы Stripe Checkout',
	session_id VARCHAR(255) COMMENT 'Stripe Checkout Session id',
	metadata JSON COMMENT 'Дополнительные данные от платёжной системы (payment_intent и т.п.)',
	error_message TEXT COMMENT 'Сообщение об ошибке (если failed)',
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

	FOREIGN KEY (order_id) REFERENCES billing_orders (id),
	UNIQUE KEY unique_transaction (transaction_id),
	INDEX idx_order (order_id),
	INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
