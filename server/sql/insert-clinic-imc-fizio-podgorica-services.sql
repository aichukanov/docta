-- ═══════════════════════════════════════════════════════════════════════════
-- IMC Fizio (Podgorica) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-imc-fizio-podgorica-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-imc-fizio-podgorica.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта (источник каждой строки, спорные, исключённые): data/clinic-imports/imc-fizio-podgorica.json.
-- 
-- Услуг: 12, с ценой: 0 (цен на сайте нет; «50% popusta na prvu sesiju» — промо, не цена). Новых записей каталога: 0.
-- 13 страниц услуг → 12 строк: Mastercare (švedski trakcioni sto) — синоним mechanical-spinal-traction, PNF — уже синоним kinesiotherapy;
-- Spinalna trakcija → mechanical-spinal-traction + spinal-decompression (страница описывает и вертебральную тракцию, и DTK).
-- Не заведены: «Termoterapija i krioterapija», «Manuelna terapija», «Edukacija i savjetovanje» — общий текст вкладки «Liječenje»
-- («neki od ključnih segmenata liječenja u fizikalnoj terapiji»), а не перечень услуг. is_price_outdated не ставится (решение юзера 2026-10-08).
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги и привязки прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJLfQykhTrTRMRa2HADgzJ7G8' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'imc-fizio-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-imc-fizio-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'BTL TR-Therapy', 'en' FROM medical_services WHERE slug = 'tecar-therapy'
UNION ALL SELECT id, 'Spinalna trakcija', 'sr' FROM medical_services WHERE slug = 'mechanical-spinal-traction'
UNION ALL SELECT id, 'Спинална тракција', 'sr-cyrl' FROM medical_services WHERE slug = 'mechanical-spinal-traction'
UNION ALL SELECT id, 'Spinal Traction', 'en' FROM medical_services WHERE slug = 'mechanical-spinal-traction'
UNION ALL SELECT id, 'Mastercare', 'en' FROM medical_services WHERE slug = 'mechanical-spinal-traction'
UNION ALL SELECT id, 'Mastercare', 'sr' FROM medical_services WHERE slug = 'mechanical-spinal-traction'
UNION ALL SELECT id, 'Švedski trakcioni sto', 'sr' FROM medical_services WHERE slug = 'mechanical-spinal-traction'
UNION ALL SELECT id, 'Шведски тракциони сто', 'sr-cyrl' FROM medical_services WHERE slug = 'mechanical-spinal-traction'
UNION ALL SELECT id, 'Dekompresiona terapija kičme', 'sr' FROM medical_services WHERE slug = 'spinal-decompression'
UNION ALL SELECT id, 'Декомпресиона терапија кичме', 'sr-cyrl' FROM medical_services WHERE slug = 'spinal-decompression'
UNION ALL SELECT id, 'Vakuum terapija', 'sr' FROM medical_services WHERE slug = 'vacuum-massage'
UNION ALL SELECT id, 'Вакуум терапија', 'sr-cyrl' FROM medical_services WHERE slug = 'vacuum-massage'
UNION ALL SELECT id, 'Vacuum Therapy', 'en' FROM medical_services WHERE slug = 'vacuum-massage'
UNION ALL SELECT id, 'Вакуумная терапия', 'ru' FROM medical_services WHERE slug = 'vacuum-massage'
UNION ALL SELECT id, 'Bioptron', 'en' FROM medical_services WHERE slug = 'infrared-ultraviolet-and-bioptron-lamp-irradiation'
UNION ALL SELECT id, 'Bioptron', 'sr' FROM medical_services WHERE slug = 'infrared-ultraviolet-and-bioptron-lamp-irradiation'
UNION ALL SELECT id, 'Bioptron svjetlosna terapija', 'sr' FROM medical_services WHERE slug = 'infrared-ultraviolet-and-bioptron-lamp-irradiation'
UNION ALL SELECT id, 'Bioptron свјетлосна терапија', 'sr-cyrl' FROM medical_services WHERE slug = 'infrared-ultraviolet-and-bioptron-lamp-irradiation'
UNION ALL SELECT id, 'Bioptron Light Therapy', 'en' FROM medical_services WHERE slug = 'infrared-ultraviolet-and-bioptron-lamp-irradiation'
UNION ALL SELECT id, 'Светотерапия Биоптрон', 'ru' FROM medical_services WHERE slug = 'infrared-ultraviolet-and-bioptron-lamp-irradiation'
UNION ALL SELECT id, 'Bioptron-Lichttherapie', 'de' FROM medical_services WHERE slug = 'infrared-ultraviolet-and-bioptron-lamp-irradiation';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_imc_fizio_podgorica;
CREATE TEMPORARY TABLE tmp_imc_fizio_podgorica (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_imc_fizio_podgorica (slug, price, price_min, price_max) VALUES
('tecar-therapy', NULL, NULL, NULL), -- /usluge/tecar-terapija — «Tecar terapija Podgorica - BTL-6000 Elite TR-Therapy … U zavisnosti od regije koja se tretira tretman traje od 15 do 30 minuta»
('electrotherapy', NULL, NULL, NULL), -- /usluge/elektroterapija — «Elektroterapija Podgorica - BTL-4825SL Premium aparat … korišćenje brojnih modaliteta električne struje»
('ultrasound-therapy', NULL, NULL, NULL), -- /usluge/ultrazvucna-terapija — «Ultrazvučna terapija Podgorica - dubinska stimulacija tkiva»
('laser-therapy', NULL, NULL, NULL), -- /usluge/laseroterapija — «LASEROTERAPIJA je potpuno prirodna i neinvazivna metoda lijecenja»
('shock-wave-therapy', NULL, NULL, NULL), -- /usluge/shockwave-terapija — «SHOCKWAVE TERAPIJA ili terapija udarnim talasima … Efekti radijalne terapije shockwave talasima»
('mechanical-spinal-traction', NULL, NULL, NULL), -- /usluge/spinalna-trakcija — «Trakcija cervikalnog (vratnog) dijela kičme», «Trakcija lumbalnog (L/S) dijela kičme», «kompjuterska trakcija cervikalne i lumbalne kičme», /usluge/mastercare — «MASTERCARE (svedski trakcioni sto) … način istezanja … Master Back-A-Traction sto» (Mastercare — синоним, отдельной записи не заводим)
('spinal-decompression', NULL, NULL, NULL), -- /usluge/spinalna-trakcija — «Dekompresiona terapija kičme (DTK) je izuzetno uspješna neoperativna procedura … na sofisticiranom stolu (BTL-6000)»
('vacuum-massage', NULL, NULL, NULL), -- /usluge/vakuum-terapija — «VAKUUM TERAPIJA (kompresivna terapija) … primjena promjenljivog ili stalnog pritiska na povrijedjeni dio tijela» (единственная запись вакуумной процедуры в кат. 5)
('infrared-ultraviolet-and-bioptron-lamp-irradiation', NULL, NULL, NULL), -- /usluge/bioptron-terapija — «BIOPTRON SVJETLOSNA TERAPIJA … posebnu vrtstu svjetlosti … bez stetnog UV zracenja» (единственная запись с Bioptron)
('bobath-therapy', NULL, NULL, NULL), -- /usluge/bobath-koncept — «BOBATH KONCEPT je vazan pristup u osposobljavanju osoba sa neuroloskim ostecenjima», главная — «Bobath koncept u radu sa djecom koja imaju smetnje u razvoju, omladinom i odraslima»
('kinesiotherapy', NULL, NULL, NULL), -- /usluge/kineziterapija — «U kineziterapiji primjenjujemo sve tipove vježbi: pasivne, aktivne, aktivno potpomognute, kao I primjena Bobath i PNF koncepta», /usluge/pnf-koncept — «PNF (proprioceptivna neuromuskularna facilitacija) je koncept» (PNF — уже синоним kinesiotherapy)
('therapeutic-massage-complete', NULL, NULL, NULL); -- /usluge/manuelna-masaza — «MANUELNA MASAZA je tehnika tretiranja misica i mekih tkiva koja se izvodi rucno … Cilj je poboljsati cirkulaciju krvi, smanjiti napetost misica» (зона и длительность не указаны — generic, как в fizio-tim-podgorica)

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_imc_fizio_podgorica t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_imc_fizio_podgorica t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_imc_fizio_podgorica t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 12
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_imc_fizio_podgorica_ds;
CREATE TEMPORARY TABLE tmp_imc_fizio_podgorica_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_imc_fizio_podgorica_ds (doctor_slug, service_slug) VALUES
('filip-pejovic', 'tecar-therapy'), -- косвенно: единственный названный специалист — «Fizioterapeut Filip Pejović … vodi programe … Usluge koje pružamo: …»
('filip-pejovic', 'electrotherapy'), -- косвенно: единственный названный специалист — «Fizioterapeut Filip Pejović … vodi programe … Usluge koje pružamo: …»
('filip-pejovic', 'ultrasound-therapy'), -- косвенно: единственный названный специалист — «Fizioterapeut Filip Pejović … vodi programe … Usluge koje pružamo: …»
('filip-pejovic', 'laser-therapy'), -- косвенно: единственный названный специалист — «Fizioterapeut Filip Pejović … vodi programe … Usluge koje pružamo: …»
('filip-pejovic', 'shock-wave-therapy'), -- косвенно: единственный названный специалист — «Fizioterapeut Filip Pejović … vodi programe … Usluge koje pružamo: …»
('filip-pejovic', 'mechanical-spinal-traction'), -- косвенно: единственный названный специалист — «Fizioterapeut Filip Pejović … vodi programe … Usluge koje pružamo: …»
('filip-pejovic', 'spinal-decompression'), -- косвенно: единственный названный специалист — «Fizioterapeut Filip Pejović … vodi programe … Usluge koje pružamo: …»
('filip-pejovic', 'vacuum-massage'), -- косвенно: единственный названный специалист — «Fizioterapeut Filip Pejović … vodi programe … Usluge koje pružamo: …»
('filip-pejovic', 'infrared-ultraviolet-and-bioptron-lamp-irradiation'), -- косвенно: единственный названный специалист — «Fizioterapeut Filip Pejović … vodi programe … Usluge koje pružamo: …»
('filip-pejovic', 'bobath-therapy'), -- сертификат «Bobath NRT» + единственный названный специалист
('filip-pejovic', 'kinesiotherapy'), -- косвенно: единственный названный специалист — «Fizioterapeut Filip Pejović … vodi programe … Usluge koje pružamo: …»
('filip-pejovic', 'therapeutic-massage-complete'); -- косвенно: единственный названный специалист — «Fizioterapeut Filip Pejović … vodi programe … Usluge koje pružamo: …»

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_imc_fizio_podgorica_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_imc_fizio_podgorica_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 12 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 12 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_imc_fizio_podgorica;
DROP TEMPORARY TABLE IF EXISTS tmp_imc_fizio_podgorica_ds;
