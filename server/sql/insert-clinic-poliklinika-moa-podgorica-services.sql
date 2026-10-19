-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika MOA (Podgorica) — услуги, цены, привязки врач ↔ услуга
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-moa-podgorica-services.sql
--
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-poliklinika-moa-podgorica.sql. Клиника — по google_place_id/slug,
-- услуги и врачи — по slug, литеральных id нет.
--
-- Источник: 5 HTML-страниц прайса moa.clinic, правка в wp-json 2026-09-14/15
--   cjenovnik-usluga-dermatovenerologija (2026-09-14), cjenovnik-hirurskih-intervencija
--   (2026-09-14), cjenovnik-estetska-medicina-i-antiaging (2026-09-15),
--   cjenovnik-fizikalna-medicina-i-rehabilitacija (2026-09-15),
--   cjenovnik-usluga-laserskih-i-inovativnih-tretmana (2026-09-15).
--   Страница стоматологии — заглушка («dummy text»), стоматология «u osnivanju».
--   Шесть позиций без цены — со страниц направлений / o-nama / FAQ (botoks, fileri,
--   hemijski piling, mezoterapija, trihološki pregled, PRP za kosu).
--
-- Цены: «X EUR» → price; «X-Y EUR» и ступени по числу/размеру/региону → price + price_max.
-- Эстетика: «lokalni doktor» → price, «gostujući doktor» → price_max (врачи не названы).
-- Пакеты («paket 4 tretmana», «7/10 tretmana», «paketi po regijama», «održavanje»,
-- «paket 7 preso terapija») — отдельные услуги каталога по схеме «<Base> Package N
-- Treatments» (решение юзера 2026-10-08), цена = цена пакета. Одинаковый состав с
-- разными областями/полом — одна запись с диапазоном. «+ gratis» — в комментарии.
-- is_price_outdated не ставится (решение за юзером), прайс свежий: сентябрь 2026.
--
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, цены пишутся
-- ON DUPLICATE KEY UPDATE, лишнее от прошлых прогонов удаляется. ⚠️ Услуги и
-- привязки, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJXX2p6ZAhsGgRFH7ibUguCr8' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'poliklinika-moa-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-poliklinika-moa-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (23) — идемпотентно по slug
-- Категории: 18 PLASTIC_SURGERY, 24 DERMATOLOGY, 31 WOUND_CARE.
-- Специальности: 7 DERMATOVENEROLOGY (авто для 24), 18 PLASTIC_SURGERY (авто для 18),
-- 44 AESTHETIC_MEDICINE (как у Botox/Jalupro/PRP в каталоге), 3 GENERAL_SURGERY.
-- Бренды аппаратов (Emsculpt Neo, Emface, Exion, Alma Harmony) — как называет сайт,
-- в кириллице не транслитерируются.
-- ═══════════════════════════════════════════════════════════════

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'emsculpt-neo-body-contouring', 'Emsculpt Neo Body Contouring', 'Emsculpt Neo oblikovanje tijela', 'Emsculpt Neo обликовање тијела',
	'Emsculpt Neo — моделирование тела', 'Emsculpt Neo Körperformung', 'Emsculpt Neo vücut şekillendirme', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'emsculpt-neo-body-contouring' OR name_en = 'Emsculpt Neo Body Contouring');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'emface-facial-treatment', 'Emface Facial Treatment', 'Emface tretman lica', 'Emface третман лица',
	'Emface — процедура для лица', 'Emface Gesichtsbehandlung', 'Emface yüz bakımı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'emface-facial-treatment' OR name_en = 'Emface Facial Treatment');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'exion-face-treatment', 'Exion Face Treatment', 'Exion tretman lica', 'Exion третман лица',
	'Exion — процедура для лица', 'Exion Gesichtsbehandlung', 'Exion yüz bakımı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'exion-face-treatment' OR name_en = 'Exion Face Treatment');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'exion-body-treatment', 'Exion Body Treatment', 'Exion tretman tijela', 'Exion третман тијела',
	'Exion — процедура для тела', 'Exion Körperbehandlung', 'Exion vücut bakımı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'exion-body-treatment' OR name_en = 'Exion Body Treatment');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'exion-fractional-face-treatment', 'Exion Fractional Face Treatment', 'Exion frakcioni tretman lica', 'Exion фракциони третман лица',
	'Exion — фракционная процедура для лица', 'Exion fraktionierte Gesichtsbehandlung', 'Exion fraksiyonel yüz bakımı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'exion-fractional-face-treatment' OR name_en = 'Exion Fractional Face Treatment');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'exion-fractional-body-treatment', 'Exion Fractional Body Treatment', 'Exion frakcioni tretman tijela', 'Exion фракциони третман тијела',
	'Exion — фракционная процедура для тела', 'Exion fraktionierte Körperbehandlung', 'Exion fraksiyonel vücut bakımı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'exion-fractional-body-treatment' OR name_en = 'Exion Fractional Body Treatment');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'alma-harmony-clearskin-clearlift-laser-treatment', 'Alma Harmony ClearSkin / ClearLift Laser Treatment', 'Alma Harmony ClearSkin / ClearLift laserski tretman', 'Alma Harmony ClearSkin / ClearLift ласерски третман',
	'Лазерная процедура Alma Harmony ClearSkin / ClearLift', 'Alma Harmony ClearSkin / ClearLift Laserbehandlung', 'Alma Harmony ClearSkin / ClearLift lazer tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'alma-harmony-clearskin-clearlift-laser-treatment' OR name_en = 'Alma Harmony ClearSkin / ClearLift Laser Treatment');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'alma-harmony-dvl-treatment', 'Alma Harmony DVL Treatment', 'Alma Harmony DVL tretman', 'Alma Harmony DVL третман',
	'Процедура Alma Harmony DVL', 'Alma Harmony DVL Behandlung', 'Alma Harmony DVL tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'alma-harmony-dvl-treatment' OR name_en = 'Alma Harmony DVL Treatment');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'alma-harmony-nir-treatment', 'Alma Harmony NIR Treatment', 'Alma Harmony NIR tretman', 'Alma Harmony NIR третман',
	'Процедура Alma Harmony NIR', 'Alma Harmony NIR Behandlung', 'Alma Harmony NIR tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'alma-harmony-nir-treatment' OR name_en = 'Alma Harmony NIR Treatment');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'exosome-therapy', 'Exosome Therapy', 'Terapija egzozomima', 'Терапија егзозомима',
	'Терапия экзосомами', 'Exosomen-Therapie', 'Eksozom tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'exosome-therapy' OR name_en = 'Exosome Therapy');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'molluscum-contagiosum-curettage', 'Molluscum Contagiosum Curettage', 'Kiretaža moluski', 'Киретажа молуски',
	'Кюретаж контагиозного моллюска', 'Kürettage von Dellwarzen', 'Molluskum kontagiozum küretajı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'molluscum-contagiosum-curettage' OR name_en = 'Molluscum Contagiosum Curettage');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'pressure-ulcer-dressing', 'Pressure Ulcer Dressing', 'Obrada i previjanje dekubitusa', 'Обрада и превијање декубитуса',
	'Обработка и перевязка пролежня', 'Versorgung und Verband eines Dekubitus', 'Bası yarası bakımı ve pansumanı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'pressure-ulcer-dressing' OR name_en = 'Pressure Ulcer Dressing');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'emsculpt-neo-1-region-package-4-treatments', 'Emsculpt Neo 1 Region Package 4 Treatments', 'Emsculpt Neo 1 regija – paket 4 tretmana', 'Emsculpt Neo 1 регија – пакет 4 третмана',
	'Emsculpt Neo 1 зона, пакет 4 процедуры', 'Emsculpt Neo 1 Region Paket 4 Behandlungen', 'Emsculpt Neo 1 bölge 4 seans paketi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'emsculpt-neo-1-region-package-4-treatments' OR name_en = 'Emsculpt Neo 1 Region Package 4 Treatments');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'emsculpt-neo-2-regions-package-4-treatments', 'Emsculpt Neo 2 Regions Package 4 Treatments', 'Emsculpt Neo 2 regije – paket 4 tretmana', 'Emsculpt Neo 2 регије – пакет 4 третмана',
	'Emsculpt Neo 2 зоны, пакет 4 процедуры', 'Emsculpt Neo 2 Regionen Paket 4 Behandlungen', 'Emsculpt Neo 2 bölge 4 seans paketi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'emsculpt-neo-2-regions-package-4-treatments' OR name_en = 'Emsculpt Neo 2 Regions Package 4 Treatments');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'emsculpt-neo-4-regions-package-4-treatments', 'Emsculpt Neo 4 Regions Package 4 Treatments', 'Emsculpt Neo 4 regije – paket 4 tretmana', 'Emsculpt Neo 4 регије – пакет 4 третмана',
	'Emsculpt Neo 4 зоны, пакет 4 процедуры', 'Emsculpt Neo 4 Regionen Paket 4 Behandlungen', 'Emsculpt Neo 4 bölge 4 seans paketi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'emsculpt-neo-4-regions-package-4-treatments' OR name_en = 'Emsculpt Neo 4 Regions Package 4 Treatments');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'emface-package-4-treatments', 'Emface Package 4 Treatments', 'Emface – paket 4 tretmana', 'Emface – пакет 4 третмана',
	'Emface пакет 4 процедуры', 'Emface Paket 4 Behandlungen', 'Emface 4 seans paketi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'emface-package-4-treatments' OR name_en = 'Emface Package 4 Treatments');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'exion-face-package-4-treatments', 'Exion Face Package 4 Treatments', 'Exion tretman lica – paket 4 tretmana', 'Exion третман лица – пакет 4 третмана',
	'Exion для лица пакет 4 процедуры', 'Exion Gesichtsbehandlung Paket 4 Behandlungen', 'Exion yüz bakımı 4 seans paketi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'exion-face-package-4-treatments' OR name_en = 'Exion Face Package 4 Treatments');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'exion-fractional-face-package-3-treatments', 'Exion Fractional Face Package 3 Treatments', 'Exion frakcioni tretman lica – paket 3 tretmana', 'Exion фракциони третман лица – пакет 3 третмана',
	'Exion фракционная процедура для лица пакет 3 процедуры', 'Exion fraktionierte Gesichtsbehandlung Paket 3 Behandlungen', 'Exion fraksiyonel yüz bakımı 3 seans paketi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'exion-fractional-face-package-3-treatments' OR name_en = 'Exion Fractional Face Package 3 Treatments');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'alma-soprano-titanium-laser-hair-removal-full-body-package-7-treatments', 'Alma Soprano Titanium Laser Hair Removal Full Body Package 7 Treatments', 'Alma Soprano Titanium laserska epilacija cijelo tijelo – 7 tretmana', 'Alma Soprano Titanium ласерска епилација цијело тијело – 7 третмана',
	'Лазерная эпиляция Alma Soprano Titanium всего тела пакет 7 процедур', 'Alma Soprano Titanium Laser-Haarentfernung Ganzkörper Paket 7 Behandlungen', 'Alma Soprano Titanium lazer epilasyon tüm vücut 7 seans paketi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'alma-soprano-titanium-laser-hair-removal-full-body-package-7-treatments' OR name_en = 'Alma Soprano Titanium Laser Hair Removal Full Body Package 7 Treatments');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'alma-soprano-titanium-laser-hair-removal-full-body-package-10-treatments', 'Alma Soprano Titanium Laser Hair Removal Full Body Package 10 Treatments', 'Alma Soprano Titanium laserska epilacija cijelo tijelo – 10 tretmana', 'Alma Soprano Titanium ласерска епилација цијело тијело – 10 третмана',
	'Лазерная эпиляция Alma Soprano Titanium всего тела пакет 10 процедур', 'Alma Soprano Titanium Laser-Haarentfernung Ganzkörper Paket 10 Behandlungen', 'Alma Soprano Titanium lazer epilasyon tüm vücut 10 seans paketi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'alma-soprano-titanium-laser-hair-removal-full-body-package-10-treatments' OR name_en = 'Alma Soprano Titanium Laser Hair Removal Full Body Package 10 Treatments');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'alma-soprano-titanium-laser-hair-removal-full-body-maintenance', 'Alma Soprano Titanium Laser Hair Removal Full Body Maintenance', 'Alma Soprano Titanium laserska epilacija cijelo tijelo – održavanje', 'Alma Soprano Titanium ласерска епилација цијело тијело – одржавање',
	'Лазерная эпиляция Alma Soprano Titanium всего тела — поддерживающая процедура', 'Alma Soprano Titanium Laser-Haarentfernung Ganzkörper Erhaltungsbehandlung', 'Alma Soprano Titanium lazer epilasyon tüm vücut bakım seansı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'alma-soprano-titanium-laser-hair-removal-full-body-maintenance' OR name_en = 'Alma Soprano Titanium Laser Hair Removal Full Body Maintenance');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'alma-soprano-titanium-laser-hair-removal-package-by-region', 'Alma Soprano Titanium Laser Hair Removal Package by Region', 'Alma Soprano Titanium laserska epilacija – paket po regiji', 'Alma Soprano Titanium ласерска епилација – пакет по регији',
	'Лазерная эпиляция Alma Soprano Titanium — пакет по зонам', 'Alma Soprano Titanium Laser-Haarentfernung Paket nach Region', 'Alma Soprano Titanium lazer epilasyon bölgesel paket', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'alma-soprano-titanium-laser-hair-removal-package-by-region' OR name_en = 'Alma Soprano Titanium Laser Hair Removal Package by Region');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'pressotherapy-package-7-treatments', 'Pressotherapy Package 7 Treatments', 'Presoterapija – paket 7 tretmana', 'Пресотерапија – пакет 7 третмана',
	'Прессотерапия пакет 7 процедур', 'Pressotherapie Paket 7 Behandlungen', 'Presoterapi 7 seans paketi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'pressotherapy-package-7-treatments' OR name_en = 'Pressotherapy Package 7 Treatments');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 5 FROM medical_services WHERE slug IN ('pressotherapy-package-7-treatments');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 18 FROM medical_services WHERE slug IN ('emsculpt-neo-body-contouring', 'emface-facial-treatment', 'exion-face-treatment', 'exion-body-treatment', 'exion-fractional-face-treatment', 'exion-fractional-body-treatment', 'alma-harmony-clearskin-clearlift-laser-treatment', 'alma-harmony-dvl-treatment', 'alma-harmony-nir-treatment', 'exosome-therapy', 'emsculpt-neo-1-region-package-4-treatments', 'emsculpt-neo-2-regions-package-4-treatments', 'emsculpt-neo-4-regions-package-4-treatments', 'emface-package-4-treatments', 'exion-face-package-4-treatments', 'exion-fractional-face-package-3-treatments', 'alma-soprano-titanium-laser-hair-removal-full-body-package-7-treatments', 'alma-soprano-titanium-laser-hair-removal-full-body-package-10-treatments', 'alma-soprano-titanium-laser-hair-removal-full-body-maintenance', 'alma-soprano-titanium-laser-hair-removal-package-by-region');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 24 FROM medical_services WHERE slug IN ('emface-facial-treatment', 'exion-face-treatment', 'exion-fractional-face-treatment', 'exion-fractional-body-treatment', 'alma-harmony-clearskin-clearlift-laser-treatment', 'alma-harmony-dvl-treatment', 'alma-harmony-nir-treatment', 'exosome-therapy', 'molluscum-contagiosum-curettage', 'emface-package-4-treatments', 'exion-face-package-4-treatments', 'exion-fractional-face-package-3-treatments', 'alma-soprano-titanium-laser-hair-removal-full-body-package-7-treatments', 'alma-soprano-titanium-laser-hair-removal-full-body-package-10-treatments', 'alma-soprano-titanium-laser-hair-removal-full-body-maintenance', 'alma-soprano-titanium-laser-hair-removal-package-by-region');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 31 FROM medical_services WHERE slug IN ('pressure-ulcer-dressing');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 3 FROM medical_services WHERE slug IN ('pressure-ulcer-dressing');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 7 FROM medical_services WHERE slug IN ('emface-facial-treatment', 'exion-face-treatment', 'exion-fractional-face-treatment', 'exion-fractional-body-treatment', 'alma-harmony-clearskin-clearlift-laser-treatment', 'alma-harmony-dvl-treatment', 'alma-harmony-nir-treatment', 'exosome-therapy', 'molluscum-contagiosum-curettage', 'emface-package-4-treatments', 'exion-face-package-4-treatments', 'exion-fractional-face-package-3-treatments', 'alma-soprano-titanium-laser-hair-removal-full-body-package-7-treatments', 'alma-soprano-titanium-laser-hair-removal-full-body-package-10-treatments', 'alma-soprano-titanium-laser-hair-removal-full-body-maintenance', 'alma-soprano-titanium-laser-hair-removal-package-by-region');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 18 FROM medical_services WHERE slug IN ('emsculpt-neo-body-contouring', 'emface-facial-treatment', 'exion-face-treatment', 'exion-body-treatment', 'exion-fractional-face-treatment', 'exion-fractional-body-treatment', 'alma-harmony-clearskin-clearlift-laser-treatment', 'alma-harmony-dvl-treatment', 'alma-harmony-nir-treatment', 'exosome-therapy', 'emsculpt-neo-1-region-package-4-treatments', 'emsculpt-neo-2-regions-package-4-treatments', 'emsculpt-neo-4-regions-package-4-treatments', 'emface-package-4-treatments', 'exion-face-package-4-treatments', 'exion-fractional-face-package-3-treatments', 'alma-soprano-titanium-laser-hair-removal-full-body-package-7-treatments', 'alma-soprano-titanium-laser-hair-removal-full-body-package-10-treatments', 'alma-soprano-titanium-laser-hair-removal-full-body-maintenance', 'alma-soprano-titanium-laser-hair-removal-package-by-region');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 42 FROM medical_services WHERE slug IN ('pressotherapy-package-7-treatments');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 44 FROM medical_services WHERE slug IN ('emsculpt-neo-body-contouring', 'emface-facial-treatment', 'exion-face-treatment', 'exion-body-treatment', 'exion-fractional-face-treatment', 'exion-fractional-body-treatment', 'alma-harmony-clearskin-clearlift-laser-treatment', 'alma-harmony-dvl-treatment', 'alma-harmony-nir-treatment', 'exosome-therapy', 'emsculpt-neo-1-region-package-4-treatments', 'emsculpt-neo-2-regions-package-4-treatments', 'emsculpt-neo-4-regions-package-4-treatments', 'emface-package-4-treatments', 'exion-face-package-4-treatments', 'exion-fractional-face-package-3-treatments');

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Эмскульпт Нео', 'ru' FROM medical_services WHERE slug = 'emsculpt-neo-body-contouring'
UNION ALL SELECT id, 'Эмфейс', 'ru' FROM medical_services WHERE slug = 'emface-facial-treatment'
UNION ALL SELECT id, 'Эксион для лица', 'ru' FROM medical_services WHERE slug = 'exion-face-treatment'
UNION ALL SELECT id, 'Эксион для тела', 'ru' FROM medical_services WHERE slug = 'exion-body-treatment'
UNION ALL SELECT id, 'Egzozomi', 'sr' FROM medical_services WHERE slug = 'exosome-therapy'
UNION ALL SELECT id, 'Егзозоми', 'sr-cyrl' FROM medical_services WHERE slug = 'exosome-therapy'
UNION ALL SELECT id, 'Exosomes', 'en' FROM medical_services WHERE slug = 'exosome-therapy'
UNION ALL SELECT id, 'Экзосомы', 'ru' FROM medical_services WHERE slug = 'exosome-therapy'
UNION ALL SELECT id, 'Kiretiranje moluski', 'sr' FROM medical_services WHERE slug = 'molluscum-contagiosum-curettage'
UNION ALL SELECT id, 'Киретирање молуски', 'sr-cyrl' FROM medical_services WHERE slug = 'molluscum-contagiosum-curettage'
UNION ALL SELECT id, 'Molluscum Removal', 'en' FROM medical_services WHERE slug = 'molluscum-contagiosum-curettage'
UNION ALL SELECT id, 'Удаление контагиозного моллюска', 'ru' FROM medical_services WHERE slug = 'molluscum-contagiosum-curettage'
UNION ALL SELECT id, 'Dellwarzen entfernen', 'de' FROM medical_services WHERE slug = 'molluscum-contagiosum-curettage'
UNION ALL SELECT id, 'Decubitus Dressing', 'en' FROM medical_services WHERE slug = 'pressure-ulcer-dressing'
UNION ALL SELECT id, 'Previjanje dekubitusa', 'sr' FROM medical_services WHERE slug = 'pressure-ulcer-dressing'
UNION ALL SELECT id, 'Превијање декубитуса', 'sr-cyrl' FROM medical_services WHERE slug = 'pressure-ulcer-dressing'
UNION ALL SELECT id, 'Перевязка пролежней', 'ru' FROM medical_services WHERE slug = 'pressure-ulcer-dressing';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (80, из них с ценой 74)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_moa_services;
CREATE TEMPORARY TABLE tmp_moa_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_moa_services (slug, price, price_min, price_max) VALUES
-- ── dermatovenerologija ───────────────────────────────────────────────────
('first-dermatologist-examination', 50.00, NULL, NULL), -- PRVI PREGLED DERMATOLOGA 50 EUR
('follow-up-dermatologist-examination', 30.00, NULL, NULL), -- KONTROLNI PREGLED DERMATOLOGA 30 EUR / U OKVIRU MJESEC DANA OD PRVOG PREGLEDA
('dermatoscopy', 50.00, NULL, NULL), -- DERMOSKOPSKI PREGLED MLADEŽA 50 EUR
('dermatologist-examination-with-dermatoscopy', 80.00, NULL, NULL), -- PREGLED DERMATOLOGA I DERMOSKOPIJA 80 EUR
('radiowave-skin-lesion-removal', 60.00, NULL, 100.00), -- RADIOTALASNO UKLANJANJE VIRUSNIH BRADAVICA 60 EUR (ZAVISNO OD BROJA PROMJENA DO 100 €); RADIOTALASNO UKLANJ...
('condyloma-radio-wave-removal', 100.00, NULL, NULL), -- RAFIOTALASNO UKLANJANJE KONDILOMA 100 EUR (опечатка «RAFIOTALASNO» в источнике)
('cryotherapy', 50.00, NULL, 80.00), -- KRIOTERAPIJA (TEČNI AZOT): DO 5 PROMJENA 50 EUR / DO 10 PROMJENA 80 EUR
('senile-keratosis-treatment-with-liquid-nitrogen-per-session', 50.00, NULL, NULL), -- KRIOTERAPIJA KERATOZA 50 EUR
('molluscum-contagiosum-curettage', 60.00, NULL, 90.00), -- KIRETIRANJE MOLUSKI KOD DJECE: DO 5 PROMJENA 60 EUR / DO 10 PROMJENA 90 EUR
('trichologist-examination', NULL, NULL, NULL), -- Trichološki pregledi za dijagnostiku uzroka opadanja kose
('prp-hair-vitality', NULL, NULL, NULL), -- PRP tretmani (plazma bogata trombocitima) za stimulaciju rasta kose
-- ── opšta hirurgija ───────────────────────────────────────────────────────
('surgical-examination', 50.00, NULL, NULL), -- Specijalistički pregled 50 EUR (cjenovnik usluga opšte hirurgije)
('small-wound-dressing', 40.00, NULL, NULL), -- HIRURŠKO PREVIJANJE RANE manje 40 EUR
('large-wound-dressing', 60.00, NULL, NULL), -- HIRUŠKO PREVIJANJE RANE veće 60 EUR
('necrectomy-and-wound-care', 75.00, NULL, NULL), -- HIRURŠKI DEBRIDMAN RANE 75 EUR
('suture-removal', 40.00, NULL, NULL), -- SKIDANJE HIR. KONACA 40 EUR
('primary-wound-care-with-sutures', 75.00, NULL, 90.00), -- OBRADA I UŠIVANJE RANE manje 75 EUR / veće 90 EUR
('treatment-of-smaller-wounds-without-deep-structure-lesion-direct', 110.00, NULL, NULL), -- OBRADA I UŠIVANJE RANE lice 110 EUR
('leg-ulcer-dressing', 75.00, NULL, 90.00), -- OBRADA I PREVIJANJE ULCUS CRURIS-a manje 75 EUR / PREVIJANJE ULCUS CRURIS-a veće 90 EUR
('burn-wound-care', 80.00, NULL, 110.00), -- OBRADA I PREVIJANJE OPEKOTINA 80-110 EUR
('pressure-ulcer-dressing', 75.00, NULL, 110.00), -- OBRADA I PREVIJANJE DEKUBITUSA manje 75 EUR / veće 110 EUR
('decubitus-surgical-treatment', 200.00, NULL, NULL), -- HIRURŠKA OBRADA I PREVIJANJE DEKUBITUSA 200 EUR / u kućnoj posjeti
('ingrown-toenail-surgery', 135.00, NULL, NULL), -- HIRURŠKA INTERVENCIJA URASLOG NOKTA 135 EUR
('nail-ablation', 110.00, NULL, NULL), -- UKLANJANJE (ablacija) NOKATNE PLOČE 110 EUR
('foot-callus-surgical-removal', 135.00, NULL, NULL), -- HIRURŠKO LIJEČENJE KLAVUSA “kurjeg oka” 135 EUR
('small-skin-abscess-incision', 75.00, NULL, NULL), -- INCIZIJA APSCESA mala 75 EUR
('large-skin-abscess-incision', 115.00, NULL, NULL), -- INCIZIJA APSCESA veća 115 EUR
('excision-of-external-thrombosed-hemorrhoids', 150.00, NULL, NULL), -- EKSCIZIJA TROMBOZIRANOG SPOLJAŠNJEG HEMOROIDA 150 EUR
('pigmented-nevus-surgical-removal', 115.00, NULL, NULL), -- EKSCIZIJA NEVUSA 115 EUR
('atheroma-removal', 60.00, NULL, 80.00), -- UKLANJANJE ATEROMA (sebacealne-epidermalne ciste) 60-80 EUR
('excision-of-small-benign-tumor-scars-fibromas-or-cysts', 60.00, NULL, 80.00), -- UKLANJANJE DERMATOFIBROMA 60-80 EUR
('lipoma-removal', 60.00, NULL, 80.00), -- UKLANJANJE LIPOMA 60-80 EUR
('viral-wart-surgical-removal', 50.00, NULL, NULL), -- UKLANJANJE BRADAVICA (do 10) 50 EUR
('skin-lesion-removal', 50.00, NULL, 70.00), -- UKLANJANJE PREKANCEROZA (aktinične keratoze, susp. pigmentne promjene, cornu cutaneum i ostalo) 50-70 EUR
('excision-of-malignant-skin-lesions-with-wound-suturing', 80.00, NULL, 115.00), -- EKSCIZIJA EPITELIOMA BASOCELLULARE I SQUAMOCELLULARE 80-115 EUR
('skin-and-subcutaneous-tissue-biopsy', 60.00, NULL, NULL), -- BIOPSIJA KOŽNIH PROMJENA 60 EUR
('foreign-body-extraction-surgery', 60.00, NULL, NULL), -- VAĐENJE STRANOG TIJELA 60 EUR
('tick-removal', 60.00, NULL, NULL), -- UKLANJANJE KRPELJA 60 EUR
('electrocoagulation-or-excision-of-condyloma-acuminata', 90.00, NULL, 115.00), -- UKLANJENJE KONDILOMA (do 10 kondiloma) 90 EUR / UKLANJANJE KONDILOMA (više od 10 kondiloma) 115 EUR
('abdominal-paracentesis', 140.00, NULL, NULL), -- PUNKCIJA ASCITA 140 EUR
('urinary-catheter-placement', 50.00, NULL, NULL), -- PLASIRANJE ILI ZAMJENA URINARNOG KATETERA 50 EUR
-- ── fizikalna medicina i rehabilitacija ───────────────────────────────────
('first-physiatrist-examination', 50.00, NULL, NULL), -- SPECIJALISTIČKI PREGLED 50 EUR
('follow-up-physiatrist-examination', 30.00, NULL, NULL), -- KONTROLNI PREGLED 30 EUR
-- ── estetska medicina i antiaging ─────────────────────────────────────────
('hyperhidrosis-botox-treatment', 300.00, NULL, NULL), -- HIPERHIDROZA 300 EUR (lokalni i gostujući doktor)
('non-surgical-rhinoplasty', 300.00, NULL, NULL), -- KOREKCIJA NOSA 300 EUR (lokalni i gostujući doktor)
('jalupro-super-hydro-treatment', 250.00, NULL, 300.00), -- JALUPRO SUPER HYDRO 250 EUR (lokalni) / 300 EUR (gostujući)
('jalupro-young-eye', 160.00, NULL, 200.00), -- JALUPRO YOUNG EYE 160 EUR (lokalni) / 200 EUR (gostujući)
('prp-facial-treatment', 200.00, NULL, 250.00), -- PRP 200 EUR (lokalni) / 250 EUR (gostujući)
('prp-therapy-cellular-matrix', 250.00, NULL, 290.00), -- PRP CELLULAR 250 EUR (lokalni) / 290 EUR (gostujući)
('exosome-therapy', 200.00, NULL, 230.00), -- EGZOZOMI 200 EUR (lokalni) / 230 EUR (gostujući)
('nefertiti-lift', 330.00, NULL, 360.00), -- NEFERTITI 330 EUR (lokalni) / 360 EUR (gostujući)
('lipolysis', 200.00, NULL, NULL), -- LIPOLIZA 200 EUR (только «lokalni doktor»)
('botox-injection', NULL, NULL, NULL), -- Botox tretmani / Botoks (Botulinum toksin)
('hyaluronic-acid-filler', NULL, NULL, NULL), -- Hijaluronski fileri / Dermalni fileri
('chemical-peel', NULL, NULL, NULL), -- Hemijski piling / Hemijski peel
('facial-mesotherapy-single-treatment', NULL, NULL, NULL), -- Mezoterapija
-- ── laserski i inovativni tretmani ────────────────────────────────────────
('emsculpt-neo-body-contouring', 250.00, NULL, 300.00), -- EMSCULPT NEO, 1 REGIJA: stomak 300, butine 300, unutrašnja strana butina 250, listovi 250, biceps 250, tric...
('emface-facial-treatment', 200.00, NULL, 450.00), -- EMFACE: 1 REGIJA (ČELO/OBRAZI/PODBRADAK) 200, 2 REGIJE 300, 3 REGIJE (ČELO, OBRAZI, SUBMENTUM) 450 EUR
('exion-face-treatment', 60.00, NULL, 250.00), -- EXION FACE: LICE (FULL FACE) 250, OKOLOOČNA REGIJA 60, REGIJA OKO USANA I USNE 60, VRAT 100, DEKOLTE 100 EUR
('exion-body-treatment', 150.00, NULL, 250.00), -- EXION BODY: VELIKA REGIJA (STOMAK, BUTINE, GLUTEUS) 250, MALA REGIJA (LISTOVI, KOLJENA, NADLAKTICE, ŠAKE) 1...
('exion-fractional-face-treatment', 300.00, NULL, 600.00), -- EXION FRAKCIONI: LICE 450, LICE + VRAT 500, LICE + DEKOLTE 550, LICE + VRAT + DEKOLTE 600, VRAT + DEKOLTE 3...
('exion-fractional-body-treatment', 500.00, NULL, 550.00), -- EXION FRAKCIONI - TIJELO: VELIKA REGIJA 500, VELIKA REGIJA + MALA REGIJA 550 EUR
('alma-harmony-clearskin-clearlift-laser-treatment', 150.00, NULL, 250.00), -- ALMA HARMONY XL PRO — CLEAR SKIN/CLEAR LIFT: LICE 15O, LICE + VRAT 200, LICE + VRAT + DEKOLTE 250 EUR («15O...
('alma-harmony-dvl-treatment', 100.00, NULL, NULL), -- ALMA HARMONY XL PRO — DVL 100 EUR
('alma-harmony-nir-treatment', 100.00, NULL, NULL), -- ALMA HARMONY XL PRO — NIR 100 EUR
('alma-soprano-titanium-special-edition-hair-removal', 25.00, NULL, 180.00), -- ALMA SOPRANO TITANIUM SPECIAL EDITION — POJEDINAČNI TRETMANI: žene mala/srednja/velika regija 25/35/60, muš...
('general-practitioner-examination', 30.00, NULL, NULL), -- LJEKARSKI PREGLED 30 EUR
('vitamin-or-anti-aging-tad-infusion', 65.00, NULL, NULL), -- INTRAVENSKA INFUZIJA (vitaminska inf. sa glutationom) 65 EUR
('pressotherapy', 30.00, NULL, NULL), -- PRESO TERAPIJA 30 EUR
-- ── laserski i inovativni tretmani — пакеты ───────────────────────────────
('emsculpt-neo-1-region-package-4-treatments', 900.00, NULL, 1100.00), -- EMS paket 4 tretmana: stomak 1100, butine 1100, unutrašnja strana butina 900, listovi 900, biceps 900, tric...
('emsculpt-neo-2-regions-package-4-treatments', 1750.00, NULL, 1950.00), -- PAKET (2 VELIKE REGIJE) - 4 TRETMANA 1950 EUR; PAKET (2 MALE REGIJE) - 4 TRETMANA 1750 EUR; PAKET (MALA + V...
('emsculpt-neo-4-regions-package-4-treatments', 4500.00, NULL, NULL), -- PAKET (4 REGIJE - 4 TRETMANA) 4500 EUR
('emface-package-4-treatments', 1200.00, NULL, 1600.00), -- EMFACE PAKET 4 TRETMANA (2 REGIJE) 1200 EUR; PAKET 4 TRETMANA (3 REGIJE) 1600 EUR (+ 2 EXION FACE GRATIS)
('exion-face-package-4-treatments', 900.00, NULL, NULL), -- EXION FACE PAKET 4 TRETMANA + 2 TRETMANA (VRAT/DEKOLTE) GRATIS 900 EUR
('exion-fractional-face-package-3-treatments', 1100.00, NULL, NULL), -- EXION FRAKCIONI PAKET 3 TRETMANA (LICE) 1100 EUR
('alma-soprano-titanium-laser-hair-removal-full-body-package-7-treatments', 1150.00, NULL, 1450.00), -- SOPRANO CIJELO TIJELO (7 TRETMANA): žene 1150 EUR, muškarci 1450 EUR
-- Новая пакетная запись. В прайсе у женщин «350 EUR» — опечатка: 10 процедур не могут стоить дешевле 7 (1150 €), у мужчин 1450 → 1600. Исправлено на 1350 (правило: ошибки источника исправляем, а не переносим).
('alma-soprano-titanium-laser-hair-removal-full-body-package-10-treatments', 1350.00, NULL, 1600.00), -- SOPRANO CIJELO TIJELO (10 TRETMANA): žene 350 (опечатка, = 1350) EUR, muškarci 1600 EUR
('alma-soprano-titanium-laser-hair-removal-full-body-maintenance', 200.00, NULL, 330.00), -- SOPRANO CIJELO TIJELO - ODRŽAVANJE: žene 200 EUR, muškarci 33O EUR (буква O в источнике)
('alma-soprano-titanium-laser-hair-removal-package-by-region', 100.00, NULL, 800.00), -- SOPRANO PAKETI PO REGIJAMA — žene: cijele noge 500, pola nogu 250, ruke 250, intimna regija 250, intimna re...
('pressotherapy-package-7-treatments', 190.00, NULL, NULL); -- PAKET 7 PRESO TERAPIJA 190 EUR

-- Страховка: slug, не найденные в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_service
FROM tmp_moa_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_moa_services t
JOIN medical_services ms ON ms.slug = t.slug
ON DUPLICATE KEY UPDATE price = VALUES(price), price_min = VALUES(price_min), price_max = VALUES(price_max);

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_moa_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (цены NULL — только связь)
-- Заведено только то, что сайт приписывает конкретному врачу:
--   * Shamenkova — блог 2025-03-13 и 2026-01-12: botoks, dermalni fileri, PRP;
--   * Albeik — блог 2025-03-24: «Anti-age procedure (botox, filere i laserske tretmane)»;
--   * Topalović — блог 2025-03-06 «dr Erna»: «hijaluronskih filera, botoksa»;
--   * Vuković — единственный физиатр состава ↔ прайс fizikalne medicine (2 осмотра);
--   * prof. Nikolić — посты 2026: «specijalističke dermatološke preglede i konsultacije».
-- Остальные услуги прайса врача не называют — к врачам не привязаны.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_moa_doctor_services;
CREATE TEMPORARY TABLE tmp_moa_doctor_services (
	doctor_slug VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_moa_doctor_services (doctor_slug, service_slug) VALUES
('natalia-shamenkova', 'botox-injection'),
('natalia-shamenkova', 'hyaluronic-acid-filler'),
('natalia-shamenkova', 'prp-facial-treatment'),
('bilal-albeik', 'botox-injection'),
('bilal-albeik', 'hyaluronic-acid-filler'),
('erna-topalovic', 'botox-injection'),
('erna-topalovic', 'hyaluronic-acid-filler'),
('milos-nikolic', 'first-dermatologist-examination'),
('marina-vukovic', 'first-physiatrist-examination'),
('marina-vukovic', 'follow-up-physiatrist-examination');

-- Полная пересборка привязок врачей ЭТОЙ клиники (новые слаги для Kaluđerović на
-- случай создания записи заново — djordje-kaludjerovic).
DELETE cmsd FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
WHERE cmsd.clinic_id = @clinic_id
	AND d.slug IN ('djordjije-kaludjerovic', 'edin-kulovic', 'erna-topalovic', 'marina-vukovic', 'milic-petar', 'milan-djordjevic', 'natalia-shamenkova', 'sanja-vujanovic', 'bilal-albeik', 'milos-nikolic', 'djordje-kaludjerovic');

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_moa_doctor_services t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 80 услуг, с ценой 74.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 23 новых записей каталога, у каждой категория и специальность.
SELECT ms.id, ms.slug, ms.name_sr_cyrl,
	(SELECT GROUP_CONCAT(medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(specialty_id) FROM medical_services_specialties sp WHERE sp.medical_service_id = ms.id) AS specs
FROM medical_services ms WHERE ms.slug IN ('emsculpt-neo-body-contouring', 'emface-facial-treatment', 'exion-face-treatment', 'exion-body-treatment', 'exion-fractional-face-treatment', 'exion-fractional-body-treatment', 'alma-harmony-clearskin-clearlift-laser-treatment', 'alma-harmony-dvl-treatment', 'alma-harmony-nir-treatment', 'exosome-therapy', 'molluscum-contagiosum-curettage', 'pressure-ulcer-dressing', 'emsculpt-neo-1-region-package-4-treatments', 'emsculpt-neo-2-regions-package-4-treatments', 'emsculpt-neo-4-regions-package-4-treatments', 'emface-package-4-treatments', 'exion-face-package-4-treatments', 'exion-fractional-face-package-3-treatments', 'alma-soprano-titanium-laser-hair-removal-full-body-package-7-treatments', 'alma-soprano-titanium-laser-hair-removal-full-body-package-10-treatments', 'alma-soprano-titanium-laser-hair-removal-full-body-maintenance', 'alma-soprano-titanium-laser-hair-removal-package-by-region', 'pressotherapy-package-7-treatments');

-- Ожидается 5 врачей, сумма привязок 10.
SELECT d.slug, COUNT(*) AS linked_services
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
WHERE cmsd.clinic_id = @clinic_id
GROUP BY d.slug ORDER BY d.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_moa_services;
DROP TEMPORARY TABLE IF EXISTS tmp_moa_doctor_services;
