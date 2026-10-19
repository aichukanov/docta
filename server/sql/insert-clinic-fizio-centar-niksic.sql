-- ═══════════════════════════════════════════════════════════════════════════
-- Fizio Centar Nikšić (Nikšić) — клиника + физиотерапевты/врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-fizio-centar-niksic.sql
-- Затем: server/sql/insert-clinic-fizio-centar-niksic-services.sql
-- Запись импорта: data/clinic-imports/fizio-centar-niksic.json. Подволна 2c, агент P.
--
-- Источники (собрано 2026-10-08, сырой HTML curl'ом; WordPress + Divi, Rank Math sitemap):
--   * https://fiziocentar.me/ (главная), /o-nama/, /usluge/, /oprema/, /kontakt/ и шесть
--     страниц протоколов /usluge/protokol-za-…/ (cervikalni, lumbalni, artroza ramena /
--     koljena / kuka, ACL). page-sitemap: /usluge/ lastmod 2025-10-22, остальные 2023-12 – 2024-02.
--   * 17 PDF пакетов протоколов (/wp-content/uploads/2023/12/PAKET-*.pdf, Last-Modified
--     11.12.2023) — состав пакетов, БЕЗ цен; pdftotext.
--   * data/google-places/niksic/fizio-centar-niksic.json — place_id, координаты
--     42.7758983 / 18.9501802, телефон +382 68 187 449 (39 отзывов — не импортируются).
--
-- Сверка: адрес «20 Njegoševa, Nikšić» — сайт и Google совпадают; индекс 81400 (Никшич).
-- Телефон 068 187 449 — сайт и Google. Email fiziocentar18@gmail.com — главная.
--
-- Цены: на сайте одна — «Terapeutska masaža … 40 minuta po cijeni od 25e» (/usluge/,
-- modified 2025-10-22). ACL-пакет — «CIJENA – na upit». PDF пакетов цен не содержат.
--
-- Команда: шесть физиотерапевтов. Ivan Đuričković («Specijalista za sport i fitnes»,
-- тренер) и Žarko Dubljević (менеджер) — не медработники, не заведены. Врачей-медиков нет.
-- Языки клиники: только SR.
--
-- Идемпотентно и самоисправляюще: клиника ищется по google_place_id → slug → name_sr;
-- пустые поля существующей записи дозаполняются, непустые не трогаются. description_*
-- клиники и НОВЫХ физиотерапевтов пишутся безусловно — правки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJQ3xVS22pTRMRqiUQtvA-Pf0';
SET @clinic_slug = 'fizio-centar-niksic';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Fizio Centar Nikšić', 'Fizio centar Nikšić', 'Fizio Centar - Nikšić') AND city_id = 2 LIMIT 1));

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
	2, -- CityId.NIKSIC
	'Fizio Centar Nikšić',
	'Физио Центар Никшић',
	'Физио Центр Никшич',
	'Njegoševa 20',
	'Његошева 20',
	'',
	'',
	'81400',
	42.77589830,
	18.95018020,
	'+38268187449',
	'fiziocentar18@gmail.com',
	'https://fiziocentar.me/',
	'facebook.com/fiziocentarniksic',
	'@fizio_centar',
	'',
	'',
	'',
	'https://fiziocentar.me/wp-content/uploads/2023/06/FIZIO-CENTRAR-LOGO.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl    = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Физио Центар Никшић', name_sr_cyrl),
	name_ru         = IF(name_ru IS NULL OR name_ru = '', 'Физио Центр Никшич', name_ru),
	address_sr      = IF(address_sr IS NULL OR address_sr = '', 'Njegoševa 20', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Његошева 20', address_sr_cyrl),
	postal_code     = IF(postal_code IS NULL OR postal_code = '', '81400', postal_code),
	latitude        = COALESCE(latitude, 42.77589830),
	longitude       = COALESCE(longitude, 18.95018020),
	phone           = IF(phone IS NULL OR phone = '', '+38268187449', phone),
	email           = IF(email IS NULL OR email = '', 'fiziocentar18@gmail.com', email),
	website         = IF(website IS NULL OR website = '', 'https://fiziocentar.me/', website),
	facebook        = IF(facebook IS NULL OR facebook = '', 'facebook.com/fiziocentarniksic', facebook),
	instagram       = IF(instagram IS NULL OR instagram = '', '@fizio_centar', instagram),
	logo_url        = IF(logo_url IS NULL OR logo_url = '', 'https://fiziocentar.me/wp-content/uploads/2023/06/FIZIO-CENTRAR-LOGO.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловная перезапись. Только то, что клиника пишет о себе; оценочное не переносится.
UPDATE clinics SET
	description_sr = 'Centar za fizioterapiju u Nikšiću, u Njegoševoj ulici 20, sa timom specijalista primijenjene fizioterapije. Liječenje počinje pregledom kod fizioterapeuta: razgovor, upoznavanje sa problemom i testiranje kroz vježbe, u trajanju od 45 minuta do sat vremena, nakon čega se određuje protokol sa tri do pet terapijskih procedura uz individualni rad sa terapeutom. Centar ima protokole za cervikalni i lumbalni sindrom (uključujući diskus herniju), artrozu ramena, koljena i kuka i oporavak nakon operacije prednjeg ukrštenog ligamenta (ACL). U ponudi su TEKAR terapija, kompjuterizovana spinalna dekompresija (DTS, Triton), shockwave, BTL visokofrekventni magnet, kineziterapija, akupunktura i elektroakupunktura, manipulativne tehnike i kiropraktika, terapijski ultrazvuk, elektroterapija i laseroterapija, kineziotejping, Game Ready krioterapija sa kompresijom, BTL CPMotion, manuelne masaže i Schroth metoda za deformitete kičme. Progresivna kineziterapija se izvodi kao grupni trening u sali centra, do osam vježbača uz dva trenera.',
	description_sr_cyrl = 'Центар за физиотерапију у Никшићу, у Његошевој улици 20, са тимом специјалиста примијењене физиотерапије. Лијечење почиње прегледом код физиотерапеута: разговор, упознавање са проблемом и тестирање кроз вјежбе, у трајању од 45 минута до сат времена, након чега се одређује протокол са три до пет терапијских процедура уз индивидуални рад са терапеутом. Центар има протоколе за цервикални и лумбални синдром (укључујући дискус хернију), артрозу рамена, кољена и кука и опоравак након операције предњег укрштеног лигамента (ACL). У понуди су ТЕКАР терапија, компјутеризована спинална декомпресија (DTS, Triton), shockwave, BTL високофреквентни магнет, кинезитерапија, акупунктура и електроакупунктура, манипулативне технике и киропрактика, терапијски ултразвук, електротерапија и ласеротерапија, кинезиотејпинг, Game Ready криотерапија са компресијом, BTL CPMotion, мануелне масаже и Schroth метода за деформитете кичме. Прогресивна кинезитерапија се изводи као групни тренинг у сали центра, до осам вјежбача уз два тренера.',
	description_ru = 'Центр физиотерапии в Никшиче, на улице Njegoševa 20, с командой специалистов прикладной физиотерапии. Лечение начинается с осмотра у физиотерапевта: беседа, разбор проблемы и тестирование с помощью упражнений, от 45 минут до часа. После этого подбирается протокол из трёх–пяти процедур с индивидуальной работой с терапевтом. В центре есть протоколы при шейном и поясничном синдроме (включая грыжу межпозвонкового диска), артрозе плечевого, коленного и тазобедренного суставов и для восстановления после операции на передней крестообразной связке (ACL). Доступны TECAR-терапия, компьютерная декомпрессия позвоночника (DTS, Triton), ударно-волновая терапия, высокоинтенсивная магнитотерапия BTL, кинезиотерапия, акупунктура и электроакупунктура, мануальные техники и хиропрактика, терапевтический ультразвук, электро- и лазеротерапия, кинезиотейпирование, криокомпрессионная терапия Game Ready, BTL CPMotion, ручной массаж и метод Шрота при деформациях позвоночника. Прогрессивная кинезиотерапия проходит в формате групповых тренировок в зале центра — до восьми человек с двумя тренерами.',
	description_en = 'A physiotherapy centre in Nikšić, at Njegoševa 20, with a team of specialists in applied physiotherapy. Treatment starts with a physiotherapist assessment — a conversation about the problem and testing through exercises, lasting 45 minutes to an hour — after which a protocol of three to five therapeutic procedures with individual work with a therapist is set. The centre has protocols for cervical and lumbar syndrome (including disc herniation), shoulder, knee and hip osteoarthritis, and recovery after anterior cruciate ligament (ACL) surgery. Services include TECAR therapy, computerised spinal decompression (DTS, Triton), shockwave, BTL high-intensity magnetic therapy, kinesiotherapy, acupuncture and electroacupuncture, manipulative techniques and chiropractic, therapeutic ultrasound, electrotherapy and laser therapy, kinesio taping, Game Ready cryo-compression, BTL CPMotion, manual massage and the Schroth method for spinal deformities. Progressive kinesiotherapy is run as group training in the centre''s gym, up to eight participants with two trainers.',
	description_de = 'Ein Physiotherapiezentrum in Nikšić, Njegoševa 20, mit einem Team von Fachphysiotherapeuten für angewandte Physiotherapie. Die Behandlung beginnt mit einer physiotherapeutischen Untersuchung — Gespräch, Analyse der Beschwerden und Testung durch Übungen, 45 Minuten bis eine Stunde —, danach wird ein Protokoll aus drei bis fünf Therapieverfahren mit Einzelarbeit mit dem Therapeuten festgelegt. Das Zentrum hat Protokolle für das Zervikal- und Lumbalsyndrom (einschließlich Bandscheibenvorfall), Arthrose von Schulter, Knie und Hüfte sowie für die Rehabilitation nach einer Operation des vorderen Kreuzbands (ACL). Angeboten werden TECAR-Therapie, computergestützte Wirbelsäulendekompression (DTS, Triton), Stoßwellentherapie, hochintensive BTL-Magnetfeldtherapie, Bewegungstherapie, Akupunktur und Elektroakupunktur, manipulative Techniken und Chiropraktik, therapeutischer Ultraschall, Elektro- und Lasertherapie, Kinesio-Taping, Game-Ready-Kryo-Kompressionstherapie, BTL CPMotion, manuelle Massagen und die Schroth-Methode bei Wirbelsäulendeformitäten. Die progressive Bewegungstherapie findet als Gruppentraining im Trainingsraum des Zentrums statt, mit höchstens acht Teilnehmern und zwei Trainern.',
	description_tr = 'Nikšić''te, Njegoševa 20 adresinde, uygulamalı fizyoterapi uzmanlarından oluşan bir ekiple çalışan fizyoterapi merkezi. Tedavi, 45 dakika ile bir saat arasında süren bir fizyoterapist değerlendirmesiyle başlar: sorun konuşulur ve egzersizlerle testler yapılır; ardından terapistle bireysel çalışmayı da içeren üç ila beş işlemlik bir protokol belirlenir. Merkezde boyun ve bel sendromu (disk hernisi dahil), omuz, diz ve kalça artrozu ile ön çapraz bağ (ACL) ameliyatı sonrası iyileşme için protokoller bulunur. TECAR tedavisi, bilgisayarlı spinal dekompresyon (DTS, Triton), şok dalga tedavisi, BTL yüksek yoğunluklu manyetik tedavi, kinezyoterapi, akupunktur ve elektroakupunktur, manipülatif teknikler ve kayropraktik, terapötik ultrason, elektroterapi ve lazer tedavisi, kinezyo bantlama, Game Ready kriyo-kompresyon tedavisi, BTL CPMotion, manuel masaj ve omurga deformiteleri için Schroth yöntemi sunulur. Progresif kinezyoterapi, merkezin salonunda en fazla sekiz kişilik gruplar halinde iki antrenörle yapılır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: CLINIC TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- PHYSIOTHERAPY_CLINIC = 24 (как endorfin-fizio-centar-*, fizikalna-terapija-vertebra-podgorica, spa-medica-podgorica)
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 24);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE, только SR (1).
SET @keep_lang_id = (
	SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1
);

DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND (language_id <> 1 OR id <> @keep_lang_id);

INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (
	SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1
);

-- Часы работы: «Radno vrijeme: Ponedjeljak – Petak: 09 – 21h, Subota: 09 – 16h, Nedjeljom ne radimo» (главная и /kontakt/)
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "16:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (6)
-- Физиотерапевты — специальность 94 = PHYSIOTHERAPY, professional_title NULL (не врачи),
-- как jelena-klikovac (OrthoExpert), valentina-buha (ДЗ Херцег-Нови), dijana-bozovic (ДЗ Котор).
-- 42 = PHYSICAL_MEDICINE (физиатр). Языки: 1 = SR (другие не заявлены).
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Alessandra Quartulli — Specijalista primijenjene fizioterapije
-- В FAQ сайта — «Alessandra Quartulli Matijašević», Instagram _alessandra.matijasevic_; в карточке команды — «Alessandra Quartulli» (взято так).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Alessandra Quartulli' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Quartulli Alessandra' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'alessandra-quartulli' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, instagram, created_at)
SELECT 'alessandra-quartulli', 'Alessandra Quartulli', 'Алесандра Квартули', 'Алессандра Квартулли', 'Alessandra Quartulli', NULL,
	'https://fiziocentar.me/wp-content/uploads/2023/09/Alessandra-Quartulli.png', '@_alessandra.matijasevic_', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://fiziocentar.me/wp-content/uploads/2023/09/Alessandra-Quartulli.png', photo_url),
	instagram = IF(instagram IS NULL OR instagram = '', '@_alessandra.matijasevic_', instagram)
