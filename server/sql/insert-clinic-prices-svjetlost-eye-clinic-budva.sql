SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- Svjetlost Eye Clinic (Budva), slug svjetlost-eye-clinic-budva — прайс с сайта
-- Источник: https://svjetlostbudva.me/cjenovnik/ (HTML), wp-json pages/1334
--   modified 2026-04-07T11:31:57 — дата актуальности; срез 2026-10-02
--   (data/clinic-pricelists/sources/svjetlost-eye-clinic-budva/2026-10-02.{html,json}).
-- Режим: новый прайс (у клиники 0 услуг и локально, и на проде).
-- В источнике 69 строк: 4 повтора (два раздела дублируют предоперационные осмотры,
-- две пары операций заднего отрезка — одна услуга под двумя названиями с одной ценой),
-- 1 строка LASIK / PRK разложена на две записи каталога.
-- Итого строк clinic_medical_services: 66
--   (существующих записей каталога: 44, новых: 22).
-- «causoma» (kauzoma) — химический ожог глаза кислотой или щёлочью
--   (https://simptomi.rs/bolesti/13-oftalmologija-bolesti-oka/1198-hemijske-povrede-oka).
-- Аргоновая лазеркоагуляция «po oku» → focal-laser-photocoagulation-single-eye (решение юзера:
--   name_sr записи общее, «Laser fotokoagulacija mrežnjače jedno oko»).
-- Рефракционная замена хрусталика (раздел HIRURŠKO UKLANJANJE DIOPTRIJE): отдельные записи
--   RLE рядом с 4296, хотя цены совпадают с катарактальными строками тех же линз (решение юзера).
-- Блефаропластика «po kapku» 600 € → price_min (цена за одно веко, «от»).
-- Цены свежие (2026), is_price_outdated = 0. Номер миграции присвоит юзер.
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'svjetlost-eye-clinic-budva');

-- ───────────────────────────────────────────────────────────────
-- PART 1: новые записи каталога (22)
-- ───────────────────────────────────────────────────────────────

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('pediatric-ophthalmological-examination', 'Pediatric Ophthalmological Examination', 'Dječiji oftalmološki pregled', 'Дјечији офталмолошки преглед', 'Детский офтальмологический осмотр', 'Augenärztliche Untersuchung für Kinder', 'Çocuk Göz Muayenesi'),
('preoperative-cataract-examination', 'Preoperative Cataract Examination', 'Pregled za operaciju katarakte', 'Преглед за операцију катаракте', 'Осмотр перед операцией катаракты', 'Voruntersuchung vor der Kataraktoperation', 'Katarakt Ameliyatı Öncesi Muayene'),
('pentacam-corneal-tomography', 'Pentacam Corneal Tomography', 'Pentakam analiza rožnjače', 'Пентакам анализа рожњаче', 'Томография роговицы Pentacam', 'Pentacam-Hornhauttomographie', 'Pentacam Kornea Tomografisi'),
('chemical-eye-burn-treatment', 'Chemical Eye Burn Treatment', 'Liječenje hemijske povrede oka (kauzoma)', 'Лијечење хемијске повреде ока (каузома)', 'Лечение химического ожога глаза', 'Behandlung einer Augenverätzung', 'Göz Kimyasal Yanık Tedavisi'),
('ophthalmology-second-opinion-consultation', 'Ophthalmology Second Opinion Consultation', 'Drugo mišljenje oftalmologa', 'Друго мишљење офталмолога', 'Второе мнение офтальмолога', 'Augenärztliche Zweitmeinung', 'Göz Hastalıkları İkinci Görüş Konsültasyonu'),
('anterior-chamber-viscoelastic-injection', 'Anterior Chamber Viscoelastic Injection', 'Aplikacija viskoelastika u prednju očnu sobicu', 'Апликација вискоеластика у предњу очну собицу', 'Введение вискоэластика в переднюю камеру глаза', 'Injektion von Viskoelastikum in die Vorderkammer', 'Ön Kamaraya Viskoelastik Enjeksiyonu'),
('cataract-surgery-with-eyhance-iol', 'Cataract Surgery with Eyhance IOL', 'Operacija katarakte sa Eyhance sočivom', 'Операција катаракте са Eyhance сочивом', 'Операция катаракты с ИОЛ Eyhance', 'Kataraktoperation mit Eyhance-Linse', 'Eyhance Göz İçi Lensi ile Katarakt Ameliyatı'),
('cataract-surgery-with-toric-eyhance-iol', 'Cataract Surgery with Toric Eyhance IOL', 'Operacija katarakte sa toričnim Eyhance sočivom', 'Операција катаракте са торичним Eyhance сочивом', 'Операция катаракты с торической ИОЛ Eyhance', 'Kataraktoperation mit torischer Eyhance-Linse', 'Torik Eyhance Göz İçi Lensi ile Katarakt Ameliyatı'),
('cataract-surgery-with-edof-iol', 'Cataract Surgery with EDOF IOL', 'Operacija katarakte sa EDOF sočivom', 'Операција катаракте са EDOF сочивом', 'Операция катаракты с ИОЛ EDOF', 'Kataraktoperation mit EDOF-Linse', 'EDOF Göz İçi Lensi ile Katarakt Ameliyatı'),
('cataract-surgery-with-toric-multifocal-iol', 'Cataract Surgery with Toric Multifocal IOL', 'Operacija katarakte sa toričnim multifokalnim sočivom', 'Операција катаракте са торичним мултифокалним сочивом', 'Операция катаракты с торической мультифокальной ИОЛ', 'Kataraktoperation mit torischer Multifokallinse', 'Torik Multifokal Göz İçi Lensi ile Katarakt Ameliyatı'),
('intraocular-lens-repositioning', 'Intraocular Lens Repositioning', 'Repozicija intraokularnog sočiva', 'Репозиција интраокуларног сочива', 'Репозиция интраокулярной линзы', 'Reposition der Intraokularlinse', 'Göz İçi Lens Repozisyonu'),
('sulcus-fixated-iol-implantation', 'Sulcus-Fixated IOL Implantation', 'Sulkusna fiksacija intraokularnog sočiva', 'Сулкусна фиксација интраокуларног сочива', 'Имплантация ИОЛ с фиксацией в цилиарной борозде', 'Sulkusfixierte IOL-Implantation', 'Sulkus Fiksasyonlu Göz İçi Lens İmplantasyonu'),
('intravitreal-anti-vegf-injection-avastin', 'Intravitreal Anti-VEGF Injection Avastin', 'Anti-VEGF intravitrealna injekcija Avastin', 'Anti-VEGF интравитреална инјекција Avastin', 'Интравитреальная анти-VEGF инъекция Avastin', 'Intravitreale Anti-VEGF-Injektion Avastin', 'İntravitreal Anti-VEGF Enjeksiyonu Avastin'),
('phakic-iol-implantation-icl', 'Phakic IOL Implantation (ICL)', 'Ugradnja fakičnog intraokularnog sočiva (ICL)', 'Уградња факичног интраокуларног сочива (ICL)', 'Имплантация факичной линзы (ICL)', 'Implantation einer phaken Intraokularlinse (ICL)', 'Fakik Göz İçi Lens İmplantasyonu (ICL)'),
('toric-phakic-iol-implantation-icl', 'Toric Phakic IOL Implantation (ICL)', 'Ugradnja toričnog fakičnog intraokularnog sočiva (ICL)', 'Уградња торичног факичног интраокуларног сочива (ICL)', 'Имплантация торической факичной линзы (ICL)', 'Implantation einer torischen phaken Intraokularlinse (ICL)', 'Torik Fakik Göz İçi Lens İmplantasyonu (ICL)'),
('anterior-chamber-phakic-iol-implantation-verisyse', 'Anterior Chamber Phakic IOL Implantation (Verisyse)', 'Ugradnja fakičnog sočiva u prednju očnu sobicu (Verisyse)', 'Уградња факичног сочива у предњу очну собицу (Verisyse)', 'Имплантация факичной линзы в переднюю камеру (Verisyse)', 'Implantation einer phaken Vorderkammerlinse (Verisyse)', 'Ön Kamara Fakik Göz İçi Lens İmplantasyonu (Verisyse)'),
('refractive-lens-exchange-with-eyhance-iol', 'Refractive Lens Exchange with Eyhance IOL', 'Refraktivna zamjena sočiva sa Eyhance implantatom', 'Рефрактивна замјена сочива са Eyhance имплантатом', 'Рефракционная замена хрусталика с ИОЛ Eyhance', 'Refraktiver Linsenaustausch mit Eyhance-Linse', 'Eyhance Göz İçi Lensi ile Refraktif Lens Değişimi'),
('refractive-lens-exchange-with-toric-eyhance-iol', 'Refractive Lens Exchange with Toric Eyhance IOL', 'Refraktivna zamjena sočiva sa toričnim Eyhance implantatom', 'Рефрактивна замјена сочива са торичним Eyhance имплантатом', 'Рефракционная замена хрусталика с торической ИОЛ Eyhance', 'Refraktiver Linsenaustausch mit torischer Eyhance-Linse', 'Torik Eyhance Göz İçi Lensi ile Refraktif Lens Değişimi'),
('refractive-lens-exchange-with-edof-iol', 'Refractive Lens Exchange with EDOF IOL', 'Refraktivna zamjena sočiva sa EDOF implantatom', 'Рефрактивна замјена сочива са EDOF имплантатом', 'Рефракционная замена хрусталика с ИОЛ EDOF', 'Refraktiver Linsenaustausch mit EDOF-Linse', 'EDOF Göz İçi Lensi ile Refraktif Lens Değişimi'),
('keratoconus-examination', 'Keratoconus Examination', 'Pregled za keratokonus', 'Преглед за кератоконус', 'Обследование при кератоконусе', 'Keratokonus-Untersuchung', 'Keratokonus Muayenesi'),
('corneal-cross-linking-cxl', 'Corneal Cross-Linking (CXL)', 'Crosslinking rožnjače (CXL)', 'Crosslinking рожњаче (CXL)', 'Кросслинкинг роговицы (CXL)', 'Hornhautvernetzung (CXL)', 'Kornea Çapraz Bağlama (CXL)'),
('corneal-cross-linking-with-trans-prk', 'Corneal Cross-Linking with Trans-PRK', 'Crosslinking rožnjače sa Trans-PRK', 'Crosslinking рожњаче са Trans-PRK', 'Кросслинкинг роговицы с транс-ФРК', 'Hornhautvernetzung mit Trans-PRK', 'Trans-PRK ile Kornea Çapraz Bağlama')
ON DUPLICATE KEY UPDATE slug = slug;

