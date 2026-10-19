-- ═══════════════════════════════════════════════════════════════════════════
-- VRMAC Health & Wellbeing Retreat de’MAR (Hyatt Regency Kotor Bay, Kotor) — клиника + врач и физиотерапевты
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-vrmac-health-wellbeing-retreat-kotor.sql
-- Затем: server/sql/insert-clinic-vrmac-health-wellbeing-retreat-kotor-services.sql
-- Запись импорта: data/clinic-imports/vrmac-health-wellbeing-retreat-kotor.json. Подволна 2d, агент T.
-- 
-- Источники (собрано 2026-10-09, сырой HTML curl с браузерным UA):
--   * https://vrmacwellbeing.com/ — WordPress + Elementor, en и /me/ (wp-json pages modified 2026-06-10…2026-06-30):
--     /about-us/, /medical-services/, /physical-therapy/, /manual-therapy/, /beauty-treatments/ (+8 подстраниц),
--     /health-wellbeing-programs/ (+6 программ с ценами), /contact/, /faqs/, /philosophy/. Часов работы нет.
--   * data/google-places/tivat/health-wellbeing-retreat-de-mar-vrmac.json — place_id, координаты 42.4646493 / 18.7329959,
--     телефон +382 69 113 222, «FP7M+V55, Jadranska magistrala, Prčanj» (Google не перезапрашивался, 3 отзыва — не импортируются).
-- 
-- Город: сайт «Hyatt Regency Kotor Bay Resort, Donji Stoliv bb, Kotor», Google — Prčanj. Оба — община Котор → city_id 6.
-- Почтовый индекс не заполнен: ни сайт, ни Google его не дают.
-- Логотип: VRMAC-LOGO.svg (тёмный), logo-Vrmac-wh.svg — белый (fill #ffffff), на светлом фоне не виден.
-- 
-- Идемпотентно и самоисправляюще: клиника ищется по google_place_id → slug → name_sr; пустые поля дозаполняются,
-- описания клиники и новых физиотерапевтов пишутся безусловно — правки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJAQAAZAo0TBMRgstKSiF85iY';
SET @clinic_slug = 'vrmac-health-wellbeing-retreat-kotor';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('VRMAC Health & Wellbeing Retreat de’MAR', 'Health & Wellbeing Retreat de ‘Mar - Vrmac', 'Vrmac Health & Wellbeing Retreat') AND city_id = 6 LIMIT 1));

