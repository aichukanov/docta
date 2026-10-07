SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 049: слияние дублей врачей по карте списков врачей (data/clinic-teams/, 2026-10-02)
-- + Rajko Karličić: вместо скрытия (410) — просто отвязка от клиники (решение юзера).
--
-- Повторяет шаги api/doctors/merge (кнопка «Объединить» в админке), только по
-- slug, а не по id (id локально и на проде расходятся):
--   1. специальности, языки, клиники, личные услуги вторичного → основному (INSERT IGNORE);
--   2. пустые поля основного заполняются из вторичного (имя основного не меняется);
--   3. отзывы и ответы на отзывы переносятся на основного;
--   4. связи вторичного удаляются, doctor_redirects: старые A→вторичный становятся
--      A→основной, плюс вторичный→основной; slug вторичного → slug_redirects;
--   5. вторичный удаляется.
-- Отличия от админки (без потерь, а не другая логика):
--   - при переносе клиник сохраняется doctor_clinics.position (админка его теряет);
--   - slug_redirects, которые уже вели на вторичного, перенаправляются на основного
--     (админка их не трогает — после удаления врача такие ссылки отдавали бы 404);
--   - AI-сводки отзывов вторичного удаляются (отзывы ушли к основному).
-- Каждый блок no-op, если одного из врачей нет, — файл можно прогнать повторно.
--
-- Тёзки не сливаются: Senad Kalač (хирург / психиатр), Ana Bulatović (ревматолог /
-- стоматолог) — разные люди, см. data/clinic-teams/BACKLOG.md.

-- ═══ 1. marko-abijanic → marko-albijanic ═══
-- опечатка со страницы «Hirurgija» Konzilijum; на всех сайтах Marko Albijanić, уролог

SET @p = (SELECT id FROM doctors WHERE slug = 'marko-albijanic');
SET @s = (SELECT id FROM doctors WHERE slug = 'marko-abijanic');
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @p <> @s);

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @p, specialty_id FROM doctor_specialties WHERE doctor_id = @s AND @ok;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @p, language_id FROM doctor_languages WHERE doctor_id = @s AND @ok;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @p, clinic_id, position FROM doctor_clinics WHERE doctor_id = @s AND @ok;
INSERT IGNORE INTO clinic_medical_service_doctors (clinic_id, medical_service_id, doctor_id, price, price_max)
SELECT clinic_id, medical_service_id, @p, price, price_max FROM clinic_medical_service_doctors WHERE doctor_id = @s AND @ok;

UPDATE doctors d1 JOIN doctors d2 ON d2.id = @s
SET
	d1.name_sr = COALESCE(NULLIF(d1.name_sr, ''), d2.name_sr),
	d1.professional_title = COALESCE(NULLIF(d1.professional_title, ''), d2.professional_title),
	d1.email = COALESCE(NULLIF(d1.email, ''), d2.email),
	d1.phone = COALESCE(NULLIF(d1.phone, ''), d2.phone),
	d1.website = COALESCE(NULLIF(d1.website, ''), d2.website),
	d1.photo_url = COALESCE(NULLIF(d1.photo_url, ''), d2.photo_url),
	d1.facebook = COALESCE(NULLIF(d1.facebook, ''), d2.facebook),
	d1.instagram = COALESCE(NULLIF(d1.instagram, ''), d2.instagram),
	d1.telegram = COALESCE(NULLIF(d1.telegram, ''), d2.telegram),
	d1.whatsapp = COALESCE(NULLIF(d1.whatsapp, ''), d2.whatsapp),
	d1.viber = COALESCE(NULLIF(d1.viber, ''), d2.viber)
WHERE d1.id = @p AND @ok;

UPDATE reviews SET doctor_id = @p WHERE doctor_id = @s AND @ok;
UPDATE review_replies SET doctor_id = @p WHERE doctor_id = @s AND @ok;
DELETE FROM review_ai_summaries WHERE entity_type = 'doctor' AND entity_id = @s AND @ok;

