-- Фикс схемы insurance_companies (010-insurance-companies.sql): забыл добавить
-- facebook/instagram/telegram/whatsapp/viber, хотя InsuranceCompanyData
-- extends ContactList и server/api/insurance-companies/details.ts их уже
-- выбирает — SELECT падал с "Unknown column", деталь-страница отдавала 500
-- и фронт молча показывал "не найдена".
--
-- Apply:
--   mysql -u docta_admin -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/011-insurance-companies-contacts.sql

ALTER TABLE insurance_companies
	ADD COLUMN facebook VARCHAR(255) AFTER email,
	ADD COLUMN instagram VARCHAR(255) AFTER facebook,
	ADD COLUMN telegram VARCHAR(255) AFTER instagram,
	ADD COLUMN whatsapp VARCHAR(255) AFTER telegram,
	ADD COLUMN viber VARCHAR(255) AFTER whatsapp;
