-- ═══════════════════════════════════════════════════════════════════════════
-- SeaStars edukativni centar (Herceg Novi) — клиника + физиотерапевты
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-seastars-herceg-novi.sql
-- Затем: server/sql/insert-clinic-seastars-herceg-novi-services.sql
-- Запись импорта: data/clinic-imports/seastars-herceg-novi.json. Подволна 2d, агент U.
-- 
-- Источники (собрано 2026-10-09, сырой HTML curl с браузерным UA):
--   * https://seastarscentar.me/ — Zyro, 4 страницы (/, /o-centru, /tretmani, /kontakt), sitemap lastmod 2026-10-08, © 2025.
--     Цен нет. Отзывы на /o-centru и /tretmani — со стоковыми фото unsplash (шаблон), не используются.
--   * Google: два файла одного места (place_id ChIJL79BQtA7TBMRcOIzlP2p4sA) —
--     data/google-places/herceg-novi/seastars-edukativni-centar-za-skoliozu-i-ranu-djeciju-terapi.json (82 отзыва, полное имя)
--     и data/google-places/herceg-novi/seastars-edukativni-centar.json (79 отзывов, короткое имя, более ранний снимок).
--     Координаты 42.4568398 / 18.5295299, +382 67 044 114, «78 Orijenskog Bataljona, Herceg - Novi 85340».
-- 
-- Адрес: из Google. На /kontakt «Bulevar JNA 12, Herceg Novi» — в одном блоке с шаблонным текстом конструктора
-- («Nalazimo se u srcu Herceg Novog…», условия использования с builder-preview.com) и расходится с Google → не взят.
-- Название: Google «SeaStars “edukativni centar” za skoliozu i ranu dječiju terapiju», сайт «SeaStars edukativni centar».
-- Instagram в подвале — пустая ссылка https://www.instagram.com/ → не заведён. Индекс 85340 — Herceg Novi.
-- 
-- Идемпотентно и самоисправляюще: клиника ищется по google_place_id → slug → name_sr; пустые поля дозаполняются,
-- описание клиники пишется безусловно — правки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJL79BQtA7TBMRcOIzlP2p4sA';
SET @clinic_slug = 'seastars-herceg-novi';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('SeaStars edukativni centar', 'SeaStars “edukativni centar”', 'SeaStars “edukativni centar” za skoliozu i ranu dječiju terapiju', 'SeaStars') AND city_id = 8 LIMIT 1));

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
	8, -- CityId.HERCEG_NOVI
	'SeaStars edukativni centar',
	'SeaStars едукативни центар',
	'Центр SeaStars: сколиоз и ранняя детская терапия',
	'Orijenskog bataljona 78',
	'Оријенског батаљона 78',
	'',
	'',
	'85340',
	42.45683980,
	18.52952990,
	'+38267044114',
	'centarseastars@gmail.com',
	'https://seastarscentar.me/',
	'',
	'',
	'',
	'',
	'',
	'https://assets.zyrosite.com/fP5Q0oHiRvl7XULp/logo-1-OU28WRUrZ4XzfPUF.jpg',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.45683980, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 18.52952990, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'SeaStars едукативни центар', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Центр SeaStars: сколиоз и ранняя детская терапия', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Orijenskog bataljona 78', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Оријенског батаљона 78', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85340', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38267044114', phone),
	email = IF(email IS NULL OR email = '', 'centarseastars@gmail.com', email),
	website = IF(website IS NULL OR website = '', 'https://seastarscentar.me/', website),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://assets.zyrosite.com/fP5Q0oHiRvl7XULp/logo-1-OU28WRUrZ4XzfPUF.jpg', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'SeaStars edukativni centar u Herceg Novom namijenjen je bebama i djeci sa motoričkim izazovima: neurorizičnim bebama, bebama i djeci sa kašnjenjem u motorici i gruboj motorici, djeci sa posturalnim deformitetima (skolioza, kifoza, lordoza) i asimetričnim položajem glave i tijela, djeci sa smetnjama ravnoteže i problemima u hodu, djeci nakon povreda ili ortopedskih operacija i djeci sa neurološkim oboljenjima koja utiču na kretanje. Svako dijete dobija individualni plan tretmana prilagođen uzrastu, mogućnostima i ciljevima porodice; rad se odvija kroz igru i uz aktivno učešće roditelja, koji dobijaju smjernice i vježbe za rad kod kuće, a napredak se redovno procjenjuje. U ponudi su Schroth terapija skolioze, dinamička neuromuskularna stabilizacija (DNS), korektivna gimnastika, Vojta metoda, Bobath koncept, baby handling i masaža za bebe. Tim čine osnivačica centra Dragana Popović, neurorazvojni i ISST Schroth terapeut, i Ivana Vujisić, pedijatrijski fizioterapeut. Tretmani se planiraju u saradnji sa partnerskim centrom Stars Therapy iz Banje Koviljače, a svi tretmani se bilježe u digitalni karton dostupan roditeljima kroz mobilnu aplikaciju StarsRehabcare. Termin se zakazuje telefonom ili e-poštom; uput nije obavezan. Radno vrijeme: ponedjeljak–petak 9–17 h, subota 9–14 h.',
	description_sr_cyrl = 'SeaStars едукативни центар у Херцег Новом намијењен је бебама и дјеци са моторичким изазовима: неуроризичним бебама, бебама и дјеци са кашњењем у моторици и грубој моторици, дјеци са постуралним деформитетима (сколиоза, кифоза, лордоза) и асиметричним положајем главе и тијела, дјеци са сметњама равнотеже и проблемима у ходу, дјеци након повреда или ортопедских операција и дјеци са неуролошким обољењима која утичу на кретање. Свако дијете добија индивидуални план третмана прилагођен узрасту, могућностима и циљевима породице; рад се одвија кроз игру и уз активно учешће родитеља, који добијају смјернице и вјежбе за рад код куће, а напредак се редовно процјењује. У понуди су Schroth терапија сколиозе, динамичка неуромускуларна стабилизација (DNS), корективна гимнастика, Војта метода, Bobath концепт, baby handling и масажа за бебе. Тим чине оснивачица центра Драгана Поповић, неуроразвојни и ISST Schroth терапеут, и Ивана Вујисић, педијатријски физиотерапеут. Третмани се планирају у сарадњи са партнерским центром Stars Therapy из Бање Ковиљаче, а сви третмани се биљеже у дигитални картон доступан родитељима кроз мобилну апликацију StarsRehabcare. Термин се заказује телефоном или е-поштом; упут није обавезан. Радно вријеме: понедјељак–петак 9–17 х, субота 9–14 х.',
	description_ru = 'Образовательный центр SeaStars в Херцег-Нови работает с младенцами и детьми с двигательными трудностями: младенцами из группы неврологического риска, младенцами и детьми с задержкой моторного развития и крупной моторики, детьми с нарушениями осанки (сколиоз, кифоз, лордоз) и асимметричным положением головы и тела, с нарушениями равновесия и походки, после травм и ортопедических операций, а также с неврологическими заболеваниями, влияющими на движение. Для каждого ребёнка составляется индивидуальный план с учётом возраста, возможностей и целей семьи; занятия проходят в игровой форме и с активным участием родителей, которые получают рекомендации и упражнения для занятий дома, а прогресс регулярно оценивается. Доступны терапия сколиоза по Шроту, динамическая нейромышечная стабилизация (DNS), корригирующая гимнастика, Войта-терапия, Бобат-концепция, baby handling и массаж для младенцев. В команде — основательница центра Драгана Попович, нейроразвивающий терапевт и терапевт ISST Schroth, и Ивана Вуйисич, детский физиотерапевт. Программы планируются совместно с партнёрским центром Stars Therapy из Баня-Ковиляча, все занятия фиксируются в цифровой карте, доступной родителям в мобильном приложении StarsRehabcare. Запись по телефону или e-mail; направление не обязательно. Часы работы: понедельник–пятница 9–17, суббота 9–14.',
	description_en = 'SeaStars educational centre in Herceg Novi works with babies and children facing motor challenges: neurologically at-risk infants, babies and children with motor and gross motor delay, children with postural deformities (scoliosis, kyphosis, lordosis) and asymmetric head and body position, balance and gait problems, children after injuries or orthopaedic surgery, and children with neurological conditions affecting movement. Every child gets an individual treatment plan tailored to age, abilities and family goals; sessions are play-based and involve parents, who receive guidance and exercises for home, and progress is assessed regularly. Treatments include Schroth therapy for scoliosis, Dynamic Neuromuscular Stabilization (DNS), corrective exercises, Vojta therapy, the Bobath concept, baby handling and baby massage. The team consists of the centre’s founder Dragana Popović, a neurodevelopmental and ISST Schroth therapist, and Ivana Vujisić, a paediatric physiotherapist. Programmes are planned together with the partner centre Stars Therapy in Banja Koviljača, and all sessions are recorded in a digital file that parents can view in the StarsRehabcare mobile app. Appointments by phone or e-mail; a referral is not required. Opening hours: Monday–Friday 9:00–17:00, Saturday 9:00–14:00.',
	description_de = 'Das Bildungszentrum SeaStars in Herceg Novi betreut Babys und Kinder mit motorischen Schwierigkeiten: neurologisch gefährdete Säuglinge, Babys und Kinder mit verzögerter (Grob-)Motorik, Kinder mit Haltungsdeformitäten (Skoliose, Kyphose, Lordose) und asymmetrischer Kopf- und Körperhaltung, mit Gleichgewichts- und Gangstörungen, nach Verletzungen oder orthopädischen Operationen sowie Kinder mit neurologischen Erkrankungen, die die Bewegung beeinträchtigen. Jedes Kind erhält einen individuellen Behandlungsplan nach Alter, Möglichkeiten und Zielen der Familie; gearbeitet wird spielerisch und unter aktiver Beteiligung der Eltern, die Anleitungen und Übungen für zu Hause erhalten, der Fortschritt wird regelmäßig bewertet. Angeboten werden Schroth-Therapie bei Skoliose, Dynamische Neuromuskuläre Stabilisation (DNS), Korrekturgymnastik, Vojta-Therapie, Bobath-Konzept, Baby Handling und Babymassage. Zum Team gehören die Gründerin des Zentrums Dragana Popović, neuroentwicklungsorientierte und ISST-Schroth-Therapeutin, und Ivana Vujisić, Kinderphysiotherapeutin. Die Programme werden mit dem Partnerzentrum Stars Therapy in Banja Koviljača geplant, alle Behandlungen werden in einer digitalen Akte dokumentiert, die Eltern in der mobilen App StarsRehabcare einsehen können. Termine telefonisch oder per E-Mail; eine Überweisung ist nicht erforderlich. Öffnungszeiten: Montag–Freitag 9–17 Uhr, Samstag 9–14 Uhr.',
	description_tr = 'Herceg Novi''deki SeaStars eğitim merkezi, motor güçlükleri olan bebek ve çocuklarla çalışır: nörolojik risk taşıyan bebekler, motor ve kaba motor gelişimi geciken bebek ve çocuklar, postür bozukluğu (skolyoz, kifoz, lordoz) ve asimetrik baş ve gövde duruşu olan, denge ve yürüme sorunları yaşayan, yaralanma veya ortopedik ameliyat sonrası çocuklar ile hareketi etkileyen nörolojik hastalığı olan çocuklar. Her çocuk için yaşına, olanaklarına ve ailenin hedeflerine göre bireysel tedavi planı hazırlanır; seanslar oyun yoluyla ve evde çalışma için yönlendirme ve egzersiz alan ebeveynlerin aktif katılımıyla yürütülür, ilerleme düzenli olarak değerlendirilir. Skolyoz için Schroth terapisi, Dinamik Nöromüsküler Stabilizasyon (DNS), düzeltici jimnastik, Vojta terapisi, Bobath konsepti, baby handling ve bebek masajı sunulur. Ekipte merkezin kurucusu, nörogelişimsel ve ISST Schroth terapisti Dragana Popović ile çocuk fizyoterapisti Ivana Vujisić yer alır. Programlar Banja Koviljača''daki ortak merkez Stars Therapy ile birlikte planlanır; tüm seanslar ebeveynlerin StarsRehabcare mobil uygulamasından görebildiği dijital dosyaya kaydedilir. Randevu telefon veya e-posta ile alınır; sevk zorunlu değildir. Çalışma saatleri: pazartesi–cuma 9:00–17:00, cumartesi 9:00–14:00.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- PHYSIOTHERAPY_CLINIC = 24: центр детской физиотерапии (врачей-педиатров нет → не PEDIATRIC_CLINIC).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 24);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках → только SR (1).
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы: главная «Radno vreme — Pon–Pet: 09:00–17:00; Subota: 09:00–14:00» (Вс не назван → closed). На /kontakt другой блок «Radno Pon-Pet 08-16» — рядом с шаблонными текстами конструктора; взят блок главной (подробнее, с субботой).
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "14:00"}]}',
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
-- Физиотерапевты — специальность 94 = PHYSIOTHERAPY, professional_title NULL (не врачи), как в physiocare-team-podgorica.
-- Источник: /o-centru «Naš stručni tim — Dragana i Ivana». Обе в БД не найдены (локаль; прод-API 204) — новые.
-- Языки: 1 = SR (другие не заявлены). Фото — внешние URL сайта без параметров CDN-обрезки (200).