WHERE id = @doctor_id;

UPDATE doctors SET
	description_sr = 'Specijalista primijenjene fizioterapije, usmjerena na pedijatriju i mišićno-koštane probleme; u Fizio centru obavlja pedijatrijske i neurološke preglede. Diplomirala je na Fakultetu primijenjene fizioterapije u Igalu. Dodatno se usavršavala u PNF tehnici (proprioceptivna neuromuskularna facilitacija), terapiji iglama (I i II dio) i na osnovnom Bobath kursu za rad sa djecom i odraslima, a primjenjuje i leukotaping, neurotaktilnu integraciju i Ergon (IASTM) tehniku.',
	description_sr_cyrl = 'Специјалиста примијењене физиотерапије, усмјерена на педијатрију и мишићно-коштане проблеме; у Физио центру обавља педијатријске и неуролошке прегледе. Дипломирала је на Факултету примијењене физиотерапије у Игалу. Додатно се усавршавала у PNF техници (проприоцептивна неуромускуларна фацилитација), терапији иглама (I и II дио) и на основном Bobath курсу за рад са дјецом и одраслима, а примјењује и leukotaping, неуротактилну интеграцију и Ergon (IASTM) технику.',
	description_ru = 'Специалист прикладной физиотерапии, работает прежде всего с детьми и с проблемами опорно-двигательного аппарата; в центре проводит педиатрические и неврологические осмотры. Окончила факультет прикладной физиотерапии в Игало. Дополнительно обучалась технике PNF (проприоцептивное нейромышечное облегчение), терапии иглами (I и II часть) и прошла базовый курс Bobath для работы с детьми и взрослыми; применяет также лейкотейпинг, нейротактильную интеграцию и технику Ergon (IASTM).',
	description_en = 'A specialist in applied physiotherapy focusing on paediatrics and musculoskeletal problems; at the centre she carries out paediatric and neurological assessments. She graduated from the Faculty of Applied Physiotherapy in Igalo. She has further training in PNF (proprioceptive neuromuscular facilitation), needling therapy (parts I and II) and the basic Bobath course for work with children and adults, and also uses leukotaping, neurotactile integration and the Ergon (IASTM) technique.',
	description_de = 'Fachphysiotherapeutin für angewandte Physiotherapie mit Schwerpunkt Pädiatrie und Beschwerden des Bewegungsapparats; im Zentrum führt sie pädiatrische und neurologische Untersuchungen durch. Sie schloss die Fakultät für angewandte Physiotherapie in Igalo ab. Weitergebildet hat sie sich in PNF (propriozeptive neuromuskuläre Fazilitation), Nadeltherapie (Teil I und II) und im Bobath-Grundkurs für die Arbeit mit Kindern und Erwachsenen; außerdem wendet sie Leukotaping, neurotaktile Integration und die Ergon-Technik (IASTM) an.',
	description_tr = 'Pediatri ve kas-iskelet sorunlarına odaklanan uygulamalı fizyoterapi uzmanı; merkezde pediatrik ve nörolojik değerlendirmeler yapar. Igalo''daki Uygulamalı Fizyoterapi Fakültesi''nden mezundur. PNF (proprioseptif nöromüsküler fasilitasyon), iğne tedavisi (I. ve II. bölüm) ve çocuk ve yetişkinlerle çalışmaya yönelik temel Bobath kursu alanlarında ek eğitim almıştır; ayrıca leukotaping, nörotaktil entegrasyon ve Ergon (IASTM) tekniğini uygular.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista primijenjene fizioterapije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Zilha Kojčin — Specijalista primijenjene fizioterapije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Zilha Kojčin' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Kojčin Zilha' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'zilha-kojcin' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, instagram, created_at)
