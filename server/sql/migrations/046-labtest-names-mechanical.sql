-- 046: названия анализов — механические дефекты (шаг 1 из docs/audit/labtest-names-2026-10.md).
--
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/046-labtest-names-mechanical.sql
--
-- Собрано скриптом scripts/services/build-service-names-sql.mjs из
-- data/labtest-names/fix-*.json (--catalog lab) — руками не править, пересобирать.
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
-- Строк: 235 (правки батчей — 106, только синхронизация кириллицы — 129).
-- Синонимов: 192 — старые name_en и экавские варианты исправленных name_sr,
-- чтобы прежние формулировки продолжали находиться.
--
-- Обновление по slug, а не по id: у локальной БД и прода разный автоинкремент.
-- Идемпотентно: присваиваются готовые значения, синонимы — INSERT IGNORE.
-- Применять ДО 047.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

START TRANSACTION;

UPDATE lab_tests SET
	name_sr_cyrl = '0127',
	name_ru = 'Анализ 0127',
	name_de = '0127',
	name_tr = '0127'
 WHERE slug = '0127';

UPDATE lab_tests SET
	name_sr = 'Antitijela na acetilholinski receptor',
	name_sr_cyrl = 'Антитијела на ацетилхолински рецептор'
 WHERE slug = 'acetylcholine-receptor-antibodies';

UPDATE lab_tests SET
	name_sr = 'Aktivirano parcijalno tromboplastinsko vrijeme',
	name_sr_cyrl = 'Активирано парцијално тромбопластинско вријеме'
 WHERE slug = 'activated-partial-thromboplastin-time';

UPDATE lab_tests SET
	name_sr = 'Antitijela na adalimumab',
	name_sr_cyrl = 'Антитијела на адалимумаб'
 WHERE slug = 'adalimumab-antibodies';

UPDATE lab_tests SET
	name_sr_cyrl = 'Аденовирус респираторни тест (брис носа)'
 WHERE slug = 'adenovirus-respiratory-test';

UPDATE lab_tests SET
	name_sr = 'Antitijela na nadbubrežnu žlijezdu',
	name_sr_cyrl = 'Антитијела на надбубрежну жлијезду'
 WHERE slug = 'adrenal-antibodies';

UPDATE lab_tests SET
	name_sr = 'ANA antinuklearna antitijela',
	name_sr_cyrl = 'ANA антинуклеарна антитијела'
 WHERE slug = 'ana-antinuclear-antibodies';

UPDATE lab_tests SET
	name_sr = 'ANA ENA profil 15 antitijela',
	name_sr_cyrl = 'ANA ENA профил 15 антитијела'
 WHERE slug = 'ana-ena-profile-15-antibodies';

UPDATE lab_tests SET
	name_sr = 'ANA ENA profil 25 antitijela',
	name_sr_cyrl = 'ANA ENA профил 25 антитијела'
 WHERE slug = 'ana-ena-profile-25-antibodies';

UPDATE lab_tests SET
	name_sr = 'Anti-C1q antitijela',
	name_sr_cyrl = 'Anti-C1q антитијела'
 WHERE slug = 'anti-c1q-antibodies';

UPDATE lab_tests SET
	name_sr = 'Antitijela na srčani mišić',
	name_sr_cyrl = 'Антитијела на срчани мишић'
 WHERE slug = 'anti-cardiac-antibodies';

UPDATE lab_tests SET
	name_sr = 'Anti-CCP antitijela',
	name_sr_cyrl = 'Anti-CCP антитијела'
 WHERE slug = 'anti-ccp-antibodies';

UPDATE lab_tests SET
	name_sr = 'Anti-GAD antitijela',
	name_sr_cyrl = 'Anti-GAD антитијела'
 WHERE slug = 'anti-gad-antibodies';

UPDATE lab_tests SET
	name_sr_cyrl = 'Тест на анти-HBc антитијела'
 WHERE slug = 'anti-hbc-antibody-test';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti HBc IgM антитијела - ELISA'
 WHERE slug = 'anti-hbc-igm-elisa';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti HBc антитијела - ELISA'
 WHERE slug = 'anti-hbc-total-elisa';

UPDATE lab_tests SET
	name_sr_cyrl = 'Тест на анти-HBe антитијела'
 WHERE slug = 'anti-hbe-antibody-test';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti HBe антитијела - ELISA'
 WHERE slug = 'anti-hbe-elisa';

UPDATE lab_tests SET
	name_sr_cyrl = 'Тест на анти-HBs антитијела'
 WHERE slug = 'anti-hbs-antibody-test';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti хепатитис C вирус антитијела - имуно блот'
 WHERE slug = 'anti-hcv-antibodies-immunoblot';

UPDATE lab_tests SET
	name_sr = 'Antitijela na srce ASA',
	name_sr_cyrl = 'Антитијела на срце ASA'
 WHERE slug = 'anti-heart-antibodies-asa';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti хепатитис E вирус IgG - ELISA'
 WHERE slug = 'anti-hev-igg-elisa';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti хепатитис E вирус IgM - ELISA'
 WHERE slug = 'anti-hev-igm-elisa';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti HIV 1 антитијела - потврдни тест - western блот'
 WHERE slug = 'anti-hiv-1-western-blot-confirmation';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti HIV 2 антитијела - потврдни тест - western блот'
 WHERE slug = 'anti-hiv-2-western-blot-confirmation';

UPDATE lab_tests SET
	name_sr = 'Antitijela na insulin',
	name_sr_cyrl = 'Антитијела на инсулин'
 WHERE slug = 'anti-insulin-antibodies';

UPDATE lab_tests SET
	name_sr = 'Anti-Jo-1 antitijela',
	name_sr_cyrl = 'Анти-Јо-1 антитијела'
 WHERE slug = 'anti-jo-1-antibodies';

UPDATE lab_tests SET
	name_sr = 'Anti-La SSB antitijela',
	name_sr_cyrl = 'Anti-La SSB антитијела'
 WHERE slug = 'anti-la-ssb-antibodies';

UPDATE lab_tests SET
	name_sr_cyrl = 'Анти-Милеров хормон'
 WHERE slug = 'anti-mullerian-hormone';

UPDATE lab_tests SET
	name_sr = 'Antitijela na parijetalne ćelije APA',
	name_sr_cyrl = 'Антитијела на паријеталне ћелије APA'
 WHERE slug = 'anti-parietal-cell-antibodies-apa';

UPDATE lab_tests SET
	name_sr = 'Anti-Rh antitijela',
	name_sr_cyrl = 'Anti-Rh антитијела'
 WHERE slug = 'anti-rh-antibodies';

UPDATE lab_tests SET
	name_sr = 'Anti-Ro SSA antitijela',
	name_sr_cyrl = 'Anti-Ro SSA антитијела'
 WHERE slug = 'anti-ro-ssa-antibodies';

UPDATE lab_tests SET
	name_sr = 'Anti-Scl-70 antitijela',
	name_sr_cyrl = 'Анти-Сцл-70 антитијела'
 WHERE slug = 'anti-scl-70-antibodies';

UPDATE lab_tests SET
	name_sr = 'Anti-SLA LP antitijela',
	name_sr_cyrl = 'Anti-SLA LP антитијела'
 WHERE slug = 'anti-sla-lp-antibodies';

UPDATE lab_tests SET
	name_sr = 'Anti-SM antitijela',
	name_sr_cyrl = 'Anti-SM антитијела'
 WHERE slug = 'anti-sm-antibodies';

UPDATE lab_tests SET
	name_sr = 'Antitijela na glatke mišiće ASMA',
	name_sr_cyrl = 'Антитијела на глатке мишиће ASMA'
 WHERE slug = 'anti-smooth-muscle-antibodies-asma';

UPDATE lab_tests SET
	name_sr = 'Antitijela na tireoglobulin',
	name_sr_cyrl = 'Антитијела на тиреоглобулин'
 WHERE slug = 'anti-thyroglobulin-antibodies';

UPDATE lab_tests SET
	name_sr = 'Antitijela na tireoperoksidazu',
	name_sr_cyrl = 'Антитијела на тиреопероксидазу'
 WHERE slug = 'anti-tpo';

UPDATE lab_tests SET
	name_sr = 'Antitijela na TSH receptor',
	name_sr_cyrl = 'Антитијела на TSH рецептор'
 WHERE slug = 'anti-tshr';

