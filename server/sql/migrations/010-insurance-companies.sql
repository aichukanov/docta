-- Справочник страховых компаний (Sava, Lovćen, Uniqa, Generali, Grawe) —
-- отдельные страницы на сайте вместо ссылок на внешние сайты страховых
-- в статьях (residence-permit health insurance и т.п.).
--
-- Модель зеркалит clinics по конвенции колонок (name_sr/name_sr_cyrl/name_ru,
-- address_sr/address_sr_cyrl, town_sr/town_sr_cyrl — те же
-- server/common/utils.ts processLocalizedNameForClinicOrDoctor/
-- processLocalizedFieldForClinic применимы без изменений), но в отличие
-- от клиники — компания может иметь несколько офисов (филиалов) в разных
-- городах, поэтому адрес вынесен в отдельную 1:N таблицу.
--
-- Также добавляет 2 города, которых не было в enums/cities.ts (Pljevlja,
-- Rožaje) — там есть офисы нескольких страховых, а полного списка городов
-- Черногории на сайте до этого не было.
--
-- Apply:
--   mysql -u docta_admin -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/010-insurance-companies.sql

SET NAMES utf8mb4;

INSERT INTO cities (id, name, latitude, longitude) VALUES
	(16, 'Pljevlja', 43.3564000, 19.3600000),
	(17, 'Rozaje', 42.8433000, 20.1667000)
ON DUPLICATE KEY UPDATE name = VALUES(name);

CREATE TABLE IF NOT EXISTS insurance_companies (
	id INT PRIMARY KEY AUTO_INCREMENT,
	slug VARCHAR(100) NOT NULL,

	name_sr VARCHAR(255) NOT NULL,
	name_sr_cyrl VARCHAR(255),
	name_ru VARCHAR(255),

	website VARCHAR(255),
	phone VARCHAR(255),
	email VARCHAR(255),
	logo_url VARCHAR(500),

	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

	UNIQUE KEY unique_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS insurance_company_branches (
	id INT PRIMARY KEY AUTO_INCREMENT,
	insurance_company_id INT NOT NULL,
	city_id INT NOT NULL,

	address_sr TEXT,
	address_sr_cyrl TEXT,
	town_sr VARCHAR(255),
	town_sr_cyrl VARCHAR(255),
	postal_code VARCHAR(20),

	latitude DECIMAL(10,8),
	longitude DECIMAL(11,8),

	-- Контакты филиала — переопределяют телефон/email компании, если заданы
	phone VARCHAR(255),
	email VARCHAR(255),

	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

	FOREIGN KEY (insurance_company_id) REFERENCES insurance_companies (id) ON DELETE CASCADE,
	FOREIGN KEY (city_id) REFERENCES cities (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
