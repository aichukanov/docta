-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika Medicus Tim (Podgorica, Zlatica) — клиника + 11 врачей
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-medicus-tim.sql
--
-- Услуги — отдельным файлом: insert-clinic-medicus-tim-services.sql
-- (применять ПОСЛЕ этого, он берёт клинику по google_place_id).
--
-- Источники данных (2026-09-03):
--   * data/google-places/podgorica/medicus-tim.json — google_place_id, координаты,
--     город. Адреса у Google НЕТ: formattedAddress — плюс-код «F77V+JW4».
--   * Instagram @medicus_tim (скриншоты профиля и постов) — название, адрес,
--     телефоны, врачи, перечень услуг, оборудование, страховые партнёры.
--   * Facebook facebook.com/p/Medicus-Tim-61573292403522/ — только сам факт страницы.
--
-- ЧЕГО ЗДЕСЬ НЕТ И ПОЧЕМУ:
--   * Цены — клиника не публикует прейскурант. Под постом «Dopler donjih
--     ekstremiteta» три человека спрашивают цену, ответа нет. Все услуги
--     идут с NULL по дизайну.
--   * website / email — не публикуются нигде, только телефоны.
--   * clinic_working_hours — radno vrijeme не публикуется ни в Instagram,
--     ни в Google Places. Заполнить вручную после уточнения у клиники.
--   * logo_url — логотип есть только вшитым в промо-картинки постов,
--     отдельного файла с URL нет.
--   * photo_url врачей — NULL у всех. Портреты доступны только внутри
--     промо-картинок (отдельного URL изображения нет), а сами посты помечены
--     Instagram'ом как «AI content» — использовать их как фото врача нельзя.
--   * lab_tests — лаборатория заявлена отдельным постом, но перечень анализов
--     дан ГРУППАМИ («Šećer», «Hormoni», «Vitamini», «Tumor markeri»,
--     «Sistematski paketi»). Конкретных анализов источник не называет, поэтому
--     clinic_lab_tests не заполняется. Тип DIAGNOSTIC_LAB при этом проставлен —
--     сам факт лаборатории заявлен явно.
--   * Отзывы — по решению пользователя не импортируются (5 оценок, текст
--     только у одной, непоказательно).
--   * Страховые партнёры (Lovćen, UNIQA) — заявлены постом, но junction-таблицы
--     «клиника ↔ страховая» в схеме нет; факт перенесён в description_*.
--
-- ТРЕБУЕТ РУЧНОЙ ПРОВЕРКИ:
--   * Написание «Gordana Globarević Vukčević». Первый пост дал «Globarevič
--     Vukčevič» (č вместо ć) вместе с опечатками «prezjedi», «djagnostika»,
--     «menópauza» — картинка сгенерирована ИИ и текст в ней искажён. Второй пост
--     той же врачихи даёт чистое «Globarević Vukčević». Взято второе, как
--     грамматически корректная сербская фамилия.
--   * Однофамильцы: скрипт переиспользует уже существующих врачей, найденных
--     по name_sr / перевёрнутому имени / slug. Проверить блок VERIFICATION.
--
-- Идемпотентно: повторный запуск не создаёт дублей и не перезатирает непустые
-- поля уже существующей клиники (status тоже не трогается). description_*
-- клиники и врачей пишутся БЕЗУСЛОВНЫМ UPDATE, чтобы правки текстов доезжали
-- до уже импортированных записей.
-- ⚠️ Цена этого: правки описаний из админки следующий прогон файла перезатрёт —
-- вносить их сюда, а не только в БД.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @google_place_id = 'ChIJpa36GwCTTRMR4xp8dn6lX_Q';
SET @clinic_slug = 'poliklinika-medicus-tim';
SET @city_podgorica = 1;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

-- Поиск существующей клиники: по google_place_id → по slug → по name_sr
SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr = 'Poliklinika Medicus Tim' LIMIT 1));