-- ───────────────────────────────────────────────────────────────
-- PART 2: категории и специальности
-- ───────────────────────────────────────────────────────────────

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT ms.id, v.cat FROM medical_services ms JOIN (
	SELECT 'pediatric-ophthalmological-examination' AS slug, 23 AS cat
	UNION ALL SELECT 'pediatric-ophthalmological-examination' AS slug, 25 AS cat
	UNION ALL SELECT 'preoperative-cataract-examination' AS slug, 23 AS cat
	UNION ALL SELECT 'pentacam-corneal-tomography' AS slug, 23 AS cat
	UNION ALL SELECT 'chemical-eye-burn-treatment' AS slug, 23 AS cat
	UNION ALL SELECT 'ophthalmology-second-opinion-consultation' AS slug, 23 AS cat
	UNION ALL SELECT 'anterior-chamber-viscoelastic-injection' AS slug, 33 AS cat
	UNION ALL SELECT 'cataract-surgery-with-eyhance-iol' AS slug, 33 AS cat
	UNION ALL SELECT 'cataract-surgery-with-toric-eyhance-iol' AS slug, 33 AS cat
	UNION ALL SELECT 'cataract-surgery-with-edof-iol' AS slug, 33 AS cat
	UNION ALL SELECT 'cataract-surgery-with-toric-multifocal-iol' AS slug, 33 AS cat
	UNION ALL SELECT 'intraocular-lens-repositioning' AS slug, 33 AS cat
	UNION ALL SELECT 'sulcus-fixated-iol-implantation' AS slug, 33 AS cat
	UNION ALL SELECT 'intravitreal-anti-vegf-injection-avastin' AS slug, 23 AS cat
	UNION ALL SELECT 'intravitreal-anti-vegf-injection-avastin' AS slug, 29 AS cat
	UNION ALL SELECT 'phakic-iol-implantation-icl' AS slug, 33 AS cat
	UNION ALL SELECT 'toric-phakic-iol-implantation-icl' AS slug, 33 AS cat
	UNION ALL SELECT 'anterior-chamber-phakic-iol-implantation-verisyse' AS slug, 33 AS cat
	UNION ALL SELECT 'refractive-lens-exchange-with-eyhance-iol' AS slug, 33 AS cat
	UNION ALL SELECT 'refractive-lens-exchange-with-toric-eyhance-iol' AS slug, 33 AS cat
	UNION ALL SELECT 'refractive-lens-exchange-with-edof-iol' AS slug, 33 AS cat
	UNION ALL SELECT 'keratoconus-examination' AS slug, 23 AS cat
	UNION ALL SELECT 'corneal-cross-linking-cxl' AS slug, 33 AS cat
	UNION ALL SELECT 'corneal-cross-linking-with-trans-prk' AS slug, 33 AS cat
	UNION ALL SELECT 'preoperative-examination-for-refractive-surgery' AS slug, 23 AS cat
) v ON v.slug = ms.slug;

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT ms.id, v.spec FROM medical_services ms JOIN (
	SELECT 'pediatric-ophthalmological-examination' AS slug, 6 AS spec
	UNION ALL SELECT 'pediatric-ophthalmological-examination' AS slug, 4 AS spec
	UNION ALL SELECT 'preoperative-cataract-examination' AS slug, 6 AS spec
	UNION ALL SELECT 'pentacam-corneal-tomography' AS slug, 6 AS spec
	UNION ALL SELECT 'chemical-eye-burn-treatment' AS slug, 6 AS spec
	UNION ALL SELECT 'ophthalmology-second-opinion-consultation' AS slug, 6 AS spec
	UNION ALL SELECT 'anterior-chamber-viscoelastic-injection' AS slug, 81 AS spec
	UNION ALL SELECT 'cataract-surgery-with-eyhance-iol' AS slug, 81 AS spec
	UNION ALL SELECT 'cataract-surgery-with-toric-eyhance-iol' AS slug, 81 AS spec
	UNION ALL SELECT 'cataract-surgery-with-edof-iol' AS slug, 81 AS spec
	UNION ALL SELECT 'cataract-surgery-with-toric-multifocal-iol' AS slug, 81 AS spec
	UNION ALL SELECT 'intraocular-lens-repositioning' AS slug, 81 AS spec
	UNION ALL SELECT 'sulcus-fixated-iol-implantation' AS slug, 81 AS spec
	UNION ALL SELECT 'intravitreal-anti-vegf-injection-avastin' AS slug, 6 AS spec
	UNION ALL SELECT 'phakic-iol-implantation-icl' AS slug, 81 AS spec
	UNION ALL SELECT 'toric-phakic-iol-implantation-icl' AS slug, 81 AS spec
	UNION ALL SELECT 'anterior-chamber-phakic-iol-implantation-verisyse' AS slug, 81 AS spec
	UNION ALL SELECT 'refractive-lens-exchange-with-eyhance-iol' AS slug, 81 AS spec
	UNION ALL SELECT 'refractive-lens-exchange-with-toric-eyhance-iol' AS slug, 81 AS spec
	UNION ALL SELECT 'refractive-lens-exchange-with-edof-iol' AS slug, 81 AS spec
	UNION ALL SELECT 'keratoconus-examination' AS slug, 6 AS spec
	UNION ALL SELECT 'corneal-cross-linking-cxl' AS slug, 81 AS spec
	UNION ALL SELECT 'corneal-cross-linking-with-trans-prk' AS slug, 81 AS spec
) v ON v.slug = ms.slug;

