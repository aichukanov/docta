-- ═══════════════════════════════════════════════════════════════════════════
-- Institut za javno zdravlje Crne Gore (Podgorica) — клиника
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-institut-za-javno-zdravlje-crne-gore-podgorica.sql
-- Затем: server/sql/insert-clinic-institut-za-javno-zdravlje-crne-gore-podgorica-services.sql
-- Запись импорта: data/clinic-imports/institut-za-javno-zdravlje-crne-gore-podgorica.json. Подволна 2e, агент M (клиники со спорным профилем, одобрены юзером 2026-10-09).
-- 
-- Источники (собрано 2026-10-09): https://www.ijzcg.me/ — AngularJS SPA, контент читался через публичный API api.ijzcg.me/v1 (заголовок locale: me):
--   /details (контакты, графики служб), /pages/{slug}?extended_fields=translations… (sanitarni-pregledi, mikrobiologija-uputstva, priprema-*, savjeti-putovanja,
--   czb-imunoprofilaksa, dpst, czb-hiv, vakcinacija, uzorkovanje), /departments/{slug} (centar-za-medicinsku-mikrobiologiju, centar-za-kontrolu-i-prevenciju-zaraznih-bolesti,
--   centar-za-zdravstvenu-ekologiju), /posts/{slug} (sanitarni-pregledi 2024-06-14, grip-vakcinacija-2025-2026), шаблон «O nama» (templates.js).
--   PDF: Pravilnik o obaveznim i preporučenim zdravstvenim pregledima … (13 стр.), плакат «Obavezni sanitarni pregledi» (1 стр.), брошюра для путешественников — цен нет.
--   Поиск по API /posts?q=cjenovnik — пусто, ?q=cijena — только новости. /team-members — пусто → врачей не заводим.
--   * data/google-places/podgorica/institut-za-javno-zdravlje.json — ОСНОВНОЕ место: place_id ChIJZXrorSTrTRMRS0H_vRxwHdc, 42.4377779 / 19.2472987,
--     +382 20 412 888, «bb Džona Džeksona, Podgorica» (рейтинг 2.6, 64 отзыва).
--   * data/google-places/podgorica/institut-za-javno-zdravlje-crne-gore-sanitarni-pregledi.json — ВТОРОЕ место того же адреса (ChIJvz_mWQDrTRMRauRKqzpiPYk,
--     «… - Sanitarni pregledi», +382 67 044 841, 0 отзывов) — отдельной карточки НЕ заводим (решение юзера: одна карточка), телефон — в phone.
-- 
-- Телефоны: +382 20 243 728 (сайт: kabinet direktora / opšte informacije), +382 20 412 888 (Google), +382 67 044 841 (санитарные осмотры). Email: ijzcg@ijzcg.me, sanitarni.pregledi@ijzcg.me.
-- Соцсети: facebook (ссылка подвала), instagram.com/ijz.cg; Twitter и YouTube — колонок нет, не заносим.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJZXrorSTrTRMRS0H_vRxwHdc';
SET @clinic_slug = 'institut-za-javno-zdravlje-crne-gore-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Institut za javno zdravlje Crne Gore', 'Institut za javno zdravlje', 'Институт за јавно здравље', 'IJZCG') AND city_id = 1 LIMIT 1));

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
	'Institut za javno zdravlje Crne Gore',
	'Институт за јавно здравље Црне Горе',
	'Институт общественного здравоохранения Черногории',
	'Džona Džeksona bb',
	'Џона Џексона бб',
	'',
	'',
	'81000',
	42.43777790,
	19.24729870,
	'+38220243728;+38220412888;+38267044841',
	'ijzcg@ijzcg.me;sanitarni.pregledi@ijzcg.me',
	'https://www.ijzcg.me/',
	'facebook.com/Institut-za-javno-zdravlje-Crne-Gore-109421201410472',
	'@ijz.cg',
	'',
	'',
	'',
	'https://www.ijzcg.me/assets/images/icons/ijzcg-me-logo.7a8fb537.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.43777790, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.24729870, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Институт за јавно здравље Црне Горе', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Институт общественного здравоохранения Черногории', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Džona Džeksona bb', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Џона Џексона бб', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38220243728;+38220412888;+38267044841', phone),
	email = IF(email IS NULL OR email = '', 'ijzcg@ijzcg.me;sanitarni.pregledi@ijzcg.me', email),
	website = IF(website IS NULL OR website = '', 'https://www.ijzcg.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/Institut-za-javno-zdravlje-Crne-Gore-109421201410472', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@ijz.cg', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.ijzcg.me/assets/images/icons/ijzcg-me-logo.7a8fb537.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Institut za javno zdravlje Crne Gore je visokospecijalizovana zdravstvena ustanova na tercijarnom nivou zdravstvene zaštite, čija je djelatnost usmjerena na očuvanje i unapređenje zdravlja svih građana. Za građane Institut obavlja obavezne sanitarne preglede određenih kategorija lica i izdaje sanitarne knjižice (radnim danima od 08:00 do 10:00 i od 11:00 do 14:00, u zgradi pored glavnog ulaza; ponijeti važeći dokument sa fotografijom, sanitarnu knjižicu ako postoji i jedan uzorak stolice; tel. 067 044 841, sanitarni.pregledi@ijzcg.me). Centar za medicinsku mikrobiologiju — nacionalna referentna laboratorija za grip, morbile i rubelu i antimikrobnu rezistenciju — radi bakteriološku, virusološku, serološku, molekularnu, mikološku i parazitološku dijagnostiku: urinokulture, PCR analize urina (CMV, BK virus, EBV, Legionella pneumophila), briseve (uretra, vagina i cerviks, grlo, nos, oko, uho, rana, koža), ispitivanje sputuma i stolice; uzorkovanje i prijem uzoraka radnim danima od 07:30 do 10:00 (genitalne mikoplazme — ne petkom), informacije od 11 do 19 h, tel. 067 163 193. Ambulanta za vakcinacije, pripremu i kontrolu putnika u međunarodnom saobraćaju savjetuje putnike prije putovanja i pregleda ih po povratku iz zemalja sa endemskim zaraznim bolestima (rad sa pacijentima 8–15 h, tel. 067 086 815). Savjetovalište za dobrovoljno povjerljivo savjetovanje i testiranje na HIV, virusne hepatitise i polno prenosive infekcije (DPST) radi radnim danima od 08:00 do 15:00 (tel. 067 103 378). Specijalistička ambulanta za poremećaje ishrane izrađuje individualne planove ishrane (tel. 067 167 636).',
	description_sr_cyrl = 'Институт за јавно здравље Црне Горе је високоспецијализована здравствена установа на терцијарном нивоу здравствене заштите, чија је дјелатност усмјерена на очување и унапређење здравља свих грађана. За грађане Институт обавља обавезне санитарне прегледе одређених категорија лица и издаје санитарне књижице (радним данима од 08:00 до 10:00 и од 11:00 до 14:00, у згради поред главног улаза; понијети важећи документ са фотографијом, санитарну књижицу ако постоји и један узорак столице; тел. 067 044 841, санитарни.прегледи@ијзцг.ме). Центар за медицинску микробиологију — национална референтна лабораторија за грип, морбиле и рубелу и антимикробну резистенцију — ради бактериолошку, вирусолошку, серолошку, молекуларну, миколошку и паразитолошку дијагностику: уринокултуре, PCR анализе урина (CMV, BK вирус, EBV, Legionella pneumophila), брисеве (уретра, вагина и цервикс, грло, нос, око, ухо, рана, кожа), испитивање спутума и столице; узорковање и пријем узорака радним данима од 07:30 до 10:00 (гениталне микоплазме — не петком), информације од 11 до 19 х, тел. 067 163 193. Амбуланта за вакцинације, припрему и контролу путника у међународном саобраћају савјетује путнике прије путовања и прегледа их по повратку из земаља са ендемским заразним болестима (рад са пацијентима 8–15 х, тел. 067 086 815). Савјетовалиште за добровољно повјерљиво савјетовање и тестирање на HIV, вирусне хепатитисе и полно преносиве инфекције (DPST) ради радним данима од 08:00 до 15:00 (тел. 067 103 378). Специјалистичка амбуланта за поремећаје исхране израђује индивидуалне планове исхране (тел. 067 167 636).',
	description_ru = 'Институт общественного здравоохранения Черногории — высокоспециализированное медицинское учреждение третичного уровня, деятельность которого направлена на сохранение и укрепление здоровья всех граждан. Для частных лиц институт проводит обязательные санитарные осмотры отдельных категорий работников и выдаёт санитарные книжки (по будням с 08:00 до 10:00 и с 11:00 до 14:00, в здании у главного входа; взять действующий документ с фотографией, санитарную книжку, если есть, и один образец кала; тел. 067 044 841, sanitarni.pregledi@ijzcg.me). Центр медицинской микробиологии — национальная референс-лаборатория по гриппу, кори и краснухе и по антимикробной резистентности — выполняет бактериологическую, вирусологическую, серологическую, молекулярную, микологическую и паразитологическую диагностику: посевы мочи, ПЦР-исследования мочи (ЦМВ, BK-вирус, ВЭБ, Legionella pneumophila), мазки (уретра, влагалище и шейка матки, зев, нос, глаз, ухо, рана, кожа), исследования мокроты и кала; забор и приём материала по будням с 07:30 до 10:00 (генитальные микоплазмы — кроме пятницы), справки с 11 до 19 ч, тел. 067 163 193. Кабинет вакцинации, подготовки и контроля путешественников консультирует перед поездкой и осматривает по возвращении из стран с эндемичными инфекциями (приём 8–15 ч, тел. 067 086 815). Кабинет добровольного конфиденциального консультирования и тестирования на ВИЧ, вирусные гепатиты и ИППП (DPST) работает по будням с 08:00 до 15:00 (тел. 067 103 378). Специализированный кабинет по нарушениям питания составляет индивидуальные планы питания (тел. 067 167 636).',
	description_en = 'The Institute of Public Health of Montenegro is a highly specialised tertiary-level healthcare institution dedicated to preserving and improving the health of all citizens. For individuals, the Institute carries out mandatory sanitary examinations for certain categories of workers and issues sanitary booklets (weekdays 08:00–10:00 and 11:00–14:00, in the building next to the main entrance; bring a valid photo ID, your sanitary booklet if you have one, and one stool sample; tel. 067 044 841, sanitarni.pregledi@ijzcg.me). The Centre for Medical Microbiology — the national reference laboratory for influenza, measles and rubella and for antimicrobial resistance — performs bacteriological, virological, serological, molecular, mycological and parasitological diagnostics: urine cultures, urine PCR tests (CMV, BK virus, EBV, Legionella pneumophila), swabs (urethral, vaginal and cervical, throat, nose, eye, ear, wound, skin), sputum and stool tests; sampling and specimen intake on weekdays 07:30–10:00 (genital mycoplasmas — not on Fridays), information 11:00–19:00, tel. 067 163 193. The clinic for vaccination, preparation and follow-up of international travellers advises travellers before their trip and examines them on return from countries with endemic infectious diseases (patients 8:00–15:00, tel. 067 086 815). The counselling centre for voluntary confidential counselling and testing for HIV, viral hepatitis and sexually transmitted infections (DPST) works on weekdays 08:00–15:00 (tel. 067 103 378). A specialist nutrition-disorders clinic prepares individual nutrition plans (tel. 067 167 636).',
	description_de = 'Das Institut für öffentliche Gesundheit Montenegros ist eine hochspezialisierte Gesundheitseinrichtung der Tertiärversorgung, deren Tätigkeit auf die Erhaltung und Förderung der Gesundheit aller Bürger ausgerichtet ist. Für Privatpersonen führt das Institut die gesetzlich vorgeschriebenen sanitären Untersuchungen bestimmter Berufsgruppen durch und stellt Gesundheitsbücher aus (werktags 08:00–10:00 und 11:00–14:00 im Gebäude neben dem Haupteingang; mitzubringen sind ein gültiger Lichtbildausweis, das Gesundheitsbuch, falls vorhanden, und eine Stuhlprobe; Tel. 067 044 841, sanitarni.pregledi@ijzcg.me). Das Zentrum für medizinische Mikrobiologie — nationales Referenzlabor für Influenza, Masern und Röteln sowie für antimikrobielle Resistenz — bietet bakteriologische, virologische, serologische, molekulare, mykologische und parasitologische Diagnostik: Urinkulturen, PCR-Untersuchungen aus Urin (CMV, BK-Virus, EBV, Legionella pneumophila), Abstriche (Harnröhre, Vagina und Zervix, Rachen, Nase, Auge, Ohr, Wunde, Haut), Sputum- und Stuhluntersuchungen; Probenahme und -annahme werktags 07:30–10:00 (genitale Mykoplasmen nicht freitags), Auskunft 11–19 Uhr, Tel. 067 163 193. Die Ambulanz für Impfungen sowie Vorbereitung und Nachkontrolle von Reisenden im internationalen Verkehr berät vor Reisen und untersucht nach der Rückkehr aus Ländern mit endemischen Infektionskrankheiten (Patienten 8–15 Uhr, Tel. 067 086 815). Die Beratungsstelle für freiwillige, vertrauliche Beratung und Testung auf HIV, Virushepatitis und sexuell übertragbare Infektionen (DPST) arbeitet werktags 08:00–15:00 (Tel. 067 103 378). Eine Fachambulanz für Ernährungsstörungen erstellt individuelle Ernährungspläne (Tel. 067 167 636).',
	description_tr = 'Karadağ Halk Sağlığı Enstitüsü, tüm vatandaşların sağlığını korumaya ve geliştirmeye yönelik çalışan, üçüncü basamakta yüksek düzeyde uzmanlaşmış bir sağlık kuruluşudur. Bireyler için Enstitü, belirli çalışan gruplarının zorunlu sanitar muayenelerini yapar ve sağlık karnesi düzenler (hafta içi 08:00–10:00 ve 11:00–14:00, ana girişin yanındaki binada; geçerli fotoğraflı kimlik, varsa sağlık karnesi ve bir dışkı örneği getirilmelidir; tel. 067 044 841, sanitarni.pregledi@ijzcg.me). Grip, kızamık ve kızamıkçık ile antimikrobiyal direnç için ulusal referans laboratuvarı olan Tıbbi Mikrobiyoloji Merkezi; bakteriyolojik, virolojik, serolojik, moleküler, mikolojik ve parazitolojik tanı yapar: idrar kültürü, idrardan PCR testleri (CMV, BK virüs, EBV, Legionella pneumophila), sürüntüler (üretra, vajina ve serviks, boğaz, burun, göz, kulak, yara, cilt), balgam ve dışkı incelemeleri; numune alma ve kabulü hafta içi 07:30–10:00 (genital mikoplazmalar cuma günleri hariç), bilgi 11:00–19:00, tel. 067 163 193. Aşı, uluslararası yolcuların hazırlığı ve kontrolü polikliniği seyahat öncesi danışmanlık verir ve endemik bulaşıcı hastalıkların görüldüğü ülkelerden dönüşte muayene yapar (hasta kabulü 8–15, tel. 067 086 815). HIV, viral hepatitler ve cinsel yolla bulaşan enfeksiyonlar için gönüllü ve gizli danışmanlık ve test merkezi (DPST) hafta içi 08:00–15:00 arasında çalışır (tel. 067 103 378). Beslenme bozuklukları uzman polikliniği bireysel beslenme planları hazırlar (tel. 067 167 636).'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- DIAGNOSTIC_LABORATORY = 4 (Centar za medicinsku mikrobiologiju — основная работа с пациентами наряду с санитарными осмотрами). Типа «государственное учреждение / институт» в enum нет; POLYCLINIC = 1 не ставим — ИЗЗ не поликлиника (нет приёма врачей-специалистов по направлениям).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 4);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт на me/en, но приём на других языках не заявлен → только SR (1).
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы клиники НЕ заполняются: общего графика института на сайте нет, только графики отдельных служб — забор материала в микробиологии 07:30–10:00 (будни), санитарные осмотры 08:00–10:00 и 11:00–14:00 (будни; плакат: 8.00–14.00), амбулатория вакцинации 8–15 (пауза 10.30–11.00), DPST 08:00–15:00, эпидемиология 7.30–15.30. Они — в описании.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (0)
-- ═══════════════════════════════════════════════════════════════
-- /team-members пусто, врачи на сайте не названы (кроме защитницы прав пациентов — не врач-приём) — врачей не заводим.

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = '1', clinic_types = '4', hours = 0
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