-- ───────────────────────────────────────────────────────────────
-- Dragana Popović — «Ja sam Popović Dragana, vaš neurorazvojni i ISST Schroth terapeut»; основательница («SeaStars Centar nastao je iz vizije da stvorim prostor…»).
-- Специальность 94 по косвенным признакам (решение юзера 2026-10-09): «neurorazvojni terapeut» (NDT) и ISST Schroth — методики физиотерапевтов; профессия прямо не названа.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Dragana Popović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Popović Dragana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'dragana-popovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dragana-popovic', 'Dragana Popović', 'Драгана Поповић', 'Драгана Попович', 'Dragana Popovic', NULL,
	'https://assets.zyrosite.com/fP5Q0oHiRvl7XULp/dragana-PmdfWqLD4FUI8mz6.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://assets.zyrosite.com/fP5Q0oHiRvl7XULp/dragana-PmdfWqLD4FUI8mz6.jpg', photo_url) WHERE id = @doctor_id;

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Neurorazvojni i ISST Schroth terapeut i osnivačica centra SeaStars. Znanje i iskustvo gradila je kroz dugogodišnji rad sa djecom i brojne stručne edukacije. Centar je osnovala sa idejom da stručnost, rana adekvatna terapija i edukacija roditelja budu dostupni svakom djetetu i porodici: kroz individualnu terapiju dijete dobija ciljani tretman, a roditelji alate i znanje da njegov razvoj podrže i kod kuće.',
	description_sr_cyrl = 'Неуроразвојни и ISST Schroth терапеут и оснивачица центра SeaStars. Знање и искуство градила је кроз дугогодишњи рад са дјецом и бројне стручне едукације. Центар је основала са идејом да стручност, рана адекватна терапија и едукација родитеља буду доступни сваком дјетету и породици: кроз индивидуалну терапију дијете добија циљани третман, а родитељи алате и знање да његов развој подрже и код куће.',
	description_ru = 'Нейроразвивающий терапевт и терапевт ISST Schroth, основательница центра SeaStars. Знания и опыт накопила за годы работы с детьми и многочисленные профессиональные обучения. Основала центр, чтобы квалифицированная помощь, ранняя терапия и обучение родителей были доступны каждому ребёнку и семье: на индивидуальных занятиях ребёнок получает целенаправленную терапию, а родители — инструменты и знания, чтобы поддерживать его развитие дома.',
	description_en = 'Neurodevelopmental and ISST Schroth therapist and founder of the SeaStars centre. She built her knowledge and experience through many years of work with children and numerous professional trainings. She founded the centre so that expertise, early appropriate therapy and parent education would be available to every child and family: in individual therapy the child receives targeted treatment, and parents get the tools and knowledge to support development at home.',
	description_de = 'Neuroentwicklungsorientierte und ISST-Schroth-Therapeutin, Gründerin des Zentrums SeaStars. Ihr Wissen und ihre Erfahrung hat sie in langjähriger Arbeit mit Kindern und zahlreichen Fortbildungen aufgebaut. Sie gründete das Zentrum, damit Fachkompetenz, frühe angemessene Therapie und Elternschulung jedem Kind und jeder Familie zugänglich sind: In der Einzeltherapie erhält das Kind eine gezielte Behandlung, die Eltern Werkzeuge und Wissen, um seine Entwicklung auch zu Hause zu unterstützen.',
	description_tr = 'Nörogelişimsel ve ISST Schroth terapisti, SeaStars merkezinin kurucusu. Bilgi ve deneyimini çocuklarla uzun yıllar süren çalışma ve çok sayıda mesleki eğitimle edindi. Merkezi, uzmanlığın, erken ve uygun terapinin ve ebeveyn eğitiminin her çocuk ve aile için erişilebilir olması amacıyla kurdu: bireysel terapide çocuk hedefe yönelik tedavi, ebeveynler ise gelişimini evde de destekleyecek araç ve bilgi alır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Neurorazvojni i ISST Schroth terapeut, osnivačica centra')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Ivana Vujisić — «Ivana Vujisić, pedijatrijski fizioterapeut». Тёзка-фамилия в БД (maja-vujisic) — другой человек.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Ivana Vujisić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vujisić Ivana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'ivana-vujisic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivana-vujisic', 'Ivana Vujisić', 'Ивана Вујисић', 'Ивана Вуйисич', 'Ivana Vujisic', NULL,
	'https://assets.zyrosite.com/fP5Q0oHiRvl7XULp/iva-mjxH5orII5lYAzEd.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://assets.zyrosite.com/fP5Q0oHiRvl7XULp/iva-mjxH5orII5lYAzEd.jpg', photo_url) WHERE id = @doctor_id;

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Pedijatrijski fizioterapeut, posvećena radu sa djecom i prepoznata po akademskim i istraživačkim dostignućima. U radu koristi aktivne i manuelne tehnike koje pomažu djeci da bolje osjete svoje tijelo i razviju motoričke sposobnosti; nježnim i ciljanim pokretima manuelna terapija podstiče ne samo motoričke i proprioceptivne, već i kognitivne i socijalne vještine djeteta.',
	description_sr_cyrl = 'Педијатријски физиотерапеут, посвећена раду са дјецом и препозната по академским и истраживачким достигнућима. У раду користи активне и мануелне технике које помажу дјеци да боље осјете своје тијело и развију моторичке способности; њежним и циљаним покретима мануелна терапија подстиче не само моторичке и проприоцептивне, већ и когнитивне и социјалне вјештине дјетета.',
	description_ru = 'Детский физиотерапевт, посвятившая себя работе с детьми и известная академическими и исследовательскими достижениями. В работе использует активные и мануальные техники, которые помогают детям лучше чувствовать своё тело и развивать двигательные навыки; мягкие и точные движения мануальной терапии развивают не только моторику и проприоцепцию, но и когнитивные и социальные навыки ребёнка.',
	description_en = 'Paediatric physiotherapist dedicated to working with children and recognised for her academic and research achievements. She uses active and manual techniques that help children sense their bodies better and develop motor skills; through gentle, targeted movements, manual therapy supports not only motor and proprioceptive but also cognitive and social skills.',
	description_de = 'Kinderphysiotherapeutin, die sich der Arbeit mit Kindern widmet und für ihre akademischen und wissenschaftlichen Leistungen bekannt ist. Sie nutzt aktive und manuelle Techniken, die Kindern helfen, ihren Körper besser wahrzunehmen und motorische Fähigkeiten zu entwickeln; mit sanften, gezielten Bewegungen fördert die manuelle Therapie nicht nur motorische und propriozeptive, sondern auch kognitive und soziale Fähigkeiten.',
	description_tr = 'Çocuklarla çalışmaya kendini adamış, akademik ve araştırma başarılarıyla tanınan çocuk fizyoterapisti. Çocukların bedenlerini daha iyi hissetmelerine ve motor becerilerini geliştirmelerine yardımcı olan aktif ve manuel teknikler kullanır; nazik ve hedefe yönelik hareketlerle manuel terapi yalnızca motor ve propriyoseptif değil, bilişsel ve sosyal becerileri de destekler.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Pedijatrijski fizioterapeut')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 8, status = published, clinic_languages = '1', clinic_types = '24', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 2: dragana-popovic (94), ivana-vujisic (94).
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