UPDATE lab_tests SET
	name_sr_cyrl = 'Идентификација антитијела — гел метода'
 WHERE slug = 'antibody-identification-gel-method';

UPDATE lab_tests SET
	name_sr_cyrl = 'Идентификација антитијела (епрувета)'
 WHERE slug = 'antibody-identification-tube';

UPDATE lab_tests SET
	name_sr_cyrl = 'Детекција антимикробних антитијела реакцијом везивања комплемента'
 WHERE slug = 'antimicrobial-antibody-detection-by-complement-fixation';

UPDATE lab_tests SET
	name_sr_cyrl = 'Детекција антимикробних антитијела ELISA тестом'
 WHERE slug = 'antimicrobial-antibody-detection-by-elisa';

UPDATE lab_tests SET
	name_sr_cyrl = 'Детекција антимикробних антитијела тестом хемаглутинације'
 WHERE slug = 'antimicrobial-antibody-detection-by-hemagglutination';

UPDATE lab_tests SET
	name_sr_cyrl = 'Детекција антимикробних антитијела индиректном имунофлуоресценцијом'
 WHERE slug = 'antimicrobial-antibody-detection-by-indirect-immunofluorescence';

UPDATE lab_tests SET
	name_sr_cyrl = 'Детекција антимикробних антитијела latex аглутинационим тестом'
 WHERE slug = 'antimicrobial-antibody-detection-by-latex-agglutination';

UPDATE lab_tests SET
	name_sr = 'Akvaporin-4 antitijela',
	name_sr_cyrl = 'Аквапорин-4 антитијела'
 WHERE slug = 'aquaporin-4-antibodies';

UPDATE lab_tests SET
	name_sr = 'Antitijela na akvaporin',
	name_sr_cyrl = 'Антитијела на аквапорин'
 WHERE slug = 'aquaporin-antibodies';

UPDATE lab_tests SET
	name_sr = 'Bris Bartolinove žlijezde bakterije',
	name_sr_cyrl = 'Брис Бартолинове жлијезде бактерије'
 WHERE slug = 'bartholin-gland-swab-bacteria';

UPDATE lab_tests SET
	name_sr = 'Bris Bartolinove žlijezde gljivice',
	name_sr_cyrl = 'Брис Бартолинове жлијезде гљивице'
 WHERE slug = 'bartholin-gland-swab-fungi';

UPDATE lab_tests SET
	name_sr_cyrl = 'Bens Џонс протеини'
 WHERE slug = 'bence-jones-protein';

UPDATE lab_tests SET
	name_sr_cyrl = 'Бета-2 гликопротеин I IgG'
 WHERE slug = 'beta-2-glycoprotein-i-igg';

UPDATE lab_tests SET
	name_sr_cyrl = 'Бета-2 гликопротеин I IgM'
 WHERE slug = 'beta-2-glycoprotein-i-igm';

UPDATE lab_tests SET
	name_sr_cyrl = 'Бета-2 микроглобулин'
 WHERE slug = 'beta-2-microglobulin';

UPDATE lab_tests SET
	name_sr_cyrl = 'Бета-2 микроглобулин у урину'
 WHERE slug = 'beta-2-microglobulin-in-urine';

UPDATE lab_tests SET
	name_sr = 'Vrijeme krvarenja',
	name_sr_cyrl = 'Вријеме крварења'
 WHERE slug = 'bleeding-time';

UPDATE lab_tests SET
	name_sr = 'Majčino mlijeko bakterije',
	name_sr_cyrl = 'Мајчино млијеко бактерије'
 WHERE slug = 'breast-milk-bacteria';

UPDATE lab_tests SET
	name_sr = 'Majčino mlijeko gljivice',
	name_sr_cyrl = 'Мајчино млијеко гљивице'
 WHERE slug = 'breast-milk-fungi';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti Brucella abortus антитијела - аглутинација'
 WHERE slug = 'brucella-abortus-antibodies-agglutination';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti Brucella IgA антитијела - ELISA'
 WHERE slug = 'brucella-iga-elisa';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti Brucella IgG антитијела - ELISA'
 WHERE slug = 'brucella-igg-elisa';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti Brucella melitensis антитијела - аглутинација'
 WHERE slug = 'brucella-melitensis-antibodies-agglutination';

UPDATE lab_tests SET
	name_sr = 'C-peptid poslije 120 min',
	name_sr_cyrl = 'C-пептид послије 120 мин'
 WHERE slug = 'c-peptide-after-120-min';

UPDATE lab_tests SET
	name_sr = 'C-peptid poslije 150 min',
	name_sr_cyrl = 'C-пептид послије 150 мин'
 WHERE slug = 'c-peptide-after-150-min';

UPDATE lab_tests SET
	name_sr = 'C-peptid poslije 180 min',
	name_sr_cyrl = 'C-пептид послије 180 мин'
 WHERE slug = 'c-peptide-after-180-min';

UPDATE lab_tests SET
	name_sr = 'C-peptid poslije 30 min',
	name_sr_cyrl = 'C-пептид послије 30 мин'
 WHERE slug = 'c-peptide-after-30-min';

UPDATE lab_tests SET
	name_sr = 'C-peptid poslije 60 min',
	name_sr_cyrl = 'C-пептид послије 60 мин'
 WHERE slug = 'c-peptide-after-60-min';

UPDATE lab_tests SET
	name_sr = 'C-peptid poslije 90 min',
	name_sr_cyrl = 'C-пептид послије 90 мин'
 WHERE slug = 'c-peptide-after-90-min';

UPDATE lab_tests SET
	name_sr = 'Candida IgG antitijela',
	name_sr_cyrl = 'Candida IgG антитијела'
 WHERE slug = 'candida-igg-antibodies';

UPDATE lab_tests SET
	name_sr = 'Candida IgM antitijela',
	name_sr_cyrl = 'Candida IgM антитијела'
 WHERE slug = 'candida-igm-antibodies';

UPDATE lab_tests SET
	name_sr_cyrl = 'Карциноембрионални антиген'
 WHERE slug = 'cea';

UPDATE lab_tests SET
	name_sr_cyrl = 'Бактериолошко испитивање бриса улазног мјеста централног венског катетера - аеробно'
 WHERE slug = 'central-venous-catheter-entry-site-swab-culture-aerobic';

UPDATE lab_tests SET
	name_sr = 'Centromer protein B antitijela',
	name_sr_cyrl = 'Центромер протеин B антитијела'
 WHERE slug = 'centromere-protein-b-antibodies';

UPDATE lab_tests SET
	name_sr_cyrl = 'Chlamydia trachomatis + Mycoplasma hominis/гениталиум PCR'
 WHERE slug = 'chlamydia-trachomatis-mycoplasma-hominis-genitalium-pcr';

UPDATE lab_tests SET
	name_sr_cyrl = 'Chlamydia trachomatis + Ureaplasma urealyticum + Mycoplasma hominis/гениталиум PCR'
 WHERE slug = 'chlamydia-trachomatis-ureaplasma-urealyticum-mycoplasma-hominis-genitalium-pcr';

UPDATE lab_tests SET
	name_sr = 'Vrijeme koagulacije',
	name_sr_cyrl = 'Вријеме коагулације'
 WHERE slug = 'coagulation-time';

UPDATE lab_tests SET
	name_sr_cyrl = 'Бактериолошко испитивање бриса дебелог цријева - аеробно'
 WHERE slug = 'colon-swab-culture-aerobic';

UPDATE lab_tests SET
	name_sr_cyrl = 'Бактериолошко испитивање бриса дебелог цријева - анаеробно'
 WHERE slug = 'colon-swab-culture-anaerobic';

UPDATE lab_tests SET
	name_sr = 'Kuvano mlijeko IgE f231',
	name_sr_cyrl = 'Кувано млијеко IgE f231'
 WHERE slug = 'cooked-milk-ige-f231';

UPDATE lab_tests SET
	name_sr_cyrl = 'Рак Ф24'
 WHERE slug = 'crab-f24';

UPDATE lab_tests SET
	name_sr_cyrl = 'Интерреакција — гел метода'
 WHERE slug = 'crossmatch-gel-method';

UPDATE lab_tests SET
	name_sr_cyrl = 'Д-димер'
 WHERE slug = 'd-dimer';