INSERT INTO clinics (
	slug, google_place_id, status, city_id,
	name_sr, name_sr_cyrl, name_ru,
	address_sr, address_sr_cyrl, town_sr, town_sr_cyrl, postal_code,
	latitude, longitude,
	phone, email, website, facebook, instagram, telegram, whatsapp, viber,
	logo_url, created_at
)
-- description_* сознательно НЕ здесь: их пишет безусловный UPDATE ниже.
SELECT
	@clinic_slug,
	@google_place_id,
	'published',
	@city_podgorica,
	'Poliklinika Medicus Tim',
	'Поликлиника Medicus Tim',
	'Поликлиника Medicus Tim',
	'Zlatica bb, prizemlje hotela Lazaro',
	'Златица бб, приземље хотела Lazaro',
	'',
	'',
	'81000',
	42.46399650,
	19.29483130,
	'+38269898898;+38269884888',
	'',
	'',
	'facebook.com/p/Medicus-Tim-61573292403522',
	'@medicus_tim',
	'',
	'',
	'',
	'',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение: только пустые/NULL поля уже существующей записи.
-- Непустые значения (в т.ч. правки из админки) не трогаем. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl    = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Поликлиника Medicus Tim', name_sr_cyrl),
	name_ru         = IF(name_ru IS NULL OR name_ru = '', 'Поликлиника Medicus Tim', name_ru),
	address_sr      = IF(address_sr IS NULL OR address_sr = '', 'Zlatica bb, prizemlje hotela Lazaro', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Златица бб, приземље хотела Lazaro', address_sr_cyrl),
	postal_code     = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	latitude        = COALESCE(latitude, 42.46399650),
	longitude       = COALESCE(longitude, 19.29483130),
	phone           = IF(phone IS NULL OR phone = '', '+38269898898;+38269884888', phone),
	facebook        = IF(facebook IS NULL OR facebook = '', 'facebook.com/p/Medicus-Tim-61573292403522', facebook),
	instagram       = IF(instagram IS NULL OR instagram = '', '@medicus_tim', instagram)
WHERE id = @clinic_id;

-- Описания — БЕЗУСЛОВНАЯ перезапись (см. шапку файла).
UPDATE clinics SET
	description_sr = 'Privatna poliklinika u podgoričkom naselju Zlatica, u prizemlju hotela Lazaro. Dijagnostika se radi na višeslojnom CT skeneru Philips CT 128: CT angiografija i koronarografija, CT endokranijuma, grudnog koša, abdomena i karlice, kičme i zglobova, CT urografija, CT kolonografija i HRCT pluća. Radi se i ultrazvučna dijagnostika — ultrazvuk abdomena, dojki, štitaste žlijezde, mekih tkiva, zglobova i tetiva, ekspertski ultrazvuk srca, dopler krvnih sudova vrata i ekstremiteta — kao i Holter EKG i Holter pritiska. Specijalistički pregledi: kardiologija, interna medicina, nefrologija, endokrinologija, ginekologija i akušerstvo, radiologija i onkologija. U sklopu poliklinike radi laboratorija (šećer, hormoni, vitamini, tumor markeri, sistematski paketi). Poliklinika navodi saradnju sa osiguravajućim kućama Lovćen i UNIQA.',
	description_sr_cyrl = 'Приватна поликлиника у подгоричком насељу Златица, у приземљу хотела Lazaro. Дијагностика се ради на вишеслојном CT скенеру Philips CT 128: CT ангиографија и коронарографија, CT ендокранијума, грудног коша, абдомена и карлице, кичме и зглобова, CT урографија, CT колонографија и HRCT плућа. Ради се и ултразвучна дијагностика — ултразвук абдомена, дојки, штитасте жлијезде, меких ткива, зглобова и тетива, експертски ултразвук срца, доплер крвних судова врата и екстремитета — као и Холтер ЕКГ и Холтер притиска. Специјалистички прегледи: кардиологија, интерна медицина, нефрологија, ендокринологија, гинекологија и акушерство, радиологија и онкологија. У склопу поликлинике ради лабораторија (шећер, хормони, витамини, тумор маркери, систематски пакети). Поликлиника наводи сарадњу са осигуравајућим кућама Lovćen и UNIQA.',
	description_ru = 'Частная поликлиника в подгорицком районе Златица, на первом этаже отеля Lazaro. Диагностика выполняется на мультиспиральном компьютерном томографе Philips CT 128: КТ-ангиография и коронарография, КТ головного мозга, грудной клетки, брюшной полости и малого таза, позвоночника и суставов, КТ-урография, КТ-колонография и КТВР лёгких. Работает ультразвуковая диагностика — УЗИ брюшной полости, молочных желёз, щитовидной железы, мягких тканей, суставов и сухожилий, экспертное УЗИ сердца, допплер сосудов шеи и конечностей, — а также суточное мониторирование ЭКГ и артериального давления. Специализированные приёмы: кардиология, терапия, нефрология, эндокринология, гинекология и акушерство, радиология и онкология. При поликлинике работает лаборатория (сахар, гормоны, витамины, онкомаркеры, комплексные пакеты). Поликлиника заявляет о сотрудничестве со страховыми компаниями Lovćen и UNIQA.',
	description_en = 'A private polyclinic in the Zlatica district of Podgorica, on the ground floor of the Lazaro hotel. Imaging is performed on a Philips CT 128 multislice scanner: CT angiography and coronary angiography, CT of the head, chest, abdomen and pelvis, spine and joints, CT urography, CT colonography and high-resolution CT of the lungs. Ultrasound diagnostics are also available — abdominal, breast, thyroid, soft tissue, joint and tendon ultrasound, expert echocardiography, Doppler of the neck and extremity vessels — along with Holter ECG and ambulatory blood pressure monitoring. Specialist consultations cover cardiology, internal medicine, nephrology, endocrinology, gynaecology and obstetrics, radiology and oncology. The polyclinic runs its own laboratory (glucose, hormones, vitamins, tumour markers, screening packages) and states that it works with the Lovćen and UNIQA insurance companies.',
	description_de = 'Eine private Poliklinik im Podgoricaer Stadtteil Zlatica, im Erdgeschoss des Hotels Lazaro. Die Bildgebung erfolgt an einem Philips CT 128 Mehrschicht-Scanner: CT-Angiographie und Koronarangiographie, CT von Schädel, Thorax, Abdomen und Becken, Wirbelsäule und Gelenken, CT-Urographie, CT-Kolonographie und HRCT der Lunge. Ebenfalls angeboten wird Ultraschalldiagnostik — Abdomen, Brust, Schilddrüse, Weichteile, Gelenke und Sehnen, Experten-Echokardiographie, Doppler der Hals- und Extremitätengefäße — sowie Holter-EKG und Langzeitblutdruckmessung. Fachärztliche Sprechstunden: Kardiologie, Innere Medizin, Nephrologie, Endokrinologie, Gynäkologie und Geburtshilfe, Radiologie und Onkologie. Zur Poliklinik gehört ein eigenes Labor (Blutzucker, Hormone, Vitamine, Tumormarker, Vorsorgepakete). Die Poliklinik gibt eine Zusammenarbeit mit den Versicherern Lovćen und UNIQA an.',
	description_tr = 'Podgorica''nın Zlatica semtinde, Lazaro otelinin zemin katında yer alan özel poliklinik. Görüntüleme Philips CT 128 çok kesitli tomografi cihazıyla yapılır: BT anjiyografi ve koroner anjiyografi, kafa, göğüs, karın ve pelvis, omurga ve eklem BT''si, BT ürografi, BT kolonografi ve yüksek çözünürlüklü akciğer BT''si. Ultrason tanısı da yapılır — batın, meme, tiroid, yumuşak doku, eklem ve tendon ultrasonu, uzman ekokardiyografi, boyun ve ekstremite damarlarının Doppler''i — ayrıca Holter EKG ve ambulatuvar tansiyon takibi. Uzman muayeneleri: kardiyoloji, iç hastalıkları, nefroloji, endokrinoloji, kadın hastalıkları ve doğum, radyoloji ve onkoloji. Poliklinik bünyesinde laboratuvar bulunur (şeker, hormonlar, vitaminler, tümör belirteçleri, tarama paketleri). Poliklinik Lovćen ve UNIQA sigorta şirketleriyle çalıştığını belirtmektedir.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: CLINIC TYPES
-- ═══════════════════════════════════════════════════════════════
-- 1 = POLYCLINIC — «Poliklinika» в самом названии, приёмы семи специальностей.
-- 4 = DIAGNOSTIC_LAB — лаборатория заявлена отдельным постом
--     («LABORATORIJA — BRZO. PRECIZNO.»).

INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id)
VALUES (@clinic_id, 1), (@clinic_id, 4);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: LANGUAGES
-- ═══════════════════════════════════════════════════════════════
-- Только SR: весь Instagram ведётся на сербском, сопровождения на других
-- языках клиника нигде не заявляет.
-- ⚠️ clinic_languages без UNIQUE — INSERT IGNORE не дедуплицирует,
-- поэтому вставка через NOT EXISTS.

