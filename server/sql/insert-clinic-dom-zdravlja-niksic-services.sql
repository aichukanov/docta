-- ═══════════════════════════════════════════════════════════════════════════
-- ZU Dom zdravlja Nikšić — услуги (без цен)
-- Run (после insert-clinic-dom-zdravlja-niksic.sql):
--   mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dom-zdravlja-niksic-services.sql
--
-- Цен на сайте нет (11+ страниц, wp-json pages/posts). Тарифы ФЗОЦГ ценами клиники
-- не ставятся. Услуги — только названные сайтом: амбулатории избранных врачей,
-- описанные службы, перечень патронажных визитов («Uredba o obimu prava…»),
-- перечень справок и осмотров службы медицины труда и спорта.
-- Записи каталога только существующие; клиника резолвится по google_place_id/slug.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJpxHe9q2pTRMRPnJUfQGgX_s' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-niksic' LIMIT 1));

-- Новых записей каталога нет (правило подволны 2b для ДЗ): только существующие slug.
DROP TEMPORARY TABLE IF EXISTS tmp_dzf_niksic_services;
CREATE TEMPORARY TABLE tmp_dzf_niksic_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	code VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_dzf_niksic_services (slug, price, code) VALUES
-- ── /izabrani-doktor/ ──
('general-practitioner-examination', NULL, NULL), -- Izabrani doktor za odrasle … kurativni rad koji podrazumijeva: dijagnostiku, liječenje i rehabilitaciju bolesti i povreda
('home-visit-examination', NULL, NULL), -- liječenje u stanu bolesnika
-- ── /izabrani-doktor-za-djecu/ ──
('pediatric-examination', NULL, NULL), -- U svakodnevnom radu izabranih doktora za djecu obavljaju se preventivni i kurativni pregledi
('pediatric-vaccination-and-revaccination-by-schedule', NULL, NULL), -- kao i vakcinacija, po redovnom kalendaru vakcinacije
-- ── post 2025-10-21 ──
('influenza-vaccination', NULL, NULL), -- Danas počinje vakcinacija protiv sezonskog gripa u DZ Nikšić
-- ── /izabrani-doktor-za-zene/, naslovna ──
('gynecological-specialist-examination', NULL, NULL), -- GINEKOLOŠKA AMBULANTA +382 40 204 620; Izabrani doktor za žene
-- ── post 2026-02-04 ──
('gynecological-ultrasound', NULL, NULL), -- u ginekološkoj ambulanti dobijen novi Ultazvučni aparat sa 4D sondom koji omogućava preciznu dijagnostiku
-- ── post 2026-04-01 ──
('internist-examination', NULL, NULL), -- rekonstrukcija i adaptacija internističke ambulante … uslovi za dijagnostiku, terapiju
-- ── /centri-za-podrsku/ ──
('pulmonologist-examination', NULL, NULL), -- Centar za plućne bolesti i TBC pruža specijalističko-konsultativne usluge iz domena prevencije, dijagnostike, praćenja i liječenje akutnih i hroničnih bolesti pluća i tuberkuloze
('first-psychiatrist-examination', NULL, NULL), -- Centar za mentalno zdravlje … usmjeren na rano otkrivanje, dijagnostiku, očuvanje i liječenje mentalnog zdravlja pacijenata; 3 doktora spec. psihijatrije
('microbiology-sample-collection', NULL, NULL), -- Mikrobiološka laboratorija … Djelatnost se sprovodi kroz sljedeće aktivnosti: uzorkovanje, ispitivanje, izvještavanje
-- ── /jedinica-za-fizikalnu-terapiju-primarnog-nivoa/ ──
('first-physiatrist-examination', NULL, NULL), -- Fizijatar obavlja specijalistički pregled i određuje vrstu fizikalne terapije
-- ── /jedinica-za-patronazu/ ──
('pregnancy-patronage-visit-birth-and-newborn-care-preparation', NULL, NULL), -- posjeta trudnici sa zdravstvenim vaspitanjem
('postpartum-patronage-visit', NULL, NULL), -- posjeta kod babinjare sa zdravstvenim vaspitanjem
('home-patronage-visit-child-age-2', NULL, NULL), -- posjeta kod djeteta u drugoj godini života
('home-patronage-visit-child-age-4', NULL, NULL), -- posjeta kod djeteta u četvrtoj godini života
('patronage-visit-for-women-without-gynecological-visit-3-years', NULL, NULL), -- posjeta kod žena koje više od tri godine nijesu bile kod ginekologa
('chronic-patient-patronage-visit', NULL, NULL), -- posjete hroničnim bolesnicima
('senior-patronage-visit-over-65', NULL, NULL), -- posjeta starijim od 65 godina koji u kalendarskoj godini nijesu bili kod izabranog doktora
('family-health-social-problem-patronage-visit', NULL, NULL), -- porodicama koje imaju zdravstveno-socijalne probleme ili brinu o invalidnoj osobi
('active-tb-patient-patronage-visit', NULL, NULL), -- posjete kod lica sa aktivnom tuberkolozom
('immobile-patient-patronage-visit', NULL, NULL), -- posjeta kod bolesnika kome je potrebna djelimična ili potpuna pomoć kod izvođenja osnovnih životnih aktivnosti zbog bolesti ili starosti
('family-with-elderly-or-disabled-member-patronage-visit', NULL, NULL), -- posjeta porodici koja se brine o invalidnoj osobi, teškom bolesniku ili o staroj osobi
-- ── /sluzba-medicine-rada-i-sporta…/ ──
('pre-employment-medical-certificate', NULL, NULL), -- ocjenu radne sposobnosti prije stupanja na rad … prethodni … pregled
-- ── /sluzba-medicine-rada-i-sporta…/, /sportska-medicina/ ──
('sports-medical-examination', NULL, NULL), -- Sportsko-medicinski pregled obuhvata: Fizikalni pregled po sistemima; Antropometrija; EKG; Spirometrija; Dodatni konsultativni pregledi
-- ── /sluzba-medicine-rada-i-sporta…/ ──
('medical-certificate-for-driving-license-category-a-b-c-d-e', NULL, NULL), -- pregleda za utvrđivanje zdrastvene sposobnosti … kandidata za upravljanje motornim vozilima svih kategorija
('medical-certificate-for-firearms-possession', NULL, NULL), -- ocjenu podobnosti za posjedovanje oružja
('medical-certificate-for-continued-education', NULL, NULL), -- Izdajemo ljekarska uvjerenja za nastavak školovanja
('medical-certificate-for-collective-accommodation', NULL, NULL), -- kolektivni smještaj
('medical-certificate-for-life-insurance', NULL, NULL), -- radi životnog osiguranja
('medical-certificate-for-child-adoption', NULL, NULL), -- o podobnosti za usvajanje djeteta
('medical-certificate-for-underage-marriage', NULL, NULL); -- za sklapanje braka maloljetne osobe

-- Страховка: slug, не найденные в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_service FROM tmp_dzf_niksic_services t LEFT JOIN medical_services ms ON ms.slug = t.slug WHERE ms.id IS NULL;

-- is_price_outdated не ставится (решение юзера 2026-10-08).
INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, NULL, NULL, t.code
FROM tmp_dzf_niksic_services t JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = VALUES(price), price_min = VALUES(price_min), price_max = VALUES(price_max), code = VALUES(code);

-- Самоисправление: услуги клиники, которых больше нет в списке.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_dzf_niksic_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════
-- Ожидается 32 услуг, с ценой 0, сумма цен 0.00, лабораторных анализов 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL) AS with_price, SUM(price) AS price_sum,
	(SELECT COUNT(*) FROM clinic_lab_tests WHERE clinic_id = @clinic_id) AS lab_tests
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_dzf_niksic_services;