SELECT 'zilha-kojcin', 'Zilha Kojčin', 'Зилха Којчин', 'Зилха Койчин', 'Zilha Kojcin', NULL,
	'https://fiziocentar.me/wp-content/uploads/2023/09/Zilha-Kojcin.png', '@zkojcin', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://fiziocentar.me/wp-content/uploads/2023/09/Zilha-Kojcin.png', photo_url),
	instagram = IF(instagram IS NULL OR instagram = '', '@zkojcin', instagram)
WHERE id = @doctor_id;

UPDATE doctors SET
	description_sr = 'Specijalista primijenjene fizioterapije, diplomirala na Fakultetu primijenjene fizioterapije u Igalu. Bavi se tretmanom mišićno-koštanih problema i relaksacionim tretmanima, terapeutskim i sportskim masažama, uključujući funkcionalne sportske masaže po metodama WAPF. Primjenjuje i osteopatske spinalne manipulacije (OMT) i vestibularnu rehabilitaciju.',
	description_sr_cyrl = 'Специјалиста примијењене физиотерапије, дипломирала на Факултету примијењене физиотерапије у Игалу. Бави се третманом мишићно-коштаних проблема и релаксационим третманима, терапеутским и спортским масажама, укључујући функционалне спортске масаже по методама WAPF. Примјењује и остеопатске спиналне манипулације (OMT) и вестибуларну рехабилитацију.',
	description_ru = 'Специалист прикладной физиотерапии, окончила факультет прикладной физиотерапии в Игало. Занимается лечением проблем опорно-двигательного аппарата и расслабляющими процедурами — лечебным и спортивным массажем, в том числе функциональным спортивным массажем по методикам WAPF. Применяет также остеопатические спинальные манипуляции (OMT) и вестибулярную реабилитацию.',
	description_en = 'A specialist in applied physiotherapy who graduated from the Faculty of Applied Physiotherapy in Igalo. She treats musculoskeletal problems and provides relaxation treatments — therapeutic and sports massage, including functional sports massage according to WAPF methods. She also uses osteopathic spinal manipulation (OMT) and vestibular rehabilitation.',
	description_de = 'Fachphysiotherapeutin für angewandte Physiotherapie, Absolventin der Fakultät für angewandte Physiotherapie in Igalo. Sie behandelt Beschwerden des Bewegungsapparats und bietet entspannende Behandlungen an — therapeutische und Sportmassagen, darunter funktionelle Sportmassagen nach WAPF-Methoden. Außerdem wendet sie osteopathische Wirbelsäulenmanipulationen (OMT) und vestibuläre Rehabilitation an.',
	description_tr = 'Igalo''daki Uygulamalı Fizyoterapi Fakültesi''nden mezun uygulamalı fizyoterapi uzmanı. Kas-iskelet sorunlarının tedavisi ve WAPF yöntemlerine göre fonksiyonel spor masajı dahil terapötik ve spor masajları gibi rahatlatıcı uygulamalarla ilgilenir. Ayrıca osteopatik spinal manipülasyon (OMT) ve vestibüler rehabilitasyon uygular.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista primijenjene fizioterapije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Petar Matijašević — Specijalista primijenjene fizioterapije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Petar Matijašević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Matijašević Petar' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'petar-matijasevic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, instagram, created_at)
