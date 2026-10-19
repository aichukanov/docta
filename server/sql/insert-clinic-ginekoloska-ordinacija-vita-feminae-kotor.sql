-- ═══════════════════════════════════════════════════════════════════════════
-- Ginekološka ordinacija Vita Feminae (Dobrota, Kotor) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ginekoloska-ordinacija-vita-feminae-kotor.sql
-- Затем: server/sql/insert-clinic-ginekoloska-ordinacija-vita-feminae-kotor-services.sql
-- Запись импорта: data/clinic-imports/ginekoloska-ordinacija-vita-feminae-kotor.json. Подволна 2d, агент V.
-- 
-- Источники (собрано 2026-10-09, сырой HTML curl с браузерным UA):
--   * https://ginekologijakotor.com/ (+ /en/, /ru/) — WordPress one-page, wp-json pages: «Home» modified 2026-04-28.
--     Блоки: O nama / Naš tim / Radno vrijeme / Usluge (7 карточек) / Recenzije (Trustindex) / Kontakt. Цен нет.
--   * data/google-places/kotor/ambulanta.json — place_id, координаты 42.452811 / 18.7658524, +382 69 048 318,
--     «Jadranski put, Dobrota 85330». Имя места в Google «Ambulanta» — в БД имя с сайта (шапка/© «Ginekološka ordinacija Vita Feminae - Kotor»;
--     Trustindex и ссылка на карту — «Vita Feminae (Ginekološko-akušerska Ordinacija)»). Google не перезапрашивался.
-- 
-- Имя: «Ginekološka ordinacija Vita Feminae» — H1 сайта без « - Kotor» (город — в city_id).
-- Facebook — ссылка в подвале сайта (facebook.com/PoliklinikaVitaFeminae), сам Facebook не читался.
-- По этому же адресу принимает Центр доктора Зобина (doctorzobin.com) — НЕ заводится и не смешивается (подволна 2e).
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJs2drV3kzTBMRGL56vSwCVSQ';
SET @clinic_slug = 'ginekoloska-ordinacija-vita-feminae-kotor';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Ginekološka ordinacija Vita Feminae', 'Vita Feminae', 'Vita Feminae (Ginekološko-akušerska Ordinacija)', 'Ginekološka ordinacija Vita Feminae - Kotor') AND city_id = 6 LIMIT 1));

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
	6, -- CityId.KOTOR (Dobrota)
	'Ginekološka ordinacija Vita Feminae',
	'Гинеколошка ординација Vita Feminae',
	'Гинекологический кабинет Vita Feminae',
	'Jadranski put',
	'Јадрански пут',
	'Dobrota',
	'Доброта',
	'85330',
	42.45281100,
	18.76585240,
	'+38269048318;+38232330909',
	'vitafeminae@t-com.me',
	'https://ginekologijakotor.com/',
	'facebook.com/PoliklinikaVitaFeminae',
	'',
	'',
	'',
	'',
	'https://ginekologijakotor.com/wp-content/uploads/2025/08/Vita_Feminae_logo_horizontal-1024x191.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.45281100, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 18.76585240, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Гинеколошка ординација Vita Feminae', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Гинекологический кабинет Vita Feminae', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Jadranski put', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Јадрански пут', address_sr_cyrl),
	town_sr = IF(town_sr IS NULL OR town_sr = '', 'Dobrota', town_sr),
	town_sr_cyrl = IF(town_sr_cyrl IS NULL OR town_sr_cyrl = '', 'Доброта', town_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85330', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38269048318;+38232330909', phone),
	email = IF(email IS NULL OR email = '', 'vitafeminae@t-com.me', email),
	website = IF(website IS NULL OR website = '', 'https://ginekologijakotor.com/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/PoliklinikaVitaFeminae', facebook),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://ginekologijakotor.com/wp-content/uploads/2025/08/Vita_Feminae_logo_horizontal-1024x191.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Ginekološka ordinacija Vita Feminae pruža sveobuhvatnu ginekološku i akušersku njegu u srcu Dobrote (Kotor). Posvećena je zdravlju žena i pruža usluge iz svih oblasti ginekologije i akušerstva, uz savremen pristup: više od 25 godina iskustva i preko 20.000 zadovoljnih pacijentkinja. Usluge: kontrola trudnoće — praćenje i savjetovanje tokom svih njenih faza; ultrazvučna dijagnostika savremenom opremom (2D, 3D, 4D); rano otkrivanje premalignih bolesti — video kolposkopija, Papanicolau test, HPV genotipizacija; savjetovanje i propisivanje kontracepcije; ublažavanje tegoba menopauzalnog perioda; dijagnostika i liječenje polno prenosivih infekcija; bračna neplodnost — folikulometrija i priprema za IVF u koordinaciji sa poznatim evropskim IVF centrima. Preglede obavlja dr Predrag Đurović, specijalista ginekologije i akušerstva; gostujući ljekar je dr Antonia Mihaljević, specijalista ginekologije i akušerstva (zakazivanje kod dr Mihaljević: +382 69 826 645). Prijem po zakazanom terminu.',
	description_sr_cyrl = 'Гинеколошка ординација Vita Feminae пружа свеобухватну гинеколошку и акушерску његу у срцу Доброте (Котор). Посвећена је здрављу жена и пружа услуге из свих области гинекологије и акушерства, уз савремен приступ: више од 25 година искуства и преко 20.000 задовољних пацијенткиња. Услуге: контрола трудноће — праћење и савјетовање током свих њених фаза; ултразвучна дијагностика савременом опремом (2D, 3D, 4D); рано откривање премалигних болести — видео колпоскопија, Папаницолау тест, HPV генотипизација; савјетовање и прописивање контрацепције; ублажавање тегоба менопаузалног периода; дијагностика и лијечење полно преносивих инфекција; брачна неплодност — фоликулометрија и припрема за IVF у координацији са познатим европским IVF центрима. Прегледе обавља др Предраг Ђуровић, специјалиста гинекологије и акушерства; гостујући љекар је др Антониа Михаљевић, специјалиста гинекологије и акушерства (заказивање код др Михаљевић: +382 69 826 645). Пријем по заказаном термину.',
	description_ru = 'Гинекологический кабинет Vita Feminae оказывает полный спектр гинекологической и акушерской помощи в самом сердце Доброты (Котор). Кабинет посвящён женскому здоровью и работает во всех областях гинекологии и акушерства: более 25 лет опыта и свыше 20 000 довольных пациенток. Услуги: ведение беременности — наблюдение и консультации на всех её этапах; ультразвуковая диагностика на современном оборудовании (2D, 3D, 4D); раннее выявление предраковых заболеваний — видеокольпоскопия, тест Папаниколау, генотипирование ВПЧ; консультации и назначение контрацепции; облегчение симптомов менопаузы; диагностика и лечение инфекций, передающихся половым путём; супружеское бесплодие — фолликулометрия и подготовка к ЭКО в сотрудничестве с известными европейскими центрами ЭКО. Приём ведёт д-р Предраг Джурович, специалист по гинекологии и акушерству; приглашённый врач — д-р Антония Михалевич, специалист по гинекологии и акушерству (запись к д-ру Михалевич: +382 69 826 645). Приём по предварительной записи.',
	description_en = 'Vita Feminae gynaecology practice provides comprehensive gynaecological and obstetric care in the heart of Dobrota (Kotor). Dedicated to women''s health, it covers all areas of gynaecology and obstetrics with a modern approach — more than 25 years of experience and over 20,000 satisfied patients. Services: pregnancy check-ups — monitoring and guidance through all stages of pregnancy; ultrasound diagnostics with modern equipment (2D, 3D, 4D); early detection of premalignant conditions — video colposcopy, Pap smear, HPV genotyping; contraception counselling and prescription; relief of menopausal symptoms; diagnosis and treatment of sexually transmitted infections; infertility — folliculometry and IVF preparation in coordination with renowned European IVF centres. Examinations are performed by Dr Predrag Đurović, specialist in gynaecology and obstetrics; the visiting doctor is Dr Antonia Mihaljević, specialist in gynaecology and obstetrics (appointments with Dr Mihaljević: +382 69 826 645). By appointment only.',
	description_de = 'Die gynäkologische Praxis Vita Feminae bietet umfassende gynäkologische und geburtshilfliche Versorgung im Herzen von Dobrota (Kotor). Sie widmet sich der Frauengesundheit und deckt mit modernem Ansatz alle Bereiche der Gynäkologie und Geburtshilfe ab — mehr als 25 Jahre Erfahrung und über 20.000 zufriedene Patientinnen. Leistungen: Schwangerschaftsvorsorge — Begleitung und Beratung in allen Phasen der Schwangerschaft; Ultraschalldiagnostik mit moderner Ausstattung (2D, 3D, 4D); Früherkennung von Krebsvorstufen — Videokolposkopie, Pap-Abstrich, HPV-Genotypisierung; Verhütungsberatung und -verschreibung; Linderung von Wechseljahresbeschwerden; Diagnose und Behandlung sexuell übertragbarer Infektionen; Kinderwunsch — Follikelmonitoring und IVF-Vorbereitung in Zusammenarbeit mit renommierten europäischen IVF-Zentren. Die Untersuchungen führt Dr. Predrag Đurović durch, Facharzt für Gynäkologie und Geburtshilfe; Gastärztin ist Dr. Antonia Mihaljević, Fachärztin für Gynäkologie und Geburtshilfe (Termine bei Dr. Mihaljević: +382 69 826 645). Nur nach Terminvereinbarung.',
	description_tr = 'Vita Feminae jinekoloji muayenehanesi, Dobrota''nın (Kotor) kalbinde kapsamlı jinekolojik ve obstetrik bakım sunar. Kadın sağlığına adanmış muayenehane, modern bir yaklaşımla jinekoloji ve obstetriğin tüm alanlarında hizmet verir: 25 yılı aşkın deneyim ve 20.000''den fazla memnun hasta. Hizmetler: gebelik takibi — gebeliğin tüm evrelerinde izlem ve danışmanlık; modern cihazlarla ultrason tanısı (2D, 3D, 4D); kanser öncesi hastalıkların erken teşhisi — video kolposkopi, Pap smear testi, HPV genotiplemesi; doğum kontrolü danışmanlığı ve reçetesi; menopoz şikâyetlerinin hafifletilmesi; cinsel yolla bulaşan enfeksiyonların teşhis ve tedavisi; kısırlık — folikül takibi ve tanınmış Avrupa IVF merkezleriyle koordineli tüp bebek (IVF) hazırlığı. Muayeneleri kadın hastalıkları ve doğum uzmanı Dr. Predrag Đurović yapar; misafir hekim kadın hastalıkları ve doğum uzmanı Dr. Antonia Mihaljević''tir (Dr. Mihaljević için randevu: +382 69 826 645). Yalnızca randevu ile.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- GYNECOLOGICAL_CLINIC = 7 (гинеколого-акушерский кабинет, как gea-medical-ginekoloska-ordinacija).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 7);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт трёхъязычный (me / en / ru), но приём на других языках прямо не заявлен; «He speaks English perfectly» — отзыв → только SR (1), правило юзера.
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы: блок «Radno vrijeme ordinacije» (главная и подвал, все три языка совпадают): «Ponedjeljak, srijeda i četvrtak: 14:00 – 20:00h; Utorak, petak: 08:00 – 14:00h (po zakazanom terminu)». Сб/Вс не названы → closed. Отпуск 06–12.10.2026 (баннер) — разовое, не заносим.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "14:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "14:00"}]}',
	'{"type": "regular", "intervals": [{"start": "14:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "14:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "14:00"}]}',
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
-- PART 3: DOCTORS (2)
-- ═══════════════════════════════════════════════════════════════
-- Источник: блок «Naš tim» главной (me/en/ru). НЕ заводится: «Struk. med. sestra - babica Danila Vučurović» (медсестра-акушерка).

