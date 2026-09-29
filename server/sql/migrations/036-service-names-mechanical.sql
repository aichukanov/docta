-- 036: названия услуг — механические дефекты (шаг 1 из docs/audit/service-names-2026-09.md).
--
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/036-service-names-mechanical.sql
--
-- Собрано скриптом scripts/services/build-service-names-sql.mjs из
-- data/service-names/fix-*.json — руками не править, пересобирать.
--
-- Что чинится:
--   - русские названия, обрубленные на прилагательном без опорного слова
--     («Перелом пяточной» → «… пяточной кости»); в основном партия прайса FZOCG;
--   - экавица в name_sr (сайт на иекавице) и потерянная диакритика;
--   - name_sr_cyrl, разошедшийся с name_sr: латинская буква внутри кириллического
--     слова («Циркониjум» — такое слово не находится поиском), экавица в
--     кириллице при иекавской латинице, обрубленная кириллица, опечатки.
--     Ручная кириллица, которая честно транслитерирует латиницу («Ботокс»,
--     «Ашерман», «vena cava inferior»), сохраняется.
--
-- Строк: 778 (правки батчей — 178, только синхронизация кириллицы — 600).
-- Синонимов: 190 — старые name_en и экавские варианты исправленных name_sr,
-- чтобы прежние формулировки продолжали находиться.
--
-- Обновление по slug, а не по id: у локальной БД и прода разный автоинкремент.
-- Идемпотентно: присваиваются готовые значения, синонимы — INSERT IGNORE.
-- Применять ДО 037.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

START TRANSACTION;

UPDATE medical_services SET
	name_sr_cyrl = 'Цјелодневно или ноћно снимање ЕЕГ-а'
 WHERE slug = '24-hour-or-overnight-eeg-recording';

UPDATE medical_services SET
	name_sr_cyrl = 'Реконструкција аорте абдоминалис by-pass поступком (синтетски графт)'
 WHERE slug = 'abdominal-aorta-bypass-reconstruction-synthetic-graft';

UPDATE medical_services SET
	name_tr = 'Yamalı abdominal aort trombendarterektomi'
 WHERE slug = 'abdominal-aorta-thrombendarterectomy-with-patch';

UPDATE medical_services SET
	name_sr_cyrl = 'Експлорација абдоминалне аорте, висцералних артерија или вена или артерије и вене реналис',
	name_ru = 'Эксплорация брюшной аорты, висцеральных или почечных сосудов'
 WHERE slug = 'abdominal-aorta-visceral-or-renal-vessels-exploration';

UPDATE medical_services SET
	name_sr_cyrl = 'Одређивање крвне групе ABO/гел метода'
 WHERE slug = 'abo-blood-group-determination-gel-method';

UPDATE medical_services SET
	name_sr_cyrl = 'Ампутација ноге кроз фемур, било које висине'
 WHERE slug = 'above-knee-amputation-through-femur';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе еластицитета акомодације и конвергенције код акомодативних поремећаја'
 WHERE slug = 'accommodation-convergence-elasticity-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Артропластика ацетабулума и проксималног дијела фемура'
 WHERE slug = 'acetabulum-and-proximal-femur-arthroplasty';

UPDATE medical_services SET
	name_sr_cyrl = 'Чишћење акни и одстрањивање гнојних циста и комедона — по сеанси (max. 4)'
 WHERE slug = 'acne-cleansing-and-comedone-extraction-per-session';

UPDATE medical_services SET
	name_ru = 'Хирургическое лечение приобретённой уретроректальной фистулы'
 WHERE slug = 'acquired-urethrorectal-fistula-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Дислокација акромиоклавикуларног зглоба — затворена или отворена',
	name_ru = 'Лечение вывиха акромиально-ключичного сустава (закрытого или открытого)',
	name_de = 'Akromioklavikulargelenk-Luxation (geschlossen oder offen)',
	name_tr = 'Akromioklavikular eklem dislokasyonu (kapalı veya açık)'
 WHERE slug = 'acromioclavicular-joint-dislocation-open-or-closed';

UPDATE medical_services SET
	name_sr_cyrl = 'Активне вјежбе и вјежбе против отпора'
 WHERE slug = 'active-and-resistance-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Активно потпомогнуте вјежбе у води'
 WHERE slug = 'active-assisted-exercises-in-water';

UPDATE medical_services SET
	name_sr_cyrl = 'Активне сегментне вјежбе са дозираним оптерећењем'
 WHERE slug = 'active-segmental-exercises-with-graded-loading';

UPDATE medical_services SET
	name_sr_cyrl = 'Увјежбавање активности свакодневног живота према патолошким обрасцима'
 WHERE slug = 'activities-of-daily-living-training';

UPDATE medical_services SET
	name_sr_cyrl = 'Одстрањење акутног интрацеребралног хематома'
 WHERE slug = 'acute-intracerebral-hematoma-removal';

UPDATE medical_services SET
	name_sr = 'Liječenje hidrocefalusa kod odraslih',
	name_sr_cyrl = 'Лијечење хидроцефалуса код одраслих'
 WHERE slug = 'adult-hydrocephalus-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'All on 4 цирконијум протеза'
 WHERE slug = 'all-on-4-zirconia';

UPDATE medical_services SET
	name_sr_cyrl = 'All on 6 цирконијум протеза'
 WHERE slug = 'all-on-6-zirconia';

UPDATE medical_services SET
	name_sr_cyrl = 'Прелом-алвеоларног гребена'
 WHERE slug = 'alveolar-ridge-fracture-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење алвеолитиса'
 WHERE slug = 'alveolitis-treatment';

UPDATE medical_services SET
	name_en = 'Medium Outpatient Dressing',
	name_tr = 'Orta poliklinik pansumanı'
 WHERE slug = 'ambulatory-medium-dressing';

UPDATE medical_services SET
	name_sr_cyrl = 'Аналитички усмјерена психотерапија'
 WHERE slug = 'analytically-oriented-psychotherapy';

UPDATE medical_services SET
	name_sr_cyrl = 'Мјерење ankle-brachial индекса Доплер ултразвуком'
 WHERE slug = 'ankle-brachial-index-by-doppler-ultrasound';

UPDATE medical_services SET
	name_sr_cyrl = 'Дислокација зглоба глежња — затворена или отворена (сложена)'
 WHERE slug = 'ankle-joint-dislocation-closed-or-open';

UPDATE medical_services SET
	name_sr = 'Reparacija prednjeg i zadnjeg dijela vagine',
	name_sr_cyrl = 'Репарација предњег и задњег дијела вагине'
 WHERE slug = 'anterior-and-posterior-vaginal-wall-repair';

UPDATE medical_services SET
	name_sr = 'Reparacija prednjeg dijela vagine',
	name_sr_cyrl = 'Репарација предњег дијела вагине'
 WHERE slug = 'anterior-vaginal-wall-repair';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе против ARK у простору',
	name_ru = 'Упражнения в пространстве при аномальной ретинальной корреспонденции (АРК)'
 WHERE slug = 'anti-arc-spatial-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе против ARK у простору (методе елиминације)',
	name_ru = 'Упражнения при аномальной ретинальной корреспонденции (АРК), метод элиминации'
 WHERE slug = 'anti-arc-spatial-exercises-elimination-method';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе вида против супресије'
 WHERE slug = 'anti-suppression-vision-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Аортоилијацна лимфодисекција'
 WHERE slug = 'aortoiliac-lymph-node-dissection';

UPDATE medical_services SET
	name_sr_cyrl = 'APC коагулација танког цријева'
 WHERE slug = 'apc-coagulation-of-small-intestine';

UPDATE medical_services SET
	name_sr_cyrl = 'Замјена лука'
 WHERE slug = 'archwire-replacement';

UPDATE medical_services SET
	name_sr_cyrl = 'Ексклузија артериовенске фистуле (са или без реконструкције)'
 WHERE slug = 'arteriovenous-fistula-exclusion-withwithout-reconstruction';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе артикулације'
 WHERE slug = 'articulation-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Тоалета вјештачког ануса'
 WHERE slug = 'artificial-anus-care';

UPDATE medical_services SET
	name_sr_cyrl = 'Одстрањење вјештачког интраокуларног сочива'
 WHERE slug = 'artificial-intraocular-lens-removal';

UPDATE medical_services SET
	name_sr_cyrl = 'ASTO-LATEX',
	name_ru = 'АСЛО, латекс-тест'
 WHERE slug = 'aso-latex-test';

UPDATE medical_services SET
	name_sr_cyrl = 'Пункција и евакуација садржаја хидроцеле, фуникулоцеле, сперматоцеле или апсцеса скротума'
 WHERE slug = 'aspiration-of-hydrocele-funiculocele-spermatocele-or-scrotal-abscess';

UPDATE medical_services SET
	name_sr_cyrl = 'Потпомогнуте сегментне вјежбе'
 WHERE slug = 'assisted-segmental-exercises';

UPDATE medical_services SET
	name_sr = 'Liječenje autoimunih neuroloških oboljenja',
	name_sr_cyrl = 'Лијечење аутоимуних неуролошких обољења'
 WHERE slug = 'autoimmune-neurological-disease-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Ресекција и аутовенски графт екстракранијалних артерија (торакални дио)'
 WHERE slug = 'autovenous-graft-of-extracranial-arteries-thoracic';

UPDATE medical_services SET
	name_sr_cyrl = 'Ресекција и аутовенски графт артерије субклавије у грудном или подкључном дијелу'
 WHERE slug = 'autovenous-graft-of-subclavian-artery-thoracic-or-subclavian';

UPDATE medical_services SET
	name_ru = 'Резекция подколенной артерии или вены с аутовенозным или синтетическим протезированием'
 WHERE slug = 'autovenous-or-synthetic-graft-of-popliteal-artery-or-vein';

UPDATE medical_services SET
	name_ru = 'Аневризмэктомия и реконструкция подмышечной артерии'
 WHERE slug = 'axillary-aneurysmectomy-and-reconstruction';

UPDATE medical_services SET
	name_sr_cyrl = 'Реконструкција артерије или вене аксиларис синтетском протезом или аутовенским графтом'
 WHERE slug = 'axillary-artery-or-vein-reconstruction-with-synthetic-or-autovenous-graft';

UPDATE medical_services SET
	name_ru = 'Тромбэндартерэктомия подмышечной артерии с заплатой',
	name_tr = 'Yamalı aksiller arter trombendarterektomi'
 WHERE slug = 'axillary-artery-thrombendarterectomy-with-patch';

UPDATE medical_services SET
	name_sr_cyrl = 'Ексцизија синовијалне цисте поплитеалне јаме (Бакерова циста)'
 WHERE slug = 'baker-cyst-excision';

UPDATE medical_services SET
	name_sr_cyrl = 'Замјена прстена'
 WHERE slug = 'band-replacement';

UPDATE medical_services SET
	name_sr_cyrl = 'Инцизија и дренажа апсцеса Бартолинијеве жлијезде'
 WHERE slug = 'bartholin-gland-abscess-incision-and-drainage';

UPDATE medical_services SET
	name_sr_cyrl = 'Марсупијализација Бартолинијеве жлијезде'
 WHERE slug = 'bartholin-gland-marsupialization';

UPDATE medical_services SET
	name_sr_cyrl = 'Пункција Бартолинијеве жлијезде'
 WHERE slug = 'bartholin-gland-puncture';

UPDATE medical_services SET
	name_sr_cyrl = 'Репозиција — гипс имобилизација поткољенице (лонгета или пуни гипс)'
 WHERE slug = 'below-knee-plaster-reduction';

UPDATE medical_services SET
	name_sr_cyrl = 'Репозиција — гипс поткољенице за кретање'
 WHERE slug = 'below-knee-walking-cast';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура фаланге палца стопала — затворена или отворена'
 WHERE slug = 'big-toe-phalanx-fracture-reduction';

UPDATE medical_services SET
	name_sr_cyrl = 'Уретеропиелографија ретроградна билатерална код мушкараца или дјеце'
 WHERE slug = 'bilateral-retrograde-ureteropyelography-in-males-or-children';

UPDATE medical_services SET
	name_sr_cyrl = 'Сијалографија пљувачних жлијезда на обје стране'
 WHERE slug = 'bilateral-sialography';

UPDATE medical_services SET
	name_sr_cyrl = 'Одстрањивање аерационих цјевчица — обострано'
 WHERE slug = 'bilateral-tympanostomy-tube-removal';

UPDATE medical_services SET
	name_ru = 'Двусторонняя уретерокутанеостомия'
 WHERE slug = 'bilateral-ureterocutaneostomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Дренажа билијарног система под контролом ЦТ-а'
 WHERE slug = 'biliary-system-drainage-under-ct-guidance';

UPDATE medical_services SET
	name_sr_cyrl = 'Бималеоларна фрактура глежња — затворена или отворена са/без фиксације'
 WHERE slug = 'bimalleolar-ankle-fracture-open-or-closed-withwithout-fixation';

UPDATE medical_services SET
	name_sr_cyrl = 'Аудиометрија по Бéкéсyју'
 WHERE slug = 'bksy-audiometry';

UPDATE medical_services SET
	name_sr_cyrl = 'Електростимулација мокраћног мјехура'
 WHERE slug = 'bladder-electrical-stimulation';

UPDATE medical_services SET
	name_sr_cyrl = 'Оперативно лијечење екстрофије бешике — успостављање континуитета'
 WHERE slug = 'bladder-exstrophy-surgery';

UPDATE medical_services SET
	name_sr_cyrl = 'Оперативно лијечење екстрофије бешике — ресекција плус'
 WHERE slug = 'bladder-resection-plus-reconstruction-for-exstrophy';

UPDATE medical_services SET
	name_sr_cyrl = 'Каутеризација тумора мокраћне бешике код мушкарца или дјетета'
 WHERE slug = 'bladder-tumor-cauterization-in-males-or-children';

UPDATE medical_services SET
	name_sr = 'Analiza tjelesne kompozicije',
	name_sr_cyrl = 'Анализа тјелесне композиције'
 WHERE slug = 'body-composition-analysis';

UPDATE medical_services SET
	name_sr_cyrl = 'Праћење састава тијела (Body Analyzer)'
 WHERE slug = 'body-composition-analysis-follow-up';

UPDATE medical_services SET
	name_sr_cyrl = 'Контрола тјелесне тежине и састава тијела'
 WHERE slug = 'body-weight-and-composition-assessment';

UPDATE medical_services SET
	name_sr = 'Liječenje infekcija kostiju i zglobova',
	name_sr_cyrl = 'Лијечење инфекција костију и зглобова'
 WHERE slug = 'bone-and-joint-infection-treatment';

UPDATE medical_services SET
	name_sr = 'Liječenje tumora kosti i mekih tkiva',
	name_sr_cyrl = 'Лијечење тумора кости и меких ткива'
 WHERE slug = 'bone-and-soft-tissue-tumor-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Материјал за замјену кости'
 WHERE slug = 'bone-substitute-material';

UPDATE medical_services SET
	name_sr_cyrl = 'Дезинвагинација цријева (без ресекције)'
 WHERE slug = 'bowel-disinvagination-without-resection';

UPDATE medical_services SET
	name_sr_cyrl = 'Зашивање цријева са колостомијом'
 WHERE slug = 'bowel-suturing-with-colostomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Замјена бравице'
 WHERE slug = 'bracket-replacement';

UPDATE medical_services SET
	name_sr = 'Zamjena grudnih implantata',
	name_sr_cyrl = 'Замјена грудних имплантата'
 WHERE slug = 'breast-implant-replacement';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење стазе'
 WHERE slug = 'breast-stasis-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе дисања'
 WHERE slug = 'breathing-exercises';

UPDATE medical_services SET
	name_sr = 'Kratka konsultacija ljekara',
	name_sr_cyrl = 'Кратка консултација љекара'
 WHERE slug = 'brief-doctor-visit-consultation';

UPDATE medical_services SET
	name_ru = 'Закрытие бронхоплевральной фистулы'
 WHERE slug = 'bronchopleural-fistula-closure';

UPDATE medical_services SET
	name_sr = 'Operativno liječenje burzitisa',
	name_sr_cyrl = 'Оперативно лијечење бурзитиса'
 WHERE slug = 'bursitis-surgical-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Остеотомија — укључујући и унутрашњу фиксацију калканеуса'
 WHERE slug = 'calcaneal-osteotomy-with-internal-fixation';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура калканеуса — затворена или отворена (сложена)',
	name_ru = 'Лечение перелома пяточной кости (закрытого или открытого)',
	name_de = 'Calcaneusfraktur (geschlossen oder offen)',
	name_tr = 'Kalkaneus kırığı (kapalı veya açık)'
 WHERE slug = 'calcaneus-fracture-open-or-closed';

UPDATE medical_services SET
	name_sr = 'Ugradnja potkoljeničnih implantata',
	name_sr_cyrl = 'Уградња поткољеничних имплантата'
 WHERE slug = 'calf-implants';

UPDATE medical_services SET
	name_sr_cyrl = 'Капсулектомија — аспирација сочивних маса (операција ''меке мрене'')'
 WHERE slug = 'capsulectomy-with-lens-mass-aspiration-soft-cataract';

UPDATE medical_services SET
	name_sr_cyrl = 'Капсулотомија или капсулопластика код контрактуре интерфалангеалног зглоба',
	name_ru = 'Капсулотомия/капсулопластика при контрактуре межфалангового сустава',
	name_de = 'Kapsulotomie/Kapsuloplastik bei Kontraktur des Interphalangealgelenks',
	name_tr = 'İnterfalangeal eklem kontraktürü için kapsülotomi/kapsüloplasti'
 WHERE slug = 'capsulotomycapsuloplasty-for-interphalangeal-contracture';

UPDATE medical_services SET
	name_sr_cyrl = 'Транспозиција великих крвних судова — каротидно-субклавијална транспозиција'
 WHERE slug = 'carotid-subclavian-transposition';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура карпалне кости — затворена или отворена, отворена репозиција са Kirschner иглом'
 WHERE slug = 'carpal-bone-fracture-open-reduction-with-k-wire';

UPDATE medical_services SET
	name_sr_cyrl = 'Карпо-метакарпална дислокација палца — затворена или отворена'
 WHERE slug = 'carpometacarpal-thumb-joint-dislocation-reduction';

UPDATE medical_services SET
	name_sr_cyrl = 'Уклањање катаракте са уградњом торичног IQ сочива'
 WHERE slug = 'cataract-surgery-with-toric-iq-iol';

UPDATE medical_services SET
	name_sr_cyrl = 'Каутеризација, електрокаутеризација или криокаутеризација бенигних кожних промјена (опсежних)'
 WHERE slug = 'cauterization-electrocauterization-or-cryocauterization-of-benign-skin-lesions-extensive';

UPDATE medical_services SET
	name_sr_cyrl = 'Каутеризација, електрокаутеризација или криокаутеризација бенигних кожних промјена (већих)'
 WHERE slug = 'cauterization-electrocauterization-or-cryocauterization-of-benign-skin-lesions-larger';

UPDATE medical_services SET
	name_sr_cyrl = 'Каутеризација, електрокаутеризација или криокаутеризација бенигних кожних промјена (средњих)'
 WHERE slug = 'cauterization-electrocauterization-or-cryocauterization-of-benign-skin-lesions-medium';

UPDATE medical_services SET
	name_sr_cyrl = 'Каутеризација, електрокаутеризација или криокаутеризација бенигних кожних промјена (вишеструких)'
 WHERE slug = 'cauterization-electrocauterization-or-cryocauterization-of-benign-skin-lesions-multiple';

UPDATE medical_services SET
	name_sr_cyrl = 'Каутеризација, електрокаутеризација или криокаутеризација бенигних или премалигних кожних промјена (мањих)'
 WHERE slug = 'cauterization-electrocauterization-or-cryocauterization-of-benign-skin-lesions-small';

UPDATE medical_services SET
	name_sr = 'Liječenje cerebrovaskularnih bolesti',
	name_sr_cyrl = 'Лијечење цереброваскуларних болести'
 WHERE slug = 'cerebrovascular-disease-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Ресекција цервикса са ''отвореном бешиком'' — изолована операција'
 WHERE slug = 'cervical-resection-with-open-bladder-isolated-operation';

UPDATE medical_services SET
	name_sr_cyrl = 'Реконструкција крвних судова врата by-pass поступком (карот./верт.) синтетским графтом'
 WHERE slug = 'cervical-vessel-reconstruction-by-synthetic-bypass';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење халациона инјекцијама'
 WHERE slug = 'chalazion-injection-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Ампутација стопала кроз тарзус (Chopart тип)'
 WHERE slug = 'chopart-tarsal-amputation';

UPDATE medical_services SET
	name_sr_cyrl = 'Хронична хемодијализа — интермитентна замјена бубрежне функције'
 WHERE slug = 'chronic-hemodialysis-session';

UPDATE medical_services SET
	name_sr = 'Previjanje i liječenje hronične rane',
	name_sr_cyrl = 'Превијање и лијечење хроничне ране'
 WHERE slug = 'chronic-wound-treatment-and-dressing';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура клавикуле — затворена или отворена са/без унутрашње или спољне фиксације'
 WHERE slug = 'clavicle-fracture-closed-or-open-withwithout-fixation';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура клавикуле — отворена или затворена манипулативна репозиција'
 WHERE slug = 'clavicle-fracture-open-or-closed-manipulative-reduction';

UPDATE medical_services SET
	name_sr_cyrl = 'Клиничко испитивање процјене интелектуалног статуса'
 WHERE slug = 'clinical-intellectual-status-assessment';

UPDATE medical_services SET
	name_sr_cyrl = 'Затворена репозиција зглоба и примјена средства мобилизације'
 WHERE slug = 'closed-joint-reduction-with-mobilization';

UPDATE medical_services SET
	name_sr_cyrl = 'Затворена манипулативна репозиција фрактуре дисталног дијела поткољенице'
 WHERE slug = 'closed-manipulation-reduction-of-distal-tibia-fracture';

UPDATE medical_services SET
	name_en = 'Closed Manipulation Reduction of Proximal or Middle Finger Phalanx Fracture',
	name_sr = 'Zatvorena manipulativna repozicija frakture proksimalne ili srednje falange prstiju šake',
	name_sr_cyrl = 'Затворена манипулативна репозиција фрактуре проксималне или средње фаланге прстију шаке',
	name_ru = 'Закрытая репозиция перелома проксимальной или средней фаланги пальца кисти',
	name_de = 'Geschlossene Manipulationsreposition einer Fraktur der Grund- oder Mittelphalanx eines Fingers',
	name_tr = 'El parmağı proksimal veya orta falanks kırığının kapalı manipülatif redüksiyonu'
 WHERE slug = 'closed-manipulation-reduction-of-proximal-fracture';

UPDATE medical_services SET
	name_sr_cyrl = 'Затворена манипулативна репозиција фрактуре тибије — проксимални дио'
 WHERE slug = 'closed-manipulation-reduction-of-proximal-tibia-fracture';

UPDATE medical_services SET
	name_sr_cyrl = 'Затворена манипулативна репозиција фрактуре дијафизе поткољенице (тибије и фибуле)'
 WHERE slug = 'closed-manipulation-reduction-of-tibia-and-fibula-diaphysis-fracture';

UPDATE medical_services SET
	name_sr_cyrl = 'Затворена манипулативна репозиција фрактуре ацетабулума са тракцијом'
 WHERE slug = 'closed-manipulative-reduction-of-acetabular-fracture-with-traction';

UPDATE medical_services SET
	name_sr_cyrl = 'Затворена или отворена репозиција са/без унутрашње или спољне фиксације'
 WHERE slug = 'closed-or-open-reduction-withwithout-internalexternal-fixation';

UPDATE medical_services SET
	name_sr_cyrl = 'Репозиција свјежег прелома носних костију са имобилизацијом'
 WHERE slug = 'closed-reduction-of-recent-nasal-fracture-with-immobilization';

