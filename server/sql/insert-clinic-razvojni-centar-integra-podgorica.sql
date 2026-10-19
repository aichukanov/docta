-- ═══════════════════════════════════════════════════════════════════════════
-- Razvojni centar Integra (Podgorica) — клиника + специалисты
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-razvojni-centar-integra-podgorica.sql
-- Затем: server/sql/insert-clinic-razvojni-centar-integra-podgorica-services.sql
-- Запись импорта: data/clinic-imports/razvojni-centar-integra-podgorica.json. Подволна 2e, агент M (клиники со спорным профилем, одобрены юзером 2026-10-09).
-- 
-- Источники (собрано 2026-10-09, сырой HTML curl с браузерным UA):
--   * https://integracentar.me/ — WordPress; wp-json pages: «Početna» modified 2026-07-23, «Usluge» 2025-12-09, «Kontakt»/«O nama» 2025-12-05,
--     «Naš tim psihologa» 2025-07-20, 8 страниц услуг 2025-08-16. Цен нет (€/cijena на страницах нет).
--   * data/google-places/podgorica/razvojni-centar-integra.json — place_id, координаты 42.4324717 / 19.2838325, +382 68 248 942,
--     «C-14 Vojina Katnića, Podgorica 81000» (Google не перезапрашивался).
-- 
-- Телефоны: три номера с сайта (068 248 942, 068 885 327, 068 448 900), у каждого ссылка viber:// → viber те же три. WhatsApp на сайте нет.
-- Facebook/Instagram — ссылки подвала; YouTube (@r.centarintegra) — колонки в clinics нет, не заносим.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJhf2cS1jtTRMRDmrZU-NvYao';
SET @clinic_slug = 'razvojni-centar-integra-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Razvojni centar Integra', 'Integra', 'Razvojni centar „Integra“') AND city_id = 1 LIMIT 1));

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
	'Razvojni centar Integra',
	'Развојни центар Integra',
	'Центр развития Integra',
	'Vojina Katnića C-14',
	'Војина Катнића C-14',
	'',
	'',
	'81000',
	42.43247170,
	19.28383250,
	'+38268248942;+38268885327;+38268448900',
	'kontakt@integracentar.me',
	'https://integracentar.me/',
	'facebook.com/RazvojniCentarIntegra',
	'@razvojnicentarintegra',
	'',
	'',
	'+38268248942;+38268885327;+38268448900',
	'https://integracentar.me/wp-content/uploads/2025/07/Razvojni-centar-integra-scaled.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.43247170, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.28383250, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Развојни центар Integra', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Центр развития Integra', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Vojina Katnića C-14', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Војина Катнића C-14', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38268248942;+38268885327;+38268448900', phone),
	email = IF(email IS NULL OR email = '', 'kontakt@integracentar.me', email),
	website = IF(website IS NULL OR website = '', 'https://integracentar.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/RazvojniCentarIntegra', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@razvojnicentarintegra', instagram),
	viber = IF(viber IS NULL OR viber = '', '+38268248942;+38268885327;+38268448900', viber),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://integracentar.me/wp-content/uploads/2025/07/Razvojni-centar-integra-scaled.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Razvojni centar Integra je savremeni psihoterapijski centar u Podgorici u kom licencirani stručnjaci primjenjuju različite terapijske modalitete — transakcionu analizu, geštalt psihoterapiju i sistemsku porodičnu psihoterapiju — pružajući personalizovanu podršku u prevazilaženju emocionalnih izazova, životnih kriza i ostvarivanju ličnog potencijala, poštujući najviše etičke i profesionalne standarde. Tim čine licencirani psihoterapeuti i savjetnici u psihoterapiji sa iskustvom u radu sa nekliničkom i kliničkom populacijom odraslih, adolescenata i djece školskog uzrasta. Usluge: individualna psihoterapija, psihoterapijsko savjetovanje, terapija parova, porodična terapija, psihoterapija adolescenata, psihoterapija djece školskog uzrasta, online psihoterapija (video poziv) i grupna psihoterapija (poluzatvorene grupe od 6–10 učesnika). Svaki psihoterapijski odnos započinje dogovorom i ugovorom o diskreciji. Zakazivanje putem kontakt forme na sajtu ili telefonom.',
	description_sr_cyrl = 'Развојни центар Integra је савремени психотерапијски центар у Подгорици у ком лиценцирани стручњаци примјењују различите терапијске модалитете — трансакциону анализу, гешталт психотерапију и системску породичну психотерапију — пружајући персонализовану подршку у превазилажењу емоционалних изазова, животних криза и остваривању личног потенцијала, поштујући највише етичке и професионалне стандарде. Тим чине лиценцирани психотерапеути и савјетници у психотерапији са искуством у раду са неклиничком и клиничком популацијом одраслих, адолесцената и дјеце школског узраста. Услуге: индивидуална психотерапија, психотерапијско савјетовање, терапија парова, породична терапија, психотерапија адолесцената, психотерапија дјеце школског узраста, онлине психотерапија (видео позив) и групна психотерапија (полузатворене групе од 6–10 учесника). Сваки психотерапијски однос започиње договором и уговором о дискрецији. Заказивање путем контакт форме на сајту или телефоном.',
	description_ru = 'Центр развития Integra — современный психотерапевтический центр в Подгорице, где лицензированные специалисты применяют разные терапевтические подходы — транзактный анализ, гештальт-психотерапию и системную семейную психотерапию — и оказывают индивидуальную поддержку в преодолении эмоциональных трудностей и жизненных кризисов и в раскрытии личного потенциала, соблюдая высокие этические и профессиональные стандарты. В команде — лицензированные психотерапевты и консультанты в психотерапии с опытом работы с неклинической и клинической группами взрослых, подростков и детей школьного возраста. Услуги: индивидуальная психотерапия, психотерапевтическое консультирование, терапия пар, семейная терапия, психотерапия подростков, психотерапия детей школьного возраста, онлайн-психотерапия (видеозвонок) и групповая психотерапия (полузакрытые группы по 6–10 участников). Каждая психотерапевтическая работа начинается с договорённости и соглашения о конфиденциальности. Запись через форму на сайте или по телефону.',
	description_en = 'The Integra Development Centre is a modern psychotherapy centre in Podgorica where licensed professionals use different therapeutic modalities — transactional analysis, gestalt psychotherapy and systemic family psychotherapy — offering personalised support in overcoming emotional difficulties and life crises and in realising personal potential, while upholding the highest ethical and professional standards. The team consists of licensed psychotherapists and psychotherapy counsellors experienced in working with non-clinical and clinical populations of adults, adolescents and school-age children. Services: individual psychotherapy, psychotherapeutic counselling, couples therapy, family therapy, adolescent psychotherapy, psychotherapy for school-age children, online psychotherapy (video call) and group psychotherapy (semi-closed groups of 6–10 participants). Every therapeutic relationship starts with an agreement and a confidentiality contract. Appointments via the contact form on the website or by phone.',
	description_de = 'Das Entwicklungszentrum Integra ist ein modernes Psychotherapiezentrum in Podgorica, in dem approbierte Fachleute verschiedene therapeutische Ansätze anwenden — Transaktionsanalyse, Gestaltpsychotherapie und systemische Familienpsychotherapie — und individuelle Unterstützung bei der Bewältigung emotionaler Herausforderungen und Lebenskrisen sowie bei der Entfaltung des persönlichen Potenzials bieten, unter Wahrung höchster ethischer und fachlicher Standards. Das Team besteht aus approbierten Psychotherapeuten und Beratern in der Psychotherapie mit Erfahrung in der Arbeit mit nichtklinischen und klinischen Gruppen von Erwachsenen, Jugendlichen und Schulkindern. Leistungen: Einzelpsychotherapie, psychotherapeutische Beratung, Paartherapie, Familientherapie, Psychotherapie für Jugendliche, Psychotherapie für Schulkinder, Online-Psychotherapie (Videoanruf) und Gruppenpsychotherapie (halboffene Gruppen mit 6–10 Teilnehmenden). Jede therapeutische Beziehung beginnt mit einer Vereinbarung und einem Vertraulichkeitsvertrag. Termine über das Kontaktformular auf der Website oder telefonisch.',
	description_tr = 'Integra Gelişim Merkezi, Podgorica''da lisanslı uzmanların farklı terapi yaklaşımlarını — transaksiyonel analiz, geştalt psikoterapisi ve sistemik aile psikoterapisi — uyguladığı modern bir psikoterapi merkezidir; en yüksek etik ve mesleki standartlara bağlı kalarak duygusal zorlukların ve yaşam krizlerinin aşılmasında ve kişisel potansiyelin gerçekleştirilmesinde kişiye özel destek sunar. Ekip, yetişkinler, ergenler ve okul çağındaki çocuklardan oluşan klinik ve klinik olmayan gruplarla çalışma deneyimine sahip lisanslı psikoterapistlerden ve psikoterapi danışmanlarından oluşur. Hizmetler: bireysel psikoterapi, psikoterapötik danışmanlık, çift terapisi, aile terapisi, ergen psikoterapisi, okul çağındaki çocuklar için psikoterapi, online psikoterapi (görüntülü görüşme) ve grup psikoterapisi (6–10 katılımcılı yarı kapalı gruplar). Her terapötik ilişki bir anlaşma ve gizlilik sözleşmesiyle başlar. Randevu web sitesindeki iletişim formu veya telefon ile alınır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- PSYCHIATRIC_CLINIC = 15 — ближайший тип для центра психотерапии (типа «психологический центр» в enum нет; так же pat-lab-podgorica для психиатрической амбулатории).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 15);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт только на черногорском, приём на других языках не заявлен → только SR (1).
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы: «Radno vrijeme: Ponedeljak - Petak 09:00h - 20:00h» (подвал всех страниц). Сб/Вс не названы → closed.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"end": "20:00", "start": "09:00"}]}',
	'{"type": "regular", "intervals": [{"end": "20:00", "start": "09:00"}]}',
	'{"type": "regular", "intervals": [{"end": "20:00", "start": "09:00"}]}',
	'{"type": "regular", "intervals": [{"end": "20:00", "start": "09:00"}]}',
	'{"type": "regular", "intervals": [{"end": "20:00", "start": "09:00"}]}',
	'{"type": "closed"}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday),
	tuesday = VALUES(tuesday),
	wednesday = VALUES(wednesday),
	thursday = VALUES(thursday),
	friday = VALUES(friday),
	saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (3)