-- ───────────────────────────────────────────────────────────────
-- «Dr Predrag Đurović, spec. ginekologije i akušerstva» (Naš tim); EN: «Consultations and examinations are performed by Med. Dr. Predrag Đurović».
-- В БД не найден (локаль: predrag-djurovic / djurovic-predrag нет; прод-API 204 по обоим) — новый. 5 = GYNECOLOGY_OBSTETRICS.
-- Языки: только SR. «He speaks English perfectly» — отзыв пациентки в виджете Trustindex, не заявление клиники.
-- Фото врача на сайте нет (галерея — только интерьер).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Predrag Đurović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Đurović Predrag' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'predrag-djurovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'predrag-djurovic', 'Predrag Đurović', 'Предраг Ђуровић', 'Предраг Джурович', 'Predrag Djurovic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 5);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista ginekologije i akušerstva')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- «Gostujući ljekar - Dr Antonia Mihaljević, spec. ginekologije i akušerstva»; «Zakazivanje za dr Mihaljević: +382 (0) 69 826 645».
-- В БД есть: antonia-mihaljevic (локаль id 218, specialty 5, ни к одной клинике не привязана; прод-API 200) — привязка (специальность совпадает).
-- Фото в БД уже есть (/uploads) — не трогаем. Телефон записи — в описании клиники.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'antonia-mihaljevic' LIMIT 1);

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'antonia-mihaljevic', 'Antonia Mihaljević', 'Антониа Михаљевић', 'Антония Михалевич', 'Antonia Mihaljevic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Врач уже в БД: дозаполнение пустых имён (ru/en), существующие не трогаем.
UPDATE doctors SET
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Антония Михалевич', name_ru),
	name_en = IF(name_en IS NULL OR name_en = '', 'Antonia Mihaljevic', name_en)
WHERE id = @doctor_id;

-- Описание врача не задаём: на сайте только специальность.

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 5);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Gostujući ljekar, specijalista ginekologije i akušerstva')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 6, status = published, clinic_languages = '1', clinic_types = '7', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 2: predrag-djurovic (5), antonia-mihaljevic (5).
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