UPDATE medical_services SET
	name_sr_cyrl = 'Хладна коагулација промјена на грлићу материце'
 WHERE slug = 'cold-coagulation-of-cervical-lesions';

UPDATE medical_services SET
	name_sr_cyrl = 'Репарација колатералног или лигаментарног круцијата'
 WHERE slug = 'collateral-or-cruciate-ligament-repair';

UPDATE medical_services SET
	name_sr_cyrl = 'Преглед дебелог цријева кроз стому'
 WHERE slug = 'colon-x-ray-through-stoma';

UPDATE medical_services SET
	name_ru = 'Колоноскопия с биопсией толстой кишки и/или терминального отдела подвздошной кишки'
 WHERE slug = 'colonoscopy-with-biopsy-of-colon-andor-terminal-ileum';

UPDATE medical_services SET
	name_sr_cyrl = 'Испитивање осјетљивости на боје помоћу аномалоскопа'
 WHERE slug = 'color-sensitivity-test-with-anomaloscope';

UPDATE medical_services SET
	name_sr_cyrl = 'Испитивање осјетљивости на боје'
 WHERE slug = 'color-vision-test';

UPDATE medical_services SET
	name_sr_cyrl = 'Затварање колостоме успостављањем континуитета дебелог цријева'
 WHERE slug = 'colostomy-closure-with-bowel-continuity-restoration';

UPDATE medical_services SET
	name_sr_cyrl = 'Колотомија (за страна тијела, полипе и сл.)'
 WHERE slug = 'colotomy-for-foreign-body-polyp';

UPDATE medical_services SET
	name_sr_cyrl = 'Композитни испун на млијечном зубу'
 WHERE slug = 'composite-filling-on-primary-tooth';

UPDATE medical_services SET
	name_sr_cyrl = 'Композитни испун (естетска пломба) - једноповршински (Ivoclar EvoCeram)'
 WHERE slug = 'composite-filling-single-surface-ivoclar-evoceram';

UPDATE medical_services SET
	name_sr_cyrl = 'Композитни испун (естетска пломба) - троповршински (Ivoclar EvoCeram)'
 WHERE slug = 'composite-filling-three-surfaces-ivoclar-evoceram';

UPDATE medical_services SET
	name_sr_cyrl = 'Композитни испун (естетска пломба) - двоповршински (Ivoclar EvoCeram)'
 WHERE slug = 'composite-filling-two-surfaces-ivoclar-evoceram';

UPDATE medical_services SET
	name_sr = 'Kompleksna stomatološka dijagnostika sa planom liječenja',
	name_sr_cyrl = 'Комплексна стоматолошка дијагностика са планом лијечења'
 WHERE slug = 'comprehensive-dental-diagnostics-with-treatment-plan';

UPDATE medical_services SET
	name_sr = 'Liječenje urođenih deformiteta stopala kod djece',
	name_sr_cyrl = 'Лијечење урођених деформитета стопала код дјеце'
 WHERE slug = 'congenital-foot-deformity-treatment-in-children';

UPDATE medical_services SET
	name_sr_cyrl = 'Оперативно лијечење уретроректалних фистула — конгениталних, цјелокупно',
	name_ru = 'Хирургическое лечение врождённой уретроректальной фистулы'
 WHERE slug = 'congenital-urethrorectal-fistula-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Затварање конјунктивом ледираног рожњача (Kunth пластика конјунктиве)'
 WHERE slug = 'conjunctival-closure-of-damaged-cornea-kunth-plasty';

UPDATE medical_services SET
	name_ru = 'Конъюнктивопластика с забором и имплантацией трансплантата'
 WHERE slug = 'conjunctivoplasty-with-graft-harvesting-and-implantation';

UPDATE medical_services SET
	name_ru = 'Конъюнктивориностомия и кантоцистостомия'
 WHERE slug = 'conjunctivorhinostomy-and-cantocystostomy';

UPDATE medical_services SET
	name_sr = 'Liječenje poremećaja svijesti',
	name_sr_cyrl = 'Лијечење поремећаја свијести'
 WHERE slug = 'consciousness-disorder-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Конзервативно лијечење ороантралне комуникације'
 WHERE slug = 'conservative-treatment-of-oroantral-communication';

UPDATE medical_services SET
	name_sr_cyrl = 'Савјет педагогу школе или вртића'
 WHERE slug = 'consultation-for-school-or-kindergarten-educator';

UPDATE medical_services SET
	name_sr_cyrl = 'Примјена Континуирајућег позитивног притиска у дисајним путевима - CPAP'
 WHERE slug = 'continuous-positive-airway-pressure-cpap';

UPDATE medical_services SET
	name_sr_cyrl = 'Континуирана замјена бубрежне функције (CRRT)'
 WHERE slug = 'continuous-renal-replacement-therapy-crrt';

UPDATE medical_services SET
	name_ru = 'Удаление конвекситальной менингиомы'
 WHERE slug = 'convexity-meningioma-removal';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе на координатору'
 WHERE slug = 'coordinator-vision-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Екстракција страног тијела рожњаче са сидерозом (абразија)'
 WHERE slug = 'corneal-foreign-body-removal-with-siderosis-abrasion';

UPDATE medical_services SET
	name_sr_cyrl = 'Савјети родитељима'
 WHERE slug = 'counseling-for-parents';

UPDATE medical_services SET
	name_sr_cyrl = 'Cross, лиг. ВСМ, стрип. ВСМ и флебектомија површних вена доњих екстремитета'
 WHERE slug = 'crossectomy-gsv-ligation-stripping-and-phlebectomy-of-lower-limb';

UPDATE medical_services SET
	name_sr_cyrl = 'Интерреакција/гел метода'
 WHERE slug = 'crossmatch-test-gel-method';

UPDATE medical_services SET
	name_sr_cyrl = 'CRP-LATEX'
 WHERE slug = 'crp-latex-test';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура црурис — затворена или отворена са/без унутрашње или спољне фиксације'
 WHERE slug = 'crus-both-bones-fracture-reduction-withwithout-fixation';

UPDATE medical_services SET
	name_sr_cyrl = 'Екстензија цервикалне кичме по Кречфилду'
 WHERE slug = 'crutchfield-cervical-spine-traction';

UPDATE medical_services SET
	name_sr_cyrl = 'Оперативно лијечење криптохизма'
 WHERE slug = 'cryptorchism-surgical-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Циклодијализа или криоапликација или склеректомија постериор — смањење очног притиска',
	name_ru = 'Циклодиализ/криоаппликация/задняя склерэктомия'
 WHERE slug = 'cyclodialysis-or-cryoapplication-or-posterior-sclerectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Цистоскопија са биопсијом код мушкарца или дјетета'
 WHERE slug = 'cystoscopy-with-biopsy-in-males-or-children';

UPDATE medical_services SET
	name_sr_cyrl = 'Цитологија пунктата пљувачне жлијезде'
 WHERE slug = 'cytology-of-salivary-gland-punctate';

UPDATE medical_services SET
	name_sr_cyrl = 'Цитологија пунктата штитне жлијезде'
 WHERE slug = 'cytology-of-thyroid-punctate';

UPDATE medical_services SET
	name_sr_cyrl = 'Циторедукција + ХИПЕЦ'
 WHERE slug = 'cytoreduction-hipec';

UPDATE medical_services SET
	name_sr_cyrl = 'Дакриоцисториностомија',
	name_ru = 'Дакриоцисториностомия'
 WHERE slug = 'dacryocystorhinostomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Дакриоцисториностомија са репарацијом сузног канала силиконском цјевчицом'
 WHERE slug = 'dacryocystorhinostomy-with-silicone-tube-lacrimal-repair';

UPDATE medical_services SET
	name_sr_cyrl = 'Примјена терапије кроз дневну болницу за дјецу узраста од 1 мес. до 7 г. (УКЦЦГ)'
 WHERE slug = 'day-hospital-therapy-administration-for-children-aged-1-month-to-7-years-ukccg';

UPDATE medical_services SET
	name_sr_cyrl = 'Примјена терапије кроз дневну болницу за старије од 7 г. (УКЦЦГ)'
 WHERE slug = 'day-hospital-therapy-administration-for-patients-older-than-7-years-ukccg';

UPDATE medical_services SET
	name_sr_cyrl = 'Дефектолошки или логопедски третман дјетета са ПСП'
 WHERE slug = 'defectological-or-speech-therapy-treatment-of-a-child-with-pdd';

UPDATE medical_services SET
	name_sr_cyrl = 'Дефектолошко-логопедски третман дјетета са сметњама'
 WHERE slug = 'defectological-speech-therapy-treatment-of-a-child-with-disabilities';

UPDATE medical_services SET
	name_sr = 'Liječenje degenerativnih bolesti kičme',
	name_sr_cyrl = 'Лијечење дегенеративних болести кичме'
 WHERE slug = 'degenerative-spine-disease-treatment';

UPDATE medical_services SET
	name_sr = 'Liječenje karijesa',
	name_sr_cyrl = 'Лијечење каријеса'
 WHERE slug = 'dental-caries-treatment';

UPDATE medical_services SET
	name_sr = 'Konsultacija sa planom liječenja',
	name_sr_cyrl = 'Консултација са планом лијечења'
 WHERE slug = 'dental-consultation-with-treatment-plan';

UPDATE medical_services SET
	name_sr = 'Dijagnostika i planiranje liječenja',
	name_sr_cyrl = 'Дијагностика и планирање лијечења'
 WHERE slug = 'dental-diagnostics-and-treatment-planning';

UPDATE medical_services SET
	name_sr_cyrl = 'Депресивна фрактура са озљедом dura matris и великих венских крвних судова'
 WHERE slug = 'depressed-fracture-with-dural-and-major-venous-injury';

UPDATE medical_services SET
	name_sr_cyrl = 'Депресивна фрактура кости лобање (са или без повреде дура матер)'
 WHERE slug = 'depressed-skull-fracture-withwithout-dural-injury';

UPDATE medical_services SET
	name_sr = 'Liječenje razvojnog poremećaja kuka kod djece',
	name_sr_cyrl = 'Лијечење развојног поремећаја кука код дјеце'
 WHERE slug = 'developmental-hip-dysplasia-treatment-in-children';

UPDATE medical_services SET
	name_ru = 'Герниопластика диафрагмальная абдоминальным доступом'
 WHERE slug = 'diaphragmatic-hernioplasty-abdominal-approach';

UPDATE medical_services SET
	name_sr_cyrl = 'Дигитални дизајн осмијеха'
 WHERE slug = 'digital-smile-design';

UPDATE medical_services SET
	name_sr_cyrl = 'Директан Кумбсов тест/гел метода'
 WHERE slug = 'direct-coombs-test-gel-method';

UPDATE medical_services SET
	name_sr_cyrl = 'Директна ларингоскопија са вађењем страног тијела'
 WHERE slug = 'direct-laryngoscopy-with-foreign-body-extraction';

UPDATE medical_services SET
	name_sr_cyrl = 'Одстрањење хернијације интервертебралног диска код истовремене стенозе спиналног канала или хернијације у више нивоа'
 WHERE slug = 'disc-herniation-removal-with-spinal-stenosis-or-multi-level';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура дисталне епифизе радиуса — отворена или затворена',
	name_ru = 'Репозиция перелома дистального эпифиза лучевой кости (открытая или закрытая)',
	name_de = 'Distale Radiusepiphysenfraktur (offene oder geschlossene Reposition)',
	name_tr = 'Distal radius epifiz kırığı (açık veya kapalı redüksiyon)'
 WHERE slug = 'distal-radial-epiphysis-fracture-open-or-closed-reduction';

UPDATE medical_services SET
	name_sr_cyrl = 'Дислокација дисталног тибиофибуларног зглоба — затворена или отворена',
	name_ru = 'Лечение вывиха дистального тибиофибулярного сустава (закрытого или открытого)'
 WHERE slug = 'distal-tibiofibular-joint-dislocation';

UPDATE medical_services SET
	name_sr_cyrl = 'Ексцизија полипа уретре у дисталном дијелу'
 WHERE slug = 'distal-urethral-polyp-excision';

UPDATE medical_services SET
	name_sr_cyrl = 'DBE (double balloon ентероскопија) танког цријева'
 WHERE slug = 'double-balloon-enteroscopy-of-small-intestine';

UPDATE medical_services SET
	name_sr_cyrl = 'Апликација лијека у грлић материце'
 WHERE slug = 'drug-application-to-cervix';

UPDATE medical_services SET
	name_sr_cyrl = 'Апликација лијека у уво и нос'
 WHERE slug = 'drug-application-to-ear-and-nose';

UPDATE medical_services SET
	name_sr_cyrl = 'DXA — вертеброморфометрија'
 WHERE slug = 'dxa-vertebral-morphometry';

UPDATE medical_services SET
	name_sr_cyrl = 'Извођење динамских тестова за испитивање надбубрежних жлијезда'
 WHERE slug = 'dynamic-adrenal-function-tests';

UPDATE medical_services SET
	name_sr_cyrl = 'Динамска сцинтиграфија пљувачних жлијезда'
 WHERE slug = 'dynamic-salivary-gland-scintigraphy';

UPDATE medical_services SET
	name_sr_cyrl = 'Динамска сцинтиграфија трансплантираног бубрега'
 WHERE slug = 'dynamic-scintigraphy-of-transplanted-kidney';

UPDATE medical_services SET
	name_sr_cyrl = 'Динамска сцинтиграфија штитасте жлијезде'
 WHERE slug = 'dynamic-thyroid-scintigraphy';

UPDATE medical_services SET
	name_sr_cyrl = 'Узимање отиска уха за слушни апарат'
 WHERE slug = 'ear-impression-for-hearing-aid';

UPDATE medical_services SET
	name_sr_cyrl = 'Одстрањивање полипа из уха'
 WHERE slug = 'ear-polyp-removal';

UPDATE medical_services SET
	name_sr = 'EEG poslije deprivacije sna',
	name_sr_cyrl = 'ЕЕГ послије депривације сна'
 WHERE slug = 'eeg-after-sleep-deprivation';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура лакта (фрактура проксималног краја улне са дислокацијом главе радиуса)',
	name_ru = 'Лечение перелома проксимального отдела локтевой кости с вывихом головки лучевой кости',
	name_tr = 'Dirsek kırığı (radius başı dislokasyonlu proksimal ulna kırığı)'
 WHERE slug = 'elbow-fracture-proximal-ulna-with-radial-head-dislocation';

UPDATE medical_services SET
	name_sr_cyrl = 'Артротомија (капсулотомија) лакатног зглоба са експлорацијом'
 WHERE slug = 'elbow-joint-arthrotomy-capsulotomy-with-exploration';

UPDATE medical_services SET
	name_sr_cyrl = 'Испитивање електричне подражљивости живаца и мишића примјеном фарадских и галванских струја'
 WHERE slug = 'electrical-excitability-test-of-nerves-and-muscles-with-faradic-and-galvanic-currents';

UPDATE medical_services SET
	name_sr_cyrl = 'Електрокохлеографија дјеце'
 WHERE slug = 'electrocochleography-in-children';

UPDATE medical_services SET
	name_sr_cyrl = 'Хитна торакотомија због одстрањивања грумена крви и крвављења'
 WHERE slug = 'emergency-thoracotomy-for-hemorrhage-control';

UPDATE medical_services SET
	name_sr = 'Endodontsko liječenje višekanalnih zuba',
	name_sr_cyrl = 'Ендодонтско лијечење вишеканалних зуба'
 WHERE slug = 'endodontic-treatment-multi-canal-tooth';

UPDATE medical_services SET
	name_sr = 'Endodontsko liječenje jednokanalnih zuba',
	name_sr_cyrl = 'Ендодонтско лијечење једноканалних зуба'
 WHERE slug = 'endodontic-treatment-single-canal-tooth';

UPDATE medical_services SET
	name_sr_cyrl = 'Ендоназална екстирпација страног тијела из носа'
 WHERE slug = 'endonasal-foreign-body-extraction';

UPDATE medical_services SET
	name_sr_cyrl = 'Ендоназална хируршка екстракција ринолита или страног тијела'
 WHERE slug = 'endonasal-surgical-rhinolith-or-foreign-body-extraction';

UPDATE medical_services SET
	name_sr_cyrl = 'Ендоскопска ексцизија промјена на зиду трахеје'
 WHERE slug = 'endoscopic-excision-of-tracheal-wall-lesions';

UPDATE medical_services SET
	name_sr_cyrl = 'Вађење страног тијела из ректума ендоскопским путем'
 WHERE slug = 'endoscopic-foreign-body-removal-from-rectum';

UPDATE medical_services SET
	name_sr_cyrl = 'Ендоскопска ласер ресекција промјена на трахеји'
 WHERE slug = 'endoscopic-laser-resection-of-tracheal-lesions';

UPDATE medical_services SET
	name_sr_cyrl = 'Ендоскопска терапија цистичне дилатације доњег дијела уретера — процедура А'
 WHERE slug = 'endoscopic-therapy-of-lower-ureter-cystic-dilatation-procedure-a';

UPDATE medical_services SET
	name_sr_cyrl = 'Ендоскопска терапија цистичне дилатације доњег дијела уретера — процедура Б'
 WHERE slug = 'endoscopic-therapy-of-lower-ureter-cystic-dilatation-procedure-b';

UPDATE medical_services SET
	name_sr_cyrl = 'Ендоскопско одстрањење страног тијела из трахеје'
 WHERE slug = 'endoscopic-tracheal-foreign-body-removal';

UPDATE medical_services SET
	name_sr_cyrl = 'Ендоскопска апликација трахеалног стента (обложени или необложени стент)'
 WHERE slug = 'endoscopic-tracheal-stent-application';

UPDATE medical_services SET
	name_ru = 'Эндоваскулярная установка стент-графта в подвздошные артерии'
 WHERE slug = 'endovascular-stent-graft-in-iliac-arteries';

UPDATE medical_services SET
	name_sr_cyrl = 'Ендоваскуларна процедура — пласирање стент графта у грудну (торакалну) аорту'
 WHERE slug = 'endovascular-stent-graft-in-thoracic-aorta';

UPDATE medical_services SET
	name_sr_cyrl = 'Ентеротомија ради полипа или вађења страног тијела'
 WHERE slug = 'enterotomy-for-polyp-or-foreign-body';

UPDATE medical_services SET
	name_sr_cyrl = 'Увјежбавање езофагусног говора'
 WHERE slug = 'esophageal-speech-training';

UPDATE medical_services SET
	name_sr_cyrl = 'Езофагогастректомија с лапаротомијом и одвојеном торакотомијом са примарном интраторакалном анастомозом'
 WHERE slug = 'esophagogastrectomy-with-laparotomy-separate-thoracotomy-intrathoracic-anastomosis';

UPDATE medical_services SET
	name_en = 'Esophagogastrectomy with Laparotomy, Thoracotomy and Cervical Esophagogastrostomy',
	name_sr = 'Ezofagogastrektomija s laparotomijom, torakotomijom i ezofagogastrostomijom na vratu',
	name_sr_cyrl = 'Езофагогастректомија с лапаротомијом, торакотомијом и езофагогастростомијом на врату',
	name_ru = 'Эзофагогастрэктомия с лапаротомией, торакотомией и шейным эзофагогастроанастомозом',
	name_de = 'Ösophagogastrektomie mit Laparotomie, Thorakotomie und zervikaler Ösophagogastrostomie',
	name_tr = 'Laparotomi, torakotomi ve servikal özofagogastrostomi ile özofagogastrektomi'
 WHERE slug = 'esophagogastrectomy-with-laparotomy-thoracotomy-cervical-esophagostomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Езофагогастродуоденоскопија са екстракцијом страног тијела'
 WHERE slug = 'esophagogastroduodenoscopy-with-foreign-body-extraction';

UPDATE medical_services SET
	name_sr_cyrl = 'Ресекција езофагуса са термино-терминалном анастомозом, операција атрезије'
 WHERE slug = 'esophagus-resection-with-end-to-end-anastomosis-atresia-surgery';

UPDATE medical_services SET
	name_sr_cyrl = 'Евакуација хидатидне цисте јетре (сутура билијарних комуникација) — мале (до 10 цм у пречнику)'
 WHERE slug = 'evacuation-of-liver-hydatid-cyst-small-up-to-10-cm';

UPDATE medical_services SET
	name_sr_cyrl = 'Ексцизија бенигних лезија, фиброзних и цистичних промјена'
 WHERE slug = 'excision-of-benign-fibrous-and-cystic-lesions';

UPDATE medical_services SET
	name_sr_cyrl = 'Ексцизија цисте или бенигног тумора (нпр. крило бедрене кости) са или без аутографта'
 WHERE slug = 'excision-of-cyst-or-benign-tumor-iliac-crest-etc-withwithout-autograft';

UPDATE medical_services SET
	name_sr_cyrl = 'Екстирпација атерома, цисте или мањег бенигног тумора ува'
 WHERE slug = 'excision-of-ear-atheroma-cyst-or-small-benign-tumor';

UPDATE medical_services SET
	name_sr_cyrl = 'Ексцизија тетиве флексора длана — више ексцизија'
 WHERE slug = 'excision-of-multiple-hand-flexor-tendons';

UPDATE medical_services SET
	name_ru = 'Иссечение кисты/опухоли лучевой или локтевой кости'
 WHERE slug = 'excision-of-radius-or-ulna-cyst-or-benign-tumor';

UPDATE medical_services SET
	name_sr_cyrl = 'Ексцизија мањих бенигних туморозних ожиљака, фиброзних, цистичних промјена'
 WHERE slug = 'excision-of-small-benign-tumor-scars-fibromas-or-cysts';

UPDATE medical_services SET
	name_sr_cyrl = 'Ексцизија малих бенигних тумора уретре (чворића)'
 WHERE slug = 'excision-of-small-benign-urethral-tumors';

UPDATE medical_services SET
	name_sr_cyrl = 'Ексцизија лезија тетивног омотача или капсуле (нпр. циста или ганглион) поткољенице/стопала'
 WHERE slug = 'excision-of-tendon-sheath-or-capsule-lesion-cyst-ganglion';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе на справама: пулиа или ергобицикл, кинетичка шина, суспензија'
 WHERE slug = 'exercises-on-equipment-pulley-ergocycle-cpm-suspension';

UPDATE medical_services SET
	name_ru = 'Эксплоративная тораколапаротомия'
 WHERE slug = 'exploratory-thoracolaparotomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Спољашња фистулизација дебелог цријева'
 WHERE slug = 'external-colonic-fistulization';

UPDATE medical_services SET
	name_sr_cyrl = 'Спољашња фистулизација танког и дебелог цријева због улцерозног колитиса'
 WHERE slug = 'external-fistulization-of-small-and-large-bowel-for-ulcerative-colitis';

UPDATE medical_services SET
	name_sr_cyrl = 'Спољашња фистулизација танког цријева'
 WHERE slug = 'external-small-bowel-fistulization';

UPDATE medical_services SET
	name_sr_cyrl = 'Тромбендартеректомија екстракранијалних артерија (вратни дио)'
 WHERE slug = 'extracranial-artery-thrombendarterectomy-cervical';

UPDATE medical_services SET
	name_sr_cyrl = 'Тромбендартеректомија екстракранијалних артерија (торакални дио)'
 WHERE slug = 'extracranial-artery-thrombendarterectomy-thoracic';

UPDATE medical_services SET
	name_ru = 'Тромбэндартерэктомия экстракраниальных артерий с пластикой заплатой',
	name_tr = 'Yamalı ekstrakranial arter trombendarterektomi'
 WHERE slug = 'extracranial-artery-thrombendarterectomy-with-patch';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе координације покрета екстремитета и баланса хода'
 WHERE slug = 'extremity-coordination-and-gait-balance-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Евисцерација булбуса ока (евакуација очног садржаја)'
 WHERE slug = 'eye-evisceration';