UPDATE lab_tests SET
	name_sr = 'Panel droga 10',
	name_sr_cyrl = 'Панел дрога 10',
	name_ru = 'Панель наркотиков 10',
	name_de = 'Drogenscreening 10',
	name_tr = 'İlaç Paneli 10'
 WHERE slug = 'drug-panel-10';

UPDATE lab_tests SET
	name_sr = 'dsDNA antitijela',
	name_sr_cyrl = 'dsDNA антитијела'
 WHERE slug = 'dsdna-antibodies';

UPDATE lab_tests SET
	name_sr = 'dsDNA IgG antitijela',
	name_sr_cyrl = 'dsDNA IgG антитијела'
 WHERE slug = 'dsdna-igg-antibodies';

UPDATE lab_tests SET
	name_sr = 'dsDNA IgM antitijela'
 WHERE slug = 'dsdna-igm-antibodies';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti Echinococcus granulosus антитијела - индиректна хемаглутинација'
 WHERE slug = 'echinococcus-granulosus-antibodies-indirect-hemagglutination';

UPDATE lab_tests SET
	name_sr = 'Endomizijalna IgA antitijela',
	name_sr_cyrl = 'Ендомизијална IgA антитијела'
 WHERE slug = 'endomysial-iga-antibodies';

UPDATE lab_tests SET
	name_sr_cyrl = 'GAD антитијела (тест за дијабетес тип 1)'
 WHERE slug = 'gad-antibodies';

UPDATE lab_tests SET
	name_sr = 'Bijeli luk IgE f47',
	name_sr_cyrl = 'Бијели лук IgE f47'
 WHERE slug = 'garlic-ige-f47';

UPDATE lab_tests SET
	name_sr = 'GBM antitijela na bazalnu membranu glomerula',
	name_sr_cyrl = 'GBM антитијела на базалну мембрану гломерула'
 WHERE slug = 'gbm-antibodies';

UPDATE lab_tests SET
	name_sr = 'Glijadin IgA antitijela',
	name_sr_cyrl = 'Глијадин IgA антитијела'
 WHERE slug = 'gliadin-iga-antibodies';

UPDATE lab_tests SET
	name_sr = 'Glijadin IgG antitijela',
	name_sr_cyrl = 'Глијадин IgG антитијела'
 WHERE slug = 'gliadin-igg-antibodies';

UPDATE lab_tests SET
	name_sr_cyrl = 'Глукоза 240 мин'
 WHERE slug = 'glucose-240-min';

UPDATE lab_tests SET
	name_sr = 'Glukoza poslije 120 min',
	name_sr_cyrl = 'Глукоза послије 120 мин'
 WHERE slug = 'glucose-after-120-min';

UPDATE lab_tests SET
	name_sr = 'Glukoza poslije 180 min',
	name_sr_cyrl = 'Глукоза послије 180 мин'
 WHERE slug = 'glucose-after-180-min';

UPDATE lab_tests SET
	name_sr = 'Glukoza poslije 30 min',
	name_sr_cyrl = 'Глукоза послије 30 мин'
 WHERE slug = 'glucose-after-30-min';

UPDATE lab_tests SET
	name_sr = 'Glukoza poslije 60 min',
	name_sr_cyrl = 'Глукоза послије 60 мин'
 WHERE slug = 'glucose-after-60-min';

UPDATE lab_tests SET
	name_sr = 'Glukoza poslije 90 min',
	name_sr_cyrl = 'Глукоза послије 90 мин'
 WHERE slug = 'glucose-after-90-min';

UPDATE lab_tests SET
	name_sr = 'Glukoza prije i 2h poslije obroka',
	name_sr_cyrl = 'Глукоза прије и 2h послије оброка'
 WHERE slug = 'glucose-before-and-2h-after-meal';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti Hanta вирус IgG - ELISA'
 WHERE slug = 'hantavirus-igg-elisa';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti Hanta вирус IgM - ELISA'
 WHERE slug = 'hantavirus-igm-elisa';

UPDATE lab_tests SET
	name_sr = 'HAV ukupna antitijela',
	name_sr_cyrl = 'HAV укупна антитијела'
 WHERE slug = 'hav-total-antibodies';

UPDATE lab_tests SET
	name_sr_cyrl = 'Лештик IgE f17'
 WHERE slug = 'hazelnut-ige-f17';

UPDATE lab_tests SET
	name_sr_cyrl = 'Испитивање присуства Herpes simplex вируса тип 1 - директна имунофлуоресценција'
 WHERE slug = 'herpes-simplex-virus-type-1-direct-immunofluorescence';

UPDATE lab_tests SET
	name_sr_cyrl = 'Испитивање присуства Herpes simplex вируса тип 2 - директна имунофлуоресценција'
 WHERE slug = 'herpes-simplex-virus-type-2-direct-immunofluorescence';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Преглед тумора мозга'
 WHERE slug = 'histopathology-brain-tumor-examination';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Бронхоскопска биопсија'
 WHERE slug = 'histopathology-bronchoscopic-biopsy';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Биопсија грлића материце и киретажа'
 WHERE slug = 'histopathology-cervical-biopsy-and-curettage';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Преглед полипа грлића'
 WHERE slug = 'histopathology-cervical-polyp-examination';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Преглед конизата'
 WHERE slug = 'histopathology-conization-specimen';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Преглед конизата са киретажом'
 WHERE slug = 'histopathology-conization-specimen-with-curettage';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ киретаже'
 WHERE slug = 'histopathology-curettage';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Цитолошки преглед-размаз'
 WHERE slug = 'histopathology-cytology-smear';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Ендоскопски узета биопсија'
 WHERE slug = 'histopathology-endoscopic-biopsy';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Биопсија јетре'
 WHERE slug = 'histopathology-liver-biopsy';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Преглед тумора плућа'
 WHERE slug = 'histopathology-lung-tumor-examination';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Биопсија медијастинума'
 WHERE slug = 'histopathology-mediastinum-biopsy';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Иглена биопсија (јетра, плућа, бубрег)'
 WHERE slug = 'histopathology-needle-biopsy-liver-lung-kidney';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Иглена биопсија дојке без имунохистохемије'
 WHERE slug = 'histopathology-needle-breast-biopsy-without-ihc';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Иглена биопсија простате'
 WHERE slug = 'histopathology-needle-prostate-biopsy';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Иглена биопсија простате висе узорака'
 WHERE slug = 'histopathology-needle-prostate-biopsy-multiple-samples';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Биопсија усне дупље'
 WHERE slug = 'histopathology-oral-cavity-biopsy';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Преглед орхиектомије-тестис'
 WHERE slug = 'histopathology-orchiectomy-testis-examination';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Остале биопсије'
 WHERE slug = 'histopathology-other-biopsies';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Биопсија плеуре'
 WHERE slug = 'histopathology-pleura-biopsy';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Преглед одстрањене дојке'
 WHERE slug = 'histopathology-removed-breast-examination';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Ревизија хистопатолошког налаза'
 WHERE slug = 'histopathology-report-review';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ биопсија желудца'
 WHERE slug = 'histopathology-stomach-biopsy';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Преглед поткожног тумора'
 WHERE slug = 'histopathology-subcutaneous-tumor-examination';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Клиноидна биопсија дојке без имунохистохемије'
 WHERE slug = 'histopathology-surgical-breast-biopsy-without-ihc';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Биопсија тестиса'
 WHERE slug = 'histopathology-testis-biopsy';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Биопсија штитне жлијезде'
 WHERE slug = 'histopathology-thyroid-biopsy';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Трус простате'
 WHERE slug = 'histopathology-trus-prostate';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Преглед утеруса'
 WHERE slug = 'histopathology-uterus-examination';

UPDATE lab_tests SET
	name_sr_cyrl = 'ПХ Биопсија вулве'
 WHERE slug = 'histopathology-vulvar-biopsy';

UPDATE lab_tests SET
	name_sr = 'IA-2 antitijela',
	name_sr_cyrl = 'IA-2 антитијела'
 WHERE slug = 'ia-2-antibodies';

UPDATE lab_tests SET
	name_sr = 'ICA antitijela na ostrvske ćelije',
	name_sr_cyrl = 'ICA антитијела на острвске ћелије'
 WHERE slug = 'ica-antibodies';

UPDATE lab_tests SET
	name_sr = 'IgE antitijela na humani insulin',
	name_sr_cyrl = 'IgE антитијела на хумани инсулин'
 WHERE slug = 'ige-antibodies-to-human-insulin';