INSERT INTO clinic_languages (clinic_id, language_id, create_time)
SELECT @clinic_id, 1, NOW() FROM dual
WHERE NOT EXISTS (
	SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1
);

-- ═══════════════════════════════════════════════════════════════
-- PART 4: DOCTORS
-- Специальности: 1 = CARDIOLOGY, 2 = INTERNAL_MEDICINE, 3 = GENERAL_SURGERY,
--                5 = GYNECOLOGY_OBSTETRICS, 10 = RADIOLOGY, 12 = ENDOCRINOLOGY,
--                46 = NEPHROLOGY, 47 = ONCOLOGY, 77 = ONCOLOGIC_SURGERY
-- Языки: 1 = SR
--
-- Схема на каждого: find-or-create (без description_*) → безусловный UPDATE
-- описаний ТАМ, ГДЕ ИСТОЧНИК ДАЁТ БИОГРАФИЮ. У врачей, о которых пост сообщает
-- только специальность и перечень услуг, description_* НЕ заполняется:
-- специальность уже хранится в professional_title и doctor_specialties,
-- а дописывать био «по общим знаниям» нельзя.
-- photo_url NULL у всех (см. шапку файла).
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Dr Aida Kovačević — kardiolog
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Aida Kovačević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Kovačević Aida' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'aida-kovacevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aida-kovacevic', 'Aida Kovačević', 'Аида Ковачевић', 'Аида Ковачевич', 'Aida Kovacevic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Kardiolog');

