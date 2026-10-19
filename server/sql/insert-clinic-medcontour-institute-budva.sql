-- ═══════════════════════════════════════════════════════════════════════════
-- Medcontour Institute (Budva) — клиника без названных специалистов
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-medcontour-institute-budva.sql
-- Затем: server/sql/insert-clinic-medcontour-institute-budva-services.sql
-- Запись импорта: data/clinic-imports/medcontour-institute-budva.json. Подволна 2e, агент Y.
-- 
-- Источники (собрано 2026-10-09, сырой SSR-HTML curl с браузерным UA):
--   * https://medcontour.me/ — Next.js SSR, /en, /ru, /sr (+ /services у каждого); sitemap — 3 главные. /me отдаёт ту же /en.
--     /en/services — перечень 44 позиций (Med Contour Plus ×7, лицо и кожа ×13, диодный лазер ×24) БЕЗ цен (ни € ни чисел);
--     главная — разделы Cosmetology / Aesthetic Medicine / Laser / Nutrition & Wellness / Trichology. Часы — шапка.
--   * data/google-places/budva/medcontour-institute.json — place_id, координаты 42.2852238 / 18.837329, +382 67 031 222,
--     «11 22. Novembra, Budva 85310» (Google не перезапрашивался; 8 отзывов — не импортируются).
-- 
-- Адрес: сайт «Ulica 22. novembra br.11, Budva» = Google. Email на сайте нет. Логотип — inline, отдельного файла нет (только favicon).
-- Соцсети — ссылки шапки сайта.
-- 
-- Идемпотентно и самоисправляюще: клиника ищется по google_place_id → slug → name_sr; пустые поля дозаполняются,
-- описание клиники пишется безусловно — правки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJ-2WsBQDVTRMRVEi1vkLXjaw';
SET @clinic_slug = 'medcontour-institute-budva';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Medcontour Institute', 'MEDCONTOUR INSTITUTE', 'Med Contour Institute', 'Medcontour institute') AND city_id = 3 LIMIT 1));

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
	3, -- CityId.BUDVA
	'Medcontour Institute',
	'Medcontour Institute',
	'Medcontour Institute',
	'22. novembra 11',
	'22. новембра 11',
	'',
	'',
	'85310',
	42.28522380,
	18.83732900,
	'+38267031222',
	'',
	'https://medcontour.me/',
	'facebook.com/p/Med-Contour-Institute-61578957897995',
	'@medcontour_institute',
	'',
	'+38267031222',
	'',
	'',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.28522380, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 18.83732900, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Medcontour Institute', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Medcontour Institute', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', '22. novembra 11', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', '22. новембра 11', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85310', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38267031222', phone),
	website = IF(website IS NULL OR website = '', 'https://medcontour.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/p/Med-Contour-Institute-61578957897995', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@medcontour_institute', instagram),
	whatsapp = IF(whatsapp IS NULL OR whatsapp = '', '+38267031222', whatsapp)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Medcontour Institute je centar estetske medicine i kozmetologije u Budvi, u Ulici 22. novembra br. 11, sa više od 12 godina profesionalnog iskustva. Nudi neinvazivno oblikovanje tijela aparatom Med Contour Plus – zatezanje kože i redukciju lokalizovanih masnih naslaga bez operacije, za velike, kombinovane i male regije i glutealnu regiju, pojedinačno ili u paketima od 5 tretmana. Od tretmana lica i kože dostupni su hidrodermoabrazija Hydra Clear, mezoterapija lica, Dermapen mikronidling lica i vrata, biorevitalizacija (i u kombinaciji RRS sa mezoterapijom regije ispod očiju), hemijski piling i Jessner (Hollywood) piling, mikrodermoabrazija i tretman strija i ožiljaka. Iz estetske medicine – botoks, fileri, skin boosteri i mezoterapija kože i kose, a za probleme sa kosom i vlasištem – mezoterapija za rast kose. Trajno uklanjanje dlaka radi se diodnim laserom, po zonama lica i tijela i za cijelo tijelo. Dostupne su i individualne konsultacije sa nutricionistom i planovi ishrane po mjeri.',
	description_sr_cyrl = 'Medcontour Institute је центар естетске медицине и козметологије у Будви, у Улици 22. новембра бр. 11, са више од 12 година професионалног искуства. Нуди неинвазивно обликовање тијела апаратом Med Contour Plus – затезање коже и редукцију локализованих масних наслага без операције, за велике, комбиноване и мале регије и глутеалну регију, појединачно или у пакетима од 5 третмана. Од третмана лица и коже доступни су хидродермоабразија Hydra Clear, мезотерапија лица, Dermapen микронидлинг лица и врата, биоревитализација (и у комбинацији RRS са мезотерапијом регије испод очију), хемијски пилинг и Jessner (Hollywood) пилинг, микродермоабразија и третман стрија и ожиљака. Из естетске медицине – ботокс, филери, скин боостери и мезотерапија коже и косе, а за проблеме са косом и власиштем – мезотерапија за раст косе. Трајно уклањање длака ради се диодним ласером, по зонама лица и тијела и за цијело тијело. Доступне су и индивидуалне консултације са нутриционистом и планови исхране по мјери.',
	description_ru = 'Medcontour Institute — центр эстетической медицины и косметологии в Будве, на улице 22. novembra, 11, с более чем 12-летним профессиональным опытом. Предлагает неинвазивное моделирование тела на аппарате Med Contour Plus — подтяжку кожи и уменьшение локальных жировых отложений без операции: большие, комбинированные и малые зоны и ягодичная зона, разовые процедуры или пакеты из 5 процедур. Из процедур для лица и кожи — гидродермабразия Hydra Clear, мезотерапия лица, микронидлинг Dermapen лица и шеи, биоревитализация (в том числе RRS в сочетании с мезотерапией области под глазами), химический пилинг и пилинг Джесснера (Hollywood), микродермабразия и коррекция растяжек и рубцов. Из эстетической медицины — ботокс, филлеры, скин-бустеры и мезотерапия кожи и волос; при проблемах волос и кожи головы — мезотерапия для роста волос. Постоянное удаление волос выполняется диодным лазером по зонам лица и тела и на всё тело. Также доступны индивидуальные консультации нутрициолога и индивидуальные планы питания.',
	description_en = 'Medcontour Institute is an aesthetic medicine and cosmetology centre in Budva, at 22. novembra 11, with more than 12 years of professional experience. It offers non-invasive body contouring with the Med Contour Plus device — skin tightening and localised fat reduction without surgery — for large, combined and small areas and the gluteal region, as single treatments or packages of 5. Facial and skin treatments include Hydra Clear hydradermabrasion, facial mesotherapy, Dermapen microneedling of the face and neck, biorevitalisation (also RRS combined with under-eye mesotherapy), chemical and Jessner (Hollywood) peels, microdermabrasion and stretch mark and scar treatment. Aesthetic medicine covers Botox, fillers, skin boosters and skin and hair mesotherapy, and for hair and scalp problems hair growth mesotherapy is available. Permanent hair removal is performed with a diode laser by face and body area and for the full body. Individual nutrition consultations and custom meal plans are also offered.',
	description_de = 'Medcontour Institute ist ein Zentrum für ästhetische Medizin und Kosmetologie in Budva, 22. novembra 11, mit mehr als 12 Jahren Berufserfahrung. Angeboten wird nichtinvasive Körperformung mit dem Gerät Med Contour Plus – Hautstraffung und Reduktion lokaler Fettdepots ohne Operation – für große, kombinierte und kleine Areale und die Gesäßregion, als Einzelbehandlung oder im Paket mit 5 Behandlungen. Zu den Gesichts- und Hautbehandlungen gehören Hydra-Clear-Hydrodermabrasion, Gesichtsmesotherapie, Dermapen-Microneedling für Gesicht und Hals, Biorevitalisierung (auch RRS in Kombination mit Mesotherapie der Augenpartie), chemisches Peeling und Jessner-(Hollywood-)Peeling, Mikrodermabrasion sowie Behandlung von Dehnungsstreifen und Narben. Die ästhetische Medizin umfasst Botox, Filler, Skinbooster und Mesotherapie für Haut und Haare; bei Haar- und Kopfhautproblemen wird Mesotherapie für das Haarwachstum angeboten. Die dauerhafte Haarentfernung erfolgt mit einem Diodenlaser nach Gesichts- und Körperzonen sowie für den ganzen Körper. Außerdem gibt es individuelle Ernährungsberatung und maßgeschneiderte Ernährungspläne.',
	description_tr = 'Medcontour Institute, Budva''da 22. novembra 11 adresinde, 12 yılı aşkın mesleki deneyime sahip bir estetik tıp ve kozmetoloji merkezidir. Med Contour Plus cihazıyla ameliyatsız, invaziv olmayan vücut şekillendirme – cilt sıkılaştırma ve bölgesel yağ azaltma – büyük, kombine ve küçük bölgeler ile kalça bölgesi için tek seans ya da 5 seanslık paketler halinde sunulur. Yüz ve cilt uygulamaları arasında Hydra Clear hidrodermabrazyon, yüz mezoterapisi, yüz ve boyun için Dermapen mikro iğneleme, biyorevitalizasyon (göz altı mezoterapisiyle birlikte RRS dahil), kimyasal peeling ve Jessner (Hollywood) peeling, mikrodermabrazyon ve çatlak ve yara izi tedavisi bulunur. Estetik tıp alanında botoks, dolgu, cilt güçlendiriciler (skin booster) ile cilt ve saç mezoterapisi; saç ve saçlı deri sorunları için saç çıkışını destekleyen mezoterapi uygulanır. Kalıcı epilasyon, yüz ve vücut bölgelerine göre ve tüm vücut için diyot lazerle yapılır. Ayrıca bireysel beslenme danışmanlığı ve kişiye özel beslenme planları sunulur.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- AESTHETIC_CLINIC = 14: «Cosmetology / Aesthetic Medicine / Laser Treatments», оборудование Med Contour Plus, Hydra Clear, диодный лазер.
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 14);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт en/ru/sr, но приём на других языках прямо не заявлен → только SR (1), правило юзера.
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы — шапка сайта: «Mon-Sat: 9 AM-9 PM» / «Pon–Sub: 9–21h» (единственный график); воскресенья нет → closed.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "21:00"}]}',
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
-- PART 3: DOCTORS (0)
-- ═══════════════════════════════════════════════════════════════
-- Специалистов не заводим: имён на сайте нет («Our licensed team is professionally trained…» — без имён).

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 3, status = published, clinic_languages = '1', clinic_types = '14', hours = 1
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
