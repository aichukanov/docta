SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
-- Državne bolnice (grupa hospitals): sinhronizacija ljekara sa sajtovima, 2026-10-06
-- Klinike: bolnica-danilo-i-cetinje, opsta-bolnica-niksic, opsta-bolnica-berane, opsta-bolnica-pljevlja,
--         specijalna-bolnica-za-plucne-bolesti-dr-jovan-bulajic-brezovik, specijalna-bolnica-za-psihijatriju-dobrota-kotor,
--         opsta-bolnica-kotor (samo website).
-- Klinike, ljekari i specijalnosti — samo po slug / name (id lokalno i na produ se razlikuju).
-- Novi ljekar: "nađi ili napravi" (ime, obrnuto ime, slug), zatim specijalnosti, srpski jezik, vezivanje.
-- Idempotentno: drugi prolaz ne mijenja ništa.
-- Odluke: data/clinic-teams/decisions/hospitals.md

-- ═══════════════════════════════════════════════════════════════
-- 1. Bolnica Danilo I Cetinje — daniloprvi.me/osoblje-bolnice-danilo-i/ + stranice odjeljenja
-- ═══════════════════════════════════════════════════════════════

SET @clinic = (SELECT id FROM clinics WHERE slug = 'bolnica-danilo-i-cetinje');

-- Pozicije postojećih (samo ako su prazne)
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Direktor' WHERE d.slug = 'ivan-ivanovic' AND dc.clinic_id = @clinic AND (dc.position IS NULL OR dc.position = '');
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Načelnik Službe anestezije i reanimacije' WHERE d.slug = 'zeljko-sankovic' AND dc.clinic_id = @clinic AND (dc.position IS NULL OR dc.position = '');
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Načelnica Službe radiološke dijagnostike' WHERE d.slug = 'latkovic-danijela' AND dc.clinic_id = @clinic AND (dc.position IS NULL OR dc.position = '');
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Šefica Odsjeka za RTG dijagnostiku sa kabinetom za CT i MR' WHERE d.slug = 'ivanovic-jelena' AND dc.clinic_id = @clinic AND (dc.position IS NULL OR dc.position = '');
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Načelnica Odjeljenja ginekologije i akušerstva' WHERE d.slug = 'tamara-jevsnik' AND dc.clinic_id = @clinic AND (dc.position IS NULL OR dc.position = '');
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Načelnik Odjeljenja za humanu reprodukciju' WHERE d.slug = 'lazovic-zeljko' AND dc.clinic_id = @clinic AND (dc.position IS NULL OR dc.position = '');
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Načelnica Odjeljenja interne medicine' WHERE d.slug = 'ivanovic-suzana' AND dc.clinic_id = @clinic AND (dc.position IS NULL OR dc.position = '');
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Šef operacionog bloka' WHERE d.slug = 'mihailo-babovic' AND dc.clinic_id = @clinic AND (dc.position IS NULL OR dc.position = '');

-- Samira Gargović-Babović — anesteziolog (Služba anestezije); u bazi već kod Codra
SET @d = (SELECT id FROM doctors WHERE slug = 'gargovic-babovic-samira');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Jelena Bojanić — radiolog (Služba radiološke dijagnostike); u bazi već kod Hirurgija Dr Eli
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-bojanic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Šefica Odsjeka za ultrazvuk' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;
UPDATE doctor_clinics SET position = 'Šefica Odsjeka za ultrazvuk' WHERE doctor_id = @d AND clinic_id = @clinic AND (position IS NULL OR position = '');

-- ═══════════════════════════════════════════════════════════════
-- 2. Opšta bolnica Nikšić — bolnica-nk.com (wp-json pages, stranice odjeljenja i kabineta)
-- ═══════════════════════════════════════════════════════════════

SET @clinic = (SELECT id FROM clinics WHERE slug = 'opsta-bolnica-niksic');

-- Pozicije postojećih (samo ako su prazne)
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Direktor' WHERE d.slug = 'mrkic-zoran' AND dc.clinic_id = @clinic AND (dc.position IS NULL OR dc.position = '');
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Načelnica Odjeljenja za infektivne bolesti' WHERE d.slug = 'sonja-lalovic' AND dc.clinic_id = @clinic AND (dc.position IS NULL OR dc.position = '');
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Načelnik Jedinice urgentnog hirurškog bloka' WHERE d.slug = 'dragutin-visnjic' AND dc.clinic_id = @clinic AND (dc.position IS NULL OR dc.position = '');
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Šef Odsjeka koronarne jedinice' WHERE d.slug = 'sabahudin-pupovic' AND dc.clinic_id = @clinic AND (dc.position IS NULL OR dc.position = '');