-- Существующие записи прайса: недостающая привязка по правилу категория → специальность
-- (OPHTHALMOLOGY 23 → 6, OPHTHALMIC_SURGERY 33 → 81, PEDIATRICS 25 → 4, PLASTIC_SURGERY 18 → 18).
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT r.medical_service_id, CASE r.medical_service_category_id WHEN 23 THEN 6 WHEN 33 THEN 81 WHEN 25 THEN 4 WHEN 18 THEN 18 END
FROM medical_service_categories_relations r
JOIN medical_services ms ON ms.id = r.medical_service_id
WHERE r.medical_service_category_id IN (23, 33, 25, 18)
  AND ms.slug IN (
	'comprehensive-ophthalmological-examination',
	'preoperative-examination-for-refractive-surgery',
	'complete-glaucoma-examination',
	'gonioscopy',
	'follow-up-ophthalmologist-examination',
	'autokeratorefractometry',
	'optical-coherence-tomography-oct',
	'visual-field-test',
	'ophthalmic-ultrasound-a-scan-and-b-scan',
	'pachymetry',
	'iol-power-calculation',
	'dry-eye-test-schirmer',
	'exophthalmometry-hertel',
	'lacrimal-duct-irrigation',
	'punctum-plug-implantation',
	'eye-swab-conjunctiva-and-lid-margin',
	'foreign-body-removal-eye',
	'emergency-ophthalmological-examination',
	'xanthelasma-removal-eye-area',
	'blepharoplasty',
	'chalazion-removal-local-anesthesia',
	'pterygium-removal',
	'trabeculectomy',
	'ndyag-laser-iridotomy',
	'cataract-surgery-with-standard-iol',
	'cataract-surgery-with-aspheric-monofocal-iol',
	'cataract-surgery-with-multifocal-iol',
	'anterior-vitrectomy',
	'iridoplasty',
	'artificial-intraocular-lens-removal',
	'secondary-iol-implantation',
	'ndyag-laser-capsulotomy',
	'phaco-vitrectomy',
	'silicone-oil-removal',
	'oct-posterior-segment',
	'focal-laser-photocoagulation-single-eye',
	'intravitreal-anti-vegf-injection-eylea',
	'intravitreal-anti-vegf-injection-lucentis',
	'intravitreal-anti-vegf-injection-vabysmo',
	'vitrectomy',
	'lasik-single-eye',
	'prk-single-eye',
	'refractive-lens-exchange-with-multifocal-iol',
	'contact-lens-fitting'
  );