SELECT 'petar-matijasevic', 'Petar Matijašević', 'Петар Матијашевић', 'Петар Матияшевич', 'Petar Matijasevic', NULL,
	'https://fiziocentar.me/wp-content/uploads/2023/09/Petar-Matijasevic.png', '@fizio.petar', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://fiziocentar.me/wp-content/uploads/2023/09/Petar-Matijasevic.png', photo_url),
	instagram = IF(instagram IS NULL OR instagram = '', '@fizio.petar', instagram)
WHERE id = @doctor_id;

UPDATE doctors SET
	description_sr = 'Specijalista primijenjene fizioterapije, obrazovanje stekao na Fakultetu primijenjene fizioterapije u Igalu. Bavi se neurološkim i mišićno-koštanim problemima, posebno kliničkom rehabilitacijom bolova u vratu i rehabilitacijom ACL-a; u Fizio centru vodi preglede prema protokolima. Ima napredne vještine u Schroth metodi (I i II nivo), osteopatskoj spinalnoj manipulaciji (I i II nivo), terapiji iglama (I i II nivo) i Mulligan metodi (I i II nivo), sertifikovan je za DNS (dinamičku neuromuskularnu stabilizaciju) i kao funkcionalni trener.',
	description_sr_cyrl = 'Специјалиста примијењене физиотерапије, образовање стекао на Факултету примијењене физиотерапије у Игалу. Бави се неуролошким и мишићно-коштаним проблемима, посебно клиничком рехабилитацијом болова у врату и рехабилитацијом ACL-а; у Физио центру води прегледе према протоколима. Има напредне вјештине у Schroth методи (I и II ниво), остеопатској спиналној манипулацији (I и II ниво), терапији иглама (I и II ниво) и Mulligan методи (I и II ниво), сертификован је за DNS (динамичку неуромускуларну стабилизацију) и као функционални тренер.',
	description_ru = 'Специалист прикладной физиотерапии, окончил факультет прикладной физиотерапии в Игало. Работает с неврологическими проблемами и нарушениями опорно-двигательного аппарата, особенно с клинической реабилитацией при боли в шее и реабилитацией после травм ACL; в центре проводит осмотры по протоколам. Владеет методом Шрота (I и II уровень), остеопатической спинальной манипуляцией (I и II уровень), терапией иглами (I и II уровень) и методом Mulligan (I и II уровень), сертифицирован по DNS (динамическая нейромышечная стабилизация) и как функциональный тренер.',
	description_en = 'A specialist in applied physiotherapy, educated at the Faculty of Applied Physiotherapy in Igalo. He works with neurological and musculoskeletal problems, in particular clinical rehabilitation of neck pain and ACL rehabilitation, and leads protocol-based assessments at the centre. He has advanced training in the Schroth method (levels I and II), osteopathic spinal manipulation (levels I and II), needling therapy (levels I and II) and the Mulligan concept (levels I and II), and is certified in DNS (dynamic neuromuscular stabilisation) and as a functional trainer.',
	description_de = 'Fachphysiotherapeut für angewandte Physiotherapie, ausgebildet an der Fakultät für angewandte Physiotherapie in Igalo. Er befasst sich mit neurologischen Beschwerden und Beschwerden des Bewegungsapparats, insbesondere mit der klinischen Rehabilitation bei Nackenschmerzen und der ACL-Rehabilitation, und leitet im Zentrum die Untersuchungen nach Protokoll. Er verfügt über fortgeschrittene Kenntnisse in der Schroth-Methode (Stufe I und II), osteopathischer Wirbelsäulenmanipulation (Stufe I und II), Nadeltherapie (Stufe I und II) und dem Mulligan-Konzept (Stufe I und II) und ist in DNS (dynamische neuromuskuläre Stabilisation) sowie als funktioneller Trainer zertifiziert.',
	description_tr = 'Igalo''daki Uygulamalı Fizyoterapi Fakültesi''nde eğitim almış uygulamalı fizyoterapi uzmanı. Nörolojik ve kas-iskelet sorunlarıyla, özellikle boyun ağrısının klinik rehabilitasyonu ve ACL rehabilitasyonuyla ilgilenir; merkezde protokole dayalı değerlendirmeleri yürütür. Schroth yöntemi (I. ve II. seviye), osteopatik spinal manipülasyon (I. ve II. seviye), iğne tedavisi (I. ve II. seviye) ve Mulligan yöntemi (I. ve II. seviye) konularında ileri düzey eğitim almış, DNS (dinamik nöromüsküler stabilizasyon) ve fonksiyonel antrenörlük sertifikalarına sahiptir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista primijenjene fizioterapije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Krsto Kovačević — Doktor zdravstvenih nauka, fizioterapeut