-- Sanja Vrbica — radiolog; u bazi već kod Konzilijum i Medicus Tim
SET @d = (SELECT id FROM doctors WHERE slug = 'sanja-vrbica');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Načelnica Kabineta za radiološku, UZ, CT i mamografsku dijagnostiku' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;
UPDATE doctor_clinics SET position = 'Načelnica Kabineta za radiološku, UZ, CT i mamografsku dijagnostiku' WHERE doctor_id = @d AND clinic_id = @clinic AND (position IS NULL OR position = '');

-- Saška Grupković — radiolog; u bazi već kod Milmedika Podgorica/Nikšić
SET @d = (SELECT id FROM doctors WHERE slug = 'grupkovic-saska');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Marija Eraković — radiolog; u bazi već kod Hipokrat
SET @d = (SELECT id FROM doctors WHERE slug = 'marija-erakovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Tanja Raičević — pediatrics
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Tanja Raičević' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Raičević Tanja' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'tanja-raicevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tanja-raicevic', 'Tanja Raičević', 'Тања Раичевић', 'Танья Раичевич', 'Tanja Raicevic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Načelnica Odjeljenja za novorođenčad' FROM dual WHERE @clinic IS NOT NULL;

-- Sanja Čizmović — pediatrics
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Sanja Čizmović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Čizmović Sanja' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'sanja-cizmovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sanja-cizmovic', 'Sanja Čizmović', 'Сања Чизмовић', 'Санья Чизмович', 'Sanja Cizmovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- Snežana Grubač — pediatrics, neonatology (subspecijalista neonatologije)
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Snežana Grubač' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Grubač Snežana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'snezana-grubac' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'snezana-grubac', 'Snežana Grubač', 'Снежана Грубач', 'Снежана Грубач', 'Snezana Grubac', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics', 'neonatology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- Mirko Varajić — gynecology_obstetrics
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Mirko Varajić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Varajić Mirko' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'mirko-varajic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mirko-varajic', 'Mirko Varajić', 'Мирко Варајић', 'Мирко Вараич', 'Mirko Varajic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gynecology_obstetrics');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Načelnik Odjeljenja akušerstva sa porođajnom salom' FROM dual WHERE @clinic IS NOT NULL;

-- Bojan Pešić — general_surgery (Ambulanta opšte hirurgije)
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Bojan Pešić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Pešić Bojan' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'bojan-pesic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'bojan-pesic', 'Bojan Pešić', 'Бојан Пешић', 'Боян Пешич', 'Bojan Pesic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_surgery');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- Nada Grbović — Physical Medicine and Rehabilitation
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Nada Grbović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Grbović Nada' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'nada-grbovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nada-grbovic', 'Nada Grbović', 'Нада Грбовић', 'Нада Грбович', 'Nada Grbovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('Physical Medicine and Rehabilitation');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Načelnica Jedinice za fizikalnu medicinu i rehabilitaciju' FROM dual WHERE @clinic IS NOT NULL;

