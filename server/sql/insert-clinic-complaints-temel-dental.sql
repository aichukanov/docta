-- Жалобы на Temel Dental (Подгорица) — кейс октября 2026
-- (prd/clinic-reputation/iterations/iteration-04-temel-dental-content.md).
-- Основание confirmed-жалоб: переписка пациентки с клиникой (октябрь 2026) и
-- платёжные документы, проверены редакцией. Идемпотентен: UNIQUE
-- (clinic_id, complaint_type) + ON DUPLICATE KEY UPDATE.
-- Требует применённой миграции 059. review_id проставляется позже через
-- админку, когда отзыв пациентки опубликован, одобрен и закреплён.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'temel-dental-podgorica');

-- Типы: enums/clinic-complaint-type.ts
-- 1 навязанные услуги | 2 итоговая стоимость выше озвученной
-- 3 нет договора/плана | 4 чек не на всю сумму | 5 невозврат предоплаты
-- 6 качество лечения (unconfirmed: только публичные Google-отзывы)
INSERT INTO clinic_complaints
	(clinic_id, complaint_type, status, is_active, review_id, article_slug, incident_date, source_note)
VALUES
	(@clinic_id, 1, 'confirmed', 1, NULL, 'temel-dental-case', '2026-10-01',
		'Переписка пациентки с клиникой 10.2026 + платёжные документы (800 € карта, 200 € наличные без чека). Корроборация — Google-отзывы: EN «сразу начали предлагать дополнительные услуги».'),
	(@clinic_id, 2, 'confirmed', 1, NULL, 'temel-dental-case', '2026-10-01',
		'Устно озвучено «≈2000 €», после оплаты 1000 € письменно насчитано 4000 € с заменой состава лечения. Корроборация — Google-отзывы: TR 80→150 €, RU «запись за 15 €» → 100 € в кресле.'),
	(@clinic_id, 3, 'confirmed', 1, NULL, 'temel-dental-case', '2026-10-01',
		'Договор не заключался, письменный план лечения не выдан — подтверждено перепиской: клиника ссылается только на «слепки, оплату и счёт».'),
	(@clinic_id, 4, 'confirmed', 1, NULL, 'temel-dental-case', '2026-10-01',
		'Из 1000 € чеками подтверждены только 800 € картой; на 200 € наличными фискальный чек не выдан. Корроборация — TR-отзыв: счёт не выдали, «пришлём фото».'),
	(@clinic_id, 5, 'confirmed', 1, NULL, 'temel-dental-case', '2026-10-01',
		'Письменная просьба расторгнуть и вернуть оплату за неоказанные услуги (выполнены только слепки) — отказ; переписка с директором головного офиса в Турции результата не дала.'),
	(@clinic_id, 6, 'unconfirmed', 1, NULL, NULL, NULL,
		'Только публичные Google-отзывы (обточен здоровый зуб; воспаление под коронкой, отказ заменить; осколок в десне после удаления). Документов у редакции нет — статус не повышать без них.')
ON DUPLICATE KEY UPDATE
	status = VALUES(status),
	is_active = VALUES(is_active),
	article_slug = VALUES(article_slug),
	incident_date = VALUES(incident_date),
	source_note = VALUES(source_note);

-- Проверка
SELECT complaint_type, status, is_active, article_slug
FROM clinic_complaints WHERE clinic_id = @clinic_id ORDER BY complaint_type;
