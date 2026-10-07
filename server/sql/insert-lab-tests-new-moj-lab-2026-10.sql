-- ═══════════════════════════════════════════════════════════════════════════
-- Moj Lab: новые записи каталога анализов + привязка к 9 лабораториям (2026-10-04)
-- Применять ПОСЛЕ insert-clinic-lab-tests-moj-lab-rules-2026-10.sql.
--
-- Источник — перечень https://mojlab.me/laboratorija (снимок
-- data/clinic-pricelists/sources/moj-lab-laboratorija-podgorica-moskovska/2026-10-02.html).
-- Это позиции, которых не было в каталоге: 172 после сопоставления + 26 по правилам A–F = 198.
-- Цен нет — price NULL. Разбор: data/clinic-imports/moj-lab-labtests-2026-10.md.
--
-- Состав:
--   139 новых записей lab_tests (переводы — агенты по батчам, name_sr_cyrl —
--       scripts/common/sr-cyrl-names.mjs + латиница для обозначений аналитов/генов
--       по конвенции каталога: HDL, RNK, DNK, IgG; NIPT-продукты целиком латиницей);
--   46 записей — те же, что заводит НЕприменённый insert-clinic-prices-tesla-medical-berane-lab.sql:
--       строки и категории скопированы оттуда один в один (ON DUPLICATE KEY), поэтому
--       порядок применения двух файлов не важен;
--   3 записи — то же для других неприменённых импортов: nail-swab-for-bacteria ← insert-clinic-prices-poliklinika-diagnostica-podgorica.sql; non-hdl-cholesterol ← insert-clinic-prices-poliklinika-diagnostica-podgorica.sql; dopamine ← insert-clinic-prices-klinicki-centar-crne-gore-podgorica.sql;
--   1 существующая запись (anti-sm-antibodies), не найденная на шаге сопоставления;
--   7 позиций патогистологии привязаны к УСЛУГАМ (clinic_medical_services):
--       в каталоге они заведены услугами (импорт КЦЦГ), заводить анализы-двойники не стали.
-- Две строки сайта — дубли других (F. tularensis IgM ×2, Sequentia Kario/Karyo) — одна запись.
--
-- Идемпотентно: lab_tests — ON DUPLICATE KEY (UNIQUE slug и name_en), связи — INSERT IGNORE.
-- Только по slug.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

START TRANSACTION;

-- ═══ 1. Записи каталога ═══

INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Eyelid Swab for Bacteria', 'eyelid-swab-bacteria', 'Bris kapka na bakterije', 'Брис капка на бактерије', 'Мазок с века на бактерии', 'Lidabstrich auf Bakterien', 'Göz Kapağı Sürüntüsünde Bakteri'),
('Eyelid Swab for Fungi', 'eyelid-swab-fungi', 'Bris kapka na gljivice', 'Брис капка на гљивице', 'Мазок с века на грибы', 'Lidabstrich auf Pilze', 'Göz Kapağı Sürüntüsünde Mantar'),
('Swab for Bacteria (Catheter, Cyst, Other Material)', 'swab-bacteria-catheter-cyst-other', 'Bris na bakterije (kateter, cista i dr.)', 'Брис на бактерије (катетер, циста и др.)', 'Мазок на бактерии (катетер, киста и др.)', 'Abstrich auf Bakterien (Katheter, Zyste u. a.)', 'Sürüntüde Bakteri (Kateter, Kist vb.)'),
('Swab for Fungi (Catheter, Cyst, Other Material)', 'swab-fungi-catheter-cyst-other', 'Bris na gljivice (kateter, cista i dr.)', 'Брис на гљивице (катетер, циста и др.)', 'Мазок на грибы (катетер, киста и др.)', 'Abstrich auf Pilze (Katheter, Zyste u. a.)', 'Sürüntüde Mantar (Kateter, Kist vb.)'),
('Nail Swab for Bacteria', 'nail-swab-for-bacteria', 'Bris nokta na bakterije', 'Брис нокта на бактерије', 'Мазок с ногтя на бактерии', 'Nagelabstrich auf Bakterien', 'Tırnak Sürüntüsünde Bakteri'),
('Tracheostomy Swab for Fungi', 'tracheostomy-swab-fungi', 'Bris traheostome na gljivice', 'Брис трахеостоме на гљивице', 'Мазок из трахеостомы на грибы', 'Tracheostomaabstrich auf Pilze', 'Trakeostomi Sürüntüsünde Mantar'),
('Enterovirus Antigen Rapid Test', 'enterovirus-antigen-rapid-test', 'Enterovirus antigen – brzi test (imunohromatografija)', 'Ентеровирус антиген – брзи тест (имунохроматографија)', 'Энтеровирус – экспресс-тест на антиген (иммунохроматография)', 'Enterovirus-Antigen-Schnelltest (Immunchromatographie)', 'Enterovirüs Antijen Hızlı Testi (İmmünokromatografi)'),
('Adenovirus Respiratory Test (Eye Swab)', 'adenovirus-respiratory-test-eye-swab', 'Adenovirus respiratorni test (bris oka)', 'Аденовирус респираторни тест (брис ока)', 'Тест на аденовирус (мазок из глаза)', 'Adenovirus-Atemwegstest (Augenabstrich)', 'Adenovirüs Solunum Testi (Göz Sürüntüsü)'),
('RSV Antigen Rapid Test', 'rsv-antigen-rapid-test', 'RSV antigen – brzi test (respiratorni sincicijalni virus)', 'RSV антиген – брзи тест (респираторни синцицијални вирус)', 'Экспресс-тест на антиген RSV (респираторно-синцитиальный вирус)', 'RSV-Antigen-Schnelltest (Respiratorisches Synzytial-Virus)', 'RSV Antijen Hızlı Testi (Respiratuvar Sinsityal Virüs)'),
('SARS-CoV-2, Influenza A/B and RSV Antigen Rapid Test', 'sars-cov-2-influenza-ab-rsv-antigen-rapid-test', 'Imunohromatografski test SARS-CoV-2 + influenca A + influenca B + RSV', 'Имунохроматографски тест SARS-CoV-2 + инфлуенца A + инфлуенца B + RSV', 'Экспресс-тест на антигены SARS-CoV-2, гриппа A/B и RSV', 'Antigen-Schnelltest SARS-CoV-2, Influenza A/B und RSV', 'SARS-CoV-2, İnfluenza A/B ve RSV Antijen Hızlı Testi'),
('Yersinia enterocolitica Detection', 'yersinia-enterocolitica-detection', 'Yersinia enterocolitica', 'Yersinia enterocolitica', 'Выявление Yersinia enterocolitica', 'Nachweis von Yersinia enterocolitica', 'Yersinia enterocolitica Tespiti'),
('Platelets in Citrated Blood', 'platelets-in-citrated-blood', 'Trombociti na citratu', 'Тромбоцити на цитрату', 'Тромбоциты в цитратной крови', 'Thrombozyten im Citratblut', 'Sitratlı Kanda Trombosit'),
('Non-HDL Cholesterol', 'non-hdl-cholesterol', 'Non-HDL holesterol', 'Non-HDL холестерол', 'Холестерин не-ЛПВП', 'Non-HDL-Cholesterin', 'HDL Dışı Kolesterol'),
('Atherogenic Index', 'atherogenic-index', 'Indeks ateroskleroze', 'Индекс атеросклерозе', 'Индекс атерогенности', 'Atherogener Index', 'Aterojenik İndeks'),
('ACE in CSF', 'ace-in-csf', 'Angiotenzin konvertujući enzim u likvoru', 'Ангиотензин конвертујући ензим у ликвору', 'Ангиотензинпревращающий фермент в ликворе', 'Angiotensin-Converting-Enzym im Liquor', 'BOS''ta Anjiyotensin Dönüştürücü Enzim'),
('Tartrate-Resistant Acid Phosphatase', 'tartrate-resistant-acid-phosphatase', 'Tartarat-rezistentna kisela fosfataza', 'Тартарат-резистентна кисела фосфатаза', 'Тартрат-резистентная кислая фосфатаза', 'Tartratresistente saure Phosphatase', 'Tartarata Dirençli Asit Fosfataz'),
('Cortisol in Saliva', 'cortisol-in-saliva', 'Kortizol u pljuvački', 'Кортизол у пљувачки', 'Кортизол в слюне', 'Cortisol im Speichel', 'Tükürükte Kortizol'),
('Androstanediol Glucuronide', 'androstanediol-glucuronide', 'Androstandiol glukuronid', 'Андростандиол глукуронид', 'Андростандиол глюкуронид', 'Androstandiolglucuronid', 'Androstanediol Glukuronid'),
('3-Methoxytyramine in Urine', '3-methoxytyramine-in-urine', '3-metoksitiramin u urinu', '3-метокситирамин у урину', '3-метокситирамин в моче', '3-Methoxytyramin im Urin', 'İdrarda 3-Metoksitiramin'),
('Dopamine', 'dopamine', 'Dopamin', 'Допамин', 'Дофамин', 'Dopamin', 'Dopamin'),
('PIVKA-II', 'pivka-ii', 'PIVKA-II', 'PIVKA-II', 'PIVKA-II', 'PIVKA-II', 'PIVKA-II'),
('Vitamin B3', 'vitamin-b3', 'Vitamin B3', 'Витамин B3', 'Витамин B3', 'Vitamin B3', 'Vitamin B3'),
('Vitamin B5', 'vitamin-b5', 'Vitamin B5', 'Витамин B5', 'Витамин B5', 'Vitamin B5', 'Vitamin B5'),
('Uroporphyrin in Urine', 'uroporphyrin-in-urine', 'Uroporfirin u urinu', 'Уропорфирин у урину', 'Уропорфирин в моче', 'Uroporphyrin im Urin', 'İdrarda Üroporfirin'),
('Drug and Psychoactive Substance Screen (3000 Metabolites)', 'drug-and-psychoactive-substance-screen-3000-metabolites', 'Ljekovi i psihoaktivne supstance (3000 metabolita)', 'Љекови и психоактивне супстанце (3000 метаболита)', 'Скрининг лекарств и психоактивных веществ (3000 метаболитов)', 'Screening auf Arzneimittel und psychoaktive Substanzen (3000 Metaboliten)', 'İlaç ve Psikoaktif Madde Taraması (3000 Metabolit)'),
('Psychoactive Substances in Hair', 'psychoactive-substances-in-hair', 'Psihoaktivne supstance u kosi', 'Психоактивне супстанце у коси', 'Психоактивные вещества в волосах', 'Psychoaktive Substanzen im Haar', 'Saçta Psikoaktif Maddeler'),
('Bromide', 'bromide', 'Bromidi', 'Бромиди', 'Бромиды', 'Bromid', 'Bromür'),
('Fluoride', 'fluoride', 'Fluorid', 'Флуорид', 'Фторид', 'Fluorid', 'Florür'),
('Tin', 'tin', 'Kalaj', 'Калај', 'Олово', 'Zinn', 'Kalay'),
('Silver', 'silver', 'Srebro', 'Сребро', 'Серебро', 'Silber', 'Gümüş'),
('Sulfur', 'sulfur', 'Sumpor', 'Сумпор', 'Сера', 'Schwefel', 'Kükürt'),
('Hair Mineral Analysis (35 Elements)', 'hair-mineral-analysis-35-elements', 'Analiza kose (35 elemenata)', 'Анализа косе (35 елемената)', 'Элементный анализ волос (35 элементов)', 'Haarmineralanalyse (35 Elemente)', 'Saç Mineral Analizi (35 Element)'),
('Aripiprazole Level', 'aripiprazole-level', 'Nivo aripiprazola', 'Ниво арипипразола', 'Уровень арипипразола', 'Aripiprazol-Spiegel', 'Aripiprazol Düzeyi'),
('Fluconazole Level', 'fluconazole-level', 'Nivo flukonazola', 'Ниво флуконазола', 'Уровень флуконазола', 'Fluconazol-Spiegel', 'Flukonazol Düzeyi'),
('Mitotane Level', 'mitotane-level', 'Nivo mitotana', 'Ниво митотана', 'Уровень митотана', 'Mitotan-Spiegel', 'Mitotan Düzeyi'),
('Omeprazole Level', 'omeprazole-level', 'Nivo omeprazola', 'Ниво омепразола', 'Уровень омепразола', 'Omeprazol-Spiegel', 'Omeprazol Düzeyi'),
('Venlafaxine and Metabolites Level', 'venlafaxine-and-metabolites-level', 'Nivo venlafaksina i metabolita', 'Ниво венлафаксина и метаболита', 'Уровень венлафаксина и метаболитов', 'Venlafaxin- und Metaboliten-Spiegel', 'Venlafaksin ve Metabolitleri Düzeyi'),
('Food Intolerance Panel 54 Foods', 'food-intolerance-panel-54-foods', 'Intolerancija na hranu 54 namirnice', 'Интолеранција на храну 54 намирнице', 'Панель пищевой непереносимости (54 продукта)', 'Nahrungsmittelintoleranz 54 Lebensmittel', 'Gıda intoleransı 54 gıda'),
('Food Intolerance Panel 216 Foods', 'food-intolerance-panel-216-foods', 'Intolerancija na hranu 216 namirnica', 'Интолеранција на храну 216 намирница', 'Панель пищевой непереносимости (216 продуктов)', 'Nahrungsmittelintoleranz 216 Lebensmittel', 'Gıda intoleransı 216 gıda'),
('ISAC Allergen Component Panel (112 Allergens)', 'isac-allergen-component-panel-112-allergens', 'ISAC panel (112 alergena)', 'ISAC панел (112 алергена)', 'Компонентная аллергодиагностика ISAC (112 аллергенов)', 'ISAC Allergenkomponenten-Panel (112 Allergene)', 'ISAC Alerjen Bileşen Paneli (112 Alerjen)'),
('Bartonella henselae IgG IgM Panel', 'bartonella-henselae-igg-igm-panel', 'Bartonella henselae IgG + IgM', 'Bartonella henselae IgG + IgM', 'Bartonella henselae IgG + IgM', 'Bartonella henselae IgG + IgM Panel', 'Bartonella henselae IgG + IgM Paneli'),
('Beta-D-Glucan', 'beta-d-glucan', 'Beta-D-glukan', 'Бета-Д-глукан', 'Бета-D-глюкан', 'Beta-D-Glucan', 'Beta-D-Glukan'),
('Chlamydia trachomatis IgA', 'chlamydia-trachomatis-iga', 'Chlamydia trachomatis IgA', 'Chlamydia trachomatis IgA', 'Chlamydia trachomatis IgA', 'Chlamydia trachomatis IgA', 'Chlamydia trachomatis IgA'),
('Dengue Virus Antigen', 'dengue-virus-antigen', 'Denga antigen', 'Денга антиген', 'Антиген вируса денге', 'Dengue-Virus-Antigen', 'Dang Virüsü Antijeni'),
('Dengue Virus IgG', 'dengue-virus-igg', 'Denga groznica IgG', 'Денга грозница IgG', 'Лихорадка денге IgG', 'Dengue-Virus IgG', 'Dang Humması IgG'),
('Dengue Virus IgM', 'dengue-virus-igm', 'Denga groznica IgM', 'Денга грозница IgM', 'Лихорадка денге IgM', 'Dengue-Virus IgM', 'Dang Humması IgM'),
('Diphtheria Antitoxin Antibodies', 'diphtheria-antitoxin-antibodies', 'Difterija antitoksin imunitet', 'Дифтерија антитоксин имунитет', 'Антитела к дифтерийному анатоксину (иммунитет)', 'Diphtherie-Antitoxin-Antikörper (Immunität)', 'Difteri Antitoksin Antikorları (Bağışıklık)'),
('Epstein-Barr EA IgG', 'epstein-barr-ea-igg', 'Epstein-Barr EA IgG', 'Epstein-Barr EA IgG', 'Эпштейн-Барр EA IgG (ранний антиген)', 'Epstein-Barr EA IgG', 'Epstein-Barr EA IgG'),
('Neisseria meningitidis IgG', 'neisseria-meningitidis-igg', 'Meningococcus IgG', 'Meningococcus IgG', 'Менингококк (Neisseria meningitidis) IgG', 'Meningokokken IgG', 'Meningokok IgG'),
('Nematode IgG Panel (Anisakis, Ascaris, Filaria, Strongyloides, Toxocara, Trichinella)', 'nematode-igg-panel-anisakis-ascaris-filaria-strongyloides-toxocara-trichinella', 'Nematode IgG (Anisakis, Ascaris, Filaria, Strongyloides, Toxocara, Trichinella)', 'Нематоде IgG (Anisakis, Ascaris, Филариа, Strongyloides, Toxocara, Trichinella)', 'Нематоды IgG (Anisakis, Ascaris, Filaria, Strongyloides, Toxocara, Trichinella)', 'Nematoden IgG (Anisakis, Ascaris, Filaria, Strongyloides, Toxocara, Trichinella)', 'Nematod IgG (Anisakis, Ascaris, Filaria, Strongyloides, Toxocara, Trichinella)'),
('Poliovirus Type 1 Antibodies', 'poliovirus-type-1-antibodies', 'Poliovirus tip 1 antitijela', 'Полиовирус тип 1 антитијела', 'Антитела к полиовирусу 1 типа', 'Poliovirus Typ 1 Antikörper', 'Poliovirüs Tip 1 Antikorları'),
('Poliovirus Type 3 Antibodies', 'poliovirus-type-3-antibodies', 'Poliovirus tip 3 antitijela', 'Полиовирус тип 3 антитијела', 'Антитела к полиовирусу 3 типа', 'Poliovirus Typ 3 Antikörper', 'Poliovirüs Tip 3 Antikorları'),
('Toxocara canis IgG Western Blot', 'toxocara-canis-igg-western-blot', 'Toxocara canis IgG Western Blot', 'Toxocara canis IgG Western Blot', 'Антитела к Toxocara canis IgG (вестерн-блот)', 'Toxocara canis IgG Western-Blot', 'Toxocara canis IgG Western Blot'),
('Yersinia IgA Western Blot', 'yersinia-iga-western-blot', 'Yersinia IgA Western Blot', 'Yersinia IgA Western Blot', 'Антитела к Yersinia IgA (вестерн-блот)', 'Yersinia IgA Western-Blot', 'Yersinia IgA Western Blot'),
('Yersinia IgG Western Blot', 'yersinia-igg-western-blot', 'Yersinia IgG Western Blot', 'Yersinia IgG Western Blot', 'Антитела к Yersinia IgG (вестерн-блот)', 'Yersinia IgG Western-Blot', 'Yersinia IgG Western Blot'),
('Newborn Screening Panel', 'newborn-screening-panel', 'Neonatalni skrining (hipotireoza, galaktozemija, biotinidaza, KAH, poremećaj metabolizma amino i organskih kiselina)', 'Неонатални скрининг (хипотиреоза, галактоземија, биотинидаза, KAH, поремећај метаболизма амино и органских киселина)', 'Неонатальный скрининг (гипотиреоз, галактоземия, биотинидаза, ВГКН, нарушения обмена амино- и органических кислот)', 'Neugeborenen-Screening (Hypothyreose, Galaktosämie, Biotinidase, AGS, Störungen des Amino- und Organosäurestoffwechsels)', 'Yenidoğan Taraması (hipotiroidi, galaktozemi, biyotinidaz, KAH, amino ve organik asit metabolizması bozuklukları)'),
('Liver Autoantibody Panel 13 Antigens', 'liver-autoantibody-panel-13-antigens', 'Panel autoantitijela jetre (AMA-M2, M2-3E, Sp100, PML, gp210, LKM-1, LC-1, SLA/LP, SS-A native, Ro-52, Scl-70, Centromer A, Centromer B)', 'Панел аутоантитијела јетре (AMA-M2, M2-3E, Sp100, PML, gp210, LKM-1, LC-1, SLA/LP, SS-A нативе, Ро-52, Сцл-70, Центромер A, Центромер B)', 'Панель аутоантител при аутоиммунных заболеваниях печени (AMA-M2, M2-3E, Sp100, PML, gp210, LKM-1, LC-1, SLA/LP, SS-A native, Ro-52, Scl-70, CENP-A, CENP-B)', 'Leber-Autoantikörper-Panel (AMA-M2, M2-3E, Sp100, PML, gp210, LKM-1, LC-1, SLA/LP, SS-A nativ, Ro-52, Scl-70, CENP-A, CENP-B)', 'Karaciğer Otoantikor Paneli (AMA-M2, M2-3E, Sp100, PML, gp210, LKM-1, LC-1, SLA/LP, SS-A native, Ro-52, Scl-70, CENP-A, CENP-B)'),
('ANNA-3 Antibodies', 'anna-3-antibodies', 'ANNA-3 antitijela', 'ANNA-3 антитијела', 'Антитела ANNA-3', 'ANNA-3-Antikörper', 'ANNA-3 Antikorları'),
('Anti-Annexin IgG Antibodies', 'anti-annexin-igg-antibodies', 'Anti-aneksin IgG antitijela', 'Анти-анексин IgG антитијела', 'Антитела к аннексину IgG', 'Anti-Annexin-IgG-Antikörper', 'Anti-Anneksin IgG Antikorları'),
('ASCA IgM', 'asca-igm', 'ASCA IgM', 'ASCA IgM', 'ASCA IgM', 'ASCA IgM', 'ASCA IgM'),
('Anti-Centromere Antibodies', 'anti-centromere-antibodies', 'Anti-centromerna antitijela', 'Анти-центромерна антитијела', 'Антицентромерные антитела', 'Anti-Zentromer-Antikörper', 'Anti-Sentromer Antikorları'),
('Endomysial IgG Antibodies', 'endomysial-igg-antibodies', 'Endomizijalna IgG antitijela', 'Ендомизијална IgG антитијела', 'Эндомизиальные IgG антитела', 'Endomysium-IgG-Antikörper', 'Endomisyal IgG Antikorları'),
('Anti-Fibrillarin (U3-RNP) Antibodies', 'anti-fibrillarin-u3-rnp-antibodies', 'Anti-fibrilarin (U3-RNP) antitijela', 'Анти-фибриларин (U3-RNP) антитијела', 'Антитела к фибрилларину (U3-RNP)', 'Anti-Fibrillarin-(U3-RNP)-Antikörper', 'Anti-Fibrillarin (U3-RNP) Antikorları'),
('Anti-Interferon Alpha Antibodies', 'anti-interferon-alpha-antibodies', 'Antitijela na interferon alfa', 'Антитијела на интерферон алфа', 'Антитела к интерферону альфа', 'Anti-Interferon-alpha-Antikörper', 'Anti-İnterferon Alfa Antikorları'),
('Ganglioside Antibody Profile', 'ganglioside-antibody-profile', 'Gangliozidni profil (GM1, GM2, GM3, GD1a, GD1b, GQ1b, GT1b IgM i IgG)', 'Ганглиозидни профил (GM1, GM2, GM3, GD1a, GD1b, GQ1b, GT1b IgM и IgG)', 'Профиль антител к ганглиозидам (GM1, GM2, GM3, GD1a, GD1b, GQ1b, GT1b IgM и IgG)', 'Gangliosid-Antikörper-Profil (GM1, GM2, GM3, GD1a, GD1b, GQ1b, GT1b IgM und IgG)', 'Gangliozid Antikor Profili (GM1, GM2, GM3, GD1a, GD1b, GQ1b, GT1b IgM ve IgG)'),
('NMDAR IgA Antibodies', 'nmdar-iga-antibodies', 'NMDAR IgA antitijela', 'NMDAR IgA антитијела', 'Антитела к NMDA-рецепторам IgA', 'NMDAR-IgA-Antikörper', 'NMDAR IgA Antikorları'),
('NMDAR IgM Antibodies', 'nmdar-igm-antibodies', 'NMDAR IgM antitijela', 'NMDAR IgM антитијела', 'Антитела к NMDA-рецепторам IgM', 'NMDAR-IgM-Antikörper', 'NMDAR IgM Antikorları'),
('Anti-NOR90 Antibodies', 'anti-nor90-antibodies', 'Anti-NOR90 antitijela', 'Анти-NOR90 антитијела', 'Анти-NOR90 антитела', 'Anti-NOR90-Antikörper', 'Anti-NOR90 Antikorları'),
('Anti-PM-Scl Antibodies', 'anti-pm-scl-antibodies', 'Anti-PM-Scl antitijela', 'Анти-PM-Сцл антитијела', 'Анти-PM-Scl антитела', 'Anti-PM-Scl-Antikörper', 'Anti-PM-Scl Antikorları'),
('Anti-Ri Antibodies', 'anti-ri-antibodies', 'Anti-Ri antitijela', 'Анти-Ри антитијела', 'Антитела к Ri', 'Anti-Ri-Antikörper', 'Anti-Ri Antikorları'),
('Anti-Ro52 Antibodies', 'anti-ro52-antibodies', 'Anti-Ro52 antitijela', 'Анти-Ro52 антитијела', 'Антитела к Ro52', 'Anti-Ro52-Antikörper', 'Anti-Ro52 Antikorları'),
('Spermatozoa Antibodies ASA IgA', 'spermatozoa-antibodies-asa-iga', 'Antitijela na spermatozoide ASA IgA', 'Антитијела на сперматозоиде ASA IgA', 'Антитела к сперматозоидам ASA IgA', 'Spermatozoen-Antikörper ASA IgA', 'Spermatozoa Antikorları ASA IgA'),
('Spermatozoa Antibodies ASA IgM', 'spermatozoa-antibodies-asa-igm', 'Antitijela na spermatozoide ASA IgM', 'Антитијела на сперматозоиде ASA IgM', 'Антитела к сперматозоидам ASA IgM', 'Spermatozoen-Antikörper ASA IgM', 'Spermatozoa Antikorları ASA IgM'),
('Hypocretin (Orexin)', 'hypocretin-orexin', 'Hipokretin (oreksin)', 'Хипокретин (орексин)', 'Гипокретин (орексин)', 'Hypocretin (Orexin)', 'Hipokretin (Oreksin)'),
('Carbohydrate-Deficient Transferrin', 'carbohydrate-deficient-transferrin', 'Transferin deficijentan ugljenim hidratima', 'Трансферин дефицијентан угљеним хидратима', 'Углевододефицитный трансферрин (CDT)', 'Kohlenhydrat-defizientes Transferrin (CDT)', 'Karbonhidrat Eksik Transferrin (CDT)'),
('14-3-3 Protein', '14-3-3-protein', 'Protein 14-3-3', 'Протеин 14-3-3', 'Белок 14-3-3', '14-3-3-Protein', '14-3-3 Proteini'),
('Neuronal Antibodies Panel in CSF', 'neuronal-antibodies-panel-in-csf', 'Panel neuralnih antitijela u likvoru (Amphiphysin 1, ANNA-III, CRMP5, CV-2, Ri, Yo, Hu D, Ma2 (Ta), PCA-2, Tr)', 'Панел неуралних антитијела у ликвору (Amphiphysin 1, ANNA-III, CRMP5, CV-2, Ri, Yo, Hu D, Ma2 (Ta), PCA-2, Tr)', 'Панель нейрональных антител в ликворе (Amphiphysin 1, ANNA-3, CRMP5, CV-2, Ri, Yo, HuD, Ma2 (Ta), PCA-2, Tr)', 'Neuronale Antikörper-Panel im Liquor (Amphiphysin 1, ANNA-3, CRMP5, CV-2, Ri, Yo, HuD, Ma2 (Ta), PCA-2, Tr)', 'BOS''ta Nöronal Antikor Paneli (Amphiphysin 1, ANNA-3, CRMP5, CV-2, Ri, Yo, HuD, Ma2 (Ta), PCA-2, Tr)'),
('Influenza A, B, C PCR', 'influenza-a-b-c-pcr', 'Influenca A, B, C PCR', 'Инфлуенца A, B, C PCR', 'Грипп A, B, C ПЦР', 'Influenza A, B, C PCR', 'İnfluenza A, B, C PCR'),
('Chlamydia pneumoniae PCR', 'chlamydia-pneumoniae-pcr', 'Chlamydia pneumoniae PCR', 'Chlamydia pneumoniae PCR', 'Chlamydia pneumoniae ПЦР', 'Chlamydia pneumoniae PCR', 'Chlamydia pneumoniae PCR'),
('Leishmania PCR', 'leishmania-pcr', 'Leishmania PCR', 'Leishmania PCR', 'Leishmania ПЦР', 'Leishmania PCR', 'Leishmania PCR'),
('Malaria PCR', 'malaria-pcr', 'Malarija PCR', 'Маларија PCR', 'Малярия ПЦР (Plasmodium)', 'Malaria PCR (Plasmodium)', 'Sıtma PCR (Plasmodium)'),
('Mumps Virus PCR', 'mumps-virus-pcr', 'Virus zaušnjaka RNK PCR', 'Вирус заушњака RNK PCR', 'Вирус эпидемического паротита РНК ПЦР', 'Mumpsvirus RNA PCR', 'Kabakulak Virüsü RNA PCR'),
('PAI-1 Locus 844', 'pai-1-locus-844', 'PAI-1 lokus 844', 'PAI-1 локус 844', 'PAI-1 локус 844', 'PAI-1 Locus 844', 'PAI-1 Lokus 844'),
('Thrombophilia 3 Genes 4 Loci', 'thrombophilia-3-genes-4-loci', 'Trombofilija 3 gena 4 lokusa', 'Тромбофилија 3 гена 4 локуса', 'Тромбофилия 3 гена 4 локуса', 'Thrombophilie 3 Gene 4 Loci', 'Trombofili 3 Gen 4 Lokus'),
('Cystic Fibrosis CFTR Full Gene Analysis', 'cystic-fibrosis-cftr-full-gene-analysis', 'Cistična fibroza – cijeli CFTR gen', 'Цистична фиброза – цијели CFTR ген', 'Муковисцидоз – весь ген CFTR', 'Mukoviszidose – gesamtes CFTR-Gen', 'Kistik Fibrozis – Tüm CFTR Geni'),
('Cystic Fibrosis F508del Mutation', 'cystic-fibrosis-f508del-mutation', 'Cistična fibroza – mutacija F508del', 'Цистична фиброза – мутација F508del', 'Муковисцидоз – мутация F508del', 'Mukoviszidose – F508del-Mutation', 'Kistik Fibrozis – F508del Mutasyonu'),
('CYP2C9 Genotyping', 'cyp2c9-genotyping', 'CYP2C9 genotipizacija', 'CYP2C9 генотипизација', 'Генотипирование CYP2C9', 'CYP2C9-Genotypisierung', 'CYP2C9 Genotipleme'),
('HLA Single Allele Typing', 'hla-single-allele-typing', 'HLA tipizacija jednog alela', 'HLA типизација једног алела', 'HLA-типирование одного аллеля', 'HLA-Typisierung eines Allels', 'Tek Alel HLA Tiplemesi'),
('JAK2 Exon 12 Mutation', 'jak2-exon-12-mutation', 'JAK2 egzon 12 mutacija', 'JAK2 егзон 12 мутација', 'Мутации гена JAK2 (экзон 12)', 'JAK2-Exon-12-Mutation', 'JAK2 Ekson 12 Mutasyonu'),
('Marfan Syndrome Genetic Test', 'marfan-syndrome-genetic-test', 'Marfanov sindrom – genetski test', 'Марфанов синдром – генетски тест', 'Синдром Марфана – генетический тест', 'Marfan-Syndrom – Gentest', 'Marfan Sendromu Genetik Testi'),
('Familial Mediterranean Fever Genetic Test', 'familial-mediterranean-fever-genetic-test', 'Mediteranska porodična groznica – genetski test', 'Медитеранска породична грозница – генетски тест', 'Семейная средиземноморская лихорадка – генетический тест', 'Familiäres Mittelmeerfieber – Gentest', 'Ailevi Akdeniz Ateşi Genetik Testi'),
('PMP22 MLPA Test', 'pmp22-mlpa-test', 'PMP22 MLPA test', 'PMP22 MLPA тест', 'PMP22 – MLPA-тест', 'PMP22-MLPA-Test', 'PMP22 MLPA Testi'),
('Alpha-Thalassemia Carrier Screening', 'alpha-thalassemia-carrier-screening', 'Alfa-talasemija (skrining na nasljedne bolesti)', 'Алфа-таласемија (скрининг на насљедне болести)', 'Альфа-талассемия (скрининг носительства)', 'Alpha-Thalassämie – Trägerscreening', 'Alfa Talasemi Taşıyıcılık Taraması'),
('Comprehensive Carrier Screening Panel (One Partner)', 'comprehensive-carrier-screening-panel-one-partner', 'Sveobuhvatni panel nasljednih bolesti – jedan partner', 'Свеобухватни панел насљедних болести – један партнер', 'Расширенная панель скрининга носительства наследственных заболеваний – один партнёр', 'Umfassendes Trägerscreening-Panel für Erbkrankheiten (ein Partner)', 'Kapsamlı Kalıtsal Hastalık Taşıyıcılık Paneli (Tek Partner)'),
('Comprehensive Carrier Screening Panel (Both Partners)', 'comprehensive-carrier-screening-panel-both-partners', 'Sveobuhvatni panel nasljednih bolesti – oba partnera', 'Свеобухватни панел насљедних болести – оба партнера', 'Расширенная панель скрининга носительства наследственных заболеваний – оба партнёра', 'Umfassendes Trägerscreening-Panel für Erbkrankheiten (beide Partner)', 'Kapsamlı Kalıtsal Hastalık Taşıyıcılık Paneli (İki Partner)'),
('Guidelines-Based Carrier Screening Panel (One Person)', 'guidelines-based-carrier-screening-panel-one-person', 'Panel prema vodičima za jednu osobu (skrining na nasljedne bolesti)', 'Панел према водичима за једну особу (скрининг на насљедне болести)', 'Панель скрининга носительства по клиническим рекомендациям – один человек', 'Leitlinienbasiertes Trägerscreening-Panel (eine Person)', 'Kılavuz Temelli Taşıyıcılık Tarama Paneli (Tek Kişi)'),
('Guidelines-Based Carrier Screening Panel (Two Persons)', 'guidelines-based-carrier-screening-panel-two-persons', 'Panel prema vodičima za dvije osobe (skrining na nasljedne bolesti)', 'Панел према водичима за двије особе (скрининг на насљедне болести)', 'Панель скрининга носительства по клиническим рекомендациям – два человека', 'Leitlinienbasiertes Trägerscreening-Panel (zwei Personen)', 'Kılavuz Temelli Taşıyıcılık Tarama Paneli (İki Kişi)'),
('Hereditary Breast and Gynecologic Cancer Panel', 'hereditary-breast-and-gynecologic-cancer-panel', 'Dojka/ginekološki panel (genetika karcinoma)', 'Дојка/гинеколошки панел (генетика карцинома)', 'Генетическая панель наследственного рака молочной железы и гинекологических опухолей', 'Panel für erblichen Brust- und gynäkologischen Krebs', 'Kalıtsal Meme ve Jinekolojik Kanser Paneli'),
('Hereditary Breast and Gynecologic Cancer Panel (Guidelines-Based)', 'hereditary-breast-and-gynecologic-cancer-panel-guidelines-based', 'Dojka/ginekološki panel prema vodičima (genetika karcinoma)', 'Дојка/гинеколошки панел према водичима (генетика карцинома)', 'Генетическая панель наследственного рака молочной железы и гинекологических опухолей (по клиническим рекомендациям)', 'Panel für erblichen Brust- und gynäkologischen Krebs (leitlinienbasiert)', 'Kalıtsal Meme ve Jinekolojik Kanser Paneli (Kılavuz Temelli)'),
('Hereditary Breast and Gynecologic Cancer Panel (High Risk)', 'hereditary-breast-and-gynecologic-cancer-panel-high-risk', 'Dojka/ginekološki panel visok rizik (genetika karcinoma)', 'Дојка/гинеколошки панел висок ризик (генетика карцинома)', 'Генетическая панель наследственного рака молочной железы и гинекологических опухолей (высокий риск)', 'Panel für erblichen Brust- und gynäkologischen Krebs (Hochrisiko)', 'Kalıtsal Meme ve Jinekolojik Kanser Paneli (Yüksek Risk)'),
('Hereditary Colorectal Cancer Panel', 'hereditary-colorectal-cancer-panel', 'Kolorektalni karcinom panel (genetika karcinoma)', 'Колоректални карцином панел (генетика карцинома)', 'Генетическая панель наследственного колоректального рака', 'Panel für erblichen kolorektalen Krebs', 'Kalıtsal Kolorektal Kanser Paneli'),
('Hereditary Colorectal Cancer Panel (High Risk)', 'hereditary-colorectal-cancer-panel-high-risk', 'Kolorektalni karcinom panel visok rizik (genetika karcinoma)', 'Колоректални карцином панел висок ризик (генетика карцинома)', 'Генетическая панель наследственного колоректального рака (высокий риск)', 'Panel für erblichen kolorektalen Krebs (Hochrisiko)', 'Kalıtsal Kolorektal Kanser Paneli (Yüksek Risk)'),
('Hereditary Non-Polyposis Colorectal Cancer Panel', 'hereditary-non-polyposis-colorectal-cancer-panel', 'Nasljedni nepolipozni kolorektalni karcinom (genetika karcinoma)', 'Насљедни неполипозни колоректални карцином (генетика карцинома)', 'Генетическая панель наследственного неполипозного колоректального рака', 'Panel für erblichen nicht-polypösen kolorektalen Krebs', 'Kalıtsal Polipozis Dışı Kolorektal Kanser Paneli'),
('Hereditary Polyposis Colorectal Cancer Panel', 'hereditary-polyposis-colorectal-cancer-panel', 'Nasljedni polipozni kolorektalni karcinom (genetika karcinoma)', 'Насљедни полипозни колоректални карцином (генетика карцинома)', 'Генетическая панель наследственного полипозного колоректального рака', 'Panel für erblichen polypösen kolorektalen Krebs', 'Kalıtsal Polipozis Kolorektal Kanser Paneli'),
('Myelodysplastic Syndrome/Leukemia Genetic Panel', 'myelodysplastic-syndrome-leukemia-genetic-panel', 'Mijelodisplastični sindrom/leukemija panel (genetika karcinoma)', 'Мијелодиспластични синдром/леукемија панел (генетика карцинома)', 'Генетическая панель: миелодиспластический синдром/лейкоз', 'Genpanel Myelodysplastisches Syndrom/Leukämie', 'Miyelodisplastik Sendrom/Lösemi Genetik Paneli'),
('Hereditary Gastric Cancer Panel', 'hereditary-gastric-cancer-panel', 'Želudac panel (genetika karcinoma)', 'Желудац панел (генетика карцинома)', 'Генетическая панель наследственного рака желудка', 'Panel für erblichen Magenkrebs', 'Kalıtsal Mide Kanseri Paneli'),
('Hereditary Prostate Cancer Panel', 'hereditary-prostate-cancer-panel', 'Prostata panel (genetika karcinoma)', 'Простата панел (генетика карцинома)', 'Генетическая панель наследственного рака предстательной железы', 'Panel für erblichen Prostatakrebs', 'Kalıtsal Prostat Kanseri Paneli'),
('Hereditary Pancreatic Cancer Panel', 'hereditary-pancreatic-cancer-panel', 'Pankreas panel (genetika karcinoma)', 'Панкреас панел (генетика карцинома)', 'Генетическая панель наследственного рака поджелудочной железы', 'Panel für erblichen Bauchspeicheldrüsenkrebs', 'Kalıtsal Pankreas Kanseri Paneli'),
('Hereditary Renal Cancer Panel', 'hereditary-renal-cancer-panel', 'Renalni panel (genetika karcinoma)', 'Ренални панел (генетика карцинома)', 'Генетическая панель наследственного рака почки', 'Panel für erblichen Nierenkrebs', 'Kalıtsal Böbrek Kanseri Paneli'),
('Hereditary Skin Cancer Panel', 'hereditary-skin-cancer-panel', 'Koža panel (genetika karcinoma)', 'Кожа панел (генетика карцинома)', 'Генетическая панель наследственного рака кожи', 'Panel für erblichen Hautkrebs', 'Kalıtsal Cilt Kanseri Paneli'),
('Familial Melanoma Panel', 'familial-melanoma-panel', 'Familijarni melanom panel (genetika karcinoma)', 'Фамилијарни меланом панел (генетика карцинома)', 'Генетическая панель семейной меланомы', 'Panel für familiäres Melanom', 'Ailesel Melanom Paneli'),
('Hereditary Paraganglioma/Pheochromocytoma Panel', 'hereditary-paraganglioma-pheochromocytoma-panel', 'Paragangliom/feohromocitom panel (genetika karcinoma)', 'Параганглиом/феохромоцитом панел (генетика карцинома)', 'Генетическая панель наследственной параганглиомы/феохромоцитомы', 'Panel für erbliches Paragangliom/Phäochromozytom', 'Kalıtsal Paraganglioma/Feokromositoma Paneli'),
('Hereditary Parathyroid Cancer Panel', 'hereditary-parathyroid-cancer-panel', 'Paratireoidni panel (genetika karcinoma)', 'Паратиреоидни панел (генетика карцинома)', 'Генетическая панель наследственного рака паращитовидных желёз', 'Panel für erblichen Nebenschilddrüsenkrebs', 'Kalıtsal Paratiroid Kanseri Paneli'),
('Hereditary Thyroid Cancer Panel', 'hereditary-thyroid-cancer-panel', 'Tireoidni panel (genetika karcinoma)', 'Тиреоидни панел (генетика карцинома)', 'Генетическая панель наследственного рака щитовидной железы', 'Panel für erblichen Schilddrüsenkrebs', 'Kalıtsal Tiroid Kanseri Paneli'),
('Pan-Cancer Hereditary Panel', 'pan-cancer-hereditary-panel', 'Pan-kancer panel (genetika karcinoma)', 'Пан-канцер панел (генетика карцинома)', 'Расширенная генетическая панель наследственных онкологических заболеваний (pan-cancer)', 'Erbliches Pan-Krebs-Panel', 'Kalıtsal Pan-Kanser Paneli'),
('NIPT Veracity Basic', 'nipt-veracity-basic', 'NIPT Veracity Basic', 'NIPT Veracity Basic', 'НИПТ Veracity базовый', 'NIPT Veracity Basis', 'NIPT Veracity Temel'),
('NIPT Veracity Plus', 'nipt-veracity-plus', 'NIPT Veracity Plus', 'NIPT Veracity Plus', 'НИПТ Veracity Plus', 'NIPT Veracity Plus', 'NIPT Veracity Plus'),
('NIPT Veracity Premium', 'nipt-veracity-premium', 'NIPT Veracity Premium', 'NIPT Veracity Premium', 'НИПТ Veracity Premium', 'NIPT Veracity Premium', 'NIPT Veracity Premium'),
('NIPT Veragene', 'nipt-veragene', 'NIPT Veragene', 'NIPT Veragene', 'НИПТ Veragene', 'NIPT Veragene', 'NIPT Veragene'),
('NIPT Sequentia Basic', 'nipt-sequentia-basic', 'NIPT Sequentia Basic', 'NIPT Sequentia Basic', 'НИПТ Sequentia Basic', 'NIPT Sequentia Basic', 'NIPT Sequentia Basic'),
('NIPT Sequentia Plus', 'nipt-sequentia-plus', 'NIPT Sequentia Plus', 'NIPT Sequentia Plus', 'НИПТ Sequentia Plus', 'NIPT Sequentia Plus', 'NIPT Sequentia Plus'),
('NIPT Sequentia Plus Expert', 'nipt-sequentia-plus-expert', 'NIPT Sequentia Plus Expert', 'NIPT Sequentia Plus Expert', 'НИПТ Sequentia Plus Expert', 'NIPT Sequentia Plus Expert', 'NIPT Sequentia Plus Expert'),
('NIPT Sequentia Premium', 'nipt-sequentia-premium', 'NIPT Sequentia Premium', 'NIPT Sequentia Premium', 'НИПТ Sequentia Premium', 'NIPT Sequentia Premium', 'NIPT Sequentia Premium'),
('NIPT Sequentia Safe Karyo Plus', 'nipt-sequentia-safe-karyo-plus', 'NIPT Sequentia Safe Karyo Plus', 'NIPT Sequentia Safe Karyo Plus', 'НИПТ Sequentia Safe Karyo Plus', 'NIPT Sequentia Safe Karyo Plus', 'NIPT Sequentia Safe Karyo Plus'),
('NIPT Sequentia PremiumGene', 'nipt-sequentia-premiumgene', 'NIPT Sequentia PremiumGene', 'NIPT Sequentia PremiumGene', 'НИПТ Sequentia PremiumGene', 'NIPT Sequentia PremiumGene', 'NIPT Sequentia PremiumGene'),
('NIPT Sequentia Safe Full Karyo Plus', 'nipt-sequentia-safe-full-karyo-plus', 'NIPT Sequentia Safe Full Karyo Plus', 'NIPT Sequentia Safe Full Karyo Plus', 'НИПТ Sequentia Safe Full Karyo Plus', 'NIPT Sequentia Safe Full Karyo Plus', 'NIPT Sequentia Safe Full Karyo Plus'),
('Chlamydia trachomatis (Direct Immunofluorescence)', 'chlamydia-trachomatis-direct-immunofluorescence', 'Chlamydia trachomatis DIF metoda', 'Chlamydia trachomatis DIF метода', 'Chlamydia trachomatis – прямая иммунофлуоресценция (ПИФ)', 'Chlamydia trachomatis – direkte Immunfluoreszenz', 'Chlamydia trachomatis – direkt immünofloresan'),
('Coxiella burnetii IgG', 'coxiella-burnetii-igg', 'Coxiella burnetii IgG', 'Coxiella burnetii IgG', 'Антитела к Coxiella burnetii IgG', 'Coxiella burnetii IgG', 'Coxiella burnetii IgG'),
('Coxiella burnetii IgM', 'coxiella-burnetii-igm', 'Coxiella burnetii IgM', 'Coxiella burnetii IgM', 'Антитела к Coxiella burnetii IgM', 'Coxiella burnetii IgM', 'Coxiella burnetii IgM'),
('Enterovirus IgM', 'enterovirus-igm', 'Enterovirus IgM (Coxsackie A/B, ECHO, enterovirusi 68-71)', 'Ентеровирус IgM (Coxsackie A/B, ECHO, ентеровируси 68-71)', 'Энтеровирусы IgM (Coxsackie A/B, ECHO, энтеровирусы 68–71)', 'Enteroviren IgM (Coxsackie A/B, ECHO, Enteroviren 68–71)', 'Enterovirüs IgM (Coxsackie A/B, ECHO, enterovirüs 68–71)'),
('Enterovirus IgG', 'enterovirus-igg', 'Enterovirus IgG (Coxsackie A/B, ECHO, enterovirusi 68-71)', 'Ентеровирус IgG (Coxsackie A/B, ECHO, ентеровируси 68-71)', 'Энтеровирусы IgG (Coxsackie A/B, ECHO, энтеровирусы 68–71)', 'Enteroviren IgG (Coxsackie A/B, ECHO, Enteroviren 68–71)', 'Enterovirüs IgG (Coxsackie A/B, ECHO, enterovirüs 68–71)'),
('Immunofixation Protein Serum', 'immunofixation-protein-serum', 'Imunofiksacija proteina seruma', 'Имунофиксација протеина серума', 'Иммунофиксация белков сыворотки', 'Immunfixation Protein Serum', 'Serum Protein İmmünofiksasyonu'),
('Immunofixation Protein Urine', 'immunofixation-protein-urine', 'Imunofiksacija proteina urina', 'Имунофиксација протеина урина', 'Иммунофиксация белков мочи', 'Immunfixation Protein Urin', 'İdrar Protein İmmünofiksasyonu'),
('Histopathology Cervical Biopsy and Fractional Curettage Three Samples', 'histopathology-cervical-biopsy-and-fractional-curettage-three-samples', 'PH Biopsija grlića materice i frakciona kiretaža ukupno tri uzorka', 'ПХ Биопсија грлића материце и фракциона киретажа укупно три узорка', 'Патогистологическое исследование биопсии шейки матки и фракционного кюретажа (всего три образца)', 'Histopathologie Zervixbiopsie und fraktionierte Kürettage (insgesamt drei Proben)', 'Histopatoloji servikal biyopsi ve fraksiyonel küretaj (toplam üç örnek)'),
('Histopathology Endoscopic Biopsy (Each Additional Sample)', 'histopathology-endoscopic-biopsy-each-additional-sample', 'PH Endoskopska biopsija (svaki sljedeći uzorak)', 'ПХ Ендоскопска биопсија (сваки сљедећи узорак)', 'Патогистологическое исследование эндоскопической биопсии (каждый следующий образец)', 'Histopathologie Endoskopische Biopsie (jede weitere Probe)', 'Histopatoloji endoskopik biyopsi (her ek örnek)'),
('Histopathology Ovary Examination', 'histopathology-ovary-examination', 'PH Pregled jajnika', 'ПХ Преглед јајника', 'Патогистологическое исследование яичника', 'Histopathologie Untersuchung des Eierstocks', 'Histopatoloji over incelemesi'),
('Candida DNA PCR', 'candida-dna-pcr', 'Candida DNK', 'Candida DNK', 'ДНК Candida (ПЦР)', 'Candida-DNA (PCR)', 'Candida DNA (PCR)'),
('Hepatitis E Virus RNA PCR', 'hepatitis-e-virus-rna-pcr', 'Hepatitis E virus RNK', 'Хепатитис E вирус RNK', 'РНК вируса гепатита E (ПЦР)', 'Hepatitis-E-Virus-RNA (PCR)', 'Hepatit E Virüsü RNA (PCR)'),
('Hemochromatosis HFE Genetic Test', 'hemochromatosis-hfe-genetic-test', 'Hemohromatoza', 'Хемохроматоза', 'Гемохроматоз (генетический тест HFE)', 'Hämochromatose HFE-Gentest', 'Hemokromatozis HFE Genetik Testi'),
('Spinal Muscular Atrophy Genetic Test', 'spinal-muscular-atrophy-genetic-test', 'Spinalna mišićna atrofija (genetika)', 'Спинална мишићна атрофија (генетика)', 'Спинальная мышечная атрофия (генетический тест)', 'Spinale Muskelatrophie (Gentest)', 'Spinal Musküler Atrofi (Genetik Test)'),
('Beta Hemoglobinopathies Carrier Screening', 'beta-hemoglobinopathies-carrier-screening', 'Beta hemoglobinopatije (skrining na nasljedne bolesti)', 'Бета хемоглобинопатије (скрининг на насљедне болести)', 'Скрининг носительства бета-гемоглобинопатий', 'Beta-Hämoglobinopathien Trägerscreening', 'Beta Hemoglobinopati Taşıyıcılık Taraması'),
('Cystic Fibrosis Carrier Screening', 'cystic-fibrosis-carrier-screening', 'Cistična fibroza (skrining na nasljedne bolesti)', 'Цистична фиброза (скрининг на насљедне болести)', 'Скрининг носительства муковисцидоза', 'Mukoviszidose Trägerscreening', 'Kistik Fibrozis Taşıyıcılık Taraması'),
('Reverse T3', 'reverse-t3', 'Reverzni T3', 'Реверзни T3', 'Реверсивный T3', 'Reverses T3', 'Ters T3'),
('Everolimus Level', 'everolimus-level', 'Nivo everolimusa', 'Ниво еверолимуса', 'Уровень эверолимуса', 'Everolimus-Spiegel', 'Everolimus düzeyi'),
('Topiramate Level', 'topiramate-level', 'Nivo topiramata', 'Ниво топирамата', 'Уровень топирамата', 'Topiramat-Spiegel', 'Topiramat düzeyi'),
('Tryptase', 'tryptase', 'Triptaza', 'Триптаза', 'Триптаза', 'Mastzell-Tryptase', 'Triptaz'),
('Francisella tularensis IgG', 'francisella-tularensis-igg', 'Francisella tularensis IgG', 'Francisella tularensis IgG', 'Антитела IgG к Francisella tularensis', 'Francisella tularensis IgG-Antikörper', 'Francisella tularensis IgG antikoru'),
('Francisella tularensis IgM', 'francisella-tularensis-igm', 'Francisella tularensis IgM', 'Francisella tularensis IgM', 'Антитела IgM к Francisella tularensis', 'Francisella tularensis IgM-Antikörper', 'Francisella tularensis IgM antikoru'),
('HTLV I/II Antibodies', 'htlv-i-ii-antibodies', 'Antitijela na HTLV I/II', 'Антитијела на HTLV I/II', 'Антитела к HTLV I/II', 'HTLV-I/II-Antikörper', 'HTLV I/II antikorları'),
('Influenza B Virus IgA', 'influenza-b-virus-iga', 'Influenca B virus IgA', 'Инфлуенца B вирус IgA', 'Антитела IgA к вирусу гриппа B', 'Influenza-B-Virus IgA-Antikörper', 'İnfluenza B virüsü IgA antikoru'),
('Streptococcus pneumoniae IgG', 'streptococcus-pneumoniae-igg', 'Streptococcus pneumoniae IgG', 'Streptococcus pneumoniae IgG', 'Антитела IgG к Streptococcus pneumoniae', 'Streptococcus pneumoniae IgG-Antikörper', 'Streptococcus pneumoniae IgG antikoru'),
('Treponema pallidum IgM Western Blot', 'treponema-pallidum-igm-western-blot', 'Treponema pallidum IgM antitijela (Western Blot)', 'Treponema pallidum IgM антитијела (Western Blot)', 'Treponema pallidum IgM антитела (вестерн-блот)', 'Treponema-pallidum-IgM-Antikörper (Western Blot)', 'Treponema pallidum IgM antikorları (Western Blot)'),
('Anti-RNP/Sm Antibodies', 'anti-rnp-sm-antibodies', 'Anti-RNP/Sm antitijela', 'Анти-RNP/Sm антитијела', 'Антитела к RNP/Sm', 'Anti-RNP/Sm-Antikörper', 'Anti-RNP/Sm antikorları'),
('NMDAR Antibodies in CSF', 'nmdar-antibodies-in-csf', 'NMDAR antitijela u likvoru', 'NMDAR антитијела у ликвору', 'Антитела к NMDA-рецепторам в ликворе', 'NMDAR-Antikörper im Liquor', 'BOS''ta NMDAR antikorları'),
('Beta-Amyloid', 'beta-amyloid', 'Beta-amiloid', 'Бета-амилоид', 'Бета-амилоид', 'Beta-Amyloid-Peptid', 'Beta-amiloid'),
('Serum Amyloid A', 'serum-amyloid-a', 'Serumski amiloid A', 'Серумски амилоид A', 'Сывороточный амилоид A', 'Serum-Amyloid A', 'Serum amiloid A'),
('Cytomegalovirus PCR', 'cytomegalovirus-pcr', 'Citomegalovirus PCR', 'Цитомегаловирус PCR', 'Цитомегаловирус ПЦР', 'Zytomegalievirus PCR-Nachweis', 'Sitomegalovirüs PCR testi'),
('Epstein-Barr Virus PCR', 'epstein-barr-virus-pcr', 'Epstein-Barr virus PCR', 'Epstein-Barr вирус PCR', 'Вирус Эпштейна-Барр ПЦР', 'Epstein-Barr-Virus PCR-Nachweis', 'Epstein-Barr virüsü PCR testi'),
('HBV PCR DNA Qualitative', 'hbv-pcr-dna-qualitative', 'HBV PCR DNK kvalitativni', 'HBV PCR DNK квалитативни', 'HBV ПЦР ДНК качественный', 'HBV-DNA PCR qualitativ', 'HBV DNA PCR kalitatif'),
('Toxoplasma gondii PCR', 'toxoplasma-gondii-pcr', 'Toxoplasma gondii PCR', 'Toxoplasma gondii PCR', 'Toxoplasma gondii ПЦР', 'Toxoplasma gondii PCR-Nachweis', 'Toxoplasma gondii PCR testi'),
('JAK2 V617F Mutation', 'jak2-v617f-mutation', 'Mutacija V617F u JAK2 genu', 'Мутација V617F у JAK2 гену', 'Мутация JAK2 V617F', 'JAK2-V617F-Mutation', 'JAK2 V617F mutasyonu'),
('LDH Isoenzymes', 'ldh-isoenzymes', 'Izoenzimi LDH', 'Изоензими LDH', 'Изоферменты ЛДГ', 'LDH-Isoenzyme', 'LDH izoenzimleri'),
('Treponema pallidum Total Antibodies', 'treponema-pallidum-total-antibodies', 'Treponema pallidum ukupna antitijela', 'Treponema pallidum укупна антитијела', 'Treponema pallidum суммарные антитела', 'Treponema-pallidum-Gesamtantikörper', 'Treponema pallidum total antikorları'),
('Human Herpesvirus 6 IgG', 'human-herpesvirus-6-igg', 'Humani herpesvirus 6 IgG', 'Хумани херпесвирус 6 IgG', 'Антитела к вирусу герпеса человека 6 типа IgG', 'Humanes Herpesvirus 6 IgG-Antikörper', 'İnsan Herpesvirüsü 6 IgG Antikoru'),
('Human Herpesvirus 6 IgM', 'human-herpesvirus-6-igm', 'Humani herpesvirus 6 IgM', 'Хумани херпесвирус 6 IgM', 'Антитела к вирусу герпеса человека 6 типа IgM', 'Humanes Herpesvirus 6 IgM-Antikörper', 'İnsan Herpesvirüsü 6 IgM Antikoru'),
('Soluble Transferrin Receptor', 'soluble-transferrin-receptor', 'Solubilni transferinski receptor', 'Солубилни трансферински рецептор', 'Растворимый рецептор трансферрина', 'Löslicher Transferrinrezeptor', 'Çözünür transferrin reseptörü'),
('Estrone', 'estrone', 'Estron', 'Естрон', 'Эстрон', 'Östron', 'Estron'),
('Holotranscobalamin', 'holotranscobalamin', 'Holotranskobalamin', 'Холотранскобаламин', 'Голотранскобаламин (активный B12)', 'Holotranscobalamin (aktives Vitamin B12)', 'Holotranskobalamin (aktif B12)'),
('Pyridinium Crosslinks in Urine', 'pyridinium-crosslinks-in-urine', 'Piridinijumske unakrsne veze u urinu', 'Пиридинијумске унакрсне везе у урину', 'Пиридиновые сшивки коллагена в моче', 'Pyridinium-Quervernetzungen im Urin', 'İdrarda piridinyum çapraz bağları'),
('Kidney Stone Analysis', 'kidney-stone-analysis', 'Analiza kamena iz bubrega', 'Анализа камена из бубрега', 'Анализ мочевого камня', 'Harnsteinanalyse', 'Böbrek taşı analizi'),
('GQ1b Antibodies IgG', 'gq1b-antibodies-igg', 'Antitijela na gangliozid GQ1b IgG', 'Антитијела на ганглиозид GQ1b IgG', 'Антитела к ганглиозиду GQ1b IgG', 'Antikörper gegen Gangliosid GQ1b IgG', 'Gangliozit GQ1b antikorları IgG'),
('GQ1b Antibodies IgM', 'gq1b-antibodies-igm', 'Antitijela na gangliozid GQ1b IgM', 'Антитијела на ганглиозид GQ1b IgM', 'Антитела к ганглиозиду GQ1b IgM', 'Antikörper gegen Gangliosid GQ1b IgM', 'Gangliozit GQ1b antikorları IgM'),
('Haemophilus influenzae IgG', 'haemophilus-influenzae-igg', 'Haemophilus influenzae IgG', 'Haemophilus influenzae IgG', 'Антитела IgG к Haemophilus influenzae', 'Haemophilus influenzae IgG-Antikörper', 'Haemophilus influenzae IgG antikoru'),
('Parainfluenza Virus 1, 2, 3 IgA', 'parainfluenza-virus-1-2-3-iga', 'Parainfluenca virus 1, 2, 3 IgA', 'Параинфлуенца вирус 1, 2, 3 IgA', 'Антитела IgA к вирусу парагриппа 1, 2, 3', 'Parainfluenzavirus 1, 2, 3 IgA-Antikörper', 'Parainfluenza virüsü 1, 2, 3 IgA antikoru'),
('Parainfluenza Virus 1, 2, 3 IgG', 'parainfluenza-virus-1-2-3-igg', 'Parainfluenca virus 1, 2, 3 IgG', 'Параинфлуенца вирус 1, 2, 3 IgG', 'Антитела IgG к вирусу парагриппа 1, 2, 3', 'Parainfluenzavirus 1, 2, 3 IgG-Antikörper', 'Parainfluenza virüsü 1, 2, 3 IgG antikoru'),
('Tetanus Antibodies', 'tetanus-antibodies', 'Antitijela na tetanus', 'Антитијела на тетанус', 'Антитела к столбнячному анатоксину', 'Tetanus-Antikörper', 'Tetanoz antikorları'),
('Very Long Chain Fatty Acids C22-C26', 'very-long-chain-fatty-acids-c22-c26', 'Masne kiseline vrlo dugog lanca C22-C26', 'Масне киселине врло дугог ланца C22-C26', 'Жирные кислоты с очень длинной цепью C22-C26', 'Überlangkettige Fettsäuren C22-C26', 'Çok uzun zincirli yağ asitleri C22-C26'),
('Amino Acid Profile in Serum', 'amino-acid-profile-in-serum', 'Profil aminokiselina u serumu', 'Профил аминокиселина у серуму', 'Профиль аминокислот в сыворотке', 'Aminosäureprofil im Serum', 'Serumda amino asit profili'),
('ENA Screening', 'ena-screening', 'ENA skrining', 'ENA скрининг', 'Скрининг ENA', 'ENA-Screening', 'ENA taraması'),
('ANCA Profile', 'anca-profile', 'ANCA profil', 'ANCA профил', 'ANCA-профиль', 'ANCA-Profil', 'ANCA profili'),
('Anti-Hu Antibodies', 'anti-hu-antibodies', 'Anti-Hu antitijela', 'Anti-Hu антитијела', 'Антитела к Hu', 'Anti-Hu-Antikörper', 'Anti-Hu antikorları'),
('Anti-Ribosomal P Antibodies', 'anti-ribosomal-p-antibodies', 'Antitijela na ribozomalni P protein', 'Антитијела на рибозомални P протеин', 'Антитела к рибосомальному P-белку', 'Anti-ribosomale-P-Protein-Antikörper', 'Anti-ribozomal P antikorları'),
('Mycobacterium tuberculosis Complex PCR', 'mycobacterium-tuberculosis-complex-pcr', 'Mycobacterium tuberculosis complex PCR', 'Mycobacterium tuberculosis complex PCR', 'Mycobacterium tuberculosis complex ПЦР', 'Mycobacterium-tuberculosis-Komplex PCR', 'Mycobacterium tuberculosis kompleks PCR'),
('Sickle Cell Mutation (HBB Codon 6)', 'sickle-cell-mutation-hbb-codon-6', 'Mutacija u 6. kodonu HBB gena (srpasta anemija)', 'Мутација у 6. кодону HBB гена (српаста анемија)', 'Мутация в 6-м кодоне гена HBB (серповидноклеточная анемия)', 'Mutation im Codon 6 des HBB-Gens (Sichelzellanämie)', 'HBB geni 6. kodon mutasyonu (orak hücre anemisi)'),
('HLA-A Typing', 'hla-a-typing', 'HLA tipizacija (lokus A)', 'HLA типизација (локус A)', 'HLA-типирование (локус A)', 'HLA-Typisierung (Locus A)', 'HLA tiplendirmesi (A lokusu)'),
('HLA-B Typing', 'hla-b-typing', 'HLA tipizacija (lokus B)', 'HLA типизација (локус B)', 'HLA-типирование (локус B)', 'HLA-Typisierung (Locus B)', 'HLA tiplendirmesi (B lokusu)'),
('HLA-C Typing', 'hla-c-typing', 'HLA-C tipizacija', 'HLA-C типизација', 'Типирование HLA-C', 'HLA-C-Typisierung', 'HLA-C tiplemesi'),
('Borrelia burgdorferi PCR in Tick', 'borrelia-burgdorferi-pcr-in-tick', 'Borrelia burgdorferi PCR u krpelju', 'Borrelia burgdorferi PCR у крпељу', 'Borrelia burgdorferi ПЦР в клеще', 'Borrelia burgdorferi PCR in der Zecke', 'Kenede Borrelia burgdorferi PCR')
ON DUPLICATE KEY UPDATE name_en = name_en;