UPDATE medical_services SET
	name_sr_cyrl = 'Одређивање наочара на уску зјеницу са астигматизмом'
 WHERE slug = 'eyeglass-determination-narrow-pupil-with-astigmatism';

UPDATE medical_services SET
	name_sr_cyrl = 'Одређивање наочара на уску зјеницу без астигматизма'
 WHERE slug = 'eyeglass-determination-narrow-pupil-without-astigmatism';

UPDATE medical_services SET
	name_sr_cyrl = 'Одређивање и прописивање наочара за дјецу'
 WHERE slug = 'eyeglass-prescription-for-children';

UPDATE medical_services SET
	name_sr = 'Lifting lica sa transferom masti iz drugih regija tijela',
	name_sr_cyrl = 'Lifting лица са трансфером масти из других регија тијела'
 WHERE slug = 'face-lift-with-fat-transfer';

UPDATE medical_services SET
	name_sr_cyrl = 'Инфилтрација лијека код лезије n. facialis'
 WHERE slug = 'facial-nerve-lesion-drug-infiltration';

UPDATE medical_services SET
	name_sr_cyrl = 'Реконструкција уретре код жене — цјелокупно лијечење'
 WHERE slug = 'female-urethral-reconstruction-complete-treatment';

UPDATE medical_services SET
	name_ru = 'Аневризмэктомия и реконструкция бедренной артерии'
 WHERE slug = 'femoral-artery-aneurysmectomy-and-reconstruction';

UPDATE medical_services SET
	name_sr = 'Trombendarterektomija sa patch-plastikom femoralne arterije',
	name_sr_cyrl = 'Тромбендартеректомија са patch-пластиком феморалне артерије',
	name_ru = 'Тромбэндартерэктомия бедренной артерии с заплатой',
	name_tr = 'Yamalı femoral arter trombendarterektomi'
 WHERE slug = 'femoral-artery-thrombendarterectomy-with-patch';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактуре фемура — затворена или отворена (сложена) репозиција са/без унутрашње фиксације'
 WHERE slug = 'femur-fracture-reduction-closed-or-open';

UPDATE medical_services SET
	name_sr_cyrl = 'Фибероптичка ларингоскопија'
 WHERE slug = 'fiberoptic-laryngoscopy';

UPDATE medical_services SET
	name_sr_cyrl = 'Фибероптички преглед фаринкса'
 WHERE slug = 'fiberoptic-pharyngoscopy';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура фибуле — затворена или отворена са/без фиксације',
	name_ru = 'Репозиция перелома малоберцовой кости (закрытого или открытого) с фиксацией или без',
	name_de = 'Fibulafraktur (geschlossen oder offen), Reposition mit oder ohne Fixation',
	name_tr = 'Fibula kırığı (kapalı veya açık), redüksiyon, fiksasyonlu veya fiksasyonsuz'
 WHERE slug = 'fibula-fracture-reduction-withwithout-fixation';

UPDATE medical_services SET
	name_sr_cyrl = 'Ампутација прста шаке било којег зглоба или фаланге — једна'
 WHERE slug = 'finger-amputation-at-any-phalanx';

UPDATE medical_services SET
	name_sr_cyrl = 'Први преглед неурохирурга'
 WHERE slug = 'first-neurosurgeon-examination';

UPDATE medical_services SET
	name_sr_cyrl = 'Први специјалистички преглед у дјечијој и адолесцентној доби'
 WHERE slug = 'first-pediatric-and-adolescent-gynecology-examination';

UPDATE medical_services SET
	name_sr_cyrl = 'Први преглед дјетета - дјечији ендокринолог'
 WHERE slug = 'first-pediatric-endocrinologist-examination';

UPDATE medical_services SET
	name_sr_cyrl = 'Први преглед одојчета - дјечији ендокринолог'
 WHERE slug = 'first-pediatric-endocrinologist-examination-infant';

UPDATE medical_services SET
	name_sr_cyrl = 'Први преглед дјетета - педијатар'
 WHERE slug = 'first-pediatric-examination';

UPDATE medical_services SET
	name_sr_cyrl = 'Први преглед дјетета - дјечији нефролог'
 WHERE slug = 'first-pediatric-nephrologist-examination';

UPDATE medical_services SET
	name_sr_cyrl = 'Први преглед одојчета - дјечији нефролог'
 WHERE slug = 'first-pediatric-nephrologist-examination-infant';

UPDATE medical_services SET
	name_sr = 'Prvi kontrolni pregled nakon početka liječenja',
	name_sr_cyrl = 'Први контролни преглед након почетка лијечења'
 WHERE slug = 'first-treatment-follow-up';

UPDATE medical_services SET
	name_sr_cyrl = 'Довршавање инкомплетног побачаја до 3 мјесеца — киретажа'
 WHERE slug = 'first-trimester-incomplete-abortion-curettage';

UPDATE medical_services SET
	name_sr_cyrl = 'Артефицијални прекид трудноће до 3 мјесеца — киретажа'
 WHERE slug = 'first-trimester-surgical-abortion-curettage';

UPDATE medical_services SET
	name_sr_cyrl = 'Фиксациони трансдуцер за континуирано мјерење интракранијалног притиска код различитих етиологија'
 WHERE slug = 'fixation-transducer-for-icp-monitoring-in-various-etiologies';

UPDATE medical_services SET
	name_sr = 'Kontrolni pregled opšteg ljekara',
	name_sr_cyrl = 'Контролни преглед општег љекара'
 WHERE slug = 'follow-up-general-practitioner-examination';

UPDATE medical_services SET
	name_sr_cyrl = 'Контролни преглед неурохирурга'
 WHERE slug = 'follow-up-neurosurgeon-examination';

UPDATE medical_services SET
	name_sr_cyrl = 'Поновни специјалистички преглед у дјечијој и адолесцентној доби'
 WHERE slug = 'follow-up-pediatric-and-adolescent-gynecology-examination';

UPDATE medical_services SET
	name_sr_cyrl = 'Поновни преглед дјетета - дјечији ендокринолог'
 WHERE slug = 'follow-up-pediatric-endocrinologist-examination';

UPDATE medical_services SET
	name_sr_cyrl = 'Поновни преглед одојчета - дјечији ендокринолог'
 WHERE slug = 'follow-up-pediatric-endocrinologist-examination-infant';

UPDATE medical_services SET
	name_sr_cyrl = 'Поновни преглед дјетета - дјечији нефролог'
 WHERE slug = 'follow-up-pediatric-nephrologist-examination';

UPDATE medical_services SET
	name_sr_cyrl = 'Поновни преглед одојчета - дјечији нефролог'
 WHERE slug = 'follow-up-pediatric-nephrologist-examination-infant';

UPDATE medical_services SET
	name_sr_cyrl = 'Репарација/сутура флексор тетива стопала, примарна или секундарна, једна или више'
 WHERE slug = 'foot-flexor-tendon-repair-primary-or-secondary-one-or-more';

UPDATE medical_services SET
	name_sr_cyrl = 'Тенолиза флексора стопала, једна или више'
 WHERE slug = 'foot-flexor-tenolysis-one-or-more';

UPDATE medical_services SET
	name_sr_cyrl = 'Екстирпација страног тијела лица'
 WHERE slug = 'foreign-body-extraction-from-face';

UPDATE medical_services SET
	name_sr_cyrl = 'Екстракција страног тијела средње уретре'
 WHERE slug = 'foreign-body-extraction-from-mid-urethra';

UPDATE medical_services SET
	name_sr_cyrl = 'Екстракција страног тијела меких дјелова главе и врата'
 WHERE slug = 'foreign-body-extraction-from-soft-tissues-of-head-and-neck';

UPDATE medical_services SET
	name_sr = 'Vađenje stranog tijela',
	name_sr_cyrl = 'Вађење страног тијела'
 WHERE slug = 'foreign-body-extraction-surgery';

UPDATE medical_services SET
	name_sr_cyrl = 'Радиоскопија и снимање страног тијела'
 WHERE slug = 'foreign-body-fluoroscopy-and-x-ray';

UPDATE medical_services SET
	name_sr_cyrl = 'Локализација страног тијела у оку уз РТГ контролу'
 WHERE slug = 'foreign-body-localization-in-eye-with-fluoroscopy';

UPDATE medical_services SET
	name_sr_cyrl = 'Локализација страног тијела у било ком органу (осим ока)'
 WHERE slug = 'foreign-body-localization-x-ray-except-eye';

UPDATE medical_services SET
	name_sr_cyrl = 'Екстракција страног тијела из бешике или камена из уретера — процедура А'
 WHERE slug = 'foreign-body-or-stone-extraction-from-bladderureter-procedure-a';

UPDATE medical_services SET
	name_sr_cyrl = 'Екстракција страног тијела из бешике или камена из уретера — процедура Б'
 WHERE slug = 'foreign-body-or-stone-extraction-from-bladderureter-procedure-b';

UPDATE medical_services SET
	name_sr = 'Uklanjanje stranog tijela',
	name_sr_cyrl = 'Уклањање страног тијела'
 WHERE slug = 'foreign-body-removal';

UPDATE medical_services SET
	name_sr = 'Uklanjanje stranog tijela iz oka',
	name_sr_cyrl = 'Уклањање страног тијела из ока'
 WHERE slug = 'foreign-body-removal-eye';

UPDATE medical_services SET
	name_sr_cyrl = 'Одстрањивање страних тијела из крвних судова'
 WHERE slug = 'foreign-body-removal-from-blood-vessels';

UPDATE medical_services SET
	name_sr = 'Uklanjanje stranog tijela iz cerviksa',
	name_sr_cyrl = 'Уклањање страног тијела из цервикса'
 WHERE slug = 'foreign-body-removal-from-cervix';

UPDATE medical_services SET
	name_sr_cyrl = 'Одстрањивање страног тијела из слушног канала, носне шупљине и орофаринкса'
 WHERE slug = 'foreign-body-removal-from-ear-nose-or-oropharynx';

UPDATE medical_services SET
	name_sr_cyrl = 'Скротум — одстрањивање страног тијела'
 WHERE slug = 'foreign-body-removal-from-scrotum';

UPDATE medical_services SET
	name_sr_cyrl = 'Одстрањивање страног тијела из коже и поткожног ткива'
 WHERE slug = 'foreign-body-removal-from-skin-and-subcutaneous-tissue';

UPDATE medical_services SET
	name_sr_cyrl = 'Уклањање страног тијела из меких ткива лица'
 WHERE slug = 'foreign-body-removal-from-soft-tissues-of-face';

UPDATE medical_services SET
	name_sr_cyrl = 'Екстракција страног тијела из вагине'
 WHERE slug = 'foreign-body-removal-from-vagina';

UPDATE medical_services SET
	name_sr = 'Vađenje stranog tijela uz repoziciju',
	name_sr_cyrl = 'Вађење страног тијела уз репозицију'
 WHERE slug = 'foreign-body-removal-with-reposition';

UPDATE medical_services SET
	name_sr_cyrl = 'Ревизија фронталног синуса — елевација фрактуре и сл. уни- или билатерално'
 WHERE slug = 'frontal-sinus-revision-fracture-elevation';

UPDATE medical_services SET
	name_sr_cyrl = 'Хистопатолошка дијагностика ex tempore (смрзнути рез)'
 WHERE slug = 'frozen-section-histopathology-ex-tempore';

UPDATE medical_services SET
	name_sr = 'Kompletna abdominoplastika sa liposukcijom',
	name_sr_cyrl = 'Комплетна абдоминопластика са липосукцијом'
 WHERE slug = 'full-abdominoplasty-with-liposuction';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе координације, корекције и аутоматизације баланса хода'
 WHERE slug = 'gait-coordination-correction-and-balance-automation-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе хода'
 WHERE slug = 'gait-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење гангрене једнокоријеног зуба'
 WHERE slug = 'gangrene-treatment-single-root';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење гангрене трокоријеног зуба'
 WHERE slug = 'gangrene-treatment-three-root';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење гангрене двокоријеног зуба'
 WHERE slug = 'gangrene-treatment-two-root';

UPDATE medical_services SET
	name_sr_cyrl = 'Гастроскопија са вађењем страног тијела'
 WHERE slug = 'gastroscopy-with-foreign-body-removal';

UPDATE medical_services SET
	name_sr_cyrl = 'Гастротомија ради одстрањења страног тјела'
 WHERE slug = 'gastrotomy-for-foreign-body-removal';

UPDATE medical_services SET
	name_sr = 'Pregled opšteg ljekara',
	name_sr_cyrl = 'Преглед општег љекара'
 WHERE slug = 'general-practitioner-examination';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење рецесије гингиве - ALODERM'
 WHERE slug = 'gingival-recession-treatment-aloderm';

UPDATE medical_services SET
	name_sr_cyrl = 'Групне вјежбе по особи у корективном гипсу за скољозу или у Милваки мидеру'
 WHERE slug = 'group-exercises-in-corrective-cast-for-scoliosis-or-milwaukee-brace';

UPDATE medical_services SET
	name_sr_cyrl = 'Групни тренинг социјалних вјештина и други бихејвиорално базирани модули'
 WHERE slug = 'group-social-skills-training-and-behavioral-modules';

UPDATE medical_services SET
	name_sr_cyrl = 'Преглед бриса косе на Demodex'
 WHERE slug = 'hair-demodex-examination';

UPDATE medical_services SET
	name_sr = 'Hirurško liječenje povreda šake',
	name_sr_cyrl = 'Хируршко лијечење повреда шаке'
 WHERE slug = 'hand-injury-surgical-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура проксималне или средње фаланге прста шаке — затворена или отворена'
 WHERE slug = 'hand-proximal-or-middle-phalanx-fracture-reduction';

UPDATE medical_services SET
	name_sr_cyrl = 'Повреде главе — повреде ватреним оружјем или друге пенетрирајуће повреде лобање'
 WHERE slug = 'head-injury-gunshot-or-other-penetrating-skull-injury';

UPDATE medical_services SET
	name_sr_cyrl = 'Превентивно здравствено савјетовање'
 WHERE slug = 'health-prevention-counseling';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење хемороида електричном деструкцијом'
 WHERE slug = 'hemorrhoid-treatment-with-electric-destruction';

UPDATE medical_services SET
	name_sr_cyrl = 'Вакцинација против хепатитиса А Avaxim'
 WHERE slug = 'hepatitis-a-vaccination-avaxim';

UPDATE medical_services SET
	name_sr_cyrl = 'Хернија са ресекцијом цријева'
 WHERE slug = 'hernia-with-bowel-resection';

UPDATE medical_services SET
	name_ru = 'Контрольный профилактический осмотр новорождённых и грудных детей из группы риска',
	name_de = 'Folge-Vorsorgeuntersuchung bei Risikoneugeborenen und Risikosäuglingen',
	name_tr = 'Yüksek riskli yenidoğan ve bebek kontrol muayenesi'
 WHERE slug = 'high-risk-neonate-and-infant-follow-up-examination';

UPDATE medical_services SET
	name_ru = 'Репозиция — гипс от тазобедренного до голеностопного сустава'
 WHERE slug = 'hip-to-ankle-plaster-reduction';

UPDATE medical_services SET
	name_sr_cyrl = 'Преглед надбубрежне жлијезде'
 WHERE slug = 'histopathology-of-adrenal-gland';

UPDATE medical_services SET
	name_sr_cyrl = 'Преглед ендоскопске биопсије дуоденума и танког цријева'
 WHERE slug = 'histopathology-of-duodenal-and-small-intestine-endoscopic-biopsy';

UPDATE medical_services SET
	name_sr_cyrl = 'Преглед промјене из ушног канала'
 WHERE slug = 'histopathology-of-ear-canal-lesion';

UPDATE medical_services SET
	name_sr_cyrl = 'Преглед ресекованог цријева код Whipple болести'
 WHERE slug = 'histopathology-of-intestinal-resection-in-whipples-disease';

UPDATE medical_services SET
	name_sr_cyrl = 'Преглед парцијалне ресекције дебелог цријева'
 WHERE slug = 'histopathology-of-partial-colectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Преглед биопсије перитонеума (трбушне марамице)'
 WHERE slug = 'histopathology-of-peritoneal-biopsy';

UPDATE medical_services SET
	name_sr_cyrl = 'Преглед пулмонектомије (плућног крила)'
 WHERE slug = 'histopathology-of-pneumonectomy-specimen';

UPDATE medical_services SET
	name_sr_cyrl = 'Преглед пљувачних и сузних жлијезда'
 WHERE slug = 'histopathology-of-salivary-and-lacrimal-glands';

UPDATE medical_services SET
	name_sr_cyrl = 'Преглед биопсије пљувачне жлијезде'
 WHERE slug = 'histopathology-of-salivary-gland-biopsy';

UPDATE medical_services SET
	name_sr_cyrl = 'Преглед тумора пљувачне жлијезде'
 WHERE slug = 'histopathology-of-salivary-gland-tumor';

UPDATE medical_services SET
	name_sr_cyrl = 'Преглед парцијалне ресекције танког цријева (фисуре и фистуле)'
 WHERE slug = 'histopathology-of-small-intestine-partial-resection-fissures-and-fistulas';

UPDATE medical_services SET
	name_sr_cyrl = 'Преглед ресекованог танког цријева'
 WHERE slug = 'histopathology-of-small-intestine-resection';

UPDATE medical_services SET
	name_sr_cyrl = 'Преглед субтоталне ресекције штитне жлијезде'
 WHERE slug = 'histopathology-of-subtotal-thyroidectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Преглед тоталне ресекције дебелог цријева'
 WHERE slug = 'histopathology-of-total-colectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Преглед тоталне ресекције штитне жлијезде'
 WHERE slug = 'histopathology-of-total-thyroidectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Преглед тумора вагине (extirpatio туморис vaginae)'
 WHERE slug = 'histopathology-of-vaginal-tumor';

UPDATE medical_services SET
	name_sr_cyrl = 'Њега пацијента у кућним условима'
 WHERE slug = 'home-patient-care';

UPDATE medical_services SET
	name_sr = 'Kućna posjeta periferija',
	name_sr_cyrl = 'Кућна посјета периферија'
 WHERE slug = 'home-visit-periphery';

UPDATE medical_services SET
	name_sr_cyrl = 'Операција потковичастог бубрега',
	name_de = 'Hufeisennieren-Operation'
 WHERE slug = 'horseshoe-kidney-surgery';

UPDATE medical_services SET
	name_sr_cyrl = 'Симфизиотомија потковичастог бубрега'
 WHERE slug = 'horseshoe-kidney-symphysiotomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура дијафизе хумеруса — затворена или отворена (сложена)'
 WHERE slug = 'humerus-diaphysis-fracture-closed-or-open-reduction';

UPDATE medical_services SET
	name_sr_cyrl = 'Хибридни абатмент цирконијум'
 WHERE slug = 'hybrid-abutment-zirconia';

UPDATE medical_services SET
	name_sr_cyrl = 'Хидроцефалус (код старијих од 16 година) — екстерна вентрикуларна дренажа'
 WHERE slug = 'hydrocephalus-external-ventricular-drainage-adults';

UPDATE medical_services SET
	name_ru = 'Аневризмэктомия и реконструкция подвздошных артерий'
 WHERE slug = 'iliac-arteries-aneurysmectomy-and-reconstruction';

UPDATE medical_services SET
	name_ru = 'Тромбэндартерэктомия подвздошных артерий с заплатой',
	name_tr = 'Yamalı ilyak arter trombendarterektomi'
 WHERE slug = 'iliac-artery-thrombendarterectomy-with-patch';

UPDATE medical_services SET
	name_sr = 'Imunoprofilaksa, imunoprofilaksa sa serumom i hemoprofilaksa za sprječavanje zaraznih bolesti',
	name_sr_cyrl = 'Имунопрофилакса, имунопрофилакса са серумом и хемопрофилакса за спрјечавање заразних болести'
 WHERE slug = 'immunoprophylaxis-and-chemoprophylaxis-for-infectious-disease-prevention';

UPDATE medical_services SET
	name_sr_cyrl = 'Операција укљештене киле'
 WHERE slug = 'incarcerated-hernia-operation';

UPDATE medical_services SET
	name_sr_cyrl = 'Оперативно лијечење укљештене херније са ресекцијом цријева'
 WHERE slug = 'incarcerated-hernia-surgery-with-bowel-resection';

UPDATE medical_services SET
	name_sr_cyrl = 'Индиректни Кумбсов тест/гел метода'
 WHERE slug = 'indirect-coombs-test-gel-method';

UPDATE medical_services SET
	name_sr_cyrl = 'Површна индивидуална психотерапија, савјетовање'
 WHERE slug = 'individual-supportive-psychotherapy-and-counseling';

UPDATE medical_services SET
	name_ru = 'Ангиография с индоцианином зелёным'
 WHERE slug = 'indocyanine-green-angiography';

UPDATE medical_services SET
	name_sr_cyrl = 'Замјена сталног уринарног катетера'
 WHERE slug = 'indwelling-urinary-catheter-replacement';

UPDATE medical_services SET
	name_sr = 'Operativno liječenje inflamiranog burzitisa',
	name_sr_cyrl = 'Оперативно лијечење инфламираног бурзитиса'
 WHERE slug = 'inflamed-bursitis-surgical-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Инфузија I (без лијекова)'
 WHERE slug = 'infusion-type-i-without-medications';

UPDATE medical_services SET
	name_sr_cyrl = 'Хируршка корекција ураслог нокта'
 WHERE slug = 'ingrown-toenail-aesthetic-correction';

UPDATE medical_services SET
	name_sr_cyrl = 'Операција ураслог нокта'
 WHERE slug = 'ingrown-toenail-surgery';

UPDATE medical_services SET
	name_sr = 'Hernioplastika ingvinalna sa ekscizijom hidrocele',
	name_sr_cyrl = 'Херниопластика ингвинална са ексцизијом хидроцеле'
 WHERE slug = 'inguinal-hernioplasty-with-hydrocele-excision';

UPDATE medical_services SET
	name_sr = 'Inhalaciona primjena',
	name_sr_cyrl = 'Инхалациона примјена'
 WHERE slug = 'inhalation-administration';

UPDATE medical_services SET
	name_sr_cyrl = 'Ревисио ревизија шупљине материце'
 WHERE slug = 'instrumental-uterine-cavity-revision';

UPDATE medical_services SET
	name_sr_cyrl = 'Издавање извјештаја за осигуравајуће куће'
 WHERE slug = 'insurance-report-issuance';

UPDATE medical_services SET
	name_sr_cyrl = 'Боравак у интензивној њези'
 WHERE slug = 'intensive-care-bed-day';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење унутрашњих хемороида гуменим лигатурама'
 WHERE slug = 'internal-hemorrhoid-rubber-band-ligation';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура интертрохатерична или перитрохантерична'
 WHERE slug = 'intertrochanteric-or-peritrochanteric-fracture';

UPDATE medical_services SET
	name_sr_cyrl = 'Пасажа цријева'
 WHERE slug = 'intestinal-barium-passage';

UPDATE medical_services SET
	name_sr = 'Intraartikularna primjena lijekova',
	name_sr_cyrl = 'Интраартикуларна примјена лијекова'
 WHERE slug = 'intra-articular-medication-application';

UPDATE medical_services SET
	name_sr_cyrl = 'Интралезионална апликација лијека'
 WHERE slug = 'intralesional-drug-application';

UPDATE medical_services SET
	name_sr = 'Zamjena intraokularnog sočiva',
	name_sr_cyrl = 'Замјена интраокуларног сочива'
 WHERE slug = 'intraocular-lens-exchange';

UPDATE medical_services SET
	name_sr_cyrl = 'Интраторакална анастомоза езофагуса с желуцем или цријевом без ресекције'
 WHERE slug = 'intrathoracic-esophageal-anastomosis-with-stomach-or-bowel-without-resection';