UPDATE lab_tests SET
	name_sr_cyrl = 'Испитивање имуних антитијела'
 WHERE slug = 'immune-antibody-screening';

UPDATE lab_tests SET
	name_sr_cyrl = 'Титар имуних антитијела'
 WHERE slug = 'immune-antibody-titer';

UPDATE lab_tests SET
	name_sr_cyrl = 'Имунохистохемијска анализа висе од 10 антитијела'
 WHERE slug = 'immunohistochemistry-more-than-10-antibodies';

UPDATE lab_tests SET
	name_sr = 'Antitijela na infliksimab',
	name_sr_cyrl = 'Антитијела на инфликсимаб'
 WHERE slug = 'infliximab-antibodies';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti инфлуенза A вирус IgG - ELISA'
 WHERE slug = 'influenza-a-virus-igg-elisa';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti инфлуенза A вирус IgM - ELISA'
 WHERE slug = 'influenza-a-virus-igm-elisa';

UPDATE lab_tests SET
	name_sr_cyrl = 'Инфлуенца A и B – брзи тест на грип'
 WHERE slug = 'influenza-ab-rapid-test';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti инфлуенза B вирус IgG - ELISA'
 WHERE slug = 'influenza-b-virus-igg-elisa';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti инфлуенза B вирус IgM - ELISA'
 WHERE slug = 'influenza-b-virus-igm-elisa';

UPDATE lab_tests SET
	name_sr = 'Insulin poslije 120 min',
	name_sr_cyrl = 'Инсулин послије 120 мин'
 WHERE slug = 'insulin-after-120-min';

UPDATE lab_tests SET
	name_sr = 'Insulin poslije 180 min',
	name_sr_cyrl = 'Инсулин послије 180 мин'
 WHERE slug = 'insulin-after-180-min';

UPDATE lab_tests SET
	name_sr = 'Insulin poslije 240 min',
	name_sr_cyrl = 'Инсулин послије 240 мин'
 WHERE slug = 'insulin-after-240-min';

UPDATE lab_tests SET
	name_sr = 'Insulin poslije 30 min',
	name_sr_cyrl = 'Инсулин послије 30 мин'
 WHERE slug = 'insulin-after-30-min';

UPDATE lab_tests SET
	name_sr = 'Insulin poslije 60 min',
	name_sr_cyrl = 'Инсулин послије 60 мин'
 WHERE slug = 'insulin-after-60-min';

UPDATE lab_tests SET
	name_sr = 'Insulin poslije 90 min',
	name_sr_cyrl = 'Инсулин послије 90 мин'
 WHERE slug = 'insulin-after-90-min';

UPDATE lab_tests SET
	name_sr_cyrl = 'Интерлеукин-1 бета'
 WHERE slug = 'interleukin-1-beta';

UPDATE lab_tests SET
	name_sr_cyrl = 'Бактериолошко испитивање бриса овојнице цријева - аеробно'
 WHERE slug = 'intestinal-serosa-swab-culture-aerobic';

UPDATE lab_tests SET
	name_sr_cyrl = 'Бактериолошко испитивање бриса овојнице цријева - анаеробно'
 WHERE slug = 'intestinal-serosa-swab-culture-anaerobic';

UPDATE lab_tests SET
	name_sr = 'Antitijela na intrinzički faktor',
	name_sr_cyrl = 'Антитијела на интринзички фактор'
 WHERE slug = 'intrinsic-factor-antibodies';

UPDATE lab_tests SET
	name_sr_cyrl = 'Испитивање ирегуларних антитијела ензим сцреенинг — гел метода'
 WHERE slug = 'irregular-antibody-enzyme-screening-gel-method';

UPDATE lab_tests SET
	name_sr_cyrl = 'Испитивање ирегуларних антитијела — сцреенинг тест'
 WHERE slug = 'irregular-antibody-screening';

UPDATE lab_tests SET
	name_sr_cyrl = 'Ламинарна тијела у плодовој води'
 WHERE slug = 'lamellar-bodies-in-amniotic-fluid';

UPDATE lab_tests SET
	name_sr = 'Bris lijevog uha bakterije',
	name_sr_cyrl = 'Брис лијевог уха бактерије'
 WHERE slug = 'left-ear-swab-bacteria';

UPDATE lab_tests SET
	name_sr = 'Bris lijevog uha gljivice',
	name_sr_cyrl = 'Брис лијевог уха гљивице'
 WHERE slug = 'left-ear-swab-fungi';

UPDATE lab_tests SET
	name_sr = 'Bris lijevog oka',
	name_sr_cyrl = 'Брис лијевог ока'
 WHERE slug = 'left-eye-swab';

UPDATE lab_tests SET
	name_sr = 'Bris lijevog oka gljivice',
	name_sr_cyrl = 'Брис лијевог ока гљивице'
 WHERE slug = 'left-eye-swab-fungi';

UPDATE lab_tests SET
	name_sr = 'Bris lijeve bradavice bakterije',
	name_sr_cyrl = 'Брис лијеве брадавице бактерије'
 WHERE slug = 'left-nipple-swab-bacteria';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti Leishmania donovani антитијела - индиректна хемаглутинација'
 WHERE slug = 'leishmania-donovani-antibodies-indirect-hemagglutination';

UPDATE lab_tests SET
	name_sr_cyrl = 'Leishmania IgG/IgM'
 WHERE slug = 'leishmania-igg-igm';

UPDATE lab_tests SET
	name_sr = 'Leishmania IgM antitijela',
	name_sr_cyrl = 'Leishmania IgM антитијела'
 WHERE slug = 'leishmania-igm-antibodies';

UPDATE lab_tests SET
	name_sr = 'LKM-1 antitijela',
	name_sr_cyrl = 'LKM-1 антитијела'
 WHERE slug = 'lkm-1-antibodies';

UPDATE lab_tests SET
	name_sr = 'LMA antitijela',
	name_sr_cyrl = 'LMA антитијела'
 WHERE slug = 'lma-antibodies';

UPDATE lab_tests SET
	name_sr = 'Lupus antitijela',
	name_sr_cyrl = 'Лупус антитијела'
 WHERE slug = 'lupus-antibodies';

UPDATE lab_tests SET
	name_sr_cyrl = 'Ливадски вијук IgE g4'
 WHERE slug = 'meadow-fescue-ige-g4';

UPDATE lab_tests SET
	name_sr = 'Mlijeko IgE f2',
	name_sr_cyrl = 'Млијеко IgE f2'
 WHERE slug = 'milk-ige-f2';

UPDATE lab_tests SET
	name_sr = 'Mlijeko u prahu IgE f228',
	name_sr_cyrl = 'Млијеко у праху IgE f228'
 WHERE slug = 'milk-powder-ige-f228';

UPDATE lab_tests SET
	name_sr_cyrl = 'Дуд IgE t70'
 WHERE slug = 'mulberry-ige-t70';

UPDATE lab_tests SET
	name_sr = 'MUSK antitijela',
	name_sr_cyrl = 'MUSK антитијела'
 WHERE slug = 'musk-antibodies';

UPDATE lab_tests SET
	name_sr_cyrl = 'Mycoplasma hominis/гениталиум PCR'
 WHERE slug = 'mycoplasma-hominis-genitalium-pcr';

UPDATE lab_tests SET
	name_sr_cyrl = 'Mycoplasma panel PCR'
 WHERE slug = 'mycoplasma-panel-pcr';

UPDATE lab_tests SET
	name_sr_cyrl = 'Mycoplasma pneumoniae IgA'
 WHERE slug = 'mycoplasma-pneumoniae-iga';

UPDATE lab_tests SET
	name_sr_cyrl = 'Титар природних антитијела'
 WHERE slug = 'natural-antibody-titer';

UPDATE lab_tests SET
	name_sr = 'Neuronska antitijela',
	name_sr_cyrl = 'Неуронска антитијела'
 WHERE slug = 'neuronal-antibodies';

UPDATE lab_tests SET
	name_sr = 'NMDAR antitijela u serumu',
	name_sr_cyrl = 'NMDAR антитијела у серуму'
 WHERE slug = 'nmdar-antibodies-in-serum';

UPDATE lab_tests SET
	name_sr = 'Nukleozomska antitijela',
	name_sr_cyrl = 'Нуклеозомска антитијела'
 WHERE slug = 'nucleosomal-antibodies';

