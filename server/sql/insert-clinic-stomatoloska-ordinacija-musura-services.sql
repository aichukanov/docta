-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Mušura (Budva) — услуги
-- Run ПОСЛЕ insert-clinic-stomatoloska-ordinacija-musura.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-stomatoloska-ordinacija-musura-services.sql
--
-- Источник: https://www.musura.me/me/usluge/{oralna-hirurgija, implantologija,
-- protetika, lijecenje-oboljenja-zuba, izbjeljivanje-zuba, ortodoncija,
-- djeciji-kutak, digitalno-snimanje-zuba}
--
-- Все 8 страниц пересверены по полям 2026-07-26 (принудительное NOT STATED,
-- см. docs-конвенцию про ненадёжность пересказов). Привязана ТОЛЬКО та услуга,
-- которая на странице напечатана. То, что «логично для стоматологии», но на
-- сайте не заявлено, не добавлено — список удалённого в шапке ниже.
--
-- ⚠️ ЦЕНЫ: клиника НЕ публикует прейскурант ни на одной странице.
-- Все price / price_min / price_max = NULL (по дизайну, не «na upit»).
--
-- Лабораторных анализов у клиники нет — блока lab_tests в файле нет.
--
-- Всего 44 услуги: 41 из каталога + 3 новые.
--
-- ── Самоисправляющийся ─────────────────────────────────────────────────────
-- Канонический список услуг лежит в temp-таблице, по ней идут И INSERT, И
-- DELETE. Поэтому файл приводит клинику ровно к этому списку: строки, которых
-- в списке нет (например 11 позиций из первой версии файла), удаляются.
-- Одного прогона хватает и на чистой БД, и на той, где применена старая версия.
-- ⚠️ Следствие: услуги, добавленные клинике вручную/в админке, этот прогон
-- снесёт. Перед запуском на живой клинике — либо внести их в список, либо
-- убрать DELETE.
--
-- ── Удалено относительно первой версии файла (11 позиций) ──────────────────
--   Dental Consultation, Orthodontic Consultation — приёмов/консультаций на
--     сайте нет вообще ни на одной странице, это была моя достройка.
--   Biooss Bone Graft 0.5g — граммовка не указана (бренд указан: Bio-Oss).
--   Biooss Membrane Small, Biooss Membrane Large — двойная ошибка: сайт называет
--     мембрану Geistlich Bio-Gide®, а не Bio-Oss, и размер не указан.
--     Заменено на generic «Resorbable Membrane» (Bio-Gide — резорбируемая).
--   Self-Ligating Braces (Metal) per Jaw, Self-Ligating Braces (Ceramic) per Jaw
--     — страница называет «DAMON sistem», но НЕ называет его самолигирующим и
--     НЕ указывает материал. Реально заявленное покрыто Fixed Braces (Metal) и
--     Fixed Braces (Ceramic or Composite).
--   Invisalign Analysis — не заявлена (заявлен только сам INVISALINE SISTEM).
--   Fixed Orthodontic Check-up, Orthodontic Follow-up of Removable Appliance
--     — контрольные приёмы на сайте не заявлены.
--   Complete Pediatric Dental Cleaning — заявлено только «UKLANJANJE MEKIH
--     NASLAGA» (= Soft Dental Deposit Removal).
--
-- ── Добавлено относительно первой версии (2 позиции) ───────────────────────
--   Surgical Exposure Impacted Tooth — страница oralna-hirurgija говорит не
--     только об удалении импактированных зубов, но и об ортодонтическом
--     «izvlačenje očnjaka», т.е. хирургическом обнажении.
--   Resorbable Membrane — Geistlich Bio-Gide®, см. выше.
--
-- ── Открытый вопрос для ревьюера ──────────────────────────────────────────
--   «BEZMETALNI ZIRKON I METALO-KERAMIČKI MOSTOVI» — отдельный печатный
--   заголовок на /protetika, т.е. мосты по материалу клиника заявляет явно.
--   В каталоге записей под мост по материалу нет, мост моделируется как
--   Dental Bridge Abutment (член моста) + соответствующая коронка. Если нужны
--   отдельные сущности («Metal-Free Zirconia Bridge Unit» и т.п.) — сказать.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJ5_aQDJvUTRMREZMDTbIvs3k' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'stomatoloska-ordinacija-musura' LIMIT 1));