DELETE FROM doctor_specialties WHERE doctor_id = @s AND @ok;
DELETE FROM doctor_languages WHERE doctor_id = @s AND @ok;
DELETE FROM doctor_clinics WHERE doctor_id = @s AND @ok;
DELETE FROM clinic_medical_service_doctors WHERE doctor_id = @s AND @ok;

UPDATE doctor_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO doctor_redirects (old_id, new_id) SELECT @s, @p FROM dual WHERE @ok;
UPDATE slug_redirects SET entity_id = @p WHERE entity_type = 'doctors' AND entity_id = @s AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'doctors', slug, @p FROM doctors WHERE id = @s AND @ok;

DELETE FROM doctors WHERE id = @s AND @ok;

-- ═══ 2. gjenasi-mehmet → mehmet-gjenashi ═══
-- один врач ДЗ Бар, на сайте «Gjenashi Mehmet»

SET @p = (SELECT id FROM doctors WHERE slug = 'mehmet-gjenashi');
SET @s = (SELECT id FROM doctors WHERE slug = 'gjenasi-mehmet');
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @p <> @s);

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @p, specialty_id FROM doctor_specialties WHERE doctor_id = @s AND @ok;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @p, language_id FROM doctor_languages WHERE doctor_id = @s AND @ok;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @p, clinic_id, position FROM doctor_clinics WHERE doctor_id = @s AND @ok;
INSERT IGNORE INTO clinic_medical_service_doctors (clinic_id, medical_service_id, doctor_id, price, price_max)
SELECT clinic_id, medical_service_id, @p, price, price_max FROM clinic_medical_service_doctors WHERE doctor_id = @s AND @ok;

UPDATE doctors d1 JOIN doctors d2 ON d2.id = @s
SET
	d1.name_sr = COALESCE(NULLIF(d1.name_sr, ''), d2.name_sr),
	d1.professional_title = COALESCE(NULLIF(d1.professional_title, ''), d2.professional_title),
	d1.email = COALESCE(NULLIF(d1.email, ''), d2.email),
	d1.phone = COALESCE(NULLIF(d1.phone, ''), d2.phone),
	d1.website = COALESCE(NULLIF(d1.website, ''), d2.website),
	d1.photo_url = COALESCE(NULLIF(d1.photo_url, ''), d2.photo_url),
	d1.facebook = COALESCE(NULLIF(d1.facebook, ''), d2.facebook),
	d1.instagram = COALESCE(NULLIF(d1.instagram, ''), d2.instagram),
	d1.telegram = COALESCE(NULLIF(d1.telegram, ''), d2.telegram),
	d1.whatsapp = COALESCE(NULLIF(d1.whatsapp, ''), d2.whatsapp),
	d1.viber = COALESCE(NULLIF(d1.viber, ''), d2.viber)
WHERE d1.id = @p AND @ok;

UPDATE reviews SET doctor_id = @p WHERE doctor_id = @s AND @ok;
UPDATE review_replies SET doctor_id = @p WHERE doctor_id = @s AND @ok;
DELETE FROM review_ai_summaries WHERE entity_type = 'doctor' AND entity_id = @s AND @ok;

DELETE FROM doctor_specialties WHERE doctor_id = @s AND @ok;
DELETE FROM doctor_languages WHERE doctor_id = @s AND @ok;
DELETE FROM doctor_clinics WHERE doctor_id = @s AND @ok;
DELETE FROM clinic_medical_service_doctors WHERE doctor_id = @s AND @ok;

UPDATE doctor_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO doctor_redirects (old_id, new_id) SELECT @s, @p FROM dual WHERE @ok;
UPDATE slug_redirects SET entity_id = @p WHERE entity_type = 'doctors' AND entity_id = @s AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'doctors', slug, @p FROM doctors WHERE id = @s AND @ok;

DELETE FROM doctors WHERE id = @s AND @ok;

-- ═══ 3. simasova-marina → marina-simashova ═══
-- один врач ДЗ Бар, на сайте «Simashova Marina»

