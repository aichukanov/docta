-- ═══════════════════════════════════════════════════════════════════════════
-- Todorović Ophthalmology & Aesthetics (Kotor) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-todorovic-ophthalmology-aesthetics-kotor-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-todorovic-ophthalmology-aesthetics-kotor.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта (источник каждой строки, спорные, исключённые): data/clinic-imports/todorovic-ophthalmology-aesthetics-kotor.json.
-- 
-- Услуг: 27, с ценой: 0 (цен на сайте нет). Новые записи каталога (агент Y, идемпотентно по slug):
--   diabetic-retinopathy-examination, macular-degeneration-examination, polynucleotide-injection, prx-t33-treatment.
-- 22 страницы услуг → 27 строк: «odraslih i djece» → взрослый + детский осмотр, определение диоптрии — из текста страницы осмотра,
-- филлеры → + коррекция губ, ботокс → + гипергидроз, PRP → лицо + волосы, COG и mono niti → две записи;
-- Jalupro Classic и HMW → одна jalupro-biorevitalization (синонимы), Viscoderm Hydrobooster → biorevitalization (синоним).
-- Все услуги привязаны к nenad-todorovic (единственный врач). is_price_outdated не ставится (решение юзера 2026-10-08).
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги и привязки прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJN_zVzNMzTBMRGfsXFs-82Xs' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'todorovic-ophthalmology-aesthetics-kotor' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-todorovic-ophthalmology-aesthetics-kotor.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- Todorović /me/pregled-pacijenata-sa-dijabetskom-reinopatijom — «specijalizovani oftalmološki pregled namenjen otkrivanju i praćenju oštećenja mrežnjače uzrokovanih dijabetesom … traje oko 30-60 minuta». Отдельной записи нет (есть только panretinal-laser-photocoagulation — лечение, fundus-photography / OCT — методы). По схеме complete-glaucoma-examination: кат. 23, спец. 6.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'diabetic-retinopathy-examination', 'Diabetic Retinopathy Examination', 'Pregled kod dijabetske retinopatije', 'Преглед код дијабетске ретинопатије',
	'Обследование при диабетической ретинопатии', 'Untersuchung bei diabetischer Retinopathie', 'Diyabetik retinopati muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'diabetic-retinopathy-examination' OR name_en = 'Diabetic Retinopathy Examination');

-- Todorović /me/pregled-pacijenata-senilnom-degeneracijom-zute-mrlje — «Pregled pacijenata sa senilnom degeneracijom žute mrlje (makularna degeneracija) … sveobuhvatan oftalmološki pregled … traje oko 60-90 minuta». Записи нет (oct-macula-analysis — один метод, macular-function-test-with-amsler-grid — один тест, macular-surgery — операция). По схеме complete-glaucoma-examination: кат. 23, спец. 6.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'macular-degeneration-examination', 'Macular Degeneration Examination', 'Pregled kod degeneracije žute mrlje', 'Преглед код дегенерације жуте мрље',
	'Обследование при макулярной дегенерации', 'Untersuchung bei Makuladegeneration', 'Makula dejenerasyonu muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'macular-degeneration-examination' OR name_en = 'Macular Degeneration Examination');

-- Todorović /me/polinukleotidi-newest-plinest-plinest-eye — «Polinukleotidi, uključujući Newest, Plinest, i Plinest Eye … kompanije Mastelli … Materijal se potom injektuje tankim iglicama u kožu». Класс препаратов (PN), в каталоге нет ни общей, ни брендовой записи; бренды Mastelli (Plinest, Newest, Plinest Eye) — синонимами. Схема как у biorevitalization / profhilo-treatment: кат. 18 + 24, спец. 7 + 44.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'polynucleotide-injection', 'Polynucleotide Injection', 'Tretman polinukleotidima', 'Третман полинуклеотидима',
	'Инъекции полинуклеотидов', 'Polynukleotid-Injektion', 'Polinükleotid enjeksiyonu', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'polynucleotide-injection' OR name_en = 'Polynucleotide Injection');

