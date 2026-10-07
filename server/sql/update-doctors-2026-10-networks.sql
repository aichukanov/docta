SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Синхронизация врачей сетей клиник с сайтами (группа networks, сайты проверены 2026-10-06):
--   Milmedika (4 филиала) — Sanity CMS (тип doctor, 104 записи), привязка строго по practiceLocation;
--   Moj Lab (17 клиник) — mojlab.me/doktori (150 карточек) + страницы отделений bolnica/poliklinika/pedijatrija;
--   Hipokrat (3 филиала) — /hipokrat/doctors (27 врачей) + /hipokrat/raspored (6–12.10.2026);
--   Endorfin (4 клиники) — без изменений.
-- Решения: data/clinic-teams/decisions/networks.md
-- Клиники, врачи, специальности — только по slug / name (id локально и на проде расходятся).
-- Врачи не удаляются; при отвязке удаляются их строки clinic_medical_service_doctors этой клиники.
-- Идемпотентно: второй прогон ничего не меняет.

-- ═══════════════════════════════════════════════════════════════
-- 0. Имена существующих записей
-- ═══════════════════════════════════════════════════════════════

-- Dijana Račeta Mašić: так на mojlab.me и в списке специалистов радиологии Медфака УЦГ
-- (ucg.ac.me, «Dijana Račeta Mašić»); «Mačić» в БД — опечатка. Старый slug — в slug_redirects.
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'doctors', 'dijana-raceta-macic', id FROM doctors WHERE slug = 'dijana-raceta-macic';
UPDATE doctors SET name_sr = 'Dijana Račeta Mašić', name_sr_cyrl = 'Дијана Рачета Машић',
	name_ru = 'Дияна Рачета Машич', name_en = 'Dijana Raceta Masic', slug = 'dijana-raceta-masic'
WHERE slug = 'dijana-raceta-macic';

-- Rade Šćekić (hipokrat.me «Dr Rade Šćekić»): в БД «Sćekić», slug не меняется
UPDATE doctors SET name_sr = 'Rade Šćekić', name_sr_cyrl = 'Раде Шћекић'
WHERE slug = 'rade-scekic' AND name_sr = 'Rade Sćekić';

-- Branko Lutovac — фото из Sanity Milmedika, если своего нет
UPDATE doctors SET photo_url = 'https://cdn.sanity.io/images/k9l9g2jg/production/2da78a4709ae28120a1423d11d9873ab7a5b93f7-516x645.jpg'
WHERE slug = 'branko-lutovac' AND (photo_url IS NULL OR photo_url = '');

-- ═══════════════════════════════════════════════════════════════
-- 1. Milmedika — строго по practiceLocation
-- ═══════════════════════════════════════════════════════════════

