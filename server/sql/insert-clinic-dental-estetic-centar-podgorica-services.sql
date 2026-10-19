-- ═══════════════════════════════════════════════════════════════════════════
-- PZU Dental & Estetic Centar (Podgorica, Zabjelo) — перечень услуг
-- Run ПОСЛЕ server/sql/insert-clinic-dental-estetic-centar-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dental-estetic-centar-podgorica-services.sql
--
-- Источник: https://www.dentalesteticcentar.com/ — /usluge/stomatoloske-usluge.html и подстраницы, /usluge/estetika-lica.html и подстраницы,
-- SEO-страницы и блог, curl 2026-10-09. Прайса нет (cjenovnik.html, cijene.html — 404). Цена есть у 1 позиции: первичный осмотр 0 €
-- («Prvi pregled je besplatan») — по образцу dental-montenegro-budva / splendid-dental-budva (0.00 при «besplatni»); остальные NULL.
--
-- Итого: 40 услуг (1 с ценой), новых записей каталога — 2 (immediate-implant-loading, full-mouth-reconstruction), повторено из других импортов агента X — gummy-smile-correction, smile-makeover. Анализов нет.
-- Привязок врач↔услуга: 0.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJ2UUYSb3rTRMRCFwiFhxaskc' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'dental-estetic-centar-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-dental-estetic-centar-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА И СИНОНИМЫ (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- (запись заведена в insert-clinic-stefanija-dental-podgorica-services.sql; повторена идемпотентно — файл не зависит от порядка применения)
-- stefanijadental.me /parodontologija/: «… menadžmentom mekog tkiva i korekcijom gummy smile-a». Метод не назван.
-- В каталоге нет (поиск gummy / gingival smile / «десневая улыбка»). Общая запись. Категория 20, специальность 78.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'gummy-smile-correction', 'Gummy Smile Correction', 'Korekcija gingivalnog osmijeha (gummy smile)', 'Корекција гингивалног осмијеха (gummy smile)',
	'Коррекция «десневой улыбки»', 'Korrektur des Gummy Smile', 'Diş eti gülüşü düzeltme', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'gummy-smile-correction' OR name_en = 'Gummy Smile Correction');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Gummy smile', 'en' FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Gingival smile correction', 'en' FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Gummy smile korekcija', 'sr' FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Korekcija desni pri osmijehu', 'sr' FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Корекција десни при осмијеху', 'sr-cyrl' FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Десневая улыбка', 'ru' FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Коррекция десневой улыбки', 'ru' FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Zahnfleischlächeln', 'de' FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Gummy smile tedavisi', 'tr' FROM medical_services WHERE slug = 'gummy-smile-correction';

-- (запись заведена в insert-clinic-omnidental-bar-services.sql; повторена идемпотентно — файл не зависит от порядка применения)
-- omnidental.me «Estetska Stomatologija»: «… porcelanske fasete (viniri) - smile makeover - Invisalign».
-- В каталоге нет: digital-smile-design — план, hollywood-smile-zirconia-crown — конкретные коронки. Общая запись. Категория 20, специальность 78.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'smile-makeover', 'Smile Makeover', 'Smile makeover (kompletno uređenje osmijeha)', 'Smile makeover (комплетно уређење осмијеха)',
	'Smile makeover (комплексное преображение улыбки)', 'Smile Makeover (Komplettgestaltung des Lächelns)', 'Smile makeover (gülüş tasarımı ve yenileme)', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'smile-makeover' OR name_en = 'Smile Makeover');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Smile makeover', 'sr' FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Uređenje osmijeha', 'sr' FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Kompletna estetska rekonstrukcija osmijeha', 'sr' FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Уређење осмијеха', 'sr-cyrl' FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Full smile makeover', 'en' FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Преображение улыбки', 'ru' FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Эстетическая реставрация улыбки', 'ru' FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Lächeln-Makeover', 'de' FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Gülüş yenileme', 'tr' FROM medical_services WHERE slug = 'smile-makeover';