SET @p = (SELECT id FROM doctors WHERE slug = 'marina-simashova');
SET @s = (SELECT id FROM doctors WHERE slug = 'simasova-marina');
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @p <> @s);

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @p, specialty_id FROM doctor_specialties WHERE doctor_id = @s AND @ok;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @p, language_id FROM doctor_languages WHERE doctor_id = @s AND @ok;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @p, clinic_id, position FROM doctor_clinics WHERE doctor_id = @s AND @ok;
INSERT IGNORE INTO clinic_medical_service_doctors (clinic_id, medical_service_id, doctor_id, price, price_max)
SELECT clinic_id, medical_service_id, @p, price, price_max FROM clinic_medical_service_doctors WHERE doctor_id = @s AND @ok;

UPDATE doctors d1 JOIN doctors d2 ON d2.id = @s
SET
	d1.name_sr = COALESCE(NULLIF(d1.name_sr, ''), d2.name_sr),
	d1.professional_title = COALESCE(NULLIF(d1.professional_title, ''), d2.professional_title),
	d1.email = COALESCE(NULLIF(d1.email, ''), d2.email),
	d1.phone = COALESCE(NULLIF(d1.phone, ''), d2.phone),
	d1.website = COALESCE(NULLIF(d1.website, ''), d2.website),
	d1.photo_url = COALESCE(NULLIF(d1.photo_url, ''), d2.photo_url),
	d1.facebook = COALESCE(NULLIF(d1.facebook, ''), d2.facebook),
	d1.instagram = COALESCE(NULLIF(d1.instagram, ''), d2.instagram),
	d1.telegram = COALESCE(NULLIF(d1.telegram, ''), d2.telegram),
	d1.whatsapp = COALESCE(NULLIF(d1.whatsapp, ''), d2.whatsapp),
	d1.viber = COALESCE(NULLIF(d1.viber, ''), d2.viber)
WHERE d1.id = @p AND @ok;

UPDATE reviews SET doctor_id = @p WHERE doctor_id = @s AND @ok;
UPDATE review_replies SET doctor_id = @p WHERE doctor_id = @s AND @ok;
DELETE FROM review_ai_summaries WHERE entity_type = 'doctor' AND entity_id = @s AND @ok;

DELETE FROM doctor_specialties WHERE doctor_id = @s AND @ok;
DELETE FROM doctor_languages WHERE doctor_id = @s AND @ok;
DELETE FROM doctor_clinics WHERE doctor_id = @s AND @ok;
DELETE FROM clinic_medical_service_doctors WHERE doctor_id = @s AND @ok;

UPDATE doctor_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO doctor_redirects (old_id, new_id) SELECT @s, @p FROM dual WHERE @ok;
UPDATE slug_redirects SET entity_id = @p WHERE entity_type = 'doctors' AND entity_id = @s AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'doctors', slug, @p FROM doctors WHERE id = @s AND @ok;

DELETE FROM doctors WHERE id = @s AND @ok;

-- ═══ 4. jelena-miranovic → jelena-terzic-miranovic ═══
-- гинеколог; Kerber и ДЗ Подгорица — «Jelena Miranović», SmartMed — полное имя

SET @p = (SELECT id FROM doctors WHERE slug = 'jelena-terzic-miranovic');
SET @s = (SELECT id FROM doctors WHERE slug = 'jelena-miranovic');
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @p <> @s);

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @p, specialty_id FROM doctor_specialties WHERE doctor_id = @s AND @ok;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @p, language_id FROM doctor_languages WHERE doctor_id = @s AND @ok;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @p, clinic_id, position FROM doctor_clinics WHERE doctor_id = @s AND @ok;
INSERT IGNORE INTO clinic_medical_service_doctors (clinic_id, medical_service_id, doctor_id, price, price_max)
SELECT clinic_id, medical_service_id, @p, price, price_max FROM clinic_medical_service_doctors WHERE doctor_id = @s AND @ok;

