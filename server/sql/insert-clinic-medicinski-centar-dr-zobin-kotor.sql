-- ═══════════════════════════════════════════════════════════════════════════
-- Medicinski centar dr Zobin (Dobrota, Kotor) — клиника + врач
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-medicinski-centar-dr-zobin-kotor.sql
-- Затем: server/sql/insert-clinic-medicinski-centar-dr-zobin-kotor-services.sql
-- Запись импорта: data/clinic-imports/medicinski-centar-dr-zobin-kotor.json. Подволна 2e, агент M (клиники со спорным профилем, одобрены юзером 2026-10-09).
-- 
-- Источники (собрано 2026-10-09, сырой HTML curl с браузерным UA):
--   * https://www.doctorzobin.com/ — Bitrix; основная версия на русском (/), переводы /rs/, /en/, /al/, /gr/, /de/. Страницы: /, /o-nas/, /uslugi/ + 9 страниц услуг,
--     /treatment/ (методы), /doktora/mikhail_zobin/, /kontakty/. /tseny/ — шаблонная заглушка конструктора сайтов в рублях (стоматология, УЗИ, массаж) — НЕ прайс,
--     игнорируется полностью; /licensiya/ — шаблон согласия по 152-ФЗ с плейсхолдерами <НАЗВАНИЕ_КОМПАНИИ> — игнорируется.
--   * data/google-places/kotor/medicinski-centr-doktora-zobina.json — place_id, координаты 42.4529405 / 18.7658489, +382 69 894 167,
--     «ul. Krivaja bb, Klinika “Vita Feminae, Dobrota 85331» (Google не перезапрашивался).
-- 
-- ⚠️ Тот же адрес, что у ginekoloska-ordinacija-vita-feminae-kotor: центр — отдельная организация-арендатор, своя карточка; Vita Feminae не трогаем.
-- Телефоны: шапка сайта +382 69 894 167, +382 69 748 888; /kontakty/ +382 69 894 167, +382 69 488 709 → все три. Email: doctor.zobin@gmail.com (шапка), dr-zobin@mail.ru (/kontakty/).
-- Соцсети: facebook.com/ordinacija.zobina, instagram.com/doctor_zobin; VK (vk.com/doctorzobin) — колонки нет, не заносим.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJF5cdFWYzTBMReM2jCGw4OrM';
SET @clinic_slug = 'medicinski-centar-dr-zobin-kotor';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Medicinski centar dr Zobin', 'Medicinski centar dr. Zobin', 'Medicinski centar Zobin', 'Медицинский Центр доктора ЗОБИНА') AND city_id = 6 LIMIT 1));

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
	6, -- CityId.KOTOR
	'Medicinski centar dr Zobin',
	'Медицински центар др Зобин',
	'Медицинский центр доктора Зобина',
	'Krivaja bb (Klinika Vita Feminae)',
	'Криваја бб (Клиника Vita Feminae)',
	'Dobrota',
	'Доброта',
	'85331',
	42.45294050,
	18.76584890,
	'+38269894167;+38269748888;+38269488709',
	'doctor.zobin@gmail.com;dr-zobin@mail.ru',
	'https://www.doctorzobin.com/',
	'facebook.com/ordinacija.zobina',
	'@doctor_zobin',
	'',
	'',
	'',
	'https://www.doctorzobin.com/include/logo.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.45294050, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 18.76584890, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Медицински центар др Зобин', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Медицинский центр доктора Зобина', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Krivaja bb (Klinika Vita Feminae)', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Криваја бб (Клиника Vita Feminae)', address_sr_cyrl),
	town_sr = IF(town_sr IS NULL OR town_sr = '', 'Dobrota', town_sr),
	town_sr_cyrl = IF(town_sr_cyrl IS NULL OR town_sr_cyrl = '', 'Доброта', town_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85331', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38269894167;+38269748888;+38269488709', phone),
	email = IF(email IS NULL OR email = '', 'doctor.zobin@gmail.com;dr-zobin@mail.ru', email),
	website = IF(website IS NULL OR website = '', 'https://www.doctorzobin.com/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/ordinacija.zobina', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@doctor_zobin', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.doctorzobin.com/include/logo.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Medicinski centar dr Zobin je narkološki i psihijatrijski centar koji prima pacijente u Dobroti (Kotor), u prostoru Klinike Vita Feminae (ul. Krivaja bb). Centar je osnovao dr Mihail Zobin 1996. godine u Moskvi, uz naučnu podršku i učešće profesora psihijatrije i narkologije A. A. Portnova i I. N. Pjatnicke; 15 godina je radio u Moskvi, a od 2009. godine, na poziv rukovodstva Crne Gore, radi u Crnoj Gori i prima pacijente iz cijelog svijeta. Centar je razvio kratkoročne ambulantne programe: antirecidivnu terapiju svih vrsta zavisnosti — od opioida, psihostimulansa i kanabisa, alkohola, duvana (uključujući e-cigarete i vejpove) i kockanja — koja traje dva do tri dana, uz prethodnu apstinenciju (opioidi 3 nedjelje, psihostimulansi i kanabis 2 nedjelje, alkohol 1 nedjelja); u nekim slučajevima moguć je pripremni period detoksikacije u centru. Liječi i depresije, anksiozne poremećaje, poremećaje spavanja, poremećaje ponašanja, psihoze i sindrome hroničnog bola, posebno kada prethodno liječenje nije bilo dovoljno efikasno; kursna terapija traje od 5 do 12 dana. Sve vrste liječenja sprovode se ambulantno, primjenom naučno zasnovanih metoda. Prijem po prethodnom zakazivanju.',
	description_sr_cyrl = 'Медицински центар др Зобин је нарколошки и психијатријски центар који прима пацијенте у Доброти (Котор), у простору Клинике Vita Feminae (ул. Криваја бб). Центар је основао др Михаил Зобин 1996. године у Москви, уз научну подршку и учешће професора психијатрије и наркологије А. А. Портнова и И. Н. Пјатницке; 15 година је радио у Москви, а од 2009. године, на позив руководства Црне Горе, ради у Црној Гори и прима пацијенте из цијелог свијета. Центар је развио краткорочне амбулантне програме: антирецидивну терапију свих врста зависности — од опиоида, психостимуланса и канабиса, алкохола, дувана (укључујући е-цигарете и вејпове) и коцкања — која траје два до три дана, уз претходну апстиненцију (опиоиди 3 недјеље, психостимуланси и канабис 2 недјеље, алкохол 1 недјеља); у неким случајевима могућ је припремни период детоксикације у центру. Лијечи и депресије, анксиозне поремећаје, поремећаје спавања, поремећаје понашања, психозе и синдроме хроничног бола, посебно када претходно лијечење није било довољно ефикасно; курсна терапија траје од 5 до 12 дана. Све врсте лијечења спроводе се амбулантно, примјеном научно заснованих метода. Пријем по претходном заказивању.',
	description_ru = 'Медицинский центр доктора Зобина — наркологический и психиатрический центр, принимающий пациентов в Доброте (Котор), в помещении клиники «Vita Feminae» (ul. Krivaja bb). Центр основан доктором М. Л. Зобиным в 1996 году в Москве при научной поддержке и участии ведущих учёных в области психиатрии и наркологии — профессора А. А. Портнова и профессора И. Н. Пятницкой; 15 лет работал в Москве, а с 2009 года по приглашению руководства Черногории работает в Черногории, принимая пациентов со всего мира. В центре разработаны краткосрочные амбулаторные программы: противорецидивная терапия всех видов зависимости — от опиоидов, психостимуляторов и каннабиса, алкоголя, табака (включая электронные сигареты и вейпы) и азартных игр — продолжительностью два–три дня при условии предшествующего воздержания (опиоиды — 3 недели, психостимуляторы и каннабис — 2 недели, алкоголь — 1 неделя); в некоторых случаях возможен подготовительный детоксикационный период в центре. Центр также лечит депрессии, тревожные расстройства, нарушения сна, расстройства поведения, психозы и хронические болевые синдромы — особенно когда предшествующее лечение оказалось недостаточно эффективным; курсовая терапия занимает от 5 до 12 дней. Все виды лечения проводятся амбулаторно, научно обоснованными методами. Приём по предварительной записи.',
	description_en = 'Dr Zobin Medical Centre is an addiction and psychiatric centre seeing patients in Dobrota (Kotor), on the premises of the Vita Feminae clinic (ul. Krivaja bb). It was founded by Dr Mikhail Zobin in Moscow in 1996 with the scientific support and participation of leading psychiatry and addiction researchers, Professor A. A. Portnov and Professor I. N. Pyatnitskaya; after 15 years in Moscow, it has worked in Montenegro since 2009 at the invitation of the Montenegrin authorities, treating patients from all over the world. The centre has developed short-term outpatient programmes: relapse-prevention therapy for all types of addiction — opioids, psychostimulants and cannabis, alcohol, tobacco (including e-cigarettes and vapes) and gambling — lasting two to three days, after a period of prior abstinence (opioids 3 weeks, psychostimulants and cannabis 2 weeks, alcohol 1 week); in some cases a preparatory detoxification period at the centre is possible. It also treats depression, anxiety disorders, sleep disorders, behavioural disorders, psychoses and chronic pain syndromes, especially when previous treatment was not effective enough; a course of therapy takes 5 to 12 days. All treatment is outpatient and uses evidence-based methods. By appointment.',
	description_de = 'Das Medizinische Zentrum Dr. Zobin ist ein Zentrum für Suchtmedizin und Psychiatrie, das Patienten in Dobrota (Kotor) in den Räumen der Klinik Vita Feminae (ul. Krivaja bb) empfängt. Es wurde 1996 von Dr. Michail Zobin in Moskau gegründet, mit wissenschaftlicher Unterstützung und Beteiligung führender Forscher der Psychiatrie und Suchtmedizin, Prof. A. A. Portnow und Prof. I. N. Pjatnizkaja; nach 15 Jahren in Moskau arbeitet es seit 2009 auf Einladung der Regierung Montenegros in Montenegro und behandelt Patienten aus aller Welt. Das Zentrum hat ambulante Kurzzeitprogramme entwickelt: Rückfallprophylaxe bei allen Arten von Abhängigkeit — Opioide, Psychostimulanzien und Cannabis, Alkohol, Tabak (einschließlich E-Zigaretten und Vapes) und Glücksspiel — mit einer Dauer von zwei bis drei Tagen nach vorheriger Abstinenz (Opioide 3 Wochen, Psychostimulanzien und Cannabis 2 Wochen, Alkohol 1 Woche); in manchen Fällen ist eine vorbereitende Entgiftungsphase im Zentrum möglich. Behandelt werden außerdem Depressionen, Angststörungen, Schlafstörungen, Verhaltensstörungen, Psychosen und chronische Schmerzsyndrome, besonders wenn frühere Behandlungen nicht ausreichend wirksam waren; eine Behandlungsserie dauert 5 bis 12 Tage. Alle Behandlungen erfolgen ambulant mit evidenzbasierten Methoden. Nach Terminvereinbarung.',
	description_tr = 'Dr. Zobin Tıp Merkezi, Dobrota''da (Kotor) Vita Feminae kliniğinin binasında (ul. Krivaja bb) hasta kabul eden bir bağımlılık ve psikiyatri merkezidir. Merkez, 1996 yılında Moskova''da Dr. Mikhail Zobin tarafından, psikiyatri ve bağımlılık alanının önde gelen bilim insanları Prof. A. A. Portnov ve Prof. I. N. Pyatnitskaya''nın bilimsel desteği ve katılımıyla kuruldu; 15 yıl Moskova''da çalıştıktan sonra 2009''dan bu yana Karadağ yönetiminin daveti üzerine Karadağ''da faaliyet göstermekte ve dünyanın her yerinden hasta kabul etmektedir. Merkez kısa süreli ayakta tedavi programları geliştirmiştir: opioid, psikostimülan ve esrar, alkol, tütün (elektronik sigara ve vape dahil) ve kumar dahil her tür bağımlılık için iki-üç gün süren nüks önleyici tedavi; önceden yoksunluk şartı aranır (opioidler 3 hafta, psikostimülanlar ve esrar 2 hafta, alkol 1 hafta); bazı durumlarda merkezde hazırlık detoks dönemi mümkündür. Ayrıca depresyon, anksiyete bozuklukları, uyku bozuklukları, davranış bozuklukları, psikozlar ve kronik ağrı sendromları — özellikle önceki tedavi yeterince etkili olmadığında — tedavi edilir; kür tedavisi 5–12 gün sürer. Tüm tedaviler ayakta ve bilimsel olarak kanıtlanmış yöntemlerle yapılır. Randevu ile.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- PSYCHIATRIC_CLINIC = 15 (наркологический / психиатрический амбулаторный центр).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 15);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. SR (1) + RU (2): весь сайт ведётся на русском (основная версия /, остальные языки — переводы), центр основан в Москве в 1996 г., врач русскоязычный — «Окончил Военно-медицинскую академию в Санкт-Петербурге в 1980 году», «В течение 15 лет наш Центр работал в Москве» (правило юзера 2026-10-09). EN не ставим: английская версия сайта — перевод, приём на английском не заявлен.
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
SET @keep_lang_2 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 2);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1 OR id <=> @keep_lang_2);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 2 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 2);

