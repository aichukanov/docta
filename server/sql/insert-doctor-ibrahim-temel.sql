SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Temel Dental (Podgorica): главный врач Ibrahim Temel, расширяющий аппарат и элайнеры.
--
-- Источники (2026-10-07):
--   • со слов пользователя (визит в клинику): турок, главный врач, ортодонт,
--     говорит по-сербски и по-русски; сам снимает слепки и изготавливает элайнеры
--     (где именно изготавливает — неизвестно, возможно в Турции; в описание не пишем).
--     Пациент — ребёнок 11 лет («самое время»). Схема лечения: около полугода
--     расширяющий челюсть съёмный аппарат с винтом
--     (подкручивать раз в неделю на один оборот) — около 1000 €; затем элайнеры,
--     новые каждый месяц по 200 €, 6–12 месяцев → 1200–2400 €;
--   • имя: отзывы Google — «Their main dentist Ibrahim Temel», «Ibrahim Bey»,
--     «Ибрагим Бей» (data/google-places/podgorica/temel-*.json).
-- Сайт temeldental.com — это Temel Dental в Аланье (Турция), сейчас отдаёт 503;
-- в архиве Ибрагима среди врачей нет. Образование и стаж не подтверждены,
-- в описание не вносятся.
--
-- Аппарат → orthodontic-removable-plate-appliance: его справка — съёмная пластинка
-- с винтом для ребёнка, расширяет челюсть, винт подкручивают по инструкции. Не
-- orthodontic-plate-with-screw (справки нет) и не rapid-palatal-expander (несъёмный,
-- винт ежедневно). Медленное расширение съёмной пластинкой работает у растущих
-- пациентов, поэтому в описании «детям при необходимости».
-- Цены — только в услугах, в описании врача их нет (не дублировать и не устаревать в 6 языках).
--
-- Клиника, врач и услуги — только по slug (id локально и на проде расходятся).
-- Файл идемпотентен: повторный прогон ничего не меняет.

SET @c = (SELECT id FROM clinics WHERE slug = 'temel-dental-podgorica');
SET @ms_aligners = (SELECT id FROM medical_services WHERE slug = 'clear-aligner-therapy');
SET @ms_expander = (SELECT id FROM medical_services WHERE slug = 'orthodontic-removable-plate-appliance');

-- ═══ 1. Врач ═══

SET @d = (SELECT id FROM doctors WHERE slug = 'ibrahim-temel' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, created_at)
SELECT 'ibrahim-temel', 'Ibrahim Temel', 'Ибрахим Темел', 'Ибрагим Темель', 'Ibrahim Temel', 'dr', NOW()
FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ibrahim-temel'));

UPDATE doctors SET
	description_sr = 'Ortodont iz Turske, glavni doktor klinike. Liječi providnim folijama (alajnerima): sam uzima otiske i izrađuje folije. Kod djece, kada je potrebno, liječenje počinje pokretnim aparatom za širenje vilice: nosi se oko pola godine, a šraf se okreće jednom sedmično. Zatim se prelazi na folije — mijenjaju se svakog mjeseca, a ova faza obično traje 6–12 mjeseci.',
	description_sr_cyrl = 'Ортодонт из Турске, главни доктор клинике. Лијечи провидним фолијама (алајнерима): сам узима отиске и израђује фолије. Код дјеце, када је потребно, лијечење почиње покретним апаратом за ширење вилице: носи се око пола године, а шраф се окреће једном седмично. Затим се прелази на фолије — мијењају се сваког мјесеца, а ова фаза обично траје 6–12 мјесеци.',
	description_ru = 'Ортодонт из Турции, главный врач клиники. Лечит прозрачными элайнерами: сам снимает слепки и изготавливает элайнеры. Детям при необходимости начинает лечение со съёмного аппарата, расширяющего челюсть: его носят около полугода и раз в неделю подкручивают винт. Затем переходят на элайнеры — их меняют каждый месяц, этот этап обычно занимает 6–12 месяцев.',
	description_en = 'Orthodontist from Turkey and the clinic''s chief doctor. Treats patients with clear aligners: takes the impressions and makes the aligners himself. For children, when needed, treatment starts with a removable jaw-expanding appliance worn for about six months, with its screw turned once a week. Then comes the aligner stage: the aligners are replaced every month, and this stage usually lasts 6–12 months.',
	description_de = 'Kieferorthopäde aus der Türkei und Chefarzt der Klinik. Behandelt mit transparenten Alignern: nimmt selbst die Abdrücke und fertigt die Aligner selbst an. Bei Kindern beginnt die Behandlung bei Bedarf mit einer herausnehmbaren Apparatur zur Kieferdehnung: Sie wird etwa ein halbes Jahr getragen, die Schraube wird einmal pro Woche gedreht. Danach folgen die Aligner – sie werden jeden Monat gewechselt, diese Phase dauert meist 6–12 Monate.',
	description_tr = 'Türkiye''den ortodontist, kliniğin başhekimi. Şeffaf plak tedavisi uyguluyor: ölçüleri kendisi alıyor ve plakları kendisi hazırlıyor. Çocuklarda gerektiğinde tedavi hareketli çene genişletici apareyle başlar: yaklaşık altı ay takılır ve vidası haftada bir çevrilir. Ardından şeffaf plaklara geçilir; her ay değiştirilir, bu aşama genellikle 6–12 ay sürer.'