-- ═══ 2. Категории ═══

INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id)
SELECT lt.id, v.category_id FROM (
      SELECT '14-3-3-protein' AS slug, 3 AS category_id
UNION ALL SELECT '3-methoxytyramine-in-urine', 5
UNION ALL SELECT 'ace-in-csf', 3
UNION ALL SELECT 'adenovirus-respiratory-test-eye-swab', 10
UNION ALL SELECT 'alpha-thalassemia-carrier-screening', 20
UNION ALL SELECT 'amino-acid-profile-in-serum', 3
UNION ALL SELECT 'amino-acid-profile-in-serum', 24
UNION ALL SELECT 'anca-profile', 14
UNION ALL SELECT 'anca-profile', 24
UNION ALL SELECT 'androstanediol-glucuronide', 5
UNION ALL SELECT 'anna-3-antibodies', 14
UNION ALL SELECT 'anti-annexin-igg-antibodies', 14
UNION ALL SELECT 'anti-centromere-antibodies', 14
UNION ALL SELECT 'anti-fibrillarin-u3-rnp-antibodies', 14
UNION ALL SELECT 'anti-hu-antibodies', 14
UNION ALL SELECT 'anti-interferon-alpha-antibodies', 14
UNION ALL SELECT 'anti-nor90-antibodies', 14
UNION ALL SELECT 'anti-pm-scl-antibodies', 14
UNION ALL SELECT 'anti-ri-antibodies', 14
UNION ALL SELECT 'anti-ribosomal-p-antibodies', 14
UNION ALL SELECT 'anti-rnp-sm-antibodies', 14
UNION ALL SELECT 'anti-ro52-antibodies', 14
UNION ALL SELECT 'aripiprazole-level', 17
UNION ALL SELECT 'asca-igm', 14
UNION ALL SELECT 'atherogenic-index', 3
UNION ALL SELECT 'bartonella-henselae-igg-igm-panel', 10
UNION ALL SELECT 'beta-amyloid', 3
UNION ALL SELECT 'beta-d-glucan', 10
UNION ALL SELECT 'beta-hemoglobinopathies-carrier-screening', 20
UNION ALL SELECT 'borrelia-burgdorferi-pcr-in-tick', 10
UNION ALL SELECT 'borrelia-burgdorferi-pcr-in-tick', 22
UNION ALL SELECT 'bromide', 16
UNION ALL SELECT 'candida-dna-pcr', 10
UNION ALL SELECT 'candida-dna-pcr', 22
UNION ALL SELECT 'carbohydrate-deficient-transferrin', 3
UNION ALL SELECT 'chlamydia-pneumoniae-pcr', 22
UNION ALL SELECT 'chlamydia-trachomatis-direct-immunofluorescence', 10
UNION ALL SELECT 'chlamydia-trachomatis-iga', 10
UNION ALL SELECT 'comprehensive-carrier-screening-panel-both-partners', 20
UNION ALL SELECT 'comprehensive-carrier-screening-panel-both-partners', 24
UNION ALL SELECT 'comprehensive-carrier-screening-panel-one-partner', 20
UNION ALL SELECT 'comprehensive-carrier-screening-panel-one-partner', 24
UNION ALL SELECT 'cortisol-in-saliva', 5
UNION ALL SELECT 'coxiella-burnetii-igg', 10
UNION ALL SELECT 'coxiella-burnetii-igm', 10
UNION ALL SELECT 'cyp2c9-genotyping', 20
UNION ALL SELECT 'cystic-fibrosis-carrier-screening', 20
UNION ALL SELECT 'cystic-fibrosis-cftr-full-gene-analysis', 20
UNION ALL SELECT 'cystic-fibrosis-f508del-mutation', 20
UNION ALL SELECT 'cytomegalovirus-pcr', 10
UNION ALL SELECT 'cytomegalovirus-pcr', 22
UNION ALL SELECT 'dengue-virus-antigen', 10
UNION ALL SELECT 'dengue-virus-igg', 10
UNION ALL SELECT 'dengue-virus-igm', 10
UNION ALL SELECT 'diphtheria-antitoxin-antibodies', 10
UNION ALL SELECT 'diphtheria-antitoxin-antibodies', 12
UNION ALL SELECT 'dopamine', 5
UNION ALL SELECT 'drug-and-psychoactive-substance-screen-3000-metabolites', 11
UNION ALL SELECT 'ena-screening', 14
UNION ALL SELECT 'endomysial-igg-antibodies', 14
UNION ALL SELECT 'enterovirus-antigen-rapid-test', 10
UNION ALL SELECT 'enterovirus-igg', 10
UNION ALL SELECT 'enterovirus-igm', 10
UNION ALL SELECT 'epstein-barr-ea-igg', 10
UNION ALL SELECT 'epstein-barr-virus-pcr', 10
UNION ALL SELECT 'epstein-barr-virus-pcr', 22
UNION ALL SELECT 'estrone', 5
UNION ALL SELECT 'everolimus-level', 17
UNION ALL SELECT 'eyelid-swab-bacteria', 21
UNION ALL SELECT 'eyelid-swab-fungi', 21
UNION ALL SELECT 'familial-mediterranean-fever-genetic-test', 20
UNION ALL SELECT 'familial-melanoma-panel', 20
UNION ALL SELECT 'familial-melanoma-panel', 24
UNION ALL SELECT 'fluconazole-level', 17
UNION ALL SELECT 'fluoride', 16
UNION ALL SELECT 'food-intolerance-panel-216-foods', 13
UNION ALL SELECT 'food-intolerance-panel-54-foods', 13
UNION ALL SELECT 'francisella-tularensis-igg', 10
UNION ALL SELECT 'francisella-tularensis-igm', 10
UNION ALL SELECT 'ganglioside-antibody-profile', 14
UNION ALL SELECT 'ganglioside-antibody-profile', 24
UNION ALL SELECT 'gq1b-antibodies-igg', 14
UNION ALL SELECT 'gq1b-antibodies-igm', 14
UNION ALL SELECT 'guidelines-based-carrier-screening-panel-one-person', 20
UNION ALL SELECT 'guidelines-based-carrier-screening-panel-one-person', 24
UNION ALL SELECT 'guidelines-based-carrier-screening-panel-two-persons', 20
UNION ALL SELECT 'guidelines-based-carrier-screening-panel-two-persons', 24
UNION ALL SELECT 'haemophilus-influenzae-igg', 10
UNION ALL SELECT 'hair-mineral-analysis-35-elements', 16
UNION ALL SELECT 'hair-mineral-analysis-35-elements', 24
UNION ALL SELECT 'hbv-pcr-dna-qualitative', 10
UNION ALL SELECT 'hbv-pcr-dna-qualitative', 22
UNION ALL SELECT 'hemochromatosis-hfe-genetic-test', 20
UNION ALL SELECT 'hepatitis-e-virus-rna-pcr', 22
UNION ALL SELECT 'hereditary-breast-and-gynecologic-cancer-panel', 20
UNION ALL SELECT 'hereditary-breast-and-gynecologic-cancer-panel', 24
UNION ALL SELECT 'hereditary-breast-and-gynecologic-cancer-panel-guidelines-based', 20
UNION ALL SELECT 'hereditary-breast-and-gynecologic-cancer-panel-guidelines-based', 24
UNION ALL SELECT 'hereditary-breast-and-gynecologic-cancer-panel-high-risk', 20
UNION ALL SELECT 'hereditary-breast-and-gynecologic-cancer-panel-high-risk', 24
UNION ALL SELECT 'hereditary-colorectal-cancer-panel', 20
UNION ALL SELECT 'hereditary-colorectal-cancer-panel', 24
UNION ALL SELECT 'hereditary-colorectal-cancer-panel-high-risk', 20
UNION ALL SELECT 'hereditary-colorectal-cancer-panel-high-risk', 24
UNION ALL SELECT 'hereditary-gastric-cancer-panel', 20
UNION ALL SELECT 'hereditary-gastric-cancer-panel', 24
UNION ALL SELECT 'hereditary-non-polyposis-colorectal-cancer-panel', 20
UNION ALL SELECT 'hereditary-non-polyposis-colorectal-cancer-panel', 24
UNION ALL SELECT 'hereditary-pancreatic-cancer-panel', 20
UNION ALL SELECT 'hereditary-pancreatic-cancer-panel', 24
UNION ALL SELECT 'hereditary-paraganglioma-pheochromocytoma-panel', 20
UNION ALL SELECT 'hereditary-paraganglioma-pheochromocytoma-panel', 24
UNION ALL SELECT 'hereditary-parathyroid-cancer-panel', 20
UNION ALL SELECT 'hereditary-parathyroid-cancer-panel', 24
UNION ALL SELECT 'hereditary-polyposis-colorectal-cancer-panel', 20
UNION ALL SELECT 'hereditary-polyposis-colorectal-cancer-panel', 24
UNION ALL SELECT 'hereditary-prostate-cancer-panel', 20
UNION ALL SELECT 'hereditary-prostate-cancer-panel', 24
UNION ALL SELECT 'hereditary-renal-cancer-panel', 20
UNION ALL SELECT 'hereditary-renal-cancer-panel', 24
UNION ALL SELECT 'hereditary-skin-cancer-panel', 20
UNION ALL SELECT 'hereditary-skin-cancer-panel', 24
UNION ALL SELECT 'hereditary-thyroid-cancer-panel', 20
UNION ALL SELECT 'hereditary-thyroid-cancer-panel', 24
UNION ALL SELECT 'histopathology-cervical-biopsy-and-fractional-curettage-three-samples', 24
UNION ALL SELECT 'histopathology-endoscopic-biopsy-each-additional-sample', 24
UNION ALL SELECT 'histopathology-ovary-examination', 24
UNION ALL SELECT 'hla-a-typing', 12
UNION ALL SELECT 'hla-a-typing', 20
UNION ALL SELECT 'hla-b-typing', 12
UNION ALL SELECT 'hla-b-typing', 20
UNION ALL SELECT 'hla-c-typing', 12
UNION ALL SELECT 'hla-c-typing', 20
UNION ALL SELECT 'hla-single-allele-typing', 12
UNION ALL SELECT 'hla-single-allele-typing', 20
UNION ALL SELECT 'holotranscobalamin', 15
UNION ALL SELECT 'htlv-i-ii-antibodies', 10
UNION ALL SELECT 'human-herpesvirus-6-igg', 10
UNION ALL SELECT 'human-herpesvirus-6-igm', 10
UNION ALL SELECT 'hypocretin-orexin', 3
UNION ALL SELECT 'immunofixation-protein-serum', 23
UNION ALL SELECT 'immunofixation-protein-urine', 23
UNION ALL SELECT 'influenza-a-b-c-pcr', 22
UNION ALL SELECT 'influenza-b-virus-iga', 10
UNION ALL SELECT 'isac-allergen-component-panel-112-allergens', 13
UNION ALL SELECT 'isac-allergen-component-panel-112-allergens', 24
UNION ALL SELECT 'jak2-exon-12-mutation', 20
UNION ALL SELECT 'jak2-v617f-mutation', 20
UNION ALL SELECT 'kidney-stone-analysis', 8
UNION ALL SELECT 'ldh-isoenzymes', 3
UNION ALL SELECT 'leishmania-pcr', 22
UNION ALL SELECT 'liver-autoantibody-panel-13-antigens', 14
UNION ALL SELECT 'liver-autoantibody-panel-13-antigens', 24
UNION ALL SELECT 'malaria-pcr', 22
UNION ALL SELECT 'marfan-syndrome-genetic-test', 20
UNION ALL SELECT 'mitotane-level', 17
UNION ALL SELECT 'mumps-virus-pcr', 22
UNION ALL SELECT 'mycobacterium-tuberculosis-complex-pcr', 10
UNION ALL SELECT 'mycobacterium-tuberculosis-complex-pcr', 22
UNION ALL SELECT 'myelodysplastic-syndrome-leukemia-genetic-panel', 20
UNION ALL SELECT 'myelodysplastic-syndrome-leukemia-genetic-panel', 24
UNION ALL SELECT 'nail-swab-for-bacteria', 21
UNION ALL SELECT 'neisseria-meningitidis-igg', 10
UNION ALL SELECT 'nematode-igg-panel-anisakis-ascaris-filaria-strongyloides-toxocara-trichinella', 10
UNION ALL SELECT 'nematode-igg-panel-anisakis-ascaris-filaria-strongyloides-toxocara-trichinella', 24
UNION ALL SELECT 'neuronal-antibodies-panel-in-csf', 14
UNION ALL SELECT 'neuronal-antibodies-panel-in-csf', 24
UNION ALL SELECT 'newborn-screening-panel', 3
UNION ALL SELECT 'newborn-screening-panel', 5
UNION ALL SELECT 'newborn-screening-panel', 24
UNION ALL SELECT 'nipt-sequentia-basic', 19
UNION ALL SELECT 'nipt-sequentia-basic', 20
UNION ALL SELECT 'nipt-sequentia-plus', 19
UNION ALL SELECT 'nipt-sequentia-plus', 20
UNION ALL SELECT 'nipt-sequentia-plus-expert', 19
UNION ALL SELECT 'nipt-sequentia-plus-expert', 20
UNION ALL SELECT 'nipt-sequentia-premium', 19
UNION ALL SELECT 'nipt-sequentia-premium', 20
UNION ALL SELECT 'nipt-sequentia-premiumgene', 19
UNION ALL SELECT 'nipt-sequentia-premiumgene', 20
UNION ALL SELECT 'nipt-sequentia-safe-full-karyo-plus', 19
UNION ALL SELECT 'nipt-sequentia-safe-full-karyo-plus', 20
UNION ALL SELECT 'nipt-sequentia-safe-karyo-plus', 19
UNION ALL SELECT 'nipt-sequentia-safe-karyo-plus', 20
UNION ALL SELECT 'nipt-veracity-basic', 19
UNION ALL SELECT 'nipt-veracity-basic', 20
UNION ALL SELECT 'nipt-veracity-plus', 19
UNION ALL SELECT 'nipt-veracity-plus', 20
UNION ALL SELECT 'nipt-veracity-premium', 19
UNION ALL SELECT 'nipt-veracity-premium', 20
UNION ALL SELECT 'nipt-veragene', 19
UNION ALL SELECT 'nipt-veragene', 20
UNION ALL SELECT 'nmdar-antibodies-in-csf', 14
UNION ALL SELECT 'nmdar-iga-antibodies', 14
UNION ALL SELECT 'nmdar-igm-antibodies', 14
UNION ALL SELECT 'non-hdl-cholesterol', 3
UNION ALL SELECT 'omeprazole-level', 17
UNION ALL SELECT 'pai-1-locus-844', 20
UNION ALL SELECT 'pan-cancer-hereditary-panel', 20
UNION ALL SELECT 'pan-cancer-hereditary-panel', 24
UNION ALL SELECT 'parainfluenza-virus-1-2-3-iga', 10
UNION ALL SELECT 'parainfluenza-virus-1-2-3-igg', 10
UNION ALL SELECT 'pivka-ii', 6
UNION ALL SELECT 'platelets-in-citrated-blood', 1
UNION ALL SELECT 'pmp22-mlpa-test', 20
UNION ALL SELECT 'poliovirus-type-1-antibodies', 10
UNION ALL SELECT 'poliovirus-type-3-antibodies', 10
UNION ALL SELECT 'psychoactive-substances-in-hair', 11
UNION ALL SELECT 'pyridinium-crosslinks-in-urine', 3
UNION ALL SELECT 'pyridinium-crosslinks-in-urine', 8
UNION ALL SELECT 'reverse-t3', 5
UNION ALL SELECT 'rsv-antigen-rapid-test', 10
UNION ALL SELECT 'sars-cov-2-influenza-ab-rsv-antigen-rapid-test', 10
UNION ALL SELECT 'serum-amyloid-a', 7
UNION ALL SELECT 'sickle-cell-mutation-hbb-codon-6', 20
UNION ALL SELECT 'silver', 16
UNION ALL SELECT 'soluble-transferrin-receptor', 3
UNION ALL SELECT 'spermatozoa-antibodies-asa-iga', 12
UNION ALL SELECT 'spermatozoa-antibodies-asa-igm', 12
UNION ALL SELECT 'spinal-muscular-atrophy-genetic-test', 20
UNION ALL SELECT 'streptococcus-pneumoniae-igg', 10
UNION ALL SELECT 'sulfur', 16
UNION ALL SELECT 'swab-bacteria-catheter-cyst-other', 21
UNION ALL SELECT 'swab-fungi-catheter-cyst-other', 21
UNION ALL SELECT 'tartrate-resistant-acid-phosphatase', 3
UNION ALL SELECT 'tetanus-antibodies', 10
UNION ALL SELECT 'tetanus-antibodies', 12
UNION ALL SELECT 'thrombophilia-3-genes-4-loci', 20
UNION ALL SELECT 'thrombophilia-3-genes-4-loci', 24
UNION ALL SELECT 'tin', 16
UNION ALL SELECT 'topiramate-level', 17
UNION ALL SELECT 'toxocara-canis-igg-western-blot', 10
UNION ALL SELECT 'toxoplasma-gondii-pcr', 10
UNION ALL SELECT 'toxoplasma-gondii-pcr', 22
UNION ALL SELECT 'tracheostomy-swab-fungi', 21
UNION ALL SELECT 'treponema-pallidum-igm-western-blot', 10
UNION ALL SELECT 'treponema-pallidum-total-antibodies', 10
UNION ALL SELECT 'tryptase', 13
UNION ALL SELECT 'uroporphyrin-in-urine', 8
UNION ALL SELECT 'venlafaxine-and-metabolites-level', 17
UNION ALL SELECT 'very-long-chain-fatty-acids-c22-c26', 3
UNION ALL SELECT 'vitamin-b3', 15
UNION ALL SELECT 'vitamin-b5', 15
UNION ALL SELECT 'yersinia-enterocolitica-detection', 21
UNION ALL SELECT 'yersinia-iga-western-blot', 10
UNION ALL SELECT 'yersinia-igg-western-blot', 10
) v JOIN lab_tests lt ON lt.slug = v.slug;