-- ───────────────────────────────────────────────────────────────
-- PART 3: синонимы
-- ───────────────────────────────────────────────────────────────

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT ms.id, v.name, v.lang FROM medical_services ms JOIN (
	SELECT 'pediatric-ophthalmological-examination' AS slug, 'Pediatric Eye Exam' AS name, 'en' AS lang
	UNION ALL SELECT 'pediatric-ophthalmological-examination' AS slug, 'Pregled oftalmologa za djecu' AS name, 'sr' AS lang
	UNION ALL SELECT 'pediatric-ophthalmological-examination' AS slug, 'Преглед офталмолога за дјецу' AS name, 'sr-cyrl' AS lang
	UNION ALL SELECT 'pediatric-ophthalmological-examination' AS slug, 'Приём детского окулиста' AS name, 'ru' AS lang
	UNION ALL SELECT 'pediatric-ophthalmological-examination' AS slug, 'Kinderaugenarzt Untersuchung' AS name, 'de' AS lang
	UNION ALL SELECT 'pediatric-ophthalmological-examination' AS slug, 'Çocuk göz doktoru muayenesi' AS name, 'tr' AS lang
	UNION ALL SELECT 'preoperative-cataract-examination' AS slug, 'Cataract Surgery Consultation' AS name, 'en' AS lang
	UNION ALL SELECT 'preoperative-cataract-examination' AS slug, 'Pregled za operaciju sive mrene' AS name, 'sr' AS lang
	UNION ALL SELECT 'preoperative-cataract-examination' AS slug, 'Преглед за операцију сиве мрене' AS name, 'sr-cyrl' AS lang
	UNION ALL SELECT 'preoperative-cataract-examination' AS slug, 'Обследование перед заменой хрусталика' AS name, 'ru' AS lang
	UNION ALL SELECT 'pentacam-corneal-tomography' AS slug, 'Pentacam' AS name, 'en' AS lang
	UNION ALL SELECT 'pentacam-corneal-tomography' AS slug, 'Pentacam' AS name, 'sr' AS lang
	UNION ALL SELECT 'pentacam-corneal-tomography' AS slug, 'Пентакам' AS name, 'sr-cyrl' AS lang
	UNION ALL SELECT 'pentacam-corneal-tomography' AS slug, 'Пентакам' AS name, 'ru' AS lang
	UNION ALL SELECT 'pentacam-corneal-tomography' AS slug, 'Scheimpflug Corneal Tomography' AS name, 'en' AS lang
	UNION ALL SELECT 'chemical-eye-burn-treatment' AS slug, 'Chemical Eye Injury Treatment' AS name, 'en' AS lang
	UNION ALL SELECT 'chemical-eye-burn-treatment' AS slug, 'Kauzoma' AS name, 'sr' AS lang
	UNION ALL SELECT 'chemical-eye-burn-treatment' AS slug, 'Каузома' AS name, 'sr-cyrl' AS lang
	UNION ALL SELECT 'chemical-eye-burn-treatment' AS slug, 'Causoma' AS name, 'sr' AS lang
	UNION ALL SELECT 'chemical-eye-burn-treatment' AS slug, 'Hemijska opekotina oka' AS name, 'sr' AS lang
	UNION ALL SELECT 'chemical-eye-burn-treatment' AS slug, 'Хемијска опекотина ока' AS name, 'sr-cyrl' AS lang
	UNION ALL SELECT 'chemical-eye-burn-treatment' AS slug, 'Химический ожог глаза' AS name, 'ru' AS lang
	UNION ALL SELECT 'chemical-eye-burn-treatment' AS slug, 'Ожог глаза щёлочью или кислотой' AS name, 'ru' AS lang
	UNION ALL SELECT 'chemical-eye-burn-treatment' AS slug, 'Verätzung des Auges' AS name, 'de' AS lang
	UNION ALL SELECT 'chemical-eye-burn-treatment' AS slug, 'Gözde kimyasal yanık' AS name, 'tr' AS lang
	UNION ALL SELECT 'ophthalmology-second-opinion-consultation' AS slug, 'Ophthalmologist Second Opinion' AS name, 'en' AS lang
	UNION ALL SELECT 'ophthalmology-second-opinion-consultation' AS slug, 'Второе мнение окулиста' AS name, 'ru' AS lang
	UNION ALL SELECT 'cataract-surgery-with-eyhance-iol' AS slug, 'Cataract Surgery with Monofocal Plus IOL' AS name, 'en' AS lang
	UNION ALL SELECT 'cataract-surgery-with-eyhance-iol' AS slug, 'Operacija katarakte sa monofokalnim plus sočivom' AS name, 'sr' AS lang
	UNION ALL SELECT 'cataract-surgery-with-eyhance-iol' AS slug, 'Операција катаракте са монофокалним плус сочивом' AS name, 'sr-cyrl' AS lang
	UNION ALL SELECT 'cataract-surgery-with-eyhance-iol' AS slug, 'Операция катаракты с монофокальной плюс ИОЛ' AS name, 'ru' AS lang
	UNION ALL SELECT 'cataract-surgery-with-edof-iol' AS slug, 'Extended Depth of Focus IOL' AS name, 'en' AS lang
	UNION ALL SELECT 'cataract-surgery-with-edof-iol' AS slug, 'ИОЛ с увеличенной глубиной фокуса' AS name, 'ru' AS lang
	UNION ALL SELECT 'intraocular-lens-repositioning' AS slug, 'IOL Repositioning' AS name, 'en' AS lang
	UNION ALL SELECT 'intraocular-lens-repositioning' AS slug, 'Репозиция ИОЛ' AS name, 'ru' AS lang
	UNION ALL SELECT 'sulcus-fixated-iol-implantation' AS slug, 'Sulcus fiksacija intraokularnog sočiva' AS name, 'sr' AS lang
	UNION ALL SELECT 'sulcus-fixated-iol-implantation' AS slug, 'Sulcus IOL Fixation' AS name, 'en' AS lang
	UNION ALL SELECT 'sulcus-fixated-iol-implantation' AS slug, 'Шовная фиксация ИОЛ в борозде' AS name, 'ru' AS lang
	UNION ALL SELECT 'intravitreal-anti-vegf-injection-avastin' AS slug, 'Bevacizumab Injection' AS name, 'en' AS lang
	UNION ALL SELECT 'intravitreal-anti-vegf-injection-avastin' AS slug, 'Bevacizumab' AS name, 'sr' AS lang
	UNION ALL SELECT 'intravitreal-anti-vegf-injection-avastin' AS slug, 'Бевацизумаб' AS name, 'sr-cyrl' AS lang
	UNION ALL SELECT 'intravitreal-anti-vegf-injection-avastin' AS slug, 'Авастин' AS name, 'ru' AS lang
	UNION ALL SELECT 'intravitreal-anti-vegf-injection-avastin' AS slug, 'Бевацизумаб' AS name, 'ru' AS lang
	UNION ALL SELECT 'phakic-iol-implantation-icl' AS slug, 'Implantable Collamer Lens' AS name, 'en' AS lang
	UNION ALL SELECT 'phakic-iol-implantation-icl' AS slug, 'ICL sočivo' AS name, 'sr' AS lang
	UNION ALL SELECT 'phakic-iol-implantation-icl' AS slug, 'ICL сочиво' AS name, 'sr-cyrl' AS lang
	UNION ALL SELECT 'phakic-iol-implantation-icl' AS slug, 'Факичная ИОЛ' AS name, 'ru' AS lang
	UNION ALL SELECT 'phakic-iol-implantation-icl' AS slug, 'Phake Linse' AS name, 'de' AS lang
	UNION ALL SELECT 'toric-phakic-iol-implantation-icl' AS slug, 'Toric ICL' AS name, 'en' AS lang
	UNION ALL SELECT 'toric-phakic-iol-implantation-icl' AS slug, 'Torično ICL sočivo' AS name, 'sr' AS lang
	UNION ALL SELECT 'toric-phakic-iol-implantation-icl' AS slug, 'Торично ICL сочиво' AS name, 'sr-cyrl' AS lang
	UNION ALL SELECT 'anterior-chamber-phakic-iol-implantation-verisyse' AS slug, 'Iris-Claw Phakic Lens' AS name, 'en' AS lang
	UNION ALL SELECT 'anterior-chamber-phakic-iol-implantation-verisyse' AS slug, 'Verisyse' AS name, 'en' AS lang
	UNION ALL SELECT 'refractive-lens-exchange-with-eyhance-iol' AS slug, 'Refractive Lens Exchange with Monofocal Plus IOL' AS name, 'en' AS lang
	UNION ALL SELECT 'refractive-lens-exchange-with-eyhance-iol' AS slug, 'Refraktivna zamjena sočiva sa monofokalnim plus implantatom' AS name, 'sr' AS lang
	UNION ALL SELECT 'refractive-lens-exchange-with-eyhance-iol' AS slug, 'Рефрактивна замјена сочива са монофокалним плус имплантатом' AS name, 'sr-cyrl' AS lang
	UNION ALL SELECT 'refractive-lens-exchange-with-eyhance-iol' AS slug, 'Замена хрусталика с монофокальной плюс ИОЛ' AS name, 'ru' AS lang
	UNION ALL SELECT 'refractive-lens-exchange-with-edof-iol' AS slug, 'Refractive Lens Exchange with Extended Depth of Focus IOL' AS name, 'en' AS lang
	UNION ALL SELECT 'keratoconus-examination' AS slug, 'Диагностика кератоконуса' AS name, 'ru' AS lang
	UNION ALL SELECT 'corneal-cross-linking-cxl' AS slug, 'CXL' AS name, 'en' AS lang
	UNION ALL SELECT 'corneal-cross-linking-cxl' AS slug, 'Corneal Crosslinking' AS name, 'en' AS lang
	UNION ALL SELECT 'corneal-cross-linking-cxl' AS slug, 'CXL' AS name, 'sr' AS lang
	UNION ALL SELECT 'corneal-cross-linking-cxl' AS slug, 'Kroslinking rožnjače' AS name, 'sr' AS lang
	UNION ALL SELECT 'corneal-cross-linking-cxl' AS slug, 'Крослинкинг рожњаче' AS name, 'sr-cyrl' AS lang
	UNION ALL SELECT 'corneal-cross-linking-cxl' AS slug, 'Кросслинкинг' AS name, 'ru' AS lang
	UNION ALL SELECT 'corneal-cross-linking-cxl' AS slug, 'Корнеальный кросслинкинг' AS name, 'ru' AS lang
	UNION ALL SELECT 'corneal-cross-linking-cxl' AS slug, 'Crosslinking' AS name, 'de' AS lang
	UNION ALL SELECT 'corneal-cross-linking-cxl' AS slug, 'Korneal crosslinking' AS name, 'tr' AS lang
	UNION ALL SELECT 'corneal-cross-linking-with-trans-prk' AS slug, 'CXL + Trans PRK' AS name, 'en' AS lang
	UNION ALL SELECT 'corneal-cross-linking-with-trans-prk' AS slug, 'CXL + Trans PRK' AS name, 'sr' AS lang
	UNION ALL SELECT 'corneal-cross-linking-with-trans-prk' AS slug, 'Кросслинкинг + транс-ФРК' AS name, 'ru' AS lang
	UNION ALL SELECT 'lacrimal-duct-irrigation' AS slug, 'Propiranje suznih kanala' AS name, 'sr' AS lang
	UNION ALL SELECT 'lacrimal-duct-irrigation' AS slug, 'Пропирање сузних канала' AS name, 'sr-cyrl' AS lang
	UNION ALL SELECT 'xanthelasma-removal-eye-area' AS slug, 'Uklanjanje masnih naslaga na koži kapaka' AS name, 'sr' AS lang
	UNION ALL SELECT 'xanthelasma-removal-eye-area' AS slug, 'Уклањање масних наслага на кожи капака' AS name, 'sr-cyrl' AS lang
	UNION ALL SELECT 'iridoplasty' AS slug, 'Pupiloplastika' AS name, 'sr' AS lang
	UNION ALL SELECT 'iridoplasty' AS slug, 'Пупилопластика' AS name, 'sr-cyrl' AS lang
	UNION ALL SELECT 'iridoplasty' AS slug, 'Rekonstrukcija zjenice' AS name, 'sr' AS lang
	UNION ALL SELECT 'iridoplasty' AS slug, 'Реконструкција зјенице' AS name, 'sr-cyrl' AS lang
	UNION ALL SELECT 'iridoplasty' AS slug, 'Pupilloplasty' AS name, 'en' AS lang
	UNION ALL SELECT 'iridoplasty' AS slug, 'Пупиллопластика' AS name, 'ru' AS lang
	UNION ALL SELECT 'silicone-oil-removal' AS slug, 'Vađenje silikonskog ulja' AS name, 'sr' AS lang
	UNION ALL SELECT 'silicone-oil-removal' AS slug, 'Вађење силиконског уља' AS name, 'sr-cyrl' AS lang
	UNION ALL SELECT 'contact-lens-fitting' AS slug, 'Fitovanje GP sočiva' AS name, 'sr' AS lang
	UNION ALL SELECT 'contact-lens-fitting' AS slug, 'Фитовање GP сочива' AS name, 'sr-cyrl' AS lang
	UNION ALL SELECT 'contact-lens-fitting' AS slug, 'RGP Contact Lens Fitting' AS name, 'en' AS lang
	UNION ALL SELECT 'contact-lens-fitting' AS slug, 'Подбор жёстких газопроницаемых линз' AS name, 'ru' AS lang
) v ON v.slug = ms.slug;

