# Moj Lab — анализы сети, 2026-10

Источник: https://mojlab.me/laboratorija (снимок `data/clinic-pricelists/sources/moj-lab-laboratorija-podgorica-moskovska/2026-10-02.html`). Цен нет.

SQL: `server/sql/insert-clinic-lab-tests-moj-lab-2026-10.sql` — 453 записей каталога × 9 лабораторий сети, price NULL.

Ниже — то, что в SQL **не** вошло: new 172, unclear 80, not_labtest 10.


## new — в каталоге нет, нужна новая запись lab_tests

| Вкладка / группа | На сайте | Предложенный name_en | Почему |
|---|---|---|---|
| Mikrobiologija /  | Bris kapka na bakterije | Eyelid Swab for Bacteria | Мазка с века нет; eye-swab-* — конъюнктива/глаз, другая локализация |
| Mikrobiologija /  | Bris kapka na gljivice | Eyelid Swab for Fungi | Мазка с века нет; eye-swab-fungi — конъюнктива, другая локализация |
| Mikrobiologija /  | Bris na bakterije (kateter, cista...) | Swab Culture for Bacteria (Catheter, Cyst, Other Material) | Общий мазок с прочего материала (катетер, киста…); в каталоге только узкие записи под конкретные катетеры (CVC, urinary catheter и т.д.) и cyst-punctate-analysis (не посев) |
| Mikrobiologija /  | Bris na gljivice (kateter, cista...) | Swab Culture for Fungi (Catheter, Cyst, Other Material) | Аналог п.9 на грибы; общей записи нет |
| Mikrobiologija /  | Bris nokta na bakterije | Nail Swab for Bacteria | Есть только nail-swab-fungi (грибы), на бактерии — нет |
| Mikrobiologija /  | Bris traheostome na gljivice | Tracheostomy Swab for Fungi | Нет никакого трахеального/трахеостомного мазка на грибы |
| Mikrobiologija /  | Enterovirus (imunohromatografija) | Enterovirus Antigen (Immunochromatography) | Энтеровирусов в каталоге нет вообще |
| Mikrobiologija /  | Adeno respiratorni virus (bris oka) (imunohromatografija) | Adenovirus Antigen Rapid Test (Eye Swab) | Аденовирусного экспресс-теста из мазка глаза нет; есть только из носа и из стула |
| Mikrobiologija /  | RSV (Respiratorni sincicijalni virus) | RSV Antigen Rapid Test | В каталоге по RSV только серология (rsv-igm, rsv-igg); во вкладке Mikrobiologija это антигенный тест |
| Mikrobiologija /  | Imunohromatografski test SARS-CoV-2 +FLU A+ FLU B + RSV | SARS-CoV-2 + Influenza A/B + RSV Antigen Rapid Test | Комбинированного антигенного теста 4-в-1 нет; есть только отдельные COVID и грипп A/B |
| Mikrobiologija /  | Yersinia enterokolitika | Yersinia enterocolitica (Stool) | Yersinia в каталоге нет совсем. Метод не указан; серология Yersinia IgA/IgG blot у Moj Lab в другой вкладке, значит здесь прямое выявление (вероятно, из стула) |
| Biohemija i imunologija / Hematologija i koagulacija | Trombociti na citratu | Platelet Count in Citrated Blood | Подсчёта тромбоцитов в цитратной крови нет; есть platelets и platelet-count-microscopic |
| Biohemija i imunologija / Biohemijske analize | Non HDL holesterol | Non-HDL Cholesterol | Non-HDL холестерина нет |
| Biohemija i imunologija / Biohemijske analize | Indeks ateroskleroze | Atherogenic Index | Индекса атерогенности нет |
| Biohemija i imunologija / Biohemijske analize | Solubilni transferinski receptori (sTfr) | Soluble Transferrin Receptor (sTfR) | sTfR нет (есть только transferrin, transferrin-saturation) |
| Biohemija i imunologija / Biohemijske analize | ACE u likvoru | ACE in CSF | ace — сывороточный; ACE в ликворе — другой материал |
| Biohemija i imunologija / Biohemijske analize | aza (tartarat rezistentna) | Tartrate-Resistant Acid Phosphatase (TRAP) | Вторая половина разорванной позиции «Kisjela fosfataza (tartarat rezistentna)». TRAP в каталоге нет (acid-phosphatase — общая кислая фосфатаза) |
| Biohemija i imunologija / Endokrinološki markeri | Reverzni T3 | Reverse T3 | Reverse T3 нет |
| Biohemija i imunologija / Endokrinološki markeri | Kortizol u pljuvačci | Salivary Cortisol | Кортизола в слюне нет; есть только сыворотка (по часам) и моча |
| Biohemija i imunologija / Endokrinološki markeri | Estron (E1) | Estrone (E1) | Эстрона нет |
| Biohemija i imunologija / Endokrinološki markeri | Androstandiol glukuronid | Androstanediol Glucuronide | Андростандиол глюкуронида нет |
| Biohemija i imunologija / Endokrinološki markeri | 3-metoksitiramin u urinu | 3-Methoxytyramine in Urine | 3-метокситирамина нет (метанефрины есть, это другие метаболиты) |
| Biohemija i imunologija / Endokrinološki markeri | Dopamin | Dopamine | Дофамина отдельно нет (catecholamines-in-plasma — адреналин/норадреналин); материал не указан |
| Biohemija i imunologija / Tumorski markeri | PIVKA | PIVKA-II | PIVKA-II нет |
| Biohemija i imunologija / Metabolizam vitamina | Holotranskobalmin (aktivni vitamin B12) | Holotranscobalamin (Active Vitamin B12) | Есть только vitamin-b12 (общий B12) — это другой анализ |
| Biohemija i imunologija / Metabolizam vitamina | Vitamin B3 | Vitamin B3 (Niacin) | В каталоге нет B3/ниацина |
| Biohemija i imunologija / Metabolizam vitamina | Vitamin B5 | Vitamin B5 (Pantothenic Acid) | В каталоге нет B5/пантотеновой кислоты |
| Biohemija i imunologija / Biohemija urina | D-Pirilinx (piridinolin) | Deoxypyridinoline (DPD) in Urine | D-Pirilinx = Pyrilinks-D, маркер резорбции кости (пиридинолиновые сшивки) в моче; в каталоге ничего похожего нет |
| Biohemija i imunologija / Biohemija urina | Uroporfirin u urinu | Uroporphyrin in Urine | Уропорфирина отдельно нет; есть только суммарные порфирины |
| Biohemija i imunologija / Biohemija urina | Analiza kamena | Urinary Stone Analysis | Анализ состава конкремента — лабораторный анализ; в каталоге нет |
| Biohemija i imunologija / Screening na urina na PAS | Ljekovi i psihoaktivne supstance (3000 metabolita) | Comprehensive Drug and Toxicology Screen (3000 Metabolites) | Широкий скрининг лекарств и ПАВ (3000 метаболитов); в каталоге только панели на 5–10 веществ |
| Biohemija i imunologija / Screening na urina na PAS | Psihoaktivne supstance u kosi | Psychoactive Substances in Hair | ПАВ в волосах; в каталоге только моча и тест-полоски |
| Biohemija i imunologija / Oligoelementi i metali | Bromidi | Bromide | Бромидов в каталоге нет |
| Biohemija i imunologija / Oligoelementi i metali | Fluorid | Fluoride | Фторидов в каталоге нет |
| Biohemija i imunologija / Oligoelementi i metali | Kalaj | Tin | Олова (Sn, kalaj) в каталоге нет |
| Biohemija i imunologija / Oligoelementi i metali | Srebro | Silver | Серебра в каталоге нет |
| Biohemija i imunologija / Oligoelementi i metali | Sumpor | Sulfur | Серы в каталоге нет |
| Biohemija i imunologija / Oligoelementi i metali | Analiza kose (aluminium, antimon, arsen, bakar, barium, berilium, bizmut, bor, kadmium, kalaj, kalcijum, hrom, germanium, gvožđe, jod, kobalt, litium, magnezium, mangan, molibden, nikl, olovo, paladium, platina, selen, srebro, stroncium, talium, titan, uran, vanadium, volfram, cinc, cirkonium, živa) | Hair Mineral Analysis (35 Elements) | Элементный анализ волос, 35 элементов; в каталоге нет |
| Biohemija i imunologija / Monitoring terapije ljekovima | Aripiprazol | Aripiprazole Level | Нет в каталоге |
| Biohemija i imunologija / Monitoring terapije ljekovima | Everolimus | Everolimus Level | Нет в каталоге (есть такролимус, сиролимус, циклоспорин) |
| Biohemija i imunologija / Monitoring terapije ljekovima | Fluconazol (Adizol) | Fluconazole Level | Нет в каталоге |
| Biohemija i imunologija / Monitoring terapije ljekovima | Mitotan | Mitotane Level | Нет в каталоге |
| Biohemija i imunologija / Monitoring terapije ljekovima | Omeprazol | Omeprazole Level | Нет в каталоге |
| Biohemija i imunologija / Monitoring terapije ljekovima | Topiramate (Topamax) | Topiramate Level | Нет в каталоге |
| Biohemija i imunologija / Monitoring terapije ljekovima | Venlafaksin i metaboliti (Velafax) | Venlafaxine and Metabolites Level | Нет в каталоге |
| Biohemija i imunologija / Alergeni/Intolerancija | Intolerancija - 54 namirnice | Food Intolerance Panel 54 Foods | В каталоге есть панели на 90 и 108 продуктов, на 54 нет |
| Biohemija i imunologija / Alergeni/Intolerancija | Intolerancija - 216 namirnica | Food Intolerance Panel 216 Foods | В каталоге есть 90 и 108, на 216 нет |
| Biohemija i imunologija / Alergeni/Intolerancija | ISAC panel (112 alergena) | ImmunoCAP ISAC Allergen Component Panel (112 Components) | Компонентная аллергодиагностика ISAC, 112 компонентов; в каталоге нет (Protia — другие панели) |
| Biohemija i imunologija / Alergeni/Intolerancija | Triptaza | Tryptase | Триптазы в каталоге нет |
| Biohemija i imunologija / Serologija | Bartonella henselae IgM/IgG | Bartonella henselae IgG IgM Panel | Комбинированная позиция IgM+IgG; в каталоге только раздельные записи |
| Biohemija i imunologija / Serologija | Beta-D-Glukan | Beta-D-Glucan | (1→3)-β-D-глюкан не найден; есть только галактоманнан Aspergillus — другой аналит |
| Biohemija i imunologija / Serologija | Chlamydia trachomatis IgA | Chlamydia trachomatis IgA | В каталоге только IgM и IgG |
| Biohemija i imunologija / Serologija | Denga antigen | Dengue NS1 Antigen | Денге в каталоге нет; на сайте просто «antigen» — обычно NS1, проверить |
| Biohemija i imunologija / Serologija | Denga groznica IgG | Dengue Virus IgG |  |
| Biohemija i imunologija / Serologija | Denga groznica IgM | Dengue Virus IgM |  |
| Biohemija i imunologija / Serologija | Difterija antitoksin imunitet | Diphtheria Antitoxin IgG | Антитела к дифтерийному токсину (оценка иммунитета) не найдены |
| Biohemija i imunologija / Serologija | EBV EA IgG | Epstein-Barr EA IgG | Есть EBNA IgG, VCA/общие IgG/IgM и авидность, но не Early Antigen |
| Biohemija i imunologija / Serologija | Francisella tularensis IgG | Francisella tularensis IgG |  |
| Biohemija i imunologija / Serologija | Francisella tularensis IgM | Francisella tularensis IgM | На сайте дублируется позицией 274 «Tularemija IgM» |
| Biohemija i imunologija / Serologija | GQ1B IgG (Quadrosialo gangliozid) | Anti-GQ1b Ganglioside IgG | Антиганглиозидных антител в каталоге нет |
| Biohemija i imunologija / Serologija | GQ1B IgM (Quadrosialo gangliozid) | Anti-GQ1b Ganglioside IgM |  |
| Biohemija i imunologija / Serologija | Haemophilus influenzae tip B IgG | Haemophilus influenzae type b IgG |  |
| Biohemija i imunologija / Serologija | Humani T limfocitni virus I/II (HTLV) IgG | HTLV I/II Antibodies |  |
| Biohemija i imunologija / Serologija | Influenca B IgA | Influenza B Virus IgA | В каталоге только IgM и IgG |
| Biohemija i imunologija / Serologija | Meningococcus IgG | Neisseria meningitidis IgG |  |
| Biohemija i imunologija / Serologija | Nematode IgG (Anisakis, Ascaris, | Nematode IgG Panel (Anisakis, Ascaris, Filaria, Strongyloides, Toxocara, Trichinella) | Начало названия, продолжение в позиции 264; групповой тест — в каталоге только отдельные Toxocara/Strongyloides/Trichinella |
| Biohemija i imunologija / Serologija | Parainfluenca IgA | Parainfluenza Virus IgA |  |
| Biohemija i imunologija / Serologija | Parainfluenca IgG | Parainfluenza Virus IgG |  |
| Biohemija i imunologija / Serologija | Pneumococcus IgG | Streptococcus pneumoniae IgG |  |
| Biohemija i imunologija / Serologija | Poliovirus tip 1 antitijela | Poliovirus Type 1 Antibodies |  |
| Biohemija i imunologija / Serologija | Poliovirus tip 3 antitijela | Poliovirus Type 3 Antibodies |  |
| Biohemija i imunologija / Serologija | Tetanus antitoksin imunitet | Tetanus Antitoxin IgG |  |
| Biohemija i imunologija / Serologija | Toxocara canis-IgG, blot | Toxocara canis IgG Western Blot | В каталоге toxocara-canis-igg — ELISA (по синонимам), blot ≠ ELISA |
| Biohemija i imunologija / Serologija | Treponema pallidum IgM (blot) | Treponema pallidum IgM Western Blot |  |
| Biohemija i imunologija / Serologija | Tularemija IgM | Francisella tularensis IgM | Дубль позиции 245 на сайте (туляремия = F. tularensis); тот же новый анализ |
| Biohemija i imunologija / Serologija | Yersinia IgA, blot | Yersinia IgA Western Blot |  |
| Biohemija i imunologija / Serologija | Yersinia IgG, blot | Yersinia IgG Western Blot |  |
| Biohemija i imunologija / Metabolički skrining | Neonatalni skrining (hipotireoza, galaktozemija, biotinidaza, KAH, poremećaj metabilizma amino i organskih kisjelina) | Newborn Screening Panel | Неонатальный скрининг (гипотиреоз, галактоземия, биотинидаза, ВГКН, амино/органические ацидурии) в каталоге отсутствует |
| Biohemija i imunologija / Metabolički skrining | Masne kisjeline dugih lanaca | Very Long Chain Fatty Acids | В каталоге только NEFA и омега-6/омега-3 — другие анализы |
| Biohemija i imunologija / Metabolički skrining | Aminokisjeline | Amino Acid Profile | Материал на сайте не указан |
| Biohemija i imunologija / Specifični proteini | ENA | ENA Screen | В каталоге только комбинированные ANA ENA профили 15/25 — шире |
| Biohemija i imunologija / Specifični proteini | Anti Sm At | Anti-Sm Antibodies |  |
| Biohemija i imunologija / Specifični proteini | ANCA | ANCA Screen | Общий скрининг ANCA; в каталоге только anti-MPO и anti-PR3 по отдельности |
| Biohemija i imunologija / Specifični proteini | Anti RNP/Sm | Anti-RNP/Sm Antibodies |  |
| Biohemija i imunologija / Specifični proteini | Liver panel (AMA-M2, M2-3E, Sp100, PML, gp210, LKM-1, LC-1,SLA/LP, SS-A native, Ro-52, Scl-70, Centromer A, Centromer B) | Autoimmune Liver Disease Panel (Immunoblot) | Многопараметровая панель; в каталоге отдельные LKM-1, SLA/LP, Scl-70, CENP-B, AMA-M2, но не панель |
| Biohemija i imunologija / Specifični proteini | ANNA 3 antitijela | ANNA-3 Antibodies | В каталоге общая запись neuronal-antibodies — шире |
| Biohemija i imunologija / Specifični proteini | Anti anexin IgG | Anti-Annexin V IgG | в каталоге нет антител к аннексину |
| Biohemija i imunologija / Specifični proteini | Anti ASCA IgM | ASCA IgM | в каталоге только ASCA IgA и IgG |
| Biohemija i imunologija / Specifični proteini | Anti centromerna antitijela | Anti-Centromere Antibodies | в каталоге только Centromere Protein B (более узкая запись); у лаборатории CENP-B отдельной позицией (321) |
| Biohemija i imunologija / Specifični proteini | Anti endomizijalna IgG | Endomysial IgG Antibodies | в каталоге только IgA |
| Biohemija i imunologija / Specifični proteini | Anti fibrilarin-U3RNP antitijela | Anti-Fibrillarin (U3-RNP) Antibodies |  |
| Biohemija i imunologija / Specifični proteini | Anti Hu D antitijela | Anti-Hu (HuD) Antibodies | отдельной записи нет; в каталоге только общий neuronal-antibodies |
| Biohemija i imunologija / Specifični proteini | Anti interferon alfa antitijela | Anti-Interferon Alpha Antibodies |  |
| Biohemija i imunologija / Specifični proteini | Gangliozidni profil (GM1M, GM1G, GD1BM, GD1BG, GQ1BM, GQ1BG, GM2M, GM2G, GM3M, GM3G, GD1AM, GD1AG, GT1BM, GT1BG) | Ganglioside Antibody Profile | профиля антител к ганглиозидам в каталоге нет |
| Biohemija i imunologija / Specifični proteini | Anti NMDA receptor IgA | Anti-NMDA Receptor IgA | в каталоге одна NMDAR-запись (сыворотка) без класса |
| Biohemija i imunologija / Specifični proteini | Anti NMDA receptor IgM | Anti-NMDA Receptor IgM | в каталоге одна NMDAR-запись (сыворотка) без класса |
| Biohemija i imunologija / Specifični proteini | Anti NMDA receptorska antitijela (likvor) | NMDAR Antibodies in CSF | в каталоге NMDAR только в сыворотке; ликвор — другой материал |
| Biohemija i imunologija / Specifični proteini | Anti NOR90 antitijela | Anti-NOR90 Antibodies |  |
| Biohemija i imunologija / Specifični proteini | Anti PM-SCL antitijela | Anti-PM-Scl Antibodies |  |
| Biohemija i imunologija / Specifični proteini | Anti Ri antitijela | Anti-Ri Antibodies | отдельной записи нет; есть только общий neuronal-antibodies |
| Biohemija i imunologija / Specifični proteini | Anti ribozoalni P protein IgG | Anti-Ribosomal P Protein IgG |  |
| Biohemija i imunologija / Specifični proteini | Anti Ro 52 | Anti-Ro52 Antibodies | в каталоге есть Anti-Ro SSA (более общая запись), Ro52 отдельно не заведён |
| Biohemija i imunologija / Specifični proteini | Anti spermatozoidna (ASA) IgA | Antisperm Antibodies ASA IgA | в каталоге одна ASA без класса |
| Biohemija i imunologija / Specifični proteini | Anti spermatozoidna (ASA) IgM | Antisperm Antibodies ASA IgM | в каталоге одна ASA без класса |
| Biohemija i imunologija / Specifični proteini | Beta amiloid | Beta-Amyloid | бета-амилоида в каталоге нет |
| Biohemija i imunologija / Specifični proteini | Hipokretin | Hypocretin (Orexin) |  |
| Biohemija i imunologija / Specifični proteini | Serumski amiloid A | Serum Amyloid A |  |
| Biohemija i imunologija / Specifični proteini | Transferin deficijentan ugljenim hidratima | Carbohydrate-Deficient Transferrin (CDT) | в каталоге только transferrin и transferrin-saturation |
| Biohemija i imunologija / Specifični proteini | Protein 14-3-3 | 14-3-3 Protein |  |
| Biohemija i imunologija / Specifični proteini | Neuralna antitijela panel (Amphiphysin 1, ANNA-III, CRMP5, CV-2, Ri antigen, Yo, Hu D antigen, Ma2 (Ta), PCA-2, Tr) u likvoru | Neural Antibodies Panel in CSF | та же панель в ликворе; в каталоге neuronal-antibodies без указания материала |
| Patohistologija /  | Pregled tumora dojke | Histopathology Breast Tumor Examination | В каталоге только «PH Pregled odstranjene dojke»; Moj Lab перечисляет её отдельно (батч 4), значит «tumor dojke» — другая позиция |
| Patohistologija /  | Pregled uterusa sa adneksama | Histopathology Uterus with Adnexa Examination | С придатками — больший объём материала, чем «Pregled uterusa»; Moj Lab даёт обе позиции |
| Molekularna dijagnostika / Molekularna dijagnostika | Influenca A, B, C | Influenza A, B, C PCR | В каталоге только грипп A+B PCR; здесь ещё и тип C — шире |
| Molekularna dijagnostika / Molekularna dijagnostika | Chlamydia pneumoniae DNK | Chlamydia pneumoniae PCR | Есть только комбинированная панель Mycoplasma + Chlamydia pneumoniae; одиночного ПЦР на C. pneumoniae нет |
| Molekularna dijagnostika / Molekularna dijagnostika | Cytomegalo virus | Cytomegalovirus PCR | Во вкладке молекулярной диагностики — ПЦР ЦМВ; в каталоге только серология и антиген (ИФ) |
| Molekularna dijagnostika / Molekularna dijagnostika | EBV DNK | Epstein-Barr Virus PCR | ПЦР ВЭБ в каталоге нет, только серология |
| Molekularna dijagnostika / Molekularna dijagnostika | Hepatitis B PCR kvalitativno | HBV PCR DNA Qualitative | В каталоге HBV только количественный и комбинированный HIV/HCV/HBV качественный |
| Molekularna dijagnostika / Molekularna dijagnostika | Leishmania DNK | Leishmania PCR | ПЦР на лейшманию нет, только серология и микроскопия |
| Molekularna dijagnostika / Molekularna dijagnostika | Malarija DNK | Malaria PCR | В каталоге малярия только микроскопией |
| Molekularna dijagnostika / Molekularna dijagnostika | M. tuberculosis DNK | Mycobacterium tuberculosis PCR | tb-test — тест иммунного ответа по крови (по справке), не ДНК возбудителя |
| Molekularna dijagnostika / Molekularna dijagnostika | Parotitis epidemica RNK | Mumps Virus RNA PCR | ПЦР на паротит нет, только серология |
| Molekularna dijagnostika / Molekularna dijagnostika | Toxoplasma gondii DNK | Toxoplasma gondii PCR | ПЦР на токсоплазму нет, только серология и окрашенный препарат |
| Molekularna dijagnostika / Genetski testovi | Mutacija gena PAI-1 844 | PAI-1 Locus 844 | Другой полиморфизм PAI-1 (844), а не 4G/5G |
| Molekularna dijagnostika / Genetski testovi | Thrombofilija mutacije panel: | Thrombophilia 3 Genes 4 Loci | Состав по сайту: FII G20210A, FV Leiden, MTHFR A1298C, MTHFR C677T (3 гена, 4 локуса). В каталоге 3/3, 3/5, 4/6, 8 SNP — по числу локусов ни один не совпадает; состав thrombophilia-folate-panel неизвестен |
| Molekularna dijagnostika / Genetski testovi | Anemija srpastih ćelija | Sickle Cell Anemia Genetic Test | Генетического теста на серповидноклеточную анемию нет |
| Molekularna dijagnostika / Genetski testovi | Cistična fibroza cijeli gen | Cystic Fibrosis Full CFTR Gene Analysis | Весь ген CFTR шире панели 34 мутаций |
| Molekularna dijagnostika / Genetski testovi | Cistična fibroza del508 | Cystic Fibrosis F508del Mutation | Одна мутация del508 уже панели 34 мутаций |
| Molekularna dijagnostika / Genetski testovi | CYP2C9 | CYP2C9 Genotyping | Одиночный ген CYP2C9; pharmacogenomic-test — общий тест |
| Molekularna dijagnostika / Genetski testovi | HLA tipizacija jednog alela | HLA Typing Single Allele | Типирование одного аллеля HLA на выбор; конкретные HLA-B27/B5701 уже |
| Molekularna dijagnostika / Genetski testovi | HLA-A (Klasa 1) | HLA-A Typing (Class I) | Типирования локуса HLA-A нет |
| Molekularna dijagnostika / Genetski testovi | HLA-B (Klasa 1) | HLA-B Typing (Class I) | Типирование локуса HLA-B шире, чем B27/B5701 |
| Molekularna dijagnostika / Genetski testovi | HLA-Cw (Klasa 1) | HLA-C Typing (Class I) | Типирования локуса HLA-C нет |
| Molekularna dijagnostika / Genetski testovi | JAK2-egzon12 mutacija | JAK2 Exon 12 Mutation | JAK2 в каталоге нет |
| Molekularna dijagnostika / Genetski testovi | JAK2-V617F mutacija | JAK2 V617F Mutation | JAK2 в каталоге нет |
| Molekularna dijagnostika / Genetski testovi | Marfanov sindrom | Marfan Syndrome Genetic Test | Нет |
| Molekularna dijagnostika / Genetski testovi | Mediteranska porodična groznica | Familial Mediterranean Fever Genetic Test | Нет |
| Molekularna dijagnostika / Genetski testovi | PMP22-MLPA test | PMP22 MLPA Test | Нет |
| Molekularna dijagnostika / Genetski testovi | A-thalassemia (skrining na nasledne bolesti) | Alpha-Thalassemia Carrier Screening | Альфа-талассемии в каталоге нет |
| Molekularna dijagnostika / Genetski testovi | Sveobuhvatni panel nasljednih bolesti - jedan partner (skrining na nasledne bolesti) | Comprehensive Carrier Screening Panel (One Partner) | Расширенный скрининг носительства, один партнёр |
| Molekularna dijagnostika / Genetski testovi | Sveobuhvatni panel nasljednih bolesti - oba partnera (skrining na nasledne bolesti) | Comprehensive Carrier Screening Panel (Both Partners) | Расширенный скрининг носительства, пара |
| Molekularna dijagnostika / Genetski testovi | Panel prema vodičima za jednu osobu (skrining na nasledne bolesti) | Guidelines-Based Carrier Screening Panel (One Person) | Скрининг носительства по рекомендациям, один человек |
| Molekularna dijagnostika / Genetski testovi | Panel prema vodičima za dvije osobe (skrining na nasledne bolesti) | Guidelines-Based Carrier Screening Panel (Two Persons) | Скрининг носительства по рекомендациям, двое |
| Molekularna dijagnostika / Genetski testovi | Dojka/Ginekološki panel (genetika karcinoma) | Hereditary Breast and Gynecologic Cancer Panel | Панель наследственного рака груди/гинекологии; Sentis Hereditary Cancer — другой продукт, объём неизвестен |
| Molekularna dijagnostika / Genetski testovi | Dojka/Ginekološki panel prema vodičima (genetika karcinoma) | Hereditary Breast and Gynecologic Cancer Panel (Guidelines-Based) | Вариант «по рекомендациям» |
| Molekularna dijagnostika / Genetski testovi | Dojka/Ginekološki panel visok rizik (genetika karcinoma) | Hereditary Breast and Gynecologic Cancer Panel (High Risk) | Вариант «высокий риск» |
| Molekularna dijagnostika / Genetski testovi | Kolorektalni karcinom panel (genetika karcinoma) | Hereditary Colorectal Cancer Panel | Нет |
| Molekularna dijagnostika / Genetski testovi | Kolorektalni karcinom panel viskok rizik (genetika karcinoma) | Hereditary Colorectal Cancer Panel (High Risk) | Нет |
| Molekularna dijagnostika / Genetski testovi | Nalijedni nepolipozni kolorektalni karcinom (genetika karcinoma) | Hereditary Non-Polyposis Colorectal Cancer Panel | Нет |
| Molekularna dijagnostika / Genetski testovi | Nalijedni polipozni kolorektalni karcinom (genetika karcinoma) | Hereditary Polyposis Colorectal Cancer Panel | Нет |
| Molekularna dijagnostika / Genetski testovi | Mijelodisplastični sindrom/Leukemija panel (genetika karcinoma) | Myelodysplastic Syndrome/Leukemia Panel | Нет; BCR-ABL — одиночная мишень |
| Molekularna dijagnostika / Genetski testovi | Želudac panel (genetika karcinoma) | Hereditary Gastric Cancer Panel | Нет |
| Molekularna dijagnostika / Genetski testovi | Prostata panel (genetika karcinoma) | Hereditary Prostate Cancer Panel | Нет |
| Molekularna dijagnostika / Genetski testovi | Pankreas panel (genetika karcinoma) | Hereditary Pancreatic Cancer Panel | Нет |
| Molekularna dijagnostika / Genetski testovi | Renalni panel (genetika karcinoma) | Hereditary Renal Cancer Panel | Рак почки, а не наследственные болезни почек |
| Molekularna dijagnostika / Genetski testovi | Koža panel (genetika karcinoma) | Hereditary Skin Cancer Panel | Нет |
| Molekularna dijagnostika / Genetski testovi | Familijarni melanom panel (genetika karcinoma) | Familial Melanoma Panel | Нет |
| Molekularna dijagnostika / Genetski testovi | Paragangliom/feohromacitom panel (genetika karcinoma) | Hereditary Paraganglioma/Pheochromocytoma Panel | Нет |
| Molekularna dijagnostika / Genetski testovi | Paratireoidni panel (genetika karcinoma) | Hereditary Parathyroid Cancer Panel | Нет |
| Molekularna dijagnostika / Genetski testovi | Tireoidini panel (genetika karcinoma) | Hereditary Thyroid Cancer Panel | Нет |
| Molekularna dijagnostika / Genetski testovi | Pan karcer panel (genetika karcinoma) | Pan-Cancer Hereditary Panel | Общая онкопанель; в каталоге есть только чужие брендовые продукты (Sentis, HerediGEN 33) с неизвестным объёмом |
| Molekularna dijagnostika / Prenatalni testovi | Veracity Basic | NIPT Veracity Basic | Продукта Veracity в каталоге нет; есть только Panorama, Silver и общий NIPT |
| Molekularna dijagnostika / Prenatalni testovi | Veracity Plus | NIPT Veracity Plus | Продукта Veracity в каталоге нет |
| Molekularna dijagnostika / Prenatalni testovi | Veracity Premium | NIPT Veracity Premium | Продукта Veracity в каталоге нет |
| Molekularna dijagnostika / Prenatalni testovi | Veragene | Veragene | Продукта Veragene в каталоге нет |
| Molekularna dijagnostika / Prenatalni testovi | Sequentia Basic | NIPT Sequentia Basic | Продукта Sequentia в каталоге нет |
| Molekularna dijagnostika / Prenatalni testovi | Sequentia Plus | NIPT Sequentia Plus | Продукта Sequentia в каталоге нет |
| Molekularna dijagnostika / Prenatalni testovi | Sequentia Plus Expert | NIPT Sequentia Plus Expert | Продукта Sequentia в каталоге нет |
| Molekularna dijagnostika / Prenatalni testovi | Sequentia Premium | NIPT Sequentia Premium | Продукта Sequentia в каталоге нет |
| Molekularna dijagnostika / Prenatalni testovi | Sequentia Safe Kario Plus | NIPT Sequentia Safe Karyo Plus | Продукта Sequentia в каталоге нет; на сайте, видимо, дубль 518 с опечаткой Kario/Karyo |
| Molekularna dijagnostika / Prenatalni testovi | Sequentia PremiumGene | NIPT Sequentia PremiumGene | Продукта Sequentia в каталоге нет |
| Molekularna dijagnostika / Prenatalni testovi | Sequentia Safe Karyo Plus | NIPT Sequentia Safe Karyo Plus | Продукта Sequentia в каталоге нет; дубль 516 |
| Molekularna dijagnostika / Prenatalni testovi | Sequentia Safe Full Karyo Plus | NIPT Sequentia Safe Full Karyo Plus | Продукта Sequentia в каталоге нет |

## unclear — нужен человек

| Вкладка / группа | На сайте | Кандидаты | Почему |
|---|---|---|---|
| Mikrobiologija /  | Bris čmara na bakterije | rectal-swab-bacteria, perianal-swab | «Čmar» = анус; в каталоге есть ректальный и перианальный мазок, какой из них соответствует — не ясно; perianal-swab без указания цели |
| Mikrobiologija /  | Bris čmara na gljivice | rectal-swab-fungi, perianal-swab-fungi | Анальный мазок на грибы: ректальный или перианальный — по названию не определить |
| Mikrobiologija /  | Bris na Trichomonas vaginalis | trichomonas-test, trichomonas-rapid-test, trichomonas-vaginalis-iht | Метод не указан, а в каталоге методы разнесены (нативная микроскопия / IHT / rapid / PCR). Скорее trichomonas-test (нативный препарат): у Moj Lab IHT-тесты везде подписаны «(imunohromatografija)», но это вывод |
| Mikrobiologija /  | Bris traheostome na bakterije | tracheoflex-swab-culture-aerobic | Мазка с трахеостомы нет; ближайшее — мазок трахеальной канюли (Tracheoflex). Стома и канюля — одна локализация или нет, решать вручную; иначе new «Tracheostomy Swab for Bacteria» |
| Mikrobiologija /  | Chlamydia trachomatis DIF metoda | chlamydia-genital-swab, microbial-antigen-detection-by-direct-immunofluorescence | DIF-записи для хламидии нет; chlamydia-genital-swab — метод не указан; microbial-antigen-detection-by-direct-immunofluorescence — общая запись метода (шире). Методы для хламидии в каталоге разнесены (IHT/PCR/ELISA/culture), так что скорее new «Chlamydia trachomatis (Direct Immunofluorescence)» |
| Mikrobiologija /  | Clostridium difficile Toxin A/B (imunohromatografija) | clostridium-difficile-toxin-ab, clostridium-difficile-toxin-a-and-b | IHT-записи нет. У clostridium-difficile-toxin-a-and-b в синонимах явно ELISA/ELFA (другой метод); clostridium-difficile-toxin-ab — метод не указан, возможно дубль первой |
| Mikrobiologija /  | Koprokultura (Salmonela spp, Shigela spp, E. coli O157, Campylobacter spp) | stool-culture, stool-culture-salmonella-shigella-ecoli | stool-culture-salmonella-shigella-ecoli без Campylobacter (уже); stool-culture — «Koprokultura» без состава. Скорее stool-culture, но состав не подтверждён |
| Mikrobiologija /  | Stolica na helminte | stool-parasites | В синонимах stool-parasites есть «Mikroskopski pregled stolice na helminte», но у Moj Lab отдельно есть «Stolica na parazite» (точное совпадение с той же записью). Одна запись или две (гельминты уже, чем паразиты) — решать вручную |
| Mikrobiologija /  | Strugotina kože | skin-scraping-fungi, dermatophytes-skin-scraping, native-mycological-skin | Цель и метод не указаны (культура на грибы / на дерматофиты / нативная микроскопия) |
| Mikrobiologija /  | Strugotina nokta | nail-scraping-fungi, dermatophytes-nail-scraping, native-mycological-nail | Цель и метод не указаны (культура / дерматофиты / нативная микроскопия) |
| Mikrobiologija /  | TBC (imunohromatografija) | tb-test, quantiferon | tb-test «TBC (tuberkuloza) test» без метода — может быть тем же экспресс-тестом, но подтвердить нечем; quantiferon — другой метод (IGRA) |
| Mikrobiologija /  | Campylobacter spp | campylobacter-iht, campylobacter-culture | Метод не указан; Campylobacter также входит в состав копрокультуры (п.30), так что отдельная позиция может быть и IHT, и культурой |
| Mikrobiologija /  | Vaginalni stepen | vaginal-secretion-group, vaginal-discharge-dmp, vaginal-microscopic-preparation | «Vaginalni stepen» — видимо, степень чистоты влагалищного секрета; в каталоге «Grupa vaginalnih sekreta» и дубль «Vaginalni sekret - grupa (DMP)». Название на сайте обрезано, подтвердить нельзя |
| Biohemija i imunologija / Biohemijske analize | Kreatinin (GFR) | creatinine, egfr-glomerular-filtration-rate | Креатинин с расчётом GFR; в каталоге креатинин и eGFR — отдельные записи |
| Biohemija i imunologija / Biohemijske analize | Kisjela fosfat | acid-phosphatase | Обломок: на сайте одна позиция разорвана на два <p> — «Kisjela fosfat» + «aza (tartarat rezistentna)» (п.83), вместе это тартрат-резистентная кислая фосфатаза (new, см. п.83). Отдельной позицией «кислая фосфатаза» это, скорее всего, не является |
| Biohemija i imunologija / Biohemijske analize | LDH Izoenzimi Omega3/6 index u eritrocitima | omega-6-omega-3-fatty-acids | На сайте две позиции слиплись в один <p>: «LDH Izoenzimi» (в каталоге нет, new «LDH Isoenzymes») и «Omega3/6 index u eritrocitima» (кандидат omega-6-omega-3-fatty-acids, но материал «в эритроцитах» в каталоге не указан) |
| Biohemija i imunologija / Endokrinološki markeri | Estriol (E3) | free-estriol | В каталоге только «Slobodni (неконъюгированный) estriol»; у Moj Lab просто «Estriol (E3)» — свободный или общий, не указано |
| Biohemija i imunologija / Endokrinološki markeri | Homovanilična kisjelina (HVA) | homovanillic-acid-in-urine, homovanillic-acid | Материал не указан; в каталоге две записи — без материала и «u urinu» |
| Biohemija i imunologija / Endokrinološki markeri | VMA (24h sa konzervansom) | vma-in-urine, vma | У Moj Lab 24-часовая моча с консервантом; в каталоге «VMA u urinu» без указания 24h и «VMA» без материала. Скорее vma-in-urine, но 24h-записи нет |
| Biohemija i imunologija / Endokrinološki markeri | Kateholamini u urinu | catecholamines-in-24h-urine | У Moj Lab «u urinu» без 24h, в каталоге только 24h-моча; совпадение вероятно, но по названию материал не подтверждается |
| Biohemija i imunologija / Metabolizam vitamina | Vitamin K | vitamin-k1-level | В каталоге только Vitamin K1; на сайте просто «Vitamin K» — не сказано, K1 это или сумма форм |
| Biohemija i imunologija / Biohemija urina | Fizičko-hemijski pregled urina | complete-urinalysis | Физико-химический осмотр мочи; в каталоге только полный анализ с микроскопией осадка. Отдельного осадка (sediment) у Moj Lab нет, так что это может быть их полный анализ мочи, а может быть только тест-полоска без осадка |
| Biohemija i imunologija / Biohemija urina | Urin - Natrijum | sodium-in-24h-urine | В каталоге только натрий в суточной моче, разовой мочи нет; у Moj Lab 24h не указано. Если это разовая моча, то new «Sodium in Urine» |
| Biohemija i imunologija / Biohemija urina | Urin - Kalijum | potassium-in-24h-urine | В каталоге только калий в суточной моче; у Moj Lab 24h не указано. Если это разовая моча, то new «Potassium in Urine» |
| Biohemija i imunologija / Biohemija urina | Citrati u urinu | citrate-in-24h-urine | В каталоге только цитрат в суточной моче; у Moj Lab просто «u urinu», 24h не указано |
| Biohemija i imunologija / Biohemija urina | Oksalati u urinu | oxalate-in-24h-urine | В каталоге только оксалат в суточной моче; у Moj Lab просто «u urinu», 24h не указано |
| Biohemija i imunologija / Biohemija urina | Porfirin | porphyrins-in-urine, urinary-porphyrins-qualitative | Порфирины в моче (группа «Biohemija urina»); в каталоге две записи, количественная и качественная, метод у Moj Lab не указан |
| Biohemija i imunologija / Biohemija urina | Koproporfirin u urinu | coproporphyrins | В каталоге «Coproporphyrins» без материала; у Moj Lab — в моче. Если запись каталога про мочу, то match |
| Biohemija i imunologija / Screening na urina na PAS | Panel 10 (kokain, amfetamin, metamfetamin, kanabinoidi, metadon, extazi, barbiturati, benzodiazempin, TCA) | drug-panel-10, drug-panel-10-ii, psychoactive-substances-panel-10-parameters | В каталоге три равноценные записи «панель 10», состава ни у одной нет (похоже на дубли). У Moj Lab в скобках перечислено 9 веществ |
| Biohemija i imunologija / Oligoelementi i metali | Arsen | arsenic-in-serum, arsenic-in-urine | Материал не указан (серум/кровь или урин); в каталоге записи разделены по материалу. Группа «Oligoelementi i metali» стоит отдельно от «Biohemija urina», так что скорее кровь/серум, но на сайте не сказано. |
| Biohemija i imunologija / Oligoelementi i metali | Bakar | copper-in-serum, copper-in-24h-urine, copper-in-single-urine-sample | Материал не указан (серум/кровь или урин); в каталоге записи разделены по материалу. Группа «Oligoelementi i metali» стоит отдельно от «Biohemija urina», так что скорее кровь/серум, но на сайте не сказано. |
| Biohemija i imunologija / Oligoelementi i metali | Cink | zinc-in-serum, zinc-in-24h-urine | Материал не указан (серум/кровь или урин); в каталоге записи разделены по материалу. Группа «Oligoelementi i metali» стоит отдельно от «Biohemija urina», так что скорее кровь/серум, но на сайте не сказано. |
| Biohemija i imunologija / Oligoelementi i metali | Hrom | chromium-in-blood | В каталоге только хром в крови; материал у Moj Lab не указан. Если кровь, то match |
| Biohemija i imunologija / Oligoelementi i metali | Jod | iodine-in-serum, iodine-in-24h-urine | Материал не указан (серум/кровь или урин); в каталоге записи разделены по материалу. Группа «Oligoelementi i metali» стоит отдельно от «Biohemija urina», так что скорее кровь/серум, но на сайте не сказано. |
| Biohemija i imunologija / Oligoelementi i metali | Kobalt | cobalt-in-serum, cobalt-in-urine | Материал не указан (серум/кровь или урин); в каталоге записи разделены по материалу. Группа «Oligoelementi i metali» стоит отдельно от «Biohemija urina», так что скорее кровь/серум, но на сайте не сказано. |
| Biohemija i imunologija / Oligoelementi i metali | Mangan | manganese-in-blood, manganese-in-urine | Материал не указан (серум/кровь или урин); в каталоге записи разделены по материалу. Группа «Oligoelementi i metali» стоит отдельно от «Biohemija urina», так что скорее кровь/серум, но на сайте не сказано. |
| Biohemija i imunologija / Oligoelementi i metali | Nikl | nickel-in-serum, nickel-in-urine | Материал не указан (серум/кровь или урин); в каталоге записи разделены по материалу. Группа «Oligoelementi i metali» стоит отдельно от «Biohemija urina», так что скорее кровь/серум, но на сайте не сказано. |
| Biohemija i imunologija / Oligoelementi i metali | Olovo | lead-in-blood, lead-in-24h-urine | Материал не указан (серум/кровь или урин); в каталоге записи разделены по материалу. Группа «Oligoelementi i metali» стоит отдельно от «Biohemija urina», так что скорее кровь/серум, но на сайте не сказано. |
| Biohemija i imunologija / Oligoelementi i metali | Živa | mercury-in-blood, mercury-in-urine, mercury-in-24h-urine | Материал не указан (серум/кровь или урин); в каталоге записи разделены по материалу. Группа «Oligoelementi i metali» стоит отдельно от «Biohemija urina», так что скорее кровь/серум, но на сайте не сказано. |
| Biohemija i imunologija / Alergeni/Intolerancija | Nutritivni panel 20 alergena | allergies-20-allergens | В каталоге «Allergies 20 Allergens» без указания типа (пищевые/ингаляционные); пищевой панели на 20 отдельной записью нет |
| Biohemija i imunologija / Alergeni/Intolerancija | Inhalatorni panel 20 alergena | allergies-20-allergens | В каталоге «Allergies 20 Allergens» без указания типа; ингаляционной панели на 20 отдельной записью нет |
| Biohemija i imunologija / Alergeni/Intolerancija | Alergen (pojedinačno) | allergies | Один специфический IgE на выбор. В каталоге есть общая «Allergies» без описания и много конкретных «X IgE»; общей записи «один аллерген» нет. Возможно, это new «Specific IgE (Single Allergen)» |
| Biohemija i imunologija / Alergeni/Intolerancija | Diamino oksidaza (DAO) | diamine-oxidase, diamine-oxidase-dao-histamine | В каталоге две записи DAO, похоже на дубли; у второй синоним «DAO» и приписка «histamin» |
| Biohemija i imunologija / Serologija | Anti Treponema pallidum At | tpha-treponema-pallidum, tpha-test-for-syphilis | «Anti T. pallidum At» — суммарные трепонемные антитела без указания метода; в каталоге только TPHA (гемагглютинация), отдельной записи для ИФА/CLIA суммарных антител нет |
| Biohemija i imunologija / Serologija | Bordetella pertussis tokson IgG | bordetella-pertussis-igg | На сайте явно антитела к коклюшному токсину (anti-PT IgG); в каталоге Bordetella pertussis IgG без указания антигена — возможно та же, возможно более общая |
| Biohemija i imunologija / Serologija | Candida albicans IgM | candida-igm-antibodies | На сайте Candida albicans IgM, в каталоге Candida IgM без вида — скорее всего тот же серологический тест, но запись формально общая |
| Biohemija i imunologija / Serologija | Coxiella burnetii IgG | coxiella-burnetii-igg-phase-1-elisa, coxiella-burnetii-igg-phase-2-elisa | Фаза не указана; в каталоге IgG разнесён на фазу 1 и фазу 2 |
| Biohemija i imunologija / Serologija | Coxiella burnetii IgM | coxiella-burnetii-igm-phase-2-elisa | Фаза не указана; в каталоге есть только IgM фаза 2 (более узкая запись) |
| Biohemija i imunologija / Serologija | Enterovirus IgM (Coxsackie A/B, Echo, enterovirusi 68-71) | coxsackie-virus-igm, coxsackie-b-igm | Групповой тест на энтеровирусы (Coxsackie A/B, ECHO, EV 68-71) шире записей Coxsackie; если coxsackie-virus-igm на деле групповой энтеровирусный ИФА — match, иначе new «Enterovirus IgM» |
| Biohemija i imunologija / Serologija | Enterovirus IgG (Coxsackie A/B, Echo, enterovirusi 68-71) | coxsackie-virus-igg, coxsackie-b-igg | Аналогично 242: групповой энтеровирусный IgG шире записей Coxsackie; иначе new «Enterovirus IgG» |
| Biohemija i imunologija / Serologija | Herpes tip 6 IgG | hhv-6 | В каталоге HHV-6 без класса антител (и отдельно PCR); если hhv-6 — IgG, то match, иначе new «Human Herpesvirus 6 IgG» |
| Biohemija i imunologija / Serologija | Herpes tip 6 IgM | hhv-6 | Как 254; иначе new «Human Herpesvirus 6 IgM» |
| Biohemija i imunologija / Serologija | Leishmania antitijela srining | leishmania-igg-igm, leishmania-donovani-igg-elisa, leishmania-donovani-antibodies-indirect-hemagglutination | «Antitijela skrining» без класса и метода; несколько кандидатов |
| Biohemija i imunologija / Serologija | Filaria, Strongyloides, Toxocara, Trichinella) |  | Не отдельный анализ: хвост названия позиции 263 (перенос строки на сайте); объединить с 263 |
| Biohemija i imunologija / Serologija | Toxocara canis-IgM, blot | toxocara-canis-igm-antibodies | На сайте blot; в каталоге IgM без метода. Если считать, что метод не разнесён — match, иначе new «Toxocara canis IgM Western Blot» |
| Biohemija i imunologija / Specifični proteini | Anti aquaporin IgG | aquaporin-4-antibodies, aquaporin-antibodies | в каталоге две записи на антитела к аквапорину (по сути дубль); класс IgG ни в одной не указан |
| Biohemija i imunologija / Specifični proteini | Anti C1q esteraza inhibitor | anti-c1q-antibodies, c1-inhibitor, c1-inactivator | в названии смешаны «Anti C1q» и «C1 esteraza inhibitor»: это либо антитела к C1q, либо C1-ингибитор (c1-inhibitor и c1-inactivator в каталоге похожи на дубль) |
| Biohemija i imunologija / Specifični proteini | Anti GAD (glitamat dekarboksilaza) antitijela | anti-gad-antibodies, gad-antibodies | аналит тот же, но в каталоге две записи-дубля |
| Biohemija i imunologija / Specifični proteini | Anti NMDA receptor IgG | nmdar-antibodies-in-serum | в каталоге NMDAR в сыворотке без класса, а лаборатория делит на IgA/IgG/IgM; ближе всего IgG, но в каталоге класс не указан |
| Biohemija i imunologija / Specifični proteini | Anti spermatozoidna (ASA) IgG | spermatozoa-antibodies-asa | в каталоге ASA без класса, а лаборатория делит на IgA/IgG/IgM |
| Biohemija i imunologija / Specifični proteini | C1q esteraza, koncentracija | c1-inhibitor, c1-inactivator | «C1q esteraza, koncentracija» — скорее концентрация ингибитора C1-эстеразы, но в названии стоит «C1q»; c1-inhibitor и c1-inactivator в каталоге похожи на дубль |
| Biohemija i imunologija / Specifični proteini | Imunofiksacija proteina seruma | immunoelectrophoresis-protein-serum | иммунофиксация и иммуноэлектрофорез — разные методы; записи именно про иммунофиксацию нет |
| Biohemija i imunologija / Specifični proteini | Imunofiksacija proteina urina | immunoelectrophoresis-protein-urine | иммунофиксация и иммуноэлектрофорез — разные методы; записи именно про иммунофиксацию нет |
| Biohemija i imunologija / Specifični proteini | Slobodni kapa/lambda lanci u serumu | kappa-light-chain, lambda-light-chain, kappa-lambda-light-chain-index | у лаборатории одна позиция «κ/λ в сыворотке»; в каталоге κ, λ и индекс заведены раздельно |
| Biohemija i imunologija / Specifični proteini | Slobodni kapa/lambda lanci u urinu | free-kappa-light-chains-in-urine, free-lambda-light-chains-in-urine | у лаборатории одна позиция «κ/λ в моче»; в каталоге κ и λ раздельно |
| Biohemija i imunologija / Specifični proteini | Neuronalna antitijela osnovni panel (Hu, Ri, Yo, Ma-2, CV-2, Amfifizin1) Neuralna antitijela panel (Amphiphysin 1, ANNA-III, CV-2, Ri antigen, Yo, Hu Dantigen, Ma2 (Ta), PCA-2, Tr ) u serumu | neuronal-antibodies | панель нейрональных антител в сыворотке; в каталоге одна общая neuronal-antibodies без состава и материала |
| Patohistologija /  | Endoskopska biopsija 1 uzorak (jednjak, želudac, duodenum, tanko i debelo crijevo) | histopathology-endoscopic-biopsy | патогистология; по сути то же, что 387, но у лаборатории это две отдельные позиции, а в каталоге запись одна |
| Patohistologija /  | Komplet receptori za dojku | her2-estrogen-progesterone-receptors | иммуногистохимия на ткани; состав «комплекта» на сайте не указан (входит ли Ki67), в каталоге HER2+ER+PR |
| Patohistologija /  | Pregled LOOP ekscizije | leep-cervical-conization, histopathology-conization-specimen | патогистология LOOP-препарата; leep-cervical-conization по синонимам похожа на саму процедуру, а не на исследование |
| Patohistologija /  | Pregled tumora mokraćne bešike | histopathology-tur-bladder | Есть только «PH TUR mokraćne bešike»; TUR — один из способов получить материал, тот ли это объём исследования, по названию не понять |
| Molekularna dijagnostika / Molekularna dijagnostika | STD panel (Mycoplasma hominis, Neisseria gonorrhoeae, Trichomonas vaginalis, Ureaplasma urealyticum, Ureaplasma parvum, Chlamydia trachomatis | std-multiplex-6, std-panel-7-pcr | Перечислено 6 возбудителей (без M. genitalium), но скобка не закрыта — список на сайте, возможно, обрезан. std-multiplex-6 в каталоге задан числом патогенов («любые 6»), состав не фиксирован; если патогенов ровно 6, это match на std-multiplex-6 |
| Molekularna dijagnostika / Molekularna dijagnostika | Borrelia burgdorferi DNK u krpelju | borrelia-burgdorferi-pcr | Материал — клещ, а не образец пациента; у записи каталога материал не указан, совпадает ли — не понять |
| Molekularna dijagnostika / Molekularna dijagnostika | Candida DNK | candida-albicans-pcr | Candida DNK (род) против C. albicans PCR (вид) — возможно, шире |
| Molekularna dijagnostika / Molekularna dijagnostika | Hepatitis C virus RNK | hcv-pcr-rna-quantitative, hcv-pcr-rna-qualitative | Качественный/количественный не указан; качественный у Moj Lab отдельной строкой (439), поэтому скорее количественный, но это догадка |
| Molekularna dijagnostika / Molekularna dijagnostika | Hepatitis E virus RNK | hev | HEV RNA (ПЦР); в каталоге только «hev» без метода и анти-HEV IgM/IgG ELISA. Если hev — серология, то new («HEV RNA PCR») |
| Molekularna dijagnostika / Genetski testovi | Hemohromatoza | hemochromatosis-pcr-c282y | Какие мутации HFE исследуются, не указано; в каталоге только C282Y |
| Molekularna dijagnostika / Genetski testovi | HLA DQ | hla-dq2-dq8-typing, hla-dq-2-8 | «HLA DQ» без уточнения; вероятно DQ2/DQ8, но не указано. Кроме того, в каталоге два дубля DQ2/DQ8 |
| Molekularna dijagnostika / Genetski testovi | Spinalna mišićna distrofija (genetika) | sma-smn1-gene-copy-number, sma-smn1-and-smn2-copy-number | «Spinalna mišićna distrofija» — вероятно, имеется в виду спинальная мышечная атрофия (SMA), но название другое; и SMN1 или SMN1+SMN2 — не указано |
| Molekularna dijagnostika / Genetski testovi | B hemoglobinopatije (skrining na nasledne bolesti) | beta-thalassemia-pcr | Бета-гемоглобинопатии шире бета-талассемии; что покрывает запись каталога, не указано |
| Molekularna dijagnostika / Genetski testovi | Cistična fibroza (skrining na nasledne bolesti) | cystic-fibrosis-34-mutations | Скрининг носительства CF — объём (сколько мутаций/секвенирование) не указан; в каталоге панель 34 мутаций (синоним CF Screening) |

## not_labtest — не анализ в смысле каталога

| На сайте | Что это | Ближайшее в каталоге |
|---|---|---|
| Biopsija grlića materice i frakciona kiretaža ukupno tri uzorka | патогистология: биопсия шейки матки + фракционная кюретаж, 3 образца; точной записи нет | histopathology-cervical-biopsy-and-curettage, histopathology-fractional-curettage-two-samples |
| Biopsija tumora kože | патогистология опухоли кожи (первый образец); точной записи нет, есть только общая «стандартная биопсия кожи и других органов» | histopathology-standard-skin-and-organ-biopsy |
| Endoskopska biopsija (svaki sledeći uzorak) | патогистология: каждый следующий образец эндоскопической биопсии; такой записи нет | histopathology-endoscopic-biopsy |
| Ex tempore biopsija | интраоперационная срочная гистология (ex tempore); в каталоге нет |  |
| Ph tumora kože | патогистология опухоли кожи; судя по названию, то же, что 379; точной записи нет | histopathology-standard-skin-and-organ-biopsy |
| Pregled jajnika | патогистология операционного материала (яичник); в каталоге нет |  |
| Pregled nefrektomije | патогистология операционного материала (нефрэктомия); точной записи нет, есть общая «радикальные операции» | histopathology-radical-surgery |
| Pregled odstranjenog mioma | патогистология удалённой миомы; в каталоге нет (есть только «Pregled uterusa») | histopathology-uterus-examination |
| Pregled prostaktetomije | патогистология операционного материала (простатэктомия); точной записи нет, есть общая «радикальные операции» | histopathology-radical-surgery |
| Genetski testovi za različite poremećaje dostupni na upit (neurološki, epliepsije, migrene, kardiovaskularni, vezivnog tkiva, rasta i razvoja, endokrinološki, ORL, oftalmološki itd) | Не анализ, а объявление: генетические тесты на прочие болезни по запросу | clinical-exome-sequencing |

## Вероятные дубли в каталоге lab_tests (найдены попутно, не правились)

- mumps-igm / mumps-virus-igm; mumps-igg / mumps-virus-igg
- beta-2-glycoprotein-i-* / beta-2-glycoprotein-1-*
- anti-hbc-total-elisa / anti-hbc-antibody-test; anti-hbe-elisa / anti-hbe-antibody-test; hbsab / anti-hbs-antibody-test
- anti-gad-antibodies / gad-antibodies; aquaporin-4-antibodies / aquaporin-antibodies; c1-inhibitor / c1-inactivator
- polyp-biopsy-cervical / histopathology-cervical-polyp-examination
- drug-panel-10 / drug-panel-10-ii / psychoactive-substances-panel-10-parameters
- diamine-oxidase / diamine-oxidase-dao-histamine; triple-test / triple-test-second-trimester-screening; hiv-ag-ab / hiv-1-plus-2-ag-ab
- factor-ii / prothrombin-ii-locus-20210-pcr; factor-v / factor-v-leiden-locus-1691 (factor-v — это мутация Leiden, не фактор свёртывания)
- hla-dq-2-8 / hla-dq2-dq8-typing; y-chromosome-microdeletion / azf-y-chromosome-deletions / y-chromosome-microdeletion-11
- cervical-swab-bacteria / bacteriological-examination-cervical-swab; cervical-swab-fungi / fungal-examination-cervical-swab
- influenza-a-plus-b-iht / influenza-ab-rapid-test; sperm-culture-fungi / seminal-fluid-fungal-test
- clostridium-difficile-toxin-a-and-b / clostridium-difficile-toxin-ab; vaginal-secretion-group / vaginal-discharge-dmp
- protein-in-urine / protein-in-random-urine
- histopathology-skin-tumor-additional-samples-15 — «15» в slug похоже на прилипшую цену

## Огрехи источника

- «Kisjela fosfat» + «aza (tartarat rezistentna)» — одна позиция, разорвана на два абзаца.
- «LDH Izoenzimi Omega3/6 index u eritrocitima» — две позиции в одной строке.
- «Nematode IgG» разбита на две строки; «Sequentia Safe Kario Plus» / «Karyo Plus» — один продукт дважды.
- Металлы и часть анализов мочи — без указания материала (кровь/серум, разовая/суточная моча).

## Решения 2026-10-02 (юзер утвердил правила A–F)

- unclear + not_labtest (90) разобраны: 65 строк → 64 существующие записи — `server/sql/insert-clinic-lab-tests-moj-lab-rules-2026-10.sql`; 26 → новые записи; 4 отброшены.
- Металлы без материала — как кровь/сыворотка (юзер: «выглядит ок»).
- Дубли каталога — `server/sql/migrations/050-labtest-dedup-moj-lab.sql`: слито 18, 10 пар оставлены раздельно (одна клиника держит обе записи с разными кодами/ценами, список в шапке миграции).
- Новые записи: 172 + 26 = 198, заводятся отложенно (квота).

### Привязки по правилам

| Правило | На сайте | → lab_tests |
|---|---|---|
| D | Bris čmara na bakterije | rectal-swab-bacteria |
| D | Bris čmara na gljivice | rectal-swab-fungi |
| D | Bris na Trichomonas vaginalis | trichomonas-test |
| D | Bris traheostome na bakterije | tracheoflex-swab-culture-aerobic |
| B | Clostridium difficile Toxin A/B (imunohromatografija) | clostridium-difficile-toxin-a-and-b |
| D | Koprokultura (Salmonela spp, Shigela spp, E. coli O157, Campylobacter spp) | stool-culture |
| D | Stolica na helminte | stool-parasites |
| D | Strugotina kože | skin-scraping-fungi |
| D | Strugotina nokta | nail-scraping-fungi |
| D | TBC (imunohromatografija) | tb-test |
| D | Campylobacter spp | campylobacter-culture |
| B | Vaginalni stepen | vaginal-discharge-dmp |
| C | Kreatinin (GFR) | creatinine |
| C | Kreatinin (GFR) | egfr-glomerular-filtration-rate |
| E | LDH Izoenzimi Omega3/6 index u eritrocitima | omega-6-omega-3-fatty-acids |
| D | Estriol (E3) | free-estriol |
| A | Homovanilična kisjelina (HVA) | homovanillic-acid-in-urine |
| A | VMA (24h sa konzervansom) | vma-in-urine |
| A | Kateholamini u urinu | catecholamines-in-24h-urine |
| D | Vitamin K | vitamin-k1-level |
| D | Fizičko-hemijski pregled urina | complete-urinalysis |
| A | Urin - Natrijum | sodium-in-24h-urine |
| A | Urin - Kalijum | potassium-in-24h-urine |
| A | Citrati u urinu | citrate-in-24h-urine |
| A | Oksalati u urinu | oxalate-in-24h-urine |
| A | Porfirin | porphyrins-in-urine |
| A | Koproporfirin u urinu | coproporphyrins |
| D | Panel 10 (kokain, amfetamin, metamfetamin, kanabinoidi, metadon, extazi, barbiturati, benzodiazempin, TCA) | drug-panel-10 |
| A | Arsen | arsenic-in-serum |
| A | Bakar | copper-in-serum |
| A | Cink | zinc-in-serum |
| A | Hrom | chromium-in-blood |
| A | Jod | iodine-in-serum |
| A | Kobalt | cobalt-in-serum |
| A | Mangan | manganese-in-blood |
| A | Nikl | nickel-in-serum |
| A | Olovo | lead-in-blood |
| A | Živa | mercury-in-blood |
| D | Nutritivni panel 20 alergena | allergies-20-allergens |
| D | Inhalatorni panel 20 alergena | allergies-20-allergens |
| D | Alergen (pojedinačno) | allergies |
| D | Diamino oksidaza (DAO) | diamine-oxidase |
| D | Bordetella pertussis tokson IgG | bordetella-pertussis-igg |
| D | Candida albicans IgM | candida-igm-antibodies |
| D | Leishmania antitijela srining | leishmania-igg-igm |
| D | Toxocara canis-IgM, blot | toxocara-canis-igm-antibodies |
| D | Anti aquaporin IgG | aquaporin-4-antibodies |
| D | Anti C1q esteraza inhibitor | c1-inactivator |
| B | Anti GAD (glitamat dekarboksilaza) antitijela | anti-gad-antibodies |
| D | Anti NMDA receptor IgG | nmdar-antibodies-in-serum |
| D | Anti spermatozoidna (ASA) IgG | spermatozoa-antibodies-asa |
| D | C1q esteraza, koncentracija | c1-inhibitor |
| C | Slobodni kapa/lambda lanci u serumu | kappa-light-chain |
| C | Slobodni kapa/lambda lanci u serumu | lambda-light-chain |
| C | Slobodni kapa/lambda lanci u serumu | kappa-lambda-light-chain-index |
| C | Slobodni kapa/lambda lanci u urinu | free-kappa-light-chains-in-urine |
| C | Slobodni kapa/lambda lanci u urinu | free-lambda-light-chains-in-urine |
| D | Neuronalna antitijela osnovni panel (Hu, Ri, Yo, Ma-2, CV-2, Amfifizin1) Neuralna antitijela panel (Amphiphysin 1, ANNA-III, CV-2, Ri antigen, Yo, Hu Dantigen, Ma2 (Ta), PCA-2, Tr ) u serumu | neuronal-antibodies |
| C | Endoskopska biopsija 1 uzorak (jednjak, želudac, duodenum, tanko i debelo crijevo) | histopathology-endoscopic-biopsy |
| D | Komplet receptori za dojku | her2-estrogen-progesterone-receptors |
| D | Pregled LOOP ekscizije | histopathology-conization-specimen |
| D | Pregled tumora mokraćne bešike | histopathology-tur-bladder |
| F | STD panel (Mycoplasma hominis, Neisseria gonorrhoeae, Trichomonas vaginalis, Ureaplasma urealyticum, Ureaplasma parvum, Chlamydia trachomatis | std-multiplex-6 |
| D | Hepatitis C virus RNK | hcv-pcr-rna-quantitative |
| B | HLA DQ | hla-dq2-dq8-typing |

### Стали новыми по правилам

| Правило | На сайте | name_en | Примечание |
|---|---|---|---|
| D | Chlamydia trachomatis DIF metoda | Chlamydia trachomatis DIF | прямая иммунофлуоресценция; записи с DIF нет |
| E | LDH Izoenzimi Omega3/6 index u eritrocitima | LDH Isoenzymes | из слипшейся строки «LDH Izoenzimi Omega3/6 index u eritrocitima» |
| D | Anti Treponema pallidum At | Treponema pallidum Total Antibodies | суммарные трепонемные антитела, не TPHA |
| D | Coxiella burnetii IgG | Coxiella burnetii IgG | фаза не указана |
| D | Coxiella burnetii IgM | Coxiella burnetii IgM | фаза не указана |
| D | Enterovirus IgM (Coxsackie A/B, Echo, enterovirusi 68-71) | Enterovirus IgM | групповой: Coxsackie A/B, ECHO, EV 68–71 |
| D | Enterovirus IgG (Coxsackie A/B, Echo, enterovirusi 68-71) | Enterovirus IgG | групповой: Coxsackie A/B, ECHO, EV 68–71 |
| D | Herpes tip 6 IgG | Human Herpesvirus 6 IgG |  |
| D | Herpes tip 6 IgM | Human Herpesvirus 6 IgM |  |
| D | Imunofiksacija proteina seruma | Serum Protein Immunofixation | иммунофиксация ≠ иммуноэлектрофорез |
| D | Imunofiksacija proteina urina | Urine Protein Immunofixation | иммунофиксация ≠ иммуноэлектрофорез |
| PH | Biopsija grlića materice i frakciona kiretaža ukupno tri uzorka | Histopathology Cervical Biopsy and Fractional Curettage (3 samples) |  |
| PH | Biopsija tumora kože | Histopathology Skin Tumor | вместе с 403 «Ph tumora kože»; сначала сверить с medical_services histopathology-of-skin-tumor и lab_tests histopathology-skin-tumor-additional-samples-15 |
| C | Endoskopska biopsija (svaki sledeći uzorak) | Histopathology Endoscopic Biopsy (each additional sample) |  |
| PH | Ex tempore biopsija | Ex Tempore Intraoperative Histopathology |  |
| PH | Pregled jajnika | Histopathology Ovary Examination |  |
| PH | Pregled nefrektomije | Histopathology Nephrectomy Specimen |  |
| PH | Pregled odstranjenog mioma | Histopathology Uterine Myoma Specimen |  |
| PH | Pregled prostaktetomije | Histopathology Prostatectomy Specimen |  |
| D | Borrelia burgdorferi DNK u krpelju | Borrelia burgdorferi DNA in Tick | материал — клещ |
| D | Candida DNK | Candida DNA PCR | род, не только C. albicans |
| D | Hepatitis E virus RNK | Hepatitis E Virus RNA PCR |  |
| F | Hemohromatoza | Hemochromatosis HFE Genetic Test | объём мутаций не указан; в каталоге только C282Y |
| F | Spinalna mišićna distrofija (genetika) | Spinal Muscular Atrophy Genetic Test | на сайте «Spinalna mišićna distrofija» |
| F | B hemoglobinopatije (skrining na nasledne bolesti) | Beta Hemoglobinopathies Carrier Screening |  |
| F | Cistična fibroza (skrining na nasledne bolesti) | Cystic Fibrosis Carrier Screening | объём не указан; в каталоге панель 34 мутаций |

### Отброшены

- обломок «Kisjela fosfat» — та же позиция, что 83 (TRAP, уже в new)
- хвост названия 263 «Nematode IgG» (перенос строки на сайте)
- то же, что 379 «Biopsija tumora kože»
- объявление «генетические тесты по запросу», не анализ

### Открыто

- `histopathology-skin-tumor-additional-samples-15` (In Vitro, 30 €): «по 15» в названии похоже на цену следующих образцов. Нужен прайс In Vitro, чтобы понять, первый это образец или следующие; до тех пор Moj Lab 380 «svaki sledeći uzorak» привязан к нему как есть.
- «Pregled tumora kože» заведён услугой `histopathology-of-skin-tumor` (KCCG), а не анализом — пересечение каталогов. Перед заведением новых «PH …» сверять и с medical_services.

## Новые записи каталога — 2026-10-04

SQL: `server/sql/insert-lab-tests-new-moj-lab-2026-10.sql` — применён локально и в проде 2026-10-04 (сверено API: каталог 1712, у 9 лабораторий по 703 анализа и 7 услуг).

- 139 новых записей lab_tests (переводы — 5 агентов, кириллица — `scripts/common/sr-cyrl-names.mjs` + латиница для обозначений аналитов/генов, NIPT-продукты целиком латиницей);
- 46 записей общие с неприменённым импортом Tesla Medical — строки и категории скопированы оттуда, порядок применения не важен;
- 3 записи общие с импортами КЦЦГ (dopamine) и Poliklinika Diagnostica (non-hdl-cholesterol, nail-swab-for-bacteria);
- 1 существующая запись (anti-sm-antibodies), пропущенная на шаге сопоставления;
- 7 позиций патогистологии привязаны к услугам КЦЦГ (clinic_medical_services), а не заведены анализами-двойниками: histopathology-of-breast-tumor, histopathology-of-uterus-with-bilateral-adnexa, histopathology-of-skin-tumor, frozen-section-histopathology-ex-tempore, histopathology-of-nephrectomy, histopathology-of-myoma, histopathology-of-total-prostatectomy;
- в неприменённых импортах Codra и Tesla `triple-test` (слит миграцией 050) заменён на `triple-test-second-trimester-screening`, иначе их строки при применении тихо терялись.

| slug | name_en | name_sr | name_ru |
|---|---|---|---|
| eyelid-swab-bacteria | Eyelid Swab for Bacteria | Bris kapka na bakterije | Мазок с века на бактерии |
| eyelid-swab-fungi | Eyelid Swab for Fungi | Bris kapka na gljivice | Мазок с века на грибы |
| swab-bacteria-catheter-cyst-other | Swab for Bacteria (Catheter, Cyst, Other Material) | Bris na bakterije (kateter, cista i dr.) | Мазок на бактерии (катетер, киста и др.) |
| swab-fungi-catheter-cyst-other | Swab for Fungi (Catheter, Cyst, Other Material) | Bris na gljivice (kateter, cista i dr.) | Мазок на грибы (катетер, киста и др.) |
| tracheostomy-swab-fungi | Tracheostomy Swab for Fungi | Bris traheostome na gljivice | Мазок из трахеостомы на грибы |
| enterovirus-antigen-rapid-test | Enterovirus Antigen Rapid Test | Enterovirus antigen – brzi test (imunohromatografija) | Энтеровирус – экспресс-тест на антиген (иммунохроматография) |
| adenovirus-respiratory-test-eye-swab | Adenovirus Respiratory Test (Eye Swab) | Adenovirus respiratorni test (bris oka) | Тест на аденовирус (мазок из глаза) |
| rsv-antigen-rapid-test | RSV Antigen Rapid Test | RSV antigen – brzi test (respiratorni sincicijalni virus) | Экспресс-тест на антиген RSV (респираторно-синцитиальный вирус) |
| sars-cov-2-influenza-ab-rsv-antigen-rapid-test | SARS-CoV-2, Influenza A/B and RSV Antigen Rapid Test | Imunohromatografski test SARS-CoV-2 + influenca A + influenca B + RSV | Экспресс-тест на антигены SARS-CoV-2, гриппа A/B и RSV |
| yersinia-enterocolitica-detection | Yersinia enterocolitica Detection | Yersinia enterocolitica | Выявление Yersinia enterocolitica |
| platelets-in-citrated-blood | Platelets in Citrated Blood | Trombociti na citratu | Тромбоциты в цитратной крови |
| atherogenic-index | Atherogenic Index | Indeks ateroskleroze | Индекс атерогенности |
| ace-in-csf | ACE in CSF | Angiotenzin konvertujući enzim u likvoru | Ангиотензинпревращающий фермент в ликворе |
| tartrate-resistant-acid-phosphatase | Tartrate-Resistant Acid Phosphatase | Tartarat-rezistentna kisela fosfataza | Тартрат-резистентная кислая фосфатаза |
| cortisol-in-saliva | Cortisol in Saliva | Kortizol u pljuvački | Кортизол в слюне |
| androstanediol-glucuronide | Androstanediol Glucuronide | Androstandiol glukuronid | Андростандиол глюкуронид |
| 3-methoxytyramine-in-urine | 3-Methoxytyramine in Urine | 3-metoksitiramin u urinu | 3-метокситирамин в моче |
| pivka-ii | PIVKA-II | PIVKA-II | PIVKA-II |
| vitamin-b3 | Vitamin B3 | Vitamin B3 | Витамин B3 |
| vitamin-b5 | Vitamin B5 | Vitamin B5 | Витамин B5 |
| uroporphyrin-in-urine | Uroporphyrin in Urine | Uroporfirin u urinu | Уропорфирин в моче |
| drug-and-psychoactive-substance-screen-3000-metabolites | Drug and Psychoactive Substance Screen (3000 Metabolites) | Ljekovi i psihoaktivne supstance (3000 metabolita) | Скрининг лекарств и психоактивных веществ (3000 метаболитов) |
| psychoactive-substances-in-hair | Psychoactive Substances in Hair | Psihoaktivne supstance u kosi | Психоактивные вещества в волосах |
| bromide | Bromide | Bromidi | Бромиды |
| fluoride | Fluoride | Fluorid | Фторид |
| tin | Tin | Kalaj | Олово |
| silver | Silver | Srebro | Серебро |
| sulfur | Sulfur | Sumpor | Сера |
| hair-mineral-analysis-35-elements | Hair Mineral Analysis (35 Elements) | Analiza kose (35 elemenata) | Элементный анализ волос (35 элементов) |
| aripiprazole-level | Aripiprazole Level | Nivo aripiprazola | Уровень арипипразола |
| fluconazole-level | Fluconazole Level | Nivo flukonazola | Уровень флуконазола |
| mitotane-level | Mitotane Level | Nivo mitotana | Уровень митотана |
| omeprazole-level | Omeprazole Level | Nivo omeprazola | Уровень омепразола |
| venlafaxine-and-metabolites-level | Venlafaxine and Metabolites Level | Nivo venlafaksina i metabolita | Уровень венлафаксина и метаболитов |
| food-intolerance-panel-54-foods | Food Intolerance Panel 54 Foods | Intolerancija na hranu 54 namirnice | Панель пищевой непереносимости (54 продукта) |
| food-intolerance-panel-216-foods | Food Intolerance Panel 216 Foods | Intolerancija na hranu 216 namirnica | Панель пищевой непереносимости (216 продуктов) |
| isac-allergen-component-panel-112-allergens | ISAC Allergen Component Panel (112 Allergens) | ISAC panel (112 alergena) | Компонентная аллергодиагностика ISAC (112 аллергенов) |
| bartonella-henselae-igg-igm-panel | Bartonella henselae IgG IgM Panel | Bartonella henselae IgG + IgM | Bartonella henselae IgG + IgM |
| beta-d-glucan | Beta-D-Glucan | Beta-D-glukan | Бета-D-глюкан |
| chlamydia-trachomatis-iga | Chlamydia trachomatis IgA | Chlamydia trachomatis IgA | Chlamydia trachomatis IgA |
| dengue-virus-antigen | Dengue Virus Antigen | Denga antigen | Антиген вируса денге |
| dengue-virus-igg | Dengue Virus IgG | Denga groznica IgG | Лихорадка денге IgG |
| dengue-virus-igm | Dengue Virus IgM | Denga groznica IgM | Лихорадка денге IgM |
| diphtheria-antitoxin-antibodies | Diphtheria Antitoxin Antibodies | Difterija antitoksin imunitet | Антитела к дифтерийному анатоксину (иммунитет) |
| epstein-barr-ea-igg | Epstein-Barr EA IgG | Epstein-Barr EA IgG | Эпштейн-Барр EA IgG (ранний антиген) |
| neisseria-meningitidis-igg | Neisseria meningitidis IgG | Meningococcus IgG | Менингококк (Neisseria meningitidis) IgG |
| nematode-igg-panel-anisakis-ascaris-filaria-strongyloides-toxocara-trichinella | Nematode IgG Panel (Anisakis, Ascaris, Filaria, Strongyloides, Toxocara, Trichinella) | Nematode IgG (Anisakis, Ascaris, Filaria, Strongyloides, Toxocara, Trichinella) | Нематоды IgG (Anisakis, Ascaris, Filaria, Strongyloides, Toxocara, Trichinella) |
| poliovirus-type-1-antibodies | Poliovirus Type 1 Antibodies | Poliovirus tip 1 antitijela | Антитела к полиовирусу 1 типа |
| poliovirus-type-3-antibodies | Poliovirus Type 3 Antibodies | Poliovirus tip 3 antitijela | Антитела к полиовирусу 3 типа |
| toxocara-canis-igg-western-blot | Toxocara canis IgG Western Blot | Toxocara canis IgG Western Blot | Антитела к Toxocara canis IgG (вестерн-блот) |
| yersinia-iga-western-blot | Yersinia IgA Western Blot | Yersinia IgA Western Blot | Антитела к Yersinia IgA (вестерн-блот) |
| yersinia-igg-western-blot | Yersinia IgG Western Blot | Yersinia IgG Western Blot | Антитела к Yersinia IgG (вестерн-блот) |
| newborn-screening-panel | Newborn Screening Panel | Neonatalni skrining (hipotireoza, galaktozemija, biotinidaza, KAH, poremećaj metabolizma amino i organskih kiselina) | Неонатальный скрининг (гипотиреоз, галактоземия, биотинидаза, ВГКН, нарушения обмена амино- и органических кислот) |
| liver-autoantibody-panel-13-antigens | Liver Autoantibody Panel 13 Antigens | Panel autoantitijela jetre (AMA-M2, M2-3E, Sp100, PML, gp210, LKM-1, LC-1, SLA/LP, SS-A native, Ro-52, Scl-70, Centromer A, Centromer B) | Панель аутоантител при аутоиммунных заболеваниях печени (AMA-M2, M2-3E, Sp100, PML, gp210, LKM-1, LC-1, SLA/LP, SS-A native, Ro-52, Scl-70, CENP-A, CENP-B) |
| anna-3-antibodies | ANNA-3 Antibodies | ANNA-3 antitijela | Антитела ANNA-3 |
| anti-annexin-igg-antibodies | Anti-Annexin IgG Antibodies | Anti-aneksin IgG antitijela | Антитела к аннексину IgG |
| asca-igm | ASCA IgM | ASCA IgM | ASCA IgM |
| anti-centromere-antibodies | Anti-Centromere Antibodies | Anti-centromerna antitijela | Антицентромерные антитела |
| endomysial-igg-antibodies | Endomysial IgG Antibodies | Endomizijalna IgG antitijela | Эндомизиальные IgG антитела |
| anti-fibrillarin-u3-rnp-antibodies | Anti-Fibrillarin (U3-RNP) Antibodies | Anti-fibrilarin (U3-RNP) antitijela | Антитела к фибрилларину (U3-RNP) |
| anti-interferon-alpha-antibodies | Anti-Interferon Alpha Antibodies | Antitijela na interferon alfa | Антитела к интерферону альфа |
| ganglioside-antibody-profile | Ganglioside Antibody Profile | Gangliozidni profil (GM1, GM2, GM3, GD1a, GD1b, GQ1b, GT1b IgM i IgG) | Профиль антител к ганглиозидам (GM1, GM2, GM3, GD1a, GD1b, GQ1b, GT1b IgM и IgG) |
| nmdar-iga-antibodies | NMDAR IgA Antibodies | NMDAR IgA antitijela | Антитела к NMDA-рецепторам IgA |
| nmdar-igm-antibodies | NMDAR IgM Antibodies | NMDAR IgM antitijela | Антитела к NMDA-рецепторам IgM |
| anti-nor90-antibodies | Anti-NOR90 Antibodies | Anti-NOR90 antitijela | Анти-NOR90 антитела |
| anti-pm-scl-antibodies | Anti-PM-Scl Antibodies | Anti-PM-Scl antitijela | Анти-PM-Scl антитела |
| anti-ri-antibodies | Anti-Ri Antibodies | Anti-Ri antitijela | Антитела к Ri |
| anti-ro52-antibodies | Anti-Ro52 Antibodies | Anti-Ro52 antitijela | Антитела к Ro52 |
| spermatozoa-antibodies-asa-iga | Spermatozoa Antibodies ASA IgA | Antitijela na spermatozoide ASA IgA | Антитела к сперматозоидам ASA IgA |
| spermatozoa-antibodies-asa-igm | Spermatozoa Antibodies ASA IgM | Antitijela na spermatozoide ASA IgM | Антитела к сперматозоидам ASA IgM |
| hypocretin-orexin | Hypocretin (Orexin) | Hipokretin (oreksin) | Гипокретин (орексин) |
| carbohydrate-deficient-transferrin | Carbohydrate-Deficient Transferrin | Transferin deficijentan ugljenim hidratima | Углевододефицитный трансферрин (CDT) |
| 14-3-3-protein | 14-3-3 Protein | Protein 14-3-3 | Белок 14-3-3 |
| neuronal-antibodies-panel-in-csf | Neuronal Antibodies Panel in CSF | Panel neuralnih antitijela u likvoru (Amphiphysin 1, ANNA-III, CRMP5, CV-2, Ri, Yo, Hu D, Ma2 (Ta), PCA-2, Tr) | Панель нейрональных антител в ликворе (Amphiphysin 1, ANNA-3, CRMP5, CV-2, Ri, Yo, HuD, Ma2 (Ta), PCA-2, Tr) |
| influenza-a-b-c-pcr | Influenza A, B, C PCR | Influenca A, B, C PCR | Грипп A, B, C ПЦР |
| chlamydia-pneumoniae-pcr | Chlamydia pneumoniae PCR | Chlamydia pneumoniae PCR | Chlamydia pneumoniae ПЦР |
| leishmania-pcr | Leishmania PCR | Leishmania PCR | Leishmania ПЦР |
| malaria-pcr | Malaria PCR | Malarija PCR | Малярия ПЦР (Plasmodium) |
| mumps-virus-pcr | Mumps Virus PCR | Virus zaušnjaka RNK PCR | Вирус эпидемического паротита РНК ПЦР |
| pai-1-locus-844 | PAI-1 Locus 844 | PAI-1 lokus 844 | PAI-1 локус 844 |
| thrombophilia-3-genes-4-loci | Thrombophilia 3 Genes 4 Loci | Trombofilija 3 gena 4 lokusa | Тромбофилия 3 гена 4 локуса |
| cystic-fibrosis-cftr-full-gene-analysis | Cystic Fibrosis CFTR Full Gene Analysis | Cistična fibroza – cijeli CFTR gen | Муковисцидоз – весь ген CFTR |
| cystic-fibrosis-f508del-mutation | Cystic Fibrosis F508del Mutation | Cistična fibroza – mutacija F508del | Муковисцидоз – мутация F508del |
| cyp2c9-genotyping | CYP2C9 Genotyping | CYP2C9 genotipizacija | Генотипирование CYP2C9 |
| hla-single-allele-typing | HLA Single Allele Typing | HLA tipizacija jednog alela | HLA-типирование одного аллеля |
| jak2-exon-12-mutation | JAK2 Exon 12 Mutation | JAK2 egzon 12 mutacija | Мутации гена JAK2 (экзон 12) |
| marfan-syndrome-genetic-test | Marfan Syndrome Genetic Test | Marfanov sindrom – genetski test | Синдром Марфана – генетический тест |
| familial-mediterranean-fever-genetic-test | Familial Mediterranean Fever Genetic Test | Mediteranska porodična groznica – genetski test | Семейная средиземноморская лихорадка – генетический тест |
| pmp22-mlpa-test | PMP22 MLPA Test | PMP22 MLPA test | PMP22 – MLPA-тест |
| alpha-thalassemia-carrier-screening | Alpha-Thalassemia Carrier Screening | Alfa-talasemija (skrining na nasljedne bolesti) | Альфа-талассемия (скрининг носительства) |
| comprehensive-carrier-screening-panel-one-partner | Comprehensive Carrier Screening Panel (One Partner) | Sveobuhvatni panel nasljednih bolesti – jedan partner | Расширенная панель скрининга носительства наследственных заболеваний – один партнёр |
| comprehensive-carrier-screening-panel-both-partners | Comprehensive Carrier Screening Panel (Both Partners) | Sveobuhvatni panel nasljednih bolesti – oba partnera | Расширенная панель скрининга носительства наследственных заболеваний – оба партнёра |
| guidelines-based-carrier-screening-panel-one-person | Guidelines-Based Carrier Screening Panel (One Person) | Panel prema vodičima za jednu osobu (skrining na nasljedne bolesti) | Панель скрининга носительства по клиническим рекомендациям – один человек |
| guidelines-based-carrier-screening-panel-two-persons | Guidelines-Based Carrier Screening Panel (Two Persons) | Panel prema vodičima za dvije osobe (skrining na nasljedne bolesti) | Панель скрининга носительства по клиническим рекомендациям – два человека |
| hereditary-breast-and-gynecologic-cancer-panel | Hereditary Breast and Gynecologic Cancer Panel | Dojka/ginekološki panel (genetika karcinoma) | Генетическая панель наследственного рака молочной железы и гинекологических опухолей |
| hereditary-breast-and-gynecologic-cancer-panel-guidelines-based | Hereditary Breast and Gynecologic Cancer Panel (Guidelines-Based) | Dojka/ginekološki panel prema vodičima (genetika karcinoma) | Генетическая панель наследственного рака молочной железы и гинекологических опухолей (по клиническим рекомендациям) |
| hereditary-breast-and-gynecologic-cancer-panel-high-risk | Hereditary Breast and Gynecologic Cancer Panel (High Risk) | Dojka/ginekološki panel visok rizik (genetika karcinoma) | Генетическая панель наследственного рака молочной железы и гинекологических опухолей (высокий риск) |
| hereditary-colorectal-cancer-panel | Hereditary Colorectal Cancer Panel | Kolorektalni karcinom panel (genetika karcinoma) | Генетическая панель наследственного колоректального рака |
| hereditary-colorectal-cancer-panel-high-risk | Hereditary Colorectal Cancer Panel (High Risk) | Kolorektalni karcinom panel visok rizik (genetika karcinoma) | Генетическая панель наследственного колоректального рака (высокий риск) |
| hereditary-non-polyposis-colorectal-cancer-panel | Hereditary Non-Polyposis Colorectal Cancer Panel | Nasljedni nepolipozni kolorektalni karcinom (genetika karcinoma) | Генетическая панель наследственного неполипозного колоректального рака |
| hereditary-polyposis-colorectal-cancer-panel | Hereditary Polyposis Colorectal Cancer Panel | Nasljedni polipozni kolorektalni karcinom (genetika karcinoma) | Генетическая панель наследственного полипозного колоректального рака |
| myelodysplastic-syndrome-leukemia-genetic-panel | Myelodysplastic Syndrome/Leukemia Genetic Panel | Mijelodisplastični sindrom/leukemija panel (genetika karcinoma) | Генетическая панель: миелодиспластический синдром/лейкоз |
| hereditary-gastric-cancer-panel | Hereditary Gastric Cancer Panel | Želudac panel (genetika karcinoma) | Генетическая панель наследственного рака желудка |
| hereditary-prostate-cancer-panel | Hereditary Prostate Cancer Panel | Prostata panel (genetika karcinoma) | Генетическая панель наследственного рака предстательной железы |
| hereditary-pancreatic-cancer-panel | Hereditary Pancreatic Cancer Panel | Pankreas panel (genetika karcinoma) | Генетическая панель наследственного рака поджелудочной железы |
| hereditary-renal-cancer-panel | Hereditary Renal Cancer Panel | Renalni panel (genetika karcinoma) | Генетическая панель наследственного рака почки |
| hereditary-skin-cancer-panel | Hereditary Skin Cancer Panel | Koža panel (genetika karcinoma) | Генетическая панель наследственного рака кожи |
| familial-melanoma-panel | Familial Melanoma Panel | Familijarni melanom panel (genetika karcinoma) | Генетическая панель семейной меланомы |
| hereditary-paraganglioma-pheochromocytoma-panel | Hereditary Paraganglioma/Pheochromocytoma Panel | Paragangliom/feohromocitom panel (genetika karcinoma) | Генетическая панель наследственной параганглиомы/феохромоцитомы |
| hereditary-parathyroid-cancer-panel | Hereditary Parathyroid Cancer Panel | Paratireoidni panel (genetika karcinoma) | Генетическая панель наследственного рака паращитовидных желёз |
| hereditary-thyroid-cancer-panel | Hereditary Thyroid Cancer Panel | Tireoidni panel (genetika karcinoma) | Генетическая панель наследственного рака щитовидной железы |
| pan-cancer-hereditary-panel | Pan-Cancer Hereditary Panel | Pan-kancer panel (genetika karcinoma) | Расширенная генетическая панель наследственных онкологических заболеваний (pan-cancer) |
| nipt-veracity-basic | NIPT Veracity Basic | NIPT Veracity Basic | НИПТ Veracity базовый |
| nipt-veracity-plus | NIPT Veracity Plus | NIPT Veracity Plus | НИПТ Veracity Plus |
| nipt-veracity-premium | NIPT Veracity Premium | NIPT Veracity Premium | НИПТ Veracity Premium |
| nipt-veragene | NIPT Veragene | NIPT Veragene | НИПТ Veragene |
| nipt-sequentia-basic | NIPT Sequentia Basic | NIPT Sequentia Basic | НИПТ Sequentia Basic |
| nipt-sequentia-plus | NIPT Sequentia Plus | NIPT Sequentia Plus | НИПТ Sequentia Plus |
| nipt-sequentia-plus-expert | NIPT Sequentia Plus Expert | NIPT Sequentia Plus Expert | НИПТ Sequentia Plus Expert |
| nipt-sequentia-premium | NIPT Sequentia Premium | NIPT Sequentia Premium | НИПТ Sequentia Premium |
| nipt-sequentia-safe-karyo-plus | NIPT Sequentia Safe Karyo Plus | NIPT Sequentia Safe Karyo Plus | НИПТ Sequentia Safe Karyo Plus |
| nipt-sequentia-premiumgene | NIPT Sequentia PremiumGene | NIPT Sequentia PremiumGene | НИПТ Sequentia PremiumGene |
| nipt-sequentia-safe-full-karyo-plus | NIPT Sequentia Safe Full Karyo Plus | NIPT Sequentia Safe Full Karyo Plus | НИПТ Sequentia Safe Full Karyo Plus |
| chlamydia-trachomatis-direct-immunofluorescence | Chlamydia trachomatis (Direct Immunofluorescence) | Chlamydia trachomatis DIF metoda | Chlamydia trachomatis – прямая иммунофлуоресценция (ПИФ) |
| coxiella-burnetii-igg | Coxiella burnetii IgG | Coxiella burnetii IgG | Антитела к Coxiella burnetii IgG |
| coxiella-burnetii-igm | Coxiella burnetii IgM | Coxiella burnetii IgM | Антитела к Coxiella burnetii IgM |
| enterovirus-igm | Enterovirus IgM | Enterovirus IgM (Coxsackie A/B, ECHO, enterovirusi 68-71) | Энтеровирусы IgM (Coxsackie A/B, ECHO, энтеровирусы 68–71) |
| enterovirus-igg | Enterovirus IgG | Enterovirus IgG (Coxsackie A/B, ECHO, enterovirusi 68-71) | Энтеровирусы IgG (Coxsackie A/B, ECHO, энтеровирусы 68–71) |
| immunofixation-protein-serum | Immunofixation Protein Serum | Imunofiksacija proteina seruma | Иммунофиксация белков сыворотки |
| immunofixation-protein-urine | Immunofixation Protein Urine | Imunofiksacija proteina urina | Иммунофиксация белков мочи |
| histopathology-cervical-biopsy-and-fractional-curettage-three-samples | Histopathology Cervical Biopsy and Fractional Curettage Three Samples | PH Biopsija grlića materice i frakciona kiretaža ukupno tri uzorka | Патогистологическое исследование биопсии шейки матки и фракционного кюретажа (всего три образца) |
| histopathology-endoscopic-biopsy-each-additional-sample | Histopathology Endoscopic Biopsy (Each Additional Sample) | PH Endoskopska biopsija (svaki sljedeći uzorak) | Патогистологическое исследование эндоскопической биопсии (каждый следующий образец) |
| histopathology-ovary-examination | Histopathology Ovary Examination | PH Pregled jajnika | Патогистологическое исследование яичника |
| candida-dna-pcr | Candida DNA PCR | Candida DNK | ДНК Candida (ПЦР) |
| hepatitis-e-virus-rna-pcr | Hepatitis E Virus RNA PCR | Hepatitis E virus RNK | РНК вируса гепатита E (ПЦР) |
| hemochromatosis-hfe-genetic-test | Hemochromatosis HFE Genetic Test | Hemohromatoza | Гемохроматоз (генетический тест HFE) |
| spinal-muscular-atrophy-genetic-test | Spinal Muscular Atrophy Genetic Test | Spinalna mišićna atrofija (genetika) | Спинальная мышечная атрофия (генетический тест) |
| beta-hemoglobinopathies-carrier-screening | Beta Hemoglobinopathies Carrier Screening | Beta hemoglobinopatije (skrining na nasljedne bolesti) | Скрининг носительства бета-гемоглобинопатий |
| cystic-fibrosis-carrier-screening | Cystic Fibrosis Carrier Screening | Cistična fibroza (skrining na nasljedne bolesti) | Скрининг носительства муковисцидоза |

## Хвосты — 2026-10-05

`server/sql/migrations/051-moj-lab-followup.sql` — применена локально и в проде 2026-10-05 (сверено API: каталог 1774, у 9 лабораторий по 704 анализа и 6 услуг, 301 со старых slug).

- **PH опухоли кожи.** Прайс In Vitro (invitro.co.me/cjenovnik.php): «PH tumora kože (sljedeći uzorci po 15)» — 30 €, то есть первый образец 30, каждый следующий 15. Запись `-15` (её справка — про следующие образцы) → `histopathology-skin-tumor-each-additional-sample`, 301 со старого; In Vitro на ней 15 €. Новая `histopathology-skin-tumor` — первый образец, In Vitro 30 €; Moj Lab «Biopsija tumora kože» / «Ph tumora kože» переехали на неё с услуги КЦЦГ `histopathology-of-skin-tumor`.
- **Натрий.** После импорта Diagnostica есть `sodium-in-urine` (у Diagnostica обе записи с разными ценами) — «Urin - Natrijum» Moj Lab переведён на разовую мочу. Калий, цитраты, оксалаты — записи по разовой моче нет, остаются на суточной.
- **double-test** слит в `double-test-first-trimester-screening` (ни одна клиника не держит обе); в неприменённых Codra и Tesla slug поправлен.
- Попутно: в `migrations/insert-entity-reference-info.sql` slug справки PH кожи обновлён на новый.
