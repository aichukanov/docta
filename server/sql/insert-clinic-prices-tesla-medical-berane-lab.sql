SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Tesla Medical (Беране, slug tesla-medical-berane) — прайс лаборатории (новый, анализов у клиники не было).
--
-- Оба PDF помечены владельцем «radna verzija» (черновик); применять решено (юзер, 2026-10-05).
--
-- Источники (сняты 2026-10-02 curl'ом, снимки в data/clinic-pricelists/sources/tesla-medical-berane/):
--   https://www.teslamedical.me/wp-content/uploads/2019/11/cenovnik-biohemija-radna-verzija.pdf
--     54 стр. Excel-распечатки: колонки разнесены по страницам (1–18 раздел, 19–36 название,
--     37–54 цена), строки склеены по y-координате; 893 строки, 879 с ценой.
--   https://www.teslamedical.me/wp-content/uploads/2019/11/cenovnik-mikrobiologija.pdf
--     3 стр., 121 строка, 118 с ценой.
--   Дата: Last-Modified и CreationDate PDF — 2019-11-26. is_price_outdated не ставится: кроме даты,
--   признаков устаревания нет (в отзывах — ни одной цены из прайса; решение юзера 2026-10-05).
--   Метки «#» / «##» в названиях — служебные пометки лаборатории, расшифровки на сайте нет.
--
-- Сводка: строк в двух PDF 1014, с ценой 975 («0.00», «/» и пустые — 39 — не заводятся); из них раздел «Usluge» 5, анализов 970.
--   925 строк прайса → 882 строк clinic_lab_tests: 633 на существующие записи, 249 на новые записи каталога;
--   28 строк спорные, 9 исключены (не анализ пациента), 6 строк «nakon provere DNK» не заведены,
--   2 строки — конфликт цен (циклоспорин).
--   Раздел «Usluge» (5 строк) → 3 строки clinic_medical_services (забор крови, branula, выезд на забор).
--   Разбор — data/clinic-imports/tesla-medical-berane-prices-2026-10.md, раздел «Лаборатория».
--
-- Клиника и записи каталога — только по slug (id локально и на проде расходятся).
-- INSERT IGNORE / ON DUPLICATE KEY: повторный прогон ничего не ломает.

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'tesla-medical-berane');

-- ═══ 1. Новые записи каталога (249) ═══

INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('11-Deoxycorticosterone', '11-deoxycorticosterone', '11-dezoksikortikosteron', '11-дезоксикортикостерон', '11-дезоксикортикостерон', '11-Desoxycorticosteron', '11-Deoksikortikosteron'),
('7-Dehydrocholesterol', '7-dehydrocholesterol', '7-dehidroholesterol', '7-дехидрохолестерол', '7-дегидрохолестерин', '7-Dehydrocholesterin', '7-dehidrokolesterol'),
('Acetylsalicylic Acid IgE', 'acetylsalicylic-acid-ige', 'Acetilsalicilna kiselina IgE', 'Ацетилсалицилна киселина IgE', 'Ацетилсалициловая кислота IgE', 'IgE gegen Acetylsalicylsäure', 'Asetilsalisilik asit IgE'),
('Acetylsalicylic Acid Level', 'acetylsalicylic-acid-level', 'Nivo acetilsalicilne kiseline', 'Ниво ацетилсалицилне киселине', 'Уровень ацетилсалициловой кислоты', 'Acetylsalicylsäure-Spiegel', 'Asetilsalisilik asit düzeyi'),
('Acid-Fast Bacilli Direct Smear', 'acid-fast-bacilli-direct-smear', 'Direktni preparat na bacil tuberkuloze', 'Директни препарат на бацил туберкулозе', 'Микроскопия мазка на кислотоустойчивые бактерии', 'Mikroskopischer Direktnachweis säurefester Stäbchen', 'Aside dirençli basil direkt yayması'),
('ADAMTS13 Gene Analysis', 'adamts13-gene-analysis', 'Genetsko ispitivanje ADAMTS13 gena', 'Генетско испитивање ADAMTS13 гена', 'Генетическое исследование гена ADAMTS13', 'ADAMTS13-Gendiagnostik', 'ADAMTS13 gen analizi'),
('Adenovirus PCR', 'adenovirus-pcr', 'Adenovirus PCR', 'Аденовирус PCR', 'Аденовирус ПЦР', 'Adenovirus PCR-Nachweis', 'Adenovirüs PCR testi'),
('Amino Acid Profile in 24h Urine', 'amino-acid-profile-in-24h-urine', 'Profil aminokiselina u 24h urinu', 'Профил аминокиселина у 24h урину', 'Профиль аминокислот в суточной моче', 'Aminosäureprofil im 24-Stunden-Urin', '24 saatlik idrarda amino asit profili'),
('Amniotic Fluid Culture', 'amniotic-fluid-culture', 'Bakteriološki pregled plodove vode', 'Бактериолошки преглед плодове воде', 'Бактериологический посев амниотической жидкости', 'Bakteriologische Kultur des Fruchtwassers', 'Amniyotik sıvı kültürü'),
('Amoxicillin IgE', 'amoxicillin-ige', 'Amoksicilin IgE', 'Амоксицилин IgE', 'Амоксициллин IgE', 'IgE gegen Amoxicillin', 'Amoksisilin IgE'),
('AMPA1 Receptor Antibodies', 'ampa1-receptor-antibodies', 'Antitijela na AMPA1 receptor', 'Антитијела на AMPA1 рецептор', 'Антитела к AMPA1-рецептору', 'AMPA1-Rezeptor-Antikörper', 'AMPA1 reseptör antikorları'),
('AMPA2 Receptor Antibodies', 'ampa2-receptor-antibodies', 'Antitijela na AMPA2 receptor', 'Антитијела на AMPA2 рецептор', 'Антитела к AMPA2-рецептору', 'AMPA2-Rezeptor-Antikörper', 'AMPA2 reseptör antikorları'),
('Amylase Isoenzymes', 'amylase-isoenzymes', 'Izoenzimi amilaze', 'Изоензими амилазе', 'Изоферменты амилазы', 'Amylase-Isoenzyme', 'Amilaz izoenzimleri'),
('Anaplasma phagocytophilum IgG', 'anaplasma-phagocytophilum-igg', 'Anaplasma phagocytophilum IgG', 'Anaplasma phagocytophilum IgG', 'Антитела IgG к Anaplasma phagocytophilum', 'Anaplasma phagocytophilum IgG-Antikörper', 'Anaplasma phagocytophilum IgG antikoru'),
('Anaplasma phagocytophilum IgM', 'anaplasma-phagocytophilum-igm', 'Anaplasma phagocytophilum IgM', 'Anaplasma phagocytophilum IgM', 'Антитела IgM к Anaplasma phagocytophilum', 'Anaplasma phagocytophilum IgM-Antikörper', 'Anaplasma phagocytophilum IgM antikoru'),
('Anti-BP180 Antibodies', 'anti-bp180-antibodies', 'Anti-BP180 antitijela', 'Анти-BP180 антитијела', 'Антитела к BP180', 'Anti-BP180-Antikörper', 'Anti-BP180 antikorları'),
('Anti-BP230 Antibodies', 'anti-bp230-antibodies', 'Anti-BP230 antitijela', 'Анти-BP230 антитијела', 'Антитела к BP230', 'Anti-BP230-Antikörper', 'Anti-BP230 antikorları'),
('Anti-Desmoglein 1 Antibodies', 'anti-desmoglein-1-antibodies', 'Antitijela na dezmoglein 1', 'Антитијела на дезмоглеин 1', 'Антитела к десмоглеину 1', 'Anti-Desmoglein-1-Antikörper', 'Anti-desmoglein 1 antikorları'),
('Anti-Desmoglein 3 Antibodies', 'anti-desmoglein-3-antibodies', 'Antitijela na dezmoglein 3', 'Антитијела на дезмоглеин 3', 'Антитела к десмоглеину 3', 'Anti-Desmoglein-3-Antikörper', 'Anti-desmoglein 3 antikorları'),
('Anti-Epidermal Basement Membrane Antibodies', 'anti-epidermal-basement-membrane-antibodies', 'Antitijela na bazalnu membranu epidermisa', 'Антитијела на базалну мембрану епидермиса', 'Антитела к базальной мембране эпидермиса', 'Antikörper gegen die epidermale Basalmembran', 'Epidermal bazal membran antikorları'),
('Anti-Epidermal Intercellular Substance Antibodies', 'anti-epidermal-intercellular-substance-antibodies', 'Antitijela na interćelijsku supstancu epidermisa', 'Антитијела на интерћелијску супстанцу епидермиса', 'Антитела к межклеточному веществу эпидермиса', 'Antikörper gegen die epidermale Interzellularsubstanz', 'Epidermal hücreler arası madde antikorları'),
('Anti-Histone Antibodies', 'anti-histone-antibodies', 'Antihistonska antitijela', 'Антихистонска антитијела', 'Антитела к гистонам', 'Anti-Histon-Antikörper', 'Anti-histon antikorları'),
('Anti-MCV Antibodies', 'anti-mcv-antibodies', 'Antitijela na mutirani citrulinirani vimentin (anti-MCV)', 'Антитијела на мутирани цитрулинирани виментин (анти-MCV)', 'Антитела к модифицированному цитруллинированному виментину (anti-MCV)', 'Antikörper gegen mutiertes citrulliniertes Vimentin (Anti-MCV)', 'Mutasyonlu sitrülinlenmiş vimentin antikorları (Anti-MCV)'),
('Anti-Mi-2 Antibodies', 'anti-mi-2-antibodies', 'Anti-Mi-2 antitijela', 'Anti-Mi-2 антитијела', 'Антитела к Mi-2', 'Anti-Mi-2-Antikörper', 'Anti-Mi-2 antikorları'),
('Anti-N-Type Calcium Channel Antibodies', 'anti-n-type-calcium-channel-antibodies', 'Antitijela na kalcijumske kanale N-tipa', 'Антитијела на калцијумске канале N-типа', 'Антитела к кальциевым каналам N-типа', 'Antikörper gegen N-Typ-Calciumkanäle', 'N tipi kalsiyum kanalı antikorları'),
('Anti-P/Q-Type Calcium Channel Antibodies', 'anti-p-q-type-calcium-channel-antibodies', 'Antitijela na kalcijumske kanale P/Q-tipa', 'Антитијела на калцијумске канале P/Q-типа', 'Антитела к кальциевым каналам P/Q-типа', 'Antikörper gegen P/Q-Typ-Calciumkanäle', 'P/Q tipi kalsiyum kanalı antikorları'),
('Anti-PLA2R Antibodies', 'anti-pla2r-antibodies', 'Antitijela na receptor fosfolipaze A2 (PLA2R)', 'Антитијела на рецептор фосфолипазе A2 (PLA2R)', 'Антитела к рецептору фосфолипазы A2 (PLA2R)', 'Antikörper gegen den Phospholipase-A2-Rezeptor (PLA2R)', 'Fosfolipaz A2 reseptörü (PLA2R) antikorları'),
('Anti-RNP-70 Antibodies', 'anti-rnp-70-antibodies', 'Anti-RNP-70 antitijela', 'Анти-RNP-70 антитијела', 'Антитела к RNP-70', 'Anti-RNP-70-Antikörper', 'Anti-RNP-70 antikorları'),
('Anti-Yo Antibodies', 'anti-yo-antibodies', 'Anti-Yo antitijela', 'Anti-Yo антитијела', 'Антитела к Yo', 'Anti-Yo-Antikörper', 'Anti-Yo antikorları'),
('Antimony in Blood', 'antimony-in-blood', 'Antimon u krvi', 'Антимон у крви', 'Сурьма в крови', 'Antimon im Blut', 'Kanda antimon'),
('Antioxidant Capacity of Lipid-Soluble Substances', 'antioxidant-capacity-of-lipid-soluble-substances', 'Antioksidativni kapacitet liposolubilnih supstanci', 'Антиоксидативни капацитет липосолубилних супстанци', 'Антиоксидантная ёмкость жирорастворимых веществ', 'Antioxidative Kapazität fettlöslicher Substanzen', 'Yağda çözünen maddelerin antioksidan kapasitesi'),
('APC Gene Mutations (Exon 15, Codons 1085-1160)', 'apc-gene-mutations-exon-15-codons-1085-1160', 'Mutacije u APC genu (15. egzon, kodoni 1085–1160)', 'Мутације у APC гену (15. егзон, кодони 1085–1160)', 'Мутации гена APC (экзон 15, кодоны 1085–1160)', 'APC-Genmutationen (Exon 15, Codons 1085–1160)', 'APC geni mutasyonları (ekzon 15, kodon 1085–1160)'),
('APOB Gene Mutation (Familial Defective ApoB-100)', 'apob-gene-mutation-familial-defective-apob-100', 'Mutacija APOB gena (familijarni defektni ApoB-100)', 'Мутација APOB гена (фамилијарни дефектни ApoB-100)', 'Мутация гена APOB (семейный дефект ApoB-100)', 'APOB-Genmutation (familiär defektes ApoB-100)', 'APOB gen mutasyonu (ailesel defektif ApoB-100)'),
('Apolipoprotein E Genotyping', 'apolipoprotein-e-genotyping', 'Genotipizacija apolipoproteina E', 'Генотипизација аполипопротеина E', 'Генотипирование аполипопротеина E', 'Apolipoprotein-E-Genotypisierung', 'Apolipoprotein E genotiplemesi'),
('Ascaris lumbricoides IgG', 'ascaris-lumbricoides-igg', 'Ascaris lumbricoides IgG', 'Ascaris lumbricoides IgG', 'Ascaris lumbricoides IgG (антитела к аскаридам)', 'Ascaris lumbricoides IgG-Antikörper', 'Ascaris lumbricoides IgG antikoru'),
('Aspergillus Total Antibodies', 'aspergillus-total-antibodies', 'Aspergillus ukupna antitijela', 'Aspergillus укупна антитијела', 'Суммарные антитела к Aspergillus', 'Aspergillus-Gesamtantikörper', 'Aspergillus toplam antikorları'),
('ATP7B Full Gene Sequencing', 'atp7b-full-gene-sequencing', 'Mutacije u ATP7B genu — cijeli gen (Wilsonova bolest)', 'Мутације у ATP7B гену — цијели ген (Вилсонова болест)', 'Секвенирование гена ATP7B, весь ген (болезнь Вильсона)', 'ATP7B-Sequenzierung, gesamtes Gen (Morbus Wilson)', 'ATP7B tam gen dizilemesi (Wilson hastalığı)'),
('ATP7B Known Familial Mutation Test', 'atp7b-known-familial-mutation-test', 'Mutacije u ATP7B genu — član porodice, poznata mutacija (Wilsonova bolest)', 'Мутације у ATP7B гену — члан породице, позната мутација (Вилсонова болест)', 'ATP7B: поиск известной семейной мутации (болезнь Вильсона)', 'ATP7B – Nachweis einer bekannten familiären Mutation (Morbus Wilson)', 'ATP7B bilinen ailesel mutasyon testi (Wilson hastalığı)'),
('Babesia IgG', 'babesia-igg', 'Babesia IgG', 'Babesia IgG', 'Антитела IgG к Babesia', 'Babesia IgG-Antikörper', 'Babesia IgG antikoru'),
('Babesia IgM', 'babesia-igm', 'Babesia IgM', 'Babesia IgM', 'Антитела IgM к Babesia', 'Babesia IgM-Antikörper', 'Babesia IgM antikoru'),
('Bacterial Identification by MALDI-TOF MS', 'bacterial-identification-by-maldi-tof-ms', 'Identifikacija bakterija MALDI-TOF MS metodom', 'Идентификација бактерија MALDI-TOF MS методом', 'Идентификация бактерий методом MALDI-TOF MS', 'Bakterienidentifizierung mittels MALDI-TOF MS', 'MALDI-TOF MS ile bakteri tanımlama'),
('Bacterial Vaginosis Test', 'bacterial-vaginosis-test', 'Test na bakterijsku vaginozu', 'Тест на бактеријску вагинозу', 'Тест на бактериальный вагиноз', 'Test auf bakterielle Vaginose', 'Bakteriyel vajinoz testi'),
('Barium in Serum', 'barium-in-serum', 'Barijum u serumu', 'Баријум у серуму', 'Барий в сыворотке крови', 'Barium im Serum', 'Serumda baryum'),
('Becker Muscular Dystrophy Genetic Test', 'becker-muscular-dystrophy-genetic-test', 'Bekerova mišićna distrofija — genetsko ispitivanje', 'Бекерова мишићна дистрофија — генетско испитивање', 'Мышечная дистрофия Беккера — генетический тест', 'Muskeldystrophie Becker – Gentest', 'Becker kas distrofisi genetik testi'),
('Beta-Trace Protein', 'beta-trace-protein', 'Beta-trace protein u sekretu', 'Бета-траце протеин у секрету', 'Бета-трейс-протеин в отделяемом', 'Beta-Trace-Protein im Sekret', 'Salgıda beta-trace protein'),
('Biliary Atresia Genetic Test', 'biliary-atresia-genetic-test', 'Bilijarna atrezija — genetsko ispitivanje', 'Билијарна атрезија — генетско испитивање', 'Билиарная атрезия — генетическое исследование', 'Gallengangsatresie – Gentest', 'Biliyer atrezi genetik testi'),
('Biopsy Material Mycobacterial Culture (Lowenstein-Jensen)', 'biopsy-material-mycobacterial-culture-lowenstein-jensen', 'Kultura biopsijskog materijala na mikobakterije (Löwenstein-Jensen)', 'Култура биопсијског материјала на микобактерије (Löwenstein-Jensen)', 'Посев биопсийного материала на микобактерии (Левенштейн-Йенсен)', 'Mykobakterienkultur aus Biopsiematerial (Löwenstein-Jensen)', 'Biyopsi materyalinde mikobakteri kültürü (Löwenstein-Jensen)'),
('Borrelia burgdorferi IgG in CSF', 'borrelia-burgdorferi-igg-in-csf', 'Borrelia burgdorferi IgG u likvoru', 'Borrelia burgdorferi IgG у ликвору', 'Антитела IgG к Borrelia burgdorferi в ликворе', 'Borrelia burgdorferi IgG-Antikörper im Liquor', 'Beyin omurilik sıvısında Borrelia burgdorferi IgG'),
('Borrelia burgdorferi IgM in CSF', 'borrelia-burgdorferi-igm-in-csf', 'Borrelia burgdorferi IgM u likvoru', 'Borrelia burgdorferi IgM у ликвору', 'Антитела IgM к Borrelia burgdorferi в ликворе', 'Borrelia burgdorferi IgM-Antikörper im Liquor', 'Beyin omurilik sıvısında Borrelia burgdorferi IgM'),
('BRCA1 Full Gene Sequencing', 'brca1-full-gene-sequencing', 'Mutacije u BRCA1 genu (cijeli gen)', 'Мутације у BRCA1 гену (цијели ген)', 'Секвенирование гена BRCA1 (весь ген)', 'BRCA1-Sequenzierung (gesamtes Gen)', 'BRCA1 tam gen dizilemesi'),
('BRCA1 Known Familial Mutation Test', 'brca1-known-familial-mutation-test', 'Mutacije u BRCA1 genu (član porodice – poznata mutacija)', 'Мутације у BRCA1 гену (члан породице – позната мутација)', 'BRCA1: поиск известной семейной мутации', 'BRCA1 – Nachweis einer bekannten familiären Mutation', 'BRCA1 bilinen ailesel mutasyon testi'),
('BRCA1 Partial Sequencing', 'brca1-partial-sequencing', 'Mutacije u BRCA1 genu (parcijalno sekvenciranje)', 'Мутације у BRCA1 гену (парцијално секвенцирање)', 'Частичное секвенирование гена BRCA1', 'BRCA1 – partielle Sequenzierung', 'BRCA1 kısmi dizileme'),
('BRCA2 Full Gene Sequencing', 'brca2-full-gene-sequencing', 'Mutacije u BRCA2 genu (cijeli gen)', 'Мутације у BRCA2 гену (цијели ген)', 'Секвенирование гена BRCA2 (весь ген)', 'BRCA2-Sequenzierung (gesamtes Gen)', 'BRCA2 tam gen dizilemesi'),
('BRCA2 Known Familial Mutation Test', 'brca2-known-familial-mutation-test', 'Mutacije u BRCA2 genu (član porodice – poznata mutacija)', 'Мутације у BRCA2 гену (члан породице – позната мутација)', 'BRCA2: поиск известной семейной мутации', 'BRCA2 – Nachweis einer bekannten familiären Mutation', 'BRCA2 bilinen ailesel mutasyon testi'),
('BRCA2 Partial Sequencing', 'brca2-partial-sequencing', 'Mutacije u BRCA2 genu (parcijalno sekvenciranje)', 'Мутације у BRCA2 гену (парцијално секвенцирање)', 'Частичное секвенирование гена BRCA2', 'BRCA2 – partielle Sequenzierung', 'BRCA2 kısmi dizileme'),
('Bromazepam Level', 'bromazepam-level', 'Nivo bromazepama', 'Ниво бромазепама', 'Уровень бромазепама', 'Bromazepam-Spiegel', 'Bromazepam düzeyi'),
('Bronchial Aspirate Culture for Bacteria', 'bronchial-aspirate-culture-for-bacteria', 'Kultura bronhoaspirata na bakterije', 'Култура бронхоаспирата на бактерије', 'Посев бронхоаспирата на бактерии', 'Bakterienkultur des Bronchialaspirats', 'Bronş aspiratı bakteri kültürü'),
('Bronchial Aspirate Culture for Fungi', 'bronchial-aspirate-culture-for-fungi', 'Kultura bronhoaspirata na gljivice', 'Култура бронхоаспирата на гљивице', 'Посев бронхоаспирата на грибы', 'Pilzkultur des Bronchialaspirats', 'Bronş aspiratı mantar kültürü'),
('BTNL2 Gene Mutations (Exons 5 and 6)', 'btnl2-gene-mutations-exons-5-and-6', 'Mutacije u BTNL2 genu — 5. i 6. egzon (sarkoidoza)', 'Мутације у BTNL2 гену — 5. и 6. егзон (саркоидоза)', 'Мутации гена BTNL2 — экзоны 5 и 6 (саркоидоз)', 'BTNL2-Genmutationen – Exons 5 und 6 (Sarkoidose)', 'BTNL2 geni mutasyonları – ekzon 5 ve 6 (sarkoidoz)'),
('C1 Inhibitor Functional', 'c1-inhibitor-functional', 'Funkcionalni C1 inhibitor', 'Функционални C1 инхибитор', 'Функциональная активность C1-ингибитора', 'C1-Inhibitor-Aktivität', 'Fonksiyonel C1 inhibitör'),
('Candida Antigen', 'candida-antigen', 'Candida antigen', 'Candida антиген', 'Антиген Candida', 'Candida-Antigen', 'Candida antijeni'),
('Candida IgA Antibodies', 'candida-iga-antibodies', 'Candida IgA antitijela', 'Candida IgA антитијела', 'Антитела IgA к Candida', 'Candida IgA-Antikörper', 'Candida IgA antikorları'),
('Cannabinoids in Urine LC-MS', 'cannabinoids-in-urine-lc-ms', 'Kanabinoidi u urinu LC-MS', 'Канабиноиди у урину LC-MS', 'Каннабиноиды в моче методом ЖХ-МС', 'Cannabinoide im Urin (LC-MS)', 'İdrarda kannabinoidler (LC-MS)'),
('Carnitine in Urine', 'carnitine-in-urine', 'Karnitin u urinu', 'Карнитин у урину', 'Карнитин в моче', 'Carnitin im Urin', 'İdrarda karnitin'),
('CASPR2 Antibodies', 'caspr2-antibodies', 'Antitijela na CASPR2', 'Антитијела на CASPR2', 'Антитела к CASPR2', 'CASPR2-Antikörper', 'CASPR2 antikorları'),
('Cefaclor IgE', 'cefaclor-ige', 'Cefaklor IgE', 'Цефаклор IgE', 'Цефаклор IgE', 'IgE gegen Cefaclor', 'Sefaklor IgE'),
('Cefalotin IgE', 'cefalotin-ige', 'Cefalotin IgE', 'Цефалотин IgE', 'Цефалотин IgE', 'IgE gegen Cefalotin', 'Sefalotin IgE'),
('Chlamydia psittaci IgA', 'chlamydia-psittaci-iga', 'Chlamydia psittaci IgA', 'Chlamydia psittaci IgA', 'Антитела к Chlamydia psittaci IgA', 'Chlamydia-psittaci-IgA-Antikörper', 'Chlamydia psittaci IgA antikoru'),
('Chlamydia psittaci IgG', 'chlamydia-psittaci-igg', 'Chlamydia psittaci IgG', 'Chlamydia psittaci IgG', 'Антитела к Chlamydia psittaci IgG', 'Chlamydia-psittaci-IgG-Antikörper', 'Chlamydia psittaci IgG antikoru'),
('Chlamydia psittaci IgM', 'chlamydia-psittaci-igm', 'Chlamydia psittaci IgM', 'Chlamydia psittaci IgM', 'Антитела к Chlamydia psittaci IgM', 'Chlamydia-psittaci-IgM-Antikörper', 'Chlamydia psittaci IgM antikoru'),
('Cholestasis Gene Panel (15 Genes)', 'cholestasis-gene-panel-15-genes', 'Panel — holestaza (15 gena)', 'Панел — холестаза (15 гена)', 'Генетическая панель «Холестаз» (15 генов)', 'Genpanel Cholestase (15 Gene)', 'Kolestaz gen paneli (15 gen)'),
('Chromium in Serum', 'chromium-in-serum', 'Hrom u serumu', 'Хром у серуму', 'Хром в сыворотке', 'Chrom im Serum', 'Serumda krom'),
('Chromium in Urine', 'chromium-in-urine', 'Hrom u urinu', 'Хром у урину', 'Хром в моче', 'Chrom im Urin', 'İdrarda krom'),
('Chromosomal Aberration Test', 'chromosomal-aberration-test', 'Test hromozomskih aberacija', 'Тест хромозомских аберација', 'Тест хромосомных аберраций', 'Chromosomenaberrationstest', 'Kromozom aberasyon testi'),
('CK Isoenzymes', 'ck-isoenzymes', 'Izoenzimi kreatin kinaze', 'Изоензими креатин киназе', 'Изоферменты креатинкиназы', 'CK-Isoenzyme', 'CK izoenzimleri'),
('Cladosporium herbarum IgE m2', 'cladosporium-herbarum-ige-m2', 'Plijesan Cladosporium herbarum IgE m2', 'Плијесан Cladosporium herbarum IgE m2', 'Плесень Cladosporium herbarum IgE m2', 'Schimmelpilz Cladosporium herbarum IgE m2', 'Küf mantarı Cladosporium herbarum IgE m2'),
('Clonazepam Level', 'clonazepam-level', 'Nivo klonazepama', 'Ниво клоназепама', 'Уровень клоназепама', 'Clonazepam-Spiegel', 'Klonazepam düzeyi'),
('Clostridium difficile PCR', 'clostridium-difficile-pcr', 'Clostridium difficile PCR', 'Clostridium difficile PCR', 'Clostridium difficile ПЦР', 'Clostridium-difficile-PCR', 'Clostridium difficile PCR testi'),
('Clozapine Level', 'clozapine-level', 'Nivo klozapina', 'Ниво клозапина', 'Уровень клозапина', 'Clozapin-Spiegel', 'Klozapin düzeyi'),
('Cobalt in Blood', 'cobalt-in-blood', 'Kobalt u krvi', 'Кобалт у крви', 'Кобальт в крови', 'Kobalt im Blut', 'Kanda kobalt'),
('Cocaine in Urine GC-MS', 'cocaine-in-urine-gc-ms', 'Kokain u urinu GC-MS', 'Кокаин у урину GC-MS', 'Кокаин в моче методом ГХ-МС', 'Kokain im Urin (GC-MS)', 'İdrarda kokain (GC-MS)'),
('Codeine IgE', 'codeine-ige', 'Kodein IgE', 'Кодеин IgE', 'Кодеин IgE', 'IgE gegen Codein', 'Kodein IgE'),
('Complexed PSA', 'complexed-psa', 'Kompleksirani PSA', 'Комплексирани PSA', 'Связанный PSA', 'Komplexiertes PSA', 'Kompleks PSA'),
('Copeptin', 'copeptin', 'Kopeptin', 'Копептин', 'Копептин', 'Copeptin (C-terminales Provasopressin)', 'Kopeptin'),
('Cotinine in Serum', 'cotinine-in-serum', 'Kotinin u serumu', 'Котинин у серуму', 'Котинин в сыворотке', 'Cotinin im Serum', 'Serumda kotinin'),
('Coxsackie Virus IgG in CSF', 'coxsackie-virus-igg-in-csf', 'Koksaki virus IgG u likvoru', 'Коксаки вирус IgG у ликвору', 'Вирус Коксаки IgG в ликворе', 'Coxsackie-Virus-IgG im Liquor', 'BOS''ta Coxsackie virüsü IgG'),
('Cryofibrinogen', 'cryofibrinogen', 'Kriofibrinogen', 'Криофибриноген', 'Криофибриноген', 'Kryofibrinogen', 'Kriyofibrinojen'),
('Cryptococcus neoformans PCR', 'cryptococcus-neoformans-pcr', 'Cryptococcus neoformans PCR', 'Cryptococcus neoformans PCR', 'Cryptococcus neoformans ПЦР', 'Cryptococcus-neoformans-PCR', 'Cryptococcus neoformans PCR testi'),
('Cyclic AMP in Plasma', 'cyclic-amp-in-plasma', 'Ciklični AMP u plazmi', 'Циклични AMP у плазми', 'Циклический АМФ в плазме', 'Zyklisches AMP im Plasma', 'Plazmada siklik AMP'),
('Cyclic AMP in Urine', 'cyclic-amp-in-urine', 'Ciklični AMP u urinu', 'Циклични AMP у урину', 'Циклический АМФ в моче', 'Zyklisches AMP im Urin', 'İdrarda siklik AMP'),
('CYP27A1 Gene Analysis', 'cyp27a1-gene-analysis', 'Genetsko ispitivanje CYP27A1 gena', 'Генетско испитивање CYP27A1 гена', 'Генетическое исследование гена CYP27A1', 'CYP27A1-Gendiagnostik', 'CYP27A1 gen analizi'),
('Cytomegalovirus PCR Quantitative', 'cytomegalovirus-pcr-quantitative', 'Citomegalovirus PCR kvantitativni', 'Цитомегаловирус PCR квантитативни', 'Цитомегаловирус ПЦР количественный', 'Zytomegalievirus PCR quantitativ', 'Sitomegalovirüs kantitatif PCR'),
('DHEA', 'dhea', 'Dehidroepiandrosteron', 'Дехидроепиандростерон', 'Дегидроэпиандростерон (ДГЭА)', 'Dehydroepiandrosteron (DHEA)', 'Dehidroepiandrosteron (DHEA)'),
('DNA Kinship Test Additional Person', 'dna-kinship-test-additional-person', 'DNK test srodstva — dodatni član porodice', 'DNK тест сродства — додатни члан породице', 'ДНК-тест родства — дополнительный участник', 'DNA-Abstammungstest – weitere Person', 'DNA akrabalık testi – ek kişi'),
('Dog Dander IgE e5', 'dog-dander-ige-e5', 'Pseća perut IgE e5', 'Псећа перут IgE e5', 'Перхоть собаки IgE e5', 'Hundeschuppen IgE e5', 'Köpek kepeği IgE e5'),
('Doxycycline IgE', 'doxycycline-ige', 'Doksiciklin IgE', 'Доксициклин IgE', 'Доксициклин IgE', 'IgE gegen Doxycyclin', 'Doksisiklin IgE'),
('DSP Gene Mutations (Exon 24)', 'dsp-gene-mutations-exon-24', 'Mutacije u DSP genu — 24. egzon', 'Мутације у DSP гену — 24. егзон', 'Мутации гена DSP (экзон 24)', 'DSP-Genmutationen (Exon 24)', 'DSP geni mutasyonları (ekzon 24)'),
('Echinococcus Antigen', 'echinococcus-antigen', 'Echinococcus antigen', 'Echinococcus антиген', 'Антиген Echinococcus', 'Echinococcus-Antigen', 'Echinococcus antijeni'),
('EGFR Gene Mutations (Exons 18-21)', 'egfr-gene-mutations-exons-18-21', 'Mutacije u EGFR genu (egzoni 18–21)', 'Мутације у EGFR гену (егзони 18–21)', 'Мутации гена EGFR (экзоны 18–21)', 'EGFR-Genmutationen (Exons 18–21)', 'EGFR geni mutasyonları (ekzon 18–21)'),
('Enterovirus Antibodies', 'enterovirus-antibodies', 'Antitijela na enteroviruse (Coxsackie, ECHO, Polio)', 'Антитијела на ентеровирусе (Coxsackie, ECHO, Полио)', 'Антитела к энтеровирусам (Coxsackie, ECHO, Polio)', 'Enterovirus-Antikörper (Coxsackie, ECHO, Polio)', 'Enterovirüs antikorları (Coxsackie, ECHO, Polio)'),
('Erythrocyte Porphyrins', 'erythrocyte-porphyrins', 'Porfirini u eritrocitima', 'Порфирини у еритроцитима', 'Порфирины в эритроцитах', 'Porphyrine in Erythrozyten', 'Eritrosit porfirinleri'),
('Exocrine Pancreas Antibodies', 'exocrine-pancreas-antibodies', 'Antitijela na egzokrini pankreas', 'Антитијела на егзокрини панкреас', 'Антитела к экзокринной части поджелудочной железы', 'Antikörper gegen exokrines Pankreas', 'Ekzokrin pankreas antikorları'),
('Extended Antibiogram (E-test)', 'extended-antibiogram-e-test', 'Prošireni antibiogram (E-test)', 'Проширени антибиограм (E-тест)', 'Расширенная антибиотикограмма (E-тест)', 'Erweitertes Antibiogramm (E-Test)', 'Genişletilmiş antibiyogram (E-test)'),
('F9 Gene Mutations and Deletions (Hemophilia B)', 'f9-gene-mutations-and-deletions-hemophilia-b', 'Mutacije i delecije u F9 genu (hemofilija B)', 'Мутације и делеције у F9 гену (хемофилија B)', 'Мутации и делеции гена F9 (гемофилия B)', 'Mutationen und Deletionen im F9-Gen (Hämophilie B)', 'F9 geni mutasyon ve delesyonları (hemofili B)'),
('Facioscapulohumeral Muscular Dystrophy (FSHD1) Genetic Test', 'facioscapulohumeral-muscular-dystrophy-fshd1-genetic-test', 'Facioskapulohumeralna mišićna distrofija (FSHD1) — genetsko ispitivanje', 'Фациоскапулохумерална мишићна дистрофија (FSHD1) — генетско испитивање', 'Плече-лопаточно-лицевая мышечная дистрофия (FSHD1) — генетический тест', 'Fazioskapulohumerale Muskeldystrophie (FSHD1) – Gentest', 'Fasiyoskapulohumeral kas distrofisi (FSHD1) genetik testi'),
('FGF-23', 'fgf-23', 'Faktor rasta fibroblasta 23', 'Фактор раста фибробласта 23', 'Фактор роста фибробластов 23 (FGF-23)', 'Fibroblasten-Wachstumsfaktor 23', 'Fibroblast büyüme faktörü 23'),
('FGFR2 Gene Mutations (Exon 7)', 'fgfr2-gene-mutations-exon-7', 'Mutacije u FGFR2 genu — 7. egzon (Apertov sindrom)', 'Мутације у FGFR2 гену — 7. егзон (Апертов синдром)', 'Мутации гена FGFR2 — экзон 7 (синдром Апера)', 'FGFR2-Genmutationen – Exon 7 (Apert-Syndrom)', 'FGFR2 geni mutasyonları – ekzon 7 (Apert sendromu)'),
('Flecainide Level', 'flecainide-level', 'Nivo flekainida', 'Ниво флекаинида', 'Уровень флекаинида', 'Flecainid-Spiegel', 'Flekainid düzeyi'),
('Food Intolerance Panel 95 Foods', 'food-intolerance-panel-95-foods', 'Intolerancija na hranu 95 namirnica', 'Интолеранција на храну 95 намирница', 'Пищевая непереносимость, панель 95 продуктов', 'Nahrungsmittelunverträglichkeit Panel 95 Lebensmittel', 'Gıda intoleransı paneli 95 gıda'),
('Food Mix fx5', 'food-mix-fx5', 'Miks namirnica fx5', 'Микс намирница fx5', 'Смесь пищевых аллергенов fx5', 'Nahrungsmittelmischung fx5', 'Gıda karışımı fx5'),
('Formic Acid in Urine', 'formic-acid-in-urine', 'Mravlja kiselina u urinu', 'Мравља киселина у урину', 'Муравьиная кислота в моче', 'Ameisensäure im Urin', 'İdrarda formik asit'),
('Free Carnitine in Serum', 'free-carnitine-in-serum', 'Slobodni karnitin u serumu', 'Слободни карнитин у серуму', 'Свободный карнитин в сыворотке', 'Freies Carnitin im Serum', 'Serumda serbest karnitin'),
('Free Hemoglobin in Plasma', 'free-hemoglobin-in-plasma', 'Slobodni hemoglobin u plazmi', 'Слободни хемоглобин у плазми', 'Свободный гемоглобин в плазме', 'Freies Hämoglobin im Plasma', 'Plazmada serbest hemoglobin'),
('Free Protein S', 'free-protein-s', 'Slobodni protein S', 'Слободни протеин S', 'Свободный протеин S', 'Freies Protein S', 'Serbest protein S'),
('Fructose in Semen', 'fructose-in-semen', 'Fruktoza u spermi', 'Фруктоза у сперми', 'Фруктоза в сперме', 'Fruktose im Sperma', 'Menide fruktoz'),
('GABA-B Receptor Antibodies', 'gaba-b-receptor-antibodies', 'Antitijela na GABA-B receptor', 'Антитијела на GABA-B рецептор', 'Антитела к GABA-B-рецептору', 'GABA-B-Rezeptor-Antikörper', 'GABA-B reseptör antikorları'),
('Gallstone Analysis', 'gallstone-analysis', 'Analiza kamena iz žučne kese', 'Анализа камена из жучне кесе', 'Анализ желчного камня', 'Gallensteinanalyse', 'Safra taşı analizi'),
('Ganglioside Antibodies IgM', 'ganglioside-antibodies-igm', 'Antitijela na gangliozide IgM', 'Антитијела на ганглиозиде IgM', 'Антитела к ганглиозидам IgM', 'Gangliosid-Antikörper IgM', 'Gangliozit antikorları IgM'),
('Ganglioside IgG Antibodies', 'ganglioside-igg-antibodies', 'Antitijela na gangliozide IgG', 'Антитијела на ганглиозиде IgG', 'Антитела к ганглиозидам IgG', 'Gangliosid-Antikörper IgG', 'Gangliozit IgG antikorları'),
('GBA Gene Mutations (Exons 2, 9, 10 and 11)', 'gba-gene-mutations-exons-2-9-10-and-11', 'Mutacije u GBA genu — egzoni 2, 9, 10 i 11 (Gošeova bolest)', 'Мутације у GBA гену — егзони 2, 9, 10 и 11 (Гошеова болест)', 'Мутации гена GBA — экзоны 2, 9, 10 и 11 (болезнь Гоше)', 'GBA-Genmutationen – Exons 2, 9, 10 und 11 (Morbus Gaucher)', 'GBA geni mutasyonları – ekzon 2, 9, 10 ve 11 (Gaucher hastalığı)'),
('GD1a Antibodies IgG', 'gd1a-antibodies-igg', 'Antitijela na gangliozid GD1a IgG', 'Антитијела на ганглиозид GD1a IgG', 'Антитела к ганглиозиду GD1a IgG', 'Antikörper gegen Gangliosid GD1a IgG', 'Gangliozit GD1a antikorları IgG'),
('GD1a Antibodies IgM', 'gd1a-antibodies-igm', 'Antitijela na gangliozid GD1a IgM', 'Антитијела на ганглиозид GD1a IgM', 'Антитела к ганглиозиду GD1a IgM', 'Antikörper gegen Gangliosid GD1a IgM', 'Gangliozit GD1a antikorları IgM'),
('GD1b Antibodies IgG', 'gd1b-antibodies-igg', 'Antitijela na gangliozid GD1b IgG', 'Антитијела на ганглиозид GD1b IgG', 'Антитела к ганглиозиду GD1b IgG', 'Antikörper gegen Gangliosid GD1b IgG', 'Gangliozit GD1b antikorları IgG'),
('GD1b Antibodies IgM', 'gd1b-antibodies-igm', 'Antitijela na gangliozid GD1b IgM', 'Антитијела на ганглиозид GD1b IgM', 'Антитела к ганглиозиду GD1b IgM', 'Antikörper gegen Gangliosid GD1b IgM', 'Gangliozit GD1b antikorları IgM'),
('Genetic DNA Profile', 'genetic-dna-profile', 'Genetički DNK profil', 'Генетички DNK профил', 'Генетический ДНК-профиль', 'Genetisches DNA-Profil', 'Genetik DNA profili'),
('Genotoxicity Test', 'genotoxicity-test', 'Test genotoksičnosti', 'Тест генотоксичности', 'Тест на генотоксичность', 'Genotoxizitätstest', 'Genotoksisite testi'),
('Gentamicin IgE', 'gentamicin-ige', 'Gentamicin IgE', 'Гентамицин IgE', 'Гентамицин IgE', 'IgE gegen Gentamicin', 'Gentamisin IgE'),
('GLDH Glutamate Dehydrogenase', 'gldh-glutamate-dehydrogenase', 'GLDH glutamat dehidrogenaza', 'GLDH глутамат дехидрогеназа', 'ГЛДГ глутаматдегидрогеназа', 'GLDH Glutamatdehydrogenase', 'GLDH glutamat dehidrogenaz'),
('Glucose Challenge Test (O''Sullivan)', 'glucose-challenge-test-o-sullivan', 'O''Sullivanov test (glukoza 1h nakon 50 g)', 'О''Саливанов тест (глукоза 1h након 50 г)', 'Тест О''Салливана (глюкозный скрининг-тест 50 г)', 'Glukose-Challenge-Test (O''Sullivan-Test, 50 g)', 'Glukoz tarama testi (O''Sullivan, 50 g)'),
('Glucose in CSF', 'glucose-in-csf', 'Glukoza u likvoru', 'Глукоза у ликвору', 'Глюкоза в ликворе', 'Glukose im Liquor', 'Beyin omurilik sıvısında glukoz'),
('GM1 Antibodies Total', 'gm1-antibodies-total', 'Ukupna antitijela na gangliozid GM1', 'Укупна антитијела на ганглиозид GM1', 'Антитела к ганглиозиду GM1 общие', 'Antikörper gegen Gangliosid GM1 gesamt', 'Gangliozit GM1 toplam antikorları'),
('GM2 Antibodies IgG', 'gm2-antibodies-igg', 'Antitijela na gangliozid GM2 IgG', 'Антитијела на ганглиозид GM2 IgG', 'Антитела к ганглиозиду GM2 IgG', 'Antikörper gegen Gangliosid GM2 IgG', 'Gangliozit GM2 antikorları IgG'),
('GM2 Antibodies IgM', 'gm2-antibodies-igm', 'Antitijela na gangliozid GM2 IgM', 'Антитијела на ганглиозид GM2 IgM', 'Антитела к ганглиозиду GM2 IgM', 'Antikörper gegen Gangliosid GM2 IgM', 'Gangliozit GM2 antikorları IgM'),
('Haloperidol Level', 'haloperidol-level', 'Nivo haloperidola', 'Ниво халоперидола', 'Уровень галоперидола', 'Haloperidol-Spiegel', 'Haloperidol düzeyi'),
('HAMA Human Anti-Mouse Antibodies', 'hama-human-anti-mouse-antibodies', 'HAMA humana antimišja antitijela', 'HAMA хумана антимишја антитијела', 'HAMA человеческие антимышиные антитела', 'HAMA humane Anti-Maus-Antikörper', 'HAMA insan anti-fare antikorları'),
('Helicobacter pylori PCR in Stool', 'helicobacter-pylori-pcr-in-stool', 'Helicobacter pylori PCR u stolici', 'Helicobacter pylori PCR у столици', 'Helicobacter pylori ПЦР в кале', 'Helicobacter-pylori-PCR im Stuhl', 'Dışkıda Helicobacter pylori PCR'),
('Helicobacter pylori Urea Breath Test', 'helicobacter-pylori-urea-breath-test', 'Izdisajni urea test na Helicobacter pylori', 'Издисајни уреа тест на Helicobacter pylori', 'Дыхательный уреазный тест на Helicobacter pylori', 'Helicobacter-pylori-Harnstoff-Atemtest', 'Helicobacter pylori üre nefes testi'),
('Hereditary Disease Carrier Screening (400 Mutations)', 'hereditary-disease-carrier-screening-400-mutations', 'Skrining na nasljedne bolesti (400 mutacija)', 'Скрининг на насљедне болести (400 мутација)', 'Скрининг носительства наследственных заболеваний (400 мутаций)', 'Trägerscreening auf Erbkrankheiten (400 Mutationen)', 'Kalıtsal hastalık taşıyıcılık taraması (400 mutasyon)'),
('Hereditary Thrombophilia Panel 9 Mutations', 'hereditary-thrombophilia-panel-9-mutations', 'Panel nasljednih trombofilija 9 mutacija', 'Панел насљедних тромбофилија 9 мутација', 'Панель наследственных тромбофилий, 9 мутаций', 'Panel erblicher Thrombophilie, 9 Mutationen', 'Kalıtsal trombofili paneli, 9 mutasyon'),
('Herpes Simplex Virus 1/2 and Varicella Zoster Virus PCR', 'herpes-simplex-virus-1-2-and-varicella-zoster-virus-pcr', 'Herpes simplex virus 1/2 i varičela zoster virus PCR', 'Herpes simplex вирус 1/2 и варичела зостер вирус PCR', 'Вирус простого герпеса 1/2 и вирус варицелла-зостер ПЦР', 'Herpes-simplex-Virus 1/2 und Varizella-Zoster-Virus PCR', 'Herpes simpleks virüsü 1/2 ve varisella zoster virüsü PCR'),
('HFE Known Familial Mutation Test', 'hfe-known-familial-mutation-test', 'Mutacije u HFE genu — član porodice, poznata mutacija (hemohromatoza)', 'Мутације у HFE гену — члан породице, позната мутација (хемохроматоза)', 'HFE: поиск известной семейной мутации (гемохроматоз)', 'HFE – Nachweis einer bekannten familiären Mutation (Hämochromatose)', 'HFE bilinen ailesel mutasyon testi (hemokromatoz)'),
('HIF1A Gene Mutation (Sports Genetics)', 'hif1a-gene-mutation-sports-genetics', 'Sportska analiza — mutacija u HIF1A genu', 'Спортска анализа — мутација у HIF1A гену', 'Спортивная генетика — мутация гена HIF1A', 'Sportgenetik – Mutation im HIF1A-Gen', 'Spor genetiği – HIF1A gen mutasyonu'),
('HIV PCR RNA Qualitative', 'hiv-pcr-rna-qualitative', 'HIV PCR RNK kvalitativni', 'HIV PCR RNK квалитативни', 'ВИЧ ПЦР РНК качественный', 'HIV-RNA PCR qualitativ', 'HIV RNA PCR kalitatif'),
('HLA-DRB1 Typing', 'hla-drb1-typing', 'HLA-DRB1 tipizacija', 'HLA-DRB1 типизација', 'HLA-DRB1 типирование', 'HLA-DRB1-Typisierung', 'HLA-DRB1 tiplendirmesi'),
('House Dust Mix hx2', 'house-dust-mix-hx2', 'Miks kućne prašine hx2', 'Микс кућне прашине hx2', 'Смесь домашней пыли hx2', 'Hausstaubmischung hx2', 'Ev tozu karışımı hx2'),
('Hyaluronic Acid', 'hyaluronic-acid', 'Hijaluronska kiselina', 'Хијалуронска киселина', 'Гиалуроновая кислота', 'Hyaluronsäure', 'Hiyalüronik asit'),
('IgE Antibodies to Bovine Insulin', 'ige-antibodies-to-bovine-insulin', 'IgE antitijela na goveđi insulin', 'IgE антитијела на говеђи инсулин', 'IgE-антитела к бычьему инсулину', 'IgE-Antikörper gegen Rinderinsulin', 'Sığır insülinine karşı IgE antikorları'),
('IgE Antibodies to Porcine Insulin', 'ige-antibodies-to-porcine-insulin', 'IgE antitijela na svinjski insulin', 'IgE антитијела на свињски инсулин', 'IgE-антитела к свиному инсулину', 'IgE-Antikörper gegen Schweineinsulin', 'Domuz insülinine karşı IgE antikorları'),
('IGF-2', 'igf-2', 'Insulinu-sličan faktor rasta 2', 'Инсулину-сличан фактор раста 2', 'Инсулиноподобный фактор роста 2 (IGF-2)', 'Insulinähnlicher Wachstumsfaktor 2', 'İnsülin benzeri büyüme faktörü 2'),
('Imatinib Level', 'imatinib-level', 'Nivo imatiniba', 'Ниво иматиниба', 'Уровень иматиниба', 'Imatinib-Spiegel', 'İmatinib düzeyi'),
('Immunoelectrophoresis Protein CSF', 'immunoelectrophoresis-protein-csf', 'Imunoelektroforeza proteina likvora', 'Имуноелектрофореза протеина ликвора', 'Иммуноэлектрофорез белков ликвора', 'Immunelektrophorese der Liquorproteine', 'BOS protein immünoelektroforezi'),
('Indomethacin IgE', 'indomethacin-ige', 'Indometacin IgE', 'Индометацин IgE', 'Индометацин IgE', 'IgE gegen Indometacin', 'İndometazin IgE'),
('Influenza A Virus IgA', 'influenza-a-virus-iga', 'Influenca A virus IgA', 'Инфлуенца A вирус IgA', 'Антитела IgA к вирусу гриппа A', 'Influenza-A-Virus IgA-Antikörper', 'İnfluenza A virüsü IgA antikoru'),
('Inhalant Allergen Screen sx1', 'inhalant-allergen-screen-sx1', 'Skrining inhalacionih alergena sx1', 'Скрининг инхалационих алергена sx1', 'Скрининг ингаляционных аллергенов sx1', 'Screening auf Inhalationsallergene sx1', 'İnhalan alerjen taraması sx1'),
('Intact Proinsulin', 'intact-proinsulin', 'Intaktni proinsulin', 'Интактни проинсулин', 'Интактный проинсулин', 'Intaktes Proinsulin', 'İntakt proinsülin'),
('Interleukin-1 Alpha', 'interleukin-1-alpha', 'Interleukin-1 alfa', 'Интерлеукин-1 алфа', 'Интерлейкин-1 альфа', 'Interleukin-1 alpha', 'İnterlökin-1 alfa'),
('Interleukin-10', 'interleukin-10', 'Interleukin-10', 'Интерлеукин-10', 'Интерлейкин-10', 'Interleukin-10', 'İnterlökin-10'),
('Interleukin-8', 'interleukin-8', 'Interleukin-8', 'Интерлеукин-8', 'Интерлейкин-8', 'Interleukin-8', 'İnterlökin-8'),
('Iodine in Random Urine', 'iodine-in-random-urine', 'Jod u slučajnom urinu', 'Јод у случајном урину', 'Йод в разовой порции мочи', 'Jod im Spontanurin', 'Spot idrarda iyot'),
('JAG1 Gene Mutations (Exon 4)', 'jag1-gene-mutations-exon-4', 'Mutacije u JAG1 genu — 4. egzon (Alagilleov sindrom)', 'Мутације у JAG1 гену — 4. егзон (Алажилов синдром)', 'Мутации гена JAG1 — экзон 4 (синдром Алажиля)', 'JAG1-Genmutationen – Exon 4 (Alagille-Syndrom)', 'JAG1 geni mutasyonları – ekzon 4 (Alagille sendromu)'),
('JC Virus PCR', 'jc-virus-pcr', 'JC virus PCR', 'JC вирус PCR', 'JC-вирус ПЦР', 'JC-Virus PCR-Nachweis', 'JC virüsü PCR testi'),
('Karyotype from Abortion Material', 'karyotype-from-abortion-material', 'Kariotip ploda iz abortivnog materijala', 'Кариотип плода из абортивног материјала', 'Кариотип абортивного материала', 'Karyotyp aus Abortmaterial', 'Düşük materyalinden karyotip'),
('Karyotype from Amniotic Fluid', 'karyotype-from-amniotic-fluid', 'Kariotip iz plodove vode', 'Кариотип из плодове воде', 'Кариотип по амниотической жидкости', 'Karyotyp aus Fruchtwasser', 'Amniyon sıvısından karyotip'),
('Karyotype from Amniotic Fluid Twins', 'karyotype-from-amniotic-fluid-twins', 'Kariotip iz plodove vode (blizanci)', 'Кариотип из плодове воде (близанци)', 'Кариотип по амниотической жидкости (близнецы)', 'Karyotyp aus Fruchtwasser (Zwillinge)', 'Amniyon sıvısından karyotip (ikizler)'),
('Karyotype from Bone Marrow', 'karyotype-from-bone-marrow', 'Kariotip iz koštane srži', 'Кариотип из коштане сржи', 'Кариотип костного мозга', 'Karyotyp aus Knochenmark', 'Kemik iliğinden karyotip'),
('Karyotype from Chorionic Villi', 'karyotype-from-chorionic-villi', 'Kariotip iz horionskih čupica', 'Кариотип из хорионских чупица', 'Кариотип по ворсинам хориона', 'Karyotyp aus Chorionzotten', 'Koryon villuslarından karyotip'),
('Karyotype from Cordocentesis Blood', 'karyotype-from-cordocentesis-blood', 'Kariotip iz krvi dobijene kordocentezom', 'Кариотип из крви добијене кордоцентезом', 'Кариотип по пуповинной крови (кордоцентез)', 'Karyotyp aus Nabelschnurblut (Kordozentese)', 'Kordosentez kanından karyotip'),
('Keto Acids', 'keto-acids', 'Keto kiseline', 'Кето киселине', 'Кетокислоты', 'Ketosäuren', 'Keto asitler'),
('Ketones in Urine', 'ketones-in-urine', 'Ketoni u urinu', 'Кетони у урину', 'Кетоны в моче', 'Ketonkörper im Urin', 'İdrarda keton'),
('KIM-1 in Urine', 'kim-1-in-urine', 'KIM-1 u urinu', 'KIM-1 у урину', 'KIM-1 в моче', 'KIM-1 im Urin', 'İdrarda KIM-1'),
('KRAS Mutations (Codons 12 and 13)', 'kras-mutations-codons-12-and-13', 'Mutacije u 12. i 13. kodonu KRAS gena', 'Мутације у 12. и 13. кодону KRAS гена', 'Мутации гена KRAS (кодоны 12 и 13)', 'KRAS-Mutationen (Codons 12 und 13)', 'KRAS mutasyonları (12. ve 13. kodon)'),
('Legionella pneumophila PCR', 'legionella-pneumophila-pcr', 'Legionella pneumophila PCR', 'Legionella pneumophila PCR', 'Legionella pneumophila ПЦР', 'Legionella-pneumophila-PCR', 'Legionella pneumophila PCR testi'),
('Listeria monocytogenes IgG', 'listeria-monocytogenes-igg', 'Listeria monocytogenes IgG', 'Listeria monocytogenes IgG', 'Антитела IgG к Listeria monocytogenes', 'Listeria monocytogenes IgG-Antikörper', 'Listeria monocytogenes IgG antikoru'),
('Lochia Swab Culture Anaerobic', 'lochia-swab-culture-anaerobic', 'Bakteriološko ispitivanje brisa lohija - anaerobno', 'Бактериолошко испитивање бриса лохија - анаеробно', 'Анаэробный посев мазка лохий', 'Anaerobe Kultur des Lochialabstrichs', 'Loşi sürüntüsü anaerobik kültürü'),
('Lymphocyte Subpopulations', 'lymphocyte-subpopulations', 'Subpopulacije limfocita', 'Субпопулације лимфоцита', 'Субпопуляции лимфоцитов', 'Lymphozyten-Subpopulationen', 'Lenfosit alt grupları'),
('Malaria Antibodies', 'malaria-antibodies', 'Antitijela na malariju', 'Антитијела на маларију', 'Антитела к малярии', 'Malaria-Antikörper', 'Sıtma antikorları'),
('Maternity Test (Mother and Child)', 'maternity-test-mother-and-child', 'Test materinstva — poređenje genetičkih profila (majka i dijete)', 'Тест материнства — поређење генетичких профила (мајка и дијете)', 'Тест на материнство (мать и ребёнок)', 'Mutterschaftstest (Mutter und Kind)', 'Annelik testi (anne ve çocuk)'),
('MC4R Gene Mutations', 'mc4r-gene-mutations', 'Mutacije u MC4R genu (gojaznost)', 'Мутације у MC4R гену (гојазност)', 'Мутации гена MC4R (ожирение)', 'MC4R-Genmutationen (Adipositas)', 'MC4R geni mutasyonları (obezite)'),
('MC4R Known Familial Mutation Test', 'mc4r-known-familial-mutation-test', 'Mutacije u MC4R genu — član porodice, poznata mutacija (gojaznost)', 'Мутације у MC4R гену — члан породице, позната мутација (гојазност)', 'MC4R: поиск известной семейной мутации (ожирение)', 'MC4R – Nachweis einer bekannten familiären Mutation (Adipositas)', 'MC4R bilinen ailesel mutasyon testi (obezite)'),
('Methylmalonic Acid in Urine', 'methylmalonic-acid-in-urine', 'Metilmalonska kiselina u urinu', 'Метилмалонска киселина у урину', 'Метилмалоновая кислота в моче', 'Methylmalonsäure im Urin', 'İdrarda metilmalonik asit'),
('MODY 3 (HNF1A Gene)', 'mody-3-hnf1a-gene', 'MODY 3 — HNF1A (TCF1) gen', 'MODY 3 — HNF1A (TCF1) ген', 'MODY 3 — ген HNF1A (TCF1)', 'MODY 3 – HNF1A-(TCF1)-Gen', 'MODY 3 – HNF1A (TCF1) geni'),
('Mold Mix mx2', 'mold-mix-mx2', 'Miks plijesni mx2', 'Микс плијесни mx2', 'Смесь плесневых грибов mx2', 'Schimmelpilzmischung mx2', 'Küf karışımı mx2'),
('Molybdenum in Blood', 'molybdenum-in-blood', 'Molibden u krvi', 'Молибден у крви', 'Молибден в крови', 'Molybdän im Blut', 'Kanda molibden'),
('Molybdenum in Serum', 'molybdenum-in-serum', 'Molibden u serumu', 'Молибден у серуму', 'Молибден в сыворотке', 'Molybdän im Serum', 'Serumda molibden'),
('Molybdenum in Urine', 'molybdenum-in-urine', 'Molibden u urinu', 'Молибден у урину', 'Молибден в моче', 'Molybdän im Urin', 'İdrarda molibden'),
('Mycobacterium leprae PCR', 'mycobacterium-leprae-pcr', 'Mycobacterium leprae PCR', 'Mycobacterium leprae PCR', 'Mycobacterium leprae ПЦР', 'Mycobacterium-leprae-PCR', 'Mycobacterium leprae PCR testi'),
('Mycobacterium tuberculosis Culture (Aspirate)', 'mycobacterium-tuberculosis-culture-aspirate', 'Kultura aspirata na Mycobacterium tuberculosis', 'Култура аспирата на Mycobacterium tuberculosis', 'Посев аспирата на Mycobacterium tuberculosis', 'Mycobacterium-tuberculosis-Kultur aus Aspirat', 'Aspirattan Mycobacterium tuberculosis kültürü'),
('Mycobacterium tuberculosis Culture (Sputum)', 'mycobacterium-tuberculosis-culture-sputum', 'Kultura sputuma na Mycobacterium tuberculosis', 'Култура спутума на Mycobacterium tuberculosis', 'Посев мокроты на Mycobacterium tuberculosis', 'Mycobacterium-tuberculosis-Kultur aus Sputum', 'Balgamdan Mycobacterium tuberculosis kültürü'),
('Mycobacterium tuberculosis Culture (Urine)', 'mycobacterium-tuberculosis-culture-urine', 'Kultura urina na Mycobacterium tuberculosis', 'Култура урина на Mycobacterium tuberculosis', 'Посев мочи на Mycobacterium tuberculosis', 'Mycobacterium-tuberculosis-Kultur aus Urin', 'İdrardan Mycobacterium tuberculosis kültürü'),
('Mycobacterium tuberculosis in Pleural Fluid', 'mycobacterium-tuberculosis-in-pleural-fluid', 'Mycobacterium tuberculosis u pleuralnom punktatu', 'Mycobacterium tuberculosis у плеуралном пунктату', 'Mycobacterium tuberculosis в плевральной жидкости', 'Mycobacterium tuberculosis im Pleurapunktat', 'Plevral sıvıda Mycobacterium tuberculosis'),
('Mycophenolic Acid Level', 'mycophenolic-acid-level', 'Nivo mikofenolne kiseline', 'Ниво микофенолне киселине', 'Уровень микофеноловой кислоты', 'Mycophenolsäure-Spiegel', 'Mikofenolik asit düzeyi'),
('Mycoplasma pneumoniae PCR', 'mycoplasma-pneumoniae-pcr', 'Mycoplasma pneumoniae PCR', 'Mycoplasma pneumoniae PCR', 'Mycoplasma pneumoniae ПЦР', 'Mycoplasma-pneumoniae-PCR', 'Mycoplasma pneumoniae PCR testi'),
('Myoglobin in Urine', 'myoglobin-in-urine', 'Mioglobin u urinu', 'Миоглобин у урину', 'Миоглобин в моче', 'Myoglobin im Urin', 'İdrarda miyoglobin'),
('N-Acetyl-Beta-Glucosaminidase NAG', 'n-acetyl-beta-glucosaminidase-nag', 'N-acetil-beta-glukozaminidaza NAG', 'N-ацетил-бета-глукозаминидаза NAG', 'N-ацетил-бета-глюкозаминидаза (NAG)', 'N-Acetyl-β-Glucosaminidase (NAG)', 'N-asetil-beta-glukozaminidaz (NAG)'),
('N-Desmethylclozapine Level', 'n-desmethylclozapine-level', 'Nivo N-dezmetilklozapina', 'Ниво N-дезметилклозапина', 'Уровень N-десметилклозапина', 'N-Desmethylclozapin-Spiegel', 'N-desmetilklozapin düzeyi'),
('Neopterin in Serum', 'neopterin-in-serum', 'Neopterin u serumu', 'Неоптерин у серуму', 'Неоптерин в сыворотке', 'Neopterin im Serum', 'Serumda neopterin'),
('Nickel in Blood', 'nickel-in-blood', 'Nikal u krvi', 'Никал у крви', 'Никель в крови', 'Nickel im Blut', 'Kanda nikel'),
('NRAS Mutations (Codons 12, 13 and 61)', 'nras-mutations-codons-12-13-and-61', 'Mutacije u NRAS genu (kodoni 12, 13 i 61)', 'Мутације у NRAS гену (кодони 12, 13 и 61)', 'Мутации гена NRAS (кодоны 12, 13 и 61)', 'NRAS-Mutationen (Codons 12, 13 und 61)', 'NRAS mutasyonları (kodon 12, 13 ve 61)'),
('Nutrigenetic Lipid Metabolism Panel (9 Mutations)', 'nutrigenetic-lipid-metabolism-panel-9-mutations', 'Nutrigenetika — metabolizam lipida, triglicerida i masnih kiselina (9 mutacija)', 'Нутригенетика — метаболизам липида, триглицерида и масних киселина (9 мутација)', 'Нутригенетика — метаболизм липидов, триглицеридов и жирных кислот (9 мутаций)', 'Nutrigenetik – Lipid-, Triglycerid- und Fettsäurestoffwechsel (9 Mutationen)', 'Nutrigenetik – lipid, trigliserit ve yağ asidi metabolizması (9 mutasyon)'),
('Paliperidone Level', 'paliperidone-level', 'Nivo paliperidona', 'Ниво палиперидона', 'Уровень палиперидона', 'Paliperidon-Spiegel', 'Paliperidon düzeyi'),
('Pancreatic Elastase 1 in Serum', 'pancreatic-elastase-1-in-serum', 'Pankreasna elastaza 1 u serumu', 'Панкреасна еластаза 1 у серуму', 'Панкреатическая эластаза 1 в сыворотке', 'Pankreas-Elastase 1 im Serum', 'Serumda pankreatik elastaz 1'),
('Parvovirus B19 PCR', 'parvovirus-b19-pcr', 'Parvovirus B19 PCR', 'Парвовирус B19 PCR', 'Парвовирус B19 ПЦР', 'Parvovirus B19 PCR-Nachweis', 'Parvovirüs B19 PCR testi'),
('Peritoneal Dialysis Catheter Exit Site Swab Culture', 'peritoneal-dialysis-catheter-exit-site-swab-culture', 'Bakteriološki pregled brisa izlazišta katetera za peritonealnu dijalizu', 'Бактериолошки преглед бриса излазишта катетера за перитонеалну дијализу', 'Бактериологический посев мазка с места выхода катетера для перитонеального диализа', 'Bakteriologische Kultur des Abstrichs der Austrittsstelle des Peritonealdialysekatheters', 'Periton diyalizi kateteri çıkış yeri sürüntüsü bakteriyolojik kültürü'),
('Phenacetin IgE', 'phenacetin-ige', 'Fenacetin IgE', 'Фенацетин IgE', 'Фенацетин IgE', 'IgE gegen Phenacetin', 'Fenasetin IgE'),
('Placental Alkaline Phosphatase', 'placental-alkaline-phosphatase', 'Placentalna alkalna fosfataza', 'Плацентална алкална фосфатаза', 'Плацентарная щелочная фосфатаза', 'Plazentare alkalische Phosphatase', 'Plasental alkalen fosfataz'),
('Plasminogen', 'plasminogen', 'Plazminogen', 'Плазминоген', 'Плазминоген', 'Plasminogen im Plasma', 'Plazminojen'),
('Pneumocystis jirovecii PCR', 'pneumocystis-jirovecii-pcr', 'Pneumocystis jirovecii PCR', 'Pneumocystis jirovecii PCR', 'Pneumocystis jirovecii ПЦР', 'Pneumocystis jirovecii PCR-Nachweis', 'Pneumocystis jirovecii PCR testi'),
('Poliovirus Antibodies', 'poliovirus-antibodies', 'Antitijela na poliovirus', 'Антитијела на полиовирус', 'Антитела к полиовирусу', 'Poliovirus-Antikörper', 'Poliovirüs antikorları'),
('Potassium in Erythrocytes', 'potassium-in-erythrocytes', 'Kalijum u eritrocitima', 'Калијум у еритроцитима', 'Калий в эритроцитах', 'Kalium in Erythrozyten', 'Eritrositlerde potasyum'),
('PROCR Gene Haplotype', 'procr-gene-haplotype', 'Haplotip PROCR gena (endotelni receptor proteina C)', 'Хаплотип PROCR гена (ендотелни рецептор протеина C)', 'Гаплотип гена PROCR (эндотелиальный рецептор протеина C)', 'PROCR-Gen-Haplotyp (endothelialer Protein-C-Rezeptor)', 'PROCR gen haplotipi (endotelyal protein C reseptörü)'),
('Protein Creatinine Ratio', 'protein-creatinine-ratio', 'Odnos proteini/kreatinin u urinu', 'Однос протеини/креатинин у урину', 'Соотношение белок/креатинин в моче', 'Protein-Kreatinin-Quotient im Urin', 'İdrar protein/kreatinin oranı'),
('Protein in Dialysate', 'protein-in-dialysate', 'Proteini u dijalizatu', 'Протеини у дијализату', 'Белок в диализате', 'Protein im Dialysat', 'Diyalizatta protein'),
('Quantitative Aspirate Culture', 'quantitative-aspirate-culture', 'Kvantitativna kultura aspirata', 'Квантитативна култура аспирата', 'Количественный посев аспирата', 'Quantitative Aspiratkultur', 'Kantitatif aspirat kültürü'),
('Risperidone Level', 'risperidone-level', 'Nivo risperidona', 'Ниво рисперидона', 'Уровень рисперидона', 'Risperidon-Spiegel', 'Risperidon düzeyi'),
('Rivaroxaban Level', 'rivaroxaban-level', 'Nivo rivaroksabana', 'Ниво ривароксабана', 'Уровень ривароксабана', 'Rivaroxaban-Spiegel', 'Rivaroksaban düzeyi'),
('RSV Antigen in BAL', 'rsv-antigen-in-bal', 'RSV antigen u bronhoalveolarnom lavatu', 'RSV антиген у бронхоалвеоларном лавату', 'Антиген RSV в бронхоальвеолярном лаваже', 'RSV-Antigen in bronchoalveolärer Lavage', 'Bronkoalveolar lavajda RSV antijeni'),
('Salivary Stone Analysis', 'salivary-stone-analysis', 'Analiza kamena iz pljuvačne žlijezde', 'Анализа камена из пљувачне жлијезде', 'Анализ камня слюнной железы', 'Speichelsteinanalyse', 'Tükürük bezi taşı analizi'),
('Seafood Mix fx2', 'seafood-mix-fx2', 'Miks morskih plodova fx2', 'Микс морских плодова fx2', 'Смесь морепродуктов fx2', 'Meeresfrüchtemischung fx2', 'Deniz ürünleri karışımı fx2'),
('Septin 9 (mSEPT9) Methylation Test', 'septin-9-msept9-methylation-test', 'Metilirani Septin 9 (mSEPT9) — skrining kolorektalnog karcinoma iz krvi', 'Метилирани Септин 9 (mSEPT9) — скрининг колоректалног карцинома из крви', 'Метилированный септин 9 (mSEPT9) — скрининг колоректального рака по крови', 'Methyliertes Septin 9 (mSEPT9) – Darmkrebs-Screening aus Blut', 'Metillenmiş Septin 9 (mSEPT9) – kandan kolorektal kanser taraması'),
('Sertraline Level', 'sertraline-level', 'Nivo sertralina', 'Ниво сертралина', 'Уровень сертралина', 'Sertralin-Spiegel', 'Sertralin düzeyi'),
('Sex Chromosome Aneuploidy PCR (X, Y)', 'sex-chromosome-aneuploidy-pcr-x-y', 'Aneuploidije polnih hromozoma X i Y — PCR', 'Анеуплоидије полних хромозома X и Y — PCR', 'Анеуплоидии половых хромосом X и Y — ПЦР', 'Aneuploidien der Geschlechtschromosomen X und Y – PCR', 'X ve Y cinsiyet kromozomu anöploidileri – PCR'),
('SLC2A1 Gene Mutations (GLUT1 Deficiency)', 'slc2a1-gene-mutations-glut1-deficiency', 'Mutacije u SLC2A1 genu (deficijencija GLUT1)', 'Мутације у SLC2A1 гену (дефицијенција GLUT1)', 'Мутации гена SLC2A1 (дефицит GLUT1)', 'SLC2A1-Genmutationen (GLUT1-Mangel)', 'SLC2A1 geni mutasyonları (GLUT1 eksikliği)'),
('Sodium in Erythrocytes', 'sodium-in-erythrocytes', 'Natrijum u eritrocitima', 'Натријум у еритроцитима', 'Натрий в эритроцитах', 'Natrium in Erythrozyten', 'Eritrositlerde sodyum'),
('Sotalol Level', 'sotalol-level', 'Nivo sotalola', 'Ниво соталола', 'Уровень соталола', 'Sotalol-Spiegel', 'Sotalol düzeyi'),
('Spinocerebellar Ataxia Type 1 (SCA1)', 'spinocerebellar-ataxia-type-1-sca1', 'Spinocerebelarna ataksija tip 1 (SCA1)', 'Спиноцеребеларна атаксија тип 1 (SCA1)', 'Спиноцеребеллярная атаксия 1 типа (SCA1)', 'Spinozerebelläre Ataxie Typ 1 (SCA1)', 'Spinoserebellar ataksi tip 1 (SCA1)'),
('Sports Genetics Panel (HIF1A, ACTN3, ACE)', 'sports-genetics-panel-hif1a-actn3-ace', 'Sportski paket — HIF1A, ACTN3 i ACE geni', 'Спортски пакет — HIF1A, ACTN3 и ACE гени', 'Спортивная генетическая панель (HIF1A, ACTN3, ACE)', 'Sportgenetik-Panel (HIF1A, ACTN3, ACE)', 'Spor genetiği paneli (HIF1A, ACTN3, ACE)'),
('SPR Gene Mutations (Sepiapterin Reductase Deficiency)', 'spr-gene-mutations-sepiapterin-reductase-deficiency', 'Mutacije u SPR genu (deficijencija sepiapterin reduktaze)', 'Мутације у SPR гену (дефицијенција сепиаптерин редуктазе)', 'Мутации гена SPR (дефицит сепиаптеринредуктазы)', 'SPR-Genmutationen (Sepiapterinreduktase-Mangel)', 'SPR geni mutasyonları (sepiapterin redüktaz eksikliği)'),
('Sulfamethoxazole IgE', 'sulfamethoxazole-ige', 'Sulfametoksazol IgE', 'Сулфаметоксазол IgE', 'Сульфаметоксазол IgE', 'IgE gegen Sulfamethoxazol', 'Sülfametoksazol IgE'),
('Superoxide Dismutase', 'superoxide-dismutase', 'Superoksid dismutaza', 'Супероксид дисмутаза', 'Супероксиддисмутаза', 'Superoxiddismutase', 'Süperoksit dismutaz'),
('Synovial Fluid Direct Microscopic Preparation', 'synovial-fluid-direct-microscopic-preparation', 'Direktni mikroskopski preparat sinovijalne tečnosti', 'Директни микроскопски препарат синовијалне течности', 'Прямая микроскопия синовиальной жидкости', 'Direktes mikroskopisches Präparat der Synovialflüssigkeit', 'Sinovyal sıvı direkt mikroskobik preparat'),
('Targeted Mutation Analysis on Request (1 Sequence)', 'targeted-mutation-analysis-on-request-1-sequence', 'Detekcija mutacija po zahtjevu (1 sekvenca)', 'Детекција мутација по захтјеву (1 секвенца)', 'Поиск мутации по запросу (1 последовательность)', 'Mutationsanalyse auf Anfrage (1 Sequenz)', 'İsteğe bağlı mutasyon analizi (1 dizi)'),
('Tetrachloroethylene PER', 'tetrachloroethylene-per', 'Tetrahloretilen PER', 'Тетрахлоретилен PER', 'Тетрахлорэтилен PER', 'Tetrachlorethylen PER', 'Tetrakloroetilen PER'),
('Thymidine Kinase', 'thymidine-kinase', 'Timidin kinaza', 'Тимидин киназа', 'Тимидинкиназа', 'Thymidinkinase', 'Timidin kinaz'),
('TMPRSS6 Gene Mutations (IRIDA)', 'tmprss6-gene-mutations-irida', 'Mutacije u TMPRSS6 genu (IRIDA — sideropenijska anemija rezistentna na željezo)', 'Мутације у TMPRSS6 гену (IRIDA — сидеропенијска анемија резистентна на жељезо)', 'Мутации гена TMPRSS6 (IRIDA — железорефрактерная железодефицитная анемия)', 'TMPRSS6-Genmutationen (IRIDA – eisenrefraktäre Eisenmangelanämie)', 'TMPRSS6 geni mutasyonları (IRIDA – demire dirençli demir eksikliği anemisi)'),
('TP53 Gene Mutations (Exons 5-8)', 'tp53-gene-mutations-exons-5-8', 'Mutacije u TP53 genu (egzoni 5–8)', 'Мутације у TP53 гену (егзони 5–8)', 'Мутации гена TP53 (экзоны 5–8)', 'TP53-Genmutationen (Exons 5–8)', 'TP53 geni mutasyonları (ekzon 5–8)'),
('Treponema pallidum IgG Western Blot', 'treponema-pallidum-igg-western-blot', 'Treponema pallidum IgG antitijela (Western Blot)', 'Treponema pallidum IgG антитијела (Western Blot)', 'Treponema pallidum IgG антитела (вестерн-блот)', 'Treponema-pallidum-IgG-Antikörper (Western Blot)', 'Treponema pallidum IgG antikorları (Western Blot)'),
('Treponema pallidum PCR', 'treponema-pallidum-pcr', 'Treponema pallidum PCR', 'Treponema pallidum PCR', 'Treponema pallidum ПЦР', 'Treponema pallidum PCR-Nachweis', 'Treponema pallidum PCR testi'),
('Trimethoprim IgE', 'trimethoprim-ige', 'Trimetoprim IgE', 'Триметоприм IgE', 'Триметоприм IgE', 'IgE gegen Trimethoprim', 'Trimetoprim IgE'),
('Tropheryma whipplei PCR', 'tropheryma-whipplei-pcr', 'Tropheryma whipplei PCR', 'Tropheryma whipplei PCR', 'Tropheryma whipplei ПЦР', 'Tropheryma whipplei PCR-Nachweis', 'Tropheryma whipplei PCR testi'),
('Trypsin in Serum', 'trypsin-in-serum', 'Tripsin u serumu', 'Трипсин у серуму', 'Трипсин в сыворотке', 'Trypsin im Serum', 'Serumda tripsin'),
('Urethral Swab Culture Anaerobic', 'urethral-swab-culture-anaerobic', 'Bakteriološko ispitivanje uretralnog brisa - anaerobno', 'Бактериолошко испитивање уретралног бриса - анаеробно', 'Анаэробный посев мазка из уретры', 'Anaerobe Kultur des Harnröhrenabstrichs', 'Üretral sürüntü anaerobik kültürü'),
('Urethral Swab Microscopy for Gardnerella', 'urethral-swab-microscopy-for-gardnerella', 'Direktni mikroskopski preparat uretralnog brisa na Gardnerella', 'Директни микроскопски препарат уретралног бриса на Gardnerella', 'Микроскопия мазка из уретры на Gardnerella', 'Mikroskopie des Harnröhrenabstrichs auf Gardnerella', 'Üretral sürüntüde Gardnerella mikroskopisi'),
('Urine Specific Gravity', 'urine-specific-gravity', 'Specifična težina urina', 'Специфична тежина урина', 'Удельный вес мочи', 'Spezifisches Gewicht des Urins', 'İdrar dansitesi'),
('Vaginal Swab Microscopy for Gardnerella vaginalis', 'vaginal-swab-microscopy-for-gardnerella-vaginalis', 'Direktni mikroskopski preparat vaginalnog brisa na Gardnerella vaginalis', 'Директни микроскопски препарат вагиналног бриса на Gardnerella vaginalis', 'Микроскопия вагинального мазка на Gardnerella vaginalis', 'Mikroskopie des Vaginalabstrichs auf Gardnerella vaginalis', 'Vajinal sürüntüde Gardnerella vaginalis mikroskopisi'),
('Varicella Zoster Virus PCR', 'varicella-zoster-virus-pcr', 'Varičela zoster virus PCR', 'Варичела зостер вирус PCR', 'Вирус варицелла-зостер ПЦР', 'Varizella-Zoster-Virus PCR-Nachweis', 'Varisella zoster virüsü PCR testi'),
('VGKC Potassium Channel Antibodies', 'vgkc-potassium-channel-antibodies', 'Antitijela na kalijumove kanale VGKC', 'Антитијела на калијумове канале VGKC', 'Антитела к потенциалзависимым калиевым каналам (VGKC)', 'Antikörper gegen spannungsabhängige Kaliumkanäle (VGKC)', 'Voltaj kapılı potasyum kanalı antikorları (VGKC)'),
('Yersinia IgA Antibodies', 'yersinia-iga-antibodies', 'Yersinia IgA antitijela', 'Yersinia IgA антитијела', 'Антитела к Yersinia IgA', 'Yersinia-IgA-Antikörper', 'Yersinia IgA Antikorları'),
('Yersinia IgM Antibodies', 'yersinia-igm-antibodies', 'Yersinia IgM antitijela', 'Yersinia IgM антитијела', 'Антитела к Yersinia IgM', 'Yersinia-IgM-Antikörper', 'Yersinia IgM Antikorları'),
('Zinc in Semen', 'zinc-in-semen', 'Cink u spermi', 'Цинк у сперми', 'Цинк в сперме', 'Zink im Sperma', 'Semende çinko')
ON DUPLICATE KEY UPDATE name_en = name_en;

INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id)
SELECT lt.id, v.category_id FROM (
      SELECT '11-deoxycorticosterone' AS slug, 5 AS category_id
UNION ALL SELECT '7-dehydrocholesterol', 3
UNION ALL SELECT 'acetylsalicylic-acid-ige', 13
UNION ALL SELECT 'acetylsalicylic-acid-level', 17
UNION ALL SELECT 'acid-fast-bacilli-direct-smear', 10
UNION ALL SELECT 'acid-fast-bacilli-direct-smear', 21
UNION ALL SELECT 'adamts13-gene-analysis', 20
UNION ALL SELECT 'adenovirus-pcr', 10
UNION ALL SELECT 'adenovirus-pcr', 22
UNION ALL SELECT 'amino-acid-profile-in-24h-urine', 8
UNION ALL SELECT 'amino-acid-profile-in-24h-urine', 24
UNION ALL SELECT 'amniotic-fluid-culture', 21
UNION ALL SELECT 'amoxicillin-ige', 13
UNION ALL SELECT 'ampa1-receptor-antibodies', 14
UNION ALL SELECT 'ampa2-receptor-antibodies', 14
UNION ALL SELECT 'amylase-isoenzymes', 3
UNION ALL SELECT 'anaplasma-phagocytophilum-igg', 10
UNION ALL SELECT 'anaplasma-phagocytophilum-igm', 10
UNION ALL SELECT 'anti-bp180-antibodies', 14
UNION ALL SELECT 'anti-bp230-antibodies', 14
UNION ALL SELECT 'anti-desmoglein-1-antibodies', 14
UNION ALL SELECT 'anti-desmoglein-3-antibodies', 14
UNION ALL SELECT 'anti-epidermal-basement-membrane-antibodies', 14
UNION ALL SELECT 'anti-epidermal-intercellular-substance-antibodies', 14
UNION ALL SELECT 'anti-histone-antibodies', 14
UNION ALL SELECT 'anti-mcv-antibodies', 14
UNION ALL SELECT 'anti-mi-2-antibodies', 14
UNION ALL SELECT 'anti-n-type-calcium-channel-antibodies', 14
UNION ALL SELECT 'anti-p-q-type-calcium-channel-antibodies', 14
UNION ALL SELECT 'anti-pla2r-antibodies', 14
UNION ALL SELECT 'anti-rnp-70-antibodies', 14
UNION ALL SELECT 'anti-yo-antibodies', 14
UNION ALL SELECT 'antimony-in-blood', 16
UNION ALL SELECT 'antioxidant-capacity-of-lipid-soluble-substances', 3
UNION ALL SELECT 'apc-gene-mutations-exon-15-codons-1085-1160', 20
UNION ALL SELECT 'apob-gene-mutation-familial-defective-apob-100', 20
UNION ALL SELECT 'apolipoprotein-e-genotyping', 20
UNION ALL SELECT 'ascaris-lumbricoides-igg', 10
UNION ALL SELECT 'aspergillus-total-antibodies', 10
UNION ALL SELECT 'atp7b-full-gene-sequencing', 20
UNION ALL SELECT 'atp7b-known-familial-mutation-test', 20
UNION ALL SELECT 'babesia-igg', 10
UNION ALL SELECT 'babesia-igm', 10
UNION ALL SELECT 'bacterial-identification-by-maldi-tof-ms', 21
UNION ALL SELECT 'bacterial-vaginosis-test', 21
UNION ALL SELECT 'barium-in-serum', 16
UNION ALL SELECT 'becker-muscular-dystrophy-genetic-test', 20
UNION ALL SELECT 'beta-trace-protein', 3
UNION ALL SELECT 'biliary-atresia-genetic-test', 20
UNION ALL SELECT 'biopsy-material-mycobacterial-culture-lowenstein-jensen', 10
UNION ALL SELECT 'biopsy-material-mycobacterial-culture-lowenstein-jensen', 21
UNION ALL SELECT 'borrelia-burgdorferi-igg-in-csf', 10
UNION ALL SELECT 'borrelia-burgdorferi-igm-in-csf', 10
UNION ALL SELECT 'brca1-full-gene-sequencing', 20
UNION ALL SELECT 'brca1-known-familial-mutation-test', 20
UNION ALL SELECT 'brca1-partial-sequencing', 20
UNION ALL SELECT 'brca2-full-gene-sequencing', 20
UNION ALL SELECT 'brca2-known-familial-mutation-test', 20
UNION ALL SELECT 'brca2-partial-sequencing', 20
UNION ALL SELECT 'bromazepam-level', 17
UNION ALL SELECT 'bronchial-aspirate-culture-for-bacteria', 21
UNION ALL SELECT 'bronchial-aspirate-culture-for-fungi', 21
UNION ALL SELECT 'btnl2-gene-mutations-exons-5-and-6', 20
UNION ALL SELECT 'c1-inhibitor-functional', 12
UNION ALL SELECT 'candida-antigen', 10
UNION ALL SELECT 'candida-iga-antibodies', 10
UNION ALL SELECT 'cannabinoids-in-urine-lc-ms', 11
UNION ALL SELECT 'carnitine-in-urine', 8
UNION ALL SELECT 'caspr2-antibodies', 14
UNION ALL SELECT 'cefaclor-ige', 13
UNION ALL SELECT 'cefalotin-ige', 13
UNION ALL SELECT 'chlamydia-psittaci-iga', 10
UNION ALL SELECT 'chlamydia-psittaci-igg', 10
UNION ALL SELECT 'chlamydia-psittaci-igm', 10
UNION ALL SELECT 'cholestasis-gene-panel-15-genes', 20
UNION ALL SELECT 'cholestasis-gene-panel-15-genes', 24
UNION ALL SELECT 'chromium-in-serum', 16
UNION ALL SELECT 'chromium-in-urine', 16
UNION ALL SELECT 'chromosomal-aberration-test', 20
UNION ALL SELECT 'ck-isoenzymes', 3
UNION ALL SELECT 'ck-isoenzymes', 18
UNION ALL SELECT 'cladosporium-herbarum-ige-m2', 13
UNION ALL SELECT 'clonazepam-level', 17
UNION ALL SELECT 'clostridium-difficile-pcr', 9
UNION ALL SELECT 'clostridium-difficile-pcr', 10
UNION ALL SELECT 'clostridium-difficile-pcr', 22
UNION ALL SELECT 'clozapine-level', 17
UNION ALL SELECT 'cobalt-in-blood', 16
UNION ALL SELECT 'cocaine-in-urine-gc-ms', 11
UNION ALL SELECT 'codeine-ige', 13
UNION ALL SELECT 'complexed-psa', 6
UNION ALL SELECT 'copeptin', 5
UNION ALL SELECT 'cotinine-in-serum', 11
UNION ALL SELECT 'coxsackie-virus-igg-in-csf', 10
UNION ALL SELECT 'cryofibrinogen', 12
UNION ALL SELECT 'cryptococcus-neoformans-pcr', 10
UNION ALL SELECT 'cryptococcus-neoformans-pcr', 22
UNION ALL SELECT 'cyclic-amp-in-plasma', 5
UNION ALL SELECT 'cyclic-amp-in-urine', 5
UNION ALL SELECT 'cyclic-amp-in-urine', 8
UNION ALL SELECT 'cyp27a1-gene-analysis', 20
UNION ALL SELECT 'cytomegalovirus-pcr-quantitative', 10
UNION ALL SELECT 'cytomegalovirus-pcr-quantitative', 22
UNION ALL SELECT 'dhea', 5
UNION ALL SELECT 'dna-kinship-test-additional-person', 20
UNION ALL SELECT 'dog-dander-ige-e5', 13
UNION ALL SELECT 'doxycycline-ige', 13
UNION ALL SELECT 'dsp-gene-mutations-exon-24', 20
UNION ALL SELECT 'echinococcus-antigen', 10
UNION ALL SELECT 'egfr-gene-mutations-exons-18-21', 20
UNION ALL SELECT 'enterovirus-antibodies', 10
UNION ALL SELECT 'enterovirus-antibodies', 24
UNION ALL SELECT 'erythrocyte-porphyrins', 3
UNION ALL SELECT 'exocrine-pancreas-antibodies', 14
UNION ALL SELECT 'extended-antibiogram-e-test', 21
UNION ALL SELECT 'f9-gene-mutations-and-deletions-hemophilia-b', 20
UNION ALL SELECT 'facioscapulohumeral-muscular-dystrophy-fshd1-genetic-test', 20
UNION ALL SELECT 'fgf-23', 5
UNION ALL SELECT 'fgfr2-gene-mutations-exon-7', 20
UNION ALL SELECT 'flecainide-level', 17
UNION ALL SELECT 'food-intolerance-panel-95-foods', 13
UNION ALL SELECT 'food-intolerance-panel-95-foods', 24
UNION ALL SELECT 'food-mix-fx5', 13
UNION ALL SELECT 'formic-acid-in-urine', 8
UNION ALL SELECT 'free-carnitine-in-serum', 3
UNION ALL SELECT 'free-hemoglobin-in-plasma', 1
UNION ALL SELECT 'free-protein-s', 2
UNION ALL SELECT 'fructose-in-semen', 8
UNION ALL SELECT 'fructose-in-semen', 19
UNION ALL SELECT 'gaba-b-receptor-antibodies', 14
UNION ALL SELECT 'gallstone-analysis', 3
UNION ALL SELECT 'ganglioside-antibodies-igm', 14
UNION ALL SELECT 'ganglioside-antibodies-igm', 24
UNION ALL SELECT 'ganglioside-igg-antibodies', 14
UNION ALL SELECT 'gba-gene-mutations-exons-2-9-10-and-11', 20
UNION ALL SELECT 'gd1a-antibodies-igg', 14
UNION ALL SELECT 'gd1a-antibodies-igm', 14
UNION ALL SELECT 'gd1b-antibodies-igg', 14
UNION ALL SELECT 'gd1b-antibodies-igm', 14
UNION ALL SELECT 'genetic-dna-profile', 20
UNION ALL SELECT 'genotoxicity-test', 20
UNION ALL SELECT 'gentamicin-ige', 13
UNION ALL SELECT 'gldh-glutamate-dehydrogenase', 3
UNION ALL SELECT 'glucose-challenge-test-o-sullivan', 3
UNION ALL SELECT 'glucose-challenge-test-o-sullivan', 19
UNION ALL SELECT 'glucose-in-csf', 3
UNION ALL SELECT 'gm1-antibodies-total', 14
UNION ALL SELECT 'gm2-antibodies-igg', 14
UNION ALL SELECT 'gm2-antibodies-igm', 14
UNION ALL SELECT 'haloperidol-level', 17
UNION ALL SELECT 'hama-human-anti-mouse-antibodies', 12
UNION ALL SELECT 'helicobacter-pylori-pcr-in-stool', 9
UNION ALL SELECT 'helicobacter-pylori-pcr-in-stool', 10
UNION ALL SELECT 'helicobacter-pylori-pcr-in-stool', 22
UNION ALL SELECT 'helicobacter-pylori-urea-breath-test', 10
UNION ALL SELECT 'hereditary-disease-carrier-screening-400-mutations', 20
UNION ALL SELECT 'hereditary-disease-carrier-screening-400-mutations', 24
UNION ALL SELECT 'hereditary-thrombophilia-panel-9-mutations', 20
UNION ALL SELECT 'hereditary-thrombophilia-panel-9-mutations', 24
UNION ALL SELECT 'herpes-simplex-virus-1-2-and-varicella-zoster-virus-pcr', 10
UNION ALL SELECT 'herpes-simplex-virus-1-2-and-varicella-zoster-virus-pcr', 22
UNION ALL SELECT 'herpes-simplex-virus-1-2-and-varicella-zoster-virus-pcr', 24
UNION ALL SELECT 'hfe-known-familial-mutation-test', 20
UNION ALL SELECT 'hif1a-gene-mutation-sports-genetics', 20
UNION ALL SELECT 'hiv-pcr-rna-qualitative', 10
UNION ALL SELECT 'hiv-pcr-rna-qualitative', 22
UNION ALL SELECT 'hla-drb1-typing', 12
UNION ALL SELECT 'hla-drb1-typing', 20
UNION ALL SELECT 'house-dust-mix-hx2', 13
UNION ALL SELECT 'hyaluronic-acid', 3
UNION ALL SELECT 'ige-antibodies-to-bovine-insulin', 13
UNION ALL SELECT 'ige-antibodies-to-porcine-insulin', 13
UNION ALL SELECT 'igf-2', 5
UNION ALL SELECT 'imatinib-level', 17
UNION ALL SELECT 'immunoelectrophoresis-protein-csf', 23
UNION ALL SELECT 'indomethacin-ige', 13
UNION ALL SELECT 'influenza-a-virus-iga', 10
UNION ALL SELECT 'inhalant-allergen-screen-sx1', 13
UNION ALL SELECT 'intact-proinsulin', 5
UNION ALL SELECT 'interleukin-1-alpha', 7
UNION ALL SELECT 'interleukin-10', 7
UNION ALL SELECT 'interleukin-8', 7
UNION ALL SELECT 'iodine-in-random-urine', 8
UNION ALL SELECT 'iodine-in-random-urine', 16
UNION ALL SELECT 'jag1-gene-mutations-exon-4', 20
UNION ALL SELECT 'jc-virus-pcr', 10
UNION ALL SELECT 'jc-virus-pcr', 22
UNION ALL SELECT 'karyotype-from-abortion-material', 19
UNION ALL SELECT 'karyotype-from-abortion-material', 20
UNION ALL SELECT 'karyotype-from-amniotic-fluid', 19
UNION ALL SELECT 'karyotype-from-amniotic-fluid', 20
UNION ALL SELECT 'karyotype-from-amniotic-fluid-twins', 19
UNION ALL SELECT 'karyotype-from-amniotic-fluid-twins', 20
UNION ALL SELECT 'karyotype-from-bone-marrow', 20
UNION ALL SELECT 'karyotype-from-chorionic-villi', 19
UNION ALL SELECT 'karyotype-from-chorionic-villi', 20
UNION ALL SELECT 'karyotype-from-cordocentesis-blood', 19
UNION ALL SELECT 'karyotype-from-cordocentesis-blood', 20
UNION ALL SELECT 'keto-acids', 3
UNION ALL SELECT 'ketones-in-urine', 8
UNION ALL SELECT 'kim-1-in-urine', 8
UNION ALL SELECT 'kras-mutations-codons-12-and-13', 20
UNION ALL SELECT 'legionella-pneumophila-pcr', 10
UNION ALL SELECT 'legionella-pneumophila-pcr', 22
UNION ALL SELECT 'listeria-monocytogenes-igg', 10
UNION ALL SELECT 'lochia-swab-culture-anaerobic', 21
UNION ALL SELECT 'lymphocyte-subpopulations', 12
UNION ALL SELECT 'lymphocyte-subpopulations', 24
UNION ALL SELECT 'malaria-antibodies', 10
UNION ALL SELECT 'maternity-test-mother-and-child', 20
UNION ALL SELECT 'mc4r-gene-mutations', 20
UNION ALL SELECT 'mc4r-known-familial-mutation-test', 20
UNION ALL SELECT 'methylmalonic-acid-in-urine', 3
UNION ALL SELECT 'methylmalonic-acid-in-urine', 8
UNION ALL SELECT 'mody-3-hnf1a-gene', 20
UNION ALL SELECT 'mold-mix-mx2', 13
UNION ALL SELECT 'molybdenum-in-blood', 16
UNION ALL SELECT 'molybdenum-in-serum', 16
UNION ALL SELECT 'molybdenum-in-urine', 16
UNION ALL SELECT 'mycobacterium-leprae-pcr', 10
UNION ALL SELECT 'mycobacterium-leprae-pcr', 22
UNION ALL SELECT 'mycobacterium-tuberculosis-culture-aspirate', 10
UNION ALL SELECT 'mycobacterium-tuberculosis-culture-aspirate', 21
UNION ALL SELECT 'mycobacterium-tuberculosis-culture-sputum', 10
UNION ALL SELECT 'mycobacterium-tuberculosis-culture-sputum', 21
UNION ALL SELECT 'mycobacterium-tuberculosis-culture-urine', 10
UNION ALL SELECT 'mycobacterium-tuberculosis-culture-urine', 21
UNION ALL SELECT 'mycobacterium-tuberculosis-in-pleural-fluid', 10
UNION ALL SELECT 'mycobacterium-tuberculosis-in-pleural-fluid', 21
UNION ALL SELECT 'mycophenolic-acid-level', 17
UNION ALL SELECT 'mycoplasma-pneumoniae-pcr', 10
UNION ALL SELECT 'mycoplasma-pneumoniae-pcr', 22
UNION ALL SELECT 'myoglobin-in-urine', 8
UNION ALL SELECT 'n-acetyl-beta-glucosaminidase-nag', 3
UNION ALL SELECT 'n-acetyl-beta-glucosaminidase-nag', 8
UNION ALL SELECT 'n-desmethylclozapine-level', 17
UNION ALL SELECT 'neopterin-in-serum', 7
UNION ALL SELECT 'neopterin-in-serum', 12
UNION ALL SELECT 'nickel-in-blood', 16
UNION ALL SELECT 'nras-mutations-codons-12-13-and-61', 20
UNION ALL SELECT 'nutrigenetic-lipid-metabolism-panel-9-mutations', 20
UNION ALL SELECT 'nutrigenetic-lipid-metabolism-panel-9-mutations', 24
UNION ALL SELECT 'paliperidone-level', 17
UNION ALL SELECT 'pancreatic-elastase-1-in-serum', 3
UNION ALL SELECT 'parvovirus-b19-pcr', 10
UNION ALL SELECT 'parvovirus-b19-pcr', 22
UNION ALL SELECT 'peritoneal-dialysis-catheter-exit-site-swab-culture', 21
UNION ALL SELECT 'phenacetin-ige', 13
UNION ALL SELECT 'placental-alkaline-phosphatase', 6
UNION ALL SELECT 'plasminogen', 2
UNION ALL SELECT 'pneumocystis-jirovecii-pcr', 10
UNION ALL SELECT 'pneumocystis-jirovecii-pcr', 22
UNION ALL SELECT 'poliovirus-antibodies', 10
UNION ALL SELECT 'potassium-in-erythrocytes', 4
UNION ALL SELECT 'procr-gene-haplotype', 20
UNION ALL SELECT 'protein-creatinine-ratio', 8
UNION ALL SELECT 'protein-in-dialysate', 3
UNION ALL SELECT 'quantitative-aspirate-culture', 21
UNION ALL SELECT 'risperidone-level', 17
UNION ALL SELECT 'rivaroxaban-level', 2
UNION ALL SELECT 'rivaroxaban-level', 17
UNION ALL SELECT 'rsv-antigen-in-bal', 10
UNION ALL SELECT 'salivary-stone-analysis', 3
UNION ALL SELECT 'seafood-mix-fx2', 13
UNION ALL SELECT 'septin-9-msept9-methylation-test', 6
UNION ALL SELECT 'septin-9-msept9-methylation-test', 20
UNION ALL SELECT 'sertraline-level', 17
UNION ALL SELECT 'sex-chromosome-aneuploidy-pcr-x-y', 20
UNION ALL SELECT 'sex-chromosome-aneuploidy-pcr-x-y', 22
UNION ALL SELECT 'slc2a1-gene-mutations-glut1-deficiency', 20
UNION ALL SELECT 'sodium-in-erythrocytes', 4
UNION ALL SELECT 'sotalol-level', 17
UNION ALL SELECT 'spinocerebellar-ataxia-type-1-sca1', 20
UNION ALL SELECT 'sports-genetics-panel-hif1a-actn3-ace', 20
UNION ALL SELECT 'sports-genetics-panel-hif1a-actn3-ace', 24
UNION ALL SELECT 'spr-gene-mutations-sepiapterin-reductase-deficiency', 20
UNION ALL SELECT 'sulfamethoxazole-ige', 13
UNION ALL SELECT 'superoxide-dismutase', 3
UNION ALL SELECT 'synovial-fluid-direct-microscopic-preparation', 21
UNION ALL SELECT 'targeted-mutation-analysis-on-request-1-sequence', 20
UNION ALL SELECT 'tetrachloroethylene-per', 16
UNION ALL SELECT 'thymidine-kinase', 6
UNION ALL SELECT 'tmprss6-gene-mutations-irida', 20
UNION ALL SELECT 'tp53-gene-mutations-exons-5-8', 20
UNION ALL SELECT 'treponema-pallidum-igg-western-blot', 10
UNION ALL SELECT 'treponema-pallidum-pcr', 10
UNION ALL SELECT 'treponema-pallidum-pcr', 22
UNION ALL SELECT 'trimethoprim-ige', 13
UNION ALL SELECT 'tropheryma-whipplei-pcr', 10
UNION ALL SELECT 'tropheryma-whipplei-pcr', 22
UNION ALL SELECT 'trypsin-in-serum', 3
UNION ALL SELECT 'urethral-swab-culture-anaerobic', 21
UNION ALL SELECT 'urethral-swab-microscopy-for-gardnerella', 21
UNION ALL SELECT 'urine-specific-gravity', 8
UNION ALL SELECT 'vaginal-swab-microscopy-for-gardnerella-vaginalis', 21
UNION ALL SELECT 'varicella-zoster-virus-pcr', 10
UNION ALL SELECT 'varicella-zoster-virus-pcr', 22
UNION ALL SELECT 'vgkc-potassium-channel-antibodies', 14
UNION ALL SELECT 'yersinia-iga-antibodies', 10
UNION ALL SELECT 'yersinia-igm-antibodies', 10
UNION ALL SELECT 'zinc-in-semen', 16
UNION ALL SELECT 'zinc-in-semen', 19
) v JOIN lab_tests lt ON lt.slug = v.slug;