UPDATE medical_services SET
	name_sr_cyrl = 'Интравитреална апликација лијека'
 WHERE slug = 'intravitreal-drug-application';

UPDATE medical_services SET
	name_sr_cyrl = 'Испитивање ирегуларних антитијела - ензимски скрининг тест/гел метода'
 WHERE slug = 'irregular-antibody-screening-test-gel-method';

UPDATE medical_services SET
	name_sr_cyrl = 'Апликација интравенске каниле (брауниле)'
 WHERE slug = 'iv-cannula-application';

UPDATE medical_services SET
	name_sr_cyrl = 'Оперативно лијечење паралитичне разрокости (Јенсен операција)'
 WHERE slug = 'jensen-operation-for-paralytic-strabismus';

UPDATE medical_services SET
	name_sr_cyrl = 'Мјерење обима покрета појединих зглобова по једном пару екстремитета'
 WHERE slug = 'joint-range-of-motion-measurement-per-pair-of-extremities';

UPDATE medical_services SET
	name_sr = 'Kineziterapija za djecu sa deformitetima',
	name_sr_cyrl = 'Кинезитерапија за дјецу са деформитетима'
 WHERE slug = 'kinesiotherapy-for-children-with-deformities';

UPDATE medical_services SET
	name_sr_cyrl = 'Артротомија (капсулотомија) кољена са експлорацијом, дренажом и одстрањивањем страног тијела'
 WHERE slug = 'knee-arthrotomy-capsulotomy-with-exploration-and-foreign-body-removal';

UPDATE medical_services SET
	name_sr_cyrl = 'Дислокација кољена — затворена или отворена са/без унутрашње фиксације'
 WHERE slug = 'knee-dislocation-closed-or-open-reduction-withwithout-fixation';

UPDATE medical_services SET
	name_sr_cyrl = 'Фиксациони завој кољена'
 WHERE slug = 'knee-fixation-bandage';

UPDATE medical_services SET
	name_sr_cyrl = 'Екстирпација сузне кесе и сузне жлијезде'
 WHERE slug = 'lacrimal-sac-and-gland-excision';

UPDATE medical_services SET
	name_sr = 'Laparoskopska operacija slijepog crijeva (apendektomija)',
	name_sr_cyrl = 'Лапароскопска операција слијепог цријева (апендектомија)'
 WHERE slug = 'laparoscopic-appendectomy';

UPDATE medical_services SET
	name_ru = 'Лапароскопический холедоходуоденоанастомоз'
 WHERE slug = 'laparoscopic-choledochoduodenoanastomosis';

UPDATE medical_services SET
	name_ru = 'Лапароскопический холедохоеюноанастомоз'
 WHERE slug = 'laparoscopic-choledochojejunostomy';

UPDATE medical_services SET
	name_ru = 'Лапароскопическая цистопростатэктомия'
 WHERE slug = 'laparoscopic-cystoprostatectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Уклијештена ингвинална хернија — лапароскопска операција'
 WHERE slug = 'laparoscopic-incarcerated-inguinal-hernia-repair';

UPDATE medical_services SET
	name_sr = 'Laparoskopska lijeva hemikolektomija',
	name_sr_cyrl = 'Лапароскопска лијева хемиколектомија'
 WHERE slug = 'laparoscopic-left-hemicolectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Хемиколектомија лијева — лапароскопска са колоректо анастомозом (вар.)'
 WHERE slug = 'laparoscopic-left-hemicolectomy-with-anastomosis-variant';

UPDATE medical_services SET
	name_sr_cyrl = 'Хемиколектомија лијева — лапароскопска са колоректо анастомозом'
 WHERE slug = 'laparoscopic-left-hemicolectomy-with-colorectal-anastomosis';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијева хемиколектомија са формирањем стоме — лапароскопска'
 WHERE slug = 'laparoscopic-left-hemicolectomy-with-stoma-formation';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијева лобектомија јетре — лапароскопска операција'
 WHERE slug = 'laparoscopic-left-liver-lobectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијева панкреатектомија — лапароскопска операција'
 WHERE slug = 'laparoscopic-left-pancreatectomy';

UPDATE medical_services SET
	name_ru = 'Лапароскопическая операция при перфоративной язве 12-перстной кишки'
 WHERE slug = 'laparoscopic-operation-for-perforated-duodenal-ulcer';

UPDATE medical_services SET
	name_sr_cyrl = 'Тотална гастректомија са спленектомијом, оментектомијом и проширеном дисекцијом — лапароскопска'
 WHERE slug = 'laparoscopic-total-gastrectomy-with-splenectomy-and-lymphadenectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Терапија озљеда аналног предјела, лезија ректума са лапаротомијом'
 WHERE slug = 'laparotomy-for-analrectal-region-injury';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење путем лапаротомије лумбалних или обтураторних хернија'
 WHERE slug = 'laparotomy-for-lumbar-or-obturator-hernia';

UPDATE medical_services SET
	name_sr_cyrl = 'Ларингомикроскопија са узимањем исјечка и ексцизијом'
 WHERE slug = 'laryngomicroscopy-with-biopsy-and-excision';

UPDATE medical_services SET
	name_sr_cyrl = 'Прекид високе трудноће (преко 12 недјеља) — интраамнијална инсталација'
 WHERE slug = 'late-term-pregnancy-termination-by-intra-amniotic-instillation';

UPDATE medical_services SET
	name_sr_cyrl = 'Фасциотомија латерална или медијална (нпр. епикондилитис ''тенис лакат'')'
 WHERE slug = 'lateral-or-medial-fasciotomy-tennis-elbow';

UPDATE medical_services SET
	name_sr_cyrl = 'Катетеризација лијеве предкоморе и аорте са перкутаним приступом преко феморалне артерије са мјерењем притиска'
 WHERE slug = 'left-atrial-and-aortic-catheterization-via-percutaneous-femoral-artery-access-with-pressure-measurement';

UPDATE medical_services SET
	name_sr_cyrl = 'Катетеризација лијеве предкоморе и аорте са микротрансдјусерима и перкутаним приступом преко феморалне артерије по модификованој Selden-геровој методи'
 WHERE slug = 'left-atrial-and-aortic-catheterization-with-microtransducers-via-femoral-artery-modified-seldinger-technique';

UPDATE medical_services SET
	name_sr_cyrl = 'Катетеризација лијеве предкоморе преко препариране брахијалне артерије са мјерењем притиска под оптерећењем на ергометру'
 WHERE slug = 'left-atrial-catheterization-via-prepared-brachial-artery-with-pressure-measurement-under-ergometer-stress';

UPDATE medical_services SET
	name_sr = 'Lijeva hemikolektomija sa kolo-kolo anastomozom',
	name_sr_cyrl = 'Лијева хемиколектомија са коло-коло анастомозом'
 WHERE slug = 'left-hemicolectomy-with-colo-colo-anastomosis';

UPDATE medical_services SET
	name_sr = 'Lijeva hemikolektomija sa izvođenjem kolostome',
	name_sr_cyrl = 'Лијева хемиколектомија са извођењем колостоме'
 WHERE slug = 'left-hemicolectomy-with-colostomy';

UPDATE medical_services SET
	name_sr = 'Lijeva hemikolektomija sa unipolarnom kolostomom',
	name_sr_cyrl = 'Лијева хемиколектомија са униполарном колостомом'
 WHERE slug = 'left-hemicolectomy-with-unipolar-colostomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Бајпас лијевог јетреног жучног вода уз помоћ Roux-en-Y вијуге'
 WHERE slug = 'left-hepatic-duct-bypass-with-roux-en-y-loop';

UPDATE medical_services SET
	name_sr_cyrl = 'Лигатура екстракранијалних крвних судова мозга (вратни дио)'
 WHERE slug = 'ligation-of-extracranial-cerebral-vessels-cervical';

UPDATE medical_services SET
	name_sr_cyrl = 'Лигатура екстракранијалних крвних судова мозга (торакални дио)'
 WHERE slug = 'ligation-of-extracranial-cerebral-vessels-thoracic';

UPDATE medical_services SET
	name_sr_cyrl = 'Испитивање осјећаја свјетлости са пројекцијом'
 WHERE slug = 'light-sense-and-projection-test';

UPDATE medical_services SET
	name_sr_cyrl = 'Испитивање осјећаја свјетлости при испитивању двослика — мотилитет'
 WHERE slug = 'light-sense-test-with-diplopia-and-motility';

UPDATE medical_services SET
	name_sr = 'Lokalna aplikacija lijeka u zglob',
	name_sr_cyrl = 'Локална апликација лијека у зглоб'
 WHERE slug = 'local-joint-medication-injection';

UPDATE medical_services SET
	name_sr = 'Zamjena izgubljenog breketa',
	name_sr_cyrl = 'Замјена изгубљеног брекета'
 WHERE slug = 'lost-bracket-replacement';

UPDATE medical_services SET
	name_sr_cyrl = 'Ниски истхмични царски рез (са вођењем порођаја)'
 WHERE slug = 'low-isthmic-cesarean-section-with-delivery';

UPDATE medical_services SET
	name_sr = 'Ultrazvuk donjeg dijela abdomena',
	name_sr_cyrl = 'Ултразвук доњег дијела абдомена'
 WHERE slug = 'lower-abdomen-ultrasound';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе координације доњих екстремитета'
 WHERE slug = 'lower-extremity-coordination-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Фасциотомија поткољенице декомпресијом'
 WHERE slug = 'lower-leg-fasciotomy-with-decompression';

UPDATE medical_services SET
	name_sr_cyrl = 'Примарна репарација или сутура тетиве флексора поткољенице, једна или више'
 WHERE slug = 'lower-leg-flexor-tendon-primary-repair-one-or-more';

UPDATE medical_services SET
	name_sr_cyrl = 'Трахеобронхоскопија доња — кроз вјештачки отвор'
 WHERE slug = 'lower-tracheobronchoscopy-via-tracheostomy';

UPDATE medical_services SET
	name_sr = 'Biopsija limfne žlijezde (u preponi i pazuhu)',
	name_sr_cyrl = 'Биопсија лимфне жлијезде (у препони и пазуху)'
 WHERE slug = 'lymph-node-biopsy-groin-armpit';

UPDATE medical_services SET
	name_sr = 'Biopsija limfne žlijezde (na vratu)',
	name_sr_cyrl = 'Биопсија лимфне жлијезде (на врату)'
 WHERE slug = 'lymph-node-biopsy-neck';

UPDATE medical_services SET
	name_sr_cyrl = 'Екстирпација или биопсија лимфне жлијезде'
 WHERE slug = 'lymph-node-biopsy-or-excision';

UPDATE medical_services SET
	name_sr = 'Limfna drenaža djelimična',
	name_sr_cyrl = 'Лимфна дренажа дјелимична'
 WHERE slug = 'lymphatic-drainage-partial';

UPDATE medical_services SET
	name_sr_cyrl = 'Екстракција страног тијела магнетне природе из задњег сегмента ока'
 WHERE slug = 'magnetic-foreign-body-extraction-from-posterior-segment';

UPDATE medical_services SET
	name_sr_cyrl = 'Већа ресекција вене saphena externa и сусједних вена, унилатерална'
 WHERE slug = 'major-resection-of-external-saphenous-vein';

UPDATE medical_services SET
	name_sr_cyrl = 'Репозиција луксације мандибуларног зглоб'
 WHERE slug = 'mandibular-joint-dislocation-reduction';

UPDATE medical_services SET
	name_ru = 'Манипулятивная репозиция открытого перелома пяточной кости'
 WHERE slug = 'manipulative-reduction-of-open-calcaneus-fracture';

UPDATE medical_services SET
	name_sr_cyrl = 'Манипулативна репозиција отворене фрактуре дисталног дијела'
 WHERE slug = 'manipulative-reduction-of-open-distal-fracture';

UPDATE medical_services SET
	name_sr_cyrl = 'Манипулативна репозиција отворене фрактуре дисталног дијела (вар.)'
 WHERE slug = 'manipulative-reduction-of-open-distal-fracture-variant';

UPDATE medical_services SET
	name_sr_cyrl = 'Манипулативна репозиција отворене фрактуре фибуле (дијафиза)',
	name_ru = 'Манипулятивная репозиция открытого перелома диафиза малоберцовой кости'
 WHERE slug = 'manipulative-reduction-of-open-fibula-fracture';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура епикондила, медијалног или латералног — затворена'
 WHERE slug = 'medial-or-lateral-epicondyle-fracture-closed';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура епикондила, медијалног или латералног — отворена (сложена) са Kirschner иглом или плочом'
 WHERE slug = 'medial-or-lateral-epicondyle-fracture-open-with-k-wire-or-plate';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура медијалног или латералног кондила фемура — затворена или отворена'
 WHERE slug = 'medial-or-lateral-femoral-condyle-fracture-open-reduction';

UPDATE medical_services SET
	name_sr_cyrl = 'Дренажа медијастинума, експлорација, одстрањење страног тијела'
 WHERE slug = 'mediastinal-drainage-exploration-foreign-body-removal';

UPDATE medical_services SET
	name_sr_cyrl = 'Киретажа Меибомове жлијезде'
 WHERE slug = 'meibomian-gland-curettage';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактуре метакарпуса — затворена или отворена (компликована) репозиција',
	name_ru = 'Репозиция перелома пястной кости (закрытая или открытая)',
	name_de = 'Metakarpalfraktur-Reposition (geschlossen oder offen)',
	name_tr = 'Metakarp kırığı redüksiyonu (kapalı veya açık)'
 WHERE slug = 'metacarpal-fracture-reduction';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура метакарпуса — затворена или отворена са/без фиксације'
 WHERE slug = 'metacarpal-fracture-reduction-closed-or-open-withwithout-fixation';

UPDATE medical_services SET
	name_sr_cyrl = 'Метакарпофалангеална дислокација — затворена или отворена',
	name_ru = 'Репозиция вывиха пястно-фалангового сустава (закрытая или открытая)',
	name_de = 'Metakarpophalangealgelenk-Reposition (geschlossen oder offen)',
	name_tr = 'Metakarpofalangeal eklem dislokasyonu redüksiyonu (kapalı veya açık)'
 WHERE slug = 'metacarpophalangeal-joint-dislocation-reduction';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура метатарзалне кости — затворена или отворена са/без фиксације',
	name_ru = 'Репозиция перелома плюсневой кости (закрытая или открытая) с фиксацией или без',
	name_de = 'Metatarsalfraktur-Reposition (geschlossen oder offen) mit oder ohne Fixation',
	name_tr = 'Metatars kırığı redüksiyonu (kapalı veya açık), fiksasyonlu veya fiksasyonsuz'
 WHERE slug = 'metatarsal-bone-fracture-reduction-withwithout-fixation';

UPDATE medical_services SET
	name_sr_cyrl = 'Затворена манипулативна репозиција фрактуре метатарзалних костију'
 WHERE slug = 'metatarsal-fracture-manipulation-reduction';

UPDATE medical_services SET
	name_sr_cyrl = 'Остектомија главице метатарзалне кости, једна или више',
	name_ru = 'Остэктомия головки плюсневой кости (одной или нескольких)',
	name_de = 'Ostektomie eines oder mehrerer Metatarsalköpfchen',
	name_tr = 'Bir veya daha fazla metatars başının ostektomisi'
 WHERE slug = 'metatarsal-head-ostectomy-one-or-more';

UPDATE medical_services SET
	name_ru = 'Остеотомия плюсневой кости'
 WHERE slug = 'metatarsal-osteotomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Остеотомија метатарзалне кости, једне или више',
	name_ru = 'Остеотомия плюсневой кости (одной или нескольких)',
	name_de = 'Osteotomie eines oder mehrerer Metatarsalknochen',
	name_tr = 'Bir veya daha fazla metatars kemiğinin osteotomisi'
 WHERE slug = 'metatarsal-osteotomy-one-or-more';

UPDATE medical_services SET
	name_sr_cyrl = 'Дислокација метатарзо-фалангеалног зглоба — затворена или отворена',
	name_ru = 'Репозиция вывиха плюсне-фалангового сустава (закрытая или открытая)',
	name_de = 'Metatarsophalangealgelenk-Reposition (geschlossen oder offen)',
	name_tr = 'Metatarsofalangeal eklem dislokasyonu redüksiyonu (kapalı veya açık)'
 WHERE slug = 'metatarsophalangeal-joint-dislocation-reduction';

UPDATE medical_services SET
	name_sr_cyrl = 'Биопсија промјена средњег уха'
 WHERE slug = 'middle-ear-lesion-biopsy';

UPDATE medical_services SET
	name_sr_cyrl = 'Екстериоризација цријева (Mikulicz операција)'
 WHERE slug = 'mikulicz-bowel-exteriorization';

UPDATE medical_services SET
	name_sr = 'Hirurško liječenje opekotina manjeg obima',
	name_sr_cyrl = 'Хируршко лијечење опекотина мањег обима'
 WHERE slug = 'minor-burns-surgical-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Интервенције ласером — мање (код промјена на конјунктиви)'
 WHERE slug = 'minor-laser-intervention-conjunctival-lesions';

UPDATE medical_services SET
	name_sr_cyrl = 'Вакцинација ММР Priorix'
 WHERE slug = 'mmr-vaccination-priorix';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура лакта, Monteggia тип — фрактура проксималног краја'
 WHERE slug = 'monteggia-elbow-fracture-proximal-end';

UPDATE medical_services SET
	name_sr_cyrl = 'Мортална екстирпација вишекоријених зуба са дефинитивним пуњењем'
 WHERE slug = 'mortal-extirpation-of-multi-root-teeth-with-definitive-filling';

UPDATE medical_services SET
	name_sr_cyrl = 'Мортална екстирпација једнокоријених зуба са дефинитивним пуњењем'
 WHERE slug = 'mortal-extirpation-of-single-root-teeth-with-definitive-filling';

UPDATE medical_services SET
	name_ru = 'КТ крестцово-подвздошных и тазобедренных суставов'
 WHERE slug = 'msct-si-joints-and-hips';

UPDATE medical_services SET
	name_sr_cyrl = 'Тенолиза екстензора стопала, више (кроз исти рез)'
 WHERE slug = 'multiple-foot-extensor-tenolysis-same-incision';

UPDATE medical_services SET
	name_sr_cyrl = 'Тенолиза флексора стопала, више (кроз исти рез)'
 WHERE slug = 'multiple-foot-flexor-tenolysis-same-incision';

UPDATE medical_services SET
	name_sr_cyrl = 'Mycoplasma култура са антибиограмом'
 WHERE slug = 'mycoplasma-culture-with-antibiogram';

UPDATE medical_services SET
	name_sr_cyrl = 'Репарација псеудоартрозе навикуларне кости са/без коштаног графта',
	name_ru = 'Лечение псевдоартроза ладьевидной кости с костной пластикой или без',
	name_de = 'Navikularpseudarthrose-Reparation mit oder ohne Knochentransplantat',
	name_tr = 'Naviküler psödoartroz onarımı, kemik greftli veya greftsiz'
 WHERE slug = 'navicular-pseudarthrosis-repair-withwithout-bone-graft';

UPDATE medical_services SET
	name_sr = 'Ultrazvuk vrata pljuvačne žlijezde',
	name_sr_cyrl = 'Ултразвук врата пљувачне жлијезде'
 WHERE slug = 'neck-ultrasound-salivary-glands';

UPDATE medical_services SET
	name_sr_cyrl = 'Промјена нефростомије'
 WHERE slug = 'nephrostomy-change';

UPDATE medical_services SET
	name_sr = 'Liječenje neurodegenerativnih bolesti',
	name_sr_cyrl = 'Лијечење неуродегенеративних болести'
 WHERE slug = 'neurodegenerative-disease-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Неуропсихолошки преглед са процјеном когнитивних функција за одрасле'
 WHERE slug = 'neuropsychological-examination-with-cognitive-assessment-for-adults';

UPDATE medical_services SET
	name_ru = 'Полуинтенсивный уход за новорождённым в инкубаторе'
 WHERE slug = 'newborn-incubator-semi-intensive-care';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење рагада'
 WHERE slug = 'nipple-fissure-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Примјена азот оксида (NO)'
 WHERE slug = 'nitric-oxide-no-administration';

UPDATE medical_services SET
	name_sr_cyrl = 'Плисирање цријева — Noble'
 WHERE slug = 'noble-bowel-plication';

UPDATE medical_services SET
	name_sr_cyrl = 'Екстракција страног тијела немагнетне природе из предњег сегмента ока'
 WHERE slug = 'non-magnetic-foreign-body-extraction-from-anterior-segment';

UPDATE medical_services SET
	name_sr_cyrl = 'Нехируршко подмлађивање - Тијело'
 WHERE slug = 'non-surgical-body-rejuvenation';

UPDATE medical_services SET
	name_sr_cyrl = 'Нехируршко подмлађивање - Ботокс токсин'
 WHERE slug = 'non-surgical-rejuvenation-botox';

UPDATE medical_services SET
	name_sr_cyrl = 'Нехируршко подмлађивање - Филери'
 WHERE slug = 'non-surgical-rejuvenation-fillers';

UPDATE medical_services SET
	name_sr_cyrl = 'Нехируршко подмлађивање - Фрактора ласер'
 WHERE slug = 'non-surgical-rejuvenation-fractora-laser';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура проксималног краја улне (олекранона) — затворена или отворена'
 WHERE slug = 'olecranon-fracture-closed-or-open-reduction';

UPDATE medical_services SET
	name_sr = 'Otvorena operacija slijepog crijeva (apendektomija)',
	name_sr_cyrl = 'Отворена операција слијепог цријева (апендектомија)'
 WHERE slug = 'open-appendectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Дренажа периреналног или реналног апсцеса — отвор'
 WHERE slug = 'open-drainage-of-perirenal-or-renal-abscess';

UPDATE medical_services SET
	name_sr_cyrl = 'Тенотомија флексора, отворена, више од једне тенотомије, кроз исти рез'
 WHERE slug = 'open-flexor-tenotomy-of-multiple-tendons-same-incision';

UPDATE medical_services SET
	name_sr_cyrl = 'Тенотомија флексора, отворена, прст један или више'
 WHERE slug = 'open-flexor-tenotomy-of-one-or-more-fingers';

UPDATE medical_services SET
	name_sr_cyrl = 'Операција уклијештене вентралне киле'
 WHERE slug = 'open-incarcerated-ventral-hernia-surgery';

UPDATE medical_services SET
	name_sr_cyrl = 'Отворена репозиција фрактуре ацетабулума са или без фиксације'
 WHERE slug = 'open-reduction-of-acetabular-fracture-withwithout-fixation';

UPDATE medical_services SET
	name_sr_cyrl = 'Отворена репозиција свјежих прелома носних костију'
 WHERE slug = 'open-reduction-of-fresh-nasal-bone-fracture';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура пателе — отворена (сложена) репозиција са репарацијом и/или ексцизијом'
 WHERE slug = 'open-reduction-of-patellar-fracture-with-repair';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура дијафизе радиуса и улне — отворена (сложена) са проширеном репозицијом',
	name_ru = 'Открытая репозиция перелома диафиза лучевой и локтевой костей'
 WHERE slug = 'open-reduction-of-radius-and-ulna-diaphysis-fracture';

UPDATE medical_services SET
	name_en = 'Operating Theatre Costs in General Hospitals (Operations of More than 180 Points)',
	name_sr = 'Troškovi operacione sale u opštim bolnicama (operacije preko 180 bodova)',
	name_sr_cyrl = 'Трошкови операционе сале у општим болницама (операције преко 180 бодова)',
	name_ru = 'Расходы на операционную в общих больницах (операции свыше 180 баллов)',
	name_de = 'Operationssaalkosten in Allgemeinkrankenhäusern (Operationen mit über 180 Punkten)',
	name_tr = 'Genel hastanelerde ameliyathane maliyeti (180 puan üzeri ameliyatlar)'
 WHERE slug = 'operating-theatre-costs-tier-i-over-180-points';

