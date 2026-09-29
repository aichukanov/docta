-- 037: названия услуг — вычитка и синонимы (шаг 2 из docs/audit/service-names-2026-09.md).
--
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/037-service-names-review.sql
--
-- Собрано скриптом scripts/services/build-service-names-sql.mjs из
-- data/service-names/review-*.json — руками не править, пересобирать.
-- Применять ПОСЛЕ 036: значения посчитаны поверх неё.
--
-- Вычитаны услуги, которые есть в трёх клиниках и больше (1282 шт.), во всех
-- локалях: обрубки, кальки и латинизмы там, где есть обычное слово, порядок
-- слов из прайса, неверные термины, разнобой внутри серий.
-- Строк: 634. Синонимов: 3664. До этой миграции синонимы были у 83 услуг
-- из 4991, и почти все попали туда побочно, при слиянии дублей.
--
-- Поиск читает синонимы уже сейчас (server/api/services/list.ts) — кода не нужно.
-- sr-cyrl-синонимы получены транслитерацией sr. Синоним, совпадающий с
-- названием другой услуги или являющийся подстрокой своего, отброшен.
--
-- Обновление по slug, а не по id. Идемпотентно.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

START TRANSACTION;

UPDATE medical_services SET
	name_ru = '3D снимок зубов (КЛКТ)'
 WHERE slug = '3d-dental-x-ray-cbct';

UPDATE medical_services SET
	name_sr = 'Eksploracija abdominalne aorte, visceralnih arterija ili vena ili renalnih arterija i vena',
	name_sr_cyrl = 'Експлорација абдоминалне аорте, висцералних артерија или вена или реналних артерија и вена',
	name_ru = 'Ревизия брюшной аорты, висцеральных или почечных сосудов'
 WHERE slug = 'abdominal-aorta-visceral-or-renal-vessels-exploration';

UPDATE medical_services SET
	name_sr = 'Repozicija — abdominalno-femoralni gips',
	name_sr_cyrl = 'Репозиција — абдоминално-феморални гипс',
	name_ru = 'Репозиция — абдомино-феморальный гипс',
	name_de = 'Reposition mit abdominofemoralem Gips',
	name_tr = 'Abdominofemoral alçı ile redüksiyon'
 WHERE slug = 'abdominal-femoral-plaster-reduction';

UPDATE medical_services SET
	name_en = 'Abdominal Hysterectomy with Preservation of Adnexa',
	name_sr = 'Abdominalna histerektomija sa konzervacijom adneksa',
	name_sr_cyrl = 'Абдоминална хистеректомија са конзервацијом аднекса',
	name_de = 'Abdominale Hysterektomie unter Erhalt der Adnexe',
	name_tr = 'Adneksler Korunarak Abdominal Histerektomi'
 WHERE slug = 'abdominal-hysterectomy-with-conservation';

UPDATE medical_services SET
	name_sr = 'Ultrazvuk abdominalnih krvnih sudova i limfnih žlijezda',
	name_sr_cyrl = 'Ултразвук абдоминалних крвних судова и лимфних жлијезда',
	name_ru = 'УЗИ сосудов брюшной полости и лимфатических узлов'
 WHERE slug = 'abdominal-vessels-and-lymph-nodes-ultrasound';

UPDATE medical_services SET
	name_tr = 'Üst kol alçı immobilizasyonu (atel veya tam alçı)'
 WHERE slug = 'above-elbow-plaster-immobilization';

UPDATE medical_services SET
	name_ru = 'Артропластика вертлужной впадины (чашка или протез)',
	name_tr = 'Asetabular kup artroplastisi / protez'
 WHERE slug = 'acetabular-cup-arthroplasty-prosthesis';

UPDATE medical_services SET
	name_en = 'Acetabulum and Proximal Femur Arthroplasty (Total Hip)',
	name_sr = 'Artroplastika acetabuluma i proksimalnog dijela femura (cijeli kuk)',
	name_sr_cyrl = 'Артропластика ацетабулума и проксималног дијела фемура (цијели кук)',
	name_ru = 'Артропластика вертлужной впадины и проксимального отдела бедренной кости (весь тазобедренный сустав)',
	name_de = 'Acetabulum- und Proximalfemur-Arthroplastik (gesamte Hüfte)',
	name_tr = 'Asetabulum ve proksimal femur artroplastisi (tüm kalça)'
 WHERE slug = 'acetabulum-and-proximal-femur-arthroplasty';

UPDATE medical_services SET
	name_ru = 'Репозиция вывиха акромиально-ключичного сустава (закрытая или открытая)',
	name_de = 'Reposition einer Akromioklavikulargelenksluxation (offen oder geschlossen)',
	name_tr = 'Akromioklavikular eklem dislokasyonu redüksiyonu (kapalı veya açık)'
 WHERE slug = 'acromioclavicular-joint-dislocation-open-or-closed';

UPDATE medical_services SET
	name_ru = 'Активные упражнения и упражнения с сопротивлением'
 WHERE slug = 'active-and-resistance-exercises';

UPDATE medical_services SET
	name_tr = 'Kademeli yüklemeli aktif segmental egzersizler'
 WHERE slug = 'active-segmental-exercises-with-graded-loading';

UPDATE medical_services SET
	name_en = 'Condition-Specific Activities of Daily Living Training',
	name_sr = 'Uvježbavanje aktivnosti svakodnevnog života prema patološkim stanjima',
	name_sr_cyrl = 'Увјежбавање активности свакодневног живота према патолошким стањима',
	name_ru = 'Тренировка повседневной активности с учётом патологического состояния',
	name_de = 'Training der Aktivitäten des täglichen Lebens je nach Krankheitsbild',
	name_tr = 'Patolojik duruma göre günlük yaşam aktiviteleri eğitimi'
 WHERE slug = 'activities-of-daily-living-training';

UPDATE medical_services SET
	name_ru = 'Акуметрическое исследование слуха',
	name_tr = 'Akumetrik işitme testleri'
 WHERE slug = 'acumetric-hearing-tests';

UPDATE medical_services SET
	name_ru = 'Удаление острой эпи- или субдуральной гематомы с костно-пластической трепанацией черепа',
	name_de = 'Entfernung eines akuten Epi- oder Subduralhämatoms durch osteoplastische Kraniotomie'
 WHERE slug = 'acute-episubdural-hematoma-removal-by-osteoplastic-craniotomy';

UPDATE medical_services SET
	name_en = 'Acute Infratentorial Epidural Hematoma Treatment',
	name_ru = 'Лечение острой инфратенториальной эпидуральной гематомы',
	name_de = 'Behandlung eines akuten infratentoriellen Epiduralhämatoms',
	name_tr = 'Akut infratentorial epidural hematom tedavisi'
 WHERE slug = 'acute-infratentorial-epidural-hematoma';

UPDATE medical_services SET
	name_en = 'Acute Infratentorial Subdural Hematoma Treatment',
	name_ru = 'Лечение острой инфратенториальной субдуральной гематомы',
	name_de = 'Behandlung eines akuten infratentoriellen Subduralhämatoms',
	name_tr = 'Akut infratentorial subdural hematom tedavisi'
 WHERE slug = 'acute-infratentorial-subdural-hematoma';

UPDATE medical_services SET
	name_en = 'Acute Supratentorial Epidural Hematoma Treatment',
	name_ru = 'Лечение острой супратенториальной эпидуральной гематомы',
	name_de = 'Behandlung eines akuten supratentoriellen Epiduralhämatoms',
	name_tr = 'Akut supratentorial epidural hematom tedavisi'
 WHERE slug = 'acute-supratentorial-epidural-hematoma';

UPDATE medical_services SET
	name_en = 'Acute Supratentorial Subdural Hematoma Treatment',
	name_ru = 'Лечение острой супратенториальной субдуральной гематомы',
	name_de = 'Behandlung eines akuten supratentoriellen Subduralhämatoms',
	name_tr = 'Akut supratentorial subdural hematom tedavisi'
 WHERE slug = 'acute-supratentorial-subdural-hematoma';

UPDATE medical_services SET
	name_sr = 'All on 4 metalokeramička proteza na titanu',
	name_sr_cyrl = 'All on 4 металокерамичка протеза на титану',
	name_ru = 'All on 4 металлокерамический протез на титане',
	name_de = 'All on 4 Metallkeramikprothese auf Titan'
 WHERE slug = 'all-on-4-metal-ceramic-titanium';

UPDATE medical_services SET
	name_de = 'All on 4 Zirkonprothese'
 WHERE slug = 'all-on-4-zirconia';

UPDATE medical_services SET
	name_de = 'All on 6 Metallkeramikprothese'
 WHERE slug = 'all-on-6-metal-ceramic';

UPDATE medical_services SET
	name_de = 'All on 6 Zirkonprothese'
 WHERE slug = 'all-on-6-zirconia';

UPDATE medical_services SET
	name_ru = 'Выравнивание альвеолярного гребня'
 WHERE slug = 'alveolar-ridge-leveling';

UPDATE medical_services SET
	name_en = 'Large Outpatient Dressing',
	name_tr = 'Büyük poliklinik pansumanı'
 WHERE slug = 'ambulatory-large-dressing';

UPDATE medical_services SET
	name_en = 'Small Outpatient Dressing',
	name_tr = 'Küçük poliklinik pansumanı'
 WHERE slug = 'ambulatory-small-dressing';

UPDATE medical_services SET
	name_de = 'Analfissur-Operation'
 WHERE slug = 'anal-fissure-surgery';

UPDATE medical_services SET
	name_sr = 'Mjerenje gležanjsko-brahijalnog indeksa dopler ultrazvukom',
	name_sr_cyrl = 'Мјерење глежањско-брахијалног индекса доплер ултразвуком',
	name_ru = 'Измерение лодыжечно-плечевого индекса методом допплерографии'
 WHERE slug = 'ankle-brachial-index-by-doppler-ultrasound';

UPDATE medical_services SET
	name_sr = 'Prednja kapsulorafija kod povratnih dislokacija ramena',
	name_sr_cyrl = 'Предња капсулорафија код повратних дислокација рамена',
	name_ru = 'Передняя капсулорафия при привычном вывихе плеча',
	name_de = 'Anteriore Kapsulorrhaphie bei rezidivierender Schulterluxation',
	name_tr = 'Tekrarlayan omuz çıkığında anterior kapsülorafi'
 WHERE slug = 'anterior-capsulorrhaphy-for-recurrent-shoulder-dislocation';

UPDATE medical_services SET
	name_en = 'Subcutaneous Hematoma Puncture',
	name_sr = 'Punkcija potkožnih hematoma',
	name_sr_cyrl = 'Пункција поткожних хематома',
	name_ru = 'Пункция подкожной гематомы',
	name_de = 'Punktion subkutaner Hämatome',
	name_tr = 'Deri altı hematom ponksiyonu'
 WHERE slug = 'anterior-hematoma-puncture';

UPDATE medical_services SET
	name_sr = 'Apikoektomija višekorijenog zuba',
	name_sr_cyrl = 'Apikoektomija вишекоријеног зуба',
	name_de = 'Wurzelspitzenresektion an einem mehrwurzeligen Zahn'
 WHERE slug = 'apicoectomy-multi-root-tooth';

UPDATE medical_services SET
	name_de = 'Apparative Massage',
	name_tr = 'Cihaz destekli masaj'
 WHERE slug = 'apparatus-assisted-massage';

UPDATE medical_services SET
	name_ru = 'Ревизия сосудов руки'
 WHERE slug = 'arm-vessels-exploration';

UPDATE medical_services SET
	name_de = 'Arterielle Blutentnahme und pH-Bestimmung'
 WHERE slug = 'arterial-blood-ph-measurement';

UPDATE medical_services SET
	name_en = 'Intertarsal or Tarsometatarsal Arthrotomy with Exploration, Drainage and Foreign Body Removal',
	name_sr = 'Artrotomija (kapsulotomija) intertarzalnog ili tarzometatarzalnog zgloba sa eksploracijom, drenažom i vađenjem stranog tijela',
	name_sr_cyrl = 'Артротомија (капсулотомија) интертарзалног или тарзометатарзалног зглоба са експлорацијом, дренажом и вађењем страног тијела',
	name_ru = 'Артротомия межпредплюсневого или предплюсне-плюсневого сустава с ревизией, дренированием и удалением инородного тела',
	name_de = 'Arthrotomie eines Intertarsal- oder Tarsometatarsalgelenks mit Exploration, Drainage und Fremdkörperentfernung',
	name_tr = 'İntertarsal veya tarsometatarsal eklem artrotomisi (eksplorasyon, drenaj ve yabancı cisim çıkarılması)'
 WHERE slug = 'arthrotomy-with-exploration-and-drainage';

UPDATE medical_services SET
	name_en = 'Colostomy Care'
 WHERE slug = 'artificial-anus-care';

UPDATE medical_services SET
	name_ru = 'Аспирационное дренирование плевральной полости при эмпиеме',
	name_tr = 'Ampiyemde göğüs boşluğunun aspirasyon drenajı'
 WHERE slug = 'aspiration-drainage-of-empyema';

UPDATE medical_services SET
	name_ru = 'Сегментарные упражнения с посторонней помощью'
 WHERE slug = 'assisted-segmental-exercises';

UPDATE medical_services SET
	name_de = 'Exstirpation von Atherom, Zyste, Xanthom oder kleinem benignem Tumor'
 WHERE slug = 'atheroma-cyst-xanthoma-or-small-benign-tumor-excision';

UPDATE medical_services SET
	name_ru = 'Наложение повязки при вывихе'
 WHERE slug = 'bandage-application-for-dislocation';

UPDATE medical_services SET
	name_en = 'Bartholin Gland Incision (Cyst or Abscess Drainage)',
	name_ru = 'Вскрытие бартолиновой железы (дренаж кисты или абсцесса)',
	name_tr = 'Bartolin Bezi İnsizyonu (Kist veya Apse Drenajı)'
 WHERE slug = 'bartholin-gland-incision';

UPDATE medical_services SET
	name_en = 'Böhler Apparatus Application',
	name_sr = 'Repozicija — aplikacija Belerovog aparata',
	name_sr_cyrl = 'Репозиција — апликација Белеровог апарата',
	name_ru = 'Репозиция с наложением аппарата Белера',
	name_de = 'Reposition mit Böhler-Apparat',
	name_tr = 'Böhler cihazı ile redüksiyon'
 WHERE slug = 'beller-apparatus-application';

UPDATE medical_services SET
	name_ru = 'Гипсовая иммобилизация ниже локтя (лонгета или круговая)',
	name_tr = 'Önkol alçı immobilizasyonu (atel veya tam alçı)'
 WHERE slug = 'below-elbow-plaster-immobilization';

UPDATE medical_services SET
	name_ru = 'Ампутация голени через большеберцовую и малоберцовую кости',
	name_tr = 'Tibia ve fibuladan bacak amputasyonu'
 WHERE slug = 'below-knee-amputation-through-tibia-and-fibula';

UPDATE medical_services SET
	name_ru = 'Репозиция — гипсовая иммобилизация голени (лонгета или круговая)',
	name_de = 'Reposition mit Unterschenkel-Gipsimmobilisation (Schiene oder Vollgips)',
	name_tr = 'Alt bacak alçı immobilizasyonu ile redüksiyon (atel veya tam alçı)'
 WHERE slug = 'below-knee-plaster-reduction';

UPDATE medical_services SET
	name_ru = 'Реампутация голени через большеберцовую или малоберцовую кость',
	name_de = 'Reamputation am Unterschenkel',
	name_tr = 'Tibia veya fibuladan bacak reamputasyonu'
 WHERE slug = 'below-knee-re-amputation-through-tibiafibula';

UPDATE medical_services SET
	name_en = 'Below-Knee Walking Cast Reduction',
	name_de = 'Reposition mit Unterschenkel-Gehgips',
	name_tr = 'Alt bacak yürüme alçısı ile redüksiyon'
 WHERE slug = 'below-knee-walking-cast';

UPDATE medical_services SET
	name_ru = 'Операция при доброкачественных опухолях молочных желёз',
	name_de = 'Operation gutartiger Brusttumoren'
 WHERE slug = 'benign-breast-tumor-surgery';

UPDATE medical_services SET
	name_ru = 'Закрытая репозиция перелома фаланги большого пальца стопы'
 WHERE slug = 'big-toe-phalanx-fracture-manipulation-reduction';

UPDATE medical_services SET
	name_ru = 'Репозиция перелома фаланги большого пальца стопы (закрытая или открытая)',
	name_de = 'Reposition einer Großzehen-Phalanxfraktur (offen oder geschlossen)',
	name_tr = 'Ayak başparmağı falanks kırığı redüksiyonu (kapalı veya açık)'
 WHERE slug = 'big-toe-phalanx-fracture-reduction';

UPDATE medical_services SET
	name_en = 'Bilateral Bony Choanal Atresia Repair',
	name_ru = 'Двусторонняя пластика при костной атрезии хоан',
	name_de = 'Bilaterale Plastik bei knöcherner Choanalatresie',
	name_tr = 'Bilateral kemik koanal atrezi onarımı'
 WHERE slug = 'bilateral-choanal-bony-atresia-plasty';

UPDATE medical_services SET
	name_ru = 'Двусторонняя операция на околоносовых пазухах по Де Лима'
 WHERE slug = 'bilateral-de-lima-sinus-operation';

UPDATE medical_services SET
	name_sr = 'Dilatacija striktura žučnih puteva',
	name_sr_cyrl = 'Дилатација стриктура жучних путева'
 WHERE slug = 'bile-duct-stricture-dilatation';

UPDATE medical_services SET
	name_ru = 'Репозиция бималлеолярного перелома голеностопа (закрытая или открытая) с фиксацией или без',
	name_de = 'Reposition einer bimalleolären Sprunggelenksfraktur (offen oder geschlossen) mit oder ohne Fixation',
	name_tr = 'Bimaleolar ayak bileği kırığı redüksiyonu (kapalı veya açık), fiksasyonlu veya fiksasyonsuz'
 WHERE slug = 'bimalleolar-ankle-fracture-open-or-closed-withwithout-fixation';

UPDATE medical_services SET
	name_en = 'Bio-Oss Bone Graft 0.5g',
	name_sr = 'Koštani graft Geistlich Bio-Oss 0.5g',
	name_sr_cyrl = 'Коштани графт Geistlich Bio-Oss 0.5г',
	name_ru = 'Костный материал Geistlich Bio-Oss 0.5 г',
	name_de = 'Knochenersatzmaterial Geistlich Bio-Oss 0.5 g',
	name_tr = 'Geistlich Bio-Oss kemik grefti 0.5 g'
 WHERE slug = 'biooss-bone-graft-05g';

UPDATE medical_services SET
	name_en = 'Dental Bleeding Control',
	name_sr = 'Zaustavljanje krvarenja (stomatologija)',
	name_sr_cyrl = 'Заустављање крварења (стоматологија)',
	name_ru = 'Остановка кровотечения (стоматология)',
	name_de = 'Zahnärztliche Blutstillung',
	name_tr = 'Dental kanama kontrolü'
 WHERE slug = 'bleeding-control-dental';

UPDATE medical_services SET
	name_en = 'Bone Augmentation Bio-Oss',
	name_sr = 'Augmentacija alveolarnog grebena Bio-Oss',
	name_sr_cyrl = 'Аугментација алвеоларног гребена Bio-Oss',
	name_ru = 'Аугментация альвеолярного гребня Bio-Oss',
	name_de = 'Knochenaugmentation Bio-Oss',
	name_tr = 'Kemik Augmentasyonu Bio-Oss'
 WHERE slug = 'bone-augmentation-biooss';

UPDATE medical_services SET
	name_de = 'Botox-Injektion'
 WHERE slug = 'botox-injection';

UPDATE medical_services SET
	name_sr = 'Botox, jedna regija',
	name_sr_cyrl = 'Ботокс, једна регија',
	name_ru = 'Ботокс, одна зона',
	name_de = 'Botox, eine Region',
	name_tr = 'Tek Bölge Botoks'
 WHERE slug = 'botox-single-region';

UPDATE medical_services SET
	name_sr = 'Botox tretman',
	name_sr_cyrl = 'Ботокс третман',
	name_de = 'Botox-Behandlung'
 WHERE slug = 'botox-treatment';

UPDATE medical_services SET
	name_sr = 'Blokada brahijalnog pleksusa',
	name_sr_cyrl = 'Блокада брахијалног плексуса'
 WHERE slug = 'brachial-plexus-block';

UPDATE medical_services SET
	name_en = 'Breast Lift (Mastopexy)',
	name_sr = 'Podizanje grudi (mastopeksija)',
	name_sr_cyrl = 'Подизање груди (мастопексија)',
	name_ru = 'Подтяжка груди (мастопексия)',
	name_de = 'Bruststraffung (Mastopexie)',
	name_tr = 'Meme Dikleştirme (Mastopeksi)'
 WHERE slug = 'breast-lift-mastopexy';

UPDATE medical_services SET
	name_en = 'Burn Wound Care up to 10% of Body Surface (Primary, Delayed Primary or Secondary)',
	name_sr = 'Primarna, primarno odložena ili sekundarna obrada opekotina do 10% površine tijela',
	name_sr_cyrl = 'Примарна, примарно одложена или секундарна обрада опекотина до 10% површине тијела',
	name_ru = 'Первичная, отсроченная первичная или вторичная обработка ожогов площадью до 10% поверхности тела',
	name_de = 'Primäre, verzögerte primäre oder sekundäre Verbrennungsversorgung bis 10 % der Körperoberfläche',
	name_tr = 'Vücut yüzeyinin %10''una kadar yanık yarası bakımı (primer, gecikmiş primer veya sekonder)'
 WHERE slug = 'burn-wound-care-primary-delayed-primary-or-secondary';

UPDATE medical_services SET
	name_sr = 'Osteotomija kalkaneusa, uključujući unutrašnju fiksaciju',
	name_sr_cyrl = 'Остеотомија калканеуса, укључујући унутрашњу фиксацију',
	name_ru = 'Остеотомия пяточной кости с внутренней фиксацией',
	name_tr = 'Kalkaneus osteotomisi (iç fiksasyonla)'
 WHERE slug = 'calcaneal-osteotomy-with-internal-fixation';

UPDATE medical_services SET
	name_ru = 'Репозиция перелома пяточной кости (закрытая или открытая)',
	name_de = 'Reposition einer Calcaneusfraktur (offen oder geschlossen)',
	name_tr = 'Kalkaneus kırığı redüksiyonu (kapalı veya açık)'
 WHERE slug = 'calcaneus-fracture-open-or-closed';

UPDATE medical_services SET
	name_sr = 'Kapsulektomija sa aspiracijom sočivnih masa (operacija meke mrene)',
	name_sr_cyrl = 'Капсулектомија са аспирацијом сочивних маса (операција меке мрене)',
	name_ru = 'Капсулэктомия с аспирацией хрусталиковых масс при мягкой катаракте',
	name_tr = 'Yumuşak katarakt için kapsülektomi ve lens materyali aspirasyonu'
 WHERE slug = 'capsulectomy-with-lens-mass-aspiration-soft-cataract';

UPDATE medical_services SET
	name_en = 'Capsulotomy or Capsuloplasty for Metacarpophalangeal Contracture (Single Joint)',
	name_sr = 'Kapsulotomija ili kapsuloplastika kod kontrakture metakarpofalangealnog zgloba (jedan zglob)',
	name_sr_cyrl = 'Капсулотомија или капсулопластика код контрактуре метакарпофалангеалног зглоба (један зглоб)',
	name_ru = 'Капсулотомия или капсулопластика при контрактуре пястно-фалангового сустава (один сустав)',
	name_de = 'Kapsulotomie/Kapsuloplastik bei Kontraktur des Metakarpophalangealgelenks (ein Gelenk)',
	name_tr = 'Metakarpofalangeal eklem kontraktüründe kapsülotomi veya kapsüloplasti (tek eklem)'
 WHERE slug = 'capsulotomy-or-capsuloplasty-for-contracture';

UPDATE medical_services SET
	name_en = 'Capsulotomy or Capsuloplasty for Interphalangeal Contracture (One or More Joints)',
	name_sr = 'Kapsulotomija ili kapsuloplastika kod kontrakture interfalangealnog zgloba (jedan ili više zglobova)',
	name_sr_cyrl = 'Капсулотомија или капсулопластика код контрактуре интерфалангеалног зглоба (један или више зглобова)',
	name_ru = 'Капсулотомия или капсулопластика при контрактуре межфалангового сустава (один или несколько)',
	name_de = 'Kapsulotomie/Kapsuloplastik bei Kontraktur des Interphalangealgelenks (ein oder mehrere Gelenke)',
	name_tr = 'İnterfalangeal eklem kontraktüründe kapsülotomi veya kapsüloplasti (bir veya daha fazla eklem)'
 WHERE slug = 'capsulotomycapsuloplasty-for-interphalangeal-contracture';

UPDATE medical_services SET
	name_de = 'Pflegetag in der kardiologischen Rehabilitation'
 WHERE slug = 'cardiac-rehabilitation-bed-day';

UPDATE medical_services SET
	name_tr = 'Kalp Ritmi Kardiyoversiyonu'
 WHERE slug = 'cardiac-rhythm-cardioversion';

UPDATE medical_services SET
	name_sr = 'Telemetrija srca',
	name_sr_cyrl = 'Телеметрија срца'
 WHERE slug = 'cardiac-telemetry';

UPDATE medical_services SET
	name_sr = 'Pregled kardiologa sa EKG-om i ehokardiografijom (ultrazvuk srca)',
	name_sr_cyrl = 'Преглед кардиолога са ЕКГ-ом и ехокардиографијом (ултразвук срца)',
	name_tr = 'EKG ve Ekokardiyografi ile Kardiyoloji Muayenesi (Kalp Ultrasonu)'
 WHERE slug = 'cardiologist-examination-with-ecg-and-echocardiography-heart-ultrasound';

UPDATE medical_services SET
	name_sr = 'Fraktura karpalne kosti — zatvorena ili otvorena, otvorena repozicija sa Kiršnerovom iglom',
	name_sr_cyrl = 'Фрактура карпалне кости — затворена или отворена, отворена репозиција са Киршнеровом иглом',
	name_ru = 'Открытая репозиция перелома кости запястья с фиксацией спицей Киршнера',
	name_de = 'Offene Reposition einer Handwurzelknochenfraktur mit Kirschner-Draht'
 WHERE slug = 'carpal-bone-fracture-open-reduction-with-k-wire';

UPDATE medical_services SET
	name_sr = 'Operacija sindroma karpalnog tunela',
	name_sr_cyrl = 'Операција синдрома карпалног тунела',
	name_ru = 'Операция при синдроме карпального канала',
	name_de = 'Karpaltunneloperation'
 WHERE slug = 'carpal-tunnel-surgery';

UPDATE medical_services SET
	name_ru = 'Репозиция вывиха запястно-пястного сустава большого пальца (закрытая или открытая)',
	name_de = 'Reposition einer Daumensattelgelenksluxation (offen oder geschlossen)',
	name_tr = 'Karpometakarpal başparmak dislokasyonu redüksiyonu (kapalı veya açık)'
 WHERE slug = 'carpometacarpal-thumb-joint-dislocation-reduction';

UPDATE medical_services SET
	name_ru = 'Удаление катаракты с имплантацией стандартной ИОЛ'
 WHERE slug = 'cataract-surgery-with-standard-iol';

UPDATE medical_services SET
	name_en = 'Transcatheter Organ Ablation by Feeding Artery Embolization',
	name_ru = 'Катетерная эктомия органа (эмболизация питающей артерии)',
	name_tr = 'Besleyici arter embolizasyonu ile transkateter organ ablasyonu'
 WHERE slug = 'catheter-organ-resection-by-feeding-artery-embolization';

UPDATE medical_services SET
	name_en = 'Cauterization, Electrocauterization or Cryocauterization of Benign or Premalignant Skin and Mucosal Lesions (4 Lesions)',
	name_sr = 'Kauterizacija, elektrokauterizacija ili kriokauterizacija benignih ili premalignih lezija kože i sluznica (4 lezije)',
	name_sr_cyrl = 'Каутеризација, електрокаутеризација или криокаутеризација бенигних или премалигних лезија коже и слузница (4 лезије)',
	name_ru = 'Прижигание, электрокоагуляция или криодеструкция доброкачественных или предраковых образований кожи и слизистых (4 образования)',
	name_de = 'Kauterisation, Elektrokauterisation oder Kryokauterisation benigner oder prämaligner Haut- und Schleimhautläsionen (4 Läsionen)',
	name_tr = 'İyi huylu veya prekanseröz cilt ve mukoza lezyonlarının kauterizasyonu, elektrokauterizasyonu veya kriyokauterizasyonu (4 lezyon)'
 WHERE slug = 'cauterization-electrocauterization-or-cryocauterization-of-benign-skin-lesions-extensive';

UPDATE medical_services SET
	name_en = 'Cauterization, Electrocauterization or Cryocauterization of Benign or Premalignant Skin and Mucosal Lesions (3 Lesions)',
	name_sr = 'Kauterizacija, elektrokauterizacija ili kriokauterizacija benignih ili premalignih lezija kože i sluznica (3 lezije)',
	name_sr_cyrl = 'Каутеризација, електрокаутеризација или криокаутеризација бенигних или премалигних лезија коже и слузница (3 лезије)',
	name_ru = 'Прижигание, электрокоагуляция или криодеструкция доброкачественных или предраковых образований кожи и слизистых (3 образования)',
	name_de = 'Kauterisation, Elektrokauterisation oder Kryokauterisation benigner oder prämaligner Haut- und Schleimhautläsionen (3 Läsionen)',
	name_tr = 'İyi huylu veya prekanseröz cilt ve mukoza lezyonlarının kauterizasyonu, elektrokauterizasyonu veya kriyokauterizasyonu (3 lezyon)'
 WHERE slug = 'cauterization-electrocauterization-or-cryocauterization-of-benign-skin-lesions-larger';

UPDATE medical_services SET
	name_en = 'Cauterization, Electrocauterization or Cryocauterization of Benign or Premalignant Skin and Mucosal Lesions (2 Lesions)',
	name_sr = 'Kauterizacija, elektrokauterizacija ili kriokauterizacija benignih ili premalignih lezija kože i sluznica (2 lezije)',
	name_sr_cyrl = 'Каутеризација, електрокаутеризација или криокаутеризација бенигних или премалигних лезија коже и слузница (2 лезије)',
	name_ru = 'Прижигание, электрокоагуляция или криодеструкция доброкачественных или предраковых образований кожи и слизистых (2 образования)',
	name_de = 'Kauterisation, Elektrokauterisation oder Kryokauterisation benigner oder prämaligner Haut- und Schleimhautläsionen (2 Läsionen)',
	name_tr = 'İyi huylu veya prekanseröz cilt ve mukoza lezyonlarının kauterizasyonu, elektrokauterizasyonu veya kriyokauterizasyonu (2 lezyon)'
 WHERE slug = 'cauterization-electrocauterization-or-cryocauterization-of-benign-skin-lesions-medium';

UPDATE medical_services SET
	name_en = 'Cauterization, Electrocauterization or Cryocauterization of Benign or Premalignant Skin and Mucosal Lesions (5 or More Lesions)',
	name_sr = 'Kauterizacija, elektrokauterizacija ili kriokauterizacija benignih ili premalignih lezija kože i sluznica (5 i više lezija)',
	name_sr_cyrl = 'Каутеризација, електрокаутеризација или криокаутеризација бенигних или премалигних лезија коже и слузница (5 и више лезија)',
	name_ru = 'Прижигание, электрокоагуляция или криодеструкция доброкачественных или предраковых образований кожи и слизистых (5 и более образований)',
	name_de = 'Kauterisation, Elektrokauterisation oder Kryokauterisation benigner oder prämaligner Haut- und Schleimhautläsionen (5 oder mehr Läsionen)',
	name_tr = 'İyi huylu veya prekanseröz cilt ve mukoza lezyonlarının kauterizasyonu, elektrokauterizasyonu veya kriyokauterizasyonu (5 ve üzeri lezyon)'
 WHERE slug = 'cauterization-electrocauterization-or-cryocauterization-of-benign-skin-lesions-multiple';

UPDATE medical_services SET
	name_en = 'Cauterization, Electrocauterization or Cryocauterization of Benign or Premalignant Skin and Mucosal Lesions (1 Lesion)',
	name_sr = 'Kauterizacija, elektrokauterizacija ili kriokauterizacija benignih ili premalignih lezija kože i sluznica (1 lezija)',
	name_sr_cyrl = 'Каутеризација, електрокаутеризација или криокаутеризација бенигних или премалигних лезија коже и слузница (1 лезија)',
	name_ru = 'Прижигание, электрокоагуляция или криодеструкция доброкачественных или предраковых образований кожи и слизистых (1 образование)',
	name_de = 'Kauterisation, Elektrokauterisation oder Kryokauterisation benigner oder prämaligner Haut- und Schleimhautläsionen (1 Läsion)',
	name_tr = 'İyi huylu veya prekanseröz cilt ve mukoza lezyonlarının kauterizasyonu, elektrokauterizasyonu veya kriyokauterizasyonu (1 lezyon)'
 WHERE slug = 'cauterization-electrocauterization-or-cryocauterization-of-benign-skin-lesions-small';

UPDATE medical_services SET
	name_sr = 'Keramički inlay ili onlay (bezmetalna plomba)',
	name_sr_cyrl = 'Керамички inlay или onlay (безметална пломба)',
	name_ru = 'Керамическая вкладка инлей или онлей'
 WHERE slug = 'ceramic-inlay-onlay';

UPDATE medical_services SET
	name_ru = 'Удаление опухоли или абсцесса полушария большого мозга',
	name_de = 'Entfernung eines Tumors oder Abszesses aus der Großhirnhemisphäre'
 WHERE slug = 'cerebral-hemisphere-tumor-or-abscess-removal';

UPDATE medical_services SET
	name_de = 'Ohrenspülung zur Entfernung von Ohrenschmalz'
 WHERE slug = 'cerumen-ear-irrigation';

UPDATE medical_services SET
	name_tr = 'Rahim Ağzı Amputasyonu'
 WHERE slug = 'cervical-amputation';

UPDATE medical_services SET
	name_ru = 'Ревизия артерии или вены шеи'
 WHERE slug = 'cervical-artery-or-vein-exploration';

UPDATE medical_services SET
	name_sr = 'Lokalna aplikacija lijeka na grlić materice',
	name_sr_cyrl = 'Локална апликација лијека на грлић материце',
	name_ru = 'Местная обработка шейки матки лекарственным препаратом',
	name_de = 'Lokale Arzneimittelapplikation am Gebärmutterhals'
 WHERE slug = 'cervical-drug-application';

UPDATE medical_services SET
	name_tr = 'Boyunda duktus torasikusun sütürü veya ligasyonu'
 WHERE slug = 'cervical-thoracic-duct-suture-or-ligation';

UPDATE medical_services SET
	name_en = 'Chalazion Removal in Children under General Anesthesia',
	name_tr = 'Çocuklarda Genel Anestezi Altında Şalazyon Çıkarma'
 WHERE slug = 'chalazion-removal-children-general-anesthesia';

UPDATE medical_services SET
	name_en = 'Chalazion Removal under Local Anesthesia',
	name_tr = 'Lokal Anestezi Altında Şalazyon Çıkarma'
 WHERE slug = 'chalazion-removal-local-anesthesia';

UPDATE medical_services SET
	name_en = 'Chemical Face Peel',
	name_de = 'Chemisches Peeling des Gesichts',
	name_tr = 'Yüz İçin Kimyasal Peeling'
 WHERE slug = 'chemical-peeling-face';

UPDATE medical_services SET
	name_ru = 'Повторный осмотр ребёнка в стационаре'
 WHERE slug = 'child-follow-up-hospital-round';

UPDATE medical_services SET
	name_ru = 'Первичный осмотр ребёнка в стационаре',
	name_de = 'Stationäre Aufnahmeuntersuchung des Kindes'
 WHERE slug = 'child-initial-hospital-workup';

UPDATE medical_services SET
	name_ru = 'Подбородочная праща'
 WHERE slug = 'chin-cap';

UPDATE medical_services SET
	name_de = 'Fußamputation nach Chopart',
	name_tr = 'Chopart amputasyonu'
 WHERE slug = 'chopart-tarsal-amputation';

UPDATE medical_services SET
	name_sr = 'Odstranjenje hroničnog subduralnog hematoma',
	name_sr_cyrl = 'Одстрањење хроничног субдуралног хематома',
	name_de = 'Entfernung eines chronischen Subduralhämatoms'
 WHERE slug = 'chronic-subdural-hematoma-removal';

UPDATE medical_services SET
	name_en = 'Circumcision under Local Anesthesia'
 WHERE slug = 'circumcision-local-anesthesia';

UPDATE medical_services SET
	name_ru = 'Репозиция перелома ключицы (закрытая или открытая) с фиксацией или без',
	name_de = 'Reposition einer Klavikulafraktur (offen oder geschlossen) mit oder ohne Fixation',
	name_tr = 'Klavikula kırığı redüksiyonu (kapalı veya açık), fiksasyonlu veya fiksasyonsuz'
 WHERE slug = 'clavicle-fracture-closed-or-open-withwithout-fixation';

UPDATE medical_services SET
	name_ru = 'Закрытая репозиция открытого или закрытого перелома ключицы',
	name_de = 'Manipulationsreposition einer Klavikulafraktur (offen oder geschlossen)',
	name_tr = 'Klavikula kırığı manipülatif redüksiyonu (açık veya kapalı kırık)'
 WHERE slug = 'clavicle-fracture-open-or-closed-manipulative-reduction';

UPDATE medical_services SET
	name_en = 'Closed Joint Reduction with Immobilization',
	name_sr = 'Zatvorena repozicija zgloba i primjena sredstava imobilizacije',
	name_sr_cyrl = 'Затворена репозиција зглоба и примјена средстава имобилизације',
	name_ru = 'Закрытое вправление сустава с применением средств иммобилизации',
	name_de = 'Geschlossene Gelenkreposition mit Immobilisation',
	name_tr = 'İmmobilizasyon ile kapalı eklem redüksiyonu'
 WHERE slug = 'closed-joint-reduction-with-mobilization';

UPDATE medical_services SET
	name_sr = 'Zatvorena manipulativna repozicija bimaleolarne frakture gležnja',
	name_sr_cyrl = 'Затворена манипулативна репозиција бималеоларне фрактуре глежња'
 WHERE slug = 'closed-manipulation-reduction-of-bimalleolar-ankle-fracture';

UPDATE medical_services SET
	name_en = 'Closed Manipulation Reduction of Distal Tibia or Medial/Lateral Malleolus Fracture',
	name_sr = 'Zatvorena manipulativna repozicija frakture distalnog dijela potkoljenice, medijalnog ili lateralnog maleolusa',
	name_sr_cyrl = 'Затворена манипулативна репозиција фрактуре дисталног дијела поткољенице, медијалног или латералног малеолуса',
	name_ru = 'Закрытая репозиция перелома дистальной части голени, внутренней или наружной лодыжки',
	name_de = 'Geschlossene Manipulationsreposition einer distalen Tibia- oder Innen-/Außenknöchelfraktur',
	name_tr = 'Distal tibia, medial veya lateral malleol kırığı kapalı manipülatif redüksiyonu'
 WHERE slug = 'closed-manipulation-reduction-of-distal-tibia-fracture';

UPDATE medical_services SET
	name_sr = 'Zatvorena manipulativna repozicija frakture dijafize humerusa'
 WHERE slug = 'closed-manipulation-reduction-of-humerus-diaphysis-fracture';

UPDATE medical_services SET
	name_en = 'Closed Manipulation Reduction of Proximal Ulna (Olecranon) Fracture',
	name_sr = 'Zatvorena manipulativna repozicija frakture proksimalnog kraja ulne (olekranona)',
	name_sr_cyrl = 'Затворена манипулативна репозиција фрактуре проксималног краја улне (олекранона)',
	name_ru = 'Закрытая репозиция перелома проксимального конца локтевой кости (локтевого отростка)',
	name_de = 'Geschlossene Manipulationsreposition einer proximalen Ulnafraktur (Olekranon)',
	name_tr = 'Proksimal ulna (olekranon) kırığı kapalı manipülatif redüksiyonu'
 WHERE slug = 'closed-manipulation-reduction-of-proximal-end-fracture';

UPDATE medical_services SET
	name_ru = 'Закрытая репозиция перелома проксимальной или средней фаланги пальцев кисти',
	name_de = 'Geschlossene Manipulationsreposition einer Grund- oder Mittelgliedfraktur der Finger',
	name_tr = 'El parmağı proksimal veya orta falanks kırığı kapalı manipülatif redüksiyonu'
 WHERE slug = 'closed-manipulation-reduction-of-proximal-fracture';

UPDATE medical_services SET
	name_sr = 'Zatvorena manipulativna repozicija frakture proksimalnog dijela tibije',
	name_sr_cyrl = 'Затворена манипулативна репозиција фрактуре проксималног дијела тибије'
 WHERE slug = 'closed-manipulation-reduction-of-proximal-tibia-fracture';

UPDATE medical_services SET
	name_de = 'Geschlossene Manipulationsreposition einer Radiusköpfchen- und Radiushalsfraktur',
	name_tr = 'Radius başı ve boynu kırığı kapalı manipülatif redüksiyonu'
 WHERE slug = 'closed-manipulation-reduction-of-radius-head-and-neck-fracture';

UPDATE medical_services SET
	name_ru = 'Закрытая репозиция перелома диафиза костей голени (большеберцовой и малоберцовой)'
 WHERE slug = 'closed-manipulation-reduction-of-tibia-and-fibula-diaphysis-fracture';

UPDATE medical_services SET
	name_ru = 'Закрытая репозиция перелома мыщелка бедренной кости',
	name_de = 'Geschlossene Manipulationsreposition einer Femurkondylenfraktur',
	name_tr = 'Femur kondil kırığı kapalı manipülatif redüksiyonu'
 WHERE slug = 'closed-manipulative-reduction-of-femoral-condyle-fracture';

UPDATE medical_services SET
	name_ru = 'Закрытая репозиция перелома шейки бедра',
	name_de = 'Geschlossene Manipulationsreposition einer Schenkelhalsfraktur',
	name_tr = 'Femur boyun kırığı kapalı manipülatif redüksiyonu'
 WHERE slug = 'closed-manipulative-reduction-of-femoral-neck-fracture';

UPDATE medical_services SET
	name_en = 'Closed Reduction of Humerus Neck Fracture (Surgical or Anatomical)',
	name_sr = 'Zatvorena repozicija frakture vrata humerusa (hirurškog ili anatomskog)',
	name_sr_cyrl = 'Затворена репозиција фрактуре врата хумеруса (хируршког или анатомског)',
	name_ru = 'Закрытая репозиция перелома хирургической или анатомической шейки плечевой кости',
	name_de = 'Geschlossene Reposition einer Humerushalsfraktur (chirurgischer oder anatomischer Hals)',
	name_tr = 'Humerus boyun kırığı kapalı redüksiyonu (cerrahi veya anatomik boyun)'
 WHERE slug = 'closed-reduction-of-humerus-neck-fracture';

UPDATE medical_services SET
	name_en = 'Closed Reduction of Sacroiliac Joint or Pubic Symphysis Dislocation',
	name_sr = 'Zatvorena manipulativna repozicija dislokacije sakroilijačnog zgloba ili simfize pubisa',
	name_sr_cyrl = 'Затворена манипулативна репозиција дислокације сакроилијачног зглоба или симфизе пубиса',
	name_ru = 'Закрытая репозиция вывиха крестцово-подвздошного сустава или лонного сочленения',
	name_de = 'Geschlossene Reposition einer Iliosakralgelenks- oder Symphysenluxation',
	name_tr = 'Sakroiliak eklem veya simfizis pubis dislokasyonunun kapalı redüksiyonu'
 WHERE slug = 'closed-reduction-of-sacroiliac-joint-dislocation';

UPDATE medical_services SET
	name_en = 'Closed Reduction of Wrist Joint (Radiocarpal, Radioulnar or Intercarpal)',
	name_sr = 'Zatvorena manipulativna repozicija ručnog zgloba (radiokarpalnog, radioulnarnog ili interkarpalnog)',
	name_sr_cyrl = 'Затворена манипулативна репозиција ручног зглоба (радиокарпалног, радиоулнарног или интеркарпалног)',
	name_ru = 'Закрытое вправление лучезапястного, лучелоктевого или межзапястного сустава',
	name_de = 'Geschlossene Reposition des Handgelenks (radiokarpal, radioulnar oder interkarpal)',
	name_tr = 'El bileği ekleminin kapalı redüksiyonu (radiokarpal, radioulnar veya interkarpal)'
 WHERE slug = 'closed-reduction-of-wrist-joint';

UPDATE medical_services SET
	name_sr = 'Repozicija — zatvoreni torakobrahijalni gips',
	name_sr_cyrl = 'Репозиција — затворени торакобрахијални гипс',
	name_ru = 'Репозиция — закрытый торакобрахиальный гипс',
	name_de = 'Reposition mit geschlossenem thorakobrachialem Gips',
	name_tr = 'Kapalı torakobrakiyal alçı ile redüksiyon'
 WHERE slug = 'closed-thoracobrachial-plaster-reduction';

UPDATE medical_services SET
	name_sr = 'Reparacija kolateralnog ili ukrštenog ligamenta',
	name_sr_cyrl = 'Репарација колатералног или укрштеног лигамента',
	name_de = 'Reparatur eines Kollateral- oder Kreuzbandes'
 WHERE slug = 'collateral-or-cruciate-ligament-repair';

UPDATE medical_services SET
	name_sr = 'RTG pregled debelog crijeva kroz stomu',
	name_sr_cyrl = 'RTG преглед дебелог цријева кроз стому',
	name_de = 'Röntgenuntersuchung des Dickdarms über das Stoma'
 WHERE slug = 'colon-x-ray-through-stoma';

UPDATE medical_services SET
	name_de = 'Totalprothese aus Acryl'
 WHERE slug = 'complete-acrylic-denture';

UPDATE medical_services SET
	name_sr = 'Kompletna fasciektomija',
	name_sr_cyrl = 'Комплетна фасциектомија',
	name_tr = 'Total fasiektomi'
 WHERE slug = 'complete-fasciectomy';

UPDATE medical_services SET
	name_ru = 'Полное обследование на глаукому'
 WHERE slug = 'complete-glaucoma-examination';

UPDATE medical_services SET
	name_sr = 'Kompletno pedijatrijsko čišćenje zuba',
	name_sr_cyrl = 'Комплетно педијатријско чишћење зуба',
	name_de = 'Vollständige Zahnreinigung bei Kindern'
 WHERE slug = 'complete-pediatric-dental-cleaning';

UPDATE medical_services SET
	name_sr = 'Pregled, kontrola i previjanje komplikovane rane',
	name_sr_cyrl = 'Преглед, контрола и превијање компликоване ране',
	name_ru = 'Осмотр, контроль и перевязка осложнённой раны',
	name_de = 'Untersuchung, Kontrolle und Verband bei komplizierter Wunde',
	name_tr = 'Komplikasyonlu yara muayenesi, kontrolü ve pansumanı'
 WHERE slug = 'complicated-wound-examination-and-dressing';

UPDATE medical_services SET
	name_ru = 'Комплексная стоматологическая диагностика с составлением плана лечения'
 WHERE slug = 'comprehensive-dental-diagnostics-with-treatment-plan';

UPDATE medical_services SET
	name_ru = 'Комплексная ортодонтическая диагностика'
 WHERE slug = 'comprehensive-orthodontic-diagnostics';

UPDATE medical_services SET
	name_en = 'Removal of Condylomas and Other Benign Growths of the Vulva and Vagina',
	name_ru = 'Удаление кондилом и других доброкачественных образований вульвы и влагалища',
	name_de = 'Entfernung von Kondylomen und anderen gutartigen Wucherungen an Vulva und Vagina',
	name_tr = 'Vulva ve Vajinadaki Kondilom ve Diğer İyi Huylu Oluşumların Çıkarılması'
 WHERE slug = 'condyloma-and-benign-growth-removal-vulva-vagina';

UPDATE medical_services SET
	name_ru = 'Осмотр консилиумом врачей',
	name_tr = 'Hekim konseyi muayenesi'
 WHERE slug = 'consilium-medical-examination';

UPDATE medical_services SET
	name_sr = 'Kontaktna i beskontaktna dermatotermometrija',
	name_sr_cyrl = 'Контактна и бесконтактна дерматотермометрија',
	name_de = 'Dermatothermometrie mit und ohne Hautkontakt'
 WHERE slug = 'contact-and-non-contact-dermatothermometry';

UPDATE medical_services SET
	name_en = 'Contact Lens Wear and Care Training',
	name_ru = 'Обучение ношению контактных линз и уходу за ними',
	name_de = 'Schulung zum Tragen und zur Pflege von Kontaktlinsen',
	name_tr = 'Kontakt Lens Kullanımı ve Bakımı Eğitimi'
 WHERE slug = 'contact-lens-fitting-and-care-training';

UPDATE medical_services SET
	name_en = 'Coxofemoral Circular Plaster Reduction with Spreader Bar',
	name_ru = 'Репозиция — циркулярный гипс тазобедренного сустава с распоркой',
	name_de = 'Reposition mit koxofemoralem Zirkulärgips und Spreizstab',
	name_tr = 'Ara çubuklu koksofemoral sirküler alçı ile redüksiyon'
 WHERE slug = 'coxofemoral-circular-plaster-reduction';

UPDATE medical_services SET
	name_sr = 'Plastika koštanog defekta kranijuma',
	name_sr_cyrl = 'Пластика коштаног дефекта кранијума',
	name_de = 'Plastische Deckung eines knöchernen Schädeldefekts'
 WHERE slug = 'cranial-bone-defect-plasty';

UPDATE medical_services SET
	name_en = 'Cranial Osteomyelitis Treatment',
	name_ru = 'Лечение остеомиелита черепа',
	name_de = 'Behandlung einer Osteomyelitis des Schädels',
	name_tr = 'Kranial osteomiyelit tedavisi'
 WHERE slug = 'cranial-osteomyelitis';

UPDATE medical_services SET
	name_en = 'Craniectomy with ICP Monitor, Drain or Reservoir Placement',
	name_ru = 'Краниэктомия с установкой датчика внутричерепного давления, дренажа или резервуара',
	name_de = 'Kraniektomie mit Anlage einer Hirndrucksonde, Drainage oder eines Reservoirs',
	name_tr = 'ICP monitörü, dren veya rezervuar yerleştirilmesiyle kraniyektomi'
 WHERE slug = 'craniectomy-with-icp-monitoring-or-reservoir';

UPDATE medical_services SET
	name_de = 'Rezementierung einer Krone oder Brücke'
 WHERE slug = 'crown-or-bridge-recementation';

UPDATE medical_services SET
	name_ru = 'Вытяжение шейного отдела позвоночника по Кречфилду',
	name_de = 'Extension der Halswirbelsäule nach Crutchfield'
 WHERE slug = 'crutchfield-cervical-spine-traction';

UPDATE medical_services SET
	name_sr = 'Štitnik za zube po mjeri',
	name_sr_cyrl = 'Штитник за зубе по мјери'
 WHERE slug = 'custom-dental-guard';

UPDATE medical_services SET
	name_en = 'Cystoscopy (Female)'
 WHERE slug = 'cystoscopy-female';

UPDATE medical_services SET
	name_en = 'Cystoscopy (Male)'
 WHERE slug = 'cystoscopy-male';

UPDATE medical_services SET
	name_ru = 'Суточный профиль внутриглазного давления (ВГД)'
 WHERE slug = 'daily-intraocular-pressure-profile';

UPDATE medical_services SET
	name_ru = 'Использование родильного зала (за одни роды)',
	name_tr = 'Doğumhane kullanımı (doğum başına)'
 WHERE slug = 'delivery-room-usage-per-birth';

UPDATE medical_services SET
	name_sr = 'Nosač zubnog mosta',
	name_sr_cyrl = 'Носач зубног моста',
	name_ru = 'Опора мостовидного протеза',
	name_de = 'Zahnbrückenpfeiler',
	name_tr = 'Diş köprüsü dayanağı'
 WHERE slug = 'dental-bridge-abutment';

UPDATE medical_services SET
	name_sr = 'Konsultacija stomatologa',
	name_sr_cyrl = 'Консултација стоматолога'
 WHERE slug = 'dental-consultation';

UPDATE medical_services SET
	name_sr = 'Produženje kliničke krune zuba',
	name_sr_cyrl = 'Продужење клиничке круне зуба',
	name_ru = 'Удлинение клинической коронки зуба',
	name_de = 'Klinische Kronenverlängerung',
	name_tr = 'Klinik kuron boyu uzatma'
 WHERE slug = 'dental-crown-lengthening';

UPDATE medical_services SET
	name_ru = 'Первая стоматологическая помощь',
	name_tr = 'Diş hekimliğinde ilk yardım'
 WHERE slug = 'dental-first-aid';

UPDATE medical_services SET
	name_de = 'Anbringen von Zahnschmuck'
 WHERE slug = 'dental-jewelry-application';

UPDATE medical_services SET
	name_de = 'Zahnärztliche Lokalanästhesie'
 WHERE slug = 'dental-local-anesthesia';

UPDATE medical_services SET
	name_sr = 'Sinus lift',
	name_sr_cyrl = 'Синус лифт',
	name_ru = 'Синус-лифтинг',
	name_de = 'Sinuslift',
	name_tr = 'Sinüs lifting'
 WHERE slug = 'dental-sinus-lift';

UPDATE medical_services SET
	name_de = 'Erweiterung der Prothese um eine Klammer',
	name_tr = 'Proteze Kroşe Ekleme'
 WHERE slug = 'denture-clasp-addition';

UPDATE medical_services SET
	name_de = 'Erweiterung der Prothese um einen Zahn'
 WHERE slug = 'denture-tooth-addition';

UPDATE medical_services SET
	name_en = 'Treatment of Depressed Fracture with Dural and Major Venous Injury',
	name_ru = 'Лечение вдавленного перелома с повреждением твёрдой мозговой оболочки и крупных венозных сосудов',
	name_de = 'Behandlung einer Impressionsfraktur mit Verletzung der Dura und großer Venen',
	name_tr = 'Dura ve büyük ven yaralanmalı çökme kırığı tedavisi'
 WHERE slug = 'depressed-fracture-with-dural-and-major-venous-injury';

UPDATE medical_services SET
	name_en = 'Treatment of Depressed Skull Fracture (with/without Dural Injury)',
	name_ru = 'Лечение вдавленного перелома черепа (с повреждением твёрдой мозговой оболочки или без)',
	name_de = 'Behandlung einer Impressionsfraktur des Schädels mit oder ohne Duraverletzung',
	name_tr = 'Kafatası çökme kırığı tedavisi (dura yaralanmalı veya yaralanmasız)'
 WHERE slug = 'depressed-skull-fracture-withwithout-dural-injury';

UPDATE medical_services SET
	name_sr = 'Pregled dermatologa sa dermatoskopijom',
	name_sr_cyrl = 'Преглед дерматолога са дерматоскопијом'
 WHERE slug = 'dermatologist-examination-with-dermatoscopy';

UPDATE medical_services SET
	name_sr = 'Dijadinamske struje',
	name_sr_cyrl = 'Дијадинамске струје'
 WHERE slug = 'diadynamic-currents';

UPDATE medical_services SET
	name_de = 'Digitales Smile Design'
 WHERE slug = 'digital-smile-design';

UPDATE medical_services SET
	name_tr = 'Diyoptri Tayini'
 WHERE slug = 'diopter-determination';

UPDATE medical_services SET
	name_de = 'Direktes Komposit-Veneer'
 WHERE slug = 'direct-composite-veneer';

UPDATE medical_services SET
	name_en = 'Distal Phalanx Fracture Manipulation Reduction (Finger or Thumb)',
	name_sr = 'Manipulativna repozicija frakture distalne falange palca ili prsta šake',
	name_sr_cyrl = 'Манипулативна репозиција фрактуре дисталне фаланге палца или прста шаке',
	name_ru = 'Закрытая репозиция перелома дистальной фаланги пальца кисти',
	name_de = 'Manipulationsreposition einer Endgliedfraktur an Daumen oder Finger',
	name_tr = 'Başparmak veya el parmağı distal falanks kırığının manipülatif redüksiyonu'
 WHERE slug = 'distal-phalanx-fracture-manipulation-reduction';

UPDATE medical_services SET
	name_en = 'Manipulative Reduction of Distal Radial Epiphysis Fracture (Open or Closed)',
	name_sr = 'Manipulativna repozicija frakture distalne epifize radijusa (otvorene ili zatvorene)',
	name_sr_cyrl = 'Манипулативна репозиција фрактуре дисталне епифизе радијуса (отворене или затворене)',
	name_ru = 'Закрытая репозиция открытого или закрытого перелома дистального эпифиза лучевой кости',
	name_de = 'Manipulationsreposition einer distalen Radiusepiphysenfraktur (offen oder geschlossen)',
	name_tr = 'Distal radius epifiz kırığı manipülatif redüksiyonu (açık veya kapalı kırık)'
 WHERE slug = 'distal-radial-epiphysis-fracture-open-or-closed-reduction';

UPDATE medical_services SET
	name_en = 'Distal Tibiofibular Joint Dislocation (Closed or Open) with Open Reduction or Fixation',
	name_sr = 'Dislokacija distalnog tibiofibularnog zgloba — zatvorena ili otvorena, sa otvorenom repozicijom ili fiksacijom',
	name_sr_cyrl = 'Дислокација дисталног тибиофибуларног зглоба — затворена или отворена, са отвореном репозицијом или фиксацијом',
	name_ru = 'Открытая репозиция или фиксация при закрытом или открытом вывихе дистального тибиофибулярного сустава',
	name_de = 'Offene Reposition oder Fixation bei distaler Tibiofibulargelenksluxation (geschlossen oder offen)',
	name_tr = 'Distal tibiofibular eklem dislokasyonunda (kapalı veya açık) açık redüksiyon veya fiksasyon'
 WHERE slug = 'distal-tibiofibular-joint-dislocation';

UPDATE medical_services SET
	name_sr = 'Dolder prečka',
	name_sr_cyrl = 'Долдер пречка',
	name_de = 'Dolder-Steg'
 WHERE slug = 'dolder-bar';

UPDATE medical_services SET
	name_tr = 'Renal Arter Doppler'
 WHERE slug = 'doppler-renal-arteries';

UPDATE medical_services SET
	name_ru = 'Ирригоскопия и ирригография с двойным контрастированием (по Фишеру)'
 WHERE slug = 'double-contrast-barium-enema-fischer-method';

UPDATE medical_services SET
	name_en = 'Schirmer Test for Dry Eye',
	name_de = 'Test auf trockenes Auge (Schirmer-Test)'
 WHERE slug = 'dry-eye-test-schirmer';

UPDATE medical_services SET
	name_sr = 'Ehokardiografija (ultrazvuk srca)',
	name_sr_cyrl = 'Ехокардиографија (ултразвук срца)'
 WHERE slug = 'echocardiography-heart-ultrasound';

UPDATE medical_services SET
	name_en = 'Elbow Joint Arthrotomy (Capsulotomy) with Exploration, Drainage and Foreign Body Removal',
	name_sr = 'Artrotomija (kapsulotomija) lakatnog zgloba sa eksploracijom, drenažom i vađenjem stranog tijela',
	name_sr_cyrl = 'Артротомија (капсулотомија) лакатног зглоба са експлорацијом, дренажом и вађењем страног тијела',
	name_ru = 'Артротомия (капсулотомия) локтевого сустава с ревизией, дренированием и удалением инородного тела',
	name_de = 'Arthrotomie (Kapsulotomie) des Ellenbogengelenks mit Exploration, Drainage und Fremdkörperentfernung',
	name_tr = 'Dirsek eklemi artrotomisi / kapsülotomisi (eksplorasyon, drenaj ve yabancı cisim çıkarılması)'
 WHERE slug = 'elbow-joint-arthrotomy-capsulotomy-with-exploration';

UPDATE medical_services SET
	name_tr = 'Dirsek veya el bileği fiksasyon bandajı'
 WHERE slug = 'elbow-or-wrist-fixation-bandage';

UPDATE medical_services SET
	name_en = 'EMNG of Lower and Upper Limbs',
	name_sr = 'EMNG donjih i gornjih ekstremiteta',
	name_sr_cyrl = 'ЕМНГ доњих и горњих екстремитета',
	name_ru = 'ЭНМГ нижних и верхних конечностей',
	name_de = 'EMNG der unteren und oberen Extremitäten',
	name_tr = 'Alt ve üst ekstremite EMNG'
 WHERE slug = 'emng-de-and-ge';

UPDATE medical_services SET
	name_en = 'EMNG of Lower or Upper Limbs',
	name_sr = 'EMNG donjih ili gornjih ekstremiteta',
	name_sr_cyrl = 'ЕМНГ доњих или горњих екстремитета',
	name_ru = 'ЭНМГ нижних или верхних конечностей',
	name_de = 'EMNG der unteren oder oberen Extremitäten',
	name_tr = 'Alt veya üst ekstremite EMNG'
 WHERE slug = 'emng-de-or-ge';

UPDATE medical_services SET
	name_de = 'Endovaskuläre Stent-Graft-Implantation in die Bauchaorta',
	name_tr = 'Abdominal aorta endovasküler stent greft yerleştirilmesi'
 WHERE slug = 'endovascular-stent-graft-in-abdominal-aorta';

UPDATE medical_services SET
	name_ru = 'Эндоваскулярная установка стент-графта в бедренную артерию',
	name_de = 'Endovaskuläre Stent-Graft-Implantation in die Femoralarterie',
	name_tr = 'Femoral artere endovasküler stent greft yerleştirilmesi'
 WHERE slug = 'endovascular-stent-graft-in-femoral-artery';

UPDATE medical_services SET
	name_de = 'Endovaskuläre Stent-Graft-Implantation in die Iliakalarterien',
	name_tr = 'İliak arterlere endovasküler stent greft yerleştirilmesi'
 WHERE slug = 'endovascular-stent-graft-in-iliac-arteries';

UPDATE medical_services SET
	name_sr = 'Endovaskularna procedura — plasiranje stent grafta u poplitealnu i/ili kruralne arterije',
	name_sr_cyrl = 'Ендоваскуларна процедура — пласирање стент графта у поплитеалну и/или круралне артерије',
	name_ru = 'Эндоваскулярная установка стент-графта в подколенную артерию и/или артерии голени',
	name_de = 'Endovaskuläre Stent-Graft-Implantation in die Poplitealarterie und/oder Unterschenkelarterien',
	name_tr = 'Popliteal ve/veya krural arterlere endovasküler stent greft yerleştirilmesi'
 WHERE slug = 'endovascular-stent-graft-in-poplitealcrural-arteries';

UPDATE medical_services SET
	name_de = 'Endovaskuläre Stent-Graft-Implantation in die Brustaorta',
	name_tr = 'Torasik aorta endovasküler stent greft yerleştirilmesi'
 WHERE slug = 'endovascular-stent-graft-in-thoracic-aorta';

UPDATE medical_services SET
	name_en = 'Enema Administration (Medium)'
 WHERE slug = 'enema-administration-medium';

UPDATE medical_services SET
	name_sr = 'Enukleacija ili ekscizija spoljašnjih tromboziranih hemoroida',
	name_sr_cyrl = 'Енуклеација или ексцизија спољашњих тромбозираних хемороида'
 WHERE slug = 'enucleation-or-excision-of-external-thrombosed-hemorrhoids';

UPDATE medical_services SET
	name_ru = 'Нагрузочный тест на велоэргометре с полной записью ЭКГ',
	name_tr = 'Tam EKG kaydı ile bisiklet ergometresinde efor testi'
 WHERE slug = 'ergocycle-stress-test-with-complete-ecg';

UPDATE medical_services SET
	name_ru = 'Эргометрия - нагрузочный ЭКГ-тест',
	name_de = 'Ergometrie - Belastungs-EKG'
 WHERE slug = 'ergometry-ecg-stress-test';

UPDATE medical_services SET
	name_ru = 'Эргометрия - нагрузочный тест'
 WHERE slug = 'ergometry-stress-test';

UPDATE medical_services SET
	name_en = 'Erythrocyte Preparation in Additive Solution (OAS)',
	name_ru = 'Приготовление эритроцитов в добавочном растворе (OAS)',
	name_de = 'Herstellung von Erythrozyten in Additivlösung (OAS)',
	name_tr = 'Katkı çözeltisinde eritrosit hazırlığı (OAS)'
 WHERE slug = 'erythrocyte-suspension-in-oas-preparation';

UPDATE medical_services SET
	name_de = 'Funktionsprüfung der Eustachischen Röhre'
 WHERE slug = 'eustachian-tube-function-test';

UPDATE medical_services SET
	name_en = 'Excision and Direct Suture of Benign Skin Lesions over 4 cm in Diameter',
	name_sr = 'Ekscizija i direktna sutura benignih lezija kože dijametra preko 4 cm',
	name_sr_cyrl = 'Ексцизија и директна сутура бенигних лезија коже дијаметра преко 4 цм',
	name_ru = 'Иссечение доброкачественных образований кожи диаметром более 4 см с ушиванием раны',
	name_de = 'Exzision und direkte Naht benigner Hautläsionen mit über 4 cm Durchmesser',
	name_tr = '4 cm''den büyük iyi huylu cilt lezyonlarının eksizyonu ve direkt sütürü'
 WHERE slug = 'excision-and-direct-suture-of-benign-skin-lesions';

UPDATE medical_services SET
	name_ru = 'Иссечение кисты или доброкачественной опухоли (например, крыла подвздошной кости) с аутотрансплантатом или без',
	name_de = 'Exzision einer Zyste oder eines gutartigen Tumors (z. B. Darmbeinschaufel) mit oder ohne autologes Knochentransplantat',
	name_tr = 'Kist veya benign tümör eksizyonu (ör. iliak kanat), otogreftli veya otogreftsiz'
 WHERE slug = 'excision-of-cyst-or-benign-tumor-iliac-crest-etc-withwithout-autograft';

UPDATE medical_services SET
	name_sr = 'Ekscizija spoljašnjih tromboziranih hemoroida',
	name_sr_cyrl = 'Ексцизија спољашњих тромбозираних хемороида',
	name_tr = 'Trombozlu eksternal hemoroid eksizyonu'
 WHERE slug = 'excision-of-external-thrombosed-hemorrhoids';

UPDATE medical_services SET
	name_ru = 'Иссечение кисты или доброкачественной опухоли бедренной кости',
	name_de = 'Exzision einer Zyste oder eines gutartigen Tumors des Femurs',
	name_tr = 'Femurda kist veya benign tümör eksizyonu'
 WHERE slug = 'excision-of-femur-cyst-or-benign-tumor';

UPDATE medical_services SET
	name_ru = 'Иссечение кисты или доброкачественной опухоли плечевой кости',
	name_de = 'Exzision einer Zyste oder eines gutartigen Tumors des Humerus',
	name_tr = 'Humerusta kist veya benign tümör eksizyonu'
 WHERE slug = 'excision-of-humerus-cyst-or-benign-tumor';

UPDATE medical_services SET
	name_en = 'Excision of Irregular Scars and Defect Closure by Direct Suture',
	name_sr = 'Ekscizija nepravilnih ožiljaka i zatvaranje defekta direktnom suturom',
	name_sr_cyrl = 'Ексцизија неправилних ожиљака и затварање дефекта директном сутуром',
	name_ru = 'Иссечение неровных рубцов с закрытием дефекта прямым швом',
	name_de = 'Exzision unregelmäßiger Narben mit Defektverschluss durch Direktnaht',
	name_tr = 'Düzensiz skarların eksizyonu ve defektin direkt sütürle kapatılması'
 WHERE slug = 'excision-of-irregular-scars-and-defect-closure';

UPDATE medical_services SET
	name_ru = 'Иссечение злокачественных образований кожи с ушиванием раны'
 WHERE slug = 'excision-of-malignant-skin-lesions-with-wound-suturing';

UPDATE medical_services SET
	name_sr = 'Ekscizija ciste ili benignog tumora radijusa ili ulne',
	name_ru = 'Иссечение кисты или доброкачественной опухоли лучевой или локтевой кости',
	name_de = 'Exzision einer Zyste oder eines gutartigen Tumors von Radius oder Ulna',
	name_tr = 'Radius veya ulnada kist veya benign tümör eksizyonu'
 WHERE slug = 'excision-of-radius-or-ulna-cyst-or-benign-tumor';

UPDATE medical_services SET
	name_en = 'Excision of Small Benign Tumor-Like Scars, Fibromas or Cysts',
	name_ru = 'Иссечение малых доброкачественных опухолевидных рубцов, фиброзных и кистозных образований',
	name_de = 'Exzision kleiner benigner tumorartiger Narben, Fibrome oder Zysten',
	name_tr = 'Küçük iyi huylu tümör benzeri skar, fibroma veya kistlerin eksizyonu'
 WHERE slug = 'excision-of-small-benign-tumor-scars-fibromas-or-cysts';

UPDATE medical_services SET
	name_en = 'Excision of Tendon Sheath or Capsule Lesion (Cyst, Ganglion) of Lower Leg or Foot',
	name_sr = 'Ekscizija lezije tetivnog omotača ili kapsule (npr. ciste ili gangliona) potkoljenice ili stopala',
	name_sr_cyrl = 'Ексцизија лезије тетивног омотача или капсуле (нпр. цисте или ганглиона) поткољенице или стопала',
	name_ru = 'Иссечение образования сухожильного влагалища или суставной капсулы (кисты, ганглия) голени или стопы',
	name_de = 'Exzision einer Sehnenscheiden- oder Kapselläsion (Zyste, Ganglion) an Unterschenkel oder Fuß',
	name_tr = 'Alt bacak veya ayakta tendon kılıfı ya da kapsül lezyonu eksizyonu (kist, ganglion)'
 WHERE slug = 'excision-of-tendon-sheath-or-capsule-lesion-cyst-ganglion';

UPDATE medical_services SET
	name_ru = 'Иссечение кисты или доброкачественной опухоли большеберцовой или малоберцовой кости',
	name_de = 'Exzision einer Zyste oder eines gutartigen Tumors von Tibia oder Fibula',
	name_tr = 'Tibia veya fibulada kist veya benign tümör eksizyonu'
 WHERE slug = 'excision-of-tibia-or-fibula-cyst-or-benign-tumor';

UPDATE medical_services SET
	name_en = 'Excisional Biopsy of Skin, Subcutaneous Tissue or Mucosa with Direct Suture',
	name_sr = 'Ekscizijska biopsija kože, potkožnog tkiva i sluznice sa direktnim šavom',
	name_sr_cyrl = 'Ексцизијска биопсија коже, поткожног ткива и слузнице са директним шавом',
	name_ru = 'Эксцизионная биопсия кожи, подкожной клетчатки или слизистой с ушиванием раны',
	name_de = 'Exzisionsbiopsie von Haut, Unterhautgewebe oder Schleimhaut mit direkter Naht',
	name_tr = 'Cilt, cilt altı doku veya mukozadan eksizyonel biyopsi ve direkt sütür'
 WHERE slug = 'excisional-biopsy-of-skin-subcutaneous-tissue-or-mucosa';

UPDATE medical_services SET
	name_sr = 'Vježbe na spravama: puli aparat ili ergobicikl, kinetička šina, suspenzija',
	name_sr_cyrl = 'Вјежбе на справама: пули апарат или ергобицикл, кинетичка шина, суспензија',
	name_de = 'Übungen an Geräten: Seilzug oder Ergometer, Bewegungsschiene (CPM), Schlingentisch',
	name_tr = 'Aletli egzersizler: makara veya ergobisiklet, CPM cihazı, süspansiyon'
 WHERE slug = 'exercises-on-equipment-pulley-ergocycle-cpm-suspension';

UPDATE medical_services SET
	name_en = 'Hertel Exophthalmometry',
	name_sr = 'Egzoftalmometrija po Hertelu',
	name_sr_cyrl = 'Егзофталмометрија по Хертелу'
 WHERE slug = 'exophthalmometry-hertel';

UPDATE medical_services SET
	name_ru = 'Диагностическая лапаротомия'
 WHERE slug = 'exploratory-laparotomy';

UPDATE medical_services SET
	name_ru = 'Диагностическая супра- или инфратенториальная трепанация'
 WHERE slug = 'exploratory-supratentorial-or-infratentorial-trepanation';

UPDATE medical_services SET
	name_de = 'Entfernung eines ausgedehnten Weichteiltumors der Kopfhaut mit Knochendestruktion'
 WHERE slug = 'extensive-scalp-soft-tissue-tumor-removal-with-bone-destruction';

UPDATE medical_services SET
	name_ru = 'Установка наружного вентрикулярного дренажа'
 WHERE slug = 'external-ventricular-drainage';

UPDATE medical_services SET
	name_ru = 'Удаление полуретинированного или ретинированного зуба'
 WHERE slug = 'extraction-of-semi-impacted-or-impacted-tooth';

UPDATE medical_services SET
	name_sr = 'Incizija apscesa ekstraoralnim putem'
 WHERE slug = 'extraoral-abscess-incision';

UPDATE medical_services SET
	name_ru = 'Упражнения на координацию движений конечностей и равновесие при ходьбе',
	name_de = 'Übungen zur Bewegungskoordination der Extremitäten und zum Gleichgewicht beim Gehen'
 WHERE slug = 'extremity-coordination-and-gait-balance-exercises';

UPDATE medical_services SET
	name_ru = 'Рентгенография глазного яблока по Фогту'
 WHERE slug = 'eye-bulb-x-ray-vogt-method';

UPDATE medical_services SET
	name_ru = 'Иссечение опухоли века с пластикой кожным лоскутом'
 WHERE slug = 'eyelid-tumor-excision-with-skin-flap';

UPDATE medical_services SET
	name_tr = 'Göz Kapağı Tümörünün Cerrahi Olarak Çıkarılması'
 WHERE slug = 'eyelid-tumor-surgical-removal';

UPDATE medical_services SET
	name_sr = 'Lifting lica',
	name_sr_cyrl = 'Lifting лица'
 WHERE slug = 'face-lift';

UPDATE medical_services SET
	name_sr = 'Mezoterapija lica, jedan tretman',
	name_sr_cyrl = 'Мезотерапија лица, један третман',
	name_ru = 'Мезотерапия лица, один сеанс',
	name_de = 'Gesichtsmesotherapie, Einzelbehandlung',
	name_tr = 'Yüz Mezoterapisi, Tek Seans'
 WHERE slug = 'facial-mesotherapy-single-treatment';

UPDATE medical_services SET
	name_ru = 'Удаление менингиомы серпа большого мозга',
	name_tr = 'Falks menenjiyomu çıkarımı'
 WHERE slug = 'falx-meningioma-removal';

UPDATE medical_services SET
	name_de = 'Aneurysmektomie und Rekonstruktion der Femoralarterie',
	name_tr = 'Femoral arter anevrizmektomisi ve rekonstrüksiyonu'
 WHERE slug = 'femoral-artery-aneurysmectomy-and-reconstruction';

UPDATE medical_services SET
	name_en = 'Femur Fracture Reduction (Closed or Open) with/without Internal Fixation',
	name_sr = 'Fraktura femura — zatvorena ili otvorena (složena) repozicija sa ili bez unutrašnje fiksacije',
	name_sr_cyrl = 'Фрактура фемура — затворена или отворена (сложена) репозиција са или без унутрашње фиксације',
	name_ru = 'Репозиция перелома бедренной кости (закрытая или открытая) с внутренней фиксацией или без',
	name_de = 'Reposition einer Femurfraktur (offen oder geschlossen) mit oder ohne interne Fixation',
	name_tr = 'Femur kırığı redüksiyonu (kapalı veya açık), iç fiksasyonlu veya fiksasyonsuz'
 WHERE slug = 'femur-fracture-reduction-closed-or-open';

UPDATE medical_services SET
	name_en = 'Fibula Fracture Reduction (Closed or Open) with/without Internal or External Fixation',
	name_sr = 'Fraktura fibule — zatvorena ili otvorena (složena) repozicija sa ili bez unutrašnje ili spoljašnje fiksacije',
	name_sr_cyrl = 'Фрактура фибуле — затворена или отворена (сложена) репозиција са или без унутрашње или спољашње фиксације',
	name_ru = 'Репозиция перелома малоберцовой кости (закрытая или открытая) с внутренней или наружной фиксацией или без',
	name_de = 'Reposition einer Fibulafraktur (offen oder geschlossen) mit oder ohne interne oder externe Fixation',
	name_tr = 'Fibula kırığı redüksiyonu (kapalı veya açık), iç veya dış fiksasyonlu ya da fiksasyonsuz'
 WHERE slug = 'fibula-fracture-reduction-withwithout-fixation';

UPDATE medical_services SET
	name_en = 'Filling Retention with Fiber or Zirconia Post',
	name_ru = 'Укрепление пломбы стекловолоконным (FRC) или циркониевым штифтом',
	name_de = 'Füllungsretention mit Glasfaser- oder Zirkonstift',
	name_tr = 'Fiber veya Zirkonyum Post ile Dolgu Retansiyonu'
 WHERE slug = 'filling-retention-with-fiber-post';

UPDATE medical_services SET
	name_ru = 'Укрепление пломбы металлическим штифтом'
 WHERE slug = 'filling-retention-with-metal-post';

UPDATE medical_services SET
	name_de = 'Herstellung gefilterter Erythrozyten'
 WHERE slug = 'filtered-erythrocyte-preparation';

UPDATE medical_services SET
	name_en = 'Single Finger Amputation at Any Joint or Phalanx',
	name_sr = 'Amputacija jednog prsta šake na nivou bilo kojeg zgloba ili falange',
	name_sr_cyrl = 'Ампутација једног прста шаке на нивоу било којег зглоба или фаланге',
	name_ru = 'Ампутация одного пальца кисти на уровне любого сустава или фаланги',
	name_de = 'Amputation eines Fingers auf Höhe eines beliebigen Gelenks oder Fingerglieds',
	name_tr = 'Tek el parmağının herhangi bir eklem veya falanks seviyesinden amputasyonu'
 WHERE slug = 'finger-amputation-at-any-phalanx';

UPDATE medical_services SET
	name_ru = 'Первичный осмотр по поводу заболевания',
	name_de = 'Erstuntersuchung bei Erkrankung',
	name_tr = 'Hastalık nedeniyle ilk muayene'
 WHERE slug = 'first-curative-examination';

UPDATE medical_services SET
	name_ru = 'Первичный осмотр ЛОР-специалиста'
 WHERE slug = 'first-ent-examination';

UPDATE medical_services SET
	name_ru = 'Первичный осмотр ортопеда'
 WHERE slug = 'first-orthopedist-examination';

UPDATE medical_services SET
	name_de = 'Erstuntersuchung Physikalische und Rehabilitative Medizin'
 WHERE slug = 'first-physiatrist-examination';

UPDATE medical_services SET
	name_ru = 'Первичный осмотр физиотерапевта для детей с особыми потребностями',
	name_de = 'Erstuntersuchung Physikalische und Rehabilitative Medizin für Kinder mit besonderen Bedürfnissen',
	name_tr = 'Özel ihtiyaçlı çocuklar için ilk fizyatrist muayenesi'
 WHERE slug = 'first-physiatrist-examination-for-children-with-special-needs';

UPDATE medical_services SET
	name_sr = 'Prvi kurativni pregled žena (specijalistički)',
	name_sr_cyrl = 'Први куративни преглед жена (специјалистички)',
	name_ru = 'Первичный осмотр гинеколога-специалиста по поводу заболевания',
	name_de = 'Fachärztliche gynäkologische Erstuntersuchung bei Erkrankung'
 WHERE slug = 'first-specialist-curative-gynecological-examination';

UPDATE medical_services SET
	name_ru = 'Первичный осмотр хирурга'
 WHERE slug = 'first-surgical-examination';

UPDATE medical_services SET
	name_ru = 'Первичный осмотр торакального хирурга'
 WHERE slug = 'first-thoracic-surgeon-examination';

UPDATE medical_services SET
	name_sr = 'Prvi pregled urologa',
	name_sr_cyrl = 'Први преглед уролога',
	name_ru = 'Первичный осмотр уролога'
 WHERE slug = 'first-urologist-examination';

UPDATE medical_services SET
	name_ru = 'Первичный осмотр сосудистого хирурга'
 WHERE slug = 'first-vascular-surgeon-examination';

UPDATE medical_services SET
	name_en = 'ICP Transducer Placement for Continuous Monitoring in Raised ICP of Various Etiologies',
	name_sr = 'Fiksiranje transdjusera za kontinuirano mjerenje povećanog intrakranijalnog pritiska različite etiologije',
	name_sr_cyrl = 'Фиксирање трансдјусера за континуирано мјерење повећаног интракранијалног притиска различите етиологије',
	name_ru = 'Установка датчика для непрерывного мониторинга ВЧД при внутричерепной гипертензии различной этиологии',
	name_de = 'Anlage einer Hirndrucksonde zur kontinuierlichen Messung bei erhöhtem Hirndruck unterschiedlicher Ätiologie',
	name_tr = 'Farklı etiyolojili kafa içi basınç artışında sürekli monitörizasyon için transdüser yerleştirilmesi'
 WHERE slug = 'fixation-transducer-for-icp-monitoring-in-various-etiologies';

UPDATE medical_services SET
	name_ru = 'Брекет-система керамическая или композитная на одну челюсть'
 WHERE slug = 'fixed-braces-ceramic-or-composite-per-jaw';

UPDATE medical_services SET
	name_ru = 'Брекет-система металлическая на одну челюсть'
 WHERE slug = 'fixed-braces-metal-per-jaw';

UPDATE medical_services SET
	name_ru = 'Брекет-система сапфировая на одну челюсть'
 WHERE slug = 'fixed-braces-sapphire-per-jaw';

UPDATE medical_services SET
	name_tr = 'Sabit Ortodontik Braket Çene Başına'
 WHERE slug = 'fixed-orthodontic-braces-per-arch';

UPDATE medical_services SET
	name_de = 'Kontrolle der festen Zahnspange'
 WHERE slug = 'fixed-orthodontic-check-up';

UPDATE medical_services SET
	name_en = 'Periodontal Flap Surgery',
	name_sr = 'Parodontalna operacija režnja',
	name_sr_cyrl = 'Пародонтална операција режња',
	name_ru = 'Лоскутная операция на пародонте',
	name_de = 'Parodontale Lappenoperation',
	name_tr = 'Periodontal Flep Ameliyatı'
 WHERE slug = 'flap-surgery-periodontal';

UPDATE medical_services SET
	name_sr = 'Kontrolni pregled kardiologa',
	name_sr_cyrl = 'Контролни преглед кардиолога'
 WHERE slug = 'follow-up-cardiologist-examination';

UPDATE medical_services SET
	name_de = 'Zahnärztliche Kontrolluntersuchung',
	name_tr = 'Diş Kontrol Muayenesi'
 WHERE slug = 'follow-up-dental-examination';

UPDATE medical_services SET
	name_tr = 'Dermatoloji Kontrol Muayenesi'
 WHERE slug = 'follow-up-dermatologist-examination';

UPDATE medical_services SET
	name_ru = 'Повторный осмотр ЛОР-специалиста',
	name_de = 'HNO-Nachuntersuchung'
 WHERE slug = 'follow-up-ent-examination';

UPDATE medical_services SET
	name_de = 'Gastroenterologische Nachuntersuchung'
 WHERE slug = 'follow-up-gastroenterologist-examination';

UPDATE medical_services SET
	name_de = 'Nachuntersuchung beim Allgemeinarzt'
 WHERE slug = 'follow-up-general-practitioner-examination';

UPDATE medical_services SET
	name_ru = 'Повторный осмотр в стационаре (обход)'
 WHERE slug = 'follow-up-hospital-round';

UPDATE medical_services SET
	name_tr = 'Enfeksiyon hastalıkları kontrol muayenesi'
 WHERE slug = 'follow-up-infectious-disease-specialist-examination';

UPDATE medical_services SET
	name_tr = 'Nefroloji kontrol muayenesi'
 WHERE slug = 'follow-up-nephrologist-examination';

UPDATE medical_services SET
	name_de = 'Neurologische Kontrolluntersuchung'
 WHERE slug = 'follow-up-neurologist-examination';

UPDATE medical_services SET
	name_ru = 'Контрольный осмотр нейрохирурга',
	name_de = 'Neurochirurgische Kontrolluntersuchung'
 WHERE slug = 'follow-up-neurosurgeon-examination';

UPDATE medical_services SET
	name_sr = 'Kontrolni pregled oftalmologa',
	name_de = 'Ophthalmologische Kontrolluntersuchung'
 WHERE slug = 'follow-up-ophthalmologist-examination';

UPDATE medical_services SET
	name_tr = 'Pediatrik Kontrol Muayenesi'
 WHERE slug = 'follow-up-pediatric-examination';

UPDATE medical_services SET
	name_de = 'Kontrolluntersuchung Physikalische und Rehabilitative Medizin'
 WHERE slug = 'follow-up-physiatrist-examination';

UPDATE medical_services SET
	name_ru = 'Повторный осмотр физиотерапевта для детей с особыми потребностями',
	name_de = 'Kontrolluntersuchung Physikalische und Rehabilitative Medizin für Kinder mit besonderen Bedürfnissen',
	name_tr = 'Özel ihtiyaçlı çocuklar için fizyatrist kontrol muayenesi'
 WHERE slug = 'follow-up-physiatrist-examination-for-children-with-special-needs';

UPDATE medical_services SET
	name_de = 'Kontrolluntersuchung durch einen Professor',
	name_tr = 'Profesör Kontrol Muayenesi'
 WHERE slug = 'follow-up-professor-examination';

UPDATE medical_services SET
	name_tr = 'Psikiyatri kontrol muayenesi'
 WHERE slug = 'follow-up-psychiatrist-examination';

UPDATE medical_services SET
	name_de = 'Rheumatologische Kontrolluntersuchung'
 WHERE slug = 'follow-up-rheumatologist-examination';

UPDATE medical_services SET
	name_ru = 'Контрольный осмотр врача-специалиста',
	name_tr = 'Uzman Kontrol Muayenesi'
 WHERE slug = 'follow-up-specialist-examination';

UPDATE medical_services SET
	name_ru = 'Контрольный осмотр педиатра узкого профиля',
	name_tr = 'Pediatrik Yan Dal Uzmanı Kontrol Muayenesi'
 WHERE slug = 'follow-up-subspecialist-pediatric-examination';

UPDATE medical_services SET
	name_tr = 'Genel cerrahi kontrol muayenesi'
 WHERE slug = 'follow-up-surgical-examination';

UPDATE medical_services SET
	name_sr = 'Kontrolni pregled — grudni hirurg',
	name_sr_cyrl = 'Контролни преглед — грудни хирург',
	name_ru = 'Контрольный осмотр торакального хирурга',
	name_de = 'Kontrolluntersuchung beim Thoraxchirurgen',
	name_tr = 'Göğüs cerrahı kontrol muayenesi'
 WHERE slug = 'follow-up-thoracic-surgeon-examination';

UPDATE medical_services SET
	name_de = 'Urologische Kontrolluntersuchung'
 WHERE slug = 'follow-up-urologist-examination';

UPDATE medical_services SET
	name_ru = 'Контрольный осмотр сосудистого хирурга',
	name_tr = 'Damar cerrahı kontrol muayenesi'
 WHERE slug = 'follow-up-vascular-surgeon-examination';

UPDATE medical_services SET
	name_sr = 'Reparacija/sutura fleksornih tetiva stopala, primarna ili sekundarna, jedna ili više',
	name_sr_cyrl = 'Репарација/сутура флексорних тетива стопала, примарна или секундарна, једна или више',
	name_ru = 'Первичный или вторичный шов сухожилий сгибателей стопы (одного или нескольких)',
	name_de = 'Beugersehnenreparatur am Fuß (primär oder sekundär, eine oder mehrere Sehnen)',
	name_tr = 'Ayak fleksör tendon onarımı (primer veya sekonder, bir veya daha fazla tendon)'
 WHERE slug = 'foot-flexor-tendon-repair-primary-or-secondary-one-or-more';

UPDATE medical_services SET
	name_ru = 'Тенолизис сгибателей стопы (одного или нескольких)',
	name_de = 'Beuger-Tenolyse am Fuß (eine oder mehrere Sehnen)',
	name_tr = 'Ayak fleksör tenolizi (bir veya daha fazla tendon)'
 WHERE slug = 'foot-flexor-tenolysis-one-or-more';

UPDATE medical_services SET
	name_sr = 'Amputacija podlaktice kroz radijus i ulnu',
	name_ru = 'Ампутация предплечья через лучевую и локтевую кости',
	name_tr = 'Radius ve ulnadan önkol amputasyonu'
 WHERE slug = 'forearm-amputation-through-radius-and-ulna';

UPDATE medical_services SET
	name_sr = 'Sinovektomija podlaktice i zgloba ručja',
	name_sr_cyrl = 'Синовектомија подлактице и зглоба ручја',
	name_tr = 'Önkol ve el bileği sinovektomisi'
 WHERE slug = 'forearm-and-wrist-joint-synovectomy';

UPDATE medical_services SET
	name_en = 'Eye Foreign Body Removal',
	name_de = 'Fremdkörperentfernung aus dem Auge'
 WHERE slug = 'foreign-body-removal-eye';

UPDATE medical_services SET
	name_ru = 'Стекловолоконный штифт FRC'
 WHERE slug = 'frc-post';

UPDATE medical_services SET
	name_ru = 'Стекловолоконный штифт FRC и восстановление культи зуба',
	name_de = 'FRC-Stift mit Stumpfaufbau',
	name_tr = 'FRC Post ve Kor Yapımı'
 WHERE slug = 'frc-post-build-up';

UPDATE medical_services SET
	name_en = 'Frenulotomy under Local Anesthesia'
 WHERE slug = 'frenulotomy';

UPDATE medical_services SET
	name_sr = 'Kompletna abdominoplastika',
	name_sr_cyrl = 'Комплетна абдоминопластика'
 WHERE slug = 'full-abdominoplasty';

UPDATE medical_services SET
	name_ru = 'Функциональное исследование почек',
	name_de = 'Nierenfunktionsprüfung',
	name_tr = 'Fonksiyonel böbrek testi'
 WHERE slug = 'functional-renal-test';

UPDATE medical_services SET
	name_ru = 'Упражнения на координацию, коррекцию и автоматизацию равновесия при ходьбе',
	name_de = 'Übungen zur Koordination, Korrektur und Automatisierung des Gleichgewichts beim Gehen'
 WHERE slug = 'gait-coordination-correction-and-balance-automation-exercises';

UPDATE medical_services SET
	name_de = 'Therapie mit galvanischem Strom im Wasser'
 WHERE slug = 'galvanic-current-therapy-in-water';

UPDATE medical_services SET
	name_en = 'Gangrene Treatment, Single-Root Tooth',
	name_de = 'Gangränbehandlung eines einwurzeligen Zahns'
 WHERE slug = 'gangrene-treatment-single-root';

UPDATE medical_services SET
	name_en = 'Gangrene Treatment, Three-Root Tooth',
	name_de = 'Gangränbehandlung eines dreiwurzeligen Zahns'
 WHERE slug = 'gangrene-treatment-three-root';

UPDATE medical_services SET
	name_en = 'Gangrene Treatment, Two-Root Tooth',
	name_de = 'Gangränbehandlung eines zweiwurzeligen Zahns'
 WHERE slug = 'gangrene-treatment-two-root';

UPDATE medical_services SET
	name_en = 'Gastroenterostomy and Enteroenterostomy',
	name_sr = 'Gastroenteroanastomoza i enteroenteroanastomoza',
	name_sr_cyrl = 'Gastroenteroanastomoza и enteroenteroanastomoza',
	name_de = 'Gastroentero- und Enteroenteroanastomose',
	name_tr = 'Gastroenterostomi ve Enteroenterostomi'
 WHERE slug = 'gastro-entero-and-entero-entero-anastomosis';

UPDATE medical_services SET
	name_sr = 'RTG pregled gastroduodenuma kroz stomu',
	name_sr_cyrl = 'RTG преглед гастродуоденума кроз стому',
	name_ru = 'Рентгенография желудка и ДПК через стому',
	name_de = 'Röntgenuntersuchung von Magen und Duodenum über das Stoma',
	name_tr = 'Stoma yoluyla mide ve duodenum röntgeni'
 WHERE slug = 'gastroduodenum-x-ray-through-stoma';

UPDATE medical_services SET
	name_de = 'Untersuchung beim Allgemeinarzt'
 WHERE slug = 'general-practitioner-examination';

UPDATE medical_services SET
	name_tr = 'Dev kauda ekvina tümörü çıkarımı'
 WHERE slug = 'giant-cauda-equina-tumor-removal';

UPDATE medical_services SET
	name_en = 'Group Exercises in Corrective Cast for Scoliosis or Milwaukee Brace (Per Person)',
	name_ru = 'Групповые упражнения в корригирующем гипсе при сколиозе или в корсете Милуоки (на одного человека)',
	name_de = 'Gruppenübungen im Korrekturgips für Skoliose oder im Milwaukee-Korsett (pro Person)',
	name_tr = 'Skolyoz için düzeltici alçı veya Milwaukee korsesi içinde grup egzersizleri (kişi başı)'
 WHERE slug = 'group-exercises-in-corrective-cast-for-scoliosis-or-milwaukee-brace';

UPDATE medical_services SET
	name_en = 'Guillotine Arm Amputation',
	name_sr = 'Giljotinska amputacija ruke',
	name_sr_cyrl = 'Гиљотинска ампутација руке',
	name_de = 'Guillotine-Amputation des Arms',
	name_tr = 'Giyotin kol amputasyonu'
 WHERE slug = 'guillotine-hand-amputation';

UPDATE medical_services SET
	name_ru = 'Осмотр гинеколога-специалиста'
 WHERE slug = 'gynecological-specialist-examination';

UPDATE medical_services SET
	name_ru = 'Осмотр гинеколога-специалиста с УЗИ'
 WHERE slug = 'gynecological-specialist-examination-with-ultrasound';

UPDATE medical_services SET
	name_sr = 'Hallux valgus, korekcija sa metatarzalnom osteotomijom',
	name_sr_cyrl = 'Hallux valgus, корекција са метатарзалном остеотомијом',
	name_ru = 'Коррекция Hallux valgus с метатарзальной остеотомией'
 WHERE slug = 'hallux-valgus-correction-with-metatarsal-osteotomy';

UPDATE medical_services SET
	name_en = 'Hallux Valgus Correction with Exostectomy',
	name_sr = 'Hallux valgus, korekcija pomoću egzostektomije',
	name_sr_cyrl = 'Hallux valgus, корекција помоћу егзостектомије',
	name_ru = 'Коррекция Hallux valgus с экзостэктомией',
	name_de = 'Hallux-valgus-Korrektur mit Exostektomie',
	name_tr = 'Ekzostektomi ile halluks valgus düzeltmesi'
 WHERE slug = 'hallux-valgus-correction-with-x-ostectomy';

UPDATE medical_services SET
	name_de = 'Handamputation auf Höhe des Metakarpalgelenks'
 WHERE slug = 'hand-amputation-through-metacarpal-joint';

UPDATE medical_services SET
	name_en = 'Hand and Foot Extensor Tenotomy (One or More)',
	name_sr = 'Tenotomija ekstenzora šake i stopala, jednog ili više',
	name_sr_cyrl = 'Тенотомија екстензора шаке и стопала, једног или више',
	name_ru = 'Тенотомия разгибателей кисти и стопы (одного или нескольких)',
	name_de = 'Strecksehnen-Tenotomie an Hand und Fuß (eine oder mehrere)',
	name_tr = 'El ve ayak ekstansör tenotomisi (bir veya daha fazla)'
 WHERE slug = 'hand-and-foot-extensor-tenotomy';

UPDATE medical_services SET
	name_ru = 'Репозиция перелома проксимальной или средней фаланги пальца кисти (закрытая или открытая)',
	name_de = 'Reposition einer Grund- oder Mittelgliedfraktur der Finger (geschlossen oder offen)',
	name_tr = 'El parmağı proksimal veya orta falanks kırığı redüksiyonu (kapalı veya açık)'
 WHERE slug = 'hand-proximal-or-middle-phalanx-fracture-reduction';

UPDATE medical_services SET
	name_en = 'Reconstruction after Hartmann Procedure',
	name_sr = 'Rekonstrukcija nakon Hartmanove operacije',
	name_sr_cyrl = 'Реконструкција након Хартманове операције',
	name_de = 'Rekonstruktion nach Hartmann-Operation',
	name_tr = 'Hartmann Ameliyatı Sonrası Rekonstrüksiyon'
 WHERE slug = 'hartmann-reconstruction';

UPDATE medical_services SET
	name_en = 'Hemorrhoid Rubber Band Ligation (per Node)',
	name_ru = 'Латексное лигирование геморроя, за узел',
	name_de = 'Gummibandligatur von Hämorrhoiden, pro Knoten',
	name_tr = 'Hemoroid Lastik Bant Ligasyonu (nodül başına)'
 WHERE slug = 'hemorrhoid-rubber-band-ligation';

UPDATE medical_services SET
	name_en = 'Classic Hemorrhoid Surgery',
	name_de = 'Klassische Hämorrhoiden-Operation',
	name_tr = 'Klasik Hemoroid Ameliyatı'
 WHERE slug = 'hemorrhoid-surgery-classic';

UPDATE medical_services SET
	name_en = 'Hemorrhoid Treatment by Electrocoagulation (per Session)',
	name_sr = 'Liječenje hemoroida električnom destrukcijom (po seansi)',
	name_sr_cyrl = 'Лијечење хемороида електричном деструкцијом (по сеанси)',
	name_ru = 'Лечение геморроя электродеструкцией (за сеанс)',
	name_de = 'Hämorrhoidenbehandlung durch Elektrokoagulation (pro Sitzung)',
	name_tr = 'Elektrokoagülasyon ile hemoroid tedavisi (seans başına)'
 WHERE slug = 'hemorrhoid-treatment-with-electric-destruction';

UPDATE medical_services SET
	name_de = 'Reposition mit Gips von der Hüfte bis zum Sprunggelenk',
	name_tr = 'Kalçadan ayak bileğine alçı ile redüksiyon'
 WHERE slug = 'hip-to-ankle-plaster-reduction';

UPDATE medical_services SET
	name_de = 'Langzeit-Blutdruckmessung'
 WHERE slug = 'holter-blood-pressure-monitoring';

UPDATE medical_services SET
	name_ru = 'Выезд на дом (центр города)'
 WHERE slug = 'home-visit-city-center';

UPDATE medical_services SET
	name_ru = 'Выезд врача и медсестры на дом',
	name_de = 'Hausbesuch durch Arzt und Pflegekraft'
 WHERE slug = 'home-visit-doctor-and-nurse';

UPDATE medical_services SET
	name_de = 'Untersuchung beim Hausbesuch'
 WHERE slug = 'home-visit-examination';

UPDATE medical_services SET
	name_en = 'Hospital Care for Involuntarily Hospitalized Patients and Patients under Compulsory Treatment Order',
	name_sr = 'Bolnička obrada prisilno hospitalizovanih pacijenata i pacijenata sa mjerom obaveznog liječenja i čuvanja',
	name_sr_cyrl = 'Болничка обрада присилно хоспитализованих пацијената и пацијената са мјером обавезног лијечења и чувања',
	name_ru = 'Ведение в стационаре принудительно госпитализированных пациентов и пациентов на принудительном лечении',
	name_de = 'Stationäre Betreuung von zwangseingewiesenen Patienten und Patienten im Maßregelvollzug',
	name_tr = 'Zorunlu yatırılmış ve güvenlik tedbiri olarak zorunlu tedavi gören hastaların hastane bakımı'
 WHERE slug = 'hospital-care-for-involuntarily-hospitalized-patient';

UPDATE medical_services SET
	name_tr = 'Taburcu epikrizi'
 WHERE slug = 'hospital-discharge-letter';

UPDATE medical_services SET
	name_en = 'Humerus Diaphysis Fracture (Open Reduction with/without Fixation)',
	name_sr = 'Fraktura dijafize humerusa — zatvorena ili otvorena (složena), otvorena repozicija sa/bez fiksacije',
	name_sr_cyrl = 'Фрактура дијафизе хумеруса — затворена или отворена (сложена), отворена репозиција са/без фиксације',
	name_ru = 'Открытая репозиция закрытого или открытого перелома диафиза плечевой кости с фиксацией или без',
	name_de = 'Offene Reposition einer geschlossenen oder offenen Humerusschaftfraktur mit oder ohne Fixation',
	name_tr = 'Kapalı veya açık humerus diyafiz kırığının açık redüksiyonu, fiksasyonlu veya fiksasyonsuz'
 WHERE slug = 'humerus-diaphysis-fracture-closed-or-open-reduction';

UPDATE medical_services SET
	name_de = 'Hyaluronsäure-Filler',
	name_tr = 'Hyaluronik Asit Dolgusu'
 WHERE slug = 'hyaluronic-acid-filler';

UPDATE medical_services SET
	name_sr = 'Hijaluronski filer 1 ml',
	name_sr_cyrl = 'Хијалуронски филер 1 мл',
	name_ru = 'Гиалуроновый филлер 1 мл',
	name_de = 'Hyaluronsäure-Filler 1 ml',
	name_tr = 'Hyaluronik Dolgu 1 ml'
 WHERE slug = 'hyaluronic-fillers-1ml';

UPDATE medical_services SET
	name_de = 'Hydrozelenoperation'
 WHERE slug = 'hydrocele-surgery';

UPDATE medical_services SET
	name_de = 'Hydrotherapie: galvanisches Vierzellenbad'
 WHERE slug = 'hydrotherapy-galvanic-four-cell-bath';

UPDATE medical_services SET
	name_sr = 'Hiperbarična oksigenoterapija – jedan tretman u komori',
	name_sr_cyrl = 'Хипербарична оксигенотерапија – један третман у комори'
 WHERE slug = 'hyperbaric-oxygen-therapy-session';

UPDATE medical_services SET
	name_sr = 'Botox tretman hiperhidroze',
	name_sr_cyrl = 'Ботокс третман хиперхидрозе',
	name_de = 'Botox-Behandlung bei Hyperhidrose'
 WHERE slug = 'hyperhidrosis-botox-treatment';

UPDATE medical_services SET
	name_en = 'Hysteroscopy for Asherman Syndrome',
	name_sr = 'Histeroskopija (Ašermanov sindrom)',
	name_sr_cyrl = 'Хистероскопија (Ашерманов синдром)',
	name_de = 'Hysteroskopie bei Asherman-Syndrom',
	name_tr = 'Asherman Sendromunda Histeroskopi'
 WHERE slug = 'hysteroscopy-asherman-syndrome';

UPDATE medical_services SET
	name_de = 'Ilioinguinalis- oder Iliohypogastricus-Blockade'
 WHERE slug = 'ilioinguinal-or-iliohypogastric-block';

UPDATE medical_services SET
	name_de = 'Extraktion eines impaktierten Zahns'
 WHERE slug = 'impacted-tooth-extraction';

UPDATE medical_services SET
	name_sr = 'Metalokeramička krunica na implantu',
	name_sr_cyrl = 'Металокерамичка круница на импланту',
	name_ru = 'Металлокерамическая коронка на имплантате',
	name_de = 'Implantatkrone aus Metallkeramik',
	name_tr = 'İmplant Üzeri Metal Seramik Kron'
 WHERE slug = 'implant-crown-metal-ceramic';

UPDATE medical_services SET
	name_de = 'Implantat-Suprakonstruktion',
	name_tr = 'İmplant üst yapısı'
 WHERE slug = 'implant-suprastructure';

UPDATE medical_services SET
	name_ru = 'Кабинетное отбеливание зубов одной челюсти',
	name_tr = 'Tek çene ofis tipi diş beyazlatma'
 WHERE slug = 'in-office-teeth-whitening-single-arch';

UPDATE medical_services SET
	name_de = 'Operation einer eingeklemmten Hernie'
 WHERE slug = 'incarcerated-hernia-operation';

UPDATE medical_services SET
	name_en = 'Incision and Drainage of Furuncle, Carbuncle, Abscessed Cyst, Smaller Skin or Subcutaneous Abscess, Paronychia or Hematoma',
	name_sr = 'Incizija i drenaža furunkula, karbunkula, zagnojenih cista, manjeg kožnog ili potkožnog apscesa, paronihije ili hematoma',
	name_sr_cyrl = 'Инцизија и дренажа фурункула, карбункула, загнојених циста, мањег кожног или поткожног апсцеса, паронихије или хематома',
	name_ru = 'Вскрытие и дренирование фурункула, карбункула, нагноившейся кисты, небольшого кожного или подкожного абсцесса, паронихии или гематомы',
	name_de = 'Inzision und Drainage von Furunkel, Karbunkel, eitriger Zyste, kleinerem Haut- oder Unterhautabszess, Paronychie oder Hämatom',
	name_tr = 'Furonkül, karbonkül, iltihaplı kist, küçük cilt veya cilt altı apse, paronişi veya hematom insizyonu ve drenajı'
 WHERE slug = 'incision-and-drainage-of-furuncle-carbuncle-or-abscessed-cyst';

UPDATE medical_services SET
	name_en = 'Incision and Drainage of Larger Skin or Subcutaneous Abscess, Carbuncle, Phlegmon or Hematoma',
	name_sr = 'Incizija i drenaža većeg kožnog ili potkožnog apscesa, karbunkula, flegmone ili hematoma',
	name_sr_cyrl = 'Инцизија и дренажа већег кожног или поткожног апсцеса, карбункула, флегмоне или хематома',
	name_ru = 'Вскрытие и дренирование крупного кожного или подкожного абсцесса, карбункула, флегмоны или гематомы',
	name_de = 'Inzision und Drainage größerer Haut- oder Unterhautabszesse, Karbunkel, Phlegmonen oder Hämatome',
	name_tr = 'Büyük cilt veya cilt altı apse, karbonkül, flegmon veya hematom insizyonu ve drenajı'
 WHERE slug = 'incision-and-drainage-of-larger-skin-or-subcutaneous-abscess-carbuncle-or-hematoma';

UPDATE medical_services SET
	name_ru = 'Повторный осмотр грудного ребёнка в стационаре'
 WHERE slug = 'infant-follow-up-hospital-round';

UPDATE medical_services SET
	name_ru = 'Первичный осмотр грудного ребёнка в стационаре',
	name_de = 'Stationäre Aufnahmeuntersuchung des Säuglings'
 WHERE slug = 'infant-initial-hospital-workup';

UPDATE medical_services SET
	name_ru = 'Облучение инфракрасной, ультрафиолетовой лампой и лампой Биоптрон'
 WHERE slug = 'infrared-ultraviolet-and-bioptron-lamp-irradiation';

UPDATE medical_services SET
	name_de = 'Operation eines eingewachsenen Zehennagels'
 WHERE slug = 'ingrown-toenail-surgery';

UPDATE medical_services SET
	name_en = 'Inhaled Medication Administration',
	name_sr = 'Inhalaciona primjena lijeka',
	name_sr_cyrl = 'Инхалациона примјена лијека',
	name_ru = 'Ингаляционное введение препарата',
	name_de = 'Inhalative Medikamentenverabreichung'
 WHERE slug = 'inhalation-administration';

UPDATE medical_services SET
	name_sr = 'Prvi stomatološki pregled i otvaranje kartona',
	name_sr_cyrl = 'Први стоматолошки преглед и отварање картона',
	name_ru = 'Первичный стоматологический осмотр и оформление медицинской карты',
	name_de = 'Zahnärztliche Erstuntersuchung und Anlage der Patientenakte',
	name_tr = 'İlk diş muayenesi ve hasta dosyası açılması'
 WHERE slug = 'initial-dental-examination-and-medical-record-opening';

UPDATE medical_services SET
	name_ru = 'Первичный осмотр в стационаре',
	name_de = 'Stationäre Aufnahmeuntersuchung'
 WHERE slug = 'initial-hospital-workup';

UPDATE medical_services SET
	name_ru = 'Первичный осмотр принудительно госпитализированного пациента в стационаре',
	name_de = 'Stationäre Aufnahmeuntersuchung eines zwangseingewiesenen Patienten'
 WHERE slug = 'initial-hospital-workup-of-involuntarily-hospitalized-patient';

UPDATE medical_services SET
	name_en = 'Consumables for Injections',
	name_tr = 'Enjeksiyon sarf malzemesi'
 WHERE slug = 'injection-materials-consumption';

UPDATE medical_services SET
	name_ru = 'Аборт в стационаре',
	name_tr = 'Serviste abortus işlemi'
 WHERE slug = 'inpatient-abortion-procedure';

UPDATE medical_services SET
	name_ru = 'Осмотр интерниста с ЭКГ'
 WHERE slug = 'internist-examination-with-ecg';

UPDATE medical_services SET
	name_en = 'Intertrochanteric or Peritrochanteric Fracture (Open Reduction with Internal Fixation)',
	name_sr = 'Intertrohanterična ili peritrohanterična fraktura — otvorena repozicija sa unutrašnjom fiksacijom',
	name_sr_cyrl = 'Интертрохантерична или перитрохантерична фрактура — отворена репозиција са унутрашњом фиксацијом',
	name_ru = 'Открытая репозиция с внутренней фиксацией при межвертельном или чрезвертельном переломе',
	name_de = 'Offene Reposition mit innerer Fixation bei inter- oder peritrochantärer Fraktur',
	name_tr = 'İntertrokanterik veya peritrokanterik kırığın açık redüksiyonu ve iç fiksasyonu'
 WHERE slug = 'intertrochanteric-or-peritrochanteric-fracture';

UPDATE medical_services SET
	name_ru = 'Внутриартериальное введение препаратов через перфузор',
	name_de = 'Intraarterielle Medikamentengabe per Perfusor'
 WHERE slug = 'intra-arterial-therapy-via-perfusor';

UPDATE medical_services SET
	name_sr = 'Aplikacija lijeka intraartikularno',
	name_sr_cyrl = 'Апликација лијека интраартикуларно'
 WHERE slug = 'intra-articular-injection';

UPDATE medical_services SET
	name_en = 'Treatment of Intracerebral Hematoma',
	name_ru = 'Лечение интрацеребральной гематомы',
	name_de = 'Behandlung eines intrazerebralen Hämatoms',
	name_tr = 'İntraserebral hematom tedavisi'
 WHERE slug = 'intracerebral-hematoma';

UPDATE medical_services SET
	name_de = 'Augeninnendruckmessung'
 WHERE slug = 'intraocular-pressure-determination';

UPDATE medical_services SET
	name_sr = 'Incizija apscesa intraoralnim putem'
 WHERE slug = 'intraoral-abscess-incision';

UPDATE medical_services SET
	name_en = 'Intravitreal Drug Injection'
 WHERE slug = 'intravitreal-drug-application';

UPDATE medical_services SET
	name_de = 'Inzision und Drainage eines ischiorektalen Abszesses'
 WHERE slug = 'ischiorectal-abscess-incision-and-drainage';

UPDATE medical_services SET
	name_ru = 'Установка внутриматочной спирали (ВМС)',
	name_de = 'Einsetzen einer Intrauterinspirale (IUP)'
 WHERE slug = 'iud-insertion';

UPDATE medical_services SET
	name_ru = 'Удаление внутриматочной спирали (ВМС)',
	name_de = 'Entfernung einer Intrauterinspirale (IUP)'
 WHERE slug = 'iud-removal';

UPDATE medical_services SET
	name_sr = 'Anestezija u IVF postupku',
	name_sr_cyrl = 'Анестезија у ИВФ поступку',
	name_ru = 'Анестезия при ЭКО',
	name_de = 'Anästhesie bei IVF'
 WHERE slug = 'ivf-anesthesia';

UPDATE medical_services SET
	name_ru = 'Процедура Jalupro Super Hydro',
	name_de = 'Behandlung mit Jalupro Super Hydro',
	name_tr = 'Jalupro Super Hydro Tedavisi'
 WHERE slug = 'jalupro-super-hydro-treatment';

UPDATE medical_services SET
	name_en = 'Knee Arthrotomy (Capsulotomy) with Exploration, Drainage and Foreign Body Removal',
	name_ru = 'Артротомия (капсулотомия) коленного сустава с ревизией, дренированием и удалением инородного тела',
	name_de = 'Kniearthrotomie (Kapsulotomie) mit Exploration, Drainage und Fremdkörperentfernung',
	name_tr = 'Diz artrotomisi (kapsülotomi) — eksplorasyon, drenaj ve yabancı cisim çıkarılması'
 WHERE slug = 'knee-arthrotomy-capsulotomy-with-exploration-and-foreign-body-removal';

UPDATE medical_services SET
	name_ru = 'Репозиция вывиха коленного сустава (закрытая или открытая) с внутренней фиксацией или без',
	name_de = 'Reposition einer Knieluxation (geschlossen oder offen) mit oder ohne innere Fixation',
	name_tr = 'Diz dislokasyonu redüksiyonu (kapalı veya açık), iç fiksasyonlu veya fiksasyonsuz'
 WHERE slug = 'knee-dislocation-closed-or-open-reduction-withwithout-fixation';

UPDATE medical_services SET
	name_en = 'Lacrimal Duct Irrigation in Children'
 WHERE slug = 'lacrimal-duct-irrigation-children';

UPDATE medical_services SET
	name_en = 'Lacrimal Duct Irrigation and Probing in Children under General Anesthesia',
	name_ru = 'Промывание и зондирование слёзных путей у детей под общей анестезией',
	name_de = 'Tränenwegsspülung und -sondierung bei Kindern in Vollnarkose',
	name_tr = 'Çocuklarda Genel Anestezi Altında Gözyaşı Kanalı Yıkama ve Sondalama'
 WHERE slug = 'lacrimal-duct-probing-children-general-anesthesia';

UPDATE medical_services SET
	name_sr = 'Laparoskopska salpingo-ooforektomija',
	name_sr_cyrl = 'Лапароскопска салпинго-оофоректомија'
 WHERE slug = 'laparoscopic-salpingo-oophorectomy';

UPDATE medical_services SET
	name_sr = 'Laserska operacija proširenih vena',
	name_sr_cyrl = 'Ласерска операција проширених вена'
 WHERE slug = 'laser-varicose-vein-surgery';

UPDATE medical_services SET
	name_sr = 'Lateralna ili medijalna fasciotomija (npr. epikondilitis, teniski lakat)',
	name_sr_cyrl = 'Латерална или медијална фасциотомија (нпр. епикондилитис, тениски лакат)'
 WHERE slug = 'lateral-or-medial-fasciotomy-tennis-elbow';

UPDATE medical_services SET
	name_ru = 'Ревизия сосудов нижних конечностей',
	name_tr = 'Bacak damarları eksplorasyonu'
 WHERE slug = 'leg-vessels-exploration';

UPDATE medical_services SET
	name_en = 'Liver Biopsy under Local Anesthesia'
 WHERE slug = 'liver-biopsy-local-anesthesia';

UPDATE medical_services SET
	name_sr = 'Repozicija — Lorencov gips',
	name_sr_cyrl = 'Репозиција — Лоренцов гипс'
 WHERE slug = 'lorenz-cast-reduction';

UPDATE medical_services SET
	name_ru = 'Первичный шов одного или нескольких сухожилий сгибателей голени',
	name_de = 'Primäre Beugesehnennaht am Unterschenkel (eine oder mehrere Sehnen)',
	name_tr = 'Alt bacak fleksör tendon primer onarımı (bir veya daha fazla)'
 WHERE slug = 'lower-leg-flexor-tendon-primary-repair-one-or-more';

UPDATE medical_services SET
	name_tr = 'Lenf düğümü biyopsisi veya eksizyonu'
 WHERE slug = 'lymph-node-biopsy-or-excision';

UPDATE medical_services SET
	name_en = 'Complete Lymphatic Drainage',
	name_de = 'Vollständige Lymphdrainage'
 WHERE slug = 'lymphatic-drainage-complete';

UPDATE medical_services SET
	name_en = 'Rotary Root Canal Treatment per Canal',
	name_sr = 'Mašinsko liječenje kanala korijena (po kanalu)',
	name_sr_cyrl = 'Машинско лијечење канала коријена (по каналу)',
	name_tr = 'Döner aletle kök kanal tedavisi kanal başına'
 WHERE slug = 'machine-root-canal-treatment-per-canal';

UPDATE medical_services SET
	name_sr = 'Magnetoterapija',
	name_sr_cyrl = 'Магнетотерапија'
 WHERE slug = 'magnetic-therapy';

UPDATE medical_services SET
	name_de = 'Größere Lokalanästhesie'
 WHERE slug = 'major-local-anesthesia';

UPDATE medical_services SET
	name_ru = 'Закрытое вправление вывиха голеностопного сустава',
	name_de = 'Manipulative Reposition einer Sprunggelenksluxation'
 WHERE slug = 'manipulative-reduction-of-ankle-joint-dislocation';

UPDATE medical_services SET
	name_ru = 'Закрытая репозиция открытого перелома пяточной кости',
	name_de = 'Manipulative Reposition einer offenen Calcaneusfraktur'
 WHERE slug = 'manipulative-reduction-of-open-calcaneus-fracture';

UPDATE medical_services SET
	name_en = 'Manipulative Reduction of Open Distal Tibia (Medial Malleolus) Fracture',
	name_sr = 'Manipulativna repozicija otvorene frakture distalnog dijela potkoljenice (medijalnog maleolusa)',
	name_sr_cyrl = 'Манипулативна репозиција отворене фрактуре дисталног дијела поткољенице (медијалног малеолуса)',
	name_ru = 'Закрытая репозиция открытого перелома дистальной части голени (внутренней лодыжки)',
	name_de = 'Manipulative Reposition einer offenen distalen Tibiafraktur (Innenknöchel)',
	name_tr = 'Açık distal tibia (medial malleol) kırığı manipülatif redüksiyonu'
 WHERE slug = 'manipulative-reduction-of-open-distal-fracture';

UPDATE medical_services SET
	name_en = 'Manipulative Reduction of Open Distal Fibula Fracture',
	name_sr = 'Manipulativna repozicija otvorene frakture distalnog dijela fibule',
	name_sr_cyrl = 'Манипулативна репозиција отворене фрактуре дисталног дијела фибуле',
	name_ru = 'Закрытая репозиция открытого перелома дистальной части малоберцовой кости',
	name_de = 'Manipulative Reposition einer offenen distalen Fibulafraktur',
	name_tr = 'Açık distal fibula kırığı manipülatif redüksiyonu'
 WHERE slug = 'manipulative-reduction-of-open-distal-fracture-variant';

UPDATE medical_services SET
	name_en = 'Manipulative Reduction of Open Fibula Fracture (Shaft or Proximal)',
	name_sr = 'Manipulativna repozicija otvorene frakture fibule (dijafiza ili proksimalni dio)',
	name_sr_cyrl = 'Манипулативна репозиција отворене фрактуре фибуле (дијафиза или проксимални дио)',
	name_ru = 'Закрытая репозиция открытого перелома диафиза или проксимальной части малоберцовой кости',
	name_de = 'Manipulative Reposition einer offenen Fibulafraktur (Schaft oder proximal)',
	name_tr = 'Açık fibula kırığı manipülatif redüksiyonu (diyafiz veya proksimal)'
 WHERE slug = 'manipulative-reduction-of-open-fibula-fracture';

UPDATE medical_services SET
	name_en = 'Manipulative Reduction of Open Iliac, Pubic or Ischial Fracture',
	name_sr = 'Manipulativna repozicija otvorene frakture ilijačne, pubične i sjedalne kosti',
	name_sr_cyrl = 'Манипулативна репозиција отворене фрактуре илијачне, пубичне и сједалне кости',
	name_ru = 'Закрытая репозиция открытого перелома подвздошной, лобковой или седалищной кости',
	name_de = 'Manipulative Reposition einer offenen Darmbein-, Schambein- oder Sitzbeinfraktur',
	name_tr = 'Açık iliak, pubik veya iskiyal kırık manipülatif redüksiyonu'
 WHERE slug = 'manipulative-reduction-of-open-iliacpubic-fracture';

UPDATE medical_services SET
	name_ru = 'Мануальное мышечное тестирование одной конечности'
 WHERE slug = 'manual-muscle-test-per-extremity';

UPDATE medical_services SET
	name_sr = 'Fraktura medijalnog ili lateralnog epikondila — otvorena (složena), sa Kiršnerovom iglom ili pločom',
	name_sr_cyrl = 'Фрактура медијалног или латералног епикондила — отворена (сложена), са Киршнеровом иглом или плочом',
	name_ru = 'Репозиция открытого перелома медиального или латерального надмыщелка с фиксацией спицей Киршнера или пластиной',
	name_de = 'Reposition einer offenen medialen oder lateralen Epikondylenfraktur mit Kirschner-Draht oder Platte',
	name_tr = 'Açık medial veya lateral epikondil kırığı redüksiyonu (Kirschner teli veya plak ile)'
 WHERE slug = 'medial-or-lateral-epicondyle-fracture-open-with-k-wire-or-plate';

UPDATE medical_services SET
	name_en = 'Medial or Lateral Femoral Condyle Fracture (Open Reduction with/without Fixation)',
	name_sr = 'Fraktura medijalnog ili lateralnog kondila femura — zatvorena ili otvorena, otvorena repozicija sa/bez fiksacije',
	name_sr_cyrl = 'Фрактура медијалног или латералног кондила фемура — затворена или отворена, отворена репозиција са/без фиксације',
	name_ru = 'Открытая репозиция закрытого или открытого перелома медиального или латерального мыщелка бедра с фиксацией или без',
	name_de = 'Offene Reposition einer geschlossenen oder offenen Femurkondylenfraktur (medial oder lateral) mit oder ohne Fixation',
	name_tr = 'Kapalı veya açık medial ya da lateral femur kondil kırığının açık redüksiyonu, fiksasyonlu veya fiksasyonsuz'
 WHERE slug = 'medial-or-lateral-femoral-condyle-fracture-open-reduction';

UPDATE medical_services SET
	name_sr = 'Ljekarsko uvjerenje o podobnosti za usvajanje djeteta',
	name_sr_cyrl = 'Љекарско увјерење о подобности за усвајање дјетета'
 WHERE slug = 'medical-certificate-for-child-adoption';

UPDATE medical_services SET
	name_sr = 'Ljekarsko uvjerenje za otežane uslove rada bez povećanog rizika',
	name_sr_cyrl = 'Љекарско увјерење за отежане услове рада без повећаног ризика'
 WHERE slug = 'medical-certificate-for-difficult-working-conditions-without-high-risk';

UPDATE medical_services SET
	name_sr = 'Ljekarsko uvjerenje za posao instruktora vožnje B, C, D i E kategorije',
	name_sr_cyrl = 'Љекарско увјерење за посао инструктора вожње Б, Ц, Д и Е категорије',
	name_de = 'Ärztliches Attest für Fahrlehrer der Klassen B, C, D, E',
	name_tr = 'B, C, D, E Sınıfı Sürücü Eğitmeni İçin Sağlık Raporu'
 WHERE slug = 'medical-certificate-for-driving-instructor-category-b-c-d-e';

UPDATE medical_services SET
	name_de = 'Ärztliches Attest für den Führerschein der Klassen A, B, C, D, E',
	name_tr = 'A, B, C, D, E Sınıfı Sürücü Belgesi İçin Sağlık Raporu'
 WHERE slug = 'medical-certificate-for-driving-license-category-a-b-c-d-e';

UPDATE medical_services SET
	name_de = 'Ärztliches Attest für die Führerscheinverlängerung der Klassen A, B, C, D, E',
	name_tr = 'A, B, C, D, E Sınıfı Sürücü Belgesi Yenileme İçin Sağlık Raporu'
 WHERE slug = 'medical-certificate-for-driving-license-renewal-category-a-b-c-d-e';

UPDATE medical_services SET
	name_ru = 'Медицинская справка для работы в обычных условиях'
 WHERE slug = 'medical-certificate-for-general-work';

UPDATE medical_services SET
	name_ru = 'Медицинская справка для работы с повышенным риском и в тяжёлых условиях труда'
 WHERE slug = 'medical-certificate-for-high-risk-and-difficult-working-conditions';

UPDATE medical_services SET
	name_de = 'Ärztliches Attest für die Aufnahme in eine weiterführende Schule'
 WHERE slug = 'medical-certificate-for-secondary-school-enrollment';

UPDATE medical_services SET
	name_sr = 'Ljekarsko uvjerenje za upravljanje taksi vozilom'
 WHERE slug = 'medical-certificate-for-taxi-driver';

UPDATE medical_services SET
	name_tr = 'Reşit Olmayanların Evlenmesi İçin Sağlık Raporu'
 WHERE slug = 'medical-certificate-for-underage-marriage';

UPDATE medical_services SET
	name_sr = 'Zatvorena manipulativna repozicija frakture metakarpalnih kostiju',
	name_sr_cyrl = 'Затворена манипулативна репозиција фрактуре метакарпалних костију',
	name_ru = 'Закрытая репозиция перелома пястных костей',
	name_tr = 'Metakarpal kırık kapalı manipülatif redüksiyonu'
 WHERE slug = 'metacarpal-fracture-manipulation-reduction';

UPDATE medical_services SET
	name_sr = 'Metalokeramička krunica na zlatu',
	name_sr_cyrl = 'Металокерамичка круница на злату',
	name_ru = 'Металлокерамическая коронка на золоте',
	name_de = 'Metallkeramikkrone auf Goldbasis',
	name_tr = 'Altın Alaşımlı Metal Seramik Kron'
 WHERE slug = 'metal-ceramic-crown-gold';

UPDATE medical_services SET
	name_ru = 'Ампутация плюсневой кости с одним или несколькими пальцами',
	name_de = 'Metatarsalamputation mit einer oder mehreren Zehen',
	name_tr = 'Bir veya daha fazla parmakla metatars amputasyonu'
 WHERE slug = 'metatarsal-amputation-with-one-or-more-toes';

UPDATE medical_services SET
	name_ru = 'Закрытая репозиция перелома плюсневых костей',
	name_tr = 'Metatarsal kırık kapalı manipülatif redüksiyonu'
 WHERE slug = 'metatarsal-fracture-manipulation-reduction';

UPDATE medical_services SET
	name_ru = 'Репозиция вывиха плюснефалангового сустава (закрытая или открытая)'
 WHERE slug = 'metatarsophalangeal-joint-dislocation-reduction';

UPDATE medical_services SET
	name_ru = 'Брюшно-промежностная экстирпация прямой кишки (операция Майлса)'
 WHERE slug = 'miles-rectal-amputation';

UPDATE medical_services SET
	name_de = 'Reposition mit Minerva-Gips',
	name_tr = 'Minerva alçısı ile redüksiyon'
 WHERE slug = 'minerva-plaster-cast-reduction';

UPDATE medical_services SET
	name_de = 'Kleinere Lokalanästhesie'
 WHERE slug = 'minor-local-anesthesia';

UPDATE medical_services SET
	name_en = 'Closed Reduction of Monteggia Elbow Fracture (Proximal Ulna with Radial Head Dislocation)',
	name_sr = 'Fraktura lakta, Monteggia tip (proksimalni kraj ulne sa dislokacijom glave radiusa) — zatvorena manipulativna repozicija',
	name_sr_cyrl = 'Фрактура лакта, Monteggia тип (проксимални крај улне са дислокацијом главе радиуса) — затворена манипулативна репозиција',
	name_ru = 'Закрытая репозиция перелома Монтеджи (проксимальный отдел локтевой кости с вывихом головки лучевой кости)',
	name_de = 'Geschlossene Reposition einer Monteggia-Fraktur (proximale Ulnafraktur mit Radiusköpfchenluxation)',
	name_tr = 'Monteggia tipi dirsek kırığı kapalı redüksiyonu (radius başı dislokasyonlu proksimal ulna kırığı)'
 WHERE slug = 'monteggia-elbow-fracture-proximal-end';

UPDATE medical_services SET
	name_de = 'MSCT-Angiographie der Aorta',
	name_tr = 'MSCT aort anjiyografisi'
 WHERE slug = 'msct-angiography-aorta';

UPDATE medical_services SET
	name_de = 'MSCT-Angiographie der Kopf- und Halsgefäße',
	name_tr = 'MSCT baş ve boyun damarları anjiyografisi'
 WHERE slug = 'msct-angiography-head-and-neck-vessels';

UPDATE medical_services SET
	name_ru = 'Кальциевый индекс коронарных артерий (КТ)'
 WHERE slug = 'msct-calcium-score';

UPDATE medical_services SET
	name_en = 'MSCT Head and Neck without Contrast',
	name_ru = 'КТ головы и шеи без контраста'
 WHERE slug = 'msct-head-and-neck-native';

UPDATE medical_services SET
	name_ru = 'МСКТ головного мозга с контрастом'
 WHERE slug = 'msct-head-endocranium-with-contrast';

UPDATE medical_services SET
	name_ru = 'МСКТ головного мозга без контраста'
 WHERE slug = 'msct-head-endocranium-without-contrast';

UPDATE medical_services SET
	name_sr = 'MSCT IVU (intravenska urografija)',
	name_sr_cyrl = 'МСКТ ИВУ (интравенска урографија)',
	name_ru = 'МСКТ внутривенная урография'
 WHERE slug = 'msct-ivu-intravenous-urography';

UPDATE medical_services SET
	name_en = 'MSCT Single Region without Contrast',
	name_sr = 'CT jedne regije nativno',
	name_sr_cyrl = 'ЦТ једне регије нативно',
	name_ru = 'КТ одной области без контраста',
	name_de = 'CT einer Region nativ'
 WHERE slug = 'msct-single-region-native';

UPDATE medical_services SET
	name_sr = 'CT jedne regije sa kontrastom',
	name_sr_cyrl = 'ЦТ једне регије са контрастом',
	name_ru = 'КТ одной области с контрастом',
	name_de = 'CT einer Region mit Kontrastmittel'
 WHERE slug = 'msct-single-region-with-contrast';

UPDATE medical_services SET
	name_sr = 'MSCT pregled toraksa (grudnog koša) sa kontrastom',
	name_sr_cyrl = 'МСКТ преглед торакса (грудног коша) са контрастом'
 WHERE slug = 'msct-thorax-chest-with-contrast';

UPDATE medical_services SET
	name_sr = 'MSCT pregled toraksa (grudnog koša) bez kontrasta',
	name_sr_cyrl = 'МСКТ преглед торакса (грудног коша) без контраста'
 WHERE slug = 'msct-thorax-chest-without-contrast';

UPDATE medical_services SET
	name_en = 'Multiple Bilateral Thoracocentesis in Severe Chest Injuries',
	name_sr = 'Torakocenteza, multiple bilateralne punkcije kod težih povreda grudnog koša',
	name_sr_cyrl = 'Торакоцентеза, мултипле билатералне пункције код тежих повреда грудног коша',
	name_ru = 'Многократный двусторонний торакоцентез при тяжёлых травмах грудной клетки',
	name_de = 'Mehrfache beidseitige Thorakozentese bei schweren Thoraxverletzungen',
	name_tr = 'Ağır göğüs travmasında çift taraflı çoklu torasentez'
 WHERE slug = 'multiple-bilateral-thoracocentesis';

UPDATE medical_services SET
	name_ru = 'Тенолизис нескольких разгибателей стопы (через один разрез)',
	name_de = 'Multiple Strecker-Tenolyse am Fuß (über denselben Schnitt)',
	name_tr = 'Ayakta çoklu ekstansör tenolizi (aynı kesiden)'
 WHERE slug = 'multiple-foot-extensor-tenolysis-same-incision';

UPDATE medical_services SET
	name_ru = 'Тенолизис нескольких сгибателей стопы (через один разрез)',
	name_de = 'Multiple Beuger-Tenolyse am Fuß (über denselben Schnitt)',
	name_tr = 'Ayakta çoklu fleksör tenolizi (aynı kesiden)'
 WHERE slug = 'multiple-foot-flexor-tenolysis-same-incision';

UPDATE medical_services SET
	name_en = 'Multiple Unilateral Thoracocentesis in Severe Chest Injuries',
	name_sr = 'Torakocenteza, multiple unilateralne punkcije kod težih povreda grudnog koša',
	name_sr_cyrl = 'Торакоцентеза, мултипле унилатералне пункције код тежих повреда грудног коша',
	name_ru = 'Многократный односторонний торакоцентез при тяжёлых травмах грудной клетки',
	name_de = 'Mehrfache einseitige Thorakozentese bei schweren Thoraxverletzungen',
	name_tr = 'Ağır göğüs travmasında tek taraflı çoklu torasentez'
 WHERE slug = 'multiple-unilateral-thoracocentesis';

UPDATE medical_services SET
	name_de = 'Anlage/Entfernung einer nasogastralen oder orogastralen Sonde mit Lavage'
 WHERE slug = 'nasogastric-or-orogastric-tube-placement-with-lavage';

UPDATE medical_services SET
	name_de = 'Anlage einer nasogastralen Sonde'
 WHERE slug = 'nasogastric-tube-placement';

UPDATE medical_services SET
	name_en = 'Navicular Pseudarthrosis Repair with/without Radial Styloidectomy, Including Bone Graft and Fixation',
	name_sr = 'Reparacija pseudoartroze navikularne kosti sa ili bez stiloidektomije radiusa, uključujući koštani kalem i fiksaciju',
	name_sr_cyrl = 'Репарација псеудоартрозе навикуларне кости са или без стилоидектомије радиуса, укључујући коштани калем и фиксацију',
	name_ru = 'Лечение псевдоартроза ладьевидной кости с костной пластикой и фиксацией, со стилоидэктомией лучевой кости или без',
	name_de = 'Operation einer Kahnbeinpseudarthrose mit oder ohne Styloidektomie des Radius, einschließlich Knochentransplantat und Fixation',
	name_tr = 'Naviküler psödoartroz onarımı, radius stiloidektomili veya stiloidektomisiz (kemik grefti ve fiksasyon dahil)'
 WHERE slug = 'navicular-pseudarthrosis-repair-withwithout-bone-graft';

UPDATE medical_services SET
	name_en = 'Neck Ultrasound (Salivary Glands)',
	name_sr = 'Ultrazvuk vrata (pljuvačne žlijezde)',
	name_sr_cyrl = 'Ултразвук врата (пљувачне жлијезде)',
	name_ru = 'УЗИ слюнных желёз',
	name_de = 'Ultraschall der Speicheldrüsen'
 WHERE slug = 'neck-ultrasound-salivary-glands';

UPDATE medical_services SET
	name_tr = 'Fantom ağrısı için nörom çıkarımı'
 WHERE slug = 'neuroma-removal-for-phantom-pain';

UPDATE medical_services SET
	name_ru = 'Первичный осмотр новорождённого в стационаре',
	name_de = 'Stationäre Aufnahmeuntersuchung des Neugeborenen'
 WHERE slug = 'newborn-initial-hospital-workup';

UPDATE medical_services SET
	name_sr = 'Obična njega novorođenčeta',
	name_sr_cyrl = 'Обична њега новорођенчета',
	name_ru = 'Обычный уход за новорождённым'
 WHERE slug = 'newborn-standard-nursing-care';

UPDATE medical_services SET
	name_en = 'Non-Medical Bed-Day Costs in General and Special Hospitals',
	name_ru = 'Немедицинская часть стоимости койко-дня в общих и специальных больницах',
	name_de = 'Nichtmedizinischer Kostenanteil des Pflegetags in Allgemein- und Fachkrankenhäusern',
	name_tr = 'Genel ve dal hastanelerinde yatak gününün tıbbi olmayan maliyeti'
 WHERE slug = 'non-medical-bed-day-cost-general-and-special-hospitals';

UPDATE medical_services SET
	name_en = 'Non-Medical Bed-Day Costs in Intensive Care, Coronary Care and Neonatal Units',
	name_ru = 'Немедицинская часть стоимости койко-дня в реанимации, кардиоблоке и неонатологии',
	name_de = 'Nichtmedizinischer Kostenanteil des Pflegetags auf Intensiv- und Koronarstation und in der Neonatologie',
	name_tr = 'Yoğun bakım, koroner bakım ve yenidoğan ünitelerinde yatak gününün tıbbi olmayan maliyeti'
 WHERE slug = 'non-medical-bed-day-cost-intensive-coronary-and-neonatal';

UPDATE medical_services SET
	name_ru = 'Сестринский выписной эпикриз',
	name_tr = 'Hemşirelik taburcu epikrizi'
 WHERE slug = 'nursing-care-discharge-letter';

UPDATE medical_services SET
	name_en = 'On-Call Specialist Examination',
	name_ru = 'Осмотр дежурного врача-специалиста',
	name_de = 'Fachärztliche Untersuchung durch den Bereitschaftsarzt',
	name_tr = 'Nöbetçi uzman hekim muayenesi'
 WHERE slug = 'on-call-doctor-specialist-examination';

UPDATE medical_services SET
	name_ru = 'Открытая тенотомия сгибателей нескольких пальцев'
 WHERE slug = 'open-flexor-tenotomy-of-multiple-fingers';

UPDATE medical_services SET
	name_ru = 'Открытая тенотомия нескольких сгибателей (через один разрез)',
	name_de = 'Offene Beuger-Tenotomie mehrerer Sehnen (über denselben Schnitt)',
	name_tr = 'Çoklu fleksör tenotomi (açık, aynı kesiden)'
 WHERE slug = 'open-flexor-tenotomy-of-multiple-tendons-same-incision';

UPDATE medical_services SET
	name_sr = 'Tenotomija fleksora, otvorena, jedan ili više prstiju',
	name_sr_cyrl = 'Тенотомија флексора, отворена, један или више прстију',
	name_ru = 'Открытая тенотомия сгибателей одного или нескольких пальцев',
	name_de = 'Offene Beuger-Tenotomie an einem oder mehreren Fingern',
	name_tr = 'Bir veya daha fazla parmakta açık fleksör tenotomi'
 WHERE slug = 'open-flexor-tenotomy-of-one-or-more-fingers';

UPDATE medical_services SET
	name_en = 'Open Reduction of Patellar Fracture with Repair and/or Excision',
	name_ru = 'Открытая репозиция перелома надколенника с восстановлением и/или иссечением',
	name_de = 'Offene Reposition einer Patellafraktur mit Rekonstruktion und/oder Exzision',
	name_tr = 'Patella kırığı açık redüksiyonu, onarım ve/veya eksizyon ile'
 WHERE slug = 'open-reduction-of-patellar-fracture-with-repair';

UPDATE medical_services SET
	name_en = 'Reduction of Open Radius and Ulna Diaphysis Fracture with Fixation and Soft Tissue Closure',
	name_sr = 'Fraktura dijafize radiusa i ulne — otvorena (složena), sa prostim zatvaranjem mekog tkiva, manipulativna repozicija sa fiksacijom',
	name_sr_cyrl = 'Фрактура дијафизе радиуса и улне — отворена (сложена), са простим затварањем меког ткива, манипулативна репозиција са фиксацијом',
	name_ru = 'Репозиция открытого перелома диафиза лучевой и локтевой костей с фиксацией и ушиванием мягких тканей',
	name_de = 'Reposition einer offenen Radius-Ulna-Diaphysenfraktur mit Fixation und Weichteilverschluss',
	name_tr = 'Açık radius-ulna diyafiz kırığı redüksiyonu, fiksasyon ve yumuşak doku kapatılması ile'
 WHERE slug = 'open-reduction-of-radius-and-ulna-diaphysis-fracture';

UPDATE medical_services SET
	name_en = 'Operating Theatre Costs in General Hospitals (Operations of 121 to 180 Points)',
	name_sr = 'Troškovi operacione sale u opštim bolnicama (operacije od 121 do 180 bodova)',
	name_sr_cyrl = 'Трошкови операционе сале у општим болницама (операције од 121 до 180 бодова)',
	name_ru = 'Расходы на операционную в общих больницах (операции от 121 до 180 баллов)',
	name_de = 'Operationssaalkosten in Allgemeinkrankenhäusern (Operationen mit 121 bis 180 Punkten)',
	name_tr = 'Genel hastanelerde ameliyathane maliyeti (121-180 puanlık ameliyatlar)'
 WHERE slug = 'operating-theatre-costs-tier-i-121-to-180-points';

UPDATE medical_services SET
	name_en = 'Operating Theatre Costs in General Hospitals (Operations of 21 to 50 Points)',
	name_sr = 'Troškovi operacione sale u opštim bolnicama (operacije od 21 do 50 bodova)',
	name_sr_cyrl = 'Трошкови операционе сале у општим болницама (операције од 21 до 50 бодова)',
	name_ru = 'Расходы на операционную в общих больницах (операции от 21 до 50 баллов)',
	name_de = 'Operationssaalkosten in Allgemeinkrankenhäusern (Operationen mit 21 bis 50 Punkten)',
	name_tr = 'Genel hastanelerde ameliyathane maliyeti (21-50 puanlık ameliyatlar)'
 WHERE slug = 'operating-theatre-costs-tier-i-21-to-50-points';

UPDATE medical_services SET
	name_en = 'Operating Theatre Costs in General Hospitals (Operations of 5 to 20 Points)',
	name_sr = 'Troškovi operacione sale u opštim bolnicama (operacije od 5 do 20 bodova)',
	name_sr_cyrl = 'Трошкови операционе сале у општим болницама (операције од 5 до 20 бодова)',
	name_ru = 'Расходы на операционную в общих больницах (операции от 5 до 20 баллов)',
	name_de = 'Operationssaalkosten in Allgemeinkrankenhäusern (Operationen mit 5 bis 20 Punkten)',
	name_tr = 'Genel hastanelerde ameliyathane maliyeti (5-20 puanlık ameliyatlar)'
 WHERE slug = 'operating-theatre-costs-tier-i-5-to-20-points';

UPDATE medical_services SET
	name_en = 'Operating Theatre Costs in General Hospitals (Operations of 51 to 120 Points)',
	name_sr = 'Troškovi operacione sale u opštim bolnicama (operacije od 51 do 120 bodova)',
	name_sr_cyrl = 'Трошкови операционе сале у општим болницама (операције од 51 до 120 бодова)',
	name_ru = 'Расходы на операционную в общих больницах (операции от 51 до 120 баллов)',
	name_de = 'Operationssaalkosten in Allgemeinkrankenhäusern (Operationen mit 51 bis 120 Punkten)',
	name_tr = 'Genel hastanelerde ameliyathane maliyeti (51-120 puanlık ameliyatlar)'
 WHERE slug = 'operating-theatre-costs-tier-i-51-to-120-points';

UPDATE medical_services SET
	name_en = 'Operating Theatre Costs in Clinical Centre and Special Hospitals (Operations of 21 to 50 Points)',
	name_sr = 'Troškovi operacionog bloka Kliničkog centra i specijalnih bolnica (operacije od 21 do 50 bodova)',
	name_sr_cyrl = 'Трошкови операционог блока Клиничког центра и специјалних болница (операције од 21 до 50 бодова)',
	name_ru = 'Расходы на операционный блок Клинического центра и специальных больниц (операции от 21 до 50 баллов)',
	name_de = 'Operationssaalkosten im Klinischen Zentrum und in Fachkrankenhäusern (Operationen mit 21 bis 50 Punkten)',
	name_tr = 'Klinik Merkez ve dal hastanelerinde ameliyathane maliyeti (21-50 puanlık ameliyatlar)'
 WHERE slug = 'operating-theatre-costs-tier-ii-21-to-50-points';

UPDATE medical_services SET
	name_en = 'Large Surgical Dressing'
 WHERE slug = 'operation-large-dressing';

UPDATE medical_services SET
	name_en = 'Medium Surgical Dressing I'
 WHERE slug = 'operation-medium-dressing-i';

UPDATE medical_services SET
	name_en = 'Medium Surgical Dressing II'
 WHERE slug = 'operation-medium-dressing-ii';

UPDATE medical_services SET
	name_en = 'Small Surgical Dressing II'
 WHERE slug = 'operation-small-dressing-ii';

UPDATE medical_services SET
	name_ru = 'УЗИ глаза (A-скан и B-скан)',
	name_tr = 'Göz ultrasonu (A-scan ve B-scan)'
 WHERE slug = 'ophthalmic-ultrasound-a-scan-and-b-scan';

UPDATE medical_services SET
	name_en = 'Ophthalmological Examination for Soft Contact Lenses',
	name_ru = 'Офтальмологический осмотр для мягких контактных линз',
	name_de = 'Ophthalmologische Untersuchung für weiche Kontaktlinsen',
	name_tr = 'Yumuşak Kontakt Lens için Oftalmoloji Muayenesi'
 WHERE slug = 'ophthalmological-examination-contact-lenses';

UPDATE medical_services SET
	name_de = 'Kieferorthopädischer Retainer'
 WHERE slug = 'orthodontic-retainer';

UPDATE medical_services SET
	name_en = 'Orthopedic Ultrasound, Single Joint',
	name_sr = 'Ultrazvuk jednog zgloba',
	name_sr_cyrl = 'Ултразвук једног зглоба',
	name_de = 'Orthopädischer Ultraschall eines Gelenks',
	name_tr = 'Tek Eklem Ortopedik Ultrasonu'
 WHERE slug = 'orthopedic-ultrasound-single-joint';

UPDATE medical_services SET
	name_de = 'Ohrenkorrektur (Otoplastik)'
 WHERE slug = 'otoplasty';

UPDATE medical_services SET
	name_de = 'Prothese auf Mini-Implantaten'
 WHERE slug = 'overdenture-on-mini-implants';

UPDATE medical_services SET
	name_en = 'Whipple Procedure for Pancreatic Head Carcinoma',
	name_sr = 'Duodenopankreatektomija (Whipple) kod karcinoma glave pankreasa',
	name_sr_cyrl = 'Дуоденопанкреатектомија (Whipple) код карцинома главе панкреаса',
	name_ru = 'Операция Уиппла при раке головки поджелудочной железы',
	name_de = 'Whipple-Operation bei Pankreaskopfkarzinom',
	name_tr = 'Pankreas Başı Karsinomunda Whipple Ameliyatı'
 WHERE slug = 'pancreatic-head-carcinoma-whipple';

UPDATE medical_services SET
	name_tr = 'Panoramik çene röntgeni'
 WHERE slug = 'panoramic-jaw-x-ray';

UPDATE medical_services SET
	name_ru = 'ПАП-тест методом жидкостной цитологии (LBC)'
 WHERE slug = 'pap-test-liquid-cytology';

UPDATE medical_services SET
	name_de = 'Röntgen der Nasennebenhöhlen pro Aufnahme',
	name_tr = 'Paranazal sinüs röntgeni (çekim başına)'
 WHERE slug = 'paranasal-sinus-x-ray-per-image';

UPDATE medical_services SET
	name_en = 'Superficial Partial Bone Excision for Osteomyelitis (Curettage, Sequestrectomy or Diaphysectomy)',
	name_sr = 'Parcijalna ekscizija kosti (kiretaža, sekvestracija ili dijafizektomija) kod osteomijelitisa, superficijalno',
	name_sr_cyrl = 'Парцијална ексцизија кости (киретажа, секвестрација или дијафизектомија) код остеомијелитиса, суперфицијално',
	name_ru = 'Поверхностная частичная резекция кости (кюретаж, секвестрэктомия или диафизэктомия) при остеомиелите',
	name_de = 'Oberflächliche partielle Knochenexzision (Kürettage, Sequestrektomie oder Diaphysektomie) bei Osteomyelitis',
	name_tr = 'Osteomiyelitte yüzeyel parsiyel kemik eksizyonu (küretaj, sekestrektomi veya diyafizektomi)'
 WHERE slug = 'partial-bone-excision-curettage-sequestrectomy-or';

UPDATE medical_services SET
	name_ru = 'Частичная фасциэктомия при контрактуре Дюпюитрена'
 WHERE slug = 'partial-dupuytren-fasciectomy';

UPDATE medical_services SET
	name_de = 'Flexible Teilprothese'
 WHERE slug = 'partial-flexible-denture';

UPDATE medical_services SET
	name_ru = 'Пассивные упражнения и упражнения с помощью'
 WHERE slug = 'passive-and-assisted-exercises';

UPDATE medical_services SET
	name_ru = 'Репозиция вывиха надколенника (закрытая или открытая)',
	name_de = 'Reposition einer Patellaluxation (geschlossen oder offen)',
	name_tr = 'Patella dislokasyonu redüksiyonu (kapalı veya açık)'
 WHERE slug = 'patellar-dislocation-closed-or-open-reduction';

UPDATE medical_services SET
	name_en = 'Patent Ductus Arteriosus Closure (Porstmann Method)',
	name_sr = 'Zatvaranje otvorenog ductus Botalli (po Porstmannu)',
	name_sr_cyrl = 'Затварање отвореног дуцтус Botalli (по Porstmannu)',
	name_ru = 'Закрытие открытого Боталлова протока (по Порстману)',
	name_de = 'Verschluss des offenen Ductus Botalli (nach Porstmann)',
	name_tr = 'Açık duktus arteriyozus kapatılması (Porstmann yöntemi)'
 WHERE slug = 'patent-ductus-arteriosus-closure-portsmann-method';

UPDATE medical_services SET
	name_en = 'Drainage Check of Pathological Fluid Collections, Biliary Tract and Nephrostomy',
	name_sr = 'Kontrola drenaže patoloških tečnih kolekcija, bilijarnih puteva i nefrostome',
	name_sr_cyrl = 'Контрола дренаже патолошких течних колекција, билијарних путева и нефростоме',
	name_ru = 'Контроль дренажа патологических жидкостных скоплений, желчных путей и нефростомы',
	name_de = 'Drainagekontrolle bei pathologischen Flüssigkeitsansammlungen, Gallenwegen und Nephrostomie',
	name_tr = 'Patolojik sıvı kolleksiyonu, safra yolu ve nefrostomi drenaj kontrolü'
 WHERE slug = 'pathological-fluid-collection-and-biliary-drainage-control';

UPDATE medical_services SET
	name_ru = 'Наблюдение за пациентом (за час)',
	name_tr = 'Saatlik Hasta Gözlemi'
 WHERE slug = 'patient-observation-per-hour';

UPDATE medical_services SET
	name_ru = 'Обучение пациента специальным защитным положениям тела',
	name_tr = 'Özel koruyucu vücut pozisyonları konusunda hasta eğitimi'
 WHERE slug = 'patient-training-in-specific-protective-body-positions';

UPDATE medical_services SET
	name_ru = 'Лечение кариеса у детей',
	name_de = 'Kariesbehandlung bei Kindern'
 WHERE slug = 'pediatric-caries-treatment';

UPDATE medical_services SET
	name_sr = 'Adaptacija djeteta na stomatologa',
	name_sr_cyrl = 'Адаптација дјетета на стоматолога',
	name_ru = 'Адаптация ребёнка к стоматологу',
	name_de = 'Gewöhnung des Kindes an den Zahnarzt',
	name_tr = 'Çocuğun Diş Hekimine Adaptasyonu'
 WHERE slug = 'pediatric-dental-adaptation';

UPDATE medical_services SET
	name_ru = 'Детская стоматологическая диагностика с планом лечения',
	name_tr = 'Çocuklarda Diş Teşhisi ve Tedavi Planı'
 WHERE slug = 'pediatric-dental-diagnostics-with-treatment-plan';

UPDATE medical_services SET
	name_de = 'Beratung beim Kinderzahnarzt'
 WHERE slug = 'pediatric-dentist-consultation';

UPDATE medical_services SET
	name_sr = 'Ultrazvuk kukova kod djece',
	name_sr_cyrl = 'Ултразвук кукова код дјеце'
 WHERE slug = 'pediatric-hip-ultrasound';

UPDATE medical_services SET
	name_de = 'Inzision und Drainage eines Perianalabszesses'
 WHERE slug = 'perianal-abscess-incision-and-drainage';

UPDATE medical_services SET
	name_de = 'Perianalfistel-Operation'
 WHERE slug = 'perianal-fistula-surgery';

UPDATE medical_services SET
	name_en = 'Periodontal Scaling and Root Planing',
	name_ru = 'Кюретаж пародонтальных карманов и сглаживание корней',
	name_de = 'Parodontales Scaling und Wurzelglättung'
 WHERE slug = 'periodontal-scaling-root-planing';

UPDATE medical_services SET
	name_sr = 'Dekompresija/transpozicija perifernog nerva kod kompresivnih neuropatija',
	name_sr_cyrl = 'Декомпресија/транспозиција периферног нерва код компресивних неуропатија',
	name_ru = 'Декомпрессия/транспозиция периферического нерва при компрессионной нейропатии',
	name_de = 'Dekompression/Transposition peripherer Nerven bei Kompressionsneuropathie',
	name_tr = 'Kompresyon nöropatisinde periferik sinir dekompresyonu/transpozisyonu'
 WHERE slug = 'peripheral-nerve-decompressiontransposition-for-compression-neuropathy';

UPDATE medical_services SET
	name_en = 'Classic Pilonidal Cyst Surgery',
	name_de = 'Klassische Pilonidalsinus-Operation',
	name_tr = 'Klasik Pilonidal Kist Ameliyatı'
 WHERE slug = 'pilonidal-cyst-surgery-classic';

UPDATE medical_services SET
	name_de = 'Chirurgische Behandlung des Pilonidalsinus'
 WHERE slug = 'pilonidal-sinus-surgical-treatment';

UPDATE medical_services SET
	name_ru = 'Гипсовый корсет на туловище, включая голову'
 WHERE slug = 'plaster-body-jacket-including-head';

UPDATE medical_services SET
	name_de = 'Reposition mit Gipsmieder',
	name_tr = 'Alçı breys ile redüksiyon'
 WHERE slug = 'plaster-brace-reduction';

UPDATE medical_services SET
	name_tr = 'Alçı veya atel çıkarılması'
 WHERE slug = 'plaster-cast-or-splint-removal';

UPDATE medical_services SET
	name_de = 'Reposition mit Gipskorsett',
	name_tr = 'Alçı korse ile redüksiyon'
 WHERE slug = 'plaster-corset-reduction';

UPDATE medical_services SET
	name_en = 'Hand and Finger Plaster Splint Reduction',
	name_ru = 'Репозиция — гипсовая лонгета на кисть и пальцы',
	name_de = 'Reposition mit Gipsschiene für Hand und Finger',
	name_tr = 'El ve parmak alçı ateli ile redüksiyon'
 WHERE slug = 'plaster-splint-for-hand-and-fingers';

UPDATE medical_services SET
	name_ru = 'Дренирование плевральной полости'
 WHERE slug = 'pleural-drainage';

UPDATE medical_services SET
	name_ru = 'Аневризмэктомия и реконструкция подколенной и других артерий нижних конечностей',
	name_de = 'Aneurysmektomie und Rekonstruktion der Poplitealarterie und anderer Beinarterien',
	name_tr = 'Popliteal ve diğer bacak arterleri anevrizmektomisi ve rekonstrüksiyonu'
 WHERE slug = 'popliteal-and-other-leg-arteries-aneurysmectomy-and-reconstruction';

UPDATE medical_services SET
	name_tr = 'Postür egzersizleri'
 WHERE slug = 'postural-exercises';

UPDATE medical_services SET
	name_en = 'Scheduled Preventive Pregnancy Examination',
	name_ru = 'Профилактический осмотр беременной по графику',
	name_de = 'Vorsorgeuntersuchung in der Schwangerschaft nach Terminplan',
	name_tr = 'Takvime göre koruyucu gebelik muayenesi'
 WHERE slug = 'pregnancy-preventive-examination-by-calendar';

UPDATE medical_services SET
	name_sr = 'Duboki absces dojke — premamarni',
	name_sr_cyrl = 'Дубоки абсцес дојке — премамарни',
	name_ru = 'Лечение глубокого премаммарного абсцесса молочной железы',
	name_de = 'Behandlung eines tiefen prämammären Brustabszesses',
	name_tr = 'Derin premamer meme apsesi tedavisi'
 WHERE slug = 'premammary-deep-breast-abscess-treatment';

UPDATE medical_services SET
	name_sr = 'Bezmetalna krunica od press keramike',
	name_sr_cyrl = 'Безметална круница од press керамике'
 WHERE slug = 'pressed-ceramic-crown';

UPDATE medical_services SET
	name_tr = 'Genel Pratisyen Koruyucu Muayenesi'
 WHERE slug = 'preventive-general-practitioner-examination';

UPDATE medical_services SET
	name_en = 'Prick Test for Inhalant Allergens',
	name_tr = 'İnhalasyon Alerjenleri için Prick Testi'
 WHERE slug = 'prick-test-inhalation-allergens';

UPDATE medical_services SET
	name_en = 'Prick Test for Food Allergens',
	name_tr = 'Besin Alerjenleri için Prick Testi'
 WHERE slug = 'prick-test-nutritive-allergens';

UPDATE medical_services SET
	name_en = 'Prick Test for Food and Inhalant Allergens',
	name_tr = 'Besin ve İnhalasyon Alerjenleri için Prick Testi'
 WHERE slug = 'prick-test-nutritive-and-inhalation-allergens';

UPDATE medical_services SET
	name_sr = 'Primarna reparacija tetive ekstenzora, jedne ili više',
	name_sr_cyrl = 'Примарна репарација тетиве екстензора, једне или више',
	name_ru = 'Первичный шов сухожилия разгибателя (одного или нескольких)',
	name_de = 'Primäre Strecksehnennaht (eine oder mehrere Sehnen)',
	name_tr = 'Primer ekstansör tendon onarımı (bir veya daha fazla)'
 WHERE slug = 'primary-extensor-tendon-repair-one-or-more';

UPDATE medical_services SET
	name_en = 'Primary Multi-Tendon Flexor Repair with Excision of Flexor Digitorum Superficialis',
	name_sr = 'Primarna tendorafija više fleksornih tetiva uz ekstirpaciju sublimisa',
	name_sr_cyrl = 'Примарна тендорафија више флексорних тетива уз екстирпацију сублимиса',
	name_ru = 'Первичный шов нескольких сухожилий сгибателей с иссечением сухожилия поверхностного сгибателя пальцев',
	name_de = 'Primäre Naht mehrerer Beugesehnen mit Exstirpation der Superficialissehne',
	name_tr = 'Çoklu fleksör tendon primer onarımı (yüzeyel fleksör tendonunun eksizyonu ile)'
 WHERE slug = 'primary-multi-tendon-flexor-repair-with-excision';

UPDATE medical_services SET
	name_de = 'Primäre periphere Nervennaht'
 WHERE slug = 'primary-peripheral-nerve-neurorrhaphy';

UPDATE medical_services SET
	name_en = 'Primary Suture of Ruptured Ankle Collateral Ligament',
	name_sr = 'Primarna sutura rupturiranog ili prekinutog kolateralnog ligamenta gležnja',
	name_sr_cyrl = 'Примарна сутура руптурираног или прекинутог колатералног лигамента глежња',
	name_ru = 'Первичный шов разрыва коллатеральной связки голеностопного сустава',
	name_de = 'Primäre Naht eines rupturierten Kollateralbands des Sprunggelenks',
	name_tr = 'Ayak bileği yırtık kolateral bağının primer sütürü'
 WHERE slug = 'primary-suture-of-ruptured-collateral-ligament';

UPDATE medical_services SET
	name_sr = 'Vađenje mliječnog zuba',
	name_sr_cyrl = 'Вађење млијечног зуба'
 WHERE slug = 'primary-tooth-extraction';

UPDATE medical_services SET
	name_en = 'Primary Tooth Extraction with Non-Resorbed Root'
 WHERE slug = 'primary-tooth-extraction-non-resorbed-root';

UPDATE medical_services SET
	name_sr = 'Liječenje pulpe mliječnog zuba',
	name_sr_cyrl = 'Лијечење пулпе млијечног зуба'
 WHERE slug = 'primary-tooth-pulp-treatment';

UPDATE medical_services SET
	name_en = 'Primary Ulnar or Median Nerve Neurorrhaphy at Forearm Level',
	name_sr = 'Primarna neurorafija ulnarisa ili medianusa u visini podlaktice',
	name_sr_cyrl = 'Примарна неурорафија улнариса или медиануса у висини подлактице',
	name_ru = 'Первичная невроррафия локтевого или срединного нерва на уровне предплечья',
	name_de = 'Primäre Ulnaris- oder Medianus-Neurorrhaphie am Unterarm',
	name_tr = 'Önkol seviyesinde ulnar veya median sinir primer nörorafisi'
 WHERE slug = 'primary-ulnar-or-median-nerve-neurorrhaphy';

UPDATE medical_services SET
	name_ru = 'Первичная обработка раны с электрокоагуляцией'
 WHERE slug = 'primary-wound-care-with-electrocauterization';

UPDATE medical_services SET
	name_de = 'Primäre Wundversorgung mit Naht'
 WHERE slug = 'primary-wound-care-with-sutures';

UPDATE medical_services SET
	name_de = 'Primäre Wundversorgung ohne Naht'
 WHERE slug = 'primary-wound-care-without-sutures';

UPDATE medical_services SET
	name_en = 'Professional Dental Cleaning (Deciduous Teeth)',
	name_sr = 'Profesionalno čišćenje zuba (mliječni zubi)',
	name_sr_cyrl = 'Професионално чишћење зуба (млијечни зуби)',
	name_de = 'Professionelle Zahnreinigung (Milchzähne)',
	name_tr = 'Profesyonel Diş Temizliği (Süt Dişleri)'
 WHERE slug = 'professional-dental-cleaning-deciduous-teeth';

UPDATE medical_services SET
	name_en = 'Professional Dental Cleaning (Mixed Dentition)',
	name_sr = 'Profesionalno čišćenje zuba (mješovita denticija)',
	name_sr_cyrl = 'Професионално чишћење зуба (мјешовита дентиција)',
	name_de = 'Professionelle Zahnreinigung (Wechselgebiss)',
	name_tr = 'Profesyonel Diş Temizliği (Karışık Dişlenme)'
 WHERE slug = 'professional-dental-cleaning-mixed-dentition';

UPDATE medical_services SET
	name_de = 'Kardiologische Untersuchung durch einen Professor'
 WHERE slug = 'professor-cardiologist-examination';

UPDATE medical_services SET
	name_de = 'Untersuchung durch einen Professor'
 WHERE slug = 'professor-examination';

UPDATE medical_services SET
	name_en = 'Progressive Resistance Exercises on a Quadriceps Machine'
 WHERE slug = 'progressive-quadriceps-resistance-exercises';

UPDATE medical_services SET
	name_en = 'Big Toe Proximal Phalanx Osteotomy for Shortening, Angular or Rotational Correction (Hallux Valgus)',
	name_sr = 'Osteotomija proksimalne falange palca za skraćenje, ugaonu ili rotacionu korekciju (Hallux valgus)',
	name_sr_cyrl = 'Остеотомија проксималне фаланге палца за скраћење, угаону или ротациону корекцију (Hallux валгус)',
	name_ru = 'Остеотомия проксимальной фаланги большого пальца стопы для укорочения, угловой или ротационной коррекции (Hallux valgus)',
	name_de = 'Osteotomie der Großzehengrundphalanx zur Verkürzung, Achsen- oder Rotationskorrektur (Hallux valgus)',
	name_tr = 'Kısaltma, açısal veya rotasyonel düzeltme için ayak başparmağı proksimal falanks osteotomisi (halluks valgus)'
 WHERE slug = 'proximal-phalanx-big-toe-osteotomy-for-shortening-or-rotation';

UPDATE medical_services SET
	name_tr = 'Pterjium Çıkarılması'
 WHERE slug = 'pterygium-removal';

UPDATE medical_services SET
	name_tr = 'Konjonktival Greft ile Pterjium Çıkarılması'
 WHERE slug = 'pterygium-removal-with-conjunctival-graft';

UPDATE medical_services SET
	name_en = 'Pulpitis Treatment, Single-Root Tooth (Rotary)',
	name_sr = 'Liječenje pulpitisa jednokorijenog zuba (mašinski)',
	name_sr_cyrl = 'Лијечење пулпитиса једнокоријеног зуба (машински)',
	name_ru = 'Лечение пульпита однокорневого зуба (машинная обработка каналов)',
	name_de = 'Pulpitisbehandlung eines einwurzeligen Zahns (maschinell)',
	name_tr = 'Tek Köklü Diş Pulpitis Tedavisi (Döner Alet)'
 WHERE slug = 'pulpitis-treatment-single-root-machine';

UPDATE medical_services SET
	name_en = 'Pulpitis Treatment, Single-Root Tooth (NiTi)',
	name_sr = 'Liječenje pulpitisa jednokorijenog zuba (NiTi)',
	name_sr_cyrl = 'Лијечење пулпитиса једнокоријеног зуба (NiTi)',
	name_ru = 'Лечение пульпита однокорневого зуба (NiTi)',
	name_de = 'Pulpitisbehandlung eines einwurzeligen Zahns (NiTi)',
	name_tr = 'Tek Köklü Diş Pulpitis Tedavisi (NiTi)'
 WHERE slug = 'pulpitis-treatment-single-root-niti';

UPDATE medical_services SET
	name_en = 'Pulpitis Treatment, Three-Root Tooth (Rotary)',
	name_sr = 'Liječenje pulpitisa trokorijenog zuba (mašinski)',
	name_sr_cyrl = 'Лијечење пулпитиса трокоријеног зуба (машински)',
	name_ru = 'Лечение пульпита трёхкорневого зуба (машинная обработка каналов)',
	name_de = 'Pulpitisbehandlung eines dreiwurzeligen Zahns (maschinell)',
	name_tr = 'Üç Köklü Diş Pulpitis Tedavisi (Döner Alet)'
 WHERE slug = 'pulpitis-treatment-three-root-machine';

UPDATE medical_services SET
	name_en = 'Pulpitis Treatment, Three-Root Tooth (NiTi)',
	name_sr = 'Liječenje pulpitisa trokorijenog zuba (NiTi)',
	name_sr_cyrl = 'Лијечење пулпитиса трокоријеног зуба (NiTi)',
	name_ru = 'Лечение пульпита трёхкорневого зуба (NiTi)',
	name_de = 'Pulpitisbehandlung eines dreiwurzeligen Zahns (NiTi)',
	name_tr = 'Üç Köklü Diş Pulpitis Tedavisi (NiTi)'
 WHERE slug = 'pulpitis-treatment-three-root-niti';

UPDATE medical_services SET
	name_en = 'Pulpitis Treatment, Two-Root Tooth (Rotary)',
	name_sr = 'Liječenje pulpitisa dvokorijenog zuba (mašinski)',
	name_sr_cyrl = 'Лијечење пулпитиса двокоријеног зуба (машински)',
	name_ru = 'Лечение пульпита двухкорневого зуба (машинная обработка каналов)',
	name_de = 'Pulpitisbehandlung eines zweiwurzeligen Zahns (maschinell)',
	name_tr = 'İki Köklü Diş Pulpitis Tedavisi (Döner Alet)'
 WHERE slug = 'pulpitis-treatment-two-root-machine';

UPDATE medical_services SET
	name_en = 'Pulpitis Treatment, Two-Root Tooth (NiTi)',
	name_sr = 'Liječenje pulpitisa dvokorijenog zuba (NiTi)',
	name_sr_cyrl = 'Лијечење пулпитиса двокоријеног зуба (NiTi)',
	name_ru = 'Лечение пульпита двухкорневого зуба (NiTi)',
	name_de = 'Pulpitisbehandlung eines zweiwurzeligen Zahns (NiTi)',
	name_tr = 'İki Köklü Diş Pulpitis Tedavisi (NiTi)'
 WHERE slug = 'pulpitis-treatment-two-root-niti';

UPDATE medical_services SET
	name_en = 'Pulpotomy (Vital or Devital)',
	name_de = 'Pulpotomie (vital oder devital)',
	name_tr = 'Pulpotomi (vital veya devital)'
 WHERE slug = 'pulpotomy';

UPDATE medical_services SET
	name_ru = 'Пункция и дренирование эпидурального, субдурального или мозгового абсцесса'
 WHERE slug = 'puncture-and-drainage-of-episubdural-or-brain-abscess';

UPDATE medical_services SET
	name_de = 'Entfernung von Hautläsionen mit Radiowellen',
	name_tr = 'Radyodalga ile Cilt Lezyonu Çıkarma'
 WHERE slug = 'radiowave-skin-lesion-removal';

UPDATE medical_services SET
	name_de = 'Blutzucker-Schnelltest'
 WHERE slug = 'rapid-blood-glucose-test';

UPDATE medical_services SET
	name_ru = 'Реампутация ноги через бедренную кость'
 WHERE slug = 're-amputation-through-femur';

UPDATE medical_services SET
	name_ru = 'Ректоскопия под анестезией'
 WHERE slug = 'rectoscopy-with-anesthesia';

UPDATE medical_services SET
	name_sr = 'Plastika recidivantne ventralne hernije',
	name_sr_cyrl = 'Пластика рецидивантне вентралне херније',
	name_ru = 'Пластика рецидивирующей вентральной грыжи'
 WHERE slug = 'recurrent-ventral-hernia-repair';

UPDATE medical_services SET
	name_ru = 'Репозиция вывиха плеча с переломом большого бугорка плечевой кости'
 WHERE slug = 'reduction-of-shoulder-dislocation-with-greater-tuberosity-fracture';

UPDATE medical_services SET
	name_ru = 'Удаление субтотального эндопротеза тазобедренного сустава с подготовкой к ревизионному эндопротезированию',
	name_de = 'Entfernung einer subtotalen Hüftendoprothese mit Vorbereitung auf eine Revisionsprothese',
	name_tr = 'Subtotal kalça protezinin çıkarılması ve revizyon protezine hazırlık'
 WHERE slug = 'removal-of-subtotal-hip-prosthesis-with-reintervention-prep';

UPDATE medical_services SET
	name_ru = 'Удаление тотального эндопротеза тазобедренного сустава с подготовкой к ревизионному эндопротезированию',
	name_de = 'Entfernung einer Hüft-Totalendoprothese mit Vorbereitung auf eine Revisionsprothese',
	name_tr = 'Total kalça protezinin çıkarılması ve revizyon protezine hazırlık'
 WHERE slug = 'removal-of-total-hip-prosthesis-with-reintervention-prep';

UPDATE medical_services SET
	name_de = 'Einsetzen eines Retainers pro Kiefer'
 WHERE slug = 'retainer-placement-per-arch';

UPDATE medical_services SET
	name_sr = 'Duboki absces dojke — retromamarni',
	name_sr_cyrl = 'Дубоки абсцес дојке — ретромамарни',
	name_ru = 'Лечение глубокого ретромаммарного абсцесса молочной железы',
	name_de = 'Behandlung eines tiefen retromammären Brustabszesses',
	name_tr = 'Derin retromamer meme apsesi tedavisi'
 WHERE slug = 'retromammary-deep-breast-abscess-treatment';

UPDATE medical_services SET
	name_en = 'Root Canal Retreatment, Multi-Root Tooth',
	name_sr = 'Revizija liječenja kanala višekorijenog zuba',
	name_sr_cyrl = 'Ревизија лијечења канала вишекоријеног зуба',
	name_de = 'Wurzelkanalrevision, mehrwurzeliger Zahn'
 WHERE slug = 'root-canal-retreatment-multi-root-tooth';

UPDATE medical_services SET
	name_en = 'Root Canal Treatment, First Root',
	name_sr = 'Liječenje korijenskog kanala, prvi korijen',
	name_sr_cyrl = 'Лијечење коријенског канала, први коријен',
	name_ru = 'Лечение корневого канала, первый корень',
	name_de = 'Wurzelkanalbehandlung, erste Wurzel',
	name_tr = 'Kök Kanal Tedavisi, Birinci Kök'
 WHERE slug = 'root-canal-treatment-first-root';

UPDATE medical_services SET
	name_en = 'Root Canal Treatment, Second Root',
	name_sr = 'Liječenje korijenskog kanala, drugi korijen',
	name_sr_cyrl = 'Лијечење коријенског канала, други коријен',
	name_ru = 'Лечение корневого канала, второй корень',
	name_de = 'Wurzelkanalbehandlung, zweite Wurzel',
	name_tr = 'Kök Kanal Tedavisi, İkinci Kök'
 WHERE slug = 'root-canal-treatment-second-root';

UPDATE medical_services SET
	name_en = 'Root Canal Treatment, Third Root',
	name_sr = 'Liječenje korijenskog kanala, treći korijen',
	name_sr_cyrl = 'Лијечење коријенског канала, трећи коријен',
	name_ru = 'Лечение корневого канала, третий корень',
	name_de = 'Wurzelkanalbehandlung, dritte Wurzel',
	name_tr = 'Kök Kanal Tedavisi, Üçüncü Kök'
 WHERE slug = 'root-canal-treatment-third-root';

UPDATE medical_services SET
	name_de = 'Anlegen eines Kofferdams'
 WHERE slug = 'rubber-dam-application';

UPDATE medical_services SET
	name_sr = 'Repozicija — Sarmiento gips',
	name_sr_cyrl = 'Репозиција — Сармиенто гипс',
	name_ru = 'Репозиция — гипс по Сармьенто'
 WHERE slug = 'sarmiento-cast-reduction';

UPDATE medical_services SET
	name_de = 'Mesotherapie der Kopfhaut',
	name_tr = 'Saç derisi mezoterapisi'
 WHERE slug = 'scalp-mesotherapy';

UPDATE medical_services SET
	name_tr = 'Schanz boyunluğu'
 WHERE slug = 'schanz-collar-application';

UPDATE medical_services SET
	name_sr = 'Blokada išijadičnog nerva',
	name_sr_cyrl = 'Блокада ишијадичног нерва'
 WHERE slug = 'sciatic-nerve-block';

UPDATE medical_services SET
	name_sr = 'Šrafovana krunica na implantatu CoCr',
	name_sr_cyrl = 'Шрафована круница на имплантату CoCr'
 WHERE slug = 'screw-retained-implant-crown-cocr';

UPDATE medical_services SET
	name_sr = 'Šrafovana cirkonijum krunica na implantatu',
	name_sr_cyrl = 'Шрафована цирконијум круница на имплантату',
	name_ru = 'Циркониевая коронка на имплантате с винтовой фиксацией',
	name_tr = 'Vidalı zirkonyum implant kronu'
 WHERE slug = 'screw-retained-implant-crown-zirconia';

UPDATE medical_services SET
	name_ru = 'Остеотомия второй фаланги любого пальца стопы',
	name_de = 'Osteotomie der zweiten Phalanx einer beliebigen Zehe',
	name_tr = 'Herhangi bir ayak parmağının ikinci falanks osteotomisi'
 WHERE slug = 'second-phalanx-osteotomy-any-toe';

UPDATE medical_services SET
	name_de = 'Sekundäre Rekonstruktion des medialen Bandes und der Kapsel'
 WHERE slug = 'secondary-repair-of-medial-ligament-and-capsule';

UPDATE medical_services SET
	name_ru = 'Самолигирующая брекет-система керамическая на одну челюсть'
 WHERE slug = 'self-ligating-braces-ceramic-per-jaw';

UPDATE medical_services SET
	name_ru = 'Самолигирующая брекет-система металлическая на одну челюсть'
 WHERE slug = 'self-ligating-braces-metal-per-jaw';

UPDATE medical_services SET
	name_sr = 'Jedan dan boravka u poluintenzivnoj njezi',
	name_sr_cyrl = 'Један дан боравка у полуинтензивној њези',
	name_ru = 'Койко-день в палате полуинтенсивной терапии',
	name_de = 'Pflegetag in der Halbintensivpflege'
 WHERE slug = 'semi-intensive-care-bed-day';

UPDATE medical_services SET
	name_sr = 'Ekstrakcija sočiva kod senilne katarakte',
	name_sr_cyrl = 'Екстракција сочива код сенилне катаракте'
 WHERE slug = 'senile-cataract-lens-extraction';

UPDATE medical_services SET
	name_en = 'Shoulder Arthrotomy (Capsulotomy) with Exploration, Drainage and Foreign Body Removal',
	name_sr = 'Artrotomija (kapsulotomija) ramena sa eksploracijom, drenažom i odstranjenjem stranog tijela',
	name_sr_cyrl = 'Артротомија (капсулотомија) рамена са експлорацијом, дренажом и одстрањењем страног тијела',
	name_ru = 'Артротомия плечевого сустава (капсулотомия) с ревизией, дренированием и удалением инородного тела',
	name_de = 'Schulterarthrotomie (Kapsulotomie) mit Exploration, Drainage und Fremdkörperentfernung',
	name_tr = 'Eksplorasyon, drenaj ve yabancı cisim çıkarılması ile omuz artrotomisi (kapsülotomi)'
 WHERE slug = 'shoulder-arthrotomy-capsulotomy-with-exploration';

UPDATE medical_services SET
	name_ru = 'Репозиция вывиха плеча (закрытого или открытого)',
	name_de = 'Reposition einer Schulterluxation (geschlossen oder offen)',
	name_tr = 'Omuz dislokasyonu redüksiyonu (kapalı veya açık)'
 WHERE slug = 'shoulder-dislocation-open-or-closed';

UPDATE medical_services SET
	name_de = 'Armtragetuch (Mitella)'
 WHERE slug = 'shoulder-sling-mitella';

UPDATE medical_services SET
	name_ru = 'ЭМГ одиночного мышечного волокна (SFEMG)',
	name_de = 'Einzelfaser-EMG (SFEMG)'
 WHERE slug = 'single-fiber-emg-sfemg';

UPDATE medical_services SET
	name_de = 'Amputation eines Fingers oder einer Zehe'
 WHERE slug = 'single-fingertoe-amputation';

UPDATE medical_services SET
	name_sr = 'Amputacija jednog metakarpusa sa prstom ili palcem',
	name_sr_cyrl = 'Ампутација једног метакарпуса са прстом или палцем',
	name_ru = 'Ампутация одной пястной кости с пальцем или большим пальцем',
	name_de = 'Amputation eines Mittelhandknochens mit Finger oder Daumen',
	name_tr = 'Parmak veya başparmak ile tek metakarp amputasyonu'
 WHERE slug = 'single-metacarpal-amputation-with-finger-or-thumb';

UPDATE medical_services SET
	name_ru = 'Фармакопунктура в одну точку'
 WHERE slug = 'single-point-pharmacopuncture';

UPDATE medical_services SET
	name_de = 'Modellgussprothese'
 WHERE slug = 'skeletal-partial-denture';

UPDATE medical_services SET
	name_de = 'Schädelbasis-Meningeom-Entfernung',
	name_tr = 'Kafa tabanı menenjiyomu çıkarımı'
 WHERE slug = 'skull-base-meningioma-removal';

UPDATE medical_services SET
	name_en = 'Standard Fluoroscopic Small Bowel Follow-Through',
	name_sr = 'Standardna rentgenoskopska pasaža tankog crijeva',
	name_sr_cyrl = 'Стандардна рентгеноскопска пасажа танког цријева',
	name_ru = 'Стандартное рентгеноскопическое исследование пассажа по тонкой кишке',
	name_de = 'Standard-Dünndarmpassage unter Durchleuchtung'
 WHERE slug = 'small-bowel-standard-fluoroscopic-passage';

UPDATE medical_services SET
	name_ru = 'Осмотр стоматолога-специалиста'
 WHERE slug = 'specialist-dental-examination';

UPDATE medical_services SET
	name_ru = 'Осмотр врача-специалиста'
 WHERE slug = 'specialist-examination';

UPDATE medical_services SET
	name_de = 'Evakuation eines spontanen intrazerebralen Hämatoms'
 WHERE slug = 'spontaneous-intracerebral-hematoma-evacuation';

UPDATE medical_services SET
	name_ru = 'Стимулирующие упражнения для младенцев группы риска'
 WHERE slug = 'stimulative-exercises-for-at-risk-infants';

UPDATE medical_services SET
	name_sr = 'RTG pregled batrljka želuca sa kateterom',
	name_sr_cyrl = 'RTG преглед батрљка желуца са катетером',
	name_de = 'Röntgenuntersuchung des Magenstumpfes mit Katheter',
	name_tr = 'Kateter ile mide güdüğü röntgeni'
 WHERE slug = 'stomach-stump-x-ray-with-catheter';

UPDATE medical_services SET
	name_en = 'Subcapsular Orchiectomy under Local Anesthesia'
 WHERE slug = 'subcapsular-orchiectomy-local-anesthesia';

UPDATE medical_services SET
	name_ru = 'Подкожная или внутримышечная инъекция'
 WHERE slug = 'subcutaneous-or-intramuscular-injection';

UPDATE medical_services SET
	name_sr = 'Subkutana palmarna fasciotomija kod Dupuytren-ove kontrakture',
	name_sr_cyrl = 'Субкутана палмарна фасциотомија код Dupuytren-ове контрактуре',
	name_ru = 'Подкожная ладонная фасциотомия при контрактуре Дюпюитрена',
	name_de = 'Subkutane palmare Fasziotomie bei Dupuytren-Kontraktur',
	name_tr = 'Dupuytren kontraktüründe subkutan palmar fasiyotomi'
 WHERE slug = 'subcutaneous-palmar-fasciotomy-dupuytren';

UPDATE medical_services SET
	name_sr = 'Subkutana plantarna fasciotomija i/ili fasciotomija prsta',
	name_sr_cyrl = 'Субкутана плантарна фасциотомија и/или фасциотомија прста',
	name_ru = 'Подкожная подошвенная фасциотомия и/или фасциотомия пальца стопы',
	name_tr = 'Subkutan plantar ve/veya ayak parmağı fasiyotomisi'
 WHERE slug = 'subcutaneous-plantar-or-toe-fasciotomy';

UPDATE medical_services SET
	name_ru = 'Осмотр врача узкого профиля',
	name_tr = 'Yan Dal Uzmanı Muayenesi'
 WHERE slug = 'subspecialist-examination';

UPDATE medical_services SET
	name_ru = 'Осмотр педиатра узкого профиля',
	name_tr = 'Pediatrik Yan Dal Uzmanı Muayenesi'
 WHERE slug = 'subspecialist-pediatric-examination';

UPDATE medical_services SET
	name_tr = 'Super Inductive System Tedavisi'
 WHERE slug = 'super-inductive-system-therapy';

UPDATE medical_services SET
	name_en = 'Simple Superficial Papilloma Excision',
	name_de = 'Exzision eines einfachen oberflächlichen Papilloms',
	name_tr = 'Basit yüzeysel papillom eksizyonu'
 WHERE slug = 'superficial-papilloma-excision';

UPDATE medical_services SET
	name_de = 'Suprakondyläre oder transkondyläre Humerusfraktur'
 WHERE slug = 'supracondylar-or-transcondylar-humerus-fracture-closed';

UPDATE medical_services SET
	name_de = 'Entfernung suprasellärer oder parasellärer Tumoren'
 WHERE slug = 'suprasellar-or-parasellar-tumor-removal';

UPDATE medical_services SET
	name_en = 'Surgical Exposure of Impacted Tooth',
	name_sr = 'Denudacija impaktiranog zuba',
	name_sr_cyrl = 'Денудација импактираног зуба',
	name_de = 'Freilegung eines impaktierten Zahns',
	name_tr = 'Gömülü Dişin Cerrahi Olarak Açılması'
 WHERE slug = 'surgical-exposure-impacted-tooth';

UPDATE medical_services SET
	name_sr = 'Hirurška vodilica po implantatu',
	name_sr_cyrl = 'Хируршка водилица по импланту',
	name_ru = 'Хирургический шаблон на один имплантат'
 WHERE slug = 'surgical-guide-per-implant';

UPDATE medical_services SET
	name_ru = 'Репозиция перелома хирургической шейки лопатки (закрытого или открытого)',
	name_de = 'Reposition einer Fraktur des chirurgischen Skapulahalses (geschlossen oder offen)',
	name_tr = 'Skapula cerrahi boyun kırığı redüksiyonu (kapalı veya açık)'
 WHERE slug = 'surgical-neck-of-scapula-fracture-closed-or-open';

UPDATE medical_services SET
	name_ru = 'Хирургическое лечение ксантелазмы, контагиозного моллюска или бородавки (двустороннее)',
	name_tr = 'Ksantelazma, molluskum veya siğil cerrahi tedavisi (çift taraflı)'
 WHERE slug = 'surgical-treatment-of-xanthelasma-molluscum-or-verruca-bilateral';

UPDATE medical_services SET
	name_ru = 'Хирургическое лечение ксантелазмы, контагиозного моллюска или бородавки (одностороннее)',
	name_tr = 'Ksantelazma, molluskum veya siğil cerrahi tedavisi (tek taraflı)'
 WHERE slug = 'surgical-treatment-of-xanthelasma-molluscum-or-verruca-unilateral';

UPDATE medical_services SET
	name_en = 'Replacement of Dislodged T-Drain under CT Guidance',
	name_de = 'Ersatz einer dislozierten T-Drainage unter CT-Kontrolle',
	name_tr = 'BT eşliğinde yerinden çıkmış T-drenin yeniden yerleştirilmesi'
 WHERE slug = 't-drain-replacement-under-ct-guidance';

UPDATE medical_services SET
	name_tr = 'Talus osteotomisi'
 WHERE slug = 'talus-osteotomy';

UPDATE medical_services SET
	name_en = 'Targeted X-Ray of Esophagus, Stomach, Duodenum and Intestine (per Image)',
	name_sr = 'Ciljano snimanje jednjaka, želuca, duodenuma i crijeva (za svaki snimak)',
	name_sr_cyrl = 'Циљано снимање једњака, желуца, дуоденума и цријева (за сваки снимак)',
	name_ru = 'Прицельная рентгенография пищевода, желудка, ДПК и кишечника (за снимок)',
	name_de = 'Gezielte Röntgenaufnahme von Speiseröhre, Magen, Duodenum und Darm (pro Aufnahme)',
	name_tr = 'Yemek borusu, mide, duodenum ve bağırsak hedefli röntgeni (çekim başına)'
 WHERE slug = 'targeted-upper-gi-tract-x-ray';

UPDATE medical_services SET
	name_ru = 'Репозиция вывиха кости предплюсны (закрытого или открытого) с фиксацией или без',
	name_de = 'Reposition einer Fußwurzelknochenluxation (geschlossen oder offen) mit oder ohne Fixation',
	name_tr = 'Tarsal kemik dislokasyonu redüksiyonu (kapalı veya açık), fiksasyonlu veya fiksasyonsuz'
 WHERE slug = 'tarsal-bone-dislocation-reduction-withwithout-fixation';

UPDATE medical_services SET
	name_ru = 'Репозиция перелома кости предплюсны (закрытого или открытого) с внутренней или наружной фиксацией или без',
	name_de = 'Reposition einer Fußwurzelknochenfraktur (geschlossen oder offen) mit oder ohne interne oder externe Fixation',
	name_tr = 'Tarsal kemik kırığı redüksiyonu (kapalı veya açık), iç veya dış fiksasyonlu ya da fiksasyonsuz'
 WHERE slug = 'tarsal-bone-fracture-reduction-withwithout-fixation';

UPDATE medical_services SET
	name_ru = 'Репозиция вывиха предплюсне-плюсневого сустава (закрытого или открытого)'
 WHERE slug = 'tarsometatarsal-joint-dislocation-reduction';

UPDATE medical_services SET
	name_sr = 'Tecar terapija',
	name_sr_cyrl = 'Тецар терапија'
 WHERE slug = 'tecar-therapy';

UPDATE medical_services SET
	name_ru = 'Временный мост на 4 единицы',
	name_de = 'Provisorische Brücke, 4-gliedrig',
	name_tr = '4 Üniteli Geçici Köprü'
 WHERE slug = 'temporary-bridge-4-units';

UPDATE medical_services SET
	name_ru = 'Наложение лекарства и временной пломбы',
	name_de = 'Medikamentöse Einlage mit provisorischer Füllung'
 WHERE slug = 'temporary-filling-with-medication';

UPDATE medical_services SET
	name_sr = 'TENS terapija',
	name_sr_cyrl = 'ТЕНС терапија'
 WHERE slug = 'tens-therapy';

UPDATE medical_services SET
	name_ru = 'УЗИ яичек'
 WHERE slug = 'testicular-ultrasound';

UPDATE medical_services SET
	name_en = 'Complete Therapeutic Massage',
	name_sr = 'Terapijska masaža kompletna',
	name_sr_cyrl = 'Терапијска масажа комплетна',
	name_de = 'Therapeutische Ganzkörpermassage'
 WHERE slug = 'therapeutic-massage-complete';

UPDATE medical_services SET
	name_en = 'Partial Therapeutic Massage',
	name_de = 'Therapeutische Teilkörpermassage'
 WHERE slug = 'therapeutic-massage-partial';

UPDATE medical_services SET
	name_sr = 'Termoterapija: krioterapija',
	name_sr_cyrl = 'Термотерапија: криотерапија'
 WHERE slug = 'thermotherapy-cryotherapy';

UPDATE medical_services SET
	name_sr = 'Termoterapija: parafango',
	name_sr_cyrl = 'Термотерапија: парафанго'
 WHERE slug = 'thermotherapy-parafango';

UPDATE medical_services SET
	name_de = 'Oberschenkel-Gipsimmobilisation (Schiene oder Vollgips)',
	name_tr = 'Uyluk alçı immobilizasyonu (atel veya tam alçı)'
 WHERE slug = 'thigh-plaster-immobilization';

UPDATE medical_services SET
	name_ru = 'Репозиция — торакобрахиальная лонгета',
	name_de = 'Reposition mit thorakobrachialer Schiene',
	name_tr = 'Torakobrakiyal atel ile redüksiyon'
 WHERE slug = 'thoracobrachial-splint-reduction';

UPDATE medical_services SET
	name_ru = 'Репозиция перелома диафиза большеберцовой кости (закрытого или открытого) с внутренней или наружной фиксацией',
	name_de = 'Reposition einer Tibiadiaphysenfraktur (geschlossen oder offen) mit interner oder externer Fixation',
	name_tr = 'Tibia diyafiz kırığı redüksiyonu (kapalı veya açık), iç veya dış fiksasyonlu'
 WHERE slug = 'tibia-diaphysis-fracture-reduction-with-internalexternal-fixation';

UPDATE medical_services SET
	name_ru = 'Репозиция перелома большеберцовой кости (закрытого или открытого) с внутренней фиксацией или без'
 WHERE slug = 'tibial-fracture-reduction-closed-or-open-withwithout-fixation';

UPDATE medical_services SET
	name_tr = 'Tibia osteotomisi'
 WHERE slug = 'tibial-osteotomy';

UPDATE medical_services SET
	name_en = 'Complex Tooth Extraction',
	name_de = 'Komplizierte Zahnextraktion'
 WHERE slug = 'tooth-extraction-complex';

UPDATE medical_services SET
	name_en = 'Simple Tooth Extraction',
	name_sr = 'Jednostavno vađenje zuba',
	name_sr_cyrl = 'Једноставно вађење зуба',
	name_de = 'Einfache Zahnextraktion'
 WHERE slug = 'tooth-extraction-simple';

UPDATE medical_services SET
	name_en = 'Topical Eye Medication Application (Drops and Ointments)',
	name_ru = 'Закапывание капель и закладывание мази в глаза',
	name_de = 'Lokale Anwendung von Augentropfen und Augensalben',
	name_tr = 'Göz Damlası ve Merhem Uygulaması'
 WHERE slug = 'topical-eye-medication-application';

UPDATE medical_services SET
	name_sr = 'Totalna kolektomija sa ileorektalnom anastomozom',
	name_sr_cyrl = 'Тотална колектомија са илеоректалном анастомозом',
	name_ru = 'Тотальная колэктомия с илеоректальным анастомозом'
 WHERE slug = 'total-colectomy-with-ileo-rectal-anastomosis';

UPDATE medical_services SET
	name_sr = 'Totalna fasciotomija kod Dupuytren-ove kontrakture',
	name_sr_cyrl = 'Тотална фасциотомија код Dupuytren-ове контрактуре'
 WHERE slug = 'total-fasciotomy-for-dupuytren-contracture';

UPDATE medical_services SET
	name_tr = 'Trakea rezeksiyonu'
 WHERE slug = 'tracheal-resection';

UPDATE medical_services SET
	name_sr = 'Transmetatarzalna amputacija stopala',
	name_sr_cyrl = 'Трансметатарзална ампутација стопала'
 WHERE slug = 'transmetatarsal-foot-amputation';

UPDATE medical_services SET
	name_sr = 'Transnavikularna perilunarna fraktura — zatvorena ili otvorena',
	name_sr_cyrl = 'Транснавикуларна перилунарна фрактура — затворена или отворена',
	name_ru = 'Репозиция транснавикулярного перилунарного перелома (закрытого или открытого)',
	name_de = 'Reposition einer transnavikulären perilunären Fraktur (geschlossen oder offen)',
	name_tr = 'Transnaviküler perilunat kırık redüksiyonu (kapalı veya açık)'
 WHERE slug = 'transnavicular-perilunate-fracture-open-or-closed';

UPDATE medical_services SET
	name_en = 'Open Reduction of Traumatic Hip Dislocation (Closed or Open)',
	name_sr = 'Traumatska dislokacija zgloba kuka — zatvorena ili otvorena, otvorena repozicija',
	name_sr_cyrl = 'Трауматска дислокација зглоба кука — затворена или отворена, отворена репозиција',
	name_ru = 'Открытая репозиция травматического вывиха бедра (закрытого или открытого)',
	name_de = 'Offene Reposition einer traumatischen Hüftluxation (geschlossen oder offen)',
	name_tr = 'Travmatik kalça dislokasyonunun açık redüksiyonu (kapalı veya açık)'
 WHERE slug = 'traumatic-hip-dislocation-closed-or-open';

UPDATE medical_services SET
	name_de = 'Versorgung von Kopfplatzwunden und kleinen Impressionsfrakturen des Schädels'
 WHERE slug = 'treatment-of-head-lacerations-and-minor-skull-depression-fractures';

UPDATE medical_services SET
	name_en = 'Treatment of Smaller Wounds without Deep Structure Lesion by Direct Suture (Face, Eyelids, Nose, Lip, Ear, Hand)',
	name_sr = 'Obrada manjih rana bez lezije dubokih struktura direktnom suturom na licu, očnim kapcima, nosu, usni, ušnoj školjci i šaci',
	name_sr_cyrl = 'Обрада мањих рана без лезије дубоких структура директном сутуром на лицу, очним капцима, носу, усни, ушној шкољци и шаци',
	name_ru = 'Обработка малых ран без повреждения глубоких структур с наложением шва (лицо, веки, нос, губа, ушная раковина, кисть)',
	name_de = 'Versorgung kleinerer Wunden ohne Verletzung tiefer Strukturen mit Direktnaht (Gesicht, Augenlider, Nase, Lippe, Ohrmuschel, Hand)',
	name_tr = 'Derin doku hasarı olmayan küçük yaraların doğrudan sütürle tedavisi (yüz, göz kapağı, burun, dudak, kulak kepçesi, el)'
 WHERE slug = 'treatment-of-smaller-wounds-without-deep-structure-lesion-direct';

UPDATE medical_services SET
	name_sr = 'Presijecanje grane n. trigeminusa',
	name_sr_cyrl = 'Пресецање гране n. тригеминуса'
 WHERE slug = 'trigeminal-nerve-branch-sectioning';

UPDATE medical_services SET
	name_sr = 'Trimaleolarna fraktura gležnja — zatvorena ili otvorena, sa ili bez fiksacije',
	name_sr_cyrl = 'Трималеоларна фрактура глежња — затворена или отворена, са или без фиксације',
	name_ru = 'Репозиция трёхлодыжечного перелома голеностопного сустава (закрытого или открытого) с фиксацией или без',
	name_de = 'Reposition einer trimalleolären Sprunggelenksfraktur (geschlossen oder offen) mit oder ohne Fixation',
	name_tr = 'Trimalleoler ayak bileği kırığı redüksiyonu (kapalı veya açık), fiksasyonlu veya fiksasyonsuz'
 WHERE slug = 'trimalleolar-ankle-fracture-open-or-closed-withwithout-fixation';

UPDATE medical_services SET
	name_de = 'Exzision der Bursa trochanterica oder von Verkalkungen'
 WHERE slug = 'trochanteric-bursa-or-calcification-excision';

UPDATE medical_services SET
	name_ru = 'Гипсовый тутор'
 WHERE slug = 'tutor-plaster-cast';

UPDATE medical_services SET
	name_sr = 'U-šina',
	name_sr_cyrl = 'У-шина',
	name_tr = 'U ateli'
 WHERE slug = 'u-splint-application';

UPDATE medical_services SET
	name_de = 'Ultraschall der Lymphknoten',
	name_tr = 'Lenf nodları ultrasonu'
 WHERE slug = 'ultrasound-lymph-nodes';

UPDATE medical_services SET
	name_sr = 'Ultrazvuk vrata (žlijezde i meka tkiva)',
	name_sr_cyrl = 'Ултразвук врата (жлијезде и мека ткива)',
	name_ru = 'УЗИ желёз и мягких тканей шеи',
	name_de = 'Ultraschall der Drüsen und Weichteile des Halses'
 WHERE slug = 'ultrasound-neck-glands-and-soft-tissue';

UPDATE medical_services SET
	name_sr = 'Ultrazvuk štitne i paraštitne žlijezde',
	name_sr_cyrl = 'Ултразвук штитне и параштитне жлијезде'
 WHERE slug = 'ultrasound-thyroid-and-parathyroid-glands';

UPDATE medical_services SET
	name_de = 'Nabelbruch-Operation'
 WHERE slug = 'umbilical-hernia-operation';

UPDATE medical_services SET
	name_ru = 'Односторонняя операция на околоносовых пазухах по Де Лима'
 WHERE slug = 'unilateral-de-lima-sinus-operation';

UPDATE medical_services SET
	name_en = 'Hysteroscopic Uterine Polypectomy',
	name_ru = 'Гистероскопическая полипэктомия матки',
	name_de = 'Hysteroskopische Uteruspolypektomie'
 WHERE slug = 'uterine-polypectomy-hysteroscopy';

UPDATE medical_services SET
	name_en = 'Hysteroscopic Uterine Septum Resection',
	name_ru = 'Гистероскопическая резекция внутриматочной перегородки',
	name_de = 'Hysteroskopische Uterusseptumresektion'
 WHERE slug = 'uterine-septum-resection-hysteroscopy';

UPDATE medical_services SET
	name_de = 'Untersuchung beim Gefäßchirurgen'
 WHERE slug = 'vascular-surgeon-examination';

UPDATE medical_services SET
	name_en = 'Vein Surgery (One Leg)',
	name_ru = 'Операция на венах одной ноги',
	name_de = 'Venenoperation an einem Bein',
	name_tr = 'Tek Bacak Ven Ameliyatı'
 WHERE slug = 'vein-surgery-one-leg';

UPDATE medical_services SET
	name_ru = 'Вентрикулоатриальное или вентрикулоперитонеальное шунтирование'
 WHERE slug = 'ventriculoatrial-or-ventriculoperitoneal-shunt';

UPDATE medical_services SET
	name_en = 'Cervical Vertebral Body Fracture or Dislocation Reduction with Halo Traction',
	name_sr = 'Repozicija frakture ili dislokacije tijela jednog ili više pršljenova sa Halo trakcijom — vratni dio kičme',
	name_sr_cyrl = 'Репозиција фрактуре или дислокације тијела једног или више пршљенова са Хало тракцијом — вратни дио кичме',
	name_ru = 'Репозиция перелома или вывиха тел одного или нескольких шейных позвонков с гало-тракцией',
	name_de = 'Reposition einer Fraktur oder Luxation eines oder mehrerer Halswirbelkörper mit Halo-Traktion',
	name_tr = 'Halo traksiyonu ile servikal vertebra cisim kırığı veya dislokasyonu redüksiyonu'
 WHERE slug = 'vertebral-body-fracture-or-dislocation-reduction';

UPDATE medical_services SET
	name_ru = 'VIMA — индукция и поддержание ингаляционной анестезии',
	name_de = 'VIMA (volatile Narkoseeinleitung und -aufrechterhaltung)',
	name_tr = 'VIMA (volatil indüksiyon ve idame anestezisi)'
 WHERE slug = 'vima-volatile-induction-and-maintenance-anesthesia';

UPDATE medical_services SET
	name_en = 'Surgical Removal of Viral Warts',
	name_de = 'Chirurgische Entfernung von Viruswarzen',
	name_tr = 'Viral siğillerin cerrahi olarak alınması'
 WHERE slug = 'viral-wart-surgical-removal';

UPDATE medical_services SET
	name_sr = 'Vistabel Botox',
	name_sr_cyrl = 'Vistabel Ботокс'
 WHERE slug = 'vistabel-botox';

UPDATE medical_services SET
	name_sr = 'Gips za kretanje ili ambulantni gips iznad 10 godina',
	name_sr_cyrl = 'Гипс за кретање или амбулантни гипс изнад 10 година',
	name_ru = 'Гипс для ходьбы или амбулаторный гипс старше 10 лет',
	name_tr = '10 yaş üstü yürüme alçısı veya ambulatuvar alçı'
 WHERE slug = 'walking-or-ambulatory-plaster-cast-over-10-years';

UPDATE medical_services SET
	name_sr = 'Gips za kretanje ili ambulantni gips ispod 10 godina',
	name_sr_cyrl = 'Гипс за кретање или амбулантни гипс испод 10 година',
	name_ru = 'Гипс для ходьбы или амбулаторный гипс до 10 лет',
	name_tr = '10 yaş altı yürüme alçısı veya ambulatuvar alçı'
 WHERE slug = 'walking-or-ambulatory-plaster-cast-under-10-years';

UPDATE medical_services SET
	name_de = 'Herstellung gewaschener Erythrozyten'
 WHERE slug = 'washed-erythrocyte-preparation';

UPDATE medical_services SET
	name_en = 'Plain X-Ray of the Abdomen',
	name_sr = 'Rendgen abdomena – nativni snimak',
	name_sr_cyrl = 'Рендген абдомена – нативни снимак',
	name_tr = 'Direkt Karın Röntgeni'
 WHERE slug = 'x-ray-abdomen-native';

UPDATE medical_services SET
	name_sr = 'Rendgen oba skočna zgloba',
	name_sr_cyrl = 'Рендген оба скочна зглоба',
	name_de = 'Röntgen beider Sprunggelenke'
 WHERE slug = 'x-ray-both-ankles';

UPDATE medical_services SET
	name_sr = 'Rendgen oba lakta',
	name_sr_cyrl = 'Рендген оба лакта',
	name_ru = 'Рентген обоих локтевых суставов',
	name_de = 'Röntgen beider Ellenbogen'
 WHERE slug = 'x-ray-both-elbows';

UPDATE medical_services SET
	name_sr = 'Rendgen oba stopala',
	name_sr_cyrl = 'Рендген оба стопала',
	name_de = 'Röntgen beider Füße'
 WHERE slug = 'x-ray-both-feet';

UPDATE medical_services SET
	name_sr = 'Rendgen obje podlaktice',
	name_sr_cyrl = 'RTG обје подлактице',
	name_de = 'Röntgen beider Unterarme'
 WHERE slug = 'x-ray-both-forearms';

UPDATE medical_services SET
	name_sr = 'Rendgen obje šake',
	name_sr_cyrl = 'RTG обје шаке',
	name_de = 'Röntgen beider Hände'
 WHERE slug = 'x-ray-both-hands';

UPDATE medical_services SET
	name_sr = 'Rendgen obje pete',
	name_sr_cyrl = 'Рендген обје пете',
	name_de = 'Röntgen beider Fersen'
 WHERE slug = 'x-ray-both-heels';

UPDATE medical_services SET
	name_de = 'Röntgen beider Knie'
 WHERE slug = 'x-ray-both-knees';

UPDATE medical_services SET
	name_sr = 'Rendgen obje potkoljenice',
	name_sr_cyrl = 'RTG обје поткољенице',
	name_de = 'Röntgen beider Unterschenkel'
 WHERE slug = 'x-ray-both-lower-legs';

UPDATE medical_services SET
	name_sr = 'Rendgen obje natkoljenice',
	name_sr_cyrl = 'Рендген обје наткољенице',
	name_de = 'Röntgen beider Oberschenkel'
 WHERE slug = 'x-ray-both-thighs';

UPDATE medical_services SET
	name_sr = 'Rendgen obje nadlaktice',
	name_sr_cyrl = 'RTG обје надлактице',
	name_de = 'Röntgen beider Oberarme'
 WHERE slug = 'x-ray-both-upper-arms';

UPDATE medical_services SET
	name_de = 'Röntgen beider Handgelenke'
 WHERE slug = 'x-ray-both-wrists';

UPDATE medical_services SET
	name_en = 'X-Ray Lungs and Heart'
 WHERE slug = 'x-ray-chest-heart';

UPDATE medical_services SET
	name_ru = 'Рентген локтевого сустава'
 WHERE slug = 'x-ray-elbow';

UPDATE medical_services SET
	name_ru = 'Рентген костей лица с боковыми проекциями',
	name_de = 'Röntgen Gesichtsknochen mit seitlichen Aufnahmen'
 WHERE slug = 'x-ray-facial-bones-with-profiles';

UPDATE medical_services SET
	name_sr = 'Rendgen podlaktice'
 WHERE slug = 'x-ray-forearm';

UPDATE medical_services SET
	name_sr = 'Rendgen cijele kičme',
	name_sr_cyrl = 'Рендген цијеле кичме'
 WHERE slug = 'x-ray-full-spine';

UPDATE medical_services SET
	name_sr = 'Rendgen šake',
	name_sr_cyrl = 'RTG шаке'
 WHERE slug = 'x-ray-hand';

UPDATE medical_services SET
	name_sr = 'Rendgen pete',
	name_sr_cyrl = 'Рендген пете'
 WHERE slug = 'x-ray-heel';

UPDATE medical_services SET
	name_en = 'X-Ray Mastoid (Schüller View)',
	name_sr = 'Rendgen mastoida (Schüller)',
	name_sr_cyrl = 'Рендген мастоида (Сцхüллер)',
	name_ru = 'Рентген сосцевидного отростка по Шюллеру',
	name_tr = 'Mastoid Röntgeni (Schüller)'
 WHERE slug = 'x-ray-mastoid-shuller';

UPDATE medical_services SET
	name_en = 'X-Ray Maxilla, Mandible and TMJ',
	name_sr = 'Rendgen maksile, mandibule i temporomandibularnog zgloba',
	name_sr_cyrl = 'Рендген максиле, mandibule и темпоромандибуларног зглоба',
	name_tr = 'Üst Çene, Alt Çene ve TME Röntgeni'
 WHERE slug = 'x-ray-maxilla-mandible-tmj';

UPDATE medical_services SET
	name_sr = 'Rendgen maksilarnih sinusa',
	name_sr_cyrl = 'Рендген максиларних синуса'
 WHERE slug = 'x-ray-maxillary-sinuses';

UPDATE medical_services SET
	name_sr = 'Rendgen nosa - profili',
	name_sr_cyrl = 'Рендген носа - профили',
	name_ru = 'Рентген носа в боковых проекциях',
	name_de = 'Röntgen Nase (seitliche Aufnahmen)'
 WHERE slug = 'x-ray-nose-profiles';

UPDATE medical_services SET
	name_sr = 'Rendgen nosa sa profilima',
	name_sr_cyrl = 'Рендген носа са профилима',
	name_ru = 'Рентген носа с боковыми проекциями',
	name_de = 'Röntgen Nase mit seitlichen Aufnahmen'
 WHERE slug = 'x-ray-nose-with-profiles';

UPDATE medical_services SET
	name_en = 'X-Ray Optic Canal (Rhese View)',
	name_sr = 'Rendgen optičkog kanala - Rhese projekcija',
	name_sr_cyrl = 'Рендген оптичког канала - Rhese пројекција',
	name_ru = 'Рентген канала зрительного нерва по Резе',
	name_de = 'Röntgen Optikuskanal (Rhese-Projektion)',
	name_tr = 'Optik Kanal Röntgeni (Rhese)'
 WHERE slug = 'x-ray-optic-canal-rhese';

UPDATE medical_services SET
	name_sr = 'Rendgen orbita (očnih duplji)',
	name_sr_cyrl = 'Рендген орбита (очних дупљи)'
 WHERE slug = 'x-ray-orbits';

UPDATE medical_services SET
	name_sr = 'Rendgen sele turcike',
	name_sr_cyrl = 'RTG селе турцике'
 WHERE slug = 'x-ray-sella-turcica';

UPDATE medical_services SET
	name_ru = 'Рентген плечевого сустава'
 WHERE slug = 'x-ray-shoulder';

UPDATE medical_services SET
	name_sr = 'Rendgen sinusa sa profilima',
	name_sr_cyrl = 'Рендген синуса са профилима',
	name_ru = 'Рентген околоносовых пазух с боковыми проекциями',
	name_de = 'Röntgen Nasennebenhöhlen mit seitlichen Aufnahmen'
 WHERE slug = 'x-ray-sinuses-with-profiles';

UPDATE medical_services SET
	name_en = 'X-Ray Skull (Towne and Altschul Views)',
	name_sr = 'Rendgen lobanje (Towne i Altschul)',
	name_sr_cyrl = 'Рендген лобање (Towne и Altschul)',
	name_ru = 'Рентген черепа (Towne и Altschul)',
	name_de = 'Röntgen Schädel (Towne und Altschul)',
	name_tr = 'Kafatası Röntgeni (Towne ve Altschul)'
 WHERE slug = 'x-ray-skull-towne-altchul';

UPDATE medical_services SET
	name_en = 'X-Ray Temporal Bones (Petrous Pyramids, Mayer and Stenvers Views)',
	name_sr = 'Rendgen temporalnih kostiju - piramide (Mayer, Stenvers)',
	name_sr_cyrl = 'Рендген темпоралних костију - пирамиде (Mayer, Stenvers)',
	name_ru = 'Рентген височных костей (пирамид) по Майеру и Стенверсу',
	name_de = 'Röntgen Schläfenbeine – Felsenbeinpyramiden (Mayer, Stenvers)',
	name_tr = 'Temporal Kemik Röntgeni – Petröz Piramit (Mayer, Stenvers)'
 WHERE slug = 'x-ray-temporal-bones';

UPDATE medical_services SET
	name_sr = 'Rendgen natkoljenice',
	name_sr_cyrl = 'Рендген наткољенице'
 WHERE slug = 'x-ray-thigh';

UPDATE medical_services SET
	name_sr = 'Rendgen urotrakta',
	name_sr_cyrl = 'Рендген уротракта'
 WHERE slug = 'x-ray-urinary-tract';

UPDATE medical_services SET
	name_en = 'Plain X-Ray of the Urinary Tract',
	name_ru = 'Обзорный рентген мочевыводящих путей',
	name_tr = 'Direkt Üriner Sistem Röntgeni'
 WHERE slug = 'x-ray-urinary-tract-native';

UPDATE medical_services SET
	name_en = 'Xanthelasma Removal Around the Eyes',
	name_de = 'Entfernung von Xanthelasmen im Augenbereich'
 WHERE slug = 'xanthelasma-removal-eye-area';

UPDATE medical_services SET
	name_ru = 'Циркониевая коронка с керамической облицовкой',
	name_tr = 'Seramik Kaplamalı Zirkonyum Kron'
 WHERE slug = 'zirconia-crown-with-veneer';

UPDATE medical_services SET
	name_sr = 'Višeslojna cirkonijum krunica',
	name_sr_cyrl = 'Вишеслојна цирконијум круница',
	name_de = 'Multilayer-Zirkonkrone',
	name_tr = 'Çok Katmanlı Zirkonyum Kron'
 WHERE slug = 'zirconia-multilayer-crown';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Вывих акромиального конца ключицы', 'ru' FROM medical_services WHERE slug = 'acromioclavicular-joint-dislocation-open-or-closed'
UNION ALL SELECT id, 'Schultereckgelenksprengung', 'de' FROM medical_services WHERE slug = 'acromioclavicular-joint-dislocation-open-or-closed';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Habitualna luksacija ramena', 'sr' FROM medical_services WHERE slug = 'anterior-capsulorrhaphy-for-recurrent-shoulder-dislocation'
UNION ALL SELECT id, 'Хабитуална луксација рамена', 'sr-cyrl' FROM medical_services WHERE slug = 'anterior-capsulorrhaphy-for-recurrent-shoulder-dislocation'
UNION ALL SELECT id, 'Привычный вывих плеча', 'ru' FROM medical_services WHERE slug = 'anterior-capsulorrhaphy-for-recurrent-shoulder-dislocation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Arthrotomy with Exploration and Drainage', 'en' FROM medical_services WHERE slug = 'arthrotomy-with-exploration-and-drainage';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Beller Apparatus Application', 'en' FROM medical_services WHERE slug = 'beller-apparatus-application';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Transtibial Amputation', 'en' FROM medical_services WHERE slug = 'below-knee-amputation-through-tibia-and-fibula'
UNION ALL SELECT id, 'Amputacija potkoljenice', 'sr' FROM medical_services WHERE slug = 'below-knee-amputation-through-tibia-and-fibula'
UNION ALL SELECT id, 'Ампутација поткољенице', 'sr-cyrl' FROM medical_services WHERE slug = 'below-knee-amputation-through-tibia-and-fibula'
UNION ALL SELECT id, 'Diz altı amputasyon', 'tr' FROM medical_services WHERE slug = 'below-knee-amputation-through-tibia-and-fibula';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Перелом большого пальца ноги', 'ru' FROM medical_services WHERE slug = 'big-toe-phalanx-fracture-reduction'
UNION ALL SELECT id, 'Großzehenbruch', 'de' FROM medical_services WHERE slug = 'big-toe-phalanx-fracture-reduction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Двухлодыжечный перелом', 'ru' FROM medical_services WHERE slug = 'bimalleolar-ankle-fracture-open-or-closed-withwithout-fixation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Heel Bone Fracture', 'en' FROM medical_services WHERE slug = 'calcaneus-fracture-open-or-closed'
UNION ALL SELECT id, 'Prelom petne kosti', 'sr' FROM medical_services WHERE slug = 'calcaneus-fracture-open-or-closed'
UNION ALL SELECT id, 'Прелом петне кости', 'sr-cyrl' FROM medical_services WHERE slug = 'calcaneus-fracture-open-or-closed'
UNION ALL SELECT id, 'Перелом пяточной кости', 'ru' FROM medical_services WHERE slug = 'calcaneus-fracture-open-or-closed'
UNION ALL SELECT id, 'Fersenbeinbruch', 'de' FROM medical_services WHERE slug = 'calcaneus-fracture-open-or-closed'
UNION ALL SELECT id, 'Topuk kemiği kırığı', 'tr' FROM medical_services WHERE slug = 'calcaneus-fracture-open-or-closed';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Capsulotomy or Capsuloplasty for Contracture', 'en' FROM medical_services WHERE slug = 'capsulotomy-or-capsuloplasty-for-contracture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Capsulotomy/Capsuloplasty for Interphalangeal Contracture', 'en' FROM medical_services WHERE slug = 'capsulotomycapsuloplasty-for-interphalangeal-contracture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Chopart Amputation', 'en' FROM medical_services WHERE slug = 'chopart-tarsal-amputation'
UNION ALL SELECT id, 'Amputacija po Šoparu', 'sr' FROM medical_services WHERE slug = 'chopart-tarsal-amputation'
UNION ALL SELECT id, 'Ампутација по Шопару', 'sr-cyrl' FROM medical_services WHERE slug = 'chopart-tarsal-amputation'
UNION ALL SELECT id, 'Ампутация по Шопару', 'ru' FROM medical_services WHERE slug = 'chopart-tarsal-amputation'
UNION ALL SELECT id, 'Chopart-Amputation', 'de' FROM medical_services WHERE slug = 'chopart-tarsal-amputation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Broken Collarbone', 'en' FROM medical_services WHERE slug = 'clavicle-fracture-closed-or-open-withwithout-fixation'
UNION ALL SELECT id, 'Prelom ključne kosti', 'sr' FROM medical_services WHERE slug = 'clavicle-fracture-closed-or-open-withwithout-fixation'
UNION ALL SELECT id, 'Прелом кључне кости', 'sr-cyrl' FROM medical_services WHERE slug = 'clavicle-fracture-closed-or-open-withwithout-fixation'
UNION ALL SELECT id, 'Перелом ключицы', 'ru' FROM medical_services WHERE slug = 'clavicle-fracture-closed-or-open-withwithout-fixation'
UNION ALL SELECT id, 'Schlüsselbeinbruch', 'de' FROM medical_services WHERE slug = 'clavicle-fracture-closed-or-open-withwithout-fixation'
UNION ALL SELECT id, 'Köprücük kemiği kırığı', 'tr' FROM medical_services WHERE slug = 'clavicle-fracture-closed-or-open-withwithout-fixation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Closed Joint Reduction with Mobilization', 'en' FROM medical_services WHERE slug = 'closed-joint-reduction-with-mobilization';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Closed Manipulation Reduction of Distal Tibia Fracture', 'en' FROM medical_services WHERE slug = 'closed-manipulation-reduction-of-distal-tibia-fracture'
UNION ALL SELECT id, 'Перелом лодыжки', 'ru' FROM medical_services WHERE slug = 'closed-manipulation-reduction-of-distal-tibia-fracture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Closed Manipulation Reduction of Proximal End Fracture', 'en' FROM medical_services WHERE slug = 'closed-manipulation-reduction-of-proximal-end-fracture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Prelom vrata butne kosti', 'sr' FROM medical_services WHERE slug = 'closed-manipulative-reduction-of-femoral-neck-fracture'
UNION ALL SELECT id, 'Прелом врата бутне кости', 'sr-cyrl' FROM medical_services WHERE slug = 'closed-manipulative-reduction-of-femoral-neck-fracture'
UNION ALL SELECT id, 'Перелом шейки бедра', 'ru' FROM medical_services WHERE slug = 'closed-manipulative-reduction-of-femoral-neck-fracture'
UNION ALL SELECT id, 'Oberschenkelhalsbruch', 'de' FROM medical_services WHERE slug = 'closed-manipulative-reduction-of-femoral-neck-fracture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Closed Reduction of Sacroiliac Joint Dislocation', 'en' FROM medical_services WHERE slug = 'closed-reduction-of-sacroiliac-joint-dislocation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Перелом ногтевой фаланги пальца', 'ru' FROM medical_services WHERE slug = 'distal-phalanx-fracture-manipulation-reduction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Distal Radial Epiphysis Fracture (Open or Closed Reduction)', 'en' FROM medical_services WHERE slug = 'distal-radial-epiphysis-fracture-open-or-closed-reduction'
UNION ALL SELECT id, 'Colles Fracture', 'en' FROM medical_services WHERE slug = 'distal-radial-epiphysis-fracture-open-or-closed-reduction'
UNION ALL SELECT id, 'Prelom radijusa na tipičnom mjestu', 'sr' FROM medical_services WHERE slug = 'distal-radial-epiphysis-fracture-open-or-closed-reduction'
UNION ALL SELECT id, 'Прелом радијуса на типичном мјесту', 'sr-cyrl' FROM medical_services WHERE slug = 'distal-radial-epiphysis-fracture-open-or-closed-reduction'
UNION ALL SELECT id, 'Перелом лучевой кости в типичном месте', 'ru' FROM medical_services WHERE slug = 'distal-radial-epiphysis-fracture-open-or-closed-reduction'
UNION ALL SELECT id, 'Distale Radiusfraktur', 'de' FROM medical_services WHERE slug = 'distal-radial-epiphysis-fracture-open-or-closed-reduction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Разрыв межберцового синдесмоза', 'ru' FROM medical_services WHERE slug = 'distal-tibiofibular-joint-dislocation'
UNION ALL SELECT id, 'Syndesmosenverletzung', 'de' FROM medical_services WHERE slug = 'distal-tibiofibular-joint-dislocation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Удаление гигромы стопы', 'ru' FROM medical_services WHERE slug = 'excision-of-tendon-sheath-or-capsule-lesion-cyst-ganglion'
UNION ALL SELECT id, 'Überbein am Fuß', 'de' FROM medical_services WHERE slug = 'excision-of-tendon-sheath-or-capsule-lesion-cyst-ganglion';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Fibula Fracture Reduction with/without Fixation', 'en' FROM medical_services WHERE slug = 'fibula-fracture-reduction-withwithout-fixation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Finger Amputation at Any Phalanx', 'en' FROM medical_services WHERE slug = 'finger-amputation-at-any-phalanx';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Initial Orthopedic Consultation', 'en' FROM medical_services WHERE slug = 'first-orthopedist-examination'
UNION ALL SELECT id, 'Первичный приём ортопеда', 'ru' FROM medical_services WHERE slug = 'first-orthopedist-examination'
UNION ALL SELECT id, 'Первичная консультация ортопеда', 'ru' FROM medical_services WHERE slug = 'first-orthopedist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ponovni pregled reumatologa', 'sr' FROM medical_services WHERE slug = 'follow-up-rheumatologist-examination'
UNION ALL SELECT id, 'Поновни преглед реуматолога', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-rheumatologist-examination'
UNION ALL SELECT id, 'Повторный осмотр ревматолога', 'ru' FROM medical_services WHERE slug = 'follow-up-rheumatologist-examination'
UNION ALL SELECT id, 'Повторный приём ревматолога', 'ru' FROM medical_services WHERE slug = 'follow-up-rheumatologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Transradial Amputation', 'en' FROM medical_services WHERE slug = 'forearm-amputation-through-radius-and-ulna'
UNION ALL SELECT id, 'Dirsek altı amputasyon', 'tr' FROM medical_services WHERE slug = 'forearm-amputation-through-radius-and-ulna';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Guillotine Hand Amputation', 'en' FROM medical_services WHERE slug = 'guillotine-hand-amputation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Bunion Surgery', 'en' FROM medical_services WHERE slug = 'hallux-valgus-correction-with-metatarsal-osteotomy'
UNION ALL SELECT id, 'Haluks valgus', 'sr' FROM medical_services WHERE slug = 'hallux-valgus-correction-with-metatarsal-osteotomy'
UNION ALL SELECT id, 'Халукс валгус', 'sr-cyrl' FROM medical_services WHERE slug = 'hallux-valgus-correction-with-metatarsal-osteotomy'
UNION ALL SELECT id, 'Operacija čukljeva', 'sr' FROM medical_services WHERE slug = 'hallux-valgus-correction-with-metatarsal-osteotomy'
UNION ALL SELECT id, 'Операција чукљева', 'sr-cyrl' FROM medical_services WHERE slug = 'hallux-valgus-correction-with-metatarsal-osteotomy'
UNION ALL SELECT id, 'Вальгусная деформация большого пальца стопы', 'ru' FROM medical_services WHERE slug = 'hallux-valgus-correction-with-metatarsal-osteotomy'
UNION ALL SELECT id, 'Операция на косточке большого пальца', 'ru' FROM medical_services WHERE slug = 'hallux-valgus-correction-with-metatarsal-osteotomy'
UNION ALL SELECT id, 'Ballenzeh-Operation', 'de' FROM medical_services WHERE slug = 'hallux-valgus-correction-with-metatarsal-osteotomy'
UNION ALL SELECT id, 'Halluks valgus ameliyatı', 'tr' FROM medical_services WHERE slug = 'hallux-valgus-correction-with-metatarsal-osteotomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hallux Valgus Correction with X-Ostectomy', 'en' FROM medical_services WHERE slug = 'hallux-valgus-correction-with-x-ostectomy'
UNION ALL SELECT id, 'Bunionectomy', 'en' FROM medical_services WHERE slug = 'hallux-valgus-correction-with-x-ostectomy'
UNION ALL SELECT id, 'Haluks valgus', 'sr' FROM medical_services WHERE slug = 'hallux-valgus-correction-with-x-ostectomy'
UNION ALL SELECT id, 'Халукс валгус', 'sr-cyrl' FROM medical_services WHERE slug = 'hallux-valgus-correction-with-x-ostectomy'
UNION ALL SELECT id, 'Вальгусная деформация большого пальца стопы', 'ru' FROM medical_services WHERE slug = 'hallux-valgus-correction-with-x-ostectomy'
UNION ALL SELECT id, 'Удаление косточки на большом пальце стопы', 'ru' FROM medical_services WHERE slug = 'hallux-valgus-correction-with-x-ostectomy'
UNION ALL SELECT id, 'Ballenzeh-Operation', 'de' FROM medical_services WHERE slug = 'hallux-valgus-correction-with-x-ostectomy'
UNION ALL SELECT id, 'Halluks valgus ameliyatı', 'tr' FROM medical_services WHERE slug = 'hallux-valgus-correction-with-x-ostectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Humerus Diaphysis Fracture (Closed or Open Reduction)', 'en' FROM medical_services WHERE slug = 'humerus-diaphysis-fracture-closed-or-open-reduction'
UNION ALL SELECT id, 'Остеосинтез диафиза плечевой кости', 'ru' FROM medical_services WHERE slug = 'humerus-diaphysis-fracture-closed-or-open-reduction'
UNION ALL SELECT id, 'Oberarmschaftbruch', 'de' FROM medical_services WHERE slug = 'humerus-diaphysis-fracture-closed-or-open-reduction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Вертельный перелом бедра', 'ru' FROM medical_services WHERE slug = 'intertrochanteric-or-peritrochanteric-fracture'
UNION ALL SELECT id, 'Остеосинтез вертельного перелома', 'ru' FROM medical_services WHERE slug = 'intertrochanteric-or-peritrochanteric-fracture'
UNION ALL SELECT id, 'Pertrochantäre Femurfraktur', 'de' FROM medical_services WHERE slug = 'intertrochanteric-or-peritrochanteric-fracture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Knee Arthrotomy (Capsulotomy) with Exploration and Foreign Body Removal', 'en' FROM medical_services WHERE slug = 'knee-arthrotomy-capsulotomy-with-exploration-and-foreign-body-removal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Iščašenje koljena', 'sr' FROM medical_services WHERE slug = 'knee-dislocation-closed-or-open-reduction-withwithout-fixation'
UNION ALL SELECT id, 'Ишчашење кољена', 'sr-cyrl' FROM medical_services WHERE slug = 'knee-dislocation-closed-or-open-reduction-withwithout-fixation'
UNION ALL SELECT id, 'Вывих колена', 'ru' FROM medical_services WHERE slug = 'knee-dislocation-closed-or-open-reduction-withwithout-fixation'
UNION ALL SELECT id, 'Diz çıkığı', 'tr' FROM medical_services WHERE slug = 'knee-dislocation-closed-or-open-reduction-withwithout-fixation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Tennis Elbow Surgery', 'en' FROM medical_services WHERE slug = 'lateral-or-medial-fasciotomy-tennis-elbow'
UNION ALL SELECT id, 'Operacija teniskog lakta', 'sr' FROM medical_services WHERE slug = 'lateral-or-medial-fasciotomy-tennis-elbow'
UNION ALL SELECT id, 'Операција тениског лакта', 'sr-cyrl' FROM medical_services WHERE slug = 'lateral-or-medial-fasciotomy-tennis-elbow'
UNION ALL SELECT id, 'Операция при эпикондилите', 'ru' FROM medical_services WHERE slug = 'lateral-or-medial-fasciotomy-tennis-elbow'
UNION ALL SELECT id, 'Tennisarm-Operation', 'de' FROM medical_services WHERE slug = 'lateral-or-medial-fasciotomy-tennis-elbow'
UNION ALL SELECT id, 'Tenisçi dirseği ameliyatı', 'tr' FROM medical_services WHERE slug = 'lateral-or-medial-fasciotomy-tennis-elbow';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Manipulative Reduction of Open Distal Fracture', 'en' FROM medical_services WHERE slug = 'manipulative-reduction-of-open-distal-fracture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Manipulative Reduction of Open Distal Fracture (Variant)', 'en' FROM medical_services WHERE slug = 'manipulative-reduction-of-open-distal-fracture-variant';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Manipulative Reduction of Open Iliac/Pubic Fracture', 'en' FROM medical_services WHERE slug = 'manipulative-reduction-of-open-iliacpubic-fracture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Medial or Lateral Femoral Condyle Fracture (Open Reduction)', 'en' FROM medical_services WHERE slug = 'medial-or-lateral-femoral-condyle-fracture-open-reduction'
UNION ALL SELECT id, 'Перелом мыщелка бедра', 'ru' FROM medical_services WHERE slug = 'medial-or-lateral-femoral-condyle-fracture-open-reduction'
UNION ALL SELECT id, 'Остеосинтез мыщелка бедренной кости', 'ru' FROM medical_services WHERE slug = 'medial-or-lateral-femoral-condyle-fracture-open-reduction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Monteggia Elbow Fracture (Proximal End)', 'en' FROM medical_services WHERE slug = 'monteggia-elbow-fracture-proximal-end';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Navicular Pseudarthrosis Repair with/without Bone Graft', 'en' FROM medical_services WHERE slug = 'navicular-pseudarthrosis-repair-withwithout-bone-graft'
UNION ALL SELECT id, 'Scaphoid Nonunion Repair', 'en' FROM medical_services WHERE slug = 'navicular-pseudarthrosis-repair-withwithout-bone-graft'
UNION ALL SELECT id, 'Pseudoartroza skafoidne kosti', 'sr' FROM medical_services WHERE slug = 'navicular-pseudarthrosis-repair-withwithout-bone-graft'
UNION ALL SELECT id, 'Псеудоартроза скафоидне кости', 'sr-cyrl' FROM medical_services WHERE slug = 'navicular-pseudarthrosis-repair-withwithout-bone-graft'
UNION ALL SELECT id, 'Ложный сустав ладьевидной кости', 'ru' FROM medical_services WHERE slug = 'navicular-pseudarthrosis-repair-withwithout-bone-graft'
UNION ALL SELECT id, 'Skafoid psödoartrozu', 'tr' FROM medical_services WHERE slug = 'navicular-pseudarthrosis-repair-withwithout-bone-graft';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kneecap Fracture', 'en' FROM medical_services WHERE slug = 'open-reduction-of-patellar-fracture-with-repair'
UNION ALL SELECT id, 'Prelom čašice koljena', 'sr' FROM medical_services WHERE slug = 'open-reduction-of-patellar-fracture-with-repair'
UNION ALL SELECT id, 'Прелом чашице кољена', 'sr-cyrl' FROM medical_services WHERE slug = 'open-reduction-of-patellar-fracture-with-repair'
UNION ALL SELECT id, 'Перелом коленной чашечки', 'ru' FROM medical_services WHERE slug = 'open-reduction-of-patellar-fracture-with-repair'
UNION ALL SELECT id, 'Kniescheibenbruch', 'de' FROM medical_services WHERE slug = 'open-reduction-of-patellar-fracture-with-repair'
UNION ALL SELECT id, 'Diz kapağı kırığı', 'tr' FROM medical_services WHERE slug = 'open-reduction-of-patellar-fracture-with-repair';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Open Reduction of Radius and Ulna Diaphysis Fracture', 'en' FROM medical_services WHERE slug = 'open-reduction-of-radius-and-ulna-diaphysis-fracture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Partial Bone Excision (Curettage, Sequestrectomy or)', 'en' FROM medical_services WHERE slug = 'partial-bone-excision-curettage-sequestrectomy-or';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kneecap Dislocation', 'en' FROM medical_services WHERE slug = 'patellar-dislocation-closed-or-open-reduction'
UNION ALL SELECT id, 'Iščašenje patele', 'sr' FROM medical_services WHERE slug = 'patellar-dislocation-closed-or-open-reduction'
UNION ALL SELECT id, 'Ишчашење пателе', 'sr-cyrl' FROM medical_services WHERE slug = 'patellar-dislocation-closed-or-open-reduction'
UNION ALL SELECT id, 'Вывих коленной чашечки', 'ru' FROM medical_services WHERE slug = 'patellar-dislocation-closed-or-open-reduction'
UNION ALL SELECT id, 'Kniescheibenluxation', 'de' FROM medical_services WHERE slug = 'patellar-dislocation-closed-or-open-reduction'
UNION ALL SELECT id, 'Diz kapağı çıkığı', 'tr' FROM medical_services WHERE slug = 'patellar-dislocation-closed-or-open-reduction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cast Removal', 'en' FROM medical_services WHERE slug = 'plaster-cast-or-splint-removal'
UNION ALL SELECT id, 'Снять гипс', 'ru' FROM medical_services WHERE slug = 'plaster-cast-or-splint-removal'
UNION ALL SELECT id, 'Снятие гипсовой повязки', 'ru' FROM medical_services WHERE slug = 'plaster-cast-or-splint-removal'
UNION ALL SELECT id, 'Gipsabnahme', 'de' FROM medical_services WHERE slug = 'plaster-cast-or-splint-removal'
UNION ALL SELECT id, 'Alçı çıkarma', 'tr' FROM medical_services WHERE slug = 'plaster-cast-or-splint-removal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Plaster Splint for Hand and Fingers', 'en' FROM medical_services WHERE slug = 'plaster-splint-for-hand-and-fingers';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Primary Nerve Repair', 'en' FROM medical_services WHERE slug = 'primary-peripheral-nerve-neurorrhaphy'
UNION ALL SELECT id, 'Primarni šav živca', 'sr' FROM medical_services WHERE slug = 'primary-peripheral-nerve-neurorrhaphy'
UNION ALL SELECT id, 'Примарни шав живца', 'sr-cyrl' FROM medical_services WHERE slug = 'primary-peripheral-nerve-neurorrhaphy'
UNION ALL SELECT id, 'Первичный шов нерва', 'ru' FROM medical_services WHERE slug = 'primary-peripheral-nerve-neurorrhaphy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Primary Suture of Ruptured Collateral Ligament', 'en' FROM medical_services WHERE slug = 'primary-suture-of-ruptured-collateral-ligament'
UNION ALL SELECT id, 'Ankle Ligament Repair', 'en' FROM medical_services WHERE slug = 'primary-suture-of-ruptured-collateral-ligament'
UNION ALL SELECT id, 'Šav ligamenta gležnja', 'sr' FROM medical_services WHERE slug = 'primary-suture-of-ruptured-collateral-ligament'
UNION ALL SELECT id, 'Шав лигамента глежња', 'sr-cyrl' FROM medical_services WHERE slug = 'primary-suture-of-ruptured-collateral-ligament'
UNION ALL SELECT id, 'Шов связки голеностопа', 'ru' FROM medical_services WHERE slug = 'primary-suture-of-ruptured-collateral-ligament';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Шов локтевого нерва', 'ru' FROM medical_services WHERE slug = 'primary-ulnar-or-median-nerve-neurorrhaphy'
UNION ALL SELECT id, 'Шов срединного нерва', 'ru' FROM medical_services WHERE slug = 'primary-ulnar-or-median-nerve-neurorrhaphy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Proximal Phalanx Big Toe Osteotomy for Shortening or Rotation', 'en' FROM medical_services WHERE slug = 'proximal-phalanx-big-toe-osteotomy-for-shortening-or-rotation'
UNION ALL SELECT id, 'Akin Osteotomy', 'en' FROM medical_services WHERE slug = 'proximal-phalanx-big-toe-osteotomy-for-shortening-or-rotation'
UNION ALL SELECT id, 'Остеотомия по Акину', 'ru' FROM medical_services WHERE slug = 'proximal-phalanx-big-toe-osteotomy-for-shortening-or-rotation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Vežbe protiv otpora', 'sr' FROM medical_services WHERE slug = 'active-and-resistance-exercises'
UNION ALL SELECT id, 'Вежбе против отпора', 'sr-cyrl' FROM medical_services WHERE slug = 'active-and-resistance-exercises';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'ADL Training', 'en' FROM medical_services WHERE slug = 'activities-of-daily-living-training'
UNION ALL SELECT id, 'Обучение навыкам самообслуживания', 'ru' FROM medical_services WHERE slug = 'activities-of-daily-living-training';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Aparatna masaža', 'sr' FROM medical_services WHERE slug = 'apparatus-assisted-massage'
UNION ALL SELECT id, 'Апаратна масажа', 'sr-cyrl' FROM medical_services WHERE slug = 'apparatus-assisted-massage';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Diadinamske struje', 'sr' FROM medical_services WHERE slug = 'diadynamic-currents'
UNION ALL SELECT id, 'Диадинамске струје', 'sr-cyrl' FROM medical_services WHERE slug = 'diadynamic-currents'
UNION ALL SELECT id, 'DD struje', 'sr' FROM medical_services WHERE slug = 'diadynamic-currents'
UNION ALL SELECT id, 'ДД струје', 'sr-cyrl' FROM medical_services WHERE slug = 'diadynamic-currents'
UNION ALL SELECT id, 'Диадинамотерапия', 'ru' FROM medical_services WHERE slug = 'diadynamic-currents'
UNION ALL SELECT id, 'Токи Бернара', 'ru' FROM medical_services WHERE slug = 'diadynamic-currents';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Vežbe na spravama', 'sr' FROM medical_services WHERE slug = 'exercises-on-equipment-pulley-ergocycle-cpm-suspension'
UNION ALL SELECT id, 'Вежбе на справама', 'sr-cyrl' FROM medical_services WHERE slug = 'exercises-on-equipment-pulley-ergocycle-cpm-suspension'
UNION ALL SELECT id, 'Krankengymnastik am Gerät', 'de' FROM medical_services WHERE slug = 'exercises-on-equipment-pulley-ergocycle-cpm-suspension';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Fizijatar – prvi pregled', 'sr' FROM medical_services WHERE slug = 'first-physiatrist-examination'
UNION ALL SELECT id, 'Физијатар – први преглед', 'sr-cyrl' FROM medical_services WHERE slug = 'first-physiatrist-examination'
UNION ALL SELECT id, 'Первичный осмотр физиатра', 'ru' FROM medical_services WHERE slug = 'first-physiatrist-examination'
UNION ALL SELECT id, 'Первичный приём реабилитолога', 'ru' FROM medical_services WHERE slug = 'first-physiatrist-examination'
UNION ALL SELECT id, 'Erstuntersuchung beim Physiater', 'de' FROM medical_services WHERE slug = 'first-physiatrist-examination'
UNION ALL SELECT id, 'Fizik tedavi doktoru ilk muayenesi', 'tr' FROM medical_services WHERE slug = 'first-physiatrist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Prvi pregled fizijatra za decu sa posebnim potrebama', 'sr' FROM medical_services WHERE slug = 'first-physiatrist-examination-for-children-with-special-needs'
UNION ALL SELECT id, 'Први преглед физијатра за децу са посебним потребама', 'sr-cyrl' FROM medical_services WHERE slug = 'first-physiatrist-examination-for-children-with-special-needs'
UNION ALL SELECT id, 'Первичный осмотр детского реабилитолога', 'ru' FROM medical_services WHERE slug = 'first-physiatrist-examination-for-children-with-special-needs';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Fizijatar – kontrolni pregled', 'sr' FROM medical_services WHERE slug = 'follow-up-physiatrist-examination'
UNION ALL SELECT id, 'Физијатар – контролни преглед', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-physiatrist-examination'
UNION ALL SELECT id, 'Ponovni pregled fizijatra', 'sr' FROM medical_services WHERE slug = 'follow-up-physiatrist-examination'
UNION ALL SELECT id, 'Поновни преглед физијатра', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-physiatrist-examination'
UNION ALL SELECT id, 'Повторный осмотр физиатра', 'ru' FROM medical_services WHERE slug = 'follow-up-physiatrist-examination'
UNION ALL SELECT id, 'Повторный приём реабилитолога', 'ru' FROM medical_services WHERE slug = 'follow-up-physiatrist-examination'
UNION ALL SELECT id, 'Kontrolluntersuchung beim Physiater', 'de' FROM medical_services WHERE slug = 'follow-up-physiatrist-examination'
UNION ALL SELECT id, 'Fizik tedavi doktoru kontrol muayenesi', 'tr' FROM medical_services WHERE slug = 'follow-up-physiatrist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kontrolni pregled fizijatra za decu sa posebnim potrebama', 'sr' FROM medical_services WHERE slug = 'follow-up-physiatrist-examination-for-children-with-special-needs'
UNION ALL SELECT id, 'Контролни преглед физијатра за децу са посебним потребама', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-physiatrist-examination-for-children-with-special-needs'
UNION ALL SELECT id, 'Повторный осмотр детского реабилитолога', 'ru' FROM medical_services WHERE slug = 'follow-up-physiatrist-examination-for-children-with-special-needs';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'HBOT', 'en' FROM medical_services WHERE slug = 'hyperbaric-oxygen-therapy-session'
UNION ALL SELECT id, 'Hyperbaric Chamber', 'en' FROM medical_services WHERE slug = 'hyperbaric-oxygen-therapy-session'
UNION ALL SELECT id, 'Hiperbarična komora', 'sr' FROM medical_services WHERE slug = 'hyperbaric-oxygen-therapy-session'
UNION ALL SELECT id, 'Хипербарична комора', 'sr-cyrl' FROM medical_services WHERE slug = 'hyperbaric-oxygen-therapy-session'
UNION ALL SELECT id, 'HBO terapija', 'sr' FROM medical_services WHERE slug = 'hyperbaric-oxygen-therapy-session'
UNION ALL SELECT id, 'ХБО терапија', 'sr-cyrl' FROM medical_services WHERE slug = 'hyperbaric-oxygen-therapy-session'
UNION ALL SELECT id, 'ГБО', 'ru' FROM medical_services WHERE slug = 'hyperbaric-oxygen-therapy-session'
UNION ALL SELECT id, 'Барокамера', 'ru' FROM medical_services WHERE slug = 'hyperbaric-oxygen-therapy-session'
UNION ALL SELECT id, 'Druckkammertherapie', 'de' FROM medical_services WHERE slug = 'hyperbaric-oxygen-therapy-session';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kineziterapija za decu', 'sr' FROM medical_services WHERE slug = 'kinesiotherapy-for-children-with-deformities'
UNION ALL SELECT id, 'Кинезитерапија за децу', 'sr-cyrl' FROM medical_services WHERE slug = 'kinesiotherapy-for-children-with-deformities'
UNION ALL SELECT id, 'ЛФК для детей', 'ru' FROM medical_services WHERE slug = 'kinesiotherapy-for-children-with-deformities';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lymphatic Drainage Complete', 'en' FROM medical_services WHERE slug = 'lymphatic-drainage-complete';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Magneto terapija', 'sr' FROM medical_services WHERE slug = 'magnetic-therapy'
UNION ALL SELECT id, 'Магнето терапија', 'sr-cyrl' FROM medical_services WHERE slug = 'magnetic-therapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pasivne i potpomognute vežbe', 'sr' FROM medical_services WHERE slug = 'passive-and-assisted-exercises'
UNION ALL SELECT id, 'Пасивне и потпомогнуте вежбе', 'sr-cyrl' FROM medical_services WHERE slug = 'passive-and-assisted-exercises';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Posture Exercises', 'en' FROM medical_services WHERE slug = 'postural-exercises'
UNION ALL SELECT id, 'Posturalne vežbe', 'sr' FROM medical_services WHERE slug = 'postural-exercises'
UNION ALL SELECT id, 'Постуралне вежбе', 'sr-cyrl' FROM medical_services WHERE slug = 'postural-exercises'
UNION ALL SELECT id, 'Упражнения для осанки', 'ru' FROM medical_services WHERE slug = 'postural-exercises';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Progressive Quadriceps Resistance Exercises', 'en' FROM medical_services WHERE slug = 'progressive-quadriceps-resistance-exercises'
UNION ALL SELECT id, 'Progresivne vežbe sa otporom na kvadriceps aparatu', 'sr' FROM medical_services WHERE slug = 'progressive-quadriceps-resistance-exercises'
UNION ALL SELECT id, 'Прогресивне вежбе са отпором на квадрицепс апарату', 'sr-cyrl' FROM medical_services WHERE slug = 'progressive-quadriceps-resistance-exercises';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Stimulativne vežbe kod rizično rođene dece', 'sr' FROM medical_services WHERE slug = 'stimulative-exercises-for-at-risk-infants'
UNION ALL SELECT id, 'Стимулативне вежбе код ризично рођене деце', 'sr-cyrl' FROM medical_services WHERE slug = 'stimulative-exercises-for-at-risk-infants';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'SIS Therapy', 'en' FROM medical_services WHERE slug = 'super-inductive-system-therapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Tekar terapija', 'sr' FROM medical_services WHERE slug = 'tecar-therapy'
UNION ALL SELECT id, 'Текар терапија', 'sr-cyrl' FROM medical_services WHERE slug = 'tecar-therapy'
UNION ALL SELECT id, 'Текар-терапия', 'ru' FROM medical_services WHERE slug = 'tecar-therapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Transcutaneous Electrical Nerve Stimulation', 'en' FROM medical_services WHERE slug = 'tens-therapy'
UNION ALL SELECT id, 'Transkutana nervna stimulacija', 'sr' FROM medical_services WHERE slug = 'tens-therapy'
UNION ALL SELECT id, 'Транскутана нервна стимулација', 'sr-cyrl' FROM medical_services WHERE slug = 'tens-therapy'
UNION ALL SELECT id, 'Чрескожная электронейростимуляция', 'ru' FROM medical_services WHERE slug = 'tens-therapy'
UNION ALL SELECT id, 'ЧЭНС', 'ru' FROM medical_services WHERE slug = 'tens-therapy'
UNION ALL SELECT id, 'Transkutane elektrische Nervenstimulation', 'de' FROM medical_services WHERE slug = 'tens-therapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Therapeutic Massage Complete', 'en' FROM medical_services WHERE slug = 'therapeutic-massage-complete'
UNION ALL SELECT id, 'Terapijska masaža cijelog tijela', 'sr' FROM medical_services WHERE slug = 'therapeutic-massage-complete'
UNION ALL SELECT id, 'Терапијска масажа цијелог тијела', 'sr-cyrl' FROM medical_services WHERE slug = 'therapeutic-massage-complete'
UNION ALL SELECT id, 'Лечебный массаж всего тела', 'ru' FROM medical_services WHERE slug = 'therapeutic-massage-complete';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Therapeutic Massage Partial', 'en' FROM medical_services WHERE slug = 'therapeutic-massage-partial';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Fibroadenoma Removal', 'en' FROM medical_services WHERE slug = 'benign-breast-tumor-surgery'
UNION ALL SELECT id, 'Uklanjanje fibroadenoma dojke', 'sr' FROM medical_services WHERE slug = 'benign-breast-tumor-surgery'
UNION ALL SELECT id, 'Уклањање фиброаденома дојке', 'sr-cyrl' FROM medical_services WHERE slug = 'benign-breast-tumor-surgery'
UNION ALL SELECT id, 'Удаление фиброаденомы', 'ru' FROM medical_services WHERE slug = 'benign-breast-tumor-surgery';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Craniectomy with ICP Monitoring or Reservoir', 'en' FROM medical_services WHERE slug = 'craniectomy-with-icp-monitoring-or-reservoir';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'EVAR', 'en' FROM medical_services WHERE slug = 'endovascular-stent-graft-in-abdominal-aorta'
UNION ALL SELECT id, 'Эндопротезирование брюшной аорты', 'ru' FROM medical_services WHERE slug = 'endovascular-stent-graft-in-abdominal-aorta';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'TEVAR', 'en' FROM medical_services WHERE slug = 'endovascular-stent-graft-in-thoracic-aorta'
UNION ALL SELECT id, 'Эндопротезирование грудной аорты', 'ru' FROM medical_services WHERE slug = 'endovascular-stent-graft-in-thoracic-aorta';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Тромбэктомия геморроидального узла', 'ru' FROM medical_services WHERE slug = 'enucleation-or-excision-of-external-thrombosed-hemorrhoids';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'EVD', 'en' FROM medical_services WHERE slug = 'external-ventricular-drainage'
UNION ALL SELECT id, 'Наружная вентрикулостомия', 'ru' FROM medical_services WHERE slug = 'external-ventricular-drainage';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Upper Abdominal Ultrasound', 'en' FROM medical_services WHERE slug = 'upper-abdomen-ultrasound'
UNION ALL SELECT id, 'UZ gornjeg abdomena', 'sr' FROM medical_services WHERE slug = 'upper-abdomen-ultrasound'
UNION ALL SELECT id, 'УЗ горњег абдомена', 'sr-cyrl' FROM medical_services WHERE slug = 'upper-abdomen-ultrasound'
UNION ALL SELECT id, 'Ultrazvuk gornjeg dela abdomena', 'sr' FROM medical_services WHERE slug = 'upper-abdomen-ultrasound'
UNION ALL SELECT id, 'Ултразвук горњег дела абдомена', 'sr-cyrl' FROM medical_services WHERE slug = 'upper-abdomen-ultrasound'
UNION ALL SELECT id, 'УЗИ печени, желчного пузыря, поджелудочной железы и селезёнки', 'ru' FROM medical_services WHERE slug = 'upper-abdomen-ultrasound'
UNION ALL SELECT id, 'Oberbauchsonographie', 'de' FROM medical_services WHERE slug = 'upper-abdomen-ultrasound'
UNION ALL SELECT id, 'Üst batın USG', 'tr' FROM medical_services WHERE slug = 'upper-abdomen-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Гипс по Сармиенто', 'ru' FROM medical_services WHERE slug = 'sarmiento-cast-reduction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cervical Collar', 'en' FROM medical_services WHERE slug = 'schanz-collar-application'
UNION ALL SELECT id, 'Šancova kragna', 'sr' FROM medical_services WHERE slug = 'schanz-collar-application'
UNION ALL SELECT id, 'Шанцова крагна', 'sr-cyrl' FROM medical_services WHERE slug = 'schanz-collar-application'
UNION ALL SELECT id, 'Kragna za vrat', 'sr' FROM medical_services WHERE slug = 'schanz-collar-application'
UNION ALL SELECT id, 'Крагна за врат', 'sr-cyrl' FROM medical_services WHERE slug = 'schanz-collar-application'
UNION ALL SELECT id, 'Шина Шанца', 'ru' FROM medical_services WHERE slug = 'schanz-collar-application'
UNION ALL SELECT id, 'Шейный воротник', 'ru' FROM medical_services WHERE slug = 'schanz-collar-application'
UNION ALL SELECT id, 'Schanz-Krawatte', 'de' FROM medical_services WHERE slug = 'schanz-collar-application'
UNION ALL SELECT id, 'Halskrawatte', 'de' FROM medical_services WHERE slug = 'schanz-collar-application'
UNION ALL SELECT id, 'Boyunluk', 'tr' FROM medical_services WHERE slug = 'schanz-collar-application';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Dislocated Shoulder', 'en' FROM medical_services WHERE slug = 'shoulder-dislocation-open-or-closed'
UNION ALL SELECT id, 'Iščašenje ramena', 'sr' FROM medical_services WHERE slug = 'shoulder-dislocation-open-or-closed'
UNION ALL SELECT id, 'Ишчашење рамена', 'sr-cyrl' FROM medical_services WHERE slug = 'shoulder-dislocation-open-or-closed'
UNION ALL SELECT id, 'Namještanje iščašenog ramena', 'sr' FROM medical_services WHERE slug = 'shoulder-dislocation-open-or-closed'
UNION ALL SELECT id, 'Намјештање ишчашеног рамена', 'sr-cyrl' FROM medical_services WHERE slug = 'shoulder-dislocation-open-or-closed'
UNION ALL SELECT id, 'Вправление вывиха плеча', 'ru' FROM medical_services WHERE slug = 'shoulder-dislocation-open-or-closed'
UNION ALL SELECT id, 'Ausgekugelte Schulter', 'de' FROM medical_services WHERE slug = 'shoulder-dislocation-open-or-closed'
UNION ALL SELECT id, 'Omuz çıkığı', 'tr' FROM medical_services WHERE slug = 'shoulder-dislocation-open-or-closed';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Трималлеолярный перелом', 'ru' FROM medical_services WHERE slug = 'trimalleolar-ankle-fracture-open-or-closed-withwithout-fixation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Sugar-Tong Splint', 'en' FROM medical_services WHERE slug = 'u-splint-application'
UNION ALL SELECT id, 'U-образная лонгета', 'ru' FROM medical_services WHERE slug = 'u-splint-application';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kućna posjeta ljekara i medicinske sestre', 'sr' FROM medical_services WHERE slug = 'home-visit-doctor-and-nurse'
UNION ALL SELECT id, 'Кућна посјета љекара и медицинске сестре', 'sr-cyrl' FROM medical_services WHERE slug = 'home-visit-doctor-and-nurse';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pregled kod kuće', 'sr' FROM medical_services WHERE slug = 'home-visit-examination'
UNION ALL SELECT id, 'Преглед код куће', 'sr-cyrl' FROM medical_services WHERE slug = 'home-visit-examination'
UNION ALL SELECT id, 'Ljekar na kućnu adresu', 'sr' FROM medical_services WHERE slug = 'home-visit-examination'
UNION ALL SELECT id, 'Љекар на кућну адресу', 'sr-cyrl' FROM medical_services WHERE slug = 'home-visit-examination'
UNION ALL SELECT id, 'Lekar na kućnu adresu', 'sr' FROM medical_services WHERE slug = 'home-visit-examination'
UNION ALL SELECT id, 'Лекар на кућну адресу', 'sr-cyrl' FROM medical_services WHERE slug = 'home-visit-examination'
UNION ALL SELECT id, 'Вызов врача на дом', 'ru' FROM medical_services WHERE slug = 'home-visit-examination'
UNION ALL SELECT id, 'Evde muayene', 'tr' FROM medical_services WHERE slug = 'home-visit-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Удаление фалькс-менингиомы', 'ru' FROM medical_services WHERE slug = 'falx-meningioma-removal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Femoral Artery Aneurysm Repair', 'en' FROM medical_services WHERE slug = 'femoral-artery-aneurysmectomy-and-reconstruction'
UNION ALL SELECT id, 'Operacija aneurizme femoralne arterije', 'sr' FROM medical_services WHERE slug = 'femoral-artery-aneurysmectomy-and-reconstruction'
UNION ALL SELECT id, 'Операција анеуризме феморалне артерије', 'sr-cyrl' FROM medical_services WHERE slug = 'femoral-artery-aneurysmectomy-and-reconstruction'
UNION ALL SELECT id, 'Операция при аневризме бедренной артерии', 'ru' FROM medical_services WHERE slug = 'femoral-artery-aneurysmectomy-and-reconstruction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Fixation Transducer for ICP Monitoring in Various Etiologies', 'en' FROM medical_services WHERE slug = 'fixation-transducer-for-icp-monitoring-in-various-etiologies'
UNION ALL SELECT id, 'ICP Monitor Insertion', 'en' FROM medical_services WHERE slug = 'fixation-transducer-for-icp-monitoring-in-various-etiologies'
UNION ALL SELECT id, 'Установка датчика внутричерепного давления', 'ru' FROM medical_services WHERE slug = 'fixation-transducer-for-icp-monitoring-in-various-etiologies';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hemorrhoid Treatment with Electric Destruction', 'en' FROM medical_services WHERE slug = 'hemorrhoid-treatment-with-electric-destruction'
UNION ALL SELECT id, 'Elektrokoagulacija hemoroida', 'sr' FROM medical_services WHERE slug = 'hemorrhoid-treatment-with-electric-destruction'
UNION ALL SELECT id, 'Електрокоагулација хемороида', 'sr-cyrl' FROM medical_services WHERE slug = 'hemorrhoid-treatment-with-electric-destruction'
UNION ALL SELECT id, 'Электрокоагуляция геморроидальных узлов', 'ru' FROM medical_services WHERE slug = 'hemorrhoid-treatment-with-electric-destruction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Лечение внутримозговой гематомы', 'ru' FROM medical_services WHERE slug = 'intracerebral-hematoma';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Incizija i drenaža išiorektalnog apscesa', 'sr' FROM medical_services WHERE slug = 'ischiorectal-abscess-incision-and-drainage'
UNION ALL SELECT id, 'Вскрытие ишиоректального парапроктита', 'ru' FROM medical_services WHERE slug = 'ischiorectal-abscess-incision-and-drainage';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Multiple Bilateral Thoracentesis', 'en' FROM medical_services WHERE slug = 'multiple-bilateral-thoracocentesis'
UNION ALL SELECT id, 'Višestruka obostrana pleuralna punkcija', 'sr' FROM medical_services WHERE slug = 'multiple-bilateral-thoracocentesis'
UNION ALL SELECT id, 'Вишеструка обострана плеурална пункција', 'sr-cyrl' FROM medical_services WHERE slug = 'multiple-bilateral-thoracocentesis'
UNION ALL SELECT id, 'Многократная двусторонняя плевральная пункция', 'ru' FROM medical_services WHERE slug = 'multiple-bilateral-thoracocentesis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Multiple Unilateral Thoracentesis', 'en' FROM medical_services WHERE slug = 'multiple-unilateral-thoracocentesis'
UNION ALL SELECT id, 'Višestruka jednostrana pleuralna punkcija', 'sr' FROM medical_services WHERE slug = 'multiple-unilateral-thoracocentesis'
UNION ALL SELECT id, 'Вишеструка једнострана плеурална пункција', 'sr-cyrl' FROM medical_services WHERE slug = 'multiple-unilateral-thoracocentesis'
UNION ALL SELECT id, 'Многократная односторонняя плевральная пункция', 'ru' FROM medical_services WHERE slug = 'multiple-unilateral-thoracocentesis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Удаление ампутационной невромы', 'ru' FROM medical_services WHERE slug = 'neuroma-removal-for-phantom-pain';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Декомпрессия нерва при туннельном синдроме', 'ru' FROM medical_services WHERE slug = 'peripheral-nerve-decompressiontransposition-for-compression-neuropathy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Popliteal Artery Aneurysm Repair', 'en' FROM medical_services WHERE slug = 'popliteal-and-other-leg-arteries-aneurysmectomy-and-reconstruction'
UNION ALL SELECT id, 'Operacija aneurizme poplitealne arterije', 'sr' FROM medical_services WHERE slug = 'popliteal-and-other-leg-arteries-aneurysmectomy-and-reconstruction'
UNION ALL SELECT id, 'Операција анеуризме поплитеалне артерије', 'sr-cyrl' FROM medical_services WHERE slug = 'popliteal-and-other-leg-arteries-aneurysmectomy-and-reconstruction'
UNION ALL SELECT id, 'Операция при аневризме подколенной артерии', 'ru' FROM medical_services WHERE slug = 'popliteal-and-other-leg-arteries-aneurysmectomy-and-reconstruction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Duboki apsces dojke, premamarni', 'sr' FROM medical_services WHERE slug = 'premammary-deep-breast-abscess-treatment'
UNION ALL SELECT id, 'Дубоки апсцес дојке, премамарни', 'sr-cyrl' FROM medical_services WHERE slug = 'premammary-deep-breast-abscess-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'ПХО раны с электрокоагуляцией', 'ru' FROM medical_services WHERE slug = 'primary-wound-care-with-electrocauterization';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Punkcija i drenaža epiduralnog, subduralnog ili moždanog apscesa', 'sr' FROM medical_services WHERE slug = 'puncture-and-drainage-of-episubdural-or-brain-abscess'
UNION ALL SELECT id, 'Пункција и дренажа епидуралног, субдуралног или можданог апсцеса', 'sr-cyrl' FROM medical_services WHERE slug = 'puncture-and-drainage-of-episubdural-or-brain-abscess';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Duboki apsces dojke, retromamarni', 'sr' FROM medical_services WHERE slug = 'retromammary-deep-breast-abscess-treatment'
UNION ALL SELECT id, 'Дубоки апсцес дојке, ретромамарни', 'sr-cyrl' FROM medical_services WHERE slug = 'retromammary-deep-breast-abscess-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Удаление спонтанной внутримозговой гематомы', 'ru' FROM medical_services WHERE slug = 'spontaneous-intracerebral-hematoma-evacuation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Treatment of Smaller Wounds without Deep Structure Lesion (Direct)', 'en' FROM medical_services WHERE slug = 'treatment-of-smaller-wounds-without-deep-structure-lesion-direct';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Невротомия ветви тройничного нерва', 'ru' FROM medical_services WHERE slug = 'trigeminal-nerve-branch-sectioning';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'VP Shunt', 'en' FROM medical_services WHERE slug = 'ventriculoatrial-or-ventriculoperitoneal-shunt'
UNION ALL SELECT id, 'Ventrikuloperitonealni šant', 'sr' FROM medical_services WHERE slug = 'ventriculoatrial-or-ventriculoperitoneal-shunt'
UNION ALL SELECT id, 'Вентрикулоперитонеални шант', 'sr-cyrl' FROM medical_services WHERE slug = 'ventriculoatrial-or-ventriculoperitoneal-shunt'
UNION ALL SELECT id, 'Шунтирование при гидроцефалии', 'ru' FROM medical_services WHERE slug = 'ventriculoatrial-or-ventriculoperitoneal-shunt';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Catheter Organ Resection by Feeding Artery Embolization', 'en' FROM medical_services WHERE slug = 'catheter-organ-resection-by-feeding-artery-embolization';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'CTA Head and Neck', 'en' FROM medical_services WHERE slug = 'msct-angiography-head-and-neck-vessels'
UNION ALL SELECT id, 'MSCT angiografija vrata i mozga', 'sr' FROM medical_services WHERE slug = 'msct-angiography-head-and-neck-vessels'
UNION ALL SELECT id, 'МСКТ ангиографија врата и мозга', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-angiography-head-and-neck-vessels'
UNION ALL SELECT id, 'КТ-ангиография брахиоцефальных артерий', 'ru' FROM medical_services WHERE slug = 'msct-angiography-head-and-neck-vessels';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Coronary Artery Calcium Score', 'en' FROM medical_services WHERE slug = 'msct-calcium-score'
UNION ALL SELECT id, 'Agatston Score', 'en' FROM medical_services WHERE slug = 'msct-calcium-score'
UNION ALL SELECT id, 'Kalcijum skor koronarnih arterija', 'sr' FROM medical_services WHERE slug = 'msct-calcium-score'
UNION ALL SELECT id, 'Калцијум скор коронарних артерија', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-calcium-score'
UNION ALL SELECT id, 'Кальций-скоринг', 'ru' FROM medical_services WHERE slug = 'msct-calcium-score'
UNION ALL SELECT id, 'Индекс Агатстона', 'ru' FROM medical_services WHERE slug = 'msct-calcium-score'
UNION ALL SELECT id, 'Koronarkalk-Score', 'de' FROM medical_services WHERE slug = 'msct-calcium-score'
UNION ALL SELECT id, 'Koroner kalsiyum skoru', 'tr' FROM medical_services WHERE slug = 'msct-calcium-score';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'CT Head with Contrast', 'en' FROM medical_services WHERE slug = 'msct-head-endocranium-with-contrast'
UNION ALL SELECT id, 'Brain CT with Contrast', 'en' FROM medical_services WHERE slug = 'msct-head-endocranium-with-contrast'
UNION ALL SELECT id, 'CT glave sa kontrastom', 'sr' FROM medical_services WHERE slug = 'msct-head-endocranium-with-contrast'
UNION ALL SELECT id, 'ЦТ главе са контрастом', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-head-endocranium-with-contrast'
UNION ALL SELECT id, 'CT mozga sa kontrastom', 'sr' FROM medical_services WHERE slug = 'msct-head-endocranium-with-contrast'
UNION ALL SELECT id, 'ЦТ мозга са контрастом', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-head-endocranium-with-contrast'
UNION ALL SELECT id, 'Skener glave sa kontrastom', 'sr' FROM medical_services WHERE slug = 'msct-head-endocranium-with-contrast'
UNION ALL SELECT id, 'Скенер главе са контрастом', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-head-endocranium-with-contrast'
UNION ALL SELECT id, 'МСКТ головы с контрастом', 'ru' FROM medical_services WHERE slug = 'msct-head-endocranium-with-contrast'
UNION ALL SELECT id, 'Schädel-CT mit Kontrastmittel', 'de' FROM medical_services WHERE slug = 'msct-head-endocranium-with-contrast'
UNION ALL SELECT id, 'Kontrastlı beyin BT', 'tr' FROM medical_services WHERE slug = 'msct-head-endocranium-with-contrast';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'CT Head without Contrast', 'en' FROM medical_services WHERE slug = 'msct-head-endocranium-without-contrast'
UNION ALL SELECT id, 'Brain CT without Contrast', 'en' FROM medical_services WHERE slug = 'msct-head-endocranium-without-contrast'
UNION ALL SELECT id, 'CT glave bez kontrasta', 'sr' FROM medical_services WHERE slug = 'msct-head-endocranium-without-contrast'
UNION ALL SELECT id, 'ЦТ главе без контраста', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-head-endocranium-without-contrast'
UNION ALL SELECT id, 'CT mozga bez kontrasta', 'sr' FROM medical_services WHERE slug = 'msct-head-endocranium-without-contrast'
UNION ALL SELECT id, 'ЦТ мозга без контраста', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-head-endocranium-without-contrast'
UNION ALL SELECT id, 'CT glave nativno', 'sr' FROM medical_services WHERE slug = 'msct-head-endocranium-without-contrast'
UNION ALL SELECT id, 'ЦТ главе нативно', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-head-endocranium-without-contrast'
UNION ALL SELECT id, 'Skener glave', 'sr' FROM medical_services WHERE slug = 'msct-head-endocranium-without-contrast'
UNION ALL SELECT id, 'Скенер главе', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-head-endocranium-without-contrast'
UNION ALL SELECT id, 'МСКТ головы без контраста', 'ru' FROM medical_services WHERE slug = 'msct-head-endocranium-without-contrast'
UNION ALL SELECT id, 'Schädel-CT nativ', 'de' FROM medical_services WHERE slug = 'msct-head-endocranium-without-contrast'
UNION ALL SELECT id, 'Kontrastsız beyin BT', 'tr' FROM medical_services WHERE slug = 'msct-head-endocranium-without-contrast';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'MSCT Head and Neck Native', 'en' FROM medical_services WHERE slug = 'msct-head-and-neck-native';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'CT Urography', 'en' FROM medical_services WHERE slug = 'msct-ivu-intravenous-urography'
UNION ALL SELECT id, 'CT urografija', 'sr' FROM medical_services WHERE slug = 'msct-ivu-intravenous-urography'
UNION ALL SELECT id, 'ЦТ урографија', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-ivu-intravenous-urography'
UNION ALL SELECT id, 'МСКТ-урография', 'ru' FROM medical_services WHERE slug = 'msct-ivu-intravenous-urography'
UNION ALL SELECT id, 'CT-Urographie', 'de' FROM medical_services WHERE slug = 'msct-ivu-intravenous-urography'
UNION ALL SELECT id, 'BT ürografi', 'tr' FROM medical_services WHERE slug = 'msct-ivu-intravenous-urography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'MSCT Single Region Native', 'en' FROM medical_services WHERE slug = 'msct-single-region-native'
UNION ALL SELECT id, 'КТ одной зоны без контраста', 'ru' FROM medical_services WHERE slug = 'msct-single-region-native';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'КТ одной зоны с контрастом', 'ru' FROM medical_services WHERE slug = 'msct-single-region-with-contrast';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Chest CT with Contrast', 'en' FROM medical_services WHERE slug = 'msct-thorax-chest-with-contrast'
UNION ALL SELECT id, 'CT grudnog koša sa kontrastom', 'sr' FROM medical_services WHERE slug = 'msct-thorax-chest-with-contrast'
UNION ALL SELECT id, 'ЦТ грудног коша са контрастом', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-thorax-chest-with-contrast'
UNION ALL SELECT id, 'CT pluća sa kontrastom', 'sr' FROM medical_services WHERE slug = 'msct-thorax-chest-with-contrast'
UNION ALL SELECT id, 'ЦТ плућа са контрастом', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-thorax-chest-with-contrast'
UNION ALL SELECT id, 'КТ лёгких с контрастом', 'ru' FROM medical_services WHERE slug = 'msct-thorax-chest-with-contrast'
UNION ALL SELECT id, 'КТ ОГК с контрастом', 'ru' FROM medical_services WHERE slug = 'msct-thorax-chest-with-contrast'
UNION ALL SELECT id, 'Kontrastlı toraks BT', 'tr' FROM medical_services WHERE slug = 'msct-thorax-chest-with-contrast';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Chest CT without Contrast', 'en' FROM medical_services WHERE slug = 'msct-thorax-chest-without-contrast'
UNION ALL SELECT id, 'CT grudnog koša bez kontrasta', 'sr' FROM medical_services WHERE slug = 'msct-thorax-chest-without-contrast'
UNION ALL SELECT id, 'ЦТ грудног коша без контраста', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-thorax-chest-without-contrast'
UNION ALL SELECT id, 'CT pluća bez kontrasta', 'sr' FROM medical_services WHERE slug = 'msct-thorax-chest-without-contrast'
UNION ALL SELECT id, 'ЦТ плућа без контраста', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-thorax-chest-without-contrast'
UNION ALL SELECT id, 'КТ лёгких без контраста', 'ru' FROM medical_services WHERE slug = 'msct-thorax-chest-without-contrast'
UNION ALL SELECT id, 'КТ ОГК без контраста', 'ru' FROM medical_services WHERE slug = 'msct-thorax-chest-without-contrast'
UNION ALL SELECT id, 'Kontrastsız toraks BT', 'tr' FROM medical_services WHERE slug = 'msct-thorax-chest-without-contrast'
UNION ALL SELECT id, 'Kontrastsız akciğer BT', 'tr' FROM medical_services WHERE slug = 'msct-thorax-chest-without-contrast';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Patent Ductus Arteriosus Closure (Portsmann Method)', 'en' FROM medical_services WHERE slug = 'patent-ductus-arteriosus-closure-portsmann-method'
UNION ALL SELECT id, 'PDA Closure (Porstmann Method)', 'en' FROM medical_services WHERE slug = 'patent-ductus-arteriosus-closure-portsmann-method'
UNION ALL SELECT id, 'Zatvaranje otvorenog Botalijevog kanala po Porstmannu', 'sr' FROM medical_services WHERE slug = 'patent-ductus-arteriosus-closure-portsmann-method'
UNION ALL SELECT id, 'Затварање отвореног Боталијевог канала по Porstmannu', 'sr-cyrl' FROM medical_services WHERE slug = 'patent-ductus-arteriosus-closure-portsmann-method'
UNION ALL SELECT id, 'Закрытие открытого артериального протока по Порстману', 'ru' FROM medical_services WHERE slug = 'patent-ductus-arteriosus-closure-portsmann-method'
UNION ALL SELECT id, 'Закрытие ОАП по Порстману', 'ru' FROM medical_services WHERE slug = 'patent-ductus-arteriosus-closure-portsmann-method'
UNION ALL SELECT id, 'PDA-Verschluss nach Porstmann', 'de' FROM medical_services WHERE slug = 'patent-ductus-arteriosus-closure-portsmann-method';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'T-Drain Replacement under CT Guidance', 'en' FROM medical_services WHERE slug = 't-drain-replacement-under-ct-guidance';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'ABI', 'en' FROM medical_services WHERE slug = 'ankle-brachial-index-by-doppler-ultrasound'
UNION ALL SELECT id, 'Gležanjsko-brahijalni indeks', 'sr' FROM medical_services WHERE slug = 'ankle-brachial-index-by-doppler-ultrasound'
UNION ALL SELECT id, 'Глежањско-брахијални индекс', 'sr-cyrl' FROM medical_services WHERE slug = 'ankle-brachial-index-by-doppler-ultrasound'
UNION ALL SELECT id, 'Pedobrahijalni indeks', 'sr' FROM medical_services WHERE slug = 'ankle-brachial-index-by-doppler-ultrasound'
UNION ALL SELECT id, 'Педобрахијални индекс', 'sr-cyrl' FROM medical_services WHERE slug = 'ankle-brachial-index-by-doppler-ultrasound'
UNION ALL SELECT id, 'Лодыжечно-плечевой индекс', 'ru' FROM medical_services WHERE slug = 'ankle-brachial-index-by-doppler-ultrasound'
UNION ALL SELECT id, 'ЛПИ', 'ru' FROM medical_services WHERE slug = 'ankle-brachial-index-by-doppler-ultrasound'
UNION ALL SELECT id, 'Knöchel-Arm-Druckindex', 'de' FROM medical_services WHERE slug = 'ankle-brachial-index-by-doppler-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Renal Artery Doppler Ultrasound', 'en' FROM medical_services WHERE slug = 'doppler-renal-arteries'
UNION ALL SELECT id, 'Dopler bubrežnih arterija', 'sr' FROM medical_services WHERE slug = 'doppler-renal-arteries'
UNION ALL SELECT id, 'Доплер бубрежних артерија', 'sr-cyrl' FROM medical_services WHERE slug = 'doppler-renal-arteries'
UNION ALL SELECT id, 'Допплерография почечных артерий', 'ru' FROM medical_services WHERE slug = 'doppler-renal-arteries'
UNION ALL SELECT id, 'Доплер почечных артерий', 'ru' FROM medical_services WHERE slug = 'doppler-renal-arteries';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lower Abdominal Ultrasound', 'en' FROM medical_services WHERE slug = 'lower-abdomen-ultrasound'
UNION ALL SELECT id, 'UZ donjeg abdomena', 'sr' FROM medical_services WHERE slug = 'lower-abdomen-ultrasound'
UNION ALL SELECT id, 'УЗ доњег абдомена', 'sr-cyrl' FROM medical_services WHERE slug = 'lower-abdomen-ultrasound'
UNION ALL SELECT id, 'Ultrazvuk donjeg dela abdomena', 'sr' FROM medical_services WHERE slug = 'lower-abdomen-ultrasound'
UNION ALL SELECT id, 'Ултразвук доњег дела абдомена', 'sr-cyrl' FROM medical_services WHERE slug = 'lower-abdomen-ultrasound'
UNION ALL SELECT id, 'УЗИ низа живота', 'ru' FROM medical_services WHERE slug = 'lower-abdomen-ultrasound'
UNION ALL SELECT id, 'Unterbauchsonographie', 'de' FROM medical_services WHERE slug = 'lower-abdomen-ultrasound'
UNION ALL SELECT id, 'Alt batın USG', 'tr' FROM medical_services WHERE slug = 'lower-abdomen-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Neck Ultrasound Salivary Glands', 'en' FROM medical_services WHERE slug = 'neck-ultrasound-salivary-glands'
UNION ALL SELECT id, 'Ultrazvuk pljuvačnih žlijezda', 'sr' FROM medical_services WHERE slug = 'neck-ultrasound-salivary-glands'
UNION ALL SELECT id, 'Ултразвук пљувачних жлијезда', 'sr-cyrl' FROM medical_services WHERE slug = 'neck-ultrasound-salivary-glands'
UNION ALL SELECT id, 'Ultrazvuk pljuvačnih žlezda', 'sr' FROM medical_services WHERE slug = 'neck-ultrasound-salivary-glands'
UNION ALL SELECT id, 'Ултразвук пљувачних жлезда', 'sr-cyrl' FROM medical_services WHERE slug = 'neck-ultrasound-salivary-glands';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Orthopedic Ultrasound Single Joint', 'en' FROM medical_services WHERE slug = 'orthopedic-ultrasound-single-joint'
UNION ALL SELECT id, 'Joint Ultrasound', 'en' FROM medical_services WHERE slug = 'orthopedic-ultrasound-single-joint'
UNION ALL SELECT id, 'Ultrazvuk zgloba', 'sr' FROM medical_services WHERE slug = 'orthopedic-ultrasound-single-joint'
UNION ALL SELECT id, 'Ултразвук зглоба', 'sr-cyrl' FROM medical_services WHERE slug = 'orthopedic-ultrasound-single-joint'
UNION ALL SELECT id, 'УЗИ сустава', 'ru' FROM medical_services WHERE slug = 'orthopedic-ultrasound-single-joint'
UNION ALL SELECT id, 'Gelenksonographie', 'de' FROM medical_services WHERE slug = 'orthopedic-ultrasound-single-joint'
UNION ALL SELECT id, 'Eklem ultrasonu', 'tr' FROM medical_services WHERE slug = 'orthopedic-ultrasound-single-joint';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ultrazvuk kukova kod dece', 'sr' FROM medical_services WHERE slug = 'pediatric-hip-ultrasound'
UNION ALL SELECT id, 'Ултразвук кукова код деце', 'sr-cyrl' FROM medical_services WHERE slug = 'pediatric-hip-ultrasound'
UNION ALL SELECT id, 'UZ kukova kod djece', 'sr' FROM medical_services WHERE slug = 'pediatric-hip-ultrasound'
UNION ALL SELECT id, 'УЗ кукова код дјеце', 'sr-cyrl' FROM medical_services WHERE slug = 'pediatric-hip-ultrasound'
UNION ALL SELECT id, 'УЗИ ТБС у детей', 'ru' FROM medical_services WHERE slug = 'pediatric-hip-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Scrotal Ultrasound', 'en' FROM medical_services WHERE slug = 'testicular-ultrasound'
UNION ALL SELECT id, 'Ultrazvuk skrotuma', 'sr' FROM medical_services WHERE slug = 'testicular-ultrasound'
UNION ALL SELECT id, 'Ултразвук скротума', 'sr-cyrl' FROM medical_services WHERE slug = 'testicular-ultrasound'
UNION ALL SELECT id, 'УЗИ органов мошонки', 'ru' FROM medical_services WHERE slug = 'testicular-ultrasound'
UNION ALL SELECT id, 'УЗИ мошонки', 'ru' FROM medical_services WHERE slug = 'testicular-ultrasound'
UNION ALL SELECT id, 'Skrotalsonographie', 'de' FROM medical_services WHERE slug = 'testicular-ultrasound'
UNION ALL SELECT id, 'Skrotal USG', 'tr' FROM medical_services WHERE slug = 'testicular-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'UZ štitne žlijezde', 'sr' FROM medical_services WHERE slug = 'thyroid-ultrasound'
UNION ALL SELECT id, 'УЗ штитне жлијезде', 'sr-cyrl' FROM medical_services WHERE slug = 'thyroid-ultrasound'
UNION ALL SELECT id, 'Ultrazvuk štitaste žlijezde', 'sr' FROM medical_services WHERE slug = 'thyroid-ultrasound'
UNION ALL SELECT id, 'Ултразвук штитасте жлијезде', 'sr-cyrl' FROM medical_services WHERE slug = 'thyroid-ultrasound'
UNION ALL SELECT id, 'Ultrazvuk štitne žlezde', 'sr' FROM medical_services WHERE slug = 'thyroid-ultrasound'
UNION ALL SELECT id, 'Ултразвук штитне жлезде', 'sr-cyrl' FROM medical_services WHERE slug = 'thyroid-ultrasound'
UNION ALL SELECT id, 'УЗИ щитовидки', 'ru' FROM medical_services WHERE slug = 'thyroid-ultrasound'
UNION ALL SELECT id, 'Schilddrüsensonographie', 'de' FROM medical_services WHERE slug = 'thyroid-ultrasound'
UNION ALL SELECT id, 'Tiroid USG', 'tr' FROM medical_services WHERE slug = 'thyroid-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ultrazvuk mekih tkiva vrata', 'sr' FROM medical_services WHERE slug = 'ultrasound-neck-glands-and-soft-tissue'
UNION ALL SELECT id, 'Ултразвук меких ткива врата', 'sr-cyrl' FROM medical_services WHERE slug = 'ultrasound-neck-glands-and-soft-tissue'
UNION ALL SELECT id, 'УЗИ мягких тканей шеи', 'ru' FROM medical_services WHERE slug = 'ultrasound-neck-glands-and-soft-tissue';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cone Beam CT', 'en' FROM medical_services WHERE slug = '3d-dental-x-ray-cbct'
UNION ALL SELECT id, 'Dental CT Scan', 'en' FROM medical_services WHERE slug = '3d-dental-x-ray-cbct'
UNION ALL SELECT id, 'CBCT snimak', 'sr' FROM medical_services WHERE slug = '3d-dental-x-ray-cbct'
UNION ALL SELECT id, 'CBCT снимак', 'sr-cyrl' FROM medical_services WHERE slug = '3d-dental-x-ray-cbct'
UNION ALL SELECT id, 'CT zuba', 'sr' FROM medical_services WHERE slug = '3d-dental-x-ray-cbct'
UNION ALL SELECT id, 'ЦТ зуба', 'sr-cyrl' FROM medical_services WHERE slug = '3d-dental-x-ray-cbct'
UNION ALL SELECT id, 'КТ зубов', 'ru' FROM medical_services WHERE slug = '3d-dental-x-ray-cbct'
UNION ALL SELECT id, 'Конусно-лучевая томография', 'ru' FROM medical_services WHERE slug = '3d-dental-x-ray-cbct'
UNION ALL SELECT id, 'Digitale Volumentomographie', 'de' FROM medical_services WHERE slug = '3d-dental-x-ray-cbct'
UNION ALL SELECT id, 'Dental tomografi', 'tr' FROM medical_services WHERE slug = '3d-dental-x-ray-cbct';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'All-on-4 Metal-Ceramic', 'en' FROM medical_services WHERE slug = 'all-on-4-metal-ceramic-titanium'
UNION ALL SELECT id, 'Metalokeramička proteza na 4 implantata', 'sr' FROM medical_services WHERE slug = 'all-on-4-metal-ceramic-titanium'
UNION ALL SELECT id, 'Металокерамичка протеза на 4 имплантата', 'sr-cyrl' FROM medical_services WHERE slug = 'all-on-4-metal-ceramic-titanium'
UNION ALL SELECT id, 'Все на 4 металлокерамика', 'ru' FROM medical_services WHERE slug = 'all-on-4-metal-ceramic-titanium';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'All-on-4 Zirconia', 'en' FROM medical_services WHERE slug = 'all-on-4-zirconia'
UNION ALL SELECT id, 'Cirkonijum proteza na 4 implantata', 'sr' FROM medical_services WHERE slug = 'all-on-4-zirconia'
UNION ALL SELECT id, 'Цирконијум протеза на 4 имплантата', 'sr-cyrl' FROM medical_services WHERE slug = 'all-on-4-zirconia'
UNION ALL SELECT id, 'Все на 4 цирконий', 'ru' FROM medical_services WHERE slug = 'all-on-4-zirconia';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'All-on-6 Metal-Ceramic', 'en' FROM medical_services WHERE slug = 'all-on-6-metal-ceramic'
UNION ALL SELECT id, 'Metalokeramička proteza na 6 implantata', 'sr' FROM medical_services WHERE slug = 'all-on-6-metal-ceramic'
UNION ALL SELECT id, 'Металокерамичка протеза на 6 имплантата', 'sr-cyrl' FROM medical_services WHERE slug = 'all-on-6-metal-ceramic'
UNION ALL SELECT id, 'Все на 6 металлокерамика', 'ru' FROM medical_services WHERE slug = 'all-on-6-metal-ceramic';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'All-on-6 Zirconia', 'en' FROM medical_services WHERE slug = 'all-on-6-zirconia'
UNION ALL SELECT id, 'Cirkonijum proteza na 6 implantata', 'sr' FROM medical_services WHERE slug = 'all-on-6-zirconia'
UNION ALL SELECT id, 'Цирконијум протеза на 6 имплантата', 'sr-cyrl' FROM medical_services WHERE slug = 'all-on-6-zirconia'
UNION ALL SELECT id, 'Все на 6 цирконий', 'ru' FROM medical_services WHERE slug = 'all-on-6-zirconia';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Alveoloplasty', 'en' FROM medical_services WHERE slug = 'alveolar-ridge-leveling'
UNION ALL SELECT id, 'Alveoloplastika', 'sr' FROM medical_services WHERE slug = 'alveolar-ridge-leveling'
UNION ALL SELECT id, 'Алвеолопластика', 'sr-cyrl' FROM medical_services WHERE slug = 'alveolar-ridge-leveling'
UNION ALL SELECT id, 'Альвеолопластика', 'ru' FROM medical_services WHERE slug = 'alveolar-ridge-leveling';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Biooss Bone Graft 0.5g', 'en' FROM medical_services WHERE slug = 'biooss-bone-graft-05g'
UNION ALL SELECT id, 'Био-Осс', 'ru' FROM medical_services WHERE slug = 'biooss-bone-graft-05g';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Bleeding Control Dental', 'en' FROM medical_services WHERE slug = 'bleeding-control-dental'
UNION ALL SELECT id, 'Zaustavljanje krvarenja nakon vađenja zuba', 'sr' FROM medical_services WHERE slug = 'bleeding-control-dental'
UNION ALL SELECT id, 'Заустављање крварења након вађења зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'bleeding-control-dental'
UNION ALL SELECT id, 'Остановка кровотечения после удаления зуба', 'ru' FROM medical_services WHERE slug = 'bleeding-control-dental';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Bone Augmentation Biooss', 'en' FROM medical_services WHERE slug = 'bone-augmentation-biooss'
UNION ALL SELECT id, 'Bone Grafting', 'en' FROM medical_services WHERE slug = 'bone-augmentation-biooss'
UNION ALL SELECT id, 'Nadogradnja kosti', 'sr' FROM medical_services WHERE slug = 'bone-augmentation-biooss'
UNION ALL SELECT id, 'Надоградња кости', 'sr-cyrl' FROM medical_services WHERE slug = 'bone-augmentation-biooss'
UNION ALL SELECT id, 'Наращивание кости', 'ru' FROM medical_services WHERE slug = 'bone-augmentation-biooss'
UNION ALL SELECT id, 'Наращивание костной ткани', 'ru' FROM medical_services WHERE slug = 'bone-augmentation-biooss'
UNION ALL SELECT id, 'Knochenaufbau mit Bio-Oss', 'de' FROM medical_services WHERE slug = 'bone-augmentation-biooss'
UNION ALL SELECT id, 'Kemik tozu', 'tr' FROM medical_services WHERE slug = 'bone-augmentation-biooss';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Керамическая накладка', 'ru' FROM medical_services WHERE slug = 'ceramic-inlay-onlay'
UNION ALL SELECT id, 'Keramikinlay', 'de' FROM medical_services WHERE slug = 'ceramic-inlay-onlay';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Chin Cup', 'en' FROM medical_services WHERE slug = 'chin-cap'
UNION ALL SELECT id, 'Çenelik', 'tr' FROM medical_services WHERE slug = 'chin-cap';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ponovno cementiranje krunice', 'sr' FROM medical_services WHERE slug = 'crown-or-bridge-recementation'
UNION ALL SELECT id, 'Поновно цементирање крунице', 'sr-cyrl' FROM medical_services WHERE slug = 'crown-or-bridge-recementation'
UNION ALL SELECT id, 'Повторная фиксация коронки', 'ru' FROM medical_services WHERE slug = 'crown-or-bridge-recementation'
UNION ALL SELECT id, 'Приклеить коронку', 'ru' FROM medical_services WHERE slug = 'crown-or-bridge-recementation'
UNION ALL SELECT id, 'Wiederbefestigung einer Krone', 'de' FROM medical_services WHERE slug = 'crown-or-bridge-recementation'
UNION ALL SELECT id, 'Kron yapıştırma', 'tr' FROM medical_services WHERE slug = 'crown-or-bridge-recementation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Custom Mouthguard', 'en' FROM medical_services WHERE slug = 'custom-dental-guard'
UNION ALL SELECT id, 'Štitnik za zube po meri', 'sr' FROM medical_services WHERE slug = 'custom-dental-guard'
UNION ALL SELECT id, 'Штитник за зубе по мери', 'sr-cyrl' FROM medical_services WHERE slug = 'custom-dental-guard'
UNION ALL SELECT id, 'Защитная капа', 'ru' FROM medical_services WHERE slug = 'custom-dental-guard'
UNION ALL SELECT id, 'Individueller Zahnschutz', 'de' FROM medical_services WHERE slug = 'custom-dental-guard';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Armplexusblockade', 'de' FROM medical_services WHERE slug = 'brachial-plexus-block';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Блокада подвздошно-пахового нерва', 'ru' FROM medical_services WHERE slug = 'ilioinguinal-or-iliohypogastric-block';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ischiadikusblockade', 'de' FROM medical_services WHERE slug = 'sciatic-nerve-block';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pfeilerzahn', 'de' FROM medical_services WHERE slug = 'dental-bridge-abutment'
UNION ALL SELECT id, 'Köprü ayağı', 'tr' FROM medical_services WHERE slug = 'dental-bridge-abutment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Tooth Decay Treatment', 'en' FROM medical_services WHERE slug = 'dental-caries-treatment'
UNION ALL SELECT id, 'Lečenje karijesa', 'sr' FROM medical_services WHERE slug = 'dental-caries-treatment'
UNION ALL SELECT id, 'Лечење каријеса', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-caries-treatment'
UNION ALL SELECT id, 'Çürük tedavisi', 'tr' FROM medical_services WHERE slug = 'dental-caries-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Dentist Consultation', 'en' FROM medical_services WHERE slug = 'dental-consultation'
UNION ALL SELECT id, 'Stomatološka konsultacija', 'sr' FROM medical_services WHERE slug = 'dental-consultation'
UNION ALL SELECT id, 'Стоматолошка консултација', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-consultation'
UNION ALL SELECT id, 'Konsultacija zubara', 'sr' FROM medical_services WHERE slug = 'dental-consultation'
UNION ALL SELECT id, 'Консултација зубара', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-consultation'
UNION ALL SELECT id, 'Приём стоматолога', 'ru' FROM medical_services WHERE slug = 'dental-consultation'
UNION ALL SELECT id, 'Консультация зубного врача', 'ru' FROM medical_services WHERE slug = 'dental-consultation'
UNION ALL SELECT id, 'Diş hekimi konsültasyonu', 'tr' FROM medical_services WHERE slug = 'dental-consultation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Produženje krune zuba', 'sr' FROM medical_services WHERE slug = 'dental-crown-lengthening'
UNION ALL SELECT id, 'Продужење круне зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-crown-lengthening'
UNION ALL SELECT id, 'Удлинение коронки зуба', 'ru' FROM medical_services WHERE slug = 'dental-crown-lengthening'
UNION ALL SELECT id, 'Kron boyu uzatma', 'tr' FROM medical_services WHERE slug = 'dental-crown-lengthening';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Emergency Dental Care', 'en' FROM medical_services WHERE slug = 'dental-first-aid'
UNION ALL SELECT id, 'Hitna stomatološka pomoć', 'sr' FROM medical_services WHERE slug = 'dental-first-aid'
UNION ALL SELECT id, 'Хитна стоматолошка помоћ', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-first-aid'
UNION ALL SELECT id, 'Неотложная стоматологическая помощь', 'ru' FROM medical_services WHERE slug = 'dental-first-aid'
UNION ALL SELECT id, 'Zahnärztliche Notfallbehandlung', 'de' FROM medical_services WHERE slug = 'dental-first-aid'
UNION ALL SELECT id, 'Acil diş tedavisi', 'tr' FROM medical_services WHERE slug = 'dental-first-aid';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Tooth Gem', 'en' FROM medical_services WHERE slug = 'dental-jewelry-application'
UNION ALL SELECT id, 'Стразы на зубы', 'ru' FROM medical_services WHERE slug = 'dental-jewelry-application'
UNION ALL SELECT id, 'Скайс', 'ru' FROM medical_services WHERE slug = 'dental-jewelry-application'
UNION ALL SELECT id, 'Diş pırlantası', 'tr' FROM medical_services WHERE slug = 'dental-jewelry-application';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Dental Anaesthesia', 'en' FROM medical_services WHERE slug = 'dental-local-anesthesia'
UNION ALL SELECT id, 'Anestezija zuba', 'sr' FROM medical_services WHERE slug = 'dental-local-anesthesia'
UNION ALL SELECT id, 'Анестезија зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-local-anesthesia'
UNION ALL SELECT id, 'Обезболивание зуба', 'ru' FROM medical_services WHERE slug = 'dental-local-anesthesia'
UNION ALL SELECT id, 'Анестезия зуба', 'ru' FROM medical_services WHERE slug = 'dental-local-anesthesia'
UNION ALL SELECT id, 'Betäubung beim Zahnarzt', 'de' FROM medical_services WHERE slug = 'dental-local-anesthesia'
UNION ALL SELECT id, 'Diş uyuşturma', 'tr' FROM medical_services WHERE slug = 'dental-local-anesthesia';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Sinus Augmentation', 'en' FROM medical_services WHERE slug = 'dental-sinus-lift'
UNION ALL SELECT id, 'Podizanje dna sinusa', 'sr' FROM medical_services WHERE slug = 'dental-sinus-lift'
UNION ALL SELECT id, 'Подизање дна синуса', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-sinus-lift'
UNION ALL SELECT id, 'Поднятие дна гайморовой пазухи', 'ru' FROM medical_services WHERE slug = 'dental-sinus-lift'
UNION ALL SELECT id, 'Субантральная аугментация', 'ru' FROM medical_services WHERE slug = 'dental-sinus-lift'
UNION ALL SELECT id, 'Sinusbodenelevation', 'de' FROM medical_services WHERE slug = 'dental-sinus-lift'
UNION ALL SELECT id, 'Sinüs yükseltme', 'tr' FROM medical_services WHERE slug = 'dental-sinus-lift';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Приварка кламмера', 'ru' FROM medical_services WHERE slug = 'denture-clasp-addition'
UNION ALL SELECT id, 'Kroşe ilavesi', 'tr' FROM medical_services WHERE slug = 'denture-clasp-addition';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Приварка зуба к протезу', 'ru' FROM medical_services WHERE slug = 'denture-tooth-addition';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'DSD', 'en' FROM medical_services WHERE slug = 'digital-smile-design'
UNION ALL SELECT id, 'Digitalni dizajn osmeha', 'sr' FROM medical_services WHERE slug = 'digital-smile-design'
UNION ALL SELECT id, 'Дигитални дизајн осмеха', 'sr-cyrl' FROM medical_services WHERE slug = 'digital-smile-design'
UNION ALL SELECT id, 'Цифровое моделирование улыбки', 'ru' FROM medical_services WHERE slug = 'digital-smile-design'
UNION ALL SELECT id, 'Digitales Lächeldesign', 'de' FROM medical_services WHERE slug = 'digital-smile-design';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kompozitne fasete', 'sr' FROM medical_services WHERE slug = 'direct-composite-veneer'
UNION ALL SELECT id, 'Композитне фасете', 'sr-cyrl' FROM medical_services WHERE slug = 'direct-composite-veneer'
UNION ALL SELECT id, 'Композитные виниры', 'ru' FROM medical_services WHERE slug = 'direct-composite-veneer'
UNION ALL SELECT id, 'Kompozit lamina', 'tr' FROM medical_services WHERE slug = 'direct-composite-veneer';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Балка Долдера', 'ru' FROM medical_services WHERE slug = 'dolder-bar';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Filling Retention with Fiber Post', 'en' FROM medical_services WHERE slug = 'filling-retention-with-fiber-post';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Flap Surgery Periodontal', 'en' FROM medical_services WHERE slug = 'flap-surgery-periodontal'
UNION ALL SELECT id, 'Flap operacija', 'sr' FROM medical_services WHERE slug = 'flap-surgery-periodontal'
UNION ALL SELECT id, 'Флап операција', 'sr-cyrl' FROM medical_services WHERE slug = 'flap-surgery-periodontal'
UNION ALL SELECT id, 'Flep operasyonu', 'tr' FROM medical_services WHERE slug = 'flap-surgery-periodontal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Dental Check-up', 'en' FROM medical_services WHERE slug = 'follow-up-dental-examination'
UNION ALL SELECT id, 'Kontrola kod stomatologa', 'sr' FROM medical_services WHERE slug = 'follow-up-dental-examination'
UNION ALL SELECT id, 'Контрола код стоматолога', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-dental-examination'
UNION ALL SELECT id, 'Контрольный осмотр стоматолога', 'ru' FROM medical_services WHERE slug = 'follow-up-dental-examination'
UNION ALL SELECT id, 'Повторный приём стоматолога', 'ru' FROM medical_services WHERE slug = 'follow-up-dental-examination'
UNION ALL SELECT id, 'Kontrolltermin beim Zahnarzt', 'de' FROM medical_services WHERE slug = 'follow-up-dental-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Fiber Post', 'en' FROM medical_services WHERE slug = 'frc-post'
UNION ALL SELECT id, 'Fiber kočić', 'sr' FROM medical_services WHERE slug = 'frc-post'
UNION ALL SELECT id, 'Фибер кочић', 'sr-cyrl' FROM medical_services WHERE slug = 'frc-post';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Fiber Post and Core', 'en' FROM medical_services WHERE slug = 'frc-post-build-up';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Gangrene Treatment Single Root', 'en' FROM medical_services WHERE slug = 'gangrene-treatment-single-root';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Gangrene Treatment Three Root', 'en' FROM medical_services WHERE slug = 'gangrene-treatment-three-root';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Gangrene Treatment Two Root', 'en' FROM medical_services WHERE slug = 'gangrene-treatment-two-root';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Chalazion Removal Children General Anesthesia', 'en' FROM medical_services WHERE slug = 'chalazion-removal-children-general-anesthesia'
UNION ALL SELECT id, 'Удаление градины у детей', 'ru' FROM medical_services WHERE slug = 'chalazion-removal-children-general-anesthesia';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kontrolni pregled pedijatra', 'sr' FROM medical_services WHERE slug = 'follow-up-pediatric-examination'
UNION ALL SELECT id, 'Контролни преглед педијатра', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-pediatric-examination'
UNION ALL SELECT id, 'Kontrolni pregled djeteta', 'sr' FROM medical_services WHERE slug = 'follow-up-pediatric-examination'
UNION ALL SELECT id, 'Контролни преглед дјетета', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-pediatric-examination'
UNION ALL SELECT id, 'Контрольный осмотр педиатра', 'ru' FROM medical_services WHERE slug = 'follow-up-pediatric-examination'
UNION ALL SELECT id, 'Повторный приём педиатра', 'ru' FROM medical_services WHERE slug = 'follow-up-pediatric-examination'
UNION ALL SELECT id, 'Kontrolluntersuchung beim Kinderarzt', 'de' FROM medical_services WHERE slug = 'follow-up-pediatric-examination'
UNION ALL SELECT id, 'Çocuk doktoru kontrol muayenesi', 'tr' FROM medical_services WHERE slug = 'follow-up-pediatric-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lacrimal Duct Probing Children General Anesthesia', 'en' FROM medical_services WHERE slug = 'lacrimal-duct-probing-children-general-anesthesia'
UNION ALL SELECT id, 'Tear Duct Probing', 'en' FROM medical_services WHERE slug = 'lacrimal-duct-probing-children-general-anesthesia'
UNION ALL SELECT id, 'Sondiranje suznih kanala kod djece', 'sr' FROM medical_services WHERE slug = 'lacrimal-duct-probing-children-general-anesthesia'
UNION ALL SELECT id, 'Сондирање сузних канала код дјеце', 'sr-cyrl' FROM medical_services WHERE slug = 'lacrimal-duct-probing-children-general-anesthesia'
UNION ALL SELECT id, 'Зондирование слёзного канала у детей', 'ru' FROM medical_services WHERE slug = 'lacrimal-duct-probing-children-general-anesthesia';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Impacted Wisdom Tooth Removal', 'en' FROM medical_services WHERE slug = 'impacted-tooth-extraction'
UNION ALL SELECT id, 'Vađenje impaktiranog umnjaka', 'sr' FROM medical_services WHERE slug = 'impacted-tooth-extraction'
UNION ALL SELECT id, 'Вађење импактираног умњака', 'sr-cyrl' FROM medical_services WHERE slug = 'impacted-tooth-extraction'
UNION ALL SELECT id, 'Удаление непрорезавшегося зуба', 'ru' FROM medical_services WHERE slug = 'impacted-tooth-extraction'
UNION ALL SELECT id, 'Удаление ретинированного зуба мудрости', 'ru' FROM medical_services WHERE slug = 'impacted-tooth-extraction'
UNION ALL SELECT id, 'Entfernung eines verlagerten Weisheitszahns', 'de' FROM medical_services WHERE slug = 'impacted-tooth-extraction'
UNION ALL SELECT id, 'Gömülü yirmilik diş çekimi', 'tr' FROM medical_services WHERE slug = 'impacted-tooth-extraction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Metal Ceramic Implant Crown', 'en' FROM medical_services WHERE slug = 'implant-crown-metal-ceramic'
UNION ALL SELECT id, 'Металлокерамическая коронка на импланте', 'ru' FROM medical_services WHERE slug = 'implant-crown-metal-ceramic';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Implant Superstructure', 'en' FROM medical_services WHERE slug = 'implant-suprastructure'
UNION ALL SELECT id, 'Implant Abutment', 'en' FROM medical_services WHERE slug = 'implant-suprastructure'
UNION ALL SELECT id, 'Абатмент', 'ru' FROM medical_services WHERE slug = 'implant-suprastructure'
UNION ALL SELECT id, 'İmplant abutmanı', 'tr' FROM medical_services WHERE slug = 'implant-suprastructure';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ordinacijsko izbeljivanje zuba', 'sr' FROM medical_services WHERE slug = 'in-office-teeth-whitening-single-arch'
UNION ALL SELECT id, 'Ординацијско избељивање зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'in-office-teeth-whitening-single-arch'
UNION ALL SELECT id, 'Профессиональное отбеливание зубов одной челюсти', 'ru' FROM medical_services WHERE slug = 'in-office-teeth-whitening-single-arch'
UNION ALL SELECT id, 'In-Office-Bleaching', 'de' FROM medical_services WHERE slug = 'in-office-teeth-whitening-single-arch';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'First Dental Visit', 'en' FROM medical_services WHERE slug = 'initial-dental-examination-and-medical-record-opening'
UNION ALL SELECT id, 'Prvi pregled kod zubara', 'sr' FROM medical_services WHERE slug = 'initial-dental-examination-and-medical-record-opening'
UNION ALL SELECT id, 'Први преглед код зубара', 'sr-cyrl' FROM medical_services WHERE slug = 'initial-dental-examination-and-medical-record-opening'
UNION ALL SELECT id, 'Первичный приём стоматолога', 'ru' FROM medical_services WHERE slug = 'initial-dental-examination-and-medical-record-opening'
UNION ALL SELECT id, 'İlk diş hekimi muayenesi', 'tr' FROM medical_services WHERE slug = 'initial-dental-examination-and-medical-record-opening';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Machine Root Canal Treatment per Canal', 'en' FROM medical_services WHERE slug = 'machine-root-canal-treatment-per-canal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Металлокерамика на золоте', 'ru' FROM medical_services WHERE slug = 'metal-ceramic-crown-gold'
UNION ALL SELECT id, 'Goldkeramikkrone', 'de' FROM medical_services WHERE slug = 'metal-ceramic-crown-gold'
UNION ALL SELECT id, 'Altın destekli porselen kron', 'tr' FROM medical_services WHERE slug = 'metal-ceramic-crown-gold';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Mini Implant Denture', 'en' FROM medical_services WHERE slug = 'overdenture-on-mini-implants'
UNION ALL SELECT id, 'Proteza na mini implantima', 'sr' FROM medical_services WHERE slug = 'overdenture-on-mini-implants'
UNION ALL SELECT id, 'Протеза на мини имплантима', 'sr-cyrl' FROM medical_services WHERE slug = 'overdenture-on-mini-implants'
UNION ALL SELECT id, 'Съёмный протез на мини-имплантах', 'ru' FROM medical_services WHERE slug = 'overdenture-on-mini-implants'
UNION ALL SELECT id, 'Deckprothese auf Mini-Implantaten', 'de' FROM medical_services WHERE slug = 'overdenture-on-mini-implants';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Flexible Partial Denture', 'en' FROM medical_services WHERE slug = 'partial-flexible-denture'
UNION ALL SELECT id, 'Частичный нейлоновый протез', 'ru' FROM medical_services WHERE slug = 'partial-flexible-denture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Periodontal Scaling Root Planing', 'en' FROM medical_services WHERE slug = 'periodontal-scaling-root-planing'
UNION ALL SELECT id, 'Zatvorena kiretaža parodontalnih džepova', 'sr' FROM medical_services WHERE slug = 'periodontal-scaling-root-planing'
UNION ALL SELECT id, 'Затворена киретажа пародонталних џепова', 'sr-cyrl' FROM medical_services WHERE slug = 'periodontal-scaling-root-planing'
UNION ALL SELECT id, 'Закрытый кюретаж пародонтальных карманов', 'ru' FROM medical_services WHERE slug = 'periodontal-scaling-root-planing'
UNION ALL SELECT id, 'Kök yüzeyi düzleştirme', 'tr' FROM medical_services WHERE slug = 'periodontal-scaling-root-planing';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Коронка из прессованной керамики', 'ru' FROM medical_services WHERE slug = 'pressed-ceramic-crown';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pulpitis Treatment Single Root Machine', 'en' FROM medical_services WHERE slug = 'pulpitis-treatment-single-root-machine';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pulpitis Treatment Single Root NiTi', 'en' FROM medical_services WHERE slug = 'pulpitis-treatment-single-root-niti';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pulpitis Treatment Three Root Machine', 'en' FROM medical_services WHERE slug = 'pulpitis-treatment-three-root-machine';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Prick Test Inhalation Allergens', 'en' FROM medical_services WHERE slug = 'prick-test-inhalation-allergens'
UNION ALL SELECT id, 'Prik test na inhalacione alergene', 'sr' FROM medical_services WHERE slug = 'prick-test-inhalation-allergens'
UNION ALL SELECT id, 'Прик тест на инхалационе алергене', 'sr-cyrl' FROM medical_services WHERE slug = 'prick-test-inhalation-allergens'
UNION ALL SELECT id, 'Alergološko prick testiranje', 'sr' FROM medical_services WHERE slug = 'prick-test-inhalation-allergens'
UNION ALL SELECT id, 'Алерголошко prick тестирање', 'sr-cyrl' FROM medical_services WHERE slug = 'prick-test-inhalation-allergens'
UNION ALL SELECT id, 'Прик тест на ингаляционные аллергены', 'ru' FROM medical_services WHERE slug = 'prick-test-inhalation-allergens'
UNION ALL SELECT id, 'Кожные аллергопробы на ингаляционные аллергены', 'ru' FROM medical_services WHERE slug = 'prick-test-inhalation-allergens'
UNION ALL SELECT id, 'Prick-Test auf Inhalationsallergene', 'de' FROM medical_services WHERE slug = 'prick-test-inhalation-allergens'
UNION ALL SELECT id, 'Solunum yolu alerjenleri deri testi', 'tr' FROM medical_services WHERE slug = 'prick-test-inhalation-allergens';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Prick Test Nutritive Allergens', 'en' FROM medical_services WHERE slug = 'prick-test-nutritive-allergens'
UNION ALL SELECT id, 'Prik test na nutritivne alergene', 'sr' FROM medical_services WHERE slug = 'prick-test-nutritive-allergens'
UNION ALL SELECT id, 'Прик тест на нутритивне алергене', 'sr-cyrl' FROM medical_services WHERE slug = 'prick-test-nutritive-allergens'
UNION ALL SELECT id, 'Prick test na alergene iz hrane', 'sr' FROM medical_services WHERE slug = 'prick-test-nutritive-allergens'
UNION ALL SELECT id, 'Prick тест на алергене из хране', 'sr-cyrl' FROM medical_services WHERE slug = 'prick-test-nutritive-allergens'
UNION ALL SELECT id, 'Прик тест на пищевые аллергены', 'ru' FROM medical_services WHERE slug = 'prick-test-nutritive-allergens'
UNION ALL SELECT id, 'Аллергопробы на продукты питания', 'ru' FROM medical_services WHERE slug = 'prick-test-nutritive-allergens'
UNION ALL SELECT id, 'Prick-Test auf Nahrungsmittelallergene', 'de' FROM medical_services WHERE slug = 'prick-test-nutritive-allergens'
UNION ALL SELECT id, 'Gıda alerjisi prick testi', 'tr' FROM medical_services WHERE slug = 'prick-test-nutritive-allergens';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Prick Test Nutritive and Inhalation Allergens', 'en' FROM medical_services WHERE slug = 'prick-test-nutritive-and-inhalation-allergens'
UNION ALL SELECT id, 'Prik test na nutritivne i inhalacione alergene', 'sr' FROM medical_services WHERE slug = 'prick-test-nutritive-and-inhalation-allergens'
UNION ALL SELECT id, 'Прик тест на нутритивне и инхалационе алергене', 'sr-cyrl' FROM medical_services WHERE slug = 'prick-test-nutritive-and-inhalation-allergens'
UNION ALL SELECT id, 'Прик тест на пищевые и ингаляционные аллергены', 'ru' FROM medical_services WHERE slug = 'prick-test-nutritive-and-inhalation-allergens'
UNION ALL SELECT id, 'Prick-Test auf Nahrungs- und Inhalationsallergene', 'de' FROM medical_services WHERE slug = 'prick-test-nutritive-and-inhalation-allergens';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operacija analne ragade', 'sr' FROM medical_services WHERE slug = 'anal-fissure-surgery'
UNION ALL SELECT id, 'Операција аналне рагаде', 'sr-cyrl' FROM medical_services WHERE slug = 'anal-fissure-surgery'
UNION ALL SELECT id, 'Иссечение анальной трещины', 'ru' FROM medical_services WHERE slug = 'anal-fissure-surgery'
UNION ALL SELECT id, 'Операция трещины заднего прохода', 'ru' FROM medical_services WHERE slug = 'anal-fissure-surgery'
UNION ALL SELECT id, 'Afterriss-Operation', 'de' FROM medical_services WHERE slug = 'anal-fissure-surgery'
UNION ALL SELECT id, 'Makat çatlağı ameliyatı', 'tr' FROM medical_services WHERE slug = 'anal-fissure-surgery';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Eksploracija trbušne duplje', 'sr' FROM medical_services WHERE slug = 'exploratory-laparotomy'
UNION ALL SELECT id, 'Експлорација трбушне дупље', 'sr-cyrl' FROM medical_services WHERE slug = 'exploratory-laparotomy'
UNION ALL SELECT id, 'Эксплоративная лапаротомия', 'ru' FROM medical_services WHERE slug = 'exploratory-laparotomy'
UNION ALL SELECT id, 'Ревизия брюшной полости', 'ru' FROM medical_services WHERE slug = 'exploratory-laparotomy'
UNION ALL SELECT id, 'Probelaparotomie', 'de' FROM medical_services WHERE slug = 'exploratory-laparotomy'
UNION ALL SELECT id, 'Tanısal laparotomi', 'tr' FROM medical_services WHERE slug = 'exploratory-laparotomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Gastro-entero and Entero-entero Anastomosis', 'en' FROM medical_services WHERE slug = 'gastro-entero-and-entero-entero-anastomosis'
UNION ALL SELECT id, 'Gastrojejunostomy', 'en' FROM medical_services WHERE slug = 'gastro-entero-and-entero-entero-anastomosis'
UNION ALL SELECT id, 'Gastrojejunalna anastomoza', 'sr' FROM medical_services WHERE slug = 'gastro-entero-and-entero-entero-anastomosis'
UNION ALL SELECT id, 'Гастројејунална анастомоза', 'sr-cyrl' FROM medical_services WHERE slug = 'gastro-entero-and-entero-entero-anastomosis'
UNION ALL SELECT id, 'Гастроэнтероанастомоз', 'ru' FROM medical_services WHERE slug = 'gastro-entero-and-entero-entero-anastomosis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hartmann Reconstruction', 'en' FROM medical_services WHERE slug = 'hartmann-reconstruction'
UNION ALL SELECT id, 'Hartmann Reversal', 'en' FROM medical_services WHERE slug = 'hartmann-reconstruction'
UNION ALL SELECT id, 'Zatvaranje kolostome nakon Hartmanove operacije', 'sr' FROM medical_services WHERE slug = 'hartmann-reconstruction'
UNION ALL SELECT id, 'Затварање колостоме након Хартманове операције', 'sr-cyrl' FROM medical_services WHERE slug = 'hartmann-reconstruction'
UNION ALL SELECT id, 'Закрытие колостомы после операции Гартмана', 'ru' FROM medical_services WHERE slug = 'hartmann-reconstruction'
UNION ALL SELECT id, 'Hartmann-Rückverlagerung', 'de' FROM medical_services WHERE slug = 'hartmann-reconstruction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hemorrhoid Banding', 'en' FROM medical_services WHERE slug = 'hemorrhoid-rubber-band-ligation'
UNION ALL SELECT id, 'Лигирование геморроидальных узлов', 'ru' FROM medical_services WHERE slug = 'hemorrhoid-rubber-band-ligation'
UNION ALL SELECT id, 'Barron-Ligatur', 'de' FROM medical_services WHERE slug = 'hemorrhoid-rubber-band-ligation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hemorrhoid Surgery Classic', 'en' FROM medical_services WHERE slug = 'hemorrhoid-surgery-classic'
UNION ALL SELECT id, 'Hemorrhoidectomy', 'en' FROM medical_services WHERE slug = 'hemorrhoid-surgery-classic'
UNION ALL SELECT id, 'Klasična operacija hemoroida', 'sr' FROM medical_services WHERE slug = 'hemorrhoid-surgery-classic'
UNION ALL SELECT id, 'Класична операција хемороида', 'sr-cyrl' FROM medical_services WHERE slug = 'hemorrhoid-surgery-classic'
UNION ALL SELECT id, 'Hemoroidektomija', 'sr' FROM medical_services WHERE slug = 'hemorrhoid-surgery-classic'
UNION ALL SELECT id, 'Хемороидектомија', 'sr-cyrl' FROM medical_services WHERE slug = 'hemorrhoid-surgery-classic'
UNION ALL SELECT id, 'Классическая геморроидэктомия', 'ru' FROM medical_services WHERE slug = 'hemorrhoid-surgery-classic'
UNION ALL SELECT id, 'Hämorrhoidektomie', 'de' FROM medical_services WHERE slug = 'hemorrhoid-surgery-classic';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Incarcerated Hernia Repair', 'en' FROM medical_services WHERE slug = 'incarcerated-hernia-operation'
UNION ALL SELECT id, 'Operacija uklještene hernije', 'sr' FROM medical_services WHERE slug = 'incarcerated-hernia-operation'
UNION ALL SELECT id, 'Операција укљештене херније', 'sr-cyrl' FROM medical_services WHERE slug = 'incarcerated-hernia-operation'
UNION ALL SELECT id, 'Operativno liječenje ukliještene hernije', 'sr' FROM medical_services WHERE slug = 'incarcerated-hernia-operation'
UNION ALL SELECT id, 'Оперативно лијечење уклијештене херније', 'sr-cyrl' FROM medical_services WHERE slug = 'incarcerated-hernia-operation'
UNION ALL SELECT id, 'Грыжесечение при ущемлённой грыже', 'ru' FROM medical_services WHERE slug = 'incarcerated-hernia-operation'
UNION ALL SELECT id, 'Sıkışmış fıtık ameliyatı', 'tr' FROM medical_services WHERE slug = 'incarcerated-hernia-operation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Abdominoperineal Resection', 'en' FROM medical_services WHERE slug = 'miles-rectal-amputation'
UNION ALL SELECT id, 'Abdominoperinealna resekcija rektuma', 'sr' FROM medical_services WHERE slug = 'miles-rectal-amputation'
UNION ALL SELECT id, 'Абдоминоперинеална ресекција ректума', 'sr-cyrl' FROM medical_services WHERE slug = 'miles-rectal-amputation'
UNION ALL SELECT id, 'Abdominoperineale Rektumexstirpation', 'de' FROM medical_services WHERE slug = 'miles-rectal-amputation'
UNION ALL SELECT id, 'Abdominoperineal rezeksiyon', 'tr' FROM medical_services WHERE slug = 'miles-rectal-amputation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pancreatic Head Carcinoma Whipple', 'en' FROM medical_services WHERE slug = 'pancreatic-head-carcinoma-whipple'
UNION ALL SELECT id, 'Pancreaticoduodenectomy', 'en' FROM medical_services WHERE slug = 'pancreatic-head-carcinoma-whipple'
UNION ALL SELECT id, 'Гастропанкреатодуоденальная резекция', 'ru' FROM medical_services WHERE slug = 'pancreatic-head-carcinoma-whipple'
UNION ALL SELECT id, 'Pankreaskopfresektion', 'de' FROM medical_services WHERE slug = 'pancreatic-head-carcinoma-whipple'
UNION ALL SELECT id, 'Pankreatikoduodenektomi', 'tr' FROM medical_services WHERE slug = 'pancreatic-head-carcinoma-whipple';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Операция свища прямой кишки', 'ru' FROM medical_services WHERE slug = 'perianal-fistula-surgery'
UNION ALL SELECT id, 'Операция параректального свища', 'ru' FROM medical_services WHERE slug = 'perianal-fistula-surgery';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pilonidal Cyst Surgery Classic', 'en' FROM medical_services WHERE slug = 'pilonidal-cyst-surgery-classic'
UNION ALL SELECT id, 'Klasična operacija pilonidalne ciste', 'sr' FROM medical_services WHERE slug = 'pilonidal-cyst-surgery-classic'
UNION ALL SELECT id, 'Класична операција пилонидалне цисте', 'sr-cyrl' FROM medical_services WHERE slug = 'pilonidal-cyst-surgery-classic'
UNION ALL SELECT id, 'Ekscizija pilonidalnog sinusa sa primarnim šavom', 'sr' FROM medical_services WHERE slug = 'pilonidal-cyst-surgery-classic'
UNION ALL SELECT id, 'Ексцизија пилонидалног синуса са примарним шавом', 'sr-cyrl' FROM medical_services WHERE slug = 'pilonidal-cyst-surgery-classic'
UNION ALL SELECT id, 'Иссечение копчиковой кисты', 'ru' FROM medical_services WHERE slug = 'pilonidal-cyst-surgery-classic'
UNION ALL SELECT id, 'Операция эпителиального копчикового хода', 'ru' FROM medical_services WHERE slug = 'pilonidal-cyst-surgery-classic'
UNION ALL SELECT id, 'Steißbeinfistel-Operation', 'de' FROM medical_services WHERE slug = 'pilonidal-cyst-surgery-classic'
UNION ALL SELECT id, 'Kıl dönmesi ameliyatı', 'tr' FROM medical_services WHERE slug = 'pilonidal-cyst-surgery-classic';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Хирургическое лечение копчиковой кисты', 'ru' FROM medical_services WHERE slug = 'pilonidal-sinus-surgical-treatment'
UNION ALL SELECT id, 'Chirurgische Behandlung der Steißbeinfistel', 'de' FROM medical_services WHERE slug = 'pilonidal-sinus-surgical-treatment'
UNION ALL SELECT id, 'Kıl dönmesi cerrahi tedavisi', 'tr' FROM medical_services WHERE slug = 'pilonidal-sinus-surgical-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Пластика рецидивной вентральной грыжи', 'ru' FROM medical_services WHERE slug = 'recurrent-ventral-hernia-repair'
UNION ALL SELECT id, 'Tekrarlayan karın duvarı fıtığı ameliyatı', 'tr' FROM medical_services WHERE slug = 'recurrent-ventral-hernia-repair';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Umbilical Hernia Repair', 'en' FROM medical_services WHERE slug = 'umbilical-hernia-operation'
UNION ALL SELECT id, 'Operacija umbilikalne hernije', 'sr' FROM medical_services WHERE slug = 'umbilical-hernia-operation'
UNION ALL SELECT id, 'Операција умбиликалне херније', 'sr-cyrl' FROM medical_services WHERE slug = 'umbilical-hernia-operation'
UNION ALL SELECT id, 'Пластика пупочной грыжи', 'ru' FROM medical_services WHERE slug = 'umbilical-hernia-operation'
UNION ALL SELECT id, 'Nabelhernien-Operation', 'de' FROM medical_services WHERE slug = 'umbilical-hernia-operation'
UNION ALL SELECT id, 'Umbilikal herni ameliyatı', 'tr' FROM medical_services WHERE slug = 'umbilical-hernia-operation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pulpitis Treatment Three Root NiTi', 'en' FROM medical_services WHERE slug = 'pulpitis-treatment-three-root-niti';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pulpitis Treatment Two Root Machine', 'en' FROM medical_services WHERE slug = 'pulpitis-treatment-two-root-machine';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pulpitis Treatment Two Root NiTi', 'en' FROM medical_services WHERE slug = 'pulpitis-treatment-two-root-niti';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pulp Amputation', 'en' FROM medical_services WHERE slug = 'pulpotomy'
UNION ALL SELECT id, 'Pulpotomija', 'sr' FROM medical_services WHERE slug = 'pulpotomy'
UNION ALL SELECT id, 'Пулпотомија', 'sr-cyrl' FROM medical_services WHERE slug = 'pulpotomy'
UNION ALL SELECT id, 'Ампутация пульпы', 'ru' FROM medical_services WHERE slug = 'pulpotomy'
UNION ALL SELECT id, 'Pulpaamputation', 'de' FROM medical_services WHERE slug = 'pulpotomy'
UNION ALL SELECT id, 'Pulpa amputasyonu', 'tr' FROM medical_services WHERE slug = 'pulpotomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Root Canal Retreatment Multi-Root Tooth', 'en' FROM medical_services WHERE slug = 'root-canal-retreatment-multi-root-tooth';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Root Canal Treatment First Root', 'en' FROM medical_services WHERE slug = 'root-canal-treatment-first-root';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Root Canal Treatment Second Root', 'en' FROM medical_services WHERE slug = 'root-canal-treatment-second-root';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Root Canal Treatment Third Root', 'en' FROM medical_services WHERE slug = 'root-canal-treatment-third-root';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Dental Dam', 'en' FROM medical_services WHERE slug = 'rubber-dam-application'
UNION ALL SELECT id, 'Установка кофердама', 'ru' FROM medical_services WHERE slug = 'rubber-dam-application'
UNION ALL SELECT id, 'Spanngummi', 'de' FROM medical_services WHERE slug = 'rubber-dam-application';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cast Partial Denture', 'en' FROM medical_services WHERE slug = 'skeletal-partial-denture'
UNION ALL SELECT id, 'Skeletna proteza', 'sr' FROM medical_services WHERE slug = 'skeletal-partial-denture'
UNION ALL SELECT id, 'Скелетна протеза', 'sr-cyrl' FROM medical_services WHERE slug = 'skeletal-partial-denture'
UNION ALL SELECT id, 'Бюгельное протезирование', 'ru' FROM medical_services WHERE slug = 'skeletal-partial-denture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Surgical Exposure Impacted Tooth', 'en' FROM medical_services WHERE slug = 'surgical-exposure-impacted-tooth'
UNION ALL SELECT id, 'Otkrivanje impaktiranog zuba', 'sr' FROM medical_services WHERE slug = 'surgical-exposure-impacted-tooth'
UNION ALL SELECT id, 'Откривање импактираног зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'surgical-exposure-impacted-tooth'
UNION ALL SELECT id, 'Обнажение импактированного зуба', 'ru' FROM medical_services WHERE slug = 'surgical-exposure-impacted-tooth';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hirurški šablon', 'sr' FROM medical_services WHERE slug = 'surgical-guide-per-implant'
UNION ALL SELECT id, 'Хируршки шаблон', 'sr-cyrl' FROM medical_services WHERE slug = 'surgical-guide-per-implant'
UNION ALL SELECT id, 'Навигационный шаблон для имплантации', 'ru' FROM medical_services WHERE slug = 'surgical-guide-per-implant'
UNION ALL SELECT id, 'Cerrahi rehber', 'tr' FROM medical_services WHERE slug = 'surgical-guide-per-implant';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Privremena plomba sa lijekom', 'sr' FROM medical_services WHERE slug = 'temporary-filling-with-medication'
UNION ALL SELECT id, 'Привремена пломба са лијеком', 'sr-cyrl' FROM medical_services WHERE slug = 'temporary-filling-with-medication'
UNION ALL SELECT id, 'Лекарство под временную пломбу', 'ru' FROM medical_services WHERE slug = 'temporary-filling-with-medication'
UNION ALL SELECT id, 'Временная пломба с лекарством', 'ru' FROM medical_services WHERE slug = 'temporary-filling-with-medication'
UNION ALL SELECT id, 'İlaçlı geçici dolgu', 'tr' FROM medical_services WHERE slug = 'temporary-filling-with-medication';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Tooth Extraction Complex', 'en' FROM medical_services WHERE slug = 'tooth-extraction-complex';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Tooth Extraction Simple', 'en' FROM medical_services WHERE slug = 'tooth-extraction-simple';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Burn Wound Care (Primary, Delayed Primary or Secondary)', 'en' FROM medical_services WHERE slug = 'burn-wound-care-primary-delayed-primary-or-secondary';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cauterization, Electrocauterization or Cryocauterization of Benign Skin Lesions (Extensive)', 'en' FROM medical_services WHERE slug = 'cauterization-electrocauterization-or-cryocauterization-of-benign-skin-lesions-extensive';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cauterization, Electrocauterization or Cryocauterization of Benign Skin Lesions (Larger)', 'en' FROM medical_services WHERE slug = 'cauterization-electrocauterization-or-cryocauterization-of-benign-skin-lesions-larger';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cauterization, Electrocauterization or Cryocauterization of Benign Skin Lesions (Medium)', 'en' FROM medical_services WHERE slug = 'cauterization-electrocauterization-or-cryocauterization-of-benign-skin-lesions-medium';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cauterization, Electrocauterization or Cryocauterization of Benign Skin Lesions (Multiple)', 'en' FROM medical_services WHERE slug = 'cauterization-electrocauterization-or-cryocauterization-of-benign-skin-lesions-multiple';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cauterization, Electrocauterization or Cryocauterization of Benign Skin Lesions (Small)', 'en' FROM medical_services WHERE slug = 'cauterization-electrocauterization-or-cryocauterization-of-benign-skin-lesions-small';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Earwax Removal', 'en' FROM medical_services WHERE slug = 'cerumen-ear-irrigation'
UNION ALL SELECT id, 'Удаление серной пробки', 'ru' FROM medical_services WHERE slug = 'cerumen-ear-irrigation'
UNION ALL SELECT id, 'Серная пробка', 'ru' FROM medical_services WHERE slug = 'cerumen-ear-irrigation'
UNION ALL SELECT id, 'Kulak kiri temizleme', 'tr' FROM medical_services WHERE slug = 'cerumen-ear-irrigation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cystoscopy Female', 'en' FROM medical_services WHERE slug = 'cystoscopy-female'
UNION ALL SELECT id, 'Female Cystoscopy', 'en' FROM medical_services WHERE slug = 'cystoscopy-female'
UNION ALL SELECT id, 'Cistoskopija kod žena', 'sr' FROM medical_services WHERE slug = 'cystoscopy-female'
UNION ALL SELECT id, 'Цистоскопија код жена', 'sr-cyrl' FROM medical_services WHERE slug = 'cystoscopy-female'
UNION ALL SELECT id, 'Цистоскопия у женщин', 'ru' FROM medical_services WHERE slug = 'cystoscopy-female';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cystoscopy Male', 'en' FROM medical_services WHERE slug = 'cystoscopy-male'
UNION ALL SELECT id, 'Male Cystoscopy', 'en' FROM medical_services WHERE slug = 'cystoscopy-male'
UNION ALL SELECT id, 'Cistoskopija kod muškaraca', 'sr' FROM medical_services WHERE slug = 'cystoscopy-male'
UNION ALL SELECT id, 'Цистоскопија код мушкараца', 'sr-cyrl' FROM medical_services WHERE slug = 'cystoscopy-male'
UNION ALL SELECT id, 'Цистоскопия у мужчин', 'ru' FROM medical_services WHERE slug = 'cystoscopy-male';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Excision of Small Benign Tumor Scars, Fibromas or Cysts', 'en' FROM medical_services WHERE slug = 'excision-of-small-benign-tumor-scars-fibromas-or-cysts';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Incision and Drainage of Furuncle, Carbuncle or Abscessed Cyst', 'en' FROM medical_services WHERE slug = 'incision-and-drainage-of-furuncle-carbuncle-or-abscessed-cyst'
UNION ALL SELECT id, 'Incizija furunkula', 'sr' FROM medical_services WHERE slug = 'incision-and-drainage-of-furuncle-carbuncle-or-abscessed-cyst'
UNION ALL SELECT id, 'Инцизија фурункула', 'sr-cyrl' FROM medical_services WHERE slug = 'incision-and-drainage-of-furuncle-carbuncle-or-abscessed-cyst'
UNION ALL SELECT id, 'Вскрытие фурункула', 'ru' FROM medical_services WHERE slug = 'incision-and-drainage-of-furuncle-carbuncle-or-abscessed-cyst';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Incision and Drainage of Larger Skin or Subcutaneous Abscess, Carbuncle or Hematoma', 'en' FROM medical_services WHERE slug = 'incision-and-drainage-of-larger-skin-or-subcutaneous-abscess-carbuncle-or-hematoma';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Удаление вросшего ногтя', 'ru' FROM medical_services WHERE slug = 'ingrown-toenail-surgery'
UNION ALL SELECT id, 'Tırnak batması ameliyatı', 'tr' FROM medical_services WHERE slug = 'ingrown-toenail-surgery';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Breast Lift Mastopexy', 'en' FROM medical_services WHERE slug = 'breast-lift-mastopexy'
UNION ALL SELECT id, 'Lifting grudi', 'sr' FROM medical_services WHERE slug = 'breast-lift-mastopexy'
UNION ALL SELECT id, 'Lifting груди', 'sr-cyrl' FROM medical_services WHERE slug = 'breast-lift-mastopexy'
UNION ALL SELECT id, 'Лифтинг груди', 'ru' FROM medical_services WHERE slug = 'breast-lift-mastopexy'
UNION ALL SELECT id, 'Brustlifting', 'de' FROM medical_services WHERE slug = 'breast-lift-mastopexy'
UNION ALL SELECT id, 'Göğüs dikleştirme', 'tr' FROM medical_services WHERE slug = 'breast-lift-mastopexy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Rhytidectomy', 'en' FROM medical_services WHERE slug = 'face-lift'
UNION ALL SELECT id, 'Zatezanje lica', 'sr' FROM medical_services WHERE slug = 'face-lift'
UNION ALL SELECT id, 'Затезање лица', 'sr-cyrl' FROM medical_services WHERE slug = 'face-lift'
UNION ALL SELECT id, 'Фейслифтинг', 'ru' FROM medical_services WHERE slug = 'face-lift'
UNION ALL SELECT id, 'Ритидэктомия', 'ru' FROM medical_services WHERE slug = 'face-lift'
UNION ALL SELECT id, 'Gesichtsstraffung', 'de' FROM medical_services WHERE slug = 'face-lift'
UNION ALL SELECT id, 'Yüz gerdirme', 'tr' FROM medical_services WHERE slug = 'face-lift';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ear Pinning', 'en' FROM medical_services WHERE slug = 'otoplasty'
UNION ALL SELECT id, 'Operacija klempavih ušiju', 'sr' FROM medical_services WHERE slug = 'otoplasty'
UNION ALL SELECT id, 'Операција клемпавих ушију', 'sr-cyrl' FROM medical_services WHERE slug = 'otoplasty'
UNION ALL SELECT id, 'Коррекция лопоухости', 'ru' FROM medical_services WHERE slug = 'otoplasty'
UNION ALL SELECT id, 'Ohranlegeplastik', 'de' FROM medical_services WHERE slug = 'otoplasty'
UNION ALL SELECT id, 'Kepçe kulak ameliyatı', 'tr' FROM medical_services WHERE slug = 'otoplasty';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Внутриартериальная инфузия', 'ru' FROM medical_services WHERE slug = 'intra-arterial-therapy-via-perfusor';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lymph Node Removal', 'en' FROM medical_services WHERE slug = 'lymph-node-biopsy-or-excision'
UNION ALL SELECT id, 'Biopsija limfnog čvora', 'sr' FROM medical_services WHERE slug = 'lymph-node-biopsy-or-excision'
UNION ALL SELECT id, 'Биопсија лимфног чвора', 'sr-cyrl' FROM medical_services WHERE slug = 'lymph-node-biopsy-or-excision'
UNION ALL SELECT id, 'Биопсия лимфоузла', 'ru' FROM medical_services WHERE slug = 'lymph-node-biopsy-or-excision'
UNION ALL SELECT id, 'Удаление лимфоузла', 'ru' FROM medical_services WHERE slug = 'lymph-node-biopsy-or-excision'
UNION ALL SELECT id, 'Lymphknotenentfernung', 'de' FROM medical_services WHERE slug = 'lymph-node-biopsy-or-excision'
UNION ALL SELECT id, 'Lenf bezi biyopsisi', 'tr' FROM medical_services WHERE slug = 'lymph-node-biopsy-or-excision';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'ПХО раны с наложением швов', 'ru' FROM medical_services WHERE slug = 'primary-wound-care-with-sutures'
UNION ALL SELECT id, 'Первичная хирургическая обработка раны с наложением швов', 'ru' FROM medical_services WHERE slug = 'primary-wound-care-with-sutures';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Zbrinjavanje rane bez šivanja', 'sr' FROM medical_services WHERE slug = 'primary-wound-care-without-sutures'
UNION ALL SELECT id, 'Збрињавање ране без шивања', 'sr-cyrl' FROM medical_services WHERE slug = 'primary-wound-care-without-sutures'
UNION ALL SELECT id, 'ПХО раны без наложения швов', 'ru' FROM medical_services WHERE slug = 'primary-wound-care-without-sutures'
UNION ALL SELECT id, 'Первичная хирургическая обработка раны без наложения швов', 'ru' FROM medical_services WHERE slug = 'primary-wound-care-without-sutures';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Fingerstick Glucose Test', 'en' FROM medical_services WHERE slug = 'rapid-blood-glucose-test'
UNION ALL SELECT id, 'Određivanje glikemije glukometrom', 'sr' FROM medical_services WHERE slug = 'rapid-blood-glucose-test'
UNION ALL SELECT id, 'Одређивање гликемије глукометром', 'sr-cyrl' FROM medical_services WHERE slug = 'rapid-blood-glucose-test'
UNION ALL SELECT id, 'Mjerenje šećera glukometrom', 'sr' FROM medical_services WHERE slug = 'rapid-blood-glucose-test'
UNION ALL SELECT id, 'Мјерење шећера глукометром', 'sr-cyrl' FROM medical_services WHERE slug = 'rapid-blood-glucose-test'
UNION ALL SELECT id, 'Глюкометрия', 'ru' FROM medical_services WHERE slug = 'rapid-blood-glucose-test'
UNION ALL SELECT id, 'Измерение сахара глюкометром', 'ru' FROM medical_services WHERE slug = 'rapid-blood-glucose-test'
UNION ALL SELECT id, 'Parmaktan kan şekeri ölçümü', 'tr' FROM medical_services WHERE slug = 'rapid-blood-glucose-test';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Viral Wart Surgical Removal', 'en' FROM medical_services WHERE slug = 'viral-wart-surgical-removal'
UNION ALL SELECT id, 'Wart Removal', 'en' FROM medical_services WHERE slug = 'viral-wart-surgical-removal'
UNION ALL SELECT id, 'Uklanjanje bradavica', 'sr' FROM medical_services WHERE slug = 'viral-wart-surgical-removal'
UNION ALL SELECT id, 'Уклањање брадавица', 'sr-cyrl' FROM medical_services WHERE slug = 'viral-wart-surgical-removal'
UNION ALL SELECT id, 'Удаление бородавок', 'ru' FROM medical_services WHERE slug = 'viral-wart-surgical-removal'
UNION ALL SELECT id, 'Иссечение бородавок', 'ru' FROM medical_services WHERE slug = 'viral-wart-surgical-removal'
UNION ALL SELECT id, 'Warzenentfernung', 'de' FROM medical_services WHERE slug = 'viral-wart-surgical-removal'
UNION ALL SELECT id, 'Siğil alma', 'tr' FROM medical_services WHERE slug = 'viral-wart-surgical-removal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Первичная консультация хирурга', 'ru' FROM medical_services WHERE slug = 'first-surgical-examination'
UNION ALL SELECT id, 'Первичный приём хирурга', 'ru' FROM medical_services WHERE slug = 'first-surgical-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Первичный приём торакального хирурга', 'ru' FROM medical_services WHERE slug = 'first-thoracic-surgeon-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Первичный приём сосудистого хирурга', 'ru' FROM medical_services WHERE slug = 'first-vascular-surgeon-examination'
UNION ALL SELECT id, 'Первичный приём ангиохирурга', 'ru' FROM medical_services WHERE slug = 'first-vascular-surgeon-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ponovni pregled neurohirurga', 'sr' FROM medical_services WHERE slug = 'follow-up-neurosurgeon-examination'
UNION ALL SELECT id, 'Поновни преглед неурохирурга', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-neurosurgeon-examination'
UNION ALL SELECT id, 'Повторный осмотр нейрохирурга', 'ru' FROM medical_services WHERE slug = 'follow-up-neurosurgeon-examination'
UNION ALL SELECT id, 'Повторный приём нейрохирурга', 'ru' FROM medical_services WHERE slug = 'follow-up-neurosurgeon-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kontrolni pregled hirurga', 'sr' FROM medical_services WHERE slug = 'follow-up-surgical-examination'
UNION ALL SELECT id, 'Контролни преглед хирурга', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-surgical-examination'
UNION ALL SELECT id, 'Контрольный осмотр хирурга', 'ru' FROM medical_services WHERE slug = 'follow-up-surgical-examination'
UNION ALL SELECT id, 'Повторный приём хирурга', 'ru' FROM medical_services WHERE slug = 'follow-up-surgical-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kontrolni pregled specijaliste grudne hirurgije', 'sr' FROM medical_services WHERE slug = 'follow-up-thoracic-surgeon-examination'
UNION ALL SELECT id, 'Контролни преглед специјалисте грудне хирургије', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-thoracic-surgeon-examination'
UNION ALL SELECT id, 'Ponovni pregled — grudni hirurg', 'sr' FROM medical_services WHERE slug = 'follow-up-thoracic-surgeon-examination'
UNION ALL SELECT id, 'Поновни преглед — грудни хирург', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-thoracic-surgeon-examination'
UNION ALL SELECT id, 'Повторный приём торакального хирурга', 'ru' FROM medical_services WHERE slug = 'follow-up-thoracic-surgeon-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ponovni pregled — vaskularni hirurg', 'sr' FROM medical_services WHERE slug = 'follow-up-vascular-surgeon-examination'
UNION ALL SELECT id, 'Поновни преглед — васкуларни хирург', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-vascular-surgeon-examination'
UNION ALL SELECT id, 'Повторный приём сосудистого хирурга', 'ru' FROM medical_services WHERE slug = 'follow-up-vascular-surgeon-examination'
UNION ALL SELECT id, 'Повторный приём ангиохирурга', 'ru' FROM medical_services WHERE slug = 'follow-up-vascular-surgeon-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Приём ангиохирурга', 'ru' FROM medical_services WHERE slug = 'vascular-surgeon-examination'
UNION ALL SELECT id, 'Приём флеболога', 'ru' FROM medical_services WHERE slug = 'vascular-surgeon-examination'
UNION ALL SELECT id, 'Консультация сосудистого хирурга', 'ru' FROM medical_services WHERE slug = 'vascular-surgeon-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Air-Contrast Barium Enema', 'en' FROM medical_services WHERE slug = 'double-contrast-barium-enema-fischer-method'
UNION ALL SELECT id, 'Ирригоскопия с двойным контрастированием', 'ru' FROM medical_services WHERE slug = 'double-contrast-barium-enema-fischer-method'
UNION ALL SELECT id, 'Doppelkontrasteinlauf', 'de' FROM medical_services WHERE slug = 'double-contrast-barium-enema-fischer-method';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pathological Fluid Collection and Biliary Drainage Control', 'en' FROM medical_services WHERE slug = 'pathological-fluid-collection-and-biliary-drainage-control';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Операция при туннельном синдроме запястья', 'ru' FROM medical_services WHERE slug = 'carpal-tunnel-surgery';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'EMNG DE and GE', 'en' FROM medical_services WHERE slug = 'emng-de-and-ge'
UNION ALL SELECT id, 'EMNG ruku i nogu', 'sr' FROM medical_services WHERE slug = 'emng-de-and-ge'
UNION ALL SELECT id, 'ЕМНГ руку и ногу', 'sr-cyrl' FROM medical_services WHERE slug = 'emng-de-and-ge'
UNION ALL SELECT id, 'ЭНМГ рук и ног', 'ru' FROM medical_services WHERE slug = 'emng-de-and-ge';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'EMNG DE or GE', 'en' FROM medical_services WHERE slug = 'emng-de-or-ge'
UNION ALL SELECT id, 'EMNG nogu', 'sr' FROM medical_services WHERE slug = 'emng-de-or-ge'
UNION ALL SELECT id, 'ЕМНГ ногу', 'sr-cyrl' FROM medical_services WHERE slug = 'emng-de-or-ge'
UNION ALL SELECT id, 'EMNG ruku', 'sr' FROM medical_services WHERE slug = 'emng-de-or-ge'
UNION ALL SELECT id, 'ЕМНГ руку', 'sr-cyrl' FROM medical_services WHERE slug = 'emng-de-or-ge'
UNION ALL SELECT id, 'ЭНМГ ног', 'ru' FROM medical_services WHERE slug = 'emng-de-or-ge'
UNION ALL SELECT id, 'ЭНМГ рук', 'ru' FROM medical_services WHERE slug = 'emng-de-or-ge';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ponovni pregled neurologa', 'sr' FROM medical_services WHERE slug = 'follow-up-neurologist-examination'
UNION ALL SELECT id, 'Поновни преглед неуролога', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-neurologist-examination'
UNION ALL SELECT id, 'Повторный приём невролога', 'ru' FROM medical_services WHERE slug = 'follow-up-neurologist-examination'
UNION ALL SELECT id, 'Контрольный осмотр невролога', 'ru' FROM medical_services WHERE slug = 'follow-up-neurologist-examination'
UNION ALL SELECT id, 'Kontrolluntersuchung beim Neurologen', 'de' FROM medical_services WHERE slug = 'follow-up-neurologist-examination'
UNION ALL SELECT id, 'Nöroloji kontrol muayenesi', 'tr' FROM medical_services WHERE slug = 'follow-up-neurologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Small Bowel Standard Fluoroscopic Passage', 'en' FROM medical_services WHERE slug = 'small-bowel-standard-fluoroscopic-passage'
UNION ALL SELECT id, 'Small Bowel Series', 'en' FROM medical_services WHERE slug = 'small-bowel-standard-fluoroscopic-passage'
UNION ALL SELECT id, 'Пассаж бария по тонкой кишке', 'ru' FROM medical_services WHERE slug = 'small-bowel-standard-fluoroscopic-passage'
UNION ALL SELECT id, 'İnce bağırsak pasaj grafisi', 'tr' FROM medical_services WHERE slug = 'small-bowel-standard-fluoroscopic-passage';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Targeted Upper GI Tract X-Ray', 'en' FROM medical_services WHERE slug = 'targeted-upper-gi-tract-x-ray';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'X-Ray Abdomen Native', 'en' FROM medical_services WHERE slug = 'x-ray-abdomen-native'
UNION ALL SELECT id, 'RTG abdomena', 'sr' FROM medical_services WHERE slug = 'x-ray-abdomen-native'
UNION ALL SELECT id, 'RTG абдомена', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-abdomen-native'
UNION ALL SELECT id, 'Рентген живота', 'ru' FROM medical_services WHERE slug = 'x-ray-abdomen-native'
UNION ALL SELECT id, 'Abdomenübersichtsaufnahme', 'de' FROM medical_services WHERE slug = 'x-ray-abdomen-native'
UNION ALL SELECT id, 'Direkt batın grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-abdomen-native';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG oba skočna zgloba', 'sr' FROM medical_services WHERE slug = 'x-ray-both-ankles'
UNION ALL SELECT id, 'RTG оба скочна зглоба', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-both-ankles';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG oba lakta', 'sr' FROM medical_services WHERE slug = 'x-ray-both-elbows'
UNION ALL SELECT id, 'RTG оба лакта', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-both-elbows';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG oba stopala', 'sr' FROM medical_services WHERE slug = 'x-ray-both-feet'
UNION ALL SELECT id, 'RTG оба стопала', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-both-feet';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG obje podlaktice', 'sr' FROM medical_services WHERE slug = 'x-ray-both-forearms';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG obje šake', 'sr' FROM medical_services WHERE slug = 'x-ray-both-hands';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG obje pete', 'sr' FROM medical_services WHERE slug = 'x-ray-both-heels'
UNION ALL SELECT id, 'RTG обје пете', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-both-heels';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG oba koljena', 'sr' FROM medical_services WHERE slug = 'x-ray-both-knees';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG obje potkoljenice', 'sr' FROM medical_services WHERE slug = 'x-ray-both-lower-legs'
UNION ALL SELECT id, 'Rendgen obe potkolenice', 'sr' FROM medical_services WHERE slug = 'x-ray-both-lower-legs'
UNION ALL SELECT id, 'Рендген обе потколенице', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-both-lower-legs';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG obje natkoljenice', 'sr' FROM medical_services WHERE slug = 'x-ray-both-thighs'
UNION ALL SELECT id, 'RTG обје наткољенице', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-both-thighs';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG obje nadlaktice', 'sr' FROM medical_services WHERE slug = 'x-ray-both-upper-arms';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG oba ručna zgloba', 'sr' FROM medical_services WHERE slug = 'x-ray-both-wrists';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'X-Ray Chest Heart', 'en' FROM medical_services WHERE slug = 'x-ray-chest-heart';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Elbow X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-elbow'
UNION ALL SELECT id, 'RTG lakta', 'sr' FROM medical_services WHERE slug = 'x-ray-elbow'
UNION ALL SELECT id, 'Рентген локтя', 'ru' FROM medical_services WHERE slug = 'x-ray-elbow';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Forearm X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-forearm'
UNION ALL SELECT id, 'RTG podlaktice', 'sr' FROM medical_services WHERE slug = 'x-ray-forearm'
UNION ALL SELECT id, 'Рентгенография предплечья', 'ru' FROM medical_services WHERE slug = 'x-ray-forearm'
UNION ALL SELECT id, 'Önkol grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-forearm';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Full Spine X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-full-spine'
UNION ALL SELECT id, 'Whole Spine X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-full-spine'
UNION ALL SELECT id, 'RTG cijele kičme', 'sr' FROM medical_services WHERE slug = 'x-ray-full-spine'
UNION ALL SELECT id, 'RTG цијеле кичме', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-full-spine'
UNION ALL SELECT id, 'Rendgen cele kičme', 'sr' FROM medical_services WHERE slug = 'x-ray-full-spine'
UNION ALL SELECT id, 'Рендген целе кичме', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-full-spine'
UNION ALL SELECT id, 'Рентгенография всего позвоночника', 'ru' FROM medical_services WHERE slug = 'x-ray-full-spine'
UNION ALL SELECT id, 'Рентген позвоночника полностью', 'ru' FROM medical_services WHERE slug = 'x-ray-full-spine'
UNION ALL SELECT id, 'Ganzwirbelsäulenaufnahme', 'de' FROM medical_services WHERE slug = 'x-ray-full-spine'
UNION ALL SELECT id, 'Tüm omurga grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-full-spine';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hand X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-hand'
UNION ALL SELECT id, 'RTG šake', 'sr' FROM medical_services WHERE slug = 'x-ray-hand'
UNION ALL SELECT id, 'Рентгенография кисти', 'ru' FROM medical_services WHERE slug = 'x-ray-hand'
UNION ALL SELECT id, 'Рентген кисти руки', 'ru' FROM medical_services WHERE slug = 'x-ray-hand'
UNION ALL SELECT id, 'El grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-hand';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Heel X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-heel'
UNION ALL SELECT id, 'Calcaneus X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-heel'
UNION ALL SELECT id, 'RTG pete', 'sr' FROM medical_services WHERE slug = 'x-ray-heel'
UNION ALL SELECT id, 'RTG пете', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-heel'
UNION ALL SELECT id, 'Рентген пяточной кости', 'ru' FROM medical_services WHERE slug = 'x-ray-heel'
UNION ALL SELECT id, 'Kalkaneus grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-heel';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'X-Ray Mastoid Shuller', 'en' FROM medical_services WHERE slug = 'x-ray-mastoid-shuller'
UNION ALL SELECT id, 'RTG mastoida', 'sr' FROM medical_services WHERE slug = 'x-ray-mastoid-shuller'
UNION ALL SELECT id, 'RTG мастоида', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-mastoid-shuller'
UNION ALL SELECT id, 'Рентген височных костей по Шюллеру', 'ru' FROM medical_services WHERE slug = 'x-ray-mastoid-shuller';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'X-Ray Maxilla Mandible TMJ', 'en' FROM medical_services WHERE slug = 'x-ray-maxilla-mandible-tmj'
UNION ALL SELECT id, 'TMJ X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-maxilla-mandible-tmj'
UNION ALL SELECT id, 'Рентген ВНЧС', 'ru' FROM medical_services WHERE slug = 'x-ray-maxilla-mandible-tmj';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Maxillary Sinus X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-maxillary-sinuses'
UNION ALL SELECT id, 'RTG maksilarnih sinusa', 'sr' FROM medical_services WHERE slug = 'x-ray-maxillary-sinuses'
UNION ALL SELECT id, 'RTG максиларних синуса', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-maxillary-sinuses'
UNION ALL SELECT id, 'Rendgen Hajmorovih šupljina', 'sr' FROM medical_services WHERE slug = 'x-ray-maxillary-sinuses'
UNION ALL SELECT id, 'Рендген Хајморових шупљина', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-maxillary-sinuses'
UNION ALL SELECT id, 'Рентген гайморовых пазух', 'ru' FROM medical_services WHERE slug = 'x-ray-maxillary-sinuses';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG nosa', 'sr' FROM medical_services WHERE slug = 'x-ray-nose-profiles'
UNION ALL SELECT id, 'RTG носа', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-nose-profiles';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG nosa', 'sr' FROM medical_services WHERE slug = 'x-ray-nose-with-profiles'
UNION ALL SELECT id, 'RTG носа', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-nose-with-profiles';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'X-Ray Optic Canal Rhese', 'en' FROM medical_services WHERE slug = 'x-ray-optic-canal-rhese';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Orbit X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-orbits'
UNION ALL SELECT id, 'RTG orbita', 'sr' FROM medical_services WHERE slug = 'x-ray-orbits'
UNION ALL SELECT id, 'RTG орбита', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-orbits'
UNION ALL SELECT id, 'Рентген глазниц', 'ru' FROM medical_services WHERE slug = 'x-ray-orbits';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG sele turcike', 'sr' FROM medical_services WHERE slug = 'x-ray-sella-turcica'
UNION ALL SELECT id, 'RTG turskog sedla', 'sr' FROM medical_services WHERE slug = 'x-ray-sella-turcica'
UNION ALL SELECT id, 'RTG турског седла', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-sella-turcica'
UNION ALL SELECT id, 'Рентгенография турецкого седла', 'ru' FROM medical_services WHERE slug = 'x-ray-sella-turcica';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Shoulder X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-shoulder'
UNION ALL SELECT id, 'RTG ramena', 'sr' FROM medical_services WHERE slug = 'x-ray-shoulder'
UNION ALL SELECT id, 'Рентген плеча', 'ru' FROM medical_services WHERE slug = 'x-ray-shoulder'
UNION ALL SELECT id, 'Рентгенография плечевого сустава', 'ru' FROM medical_services WHERE slug = 'x-ray-shoulder'
UNION ALL SELECT id, 'Omuz grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-shoulder';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG sinusa sa profilima', 'sr' FROM medical_services WHERE slug = 'x-ray-sinuses-with-profiles'
UNION ALL SELECT id, 'RTG синуса са профилима', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-sinuses-with-profiles';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'X-Ray Skull Towne Altchul', 'en' FROM medical_services WHERE slug = 'x-ray-skull-towne-altchul';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG temporalnih kostiju', 'sr' FROM medical_services WHERE slug = 'x-ray-temporal-bones'
UNION ALL SELECT id, 'RTG темпоралних костију', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-temporal-bones';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Thigh X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-thigh'
UNION ALL SELECT id, 'RTG natkoljenice', 'sr' FROM medical_services WHERE slug = 'x-ray-thigh'
UNION ALL SELECT id, 'RTG наткољенице', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-thigh'
UNION ALL SELECT id, 'Rendgen natkolenice', 'sr' FROM medical_services WHERE slug = 'x-ray-thigh'
UNION ALL SELECT id, 'Рендген натколенице', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-thigh'
UNION ALL SELECT id, 'Рентгенография бедра', 'ru' FROM medical_services WHERE slug = 'x-ray-thigh'
UNION ALL SELECT id, 'Uyluk grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-thigh';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG urotrakta', 'sr' FROM medical_services WHERE slug = 'x-ray-urinary-tract'
UNION ALL SELECT id, 'RTG уротракта', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-urinary-tract'
UNION ALL SELECT id, 'Рентгенография мочевыводящих путей', 'ru' FROM medical_services WHERE slug = 'x-ray-urinary-tract';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'X-Ray Urinary Tract Native', 'en' FROM medical_services WHERE slug = 'x-ray-urinary-tract-native'
UNION ALL SELECT id, 'KUB X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-urinary-tract-native'
UNION ALL SELECT id, 'Обзорная урография', 'ru' FROM medical_services WHERE slug = 'x-ray-urinary-tract-native'
UNION ALL SELECT id, 'Nierenleeraufnahme', 'de' FROM medical_services WHERE slug = 'x-ray-urinary-tract-native'
UNION ALL SELECT id, 'Direkt üriner sistem grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-urinary-tract-native'
UNION ALL SELECT id, 'DÜSG', 'tr' FROM medical_services WHERE slug = 'x-ray-urinary-tract-native';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Circumcision Local Anesthesia', 'en' FROM medical_services WHERE slug = 'circumcision-local-anesthesia'
UNION ALL SELECT id, 'Phimosis Surgery', 'en' FROM medical_services WHERE slug = 'circumcision-local-anesthesia'
UNION ALL SELECT id, 'Obrezivanje', 'sr' FROM medical_services WHERE slug = 'circumcision-local-anesthesia'
UNION ALL SELECT id, 'Обрезивање', 'sr-cyrl' FROM medical_services WHERE slug = 'circumcision-local-anesthesia'
UNION ALL SELECT id, 'Operacija fimoze', 'sr' FROM medical_services WHERE slug = 'circumcision-local-anesthesia'
UNION ALL SELECT id, 'Операција фимозе', 'sr-cyrl' FROM medical_services WHERE slug = 'circumcision-local-anesthesia'
UNION ALL SELECT id, 'Циркумцизия', 'ru' FROM medical_services WHERE slug = 'circumcision-local-anesthesia'
UNION ALL SELECT id, 'Операция при фимозе', 'ru' FROM medical_services WHERE slug = 'circumcision-local-anesthesia'
UNION ALL SELECT id, 'Beschneidung', 'de' FROM medical_services WHERE slug = 'circumcision-local-anesthesia'
UNION ALL SELECT id, 'Fimozis ameliyatı', 'tr' FROM medical_services WHERE slug = 'circumcision-local-anesthesia';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Initial Urology Consultation', 'en' FROM medical_services WHERE slug = 'first-urologist-examination'
UNION ALL SELECT id, 'Первичная консультация уролога', 'ru' FROM medical_services WHERE slug = 'first-urologist-examination'
UNION ALL SELECT id, 'Первичный приём уролога', 'ru' FROM medical_services WHERE slug = 'first-urologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ponovni pregled urologa', 'sr' FROM medical_services WHERE slug = 'follow-up-urologist-examination'
UNION ALL SELECT id, 'Поновни преглед уролога', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-urologist-examination'
UNION ALL SELECT id, 'Повторный осмотр уролога', 'ru' FROM medical_services WHERE slug = 'follow-up-urologist-examination'
UNION ALL SELECT id, 'Повторный приём уролога', 'ru' FROM medical_services WHERE slug = 'follow-up-urologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Рассечение уздечки крайней плоти', 'ru' FROM medical_services WHERE slug = 'frenulotomy'
UNION ALL SELECT id, 'Пластика уздечки крайней плоти', 'ru' FROM medical_services WHERE slug = 'frenulotomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hydrocelectomy', 'en' FROM medical_services WHERE slug = 'hydrocele-surgery'
UNION ALL SELECT id, 'Operacija hidrokele', 'sr' FROM medical_services WHERE slug = 'hydrocele-surgery'
UNION ALL SELECT id, 'Операција хидрокеле', 'sr-cyrl' FROM medical_services WHERE slug = 'hydrocele-surgery'
UNION ALL SELECT id, 'Операция при водянке яичка', 'ru' FROM medical_services WHERE slug = 'hydrocele-surgery'
UNION ALL SELECT id, 'Wasserbruch-Operation', 'de' FROM medical_services WHERE slug = 'hydrocele-surgery'
UNION ALL SELECT id, 'Su fıtığı ameliyatı', 'tr' FROM medical_services WHERE slug = 'hydrocele-surgery';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'EVLA', 'en' FROM medical_services WHERE slug = 'laser-varicose-vein-surgery'
UNION ALL SELECT id, 'Endovenous Laser Ablation', 'en' FROM medical_services WHERE slug = 'laser-varicose-vein-surgery'
UNION ALL SELECT id, 'Laserska operacija varikoznih vena', 'sr' FROM medical_services WHERE slug = 'laser-varicose-vein-surgery'
UNION ALL SELECT id, 'Ласерска операција варикозних вена', 'sr-cyrl' FROM medical_services WHERE slug = 'laser-varicose-vein-surgery'
UNION ALL SELECT id, 'ЭВЛК', 'ru' FROM medical_services WHERE slug = 'laser-varicose-vein-surgery'
UNION ALL SELECT id, 'Эндовенозная лазерная коагуляция вен', 'ru' FROM medical_services WHERE slug = 'laser-varicose-vein-surgery'
UNION ALL SELECT id, 'Лазерное лечение варикоза', 'ru' FROM medical_services WHERE slug = 'laser-varicose-vein-surgery'
UNION ALL SELECT id, 'Endovenöse Lasertherapie', 'de' FROM medical_services WHERE slug = 'laser-varicose-vein-surgery'
UNION ALL SELECT id, 'Endovenöz lazer ablasyonu', 'tr' FROM medical_services WHERE slug = 'laser-varicose-vein-surgery';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Subcapsular Orchiectomy Local Anesthesia', 'en' FROM medical_services WHERE slug = 'subcapsular-orchiectomy-local-anesthesia'
UNION ALL SELECT id, 'Subcapsular Orchidectomy', 'en' FROM medical_services WHERE slug = 'subcapsular-orchiectomy-local-anesthesia'
UNION ALL SELECT id, 'Subkapsularna orhidektomija', 'sr' FROM medical_services WHERE slug = 'subcapsular-orchiectomy-local-anesthesia'
UNION ALL SELECT id, 'Субкапсуларна орхидектомија', 'sr-cyrl' FROM medical_services WHERE slug = 'subcapsular-orchiectomy-local-anesthesia'
UNION ALL SELECT id, 'Субкапсулярная орхэктомия', 'ru' FROM medical_services WHERE slug = 'subcapsular-orchiectomy-local-anesthesia';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Vein Surgery One Leg', 'en' FROM medical_services WHERE slug = 'vein-surgery-one-leg';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Tuning Fork Tests', 'en' FROM medical_services WHERE slug = 'acumetric-hearing-tests'
UNION ALL SELECT id, 'Ispitivanje zvučnim viljuškama', 'sr' FROM medical_services WHERE slug = 'acumetric-hearing-tests'
UNION ALL SELECT id, 'Испитивање звучним виљушкама', 'sr-cyrl' FROM medical_services WHERE slug = 'acumetric-hearing-tests'
UNION ALL SELECT id, 'Камертональные пробы', 'ru' FROM medical_services WHERE slug = 'acumetric-hearing-tests'
UNION ALL SELECT id, 'Stimmgabeltest', 'de' FROM medical_services WHERE slug = 'acumetric-hearing-tests'
UNION ALL SELECT id, 'Diyapazon testi', 'tr' FROM medical_services WHERE slug = 'acumetric-hearing-tests';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Bilateral Choanal Bony Atresia Plasty', 'en' FROM medical_services WHERE slug = 'bilateral-choanal-bony-atresia-plasty';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ispitivanje prohodnosti Eustahijeve tube', 'sr' FROM medical_services WHERE slug = 'eustachian-tube-function-test'
UNION ALL SELECT id, 'Испитивање проходности Еустахијеве тубе', 'sr-cyrl' FROM medical_services WHERE slug = 'eustachian-tube-function-test'
UNION ALL SELECT id, 'Исследование проходимости слуховой трубы', 'ru' FROM medical_services WHERE slug = 'eustachian-tube-function-test'
UNION ALL SELECT id, 'Tubenfunktionsprüfung', 'de' FROM medical_services WHERE slug = 'eustachian-tube-function-test'
UNION ALL SELECT id, 'Östaki borusu fonksiyon testi', 'tr' FROM medical_services WHERE slug = 'eustachian-tube-function-test';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Prvi pregled otorinolaringologa', 'sr' FROM medical_services WHERE slug = 'first-ent-examination'
UNION ALL SELECT id, 'Први преглед оториноларинголога', 'sr-cyrl' FROM medical_services WHERE slug = 'first-ent-examination'
UNION ALL SELECT id, 'Первичный приём ЛОР-врача', 'ru' FROM medical_services WHERE slug = 'first-ent-examination'
UNION ALL SELECT id, 'HNO-Erstuntersuchung', 'de' FROM medical_services WHERE slug = 'first-ent-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kontrolni pregled otorinolaringologa', 'sr' FROM medical_services WHERE slug = 'follow-up-ent-examination'
UNION ALL SELECT id, 'Контролни преглед оториноларинголога', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-ent-examination'
UNION ALL SELECT id, 'Повторный приём ЛОР-врача', 'ru' FROM medical_services WHERE slug = 'follow-up-ent-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Вскрытие флюса', 'ru' FROM medical_services WHERE slug = 'intraoral-abscess-incision';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kontrolni pregled gastroenterohepatologa', 'sr' FROM medical_services WHERE slug = 'follow-up-gastroenterologist-examination'
UNION ALL SELECT id, 'Контролни преглед gastroenterohepatologa', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-gastroenterologist-examination'
UNION ALL SELECT id, 'Повторный приём гастроэнтеролога', 'ru' FROM medical_services WHERE slug = 'follow-up-gastroenterologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Liver Biopsy Local Anesthesia', 'en' FROM medical_services WHERE slug = 'liver-biopsy-local-anesthesia'
UNION ALL SELECT id, 'Percutaneous Liver Biopsy', 'en' FROM medical_services WHERE slug = 'liver-biopsy-local-anesthesia'
UNION ALL SELECT id, 'Perkutana biopsija jetre', 'sr' FROM medical_services WHERE slug = 'liver-biopsy-local-anesthesia'
UNION ALL SELECT id, 'Перкутана биопсија јетре', 'sr-cyrl' FROM medical_services WHERE slug = 'liver-biopsy-local-anesthesia'
UNION ALL SELECT id, 'Пункционная биопсия печени', 'ru' FROM medical_services WHERE slug = 'liver-biopsy-local-anesthesia'
UNION ALL SELECT id, 'Leberpunktion', 'de' FROM medical_services WHERE slug = 'liver-biopsy-local-anesthesia';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Incizija perianalnog apscesa', 'sr' FROM medical_services WHERE slug = 'perianal-abscess-incision-and-drainage'
UNION ALL SELECT id, 'Инцизија перианалног апсцеса', 'sr-cyrl' FROM medical_services WHERE slug = 'perianal-abscess-incision-and-drainage'
UNION ALL SELECT id, 'Вскрытие парапроктита', 'ru' FROM medical_services WHERE slug = 'perianal-abscess-incision-and-drainage';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ректоскопия под наркозом', 'ru' FROM medical_services WHERE slug = 'rectoscopy-with-anesthesia';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Glaucoma Screening', 'en' FROM medical_services WHERE slug = 'complete-glaucoma-examination'
UNION ALL SELECT id, 'Dijagnostika glaukoma', 'sr' FROM medical_services WHERE slug = 'complete-glaucoma-examination'
UNION ALL SELECT id, 'Дијагностика глаукома', 'sr-cyrl' FROM medical_services WHERE slug = 'complete-glaucoma-examination'
UNION ALL SELECT id, 'Диагностика глаукомы', 'ru' FROM medical_services WHERE slug = 'complete-glaucoma-examination'
UNION ALL SELECT id, 'Проверка на глаукому', 'ru' FROM medical_services WHERE slug = 'complete-glaucoma-examination'
UNION ALL SELECT id, 'Glaukomvorsorge', 'de' FROM medical_services WHERE slug = 'complete-glaucoma-examination'
UNION ALL SELECT id, 'Glokom taraması', 'tr' FROM medical_services WHERE slug = 'complete-glaucoma-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Contact Lens Fitting and Care Training', 'en' FROM medical_services WHERE slug = 'contact-lens-fitting-and-care-training';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Diurnal Tension Curve', 'en' FROM medical_services WHERE slug = 'daily-intraocular-pressure-profile'
UNION ALL SELECT id, 'Dnevna kriva očnog pritiska', 'sr' FROM medical_services WHERE slug = 'daily-intraocular-pressure-profile'
UNION ALL SELECT id, 'Дневна крива очног притиска', 'sr-cyrl' FROM medical_services WHERE slug = 'daily-intraocular-pressure-profile'
UNION ALL SELECT id, 'Суточная тонометрия', 'ru' FROM medical_services WHERE slug = 'daily-intraocular-pressure-profile'
UNION ALL SELECT id, 'Augeninnendruck-Tagesprofil', 'de' FROM medical_services WHERE slug = 'daily-intraocular-pressure-profile';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Refraction Test', 'en' FROM medical_services WHERE slug = 'diopter-determination'
UNION ALL SELECT id, 'Mjerenje dioptrije', 'sr' FROM medical_services WHERE slug = 'diopter-determination'
UNION ALL SELECT id, 'Мјерење диоптрије', 'sr-cyrl' FROM medical_services WHERE slug = 'diopter-determination'
UNION ALL SELECT id, 'Определение рефракции', 'ru' FROM medical_services WHERE slug = 'diopter-determination'
UNION ALL SELECT id, 'Refraktionsbestimmung', 'de' FROM medical_services WHERE slug = 'diopter-determination'
UNION ALL SELECT id, 'Göz numarası ölçümü', 'tr' FROM medical_services WHERE slug = 'diopter-determination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Dry Eye Test Schirmer', 'en' FROM medical_services WHERE slug = 'dry-eye-test-schirmer'
UNION ALL SELECT id, 'Širmerov test', 'sr' FROM medical_services WHERE slug = 'dry-eye-test-schirmer'
UNION ALL SELECT id, 'Ширмеров тест', 'sr-cyrl' FROM medical_services WHERE slug = 'dry-eye-test-schirmer'
UNION ALL SELECT id, 'Диагностика синдрома сухого глаза', 'ru' FROM medical_services WHERE slug = 'dry-eye-test-schirmer';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Exophthalmometry Hertel', 'en' FROM medical_services WHERE slug = 'exophthalmometry-hertel';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Follow-up Eye Exam', 'en' FROM medical_services WHERE slug = 'follow-up-ophthalmologist-examination'
UNION ALL SELECT id, 'Ponovni pregled oftalmologa', 'sr' FROM medical_services WHERE slug = 'follow-up-ophthalmologist-examination'
UNION ALL SELECT id, 'Поновни преглед офталмолога', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-ophthalmologist-examination'
UNION ALL SELECT id, 'Контрольный осмотр офтальмолога', 'ru' FROM medical_services WHERE slug = 'follow-up-ophthalmologist-examination'
UNION ALL SELECT id, 'Повторный приём окулиста', 'ru' FROM medical_services WHERE slug = 'follow-up-ophthalmologist-examination'
UNION ALL SELECT id, 'Kontrolluntersuchung beim Augenarzt', 'de' FROM medical_services WHERE slug = 'follow-up-ophthalmologist-examination'
UNION ALL SELECT id, 'Göz doktoru kontrol muayenesi', 'tr' FROM medical_services WHERE slug = 'follow-up-ophthalmologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Foreign Body Removal Eye', 'en' FROM medical_services WHERE slug = 'foreign-body-removal-eye'
UNION ALL SELECT id, 'Vađenje stranog tijela iz oka', 'sr' FROM medical_services WHERE slug = 'foreign-body-removal-eye'
UNION ALL SELECT id, 'Вађење страног тијела из ока', 'sr-cyrl' FROM medical_services WHERE slug = 'foreign-body-removal-eye'
UNION ALL SELECT id, 'Uklanjanje stranog tela iz oka', 'sr' FROM medical_services WHERE slug = 'foreign-body-removal-eye'
UNION ALL SELECT id, 'Уклањање страног тела из ока', 'sr-cyrl' FROM medical_services WHERE slug = 'foreign-body-removal-eye'
UNION ALL SELECT id, 'Удаление соринки из глаза', 'ru' FROM medical_services WHERE slug = 'foreign-body-removal-eye'
UNION ALL SELECT id, 'Удаление окалины из глаза', 'ru' FROM medical_services WHERE slug = 'foreign-body-removal-eye'
UNION ALL SELECT id, 'Gözden çapak çıkarma', 'tr' FROM medical_services WHERE slug = 'foreign-body-removal-eye';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Tonometry', 'en' FROM medical_services WHERE slug = 'intraocular-pressure-determination'
UNION ALL SELECT id, 'Eye Pressure Test', 'en' FROM medical_services WHERE slug = 'intraocular-pressure-determination'
UNION ALL SELECT id, 'Tonometrija', 'sr' FROM medical_services WHERE slug = 'intraocular-pressure-determination'
UNION ALL SELECT id, 'Тонометрија', 'sr-cyrl' FROM medical_services WHERE slug = 'intraocular-pressure-determination'
UNION ALL SELECT id, 'Merenje očnog pritiska', 'sr' FROM medical_services WHERE slug = 'intraocular-pressure-determination'
UNION ALL SELECT id, 'Мерење очног притиска', 'sr-cyrl' FROM medical_services WHERE slug = 'intraocular-pressure-determination'
UNION ALL SELECT id, 'Тонометрия глаза', 'ru' FROM medical_services WHERE slug = 'intraocular-pressure-determination'
UNION ALL SELECT id, 'Измерение глазного давления', 'ru' FROM medical_services WHERE slug = 'intraocular-pressure-determination'
UNION ALL SELECT id, 'Göz tansiyonu ölçümü', 'tr' FROM medical_services WHERE slug = 'intraocular-pressure-determination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Intravitreal Drug Application', 'en' FROM medical_services WHERE slug = 'intravitreal-drug-application'
UNION ALL SELECT id, 'Intravitreal Injection', 'en' FROM medical_services WHERE slug = 'intravitreal-drug-application'
UNION ALL SELECT id, 'Intravitrealna injekcija', 'sr' FROM medical_services WHERE slug = 'intravitreal-drug-application'
UNION ALL SELECT id, 'Интравитреална инјекција', 'sr-cyrl' FROM medical_services WHERE slug = 'intravitreal-drug-application'
UNION ALL SELECT id, 'Интравитреальное введение препарата', 'ru' FROM medical_services WHERE slug = 'intravitreal-drug-application'
UNION ALL SELECT id, 'Укол в глаз', 'ru' FROM medical_services WHERE slug = 'intravitreal-drug-application'
UNION ALL SELECT id, 'IVOM', 'de' FROM medical_services WHERE slug = 'intravitreal-drug-application'
UNION ALL SELECT id, 'Göz içi iğne tedavisi', 'tr' FROM medical_services WHERE slug = 'intravitreal-drug-application';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lacrimal Duct Irrigation Children', 'en' FROM medical_services WHERE slug = 'lacrimal-duct-irrigation-children'
UNION ALL SELECT id, 'Tear Duct Irrigation in Children', 'en' FROM medical_services WHERE slug = 'lacrimal-duct-irrigation-children'
UNION ALL SELECT id, 'Ispiranje suznih puteva kod djece', 'sr' FROM medical_services WHERE slug = 'lacrimal-duct-irrigation-children'
UNION ALL SELECT id, 'Испирање сузних путева код дјеце', 'sr-cyrl' FROM medical_services WHERE slug = 'lacrimal-duct-irrigation-children'
UNION ALL SELECT id, 'Промывание носослёзного канала у детей', 'ru' FROM medical_services WHERE slug = 'lacrimal-duct-irrigation-children';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ophthalmological Examination Contact Lenses', 'en' FROM medical_services WHERE slug = 'ophthalmological-examination-contact-lenses';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Xanthelasma Removal Eye Area', 'en' FROM medical_services WHERE slug = 'xanthelasma-removal-eye-area'
UNION ALL SELECT id, 'Удаление жировых бляшек на веках', 'ru' FROM medical_services WHERE slug = 'xanthelasma-removal-eye-area';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Диагностика прикуса', 'ru' FROM medical_services WHERE slug = 'comprehensive-orthodontic-diagnostics';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ceramic Braces', 'en' FROM medical_services WHERE slug = 'fixed-braces-ceramic-or-composite-per-jaw'
UNION ALL SELECT id, 'Keramički breketi', 'sr' FROM medical_services WHERE slug = 'fixed-braces-ceramic-or-composite-per-jaw'
UNION ALL SELECT id, 'Керамички брекети', 'sr-cyrl' FROM medical_services WHERE slug = 'fixed-braces-ceramic-or-composite-per-jaw'
UNION ALL SELECT id, 'Керамические брекеты', 'ru' FROM medical_services WHERE slug = 'fixed-braces-ceramic-or-composite-per-jaw'
UNION ALL SELECT id, 'Keramikbrackets', 'de' FROM medical_services WHERE slug = 'fixed-braces-ceramic-or-composite-per-jaw'
UNION ALL SELECT id, 'Seramik braket', 'tr' FROM medical_services WHERE slug = 'fixed-braces-ceramic-or-composite-per-jaw';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Metal Braces', 'en' FROM medical_services WHERE slug = 'fixed-braces-metal-per-jaw'
UNION ALL SELECT id, 'Metalni breketi', 'sr' FROM medical_services WHERE slug = 'fixed-braces-metal-per-jaw'
UNION ALL SELECT id, 'Метални брекети', 'sr-cyrl' FROM medical_services WHERE slug = 'fixed-braces-metal-per-jaw'
UNION ALL SELECT id, 'Металлические брекеты', 'ru' FROM medical_services WHERE slug = 'fixed-braces-metal-per-jaw'
UNION ALL SELECT id, 'Metallbrackets', 'de' FROM medical_services WHERE slug = 'fixed-braces-metal-per-jaw'
UNION ALL SELECT id, 'Metal diş teli', 'tr' FROM medical_services WHERE slug = 'fixed-braces-metal-per-jaw';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Sapphire Braces', 'en' FROM medical_services WHERE slug = 'fixed-braces-sapphire-per-jaw'
UNION ALL SELECT id, 'Safirni breketi', 'sr' FROM medical_services WHERE slug = 'fixed-braces-sapphire-per-jaw'
UNION ALL SELECT id, 'Сафирни брекети', 'sr-cyrl' FROM medical_services WHERE slug = 'fixed-braces-sapphire-per-jaw'
UNION ALL SELECT id, 'Сапфировые брекеты', 'ru' FROM medical_services WHERE slug = 'fixed-braces-sapphire-per-jaw'
UNION ALL SELECT id, 'Saphirbrackets', 'de' FROM medical_services WHERE slug = 'fixed-braces-sapphire-per-jaw';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Breketi', 'sr' FROM medical_services WHERE slug = 'fixed-orthodontic-braces-per-arch'
UNION ALL SELECT id, 'Брекети', 'sr-cyrl' FROM medical_services WHERE slug = 'fixed-orthodontic-braces-per-arch'
UNION ALL SELECT id, 'Fiksni aparatić za zube', 'sr' FROM medical_services WHERE slug = 'fixed-orthodontic-braces-per-arch'
UNION ALL SELECT id, 'Фиксни апаратић за зубе', 'sr-cyrl' FROM medical_services WHERE slug = 'fixed-orthodontic-braces-per-arch'
UNION ALL SELECT id, 'Установка брекетов', 'ru' FROM medical_services WHERE slug = 'fixed-orthodontic-braces-per-arch'
UNION ALL SELECT id, 'Diş teli', 'tr' FROM medical_services WHERE slug = 'fixed-orthodontic-braces-per-arch';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Braces Check-up', 'en' FROM medical_services WHERE slug = 'fixed-orthodontic-check-up'
UNION ALL SELECT id, 'Kontrola breketa', 'sr' FROM medical_services WHERE slug = 'fixed-orthodontic-check-up'
UNION ALL SELECT id, 'Контрола брекета', 'sr-cyrl' FROM medical_services WHERE slug = 'fixed-orthodontic-check-up'
UNION ALL SELECT id, 'Diş teli kontrolü', 'tr' FROM medical_services WHERE slug = 'fixed-orthodontic-check-up';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ретайнер', 'ru' FROM medical_services WHERE slug = 'orthodontic-retainer';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Установка ретайнера', 'ru' FROM medical_services WHERE slug = 'retainer-placement-per-arch'
UNION ALL SELECT id, 'Фиксация ретейнера', 'ru' FROM medical_services WHERE slug = 'retainer-placement-per-arch';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Безлигатурные керамические брекеты', 'ru' FROM medical_services WHERE slug = 'self-ligating-braces-ceramic-per-jaw'
UNION ALL SELECT id, 'Selbstligierende Keramikbrackets', 'de' FROM medical_services WHERE slug = 'self-ligating-braces-ceramic-per-jaw';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Безлигатурные металлические брекеты', 'ru' FROM medical_services WHERE slug = 'self-ligating-braces-metal-per-jaw'
UNION ALL SELECT id, 'Selbstligierende Metallbrackets', 'de' FROM medical_services WHERE slug = 'self-ligating-braces-metal-per-jaw';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Enema Administration Medium', 'en' FROM medical_services WHERE slug = 'enema-administration-medium';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Erythrocyte Suspension in OAS Preparation', 'en' FROM medical_services WHERE slug = 'erythrocyte-suspension-in-oas-preparation'
UNION ALL SELECT id, 'Эритроцитная взвесь', 'ru' FROM medical_services WHERE slug = 'erythrocyte-suspension-in-oas-preparation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Leukoreduced Red Blood Cells', 'en' FROM medical_services WHERE slug = 'filtered-erythrocyte-preparation'
UNION ALL SELECT id, 'Лейкофильтрация эритроцитов', 'ru' FROM medical_services WHERE slug = 'filtered-erythrocyte-preparation'
UNION ALL SELECT id, 'Leukozytendepletierte Erythrozyten', 'de' FROM medical_services WHERE slug = 'filtered-erythrocyte-preparation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Inhalation Administration', 'en' FROM medical_services WHERE slug = 'inhalation-administration'
UNION ALL SELECT id, 'Davanje inhalacije', 'sr' FROM medical_services WHERE slug = 'inhalation-administration'
UNION ALL SELECT id, 'Давање инхалације', 'sr-cyrl' FROM medical_services WHERE slug = 'inhalation-administration'
UNION ALL SELECT id, 'Inhalacija', 'sr' FROM medical_services WHERE slug = 'inhalation-administration'
UNION ALL SELECT id, 'Инхалација', 'sr-cyrl' FROM medical_services WHERE slug = 'inhalation-administration'
UNION ALL SELECT id, 'Ингаляция', 'ru' FROM medical_services WHERE slug = 'inhalation-administration';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Injection Materials Consumption', 'en' FROM medical_services WHERE slug = 'injection-materials-consumption';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Joint Injection', 'en' FROM medical_services WHERE slug = 'intra-articular-injection'
UNION ALL SELECT id, 'Injekcija u zglob', 'sr' FROM medical_services WHERE slug = 'intra-articular-injection'
UNION ALL SELECT id, 'Инјекција у зглоб', 'sr-cyrl' FROM medical_services WHERE slug = 'intra-articular-injection'
UNION ALL SELECT id, 'Укол в сустав', 'ru' FROM medical_services WHERE slug = 'intra-articular-injection'
UNION ALL SELECT id, 'Блокада сустава', 'ru' FROM medical_services WHERE slug = 'intra-articular-injection'
UNION ALL SELECT id, 'Gelenkinjektion', 'de' FROM medical_services WHERE slug = 'intra-articular-injection'
UNION ALL SELECT id, 'Eklem içi enjeksiyon', 'tr' FROM medical_services WHERE slug = 'intra-articular-injection';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Washed Red Blood Cells', 'en' FROM medical_services WHERE slug = 'washed-erythrocyte-preparation'
UNION ALL SELECT id, 'Oprani eritrociti', 'sr' FROM medical_services WHERE slug = 'washed-erythrocyte-preparation'
UNION ALL SELECT id, 'Опрани еритроцити', 'sr-cyrl' FROM medical_services WHERE slug = 'washed-erythrocyte-preparation'
UNION ALL SELECT id, 'Отмытые эритроциты', 'ru' FROM medical_services WHERE slug = 'washed-erythrocyte-preparation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ambulatory Large Dressing', 'en' FROM medical_services WHERE slug = 'ambulatory-large-dressing';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ambulatory Small Dressing', 'en' FROM medical_services WHERE slug = 'ambulatory-small-dressing';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Artificial Anus Care', 'en' FROM medical_services WHERE slug = 'artificial-anus-care';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operation Large Dressing', 'en' FROM medical_services WHERE slug = 'operation-large-dressing';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operation Medium Dressing I', 'en' FROM medical_services WHERE slug = 'operation-medium-dressing-i';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operation Medium Dressing II', 'en' FROM medical_services WHERE slug = 'operation-medium-dressing-ii';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operation Small Dressing II', 'en' FROM medical_services WHERE slug = 'operation-small-dressing-ii';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operacija sive mrene', 'sr' FROM medical_services WHERE slug = 'cataract-surgery-with-standard-iol'
UNION ALL SELECT id, 'Операција сиве мрене', 'sr-cyrl' FROM medical_services WHERE slug = 'cataract-surgery-with-standard-iol'
UNION ALL SELECT id, 'Замена хрусталика', 'ru' FROM medical_services WHERE slug = 'cataract-surgery-with-standard-iol'
UNION ALL SELECT id, 'Операция катаракты', 'ru' FROM medical_services WHERE slug = 'cataract-surgery-with-standard-iol'
UNION ALL SELECT id, 'Grauer-Star-Operation', 'de' FROM medical_services WHERE slug = 'cataract-surgery-with-standard-iol'
UNION ALL SELECT id, 'Göz perdesi ameliyatı', 'tr' FROM medical_services WHERE slug = 'cataract-surgery-with-standard-iol';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Chalazion Removal Local Anesthesia', 'en' FROM medical_services WHERE slug = 'chalazion-removal-local-anesthesia'
UNION ALL SELECT id, 'Удаление градины века', 'ru' FROM medical_services WHERE slug = 'chalazion-removal-local-anesthesia'
UNION ALL SELECT id, 'Hagelkorn-Entfernung', 'de' FROM medical_services WHERE slug = 'chalazion-removal-local-anesthesia';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operacija pterigijuma', 'sr' FROM medical_services WHERE slug = 'pterygium-removal'
UNION ALL SELECT id, 'Операција птеригијума', 'sr-cyrl' FROM medical_services WHERE slug = 'pterygium-removal'
UNION ALL SELECT id, 'Удаление крыловидной плевы', 'ru' FROM medical_services WHERE slug = 'pterygium-removal'
UNION ALL SELECT id, 'Flügelfell-Entfernung', 'de' FROM medical_services WHERE slug = 'pterygium-removal'
UNION ALL SELECT id, 'Göz eti ameliyatı', 'tr' FROM medical_services WHERE slug = 'pterygium-removal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Chest Tube Insertion', 'en' FROM medical_services WHERE slug = 'pleural-drainage'
UNION ALL SELECT id, 'Pleuralna drenaža', 'sr' FROM medical_services WHERE slug = 'pleural-drainage'
UNION ALL SELECT id, 'Плеурална дренажа', 'sr-cyrl' FROM medical_services WHERE slug = 'pleural-drainage'
UNION ALL SELECT id, 'Torakalna drenaža', 'sr' FROM medical_services WHERE slug = 'pleural-drainage'
UNION ALL SELECT id, 'Торакална дренажа', 'sr-cyrl' FROM medical_services WHERE slug = 'pleural-drainage'
UNION ALL SELECT id, 'Установка плеврального дренажа', 'ru' FROM medical_services WHERE slug = 'pleural-drainage'
UNION ALL SELECT id, 'Thoraxdrainage', 'de' FROM medical_services WHERE slug = 'pleural-drainage'
UNION ALL SELECT id, 'Göğüs tüpü takılması', 'tr' FROM medical_services WHERE slug = 'pleural-drainage';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kardiorehabilitacija', 'sr' FROM medical_services WHERE slug = 'cardiac-rehabilitation-bed-day'
UNION ALL SELECT id, 'Кардиорехабилитација', 'sr-cyrl' FROM medical_services WHERE slug = 'cardiac-rehabilitation-bed-day'
UNION ALL SELECT id, 'Кардиореабилитация', 'ru' FROM medical_services WHERE slug = 'cardiac-rehabilitation-bed-day';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kardioverzija', 'sr' FROM medical_services WHERE slug = 'cardiac-rhythm-cardioversion'
UNION ALL SELECT id, 'Кардиоверзија', 'sr-cyrl' FROM medical_services WHERE slug = 'cardiac-rhythm-cardioversion';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'ECG Telemetry', 'en' FROM medical_services WHERE slug = 'cardiac-telemetry'
UNION ALL SELECT id, 'EKG telemetrija', 'sr' FROM medical_services WHERE slug = 'cardiac-telemetry'
UNION ALL SELECT id, 'ЕКГ телеметрија', 'sr-cyrl' FROM medical_services WHERE slug = 'cardiac-telemetry'
UNION ALL SELECT id, 'Телеметрия ЭКГ', 'ru' FROM medical_services WHERE slug = 'cardiac-telemetry'
UNION ALL SELECT id, 'Кардиотелеметрия', 'ru' FROM medical_services WHERE slug = 'cardiac-telemetry'
UNION ALL SELECT id, 'EKG-Telemetrie', 'de' FROM medical_services WHERE slug = 'cardiac-telemetry';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Приём кардиолога с ЭКГ и УЗИ сердца', 'ru' FROM medical_services WHERE slug = 'cardiologist-examination-with-ecg-and-echocardiography-heart-ultrasound'
UNION ALL SELECT id, 'Осмотр кардиолога с ЭКГ и ЭхоКГ', 'ru' FROM medical_services WHERE slug = 'cardiologist-examination-with-ecg-and-echocardiography-heart-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cardiac Ultrasound', 'en' FROM medical_services WHERE slug = 'echocardiography-heart-ultrasound'
UNION ALL SELECT id, 'Transthoracic Echocardiography', 'en' FROM medical_services WHERE slug = 'echocardiography-heart-ultrasound'
UNION ALL SELECT id, 'Eho srca', 'sr' FROM medical_services WHERE slug = 'echocardiography-heart-ultrasound'
UNION ALL SELECT id, 'Ехо срца', 'sr-cyrl' FROM medical_services WHERE slug = 'echocardiography-heart-ultrasound'
UNION ALL SELECT id, 'UZ srca', 'sr' FROM medical_services WHERE slug = 'echocardiography-heart-ultrasound'
UNION ALL SELECT id, 'УЗ срца', 'sr-cyrl' FROM medical_services WHERE slug = 'echocardiography-heart-ultrasound'
UNION ALL SELECT id, 'ЭхоКГ', 'ru' FROM medical_services WHERE slug = 'echocardiography-heart-ultrasound'
UNION ALL SELECT id, 'Эхо сердца', 'ru' FROM medical_services WHERE slug = 'echocardiography-heart-ultrasound'
UNION ALL SELECT id, 'Herzecho', 'de' FROM medical_services WHERE slug = 'echocardiography-heart-ultrasound'
UNION ALL SELECT id, 'Transthorakale Echokardiographie', 'de' FROM medical_services WHERE slug = 'echocardiography-heart-ultrasound'
UNION ALL SELECT id, 'Kalp Ekosu', 'tr' FROM medical_services WHERE slug = 'echocardiography-heart-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'ВЭМ-проба', 'ru' FROM medical_services WHERE slug = 'ergocycle-stress-test-with-complete-ecg'
UNION ALL SELECT id, 'Fahrradergometrie', 'de' FROM medical_services WHERE slug = 'ergocycle-stress-test-with-complete-ecg';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Exercise ECG', 'en' FROM medical_services WHERE slug = 'ergometry-ecg-stress-test'
UNION ALL SELECT id, 'Dinamska elektrokardiografija', 'sr' FROM medical_services WHERE slug = 'ergometry-ecg-stress-test'
UNION ALL SELECT id, 'Динамска електрокардиографија', 'sr-cyrl' FROM medical_services WHERE slug = 'ergometry-ecg-stress-test'
UNION ALL SELECT id, 'ЭКГ с нагрузкой', 'ru' FROM medical_services WHERE slug = 'ergometry-ecg-stress-test';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Exercise Stress Test', 'en' FROM medical_services WHERE slug = 'ergometry-stress-test'
UNION ALL SELECT id, 'Проба с физической нагрузкой', 'ru' FROM medical_services WHERE slug = 'ergometry-stress-test';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ponovni pregled kardiologa', 'sr' FROM medical_services WHERE slug = 'follow-up-cardiologist-examination'
UNION ALL SELECT id, 'Поновни преглед кардиолога', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-cardiologist-examination'
UNION ALL SELECT id, 'Повторный приём кардиолога', 'ru' FROM medical_services WHERE slug = 'follow-up-cardiologist-examination'
UNION ALL SELECT id, 'Повторный осмотр кардиолога', 'ru' FROM medical_services WHERE slug = 'follow-up-cardiologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Консультация профессора-кардиолога', 'ru' FROM medical_services WHERE slug = 'professor-cardiologist-examination'
UNION ALL SELECT id, 'Приём профессора-кардиолога', 'ru' FROM medical_services WHERE slug = 'professor-cardiologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Abdominal Hysterectomy with Conservation', 'en' FROM medical_services WHERE slug = 'abdominal-hysterectomy-with-conservation'
UNION ALL SELECT id, 'Hysterectomy with Ovarian Preservation', 'en' FROM medical_services WHERE slug = 'abdominal-hysterectomy-with-conservation'
UNION ALL SELECT id, 'Uklanjanje materice uz očuvanje jajnika', 'sr' FROM medical_services WHERE slug = 'abdominal-hysterectomy-with-conservation'
UNION ALL SELECT id, 'Уклањање материце уз очување јајника', 'sr-cyrl' FROM medical_services WHERE slug = 'abdominal-hysterectomy-with-conservation'
UNION ALL SELECT id, 'Удаление матки с сохранением придатков', 'ru' FROM medical_services WHERE slug = 'abdominal-hysterectomy-with-conservation'
UNION ALL SELECT id, 'Удаление матки с сохранением яичников', 'ru' FROM medical_services WHERE slug = 'abdominal-hysterectomy-with-conservation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Bartholin Abscess Drainage', 'en' FROM medical_services WHERE slug = 'bartholin-gland-incision'
UNION ALL SELECT id, 'Incizija Bartolinove žlijezde', 'sr' FROM medical_services WHERE slug = 'bartholin-gland-incision'
UNION ALL SELECT id, 'Инцизија Бартолинове жлијезде', 'sr-cyrl' FROM medical_services WHERE slug = 'bartholin-gland-incision'
UNION ALL SELECT id, 'Вскрытие бартолинита', 'ru' FROM medical_services WHERE slug = 'bartholin-gland-incision'
UNION ALL SELECT id, 'Вскрытие абсцесса бартолиновой железы', 'ru' FROM medical_services WHERE slug = 'bartholin-gland-incision'
UNION ALL SELECT id, 'Bartolin apsesi drenajı', 'tr' FROM medical_services WHERE slug = 'bartholin-gland-incision';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cervix Amputation', 'en' FROM medical_services WHERE slug = 'cervical-amputation'
UNION ALL SELECT id, 'Amputacija cerviksa', 'sr' FROM medical_services WHERE slug = 'cervical-amputation'
UNION ALL SELECT id, 'Ампутација цервикса', 'sr-cyrl' FROM medical_services WHERE slug = 'cervical-amputation'
UNION ALL SELECT id, 'Portioamputation', 'de' FROM medical_services WHERE slug = 'cervical-amputation'
UNION ALL SELECT id, 'Serviks amputasyonu', 'tr' FROM medical_services WHERE slug = 'cervical-amputation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Condyloma and Benign Growth Removal Vulva Vagina', 'en' FROM medical_services WHERE slug = 'condyloma-and-benign-growth-removal-vulva-vagina'
UNION ALL SELECT id, 'Genital Wart Removal', 'en' FROM medical_services WHERE slug = 'condyloma-and-benign-growth-removal-vulva-vagina'
UNION ALL SELECT id, 'Uklanjanje genitalnih bradavica', 'sr' FROM medical_services WHERE slug = 'condyloma-and-benign-growth-removal-vulva-vagina'
UNION ALL SELECT id, 'Уклањање гениталних брадавица', 'sr-cyrl' FROM medical_services WHERE slug = 'condyloma-and-benign-growth-removal-vulva-vagina'
UNION ALL SELECT id, 'Удаление остроконечных кондилом', 'ru' FROM medical_services WHERE slug = 'condyloma-and-benign-growth-removal-vulva-vagina'
UNION ALL SELECT id, 'Удаление генитальных бородавок', 'ru' FROM medical_services WHERE slug = 'condyloma-and-benign-growth-removal-vulva-vagina'
UNION ALL SELECT id, 'Feigwarzenentfernung', 'de' FROM medical_services WHERE slug = 'condyloma-and-benign-growth-removal-vulva-vagina'
UNION ALL SELECT id, 'Genital siğil alınması', 'tr' FROM medical_services WHERE slug = 'condyloma-and-benign-growth-removal-vulva-vagina';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hysteroscopy Asherman Syndrome', 'en' FROM medical_services WHERE slug = 'hysteroscopy-asherman-syndrome'
UNION ALL SELECT id, 'Asherman sindrom', 'sr' FROM medical_services WHERE slug = 'hysteroscopy-asherman-syndrome'
UNION ALL SELECT id, 'Asherman синдром', 'sr-cyrl' FROM medical_services WHERE slug = 'hysteroscopy-asherman-syndrome';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Laparoscopic Adnexectomy', 'en' FROM medical_services WHERE slug = 'laparoscopic-salpingo-oophorectomy'
UNION ALL SELECT id, 'Laparoskopska adneksektomija', 'sr' FROM medical_services WHERE slug = 'laparoscopic-salpingo-oophorectomy'
UNION ALL SELECT id, 'Лапароскопска аднексектомија', 'sr-cyrl' FROM medical_services WHERE slug = 'laparoscopic-salpingo-oophorectomy'
UNION ALL SELECT id, 'Лапароскопическая аднексэктомия', 'ru' FROM medical_services WHERE slug = 'laparoscopic-salpingo-oophorectomy'
UNION ALL SELECT id, 'Лапароскопическое удаление придатков матки', 'ru' FROM medical_services WHERE slug = 'laparoscopic-salpingo-oophorectomy'
UNION ALL SELECT id, 'Laparoskopische Adnexektomie', 'de' FROM medical_services WHERE slug = 'laparoscopic-salpingo-oophorectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Uterine Polypectomy Hysteroscopy', 'en' FROM medical_services WHERE slug = 'uterine-polypectomy-hysteroscopy'
UNION ALL SELECT id, 'Endometrial Polyp Removal', 'en' FROM medical_services WHERE slug = 'uterine-polypectomy-hysteroscopy'
UNION ALL SELECT id, 'Histeroskopska polipektomija', 'sr' FROM medical_services WHERE slug = 'uterine-polypectomy-hysteroscopy'
UNION ALL SELECT id, 'Хистероскопска полипектомија', 'sr-cyrl' FROM medical_services WHERE slug = 'uterine-polypectomy-hysteroscopy'
UNION ALL SELECT id, 'Uklanjanje polipa materice', 'sr' FROM medical_services WHERE slug = 'uterine-polypectomy-hysteroscopy'
UNION ALL SELECT id, 'Уклањање полипа материце', 'sr-cyrl' FROM medical_services WHERE slug = 'uterine-polypectomy-hysteroscopy'
UNION ALL SELECT id, 'Удаление полипа эндометрия', 'ru' FROM medical_services WHERE slug = 'uterine-polypectomy-hysteroscopy'
UNION ALL SELECT id, 'Удаление полипа матки', 'ru' FROM medical_services WHERE slug = 'uterine-polypectomy-hysteroscopy'
UNION ALL SELECT id, 'Rahim polibi alınması', 'tr' FROM medical_services WHERE slug = 'uterine-polypectomy-hysteroscopy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Uterine Septum Resection Hysteroscopy', 'en' FROM medical_services WHERE slug = 'uterine-septum-resection-hysteroscopy'
UNION ALL SELECT id, 'Hysteroscopic Septoplasty', 'en' FROM medical_services WHERE slug = 'uterine-septum-resection-hysteroscopy'
UNION ALL SELECT id, 'Hysteroscopic Metroplasty', 'en' FROM medical_services WHERE slug = 'uterine-septum-resection-hysteroscopy'
UNION ALL SELECT id, 'Histeroskopska resekcija septuma', 'sr' FROM medical_services WHERE slug = 'uterine-septum-resection-hysteroscopy'
UNION ALL SELECT id, 'Хистероскопска ресекција септума', 'sr-cyrl' FROM medical_services WHERE slug = 'uterine-septum-resection-hysteroscopy'
UNION ALL SELECT id, 'Рассечение внутриматочной перегородки', 'ru' FROM medical_services WHERE slug = 'uterine-septum-resection-hysteroscopy'
UNION ALL SELECT id, 'Гистероскопическая метропластика', 'ru' FROM medical_services WHERE slug = 'uterine-septum-resection-hysteroscopy'
UNION ALL SELECT id, 'Rahim perdesi ameliyatı', 'tr' FROM medical_services WHERE slug = 'uterine-septum-resection-hysteroscopy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Gynecologist Visit', 'en' FROM medical_services WHERE slug = 'gynecological-specialist-examination'
UNION ALL SELECT id, 'Pregled ginekologa', 'sr' FROM medical_services WHERE slug = 'gynecological-specialist-examination'
UNION ALL SELECT id, 'Преглед гинеколога', 'sr-cyrl' FROM medical_services WHERE slug = 'gynecological-specialist-examination'
UNION ALL SELECT id, 'Приём гинеколога', 'ru' FROM medical_services WHERE slug = 'gynecological-specialist-examination'
UNION ALL SELECT id, 'Untersuchung beim Frauenarzt', 'de' FROM medical_services WHERE slug = 'gynecological-specialist-examination'
UNION ALL SELECT id, 'Kadın doğum muayenesi', 'tr' FROM medical_services WHERE slug = 'gynecological-specialist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pregled ginekologa sa ultrazvukom', 'sr' FROM medical_services WHERE slug = 'gynecological-specialist-examination-with-ultrasound'
UNION ALL SELECT id, 'Преглед гинеколога са ултразвуком', 'sr-cyrl' FROM medical_services WHERE slug = 'gynecological-specialist-examination-with-ultrasound'
UNION ALL SELECT id, 'Приём гинеколога с УЗИ', 'ru' FROM medical_services WHERE slug = 'gynecological-specialist-examination-with-ultrasound'
UNION ALL SELECT id, 'Frauenarztuntersuchung mit Ultraschall', 'de' FROM medical_services WHERE slug = 'gynecological-specialist-examination-with-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Coil Fitting', 'en' FROM medical_services WHERE slug = 'iud-insertion'
UNION ALL SELECT id, 'Postavljanje spirale', 'sr' FROM medical_services WHERE slug = 'iud-insertion'
UNION ALL SELECT id, 'Постављање спирале', 'sr-cyrl' FROM medical_services WHERE slug = 'iud-insertion'
UNION ALL SELECT id, 'Ugradnja spirale', 'sr' FROM medical_services WHERE slug = 'iud-insertion'
UNION ALL SELECT id, 'Уградња спирале', 'sr-cyrl' FROM medical_services WHERE slug = 'iud-insertion'
UNION ALL SELECT id, 'Установка спирали', 'ru' FROM medical_services WHERE slug = 'iud-insertion'
UNION ALL SELECT id, 'Поставить спираль', 'ru' FROM medical_services WHERE slug = 'iud-insertion'
UNION ALL SELECT id, 'Spirale legen', 'de' FROM medical_services WHERE slug = 'iud-insertion'
UNION ALL SELECT id, 'Spiral takma', 'tr' FROM medical_services WHERE slug = 'iud-insertion'
UNION ALL SELECT id, 'Spiral taktırma', 'tr' FROM medical_services WHERE slug = 'iud-insertion';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Coil Removal', 'en' FROM medical_services WHERE slug = 'iud-removal'
UNION ALL SELECT id, 'Vađenje spirale', 'sr' FROM medical_services WHERE slug = 'iud-removal'
UNION ALL SELECT id, 'Вађење спирале', 'sr-cyrl' FROM medical_services WHERE slug = 'iud-removal'
UNION ALL SELECT id, 'Uklanjanje spirale', 'sr' FROM medical_services WHERE slug = 'iud-removal'
UNION ALL SELECT id, 'Уклањање спирале', 'sr-cyrl' FROM medical_services WHERE slug = 'iud-removal'
UNION ALL SELECT id, 'Удаление спирали', 'ru' FROM medical_services WHERE slug = 'iud-removal'
UNION ALL SELECT id, 'Снять спираль', 'ru' FROM medical_services WHERE slug = 'iud-removal'
UNION ALL SELECT id, 'Spirale entfernen', 'de' FROM medical_services WHERE slug = 'iud-removal'
UNION ALL SELECT id, 'Spiral çıkarma', 'tr' FROM medical_services WHERE slug = 'iud-removal'
UNION ALL SELECT id, 'Spiral aldırma', 'tr' FROM medical_services WHERE slug = 'iud-removal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Liquid-Based Cytology', 'en' FROM medical_services WHERE slug = 'pap-test-liquid-cytology'
UNION ALL SELECT id, 'Dünnschichtzytologie', 'de' FROM medical_services WHERE slug = 'pap-test-liquid-cytology'
UNION ALL SELECT id, 'Sıvı bazlı sitoloji', 'tr' FROM medical_services WHERE slug = 'pap-test-liquid-cytology';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pregnancy Preventive Examination by Calendar', 'en' FROM medical_services WHERE slug = 'pregnancy-preventive-examination-by-calendar'
UNION ALL SELECT id, 'Плановый осмотр беременной', 'ru' FROM medical_services WHERE slug = 'pregnancy-preventive-examination-by-calendar';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lečenje karijesa kod dece', 'sr' FROM medical_services WHERE slug = 'pediatric-caries-treatment'
UNION ALL SELECT id, 'Лечење каријеса код деце', 'sr-cyrl' FROM medical_services WHERE slug = 'pediatric-caries-treatment'
UNION ALL SELECT id, 'Çocuklarda çürük tedavisi', 'tr' FROM medical_services WHERE slug = 'pediatric-caries-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Adaptacija deteta na stomatologa', 'sr' FROM medical_services WHERE slug = 'pediatric-dental-adaptation'
UNION ALL SELECT id, 'Адаптација детета на стоматолога', 'sr-cyrl' FROM medical_services WHERE slug = 'pediatric-dental-adaptation'
UNION ALL SELECT id, 'Адаптационный приём', 'ru' FROM medical_services WHERE slug = 'pediatric-dental-adaptation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Dečja stomatološka dijagnostika', 'sr' FROM medical_services WHERE slug = 'pediatric-dental-diagnostics-with-treatment-plan'
UNION ALL SELECT id, 'Дечја стоматолошка дијагностика', 'sr-cyrl' FROM medical_services WHERE slug = 'pediatric-dental-diagnostics-with-treatment-plan';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Dečji stomatolog', 'sr' FROM medical_services WHERE slug = 'pediatric-dentist-consultation'
UNION ALL SELECT id, 'Дечји стоматолог', 'sr-cyrl' FROM medical_services WHERE slug = 'pediatric-dentist-consultation'
UNION ALL SELECT id, 'Pedodont', 'sr' FROM medical_services WHERE slug = 'pediatric-dentist-consultation'
UNION ALL SELECT id, 'Педодонт', 'sr-cyrl' FROM medical_services WHERE slug = 'pediatric-dentist-consultation'
UNION ALL SELECT id, 'Pregled dječjeg stomatologa', 'sr' FROM medical_services WHERE slug = 'pediatric-dentist-consultation'
UNION ALL SELECT id, 'Преглед дјечјег стоматолога', 'sr-cyrl' FROM medical_services WHERE slug = 'pediatric-dentist-consultation'
UNION ALL SELECT id, 'Приём детского стоматолога', 'ru' FROM medical_services WHERE slug = 'pediatric-dentist-consultation'
UNION ALL SELECT id, 'Детский стоматолог', 'ru' FROM medical_services WHERE slug = 'pediatric-dentist-consultation'
UNION ALL SELECT id, 'Pedodontist', 'tr' FROM medical_services WHERE slug = 'pediatric-dentist-consultation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Baby Tooth Extraction', 'en' FROM medical_services WHERE slug = 'primary-tooth-extraction'
UNION ALL SELECT id, 'Vađenje mlečnog zuba', 'sr' FROM medical_services WHERE slug = 'primary-tooth-extraction'
UNION ALL SELECT id, 'Вађење млечног зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'primary-tooth-extraction'
UNION ALL SELECT id, 'Milchzahn ziehen', 'de' FROM medical_services WHERE slug = 'primary-tooth-extraction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Primary Tooth Extraction Non-Resorbed Root', 'en' FROM medical_services WHERE slug = 'primary-tooth-extraction-non-resorbed-root';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Liječenje mliječnog zuba', 'sr' FROM medical_services WHERE slug = 'primary-tooth-pulp-treatment'
UNION ALL SELECT id, 'Лијечење млијечног зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'primary-tooth-pulp-treatment'
UNION ALL SELECT id, 'Lečenje mlečnog zuba', 'sr' FROM medical_services WHERE slug = 'primary-tooth-pulp-treatment'
UNION ALL SELECT id, 'Лечење млечног зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'primary-tooth-pulp-treatment'
UNION ALL SELECT id, 'Лечение пульпита молочного зуба', 'ru' FROM medical_services WHERE slug = 'primary-tooth-pulp-treatment'
UNION ALL SELECT id, 'Süt dişi kanal tedavisi', 'tr' FROM medical_services WHERE slug = 'primary-tooth-pulp-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Professional Dental Cleaning Deciduous Teeth', 'en' FROM medical_services WHERE slug = 'professional-dental-cleaning-deciduous-teeth'
UNION ALL SELECT id, 'Čišćenje mliječnih zuba', 'sr' FROM medical_services WHERE slug = 'professional-dental-cleaning-deciduous-teeth'
UNION ALL SELECT id, 'Чишћење млијечних зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'professional-dental-cleaning-deciduous-teeth'
UNION ALL SELECT id, 'Čišćenje mlečnih zuba', 'sr' FROM medical_services WHERE slug = 'professional-dental-cleaning-deciduous-teeth'
UNION ALL SELECT id, 'Чишћење млечних зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'professional-dental-cleaning-deciduous-teeth'
UNION ALL SELECT id, 'Чистка молочных зубов', 'ru' FROM medical_services WHERE slug = 'professional-dental-cleaning-deciduous-teeth';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Professional Dental Cleaning Mixed Dentition', 'en' FROM medical_services WHERE slug = 'professional-dental-cleaning-mixed-dentition';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kontrolni pregled ljekara opšte prakse', 'sr' FROM medical_services WHERE slug = 'follow-up-general-practitioner-examination'
UNION ALL SELECT id, 'Контролни преглед љекара опште праксе', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-general-practitioner-examination'
UNION ALL SELECT id, 'Kontrolni pregled opšteg lekara', 'sr' FROM medical_services WHERE slug = 'follow-up-general-practitioner-examination'
UNION ALL SELECT id, 'Контролни преглед општег лекара', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-general-practitioner-examination'
UNION ALL SELECT id, 'Повторный приём терапевта', 'ru' FROM medical_services WHERE slug = 'follow-up-general-practitioner-examination'
UNION ALL SELECT id, 'Контрольный осмотр терапевта', 'ru' FROM medical_services WHERE slug = 'follow-up-general-practitioner-examination'
UNION ALL SELECT id, 'Kontrolluntersuchung beim Hausarzt', 'de' FROM medical_services WHERE slug = 'follow-up-general-practitioner-examination'
UNION ALL SELECT id, 'Pratisyen hekim kontrol muayenesi', 'tr' FROM medical_services WHERE slug = 'follow-up-general-practitioner-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kontrolni pregled infektologa', 'sr' FROM medical_services WHERE slug = 'follow-up-infectious-disease-specialist-examination'
UNION ALL SELECT id, 'Контролни преглед инфектолога', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-infectious-disease-specialist-examination'
UNION ALL SELECT id, 'Повторная консультация инфекциониста', 'ru' FROM medical_services WHERE slug = 'follow-up-infectious-disease-specialist-examination'
UNION ALL SELECT id, 'Повторный приём инфекциониста', 'ru' FROM medical_services WHERE slug = 'follow-up-infectious-disease-specialist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kontrolni pregled nefrologa', 'sr' FROM medical_services WHERE slug = 'follow-up-nephrologist-examination'
UNION ALL SELECT id, 'Контролни преглед нефролога', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-nephrologist-examination'
UNION ALL SELECT id, 'Повторная консультация нефролога', 'ru' FROM medical_services WHERE slug = 'follow-up-nephrologist-examination'
UNION ALL SELECT id, 'Повторный приём нефролога', 'ru' FROM medical_services WHERE slug = 'follow-up-nephrologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kontrolni pregled profesora', 'sr' FROM medical_services WHERE slug = 'follow-up-professor-examination'
UNION ALL SELECT id, 'Контролни преглед професора', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-professor-examination'
UNION ALL SELECT id, 'Повторная консультация профессора', 'ru' FROM medical_services WHERE slug = 'follow-up-professor-examination'
UNION ALL SELECT id, 'Повторный приём профессора', 'ru' FROM medical_services WHERE slug = 'follow-up-professor-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kontrolni pregled specijaliste', 'sr' FROM medical_services WHERE slug = 'follow-up-specialist-examination'
UNION ALL SELECT id, 'Контролни преглед специјалисте', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-specialist-examination'
UNION ALL SELECT id, 'Повторный приём специалиста', 'ru' FROM medical_services WHERE slug = 'follow-up-specialist-examination'
UNION ALL SELECT id, 'Контрольный осмотр специалиста', 'ru' FROM medical_services WHERE slug = 'follow-up-specialist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'GP Consultation', 'en' FROM medical_services WHERE slug = 'general-practitioner-examination'
UNION ALL SELECT id, 'Pregled ljekara opšte prakse', 'sr' FROM medical_services WHERE slug = 'general-practitioner-examination'
UNION ALL SELECT id, 'Преглед љекара опште праксе', 'sr-cyrl' FROM medical_services WHERE slug = 'general-practitioner-examination'
UNION ALL SELECT id, 'Pregled lekara opšte prakse', 'sr' FROM medical_services WHERE slug = 'general-practitioner-examination'
UNION ALL SELECT id, 'Преглед лекара опште праксе', 'sr-cyrl' FROM medical_services WHERE slug = 'general-practitioner-examination'
UNION ALL SELECT id, 'Pregled opšteg lekara', 'sr' FROM medical_services WHERE slug = 'general-practitioner-examination'
UNION ALL SELECT id, 'Преглед општег лекара', 'sr-cyrl' FROM medical_services WHERE slug = 'general-practitioner-examination'
UNION ALL SELECT id, 'Приём терапевта', 'ru' FROM medical_services WHERE slug = 'general-practitioner-examination'
UNION ALL SELECT id, 'Врач общей практики', 'ru' FROM medical_services WHERE slug = 'general-practitioner-examination'
UNION ALL SELECT id, 'Консультация терапевта', 'ru' FROM medical_services WHERE slug = 'general-practitioner-examination'
UNION ALL SELECT id, 'Untersuchung beim Hausarzt', 'de' FROM medical_services WHERE slug = 'general-practitioner-examination'
UNION ALL SELECT id, 'Pratisyen hekim muayenesi', 'tr' FROM medical_services WHERE slug = 'general-practitioner-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Internistički pregled sa EKG-om', 'sr' FROM medical_services WHERE slug = 'internist-examination-with-ecg'
UNION ALL SELECT id, 'Интернистички преглед са ЕКГ-ом', 'sr-cyrl' FROM medical_services WHERE slug = 'internist-examination-with-ecg'
UNION ALL SELECT id, 'Осмотр терапевта с ЭКГ', 'ru' FROM medical_services WHERE slug = 'internist-examination-with-ecg';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lekarsko uverenje za usvajanje deteta', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-child-adoption'
UNION ALL SELECT id, 'Лекарско уверење за усвајање детета', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-child-adoption'
UNION ALL SELECT id, 'Медицинское заключение для усыновления', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-child-adoption';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lekarsko uverenje za otežane uslove rada bez povećanog rizika', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-difficult-working-conditions-without-high-risk'
UNION ALL SELECT id, 'Лекарско уверење за отежане услове рада без повећаног ризика', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-difficult-working-conditions-without-high-risk';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lekarsko uverenje za instruktora vožnje', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-driving-instructor-category-b-c-d-e'
UNION ALL SELECT id, 'Лекарско уверење за инструктора вожње', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-driving-instructor-category-b-c-d-e'
UNION ALL SELECT id, 'Справка для инструктора автошколы', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-driving-instructor-category-b-c-d-e';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Botox injekcija', 'sr' FROM medical_services WHERE slug = 'botox-injection'
UNION ALL SELECT id, 'Ботокс инјекција', 'sr-cyrl' FROM medical_services WHERE slug = 'botox-injection'
UNION ALL SELECT id, 'Уколы ботокса', 'ru' FROM medical_services WHERE slug = 'botox-injection'
UNION ALL SELECT id, 'Инъекции ботокса', 'ru' FROM medical_services WHERE slug = 'botox-injection';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ботокс 1 зона', 'ru' FROM medical_services WHERE slug = 'botox-single-region';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Botulinum Toxin Treatment', 'en' FROM medical_services WHERE slug = 'botox-treatment'
UNION ALL SELECT id, 'Botulinski toksin', 'sr' FROM medical_services WHERE slug = 'botox-treatment'
UNION ALL SELECT id, 'Ботулински токсин', 'sr-cyrl' FROM medical_services WHERE slug = 'botox-treatment'
UNION ALL SELECT id, 'Ботулинотерапия', 'ru' FROM medical_services WHERE slug = 'botox-treatment'
UNION ALL SELECT id, 'Botulinumtoxin-Behandlung', 'de' FROM medical_services WHERE slug = 'botox-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Chemical Peeling Face', 'en' FROM medical_services WHERE slug = 'chemical-peeling-face'
UNION ALL SELECT id, 'Кислотный пилинг лица', 'ru' FROM medical_services WHERE slug = 'chemical-peeling-face';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pregled dermatologa sa dermoskopijom', 'sr' FROM medical_services WHERE slug = 'dermatologist-examination-with-dermatoscopy'
UNION ALL SELECT id, 'Преглед дерматолога са дермоскопијом', 'sr-cyrl' FROM medical_services WHERE slug = 'dermatologist-examination-with-dermatoscopy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ponovni pregled dermatovenerologa', 'sr' FROM medical_services WHERE slug = 'follow-up-dermatologist-examination'
UNION ALL SELECT id, 'Поновни преглед дерматовенеролога', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-dermatologist-examination'
UNION ALL SELECT id, 'Повторный приём дерматолога', 'ru' FROM medical_services WHERE slug = 'follow-up-dermatologist-examination'
UNION ALL SELECT id, 'Повторная консультация дерматолога', 'ru' FROM medical_services WHERE slug = 'follow-up-dermatologist-examination'
UNION ALL SELECT id, 'Kontrolluntersuchung beim Hautarzt', 'de' FROM medical_services WHERE slug = 'follow-up-dermatologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Dermal Filler', 'en' FROM medical_services WHERE slug = 'hyaluronic-acid-filler'
UNION ALL SELECT id, 'Filer sa hijaluronskom kiselinom', 'sr' FROM medical_services WHERE slug = 'hyaluronic-acid-filler'
UNION ALL SELECT id, 'Филер са хијалуронском киселином', 'sr-cyrl' FROM medical_services WHERE slug = 'hyaluronic-acid-filler'
UNION ALL SELECT id, 'Контурная пластика гиалуроновой кислотой', 'ru' FROM medical_services WHERE slug = 'hyaluronic-acid-filler'
UNION ALL SELECT id, 'Faltenunterspritzung mit Hyaluronsäure', 'de' FROM medical_services WHERE slug = 'hyaluronic-acid-filler'
UNION ALL SELECT id, 'Hiyalüronik asit dolgusu', 'tr' FROM medical_services WHERE slug = 'hyaluronic-acid-filler';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Botox for Excessive Sweating', 'en' FROM medical_services WHERE slug = 'hyperhidrosis-botox-treatment'
UNION ALL SELECT id, 'Botox protiv znojenja', 'sr' FROM medical_services WHERE slug = 'hyperhidrosis-botox-treatment'
UNION ALL SELECT id, 'Ботокс против знојења', 'sr-cyrl' FROM medical_services WHERE slug = 'hyperhidrosis-botox-treatment'
UNION ALL SELECT id, 'Ботокс от потливости', 'ru' FROM medical_services WHERE slug = 'hyperhidrosis-botox-treatment'
UNION ALL SELECT id, 'Лечение потливости ботоксом', 'ru' FROM medical_services WHERE slug = 'hyperhidrosis-botox-treatment'
UNION ALL SELECT id, 'Botox gegen Schwitzen', 'de' FROM medical_services WHERE slug = 'hyperhidrosis-botox-treatment'
UNION ALL SELECT id, 'Terleme botoksu', 'tr' FROM medical_services WHERE slug = 'hyperhidrosis-botox-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ялупро Супер Гидро', 'ru' FROM medical_services WHERE slug = 'jalupro-super-hydro-treatment'
UNION ALL SELECT id, 'Жалупро Супер Гидро', 'ru' FROM medical_services WHERE slug = 'jalupro-super-hydro-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Radiofrequency Mole Removal', 'en' FROM medical_services WHERE slug = 'radiowave-skin-lesion-removal'
UNION ALL SELECT id, 'Uklanjanje mladeža radiotalasima', 'sr' FROM medical_services WHERE slug = 'radiowave-skin-lesion-removal'
UNION ALL SELECT id, 'Уклањање младежа радиоталасима', 'sr-cyrl' FROM medical_services WHERE slug = 'radiowave-skin-lesion-removal'
UNION ALL SELECT id, 'Удаление родинок радиоволной', 'ru' FROM medical_services WHERE slug = 'radiowave-skin-lesion-removal'
UNION ALL SELECT id, 'Удаление папиллом радиоволной', 'ru' FROM medical_services WHERE slug = 'radiowave-skin-lesion-removal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hair Mesotherapy', 'en' FROM medical_services WHERE slug = 'scalp-mesotherapy'
UNION ALL SELECT id, 'Mezoterapija kose', 'sr' FROM medical_services WHERE slug = 'scalp-mesotherapy'
UNION ALL SELECT id, 'Мезотерапија косе', 'sr-cyrl' FROM medical_services WHERE slug = 'scalp-mesotherapy'
UNION ALL SELECT id, 'Мезотерапия волос', 'ru' FROM medical_services WHERE slug = 'scalp-mesotherapy'
UNION ALL SELECT id, 'Haar-Mesotherapie', 'de' FROM medical_services WHERE slug = 'scalp-mesotherapy'
UNION ALL SELECT id, 'Saç mezoterapisi', 'tr' FROM medical_services WHERE slug = 'scalp-mesotherapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Driving Licence Medical Certificate', 'en' FROM medical_services WHERE slug = 'medical-certificate-for-driving-license-category-a-b-c-d-e'
UNION ALL SELECT id, 'Driver''s License Medical Certificate', 'en' FROM medical_services WHERE slug = 'medical-certificate-for-driving-license-category-a-b-c-d-e'
UNION ALL SELECT id, 'Ljekarsko uvjerenje za vozačku dozvolu', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-driving-license-category-a-b-c-d-e'
UNION ALL SELECT id, 'Љекарско увјерење за возачку дозволу', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-driving-license-category-a-b-c-d-e'
UNION ALL SELECT id, 'Lekarsko uverenje za vozačku dozvolu', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-driving-license-category-a-b-c-d-e'
UNION ALL SELECT id, 'Лекарско уверење за возачку дозволу', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-driving-license-category-a-b-c-d-e'
UNION ALL SELECT id, 'Медсправка на права', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-driving-license-category-a-b-c-d-e'
UNION ALL SELECT id, 'Медкомиссия на права', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-driving-license-category-a-b-c-d-e'
UNION ALL SELECT id, 'Водительская справка', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-driving-license-category-a-b-c-d-e'
UNION ALL SELECT id, 'Führerscheinuntersuchung', 'de' FROM medical_services WHERE slug = 'medical-certificate-for-driving-license-category-a-b-c-d-e'
UNION ALL SELECT id, 'Ehliyet Sağlık Raporu', 'tr' FROM medical_services WHERE slug = 'medical-certificate-for-driving-license-category-a-b-c-d-e';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Driving Licence Renewal Medical Certificate', 'en' FROM medical_services WHERE slug = 'medical-certificate-for-driving-license-renewal-category-a-b-c-d-e'
UNION ALL SELECT id, 'Lekarsko uverenje za produženje vozačke dozvole', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-driving-license-renewal-category-a-b-c-d-e'
UNION ALL SELECT id, 'Лекарско уверење за продужење возачке дозволе', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-driving-license-renewal-category-a-b-c-d-e'
UNION ALL SELECT id, 'Медсправка для продления прав', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-driving-license-renewal-category-a-b-c-d-e'
UNION ALL SELECT id, 'Ehliyet Yenileme Sağlık Raporu', 'tr' FROM medical_services WHERE slug = 'medical-certificate-for-driving-license-renewal-category-a-b-c-d-e';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ljekarsko uvjerenje za radna mjesta sa povećanim rizikom', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-high-risk-and-difficult-working-conditions'
UNION ALL SELECT id, 'Љекарско увјерење за радна мјеста са повећаним ризиком', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-high-risk-and-difficult-working-conditions'
UNION ALL SELECT id, 'Lekarsko uverenje za radna mesta sa povećanim rizikom', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-high-risk-and-difficult-working-conditions'
UNION ALL SELECT id, 'Лекарско уверење за радна места са повећаним ризиком', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-high-risk-and-difficult-working-conditions';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'High School Enrollment Medical Certificate', 'en' FROM medical_services WHERE slug = 'medical-certificate-for-secondary-school-enrollment'
UNION ALL SELECT id, 'Lekarsko uverenje za upis u srednju školu', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-secondary-school-enrollment'
UNION ALL SELECT id, 'Лекарско уверење за упис у средњу школу', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-secondary-school-enrollment'
UNION ALL SELECT id, 'Справка для поступления в гимназию', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-secondary-school-enrollment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ljekarsko uvjerenje za taksi vozače', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-taxi-driver'
UNION ALL SELECT id, 'Љекарско увјерење за такси возаче', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-taxi-driver'
UNION ALL SELECT id, 'Lekarsko uverenje za taksi vozače', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-taxi-driver'
UNION ALL SELECT id, 'Лекарско уверење за такси возаче', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-taxi-driver'
UNION ALL SELECT id, 'Медицинская справка для таксиста', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-taxi-driver';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lekarsko uverenje za sklapanje braka maloletnih osoba', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-underage-marriage'
UNION ALL SELECT id, 'Лекарско уверење за склапање брака малолетних особа', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-underage-marriage';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'NG Tube Insertion', 'en' FROM medical_services WHERE slug = 'nasogastric-tube-placement'
UNION ALL SELECT id, 'Nasogastric Intubation', 'en' FROM medical_services WHERE slug = 'nasogastric-tube-placement'
UNION ALL SELECT id, 'Postavljanje nazogastrične sonde', 'sr' FROM medical_services WHERE slug = 'nasogastric-tube-placement'
UNION ALL SELECT id, 'Постављање назогастричне сонде', 'sr-cyrl' FROM medical_services WHERE slug = 'nasogastric-tube-placement'
UNION ALL SELECT id, 'Постановка назогастрального зонда', 'ru' FROM medical_services WHERE slug = 'nasogastric-tube-placement'
UNION ALL SELECT id, 'Постановка желудочного зонда', 'ru' FROM medical_services WHERE slug = 'nasogastric-tube-placement'
UNION ALL SELECT id, 'Legen einer Magensonde', 'de' FROM medical_services WHERE slug = 'nasogastric-tube-placement'
UNION ALL SELECT id, 'Nazogastrik Tüp Takılması', 'tr' FROM medical_services WHERE slug = 'nasogastric-tube-placement';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Preventive GP Check-up', 'en' FROM medical_services WHERE slug = 'preventive-general-practitioner-examination'
UNION ALL SELECT id, 'Preventivni pregled ljekara opšte prakse', 'sr' FROM medical_services WHERE slug = 'preventive-general-practitioner-examination'
UNION ALL SELECT id, 'Превентивни преглед љекара опште праксе', 'sr-cyrl' FROM medical_services WHERE slug = 'preventive-general-practitioner-examination'
UNION ALL SELECT id, 'Preventivni pregled lekara opšte prakse', 'sr' FROM medical_services WHERE slug = 'preventive-general-practitioner-examination'
UNION ALL SELECT id, 'Превентивни преглед лекара опште праксе', 'sr-cyrl' FROM medical_services WHERE slug = 'preventive-general-practitioner-examination'
UNION ALL SELECT id, 'Профилактический осмотр врача общей практики', 'ru' FROM medical_services WHERE slug = 'preventive-general-practitioner-examination'
UNION ALL SELECT id, 'Профилактический приём терапевта', 'ru' FROM medical_services WHERE slug = 'preventive-general-practitioner-examination'
UNION ALL SELECT id, 'Check-up beim Hausarzt', 'de' FROM medical_services WHERE slug = 'preventive-general-practitioner-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pregled profesora', 'sr' FROM medical_services WHERE slug = 'professor-examination'
UNION ALL SELECT id, 'Преглед професора', 'sr-cyrl' FROM medical_services WHERE slug = 'professor-examination'
UNION ALL SELECT id, 'Приём профессора', 'ru' FROM medical_services WHERE slug = 'professor-examination'
UNION ALL SELECT id, 'Осмотр профессора', 'ru' FROM medical_services WHERE slug = 'professor-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pregled specijaliste', 'sr' FROM medical_services WHERE slug = 'specialist-examination'
UNION ALL SELECT id, 'Преглед специјалисте', 'sr-cyrl' FROM medical_services WHERE slug = 'specialist-examination'
UNION ALL SELECT id, 'Приём врача-специалиста', 'ru' FROM medical_services WHERE slug = 'specialist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pregled subspecijaliste', 'sr' FROM medical_services WHERE slug = 'subspecialist-examination'
UNION ALL SELECT id, 'Преглед субспецијалисте', 'sr-cyrl' FROM medical_services WHERE slug = 'subspecialist-examination'
UNION ALL SELECT id, 'Приём узкого специалиста', 'ru' FROM medical_services WHERE slug = 'subspecialist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Anterior Hematoma Puncture', 'en' FROM medical_services WHERE slug = 'anterior-hematoma-puncture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ljekarski konzilijum', 'sr' FROM medical_services WHERE slug = 'consilium-medical-examination'
UNION ALL SELECT id, 'Љекарски конзилијум', 'sr-cyrl' FROM medical_services WHERE slug = 'consilium-medical-examination'
UNION ALL SELECT id, 'Lekarski konzilijum', 'sr' FROM medical_services WHERE slug = 'consilium-medical-examination'
UNION ALL SELECT id, 'Лекарски конзилијум', 'sr-cyrl' FROM medical_services WHERE slug = 'consilium-medical-examination'
UNION ALL SELECT id, 'Консилиум врачей', 'ru' FROM medical_services WHERE slug = 'consilium-medical-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ponovni pregled psihijatra', 'sr' FROM medical_services WHERE slug = 'follow-up-psychiatrist-examination'
UNION ALL SELECT id, 'Поновни преглед психијатра', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-psychiatrist-examination'
UNION ALL SELECT id, 'Повторная консультация психиатра', 'ru' FROM medical_services WHERE slug = 'follow-up-psychiatrist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Функциональные пробы почек', 'ru' FROM medical_services WHERE slug = 'functional-renal-test';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Discharge Summary', 'en' FROM medical_services WHERE slug = 'hospital-discharge-letter'
UNION ALL SELECT id, 'Otpusna lista', 'sr' FROM medical_services WHERE slug = 'hospital-discharge-letter'
UNION ALL SELECT id, 'Отпусна листа', 'sr-cyrl' FROM medical_services WHERE slug = 'hospital-discharge-letter'
UNION ALL SELECT id, 'Выписка из больницы', 'ru' FROM medical_services WHERE slug = 'hospital-discharge-letter'
UNION ALL SELECT id, 'Выписка из стационара', 'ru' FROM medical_services WHERE slug = 'hospital-discharge-letter'
UNION ALL SELECT id, 'Entlassbrief', 'de' FROM medical_services WHERE slug = 'hospital-discharge-letter'
UNION ALL SELECT id, 'Taburcu özeti', 'tr' FROM medical_services WHERE slug = 'hospital-discharge-letter';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Termination of Pregnancy', 'en' FROM medical_services WHERE slug = 'inpatient-abortion-procedure'
UNION ALL SELECT id, 'Prekid trudnoće', 'sr' FROM medical_services WHERE slug = 'inpatient-abortion-procedure'
UNION ALL SELECT id, 'Прекид трудноће', 'sr-cyrl' FROM medical_services WHERE slug = 'inpatient-abortion-procedure'
UNION ALL SELECT id, 'Прерывание беременности в стационаре', 'ru' FROM medical_services WHERE slug = 'inpatient-abortion-procedure'
UNION ALL SELECT id, 'Abtreibung', 'de' FROM medical_services WHERE slug = 'inpatient-abortion-procedure'
UNION ALL SELECT id, 'Kürtaj', 'tr' FROM medical_services WHERE slug = 'inpatient-abortion-procedure';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Non-Medical Bed-Day Cost General and Special Hospitals', 'en' FROM medical_services WHERE slug = 'non-medical-bed-day-cost-general-and-special-hospitals';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Non-Medical Bed-Day Cost Intensive Coronary and Neonatal', 'en' FROM medical_services WHERE slug = 'non-medical-bed-day-cost-intensive-coronary-and-neonatal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'On-Call Doctor Specialist Examination', 'en' FROM medical_services WHERE slug = 'on-call-doctor-specialist-examination'
UNION ALL SELECT id, 'Pregled dežurnog lekara', 'sr' FROM medical_services WHERE slug = 'on-call-doctor-specialist-examination'
UNION ALL SELECT id, 'Преглед дежурног лекара', 'sr-cyrl' FROM medical_services WHERE slug = 'on-call-doctor-specialist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operating Theatre Costs Tier I 121 to 180 Points', 'en' FROM medical_services WHERE slug = 'operating-theatre-costs-tier-i-121-to-180-points';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operating Theatre Costs Tier I 21 to 50 Points', 'en' FROM medical_services WHERE slug = 'operating-theatre-costs-tier-i-21-to-50-points';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operating Theatre Costs Tier I 5 to 20 Points', 'en' FROM medical_services WHERE slug = 'operating-theatre-costs-tier-i-5-to-20-points';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operating Theatre Costs Tier I 51 to 120 Points', 'en' FROM medical_services WHERE slug = 'operating-theatre-costs-tier-i-51-to-120-points';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operating Theatre Costs Tier II 21 to 50 Points', 'en' FROM medical_services WHERE slug = 'operating-theatre-costs-tier-ii-21-to-50-points';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ultrazvuk limfnih žlijezda', 'sr' FROM medical_services WHERE slug = 'ultrasound-lymph-nodes'
UNION ALL SELECT id, 'Ултразвук лимфних жлијезда', 'sr-cyrl' FROM medical_services WHERE slug = 'ultrasound-lymph-nodes'
UNION ALL SELECT id, 'Ultrazvuk limfnih čvorova', 'sr' FROM medical_services WHERE slug = 'ultrasound-lymph-nodes'
UNION ALL SELECT id, 'Ултразвук лимфних чворова', 'sr-cyrl' FROM medical_services WHERE slug = 'ultrasound-lymph-nodes'
UNION ALL SELECT id, 'Ultrazvuk limfnih žlezda', 'sr' FROM medical_services WHERE slug = 'ultrasound-lymph-nodes'
UNION ALL SELECT id, 'Ултразвук лимфних жлезда', 'sr-cyrl' FROM medical_services WHERE slug = 'ultrasound-lymph-nodes'
UNION ALL SELECT id, 'УЗИ лимфоузлов', 'ru' FROM medical_services WHERE slug = 'ultrasound-lymph-nodes'
UNION ALL SELECT id, 'Lymphknotensonographie', 'de' FROM medical_services WHERE slug = 'ultrasound-lymph-nodes'
UNION ALL SELECT id, 'Lenf nodu USG', 'tr' FROM medical_services WHERE slug = 'ultrasound-lymph-nodes';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Transfemoral Amputation', 'en' FROM medical_services WHERE slug = 'above-knee-amputation-through-femur'
UNION ALL SELECT id, 'Amputacija natkoljenice', 'sr' FROM medical_services WHERE slug = 'above-knee-amputation-through-femur'
UNION ALL SELECT id, 'Ампутација наткољенице', 'sr-cyrl' FROM medical_services WHERE slug = 'above-knee-amputation-through-femur'
UNION ALL SELECT id, 'Ампутация бедра', 'ru' FROM medical_services WHERE slug = 'above-knee-amputation-through-femur'
UNION ALL SELECT id, 'Diz üstü amputasyon', 'tr' FROM medical_services WHERE slug = 'above-knee-amputation-through-femur';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ruptura Ahilove tetive', 'sr' FROM medical_services WHERE slug = 'achilles-tendon-rupture-repair'
UNION ALL SELECT id, 'Руптура Ахилове тетиве', 'sr-cyrl' FROM medical_services WHERE slug = 'achilles-tendon-rupture-repair'
UNION ALL SELECT id, 'Разрыв ахиллова сухожилия', 'ru' FROM medical_services WHERE slug = 'achilles-tendon-rupture-repair'
UNION ALL SELECT id, 'Achillessehnennaht', 'de' FROM medical_services WHERE slug = 'achilles-tendon-rupture-repair'
UNION ALL SELECT id, 'Achillessehnenriss', 'de' FROM medical_services WHERE slug = 'achilles-tendon-rupture-repair'
UNION ALL SELECT id, 'Aşil tendonu kopması', 'tr' FROM medical_services WHERE slug = 'achilles-tendon-rupture-repair';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Вправление вывиха акромиального конца ключицы', 'ru' FROM medical_services WHERE slug = 'acromioclavicular-joint-dislocation-reduction-closed';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Fiksacioni zavoj skočnog zgloba', 'sr' FROM medical_services WHERE slug = 'ankle-fixation-bandage'
UNION ALL SELECT id, 'Фиксациони завој скочног зглоба', 'sr-cyrl' FROM medical_services WHERE slug = 'ankle-fixation-bandage'
UNION ALL SELECT id, 'Повязка на голеностоп', 'ru' FROM medical_services WHERE slug = 'ankle-fixation-bandage';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Popliteal Cyst Excision', 'en' FROM medical_services WHERE slug = 'baker-cyst-excision'
UNION ALL SELECT id, 'Bejkerova cista', 'sr' FROM medical_services WHERE slug = 'baker-cyst-excision'
UNION ALL SELECT id, 'Бејкерова циста', 'sr-cyrl' FROM medical_services WHERE slug = 'baker-cyst-excision'
UNION ALL SELECT id, 'Киста Бейкера', 'ru' FROM medical_services WHERE slug = 'baker-cyst-excision'
UNION ALL SELECT id, 'Удаление подколенной кисты', 'ru' FROM medical_services WHERE slug = 'baker-cyst-excision'
UNION ALL SELECT id, 'Bakerzyste', 'de' FROM medical_services WHERE slug = 'baker-cyst-excision';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Carpal Tunnel Release', 'en' FROM medical_services WHERE slug = 'carpal-tunnel-decompression'
UNION ALL SELECT id, 'Operacija karpalnog tunela', 'sr' FROM medical_services WHERE slug = 'carpal-tunnel-decompression'
UNION ALL SELECT id, 'Операција карпалног тунела', 'sr-cyrl' FROM medical_services WHERE slug = 'carpal-tunnel-decompression'
UNION ALL SELECT id, 'Операция при синдроме запястного канала', 'ru' FROM medical_services WHERE slug = 'carpal-tunnel-decompression'
UNION ALL SELECT id, 'Декомпрессия срединного нерва', 'ru' FROM medical_services WHERE slug = 'carpal-tunnel-decompression'
UNION ALL SELECT id, 'Karpaltunnelspaltung', 'de' FROM medical_services WHERE slug = 'carpal-tunnel-decompression'
UNION ALL SELECT id, 'Karpal tünel sendromu ameliyatı', 'tr' FROM medical_services WHERE slug = 'carpal-tunnel-decompression';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Вправление вывиха коленной чашечки', 'ru' FROM medical_services WHERE slug = 'closed-manipulation-reduction-of-patellar-dislocation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kahnbeinbruch', 'de' FROM medical_services WHERE slug = 'closed-manipulation-reduction-of-scaphoid-fracture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Namještanje iščašenog zgloba', 'sr' FROM medical_services WHERE slug = 'closed-reduction-of-habitual-or-traumatic-dislocations'
UNION ALL SELECT id, 'Намјештање ишчашеног зглоба', 'sr-cyrl' FROM medical_services WHERE slug = 'closed-reduction-of-habitual-or-traumatic-dislocations'
UNION ALL SELECT id, 'Вправление вывиха', 'ru' FROM medical_services WHERE slug = 'closed-reduction-of-habitual-or-traumatic-dislocations'
UNION ALL SELECT id, 'Einrenken eines ausgerenkten Gelenks', 'de' FROM medical_services WHERE slug = 'closed-reduction-of-habitual-or-traumatic-dislocations'
UNION ALL SELECT id, 'Çıkık redüksiyonu', 'tr' FROM medical_services WHERE slug = 'closed-reduction-of-habitual-or-traumatic-dislocations';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Desault Bandage', 'en' FROM medical_services WHERE slug = 'desault-shoulder-fixation-bandage'
UNION ALL SELECT id, 'Dezoov zavoj', 'sr' FROM medical_services WHERE slug = 'desault-shoulder-fixation-bandage'
UNION ALL SELECT id, 'Дезоов завој', 'sr-cyrl' FROM medical_services WHERE slug = 'desault-shoulder-fixation-bandage'
UNION ALL SELECT id, 'Повязка Дезо', 'ru' FROM medical_services WHERE slug = 'desault-shoulder-fixation-bandage'
UNION ALL SELECT id, 'Desault-Verband', 'de' FROM medical_services WHERE slug = 'desault-shoulder-fixation-bandage';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ponovni pregled ortopeda', 'sr' FROM medical_services WHERE slug = 'follow-up-orthopedist-examination'
UNION ALL SELECT id, 'Поновни преглед ортопеда', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-orthopedist-examination'
UNION ALL SELECT id, 'Повторный осмотр ортопеда', 'ru' FROM medical_services WHERE slug = 'follow-up-orthopedist-examination'
UNION ALL SELECT id, 'Повторный приём ортопеда', 'ru' FROM medical_services WHERE slug = 'follow-up-orthopedist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Eksartikulacija kuka', 'sr' FROM medical_services WHERE slug = 'hip-disarticulation'
UNION ALL SELECT id, 'Ексартикулација кука', 'sr-cyrl' FROM medical_services WHERE slug = 'hip-disarticulation'
UNION ALL SELECT id, 'Экзартикуляция бедра', 'ru' FROM medical_services WHERE slug = 'hip-disarticulation'
UNION ALL SELECT id, 'Вычленение бедра', 'ru' FROM medical_services WHERE slug = 'hip-disarticulation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Iščašenje prsta', 'sr' FROM medical_services WHERE slug = 'interphalangeal-joint-dislocation-reduction'
UNION ALL SELECT id, 'Ишчашење прста', 'sr-cyrl' FROM medical_services WHERE slug = 'interphalangeal-joint-dislocation-reduction'
UNION ALL SELECT id, 'Вправление вывиха пальца', 'ru' FROM medical_services WHERE slug = 'interphalangeal-joint-dislocation-reduction'
UNION ALL SELECT id, 'Parmak çıkığı', 'tr' FROM medical_services WHERE slug = 'interphalangeal-joint-dislocation-reduction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Повязка на колено', 'ru' FROM medical_services WHERE slug = 'knee-fixation-bandage';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Перелом пястной кости', 'ru' FROM medical_services WHERE slug = 'metacarpal-fracture-reduction'
UNION ALL SELECT id, 'Mittelhandbruch', 'de' FROM medical_services WHERE slug = 'metacarpal-fracture-reduction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Перелом плюсневой кости', 'ru' FROM medical_services WHERE slug = 'metatarsal-bone-fracture-reduction-withwithout-fixation'
UNION ALL SELECT id, 'Mittelfußbruch', 'de' FROM medical_services WHERE slug = 'metatarsal-bone-fracture-reduction-withwithout-fixation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Tailbone Fracture', 'en' FROM medical_services WHERE slug = 'open-or-closed-coccyx-fracture-reduction'
UNION ALL SELECT id, 'Prelom trtice', 'sr' FROM medical_services WHERE slug = 'open-or-closed-coccyx-fracture-reduction'
UNION ALL SELECT id, 'Прелом тртице', 'sr-cyrl' FROM medical_services WHERE slug = 'open-or-closed-coccyx-fracture-reduction'
UNION ALL SELECT id, 'Перелом копчика', 'ru' FROM medical_services WHERE slug = 'open-or-closed-coccyx-fracture-reduction'
UNION ALL SELECT id, 'Steißbeinbruch', 'de' FROM medical_services WHERE slug = 'open-or-closed-coccyx-fracture-reduction'
UNION ALL SELECT id, 'Kuyruk sokumu kırığı', 'tr' FROM medical_services WHERE slug = 'open-or-closed-coccyx-fracture-reduction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Orthopedic Consultation', 'en' FROM medical_services WHERE slug = 'orthopedist-examination'
UNION ALL SELECT id, 'Orthopaedic Examination', 'en' FROM medical_services WHERE slug = 'orthopedist-examination'
UNION ALL SELECT id, 'Ortopedski pregled', 'sr' FROM medical_services WHERE slug = 'orthopedist-examination'
UNION ALL SELECT id, 'Ортопедски преглед', 'sr-cyrl' FROM medical_services WHERE slug = 'orthopedist-examination'
UNION ALL SELECT id, 'Приём ортопеда', 'ru' FROM medical_services WHERE slug = 'orthopedist-examination'
UNION ALL SELECT id, 'Консультация ортопеда', 'ru' FROM medical_services WHERE slug = 'orthopedist-examination'
UNION ALL SELECT id, 'Приём травматолога-ортопеда', 'ru' FROM medical_services WHERE slug = 'orthopedist-examination'
UNION ALL SELECT id, 'Untersuchung beim Orthopäden', 'de' FROM medical_services WHERE slug = 'orthopedist-examination'
UNION ALL SELECT id, 'Ortopedist muayenesi', 'tr' FROM medical_services WHERE slug = 'orthopedist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Orthopedic Hardware Removal', 'en' FROM medical_services WHERE slug = 'osteosynthetic-material-removal'
UNION ALL SELECT id, 'Vađenje pločice i šrafova', 'sr' FROM medical_services WHERE slug = 'osteosynthetic-material-removal'
UNION ALL SELECT id, 'Вађење плочице и шрафова', 'sr-cyrl' FROM medical_services WHERE slug = 'osteosynthetic-material-removal'
UNION ALL SELECT id, 'Удаление металлоконструкции', 'ru' FROM medical_services WHERE slug = 'osteosynthetic-material-removal'
UNION ALL SELECT id, 'Metallentfernung', 'de' FROM medical_services WHERE slug = 'osteosynthetic-material-removal'
UNION ALL SELECT id, 'Platin çıkarılması', 'tr' FROM medical_services WHERE slug = 'osteosynthetic-material-removal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Korekcija gipsa', 'sr' FROM medical_services WHERE slug = 'plaster-cast-correction'
UNION ALL SELECT id, 'Корекција гипса', 'sr-cyrl' FROM medical_services WHERE slug = 'plaster-cast-correction'
UNION ALL SELECT id, 'Коррекция гипсовой повязки', 'ru' FROM medical_services WHERE slug = 'plaster-cast-correction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Prepatelarna burzektomija', 'sr' FROM medical_services WHERE slug = 'prepatellar-bursectomy'
UNION ALL SELECT id, 'Препателарна бурзектомија', 'sr-cyrl' FROM medical_services WHERE slug = 'prepatellar-bursectomy'
UNION ALL SELECT id, 'Препателлярная бурсэктомия', 'ru' FROM medical_services WHERE slug = 'prepatellar-bursectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Quadriceps Tendon Repair', 'en' FROM medical_services WHERE slug = 'quadriceps-rupture-suture'
UNION ALL SELECT id, 'Ruptura kvadricepsa', 'sr' FROM medical_services WHERE slug = 'quadriceps-rupture-suture'
UNION ALL SELECT id, 'Руптура квадрицепса', 'sr-cyrl' FROM medical_services WHERE slug = 'quadriceps-rupture-suture'
UNION ALL SELECT id, 'Шов сухожилия четырёхглавой мышцы бедра', 'ru' FROM medical_services WHERE slug = 'quadriceps-rupture-suture'
UNION ALL SELECT id, 'Quadrizepssehnennaht', 'de' FROM medical_services WHERE slug = 'quadriceps-rupture-suture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Rheumatology Consultation', 'en' FROM medical_services WHERE slug = 'rheumatologist-examination'
UNION ALL SELECT id, 'Reumatološki pregled', 'sr' FROM medical_services WHERE slug = 'rheumatologist-examination'
UNION ALL SELECT id, 'Реуматолошки преглед', 'sr-cyrl' FROM medical_services WHERE slug = 'rheumatologist-examination'
UNION ALL SELECT id, 'Приём ревматолога', 'ru' FROM medical_services WHERE slug = 'rheumatologist-examination'
UNION ALL SELECT id, 'Консультация ревматолога', 'ru' FROM medical_services WHERE slug = 'rheumatologist-examination'
UNION ALL SELECT id, 'Untersuchung beim Rheumatologen', 'de' FROM medical_services WHERE slug = 'rheumatologist-examination'
UNION ALL SELECT id, 'Romatolog muayenesi', 'tr' FROM medical_services WHERE slug = 'rheumatologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'ADL Assessment', 'en' FROM medical_services WHERE slug = 'activities-of-daily-living-test';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Иглоукалывание', 'ru' FROM medical_services WHERE slug = 'acupuncture'
UNION ALL SELECT id, 'Иглорефлексотерапия', 'ru' FROM medical_services WHERE slug = 'acupuncture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Vežbe disanja', 'sr' FROM medical_services WHERE slug = 'breathing-exercises'
UNION ALL SELECT id, 'Вежбе дисања', 'sr-cyrl' FROM medical_services WHERE slug = 'breathing-exercises'
UNION ALL SELECT id, 'Дыхательная гимнастика', 'ru' FROM medical_services WHERE slug = 'breathing-exercises'
UNION ALL SELECT id, 'Atemgymnastik', 'de' FROM medical_services WHERE slug = 'breathing-exercises'
UNION ALL SELECT id, 'Nefes egzersizleri', 'tr' FROM medical_services WHERE slug = 'breathing-exercises';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Chiropractor', 'en' FROM medical_services WHERE slug = 'chiropractic-treatment'
UNION ALL SELECT id, 'Kiropraktika', 'sr' FROM medical_services WHERE slug = 'chiropractic-treatment'
UNION ALL SELECT id, 'Киропрактика', 'sr-cyrl' FROM medical_services WHERE slug = 'chiropractic-treatment'
UNION ALL SELECT id, 'Kiropraktičar', 'sr' FROM medical_services WHERE slug = 'chiropractic-treatment'
UNION ALL SELECT id, 'Киропрактичар', 'sr-cyrl' FROM medical_services WHERE slug = 'chiropractic-treatment'
UNION ALL SELECT id, 'Chiropraktik', 'de' FROM medical_services WHERE slug = 'chiropractic-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'CO2 kupke', 'sr' FROM medical_services WHERE slug = 'co2-bath-therapy'
UNION ALL SELECT id, 'CO2 купке', 'sr-cyrl' FROM medical_services WHERE slug = 'co2-bath-therapy'
UNION ALL SELECT id, 'Углекислые ванны', 'ru' FROM medical_services WHERE slug = 'co2-bath-therapy'
UNION ALL SELECT id, 'Kohlensäurebad', 'de' FROM medical_services WHERE slug = 'co2-bath-therapy'
UNION ALL SELECT id, 'Karbondioksit banyosu', 'tr' FROM medical_services WHERE slug = 'co2-bath-therapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Драй нидлинг', 'ru' FROM medical_services WHERE slug = 'dry-needling';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Iontophoresis', 'en' FROM medical_services WHERE slug = 'electrophoresis'
UNION ALL SELECT id, 'Jontoforeza', 'sr' FROM medical_services WHERE slug = 'electrophoresis'
UNION ALL SELECT id, 'Јонтофореза', 'sr-cyrl' FROM medical_services WHERE slug = 'electrophoresis'
UNION ALL SELECT id, 'Лекарственный электрофорез', 'ru' FROM medical_services WHERE slug = 'electrophoresis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Электролечение', 'ru' FROM medical_services WHERE slug = 'electrotherapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Vežbe hoda', 'sr' FROM medical_services WHERE slug = 'gait-exercises'
UNION ALL SELECT id, 'Вежбе хода', 'sr-cyrl' FROM medical_services WHERE slug = 'gait-exercises';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Obuka hoda sa štakama', 'sr' FROM medical_services WHERE slug = 'gait-training-with-walking-aid'
UNION ALL SELECT id, 'Обука хода са штакама', 'sr-cyrl' FROM medical_services WHERE slug = 'gait-training-with-walking-aid'
UNION ALL SELECT id, 'Обучение ходьбе на костылях', 'ru' FROM medical_services WHERE slug = 'gait-training-with-walking-aid';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'ВЧ-терапия', 'ru' FROM medical_services WHERE slug = 'high-frequency-current-therapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'High-Intensity Laser Therapy', 'en' FROM medical_services WHERE slug = 'hilt-laser-therapy'
UNION ALL SELECT id, 'Visokointenzivna laserska terapija', 'sr' FROM medical_services WHERE slug = 'hilt-laser-therapy'
UNION ALL SELECT id, 'Високоинтензивна ласерска терапија', 'sr-cyrl' FROM medical_services WHERE slug = 'hilt-laser-therapy'
UNION ALL SELECT id, 'Высокоинтенсивная лазерная терапия', 'ru' FROM medical_services WHERE slug = 'hilt-laser-therapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hot Pack Therapy', 'en' FROM medical_services WHERE slug = 'hydrocollator-therapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Подводный душ-массаж', 'ru' FROM medical_services WHERE slug = 'hydrotherapy-underwater-massage'
UNION ALL SELECT id, 'Unterwasserdruckstrahlmassage', 'de' FROM medical_services WHERE slug = 'hydrotherapy-underwater-massage';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Instrument-Assisted Soft Tissue Mobilization', 'en' FROM medical_services WHERE slug = 'iastm-therapy'
UNION ALL SELECT id, 'Инструментальная мобилизация мягких тканей', 'ru' FROM medical_services WHERE slug = 'iastm-therapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Interferential Therapy', 'en' FROM medical_services WHERE slug = 'interferential-currents'
UNION ALL SELECT id, 'Интерференцтерапия', 'ru' FROM medical_services WHERE slug = 'interferential-currents'
UNION ALL SELECT id, 'Interferenzstromtherapie', 'de' FROM medical_services WHERE slug = 'interferential-currents';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Goniometry', 'en' FROM medical_services WHERE slug = 'joint-range-of-motion-measurement-per-pair-of-extremities'
UNION ALL SELECT id, 'Goniometrija', 'sr' FROM medical_services WHERE slug = 'joint-range-of-motion-measurement-per-pair-of-extremities'
UNION ALL SELECT id, 'Гониометрија', 'sr-cyrl' FROM medical_services WHERE slug = 'joint-range-of-motion-measurement-per-pair-of-extremities'
UNION ALL SELECT id, 'Гониометрия', 'ru' FROM medical_services WHERE slug = 'joint-range-of-motion-measurement-per-pair-of-extremities';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Exercise Therapy', 'en' FROM medical_services WHERE slug = 'kinesiotherapy'
UNION ALL SELECT id, 'Kinezioterapija', 'sr' FROM medical_services WHERE slug = 'kinesiotherapy'
UNION ALL SELECT id, 'Кинезиотерапија', 'sr-cyrl' FROM medical_services WHERE slug = 'kinesiotherapy'
UNION ALL SELECT id, 'ЛФК', 'ru' FROM medical_services WHERE slug = 'kinesiotherapy'
UNION ALL SELECT id, 'Лечебная физкультура', 'ru' FROM medical_services WHERE slug = 'kinesiotherapy'
UNION ALL SELECT id, 'Кинезитерапия', 'ru' FROM medical_services WHERE slug = 'kinesiotherapy'
UNION ALL SELECT id, 'Krankengymnastik', 'de' FROM medical_services WHERE slug = 'kinesiotherapy'
UNION ALL SELECT id, 'Bewegungstherapie', 'de' FROM medical_services WHERE slug = 'kinesiotherapy'
UNION ALL SELECT id, 'Egzersiz tedavisi', 'tr' FROM medical_services WHERE slug = 'kinesiotherapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Laser terapija', 'sr' FROM medical_services WHERE slug = 'laser-therapy'
UNION ALL SELECT id, 'Ласер терапија', 'sr-cyrl' FROM medical_services WHERE slug = 'laser-therapy'
UNION ALL SELECT id, 'Лазерная терапия', 'ru' FROM medical_services WHERE slug = 'laser-therapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Vežbe koordinacije donjih ekstremiteta', 'sr' FROM medical_services WHERE slug = 'lower-extremity-coordination-exercises'
UNION ALL SELECT id, 'Вежбе координације доњих екстремитета', 'sr-cyrl' FROM medical_services WHERE slug = 'lower-extremity-coordination-exercises';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Сегментарно-рефлекторный массаж', 'ru' FROM medical_services WHERE slug = 'manual-segmental-massage';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Мануальный терапевт', 'ru' FROM medical_services WHERE slug = 'manual-therapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Istezanje kičme na aparatu', 'sr' FROM medical_services WHERE slug = 'mechanical-spinal-traction'
UNION ALL SELECT id, 'Истезање кичме на апарату', 'sr-cyrl' FROM medical_services WHERE slug = 'mechanical-spinal-traction'
UNION ALL SELECT id, 'Вытяжение позвоночника', 'ru' FROM medical_services WHERE slug = 'mechanical-spinal-traction'
UNION ALL SELECT id, 'Extensionsbehandlung der Wirbelsäule', 'de' FROM medical_services WHERE slug = 'mechanical-spinal-traction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Mikrotalasna diatermija', 'sr' FROM medical_services WHERE slug = 'microwave-diathermy'
UNION ALL SELECT id, 'Микроталасна диатермија', 'sr-cyrl' FROM medical_services WHERE slug = 'microwave-diathermy'
UNION ALL SELECT id, 'СВЧ-терапия', 'ru' FROM medical_services WHERE slug = 'microwave-diathermy'
UNION ALL SELECT id, 'Микроволновая терапия', 'ru' FROM medical_services WHERE slug = 'microwave-diathermy'
UNION ALL SELECT id, 'Mikrowellentherapie', 'de' FROM medical_services WHERE slug = 'microwave-diathermy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Biserne kupke', 'sr' FROM medical_services WHERE slug = 'pearl-bath-therapy'
UNION ALL SELECT id, 'Бисерне купке', 'sr-cyrl' FROM medical_services WHERE slug = 'pearl-bath-therapy'
UNION ALL SELECT id, 'Жемчужные ванны', 'ru' FROM medical_services WHERE slug = 'pearl-bath-therapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ультрафонофорез', 'ru' FROM medical_services WHERE slug = 'phonophoresis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Progresivne vežbe sa otporom', 'sr' FROM medical_services WHERE slug = 'progressive-resistance-exercises'
UNION ALL SELECT id, 'Прогресивне вежбе са отпором', 'sr-cyrl' FROM medical_services WHERE slug = 'progressive-resistance-exercises';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Šrot metoda', 'sr' FROM medical_services WHERE slug = 'schroth-method'
UNION ALL SELECT id, 'Шрот метода', 'sr-cyrl' FROM medical_services WHERE slug = 'schroth-method'
UNION ALL SELECT id, 'Гимнастика Шрот', 'ru' FROM medical_services WHERE slug = 'schroth-method'
UNION ALL SELECT id, 'Schroth egzersizleri', 'tr' FROM medical_services WHERE slug = 'schroth-method';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Segmentne izometrijske vežbe', 'sr' FROM medical_services WHERE slug = 'segmental-isometric-exercises'
UNION ALL SELECT id, 'Сегментне изометријске вежбе', 'sr-cyrl' FROM medical_services WHERE slug = 'segmental-isometric-exercises';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'ESWT', 'en' FROM medical_services WHERE slug = 'shock-wave-therapy'
UNION ALL SELECT id, 'Shockwave Therapy', 'en' FROM medical_services WHERE slug = 'shock-wave-therapy'
UNION ALL SELECT id, 'УВТ', 'ru' FROM medical_services WHERE slug = 'shock-wave-therapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kratkotalasna diatermija', 'sr' FROM medical_services WHERE slug = 'short-wave-diathermy'
UNION ALL SELECT id, 'Краткоталасна диатермија', 'sr-cyrl' FROM medical_services WHERE slug = 'short-wave-diathermy'
UNION ALL SELECT id, 'Индуктотермия', 'ru' FROM medical_services WHERE slug = 'short-wave-diathermy'
UNION ALL SELECT id, 'Kurzwellentherapie', 'de' FROM medical_services WHERE slug = 'short-wave-diathermy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Wirbelsäulendekompression', 'de' FROM medical_services WHERE slug = 'spinal-decompression';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'УВЧ-терапия', 'ru' FROM medical_services WHERE slug = 'ultra-short-wave-therapy'
UNION ALL SELECT id, 'UKW-Therapie', 'de' FROM medical_services WHERE slug = 'ultra-short-wave-therapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Terapija ultrazvukom', 'sr' FROM medical_services WHERE slug = 'ultrasound-therapy'
UNION ALL SELECT id, 'Терапија ултразвуком', 'sr-cyrl' FROM medical_services WHERE slug = 'ultrasound-therapy'
UNION ALL SELECT id, 'Лечение ультразвуком', 'ru' FROM medical_services WHERE slug = 'ultrasound-therapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Vežbe za korekciju deformiteta gornjih i donjih ekstremiteta', 'sr' FROM medical_services WHERE slug = 'upper-and-lower-extremity-deformity-correction-exercises'
UNION ALL SELECT id, 'Вежбе за корекцију деформитета горњих и доњих екстремитета', 'sr-cyrl' FROM medical_services WHERE slug = 'upper-and-lower-extremity-deformity-correction-exercises';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Vežbe koordinacije gornjih ekstremiteta', 'sr' FROM medical_services WHERE slug = 'upper-extremity-coordination-exercises'
UNION ALL SELECT id, 'Вежбе координације горњих екстремитета', 'sr-cyrl' FROM medical_services WHERE slug = 'upper-extremity-coordination-exercises';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Vakuum masaža', 'sr' FROM medical_services WHERE slug = 'vacuum-massage'
UNION ALL SELECT id, 'Вакуум масажа', 'sr-cyrl' FROM medical_services WHERE slug = 'vacuum-massage'
UNION ALL SELECT id, 'Баночный массаж', 'ru' FROM medical_services WHERE slug = 'vacuum-massage';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Visceral Manipulation', 'en' FROM medical_services WHERE slug = 'visceral-osteopathy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Удаление внутримозговой гематомы', 'ru' FROM medical_services WHERE slug = 'acute-intracerebral-hematoma-removal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kranioplastika', 'sr' FROM medical_services WHERE slug = 'cranioplasty'
UNION ALL SELECT id, 'Пластика черепа', 'ru' FROM medical_services WHERE slug = 'cranioplasty';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Craniosynostosis Surgery', 'en' FROM medical_services WHERE slug = 'craniostenosis-surgery'
UNION ALL SELECT id, 'Operacija kraniosinostoze', 'sr' FROM medical_services WHERE slug = 'craniostenosis-surgery'
UNION ALL SELECT id, 'Операција краниосиностозе', 'sr-cyrl' FROM medical_services WHERE slug = 'craniostenosis-surgery'
UNION ALL SELECT id, 'Операция при краниосиностозе', 'ru' FROM medical_services WHERE slug = 'craniostenosis-surgery'
UNION ALL SELECT id, 'Operation bei Kraniosynostose', 'de' FROM medical_services WHERE slug = 'craniostenosis-surgery'
UNION ALL SELECT id, 'Kraniosinostoz ameliyatı', 'tr' FROM medical_services WHERE slug = 'craniostenosis-surgery';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Direct Nerve Suture', 'en' FROM medical_services WHERE slug = 'direct-neurorrhaphy'
UNION ALL SELECT id, 'Direktni šav nerva', 'sr' FROM medical_services WHERE slug = 'direct-neurorrhaphy'
UNION ALL SELECT id, 'Директни шав нерва', 'sr-cyrl' FROM medical_services WHERE slug = 'direct-neurorrhaphy'
UNION ALL SELECT id, 'Прямой шов нерва', 'ru' FROM medical_services WHERE slug = 'direct-neurorrhaphy'
UNION ALL SELECT id, 'Direkte Nervennaht', 'de' FROM medical_services WHERE slug = 'direct-neurorrhaphy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Удаление наружного геморроя', 'ru' FROM medical_services WHERE slug = 'external-hemorrhoid-excision';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Stomach Pumping', 'en' FROM medical_services WHERE slug = 'gastric-lavage'
UNION ALL SELECT id, 'Lavaža želuca', 'sr' FROM medical_services WHERE slug = 'gastric-lavage'
UNION ALL SELECT id, 'Лаважа желуца', 'sr-cyrl' FROM medical_services WHERE slug = 'gastric-lavage'
UNION ALL SELECT id, 'Magen auspumpen', 'de' FROM medical_services WHERE slug = 'gastric-lavage'
UNION ALL SELECT id, 'Gastrik lavaj', 'tr' FROM medical_services WHERE slug = 'gastric-lavage';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Люмбальная симпатэктомия', 'ru' FROM medical_services WHERE slug = 'lumbar-sympathectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Удаление ногтевой пластины с матриксом', 'ru' FROM medical_services WHERE slug = 'nail-plate-and-matrix-excision';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Biopsija perifernog živca', 'sr' FROM medical_services WHERE slug = 'peripheral-nerve-biopsy'
UNION ALL SELECT id, 'Биопсија периферног живца', 'sr-cyrl' FROM medical_services WHERE slug = 'peripheral-nerve-biopsy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Peripheral Nerve Grafting', 'en' FROM medical_services WHERE slug = 'peripheral-nerve-transplantation'
UNION ALL SELECT id, 'Пластика периферического нерва', 'ru' FROM medical_services WHERE slug = 'peripheral-nerve-transplantation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Иссечение эпителиального копчикового хода без первичного шва', 'ru' FROM medical_services WHERE slug = 'pilonidal-sinus-or-cyst-excision-without-primary-suture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Иссечение подкожного свища прямой кишки', 'ru' FROM medical_services WHERE slug = 'subcutaneous-anal-fistulotomy-or-fistulectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Хирургическое лечение обширной ЧМТ', 'ru' FROM medical_services WHERE slug = 'surgical-treatment-of-extensive-cranio-cerebral-injuries';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Обработка крупной рвано-ушибленной раны', 'ru' FROM medical_services WHERE slug = 'treatment-of-larger-lacerations-and-contusions';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Верхняя торакальная симпатэктомия', 'ru' FROM medical_services WHERE slug = 'upper-thoracic-sympathectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Atrioseptostomija po Raškindu', 'sr' FROM medical_services WHERE slug = 'balloon-atrial-septostomy-rashkind-procedure'
UNION ALL SELECT id, 'Атриосептостомија по Рашкинду', 'sr-cyrl' FROM medical_services WHERE slug = 'balloon-atrial-septostomy-rashkind-procedure'
UNION ALL SELECT id, 'Операция Рашкинда', 'ru' FROM medical_services WHERE slug = 'balloon-atrial-septostomy-rashkind-procedure';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Drenaža žučnih puteva pod kontrolom CT-a', 'sr' FROM medical_services WHERE slug = 'biliary-system-drainage-under-ct-guidance'
UNION ALL SELECT id, 'Дренажа жучних путева под контролом ЦТ-а', 'sr-cyrl' FROM medical_services WHERE slug = 'biliary-system-drainage-under-ct-guidance'
UNION ALL SELECT id, 'Дренирование желчных протоков под контролем КТ', 'ru' FROM medical_services WHERE slug = 'biliary-system-drainage-under-ct-guidance';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'CT abdomena i male karlice sa kontrastom', 'sr' FROM medical_services WHERE slug = 'msct-abdomen-and-pelvis-with-contrast'
UNION ALL SELECT id, 'ЦТ абдомена и мале карлице са контрастом', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-abdomen-and-pelvis-with-contrast'
UNION ALL SELECT id, 'КТ органов брюшной полости и малого таза с контрастом', 'ru' FROM medical_services WHERE slug = 'msct-abdomen-and-pelvis-with-contrast'
UNION ALL SELECT id, 'Kontrastlı tüm batın BT', 'tr' FROM medical_services WHERE slug = 'msct-abdomen-and-pelvis-with-contrast';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'CT abdomena sa kontrastom', 'sr' FROM medical_services WHERE slug = 'msct-abdomen-with-contrast'
UNION ALL SELECT id, 'ЦТ абдомена са контрастом', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-abdomen-with-contrast'
UNION ALL SELECT id, 'КТ органов брюшной полости с контрастом', 'ru' FROM medical_services WHERE slug = 'msct-abdomen-with-contrast'
UNION ALL SELECT id, 'Kontrastlı batın BT', 'tr' FROM medical_services WHERE slug = 'msct-abdomen-with-contrast';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'КТ-ангиография сосудов конечностей', 'ru' FROM medical_services WHERE slug = 'msct-angiography-extremities';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'CT vratne kičme', 'sr' FROM medical_services WHERE slug = 'msct-cervical-spine'
UNION ALL SELECT id, 'ЦТ вратне кичме', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-cervical-spine'
UNION ALL SELECT id, 'КТ ШОП', 'ru' FROM medical_services WHERE slug = 'msct-cervical-spine'
UNION ALL SELECT id, 'CT HWS', 'de' FROM medical_services WHERE slug = 'msct-cervical-spine'
UNION ALL SELECT id, 'Servikal BT', 'tr' FROM medical_services WHERE slug = 'msct-cervical-spine';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Virtual Colonoscopy', 'en' FROM medical_services WHERE slug = 'msct-colonography'
UNION ALL SELECT id, 'Virtuelna kolonoskopija', 'sr' FROM medical_services WHERE slug = 'msct-colonography'
UNION ALL SELECT id, 'Виртуелна колоноскопија', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-colonography'
UNION ALL SELECT id, 'Виртуальная колоноскопия', 'ru' FROM medical_services WHERE slug = 'msct-colonography'
UNION ALL SELECT id, 'Virtuelle Koloskopie', 'de' FROM medical_services WHERE slug = 'msct-colonography'
UNION ALL SELECT id, 'Sanal kolonoskopi', 'tr' FROM medical_services WHERE slug = 'msct-colonography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Coronary CT Angiography', 'en' FROM medical_services WHERE slug = 'msct-coronary-angiography'
UNION ALL SELECT id, 'MSCT koronarografija', 'sr' FROM medical_services WHERE slug = 'msct-coronary-angiography'
UNION ALL SELECT id, 'МСКТ коронарографија', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-coronary-angiography'
UNION ALL SELECT id, 'CT koronarnih arterija', 'sr' FROM medical_services WHERE slug = 'msct-coronary-angiography'
UNION ALL SELECT id, 'ЦТ коронарних артерија', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-coronary-angiography'
UNION ALL SELECT id, 'МСКТ коронарных артерий', 'ru' FROM medical_services WHERE slug = 'msct-coronary-angiography'
UNION ALL SELECT id, 'КТ-ангиография коронарных артерий', 'ru' FROM medical_services WHERE slug = 'msct-coronary-angiography'
UNION ALL SELECT id, 'Kardio-CT', 'de' FROM medical_services WHERE slug = 'msct-coronary-angiography'
UNION ALL SELECT id, 'Sanal anjiyo', 'tr' FROM medical_services WHERE slug = 'msct-coronary-angiography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'CT lumbalne kičme', 'sr' FROM medical_services WHERE slug = 'msct-lumbosacral-spine'
UNION ALL SELECT id, 'ЦТ лумбалне кичме', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-lumbosacral-spine'
UNION ALL SELECT id, 'КТ поясничного отдела позвоночника', 'ru' FROM medical_services WHERE slug = 'msct-lumbosacral-spine'
UNION ALL SELECT id, 'КТ ПКОП', 'ru' FROM medical_services WHERE slug = 'msct-lumbosacral-spine'
UNION ALL SELECT id, 'CT LWS', 'de' FROM medical_services WHERE slug = 'msct-lumbosacral-spine'
UNION ALL SELECT id, 'Lomber BT', 'tr' FROM medical_services WHERE slug = 'msct-lumbosacral-spine';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Sinus CT', 'en' FROM medical_services WHERE slug = 'msct-paranasal-sinuses-without-contrast'
UNION ALL SELECT id, 'CT sinusa', 'sr' FROM medical_services WHERE slug = 'msct-paranasal-sinuses-without-contrast'
UNION ALL SELECT id, 'ЦТ синуса', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-paranasal-sinuses-without-contrast'
UNION ALL SELECT id, 'CT paranazalnih šupljina', 'sr' FROM medical_services WHERE slug = 'msct-paranasal-sinuses-without-contrast'
UNION ALL SELECT id, 'ЦТ параназалних шупљина', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-paranasal-sinuses-without-contrast'
UNION ALL SELECT id, 'КТ пазух носа', 'ru' FROM medical_services WHERE slug = 'msct-paranasal-sinuses-without-contrast'
UNION ALL SELECT id, 'КТ придаточных пазух носа', 'ru' FROM medical_services WHERE slug = 'msct-paranasal-sinuses-without-contrast'
UNION ALL SELECT id, 'CT NNH', 'de' FROM medical_services WHERE slug = 'msct-paranasal-sinuses-without-contrast'
UNION ALL SELECT id, 'Sinüs BT', 'tr' FROM medical_services WHERE slug = 'msct-paranasal-sinuses-without-contrast';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'CT grudne kičme', 'sr' FROM medical_services WHERE slug = 'msct-thoracic-spine'
UNION ALL SELECT id, 'ЦТ грудне кичме', 'sr-cyrl' FROM medical_services WHERE slug = 'msct-thoracic-spine'
UNION ALL SELECT id, 'КТ ГОП', 'ru' FROM medical_services WHERE slug = 'msct-thoracic-spine'
UNION ALL SELECT id, 'CT BWS', 'de' FROM medical_services WHERE slug = 'msct-thoracic-spine';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'CT-Guided Aspiration Biopsy', 'en' FROM medical_services WHERE slug = 'percutaneous-aspiration-biopsy-under-ct-guidance'
UNION ALL SELECT id, 'PAB pod kontrolom CT-a', 'sr' FROM medical_services WHERE slug = 'percutaneous-aspiration-biopsy-under-ct-guidance'
UNION ALL SELECT id, 'ПАБ под контролом ЦТ-а', 'sr-cyrl' FROM medical_services WHERE slug = 'percutaneous-aspiration-biopsy-under-ct-guidance'
UNION ALL SELECT id, 'Пункционная биопсия под контролем КТ', 'ru' FROM medical_services WHERE slug = 'percutaneous-aspiration-biopsy-under-ct-guidance';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Чрескожная пункционная нефростомия (ЧПНС) под контролем КТ', 'ru' FROM medical_services WHERE slug = 'percutaneous-nephrostomy-under-ct-guidance';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Punkcija ciste bubrega pod kontrolom CT-a', 'sr' FROM medical_services WHERE slug = 'percutaneous-renal-cyst-aspiration-under-ct-guidance'
UNION ALL SELECT id, 'Пункција цисте бубрега под контролом ЦТ-а', 'sr-cyrl' FROM medical_services WHERE slug = 'percutaneous-renal-cyst-aspiration-under-ct-guidance'
UNION ALL SELECT id, 'Пункция кисты почки под контролем КТ', 'ru' FROM medical_services WHERE slug = 'percutaneous-renal-cyst-aspiration-under-ct-guidance';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'УЗИ органов брюшной полости и почек', 'ru' FROM medical_services WHERE slug = 'abdomen-and-kidney-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Abdominal Ultrasound', 'en' FROM medical_services WHERE slug = 'abdomen-ultrasound'
UNION ALL SELECT id, 'UZ abdomena', 'sr' FROM medical_services WHERE slug = 'abdomen-ultrasound'
UNION ALL SELECT id, 'УЗ абдомена', 'sr-cyrl' FROM medical_services WHERE slug = 'abdomen-ultrasound'
UNION ALL SELECT id, 'Ultrazvuk stomaka', 'sr' FROM medical_services WHERE slug = 'abdomen-ultrasound'
UNION ALL SELECT id, 'Ултразвук стомака', 'sr-cyrl' FROM medical_services WHERE slug = 'abdomen-ultrasound'
UNION ALL SELECT id, 'УЗИ органов брюшной полости', 'ru' FROM medical_services WHERE slug = 'abdomen-ultrasound'
UNION ALL SELECT id, 'УЗИ ОБП', 'ru' FROM medical_services WHERE slug = 'abdomen-ultrasound'
UNION ALL SELECT id, 'УЗИ живота', 'ru' FROM medical_services WHERE slug = 'abdomen-ultrasound'
UNION ALL SELECT id, 'Bauchultraschall', 'de' FROM medical_services WHERE slug = 'abdomen-ultrasound'
UNION ALL SELECT id, 'Abdomensonographie', 'de' FROM medical_services WHERE slug = 'abdomen-ultrasound'
UNION ALL SELECT id, 'Tüm batın USG', 'tr' FROM medical_services WHERE slug = 'abdomen-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Vascular Doppler Ultrasound', 'en' FROM medical_services WHERE slug = 'blood-vessels-doppler'
UNION ALL SELECT id, 'Doppler krvnih sudova', 'sr' FROM medical_services WHERE slug = 'blood-vessels-doppler'
UNION ALL SELECT id, 'Допплер крвних судова', 'sr-cyrl' FROM medical_services WHERE slug = 'blood-vessels-doppler'
UNION ALL SELECT id, 'УЗДГ сосудов', 'ru' FROM medical_services WHERE slug = 'blood-vessels-doppler'
UNION ALL SELECT id, 'Допплерография сосудов', 'ru' FROM medical_services WHERE slug = 'blood-vessels-doppler'
UNION ALL SELECT id, 'Доплер сосудов', 'ru' FROM medical_services WHERE slug = 'blood-vessels-doppler'
UNION ALL SELECT id, 'Doppler-Sonographie der Gefäße', 'de' FROM medical_services WHERE slug = 'blood-vessels-doppler'
UNION ALL SELECT id, 'Damar Doppler USG', 'tr' FROM medical_services WHERE slug = 'blood-vessels-doppler';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Breast Sonography', 'en' FROM medical_services WHERE slug = 'breast-ultrasound'
UNION ALL SELECT id, 'Ultrazvuk grudi', 'sr' FROM medical_services WHERE slug = 'breast-ultrasound'
UNION ALL SELECT id, 'Ултразвук груди', 'sr-cyrl' FROM medical_services WHERE slug = 'breast-ultrasound'
UNION ALL SELECT id, 'Ultrazvuk dojke', 'sr' FROM medical_services WHERE slug = 'breast-ultrasound'
UNION ALL SELECT id, 'Ултразвук дојке', 'sr-cyrl' FROM medical_services WHERE slug = 'breast-ultrasound'
UNION ALL SELECT id, 'UZ dojki', 'sr' FROM medical_services WHERE slug = 'breast-ultrasound'
UNION ALL SELECT id, 'УЗ дојки', 'sr-cyrl' FROM medical_services WHERE slug = 'breast-ultrasound'
UNION ALL SELECT id, 'УЗИ груди', 'ru' FROM medical_services WHERE slug = 'breast-ultrasound'
UNION ALL SELECT id, 'Mammasonographie', 'de' FROM medical_services WHERE slug = 'breast-ultrasound'
UNION ALL SELECT id, 'Meme USG', 'tr' FROM medical_services WHERE slug = 'breast-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lower Limb Doppler Ultrasound', 'en' FROM medical_services WHERE slug = 'doppler-lower-extremity-blood-vessels'
UNION ALL SELECT id, 'Leg Doppler Ultrasound', 'en' FROM medical_services WHERE slug = 'doppler-lower-extremity-blood-vessels'
UNION ALL SELECT id, 'Dopler krvnih sudova nogu', 'sr' FROM medical_services WHERE slug = 'doppler-lower-extremity-blood-vessels'
UNION ALL SELECT id, 'Доплер крвних судова ногу', 'sr-cyrl' FROM medical_services WHERE slug = 'doppler-lower-extremity-blood-vessels'
UNION ALL SELECT id, 'УЗДГ сосудов нижних конечностей', 'ru' FROM medical_services WHERE slug = 'doppler-lower-extremity-blood-vessels'
UNION ALL SELECT id, 'Дуплексное сканирование сосудов нижних конечностей', 'ru' FROM medical_services WHERE slug = 'doppler-lower-extremity-blood-vessels'
UNION ALL SELECT id, 'Доплер сосудов нижних конечностей', 'ru' FROM medical_services WHERE slug = 'doppler-lower-extremity-blood-vessels'
UNION ALL SELECT id, 'УЗИ сосудов ног', 'ru' FROM medical_services WHERE slug = 'doppler-lower-extremity-blood-vessels'
UNION ALL SELECT id, 'Doppler-Sonographie der Beingefäße', 'de' FROM medical_services WHERE slug = 'doppler-lower-extremity-blood-vessels'
UNION ALL SELECT id, 'Bacak Damar Doppler USG', 'tr' FROM medical_services WHERE slug = 'doppler-lower-extremity-blood-vessels';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Portal Vein Doppler Ultrasound', 'en' FROM medical_services WHERE slug = 'doppler-portal-vein'
UNION ALL SELECT id, 'Допплерография воротной вены', 'ru' FROM medical_services WHERE slug = 'doppler-portal-vein'
UNION ALL SELECT id, 'Доплер воротной вены', 'ru' FROM medical_services WHERE slug = 'doppler-portal-vein';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Upper Limb Doppler Ultrasound', 'en' FROM medical_services WHERE slug = 'doppler-upper-extremity-blood-vessels'
UNION ALL SELECT id, 'Arm Doppler Ultrasound', 'en' FROM medical_services WHERE slug = 'doppler-upper-extremity-blood-vessels'
UNION ALL SELECT id, 'Dopler krvnih sudova ruku', 'sr' FROM medical_services WHERE slug = 'doppler-upper-extremity-blood-vessels'
UNION ALL SELECT id, 'Доплер крвних судова руку', 'sr-cyrl' FROM medical_services WHERE slug = 'doppler-upper-extremity-blood-vessels'
UNION ALL SELECT id, 'УЗДГ сосудов верхних конечностей', 'ru' FROM medical_services WHERE slug = 'doppler-upper-extremity-blood-vessels'
UNION ALL SELECT id, 'Дуплексное сканирование сосудов верхних конечностей', 'ru' FROM medical_services WHERE slug = 'doppler-upper-extremity-blood-vessels'
UNION ALL SELECT id, 'Доплер сосудов верхних конечностей', 'ru' FROM medical_services WHERE slug = 'doppler-upper-extremity-blood-vessels'
UNION ALL SELECT id, 'УЗИ сосудов рук', 'ru' FROM medical_services WHERE slug = 'doppler-upper-extremity-blood-vessels'
UNION ALL SELECT id, 'Doppler-Sonographie der Armgefäße', 'de' FROM medical_services WHERE slug = 'doppler-upper-extremity-blood-vessels'
UNION ALL SELECT id, 'Kol Damar Doppler USG', 'tr' FROM medical_services WHERE slug = 'doppler-upper-extremity-blood-vessels';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'УЗИ экспертного класса при беременности', 'ru' FROM medical_services WHERE slug = 'expert-pregnancy-ultrasound'
UNION ALL SELECT id, 'Feinultraschall', 'de' FROM medical_services WHERE slug = 'expert-pregnancy-ultrasound'
UNION ALL SELECT id, 'Detaylı gebelik ultrasonu', 'tr' FROM medical_services WHERE slug = 'expert-pregnancy-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Follicle Tracking', 'en' FROM medical_services WHERE slug = 'folliculometry'
UNION ALL SELECT id, 'Praćenje ovulacije', 'sr' FROM medical_services WHERE slug = 'folliculometry'
UNION ALL SELECT id, 'Праћење овулације', 'sr-cyrl' FROM medical_services WHERE slug = 'folliculometry'
UNION ALL SELECT id, 'УЗИ-мониторинг овуляции', 'ru' FROM medical_services WHERE slug = 'folliculometry'
UNION ALL SELECT id, 'Фоликулометрия', 'ru' FROM medical_services WHERE slug = 'folliculometry'
UNION ALL SELECT id, 'Follikelmonitoring', 'de' FROM medical_services WHERE slug = 'folliculometry'
UNION ALL SELECT id, 'Folikül takibi', 'tr' FROM medical_services WHERE slug = 'folliculometry'
UNION ALL SELECT id, 'Yumurtlama takibi', 'tr' FROM medical_services WHERE slug = 'folliculometry';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Female Pelvic Ultrasound', 'en' FROM medical_services WHERE slug = 'gynecological-ultrasound'
UNION ALL SELECT id, 'Ultrazvuk male karlice', 'sr' FROM medical_services WHERE slug = 'gynecological-ultrasound'
UNION ALL SELECT id, 'Ултразвук мале карлице', 'sr-cyrl' FROM medical_services WHERE slug = 'gynecological-ultrasound'
UNION ALL SELECT id, 'Ultrazvuk materice i jajnika', 'sr' FROM medical_services WHERE slug = 'gynecological-ultrasound'
UNION ALL SELECT id, 'Ултразвук материце и јајника', 'sr-cyrl' FROM medical_services WHERE slug = 'gynecological-ultrasound'
UNION ALL SELECT id, 'УЗИ органов малого таза у женщин', 'ru' FROM medical_services WHERE slug = 'gynecological-ultrasound'
UNION ALL SELECT id, 'УЗИ матки и яичников', 'ru' FROM medical_services WHERE slug = 'gynecological-ultrasound'
UNION ALL SELECT id, 'Gynäkologische Sonographie', 'de' FROM medical_services WHERE slug = 'gynecological-ultrasound'
UNION ALL SELECT id, 'Unterleibsultraschall', 'de' FROM medical_services WHERE slug = 'gynecological-ultrasound'
UNION ALL SELECT id, 'Jinekolojik USG', 'tr' FROM medical_services WHERE slug = 'gynecological-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hip Joint Ultrasound', 'en' FROM medical_services WHERE slug = 'hip-ultrasound'
UNION ALL SELECT id, 'Ultrazvuk kuka', 'sr' FROM medical_services WHERE slug = 'hip-ultrasound'
UNION ALL SELECT id, 'Ултразвук кука', 'sr-cyrl' FROM medical_services WHERE slug = 'hip-ultrasound'
UNION ALL SELECT id, 'УЗИ ТБС', 'ru' FROM medical_services WHERE slug = 'hip-ultrasound'
UNION ALL SELECT id, 'Kalça USG', 'tr' FROM medical_services WHERE slug = 'hip-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'MSK Ultrasound', 'en' FROM medical_services WHERE slug = 'musculoskeletal-ultrasound'
UNION ALL SELECT id, 'Muskuloskeletni ultrazvuk', 'sr' FROM medical_services WHERE slug = 'musculoskeletal-ultrasound'
UNION ALL SELECT id, 'Мускулоскелетни ултразвук', 'sr-cyrl' FROM medical_services WHERE slug = 'musculoskeletal-ultrasound'
UNION ALL SELECT id, 'УЗИ мышц, связок и сухожилий', 'ru' FROM medical_services WHERE slug = 'musculoskeletal-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Boyun USG', 'tr' FROM medical_services WHERE slug = 'neck-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Eye Ultrasound', 'en' FROM medical_services WHERE slug = 'ophthalmological-ultrasound'
UNION ALL SELECT id, 'Ultrazvuk oka', 'sr' FROM medical_services WHERE slug = 'ophthalmological-ultrasound'
UNION ALL SELECT id, 'Ултразвук ока', 'sr-cyrl' FROM medical_services WHERE slug = 'ophthalmological-ultrasound'
UNION ALL SELECT id, 'УЗИ глаза', 'ru' FROM medical_services WHERE slug = 'ophthalmological-ultrasound'
UNION ALL SELECT id, 'Augenultraschall', 'de' FROM medical_services WHERE slug = 'ophthalmological-ultrasound'
UNION ALL SELECT id, 'Göz ultrasonu', 'tr' FROM medical_services WHERE slug = 'ophthalmological-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'УЗИ пазух носа', 'ru' FROM medical_services WHERE slug = 'sinus-ultrasound'
UNION ALL SELECT id, 'УЗИ гайморовых пазух', 'ru' FROM medical_services WHERE slug = 'sinus-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Yumuşak doku USG', 'tr' FROM medical_services WHERE slug = 'soft-tissue-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'TCD', 'en' FROM medical_services WHERE slug = 'transcranial-doppler-sonography'
UNION ALL SELECT id, 'Transkranijalni dopler', 'sr' FROM medical_services WHERE slug = 'transcranial-doppler-sonography'
UNION ALL SELECT id, 'Транскранијални доплер', 'sr-cyrl' FROM medical_services WHERE slug = 'transcranial-doppler-sonography'
UNION ALL SELECT id, 'ТКДГ', 'ru' FROM medical_services WHERE slug = 'transcranial-doppler-sonography'
UNION ALL SELECT id, 'УЗДГ сосудов головного мозга', 'ru' FROM medical_services WHERE slug = 'transcranial-doppler-sonography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'KUB Ultrasound', 'en' FROM medical_services WHERE slug = 'urinary-tract-ultrasound'
UNION ALL SELECT id, 'Ultrazvuk urinarnog trakta', 'sr' FROM medical_services WHERE slug = 'urinary-tract-ultrasound'
UNION ALL SELECT id, 'Ултразвук уринарног тракта', 'sr-cyrl' FROM medical_services WHERE slug = 'urinary-tract-ultrasound'
UNION ALL SELECT id, 'Ultrazvuk bubrega i mokraćne bešike', 'sr' FROM medical_services WHERE slug = 'urinary-tract-ultrasound'
UNION ALL SELECT id, 'Ултразвук бубрега и мокраћне бешике', 'sr-cyrl' FROM medical_services WHERE slug = 'urinary-tract-ultrasound'
UNION ALL SELECT id, 'УЗИ мочевыделительной системы', 'ru' FROM medical_services WHERE slug = 'urinary-tract-ultrasound'
UNION ALL SELECT id, 'УЗИ почек и мочевого пузыря', 'ru' FROM medical_services WHERE slug = 'urinary-tract-ultrasound'
UNION ALL SELECT id, 'Sonographie der Harnwege', 'de' FROM medical_services WHERE slug = 'urinary-tract-ultrasound'
UNION ALL SELECT id, 'Üriner sistem USG', 'tr' FROM medical_services WHERE slug = 'urinary-tract-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Endocrinologist Consultation', 'en' FROM medical_services WHERE slug = 'endocrinologist-examination'
UNION ALL SELECT id, 'Konsultacija endokrinologa', 'sr' FROM medical_services WHERE slug = 'endocrinologist-examination'
UNION ALL SELECT id, 'Консултација ендокринолога', 'sr-cyrl' FROM medical_services WHERE slug = 'endocrinologist-examination'
UNION ALL SELECT id, 'Приём эндокринолога', 'ru' FROM medical_services WHERE slug = 'endocrinologist-examination'
UNION ALL SELECT id, 'Консультация эндокринолога', 'ru' FROM medical_services WHERE slug = 'endocrinologist-examination'
UNION ALL SELECT id, 'Untersuchung beim Endokrinologen', 'de' FROM medical_services WHERE slug = 'endocrinologist-examination'
UNION ALL SELECT id, 'Endokrinolog muayenesi', 'tr' FROM medical_services WHERE slug = 'endocrinologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Приём эндокринолога с УЗИ щитовидной железы', 'ru' FROM medical_services WHERE slug = 'endocrinologist-examination-with-thyroid-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Первичный приём эндокринолога', 'ru' FROM medical_services WHERE slug = 'first-endocrinologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Повторный приём эндокринолога', 'ru' FROM medical_services WHERE slug = 'follow-up-endocrinologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Biopsija štitne žlijezde', 'sr' FROM medical_services WHERE slug = 'thyroid-biopsy'
UNION ALL SELECT id, 'Биопсија штитне жлијезде', 'sr-cyrl' FROM medical_services WHERE slug = 'thyroid-biopsy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Digital Implant Planning', 'en' FROM medical_services WHERE slug = '3d-implant-planning'
UNION ALL SELECT id, '3D planiranje implantata', 'sr' FROM medical_services WHERE slug = '3d-implant-planning'
UNION ALL SELECT id, '3Д планирање имплантата', 'sr-cyrl' FROM medical_services WHERE slug = '3d-implant-planning'
UNION ALL SELECT id, '3D планирование имплантации', 'ru' FROM medical_services WHERE slug = '3d-implant-planning'
UNION ALL SELECT id, 'Цифровое планирование имплантации', 'ru' FROM medical_services WHERE slug = '3d-implant-planning';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'All-on-4 Nobel Biocare', 'en' FROM medical_services WHERE slug = 'all-on-4-implant-prosthesis-nobel'
UNION ALL SELECT id, 'Proteza na 4 implantata Nobel', 'sr' FROM medical_services WHERE slug = 'all-on-4-implant-prosthesis-nobel'
UNION ALL SELECT id, 'Протеза на 4 имплантата Nobel', 'sr-cyrl' FROM medical_services WHERE slug = 'all-on-4-implant-prosthesis-nobel'
UNION ALL SELECT id, 'Все на 4 Нобель Биокеа', 'ru' FROM medical_services WHERE slug = 'all-on-4-implant-prosthesis-nobel';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'All-on-4 Straumann', 'en' FROM medical_services WHERE slug = 'all-on-4-implant-prosthesis-straumann'
UNION ALL SELECT id, 'Proteza na 4 implantata Straumann', 'sr' FROM medical_services WHERE slug = 'all-on-4-implant-prosthesis-straumann'
UNION ALL SELECT id, 'Протеза на 4 имплантата Straumann', 'sr-cyrl' FROM medical_services WHERE slug = 'all-on-4-implant-prosthesis-straumann'
UNION ALL SELECT id, 'Все на 4 Штрауман', 'ru' FROM medical_services WHERE slug = 'all-on-4-implant-prosthesis-straumann';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'All-on-6 Nobel Biocare', 'en' FROM medical_services WHERE slug = 'all-on-6-implant-prosthesis-nobel'
UNION ALL SELECT id, 'Proteza na 6 implantata Nobel', 'sr' FROM medical_services WHERE slug = 'all-on-6-implant-prosthesis-nobel'
UNION ALL SELECT id, 'Протеза на 6 имплантата Nobel', 'sr-cyrl' FROM medical_services WHERE slug = 'all-on-6-implant-prosthesis-nobel'
UNION ALL SELECT id, 'Все на 6 Нобель Биокеа', 'ru' FROM medical_services WHERE slug = 'all-on-6-implant-prosthesis-nobel';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Dry Socket Treatment', 'en' FROM medical_services WHERE slug = 'alveolitis-treatment'
UNION ALL SELECT id, 'Suva alveola', 'sr' FROM medical_services WHERE slug = 'alveolitis-treatment'
UNION ALL SELECT id, 'Сува алвеола', 'sr-cyrl' FROM medical_services WHERE slug = 'alveolitis-treatment'
UNION ALL SELECT id, 'Lečenje alveolita', 'sr' FROM medical_services WHERE slug = 'alveolitis-treatment'
UNION ALL SELECT id, 'Лечење алвеолита', 'sr-cyrl' FROM medical_services WHERE slug = 'alveolitis-treatment'
UNION ALL SELECT id, 'Лечение сухой лунки', 'ru' FROM medical_services WHERE slug = 'alveolitis-treatment'
UNION ALL SELECT id, 'Лечение лунки после удаления зуба', 'ru' FROM medical_services WHERE slug = 'alveolitis-treatment'
UNION ALL SELECT id, 'Behandlung einer trockenen Alveole', 'de' FROM medical_services WHERE slug = 'alveolitis-treatment'
UNION ALL SELECT id, 'Kuru soket tedavisi', 'tr' FROM medical_services WHERE slug = 'alveolitis-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Silver Filling', 'en' FROM medical_services WHERE slug = 'amalgam-filling'
UNION ALL SELECT id, 'Amalgamski ispun', 'sr' FROM medical_services WHERE slug = 'amalgam-filling'
UNION ALL SELECT id, 'Амалгамски испун', 'sr-cyrl' FROM medical_services WHERE slug = 'amalgam-filling'
UNION ALL SELECT id, 'Crna plomba', 'sr' FROM medical_services WHERE slug = 'amalgam-filling'
UNION ALL SELECT id, 'Црна пломба', 'sr-cyrl' FROM medical_services WHERE slug = 'amalgam-filling'
UNION ALL SELECT id, 'Серебряная пломба', 'ru' FROM medical_services WHERE slug = 'amalgam-filling'
UNION ALL SELECT id, 'Amalgamplombe', 'de' FROM medical_services WHERE slug = 'amalgam-filling'
UNION ALL SELECT id, 'Gümüş dolgu', 'tr' FROM medical_services WHERE slug = 'amalgam-filling';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Apicectomy', 'en' FROM medical_services WHERE slug = 'apicoectomy'
UNION ALL SELECT id, 'Resekcija vrha korijena', 'sr' FROM medical_services WHERE slug = 'apicoectomy'
UNION ALL SELECT id, 'Ресекција врха коријена', 'sr-cyrl' FROM medical_services WHERE slug = 'apicoectomy'
UNION ALL SELECT id, 'Resekcija vrha korena', 'sr' FROM medical_services WHERE slug = 'apicoectomy'
UNION ALL SELECT id, 'Ресекција врха корена', 'sr-cyrl' FROM medical_services WHERE slug = 'apicoectomy'
UNION ALL SELECT id, 'Резекция верхушки корня', 'ru' FROM medical_services WHERE slug = 'apicoectomy'
UNION ALL SELECT id, 'WSR', 'de' FROM medical_services WHERE slug = 'apicoectomy'
UNION ALL SELECT id, 'Kök ucu rezeksiyonu', 'tr' FROM medical_services WHERE slug = 'apicoectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Emax krunica', 'sr' FROM medical_services WHERE slug = 'cadcam-e-max-layered-crown'
UNION ALL SELECT id, 'Emax круница', 'sr-cyrl' FROM medical_services WHERE slug = 'cadcam-e-max-layered-crown'
UNION ALL SELECT id, 'Коронка Е-макс', 'ru' FROM medical_services WHERE slug = 'cadcam-e-max-layered-crown';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Livena nadogradnja', 'sr' FROM medical_services WHERE slug = 'cast-post-and-core'
UNION ALL SELECT id, 'Ливена надоградња', 'sr-cyrl' FROM medical_services WHERE slug = 'cast-post-and-core'
UNION ALL SELECT id, 'Культевая штифтовая вкладка', 'ru' FROM medical_services WHERE slug = 'cast-post-and-core';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Porcelain Veneer', 'en' FROM medical_services WHERE slug = 'ceramic-veneer'
UNION ALL SELECT id, 'Keramičke fasete', 'sr' FROM medical_services WHERE slug = 'ceramic-veneer'
UNION ALL SELECT id, 'Керамичке фасете', 'sr-cyrl' FROM medical_services WHERE slug = 'ceramic-veneer'
UNION ALL SELECT id, 'Porcelanske fasete', 'sr' FROM medical_services WHERE slug = 'ceramic-veneer'
UNION ALL SELECT id, 'Порцеланске фасете', 'sr-cyrl' FROM medical_services WHERE slug = 'ceramic-veneer'
UNION ALL SELECT id, 'Керамические виниры', 'ru' FROM medical_services WHERE slug = 'ceramic-veneer'
UNION ALL SELECT id, 'Фарфоровые виниры', 'ru' FROM medical_services WHERE slug = 'ceramic-veneer'
UNION ALL SELECT id, 'Keramikverblendschale', 'de' FROM medical_services WHERE slug = 'ceramic-veneer'
UNION ALL SELECT id, 'Porselen lamina', 'tr' FROM medical_services WHERE slug = 'ceramic-veneer';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Комплексная чистка зубов', 'ru' FROM medical_services WHERE slug = 'complete-dental-cleaning';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Full Denture', 'en' FROM medical_services WHERE slug = 'complete-denture'
UNION ALL SELECT id, 'Potpuna proteza', 'sr' FROM medical_services WHERE slug = 'complete-denture'
UNION ALL SELECT id, 'Потпуна протеза', 'sr-cyrl' FROM medical_services WHERE slug = 'complete-denture'
UNION ALL SELECT id, 'Полный протез', 'ru' FROM medical_services WHERE slug = 'complete-denture'
UNION ALL SELECT id, 'Вставная челюсть', 'ru' FROM medical_services WHERE slug = 'complete-denture'
UNION ALL SELECT id, 'Vollprothese', 'de' FROM medical_services WHERE slug = 'complete-denture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'White Filling', 'en' FROM medical_services WHERE slug = 'composite-filling'
UNION ALL SELECT id, 'Kompozitna plomba', 'sr' FROM medical_services WHERE slug = 'composite-filling'
UNION ALL SELECT id, 'Композитна пломба', 'sr-cyrl' FROM medical_services WHERE slug = 'composite-filling'
UNION ALL SELECT id, 'Bijela plomba', 'sr' FROM medical_services WHERE slug = 'composite-filling'
UNION ALL SELECT id, 'Бијела пломба', 'sr-cyrl' FROM medical_services WHERE slug = 'composite-filling'
UNION ALL SELECT id, 'Bela plomba', 'sr' FROM medical_services WHERE slug = 'composite-filling'
UNION ALL SELECT id, 'Бела пломба', 'sr-cyrl' FROM medical_services WHERE slug = 'composite-filling'
UNION ALL SELECT id, 'Фотополимерная пломба', 'ru' FROM medical_services WHERE slug = 'composite-filling'
UNION ALL SELECT id, 'Светоотверждаемая пломба', 'ru' FROM medical_services WHERE slug = 'composite-filling'
UNION ALL SELECT id, 'Kunststofffüllung', 'de' FROM medical_services WHERE slug = 'composite-filling'
UNION ALL SELECT id, 'Beyaz dolgu', 'tr' FROM medical_services WHERE slug = 'composite-filling';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Apical Periodontitis Treatment', 'en' FROM medical_services WHERE slug = 'conservative-treatment-of-periapical-process-and-dental-gangrene'
UNION ALL SELECT id, 'Liječenje periodontitisa', 'sr' FROM medical_services WHERE slug = 'conservative-treatment-of-periapical-process-and-dental-gangrene'
UNION ALL SELECT id, 'Лијечење периодонтитиса', 'sr-cyrl' FROM medical_services WHERE slug = 'conservative-treatment-of-periapical-process-and-dental-gangrene'
UNION ALL SELECT id, 'Лечение периодонтита', 'ru' FROM medical_services WHERE slug = 'conservative-treatment-of-periapical-process-and-dental-gangrene';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Uklanjanje krunice', 'sr' FROM medical_services WHERE slug = 'crown-removal'
UNION ALL SELECT id, 'Уклањање крунице', 'sr-cyrl' FROM medical_services WHERE slug = 'crown-removal'
UNION ALL SELECT id, 'Снять коронку', 'ru' FROM medical_services WHERE slug = 'crown-removal'
UNION ALL SELECT id, 'Распил коронки', 'ru' FROM medical_services WHERE slug = 'crown-removal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Spinal Anesthesia', 'en' FROM medical_services WHERE slug = 'central-nerve-block-for-surgical-interventions'
UNION ALL SELECT id, 'Neuraxial Block', 'en' FROM medical_services WHERE slug = 'central-nerve-block-for-surgical-interventions'
UNION ALL SELECT id, 'Spinalna anestezija', 'sr' FROM medical_services WHERE slug = 'central-nerve-block-for-surgical-interventions'
UNION ALL SELECT id, 'Спинална анестезија', 'sr-cyrl' FROM medical_services WHERE slug = 'central-nerve-block-for-surgical-interventions'
UNION ALL SELECT id, 'Спинальная анестезия', 'ru' FROM medical_services WHERE slug = 'central-nerve-block-for-surgical-interventions'
UNION ALL SELECT id, 'Нейроаксиальная анестезия', 'ru' FROM medical_services WHERE slug = 'central-nerve-block-for-surgical-interventions'
UNION ALL SELECT id, 'Spinalanästhesie', 'de' FROM medical_services WHERE slug = 'central-nerve-block-for-surgical-interventions'
UNION ALL SELECT id, 'Spinal anestezi', 'tr' FROM medical_services WHERE slug = 'central-nerve-block-for-surgical-interventions';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Epidural Analgesia', 'en' FROM medical_services WHERE slug = 'continuous-epidural-anesthesiaanalgesia'
UNION ALL SELECT id, 'Epiduralna analgezija', 'sr' FROM medical_services WHERE slug = 'continuous-epidural-anesthesiaanalgesia'
UNION ALL SELECT id, 'Епидурална аналгезија', 'sr-cyrl' FROM medical_services WHERE slug = 'continuous-epidural-anesthesiaanalgesia'
UNION ALL SELECT id, 'Эпидуральная анальгезия', 'ru' FROM medical_services WHERE slug = 'continuous-epidural-anesthesiaanalgesia'
UNION ALL SELECT id, 'Эпидуралка', 'ru' FROM medical_services WHERE slug = 'continuous-epidural-anesthesiaanalgesia'
UNION ALL SELECT id, 'Periduralanästhesie', 'de' FROM medical_services WHERE slug = 'continuous-epidural-anesthesiaanalgesia';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Interkostalna blokada', 'sr' FROM medical_services WHERE slug = 'intercostal-nerve-block'
UNION ALL SELECT id, 'Интеркостална блокада', 'sr-cyrl' FROM medical_services WHERE slug = 'intercostal-nerve-block'
UNION ALL SELECT id, 'Межрёберная блокада', 'ru' FROM medical_services WHERE slug = 'intercostal-nerve-block';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pudendal Nerve Block', 'en' FROM medical_services WHERE slug = 'pudendal-block'
UNION ALL SELECT id, 'Пудендальная анестезия', 'ru' FROM medical_services WHERE slug = 'pudendal-block'
UNION ALL SELECT id, 'Блокада полового нерва', 'ru' FROM medical_services WHERE slug = 'pudendal-block'
UNION ALL SELECT id, 'Pudendusblock', 'de' FROM medical_services WHERE slug = 'pudendal-block'
UNION ALL SELECT id, 'Pudendal sinir bloğu', 'tr' FROM medical_services WHERE slug = 'pudendal-block';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Jaw Cyst Removal', 'en' FROM medical_services WHERE slug = 'cystectomy'
UNION ALL SELECT id, 'Uklanjanje ciste na zubu', 'sr' FROM medical_services WHERE slug = 'cystectomy'
UNION ALL SELECT id, 'Уклањање цисте на зубу', 'sr-cyrl' FROM medical_services WHERE slug = 'cystectomy'
UNION ALL SELECT id, 'Удаление кисты зуба', 'ru' FROM medical_services WHERE slug = 'cystectomy'
UNION ALL SELECT id, 'Удаление кисты челюсти', 'ru' FROM medical_services WHERE slug = 'cystectomy'
UNION ALL SELECT id, 'Entfernung einer Kieferzyste', 'de' FROM medical_services WHERE slug = 'cystectomy'
UNION ALL SELECT id, 'Çene kisti ameliyatı', 'tr' FROM medical_services WHERE slug = 'cystectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Scaling and Air Polishing', 'en' FROM medical_services WHERE slug = 'dental-calculus-removal-and-air-flow'
UNION ALL SELECT id, 'Skidanje kamenca i Air-Flow', 'sr' FROM medical_services WHERE slug = 'dental-calculus-removal-and-air-flow'
UNION ALL SELECT id, 'Скидање каменца и Air-Flow', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-calculus-removal-and-air-flow'
UNION ALL SELECT id, 'Удаление зубного камня и Эйр Флоу', 'ru' FROM medical_services WHERE slug = 'dental-calculus-removal-and-air-flow'
UNION ALL SELECT id, 'Detertraj ve Air-Flow', 'tr' FROM medical_services WHERE slug = 'dental-calculus-removal-and-air-flow';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Имплант Бредент', 'ru' FROM medical_services WHERE slug = 'dental-implant-bredent'
UNION ALL SELECT id, 'Имплантат Бредент', 'ru' FROM medical_services WHERE slug = 'dental-implant-bredent';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Имплант Нобель Биокеа', 'ru' FROM medical_services WHERE slug = 'dental-implant-nobel-biocare'
UNION ALL SELECT id, 'Имплантат Нобель Биокеа', 'ru' FROM medical_services WHERE slug = 'dental-implant-nobel-biocare';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Имплант Штрауманн', 'ru' FROM medical_services WHERE slug = 'dental-implant-straumann'
UNION ALL SELECT id, 'Имплантат Штрауманн', 'ru' FROM medical_services WHERE slug = 'dental-implant-straumann';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Popravka proteze', 'sr' FROM medical_services WHERE slug = 'denture-repair'
UNION ALL SELECT id, 'Поправка протезе', 'sr-cyrl' FROM medical_services WHERE slug = 'denture-repair'
UNION ALL SELECT id, 'Починка протеза', 'ru' FROM medical_services WHERE slug = 'denture-repair';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Direkt protez besleme', 'tr' FROM medical_services WHERE slug = 'direct-denture-relining';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Fluoride Dental Sealant', 'en' FROM medical_services WHERE slug = 'fissure-sealant-with-fluoride'
UNION ALL SELECT id, 'Silanti sa fluorom', 'sr' FROM medical_services WHERE slug = 'fissure-sealant-with-fluoride'
UNION ALL SELECT id, 'Силанти са флуором', 'sr-cyrl' FROM medical_services WHERE slug = 'fissure-sealant-with-fluoride'
UNION ALL SELECT id, 'Запечатывание фиссур с фтором', 'ru' FROM medical_services WHERE slug = 'fissure-sealant-with-fluoride';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Оттиск для несъёмного протезирования', 'ru' FROM medical_services WHERE slug = 'fixed-prosthetic-impression';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Elastična proteza', 'sr' FROM medical_services WHERE slug = 'flexible-denture'
UNION ALL SELECT id, 'Еластична протеза', 'sr-cyrl' FROM medical_services WHERE slug = 'flexible-denture'
UNION ALL SELECT id, 'Нейлоновый протез', 'ru' FROM medical_services WHERE slug = 'flexible-denture'
UNION ALL SELECT id, 'Nylonprothese', 'de' FROM medical_services WHERE slug = 'flexible-denture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Frenum Removal', 'en' FROM medical_services WHERE slug = 'frenectomy'
UNION ALL SELECT id, 'Uklanjanje frenuluma', 'sr' FROM medical_services WHERE slug = 'frenectomy'
UNION ALL SELECT id, 'Уклањање френулума', 'sr-cyrl' FROM medical_services WHERE slug = 'frenectomy'
UNION ALL SELECT id, 'Иссечение уздечки', 'ru' FROM medical_services WHERE slug = 'frenectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Frenulum Removal', 'en' FROM medical_services WHERE slug = 'frenulectomy'
UNION ALL SELECT id, 'Удаление уздечки', 'ru' FROM medical_services WHERE slug = 'frenulectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kontrolni pregled novorođenčeta', 'sr' FROM medical_services WHERE slug = 'follow-up-neonatologist-examination'
UNION ALL SELECT id, 'Контролни преглед новорођенчета', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-neonatologist-examination'
UNION ALL SELECT id, 'Контрольный осмотр новорождённого', 'ru' FROM medical_services WHERE slug = 'follow-up-neonatologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pediatrician Visit', 'en' FROM medical_services WHERE slug = 'pediatric-examination'
UNION ALL SELECT id, 'Paediatric Examination', 'en' FROM medical_services WHERE slug = 'pediatric-examination'
UNION ALL SELECT id, 'Pregled pedijatra', 'sr' FROM medical_services WHERE slug = 'pediatric-examination'
UNION ALL SELECT id, 'Преглед педијатра', 'sr-cyrl' FROM medical_services WHERE slug = 'pediatric-examination'
UNION ALL SELECT id, 'Pregled djeteta', 'sr' FROM medical_services WHERE slug = 'pediatric-examination'
UNION ALL SELECT id, 'Преглед дјетета', 'sr-cyrl' FROM medical_services WHERE slug = 'pediatric-examination'
UNION ALL SELECT id, 'Приём педиатра', 'ru' FROM medical_services WHERE slug = 'pediatric-examination'
UNION ALL SELECT id, 'Осмотр педиатра', 'ru' FROM medical_services WHERE slug = 'pediatric-examination'
UNION ALL SELECT id, 'Untersuchung beim Kinderarzt', 'de' FROM medical_services WHERE slug = 'pediatric-examination'
UNION ALL SELECT id, 'Çocuk doktoru muayenesi', 'tr' FROM medical_services WHERE slug = 'pediatric-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Dječja rehabilitacija', 'sr' FROM medical_services WHERE slug = 'pediatric-rehabilitation'
UNION ALL SELECT id, 'Дјечја рехабилитација', 'sr-cyrl' FROM medical_services WHERE slug = 'pediatric-rehabilitation'
UNION ALL SELECT id, 'Реабилитация детей', 'ru' FROM medical_services WHERE slug = 'pediatric-rehabilitation'
UNION ALL SELECT id, 'Kinder-Reha', 'de' FROM medical_services WHERE slug = 'pediatric-rehabilitation'
UNION ALL SELECT id, 'Çocuk rehabilitasyonu', 'tr' FROM medical_services WHERE slug = 'pediatric-rehabilitation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Skraćivanje desni', 'sr' FROM medical_services WHERE slug = 'gingivectomy'
UNION ALL SELECT id, 'Скраћивање десни', 'sr-cyrl' FROM medical_services WHERE slug = 'gingivectomy'
UNION ALL SELECT id, 'Иссечение десны', 'ru' FROM medical_services WHERE slug = 'gingivectomy'
UNION ALL SELECT id, 'Гингивектомия', 'ru' FROM medical_services WHERE slug = 'gingivectomy'
UNION ALL SELECT id, 'Diş eti kesimi', 'tr' FROM medical_services WHERE slug = 'gingivectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Gum Contouring', 'en' FROM medical_services WHERE slug = 'gingivoplasty'
UNION ALL SELECT id, 'Oblikovanje desni', 'sr' FROM medical_services WHERE slug = 'gingivoplasty'
UNION ALL SELECT id, 'Обликовање десни', 'sr-cyrl' FROM medical_services WHERE slug = 'gingivoplasty'
UNION ALL SELECT id, 'Коррекция контура десны', 'ru' FROM medical_services WHERE slug = 'gingivoplasty'
UNION ALL SELECT id, 'Zahnfleischkorrektur', 'de' FROM medical_services WHERE slug = 'gingivoplasty'
UNION ALL SELECT id, 'Diş eti şekillendirme', 'tr' FROM medical_services WHERE slug = 'gingivoplasty';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'GIC Filling', 'en' FROM medical_services WHERE slug = 'glass-ionomer-filling'
UNION ALL SELECT id, 'Glasjonomerna plomba', 'sr' FROM medical_services WHERE slug = 'glass-ionomer-filling'
UNION ALL SELECT id, 'Гласјономерна пломба', 'sr-cyrl' FROM medical_services WHERE slug = 'glass-ionomer-filling'
UNION ALL SELECT id, 'Glasjonomerni ispun', 'sr' FROM medical_services WHERE slug = 'glass-ionomer-filling'
UNION ALL SELECT id, 'Гласјономерни испун', 'sr-cyrl' FROM medical_services WHERE slug = 'glass-ionomer-filling'
UNION ALL SELECT id, 'Пломба из стеклоиономерного цемента', 'ru' FROM medical_services WHERE slug = 'glass-ionomer-filling'
UNION ALL SELECT id, 'Пломба СИЦ', 'ru' FROM medical_services WHERE slug = 'glass-ionomer-filling';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Take-Home Teeth Whitening', 'en' FROM medical_services WHERE slug = 'home-teeth-whitening'
UNION ALL SELECT id, 'Kućno izbjeljivanje zuba', 'sr' FROM medical_services WHERE slug = 'home-teeth-whitening'
UNION ALL SELECT id, 'Кућно избјељивање зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'home-teeth-whitening'
UNION ALL SELECT id, 'Kućno izbeljivanje zuba', 'sr' FROM medical_services WHERE slug = 'home-teeth-whitening'
UNION ALL SELECT id, 'Кућно избељивање зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'home-teeth-whitening'
UNION ALL SELECT id, 'Отбеливание зубов капами', 'ru' FROM medical_services WHERE slug = 'home-teeth-whitening'
UNION ALL SELECT id, 'Отбеливание зубов в домашних условиях', 'ru' FROM medical_services WHERE slug = 'home-teeth-whitening'
UNION ALL SELECT id, 'Home-Bleaching', 'de' FROM medical_services WHERE slug = 'home-teeth-whitening'
UNION ALL SELECT id, 'Ev tipi diş beyazlatma', 'tr' FROM medical_services WHERE slug = 'home-teeth-whitening';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pregled implantologa', 'sr' FROM medical_services WHERE slug = 'implantologist-consultation'
UNION ALL SELECT id, 'Преглед имплантолога', 'sr-cyrl' FROM medical_services WHERE slug = 'implantologist-consultation'
UNION ALL SELECT id, 'Приём имплантолога', 'ru' FROM medical_services WHERE slug = 'implantologist-consultation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Лабораторная перебазировка протеза', 'ru' FROM medical_services WHERE slug = 'indirect-denture-relining'
UNION ALL SELECT id, 'Laborunterfütterung', 'de' FROM medical_services WHERE slug = 'indirect-denture-relining'
UNION ALL SELECT id, 'İndirekt protez besleme', 'tr' FROM medical_services WHERE slug = 'indirect-denture-relining';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Non-Vital Tooth Bleaching', 'en' FROM medical_services WHERE slug = 'internal-bleaching-of-devitalized-tooth'
UNION ALL SELECT id, 'Izbjeljivanje mrtvog zuba', 'sr' FROM medical_services WHERE slug = 'internal-bleaching-of-devitalized-tooth'
UNION ALL SELECT id, 'Избјељивање мртвог зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'internal-bleaching-of-devitalized-tooth'
UNION ALL SELECT id, 'Izbeljivanje devitalizovanog zuba', 'sr' FROM medical_services WHERE slug = 'internal-bleaching-of-devitalized-tooth'
UNION ALL SELECT id, 'Избељивање девитализованог зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'internal-bleaching-of-devitalized-tooth'
UNION ALL SELECT id, 'Внутриканальное отбеливание зуба', 'ru' FROM medical_services WHERE slug = 'internal-bleaching-of-devitalized-tooth'
UNION ALL SELECT id, 'Отбеливание депульпированного зуба', 'ru' FROM medical_services WHERE slug = 'internal-bleaching-of-devitalized-tooth'
UNION ALL SELECT id, 'Internes Bleaching', 'de' FROM medical_services WHERE slug = 'internal-bleaching-of-devitalized-tooth'
UNION ALL SELECT id, 'Ölü diş beyazlatma', 'tr' FROM medical_services WHERE slug = 'internal-bleaching-of-devitalized-tooth';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Periapical X-Ray', 'en' FROM medical_services WHERE slug = 'intraoral-x-ray'
UNION ALL SELECT id, 'Ciljani snimak zuba', 'sr' FROM medical_services WHERE slug = 'intraoral-x-ray'
UNION ALL SELECT id, 'Циљани снимак зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'intraoral-x-ray'
UNION ALL SELECT id, 'RVG snimak zuba', 'sr' FROM medical_services WHERE slug = 'intraoral-x-ray'
UNION ALL SELECT id, 'РВГ снимак зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'intraoral-x-ray'
UNION ALL SELECT id, 'Прицельный снимок зуба', 'ru' FROM medical_services WHERE slug = 'intraoral-x-ray'
UNION ALL SELECT id, 'Радиовизиография', 'ru' FROM medical_services WHERE slug = 'intraoral-x-ray'
UNION ALL SELECT id, 'Zahnfilm', 'de' FROM medical_services WHERE slug = 'intraoral-x-ray'
UNION ALL SELECT id, 'Periapikal röntgen', 'tr' FROM medical_services WHERE slug = 'intraoral-x-ray';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lasersko izbeljivanje zuba', 'sr' FROM medical_services WHERE slug = 'laser-teeth-whitening'
UNION ALL SELECT id, 'Ласерско избељивање зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'laser-teeth-whitening'
UNION ALL SELECT id, 'Laserbleaching', 'de' FROM medical_services WHERE slug = 'laser-teeth-whitening'
UNION ALL SELECT id, 'Lazer diş beyazlatma', 'tr' FROM medical_services WHERE slug = 'laser-teeth-whitening';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Resin-Bonded Bridge', 'en' FROM medical_services WHERE slug = 'maryland-bridge'
UNION ALL SELECT id, 'Adhezivni most', 'sr' FROM medical_services WHERE slug = 'maryland-bridge'
UNION ALL SELECT id, 'Адхезивни мост', 'sr-cyrl' FROM medical_services WHERE slug = 'maryland-bridge'
UNION ALL SELECT id, 'Адгезивный мост', 'ru' FROM medical_services WHERE slug = 'maryland-bridge'
UNION ALL SELECT id, 'Мерилендский мост', 'ru' FROM medical_services WHERE slug = 'maryland-bridge'
UNION ALL SELECT id, 'Klebebrücke', 'de' FROM medical_services WHERE slug = 'maryland-bridge'
UNION ALL SELECT id, 'Adeziv köprü', 'tr' FROM medical_services WHERE slug = 'maryland-bridge';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Металлокерамическая коронка на кобальт-хромовом сплаве', 'ru' FROM medical_services WHERE slug = 'metal-ceramic-crown-cocr';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'PFM Crown', 'en' FROM medical_services WHERE slug = 'metal-ceramic-crown'
UNION ALL SELECT id, 'Porcelain-Fused-to-Metal Crown', 'en' FROM medical_services WHERE slug = 'metal-ceramic-crown'
UNION ALL SELECT id, 'Metalokeramička kruna', 'sr' FROM medical_services WHERE slug = 'metal-ceramic-crown'
UNION ALL SELECT id, 'Металокерамичка круна', 'sr-cyrl' FROM medical_services WHERE slug = 'metal-ceramic-crown'
UNION ALL SELECT id, 'Металлокерамика', 'ru' FROM medical_services WHERE slug = 'metal-ceramic-crown'
UNION ALL SELECT id, 'VMK-Krone', 'de' FROM medical_services WHERE slug = 'metal-ceramic-crown'
UNION ALL SELECT id, 'Metal destekli porselen kron', 'tr' FROM medical_services WHERE slug = 'metal-ceramic-crown'
UNION ALL SELECT id, 'Metal seramik kron', 'tr' FROM medical_services WHERE slug = 'metal-ceramic-crown';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Zirconia Crown', 'en' FROM medical_services WHERE slug = 'metal-free-zirconia-ceramic-crown'
UNION ALL SELECT id, 'Cirkonijum krunica', 'sr' FROM medical_services WHERE slug = 'metal-free-zirconia-ceramic-crown'
UNION ALL SELECT id, 'Цирконијум круница', 'sr-cyrl' FROM medical_services WHERE slug = 'metal-free-zirconia-ceramic-crown'
UNION ALL SELECT id, 'Циркониевая коронка', 'ru' FROM medical_services WHERE slug = 'metal-free-zirconia-ceramic-crown'
UNION ALL SELECT id, 'Коронка из диоксида циркония', 'ru' FROM medical_services WHERE slug = 'metal-free-zirconia-ceramic-crown'
UNION ALL SELECT id, 'Zirkonkrone', 'de' FROM medical_services WHERE slug = 'metal-free-zirconia-ceramic-crown'
UNION ALL SELECT id, 'Zirkonyum kron', 'tr' FROM medical_services WHERE slug = 'metal-free-zirconia-ceramic-crown';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Panoramski snimak zuba', 'sr' FROM medical_services WHERE slug = 'panoramic-x-ray'
UNION ALL SELECT id, 'Панорамски снимак зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'panoramic-x-ray'
UNION ALL SELECT id, 'OPG snimak', 'sr' FROM medical_services WHERE slug = 'panoramic-x-ray'
UNION ALL SELECT id, 'ОПГ снимак', 'sr-cyrl' FROM medical_services WHERE slug = 'panoramic-x-ray'
UNION ALL SELECT id, 'ОПТГ', 'ru' FROM medical_services WHERE slug = 'panoramic-x-ray'
UNION ALL SELECT id, 'Панорамный снимок зубов', 'ru' FROM medical_services WHERE slug = 'panoramic-x-ray'
UNION ALL SELECT id, 'Orthopantomogramm', 'de' FROM medical_services WHERE slug = 'panoramic-x-ray'
UNION ALL SELECT id, 'Panoramik diş filmi', 'tr' FROM medical_services WHERE slug = 'panoramic-x-ray';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Частичный пластиночный протез', 'ru' FROM medical_services WHERE slug = 'partial-acrylic-denture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Removable Partial Denture', 'en' FROM medical_services WHERE slug = 'partial-denture'
UNION ALL SELECT id, 'Djelimična proteza', 'sr' FROM medical_services WHERE slug = 'partial-denture'
UNION ALL SELECT id, 'Дјелимична протеза', 'sr-cyrl' FROM medical_services WHERE slug = 'partial-denture'
UNION ALL SELECT id, 'Delimična proteza', 'sr' FROM medical_services WHERE slug = 'partial-denture'
UNION ALL SELECT id, 'Делимична протеза', 'sr-cyrl' FROM medical_services WHERE slug = 'partial-denture'
UNION ALL SELECT id, 'Частичный протез', 'ru' FROM medical_services WHERE slug = 'partial-denture'
UNION ALL SELECT id, 'Kısmi protez', 'tr' FROM medical_services WHERE slug = 'partial-denture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Наложение лечебной прокладки', 'ru' FROM medical_services WHERE slug = 'pulp-capping-direct-or-indirect';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Liječenje živca zuba', 'sr' FROM medical_services WHERE slug = 'pulpitis-treatment'
UNION ALL SELECT id, 'Лијечење живца зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'pulpitis-treatment'
UNION ALL SELECT id, 'Lečenje pulpitisa', 'sr' FROM medical_services WHERE slug = 'pulpitis-treatment'
UNION ALL SELECT id, 'Лечење пулпитиса', 'sr-cyrl' FROM medical_services WHERE slug = 'pulpitis-treatment'
UNION ALL SELECT id, 'Лечение нерва зуба', 'ru' FROM medical_services WHERE slug = 'pulpitis-treatment'
UNION ALL SELECT id, 'Behandlung einer Zahnnerventzündung', 'de' FROM medical_services WHERE slug = 'pulpitis-treatment'
UNION ALL SELECT id, 'Diş siniri tedavisi', 'tr' FROM medical_services WHERE slug = 'pulpitis-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Vađenje krvi', 'sr' FROM medical_services WHERE slug = 'blood-collection-fee'
UNION ALL SELECT id, 'Вађење крви', 'sr-cyrl' FROM medical_services WHERE slug = 'blood-collection-fee'
UNION ALL SELECT id, 'Взятие крови', 'ru' FROM medical_services WHERE slug = 'blood-collection-fee'
UNION ALL SELECT id, 'Blutabnahme', 'de' FROM medical_services WHERE slug = 'blood-collection-fee';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Finger Prick Blood Draw', 'en' FROM medical_services WHERE slug = 'capillary-blood-draw'
UNION ALL SELECT id, 'Vađenje krvi iz prsta', 'sr' FROM medical_services WHERE slug = 'capillary-blood-draw'
UNION ALL SELECT id, 'Вађење крви из прста', 'sr-cyrl' FROM medical_services WHERE slug = 'capillary-blood-draw'
UNION ALL SELECT id, 'Взятие крови из пальца', 'ru' FROM medical_services WHERE slug = 'capillary-blood-draw'
UNION ALL SELECT id, 'Blutabnahme aus dem Finger', 'de' FROM medical_services WHERE slug = 'capillary-blood-draw'
UNION ALL SELECT id, 'Kapiller kan alımı', 'tr' FROM medical_services WHERE slug = 'capillary-blood-draw';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Protrombinsko vrijeme', 'sr' FROM medical_services WHERE slug = 'prothrombin-time-pt'
UNION ALL SELECT id, 'Протромбинско вријеме', 'sr-cyrl' FROM medical_services WHERE slug = 'prothrombin-time-pt'
UNION ALL SELECT id, 'Protrombinsko vreme', 'sr' FROM medical_services WHERE slug = 'prothrombin-time-pt'
UNION ALL SELECT id, 'Протромбинско време', 'sr-cyrl' FROM medical_services WHERE slug = 'prothrombin-time-pt'
UNION ALL SELECT id, 'ПТВ', 'ru' FROM medical_services WHERE slug = 'prothrombin-time-pt'
UNION ALL SELECT id, 'Протромбин по Квику', 'ru' FROM medical_services WHERE slug = 'prothrombin-time-pt'
UNION ALL SELECT id, 'Quick-Wert', 'de' FROM medical_services WHERE slug = 'prothrombin-time-pt';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Sterilna posuda za urin', 'sr' FROM medical_services WHERE slug = 'sample-reception-and-sterile-container-distribution'
UNION ALL SELECT id, 'Стерилна посуда за урин', 'sr-cyrl' FROM medical_services WHERE slug = 'sample-reception-and-sterile-container-distribution'
UNION ALL SELECT id, 'Стерильный контейнер для мочи', 'ru' FROM medical_services WHERE slug = 'sample-reception-and-sterile-container-distribution';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Allergist Consultation', 'en' FROM medical_services WHERE slug = 'allergist-examination'
UNION ALL SELECT id, 'Konsultacija alergologa', 'sr' FROM medical_services WHERE slug = 'allergist-examination'
UNION ALL SELECT id, 'Консултација алерголога', 'sr-cyrl' FROM medical_services WHERE slug = 'allergist-examination'
UNION ALL SELECT id, 'Приём аллерголога', 'ru' FROM medical_services WHERE slug = 'allergist-examination'
UNION ALL SELECT id, 'Консультация аллерголога', 'ru' FROM medical_services WHERE slug = 'allergist-examination'
UNION ALL SELECT id, 'Untersuchung beim Allergologen', 'de' FROM medical_services WHERE slug = 'allergist-examination'
UNION ALL SELECT id, 'Alerji uzmanı muayenesi', 'tr' FROM medical_services WHERE slug = 'allergist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hydrogen Breath Test', 'en' FROM medical_services WHERE slug = 'lactofan-intolerance-tests'
UNION ALL SELECT id, 'Lactose Intolerance Test', 'en' FROM medical_services WHERE slug = 'lactofan-intolerance-tests'
UNION ALL SELECT id, 'Laktofan testovi', 'sr' FROM medical_services WHERE slug = 'lactofan-intolerance-tests'
UNION ALL SELECT id, 'Лактофан тестови', 'sr-cyrl' FROM medical_services WHERE slug = 'lactofan-intolerance-tests'
UNION ALL SELECT id, 'Vodonični izdisajni test', 'sr' FROM medical_services WHERE slug = 'lactofan-intolerance-tests'
UNION ALL SELECT id, 'Водонични издисајни тест', 'sr-cyrl' FROM medical_services WHERE slug = 'lactofan-intolerance-tests'
UNION ALL SELECT id, 'Водородный дыхательный тест', 'ru' FROM medical_services WHERE slug = 'lactofan-intolerance-tests'
UNION ALL SELECT id, 'Тест на непереносимость лактозы', 'ru' FROM medical_services WHERE slug = 'lactofan-intolerance-tests'
UNION ALL SELECT id, 'H2-Atemtest', 'de' FROM medical_services WHERE slug = 'lactofan-intolerance-tests'
UNION ALL SELECT id, 'Laktoseintoleranztest', 'de' FROM medical_services WHERE slug = 'lactofan-intolerance-tests'
UNION ALL SELECT id, 'Hidrojen nefes testi', 'tr' FROM medical_services WHERE slug = 'lactofan-intolerance-tests'
UNION ALL SELECT id, 'Laktoz intoleransı testi', 'tr' FROM medical_services WHERE slug = 'lactofan-intolerance-tests';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Bilateral Hernia Repair', 'en' FROM medical_services WHERE slug = 'bilateral-hernia-operation'
UNION ALL SELECT id, 'Obostrana hernioplastika', 'sr' FROM medical_services WHERE slug = 'bilateral-hernia-operation'
UNION ALL SELECT id, 'Обострана херниопластика', 'sr-cyrl' FROM medical_services WHERE slug = 'bilateral-hernia-operation'
UNION ALL SELECT id, 'Двусторонняя герниопластика', 'ru' FROM medical_services WHERE slug = 'bilateral-hernia-operation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operacija epigastrične hernije', 'sr' FROM medical_services WHERE slug = 'epigastric-hernia-operation'
UNION ALL SELECT id, 'Операција епигастричне херније', 'sr-cyrl' FROM medical_services WHERE slug = 'epigastric-hernia-operation'
UNION ALL SELECT id, 'Операция грыжи белой линии живота', 'ru' FROM medical_services WHERE slug = 'epigastric-hernia-operation'
UNION ALL SELECT id, 'Oberbauchbruch-Operation', 'de' FROM medical_services WHERE slug = 'epigastric-hernia-operation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hernia Repair', 'en' FROM medical_services WHERE slug = 'hernia-operation'
UNION ALL SELECT id, 'Operacija hernije', 'sr' FROM medical_services WHERE slug = 'hernia-operation'
UNION ALL SELECT id, 'Операција херније', 'sr-cyrl' FROM medical_services WHERE slug = 'hernia-operation'
UNION ALL SELECT id, 'Hernioplastika', 'sr' FROM medical_services WHERE slug = 'hernia-operation'
UNION ALL SELECT id, 'Херниопластика', 'sr-cyrl' FROM medical_services WHERE slug = 'hernia-operation'
UNION ALL SELECT id, 'Грыжесечение', 'ru' FROM medical_services WHERE slug = 'hernia-operation'
UNION ALL SELECT id, 'Герниопластика', 'ru' FROM medical_services WHERE slug = 'hernia-operation'
UNION ALL SELECT id, 'Bruchoperation', 'de' FROM medical_services WHERE slug = 'hernia-operation'
UNION ALL SELECT id, 'Herni ameliyatı', 'tr' FROM medical_services WHERE slug = 'hernia-operation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Laparoscopic Appendicectomy', 'en' FROM medical_services WHERE slug = 'laparoscopic-appendectomy'
UNION ALL SELECT id, 'Laparoskopska apendektomija', 'sr' FROM medical_services WHERE slug = 'laparoscopic-appendectomy'
UNION ALL SELECT id, 'Лапароскопска апендектомија', 'sr-cyrl' FROM medical_services WHERE slug = 'laparoscopic-appendectomy'
UNION ALL SELECT id, 'Лапароскопическое удаление аппендикса', 'ru' FROM medical_services WHERE slug = 'laparoscopic-appendectomy'
UNION ALL SELECT id, 'Laparoskopische Blinddarmentfernung', 'de' FROM medical_services WHERE slug = 'laparoscopic-appendectomy'
UNION ALL SELECT id, 'Laparoskopik apandisit ameliyatı', 'tr' FROM medical_services WHERE slug = 'laparoscopic-appendectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Laparoscopic Gallbladder Removal', 'en' FROM medical_services WHERE slug = 'laparoscopic-cholecystectomy'
UNION ALL SELECT id, 'Laparoskopska holecistektomija', 'sr' FROM medical_services WHERE slug = 'laparoscopic-cholecystectomy'
UNION ALL SELECT id, 'Лапароскопска холецистектомија', 'sr-cyrl' FROM medical_services WHERE slug = 'laparoscopic-cholecystectomy'
UNION ALL SELECT id, 'Laparoskopska operacija žučnog mjehura', 'sr' FROM medical_services WHERE slug = 'laparoscopic-cholecystectomy'
UNION ALL SELECT id, 'Лапароскопска операција жучног мјехура', 'sr-cyrl' FROM medical_services WHERE slug = 'laparoscopic-cholecystectomy'
UNION ALL SELECT id, 'Лапароскопическое удаление желчного пузыря', 'ru' FROM medical_services WHERE slug = 'laparoscopic-cholecystectomy'
UNION ALL SELECT id, 'Laparoskopische Gallenblasenentfernung', 'de' FROM medical_services WHERE slug = 'laparoscopic-cholecystectomy'
UNION ALL SELECT id, 'Laparoskopik safra kesesi ameliyatı', 'tr' FROM medical_services WHERE slug = 'laparoscopic-cholecystectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Laparoskopska biopsija jetre', 'sr' FROM medical_services WHERE slug = 'laparoscopic-liver-biopsy'
UNION ALL SELECT id, 'Лапароскопска биопсија јетре', 'sr-cyrl' FROM medical_services WHERE slug = 'laparoscopic-liver-biopsy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Лапароскопическая правосторонняя гемиколэктомия', 'ru' FROM medical_services WHERE slug = 'laparoscopic-right-hemicolectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Laparoskopska operacija pupčane kile', 'sr' FROM medical_services WHERE slug = 'laparoscopic-umbilical-hernia-repair'
UNION ALL SELECT id, 'Лапароскопска операција пупчане киле', 'sr-cyrl' FROM medical_services WHERE slug = 'laparoscopic-umbilical-hernia-repair'
UNION ALL SELECT id, 'Лапароскопическая пластика пупочной грыжи', 'ru' FROM medical_services WHERE slug = 'laparoscopic-umbilical-hernia-repair'
UNION ALL SELECT id, 'Laparoskopische Nabelbruch-Operation', 'de' FROM medical_services WHERE slug = 'laparoscopic-umbilical-hernia-repair'
UNION ALL SELECT id, 'Laparoskopik göbek fıtığı ameliyatı', 'tr' FROM medical_services WHERE slug = 'laparoscopic-umbilical-hernia-repair';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Laser Hemorrhoidoplasty', 'en' FROM medical_services WHERE slug = 'laser-hemorrhoid-surgery'
UNION ALL SELECT id, 'Laserska operacija hemoroida', 'sr' FROM medical_services WHERE slug = 'laser-hemorrhoid-surgery'
UNION ALL SELECT id, 'Ласерска операција хемороида', 'sr-cyrl' FROM medical_services WHERE slug = 'laser-hemorrhoid-surgery'
UNION ALL SELECT id, 'Лазерная геморроидопластика', 'ru' FROM medical_services WHERE slug = 'laser-hemorrhoid-surgery'
UNION ALL SELECT id, 'Лазерное удаление геморроя', 'ru' FROM medical_services WHERE slug = 'laser-hemorrhoid-surgery'
UNION ALL SELECT id, 'Laserbehandlung von Hämorrhoiden', 'de' FROM medical_services WHERE slug = 'laser-hemorrhoid-surgery'
UNION ALL SELECT id, 'Lazerle hemoroid tedavisi', 'tr' FROM medical_services WHERE slug = 'laser-hemorrhoid-surgery';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Лазерное лечение свища прямой кишки', 'ru' FROM medical_services WHERE slug = 'laser-perianal-fistula-surgery';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Laserska operacija pilonidalne ciste', 'sr' FROM medical_services WHERE slug = 'laser-pilonidal-sinus-surgery'
UNION ALL SELECT id, 'Ласерска операција пилонидалне цисте', 'sr-cyrl' FROM medical_services WHERE slug = 'laser-pilonidal-sinus-surgery'
UNION ALL SELECT id, 'Лазерное лечение копчиковой кисты', 'ru' FROM medical_services WHERE slug = 'laser-pilonidal-sinus-surgery'
UNION ALL SELECT id, 'Лазерное лечение эпителиального копчикового хода', 'ru' FROM medical_services WHERE slug = 'laser-pilonidal-sinus-surgery'
UNION ALL SELECT id, 'Laserbehandlung der Steißbeinfistel', 'de' FROM medical_services WHERE slug = 'laser-pilonidal-sinus-surgery'
UNION ALL SELECT id, 'Lazerle kıl dönmesi tedavisi', 'tr' FROM medical_services WHERE slug = 'laser-pilonidal-sinus-surgery';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lijeva hemikolektomija sa anastomozom', 'sr' FROM medical_services WHERE slug = 'left-hemicolectomy-with-colo-colo-anastomosis'
UNION ALL SELECT id, 'Лијева хемиколектомија са анастомозом', 'sr-cyrl' FROM medical_services WHERE slug = 'left-hemicolectomy-with-colo-colo-anastomosis'
UNION ALL SELECT id, 'Левосторонняя гемиколэктомия с анастомозом', 'ru' FROM medical_services WHERE slug = 'left-hemicolectomy-with-colo-colo-anastomosis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lijeva hemikolektomija sa formiranjem stome', 'sr' FROM medical_services WHERE slug = 'left-hemicolectomy-with-colostomy'
UNION ALL SELECT id, 'Лијева хемиколектомија са формирањем стоме', 'sr-cyrl' FROM medical_services WHERE slug = 'left-hemicolectomy-with-colostomy'
UNION ALL SELECT id, 'Левосторонняя гемиколэктомия с колостомой', 'ru' FROM medical_services WHERE slug = 'left-hemicolectomy-with-colostomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Open Appendicectomy', 'en' FROM medical_services WHERE slug = 'open-appendectomy'
UNION ALL SELECT id, 'Удаление аппендикса открытым доступом', 'ru' FROM medical_services WHERE slug = 'open-appendectomy'
UNION ALL SELECT id, 'Offene Blinddarmentfernung', 'de' FROM medical_services WHERE slug = 'open-appendectomy'
UNION ALL SELECT id, 'Açık apandisit ameliyatı', 'tr' FROM medical_services WHERE slug = 'open-appendectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operacija recidivantne ingvinalne hernije', 'sr' FROM medical_services WHERE slug = 'recurrent-inguinal-hernia-repair'
UNION ALL SELECT id, 'Операција рецидивантне ингвиналне херније', 'sr-cyrl' FROM medical_services WHERE slug = 'recurrent-inguinal-hernia-repair'
UNION ALL SELECT id, 'Operacija recidivantne preponske kile', 'sr' FROM medical_services WHERE slug = 'recurrent-inguinal-hernia-repair'
UNION ALL SELECT id, 'Операција рецидивантне препонске киле', 'sr-cyrl' FROM medical_services WHERE slug = 'recurrent-inguinal-hernia-repair'
UNION ALL SELECT id, 'Пластика рецидивной паховой грыжи', 'ru' FROM medical_services WHERE slug = 'recurrent-inguinal-hernia-repair'
UNION ALL SELECT id, 'Operation eines Leistenbruchrezidivs', 'de' FROM medical_services WHERE slug = 'recurrent-inguinal-hernia-repair'
UNION ALL SELECT id, 'Tekrarlayan kasık fıtığı ameliyatı', 'tr' FROM medical_services WHERE slug = 'recurrent-inguinal-hernia-repair';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Desna hemikolektomija sa anastomozom', 'sr' FROM medical_services WHERE slug = 'right-hemicolectomy-with-anastomosis'
UNION ALL SELECT id, 'Десна хемиколектомија са анастомозом', 'sr-cyrl' FROM medical_services WHERE slug = 'right-hemicolectomy-with-anastomosis'
UNION ALL SELECT id, 'Правосторонняя гемиколэктомия с анастомозом', 'ru' FROM medical_services WHERE slug = 'right-hemicolectomy-with-anastomosis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Endodontic Retreatment', 'en' FROM medical_services WHERE slug = 'root-canal-retreatment'
UNION ALL SELECT id, 'Revizija kanala', 'sr' FROM medical_services WHERE slug = 'root-canal-retreatment'
UNION ALL SELECT id, 'Ревизија канала', 'sr-cyrl' FROM medical_services WHERE slug = 'root-canal-retreatment'
UNION ALL SELECT id, 'Перелечивание каналов', 'ru' FROM medical_services WHERE slug = 'root-canal-retreatment'
UNION ALL SELECT id, 'Повторное лечение каналов', 'ru' FROM medical_services WHERE slug = 'root-canal-retreatment'
UNION ALL SELECT id, 'Endodontische Revision', 'de' FROM medical_services WHERE slug = 'root-canal-retreatment'
UNION ALL SELECT id, 'Kanal revizyonu', 'tr' FROM medical_services WHERE slug = 'root-canal-retreatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, '3D snimak jednog segmenta', 'sr' FROM medical_services WHERE slug = 'single-segment-cbct-scan'
UNION ALL SELECT id, '3Д снимак једног сегмента', 'sr-cyrl' FROM medical_services WHERE slug = 'single-segment-cbct-scan'
UNION ALL SELECT id, 'КЛКТ одного сегмента', 'ru' FROM medical_services WHERE slug = 'single-segment-cbct-scan'
UNION ALL SELECT id, 'DVT eines Segments', 'de' FROM medical_services WHERE slug = 'single-segment-cbct-scan';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Plaque Removal', 'en' FROM medical_services WHERE slug = 'soft-dental-deposit-removal'
UNION ALL SELECT id, 'Uklanjanje plaka', 'sr' FROM medical_services WHERE slug = 'soft-dental-deposit-removal'
UNION ALL SELECT id, 'Уклањање плака', 'sr-cyrl' FROM medical_services WHERE slug = 'soft-dental-deposit-removal'
UNION ALL SELECT id, 'Удаление зубного налёта', 'ru' FROM medical_services WHERE slug = 'soft-dental-deposit-removal'
UNION ALL SELECT id, 'Plaqueentfernung', 'de' FROM medical_services WHERE slug = 'soft-dental-deposit-removal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hirurška ekstrakcija zuba', 'sr' FROM medical_services WHERE slug = 'surgical-tooth-extraction'
UNION ALL SELECT id, 'Хируршка екстракција зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'surgical-tooth-extraction'
UNION ALL SELECT id, 'Хирургическая экстракция зуба', 'ru' FROM medical_services WHERE slug = 'surgical-tooth-extraction'
UNION ALL SELECT id, 'Operative Zahnentfernung', 'de' FROM medical_services WHERE slug = 'surgical-tooth-extraction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Tooth Bleaching', 'en' FROM medical_services WHERE slug = 'teeth-whitening'
UNION ALL SELECT id, 'Bijeljenje zuba', 'sr' FROM medical_services WHERE slug = 'teeth-whitening'
UNION ALL SELECT id, 'Бијељење зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'teeth-whitening'
UNION ALL SELECT id, 'Zahnbleaching', 'de' FROM medical_services WHERE slug = 'teeth-whitening';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Provisional Crown', 'en' FROM medical_services WHERE slug = 'temporary-crown'
UNION ALL SELECT id, 'Privremena krunica', 'sr' FROM medical_services WHERE slug = 'temporary-crown'
UNION ALL SELECT id, 'Привремена круница', 'sr-cyrl' FROM medical_services WHERE slug = 'temporary-crown'
UNION ALL SELECT id, 'Провизорная коронка', 'ru' FROM medical_services WHERE slug = 'temporary-crown';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Tooth Reshaping', 'en' FROM medical_services WHERE slug = 'tooth-contouring'
UNION ALL SELECT id, 'Enameloplasty', 'en' FROM medical_services WHERE slug = 'tooth-contouring'
UNION ALL SELECT id, 'Коррекция формы зуба', 'ru' FROM medical_services WHERE slug = 'tooth-contouring'
UNION ALL SELECT id, 'Zahnformkorrektur', 'de' FROM medical_services WHERE slug = 'tooth-contouring'
UNION ALL SELECT id, 'Diş şekillendirme', 'tr' FROM medical_services WHERE slug = 'tooth-contouring';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Tooth Removal', 'en' FROM medical_services WHERE slug = 'tooth-extraction'
UNION ALL SELECT id, 'Ekstrakcija zuba', 'sr' FROM medical_services WHERE slug = 'tooth-extraction'
UNION ALL SELECT id, 'Екстракција зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'tooth-extraction'
UNION ALL SELECT id, 'Экстракция зуба', 'ru' FROM medical_services WHERE slug = 'tooth-extraction'
UNION ALL SELECT id, 'Удалить зуб', 'ru' FROM medical_services WHERE slug = 'tooth-extraction'
UNION ALL SELECT id, 'Zahn ziehen', 'de' FROM medical_services WHERE slug = 'tooth-extraction'
UNION ALL SELECT id, 'Diş çektirme', 'tr' FROM medical_services WHERE slug = 'tooth-extraction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Vestibuloplastika', 'sr' FROM medical_services WHERE slug = 'vestibuloplasty'
UNION ALL SELECT id, 'Углубление преддверия полости рта', 'ru' FROM medical_services WHERE slug = 'vestibuloplasty'
UNION ALL SELECT id, 'Mundvorhofplastik', 'de' FROM medical_services WHERE slug = 'vestibuloplasty';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Anterior Nasal Tamponade', 'en' FROM medical_services WHERE slug = 'anterior-nasal-packing';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Удаление доброкачественных новообразований кожи', 'ru' FROM medical_services WHERE slug = 'benign-skin-tumor-removal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Blood Transfusion', 'en' FROM medical_services WHERE slug = 'blood-and-blood-derivatives-transfusion'
UNION ALL SELECT id, 'Гемотрансфузия', 'ru' FROM medical_services WHERE slug = 'blood-and-blood-derivatives-transfusion'
UNION ALL SELECT id, 'Bluttransfusion', 'de' FROM medical_services WHERE slug = 'blood-and-blood-derivatives-transfusion'
UNION ALL SELECT id, 'Kan transfüzyonu', 'tr' FROM medical_services WHERE slug = 'blood-and-blood-derivatives-transfusion';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Nailfold Capillaroscopy', 'en' FROM medical_services WHERE slug = 'capillaroscopy'
UNION ALL SELECT id, 'Капилляроскопия ногтевого ложа', 'ru' FROM medical_services WHERE slug = 'capillaroscopy'
UNION ALL SELECT id, 'Nagelfalzkapillaroskopie', 'de' FROM medical_services WHERE slug = 'capillaroscopy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'IV Sedation', 'en' FROM medical_services WHERE slug = 'conscious-sedation'
UNION ALL SELECT id, 'Аналгоседация', 'ru' FROM medical_services WHERE slug = 'conscious-sedation'
UNION ALL SELECT id, 'Внутривенная седация', 'ru' FROM medical_services WHERE slug = 'conscious-sedation'
UNION ALL SELECT id, 'Dämmerschlaf', 'de' FROM medical_services WHERE slug = 'conscious-sedation'
UNION ALL SELECT id, 'Bilinçli sedasyon', 'tr' FROM medical_services WHERE slug = 'conscious-sedation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'DEXA Scan', 'en' FROM medical_services WHERE slug = 'dxa-bone-densitometry'
UNION ALL SELECT id, 'Bone Density Scan', 'en' FROM medical_services WHERE slug = 'dxa-bone-densitometry'
UNION ALL SELECT id, 'Mjerenje gustine kostiju', 'sr' FROM medical_services WHERE slug = 'dxa-bone-densitometry'
UNION ALL SELECT id, 'Мјерење густине костију', 'sr-cyrl' FROM medical_services WHERE slug = 'dxa-bone-densitometry'
UNION ALL SELECT id, 'Merenje gustine kostiju', 'sr' FROM medical_services WHERE slug = 'dxa-bone-densitometry'
UNION ALL SELECT id, 'Мерење густине костију', 'sr-cyrl' FROM medical_services WHERE slug = 'dxa-bone-densitometry'
UNION ALL SELECT id, 'Рентгеновская денситометрия', 'ru' FROM medical_services WHERE slug = 'dxa-bone-densitometry'
UNION ALL SELECT id, 'Измерение плотности костей', 'ru' FROM medical_services WHERE slug = 'dxa-bone-densitometry'
UNION ALL SELECT id, 'Kemik dansitometrisi', 'tr' FROM medical_services WHERE slug = 'dxa-bone-densitometry';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Intubacija traheje', 'sr' FROM medical_services WHERE slug = 'endotracheal-intubation'
UNION ALL SELECT id, 'Интубација трахеје', 'sr-cyrl' FROM medical_services WHERE slug = 'endotracheal-intubation'
UNION ALL SELECT id, 'Интубация трахеи', 'ru' FROM medical_services WHERE slug = 'endotracheal-intubation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'EGD with Injection Hemostasis', 'en' FROM medical_services WHERE slug = 'esophagogastroduodenoscopy-with-injection-hemostasis'
UNION ALL SELECT id, 'Gastroskopija sa injekcionom hemostazom', 'sr' FROM medical_services WHERE slug = 'esophagogastroduodenoscopy-with-injection-hemostasis'
UNION ALL SELECT id, 'Гастроскопија са инјекционом хемостазом', 'sr-cyrl' FROM medical_services WHERE slug = 'esophagogastroduodenoscopy-with-injection-hemostasis'
UNION ALL SELECT id, 'ЭГДС с инъекционным гемостазом', 'ru' FROM medical_services WHERE slug = 'esophagogastroduodenoscopy-with-injection-hemostasis'
UNION ALL SELECT id, 'Гастроскопия с инъекционным гемостазом', 'ru' FROM medical_services WHERE slug = 'esophagogastroduodenoscopy-with-injection-hemostasis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Splinter Removal', 'en' FROM medical_services WHERE slug = 'foreign-body-removal-from-skin-and-subcutaneous-tissue'
UNION ALL SELECT id, 'Vađenje stranog tijela iz kože', 'sr' FROM medical_services WHERE slug = 'foreign-body-removal-from-skin-and-subcutaneous-tissue'
UNION ALL SELECT id, 'Вађење страног тијела из коже', 'sr-cyrl' FROM medical_services WHERE slug = 'foreign-body-removal-from-skin-and-subcutaneous-tissue'
UNION ALL SELECT id, 'Удаление занозы', 'ru' FROM medical_services WHERE slug = 'foreign-body-removal-from-skin-and-subcutaneous-tissue'
UNION ALL SELECT id, 'Splitterentfernung', 'de' FROM medical_services WHERE slug = 'foreign-body-removal-from-skin-and-subcutaneous-tissue'
UNION ALL SELECT id, 'Kıymık çıkarma', 'tr' FROM medical_services WHERE slug = 'foreign-body-removal-from-skin-and-subcutaneous-tissue';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Repozicija uklještene hernije', 'sr' FROM medical_services WHERE slug = 'incarcerated-hernia-reduction'
UNION ALL SELECT id, 'Репозиција укљештене херније', 'sr-cyrl' FROM medical_services WHERE slug = 'incarcerated-hernia-reduction'
UNION ALL SELECT id, 'Repozicija ukleštene kile', 'sr' FROM medical_services WHERE slug = 'incarcerated-hernia-reduction'
UNION ALL SELECT id, 'Репозиција уклештене киле', 'sr-cyrl' FROM medical_services WHERE slug = 'incarcerated-hernia-reduction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Breast Implants', 'en' FROM medical_services WHERE slug = 'breast-augmentation'
UNION ALL SELECT id, 'Povećanje grudi', 'sr' FROM medical_services WHERE slug = 'breast-augmentation'
UNION ALL SELECT id, 'Повећање груди', 'sr-cyrl' FROM medical_services WHERE slug = 'breast-augmentation'
UNION ALL SELECT id, 'Увеличивающая маммопластика', 'ru' FROM medical_services WHERE slug = 'breast-augmentation'
UNION ALL SELECT id, 'Эндопротезирование груди', 'ru' FROM medical_services WHERE slug = 'breast-augmentation'
UNION ALL SELECT id, 'Brustaugmentation', 'de' FROM medical_services WHERE slug = 'breast-augmentation'
UNION ALL SELECT id, 'Göğüs büyütme', 'tr' FROM medical_services WHERE slug = 'breast-augmentation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Reduction Mammaplasty', 'en' FROM medical_services WHERE slug = 'breast-reduction'
UNION ALL SELECT id, 'Redukcija grudi', 'sr' FROM medical_services WHERE slug = 'breast-reduction'
UNION ALL SELECT id, 'Редукција груди', 'sr-cyrl' FROM medical_services WHERE slug = 'breast-reduction'
UNION ALL SELECT id, 'Редукционная маммопластика', 'ru' FROM medical_services WHERE slug = 'breast-reduction'
UNION ALL SELECT id, 'Mammareduktion', 'de' FROM medical_services WHERE slug = 'breast-reduction'
UNION ALL SELECT id, 'Göğüs küçültme', 'tr' FROM medical_services WHERE slug = 'breast-reduction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Male Breast Reduction', 'en' FROM medical_services WHERE slug = 'gynecomastia-correction'
UNION ALL SELECT id, 'Smanjenje grudi kod muškaraca', 'sr' FROM medical_services WHERE slug = 'gynecomastia-correction'
UNION ALL SELECT id, 'Смањење груди код мушкараца', 'sr-cyrl' FROM medical_services WHERE slug = 'gynecomastia-correction'
UNION ALL SELECT id, 'Уменьшение груди у мужчин', 'ru' FROM medical_services WHERE slug = 'gynecomastia-correction'
UNION ALL SELECT id, 'Erkek meme küçültme', 'tr' FROM medical_services WHERE slug = 'gynecomastia-correction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lip Fillers', 'en' FROM medical_services WHERE slug = 'lip-augmentation'
UNION ALL SELECT id, 'Povećanje usana', 'sr' FROM medical_services WHERE slug = 'lip-augmentation'
UNION ALL SELECT id, 'Повећање усана', 'sr-cyrl' FROM medical_services WHERE slug = 'lip-augmentation'
UNION ALL SELECT id, 'Контурная пластика губ', 'ru' FROM medical_services WHERE slug = 'lip-augmentation'
UNION ALL SELECT id, 'Lippenunterspritzung', 'de' FROM medical_services WHERE slug = 'lip-augmentation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Liposuktion', 'de' FROM medical_services WHERE slug = 'liposuction'
UNION ALL SELECT id, 'Liposakşın', 'tr' FROM medical_services WHERE slug = 'liposuction'
UNION ALL SELECT id, 'Yağ aldırma', 'tr' FROM medical_services WHERE slug = 'liposuction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Nose Job', 'en' FROM medical_services WHERE slug = 'rhinoplasty'
UNION ALL SELECT id, 'Rinoplastika', 'sr' FROM medical_services WHERE slug = 'rhinoplasty'
UNION ALL SELECT id, 'Пластика носа', 'ru' FROM medical_services WHERE slug = 'rhinoplasty'
UNION ALL SELECT id, 'Nasenkorrektur', 'de' FROM medical_services WHERE slug = 'rhinoplasty'
UNION ALL SELECT id, 'Burun estetiği', 'tr' FROM medical_services WHERE slug = 'rhinoplasty';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Bullhorn Lip Lift', 'en' FROM medical_services WHERE slug = 'surgical-upper-lip-lift'
UNION ALL SELECT id, 'Лифтинг верхней губы', 'ru' FROM medical_services WHERE slug = 'surgical-upper-lip-lift'
UNION ALL SELECT id, 'Булхорн', 'ru' FROM medical_services WHERE slug = 'surgical-upper-lip-lift';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Arthrocentesis', 'en' FROM medical_services WHERE slug = 'joint-puncture'
UNION ALL SELECT id, 'Artrocenteza', 'sr' FROM medical_services WHERE slug = 'joint-puncture'
UNION ALL SELECT id, 'Артроцентеза', 'sr-cyrl' FROM medical_services WHERE slug = 'joint-puncture'
UNION ALL SELECT id, 'Punkcija koljena', 'sr' FROM medical_services WHERE slug = 'joint-puncture'
UNION ALL SELECT id, 'Пункција кољена', 'sr-cyrl' FROM medical_services WHERE slug = 'joint-puncture'
UNION ALL SELECT id, 'Артроцентез', 'ru' FROM medical_services WHERE slug = 'joint-puncture'
UNION ALL SELECT id, 'Пункция коленного сустава', 'ru' FROM medical_services WHERE slug = 'joint-puncture'
UNION ALL SELECT id, 'Kniegelenkpunktion', 'de' FROM medical_services WHERE slug = 'joint-puncture'
UNION ALL SELECT id, 'Artrosentez', 'tr' FROM medical_services WHERE slug = 'joint-puncture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Mikroskopska analiza želudačnog soka', 'sr' FROM medical_services WHERE slug = 'microscopic-gastric-juice-analysis'
UNION ALL SELECT id, 'Микроскопска анализа желудачног сока', 'sr-cyrl' FROM medical_services WHERE slug = 'microscopic-gastric-juice-analysis'
UNION ALL SELECT id, 'Микроскопия желудочного сока', 'ru' FROM medical_services WHERE slug = 'microscopic-gastric-juice-analysis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Methacholine Challenge Test', 'en' FROM medical_services WHERE slug = 'nonspecific-bronchial-provocation-test'
UNION ALL SELECT id, 'Metaholinski test', 'sr' FROM medical_services WHERE slug = 'nonspecific-bronchial-provocation-test'
UNION ALL SELECT id, 'Метахолински тест', 'sr-cyrl' FROM medical_services WHERE slug = 'nonspecific-bronchial-provocation-test'
UNION ALL SELECT id, 'Метахолиновый тест', 'ru' FROM medical_services WHERE slug = 'nonspecific-bronchial-provocation-test'
UNION ALL SELECT id, 'Бронхопровокационная проба', 'ru' FROM medical_services WHERE slug = 'nonspecific-bronchial-provocation-test';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Репозиция парафимоза', 'ru' FROM medical_services WHERE slug = 'paraphimosis-reduction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Плевральная пункция с промыванием', 'ru' FROM medical_services WHERE slug = 'pleural-puncture-with-lavage';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Fever Therapy', 'en' FROM medical_services WHERE slug = 'pyrotherapy'
UNION ALL SELECT id, 'Пирогенная терапия', 'ru' FROM medical_services WHERE slug = 'pyrotherapy'
UNION ALL SELECT id, 'Fiebertherapie', 'de' FROM medical_services WHERE slug = 'pyrotherapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Rektoskopija sa biopsijom', 'sr' FROM medical_services WHERE slug = 'rectoscopy-with-biopsy'
UNION ALL SELECT id, 'Ректоскопија са биопсијом', 'sr-cyrl' FROM medical_services WHERE slug = 'rectoscopy-with-biopsy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Реовазография конечностей', 'ru' FROM medical_services WHERE slug = 'rheography-of-upper-or-lower-extremities';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'ВХО раны', 'ru' FROM medical_services WHERE slug = 'secondary-wound-care'
UNION ALL SELECT id, 'Вторичная хирургическая обработка раны', 'ru' FROM medical_services WHERE slug = 'secondary-wound-care';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Удаление новообразования кожи с пластикой', 'ru' FROM medical_services WHERE slug = 'skin-tumor-excision-with-reconstruction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Sternal Bone Marrow Aspiration', 'en' FROM medical_services WHERE slug = 'sternal-puncture'
UNION ALL SELECT id, 'Punkcija koštane srži iz grudne kosti', 'sr' FROM medical_services WHERE slug = 'sternal-puncture'
UNION ALL SELECT id, 'Пункција коштане сржи из грудне кости', 'sr-cyrl' FROM medical_services WHERE slug = 'sternal-puncture'
UNION ALL SELECT id, 'Пункция костного мозга из грудины', 'ru' FROM medical_services WHERE slug = 'sternal-puncture'
UNION ALL SELECT id, 'Knochenmarkpunktion am Brustbein', 'de' FROM medical_services WHERE slug = 'sternal-puncture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Флеботонометрия', 'ru' FROM medical_services WHERE slug = 'superficial-vein-pressure-measurement';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Тепловизионная диагностика', 'ru' FROM medical_services WHERE slug = 'thermography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Topical Anesthesia', 'en' FROM medical_services WHERE slug = 'topical-local-anesthesia'
UNION ALL SELECT id, 'Površinska anestezija', 'sr' FROM medical_services WHERE slug = 'topical-local-anesthesia'
UNION ALL SELECT id, 'Површинска анестезија', 'sr-cyrl' FROM medical_services WHERE slug = 'topical-local-anesthesia'
UNION ALL SELECT id, 'Topikalna anestezija', 'sr' FROM medical_services WHERE slug = 'topical-local-anesthesia'
UNION ALL SELECT id, 'Топикална анестезија', 'sr-cyrl' FROM medical_services WHERE slug = 'topical-local-anesthesia'
UNION ALL SELECT id, 'Поверхностная анестезия', 'ru' FROM medical_services WHERE slug = 'topical-local-anesthesia'
UNION ALL SELECT id, 'Аппликационная анестезия', 'ru' FROM medical_services WHERE slug = 'topical-local-anesthesia'
UNION ALL SELECT id, 'Topikal anestezi', 'tr' FROM medical_services WHERE slug = 'topical-local-anesthesia';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hranjenje preko sonde', 'sr' FROM medical_services WHERE slug = 'tube-feeding-per-meal'
UNION ALL SELECT id, 'Храњење преко сонде', 'sr-cyrl' FROM medical_services WHERE slug = 'tube-feeding-per-meal'
UNION ALL SELECT id, 'Кормление через зонд', 'ru' FROM medical_services WHERE slug = 'tube-feeding-per-meal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Foley Catheter Insertion', 'en' FROM medical_services WHERE slug = 'urinary-catheter-placement'
UNION ALL SELECT id, 'Postavljanje urinarnog katetera', 'sr' FROM medical_services WHERE slug = 'urinary-catheter-placement'
UNION ALL SELECT id, 'Постављање уринарног катетера', 'sr-cyrl' FROM medical_services WHERE slug = 'urinary-catheter-placement'
UNION ALL SELECT id, 'Постановка мочевого катетера', 'ru' FROM medical_services WHERE slug = 'urinary-catheter-placement'
UNION ALL SELECT id, 'Установка катетера Фолея', 'ru' FROM medical_services WHERE slug = 'urinary-catheter-placement';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Aesthetic Medicine Consultation', 'en' FROM medical_services WHERE slug = 'aesthetic-consultation'
UNION ALL SELECT id, 'Консультация по эстетической медицине', 'ru' FROM medical_services WHERE slug = 'aesthetic-consultation'
UNION ALL SELECT id, 'Консультация врача-косметолога', 'ru' FROM medical_services WHERE slug = 'aesthetic-consultation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Первичный приём нейрохирурга', 'ru' FROM medical_services WHERE slug = 'first-neurosurgeon-examination'
UNION ALL SELECT id, 'Первичная консультация нейрохирурга', 'ru' FROM medical_services WHERE slug = 'first-neurosurgeon-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Повторный приём пластического хирурга', 'ru' FROM medical_services WHERE slug = 'plastic-surgeon-follow-up-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Surgeon Consultation', 'en' FROM medical_services WHERE slug = 'surgical-examination'
UNION ALL SELECT id, 'Pregled hirurga', 'sr' FROM medical_services WHERE slug = 'surgical-examination'
UNION ALL SELECT id, 'Преглед хирурга', 'sr-cyrl' FROM medical_services WHERE slug = 'surgical-examination'
UNION ALL SELECT id, 'Осмотр хирурга', 'ru' FROM medical_services WHERE slug = 'surgical-examination'
UNION ALL SELECT id, 'Приём хирурга', 'ru' FROM medical_services WHERE slug = 'surgical-examination'
UNION ALL SELECT id, 'Консультация хирурга', 'ru' FROM medical_services WHERE slug = 'surgical-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lower GI Series', 'en' FROM medical_services WHERE slug = 'barium-enema'
UNION ALL SELECT id, 'Ирригоскопия кишечника', 'ru' FROM medical_services WHERE slug = 'barium-enema'
UNION ALL SELECT id, 'Рентген толстой кишки с барием', 'ru' FROM medical_services WHERE slug = 'barium-enema'
UNION ALL SELECT id, 'Irrigographie', 'de' FROM medical_services WHERE slug = 'barium-enema'
UNION ALL SELECT id, 'Baryumlu kolon grafisi', 'tr' FROM medical_services WHERE slug = 'barium-enema';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lateral Cephalogram', 'en' FROM medical_services WHERE slug = 'cephalometric-x-ray'
UNION ALL SELECT id, 'Telerendgenski snimak glave', 'sr' FROM medical_services WHERE slug = 'cephalometric-x-ray'
UNION ALL SELECT id, 'Телерендгенски снимак главе', 'sr-cyrl' FROM medical_services WHERE slug = 'cephalometric-x-ray'
UNION ALL SELECT id, 'ТРГ', 'ru' FROM medical_services WHERE slug = 'cephalometric-x-ray'
UNION ALL SELECT id, 'Телерентгенография', 'ru' FROM medical_services WHERE slug = 'cephalometric-x-ray'
UNION ALL SELECT id, 'Fernröntgenseitenbild', 'de' FROM medical_services WHERE slug = 'cephalometric-x-ray'
UNION ALL SELECT id, 'Sefalometrik film', 'tr' FROM medical_services WHERE slug = 'cephalometric-x-ray';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Radioskopija želuca', 'sr' FROM medical_services WHERE slug = 'esophagus-stomach-and-duodenum-fluoroscopy'
UNION ALL SELECT id, 'Радиоскопија желуца', 'sr-cyrl' FROM medical_services WHERE slug = 'esophagus-stomach-and-duodenum-fluoroscopy'
UNION ALL SELECT id, 'Рентгеноскопия желудка', 'ru' FROM medical_services WHERE slug = 'esophagus-stomach-and-duodenum-fluoroscopy'
UNION ALL SELECT id, 'ÖMD grafisi', 'tr' FROM medical_services WHERE slug = 'esophagus-stomach-and-duodenum-fluoroscopy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'HSG', 'en' FROM medical_services WHERE slug = 'hysterosalpingography'
UNION ALL SELECT id, 'ГСГ', 'ru' FROM medical_services WHERE slug = 'hysterosalpingography'
UNION ALL SELECT id, 'Метросальпингография', 'ru' FROM medical_services WHERE slug = 'hysterosalpingography'
UNION ALL SELECT id, 'Rahim filmi', 'tr' FROM medical_services WHERE slug = 'hysterosalpingography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'IVP', 'en' FROM medical_services WHERE slug = 'intravenous-urography'
UNION ALL SELECT id, 'Excretory Urography', 'en' FROM medical_services WHERE slug = 'intravenous-urography'
UNION ALL SELECT id, 'Intravenozna urografija', 'sr' FROM medical_services WHERE slug = 'intravenous-urography'
UNION ALL SELECT id, 'Интравенозна урографија', 'sr-cyrl' FROM medical_services WHERE slug = 'intravenous-urography'
UNION ALL SELECT id, 'Экскреторная урография', 'ru' FROM medical_services WHERE slug = 'intravenous-urography'
UNION ALL SELECT id, 'Ausscheidungsurographie', 'de' FROM medical_services WHERE slug = 'intravenous-urography'
UNION ALL SELECT id, 'İntravenöz piyelografi', 'tr' FROM medical_services WHERE slug = 'intravenous-urography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'ФЛГ', 'ru' FROM medical_services WHERE slug = 'lung-fluorography'
UNION ALL SELECT id, 'Флюорография грудной клетки', 'ru' FROM medical_services WHERE slug = 'lung-fluorography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Mammogram', 'en' FROM medical_services WHERE slug = 'mammography'
UNION ALL SELECT id, 'Рентген молочных желёз', 'ru' FROM medical_services WHERE slug = 'mammography'
UNION ALL SELECT id, 'Маммограмма', 'ru' FROM medical_services WHERE slug = 'mammography'
UNION ALL SELECT id, 'Mammografie', 'de' FROM medical_services WHERE slug = 'mammography'
UNION ALL SELECT id, 'Meme röntgeni', 'tr' FROM medical_services WHERE slug = 'mammography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Склерозирование кисты почки', 'ru' FROM medical_services WHERE slug = 'percutaneous-renal-cyst-sclerotherapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Neck Vessel Doppler Ultrasound', 'en' FROM medical_services WHERE slug = 'doppler-neck-blood-vessels'
UNION ALL SELECT id, 'Doppler krvnih sudova vrata', 'sr' FROM medical_services WHERE slug = 'doppler-neck-blood-vessels'
UNION ALL SELECT id, 'Допплер крвних судова врата', 'sr-cyrl' FROM medical_services WHERE slug = 'doppler-neck-blood-vessels'
UNION ALL SELECT id, 'Ultrazvuk krvnih sudova vrata', 'sr' FROM medical_services WHERE slug = 'doppler-neck-blood-vessels'
UNION ALL SELECT id, 'Ултразвук крвних судова врата', 'sr-cyrl' FROM medical_services WHERE slug = 'doppler-neck-blood-vessels'
UNION ALL SELECT id, 'УЗДГ сосудов шеи', 'ru' FROM medical_services WHERE slug = 'doppler-neck-blood-vessels'
UNION ALL SELECT id, 'Дуплексное сканирование сосудов шеи', 'ru' FROM medical_services WHERE slug = 'doppler-neck-blood-vessels'
UNION ALL SELECT id, 'УЗИ сосудов шеи', 'ru' FROM medical_services WHERE slug = 'doppler-neck-blood-vessels'
UNION ALL SELECT id, 'УЗДГ БЦА', 'ru' FROM medical_services WHERE slug = 'doppler-neck-blood-vessels'
UNION ALL SELECT id, 'Boyun Damar Doppler USG', 'tr' FROM medical_services WHERE slug = 'doppler-neck-blood-vessels';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'EEG', 'en' FROM medical_services WHERE slug = 'electroencephalography'
UNION ALL SELECT id, 'ЭЭГ головного мозга', 'ru' FROM medical_services WHERE slug = 'electroencephalography'
UNION ALL SELECT id, 'Энцефалограмма', 'ru' FROM medical_services WHERE slug = 'electroencephalography'
UNION ALL SELECT id, 'Hirnstrommessung', 'de' FROM medical_services WHERE slug = 'electroencephalography'
UNION ALL SELECT id, 'Beyin elektrosu', 'tr' FROM medical_services WHERE slug = 'electroencephalography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Initial Neurology Consultation', 'en' FROM medical_services WHERE slug = 'first-neurologist-examination'
UNION ALL SELECT id, 'Первичный приём невролога', 'ru' FROM medical_services WHERE slug = 'first-neurologist-examination'
UNION ALL SELECT id, 'Первичная консультация невролога', 'ru' FROM medical_services WHERE slug = 'first-neurologist-examination'
UNION ALL SELECT id, 'Приём невропатолога', 'ru' FROM medical_services WHERE slug = 'first-neurologist-examination'
UNION ALL SELECT id, 'Erstuntersuchung beim Neurologen', 'de' FROM medical_services WHERE slug = 'first-neurologist-examination'
UNION ALL SELECT id, 'İlk nöroloji muayenesi', 'tr' FROM medical_services WHERE slug = 'first-neurologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Spinal Tap', 'en' FROM medical_services WHERE slug = 'lumbar-puncture'
UNION ALL SELECT id, 'Спинномозговая пункция', 'ru' FROM medical_services WHERE slug = 'lumbar-puncture'
UNION ALL SELECT id, 'Поясничная пункция', 'ru' FROM medical_services WHERE slug = 'lumbar-puncture'
UNION ALL SELECT id, 'Liquorpunktion', 'de' FROM medical_services WHERE slug = 'lumbar-puncture'
UNION ALL SELECT id, 'Belden su alma', 'tr' FROM medical_services WHERE slug = 'lumbar-puncture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Folstein Test', 'en' FROM medical_services WHERE slug = 'mini-mental-state-examination-mmse';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Repetitive Nerve Stimulation', 'en' FROM medical_services WHERE slug = 'neuromuscular-transmission-test'
UNION ALL SELECT id, 'TNT test', 'sr' FROM medical_services WHERE slug = 'neuromuscular-transmission-test'
UNION ALL SELECT id, 'ТНТ тест', 'sr-cyrl' FROM medical_services WHERE slug = 'neuromuscular-transmission-test'
UNION ALL SELECT id, 'Декремент-тест', 'ru' FROM medical_services WHERE slug = 'neuromuscular-transmission-test';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Neostigmine Test', 'en' FROM medical_services WHERE slug = 'prostigmin-test'
UNION ALL SELECT id, 'Прозериновый тест', 'ru' FROM medical_services WHERE slug = 'prostigmin-test';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG ždrijela i grkljana', 'sr' FROM medical_services WHERE slug = 'pharynx-and-larynx-x-ray'
UNION ALL SELECT id, 'RTG ждријела и гркљана', 'sr-cyrl' FROM medical_services WHERE slug = 'pharynx-and-larynx-x-ray'
UNION ALL SELECT id, 'Rendgen grla', 'sr' FROM medical_services WHERE slug = 'pharynx-and-larynx-x-ray'
UNION ALL SELECT id, 'Рендген грла', 'sr-cyrl' FROM medical_services WHERE slug = 'pharynx-and-larynx-x-ray'
UNION ALL SELECT id, 'Рентген гортани', 'ru' FROM medical_services WHERE slug = 'pharynx-and-larynx-x-ray'
UNION ALL SELECT id, 'Рентген горла', 'ru' FROM medical_services WHERE slug = 'pharynx-and-larynx-x-ray';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Retrograde Pyelography', 'en' FROM medical_services WHERE slug = 'retrograde-urography'
UNION ALL SELECT id, 'Retrogradna pijelografija', 'sr' FROM medical_services WHERE slug = 'retrograde-urography'
UNION ALL SELECT id, 'Ретроградна пијелографија', 'sr-cyrl' FROM medical_services WHERE slug = 'retrograde-urography'
UNION ALL SELECT id, 'Ретроградная пиелография', 'ru' FROM medical_services WHERE slug = 'retrograde-urography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG mekih tkiva vrata', 'sr' FROM medical_services WHERE slug = 'soft-tissue-neck-x-ray'
UNION ALL SELECT id, 'RTG меких ткива врата', 'sr-cyrl' FROM medical_services WHERE slug = 'soft-tissue-neck-x-ray'
UNION ALL SELECT id, 'Рентген мягких тканей шеи', 'ru' FROM medical_services WHERE slug = 'soft-tissue-neck-x-ray'
UNION ALL SELECT id, 'Röntgen Halsweichteile', 'de' FROM medical_services WHERE slug = 'soft-tissue-neck-x-ray';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cystography', 'en' FROM medical_services WHERE slug = 'standard-cystourethrography'
UNION ALL SELECT id, 'Цистография', 'ru' FROM medical_services WHERE slug = 'standard-cystourethrography'
UNION ALL SELECT id, 'Уретроцистография', 'ru' FROM medical_services WHERE slug = 'standard-cystourethrography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'TMJ Arthrography', 'en' FROM medical_services WHERE slug = 'temporomandibular-joint-arthrography'
UNION ALL SELECT id, 'Artrografija viličnog zgloba', 'sr' FROM medical_services WHERE slug = 'temporomandibular-joint-arthrography'
UNION ALL SELECT id, 'Артрографија виличног зглоба', 'sr-cyrl' FROM medical_services WHERE slug = 'temporomandibular-joint-arthrography'
UNION ALL SELECT id, 'Артрография ВНЧС', 'ru' FROM medical_services WHERE slug = 'temporomandibular-joint-arthrography'
UNION ALL SELECT id, 'TME artrografisi', 'tr' FROM medical_services WHERE slug = 'temporomandibular-joint-arthrography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'VCUG', 'en' FROM medical_services WHERE slug = 'voiding-cystourethrography'
UNION ALL SELECT id, 'Mikciona cistouretrografija', 'sr' FROM medical_services WHERE slug = 'voiding-cystourethrography'
UNION ALL SELECT id, 'Микциона цистоуретрографија', 'sr-cyrl' FROM medical_services WHERE slug = 'voiding-cystourethrography'
UNION ALL SELECT id, 'MCUG', 'sr' FROM medical_services WHERE slug = 'voiding-cystourethrography'
UNION ALL SELECT id, 'МЦУГ', 'sr-cyrl' FROM medical_services WHERE slug = 'voiding-cystourethrography'
UNION ALL SELECT id, 'Микционная цистография', 'ru' FROM medical_services WHERE slug = 'voiding-cystourethrography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ankle X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-ankle'
UNION ALL SELECT id, 'RTG skočnog zgloba', 'sr' FROM medical_services WHERE slug = 'x-ray-ankle'
UNION ALL SELECT id, 'Рентген голеностопа', 'ru' FROM medical_services WHERE slug = 'x-ray-ankle';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cervical Spine X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-cervical-spine'
UNION ALL SELECT id, 'RTG vratne kičme', 'sr' FROM medical_services WHERE slug = 'x-ray-cervical-spine'
UNION ALL SELECT id, 'RTG вратне кичме', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-cervical-spine'
UNION ALL SELECT id, 'Рентген ШОП', 'ru' FROM medical_services WHERE slug = 'x-ray-cervical-spine'
UNION ALL SELECT id, 'Röntgen HWS', 'de' FROM medical_services WHERE slug = 'x-ray-cervical-spine';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Facial Bones X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-facial-bones'
UNION ALL SELECT id, 'Rendgen kostiju lica', 'sr' FROM medical_services WHERE slug = 'x-ray-facial-bones'
UNION ALL SELECT id, 'Рендген костију лица', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-facial-bones'
UNION ALL SELECT id, 'Рентген лицевого скелета', 'ru' FROM medical_services WHERE slug = 'x-ray-facial-bones';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Abdominal MRI', 'en' FROM medical_services WHERE slug = 'mri-abdomen'
UNION ALL SELECT id, 'MR abdomena', 'sr' FROM medical_services WHERE slug = 'mri-abdomen'
UNION ALL SELECT id, 'МР абдомена', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-abdomen'
UNION ALL SELECT id, 'МРТ органов брюшной полости', 'ru' FROM medical_services WHERE slug = 'mri-abdomen'
UNION ALL SELECT id, 'Batın MR', 'tr' FROM medical_services WHERE slug = 'mri-abdomen';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'MRA Head and Neck', 'en' FROM medical_services WHERE slug = 'mri-angiography-brain-and-neck-vessels'
UNION ALL SELECT id, 'MR krvnih sudova vrata i mozga', 'sr' FROM medical_services WHERE slug = 'mri-angiography-brain-and-neck-vessels'
UNION ALL SELECT id, 'МР крвних судова врата и мозга', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-angiography-brain-and-neck-vessels'
UNION ALL SELECT id, 'МРТ сосудов головы и шеи', 'ru' FROM medical_services WHERE slug = 'mri-angiography-brain-and-neck-vessels';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Brain MRI', 'en' FROM medical_services WHERE slug = 'mri-brain'
UNION ALL SELECT id, 'Head MRI', 'en' FROM medical_services WHERE slug = 'mri-brain'
UNION ALL SELECT id, 'MR mozga', 'sr' FROM medical_services WHERE slug = 'mri-brain'
UNION ALL SELECT id, 'МР мозга', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-brain'
UNION ALL SELECT id, 'MR glave', 'sr' FROM medical_services WHERE slug = 'mri-brain'
UNION ALL SELECT id, 'МР главе', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-brain'
UNION ALL SELECT id, 'МРТ головы', 'ru' FROM medical_services WHERE slug = 'mri-brain'
UNION ALL SELECT id, 'МРТ мозга', 'ru' FROM medical_services WHERE slug = 'mri-brain'
UNION ALL SELECT id, 'MRT Kopf', 'de' FROM medical_services WHERE slug = 'mri-brain'
UNION ALL SELECT id, 'Kranial MR', 'tr' FROM medical_services WHERE slug = 'mri-brain';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Breast MRI', 'en' FROM medical_services WHERE slug = 'mri-breast'
UNION ALL SELECT id, 'MR dojke', 'sr' FROM medical_services WHERE slug = 'mri-breast'
UNION ALL SELECT id, 'МР дојке', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-breast'
UNION ALL SELECT id, 'MR grudi', 'sr' FROM medical_services WHERE slug = 'mri-breast'
UNION ALL SELECT id, 'МР груди', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-breast'
UNION ALL SELECT id, 'МРТ молочных желёз', 'ru' FROM medical_services WHERE slug = 'mri-breast'
UNION ALL SELECT id, 'МРТ груди', 'ru' FROM medical_services WHERE slug = 'mri-breast'
UNION ALL SELECT id, 'Mamma-MRT', 'de' FROM medical_services WHERE slug = 'mri-breast';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'MR vratne kičme', 'sr' FROM medical_services WHERE slug = 'mri-cervical-spine'
UNION ALL SELECT id, 'МР вратне кичме', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-cervical-spine'
UNION ALL SELECT id, 'МРТ ШОП', 'ru' FROM medical_services WHERE slug = 'mri-cervical-spine'
UNION ALL SELECT id, 'MRT HWS', 'de' FROM medical_services WHERE slug = 'mri-cervical-spine'
UNION ALL SELECT id, 'Servikal MR', 'tr' FROM medical_services WHERE slug = 'mri-cervical-spine';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Magnetic Resonance Cholangiopancreatography', 'en' FROM medical_services WHERE slug = 'mri-cholangiography-mrcp'
UNION ALL SELECT id, 'MR holangiopankreatografija', 'sr' FROM medical_services WHERE slug = 'mri-cholangiography-mrcp'
UNION ALL SELECT id, 'МР холангиопанкреатографија', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-cholangiography-mrcp'
UNION ALL SELECT id, 'МР-холангиопанкреатография', 'ru' FROM medical_services WHERE slug = 'mri-cholangiography-mrcp';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hip MRI', 'en' FROM medical_services WHERE slug = 'mri-hip-joints-in-pelvis'
UNION ALL SELECT id, 'MR kukova', 'sr' FROM medical_services WHERE slug = 'mri-hip-joints-in-pelvis'
UNION ALL SELECT id, 'МР кукова', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-hip-joints-in-pelvis'
UNION ALL SELECT id, 'MR karlice sa kukovima', 'sr' FROM medical_services WHERE slug = 'mri-hip-joints-in-pelvis'
UNION ALL SELECT id, 'МР карлице са куковима', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-hip-joints-in-pelvis'
UNION ALL SELECT id, 'МРТ тазобедренного сустава', 'ru' FROM medical_services WHERE slug = 'mri-hip-joints-in-pelvis'
UNION ALL SELECT id, 'МРТ ТБС', 'ru' FROM medical_services WHERE slug = 'mri-hip-joints-in-pelvis'
UNION ALL SELECT id, 'MRT Hüfte', 'de' FROM medical_services WHERE slug = 'mri-hip-joints-in-pelvis'
UNION ALL SELECT id, 'Kalça MR', 'tr' FROM medical_services WHERE slug = 'mri-hip-joints-in-pelvis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'MR lumbosakralne kičme', 'sr' FROM medical_services WHERE slug = 'mri-lumbosacral-spine'
UNION ALL SELECT id, 'МР лумбосакралне кичме', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-lumbosacral-spine'
UNION ALL SELECT id, 'MR lumbalne kičme', 'sr' FROM medical_services WHERE slug = 'mri-lumbosacral-spine'
UNION ALL SELECT id, 'МР лумбалне кичме', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-lumbosacral-spine'
UNION ALL SELECT id, 'МРТ поясничного отдела позвоночника', 'ru' FROM medical_services WHERE slug = 'mri-lumbosacral-spine'
UNION ALL SELECT id, 'МРТ ПКОП', 'ru' FROM medical_services WHERE slug = 'mri-lumbosacral-spine'
UNION ALL SELECT id, 'MRT LWS', 'de' FROM medical_services WHERE slug = 'mri-lumbosacral-spine'
UNION ALL SELECT id, 'Lomber MR', 'tr' FROM medical_services WHERE slug = 'mri-lumbosacral-spine';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Musculoskeletal MRI', 'en' FROM medical_services WHERE slug = 'mri-musculoskeletal-system'
UNION ALL SELECT id, 'MR osteomuskularnog sistema', 'sr' FROM medical_services WHERE slug = 'mri-musculoskeletal-system'
UNION ALL SELECT id, 'МР остеомускуларног система', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-musculoskeletal-system'
UNION ALL SELECT id, 'МРТ опорно-двигательного аппарата', 'ru' FROM medical_services WHERE slug = 'mri-musculoskeletal-system';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pituitary MRI', 'en' FROM medical_services WHERE slug = 'mri-pituitary-gland-sella-turcica'
UNION ALL SELECT id, 'MR turskog sedla', 'sr' FROM medical_services WHERE slug = 'mri-pituitary-gland-sella-turcica'
UNION ALL SELECT id, 'МР турског седла', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-pituitary-gland-sella-turcica'
UNION ALL SELECT id, 'МРТ турецкого седла', 'ru' FROM medical_services WHERE slug = 'mri-pituitary-gland-sella-turcica';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Prostate MRI', 'en' FROM medical_services WHERE slug = 'mri-prostate-multiparametric'
UNION ALL SELECT id, 'MR prostate', 'sr' FROM medical_services WHERE slug = 'mri-prostate-multiparametric'
UNION ALL SELECT id, 'МР простате', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-prostate-multiparametric'
UNION ALL SELECT id, 'МРТ предстательной железы', 'ru' FROM medical_services WHERE slug = 'mri-prostate-multiparametric'
UNION ALL SELECT id, 'мпМРТ простаты', 'ru' FROM medical_services WHERE slug = 'mri-prostate-multiparametric';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'MR vrata', 'sr' FROM medical_services WHERE slug = 'mri-soft-tissue-neck'
UNION ALL SELECT id, 'МР врата', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-soft-tissue-neck'
UNION ALL SELECT id, 'МРТ шеи', 'ru' FROM medical_services WHERE slug = 'mri-soft-tissue-neck'
UNION ALL SELECT id, 'Boyun MR', 'tr' FROM medical_services WHERE slug = 'mri-soft-tissue-neck';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'MR torakalne kičme', 'sr' FROM medical_services WHERE slug = 'mri-thoracic-spine'
UNION ALL SELECT id, 'МР торакалне кичме', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-thoracic-spine'
UNION ALL SELECT id, 'MR grudne kičme', 'sr' FROM medical_services WHERE slug = 'mri-thoracic-spine'
UNION ALL SELECT id, 'МР грудне кичме', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-thoracic-spine'
UNION ALL SELECT id, 'МРТ ГОП', 'ru' FROM medical_services WHERE slug = 'mri-thoracic-spine'
UNION ALL SELECT id, 'MRT BWS', 'de' FROM medical_services WHERE slug = 'mri-thoracic-spine'
UNION ALL SELECT id, 'Torakal MR', 'tr' FROM medical_services WHERE slug = 'mri-thoracic-spine';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Foot X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-foot'
UNION ALL SELECT id, 'RTG stopala', 'sr' FROM medical_services WHERE slug = 'x-ray-foot'
UNION ALL SELECT id, 'Рентгенография стопы', 'ru' FROM medical_services WHERE slug = 'x-ray-foot'
UNION ALL SELECT id, 'Рентген ступни', 'ru' FROM medical_services WHERE slug = 'x-ray-foot'
UNION ALL SELECT id, 'Ayak grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-foot';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Skull X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-head-craniogram'
UNION ALL SELECT id, 'RTG glave', 'sr' FROM medical_services WHERE slug = 'x-ray-head-craniogram'
UNION ALL SELECT id, 'RTG главе', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-head-craniogram'
UNION ALL SELECT id, 'RTG lobanje', 'sr' FROM medical_services WHERE slug = 'x-ray-head-craniogram'
UNION ALL SELECT id, 'RTG лобање', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-head-craniogram'
UNION ALL SELECT id, 'Рентген черепа', 'ru' FROM medical_services WHERE slug = 'x-ray-head-craniogram'
UNION ALL SELECT id, 'Краниография', 'ru' FROM medical_services WHERE slug = 'x-ray-head-craniogram'
UNION ALL SELECT id, 'Schädelröntgen', 'de' FROM medical_services WHERE slug = 'x-ray-head-craniogram'
UNION ALL SELECT id, 'Kafa grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-head-craniogram';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hip X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-hip'
UNION ALL SELECT id, 'RTG kuka', 'sr' FROM medical_services WHERE slug = 'x-ray-hip'
UNION ALL SELECT id, 'Рентгенография тазобедренного сустава', 'ru' FROM medical_services WHERE slug = 'x-ray-hip'
UNION ALL SELECT id, 'Рентген ТБС', 'ru' FROM medical_services WHERE slug = 'x-ray-hip'
UNION ALL SELECT id, 'Kalça grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-hip';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Knee X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-knee'
UNION ALL SELECT id, 'RTG koljena', 'sr' FROM medical_services WHERE slug = 'x-ray-knee'
UNION ALL SELECT id, 'Rendgen kolena', 'sr' FROM medical_services WHERE slug = 'x-ray-knee'
UNION ALL SELECT id, 'Рендген колена', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-knee'
UNION ALL SELECT id, 'Рентген колена', 'ru' FROM medical_services WHERE slug = 'x-ray-knee'
UNION ALL SELECT id, 'Рентгенография коленного сустава', 'ru' FROM medical_services WHERE slug = 'x-ray-knee'
UNION ALL SELECT id, 'Diz grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-knee';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lower Leg X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-lower-leg'
UNION ALL SELECT id, 'Tibia and Fibula X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-lower-leg'
UNION ALL SELECT id, 'RTG potkoljenice', 'sr' FROM medical_services WHERE slug = 'x-ray-lower-leg'
UNION ALL SELECT id, 'Rendgen potkolenice', 'sr' FROM medical_services WHERE slug = 'x-ray-lower-leg'
UNION ALL SELECT id, 'Рендген потколенице', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-lower-leg'
UNION ALL SELECT id, 'Рентгенография голени', 'ru' FROM medical_services WHERE slug = 'x-ray-lower-leg'
UNION ALL SELECT id, 'Рентген костей голени', 'ru' FROM medical_services WHERE slug = 'x-ray-lower-leg'
UNION ALL SELECT id, 'Tibia fibula grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-lower-leg';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lumbar Spine X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-lumbar-spine-and-sacrum'
UNION ALL SELECT id, 'Lumbosacral Spine X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-lumbar-spine-and-sacrum'
UNION ALL SELECT id, 'RTG LS kičme', 'sr' FROM medical_services WHERE slug = 'x-ray-lumbar-spine-and-sacrum'
UNION ALL SELECT id, 'RTG ЛС кичме', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-lumbar-spine-and-sacrum'
UNION ALL SELECT id, 'RTG lumbalne kičme', 'sr' FROM medical_services WHERE slug = 'x-ray-lumbar-spine-and-sacrum'
UNION ALL SELECT id, 'RTG лумбалне кичме', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-lumbar-spine-and-sacrum'
UNION ALL SELECT id, 'Рентген пояснично-крестцового отдела позвоночника', 'ru' FROM medical_services WHERE slug = 'x-ray-lumbar-spine-and-sacrum'
UNION ALL SELECT id, 'Рентген поясницы', 'ru' FROM medical_services WHERE slug = 'x-ray-lumbar-spine-and-sacrum'
UNION ALL SELECT id, 'Röntgen LWS', 'de' FROM medical_services WHERE slug = 'x-ray-lumbar-spine-and-sacrum'
UNION ALL SELECT id, 'Lumbosakral grafi', 'tr' FROM medical_services WHERE slug = 'x-ray-lumbar-spine-and-sacrum';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Sinus X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-paranasal-sinuses'
UNION ALL SELECT id, 'Рентген пазух носа', 'ru' FROM medical_services WHERE slug = 'x-ray-paranasal-sinuses'
UNION ALL SELECT id, 'Рентгенография околоносовых пазух', 'ru' FROM medical_services WHERE slug = 'x-ray-paranasal-sinuses'
UNION ALL SELECT id, 'NNH-Röntgen', 'de' FROM medical_services WHERE slug = 'x-ray-paranasal-sinuses'
UNION ALL SELECT id, 'Sinüs grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-paranasal-sinuses';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pelvic X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-pelvis'
UNION ALL SELECT id, 'Рентген костей таза', 'ru' FROM medical_services WHERE slug = 'x-ray-pelvis'
UNION ALL SELECT id, 'Рентгенография таза', 'ru' FROM medical_services WHERE slug = 'x-ray-pelvis'
UNION ALL SELECT id, 'Beckenübersichtsaufnahme', 'de' FROM medical_services WHERE slug = 'x-ray-pelvis'
UNION ALL SELECT id, 'Pelvis grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-pelvis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Sternum X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-sternum'
UNION ALL SELECT id, 'RTG sternuma', 'sr' FROM medical_services WHERE slug = 'x-ray-sternum'
UNION ALL SELECT id, 'RTG стернума', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-sternum'
UNION ALL SELECT id, 'Рентгенография грудины', 'ru' FROM medical_services WHERE slug = 'x-ray-sternum'
UNION ALL SELECT id, 'Sternum grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-sternum';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Thoracic Spine X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-thoracic-spine'
UNION ALL SELECT id, 'RTG torakalne kičme', 'sr' FROM medical_services WHERE slug = 'x-ray-thoracic-spine'
UNION ALL SELECT id, 'RTG торакалне кичме', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-thoracic-spine'
UNION ALL SELECT id, 'Рентгенография грудного отдела позвоночника', 'ru' FROM medical_services WHERE slug = 'x-ray-thoracic-spine'
UNION ALL SELECT id, 'Röntgen BWS', 'de' FROM medical_services WHERE slug = 'x-ray-thoracic-spine'
UNION ALL SELECT id, 'Torakal omurga grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-thoracic-spine';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Upper Arm X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-upper-arm'
UNION ALL SELECT id, 'Humerus X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-upper-arm'
UNION ALL SELECT id, 'RTG nadlaktice', 'sr' FROM medical_services WHERE slug = 'x-ray-upper-arm'
UNION ALL SELECT id, 'Рентгенография плечевой кости', 'ru' FROM medical_services WHERE slug = 'x-ray-upper-arm'
UNION ALL SELECT id, 'Humerus grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-upper-arm';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Wrist X-Ray', 'en' FROM medical_services WHERE slug = 'x-ray-wrist'
UNION ALL SELECT id, 'RTG ručnog zgloba', 'sr' FROM medical_services WHERE slug = 'x-ray-wrist'
UNION ALL SELECT id, 'Рентген запястья', 'ru' FROM medical_services WHERE slug = 'x-ray-wrist'
UNION ALL SELECT id, 'Рентгенография лучезапястного сустава', 'ru' FROM medical_services WHERE slug = 'x-ray-wrist'
UNION ALL SELECT id, 'El bileği grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-wrist';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Penile Implant Surgery', 'en' FROM medical_services WHERE slug = 'penile-prosthesis-implantation'
UNION ALL SELECT id, 'Ugradnja proteze penisa', 'sr' FROM medical_services WHERE slug = 'penile-prosthesis-implantation'
UNION ALL SELECT id, 'Уградња протезе пениса', 'sr-cyrl' FROM medical_services WHERE slug = 'penile-prosthesis-implantation'
UNION ALL SELECT id, 'Фаллопротезирование', 'ru' FROM medical_services WHERE slug = 'penile-prosthesis-implantation'
UNION ALL SELECT id, 'Протезирование полового члена', 'ru' FROM medical_services WHERE slug = 'penile-prosthesis-implantation'
UNION ALL SELECT id, 'Penisimplantat', 'de' FROM medical_services WHERE slug = 'penile-prosthesis-implantation'
UNION ALL SELECT id, 'Penis protezi ameliyatı', 'tr' FROM medical_services WHERE slug = 'penile-prosthesis-implantation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Urologist Consultation', 'en' FROM medical_services WHERE slug = 'urologist-examination'
UNION ALL SELECT id, 'Urološki pregled', 'sr' FROM medical_services WHERE slug = 'urologist-examination'
UNION ALL SELECT id, 'Уролошки преглед', 'sr-cyrl' FROM medical_services WHERE slug = 'urologist-examination'
UNION ALL SELECT id, 'Приём уролога', 'ru' FROM medical_services WHERE slug = 'urologist-examination'
UNION ALL SELECT id, 'Консультация уролога', 'ru' FROM medical_services WHERE slug = 'urologist-examination'
UNION ALL SELECT id, 'Ürolog muayenesi', 'tr' FROM medical_services WHERE slug = 'urologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pregled urologa sa UZ', 'sr' FROM medical_services WHERE slug = 'urologist-examination-with-ultrasound'
UNION ALL SELECT id, 'Преглед уролога са УЗ', 'sr-cyrl' FROM medical_services WHERE slug = 'urologist-examination-with-ultrasound'
UNION ALL SELECT id, 'Приём уролога с УЗИ', 'ru' FROM medical_services WHERE slug = 'urologist-examination-with-ultrasound'
UNION ALL SELECT id, 'Консультация уролога с УЗИ', 'ru' FROM medical_services WHERE slug = 'urologist-examination-with-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Adenoid Removal', 'en' FROM medical_services WHERE slug = 'adenotomy'
UNION ALL SELECT id, 'Vađenje trećeg krajnika', 'sr' FROM medical_services WHERE slug = 'adenotomy'
UNION ALL SELECT id, 'Вађење трећег крајника', 'sr-cyrl' FROM medical_services WHERE slug = 'adenotomy'
UNION ALL SELECT id, 'Uklanjanje adenoida', 'sr' FROM medical_services WHERE slug = 'adenotomy'
UNION ALL SELECT id, 'Уклањање аденоида', 'sr-cyrl' FROM medical_services WHERE slug = 'adenotomy'
UNION ALL SELECT id, 'Удаление аденоидов', 'ru' FROM medical_services WHERE slug = 'adenotomy'
UNION ALL SELECT id, 'Entfernung der Rachenmandel', 'de' FROM medical_services WHERE slug = 'adenotomy'
UNION ALL SELECT id, 'Geniz eti ameliyatı', 'tr' FROM medical_services WHERE slug = 'adenotomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hearing Test', 'en' FROM medical_services WHERE slug = 'audiometry'
UNION ALL SELECT id, 'Ispitivanje sluha', 'sr' FROM medical_services WHERE slug = 'audiometry'
UNION ALL SELECT id, 'Испитивање слуха', 'sr-cyrl' FROM medical_services WHERE slug = 'audiometry'
UNION ALL SELECT id, 'Test sluha', 'sr' FROM medical_services WHERE slug = 'audiometry'
UNION ALL SELECT id, 'Тест слуха', 'sr-cyrl' FROM medical_services WHERE slug = 'audiometry'
UNION ALL SELECT id, 'Проверка слуха', 'ru' FROM medical_services WHERE slug = 'audiometry'
UNION ALL SELECT id, 'Тональная аудиометрия', 'ru' FROM medical_services WHERE slug = 'audiometry'
UNION ALL SELECT id, 'Hörtest', 'de' FROM medical_services WHERE slug = 'audiometry'
UNION ALL SELECT id, 'İşitme testi', 'tr' FROM medical_services WHERE slug = 'audiometry';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ispiranje ušiju', 'sr' FROM medical_services WHERE slug = 'ear-irrigation'
UNION ALL SELECT id, 'Испирање ушију', 'sr-cyrl' FROM medical_services WHERE slug = 'ear-irrigation'
UNION ALL SELECT id, 'Промывание ушей', 'ru' FROM medical_services WHERE slug = 'ear-irrigation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Otolaryngologist Examination', 'en' FROM medical_services WHERE slug = 'ent-specialist-examination'
UNION ALL SELECT id, 'ENT Doctor Visit', 'en' FROM medical_services WHERE slug = 'ent-specialist-examination'
UNION ALL SELECT id, 'ORL pregled', 'sr' FROM medical_services WHERE slug = 'ent-specialist-examination'
UNION ALL SELECT id, 'ОРЛ преглед', 'sr-cyrl' FROM medical_services WHERE slug = 'ent-specialist-examination'
UNION ALL SELECT id, 'Pregled otorinolaringologa', 'sr' FROM medical_services WHERE slug = 'ent-specialist-examination'
UNION ALL SELECT id, 'Преглед оториноларинголога', 'sr-cyrl' FROM medical_services WHERE slug = 'ent-specialist-examination'
UNION ALL SELECT id, 'Приём ЛОР-врача', 'ru' FROM medical_services WHERE slug = 'ent-specialist-examination'
UNION ALL SELECT id, 'Осмотр оториноларинголога', 'ru' FROM medical_services WHERE slug = 'ent-specialist-examination'
UNION ALL SELECT id, 'Hals-Nasen-Ohren-Untersuchung', 'de' FROM medical_services WHERE slug = 'ent-specialist-examination'
UNION ALL SELECT id, 'Kulak burun boğaz muayenesi', 'tr' FROM medical_services WHERE slug = 'ent-specialist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Импедансометрия', 'ru' FROM medical_services WHERE slug = 'extended-tympanometry';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Uklanjanje stranog tijela iz nosa', 'sr' FROM medical_services WHERE slug = 'foreign-body-removal-from-nose'
UNION ALL SELECT id, 'Уклањање страног тијела из носа', 'sr-cyrl' FROM medical_services WHERE slug = 'foreign-body-removal-from-nose';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Fish Bone Removal from Throat', 'en' FROM medical_services WHERE slug = 'foreign-body-removal-from-throat'
UNION ALL SELECT id, 'Uklanjanje stranog tijela iz grla', 'sr' FROM medical_services WHERE slug = 'foreign-body-removal-from-throat'
UNION ALL SELECT id, 'Уклањање страног тијела из грла', 'sr-cyrl' FROM medical_services WHERE slug = 'foreign-body-removal-from-throat'
UNION ALL SELECT id, 'Vađenje riblje kosti iz grla', 'sr' FROM medical_services WHERE slug = 'foreign-body-removal-from-throat'
UNION ALL SELECT id, 'Вађење рибље кости из грла', 'sr-cyrl' FROM medical_services WHERE slug = 'foreign-body-removal-from-throat'
UNION ALL SELECT id, 'Удаление рыбьей кости из горла', 'ru' FROM medical_services WHERE slug = 'foreign-body-removal-from-throat';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Бакпосев из носа', 'ru' FROM medical_services WHERE slug = 'nose-swab';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Auditory Brainstem Response (ABR)', 'en' FROM medical_services WHERE slug = 'objective-audiometry-bera'
UNION ALL SELECT id, 'Evocirani potencijali moždanog stabla', 'sr' FROM medical_services WHERE slug = 'objective-audiometry-bera'
UNION ALL SELECT id, 'Евоцирани потенцијали можданог стабла', 'sr-cyrl' FROM medical_services WHERE slug = 'objective-audiometry-bera'
UNION ALL SELECT id, 'КСВП', 'ru' FROM medical_services WHERE slug = 'objective-audiometry-bera'
UNION ALL SELECT id, 'Слуховые вызванные потенциалы', 'ru' FROM medical_services WHERE slug = 'objective-audiometry-bera'
UNION ALL SELECT id, 'Hirnstammaudiometrie', 'de' FROM medical_services WHERE slug = 'objective-audiometry-bera'
UNION ALL SELECT id, 'İşitsel beyin sapı cevabı', 'tr' FROM medical_services WHERE slug = 'objective-audiometry-bera';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Otoakustičke emisije', 'sr' FROM medical_services WHERE slug = 'otoacoustic-emissions-teoae'
UNION ALL SELECT id, 'Отоакустичке емисије', 'sr-cyrl' FROM medical_services WHERE slug = 'otoacoustic-emissions-teoae'
UNION ALL SELECT id, 'ОАЭ', 'ru' FROM medical_services WHERE slug = 'otoacoustic-emissions-teoae'
UNION ALL SELECT id, 'Скрининг слуха новорождённых', 'ru' FROM medical_services WHERE slug = 'otoacoustic-emissions-teoae';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Бакпосев с языка', 'ru' FROM medical_services WHERE slug = 'tongue-swab';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Tonsil Removal', 'en' FROM medical_services WHERE slug = 'tonsillectomy'
UNION ALL SELECT id, 'Vađenje krajnika', 'sr' FROM medical_services WHERE slug = 'tonsillectomy'
UNION ALL SELECT id, 'Вађење крајника', 'sr-cyrl' FROM medical_services WHERE slug = 'tonsillectomy'
UNION ALL SELECT id, 'Operacija krajnika', 'sr' FROM medical_services WHERE slug = 'tonsillectomy'
UNION ALL SELECT id, 'Операција крајника', 'sr-cyrl' FROM medical_services WHERE slug = 'tonsillectomy'
UNION ALL SELECT id, 'Удаление миндалин', 'ru' FROM medical_services WHERE slug = 'tonsillectomy'
UNION ALL SELECT id, 'Удаление гланд', 'ru' FROM medical_services WHERE slug = 'tonsillectomy'
UNION ALL SELECT id, 'Mandelentfernung', 'de' FROM medical_services WHERE slug = 'tonsillectomy'
UNION ALL SELECT id, 'Mandeloperation', 'de' FROM medical_services WHERE slug = 'tonsillectomy'
UNION ALL SELECT id, 'Bademcik ameliyatı', 'tr' FROM medical_services WHERE slug = 'tonsillectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Vestibular Function Test', 'en' FROM medical_services WHERE slug = 'vestibulometry'
UNION ALL SELECT id, 'Ispitivanje vestibularnog aparata', 'sr' FROM medical_services WHERE slug = 'vestibulometry'
UNION ALL SELECT id, 'Испитивање вестибуларног апарата', 'sr-cyrl' FROM medical_services WHERE slug = 'vestibulometry'
UNION ALL SELECT id, 'Исследование вестибулярного аппарата', 'ru' FROM medical_services WHERE slug = 'vestibulometry'
UNION ALL SELECT id, 'Gleichgewichtsprüfung', 'de' FROM medical_services WHERE slug = 'vestibulometry'
UNION ALL SELECT id, 'Denge testi', 'tr' FROM medical_services WHERE slug = 'vestibulometry';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ascitic Tap', 'en' FROM medical_services WHERE slug = 'abdominal-paracentesis'
UNION ALL SELECT id, 'Paracenteza', 'sr' FROM medical_services WHERE slug = 'abdominal-paracentesis'
UNION ALL SELECT id, 'Парацентеза', 'sr-cyrl' FROM medical_services WHERE slug = 'abdominal-paracentesis'
UNION ALL SELECT id, 'Punkcija ascitesa', 'sr' FROM medical_services WHERE slug = 'abdominal-paracentesis'
UNION ALL SELECT id, 'Пункција асцитеса', 'sr-cyrl' FROM medical_services WHERE slug = 'abdominal-paracentesis'
UNION ALL SELECT id, 'Лапароцентез', 'ru' FROM medical_services WHERE slug = 'abdominal-paracentesis'
UNION ALL SELECT id, 'Пункция асцита', 'ru' FROM medical_services WHERE slug = 'abdominal-paracentesis'
UNION ALL SELECT id, 'Aszitespunktion', 'de' FROM medical_services WHERE slug = 'abdominal-paracentesis'
UNION ALL SELECT id, 'Asit ponksiyonu', 'tr' FROM medical_services WHERE slug = 'abdominal-paracentesis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Gastroskopija i kolonoskopija pod anestezijom', 'sr' FROM medical_services WHERE slug = 'colonoscopy-and-gastroscopy-with-anesthesia'
UNION ALL SELECT id, 'Гастроскопија и колоноскопија под анестезијом', 'sr-cyrl' FROM medical_services WHERE slug = 'colonoscopy-and-gastroscopy-with-anesthesia'
UNION ALL SELECT id, 'ФГДС и колоноскопия под наркозом', 'ru' FROM medical_services WHERE slug = 'colonoscopy-and-gastroscopy-with-anesthesia'
UNION ALL SELECT id, 'Magen- und Darmspiegelung in Narkose', 'de' FROM medical_services WHERE slug = 'colonoscopy-and-gastroscopy-with-anesthesia'
UNION ALL SELECT id, 'Sedasyonlu gastroskopi ve kolonoskopi', 'tr' FROM medical_services WHERE slug = 'colonoscopy-and-gastroscopy-with-anesthesia';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Colonoscopy under Sedation', 'en' FROM medical_services WHERE slug = 'colonoscopy-with-anesthesia'
UNION ALL SELECT id, 'Kolonoskopija pod anestezijom', 'sr' FROM medical_services WHERE slug = 'colonoscopy-with-anesthesia'
UNION ALL SELECT id, 'Колоноскопија под анестезијом', 'sr-cyrl' FROM medical_services WHERE slug = 'colonoscopy-with-anesthesia'
UNION ALL SELECT id, 'Kolonoskopija u narkozi', 'sr' FROM medical_services WHERE slug = 'colonoscopy-with-anesthesia'
UNION ALL SELECT id, 'Колоноскопија у наркози', 'sr-cyrl' FROM medical_services WHERE slug = 'colonoscopy-with-anesthesia'
UNION ALL SELECT id, 'Колоноскопия под наркозом', 'ru' FROM medical_services WHERE slug = 'colonoscopy-with-anesthesia'
UNION ALL SELECT id, 'Колоноскопия во сне', 'ru' FROM medical_services WHERE slug = 'colonoscopy-with-anesthesia'
UNION ALL SELECT id, 'Darmspiegelung in Narkose', 'de' FROM medical_services WHERE slug = 'colonoscopy-with-anesthesia'
UNION ALL SELECT id, 'Sedasyonlu kolonoskopi', 'tr' FROM medical_services WHERE slug = 'colonoscopy-with-anesthesia';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Colon Polyp Removal', 'en' FROM medical_services WHERE slug = 'colonoscopy-with-polypectomy'
UNION ALL SELECT id, 'Uklanjanje polipa debelog crijeva', 'sr' FROM medical_services WHERE slug = 'colonoscopy-with-polypectomy'
UNION ALL SELECT id, 'Уклањање полипа дебелог цријева', 'sr-cyrl' FROM medical_services WHERE slug = 'colonoscopy-with-polypectomy'
UNION ALL SELECT id, 'Удаление полипов толстой кишки', 'ru' FROM medical_services WHERE slug = 'colonoscopy-with-polypectomy'
UNION ALL SELECT id, 'Darmpolypenentfernung', 'de' FROM medical_services WHERE slug = 'colonoscopy-with-polypectomy'
UNION ALL SELECT id, 'Kolon polibi alınması', 'tr' FROM medical_services WHERE slug = 'colonoscopy-with-polypectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kolonoskopija bez narkoze', 'sr' FROM medical_services WHERE slug = 'colonoscopy-without-anesthesia'
UNION ALL SELECT id, 'Колоноскопија без наркозе', 'sr-cyrl' FROM medical_services WHERE slug = 'colonoscopy-without-anesthesia'
UNION ALL SELECT id, 'Колоноскопия без наркоза', 'ru' FROM medical_services WHERE slug = 'colonoscopy-without-anesthesia'
UNION ALL SELECT id, 'Darmspiegelung', 'de' FROM medical_services WHERE slug = 'colonoscopy-without-anesthesia';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Prvi pregled gastroenterohepatologa', 'sr' FROM medical_services WHERE slug = 'first-gastroenterologist-examination'
UNION ALL SELECT id, 'Први преглед gastroenterohepatologa', 'sr-cyrl' FROM medical_services WHERE slug = 'first-gastroenterologist-examination'
UNION ALL SELECT id, 'Первичный приём гастроэнтеролога', 'ru' FROM medical_services WHERE slug = 'first-gastroenterologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Gastroscopy under Sedation', 'en' FROM medical_services WHERE slug = 'gastroscopy-with-anesthesia'
UNION ALL SELECT id, 'Gastroskopija pod anestezijom', 'sr' FROM medical_services WHERE slug = 'gastroscopy-with-anesthesia'
UNION ALL SELECT id, 'Гастроскопија под анестезијом', 'sr-cyrl' FROM medical_services WHERE slug = 'gastroscopy-with-anesthesia'
UNION ALL SELECT id, 'Gastroskopija u narkozi', 'sr' FROM medical_services WHERE slug = 'gastroscopy-with-anesthesia'
UNION ALL SELECT id, 'Гастроскопија у наркози', 'sr-cyrl' FROM medical_services WHERE slug = 'gastroscopy-with-anesthesia'
UNION ALL SELECT id, 'ФГДС под наркозом', 'ru' FROM medical_services WHERE slug = 'gastroscopy-with-anesthesia'
UNION ALL SELECT id, 'Гастроскопия под наркозом', 'ru' FROM medical_services WHERE slug = 'gastroscopy-with-anesthesia'
UNION ALL SELECT id, 'Гастроскопия во сне', 'ru' FROM medical_services WHERE slug = 'gastroscopy-with-anesthesia'
UNION ALL SELECT id, 'Magenspiegelung in Narkose', 'de' FROM medical_services WHERE slug = 'gastroscopy-with-anesthesia'
UNION ALL SELECT id, 'Sedasyonlu gastroskopi', 'tr' FROM medical_services WHERE slug = 'gastroscopy-with-anesthesia';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'EGD', 'en' FROM medical_services WHERE slug = 'gastroscopy-without-anesthesia'
UNION ALL SELECT id, 'Upper GI Endoscopy', 'en' FROM medical_services WHERE slug = 'gastroscopy-without-anesthesia'
UNION ALL SELECT id, 'Gastroskopija bez narkoze', 'sr' FROM medical_services WHERE slug = 'gastroscopy-without-anesthesia'
UNION ALL SELECT id, 'Гастроскопија без наркозе', 'sr-cyrl' FROM medical_services WHERE slug = 'gastroscopy-without-anesthesia'
UNION ALL SELECT id, 'ФГДС', 'ru' FROM medical_services WHERE slug = 'gastroscopy-without-anesthesia'
UNION ALL SELECT id, 'ЭГДС', 'ru' FROM medical_services WHERE slug = 'gastroscopy-without-anesthesia'
UNION ALL SELECT id, 'Гастроскопия без наркоза', 'ru' FROM medical_services WHERE slug = 'gastroscopy-without-anesthesia'
UNION ALL SELECT id, 'Magenspiegelung', 'de' FROM medical_services WHERE slug = 'gastroscopy-without-anesthesia'
UNION ALL SELECT id, 'Mide endoskopisi', 'tr' FROM medical_services WHERE slug = 'gastroscopy-without-anesthesia';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Histopatološki nalaz biopsije', 'sr' FROM medical_services WHERE slug = 'histopathology-report-single-biopsy'
UNION ALL SELECT id, 'Хистопатолошки налаз биопсије', 'sr-cyrl' FROM medical_services WHERE slug = 'histopathology-report-single-biopsy'
UNION ALL SELECT id, 'Гистологическое исследование биоптата', 'ru' FROM medical_services WHERE slug = 'histopathology-report-single-biopsy'
UNION ALL SELECT id, 'Гистология биопсии', 'ru' FROM medical_services WHERE slug = 'histopathology-report-single-biopsy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Proctosigmoidoscopy', 'en' FROM medical_services WHERE slug = 'rectosigmoidoscopy'
UNION ALL SELECT id, 'Ректороманоскопия', 'ru' FROM medical_services WHERE slug = 'rectosigmoidoscopy'
UNION ALL SELECT id, 'РРС', 'ru' FROM medical_services WHERE slug = 'rectosigmoidoscopy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Gastric Polyp Removal', 'en' FROM medical_services WHERE slug = 'stomach-polypectomy'
UNION ALL SELECT id, 'Uklanjanje polipa želuca', 'sr' FROM medical_services WHERE slug = 'stomach-polypectomy'
UNION ALL SELECT id, 'Уклањање полипа желуца', 'sr-cyrl' FROM medical_services WHERE slug = 'stomach-polypectomy'
UNION ALL SELECT id, 'Удаление полипов желудка', 'ru' FROM medical_services WHERE slug = 'stomach-polypectomy'
UNION ALL SELECT id, 'Entfernung von Magenpolypen', 'de' FROM medical_services WHERE slug = 'stomach-polypectomy'
UNION ALL SELECT id, 'Mide polibi alınması', 'tr' FROM medical_services WHERE slug = 'stomach-polypectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Autorefractometry', 'en' FROM medical_services WHERE slug = 'autokeratorefractometry'
UNION ALL SELECT id, 'Autorefraction', 'en' FROM medical_services WHERE slug = 'autokeratorefractometry'
UNION ALL SELECT id, 'Autorefraktometrija', 'sr' FROM medical_services WHERE slug = 'autokeratorefractometry'
UNION ALL SELECT id, 'Ауторефрактометрија', 'sr-cyrl' FROM medical_services WHERE slug = 'autokeratorefractometry'
UNION ALL SELECT id, 'Kompjuterski pregled vida', 'sr' FROM medical_services WHERE slug = 'autokeratorefractometry'
UNION ALL SELECT id, 'Компјутерски преглед вида', 'sr-cyrl' FROM medical_services WHERE slug = 'autokeratorefractometry'
UNION ALL SELECT id, 'Авторефрактометрия', 'ru' FROM medical_services WHERE slug = 'autokeratorefractometry'
UNION ALL SELECT id, 'Компьютерная рефрактометрия', 'ru' FROM medical_services WHERE slug = 'autokeratorefractometry'
UNION ALL SELECT id, 'Otorefraktometri', 'tr' FROM medical_services WHERE slug = 'autokeratorefractometry';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Eyelid Surgery', 'en' FROM medical_services WHERE slug = 'blepharoplasty'
UNION ALL SELECT id, 'Korekcija kapaka', 'sr' FROM medical_services WHERE slug = 'blepharoplasty'
UNION ALL SELECT id, 'Корекција капака', 'sr-cyrl' FROM medical_services WHERE slug = 'blepharoplasty'
UNION ALL SELECT id, 'Пластика век', 'ru' FROM medical_services WHERE slug = 'blepharoplasty'
UNION ALL SELECT id, 'Augenlidstraffung', 'de' FROM medical_services WHERE slug = 'blepharoplasty'
UNION ALL SELECT id, 'Göz kapağı estetiği', 'tr' FROM medical_services WHERE slug = 'blepharoplasty';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Comprehensive Eye Exam', 'en' FROM medical_services WHERE slug = 'comprehensive-ophthalmological-examination'
UNION ALL SELECT id, 'Kompletan oftalmološki pregled', 'sr' FROM medical_services WHERE slug = 'comprehensive-ophthalmological-examination'
UNION ALL SELECT id, 'Комплетан офталмолошки преглед', 'sr-cyrl' FROM medical_services WHERE slug = 'comprehensive-ophthalmological-examination'
UNION ALL SELECT id, 'Комплексное обследование зрения', 'ru' FROM medical_services WHERE slug = 'comprehensive-ophthalmological-examination'
UNION ALL SELECT id, 'Umfassende Augenuntersuchung', 'de' FROM medical_services WHERE slug = 'comprehensive-ophthalmological-examination'
UNION ALL SELECT id, 'Kapsamlı göz muayenesi', 'tr' FROM medical_services WHERE slug = 'comprehensive-ophthalmological-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'ERG', 'en' FROM medical_services WHERE slug = 'electroretinography'
UNION ALL SELECT id, 'ЭРГ', 'ru' FROM medical_services WHERE slug = 'electroretinography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Initial Eye Exam', 'en' FROM medical_services WHERE slug = 'first-ophthalmologist-examination'
UNION ALL SELECT id, 'Eye Doctor Consultation', 'en' FROM medical_services WHERE slug = 'first-ophthalmologist-examination'
UNION ALL SELECT id, 'Pregled očnog ljekara', 'sr' FROM medical_services WHERE slug = 'first-ophthalmologist-examination'
UNION ALL SELECT id, 'Преглед очног љекара', 'sr-cyrl' FROM medical_services WHERE slug = 'first-ophthalmologist-examination'
UNION ALL SELECT id, 'Pregled očnog lekara', 'sr' FROM medical_services WHERE slug = 'first-ophthalmologist-examination'
UNION ALL SELECT id, 'Преглед очног лекара', 'sr-cyrl' FROM medical_services WHERE slug = 'first-ophthalmologist-examination'
UNION ALL SELECT id, 'Первичный приём офтальмолога', 'ru' FROM medical_services WHERE slug = 'first-ophthalmologist-examination'
UNION ALL SELECT id, 'Приём окулиста', 'ru' FROM medical_services WHERE slug = 'first-ophthalmologist-examination'
UNION ALL SELECT id, 'Консультация офтальмолога', 'ru' FROM medical_services WHERE slug = 'first-ophthalmologist-examination'
UNION ALL SELECT id, 'Erstuntersuchung beim Augenarzt', 'de' FROM medical_services WHERE slug = 'first-ophthalmologist-examination'
UNION ALL SELECT id, 'Göz doktoru muayenesi', 'tr' FROM medical_services WHERE slug = 'first-ophthalmologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Angiografija očnog dna', 'sr' FROM medical_services WHERE slug = 'fluorescein-angiography'
UNION ALL SELECT id, 'Ангиографија очног дна', 'sr-cyrl' FROM medical_services WHERE slug = 'fluorescein-angiography'
UNION ALL SELECT id, 'ФАГ', 'ru' FROM medical_services WHERE slug = 'fluorescein-angiography'
UNION ALL SELECT id, 'Флуоресцентная ангиография', 'ru' FROM medical_services WHERE slug = 'fluorescein-angiography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Retinal Photography', 'en' FROM medical_services WHERE slug = 'fundus-photography'
UNION ALL SELECT id, 'Fotografisanje očnog dna', 'sr' FROM medical_services WHERE slug = 'fundus-photography'
UNION ALL SELECT id, 'Фотографисање очног дна', 'sr-cyrl' FROM medical_services WHERE slug = 'fundus-photography'
UNION ALL SELECT id, 'Фоторегистрация глазного дна', 'ru' FROM medical_services WHERE slug = 'fundus-photography'
UNION ALL SELECT id, 'Фундус-фотография', 'ru' FROM medical_services WHERE slug = 'fundus-photography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Tear Duct Irrigation', 'en' FROM medical_services WHERE slug = 'lacrimal-duct-irrigation'
UNION ALL SELECT id, 'Ispiranje suznih puteva', 'sr' FROM medical_services WHERE slug = 'lacrimal-duct-irrigation'
UNION ALL SELECT id, 'Испирање сузних путева', 'sr-cyrl' FROM medical_services WHERE slug = 'lacrimal-duct-irrigation'
UNION ALL SELECT id, 'Промывание носослёзного канала', 'ru' FROM medical_services WHERE slug = 'lacrimal-duct-irrigation'
UNION ALL SELECT id, 'Промывание слёзных путей', 'ru' FROM medical_services WHERE slug = 'lacrimal-duct-irrigation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lower Eyelid Surgery', 'en' FROM medical_services WHERE slug = 'lower-blepharoplasty'
UNION ALL SELECT id, 'Eye Bag Removal', 'en' FROM medical_services WHERE slug = 'lower-blepharoplasty'
UNION ALL SELECT id, 'Korekcija donjih kapaka', 'sr' FROM medical_services WHERE slug = 'lower-blepharoplasty'
UNION ALL SELECT id, 'Корекција доњих капака', 'sr-cyrl' FROM medical_services WHERE slug = 'lower-blepharoplasty'
UNION ALL SELECT id, 'Operacija podočnjaka', 'sr' FROM medical_services WHERE slug = 'lower-blepharoplasty'
UNION ALL SELECT id, 'Операција подочњака', 'sr-cyrl' FROM medical_services WHERE slug = 'lower-blepharoplasty'
UNION ALL SELECT id, 'Удаление мешков под глазами', 'ru' FROM medical_services WHERE slug = 'lower-blepharoplasty'
UNION ALL SELECT id, 'Unterlidstraffung', 'de' FROM medical_services WHERE slug = 'lower-blepharoplasty'
UNION ALL SELECT id, 'Göz altı torbası ameliyatı', 'tr' FROM medical_services WHERE slug = 'lower-blepharoplasty';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'OCT oka', 'sr' FROM medical_services WHERE slug = 'optical-coherence-tomography-oct'
UNION ALL SELECT id, 'OCT ока', 'sr-cyrl' FROM medical_services WHERE slug = 'optical-coherence-tomography-oct'
UNION ALL SELECT id, 'ОКТ глаза', 'ru' FROM medical_services WHERE slug = 'optical-coherence-tomography-oct'
UNION ALL SELECT id, 'Göz tomografisi', 'tr' FROM medical_services WHERE slug = 'optical-coherence-tomography-oct';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Upper Eyelid Surgery', 'en' FROM medical_services WHERE slug = 'upper-blepharoplasty'
UNION ALL SELECT id, 'Korekcija gornjih kapaka', 'sr' FROM medical_services WHERE slug = 'upper-blepharoplasty'
UNION ALL SELECT id, 'Корекција горњих капака', 'sr-cyrl' FROM medical_services WHERE slug = 'upper-blepharoplasty'
UNION ALL SELECT id, 'Коррекция нависшего века', 'ru' FROM medical_services WHERE slug = 'upper-blepharoplasty'
UNION ALL SELECT id, 'Oberlidstraffung', 'de' FROM medical_services WHERE slug = 'upper-blepharoplasty'
UNION ALL SELECT id, 'Üst göz kapağı estetiği', 'tr' FROM medical_services WHERE slug = 'upper-blepharoplasty';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Bracket Rebonding', 'en' FROM medical_services WHERE slug = 'bracket-replacement'
UNION ALL SELECT id, 'Zamjena breketa', 'sr' FROM medical_services WHERE slug = 'bracket-replacement'
UNION ALL SELECT id, 'Замјена брекета', 'sr-cyrl' FROM medical_services WHERE slug = 'bracket-replacement'
UNION ALL SELECT id, 'Zamena breketa', 'sr' FROM medical_services WHERE slug = 'bracket-replacement'
UNION ALL SELECT id, 'Переклейка брекета', 'ru' FROM medical_services WHERE slug = 'bracket-replacement';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Invisible Braces', 'en' FROM medical_services WHERE slug = 'clear-aligner-therapy'
UNION ALL SELECT id, 'Clear Aligners', 'en' FROM medical_services WHERE slug = 'clear-aligner-therapy'
UNION ALL SELECT id, 'Aligneri', 'sr' FROM medical_services WHERE slug = 'clear-aligner-therapy'
UNION ALL SELECT id, 'Алигнери', 'sr-cyrl' FROM medical_services WHERE slug = 'clear-aligner-therapy'
UNION ALL SELECT id, 'Providne folije za zube', 'sr' FROM medical_services WHERE slug = 'clear-aligner-therapy'
UNION ALL SELECT id, 'Провидне фолије за зубе', 'sr-cyrl' FROM medical_services WHERE slug = 'clear-aligner-therapy'
UNION ALL SELECT id, 'Элайнеры', 'ru' FROM medical_services WHERE slug = 'clear-aligner-therapy'
UNION ALL SELECT id, 'Капы для выравнивания зубов', 'ru' FROM medical_services WHERE slug = 'clear-aligner-therapy'
UNION ALL SELECT id, 'Unsichtbare Zahnspange', 'de' FROM medical_services WHERE slug = 'clear-aligner-therapy'
UNION ALL SELECT id, 'Görünmez diş teli', 'tr' FROM medical_services WHERE slug = 'clear-aligner-therapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Инвизилайн', 'ru' FROM medical_services WHERE slug = 'invisalign-aligner'
UNION ALL SELECT id, 'Инвизалайн', 'ru' FROM medical_services WHERE slug = 'invisalign-aligner';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pregled ortodonta', 'sr' FROM medical_services WHERE slug = 'orthodontic-consultation'
UNION ALL SELECT id, 'Преглед ортодонта', 'sr-cyrl' FROM medical_services WHERE slug = 'orthodontic-consultation'
UNION ALL SELECT id, 'Приём ортодонта', 'ru' FROM medical_services WHERE slug = 'orthodontic-consultation'
UNION ALL SELECT id, 'Untersuchung beim Kieferorthopäden', 'de' FROM medical_services WHERE slug = 'orthodontic-consultation'
UNION ALL SELECT id, 'Ortodontist muayenesi', 'tr' FROM medical_services WHERE slug = 'orthodontic-consultation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Removable Braces', 'en' FROM medical_services WHERE slug = 'orthodontic-removable-plate-appliance'
UNION ALL SELECT id, 'Mobilni ortodontski aparat', 'sr' FROM medical_services WHERE slug = 'orthodontic-removable-plate-appliance'
UNION ALL SELECT id, 'Мобилни ортодонтски апарат', 'sr-cyrl' FROM medical_services WHERE slug = 'orthodontic-removable-plate-appliance'
UNION ALL SELECT id, 'Ортодонтическая пластинка', 'ru' FROM medical_services WHERE slug = 'orthodontic-removable-plate-appliance'
UNION ALL SELECT id, 'Пластинка для выравнивания зубов', 'ru' FROM medical_services WHERE slug = 'orthodontic-removable-plate-appliance'
UNION ALL SELECT id, 'Herausnehmbare Zahnspange', 'de' FROM medical_services WHERE slug = 'orthodontic-removable-plate-appliance'
UNION ALL SELECT id, 'Hareketli diş teli', 'tr' FROM medical_services WHERE slug = 'orthodontic-removable-plate-appliance';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Clear Retainer', 'en' FROM medical_services WHERE slug = 'retention-aligner-fabrication'
UNION ALL SELECT id, 'Retenciona folija', 'sr' FROM medical_services WHERE slug = 'retention-aligner-fabrication'
UNION ALL SELECT id, 'Ретенциона фолија', 'sr-cyrl' FROM medical_services WHERE slug = 'retention-aligner-fabrication'
UNION ALL SELECT id, 'Ретенционная капа', 'ru' FROM medical_services WHERE slug = 'retention-aligner-fabrication'
UNION ALL SELECT id, 'Капа после брекетов', 'ru' FROM medical_services WHERE slug = 'retention-aligner-fabrication';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Anti-VEGF Therapy', 'en' FROM medical_services WHERE slug = 'anti-vegf-injection'
UNION ALL SELECT id, 'Anti-VEGF terapija', 'sr' FROM medical_services WHERE slug = 'anti-vegf-injection'
UNION ALL SELECT id, 'Анти-ВЕГФ терапија', 'sr-cyrl' FROM medical_services WHERE slug = 'anti-vegf-injection'
UNION ALL SELECT id, 'Анти-VEGF терапия', 'ru' FROM medical_services WHERE slug = 'anti-vegf-injection';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Postavljanje katetera', 'sr' FROM medical_services WHERE slug = 'catheter-placement'
UNION ALL SELECT id, 'Постављање катетера', 'sr-cyrl' FROM medical_services WHERE slug = 'catheter-placement'
UNION ALL SELECT id, 'Постановка катетера', 'ru' FROM medical_services WHERE slug = 'catheter-placement';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Central Line Placement', 'en' FROM medical_services WHERE slug = 'central-venous-catheter-placement'
UNION ALL SELECT id, 'CVC Placement', 'en' FROM medical_services WHERE slug = 'central-venous-catheter-placement'
UNION ALL SELECT id, 'Plasiranje CVK', 'sr' FROM medical_services WHERE slug = 'central-venous-catheter-placement'
UNION ALL SELECT id, 'Пласирање ЦВК', 'sr-cyrl' FROM medical_services WHERE slug = 'central-venous-catheter-placement'
UNION ALL SELECT id, 'Постановка ЦВК', 'ru' FROM medical_services WHERE slug = 'central-venous-catheter-placement'
UNION ALL SELECT id, 'Катетеризация центральной вены', 'ru' FROM medical_services WHERE slug = 'central-venous-catheter-placement'
UNION ALL SELECT id, 'ZVK-Anlage', 'de' FROM medical_services WHERE slug = 'central-venous-catheter-placement'
UNION ALL SELECT id, 'Santral kateter takılması', 'tr' FROM medical_services WHERE slug = 'central-venous-catheter-placement';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Plasma Donation', 'en' FROM medical_services WHERE slug = 'donor-plasmapheresis'
UNION ALL SELECT id, 'Doniranje plazme', 'sr' FROM medical_services WHERE slug = 'donor-plasmapheresis'
UNION ALL SELECT id, 'Донирање плазме', 'sr-cyrl' FROM medical_services WHERE slug = 'donor-plasmapheresis'
UNION ALL SELECT id, 'Сдача плазмы', 'ru' FROM medical_services WHERE slug = 'donor-plasmapheresis'
UNION ALL SELECT id, 'Донорство плазмы', 'ru' FROM medical_services WHERE slug = 'donor-plasmapheresis'
UNION ALL SELECT id, 'Plasmaspende', 'de' FROM medical_services WHERE slug = 'donor-plasmapheresis'
UNION ALL SELECT id, 'Plazma bağışı', 'tr' FROM medical_services WHERE slug = 'donor-plasmapheresis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'IV Drip', 'en' FROM medical_services WHERE slug = 'infusion-therapy'
UNION ALL SELECT id, 'Davanje infuzije', 'sr' FROM medical_services WHERE slug = 'infusion-therapy'
UNION ALL SELECT id, 'Давање инфузије', 'sr-cyrl' FROM medical_services WHERE slug = 'infusion-therapy'
UNION ALL SELECT id, 'Капельница', 'ru' FROM medical_services WHERE slug = 'infusion-therapy'
UNION ALL SELECT id, 'Serum takılması', 'tr' FROM medical_services WHERE slug = 'infusion-therapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'IM Injection', 'en' FROM medical_services WHERE slug = 'intramuscular-injection'
UNION ALL SELECT id, 'Injekcija u mišić', 'sr' FROM medical_services WHERE slug = 'intramuscular-injection'
UNION ALL SELECT id, 'Инјекција у мишић', 'sr-cyrl' FROM medical_services WHERE slug = 'intramuscular-injection'
UNION ALL SELECT id, 'Внутримышечный укол', 'ru' FROM medical_services WHERE slug = 'intramuscular-injection'
UNION ALL SELECT id, 'Укол в мышцу', 'ru' FROM medical_services WHERE slug = 'intramuscular-injection'
UNION ALL SELECT id, 'Kas içi enjeksiyon', 'tr' FROM medical_services WHERE slug = 'intramuscular-injection';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'IV Injection', 'en' FROM medical_services WHERE slug = 'intravenous-medication-application'
UNION ALL SELECT id, 'Intravenska injekcija', 'sr' FROM medical_services WHERE slug = 'intravenous-medication-application'
UNION ALL SELECT id, 'Интравенска инјекција', 'sr-cyrl' FROM medical_services WHERE slug = 'intravenous-medication-application'
UNION ALL SELECT id, 'Injekcija u venu', 'sr' FROM medical_services WHERE slug = 'intravenous-medication-application'
UNION ALL SELECT id, 'Инјекција у вену', 'sr-cyrl' FROM medical_services WHERE slug = 'intravenous-medication-application'
UNION ALL SELECT id, 'Укол в вену', 'ru' FROM medical_services WHERE slug = 'intravenous-medication-application'
UNION ALL SELECT id, 'Damar içi enjeksiyon', 'tr' FROM medical_services WHERE slug = 'intravenous-medication-application';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Peripheral IV Cannulation', 'en' FROM medical_services WHERE slug = 'iv-cannula-application'
UNION ALL SELECT id, 'Postavljanje braunile', 'sr' FROM medical_services WHERE slug = 'iv-cannula-application'
UNION ALL SELECT id, 'Постављање брауниле', 'sr-cyrl' FROM medical_services WHERE slug = 'iv-cannula-application'
UNION ALL SELECT id, 'Установка периферического венозного катетера', 'ru' FROM medical_services WHERE slug = 'iv-cannula-application'
UNION ALL SELECT id, 'Legen einer Braunüle', 'de' FROM medical_services WHERE slug = 'iv-cannula-application'
UNION ALL SELECT id, 'Damar yolu açılması', 'tr' FROM medical_services WHERE slug = 'iv-cannula-application'
UNION ALL SELECT id, 'Branül takılması', 'tr' FROM medical_services WHERE slug = 'iv-cannula-application';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'LMA Insertion', 'en' FROM medical_services WHERE slug = 'laryngeal-mask-placement';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Oxygen Therapy', 'en' FROM medical_services WHERE slug = 'oxygen-administration'
UNION ALL SELECT id, 'Oksigenoterapija', 'sr' FROM medical_services WHERE slug = 'oxygen-administration'
UNION ALL SELECT id, 'Оксигенотерапија', 'sr-cyrl' FROM medical_services WHERE slug = 'oxygen-administration'
UNION ALL SELECT id, 'Оксигенотерапия', 'ru' FROM medical_services WHERE slug = 'oxygen-administration'
UNION ALL SELECT id, 'Sauerstofftherapie', 'de' FROM medical_services WHERE slug = 'oxygen-administration'
UNION ALL SELECT id, 'Oksijen tedavisi', 'tr' FROM medical_services WHERE slug = 'oxygen-administration';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Укол под конъюнктиву', 'ru' FROM medical_services WHERE slug = 'subconjunctival-injection';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'SubQ Injection', 'en' FROM medical_services WHERE slug = 'subcutaneous-injection'
UNION ALL SELECT id, 'Subkutana injekcija', 'sr' FROM medical_services WHERE slug = 'subcutaneous-injection'
UNION ALL SELECT id, 'Субкутана инјекција', 'sr-cyrl' FROM medical_services WHERE slug = 'subcutaneous-injection'
UNION ALL SELECT id, 'Injekcija pod kožu', 'sr' FROM medical_services WHERE slug = 'subcutaneous-injection'
UNION ALL SELECT id, 'Инјекција под кожу', 'sr-cyrl' FROM medical_services WHERE slug = 'subcutaneous-injection'
UNION ALL SELECT id, 'Подкожный укол', 'ru' FROM medical_services WHERE slug = 'subcutaneous-injection'
UNION ALL SELECT id, 'Укол под кожу', 'ru' FROM medical_services WHERE slug = 'subcutaneous-injection'
UNION ALL SELECT id, 'Deri altı enjeksiyon', 'tr' FROM medical_services WHERE slug = 'subcutaneous-injection';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Лечебный цитаферез', 'ru' FROM medical_services WHERE slug = 'therapeutic-cytapheresis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Therapeutic Plasma Exchange', 'en' FROM medical_services WHERE slug = 'therapeutic-plasmapheresis'
UNION ALL SELECT id, 'Terapijska izmjena plazme', 'sr' FROM medical_services WHERE slug = 'therapeutic-plasmapheresis'
UNION ALL SELECT id, 'Терапијска измјена плазме', 'sr-cyrl' FROM medical_services WHERE slug = 'therapeutic-plasmapheresis'
UNION ALL SELECT id, 'Лечебный плазмаферез', 'ru' FROM medical_services WHERE slug = 'therapeutic-plasmapheresis'
UNION ALL SELECT id, 'Plasmaaustausch', 'de' FROM medical_services WHERE slug = 'therapeutic-plasmapheresis'
UNION ALL SELECT id, 'Plazma değişimi', 'tr' FROM medical_services WHERE slug = 'therapeutic-plasmapheresis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Vađenje krvi iz vene', 'sr' FROM medical_services WHERE slug = 'venous-blood-draw'
UNION ALL SELECT id, 'Вађење крви из вене', 'sr-cyrl' FROM medical_services WHERE slug = 'venous-blood-draw'
UNION ALL SELECT id, 'Взятие крови из вены', 'ru' FROM medical_services WHERE slug = 'venous-blood-draw'
UNION ALL SELECT id, 'Blutabnahme', 'de' FROM medical_services WHERE slug = 'venous-blood-draw'
UNION ALL SELECT id, 'Damardan kan alma', 'tr' FROM medical_services WHERE slug = 'venous-blood-draw';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Otvaranje apscesa', 'sr' FROM medical_services WHERE slug = 'abscess-incision'
UNION ALL SELECT id, 'Отварање апсцеса', 'sr-cyrl' FROM medical_services WHERE slug = 'abscess-incision'
UNION ALL SELECT id, 'Вскрытие гнойника', 'ru' FROM medical_services WHERE slug = 'abscess-incision'
UNION ALL SELECT id, 'Abszesseröffnung', 'de' FROM medical_services WHERE slug = 'abscess-incision'
UNION ALL SELECT id, 'Apse açılması', 'tr' FROM medical_services WHERE slug = 'abscess-incision';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Stitch Removal', 'en' FROM medical_services WHERE slug = 'suture-removal'
UNION ALL SELECT id, 'Vađenje konaca', 'sr' FROM medical_services WHERE slug = 'suture-removal'
UNION ALL SELECT id, 'Вађење конаца', 'sr-cyrl' FROM medical_services WHERE slug = 'suture-removal'
UNION ALL SELECT id, 'Skidanje šavova', 'sr' FROM medical_services WHERE slug = 'suture-removal'
UNION ALL SELECT id, 'Скидање шавова', 'sr-cyrl' FROM medical_services WHERE slug = 'suture-removal'
UNION ALL SELECT id, 'Снять швы', 'ru' FROM medical_services WHERE slug = 'suture-removal'
UNION ALL SELECT id, 'Снятие шовного материала', 'ru' FROM medical_services WHERE slug = 'suture-removal'
UNION ALL SELECT id, 'Fäden ziehen', 'de' FROM medical_services WHERE slug = 'suture-removal'
UNION ALL SELECT id, 'Dikiş aldırma', 'tr' FROM medical_services WHERE slug = 'suture-removal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Skidanje krpelja', 'sr' FROM medical_services WHERE slug = 'tick-removal'
UNION ALL SELECT id, 'Скидање крпеља', 'sr-cyrl' FROM medical_services WHERE slug = 'tick-removal'
UNION ALL SELECT id, 'Uklanjanje krpelja', 'sr' FROM medical_services WHERE slug = 'tick-removal'
UNION ALL SELECT id, 'Уклањање крпеља', 'sr-cyrl' FROM medical_services WHERE slug = 'tick-removal'
UNION ALL SELECT id, 'Извлечение клеща', 'ru' FROM medical_services WHERE slug = 'tick-removal'
UNION ALL SELECT id, 'Снять клеща', 'ru' FROM medical_services WHERE slug = 'tick-removal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Dressing Change', 'en' FROM medical_services WHERE slug = 'wound-dressing'
UNION ALL SELECT id, 'Previjanje rane', 'sr' FROM medical_services WHERE slug = 'wound-dressing'
UNION ALL SELECT id, 'Превијање ране', 'sr-cyrl' FROM medical_services WHERE slug = 'wound-dressing'
UNION ALL SELECT id, 'Verbandswechsel', 'de' FROM medical_services WHERE slug = 'wound-dressing';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Laceration Repair', 'en' FROM medical_services WHERE slug = 'wound-suturing-under-local-anesthesia'
UNION ALL SELECT id, 'Zbrinjavanje rane sa ušivanjem', 'sr' FROM medical_services WHERE slug = 'wound-suturing-under-local-anesthesia'
UNION ALL SELECT id, 'Збрињавање ране са ушивањем', 'sr-cyrl' FROM medical_services WHERE slug = 'wound-suturing-under-local-anesthesia'
UNION ALL SELECT id, 'Šivenje rane', 'sr' FROM medical_services WHERE slug = 'wound-suturing-under-local-anesthesia'
UNION ALL SELECT id, 'Шивење ране', 'sr-cyrl' FROM medical_services WHERE slug = 'wound-suturing-under-local-anesthesia'
UNION ALL SELECT id, 'Наложение швов на рану', 'ru' FROM medical_services WHERE slug = 'wound-suturing-under-local-anesthesia';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operacija ektropiona', 'sr' FROM medical_services WHERE slug = 'ectropion-surgery'
UNION ALL SELECT id, 'Операција ектропиона', 'sr-cyrl' FROM medical_services WHERE slug = 'ectropion-surgery';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Operacija entropiona', 'sr' FROM medical_services WHERE slug = 'entropion-surgery'
UNION ALL SELECT id, 'Операција ентропиона', 'sr-cyrl' FROM medical_services WHERE slug = 'entropion-surgery';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Scleral Buckling', 'en' FROM medical_services WHERE slug = 'episcleral-retinal-detachment-surgery'
UNION ALL SELECT id, 'Экстрасклеральное пломбирование', 'ru' FROM medical_services WHERE slug = 'episcleral-retinal-detachment-surgery'
UNION ALL SELECT id, 'Eindellende Netzhautoperation', 'de' FROM medical_services WHERE slug = 'episcleral-retinal-detachment-surgery';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Podizanje spuštenog kapka', 'sr' FROM medical_services WHERE slug = 'ptosis-correction-with-frontal-suspension'
UNION ALL SELECT id, 'Подизање спуштеног капка', 'sr-cyrl' FROM medical_services WHERE slug = 'ptosis-correction-with-frontal-suspension'
UNION ALL SELECT id, 'Операция при опущении века', 'ru' FROM medical_services WHERE slug = 'ptosis-correction-with-frontal-suspension'
UNION ALL SELECT id, 'Göz kapağı düşüklüğü ameliyatı', 'tr' FROM medical_services WHERE slug = 'ptosis-correction-with-frontal-suspension';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Sekundarna ugradnja intraokularnog sočiva', 'sr' FROM medical_services WHERE slug = 'secondary-iol-implantation'
UNION ALL SELECT id, 'Секундарна уградња интраокуларног сочива', 'sr-cyrl' FROM medical_services WHERE slug = 'secondary-iol-implantation'
UNION ALL SELECT id, 'Вторичная имплантация интраокулярной линзы', 'ru' FROM medical_services WHERE slug = 'secondary-iol-implantation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Uklanjanje silikonskog ulja', 'sr' FROM medical_services WHERE slug = 'silicone-oil-removal'
UNION ALL SELECT id, 'Уклањање силиконског уља', 'sr-cyrl' FROM medical_services WHERE slug = 'silicone-oil-removal'
UNION ALL SELECT id, 'Удаление силикона из глаза', 'ru' FROM medical_services WHERE slug = 'silicone-oil-removal';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Squint Surgery', 'en' FROM medical_services WHERE slug = 'strabismus-surgery'
UNION ALL SELECT id, 'Operacija razrokosti', 'sr' FROM medical_services WHERE slug = 'strabismus-surgery'
UNION ALL SELECT id, 'Операција разрокости', 'sr-cyrl' FROM medical_services WHERE slug = 'strabismus-surgery'
UNION ALL SELECT id, 'Операция косоглазия', 'ru' FROM medical_services WHERE slug = 'strabismus-surgery'
UNION ALL SELECT id, 'Schieloperation', 'de' FROM medical_services WHERE slug = 'strabismus-surgery';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ganzkörperplethysmographie', 'de' FROM medical_services WHERE slug = 'body-plethysmography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Bronchodilator Reversibility Test', 'en' FROM medical_services WHERE slug = 'bronchodilator-test'
UNION ALL SELECT id, 'Bronhodilatacijski test', 'sr' FROM medical_services WHERE slug = 'bronchodilator-test'
UNION ALL SELECT id, 'Бронходилатацијски тест', 'sr-cyrl' FROM medical_services WHERE slug = 'bronchodilator-test'
UNION ALL SELECT id, 'Бронхолитическая проба', 'ru' FROM medical_services WHERE slug = 'bronchodilator-test'
UNION ALL SELECT id, 'Спирометрия с бронхолитиком', 'ru' FROM medical_services WHERE slug = 'bronchodilator-test'
UNION ALL SELECT id, 'Bronchospasmolysetest', 'de' FROM medical_services WHERE slug = 'bronchodilator-test'
UNION ALL SELECT id, 'Reversibilite testi', 'tr' FROM medical_services WHERE slug = 'bronchodilator-test';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cardiopulmonary Exercise Test', 'en' FROM medical_services WHERE slug = 'ergospirometry'
UNION ALL SELECT id, 'CPET', 'en' FROM medical_services WHERE slug = 'ergospirometry'
UNION ALL SELECT id, 'Spiroergometrija', 'sr' FROM medical_services WHERE slug = 'ergospirometry'
UNION ALL SELECT id, 'Кардиопульмональный нагрузочный тест', 'ru' FROM medical_services WHERE slug = 'ergospirometry'
UNION ALL SELECT id, 'Spiroergometrie', 'de' FROM medical_services WHERE slug = 'ergospirometry'
UNION ALL SELECT id, 'Kardiyopulmoner egzersiz testi', 'tr' FROM medical_services WHERE slug = 'ergospirometry';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kontrolni pregled pulmologa', 'sr' FROM medical_services WHERE slug = 'follow-up-pulmonologist-examination'
UNION ALL SELECT id, 'Контролни преглед пулмолога', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-pulmonologist-examination'
UNION ALL SELECT id, 'Повторный приём пульмонолога', 'ru' FROM medical_services WHERE slug = 'follow-up-pulmonologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Nebulizer Therapy', 'en' FROM medical_services WHERE slug = 'inhalation-therapy'
UNION ALL SELECT id, 'Inhalacija', 'sr' FROM medical_services WHERE slug = 'inhalation-therapy'
UNION ALL SELECT id, 'Инхалација', 'sr-cyrl' FROM medical_services WHERE slug = 'inhalation-therapy'
UNION ALL SELECT id, 'Ингаляция', 'ru' FROM medical_services WHERE slug = 'inhalation-therapy'
UNION ALL SELECT id, 'Небулайзерная терапия', 'ru' FROM medical_services WHERE slug = 'inhalation-therapy'
UNION ALL SELECT id, 'Nebülizatör tedavisi', 'tr' FROM medical_services WHERE slug = 'inhalation-therapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'RTG medijastinuma', 'sr' FROM medical_services WHERE slug = 'mediastinum-x-ray'
UNION ALL SELECT id, 'RTG медијастинума', 'sr-cyrl' FROM medical_services WHERE slug = 'mediastinum-x-ray';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pleuralna punkcija', 'sr' FROM medical_services WHERE slug = 'pleural-puncture'
UNION ALL SELECT id, 'Плеурална пункција', 'sr-cyrl' FROM medical_services WHERE slug = 'pleural-puncture'
UNION ALL SELECT id, 'Пункция плевральной полости', 'ru' FROM medical_services WHERE slug = 'pleural-puncture';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Sleep Study', 'en' FROM medical_services WHERE slug = 'polysomnography'
UNION ALL SELECT id, 'Snimanje sna', 'sr' FROM medical_services WHERE slug = 'polysomnography'
UNION ALL SELECT id, 'Снимање сна', 'sr-cyrl' FROM medical_services WHERE slug = 'polysomnography'
UNION ALL SELECT id, 'Исследование сна', 'ru' FROM medical_services WHERE slug = 'polysomnography'
UNION ALL SELECT id, 'Schlaflabor', 'de' FROM medical_services WHERE slug = 'polysomnography'
UNION ALL SELECT id, 'Uyku testi', 'tr' FROM medical_services WHERE slug = 'polysomnography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lung Specialist', 'en' FROM medical_services WHERE slug = 'pulmonologist-examination'
UNION ALL SELECT id, 'Konsultacija pulmologa', 'sr' FROM medical_services WHERE slug = 'pulmonologist-examination'
UNION ALL SELECT id, 'Консултација пулмолога', 'sr-cyrl' FROM medical_services WHERE slug = 'pulmonologist-examination'
UNION ALL SELECT id, 'Приём пульмонолога', 'ru' FROM medical_services WHERE slug = 'pulmonologist-examination'
UNION ALL SELECT id, 'Консультация пульмонолога', 'ru' FROM medical_services WHERE slug = 'pulmonologist-examination'
UNION ALL SELECT id, 'Lungenarzt', 'de' FROM medical_services WHERE slug = 'pulmonologist-examination'
UNION ALL SELECT id, 'Akciğer doktoru', 'tr' FROM medical_services WHERE slug = 'pulmonologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Oxygen Saturation Measurement', 'en' FROM medical_services WHERE slug = 'pulse-oximetry'
UNION ALL SELECT id, 'Mjerenje saturacije', 'sr' FROM medical_services WHERE slug = 'pulse-oximetry'
UNION ALL SELECT id, 'Мјерење сатурације', 'sr-cyrl' FROM medical_services WHERE slug = 'pulse-oximetry'
UNION ALL SELECT id, 'Измерение сатурации', 'ru' FROM medical_services WHERE slug = 'pulse-oximetry'
UNION ALL SELECT id, 'Messung der Sauerstoffsättigung', 'de' FROM medical_services WHERE slug = 'pulse-oximetry'
UNION ALL SELECT id, 'Oksijen satürasyonu ölçümü', 'tr' FROM medical_services WHERE slug = 'pulse-oximetry';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lung Function Test', 'en' FROM medical_services WHERE slug = 'spirometry'
UNION ALL SELECT id, 'Ispitivanje plućne funkcije', 'sr' FROM medical_services WHERE slug = 'spirometry'
UNION ALL SELECT id, 'Испитивање плућне функције', 'sr-cyrl' FROM medical_services WHERE slug = 'spirometry'
UNION ALL SELECT id, 'ФВД', 'ru' FROM medical_services WHERE slug = 'spirometry'
UNION ALL SELECT id, 'Исследование функции внешнего дыхания', 'ru' FROM medical_services WHERE slug = 'spirometry'
UNION ALL SELECT id, 'Lungenfunktionstest', 'de' FROM medical_services WHERE slug = 'spirometry'
UNION ALL SELECT id, 'Solunum fonksiyon testi', 'tr' FROM medical_services WHERE slug = 'spirometry'
UNION ALL SELECT id, 'SFT', 'tr' FROM medical_services WHERE slug = 'spirometry';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Thyroid Surgery', 'en' FROM medical_services WHERE slug = 'thyroidectomy'
UNION ALL SELECT id, 'Tireoidektomija', 'sr' FROM medical_services WHERE slug = 'thyroidectomy'
UNION ALL SELECT id, 'Тиреоидектомија', 'sr-cyrl' FROM medical_services WHERE slug = 'thyroidectomy'
UNION ALL SELECT id, 'Operacija štitne žlezde', 'sr' FROM medical_services WHERE slug = 'thyroidectomy'
UNION ALL SELECT id, 'Операција штитне жлезде', 'sr-cyrl' FROM medical_services WHERE slug = 'thyroidectomy'
UNION ALL SELECT id, 'Удаление щитовидной железы', 'ru' FROM medical_services WHERE slug = 'thyroidectomy'
UNION ALL SELECT id, 'Операция на щитовидной железе', 'ru' FROM medical_services WHERE slug = 'thyroidectomy'
UNION ALL SELECT id, 'Schilddrüsenentfernung', 'de' FROM medical_services WHERE slug = 'thyroidectomy'
UNION ALL SELECT id, 'Guatr ameliyatı', 'tr' FROM medical_services WHERE slug = 'thyroidectomy'
UNION ALL SELECT id, 'Tiroid ameliyatı', 'tr' FROM medical_services WHERE slug = 'thyroidectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Mantoux Test', 'en' FROM medical_services WHERE slug = 'tuberculin-skin-test'
UNION ALL SELECT id, 'Mantu test', 'sr' FROM medical_services WHERE slug = 'tuberculin-skin-test'
UNION ALL SELECT id, 'Манту тест', 'sr-cyrl' FROM medical_services WHERE slug = 'tuberculin-skin-test'
UNION ALL SELECT id, 'Проба Манту', 'ru' FROM medical_services WHERE slug = 'tuberculin-skin-test'
UNION ALL SELECT id, 'PPD testi', 'tr' FROM medical_services WHERE slug = 'tuberculin-skin-test';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Rendgen pluća', 'sr' FROM medical_services WHERE slug = 'x-ray-chest'
UNION ALL SELECT id, 'Рендген плућа', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-chest'
UNION ALL SELECT id, 'Рентгенография органов грудной клетки', 'ru' FROM medical_services WHERE slug = 'x-ray-chest'
UNION ALL SELECT id, 'Röntgen-Thorax', 'de' FROM medical_services WHERE slug = 'x-ray-chest'
UNION ALL SELECT id, 'Akciğer grafisi', 'tr' FROM medical_services WHERE slug = 'x-ray-chest';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Aortic Ultrasound', 'en' FROM medical_services WHERE slug = 'aorta-ultrasound'
UNION ALL SELECT id, 'UZ aorte', 'sr' FROM medical_services WHERE slug = 'aorta-ultrasound'
UNION ALL SELECT id, 'УЗ аорте', 'sr-cyrl' FROM medical_services WHERE slug = 'aorta-ultrasound'
UNION ALL SELECT id, 'УЗИ брюшной аорты', 'ru' FROM medical_services WHERE slug = 'aorta-ultrasound'
UNION ALL SELECT id, 'УЗДГ аорты', 'ru' FROM medical_services WHERE slug = 'aorta-ultrasound'
UNION ALL SELECT id, 'Aortensonographie', 'de' FROM medical_services WHERE slug = 'aorta-ultrasound'
UNION ALL SELECT id, 'Aort USG', 'tr' FROM medical_services WHERE slug = 'aorta-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cardiologist Consultation', 'en' FROM medical_services WHERE slug = 'cardiologist-examination'
UNION ALL SELECT id, 'Cardiology Consultation', 'en' FROM medical_services WHERE slug = 'cardiologist-examination'
UNION ALL SELECT id, 'Kardiološki pregled', 'sr' FROM medical_services WHERE slug = 'cardiologist-examination'
UNION ALL SELECT id, 'Кардиолошки преглед', 'sr-cyrl' FROM medical_services WHERE slug = 'cardiologist-examination'
UNION ALL SELECT id, 'Konsultacija kardiologa', 'sr' FROM medical_services WHERE slug = 'cardiologist-examination'
UNION ALL SELECT id, 'Консултација кардиолога', 'sr-cyrl' FROM medical_services WHERE slug = 'cardiologist-examination'
UNION ALL SELECT id, 'Приём кардиолога', 'ru' FROM medical_services WHERE slug = 'cardiologist-examination'
UNION ALL SELECT id, 'Консультация кардиолога', 'ru' FROM medical_services WHERE slug = 'cardiologist-examination'
UNION ALL SELECT id, 'Untersuchung beim Kardiologen', 'de' FROM medical_services WHERE slug = 'cardiologist-examination'
UNION ALL SELECT id, 'Kardiyolog muayenesi', 'tr' FROM medical_services WHERE slug = 'cardiologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kardiološki pregled sa EKG-om', 'sr' FROM medical_services WHERE slug = 'cardiologist-examination-with-ecg'
UNION ALL SELECT id, 'Кардиолошки преглед са ЕКГ-ом', 'sr-cyrl' FROM medical_services WHERE slug = 'cardiologist-examination-with-ecg'
UNION ALL SELECT id, 'Приём кардиолога с ЭКГ', 'ru' FROM medical_services WHERE slug = 'cardiologist-examination-with-ecg';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Приём кардиолога с УЗИ', 'ru' FROM medical_services WHERE slug = 'cardiologist-examination-with-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Carotid Duplex Scan', 'en' FROM medical_services WHERE slug = 'carotid-artery-color-doppler'
UNION ALL SELECT id, 'Dopler karotida', 'sr' FROM medical_services WHERE slug = 'carotid-artery-color-doppler'
UNION ALL SELECT id, 'Доплер каротида', 'sr-cyrl' FROM medical_services WHERE slug = 'carotid-artery-color-doppler'
UNION ALL SELECT id, 'УЗДГ сонных артерий', 'ru' FROM medical_services WHERE slug = 'carotid-artery-color-doppler'
UNION ALL SELECT id, 'Дуплексное сканирование сонных артерий', 'ru' FROM medical_services WHERE slug = 'carotid-artery-color-doppler'
UNION ALL SELECT id, 'Доплер сонных артерий', 'ru' FROM medical_services WHERE slug = 'carotid-artery-color-doppler'
UNION ALL SELECT id, 'Karotis-Duplexsonographie', 'de' FROM medical_services WHERE slug = 'carotid-artery-color-doppler'
UNION ALL SELECT id, 'Karotis Doppler USG', 'tr' FROM medical_services WHERE slug = 'carotid-artery-color-doppler';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Electrocardiogram', 'en' FROM medical_services WHERE slug = 'ecg'
UNION ALL SELECT id, 'Electrocardiography', 'en' FROM medical_services WHERE slug = 'ecg'
UNION ALL SELECT id, 'Elektrokardiogram', 'sr' FROM medical_services WHERE slug = 'ecg'
UNION ALL SELECT id, 'Електрокардиограм', 'sr-cyrl' FROM medical_services WHERE slug = 'ecg'
UNION ALL SELECT id, 'Elektrokardiografija', 'sr' FROM medical_services WHERE slug = 'ecg'
UNION ALL SELECT id, 'Електрокардиографија', 'sr-cyrl' FROM medical_services WHERE slug = 'ecg'
UNION ALL SELECT id, 'Электрокардиограмма', 'ru' FROM medical_services WHERE slug = 'ecg'
UNION ALL SELECT id, 'Электрокардиография', 'ru' FROM medical_services WHERE slug = 'ecg'
UNION ALL SELECT id, 'Elektrokardiyografi', 'tr' FROM medical_services WHERE slug = 'ecg';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'ECG with Interpretation', 'en' FROM medical_services WHERE slug = 'ecg-recording-and-interpretation'
UNION ALL SELECT id, 'ЭКГ с расшифровкой', 'ru' FROM medical_services WHERE slug = 'ecg-recording-and-interpretation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Električna kardioverzija', 'sr' FROM medical_services WHERE slug = 'electric-cardioversion'
UNION ALL SELECT id, 'Електрична кардиоверзија', 'sr-cyrl' FROM medical_services WHERE slug = 'electric-cardioversion'
UNION ALL SELECT id, 'Электроимпульсная терапия', 'ru' FROM medical_services WHERE slug = 'electric-cardioversion'
UNION ALL SELECT id, 'ЭИТ', 'ru' FROM medical_services WHERE slug = 'electric-cardioversion'
UNION ALL SELECT id, 'Elektrokardioversion', 'de' FROM medical_services WHERE slug = 'electric-cardioversion';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'ABPM', 'en' FROM medical_services WHERE slug = 'holter-blood-pressure-24h'
UNION ALL SELECT id, '24-Hour Blood Pressure Monitoring', 'en' FROM medical_services WHERE slug = 'holter-blood-pressure-24h'
UNION ALL SELECT id, 'Holter pritiska', 'sr' FROM medical_services WHERE slug = 'holter-blood-pressure-24h'
UNION ALL SELECT id, 'Холтер притиска', 'sr-cyrl' FROM medical_services WHERE slug = 'holter-blood-pressure-24h'
UNION ALL SELECT id, 'СМАД', 'ru' FROM medical_services WHERE slug = 'holter-blood-pressure-24h'
UNION ALL SELECT id, 'Холтер давления', 'ru' FROM medical_services WHERE slug = 'holter-blood-pressure-24h'
UNION ALL SELECT id, 'Суточный мониторинг давления', 'ru' FROM medical_services WHERE slug = 'holter-blood-pressure-24h'
UNION ALL SELECT id, '24-Stunden-Blutdruckmessung', 'de' FROM medical_services WHERE slug = 'holter-blood-pressure-24h'
UNION ALL SELECT id, 'Tansiyon Holteri', 'tr' FROM medical_services WHERE slug = 'holter-blood-pressure-24h';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, '24-Hour Holter Monitoring', 'en' FROM medical_services WHERE slug = 'holter-ecg-24h'
UNION ALL SELECT id, 'Ambulatory ECG', 'en' FROM medical_services WHERE slug = 'holter-ecg-24h'
UNION ALL SELECT id, 'Holter srca', 'sr' FROM medical_services WHERE slug = 'holter-ecg-24h'
UNION ALL SELECT id, 'Холтер срца', 'sr-cyrl' FROM medical_services WHERE slug = 'holter-ecg-24h'
UNION ALL SELECT id, 'Суточное мониторирование ЭКГ', 'ru' FROM medical_services WHERE slug = 'holter-ecg-24h'
UNION ALL SELECT id, 'Холтер сердца', 'ru' FROM medical_services WHERE slug = 'holter-ecg-24h'
UNION ALL SELECT id, 'Langzeit-EKG', 'de' FROM medical_services WHERE slug = 'holter-ecg-24h'
UNION ALL SELECT id, 'Ritim Holter', 'tr' FROM medical_services WHERE slug = 'holter-ecg-24h';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Stres eho test', 'sr' FROM medical_services WHERE slug = 'stress-echocardiography'
UNION ALL SELECT id, 'Стрес ехо тест', 'sr-cyrl' FROM medical_services WHERE slug = 'stress-echocardiography'
UNION ALL SELECT id, 'Dinamska ehokardiografija', 'sr' FROM medical_services WHERE slug = 'stress-echocardiography'
UNION ALL SELECT id, 'Динамска ехокардиографија', 'sr-cyrl' FROM medical_services WHERE slug = 'stress-echocardiography'
UNION ALL SELECT id, 'Стресс-эхокардиография', 'ru' FROM medical_services WHERE slug = 'stress-echocardiography'
UNION ALL SELECT id, 'Стресс-ЭхоКГ', 'ru' FROM medical_services WHERE slug = 'stress-echocardiography'
UNION ALL SELECT id, 'Stressecho', 'de' FROM medical_services WHERE slug = 'stress-echocardiography';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Transoesophageal Echocardiography', 'en' FROM medical_services WHERE slug = 'transesophageal-echocardiography-tee'
UNION ALL SELECT id, 'Transezofagealna ehokardiografija', 'sr' FROM medical_services WHERE slug = 'transesophageal-echocardiography-tee'
UNION ALL SELECT id, 'Трансезофагеална ехокардиографија', 'sr-cyrl' FROM medical_services WHERE slug = 'transesophageal-echocardiography-tee'
UNION ALL SELECT id, 'ЧП ЭхоКГ', 'ru' FROM medical_services WHERE slug = 'transesophageal-echocardiography-tee'
UNION ALL SELECT id, 'Чреспищеводное УЗИ сердца', 'ru' FROM medical_services WHERE slug = 'transesophageal-echocardiography-tee'
UNION ALL SELECT id, 'Schluckecho', 'de' FROM medical_services WHERE slug = 'transesophageal-echocardiography-tee';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Uklanjanje materice abdominalnim putem', 'sr' FROM medical_services WHERE slug = 'abdominal-hysterectomy'
UNION ALL SELECT id, 'Уклањање материце абдоминалним путем', 'sr-cyrl' FROM medical_services WHERE slug = 'abdominal-hysterectomy'
UNION ALL SELECT id, 'Удаление матки полостным методом', 'ru' FROM medical_services WHERE slug = 'abdominal-hysterectomy'
UNION ALL SELECT id, 'Лапаротомная гистерэктомия', 'ru' FROM medical_services WHERE slug = 'abdominal-hysterectomy'
UNION ALL SELECT id, 'Abdominale Gebärmutterentfernung', 'de' FROM medical_services WHERE slug = 'abdominal-hysterectomy'
UNION ALL SELECT id, 'Açık ameliyatla rahim alınması', 'tr' FROM medical_services WHERE slug = 'abdominal-hysterectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cervix Biopsy', 'en' FROM medical_services WHERE slug = 'cervical-biopsy'
UNION ALL SELECT id, 'Biopsija cerviksa', 'sr' FROM medical_services WHERE slug = 'cervical-biopsy'
UNION ALL SELECT id, 'Биопсија цервикса', 'sr-cyrl' FROM medical_services WHERE slug = 'cervical-biopsy'
UNION ALL SELECT id, 'Portiobiopsie', 'de' FROM medical_services WHERE slug = 'cervical-biopsy'
UNION ALL SELECT id, 'Serviks biyopsisi', 'tr' FROM medical_services WHERE slug = 'cervical-biopsy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Presijecanje himena', 'sr' FROM medical_services WHERE slug = 'hymenotomy'
UNION ALL SELECT id, 'Пресијецање химена', 'sr-cyrl' FROM medical_services WHERE slug = 'hymenotomy'
UNION ALL SELECT id, 'Рассечение девственной плевы', 'ru' FROM medical_services WHERE slug = 'hymenotomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Labioplasty', 'en' FROM medical_services WHERE slug = 'labiaplasty'
UNION ALL SELECT id, 'Labioplastika', 'sr' FROM medical_services WHERE slug = 'labiaplasty'
UNION ALL SELECT id, 'Пластика половых губ', 'ru' FROM medical_services WHERE slug = 'labiaplasty'
UNION ALL SELECT id, 'Лабиапластика', 'ru' FROM medical_services WHERE slug = 'labiaplasty'
UNION ALL SELECT id, 'Schamlippenkorrektur', 'de' FROM medical_services WHERE slug = 'labiaplasty';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Laparoscopic Fibroid Removal', 'en' FROM medical_services WHERE slug = 'laparoscopic-myomectomy'
UNION ALL SELECT id, 'Laparoskopsko uklanjanje mioma', 'sr' FROM medical_services WHERE slug = 'laparoscopic-myomectomy'
UNION ALL SELECT id, 'Лапароскопско уклањање миома', 'sr-cyrl' FROM medical_services WHERE slug = 'laparoscopic-myomectomy'
UNION ALL SELECT id, 'Лапароскопическое удаление миомы матки', 'ru' FROM medical_services WHERE slug = 'laparoscopic-myomectomy'
UNION ALL SELECT id, 'Laparoskopische Myomentfernung', 'de' FROM medical_services WHERE slug = 'laparoscopic-myomectomy'
UNION ALL SELECT id, 'Laparoskopik miyom ameliyatı', 'tr' FROM medical_services WHERE slug = 'laparoscopic-myomectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Laparoscopic Fallopian Tube Removal', 'en' FROM medical_services WHERE slug = 'laparoscopic-salpingectomy'
UNION ALL SELECT id, 'Laparoskopsko uklanjanje jajovoda', 'sr' FROM medical_services WHERE slug = 'laparoscopic-salpingectomy'
UNION ALL SELECT id, 'Лапароскопско уклањање јајовода', 'sr-cyrl' FROM medical_services WHERE slug = 'laparoscopic-salpingectomy'
UNION ALL SELECT id, 'Лапароскопическое удаление маточной трубы', 'ru' FROM medical_services WHERE slug = 'laparoscopic-salpingectomy'
UNION ALL SELECT id, 'Laparoskopische Eileiterentfernung', 'de' FROM medical_services WHERE slug = 'laparoscopic-salpingectomy'
UNION ALL SELECT id, 'Laparoskopik tüp alınması', 'tr' FROM medical_services WHERE slug = 'laparoscopic-salpingectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Total Laparoscopic Hysterectomy', 'en' FROM medical_services WHERE slug = 'total-laparoscopic-abdominal-hysterectomy'
UNION ALL SELECT id, 'TLH', 'en' FROM medical_services WHERE slug = 'total-laparoscopic-abdominal-hysterectomy'
UNION ALL SELECT id, 'Laparoskopsko uklanjanje materice', 'sr' FROM medical_services WHERE slug = 'total-laparoscopic-abdominal-hysterectomy'
UNION ALL SELECT id, 'Лапароскопско уклањање материце', 'sr-cyrl' FROM medical_services WHERE slug = 'total-laparoscopic-abdominal-hysterectomy'
UNION ALL SELECT id, 'Лапароскопическая экстирпация матки', 'ru' FROM medical_services WHERE slug = 'total-laparoscopic-abdominal-hysterectomy'
UNION ALL SELECT id, 'Лапароскопическое удаление матки', 'ru' FROM medical_services WHERE slug = 'total-laparoscopic-abdominal-hysterectomy'
UNION ALL SELECT id, 'Laparoskopische Gebärmutterentfernung', 'de' FROM medical_services WHERE slug = 'total-laparoscopic-abdominal-hysterectomy'
UNION ALL SELECT id, 'Laparoskopik rahim alınması', 'tr' FROM medical_services WHERE slug = 'total-laparoscopic-abdominal-hysterectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Uklanjanje materice vaginalnim putem', 'sr' FROM medical_services WHERE slug = 'vaginal-hysterectomy'
UNION ALL SELECT id, 'Уклањање материце вагиналним путем', 'sr-cyrl' FROM medical_services WHERE slug = 'vaginal-hysterectomy'
UNION ALL SELECT id, 'Влагалищная экстирпация матки', 'ru' FROM medical_services WHERE slug = 'vaginal-hysterectomy'
UNION ALL SELECT id, 'Удаление матки влагалищным доступом', 'ru' FROM medical_services WHERE slug = 'vaginal-hysterectomy'
UNION ALL SELECT id, 'Vaginale Gebärmutterentfernung', 'de' FROM medical_services WHERE slug = 'vaginal-hysterectomy'
UNION ALL SELECT id, 'Vajinal yoldan rahim alınması', 'tr' FROM medical_services WHERE slug = 'vaginal-hysterectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cervical Polyp Removal', 'en' FROM medical_services WHERE slug = 'cervical-or-uterine-polypectomy'
UNION ALL SELECT id, 'Uklanjanje polipa grlića materice', 'sr' FROM medical_services WHERE slug = 'cervical-or-uterine-polypectomy'
UNION ALL SELECT id, 'Уклањање полипа грлића материце', 'sr-cyrl' FROM medical_services WHERE slug = 'cervical-or-uterine-polypectomy'
UNION ALL SELECT id, 'Удаление полипа шейки матки', 'ru' FROM medical_services WHERE slug = 'cervical-or-uterine-polypectomy'
UNION ALL SELECT id, 'Entfernung eines Zervixpolypen', 'de' FROM medical_services WHERE slug = 'cervical-or-uterine-polypectomy'
UNION ALL SELECT id, 'Rahim ağzı polibi alınması', 'tr' FROM medical_services WHERE slug = 'cervical-or-uterine-polypectomy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Cardiotocography', 'en' FROM medical_services WHERE slug = 'ctg-fetal-monitoring'
UNION ALL SELECT id, 'Non-Stress Test', 'en' FROM medical_services WHERE slug = 'ctg-fetal-monitoring'
UNION ALL SELECT id, 'Kardiotokografija', 'sr' FROM medical_services WHERE slug = 'ctg-fetal-monitoring'
UNION ALL SELECT id, 'Кардиотокографија', 'sr-cyrl' FROM medical_services WHERE slug = 'ctg-fetal-monitoring'
UNION ALL SELECT id, 'KTG', 'sr' FROM medical_services WHERE slug = 'ctg-fetal-monitoring'
UNION ALL SELECT id, 'Кардиотокография', 'ru' FROM medical_services WHERE slug = 'ctg-fetal-monitoring'
UNION ALL SELECT id, 'КТГ плода', 'ru' FROM medical_services WHERE slug = 'ctg-fetal-monitoring'
UNION ALL SELECT id, 'Wehenschreiber', 'de' FROM medical_services WHERE slug = 'ctg-fetal-monitoring'
UNION ALL SELECT id, 'NST', 'tr' FROM medical_services WHERE slug = 'ctg-fetal-monitoring'
UNION ALL SELECT id, 'Kardiyotokografi', 'tr' FROM medical_services WHERE slug = 'ctg-fetal-monitoring';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Transfer embriona', 'sr' FROM medical_services WHERE slug = 'embryo-transfer'
UNION ALL SELECT id, 'Трансфер ембриона', 'sr-cyrl' FROM medical_services WHERE slug = 'embryo-transfer'
UNION ALL SELECT id, 'Подсадка эмбрионов', 'ru' FROM medical_services WHERE slug = 'embryo-transfer'
UNION ALL SELECT id, 'Embryonentransfer', 'de' FROM medical_services WHERE slug = 'embryo-transfer';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Oocyte Retrieval', 'en' FROM medical_services WHERE slug = 'follicle-aspiration'
UNION ALL SELECT id, 'Egg Retrieval', 'en' FROM medical_services WHERE slug = 'follicle-aspiration'
UNION ALL SELECT id, 'Punkcija folikula', 'sr' FROM medical_services WHERE slug = 'follicle-aspiration'
UNION ALL SELECT id, 'Пункција фоликула', 'sr-cyrl' FROM medical_services WHERE slug = 'follicle-aspiration'
UNION ALL SELECT id, 'Пункция фолликулов', 'ru' FROM medical_services WHERE slug = 'follicle-aspiration'
UNION ALL SELECT id, 'Забор яйцеклеток', 'ru' FROM medical_services WHERE slug = 'follicle-aspiration'
UNION ALL SELECT id, 'Follikelpunktion', 'de' FROM medical_services WHERE slug = 'follicle-aspiration'
UNION ALL SELECT id, 'Eizellentnahme', 'de' FROM medical_services WHERE slug = 'follicle-aspiration'
UNION ALL SELECT id, 'Yumurta toplama', 'tr' FROM medical_services WHERE slug = 'follicle-aspiration';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kontrolni ginekološki pregled', 'sr' FROM medical_services WHERE slug = 'follow-up-gynecological-examination'
UNION ALL SELECT id, 'Контролни гинеколошки преглед', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-gynecological-examination'
UNION ALL SELECT id, 'Повторный приём гинеколога', 'ru' FROM medical_services WHERE slug = 'follow-up-gynecological-examination'
UNION ALL SELECT id, 'Kontrolluntersuchung beim Frauenarzt', 'de' FROM medical_services WHERE slug = 'follow-up-gynecological-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ginekološki bris', 'sr' FROM medical_services WHERE slug = 'gynecological-swab-collection'
UNION ALL SELECT id, 'Гинеколошки брис', 'sr-cyrl' FROM medical_services WHERE slug = 'gynecological-swab-collection'
UNION ALL SELECT id, 'Взятие мазка у гинеколога', 'ru' FROM medical_services WHERE slug = 'gynecological-swab-collection'
UNION ALL SELECT id, 'Vaginalabstrich', 'de' FROM medical_services WHERE slug = 'gynecological-swab-collection';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pap Smear', 'en' FROM medical_services WHERE slug = 'pap-test-with-smear-collection'
UNION ALL SELECT id, 'Papa bris', 'sr' FROM medical_services WHERE slug = 'pap-test-with-smear-collection'
UNION ALL SELECT id, 'Папа брис', 'sr-cyrl' FROM medical_services WHERE slug = 'pap-test-with-smear-collection'
UNION ALL SELECT id, 'Citološki bris po Papanikolau', 'sr' FROM medical_services WHERE slug = 'pap-test-with-smear-collection'
UNION ALL SELECT id, 'Цитолошки брис по Папаниколау', 'sr-cyrl' FROM medical_services WHERE slug = 'pap-test-with-smear-collection'
UNION ALL SELECT id, 'Мазок на онкоцитологию', 'ru' FROM medical_services WHERE slug = 'pap-test-with-smear-collection'
UNION ALL SELECT id, 'Мазок Папаниколау', 'ru' FROM medical_services WHERE slug = 'pap-test-with-smear-collection'
UNION ALL SELECT id, 'Pap-Abstrich', 'de' FROM medical_services WHERE slug = 'pap-test-with-smear-collection'
UNION ALL SELECT id, 'Krebsabstrich', 'de' FROM medical_services WHERE slug = 'pap-test-with-smear-collection'
UNION ALL SELECT id, 'Smear testi', 'tr' FROM medical_services WHERE slug = 'pap-test-with-smear-collection';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Obstetric Ultrasound', 'en' FROM medical_services WHERE slug = 'pregnancy-ultrasound'
UNION ALL SELECT id, 'Ultrazvuk u trudnoći', 'sr' FROM medical_services WHERE slug = 'pregnancy-ultrasound'
UNION ALL SELECT id, 'Ултразвук у трудноћи', 'sr-cyrl' FROM medical_services WHERE slug = 'pregnancy-ultrasound'
UNION ALL SELECT id, 'УЗИ плода', 'ru' FROM medical_services WHERE slug = 'pregnancy-ultrasound'
UNION ALL SELECT id, 'Акушерское УЗИ', 'ru' FROM medical_services WHERE slug = 'pregnancy-ultrasound'
UNION ALL SELECT id, 'Schwangerschaftsultraschall', 'de' FROM medical_services WHERE slug = 'pregnancy-ultrasound'
UNION ALL SELECT id, 'Gebelik USG', 'tr' FROM medical_services WHERE slug = 'pregnancy-ultrasound';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kompozitni ispun na mlečnom zubu', 'sr' FROM medical_services WHERE slug = 'composite-filling-on-primary-tooth'
UNION ALL SELECT id, 'Композитни испун на млечном зубу', 'sr-cyrl' FROM medical_services WHERE slug = 'composite-filling-on-primary-tooth';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pit and Fissure Sealing', 'en' FROM medical_services WHERE slug = 'dental-fissure-sealant'
UNION ALL SELECT id, 'Silanti', 'sr' FROM medical_services WHERE slug = 'dental-fissure-sealant'
UNION ALL SELECT id, 'Силанти', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-fissure-sealant'
UNION ALL SELECT id, 'Запечатывание фиссур', 'ru' FROM medical_services WHERE slug = 'dental-fissure-sealant';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'SDF', 'en' FROM medical_services WHERE slug = 'silver-diamine-fluoride-application'
UNION ALL SELECT id, 'Серебрение молочных зубов', 'ru' FROM medical_services WHERE slug = 'silver-diamine-fluoride-application';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Лечение зуба с несформированным корнем', 'ru' FROM medical_services WHERE slug = 'treatment-of-tooth-with-incomplete-root-growth';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Bioelectrical Impedance Analysis', 'en' FROM medical_services WHERE slug = 'body-composition-analysis'
UNION ALL SELECT id, 'Bioimpedansa', 'sr' FROM medical_services WHERE slug = 'body-composition-analysis'
UNION ALL SELECT id, 'Биоимпеданса', 'sr-cyrl' FROM medical_services WHERE slug = 'body-composition-analysis'
UNION ALL SELECT id, 'Analiza sastava tijela', 'sr' FROM medical_services WHERE slug = 'body-composition-analysis'
UNION ALL SELECT id, 'Анализа састава тијела', 'sr-cyrl' FROM medical_services WHERE slug = 'body-composition-analysis'
UNION ALL SELECT id, 'Analiza telesne kompozicije', 'sr' FROM medical_services WHERE slug = 'body-composition-analysis'
UNION ALL SELECT id, 'Анализа телесне композиције', 'sr-cyrl' FROM medical_services WHERE slug = 'body-composition-analysis'
UNION ALL SELECT id, 'Биоимпедансный анализ', 'ru' FROM medical_services WHERE slug = 'body-composition-analysis'
UNION ALL SELECT id, 'Биоимпедансометрия', 'ru' FROM medical_services WHERE slug = 'body-composition-analysis'
UNION ALL SELECT id, 'Bioimpedanzanalyse', 'de' FROM medical_services WHERE slug = 'body-composition-analysis'
UNION ALL SELECT id, 'Biyoempedans analizi', 'tr' FROM medical_services WHERE slug = 'body-composition-analysis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Family Doctor Visit', 'en' FROM medical_services WHERE slug = 'family-medicine-examination'
UNION ALL SELECT id, 'Pregled porodičnog ljekara', 'sr' FROM medical_services WHERE slug = 'family-medicine-examination'
UNION ALL SELECT id, 'Преглед породичног љекара', 'sr-cyrl' FROM medical_services WHERE slug = 'family-medicine-examination'
UNION ALL SELECT id, 'Porodični ljekar', 'sr' FROM medical_services WHERE slug = 'family-medicine-examination'
UNION ALL SELECT id, 'Породични љекар', 'sr-cyrl' FROM medical_services WHERE slug = 'family-medicine-examination'
UNION ALL SELECT id, 'Porodični lekar', 'sr' FROM medical_services WHERE slug = 'family-medicine-examination'
UNION ALL SELECT id, 'Породични лекар', 'sr-cyrl' FROM medical_services WHERE slug = 'family-medicine-examination'
UNION ALL SELECT id, 'Семейный врач', 'ru' FROM medical_services WHERE slug = 'family-medicine-examination'
UNION ALL SELECT id, 'Приём семейного врача', 'ru' FROM medical_services WHERE slug = 'family-medicine-examination'
UNION ALL SELECT id, 'Untersuchung beim Familienarzt', 'de' FROM medical_services WHERE slug = 'family-medicine-examination'
UNION ALL SELECT id, 'Aile hekimi muayenesi', 'tr' FROM medical_services WHERE slug = 'family-medicine-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'First Infectologist Examination', 'en' FROM medical_services WHERE slug = 'first-infectious-disease-specialist-examination'
UNION ALL SELECT id, 'Prvi pregled infektologa', 'sr' FROM medical_services WHERE slug = 'first-infectious-disease-specialist-examination'
UNION ALL SELECT id, 'Први преглед инфектолога', 'sr-cyrl' FROM medical_services WHERE slug = 'first-infectious-disease-specialist-examination'
UNION ALL SELECT id, 'Первичный осмотр инфекциониста', 'ru' FROM medical_services WHERE slug = 'first-infectious-disease-specialist-examination'
UNION ALL SELECT id, 'Первичный приём инфекциониста', 'ru' FROM medical_services WHERE slug = 'first-infectious-disease-specialist-examination'
UNION ALL SELECT id, 'Erstuntersuchung beim Infektiologen', 'de' FROM medical_services WHERE slug = 'first-infectious-disease-specialist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Prvi pregled nefrologa', 'sr' FROM medical_services WHERE slug = 'first-nephrologist-examination'
UNION ALL SELECT id, 'Први преглед нефролога', 'sr-cyrl' FROM medical_services WHERE slug = 'first-nephrologist-examination'
UNION ALL SELECT id, 'Первичный осмотр нефролога', 'ru' FROM medical_services WHERE slug = 'first-nephrologist-examination'
UNION ALL SELECT id, 'Первичный приём нефролога', 'ru' FROM medical_services WHERE slug = 'first-nephrologist-examination'
UNION ALL SELECT id, 'Erstuntersuchung beim Nephrologen', 'de' FROM medical_services WHERE slug = 'first-nephrologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Kontrolni pregled interniste', 'sr' FROM medical_services WHERE slug = 'follow-up-internist-examination'
UNION ALL SELECT id, 'Контролни преглед интернисте', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-internist-examination'
UNION ALL SELECT id, 'Ponovni pregled interniste', 'sr' FROM medical_services WHERE slug = 'follow-up-internist-examination'
UNION ALL SELECT id, 'Поновни преглед интернисте', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-internist-examination'
UNION ALL SELECT id, 'Повторный осмотр интерниста', 'ru' FROM medical_services WHERE slug = 'follow-up-internist-examination'
UNION ALL SELECT id, 'Контрольный осмотр врача-терапевта', 'ru' FROM medical_services WHERE slug = 'follow-up-internist-examination'
UNION ALL SELECT id, 'Kontrolluntersuchung beim Internisten', 'de' FROM medical_services WHERE slug = 'follow-up-internist-examination'
UNION ALL SELECT id, 'İç hastalıkları kontrol muayenesi', 'tr' FROM medical_services WHERE slug = 'follow-up-internist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Hematology Consultation', 'en' FROM medical_services WHERE slug = 'hematologist-examination'
UNION ALL SELECT id, 'Hematološki pregled', 'sr' FROM medical_services WHERE slug = 'hematologist-examination'
UNION ALL SELECT id, 'Хематолошки преглед', 'sr-cyrl' FROM medical_services WHERE slug = 'hematologist-examination'
UNION ALL SELECT id, 'Приём гематолога', 'ru' FROM medical_services WHERE slug = 'hematologist-examination'
UNION ALL SELECT id, 'Консультация гематолога', 'ru' FROM medical_services WHERE slug = 'hematologist-examination'
UNION ALL SELECT id, 'Untersuchung beim Hämatologen', 'de' FROM medical_services WHERE slug = 'hematologist-examination'
UNION ALL SELECT id, 'Hematolog muayenesi', 'tr' FROM medical_services WHERE slug = 'hematologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Internal Medicine Consultation', 'en' FROM medical_services WHERE slug = 'internist-examination'
UNION ALL SELECT id, 'Pregled interniste', 'sr' FROM medical_services WHERE slug = 'internist-examination'
UNION ALL SELECT id, 'Преглед интернисте', 'sr-cyrl' FROM medical_services WHERE slug = 'internist-examination'
UNION ALL SELECT id, 'Приём интерниста', 'ru' FROM medical_services WHERE slug = 'internist-examination'
UNION ALL SELECT id, 'Консультация интерниста', 'ru' FROM medical_services WHERE slug = 'internist-examination'
UNION ALL SELECT id, 'Осмотр врача-терапевта', 'ru' FROM medical_services WHERE slug = 'internist-examination'
UNION ALL SELECT id, 'Untersuchung beim Internisten', 'de' FROM medical_services WHERE slug = 'internist-examination'
UNION ALL SELECT id, 'İç hastalıkları muayenesi', 'tr' FROM medical_services WHERE slug = 'internist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Sports Medical Certificate', 'en' FROM medical_services WHERE slug = 'medical-certificate-for-athletes'
UNION ALL SELECT id, 'Lekarsko uverenje za sportiste', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-athletes'
UNION ALL SELECT id, 'Лекарско уверење за спортисте', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-athletes'
UNION ALL SELECT id, 'Справка для занятий спортом', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-athletes'
UNION ALL SELECT id, 'Sportattest', 'de' FROM medical_services WHERE slug = 'medical-certificate-for-athletes'
UNION ALL SELECT id, 'Sporcu sağlık raporu', 'tr' FROM medical_services WHERE slug = 'medical-certificate-for-athletes';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Boat License Medical Certificate', 'en' FROM medical_services WHERE slug = 'medical-certificate-for-boat-operation-up-to-12-meters'
UNION ALL SELECT id, 'Lekarsko uverenje za upravljanje čamcem', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-boat-operation-up-to-12-meters'
UNION ALL SELECT id, 'Лекарско уверење за управљање чамцем', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-boat-operation-up-to-12-meters'
UNION ALL SELECT id, 'Справка на права на лодку', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-boat-operation-up-to-12-meters'
UNION ALL SELECT id, 'Attest für den Bootsführerschein', 'de' FROM medical_services WHERE slug = 'medical-certificate-for-boat-operation-up-to-12-meters'
UNION ALL SELECT id, 'Tekne ehliyeti sağlık raporu', 'tr' FROM medical_services WHERE slug = 'medical-certificate-for-boat-operation-up-to-12-meters';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Medical Certificate for Dormitory', 'en' FROM medical_services WHERE slug = 'medical-certificate-for-collective-accommodation'
UNION ALL SELECT id, 'Lekarsko uverenje za kolektivni smeštaj', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-collective-accommodation'
UNION ALL SELECT id, 'Лекарско уверење за колективни смештај', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-collective-accommodation'
UNION ALL SELECT id, 'Ljekarsko uvjerenje za studentski dom', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-collective-accommodation'
UNION ALL SELECT id, 'Љекарско увјерење за студентски дом', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-collective-accommodation'
UNION ALL SELECT id, 'Справка для общежития', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-collective-accommodation'
UNION ALL SELECT id, 'Yurt sağlık raporu', 'tr' FROM medical_services WHERE slug = 'medical-certificate-for-collective-accommodation';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lekarsko uverenje za sudskog veštaka', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-court-expert'
UNION ALL SELECT id, 'Лекарско уверење за судског вештака', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-court-expert';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Biyorevitalizasyon', 'tr' FROM medical_services WHERE slug = 'biorevitalization';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Dermatology Consultation', 'en' FROM medical_services WHERE slug = 'dermatologist-examination'
UNION ALL SELECT id, 'Dermatološki pregled', 'sr' FROM medical_services WHERE slug = 'dermatologist-examination'
UNION ALL SELECT id, 'Дерматолошки преглед', 'sr-cyrl' FROM medical_services WHERE slug = 'dermatologist-examination'
UNION ALL SELECT id, 'Pregled dermatovenerologa', 'sr' FROM medical_services WHERE slug = 'dermatologist-examination'
UNION ALL SELECT id, 'Преглед дерматовенеролога', 'sr-cyrl' FROM medical_services WHERE slug = 'dermatologist-examination'
UNION ALL SELECT id, 'Приём дерматолога', 'ru' FROM medical_services WHERE slug = 'dermatologist-examination'
UNION ALL SELECT id, 'Консультация дерматолога', 'ru' FROM medical_services WHERE slug = 'dermatologist-examination'
UNION ALL SELECT id, 'Приём дерматовенеролога', 'ru' FROM medical_services WHERE slug = 'dermatologist-examination'
UNION ALL SELECT id, 'Untersuchung beim Hautarzt', 'de' FROM medical_services WHERE slug = 'dermatologist-examination'
UNION ALL SELECT id, 'Cildiye muayenesi', 'tr' FROM medical_services WHERE slug = 'dermatologist-examination'
UNION ALL SELECT id, 'Dermatolog muayenesi', 'tr' FROM medical_services WHERE slug = 'dermatologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Dermoscopy', 'en' FROM medical_services WHERE slug = 'dermatoscopy'
UNION ALL SELECT id, 'Mole Check', 'en' FROM medical_services WHERE slug = 'dermatoscopy'
UNION ALL SELECT id, 'Dermoskopija', 'sr' FROM medical_services WHERE slug = 'dermatoscopy'
UNION ALL SELECT id, 'Дермоскопија', 'sr-cyrl' FROM medical_services WHERE slug = 'dermatoscopy'
UNION ALL SELECT id, 'Pregled mladeža', 'sr' FROM medical_services WHERE slug = 'dermatoscopy'
UNION ALL SELECT id, 'Преглед младежа', 'sr-cyrl' FROM medical_services WHERE slug = 'dermatoscopy'
UNION ALL SELECT id, 'Дермоскопия', 'ru' FROM medical_services WHERE slug = 'dermatoscopy'
UNION ALL SELECT id, 'Проверка родинок', 'ru' FROM medical_services WHERE slug = 'dermatoscopy'
UNION ALL SELECT id, 'Auflichtmikroskopie', 'de' FROM medical_services WHERE slug = 'dermatoscopy'
UNION ALL SELECT id, 'Muttermalkontrolle', 'de' FROM medical_services WHERE slug = 'dermatoscopy'
UNION ALL SELECT id, 'Ben kontrolü', 'tr' FROM medical_services WHERE slug = 'dermatoscopy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Плазмолифтинг лица', 'ru' FROM medical_services WHERE slug = 'prp-facial-treatment'
UNION ALL SELECT id, 'Плазмотерапия лица', 'ru' FROM medical_services WHERE slug = 'prp-facial-treatment'
UNION ALL SELECT id, 'Eigenbluttherapie im Gesicht', 'de' FROM medical_services WHERE slug = 'prp-facial-treatment';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Scar Revision', 'en' FROM medical_services WHERE slug = 'scar-correction'
UNION ALL SELECT id, 'Uklanjanje ožiljaka', 'sr' FROM medical_services WHERE slug = 'scar-correction'
UNION ALL SELECT id, 'Уклањање ожиљака', 'sr-cyrl' FROM medical_services WHERE slug = 'scar-correction'
UNION ALL SELECT id, 'Korekcija ožiljaka', 'sr' FROM medical_services WHERE slug = 'scar-correction'
UNION ALL SELECT id, 'Корекција ожиљака', 'sr-cyrl' FROM medical_services WHERE slug = 'scar-correction'
UNION ALL SELECT id, 'Коррекция шрама', 'ru' FROM medical_services WHERE slug = 'scar-correction'
UNION ALL SELECT id, 'Удаление шрамов', 'ru' FROM medical_services WHERE slug = 'scar-correction'
UNION ALL SELECT id, 'Narbenentfernung', 'de' FROM medical_services WHERE slug = 'scar-correction'
UNION ALL SELECT id, 'Yara izi giderme', 'tr' FROM medical_services WHERE slug = 'scar-correction';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Gun License Medical Certificate', 'en' FROM medical_services WHERE slug = 'medical-certificate-for-firearms-possession'
UNION ALL SELECT id, 'Ljekarsko uvjerenje za oružni list', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-firearms-possession'
UNION ALL SELECT id, 'Љекарско увјерење за оружни лист', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-firearms-possession'
UNION ALL SELECT id, 'Lekarsko uverenje za oružje', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-firearms-possession'
UNION ALL SELECT id, 'Лекарско уверење за оружје', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-firearms-possession'
UNION ALL SELECT id, 'Медсправка на оружие', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-firearms-possession'
UNION ALL SELECT id, 'Справка для лицензии на оружие', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-firearms-possession'
UNION ALL SELECT id, 'Attest für den Waffenschein', 'de' FROM medical_services WHERE slug = 'medical-certificate-for-firearms-possession'
UNION ALL SELECT id, 'Silah Ruhsatı Sağlık Raporu', 'tr' FROM medical_services WHERE slug = 'medical-certificate-for-firearms-possession';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lekarsko uverenje za životno osiguranje', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-life-insurance'
UNION ALL SELECT id, 'Лекарско уверење за животно осигурање', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-life-insurance';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lekarsko uverenje za spasioce', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-lifeguards'
UNION ALL SELECT id, 'Лекарско уверење за спасиоце', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-lifeguards';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Seafarer Medical Certificate', 'en' FROM medical_services WHERE slug = 'medical-certificate-for-maritime-workers'
UNION ALL SELECT id, 'Ljekarsko uvjerenje za pomorce', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-maritime-workers'
UNION ALL SELECT id, 'Љекарско увјерење за поморце', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-maritime-workers'
UNION ALL SELECT id, 'Lekarsko uverenje za pomorce', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-maritime-workers'
UNION ALL SELECT id, 'Лекарско уверење за поморце', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-maritime-workers'
UNION ALL SELECT id, 'Медицинская справка для моряков', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-maritime-workers'
UNION ALL SELECT id, 'Медкомиссия для моряков', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-maritime-workers'
UNION ALL SELECT id, 'Seediensttauglichkeitsuntersuchung', 'de' FROM medical_services WHERE slug = 'medical-certificate-for-maritime-workers'
UNION ALL SELECT id, 'Gemiadamı Sağlık Raporu', 'tr' FROM medical_services WHERE slug = 'medical-certificate-for-maritime-workers';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ljekarsko uvjerenje za vojsku', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-military-service'
UNION ALL SELECT id, 'Љекарско увјерење за војску', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-military-service'
UNION ALL SELECT id, 'Lekarsko uverenje za vojsku', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-military-service'
UNION ALL SELECT id, 'Лекарско уверење за војску', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-military-service'
UNION ALL SELECT id, 'Медицинская справка для службы в армии', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-military-service'
UNION ALL SELECT id, 'Askerlik Sağlık Raporu', 'tr' FROM medical_services WHERE slug = 'medical-certificate-for-military-service';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Lekarsko uverenje za profesionalne vozače', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-professional-drivers'
UNION ALL SELECT id, 'Лекарско уверење за професионалне возаче', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-professional-drivers';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Residence Permit Medical Certificate', 'en' FROM medical_services WHERE slug = 'medical-certificate-for-residence-and-work-in-montenegro'
UNION ALL SELECT id, 'Work Permit Medical Certificate', 'en' FROM medical_services WHERE slug = 'medical-certificate-for-residence-and-work-in-montenegro'
UNION ALL SELECT id, 'Ljekarsko uvjerenje za privremeni boravak i rad', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-residence-and-work-in-montenegro'
UNION ALL SELECT id, 'Љекарско увјерење за привремени боравак и рад', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-residence-and-work-in-montenegro'
UNION ALL SELECT id, 'Lekarsko uverenje za boravak i rad', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-residence-and-work-in-montenegro'
UNION ALL SELECT id, 'Лекарско уверење за боравак и рад', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-residence-and-work-in-montenegro'
UNION ALL SELECT id, 'Медицинская справка для ВНЖ', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-residence-and-work-in-montenegro'
UNION ALL SELECT id, 'Справка для вида на жительство', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-residence-and-work-in-montenegro'
UNION ALL SELECT id, 'Справка для боравка', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-residence-and-work-in-montenegro'
UNION ALL SELECT id, 'Gesundheitszeugnis für die Aufenthaltserlaubnis', 'de' FROM medical_services WHERE slug = 'medical-certificate-for-residence-and-work-in-montenegro'
UNION ALL SELECT id, 'Oturma İzni İçin Sağlık Raporu', 'tr' FROM medical_services WHERE slug = 'medical-certificate-for-residence-and-work-in-montenegro';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Student Visa Medical Certificate', 'en' FROM medical_services WHERE slug = 'medical-certificate-for-study-abroad-and-visa'
UNION ALL SELECT id, 'Ljekarsko uvjerenje za vizu', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-study-abroad-and-visa'
UNION ALL SELECT id, 'Љекарско увјерење за визу', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-study-abroad-and-visa'
UNION ALL SELECT id, 'Lekarsko uverenje za školovanje u inostranstvu', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-study-abroad-and-visa'
UNION ALL SELECT id, 'Лекарско уверење за школовање у иностранству', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-study-abroad-and-visa'
UNION ALL SELECT id, 'Медицинская справка для визы', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-study-abroad-and-visa'
UNION ALL SELECT id, 'Справка для учёбы за границей', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-study-abroad-and-visa'
UNION ALL SELECT id, 'Öğrenci Vizesi İçin Sağlık Raporu', 'tr' FROM medical_services WHERE slug = 'medical-certificate-for-study-abroad-and-visa';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pregled onkologa', 'sr' FROM medical_services WHERE slug = 'oncologist-examination'
UNION ALL SELECT id, 'Преглед онколога', 'sr-cyrl' FROM medical_services WHERE slug = 'oncologist-examination'
UNION ALL SELECT id, 'Onkološki pregled', 'sr' FROM medical_services WHERE slug = 'oncologist-examination'
UNION ALL SELECT id, 'Онколошки преглед', 'sr-cyrl' FROM medical_services WHERE slug = 'oncologist-examination'
UNION ALL SELECT id, 'Приём онколога', 'ru' FROM medical_services WHERE slug = 'oncologist-examination'
UNION ALL SELECT id, 'Untersuchung beim Onkologen', 'de' FROM medical_services WHERE slug = 'oncologist-examination'
UNION ALL SELECT id, 'Onkolog Muayenesi', 'tr' FROM medical_services WHERE slug = 'oncologist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Health Check-up Package 1', 'en' FROM medical_services WHERE slug = 'systematic-examination-package-1'
UNION ALL SELECT id, 'Чекап, пакет 1', 'ru' FROM medical_services WHERE slug = 'systematic-examination-package-1'
UNION ALL SELECT id, 'Комплексное обследование, пакет 1', 'ru' FROM medical_services WHERE slug = 'systematic-examination-package-1'
UNION ALL SELECT id, 'Check-up Paketi 1', 'tr' FROM medical_services WHERE slug = 'systematic-examination-package-1';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Health Check-up Package 2', 'en' FROM medical_services WHERE slug = 'systematic-examination-package-2'
UNION ALL SELECT id, 'Чекап, пакет 2', 'ru' FROM medical_services WHERE slug = 'systematic-examination-package-2'
UNION ALL SELECT id, 'Комплексное обследование, пакет 2', 'ru' FROM medical_services WHERE slug = 'systematic-examination-package-2'
UNION ALL SELECT id, 'Check-up Paketi 2', 'tr' FROM medical_services WHERE slug = 'systematic-examination-package-2';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Behavior Therapy', 'en' FROM medical_services WHERE slug = 'behavioral-psychotherapy'
UNION ALL SELECT id, 'Behavioral Therapy', 'en' FROM medical_services WHERE slug = 'behavioral-psychotherapy'
UNION ALL SELECT id, 'Bihejvioralna terapija', 'sr' FROM medical_services WHERE slug = 'behavioral-psychotherapy'
UNION ALL SELECT id, 'Бихејвиорална терапија', 'sr-cyrl' FROM medical_services WHERE slug = 'behavioral-psychotherapy'
UNION ALL SELECT id, 'Bihevioralna terapija', 'sr' FROM medical_services WHERE slug = 'behavioral-psychotherapy'
UNION ALL SELECT id, 'Бихевиорална терапија', 'sr-cyrl' FROM medical_services WHERE slug = 'behavioral-psychotherapy'
UNION ALL SELECT id, 'Поведенческая терапия', 'ru' FROM medical_services WHERE slug = 'behavioral-psychotherapy'
UNION ALL SELECT id, 'Бихевиоральная терапия', 'ru' FROM medical_services WHERE slug = 'behavioral-psychotherapy'
UNION ALL SELECT id, 'Davranış terapisi', 'tr' FROM medical_services WHERE slug = 'behavioral-psychotherapy';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Maintenance Hemodialysis', 'en' FROM medical_services WHERE slug = 'chronic-hemodialysis-session'
UNION ALL SELECT id, 'Программный гемодиализ', 'ru' FROM medical_services WHERE slug = 'chronic-hemodialysis-session';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'ПЗПТ', 'ru' FROM medical_services WHERE slug = 'continuous-renal-replacement-therapy-crrt'
UNION ALL SELECT id, 'SRRT', 'tr' FROM medical_services WHERE slug = 'continuous-renal-replacement-therapy-crrt';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Psychiatric Consultation', 'en' FROM medical_services WHERE slug = 'first-psychiatrist-examination'
UNION ALL SELECT id, 'Pregled kod psihijatra', 'sr' FROM medical_services WHERE slug = 'first-psychiatrist-examination'
UNION ALL SELECT id, 'Преглед код психијатра', 'sr-cyrl' FROM medical_services WHERE slug = 'first-psychiatrist-examination'
UNION ALL SELECT id, 'Консультация психиатра', 'ru' FROM medical_services WHERE slug = 'first-psychiatrist-examination'
UNION ALL SELECT id, 'Psikiyatrist muayenesi', 'tr' FROM medical_services WHERE slug = 'first-psychiatrist-examination';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Collateral History', 'en' FROM medical_services WHERE slug = 'heteroanamnesis'
UNION ALL SELECT id, 'Объективный анамнез', 'ru' FROM medical_services WHERE slug = 'heteroanamnesis'
UNION ALL SELECT id, 'Сбор анамнеза у родственников', 'ru' FROM medical_services WHERE slug = 'heteroanamnesis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Acid Loading Test', 'en' FROM medical_services WHERE slug = 'loading-tests-for-suspected-renal-tubular-acidosis'
UNION ALL SELECT id, 'Säurebelastungstest', 'de' FROM medical_services WHERE slug = 'loading-tests-for-suspected-renal-tubular-acidosis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Pelvic MRI', 'en' FROM medical_services WHERE slug = 'mri-pelvis'
UNION ALL SELECT id, 'Magnetna rezonanca male karlice', 'sr' FROM medical_services WHERE slug = 'mri-pelvis'
UNION ALL SELECT id, 'Магнетна резонанца мале карлице', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-pelvis'
UNION ALL SELECT id, 'Becken-MRT', 'de' FROM medical_services WHERE slug = 'mri-pelvis'
UNION ALL SELECT id, 'Pelvik MR', 'tr' FROM medical_services WHERE slug = 'mri-pelvis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Peritonealna dijaliza', 'sr' FROM medical_services WHERE slug = 'peritoneal-dialysis'
UNION ALL SELECT id, 'Перитонеална дијализа', 'sr-cyrl' FROM medical_services WHERE slug = 'peritoneal-dialysis'
UNION ALL SELECT id, 'Bauchfelldialyse', 'de' FROM medical_services WHERE slug = 'peritoneal-dialysis'
UNION ALL SELECT id, 'Karın zarı diyalizi', 'tr' FROM medical_services WHERE slug = 'peritoneal-dialysis';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Relaxation Training', 'en' FROM medical_services WHERE slug = 'relaxation-technique'
UNION ALL SELECT id, 'Tehnike relaksacije', 'sr' FROM medical_services WHERE slug = 'relaxation-technique'
UNION ALL SELECT id, 'Технике релаксације', 'sr-cyrl' FROM medical_services WHERE slug = 'relaxation-technique'
UNION ALL SELECT id, 'Техники релаксации', 'ru' FROM medical_services WHERE slug = 'relaxation-technique'
UNION ALL SELECT id, 'Релаксационная терапия', 'ru' FROM medical_services WHERE slug = 'relaxation-technique'
UNION ALL SELECT id, 'Entspannungstraining', 'de' FROM medical_services WHERE slug = 'relaxation-technique'
UNION ALL SELECT id, 'Gevşeme egzersizleri', 'tr' FROM medical_services WHERE slug = 'relaxation-technique';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Urine Concentration Test', 'en' FROM medical_services WHERE slug = 'renal-concentration-test'
UNION ALL SELECT id, 'Концентрационная проба', 'ru' FROM medical_services WHERE slug = 'renal-concentration-test';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Renal Tubular Function Test', 'en' FROM medical_services WHERE slug = 'tubular-function-test'
UNION ALL SELECT id, 'Исследование функции почечных канальцев', 'ru' FROM medical_services WHERE slug = 'tubular-function-test';

COMMIT;