-- Категории услуг
SET @cat_dentistry = 20;
SET @cat_pediatric_dentistry = 35;

-- Специальности врачей (авто-привязка категория → специальность)
SET @spec_dentistry = 78;
SET @spec_pediatric_dentistry = 87;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: NEW MEDICAL SERVICES
-- ═══════════════════════════════════════════════════════════════

-- Step 1.1: новые услуги (6 языков + slug)
--   * All on 4 Implant Prosthesis — в каталоге только брендовые (Bredent /
--     Nobel / Straumann / Zimmer / Biotech) и материальные (Acrylic Titanium /
--     Metal Ceramic / Zirconia) варианты; сайт бренд не называет:
--     «Novi koncept All on 4 procedura omogućava da sa ugradnjom minimalnog
--     broja implantata pacijent dobije fiksni rad (most).»
--   * Implant Overdenture with Locators — в каталоге только «… Locators
--     Bredent / Nobel»; сайт бренд не называет: «Ugradnja dva implantata u
--     donjoj vilici omogućava da se principom lokatora potpuno stabilizuje
--     mobilna nadoknada tj. proteza.»
--   * Dental and Soft Tissue Trauma Treatment — печатный заголовок «POVREDE
--     ZUBA I MEKIH TKIVA» в разделе Dječiji kutak; аналога в каталоге не было
--     («Dental First Aid» — про ургентные состояния, не про травму).
-- «All on 4» — торговая марка, во всех локалях остаётся латиницей.
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('All on 4 Implant Prosthesis', 'all-on-4-implant-prosthesis',
	'Implantna proteza All on 4', 'Имплантна протеза All on 4',
	'Имплантационный протез All on 4', 'All-on-4-Implantatprothese', 'All on 4 implant protezi'),
('Implant Overdenture with Locators', 'implant-overdenture-with-locators',
	'Mobilna proteza na implantima sa lokatorima', 'Мобилна протеза на имплантима са локаторима',
	'Съёмный протез на имплантах с локаторами', 'Implantatgetragene Deckprothese mit Locatoren',
	'Lokatörlü implant üstü hareketli protez'),
('Dental and Soft Tissue Trauma Treatment', 'dental-and-soft-tissue-trauma-treatment',
	'Zbrinjavanje povreda zuba i mekih tkiva', 'Збрињавање повреда зуба и меких ткива',
	'Лечение травм зубов и мягких тканей', 'Behandlung von Zahn- und Weichgewebeverletzungen',
	'Diş ve yumuşak doku yaralanmalarının tedavisi')
ON DUPLICATE KEY UPDATE name_en = name_en;

-- sort_order не задаётся: ни одна из новых услуг не является осмотром.

-- Step 1.2: категории для новых услуг
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, @cat_dentistry FROM medical_services WHERE name_en IN (
	'All on 4 Implant Prosthesis',
	'Implant Overdenture with Locators',
	'Dental and Soft Tissue Trauma Treatment'
);

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, @cat_pediatric_dentistry FROM medical_services WHERE name_en IN (
	'Dental and Soft Tissue Trauma Treatment'
);

-- Step 1.3: специальности (DENTISTRY 20 → 78, PEDIATRIC_DENTISTRY 35 → 87)
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, @spec_dentistry FROM medical_services WHERE name_en IN (
	'All on 4 Implant Prosthesis',
	'Implant Overdenture with Locators',
	'Dental and Soft Tissue Trauma Treatment'
);

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, @spec_pediatric_dentistry FROM medical_services WHERE name_en IN (
	'Dental and Soft Tissue Trauma Treatment'
);

-- ═══════════════════════════════════════════════════════════════
-- PART 2: CANONICAL SERVICE LIST
-- Рядом с каждой — печатная формулировка с сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