-- Todorović /me/prx-t33 — «PRX T33 je medicinski preparat iz WIQo linije koji sadrži 33% trihlorsirćetnu kiselinu i hidrogen-peroksid … ne uzrokuje eksfolijaciju površinskih slojeva kože … biorevitalizaciju kože bez … uboda». Сайт отделяет его и от пилингов, и от инъекционной биоревитализации; в каталоге записи нет. Кат. 24, спец. 7 + 44.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'prx-t33-treatment', 'PRX-T33 Treatment', 'PRX-T33 tretman', 'PRX-T33 третман',
	'Процедура PRX-T33', 'PRX-T33-Behandlung', 'PRX-T33 uygulaması', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'prx-t33-treatment' OR name_en = 'PRX-T33 Treatment');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 18 FROM medical_services WHERE slug IN ('polynucleotide-injection');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 23 FROM medical_services WHERE slug IN ('diabetic-retinopathy-examination', 'macular-degeneration-examination');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 24 FROM medical_services WHERE slug IN ('polynucleotide-injection', 'prx-t33-treatment');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 6 FROM medical_services WHERE slug IN ('diabetic-retinopathy-examination', 'macular-degeneration-examination');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 7 FROM medical_services WHERE slug IN ('polynucleotide-injection', 'prx-t33-treatment');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 44 FROM medical_services WHERE slug IN ('polynucleotide-injection', 'prx-t33-treatment');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Pregled pacijenata sa dijabetskom retinopatijom', 'sr' FROM medical_services WHERE slug = 'diabetic-retinopathy-examination'
