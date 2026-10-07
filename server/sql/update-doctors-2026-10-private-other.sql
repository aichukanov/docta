SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Синхронизация составов врачей с сайтами клиник, группа private-other
-- (небольшие частные клиники). Карта — data/clinic-teams/map.json (срез 2026-10-02),
-- сайты перепроверены curl'ом 2026-10-06. Решения по каждой клинике —
-- data/clinic-teams/decisions/private-other.md.
-- Клиники, врачи, специальности — только по slug / name (id локально и на проде расходятся).
-- Идемпотентно: повторный прогон даёт 0 изменённых строк.
-- Врачи не удаляются; оставшиеся без клиник так и остаются (решение юзера).

-- ═══ a3-medical-sutomore ═══
-- отвязка: dilinov-dmitrii
DELETE m FROM clinic_medical_service_doctors m JOIN doctors d ON d.id = m.doctor_id JOIN clinics c ON c.id = m.clinic_id WHERE d.slug = 'dilinov-dmitrii' AND c.slug = 'a3-medical-sutomore';
DELETE dc FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id WHERE d.slug = 'dilinov-dmitrii' AND c.slug = 'a3-medical-sutomore';
-- отвязка: kolmakov-aleksandar
DELETE m FROM clinic_medical_service_doctors m JOIN doctors d ON d.id = m.doctor_id JOIN clinics c ON c.id = m.clinic_id WHERE d.slug = 'kolmakov-aleksandar' AND c.slug = 'a3-medical-sutomore';
DELETE dc FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id WHERE d.slug = 'kolmakov-aleksandar' AND c.slug = 'a3-medical-sutomore';
-- привязка существующего: nebojsa-crnogorac (+ oncologic_surgery, mammology)
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, NULL FROM doctors d JOIN clinics c ON c.slug = 'a3-medical-sutomore' WHERE d.slug = 'nebojsa-crnogorac';
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT d.id, s.id FROM doctors d JOIN specialties s ON s.name IN ('oncologic_surgery', 'mammology') WHERE d.slug = 'nebojsa-crnogorac';
-- найти или создать: Obrad Vujadinović
SET @d = (SELECT id FROM doctors WHERE slug = 'obrad-vujadinovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Obrad Vujadinović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Vujadinović Obrad' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'vujadinovic-obrad' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'obrad-vujadinovic', 'Obrad Vujadinović', 'Обрад Вујадиновић', 'Обрад Вуядинович', 'Obrad Vujadinovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_surgery', 'thoracic_surgery');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'a3-medical-sutomore';
-- найти или создать: Bojan Kovačević
SET @d = (SELECT id FROM doctors WHERE slug = 'bojan-kovacevic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Bojan Kovačević' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Kovačević Bojan' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'kovacevic-bojan' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'bojan-kovacevic', 'Bojan Kovačević', 'Бојан Ковачевић', 'Боян Ковачевич', 'Bojan Kovacevic', 'prof. dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_surgery');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'a3-medical-sutomore';

-- ═══ bonomedica-budva ═══
-- отвязка: ana-penda
DELETE m FROM clinic_medical_service_doctors m JOIN doctors d ON d.id = m.doctor_id JOIN clinics c ON c.id = m.clinic_id WHERE d.slug = 'ana-penda' AND c.slug = 'bonomedica-budva';
DELETE dc FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id WHERE d.slug = 'ana-penda' AND c.slug = 'bonomedica-budva';
-- отвязка: bojovic-svetlana
DELETE m FROM clinic_medical_service_doctors m JOIN doctors d ON d.id = m.doctor_id JOIN clinics c ON c.id = m.clinic_id WHERE d.slug = 'bojovic-svetlana' AND c.slug = 'bonomedica-budva';
DELETE dc FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id WHERE d.slug = 'bojovic-svetlana' AND c.slug = 'bonomedica-budva';
-- отвязка: toma-nisavic
DELETE m FROM clinic_medical_service_doctors m JOIN doctors d ON d.id = m.doctor_id JOIN clinics c ON c.id = m.clinic_id WHERE d.slug = 'toma-nisavic' AND c.slug = 'bonomedica-budva';
DELETE dc FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id WHERE d.slug = 'toma-nisavic' AND c.slug = 'bonomedica-budva';
-- отвязка: vasko-roganovic
DELETE m FROM clinic_medical_service_doctors m JOIN doctors d ON d.id = m.doctor_id JOIN clinics c ON c.id = m.clinic_id WHERE d.slug = 'vasko-roganovic' AND c.slug = 'bonomedica-budva';
DELETE dc FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id WHERE d.slug = 'vasko-roganovic' AND c.slug = 'bonomedica-budva';
-- привязка существующего: aida-kovacevic
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, NULL FROM doctors d JOIN clinics c ON c.slug = 'bonomedica-budva' WHERE d.slug = 'aida-kovacevic';

-- ═══ svjetlost-eye-clinic-budva ═══
-- найти или создать: Nada Džaković
SET @d = (SELECT id FROM doctors WHERE slug = 'nada-dzakovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Nada Džaković' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Džaković Nada' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'dzakovic-nada' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nada-dzakovic', 'Nada Džaković', 'Нада Џаковић', 'Нада Джакович', 'Nada Dzakovic', 'dr', 'https://svjetlostbudva.me/wp-content/uploads/2019/01/nada.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('ophthalmology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'svjetlost-eye-clinic-budva';

-- ═══ normedica-herceg-novi ═══
-- отвязка: homjakova-tatjana
DELETE m FROM clinic_medical_service_doctors m JOIN doctors d ON d.id = m.doctor_id JOIN clinics c ON c.id = m.clinic_id WHERE d.slug = 'homjakova-tatjana' AND c.slug = 'normedica-herceg-novi';
DELETE dc FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id WHERE d.slug = 'homjakova-tatjana' AND c.slug = 'normedica-herceg-novi';
-- привязка существующего: grupkovic-saska
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, NULL FROM doctors d JOIN clinics c ON c.slug = 'normedica-herceg-novi' WHERE d.slug = 'grupkovic-saska';

-- ═══ codra-hospital-podgorica ═══
-- привязка существующего: batric-vukcevic
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, NULL FROM doctors d JOIN clinics c ON c.slug = 'codra-hospital-podgorica' WHERE d.slug = 'batric-vukcevic';
-- привязка существующего: boris-dasic
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, NULL FROM doctors d JOIN clinics c ON c.slug = 'codra-hospital-podgorica' WHERE d.slug = 'boris-dasic';

-- ═══ humana-reprodukcija-budva ═══
-- отвязка: darko-topic
DELETE m FROM clinic_medical_service_doctors m JOIN doctors d ON d.id = m.doctor_id JOIN clinics c ON c.id = m.clinic_id WHERE d.slug = 'darko-topic' AND c.slug = 'humana-reprodukcija-budva';
DELETE dc FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id WHERE d.slug = 'darko-topic' AND c.slug = 'humana-reprodukcija-budva';
-- привязка существующего: lazovic-zeljko
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, NULL FROM doctors d JOIN clinics c ON c.slug = 'humana-reprodukcija-budva' WHERE d.slug = 'lazovic-zeljko';
-- найти или создать: Ivan Gazivoda
SET @d = (SELECT id FROM doctors WHERE slug = 'ivan-gazivoda' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ivan Gazivoda' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Gazivoda Ivan' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'gazivoda-ivan' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivan-gazivoda', 'Ivan Gazivoda', 'Иван Газивода', 'Иван Газивода', 'Ivan Gazivoda', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('anesthesiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'humana-reprodukcija-budva';

-- ═══ dukley-dental-clinic-budva ═══
-- найти или создать: Tihomir Jović
SET @d = (SELECT id FROM doctors WHERE slug = 'tihomir-jovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Tihomir Jović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Jović Tihomir' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jovic-tihomir' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tihomir-jovic', 'Tihomir Jović', 'Тихомир Јовић', 'Тихомир Йович', 'Tihomir Jovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('dentistry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, 'Upravnik klinike' FROM clinics WHERE slug = 'dukley-dental-clinic-budva';
-- найти или создать: Nikola Bogdanović
SET @d = (SELECT id FROM doctors WHERE slug = 'nikola-bogdanovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Nikola Bogdanović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Bogdanović Nikola' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'bogdanovic-nikola' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nikola-bogdanovic', 'Nikola Bogdanović', 'Никола Богдановић', 'Никола Богданович', 'Nikola Bogdanovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('dentistry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'dukley-dental-clinic-budva';

-- ═══ apolonia-rasovic-stomatoloska-ordinacija-podgorica ═══
-- отвязка: poljakov-kiril
DELETE m FROM clinic_medical_service_doctors m JOIN doctors d ON d.id = m.doctor_id JOIN clinics c ON c.id = m.clinic_id WHERE d.slug = 'poljakov-kiril' AND c.slug = 'apolonia-rasovic-stomatoloska-ordinacija-podgorica';
DELETE dc FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id WHERE d.slug = 'poljakov-kiril' AND c.slug = 'apolonia-rasovic-stomatoloska-ordinacija-podgorica';
-- отвязка: zakirova-marija
DELETE m FROM clinic_medical_service_doctors m JOIN doctors d ON d.id = m.doctor_id JOIN clinics c ON c.id = m.clinic_id WHERE d.slug = 'zakirova-marija' AND c.slug = 'apolonia-rasovic-stomatoloska-ordinacija-podgorica';
DELETE dc FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id WHERE d.slug = 'zakirova-marija' AND c.slug = 'apolonia-rasovic-stomatoloska-ordinacija-podgorica';

-- ═══ dr-zejnilovic-pzu-dnevna-bolnica ═══
-- отвязка: cavic-milorad
DELETE m FROM clinic_medical_service_doctors m JOIN doctors d ON d.id = m.doctor_id JOIN clinics c ON c.id = m.clinic_id WHERE d.slug = 'cavic-milorad' AND c.slug = 'dr-zejnilovic-pzu-dnevna-bolnica';
DELETE dc FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id WHERE d.slug = 'cavic-milorad' AND c.slug = 'dr-zejnilovic-pzu-dnevna-bolnica';
-- найти или создать: Zoran Ivović
SET @d = (SELECT id FROM doctors WHERE slug = 'zoran-ivovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Zoran Ivović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ivović Zoran' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ivovic-zoran' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zoran-ivovic', 'Zoran Ivović', 'Зоран Ивовић', 'Зоран Ивович', 'Zoran Ivovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('urology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'dr-zejnilovic-pzu-dnevna-bolnica';

-- ═══ medical-centar-budva ═══
-- отвязка: vinogradov-oleg
DELETE m FROM clinic_medical_service_doctors m JOIN doctors d ON d.id = m.doctor_id JOIN clinics c ON c.id = m.clinic_id WHERE d.slug = 'vinogradov-oleg' AND c.slug = 'medical-centar-budva';
DELETE dc FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id WHERE d.slug = 'vinogradov-oleg' AND c.slug = 'medical-centar-budva';
-- найти или создать: Milena Perošević
SET @d = (SELECT id FROM doctors WHERE slug = 'milena-perosevic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Milena Perošević' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Perošević Milena' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'perosevic-milena' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milena-perosevic', 'Milena Perošević', 'Милена Перошевић', 'Милена Перошевич', 'Milena Perosevic', 'prim. dr sc.', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics', 'pediatric_gastroenterology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'medical-centar-budva';

-- ═══ poliklinika-dr-masonicic-bar ═══
-- привязка существующего: muzurovic-emir
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, 'Konsultant' FROM doctors d JOIN clinics c ON c.slug = 'poliklinika-dr-masonicic-bar' WHERE d.slug = 'muzurovic-emir';
-- привязка существующего: bakic-nikola
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, 'Konsultant' FROM doctors d JOIN clinics c ON c.slug = 'poliklinika-dr-masonicic-bar' WHERE d.slug = 'bakic-nikola';
-- привязка существующего: nikola-pavlovic
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, 'Konsultant' FROM doctors d JOIN clinics c ON c.slug = 'poliklinika-dr-masonicic-bar' WHERE d.slug = 'nikola-pavlovic';
-- привязка существующего: boskovic-olivera
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, 'Konsultant' FROM doctors d JOIN clinics c ON c.slug = 'poliklinika-dr-masonicic-bar' WHERE d.slug = 'boskovic-olivera';
-- найти или создать: Mirko Šaranović
SET @d = (SELECT id FROM doctors WHERE slug = 'mirko-saranovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Mirko Šaranović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Šaranović Mirko' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'saranovic-mirko' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mirko-saranovic', 'Mirko Šaranović', 'Мирко Шарановић', 'Мирко Шаранович', 'Mirko Saranovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('cardiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, 'Konsultant' FROM clinics WHERE slug = 'poliklinika-dr-masonicic-bar';
-- найти или создать: Milena Kerić
SET @d = (SELECT id FROM doctors WHERE slug = 'milena-keric' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Milena Kerić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Kerić Milena' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'keric-milena' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milena-keric', 'Milena Kerić', 'Милена Керић', 'Милена Керич', 'Milena Keric', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('radiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'poliklinika-dr-masonicic-bar';
-- найти или создать: Svetlana Aligrudić
SET @d = (SELECT id FROM doctors WHERE slug = 'svetlana-aligrudic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Svetlana Aligrudić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Aligrudić Svetlana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'aligrudic-svetlana' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'svetlana-aligrudic', 'Svetlana Aligrudić', 'Светлана Алигрудић', 'Светлана Алигрудич', 'Svetlana Aligrudic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('rheumatology', 'internal_medicine');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, 'Konsultant' FROM clinics WHERE slug = 'poliklinika-dr-masonicic-bar';
-- найти или создать: Anastasija Rudović
SET @d = (SELECT id FROM doctors WHERE slug = 'anastasija-rudovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Anastasija Rudović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Rudović Anastasija' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'rudovic-anastasija' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'anastasija-rudovic', 'Anastasija Rudović', 'Анастасија Рудовић', 'Анастасия Рудович', 'Anastasija Rudovic', '', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('Physiotherapy');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'poliklinika-dr-masonicic-bar';

-- ═══ ordinacija-balans-niksic ═══
-- привязка существующего: sabahudin-pupovic (+ cardiology)
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, NULL FROM doctors d JOIN clinics c ON c.slug = 'ordinacija-balans-niksic' WHERE d.slug = 'sabahudin-pupovic';
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT d.id, s.id FROM doctors d JOIN specialties s ON s.name IN ('cardiology') WHERE d.slug = 'sabahudin-pupovic';
-- привязка существующего: andrija-vujovic (+ nephrology)
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, NULL FROM doctors d JOIN clinics c ON c.slug = 'ordinacija-balans-niksic' WHERE d.slug = 'andrija-vujovic';
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT d.id, s.id FROM doctors d JOIN specialties s ON s.name IN ('nephrology') WHERE d.slug = 'andrija-vujovic';
-- привязка существующего: olivera-bojovic
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, NULL FROM doctors d JOIN clinics c ON c.slug = 'ordinacija-balans-niksic' WHERE d.slug = 'olivera-bojovic';
-- найти или создать: Biljana Savić
SET @d = (SELECT id FROM doctors WHERE slug = 'biljana-savic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Biljana Savić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Savić Biljana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'savic-biljana' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'biljana-savic', 'Biljana Savić', 'Биљана Савић', 'Биляна Савич', 'Biljana Savic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('internal_medicine');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'ordinacija-balans-niksic';
-- найти или создать: Vera Svorcan Đurđevac
SET @d = (SELECT id FROM doctors WHERE slug = 'vera-svorcan-djurdjevac' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Vera Svorcan Đurđevac' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Đurđevac Vera Svorcan' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'djurdjevac-vera-svorcan' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vera-svorcan-djurdjevac', 'Vera Svorcan Đurđevac', 'Вера Сворцан Ђурђевац', 'Вера Сворцан Джурджевац', 'Vera Svorcan Djurdjevac', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('radiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'ordinacija-balans-niksic';
-- найти или создать: Nada Krivokapić
SET @d = (SELECT id FROM doctors WHERE slug = 'nada-krivokapic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Nada Krivokapić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Krivokapić Nada' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'krivokapic-nada' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nada-krivokapic', 'Nada Krivokapić', 'Нада Кривокапић', 'Нада Кривокапич', 'Nada Krivokapic', 'dr', 'https://drbalans.me/wp-content/uploads/2025/12/DR-NADA-KRIVOKAPIC-e1764623796787.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('Physical Medicine and Rehabilitation');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'ordinacija-balans-niksic';
-- найти или создать: Marko Kovačević
SET @d = (SELECT id FROM doctors WHERE slug = 'marko-kovacevic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Marko Kovačević' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Kovačević Marko' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'kovacevic-marko' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marko-kovacevic', 'Marko Kovačević', 'Марко Ковачевић', 'Марко Ковачевич', 'Marko Kovacevic', '', 'https://drbalans.me/wp-content/uploads/2026/03/Dipl.-fizioterpaeut-Marko-Kovacevic-e1773734011257.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('Physiotherapy');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'ordinacija-balans-niksic';
-- найти или создать: Ivana Kovačević
SET @d = (SELECT id FROM doctors WHERE slug = 'ivana-kovacevic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ivana Kovačević' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Kovačević Ivana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'kovacevic-ivana' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivana-kovacevic', 'Ivana Kovačević', 'Ивана Ковачевић', 'Ивана Ковачевич', 'Ivana Kovacevic', '', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('Physiotherapy');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'ordinacija-balans-niksic';

-- ═══ spa-medica-podgorica ═══
-- привязка существующего: aleksandra-savic
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, NULL FROM doctors d JOIN clinics c ON c.slug = 'spa-medica-podgorica' WHERE d.slug = 'aleksandra-savic';
-- привязка существующего: igor-mandic
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, NULL FROM doctors d JOIN clinics c ON c.slug = 'spa-medica-podgorica' WHERE d.slug = 'igor-mandic';
-- найти или создать: Andrija Damjanović
SET @d = (SELECT id FROM doctors WHERE slug = 'andrija-damjanovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Andrija Damjanović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Damjanović Andrija' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'damjanovic-andrija' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'andrija-damjanovic', 'Andrija Damjanović', 'Андрија Дамјановић', 'Андрия Дамьянович', 'Andrija Damjanovic', '', 'https://spamedica.me/wp-content/uploads/2025/08/andrija-damjanovic.webp', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('Physiotherapy');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'spa-medica-podgorica';
-- найти или создать: Sandra Bujiša
SET @d = (SELECT id FROM doctors WHERE slug = 'sandra-bujisa' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Sandra Bujiša' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Bujiša Sandra' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'bujisa-sandra' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sandra-bujisa', 'Sandra Bujiša', 'Сандра Бујиша', 'Сандра Буиша', 'Sandra Bujisa', '', 'https://spamedica.me/wp-content/uploads/2025/08/sandra-bujisa.webp', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('Physiotherapy');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'spa-medica-podgorica';
-- найти или создать: Lidija Marinković
SET @d = (SELECT id FROM doctors WHERE slug = 'lidija-marinkovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Lidija Marinković' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Marinković Lidija' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'marinkovic-lidija' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'lidija-marinkovic', 'Lidija Marinković', 'Лидија Маринковић', 'Лидия Маринкович', 'Lidija Marinkovic', '', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('Physiotherapy');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'spa-medica-podgorica';

-- ═══ luca-medical-podgorica ═══
-- привязка существующего: sanja-borozan
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, NULL FROM doctors d JOIN clinics c ON c.slug = 'luca-medical-podgorica' WHERE d.slug = 'sanja-borozan';
-- найти или создать: Irena Šubarić
SET @d = (SELECT id FROM doctors WHERE slug = 'irena-subaric' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Irena Šubarić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Šubarić Irena' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'subaric-irena' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'irena-subaric', 'Irena Šubarić', 'Ирена Шубарић', 'Ирена Шубарич', 'Irena Subaric', 'dr', 'https://lucamedical.me/wp-content/uploads/2022/02/dr-Irena-Subaric2.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pulmonology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'luca-medical-podgorica';

-- ═══ oftalmoloski-centar-dr-raonic-podgorica ═══
-- привязка существующего: jelena-vukovic (+ ophthalmology)
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, NULL FROM doctors d JOIN clinics c ON c.slug = 'oftalmoloski-centar-dr-raonic-podgorica' WHERE d.slug = 'jelena-vukovic';
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT d.id, s.id FROM doctors d JOIN specialties s ON s.name IN ('ophthalmology') WHERE d.slug = 'jelena-vukovic';
-- привязка существующего: sabina-hasanagic
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, NULL FROM doctors d JOIN clinics c ON c.slug = 'oftalmoloski-centar-dr-raonic-podgorica' WHERE d.slug = 'sabina-hasanagic';
-- привязка существующего: jelena-radovic (+ ophtalmic_surgery)
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, NULL FROM doctors d JOIN clinics c ON c.slug = 'oftalmoloski-centar-dr-raonic-podgorica' WHERE d.slug = 'jelena-radovic';
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT d.id, s.id FROM doctors d JOIN specialties s ON s.name IN ('ophtalmic_surgery') WHERE d.slug = 'jelena-radovic';
-- привязка существующего: maja-djurovic (+ ophtalmic_surgery)
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT d.id, c.id, NULL FROM doctors d JOIN clinics c ON c.slug = 'oftalmoloski-centar-dr-raonic-podgorica' WHERE d.slug = 'maja-djurovic';
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT d.id, s.id FROM doctors d JOIN specialties s ON s.name IN ('ophtalmic_surgery') WHERE d.slug = 'maja-djurovic';

-- ═══ doktorica-mica-pedijatrijski-centar ═══
-- отвязка: snezana-pavicevic
DELETE m FROM clinic_medical_service_doctors m JOIN doctors d ON d.id = m.doctor_id JOIN clinics c ON c.id = m.clinic_id WHERE d.slug = 'snezana-pavicevic' AND c.slug = 'doktorica-mica-pedijatrijski-centar';
DELETE dc FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id WHERE d.slug = 'snezana-pavicevic' AND c.slug = 'doktorica-mica-pedijatrijski-centar';

-- ═══ medtim-privatna-bolnica ═══
-- найти или создать: Dejan Marinković
SET @d = (SELECT id FROM doctors WHERE slug = 'dejan-marinkovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Dejan Marinković' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Marinković Dejan' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'marinkovic-dejan' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dejan-marinkovic', 'Dejan Marinković', 'Дејан Маринковић', 'Деян Маринкович', 'Dejan Marinkovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('endocrinology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'medtim-privatna-bolnica';

-- ═══ ars-medica-specijalna-bolnica ═══
-- найти или создать: Aleksandar Ljubić
SET @d = (SELECT id FROM doctors WHERE slug = 'aleksandar-ljubic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Aleksandar Ljubić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ljubić Aleksandar' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ljubic-aleksandar' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aleksandar-ljubic', 'Aleksandar Ljubić', 'Александар Љубић', 'Александар Любич', 'Aleksandar Ljubic', 'prof. dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gynecology_obstetrics', 'perinatology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'ars-medica-specijalna-bolnica';

-- ═══ ars-medica-dental-clinic ═══
-- найти или создать: Dražen Nikčević
SET @d = (SELECT id FROM doctors WHERE slug = 'drazen-nikcevic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Dražen Nikčević' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Nikčević Dražen' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'nikcevic-drazen' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'drazen-nikcevic', 'Dražen Nikčević', 'Дражен Никчевић', 'Дражен Никчевич', 'Drazen Nikcevic', 'dr', 'https://arsmedica.co.me/wp-content/uploads/2023/12/3.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('dentistry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'ars-medica-dental-clinic';
-- найти или создать: Aleksa Raičković
SET @d = (SELECT id FROM doctors WHERE slug = 'aleksa-raickovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Aleksa Raičković' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Raičković Aleksa' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'raickovic-aleksa' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aleksa-raickovic', 'Aleksa Raičković', 'Алекса Раичковић', 'Алекса Раичкович', 'Aleksa Raickovic', 'dr', 'https://arsmedica.co.me/wp-content/uploads/2023/12/Aleksandar.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('dentistry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, id, NULL FROM clinics WHERE slug = 'ars-medica-dental-clinic';

-- ═══ stomatoloska-ordinacija-musura ═══
-- отвязка: nikola-musura
DELETE m FROM clinic_medical_service_doctors m JOIN doctors d ON d.id = m.doctor_id JOIN clinics c ON c.id = m.clinic_id WHERE d.slug = 'nikola-musura' AND c.slug = 'stomatoloska-ordinacija-musura';
DELETE dc FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id WHERE d.slug = 'nikola-musura' AND c.slug = 'stomatoloska-ordinacija-musura';

-- ═══ VERIFICATION ═══
-- 1. Отвязанные: должно быть 0 строк.
SELECT c.slug clinic, d.slug doctor FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id WHERE (c.slug, d.slug) IN (('a3-medical-sutomore', 'dilinov-dmitrii'), ('a3-medical-sutomore', 'kolmakov-aleksandar'), ('bonomedica-budva', 'ana-penda'), ('bonomedica-budva', 'bojovic-svetlana'), ('bonomedica-budva', 'toma-nisavic'), ('bonomedica-budva', 'vasko-roganovic'), ('normedica-herceg-novi', 'homjakova-tatjana'), ('humana-reprodukcija-budva', 'darko-topic'), ('apolonia-rasovic-stomatoloska-ordinacija-podgorica', 'poljakov-kiril'), ('apolonia-rasovic-stomatoloska-ordinacija-podgorica', 'zakirova-marija'), ('dr-zejnilovic-pzu-dnevna-bolnica', 'cavic-milorad'), ('medical-centar-budva', 'vinogradov-oleg'), ('doktorica-mica-pedijatrijski-centar', 'snezana-pavicevic'), ('stomatoloska-ordinacija-musura', 'nikola-musura'));
-- 2. Привязанные и созданные: должно быть 45 строк, у каждой specialties не пусто.
SELECT c.slug clinic, d.slug doctor, d.name_sr, IFNULL(dc.position, '') position, (SELECT GROUP_CONCAT(s.name ORDER BY s.name) FROM doctor_specialties ds JOIN specialties s ON s.id = ds.specialty_id WHERE ds.doctor_id = d.id) specialties FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id WHERE (c.slug, d.slug) IN (('a3-medical-sutomore', 'nebojsa-crnogorac'), ('a3-medical-sutomore', 'obrad-vujadinovic'), ('a3-medical-sutomore', 'bojan-kovacevic'), ('bonomedica-budva', 'aida-kovacevic'), ('svjetlost-eye-clinic-budva', 'nada-dzakovic'), ('normedica-herceg-novi', 'grupkovic-saska'), ('codra-hospital-podgorica', 'batric-vukcevic'), ('codra-hospital-podgorica', 'boris-dasic'), ('humana-reprodukcija-budva', 'lazovic-zeljko'), ('humana-reprodukcija-budva', 'ivan-gazivoda'), ('dukley-dental-clinic-budva', 'tihomir-jovic'), ('dukley-dental-clinic-budva', 'nikola-bogdanovic'), ('dr-zejnilovic-pzu-dnevna-bolnica', 'zoran-ivovic'), ('medical-centar-budva', 'milena-perosevic'), ('poliklinika-dr-masonicic-bar', 'muzurovic-emir'), ('poliklinika-dr-masonicic-bar', 'bakic-nikola'), ('poliklinika-dr-masonicic-bar', 'nikola-pavlovic'), ('poliklinika-dr-masonicic-bar', 'boskovic-olivera'), ('poliklinika-dr-masonicic-bar', 'mirko-saranovic'), ('poliklinika-dr-masonicic-bar', 'milena-keric'), ('poliklinika-dr-masonicic-bar', 'svetlana-aligrudic'), ('poliklinika-dr-masonicic-bar', 'anastasija-rudovic'), ('ordinacija-balans-niksic', 'sabahudin-pupovic'), ('ordinacija-balans-niksic', 'andrija-vujovic'), ('ordinacija-balans-niksic', 'olivera-bojovic'), ('ordinacija-balans-niksic', 'biljana-savic'), ('ordinacija-balans-niksic', 'vera-svorcan-djurdjevac'), ('ordinacija-balans-niksic', 'nada-krivokapic'), ('ordinacija-balans-niksic', 'marko-kovacevic'), ('ordinacija-balans-niksic', 'ivana-kovacevic'), ('spa-medica-podgorica', 'aleksandra-savic'), ('spa-medica-podgorica', 'igor-mandic'), ('spa-medica-podgorica', 'andrija-damjanovic'), ('spa-medica-podgorica', 'sandra-bujisa'), ('spa-medica-podgorica', 'lidija-marinkovic'), ('luca-medical-podgorica', 'sanja-borozan'), ('luca-medical-podgorica', 'irena-subaric'), ('oftalmoloski-centar-dr-raonic-podgorica', 'jelena-vukovic'), ('oftalmoloski-centar-dr-raonic-podgorica', 'sabina-hasanagic'), ('oftalmoloski-centar-dr-raonic-podgorica', 'jelena-radovic'), ('oftalmoloski-centar-dr-raonic-podgorica', 'maja-djurovic'), ('medtim-privatna-bolnica', 'dejan-marinkovic'), ('ars-medica-specijalna-bolnica', 'aleksandar-ljubic'), ('ars-medica-dental-clinic', 'drazen-nikcevic'), ('ars-medica-dental-clinic', 'aleksa-raickovic')) ORDER BY c.slug, d.slug;
-- 3. Число врачей по затронутым клиникам (ожидаемо после применения: a3 18, apolonia 4, ars-dental 7, ars-bolnica 16, bonomedica 11, codra 91, mica 21, zejnilovic 14, dukley 4, humana 9, luca 16, mcb 8, medtim 17, normedica 7, raonic 8, balans 11, masonicic 9, spa-medica 5, musura 5, svjetlost 6; по локальной базе).
SELECT c.slug clinic, COUNT(dc.id) doctors FROM clinics c LEFT JOIN doctor_clinics dc ON dc.clinic_id = c.id WHERE c.slug IN ('a3-medical-sutomore', 'bonomedica-budva', 'svjetlost-eye-clinic-budva', 'normedica-herceg-novi', 'codra-hospital-podgorica', 'humana-reprodukcija-budva', 'dukley-dental-clinic-budva', 'apolonia-rasovic-stomatoloska-ordinacija-podgorica', 'dr-zejnilovic-pzu-dnevna-bolnica', 'medical-centar-budva', 'poliklinika-dr-masonicic-bar', 'ordinacija-balans-niksic', 'spa-medica-podgorica', 'luca-medical-podgorica', 'oftalmoloski-centar-dr-raonic-podgorica', 'doktorica-mica-pedijatrijski-centar', 'medtim-privatna-bolnica', 'ars-medica-specijalna-bolnica', 'ars-medica-dental-clinic', 'stomatoloska-ordinacija-musura') GROUP BY c.slug ORDER BY c.slug;
