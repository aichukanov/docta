-- ═══════════════════════════════════════════════════════════════════════════
-- Fizio Tim (Podgorica) — клиника + физиотерапевты
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-fizio-tim-podgorica.sql
-- Затем: server/sql/insert-clinic-fizio-tim-podgorica-services.sql
-- Запись импорта: data/clinic-imports/fizio-tim-podgorica.json. Подволна 2d, агент U.
-- 
-- Источники (собрано 2026-10-09):
--   * https://fiziotim.me/ — WordPress; тексты через wp-json (/wp-json/wp/v2/pages, /posts) + сырой HTML /nas-tim.
--     Страницы услуг (10) — modified 2024-02-04; главная и /kontakt — 2026-03-18. Посты 2020–2024 — старые копии тех же текстов.
--     Цен нет нигде. Часов работы нет.
--   * data/google-places/podgorica/fizio-tim-crna-gora.json — place_id, координаты 42.4291526 / 19.2608058,
--     +382 67 758 000, «7 4. Jul, Podgorica 81000» (Google не перезапрашивался; 42 отзыва).
-- 
-- Адрес: /kontakt и главная «Ulica 4. Jula br. 7» (= Google). На /o-nama (2024-02) старый «4. Jula 56-A (zgrada EUROPACTA)» — не взят.
-- Название: Google «FIZIO TIM CRNA GORA», юрлицо «PZU FIZIO TIM» → name_sr «Fizio Tim» (как Fizio PG).
-- Индекс 81000 — Podgorica. Соцсети — ссылки шапки сайта.
-- 
-- Идемпотентно и самоисправляюще: клиника ищется по google_place_id → slug → name_sr; пустые поля дозаполняются,
-- описание клиники пишется безусловно — правки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJhRgbph3rTRMR6FfMAsrhluk';
SET @clinic_slug = 'fizio-tim-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Fizio Tim', 'FIZIO TIM CRNA GORA', 'Fizio Tim Crna Gora', 'PZU Fizio Tim', 'Fiziotim') AND city_id = 1 LIMIT 1));

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
	1, -- CityId.PODGORICA
	'Fizio Tim',
	'Физио Тим',
	'Физио Тим',
	'4. jula 7',
	'4. јула 7',
	'',
	'',
	'81000',
	42.42915260,
	19.26080580,
	'+38267758000',
	'fiziotim.me@gmail.com',
	'https://fiziotim.me/',
	'facebook.com/fiziotimcrnagora',
	'instagram.com/fiziotim.crnagora',
	'',
	'',
	'',
	'https://fiziotim.me/wp-content/uploads/2024/01/cropped-logosquarefiziotim.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.42915260, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.26080580, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Физио Тим', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Физио Тим', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', '4. jula 7', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', '4. јула 7', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38267758000', phone),
	email = IF(email IS NULL OR email = '', 'fiziotim.me@gmail.com', email),
	website = IF(website IS NULL OR website = '', 'https://fiziotim.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/fiziotimcrnagora', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', 'instagram.com/fiziotim.crnagora', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://fiziotim.me/wp-content/uploads/2024/01/cropped-logosquarefiziotim.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'PZU Fizio Tim je privatna zdravstvena ustanova za fizikalnu terapiju primarnog nivoa u Podgorici, u ulici 4. jula br. 7, koju su osnovali sportski fizioterapeuti. Uža specijalnost ustanove je rehabilitacija sportskih povreda: fizioterapeuti tima bili su dio medicinskih timova nacionalnih reprezentacija na evropskim i svjetskim prvenstvima i Olimpijskim igrama i radili u brojnim sportskim klubovima. Tim čine specijalisti primijenjene fizioterapije Srđan Kojić i Alen Pepić, a ustanova sarađuje sa specijalistima radiologije, fizikalne medicine i ortopedije. Moguće je zakazati pregled specijaliste fizijatra ili specijaliste primijenjene fizioterapije, dijagnostički mišićno-skeletni ultrazvuk, tretman akutnih povreda i sindroma prenaprezanja, preoperativnu pripremu i postoperativni oporavak nakon operacija koljena i ramena. Od terapija su dostupni INDIBA-Tecar, shockwave, HILT laser, elektroterapija, terapijski ultrazvuk, magnetoterapija, laseroterapija, elektromišićna stimulacija (Compex), limfna drenaža po metodi Vodder, cupping masaža, terapija toplotom, dry needling, medicinska akupunktura i elektroakupunktura, ERGON IASTM, kineziotejping, masaža, mobilizacije i manipulacije, kao i kineziterapija za djecu i odrasle, trudnice i porodilje, individualno ili grupno, uključujući programe Schroth, DNS i PNF.',
	description_sr_cyrl = 'ПЗУ Физио Тим је приватна здравствена установа за физикалну терапију примарног нивоа у Подгорици, у улици 4. јула бр. 7, коју су основали спортски физиотерапеути. Ужа специјалност установе је рехабилитација спортских повреда: физиотерапеути тима били су дио медицинских тимова националних репрезентација на европским и свјетским првенствима и Олимпијским играма и радили у бројним спортским клубовима. Тим чине специјалисти примијењене физиотерапије Срђан Којић и Ален Пепић, а установа сарађује са специјалистима радиологије, физикалне медицине и ортопедије. Могуће је заказати преглед специјалисте физијатра или специјалисте примијењене физиотерапије, дијагностички мишићно-скелетни ултразвук, третман акутних повреда и синдрома пренапрезања, преоперативну припрему и постоперативни опоравак након операција кољена и рамена. Од терапија су доступни INDIBA-Tecar, shockwave, HILT ласер, електротерапија, терапијски ултразвук, магнетотерапија, ласеротерапија, електромишићна стимулација (Compex), лимфна дренажа по методи Vodder, cupping масажа, терапија топлотом, dry needling, медицинска акупунктура и електроакупунктура, ERGON IASTM, кинезиотејпинг, масажа, мобилизације и манипулације, као и кинезитерапија за дјецу и одрасле, труднице и породиље, индивидуално или групно, укључујући програме Schroth, DNS и PNF.',
	description_ru = 'PZU Fizio Tim — частное медицинское учреждение первичного уровня по физиотерапии в Подгорице, на улице 4. jula, 7, основанное спортивными физиотерапевтами. Профиль учреждения — реабилитация после спортивных травм: физиотерапевты команды работали в медицинских штабах национальных сборных на чемпионатах Европы и мира и Олимпийских играх, а также во многих спортивных клубах. В команде — специалисты прикладной физиотерапии Срджан Коич и Ален Пепич; учреждение сотрудничает с рентгенологами, физиатрами и ортопедами. Можно записаться на осмотр физиатра или специалиста прикладной физиотерапии, диагностическое УЗИ опорно-двигательного аппарата, лечение острых травм и синдромов перегрузки, подготовку к операции и восстановление после операций на колене и плече. Из процедур доступны INDIBA-Tecar, ударно-волновая терапия, HILT-лазер, электротерапия, терапевтический ультразвук, магнитотерапия, лазеротерапия, электромиостимуляция (Compex), лимфодренаж по методу Воддера, баночный массаж, тепловая терапия, dry needling, медицинская акупунктура и электроакупунктура, ERGON IASTM, кинезиотейпирование, массаж, мобилизации и манипуляции, а также кинезитерапия для детей и взрослых, беременных и рожениц, индивидуально или в группе, включая программы Шрота, DNS и PNF.',
	description_en = 'PZU Fizio Tim is a private primary-care physiotherapy facility in Podgorica, at 4. jula 7, founded by sports physiotherapists. Its core speciality is sports injury rehabilitation: the team’s physiotherapists have been part of national teams’ medical staff at European and World Championships and the Olympic Games and have worked with many sports clubs. The team consists of applied physiotherapy specialists Srđan Kojić and Alen Pepić, and the facility works with specialists in radiology, physical medicine and orthopaedics. Patients can book an examination by a physiatrist or an applied physiotherapy specialist, diagnostic musculoskeletal ultrasound, treatment of acute injuries and overuse syndromes, pre-operative preparation and post-operative recovery after knee and shoulder surgery. Treatments include INDIBA-Tecar, shockwave, HILT laser, electrotherapy, therapeutic ultrasound, magnetic therapy, laser therapy, electrical muscle stimulation (Compex), Vodder lymphatic drainage, cupping massage, heat therapy, dry needling, medical acupuncture and electroacupuncture, ERGON IASTM, kinesio taping, massage, mobilisations and manipulations, and exercise therapy for children and adults, pregnant women and new mothers, individually or in groups, including the Schroth, DNS and PNF programmes.',
	description_de = 'PZU Fizio Tim ist eine private Einrichtung für Physiotherapie der Primärversorgung in Podgorica, 4. jula 7, gegründet von Sportphysiotherapeuten. Schwerpunkt ist die Rehabilitation von Sportverletzungen: Die Physiotherapeuten des Teams gehörten bei Europa- und Weltmeisterschaften und Olympischen Spielen zu den medizinischen Stäben von Nationalmannschaften und haben in zahlreichen Sportvereinen gearbeitet. Zum Team gehören die Fachphysiotherapeuten für angewandte Physiotherapie Srđan Kojić und Alen Pepić; die Einrichtung arbeitet mit Fachärzten für Radiologie, physikalische Medizin und Orthopädie zusammen. Gebucht werden können eine Untersuchung beim Facharzt für physikalische Medizin oder beim Fachphysiotherapeuten, diagnostischer muskuloskelettaler Ultraschall, die Behandlung akuter Verletzungen und Überlastungssyndrome sowie präoperative Vorbereitung und postoperative Rehabilitation nach Knie- und Schulteroperationen. Angeboten werden INDIBA-Tecar, Stoßwellentherapie, HILT-Laser, Elektrotherapie, therapeutischer Ultraschall, Magnetfeldtherapie, Lasertherapie, elektrische Muskelstimulation (Compex), Lymphdrainage nach Vodder, Schröpfmassage, Wärmetherapie, Dry Needling, medizinische Akupunktur und Elektroakupunktur, ERGON IASTM, Kinesio-Taping, Massage, Mobilisationen und Manipulationen sowie Bewegungstherapie für Kinder und Erwachsene, Schwangere und Wöchnerinnen, einzeln oder in der Gruppe, einschließlich der Programme Schroth, DNS und PNF.',
	description_tr = 'PZU Fizio Tim, Podgorica''da 4. jula 7 adresinde, spor fizyoterapistleri tarafından kurulmuş birinci basamak özel fizik tedavi kuruluşudur. Kurumun ana uzmanlık alanı spor yaralanmalarının rehabilitasyonudur: ekibin fizyoterapistleri Avrupa ve Dünya şampiyonaları ile Olimpiyat Oyunları''nda milli takımların sağlık ekiplerinde yer almış ve pek çok spor kulübünde çalışmıştır. Ekipte uygulamalı fizyoterapi uzmanları Srđan Kojić ve Alen Pepić bulunur; kurum radyoloji, fiziksel tıp ve ortopedi uzmanlarıyla iş birliği yapar. Fiziksel tıp uzmanı veya uygulamalı fizyoterapi uzmanı muayenesi, tanısal kas-iskelet ultrasonu, akut yaralanma ve aşırı kullanım sendromlarının tedavisi, diz ve omuz ameliyatları öncesi hazırlık ve sonrası iyileşme için randevu alınabilir. INDIBA-Tecar, şok dalga, HILT lazer, elektroterapi, terapötik ultrason, manyetoterapi, lazer tedavisi, elektrikli kas stimülasyonu (Compex), Vodder yöntemiyle lenf drenajı, kupa masajı, sıcak tedavisi, dry needling, tıbbi akupunktur ve elektroakupunktur, ERGON IASTM, kinezyo bantlama, masaj, mobilizasyon ve manipülasyonların yanı sıra çocuklar ve yetişkinler, hamileler ve yeni anneler için bireysel veya grup halinde, Schroth, DNS ve PNF programlarını da içeren egzersiz tedavisi sunulur.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- PHYSIOTHERAPY_CLINIC = 24: «privatna zdravstvena ustanova za fizikalnu terapiju primarnog nivoa».
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 24);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках → только SR (1).
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы на сайте не указаны (в файле Google их тоже нет) → clinic_working_hours не заполняется.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (2)
-- ═══════════════════════════════════════════════════════════════
-- Физиотерапевты — специальность 94 = PHYSIOTHERAPY, professional_title NULL (не врачи), как в physiocare-team-podgorica.
-- Источник: /nas-tim. Оба по био штатные в KCCG (odjeljenje fizikalne medicine i rehabilitacije), но в БД их нет ни у KCCG,
-- ни где-либо (локаль: Kojić/Pepić — только другие люди; прод-API 204) → новые; к KCCG не привязываем (на сайте KCCG не названы).
-- Имя: сайт «Srdjan Kojić» → name_sr «Srđan Kojić» (правильная диакритика; slug тот же srdjan-kojic).
-- Фото: /nas-tim — секция 763d258 = текст Kojić + 1-scaled…jpg, секция 2076755 = 2-…jpg + текст Pepić (200).
-- Языки: 1 = SR (другие не заявлены).

