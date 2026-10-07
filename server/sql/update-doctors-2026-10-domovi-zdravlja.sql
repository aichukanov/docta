SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Группа domovi-zdravlja: синхронизация составов врачей домов здоровья с сайтами (кроме ДЗ Подгорица).
-- Карта: data/clinic-teams/map.json (срез 2026-10-02); сайты перепроверены curl'ом 2026-10-06.
-- Решения по каждой клинике: data/clinic-teams/decisions/domovi-zdravlja.md
-- Клиники, врачи, специальности — только по slug / name (id локально и на проде расходятся).
-- Новый врач: «найти или создать» по slug; язык — сербский; photo_url NULL (на сайтах фото нет или заглушки).
-- Врачей не удаляем: отвязанные без клиник так и остаются. Идемпотентно: второй прогон ничего не меняет.

SET @c_hn = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-herceg-novi');
SET @c_bd = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-budva');
SET @c_tv = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-tivat');
SET @c_bar = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-bar');
SET @c_dg = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad');
SET @c_bp = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-bijelo-polje');
SET @c_mk = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-bosko-dedeic-mojkovac');
SET @c_kl = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-kolasin');
SET @c_an = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-andrijevica');
SET @c_kt = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-kotor');

-- ═══════════════════════════════════════════════════════════════
-- 1. Отвязка (сайт даёт полный список, врача нет и при перепроверке 2026-10-06)
-- ═══════════════════════════════════════════════════════════════

-- DZ Herceg Novi: ana-penda, darko-topic, milos-milic, milovan-radosavljevic
DELETE x FROM clinic_medical_service_doctors x JOIN doctors d ON d.id = x.doctor_id
WHERE x.clinic_id = @c_hn AND d.slug IN ('ana-penda', 'darko-topic', 'milos-milic', 'milovan-radosavljevic');
DELETE dc FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id
WHERE dc.clinic_id = @c_hn AND d.slug IN ('ana-penda', 'darko-topic', 'milos-milic', 'milovan-radosavljevic');

-- DZ Budva: ana-penda, lidija-krtolica, sladjana-strahinic, vesna-milutinovic, veselin-vusurovic
DELETE x FROM clinic_medical_service_doctors x JOIN doctors d ON d.id = x.doctor_id
WHERE x.clinic_id = @c_bd AND d.slug IN ('ana-penda', 'lidija-krtolica', 'sladjana-strahinic', 'vesna-milutinovic', 'veselin-vusurovic');
DELETE dc FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id
WHERE dc.clinic_id = @c_bd AND d.slug IN ('ana-penda', 'lidija-krtolica', 'sladjana-strahinic', 'vesna-milutinovic', 'veselin-vusurovic');

-- DZ Tivat: ana-penda, bojan-vucetic, igor-bjeladinovic, jelena-pajcin, jelena-perunovic, lidija-krtolica, milica-vusurovic, nevenka-becir, svetlana-slavkovic
DELETE x FROM clinic_medical_service_doctors x JOIN doctors d ON d.id = x.doctor_id
WHERE x.clinic_id = @c_tv AND d.slug IN ('ana-penda', 'bojan-vucetic', 'igor-bjeladinovic', 'jelena-pajcin', 'jelena-perunovic', 'lidija-krtolica', 'milica-vusurovic', 'nevenka-becir', 'svetlana-slavkovic');
DELETE dc FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id
WHERE dc.clinic_id = @c_tv AND d.slug IN ('ana-penda', 'bojan-vucetic', 'igor-bjeladinovic', 'jelena-pajcin', 'jelena-perunovic', 'lidija-krtolica', 'milica-vusurovic', 'nevenka-becir', 'svetlana-slavkovic');

-- ═══════════════════════════════════════════════════════════════
-- 2. Существующие врачи — только привязка
-- ═══════════════════════════════════════════════════════════════