-- dentalesteticcentar.com /usluge/zubi-za-24h.html: «nakon ekstrakcija ili ugradnje implantata isti dan … postavlja privremeni fiksni osmijeh».
-- В каталоге нет: immediate-implant-placement — установка без нагрузки, All-on-X сайт не называет. Категория 20; специальности 74, 78.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'immediate-implant-loading', 'Immediate Implant Loading (Teeth in 24 Hours)', 'Imedijatno opterećenje implantata (zubi za 24h)', 'Имедијатно оптерећење имплантата (зуби за 24h)',
	'Немедленная нагрузка имплантов (зубы за 24 часа)', 'Sofortbelastung von Implantaten (Zähne in 24 Stunden)', 'İmplantlara anında yükleme (24 saatte diş)', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'immediate-implant-loading' OR name_en = 'Immediate Implant Loading (Teeth in 24 Hours)');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'immediate-implant-loading';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 74 FROM medical_services WHERE slug = 'immediate-implant-loading';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'immediate-implant-loading';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Teeth in 24 hours', 'en' FROM medical_services WHERE slug = 'immediate-implant-loading';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Teeth in a day', 'en' FROM medical_services WHERE slug = 'immediate-implant-loading';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Same-day teeth', 'en' FROM medical_services WHERE slug = 'immediate-implant-loading';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Zubi za 24h', 'sr' FROM medical_services WHERE slug = 'immediate-implant-loading';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Zubi za jedan dan', 'sr' FROM medical_services WHERE slug = 'immediate-implant-loading';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Зуби за 24 сата', 'sr-cyrl' FROM medical_services WHERE slug = 'immediate-implant-loading';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Зубы за один день', 'ru' FROM medical_services WHERE slug = 'immediate-implant-loading';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Одномоментная имплантация с нагрузкой', 'ru' FROM medical_services WHERE slug = 'immediate-implant-loading';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Feste Zähne an einem Tag', 'de' FROM medical_services WHERE slug = 'immediate-implant-loading';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Aynı gün diş', 'tr' FROM medical_services WHERE slug = 'immediate-implant-loading';

-- dentalesteticcentar.com /usluge/kompletna-restauracija.html: «cjelokupnu rekonstrukciju lica i vilica … donja trećina lica, zagriz i osmijeh čine cjelinu»;
-- /rekonstrukcija-zagriza-zuba/: «vrati visinu zuba, oslonac i sklad osmijeha». В каталоге нет. Категория 20, специальность 78.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'full-mouth-reconstruction', 'Full Mouth Reconstruction', 'Kompletna rekonstrukcija zuba i zagriza', 'Комплетна реконструкција зуба и загриза',
	'Полная реконструкция зубных рядов и прикуса', 'Komplette Gebiss- und Bissrekonstruktion', 'Tam ağız rekonstrüksiyonu', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'full-mouth-reconstruction' OR name_en = 'Full Mouth Reconstruction');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'full-mouth-reconstruction';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'full-mouth-reconstruction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Full mouth rehabilitation', 'en' FROM medical_services WHERE slug = 'full-mouth-reconstruction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Bite reconstruction', 'en' FROM medical_services WHERE slug = 'full-mouth-reconstruction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Kompletna restauracija zuba', 'sr' FROM medical_services WHERE slug = 'full-mouth-reconstruction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Rekonstrukcija zagriza', 'sr' FROM medical_services WHERE slug = 'full-mouth-reconstruction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Реконструкција загриза', 'sr-cyrl' FROM medical_services WHERE slug = 'full-mouth-reconstruction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Полная реабилитация полости рта', 'ru' FROM medical_services WHERE slug = 'full-mouth-reconstruction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Восстановление высоты прикуса', 'ru' FROM medical_services WHERE slug = 'full-mouth-reconstruction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Bisshebung', 'de' FROM medical_services WHERE slug = 'full-mouth-reconstruction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Kapanış rekonstrüksiyonu', 'tr' FROM medical_services WHERE slug = 'full-mouth-reconstruction';