-- ═══ 3. Синонимы (дословные названия сайта и аббревиатуры) ═══

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
SELECT lt.id, v.another_name, v.language FROM (
      SELECT 'ace-in-csf' AS slug, 'ACE u likvoru' AS another_name, 'sr' AS language
UNION ALL SELECT 'ace-in-csf', 'АПФ в ликворе', 'ru'
UNION ALL SELECT 'adenovirus-respiratory-test-eye-swab', 'Adeno respiratorni virus (bris oka) (imunohromatografija)', 'sr'
UNION ALL SELECT 'alpha-thalassemia-carrier-screening', 'A-thalassemia (skrining na nasledne bolesti)', 'sr'
UNION ALL SELECT 'alpha-thalassemia-carrier-screening', 'Alpha-Thalassemia', 'en'
UNION ALL SELECT 'anna-3-antibodies', 'Anti-Neuronal Nuclear Antibody Type 3', 'en'
UNION ALL SELECT 'anti-annexin-igg-antibodies', 'Anti anexin IgG', 'sr'
UNION ALL SELECT 'anti-centromere-antibodies', 'ACA', 'en'
UNION ALL SELECT 'anti-fibrillarin-u3-rnp-antibodies', 'Anti fibrilarin-U3RNP antitijela', 'sr'
UNION ALL SELECT 'anti-fibrillarin-u3-rnp-antibodies', 'Anti-U3-RNP', 'en'
UNION ALL SELECT 'anti-interferon-alpha-antibodies', 'Anti interferon alfa antitijela', 'sr'
UNION ALL SELECT 'anti-ri-antibodies', 'ANNA-2', 'en'
UNION ALL SELECT 'anti-ro52-antibodies', 'Anti Ro 52', 'sr'
UNION ALL SELECT 'aripiprazole-level', 'Aripiprazol', 'sr'
UNION ALL SELECT 'asca-igm', 'Anti ASCA IgM', 'sr'
UNION ALL SELECT 'asca-igm', 'Anti-Saccharomyces cerevisiae IgM', 'en'
UNION ALL SELECT 'atherogenic-index', 'Aterogeni indeks', 'sr'
UNION ALL SELECT 'atherogenic-index', 'Коэффициент атерогенности', 'ru'
UNION ALL SELECT 'bartonella-henselae-igg-igm-panel', 'Bartonella henselae IgM/IgG', 'sr'
UNION ALL SELECT 'beta-d-glucan', '(1,3)-Beta-D-Glucan', 'en'
UNION ALL SELECT 'beta-hemoglobinopathies-carrier-screening', 'B hemoglobinopatije (skrining na nasledne bolesti)', 'sr'
UNION ALL SELECT 'beta-hemoglobinopathies-carrier-screening', 'HBB', 'en'
UNION ALL SELECT 'bromide', 'Br', 'en'
UNION ALL SELECT 'candida-dna-pcr', 'Candida PCR', 'en'
UNION ALL SELECT 'candida-dna-pcr', 'ПЦР на кандиду', 'ru'
UNION ALL SELECT 'carbohydrate-deficient-transferrin', 'CDT', 'en'
UNION ALL SELECT 'chlamydia-pneumoniae-pcr', 'Chlamydia pneumoniae DNK', 'sr'
UNION ALL SELECT 'chlamydia-trachomatis-direct-immunofluorescence', 'Chlamydia trachomatis - direktna imunofluorescencija', 'sr'
UNION ALL SELECT 'chlamydia-trachomatis-direct-immunofluorescence', 'Chlamydia trachomatis DFA', 'en'
UNION ALL SELECT 'chlamydia-trachomatis-direct-immunofluorescence', 'ПИФ на хламидии', 'ru'
UNION ALL SELECT 'comprehensive-carrier-screening-panel-both-partners', 'Sveobuhvatni panel nasljednih bolesti - oba partnera (skrining na nasledne bolesti)', 'sr'
UNION ALL SELECT 'comprehensive-carrier-screening-panel-one-partner', 'Sveobuhvatni panel nasljednih bolesti - jedan partner (skrining na nasledne bolesti)', 'sr'
UNION ALL SELECT 'cortisol-in-saliva', 'Kortizol u pljuvačci', 'sr'
UNION ALL SELECT 'cortisol-in-saliva', 'Salivary Cortisol', 'en'
UNION ALL SELECT 'coxiella-burnetii-igg', 'Q Fever IgG', 'en'
UNION ALL SELECT 'coxiella-burnetii-igg', 'Q-groznica IgG', 'sr'
UNION ALL SELECT 'coxiella-burnetii-igg', 'Ку-лихорадка IgG', 'ru'
UNION ALL SELECT 'coxiella-burnetii-igm', 'Q Fever IgM', 'en'
UNION ALL SELECT 'coxiella-burnetii-igm', 'Q-groznica IgM', 'sr'
UNION ALL SELECT 'coxiella-burnetii-igm', 'Ку-лихорадка IgM', 'ru'
UNION ALL SELECT 'cyp2c9-genotyping', 'CYP2C9', 'sr'
UNION ALL SELECT 'cystic-fibrosis-carrier-screening', 'CFTR', 'en'
UNION ALL SELECT 'cystic-fibrosis-carrier-screening', 'Cistična fibroza (skrining na nasledne bolesti)', 'sr'
UNION ALL SELECT 'cystic-fibrosis-carrier-screening', 'Муковисцидоз', 'ru'
UNION ALL SELECT 'cystic-fibrosis-cftr-full-gene-analysis', 'CFTR', 'en'
UNION ALL SELECT 'cystic-fibrosis-cftr-full-gene-analysis', 'Cistična fibroza cijeli gen', 'sr'
UNION ALL SELECT 'cystic-fibrosis-f508del-mutation', 'Cistična fibroza del508', 'sr'
UNION ALL SELECT 'cystic-fibrosis-f508del-mutation', 'ΔF508', 'en'
UNION ALL SELECT 'dengue-virus-igg', 'Dengue IgG', 'en'
UNION ALL SELECT 'dengue-virus-igm', 'Dengue IgM', 'en'
UNION ALL SELECT 'diphtheria-antitoxin-antibodies', 'Antitijela na difteriju', 'sr'
UNION ALL SELECT 'endomysial-igg-antibodies', 'Anti endomizijalna IgG', 'sr'
UNION ALL SELECT 'endomysial-igg-antibodies', 'EMA IgG', 'en'
UNION ALL SELECT 'enterovirus-antigen-rapid-test', 'Enterovirus (imunohromatografija)', 'sr'
UNION ALL SELECT 'enterovirus-igg', 'Enterovirus IgG Antibodies', 'en'
UNION ALL SELECT 'enterovirus-igg', 'Антитела к энтеровирусам IgG', 'ru'
UNION ALL SELECT 'enterovirus-igm', 'Enterovirus IgM Antibodies', 'en'
UNION ALL SELECT 'enterovirus-igm', 'Антитела к энтеровирусам IgM', 'ru'
UNION ALL SELECT 'epstein-barr-ea-igg', 'EBV EA IgG', 'sr'
UNION ALL SELECT 'epstein-barr-ea-igg', 'EBV Early Antigen IgG', 'en'
UNION ALL SELECT 'familial-mediterranean-fever-genetic-test', 'FMF', 'en'
UNION ALL SELECT 'familial-mediterranean-fever-genetic-test', 'MEFV', 'en'
UNION ALL SELECT 'familial-mediterranean-fever-genetic-test', 'Mediteranska porodična groznica', 'sr'
UNION ALL SELECT 'fluconazole-level', 'Adizol Level', 'en'
UNION ALL SELECT 'fluconazole-level', 'Fluconazol (Adizol)', 'sr'
UNION ALL SELECT 'food-intolerance-panel-216-foods', 'Intolerancija - 216 namirnica', 'sr'
UNION ALL SELECT 'food-intolerance-panel-54-foods', 'Intolerancija - 54 namirnice', 'sr'
UNION ALL SELECT 'ganglioside-antibody-profile', 'Gangliozidni profil', 'sr'
UNION ALL SELECT 'guidelines-based-carrier-screening-panel-one-person', 'Panel prema vodičima za jednu osobu (skrining na nasledne bolesti)', 'sr'
UNION ALL SELECT 'guidelines-based-carrier-screening-panel-two-persons', 'Panel prema vodičima za dvije osobe (skrining na nasledne bolesti)', 'sr'
UNION ALL SELECT 'hair-mineral-analysis-35-elements', 'Analiza kose (aluminium, antimon, arsen, bakar, barium, berilium, bizmut, bor, kadmium, kalaj, kalcijum, hrom, germanium, gvožđe, jod, kobalt, litium, magnezium, mangan, molibden, nikl, olovo, paladium, platina, selen, srebro, stroncium, talium, titan, uran, vanadium, volfram, cinc, cirkonium, živa)', 'sr'
UNION ALL SELECT 'hair-mineral-analysis-35-elements', 'Hair Element Analysis', 'en'
UNION ALL SELECT 'hemochromatosis-hfe-genetic-test', 'HFE gen', 'sr'
UNION ALL SELECT 'hemochromatosis-hfe-genetic-test', 'Генетика гемохроматоза', 'ru'
UNION ALL SELECT 'hepatitis-e-virus-rna-pcr', 'HEV PCR RNK', 'sr'
UNION ALL SELECT 'hepatitis-e-virus-rna-pcr', 'HEV RNA', 'en'
UNION ALL SELECT 'hepatitis-e-virus-rna-pcr', 'ПЦР на гепатит E', 'ru'
UNION ALL SELECT 'hereditary-colorectal-cancer-panel-high-risk', 'Kolorektalni karcinom panel viskok rizik (genetika karcinoma)', 'sr'
UNION ALL SELECT 'hereditary-non-polyposis-colorectal-cancer-panel', 'HNPCC', 'en'
UNION ALL SELECT 'hereditary-non-polyposis-colorectal-cancer-panel', 'Nalijedni nepolipozni kolorektalni karcinom (genetika karcinoma)', 'sr'
UNION ALL SELECT 'hereditary-non-polyposis-colorectal-cancer-panel', 'Синдром Линча', 'ru'
UNION ALL SELECT 'hereditary-paraganglioma-pheochromocytoma-panel', 'Paragangliom/feohromacitom panel (genetika karcinoma)', 'sr'
UNION ALL SELECT 'hereditary-polyposis-colorectal-cancer-panel', 'Nalijedni polipozni kolorektalni karcinom (genetika karcinoma)', 'sr'
UNION ALL SELECT 'hereditary-thyroid-cancer-panel', 'Tireoidini panel (genetika karcinoma)', 'sr'
UNION ALL SELECT 'histopathology-cervical-biopsy-and-fractional-curettage-three-samples', 'Biopsija grlića materice i frakciona kiretaža ukupno tri uzorka', 'sr'
UNION ALL SELECT 'histopathology-cervical-biopsy-and-fractional-curettage-three-samples', 'Гистология биопсии шейки матки и раздельного диагностического выскабливания', 'ru'
UNION ALL SELECT 'histopathology-endoscopic-biopsy-each-additional-sample', 'Endoskopska biopsija (svaki sledeći uzorak)', 'sr'
UNION ALL SELECT 'histopathology-endoscopic-biopsy-each-additional-sample', 'Гистология эндоскопической биопсии (каждый следующий образец)', 'ru'
UNION ALL SELECT 'histopathology-ovary-examination', 'Pregled jajnika', 'sr'
UNION ALL SELECT 'histopathology-ovary-examination', 'Гистология яичника', 'ru'
UNION ALL SELECT 'hypocretin-orexin', 'Hipokretin', 'sr'
UNION ALL SELECT 'hypocretin-orexin', 'Orexin', 'en'
UNION ALL SELECT 'immunofixation-protein-serum', 'IFE Serum', 'en'
UNION ALL SELECT 'immunofixation-protein-serum', 'Serum Immunofixation Electrophoresis', 'en'
UNION ALL SELECT 'immunofixation-protein-serum', 'Иммунофиксационный электрофорез белков сыворотки', 'ru'
UNION ALL SELECT 'immunofixation-protein-urine', 'IFE Urine', 'en'
UNION ALL SELECT 'immunofixation-protein-urine', 'Urine Immunofixation Electrophoresis', 'en'
UNION ALL SELECT 'immunofixation-protein-urine', 'Иммунофиксационный электрофорез белков мочи', 'ru'
UNION ALL SELECT 'influenza-a-b-c-pcr', 'Influenca A, B, C', 'sr'
UNION ALL SELECT 'isac-allergen-component-panel-112-allergens', 'ISAC 112', 'en'
UNION ALL SELECT 'isac-allergen-component-panel-112-allergens', 'ImmunoCAP ISAC', 'en'
UNION ALL SELECT 'jak2-exon-12-mutation', 'JAK2-egzon12 mutacija', 'sr'
UNION ALL SELECT 'leishmania-pcr', 'Leishmania DNK', 'sr'
UNION ALL SELECT 'liver-autoantibody-panel-13-antigens', 'Liver panel', 'sr'
UNION ALL SELECT 'malaria-pcr', 'Malarija DNK', 'sr'
UNION ALL SELECT 'malaria-pcr', 'Plasmodium PCR', 'en'
UNION ALL SELECT 'marfan-syndrome-genetic-test', 'Marfanov sindrom', 'sr'
UNION ALL SELECT 'mitotane-level', 'Mitotan', 'sr'
UNION ALL SELECT 'mumps-virus-pcr', 'Mumps RNA PCR', 'en'
UNION ALL SELECT 'mumps-virus-pcr', 'Parotitis epidemica RNK', 'sr'
UNION ALL SELECT 'myelodysplastic-syndrome-leukemia-genetic-panel', 'MDS', 'en'
UNION ALL SELECT 'neisseria-meningitidis-igg', 'Meningococcal IgG', 'en'
UNION ALL SELECT 'neisseria-meningitidis-igg', 'Meningokok IgG', 'sr'
UNION ALL SELECT 'neuronal-antibodies-panel-in-csf', 'Neuralna antitijela panel u likvoru', 'sr'
UNION ALL SELECT 'newborn-screening-panel', 'Neonatal Screening', 'en'
UNION ALL SELECT 'newborn-screening-panel', 'Neonatalni skrining', 'sr'
UNION ALL SELECT 'nipt-sequentia-basic', 'Sequentia Basic', 'sr'
UNION ALL SELECT 'nipt-sequentia-plus', 'Sequentia Plus', 'sr'
UNION ALL SELECT 'nipt-sequentia-plus-expert', 'Sequentia Plus Expert', 'sr'
UNION ALL SELECT 'nipt-sequentia-premium', 'Sequentia Premium', 'sr'
UNION ALL SELECT 'nipt-sequentia-premiumgene', 'Sequentia PremiumGene', 'sr'
UNION ALL SELECT 'nipt-sequentia-safe-full-karyo-plus', 'Sequentia Safe Full Karyo Plus', 'sr'
UNION ALL SELECT 'nipt-sequentia-safe-karyo-plus', 'Sequentia Safe Karyo Plus', 'sr'
UNION ALL SELECT 'nipt-veracity-basic', 'Veracity Basic', 'sr'
UNION ALL SELECT 'nipt-veracity-plus', 'Veracity Plus', 'sr'
UNION ALL SELECT 'nipt-veracity-premium', 'Veracity Premium', 'sr'
UNION ALL SELECT 'nipt-veragene', 'Veragene', 'sr'
UNION ALL SELECT 'nmdar-iga-antibodies', 'Anti NMDA receptor IgA', 'sr'
UNION ALL SELECT 'nmdar-igm-antibodies', 'Anti NMDA receptor IgM', 'sr'
UNION ALL SELECT 'omeprazole-level', 'Omeprazol', 'sr'
UNION ALL SELECT 'pai-1-locus-844', 'Mutacija gena PAI-1 844', 'sr'
UNION ALL SELECT 'pan-cancer-hereditary-panel', 'Pan karcer panel (genetika karcinoma)', 'sr'
UNION ALL SELECT 'pan-cancer-hereditary-panel', 'Pan-Cancer Panel', 'en'
UNION ALL SELECT 'pivka-ii', 'DCP', 'en'
UNION ALL SELECT 'pivka-ii', 'PIVKA', 'sr'
UNION ALL SELECT 'pivka-ii', 'Дез-гамма-карбоксипротромбин', 'ru'
UNION ALL SELECT 'pmp22-mlpa-test', 'PMP22-MLPA test', 'sr'
UNION ALL SELECT 'psychoactive-substances-in-hair', 'Hair Drug Test', 'en'
UNION ALL SELECT 'psychoactive-substances-in-hair', 'Анализ волос на наркотики', 'ru'
UNION ALL SELECT 'rsv-antigen-rapid-test', 'RSV (Respiratorni sincicijalni virus)', 'sr'
UNION ALL SELECT 'rsv-antigen-rapid-test', 'Респираторно-синцитиальный вирус', 'ru'
UNION ALL SELECT 'sars-cov-2-influenza-ab-rsv-antigen-rapid-test', 'Imunohromatografski test SARS-CoV-2 +FLU A+ FLU B + RSV', 'sr'
UNION ALL SELECT 'silver', 'Ag', 'en'
UNION ALL SELECT 'spermatozoa-antibodies-asa-iga', 'Anti spermatozoidna (ASA) IgA', 'sr'
UNION ALL SELECT 'spermatozoa-antibodies-asa-igm', 'Anti spermatozoidna (ASA) IgM', 'sr'
UNION ALL SELECT 'spinal-muscular-atrophy-genetic-test', 'SMA', 'en'
UNION ALL SELECT 'spinal-muscular-atrophy-genetic-test', 'Spinalna mišićna distrofija (genetika)', 'sr'
UNION ALL SELECT 'spinal-muscular-atrophy-genetic-test', 'СМА', 'ru'
UNION ALL SELECT 'sulfur', 'S', 'en'
UNION ALL SELECT 'swab-bacteria-catheter-cyst-other', 'Bris na bakterije (kateter, cista...)', 'sr'
UNION ALL SELECT 'swab-fungi-catheter-cyst-other', 'Bris na gljivice (kateter, cista...)', 'sr'
UNION ALL SELECT 'tartrate-resistant-acid-phosphatase', 'Kisjela fosfataza (tartarat rezistentna)', 'sr'
UNION ALL SELECT 'tartrate-resistant-acid-phosphatase', 'TRAP', 'en'
UNION ALL SELECT 'thrombophilia-3-genes-4-loci', 'Trombofilija mutacije panel', 'sr'
UNION ALL SELECT 'tin', 'Sn', 'en'
UNION ALL SELECT 'toxocara-canis-igg-western-blot', 'Toxocara canis-IgG, blot', 'sr'
UNION ALL SELECT 'venlafaxine-and-metabolites-level', 'Velafax Level', 'en'
UNION ALL SELECT 'venlafaxine-and-metabolites-level', 'Venlafaksin i metaboliti (Velafax)', 'sr'
UNION ALL SELECT 'vitamin-b3', 'Niacin', 'en'
UNION ALL SELECT 'vitamin-b3', 'Ниацин', 'ru'
UNION ALL SELECT 'vitamin-b5', 'Pantothenic Acid', 'en'
UNION ALL SELECT 'vitamin-b5', 'Пантотеновая кислота', 'ru'
UNION ALL SELECT 'yersinia-enterocolitica-detection', 'Yersinia enterokolitika', 'sr'
UNION ALL SELECT 'yersinia-iga-western-blot', 'Yersinia IgA, blot', 'sr'
UNION ALL SELECT 'yersinia-igg-western-blot', 'Yersinia IgG, blot', 'sr'
) v JOIN lab_tests lt ON lt.slug = v.slug;