-- ───────────────────────────────────────────────────────────────
-- Dr Miroslav Rabrenović — spec. interne medicine, subspec. kardiologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Miroslav Rabrenović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Rabrenović Miroslav' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'miroslav-rabrenovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'miroslav-rabrenovic', 'Miroslav Rabrenović', 'Мирослав Рабреновић', 'Мирослав Рабренович', 'Miroslav Rabrenovic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 2), (@doctor_id, 1);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Spec. interne medicine – subspecijalista kardiologije');

-- ───────────────────────────────────────────────────────────────
-- Dr Nebojša Ninković — internista, kardiolog
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Nebojša Ninković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Ninković Nebojša' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'nebojsa-ninkovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nebojsa-ninkovic', 'Nebojša Ninković', 'Небојша Нинковић', 'Небойша Нинкович', 'Nebojsa Ninkovic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 2), (@doctor_id, 1);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Internista – kardiolog');

-- ───────────────────────────────────────────────────────────────
-- Dr Elvir Mučić — spec. interne medicine, nefrolog
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Elvir Mučić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mučić Elvir' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'elvir-mucic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'elvir-mucic', 'Elvir Mučić', 'Елвир Мучић', 'Эльвир Мучич', 'Elvir Mucic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista interne medicine – nefrolog. Bavi se dijagnostikom i liječenjem akutnih i hroničnih bubrežnih oboljenja, procjenom uzroka i faktora rizika bubrežnih bolesti te praćenjem i liječenjem komplikovanih internističkih stanja.',
	description_sr_cyrl = 'Специјалиста интерне медицине – нефролог. Бави се дијагностиком и лијечењем акутних и хроничних бубрежних обољења, процјеном узрока и фактора ризика бубрежних болести те праћењем и лијечењем компликованих интернистичких стања.',
	description_ru = 'Специалист по внутренним болезням, нефролог. Занимается диагностикой и лечением острых и хронических заболеваний почек, оценкой причин и факторов риска почечных болезней, а также наблюдением и лечением сложных терапевтических состояний.',
	description_en = 'Specialist in internal medicine and nephrologist. He diagnoses and treats acute and chronic kidney disease, assesses the causes and risk factors of renal conditions, and manages complex internal medicine cases.',
	description_de = 'Facharzt für Innere Medizin und Nephrologe. Er diagnostiziert und behandelt akute und chronische Nierenerkrankungen, beurteilt Ursachen und Risikofaktoren von Nierenleiden und betreut komplexe internistische Krankheitsbilder.',
	description_tr = 'İç hastalıkları uzmanı ve nefrolog. Akut ve kronik böbrek hastalıklarının tanı ve tedavisi, böbrek hastalıklarının nedenlerinin ve risk faktörlerinin değerlendirilmesi ile karmaşık dahiliye vakalarının takibi ve tedavisiyle ilgilenir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 2), (@doctor_id, 46);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista interne medicine – nefrolog');