UPDATE doctors d1 JOIN doctors d2 ON d2.id = @s
SET
	d1.name_sr = COALESCE(NULLIF(d1.name_sr, ''), d2.name_sr),
	d1.professional_title = COALESCE(NULLIF(d1.professional_title, ''), d2.professional_title),
	d1.email = COALESCE(NULLIF(d1.email, ''), d2.email),
	d1.phone = COALESCE(NULLIF(d1.phone, ''), d2.phone),
	d1.website = COALESCE(NULLIF(d1.website, ''), d2.website),
	d1.photo_url = COALESCE(NULLIF(d1.photo_url, ''), d2.photo_url),
	d1.facebook = COALESCE(NULLIF(d1.facebook, ''), d2.facebook),
	d1.instagram = COALESCE(NULLIF(d1.instagram, ''), d2.instagram),
	d1.telegram = COALESCE(NULLIF(d1.telegram, ''), d2.telegram),
	d1.whatsapp = COALESCE(NULLIF(d1.whatsapp, ''), d2.whatsapp),
	d1.viber = COALESCE(NULLIF(d1.viber, ''), d2.viber)
WHERE d1.id = @p AND @ok;

UPDATE reviews SET doctor_id = @p WHERE doctor_id = @s AND @ok;
UPDATE review_replies SET doctor_id = @p WHERE doctor_id = @s AND @ok;
DELETE FROM review_ai_summaries WHERE entity_type = 'doctor' AND entity_id = @s AND @ok;

DELETE FROM doctor_specialties WHERE doctor_id = @s AND @ok;
DELETE FROM doctor_languages WHERE doctor_id = @s AND @ok;
DELETE FROM doctor_clinics WHERE doctor_id = @s AND @ok;
DELETE FROM clinic_medical_service_doctors WHERE doctor_id = @s AND @ok;

UPDATE doctor_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO doctor_redirects (old_id, new_id) SELECT @s, @p FROM dual WHERE @ok;
UPDATE slug_redirects SET entity_id = @p WHERE entity_type = 'doctors' AND entity_id = @s AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'doctors', slug, @p FROM doctors WHERE id = @s AND @ok;

DELETE FROM doctors WHERE id = @s AND @ok;

-- ═══ 5. ljljana-cirkovic → ljiljana-cirkovic-natalic ═══
-- кардиолог; в биографии — КЦЦГ, начальница предоперационной подготовки, там же её указывает kccg.me

SET @p = (SELECT id FROM doctors WHERE slug = 'ljiljana-cirkovic-natalic');
SET @s = (SELECT id FROM doctors WHERE slug = 'ljljana-cirkovic');
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @p <> @s);

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @p, specialty_id FROM doctor_specialties WHERE doctor_id = @s AND @ok;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @p, language_id FROM doctor_languages WHERE doctor_id = @s AND @ok;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @p, clinic_id, position FROM doctor_clinics WHERE doctor_id = @s AND @ok;
INSERT IGNORE INTO clinic_medical_service_doctors (clinic_id, medical_service_id, doctor_id, price, price_max)
SELECT clinic_id, medical_service_id, @p, price, price_max FROM clinic_medical_service_doctors WHERE doctor_id = @s AND @ok;

UPDATE doctors d1 JOIN doctors d2 ON d2.id = @s
SET
	d1.name_sr = COALESCE(NULLIF(d1.name_sr, ''), d2.name_sr),
	d1.professional_title = COALESCE(NULLIF(d1.professional_title, ''), d2.professional_title),
	d1.email = COALESCE(NULLIF(d1.email, ''), d2.email),
	d1.phone = COALESCE(NULLIF(d1.phone, ''), d2.phone),
	d1.website = COALESCE(NULLIF(d1.website, ''), d2.website),
	d1.photo_url = COALESCE(NULLIF(d1.photo_url, ''), d2.photo_url),
	d1.facebook = COALESCE(NULLIF(d1.facebook, ''), d2.facebook),
	d1.instagram = COALESCE(NULLIF(d1.instagram, ''), d2.instagram),
	d1.telegram = COALESCE(NULLIF(d1.telegram, ''), d2.telegram),
	d1.whatsapp = COALESCE(NULLIF(d1.whatsapp, ''), d2.whatsapp),
	d1.viber = COALESCE(NULLIF(d1.viber, ''), d2.viber)