-- Тёзка в БД: krsto-kovacevic (стоматолог, Dental Clinic Kovačević) — другой человек; ищем ТОЛЬКО по своему slug. professional_title NULL: «doktor zdravstvenih nauka» — учёная степень, не врач.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'krsto-kovacevic-fizioterapeut' LIMIT 1);

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, instagram, created_at)
SELECT 'krsto-kovacevic-fizioterapeut', 'Krsto Kovačević', 'Крсто Ковачевић', 'Крсто Ковачевич', 'Krsto Kovacevic', NULL,
	'https://fiziocentar.me/wp-content/uploads/2023/10/Krsto-Kovacevic-1.png', '@krstokovacevic', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://fiziocentar.me/wp-content/uploads/2023/10/Krsto-Kovacevic-1.png', photo_url),
	instagram = IF(instagram IS NULL OR instagram = '', '@krstokovacevic', instagram)
WHERE id = @doctor_id;

UPDATE doctors SET
	description_sr = 'Fizioterapeut, doktor zdravstvenih nauka. Osnovne i specijalističke primijenjene studije završio je na Fakultetu primijenjene fizioterapije Univerziteta Crne Gore u Igalu (2011. i 2012), zvanje magistra fizikalne terapije stekao je 2016. godine na Fakultetu zdravstvenih studija Univerziteta u Sarajevu, a 2022. godine i zvanje doktora zdravstvenih nauka. Autor je deset naučnih i devet stručnih radova; završio je 16 stručnih kurseva, među kojima PNF, Shiatsu, Cyriax, Kinesio Taping i Mirror therapy. Radio je u Institutu za fizikalnu medicinu, rehabilitaciju i reumatologiju „Dr Simo Milošević“ u Igalu i bio saradnik na studijskom programu Primijenjena fizioterapija Medicinskog fakulteta Univerziteta Crne Gore. U Fizio centru vodi preglede prema protokolima.',
	description_sr_cyrl = 'Физиотерапеут, доктор здравствених наука. Основне и специјалистичке примијењене студије завршио је на Факултету примијењене физиотерапије Универзитета Црне Горе у Игалу (2011. и 2012), звање магистра физикалне терапије стекао је 2016. године на Факултету здравствених студија Универзитета у Сарајеву, а 2022. године и звање доктора здравствених наука. Аутор је десет научних и девет стручних радова; завршио је 16 стручних курсева, међу којима PNF, Shiatsu, Cyriax, Kinesio Taping и Mirror therapy. Радио је у Институту за физикалну медицину, рехабилитацију и реуматологију „Др Симо Милошевић“ у Игалу и био сарадник на студијском програму Примијењена физиотерапија Медицинског факултета Универзитета Црне Горе. У Физио центру води прегледе према протоколима.',
	description_ru = 'Физиотерапевт, доктор наук в области здравоохранения. Окончил базовое и специализированное прикладное обучение на факультете прикладной физиотерапии Университета Черногории в Игало (2011 и 2012), в 2016 году получил степень магистра физической терапии на факультете медицинских специальностей Университета Сараево, в 2022 году — степень доктора наук в области здравоохранения. Автор десяти научных и девяти профессиональных статей; прошёл 16 профессиональных курсов, в том числе PNF, Shiatsu, Cyriax, Kinesio Taping и Mirror therapy. Работал в Институте физической медицины, реабилитации и ревматологии «Д-р Симо Милошевич» в Игало и сотрудничал с программой «Прикладная физиотерапия» медицинского факультета Университета Черногории. В центре проводит осмотры по протоколам.',
	description_en = 'A physiotherapist with a doctorate in health sciences. He completed his undergraduate and specialist applied studies at the Faculty of Applied Physiotherapy of the University of Montenegro in Igalo (2011 and 2012), obtained a master''s degree in physical therapy at the Faculty of Health Studies of the University of Sarajevo in 2016 and a doctorate in health sciences in 2022. He is the author of ten scientific and nine professional papers and has completed 16 professional courses, including PNF, Shiatsu, Cyriax, Kinesio Taping and Mirror therapy. He has worked at the "Dr Simo Milošević" Institute for Physical Medicine, Rehabilitation and Rheumatology in Igalo and taught on the Applied Physiotherapy programme of the Faculty of Medicine, University of Montenegro. At the centre he leads protocol-based assessments.',
	description_de = 'Physiotherapeut mit Doktorgrad in Gesundheitswissenschaften. Grund- und Fachstudium absolvierte er an der Fakultät für angewandte Physiotherapie der Universität Montenegro in Igalo (2011 und 2012), den Master in physikalischer Therapie erwarb er 2016 an der Fakultät für Gesundheitsstudien der Universität Sarajevo, 2022 promovierte er in Gesundheitswissenschaften. Er ist Autor von zehn wissenschaftlichen und neun Fachartikeln und hat 16 Fachkurse absolviert, darunter PNF, Shiatsu, Cyriax, Kinesio Taping und Spiegeltherapie. Er arbeitete am Institut für physikalische Medizin, Rehabilitation und Rheumatologie „Dr Simo Milošević“ in Igalo und wirkte am Studiengang Angewandte Physiotherapie der Medizinischen Fakultät der Universität Montenegro mit. Im Zentrum leitet er die Untersuchungen nach Protokoll.',
	description_tr = 'Sağlık bilimleri doktorası olan fizyoterapist. Lisans ve uygulamalı uzmanlık eğitimini Karadağ Üniversitesi Igalo Uygulamalı Fizyoterapi Fakültesi''nde (2011 ve 2012) tamamlamış, 2016''da Saraybosna Üniversitesi Sağlık Bilimleri Fakültesi''nde fizik tedavi yüksek lisansı, 2022''de sağlık bilimleri doktorası almıştır. On bilimsel ve dokuz mesleki makalenin yazarıdır; PNF, Shiatsu, Cyriax, Kinesio Taping ve ayna terapisi dahil 16 mesleki kursu tamamlamıştır. Igalo''daki "Dr Simo Milošević" Fiziksel Tıp, Rehabilitasyon ve Romatoloji Enstitüsü''nde çalışmış ve Karadağ Üniversitesi Tıp Fakültesi Uygulamalı Fizyoterapi programında görev almıştır. Merkezde protokole dayalı değerlendirmeleri yürütür.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor zdravstvenih nauka, fizioterapeut')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Predrag Ćalić — Specijalista primijenjene fizioterapije