-- ═══ 4. Привязка к 9 лабораториям ═══

DROP TEMPORARY TABLE IF EXISTS tmp_mojlab_labs;
CREATE TEMPORARY TABLE tmp_mojlab_labs (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY
);
INSERT INTO tmp_mojlab_labs VALUES
('moj-lab-laboratorija-podgorica-moskovska'),
('moj-lab-laboratorija-city-kvart'),
('moj-lab-laboratorija-budva'),
('moj-lab-laboratorija-ulcinj'),
('moj-lab-laboratorija-cetinje'),
('moj-lab-laboratorija-herceg-novi'),
('moj-lab-laboratorija-kotor'),
('moj-lab-laboratorija-niksic'),
('moj-lab-laboratorija-tivat');

DROP TEMPORARY TABLE IF EXISTS tmp_mojlab_tests;
CREATE TEMPORARY TABLE tmp_mojlab_tests (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	source_name VARCHAR(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
);
-- (lab_tests.slug, дословная строка сайта)
INSERT INTO tmp_mojlab_tests VALUES
('14-3-3-protein', 'Protein 14-3-3'),
('3-methoxytyramine-in-urine', '3-metoksitiramin u urinu'),
('ace-in-csf', 'ACE u likvoru'),
('adenovirus-respiratory-test-eye-swab', 'Adeno respiratorni virus (bris oka) (imunohromatografija)'),
('alpha-thalassemia-carrier-screening', 'A-thalassemia (skrining na nasledne bolesti)'),
('amino-acid-profile-in-serum', 'Aminokisjeline'),
('anca-profile', 'ANCA'),
('androstanediol-glucuronide', 'Androstandiol glukuronid'),
('anna-3-antibodies', 'ANNA 3 antitijela'),
('anti-annexin-igg-antibodies', 'Anti anexin IgG'),
('anti-centromere-antibodies', 'Anti centromerna antitijela'),
('anti-fibrillarin-u3-rnp-antibodies', 'Anti fibrilarin-U3RNP antitijela'),
('anti-hu-antibodies', 'Anti Hu D antitijela'),
('anti-interferon-alpha-antibodies', 'Anti interferon alfa antitijela'),
('anti-nor90-antibodies', 'Anti NOR90 antitijela'),
('anti-pm-scl-antibodies', 'Anti PM-SCL antitijela'),
('anti-ri-antibodies', 'Anti Ri antitijela'),
('anti-ribosomal-p-antibodies', 'Anti ribozoalni P protein IgG'),
('anti-rnp-sm-antibodies', 'Anti RNP/Sm'),
('anti-ro52-antibodies', 'Anti Ro 52'),
('anti-sm-antibodies', 'Anti Sm At'),
('aripiprazole-level', 'Aripiprazol'),
('asca-igm', 'Anti ASCA IgM'),
('atherogenic-index', 'Indeks ateroskleroze'),
('bartonella-henselae-igg-igm-panel', 'Bartonella henselae IgM/IgG'),
('beta-amyloid', 'Beta amiloid'),
('beta-d-glucan', 'Beta-D-Glukan'),
('beta-hemoglobinopathies-carrier-screening', 'B hemoglobinopatije (skrining na nasledne bolesti)'),
('borrelia-burgdorferi-pcr-in-tick', 'Borrelia burgdorferi DNK u krpelju'),
('bromide', 'Bromidi'),
('candida-dna-pcr', 'Candida DNK'),
('carbohydrate-deficient-transferrin', 'Transferin deficijentan ugljenim hidratima'),
('chlamydia-pneumoniae-pcr', 'Chlamydia pneumoniae DNK'),
('chlamydia-trachomatis-direct-immunofluorescence', 'Chlamydia trachomatis DIF metoda'),
('chlamydia-trachomatis-iga', 'Chlamydia trachomatis IgA'),
('comprehensive-carrier-screening-panel-both-partners', 'Sveobuhvatni panel nasljednih bolesti - oba partnera (skrining na nasledne bolesti)'),
('comprehensive-carrier-screening-panel-one-partner', 'Sveobuhvatni panel nasljednih bolesti - jedan partner (skrining na nasledne bolesti)'),
('cortisol-in-saliva', 'Kortizol u pljuvačci'),
('coxiella-burnetii-igg', 'Coxiella burnetii IgG'),
('coxiella-burnetii-igm', 'Coxiella burnetii IgM'),
('cyp2c9-genotyping', 'CYP2C9'),
('cystic-fibrosis-carrier-screening', 'Cistična fibroza (skrining na nasledne bolesti)'),
('cystic-fibrosis-cftr-full-gene-analysis', 'Cistična fibroza cijeli gen'),
('cystic-fibrosis-f508del-mutation', 'Cistična fibroza del508'),
('cytomegalovirus-pcr', 'Cytomegalo virus'),
('dengue-virus-antigen', 'Denga antigen'),
('dengue-virus-igg', 'Denga groznica IgG'),
('dengue-virus-igm', 'Denga groznica IgM'),
('diphtheria-antitoxin-antibodies', 'Difterija antitoksin imunitet'),
('dopamine', 'Dopamin'),
('drug-and-psychoactive-substance-screen-3000-metabolites', 'Ljekovi i psihoaktivne supstance (3000 metabolita)'),
('ena-screening', 'ENA'),
('endomysial-igg-antibodies', 'Anti endomizijalna IgG'),
('enterovirus-antigen-rapid-test', 'Enterovirus (imunohromatografija)'),
('enterovirus-igg', 'Enterovirus IgG (Coxsackie A/B, Echo, enterovirusi 68-71)'),
('enterovirus-igm', 'Enterovirus IgM (Coxsackie A/B, Echo, enterovirusi 68-71)'),
('epstein-barr-ea-igg', 'EBV EA IgG'),
('epstein-barr-virus-pcr', 'EBV DNK'),
('estrone', 'Estron (E1)'),
('everolimus-level', 'Everolimus'),
('eyelid-swab-bacteria', 'Bris kapka na bakterije'),
('eyelid-swab-fungi', 'Bris kapka na gljivice'),
('familial-mediterranean-fever-genetic-test', 'Mediteranska porodična groznica'),
('familial-melanoma-panel', 'Familijarni melanom panel (genetika karcinoma)'),
('fluconazole-level', 'Fluconazol (Adizol)'),
('fluoride', 'Fluorid'),
('food-intolerance-panel-216-foods', 'Intolerancija - 216 namirnica'),
('food-intolerance-panel-54-foods', 'Intolerancija - 54 namirnice'),
('francisella-tularensis-igg', 'Francisella tularensis IgG'),
('francisella-tularensis-igm', 'Francisella tularensis IgM ; Tularemija IgM'),
('ganglioside-antibody-profile', 'Gangliozidni profil (GM1M, GM1G, GD1BM, GD1BG, GQ1BM, GQ1BG, GM2M, GM2G, GM3M, GM3G, GD1AM, GD1AG, GT1BM, GT1BG)'),
('gq1b-antibodies-igg', 'GQ1B IgG (Quadrosialo gangliozid)'),
('gq1b-antibodies-igm', 'GQ1B IgM (Quadrosialo gangliozid)'),
('guidelines-based-carrier-screening-panel-one-person', 'Panel prema vodičima za jednu osobu (skrining na nasledne bolesti)'),
('guidelines-based-carrier-screening-panel-two-persons', 'Panel prema vodičima za dvije osobe (skrining na nasledne bolesti)'),
('haemophilus-influenzae-igg', 'Haemophilus influenzae tip B IgG'),
('hair-mineral-analysis-35-elements', 'Analiza kose (aluminium, antimon, arsen, bakar, barium, berilium, bizmut, bor, kadmium, kalaj, kalcijum, hrom, germanium, gvožđe, jod, kobalt, litium, magnezium, mangan, molibden, nikl, olovo, paladium, platina, selen, srebro, stroncium, talium, titan, uran, vanadium, volfram, cinc, cirkonium, živa)'),
('hbv-pcr-dna-qualitative', 'Hepatitis B PCR kvalitativno'),
('hemochromatosis-hfe-genetic-test', 'Hemohromatoza'),
('hepatitis-e-virus-rna-pcr', 'Hepatitis E virus RNK'),
('hereditary-breast-and-gynecologic-cancer-panel', 'Dojka/Ginekološki panel (genetika karcinoma)'),
('hereditary-breast-and-gynecologic-cancer-panel-guidelines-based', 'Dojka/Ginekološki panel prema vodičima (genetika karcinoma)'),
('hereditary-breast-and-gynecologic-cancer-panel-high-risk', 'Dojka/Ginekološki panel visok rizik (genetika karcinoma)'),
('hereditary-colorectal-cancer-panel', 'Kolorektalni karcinom panel (genetika karcinoma)'),
('hereditary-colorectal-cancer-panel-high-risk', 'Kolorektalni karcinom panel viskok rizik (genetika karcinoma)'),
('hereditary-gastric-cancer-panel', 'Želudac panel (genetika karcinoma)'),
('hereditary-non-polyposis-colorectal-cancer-panel', 'Nalijedni nepolipozni kolorektalni karcinom (genetika karcinoma)'),
('hereditary-pancreatic-cancer-panel', 'Pankreas panel (genetika karcinoma)'),
('hereditary-paraganglioma-pheochromocytoma-panel', 'Paragangliom/feohromacitom panel (genetika karcinoma)'),
('hereditary-parathyroid-cancer-panel', 'Paratireoidni panel (genetika karcinoma)'),
('hereditary-polyposis-colorectal-cancer-panel', 'Nalijedni polipozni kolorektalni karcinom (genetika karcinoma)'),
('hereditary-prostate-cancer-panel', 'Prostata panel (genetika karcinoma)'),
('hereditary-renal-cancer-panel', 'Renalni panel (genetika karcinoma)'),
('hereditary-skin-cancer-panel', 'Koža panel (genetika karcinoma)'),
('hereditary-thyroid-cancer-panel', 'Tireoidini panel (genetika karcinoma)'),
('histopathology-cervical-biopsy-and-fractional-curettage-three-samples', 'Biopsija grlića materice i frakciona kiretaža ukupno tri uzorka'),
('histopathology-endoscopic-biopsy-each-additional-sample', 'Endoskopska biopsija (svaki sledeći uzorak)'),
('histopathology-ovary-examination', 'Pregled jajnika'),
('hla-a-typing', 'HLA-A (Klasa 1)'),
('hla-b-typing', 'HLA-B (Klasa 1)'),
('hla-c-typing', 'HLA-Cw (Klasa 1)'),
('hla-single-allele-typing', 'HLA tipizacija jednog alela'),
('holotranscobalamin', 'Holotranskobalmin (aktivni vitamin B12)'),
('htlv-i-ii-antibodies', 'Humani T limfocitni virus I/II (HTLV) IgG'),
('human-herpesvirus-6-igg', 'Herpes tip 6 IgG'),
('human-herpesvirus-6-igm', 'Herpes tip 6 IgM'),
('hypocretin-orexin', 'Hipokretin'),
('immunofixation-protein-serum', 'Imunofiksacija proteina seruma'),
('immunofixation-protein-urine', 'Imunofiksacija proteina urina'),
('influenza-a-b-c-pcr', 'Influenca A, B, C'),
('influenza-b-virus-iga', 'Influenca B IgA'),
('isac-allergen-component-panel-112-allergens', 'ISAC panel (112 alergena)'),
('jak2-exon-12-mutation', 'JAK2-egzon12 mutacija'),
('jak2-v617f-mutation', 'JAK2-V617F mutacija'),
('kidney-stone-analysis', 'Analiza kamena'),
('ldh-isoenzymes', 'LDH Izoenzimi Omega3/6 index u eritrocitima'),
('leishmania-pcr', 'Leishmania DNK'),
('liver-autoantibody-panel-13-antigens', 'Liver panel (AMA-M2, M2-3E, Sp100, PML, gp210, LKM-1, LC-1,SLA/LP, SS-A native, Ro-52, Scl-70, Centromer A, Centromer B)'),
('malaria-pcr', 'Malarija DNK'),
('marfan-syndrome-genetic-test', 'Marfanov sindrom'),
('mitotane-level', 'Mitotan'),
('mumps-virus-pcr', 'Parotitis epidemica RNK'),
('mycobacterium-tuberculosis-complex-pcr', 'M. tuberculosis DNK'),
('myelodysplastic-syndrome-leukemia-genetic-panel', 'Mijelodisplastični sindrom/Leukemija panel (genetika karcinoma)'),
('nail-swab-for-bacteria', 'Bris nokta na bakterije'),
('neisseria-meningitidis-igg', 'Meningococcus IgG'),
('nematode-igg-panel-anisakis-ascaris-filaria-strongyloides-toxocara-trichinella', 'Nematode IgG (Anisakis, Ascaris,'),
('neuronal-antibodies-panel-in-csf', 'Neuralna antitijela panel (Amphiphysin 1, ANNA-III, CRMP5, CV-2, Ri antigen, Yo, Hu D antigen, Ma2 (Ta), PCA-2, Tr) u likvoru'),
('newborn-screening-panel', 'Neonatalni skrining (hipotireoza, galaktozemija, biotinidaza, KAH, poremećaj metabilizma amino i organskih kisjelina)'),
('nipt-sequentia-basic', 'Sequentia Basic'),
('nipt-sequentia-plus', 'Sequentia Plus'),
('nipt-sequentia-plus-expert', 'Sequentia Plus Expert'),
('nipt-sequentia-premium', 'Sequentia Premium'),
('nipt-sequentia-premiumgene', 'Sequentia PremiumGene'),
('nipt-sequentia-safe-full-karyo-plus', 'Sequentia Safe Full Karyo Plus'),
('nipt-sequentia-safe-karyo-plus', 'Sequentia Safe Kario Plus ; Sequentia Safe Karyo Plus'),
('nipt-veracity-basic', 'Veracity Basic'),
('nipt-veracity-plus', 'Veracity Plus'),
('nipt-veracity-premium', 'Veracity Premium'),
('nipt-veragene', 'Veragene'),
('nmdar-antibodies-in-csf', 'Anti NMDA receptorska antitijela (likvor)'),
('nmdar-iga-antibodies', 'Anti NMDA receptor IgA'),
('nmdar-igm-antibodies', 'Anti NMDA receptor IgM'),
('non-hdl-cholesterol', 'Non HDL holesterol'),
('omeprazole-level', 'Omeprazol'),
('pai-1-locus-844', 'Mutacija gena PAI-1 844'),
('pan-cancer-hereditary-panel', 'Pan karcer panel (genetika karcinoma)'),
('parainfluenza-virus-1-2-3-iga', 'Parainfluenca IgA'),
('parainfluenza-virus-1-2-3-igg', 'Parainfluenca IgG'),
('pivka-ii', 'PIVKA'),
('platelets-in-citrated-blood', 'Trombociti na citratu'),
('pmp22-mlpa-test', 'PMP22-MLPA test'),
('poliovirus-type-1-antibodies', 'Poliovirus tip 1 antitijela'),
('poliovirus-type-3-antibodies', 'Poliovirus tip 3 antitijela'),
('psychoactive-substances-in-hair', 'Psihoaktivne supstance u kosi'),
('pyridinium-crosslinks-in-urine', 'D-Pirilinx (piridinolin)'),
('reverse-t3', 'Reverzni T3'),
('rsv-antigen-rapid-test', 'RSV (Respiratorni sincicijalni virus)'),
('sars-cov-2-influenza-ab-rsv-antigen-rapid-test', 'Imunohromatografski test SARS-CoV-2 +FLU A+ FLU B + RSV'),
('serum-amyloid-a', 'Serumski amiloid A'),
('sickle-cell-mutation-hbb-codon-6', 'Anemija srpastih ćelija'),
('silver', 'Srebro'),
('soluble-transferrin-receptor', 'Solubilni transferinski receptori (sTfr)'),
('spermatozoa-antibodies-asa-iga', 'Anti spermatozoidna (ASA) IgA'),
('spermatozoa-antibodies-asa-igm', 'Anti spermatozoidna (ASA) IgM'),
('spinal-muscular-atrophy-genetic-test', 'Spinalna mišićna distrofija (genetika)'),
('streptococcus-pneumoniae-igg', 'Pneumococcus IgG'),
('sulfur', 'Sumpor'),
('swab-bacteria-catheter-cyst-other', 'Bris na bakterije (kateter, cista...)'),
('swab-fungi-catheter-cyst-other', 'Bris na gljivice (kateter, cista...)'),
('tartrate-resistant-acid-phosphatase', 'aza (tartarat rezistentna)'),
('tetanus-antibodies', 'Tetanus antitoksin imunitet'),
('thrombophilia-3-genes-4-loci', 'Thrombofilija mutacije panel:'),
('tin', 'Kalaj'),
('topiramate-level', 'Topiramate (Topamax)'),
('toxocara-canis-igg-western-blot', 'Toxocara canis-IgG, blot'),
('toxoplasma-gondii-pcr', 'Toxoplasma gondii DNK'),
('tracheostomy-swab-fungi', 'Bris traheostome na gljivice'),
('treponema-pallidum-igm-western-blot', 'Treponema pallidum IgM (blot)'),
('treponema-pallidum-total-antibodies', 'Anti Treponema pallidum At'),
('tryptase', 'Triptaza'),
('uroporphyrin-in-urine', 'Uroporfirin u urinu'),
('venlafaxine-and-metabolites-level', 'Venlafaksin i metaboliti (Velafax)'),
('very-long-chain-fatty-acids-c22-c26', 'Masne kisjeline dugih lanaca'),
('vitamin-b3', 'Vitamin B3'),
('vitamin-b5', 'Vitamin B5'),
('yersinia-enterocolitica-detection', 'Yersinia enterokolitika'),
('yersinia-iga-western-blot', 'Yersinia IgA, blot'),
('yersinia-igg-western-blot', 'Yersinia IgG, blot');

DROP TEMPORARY TABLE IF EXISTS tmp_mojlab_services;
CREATE TEMPORARY TABLE tmp_mojlab_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	source_name VARCHAR(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
);
-- (medical_services.slug, дословная строка сайта)
INSERT INTO tmp_mojlab_services VALUES
('frozen-section-histopathology-ex-tempore', 'Ex tempore biopsija'),
('histopathology-of-breast-tumor', 'Pregled tumora dojke'),
('histopathology-of-myoma', 'Pregled odstranjenog mioma'),
('histopathology-of-nephrectomy', 'Pregled nefrektomije'),
('histopathology-of-skin-tumor', 'Biopsija tumora kože'),
('histopathology-of-total-prostatectomy', 'Pregled prostaktetomije'),
('histopathology-of-uterus-with-bilateral-adnexa', 'Pregled uterusa sa adneksama');

-- Контроль (ожидается пусто): анализы, услуги, лаборатории
SELECT t.slug AS missing_lab_test FROM tmp_mojlab_tests t LEFT JOIN lab_tests lt ON lt.slug = t.slug WHERE lt.id IS NULL;
SELECT t.slug AS missing_service FROM tmp_mojlab_services t LEFT JOIN medical_services ms ON ms.slug = t.slug WHERE ms.id IS NULL;
SELECT l.slug AS missing_clinic FROM tmp_mojlab_labs l LEFT JOIN clinics c ON c.slug = l.slug WHERE c.id IS NULL;

INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price)
SELECT c.id, lt.id, NULL
FROM tmp_mojlab_labs l
JOIN clinics c ON c.slug = l.slug
CROSS JOIN tmp_mojlab_tests t
JOIN lab_tests lt ON lt.slug = t.slug;

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price)
SELECT c.id, ms.id, NULL
FROM tmp_mojlab_labs l
JOIN clinics c ON c.slug = l.slug
CROSS JOIN tmp_mojlab_services t
JOIN medical_services ms ON ms.slug = t.slug;