-- ═══════════════════════════════════════════════════════════════
-- Источник: /nas-tim-psihologa/ — три дипломированных психолога с фото и краткой биографией. Это центр психотерапии без врачей;
-- психологи заводятся как специалисты (в БД уже 39 психологов, решение юзера). Все трое — новые карточки.

-- ───────────────────────────────────────────────────────────────
-- /nas-tim-psihologa/: «Marko Minić — Dipl.psiholog; geštalt i transakcioni analitičar psihoterapeut».
-- В БД нет (name_sr / перевёрнутое / slug marko-minic; прод-API 204) → новая карточка. Спец. 22 PSYCHOLOGY + 51 PSYCHOTHERAPY («Sertifikovani je psihoterapeut transakcione analize … i geštalt psihoterapeut»).
-- Языки — только SR: другие не заявлены.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Marko Minić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Minić Marko' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'marko-minic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marko-minic', 'Marko Minić', 'Марко Минић', 'Марко Минич', 'Marko Minic', 'dipl. psiholog',
	'https://integracentar.me/wp-content/uploads/2025/06/Marko-Minic.webp', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://integracentar.me/wp-content/uploads/2025/06/Marko-Minic.webp', photo_url) WHERE id = @doctor_id;

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Marko Minić je diplomirani psiholog, diplomirao na Filozofskom fakultetu Univerziteta u Beogradu. Sertifikovani je psihoterapeut transakcione analize (TA Centar Beograd, nosilac nacionalnog sertifikata) i geštalt psihoterapeut (Gestalt Studio Beograd). Posjeduje bogato kliničko iskustvo i kontinuirano se stručno usavršava u zemlji i inostranstvu. Već duži niz godina radi kao psihoterapeut u Razvojnom centru Integra.',
	description_sr_cyrl = 'Марко Минић је дипломирани психолог, дипломирао на Филозофском факултету Универзитета у Београду. Сертификовани је психотерапеут трансакционе анализе (TA Центар Београд, носилац националног сертификата) и гешталт психотерапеут (Gestalt Studio Београд). Посједује богато клиничко искуство и континуирано се стручно усавршава у земљи и иностранству. Већ дужи низ година ради као психотерапеут у Развојном центру Интегра.',
	description_ru = 'Марко Минич — дипломированный психолог, выпускник философского факультета Белградского университета. Сертифицированный психотерапевт транзактного анализа (TA Centar Beograd, обладатель национального сертификата) и гештальт-психотерапевт (Gestalt Studio Beograd). Имеет большой клинический опыт и постоянно повышает квалификацию в стране и за рубежом. Уже много лет работает психотерапевтом в центре развития Integra.',
	description_en = 'Marko Minić is a psychology graduate of the Faculty of Philosophy, University of Belgrade. He is a certified transactional analysis psychotherapist (TA Centar Beograd, national certificate holder) and a gestalt psychotherapist (Gestalt Studio Beograd). He has extensive clinical experience and continues his professional training at home and abroad. He has worked as a psychotherapist at the Integra Development Centre for many years.',
	description_de = 'Marko Minić ist Diplom-Psychologe und hat an der Philosophischen Fakultät der Universität Belgrad studiert. Er ist zertifizierter Psychotherapeut für Transaktionsanalyse (TA Centar Beograd, Inhaber des nationalen Zertifikats) und Gestaltpsychotherapeut (Gestalt Studio Beograd). Er verfügt über umfangreiche klinische Erfahrung und bildet sich im In- und Ausland kontinuierlich fort. Seit vielen Jahren arbeitet er als Psychotherapeut im Entwicklungszentrum Integra.',
	description_tr = 'Marko Minić, Belgrad Üniversitesi Felsefe Fakültesi mezunu bir psikologdur. Sertifikalı transaksiyonel analiz psikoterapisti (TA Centar Beograd, ulusal sertifika sahibi) ve geştalt psikoterapistidir (Gestalt Studio Beograd). Geniş klinik deneyime sahiptir ve yurt içinde ve yurt dışında mesleki gelişimini sürdürmektedir. Uzun yıllardır Integra Gelişim Merkezi''nde psikoterapist olarak çalışmaktadır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 22), (@doctor_id, 51);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Dipl. psiholog; geštalt i transakcioni analitičar psihoterapeut')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- /nas-tim-psihologa/: «Ljubica Aničić — Dipl.psiholog; geštalt psihoterapeut»; био: «diplomirani psiholog i licencirani psihoterapeut».
