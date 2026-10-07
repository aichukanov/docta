SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Синхронизация составов врачей с сайтами: крупные частные поликлиники Подгорицы
-- (группа private-pg, карта data/clinic-teams/map.json от 2026-10-02, сайты
-- перепроверены curl'ом 2026-10-06). Решения по каждому врачу —
-- data/clinic-teams/decisions/private-pg.md.
--
-- Клиники, врачи и специальности — только по slug / name (id локально и на проде
-- расходятся, например Natal Kids). Файл идемпотентен: повторный прогон ничего не меняет.
-- Врачи не удаляются и не скрываются: отвязанный врач без клиник остаётся как есть.
-- При отвязке удаляются его строки clinic_medical_service_doctors этой клиники.
--
-- Источники:
--   SmartMed       /doktori + /aktuelno/ordinirajuci-doktori (сироты из sitemap — ушедшие)
--   Vaše zdravlje  /strucni-tim/ (2026-04-24, штат сменился; старая /strucni-tim1/ = прежняя БД)
--   Konzilijum     /nas-tim/ (2025-11) + страницы отделений, которые ссылаются из меню
--   Novi Cenex     /nasi-ljekari/ — меню + блок биографий (сайт взломан, только curl)
--   Diagnostica    api.diagnostica.me/api/public/bootstrap, teamCategoryId = ljekari
--   Kerber         /doktori/ + team-member-sitemap (2026-05-05)
--   Natal          wp-json CPT nas-tim (47 записей; педиатры — Natal Kids, не тронуты)
--   Naša medicina  /o-nama/ (2026-06)

-- ═══ Клиники ═══

SET @c_smartmed = (SELECT id FROM clinics WHERE slug = 'smartmed-podgorica');
SET @c_vz = (SELECT id FROM clinics WHERE slug = 'vase-zdravlje-podgorica');
SET @c_konz = (SELECT id FROM clinics WHERE slug = 'konzilijum-poliklinika-i-bolnica-podgorica');
SET @c_cenex = (SELECT id FROM clinics WHERE slug = 'novi-cenex-medical-podgorica');
SET @c_diag = (SELECT id FROM clinics WHERE slug = 'poliklinika-diagnostica-podgorica');
SET @c_kerber = (SELECT id FROM clinics WHERE slug = 'rezidencija-zdravlja-kerber-podgorica');
SET @c_natal = (SELECT id FROM clinics WHERE slug = 'poliklinika-natal-podgorica');
SET @c_nasa = (SELECT id FROM clinics WHERE slug = 'nasa-medicina-podgorica');

-- ═══ 1. Отвязка: врачей нет в полном списке сайта ═══

-- SmartMed Podgorica: 34
DELETE x FROM clinic_medical_service_doctors x
JOIN doctors d ON d.id = x.doctor_id
WHERE x.clinic_id = @c_smartmed AND d.slug IN (
	'adzic-milena', 'ajsa-kalac', 'aleksandar-vlahovic', 'aleksandra-boskovic',
	'aleksandra-spasic-jokmanovic', 'ana-laban', 'anja-djurovic', 'antonia-mihaljevic',
	'bojan-vucetic', 'danica-izgarevic', 'danica-vesovic', 'danijela-loncar',
	'ivana-lakicevic', 'jelena-labudovic', 'jelena-vukicevic', 'jelena-zekic',
	'jovana-stojic', 'jovica-milovanovic', 'marina-vuceljic', 'miketic-ivana',
	'milic-petar', 'milos-obradovic', 'mirjana-vojvodic', 'mladen-rakus',
	'natasa-vlahovic', 'nevenka-lukovac-janjic', 'nikola-kastratovic', 'tamara-radoman',
	'vasiljka-davidovic', 'velimir-milosevic', 'vladimir-dedovic', 'vladimir-vujovic',
	'irena-maric', 'milica-vusurovic'
);
DELETE dc FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id
WHERE dc.clinic_id = @c_smartmed AND d.slug IN (
	'adzic-milena', 'ajsa-kalac', 'aleksandar-vlahovic', 'aleksandra-boskovic',
	'aleksandra-spasic-jokmanovic', 'ana-laban', 'anja-djurovic', 'antonia-mihaljevic',
	'bojan-vucetic', 'danica-izgarevic', 'danica-vesovic', 'danijela-loncar',
	'ivana-lakicevic', 'jelena-labudovic', 'jelena-vukicevic', 'jelena-zekic',
	'jovana-stojic', 'jovica-milovanovic', 'marina-vuceljic', 'miketic-ivana',
	'milic-petar', 'milos-obradovic', 'mirjana-vojvodic', 'mladen-rakus',
	'natasa-vlahovic', 'nevenka-lukovac-janjic', 'nikola-kastratovic', 'tamara-radoman',
	'vasiljka-davidovic', 'velimir-milosevic', 'vladimir-dedovic', 'vladimir-vujovic',
	'irena-maric', 'milica-vusurovic'
);

-- Vaše zdravlje: 13
DELETE x FROM clinic_medical_service_doctors x
JOIN doctors d ON d.id = x.doctor_id
WHERE x.clinic_id = @c_vz AND d.slug IN (
	'admir-mukovic', 'adrijana-klisic', 'aleksandar-boljevic', 'boskovic-olivera',
	'enisa-pupovic', 'maida-burdzovic', 'milenka-uscumlic', 'mirjana-jovicevic-kracunov',
	'miroslav-radunovic', 'nikola-pavlovic', 'radojka-vukcevic', 'smiljka-vukcevic',
	'vojislav-simun'
);
DELETE dc FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id
WHERE dc.clinic_id = @c_vz AND d.slug IN (
	'admir-mukovic', 'adrijana-klisic', 'aleksandar-boljevic', 'boskovic-olivera',
	'enisa-pupovic', 'maida-burdzovic', 'milenka-uscumlic', 'mirjana-jovicevic-kracunov',
	'miroslav-radunovic', 'nikola-pavlovic', 'radojka-vukcevic', 'smiljka-vukcevic',
	'vojislav-simun'
);

-- Konzilijum: 9
DELETE x FROM clinic_medical_service_doctors x
JOIN doctors d ON d.id = x.doctor_id
WHERE x.clinic_id = @c_konz AND d.slug IN (
	'amer-halilovic', 'damir-muhovic', 'dijana-asanovic', 'maja-mirocevic-rotolo',
	'mirjana-gotic', 'nermin-abdic', 'sabahudin-pupovic', 'velimir-milosevic',
	'vladimir-jovanovic'
);
DELETE dc FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id
WHERE dc.clinic_id = @c_konz AND d.slug IN (
	'amer-halilovic', 'damir-muhovic', 'dijana-asanovic', 'maja-mirocevic-rotolo',
	'mirjana-gotic', 'nermin-abdic', 'sabahudin-pupovic', 'velimir-milosevic',
	'vladimir-jovanovic'
);

-- Novi Cenex Medical: 4
DELETE x FROM clinic_medical_service_doctors x
JOIN doctors d ON d.id = x.doctor_id
WHERE x.clinic_id = @c_cenex AND d.slug IN (
	'aleksandra-furtula', 'dubravka-lopicic', 'milos-gacevic', 'sasa-ljustina'
);
DELETE dc FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id
WHERE dc.clinic_id = @c_cenex AND d.slug IN (
	'aleksandra-furtula', 'dubravka-lopicic', 'milos-gacevic', 'sasa-ljustina'
);

-- Poliklinika Diagnostica: 2
DELETE x FROM clinic_medical_service_doctors x
JOIN doctors d ON d.id = x.doctor_id
WHERE x.clinic_id = @c_diag AND d.slug IN (
	'bojana-miljic', 'marko-buta'
);
DELETE dc FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id
WHERE dc.clinic_id = @c_diag AND d.slug IN (
	'bojana-miljic', 'marko-buta'
);

-- Rezidencija zdravlja Kerber: 4
DELETE x FROM clinic_medical_service_doctors x
JOIN doctors d ON d.id = x.doctor_id
WHERE x.clinic_id = @c_kerber AND d.slug IN (
	'andja-bulajic-vukovic', 'jovana-pesic', 'maja-velimirov', 'svjetlana-raicevic'
);
DELETE dc FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id
WHERE dc.clinic_id = @c_kerber AND d.slug IN (
	'andja-bulajic-vukovic', 'jovana-pesic', 'maja-velimirov', 'svjetlana-raicevic'
);

-- Poliklinika Natal: 5
DELETE x FROM clinic_medical_service_doctors x
JOIN doctors d ON d.id = x.doctor_id
WHERE x.clinic_id = @c_natal AND d.slug IN (
	'irena-maric', 'jelena-jovovic', 'ljubomir-petricevic', 'natasa-vukotic-djuricanin',
	'snezana-rakic'
);
DELETE dc FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id
WHERE dc.clinic_id = @c_natal AND d.slug IN (
	'irena-maric', 'jelena-jovovic', 'ljubomir-petricevic', 'natasa-vukotic-djuricanin',
	'snezana-rakic'
);

-- Naša medicina: 4
DELETE x FROM clinic_medical_service_doctors x
JOIN doctors d ON d.id = x.doctor_id
WHERE x.clinic_id = @c_nasa AND d.slug IN (
	'ankica-ivanovic', 'edita-files-bradaric', 'maida-medjedovic', 'marina-neric-kozarev'
);
DELETE dc FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id
WHERE dc.clinic_id = @c_nasa AND d.slug IN (
	'ankica-ivanovic', 'edita-files-bradaric', 'maida-medjedovic', 'marina-neric-kozarev'
);

-- ═══ 2. Привязка врачей, которые уже есть в БД ═══

-- SmartMed Podgorica
--   albijanic-drago: Dr Drago Albijanić — dječija hirurgija, dječija urologija
--   sladjana-coric: Dr Slađana Ćorić — interna medicina
--   olivera-miketic: Dr Olivera Miketić — interna medicina, endokrinologija
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
SELECT d.id, @c_smartmed FROM doctors d
WHERE @c_smartmed IS NOT NULL AND d.slug IN ('albijanic-drago', 'sladjana-coric', 'olivera-miketic');

-- Vaše zdravlje
--   senad-kalac-2: dr Senad Kalač — specijalista psihijatrije
--   bozovic-bjanka: dr Bjanka Božović — specijalista kardiologije
--   jovan-bubanja: dr Jovan Bubanja — specijalista reumatologije
--   amer-halilovic: Dr Amer Halilović — specijalista pulmologije
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
SELECT d.id, @c_vz FROM doctors d
WHERE @c_vz IS NOT NULL AND d.slug IN ('senad-kalac-2', 'bozovic-bjanka', 'jovan-bubanja', 'amer-halilovic');

-- Konzilijum
--   senad-kalac: /endokrina-hirurgija/ (2024): opšta hirurgija, supspec. endokrine hirurgije
--   tahir-kalac: /vaskularna-hirurgija/ (2024): specijalista opšte hirurgije
--   jovan-bubanja: /reumatologija/: interna medicina, reumatolog
--   slavisa-rabrenovic: /endokrinologija/: interna medicina, endokrinolog
--   vesko-vujicic: /hematologija/: interna medicina, hematologija
--   sabrina-hadziosmanovic: /neurologija/: neurologija, klinička neurofiziologija
--   zeljka-rogac: /neurologija/: neurologija
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
SELECT d.id, @c_konz FROM doctors d
WHERE @c_konz IS NOT NULL AND d.slug IN ('senad-kalac', 'tahir-kalac', 'jovan-bubanja', 'slavisa-rabrenovic', 'vesko-vujicic', 'sabrina-hadziosmanovic', 'zeljka-rogac');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT d.id, s.id FROM doctors d JOIN specialties s ON s.name IN ('endocrine_surgery')
WHERE d.slug = 'senad-kalac';

-- Novi Cenex Medical
--   albijanic-drago: menu: Dječija hirurgija
--   nemanja-vukcevic: menu: Dječija hirurgija
--   zeljko-jelic: bio: specijalista opšte hirurgije
--   nevena-cadjenovic: bio: Dr Nevena Čađenović Šelmić — dermatovenerologija, subspec. alergologije i kliničke imunologije
--   asanin-ilija: bio: Mr sci. med. dr Ilija Ašanin — opšta hirurgija, OB Nikšić
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
SELECT d.id, @c_cenex FROM doctors d
WHERE @c_cenex IS NOT NULL AND d.slug IN ('albijanic-drago', 'nemanja-vukcevic', 'zeljko-jelic', 'nevena-cadjenovic', 'asanin-ilija');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT d.id, s.id FROM doctors d JOIN specialties s ON s.name IN ('allergology', 'immunology')
WHERE d.slug = 'nevena-cadjenovic';

-- Poliklinika Diagnostica
--   radomir-rakocevic: API: spec radiologije
--   emilija-delevic: API: spec ginekologije i akušerstva
--   biljana-andrijasevic: API: diplomirani psiholog
--   slavisa-rabrenovic: API: interna medicina, subspec endokrinologije
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
SELECT d.id, @c_diag FROM doctors d
WHERE @c_diag IS NOT NULL AND d.slug IN ('radomir-rakocevic', 'emilija-delevic', 'biljana-andrijasevic', 'slavisa-rabrenovic');

-- Rezidencija zdravlja Kerber
--   veljovic-radoman-marijana: dr Marijana Veljović Radoman — spec. dermatovenerologije
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
SELECT d.id, @c_kerber FROM doctors d
WHERE @c_kerber IS NOT NULL AND d.slug IN ('veljovic-radoman-marijana');

-- Poliklinika Natal
--   vladimir-prelevic: nas-tim: Interna medicina, specijalista nefrologije
--   vukadinovic-snezana: nas-tim: Dermatologija
--   eldin-sabovic: nas-tim: Interna medicina / specijalista urologije
--   dusanka-radovic: nas-tim: Radiologija
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
SELECT d.id, @c_natal FROM doctors d
WHERE @c_natal IS NOT NULL AND d.slug IN ('vladimir-prelevic', 'vukadinovic-snezana', 'eldin-sabovic', 'dusanka-radovic');

-- Naša medicina
--   radojicic-jelena: dr Jelena Radojičić — specijalista oftalmologije
--   jelena-milonjic: dr Jelena Milonjić — specijalista psihijatrije
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
SELECT d.id, @c_nasa FROM doctors d
WHERE @c_nasa IS NOT NULL AND d.slug IN ('radojicic-jelena', 'jelena-milonjic');

-- ═══ 3. Новые врачи (найти или создать) ═══

-- ─── SmartMed Podgorica ───

-- Maja Karadžić — pediatrics
SET @d = (SELECT id FROM doctors WHERE slug = 'maja-karadzic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Maja Karadžić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Karadžić Maja' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'maja-karadzic', 'Maja Karadžić', 'Маја Караџић', 'Майя Караджич', 'Maja Karadzic', 'dr',
	'https://www.poliklinikasmartmed.me/SmartMed/oljka_sajt_3.png', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'maja-karadzic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_smartmed, NULL FROM dual WHERE @d IS NOT NULL AND @c_smartmed IS NOT NULL;

-- Nevena Jovičić — pediatrics, pediatric_pulmonology
SET @d = (SELECT id FROM doctors WHERE slug = 'nevena-jovicic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Nevena Jovičić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Jovičić Nevena' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nevena-jovicic', 'Nevena Jovičić', 'Невена Јовичић', 'Невена Йовичич', 'Nevena Jovicic', 'dr mr sci. med.',
	'https://www.poliklinikasmartmed.me/SmartMed/3_2.png', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'nevena-jovicic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('pediatrics', 'pediatric_pulmonology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_smartmed, NULL FROM dual WHERE @d IS NOT NULL AND @c_smartmed IS NOT NULL;

-- Stefan Đorđević — pediatrics, rheumatology
SET @d = (SELECT id FROM doctors WHERE slug = 'stefan-djordjevic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Stefan Đorđević' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Đorđević Stefan' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'stefan-djordjevic', 'Stefan Đorđević', 'Стефан Ђорђевић', 'Стефан Джорджевич', 'Stefan Djordjevic', 'dr',
	'https://www.poliklinikasmartmed.me/SmartMed/2_1.png', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'stefan-djordjevic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('pediatrics', 'rheumatology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_smartmed, NULL FROM dual WHERE @d IS NOT NULL AND @c_smartmed IS NOT NULL;

-- Nevena Popovac — pediatrics
SET @d = (SELECT id FROM doctors WHERE slug = 'nevena-popovac' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Nevena Popovac' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Popovac Nevena' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nevena-popovac', 'Nevena Popovac', 'Невена Поповац', 'Невена Поповац', 'Nevena Popovac', 'dr',
	'https://www.poliklinikasmartmed.me/SmartMed/nevena_popovac_sajt.png', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'nevena-popovac'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_smartmed, NULL FROM dual WHERE @d IS NOT NULL AND @c_smartmed IS NOT NULL;

-- Dejan Orlić — internal_medicine, cardiology
SET @d = (SELECT id FROM doctors WHERE slug = 'dejan-orlic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Dejan Orlić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Orlić Dejan' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dejan-orlic', 'Dejan Orlić', 'Дејан Орлић', 'Деян Орлич', 'Dejan Orlic', 'prof. dr',
	'https://www.poliklinikasmartmed.me/SmartMed/thumb_15626_450_0_0_0_crop_2.png', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'dejan-orlic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('internal_medicine', 'cardiology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_smartmed, NULL FROM dual WHERE @d IS NOT NULL AND @c_smartmed IS NOT NULL;

-- Danilo Ćosović — internal_medicine, pulmonology
SET @d = (SELECT id FROM doctors WHERE slug = 'danilo-cosovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Danilo Ćosović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ćosović Danilo' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'danilo-cosovic', 'Danilo Ćosović', 'Данило Ћосовић', 'Данило Чосович', 'Danilo Cosovic', 'dr',
	'https://www.poliklinikasmartmed.me/SmartMed/dr_danilo_600_x_600_px_1_.png', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'danilo-cosovic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('internal_medicine', 'pulmonology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_smartmed, NULL FROM dual WHERE @d IS NOT NULL AND @c_smartmed IS NOT NULL;

-- Milovan Dimitrijević — maxillofacial_surgery
SET @d = (SELECT id FROM doctors WHERE slug = 'milovan-dimitrijevic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Milovan Dimitrijević' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Dimitrijević Milovan' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milovan-dimitrijevic', 'Milovan Dimitrijević', 'Милован Димитријевић', 'Милован Димитриевич', 'Milovan Dimitrijevic', 'prof. dr',
	'https://www.poliklinikasmartmed.me/SmartMed/dimi_m.png', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'milovan-dimitrijevic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('maxillofacial_surgery') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_smartmed, NULL FROM dual WHERE @d IS NOT NULL AND @c_smartmed IS NOT NULL;

-- Jelena Laković — radiology
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-lakovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Jelena Laković' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Laković Jelena' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jelena-lakovic', 'Jelena Laković', 'Јелена Лаковић', 'Елена Лакович', 'Jelena Lakovic', 'dr',
	'https://www.poliklinikasmartmed.me/SmartMed/untitled_design_1.png', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jelena-lakovic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('radiology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_smartmed, NULL FROM dual WHERE @d IS NOT NULL AND @c_smartmed IS NOT NULL;

-- Snežana Blagojević — aesthetic_medicine
SET @d = (SELECT id FROM doctors WHERE slug = 'snezana-blagojevic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Snežana Blagojević' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Blagojević Snežana' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'snezana-blagojevic', 'Snežana Blagojević', 'Снежана Благојевић', 'Снежана Благоевич', 'Snezana Blagojevic', 'dr',
	'https://www.poliklinikasmartmed.me/SmartMed/nina_sajt_1_.png', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'snezana-blagojevic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('aesthetic_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_smartmed, NULL FROM dual WHERE @d IS NOT NULL AND @c_smartmed IS NOT NULL;

-- Ivona Dragović — aesthetic_medicine
SET @d = (SELECT id FROM doctors WHERE slug = 'ivona-dragovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ivona Dragović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Dragović Ivona' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivona-dragovic', 'Ivona Dragović', 'Ивона Драговић', 'Ивона Драгович', 'Ivona Dragovic', 'dr',
	'https://www.poliklinikasmartmed.me/SmartMed/ivona_esettika_sajt_2.png', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ivona-dragovic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('aesthetic_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_smartmed, NULL FROM dual WHERE @d IS NOT NULL AND @c_smartmed IS NOT NULL;

-- Maja Milosavljević — psychiatry
SET @d = (SELECT id FROM doctors WHERE slug = 'maja-milosavljevic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Maja Milosavljević' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Milosavljević Maja' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'maja-milosavljevic', 'Maja Milosavljević', 'Маја Милосављевић', 'Майя Милосавлевич', 'Maja Milosavljevic', 'dr sci. med.',
	'https://www.poliklinikasmartmed.me/SmartMed/untitled_600_x_600_px_.png', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'maja-milosavljevic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('psychiatry') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_smartmed, NULL FROM dual WHERE @d IS NOT NULL AND @c_smartmed IS NOT NULL;

-- ─── Vaše zdravlje ───

-- Vesko Kovijanić — general_medicine
SET @d = (SELECT id FROM doctors WHERE slug = 'vesko-kovijanic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Vesko Kovijanić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Kovijanić Vesko' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vesko-kovijanic', 'Vesko Kovijanić', 'Веско Ковијанић', 'Веско Ковиянич', 'Vesko Kovijanic', 'dr',
	NULL, NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'vesko-kovijanic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_vz, NULL FROM dual WHERE @d IS NOT NULL AND @c_vz IS NOT NULL;

-- ─── Konzilijum ───

-- Milutin Bulajić — gastroenterology
SET @d = (SELECT id FROM doctors WHERE slug = 'milutin-bulajic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Milutin Bulajić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Bulajić Milutin' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milutin-bulajic', 'Milutin Bulajić', 'Милутин Булајић', 'Милутин Булаич', 'Milutin Bulajic', 'dr',
	NULL, NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'milutin-bulajic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('gastroenterology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_konz, NULL FROM dual WHERE @d IS NOT NULL AND @c_konz IS NOT NULL;

-- Gordana Reljić — internal_medicine
SET @d = (SELECT id FROM doctors WHERE slug = 'gordana-reljic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Gordana Reljić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Reljić Gordana' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'gordana-reljic', 'Gordana Reljić', 'Гордана Рељић', 'Гордана Рельич', 'Gordana Reljic', 'dr',
	NULL, NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'gordana-reljic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('internal_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_konz, NULL FROM dual WHERE @d IS NOT NULL AND @c_konz IS NOT NULL;

-- Aleksandra Radojičić — neurology
SET @d = (SELECT id FROM doctors WHERE slug = 'aleksandra-radojicic-2' LIMIT 1);
-- только по slug: в БД есть aleksandra-radojicic — детский офтальмолог (Moj Lab), другой человек
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aleksandra-radojicic-2', 'Aleksandra Radojičić', 'Александра Радојичић', 'Александра Радойичич', 'Aleksandra Radojicic', 'doc. dr',
	NULL, NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'aleksandra-radojicic-2'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('neurology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_konz, NULL FROM dual WHERE @d IS NOT NULL AND @c_konz IS NOT NULL;

-- ─── Novi Cenex Medical ───

-- Milija Mimović — general_surgery
SET @d = (SELECT id FROM doctors WHERE slug = 'milija-mimovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Milija Mimović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Mimović Milija' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milija-mimovic', 'Milija Mimović', 'Милија Мимовић', 'Милия Мимович', 'Milija Mimovic', 'dr',
	'https://cenexmedical.com/wp-content/uploads/2024/07/mimovic-Small.jpg', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'milija-mimovic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('general_surgery') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id UNION ALL SELECT 3) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_cenex, NULL FROM dual WHERE @d IS NOT NULL AND @c_cenex IS NOT NULL;

-- Srđan Perazić — internal_medicine, cardiology
SET @d = (SELECT id FROM doctors WHERE slug = 'srdjan-perazic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Srđan Perazić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Perazić Srđan' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'srdjan-perazic', 'Srđan Perazić', 'Срђан Перазић', 'Срджан Перазич', 'Srdjan Perazic', 'dr',
	'https://cenexmedical.com/wp-content/uploads/2026/01/srdjan-perazic-jpg.jpg', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'srdjan-perazic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('internal_medicine', 'cardiology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_cenex, NULL FROM dual WHERE @d IS NOT NULL AND @c_cenex IS NOT NULL;

-- Žan Mrdović — anesthesiology
SET @d = (SELECT id FROM doctors WHERE slug = 'zan-mrdovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Žan Mrdović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Mrdović Žan' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zan-mrdovic', 'Žan Mrdović', 'Жан Мрдовић', 'Жан Мрдович', 'Zan Mrdovic', 'dr',
	'https://cenexmedical.com/wp-content/uploads/2026/01/zan-mrdovic.jpg', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'zan-mrdovic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('anesthesiology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_cenex, NULL FROM dual WHERE @d IS NOT NULL AND @c_cenex IS NOT NULL;

-- Valentin Sojar — general_surgery, proctology
SET @d = (SELECT id FROM doctors WHERE slug = 'valentin-sojar' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Valentin Sojar' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Sojar Valentin' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'valentin-sojar', 'Valentin Sojar', 'Валентин Сојар', 'Валентин Сояр', 'Valentin Sojar', 'prim. dr',
	'https://cenexmedical.com/wp-content/uploads/2026/01/dr-valentin-sojar.jpg', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'valentin-sojar'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('general_surgery', 'proctology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_cenex, NULL FROM dual WHERE @d IS NOT NULL AND @c_cenex IS NOT NULL;

-- ─── Poliklinika Diagnostica ───

-- Zoran Vratnica — microbiology
SET @d = (SELECT id FROM doctors WHERE slug = 'zoran-vratnica' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Zoran Vratnica' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Vratnica Zoran' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zoran-vratnica', 'Zoran Vratnica', 'Зоран Вратница', 'Зоран Вратница', 'Zoran Vratnica', 'dr sci. med.',
	NULL, NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'zoran-vratnica'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('microbiology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id UNION ALL SELECT 3) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_diag, NULL FROM dual WHERE @d IS NOT NULL AND @c_diag IS NOT NULL;

-- Aleksandra Stanišić — clinical_biochemistry
SET @d = (SELECT id FROM doctors WHERE slug = 'aleksandra-stanisic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Aleksandra Stanišić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Stanišić Aleksandra' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aleksandra-stanisic', 'Aleksandra Stanišić', 'Александра Станишић', 'Александра Станишич', 'Aleksandra Stanisic', 'mr ph',
	NULL, NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'aleksandra-stanisic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('clinical_biochemistry') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id UNION ALL SELECT 3) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_diag, NULL FROM dual WHERE @d IS NOT NULL AND @c_diag IS NOT NULL;

-- Violeta Peković — radiology
SET @d = (SELECT id FROM doctors WHERE slug = 'violeta-pekovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Violeta Peković' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Peković Violeta' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'violeta-pekovic', 'Violeta Peković', 'Виолета Пековић', 'Виолета Пекович', 'Violeta Pekovic', 'dr',
	'https://api.diagnostica.me/uploads/1789116583302-10.jpg', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'violeta-pekovic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('radiology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_diag, NULL FROM dual WHERE @d IS NOT NULL AND @c_diag IS NOT NULL;

-- Stanka Nikač — psychiatry
SET @d = (SELECT id FROM doctors WHERE slug = 'stanka-nikac' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Stanka Nikač' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Nikač Stanka' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'stanka-nikac', 'Stanka Nikač', 'Станка Никач', 'Станка Никач', 'Stanka Nikac', 'dr',
	NULL, NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'stanka-nikac'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('psychiatry') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_diag, NULL FROM dual WHERE @d IS NOT NULL AND @c_diag IS NOT NULL;

-- Natalija Pavličić — psychiatry
SET @d = (SELECT id FROM doctors WHERE slug = 'natalija-pavlicic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Natalija Pavličić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Pavličić Natalija' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'natalija-pavlicic', 'Natalija Pavličić', 'Наталија Павличић', 'Наталия Павличич', 'Natalija Pavlicic', 'dr',
	'https://api.diagnostica.me/uploads/1789116649915-23.jpg', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'natalija-pavlicic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('psychiatry') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_diag, NULL FROM dual WHERE @d IS NOT NULL AND @c_diag IS NOT NULL;

-- Milisav Lalević — otorhinolaryngology
SET @d = (SELECT id FROM doctors WHERE slug = 'milisav-lalevic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Milisav Lalević' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Lalević Milisav' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milisav-lalevic', 'Milisav Lalević', 'Милисав Лалевић', 'Милисав Лалевич', 'Milisav Lalevic', 'dr',
	NULL, NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'milisav-lalevic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('otorhinolaryngology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id UNION ALL SELECT 3) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_diag, NULL FROM dual WHERE @d IS NOT NULL AND @c_diag IS NOT NULL;

-- Angel Trenevski — ophthalmology
SET @d = (SELECT id FROM doctors WHERE slug = 'angel-trenevski' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Angel Trenevski' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Trenevski Angel' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'angel-trenevski', 'Angel Trenevski', 'Ангел Треневски', 'Ангел Треневски', 'Angel Trenevski', 'dr',
	'https://api.diagnostica.me/uploads/1789116662662-24.jpg', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'angel-trenevski'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('ophthalmology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_diag, NULL FROM dual WHERE @d IS NOT NULL AND @c_diag IS NOT NULL;

-- Mileta Golubović — pathological_anatomy
SET @d = (SELECT id FROM doctors WHERE slug = 'mileta-golubovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Mileta Golubović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Golubović Mileta' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mileta-golubovic', 'Mileta Golubović', 'Милета Голубовић', 'Милета Голубович', 'Mileta Golubovic', 'prof. dr',
	'https://api.diagnostica.me/uploads/1789033144498-34.jpg', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'mileta-golubovic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('pathological_anatomy') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_diag, NULL FROM dual WHERE @d IS NOT NULL AND @c_diag IS NOT NULL;

-- Omer Adžović — pediatrics
SET @d = (SELECT id FROM doctors WHERE slug = 'omer-adzovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Omer Adžović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Adžović Omer' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'omer-adzovic', 'Omer Adžović', 'Омер Аџовић', 'Омер Аджович', 'Omer Adzovic', 'dr',
	'https://api.diagnostica.me/uploads/1789558099698-37.jpg', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'omer-adzovic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_diag, NULL FROM dual WHERE @d IS NOT NULL AND @c_diag IS NOT NULL;

-- ─── Rezidencija zdravlja Kerber ───

-- Teodora Jovanović — internal_medicine, cardiology
SET @d = (SELECT id FROM doctors WHERE slug = 'teodora-jovanovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Teodora Jovanović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Jovanović Teodora' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'teodora-jovanovic', 'Teodora Jovanović', 'Теодора Јовановић', 'Теодора Йованович', 'Teodora Jovanovic', 'dr',
	'https://rzkerber.com/wp-content/uploads/2026/04/dr-Teodora-Jovanovic.webp', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'teodora-jovanovic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('internal_medicine', 'cardiology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_kerber, NULL FROM dual WHERE @d IS NOT NULL AND @c_kerber IS NOT NULL;

-- Tanja Šaranović — internal_medicine, gastroenterology
SET @d = (SELECT id FROM doctors WHERE slug = 'tanja-saranovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Tanja Šaranović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Šaranović Tanja' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tanja-saranovic', 'Tanja Šaranović', 'Тања Шарановић', 'Таня Шаранович', 'Tanja Saranovic', 'dr',
	'https://rzkerber.com/wp-content/uploads/2026/04/dr-Tanja-Saranovic.webp', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'tanja-saranovic'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('internal_medicine', 'gastroenterology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_kerber, NULL FROM dual WHERE @d IS NOT NULL AND @c_kerber IS NOT NULL;

-- ─── Naša medicina ───

-- Mevlida Gusinjac — occupational_medicine
SET @d = (SELECT id FROM doctors WHERE slug = 'mevlida-gusinjac' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Mevlida Gusinjac' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Gusinjac Mevlida' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mevlida-gusinjac', 'Mevlida Gusinjac', 'Мевлида Гусињац', 'Мевлида Гусиняц', 'Mevlida Gusinjac', 'dr',
	'https://nasa-medicina.me/wp-content/uploads/2026/06/mevlida-gusinjac.jpg', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'mevlida-gusinjac'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('occupational_medicine') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_nasa, NULL FROM dual WHERE @d IS NOT NULL AND @c_nasa IS NOT NULL;

-- Jelena Nerić — psychology
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-neric' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Jelena Nerić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Nerić Jelena' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jelena-neric', 'Jelena Nerić', 'Јелена Нерић', 'Елена Нерич', 'Jelena Neric', 'mr psihologije',
	'https://nasa-medicina.me/wp-content/uploads/2022/08/jelena-neric.jpg', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jelena-neric'));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('psychology') AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, l.id FROM (SELECT 1 AS id) l WHERE @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c_nasa, 'Osnivač i izvršni direktor' FROM dual WHERE @d IS NOT NULL AND @c_nasa IS NOT NULL;

-- ═══ VERIFICATION ═══

-- Состав клиник после синхронизации (ожидается: SmartMed 68, Vaše zdravlje 13,
-- Konzilijum 52, Novi Cenex 43, Diagnostica 22, Kerber 33, Natal 32, Naša medicina 9;
-- Natal Kids не тронута — 15)
SELECT c.slug, COUNT(dc.id) AS doctors FROM clinics c
LEFT JOIN doctor_clinics dc ON dc.clinic_id = c.id
WHERE c.slug IN ('smartmed-podgorica', 'vase-zdravlje-podgorica', 'konzilijum-poliklinika-i-bolnica-podgorica', 'novi-cenex-medical-podgorica', 'poliklinika-diagnostica-podgorica', 'rezidencija-zdravlja-kerber-podgorica', 'poliklinika-natal-podgorica', 'nasa-medicina-podgorica', 'pedijatrija-natal-kids-podgorica')
GROUP BY c.slug ORDER BY c.slug;

-- Отвязанные — ожидается 0 строк
SELECT c.slug AS clinic, d.slug AS doctor FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id JOIN clinics c ON c.id = dc.clinic_id
WHERE (c.slug, d.slug) IN (
	('smartmed-podgorica', 'adzic-milena'),
	('smartmed-podgorica', 'ajsa-kalac'),
	('smartmed-podgorica', 'aleksandar-vlahovic'),
	('smartmed-podgorica', 'aleksandra-boskovic'),
	('smartmed-podgorica', 'aleksandra-spasic-jokmanovic'),
	('smartmed-podgorica', 'ana-laban'),
	('smartmed-podgorica', 'anja-djurovic'),
	('smartmed-podgorica', 'antonia-mihaljevic'),
	('smartmed-podgorica', 'bojan-vucetic'),
	('smartmed-podgorica', 'danica-izgarevic'),
	('smartmed-podgorica', 'danica-vesovic'),
	('smartmed-podgorica', 'danijela-loncar'),
	('smartmed-podgorica', 'ivana-lakicevic'),
	('smartmed-podgorica', 'jelena-labudovic'),
	('smartmed-podgorica', 'jelena-vukicevic'),
	('smartmed-podgorica', 'jelena-zekic'),
	('smartmed-podgorica', 'jovana-stojic'),
	('smartmed-podgorica', 'jovica-milovanovic'),
	('smartmed-podgorica', 'marina-vuceljic'),
	('smartmed-podgorica', 'miketic-ivana'),
	('smartmed-podgorica', 'milic-petar'),
	('smartmed-podgorica', 'milos-obradovic'),
	('smartmed-podgorica', 'mirjana-vojvodic'),
	('smartmed-podgorica', 'mladen-rakus'),
	('smartmed-podgorica', 'natasa-vlahovic'),
	('smartmed-podgorica', 'nevenka-lukovac-janjic'),
	('smartmed-podgorica', 'nikola-kastratovic'),
	('smartmed-podgorica', 'tamara-radoman'),
	('smartmed-podgorica', 'vasiljka-davidovic'),
	('smartmed-podgorica', 'velimir-milosevic'),
	('smartmed-podgorica', 'vladimir-dedovic'),
	('smartmed-podgorica', 'vladimir-vujovic'),
	('smartmed-podgorica', 'irena-maric'),
	('smartmed-podgorica', 'milica-vusurovic'),
	('vase-zdravlje-podgorica', 'admir-mukovic'),
	('vase-zdravlje-podgorica', 'adrijana-klisic'),
	('vase-zdravlje-podgorica', 'aleksandar-boljevic'),
	('vase-zdravlje-podgorica', 'boskovic-olivera'),
	('vase-zdravlje-podgorica', 'enisa-pupovic'),
	('vase-zdravlje-podgorica', 'maida-burdzovic'),
	('vase-zdravlje-podgorica', 'milenka-uscumlic'),
	('vase-zdravlje-podgorica', 'mirjana-jovicevic-kracunov'),
	('vase-zdravlje-podgorica', 'miroslav-radunovic'),
	('vase-zdravlje-podgorica', 'nikola-pavlovic'),
	('vase-zdravlje-podgorica', 'radojka-vukcevic'),
	('vase-zdravlje-podgorica', 'smiljka-vukcevic'),
	('vase-zdravlje-podgorica', 'vojislav-simun'),
	('konzilijum-poliklinika-i-bolnica-podgorica', 'amer-halilovic'),
	('konzilijum-poliklinika-i-bolnica-podgorica', 'damir-muhovic'),
	('konzilijum-poliklinika-i-bolnica-podgorica', 'dijana-asanovic'),
	('konzilijum-poliklinika-i-bolnica-podgorica', 'maja-mirocevic-rotolo'),
	('konzilijum-poliklinika-i-bolnica-podgorica', 'mirjana-gotic'),
	('konzilijum-poliklinika-i-bolnica-podgorica', 'nermin-abdic'),
	('konzilijum-poliklinika-i-bolnica-podgorica', 'sabahudin-pupovic'),
	('konzilijum-poliklinika-i-bolnica-podgorica', 'velimir-milosevic'),
	('konzilijum-poliklinika-i-bolnica-podgorica', 'vladimir-jovanovic'),
	('novi-cenex-medical-podgorica', 'aleksandra-furtula'),
	('novi-cenex-medical-podgorica', 'dubravka-lopicic'),
	('novi-cenex-medical-podgorica', 'milos-gacevic'),
	('novi-cenex-medical-podgorica', 'sasa-ljustina'),
	('poliklinika-diagnostica-podgorica', 'bojana-miljic'),
	('poliklinika-diagnostica-podgorica', 'marko-buta'),
	('rezidencija-zdravlja-kerber-podgorica', 'andja-bulajic-vukovic'),
	('rezidencija-zdravlja-kerber-podgorica', 'jovana-pesic'),
	('rezidencija-zdravlja-kerber-podgorica', 'maja-velimirov'),
	('rezidencija-zdravlja-kerber-podgorica', 'svjetlana-raicevic'),
	('poliklinika-natal-podgorica', 'irena-maric'),
	('poliklinika-natal-podgorica', 'jelena-jovovic'),
	('poliklinika-natal-podgorica', 'ljubomir-petricevic'),
	('poliklinika-natal-podgorica', 'natasa-vukotic-djuricanin'),
	('poliklinika-natal-podgorica', 'snezana-rakic'),
	('nasa-medicina-podgorica', 'ankica-ivanovic'),
	('nasa-medicina-podgorica', 'edita-files-bradaric'),
	('nasa-medicina-podgorica', 'maida-medjedovic'),
	('nasa-medicina-podgorica', 'marina-neric-kozarev')
);

-- Новые и привязанные врачи: специальности и клиники
SELECT d.slug, d.name_sr, d.name_sr_cyrl, d.name_ru, d.professional_title,
	(SELECT GROUP_CONCAT(s.name ORDER BY s.name) FROM doctor_specialties ds JOIN specialties s ON s.id = ds.specialty_id WHERE ds.doctor_id = d.id) AS specialties,
	(SELECT GROUP_CONCAT(c.slug ORDER BY c.slug) FROM doctor_clinics dc JOIN clinics c ON c.id = dc.clinic_id WHERE dc.doctor_id = d.id) AS clinics
FROM doctors d
WHERE d.slug IN (
	'maja-karadzic', 'nevena-jovicic', 'stefan-djordjevic', 'nevena-popovac', 'dejan-orlic', 'danilo-cosovic', 'milovan-dimitrijevic', 'jelena-lakovic', 'snezana-blagojevic', 'ivona-dragovic', 'maja-milosavljevic', 'vesko-kovijanic', 'milutin-bulajic', 'gordana-reljic', 'aleksandra-radojicic-2', 'milija-mimovic', 'srdjan-perazic', 'zan-mrdovic', 'valentin-sojar', 'zoran-vratnica', 'aleksandra-stanisic', 'violeta-pekovic', 'stanka-nikac', 'natalija-pavlicic', 'milisav-lalevic', 'angel-trenevski', 'mileta-golubovic', 'omer-adzovic', 'teodora-jovanovic', 'tanja-saranovic', 'mevlida-gusinjac', 'jelena-neric', 'albijanic-drago', 'sladjana-coric', 'olivera-miketic', 'senad-kalac-2', 'bozovic-bjanka', 'jovan-bubanja', 'amer-halilovic', 'senad-kalac', 'tahir-kalac', 'slavisa-rabrenovic', 'vesko-vujicic', 'sabrina-hadziosmanovic', 'zeljka-rogac', 'nemanja-vukcevic', 'zeljko-jelic', 'nevena-cadjenovic', 'asanin-ilija', 'radomir-rakocevic', 'emilija-delevic', 'biljana-andrijasevic', 'veljovic-radoman-marijana', 'vladimir-prelevic', 'vukadinovic-snezana', 'eldin-sabovic', 'dusanka-radovic', 'radojicic-jelena', 'jelena-milonjic'
)
ORDER BY d.slug;