-- На главной «Predrag Ćalic», на /o-nama/ «Predrag Ćalić» и «Calić» — взято «Ćalić».
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Predrag Ćalić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Ćalić Predrag' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'predrag-calic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, instagram, created_at)
SELECT 'predrag-calic', 'Predrag Ćalić', 'Предраг Ћалић', 'Предраг Чалич', 'Predrag Calic', NULL,
	'https://fiziocentar.me/wp-content/uploads/2023/09/Predrag-Calic.png', '@p_e_dj_a__fizio', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://fiziocentar.me/wp-content/uploads/2023/09/Predrag-Calic.png', photo_url),
	instagram = IF(instagram IS NULL OR instagram = '', '@p_e_dj_a__fizio', instagram)
WHERE id = @doctor_id;

UPDATE doctors SET
	description_sr = 'Specijalista primijenjene fizioterapije, diplomirao na Fakultetu primijenjene fizioterapije u Igalu. Bavi se tretmanom mišićno-koštanih problema sa fokusom na kineziterapiju i rehabilitacijom prednjeg ukrštenog ligamenta (ACL), uključujući testiranje. U Fizio centru obavlja preglede i tretmane koljena, lumbalne kičme, skočnog zgloba i kuka.',
	description_sr_cyrl = 'Специјалиста примијењене физиотерапије, дипломирао на Факултету примијењене физиотерапије у Игалу. Бави се третманом мишићно-коштаних проблема са фокусом на кинезитерапију и рехабилитацијом предњег укрштеног лигамента (ACL), укључујући тестирање. У Физио центру обавља прегледе и третмане кољена, лумбалне кичме, скочног зглоба и кука.',
	description_ru = 'Специалист прикладной физиотерапии, окончил факультет прикладной физиотерапии в Игало. Занимается лечением проблем опорно-двигательного аппарата с упором на кинезиотерапию, а также тестированием и реабилитацией при травмах передней крестообразной связки (ACL). В центре проводит осмотры и лечение коленного сустава, поясничного отдела позвоночника, голеностопного и тазобедренного суставов.',
	description_en = 'A specialist in applied physiotherapy who graduated from the Faculty of Applied Physiotherapy in Igalo. He treats musculoskeletal problems with a focus on kinesiotherapy, and specialises in testing and rehabilitation of the anterior cruciate ligament (ACL). At the centre he assesses and treats the knee, lumbar spine, ankle and hip.',
	description_de = 'Fachphysiotherapeut für angewandte Physiotherapie, Absolvent der Fakultät für angewandte Physiotherapie in Igalo. Er behandelt Beschwerden des Bewegungsapparats mit Schwerpunkt Bewegungstherapie und ist auf Testung und Rehabilitation des vorderen Kreuzbands (ACL) spezialisiert. Im Zentrum untersucht und behandelt er Knie, Lendenwirbelsäule, Sprunggelenk und Hüfte.',
	description_tr = 'Igalo''daki Uygulamalı Fizyoterapi Fakültesi''nden mezun uygulamalı fizyoterapi uzmanı. Kinezyoterapi ağırlıklı olarak kas-iskelet sorunlarının tedavisiyle, ayrıca ön çapraz bağın (ACL) test edilmesi ve rehabilitasyonuyla ilgilenir. Merkezde diz, bel omurgası, ayak bileği ve kalça muayene ve tedavilerini yapar.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista primijenjene fizioterapije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Vojin Kostić — Specijalista primijenjene fizioterapije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Vojin Kostić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Kostić Vojin' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'vojin-kostic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, instagram, created_at)