-- В БД нет (есть только Slađana Aničić — патолог Moj Lab, другой человек; прод-API 204) → новая карточка. Спец. 22 + 51. Фото — версия 2025/12 из блока био (на карточке — 2025/06 обрезка того же снимка).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Ljubica Aničić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Aničić Ljubica' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'ljubica-anicic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ljubica-anicic', 'Ljubica Aničić', 'Љубица Аничић', 'Любица Аничич', 'Ljubica Anicic', 'dipl. psiholog',
	'https://integracentar.me/wp-content/uploads/2025/12/Ljubica-Anicic-Dipl.psiholog-gestalt-psihoterapeut.webp', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://integracentar.me/wp-content/uploads/2025/12/Ljubica-Anicic-Dipl.psiholog-gestalt-psihoterapeut.webp', photo_url) WHERE id = @doctor_id;

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Ljubica Aničić je diplomirani psiholog i licencirani psihoterapeut, diplomirala na Filozofskom fakultetu Univerziteta u Beogradu. Završila je edukaciju iz geštalt psihoterapije pri EAPTI – Studio za edukaciju Beograd. Radi sa odraslima, adolescentima i djecom. Iskustvo je sticala kroz rad u obrazovno-savjetodavnim centrima. Angažovana je kao psihoterapeut u Razvojnom centru Integra.',
	description_sr_cyrl = 'Љубица Аничић је дипломирани психолог и лиценцирани психотерапеут, дипломирала на Филозофском факултету Универзитета у Београду. Завршила је едукацију из гешталт психотерапије при EAPTI – Студио за едукацију Београд. Ради са одраслима, адолесцентима и дјецом. Искуство је стицала кроз рад у образовно-савјетодавним центрима. Ангажована је као психотерапеут у Развојном центру Интегра.',
	description_ru = 'Любица Аничич — дипломированный психолог и лицензированный психотерапевт, выпускница философского факультета Белградского университета. Окончила обучение гештальт-психотерапии в EAPTI – Studio za edukaciju Beograd. Работает со взрослыми, подростками и детьми. Опыт получила в образовательно-консультационных центрах. Работает психотерапевтом в центре развития Integra.',
	description_en = 'Ljubica Aničić is a psychology graduate of the Faculty of Philosophy, University of Belgrade, and a licensed psychotherapist. She completed her training in gestalt psychotherapy at EAPTI – Studio za edukaciju Beograd. She works with adults, adolescents and children, and gained her experience in educational and counselling centres. She works as a psychotherapist at the Integra Development Centre.',
	description_de = 'Ljubica Aničić ist Diplom-Psychologin und approbierte Psychotherapeutin; sie hat an der Philosophischen Fakultät der Universität Belgrad studiert. Ihre Ausbildung in Gestaltpsychotherapie absolvierte sie bei EAPTI – Studio za edukaciju Beograd. Sie arbeitet mit Erwachsenen, Jugendlichen und Kindern; Erfahrung sammelte sie in Bildungs- und Beratungszentren. Sie ist als Psychotherapeutin im Entwicklungszentrum Integra tätig.',
	description_tr = 'Ljubica Aničić, Belgrad Üniversitesi Felsefe Fakültesi mezunu bir psikolog ve lisanslı psikoterapisttir. Geştalt psikoterapisi eğitimini EAPTI – Studio za edukaciju Beograd''da tamamlamıştır. Yetişkinler, ergenler ve çocuklarla çalışır; deneyimini eğitim ve danışmanlık merkezlerinde edinmiştir. Integra Gelişim Merkezi''nde psikoterapist olarak çalışmaktadır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 22), (@doctor_id, 51);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Dipl. psiholog; geštalt psihoterapeut')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- /nas-tim-psihologa/: «Dragana Živković — Dipl.psiholog; savjetnik u sistemskoj porodičnoj psihoterapiji»; био: «Savjetnik je u edukaciji iz sistemske porodične psihoterapije … angažovana je kao savjetnik u psihoterapiji».