-- Oliver Adrović → DZ Herceg Novi
SET @d = (SELECT id FROM doctors WHERE slug = 'oliver-adrovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Ortopedska ambulanta' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Kristina Mašanović → DZ Kotor
SET @d = (SELECT id FROM doctors WHERE slug = 'masanovic-kristina');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_kt, 'Molekularni biolog, Centar za mikrobiološku dijagnostiku' FROM dual WHERE @d IS NOT NULL AND @c_kt IS NOT NULL;

-- ═══════════════════════════════════════════════════════════════
-- 3. Новые врачи (73)
-- ═══════════════════════════════════════════════════════════════

-- ─── DZ Herceg Novi ───

-- Maja Popović (pediatrics)
SET @d = (SELECT id FROM doctors WHERE slug = 'maja-popovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'maja-popovic', 'Maja Popović', 'Маја Поповић', 'Мая Попович', 'Maja Popovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'maja-popovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Nataša Milović (pediatrics)
SET @d = (SELECT id FROM doctors WHERE slug = 'natasa-milovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'natasa-milovic', 'Nataša Milović', 'Наташа Миловић', 'Наташа Милович', 'Natasa Milovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'natasa-milovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Dragan Maksimović (pediatrics)
SET @d = (SELECT id FROM doctors WHERE slug = 'dragan-maksimovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dragan-maksimovic', 'Dragan Maksimović', 'Драган Максимовић', 'Драган Максимович', 'Dragan Maksimovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'dragan-maksimovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Dragana Knežević (pediatrics)
SET @d = (SELECT id FROM doctors WHERE slug = 'dragana-knezevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dragana-knezevic', 'Dragana Knežević', 'Драгана Кнежевић', 'Драгана Кнежевич', 'Dragana Knezevic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'dragana-knezevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Olivera Mentović (pediatrics)
SET @d = (SELECT id FROM doctors WHERE slug = 'olivera-mentovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'olivera-mentovic', 'Olivera Mentović', 'Оливера Ментовић', 'Оливера Ментович', 'Olivera Mentovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'olivera-mentovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Vesna Kovač (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'vesna-kovac');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vesna-kovac', 'Vesna Kovač', 'Весна Ковач', 'Весна Ковач', 'Vesna Kovac', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'vesna-kovac');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Tanja Zgradić (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'tanja-zgradic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tanja-zgradic', 'Tanja Zgradić', 'Тања Зградић', 'Таня Зградич', 'Tanja Zgradic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'tanja-zgradic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Sanja Čeprnić (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'sanja-ceprnic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sanja-ceprnic', 'Sanja Čeprnić', 'Сања Чепрнић', 'Саня Чепрнич', 'Sanja Ceprnic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'sanja-ceprnic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Sanja Topić (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'sanja-topic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sanja-topic', 'Sanja Topić', 'Сања Топић', 'Саня Топич', 'Sanja Topic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'sanja-topic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Nenad Jeremić (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'nenad-jeremic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nenad-jeremic', 'Nenad Jeremić', 'Ненад Јеремић', 'Ненад Еремич', 'Nenad Jeremic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'nenad-jeremic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Marija Stanišić (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'marija-stanisic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marija-stanisic', 'Marija Stanišić', 'Марија Станишић', 'Мария Станишич', 'Marija Stanisic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'marija-stanisic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Zinaida Miljković (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'zinaida-miljkovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zinaida-miljkovic', 'Zinaida Miljković', 'Зинаида Миљковић', 'Зинаида Милькович', 'Zinaida Miljkovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'zinaida-miljkovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Danka Krivokapić (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'danka-krivokapic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'danka-krivokapic', 'Danka Krivokapić', 'Данка Кривокапић', 'Данка Кривокапич', 'Danka Krivokapic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'danka-krivokapic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Tamara Piljević (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'tamara-piljevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tamara-piljevic', 'Tamara Piljević', 'Тамара Пиљевић', 'Тамара Пилевич', 'Tamara Piljevic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'tamara-piljevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Goran Komar (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'goran-komar');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'goran-komar', 'Goran Komar', 'Горан Комар', 'Горан Комар', 'Goran Komar', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'goran-komar');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Ana Popović (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'ana-popovic-2');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ana-popovic-2', 'Ana Popović', 'Ана Поповић', 'Ана Попович', 'Ana Popovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ana-popovic-2');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Alenka Srdanović (gynecology_obstetrics)
SET @d = (SELECT id FROM doctors WHERE slug = 'alenka-srdanovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'alenka-srdanovic', 'Alenka Srdanović', 'Аленка Срдановић', 'Аленка Срданович', 'Alenka Srdanovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'alenka-srdanovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gynecology_obstetrics') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor za žene' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Ana Džakula Dosković (gynecology_obstetrics)
SET @d = (SELECT id FROM doctors WHERE slug = 'ana-dzakula-doskovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ana-dzakula-doskovic', 'Ana Džakula Dosković', 'Ана Џакула Досковић', 'Ана Джакула Доскович', 'Ana Dzakula Doskovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ana-dzakula-doskovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gynecology_obstetrics') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor za žene' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Đorđe Daničić (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'djordje-danicic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'djordje-danicic', 'Đorđe Daničić', 'Ђорђе Даничић', 'Джордже Даничич', 'Djordje Danicic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'djordje-danicic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor, Ambulanta Igalo' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Ksenija Vasileva (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'ksenija-vasileva');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ksenija-vasileva', 'Ksenija Vasileva', 'Ксенија Василева', 'Ксения Васильева', 'Ksenija Vasileva', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ksenija-vasileva');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor, Ambulanta Bijela' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Gorčin Čvorović (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'gorcin-cvorovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'gorcin-cvorovic', 'Gorčin Čvorović', 'Горчин Чворовић', 'Горчин Чворович', 'Gorcin Cvorovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'gorcin-cvorovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Izabrani doktor, Ambulanta Bijela' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Darinka Kovačić (pulmonology)
SET @d = (SELECT id FROM doctors WHERE slug = 'darinka-kovacic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'darinka-kovacic', 'Darinka Kovačić', 'Даринка Ковачић', 'Даринка Ковачич', 'Darinka Kovacic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'darinka-kovacic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pulmonology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Pulmološka ambulanta' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Emilija Nikolić (pulmonology)
SET @d = (SELECT id FROM doctors WHERE slug = 'emilija-nikolic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'emilija-nikolic', 'Emilija Nikolić', 'Емилија Николић', 'Эмилия Николич', 'Emilija Nikolic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'emilija-nikolic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pulmonology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Pulmološka ambulanta' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Sanela Kusturica (psychiatry)
SET @d = (SELECT id FROM doctors WHERE slug = 'sanela-kusturica');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sanela-kusturica', 'Sanela Kusturica', 'Санела Кустурица', 'Санела Кустурица', 'Sanela Kusturica', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'sanela-kusturica');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Centar za mentalno zdravlje' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Jovica Dostinić (psychiatry)
SET @d = (SELECT id FROM doctors WHERE slug = 'jovica-dostinic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jovica-dostinic', 'Jovica Dostinić', 'Јовица Достинић', 'Йовица Достинич', 'Jovica Dostinic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'jovica-dostinic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Centar za mentalno zdravlje' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Igor Milinić (radiology)
SET @d = (SELECT id FROM doctors WHERE slug = 'igor-milinic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'igor-milinic', 'Igor Milinić', 'Игор Милинић', 'Игор Милинич', 'Igor Milinic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'igor-milinic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('radiology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'RTG i ultrazvučna dijagnostika' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Mladen Perčinkovski (radiology)
SET @d = (SELECT id FROM doctors WHERE slug = 'mladen-percinkovski');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mladen-percinkovski', 'Mladen Perčinkovski', 'Младен Перчинковски', 'Младен Перчинковски', 'Mladen Percinkovski', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'mladen-percinkovski');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('radiology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'RTG i ultrazvučna dijagnostika' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Milo Zgradić (microbiology)
SET @d = (SELECT id FROM doctors WHERE slug = 'milo-zgradic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milo-zgradic', 'Milo Zgradić', 'Мило Зградић', 'Мило Зградич', 'Milo Zgradic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'milo-zgradic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('microbiology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Mikrobiološka dijagnostika' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Stefa Glušac (infectious_diseases)
SET @d = (SELECT id FROM doctors WHERE slug = 'stefa-glusac');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'stefa-glusac', 'Stefa Glušac', 'Стефа Глушац', 'Стефа Глушац', 'Stefa Glusac', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'stefa-glusac');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('infectious_diseases') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Higijensko-epidemiološka služba' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Slađana Zgradić (infectious_diseases)
SET @d = (SELECT id FROM doctors WHERE slug = 'sladjana-zgradic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sladjana-zgradic', 'Slađana Zgradić', 'Слађана Зградић', 'Сладжана Зградич', 'Sladjana Zgradic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'sladjana-zgradic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('infectious_diseases') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Higijensko-epidemiološka služba' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Gordana Miludinović Stojanović (internal_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'gordana-miludinovic-stojanovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'gordana-miludinovic-stojanovic', 'Gordana Miludinović Stojanović', 'Гордана Милудиновић Стојановић', 'Гордана Милудинович Стоянович', 'Gordana Miludinovic Stojanovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'gordana-miludinovic-stojanovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('internal_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Internistička ambulanta' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Danijela Ranđelović (internal_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'danijela-randjelovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'danijela-randjelovic', 'Danijela Ranđelović', 'Данијела Ранђеловић', 'Даниела Ранджелович', 'Danijela Randjelovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'danijela-randjelovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('internal_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Internistička ambulanta' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Gordana Rajović (internal_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'gordana-rajovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'gordana-rajovic', 'Gordana Rajović', 'Гордана Рајовић', 'Гордана Райович', 'Gordana Rajovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'gordana-rajovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('internal_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Internistička ambulanta' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Nenad Sekulić (general_surgery)
SET @d = (SELECT id FROM doctors WHERE slug = 'nenad-sekulic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nenad-sekulic', 'Nenad Sekulić', 'Ненад Секулић', 'Ненад Секулич', 'Nenad Sekulic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'nenad-sekulic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_surgery') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Hirurška ambulanta' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Ljiljana Maksimović (ophthalmology)
SET @d = (SELECT id FROM doctors WHERE slug = 'ljiljana-maksimovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ljiljana-maksimovic', 'Ljiljana Maksimović', 'Љиљана Максимовић', 'Лиляна Максимович', 'Ljiljana Maksimovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ljiljana-maksimovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('ophthalmology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Oftalmološka ambulanta' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Aleksandra Kolundžić (occupational_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'aleksandra-kolundzic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aleksandra-kolundzic', 'Aleksandra Kolundžić', 'Александра Колунџић', 'Александра Колунджич', 'Aleksandra Kolundzic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'aleksandra-kolundzic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('occupational_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Medicina rada' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Jasmina Živković (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'jasmina-zivkovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jasmina-zivkovic', 'Jasmina Živković', 'Јасмина Живковић', 'Ясмина Живкович', 'Jasmina Zivkovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'jasmina-zivkovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Sportska medicina' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Biljana Dapčević (nephrology)
SET @d = (SELECT id FROM doctors WHERE slug = 'biljana-dapcevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'biljana-dapcevic', 'Biljana Dapčević', 'Биљана Дапчевић', 'Биляна Дапчевич', 'Biljana Dapcevic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'biljana-dapcevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('nephrology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Odjeljenje hemodijalize' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Filip Rajčević (speech_therapy)
SET @d = (SELECT id FROM doctors WHERE slug = 'filip-rajcevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'filip-rajcevic', 'Filip Rajčević', 'Филип Рајчевић', 'Филип Райчевич', 'Filip Rajcevic', NULL, NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'filip-rajcevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('speech_therapy') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Logoped, Centar za djecu sa posebnim potrebama' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Nikolina Tišma Knežić (speech_therapy)
SET @d = (SELECT id FROM doctors WHERE slug = 'nikolina-tisma-knezic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nikolina-tisma-knezic', 'Nikolina Tišma Knežić', 'Николина Тишма Кнежић', 'Николина Тишма Кнежич', 'Nikolina Tisma Knezic', NULL, NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'nikolina-tisma-knezic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('speech_therapy') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Logoped, Centar za djecu sa posebnim potrebama' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Jelena Pejović (psychology)
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-pejovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jelena-pejovic', 'Jelena Pejović', 'Јелена Пејовић', 'Елена Пейович', 'Jelena Pejovic', NULL, NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-pejovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Psiholog, Centar za djecu sa posebnim potrebama' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- Valentina Buha (Physiotherapy)
SET @d = (SELECT id FROM doctors WHERE slug = 'valentina-buha');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'valentina-buha', 'Valentina Buha', 'Валентина Буха', 'Валентина Буха', 'Valentina Buha', NULL, NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'valentina-buha');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('Physiotherapy') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_hn, 'Bobath terapeut, Jedinica za fizikalnu terapiju' FROM dual WHERE @d IS NOT NULL AND @c_hn IS NOT NULL;

-- ─── DZ Budva ───

-- Sandra Bošković (pediatrics)
SET @d = (SELECT id FROM doctors WHERE slug = 'sandra-boskovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sandra-boskovic', 'Sandra Bošković', 'Сандра Бошковић', 'Сандра Бошкович', 'Sandra Boskovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'sandra-boskovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_bd, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @c_bd IS NOT NULL;

-- Dželadina Velinov (clinical_biochemistry)
SET @d = (SELECT id FROM doctors WHERE slug = 'dzeladina-velinov');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dzeladina-velinov', 'Dželadina Velinov', 'Џеладина Велинов', 'Джеладина Велинов', 'Dzeladina Velinov', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'dzeladina-velinov');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('clinical_biochemistry') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_bd, 'Biohemijska laboratorija' FROM dual WHERE @d IS NOT NULL AND @c_bd IS NOT NULL;

-- Bojan Vučinić (radiology)
SET @d = (SELECT id FROM doctors WHERE slug = 'bojan-vucinic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'bojan-vucinic', 'Bojan Vučinić', 'Бојан Вучинић', 'Боян Вучинич', 'Bojan Vucinic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'bojan-vucinic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('radiology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_bd, 'Centar za RTG i UZ dijagnostiku' FROM dual WHERE @d IS NOT NULL AND @c_bd IS NOT NULL;

-- ─── DZ Tivat ───

-- Nada Kovačević (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'nada-kovacevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nada-kovacevic', 'Nada Kovačević', 'Нада Ковачевић', 'Нада Ковачевич', 'Nada Kovacevic', 'Prim. dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'nada-kovacevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_tv, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_tv IS NOT NULL;

-- Ljiljana Soković (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'ljiljana-sokovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ljiljana-sokovic', 'Ljiljana Soković', 'Љиљана Соковић', 'Лиляна Сокович', 'Ljiljana Sokovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ljiljana-sokovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_tv, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_tv IS NOT NULL;

-- Sanela Preljević Gašanin (pediatrics)
SET @d = (SELECT id FROM doctors WHERE slug = 'sanela-preljevic-gasanin');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sanela-preljevic-gasanin', 'Sanela Preljević Gašanin', 'Санела Прељевић Гашанин', 'Санела Прелевич Гашанин', 'Sanela Preljevic Gasanin', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'sanela-preljevic-gasanin');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_tv, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @c_tv IS NOT NULL;

-- ─── DZ Bar ───

-- Sonja Mitrović (pulmonology)
SET @d = (SELECT id FROM doctors WHERE slug = 'sonja-mitrovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sonja-mitrovic', 'Sonja Mitrović', 'Соња Митровић', 'Соня Митрович', 'Sonja Mitrovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'sonja-mitrovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pulmonology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_bar, 'Centar za plućne bolesti i TBC' FROM dual WHERE @d IS NOT NULL AND @c_bar IS NOT NULL;

-- ─── DZ Bijelo Polje ───

-- Slobodan Nanevski (microbiology)
SET @d = (SELECT id FROM doctors WHERE slug = 'slobodan-nanevski');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'slobodan-nanevski', 'Slobodan Nanevski', 'Слободан Наневски', 'Слободан Наневски', 'Slobodan Nanevski', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'slobodan-nanevski');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('microbiology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_bp, 'Mikrobiološka laboratorija' FROM dual WHERE @d IS NOT NULL AND @c_bp IS NOT NULL;

-- ─── DZ Mojkovac ───

-- Milovan Bogavac (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'milovan-bogavac');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milovan-bogavac', 'Milovan Bogavac', 'Милован Богавац', 'Милован Богавац', 'Milovan Bogavac', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'milovan-bogavac');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_mk, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_mk IS NOT NULL;

-- Nataša Tmušić Bogavac (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'natasa-tmusic-bogavac');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'natasa-tmusic-bogavac', 'Nataša Tmušić Bogavac', 'Наташа Тмушић Богавац', 'Наташа Тмушич Богавац', 'Natasa Tmusic Bogavac', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'natasa-tmusic-bogavac');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_mk, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_mk IS NOT NULL;

-- Marko Blažević (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'marko-blazevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marko-blazevic', 'Marko Blažević', 'Марко Блажевић', 'Марко Блажевич', 'Marko Blazevic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'marko-blazevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_mk, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_mk IS NOT NULL;

-- Sanja Baković Barac (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'sanja-bakovic-barac');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sanja-bakovic-barac', 'Sanja Baković Barac', 'Сања Баковић Барац', 'Саня Бакович Барац', 'Sanja Bakovic Barac', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'sanja-bakovic-barac');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_mk, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_mk IS NOT NULL;

-- Sanja Ćetković (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'sanja-cetkovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sanja-cetkovic', 'Sanja Ćetković', 'Сања Ћетковић', 'Саня Четкович', 'Sanja Cetkovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'sanja-cetkovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_mk, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_mk IS NOT NULL;

-- Miloje Zejak (pediatrics)
SET @d = (SELECT id FROM doctors WHERE slug = 'miloje-zejak');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'miloje-zejak', 'Miloje Zejak', 'Милоје Зејак', 'Милое Зеяк', 'Miloje Zejak', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'miloje-zejak');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_mk, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @c_mk IS NOT NULL;

-- Maja Vujisić (gynecology_obstetrics)
SET @d = (SELECT id FROM doctors WHERE slug = 'maja-vujisic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'maja-vujisic', 'Maja Vujisić', 'Маја Вујисић', 'Мая Вуйисич', 'Maja Vujisic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'maja-vujisic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gynecology_obstetrics') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_mk, 'Direktorica; izabrani doktor za žene' FROM dual WHERE @d IS NOT NULL AND @c_mk IS NOT NULL;

-- Tijana Stanić (psychology)
SET @d = (SELECT id FROM doctors WHERE slug = 'tijana-stanic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tijana-stanic', 'Tijana Stanić', 'Тијана Станић', 'Тияна Станич', 'Tijana Stanic', NULL, NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'tijana-stanic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_mk, 'Psiholog, Centar za mentalno zdravlje' FROM dual WHERE @d IS NOT NULL AND @c_mk IS NOT NULL;

-- ─── DZ Kolašin ───

-- Radovan Selić (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'radovan-selic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'radovan-selic', 'Radovan Selić', 'Радован Селић', 'Радован Селич', 'Radovan Selic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'radovan-selic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_kl, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_kl IS NOT NULL;

-- Ksenija Popović (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'ksenija-popovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ksenija-popovic', 'Ksenija Popović', 'Ксенија Поповић', 'Ксения Попович', 'Ksenija Popovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ksenija-popovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_kl, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_kl IS NOT NULL;

-- Milena Lalić (family_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'milena-lalic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milena-lalic', 'Milena Lalić', 'Милена Лалић', 'Милена Лалич', 'Milena Lalic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'milena-lalic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('family_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_kl, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_kl IS NOT NULL;

-- Jadranka Vučinić (family_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'jadranka-vucinic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jadranka-vucinic', 'Jadranka Vučinić', 'Јадранка Вучинић', 'Ядранка Вучинич', 'Jadranka Vucinic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'jadranka-vucinic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('family_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_kl, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_kl IS NOT NULL;

-- Danka Marković (gynecology_obstetrics, general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'danka-markovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'danka-markovic', 'Danka Marković', 'Данка Марковић', 'Данка Маркович', 'Danka Markovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'danka-markovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gynecology_obstetrics', 'general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_kl, 'Izabrani doktor za žene' FROM dual WHERE @d IS NOT NULL AND @c_kl IS NOT NULL;

-- Ivan Đurović (gynecology_obstetrics)
SET @d = (SELECT id FROM doctors WHERE slug = 'ivan-djurovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivan-djurovic', 'Ivan Đurović', 'Иван Ђуровић', 'Иван Джурович', 'Ivan Djurovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ivan-djurovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gynecology_obstetrics') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_kl, 'Izabrani doktor za žene' FROM dual WHERE @d IS NOT NULL AND @c_kl IS NOT NULL;

-- Nikola Damjanović (radiology)
SET @d = (SELECT id FROM doctors WHERE slug = 'nikola-damjanovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nikola-damjanovic', 'Nikola Damjanović', 'Никола Дамјановић', 'Никола Дамьянович', 'Nikola Damjanovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'nikola-damjanovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('radiology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_kl, 'Centar za RTG i UZ dijagnostiku' FROM dual WHERE @d IS NOT NULL AND @c_kl IS NOT NULL;

-- ─── DZ Andrijevica ───

-- Anđelija Popović (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'andjelija-popovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'andjelija-popovic', 'Anđelija Popović', 'Анђелија Поповић', 'Анджелия Попович', 'Andjelija Popovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'andjelija-popovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_an, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_an IS NOT NULL;

-- Veselinka Paunović (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'veselinka-paunovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'veselinka-paunovic', 'Veselinka Paunović', 'Веселинка Пауновић', 'Веселинка Паунович', 'Veselinka Paunovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'veselinka-paunovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_an, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_an IS NOT NULL;

-- Džemail Gilić (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'dzemail-gilic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dzemail-gilic', 'Džemail Gilić', 'Џемаил Гилић', 'Джемаил Гилич', 'Dzemail Gilic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'dzemail-gilic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_an, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_an IS NOT NULL;

-- Danijela Đekić (pediatrics)
SET @d = (SELECT id FROM doctors WHERE slug = 'danijela-djekic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'danijela-djekic', 'Danijela Đekić', 'Данијела Ђекић', 'Даниела Джекич', 'Danijela Djekic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'danijela-djekic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_an, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @c_an IS NOT NULL;

-- Jugoslav Račić (gynecology_obstetrics)
SET @d = (SELECT id FROM doctors WHERE slug = 'jugoslav-racic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jugoslav-racic', 'Jugoslav Račić', 'Југослав Рачић', 'Югослав Рачич', 'Jugoslav Racic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'jugoslav-racic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gynecology_obstetrics') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_an, 'Izabrani doktor za žene' FROM dual WHERE @d IS NOT NULL AND @c_an IS NOT NULL;

-- ─── DZ Kotor ───

-- Aleksandar Stjepčević (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'aleksandar-stjepcevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aleksandar-stjepcevic', 'Aleksandar Stjepčević', 'Александар Стјепчевић', 'Александар Стьепчевич', 'Aleksandar Stjepcevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'aleksandar-stjepcevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_kt, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_kt IS NOT NULL;

-- Anela Moco (general_medicine)
SET @d = (SELECT id FROM doctors WHERE slug = 'anela-moco');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'anela-moco', 'Anela Moco', 'Анела Моцо', 'Анела Моцо', 'Anela Moco', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'anela-moco');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_kt, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @c_kt IS NOT NULL;

-- Dijana Božović (Physiotherapy)
SET @d = (SELECT id FROM doctors WHERE slug = 'dijana-bozovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dijana-bozovic', 'Dijana Božović', 'Дијана Божовић', 'Дияна Божович', 'Dijana Bozovic', NULL, NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'dijana-bozovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('Physiotherapy') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @c_kt, 'Fizioterapeut, Jedinica za fizikalnu terapiju' FROM dual WHERE @d IS NOT NULL AND @c_kt IS NOT NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- врачей по клиникам после применения
SELECT c.slug, COUNT(dc.id) AS doctors FROM clinics c LEFT JOIN doctor_clinics dc ON dc.clinic_id = c.id
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-budva', 'dom-zdravlja-tivat', 'dom-zdravlja-bar', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad', 'dom-zdravlja-bijelo-polje', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-andrijevica', 'dom-zdravlja-kotor') GROUP BY c.slug ORDER BY c.slug;

-- отвязанные, но всё ещё привязанные (ожидается: пусто)
SELECT x.clinic, x.slug FROM (SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'ana-penda' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'darko-topic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'milos-milic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'milovan-radosavljevic' AS slug UNION ALL SELECT 'dom-zdravlja-budva' AS clinic, 'ana-penda' AS slug UNION ALL SELECT 'dom-zdravlja-budva' AS clinic, 'lidija-krtolica' AS slug UNION ALL SELECT 'dom-zdravlja-budva' AS clinic, 'sladjana-strahinic' AS slug UNION ALL SELECT 'dom-zdravlja-budva' AS clinic, 'vesna-milutinovic' AS slug UNION ALL SELECT 'dom-zdravlja-budva' AS clinic, 'veselin-vusurovic' AS slug UNION ALL SELECT 'dom-zdravlja-tivat' AS clinic, 'ana-penda' AS slug UNION ALL SELECT 'dom-zdravlja-tivat' AS clinic, 'bojan-vucetic' AS slug UNION ALL SELECT 'dom-zdravlja-tivat' AS clinic, 'igor-bjeladinovic' AS slug UNION ALL SELECT 'dom-zdravlja-tivat' AS clinic, 'jelena-pajcin' AS slug UNION ALL SELECT 'dom-zdravlja-tivat' AS clinic, 'jelena-perunovic' AS slug UNION ALL SELECT 'dom-zdravlja-tivat' AS clinic, 'lidija-krtolica' AS slug UNION ALL SELECT 'dom-zdravlja-tivat' AS clinic, 'milica-vusurovic' AS slug UNION ALL SELECT 'dom-zdravlja-tivat' AS clinic, 'nevenka-becir' AS slug UNION ALL SELECT 'dom-zdravlja-tivat' AS clinic, 'svetlana-slavkovic' AS slug) x
JOIN doctors d ON d.slug = x.slug JOIN clinics c ON c.slug = x.clinic
JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = c.id;

-- ожидаемые привязки, которых нет (ожидается: пусто)
SELECT x.clinic, x.slug FROM (SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'oliver-adrovic' AS slug UNION ALL SELECT 'dom-zdravlja-kotor' AS clinic, 'masanovic-kristina' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'maja-popovic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'natasa-milovic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'dragan-maksimovic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'dragana-knezevic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'olivera-mentovic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'vesna-kovac' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'tanja-zgradic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'sanja-ceprnic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'sanja-topic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'nenad-jeremic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'marija-stanisic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'zinaida-miljkovic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'danka-krivokapic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'tamara-piljevic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'goran-komar' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'ana-popovic-2' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'alenka-srdanovic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'ana-dzakula-doskovic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'djordje-danicic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'ksenija-vasileva' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'gorcin-cvorovic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'darinka-kovacic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'emilija-nikolic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'sanela-kusturica' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'jovica-dostinic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'igor-milinic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'mladen-percinkovski' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'milo-zgradic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'stefa-glusac' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'sladjana-zgradic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'gordana-miludinovic-stojanovic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'danijela-randjelovic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'gordana-rajovic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'nenad-sekulic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'ljiljana-maksimovic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'aleksandra-kolundzic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'jasmina-zivkovic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'biljana-dapcevic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'filip-rajcevic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'nikolina-tisma-knezic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'jelena-pejovic' AS slug UNION ALL SELECT 'dom-zdravlja-herceg-novi' AS clinic, 'valentina-buha' AS slug UNION ALL SELECT 'dom-zdravlja-budva' AS clinic, 'sandra-boskovic' AS slug UNION ALL SELECT 'dom-zdravlja-budva' AS clinic, 'dzeladina-velinov' AS slug UNION ALL SELECT 'dom-zdravlja-budva' AS clinic, 'bojan-vucinic' AS slug UNION ALL SELECT 'dom-zdravlja-tivat' AS clinic, 'nada-kovacevic' AS slug UNION ALL SELECT 'dom-zdravlja-tivat' AS clinic, 'ljiljana-sokovic' AS slug UNION ALL SELECT 'dom-zdravlja-tivat' AS clinic, 'sanela-preljevic-gasanin' AS slug UNION ALL SELECT 'dom-zdravlja-bar' AS clinic, 'sonja-mitrovic' AS slug UNION ALL SELECT 'dom-zdravlja-bijelo-polje' AS clinic, 'slobodan-nanevski' AS slug UNION ALL SELECT 'dom-zdravlja-bosko-dedeic-mojkovac' AS clinic, 'milovan-bogavac' AS slug UNION ALL SELECT 'dom-zdravlja-bosko-dedeic-mojkovac' AS clinic, 'natasa-tmusic-bogavac' AS slug UNION ALL SELECT 'dom-zdravlja-bosko-dedeic-mojkovac' AS clinic, 'marko-blazevic' AS slug UNION ALL SELECT 'dom-zdravlja-bosko-dedeic-mojkovac' AS clinic, 'sanja-bakovic-barac' AS slug UNION ALL SELECT 'dom-zdravlja-bosko-dedeic-mojkovac' AS clinic, 'sanja-cetkovic' AS slug UNION ALL SELECT 'dom-zdravlja-bosko-dedeic-mojkovac' AS clinic, 'miloje-zejak' AS slug UNION ALL SELECT 'dom-zdravlja-bosko-dedeic-mojkovac' AS clinic, 'maja-vujisic' AS slug UNION ALL SELECT 'dom-zdravlja-bosko-dedeic-mojkovac' AS clinic, 'tijana-stanic' AS slug UNION ALL SELECT 'dom-zdravlja-kolasin' AS clinic, 'radovan-selic' AS slug UNION ALL SELECT 'dom-zdravlja-kolasin' AS clinic, 'ksenija-popovic' AS slug UNION ALL SELECT 'dom-zdravlja-kolasin' AS clinic, 'milena-lalic' AS slug UNION ALL SELECT 'dom-zdravlja-kolasin' AS clinic, 'jadranka-vucinic' AS slug UNION ALL SELECT 'dom-zdravlja-kolasin' AS clinic, 'danka-markovic' AS slug UNION ALL SELECT 'dom-zdravlja-kolasin' AS clinic, 'ivan-djurovic' AS slug UNION ALL SELECT 'dom-zdravlja-kolasin' AS clinic, 'nikola-damjanovic' AS slug UNION ALL SELECT 'dom-zdravlja-andrijevica' AS clinic, 'andjelija-popovic' AS slug UNION ALL SELECT 'dom-zdravlja-andrijevica' AS clinic, 'veselinka-paunovic' AS slug UNION ALL SELECT 'dom-zdravlja-andrijevica' AS clinic, 'dzemail-gilic' AS slug UNION ALL SELECT 'dom-zdravlja-andrijevica' AS clinic, 'danijela-djekic' AS slug UNION ALL SELECT 'dom-zdravlja-andrijevica' AS clinic, 'jugoslav-racic' AS slug UNION ALL SELECT 'dom-zdravlja-kotor' AS clinic, 'aleksandar-stjepcevic' AS slug UNION ALL SELECT 'dom-zdravlja-kotor' AS clinic, 'anela-moco' AS slug UNION ALL SELECT 'dom-zdravlja-kotor' AS clinic, 'dijana-bozovic' AS slug) x
LEFT JOIN doctors d ON d.slug = x.slug LEFT JOIN clinics c ON c.slug = x.clinic
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = c.id WHERE dc.id IS NULL;

-- новые врачи без специальности или языка (ожидается: пусто)
SELECT d.slug FROM doctors d WHERE d.slug IN ('maja-popovic', 'natasa-milovic', 'dragan-maksimovic', 'dragana-knezevic', 'olivera-mentovic', 'vesna-kovac', 'tanja-zgradic', 'sanja-ceprnic', 'sanja-topic', 'nenad-jeremic', 'marija-stanisic', 'zinaida-miljkovic', 'danka-krivokapic', 'tamara-piljevic', 'goran-komar', 'ana-popovic-2', 'alenka-srdanovic', 'ana-dzakula-doskovic', 'djordje-danicic', 'ksenija-vasileva', 'gorcin-cvorovic', 'darinka-kovacic', 'emilija-nikolic', 'sanela-kusturica', 'jovica-dostinic', 'igor-milinic', 'mladen-percinkovski', 'milo-zgradic', 'stefa-glusac', 'sladjana-zgradic', 'gordana-miludinovic-stojanovic', 'danijela-randjelovic', 'gordana-rajovic', 'nenad-sekulic', 'ljiljana-maksimovic', 'aleksandra-kolundzic', 'jasmina-zivkovic', 'biljana-dapcevic', 'filip-rajcevic', 'nikolina-tisma-knezic', 'jelena-pejovic', 'valentina-buha', 'sandra-boskovic', 'dzeladina-velinov', 'bojan-vucinic', 'nada-kovacevic', 'ljiljana-sokovic', 'sanela-preljevic-gasanin', 'sonja-mitrovic', 'slobodan-nanevski', 'milovan-bogavac', 'natasa-tmusic-bogavac', 'marko-blazevic', 'sanja-bakovic-barac', 'sanja-cetkovic', 'miloje-zejak', 'maja-vujisic', 'tijana-stanic', 'radovan-selic', 'ksenija-popovic', 'milena-lalic', 'jadranka-vucinic', 'danka-markovic', 'ivan-djurovic', 'nikola-damjanovic', 'andjelija-popovic', 'veselinka-paunovic', 'dzemail-gilic', 'danijela-djekic', 'jugoslav-racic', 'aleksandar-stjepcevic', 'anela-moco', 'dijana-bozovic')
  AND (NOT EXISTS (SELECT 1 FROM doctor_specialties ds WHERE ds.doctor_id = d.id)
       OR NOT EXISTS (SELECT 1 FROM doctor_languages dl WHERE dl.doctor_id = d.id));