-- ───────────────────────────────────────────────────────────────
-- PART 4: цены клиники (66)
-- ───────────────────────────────────────────────────────────────

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, v.price, v.price_min, v.price_max, NULL FROM medical_services ms JOIN (
	SELECT 'comprehensive-ophthalmological-examination' AS slug, 80.00 AS price, NULL AS price_min, NULL AS price_max -- Opšti oftalmološki pregled
	UNION ALL SELECT 'pediatric-ophthalmological-examination' AS slug, 100.00 AS price, NULL AS price_min, NULL AS price_max -- Dječiji oftalmološki pregled
	UNION ALL SELECT 'preoperative-examination-for-refractive-surgery' AS slug, 150.00 AS price, NULL AS price_min, NULL AS price_max -- Pregled za lasersko skidanje dioptrije
	UNION ALL SELECT 'preoperative-cataract-examination' AS slug, 150.00 AS price, NULL AS price_min, NULL AS price_max -- Pregled za operaciju katarakte
	UNION ALL SELECT 'complete-glaucoma-examination' AS slug, 150.00 AS price, NULL AS price_min, NULL AS price_max -- Pregled za glaukom (pregled+CVP+OCT+gonioskopija)
	UNION ALL SELECT 'gonioscopy' AS slug, 30.00 AS price, NULL AS price_min, NULL AS price_max -- Gonioskopija
	UNION ALL SELECT 'follow-up-ophthalmologist-examination' AS slug, 50.00 AS price, NULL AS price_min, NULL AS price_max -- Kontrolni pregled
	UNION ALL SELECT 'autokeratorefractometry' AS slug, 20.00 AS price, NULL AS price_min, NULL AS price_max -- Auto keratorefraktometrija
	UNION ALL SELECT 'optical-coherence-tomography-oct' AS slug, 60.00 AS price, NULL AS price_min, NULL AS price_max -- OCT (optička koherentna tomografija)
	UNION ALL SELECT 'pentacam-corneal-tomography' AS slug, 60.00 AS price, NULL AS price_min, NULL AS price_max -- Pentakam analiza rožnjače
	UNION ALL SELECT 'visual-field-test' AS slug, 60.00 AS price, NULL AS price_min, NULL AS price_max -- KVP (kompjuterizovano vidno polje)
	UNION ALL SELECT 'ophthalmic-ultrasound-a-scan-and-b-scan' AS slug, 50.00 AS price, NULL AS price_min, NULL AS price_max -- UZ oka, orbita i biometrija
	UNION ALL SELECT 'pachymetry' AS slug, 30.00 AS price, NULL AS price_min, NULL AS price_max -- Pahimetrija
	UNION ALL SELECT 'iol-power-calculation' AS slug, 40.00 AS price, NULL AS price_min, NULL AS price_max -- IOL master izračun dioptrijske vrijednosti sočiva
	UNION ALL SELECT 'dry-eye-test-schirmer' AS slug, 20.00 AS price, NULL AS price_min, NULL AS price_max -- Schirmer test (mjerenje lučenja suza)
	UNION ALL SELECT 'exophthalmometry-hertel' AS slug, 20.00 AS price, NULL AS price_min, NULL AS price_max -- Egzoftalmometrija (HERTEL)
	UNION ALL SELECT 'lacrimal-duct-irrigation' AS slug, 70.00 AS price, NULL AS price_min, NULL AS price_max -- Propiranje suznih kanala
	UNION ALL SELECT 'punctum-plug-implantation' AS slug, 100.00 AS price, NULL AS price_min, NULL AS price_max -- Implantatio plugs po oku
	UNION ALL SELECT 'eye-swab-conjunctiva-and-lid-margin' AS slug, 30.00 AS price, NULL AS price_min, NULL AS price_max -- Bris oka
	UNION ALL SELECT 'chemical-eye-burn-treatment' AS slug, 120.00 AS price, NULL AS price_min, NULL AS price_max -- Primjena lokalne terapije (causoma)
	UNION ALL SELECT 'foreign-body-removal-eye' AS slug, 100.00 AS price, NULL AS price_min, NULL AS price_max -- Uklanjanje stranog tijela
	UNION ALL SELECT 'emergency-ophthalmological-examination' AS slug, 100.00 AS price, NULL AS price_min, NULL AS price_max -- Hitan pregled tokom dana
	UNION ALL SELECT 'ophthalmology-second-opinion-consultation' AS slug, 200.00 AS price, NULL AS price_min, NULL AS price_max -- Drugo mišljenje oftalmologa
	UNION ALL SELECT 'xanthelasma-removal-eye-area' AS slug, 400.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija uklanjanja masnih naslaga na koži kapaka
	UNION ALL SELECT 'blepharoplasty' AS slug, NULL AS price, 600.00 AS price_min, NULL AS price_max -- Operativna korekcija kapaka – blefaroplastika po kapku
	UNION ALL SELECT 'chalazion-removal-local-anesthesia' AS slug, 150.00 AS price, NULL AS price_min, NULL AS price_max -- Chalazion intervencija i hordeolum
	UNION ALL SELECT 'pterygium-removal' AS slug, 300.00 AS price, NULL AS price_min, 500.00 AS price_max -- Duplikatura vežnjače – Pterygium
	UNION ALL SELECT 'trabeculectomy' AS slug, 1600.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija glaukoma – trabekulektomija
	UNION ALL SELECT 'anterior-chamber-viscoelastic-injection' AS slug, 300.00 AS price, NULL AS price_min, NULL AS price_max -- Aplikacija viskoelastika u prednju sobicu
	UNION ALL SELECT 'ndyag-laser-iridotomy' AS slug, 150.00 AS price, NULL AS price_min, NULL AS price_max -- Yag laser iridotomija
	UNION ALL SELECT 'cataract-surgery-with-standard-iol' AS slug, 1400.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija katarakte ultrazvukom (PHACO) – sa ugradnjom monofokalno akrilatno intraokularnog sočiva
	UNION ALL SELECT 'cataract-surgery-with-aspheric-monofocal-iol' AS slug, 1500.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija katarakte ultrazvukom (PHACO) – sa ugradnjom monofokalno asferično intraokularnog sočiva
	UNION ALL SELECT 'cataract-surgery-with-eyhance-iol' AS slug, 1600.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija katarakte ultrazvukom (PHACO) – sa ugradnjom monofokalno plus intraokularnog sočiva (Eyhance)
	UNION ALL SELECT 'cataract-surgery-with-toric-eyhance-iol' AS slug, 1800.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija katarakte ultrazvukom (PHACO) – sa ugradnjom monofokalno plus torično intraokularnog sočiva (Eyhance)
	UNION ALL SELECT 'cataract-surgery-with-edof-iol' AS slug, 2200.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija katarakte ultrazvukom (PHACO) – sa ugradnjom monofokalno intraokularnog EDOF sočiva
	UNION ALL SELECT 'cataract-surgery-with-multifocal-iol' AS slug, 2400.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija katarakte ultrazvukom (PHACO) – sa ugradnjom multifokalno intraokularnog sočiva (Low-add, Symfony, Synergy)
	UNION ALL SELECT 'cataract-surgery-with-toric-multifocal-iol' AS slug, 2400.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija katarakte ultrazvukom (PHACO) – sa ugradnjom multifokalno torično intraokularnog sočiva
	UNION ALL SELECT 'anterior-vitrectomy' AS slug, 500.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija prednja vitrektomija
	UNION ALL SELECT 'intraocular-lens-repositioning' AS slug, 800.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija repozicije intraokularnog sočiva
	UNION ALL SELECT 'iridoplasty' AS slug, 1400.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija rekonstrukcije zenice (pupiloplastika)
	UNION ALL SELECT 'artificial-intraocular-lens-removal' AS slug, 800.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija vađenja (eksplantacija) sočiva
	UNION ALL SELECT 'secondary-iol-implantation' AS slug, 800.00 AS price, NULL AS price_min, NULL AS price_max -- Sekundarna implantacija sočiva u stražnju očnu sobicu
	UNION ALL SELECT 'sulcus-fixated-iol-implantation' AS slug, 1300.00 AS price, NULL AS price_min, NULL AS price_max -- Sulcus fiksacija intraokularnog sočiva
	UNION ALL SELECT 'ndyag-laser-capsulotomy' AS slug, 150.00 AS price, NULL AS price_min, NULL AS price_max -- Yag laser capsulotomia, uklanjanje sek. katarakte Yag laserom (po oku)
	UNION ALL SELECT 'phaco-vitrectomy' AS slug, 3500.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija zadnje vitrektomije sa operacijom katarakte | Operacija vitrektomija sa tamponadom silikonskim uljem ili gasom sa operacijom katarakte i ugradnjom IOL
	UNION ALL SELECT 'silicone-oil-removal' AS slug, 1500.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija vitrektomije i vađenje ulja | Operacija vađenja silikonskog ulja
	UNION ALL SELECT 'oct-posterior-segment' AS slug, 50.00 AS price, NULL AS price_min, NULL AS price_max -- OCT – Optička koherentna tomografija retine i vidnog živca
	UNION ALL SELECT 'focal-laser-photocoagulation-single-eye' AS slug, 150.00 AS price, NULL AS price_min, NULL AS price_max -- Laserska fotokoagulacija retine argonskim laserom (po oku)
	UNION ALL SELECT 'intravitreal-anti-vegf-injection-avastin' AS slug, 200.00 AS price, NULL AS price_min, NULL AS price_max -- Liječenje degeneracije makule i vaskularnih oboljenja retine i makule (injekcija Avastin)
	UNION ALL SELECT 'intravitreal-anti-vegf-injection-eylea' AS slug, 850.00 AS price, NULL AS price_min, NULL AS price_max -- Liječenje degeneracije makule i vaskularnih oboljenja retine i makule (injekcija Eylea)
	UNION ALL SELECT 'intravitreal-anti-vegf-injection-lucentis' AS slug, 850.00 AS price, NULL AS price_min, NULL AS price_max -- Liječenje degeneracije makule i vaskularnih oboljenja retine i makule (injekcija Lucentis)
	UNION ALL SELECT 'intravitreal-anti-vegf-injection-vabysmo' AS slug, 1100.00 AS price, NULL AS price_min, NULL AS price_max -- Liječenje degeneracije makule i vaskularnih oboljenja retine i makule (injekcija Vabysmo)
	UNION ALL SELECT 'vitrectomy' AS slug, 3000.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija vitrektomija sa tamponadom silikonskim uljem ili gasom
	UNION ALL SELECT 'lasik-single-eye' AS slug, 850.00 AS price, NULL AS price_min, NULL AS price_max -- Lasersko skidanje dioptrije LASIK / PRK (po oku)
	UNION ALL SELECT 'prk-single-eye' AS slug, 850.00 AS price, NULL AS price_min, NULL AS price_max -- Lasersko skidanje dioptrije LASIK / PRK (po oku)
	UNION ALL SELECT 'phakic-iol-implantation-icl' AS slug, 2000.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija ugradnje fakično intraokularnog sočiva za zadnju očnu sobicu (ICL)
	UNION ALL SELECT 'toric-phakic-iol-implantation-icl' AS slug, 2200.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija ugradnje fakično intraokularno toričnog sočiva za zadnju očnu sobicu (ICL)
	UNION ALL SELECT 'anterior-chamber-phakic-iol-implantation-verisyse' AS slug, 1600.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija ugradnje fakično intraokularnog sočiva za prednju očnu sobicu (Verisyse)
	UNION ALL SELECT 'refractive-lens-exchange-with-eyhance-iol' AS slug, 1600.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija ugradnje monofokalnog plus intraokularnog sočiva (Eyhance)
	UNION ALL SELECT 'refractive-lens-exchange-with-toric-eyhance-iol' AS slug, 1800.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija ugradnje monofokalnog plus toričnog intraokularnog sočiva (Eyhance)
	UNION ALL SELECT 'refractive-lens-exchange-with-edof-iol' AS slug, 2200.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija ugradnje monofokalnog intraokularnog EDOF sočiva
	UNION ALL SELECT 'refractive-lens-exchange-with-multifocal-iol' AS slug, 2400.00 AS price, NULL AS price_min, NULL AS price_max -- Operacija ugradnje multifokalnog intraokularnog sočiva
	UNION ALL SELECT 'keratoconus-examination' AS slug, 150.00 AS price, NULL AS price_min, NULL AS price_max -- Pregled za keratoconus
	UNION ALL SELECT 'corneal-cross-linking-cxl' AS slug, 850.00 AS price, NULL AS price_min, NULL AS price_max -- CXL
	UNION ALL SELECT 'corneal-cross-linking-with-trans-prk' AS slug, 1000.00 AS price, NULL AS price_min, NULL AS price_max -- CXL + Trans PRK
	UNION ALL SELECT 'contact-lens-fitting' AS slug, 130.00 AS price, NULL AS price_min, NULL AS price_max -- Fitovanje GP sočiva
) v ON v.slug = ms.slug
WHERE @clinic_id IS NOT NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- 1. id клиники (NULL = slug не найден, цены не вставлены)
SELECT @clinic_id AS clinic_id;

