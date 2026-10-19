-- ═══════════════════════════════════════════════════════════════════════════
-- IMC Fizio (Podgorica) — клиника + физиотерапевт
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-imc-fizio-podgorica.sql
-- Затем: server/sql/insert-clinic-imc-fizio-podgorica-services.sql
-- Запись импорта: data/clinic-imports/imc-fizio-podgorica.json. Подволна 2e, агент Y.
-- 
-- Источники (собрано 2026-10-09, сырой HTML curl с браузерным UA):
--   * https://imcfizio.me/ — статический сайт (Jekyll 4.3.3), me/en/ru/tr; sitemap.xml: 14 страниц × 4 языка.
--     Прочитаны главная (услуги, «O nama», контакты, schema.org) и 13 страниц /usluge/*. Цен нет (только промо
--     «50% popusta na prvu sesiju» — не цена). Часы — из schema.org openingHoursSpecification главной.
--   * data/google-places/podgorica/imc-fizio.json — place_id, координаты 42.4303078 / 19.2415288, +382 69 789 882,
--     «34 Iva Vizina, Podgorica 81000» (Google не перезапрашивался; 43 отзыва — не импортируются).
-- 
-- Юрлицо: «FIZIOREHAB_ME» DOO Podgorica (PIB 03789543) — в описание не выносится. Соцсети — ссылки шапки сайта.
-- Клиника 78 «IMC (International Medical Center) — ORL ambulanta» (8. marta) — другое учреждение, не путать.
-- 
-- Идемпотентно и самоисправляюще: клиника ищется по google_place_id → slug → name_sr; пустые поля дозаполняются,
-- описание клиники пишется безусловно — правки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJLfQykhTrTRMRa2HADgzJ7G8';
SET @clinic_slug = 'imc-fizio-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('IMC Fizio', 'IMC Fizio Podgorica', 'IMC Fizio ambulanta') AND city_id = 1 LIMIT 1));

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
	'IMC Fizio',
	'IMC Физио',
	'IMC Физио',
	'Iva Vizina 34',
	'Ива Визина 34',
	'',
	'',
	'81000',
	42.43030780,
	19.24152880,
	'+38269789882',
	'filip@imcfizio.me',
	'https://imcfizio.me/',
	'facebook.com/imcfizio',
	'@imc_fizio',
	'',
	'',
	'',
	'https://imcfizio.me/assets/images/logo.svg',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.43030780, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.24152880, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'IMC Физио', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'IMC Физио', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Iva Vizina 34', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Ива Визина 34', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38269789882', phone),
	email = IF(email IS NULL OR email = '', 'filip@imcfizio.me', email),
	website = IF(website IS NULL OR website = '', 'https://imcfizio.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/imcfizio', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@imc_fizio', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://imcfizio.me/assets/images/logo.svg', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'IMC Fizio je ambulanta fizikalne terapije u Podgorici, u ulici Iva Vizina 34. Programe, zasnovane na individualnom terapijskom pristupu, vodi fizioterapeut Filip Pejović, specijalista primijenjene fizioterapije u neurologiji. Ambulanta radi na aparatima BTL: Tecar terapija aparatom BTL-6000 Elite TR-Therapy, kombinovani aparat BTL-4825SL Premium za elektroterapiju, ultrazvučnu i lasersku terapiju i BTL sto za kompjutersku trakciju i dekompresiju vratne i lumbalne kičme. Dostupni su i shockwave terapija radijalnim udarnim talasima, vakuum terapija, Bioptron svjetlosna terapija, Mastercare švedski trakcioni sto za istezanje kičme, manuelna masaža i kineziterapija – kod cervikalnog i lumbalnog sindroma, reumatskih oboljenja, nakon povreda koštano-zglobnog sistema, kod neuroloških stanja i u pedijatriji, uz primjenu Bobath koncepta u radu sa djecom koja imaju smetnje u razvoju, omladinom i odraslima i PNF koncepta u neurologiji, ortopediji i traumatologiji.',
	description_sr_cyrl = 'IMC Физио је амбуланта физикалне терапије у Подгорици, у улици Ива Визина 34. Програме, засноване на индивидуалном терапијском приступу, води физиотерапеут Филип Пејовић, специјалиста примијењене физиотерапије у неурологији. Амбуланта ради на апаратима BTL: Tecar терапија апаратом BTL-6000 Elite TR-Therapy, комбиновани апарат BTL-4825SL Premium за електротерапију, ултразвучну и ласерску терапију и BTL сто за компјутерску тракцију и декомпресију вратне и лумбалне кичме. Доступни су и shockwave терапија радијалним ударним таласима, вакуум терапија, Bioptron свјетлосна терапија, Mastercare шведски тракциони сто за истезање кичме, мануелна масажа и кинезитерапија – код цервикалног и лумбалног синдрома, реуматских обољења, након повреда коштано-зглобног система, код неуролошких стања и у педијатрији, уз примјену Bobath концепта у раду са дјецом која имају сметње у развоју, омладином и одраслима и PNF концепта у неурологији, ортопедији и трауматологији.',
	description_ru = 'IMC Fizio — кабинет физиотерапии в Подгорице, на улице Iva Vizina, 34. Программы, построенные на индивидуальном подходе, ведёт физиотерапевт Филип Пейович, специалист прикладной физиотерапии в неврологии. Кабинет работает на аппаратах BTL: Tecar-терапия на аппарате BTL-6000 Elite TR-Therapy, комбинированный аппарат BTL-4825SL Premium для электротерапии, ультразвуковой и лазерной терапии и стол BTL для компьютерного вытяжения и декомпрессии шейного и поясничного отделов позвоночника. Также доступны ударно-волновая терапия радиальными волнами, вакуумная терапия, светотерапия Bioptron, шведский тракционный стол Mastercare для вытяжения позвоночника, ручной массаж и кинезитерапия — при шейном и поясничном синдроме, ревматических заболеваниях, после травм костно-суставной системы, при неврологических состояниях и в педиатрии, с применением концепции Бобат в работе с детьми с нарушениями развития, подростками и взрослыми и концепции PNF в неврологии, ортопедии и травматологии.',
	description_en = 'IMC Fizio is a physical therapy practice in Podgorica, at Iva Vizina 34. Its programmes, based on an individual therapeutic approach, are led by physiotherapist Filip Pejović, a specialist in applied physiotherapy in neurology. The practice works with BTL equipment: Tecar therapy on the BTL-6000 Elite TR-Therapy, the BTL-4825SL Premium combination unit for electrotherapy, ultrasound and laser therapy, and a BTL table for computerised traction and decompression of the cervical and lumbar spine. Also available are radial shockwave therapy, vacuum therapy, Bioptron light therapy, the Mastercare Swedish traction table for spinal stretching, manual massage and exercise therapy for cervical and lumbar syndrome, rheumatic diseases, after musculoskeletal injuries, for neurological conditions and in paediatrics, using the Bobath concept with children with developmental disorders, young people and adults, and the PNF concept in neurology, orthopaedics and traumatology.',
	description_de = 'IMC Fizio ist eine Praxis für physikalische Therapie in Podgorica, Iva Vizina 34. Die Programme beruhen auf einem individuellen therapeutischen Ansatz und werden vom Physiotherapeuten Filip Pejović geleitet, Fachphysiotherapeut für angewandte Physiotherapie in der Neurologie. Die Praxis arbeitet mit BTL-Geräten: Tecar-Therapie mit dem BTL-6000 Elite TR-Therapy, dem Kombinationsgerät BTL-4825SL Premium für Elektro-, Ultraschall- und Lasertherapie sowie einem BTL-Tisch für computergesteuerte Traktion und Dekompression der Hals- und Lendenwirbelsäule. Außerdem werden radiale Stoßwellentherapie, Vakuumtherapie, Bioptron-Lichttherapie, der schwedische Traktionstisch Mastercare zur Wirbelsäulendehnung, manuelle Massage und Bewegungstherapie angeboten – bei Zervikal- und Lumbalsyndrom, rheumatischen Erkrankungen, nach Verletzungen des Bewegungsapparats, bei neurologischen Erkrankungen und in der Pädiatrie, mit dem Bobath-Konzept für Kinder mit Entwicklungsstörungen, Jugendliche und Erwachsene sowie dem PNF-Konzept in Neurologie, Orthopädie und Traumatologie.',
	description_tr = 'IMC Fizio, Podgorica''da Iva Vizina 34 adresinde bir fizik tedavi muayenehanesidir. Bireysel terapi yaklaşımına dayanan programları, nörolojide uygulamalı fizyoterapi uzmanı fizyoterapist Filip Pejović yürütür. Muayenehane BTL cihazlarıyla çalışır: BTL-6000 Elite TR-Therapy ile Tecar tedavisi, elektroterapi, ultrason ve lazer tedavisi için BTL-4825SL Premium kombine cihazı ve boyun ile bel omurgasının bilgisayarlı traksiyonu ve dekompresyonu için BTL masası. Ayrıca radyal şok dalga tedavisi, vakum tedavisi, Bioptron ışık tedavisi, omurga germe için Mastercare İsveç traksiyon masası, manuel masaj ve egzersiz tedavisi sunulur: boyun ve bel sendromu, romatizmal hastalıklar, kas-iskelet sistemi yaralanmaları sonrası, nörolojik durumlar ve pediatride; gelişim bozukluğu olan çocuklar, gençler ve yetişkinlerle Bobath konsepti, nöroloji, ortopedi ve travmatolojide PNF konsepti uygulanır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- PHYSIOTHERAPY_CLINIC = 24: «Ambulanta fizikalne terapije».
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 24);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт на me/en/ru/tr, но приём на других языках прямо не заявлен → только SR (1), правило юзера.
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы — schema.org openingHoursSpecification на главной: Mon–Fri 08:00–14:00 и 16:00–21:00, Sat 08:00–14:00; воскресенья в графике нет → closed. Единственный график на сайте.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "14:00"}, {"start": "16:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "14:00"}, {"start": "16:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "14:00"}, {"start": "16:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "14:00"}, {"start": "16:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "14:00"}, {"start": "16:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "14:00"}]}',
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
-- PART 3: DOCTORS (1)
-- ═══════════════════════════════════════════════════════════════
-- Физиотерапевт — специальность 94 = PHYSIOTHERAPY, professional_title NULL (не врач), как в fizio-tim-podgorica.
-- Источник: главная, блок «O nama» + schema.org Person. Других имён на сайте нет («Naš tim čine licencirani fizioterapeuti» — без имён).
-- Языки: 1 = SR (другие не заявлены).

-- ───────────────────────────────────────────────────────────────
-- Filip Pejović — «Fizioterapeut Filip Pejović, specijalista primijenjene fizioterapije u neurologiji». Новый: в БД Pejović — только другие люди
-- (marina-, mirjana-, nikola-, predrag-, jelena-pejovic …); прод-API filip-pejovic → 204. Фото — /assets/images/filip.png (200).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Filip Pejović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Pejović Filip' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'filip-pejovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'filip-pejovic', 'Filip Pejović', 'Филип Пејовић', 'Филип Пейович', 'Filip Pejovic', NULL,
	'https://imcfizio.me/assets/images/filip.png', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://imcfizio.me/assets/images/filip.png', photo_url) WHERE id = @doctor_id;

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Specijalista primijenjene fizioterapije u neurologiji. Osnovne studije na Fakultetu primijenjene fizioterapije u Igalu završio je 2014. godine, a godinu dana kasnije i specijalističke studije. Dugi niz godina radio je u NVO udruženju roditelja djece sa teškoćama u razvoju, gdje je stekao veliko iskustvo u radu sa djecom i omladinom sa smetnjama u razvoju; ima završen međunarodno priznat Bobath NRT za rad sa djecom i omladinom. Kao fizioterapeut bio je član muške i ženske ragbi reprezentacije Crne Gore. Od 2020. godine radi u ambulanti IMC Fizio i edukovan je za rad na savremenoj aparaturi za fizikalnu terapiju.',
	description_sr_cyrl = 'Специјалиста примијењене физиотерапије у неурологији. Основне студије на Факултету примијењене физиотерапије у Игалу завршио је 2014. године, а годину дана касније и специјалистичке студије. Дуги низ година радио је у НВО удружењу родитеља дјеце са тешкоћама у развоју, гдје је стекао велико искуство у раду са дјецом и омладином са сметњама у развоју; има завршен међународно признат Bobath NRT за рад са дјецом и омладином. Као физиотерапеут био је члан мушке и женске рагби репрезентације Црне Горе. Од 2020. године ради у амбуланти IMC Физио и едукован је за рад на савременој апаратури за физикалну терапију.',
	description_ru = 'Специалист прикладной физиотерапии в неврологии. В 2014 году окончил бакалавриат факультета прикладной физиотерапии в Игало, а через год — специализацию. Много лет работал в НКО — объединении родителей детей с нарушениями развития, где получил большой опыт работы с детьми и подростками с нарушениями развития; прошёл международно признанное обучение Bobath NRT для работы с детьми и подростками. Был физиотерапевтом мужской и женской сборных Черногории по регби. С 2020 года работает в кабинете IMC Fizio, обучен работе на современной аппаратуре для физиотерапии.',
	description_en = 'Specialist in applied physiotherapy in neurology. He completed his undergraduate studies at the Faculty of Applied Physiotherapy in Igalo in 2014 and his specialist studies a year later. For many years he worked at an NGO association of parents of children with developmental difficulties, gaining extensive experience with children and young people with developmental disorders, and he holds the internationally recognised Bobath NRT qualification for work with children and young people. He has been physiotherapist of Montenegro’s men’s and women’s national rugby teams. Since 2020 he has worked at IMC Fizio and is trained in the use of modern physical therapy equipment.',
	description_de = 'Fachphysiotherapeut für angewandte Physiotherapie in der Neurologie. Sein Grundstudium an der Fakultät für angewandte Physiotherapie in Igalo schloss er 2014 ab, ein Jahr später das Fachstudium. Viele Jahre arbeitete er in einem gemeinnützigen Verein von Eltern von Kindern mit Entwicklungsstörungen und sammelte dort umfangreiche Erfahrung mit Kindern und Jugendlichen mit Entwicklungsstörungen; er besitzt die international anerkannte Bobath-NRT-Qualifikation für die Arbeit mit Kindern und Jugendlichen. Er war Physiotherapeut der Rugby-Nationalmannschaften der Männer und Frauen Montenegros. Seit 2020 arbeitet er bei IMC Fizio und ist in der Anwendung moderner Geräte der physikalischen Therapie geschult.',
	description_tr = 'Nörolojide uygulamalı fizyoterapi uzmanı. Igalo''daki Uygulamalı Fizyoterapi Fakültesi lisans eğitimini 2014''te, bir yıl sonra da uzmanlık eğitimini tamamladı. Uzun yıllar gelişim güçlüğü olan çocukların ebeveynlerinden oluşan bir sivil toplum derneğinde çalışarak gelişim bozukluğu olan çocuk ve gençlerle çalışmada geniş deneyim kazandı; çocuk ve gençlerle çalışma için uluslararası tanınan Bobath NRT eğitimine sahiptir. Karadağ erkek ve kadın milli ragbi takımlarının fizyoterapistliğini yaptı. 2020''den beri IMC Fizio''da çalışıyor ve modern fizik tedavi cihazlarının kullanımı konusunda eğitimlidir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Fizioterapeut, specijalista primijenjene fizioterapije u neurologiji')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = '1', clinic_types = '24', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 1: filip-pejovic (94).
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