-- ⚠️ COLLATE обязателен ЯВНО в определении колонки. `SET collation_connection`
-- из шапки влияет только на литералы и сравнения, но НЕ на CREATE TABLE:
-- колонка без COLLATE берёт коллацию БАЗЫ (на MySQL 8 это utf8mb4_0900_ai_ci),
-- и любой JOIN с medical_services.name_en (utf8mb4_unicode_ci) падает с
-- ERROR 1267 «Illegal mix of collations».
DROP TEMPORARY TABLE IF EXISTS tmp_musura_services;
CREATE TEMPORARY TABLE tmp_musura_services (
	name_en VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY
);

INSERT INTO tmp_musura_services (name_en) VALUES
	-- ── Oralna hirurgija ─────────────────────────────────────────
	('Tooth Extraction'),                                -- «Vađenje zuba je procedura, kojoj se pristupa u krajnjem slučaju»
	('Extraction of Semi-Impacted or Impacted Tooth'),   -- impaktirani zubi «se uklanjaju»
	('Surgical Exposure Impacted Tooth'),                -- ортодонтско «izvlačenje očnjaka»
	('Apicoectomy'),                                     -- «uklanjanje patološke lezije sa vrha korijena zuba»
	('Frenectomy'),                                      -- «Uklanjanje nisko pripojenog i izraženog frenuluma gornje usne»

	-- ── Implantologija ───────────────────────────────────────────
	('Dental Implant Placement'),
	('Implant Crown Metal Ceramic'),                     -- «metalo-keramička ili bezmetalna krunica»
	('Metal-Free Implant Crown with Original Abutment'), -- то же, бесметалловый вариант
	('Implant Overdenture with Locators'),               -- «principom lokatora potpuno stabilizuje mobilna nadoknada»
	('All on 4 Implant Prosthesis'),                     -- «Novi koncept All on 4 procedura»
	('Bone Augmentation Biooss'),                        -- «koštani graft koristimo Geistlich Bio-Oss®»
	('Resorbable Membrane'),                             -- «membranu Geistlich Bio-Gide®»

	-- ── Protetika ────────────────────────────────────────────────
	('Metal-Free (Zirconia) Ceramic Crown'),             -- «BEZMETALNE ZIRKON I METALO-KERAMIČKE KRUNICE»
	('Metal-Ceramic Crown'),                             -- там же
	('Dental Bridge Abutment'),                          -- «BEZMETALNI ZIRKON I METALO-KERAMIČKI MOSTOVI» (см. открытый вопрос)
	('Ceramic Veneer'),                                  -- «FASETE (VINIRI)»
	('Complete Denture'),                                -- «TOTALNA PROTEZA»
	('Partial Denture'),                                 -- «PARCIJALNE PROTEZE»
	('Partial Flexible Denture'),                        -- «parcijalne BREFLEX (silikonske) proteze»

	-- ── Liječenje oboljenja zuba ─────────────────────────────────
	('Dental Caries Treatment'),                         -- «Liječenje karijesa i njegovih komplikacija»
	('Composite Filling'),                               -- «KOMPOZITNI ISPUN» (материал GC Gradia Direct)
	('Glass Ionomer Filling'),                           -- «ojačani Fuji IX glasionomer EQUIA»
	('Endodontic Treatment Single Canal Tooth'),         -- «Liječenje kanala korijena (tzv. vađenje živca)»
	('Endodontic Treatment Multi-Canal Tooth'),          -- там же
	('Dental Calculus Removal and Air-Flow'),            -- «kamenac … iznad gingive» + «AIR-FLOW tretman ili PJESKARENJE»
	('Periodontal Scaling Root Planing'),                -- «kao i onaj koji je ispod nivoa gingive»

	-- ── Izbjeljivanje zuba ───────────────────────────────────────
	('Teeth Whitening'),                                 -- «Ordinacijsko bijeljenje … LED lampe» (лазер НЕ используется)
	('Home Teeth Whitening'),                            -- «Kućno bijeljenje … individualnog splinta»
	('Internal Bleaching of Devitalized Tooth'),         -- «Sa unutrašnje strane zuba se formira mali pristupni kavitet»

	-- ── Ortodoncija ──────────────────────────────────────────────
	('Orthodontic Removable Plate Appliance'),           -- «Mobilni aparati … u toku mješovite denticije»
	('Orthodontic Functional Monoblock Appliance'),      -- «terapiju nastavljamo funkcionalnim aparatima»
	('Fixed Braces (Metal) per Jaw'),                    -- «Zlatni standard ortodoncije su još uvijek metalne bravice (breketi)»
	('Fixed Braces (Ceramic or Composite) per Jaw'),     -- «postoje estetske (providne) bravice»
	('Invisalign Aligner'),                              -- «INVISALINE SISTEM»
	('Clear Aligner Therapy'),                           -- «providnih folija (aktivatora), koje su mobilne»

	-- ── Dječiji kutak ────────────────────────────────────────────
	('Pediatric Dentist Consultation'),                  -- «PRVA POSJETA STOMATOLOGU»
	('Pediatric Dental Adaptation'),                     -- там же (адаптация ребёнка)
	('Soft Dental Deposit Removal'),                     -- «UKLANJANJE MEKIH NASLAGA»
	('Dental Fissure Sealant'),                          -- «ZALIVANJE FISURA»
	('Primary Tooth Extraction'),                        -- «VAĐENJE MLIJEČNIH ZUBA»
	('Dental and Soft Tissue Trauma Treatment'),         -- «POVREDE ZUBA I MEKIH TKIVA»
	('Dental First Aid'),                                -- «URGENTNA STANJA KOD DJECE»

	-- ── Digitalno snimanje zuba ──────────────────────────────────
	('Panoramic X-Ray'),                                 -- «najsavremeniji digitalni 2D ortopan aparat Owandy» (3D/CBCT НЕТ)
	('Digital Intraoral X-Ray');                         -- «Retroalvernim (malim, pojedinačnim) snimkom» — RVG Owandy / Myray

