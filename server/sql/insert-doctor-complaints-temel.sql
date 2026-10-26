-- Жалоба на врача Ibrahim Halil Temel (Temel Dental, Подгорица) — кейс
-- октября 2026 (prd/clinic-reputation/iterations/iteration-04-temel-dental-content.md).
-- Врач ищется по slug: id врачей в локальной БД и на проде не совпадают.
-- Идемпотентен: UNIQUE (doctor_id, complaint_type) + ON DUPLICATE KEY UPDATE.
-- Требует применённой миграции 060.
--
-- Тип 1 (навязывание услуг, enums/complaint-type.ts) — тот же, что у клиники;
-- здесь он поставлен персонально главному стоматологу и владельцу практики:
-- именно он определяет состав и цену плана лечения, которые в кейсе были
-- заменены после внесения оплаты. Остальные типы (чек, договор, возврат) —
-- организационные обязанности юрлица и остаются только у клиники.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'ibrahim-halil-temel');

INSERT INTO doctor_complaints
	(doctor_id, complaint_type, status, is_active, review_id, article_slug, incident_date, source_note)
VALUES
	(@doctor_id, 1, 'confirmed', 1, NULL, 'temel-dental-case', '2026-10-01',
		'Главный стоматолог и владелец Temel Dental: состав и цена плана лечения — его решение. Переписка пациентки с клиникой 10.2026 + платёжные документы: устно «≈2000 €», после оплаты 1000 € письменно 4000 € с заменой элайнеров на брекеты и добавлением пластинки на нижнюю челюсть, которую сам же врач перед этим назвал ненужной. Корроборация — Google-отзывы: EN «сразу начали предлагать дополнительные услуги»; отдельный EN-отзыв называет Ibrahim Temel поимённо (обточен здоровый зуб под коронку).')
ON DUPLICATE KEY UPDATE
	status = VALUES(status),
	is_active = VALUES(is_active),
	article_slug = VALUES(article_slug),
	incident_date = VALUES(incident_date),
	source_note = VALUES(source_note);

-- Проверка
SELECT d.slug, dc.complaint_type, dc.status, dc.is_active, dc.article_slug
FROM doctor_complaints dc
JOIN doctors d ON d.id = dc.doctor_id
WHERE d.slug = 'ibrahim-halil-temel'
ORDER BY dc.complaint_type;