WHERE id = @d;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT @d, id FROM specialties WHERE name IN ('orthodontist', 'dentistry') AND @d IS NOT NULL;

INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @d, id FROM languages WHERE code IN ('tr', 'ru', 'sr') AND @d IS NOT NULL;

INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @d, @c, NULL FROM dual WHERE @d IS NOT NULL AND @c IS NOT NULL;

-- ═══ 2. Услуги клиники ═══
-- Диапазон = price (нижняя граница) + price_max, так сайт выводит «X – Y €».

-- Расширяющий аппарат: около 1000 €.
INSERT INTO clinic_medical_services (medical_service_id, clinic_id, price, created_at)
SELECT @ms_expander, @c, 1000.00, NOW()
FROM dual
WHERE @ms_expander IS NOT NULL AND @c IS NOT NULL
	AND NOT EXISTS (
		SELECT 1 FROM clinic_medical_services WHERE clinic_id = @c AND medical_service_id = @ms_expander
	);
UPDATE clinic_medical_services
SET price = 1000.00, price_min = NULL, price_max = NULL, is_price_outdated = 0, is_obsolete = 0
WHERE clinic_id = @c AND medical_service_id = @ms_expander;

-- Элайнеры: 200 € в месяц × 6–12 месяцев = 1200–2400 €.
INSERT INTO clinic_medical_services (medical_service_id, clinic_id, price, price_max, created_at)
SELECT @ms_aligners, @c, 1200.00, 2400.00, NOW()
FROM dual
WHERE @ms_aligners IS NOT NULL AND @c IS NOT NULL
	AND NOT EXISTS (
		SELECT 1 FROM clinic_medical_services WHERE clinic_id = @c AND medical_service_id = @ms_aligners
	);
UPDATE clinic_medical_services
SET price = 1200.00, price_min = NULL, price_max = 2400.00, is_price_outdated = 0, is_obsolete = 0
WHERE clinic_id = @c AND medical_service_id = @ms_aligners;

-- ═══ 3. Врач ↔ услуги ═══

DELETE FROM clinic_medical_service_doctors
WHERE clinic_id = @c AND doctor_id = @d AND medical_service_id IN (@ms_aligners, @ms_expander);
INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT @d, @c, ms.id, NULL, NULL, NOW()
FROM medical_services ms
WHERE ms.id IN (@ms_aligners, @ms_expander) AND @d IS NOT NULL AND @c IS NOT NULL;

-- ═══ Проверка ═══

-- Ожидается 1 строка: ibrahim-temel, языки ru,sr,tr, специальности dentistry,orthodontist.
SELECT d.slug, d.name_ru,
	(SELECT GROUP_CONCAT(l.code ORDER BY l.code) FROM doctor_languages dl JOIN languages l ON l.id = dl.language_id WHERE dl.doctor_id = d.id) AS langs,
	(SELECT GROUP_CONCAT(s.name ORDER BY s.name) FROM doctor_specialties ds JOIN specialties s ON s.id = ds.specialty_id WHERE ds.doctor_id = d.id) AS specs,
	(SELECT COUNT(*) FROM doctor_clinics dc WHERE dc.doctor_id = d.id AND dc.clinic_id = @c) AS in_clinic
FROM doctors d WHERE d.id = @d;

-- Ожидается 2 строки, у каждой 1 врач:
--   clear-aligner-therapy                 1200.00 / 2400.00
--   orthodontic-removable-plate-appliance 1000.00 / NULL
SELECT ms.slug, cms.price, cms.price_max,
	(SELECT COUNT(*) FROM clinic_medical_service_doctors x WHERE x.clinic_id = @c AND x.medical_service_id = ms.id) AS doctors
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @c AND cms.medical_service_id IN (@ms_aligners, @ms_expander)
ORDER BY ms.slug;