UPDATE medical_services SET
	name_en = 'Operating Theatre Costs in Clinical Centre and Special Hospitals (Operations of 121 to 180 Points)',
	name_sr = 'Troškovi operacionog bloka Kliničkog centra i specijalnih bolnica (operacije od 121 do 180 bodova)',
	name_sr_cyrl = 'Трошкови операционог блока Клиничког центра и специјалних болница (операције од 121 до 180 бодова)',
	name_ru = 'Расходы на операционный блок Клинического центра и специальных больниц (операции от 121 до 180 баллов)',
	name_de = 'Operationssaalkosten im Klinischen Zentrum und in Fachkrankenhäusern (Operationen mit 121 bis 180 Punkten)',
	name_tr = 'Klinik Merkez ve dal hastanelerinde ameliyathane maliyeti (121-180 puanlık ameliyatlar)'
 WHERE slug = 'operating-theatre-costs-tier-ii-121-to-180-points';

UPDATE medical_services SET
	name_en = 'Operating Theatre Costs in Clinical Centre and Special Hospitals (Operations of 5 to 20 Points)',
	name_sr = 'Troškovi operacionog bloka Kliničkog centra i specijalnih bolnica (operacije od 5 do 20 bodova)',
	name_sr_cyrl = 'Трошкови операционог блока Клиничког центра и специјалних болница (операције од 5 до 20 бодова)',
	name_ru = 'Расходы на операционный блок Клинического центра и специальных больниц (операции от 5 до 20 баллов)',
	name_de = 'Operationssaalkosten im Klinischen Zentrum und in Fachkrankenhäusern (Operationen mit 5 bis 20 Punkten)',
	name_tr = 'Klinik Merkez ve dal hastanelerinde ameliyathane maliyeti (5-20 puanlık ameliyatlar)'
 WHERE slug = 'operating-theatre-costs-tier-ii-5-to-20-points';

UPDATE medical_services SET
	name_en = 'Operating Theatre Costs in Clinical Centre and Special Hospitals (Operations of 51 to 120 Points)',
	name_sr = 'Troškovi operacionog bloka Kliničkog centra i specijalnih bolnica (operacije od 51 do 120 bodova)',
	name_sr_cyrl = 'Трошкови операционог блока Клиничког центра и специјалних болница (операције од 51 до 120 бодова)',
	name_ru = 'Расходы на операционный блок Клинического центра и специальных больниц (операции от 51 до 120 баллов)',
	name_de = 'Operationssaalkosten im Klinischen Zentrum und in Fachkrankenhäusern (Operationen mit 51 bis 120 Punkten)',
	name_tr = 'Klinik Merkez ve dal hastanelerinde ameliyathane maliyeti (51-120 puanlık ameliyatlar)'
 WHERE slug = 'operating-theatre-costs-tier-ii-51-to-120-points';

UPDATE medical_services SET
	name_en = 'Operating Theatre Costs in Clinical Centre and Special Hospitals (Operations of More than 180 Points)',
	name_sr = 'Troškovi operacionog bloka Kliničkog centra i specijalnih bolnica (operacije preko 180 bodova)',
	name_sr_cyrl = 'Трошкови операционог блока Клиничког центра и специјалних болница (операције преко 180 бодова)',
	name_ru = 'Расходы на операционный блок Клинического центра и специальных больниц (операции свыше 180 баллов)',
	name_de = 'Operationssaalkosten im Klinischen Zentrum und in Fachkrankenhäusern (Operationen mit über 180 Punkten)',
	name_tr = 'Klinik Merkez ve dal hastanelerinde ameliyathane maliyeti (180 puan üzeri ameliyatlar)'
 WHERE slug = 'operating-theatre-costs-tier-ii-over-180-points';

UPDATE medical_services SET
	name_en = 'Small Surgical Dressing I'
 WHERE slug = 'operation-small-dressing-i';

UPDATE medical_services SET
	name_sr_cyrl = 'Ортодонтска контрола мјесечна'
 WHERE slug = 'orthodontic-follow-up-monthly';

UPDATE medical_services SET
	name_sr_cyrl = 'Ортодонтско лијечење са Трејнером'
 WHERE slug = 'orthodontic-treatment-with-trainer';

UPDATE medical_services SET
	name_tr = 'Yamalı diğer kol arteri trombendarterektomi'
 WHERE slug = 'other-arm-arteries-thrombendarterectomy-with-patch';

UPDATE medical_services SET
	name_sr_cyrl = 'Друге репарације једњака, кардиопластика, збрињавање фистуле, ресекција дивертикулума трансторакално'
 WHERE slug = 'other-esophageal-repair-cardioplasty-fistula-closure-diverticulum-resection-transthoracic';

UPDATE medical_services SET
	name_sr_cyrl = 'Друге операције ириса, цилијарног тијела и предње коморе'
 WHERE slug = 'other-iris-ciliary-body-and-anterior-chamber-operations';

UPDATE medical_services SET
	name_tr = 'Yamalı diğer bacak arteri trombendarterektomi'
 WHERE slug = 'other-leg-arteries-thrombendarterectomy-with-patch';

UPDATE medical_services SET
	name_sr_cyrl = 'Отомикроскопија са аспирационим чишћењем уха'
 WHERE slug = 'otomicroscopy-with-ear-aspiration';

UPDATE medical_services SET
	name_ru = 'Единица эритроцитной массы Rh-отрицательная',
	name_tr = 'Eritrosit süspansiyonu ünitesi Rh negatif'
 WHERE slug = 'packed-red-blood-cells-unit-rh-negative';

UPDATE medical_services SET
	name_ru = 'Единица эритроцитной массы Rh-положительная',
	name_tr = 'Eritrosit süspansiyonu ünitesi Rh pozitif'
 WHERE slug = 'packed-red-blood-cells-unit-rh-positive';

UPDATE medical_services SET
	name_sr_cyrl = 'Деривација псеудоцисте панкреаса издвојеном цријевном вијугом'
 WHERE slug = 'pancreatic-pseudocyst-drainage-with-roux-en-y-loop';

UPDATE medical_services SET
	name_sr_cyrl = 'Сцинтиграфија паратироидних жлијезда'
 WHERE slug = 'parathyroid-gland-scintigraphy';

UPDATE medical_services SET
	name_sr_cyrl = 'Операција паратироидне жлијезде'
 WHERE slug = 'parathyroidectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Парцијална ексцизија кости (киретажа, секвестрација или)'
 WHERE slug = 'partial-bone-excision-curettage-sequestrectomy-or';

UPDATE medical_services SET
	name_ru = 'Частичная резекция кости при остеомиелите таранной кости'
 WHERE slug = 'partial-bone-excision-for-talus-osteomyelitis';

UPDATE medical_services SET
	name_sr_cyrl = 'Цистектомија парцијална са ресекцијом ушћа и реимпл. (вар.)'
 WHERE slug = 'partial-cystectomy-with-orifice-resection-variant';

UPDATE medical_services SET
	name_sr_cyrl = 'Пасивне и потпомогнуте вјежбе'
 WHERE slug = 'passive-and-assisted-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Дислокација пателе — затворена или отворена'
 WHERE slug = 'patellar-dislocation-closed-or-open-reduction';

UPDATE medical_services SET
	name_sr_cyrl = 'Обука пацијента специфичним заштитним положајима тијела'
 WHERE slug = 'patient-training-in-specific-protective-body-positions';

UPDATE medical_services SET
	name_sr = 'Pedijatrijsko liječenje karijesa',
	name_sr_cyrl = 'Педијатријско лијечење каријеса'
 WHERE slug = 'pediatric-caries-treatment';

UPDATE medical_services SET
	name_sr = 'Dječja stomatološka dijagnostika sa planom liječenja',
	name_sr_cyrl = 'Дјечја стоматолошка дијагностика са планом лијечења'
 WHERE slug = 'pediatric-dental-diagnostics-with-treatment-plan';

UPDATE medical_services SET
	name_sr = 'Konsultacija dječjeg stomatologa',
	name_sr_cyrl = 'Консултација дјечјег стоматолога'
 WHERE slug = 'pediatric-dentist-consultation';

UPDATE medical_services SET
	name_sr_cyrl = 'Припрема дјечијих доза еритроцита'
 WHERE slug = 'pediatric-erythrocyte-dose-preparation';

UPDATE medical_services SET
	name_sr_cyrl = 'Тестови функције дисања дјетета — кривуља проток-волумен'
 WHERE slug = 'pediatric-flow-volume-curve';

UPDATE medical_services SET
	name_sr_cyrl = 'Неурохирургија дјеце — повреде главе'
 WHERE slug = 'pediatric-neurosurgery-head-injuries';

UPDATE medical_services SET
	name_sr_cyrl = 'Неурохирургија дјеце — хидроцефалус и конгениталне малформације'
 WHERE slug = 'pediatric-neurosurgery-hydrocephalus-and-congenital-malformations';

UPDATE medical_services SET
	name_sr_cyrl = 'Неурохирургија дјеце — тумори мозга супратенторијални — тумори хемисфера мозга'
 WHERE slug = 'pediatric-neurosurgery-supratentorial-brain-hemisphere-tumors';

UPDATE medical_services SET
	name_sr = 'Oftalmološki i strabološki pregled za djecu sa širenjem zjenica',
	name_sr_cyrl = 'Офталмолошки и страболошки преглед за дјецу са ширењем зјеница'
 WHERE slug = 'pediatric-strabismus-examination';

UPDATE medical_services SET
	name_en = 'Ureteral Implantation Using a Pedicled Tubular Bladder Flap (Boari)',
	name_sr = 'Ureteralna implantacija putem pedikularnog i tubularnog isječka bešike (Boari)',
	name_sr_cyrl = 'Уретерална имплантација путем педикуларног и тубуларног исјечка бешике (Боари)',
	name_ru = 'Имплантация мочеточника трубчатым лоскутом мочевого пузыря на ножке (операция Боари)',
	name_de = 'Ureterimplantation mit gestieltem tubulärem Blasenlappen (Boari)',
	name_tr = 'Pediküllü tübüler mesane flebi ile üreter implantasyonu (Boari)'
 WHERE slug = 'pediculated-and-tubular-ureteral-implantation';

UPDATE medical_services SET
	name_sr_cyrl = 'Пенализација — њено дозирање и провјеравање у кабинету'
 WHERE slug = 'penalization-dosing-and-verification';

UPDATE medical_services SET
	name_sr_cyrl = 'Перкутана аспирациона биопсија под контролом ЦТ-а'
 WHERE slug = 'percutaneous-aspiration-biopsy-under-ct-guidance';

UPDATE medical_services SET
	name_sr_cyrl = 'Перкутана дренажа јетреног апсцеса под контролом ЦТ-а'
 WHERE slug = 'percutaneous-liver-abscess-drainage-under-ct-guidance';

UPDATE medical_services SET
	name_sr_cyrl = 'Перкутана нефростомија под контролом ЦТ-а'
 WHERE slug = 'percutaneous-nephrostomy-under-ct-guidance';

UPDATE medical_services SET
	name_sr_cyrl = 'Пункција и евакуација бубрежних циста под контролом ЦТ-а'
 WHERE slug = 'percutaneous-renal-cyst-aspiration-under-ct-guidance';

UPDATE medical_services SET
	name_sr_cyrl = 'Перикардиоцентеза и дренажа катетером под контролом ЦТ-а'
 WHERE slug = 'pericardiocentesis-with-catheter-drainage-under-ct-guidance';

UPDATE medical_services SET
	name_sr = 'Liječenje inflamatornih oboljenja perifernih nerava i kičmene moždine',
	name_sr_cyrl = 'Лијечење инфламаторних обољења периферних нерава и кичмене мождине'
 WHERE slug = 'peripheral-nerve-and-spinal-cord-inflammatory-disease-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Повреде и обољења периферних нерава — декомпресија/транспозиција код компресивних неуропатија'
 WHERE slug = 'peripheral-nerve-decompressiontransposition-for-compression-neuropathy';

UPDATE medical_services SET
	name_sr_cyrl = 'Перитонеумска дијализа — интермитентна замјена бубрежне функције'
 WHERE slug = 'peritoneal-dialysis';

UPDATE medical_services SET
	name_ru = 'Герниопластика очень крупной послеоперационной вентральной грыжи',
	name_de = 'Hernioplastik bei sehr großer ventraler Narbenhernie (permagna)'
 WHERE slug = 'permagna-ventral-incisional-hernioplasty';

UPDATE medical_services SET
	name_sr_cyrl = 'Процјена структуре личности (експлорација) за одрасле'
 WHERE slug = 'personality-structure-assessment-for-adults';

UPDATE medical_services SET
	name_sr_cyrl = 'Операција катаракте помоћу UZ-fakoemulzifikacije са уградњом интраокуларног сочива'
 WHERE slug = 'phacoemulsification-cataract-surgery-with-iol-implantation';

UPDATE medical_services SET
	name_sr_cyrl = 'Фармаколошки тестови за процјену исхемије и/или вијабилности миокарда'
 WHERE slug = 'pharmacological-test-for-ischemia-or-myocardial-viability';

UPDATE medical_services SET
	name_sr_cyrl = 'Вађење страног тијела из ждријела'
 WHERE slug = 'pharyngeal-foreign-body-removal';

UPDATE medical_services SET
	name_sr_cyrl = 'Снимање ждријела и гркљана'
 WHERE slug = 'pharynx-and-larynx-x-ray';

UPDATE medical_services SET
	name_sr_cyrl = 'Снимање ждријела и гркљана уз рентгеноскопију'
 WHERE slug = 'pharynx-and-larynx-x-ray-with-fluoroscopy';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе фонације'
 WHERE slug = 'phonation-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Фонијатријске вјежбе'
 WHERE slug = 'phoniatric-exercises';

UPDATE medical_services SET
	name_sr = 'Hirurško liječenje pilonidalnog sinusa',
	name_sr_cyrl = 'Хируршко лијечење пилонидалног синуса'
 WHERE slug = 'pilonidal-sinus-surgical-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Пласмапен – преко 10 промјена'
 WHERE slug = 'plasma-pen-treatment-over-10-lesions';

UPDATE medical_services SET
	name_sr_cyrl = 'Пласмапен – до 10 промјена'
 WHERE slug = 'plasma-pen-treatment-up-to-10-lesions';

UPDATE medical_services SET
	name_sr_cyrl = 'Пласмапен – до 3 промјене'
 WHERE slug = 'plasma-pen-treatment-up-to-3-lesions';

UPDATE medical_services SET
	name_sr_cyrl = 'Гипсани цилиндар од кука до глежња изнад 10 година'
 WHERE slug = 'plaster-cylinder-hip-to-ankle-over-10-years';

UPDATE medical_services SET
	name_sr_cyrl = 'Гипсани цилиндар од кука до глежња испод 10 година'
 WHERE slug = 'plaster-cylinder-hip-to-ankle-under-10-years';

UPDATE medical_services SET
	name_sr_cyrl = 'Гипсане лонгете од кука до глежња и прстију изнад 10 година'
 WHERE slug = 'plaster-splint-hip-to-ankle-and-toes-over-10-years';

UPDATE medical_services SET
	name_sr_cyrl = 'Гипсане лонгете од кука до глежња и прстију испод 10 година'
 WHERE slug = 'plaster-splint-hip-to-ankle-and-toes-under-10-years';

UPDATE medical_services SET
	name_sr_cyrl = 'Вакцинација против дјечје парализе Imovax полио'
 WHERE slug = 'polio-vaccination-imovax';

UPDATE medical_services SET
	name_sr_cyrl = 'Полисегментно испитивање брзине проводљивости мјешовитог живца'
 WHERE slug = 'polysegmental-conduction-velocity-test-of-mixed-nerve';

UPDATE medical_services SET
	name_ru = 'Тромбэндартерэктомия подколенной артерии с заплатой',
	name_tr = 'Yamalı popliteal arter trombendarterektomi'
 WHERE slug = 'popliteal-artery-thrombendarterectomy-with-patch';

UPDATE medical_services SET
	name_sr = 'Rehabilitacija nakon ugradnje vještačkog zgloba',
	name_sr_cyrl = 'Рехабилитација након уградње вјештачког зглоба'
 WHERE slug = 'post-joint-replacement-rehabilitation';

UPDATE medical_services SET
	name_sr_cyrl = 'Хемостаза послије тонзилектомије'
 WHERE slug = 'post-tonsillectomy-hemostasis';

UPDATE medical_services SET
	name_sr_cyrl = 'Операција одстрањења страног тијела из задњег сегмента ока са превенцијом аблације'
 WHERE slug = 'posterior-segment-foreign-body-removal-with-ablation-prevention';

UPDATE medical_services SET
	name_sr_cyrl = 'Постоперативно лијечење ДТК терапијском дозом И-131'
 WHERE slug = 'postoperative-treatment-of-differentiated-thyroid-carcinoma-with-therapeutic-i-131-dose';

UPDATE medical_services SET
	name_sr_cyrl = 'Постуралне вјежбе'
 WHERE slug = 'postural-exercises';

UPDATE medical_services SET
	name_sr = 'Preventivni pregled opšteg ljekara',
	name_sr_cyrl = 'Превентивни преглед општег љекара'
 WHERE slug = 'preventive-general-practitioner-examination';

UPDATE medical_services SET
	name_sr_cyrl = 'Репарација тетиве екстензора примарна, једна или више'
 WHERE slug = 'primary-extensor-tendon-repair-one-or-more';

UPDATE medical_services SET
	name_sr_cyrl = 'Примарна тендорафија више флексорних тетива уз екстирпацију'
 WHERE slug = 'primary-multi-tendon-flexor-repair-with-excision';

UPDATE medical_services SET
	name_sr_cyrl = 'Примарна сутура руптурираног или прекинутог колатералног лигамента'
 WHERE slug = 'primary-suture-of-ruptured-collateral-ligament';

UPDATE medical_services SET
	name_ru = 'Первичная невроррафия локтевого или срединного нерва'
 WHERE slug = 'primary-ulnar-or-median-nerve-neurorrhaphy';

UPDATE medical_services SET
	name_sr_cyrl = 'Примарна обрада ране уз примјену електрокаутеризације'
 WHERE slug = 'primary-wound-care-with-electrocauterization';

UPDATE medical_services SET
	name_sr = 'Profesionalno čišćenje zuba mliječni zubi',
	name_sr_cyrl = 'Професионално чишћење зуба млијечни зуби'
 WHERE slug = 'professional-dental-cleaning-deciduous-teeth';

UPDATE medical_services SET
	name_sr_cyrl = 'Ултразвук двије регије професора'
 WHERE slug = 'professor-ultrasound-two-regions';

UPDATE medical_services SET
	name_sr_cyrl = 'Прогресивне вјежбе са отпором на квадрицепс апарату'
 WHERE slug = 'progressive-quadriceps-resistance-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Прогресивне вјежбе са отпором'
 WHERE slug = 'progressive-resistance-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Остеотомија проксималне фаланге палца за скраћење, угао или ротацију'
 WHERE slug = 'proximal-phalanx-big-toe-osteotomy-for-shortening-or-rotation';

UPDATE medical_services SET
	name_sr_cyrl = 'Експертиза психолошког стања код дјеце са посебним потребама'
 WHERE slug = 'psychological-assessment-for-children-with-special-needs';

UPDATE medical_services SET
	name_sr = 'Liječenje pulpitisa',
	name_sr_cyrl = 'Лијечење пулпитиса'
 WHERE slug = 'pulpitis-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење пулпита једнокоријеног зуба машински'
 WHERE slug = 'pulpitis-treatment-single-root-machine';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење пулпита једнокоријеног зуба NiTi'
 WHERE slug = 'pulpitis-treatment-single-root-niti';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење пулпита трокоријеног зуба машински'
 WHERE slug = 'pulpitis-treatment-three-root-machine';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење пулпита трокоријеног зуба NiTi'
 WHERE slug = 'pulpitis-treatment-three-root-niti';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење пулпита двокоријеног зуба машински'
 WHERE slug = 'pulpitis-treatment-two-root-machine';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење пулпита двокоријеног зуба NiTi'
 WHERE slug = 'pulpitis-treatment-two-root-niti';

UPDATE medical_services SET
	name_sr_cyrl = 'Пункција и дренажа епидуралног или субдуралног или можданог апсцеса',
	name_ru = 'Пункция и дренирование эпи/субдурального или мозгового абсцесса'
 WHERE slug = 'puncture-and-drainage-of-episubdural-or-brain-abscess';

UPDATE medical_services SET
	name_sr_cyrl = 'Испитивање слуха тонално-лиминарном аудиометријом код дјеце до 7 година'
 WHERE slug = 'pure-tone-audiometry-in-children-up-to-7-years';

UPDATE medical_services SET
	name_ru = 'Пиелоуретеропластика'
 WHERE slug = 'pyeloureteroplasty';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура дијафизе радиуса — затворена или отворена са отвореном репозицијом, са/без фиксације',
	name_ru = 'Открытая репозиция перелома диафиза лучевой кости (закрытого или открытого) с фиксацией или без',
	name_de = 'Radiusdiaphysenfraktur (geschlossen oder offen), offene Reposition mit oder ohne Fixation',
	name_tr = 'Radius diyafiz kırığı (kapalı veya açık), açık redüksiyon, fiksasyonlu veya fiksasyonsuz'
 WHERE slug = 'radial-diaphysis-fracture-closed-or-open-withwithout-fixation';

UPDATE medical_services SET
	name_ru = 'Резекция головки лучевой кости'
 WHERE slug = 'radial-head-resection';

UPDATE medical_services SET
	name_ru = 'Радикальная мастэктомия с подмышечной лимфодиссекцией'
 WHERE slug = 'radical-mastectomy-with-axillary-evacuation';

UPDATE medical_services SET
	name_sr_cyrl = 'Уклањање кожних промјена радиоталасима'
 WHERE slug = 'radiowave-skin-lesion-removal';

UPDATE medical_services SET
	name_sr_cyrl = 'Реконструкција крвних судова мозга у торакалном дијелу са синтетском протезом by-pass'
 WHERE slug = 'reconstruction-of-brain-vessels-in-thoracic-region-with-synthetic-prosthesis-bypass';

UPDATE medical_services SET
	name_ru = 'Реконструкция поражений сетчатки и сосудистой оболочки'
 WHERE slug = 'reconstruction-of-retinal-and-choroidal-lesions';

UPDATE medical_services SET
	name_sr_cyrl = 'Вађење страног тијела из ректума ректалним путем'
 WHERE slug = 'rectal-foreign-body-removal-transrectal';

UPDATE medical_services SET
	name_sr_cyrl = 'Ректоскопија са узимањем исјечка'
 WHERE slug = 'rectoscopy-with-biopsy';

UPDATE medical_services SET
	name_sr_cyrl = 'Рецидив херније препонског канала који је рађен PHS методом без инфекције импланта'
 WHERE slug = 'recurrent-inguinal-hernia-after-phs-method-no-implant-infection';

UPDATE medical_services SET
	name_sr_cyrl = 'Одређивање рефракције на широку зјеницу са астигматизмом'
 WHERE slug = 'refraction-with-wide-pupil-with-astigmatism';

UPDATE medical_services SET
	name_sr_cyrl = 'Одређивање рефракције на широку зјеницу без астигматизма'
 WHERE slug = 'refraction-with-wide-pupil-without-astigmatism';

UPDATE medical_services SET
	name_sr_cyrl = 'Вађење инфицираног имплантата код великих вентралних хернија'
 WHERE slug = 'removal-of-infected-implant-from-large-ventral-hernia';

UPDATE medical_services SET
	name_sr_cyrl = 'Вађење инфицираног имплантата код мањих препонских хернија'
 WHERE slug = 'removal-of-infected-implant-from-smaller-inguinal-hernia';