INSERT INTO clinics (
	slug, google_place_id, status, city_id,
	name_sr, name_sr_cyrl, name_ru,
	address_sr, address_sr_cyrl, town_sr, town_sr_cyrl, postal_code,
	latitude, longitude,
	phone, email, website, facebook, instagram, telegram, whatsapp, viber,
	logo_url, created_at
)
SELECT
	@clinic_slug,
	@google_place_id,
	'published',
	6, -- CityId.KOTOR (Donji Stoliv / Prčanj — opština Kotor, файл места лежит в папке tivat)
	'VRMAC Health & Wellbeing Retreat de’MAR',
	'VRMAC Health & Wellbeing Retreat de’MAR',
	'VRMAC Health & Wellbeing Retreat de’MAR',
	'Hyatt Regency Kotor Bay Resort, Donji Stoliv bb',
	'Hyatt Regency Kotor Bay Resort, Доњи Столив бб',
	'Donji Stoliv',
	'Доњи Столив',
	'',
	42.46464930,
	18.73299590,
	'+38269113222',
	'vrmac.kotorregency@hyatt.com',
	'https://vrmacwellbeing.com/',
	'facebook.com/profile.php?id=100076239241728',
	'@vrmac.wellbeing',
	'',
	'+38269113222',
	'',
	'https://vrmacwellbeing.com/wp-content/uploads/2026/06/VRMAC-LOGO.svg',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.46464930, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 18.73299590, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'VRMAC Health & Wellbeing Retreat de’MAR', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'VRMAC Health & Wellbeing Retreat de’MAR', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Hyatt Regency Kotor Bay Resort, Donji Stoliv bb', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Hyatt Regency Kotor Bay Resort, Доњи Столив бб', address_sr_cyrl),
	town_sr = IF(town_sr IS NULL OR town_sr = '', 'Donji Stoliv', town_sr),
	town_sr_cyrl = IF(town_sr_cyrl IS NULL OR town_sr_cyrl = '', 'Доњи Столив', town_sr_cyrl),
	phone = IF(phone IS NULL OR phone = '', '+38269113222', phone),
	email = IF(email IS NULL OR email = '', 'vrmac.kotorregency@hyatt.com', email),
	website = IF(website IS NULL OR website = '', 'https://vrmacwellbeing.com/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/profile.php?id=100076239241728', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@vrmac.wellbeing', instagram),
	whatsapp = IF(whatsapp IS NULL OR whatsapp = '', '+38269113222', whatsapp),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://vrmacwellbeing.com/wp-content/uploads/2026/06/VRMAC-LOGO.svg', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Zdravstveni i wellness retreat u sklopu hotela Hyatt Regency Kotor Bay Resort (Donji Stoliv bb, Kotor), na obali Bokokotorskog zaliva u podnožju Vrmca. Svi zdravstveni i wellness programi počinju medicinskom procjenom, na osnovu koje se program prilagođava gostu. Glavni doktor je dr Marina Delić, specijalista fizikalne medicine i rehabilitacije sa subspecijalizacijom iz pulmologije, dugogodišnja medicinska direktorka i v. d. izvršne direktorke Instituta „Dr Simo Milošević“ u Igalu; u timu su i fizioterapeuti. Medicinske usluge: specijalistički i kontrolni pregled, pregled fizioterapeuta, BIA analiza sastava tijela, EKG, testovi plućne funkcije (spirometrija, bronhodilatatorni test, bodipletizmografija, difuzijski kapacitet), intramuskularne injekcije, infuzije sa lijekom, vitaminske i imuno infuzije, intervencije poput njege rana i inhalacije sa lijekom. Fizikalna terapija: individualna i grupna (do 6 osoba) kineziterapija, hidrokineziterapija, elektroterapija, ultrazvučna terapija, magnetoterapija, HILT laser visokog intenziteta, terapija udarnim talasima, TECAR i HIFEM terapija. Manuelna terapija: manuelni tretmani, CuMan (vakuum čašice i manuelna terapija), refleksologija stopala, manuelna i aparaturna limfna drenaža, vibro masaža, podvodna masaža tušem, kupke, biljne obloge, kinezio taping i dry needling. Estetski tretmani: botoks, hijaluronski fileri, Profhilo, terapija egzozomima, mezoterapija, Dermapen mikroiglični tretman, Emface i tretmani lica. Višednevni programi — Longevity Living, Pure Breath Experience, Inner Light Reset, Deep Calm Escape i Core Vitality (od 5 dana, od 550 €) te Managers Retreat (od 2 dana, 110 € dnevno) — uključuju početni i završni ljekarski pregled; cijene ne obuhvataju smještaj, a za neke programe obavezan je paket sa polupansionom u hotelu.',
	description_sr_cyrl = 'Здравствени и wеллнесс ретреат у склопу хотела Hyatt Regency Kotor Bay Resort (Доњи Столив бб, Котор), на обали Бококоторског залива у подножју Врмца. Сви здравствени и wеллнесс програми почињу медицинском процјеном, на основу које се програм прилагођава госту. Главни доктор је др Марина Делић, специјалиста физикалне медицине и рехабилитације са субспецијализацијом из пулмологије, дугогодишња медицинска директорка и в. д. извршне директорке Института „Др Симо Милошевић“ у Игалу; у тиму су и физиотерапеути. Медицинске услуге: специјалистички и контролни преглед, преглед физиотерапеута, BIA анализа састава тијела, EKG, тестови плућне функције (спирометрија, бронходилататорни тест, бодиплетизмографија, дифузијски капацитет), интрамускуларне ињекције, инфузије са лијеком, витаминске и имуно инфузије, интервенције попут његе рана и инхалације са лијеком. Физикална терапија: индивидуална и групна (до 6 особа) кинезитерапија, хидрокинезитерапија, електротерапија, ултразвучна терапија, магнетотерапија, HILT ласер високог интензитета, терапија ударним таласима, TECAR и HIFEM терапија. Мануелна терапија: мануелни третмани, CuMan (вакуум чашице и мануелна терапија), рефлексологија стопала, мануелна и апаратурна лимфна дренажа, вибро масажа, подводна масажа тушем, купке, биљне облоге, кинезио тапинг и dry needling. Естетски третмани: ботокс, хијалуронски филери, Profhilo, терапија егзозомима, мезотерапија, Dermapen микроиглични третман, Emface и третмани лица. Вишедневни програми — Longevity Living, Pure Breath Experience, Inner Light Reset, Deep Calm Escape и Core Vitality (од 5 дана, од 550 €) те Managers Retreat (од 2 дана, 110 € дневно) — укључују почетни и завршни љекарски преглед; цијене не обухватају смјештај, а за неке програме обавезан је пакет са полупансионом у хотелу.',
	description_ru = 'Медицинский и wellness-ретрит при отеле Hyatt Regency Kotor Bay Resort (Donji Stoliv bb, Котор) на берегу Бока-Которского залива у подножия горы Врмац. Все программы начинаются с медицинской оценки, по итогам которой программа подбирается под гостя. Главный врач — доктор Марина Делич, специалист по физической медицине и реабилитации с субспециализацией по пульмонологии, многолетний медицинский директор и исполняющая обязанности исполнительного директора Института «Д-р Симо Милошевич» в Игало; в команде также физиотерапевты. Медицинские услуги: осмотр специалиста и контрольный осмотр, осмотр физиотерапевта, анализ состава тела BIA, ЭКГ, исследования функции лёгких (спирометрия, бронходилатационный тест, бодиплетизмография, диффузионная способность), внутримышечные инъекции, капельницы с лекарствами, витаминные и иммунные капельницы, процедуры вроде обработки ран, ингаляции с лекарствами. Физиотерапия: индивидуальная и групповая (до 6 человек) кинезиотерапия, гидрокинезиотерапия, электротерапия, ультразвуковая терапия, магнитотерапия, высокоинтенсивный лазер HILT, ударно-волновая терапия, TECAR и HIFEM. Мануальная терапия: мануальные процедуры, CuMan (банки и мануальная терапия), рефлексология стоп, ручной и аппаратный лимфодренаж, вибромассаж, подводный душ-массаж, ванны, травяные обёртывания, кинезиотейпирование и dry needling. Эстетические процедуры: ботокс, филлеры на основе гиалуроновой кислоты, Profhilo, терапия экзосомами, мезотерапия, микронидлинг Dermapen, Emface и уходовые процедуры для лица. Многодневные программы — Longevity Living, Pure Breath Experience, Inner Light Reset, Deep Calm Escape и Core Vitality (от 5 дней, от 550 €) и Managers Retreat (от 2 дней, 110 € в день) — включают первичный и итоговый осмотр врача; проживание в цену не входит, для некоторых программ обязателен пакет проживания с полупансионом в отеле.',
	description_en = 'A health and wellbeing retreat within the Hyatt Regency Kotor Bay Resort (Donji Stoliv bb, Kotor), on the shore of the Bay of Kotor at the foot of Mount Vrmac. All health and wellness programmes begin with a medical assessment used to tailor the programme to each guest. The head doctor is Dr Marina Delić, a specialist in physical medicine and rehabilitation with a subspecialisation in pulmonology and long-standing Medical Director and Acting Executive Director of the “Dr Simo Milošević” Institute in Igalo; the team also includes physiotherapists. Medical services: specialist and follow-up examinations, physiotherapist examination, BIA body composition analysis, ECG, lung function tests (spirometry, bronchodilator test, body plethysmography, diffusion capacity), intramuscular injections, infusions with medication, vitamin and immune infusions, interventions such as wound care, and medicated inhalations. Physical therapy: individual and group (up to 6 people) kinesiotherapy, hydrokinesiotherapy, electrotherapy, ultrasound therapy, magnetotherapy, HILT high-intensity laser, shockwave therapy, TECAR and HIFEM therapy. Manual therapy: manual treatments, CuMan (cupping and manual therapy), foot reflexology, manual and apparatus lymphatic drainage, vibration massage, underwater shower massage, baths, herbal wraps, kinesio taping and dry needling. Aesthetic treatments: Botox, hyaluronic acid fillers, Profhilo, exosome therapy, mesotherapy, Dermapen microneedling, Emface and facials. Multi-day programmes — Longevity Living, Pure Breath Experience, Inner Light Reset, Deep Calm Escape and Core Vitality (from 5 days, from €550) and Managers Retreat (from 2 days, €110 per day) — include initial and final medical check-ups; prices do not include accommodation, and some programmes must be booked with a half-board stay at the hotel.',
	description_de = 'Ein Gesundheits- und Wellbeing-Retreat im Hyatt Regency Kotor Bay Resort (Donji Stoliv bb, Kotor), am Ufer der Bucht von Kotor am Fuß des Vrmac. Alle Gesundheits- und Wellnessprogramme beginnen mit einer ärztlichen Untersuchung, auf deren Grundlage das Programm individuell angepasst wird. Leitende Ärztin ist Dr. Marina Delić, Fachärztin für physikalische Medizin und Rehabilitation mit Subspezialisierung in Pneumologie, langjährige medizinische Direktorin und kommissarische Geschäftsführerin des Instituts „Dr Simo Milošević“ in Igalo; zum Team gehören außerdem Physiotherapeuten. Medizinische Leistungen: fachärztliche Untersuchung und Kontrolluntersuchung, physiotherapeutische Untersuchung, BIA-Körperzusammensetzungsanalyse, EKG, Lungenfunktionstests (Spirometrie, Bronchodilatationstest, Bodyplethysmographie, Diffusionskapazität), intramuskuläre Injektionen, Infusionen mit Medikamenten, Vitamin- und Immuninfusionen, Eingriffe wie Wundversorgung sowie Inhalationen mit Medikamenten. Physiotherapie: Einzel- und Gruppen-Bewegungstherapie (bis 6 Personen), Bewegungstherapie im Wasser, Elektrotherapie, Ultraschalltherapie, Magnetfeldtherapie, HILT-Hochleistungslaser, Stoßwellentherapie, TECAR- und HIFEM-Therapie. Manuelle Therapie: manuelle Behandlungen, CuMan (Schröpfen und manuelle Therapie), Fußreflexzonenmassage, manuelle und apparative Lymphdrainage, Vibrationsmassage, Unterwasserdruckstrahlmassage, Bäder, Kräuterpackungen, Kinesio-Taping und Dry Needling. Ästhetische Behandlungen: Botox, Hyaluronsäure-Filler, Profhilo, Exosomen-Therapie, Mesotherapie, Dermapen-Microneedling, Emface und Gesichtsbehandlungen. Mehrtägige Programme — Longevity Living, Pure Breath Experience, Inner Light Reset, Deep Calm Escape und Core Vitality (ab 5 Tagen, ab 550 €) sowie Managers Retreat (ab 2 Tagen, 110 € pro Tag) — umfassen eine ärztliche Eingangs- und Abschlussuntersuchung; die Preise enthalten keine Unterkunft, einige Programme sind nur mit einem Halbpensionsaufenthalt im Hotel buchbar.',
	description_tr = 'Kotor Körfezi kıyısında, Vrmac Dağı''nın eteğinde, Hyatt Regency Kotor Bay Resort (Donji Stoliv bb, Kotor) bünyesindeki sağlık ve iyi yaşam merkezi. Tüm sağlık ve wellness programları, programın misafire göre uyarlandığı tıbbi değerlendirmeyle başlar. Başhekim, fiziksel tıp ve rehabilitasyon uzmanı, göğüs hastalıkları yan dal uzmanı ve Igalo''daki “Dr Simo Milošević” Enstitüsü''nün uzun yıllar tıbbi direktörü ve vekil genel müdürü olan Dr. Marina Delić''tir; ekipte fizyoterapistler de bulunur. Tıbbi hizmetler: uzman ve kontrol muayenesi, fizyoterapist muayenesi, BIA vücut kompozisyonu analizi, EKG, solunum fonksiyon testleri (spirometri, bronkodilatör testi, vücut pletismografisi, difüzyon kapasitesi), kas içi enjeksiyonlar, ilaçlı serum, vitamin ve bağışıklık serumları, yara bakımı gibi müdahaleler ve ilaçlı inhalasyon. Fizik tedavi: bireysel ve grup (6 kişiye kadar) kinezyoterapi, hidrokinezyoterapi, elektroterapi, ultrason tedavisi, manyetoterapi, HILT yüksek yoğunluklu lazer, şok dalga tedavisi, TECAR ve HIFEM tedavisi. Manuel terapi: manuel uygulamalar, CuMan (kupa ve manuel terapi), ayak refleksolojisi, manuel ve cihazla lenf drenajı, vibrasyon masajı, su altı duş masajı, banyolar, bitkisel sargılar, kinezyo bantlama ve dry needling. Estetik uygulamalar: botoks, hyaluronik asit dolgular, Profhilo, eksozom tedavisi, mezoterapi, Dermapen mikro iğneleme, Emface ve yüz bakımları. Çok günlük programlar — Longevity Living, Pure Breath Experience, Inner Light Reset, Deep Calm Escape ve Core Vitality (5 günden itibaren, 550 €''dan başlayan fiyatlarla) ile Managers Retreat (2 günden itibaren, günlük 110 €) — ilk ve son doktor muayenesini içerir; fiyatlara konaklama dahil değildir, bazı programlar yalnızca otelde yarım pansiyon konaklamayla birlikte rezerve edilebilir.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- PHYSIOTHERAPY_CLINIC = 24 (физиатр + физиотерапевты, физио- и мануальная терапия) + AESTHETIC_CLINIC = 14 (раздел Beauty Treatments: ботокс, филлеры, Profhilo, мезотерапия).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 24), (@clinic_id, 14);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт двуязычный (en / me), но приём на других языках прямо не заявлен → только SR (1), правило юзера.
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы НЕ заполняются: на сайте их нет (только форма запроса и контакты).

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (4)
-- ═══════════════════════════════════════════════════════════════
-- Источник: https://vrmacwellbeing.com/about-us/ (+ /me/o-nama/). Фото команды на сайте нет (doctor-vertical.jpg — декоративное, без подписи).
-- НЕ заводятся: Ivana Bošković («Wellness & Spa Expert»), Marija Lučić («Aesthetician & Massage Therapist») — решение юзера.
-- Физиотерапевты — 94 = PHYSIOTHERAPY, professional_title NULL. Языки: 1 = SR (другие не заявлены).

-- ───────────────────────────────────────────────────────────────
-- Dr. Marina Delić — «Head Doctor … specialist in Physical Medicine and Rehabilitation with subspecialisation in Pulmonology», бывший мед. директор Instituta «Dr Simo Milošević».
-- НАЙДЕНА в БД: marina-delic (локаль и прод id 1025, специальности 14,42, без клиник, фото /uploads/…, био sr об Igalo) — тот же человек.
-- Карточку не перезаписываем: ни фото, ни описание не трогаем (INSERT не сработает), только привязка к клинике.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Marina Delić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Delić Marina' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'marina-delic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marina-delic', 'Marina Delić', 'Марина Делић', 'Марина Делич', 'Marina Delic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Описание существующей карточки не трогаем (оно уже есть, sr).

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 42), (@doctor_id, 14);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Glavni doktor')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Jovana Vuković — «Physiotherapist». Новая (локаль, прод-API 204).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Jovana Vuković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vuković Jovana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'jovana-vukovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jovana-vukovic', 'Jovana Vuković', 'Јована Вуковић', 'Йована Вукович', 'Jovana Vukovic', NULL,
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Fizioterapeut. Radi na individualno prilagođenoj terapiji usmjerenoj na rezultate — oporavak, ublažavanje bola i poboljšanje fizičke funkcije — primjenjujući različite terapijske tehnike.',
	description_sr_cyrl = 'Физиотерапеут. Ради на индивидуално прилагођеној терапији усмјереној на резултате — опоравак, ублажавање бола и побољшање физичке функције — примјењујући различите терапијске технике.',
	description_ru = 'Физиотерапевт. Проводит индивидуально подобранную терапию, нацеленную на восстановление, облегчение боли и улучшение физических функций, используя различные терапевтические техники.',
	description_en = 'A physiotherapist providing personalised, results-driven care that supports recovery, pain relief and improved physical function through a range of therapeutic techniques.',
	description_de = 'Physiotherapeutin. Sie bietet individuell abgestimmte, ergebnisorientierte Behandlungen zur Genesung, Schmerzlinderung und Verbesserung der körperlichen Funktion mit verschiedenen therapeutischen Techniken.',
	description_tr = 'Fizyoterapist. Çeşitli terapötik tekniklerle iyileşmeyi, ağrının giderilmesini ve fiziksel fonksiyonun gelişmesini destekleyen, kişiye özel ve sonuç odaklı tedavi uygular.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Fizioterapeut')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Fedis Kardović — «Physiotherapist». Новый (локаль, прод-API 204).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Fedis Kardović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Kardović Fedis' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'fedis-kardovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'fedis-kardovic', 'Fedis Kardović', 'Федис Кардовић', 'Федис Кардович', 'Fedis Kardovic', NULL,
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Fizioterapeut sa iskustvom u rehabilitaciji, sportskoj medicini i terapiji pokretom. Iskustvo je stekao i u profesionalnom sportu i u međunarodnom zdravstvu.',
	description_sr_cyrl = 'Физиотерапеут са искуством у рехабилитацији, спортској медицини и терапији покретом. Искуство је стекао и у професионалном спорту и у међународном здравству.',
	description_ru = 'Физиотерапевт с опытом в реабилитации, спортивной медицине и терапии движением. Работал в профессиональном спорте и в международном здравоохранении.',
	description_en = 'A physiotherapist with expertise in rehabilitation, sports medicine and movement therapy, with a background in professional sports and international healthcare.',
	description_de = 'Physiotherapeut mit Erfahrung in Rehabilitation, Sportmedizin und Bewegungstherapie sowie Hintergrund im Profisport und im internationalen Gesundheitswesen.',
	description_tr = 'Rehabilitasyon, spor hekimliği ve hareket terapisi alanında deneyimli fizyoterapist, profesyonel spor ve uluslararası sağlık hizmetleri geçmişine sahiptir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Fizioterapeut')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dragana Gudelj — «Physiotherapist … over five years of experience at VRMAC». Новая (локаль, прод-API 204).