-- Milena Šaranović — Physical Medicine and Rehabilitation
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Milena Šaranović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Šaranović Milena' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'milena-saranovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milena-saranovic', 'Milena Šaranović', 'Милена Шарановић', 'Милена Шаранович', 'Milena Saranovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('Physical Medicine and Rehabilitation');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- Ranka Koprivica — radiology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Ranka Koprivica' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Koprivica Ranka' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ranka-koprivica' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ranka-koprivica', 'Ranka Koprivica', 'Ранка Копривица', 'Ранка Копривица', 'Ranka Koprivica', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('radiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- Andrija Radulović — radiology (ne Andrea Radulović (opšta medicina, Moj Lab Budva))
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Andrija Radulović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Radulović Andrija' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'andrija-radulovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'andrija-radulovic', 'Andrija Radulović', 'Андрија Радуловић', 'Андрия Радулович', 'Andrija Radulovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('radiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- Maja Mušikić — clinical_biochemistry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Maja Mušikić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Mušikić Maja' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'maja-musikic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'maja-musikic', 'Maja Mušikić', 'Маја Мушикић', 'Мая Мушикич', 'Maja Musikic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('clinical_biochemistry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Načelnica Kabineta za laboratorijsku dijagnostiku' FROM dual WHERE @clinic IS NOT NULL;

-- ═══════════════════════════════════════════════════════════════
-- 3. Opšta bolnica (KBC) Berane — /menadzerski-tim, /o-nama/menadzment, aktuelnosti 2026
-- ═══════════════════════════════════════════════════════════════

SET @clinic = (SELECT id FROM clinics WHERE slug = 'opsta-bolnica-berane');

-- Violeta Manović nestala sa /menadzerski-tim; njeno mjesto (Šefica Odsjeka intenzivnog liječenja) sada drži Miladinović.
-- Odluka koordinatora 2026-10-06: stranica navodi samo rukovodioce — nestanak znači «nije više šefica», ne «otišla».
-- Veza ostaje, briše se samo funkcija (samo ako je još stara).
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = NULL
WHERE d.slug = 'violeta-manovic' AND dc.clinic_id = @clinic AND dc.position LIKE '%intenzivnog lije%';

-- Markišić i Miladinović zamijenili funkcije
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Načelnik Odjeljenja za anesteziju i reanimaciju' WHERE d.slug = 'mirsad-markisic' AND dc.clinic_id = @clinic AND dc.position = 'Šef Odsjeka za anesteziju i reanimaciju';
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Šef Odsjeka intenzivnog liječenja' WHERE d.slug = 'milosav-miladinovic' AND dc.clinic_id = @clinic AND dc.position = 'Načelnik Odjeljenja za anesteziju i reanimaciju';

-- Prof. dr Miroljub Todorović — ORL, angažovan za operativni program (vijest 11.09.2026); u bazi već kod Danilo i Medtim
SET @d = (SELECT id FROM doctors WHERE slug = 'miroljub-todorovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Nikola Cvijović — oftalmolog, angažovan iz KCCG za anti-VEGF terapiju (vijest 02.03.2026)
SET @d = (SELECT id FROM doctors WHERE slug = 'nikola-cvijovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Milorad Magdelinić — general_surgery (specijalista hirurgije)
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Milorad Magdelinić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Magdelinić Milorad' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'milorad-magdelinic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milorad-magdelinic', 'Milorad Magdelinić', 'Милорад Магделинић', 'Милорад Магделинич', 'Milorad Magdelinic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_surgery');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Direktor' FROM dual WHERE @clinic IS NOT NULL;

-- Goran Bulatović — otorhinolaryngology (vijest 11.09.2026)
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Goran Bulatović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Bulatović Goran' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'goran-bulatovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'goran-bulatovic', 'Goran Bulatović', 'Горан Булатовић', 'Горан Булатович', 'Goran Bulatovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('otorhinolaryngology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- Nemanja Vuković — vascular_surgery (vijest 27.07.2026; isti čovjek kao vaskularni hirurg KCCG u update-doctors-2026-10-kccg.sql)
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Nemanja Vuković' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Vuković Nemanja' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'nemanja-vukovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nemanja-vukovic', 'Nemanja Vuković', 'Немања Вуковић', 'Неманья Вукович', 'Nemanja Vukovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('vascular_surgery');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- Saveta Obradović Kljajić — ophthalmology (vijest 02.03.2026)
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Saveta Obradović Kljajić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Kljajić Saveta Obradović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'saveta-obradovic-kljajic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'saveta-obradovic-kljajic', 'Saveta Obradović Kljajić', 'Савета Обрадовић Кљајић', 'Савета Обрадович Кльяич', 'Saveta Obradovic Kljajic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('ophthalmology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- Jasmina Međedović — ophthalmology (vijest 02.03.2026)
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Jasmina Međedović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Međedović Jasmina' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jasmina-medjedovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jasmina-medjedovic', 'Jasmina Međedović', 'Јасмина Међедовић', 'Ясмина Меджедович', 'Jasmina Medjedovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('ophthalmology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- ═══════════════════════════════════════════════════════════════
-- 4. Opšta bolnica Pljevlja — bolnicapv.com, stranice odjeljenja i ambulanti
-- ═══════════════════════════════════════════════════════════════

SET @clinic = (SELECT id FROM clinics WHERE slug = 'opsta-bolnica-pljevlja');

-- Ana Mrdak (psihijatrija) — NE odvezujemo: sajt nema stranicu psihijatrije, jedinica Detoksikacija je bez imena

-- Pozicije postojećih (samo ako su prazne)
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Načelnica Odjeljenja neurologije' WHERE d.slug = 'sabrina-hadziosmanovic' AND dc.clinic_id = @clinic AND (dc.position IS NULL OR dc.position = '');
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Načelnica Odjeljenja pedijatrije' WHERE d.slug = 'maja-terzic' AND dc.clinic_id = @clinic AND (dc.position IS NULL OR dc.position = '');
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Pomoćnik direktora za medicinska pitanja' WHERE d.slug = 'strahinja-vranes' AND dc.clinic_id = @clinic AND (dc.position IS NULL OR dc.position = '');

-- Radoman Čolović — cardiology (kardiološka ambulanta)
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Radoman Čolović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Čolović Radoman' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'radoman-colovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'radoman-colovic', 'Radoman Čolović', 'Радоман Чоловић', 'Радоман Чолович', 'Radoman Colovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('cardiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- Jovan Peruničić — cardiology
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Jovan Peruničić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Peruničić Jovan' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jovan-perunicic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jovan-perunicic', 'Jovan Peruničić', 'Јован Перуничић', 'Йован Перуничич', 'Jovan Perunicic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('cardiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Kardiolog – konsultant' FROM dual WHERE @clinic IS NOT NULL;

-- Davor Cvijović — general_surgery
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Davor Cvijović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Cvijović Davor' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'davor-cvijovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'davor-cvijovic', 'Davor Cvijović', 'Давор Цвијовић', 'Давор Цвийович', 'Davor Cvijovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_surgery');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- ═══════════════════════════════════════════════════════════════
-- 5. Specijalna bolnica za plućne bolesti Brezovik — stranice odjeljenja/službi, raspored ambulante, kontakt
-- ═══════════════════════════════════════════════════════════════

SET @clinic = (SELECT id FROM clinics WHERE slug = 'specijalna-bolnica-za-plucne-bolesti-dr-jovan-bulajic-brezovik');

-- Pozicije postojećih (samo ako su prazne)
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Načelnica Odjeljenja za hronični bronhitis, astmu i srodne bolesti' WHERE d.slug = 'aleksandra-toljic' AND dc.clinic_id = @clinic AND (dc.position IS NULL OR dc.position = '');
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Načelnica Odjeljenja za tuberkulozu' WHERE d.slug = 'olivera-bojovic' AND dc.clinic_id = @clinic AND (dc.position IS NULL OR dc.position = '');
UPDATE doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id SET dc.position = 'Načelnik Odjeljenja za zapaljenske bolesti pluća' WHERE d.slug = 'mitar-vukosavljevic' AND dc.clinic_id = @clinic AND (dc.position IS NULL OR dc.position = '');

-- Marija Stolić — internista-onkolog; u bazi već kod Moj Lab Podgorica (interna, onkologija)
SET @d = (SELECT id FROM doctors WHERE slug = 'marija-stolic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Načelnica Odjeljenja pulmološke onkologije' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;
UPDATE doctor_clinics SET position = 'Načelnica Odjeljenja pulmološke onkologije' WHERE doctor_id = @d AND clinic_id = @clinic AND (position IS NULL OR position = '');

-- Dejan Perović — radiolog; u bazi već kod Milmedika Nikšić
SET @d = (SELECT id FROM doctors WHERE slug = 'perovic-dejan');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Načelnik Službe radiološke dijagnostike' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;
UPDATE doctor_clinics SET position = 'Načelnik Službe radiološke dijagnostike' WHERE doctor_id = @d AND clinic_id = @clinic AND (position IS NULL OR position = '');

-- Rade Kovač — radiolog; u bazi već kod SmartMed i Hipokrat
SET @d = (SELECT id FROM doctors WHERE slug = 'rade-kovac');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Slobodan Guzina — internal_medicine
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Slobodan Guzina' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Guzina Slobodan' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'slobodan-guzina' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'slobodan-guzina', 'Slobodan Guzina', 'Слободан Гузина', 'Слободан Гузина', 'Slobodan Guzina', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('internal_medicine');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Načelnik Odjeljenja intenzivne njege' FROM dual WHERE @clinic IS NOT NULL;

-- Ana Vukićević Delić — internal_medicine (Odjeljenje pulmološke onkologije)
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Ana Vukićević Delić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Delić Ana Vukićević' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ana-vukicevic-delic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ana-vukicevic-delic', 'Ana Vukićević Delić', 'Ана Вукићевић Делић', 'Ана Вукичевич Делич', 'Ana Vukicevic Delic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('internal_medicine');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- Danilo Ćosović — internal_medicine (Odjeljenje za zapaljenske bolesti pluća)
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Danilo Ćosović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ćosović Danilo' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'danilo-cosovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'danilo-cosovic', 'Danilo Ćosović', 'Данило Ћосовић', 'Данило Чосович', 'Danilo Cosovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('internal_medicine');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- ═══════════════════════════════════════════════════════════════
-- 6. Specijalna bolnica za psihijatriju Dobrota Kotor — wp-json pages (odjeljenja, menadžment, psihološka služba)
-- ═══════════════════════════════════════════════════════════════

SET @clinic = (SELECT id FROM clinics WHERE slug = 'specijalna-bolnica-za-psihijatriju-dobrota-kotor');

-- dbOnly (Stijović, Perunović, Donković) — NE odvezujemo: polja "Ordinirajući ljekar" za internističku i druge službe su prazna

-- Jovan Đedović = "Prim. dr Jovo Đedović", direktor (Jovo — hipokoristik od Jovan, ista specijalnost). Ime ne mijenjamo.
SET @d = (SELECT id FROM doctors WHERE slug = 'jovan-djedovic');
UPDATE doctor_clinics SET position = 'Direktor' WHERE doctor_id = @d AND clinic_id = @clinic AND (position IS NULL OR position = '');
UPDATE doctors SET professional_title = 'prim. dr' WHERE id = @d AND professional_title IN ('Dr', 'dr', '');
UPDATE doctors SET photo_url = 'https://psihijatrijakotor.com/wp-content/uploads/2025/12/1718187463-za-sajt.jpg' WHERE id = @d AND (photo_url IS NULL OR photo_url = '');

-- Boris Ćorić — psychiatry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Boris Ćorić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ćorić Boris' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'boris-coric' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'boris-coric', 'Boris Ćorić', 'Борис Ћорић', 'Борис Чорич', 'Boris Coric', 'dr', 'https://psihijatrijakotor.com/wp-content/uploads/2026/01/4420883F-4716-4760-B1AB-9C795969F396.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Načelnik Odjeljenja za produženo liječenje – žensko' FROM dual WHERE @clinic IS NOT NULL;

-- Tanja Mijatović Papić — psychiatry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Tanja Mijatović Papić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Papić Tanja Mijatović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'tanja-mijatovic-papic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tanja-mijatovic-papic', 'Tanja Mijatović Papić', 'Тања Мијатовић Папић', 'Танья Миятович Папич', 'Tanja Mijatovic Papic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Načelnica Odjeljenja za produženo liječenje muško-otvoreno' FROM dual WHERE @clinic IS NOT NULL;

-- Neda Grbović — psychiatry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Neda Grbović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Grbović Neda' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'neda-grbovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'neda-grbovic', 'Neda Grbović', 'Неда Грбовић', 'Неда Грбович', 'Neda Grbovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- Jovana Bogdanović — psychiatry (uža specijalizacija iz bolesti zavisnosti)
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Jovana Bogdanović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Bogdanović Jovana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jovana-bogdanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jovana-bogdanovic', 'Jovana Bogdanović', 'Јована Богдановић', 'Йована Богданович', 'Jovana Bogdanovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Načelnica Odjeljenja za produženo liječenje muško-zatvoreno' FROM dual WHERE @clinic IS NOT NULL;

-- Danijela Miladinović — psychiatry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Danijela Miladinović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Miladinović Danijela' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'danijela-miladinovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'danijela-miladinovic', 'Danijela Miladinović', 'Данијела Миладиновић', 'Даниела Миладинович', 'Danijela Miladinovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Načelnica Odjeljenja za akutne psihoze – muško' FROM dual WHERE @clinic IS NOT NULL;

-- Milica Vučetić — psychiatry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Milica Vučetić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Vučetić Milica' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'milica-vucetic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milica-vucetic', 'Milica Vučetić', 'Милица Вучетић', 'Милица Вучетич', 'Milica Vucetic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- Milka Bulatović Nišavić — psychiatry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Milka Bulatović Nišavić' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Nišavić Milka Bulatović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'milka-bulatovic-nisavic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milka-bulatovic-nisavic', 'Milka Bulatović Nišavić', 'Милка Булатовић Нишавић', 'Милка Булатович Нишавич', 'Milka Bulatovic Nisavic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Načelnica Odjeljenja za akutne psihoze – žensko' FROM dual WHERE @clinic IS NOT NULL;

-- Ana Stanković — psychiatry (samo po slug: ana-stankovic je druga osoba (opšta medicina, Novi Standard))
SET @d = (SELECT id FROM doctors WHERE slug = 'ana-stankovic-2' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ana-stankovic-2', 'Ana Stanković', 'Ана Станковић', 'Ана Станкович', 'Ana Stankovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- Nikola Radoman — psychiatry, neurology (specijalista neuropsihijatrije)
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Nikola Radoman' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Radoman Nikola' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'nikola-radoman' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nikola-radoman', 'Nikola Radoman', 'Никола Радоман', 'Никола Радоман', 'Nikola Radoman', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry', 'neurology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Načelnik Otvorenog odjeljenja za akutne psihoze i EEG odsjeka' FROM dual WHERE @clinic IS NOT NULL;

-- Vesna Blagojević — psychiatry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Vesna Blagojević' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Blagojević Vesna' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'vesna-blagojevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vesna-blagojevic', 'Vesna Blagojević', 'Весна Благојевић', 'Весна Благоевич', 'Vesna Blagojevic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Načelnica Odjeljenja za forenzičko-sudsku psihijatriju' FROM dual WHERE @clinic IS NOT NULL;

-- Sandra Vlahović — psychiatry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Sandra Vlahović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Vlahović Sandra' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'sandra-vlahovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sandra-vlahovic', 'Sandra Vlahović', 'Сандра Влаховић', 'Сандра Влахович', 'Sandra Vlahovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Načelnica Odjeljenja za liječenje bolesti zavisnosti' FROM dual WHERE @clinic IS NOT NULL;

-- Aleksandar Tomčuk — psychiatry
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Aleksandar Tomčuk' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Tomčuk Aleksandar' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'aleksandar-tomcuk' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aleksandar-tomcuk', 'Aleksandar Tomčuk', 'Александар Томчук', 'Александар Томчук', 'Aleksandar Tomcuk', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Načelnik Centra za promociju nauke i razvoj projekata' FROM dual WHERE @clinic IS NOT NULL;

-- Stevan Radoman — oral_surgery
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Stevan Radoman' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Radoman Stevan' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'stevan-radoman' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'stevan-radoman', 'Stevan Radoman', 'Стеван Радоман', 'Стеван Радоман', 'Stevan Radoman', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('oral_surgery');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Stomatološka ambulanta' FROM dual WHERE @clinic IS NOT NULL;

-- Marija Kaluđerović — anesthesiology (članica Etičkog komiteta bolnice)
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Marija Kaluđerović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Kaluđerović Marija' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'marija-kaludjerovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marija-kaludjerovic', 'Marija Kaluđerović', 'Марија Калуђеровић', 'Мария Калуджерович', 'Marija Kaludjerovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('anesthesiology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- Kristina Bećir Veriš — psychology (specijalista medicinske psihologije)
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Kristina Bećir Veriš' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Veriš Kristina Bećir' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'kristina-becir-veris' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'kristina-becir-veris', 'Kristina Bećir Veriš', 'Кристина Бећир Вериш', 'Кристина Бечир Вериш', 'Kristina Becir Veris', '', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Šefica Psihološke službe' FROM dual WHERE @clinic IS NOT NULL;

-- Olivera Marković — psychology (specijalista medicinske psihologije)
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Olivera Marković' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Marković Olivera' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'olivera-markovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'olivera-markovic', 'Olivera Marković', 'Оливера Марковић', 'Оливера Маркович', 'Olivera Markovic', '', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- Ljiljana Matković — psychology (dipl. psiholog)
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Ljiljana Matković' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Matković Ljiljana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ljiljana-matkovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ljiljana-matkovic', 'Ljiljana Matković', 'Љиљана Матковић', 'Лильяна Маткович', 'Ljiljana Matkovic', '', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- Ivana Mihailović — psychology (dipl. psiholog)
SET @d = (SELECT id FROM doctors WHERE name_sr = 'Ivana Mihailović' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Mihailović Ivana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ivana-mihailovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivana-mihailovic', 'Ivana Mihailović', 'Ивана Михаиловић', 'Ивана Михаилович', 'Ivana Mihailovic', '', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychology');
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@d, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, NULL FROM dual WHERE @clinic IS NOT NULL;

-- ═══════════════════════════════════════════════════════════════
-- 7. Opšta bolnica Kotor — samo website (jzuobkotor.me napušten od 2023); ljekare ne diramo
-- ═══════════════════════════════════════════════════════════════
UPDATE clinics SET website = 'https://kbckotor.me' WHERE slug = 'opsta-bolnica-kotor' AND (website IS NULL OR website = '' OR website = 'https://kbckotor.me;https://jzuobkotor.me');

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════
SELECT c.slug, COUNT(dc.id) AS doctors FROM clinics c LEFT JOIN doctor_clinics dc ON dc.clinic_id = c.id
WHERE c.slug IN ('bolnica-danilo-i-cetinje', 'opsta-bolnica-niksic', 'opsta-bolnica-berane', 'opsta-bolnica-pljevlja',
  'specijalna-bolnica-za-plucne-bolesti-dr-jovan-bulajic-brezovik', 'specijalna-bolnica-za-psihijatriju-dobrota-kotor', 'opsta-bolnica-kotor')
GROUP BY c.slug ORDER BY c.slug;

SELECT d.slug, d.name_sr, d.name_sr_cyrl, d.name_ru,
  (SELECT GROUP_CONCAT(s.name) FROM doctor_specialties ds JOIN specialties s ON s.id = ds.specialty_id WHERE ds.doctor_id = d.id) AS specialties,
  (SELECT GROUP_CONCAT(CONCAT(c.slug, ' [', IFNULL(dc.position, ''), ']') SEPARATOR '; ') FROM doctor_clinics dc JOIN clinics c ON c.id = dc.clinic_id WHERE dc.doctor_id = d.id) AS clinics
FROM doctors d WHERE d.slug IN (
  'tanja-raicevic',
  'sanja-cizmovic',
  'snezana-grubac',
  'mirko-varajic',
  'bojan-pesic',
  'nada-grbovic',
  'milena-saranovic',
  'ranka-koprivica',
  'andrija-radulovic',
  'maja-musikic',
  'milorad-magdelinic',
  'goran-bulatovic',
  'nemanja-vukovic',
  'saveta-obradovic-kljajic',
  'jasmina-medjedovic',
  'radoman-colovic',
  'jovan-perunicic',
  'davor-cvijovic',
  'slobodan-guzina',
  'ana-vukicevic-delic',
  'danilo-cosovic',
  'boris-coric',
  'tanja-mijatovic-papic',
  'neda-grbovic',
  'jovana-bogdanovic',
  'danijela-miladinovic',
  'milica-vucetic',
  'milka-bulatovic-nisavic',
  'ana-stankovic-2',
  'nikola-radoman',
  'vesna-blagojevic',
  'sandra-vlahovic',
  'aleksandar-tomcuk',
  'stevan-radoman',
  'marija-kaludjerovic',
  'kristina-becir-veris',
  'olivera-markovic',
  'ljiljana-matkovic',
  'ivana-mihailovic'
) ORDER BY d.slug;

SELECT d.slug, dc.position FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id
WHERE c.slug = 'opsta-bolnica-berane' AND d.slug IN ('mirsad-markisic', 'milosav-miladinovic', 'violeta-manovic');
SELECT slug, website FROM clinics WHERE slug = 'opsta-bolnica-kotor';
SELECT slug, name_sr, professional_title, photo_url FROM doctors WHERE slug = 'jovan-djedovic';