-- Страховка от опечаток и коллизий slug: ожидается 0 строк.
-- Если что-то вывелось — название в списке не совпало с medical_services.name_en.
SELECT t.name_en AS unmatched_service_name
FROM tmp_musura_services t
LEFT JOIN medical_services ms ON ms.name_en = t.name_en
WHERE ms.id IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 3: SYNC CLINIC SERVICES (prices NULL)
-- ═══════════════════════════════════════════════════════════════

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, NULL, NULL, NULL, NULL
FROM medical_services ms
JOIN tmp_musura_services t ON t.name_en = ms.name_en;

-- Снятие услуг, которых в каноническом списке нет (в т.ч. 11 позиций,
-- привязанных первой версией файла). Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_musura_services t ON t.name_en = ms.name_en
WHERE cms.clinic_id = @clinic_id AND t.name_en IS NULL;

DROP TEMPORARY TABLE tmp_musura_services;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 44
SELECT COUNT(*) AS services_attached
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Разбивка по категориям
SELECT msc.name AS category, COUNT(DISTINCT ms.id) AS cnt
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN medical_service_categories_relations r ON r.medical_service_id = ms.id
LEFT JOIN medical_service_categories msc ON msc.id = r.medical_service_category_id
WHERE cms.clinic_id = @clinic_id
GROUP BY msc.name
ORDER BY cnt DESC;

-- Три новые услуги должны иметь категории и специальности
SELECT ms.id, ms.name_en, ms.slug,
	GROUP_CONCAT(DISTINCT msc.name ORDER BY msc.name) AS categories,
	GROUP_CONCAT(DISTINCT s.name ORDER BY s.name) AS specialties
FROM medical_services ms
LEFT JOIN medical_service_categories_relations r ON r.medical_service_id = ms.id
LEFT JOIN medical_service_categories msc ON msc.id = r.medical_service_category_id
LEFT JOIN medical_services_specialties mss ON mss.medical_service_id = ms.id
LEFT JOIN specialties s ON s.id = mss.specialty_id
WHERE ms.name_en IN (
	'All on 4 Implant Prosthesis',
	'Implant Overdenture with Locators',
	'Dental and Soft Tissue Trauma Treatment'
)
GROUP BY ms.id;
