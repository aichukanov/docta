SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
-- Klinički centar Crne Gore (slug klinicki-centar-crne-gore-podgorica): sinhronizacija ljekara sa sajtom kccg.me
-- Izvor: wp-json/wp/v2/pages (102 stranice, preuzeto 2026-10-06): /poliklinika/* (rasporedi ambulanti),
--        /klinike-i-centri/* (kontakt-blokovi rukovodilaca), /o-nama/.
-- Samo dodavanje (siteOnly). Odvezivanja NEMA: dbOnlyCaveat — bolnički ljekari bez ambulante se ne objavljuju.
-- Klinika, ljekari i specijalnosti — samo po slug / name (id lokalno i na produ se razlikuju).
-- Idempotentno: drugi prolaz ne mijenja ništa.
-- Odluke: data/clinic-teams/decisions/kccg.md

SET @clinic = (SELECT id FROM clinics WHERE slug = 'klinicki-centar-crne-gore-podgorica');

-- ═══════════════════════════════════════════════════════════════
-- 1. Postojeći ljekari (već u bazi kod drugih klinika) — samo vezivanje za KCCG (18)
-- ═══════════════════════════════════════════════════════════════

SET @d = (SELECT id FROM doctors WHERE slug = 'danko-natalic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Klinika za ginekologiju i akušerstvo, Centar za patologiju trudnoće, načelnik' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

SET @d = (SELECT id FROM doctors WHERE slug = 'zanka-cerovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za radiološku dijagnostiku, Odjeljenje za CT i MR dijagnostiku, načelnica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

SET @d = (SELECT id FROM doctors WHERE slug = 'muhedin-kadic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Institut za bolesti djece, Operacioni blok, načelnik; Ambulanta za ORL' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

SET @d = (SELECT id FROM doctors WHERE slug = 'dragan-nesovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Institut za bolesti djece, Odjeljenje za radiološku dijagnostiku, načelnik' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

SET @d = (SELECT id FROM doctors WHERE slug = 'dijana-asanovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Klinika za kardiologiju, VD direktorica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

SET @d = (SELECT id FROM doctors WHERE slug = 'bozovic-bjanka');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Klinika za kardiologiju, Odjeljenje poluintenzivne njege, načelnica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

SET @d = (SELECT id FROM doctors WHERE slug = 'mihailo-vukmirovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Klinika za kardiologiju, Odjeljenje za poremećaje srčanog ritma i elektrofiziologiju srca, načelnik' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

SET @d = (SELECT id FROM doctors WHERE slug = 'gordana-globarevic-vukcevic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Klinika za ginekologiju i akušerstvo, Porodilište, načelnica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-paunovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Klinika za ginekologiju i akušerstvo, Akušersko odjeljenje, načelnica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

SET @d = (SELECT id FROM doctors WHERE slug = 'milorada-nesovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Klinika za ginekologiju i akušerstvo, Odjeljenje neonatologije, načelnica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

SET @d = (SELECT id FROM doctors WHERE slug = 'milos-obradovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Klinika za ginekologiju i akušerstvo, Odjeljenje za ginekološku patologiju, načelnik' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

SET @d = (SELECT id FROM doctors WHERE slug = 'marija-abramovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za radiološku dijagnostiku, Odjeljenje za konvencionalnu radiološku dijagnostiku, načelnica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

SET @d = (SELECT id FROM doctors WHERE slug = 'vojislav-mandic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za radiološku dijagnostiku, Odjeljenje za dijagnostiku bolesti dojki, načelnik' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

SET @d = (SELECT id FROM doctors WHERE slug = 'dragomir-madzgalj');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Poliklinika KCCG, Gastroenterohepatološka ambulanta' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

SET @d = (SELECT id FROM doctors WHERE slug = 'nikola-delevic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Poliklinika KCCG, Alergološka ambulanta' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-borovinic-bojovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Poliklinika KCCG, Pulmološka ambulanta' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

SET @d = (SELECT id FROM doctors WHERE slug = 'aleksandra-furtula');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Poliklinika KCCG, Endokrinološka ambulanta' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

SET @d = (SELECT id FROM doctors WHERE slug = 'miladinovic-mirjana');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za patologiju, VD direktorica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;


-- ═══════════════════════════════════════════════════════════════
-- 2. Novi ljekari (47) — "nađi ili napravi" (ime, obrnuto ime, slug),
--    zatim specijalnosti, srpski jezik, vezivanje za KCCG
-- ═══════════════════════════════════════════════════════════════

-- Olivera Miljanović — genetics
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Olivera Miljanović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Miljanović Olivera' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'olivera-miljanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'olivera-miljanovic', 'Olivera Miljanović', 'Оливера Миљановић', 'Оливера Мильянович', 'Olivera Miljanovic', 'Prof. dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('genetics');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za medicinsku genetiku i imunologiju, direktorica; genetička ambulanta' FROM dual WHERE @clinic IS NOT NULL;

-- Jelena Jovanović — genetics
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Jelena Jovanović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Jovanović Jelena' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jelena-jovanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jelena-jovanovic', 'Jelena Jovanović', 'Јелена Јовановић', 'Елена Йованович', 'Jelena Jovanovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('genetics');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za medicinsku genetiku i imunologiju, Odjeljenje za kliničku genetiku, načelnica; genetička ambulanta' FROM dual WHERE @clinic IS NOT NULL;

-- Gordana Stojanović — genetics, immunology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Gordana Stojanović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Stojanović Gordana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'gordana-stojanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'gordana-stojanovic', 'Gordana Stojanović', 'Гордана Стојановић', 'Гордана Стоянович', 'Gordana Stojanovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('genetics', 'immunology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Poliklinika KCCG, genetička ambulanta za trudnice' FROM dual WHERE @clinic IS NOT NULL;

-- Tamara Jovićević — immunology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Tamara Jovićević' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Jovićević Tamara' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'tamara-jovicevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tamara-jovicevic', 'Tamara Jovićević', 'Тамара Јовићевић', 'Тамара Йовичевич', 'Tamara Jovicevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('immunology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za medicinsku genetiku i imunologiju, Odjeljenje za kliničku imunologiju, načelnica' FROM dual WHERE @clinic IS NOT NULL;

-- Dagan Račić — anesthesiology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Dagan Račić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Račić Dagan' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'dagan-racic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dagan-racic', 'Dagan Račić', 'Даган Рачић', 'Даган Рачич', 'Dagan Racic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('anesthesiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Institut za bolesti djece, Odjeljenje za anesteziju i reanimaciju, načelnik' FROM dual WHERE @clinic IS NOT NULL;

-- Olja Manđarelo — clinical_biochemistry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Olja Manđarelo' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Manđarelo Olja' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'olja-mandjarelo' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'olja-mandjarelo', 'Olja Manđarelo', 'Оља Манђарело', 'Олья Манджарело', 'Olja Mandjarelo', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('clinical_biochemistry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Institut za bolesti djece, Odjeljenje za laboratorijsku dijagnostiku, načelnica' FROM dual WHERE @clinic IS NOT NULL;

-- Maša Raonić — pediatrics
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Maša Raonić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Raonić Maša' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'masa-raonic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'masa-raonic', 'Maša Raonić', 'Маша Раонић', 'Маша Раонич', 'Masa Raonic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Institut za bolesti djece, Prijemna ambulanta sa dnevnom bolnicom i odjeljenje za opservaciju, načelnica' FROM dual WHERE @clinic IS NOT NULL;

-- Lidija Banjac — pediatrics, neonatology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Lidija Banjac' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Banjac Lidija' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'lidija-banjac' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'lidija-banjac', 'Lidija Banjac', 'Лидија Бањац', 'Лидия Баняц', 'Lidija Banjac', 'Doc. prim. dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics', 'neonatology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Institut za bolesti djece, Centar za neonatologiju, načelnica' FROM dual WHERE @clinic IS NOT NULL;

-- Mirjana Đurović — radiology, oncology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Mirjana Đurović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Đurović Mirjana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'mirjana-djurovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mirjana-djurovic', 'Mirjana Đurović', 'Мирјана Ђуровић', 'Мирьяна Джурович', 'Mirjana Djurovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('radiology', 'oncology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Institut za onkologiju, Odjeljenje za brahiterapiju, načelnica' FROM dual WHERE @clinic IS NOT NULL;

-- Nebojša Brnović — emergency_medicine
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Nebojša Brnović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Brnović Nebojša' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'nebojsa-brnovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nebojsa-brnovic', 'Nebojša Brnović', 'Небојша Брновић', 'Небойша Брнович', 'Nebojsa Brnovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('emergency_medicine');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Urgentni centar, direktor' FROM dual WHERE @clinic IS NOT NULL;

-- Aleksandra Boljević — cardiology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Aleksandra Boljević' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Boljević Aleksandra' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'aleksandra-boljevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aleksandra-boljevic', 'Aleksandra Boljević', 'Александра Бољевић', 'Александра Больевич', 'Aleksandra Boljevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('cardiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Klinika za kardiologiju, Odjeljenje za kardiologiju, načelnica' FROM dual WHERE @clinic IS NOT NULL;

-- Siniša Dragnić — cardiology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Siniša Dragnić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Dragnić Siniša' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'sinisa-dragnic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sinisa-dragnic', 'Siniša Dragnić', 'Синиша Драгнић', 'Синиша Драгнич', 'Sinisa Dragnic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('cardiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Klinika za kardiologiju, Centar za interventnu kardiologiju, načelnik' FROM dual WHERE @clinic IS NOT NULL;

-- Jelena Kovačević — psychiatry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Jelena Kovačević' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Kovačević Jelena' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jelena-kovacevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jelena-kovacevic', 'Jelena Kovačević', 'Јелена Ковачевић', 'Елена Ковачевич', 'Jelena Kovacevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Klinika za psihijatriju, Odjeljenje integrisanog dnevnog tretmana djece i adolescenata, načelnica' FROM dual WHERE @clinic IS NOT NULL;

-- Iva Ivanović — psychiatry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Iva Ivanović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ivanović Iva' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'iva-ivanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'iva-ivanovic', 'Iva Ivanović', 'Ива Ивановић', 'Ива Иванович', 'Iva Ivanovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za rani razvoj, direktorica' FROM dual WHERE @clinic IS NOT NULL;

-- Goran Lazarević — gynecology_obstetrics
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Goran Lazarević' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Lazarević Goran' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'goran-lazarevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'goran-lazarevic', 'Goran Lazarević', 'Горан Лазаревић', 'Горан Лазаревич', 'Goran Lazarevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gynecology_obstetrics');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Klinika za ginekologiju i akušerstvo, direktor' FROM dual WHERE @clinic IS NOT NULL;

-- Saša Raičević — gynecology_obstetrics
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Saša Raičević' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Raičević Saša' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'sasa-raicevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sasa-raicevic', 'Saša Raičević', 'Саша Раичевић', 'Саша Раичевич', 'Sasa Raicevic', 'Prof. dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gynecology_obstetrics');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Član Odbora direktora (predstavnik zaposlenih)' FROM dual WHERE @clinic IS NOT NULL;

-- Natalija Trninić — anesthesiology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Natalija Trninić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Trninić Natalija' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'natalija-trninic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'natalija-trninic', 'Natalija Trninić', 'Наталија Трнинић', 'Наталия Трнинич', 'Natalija Trninic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('anesthesiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Klinika za anesteziju, intenzivnu terapiju i terapiju bola, direktorka' FROM dual WHERE @clinic IS NOT NULL;

-- Elma Kolić Salković — anesthesiology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Elma Kolić Salković' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Kolić Salković Elma' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'elma-kolic-salkovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'elma-kolic-salkovic', 'Elma Kolić Salković', 'Елма Колић Салковић', 'Эльма Колич Салкович', 'Elma Kolic Salkovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('anesthesiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Klinika za anesteziju, intenzivnu terapiju i terapiju bola, Odjeljenje za anesteziju, načelnica' FROM dual WHERE @clinic IS NOT NULL;

-- Ivana Đurišić — anesthesiology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Ivana Đurišić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Đurišić Ivana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ivana-djurisic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivana-djurisic', 'Ivana Đurišić', 'Ивана Ђуришић', 'Ивана Джуришич', 'Ivana Djurisic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('anesthesiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Klinika za anesteziju, intenzivnu terapiju i terapiju bola, Odjeljenje centralne intenzivne terapije, načelnica' FROM dual WHERE @clinic IS NOT NULL;

-- Kemal Šahmanović — dentistry, pediatric_dentistry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Kemal Šahmanović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Šahmanović Kemal' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'kemal-sahmanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'kemal-sahmanovic', 'Kemal Šahmanović', 'Кемал Шахмановић', 'Кемаль Шахманович', 'Kemal Sahmanovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('dentistry', 'pediatric_dentistry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Stomatološka poliklinika, VD direktor; Odjeljenje dječje i preventivne stomatologije, načelnik' FROM dual WHERE @clinic IS NOT NULL;

-- Dženad Ganjola — oral_surgery
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Dženad Ganjola' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ganjola Dženad' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'dzenad-ganjola' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dzenad-ganjola', 'Dženad Ganjola', 'Џенад Гањола', 'Дженад Ганьола', 'Dzenad Ganjola', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('oral_surgery');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Stomatološka poliklinika, Odjeljenje oralne hirurgije sa trijažom, načelnik' FROM dual WHERE @clinic IS NOT NULL;

-- Danijela Subotić — dentistry, pediatric_dentistry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Danijela Subotić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Subotić Danijela' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'danijela-subotic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'danijela-subotic', 'Danijela Subotić', 'Данијела Суботић', 'Даниела Суботич', 'Danijela Subotic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('dentistry', 'pediatric_dentistry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Stomatološka poliklinika, Odjeljenje dječje i preventivne stomatologije' FROM dual WHERE @clinic IS NOT NULL;

-- Lidija Krstajić Mijović — orthodontist
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Lidija Krstajić Mijović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Krstajić Mijović Lidija' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'lidija-krstajic-mijovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'lidija-krstajic-mijovic', 'Lidija Krstajić Mijović', 'Лидија Крстајић Мијовић', 'Лидия Крстаич Мийович', 'Lidija Krstajic Mijovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('orthodontist');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Stomatološka poliklinika, Odjeljenje ortopedije vilica sa laboratorijom' FROM dual WHERE @clinic IS NOT NULL;

-- Tatjana Džarić — dentistry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Tatjana Džarić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Džarić Tatjana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'tatjana-dzaric' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tatjana-dzaric', 'Tatjana Džarić', 'Татјана Џарић', 'Татьяна Джарич', 'Tatjana Dzaric', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('dentistry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Stomatološka poliklinika, Odjeljenje parodontologije i oralne medicine' FROM dual WHERE @clinic IS NOT NULL;

-- Marija Delić — dentistry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Marija Delić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Delić Marija' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'marija-delic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marija-delic', 'Marija Delić', 'Марија Делић', 'Мария Делич', 'Marija Delic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('dentistry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Stomatološka poliklinika, Odjeljenje za bolesti zuba sa endodoncijom, načelnica' FROM dual WHERE @clinic IS NOT NULL;

-- Zorica Stanišić — dentistry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Zorica Stanišić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Stanišić Zorica' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'zorica-stanisic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zorica-stanisic', 'Zorica Stanišić', 'Зорица Станишић', 'Зорица Станишич', 'Zorica Stanisic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('dentistry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Stomatološka poliklinika, Odjeljenje stomatološke protetike sa laboratorijom' FROM dual WHERE @clinic IS NOT NULL;

-- Biljana Milošević — dentistry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Biljana Milošević' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Milošević Biljana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'biljana-milosevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'biljana-milosevic', 'Biljana Milošević', 'Биљана Милошевић', 'Биляна Милошевич', 'Biljana Milosevic', 'Dr sc.', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('dentistry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Stomatološka poliklinika, Odjeljenje stomatološke protetike sa laboratorijom, načelnica' FROM dual WHERE @clinic IS NOT NULL;

-- Sonja Nejkov — Physical Medicine and Rehabilitation
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Sonja Nejkov' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Nejkov Sonja' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'sonja-nejkov' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sonja-nejkov', 'Sonja Nejkov', 'Соња Нејков', 'Соня Нейков', 'Sonja Nejkov', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('Physical Medicine and Rehabilitation');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za fizikalnu medicinu i rehabilitaciju, direktorica' FROM dual WHERE @clinic IS NOT NULL;

-- Vesna Bokan Mirković — Physical Medicine and Rehabilitation
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Vesna Bokan Mirković' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Bokan Mirković Vesna' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'vesna-bokan-mirkovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vesna-bokan-mirkovic', 'Vesna Bokan Mirković', 'Весна Бокан Мирковић', 'Весна Бокан Миркович', 'Vesna Bokan Mirkovic', 'Doc. dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('Physical Medicine and Rehabilitation');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za fizikalnu medicinu i rehabilitaciju, Odjeljenje za ranu rehabilitaciju, načelnica' FROM dual WHERE @clinic IS NOT NULL;

-- Marijana Karadžić — Physical Medicine and Rehabilitation
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Marijana Karadžić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Karadžić Marijana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'marijana-karadzic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marijana-karadzic', 'Marijana Karadžić', 'Маријана Караџић', 'Марияна Караджич', 'Marijana Karadzic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('Physical Medicine and Rehabilitation');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za fizikalnu medicinu i rehabilitaciju, Odjeljenje za ambulantnu rehabilitaciju, načelnica' FROM dual WHERE @clinic IS NOT NULL;

-- Filip Boljević — radiology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Filip Boljević' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Boljević Filip' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'filip-boljevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'filip-boljevic', 'Filip Boljević', 'Филип Бољевић', 'Филип Больевич', 'Filip Boljevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('radiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za radiološku dijagnostiku, Odjeljenje za urgentnu radiološku dijagnostiku, načelnik' FROM dual WHERE @clinic IS NOT NULL;

-- Danica Raičević — radiology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Danica Raičević' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Raičević Danica' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'danica-raicevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'danica-raicevic', 'Danica Raičević', 'Даница Раичевић', 'Даница Раичевич', 'Danica Raicevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('radiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za radiološku dijagnostiku, Odjeljenje za ultrazvučnu dijagnostiku, načelnica' FROM dual WHERE @clinic IS NOT NULL;

-- Nevena Terzić Stanić — clinical_biochemistry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Nevena Terzić Stanić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Terzić Stanić Nevena' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'nevena-terzic-stanic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nevena-terzic-stanic', 'Nevena Terzić Stanić', 'Невена Терзић Станић', 'Невена Терзич Станич', 'Nevena Terzic Stanic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('clinical_biochemistry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za kliničko-laboratorijsku dijagnostiku, direktorica' FROM dual WHERE @clinic IS NOT NULL;

-- Jelena Jovetić — gastroenterology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Jelena Jovetić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Jovetić Jelena' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jelena-jovetic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jelena-jovetic', 'Jelena Jovetić', 'Јелена Јоветић', 'Елена Йоветич', 'Jelena Jovetic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gastroenterology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Poliklinika KCCG, Gastroenterohepatološka ambulanta' FROM dual WHERE @clinic IS NOT NULL;

-- Miloš Lukić — gastroenterology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Miloš Lukić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Lukić Miloš' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'milos-lukic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milos-lukic', 'Miloš Lukić', 'Милош Лукић', 'Милош Лукич', 'Milos Lukic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gastroenterology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Poliklinika KCCG, Gastroenterohepatološka ambulanta' FROM dual WHERE @clinic IS NOT NULL;

-- Tanja Šaranović — gastroenterology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Tanja Šaranović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Šaranović Tanja' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'tanja-saranovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tanja-saranovic', 'Tanja Šaranović', 'Тања Шарановић', 'Таня Шаранович', 'Tanja Saranovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gastroenterology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Poliklinika KCCG, Gastroenterohepatološka ambulanta' FROM dual WHERE @clinic IS NOT NULL;

-- Sanja Ćalasan — gastroenterology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Sanja Ćalasan' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ćalasan Sanja' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'sanja-calasan' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sanja-calasan', 'Sanja Ćalasan', 'Сања Ћаласан', 'Саня Чаласан', 'Sanja Calasan', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gastroenterology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Poliklinika KCCG, Gastroenterohepatološka ambulanta' FROM dual WHERE @clinic IS NOT NULL;

-- Marko Nišavić — pulmonology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Marko Nišavić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Nišavić Marko' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'marko-nisavic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marko-nisavic', 'Marko Nišavić', 'Марко Нишавић', 'Марко Нишавич', 'Marko Nisavic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pulmonology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Poliklinika KCCG, Pulmološka ambulanta' FROM dual WHERE @clinic IS NOT NULL;

-- Nina Mikić — hematology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Nina Mikić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Mikić Nina' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'nina-mikic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nina-mikic', 'Nina Mikić', 'Нина Микић', 'Нина Микич', 'Nina Mikic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('hematology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Poliklinika KCCG, Hematološka ambulanta' FROM dual WHERE @clinic IS NOT NULL;

-- Jovana Šaban Šćepanović — hematology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Jovana Šaban Šćepanović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Šaban Šćepanović Jovana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jovana-saban-scepanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jovana-saban-scepanovic', 'Jovana Šaban Šćepanović', 'Јована Шабан Шћепановић', 'Йована Шабан Щепанович', 'Jovana Saban Scepanovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('hematology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Poliklinika KCCG, Hematološka ambulanta' FROM dual WHERE @clinic IS NOT NULL;

-- Nemanja Vuković — vascular_surgery
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Nemanja Vuković' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Vuković Nemanja' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'nemanja-vukovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nemanja-vukovic', 'Nemanja Vuković', 'Немања Вуковић', 'Неманья Вукович', 'Nemanja Vukovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('vascular_surgery');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Poliklinika KCCG, Ambulanta vaskularne hirurgije' FROM dual WHERE @clinic IS NOT NULL;

-- Balša Stanišić — vascular_surgery
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Balša Stanišić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Stanišić Balša' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'balsa-stanisic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'balsa-stanisic', 'Balša Stanišić', 'Балша Станишић', 'Балша Станишич', 'Balsa Stanisic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('vascular_surgery');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Poliklinika KCCG, Ambulanta vaskularne hirurgije' FROM dual WHERE @clinic IS NOT NULL;

-- Miloš Jovanović — vascular_surgery
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Miloš Jovanović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Jovanović Miloš' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'milos-jovanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milos-jovanovic', 'Miloš Jovanović', 'Милош Јовановић', 'Милош Йованович', 'Milos Jovanovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('vascular_surgery');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Poliklinika KCCG, Ambulanta vaskularne hirurgije' FROM dual WHERE @clinic IS NOT NULL;

-- Janja Rašović — pathological_anatomy
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Janja Rašović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Rašović Janja' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'janja-rasovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'janja-rasovic', 'Janja Rašović', 'Јања Рашовић', 'Яня Рашович', 'Janja Rasovic', 'Dr sc. med.', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pathological_anatomy');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za patologiju, Odjeljenje za patohistologiju, načelnica' FROM dual WHERE @clinic IS NOT NULL;

-- Mileta Golubović — pathological_anatomy
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Mileta Golubović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Golubović Mileta' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'mileta-golubovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mileta-golubovic', 'Mileta Golubović', 'Милета Голубовић', 'Милета Голубович', 'Mileta Golubovic', 'Prof. dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pathological_anatomy');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za patologiju, Odjeljenje za imunohistohemiju, načelnik' FROM dual WHERE @clinic IS NOT NULL;

-- Tatjana Ćulafić — pathological_anatomy
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Tatjana Ćulafić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ćulafić Tatjana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'tatjana-culafic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tatjana-culafic', 'Tatjana Ćulafić', 'Татјана Ћулафић', 'Татьяна Чулафич', 'Tatjana Culafic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pathological_anatomy');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za patologiju, Odjeljenje za citologiju, načelnica' FROM dual WHERE @clinic IS NOT NULL;

-- Tanja Nenezić — pathological_anatomy
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Tanja Nenezić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Nenezić Tanja' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'tanja-nenezic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tanja-nenezic', 'Tanja Nenezić', 'Тања Ненезић', 'Таня Ненезич', 'Tanja Nenezic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pathological_anatomy');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za patologiju, Odjeljenje za molekularne analize, načelnica' FROM dual WHERE @clinic IS NOT NULL;


-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════
-- Očekivano: 65 redova, svi sa linked = 1 i bar jednom specijalnošću
SELECT d.slug, d.name_sr,
       (SELECT COUNT(*) FROM doctor_clinics dc WHERE dc.doctor_id = d.id AND dc.clinic_id = @clinic) AS linked,
       (SELECT GROUP_CONCAT(s.name ORDER BY s.name) FROM doctor_specialties ds JOIN specialties s ON s.id = ds.specialty_id WHERE ds.doctor_id = d.id) AS specialties
FROM doctors d
WHERE d.slug IN (
  'danko-natalic',
  'zanka-cerovic',
  'muhedin-kadic',
  'dragan-nesovic',
  'dijana-asanovic',
  'bozovic-bjanka',
  'mihailo-vukmirovic',
  'gordana-globarevic-vukcevic',
  'jelena-paunovic',
  'milorada-nesovic',
  'milos-obradovic',
  'marija-abramovic',
  'vojislav-mandic',
  'dragomir-madzgalj',
  'nikola-delevic',
  'jelena-borovinic-bojovic',
  'aleksandra-furtula',
  'miladinovic-mirjana',
  'olivera-miljanovic',
  'jelena-jovanovic',
  'gordana-stojanovic',
  'tamara-jovicevic',
  'dagan-racic',
  'olja-mandjarelo',
  'masa-raonic',
  'lidija-banjac',
  'mirjana-djurovic',
  'nebojsa-brnovic',
  'aleksandra-boljevic',
  'sinisa-dragnic',
  'jelena-kovacevic',
  'iva-ivanovic',
  'goran-lazarevic',
  'sasa-raicevic',
  'natalija-trninic',
  'elma-kolic-salkovic',
  'ivana-djurisic',
  'kemal-sahmanovic',
  'dzenad-ganjola',
  'danijela-subotic',
  'lidija-krstajic-mijovic',
  'tatjana-dzaric',
  'marija-delic',
  'zorica-stanisic',
  'biljana-milosevic',
  'sonja-nejkov',
  'vesna-bokan-mirkovic',
  'marijana-karadzic',
  'filip-boljevic',
  'danica-raicevic',
  'nevena-terzic-stanic',
  'jelena-jovetic',
  'milos-lukic',
  'tanja-saranovic',
  'sanja-calasan',
  'marko-nisavic',
  'nina-mikic',
  'jovana-saban-scepanovic',
  'nemanja-vukovic',
  'balsa-stanisic',
  'milos-jovanovic',
  'janja-rasovic',
  'mileta-golubovic',
  'tatjana-culafic',
  'tanja-nenezic'
)
ORDER BY d.slug;

-- Ukupno ljekara KCCG: lokalno prije skripte 264 → poslije 329
SELECT COUNT(*) AS kccg_doctors FROM doctor_clinics WHERE clinic_id = @clinic;