-- Часы НЕ заполняются: на сайте их нет (только форма записи; на /uslugi/lechenie_pristrastiya… — «Приём по предварительной записи»).

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (1)
-- ═══════════════════════════════════════════════════════════════
-- Источник: /doktora/mikhail_zobin/ — единственный врач сайта (форма записи «Выберите Доктора: Михаил Зобин»). Безымянных «сотрудников» не заводим.

-- ───────────────────────────────────────────────────────────────
-- /doktora/mikhail_zobin/: «Михаил Зобин — Психиатр-нарколог»; «Руководитель клинических программ Медицинского центра Зобин Михаил Леонидович, психиатр, нарколог, психотерапевт … Кандидат медицинских наук». Фото — единственное нешаблонное изображение страницы врача.
-- Сербская версия сайта пишет «Mikhail Zobin» / «Zobin Mihail Leonidovič»; name_sr — сербская транслитерация «Mihail Zobin» (как mihail-rizov), name_en — «Mikhail Zobin», name_ru — с отчеством (как у остальных русских врачей в БД).
-- В БД нет (name_sr / перевёрнутое / slug mihail-zobin; LIKE %Zobin% / %Зобин% — пусто; прод-API 204 и для mikhail-zobin) → новая карточка.
-- Спец. 21 PSYCHIATRY (психиатр-нарколог; наркологии в enum нет) + 51 PSYCHOTHERAPY («психотерапевт»). Титул — «dr med. sci.» по образцу других русских к.м.н. в БД.
-- Языки 1 SR + 2 RU: весь сайт ведётся на русском (основная версия /), врач русскоязычный — «Окончил Военно-медицинскую академию в Санкт-Петербурге в 1980 году», «В течение 15 лет наш Центр работал в Москве» (правило юзера 2026-10-09: русскоязычный сервис + русскоязычный врач = заявление). SR — всем по умолчанию.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Mihail Zobin' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Zobin Mihail' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'mihail-zobin' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mihail-zobin', 'Mihail Zobin', 'Михаил Зобин', 'Михаил Леонидович Зобин', 'Mikhail Zobin', 'dr med. sci.',
	'https://www.doctorzobin.com/upload/iblock/e51/rjd9qdidfrn1kkif25zawg0q46hrlh0f.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://www.doctorzobin.com/upload/iblock/e51/rjd9qdidfrn1kkif25zawg0q46hrlh0f.jpg', photo_url) WHERE id = @doctor_id;

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Mihail Leonidovič Zobin je psihijatar, narkolog i psihoterapeut, rukovodilac kliničkih programa Medicinskog centra. Završio je Vojnomedicinsku akademiju u Sankt Peterburgu 1980. godine. Postdiplomsko obrazovanje: klinička specijalizacija iz psihijatrije, specijalizacija iz narkologije i psihoterapije na Ruskoj akademiji postdiplomskog obrazovanja. Kandidat je medicinskih nauka, autor više od pedeset publikacija u domaćim i stranim naučnim časopisima, koautor Vodiča za adiktologiju i monografije „Adiktivna žudnja“, autor praktičnog vodiča za ljekare „Terapijske intervencije u adiktologiji“. Član je Upravnog odbora Evroazijske profesionalne asocijacije adiktivne medicine.',
	description_sr_cyrl = 'Михаил Леонидович Зобин је психијатар, нарколог и психотерапеут, руководилац клиничких програма Медицинског центра. Завршио је Војномедицинску академију у Санкт Петербургу 1980. године. Постдипломско образовање: клиничка специјализација из психијатрије, специјализација из наркологије и психотерапије на Руској академији постдипломског образовања. Кандидат је медицинских наука, аутор више од педесет публикација у домаћим и страним научним часописима, коаутор Водича за адиктологију и монографије „Адиктивна жудња“, аутор практичног водича за љекаре „Терапијске интервенције у адиктологији“. Члан је Управног одбора Евроазијске професионалне асоцијације адиктивне медицине.',
	description_ru = 'Зобин Михаил Леонидович — психиатр, нарколог, психотерапевт, руководитель клинических программ Медицинского центра. Окончил Военно-медицинскую академию в Санкт-Петербурге в 1980 году. Постдипломное образование: клиническая ординатура по психиатрии, специализация по наркологии и психотерапии в Российской академии постдипломного образования. Кандидат медицинских наук, автор более полусотни публикаций в отечественных и зарубежных научных изданиях, соавтор Руководства по аддиктологии, монографии «Аддиктивное влечение», автор практического руководства для врачей «Терапевтические вмешательства в аддиктологии». Член Правления Евразийской Профессиональной Ассоциации Аддиктивной Медицины.',
	description_en = 'Mikhail Leonidovich Zobin is a psychiatrist, addiction specialist and psychotherapist, and head of clinical programmes at the Medical Centre. He graduated from the Military Medical Academy in Saint Petersburg in 1980. Postgraduate training: clinical residency in psychiatry and specialisation in addiction medicine and psychotherapy at the Russian Academy of Postgraduate Education. He holds a Candidate of Medical Sciences degree and is the author of more than fifty publications in Russian and international scientific journals, co-author of the Guide to Addictology and the monograph “Addictive Craving”, and author of the practical guide for physicians “Therapeutic Interventions in Addictology”. He is a board member of the Eurasian Professional Association of Addiction Medicine.',
	description_de = 'Michail Leonidowitsch Zobin ist Psychiater, Suchtmediziner und Psychotherapeut sowie Leiter der klinischen Programme des Medizinischen Zentrums. Er absolvierte 1980 die Militärmedizinische Akademie in Sankt Petersburg. Weiterbildung: klinische Facharztausbildung in Psychiatrie sowie Spezialisierung in Suchtmedizin und Psychotherapie an der Russischen Akademie für postgraduale Ausbildung. Er ist Kandidat der medizinischen Wissenschaften, Autor von mehr als fünfzig Veröffentlichungen in russischen und internationalen Fachzeitschriften, Mitautor des Leitfadens für Addiktologie und der Monografie „Süchtiges Verlangen“ sowie Autor des Praxisleitfadens für Ärzte „Therapeutische Interventionen in der Addiktologie“. Er ist Vorstandsmitglied der Eurasischen Berufsvereinigung für Suchtmedizin.',
	description_tr = 'Mikhail Leonidovich Zobin; psikiyatrist, bağımlılık uzmanı ve psikoterapist olup Tıp Merkezi''nin klinik programlar sorumlusudur. 1980 yılında Sankt Petersburg Askerî Tıp Akademisi''nden mezun oldu. Lisansüstü eğitim: psikiyatride klinik ihtisas, Rusya Lisansüstü Eğitim Akademisi''nde bağımlılık tıbbı ve psikoterapi uzmanlığı. Tıp bilimleri adayıdır (doktora); Rus ve uluslararası bilimsel yayınlarda elliden fazla yayını vardır; Bağımlılık Bilimi Rehberi''nin ve “Bağımlılık Arzusu” monografisinin ortak yazarı, hekimler için “Bağımlılık Biliminde Terapötik Müdahaleler” uygulama rehberinin yazarıdır. Avrasya Bağımlılık Tıbbı Meslek Derneği yönetim kurulu üyesidir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 21), (@doctor_id, 51);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1), (@doctor_id, 2);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Psihijatar-narkolog, psihoterapeut; rukovodilac kliničkih programa')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 6, status = published, clinic_languages = '1,2', clinic_types = '15', hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 1: mihail-zobin (21,51).
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