UPDATE medical_services SET
	name_sr_cyrl = 'Одстрањивање непенетрирајућих страних тијела'
 WHERE slug = 'removal-of-non-penetrating-foreign-bodies';

UPDATE medical_services SET
	name_sr_cyrl = 'Вађење субтоталне протезе кука и припрема за реинтервенцију протезе'
 WHERE slug = 'removal-of-subtotal-hip-prosthesis-with-reintervention-prep';

UPDATE medical_services SET
	name_sr_cyrl = 'Вађење тоталне протезе кука и припрема за реинтервенцију протезе'
 WHERE slug = 'removal-of-total-hip-prosthesis-with-reintervention-prep';

UPDATE medical_services SET
	name_sr_cyrl = 'Реконструкција артерије реналис by-pass поступком (аутовени/синтетски графт)'
 WHERE slug = 'renal-artery-bypass-reconstruction-autovenoussynthetic';

UPDATE medical_services SET
	name_ru = 'Тромбэндартерэктомия почечной артерии с заплатой',
	name_tr = 'Yamalı renal arter trombendarterektomi'
 WHERE slug = 'renal-artery-thrombendarterectomy-with-patch';

UPDATE medical_services SET
	name_sr_cyrl = 'Пластична операција на пелвис реналису са или без нефростоме'
 WHERE slug = 'renal-pelvis-plastic-surgery-with-or-without-nephrostomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Динамска сцинтиграфија бубрега са диуретском стимулацијом'
 WHERE slug = 'renal-scintigraphy-with-diuretic-stimulation';

UPDATE medical_services SET
	name_sr_cyrl = 'Репозициони маневар за лијечење бенигног пароксизмалног вертига'
 WHERE slug = 'repositioning-maneuver-for-bppv-treatment';

UPDATE medical_services SET
	name_ru = 'Резекция и анастомоз подмышечной артерии'
 WHERE slug = 'resection-and-anastomosis-of-axillary-artery';

UPDATE medical_services SET
	name_sr_cyrl = 'Ресекција и анастомоза екстра- и интракранијалних артерија (вратни дио)'
 WHERE slug = 'resection-and-anastomosis-of-extraintracranial-arteries-cervical';

UPDATE medical_services SET
	name_sr_cyrl = 'Ресекција и анастомоза интракранијалних артерија (торакални дио)'
 WHERE slug = 'resection-and-anastomosis-of-intracranial-arteries-thoracic';

UPDATE medical_services SET
	name_sr_cyrl = 'Ресекција и анастомоза артерије субклавије (подкључни дио)'
 WHERE slug = 'resection-and-anastomosis-of-subclavian-artery-subclavian';

UPDATE medical_services SET
	name_sr_cyrl = 'Ресекција и анастомоза артерије субклавије (торакални дио)'
 WHERE slug = 'resection-and-anastomosis-of-subclavian-artery-thoracic';

UPDATE medical_services SET
	name_sr_cyrl = 'Операција мрежњаче и судовњаче (аблација са пункцијом, каутером)'
 WHERE slug = 'retinal-and-choroidal-surgery-detachment-with-puncture-cautery';

UPDATE medical_services SET
	name_sr_cyrl = 'Уретеропиелографија ретроградна код мушкараца и дјеце'
 WHERE slug = 'retrograde-ureteropyelography-in-males-and-children';

UPDATE medical_services SET
	name_sr_cyrl = 'Испитивање Rh-D антигена/гел метода'
 WHERE slug = 'rh-d-antigen-testing-gel-method';

UPDATE medical_services SET
	name_sr_cyrl = 'РЕУМА ФАКТОР (РФ) LATEX'
 WHERE slug = 'rheumatoid-factor-latex-test';

UPDATE medical_services SET
	name_sr_cyrl = 'Ресекција ребра код thoracic outlet syndroma'
 WHERE slug = 'rib-resection-for-thoracic-outlet-syndrome';

UPDATE medical_services SET
	name_sr = 'Desna hemikolektomija i anastomoza crijeva',
	name_sr_cyrl = 'Десна хемиколектомија и анастомоза цријева'
 WHERE slug = 'right-hemicolectomy-with-anastomosis';

UPDATE medical_services SET
	name_sr_cyrl = 'Езофагоскопија ригидна — са одстрањивањем страног тијела код одраслих'
 WHERE slug = 'rigid-esophagoscopy-with-foreign-body-removal-in-adults';

UPDATE medical_services SET
	name_sr_cyrl = 'Езофагоскопија ригидна — са одстрањивањем страног тијела код дјеце до 10 година'
 WHERE slug = 'rigid-esophagoscopy-with-foreign-body-removal-in-children-up-to-10-years';

UPDATE medical_services SET
	name_sr = 'Definitivna opturacija kanala korijena',
	name_sr_cyrl = 'Дефинитивна оптурација канала коријена'
 WHERE slug = 'root-canal-obturation';

UPDATE medical_services SET
	name_sr = 'Primarna obrada kanala korijena',
	name_sr_cyrl = 'Примарна обрада канала коријена'
 WHERE slug = 'root-canal-preparation';

UPDATE medical_services SET
	name_sr_cyrl = 'Ревизија лијечења канала коријена'
 WHERE slug = 'root-canal-retreatment';

UPDATE medical_services SET
	name_sr = 'Liječenje korijenskog kanala prvi korijen',
	name_sr_cyrl = 'Лијечење коријенског канала први коријен'
 WHERE slug = 'root-canal-treatment-first-root';

UPDATE medical_services SET
	name_sr = 'Liječenje korijenskog kanala drugi korijen',
	name_sr_cyrl = 'Лијечење коријенског канала други коријен'
 WHERE slug = 'root-canal-treatment-second-root';

UPDATE medical_services SET
	name_sr = 'Liječenje korijenskog kanala treći korijen',
	name_sr_cyrl = 'Лијечење коријенског канала трећи коријен'
 WHERE slug = 'root-canal-treatment-third-root';

UPDATE medical_services SET
	name_sr_cyrl = 'Дилатација отвора канала пљувачне жлијезде'
 WHERE slug = 'salivary-gland-duct-opening-dilatation';

UPDATE medical_services SET
	name_sr_cyrl = 'Инцизија пљувачне жлијезде или канала'
 WHERE slug = 'salivary-gland-or-duct-incision';

UPDATE medical_services SET
	name_sr_cyrl = 'Шанцов оковратник'
 WHERE slug = 'schanz-collar-application';

UPDATE medical_services SET
	name_tr = 'Ven skleroterapisi'
 WHERE slug = 'sclerotherapy-veins';

UPDATE medical_services SET
	name_sr_cyrl = 'Цирконијум круница на имплантату на шрафљење'
 WHERE slug = 'screw-retained-implant-crown-zirconia';

UPDATE medical_services SET
	name_sr_cyrl = 'Остеотомија друге фаланге, било који прст'
 WHERE slug = 'second-phalanx-osteotomy-any-toe';

UPDATE medical_services SET
	name_sr_cyrl = 'Аспирирање секрета код дојенчади и мале дјеце'
 WHERE slug = 'secretion-aspiration-in-infants-and-young-children';

UPDATE medical_services SET
	name_sr_cyrl = 'Изометријске вјежбе — сегментне'
 WHERE slug = 'segmental-isometric-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Селективна артеријска инфузија вазопресина и простагландина у цријевне артерије'
 WHERE slug = 'selective-arterial-vasopressin-and-prostaglandin-infusion-in-mesenteric-arteries';

UPDATE medical_services SET
	name_sr_cyrl = 'Боравак у полуинтензивној њези'
 WHERE slug = 'semi-intensive-care-bed-day';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење сенилне кератозе течним азотом по сеанси'
 WHERE slug = 'senile-keratosis-treatment-with-liquid-nitrogen-per-session';

UPDATE medical_services SET
	name_sr_cyrl = 'Дислокација рамена — затворена или отворена (сложена)'
 WHERE slug = 'shoulder-dislocation-open-or-closed';

UPDATE medical_services SET
	name_sr_cyrl = 'Заштитни подизач рамена — митела'
 WHERE slug = 'shoulder-sling-mitella';

UPDATE medical_services SET
	name_ru = 'Резекция сигмовидной кишки и верхнего отдела прямой кишки с выведением стомы (операция Гартмана)',
	name_de = 'Sigma- und obere Rektumresektion mit Hartmann-Stoma'
 WHERE slug = 'sigmoid-and-upper-rectal-resection-with-hartmann-stoma';

UPDATE medical_services SET
	name_sr = 'Zamjena silikonskog ulja',
	name_sr_cyrl = 'Замјена силиконског уља'
 WHERE slug = 'silicone-oil-exchange';

UPDATE medical_services SET
	name_sr_cyrl = 'Затварање синуса са уклањањем страног тијела'
 WHERE slug = 'sinus-closure-with-foreign-body-removal';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе равнотеже сједећег или стојећег става'
 WHERE slug = 'sitting-or-standing-balance-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Скијаскопија код дјеце'
 WHERE slug = 'skiascopy-in-children';

UPDATE medical_services SET
	name_sr_cyrl = 'Медицински третман обољеле коже'
 WHERE slug = 'skin-disease-medical-treatment';

UPDATE medical_services SET
	name_sr_cyrl = 'Одстрањење тумора лобањских костију'
 WHERE slug = 'skull-bone-tumor-removal';

UPDATE medical_services SET
	name_sr_cyrl = 'Слееве гастректомија'
 WHERE slug = 'sleeve-gastrectomy';

UPDATE medical_services SET
	name_sr = 'Parcijalna resekcija tankih crijeva sa ileostomom',
	name_sr_cyrl = 'Парцијална ресекција танких цријева са илеостомом'
 WHERE slug = 'small-bowel-partial-resection-with-ileostomy';

UPDATE medical_services SET
	name_sr = 'Parcijalna resekcija tankih crijeva sa primarnom anastomozom',
	name_sr_cyrl = 'Парцијална ресекција танких цријева са примарном анастомозом'
 WHERE slug = 'small-bowel-partial-resection-with-primary-anastomosis';

UPDATE medical_services SET
	name_sr_cyrl = 'Ресекција танког цријева са анастомозом'
 WHERE slug = 'small-bowel-resection-with-anastomosis';

UPDATE medical_services SET
	name_sr_cyrl = 'Ресекција танког цријева са формирањем стоме'
 WHERE slug = 'small-bowel-resection-with-stoma-formation';

UPDATE medical_services SET
	name_sr_cyrl = 'Танко цријево - стандардна рентгеноскопска пасажа'
 WHERE slug = 'small-bowel-standard-fluoroscopic-passage';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе фузије у простору'
 WHERE slug = 'spatial-fusion-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежба мишића у простору или на апарату'
 WHERE slug = 'spatial-or-apparatus-eye-muscle-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Логопедска процјена артикулационих способности дјетета'
 WHERE slug = 'speech-therapy-assessment-of-childs-articulation-abilities';

UPDATE medical_services SET
	name_sr_cyrl = 'Логопедска процјена специфичних поремећаја учења'
 WHERE slug = 'speech-therapy-assessment-of-specific-learning-disorders';

UPDATE medical_services SET
	name_sr_cyrl = 'Логопедска процјена степена и тежине муцања'
 WHERE slug = 'speech-therapy-assessment-of-stuttering-severity';

UPDATE medical_services SET
	name_sr_cyrl = 'Логопедска, соматопедска и олигофренолошка процјена'
 WHERE slug = 'speech-therapy-somatopedic-and-oligophrenological-assessment';

UPDATE medical_services SET
	name_sr_cyrl = 'Ексцизија сперматокеле са епидидимектомијом'
 WHERE slug = 'spermatocele-excision-with-epididymectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Ексцизија сперматокеле без епидидимектомије'
 WHERE slug = 'spermatocele-excision-without-epididymectomy';

UPDATE medical_services SET
	name_sr = 'Liječenje deformiteta kičmenog stuba kod djece i omladine',
	name_sr_cyrl = 'Лијечење деформитета кичменог стуба код дјеце и омладине'
 WHERE slug = 'spinal-deformity-treatment-in-children-and-adolescents';

UPDATE medical_services SET
	name_sr_cyrl = 'Евакуација спонтаног интрацеребралног хематома'
 WHERE slug = 'spontaneous-intracerebral-hematoma-evacuation';

UPDATE medical_services SET
	name_sr_cyrl = 'Боравак у обичној њези'
 WHERE slug = 'standard-care-bed-day';

UPDATE medical_services SET
	name_sr_cyrl = 'Припрема стандардног тромбоцитног концентрата из јединице цијеле крви (PRP)'
 WHERE slug = 'standard-platelet-concentrate-preparation-from-whole-blood-prp';

UPDATE medical_services SET
	name_sr_cyrl = 'Стапедовестибуларна операција (стапедопластика, фенестрација, мобилизација, адхезиолиза)',
	name_ru = 'Стапедовестибуларная операция'
 WHERE slug = 'stapedovestibular-surgery-stapedoplasty-fenestration-mobilization-adhesiolysis';

UPDATE medical_services SET
	name_sr_cyrl = 'Стимулативне вјежбе код ризично рођене дјеце'
 WHERE slug = 'stimulative-exercises-for-at-risk-infants';

UPDATE medical_services SET
	name_sr_cyrl = 'Одређивање I/T (интензитет–вријеме) криве'
 WHERE slug = 'strength-duration-curve-determination';

UPDATE medical_services SET
	name_ru = 'Аневризмэктомия и реконструкция подключичной артерии'
 WHERE slug = 'subclavian-aneurysmectomy-and-reconstruction';

UPDATE medical_services SET
	name_sr_cyrl = 'Лигатура артерије субклавије у подкључном дијелу'
 WHERE slug = 'subclavian-artery-ligation-subclavian-region';

UPDATE medical_services SET
	name_sr_cyrl = 'Реконструкција артерије или вене субклавије by-pass поступком венским или синтетским графтом'
 WHERE slug = 'subclavian-artery-or-vein-bypass-with-venous-or-synthetic-graft';

UPDATE medical_services SET
	name_sr_cyrl = 'Лигатура подкључне артерије или вене у торакалном дијелу'
 WHERE slug = 'subclavian-artery-or-vein-ligation-thoracic';

UPDATE medical_services SET
	name_sr_cyrl = 'Сутура артерије или вене субклавије (подкључни дио)'
 WHERE slug = 'subclavian-artery-or-vein-suture-subclavian-region';

UPDATE medical_services SET
	name_sr_cyrl = 'Сутура артерије или вене субклавије (торакални дио)'
 WHERE slug = 'subclavian-artery-or-vein-suture-thoracic';

UPDATE medical_services SET
	name_sr_cyrl = 'Тромбендартеректомија артерије субклавије (торакални дио)'
 WHERE slug = 'subclavian-artery-thrombendarterectomy-thoracic';

UPDATE medical_services SET
	name_ru = 'Тромбэндартерэктомия подключичной артерии с заплатой',
	name_tr = 'Yamalı subklavian arter trombendarterektomi'
 WHERE slug = 'subclavian-artery-thrombendarterectomy-with-patch';

UPDATE medical_services SET
	name_sr_cyrl = 'Тромбендартеректомија са patch-пластиком артерије субклавије (подкључни дио)'
 WHERE slug = 'subclavian-artery-thrombendarterectomy-with-patch-subclavian';

UPDATE medical_services SET
	name_sr_cyrl = 'Транспозиција великих крвних судова — субклавио-каротидна транспозиција'
 WHERE slug = 'subclavian-carotid-transposition';

UPDATE medical_services SET
	name_sr_cyrl = 'Фасциотомија палмарна субкутана (Dupuytren)'
 WHERE slug = 'subcutaneous-palmar-fasciotomy-dupuytren';

UPDATE medical_services SET
	name_sr_cyrl = 'Фасциотомија плантарна и/или прста — субкутана'
 WHERE slug = 'subcutaneous-plantar-or-toe-fasciotomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Екстракција калкулуса из изводног канала субмандибуларне жлијезде'
 WHERE slug = 'submandibular-duct-calculus-extraction';

UPDATE medical_services SET
	name_sr_cyrl = 'Субтотална колектомија са анастомозом (десни, трансверзални, лијеви колон)'
 WHERE slug = 'subtotal-colectomy-with-anastomosis-right-transverse-left-colon';

UPDATE medical_services SET
	name_sr_cyrl = 'Мјерење притиска површинских вена'
 WHERE slug = 'superficial-vein-pressure-measurement';

UPDATE medical_services SET
	name_sr_cyrl = 'Реконструкција вене цаве супериор by-pass поступком (синтетски графт)'
 WHERE slug = 'superior-vena-cava-bypass-reconstruction-synthetic-graft';

UPDATE medical_services SET
	name_sr_cyrl = 'Супракондиларна или транскондиларна фрактура хумеруса — затворена'
 WHERE slug = 'supracondylar-or-transcondylar-humerus-fracture-closed';

UPDATE medical_services SET
	name_sr_cyrl = 'Замјена супрапубичног катетера'
 WHERE slug = 'suprapubic-catheter-replacement';

UPDATE medical_services SET
	name_sr_cyrl = 'Репарација руптуриране тетиве супраспинатуса или других'
 WHERE slug = 'supraspinatus-or-other-rotator-cuff-tendon-repair';

UPDATE medical_services SET
	name_sr_cyrl = 'Примјена сурфактанта код новорођенчади'
 WHERE slug = 'surfactant-administration-in-neonates';

UPDATE medical_services SET
	name_sr_cyrl = 'Оперативно лијечење врло волуминозне херније (величине дјечије главе)'
 WHERE slug = 'surgery-for-very-large-hernia-pediatric-head-size';

UPDATE medical_services SET
	name_sr_cyrl = 'Оперативно одстрањење страног тијела из уха'
 WHERE slug = 'surgical-foreign-body-removal-from-ear';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура хируршког врата скапуле — затворена или отворена'
 WHERE slug = 'surgical-neck-of-scapula-fracture-closed-or-open';

UPDATE medical_services SET
	name_sr_cyrl = 'Хируршка екстирпација ринолита или страног тијела из носа латералном ринотомијом'
 WHERE slug = 'surgical-rhinolith-or-foreign-body-extraction-by-lateral-rhinotomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Хирушка ексцизија круне зуба'
 WHERE slug = 'surgical-tooth-crown-excision';

UPDATE medical_services SET
	name_sr_cyrl = 'Оперативно лијечење грудног коша и плућа'
 WHERE slug = 'surgical-treatment-of-chest-and-lungs';

UPDATE medical_services SET
	name_sr_cyrl = 'Хируршко збрињавање обољелог нокта'
 WHERE slug = 'surgical-treatment-of-diseased-nail';

UPDATE medical_services SET
	name_sr_cyrl = 'Оперативно лијечење циста доњег зида усне шупљине'
 WHERE slug = 'surgical-treatment-of-lower-oral-cavity-cysts';

UPDATE medical_services SET
	name_sr_cyrl = 'Оперативно лијечење дифузне периуретралне гангрене, флегмона и абсцеса'
 WHERE slug = 'surgical-treatment-of-periurethral-gangrenephlegmonabscess';

UPDATE medical_services SET
	name_sr_cyrl = 'Оперативно лијечење уретрокеле'
 WHERE slug = 'surgical-treatment-of-urethrocele';

UPDATE medical_services SET
	name_sr = 'Hirurška obrada rana na tijelu',
	name_sr_cyrl = 'Хируршка обрада рана на тијелу'
 WHERE slug = 'surgical-wound-treatment-body';

UPDATE medical_services SET
	name_sr_cyrl = 'Сутура екстракранијалног дијела крвног суда мозга (вратни дио)'
 WHERE slug = 'suture-of-extracranial-cerebral-vessel-cervical';

UPDATE medical_services SET
	name_sr_cyrl = 'Сутура екстракранијалног дијела крвног суда мозга (торакални дио)'
 WHERE slug = 'suture-of-extracranial-cerebral-vessel-thoracic';

UPDATE medical_services SET
	name_sr_cyrl = 'Сутура повреде дебелог цријева'
 WHERE slug = 'suture-of-large-bowel-injury';

UPDATE medical_services SET
	name_sr_cyrl = 'Сутура повреде танког цријева'
 WHERE slug = 'suture-of-small-bowel-injury';

UPDATE medical_services SET
	name_sr_cyrl = 'Сутура везико вагиналне постирадиационе фистуле',
	name_ru = 'Шов везиковагинальной постлучевой фистулы'
 WHERE slug = 'suture-of-vesicovaginal-postirradiation-fistula';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе фузије на синоптофору — са накнадним и реалним сликама'
 WHERE slug = 'synoptophore-fusion-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Ресекција и синтетски графт екстракранијалних артерија (торакални дио)'
 WHERE slug = 'synthetic-graft-of-extracranial-arteries-thoracic';

UPDATE medical_services SET
	name_sr_cyrl = 'Ресекција и синтетски графт артерије субклавије у подкључном дијелу'
 WHERE slug = 'synthetic-graft-of-subclavian-artery-subclavian';

UPDATE medical_services SET
	name_sr_cyrl = 'Ресекција и синтетски графт артерије субклавије у грудном дијелу'
 WHERE slug = 'synthetic-graft-of-subclavian-artery-thoracic';

UPDATE medical_services SET
	name_sr_cyrl = 'Надомјештање испалог Т-дрена под контролом ЦТ-а'
 WHERE slug = 't-drain-replacement-under-ct-guidance';

UPDATE medical_services SET
	name_ru = 'Остеотомия таранной кости'
 WHERE slug = 'talus-osteotomy';

UPDATE medical_services SET
	name_ru = 'Кольпоцистоуретропексия (Tanagho/Burch)'
 WHERE slug = 'tanagho-or-burch-colpocystourethropexy';

UPDATE medical_services SET
	name_sr_cyrl = 'Циљано снимање једњака, желуца, дуоденума и цријева'
 WHERE slug = 'targeted-upper-gi-tract-x-ray';

UPDATE medical_services SET
	name_sr_cyrl = 'Дислокација тарзалних кости — затворена или отворена са/без фиксације'
 WHERE slug = 'tarsal-bone-dislocation-reduction-withwithout-fixation';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура тарзалне кости — затворена или отворена са/без унутрашње или спољне фиксације'
 WHERE slug = 'tarsal-bone-fracture-reduction-withwithout-fixation';

UPDATE medical_services SET
	name_sr_cyrl = 'Дислокација тарзометатарзалног зглоба — затворена или отворена',
	name_ru = 'Репозиция вывиха предплюсне-плюсневого сустава (закрытая или открытая)',
	name_de = 'Tarsometatarsalgelenk-Reposition (geschlossen oder offen)',
	name_tr = 'Tarsometatarsal eklem dislokasyonu redüksiyonu (kapalı veya açık)'
 WHERE slug = 'tarsometatarsal-joint-dislocation-reduction';

UPDATE medical_services SET
	name_sr_cyrl = 'Адаптација — испитивање по Тüбингеру'
 WHERE slug = 'tbinger-adaptation-test';

UPDATE medical_services SET
	name_sr = 'Tecar stomak noge leđa'
 WHERE slug = 'tecar-stomach-leg-back';

UPDATE medical_services SET
	name_sr_cyrl = 'Текар'
 WHERE slug = 'tecar-therapy';

UPDATE medical_services SET
	name_sr = 'Izbjeljivanje zuba',
	name_sr_cyrl = 'Избјељивање зуба'
 WHERE slug = 'teeth-whitening';

UPDATE medical_services SET
	name_sr_cyrl = 'Апликација лијека и привремени испун'
 WHERE slug = 'temporary-filling-with-medication';

UPDATE medical_services SET
	name_ru = 'Деторсия яичка с фиксацией контралатерального яичка',
	name_de = 'Hodentorsionsreposition mit Gegenseitenfixierung'
 WHERE slug = 'testicular-torsion-reduction-with-contralateral-fixation';