-- В БД нет (другие Živković — врачи иных специальностей; прод-API 204) → новая карточка. Только спец. 22: сайт называет её «savjetnik u psihoterapiji» (в обучении), не психотерапевтом — 51 не ставим.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Dragana Živković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Živković Dragana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'dragana-zivkovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dragana-zivkovic', 'Dragana Živković', 'Драгана Живковић', 'Драгана Живкович', 'Dragana Zivkovic', 'dipl. psiholog',
	'https://integracentar.me/wp-content/uploads/2025/12/Dragana-Zivkovic-Dipl.-psiholog-savjetnik-u-sistemskoj-porodicnoj-psihoterapiji.webp', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://integracentar.me/wp-content/uploads/2025/12/Dragana-Zivkovic-Dipl.-psiholog-savjetnik-u-sistemskoj-porodicnoj-psihoterapiji.webp', photo_url) WHERE id = @doctor_id;

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Dragana Živković je diplomirani psiholog, diplomirala na Filozofskom fakultetu Univerziteta Crne Gore – odsjek za psihologiju. Savjetnik je u edukaciji iz sistemske porodične psihoterapije. Radi sa pojedincima, parovima i porodicama, a angažovana je kao savjetnik u psihoterapiji u Razvojnom centru Integra.',
	description_sr_cyrl = 'Драгана Живковић је дипломирани психолог, дипломирала на Филозофском факултету Универзитета Црне Горе – одсјек за психологију. Савјетник је у едукацији из системске породичне психотерапије. Ради са појединцима, паровима и породицама, а ангажована је као савјетник у психотерапији у Развојном центру Интегра.',
	description_ru = 'Драгана Живкович — дипломированный психолог, выпускница отделения психологии философского факультета Университета Черногории. Консультант, проходящий обучение системной семейной психотерапии. Работает с отдельными клиентами, парами и семьями; в центре развития Integra работает консультантом в психотерапии.',
	description_en = 'Dragana Živković is a psychology graduate of the Faculty of Philosophy, University of Montenegro (Department of Psychology). She is a counsellor in training in systemic family psychotherapy. She works with individuals, couples and families and is engaged as a psychotherapy counsellor at the Integra Development Centre.',
	description_de = 'Dragana Živković ist Diplom-Psychologin und hat an der Philosophischen Fakultät der Universität Montenegro (Abteilung Psychologie) studiert. Sie ist Beraterin in Ausbildung in systemischer Familienpsychotherapie. Sie arbeitet mit Einzelpersonen, Paaren und Familien und ist im Entwicklungszentrum Integra als Beraterin in der Psychotherapie tätig.',
	description_tr = 'Dragana Živković, Karadağ Üniversitesi Felsefe Fakültesi Psikoloji Bölümü mezunu bir psikologdur. Sistemik aile psikoterapisi eğitimi alan bir danışmandır. Bireyler, çiftler ve ailelerle çalışır; Integra Gelişim Merkezi''nde psikoterapi danışmanı olarak görev yapmaktadır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 22);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Dipl. psiholog; savjetnik u sistemskoj porodičnoj psihoterapiji')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = '1', clinic_types = '15', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 3: marko-minic (22,51), ljubica-anicic (22,51), dragana-zivkovic (22).
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