-- ───────────────────────────────────────────────────────────────
-- Dr Gordana Globarević Vukčević — specijalista ginekologije i akušerstva
-- ⚠️ Написание фамилии — см. «ТРЕБУЕТ РУЧНОЙ ПРОВЕРКИ» в шапке файла.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Gordana Globarević Vukčević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Globarević Vukčević Gordana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'gordana-globarevic-vukcevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'gordana-globarevic-vukcevic', 'Gordana Globarević Vukčević', 'Гордана Глобаревић Вукчевић', 'Гордана Глобаревич Вукчевич', 'Gordana Globarevic Vukcevic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 5);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista ginekologije i akušerstva');

-- ───────────────────────────────────────────────────────────────
-- Dr Valentina Kalinić — spec. interne medicine, subspec. endokrinologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Valentina Kalinić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Kalinić Valentina' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'valentina-kalinic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'valentina-kalinic', 'Valentina Kalinić', 'Валентина Калинић', 'Валентина Калинич', 'Valentina Kalinic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 2), (@doctor_id, 12);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Spec. interne medicine, subspec. endokrinologije');

-- ───────────────────────────────────────────────────────────────
-- Spec. dr Darko Radinović — specijalista radiologije,
--                            subspecijalista interventne radiologije
-- ⚠️ Отдельной специальности «интервенционная радиология» в enums/specialty.ts
-- нет — субспециализация зафиксирована только в position.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Darko Radinović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Radinović Darko' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'darko-radinovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'darko-radinovic', 'Darko Radinović', 'Дарко Радиновић', 'Дарко Радинович', 'Darko Radinovic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 10);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista radiologije, subspecijalista interventne radiologije');

-- ───────────────────────────────────────────────────────────────
-- Dr Sanja Vrbica — spec. radiologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Sanja Vrbica' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vrbica Sanja' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'sanja-vrbica' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sanja-vrbica', 'Sanja Vrbica', 'Сања Врбица', 'Саня Врбица', 'Sanja Vrbica', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 10);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Spec. radiologije');

-- ───────────────────────────────────────────────────────────────
-- Dr Marina Mandarić — specijalista radiologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Marina Mandarić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mandarić Marina' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'marina-mandaric' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marina-mandaric', 'Marina Mandarić', 'Марина Мандарић', 'Марина Мандарич', 'Marina Mandaric', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 10);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista radiologije');