UPDATE medical_services SET
	name_sr = 'Terapijska masaža djelimična',
	name_sr_cyrl = 'Терапијска масажа дјелимична'
 WHERE slug = 'therapeutic-massage-partial';

UPDATE medical_services SET
	name_sr_cyrl = 'Терапија неуробластома и феохромоцитома са МИБИ-И-131'
 WHERE slug = 'therapy-of-neuroblastoma-and-pheochromocytoma-with-mibg-i-131';

UPDATE medical_services SET
	name_sr_cyrl = 'Репозиција — гипс наткољенице (лонгета или пуни гипс)'
 WHERE slug = 'thigh-plaster-immobilization';

UPDATE medical_services SET
	name_sr_cyrl = 'Реконструкција грудне аорте by-pass поступком (синтетска протеза)'
 WHERE slug = 'thoracic-aorta-bypass-reconstruction-synthetic-prosthesis';

UPDATE medical_services SET
	name_sr_cyrl = 'Торакоскопска операција релаксације дијафрагме'
 WHERE slug = 'thoracoscopic-diaphragm-plication';

UPDATE medical_services SET
	name_sr_cyrl = 'Торакоскопска ексцизија лезије са дијафрагме'
 WHERE slug = 'thoracoscopic-diaphragmatic-lesion-excision';

UPDATE medical_services SET
	name_sr_cyrl = 'Торакоскопска репарација руптуре дијафрагме'
 WHERE slug = 'thoracoscopic-diaphragmatic-rupture-repair';

UPDATE medical_services SET
	name_sr_cyrl = 'Торакоскопска билобектомија плућа'
 WHERE slug = 'thoracoscopic-lung-bilobectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Торакоскопска декортикација плућа'
 WHERE slug = 'thoracoscopic-lung-decortication';

UPDATE medical_services SET
	name_sr_cyrl = 'Торакоскопска лобектомија плућа'
 WHERE slug = 'thoracoscopic-lung-lobectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Торакоскопска сегментектомија'
 WHERE slug = 'thoracoscopic-lung-segmentectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Торакоскопска репарација параезофагеалне херније'
 WHERE slug = 'thoracoscopic-paraesophageal-hernia-repair';

UPDATE medical_services SET
	name_sr_cyrl = 'Торакоскопска плеуректомија — парцијална или тотална'
 WHERE slug = 'thoracoscopic-pleurectomy-partial-or-total';

UPDATE medical_services SET
	name_sr_cyrl = 'Торакоскопска пнеумонектомија'
 WHERE slug = 'thoracoscopic-pneumonectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Торакоскопска ресекција була на плућима',
	name_ru = 'Торакоскопическая резекция булл'
 WHERE slug = 'thoracoscopic-pulmonary-bullae-resection';

UPDATE medical_services SET
	name_sr_cyrl = 'Торакоскопска wedge ресекција плућа'
 WHERE slug = 'thoracoscopic-pulmonary-wedge-resection';

UPDATE medical_services SET
	name_sr_cyrl = 'Торакоскопска операција ductusa thoracicusa'
 WHERE slug = 'thoracoscopic-thoracic-duct-surgery';

UPDATE medical_services SET
	name_sr_cyrl = 'Торакоскопска тимектомија'
 WHERE slug = 'thoracoscopic-thymectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Биопсија штитасте жлијезде'
 WHERE slug = 'thyroid-biopsy';

UPDATE medical_services SET
	name_sr = 'Ultrazvuk štitne žlijezde',
	name_sr_cyrl = 'Ултразвук штитне жлијезде'
 WHERE slug = 'thyroid-ultrasound';

UPDATE medical_services SET
	name_sr_cyrl = 'Операција штитне жлијезде'
 WHERE slug = 'thyroidectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура дијафизе тибије — затворена или отворена, са унутрашњом или спољном фиксацијом'
 WHERE slug = 'tibia-diaphysis-fracture-reduction-with-internalexternal-fixation';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура тибије — затворена или отворена, са или без унутрашње фиксације',
	name_ru = 'Репозиция перелома большеберцовой кости (закрытая или открытая) с внутренней фиксацией или без',
	name_de = 'Tibiafrakturreposition (geschlossen oder offen) mit oder ohne interne Fixation',
	name_tr = 'Tibia kırığı redüksiyonu (kapalı veya açık), iç fiksasyonlu veya fiksasyonsuz'
 WHERE slug = 'tibial-fracture-reduction-closed-or-open-withwithout-fixation';

UPDATE medical_services SET
	name_ru = 'Остеотомия большеберцовой кости'
 WHERE slug = 'tibial-osteotomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе за постизање тоничне уједначености'
 WHERE slug = 'tone-equalization-exercises';

UPDATE medical_services SET
	name_ru = 'Тонзиллэктомия с аденотомией'
 WHERE slug = 'tonsillectomy-with-adenotomy';

UPDATE medical_services SET
	name_ru = 'Тотальная цистэктомия с уретеросигмостомой Майнц-Пауч I'
 WHERE slug = 'total-cystectomy-with-mainz-pouch-i-ureterosigmoidostomy';

UPDATE medical_services SET
	name_ru = 'Тотальная цистэктомия с уретерокутанеостомией'
 WHERE slug = 'total-cystectomy-with-ureterocutaneostomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Реконструкција уха — тотална, независна од методе'
 WHERE slug = 'total-ear-reconstruction';

UPDATE medical_services SET
	name_sr_cyrl = 'Имплантација тоталне протезе кољена'
 WHERE slug = 'total-knee-replacement';

UPDATE medical_services SET
	name_sr_cyrl = 'Трахеобронхоскопија са одстрањивањем страног тијела код одраслих'
 WHERE slug = 'tracheobronchoscopy-with-foreign-body-removal-in-adults';

UPDATE medical_services SET
	name_sr_cyrl = 'Трахеобронхоскопија са одстрањивањем страног тијела код дјеце (до 10 година)'
 WHERE slug = 'tracheobronchoscopy-with-foreign-body-removal-in-children-up-to-10-years';

UPDATE medical_services SET
	name_sr_cyrl = 'Трахеотомија са одстрањењем страног тијела из трахеје'
 WHERE slug = 'tracheotomy-with-tracheal-foreign-body-removal';

UPDATE medical_services SET
	name_sr_cyrl = 'Транснавикуларно перилунарни тип фрактуре — затворена или отворена'
 WHERE slug = 'transnavicular-perilunate-fracture-open-or-closed';

UPDATE medical_services SET
	name_sr_cyrl = 'Трансторакална езофаго-кардиомиотомија са евентуалном репарацијом хијатуса',
	name_ru = 'Трансторакальная эзофагокардиомиотомия с пластикой пищеводного отверстия диафрагмы'
 WHERE slug = 'transthoracic-esophagocardiomyotomy-with-hiatus-repair';

UPDATE medical_services SET
	name_sr_cyrl = 'Езофаготомија — трансторакална, збрињавање перфорације, одстрањење страног тијела једњака'
 WHERE slug = 'transthoracic-esophagotomy-for-perforation-or-foreign-body';

UPDATE medical_services SET
	name_sr_cyrl = 'Операција уклијештене дијафрагмалне киле са ресекцијом трансторакалним путем'
 WHERE slug = 'transthoracic-surgery-of-incarcerated-diaphragmatic-hernia-with-resection';

UPDATE medical_services SET
	name_sr_cyrl = 'Трауматска дислокација зглоба кука — затворена или отворена'
 WHERE slug = 'traumatic-hip-dislocation-closed-or-open';

UPDATE medical_services SET
	name_sr = 'Kontrola liječenja u mjesecu nakon prvog pregleda',
	name_sr_cyrl = 'Контрола лијечења у мјесецу након првог прегледа'
 WHERE slug = 'treatment-follow-up-first-month';

UPDATE medical_services SET
	name_sr_cyrl = 'Терапија повреда аналног предјела или лезија ануса без шава'
 WHERE slug = 'treatment-of-anal-region-injuries-or-lesions-without-suture';

UPDATE medical_services SET
	name_sr_cyrl = 'Обрада лацерационих рана на глави и мањих депресивних фрактура костију главе'
 WHERE slug = 'treatment-of-head-lacerations-and-minor-skull-depression-fractures';

UPDATE medical_services SET
	name_sr_cyrl = 'Лијечење хипертиреоидних пацијената терапијском дозом I-131'
 WHERE slug = 'treatment-of-hyperthyroid-patients-with-therapeutic-i-131-dose';

UPDATE medical_services SET
	name_sr_cyrl = 'Обрада већих рана са дефектом коже које захтјевају затварање'
 WHERE slug = 'treatment-of-larger-wounds-with-skin-defect-closure';

UPDATE medical_services SET
	name_sr_cyrl = 'Трепанотрабекулотомија, гониотомија, гониопункција и друге операције против глаукома'
 WHERE slug = 'trepanotrabeculotomy-goniotomy-goniopuncture-for-glaucoma';

UPDATE medical_services SET
	name_sr_cyrl = 'Трихолоски преглед'
 WHERE slug = 'trichologist-examination';

UPDATE medical_services SET
	name_sr_cyrl = 'Трималеоларна фрактура глежња — затворена или отворена'
 WHERE slug = 'trimalleolar-ankle-fracture-open-or-closed-withwithout-fixation';

UPDATE medical_services SET
	name_sr_cyrl = 'Трансуретрална простатектомија — ресекција врата мокраћног мјехура'
 WHERE slug = 'tur-of-prostate-bladder-neck-resection';

UPDATE medical_services SET
	name_sr_cyrl = 'Инстилација лијека кроз бубну опну у бубну дупљу'
 WHERE slug = 'tympanic-membrane-drug-instillation';

UPDATE medical_services SET
	name_sr_cyrl = 'Парацентеза бубне опне са постављањем цјевчице за aeraciju и дренажу — обострана'
 WHERE slug = 'tympanocentesis-with-tube-placement-bilateral';

UPDATE medical_services SET
	name_sr_cyrl = 'Парацентеза бубне опне са постављањем цјевчице за аерацију и дренажу — унилатерална'
 WHERE slug = 'tympanocentesis-with-tube-placement-unilateral';

UPDATE medical_services SET
	name_ru = 'Тимпанопластика разных типов с атикотомией'
 WHERE slug = 'tympanoplasty-various-types-with-atticotomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Уградња вентилационе цјевчице у општој анестезији'
 WHERE slug = 'tympanostomy-tube-placement-general-anesthesia';

UPDATE medical_services SET
	name_sr_cyrl = 'Уградња вентилационе цјевчице у локалној анестезији'
 WHERE slug = 'tympanostomy-tube-placement-local-anesthesia';

UPDATE medical_services SET
	name_sr_cyrl = 'Уградња вентилационе цјевчице и аденоидектомија'
 WHERE slug = 'tympanostomy-tube-with-adenoidectomy';

UPDATE medical_services SET
	name_sr_cyrl = 'Фрактура дијафизе улне — затворена или отворена, отворена репозиција са/без фиксације',
	name_ru = 'Открытая репозиция перелома диафиза локтевой кости (закрытого или открытого) с фиксацией или без',
	name_de = 'Offene Reposition einer Ulnadiaphysenfraktur (geschlossen oder offen) mit oder ohne Fixation',
	name_tr = 'Ulna diyafiz kırığı (kapalı veya açık) açık redüksiyonu, fiksasyonlu veya fiksasyonsuz'
 WHERE slug = 'ulnar-diaphysis-fracture-open-reduction-withwithout-fixation';

UPDATE medical_services SET
	name_sr_cyrl = 'Лаписирање гранулома пупка'
 WHERE slug = 'umbilical-granuloma-cauterization';

UPDATE medical_services SET
	name_sr = 'Pregled, kontrola i previjanje nekomplikovane rane',
	name_sr_cyrl = 'Преглед, контрола и превијање некомпликоване ране',
	name_ru = 'Осмотр, контроль и перевязка неосложнённой раны',
	name_de = 'Untersuchung, Kontrolle und Verband bei unkomplizierter Wunde',
	name_tr = 'Komplikasyonsuz yara muayenesi, kontrolü ve pansumanı'
 WHERE slug = 'uncomplicated-wound-examination-and-dressing';

UPDATE medical_services SET
	name_sr_cyrl = 'Сијалографија једне пљувачне жлијезде на једној страни'
 WHERE slug = 'unilateral-sialography';

UPDATE medical_services SET
	name_sr_cyrl = 'Одстрањивање аерационих цјевчица — једнострано'
 WHERE slug = 'unilateral-tympanostomy-tube-removal';

UPDATE medical_services SET
	name_sr = 'Ultrazvuk gornjeg dijela abdomena',
	name_sr_cyrl = 'Ултразвук горњег дијела абдомена'
 WHERE slug = 'upper-abdomen-ultrasound';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе за корекцију деформитета горњих и доњих екстремитета'
 WHERE slug = 'upper-and-lower-extremity-deformity-correction-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Вјежбе координације горњих екстремитета'
 WHERE slug = 'upper-extremity-coordination-exercises';

UPDATE medical_services SET
	name_sr_cyrl = 'Катетеризација уретера код мушкараца и дјеце'
 WHERE slug = 'ureteral-catheterization-in-males-and-children';

UPDATE medical_services SET
	name_sr_cyrl = 'Замјена уретера илеумом'
 WHERE slug = 'ureteral-replacement-with-ileum';

UPDATE medical_services SET
	name_sr_cyrl = 'Ургентна хемодијализа — интермитентна замјена бубрежне функције'
 WHERE slug = 'urgent-hemodialysis';

UPDATE medical_services SET
	name_sr_cyrl = 'Испитивање урина са flow цитометријом'
 WHERE slug = 'urinalysis-with-flow-cytometry';

UPDATE medical_services SET
	name_sr_cyrl = 'Пластика вентралне херније са mesh-prolen мрежицом'
 WHERE slug = 'ventral-hernia-plasty-with-mesh';

UPDATE medical_services SET
	name_ru = 'Аневризмэктомия и реконструкция позвоночной артерии'
 WHERE slug = 'vertebral-aneurysmectomy-and-reconstruction';

UPDATE medical_services SET
	name_sr_cyrl = 'Репозиција фрактуре или дислокације тијела једног или више пршљенова'
 WHERE slug = 'vertebral-body-fracture-or-dislocation-reduction';

UPDATE medical_services SET
	name_ru = 'Закрытие везикокутанной фистулы'
 WHERE slug = 'vesicocutaneous-fistula-closure';

UPDATE medical_services SET
	name_ru = 'Аневризмэктомия и реконструкция висцеральных артерий'
 WHERE slug = 'visceral-arteries-aneurysmectomy-and-reconstruction';

UPDATE medical_services SET
	name_sr_cyrl = 'Реконструкција висцералне артерије by-pass поступком (аутовени/синтетски графт)'
 WHERE slug = 'visceral-artery-bypass-reconstruction-autovenoussynthetic';

UPDATE medical_services SET
	name_ru = 'Тромбэндартерэктомия висцеральной артерии с заплатой',
	name_tr = 'Yamalı visseral arter trombendarterektomi'
 WHERE slug = 'visceral-artery-thrombendarterectomy-with-patch';

UPDATE medical_services SET
	name_sr_cyrl = 'Висус код симулације и агравације'
 WHERE slug = 'visus-test-in-simulation-and-aggravation';

UPDATE medical_services SET
	name_sr_cyrl = 'Витална екстирпација вишекоријених зуба са дефинитивним пуњењем'
 WHERE slug = 'vital-extirpation-of-multi-root-teeth-with-definitive-filling';

UPDATE medical_services SET
	name_sr_cyrl = 'Витална екстирпација једнокоријених зуба са дефинитивним пуњењем'
 WHERE slug = 'vital-extirpation-of-single-root-teeth-with-definitive-filling';

UPDATE medical_services SET
	name_sr = 'Revizija prostora staklastog tijela',
	name_sr_cyrl = 'Ревизија простора стакластог тијела'
 WHERE slug = 'vitreous-cavity-revision';

UPDATE medical_services SET
	name_sr_cyrl = 'Рендген абдомена тАУ нативни снимак'
 WHERE slug = 'x-ray-abdomen-native';

UPDATE medical_services SET
	name_sr = 'Rendgen skočnog zgloba'
 WHERE slug = 'x-ray-ankle';

UPDATE medical_services SET
	name_sr_cyrl = 'RTG обе подлактице'
 WHERE slug = 'x-ray-both-forearms';

UPDATE medical_services SET
	name_sr_cyrl = 'RTG обе ┼баке'
 WHERE slug = 'x-ray-both-hands';

UPDATE medical_services SET
	name_sr = 'Rendgen oba koljena'
 WHERE slug = 'x-ray-both-knees';

UPDATE medical_services SET
	name_sr = 'Rendgen oba koljena u oba pravca',
	name_sr_cyrl = 'Рендген оба кољена у оба правца'
 WHERE slug = 'x-ray-both-knees-two-views';

UPDATE medical_services SET
	name_sr_cyrl = 'RTG обе поткољенице'
 WHERE slug = 'x-ray-both-lower-legs';

UPDATE medical_services SET
	name_sr_cyrl = 'RTG обе надлактице'
 WHERE slug = 'x-ray-both-upper-arms';

UPDATE medical_services SET
	name_sr = 'Rendgen oba ručna zgloba'
 WHERE slug = 'x-ray-both-wrists';

UPDATE medical_services SET
	name_sr = 'Rendgen cervikalnog (vratnog) dijela kičme',
	name_sr_cyrl = 'Рендген цервикалног (вратног) дијела кичме'
 WHERE slug = 'x-ray-cervical-spine';

UPDATE medical_services SET
	name_sr_cyrl = 'RTG ┼баке'
 WHERE slug = 'x-ray-hand';

UPDATE medical_services SET
	name_sr = 'Rendgenski aksijalni snimak koljena',
	name_sr_cyrl = 'Рендгенски аксијални снимак кољена'
 WHERE slug = 'x-ray-knee-axial-view';

UPDATE medical_services SET
	name_sr = 'Rendgen lumbalnog dijela kičme i sakruma',
	name_sr_cyrl = 'RTG лумбалне дијела кичме и сакрума',
	name_ru = 'Рентген поясничного отдела позвоночника и крестца'
 WHERE slug = 'x-ray-lumbar-spine-and-sacrum';

UPDATE medical_services SET
	name_sr = 'Rendgen sakralnog dijela kičme',
	name_sr_cyrl = 'Рендген сакралног дијела кичме'
 WHERE slug = 'x-ray-sacrum';

UPDATE medical_services SET
	name_sr = 'Rendgen torakalnog dijela kičme'
 WHERE slug = 'x-ray-thoracic-spine';

UPDATE medical_services SET
	name_sr = 'Rendgen ručnog zgloba'
 WHERE slug = 'x-ray-wrist';

UPDATE medical_services SET
	name_sr = 'Uklanjanje ksantelazmi u predjelu očiju',
	name_sr_cyrl = 'Уклањање ксантелазми у предјелу очију'
 WHERE slug = 'xanthelasma-removal-eye-area';

UPDATE medical_services SET
	name_sr_cyrl = 'Цирконијум круница са керамиком'
 WHERE slug = 'zirconia-crown-with-veneer';

UPDATE medical_services SET
	name_sr_cyrl = 'Цирконијум круница multilayer'
 WHERE slug = 'zirconia-multilayer-crown';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kućna poseta periferija', 'sr' FROM medical_services WHERE slug = 'home-visit-periphery'
