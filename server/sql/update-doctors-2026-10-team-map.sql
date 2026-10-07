SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Правки врачей по карте списков врачей (data/clinic-teams/, проверка 2026-10-02).
-- Врачи, клиники и специальности — только по slug / name (id локально и на проде
-- расходятся). Слияния дублей сюда НЕ входят — они в миграции
-- 049-merge-duplicate-doctors.sql (те же шаги, что api/doctors/merge).
--
-- 1. Опечатки в именах (источник — сайты клиник):
--    Blaćo Varagić → Blažo Varagić — bpbolnica.me «Blažo Varagic», «Blaćo» только у ДЗ Бело-Поле;
--    Miljenjka Tamara → Tamara Milenkaya — codra.me и novistandard.me, рус. Миленькая;
--    Nataša Jusković → Nataša Jušković — daniloprvi.me (основное место работы);
--      на drzejnilovic.me «Josković» — считаем опечаткой сайта;
--    Tarik Kujundžić → Tarik Kojundžić — bolnicapv.com, откуда у нас «Kujundžić», не записано.
--    Сменившийся slug сохраняется в slug_redirects (как при слиянии).
-- 2. Имена основных записей перед слиянием в админке (слияние заполняет только
--    пустые поля основной записи, имя берётся от неё): Gjenashi, Simashova —
--    написание как на domzdravljabar.com.
-- 3. Специальности:
--    Petar Popović (Kulušić) — в его собственном описании «specijalista ortopedije
--    vilica», на сайте тоже; oral_surgery + maxillofacial_surgery → orthodontist;
--    Ana Bulatović (Apolonia, ana-bulatovic-2) — на сайте «specijalista parodontologije»;
--    orthodontist → dentistry (специальности «пародонтолог» в справочнике нет).
-- 4. Aleksandar Babović — два разных человека в одной записи: психиатр КЦЦГ
--    (kccg.me, «Odjeljenje za psihoze») и начальник кардиологии ОБ Беране
--    (kbcberane.me/menadzerski-tim). Кардиолог выносится в aleksandar-babovic-2
--    вместе с привязкой к Беране; у исходной записи остаются психиатрия и КЦЦГ.
-- 5. Rajko Karličić (ОБ Беране) скрыт админом: умер, kbcberane.me сообщает о
--    комеморативной сессии 19.04.2026. Страница отдаёт 410.

-- ═══ 1. Опечатки в именах ═══

-- Blažo Varagić
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'doctors', 'blaco-varagic', id FROM doctors WHERE slug = 'blaco-varagic';
UPDATE doctors SET name_sr = 'Blažo Varagić', name_sr_cyrl = 'Блажо Варагић', slug = 'blazo-varagic'
WHERE slug = 'blaco-varagic';

-- Tamara Milenkaya
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'doctors', 'miljenjka-tamara', id FROM doctors WHERE slug = 'miljenjka-tamara';
UPDATE doctors SET
	name_sr = 'Tamara Milenkaya', name_sr_cyrl = 'Тамара Миленкаја',
	name_ru = 'Тамара Миленькая', name_en = 'Tamara Milenkaya', slug = 'tamara-milenkaya'
WHERE slug = 'miljenjka-tamara';

-- Nataša Jušković (slug не меняется)
UPDATE doctors SET name_sr = 'Nataša Jušković', name_sr_cyrl = 'Наташа Јушковић'
WHERE slug = 'natasa-juskovic' AND name_sr = 'Nataša Jusković';

-- Tarik Kojundžić
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'doctors', 'tarik-kujundzic', id FROM doctors WHERE slug = 'tarik-kujundzic';
UPDATE doctors SET name_sr = 'Tarik Kojundžić', name_sr_cyrl = 'Тарик Којунџић', slug = 'tarik-kojundzic'
WHERE slug = 'tarik-kujundzic';

-- ═══ 2. Имена основных записей перед слиянием ═══

UPDATE doctors SET name_sr = 'Mehmet Gjenashi', name_sr_cyrl = 'Мехмет Ђенаши', name_en = 'Mehmet Gjenashi'
WHERE slug = 'mehmet-gjenashi';

UPDATE doctors SET name_sr = 'Marina Simashova', name_sr_cyrl = 'Марина Симашова',
	name_ru = 'Марина Симашова', name_en = 'Marina Simashova'