-- ═══ 2. Синонимы (264) ═══
-- UNIQUE (another_name, language) глобальный: занятые другими записями отсеяны при сборке.

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
SELECT lt.id, v.another_name, v.language FROM (
      SELECT '11-deoxycorticosterone' AS slug, 'DOC' AS another_name, 'en' AS language
UNION ALL SELECT '7-dehydrocholesterol', '7-DHC', 'en'
UNION ALL SELECT 'acetylsalicylic-acid-ige', 'Aspirin IgE', 'en'
UNION ALL SELECT 'acetylsalicylic-acid-level', 'Salicylate Level', 'en'
UNION ALL SELECT 'acetylsalicylic-acid-level', 'Aspirin Level', 'en'
UNION ALL SELECT 'acetylsalicylic-acid-level', 'Acetilsalicilna kiselina', 'sr'
UNION ALL SELECT 'acid-fast-bacilli-direct-smear', 'AFB Smear', 'en'
UNION ALL SELECT 'adenovirus-pcr', 'Adenovirus DNA (kvalitativno)', 'sr'
UNION ALL SELECT 'amino-acid-profile-in-24h-urine', 'Aminokiseline u 24h urinu', 'sr'
UNION ALL SELECT 'amino-acid-profile-in-24h-urine', 'Urine Aminogram', 'en'
UNION ALL SELECT 'amniotic-fluid-culture', 'Amnion bakteriološki', 'sr'
UNION ALL SELECT 'ampa1-receptor-antibodies', 'AMPA 1 receptorska autoantitela', 'sr'
UNION ALL SELECT 'ampa2-receptor-antibodies', 'AMPA 2 receptorska autoantitela', 'sr'
UNION ALL SELECT 'anaplasma-phagocytophilum-igg', 'Anaplazmoza IgG', 'sr'
UNION ALL SELECT 'anaplasma-phagocytophilum-igm', 'Anaplazmoza IgM', 'sr'
UNION ALL SELECT 'anti-bp180-antibodies', 'BP180 IgG', 'en'
UNION ALL SELECT 'anti-bp230-antibodies', 'BP230 IgG', 'en'
UNION ALL SELECT 'anti-desmoglein-1-antibodies', 'Dsg1 Antibodies', 'en'
UNION ALL SELECT 'anti-desmoglein-1-antibodies', 'Antitela prema desmogleinu 1', 'sr'
UNION ALL SELECT 'anti-desmoglein-3-antibodies', 'Dsg3 Antibodies', 'en'
UNION ALL SELECT 'anti-desmoglein-3-antibodies', 'Antitela prema desmogleinu 3', 'sr'
UNION ALL SELECT 'anti-epidermal-basement-membrane-antibodies', 'Anti-BMZ Antibodies', 'en'
UNION ALL SELECT 'anti-epidermal-basement-membrane-antibodies', 'Antitela prema epidermalnoj bazalnoj membrani', 'sr'
UNION ALL SELECT 'anti-epidermal-intercellular-substance-antibodies', 'Pemphigus Antibodies', 'en'
UNION ALL SELECT 'anti-epidermal-intercellular-substance-antibodies', 'ICS Antibodies', 'en'
UNION ALL SELECT 'anti-histone-antibodies', 'Antihistonska antitela', 'sr'
UNION ALL SELECT 'anti-mcv-antibodies', 'Mutirani citrulirani vimentin antitela', 'sr'
UNION ALL SELECT 'anti-mcv-antibodies', 'Mutated Citrullinated Vimentin Antibodies', 'en'
UNION ALL SELECT 'anti-n-type-calcium-channel-antibodies', 'Anti-N At na kalcijumove kanale', 'sr'
UNION ALL SELECT 'anti-n-type-calcium-channel-antibodies', 'N-type VGCC Antibodies', 'en'
UNION ALL SELECT 'anti-p-q-type-calcium-channel-antibodies', 'Anti-P/Q At na kalcijumove kanale', 'sr'
UNION ALL SELECT 'anti-p-q-type-calcium-channel-antibodies', 'P/Q-type VGCC Antibodies', 'en'
UNION ALL SELECT 'anti-pla2r-antibodies', 'Phospholipase A2 Receptor Antibodies', 'en'
UNION ALL SELECT 'anti-pla2r-antibodies', 'Antitela prema PLA2 receptorima', 'sr'
UNION ALL SELECT 'anti-rnp-70-antibodies', 'Anti-U1-RNP 70 kDa', 'en'
UNION ALL SELECT 'anti-yo-antibodies', 'PCA-1', 'en'
UNION ALL SELECT 'anti-yo-antibodies', 'Anti-Purkinje Cell Antibodies', 'en'
UNION ALL SELECT 'antioxidant-capacity-of-lipid-soluble-substances', 'Lipid-Soluble Antioxidant Capacity', 'en'
UNION ALL SELECT 'apolipoprotein-e-genotyping', 'Apolipoprotein E genotip', 'sr'
UNION ALL SELECT 'apolipoprotein-e-genotyping', 'APOE Genotype', 'en'
UNION ALL SELECT 'ascaris-lumbricoides-igg', 'Antitijela na Ascaris lumbricoides IgG', 'sr'
UNION ALL SELECT 'ascaris-lumbricoides-igg', 'Roundworm IgG', 'en'
UNION ALL SELECT 'aspergillus-total-antibodies', 'Aspergillus antitijela', 'sr'
UNION ALL SELECT 'babesia-igg', 'Babezioza IgG', 'sr'
UNION ALL SELECT 'babesia-igm', 'Babezioza IgM', 'sr'
UNION ALL SELECT 'bacterial-identification-by-maldi-tof-ms', 'MALDI-TOF MS identifikacija bakterija', 'sr'
UNION ALL SELECT 'bacterial-identification-by-maldi-tof-ms', 'MALDI-TOF', 'en'
UNION ALL SELECT 'bacterial-vaginosis-test', 'Bakterijska vaginoza', 'sr'
UNION ALL SELECT 'bacterial-vaginosis-test', 'BV Test', 'en'
UNION ALL SELECT 'barium-in-serum', 'Ba', 'en'
UNION ALL SELECT 'becker-muscular-dystrophy-genetic-test', 'Beckerova muskularna distrofija', 'sr'
UNION ALL SELECT 'beta-trace-protein', 'Beta-Trace-Protein (sekret)', 'sr'
UNION ALL SELECT 'beta-trace-protein', 'Prostaglandin D Synthase', 'en'
UNION ALL SELECT 'beta-trace-protein', 'BTP', 'en'
UNION ALL SELECT 'biopsy-material-mycobacterial-culture-lowenstein-jensen', 'Biopsijski materijal - Lowenstein', 'sr'
UNION ALL SELECT 'biopsy-material-mycobacterial-culture-lowenstein-jensen', 'TB Culture of Biopsy', 'en'
UNION ALL SELECT 'borrelia-burgdorferi-igg-in-csf', 'Antitijela IgG na Borrelia burgdorferi u likvoru (Lajmska bolest)', 'sr'
UNION ALL SELECT 'borrelia-burgdorferi-igm-in-csf', 'Antitijela IgM na Borrelia burgdorferi u likvoru (Lajmska bolest)', 'sr'
UNION ALL SELECT 'bronchial-aspirate-culture-for-bacteria', 'Bronhoaspirat bakteriološki', 'sr'
UNION ALL SELECT 'bronchial-aspirate-culture-for-fungi', 'Bronhoaspirat mikološki', 'sr'
UNION ALL SELECT 'c1-inhibitor-functional', 'C1-inaktivator funkcionalni', 'sr'
UNION ALL SELECT 'c1-inhibitor-functional', 'C1-INH Function', 'en'
UNION ALL SELECT 'candida-antigen', 'Candida-Antigen test (RAMCO)', 'sr'
UNION ALL SELECT 'candida-iga-antibodies', 'Candida IgA antitela', 'sr'
UNION ALL SELECT 'cannabinoids-in-urine-lc-ms', 'Dokazivanje kanabinoida u urinu metodom LC-MS', 'sr'
UNION ALL SELECT 'caspr2-antibodies', 'CASPR 2 autoantitela', 'sr'
UNION ALL SELECT 'chromosomal-aberration-test', 'Hromozomske aberacije', 'sr'
UNION ALL SELECT 'ck-isoenzymes', 'CK-izoenzimi (MM, MB, BB, makro-CK)', 'sr'
UNION ALL SELECT 'ck-isoenzymes', 'Macro-CK', 'en'
UNION ALL SELECT 'cladosporium-herbarum-ige-m2', 'Cladosporium herbarum m2', 'sr'
UNION ALL SELECT 'clonazepam-level', 'Rivotril Level', 'en'
UNION ALL SELECT 'clostridium-difficile-pcr', 'C. difficile DNA', 'en'
UNION ALL SELECT 'clozapine-level', 'Leponex Level', 'en'
UNION ALL SELECT 'cocaine-in-urine-gc-ms', 'Dokazivanje kokaina u urinu metodom GC-MS', 'sr'
UNION ALL SELECT 'complexed-psa', 'cPSA', 'en'
UNION ALL SELECT 'copeptin', 'CT-proAVP', 'en'
UNION ALL SELECT 'copeptin', 'C-terminal Provasopressin', 'en'
UNION ALL SELECT 'cotinine-in-serum', 'Cotinin serum', 'sr'
UNION ALL SELECT 'coxsackie-virus-igg-in-csf', 'Coxsackie IgG, CSF', 'sr'
UNION ALL SELECT 'cyclic-amp-in-plasma', 'cAMP Plasma', 'en'
UNION ALL SELECT 'cyclic-amp-in-plasma', 'cAMP plazma', 'sr'
UNION ALL SELECT 'cyclic-amp-in-urine', 'cAMP Urine', 'en'
UNION ALL SELECT 'cyclic-amp-in-urine', 'cAMP urin', 'sr'
UNION ALL SELECT 'cyp27a1-gene-analysis', 'Cerebrotendinous Xanthomatosis', 'en'
UNION ALL SELECT 'cytomegalovirus-pcr-quantitative', 'Kvantitativna analiza citomegalovirusa', 'sr'
UNION ALL SELECT 'cytomegalovirus-pcr-quantitative', 'CMV Viral Load', 'en'
UNION ALL SELECT 'dhea', 'Dehydroepiandrosterone', 'en'
UNION ALL SELECT 'dog-dander-ige-e5', 'Perut psa e5', 'sr'
UNION ALL SELECT 'dog-dander-ige-e5', 'Dog Dander', 'en'
UNION ALL SELECT 'echinococcus-antigen', 'Echinococcus Ag', 'en'
UNION ALL SELECT 'enterovirus-antibodies', 'Enteroviruses (Coxackie, ECHO, Polio)', 'sr'
UNION ALL SELECT 'erythrocyte-porphyrins', 'RBC Porphyrins', 'en'
UNION ALL SELECT 'exocrine-pancreas-antibodies', 'Autoantitela prema egzokrinom pankreasu', 'sr'
UNION ALL SELECT 'exocrine-pancreas-antibodies', 'PAB', 'en'
UNION ALL SELECT 'extended-antibiogram-e-test', 'Prošireni AB - E test', 'sr'
UNION ALL SELECT 'extended-antibiogram-e-test', 'E-test MIC', 'en'
UNION ALL SELECT 'facioscapulohumeral-muscular-dystrophy-fshd1-genetic-test', 'FSHMD1A', 'en'
UNION ALL SELECT 'facioscapulohumeral-muscular-dystrophy-fshd1-genetic-test', 'FSHD', 'en'
UNION ALL SELECT 'fgf-23', 'FGF23', 'en'
UNION ALL SELECT 'fgf-23', 'Fibroblast Growth Factor 23', 'en'
UNION ALL SELECT 'flecainide-level', 'Tambocor Level', 'en'
UNION ALL SELECT 'food-intolerance-panel-95-foods', 'Test intolerancije na hranu 95 namirnica', 'sr'
UNION ALL SELECT 'food-mix-fx5', 'Skrining alergena na hranu fx5', 'sr'
UNION ALL SELECT 'free-hemoglobin-in-plasma', 'Plasma Free Hemoglobin', 'en'
UNION ALL SELECT 'free-protein-s', 'Protein S - slobodni', 'sr'
UNION ALL SELECT 'free-protein-s', 'Free Protein S Antigen', 'en'
UNION ALL SELECT 'fructose-in-semen', 'Fruktoza-Sperma', 'sr'
UNION ALL SELECT 'fructose-in-semen', 'Seminal Fructose', 'en'
UNION ALL SELECT 'gaba-b-receptor-antibodies', 'GABA B receptorska autoantitela', 'sr'
UNION ALL SELECT 'ganglioside-antibodies-igm', 'Gangliozidna autoantitela IgM', 'sr'
UNION ALL SELECT 'ganglioside-igg-antibodies', 'Gangliozidna autoantitela IgG', 'sr'
UNION ALL SELECT 'gd1a-antibodies-igg', 'GD1a autoantitela IgG', 'sr'
UNION ALL SELECT 'gd1a-antibodies-igg', 'Anti-GD1a IgG', 'en'
UNION ALL SELECT 'gd1a-antibodies-igm', 'GD1a autoantitela IgM', 'sr'
UNION ALL SELECT 'gd1a-antibodies-igm', 'Anti-GD1a IgM', 'en'
UNION ALL SELECT 'gd1b-antibodies-igg', 'GD1b autoantitela IgG', 'sr'
UNION ALL SELECT 'gd1b-antibodies-igg', 'Anti-GD1b IgG', 'en'
UNION ALL SELECT 'gd1b-antibodies-igm', 'GD1b autoantitela IgM', 'sr'
UNION ALL SELECT 'gd1b-antibodies-igm', 'Anti-GD1b IgM', 'en'
UNION ALL SELECT 'genetic-dna-profile', 'DNA Profiling', 'en'
UNION ALL SELECT 'genotoxicity-test', 'Test na genotoksičnost kultura', 'sr'
UNION ALL SELECT 'gldh-glutamate-dehydrogenase', 'GLDH', 'en'
UNION ALL SELECT 'glucose-challenge-test-o-sullivan', 'O''Sullivan Test', 'en'
UNION ALL SELECT 'glucose-challenge-test-o-sullivan', 'GCT', 'en'
UNION ALL SELECT 'glucose-challenge-test-o-sullivan', '50 g Glucose Challenge Test', 'en'
UNION ALL SELECT 'glucose-in-csf', 'Glukoza (CSF)', 'sr'
UNION ALL SELECT 'glucose-in-csf', 'CSF Glucose', 'en'
UNION ALL SELECT 'gm1-antibodies-total', 'GM1 ukupna antitela', 'sr'
UNION ALL SELECT 'gm1-antibodies-total', 'Anti-GM1', 'en'
UNION ALL SELECT 'gm2-antibodies-igg', 'GM2 autoantitela IgG', 'sr'
UNION ALL SELECT 'gm2-antibodies-igg', 'Anti-GM2 IgG', 'en'
UNION ALL SELECT 'gm2-antibodies-igm', 'GM2 autoantitela IgM', 'sr'
UNION ALL SELECT 'gm2-antibodies-igm', 'Anti-GM2 IgM', 'en'
UNION ALL SELECT 'hama-human-anti-mouse-antibodies', 'Humana anti-mišja antitela', 'sr'
UNION ALL SELECT 'hama-human-anti-mouse-antibodies', 'Heterofilna antitela', 'sr'
UNION ALL SELECT 'hama-human-anti-mouse-antibodies', 'Heterophile Antibodies', 'en'
UNION ALL SELECT 'helicobacter-pylori-pcr-in-stool', 'Helicobacter pylori DNA u fecesu', 'sr'
UNION ALL SELECT 'helicobacter-pylori-urea-breath-test', 'Izdisajni test na H. pylori', 'sr'
UNION ALL SELECT 'helicobacter-pylori-urea-breath-test', 'UBT', 'en'
UNION ALL SELECT 'hereditary-disease-carrier-screening-400-mutations', 'STID', 'en'
UNION ALL SELECT 'hereditary-thrombophilia-panel-9-mutations', 'Panel - nasledne trombofilije 9 mutacija', 'sr'
UNION ALL SELECT 'herpes-simplex-virus-1-2-and-varicella-zoster-virus-pcr', 'PCR-HSV HSV 1+2+VZV', 'sr'
UNION ALL SELECT 'herpes-simplex-virus-1-2-and-varicella-zoster-virus-pcr', 'HSV 1/2 VZV PCR', 'en'
UNION ALL SELECT 'hiv-pcr-rna-qualitative', 'Kvalitativna analiza HIV-a', 'sr'
UNION ALL SELECT 'hiv-pcr-rna-qualitative', 'HIV RNA Qualitative', 'en'
UNION ALL SELECT 'house-dust-mix-hx2', 'Mješavina kućne prašine hx2', 'sr'
UNION ALL SELECT 'hyaluronic-acid', 'Hialuronska kiselina', 'sr'
UNION ALL SELECT 'ige-antibodies-to-bovine-insulin', 'Goveđi insulin IgE', 'sr'
UNION ALL SELECT 'ige-antibodies-to-porcine-insulin', 'Svinjski insulin IgE', 'sr'
UNION ALL SELECT 'igf-2', 'IGF-II', 'en'
UNION ALL SELECT 'igf-2', 'Insulin-like Growth Factor 2', 'en'
UNION ALL SELECT 'imatinib-level', 'Glivec Level', 'en'
UNION ALL SELECT 'immunoelectrophoresis-protein-csf', 'Imunoelektroforeza u likvoru', 'sr'
UNION ALL SELECT 'influenza-a-virus-iga', 'Influenza A IgA', 'en'
UNION ALL SELECT 'intact-proinsulin', 'Proinsulin, intaktni', 'sr'
UNION ALL SELECT 'intact-proinsulin', 'Proinsulin', 'en'
UNION ALL SELECT 'interleukin-1-alpha', 'IL-1α', 'en'
UNION ALL SELECT 'interleukin-1-alpha', 'IL-1 alpha', 'en'
UNION ALL SELECT 'interleukin-10', 'IL-10', 'en'
UNION ALL SELECT 'interleukin-8', 'IL-8', 'en'
UNION ALL SELECT 'interleukin-8', 'CXCL8', 'en'
UNION ALL SELECT 'iodine-in-random-urine', 'Jod spontani urin', 'sr'
UNION ALL SELECT 'jc-virus-pcr', 'Polioma JC virus DNA', 'sr'
UNION ALL SELECT 'jc-virus-pcr', 'JCV PCR', 'en'
UNION ALL SELECT 'karyotype-from-abortion-material', 'Kariotip fetusa iz abortnog materijala', 'sr'
UNION ALL SELECT 'karyotype-from-amniotic-fluid', 'Kariotip iz amnionske tečnosti', 'sr'
UNION ALL SELECT 'karyotype-from-amniotic-fluid-twins', 'Kariotip iz amnionske tečnosti blizanci', 'sr'
UNION ALL SELECT 'karyotype-from-bone-marrow', 'Kariotip iz kostne srži kultura', 'sr'
UNION ALL SELECT 'karyotype-from-chorionic-villi', 'Kariotip iz horionskih resica', 'sr'
UNION ALL SELECT 'karyotype-from-cordocentesis-blood', 'Kariotip iz krvi uzete kordocentezom', 'sr'
UNION ALL SELECT 'ketones-in-urine', 'Ketoni u urinu semikvantitativno', 'sr'
UNION ALL SELECT 'kim-1-in-urine', 'TIM-1/KIM-1/HAVCR u urinu', 'sr'
UNION ALL SELECT 'kim-1-in-urine', 'Kidney Injury Molecule-1', 'en'
UNION ALL SELECT 'kim-1-in-urine', 'HAVCR1', 'en'
UNION ALL SELECT 'kras-mutations-codons-12-and-13', 'K-RAS', 'en'
UNION ALL SELECT 'listeria-monocytogenes-igg', 'Listerija IgG', 'sr'
UNION ALL SELECT 'lochia-swab-culture-anaerobic', 'Bris lohija anaerobno', 'sr'
UNION ALL SELECT 'lymphocyte-subpopulations', 'Subpopulacija limfocita', 'sr'
UNION ALL SELECT 'lymphocyte-subpopulations', 'Lymphocyte Immunophenotyping', 'en'
UNION ALL SELECT 'malaria-antibodies', 'Malaria antitela', 'sr'
UNION ALL SELECT 'malaria-antibodies', 'Plasmodium Antibodies', 'en'
UNION ALL SELECT 'mold-mix-mx2', 'Skrining alergena na gljivice mx2', 'sr'
UNION ALL SELECT 'mycobacterium-tuberculosis-culture-aspirate', 'Aspirat TBC', 'sr'
UNION ALL SELECT 'mycobacterium-tuberculosis-culture-sputum', 'Sputum TBC', 'sr'
UNION ALL SELECT 'mycobacterium-tuberculosis-culture-urine', 'Urin TBC', 'sr'
UNION ALL SELECT 'mycobacterium-tuberculosis-in-pleural-fluid', 'Pleuralni punktat TBC', 'sr'
UNION ALL SELECT 'mycophenolic-acid-level', 'MPA Level', 'en'
UNION ALL SELECT 'mycophenolic-acid-level', 'Mycophenolate Mofetil (MMF)', 'en'
UNION ALL SELECT 'mycophenolic-acid-level', 'Mikofenolat-mofetil (MMF)', 'sr'
UNION ALL SELECT 'n-acetyl-beta-glucosaminidase-nag', 'Beta-NAG', 'en'
UNION ALL SELECT 'n-desmethylclozapine-level', 'Norclozapine Level', 'en'
UNION ALL SELECT 'n-desmethylclozapine-level', 'Desmethyl Clozapin', 'sr'
UNION ALL SELECT 'nras-mutations-codons-12-13-and-61', 'N-RAS', 'en'
UNION ALL SELECT 'paliperidone-level', 'Xeplion Level', 'en'
UNION ALL SELECT 'pancreatic-elastase-1-in-serum', 'Serum Elastase 1', 'en'
UNION ALL SELECT 'parvovirus-b19-pcr', 'Parvovirus B19 DNA', 'sr'
UNION ALL SELECT 'peritoneal-dialysis-catheter-exit-site-swab-culture', 'Bakteriološki pregled izlazišta PD katetera', 'sr'
UNION ALL SELECT 'peritoneal-dialysis-catheter-exit-site-swab-culture', 'PD Catheter Exit Site Culture', 'en'
UNION ALL SELECT 'placental-alkaline-phosphatase', 'PLAP', 'en'
UNION ALL SELECT 'placental-alkaline-phosphatase', 'hPLAP', 'en'
UNION ALL SELECT 'pneumocystis-jirovecii-pcr', 'Pneumocystis carinii DNA', 'sr'
UNION ALL SELECT 'pneumocystis-jirovecii-pcr', 'Pneumocystis carinii PCR', 'en'
UNION ALL SELECT 'poliovirus-antibodies', 'Poliovirusi', 'sr'
UNION ALL SELECT 'procr-gene-haplotype', 'EPCR Haplotype', 'en'
UNION ALL SELECT 'protein-creatinine-ratio', 'Protein/Kreatinin odnos', 'sr'
UNION ALL SELECT 'protein-creatinine-ratio', 'UPCR', 'en'
UNION ALL SELECT 'quantitative-aspirate-culture', 'Aspirat kvantitativno', 'sr'
UNION ALL SELECT 'risperidone-level', 'Risperdal Level', 'en'
UNION ALL SELECT 'rivaroxaban-level', 'Xarelto Level', 'en'
UNION ALL SELECT 'rsv-antigen-in-bal', 'RSV antigen (BAL)', 'sr'
UNION ALL SELECT 'salivary-stone-analysis', 'Analiza kamena iz pljuvačne žlezde', 'sr'
UNION ALL SELECT 'seafood-mix-fx2', 'Skrining alergena na morske plodove fx2', 'sr'
UNION ALL SELECT 'septin-9-msept9-methylation-test', 'Kolorektalni kancer - skrining iz krvi (SEPTin9)', 'sr'
UNION ALL SELECT 'septin-9-msept9-methylation-test', 'SEPT9', 'en'
UNION ALL SELECT 'sertraline-level', 'Sertralin', 'sr'
UNION ALL SELECT 'sertraline-level', 'Zoloft Level', 'en'
UNION ALL SELECT 'slc2a1-gene-mutations-glut1-deficiency', 'GLUT1', 'en'
UNION ALL SELECT 'sotalol-level', 'Sotalol', 'sr'
UNION ALL SELECT 'superoxide-dismutase', 'SOD', 'en'
UNION ALL SELECT 'synovial-fluid-direct-microscopic-preparation', 'Direktni preparat - sinovijska tečnost', 'sr'
UNION ALL SELECT 'tetrachloroethylene-per', 'Perchloroethylene', 'en'
UNION ALL SELECT 'tetrachloroethylene-per', 'Tetrahloroetilen', 'sr'
UNION ALL SELECT 'thymidine-kinase', 'TK', 'en'
UNION ALL SELECT 'tmprss6-gene-mutations-irida', 'IRIDA', 'en'
UNION ALL SELECT 'tp53-gene-mutations-exons-5-8', 'P53', 'en'
UNION ALL SELECT 'treponema-pallidum-igg-western-blot', 'Syphilis IgG Immunoblot', 'en'
UNION ALL SELECT 'treponema-pallidum-pcr', 'Treponema pallidum DNA', 'sr'
UNION ALL SELECT 'tropheryma-whipplei-pcr', 'Tropheryma Whipplei DNK', 'sr'
UNION ALL SELECT 'urethral-swab-culture-anaerobic', 'Uretralni bris anaerobno', 'sr'
UNION ALL SELECT 'urethral-swab-microscopy-for-gardnerella', 'UB (dir. prep.) na Gardnerella spp.', 'sr'
UNION ALL SELECT 'vaginal-swab-microscopy-for-gardnerella-vaginalis', 'VB (dir. prep.) na Gardnerella vaginalis', 'sr'
UNION ALL SELECT 'varicella-zoster-virus-pcr', 'Varicella DNA', 'sr'
UNION ALL SELECT 'varicella-zoster-virus-pcr', 'VZV PCR', 'en'
UNION ALL SELECT 'vgkc-potassium-channel-antibodies', 'Autoantitela prema kalijumovim kanalima', 'sr'
UNION ALL SELECT 'vgkc-potassium-channel-antibodies', 'VGKC Antibodies', 'en'
UNION ALL SELECT 'yersinia-iga-antibodies', 'Jersinija IgA', 'sr'
UNION ALL SELECT 'yersinia-igm-antibodies', 'Jersinija IgM', 'sr'
UNION ALL SELECT 'zinc-in-semen', 'Zink-Sperma', 'sr'
UNION ALL SELECT 'zinc-in-semen', 'Seminal Zinc', 'en'
UNION ALL SELECT 'nasal-eosinophils', 'Eozinofili u razmazu iz nosa', 'sr'
UNION ALL SELECT 'direct-coombs-test', 'Coombs-ov test - direktan', 'sr'
UNION ALL SELECT 'indirect-coombs-test', 'Coombs-ov test - indirektan', 'sr'
UNION ALL SELECT 'dsdna-antibodies', 'Anti ds-DNA skrining', 'sr'
UNION ALL SELECT 'mog-myelin-oligodendrocyte-glycoprotein', 'Anti-MOG antitijela', 'sr'
UNION ALL SELECT 'anti-sla-lp-antibodies', 'Antitijela na solubilni antigen jetre', 'sr'
UNION ALL SELECT 'anti-insulin-antibodies', 'IAA', 'en'
UNION ALL SELECT 'c3-complement', 'C3c', 'en'
UNION ALL SELECT 'c1-inhibitor', 'C1-esteraza inhibitor', 'sr'
UNION ALL SELECT 'prealbumin', 'Transtiretin', 'sr'
UNION ALL SELECT 'prealbumin', 'Transthyretin', 'en'
UNION ALL SELECT 'creatinine', 'Kreatinin u serumu', 'sr'
UNION ALL SELECT 'prostatic-acid-phosphatase', 'Prostatična fosfataza', 'sr'
UNION ALL SELECT 'urea', 'Urea u serumu', 'sr'
UNION ALL SELECT 'glucose-from-capillary-blood', 'Glukoza iz prsta', 'sr'
UNION ALL SELECT 'myoglobin', 'Mioglobin u serumu', 'sr'
UNION ALL SELECT 'hippuric-acid', 'Hipurna kiselina u urinu', 'sr'
UNION ALL SELECT 'heparin-anti-xa-activity', 'Anti Xa (LMWH)', 'sr'
UNION ALL SELECT 'valproic-acid', 'Eftil', 'sr'
UNION ALL SELECT 'carbamazepine-level', 'Karbamazepin (Tegretol)', 'sr'
UNION ALL SELECT 'phenobarbital-level', 'Fenobarbiton', 'sr'
UNION ALL SELECT 'adalimumab-level', 'Koncentracija adalimumaba', 'sr'
UNION ALL SELECT 'infliximab-level', 'Koncentracija infliksimaba', 'sr'
UNION ALL SELECT 'tacrolimus-level', 'Takrolimus (Prograf)', 'sr'
UNION ALL SELECT 'coproporphyrins', 'Koproporfirini u urinu', 'sr'
) v JOIN lab_tests lt ON lt.slug = v.slug;

-- ═══ 3. Цены клиники (882) ═══
-- price_max — где один анализ стоит в прайсе дважды с разной ценой (диапазон).

INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code)
SELECT @clinic_id, lt.id, v.price, v.price_max, NULL FROM (
      SELECT 'beta-lactoglobulin-ige-f77' AS slug, 16.00 AS price, NULL AS price_max -- B001 «(f77) IgE-RAST Beta-Lactoglobulin (Mleko)»
UNION ALL SELECT 'house-dust-mite-ige-h2', 16.00, NULL -- B003 «d1 (Dermatophagoides pteronyssinus-Kućne grinje)»
UNION ALL SELECT 'diamine-oxidase-dao-histamine', 13.00, NULL -- B004 «Diaminooksidaza (DAO)»
UNION ALL SELECT 'cat-epithelium-and-hair-ige-e1', 16.00, NULL -- B005 «e1 (Perut mačke)»
UNION ALL SELECT 'dog-dander-ige-e5', 16.00, NULL -- B006 «e5 (Perut psa)» / B012 «IgE (e5) -Perut psa»
UNION ALL SELECT 'ecp-eosinophil-cationic-protein', 31.00, NULL -- B007 «ECP (Eosinofilni Katjonski Protein)»
UNION ALL SELECT 'alpha-lactalbumin-ige-f76', 16.00, NULL -- B008 «f76 (IgE-RAST Alfa-Lactalbumin (Mleko))»
UNION ALL SELECT 'rye-pollen-ige-g14', 16.00, NULL -- B009 «g12 (Kultivisana raž)»
UNION ALL SELECT 'timothy-ige-g2', 16.00, NULL -- B010 «g6 (Popino prase)»
UNION ALL SELECT 'ige', 10.00, NULL -- B011 «IgE»
UNION ALL SELECT 'house-dust-mix-hx2', 15.00, NULL -- B014 «IgE-At na mešavinu kućne prašine (hx2)»
UNION ALL SELECT 'acetylsalicylic-acid-ige', 15.00, NULL -- B015 «IgE-RAST Acetilsalicilna kiselina»
UNION ALL SELECT 'amoxicillin-ige', 15.00, NULL -- B016 «IgE-RAST Amoksicilin»
UNION ALL SELECT 'codeine-ige', 15.00, NULL -- B017 «IgE-RAST Codein»
UNION ALL SELECT 'diclofenac-ige-c281', 15.00, NULL -- B018 «IgE-RAST Diclofenac»
UNION ALL SELECT 'doxycycline-ige', 15.00, NULL -- B019 «IgE-RAST Doxycyclin»
UNION ALL SELECT 'gentamicin-ige', 15.00, NULL -- B020 «IgE-RAST Gentamycin»
UNION ALL SELECT 'ige-antibodies-to-bovine-insulin', 15.00, NULL -- B021 «IgE-RAST Goveđi insulin»
UNION ALL SELECT 'ige-antibodies-to-human-insulin', 15.00, NULL -- B022 «IgE-RAST Humani insulin»
UNION ALL SELECT 'ibuprofen-ige-c286', 15.00, NULL -- B023 «IgE-RAST Ibuprofen»
UNION ALL SELECT 'indomethacin-ige', 15.00, NULL -- B024 «IgE-RAST Indometacin»
UNION ALL SELECT 'paracetamol-acetaminophen-ige-c2', 15.00, NULL -- B025 «IgE-RAST Paracetamol»
UNION ALL SELECT 'penicilloyl-g-ige-c1', 15.00, NULL -- B026 «IgE-RAST Penicilin G»
UNION ALL SELECT 'penicilloyl-v-ige-c2', 15.00, NULL -- B027 «IgE-RAST Penicilin V»
UNION ALL SELECT 'phenacetin-ige', 15.00, NULL -- B028 «IgE-RAST Phenacetin»
UNION ALL SELECT 'wheat-flour-ige-f4', 19.00, NULL -- B029 «IgE-RAST pšenično brašno (f4)»
UNION ALL SELECT 'soy-ige-f14', 19.00, NULL -- B030 «IgE-RAST soja (f14)»
UNION ALL SELECT 'sulfamethoxazole-ige', 15.00, NULL -- B031 «IgE-RAST Sulfamethoxazol»
UNION ALL SELECT 'ige-antibodies-to-porcine-insulin', 15.00, NULL -- B032 «IgE-RAST Svinjski insulin»
UNION ALL SELECT 'trimethoprim-ige', 15.00, NULL -- B033 «IgE-RAST Trimethoprim»
UNION ALL SELECT 'egg-white-ige-e1', 15.00, NULL -- B035 «IgE-RAST-Belance jajeta»
UNION ALL SELECT 'cefaclor-ige', 15.00, NULL -- B036 «IgE-RAST-Cefaclor»
UNION ALL SELECT 'cefalotin-ige', 15.00, NULL -- B037 «IgE-RAST-Cefalotin»
UNION ALL SELECT 'casein-ige-f78', 15.00, NULL -- B038 «IgE-RAST-Kazein»
UNION ALL SELECT 'peanut-ige-f13', 15.00, NULL -- B039 «IgE-RAST-Kikiriki»
UNION ALL SELECT 'milk-ige-f2', 15.00, NULL -- B040 «IgE-RAST-Kravlje mleko (F2)»
UNION ALL SELECT 'squid-ige-f258', 16.00, NULL -- B041 «IgE-RAST-Lignje»
UNION ALL SELECT 'wasp-ige-i3', 15.00, NULL -- B042 «IgE-RAST-Osa (i3)»
UNION ALL SELECT 'hornet-ige-i75', 15.00, NULL -- B043 «IgE-RAST-Otrov stršljena»
UNION ALL SELECT 'bee-ige-i1', 15.00, NULL -- B044 «IgE-RAST-Pčelinji otrov (i1)»
UNION ALL SELECT 'pistachio-ige-f203', 15.00, NULL -- B045 «IgE-RAST-Pistaći»
UNION ALL SELECT 'cod-ige-f3', 15.00, NULL -- B046 «IgE-RAST-Riba»
UNION ALL SELECT 'tuna-ige-f40', 16.00, NULL -- B047 «IgE-RAST-Tunjevina»
UNION ALL SELECT 'cladosporium-herbarum-ige-m2', 16.00, NULL -- B049 «m2 (Cladosporium herbarum )»
UNION ALL SELECT 'mold-mix-mx4', 49.00, NULL -- B050 «Skrining alergena na Aspergillus(mx4)»
UNION ALL SELECT 'mold-mix-mx2', 49.00, NULL -- B051 «Skrining alergena na gljivice (mx2)»
UNION ALL SELECT 'food-mix-fx5', 50.00, NULL -- B052 «Skrining alergena na hranu (fx5)»
UNION ALL SELECT 'seafood-mix-fx2', 49.00, NULL -- B053 «Skrining alergena na morske plodove (fx2)»
UNION ALL SELECT 'inhalant-allergen-screen-sx1', 50.00, NULL -- B055 «Skrining inhalacionih alergena (SX1)»
UNION ALL SELECT 'birch-ige-t3', 16.00, NULL -- B056 «t3 (Srebrna breza)»
UNION ALL SELECT 'food-intolerance-panel-95-foods', 51.00, NULL -- B057 «Test intolerancije na hranu 95 namirnica»
UNION ALL SELECT 'tryptase', 13.00, NULL -- B058 «Triptaza»
UNION ALL SELECT 'mugwort-ige-w6', 16.00, NULL -- B059 «w6 (Pelin)»
UNION ALL SELECT 'beta-amyloid', 60.00, NULL -- B061 «Beta Amiloid»
UNION ALL SELECT 'ketones-in-urine', 5.00, NULL -- B064 «Ketoni u urinu- Semikvantitativno»
UNION ALL SELECT 'very-long-chain-fatty-acids-c22-c26', 60.00, NULL -- B066 «Masne kiseline, "very long chain" (C22-C26)»
UNION ALL SELECT 'uric-acid', 3.00, NULL -- B067 «Mokraćna kiselina u serumu»
UNION ALL SELECT 'pthrp', 55.00, NULL -- B068 «PTHrP»
UNION ALL SELECT 'tetrachloroethylene-per', 30.00, NULL -- B069 «Tetrahloroetilen ("PER") 4»
UNION ALL SELECT 'chromosomal-aberration-test', 35.00, NULL -- B070 «Hromozomske aberacije»
UNION ALL SELECT 'karyotype-from-abortion-material', 130.00, 250.00 -- B071 «Kariotip fetusa iz abortnog materijala» / B072 «Kariotip fetusa iz abortnog materijala»
UNION ALL SELECT 'karyotype-from-amniotic-fluid', 170.00, 230.00 -- B073 «Kariotip iz amnionske tečnosti» / B074 «Kariotip iz amnionske tečnosti»
UNION ALL SELECT 'karyotype-from-amniotic-fluid-twins', 270.00, NULL -- B075 «Kariotip iz amnionske tečnosti (BLIZANCI)»
UNION ALL SELECT 'karyotype-from-chorionic-villi', 100.00, 190.00 -- B076 «Kariotip iz horionskih resica» / B077 «Kariotip iz horionskih resica»
UNION ALL SELECT 'karyotype-from-bone-marrow', 200.00, NULL -- B078 «Kariotip iz kostne srži -Kultura»
UNION ALL SELECT 'karyotype-from-cordocentesis-blood', 90.00, NULL -- B079 «Kariotip iz krvi uzete kordocentezom»
UNION ALL SELECT 'karyotype-from-peripheral-blood', 120.00, NULL -- B080 «Kariotip iz periferne krvi» / B081 «Kariotip iz periferne krvi (oba roditelja)»
UNION ALL SELECT 'micronucleus-test', 50.00, NULL -- B083 «Mikronukleus test»
UNION ALL SELECT 'genotoxicity-test', 150.00, NULL -- B084 «Test na genotoksičnost -Kultura»
UNION ALL SELECT 'pap-papanicolaou-test', 15.00, NULL -- B096 «Papanikolau»
UNION ALL SELECT 'spermogram', 20.00, NULL -- B097 «Spermogram»
UNION ALL SELECT 'anti-mullerian-hormone', 29.00, NULL -- B098 «Anti Mullerian Hormon (AMH)»
UNION ALL SELECT 'beta-hcg', 14.00, NULL -- B099 «Beta HCG»
UNION ALL SELECT 'dhea', 23.00, NULL -- B100 «DHEA (Dehydroepiandrosteron)»
UNION ALL SELECT 'dhea-s', 9.00, NULL -- B101 «DHEA-S (Dehidroepiandrosteron sulfat)»
UNION ALL SELECT 'dihydrotestosterone', 20.00, NULL -- B102 «Dihidrotestosteron (DHT)»
UNION ALL SELECT 'estradiol', 8.00, NULL -- B103 «Estradiol»
UNION ALL SELECT 'free-beta-hcg', 14.00, NULL -- B104 «FBETA HCG»
UNION ALL SELECT 'free-testosterone', 8.00, NULL -- B105 «Free testosteron»
UNION ALL SELECT 'fsh', 8.00, NULL -- B106 «FSH»
UNION ALL SELECT 'inhibin-a', 35.00, NULL -- B107 «Inhibin A»
UNION ALL SELECT 'inhibin-b', 35.00, NULL -- B108 «Inhibin B»
UNION ALL SELECT 'lh', 8.00, NULL -- B109 «LH»
UNION ALL SELECT 'macroprolactin', 19.00, NULL -- B110 «Profil Makroprolaktina»
UNION ALL SELECT 'progesterone', 8.00, NULL -- B111 «Progesteron» / B112 «Progesteron (pg/ml)»
UNION ALL SELECT 'prolactin', 8.00, NULL -- B113 «Prolaktin»
UNION ALL SELECT 'shbg', 8.00, NULL -- B115 «SHBG»
UNION ALL SELECT 'testosterone', 8.00, NULL -- B116 «Testosteron»
UNION ALL SELECT 'acth', 13.00, NULL -- B117 «ACTH (Adenokortikotropni hormon)»
UNION ALL SELECT 'growth-hormone', 13.00, NULL -- B118 «Hormon rasta»
UNION ALL SELECT 'igf-1', 10.00, NULL -- B119 «IGF1 (Somatomedin C)»
UNION ALL SELECT 'vitamin-125-oh2-d', 49.00, NULL -- B120 «1,25-Dihydroxy-Vitamin D»
UNION ALL SELECT '11-deoxycorticosterone', 39.00, NULL -- B121 «11-Dezoksikortikosteron»
UNION ALL SELECT '3-methoxytyramine-in-urine', 39.00, NULL -- B122 «3-Metoksi Tiramin»
UNION ALL SELECT 'aldosterone-in-24h-urine', 12.00, NULL -- B123 «Aldosteron -18-glucuronid u urinu»
UNION ALL SELECT 'aldosterone', 12.00, NULL -- B124 «Aldosteron u serumu»
UNION ALL SELECT 'androstenedione', 13.00, NULL -- B126 «Androstendion»
UNION ALL SELECT 'catecholamines-in-plasma', 35.00, NULL -- B127 «Kateholamini - Plazma»
UNION ALL SELECT 'catecholamines-in-24h-urine', 35.00, NULL -- B128 «Kateholamini (urin)»
UNION ALL SELECT 'cortisol', 10.00, NULL -- B130 «Kortizol u serumu»
UNION ALL SELECT 'metanephrine-in-urine', 23.00, NULL -- B131 «Metanefrin (urin 24h)»
UNION ALL SELECT 'free-normetanephrine-in-24h-urine', 23.00, NULL -- B132 «Normetanefrin u urinu (24h)»
UNION ALL SELECT 'renin', 15.00, NULL -- B133 «Renin-direktni (Koncentracija)»
UNION ALL SELECT 'free-metanephrine-in-plasma', 39.00, NULL -- B134 «Slobodni metanefrin-Plazma»
UNION ALL SELECT 'normetanephrine-in-plasma', 39.00, NULL -- B135 «Slobodni normetanefrin-Plazma»
UNION ALL SELECT 'vma', 11.00, NULL -- B136 «VMA (Vanil mandelična kiselina)»
UNION ALL SELECT '17-hydroxyprogesterone', 10.00, NULL -- B137 «17-OH progesteron»
UNION ALL SELECT 'adh-antidiuretic-hormone', 30.00, NULL -- B138 «ADH (Antidiuretični hormon, Vazopresin)»
UNION ALL SELECT 'cyclic-amp-in-plasma', 23.00, NULL -- B139 «cAMP (plazma)»
UNION ALL SELECT 'cyclic-amp-in-urine', 30.00, NULL -- B140 «cAMP (urin)»
UNION ALL SELECT 'copeptin', 30.00, NULL -- B141 «Copeptin (CT-proAVP)»
UNION ALL SELECT 'c-peptide', 12.00, NULL -- B142 «C-Peptid»
UNION ALL SELECT 'egf-epidermal-growth-factor', 18.00, NULL -- B143 «EGF (Epidermalni faktor rasta)»
UNION ALL SELECT 'estrone', 30.00, NULL -- B144 «Estron (E1)»
UNION ALL SELECT 'gastrin', 12.00, NULL -- B145 «Gastrin»
UNION ALL SELECT 'glucagon', 18.00, NULL -- B146 «Glukagon»
UNION ALL SELECT 'chromogranin-a', 30.00, NULL -- B147 «Hromogranin A (CgA)»
UNION ALL SELECT 'igf-2', 28.00, NULL -- B148 «IGF-2»
UNION ALL SELECT 'igfbp-3', 10.00, NULL -- B149 «IGFBP-3»
UNION ALL SELECT 'insulin', 12.00, NULL -- B150 «Insulin»
UNION ALL SELECT 'leptin', 10.00, NULL -- B151 «LEPTIN»
UNION ALL SELECT 'nt-probnp', 32.00, NULL -- B152 «NT-proBNP»
UNION ALL SELECT 'intact-proinsulin', 15.00, NULL -- B153 «Proinsulin, intaktni»
UNION ALL SELECT 'pth', 13.00, NULL -- B154 «PTH»
UNION ALL SELECT 'serotonin', 32.00, NULL -- B155 «Serotonin (serum)»
UNION ALL SELECT 'serotonin-in-24h-urine', 32.00, NULL -- B156 «Serotonin u urinu»
UNION ALL SELECT 'vasoactive-intestinal-polypeptide', 50.00, NULL -- B157 «Vazoaktivni intestinalni peptid (VIP)»
UNION ALL SELECT 'free-t3', 10.00, NULL -- B158 «FT3»
UNION ALL SELECT 'free-t4', 10.00, NULL -- B159 «FT4»
UNION ALL SELECT 't3', 5.00, NULL -- B160 «T3»
UNION ALL SELECT 't4', 5.00, NULL -- B161 «T4»
UNION ALL SELECT 'tsh', 5.00, NULL -- B162 «TSH»
UNION ALL SELECT 'calprotectin', 38.00, NULL -- B163 «Calprotectin»
UNION ALL SELECT 'helicobacter-pylori-antigen-in-feces', 12.00, NULL -- B164 «Helicobacter Pylori antigen u fecesu»
UNION ALL SELECT 'lactoferrin', 31.00, NULL -- B165 «Laktoferin u fecesu»
UNION ALL SELECT 'fecal-occult-blood', 7.00, NULL -- B166 «Okultno krvarenje»
UNION ALL SELECT 'pancreatic-elastase-in-stool', 31.00, NULL -- B167 «Pankreasna Elastaza 1 (Feces)»
UNION ALL SELECT 'hemoglobin-electrophoresis', 23.00, NULL -- B168 «Elektroforeza Hemoglobina»
UNION ALL SELECT 'blood-eosinophils', 2.00, NULL -- B169 «Eozinofili u komori»
UNION ALL SELECT 'nasal-eosinophils', 2.00, NULL -- B170 «Eozinofili u razmazu iz nosa»
UNION ALL SELECT 'erythrocytes', 2.00, NULL -- B171 «Eritrociti»
UNION ALL SELECT 'hematocrit', 2.00, NULL -- B172 «Hematokrit»
UNION ALL SELECT 'hemoglobin', 2.00, NULL -- B173 «Hemoglobin»
UNION ALL SELECT 'complete-blood-count', 5.00, NULL -- B174 «Kompletna krvna slika»
UNION ALL SELECT 'leukocytes', 1.00, NULL -- B175 «Leukociti»
UNION ALL SELECT 'leukocyte-formula', 2.00, NULL -- B176 «Leukocitna formula»
UNION ALL SELECT 'methemoglobin', 10.00, NULL -- B177 «Methemoglobin»
UNION ALL SELECT 'reticulocytes', 1.50, NULL -- B178 «Retikulociti»
UNION ALL SELECT 'erythrocyte-sedimentation-rate', 1.00, NULL -- B180 «Sedimentacija eritrocita»
UNION ALL SELECT 'free-hemoglobin-in-plasma', 40.00, NULL -- B182 «Slobodni hemoglobin u plazmi»
UNION ALL SELECT 'platelets', 1.00, NULL -- B183 «Trombociti»
UNION ALL SELECT 'fgf-23', 26.00, NULL -- B184 «FGF23»
UNION ALL SELECT 'free-estriol', 10.00, NULL -- B185 «Free Estriol»
UNION ALL SELECT 'reverse-t3', 40.00, NULL -- B186 «Reverzni T3»
UNION ALL SELECT 'direct-coombs-test', 14.00, NULL -- B187 «Coombs-ov test - direktan»
UNION ALL SELECT 'indirect-coombs-test', 14.00, NULL -- B188 «Coombs-ov test - indirektan»
UNION ALL SELECT 't-lymphocytes-cd4', 33.00, NULL -- B189 «Helper - T limfociti (CD4+)»
UNION ALL SELECT 'cold-agglutinins', 4.00, NULL -- B190 «Hladni aglutinini»
UNION ALL SELECT 'cryofibrinogen', 4.00, NULL -- B191 «Kriofibrinogen»
UNION ALL SELECT 'cryoglobulins', 4.00, NULL -- B192 «Krioglobulini»
UNION ALL SELECT 'blood-group-and-rh-factor', 13.00, NULL -- B193 «Krvna Grupa»
UNION ALL SELECT 'lymphocyte-subpopulations', 38.00, NULL -- B195 «Subpopulacija limfocita»
UNION ALL SELECT 'anca-profile', 68.00, NULL -- B196 «ANCA Profil»
UNION ALL SELECT 'dsdna-antibodies', 13.00, NULL -- B197 «Anti ds-DNA Skrining»
UNION ALL SELECT 'phospholipid-igg-antibodies', 13.00, NULL -- B198 «Anti-Fosfolipid Skrining IgG»
UNION ALL SELECT 'phospholipid-igm-antibodies', 13.00, NULL -- B199 «Anti-Fosfolipid Skrining IgM»
UNION ALL SELECT 'anti-histone-antibodies', 11.00, NULL -- B200 «Antihistonska antitela»
UNION ALL SELECT 'mog-myelin-oligodendrocyte-glycoprotein', 10.00, NULL -- B201 «Anti-MOG Antitela»
UNION ALL SELECT 'anti-n-type-calcium-channel-antibodies', 40.00, NULL -- B202 «Anti-N At na kalcijumove kanale»
UNION ALL SELECT 'nucleosomal-antibodies', 11.00, NULL -- B203 «Anti-Nukleozomalna IgG At»
UNION ALL SELECT 'anti-p-q-type-calcium-channel-antibodies', 40.00, NULL -- B204 «Anti-P/Q At na kalcijumove kanale»
UNION ALL SELECT 'anti-rnp-sm-antibodies', 11.00, NULL -- B205 «Anti-RNP/Sm»
UNION ALL SELECT 'anti-rnp-70-antibodies', 12.00, NULL -- B206 «Anti-RNP-70»
UNION ALL SELECT 'anticardiolipin-igg', 13.00, NULL -- B207 «Antitela prema Cardiolipinu (IgG)»
UNION ALL SELECT 'anticardiolipin-igm', 13.00, NULL -- B208 «Antitela prema Cardiolipinu (IgM)»
UNION ALL SELECT 'gliadin-iga-antibodies', 13.00, NULL -- B209 «Antitela prema Glijadinu (IgA)»
UNION ALL SELECT 'gliadin-igg-antibodies', 13.00, NULL -- B210 «Antitela prema Glijadinu (IgG)»
UNION ALL SELECT 'anti-pla2r-antibodies', 34.00, NULL -- B211 «Antitela prema Pla2-Receptorima (PLA2R)»
UNION ALL SELECT 'anti-sla-lp-antibodies', 30.00, NULL -- B212 «Antitela prema solubilnom antigenu jetre (SLE/LP autoantitela)»
UNION ALL SELECT 'transglutaminase-iga-antibodies', 13.00, NULL -- B213 «Antitela prema tkivnoj transglutaminazi (IgA)»
UNION ALL SELECT 'transglutaminase-igg-antibodies', 13.00, NULL -- B214 «Antitela prema tkivnoj transglutaminazi (IgG)»
UNION ALL SELECT 'beta-2-glycoprotein-i-igg', 13.00, NULL -- B215 «Antitela prema β2-Glikoproteinu I (IgG)»
UNION ALL SELECT 'beta-2-glycoprotein-i-igm', 13.00, NULL -- B216 «Antitela prema β2-Glikoproteinu I (IgM)»
UNION ALL SELECT 'asca-iga', 12.00, NULL -- B217 «ASCA IgA»
UNION ALL SELECT 'asca-igg', 12.00, NULL -- B218 «ASCA IgG»
UNION ALL SELECT 'adrenal-antibodies', 12.00, NULL -- B219 «Auto Antitela na adrenalni korteks»
UNION ALL SELECT 'intrinsic-factor-antibodies', 12.00, NULL -- B220 «Auto antitela prema intrinsic faktoru»
UNION ALL SELECT 'anti-ribosomal-p-antibodies', 18.00, NULL -- B221 «Auto antitela prema ribozomima»
UNION ALL SELECT 'ana-antinuclear-antibodies', 12.00, NULL -- B222 «Auto-antitela (IgG) prema antigenima nukleusa (ANA)»
UNION ALL SELECT 'gbm-antibodies', 12.00, NULL -- B223 «Auto-antitela (IgG) prema bazalnoj glomeluralnoj membrani (GBM)»
UNION ALL SELECT 'centromere-protein-b-antibodies', 12.00, NULL -- B224 «Auto-antitela (IgG) prema centromeri B»
UNION ALL SELECT 'anti-desmoglein-1-antibodies', 15.00, NULL -- B225 «Auto-antitela (IgG) prema desmogleinu 1»
UNION ALL SELECT 'anti-desmoglein-3-antibodies', 15.00, NULL -- B226 «Auto-antitela (IgG) prema desmogleinu 3»
UNION ALL SELECT 'anti-epidermal-basement-membrane-antibodies', 15.00, NULL -- B227 «Auto-antitela (IgG) prema epidermalnoj bazalnoj membrani»
UNION ALL SELECT 'anti-smooth-muscle-antibodies-asma', 20.00, NULL -- B228 «Auto-antitela (IgG) prema glatkoj muskulaturi (ASMA)»
UNION ALL SELECT 'anti-gad-antibodies', 24.00, NULL -- B229 «Auto-antitela (IgG) prema glutamat-dekarboksilazi (GAD)»
UNION ALL SELECT 'anti-hu-antibodies', 15.00, NULL -- B230 «Auto-antitela (IgG) prema Hu»
UNION ALL SELECT 'anti-jo-1-antibodies', 13.00, NULL -- B231 «Auto-antitela (IgG) prema Jo-1»
UNION ALL SELECT 'anca-p-anti-mpo', 13.00, NULL -- B232 «Auto-antitela (IgG) prema mijeloperoksidazi (MPO, p-ANCA)»
UNION ALL SELECT 'anti-parietal-cell-antibodies-apa', 12.00, NULL -- B233 «Auto-antitela (IgG) prema parijetalnim ćelijama»
UNION ALL SELECT 'anca-c-anti-pr3', 12.00, NULL -- B234 «Auto-antitela (IgG) prema Proteinazi 3 (PR3, c-ANCA)»
UNION ALL SELECT 'nmdar-antibodies-in-csf', 15.00, NULL -- B235 «Auto-antitela (IgG) prema receptorima za NMDAR (CSF)»
UNION ALL SELECT 'nmdar-antibodies-in-serum', 15.00, NULL -- B236 «Auto-antitela (IgG) prema receptorima za NMDAR (Serum)»
UNION ALL SELECT 'anti-scl-70-antibodies', 12.00, NULL -- B237 «Auto-antitela (IgG) prema Scl 70»
UNION ALL SELECT 'anti-sm-antibodies', 14.00, NULL -- B238 «Auto-antitela (IgG) prema Sm»
UNION ALL SELECT 'anti-ro-ssa-antibodies', 14.00, NULL -- B239 «Auto-antitela (IgG) prema SS-A (Rӧ)»
UNION ALL SELECT 'anti-la-ssb-antibodies', 14.00, NULL -- B240 «Auto-antitela (IgG) prema SS-B (La)»
UNION ALL SELECT 'anti-thyroglobulin-antibodies', 12.00, NULL -- B241 «Auto-antitela (IgG) prema tireoglobulinu (ATG)»
UNION ALL SELECT 'anti-tpo', 12.00, NULL -- B242 «Auto-antitela (IgG) prema TPO (AMC)»
UNION ALL SELECT 'anti-yo-antibodies', 14.00, NULL -- B243 «Auto-antitela (IgG) prema Yo (purkinijeve ćelije)»
UNION ALL SELECT 'anti-bp180-antibodies', 15.00, NULL -- B244 «Auto-Antitela BP 180 (IgG)»
UNION ALL SELECT 'anti-bp230-antibodies', 15.00, NULL -- B245 «Auto-Antitela BP 230 (IgG)»
UNION ALL SELECT 'ama-antimitochondrial-m2', 16.00, NULL -- B247 «Auto-antitela prema mitohondrijama (AMA-M2)»
UNION ALL SELECT 'aquaporin-4-antibodies', 23.00, NULL -- B248 «Autoantitela prema Aquaporinu 4»
UNION ALL SELECT 'anti-ccp-antibodies', 15.00, NULL -- B249 «Auto-antitela prema CCP/RA (IgG)»
UNION ALL SELECT 'dsdna-igg-antibodies', 13.00, NULL -- B250 «Auto-antitela prema ds-DNA (IgG)»
UNION ALL SELECT 'anti-epidermal-intercellular-substance-antibodies', 15.00, NULL -- B251 «Auto-antitela prema epidermalnoj intercelularnoj supstanci (Pemphigus, ICS - At)»
UNION ALL SELECT 'anti-insulin-antibodies', 13.00, NULL -- B252 «Auto-antitela prema insulinu (IAA)»
UNION ALL SELECT 'anti-mi-2-antibodies', 15.00, NULL -- B253 «Auto-antitela prema Mi-2»
UNION ALL SELECT 'lkm-1-antibodies', 10.00, NULL -- B254 «Auto-antitela prema mikrozomima jetre i bubrega (LKM1)»
UNION ALL SELECT 'ovarian-antibodies', 10.00, NULL -- B255 «Auto-antitela prema ovarijumu (steroidnim ćelijama)»
UNION ALL SELECT 'ica-antibodies', 26.00, NULL -- B256 «Auto-antitela prema pankreasnim ostrvcima (ICA)»
UNION ALL SELECT 'anti-tshr', 18.00, NULL -- B257 «Auto-antitela prema receptorima na TSH» / B293 «(Tiroid stimulišućii imunoglobulini)»
UNION ALL SELECT 'acetylcholine-receptor-antibodies', 39.00, NULL -- B258 «Auto-antitela prema receptorima za acetilholin»
UNION ALL SELECT 'reticulin-antibodies', 15.00, NULL -- B259 «Auto-antitela prema retikulinu»
UNION ALL SELECT 'spermatozoa-antibodies-asa', 10.00, NULL -- B260 «Auto-antitela prema spermatozoidima (ASA)»
UNION ALL SELECT 'ia-2-antibodies', 18.00, NULL -- B261 «Auto-antitela prema tirozinfosfatazi (IA-2)»
UNION ALL SELECT 'ena-screening', 15.00, NULL -- B262 «ENA skrining»
UNION ALL SELECT 'ganglioside-igg-antibodies', 30.00, NULL -- B263 «Gangliozidna autoantitela IgG»
UNION ALL SELECT 'ganglioside-antibodies-igm', 30.00, NULL -- B264 «Gangliozidna autoantitela IgM»
UNION ALL SELECT 'gd1a-antibodies-igg', 30.00, NULL -- B265 «GD1a-autoantitela IgG»
UNION ALL SELECT 'gd1a-antibodies-igm', 30.00, NULL -- B266 «GD1a-autoantitela IgM»
UNION ALL SELECT 'gd1b-antibodies-igg', 30.00, NULL -- B267 «GD1b-autoantitela IgG»
UNION ALL SELECT 'gd1b-antibodies-igm', 30.00, NULL -- B268 «GD1b-autoantitela IgM»
UNION ALL SELECT 'gm1-antibodies-total', 50.00, NULL -- B269 «GM1 Ukupna antitela»
UNION ALL SELECT 'gm2-antibodies-igg', 30.00, NULL -- B270 «GM2-autoantitela IgG»
UNION ALL SELECT 'gm2-antibodies-igm', 30.00, NULL -- B271 «GM2-autoantitela IgM»
UNION ALL SELECT 'gq1b-antibodies-igg', 30.00, NULL -- B272 «GQ1b-autoantitela IgG»
UNION ALL SELECT 'gq1b-antibodies-igm', 30.00, NULL -- B273 «GQ1b-autoantitela IgM»
UNION ALL SELECT 'hama-human-anti-mouse-antibodies', 70.00, NULL -- B274 «HAMA (Humana anti-mišja antitela, heterofilna At)»
UNION ALL SELECT 'immune-complexes-peg', 10.00, NULL -- B275 «Imuni kompleksi - PEG»
UNION ALL SELECT 'musk-antibodies', 15.00, NULL -- B276 «MuSK Auto antitela»
UNION ALL SELECT 'anti-mcv-antibodies', 18.00, NULL -- B277 «Mutirani Citrulirani Vimentin-At»
UNION ALL SELECT 'anti-c1q-antibodies', 10.00, NULL -- B279 «Anti-C 1q»
UNION ALL SELECT 'platelet-iga-igm-igg-antibodies', 20.00, NULL -- B280 «Anti-trombocitna At»
UNION ALL SELECT 'c3-complement', 8.00, NULL -- B281 «C3c»
UNION ALL SELECT 'c4-complement', 8.00, NULL -- B282 «C4»
UNION ALL SELECT 'total-complement-ch50', 9.00, NULL -- B283 «CH-100 (Totalna hemolitička aktivnost komplementa)»
UNION ALL SELECT 'iga', 10.00, NULL -- B284 «IgA»
UNION ALL SELECT 'igg', 10.00, NULL -- B285 «IgG»
UNION ALL SELECT 'igg-subclasses', 22.00, NULL -- B286 «IgG subklase (IgG 1,2,3,4)»
UNION ALL SELECT 'igm', 10.00, NULL -- B287 «IgM»
UNION ALL SELECT 'immunoelectrophoresis-protein-csf', 37.00, NULL -- B288 «Imunoelektroforeza u likvoru»
UNION ALL SELECT 'immunoelectrophoresis-protein-serum', 37.00, NULL -- B289 «Imunoelektroforeza u serumu» / B290 «Imunoelektroforeza u serumu»
UNION ALL SELECT 'immunoelectrophoresis-protein-urine', 28.00, NULL -- B291 «Imunoelektroforeza u urinu»
UNION ALL SELECT 'rheumatoid-factor', 4.00, NULL -- B292 «RF»
UNION ALL SELECT 'ampa1-receptor-antibodies', 33.00, NULL -- B294 «AMPA 1 receptorska auto At»
UNION ALL SELECT 'ampa2-receptor-antibodies', 33.00, NULL -- B295 «AMPA 2 receptorska auto At»
UNION ALL SELECT 'liver-autoantibody-panel-13-antigens', 170.00, NULL -- B296 «Auto antitela prema antigenime jetre»
UNION ALL SELECT 'vgkc-potassium-channel-antibodies', 82.00, NULL -- B297 «Auto antitela prema kalijumovim kanalima»
UNION ALL SELECT 'exocrine-pancreas-antibodies', 20.00, NULL -- B298 «Auto At prema egzokrinom pankreasu»
UNION ALL SELECT 'c1-inhibitor', 17.00, NULL -- B299 «C1-Esterase-Inhibitor (koncentracija)»
UNION ALL SELECT 'c1-inhibitor-functional', 20.00, NULL -- B300 «C1-Inaktivator-Funkcionalni»
UNION ALL SELECT 'caspr2-antibodies', 18.00, NULL -- B301 «CASPR 2 auto At»
UNION ALL SELECT 'gaba-b-receptor-antibodies', 33.00, NULL -- B302 «GABA B receptorska auto At»
UNION ALL SELECT 'hla-c-typing', 230.00, NULL -- B303 «HLA-C»
UNION ALL SELECT 'neopterin-in-serum', 26.00, NULL -- B304 «Neopterin u serumu»
UNION ALL SELECT 'ngal-in-urine', 51.00, NULL -- B305 «NGAL u urinu»
UNION ALL SELECT 'kim-1-in-urine', 40.00, NULL -- B306 «TIM-1/KIM-1/HAVCR u urinu»
UNION ALL SELECT 'interleukin-10', 31.00, NULL -- B307 «IL-10»
UNION ALL SELECT 'interleukin-6', 31.00, NULL -- B308 «IL-6»
UNION ALL SELECT 'interleukin-1-alpha', 48.00, NULL -- B309 «Interleukin 1-alfa»
UNION ALL SELECT 'interleukin-1-beta', 48.00, NULL -- B310 «Interleukin 1-beta»
UNION ALL SELECT 'interleukin-8', 48.00, NULL -- B311 «Interleukin 8»
UNION ALL SELECT 'tnf-alpha-tumor-necrosis-factor', 27.00, NULL -- B312 «TNF-Alfa»
UNION ALL SELECT 'ace', 16.00, NULL -- B313 «ACE (Angiotenzin konverting enzim)»
UNION ALL SELECT 'aldolase', 8.00, NULL -- B314 «Aldolaza (Serum)»
UNION ALL SELECT 'aluminum', 22.00, NULL -- B315 «Aluminijum u serumu»
UNION ALL SELECT 'ammonia-nh3', 11.00, NULL -- B316 «Amonijum (plazma)»
UNION ALL SELECT 'kidney-stone-analysis', 13.00, NULL -- B317 «Analiza kamena iz bubrega» / B319 «Analiza kamena iz urina»
UNION ALL SELECT 'salivary-stone-analysis', 3.00, NULL -- B318 «Analiza kamena iz pljuvačne žlezde»
UNION ALL SELECT 'gallstone-analysis', 13.00, NULL -- B320 «Analiza kamena iz žučne kese»
UNION ALL SELECT 'n-acetyl-beta-glucosaminidase-nag', 15.00, NULL -- B321 «Beta-NAG (N-acetil glukozaminidaza)»
UNION ALL SELECT 'bicarbonates', 3.00, NULL -- B322 «Bikarbonati»
UNION ALL SELECT 'ceruloplasmin', 11.00, NULL -- B323 «Ceruloplazmin»
UNION ALL SELECT 'citrate-in-24h-urine', 16.00, NULL -- B324 «Citrati u urinu 24h»
UNION ALL SELECT 'cotinine-in-serum', 50.00, NULL -- B325 «Cotinin-Serum»
UNION ALL SELECT 'delta-aminolevulinic-acid', 24.00, NULL -- B326 «Delta-Aminolevulinska kiselina»
UNION ALL SELECT 'alcohol-in-blood', 3.00, NULL -- B327 «Etil alkohol»
UNION ALL SELECT 'fructose-in-semen', 12.00, NULL -- B328 «Fruktoza-Sperma»
UNION ALL SELECT 'glucose-6-phosphate-dehydrogenase', 4.00, NULL -- B329 «G-6-PDH U eritrocitima»
UNION ALL SELECT 'hyaluronic-acid', 15.00, NULL -- B330 «Hialuronska kiselina»
UNION ALL SELECT 'histamine-in-blood', 8.00, NULL -- B331 «Histamin u plazmi»
UNION ALL SELECT 'histamine-in-urine', 8.00, NULL -- B332 «Histamin u urinu 24h»
UNION ALL SELECT 'chloride', 3.00, NULL -- B333 «Hloridi u serumu»
UNION ALL SELECT 'chloride-in-24h-urine', 3.00, NULL -- B334 «Hloridi u urinu 24h»
UNION ALL SELECT 'homocysteine', 23.00, NULL -- B335 «Homocistein»
UNION ALL SELECT 'iodine-in-serum', 27.00, NULL -- B337 «Jod u serumu»
UNION ALL SELECT 'iodine-in-24h-urine', 27.00, NULL -- B338 «Jod-24h Urin»
UNION ALL SELECT 'iodine-in-random-urine', 27.00, NULL -- B339 «Jod-Spontani urin»
UNION ALL SELECT 'potassium-in-erythrocytes', 2.00, NULL -- B340 «Kalijum u eritrocitima»
UNION ALL SELECT 'potassium', 4.00, NULL -- B341 «Kalijum u serumu»
UNION ALL SELECT 'potassium-in-24h-urine', 4.00, NULL -- B342 «Kalijum u urinu 24h»
UNION ALL SELECT 'free-carnitine-in-serum', 16.00, NULL -- B343 «Karnitin - Slobodni u serumu»
UNION ALL SELECT 'carnitine-in-urine', 16.00, NULL -- B344 «Karnitin u urinu»
UNION ALL SELECT 'magnesium', 4.00, NULL -- B345 «Magnezijum u serumu»
UNION ALL SELECT 'magnesium-in-urine', 4.00, NULL -- B346 «Magnezijum u urinu»
UNION ALL SELECT 'sodium-in-erythrocytes', 4.00, NULL -- B347 «Natrijum u eritrocitima»
UNION ALL SELECT 'sodium', 4.00, NULL -- B348 «Natrijum u serumu»
UNION ALL SELECT 'sodium-in-24h-urine', 4.00, NULL -- B349 «Natrijum u urinu 24h»
UNION ALL SELECT 'phosphorus', 4.00, NULL -- B350 «Neorganski fosfat u serumu»
UNION ALL SELECT 'phosphorus-in-24h-urine', 4.00, NULL -- B351 «Neorganski fosfat u urinu 24h»
UNION ALL SELECT 'cystatin-c', 18.00, NULL -- B353 «Profil Cistatin C»
UNION ALL SELECT 'trypsin-in-serum', 10.00, NULL -- B354 «Tripsin (serum)»
UNION ALL SELECT 'albumin', 2.00, NULL -- B355 «Albumini u serumu»
UNION ALL SELECT 'microalbumin-in-urine', 5.00, 6.00 -- B356 «Albumini u urinu (Mikroalbuminurija)» / B848 «Mikroalbumini - drugi jutarnji urin»
UNION ALL SELECT 'alpha-1-acid-glycoprotein', 12.00, NULL -- B357 «Alfa-1 kiseli glikoprotein»
UNION ALL SELECT 'alpha-1-antitrypsin', 10.00, NULL -- B358 «Alfa1-antitripsin»
UNION ALL SELECT 'alpha-2-macroglobulin', 10.00, NULL -- B359 «Alfa2-makroglobulin»
UNION ALL SELECT 'protein-electrophoresis-serum', 6.00, NULL -- B360 «Elektroforeza proteina u serumu»
UNION ALL SELECT 'protein-electrophoresis-urine', 6.00, NULL -- B361 «Elektroforeza proteina u urinu»
UNION ALL SELECT 'haptoglobin', 10.00, NULL -- B362 «Haptoglobin»
UNION ALL SELECT 'holotranscobalamin', 18.00, NULL -- B363 «Holo-Transcobalamin (Holo-TC)»
UNION ALL SELECT 'oligoclonal-igg-bands-in-serum', 44.00, NULL -- B364 «Izoelektrofokusiranje na oligoklonalne imunoglobuline»
UNION ALL SELECT 'myoglobin-in-urine', 7.00, NULL -- B365 «Mioglobin u urinu»
UNION ALL SELECT 'protein-creatinine-ratio', 4.00, NULL -- B366 «Protein/Kreatinin odnos»
UNION ALL SELECT 'total-protein', 2.00, NULL -- B367 «Proteini - serum»
UNION ALL SELECT 'protein-in-dialysate', 2.00, NULL -- B368 «Proteini u dijalizatu»
UNION ALL SELECT 'prealbumin', 6.00, NULL -- B369 «Transtiretin (Prealbumin)»
UNION ALL SELECT 'alkaline-phosphatase-isoenzymes', 9.00, NULL -- B370 «Alkalna Fosfataza (Izoenzimi)» / B371 «Alkalna Fosfataza (Izoenzimi)»
UNION ALL SELECT 'alkaline-phosphatase', 2.00, NULL -- B372 «ALP (Alkalna Fosfataza)»
UNION ALL SELECT 'alt', 2.00, NULL -- B373 «ALT (SGPT)»
UNION ALL SELECT 'amylase', 3.00, NULL -- B374 «Amilaza u serumu»
UNION ALL SELECT 'amylase-in-urine', 3.00, NULL -- B375 «Amilaza u urinu»
UNION ALL SELECT 'amylase-isoenzymes', 9.00, NULL -- B376 «Amilaze (serum)-Izoenziimi»
UNION ALL SELECT 'ast', 2.00, NULL -- B377 «AST (SGOT)»
UNION ALL SELECT 'direct-bilirubin', 2.00, NULL -- B378 «Bilirubin - direktni»
UNION ALL SELECT 'total-bilirubin', 2.00, NULL -- B379 «Bilirubin - ukupni»
UNION ALL SELECT 'ck', 3.00, NULL -- B380 «CK (Kreatin Kinaza)»
UNION ALL SELECT 'ck-isoenzymes', 19.00, NULL -- B381 «CK-Izoenzimi (MM,MB,BB, Makro-CK)»
UNION ALL SELECT 'gamma-gt', 2.00, NULL -- B382 «Gama-GT»
UNION ALL SELECT 'gldh-glutamate-dehydrogenase', 4.00, NULL -- B383 «GLDH»
UNION ALL SELECT 'cholesterol', 2.00, NULL -- B384 «Holesterol»
UNION ALL SELECT 'cholinesterase', 2.00, NULL -- B385 «Holinesteraza»
UNION ALL SELECT 'ionized-calcium', 4.00, NULL -- B386 «Jonizovani kalcijum»
UNION ALL SELECT 'calcium', 4.00, NULL -- B387 «Kalcijum u serumu»
UNION ALL SELECT 'calcium-in-24h-urine', 4.00, NULL -- B388 «Kalcijum u urinu 24h»
UNION ALL SELECT 'acid-phosphatase', 2.00, NULL -- B389 «Kisela fosfataza»
UNION ALL SELECT 'creatinine', 2.00, NULL -- B390 «Kreatinin u serumu»
UNION ALL SELECT 'creatinine-in-24h-urine', 2.00, NULL -- B391 «Kreatinin u urinu 24h»
UNION ALL SELECT 'ldh', 2.00, NULL -- B392 «LDH» / B393 «LDH»
UNION ALL SELECT 'ldh-isoenzymes', 18.00, NULL -- B394 «LDH-Izoenzimi»
UNION ALL SELECT 'lipase', 5.00, NULL -- B395 «Lipaza»
UNION ALL SELECT 'pancreatic-elastase-1-in-serum', 23.00, NULL -- B396 «Pankreasna elastaza 1 (Serum)»
UNION ALL SELECT 'prostatic-acid-phosphatase', 2.00, NULL -- B397 «Prostatična fosfataza»
UNION ALL SELECT 'urea', 2.00, NULL -- B398 «Urea u serumu»
UNION ALL SELECT 'urea-in-24h-urine', 2.00, NULL -- B399 «Urea u urinu 24h»
UNION ALL SELECT 'serum-amyloid-a', 13.00, NULL -- B400 «Amiloid A (serum)»
UNION ALL SELECT 'c-reactive-protein', 5.00, NULL -- B401 «C- reaktivni protein (CRP)»
UNION ALL SELECT 'high-sensitivity-c-reactive-protein', 5.00, NULL -- B402 «hs-CRP»
UNION ALL SELECT 'procalcitonin', 30.00, NULL -- B403 «Procalcitonin»
UNION ALL SELECT 'fructosamine', 2.00, NULL -- B404 «Fruktozamin»
UNION ALL SELECT 'glucose', 2.00, NULL -- B405 «Glukoza»
UNION ALL SELECT 'glucose-from-capillary-blood', 1.00, NULL -- B407 «Glukoza iz prsta»
UNION ALL SELECT 'hba1c', 12.00, NULL -- B408 «HbA1C»
UNION ALL SELECT 'glucose-challenge-test-o-sullivan', 1.00, NULL -- B409 «O' Sullivanov test»
UNION ALL SELECT 'erythropoietin', 40.00, NULL -- B410 «Eritropoetin»
UNION ALL SELECT 'ferritin', 10.00, NULL -- B411 «Feritin»
UNION ALL SELECT 'iron', 3.00, NULL -- B412 «Gvožđe»
UNION ALL SELECT 'soluble-transferrin-receptor', 16.00, NULL -- B413 «sTfR»
UNION ALL SELECT 'tibc', 3.00, NULL -- B414 «TIBC»
UNION ALL SELECT 'transferrin', 5.00, NULL -- B415 «Transferin»
UNION ALL SELECT 'uibc', 3.00, NULL -- B416 «UIBC»
UNION ALL SELECT 'beta-crosslaps', 14.00, NULL -- B417 «Beta - CrossLaps»
UNION ALL SELECT 'osteocalcin', 13.00, NULL -- B418 «Osteokalcitonin»
UNION ALL SELECT 'apoa-i', 4.00, NULL -- B419 «Apo - A1 (Apolipoprotein A1)»
UNION ALL SELECT 'apolipoprotein-b', 4.00, NULL -- B420 «Apo - B (Apolipoprotein B)»
UNION ALL SELECT 'hdl-cholesterol', 3.00, NULL -- B421 «HDL holesterol»
UNION ALL SELECT 'ldl-cholesterol', 3.00, NULL -- B422 «LDL holesterol»
UNION ALL SELECT 'lipoprotein-a', 6.00, NULL -- B423 «Lipoprotein (a)»
UNION ALL SELECT 'non-esterified-fatty-acids', 20.00, NULL -- B424 «Masne kiseline, neesterifikovane (NEFA)»
UNION ALL SELECT 'triglycerides', 2.00, NULL -- B425 «Trigliceridi»
UNION ALL SELECT 'copper-in-serum', 5.00, NULL -- B426 «Bakar u serumu»
UNION ALL SELECT 'copper-in-24h-urine', 11.00, NULL -- B427 «Bakar u urinu 24h»
UNION ALL SELECT 'chromium-in-blood', 26.00, NULL -- B428 «Hrom-Krv-nosioci endoproteza»
UNION ALL SELECT 'chromium-in-serum', 26.00, NULL -- B429 «Hrom-Serum»
UNION ALL SELECT 'chromium-in-urine', 26.00, NULL -- B430 «Hrom-Urin»
UNION ALL SELECT 'cobalt-in-blood', 26.00, NULL -- B431 «Kobalt-Krv-nosioci endoproteza»
UNION ALL SELECT 'cobalt-in-serum', 26.00, NULL -- B432 «Kobalt-Serum»
UNION ALL SELECT 'cobalt-in-urine', 26.00, NULL -- B433 «Kobalt-Urin»
UNION ALL SELECT 'molybdenum-in-blood', 26.00, NULL -- B434 «Molibden-Krv-nosioci endoproteza»
UNION ALL SELECT 'molybdenum-in-serum', 26.00, NULL -- B435 «Molibden-Serum»
UNION ALL SELECT 'molybdenum-in-urine', 26.00, NULL -- B436 «Molibden-Urin»
UNION ALL SELECT 'nickel-in-blood', 26.00, NULL -- B437 «Nikl-Krv-nosioci endoproteza»
UNION ALL SELECT 'nickel-in-serum', 26.00, NULL -- B438 «Nikl-Serum»
UNION ALL SELECT 'nickel-in-urine', 26.00, NULL -- B439 «Nikl-Urin»
UNION ALL SELECT 'lead-in-blood', 13.00, NULL -- B440 «Olovo u krvi»
UNION ALL SELECT 'lead-in-24h-urine', 13.00, NULL -- B441 «Olovo-Urin»
UNION ALL SELECT 'selenium', 20.00, NULL -- B442 «Selen u krvi» / B443 «Selen-Serum/Plazma» / B444 «Selen-Serum/Plazma»
UNION ALL SELECT 'zinc-in-serum', 6.00, NULL -- B445 «Zink u serumu»
UNION ALL SELECT 'zinc-in-semen', 6.00, NULL -- B446 «Zink-Sperma»
UNION ALL SELECT 'ck-mb', 8.00, NULL -- B447 «CK - MB»
UNION ALL SELECT 'myoglobin', 7.00, NULL -- B448 «Mioglobin u serumu»
UNION ALL SELECT 'troponin-i', 12.00, NULL -- B449 «Troponin I»
UNION ALL SELECT 'troponin-t-hs', 12.00, NULL -- B450 «Troponin T»
UNION ALL SELECT 'arsenic-in-serum', 22.00, NULL -- B451 «Arsen»
UNION ALL SELECT 'barbiturates', 4.00, NULL -- B452 «Barbiturati u urinu - kvalitativno»
UNION ALL SELECT 'benzodiazepines', 4.00, NULL -- B453 «Bezodiazepini u urinu - kvalitativno»
UNION ALL SELECT 'cannabinoids-in-urine-lc-ms', 32.00, NULL -- B454 «Dokazivanje kanabinoida u urinu metodom LC-MS»
UNION ALL SELECT 'cocaine-in-urine-gc-ms', 32.00, NULL -- B455 «Dokazivanje kokaina u urinu metodom GC-MS»
UNION ALL SELECT 'phencyclidine', 4.00, NULL -- B457 «Fenciklidin u urinu - kvalitativno»
UNION ALL SELECT 'phenol-in-urine', 16.00, NULL -- B458 «Fenol u urinu»
UNION ALL SELECT 'hippuric-acid', 32.00, NULL -- B459 «Hipurna kiselina u urinu»
UNION ALL SELECT 'mercury-in-blood', 23.00, NULL -- B460 «Živa (Hg) u krvi»
UNION ALL SELECT 'mercury-in-urine', 23.00, NULL -- B461 «Živa (Hg) u urinu»
UNION ALL SELECT 'heparin-anti-xa-activity', 20.00, NULL -- B462 «Anti Xa (LMWH)»
UNION ALL SELECT 'antithrombin-iii', 6.00, NULL -- B463 «Antitrombin (aktivnost)»
UNION ALL SELECT 'apcr-resistance-to-activated-protein-c', 20.00, NULL -- B464 «APCR (rezistencija na aktivisani protein C)»
UNION ALL SELECT 'activated-partial-thromboplastin-time', 5.00, NULL -- B465 «aPTT»
UNION ALL SELECT 'd-dimer', 18.00, NULL -- B466 «D-dimer» / B467 «D-dimer»
UNION ALL SELECT 'fibrinogen', 3.00, NULL -- B468 «Fibrinogen» / B469 «Fibrinogen»
UNION ALL SELECT 'prothrombin-time-pt-inr', 4.00, NULL -- B470 «INR» / B489 «Protrombinsko vreme»
UNION ALL SELECT 'coagulation-factor-ii', 23.00, NULL -- B471 «Koagulacioni faktor II»
UNION ALL SELECT 'factor-ix', 23.00, NULL -- B472 «Koagulacioni faktor IX»
UNION ALL SELECT 'coagulation-factor-v', 23.00, NULL -- B473 «Koagulacioni faktor V»
UNION ALL SELECT 'coagulation-factor-vii', 23.00, 28.00 -- B474 «Koagulacioni faktor VII» / B475 «Koagulacioni faktor VII»
UNION ALL SELECT 'coagulation-factor-viii', 24.00, NULL -- B476 «Koagulacioni faktor VIII»
UNION ALL SELECT 'factor-x', 24.00, NULL -- B477 «Koagulacioni faktor X»
UNION ALL SELECT 'factor-xi', 28.00, NULL -- B478 «Koagulacioni faktor XI»
UNION ALL SELECT 'factor-xii-hageman', 28.00, NULL -- B479 «Koagulacioni faktor XII»
UNION ALL SELECT 'coagulation-factor-xiii', 13.00, NULL -- B480 «Koagulacioni faktor XIII»
UNION ALL SELECT 'antithrombin-iii-antigen', 11.00, NULL -- B481 «Koncentracija Antitrombina»
UNION ALL SELECT 'lupus-anticoagulant', 17.00, NULL -- B482 «Lupus antikoagulans»
UNION ALL SELECT 'plasminogen', 24.00, NULL -- B485 «Plazminogen»
UNION ALL SELECT 'protein-c', 23.00, NULL -- B486 «Protein C- Aktivnost»
UNION ALL SELECT 'protein-s', 23.00, NULL -- B487 «Protein S - Aktivnost»
UNION ALL SELECT 'free-protein-s', 23.00, NULL -- B488 «Protein S - Slobodni»
UNION ALL SELECT 'thrombin-time', 4.00, NULL -- B490 «Trombinsko vreme»
UNION ALL SELECT 'von-willebrand-factor-activity', 20.00, NULL -- B492 «Von-Willebrand Faktor (Aktivnost)»
UNION ALL SELECT 'von-willebrand-factor-antigen', 20.00, NULL -- B493 «Von-Willebrand Faktor (Antigen)»
UNION ALL SELECT 'coagulation-time', 1.50, NULL -- B494 «Vreme koagulacije»
UNION ALL SELECT 'bleeding-time', 1.50, NULL -- B495 «Vreme krvarenja»
UNION ALL SELECT 'oxcarbazepine-level', 10.00, NULL -- B497 «10-hydroxyoxcarbazepin»
UNION ALL SELECT 'acetylsalicylic-acid-level', 23.00, NULL -- B499 «Acetilsalicilna kiselina»
UNION ALL SELECT 'bromazepam-level', 50.00, NULL -- B501 «Bromazepam»
UNION ALL SELECT 'clonazepam-level', 50.00, NULL -- B502 «Clonazepam (Rivotril)»
UNION ALL SELECT 'clozapine-level', 22.00, NULL -- B503 «Clozapine (Leponex, Elcrit)»
UNION ALL SELECT 'n-desmethylclozapine-level', 22.00, NULL -- B505 «Desmethyl Clozapin»
UNION ALL SELECT 'digoxin-level', 14.00, NULL -- B506 «Digoxin»
UNION ALL SELECT 'valproic-acid', 11.00, NULL -- B507 «EFTIL (Valproična kiselina)»
UNION ALL SELECT 'flecainide-level', 38.00, NULL -- B508 «Flecainid (Tambocor)»
UNION ALL SELECT 'haloperidol-level', 24.00, NULL -- B509 «Haloperidol»
UNION ALL SELECT 'imatinib-level', 24.00, NULL -- B510 «Imatinib»
UNION ALL SELECT 'levetiracetam-level', 57.00, NULL -- B511 «Levetiracetam (Keppra)»
UNION ALL SELECT 'lithium', 3.00, NULL -- B512 «Litijum»
UNION ALL SELECT 'mycophenolic-acid-level', 25.00, NULL -- B513 «Mycophenolat-Mofetil (MMF)»
UNION ALL SELECT 'paliperidone-level', 26.00, NULL -- B514 «Paliperidon Palmitat (Xeplion)»
UNION ALL SELECT 'risperidone-level', 57.00, NULL -- B515 «Risperidon»
UNION ALL SELECT 'rivaroxaban-level', 10.00, NULL -- B516 «Rivaroxaban (Xarelto)»
UNION ALL SELECT 'sertraline-level', 58.00, NULL -- B517 «Sertralin»
UNION ALL SELECT 'sotalol-level', 44.00, NULL -- B518 «Sotalol»
UNION ALL SELECT 'topiramate-level', 61.00, NULL -- B519 «Topiramat»
UNION ALL SELECT 'carbamazepine-level', 10.00, NULL -- B520 «Carbamazepin (Tegretol)»
UNION ALL SELECT 'lamotrigine-level', 23.00, NULL -- B521 «Lamotrigine (Lamictal)»
UNION ALL SELECT 'phenobarbital-level', 10.00, NULL -- B522 «Phenobarbiton»
UNION ALL SELECT 'adalimumab-antibodies', 76.00, NULL -- B523 «Adalimumab-Antitela»
UNION ALL SELECT 'adalimumab-level', 52.00, NULL -- B524 «Adalimumab-Koncentracija»
UNION ALL SELECT 'everolimus-level', 57.00, NULL -- B526 «Everolimus (Certican ®)»
UNION ALL SELECT 'infliximab-antibodies', 26.00, NULL -- B527 «Infliximab- Antitela»
UNION ALL SELECT 'infliximab-level', 44.00, NULL -- B528 «Infliximab-Koncentracija»
UNION ALL SELECT 'sirolimus-level', 50.00, NULL -- B529 «Rapamycin (Sirolimus)»
UNION ALL SELECT 'tacrolimus-level', 57.00, NULL -- B530 «Tacrolimus (Prograf)- Koncentracija»
UNION ALL SELECT 'beta-trace-protein', 24.00, NULL -- B532 «Beta-"Trace"-Protein (sekret)»
UNION ALL SELECT 'glucose-in-csf', 2.00, NULL -- B533 «Glukoza (CSF)»
UNION ALL SELECT 'antioxidant-capacity-of-lipid-soluble-substances', 14.00, NULL -- B536 «Antioksidativni kapacitet liposolubilnih supstanci»
UNION ALL SELECT 'superoxide-dismutase', 9.00, NULL -- B537 «Superoxide dismuthase»
UNION ALL SELECT '7-dehydrocholesterol', 67.00, NULL -- B538 «7-Dehidroholesterol»
UNION ALL SELECT 'cystine-in-24h-urine', 16.00, NULL -- B539 «Cistin u urinu 24 h»
UNION ALL SELECT 'coproporphyrins', 11.00, NULL -- B540 «Koproporfirini u urinu»
UNION ALL SELECT 'lactate', 11.00, NULL -- B541 «Laktati (plazma)»
UNION ALL SELECT 'oxalate-in-24h-urine', 13.00, NULL -- B543 «Oksalati u urinu 24h»
UNION ALL SELECT 'pyruvate', 13.00, NULL -- B544 «Piruvati u plazmi»
UNION ALL SELECT 'erythrocyte-porphyrins', 36.00, NULL -- B545 «Porfirini u eritrocitima»
UNION ALL SELECT 'amino-acid-profile-in-serum', 37.00, NULL -- B546 «Profil Amino kiselina u serumu»
UNION ALL SELECT 'amino-acid-profile-in-24h-urine', 37.00, NULL -- B547 «Profil Amino kiselina u urinu 24h»
UNION ALL SELECT 'adenovirus-igg', 18.00, NULL -- B548 «Adenovirus IgG»
UNION ALL SELECT 'adenovirus-igm', 18.00, NULL -- B549 «Adenovirus IgM»
UNION ALL SELECT 'anaplasma-phagocytophilum-igg', 17.00, NULL -- B550 «Anaplasma phagocytophilia IgG»
UNION ALL SELECT 'anaplasma-phagocytophilum-igm', 17.00, NULL -- B551 «Anaplasma phagocytophilia IgM»
UNION ALL SELECT 'anti-hev-igg-elisa', 24.00, NULL -- B552 «Anti- HEV IgG»
UNION ALL SELECT 'hav-igm', 13.00, NULL -- B553 «Anti-HAV-IgM»
UNION ALL SELECT 'anti-hbc-total-elisa', 11.00, NULL -- B554 «Anti-HBc-Ukupna antitela»
UNION ALL SELECT 'anti-hbe-elisa', 11.00, NULL -- B555 «Anti-HBe»
UNION ALL SELECT 'hbsab', 11.00, NULL -- B556 «Anti-HBs»
UNION ALL SELECT 'anti-hev-igm-elisa', 24.00, NULL -- B557 «Anti-HEV IgM»
UNION ALL SELECT 'asto', 10.00, NULL -- B558 «Anti-Streptolizin O (ASTO)»
UNION ALL SELECT 'borrelia-burgdorferi-igg', 13.00, NULL -- B559 «Antitela (IgG) prema Borelia burgdorferi»
UNION ALL SELECT 'borrelia-burgdorferi-igg-in-csf', 13.00, NULL -- B560 «Antitela (IgG) prema Borelia burgdorferi u CSF (Lajmska bolest)»
UNION ALL SELECT 'borrelia-burgdorferi-igm', 13.00, NULL -- B561 «Antitela (IgM) prema Borelia burgdorferi»
UNION ALL SELECT 'borrelia-burgdorferi-igm-in-csf', 13.00, NULL -- B562 «Antitela (IgM) prema Borelia burgdorferi u CSF (Lajmska bolest)»
UNION ALL SELECT 'chlamydia-trachomatis-igg', 27.00, NULL -- B564 «Antitela prema Chlamydia trachomatis (IgG)»
UNION ALL SELECT 'chlamydia-trachomatis-igm', 27.00, NULL -- B565 «Antitela prema Chlamydia trachomatis (IgM)»
UNION ALL SELECT 'galactomannan-test-aspergillus', 15.00, NULL -- B567 «Aspergillus galactomannan Ag»
UNION ALL SELECT 'aspergillus-total-antibodies', 15.00, NULL -- B568 «Aspergillus-Ukupna antitela»
UNION ALL SELECT 'babesia-igg', 17.00, NULL -- B569 «Babesia IgG»
UNION ALL SELECT 'babesia-igm', 17.00, NULL -- B570 «Babesia IgM»
UNION ALL SELECT 'bartonella-henselae-igg', 28.00, NULL -- B571 «Bartonella henselae- IgG»
UNION ALL SELECT 'bartonella-henselae-igm', 28.00, NULL -- B572 «Bartonella henselae IgM»
UNION ALL SELECT 'bartonella-quintana-igg', 28.00, NULL -- B573 «Bartonella quintana IgG»
UNION ALL SELECT 'bartonella-quintana-igm', 28.00, NULL -- B574 «Bartonella quintana IgM»
UNION ALL SELECT 'borrelia-burgdorferi-igg-western-blot', 33.00, NULL -- B575 «Borelia burgdorferi IgG At (Western Blot)»
UNION ALL SELECT 'borrelia-burgdorferi-igm-western-blot', 33.00, NULL -- B576 «Borelia burgdorferi IgM At (Western Blot)»
UNION ALL SELECT 'brucella-abortus-antibodies-agglutination', 11.00, NULL -- B577 «Brucella-At»
UNION ALL SELECT 'candida-iga-antibodies', 25.00, NULL -- B578 «Candida IgA Antitela»
UNION ALL SELECT 'candida-igg-antibodies', 25.00, NULL -- B579 «Candida IgG Antitela»
UNION ALL SELECT 'candida-igm-antibodies', 25.00, NULL -- B580 «Candida IgM Antitela»
UNION ALL SELECT 'chlamydia-pneumoniae-igg', 27.00, NULL -- B581 «Chlamydia pneumoniae IgG»
UNION ALL SELECT 'chlamydia-pneumoniae-igm', 27.00, NULL -- B582 «Chlamydia pneumoniae IgM»
UNION ALL SELECT 'cytomegalovirus-igg', 13.00, NULL -- B583 «CMV-IgG» / B864 «CMV-IgG»
UNION ALL SELECT 'cytomegalovirus-igm', 13.00, NULL -- B584 «CMV-IgM»
UNION ALL SELECT 'coxsackie-virus-igm', 15.00, NULL -- B586 «Coxsackie - IgM»
UNION ALL SELECT 'coxsackie-virus-igg', 15.00, NULL -- B587 «Coxsackie IgG»
UNION ALL SELECT 'cysticercosis-igg', 45.00, NULL -- B588 «Cysticercosis-Antitela»
UNION ALL SELECT 'epstein-barr-ebna-igg', 36.00, NULL -- B589 «EBV EBNA IgG -At»
UNION ALL SELECT 'epstein-barr-igg', 13.00, NULL -- B590 «EBV IgG» / B866 «EBV-IgG»
UNION ALL SELECT 'epstein-barr-igm', 13.00, NULL -- B591 «EBV IgM»
UNION ALL SELECT 'echinococcus-igg-elisa', 12.00, NULL -- B592 «Echinococcus IgG At»
UNION ALL SELECT 'echinococcus-granulosus-antibodies-indirect-hemagglutination', 28.00, NULL -- B593 «Echinococcus-ukupna antitela»
UNION ALL SELECT 'enterovirus-antibodies', 56.00, NULL -- B594 «Enteroviruses (Coxackie, ECHO, Polio)»
UNION ALL SELECT 'francisella-tularensis-igg', 11.00, NULL -- B597 «Francisella Tularensis IgG»
UNION ALL SELECT 'francisella-tularensis-igm', 11.00, NULL -- B598 «Francisella Tularensis IgM»
UNION ALL SELECT 'haemophilus-influenzae-igg', 23.00, NULL -- B599 «Haemophilus influenzae-IgG At»
UNION ALL SELECT 'hbeag', 14.00, NULL -- B600 «HBeAg»
UNION ALL SELECT 'hbsag', 11.00, NULL -- B601 «HBs Antigen»
UNION ALL SELECT 'helicobacter-pylori-iga', 12.00, NULL -- B602 «Helicobacter pylori- IgA»
UNION ALL SELECT 'helicobacter-pylori-igg', 12.00, NULL -- B603 «Helicobacter pylori- IgG»
UNION ALL SELECT 'hiv-ag-ab', 10.00, NULL -- B604 «HIV 1/2 (Combi)» / B605 «HIV 1/2 (Combi)»
UNION ALL SELECT 'herpes-simplex-ii-igm', 10.00, 13.00 -- B606 «HSV 2 IgM» / B610 «HSV-2 IgM» / B874 «HSV2-IgM»
UNION ALL SELECT 'herpes-simplex-i-igg', 13.00, NULL -- B607 «HSV-1 IgG»
UNION ALL SELECT 'herpes-simplex-virus-type-1-2-pcr', 28.00, NULL -- B608 «HSV-1/2 u uretralnom brisu»
UNION ALL SELECT 'herpes-simplex-ii-igg', 10.00, NULL -- B609 «HSV-2 IgG»
UNION ALL SELECT 'human-herpesvirus-6-igg', 14.00, NULL -- B611 «Humani Herpes Virus-Tip 6 (IgG)»
UNION ALL SELECT 'human-herpesvirus-6-igm', 14.00, NULL -- B612 «Humani Herpes Virus-Tip 6 (IgM)»
UNION ALL SELECT 'influenza-a-virus-iga', 11.00, NULL -- B613 «Influenza A IgA At» / B614 «Influenza A IgA At»
UNION ALL SELECT 'influenza-a-virus-igg-elisa', 11.00, NULL -- B615 «Influenza A IgG At»
UNION ALL SELECT 'influenza-b-virus-iga', 11.00, NULL -- B616 «Influenza B IgA At»
UNION ALL SELECT 'influenza-b-virus-igg-elisa', 11.00, NULL -- B617 «Influenza B IgG At»
UNION ALL SELECT 'helicobacter-pylori-urea-breath-test', 30.00, NULL -- B618 «Izdisajni test na H. Pylori»
UNION ALL SELECT 'legionella-pneumophila-igm', 38.00, NULL -- B619 «Legionella At (IgM)»
UNION ALL SELECT 'legionella-pneumophila-igg', 29.00, NULL -- B620 «Legionella At (IgG)»
UNION ALL SELECT 'legionella-pneumophila-antigen-urine', 14.00, NULL -- B621 «Legionella pneumophila (Antigen)»
UNION ALL SELECT 'leishmania-donovani-antibodies-indirect-hemagglutination', 16.00, NULL -- B622 «Leishmania donovani Antitela»
UNION ALL SELECT 'leishmania-donovani-igg-elisa', 16.00, NULL -- B623 «Leishmania donovani IgG»
UNION ALL SELECT 'leptospira-igg-elisa', 23.00, NULL -- B624 «Leptospira IgG»
UNION ALL SELECT 'leptospira-igm-elisa', 23.00, NULL -- B625 «Leptospira IgM»
UNION ALL SELECT 'listeria-monocytogenes-igg', 11.00, NULL -- B626 «Listeria monocytogenes- IgG»
UNION ALL SELECT 'measles-igg', 14.00, NULL -- B627 «Morbilli IgG»
UNION ALL SELECT 'measles-igm', 14.00, NULL -- B628 «Morbilli (Measle) IgM»
UNION ALL SELECT 'mumps-igg', 12.00, NULL -- B629 «MUMPS IgG»
UNION ALL SELECT 'mumps-igm', 12.00, NULL -- B630 «MUMPS IgM»
UNION ALL SELECT 'mycoplasma-pneumoniae-igg', 14.00, NULL -- B631 «Mycoplasma pneumoniae IgG»
UNION ALL SELECT 'mycoplasma-pneumoniae-igm', 14.00, NULL -- B632 «Mycoplasma pneumoniae IgM»
UNION ALL SELECT 'parainfluenza-virus-1-2-3-iga', 11.00, NULL -- B633 «Parainfluenza 1,2,3-IgA»
UNION ALL SELECT 'parainfluenza-virus-1-2-3-igg', 11.00, NULL -- B634 «Parainfluenza 1,2,3-IgG»
UNION ALL SELECT 'parvovirus-b19-igg', 12.00, NULL -- B635 «Parvovirus B19 -IgG»
UNION ALL SELECT 'parvovirus-b19-igm', 12.00, NULL -- B636 «Parvovirus B19- IgM»
UNION ALL SELECT 'streptococcus-pneumoniae-igg', 23.00, NULL -- B637 «Pneumococcus -IgG At»
UNION ALL SELECT 'adenovirus-rotavirus-in-stool', 15.00, NULL -- B638 «Rota/Adeno virus - feces»
UNION ALL SELECT 'rsv-antigen-in-bal', 12.00, NULL -- B640 «RSV-Antigen (BAL)»
UNION ALL SELECT 'strongyloides-stercoralis-igg', 33.00, NULL -- B641 «Strongyloides stercoralis IgG»
UNION ALL SELECT 'tetanus-antibodies', 23.00, NULL -- B642 «Tetanus antitela»
UNION ALL SELECT 'toxocara-canis-igg', 30.00, NULL -- B643 «Toxocara canis antitela (IgG)»
UNION ALL SELECT 'toxoplasma-igg-avidity', 46.00, NULL -- B644 «Toxoplasma IgG-Aviditet»
UNION ALL SELECT 'tpha-treponema-pallidum', 10.00, NULL -- B645 «TPHA»
UNION ALL SELECT 'treponema-pallidum-igg-western-blot', 34.00, NULL -- B646 «Treponema pallidum IgG At (Western Blot)»
UNION ALL SELECT 'treponema-pallidum-igm-western-blot', 34.00, NULL -- B647 «Treponema pallidum IgM At (Western Blot)»
UNION ALL SELECT 'trichinella-spiralis-igg', 11.00, NULL -- B648 «Trichinella spiralis IgG»
UNION ALL SELECT 'treponema-pallidum-total-antibodies', 9.00, NULL -- B649 «Ukupna At prema Treponema Pallidum»
UNION ALL SELECT 'vdrl', 20.00, NULL -- B650 «VDRL (Cardiolipin mikroflokulacioni test)»
UNION ALL SELECT 'varicella-zoster-virus-igg', 34.00, NULL -- B651 «VZV IgG»
UNION ALL SELECT 'varicella-zoster-igg-avidity', 13.00, NULL -- B652 «VZV IgG-Aviditet»
UNION ALL SELECT 'varicella-zoster-virus-igm', 13.00, NULL -- B653 «VZV-IgM»
UNION ALL SELECT 'yersinia-iga-antibodies', 23.00, NULL -- B654 «Yersinia IgA At»
UNION ALL SELECT 'yersinia-igg-antibodies', 23.00, NULL -- B655 «Yersinia IgG At»
UNION ALL SELECT 'yersinia-igm-antibodies', 23.00, NULL -- B656 «Yersinia IgM At»
UNION ALL SELECT 'mycobacterium-tuberculosis-culture-aspirate', 50.00, NULL -- B657 «Aspirat TBC»
UNION ALL SELECT 'acid-fast-bacilli-direct-smear', 8.00, NULL -- B658 «Direktni preparat na bacil tuberkuloze»
UNION ALL SELECT 'mycobacterium-tuberculosis-complex-pcr', 60.00, NULL -- B659 «M.Tuberculosis Complex-DNA» / B660 «M.Tuberculosis Complex-DNA»
UNION ALL SELECT 'quantiferon', 49.00, NULL -- B661 «QuantiFERON-TB GOLD»
UNION ALL SELECT 'mycobacterium-tuberculosis-culture-sputum', 50.00, NULL -- B662 «Sputum TBC»
UNION ALL SELECT 'mycobacterium-tuberculosis-culture-urine', 50.00, NULL -- B663 «Urin TBC»
UNION ALL SELECT 'bcr-abl-molecular-detection', 220.00, NULL -- B664 «BCR/ABL fuzioni transkript»
UNION ALL SELECT 'microsatellite-instability', 25.00, NULL -- B666 «Detekcija mikrosatelitske nestabilnosti (MSI)»
UNION ALL SELECT 'septin-9-msept9-methylation-test', 110.00, NULL -- B668 «Kolorektali kancer - skrining iz krvi (SEPTin9)»
UNION ALL SELECT 'braf-mutation', 54.00, NULL -- B669 «Mutacija V600E u 15. egzonu BRAF gena»
UNION ALL SELECT 'jak2-v617f-mutation', 80.00, NULL -- B671 «Mutacija V617F u JAK2 genu»
UNION ALL SELECT 'kras-mutations-codons-12-and-13', 46.00, NULL -- B672 «Mutacije u 12. i 13. kodonu K-RAS gena»
UNION ALL SELECT 'apc-gene-mutations-exon-15-codons-1085-1160', 51.00, NULL -- B674 «Mutacije u APC genu (1085. - 1160. kodon 15. egzona APC gena)»
UNION ALL SELECT 'brca1-full-gene-sequencing', 510.00, NULL -- B675 «Mutacije u BRCA1 genu (CEO GEN)»
UNION ALL SELECT 'brca1-known-familial-mutation-test', 160.00, NULL -- B676 «Mutacije u BRCA1 genu (član porodice-poznate mutacije)»
UNION ALL SELECT 'brca1-partial-sequencing', 220.00, NULL -- B677 «Mutacije u BRCA1 genu (parcijalno sekveniranje)»
UNION ALL SELECT 'brca2-full-gene-sequencing', 670.00, NULL -- B678 «Mutacije u BRCA2 genu (CEO GEN)»
UNION ALL SELECT 'brca2-known-familial-mutation-test', 160.00, NULL -- B679 «Mutacije u BRCA2 genu (član porodice-poznate mutacije)»
UNION ALL SELECT 'brca2-partial-sequencing', 220.00, NULL -- B680 «Mutacije u BRCA2 genu (parcijalno sekveniranje)»
UNION ALL SELECT 'egfr-gene-mutations-exons-18-21', 95.00, NULL -- B681 «Mutacije u EGFR genu - 18, 19, 20. i 21. egzon»
UNION ALL SELECT 'nras-mutations-codons-12-13-and-61', 95.00, NULL -- B683 «Mutacije u N-RAS genu - 12, 13. i 61. kodon»
UNION ALL SELECT 'tp53-gene-mutations-exons-5-8', 51.00, NULL -- B685 «Mutacije u P53 genu (5, 6, 7. i 8.exon p53 gena)»
UNION ALL SELECT 'adamts13-gene-analysis', 790.00, NULL -- B689 «ADAMTS13 (HUS)»
UNION ALL SELECT 'alpha-1-antitrypsin-genotyping', 81.00, NULL -- B690 «Alfa-1 antitripsin - genotip»
UNION ALL SELECT 'apob-gene-mutation-familial-defective-apob-100', 150.00, NULL -- B691 «APOB-100 (APOB gen)»
UNION ALL SELECT 'apolipoprotein-e-genotyping', 150.00, NULL -- B692 «Apolipoprotein E genotip»
UNION ALL SELECT 'becker-muscular-dystrophy-genetic-test', 920.00, NULL -- B693 «Beckerova Muskularna Distrofija (BMD)»
UNION ALL SELECT 'biliary-atresia-genetic-test', 440.00, NULL -- B694 «Bilijarna atrezija - genetičko ispitivanje»
UNION ALL SELECT 'huntington-disease-analysis', 98.00, NULL -- B695 «CAG tripletski ponovci u HTT genu (Hantingtonova bolest)»
UNION ALL SELECT 'cyp27a1-gene-analysis', 630.00, NULL -- B696 «CYP27A1-gen»
UNION ALL SELECT 'hla-dq2-dq8-typing', 86.00, NULL -- B697 «Detekcija HLA-DQ2 i HLA-DQ8 genotipa (Intolerancija na gluten)»
UNION ALL SELECT 'targeted-mutation-analysis-on-request-1-sequence', 79.00, NULL -- B698 «Detekcija mutacija po zahtevu (1 sekvenca)»
UNION ALL SELECT 'duchenne-muscular-dystrophy', 710.00, 800.00 -- B699 «Dišenova Muskularna Distrofija-DMD (Distrofin)» / B700 «Dišenova Muskularna Distrofija-DMD (Distrofin)»
UNION ALL SELECT 'genetic-dna-profile', 120.00, NULL -- B703 «Genetički DNK profil»
UNION ALL SELECT 'hla-a-typing', 83.00, NULL -- B704 «HLA Tipizacija (A Lokus)»
UNION ALL SELECT 'hla-b-typing', 83.00, NULL -- B705 «HLA Tipizacija (B Lokus)»
UNION ALL SELECT 'hla-b27-antigen', 83.00, NULL -- B706 «HLA-B27 Antigen»
UNION ALL SELECT 'hla-drb1-typing', 83.00, NULL -- B707 «HLA-DRB 1»
UNION ALL SELECT 'maternity-test-mother-and-child', 240.00, NULL -- B709 «Materinstvo - poređenje genetičkih profila (majka + dete)»
UNION ALL SELECT 'dna-kinship-test-additional-person', 79.00, NULL -- B710 «Materinstvo - poređenje genetičkih profila (sledeći član)» / B740 «Očinstvo - poređenje genetičkih profila (sledeći član)»
UNION ALL SELECT 'microdeletion-syndromes-angelman', 130.00, NULL -- B711 «Microdelecijski sindromi:Angelman/Prader Willy»
UNION ALL SELECT 'y-chromosome-microdeletion', 79.00, NULL -- B712 «Mikrodelecije Y hromozoma - AZFa, AZFb, AZFc regioni»
UNION ALL SELECT 'mody-3-hnf1a-gene', 870.00, NULL -- B715 «MODY-3 HNF1A (TCF1)»
UNION ALL SELECT 'sickle-cell-mutation-hbb-codon-6', 31.00, NULL -- B716 «Mutacija u 6. kodonu HBB gena (Srpasta anemija)»
UNION ALL SELECT 'jag1-gene-mutations-exon-4', 39.00, NULL -- B717 «Mutacija u Jag1 genu - 4.exon (Alagille sy.)»
UNION ALL SELECT 'dsp-gene-mutations-exon-24', 45.00, NULL -- B718 «Mutacije DSP genu - 24. exon»
UNION ALL SELECT 'f9-gene-mutations-and-deletions-hemophilia-b', 740.00, NULL -- B719 «Mutacije i delecije u F9 genu Faktor 9 (Hemofilija B)»
UNION ALL SELECT 'beta-thalassemia-pcr', 98.00, NULL -- B720 «Mutacije i delecije u HBB genu (Beta talasemija)»
UNION ALL SELECT 'atp7b-full-gene-sequencing', 530.00, NULL -- B721 «Mutacije u ATP7B genu - CEO GEN (Vilsonova bolest)»
UNION ALL SELECT 'atp7b-known-familial-mutation-test', 75.00, NULL -- B722 «Mutacije u ATP7B genu - član porodice-poznate mutacije (Vilsonova bolest)»
UNION ALL SELECT 'wilson-disease-pcr', 120.00, NULL -- B723 «Mutacije u ATP7B genu (Vilsonova bolest)»
UNION ALL SELECT 'btnl2-gene-mutations-exons-5-and-6', 98.00, NULL -- B724 «Mutacije u BTNL2 genu - 5. i 6. egzon (Sarkoidoza)»
UNION ALL SELECT 'cystic-fibrosis-34-mutations', 106.00, NULL -- B725 «Mutacije u CFTR genu (Cistična fibroza)»
UNION ALL SELECT '21-hydroxylase-cyp21a2', 280.00, NULL -- B726 «Mutacije u CYP21A2 genu (Kongenitalna adrenalna hiperplazija)»
UNION ALL SELECT 'fgfr2-gene-mutations-exon-7', 48.00, NULL -- B727 «Mutacije u FGFR2 genu - 7. egzon (Apertov sindrom)»
UNION ALL SELECT 'gba-gene-mutations-exons-2-9-10-and-11', 170.00, NULL -- B728 «Mutacije u GBA genu - 2, 9, 10. i 11. egzon (Gošeova bolest)»
UNION ALL SELECT 'hemochromatosis-pcr-c282y', 150.00, NULL -- B729 «Mutacije u HFE genu (Hemohromatoza)»
UNION ALL SELECT 'hfe-known-familial-mutation-test', 77.00, NULL -- B730 «Mutacije u HFE genu, član porodice-poznate mutacije (Hemohromatoza)»
UNION ALL SELECT 'mc4r-gene-mutations', 92.00, NULL -- B731 «Mutacije u MC4R genu (Gojaznost)»
UNION ALL SELECT 'mc4r-known-familial-mutation-test', 46.00, NULL -- B732 «Mutacije u MC4R genu Član porodice-poznate mutacije(Gojaznost)»
UNION ALL SELECT 'lactose-intolerance-pcr', 67.00, NULL -- B733 «Mutacije u MCM6 genu (Intolerancija na laktozu)»
UNION ALL SELECT 'slc2a1-gene-mutations-glut1-deficiency', 310.00, NULL -- B734 «Mutacije u SLC2A1 genu (Glutation-1 deficijencija)»
UNION ALL SELECT 'spr-gene-mutations-sepiapterin-reductase-deficiency', 80.00, NULL -- B735 «Mutacije u SPR genu (za Sepiapterin reduktazu)»
UNION ALL SELECT 'tmprss6-gene-mutations-irida', 470.00, NULL -- B737 «Mutacije u TMPRSS6 genu (IRIDA iron-refractory iron deficiency anemia)»
UNION ALL SELECT 'nutrigenetic-lipid-metabolism-panel-9-mutations', 110.00, NULL -- B738 «Nutrigenetika (9 mutacija, metabolizam lipida, triglicerida i masnih kiselina)»
UNION ALL SELECT 'paternity-testing-pcr', 240.00, NULL -- B739 «Očinstvo - poređenje genetičkih profila (otac + dete)» / B742 «Očinstvo (otac + dete) - genetičko ispitivanje»
UNION ALL SELECT 'cholestasis-gene-panel-15-genes', 130.00, NULL -- B743 «Panel - Holestaza (15 gena)»
UNION ALL SELECT 'pca3-score-prostate-cancer', 240.00, NULL -- B744 «PCA3 mRNA-Score»
UNION ALL SELECT 'facioscapulohumeral-muscular-dystrophy-fshd1-genetic-test', 490.00, NULL -- B745 «PCR FSHMD1A»
UNION ALL SELECT 'friedreich-ataxia', 98.00, NULL -- B746 «PCR-Friedreich ataxia»
UNION ALL SELECT 'sex-chromosome-aneuploidy-pcr-x-y', 55.00, NULL -- B747 «Polni hromozomi (Aneuploidije hromozoma X i Y) PCR»
UNION ALL SELECT 'numerical-aberration-analysis-chromosomes', 96.00, NULL -- B748 «Postnatalne aneuploidije(hromozomi: 13,18,21,X,Y) PCR»
UNION ALL SELECT 'spinocerebellar-ataxia-type-1-sca1', 98.00, NULL -- B750 «Spinocerebralna ataxia tipa 1»
UNION ALL SELECT 'hif1a-gene-mutation-sports-genetics', 31.00, NULL -- B751 «Sport analiza (Mutacija u HIF1 genu)»
UNION ALL SELECT 'sports-genetics-panel-hif1a-actn3-ace', 44.00, NULL -- B752 «Sport Paket (HIF1 gen, ACTN3 gen i ACE gen)»
UNION ALL SELECT 'hereditary-disease-carrier-screening-400-mutations', 530.00, NULL -- B753 «STID - Skrining na nasledne bolesti (400 mutacija)»
UNION ALL SELECT 'bordetella-pertussis-pcr', 110.00, NULL -- B754 «Bordetella pertussis DNA»
UNION ALL SELECT 'borrelia-burgdorferi-pcr', 63.00, NULL -- B755 «Borrelia burgdorferi DNA»
UNION ALL SELECT 'chlamydia-trachomatis-real-time-pcr', 20.00, NULL -- B756 «Chlamydia trachomatis DNK»
UNION ALL SELECT 'clostridium-difficile-pcr', 44.00, NULL -- B757 «Clostridium difficile DNK»
UNION ALL SELECT 'cryptococcus-neoformans-pcr', 130.00, NULL -- B758 «Cryptococcus neoformans DNA»
UNION ALL SELECT 'std-multiplex-6', 87.00, NULL -- B759 «Detekcija prisustva polno prenosivih patogena (6 patogena)» / B760 «Detekcija prisustva polno prenosivih patogena (6 patogena)» / B761 «Detekcija prisustva polno prenosivih patogena (6 patogena)» / B762 «Detekcija prisustva polno prenosivih patogena (6 patogena)»
UNION ALL SELECT 'helicobacter-pylori-pcr-in-stool', 62.00, NULL -- B763 «Helicobacter pylori DNA (u fecesu)»
UNION ALL SELECT 'legionella-pneumophila-pcr', 78.00, NULL -- B764 «Legionella pneumophilia DNA»
UNION ALL SELECT 'mycobacterium-leprae-pcr', 75.00, NULL -- B765 «Mycobacterium Leprae DNK»
UNION ALL SELECT 'mycoplasma-genitalium-real-time-pcr', 20.00, NULL -- B766 «Mycoplasma genitalium DNK»
UNION ALL SELECT 'mycoplasma-hominis-real-time-pcr', 20.00, NULL -- B767 «Mycoplasma hominis DNK»
UNION ALL SELECT 'mycoplasma-pneumoniae-pcr', 63.00, NULL -- B768 «Mycoplasma pneumoniae DNA»
UNION ALL SELECT 'neisseria-gonorrhoeae-real-time-pcr', 20.00, NULL -- B769 «Neisseria gonorrhoeae DNK»
UNION ALL SELECT 'pneumocystis-jirovecii-pcr', 120.00, 150.00 -- B770 «Pneumocystis carinii DNA» / B771 «Pneumocystis carinii DNA»
UNION ALL SELECT 'toxoplasma-gondii-pcr', 11.00, NULL -- B772 «Toxoplasma gondii DNA»
UNION ALL SELECT 'treponema-pallidum-pcr', 63.00, NULL -- B773 «Treponema pallidum DNA»
UNION ALL SELECT 'trichomonas-vaginalis-real-time-pcr', 20.00, NULL -- B774 «Trichomonas vaginalis»
UNION ALL SELECT 'tropheryma-whipplei-pcr', 44.00, NULL -- B775 «Tropheryma Whipplei DNK»
UNION ALL SELECT 'ureaplasma-urealyticum-pcr', 20.00, NULL -- B776 «Ureaplasma urealyticum DNK»
UNION ALL SELECT 'adenovirus-pcr', 97.00, NULL -- B777 «Adenovirus DNA (kvalitativno)»
UNION ALL SELECT 'cytomegalovirus-pcr', 58.00, NULL -- B778 «CMV (Citomegalovirus) DNA»
UNION ALL SELECT 'cytomegalovirus-pcr-quantitative', 58.00, NULL -- B779 «CMV (Kvantitativna analiza Citomegalovirusa)»
UNION ALL SELECT 'epstein-barr-virus-pcr', 110.00, NULL -- B781 «EBV-DNA (PCR)»
UNION ALL SELECT 'hbv-pcr-dna-qualitative', 81.00, NULL -- B782 «HBV DNK (Kvalitativna analiza Hepatitis B virusa)»
UNION ALL SELECT 'hbv-pcr-dna-quantitative', 81.00, NULL -- B783 «HBV DNK (Kvantitativna analiza Hepatitis B virusa)» / B787 «Hepatitis B - DNA - kvantitativno»
UNION ALL SELECT 'hcv-pcr-rna-qualitative', 6.00, NULL -- B784 «HCV RNK (Kvalitativna analiza Hepatitis C virusa)»
UNION ALL SELECT 'hcv-pcr-rna-quantitative', 120.00, NULL -- B785 «HCV RNK (Kvantitativna analiza Hepatitis C virusa)»
UNION ALL SELECT 'hcv-rna-genotyping', 270.00, NULL -- B786 «HCV-Genotipizacija»
UNION ALL SELECT 'hiv-pcr-rna-quantitative', 94.00, NULL -- B788 «HIV - RNA - kvantitativno» / B790 «HIV RNK (Kvantitativna analiza HIV-a)»
UNION ALL SELECT 'hiv-pcr-rna-qualitative', 94.00, NULL -- B789 «HIV RNK (Kvalitativna analiza HIV-a)»
UNION ALL SELECT 'human-herpesvirus-6-pcr', 130.00, NULL -- B791 «Humani-Herpes-Virus-Tip-6-DNA»
UNION ALL SELECT 'parvovirus-b19-pcr', 130.00, NULL -- B792 «Parvovirus B19 - DNA (PCR)»
UNION ALL SELECT 'herpes-simplex-virus-1-2-and-varicella-zoster-virus-pcr', 47.00, NULL -- B793 «PCR-HSV HSV 1+2+VZV»
UNION ALL SELECT 'jc-virus-pcr', 110.00, 112.00 -- B794 «Polioma JCV Virus DNA» / B876 «JC-Polyoma virus DNA»
UNION ALL SELECT 'bk-virus-pcr', 112.00, NULL -- B795 «Polioma-BK virus DNA»
UNION ALL SELECT 'varicella-zoster-virus-pcr', 68.00, NULL -- B796 «Varicella - DNA»
UNION ALL SELECT 'procr-gene-haplotype', 31.00, NULL -- B797 «Haplotip PROCR gena (endotelni protein receptor C)»
UNION ALL SELECT 'prothrombin-ii-locus-20210-pcr', 31.00, NULL -- B798 «Mutacija u genu za faktor koagulacije II (Protrombin II; G20210A)»
UNION ALL SELECT 'factor-v-hr2-locus-4070', 31.00, NULL -- B799 «Mutacija u genu za faktor koagulacije V (A4070G)»
UNION ALL SELECT 'factor-v-leiden-locus-1691', 31.00, NULL -- B800 «Mutacija u genu za faktor koagulacije V (R506Q, Leiden V)»
UNION ALL SELECT 'factor-xiii-locus-v34l', 31.00, NULL -- B801 «Mutacija u genu za faktor koagulacije XIII (V34L)»
UNION ALL SELECT 'mthfr-locus-677-pcr', 31.00, NULL -- B802 «Mutacija u genu za metilentetrahidrofolat reduktazu (MTHFR; C677T)»
UNION ALL SELECT 'mthfr-locus-1298', 31.00, NULL -- B803 «Mutacija u genu za MTHFR (A1298C)»
UNION ALL SELECT 'thrombophilia-3-genes-3-loci', 95.00, NULL -- B804 «Panel - nasledne trombofilije 3 mutacije (Leiden V, Protrombin II, MTHFR)»
UNION ALL SELECT 'hereditary-thrombophilia-panel-9-mutations', 220.00, NULL -- B805 «Panel - nasledne trombofilije 9 mutacija»
UNION ALL SELECT 'pai-1-675-4g-5g', 46.00, NULL -- B806 «Polimorfizam u genu za Plazminogen Aktivator Inhibitor-1 (PAI-1)»
UNION ALL SELECT 'double-test-first-trimester-screening', 25.00, NULL -- B808 «DOUBLE test»
UNION ALL SELECT 'quadruple-test', 49.00, NULL -- B809 «Quadruple-("Q") test»
UNION ALL SELECT 'triple-test-second-trimester-screening', 28.00, NULL -- B810 «TRIPLE Test»
UNION ALL SELECT 'waaler-rose-test', 7.00, NULL -- B811 «Waaler Rose»
UNION ALL SELECT 'bordetella-pertussis-igg', 24.00, NULL -- B812 «Bordetella pertussis IgG»
UNION ALL SELECT 'candida-antigen', 9.00, NULL -- B813 «Candida-Antigen test (RAMCO)»
UNION ALL SELECT 'chlamydia-psittaci-iga', 35.00, NULL -- B814 «Chlamydia psittaci IgA»
UNION ALL SELECT 'chlamydia-psittaci-igg', 35.00, NULL -- B815 «Chlamydia psittaci IgG»
UNION ALL SELECT 'chlamydia-psittaci-igm', 35.00, NULL -- B816 «Chlamydia psittaci IgM»
UNION ALL SELECT 'acylcarnitine-profile', 29.00, NULL -- B817 «Acilkarnitin Profil»
UNION ALL SELECT 'keto-acids', 27.00, NULL -- B819 «Keto kiseline»
UNION ALL SELECT 'irregular-antibody-screening', 13.00, NULL -- B820 «Screening antitela»
UNION ALL SELECT '5-hiaa', 12.00, NULL -- B821 «5-Hidroksiindol sirćetna kiselina»
UNION ALL SELECT 'afp', 13.00, NULL -- B822 «AFP (α1-Fetoprotein)»
UNION ALL SELECT 'beta-2-microglobulin', 12.00, NULL -- B823 «Beta2 - mikroglobulin u serumu»
UNION ALL SELECT 'ca-125', 13.00, NULL -- B824 «CA-125»
UNION ALL SELECT 'ca-15-3', 13.00, NULL -- B825 «CA-15-3»
UNION ALL SELECT 'ca-19-9', 13.00, NULL -- B826 «CA-19-9»
UNION ALL SELECT 'ca-50', 28.00, NULL -- B827 «CA-50»
UNION ALL SELECT 'ca-72-4', 13.00, NULL -- B828 «CA-72-4»
UNION ALL SELECT 'calcitonin', 13.00, NULL -- B829 «Calcitonin»
UNION ALL SELECT 'cea', 13.00, NULL -- B830 «CEA»
UNION ALL SELECT 'complexed-psa', 13.00, NULL -- B831 «cPSA»
UNION ALL SELECT 'cyfra-21-1', 14.00, NULL -- B832 «CYFRA 21-1»
UNION ALL SELECT 'psa-plus-free-psa', 18.00, NULL -- B833 «FPSA/PSA/ Index»
UNION ALL SELECT 'he4', 23.00, NULL -- B834 «HE4»
UNION ALL SELECT 'nse', 13.00, NULL -- B836 «NSE»
UNION ALL SELECT 'placental-alkaline-phosphatase', 16.00, NULL -- B837 «Placentalna alkalna fosfataza (hPLAP)»
UNION ALL SELECT 'psa', 13.00, NULL -- B838 «PSA»
UNION ALL SELECT 'free-psa', 13.00, NULL -- B839 «PSA-Free»
UNION ALL SELECT 'protein-s-100', 20.00, NULL -- B840 «S-100»
UNION ALL SELECT 'scc-squamous-cell-carcinoma-antigen', 25.00, NULL -- B841 «SCC (squamous cell carcinoma antigen)»
UNION ALL SELECT 'thymidine-kinase', 21.00, NULL -- B842 «Timidin Kinaza (TK)»
UNION ALL SELECT 'thyroglobulin', 11.00, NULL -- B843 «Tireoglobulin»
UNION ALL SELECT 'bence-jones-protein', 3.00, NULL -- B844 «Bence Jones proteinurija (kvalitativno)»
UNION ALL SELECT 'beta-2-microglobulin-in-urine', 10.00, NULL -- B845 «Beta2-mikroglobulin u urinu»
UNION ALL SELECT 'creatinine-clearance', 10.00, NULL -- B846 «Klirens kreatinina»
UNION ALL SELECT 'urea-clearance', 10.00, NULL -- B847 «Klirens uree»
UNION ALL SELECT 'uric-acid-in-24h-urine', 2.00, NULL -- B849 «Mokraćna kiselina u urinu 24h»
UNION ALL SELECT 'formic-acid-in-urine', 19.00, NULL -- B850 «Mravlja kiselina u urinu»
UNION ALL SELECT 'urine-osmolality', 5.00, NULL -- B851 «Osmolalitet-urin»
UNION ALL SELECT 'complete-urinalysis', 3.00, NULL -- B852 «Pregled urina»
UNION ALL SELECT 'protein-in-urine', 4.00, NULL -- B853 «Proteini u urinu - kvalitativno»
UNION ALL SELECT 'protein-in-24h-urine', 4.00, NULL -- B854 «Proteini u urinu 24h»
UNION ALL SELECT 'pyridinium-crosslinks-in-urine', 16.00, NULL -- B855 «Pyridinijum "crosslinks" u urinu»
UNION ALL SELECT 'urine-specific-gravity', 1.00, NULL -- B856 «Specifična težina urina»
UNION ALL SELECT 'anti-hcv', 13.00, NULL -- B862 «Anti-HCV»
UNION ALL SELECT 'cmv-avidity', 31.00, NULL -- B863 «CMV IgG-Aviditet»
UNION ALL SELECT 'coxsackie-virus-igg-in-csf', 19.00, NULL -- B865 «Coxsackie IgG, CSF»
UNION ALL SELECT 'anti-hbc-igm-elisa', 24.00, NULL -- B868 «HbC IgM At»
UNION ALL SELECT 'anti-hcv-antibodies-immunoblot', 55.00, NULL -- B870 «HCV-RIBA»
UNION ALL SELECT 'hiv-p24-antigen-elisa', 17.00, NULL -- B871 «HIV-p24 Antigen»
UNION ALL SELECT 'anti-hiv-1-western-blot-confirmation', 34.00, NULL -- B872 «HIV-Potvrdni test (Imunoblot)»
UNION ALL SELECT 'herpes-simplex-i-igm', 10.00, NULL -- B873 «HSV1-IgM»
UNION ALL SELECT 'htlv-i-ii-antibodies', 9.00, NULL -- B875 «HTLV I/II»
UNION ALL SELECT 'poliovirus-antibodies', 56.00, NULL -- B877 «Poliovirusi»
UNION ALL SELECT 'rubella-igg', 12.00, NULL -- B878 «Rubella IgG»
UNION ALL SELECT 'rubella-igg-avidity', 31.00, NULL -- B879 «Rubella IgG-Aviditet»
UNION ALL SELECT 'rubella-igm', 12.00, NULL -- B880 «Rubella IgM»
UNION ALL SELECT 'coenzyme-q10', 35.00, NULL -- B881 «Coenzmye Q10 (Ubichinon)»
UNION ALL SELECT 'folic-acid', 10.00, NULL -- B882 «Folna kiselina (Vitamin B9)»
UNION ALL SELECT 'methylmalonic-acid', 62.00, NULL -- B883 «Metil Malonska kiselina (Serum)»
UNION ALL SELECT 'methylmalonic-acid-in-urine', 62.00, NULL -- B884 «Metil Malonska kiselina (Urin)»
UNION ALL SELECT 'vitamin-a', 62.00, NULL -- B885 «Vitamin A (Retinol)»
UNION ALL SELECT 'vitamin-b1-level', 23.00, NULL -- B886 «Vitamin B1(Tiamin)»
UNION ALL SELECT 'vitamin-b12', 11.00, NULL -- B887 «Vitamin B12»
UNION ALL SELECT 'vitamin-b6-level', 56.00, NULL -- B888 «Vitamin B6 (Piridoksal Fosfat)»
UNION ALL SELECT 'vitamin-c-level', 48.00, NULL -- B889 «Vitamin C»
UNION ALL SELECT 'vitamin-d-25-oh', 20.00, NULL -- B890 «Vitamin D (25(OH)D3; 25(OH)D2)»
UNION ALL SELECT 'vitamin-e-level', 21.00, NULL -- B891 «Vitamin E»
UNION ALL SELECT 'vitamin-h-b7-biotin-level', 21.00, NULL -- B892 «Vitamin H (Biotin)»
UNION ALL SELECT 'vitamin-k1-level', 27.00, NULL -- B893 «Vitamin K»
UNION ALL SELECT 'amniotic-fluid-culture', 13.00, NULL -- M001 «Amnion Bakteriološki»
UNION ALL SELECT 'antimycogram', 16.00, NULL -- M002 «Antimikogram»
UNION ALL SELECT 'quantitative-aspirate-culture', 14.00, NULL -- M003 «Aspirat-kvantitativno»
UNION ALL SELECT 'bacterial-vaginosis-test', 6.00, NULL -- M004 «Bakterijska Vaginoza»
UNION ALL SELECT 'peritoneal-dialysis-catheter-exit-site-swab-culture', 13.00, NULL -- M005 «Bakteriološki pregled izlazišta PD katetera»
UNION ALL SELECT 'biopsy-material-mycobacterial-culture-lowenstein-jensen', 30.00, NULL -- M006 «Biopsijski materijal - Lowenstein»
UNION ALL SELECT 'tissue-biopsy-culture-anaerobic', 10.00, NULL -- M007 «Biopsijski materijal- anaerobno»
UNION ALL SELECT 'tissue-biopsy-culture-aerobic', 5.00, NULL -- M008 «Biopsijski materijal- bakteriološki»
UNION ALL SELECT 'mycoplasma-hominis-culture', 10.00, 12.00 -- M010 «Biopsijski materijal- Mycoplasma hominis» / M050 «Cervikalni bris-Mycoplasma hominis» / M078 «Sperma- Mycoplasma hominis» / M093 «Uretralni bris- Mycoplasma hominis»
UNION ALL SELECT 'ureaplasma-urealyticum-culture', 10.00, 12.00 -- M011 «Biopsijski materijal- Ureaplasma urealyticum» / M048 «Cervikalni bris- Ureaplasma urealyticum» / M079 «Sperma- Ureaplasma urealyticum» / M094 «Uretralni bris- Ureaplasma Urealiticum»
UNION ALL SELECT 'borrelia-burgdorferi-pcr-in-tick', 41.00, NULL -- M012 «Borrelia burgdoferi DNA, Krpelj»
UNION ALL SELECT 'breast-swab-bacteria', 6.00, NULL -- M013 «Bris dojke bakteriološki»
UNION ALL SELECT 'breast-swab-fungi', 6.00, NULL -- M014 «Bris dojke mikološki»
UNION ALL SELECT 'glans-swab-bacteria', 6.00, NULL -- M015 «Bris glansa- bakteriološki»
UNION ALL SELECT 'glans-swab-fungi', 6.00, NULL -- M016 «Bris glansa- mikološki»
UNION ALL SELECT 'throat-swab-fungi', 6.00, NULL -- M017 «Bris grla- mikološki»
UNION ALL SELECT 'throat-swab-bacteria', 6.00, NULL -- M018 «Bris grla-bakteriološki»
UNION ALL SELECT 'tongue-swab-bacteria', 6.00, NULL -- M019 «Bris jezika- bakteriološki»
UNION ALL SELECT 'tongue-swab-fungi', 6.00, NULL -- M020 «Bris jezika- mikološki»
UNION ALL SELECT 'skin-swab-fungi', 6.00, NULL -- M021 «Bris kože- mikološki»
UNION ALL SELECT 'skin-swab-bacteria', 6.00, NULL -- M022 «Bris kože-bakteriološki»
UNION ALL SELECT 'lochia-swab-culture-anaerobic', 10.00, NULL -- M023 «Bris lohija- anaerobno»
UNION ALL SELECT 'lochia-swab-culture-aerobic', 6.00, NULL -- M024 «Bris lohija bakteriološki»
UNION ALL SELECT 'nose-swab-fungi', 6.00, NULL -- M025 «Bris nosa- mikološki»
UNION ALL SELECT 'nose-swab-bacteria', 6.00, NULL -- M026 «Bris nosa-bakteriološki»
UNION ALL SELECT 'eye-swab-bacteria', 6.00, NULL -- M027 «Bris oka - bakteriološki»
UNION ALL SELECT 'eye-swab-chlamydia', 12.00, NULL -- M028 «Bris oka- Chlamidiae trachomatis»
UNION ALL SELECT 'eye-swab-fungi', 6.00, NULL -- M029 «Bris oka- mikološki»
UNION ALL SELECT 'prepuce-swab-bacteria', 6.00, NULL -- M030 «Bris prepucijuma- bakteriološki»
UNION ALL SELECT 'prepuce-swab-fungi', 7.00, NULL -- M031 «Bris prepucijuma- mikološki»
UNION ALL SELECT 'wound-swab-culture-anaerobic', 10.00, NULL -- M032 «Bris rane- anaerobno»
UNION ALL SELECT 'wound-swab-fungi', 7.00, NULL -- M033 «Bris rane mikološki»
UNION ALL SELECT 'wound-swab-bacteria', 6.00, NULL -- M034 «Bris rane-bakteriološki»
UNION ALL SELECT 'ear-swab-fungi', 7.00, NULL -- M035 «Bris uha- mikološki»
UNION ALL SELECT 'bacteriological-examination-ear-swab', 6.00, NULL -- M036 «Bris uha-bakteriološki»
UNION ALL SELECT 'oral-cavity-swab-bacteria', 6.00, NULL -- M037 «Bris usne duplje-bakteriološki»
UNION ALL SELECT 'oral-cavity-fungi', 7.00, NULL -- M038 «Bris usne duplje-mikološki»
UNION ALL SELECT 'vulvar-swab-bacteria', 7.00, NULL -- M039 «Bris vulve- bakteriološki»
UNION ALL SELECT 'vulvar-swab-fungi', 7.00, NULL -- M040 «Bris vulve- mikološki»
UNION ALL SELECT 'bronchial-aspirate-culture-for-bacteria', 7.00, NULL -- M041 «Bronhoaspirat bakteriološki»
UNION ALL SELECT 'bronchial-aspirate-culture-for-fungi', 7.00, NULL -- M042 «Bronhoaspirat mikološki»
UNION ALL SELECT 'campylobacter-culture', 8.00, NULL -- M043 «Campylobacter spp»
UNION ALL SELECT 'microscopic-examination-of-swab-for-gonorrhea', 5.00, NULL -- M044 «CB (dir.prep)- na N. gonorrhoeoe» / M088 «Uretralni bris (dir.prep)- na N. Gonorrhoeoe»
UNION ALL SELECT 'cervical-swab-culture-anaerobic', 11.00, NULL -- M045 «Cervikalni bris- anaerobno»
UNION ALL SELECT 'chlamydia-genital-swab', 11.00, 12.00 -- M046 «Cervikalni bris- Chlamidiae trachomatis» / M091 «Uretralni bris- Chlamidiae trachomatis»
UNION ALL SELECT 'cervical-swab-fungi', 8.00, NULL -- M047 «Cervikalni bris- mikološki»
UNION ALL SELECT 'cervical-swab-bacteria', 7.00, NULL -- M049 «Cervikalni bris-bakteriološki»
UNION ALL SELECT 'clostridium-difficile-toxin-a-and-b', 24.00, NULL -- M051 «Clostridium difficile Toxin A i B»
UNION ALL SELECT 'demodex-species', 4.00, NULL -- M052 «Demodex»
UNION ALL SELECT 'stool-culture', 6.00, NULL -- M053 «Feces- bakteriološki»
UNION ALL SELECT 'stool-fungi', 7.00, NULL -- M054 «Feces- mikološki»
UNION ALL SELECT 'stool-parasites', 6.00, NULL -- M055 «Feces- parazitološki (helminti)»
UNION ALL SELECT 'stool-microscopic-examination-for-protozoa', 6.00, NULL -- M056 «Feces-Protozoe»
UNION ALL SELECT 'vaginal-discharge-dmp', 7.00, NULL -- M057 «Grupa vaginalnog sekreta»
UNION ALL SELECT 'blood-culture-anaerobic', 12.00, NULL -- M058 «Hemokultura - anaerobno»
UNION ALL SELECT 'blood-culture-aerobic', 12.00, NULL -- M059 «Hemokultura-aerobno»
UNION ALL SELECT 'intravascular-catheter-tip-swab-culture-aerobic', 12.00, NULL -- M060 «Intravaskularni kateter»
UNION ALL SELECT 'nipple-discharge-bacteria', 7.00, NULL -- M061 «Iscedak dojke bakteriološki»
UNION ALL SELECT 'nipple-discharge-fungi', 8.00, NULL -- M062 «Iscedak dojke mikološki»
UNION ALL SELECT 'bacterial-identification-by-maldi-tof-ms', 12.00, NULL -- M067 «MALDI-TOF MS -identifikacija bakterija»
UNION ALL SELECT 'dermatophytes-hair-scraping', 7.00, NULL -- M068 «Mikološki pregled dlake»
UNION ALL SELECT 'dermatophytes-skin-scraping', 11.00, NULL -- M069 «Mikološki pregled strugotine kože»
UNION ALL SELECT 'perianal-impression', 4.00, NULL -- M071 «Perianalni otisak»
UNION ALL SELECT 'mycobacterium-tuberculosis-in-pleural-fluid', 51.00, NULL -- M072 «Pleuralni punktat TBC»
UNION ALL SELECT 'extended-antibiogram-e-test', 11.00, NULL -- M073 «Prošireni AB- E test»
UNION ALL SELECT 'punctate-aerobic', 7.00, NULL -- M074 «Punktat - bakteriološki»
UNION ALL SELECT 'abscess-content-culture-anaerobic', 11.00, NULL -- M075 «Pyo kultura - anaerobno»
UNION ALL SELECT 'rectal-swab-bacteria', 7.00, NULL -- M076 «Rektalni bris»
UNION ALL SELECT 'sperm-culture-fungi', 7.00, NULL -- M077 «Sperma- mikološki»
UNION ALL SELECT 'sperm-culture-bacteria', 7.00, NULL -- M080 «Sperma-bakteriološki»
UNION ALL SELECT 'sputum-bacteria', 6.00, NULL -- M081 «Sputum- bakteriološki»
UNION ALL SELECT 'sputum-fungi', 7.00, NULL -- M082 «Sputum- mikološki»
UNION ALL SELECT 'gbs-culture', 13.00, NULL -- M083 «Streptococcus agalactiae (Beta-hem strept B)»
UNION ALL SELECT 'rapid-strep-a', 6.00, NULL -- M084 «Streptococcus pyogenes-Brzi test»
UNION ALL SELECT 'skin-scraping-fungi', 7.00, NULL -- M085 «Strugotina kože- mikološki»
UNION ALL SELECT 'nail-scraping-fungi', 8.00, NULL -- M086 «Strugotina nokta- mikološki»
UNION ALL SELECT 'urethral-swab-microscopy-for-gardnerella', 5.00, NULL -- M087 «UB (dir.prep.)- na Gardnerella SPP»
UNION ALL SELECT 'trichomonas-test-urethral', 5.00, NULL -- M089 «Uretralni bris (dir.prep.)- na Trichomonas spp.»
UNION ALL SELECT 'urethral-swab-culture-anaerobic', 11.00, NULL -- M090 «Uretralni bris- anaerobno»
UNION ALL SELECT 'urethral-swab-fungi', 7.00, NULL -- M092 «Uretralni bris- mikološki»
UNION ALL SELECT 'urethral-swab-bacteria', 7.00, NULL -- M095 «Uretralni bris-bakteriološki»
UNION ALL SELECT 'chlamydia-trachomatis-pcr-urine', 12.00, NULL -- M096 «Urin- Chlamidiae trachomatis»
UNION ALL SELECT 'urine-fungi', 7.00, NULL -- M097 «Urin- mikološki»
UNION ALL SELECT 'urine-culture', 6.00, NULL -- M098 «Urin-bakteriološki»
UNION ALL SELECT 'direct-microscopic-preparation-vaginal', 7.00, NULL -- M099 «Vaginalni bris - direktni preparat»
UNION ALL SELECT 'trichomonas-test', 5.00, NULL -- M100 «Vaginalni bris (dir.prep)-na Trichomonas vaginalis»
UNION ALL SELECT 'vaginal-swab-culture-anaerobic', 10.00, NULL -- M101 «Vaginalni bris- anaerobno»
UNION ALL SELECT 'vaginal-swab-fungi', 7.00, NULL -- M102 «Vaginalni bris- mikološki»
UNION ALL SELECT 'vaginal-swab-bacteria', 7.00, NULL -- M103 «Vaginalni bris-bakteriološki»
UNION ALL SELECT 'vaginal-swab-microscopy-for-gardnerella-vaginalis', 5.00, NULL -- M104 «VB (dir.prep)- na Gardnerella vag.»
UNION ALL SELECT 'bile-culture-aerobic', 7.00, NULL -- M105 «Žuč- bakteriološki»
UNION ALL SELECT 'antimony-in-blood', 29.00, NULL -- M106 «Antimon (Sb)»
UNION ALL SELECT 'antimony-in-urine', 29.00, NULL -- M107 «Antimon (Sb)-Urine»
UNION ALL SELECT 'barium-in-serum', 62.00, NULL -- M108 «Barijum u serumu»
UNION ALL SELECT 'cadmium-in-blood', 27.00, NULL -- M109 «Kadmijum-Krv»
UNION ALL SELECT 'cadmium-in-24h-urine', 27.00, NULL -- M110 «Kadmijum-Urin»
UNION ALL SELECT 'direct-microscopic-preparation', 6.00, NULL -- M111 «Direktni preparat»
UNION ALL SELECT 'synovial-fluid-direct-microscopic-preparation', 6.00, NULL -- M112 «Direktni preparat-Sinovijska tečnost»
UNION ALL SELECT 'ascaris-lumbricoides-igg', 24.00, NULL -- M117 «Ascaris lumbricoides IgG»
UNION ALL SELECT 'echinococcus-antigen', 28.00, NULL -- M118 «Echinococcus- Ag»
UNION ALL SELECT 'malaria-antibodies', 18.00, NULL -- M119 «Malaria antitela»
UNION ALL SELECT 'toxoplasma-igg', 11.00, NULL -- M120 «TOXO IgG»
UNION ALL SELECT 'toxoplasma-igm', 11.00, NULL -- M121 «TOXO IgM»
) v JOIN lab_tests lt ON lt.slug = v.slug
WHERE @clinic_id IS NOT NULL;