-- Синонимы к существующим записям: бренд/система, названные сайтом, без бренд-дубля в каталоге.
-- complete-dental-cleaning: dentalesteticcentar.com /usluge/detox-usne-duplje.html: «Detox usne duplje je temeljno čišćenje: uklanjanje kamenca, mekog plaka, pigmentacija i bakterijskog biofilma» — собственное название клиники для полной профессиональной чистки (complete-dental-cleaning). Дубль не заводим, формулировку — синонимом.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Detox usne duplje', 'sr' FROM medical_services WHERE slug = 'complete-dental-cleaning';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Детокс усне дупље', 'sr-cyrl' FROM medical_services WHERE slug = 'complete-dental-cleaning';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Детокс полости рта', 'ru' FROM medical_services WHERE slug = 'complete-dental-cleaning';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (40)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_x_dec_services;
CREATE TEMPORARY TABLE tmp_x_dec_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_x_dec_services (slug, price, price_min, price_max) VALUES
	('initial-dental-examination-and-medical-record-opening', 0, NULL, NULL), -- /stomatolog-podgorica.html: «Prvi pregled je besplatan», «Besplatan prvi pregled»; /lijecenje-zuba/: «Pregled je besplatan. Kažemo šta vidimo i šta predlažemo» — 0 € (как dental-montenegro-budva)
	('follow-up-dental-examination', NULL, NULL, NULL), -- /lijecenje-zuba/: «Ako vas ništa ne boli, kontrola i dalje ima smisla … Poslije rada dobijate kada da se vratite na kontrolu»
	('teeth-whitening', NULL, NULL, NULL), -- /usluge/izbjeljivanje-zuba.html: «Profesionalno izbjeljivanje zuba u ordinaciji daje brži i kontrolisaniji rezultat od kućnih preparata»
	('composite-filling', NULL, NULL, NULL), -- /usluge/plombe.html: «Kompozitne plombe — „Bijele plombe“ od smole u boji zuba»
	('amalgam-filling', NULL, NULL, NULL), -- /usluge/plombe.html: «Amalgamske plombe — „Srebrne plombe“ od mješavine metala»
	('ceramic-inlay-onlay', NULL, NULL, NULL), -- /usluge/plombe.html: «Keramičke plombe — Od porculana»; /usluge/inley.html: «laboratorijski izrađeni ispuni (najčešće keramika ili kompozit)»
	('gold-inlay', NULL, NULL, NULL), -- /usluge/plombe.html: «Zlatne plombe — Vrlo izdržljive (često preko 20 godina) … za stražnje zube»
	('composite-inlay-onlay', NULL, NULL, NULL), -- /usluge/inley.html: «Inley i onley su laboratorijski izrađeni ispuni (najčešće keramika ili kompozit)»
	('metal-ceramic-crown', NULL, NULL, NULL), -- /usluge/metalkeramicke-krunice.html: «Metalkeramička krunica ima metalnu kapicu prekrivenu keramikom»
	('temporary-crown', NULL, NULL, NULL), -- /usluge/metalkeramicke-krunice.html: «Nakon brušenja zuba uzima se otisak, postavlja se privremena krunica, zatim se cementira gotov rad»
	('all-ceramic-crown', NULL, NULL, NULL), -- /usluge/bezmetalne-krunice.html: «Bezmetalne (keramičke / cirkonijumske) krunice nemaju metalnu podlogu»
	('metal-free-zirconia-ceramic-crown', NULL, NULL, NULL), -- /usluge/bezmetalne-krunice.html: «Bezmetalne (keramičke / cirkonijumske) krunice»; title «Cirkon i keramika»
	('ceramic-veneer', NULL, NULL, NULL), -- /usluge/viniri.html: «Fasete (viniri) su tanke keramičke ljuspice koje se lijepe na prednju stranu zuba»; /viniri-podgorica.html
	('dental-mock-up', NULL, NULL, NULL), -- /usluge/viniri.html: «Proces: pregled i digitalno/analitičko planiranje, eventualni mock-up, preparacija …»
	('smile-makeover', NULL, NULL, NULL), -- /usluge/hollywood-smile.html: «Estetski tretman za savršen, bijeli i simetričan osmijeh: izbjeljivanje, keramičke fasete ili krunice, korekcija zagriza i linije osmijeha»; /usluge/natural-smile.html: «diskretnije vinire, blago izbjeljivanje i minimalno brušenje» (запись заведена импортом omnidental-bar) (НОВАЯ запись каталога)
	('full-mouth-reconstruction', NULL, NULL, NULL), -- /usluge/kompletna-restauracija.html: «cjelokupnu rekonstrukciju lica i vilica … implantate, krunice, vinire, proteze»; /rekonstrukcija-zagriza-zuba/; /usluge/anti-aging-stomatologija.html: «krunice, viniri i podizanje zagriza» (НОВАЯ запись) (НОВАЯ запись каталога)
	('immediate-implant-loading', NULL, NULL, NULL), -- /usluge/zubi-za-24h.html: «nakon ekstrakcija ili ugradnje implantata isti dan ili u vrlo kratkom roku postavlja privremeni fiksni osmijeh» (НОВАЯ запись) (НОВАЯ запись каталога)
	('complete-dental-cleaning', NULL, NULL, NULL), -- /usluge/detox-usne-duplje.html: «Detox usne duplje je temeljno čišćenje: uklanjanje kamenca, mekog plaka, pigmentacija i bakterijskog biofilma» → синоним «Detox usne duplje»
	('gummy-smile-correction', NULL, NULL, NULL), -- /usluge/gummy-smile.html: «Rješenja zavise od uzroka: botox za usnu, korekcija desni (gingivektomija / produženje krune), viniri ili kombinacija» (запись заведена импортом stefanija-dental-podgorica) (НОВАЯ запись каталога)
	('gingivectomy', NULL, NULL, NULL), -- /usluge/gummy-smile.html: «korekcija desni (gingivektomija / produženje krune)»
	('dental-crown-lengthening', NULL, NULL, NULL), -- /usluge/gummy-smile.html: «korekcija desni (gingivektomija / produženje krune)»
	('dental-implant-placement', NULL, NULL, NULL), -- /usluge/zubni-implanti.html «Radovi na implantima»: «Ugradnja je u lokalnoj anesteziji. Osteointegracija traje 3 do 6 mjeseci»; /zubni-implanti-podgorica.html
	('implant-suprastructure', NULL, NULL, NULL), -- /usluge/zubni-implanti.html: «Zatim se postavlja gingivo former, pa suprastruktura i protetski rad»
	('complete-denture', NULL, NULL, NULL), -- /usluge/proteze.html: «Potpune proteze — Kod gubitka svih prirodnih zuba prekrivaju cijelu vilicu»
	('partial-denture', NULL, NULL, NULL), -- /usluge/proteze.html: «Parcijalne proteze — Kada nedostaje jedan ili više zuba, a preostali zdravi zubi služe kao oslonac»
	('complete-acrylic-denture', NULL, NULL, NULL), -- /usluge/akrilatna.html: «Akrilatna (plastična) proteza je klasična totalna ili parcijalna proteza od akrilata»
	('partial-acrylic-denture', NULL, NULL, NULL), -- /usluge/akrilatna.html: «… klasična totalna ili parcijalna proteza od akrilata»
	('flexible-denture', NULL, NULL, NULL), -- /usluge/fleksibilne-proteze.html: «Fleksibilne (termoplastične) proteze nemaju metalne kukice … Pogodne su za parcijalne nedostatke zuba»
	('skeletal-partial-denture', NULL, NULL, NULL), -- /usluge/parcijalne-skeletirane-proteze.html: «Skeletirana (metalna) parcijalna proteza ima tanki liveni skelet»
	('telescopic-crown', NULL, NULL, NULL), -- /usluge/proteze-na-teleskop-krunicama.html: «Teleskop proteza se veže na preostale zube preko dvostrukih krunica (unutrašnja na zubu, spoljašnja u protezi)» — единственная запись (Teleskop krunica)
	('hyaluronic-acid-filler', NULL, NULL, NULL), -- /usluge/hijaluronski-fileri.html: «Hijaluronski fileri su dermalni fileri koji se ubrizgavaju u kožu lica»; «Remodelacija jagodica»
	('lip-augmentation', NULL, NULL, NULL), -- /usluge/hijaluronski-fileri.html: «Usne: Hijaluronskim filerima možemo korigovati oblik, definiciju ivica, volumen i simetriju usana»
	('wrinkle-correction-hyaluronic-acid', NULL, NULL, NULL), -- /usluge/hijaluronski-fileri.html: «Nazolabijalne bore», «Bore marionete», «Bore iznad i ispod usana», «Čeona regija i bore između obrva»
	('botox-injection', NULL, NULL, NULL), -- /usluge/botox.html: «Botox (botulinum toxin) … posebno kod mimičnih bora … čelo, prostor između obrva i bore oko očiju»
	('prp-facial-treatment', NULL, NULL, NULL), -- /usluge/prp-tretman.html: «PRP tretman (Platelet Rich Plasma) … za podmlađivanje kože … aplikuje se u kožu tankim iglicama»
	('face-lifting-cog-threads', NULL, NULL, NULL), -- /usluge/cog-niti.html: «COG niti su savremena metoda za podmlađivanje lica bez hirurškog zahvata … za lifting i konturiranje lica»
	('mesothreads-treatment', NULL, NULL, NULL), -- /usluge/mezoniti.html: «Mezoniti su resorptivne niti koje se postavljaju u kožu radi zatezanja, liftinga i stimulacije kolagena»
	('chemical-peel', NULL, NULL, NULL), -- /usluge/hemijski-piling.html: «Hemijski piling podrazumijeva nanošenje rastvora kiselina na kožu»
	('facial-mesotherapy-single-treatment', NULL, NULL, NULL), -- /usluge/mezoterapija.html: «Mezoterapija lica … Obično serija od 2 do 4 tretmana» — пакет без числа и цены → разовый tretman
	('profhilo-treatment', NULL, NULL, NULL); -- /usluge/profhilo-tretman.html: «Profhilo … Dvije sesije, razdvojene četiri sedmice»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_x_dec_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_x_dec_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_x_dec_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- Врачей в импорте нет → привязок нет.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 40, with_price = 1.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 0 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

-- Новые записи каталога: категории, специальности, синонимы.
SELECT ms.id, ms.slug, ms.name_sr,
	(SELECT GROUP_CONCAT(medical_service_category_id) FROM medical_service_categories_relations WHERE medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(specialty_id) FROM medical_services_specialties WHERE medical_service_id = ms.id) AS specs,
	(SELECT COUNT(*) FROM medical_service_synonyms WHERE medical_service_id = ms.id) AS synonyms
FROM medical_services ms WHERE ms.slug IN ('gummy-smile-correction', 'smile-makeover', 'immediate-implant-loading', 'full-mouth-reconstruction');

DROP TEMPORARY TABLE IF EXISTS tmp_x_dec_services;