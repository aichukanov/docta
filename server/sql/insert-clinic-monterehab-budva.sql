-- ═══════════════════════════════════════════════════════════════════════════
-- MonteRehab (Blizikuće, Sveti Stefan — Budva) — клиника
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-monterehab-budva.sql
-- Затем: server/sql/insert-clinic-monterehab-budva-services.sql
-- Запись импорта: data/clinic-imports/monterehab-budva.json. Подволна 2e, агент M (клиники со спорным профилем, одобрены юзером 2026-10-09).
-- 
-- Источники (собрано 2026-10-09, сырой HTML curl с браузерным UA):
--   * https://monterehab.com/ — Tilda; sitemap 175 URL (lastmod 2026-07-04 у всех), в основном SEO-лендинги по видам зависимостей (en/ru/me).
--     Читались: /, /ru, /home_me, /pricing, /cijene_me, /contacts, /kontakti_me, 13 страниц меню + /ru/eating-disorders, /alcohol_addiction, /drug_addiction,
--     /gambling_addiction, /opiate_addiction. Цены — 4 месячные программы на /pricing (= /cijene_me).
--   * data/google-places/budva/monterehab.json — place_id, координаты 42.2527278 / 18.9060491, +382 67 852 938, «Свети Стефан, Близикуће 85315» (Google не перезапрашивался).
-- 
-- Телефоны: сайт +382 69 621 111 (шапка, /contacts), Google и /ru: +382 67 852 938 → оба; WhatsApp и Viber — ссылки на оба номера (wa.me, viber://).
-- Telegram: t.me/RehabMontenegro (t.me/dmakarovskiy на главной — личный аккаунт без подписи, не заносим). Facebook/Instagram на сайте нет. Логотипа-картинки нет (текстовый) — logo_url пуст.
-- Персонал не назван нигде («Every member of our rehab team has at least 6 years of professional experience») → врачей не заводим (правило юзера).
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJH5qWtknXTRMRvbZK1sxa4XQ';
SET @clinic_slug = 'monterehab-budva';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('MonteRehab', 'Monte Rehab', 'Montenegro Rehab') AND city_id = 3 LIMIT 1));

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
	3, -- CityId.BUDVA (Sveti Stefan, Blizikuće — как dental-studio-przno-budva)
	'MonteRehab',
	'MonteRehab',
	'MonteRehab',
	'Blizikuće',
	'Близикуће',
	'Sveti Stefan',
	'Свети Стефан',
	'85315',
	42.25272780,
	18.90604910,
	'+38269621111;+38267852938',
	'montenegrorehab@gmail.com',
	'https://monterehab.com/',
	'',
	'',
	'@RehabMontenegro',
	'+38269621111;+38267852938',
	'+38269621111;+38267852938',
	'',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.25272780, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 18.90604910, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'MonteRehab', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'MonteRehab', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Blizikuće', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Близикуће', address_sr_cyrl),
	town_sr = IF(town_sr IS NULL OR town_sr = '', 'Sveti Stefan', town_sr),
	town_sr_cyrl = IF(town_sr_cyrl IS NULL OR town_sr_cyrl = '', 'Свети Стефан', town_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85315', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38269621111;+38267852938', phone),
	email = IF(email IS NULL OR email = '', 'montenegrorehab@gmail.com', email),
	website = IF(website IS NULL OR website = '', 'https://monterehab.com/', website),
	telegram = IF(telegram IS NULL OR telegram = '', '@RehabMontenegro', telegram),
	whatsapp = IF(whatsapp IS NULL OR whatsapp = '', '+38269621111;+38267852938', whatsapp),
	viber = IF(viber IS NULL OR viber = '', '+38269621111;+38267852938', viber)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'MonteRehab je rehabilitacioni centar za liječenje zavisnosti i mentalnih poremećaja u Blizikućama kod Svetog Stefana. Program stacionarnog liječenja (puni ciklus pod nadzorom tima terapeuta) uključuje svakodnevne individualne terapijske sesije, kompletan medicinski pregled pri prijemu i individualnu podršku kod pratećih oboljenja, grupne časove online i uživo za podršku oporavku i prevenciju recidiva, više od 8 sati psihoterapije dnevno i 4 sata porodične psihoterapije na poklon, kao i nedjeljne izlete brodom, ture po planinama i ekskurzije. Svaki član tima ima najmanje 6 godina profesionalnog iskustva. Centar se bavi liječenjem zavisnosti od alkohola i droga (heroin, metadon, kodein, tramadol, kokain, amfetamini, marihuana, hašiš, spice, ekstazi, LSD i dr.), medicinskom detoksikacijom pod nadzorom narkologa i terapeuta, liječenjem bihejvioralnih (bezhemijskih) zavisnosti — kockanja, video-igara, interneta, kupovine, seksualne i ljubavne zavisnosti — i dvojne dijagnoze, kao i liječenjem anksioznosti, depresije, sindroma sagorijevanja na poslu, nesanice, poremećaja raspoloženja, PTSP-a i traume, te poremećaja ishrane (anoreksija, bulimija). Cijene programa: Evrostandard — dvokrevetni smještaj 6.000 € mjesečno, jednokrevetni smještaj 9.000 € mjesečno; online program „Motivacija i oporavak“ 3.000 € mjesečno; „Resocijalizacija i obrazovanje“ 3.500 € mjesečno (smještaj na teritoriji centra ili samostalno u najbližem gradu, svakodnevne obavezne aktivnosti i sastanci sa mentorom, podrška u obrazovanju i zapošljavanju). Popust 10% pri uplati za tri ili više mjeseci.',
	description_sr_cyrl = 'MonteRehab је рехабилитациони центар за лијечење зависности и менталних поремећаја у Близикућама код Светог Стефана. Програм стационарног лијечења (пуни циклус под надзором тима терапеута) укључује свакодневне индивидуалне терапијске сесије, комплетан медицински преглед при пријему и индивидуалну подршку код пратећих обољења, групне часове онлине и уживо за подршку опоравку и превенцију рецидива, више од 8 сати психотерапије дневно и 4 сата породичне психотерапије на поклон, као и недјељне излете бродом, туре по планинама и екскурзије. Сваки члан тима има најмање 6 година професионалног искуства. Центар се бави лијечењем зависности од алкохола и дрога (хероин, метадон, кодеин, трамадол, кокаин, амфетамини, марихуана, хашиш, спице, екстази, ЛСД и др.), медицинском детоксикацијом под надзором нарколога и терапеута, лијечењем бихејвиоралних (безхемијских) зависности — коцкања, видео-игара, интернета, куповине, сексуалне и љубавне зависности — и двојне дијагнозе, као и лијечењем анксиозности, депресије, синдрома сагоријевања на послу, несанице, поремећаја расположења, ПТСП-а и трауме, те поремећаја исхране (анорексија, булимија). Цијене програма: Евростандард — двокреветни смјештај 6.000 € мјесечно, једнокреветни смјештај 9.000 € мјесечно; онлине програм „Мотивација и опоравак“ 3.000 € мјесечно; „Ресоцијализација и образовање“ 3.500 € мјесечно (смјештај на територији центра или самостално у најближем граду, свакодневне обавезне активности и састанци са ментором, подршка у образовању и запошљавању). Попуст 10% при уплати за три или више мјесеци.',
	description_ru = 'MonteRehab — реабилитационный центр лечения зависимостей и психических расстройств в Близикуче у Свети-Стефана. Программа стационарного лечения (полный цикл под наблюдением команды терапевтов) включает ежедневные индивидуальные терапевтические сессии, полное медицинское обследование при поступлении и индивидуальную поддержку при сопутствующих заболеваниях, групповые занятия онлайн и офлайн для поддержки выздоровления и профилактики срывов, более 8 часов психотерапии в день и 4 часа семейной психотерапии в подарок, а также еженедельные морские прогулки, горные туры и экскурсии. Каждый член команды имеет не менее 6 лет профессионального опыта. Центр лечит алкогольную и наркотическую зависимость (героин, метадон, кодеин, трамадол, кокаин, амфетамины, марихуана, гашиш, спайс, экстази, ЛСД и др.), проводит медицинскую детоксикацию под наблюдением наркологов и терапевтов, лечит нехимические (поведенческие) зависимости — игровую, от видеоигр, интернета, шопоголизм, сексуальную и любовную зависимость — и двойной диагноз, а также тревожность, депрессию, эмоциональное выгорание, бессонницу, расстройства настроения, ПТСР и травму, расстройства пищевого поведения (анорексия, булимия). Стоимость программ: «Евростандарт» — двухместное размещение 6000 € в месяц, одноместное 9000 € в месяц; онлайн-программа «Мотивация и восстановление» — 3000 € в месяц; «Ресоциализация и образование» — 3500 € в месяц (проживание на территории центра или самостоятельно в ближайшем городе, ежедневное посещение обязательных мероприятий и встречи с куратором, поддержка в обучении и трудоустройстве). Скидка 10% при оплате за три месяца и более.',
	description_en = 'MonteRehab is a rehabilitation centre for the treatment of addiction and mental health disorders in Blizikuće near Sveti Stefan. The full-cycle residential programme, under the supervision of a team of therapists, includes daily one-to-one therapy sessions, a full medical examination on admission and individual support for comorbidities, online and offline group classes to support recovery and prevent relapse, more than 8 hours of psychotherapy daily and 4 hours of family psychotherapy as a gift, plus weekly boat trips, mountain tours and excursions. Every member of the team has at least 6 years of professional experience. The centre treats alcohol and drug addiction (heroin, methadone, codeine, tramadol, cocaine, amphetamines, marijuana, hashish, Spice, ecstasy, LSD and others), provides medical detox supervised by narcologists and therapists, and treats behavioural (non-chemical) addictions — gambling, gaming, internet, shopping, sex and love addiction — and dual diagnosis, as well as anxiety, depression, executive burnout, insomnia, mood disorders, PTSD and trauma, and eating disorders (anorexia, bulimia). Programme prices: Eurostandard — double occupancy €6,000 per month, single occupancy €9,000 per month; online programme “Motivation and Recovery” €3,000 per month; “Resocialization and education” €3,500 per month (accommodation at the centre or independently in the nearest town, daily attendance at compulsory activities and meetings with a curator, support with education and employment). 10% discount when paying for three months or more.',
	description_de = 'MonteRehab ist ein Rehabilitationszentrum für die Behandlung von Abhängigkeiten und psychischen Störungen in Blizikuće bei Sveti Stefan. Das stationäre Programm (voller Zyklus unter Aufsicht eines Therapeutenteams) umfasst tägliche Einzeltherapiesitzungen, eine vollständige ärztliche Untersuchung bei der Aufnahme und individuelle Unterstützung bei Begleiterkrankungen, Gruppenstunden online und vor Ort zur Unterstützung der Genesung und Rückfallprävention, mehr als 8 Stunden Psychotherapie täglich und 4 Stunden Familienpsychotherapie als Geschenk sowie wöchentliche Bootsausflüge, Bergtouren und Exkursionen. Jedes Teammitglied hat mindestens 6 Jahre Berufserfahrung. Das Zentrum behandelt Alkohol- und Drogenabhängigkeit (Heroin, Methadon, Codein, Tramadol, Kokain, Amphetamine, Marihuana, Haschisch, Spice, Ecstasy, LSD u. a.), bietet medizinische Entgiftung unter Aufsicht von Suchtmedizinern und Therapeuten und behandelt Verhaltenssüchte (nicht stoffgebundene Süchte) — Glücksspiel, Videospiele, Internet, Kaufsucht, Sex- und Liebessucht — sowie Doppeldiagnosen, außerdem Angst, Depression, Burnout bei Führungskräften, Schlaflosigkeit, affektive Störungen, PTBS und Traumata sowie Essstörungen (Anorexie, Bulimie). Programmpreise: Eurostandard — Doppelzimmer 6.000 € pro Monat, Einzelzimmer 9.000 € pro Monat; Online-Programm „Motivation und Genesung“ 3.000 € pro Monat; „Resozialisierung und Bildung“ 3.500 € pro Monat (Unterkunft auf dem Gelände des Zentrums oder selbstständig in der nächstgelegenen Stadt, tägliche Teilnahme an Pflichtaktivitäten und Treffen mit einem Betreuer, Unterstützung bei Ausbildung und Beschäftigung). 10 % Rabatt bei Zahlung für drei Monate oder mehr.',
	description_tr = 'MonteRehab, Sveti Stefan yakınlarındaki Blizikuće''de bağımlılık ve ruh sağlığı bozukluklarının tedavisi için bir rehabilitasyon merkezidir. Terapist ekibinin gözetiminde tam döngülü yatılı program; günlük bireysel terapi seansları, kabulde tam tıbbi muayene ve eşlik eden hastalıklar için bireysel destek, iyileşmeyi desteklemek ve nüksü önlemek için online ve yüz yüze grup çalışmaları, günde 8 saatten fazla psikoterapi ve hediye olarak 4 saat aile psikoterapisi, ayrıca haftalık tekne gezileri, dağ turları ve geziler içerir. Ekibin her üyesinin en az 6 yıllık mesleki deneyimi vardır. Merkez alkol ve uyuşturucu bağımlılığını (eroin, metadon, kodein, tramadol, kokain, amfetaminler, esrar, haşiş, Spice, ekstazi, LSD vb.) tedavi eder, bağımlılık uzmanları ve terapistler gözetiminde tıbbi detoks uygular; davranışsal (kimyasal olmayan) bağımlılıkları — kumar, video oyunu, internet, alışveriş, seks ve aşk bağımlılığı — ve ikili tanıyı, ayrıca anksiyete, depresyon, yönetici tükenmişliği, uykusuzluk, duygudurum bozuklukları, TSSB ve travma ile yeme bozukluklarını (anoreksiya, bulimiya) tedavi eder. Program fiyatları: Eurostandard — çift kişilik konaklama aylık 6.000 €, tek kişilik konaklama aylık 9.000 €; online program “Motivasyon ve İyileşme” aylık 3.000 €; “Yeniden sosyalleşme ve eğitim” aylık 3.500 € (merkezde veya en yakın şehirde bağımsız konaklama, zorunlu etkinliklere ve danışmanla görüşmelere günlük katılım, eğitim ve istihdam desteği). Üç ay veya daha uzun süre için ödemede %10 indirim.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- PSYCHIATRIC_CLINIC = 15 (schema.org сайта: medicalSpecialty «Psychiatry»). REHABILITATION_CENTER = 13 не ставим: в enum он размечен как Physiotherapy (schema) и предназначен для физической реабилитации.
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 15);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт на en/ru/me, но приём на других языках прямо не заявлен (сотрудники не названы) → только SR (1), правило юзера.
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы НЕ заполняются: на сайте их нет (стационар; только телефоны и форма).

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (0)
-- ═══════════════════════════════════════════════════════════════
-- Имён персонала на сайте нет — врачей не заводим.

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 3, status = published, clinic_languages = '1', clinic_types = '15', hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 0: .
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
