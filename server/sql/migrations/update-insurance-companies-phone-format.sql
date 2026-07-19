-- Приводит телефоны/email страховых компаний и их филиалов к общему для
-- сайта формату: чистые цифры с +382 без пробелов, несколько значений
-- в одном поле разделены через ";" (как у клиник), а не через ", ".
-- Без этого formatPhoneNumber() в components/contacts/utils.ts (рассчитан
-- на "+382XXXXXXXXX" без пробелов) даёт битую разбивку вида "+382 2 0 4 44 800",
-- а splitContacts() (делит только по ";") не разбивает "num1, num2" на два номера.
--
-- Apply:
--   mysql -u docta_admin -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/update-insurance-companies-phone-format.sql

SET NAMES utf8mb4;

UPDATE insurance_companies
SET phone = REPLACE(REPLACE(phone, ', ', ';'), ' ', ''),
	email = REPLACE(email, ', ', ';');

UPDATE insurance_company_branches
SET phone = REPLACE(phone, ' ', '')
WHERE phone IS NOT NULL;