UPDATE lab_tests SET
	name_sr_cyrl = 'Хоботница IgE Ф59'
 WHERE slug = 'octopus-ige-f59';

UPDATE lab_tests SET
	name_sr = 'Antitijela na jajnike',
	name_sr_cyrl = 'Антитијела на јајнике'
 WHERE slug = 'ovarian-antibodies';

UPDATE lab_tests SET
	name_sr = 'Paket 132',
	name_sr_cyrl = 'Пакет 132',
	name_ru = 'Пакет 132',
	name_de = 'Paket 132',
	name_tr = 'Paket 132'
 WHERE slug = 'package-132';

UPDATE lab_tests SET
	name_sr = 'Paket 32',
	name_sr_cyrl = 'Пакет 32',
	name_ru = 'Пакет 32',
	name_de = 'Paket 32',
	name_tr = 'Paket 32'
 WHERE slug = 'package-32';

UPDATE lab_tests SET
	name_sr = 'Panel 2',
	name_sr_cyrl = 'Панел 2',
	name_ru = 'Панель 2',
	name_de = 'Panel 2',
	name_tr = 'Panel 2'
 WHERE slug = 'panel-2';

UPDATE lab_tests SET
	name_sr_cyrl = 'Paracetamol ацетаминофен IgE c2'
 WHERE slug = 'paracetamol-acetaminophen-ige-c2';

UPDATE lab_tests SET
	name_sr = 'Izvještaj o očinstvu',
	name_sr_cyrl = 'Извјештај о очинству'
 WHERE slug = 'paternity-report';

UPDATE lab_tests SET
	name_sr_cyrl = 'Пеницилоил G HSA C1'
 WHERE slug = 'penicilloyl-g-hsa-c1';

UPDATE lab_tests SET
	name_sr_cyrl = 'Пеницилоил G IgE c1'
 WHERE slug = 'penicilloyl-g-ige-c1';

UPDATE lab_tests SET
	name_sr_cyrl = 'Пеницилоил V HSA C2'
 WHERE slug = 'penicilloyl-v-hsa-c2';

UPDATE lab_tests SET
	name_sr_cyrl = 'Пеницилоил V IgE c2'
 WHERE slug = 'penicilloyl-v-ige-c2';

UPDATE lab_tests SET
	name_sr_cyrl = 'Микроскопски преглед перианалног отиска љепљивим целофаном'
 WHERE slug = 'perianal-cellophane-tape-test-pinworm';

UPDATE lab_tests SET
	name_sr = 'Fosfolipid IgG antitijela',
	name_sr_cyrl = 'Фосфолипид IgG антитијела'
 WHERE slug = 'phospholipid-igg-antibodies';

UPDATE lab_tests SET
	name_sr = 'Fosfolipid IgM antitijela',
	name_sr_cyrl = 'Фосфолипид IgM антитијела'
 WHERE slug = 'phospholipid-igm-antibodies';

UPDATE lab_tests SET
	name_sr_cyrl = 'Бактериолошко испитивање исјечка постељице - анаеробно'
 WHERE slug = 'placental-tissue-biopsy-culture-anaerobic';

UPDATE lab_tests SET
	name_sr = 'Trombocitna IgA IgM IgG antitijela',
	name_sr_cyrl = 'Тромбоцитна IgA IgM IgG антитијела'
 WHERE slug = 'platelet-iga-igm-igg-antibodies';

UPDATE lab_tests SET
	name_sr = 'Skrining preeklampsije poslije 12 nedjelja',
	name_sr_cyrl = 'Скрининг прееклампсије послије 12 недјеља'
 WHERE slug = 'preeclampsia-screening-after-12-weeks';

UPDATE lab_tests SET
	name_sr = 'Skrining preeklampsije do 12 nedjelja',
	name_sr_cyrl = 'Скрининг прееклампсије до 12 недјеља'
 WHERE slug = 'preeclampsia-screening-up-to-12-weeks';

UPDATE lab_tests SET
	name_sr = 'Protrombinsko vrijeme PT INR',
	name_sr_cyrl = 'Протромбинско вријеме PT INR'
 WHERE slug = 'prothrombin-time-pt-inr';

UPDATE lab_tests SET
	name_sr_cyrl = 'Протозое тест – Giardia, Cryptosporidium, Entamoeba'
 WHERE slug = 'protozoa-stool-test';

UPDATE lab_tests SET
	name_sr = 'Retikulinska antitijela',
	name_sr_cyrl = 'Ретикулинска антитијела'
 WHERE slug = 'reticulin-antibodies';

UPDATE lab_tests SET
	name_sr = 'Rh antitijela',
	name_sr_cyrl = 'Rh антитијела'
 WHERE slug = 'rh-antibodies';

UPDATE lab_tests SET
	name_sr_cyrl = 'Испитивање Rh фенотипа (гел метода)'
 WHERE slug = 'rh-phenotype-testing-gel-method';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti rubella вирус IgG - Western Blot'
 WHERE slug = 'rubella-igg-western-blot';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti Salmonella гр.A, H антитијела (Vidal) - аглутинација'
 WHERE slug = 'salmonella-group-a-h-antibodies-widal-agglutination';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti Salmonella гр.A, O антитијела (Vidal) - аглутинација'
 WHERE slug = 'salmonella-group-a-o-antibodies-widal-agglutination';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti Salmonella гр.B, H антитијела (Vidal) - аглутинација'
 WHERE slug = 'salmonella-group-b-h-antibodies-widal-agglutination';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti Salmonella гр.B, O антитијела (Vidal) - аглутинација'
 WHERE slug = 'salmonella-group-b-o-antibodies-widal-agglutination';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti Salmonella гр.C, H антитијела (Vidal) - аглутинација'
 WHERE slug = 'salmonella-group-c-h-antibodies-widal-agglutination';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti Salmonella гр.C, O антитијела (Vidal) - аглутинација'
 WHERE slug = 'salmonella-group-c-o-antibodies-widal-agglutination';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti Salmonella гр.D, H антитијела (Vidal) - аглутинација'
 WHERE slug = 'salmonella-group-d-h-antibodies-widal-agglutination';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti Salmonella гр.D, O антитијела (Vidal) - аглутинација'
 WHERE slug = 'salmonella-group-d-o-antibodies-widal-agglutination';

UPDATE lab_tests SET
	name_sr_cyrl = 'Секундарно вријеме крварења'
 WHERE slug = 'secondary-bleeding-time';

UPDATE lab_tests SET
	name_sr_cyrl = 'Серијско испитивање АБО/Rh крвних група — гел техника'
 WHERE slug = 'serial-aborh-blood-group-testing-gel-method';

UPDATE lab_tests SET
	name_sr_cyrl = 'Бактериолошко испитивање бриса танког цријева - аеробно'
 WHERE slug = 'small-intestine-swab-culture-aerobic';

UPDATE lab_tests SET
	name_sr_cyrl = 'Бактериолошко испитивање бриса танког цријева - анаеробно'
 WHERE slug = 'small-intestine-swab-culture-anaerobic';

UPDATE lab_tests SET
	name_sr = 'Antitijela na spermatozoide ASA',
	name_sr_cyrl = 'Антитијела на сперматозоиде ASA'
 WHERE slug = 'spermatozoa-antibodies-asa';

UPDATE lab_tests SET
	name_sr_cyrl = 'Јагода IgE Ф44'
 WHERE slug = 'strawberry-ige-f44';

UPDATE lab_tests SET
	name_sr = 'Trombinsko vrijeme',
	name_sr_cyrl = 'Тромбинско вријеме'
 WHERE slug = 'thrombin-time';

UPDATE lab_tests SET
	name_sr_cyrl = 'Бактериолошко испитивање исјечка ткива - аеробно'
 WHERE slug = 'tissue-biopsy-culture-aerobic';

UPDATE lab_tests SET
	name_sr_cyrl = 'Бактериолошко испитивање исјечка ткива - анаеробно'
 WHERE slug = 'tissue-biopsy-culture-anaerobic';

UPDATE lab_tests SET
	name_sr = 'Toxocara Canis IgM antitijela',
	name_sr_cyrl = 'Toxocara Canis IgM антитијела'
 WHERE slug = 'toxocara-canis-igm-antibodies';