SELECT 'vojin-kostic', 'Vojin Kostić', 'Војин Костић', 'Воин Костич', 'Vojin Kostic', NULL,
	'https://fiziocentar.me/wp-content/uploads/2023/09/Vojin-Kostic.png', '@vojin_fizio95', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://fiziocentar.me/wp-content/uploads/2023/09/Vojin-Kostic.png', photo_url),
	instagram = IF(instagram IS NULL OR instagram = '', '@vojin_fizio95', instagram)
WHERE id = @doctor_id;

UPDATE doctors SET
	description_sr = 'Specijalista primijenjene fizioterapije, završio Fakultet primijenjene fizioterapije u Igalu. Bavi se tretmanom mišićno-koštanih problema i radom sa neurološkim pacijentima u patronaži, a specijalizovao se za limfnu drenažu, zarastanje tkiva, elektroterapiju i Ergon (IASTM) tehniku, kao i za liječenje sindroma bolnog ramena. U Fizio centru obavlja preglede ramena, vrata i deformiteta stopala.',
	description_sr_cyrl = 'Специјалиста примијењене физиотерапије, завршио Факултет примијењене физиотерапије у Игалу. Бави се третманом мишићно-коштаних проблема и радом са неуролошким пацијентима у патронажи, а специјализовао се за лимфну дренажу, зарастање ткива, електротерапију и Ergon (IASTM) технику, као и за лијечење синдрома болног рамена. У Физио центру обавља прегледе рамена, врата и деформитета стопала.',
	description_ru = 'Специалист прикладной физиотерапии, окончил факультет прикладной физиотерапии в Игало. Занимается лечением проблем опорно-двигательного аппарата и работой с неврологическими пациентами на дому; специализируется на лимфодренаже, заживлении тканей, электротерапии, технике Ergon (IASTM) и лечении синдрома болезненного плеча. В центре проводит осмотры при проблемах плеча, шеи и деформациях стопы.',
	description_en = 'A specialist in applied physiotherapy who graduated from the Faculty of Applied Physiotherapy in Igalo. He treats musculoskeletal problems and works with neurological patients in home care, and specialises in lymphatic drainage, tissue healing, electrotherapy, the Ergon (IASTM) technique and painful shoulder syndrome. At the centre he assesses shoulder, neck and foot deformity problems.',
	description_de = 'Fachphysiotherapeut für angewandte Physiotherapie, Absolvent der Fakultät für angewandte Physiotherapie in Igalo. Er behandelt Beschwerden des Bewegungsapparats und betreut neurologische Patienten im Hausbesuch; spezialisiert hat er sich auf Lymphdrainage, Gewebeheilung, Elektrotherapie, die Ergon-Technik (IASTM) und das schmerzhafte Schultersyndrom. Im Zentrum untersucht er Schulter, Nacken und Fußfehlstellungen.',
	description_tr = 'Igalo''daki Uygulamalı Fizyoterapi Fakültesi''nden mezun uygulamalı fizyoterapi uzmanı. Kas-iskelet sorunlarının tedavisi ve evde bakımdaki nörolojik hastalarla çalışır; lenf drenajı, doku iyileşmesi, elektroterapi, Ergon (IASTM) tekniği ve ağrılı omuz sendromu tedavisi konusunda uzmanlaşmıştır. Merkezde omuz, boyun ve ayak deformitelerine yönelik muayeneler yapar.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista primijenjene fizioterapije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 2, status = published, clinic_languages = '1', clinic_types = '24', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 6: alessandra-quartulli (94), zilha-kojcin (94), petar-matijasevic (94), krsto-kovacevic-fizioterapeut (94), predrag-calic (94), vojin-kostic (94).
-- Если created_at нового физиотерапевта старше даты прогона — запись уже была: проверить, тот ли человек.
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