-- ═══ 4. Раздел «Usluge» → услуги ═══
-- «Patronaža centar / periferija / udaljena naselja» 5 / 8 / 10 € — выезд на забор,
-- одна запись каталога field-sampling, поэтому диапазоном 5–10.

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, v.price, NULL, v.price_max, NULL FROM (
      SELECT 'venous-blood-draw' AS slug, 1.00 AS price, NULL AS price_max -- «Uzimanje uzorka» 1.00
UNION ALL SELECT 'iv-cannula-application', 3.00, NULL -- «Braunila» 3.00
UNION ALL SELECT 'field-sampling', 5.00, 10.00 -- «Patronaža centar» 5.00 / «Patronaža periferija» 8.00 / «Patronaža udaljena naselja» 10.00
) v JOIN medical_services ms ON ms.slug = v.slug
WHERE @clinic_id IS NOT NULL;

-- ═══ VERIFICATION ═══
SELECT @clinic_id AS clinic_id;
SELECT COUNT(*) AS lab_rows, SUM(is_price_outdated) AS outdated, SUM(price_max IS NOT NULL) AS ranges
  FROM clinic_lab_tests WHERE clinic_id = @clinic_id;
-- Ожидается: lab_rows 882, outdated 0, ranges 12.
SELECT COUNT(*) AS new_catalog_entries FROM lab_tests WHERE slug IN (
  '11-deoxycorticosterone', '7-dehydrocholesterol', 'acetylsalicylic-acid-ige', 'acetylsalicylic-acid-level', 'acid-fast-bacilli-direct-smear', 'adamts13-gene-analysis', 'adenovirus-pcr', 'amino-acid-profile-in-24h-urine', 'amniotic-fluid-culture', 'amoxicillin-ige', 'ampa1-receptor-antibodies', 'ampa2-receptor-antibodies', 'amylase-isoenzymes', 'anaplasma-phagocytophilum-igg', 'anaplasma-phagocytophilum-igm', 'anti-bp180-antibodies', 'anti-bp230-antibodies', 'anti-desmoglein-1-antibodies', 'anti-desmoglein-3-antibodies', 'anti-epidermal-basement-membrane-antibodies', 'anti-epidermal-intercellular-substance-antibodies', 'anti-histone-antibodies', 'anti-mcv-antibodies', 'anti-mi-2-antibodies', 'anti-n-type-calcium-channel-antibodies', 'anti-p-q-type-calcium-channel-antibodies', 'anti-pla2r-antibodies', 'anti-rnp-70-antibodies', 'anti-yo-antibodies', 'antimony-in-blood', 'antioxidant-capacity-of-lipid-soluble-substances', 'apc-gene-mutations-exon-15-codons-1085-1160', 'apob-gene-mutation-familial-defective-apob-100', 'apolipoprotein-e-genotyping', 'ascaris-lumbricoides-igg', 'aspergillus-total-antibodies', 'atp7b-full-gene-sequencing', 'atp7b-known-familial-mutation-test', 'babesia-igg', 'babesia-igm', 'bacterial-identification-by-maldi-tof-ms', 'bacterial-vaginosis-test', 'barium-in-serum', 'becker-muscular-dystrophy-genetic-test', 'beta-trace-protein', 'biliary-atresia-genetic-test', 'biopsy-material-mycobacterial-culture-lowenstein-jensen', 'borrelia-burgdorferi-igg-in-csf', 'borrelia-burgdorferi-igm-in-csf', 'brca1-full-gene-sequencing', 'brca1-known-familial-mutation-test', 'brca1-partial-sequencing', 'brca2-full-gene-sequencing', 'brca2-known-familial-mutation-test', 'brca2-partial-sequencing', 'bromazepam-level', 'bronchial-aspirate-culture-for-bacteria', 'bronchial-aspirate-culture-for-fungi', 'btnl2-gene-mutations-exons-5-and-6', 'c1-inhibitor-functional', 'candida-antigen', 'candida-iga-antibodies', 'cannabinoids-in-urine-lc-ms', 'carnitine-in-urine', 'caspr2-antibodies', 'cefaclor-ige', 'cefalotin-ige', 'chlamydia-psittaci-iga', 'chlamydia-psittaci-igg', 'chlamydia-psittaci-igm', 'cholestasis-gene-panel-15-genes', 'chromium-in-serum', 'chromium-in-urine', 'chromosomal-aberration-test', 'ck-isoenzymes', 'cladosporium-herbarum-ige-m2', 'clonazepam-level', 'clostridium-difficile-pcr', 'clozapine-level', 'cobalt-in-blood', 'cocaine-in-urine-gc-ms', 'codeine-ige', 'complexed-psa', 'copeptin', 'cotinine-in-serum', 'coxsackie-virus-igg-in-csf', 'cryofibrinogen', 'cryptococcus-neoformans-pcr', 'cyclic-amp-in-plasma', 'cyclic-amp-in-urine', 'cyp27a1-gene-analysis', 'cytomegalovirus-pcr-quantitative', 'dhea', 'dna-kinship-test-additional-person', 'dog-dander-ige-e5', 'doxycycline-ige', 'dsp-gene-mutations-exon-24', 'echinococcus-antigen', 'egfr-gene-mutations-exons-18-21', 'enterovirus-antibodies', 'erythrocyte-porphyrins', 'exocrine-pancreas-antibodies', 'extended-antibiogram-e-test', 'f9-gene-mutations-and-deletions-hemophilia-b', 'facioscapulohumeral-muscular-dystrophy-fshd1-genetic-test', 'fgf-23', 'fgfr2-gene-mutations-exon-7', 'flecainide-level', 'food-intolerance-panel-95-foods', 'food-mix-fx5', 'formic-acid-in-urine', 'free-carnitine-in-serum', 'free-hemoglobin-in-plasma', 'free-protein-s', 'fructose-in-semen', 'gaba-b-receptor-antibodies', 'gallstone-analysis', 'ganglioside-antibodies-igm', 'ganglioside-igg-antibodies', 'gba-gene-mutations-exons-2-9-10-and-11', 'gd1a-antibodies-igg', 'gd1a-antibodies-igm', 'gd1b-antibodies-igg', 'gd1b-antibodies-igm', 'genetic-dna-profile', 'genotoxicity-test', 'gentamicin-ige', 'gldh-glutamate-dehydrogenase', 'glucose-challenge-test-o-sullivan', 'glucose-in-csf', 'gm1-antibodies-total', 'gm2-antibodies-igg', 'gm2-antibodies-igm', 'haloperidol-level', 'hama-human-anti-mouse-antibodies', 'helicobacter-pylori-pcr-in-stool', 'helicobacter-pylori-urea-breath-test', 'hereditary-disease-carrier-screening-400-mutations', 'hereditary-thrombophilia-panel-9-mutations', 'herpes-simplex-virus-1-2-and-varicella-zoster-virus-pcr', 'hfe-known-familial-mutation-test', 'hif1a-gene-mutation-sports-genetics', 'hiv-pcr-rna-qualitative', 'hla-drb1-typing', 'house-dust-mix-hx2', 'hyaluronic-acid', 'ige-antibodies-to-bovine-insulin', 'ige-antibodies-to-porcine-insulin', 'igf-2', 'imatinib-level', 'immunoelectrophoresis-protein-csf', 'indomethacin-ige', 'influenza-a-virus-iga', 'inhalant-allergen-screen-sx1', 'intact-proinsulin', 'interleukin-1-alpha', 'interleukin-10', 'interleukin-8', 'iodine-in-random-urine', 'jag1-gene-mutations-exon-4', 'jc-virus-pcr', 'karyotype-from-abortion-material', 'karyotype-from-amniotic-fluid', 'karyotype-from-amniotic-fluid-twins', 'karyotype-from-bone-marrow', 'karyotype-from-chorionic-villi', 'karyotype-from-cordocentesis-blood', 'keto-acids', 'ketones-in-urine', 'kim-1-in-urine', 'kras-mutations-codons-12-and-13', 'legionella-pneumophila-pcr', 'listeria-monocytogenes-igg', 'lochia-swab-culture-anaerobic', 'lymphocyte-subpopulations', 'malaria-antibodies', 'maternity-test-mother-and-child', 'mc4r-gene-mutations', 'mc4r-known-familial-mutation-test', 'methylmalonic-acid-in-urine', 'mody-3-hnf1a-gene', 'mold-mix-mx2', 'molybdenum-in-blood', 'molybdenum-in-serum', 'molybdenum-in-urine', 'mycobacterium-leprae-pcr', 'mycobacterium-tuberculosis-culture-aspirate', 'mycobacterium-tuberculosis-culture-sputum', 'mycobacterium-tuberculosis-culture-urine', 'mycobacterium-tuberculosis-in-pleural-fluid', 'mycophenolic-acid-level', 'mycoplasma-pneumoniae-pcr', 'myoglobin-in-urine', 'n-acetyl-beta-glucosaminidase-nag', 'n-desmethylclozapine-level', 'neopterin-in-serum', 'nickel-in-blood', 'nras-mutations-codons-12-13-and-61', 'nutrigenetic-lipid-metabolism-panel-9-mutations', 'paliperidone-level', 'pancreatic-elastase-1-in-serum', 'parvovirus-b19-pcr', 'peritoneal-dialysis-catheter-exit-site-swab-culture', 'phenacetin-ige', 'placental-alkaline-phosphatase', 'plasminogen', 'pneumocystis-jirovecii-pcr', 'poliovirus-antibodies', 'potassium-in-erythrocytes', 'procr-gene-haplotype', 'protein-creatinine-ratio', 'protein-in-dialysate', 'quantitative-aspirate-culture', 'risperidone-level', 'rivaroxaban-level', 'rsv-antigen-in-bal', 'salivary-stone-analysis', 'seafood-mix-fx2', 'septin-9-msept9-methylation-test', 'sertraline-level', 'sex-chromosome-aneuploidy-pcr-x-y', 'slc2a1-gene-mutations-glut1-deficiency', 'sodium-in-erythrocytes', 'sotalol-level', 'spinocerebellar-ataxia-type-1-sca1', 'sports-genetics-panel-hif1a-actn3-ace', 'spr-gene-mutations-sepiapterin-reductase-deficiency', 'sulfamethoxazole-ige', 'superoxide-dismutase', 'synovial-fluid-direct-microscopic-preparation', 'targeted-mutation-analysis-on-request-1-sequence', 'tetrachloroethylene-per', 'thymidine-kinase', 'tmprss6-gene-mutations-irida', 'tp53-gene-mutations-exons-5-8', 'treponema-pallidum-igg-western-blot', 'treponema-pallidum-pcr', 'trimethoprim-ige', 'tropheryma-whipplei-pcr', 'trypsin-in-serum', 'urethral-swab-culture-anaerobic', 'urethral-swab-microscopy-for-gardnerella', 'urine-specific-gravity', 'vaginal-swab-microscopy-for-gardnerella-vaginalis', 'varicella-zoster-virus-pcr', 'vgkc-potassium-channel-antibodies', 'yersinia-iga-antibodies', 'yersinia-igm-antibodies', 'zinc-in-semen');
