-- 035: отзывы на страховые компании (та же система, что у клиник/врачей).
--
-- reviews полиморфна через nullable FK-колонки (ровно одна заполнена):
-- clinic_id / doctor_id / medical_service_id — добавляем insurance_company_id.
-- Индексы зеркалят клинические: (entity, rating) для рейтинга/фильтра,
-- (entity, user) для проверки дубликатов и own-запроса.

-- 1. Целевая колонка на reviews
ALTER TABLE reviews
	ADD COLUMN insurance_company_id INT NULL AFTER medical_service_id,
	ADD INDEX idx_reviews_insurance_rating (insurance_company_id, rating),
	ADD INDEX idx_reviews_insurance_user (insurance_company_id, user_id),
	ADD CONSTRAINT fk_reviews_insurance_company FOREIGN KEY (insurance_company_id)
		REFERENCES insurance_companies (id) ON DELETE CASCADE;

-- 2. Ответы на отзывы: страховая как отвечающая сторона (задел под импорт
-- Google Maps-отзывов, где страховые отвечают так же, как клиники)
ALTER TABLE review_replies
	ADD COLUMN insurance_company_id INT NULL AFTER doctor_id,
	MODIFY COLUMN responder_type ENUM('clinic', 'doctor', 'insurance_company') NOT NULL,
	ADD CONSTRAINT fk_review_replies_insurance_company FOREIGN KEY (insurance_company_id)
		REFERENCES insurance_companies (id) ON DELETE CASCADE;

-- 3. AI-обзоры отзывов: страховая как сущность
ALTER TABLE review_ai_summaries
	MODIFY COLUMN entity_type ENUM('doctor', 'clinic', 'insurance_company') NOT NULL;