-- ───────────────────────────────────────────────────────────────
-- Prof. dr Dejan Nikolić — hirurg onkolog
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Dejan Nikolić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Nikolić Dejan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'dejan-nikolic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dejan-nikolic', 'Dejan Nikolić', 'Дејан Николић', 'Деян Николич', 'Dejan Nikolic', 'Prof. dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Hirurg onkolog, redovni profesor hirurgije i redovni član Medicinske akademije SLD. Osnivač je prvog Melanoma centra na Balkanu i predsjednik Srpskog udruženja za karcinome kože. Bavi se dijagnostikom i hirurškim liječenjem benignih i malignih promjena kože, mekih tkiva, dojke, štitaste žlijezde i limfnih čvorova. U poliklinici radi specijalističke preglede i konsultacije: pregled i procjena svih promjena na koži, pregled mladeža, dijagnostika melanoma i karcinoma kože, promjene na dojci i stručno drugo mišljenje, promjene štitaste žlijezde, uvećani limfni čvorovi, lipomi, ateromi, fibromi i tumori mekih tkiva.',
	description_sr_cyrl = 'Хирург онколог, редовни професор хирургије и редовни члан Медицинске академије СЛД. Оснивач је првог Меланома центра на Балкану и предсједник Српског удружења за карциноме коже. Бави се дијагностиком и хируршким лијечењем бенигних и малигних промјена коже, меких ткива, дојке, штитасте жлијезде и лимфних чворова. У поликлиници ради специјалистичке прегледе и консултације: преглед и процјена свих промјена на кожи, преглед младежа, дијагностика меланома и карцинома коже, промјене на дојци и стручно друго мишљење, промјене штитасте жлијезде, увећани лимфни чворови, липоми, атероми, фиброми и тумори меких ткива.',
	description_ru = 'Хирург-онколог, ординарный профессор хирургии и действительный член Медицинской академии Сербского врачебного общества (SLD). Основатель первого на Балканах центра меланомы и председатель Сербского общества по раку кожи. Занимается диагностикой и хирургическим лечением доброкачественных и злокачественных изменений кожи, мягких тканей, молочной железы, щитовидной железы и лимфатических узлов. В поликлинике ведёт специализированные приёмы и консультации: осмотр и оценка любых изменений кожи, осмотр родинок, диагностика меланомы и рака кожи, изменения молочной железы и экспертное второе мнение, изменения щитовидной железы, увеличенные лимфоузлы, липомы, атеромы, фибромы и опухоли мягких тканей.',
	description_en = 'Surgical oncologist, full professor of surgery and full member of the Medical Academy of the Serbian Medical Society. He founded the first Melanoma Centre in the Balkans and chairs the Serbian Association for Skin Cancer. His work covers the diagnosis and surgical treatment of benign and malignant lesions of the skin, soft tissue, breast, thyroid gland and lymph nodes. At the polyclinic he provides specialist examinations and consultations: assessment of any skin lesion, mole checks, diagnosis of melanoma and skin cancer, breast lesions and expert second opinions, thyroid lesions, enlarged lymph nodes, and lipomas, atheromas, fibromas and soft tissue tumours.',
	description_de = 'Chirurgischer Onkologe, ordentlicher Professor für Chirurgie und ordentliches Mitglied der Medizinischen Akademie der Serbischen Ärztegesellschaft. Er gründete das erste Melanomzentrum auf dem Balkan und ist Vorsitzender der Serbischen Gesellschaft für Hautkrebs. Sein Arbeitsgebiet ist die Diagnostik und chirurgische Behandlung gutartiger und bösartiger Veränderungen von Haut, Weichteilen, Brust, Schilddrüse und Lymphknoten. In der Poliklinik führt er fachärztliche Untersuchungen und Beratungen durch: Beurteilung aller Hautveränderungen, Muttermalkontrolle, Diagnostik von Melanom und Hautkrebs, Brustveränderungen und fachliche Zweitmeinung, Schilddrüsenveränderungen, vergrößerte Lymphknoten sowie Lipome, Atherome, Fibrome und Weichteiltumoren.',
	description_tr = 'Cerrahi onkolog, cerrahi profesörü ve Sırp Tabipler Birliği Tıp Akademisi asli üyesi. Balkanlar''daki ilk Melanom Merkezi''nin kurucusu ve Sırp Deri Kanseri Derneği başkanıdır. Derinin, yumuşak dokuların, memenin, tiroid bezinin ve lenf düğümlerinin iyi ve kötü huylu değişikliklerinin tanı ve cerrahi tedavisiyle ilgilenir. Poliklinikte uzman muayene ve konsültasyonlar yapar: her türlü deri lezyonunun değerlendirilmesi, ben kontrolü, melanom ve deri kanseri tanısı, meme lezyonları ve uzman ikinci görüş, tiroid lezyonları, büyümüş lenf düğümleri, lipom, ateroma, fibrom ve yumuşak doku tümörleri.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 77), (@doctor_id, 3);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Hirurg onkolog');