-- Ожидается 249.
SELECT COUNT(*) AS new_without_category FROM lab_tests lt
 WHERE lt.slug IN ('11-deoxycorticosterone', '7-dehydrocholesterol', 'acetylsalicylic-acid-ige', 'acetylsalicylic-acid-level', 'acid-fast-bacilli-direct-smear', 'adamts13-gene-analysis', 'adenovirus-pcr', 'amino-acid-profile-in-24h-urine', 'amniotic-fluid-culture', 'amoxicillin-ige', 'ampa1-receptor-antibodies', 'ampa2-receptor-antibodies', 'amylase-isoenzymes', 'anaplasma-phagocytophilum-igg', 'anaplasma-phagocytophilum-igm', 'anti-bp180-antibodies', 'anti-bp230-antibodies', 'anti-desmoglein-1-antibodies', 'anti-desmoglein-3-antibodies', 'anti-epidermal-basement-membrane-antibodies', 'anti-epidermal-intercellular-substance-antibodies', 'anti-histone-antibodies', 'anti-mcv-antibodies', 'anti-mi-2-antibodies', 'anti-n-type-calcium-channel-antibodies', 'anti-p-q-type-calcium-channel-antibodies', 'anti-pla2r-antibodies', 'anti-rnp-70-antibodies', 'anti-yo-antibodies', 'antimony-in-blood', 'antioxidant-capacity-of-lipid-soluble-substances', 'apc-gene-mutations-exon-15-codons-1085-1160', 'apob-gene-mutation-familial-defective-apob-100', 'apolipoprotein-e-genotyping', 'ascaris-lumbricoides-igg', 'aspergillus-total-antibodies', 'atp7b-full-gene-sequencing', 'atp7b-known-familial-mutation-test', 'babesia-igg', 'babesia-igm', 'bacterial-identification-by-maldi-tof-ms', 'bacterial-vaginosis-test', 'barium-in-serum', 'becker-muscular-dystrophy-genetic-test', 'beta-trace-protein', 'biliary-atresia-genetic-test', 'biopsy-material-mycobacterial-culture-lowenstein-jensen', 'borrelia-burgdorferi-igg-in-csf', 'borrelia-burgdorferi-igm-in-csf', 'brca1-full-gene-sequencing', 'brca1-known-familial-mutation-test', 'brca1-partial-sequencing', 'brca2-full-gene-sequencing', 'brca2-known-familial-mutation-test', 'brca2-partial-sequencing', 'bromazepam-level', 'bronchial-aspirate-culture-for-bacteria', 'bronchial-aspirate-culture-for-fungi', 'btnl2-gene-mutations-exons-5-and-6', 'c1-inhibitor-functional', 'candida-antigen', 'candida-iga-antibodies', 'cannabinoids-in-urine-lc-ms', 'carnitine-in-urine', 'caspr2-antibodies', 'cefaclor-ige', 'cefalotin-ige', 'chlamydia-psittaci-iga', 'chlamydia-psittaci-igg', 'chlamydia-psittaci-igm', 'cholestasis-gene-panel-15-genes', 'chromium-in-serum', 'chromium-in-urine', 'chromosomal-aberration-test', 'ck-isoenzymes', 'cladosporium-herbarum-ige-m2', 'clonazepam-level', 'clostridium-difficile-pcr', 'clozapine-level', 'cobalt-in-blood', 'cocaine-in-urine-gc-ms', 'codeine-ige', 'complexed-psa', 'copeptin', 'cotinine-in-serum', 'coxsackie-virus-igg-in-csf', 'cryofibrinogen', 'cryptococcus-neoformans-pcr', 'cyclic-amp-in-plasma', 'cyclic-amp-in-urine', 'cyp27a1-gene-analysis', 'cytomegalovirus-pcr-quantitative', 'dhea', 'dna-kinship-test-additional-person', 'dog-dander-ige-e5', 'doxycycline-ige', 'dsp-gene-mutations-exon-24', 'echinococcus-antigen', 'egfr-gene-mutations-exons-18-21', 'enterovirus-antibodies', 'erythrocyte-porphyrins', 'exocrine-pancreas-antibodies', 'extended-antibiogram-e-test', 'f9-gene-mutations-and-deletions-hemophilia-b', 'facioscapulohumeral-muscular-dystrophy-fshd1-genetic-test', 'fgf-23', 'fgfr2-gene-mutations-exon-7', 'flecainide-level', 'food-intolerance-panel-95-foods', 'food-mix-fx5', 'formic-acid-in-urine', 'free-carnitine-in-serum', 'free-hemoglobin-in-plasma', 'free-protein-s', 'fructose-in-semen', 'gaba-b-receptor-antibodies', 'gallstone-analysis', 'ganglioside-antibodies-igm', 'ganglioside-igg-antibodies', 'gba-gene-mutations-exons-2-9-10-and-11', 'gd1a-antibodies-igg', 'gd1a-antibodies-igm', 'gd1b-antibodies-igg', 'gd1b-antibodies-igm', 'genetic-dna-profile', 'genotoxicity-test', 'gentamicin-ige', 'gldh-glutamate-dehydrogenase', 'glucose-challenge-test-o-sullivan', 'glucose-in-csf', 'gm1-antibodies-total', 'gm2-antibodies-igg', 'gm2-antibodies-igm', 'haloperidol-level', 'hama-human-anti-mouse-antibodies', 'helicobacter-pylori-pcr-in-stool', 'helicobacter-pylori-urea-breath-test', 'hereditary-disease-carrier-screening-400-mutations', 'hereditary-thrombophilia-panel-9-mutations', 'herpes-simplex-virus-1-2-and-varicella-zoster-virus-pcr', 'hfe-known-familial-mutation-test', 'hif1a-gene-mutation-sports-genetics', 'hiv-pcr-rna-qualitative', 'hla-drb1-typing', 'house-dust-mix-hx2', 'hyaluronic-acid', 'ige-antibodies-to-bovine-insulin', 'ige-antibodies-to-porcine-insulin', 'igf-2', 'imatinib-level', 'immunoelectrophoresis-protein-csf', 'indomethacin-ige', 'influenza-a-virus-iga', 'inhalant-allergen-screen-sx1', 'intact-proinsulin', 'interleukin-1-alpha', 'interleukin-10', 'interleukin-8', 'iodine-in-random-urine', 'jag1-gene-mutations-exon-4', 'jc-virus-pcr', 'karyotype-from-abortion-material', 'karyotype-from-amniotic-fluid', 'karyotype-from-amniotic-fluid-twins', 'karyotype-from-bone-marrow', 'karyotype-from-chorionic-villi', 'karyotype-from-cordocentesis-blood', 'keto-acids', 'ketones-in-urine', 'kim-1-in-urine', 'kras-mutations-codons-12-and-13', 'legionella-pneumophila-pcr', 'listeria-monocytogenes-igg', 'lochia-swab-culture-anaerobic', 'lymphocyte-subpopulations', 'malaria-antibodies', 'maternity-test-mother-and-child', 'mc4r-gene-mutations', 'mc4r-known-familial-mutation-test', 'methylmalonic-acid-in-urine', 'mody-3-hnf1a-gene', 'mold-mix-mx2', 'molybdenum-in-blood', 'molybdenum-in-serum', 'molybdenum-in-urine', 'mycobacterium-leprae-pcr', 'mycobacterium-tuberculosis-culture-aspirate', 'mycobacterium-tuberculosis-culture-sputum', 'mycobacterium-tuberculosis-culture-urine', 'mycobacterium-tuberculosis-in-pleural-fluid', 'mycophenolic-acid-level', 'mycoplasma-pneumoniae-pcr', 'myoglobin-in-urine', 'n-acetyl-beta-glucosaminidase-nag', 'n-desmethylclozapine-level', 'neopterin-in-serum', 'nickel-in-blood', 'nras-mutations-codons-12-13-and-61', 'nutrigenetic-lipid-metabolism-panel-9-mutations', 'paliperidone-level', 'pancreatic-elastase-1-in-serum', 'parvovirus-b19-pcr', 'peritoneal-dialysis-catheter-exit-site-swab-culture', 'phenacetin-ige', 'placental-alkaline-phosphatase', 'plasminogen', 'pneumocystis-jirovecii-pcr', 'poliovirus-antibodies', 'potassium-in-erythrocytes', 'procr-gene-haplotype', 'protein-creatinine-ratio', 'protein-in-dialysate', 'quantitative-aspirate-culture', 'risperidone-level', 'rivaroxaban-level', 'rsv-antigen-in-bal', 'salivary-stone-analysis', 'seafood-mix-fx2', 'septin-9-msept9-methylation-test', 'sertraline-level', 'sex-chromosome-aneuploidy-pcr-x-y', 'slc2a1-gene-mutations-glut1-deficiency', 'sodium-in-erythrocytes', 'sotalol-level', 'spinocerebellar-ataxia-type-1-sca1', 'sports-genetics-panel-hif1a-actn3-ace', 'spr-gene-mutations-sepiapterin-reductase-deficiency', 'sulfamethoxazole-ige', 'superoxide-dismutase', 'synovial-fluid-direct-microscopic-preparation', 'targeted-mutation-analysis-on-request-1-sequence', 'tetrachloroethylene-per', 'thymidine-kinase', 'tmprss6-gene-mutations-irida', 'tp53-gene-mutations-exons-5-8', 'treponema-pallidum-igg-western-blot', 'treponema-pallidum-pcr', 'trimethoprim-ige', 'tropheryma-whipplei-pcr', 'trypsin-in-serum', 'urethral-swab-culture-anaerobic', 'urethral-swab-microscopy-for-gardnerella', 'urine-specific-gravity', 'vaginal-swab-microscopy-for-gardnerella-vaginalis', 'varicella-zoster-virus-pcr', 'vgkc-potassium-channel-antibodies', 'yersinia-iga-antibodies', 'yersinia-igm-antibodies', 'zinc-in-semen')
   AND NOT EXISTS (SELECT 1 FROM lab_test_categories_relations r WHERE r.lab_test_id = lt.id);
-- Ожидается 0.
SELECT e.slug, r.price, r.price_max FROM clinic_medical_services r JOIN medical_services e ON e.id = r.medical_service_id
 WHERE r.clinic_id = @clinic_id AND e.slug IN ('venous-blood-draw', 'iv-cannula-application', 'field-sampling');
-- Ожидается 3 строки.