WHERE slug = 'marina-simashova';

-- ═══ 3. Специальности ═══

SET @petar = (SELECT id FROM doctors WHERE slug = 'petar-popovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @petar, id FROM specialties WHERE name = 'orthodontist' AND @petar IS NOT NULL;
DELETE ds FROM doctor_specialties ds
JOIN specialties s ON s.id = ds.specialty_id
WHERE ds.doctor_id = @petar AND s.name IN ('oral_surgery', 'maxillofacial_surgery');

SET @ana = (SELECT id FROM doctors WHERE slug = 'ana-bulatovic-2');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @ana, id FROM specialties WHERE name = 'dentistry' AND @ana IS NOT NULL;
DELETE ds FROM doctor_specialties ds
JOIN specialties s ON s.id = ds.specialty_id
WHERE ds.doctor_id = @ana AND s.name = 'orthodontist';

-- ═══ 4. Aleksandar Babović: кардиолог Беране — отдельная запись ═══

SET @bab_old = (SELECT id FROM doctors WHERE slug = 'aleksandar-babovic');
SET @berane = (SELECT id FROM clinics WHERE slug = 'opsta-bolnica-berane');
SET @bab_new = (SELECT id FROM doctors WHERE slug = 'aleksandar-babovic-2');

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aleksandar-babovic-2', 'Aleksandar Babović', 'Александар Бабовић', '', '', 'dr', NULL, NOW()
FROM dual WHERE @bab_new IS NULL AND @bab_old IS NOT NULL;
SET @bab_new = COALESCE(@bab_new, (SELECT id FROM doctors WHERE slug = 'aleksandar-babovic-2'));

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @bab_new, id FROM specialties WHERE name = 'cardiology' AND @bab_new IS NOT NULL;

INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @bab_new, language_id FROM doctor_languages WHERE doctor_id = @bab_old AND @bab_new IS NOT NULL;

INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @bab_new, clinic_id, position FROM doctor_clinics
WHERE doctor_id = @bab_old AND clinic_id = @berane AND @bab_new IS NOT NULL;

UPDATE clinic_medical_service_doctors SET doctor_id = @bab_new
WHERE doctor_id = @bab_old AND clinic_id = @berane AND @bab_new IS NOT NULL;

DELETE FROM doctor_clinics
WHERE doctor_id = @bab_old AND clinic_id = @berane AND @bab_new IS NOT NULL;

DELETE ds FROM doctor_specialties ds
JOIN specialties s ON s.id = ds.specialty_id
WHERE ds.doctor_id = @bab_old AND s.name = 'cardiology' AND @bab_new IS NOT NULL;

-- ═══ 5. Rajko Karličić ═══
-- Блок скрытия (hidden_by_admin = 1) удалён после применения: решено не скрывать,
-- а отвязать от клиники — это делает 049-merge-duplicate-doctors.sql. Удалён, чтобы
-- повторный прогон этого файла не скрыл врача снова.

-- ═══ VERIFICATION ═══

SELECT slug, name_sr, name_sr_cyrl, name_ru, name_en FROM doctors
WHERE slug IN ('blazo-varagic', 'tamara-milenkaya', 'natasa-juskovic', 'tarik-kojundzic',
	'mehmet-gjenashi', 'marina-simashova');

SELECT old_slug, entity_id FROM slug_redirects
WHERE entity_type = 'doctors' AND old_slug IN ('blaco-varagic', 'miljenjka-tamara', 'tarik-kujundzic');

SELECT d.slug,
	(SELECT GROUP_CONCAT(s.name ORDER BY s.name) FROM doctor_specialties ds JOIN specialties s ON s.id = ds.specialty_id WHERE ds.doctor_id = d.id) AS specialties,
	(SELECT GROUP_CONCAT(c.slug ORDER BY c.slug) FROM doctor_clinics dc JOIN clinics c ON c.id = dc.clinic_id WHERE dc.doctor_id = d.id) AS clinics
FROM doctors d
WHERE d.slug IN ('petar-popovic', 'ana-bulatovic-2', 'aleksandar-babovic', 'aleksandar-babovic-2');
-- ожидание: petar-popovic — orthodontist; ana-bulatovic-2 — dentistry;
-- aleksandar-babovic — psychiatry / KCCG; aleksandar-babovic-2 — cardiology / opsta-bolnica-berane