-- ───────────────────────────────────────────────────────────────
-- Srđan Kojić — /nas-tim «Srdjan Kojić — specijalista primijenjene fizioterapije».
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Srđan Kojić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Kojić Srđan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'srdjan-kojic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'srdjan-kojic', 'Srđan Kojić', 'Срђан Којић', 'Срджан Коич', 'Srdjan Kojic', NULL,
	'https://fiziotim.me/wp-content/uploads/elementor/thumbs/1-scaled-qj3wkoe1zcuqs07b3harpoi4xk8xdt9lkz1te1fmkg.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://fiziotim.me/wp-content/uploads/elementor/thumbs/1-scaled-qj3wkoe1zcuqs07b3harpoi4xk8xdt9lkz1te1fmkg.jpg', photo_url) WHERE id = @doctor_id;

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Specijalista primijenjene fizioterapije. Završio je srednju medicinsku školu, Višu fizioterapeutsku školu i Fakultet primijenjene fizioterapije, smjer sportska fizioterapija. Od 2002. zaposlen je u Kliničkom centru Crne Gore, na odjeljenju fizikalne medicine i rehabilitacije. Bio je fizioterapeut olimpijske i ženske rukometne reprezentacije (srebrna olimpijska i bronzana svjetska medalja), radio je u ŽRK Budućnost, OK Budvanska rivijera, FK Zeta i drugim klubovima, a saradnik je Crnogorskog paraolimpijskog komiteta. Posjeduje međunarodne sertifikate za ERGON IASTM, visceralne manipulacije, spinalne i periferne manipulacije, Yumeiho, kineziotejping, DNS, dry needling i elektroakupunkturu, suvi i vlažni cupping i kinetic flossing; sertifikovani je INDIBA-Tecar terapeut i prvi sertifikovani shockwave terapeut u Crnoj Gori. Predavač je na stručnim konferencijama i više puta je proglašavan za najboljeg sportskog fizioterapeuta. Najviše se bavi sportskim povredama, postoperativnom rehabilitacijom, povredama i sindromima prenaprezanja koljena, ramena, lakta i stopala, kao i ortopedskim i neurološkim pacijentima.',
	description_sr_cyrl = 'Специјалиста примијењене физиотерапије. Завршио је средњу медицинску школу, Вишу физиотерапеутску школу и Факултет примијењене физиотерапије, смјер спортска физиотерапија. Од 2002. запослен је у Клиничком центру Црне Горе, на одјељењу физикалне медицине и рехабилитације. Био је физиотерапеут олимпијске и женске рукометне репрезентације (сребрна олимпијска и бронзана свјетска медаља), радио је у ЖРК Будућност, ОК Будванска ривијера, ФК Зета и другим клубовима, а сарадник је Црногорског параолимпијског комитета. Посједује међународне сертификате за ERGON IASTM, висцералне манипулације, спиналне и периферне манипулације, Yumeiho, кинезиотејпинг, DNS, dry needling и електроакупунктуру, суви и влажни cupping и kinetic flossing; сертификовани је INDIBA-Tecar терапеут и први сертификовани shockwave терапеут у Црној Гори. Предавач је на стручним конференцијама и више пута је проглашаван за најбољег спортског физиотерапеута. Највише се бави спортским повредама, постоперативном рехабилитацијом, повредама и синдромима пренапрезања кољена, рамена, лакта и стопала, као и ортопедским и неуролошким пацијентима.',
	description_ru = 'Специалист прикладной физиотерапии. Окончил среднюю медицинскую школу, Высшую физиотерапевтическую школу и факультет прикладной физиотерапии по направлению «спортивная физиотерапия». С 2002 года работает в Клиническом центре Черногории, в отделении физической медицины и реабилитации. Был физиотерапевтом олимпийской и женской сборной по гандболу (серебро Олимпиады и бронза чемпионата мира), работал в ЖГК «Будучност», ВК «Будванская Ривьера», ФК «Зета» и других клубах, сотрудничает с Паралимпийским комитетом Черногории. Имеет международные сертификаты по ERGON IASTM, висцеральным манипуляциям, спинальным и периферическим манипуляциям, Yumeiho, кинезиотейпированию, DNS, dry needling и электроакупунктуре, сухому и влажному cupping и kinetic flossing; сертифицированный терапевт INDIBA-Tecar и первый сертифицированный специалист по ударно-волновой терапии в Черногории. Выступает на профессиональных конференциях, неоднократно признавался лучшим спортивным физиотерапевтом. Основные направления — спортивные травмы, послеоперационная реабилитация, травмы и синдромы перегрузки колена, плеча, локтя и стопы, ортопедические и неврологические пациенты.',
	description_en = 'Applied physiotherapy specialist. He completed secondary medical school, the Higher School of Physiotherapy and the Faculty of Applied Physiotherapy, majoring in sports physiotherapy. Since 2002 he has worked at the Clinical Centre of Montenegro, in the department of physical medicine and rehabilitation. He was physiotherapist of the Olympic and women’s national handball team (Olympic silver and World Championship bronze), worked with ŽRK Budućnost, OK Budvanska rivijera, FK Zeta and other clubs, and collaborates with the Montenegrin Paralympic Committee. He holds international certificates in ERGON IASTM, visceral manipulation, spinal and peripheral manipulation, Yumeiho, kinesio taping, DNS, dry needling and electroacupuncture, dry and wet cupping and kinetic flossing; he is a certified INDIBA-Tecar therapist and the first certified shockwave therapist in Montenegro. He lectures at professional conferences and has repeatedly been named best sports physiotherapist. His main focus is sports injuries, post-operative rehabilitation, injuries and overuse syndromes of the knee, shoulder, elbow and foot, and orthopaedic and neurological patients.',
	description_de = 'Fachphysiotherapeut für angewandte Physiotherapie. Er absolvierte die medizinische Fachoberschule, die Höhere Physiotherapieschule und die Fakultät für angewandte Physiotherapie, Fachrichtung Sportphysiotherapie. Seit 2002 arbeitet er im Klinischen Zentrum Montenegros in der Abteilung für physikalische Medizin und Rehabilitation. Er war Physiotherapeut der olympischen und der Frauen-Handballnationalmannschaft (olympisches Silber und WM-Bronze), arbeitete bei ŽRK Budućnost, OK Budvanska rivijera, FK Zeta und weiteren Vereinen und ist Mitarbeiter des Paralympischen Komitees Montenegros. Er besitzt internationale Zertifikate in ERGON IASTM, viszeraler Manipulation, spinaler und peripherer Manipulation, Yumeiho, Kinesio-Taping, DNS, Dry Needling und Elektroakupunktur, trockenem und nassem Schröpfen sowie Kinetic Flossing; er ist zertifizierter INDIBA-Tecar-Therapeut und der erste zertifizierte Stoßwellentherapeut Montenegros. Er referiert auf Fachkonferenzen und wurde mehrfach zum besten Sportphysiotherapeuten gewählt. Schwerpunkte sind Sportverletzungen, postoperative Rehabilitation, Verletzungen und Überlastungssyndrome von Knie, Schulter, Ellenbogen und Fuß sowie orthopädische und neurologische Patienten.',
	description_tr = 'Uygulamalı fizyoterapi uzmanı. Sağlık meslek lisesini, Fizyoterapi Yüksekokulu''nu ve Uygulamalı Fizyoterapi Fakültesi spor fizyoterapisi bölümünü bitirdi. 2002''den beri Karadağ Klinik Merkezi fiziksel tıp ve rehabilitasyon bölümünde çalışıyor. Olimpiyat ve kadın milli hentbol takımının fizyoterapistliğini yaptı (olimpiyat gümüş ve dünya bronz madalyası), ŽRK Budućnost, OK Budvanska rivijera, FK Zeta ve diğer kulüplerde çalıştı; Karadağ Paralimpik Komitesi ile iş birliği yapıyor. ERGON IASTM, visseral manipülasyon, spinal ve periferik manipülasyon, Yumeiho, kinezyo bantlama, DNS, dry needling ve elektroakupunktur, kuru ve yaş kupa ile kinetic flossing alanlarında uluslararası sertifikalara sahiptir; sertifikalı INDIBA-Tecar terapisti ve Karadağ''ın ilk sertifikalı şok dalga terapistidir. Mesleki konferanslarda konuşmacıdır ve birçok kez en iyi spor fizyoterapisti seçilmiştir. Başlıca alanları spor yaralanmaları, ameliyat sonrası rehabilitasyon, diz, omuz, dirsek ve ayak yaralanmaları ve aşırı kullanım sendromları ile ortopedik ve nörolojik hastalardır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista primijenjene fizioterapije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Alen Pepić — /nas-tim «Alen Pepić — specijalista primijenjene fizioterapije». Однофамильцы в БД (dzihad-pepic, jaho-pepic, sajma-pepic, biljana-jovovic-pepic) — другие люди.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Alen Pepić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Pepić Alen' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'alen-pepic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'alen-pepic', 'Alen Pepić', 'Ален Пепић', 'Ален Пепич', 'Alen Pepic', NULL,
	'https://fiziotim.me/wp-content/uploads/elementor/thumbs/2-qj3wklkjeuqvt6bejy2w077r5emtqpyekl3cy7jt34.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://fiziotim.me/wp-content/uploads/elementor/thumbs/2-qj3wklkjeuqvt6bejy2w077r5emtqpyekl3cy7jt34.jpg', photo_url) WHERE id = @doctor_id;

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Specijalista primijenjene fizioterapije. Završio je Višu fizioterapeutsku školu i Fakultet primijenjene fizioterapije, smjer sportska fizioterapija; stalno je zaposlen u Kliničkom centru Crne Gore, na odjeljenju fizikalne medicine i rehabilitacije. Bio je fizioterapeut muške i ženske seniorske rukometne reprezentacije, osvajač je olimpijske medalje i Kupa EHF i član olimpijskih selekcija na Igrama u Londonu, Rio de Žaneiru i Tokiju; iskustvo je sticao na brojnim evropskim, svjetskim i Mediteranskim prvenstvima i u sportskim kolektivima u inostranstvu. Posjeduje sertifikate za ERGON IASTM, dry needling i elektroakupunkturu, spinalne manipulacije, Yumeiho, visceralne manipulacije, kineziotejping, suvi i vlažni cupping i kinetic flossing; sertifikovani je INDIBA-Tecar terapeut i prvi shockwave praktičar u Crnoj Gori. Predavač je na domaćim i međunarodnim stručnim skupovima i više puta je proglašavan za najboljeg sportskog fizioterapeuta.',
	description_sr_cyrl = 'Специјалиста примијењене физиотерапије. Завршио је Вишу физиотерапеутску школу и Факултет примијењене физиотерапије, смјер спортска физиотерапија; стално је запослен у Клиничком центру Црне Горе, на одјељењу физикалне медицине и рехабилитације. Био је физиотерапеут мушке и женске сениорске рукометне репрезентације, освајач је олимпијске медаље и Купа EHF и члан олимпијских селекција на Играма у Лондону, Рио де Жанеиру и Токију; искуство је стицао на бројним европским, свјетским и Медитеранским првенствима и у спортским колективима у иностранству. Посједује сертификате за ERGON IASTM, dry needling и електроакупунктуру, спиналне манипулације, Yumeiho, висцералне манипулације, кинезиотејпинг, суви и влажни cupping и kinetic flossing; сертификовани је INDIBA-Tecar терапеут и први shockwave практичар у Црној Гори. Предавач је на домаћим и међународним стручним скуповима и више пута је проглашаван за најбољег спортског физиотерапеута.',
	description_ru = 'Специалист прикладной физиотерапии. Окончил Высшую физиотерапевтическую школу и факультет прикладной физиотерапии по направлению «спортивная физиотерапия»; работает в штате Клинического центра Черногории, в отделении физической медицины и реабилитации. Был физиотерапевтом мужской и женской сборных по гандболу, обладатель олимпийской медали и Кубка EHF, входил в олимпийские команды на Играх в Лондоне, Рио-де-Жанейро и Токио; опыт получил на многочисленных чемпионатах Европы, мира и Средиземноморских играх и в зарубежных клубах. Имеет сертификаты по ERGON IASTM, dry needling и электроакупунктуре, спинальным манипуляциям, Yumeiho, висцеральным манипуляциям, кинезиотейпированию, сухому и влажному cupping и kinetic flossing; сертифицированный терапевт INDIBA-Tecar и первый практик ударно-волновой терапии в Черногории. Выступает на отечественных и международных профессиональных конференциях, неоднократно признавался лучшим спортивным физиотерапевтом.',
	description_en = 'Applied physiotherapy specialist. He completed the Higher School of Physiotherapy and the Faculty of Applied Physiotherapy, majoring in sports physiotherapy, and is on the permanent staff of the Clinical Centre of Montenegro, in the department of physical medicine and rehabilitation. He was physiotherapist of the men’s and women’s senior national handball teams, is an Olympic medallist and EHF Cup winner, and was part of the Olympic squads in London, Rio de Janeiro and Tokyo; he gained experience at numerous European, World and Mediterranean championships and with clubs abroad. He holds certificates in ERGON IASTM, dry needling and electroacupuncture, spinal manipulation, Yumeiho, visceral manipulation, kinesio taping, dry and wet cupping and kinetic flossing; he is a certified INDIBA-Tecar therapist and the first shockwave practitioner in Montenegro. He lectures at national and international professional meetings and has repeatedly been named best sports physiotherapist.',
	description_de = 'Fachphysiotherapeut für angewandte Physiotherapie. Er absolvierte die Höhere Physiotherapieschule und die Fakultät für angewandte Physiotherapie, Fachrichtung Sportphysiotherapie, und ist fest im Klinischen Zentrum Montenegros in der Abteilung für physikalische Medizin und Rehabilitation angestellt. Er war Physiotherapeut der Handball-Nationalmannschaften der Männer und Frauen, ist Olympiamedaillengewinner und EHF-Pokalsieger und gehörte zu den Olympiakadern in London, Rio de Janeiro und Tokio; Erfahrung sammelte er bei zahlreichen Europa-, Welt- und Mittelmeermeisterschaften und bei Vereinen im Ausland. Er besitzt Zertifikate in ERGON IASTM, Dry Needling und Elektroakupunktur, spinaler Manipulation, Yumeiho, viszeraler Manipulation, Kinesio-Taping, trockenem und nassem Schröpfen sowie Kinetic Flossing; er ist zertifizierter INDIBA-Tecar-Therapeut und der erste Stoßwellenpraktiker Montenegros. Er referiert auf nationalen und internationalen Fachtagungen und wurde mehrfach zum besten Sportphysiotherapeuten gewählt.',
	description_tr = 'Uygulamalı fizyoterapi uzmanı. Fizyoterapi Yüksekokulu''nu ve Uygulamalı Fizyoterapi Fakültesi spor fizyoterapisi bölümünü bitirdi; Karadağ Klinik Merkezi fiziksel tıp ve rehabilitasyon bölümünde kadrolu çalışıyor. Erkek ve kadın A milli hentbol takımlarının fizyoterapistliğini yaptı; olimpiyat madalyası ve EHF Kupası sahibidir, Londra, Rio de Janeiro ve Tokyo olimpiyat kadrolarında yer aldı; deneyimini çok sayıda Avrupa, Dünya ve Akdeniz şampiyonasında ve yurt dışındaki kulüplerde kazandı. ERGON IASTM, dry needling ve elektroakupunktur, spinal manipülasyon, Yumeiho, visseral manipülasyon, kinezyo bantlama, kuru ve yaş kupa ile kinetic flossing sertifikalarına sahiptir; sertifikalı INDIBA-Tecar terapisti ve Karadağ''ın ilk şok dalga uygulayıcısıdır. Ulusal ve uluslararası mesleki toplantılarda konuşmacıdır ve birçok kez en iyi spor fizyoterapisti seçilmiştir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista primijenjene fizioterapije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = '1', clinic_types = '24', hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 2: srdjan-kojic (94), alen-pepic (94).
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