-- 2. Должно быть 66 строк, все с ценой
SELECT COUNT(*) AS rows_total,
       SUM(price IS NOT NULL OR price_min IS NOT NULL) AS rows_priced
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- 3. Новые записи каталога: должно быть 22, у каждой категория и специальность
SELECT ms.id, ms.slug, ms.name_sr_cyrl,
       (SELECT GROUP_CONCAT(medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
       (SELECT GROUP_CONCAT(specialty_id) FROM medical_services_specialties s WHERE s.medical_service_id = ms.id) AS specs
FROM medical_services ms WHERE ms.slug IN (
	'pediatric-ophthalmological-examination',
	'preoperative-cataract-examination',
	'pentacam-corneal-tomography',
	'chemical-eye-burn-treatment',
	'ophthalmology-second-opinion-consultation',
	'anterior-chamber-viscoelastic-injection',
	'cataract-surgery-with-eyhance-iol',
	'cataract-surgery-with-toric-eyhance-iol',
	'cataract-surgery-with-edof-iol',
	'cataract-surgery-with-toric-multifocal-iol',
	'intraocular-lens-repositioning',
	'sulcus-fixated-iol-implantation',
	'intravitreal-anti-vegf-injection-avastin',
	'phakic-iol-implantation-icl',
	'toric-phakic-iol-implantation-icl',
	'anterior-chamber-phakic-iol-implantation-verisyse',
	'refractive-lens-exchange-with-eyhance-iol',
	'refractive-lens-exchange-with-toric-eyhance-iol',
	'refractive-lens-exchange-with-edof-iol',
	'keratoconus-examination',
	'corneal-cross-linking-cxl',
	'corneal-cross-linking-with-trans-prk'
);

-- 4. Слаги прайса, которых нет в каталоге (должно быть пусто)
SELECT v.slug FROM (
	SELECT 'comprehensive-ophthalmological-examination' AS slug
	UNION ALL SELECT 'pediatric-ophthalmological-examination' AS slug
	UNION ALL SELECT 'preoperative-examination-for-refractive-surgery' AS slug
	UNION ALL SELECT 'preoperative-cataract-examination' AS slug
	UNION ALL SELECT 'complete-glaucoma-examination' AS slug
	UNION ALL SELECT 'gonioscopy' AS slug
	UNION ALL SELECT 'follow-up-ophthalmologist-examination' AS slug
	UNION ALL SELECT 'autokeratorefractometry' AS slug
	UNION ALL SELECT 'optical-coherence-tomography-oct' AS slug
	UNION ALL SELECT 'pentacam-corneal-tomography' AS slug
	UNION ALL SELECT 'visual-field-test' AS slug
	UNION ALL SELECT 'ophthalmic-ultrasound-a-scan-and-b-scan' AS slug
	UNION ALL SELECT 'pachymetry' AS slug
	UNION ALL SELECT 'iol-power-calculation' AS slug
	UNION ALL SELECT 'dry-eye-test-schirmer' AS slug
	UNION ALL SELECT 'exophthalmometry-hertel' AS slug
	UNION ALL SELECT 'lacrimal-duct-irrigation' AS slug
	UNION ALL SELECT 'punctum-plug-implantation' AS slug
	UNION ALL SELECT 'eye-swab-conjunctiva-and-lid-margin' AS slug
	UNION ALL SELECT 'chemical-eye-burn-treatment' AS slug
	UNION ALL SELECT 'foreign-body-removal-eye' AS slug
	UNION ALL SELECT 'emergency-ophthalmological-examination' AS slug
	UNION ALL SELECT 'ophthalmology-second-opinion-consultation' AS slug
	UNION ALL SELECT 'xanthelasma-removal-eye-area' AS slug
	UNION ALL SELECT 'blepharoplasty' AS slug
	UNION ALL SELECT 'chalazion-removal-local-anesthesia' AS slug
	UNION ALL SELECT 'pterygium-removal' AS slug
	UNION ALL SELECT 'trabeculectomy' AS slug
	UNION ALL SELECT 'anterior-chamber-viscoelastic-injection' AS slug
	UNION ALL SELECT 'ndyag-laser-iridotomy' AS slug
	UNION ALL SELECT 'cataract-surgery-with-standard-iol' AS slug
	UNION ALL SELECT 'cataract-surgery-with-aspheric-monofocal-iol' AS slug
	UNION ALL SELECT 'cataract-surgery-with-eyhance-iol' AS slug
	UNION ALL SELECT 'cataract-surgery-with-toric-eyhance-iol' AS slug
	UNION ALL SELECT 'cataract-surgery-with-edof-iol' AS slug
	UNION ALL SELECT 'cataract-surgery-with-multifocal-iol' AS slug
	UNION ALL SELECT 'cataract-surgery-with-toric-multifocal-iol' AS slug
	UNION ALL SELECT 'anterior-vitrectomy' AS slug
	UNION ALL SELECT 'intraocular-lens-repositioning' AS slug
	UNION ALL SELECT 'iridoplasty' AS slug
	UNION ALL SELECT 'artificial-intraocular-lens-removal' AS slug
	UNION ALL SELECT 'secondary-iol-implantation' AS slug
	UNION ALL SELECT 'sulcus-fixated-iol-implantation' AS slug
	UNION ALL SELECT 'ndyag-laser-capsulotomy' AS slug
	UNION ALL SELECT 'phaco-vitrectomy' AS slug
	UNION ALL SELECT 'silicone-oil-removal' AS slug
	UNION ALL SELECT 'oct-posterior-segment' AS slug
	UNION ALL SELECT 'focal-laser-photocoagulation-single-eye' AS slug
	UNION ALL SELECT 'intravitreal-anti-vegf-injection-avastin' AS slug
	UNION ALL SELECT 'intravitreal-anti-vegf-injection-eylea' AS slug
	UNION ALL SELECT 'intravitreal-anti-vegf-injection-lucentis' AS slug
	UNION ALL SELECT 'intravitreal-anti-vegf-injection-vabysmo' AS slug
	UNION ALL SELECT 'vitrectomy' AS slug
	UNION ALL SELECT 'lasik-single-eye' AS slug
	UNION ALL SELECT 'prk-single-eye' AS slug
	UNION ALL SELECT 'phakic-iol-implantation-icl' AS slug
	UNION ALL SELECT 'toric-phakic-iol-implantation-icl' AS slug
	UNION ALL SELECT 'anterior-chamber-phakic-iol-implantation-verisyse' AS slug
	UNION ALL SELECT 'refractive-lens-exchange-with-eyhance-iol' AS slug
	UNION ALL SELECT 'refractive-lens-exchange-with-toric-eyhance-iol' AS slug
	UNION ALL SELECT 'refractive-lens-exchange-with-edof-iol' AS slug
	UNION ALL SELECT 'refractive-lens-exchange-with-multifocal-iol' AS slug
	UNION ALL SELECT 'keratoconus-examination' AS slug
	UNION ALL SELECT 'corneal-cross-linking-cxl' AS slug
	UNION ALL SELECT 'corneal-cross-linking-with-trans-prk' AS slug
	UNION ALL SELECT 'contact-lens-fitting' AS slug
) v LEFT JOIN medical_services ms ON ms.slug = v.slug WHERE ms.id IS NULL;

-- 5. Прайс клиники
SELECT ms.slug, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id ORDER BY ms.slug;