-- Похожие в БД: dragica-gudelj и dragica-gudelj-brezovik (Dragica, интернист/пульмолог) — другие люди.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Dragana Gudelj' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Gudelj Dragana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'dragana-gudelj' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dragana-gudelj', 'Dragana Gudelj', 'Драгана Гудељ', 'Драгана Гудель', 'Dragana Gudelj', NULL,
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Fizioterapeut sa više od pet godina iskustva u VRMAC Health & Wellbeing Retreat de’MAR. Individualnim pristupom radi na poboljšanju fizičkog zdravlja, pokretljivosti i opšteg blagostanja.',
	description_sr_cyrl = 'Физиотерапеут са више од пет година искуства у VRMAC Health & Wellbeing Retreat de’MAR. Индивидуалним приступом ради на побољшању физичког здравља, покретљивости и општег благостања.',
	description_ru = 'Физиотерапевт, более пяти лет работает в VRMAC Health & Wellbeing Retreat de’MAR. Благодаря индивидуальному подходу помогает улучшить физическое здоровье, подвижность и общее самочувствие.',
	description_en = 'A physiotherapist with over five years of experience at VRMAC Health & Wellbeing Retreat de’MAR, improving physical health, mobility and overall well-being through an individualised approach.',
	description_de = 'Physiotherapeutin mit mehr als fünf Jahren Erfahrung im VRMAC Health & Wellbeing Retreat de’MAR, die mit individuellem Ansatz körperliche Gesundheit, Beweglichkeit und Wohlbefinden verbessert.',
	description_tr = 'VRMAC Health & Wellbeing Retreat de’MAR''da beş yılı aşkın deneyime sahip fizyoterapist; bireysel yaklaşımla fiziksel sağlığı, hareketliliği ve genel iyi oluşu geliştirmeye çalışır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Fizioterapeut')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 6, status = published, clinic_languages = '1', clinic_types = '24,14', hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 4: marina-delic (42,14), jovana-vukovic (94), fedis-kardovic (94), dragana-gudelj (94).
-- Если created_at нового врача старше даты прогона — запись уже была: проверить, тот ли человек.
SELECT d.id, d.slug, d.name_sr, d.professional_title,
	GROUP_CONCAT(DISTINCT ds.specialty_id ORDER BY ds.specialty_id) AS specialties,
	GROUP_CONCAT(DISTINCT dl.language_id ORDER BY dl.language_id) AS languages,
	IF(d.photo_url IS NULL OR d.photo_url = '', 'NO PHOTO', 'ok') AS photo,
	d.created_at
FROM doctors d
JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
LEFT JOIN doctor_languages dl ON dl.doctor_id = d.id
GROUP BY d.id
ORDER BY d.name_sr;