-- ───────────────────────────────────────────────────────────────
-- Prof. dr Vladimir Kovčin — spec. interne medicine, subspec. onkologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Vladimir Kovčin' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Kovčin Vladimir' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'vladimir-kovcin' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vladimir-kovcin', 'Vladimir Kovčin', 'Владимир Ковчин', 'Владимир Ковчин', 'Vladimir Kovcin', 'Prof. dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista interne medicine i subspecijalista kliničke onkologije sa više od 40 godina iskustva u dijagnostici i liječenju malignih oboljenja. Tokom karijere obavljao je funkcije direktora i načelnika u vodećim zdravstvenim ustanovama u Beogradu, uključujući KBC „Bežanijska Kosa“, Institut za onkologiju i radiologiju Srbije i privatni onkološki centar „Oncomed“. Vanredni je profesor onkologije i interne medicine, autor 6 monografija i 23 poglavlja u stručnim knjigama, sa preko 200 objavljenih naučnih radova i kongresnih saopštenja u zemlji i inostranstvu. U poliklinici radi subspecijalističke onkološke konsultacije i drugo mišljenje te konzilijarni pregled sa predlogom terapije.',
	description_sr_cyrl = 'Специјалиста интерне медицине и субспецијалиста клиничке онкологије са више од 40 година искуства у дијагностици и лијечењу малигних обољења. Током каријере обављао је функције директора и начелника у водећим здравственим установама у Београду, укључујући КБЦ „Бежанијска Коса“, Институт за онкологију и радиологију Србије и приватни онколошки центар „Oncomed“. Ванредни је професор онкологије и интерне медицине, аутор 6 монографија и 23 поглавља у стручним књигама, са преко 200 објављених научних радова и конгресних саопштења у земљи и иностранству. У поликлиници ради субспецијалистичке онколошке консултације и друго мишљење те конзилијарни преглед са предлогом терапије.',
	description_ru = 'Специалист по внутренним болезням и субспециалист по клинической онкологии с более чем 40-летним опытом диагностики и лечения злокачественных заболеваний. За время карьеры занимал должности директора и заведующего в ведущих медицинских учреждениях Белграда, включая КБЦ «Бежанийска Коса», Институт онкологии и радиологии Сербии и частный онкологический центр «Oncomed». Доцент онкологии и внутренних болезней, автор 6 монографий и 23 глав в специализированных книгах, свыше 200 опубликованных научных работ и докладов на конгрессах в стране и за рубежом. В поликлинике ведёт субспециализированные онкологические консультации и второе мнение, а также консилиарный приём с предложением терапии.',
	description_en = 'Specialist in internal medicine and subspecialist in clinical oncology with over 40 years of experience in diagnosing and treating malignant disease. During his career he held director and head-of-department posts at leading Belgrade healthcare institutions, including the Bežanijska Kosa Clinical Hospital Centre, the Institute for Oncology and Radiology of Serbia and the private oncology centre Oncomed. He is an associate professor of oncology and internal medicine, author of 6 monographs and 23 chapters in specialist books, with more than 200 published papers and congress presentations at home and abroad. At the polyclinic he provides subspecialist oncology consultations and second opinions, as well as multidisciplinary review with a treatment proposal.',
	description_de = 'Facharzt für Innere Medizin und Subspezialist für klinische Onkologie mit über 40 Jahren Erfahrung in Diagnostik und Behandlung bösartiger Erkrankungen. Im Laufe seiner Laufbahn leitete er Abteilungen und Häuser führender Belgrader Einrichtungen, darunter das Klinisch-Krankenhauszentrum „Bežanijska Kosa“, das Institut für Onkologie und Radiologie Serbiens und das private Onkologiezentrum „Oncomed“. Er ist außerordentlicher Professor für Onkologie und Innere Medizin, Autor von 6 Monographien und 23 Buchkapiteln mit über 200 veröffentlichten Arbeiten und Kongressbeiträgen im In- und Ausland. In der Poliklinik bietet er subspezialisierte onkologische Beratungen und Zweitmeinungen sowie eine konsiliarische Untersuchung mit Therapievorschlag an.',
	description_tr = 'İç hastalıkları uzmanı ve klinik onkoloji yan dal uzmanı; malign hastalıkların tanı ve tedavisinde 40 yılı aşkın deneyime sahiptir. Kariyeri boyunca Bežanijska Kosa Klinik Hastane Merkezi, Sırbistan Onkoloji ve Radyoloji Enstitüsü ve özel onkoloji merkezi Oncomed dahil olmak üzere Belgrad''ın önde gelen sağlık kuruluşlarında müdürlük ve başkanlık görevlerinde bulundu. Onkoloji ve iç hastalıkları doçentidir; 6 monografi ile uzmanlık kitaplarında 23 bölümün yazarı olup yurt içinde ve dışında 200''den fazla bilimsel makale ve kongre bildirisi yayımlamıştır. Poliklinikte yan dal onkoloji konsültasyonları ve ikinci görüş ile tedavi önerisi içeren konsey muayenesi yapmaktadır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 2), (@doctor_id, 47);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Spec. interne medicine, subspec. onkologije');

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

SELECT id, slug, status, city_id, name_sr, address_sr, phone, instagram FROM clinics WHERE id = @clinic_id;
SELECT clinic_type_id FROM clinic_clinic_types WHERE clinic_id = @clinic_id;
SELECT language_id, COUNT(*) AS cnt FROM clinic_languages WHERE clinic_id = @clinic_id GROUP BY language_id;

-- Ожидается 11 строк, у каждой непустой position и непустой список специальностей.
SELECT d.id, d.slug, d.name_sr, d.professional_title, dc.position,
	GROUP_CONCAT(ds.specialty_id ORDER BY ds.specialty_id) AS specialties
FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
WHERE dc.clinic_id = @clinic_id
GROUP BY d.id, d.slug, d.name_sr, d.professional_title, dc.position
ORDER BY d.id;