WHERE d1.id = @p AND @ok;

UPDATE reviews SET doctor_id = @p WHERE doctor_id = @s AND @ok;
UPDATE review_replies SET doctor_id = @p WHERE doctor_id = @s AND @ok;
DELETE FROM review_ai_summaries WHERE entity_type = 'doctor' AND entity_id = @s AND @ok;

DELETE FROM doctor_specialties WHERE doctor_id = @s AND @ok;
DELETE FROM doctor_languages WHERE doctor_id = @s AND @ok;
DELETE FROM doctor_clinics WHERE doctor_id = @s AND @ok;
DELETE FROM clinic_medical_service_doctors WHERE doctor_id = @s AND @ok;

UPDATE doctor_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO doctor_redirects (old_id, new_id) SELECT @s, @p FROM dual WHERE @ok;
UPDATE slug_redirects SET entity_id = @p WHERE entity_type = 'doctors' AND entity_id = @s AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'doctors', slug, @p FROM doctors WHERE id = @s AND @ok;

DELETE FROM doctors WHERE id = @s AND @ok;

-- ═══ 6. Rajko Karličić: снять скрытие, отвязать от ОБ Беране ═══
-- Умер (kbcberane.me, комеморативная сессия 19.04.2026). update-doctors-2026-10-team-map.sql
-- скрыл его с 410 — решено иначе: страница остаётся, привязки к клинике нет.

SET @rk = (SELECT id FROM doctors WHERE slug = 'rajko-karlicic');
UPDATE doctors SET hidden_by_admin = 0, hidden_by_admin_reason = NULL WHERE id = @rk AND hidden_by_admin = 1;
DELETE FROM clinic_medical_service_doctors WHERE doctor_id = @rk;
DELETE FROM doctor_clinics WHERE doctor_id = @rk;

-- ═══ VERIFICATION ═══

SELECT slug AS should_be_gone FROM doctors
WHERE slug IN ('marko-abijanic', 'gjenasi-mehmet', 'simasova-marina', 'jelena-miranovic', 'ljljana-cirkovic');
-- ожидание: пусто

SELECT d.slug, d.name_sr,
	(SELECT GROUP_CONCAT(s.name ORDER BY s.name) FROM doctor_specialties ds JOIN specialties s ON s.id = ds.specialty_id WHERE ds.doctor_id = d.id) AS specialties,
	(SELECT GROUP_CONCAT(c.slug ORDER BY c.slug) FROM doctor_clinics dc JOIN clinics c ON c.id = dc.clinic_id WHERE dc.doctor_id = d.id) AS clinics,
	(SELECT COUNT(*) FROM clinic_medical_service_doctors x WHERE x.doctor_id = d.id) AS services,
	(SELECT COUNT(*) FROM reviews r WHERE r.doctor_id = d.id) AS reviews
FROM doctors d
WHERE d.slug IN ('marko-albijanic', 'mehmet-gjenashi', 'marina-simashova', 'jelena-terzic-miranovic', 'ljiljana-cirkovic-natalic');

SELECT sr.old_slug, d.slug AS redirects_to FROM slug_redirects sr JOIN doctors d ON d.id = sr.entity_id
WHERE sr.entity_type = 'doctors' AND sr.old_slug IN ('marko-abijanic', 'gjenasi-mehmet', 'simasova-marina', 'jelena-miranovic', 'ljljana-cirkovic');

SELECT d.slug, d.hidden_by_admin, d.hidden_by_admin_reason,
	(SELECT COUNT(*) FROM doctor_clinics dc WHERE dc.doctor_id = d.id) AS clinics
FROM doctors d WHERE d.slug = 'rajko-karlicic';
-- ожидание: 0, NULL, 0