UNION ALL SELECT id, 'Преглед пацијената са дијабетском ретинопатијом', 'sr-cyrl' FROM medical_services WHERE slug = 'diabetic-retinopathy-examination'
UNION ALL SELECT id, 'Diabetic Eye Exam', 'en' FROM medical_services WHERE slug = 'diabetic-retinopathy-examination'
UNION ALL SELECT id, 'Осмотр глазного дна при диабете', 'ru' FROM medical_services WHERE slug = 'diabetic-retinopathy-examination'
UNION ALL SELECT id, 'Pregled kod senilne degeneracije žute mrlje', 'sr' FROM medical_services WHERE slug = 'macular-degeneration-examination'
UNION ALL SELECT id, 'Преглед код сениле дегенерације жуте мрље', 'sr-cyrl' FROM medical_services WHERE slug = 'macular-degeneration-examination'
UNION ALL SELECT id, 'Pregled kod makularne degeneracije', 'sr' FROM medical_services WHERE slug = 'macular-degeneration-examination'
UNION ALL SELECT id, 'AMD Examination', 'en' FROM medical_services WHERE slug = 'macular-degeneration-examination'
UNION ALL SELECT id, 'Обследование при ВМД', 'ru' FROM medical_services WHERE slug = 'macular-degeneration-examination'
UNION ALL SELECT id, 'Polinukleotidi', 'sr' FROM medical_services WHERE slug = 'polynucleotide-injection'
UNION ALL SELECT id, 'Полинуклеотиди', 'sr-cyrl' FROM medical_services WHERE slug = 'polynucleotide-injection'
UNION ALL SELECT id, 'Plinest', 'en' FROM medical_services WHERE slug = 'polynucleotide-injection'
UNION ALL SELECT id, 'Plinest', 'sr' FROM medical_services WHERE slug = 'polynucleotide-injection'
UNION ALL SELECT id, 'Plinest Eye', 'en' FROM medical_services WHERE slug = 'polynucleotide-injection'
UNION ALL SELECT id, 'Newest', 'en' FROM medical_services WHERE slug = 'polynucleotide-injection'
UNION ALL SELECT id, 'Polynucleotides', 'en' FROM medical_services WHERE slug = 'polynucleotide-injection'
UNION ALL SELECT id, 'Полинуклеотиды', 'ru' FROM medical_services WHERE slug = 'polynucleotide-injection'
UNION ALL SELECT id, 'Плинест', 'ru' FROM medical_services WHERE slug = 'polynucleotide-injection'
UNION ALL SELECT id, 'Polynukleotide', 'de' FROM medical_services WHERE slug = 'polynucleotide-injection'
UNION ALL SELECT id, 'PRX T33', 'en' FROM medical_services WHERE slug = 'prx-t33-treatment'
UNION ALL SELECT id, 'PRX T33', 'sr' FROM medical_services WHERE slug = 'prx-t33-treatment'
UNION ALL SELECT id, 'WiQo PRX-T33', 'en' FROM medical_services WHERE slug = 'prx-t33-treatment'
UNION ALL SELECT id, 'Безыгольная биоревитализация PRX-T33', 'ru' FROM medical_services WHERE slug = 'prx-t33-treatment'
UNION ALL SELECT id, 'Jalupro Classic', 'en' FROM medical_services WHERE slug = 'jalupro-biorevitalization'
UNION ALL SELECT id, 'Jalupro Classic', 'sr' FROM medical_services WHERE slug = 'jalupro-biorevitalization'
UNION ALL SELECT id, 'Jalupro HMW', 'en' FROM medical_services WHERE slug = 'jalupro-biorevitalization'
UNION ALL SELECT id, 'Jalupro HMW', 'sr' FROM medical_services WHERE slug = 'jalupro-biorevitalization'
UNION ALL SELECT id, 'Jalupro mezoterapija', 'sr' FROM medical_services WHERE slug = 'jalupro-biorevitalization'
UNION ALL SELECT id, 'Jalupro мезотерапија', 'sr-cyrl' FROM medical_services WHERE slug = 'jalupro-biorevitalization'
UNION ALL SELECT id, 'Ялупро', 'ru' FROM medical_services WHERE slug = 'jalupro-biorevitalization'
UNION ALL SELECT id, 'Viscoderm Hydrobooster', 'en' FROM medical_services WHERE slug = 'biorevitalization'
UNION ALL SELECT id, 'Viscoderm Hydrobooster', 'sr' FROM medical_services WHERE slug = 'biorevitalization'
UNION ALL SELECT id, 'Microneedling', 'en' FROM medical_services WHERE slug = 'dermapen-microneedling'
UNION ALL SELECT id, 'Microneedling', 'sr' FROM medical_services WHERE slug = 'dermapen-microneedling'
UNION ALL SELECT id, 'Mikronidling', 'sr' FROM medical_services WHERE slug = 'dermapen-microneedling'
UNION ALL SELECT id, 'Микронидлинг', 'sr-cyrl' FROM medical_services WHERE slug = 'dermapen-microneedling'
UNION ALL SELECT id, 'Микронидлинг', 'ru' FROM medical_services WHERE slug = 'dermapen-microneedling'
UNION ALL SELECT id, 'Microneedling-Behandlung', 'de' FROM medical_services WHERE slug = 'dermapen-microneedling'
UNION ALL SELECT id, 'Mikro iğneleme', 'tr' FROM medical_services WHERE slug = 'dermapen-microneedling'
UNION ALL SELECT id, 'Mono niti', 'sr' FROM medical_services WHERE slug = 'mesothreads-treatment'
UNION ALL SELECT id, 'Моно нити', 'sr-cyrl' FROM medical_services WHERE slug = 'mesothreads-treatment'
UNION ALL SELECT id, 'Mono Threads', 'en' FROM medical_services WHERE slug = 'mesothreads-treatment'
UNION ALL SELECT id, 'Мононити', 'ru' FROM medical_services WHERE slug = 'mesothreads-treatment'
UNION ALL SELECT id, 'COG niti', 'sr' FROM medical_services WHERE slug = 'face-lifting-cog-threads'
UNION ALL SELECT id, 'COG нити', 'sr-cyrl' FROM medical_services WHERE slug = 'face-lifting-cog-threads'
UNION ALL SELECT id, 'COG Threads', 'en' FROM medical_services WHERE slug = 'face-lifting-cog-threads'
UNION ALL SELECT id, 'Нити COG', 'ru' FROM medical_services WHERE slug = 'face-lifting-cog-threads';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_todorovic_ophthalmology_aesthetics_kotor;
CREATE TEMPORARY TABLE tmp_todorovic_ophthalmology_aesthetics_kotor (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_todorovic_ophthalmology_aesthetics_kotor (slug, price, price_min, price_max) VALUES
('ophthalmological-examination', NULL, NULL, NULL), -- /me/oftamologija — «Oftalmološki pregled odraslih i djece», FAQ — «Kompletan opsti oftalmološki pregled podrazumijeva vidnu oštrinu, određivanje dioptrije, mjerenje intraokularnog pritiska, širenje zjenice, pregled na biomikroskopu …»
('pediatric-ophthalmological-examination', NULL, NULL, NULL), -- /me/oftamologija — «Oftalmološki pregled odraslih i djece»
('diopter-determination', NULL, NULL, NULL), -- /me/oftamologija — «Šta je određivanje dioptrije na daljinu i blizinu? … Nakon pregleda, dobićete recept sa tačnom dioptrijom … traje oko 20-30 minuta»
('optical-coherence-tomography-oct', NULL, NULL, NULL), -- /me/snimanje-ocnog-dna-na-oct-aparatu — «Snimanje očnog dna na OCT (Optička Koherentna Tomografija) aparatu … mrežnjaču i optički nerv»
('complete-glaucoma-examination', NULL, NULL, NULL), -- /me/pregled-pacijenata-sa-glaukomom — «sveobuhvatan oftalmološki pregled namjenjen dijagnostikovanju i praćenju glaukoma … traje oko 60 minuta»
('diabetic-retinopathy-examination', NULL, NULL, NULL), -- /me/pregled-pacijenata-sa-dijabetskom-reinopatijom — «Pregled pacijenata sa dijabetskom retinopatijom je specijalizovani oftalmološki pregled …»
('macular-degeneration-examination', NULL, NULL, NULL), -- /me/pregled-pacijenata-senilnom-degeneracijom-zute-mrlje — «Pregled pacijenata senilnom degeneracijom žute mrlje i svih oftalmoloških stanja i oboljenja kao i dijagnozu bolesti»
('foreign-body-removal-eye', NULL, NULL, NULL), -- /me/uklanjanje-stranog-tijela-na-biomikroskopu-sa-procjpenom-lampom — «uklanjanje stranih čestica iz oka, kao što su metalne ili drvene opiljke, pesak ili staklo … zahvaljujući lokalnoj anesteziji»
('contact-lens-fitting', NULL, NULL, NULL), -- /me/fitovanje-i-odredjivanje-kontaktnih-sociva — «Fitovanje i određivanje kontaktnih sočiva je oftalmološki tretman koji uključuje precizan odabir odgovarajućih kontaktnih sočiva»
('hyaluronic-acid-filler', NULL, NULL, NULL), -- /me/hijaluronski-fileri — «Hijaluronski fileri ili “supstanca mladosti” … Podmlađivanje lica hijaluronom»
('lip-augmentation', NULL, NULL, NULL), -- /me/hijaluronski-fileri — «Hijaluronski fileri za korekciju usana … Korekcija usana hijaluronom – kako to izgleda kod nas?»
('botox-injection', NULL, NULL, NULL), -- /me/botulin-toxin-botox — «Najčešća primjena botulinskog toksina je u regiji čela, između obrva i oko očiju»
('hyperhidrosis-botox-treatment', NULL, NULL, NULL), -- /me/botulin-toxin-botox — «Botulinski toksin kao rešenje za prekomjerno znojenje … Najčešće se tretira regija pazuha, a pored toga mogu se tretirati i dlanovi i tabani»
('prp-facial-treatment', NULL, NULL, NULL), -- /me/prp-tretman — «Plazma se injektuje u kožu … PRP je idealan tretman za: lice, vrat, dekolte, šake»
('prp-hair-vitality', NULL, NULL, NULL), -- /me/prp-tretman — «PRP kose … injekcijama koje se ubrizgavaju u kožu glave … Zaustavlja opadanje kose»
('jalupro-biorevitalization', NULL, NULL, NULL), -- /me/jalupro-classic — «U našoj ordinaciji naš izbor je Jalupro Classic mezoterapijski koktel», /me/jalupro-hmw — «naš izbor je Jalupro HMW biorevitalizacija» (обе — одна запись Jalupro, варианты — синонимами)
('jalupro-super-hydro-treatment', NULL, NULL, NULL), -- /me/jalupro-super-hydro — «Jalupro Super Hydro … ubrizgavamo preparat u 13 tačno određenih tačaka na koži lica»
('jalupro-young-eye', NULL, NULL, NULL), -- /me/jalupro-young-eye — «Jalupro Young Eye … doktor injektuje preparat u okoloočnu regiju»
('profhilo-treatment', NULL, NULL, NULL), -- /me/profhilio — «PROFHILO je trenutno najpopularniji hijaluronski tretman na svijetu»
('polynucleotide-injection', NULL, NULL, NULL), -- /me/polinukleotidi-newest-plinest-plinest-eye — «Polinukleotidi Newest, Plinest, Plinest eye»
('biorevitalization', NULL, NULL, NULL), -- /me/viscoderm-hydrobooster-i — «Viscoderm Hydroboosteri su hijaluronski gel sa niskim stepenom umreženosti … doktor injektuje preparat tankim iglicama» (skin booster, бренд — синоним)
('chemical-peel', NULL, NULL, NULL), -- /me/hemijski-pilinzi — «Hemijski piling … Hemijskim pilingom možemo tretirati neujednačen ten, ožiljke od akni, hiperpigmentacije, staračke pjege i sitne bore»
('prx-t33-treatment', NULL, NULL, NULL), -- /me/prx-t33 — «PRX T33 je medicinski preparat iz WIQo linije …»
('dermapen-microneedling', NULL, NULL, NULL), -- /me/microneedling — «Microneedling … se izvodi uređajem u obliku olovke s jednokratnom mikroiglicom … microneedling penom uz primjenu mezokoktela»
('lipolysis', NULL, NULL, NULL), -- /me/lipofiza — «Lipoliza … Koristi se koktel lipolitika … preparat se injektuje direktno u masno tkivo»
('face-lifting-cog-threads', NULL, NULL, NULL), -- /me/cog-i-mono-niti — «COG niti su biorazgradive niti koje se koriste za lifting i zatezanje kože lica i vrata … polydioxanone»
('mesothreads-treatment', NULL, NULL, NULL); -- /me/cog-i-mono-niti «Cog i Mono niti» — mono niti (= mezoniti)

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_todorovic_ophthalmology_aesthetics_kotor t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_todorovic_ophthalmology_aesthetics_kotor t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_todorovic_ophthalmology_aesthetics_kotor t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 27
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_todorovic_ophthalmology_aesthetics_kotor_ds;
CREATE TEMPORARY TABLE tmp_todorovic_ophthalmology_aesthetics_kotor_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_todorovic_ophthalmology_aesthetics_kotor_ds (doctor_slug, service_slug) VALUES
('nenad-todorovic', 'ophthalmological-examination'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'pediatric-ophthalmological-examination'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'diopter-determination'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'optical-coherence-tomography-oct'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'complete-glaucoma-examination'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'diabetic-retinopathy-examination'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'macular-degeneration-examination'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'foreign-body-removal-eye'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'contact-lens-fitting'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'hyaluronic-acid-filler'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'lip-augmentation'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'botox-injection'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'hyperhidrosis-botox-treatment'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'prp-facial-treatment'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'prp-hair-vitality'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'jalupro-biorevitalization'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'jalupro-super-hydro-treatment'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'jalupro-young-eye'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'profhilo-treatment'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'polynucleotide-injection'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'biorevitalization'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'chemical-peel'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'prx-t33-treatment'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'dermapen-microneedling'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'lipolysis'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'face-lifting-cog-threads'), -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)
('nenad-todorovic', 'mesothreads-treatment'); -- единственный врач ординации (o-nama: dr Nenad Todorović — oftalmolog, estetska medicina, вторая — медсестра)

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_todorovic_ophthalmology_aesthetics_kotor_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_todorovic_ophthalmology_aesthetics_kotor_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 27 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 27 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

-- Ожидается 4: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(x.specialty_id) FROM medical_services_specialties x WHERE x.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('diabetic-retinopathy-examination', 'macular-degeneration-examination', 'polynucleotide-injection', 'prx-t33-treatment');

DROP TEMPORARY TABLE IF EXISTS tmp_todorovic_ophthalmology_aesthetics_kotor;
DROP TEMPORARY TABLE IF EXISTS tmp_todorovic_ophthalmology_aesthetics_kotor_ds;