UPDATE lab_tests SET
	name_sr = 'Transglutaminaza IgA antitijela',
	name_sr_cyrl = 'Трансглутаминаза IgA антитијела'
 WHERE slug = 'transglutaminase-iga-antibodies';

UPDATE lab_tests SET
	name_sr = 'Transglutaminaza IgG antitijela',
	name_sr_cyrl = 'Трансглутаминаза IgG антитијела'
 WHERE slug = 'transglutaminase-igg-antibodies';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti Trichinella spiralis антитијела - индиректна имунофлуоресценција'
 WHERE slug = 'trichinella-spiralis-antibodies-indirect-immunofluorescence';

UPDATE lab_tests SET
	name_sr = 'Trichinella Spiralis ukupna antitijela',
	name_sr_cyrl = 'Trichinella Spiralis укупна антитијела'
 WHERE slug = 'trichinella-spiralis-total-antibodies';

UPDATE lab_tests SET
	name_sr_cyrl = 'Тропонин T високе осетљивости'
 WHERE slug = 'troponin-t-hs';

UPDATE lab_tests SET
	name_sr_cyrl = 'Квалитативно одређивање HCG у урину (тест траком)'
 WHERE slug = 'urine-pregnancy-test-hcg-qualitative';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti West Nile вирус IgG - ELISA'
 WHERE slug = 'west-nile-virus-igg-elisa';

UPDATE lab_tests SET
	name_sr_cyrl = 'Anti West Nile вирус IgM - ELISA'
 WHERE slug = 'west-nile-virus-igm-elisa';

UPDATE lab_tests SET
	name_sr = 'Antitijela na ZnT8'
 WHERE slug = 'znt8-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Vreme krvarenja', 'sr' FROM lab_tests WHERE slug = 'bleeding-time'