-- Нет в CMS совсем (8 — 404 на /biografija/*, Nasufović не было никогда) → отвязка от всех филиалов
DELETE cmsd FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id JOIN clinics c ON c.id = cmsd.clinic_id
WHERE d.slug IN ('albijanic-drago', 'colakovic-slavka', 'djurisic-borislav-miso', 'emil-nasufovic', 'filipovic-aleksandar', 'gacevic-milomir', 'milovanovic-tamara', 'natasa-vukotic-djuricanin', 'radojicic-jelena')
  AND c.slug IN ('milmedika-podgorica', 'milmedika-niksic', 'milmedika-tivat', 'milmedika-budva');
DELETE dc FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id
WHERE d.slug IN ('albijanic-drago', 'colakovic-slavka', 'djurisic-borislav-miso', 'emil-nasufovic', 'filipovic-aleksandar', 'gacevic-milomir', 'milovanovic-tamara', 'natasa-vukotic-djuricanin', 'radojicic-jelena')
  AND c.slug IN ('milmedika-podgorica', 'milmedika-niksic', 'milmedika-tivat', 'milmedika-budva');

-- Перепривязка: в practiceLocation нет филиала milmedika-niksic
DELETE cmsd FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id JOIN clinics c ON c.id = cmsd.clinic_id
WHERE d.slug IN ('djordjevic-dikic-ana', 'drincic-nenezic-tanja')
  AND c.slug IN ('milmedika-niksic');
DELETE dc FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id
WHERE d.slug IN ('djordjevic-dikic-ana', 'drincic-nenezic-tanja')
  AND c.slug IN ('milmedika-niksic');

-- Перепривязка: в practiceLocation нет филиала milmedika-tivat
DELETE cmsd FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id JOIN clinics c ON c.id = cmsd.clinic_id
WHERE d.slug IN ('adzic-milena', 'ivanovic-milos', 'novosel-dusanka')
  AND c.slug IN ('milmedika-tivat');
DELETE dc FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id
WHERE d.slug IN ('adzic-milena', 'ivanovic-milos', 'novosel-dusanka')
  AND c.slug IN ('milmedika-tivat');

-- Перепривязка: филиалы из practiceLocation, которых у нас не было
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
SELECT d.id, c.id FROM doctors d JOIN clinics c ON c.slug = 'milmedika-niksic'
WHERE d.slug IN ('branko-lutovac', 'ivanovic-milos', 'milica-vusurovic');

INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
SELECT d.id, c.id FROM doctors d JOIN clinics c ON c.slug = 'milmedika-tivat'
WHERE d.slug IN ('branko-lutovac', 'doknic-mirjana', 'malisic-korac-marija', 'milica-vusurovic', 'miskulin-mladen');

-- ═══════════════════════════════════════════════════════════════
-- 2. Moj Lab
-- ═══════════════════════════════════════════════════════════════

-- Нет на сайте сети ни в одном разделе → отвязка от всех клиник Moj Lab
DELETE cmsd FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id JOIN clinics c ON c.id = cmsd.clinic_id
WHERE d.slug IN ('aleksandar-zekic', 'bojana-mijatovic-pavlovic', 'iva-tomasevic', 'ivan-popovic', 'marija-stolic', 'marko-music', 'milos-raspopovic', 'miroslav-knezevic', 'olivera-nikolic', 'slobodan-cirkovic', 'valentina-vujovic', 'vera-djurisic', 'vesna-ivancevic', 'violeta-mihailovic-vucinic', 'vojislav-vucetic', 'zoja-stankovic', 'zoran-zikic')
  AND c.slug IN ('moj-lab-podgorica-1', 'moj-lab-podgorica-2', 'moj-lab-budva', 'moj-lab-ulcinj', 'moj-lab-pedijatrija-podgorica', 'moj-lab-pedijatrija-budva', 'moj-lab-pedijatrija-ulcinj', 'moj-lab-bolnica-podgorica');
DELETE dc FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id
WHERE d.slug IN ('aleksandar-zekic', 'bojana-mijatovic-pavlovic', 'iva-tomasevic', 'ivan-popovic', 'marija-stolic', 'marko-music', 'milos-raspopovic', 'miroslav-knezevic', 'olivera-nikolic', 'slobodan-cirkovic', 'valentina-vujovic', 'vera-djurisic', 'vesna-ivancevic', 'violeta-mihailovic-vucinic', 'vojislav-vucetic', 'zoja-stankovic', 'zoran-zikic')
  AND c.slug IN ('moj-lab-podgorica-1', 'moj-lab-podgorica-2', 'moj-lab-budva', 'moj-lab-ulcinj', 'moj-lab-pedijatrija-podgorica', 'moj-lab-pedijatrija-budva', 'moj-lab-pedijatrija-ulcinj', 'moj-lab-bolnica-podgorica');

-- Педиатр своего города: снимается поликлиника moj-lab-budva (вместо неё — педиатрия того же города ниже)
DELETE cmsd FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id JOIN clinics c ON c.id = cmsd.clinic_id
WHERE d.slug IN ('dragica-becic')
  AND c.slug IN ('moj-lab-budva');
DELETE dc FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id
WHERE d.slug IN ('dragica-becic')
  AND c.slug IN ('moj-lab-budva');

-- Педиатр своего города: снимается поликлиника moj-lab-ulcinj (вместо неё — педиатрия того же города ниже)
DELETE cmsd FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id JOIN clinics c ON c.id = cmsd.clinic_id
WHERE d.slug IN ('pavle-marnikovic')
  AND c.slug IN ('moj-lab-ulcinj');
DELETE dc FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id
WHERE d.slug IN ('pavle-marnikovic')
  AND c.slug IN ('moj-lab-ulcinj');

-- Существующие врачи: раздел Bolnica → bolnica, Pedijatrija → педиатрия,
-- Poliklinika (и карточка без отделения) без привязки к поликлинике сети → podgorica-1
-- moj-lab-bolnica-podgorica (61)
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
SELECT d.id, c.id FROM doctors d JOIN clinics c ON c.slug = 'moj-lab-bolnica-podgorica'
WHERE d.slug IN ('aleksandra-arandjelovic', 'aleksandra-perisic', 'alma-crnovrsanin', 'ana-music', 'angela-coric', 'bosko-cejovic', 'damir-muhovic', 'danilo-radunovic', 'danojla-dakic', 'darko-nisavic', 'dejan-kojic', 'dejan-lekovic', 'dejan-mandic', 'dijana-raceta-masic', 'djordje-jelic', 'djordjije-saranovic', 'dragan-sorat', 'dragica-becic', 'dragica-gudelj', 'elvir-zvrko', 'emil-nasufovic', 'grupkovic-saska', 'ivanovic-jelena', 'jovovic-predrag', 'lidija-ljubisa-maslovar', 'maja-mirocevic-rotolo', 'maja-rabrenovic', 'marija-abramovic', 'marija-kustudic', 'marijana-karisik', 'marina-vukovic', 'milan-mijovic', 'milenko-tadic', 'milica-marovic', 'miljan-ceranic', 'milorad-drljevic', 'milorada-nesovic', 'milovan-jovanovic', 'mladen-donkovic', 'muhedin-kadic', 'nebojsa-cejovic', 'predrag-maras', 'rade-kovac', 'radenko-koprivica', 'sanja-cejovic', 'sanja-medenica', 'sasa-radovic', 'sinisa-drekalovic', 'smilja-rancic', 'srdja-ilic', 'srdjan-medan', 'utjesinovic-jovan', 'vesko-vujicic', 'violeta-manovic', 'vladimir-prelevic', 'vuk-kadic', 'vuk-sekulic', 'zdenka-koturovic', 'zlata-kovacevic', 'zoran-jovancevic', 'zoran-vujacic');

-- moj-lab-pedijatrija-podgorica (6)
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
SELECT d.id, c.id FROM doctors d JOIN clinics c ON c.slug = 'moj-lab-pedijatrija-podgorica'
WHERE d.slug IN ('aleksandra-brasnjo', 'darko-nisavic', 'goran-banjac', 'jelena-vukicevic', 'pekovic-dragana', 'tomo-plamenac');

-- moj-lab-podgorica-1 (11)
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
SELECT d.id, c.id FROM doctors d JOIN clinics c ON c.slug = 'moj-lab-podgorica-1'
WHERE d.slug IN ('aleksandra-radojicic', 'ana-music', 'damir-muhovic', 'grupkovic-saska', 'muhedin-kadic', 'natasa-radovic', 'natasa-vukotic-djuricanin', 'nebojsa-jovanovic', 'rade-kovac', 'sasa-radovic', 'violeta-manovic');

-- moj-lab-pedijatrija-budva (1)
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
SELECT d.id, c.id FROM doctors d JOIN clinics c ON c.slug = 'moj-lab-pedijatrija-budva'
WHERE d.slug IN ('dragica-becic');

-- moj-lab-budva (2)
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
SELECT d.id, c.id FROM doctors d JOIN clinics c ON c.slug = 'moj-lab-budva'
WHERE d.slug IN ('katica-raskovic', 'zlata-kovacevic');

-- moj-lab-pedijatrija-ulcinj (1)
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
SELECT d.id, c.id FROM doctors d JOIN clinics c ON c.slug = 'moj-lab-pedijatrija-ulcinj'
WHERE d.slug IN ('pavle-marnikovic');

-- ═══════════════════════════════════════════════════════════════
-- 3. Hipokrat
-- ═══════════════════════════════════════════════════════════════

-- Нет на /hipokrat/doctors → отвязка от всех филиалов
DELETE cmsd FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id JOIN clinics c ON c.id = cmsd.clinic_id
WHERE d.slug IN ('alma-crnovrsanin', 'dragan-masulovic', 'lidija-krtolica', 'rade-kovac', 'vladan-cipovic')
  AND c.slug IN ('hipokrat-poliklinika-podgorica', 'hipokrat-poliklinika-radanovici', 'hipokrat-poliklinika-niksic');
DELETE dc FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id
WHERE d.slug IN ('alma-crnovrsanin', 'dragan-masulovic', 'lidija-krtolica', 'rade-kovac', 'vladan-cipovic')
  AND c.slug IN ('hipokrat-poliklinika-podgorica', 'hipokrat-poliklinika-radanovici', 'hipokrat-poliklinika-niksic');

-- Есть в БД у других клиник: Luburić (радиолог) → Podgorica, Šćekić (нейрохирург, в графике — Nikšić)
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
SELECT d.id, c.id FROM doctors d JOIN clinics c ON c.slug = 'hipokrat-poliklinika-podgorica'
WHERE d.slug IN ('nikola-luburic');

INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
SELECT d.id, c.id FROM doctors d JOIN clinics c ON c.slug = 'hipokrat-poliklinika-niksic'
WHERE d.slug IN ('rade-scekic');

-- ═══════════════════════════════════════════════════════════════
-- 4. Специальности существующих врачей (по сайтам)
-- ═══════════════════════════════════════════════════════════════

-- Dragan Sorat: на mojlab.me «Specijalista opšte hirurgije», шеф абдоминальной хирургии Bolnice Moj Lab;
-- internal_medicine + oncology в БД ошибочны
SET @d = (SELECT id FROM doctors WHERE slug = 'dragan-sorat');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_surgery' AND @d IS NOT NULL;
DELETE ds FROM doctor_specialties ds JOIN specialties s ON s.id = ds.specialty_id
WHERE ds.doctor_id = @d AND s.name IN ('internal_medicine', 'oncology');

-- darko-nisavic: на mojlab.me «Specijalista ortopedije i traumatologije», разделы Bolnica и Pedijatrija
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT d.id, s.id FROM doctors d JOIN specialties s ON s.name = 'orthopedics_traumatology' WHERE d.slug = 'darko-nisavic';

-- muhedin-kadic: на mojlab.me «Specijalista ORL» во всех трёх разделах
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT d.id, s.id FROM doctors d JOIN specialties s ON s.name = 'otorhinolaryngology' WHERE d.slug = 'muhedin-kadic';

-- jelena-vukicevic: на mojlab.me «Subspecijalista neonatologije»
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT d.id, s.id FROM doctors d JOIN specialties s ON s.name = 'neonatology' WHERE d.slug = 'jelena-vukicevic';

-- ═══════════════════════════════════════════════════════════════
-- 5. Новые врачи (найти или создать)
-- ═══════════════════════════════════════════════════════════════

-- ─── milmedika ───

-- Predrag Matić — vascular_surgery → milmedika-niksic, milmedika-tivat
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Predrag Matić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Matić Predrag' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'predrag-matic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'predrag-matic', 'Predrag Matić', 'Предраг Матић', 'Предраг Матич', 'Predrag Matic', 'doc. dr', 'https://cdn.sanity.io/images/k9l9g2jg/production/68a409fc52cf0616092d32139e5bf22ef1a43982-516x645.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('vascular_surgery');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('milmedika-niksic', 'milmedika-tivat');

-- Slobodan Vukanić — gynecology_obstetrics → milmedika-niksic, milmedika-tivat
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Slobodan Vukanić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Vukanić Slobodan' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'slobodan-vukanic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'slobodan-vukanic', 'Slobodan Vukanić', 'Слободан Вуканић', 'Слободан Вуканич', 'Slobodan Vukanic', 'dr', 'https://cdn.sanity.io/images/k9l9g2jg/production/509776abbe30b6ee692ef7648bb02bc45a03cd31-1454x1817.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gynecology_obstetrics');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('milmedika-niksic', 'milmedika-tivat');

-- Dobrila Radovanov — pediatrics, genetics → milmedika-niksic
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Dobrila Radovanov' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Radovanov Dobrila' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'dobrila-radovanov' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dobrila-radovanov', 'Dobrila Radovanov', 'Добрила Радованов', 'Добрила Радованов', 'Dobrila Radovanov', 'dr', 'https://cdn.sanity.io/images/k9l9g2jg/production/746c1e777c7e34d5ca1faf7ce8780da185b149cf-516x645.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics', 'genetics');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('milmedika-niksic');

-- Predrag Stevanović — anesthesiology → milmedika-niksic
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Predrag Stevanović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Stevanović Predrag' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'predrag-stevanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'predrag-stevanovic', 'Predrag Stevanović', 'Предраг Стевановић', 'Предраг Стеванович', 'Predrag Stevanovic', 'prof. dr', 'https://cdn.sanity.io/images/k9l9g2jg/production/015e89d1427e91231ff963afd6c505f3c4249762-1295x1619.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('anesthesiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('milmedika-niksic');

-- Ilija Tripković — general_surgery, gastrointestial_surgery → milmedika-niksic
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Ilija Tripković' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Tripković Ilija' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ilija-tripkovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ilija-tripkovic', 'Ilija Tripković', 'Илија Трипковић', 'Илия Трипкович', 'Ilija Tripkovic', 'prim. dr', 'https://cdn.sanity.io/images/k9l9g2jg/production/c8c063ccdc9b9be0ed6d3860cd049da115bdf4c4-516x645.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_surgery', 'gastrointestial_surgery');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('milmedika-niksic');

-- ─── hipokrat ───

-- Miloš Veljković — neurology → hipokrat-poliklinika-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Miloš Veljković' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Veljković Miloš' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'milos-veljkovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milos-veljkovic', 'Miloš Veljković', 'Милош Вељковић', 'Милош Велькович', 'Milos Veljkovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('neurology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('hipokrat-poliklinika-podgorica');

-- Radmila Ognjenović — neurology → hipokrat-poliklinika-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Radmila Ognjenović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ognjenović Radmila' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'radmila-ognjenovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'radmila-ognjenovic', 'Radmila Ognjenović', 'Радмила Огњеновић', 'Радмила Огненович', 'Radmila Ognjenovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('neurology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('hipokrat-poliklinika-podgorica');

-- ─── mojlab ───

-- Ana Martinović — clinical_biochemistry → moj-lab-laboratorija-budva
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Ana Martinović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Martinović Ana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ana-martinovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ana-martinovic', 'Ana Martinović', 'Ана Мартиновић', 'Ана Мартинович', 'Ana Martinovic', 'mr ph', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a33908fa269851d910ae011_Ana-Martinovic%CC%81.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('clinical_biochemistry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-laboratorija-budva');

-- Andrijana Bulatović — general_medicine → moj-lab-podgorica-1
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Andrijana Bulatović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Bulatović Andrijana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'andrijana-bulatovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'andrijana-bulatovic', 'Andrijana Bulatović', 'Андријана Булатовић', 'Андрияна Булатович', 'Andrijana Bulatovic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a296ded65b3203c940d8a7a_Andrijana-Bulatovic%CC%81.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-podgorica-1');

-- Anja Magdelinić — general_medicine → moj-lab-podgorica-1
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Anja Magdelinić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Magdelinić Anja' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'anja-magdelinic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'anja-magdelinic', 'Anja Magdelinić', 'Ања Магделинић', 'Аня Магделинич', 'Anja Magdelinic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a3135965b1910bfcd65a9d5_Anja%20Magdelini%C4%87.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3), (@d, 2);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-podgorica-1');

-- Azis Haliti — gynecology_obstetrics, perinatology → moj-lab-podgorica-1
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Azis Haliti' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Haliti Azis' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'azis-haliti' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'azis-haliti', 'Azis Haliti', 'Азис Халити', 'Азис Халити', 'Azis Haliti', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6aba21cc927ba57c82f9ed0f_jj.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gynecology_obstetrics', 'perinatology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-podgorica-1');

-- Balša Stanišić — vascular_surgery → moj-lab-podgorica-1
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Balša Stanišić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Stanišić Balša' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'balsa-stanisic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'balsa-stanisic', 'Balša Stanišić', 'Балша Станишић', 'Балша Станишич', 'Balsa Stanisic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a607dcd476b5a030047b4b9_balsa.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('vascular_surgery');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-podgorica-1');

-- Boris Poberaj — orthopedics_traumatology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Boris Poberaj' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Poberaj Boris' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'boris-poberaj' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'boris-poberaj', 'Boris Poberaj', 'Борис Поберај', 'Борис Поберай', 'Boris Poberaj', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6abb5cd9b3edd7525ef511ad_Dr-Boris-Poberaj-MojLab-.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('orthopedics_traumatology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3), (@d, 6);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Çağatay Öztürk — orthopedics_traumatology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Çağatay Öztürk' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Öztürk Çağatay' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'cagatay-ozturk' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'cagatay-ozturk', 'Çağatay Öztürk', 'Чагатај Озтурк', 'Чагатай Озтюрк', 'Cagatay Ozturk', 'prof. dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a296d49b065c800ba28d27b_Cagatay-Ozturk.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('orthopedics_traumatology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Danilo Jeremić — orthopedics_traumatology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Danilo Jeremić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Jeremić Danilo' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'danilo-jeremic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'danilo-jeremic', 'Danilo Jeremić', 'Данило Јеремић', 'Данило Еремич', 'Danilo Jeremic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a339291aabf8125364c4e4a_dr-Danilo-Jeremic%CC%81-Specijalista-ortopedije-(2).avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('orthopedics_traumatology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Darko Mirković — general_surgery, oncologic_surgery → moj-lab-bolnica-podgorica, moj-lab-podgorica-1
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Darko Mirković' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Mirković Darko' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'darko-mirkovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'darko-mirkovic', 'Darko Mirković', 'Дарко Мирковић', 'Дарко Миркович', 'Darko Mirkovic', 'prof. dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a296c1b516623b627d237e8_Darko-Mirkovic%CC%81.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_surgery', 'oncologic_surgery');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica', 'moj-lab-podgorica-1');

-- Davor Bulatović — orthopedics_traumatology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Davor Bulatović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Bulatović Davor' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'davor-bulatovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'davor-bulatovic', 'Davor Bulatović', 'Давор Булатовић', 'Давор Булатович', 'Davor Bulatovic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6aa3f4afd5bae1ea636dd95d_Untitled-1.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('orthopedics_traumatology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Dejana Jovanović — neurology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Dejana Jovanović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Jovanović Dejana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'dejana-jovanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dejana-jovanovic', 'Dejana Jovanović', 'Дејана Јовановић', 'Деяна Йованович', 'Dejana Jovanovic', 'prof. dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a71c09ced619f880e0a7411_SDWSWD.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('neurology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Dejan Kordić — internal_medicine, cardiology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Dejan Kordić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Kordić Dejan' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'dejan-kordic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dejan-kordic', 'Dejan Kordić', 'Дејан Кордић', 'Деян Кордич', 'Dejan Kordic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a2963d056160edf6d49310b_Dejan-Kordic%CC%81.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('internal_medicine', 'cardiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Đorđe Kravljanac — pediatric_surgery, pediatric_plastic_surgery → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Đorđe Kravljanac' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Kravljanac Đorđe' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'djordje-kravljanac' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'djordje-kravljanac', 'Đorđe Kravljanac', 'Ђорђе Крављанац', 'Джордже Кравлянац', 'Djordje Kravljanac', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a3392fc6946260a106cf4a5_dr-%C4%90or%C4%91e-Kravljanac.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatric_surgery', 'pediatric_plastic_surgery');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Elma Baković — anesthesiology → moj-lab-podgorica-1
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Elma Baković' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Baković Elma' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'elma-bakovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'elma-bakovic', 'Elma Baković', 'Елма Баковић', 'Элма Бакович', 'Elma Bakovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('anesthesiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3), (@d, 9);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-podgorica-1');

-- Goran Marijanović — anesthesiology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Goran Marijanović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Marijanović Goran' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'goran-marijanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'goran-marijanovic', 'Goran Marijanović', 'Горан Маријановић', 'Горан Мариянович', 'Goran Marijanovic', 'prim. dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a29645eceb4359f4c822c7f_Goran-Marijanovic%CC%81.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('anesthesiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 2);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, 'Načelnik anestezije' FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Gordana Jelušić — microbiology → moj-lab-laboratorija-podgorica-moskovska
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Gordana Jelušić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Jelušić Gordana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'gordana-jelusic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'gordana-jelusic', 'Gordana Jelušić', 'Гордана Јелушић', 'Гордана Елушич', 'Gordana Jelusic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a339499b47ab7b308151bca_Gordana-Jelus%CC%8Cic%CC%81.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('microbiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, 'Načelnica Mikrobiološke laboratorije' FROM clinics c WHERE c.slug IN ('moj-lab-laboratorija-podgorica-moskovska');

-- Haki Mavrić — pediatrics → moj-lab-pedijatrija-podgorica, moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Haki Mavrić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Mavrić Haki' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'haki-mavric' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'haki-mavric', 'Haki Mavrić', 'Хаки Маврић', 'Хаки Маврич', 'Haki Mavric', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a8d9ad634aa20b2e868d353_DSASD.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3), (@d, 6);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-pedijatrija-podgorica', 'moj-lab-bolnica-podgorica');

-- Ida Jovanović — pediatrics, pediatric_cardiology → moj-lab-pedijatrija-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Ida Jovanović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Jovanović Ida' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ida-jovanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ida-jovanovic', 'Ida Jovanović', 'Ида Јовановић', 'Ида Йованович', 'Ida Jovanovic', 'prof. dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a3394a99569a07af6a9c1c3_Ida-Jovanovic%CC%81.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics', 'pediatric_cardiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-pedijatrija-podgorica');

-- Irena Šubarić — internal_medicine, pulmonology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Irena Šubarić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Šubarić Irena' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'irena-subaric' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'irena-subaric', 'Irena Šubarić', 'Ирена Шубарић', 'Ирена Шубарич', 'Irena Subaric', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a2964b59245b9952b53cb1a_Irena-S%CC%8Cubaric%CC%81.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('internal_medicine', 'pulmonology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Jela Knežević — pediatrics → moj-lab-pedijatrija-podgorica, moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Jela Knežević' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Knežević Jela' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jela-knezevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jela-knezevic', 'Jela Knežević', 'Јела Кнежевић', 'Ела Кнежевич', 'Jela Knezevic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a3cfba1712eaa1f2775e673_Artboard%207.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-pedijatrija-podgorica', 'moj-lab-bolnica-podgorica');

-- Katarina Kačar — radiology → moj-lab-bolnica-podgorica, moj-lab-podgorica-1
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Katarina Kačar' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Kačar Katarina' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'katarina-kacar' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'katarina-kacar', 'Katarina Kačar', 'Катарина Качар', 'Катарина Качар', 'Katarina Kacar', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('radiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica', 'moj-lab-podgorica-1');

-- Ljiljana Mirković — gynecology_obstetrics, perinatology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Ljiljana Mirković' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Mirković Ljiljana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ljiljana-mirkovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ljiljana-mirkovic', 'Ljiljana Mirković', 'Љиљана Мирковић', 'Лиляна Миркович', 'Ljiljana Mirkovic', 'prof. dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a2964f4c8136b8c06f27014_Ljiljana-Mirkovic%CC%81.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gynecology_obstetrics', 'perinatology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Marija Friščić — clinical_biochemistry → moj-lab-laboratorija-podgorica-moskovska
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Marija Friščić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Friščić Marija' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'marija-friscic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marija-friscic', 'Marija Friščić', 'Марија Фришчић', 'Мария Фришчич', 'Marija Friscic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('clinical_biochemistry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-laboratorija-podgorica-moskovska');

-- Marija Radević — general_medicine → moj-lab-podgorica-1
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Marija Radević' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Radević Marija' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'marija-radevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marija-radevic', 'Marija Radević', 'Марија Радевић', 'Мария Радевич', 'Marija Radevic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a33fab2eb83adc14a2b926b_DSC02980.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3), (@d, 8);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-podgorica-1');

-- Marko Ercegovac — neurology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Marko Ercegovac' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ercegovac Marko' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'marko-ercegovac' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marko-ercegovac', 'Marko Ercegovac', 'Марко Ерцеговац', 'Марко Эрцеговац', 'Marko Ercegovac', 'prof. dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a296543a0cb51226e560c84_Marko-Ercegovac.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('neurology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3), (@d, 9);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, 'Medicinski direktor Bolnice Moj Lab' FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Milan Petronijević — internal_medicine, rheumatology → moj-lab-podgorica-1
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Milan Petronijević' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Petronijević Milan' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'milan-petronijevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milan-petronijevic', 'Milan Petronijević', 'Милан Петронијевић', 'Милан Петрониевич', 'Milan Petronijevic', 'prof. dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a3bc4c8cf32fddfb0cfb959_Artboard%202.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('internal_medicine', 'rheumatology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-podgorica-1');

-- Miloš Jovanović — vascular_surgery → moj-lab-podgorica-1
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Miloš Jovanović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Jovanović Miloš' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'milos-jovanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milos-jovanovic', 'Miloš Jovanović', 'Милош Јовановић', 'Милош Йованович', 'Milos Jovanovic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a61efca0b72c8dafaf735ba_fgfg.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('vascular_surgery');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-podgorica-1');

-- Mira Rudanović Perović — pediatrics, neonatology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Mira Rudanović Perović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Rudanović Perović Mira' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'mira-rudanovic-perovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mira-rudanovic-perovic', 'Mira Rudanović Perović', 'Мира Рудановић Перовић', 'Мира Руданович Перович', 'Mira Rudanovic Perovic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a33943d6bf40f9d39414e97_dr-Mira-Perovic%CC%81.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics', 'neonatology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Nada Milanović — otorhinolaryngology → moj-lab-podgorica-1
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Nada Milanović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Milanović Nada' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'nada-milanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nada-milanovic', 'Nada Milanović', 'Нада Милановић', 'Нада Миланович', 'Nada Milanovic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a33971b4a58dc64ba1f606a_Nada-Milanovic%CC%81.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('otorhinolaryngology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-podgorica-1');

-- Najdana Gligorović Barhanović — clinical_biochemistry → moj-lab-laboratorija-podgorica-moskovska
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Najdana Gligorović Barhanović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Gligorović Barhanović Najdana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'najdana-gligorovic-barhanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'najdana-gligorovic-barhanovic', 'Najdana Gligorović Barhanović', 'Најдана Глигоровић Бархановић', 'Найдана Глигорович Барханович', 'Najdana Gligorovic Barhanovic', 'mr ph', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('clinical_biochemistry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3), (@d, 8);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, 'Direktorica Laboratorije' FROM clinics c WHERE c.slug IN ('moj-lab-laboratorija-podgorica-moskovska');

-- Otaš Durutović — urology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Otaš Durutović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Durutović Otaš' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'otas-durutovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'otas-durutovic', 'Otaš Durutović', 'Оташ Дурутовић', 'Оташ Дурутович', 'Otas Durutovic', 'prof. dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6ac2070151759a00cf075868_CV-za-sajt-Fotografija--Titula%2C-ime-i-prezime--Doc.-dr-sci.-med.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('urology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Predrag Živanović — orthopedics_traumatology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Predrag Živanović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Živanović Predrag' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'predrag-zivanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'predrag-zivanovic', 'Predrag Živanović', 'Предраг Живановић', 'Предраг Живанович', 'Predrag Zivanovic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a2965be313a238b455ac5bd_Predrag-Z%CC%8Civanovic%CC%81.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('orthopedics_traumatology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Rabina Dedeić — radiology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Rabina Dedeić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Dedeić Rabina' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'rabina-dedeic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'rabina-dedeic', 'Rabina Dedeić', 'Рабина Дедеић', 'Рабина Дедеич', 'Rabina Dedeic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('radiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Ružica Kravljanac — pediatrics, pediatric_neurology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Ružica Kravljanac' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Kravljanac Ružica' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ruzica-kravljanac' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ruzica-kravljanac', 'Ružica Kravljanac', 'Ружица Крављанац', 'Ружица Кравлянац', 'Ruzica Kravljanac', 'prof. dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a33985acb3f89a80c541a02_Ruz%CC%8Cica-Kravljanaca.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics', 'pediatric_neurology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Saveta Stanišić — pediatrics, neonatology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Saveta Stanišić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Stanišić Saveta' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'saveta-stanisic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'saveta-stanisic', 'Saveta Stanišić', 'Савета Станишић', 'Савета Станишич', 'Saveta Stanisic', 'prim. dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a296fd7508919a6ebb78aa3_Saveta-Stanis%CC%8Cic%CC%81.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics', 'neonatology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Slađana Aničić — pathological_anatomy → moj-lab-laboratorija-podgorica-moskovska
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Slađana Aničić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Aničić Slađana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'sladjana-anicic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sladjana-anicic', 'Slađana Aničić', 'Слађана Аничић', 'Сладжана Аничич', 'Sladjana Anicic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a296622b5e8296eb63a7a61_Sla%C4%91ana-Anic%CC%8Cic%CC%81.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pathological_anatomy');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-laboratorija-podgorica-moskovska');

-- Slavko Manojlović — orthopedics_traumatology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Slavko Manojlović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Manojlović Slavko' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'slavko-manojlovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'slavko-manojlovic', 'Slavko Manojlović', 'Славко Манојловић', 'Славко Манойлович', 'Slavko Manojlovic', 'prof. dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a2966614ca48c4f81fd1425_Slavko-Manojlovic%CC%81.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('orthopedics_traumatology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Sonja Šofranac — pediatrics, neonatology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Sonja Šofranac' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Šofranac Sonja' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'sonja-sofranac' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sonja-sofranac', 'Sonja Šofranac', 'Соња Шофранац', 'Соня Шофранац', 'Sonja Sofranac', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a3a527ff58b02322496bff6_Sonja%20%C5%A0ofranac.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics', 'neonatology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Tatjana Borilović Stamenković — general_medicine → moj-lab-podgorica-1
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Tatjana Borilović Stamenković' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Borilović Stamenković Tatjana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'tatjana-borilovic-stamenkovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tatjana-borilovic-stamenkovic', 'Tatjana Borilović Stamenković', 'Татјана Бориловић Стаменковић', 'Татьяна Борилович Стаменкович', 'Tatjana Borilovic Stamenkovic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a339936957e26af2967497c_Tatjana-Borilovic%CC%81.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-podgorica-1');

-- Tatjana Božanović — gynecology_obstetrics → moj-lab-bolnica-podgorica, moj-lab-podgorica-1
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Tatjana Božanović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Božanović Tatjana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'tatjana-bozanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tatjana-bozanovic', 'Tatjana Božanović', 'Татјана Божановић', 'Татьяна Божанович', 'Tatjana Bozanovic', 'prof. dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6abdfefc789ae4310206990b_ChatGPT-Image-Oct-1%2C-2026%2C-08_23_46-AM.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gynecology_obstetrics');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica', 'moj-lab-podgorica-1');

-- Tatjana Nikolić — pediatrics → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Tatjana Nikolić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Nikolić Tatjana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'tatjana-nikolic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tatjana-nikolic', 'Tatjana Nikolić', 'Татјана Николић', 'Татьяна Николич', 'Tatjana Nikolic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a339466bef6ad8573508503_dr-tatjana-nikolic.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Uroš Kadić — gynecology_obstetrics → moj-lab-podgorica-1
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Uroš Kadić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Kadić Uroš' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'uros-kadic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'uros-kadic', 'Uroš Kadić', 'Урош Кадић', 'Урош Кадич', 'Uros Kadic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a69fc96b53bc2071bbb2012_xdfd.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gynecology_obstetrics');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-podgorica-1');

-- Vesna Vuković — radiology → moj-lab-bolnica-podgorica, moj-lab-podgorica-1
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Vesna Vuković' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Vuković Vesna' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'vesna-vukovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vesna-vukovic', 'Vesna Vuković', 'Весна Вуковић', 'Весна Вукович', 'Vesna Vukovic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a69f088266f15e894bd7baa_jh.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('radiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1), (@d, 3);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica', 'moj-lab-podgorica-1');

-- Želimir Jovanović — orthopedics_traumatology → moj-lab-bolnica-podgorica
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Želimir Jovanović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Jovanović Želimir' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'zelimir-jovanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zelimir-jovanovic', 'Želimir Jovanović', 'Желимир Јовановић', 'Желимир Йованович', 'Zelimir Jovanovic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a3399b79569a07af6ac7d7a_Z%CC%8Celimir-Jovanovic%CC%81.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('orthopedics_traumatology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica');

-- Zoran Ražnatović — general_surgery → moj-lab-bolnica-podgorica, moj-lab-podgorica-1
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Zoran Ražnatović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ražnatović Zoran' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'zoran-raznatovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zoran-raznatovic', 'Zoran Ražnatović', 'Зоран Ражнатовић', 'Зоран Ражнатович', 'Zoran Raznatovic', 'dr', 'https://cdn.prod.website-files.com/69fdb4415d9d0d3bba020b6e/6a2967370859141844f072b5_Zoran-Raz%CC%8Cnatovic%CC%81.avif', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_surgery');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, c.id, NULL FROM clinics c WHERE c.slug IN ('moj-lab-bolnica-podgorica', 'moj-lab-podgorica-1');

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Врачи по клиникам сетей
SELECT c.slug, COUNT(dc.id) AS doctors FROM clinics c LEFT JOIN doctor_clinics dc ON dc.clinic_id = c.id
WHERE c.slug LIKE 'milmedika-%' OR c.slug LIKE 'moj-lab-%' OR c.slug LIKE 'hipokrat-%' OR c.slug LIKE 'endorfin-%'
GROUP BY c.slug ORDER BY c.slug;

-- Отвязанные: должно быть 0 строк
SELECT d.slug, c.slug FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id
WHERE (d.slug IN ('albijanic-drago', 'colakovic-slavka', 'djurisic-borislav-miso', 'emil-nasufovic', 'filipovic-aleksandar', 'gacevic-milomir', 'milovanovic-tamara', 'natasa-vukotic-djuricanin', 'radojicic-jelena') AND c.slug LIKE 'milmedika-%')
   OR (d.slug IN ('aleksandar-zekic', 'bojana-mijatovic-pavlovic', 'iva-tomasevic', 'ivan-popovic', 'marija-stolic', 'marko-music', 'milos-raspopovic', 'miroslav-knezevic', 'olivera-nikolic', 'slobodan-cirkovic', 'valentina-vujovic', 'vera-djurisic', 'vesna-ivancevic', 'violeta-mihailovic-vucinic', 'vojislav-vucetic', 'zoja-stankovic', 'zoran-zikic') AND c.slug LIKE 'moj-lab-%')
   OR (d.slug IN ('alma-crnovrsanin', 'dragan-masulovic', 'lidija-krtolica', 'rade-kovac', 'vladan-cipovic') AND c.slug LIKE 'hipokrat-%');

-- Новые врачи: специальности и клиники
SELECT d.slug, d.name_sr,
	(SELECT GROUP_CONCAT(s.name ORDER BY s.name) FROM doctor_specialties ds JOIN specialties s ON s.id = ds.specialty_id WHERE ds.doctor_id = d.id) AS specialties,
	(SELECT GROUP_CONCAT(c.slug ORDER BY c.slug) FROM doctor_clinics dc JOIN clinics c ON c.id = dc.clinic_id WHERE dc.doctor_id = d.id) AS clinics
FROM doctors d WHERE d.slug IN ('predrag-matic', 'slobodan-vukanic', 'dobrila-radovanov', 'predrag-stevanovic', 'ilija-tripkovic', 'milos-veljkovic', 'radmila-ognjenovic', 'ana-martinovic', 'andrijana-bulatovic', 'anja-magdelinic', 'azis-haliti', 'balsa-stanisic', 'boris-poberaj', 'cagatay-ozturk', 'danilo-jeremic', 'darko-mirkovic', 'davor-bulatovic', 'dejana-jovanovic', 'dejan-kordic', 'djordje-kravljanac', 'elma-bakovic', 'goran-marijanovic', 'gordana-jelusic', 'haki-mavric', 'ida-jovanovic', 'irena-subaric', 'jela-knezevic', 'katarina-kacar', 'ljiljana-mirkovic', 'marija-friscic', 'marija-radevic', 'marko-ercegovac', 'milan-petronijevic', 'milos-jovanovic', 'mira-rudanovic-perovic', 'nada-milanovic', 'najdana-gligorovic-barhanovic', 'otas-durutovic', 'predrag-zivanovic', 'rabina-dedeic', 'ruzica-kravljanac', 'saveta-stanisic', 'sladjana-anicic', 'slavko-manojlovic', 'sonja-sofranac', 'tatjana-borilovic-stamenkovic', 'tatjana-bozanovic', 'tatjana-nikolic', 'uros-kadic', 'vesna-vukovic', 'zelimir-jovanovic', 'zoran-raznatovic')
ORDER BY d.slug;

-- Переименование: старый slug ведёт на новую запись
SELECT sr.old_slug, d.slug, d.name_sr FROM slug_redirects sr JOIN doctors d ON d.id = sr.entity_id
WHERE sr.entity_type = 'doctors' AND sr.old_slug = 'dijana-raceta-macic';