UNION ALL SELECT id, 'Кућна посета периферија', 'sr-cyrl' FROM medical_services WHERE slug = 'home-visit-periphery';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Inhalaciona primena', 'sr' FROM medical_services WHERE slug = 'inhalation-administration'
UNION ALL SELECT id, 'Инхалациона примена', 'sr-cyrl' FROM medical_services WHERE slug = 'inhalation-administration';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Uklanjanje stranog tela', 'sr' FROM medical_services WHERE slug = 'foreign-body-removal'
UNION ALL SELECT id, 'Уклањање страног тела', 'sr-cyrl' FROM medical_services WHERE slug = 'foreign-body-removal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kineziterapija za decu sa deformitetima', 'sr' FROM medical_services WHERE slug = 'kinesiotherapy-for-children-with-deformities'
UNION ALL SELECT id, 'Кинезитерапија за децу са деформитетима', 'sr-cyrl' FROM medical_services WHERE slug = 'kinesiotherapy-for-children-with-deformities';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Terapijski masaža delimična', 'sr' FROM medical_services WHERE slug = 'therapeutic-massage-partial'
UNION ALL SELECT id, 'Терапијски масажа делимична', 'sr-cyrl' FROM medical_services WHERE slug = 'therapeutic-massage-partial';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Limfna drenaža delimična', 'sr' FROM medical_services WHERE slug = 'lymphatic-drainage-partial'
UNION ALL SELECT id, 'Лимфна дренажа делимична', 'sr-cyrl' FROM medical_services WHERE slug = 'lymphatic-drainage-partial';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ultrazvuk gornjeg dela abdomena', 'sr' FROM medical_services WHERE slug = 'upper-abdomen-ultrasound'
UNION ALL SELECT id, 'Ултразвук горњег дела абдомена', 'sr-cyrl' FROM medical_services WHERE slug = 'upper-abdomen-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ultrazvuk donjeg dela abdomena', 'sr' FROM medical_services WHERE slug = 'lower-abdomen-ultrasound'
UNION ALL SELECT id, 'Ултразвук доњег дела абдомена', 'sr-cyrl' FROM medical_services WHERE slug = 'lower-abdomen-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ultrazvuk štitne žlezde', 'sr' FROM medical_services WHERE slug = 'thyroid-ultrasound'
UNION ALL SELECT id, 'Ултразвук штитне жлезде', 'sr-cyrl' FROM medical_services WHERE slug = 'thyroid-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ultrazvuk vrata pljuvačne žlezde', 'sr' FROM medical_services WHERE slug = 'neck-ultrasound-salivary-glands'
UNION ALL SELECT id, 'Ултразвук врата пљувачне жлезде', 'sr-cyrl' FROM medical_services WHERE slug = 'neck-ultrasound-salivary-glands';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pregled opšteg lekara', 'sr' FROM medical_services WHERE slug = 'general-practitioner-examination'
UNION ALL SELECT id, 'Преглед општег лекара', 'sr-cyrl' FROM medical_services WHERE slug = 'general-practitioner-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Preventivni pregled opšteg lekara', 'sr' FROM medical_services WHERE slug = 'preventive-general-practitioner-examination'
UNION ALL SELECT id, 'Превентивни преглед општег лекара', 'sr-cyrl' FROM medical_services WHERE slug = 'preventive-general-practitioner-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Intraartikularna primena lekova', 'sr' FROM medical_services WHERE slug = 'intra-articular-medication-application'
UNION ALL SELECT id, 'Интраартикуларна примена лекова', 'sr-cyrl' FROM medical_services WHERE slug = 'intra-articular-medication-application';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kratka konsultacija lekara', 'sr' FROM medical_services WHERE slug = 'brief-doctor-visit-consultation'
UNION ALL SELECT id, 'Кратка консултација лекара', 'sr-cyrl' FROM medical_services WHERE slug = 'brief-doctor-visit-consultation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kontrolni pregled opšteg lekara', 'sr' FROM medical_services WHERE slug = 'follow-up-general-practitioner-examination'
UNION ALL SELECT id, 'Контролни преглед општег лекара', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-general-practitioner-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Uklanjanje stranog tela iz oka', 'sr' FROM medical_services WHERE slug = 'foreign-body-removal-eye'
UNION ALL SELECT id, 'Уклањање страног тела из ока', 'sr-cyrl' FROM medical_services WHERE slug = 'foreign-body-removal-eye';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lečenje karijesa', 'sr' FROM medical_services WHERE slug = 'dental-caries-treatment'
UNION ALL SELECT id, 'Лечење каријеса', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-caries-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lečenje korenskog kanala prvi koren', 'sr' FROM medical_services WHERE slug = 'root-canal-treatment-first-root'
UNION ALL SELECT id, 'Лечење коренског канала први корен', 'sr-cyrl' FROM medical_services WHERE slug = 'root-canal-treatment-first-root';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lečenje korenskog kanala drugi koren', 'sr' FROM medical_services WHERE slug = 'root-canal-treatment-second-root'
UNION ALL SELECT id, 'Лечење коренског канала други корен', 'sr-cyrl' FROM medical_services WHERE slug = 'root-canal-treatment-second-root';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lečenje korenskog kanala treći koren', 'sr' FROM medical_services WHERE slug = 'root-canal-treatment-third-root'
UNION ALL SELECT id, 'Лечење коренског канала трећи корен', 'sr-cyrl' FROM medical_services WHERE slug = 'root-canal-treatment-third-root';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Izbeljivanje zuba', 'sr' FROM medical_services WHERE slug = 'teeth-whitening'
UNION ALL SELECT id, 'Избељивање зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'teeth-whitening';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pedijatrisko lečenje karijesa', 'sr' FROM medical_services WHERE slug = 'pediatric-caries-treatment'
UNION ALL SELECT id, 'Педијатриско лечење каријеса', 'sr-cyrl' FROM medical_services WHERE slug = 'pediatric-caries-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lečenje pulpitisa', 'sr' FROM medical_services WHERE slug = 'pulpitis-treatment'
UNION ALL SELECT id, 'Лечење пулпитиса', 'sr-cyrl' FROM medical_services WHERE slug = 'pulpitis-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Rendgen cervikalnog (vratnog) dela vrata', 'sr' FROM medical_services WHERE slug = 'x-ray-cervical-spine'
UNION ALL SELECT id, 'Рендген цервикалног (вратног) дела врата', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-cervical-spine';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Rendgen torakalnog dela kicme', 'sr' FROM medical_services WHERE slug = 'x-ray-thoracic-spine'
UNION ALL SELECT id, 'Рендген торакалног дела кицме', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-thoracic-spine';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Rendgen lumbalnog dela kicme i sakruma', 'sr' FROM medical_services WHERE slug = 'x-ray-lumbar-spine-and-sacrum'
UNION ALL SELECT id, 'Рендген лумбалног дела кицме и сакрума', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-lumbar-spine-and-sacrum';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Rendgen oba kolena', 'sr' FROM medical_services WHERE slug = 'x-ray-both-knees'
UNION ALL SELECT id, 'Рендген оба колена', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-both-knees';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Oftalmološki i strabološki pregled za djecu sa širenjem zenica', 'sr' FROM medical_services WHERE slug = 'pediatric-strabismus-examination'
UNION ALL SELECT id, 'Офталмолошки и страболошки преглед за дјецу са ширењем зеница', 'sr-cyrl' FROM medical_services WHERE slug = 'pediatric-strabismus-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Rendgenski aksijalni snimak kolena', 'sr' FROM medical_services WHERE slug = 'x-ray-knee-axial-view'
UNION ALL SELECT id, 'Рендгенски аксијални снимак колена', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-knee-axial-view';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Rendgen oba kolena u oba pravca', 'sr' FROM medical_services WHERE slug = 'x-ray-both-knees-two-views'
UNION ALL SELECT id, 'Рендген оба колена у оба правца', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-both-knees-two-views';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Rendgen sakralnog dela', 'sr' FROM medical_services WHERE slug = 'x-ray-sacrum'
UNION ALL SELECT id, 'Рендген сакралног дела', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-sacrum';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lokalna aplikacija leka u zglob', 'sr' FROM medical_services WHERE slug = 'local-joint-medication-injection'
UNION ALL SELECT id, 'Локална апликација лека у зглоб', 'sr-cyrl' FROM medical_services WHERE slug = 'local-joint-medication-injection';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operativno lečenje burzitisa', 'sr' FROM medical_services WHERE slug = 'bursitis-surgical-treatment'
UNION ALL SELECT id, 'Оперативно лечење бурзитиса', 'sr-cyrl' FROM medical_services WHERE slug = 'bursitis-surgical-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operativno lečenje inflamiranog burzitisa', 'sr' FROM medical_services WHERE slug = 'inflamed-bursitis-surgical-treatment'
UNION ALL SELECT id, 'Оперативно лечење инфламираног бурзитиса', 'sr-cyrl' FROM medical_services WHERE slug = 'inflamed-bursitis-surgical-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Vađenje stranog tela uz repoziciju', 'sr' FROM medical_services WHERE slug = 'foreign-body-removal-with-reposition'
UNION ALL SELECT id, 'Вађење страног тела уз репозицију', 'sr-cyrl' FROM medical_services WHERE slug = 'foreign-body-removal-with-reposition';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Vađenje stranog tela', 'sr' FROM medical_services WHERE slug = 'foreign-body-extraction-surgery'
UNION ALL SELECT id, 'Вађење страног тела', 'sr-cyrl' FROM medical_services WHERE slug = 'foreign-body-extraction-surgery';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Biopsija limfne žlezde (u preponi i pazuhu)', 'sr' FROM medical_services WHERE slug = 'lymph-node-biopsy-groin-armpit'
UNION ALL SELECT id, 'Биопсија лимфне жлезде (у препони и пазуху)', 'sr-cyrl' FROM medical_services WHERE slug = 'lymph-node-biopsy-groin-armpit';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Biopsija limfne žlezde (na vratu)', 'sr' FROM medical_services WHERE slug = 'lymph-node-biopsy-neck'
UNION ALL SELECT id, 'Биопсија лимфне жлезде (на врату)', 'sr-cyrl' FROM medical_services WHERE slug = 'lymph-node-biopsy-neck';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hirurška obrada rana na telu', 'sr' FROM medical_services WHERE slug = 'surgical-wound-treatment-body'
UNION ALL SELECT id, 'Хируршка обрада рана на телу', 'sr-cyrl' FROM medical_services WHERE slug = 'surgical-wound-treatment-body';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Previjanje i lečenje hronične rane', 'sr' FROM medical_services WHERE slug = 'chronic-wound-treatment-and-dressing'
UNION ALL SELECT id, 'Превијање и лечење хроничне ране', 'sr-cyrl' FROM medical_services WHERE slug = 'chronic-wound-treatment-and-dressing';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hirurško lečenje pilonidalnog sinusa', 'sr' FROM medical_services WHERE slug = 'pilonidal-sinus-surgical-treatment'
UNION ALL SELECT id, 'Хируршко лечење пилонидалног синуса', 'sr-cyrl' FROM medical_services WHERE slug = 'pilonidal-sinus-surgical-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Uklanjanje stranog tela iz cerviksa', 'sr' FROM medical_services WHERE slug = 'foreign-body-removal-from-cervix'
UNION ALL SELECT id, 'Уклањање страног тела из цервикса', 'sr-cyrl' FROM medical_services WHERE slug = 'foreign-body-removal-from-cervix';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Reparacija prednjeg dela vagine', 'sr' FROM medical_services WHERE slug = 'anterior-vaginal-wall-repair'
UNION ALL SELECT id, 'Репарација предњег дела вагине', 'sr-cyrl' FROM medical_services WHERE slug = 'anterior-vaginal-wall-repair';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Reparacija prednjeg i zadnjeg dela vagine', 'sr' FROM medical_services WHERE slug = 'anterior-and-posterior-vaginal-wall-repair'
UNION ALL SELECT id, 'Репарација предњег и задњег дела вагине', 'sr-cyrl' FROM medical_services WHERE slug = 'anterior-and-posterior-vaginal-wall-repair';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Laparoskopska operacija slepog creva (apendektomija)', 'sr' FROM medical_services WHERE slug = 'laparoscopic-appendectomy'
UNION ALL SELECT id, 'Лапароскопска операција слепог црева (апендектомија)', 'sr-cyrl' FROM medical_services WHERE slug = 'laparoscopic-appendectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Otvorena operacija slepog creva (apendektomija)', 'sr' FROM medical_services WHERE slug = 'open-appendectomy'
UNION ALL SELECT id, 'Отворена операција слепог црева (апендектомија)', 'sr-cyrl' FROM medical_services WHERE slug = 'open-appendectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Parcijalna resekcija tankih creva sa primarnom anastomozom', 'sr' FROM medical_services WHERE slug = 'small-bowel-partial-resection-with-primary-anastomosis'
UNION ALL SELECT id, 'Парцијална ресекција танких црева са примарном анастомозом', 'sr-cyrl' FROM medical_services WHERE slug = 'small-bowel-partial-resection-with-primary-anastomosis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Parcijalna resekcija tankih creva sa ileostomom', 'sr' FROM medical_services WHERE slug = 'small-bowel-partial-resection-with-ileostomy'
UNION ALL SELECT id, 'Парцијална ресекција танких црева са илеостомом', 'sr-cyrl' FROM medical_services WHERE slug = 'small-bowel-partial-resection-with-ileostomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Leva hemikolektomija sa unipolarnom kolostomom', 'sr' FROM medical_services WHERE slug = 'left-hemicolectomy-with-unipolar-colostomy'
UNION ALL SELECT id, 'Лева хемиколектомија са униполарном колостомом', 'sr-cyrl' FROM medical_services WHERE slug = 'left-hemicolectomy-with-unipolar-colostomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Leva hemikolektomija sa izvođenjem kolostome', 'sr' FROM medical_services WHERE slug = 'left-hemicolectomy-with-colostomy'
UNION ALL SELECT id, 'Лева хемиколектомија са извођењем колостоме', 'sr-cyrl' FROM medical_services WHERE slug = 'left-hemicolectomy-with-colostomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Leva hemikolektomija sa kolo-kolo anastomozom', 'sr' FROM medical_services WHERE slug = 'left-hemicolectomy-with-colo-colo-anastomosis'
UNION ALL SELECT id, 'Лева хемиколектомија са коло-коло анастомозом', 'sr-cyrl' FROM medical_services WHERE slug = 'left-hemicolectomy-with-colo-colo-anastomosis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Laparoskopska leva hemikolektomija', 'sr' FROM medical_services WHERE slug = 'laparoscopic-left-hemicolectomy'
UNION ALL SELECT id, 'Лапароскопска лева хемиколектомија', 'sr-cyrl' FROM medical_services WHERE slug = 'laparoscopic-left-hemicolectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Desna hemikolektomija i anastomoza creva', 'sr' FROM medical_services WHERE slug = 'right-hemicolectomy-with-anastomosis'
UNION ALL SELECT id, 'Десна хемиколектомија и анастомоза црева', 'sr-cyrl' FROM medical_services WHERE slug = 'right-hemicolectomy-with-anastomosis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Uklanjanje ksantelazmi u predelu očiju', 'sr' FROM medical_services WHERE slug = 'xanthelasma-removal-eye-area'
UNION ALL SELECT id, 'Уклањање ксантелазми у пределу очију', 'sr-cyrl' FROM medical_services WHERE slug = 'xanthelasma-removal-eye-area';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Face lifting sa transferom masti u lice iz drugih regija tela', 'sr' FROM medical_services WHERE slug = 'face-lift-with-fat-transfer'
UNION ALL SELECT id, 'Face лифтинг са трансфером масти у лице из других регија тела', 'sr-cyrl' FROM medical_services WHERE slug = 'face-lift-with-fat-transfer';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Zamena grudnih implantanata', 'sr' FROM medical_services WHERE slug = 'breast-implant-replacement'
UNION ALL SELECT id, 'Замена грудних имплантаната', 'sr-cyrl' FROM medical_services WHERE slug = 'breast-implant-replacement';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kontrola lečenja u mesecu nakon prvog pregleda', 'sr' FROM medical_services WHERE slug = 'treatment-follow-up-first-month'
UNION ALL SELECT id, 'Контрола лечења у месецу након првог прегледа', 'sr-cyrl' FROM medical_services WHERE slug = 'treatment-follow-up-first-month';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Prvi kontrolni pregled nakon početka lečenja', 'sr' FROM medical_services WHERE slug = 'first-treatment-follow-up'
UNION ALL SELECT id, 'Први контролни преглед након почетка лечења', 'sr-cyrl' FROM medical_services WHERE slug = 'first-treatment-follow-up';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Zamena intraokularnog sočiva', 'sr' FROM medical_services WHERE slug = 'intraocular-lens-exchange'
UNION ALL SELECT id, 'Замена интраокуларног сочива', 'sr-cyrl' FROM medical_services WHERE slug = 'intraocular-lens-exchange';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Zamena silikonskog ulja', 'sr' FROM medical_services WHERE slug = 'silicone-oil-exchange'
UNION ALL SELECT id, 'Замена силиконског уља', 'sr-cyrl' FROM medical_services WHERE slug = 'silicone-oil-exchange';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Revizija prostora staklastog tela', 'sr' FROM medical_services WHERE slug = 'vitreous-cavity-revision'
UNION ALL SELECT id, 'Ревизија простора стакластог тела', 'sr-cyrl' FROM medical_services WHERE slug = 'vitreous-cavity-revision';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Profesionalno čišćenje zuba mlečni zubi', 'sr' FROM medical_services WHERE slug = 'professional-dental-cleaning-deciduous-teeth'
UNION ALL SELECT id, 'Професионално чишћење зуба млечни зуби', 'sr-cyrl' FROM medical_services WHERE slug = 'professional-dental-cleaning-deciduous-teeth';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Primarna obrada kanala korena', 'sr' FROM medical_services WHERE slug = 'root-canal-preparation'
UNION ALL SELECT id, 'Примарна обрада канала корена', 'sr-cyrl' FROM medical_services WHERE slug = 'root-canal-preparation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Definitivna opturacija kanala korena', 'sr' FROM medical_services WHERE slug = 'root-canal-obturation'
UNION ALL SELECT id, 'Дефинитивна оптурација канала корена', 'sr-cyrl' FROM medical_services WHERE slug = 'root-canal-obturation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Zamena izgubljenog breketa', 'sr' FROM medical_services WHERE slug = 'lost-bracket-replacement'
UNION ALL SELECT id, 'Замена изгубљеног брекета', 'sr-cyrl' FROM medical_services WHERE slug = 'lost-bracket-replacement';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Konsultacija dečjeg stomatologa', 'sr' FROM medical_services WHERE slug = 'pediatric-dentist-consultation'
UNION ALL SELECT id, 'Консултација дечјег стоматолога', 'sr-cyrl' FROM medical_services WHERE slug = 'pediatric-dentist-consultation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Konsultacija sa planom lečenja', 'sr' FROM medical_services WHERE slug = 'dental-consultation-with-treatment-plan'
UNION ALL SELECT id, 'Консултација са планом лечења', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-consultation-with-treatment-plan';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Dijagnostika i planiranje lečenja', 'sr' FROM medical_services WHERE slug = 'dental-diagnostics-and-treatment-planning'
UNION ALL SELECT id, 'Дијагностика и планирање лечења', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-diagnostics-and-treatment-planning';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Dečja stomatološka dijagnostika sa planom lečenja', 'sr' FROM medical_services WHERE slug = 'pediatric-dental-diagnostics-with-treatment-plan'
UNION ALL SELECT id, 'Дечја стоматолошка дијагностика са планом лечења', 'sr-cyrl' FROM medical_services WHERE slug = 'pediatric-dental-diagnostics-with-treatment-plan';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kompleksna stomatološka dijagnostika sa planom lečenja', 'sr' FROM medical_services WHERE slug = 'comprehensive-dental-diagnostics-with-treatment-plan'
UNION ALL SELECT id, 'Комплексна стоматолошка дијагностика са планом лечења', 'sr-cyrl' FROM medical_services WHERE slug = 'comprehensive-dental-diagnostics-with-treatment-plan';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Analiza telesne kompozicije', 'sr' FROM medical_services WHERE slug = 'body-composition-analysis'
UNION ALL SELECT id, 'Анализа телесне композиције', 'sr-cyrl' FROM medical_services WHERE slug = 'body-composition-analysis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'EEG posle deprivacije sna', 'sr' FROM medical_services WHERE slug = 'eeg-after-sleep-deprivation'
UNION ALL SELECT id, 'ЕЕГ после депривације сна', 'sr-cyrl' FROM medical_services WHERE slug = 'eeg-after-sleep-deprivation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Endodontsko lečenje jednokanalnih zuba', 'sr' FROM medical_services WHERE slug = 'endodontic-treatment-single-canal-tooth'
UNION ALL SELECT id, 'Ендодонтско лечење једноканалних зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'endodontic-treatment-single-canal-tooth';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Endodontsko lečenje višekanalnih zuba', 'sr' FROM medical_services WHERE slug = 'endodontic-treatment-multi-canal-tooth'
UNION ALL SELECT id, 'Ендодонтско лечење вишеканалних зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'endodontic-treatment-multi-canal-tooth';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Closed Manipulation Reduction of Proximal Fracture', 'en' FROM medical_services WHERE slug = 'closed-manipulation-reduction-of-proximal-fracture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pediculated and Tubular Ureteral Implantation', 'en' FROM medical_services WHERE slug = 'pediculated-and-tubular-ureteral-implantation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Esophagogastrectomy with Laparotomy, Thoracotomy, Cervical Esophagostomy', 'en' FROM medical_services WHERE slug = 'esophagogastrectomy-with-laparotomy-thoracotomy-cervical-esophagostomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Imunoprofilaksa, imunoprofilaksa sa serumom i hemoprofilaksa za sprečavanje zaraznih bolesti', 'sr' FROM medical_services WHERE slug = 'immunoprophylaxis-and-chemoprophylaxis-for-infectious-disease-prevention'
UNION ALL SELECT id, 'Имунопрофилакса, имунопрофилакса са серумом и хемопрофилакса за спречавање заразних болести', 'sr-cyrl' FROM medical_services WHERE slug = 'immunoprophylaxis-and-chemoprophylaxis-for-infectious-disease-prevention';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lečenje razvojnog poremećaja kuka kod dece', 'sr' FROM medical_services WHERE slug = 'developmental-hip-dysplasia-treatment-in-children'
UNION ALL SELECT id, 'Лечење развојног поремећаја кука код деце', 'sr-cyrl' FROM medical_services WHERE slug = 'developmental-hip-dysplasia-treatment-in-children';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lečenje urođenih deformiteta stopala kod dece', 'sr' FROM medical_services WHERE slug = 'congenital-foot-deformity-treatment-in-children'
UNION ALL SELECT id, 'Лечење урођених деформитета стопала код деце', 'sr-cyrl' FROM medical_services WHERE slug = 'congenital-foot-deformity-treatment-in-children';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lečenje deformiteta kičmenog stuba kod dece i omladine', 'sr' FROM medical_services WHERE slug = 'spinal-deformity-treatment-in-children-and-adolescents'
UNION ALL SELECT id, 'Лечење деформитета кичменог стуба код деце и омладине', 'sr-cyrl' FROM medical_services WHERE slug = 'spinal-deformity-treatment-in-children-and-adolescents';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lečenje infekcija kostiju i zglobova', 'sr' FROM medical_services WHERE slug = 'bone-and-joint-infection-treatment'
UNION ALL SELECT id, 'Лечење инфекција костију и зглобова', 'sr-cyrl' FROM medical_services WHERE slug = 'bone-and-joint-infection-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lečenje tumora kosti i mekih tkiva', 'sr' FROM medical_services WHERE slug = 'bone-and-soft-tissue-tumor-treatment'
UNION ALL SELECT id, 'Лечење тумора кости и меких ткива', 'sr-cyrl' FROM medical_services WHERE slug = 'bone-and-soft-tissue-tumor-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lečenje degenerativnih bolesti kičme', 'sr' FROM medical_services WHERE slug = 'degenerative-spine-disease-treatment'
UNION ALL SELECT id, 'Лечење дегенеративних болести кичме', 'sr-cyrl' FROM medical_services WHERE slug = 'degenerative-spine-disease-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lečenje hidrocefalusa kod odraslih', 'sr' FROM medical_services WHERE slug = 'adult-hydrocephalus-treatment'
UNION ALL SELECT id, 'Лечење хидроцефалуса код одраслих', 'sr-cyrl' FROM medical_services WHERE slug = 'adult-hydrocephalus-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lečenje cerebrovaskularnih bolesti', 'sr' FROM medical_services WHERE slug = 'cerebrovascular-disease-treatment'
UNION ALL SELECT id, 'Лечење цереброваскуларних болести', 'sr-cyrl' FROM medical_services WHERE slug = 'cerebrovascular-disease-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lečenje neurodegenerativnih bolesti', 'sr' FROM medical_services WHERE slug = 'neurodegenerative-disease-treatment'
UNION ALL SELECT id, 'Лечење неуродегенеративних болести', 'sr-cyrl' FROM medical_services WHERE slug = 'neurodegenerative-disease-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lečenje inflamatornih oboljenja perifernih nerava i kičmene moždine', 'sr' FROM medical_services WHERE slug = 'peripheral-nerve-and-spinal-cord-inflammatory-disease-treatment'
UNION ALL SELECT id, 'Лечење инфламаторних обољења периферних нерава и кичмене мождине', 'sr-cyrl' FROM medical_services WHERE slug = 'peripheral-nerve-and-spinal-cord-inflammatory-disease-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lečenje autoimunih neuroloških oboljenja', 'sr' FROM medical_services WHERE slug = 'autoimmune-neurological-disease-treatment'
UNION ALL SELECT id, 'Лечење аутоимуних неуролошких обољења', 'sr-cyrl' FROM medical_services WHERE slug = 'autoimmune-neurological-disease-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lečenje poremećaja svesti', 'sr' FROM medical_services WHERE slug = 'consciousness-disorder-treatment'
UNION ALL SELECT id, 'Лечење поремећаја свести', 'sr-cyrl' FROM medical_services WHERE slug = 'consciousness-disorder-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hirurško lečenje povreda šake', 'sr' FROM medical_services WHERE slug = 'hand-injury-surgical-treatment'
UNION ALL SELECT id, 'Хируршко лечење повреда шаке', 'sr-cyrl' FROM medical_services WHERE slug = 'hand-injury-surgical-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hirurško lečenje opekotina manjeg obima', 'sr' FROM medical_services WHERE slug = 'minor-burns-surgical-treatment'
UNION ALL SELECT id, 'Хируршко лечење опекотина мањег обима', 'sr-cyrl' FROM medical_services WHERE slug = 'minor-burns-surgical-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Rehabilitacija nakon ugradnje veštačkog zgloba', 'sr' FROM medical_services WHERE slug = 'post-joint-replacement-rehabilitation'
UNION ALL SELECT id, 'Рехабилитација након уградње вештачког зглоба', 'sr-cyrl' FROM medical_services WHERE slug = 'post-joint-replacement-rehabilitation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ambulatory Medium Dressing', 'en' FROM medical_services WHERE slug = 'ambulatory-medium-dressing';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operation Small Dressing I', 'en' FROM medical_services WHERE slug = 'operation-small-dressing-i';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operating Theatre Costs Tier I Over 180 Points', 'en' FROM medical_services WHERE slug = 'operating-theatre-costs-tier-i-over-180-points';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operating Theatre Costs Tier II 5 to 20 Points', 'en' FROM medical_services WHERE slug = 'operating-theatre-costs-tier-ii-5-to-20-points';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operating Theatre Costs Tier II 51 to 120 Points', 'en' FROM medical_services WHERE slug = 'operating-theatre-costs-tier-ii-51-to-120-points';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operating Theatre Costs Tier II 121 to 180 Points', 'en' FROM medical_services WHERE slug = 'operating-theatre-costs-tier-ii-121-to-180-points';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operating Theatre Costs Tier II Over 180 Points', 'en' FROM medical_services WHERE slug = 'operating-theatre-costs-tier-ii-over-180-points';

COMMIT;