DROP TEMPORARY TABLE tmp_mojlab_services;
DROP TEMPORARY TABLE tmp_mojlab_tests;
DROP TEMPORARY TABLE tmp_mojlab_labs;

COMMIT;

-- ═══ VERIFICATION ═══

-- Новые записи без категории (ожидается 0)
SELECT COUNT(*) AS without_category FROM lab_tests lt
WHERE lt.slug IN ('14-3-3-protein', '3-methoxytyramine-in-urine', 'ace-in-csf', 'adenovirus-respiratory-test-eye-swab', 'alpha-thalassemia-carrier-screening', 'amino-acid-profile-in-serum', 'anca-profile', 'androstanediol-glucuronide', 'anna-3-antibodies', 'anti-annexin-igg-antibodies', 'anti-centromere-antibodies', 'anti-fibrillarin-u3-rnp-antibodies', 'anti-hu-antibodies', 'anti-interferon-alpha-antibodies', 'anti-nor90-antibodies', 'anti-pm-scl-antibodies', 'anti-ri-antibodies', 'anti-ribosomal-p-antibodies', 'anti-rnp-sm-antibodies', 'anti-ro52-antibodies', 'anti-sm-antibodies', 'aripiprazole-level', 'asca-igm', 'atherogenic-index', 'bartonella-henselae-igg-igm-panel', 'beta-amyloid', 'beta-d-glucan', 'beta-hemoglobinopathies-carrier-screening', 'borrelia-burgdorferi-pcr-in-tick', 'bromide', 'candida-dna-pcr', 'carbohydrate-deficient-transferrin', 'chlamydia-pneumoniae-pcr', 'chlamydia-trachomatis-direct-immunofluorescence', 'chlamydia-trachomatis-iga', 'comprehensive-carrier-screening-panel-both-partners', 'comprehensive-carrier-screening-panel-one-partner', 'cortisol-in-saliva', 'coxiella-burnetii-igg', 'coxiella-burnetii-igm', 'cyp2c9-genotyping', 'cystic-fibrosis-carrier-screening', 'cystic-fibrosis-cftr-full-gene-analysis', 'cystic-fibrosis-f508del-mutation', 'cytomegalovirus-pcr', 'dengue-virus-antigen', 'dengue-virus-igg', 'dengue-virus-igm', 'diphtheria-antitoxin-antibodies', 'dopamine', 'drug-and-psychoactive-substance-screen-3000-metabolites', 'ena-screening', 'endomysial-igg-antibodies', 'enterovirus-antigen-rapid-test', 'enterovirus-igg', 'enterovirus-igm', 'epstein-barr-ea-igg', 'epstein-barr-virus-pcr', 'estrone', 'everolimus-level', 'eyelid-swab-bacteria', 'eyelid-swab-fungi', 'familial-mediterranean-fever-genetic-test', 'familial-melanoma-panel', 'fluconazole-level', 'fluoride', 'food-intolerance-panel-216-foods', 'food-intolerance-panel-54-foods', 'francisella-tularensis-igg', 'francisella-tularensis-igm', 'ganglioside-antibody-profile', 'gq1b-antibodies-igg', 'gq1b-antibodies-igm', 'guidelines-based-carrier-screening-panel-one-person', 'guidelines-based-carrier-screening-panel-two-persons', 'haemophilus-influenzae-igg', 'hair-mineral-analysis-35-elements', 'hbv-pcr-dna-qualitative', 'hemochromatosis-hfe-genetic-test', 'hepatitis-e-virus-rna-pcr', 'hereditary-breast-and-gynecologic-cancer-panel', 'hereditary-breast-and-gynecologic-cancer-panel-guidelines-based', 'hereditary-breast-and-gynecologic-cancer-panel-high-risk', 'hereditary-colorectal-cancer-panel', 'hereditary-colorectal-cancer-panel-high-risk', 'hereditary-gastric-cancer-panel', 'hereditary-non-polyposis-colorectal-cancer-panel', 'hereditary-pancreatic-cancer-panel', 'hereditary-paraganglioma-pheochromocytoma-panel', 'hereditary-parathyroid-cancer-panel', 'hereditary-polyposis-colorectal-cancer-panel', 'hereditary-prostate-cancer-panel', 'hereditary-renal-cancer-panel', 'hereditary-skin-cancer-panel', 'hereditary-thyroid-cancer-panel', 'histopathology-cervical-biopsy-and-fractional-curettage-three-samples', 'histopathology-endoscopic-biopsy-each-additional-sample', 'histopathology-ovary-examination', 'hla-a-typing', 'hla-b-typing', 'hla-c-typing', 'hla-single-allele-typing', 'holotranscobalamin', 'htlv-i-ii-antibodies', 'human-herpesvirus-6-igg', 'human-herpesvirus-6-igm', 'hypocretin-orexin', 'immunofixation-protein-serum', 'immunofixation-protein-urine', 'influenza-a-b-c-pcr', 'influenza-b-virus-iga', 'isac-allergen-component-panel-112-allergens', 'jak2-exon-12-mutation', 'jak2-v617f-mutation', 'kidney-stone-analysis', 'ldh-isoenzymes', 'leishmania-pcr', 'liver-autoantibody-panel-13-antigens', 'malaria-pcr', 'marfan-syndrome-genetic-test', 'mitotane-level', 'mumps-virus-pcr', 'mycobacterium-tuberculosis-complex-pcr', 'myelodysplastic-syndrome-leukemia-genetic-panel', 'nail-swab-for-bacteria', 'neisseria-meningitidis-igg', 'nematode-igg-panel-anisakis-ascaris-filaria-strongyloides-toxocara-trichinella', 'neuronal-antibodies-panel-in-csf', 'newborn-screening-panel', 'nipt-sequentia-basic', 'nipt-sequentia-plus', 'nipt-sequentia-plus-expert', 'nipt-sequentia-premium', 'nipt-sequentia-premiumgene', 'nipt-sequentia-safe-full-karyo-plus', 'nipt-sequentia-safe-karyo-plus', 'nipt-veracity-basic', 'nipt-veracity-plus', 'nipt-veracity-premium', 'nipt-veragene', 'nmdar-antibodies-in-csf', 'nmdar-iga-antibodies', 'nmdar-igm-antibodies', 'non-hdl-cholesterol', 'omeprazole-level', 'pai-1-locus-844', 'pan-cancer-hereditary-panel', 'parainfluenza-virus-1-2-3-iga', 'parainfluenza-virus-1-2-3-igg', 'pivka-ii', 'platelets-in-citrated-blood', 'pmp22-mlpa-test', 'poliovirus-type-1-antibodies', 'poliovirus-type-3-antibodies', 'psychoactive-substances-in-hair', 'pyridinium-crosslinks-in-urine', 'reverse-t3', 'rsv-antigen-rapid-test', 'sars-cov-2-influenza-ab-rsv-antigen-rapid-test', 'serum-amyloid-a', 'sickle-cell-mutation-hbb-codon-6', 'silver', 'soluble-transferrin-receptor', 'spermatozoa-antibodies-asa-iga', 'spermatozoa-antibodies-asa-igm', 'spinal-muscular-atrophy-genetic-test', 'streptococcus-pneumoniae-igg', 'sulfur', 'swab-bacteria-catheter-cyst-other', 'swab-fungi-catheter-cyst-other', 'tartrate-resistant-acid-phosphatase', 'tetanus-antibodies', 'thrombophilia-3-genes-4-loci', 'tin', 'topiramate-level', 'toxocara-canis-igg-western-blot', 'toxoplasma-gondii-pcr', 'tracheostomy-swab-fungi', 'treponema-pallidum-igm-western-blot', 'treponema-pallidum-total-antibodies', 'tryptase', 'uroporphyrin-in-urine', 'venlafaxine-and-metabolites-level', 'very-long-chain-fatty-acids-c22-c26', 'vitamin-b3', 'vitamin-b5', 'yersinia-enterocolitica-detection', 'yersinia-iga-western-blot', 'yersinia-igg-western-blot')
	AND NOT EXISTS (SELECT 1 FROM lab_test_categories_relations r WHERE r.lab_test_id = lt.id);

-- У каждой из 9 лабораторий: анализов 514 + 189 = 703, услуг 7, цен 0
SELECT c.slug,
	(SELECT COUNT(*) FROM clinic_lab_tests x WHERE x.clinic_id = c.id) AS lab_tests,
	(SELECT COUNT(*) FROM clinic_medical_services x WHERE x.clinic_id = c.id) AS services,
	(SELECT COUNT(*) FROM clinic_lab_tests x WHERE x.clinic_id = c.id AND x.price IS NOT NULL) AS with_price
FROM clinics c
WHERE c.slug LIKE 'moj-lab-laboratorija-%'
ORDER BY c.slug;