UNION ALL SELECT id, 'Време крварења', 'sr-cyrl' FROM lab_tests WHERE slug = 'bleeding-time';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Vreme koagulacije', 'sr' FROM lab_tests WHERE slug = 'coagulation-time'
UNION ALL SELECT id, 'Време коагулације', 'sr-cyrl' FROM lab_tests WHERE slug = 'coagulation-time';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Aktivirano parcijalno tromboplastinsko vreme', 'sr' FROM lab_tests WHERE slug = 'activated-partial-thromboplastin-time'
UNION ALL SELECT id, 'Активирано парцијално тромбопластинско време', 'sr-cyrl' FROM lab_tests WHERE slug = 'activated-partial-thromboplastin-time';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Anti-Rh antitela', 'sr' FROM lab_tests WHERE slug = 'anti-rh-antibodies'
UNION ALL SELECT id, 'Анти-Рх антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-rh-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Glukoza posle 180 min', 'sr' FROM lab_tests WHERE slug = 'glucose-after-180-min'
UNION ALL SELECT id, 'Глукоза после 180 мин', 'sr-cyrl' FROM lab_tests WHERE slug = 'glucose-after-180-min';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Glukoza posle 30 min', 'sr' FROM lab_tests WHERE slug = 'glucose-after-30-min'
UNION ALL SELECT id, 'Глукоза после 30 мин', 'sr-cyrl' FROM lab_tests WHERE slug = 'glucose-after-30-min';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na tireopeoksidazu', 'sr' FROM lab_tests WHERE slug = 'anti-tpo'
UNION ALL SELECT id, 'Антитела на тиреопеоксидазу', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-tpo';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Insulin posle 30 min', 'sr' FROM lab_tests WHERE slug = 'insulin-after-30-min'
UNION ALL SELECT id, 'Инсулин после 30 мин', 'sr-cyrl' FROM lab_tests WHERE slug = 'insulin-after-30-min';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Insulin posle 60 min', 'sr' FROM lab_tests WHERE slug = 'insulin-after-60-min'
UNION ALL SELECT id, 'Инсулин после 60 мин', 'sr-cyrl' FROM lab_tests WHERE slug = 'insulin-after-60-min';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Insulin posle 120 min', 'sr' FROM lab_tests WHERE slug = 'insulin-after-120-min'
UNION ALL SELECT id, 'Инсулин после 120 мин', 'sr-cyrl' FROM lab_tests WHERE slug = 'insulin-after-120-min';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Insulin posle 90 min', 'sr' FROM lab_tests WHERE slug = 'insulin-after-90-min'
UNION ALL SELECT id, 'Инсулин после 90 мин', 'sr-cyrl' FROM lab_tests WHERE slug = 'insulin-after-90-min';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Insulin posle 180 min', 'sr' FROM lab_tests WHERE slug = 'insulin-after-180-min'
UNION ALL SELECT id, 'Инсулин после 180 мин', 'sr-cyrl' FROM lab_tests WHERE slug = 'insulin-after-180-min';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'C-peptid posle 30 min', 'sr' FROM lab_tests WHERE slug = 'c-peptide-after-30-min'
UNION ALL SELECT id, 'Ц-пептид после 30 мин', 'sr-cyrl' FROM lab_tests WHERE slug = 'c-peptide-after-30-min';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Insulin posle 240 min', 'sr' FROM lab_tests WHERE slug = 'insulin-after-240-min'
UNION ALL SELECT id, 'Инсулин после 240 мин', 'sr-cyrl' FROM lab_tests WHERE slug = 'insulin-after-240-min';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'C-peptid posle 60 min', 'sr' FROM lab_tests WHERE slug = 'c-peptide-after-60-min'
UNION ALL SELECT id, 'Ц-пептид после 60 мин', 'sr-cyrl' FROM lab_tests WHERE slug = 'c-peptide-after-60-min';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'C-peptid posle 90 min', 'sr' FROM lab_tests WHERE slug = 'c-peptide-after-90-min'
UNION ALL SELECT id, 'Ц-пептид после 90 мин', 'sr-cyrl' FROM lab_tests WHERE slug = 'c-peptide-after-90-min';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'C-peptid posle 120 min', 'sr' FROM lab_tests WHERE slug = 'c-peptide-after-120-min'
UNION ALL SELECT id, 'Ц-пептид после 120 мин', 'sr-cyrl' FROM lab_tests WHERE slug = 'c-peptide-after-120-min';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'C-peptid posle 150 min', 'sr' FROM lab_tests WHERE slug = 'c-peptide-after-150-min'
UNION ALL SELECT id, 'Ц-пептид после 150 мин', 'sr-cyrl' FROM lab_tests WHERE slug = 'c-peptide-after-150-min';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'C-peptid posle 180 min', 'sr' FROM lab_tests WHERE slug = 'c-peptide-after-180-min'
UNION ALL SELECT id, 'Ц-пептид после 180 мин', 'sr-cyrl' FROM lab_tests WHERE slug = 'c-peptide-after-180-min';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na TSH receptor', 'sr' FROM lab_tests WHERE slug = 'anti-tshr'
UNION ALL SELECT id, 'Антитела на TSH рецептор', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-tshr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'HAV ukupna antitela', 'sr' FROM lab_tests WHERE slug = 'hav-total-antibodies'
UNION ALL SELECT id, 'ХАВ укупна антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'hav-total-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Protrombinsko vreme PT INR', 'sr' FROM lab_tests WHERE slug = 'prothrombin-time-pt-inr'
UNION ALL SELECT id, 'Протромбинско време ПТ ИНР', 'sr-cyrl' FROM lab_tests WHERE slug = 'prothrombin-time-pt-inr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Trombinsko vreme', 'sr' FROM lab_tests WHERE slug = 'thrombin-time'
UNION ALL SELECT id, 'Тромбинско време', 'sr-cyrl' FROM lab_tests WHERE slug = 'thrombin-time';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Glukoza pre i 2h posle obroka', 'sr' FROM lab_tests WHERE slug = 'glucose-before-and-2h-after-meal'
UNION ALL SELECT id, 'Глукоза пре и 2х после оброка', 'sr-cyrl' FROM lab_tests WHERE slug = 'glucose-before-and-2h-after-meal';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Rh antitela', 'sr' FROM lab_tests WHERE slug = 'rh-antibodies'
UNION ALL SELECT id, 'Rh антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'rh-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na akvaporin', 'sr' FROM lab_tests WHERE slug = 'aquaporin-antibodies'
UNION ALL SELECT id, 'Антитела на аквапорин', 'sr-cyrl' FROM lab_tests WHERE slug = 'aquaporin-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Nukleozomska antitela', 'sr' FROM lab_tests WHERE slug = 'nucleosomal-antibodies'
UNION ALL SELECT id, 'Нуклеозомска антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'nucleosomal-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'NMDAR antitela u serumu', 'sr' FROM lab_tests WHERE slug = 'nmdar-antibodies-in-serum'
UNION ALL SELECT id, 'НМДАР антитела у серуму', 'sr-cyrl' FROM lab_tests WHERE slug = 'nmdar-antibodies-in-serum';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na tireoglobulin', 'sr' FROM lab_tests WHERE slug = 'anti-thyroglobulin-antibodies'
UNION ALL SELECT id, 'Антитела на тиреоглобулин', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-thyroglobulin-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'dsDNA antitela', 'sr' FROM lab_tests WHERE slug = 'dsdna-antibodies'
UNION ALL SELECT id, 'dsDNA антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'dsdna-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Anti-CCP antitela', 'sr' FROM lab_tests WHERE slug = 'anti-ccp-antibodies'
UNION ALL SELECT id, 'Anti-CCP антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-ccp-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Trombocitna IgA IgM IgG antitela', 'sr' FROM lab_tests WHERE slug = 'platelet-iga-igm-igg-antibodies'
UNION ALL SELECT id, 'Тромбоцитна IgA IgM IgG антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'platelet-iga-igm-igg-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'dsDNA IgG antitela', 'sr' FROM lab_tests WHERE slug = 'dsdna-igg-antibodies'
UNION ALL SELECT id, 'dsDNA IgG антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'dsdna-igg-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Anti-La SSB antitela', 'sr' FROM lab_tests WHERE slug = 'anti-la-ssb-antibodies'
UNION ALL SELECT id, 'Анти-Ла SSB антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-la-ssb-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Anti-Ro SSA antitela', 'sr' FROM lab_tests WHERE slug = 'anti-ro-ssa-antibodies'
UNION ALL SELECT id, 'Анти-Ро SSA антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-ro-ssa-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Anti-Jo-1 antitela', 'sr' FROM lab_tests WHERE slug = 'anti-jo-1-antibodies'
UNION ALL SELECT id, 'Анти-Јо-1 антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-jo-1-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'GBM antitela na bazalnu membranu glomerula', 'sr' FROM lab_tests WHERE slug = 'gbm-antibodies'
UNION ALL SELECT id, 'ГБМ антитела на базалну мембрану гломерула', 'sr-cyrl' FROM lab_tests WHERE slug = 'gbm-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Anti-Scl-70 antitela', 'sr' FROM lab_tests WHERE slug = 'anti-scl-70-antibodies'
UNION ALL SELECT id, 'Анти-Сцл-70 антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-scl-70-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Anti-SM antitela', 'sr' FROM lab_tests WHERE slug = 'anti-sm-antibodies'
UNION ALL SELECT id, 'Анти-СМ антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-sm-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Anti-GAD antitela', 'sr' FROM lab_tests WHERE slug = 'anti-gad-antibodies'
UNION ALL SELECT id, 'Анти-ГАД антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-gad-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'LKM-1 antitela', 'sr' FROM lab_tests WHERE slug = 'lkm-1-antibodies'
UNION ALL SELECT id, 'ЛКМ-1 антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'lkm-1-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na glatke mišiće ASMA', 'sr' FROM lab_tests WHERE slug = 'anti-smooth-muscle-antibodies-asma'
UNION ALL SELECT id, 'Антитела на глатке мишиће АСМА', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-smooth-muscle-antibodies-asma';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'IgE antitela na humani insulin', 'sr' FROM lab_tests WHERE slug = 'ige-antibodies-to-human-insulin'
UNION ALL SELECT id, 'IgE антитела на хумани инсулин', 'sr-cyrl' FROM lab_tests WHERE slug = 'ige-antibodies-to-human-insulin';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na srce ASA', 'sr' FROM lab_tests WHERE slug = 'anti-heart-antibodies-asa'
UNION ALL SELECT id, 'Антитела на срце ASA', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-heart-antibodies-asa';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Centromer protein B antitela', 'sr' FROM lab_tests WHERE slug = 'centromere-protein-b-antibodies'
UNION ALL SELECT id, 'Центромер протеин B антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'centromere-protein-b-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na parijetalne ćelije APA', 'sr' FROM lab_tests WHERE slug = 'anti-parietal-cell-antibodies-apa'
UNION ALL SELECT id, 'Антитела на паријеталне ћелије АПА', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-parietal-cell-antibodies-apa';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na insulin', 'sr' FROM lab_tests WHERE slug = 'anti-insulin-antibodies'
UNION ALL SELECT id, 'Антитела на инсулин', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-insulin-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na srčani mišić', 'sr' FROM lab_tests WHERE slug = 'anti-cardiac-antibodies'
UNION ALL SELECT id, 'Антитела на срчани мишић', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-cardiac-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'IA-2 antitela', 'sr' FROM lab_tests WHERE slug = 'ia-2-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Fosfolipid IgM antitela', 'sr' FROM lab_tests WHERE slug = 'phospholipid-igm-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Fosfolipid IgG antitela', 'sr' FROM lab_tests WHERE slug = 'phospholipid-igg-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na spermatozoide ASA', 'sr' FROM lab_tests WHERE slug = 'spermatozoa-antibodies-asa'
UNION ALL SELECT id, 'Антитела на сперматозоиде ASA', 'sr-cyrl' FROM lab_tests WHERE slug = 'spermatozoa-antibodies-asa';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na jajnike', 'sr' FROM lab_tests WHERE slug = 'ovarian-antibodies'
UNION ALL SELECT id, 'Антитела на јајнике', 'sr-cyrl' FROM lab_tests WHERE slug = 'ovarian-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Transglutaminaza IgA antitela', 'sr' FROM lab_tests WHERE slug = 'transglutaminase-iga-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Transglutaminaza IgG antitela', 'sr' FROM lab_tests WHERE slug = 'transglutaminase-igg-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Glijadin IgA antitela', 'sr' FROM lab_tests WHERE slug = 'gliadin-iga-antibodies'
UNION ALL SELECT id, 'Глијадин IgA антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'gliadin-iga-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Glijadin IgG antitela', 'sr' FROM lab_tests WHERE slug = 'gliadin-igg-antibodies'
UNION ALL SELECT id, 'Глијадин IgG антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'gliadin-igg-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na nadbubrežnu žlezdu', 'sr' FROM lab_tests WHERE slug = 'adrenal-antibodies'
UNION ALL SELECT id, 'Антитела на надбубрежну жлезду', 'sr-cyrl' FROM lab_tests WHERE slug = 'adrenal-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na intrinzički faktor', 'sr' FROM lab_tests WHERE slug = 'intrinsic-factor-antibodies'
UNION ALL SELECT id, 'Антитела на интринзички фактор', 'sr-cyrl' FROM lab_tests WHERE slug = 'intrinsic-factor-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Endomizijalna IgA antitela', 'sr' FROM lab_tests WHERE slug = 'endomysial-iga-antibodies'
UNION ALL SELECT id, 'Ендомизијална IgA антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'endomysial-iga-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na acetilholinski receptor', 'sr' FROM lab_tests WHERE slug = 'acetylcholine-receptor-antibodies'
UNION ALL SELECT id, 'Антитела на ацетилхолински рецептор', 'sr-cyrl' FROM lab_tests WHERE slug = 'acetylcholine-receptor-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'MUSK antitela', 'sr' FROM lab_tests WHERE slug = 'musk-antibodies'
UNION ALL SELECT id, 'МУСК антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'musk-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Neuronska antitela', 'sr' FROM lab_tests WHERE slug = 'neuronal-antibodies'
UNION ALL SELECT id, 'Неуронска антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'neuronal-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Retikulinska antitela', 'sr' FROM lab_tests WHERE slug = 'reticulin-antibodies'
UNION ALL SELECT id, 'Ретикулинска антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'reticulin-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Akvaporin-4 antitela', 'sr' FROM lab_tests WHERE slug = 'aquaporin-4-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'ICA antitela na ostrvske ćelije', 'sr' FROM lab_tests WHERE slug = 'ica-antibodies'
UNION ALL SELECT id, 'ИЦА антитела на острвске ћелије', 'sr-cyrl' FROM lab_tests WHERE slug = 'ica-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Anti-C1q antitela', 'sr' FROM lab_tests WHERE slug = 'anti-c1q-antibodies'
UNION ALL SELECT id, 'Anti-C1q антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-c1q-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'ANA antinuklearna antitela', 'sr' FROM lab_tests WHERE slug = 'ana-antinuclear-antibodies'
UNION ALL SELECT id, 'ANA антинуклеарна антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'ana-antinuclear-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Anti-SLA LP antitela', 'sr' FROM lab_tests WHERE slug = 'anti-sla-lp-antibodies'
UNION ALL SELECT id, 'Анти-СЛА ЛП антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-sla-lp-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'LMA antitela', 'sr' FROM lab_tests WHERE slug = 'lma-antibodies'
UNION ALL SELECT id, 'ЛМА антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'lma-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Lupus antitela', 'sr' FROM lab_tests WHERE slug = 'lupus-antibodies'
UNION ALL SELECT id, 'Лупус антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'lupus-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Mleko IgE f2', 'sr' FROM lab_tests WHERE slug = 'milk-ige-f2'
UNION ALL SELECT id, 'Млеко IgE f2', 'sr-cyrl' FROM lab_tests WHERE slug = 'milk-ige-f2';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Kuvano mleko IgE f231', 'sr' FROM lab_tests WHERE slug = 'cooked-milk-ige-f231'
UNION ALL SELECT id, 'Кувано млеко IgE f231', 'sr-cyrl' FROM lab_tests WHERE slug = 'cooked-milk-ige-f231';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Mleko u prahu IgE f228', 'sr' FROM lab_tests WHERE slug = 'milk-powder-ige-f228'
UNION ALL SELECT id, 'Млеко у праху IgE f228', 'sr-cyrl' FROM lab_tests WHERE slug = 'milk-powder-ige-f228';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Beli luk IgE f47', 'sr' FROM lab_tests WHERE slug = 'garlic-ige-f47'
UNION ALL SELECT id, 'Бели лук IgE f47', 'sr-cyrl' FROM lab_tests WHERE slug = 'garlic-ige-f47';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na adalimumab', 'sr' FROM lab_tests WHERE slug = 'adalimumab-antibodies'
UNION ALL SELECT id, 'Антитела на адалимумаб', 'sr-cyrl' FROM lab_tests WHERE slug = 'adalimumab-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na infliksimab', 'sr' FROM lab_tests WHERE slug = 'infliximab-antibodies'
UNION ALL SELECT id, 'Антитела на инфликсимаб', 'sr-cyrl' FROM lab_tests WHERE slug = 'infliximab-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Skrining preeklampsije do 12 nedelja', 'sr' FROM lab_tests WHERE slug = 'preeclampsia-screening-up-to-12-weeks'
UNION ALL SELECT id, 'Скрининг прееклампсије до 12 недеља', 'sr-cyrl' FROM lab_tests WHERE slug = 'preeclampsia-screening-up-to-12-weeks';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Skrining preeklampsije posle 12 nedelja', 'sr' FROM lab_tests WHERE slug = 'preeclampsia-screening-after-12-weeks'
UNION ALL SELECT id, 'Скрининг прееклампсије после 12 недеља', 'sr-cyrl' FROM lab_tests WHERE slug = 'preeclampsia-screening-after-12-weeks';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Bris levog uha gljivice', 'sr' FROM lab_tests WHERE slug = 'left-ear-swab-fungi'
UNION ALL SELECT id, 'Брис левог уха гљивице', 'sr-cyrl' FROM lab_tests WHERE slug = 'left-ear-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Bris levog oka', 'sr' FROM lab_tests WHERE slug = 'left-eye-swab'
UNION ALL SELECT id, 'Брис левог ока', 'sr-cyrl' FROM lab_tests WHERE slug = 'left-eye-swab';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Bris levog uha bakterije', 'sr' FROM lab_tests WHERE slug = 'left-ear-swab-bacteria'
UNION ALL SELECT id, 'Брис левог уха бактерије', 'sr-cyrl' FROM lab_tests WHERE slug = 'left-ear-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Bris leve bradavice bakterije', 'sr' FROM lab_tests WHERE slug = 'left-nipple-swab-bacteria'
UNION ALL SELECT id, 'Брис леве брадавице бактерије', 'sr-cyrl' FROM lab_tests WHERE slug = 'left-nipple-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Bris levog oka gljivice', 'sr' FROM lab_tests WHERE slug = 'left-eye-swab-fungi'
UNION ALL SELECT id, 'Брис левог ока гљивице', 'sr-cyrl' FROM lab_tests WHERE slug = 'left-eye-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Bris Bartolinove žlezde bakterije', 'sr' FROM lab_tests WHERE slug = 'bartholin-gland-swab-bacteria'
UNION ALL SELECT id, 'Брис Бартолинове жлезде бактерије', 'sr-cyrl' FROM lab_tests WHERE slug = 'bartholin-gland-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Majčino mleko bakterije', 'sr' FROM lab_tests WHERE slug = 'breast-milk-bacteria'
UNION ALL SELECT id, 'Мајчино млеко бактерије', 'sr-cyrl' FROM lab_tests WHERE slug = 'breast-milk-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Majčino mleko gljivice', 'sr' FROM lab_tests WHERE slug = 'breast-milk-fungi'
UNION ALL SELECT id, 'Мајчино млеко гљивице', 'sr-cyrl' FROM lab_tests WHERE slug = 'breast-milk-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Bris Bartolinove žlezde gljivice', 'sr' FROM lab_tests WHERE slug = 'bartholin-gland-swab-fungi'
UNION ALL SELECT id, 'Брис Бартолинове жлезде гљивице', 'sr-cyrl' FROM lab_tests WHERE slug = 'bartholin-gland-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Candida IgM antitela', 'sr' FROM lab_tests WHERE slug = 'candida-igm-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Candida IgG antitela', 'sr' FROM lab_tests WHERE slug = 'candida-igg-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Toxocara Canis IgM antitela', 'sr' FROM lab_tests WHERE slug = 'toxocara-canis-igm-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Leishmania IgM antitela', 'sr' FROM lab_tests WHERE slug = 'leishmania-igm-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Trichinella Spiralis ukupna antitela', 'sr' FROM lab_tests WHERE slug = 'trichinella-spiralis-total-antibodies'
UNION ALL SELECT id, 'Trichinella Spiralis укупна антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'trichinella-spiralis-total-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Izveštaj o očinstvu', 'sr' FROM lab_tests WHERE slug = 'paternity-report'
UNION ALL SELECT id, 'Извештај о очинству', 'sr-cyrl' FROM lab_tests WHERE slug = 'paternity-report';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'ANA ENA profil 15 antitela', 'sr' FROM lab_tests WHERE slug = 'ana-ena-profile-15-antibodies'
UNION ALL SELECT id, 'ANA ENA профил 15 антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'ana-ena-profile-15-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'ANA ENA profil 25 antitela', 'sr' FROM lab_tests WHERE slug = 'ana-ena-profile-25-antibodies'
UNION ALL SELECT id, 'ANA ENA профил 25 антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'ana-ena-profile-25-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'dsDNA IgM antitela', 'sr' FROM lab_tests WHERE slug = 'dsdna-igm-antibodies'
UNION ALL SELECT id, 'dsDNA IgM антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'dsdna-igm-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na ZnT8', 'sr' FROM lab_tests WHERE slug = 'znt8-antibodies'
UNION ALL SELECT id, 'Антитела на ЗнТ8', 'sr-cyrl' FROM lab_tests WHERE slug = 'znt8-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Glukoza posle 60 min', 'sr' FROM lab_tests WHERE slug = 'glucose-after-60-min'
UNION ALL SELECT id, 'Глукоза после 60 мин', 'sr-cyrl' FROM lab_tests WHERE slug = 'glucose-after-60-min';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Glukoza posle 90 min', 'sr' FROM lab_tests WHERE slug = 'glucose-after-90-min'
UNION ALL SELECT id, 'Глукоза после 90 мин', 'sr-cyrl' FROM lab_tests WHERE slug = 'glucose-after-90-min';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Glukoza posle 120 min', 'sr' FROM lab_tests WHERE slug = 'glucose-after-120-min'
UNION ALL SELECT id, 'Глукоза после 120 мин', 'sr-cyrl' FROM lab_tests WHERE slug = 'glucose-after-120-min';

COMMIT;
