-- 047: названия анализов — вычитка и синонимы (шаг 2 из docs/audit/labtest-names-2026-10.md).
--
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/047-labtest-names-review.sql
--
-- Собрано скриптом scripts/services/build-service-names-sql.mjs из
-- data/labtest-names/review-*.json (--catalog lab) — руками не править, пересобирать.
-- Применять ПОСЛЕ 046: значения посчитаны поверх неё.
--
-- Вычитаны анализы, которые есть в трёх клиниках и больше (509 шт.), во всех
-- локалях: обрубки, кальки и латинизмы там, где есть обычное слово, порядок
-- слов из прайса, неверные термины, разнобой внутри серий.
-- Строк: 268. Синонимов: 1367.
--
-- Поиск читает синонимы уже сейчас (server/api/labtests/list.ts) — кода не нужно.
-- sr-cyrl-синонимы получены транслитерацией sr. Синоним, совпадающий с
-- названием другой записи каталога или являющийся подстрокой своего, отброшен.
--
-- Обновление по slug, а не по id. Идемпотентно.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

START TRANSACTION;

UPDATE lab_tests SET
	name_sr = '17-hidroksiprogesteron',
	name_sr_cyrl = '17-хидроксипрогестерон',
	name_tr = '17-Hidroksiprogesteron'
 WHERE slug = '17-hydroxyprogesterone';

UPDATE lab_tests SET
	name_en = 'Acarus siro IgE d2',
	name_sr = 'Acarus siro IgE d2',
	name_sr_cyrl = 'Acarus siro IgE d2',
	name_ru = 'Acarus siro IgE d2',
	name_de = 'Acarus siro IgE d2',
	name_tr = 'Acarus siro IgE d2'
 WHERE slug = 'acarus-siro-ige-d2';

UPDATE lab_tests SET
	name_sr = 'Aviditet IgG antitijela na adenovirus',
	name_sr_cyrl = 'Авидитет IgG антитијела на аденовирус',
	name_ru = 'Авидность антител IgG к аденовирусу'
 WHERE slug = 'adenovirus-igg-avidity';

UPDATE lab_tests SET
	name_en = 'Adenovirus Respiratory Test (Nasal Swab)',
	name_ru = 'Тест на аденовирус (мазок из носа)',
	name_de = 'Adenovirus-Atemwegstest (Nasenabstrich)',
	name_tr = 'Adenovirüs Solunum Testi (Burun Sürüntüsü)'
 WHERE slug = 'adenovirus-respiratory-test';

UPDATE lab_tests SET
	name_en = 'Adenovirus and Rotavirus in Stool',
	name_sr = 'Adenovirus i rotavirus u stolici',
	name_sr_cyrl = 'Аденовирус и ротавирус у столици',
	name_ru = 'Аденовирус и ротавирус в кале',
	name_de = 'Adenovirus und Rotavirus im Stuhl',
	name_tr = 'Gaitada Adenovirüs ve Rotavirüs'
 WHERE slug = 'adenovirus-rotavirus-in-stool';

UPDATE lab_tests SET
	name_en = 'Ambrosia elatior IgE w1',
	name_de = 'Ambrosia elatior IgE w1'
 WHERE slug = 'ambrosia-elatior-ige-w1';

UPDATE lab_tests SET
	name_ru = 'Антитела к GAD'
 WHERE slug = 'anti-gad-antibodies';

UPDATE lab_tests SET
	name_ru = 'Аллергопанель на антибиотики (10 аллергенов)'
 WHERE slug = 'antibiotic-allergy-panel-10-allergens';

UPDATE lab_tests SET
	name_ru = 'Антитела к кардиолипину IgG'
 WHERE slug = 'anticardiolipin-igg';

UPDATE lab_tests SET
	name_ru = 'Антитела к кардиолипину IgM'
 WHERE slug = 'anticardiolipin-igm';

UPDATE lab_tests SET
	name_sr = 'Detekcija antimikrobnih antitijela lateks aglutinacionim testom',
	name_sr_cyrl = 'Детекција антимикробних антитијела латекс аглутинационим тестом'
 WHERE slug = 'antimicrobial-antibody-detection-by-latex-agglutination';

UPDATE lab_tests SET
	name_ru = 'Делеции Y-хромосомы (AZF)',
	name_de = 'AZF-Deletionen des Y-Chromosoms',
	name_tr = 'Y Kromozomu AZF Delesyonları'
 WHERE slug = 'azf-y-chromosome-deletions';

UPDATE lab_tests SET
	name_en = 'Bacteriological Examination of Ear Swab',
	name_sr = 'Bakteriološki pregled brisa uha',
	name_sr_cyrl = 'Бактериолошки преглед бриса уха',
	name_de = 'Bakteriologische Untersuchung des Ohrabstrichs'
 WHERE slug = 'bacteriological-examination-ear-swab';

UPDATE lab_tests SET
	name_en = 'Bartonella henselae IgG',
	name_sr = 'Bartonella henselae IgG',
	name_sr_cyrl = 'Bartonella henselae IgG',
	name_ru = 'Bartonella henselae IgG',
	name_de = 'Bartonella henselae IgG',
	name_tr = 'Bartonella henselae IgG'
 WHERE slug = 'bartonella-henselae-igg';

UPDATE lab_tests SET
	name_en = 'Bartonella henselae IgM',
	name_sr = 'Bartonella henselae IgM',
	name_sr_cyrl = 'Bartonella henselae IgM',
	name_ru = 'Bartonella henselae IgM',
	name_de = 'Bartonella henselae IgM',
	name_tr = 'Bartonella henselae IgM'
 WHERE slug = 'bartonella-henselae-igm';

UPDATE lab_tests SET
	name_en = 'Bartonella quintana IgG',
	name_sr = 'Bartonella quintana IgG',
	name_sr_cyrl = 'Bartonella quintana IgG',
	name_ru = 'Bartonella quintana IgG',
	name_de = 'Bartonella quintana IgG',
	name_tr = 'Bartonella quintana IgG'
 WHERE slug = 'bartonella-quintana-igg';

UPDATE lab_tests SET
	name_en = 'Bartonella quintana IgM',
	name_sr = 'Bartonella quintana IgM',
	name_sr_cyrl = 'Bartonella quintana IgM',
	name_ru = 'Bartonella quintana IgM',
	name_de = 'Bartonella quintana IgM',
	name_tr = 'Bartonella quintana IgM'
 WHERE slug = 'bartonella-quintana-igm';

UPDATE lab_tests SET
	name_ru = 'Антитела к бета-2 гликопротеину I IgG'
 WHERE slug = 'beta-2-glycoprotein-i-igg';

UPDATE lab_tests SET
	name_ru = 'Антитела к бета-2 гликопротеину I IgM'
 WHERE slug = 'beta-2-glycoprotein-i-igm';

UPDATE lab_tests SET
	name_ru = 'Время кровотечения и свертывания'
 WHERE slug = 'bleeding-and-coagulation-time';

UPDATE lab_tests SET
	name_en = 'Selected Blood Count Parameters',
	name_ru = 'Отдельные показатели анализа крови'
 WHERE slug = 'blood-count-selected-parameters';

UPDATE lab_tests SET
	name_en = 'Bordetella pertussis IgA',
	name_sr = 'Bordetella pertussis IgA',
	name_sr_cyrl = 'Bordetella pertussis IgA',
	name_ru = 'Bordetella pertussis IgA',
	name_de = 'Bordetella pertussis IgA',
	name_tr = 'Bordetella pertussis IgA'
 WHERE slug = 'bordetella-pertussis-iga';

UPDATE lab_tests SET
	name_en = 'Bordetella pertussis IgG',
	name_sr = 'Bordetella pertussis IgG',
	name_sr_cyrl = 'Bordetella pertussis IgG',
	name_ru = 'Антитела к Bordetella pertussis IgG',
	name_de = 'Bordetella pertussis IgG',
	name_tr = 'Bordetella pertussis IgG'
 WHERE slug = 'bordetella-pertussis-igg';

UPDATE lab_tests SET
	name_en = 'Bordetella pertussis Nasopharyngeal Swab Culture Aerobic'
 WHERE slug = 'bordetella-pertussis-nasopharyngeal-swab-culture-aerobic';

UPDATE lab_tests SET
	name_en = 'Bordetella pertussis PCR',
	name_sr = 'Bordetella pertussis PCR',
	name_sr_cyrl = 'Bordetella pertussis PCR',
	name_ru = 'Bordetella pertussis ПЦР',
	name_de = 'Bordetella pertussis PCR',
	name_tr = 'Bordetella pertussis PCR'
 WHERE slug = 'bordetella-pertussis-pcr';

UPDATE lab_tests SET
	name_en = 'Borrelia burgdorferi IgG',
	name_sr = 'Borrelia burgdorferi IgG',
	name_sr_cyrl = 'Borrelia burgdorferi IgG',
	name_ru = 'Антитела к Borrelia burgdorferi IgG',
	name_de = 'Borrelia burgdorferi IgG',
	name_tr = 'Borrelia burgdorferi IgG'
 WHERE slug = 'borrelia-burgdorferi-igg';

UPDATE lab_tests SET
	name_en = 'Borrelia burgdorferi IgG IgM Panel'
 WHERE slug = 'borrelia-burgdorferi-igg-igm-panel';

UPDATE lab_tests SET
	name_en = 'Borrelia burgdorferi IgG Western Blot',
	name_sr = 'Borrelia burgdorferi IgG Western Blot',
	name_sr_cyrl = 'Borrelia burgdorferi IgG Western Blot',
	name_ru = 'Антитела к Borrelia burgdorferi IgG (вестерн-блот)',
	name_de = 'Borrelia burgdorferi IgG Western-Blot',
	name_tr = 'Borrelia burgdorferi IgG Western Blot'
 WHERE slug = 'borrelia-burgdorferi-igg-western-blot';

UPDATE lab_tests SET
	name_en = 'Borrelia burgdorferi IgM',
	name_sr = 'Borrelia burgdorferi IgM',
	name_sr_cyrl = 'Borrelia burgdorferi IgM',
	name_ru = 'Антитела к Borrelia burgdorferi IgM',
	name_de = 'Borrelia burgdorferi IgM',
	name_tr = 'Borrelia burgdorferi IgM'
 WHERE slug = 'borrelia-burgdorferi-igm';

UPDATE lab_tests SET
	name_en = 'Borrelia burgdorferi IgM Western Blot',
	name_sr = 'Borrelia burgdorferi IgM Western Blot',
	name_sr_cyrl = 'Borrelia burgdorferi IgM Western Blot',
	name_ru = 'Антитела к Borrelia burgdorferi IgM (вестерн-блот)',
	name_de = 'Borrelia burgdorferi IgM Western-Blot',
	name_tr = 'Borrelia burgdorferi IgM Western Blot'
 WHERE slug = 'borrelia-burgdorferi-igm-western-blot';

UPDATE lab_tests SET
	name_en = 'Borrelia burgdorferi PCR',
	name_sr = 'Borrelia burgdorferi PCR',
	name_sr_cyrl = 'Borrelia burgdorferi PCR',
	name_ru = 'Borrelia burgdorferi ПЦР',
	name_de = 'Borrelia burgdorferi PCR',
	name_tr = 'Borrelia burgdorferi PCR'
 WHERE slug = 'borrelia-burgdorferi-pcr';

UPDATE lab_tests SET
	name_tr = 'BRCA1 / BRCA2 Genetik Testi'
 WHERE slug = 'brca1-brca2-genetic-test';

UPDATE lab_tests SET
	name_en = 'Breast Swab for Bacteria',
	name_sr = 'Bris dojke na bakterije',
	name_sr_cyrl = 'Брис дојке на бактерије',
	name_ru = 'Мазок с молочной железы на бактерии',
	name_de = 'Brustabstrich auf Bakterien',
	name_tr = 'Meme Sürüntüsünde Bakteri'
 WHERE slug = 'breast-swab-bacteria';

UPDATE lab_tests SET
	name_en = 'Breast Swab for Fungi',
	name_sr = 'Bris dojke na gljivice',
	name_sr_cyrl = 'Брис дојке на гљивице',
	name_ru = 'Мазок с молочной железы на грибы',
	name_de = 'Brustabstrich auf Pilze',
	name_tr = 'Meme Sürüntüsünde Mantar'
 WHERE slug = 'breast-swab-fungi';

UPDATE lab_tests SET
	name_en = 'Brucella abortus Antibodies (Agglutination)'
 WHERE slug = 'brucella-abortus-antibodies-agglutination';

UPDATE lab_tests SET
	name_sr = 'Brucella IgM',
	name_sr_cyrl = 'Brucella IgM',
	name_ru = 'Антитела к Brucella IgM'
 WHERE slug = 'brucella-igm';

UPDATE lab_tests SET
	name_ru = 'Посев на Campylobacter',
	name_de = 'Campylobacter-Kultur',
	name_tr = 'Campylobacter kültürü'
 WHERE slug = 'campylobacter-culture';

UPDATE lab_tests SET
	name_ru = 'Тест на Campylobacter (кал)',
	name_de = 'Campylobacter-Stuhltest'
 WHERE slug = 'campylobacter-stool-test';

UPDATE lab_tests SET
	name_en = 'Candida albicans PCR'
 WHERE slug = 'candida-albicans-pcr';

UPDATE lab_tests SET
	name_ru = 'Candida (культура)',
	name_de = 'Candida-Kultur',
	name_tr = 'Candida Kültürü'
 WHERE slug = 'candida-culture';

UPDATE lab_tests SET
	name_ru = 'Антитела к Candida IgG'
 WHERE slug = 'candida-igg-antibodies';

UPDATE lab_tests SET
	name_ru = 'Антитела к Candida IgM'
 WHERE slug = 'candida-igm-antibodies';

UPDATE lab_tests SET
	name_en = 'Cervical Swab for Bacteria',
	name_sr = 'Bris cerviksa na bakterije',
	name_sr_cyrl = 'Брис цервикса на бактерије',
	name_ru = 'Мазок из шейки матки на бактерии',
	name_de = 'Zervixabstrich auf Bakterien',
	name_tr = 'Servikal Sürüntüde Bakteri'
 WHERE slug = 'cervical-swab-bacteria';

UPDATE lab_tests SET
	name_en = 'Cervical Swab for Fungi',
	name_sr = 'Bris cerviksa na gljivice',
	name_sr_cyrl = 'Брис цервикса на гљивице',
	name_ru = 'Мазок из шейки матки на грибы',
	name_de = 'Zervixabstrich auf Pilze',
	name_tr = 'Servikal Sürüntüde Mantar'
 WHERE slug = 'cervical-swab-fungi';

UPDATE lab_tests SET
	name_en = 'Chenopodium album IgE w10',
	name_sr = 'Loboda Chenopodium album IgE w10',
	name_sr_cyrl = 'Лобода Chenopodium album IgE w10',
	name_ru = 'Марь белая Chenopodium album IgE w10',
	name_tr = 'Sirken Chenopodium album IgE w10'
 WHERE slug = 'chenopodium-album-ige-w10';

UPDATE lab_tests SET
	name_en = 'Chlamydia trachomatis Genital Swab',
	name_ru = 'Chlamydia trachomatis – мазок из половых путей',
	name_de = 'Chlamydia trachomatis – Genitalabstrich',
	name_tr = 'Chlamydia trachomatis – Genital Sürüntü'
 WHERE slug = 'chlamydia-genital-swab';

UPDATE lab_tests SET
	name_en = 'Chlamydia pneumoniae IgG',
	name_sr = 'Chlamydia pneumoniae IgG',
	name_sr_cyrl = 'Chlamydia pneumoniae IgG',
	name_ru = 'Chlamydia pneumoniae IgG',
	name_de = 'Chlamydia pneumoniae IgG',
	name_tr = 'Chlamydia pneumoniae IgG'
 WHERE slug = 'chlamydia-pneumoniae-igg';

UPDATE lab_tests SET
	name_en = 'Chlamydia pneumoniae IgM',
	name_sr = 'Chlamydia pneumoniae IgM',
	name_sr_cyrl = 'Chlamydia pneumoniae IgM',
	name_ru = 'Chlamydia pneumoniae IgM',
	name_de = 'Chlamydia pneumoniae IgM',
	name_tr = 'Chlamydia pneumoniae IgM'
 WHERE slug = 'chlamydia-pneumoniae-igm';

UPDATE lab_tests SET
	name_en = 'Chlamydia trachomatis Culture'
 WHERE slug = 'chlamydia-trachomatis-culture';

UPDATE lab_tests SET
	name_en = 'Chlamydia trachomatis IgG',
	name_sr = 'Chlamydia trachomatis IgG',
	name_sr_cyrl = 'Chlamydia trachomatis IgG',
	name_ru = 'Chlamydia trachomatis IgG',
	name_de = 'Chlamydia trachomatis IgG',
	name_tr = 'Chlamydia trachomatis IgG'
 WHERE slug = 'chlamydia-trachomatis-igg';

UPDATE lab_tests SET
	name_en = 'Chlamydia trachomatis IgM',
	name_sr = 'Chlamydia trachomatis IgM',
	name_sr_cyrl = 'Chlamydia trachomatis IgM',
	name_ru = 'Chlamydia trachomatis IgM',
	name_de = 'Chlamydia trachomatis IgM',
	name_tr = 'Chlamydia trachomatis IgM'
 WHERE slug = 'chlamydia-trachomatis-igm';

UPDATE lab_tests SET
	name_en = 'Chlamydia trachomatis IHT',
	name_sr = 'Chlamydia trachomatis IHT',
	name_sr_cyrl = 'Chlamydia trachomatis IHT',
	name_ru = 'Chlamydia trachomatis ИХТ',
	name_de = 'Chlamydia trachomatis IHT',
	name_tr = 'Chlamydia trachomatis IHT'
 WHERE slug = 'chlamydia-trachomatis-iht';

UPDATE lab_tests SET
	name_en = 'Chlamydia trachomatis + Mycoplasma hominis/genitalium PCR'
 WHERE slug = 'chlamydia-trachomatis-mycoplasma-hominis-genitalium-pcr';

UPDATE lab_tests SET
	name_en = 'Chlamydia trachomatis PCR Swab'
 WHERE slug = 'chlamydia-trachomatis-pcr-swab';

UPDATE lab_tests SET
	name_en = 'Chlamydia trachomatis PCR in Urine',
	name_sr = 'Chlamydia trachomatis PCR u urinu',
	name_sr_cyrl = 'Chlamydia trachomatis PCR у урину',
	name_ru = 'Chlamydia trachomatis ПЦР в моче',
	name_de = 'Chlamydia trachomatis PCR im Urin',
	name_tr = 'İdrarda Chlamydia trachomatis PCR'
 WHERE slug = 'chlamydia-trachomatis-pcr-urine';

UPDATE lab_tests SET
	name_en = 'Chlamydia trachomatis + Ureaplasma',
	name_sr = 'Chlamydia trachomatis + Ureaplasma',
	name_sr_cyrl = 'Chlamydia trachomatis + Ureaplasma',
	name_ru = 'Chlamydia trachomatis и Ureaplasma',
	name_de = 'Chlamydia trachomatis + Ureaplasma',
	name_tr = 'Chlamydia trachomatis + Ureaplasma'
 WHERE slug = 'chlamydia-trachomatis-plus-ureaplasma';

UPDATE lab_tests SET
	name_en = 'Chlamydia trachomatis + Ureaplasma urealyticum + Mycoplasma hominis/genitalium PCR'
 WHERE slug = 'chlamydia-trachomatis-ureaplasma-urealyticum-mycoplasma-hominis-genitalium-pcr';

UPDATE lab_tests SET
	name_en = 'Clostridium difficile Toxin A and B',
	name_sr = 'Clostridium difficile toksin A i B',
	name_sr_cyrl = 'Clostridium difficile токсин A и B',
	name_ru = 'Clostridium difficile – токсин A и B',
	name_de = 'Clostridium difficile Toxin A und B',
	name_tr = 'Clostridium difficile Toksin A ve B'
 WHERE slug = 'clostridium-difficile-toxin-a-and-b';

UPDATE lab_tests SET
	name_en = 'Clostridium difficile Toxin AB',
	name_ru = 'Clostridium difficile – токсин A+B',
	name_tr = 'Clostridium difficile Toksin A+B'
 WHERE slug = 'clostridium-difficile-toxin-ab';

UPDATE lab_tests SET
	name_sr = 'Aviditet IgG antitijela na CMV',
	name_sr_cyrl = 'Авидитет IgG антитијела на CMV',
	name_ru = 'Авидность антител IgG к ЦМВ',
	name_de = 'CMV-Avidität'
 WHERE slug = 'cmv-avidity';

UPDATE lab_tests SET
	name_de = 'Kleines Blutbild'
 WHERE slug = 'complete-blood-count';

UPDATE lab_tests SET
	name_de = 'Großes Blutbild (mit Differentialblutbild)'
 WHERE slug = 'complete-blood-count-with-leukocyte-formula';

UPDATE lab_tests SET
	name_sr = 'Kompletan pregled urina (test traka + protočna citometrija sedimenta)',
	name_sr_cyrl = 'Комплетан преглед урина (тест трака + проточна цитометрија седимента)'
 WHERE slug = 'complete-urinalysis-with-flow-cytometry';

UPDATE lab_tests SET
	name_en = 'Coxiella burnetii IgA Phase 1 ELISA'
 WHERE slug = 'coxiella-burnetii-iga-phase-1-elisa';

UPDATE lab_tests SET
	name_en = 'Coxiella burnetii IgG Phase 1 ELISA'
 WHERE slug = 'coxiella-burnetii-igg-phase-1-elisa';

UPDATE lab_tests SET
	name_en = 'Coxiella burnetii IgG Phase 2 ELISA'
 WHERE slug = 'coxiella-burnetii-igg-phase-2-elisa';

UPDATE lab_tests SET
	name_en = 'Coxiella burnetii IgM Phase 2 ELISA'
 WHERE slug = 'coxiella-burnetii-igm-phase-2-elisa';

UPDATE lab_tests SET
	name_en = 'Crab f24',
	name_sr = 'Rak f24',
	name_sr_cyrl = 'Рак f24',
	name_ru = 'Креветка f24',
	name_de = 'Krabbe f24',
	name_tr = 'Yengeç f24'
 WHERE slug = 'crab-f24';

UPDATE lab_tests SET
	name_en = 'Dactylis glomerata IgE g3',
	name_sr = 'Ježeva glavica Dactylis glomerata IgE g3',
	name_sr_cyrl = 'Јежева главица Dactylis glomerata IgE g3',
	name_ru = 'Ежа сборная Dactylis glomerata IgE g3',
	name_de = 'Dactylis glomerata IgE g3',
	name_tr = 'Domuz Ayrığı Dactylis glomerata IgE g3'
 WHERE slug = 'dactylis-glomerata-ige-g3';

UPDATE lab_tests SET
	name_sr = 'Pregled na Demodex',
	name_sr_cyrl = 'Преглед на Demodex',
	name_ru = 'Исследование на Demodex',
	name_de = 'Untersuchung auf Demodex',
	name_tr = 'Demodex incelemesi'
 WHERE slug = 'demodex-species';

UPDATE lab_tests SET
	name_en = 'Dermatomycosis (Nails, Hair, Skin) – NMP',
	name_de = 'Dermatomykosen (Nägel, Haare, Haut) – NMP',
	name_tr = 'Dermatomikoz (Tırnak, Saç, Cilt) – NMP'
 WHERE slug = 'dermatomycosis-nmp';

UPDATE lab_tests SET
	name_de = 'Dermatophyten-Kultur',
	name_tr = 'Dermatofit Kültürü'
 WHERE slug = 'dermatophytes-culture';

UPDATE lab_tests SET
	name_en = 'Hair Scraping for Dermatophytes',
	name_de = 'Haarabschabung auf Dermatophyten'
 WHERE slug = 'dermatophytes-hair-scraping';

UPDATE lab_tests SET
	name_en = 'Nail Scraping for Dermatophytes',
	name_sr = 'Strugotina nokta na dermatofite',
	name_sr_cyrl = 'Струготина нокта на дерматофите',
	name_ru = 'Соскоб ногтя на дерматофиты',
	name_de = 'Nagelabschabung auf Dermatophyten',
	name_tr = 'Tırnak Kazıntısında Dermatofit'
 WHERE slug = 'dermatophytes-nail-scraping';

UPDATE lab_tests SET
	name_en = 'Skin Scraping for Dermatophytes',
	name_sr = 'Strugotina kože na dermatofite',
	name_sr_cyrl = 'Струготина коже на дерматофите',
	name_ru = 'Соскоб кожи на дерматофиты',
	name_de = 'Hautabschabung auf Dermatophyten',
	name_tr = 'Cilt Kazıntısında Dermatofit'
 WHERE slug = 'dermatophytes-skin-scraping';

UPDATE lab_tests SET
	name_de = 'Direktes mikroskopisches Präparat'
 WHERE slug = 'direct-microscopic-preparation';

UPDATE lab_tests SET
	name_sr = 'Dabl test (biohemijski skrining 1. trimestra)',
	name_sr_cyrl = 'Дабл тест (биохемијски скрининг 1. триместра)',
	name_tr = 'İkili Test (1. Trimester Taraması)'
 WHERE slug = 'double-test-first-trimester-screening';

UPDATE lab_tests SET
	name_tr = 'Uyuşturucu Paneli 10'
 WHERE slug = 'drug-panel-10';

UPDATE lab_tests SET
	name_tr = 'Uyuşturucu Paneli 10 II'
 WHERE slug = 'drug-panel-10-ii';

UPDATE lab_tests SET
	name_tr = 'Uyuşturucu Paneli 5 Yeni'
 WHERE slug = 'drug-panel-5-new';

UPDATE lab_tests SET
	name_ru = 'Антитела к дсДНК IgG'
 WHERE slug = 'dsdna-igg-antibodies';

UPDATE lab_tests SET
	name_ru = 'Антитела к дсДНК IgM'
 WHERE slug = 'dsdna-igm-antibodies';

UPDATE lab_tests SET
	name_en = 'Ear Swab for Bacteria',
	name_sr = 'Bris uha na bakterije',
	name_sr_cyrl = 'Брис уха на бактерије',
	name_ru = 'Мазок из уха на бактерии',
	name_de = 'Ohrabstrich auf Bakterien',
	name_tr = 'Kulak Sürüntüsünde Bakteri'
 WHERE slug = 'ear-swab-bacteria';

UPDATE lab_tests SET
	name_en = 'Ear Swab for Fungi',
	name_sr = 'Bris uha na gljivice',
	name_sr_cyrl = 'Брис уха на гљивице',
	name_ru = 'Мазок из уха на грибы',
	name_de = 'Ohrabstrich auf Pilze',
	name_tr = 'Kulak Sürüntüsünde Mantar'
 WHERE slug = 'ear-swab-fungi';

UPDATE lab_tests SET
	name_en = 'Echinococcus granulosus Antibodies (Indirect Hemagglutination)'
 WHERE slug = 'echinococcus-granulosus-antibodies-indirect-hemagglutination';

UPDATE lab_tests SET
	name_ru = 'Антитела к Echinococcus IgG (ИФА)'
 WHERE slug = 'echinococcus-igg-elisa';

UPDATE lab_tests SET
	name_en = 'Egg Mix rf245',
	name_sr = 'Miks jaja rf245',
	name_sr_cyrl = 'Микс јаја rf245',
	name_ru = 'Яичная смесь rf245',
	name_de = 'Ei-Mix rf245',
	name_tr = 'Yumurta Karışımı rf245'
 WHERE slug = 'egg-mix-rf245';

UPDATE lab_tests SET
	name_en = 'Entamoeba histolytica IHT',
	name_sr = 'Entamoeba histolytica IHT',
	name_sr_cyrl = 'Entamoeba histolytica IHT',
	name_ru = 'Entamoeba histolytica ИХТ',
	name_de = 'Entamoeba histolytica IHT',
	name_tr = 'Entamoeba histolytica IHT'
 WHERE slug = 'entamoeba-histolytica-iht';

UPDATE lab_tests SET
	name_ru = 'Вирус Эпштейна-Барр IgG'
 WHERE slug = 'epstein-barr-igg';

UPDATE lab_tests SET
	name_sr = 'Aviditet IgG antitijela na Epstein-Barr virus',
	name_sr_cyrl = 'Авидитет IgG антитијела на Epstein-Barr вирус',
	name_ru = 'Авидность антител IgG к вирусу Эпштейна–Барр'
 WHERE slug = 'epstein-barr-igg-avidity';

UPDATE lab_tests SET
	name_ru = 'Вирус Эпштейна-Барр IgM'
 WHERE slug = 'epstein-barr-igm';

UPDATE lab_tests SET
	name_en = 'Erythrocyte Osmotic Resistance',
	name_de = 'Osmotische Erythrozytenresistenz',
	name_tr = 'Eritrosit Ozmotik Direnci'
 WHERE slug = 'erythrocyte-resistance';

UPDATE lab_tests SET
	name_en = 'Eye Swab for Bacteria',
	name_sr = 'Bris oka na bakterije',
	name_sr_cyrl = 'Брис ока на бактерије',
	name_ru = 'Мазок из глаза на бактерии',
	name_de = 'Augenabstrich auf Bakterien',
	name_tr = 'Göz Sürüntüsünde Bakteri'
 WHERE slug = 'eye-swab-bacteria';

UPDATE lab_tests SET
	name_en = 'Eye Swab for Fungi',
	name_sr = 'Bris oka na gljivice',
	name_sr_cyrl = 'Брис ока на гљивице',
	name_ru = 'Мазок из глаза на грибы',
	name_de = 'Augenabstrich auf Pilze',
	name_tr = 'Göz Sürüntüsünde Mantar'
 WHERE slug = 'eye-swab-fungi';

UPDATE lab_tests SET
	name_ru = 'Пищевая аллергопанель (30 аллергенов)'
 WHERE slug = 'food-allergy-panel-30-allergens';

UPDATE lab_tests SET
	name_ru = 'Панель пищевой непереносимости (90 продуктов)'
 WHERE slug = 'food-intolerance-panel-90-foods';

UPDATE lab_tests SET
	name_tr = 'Fruktozamin'
 WHERE slug = 'fructosamine';

UPDATE lab_tests SET
	name_en = 'Giardia lamblia IHT',
	name_sr = 'Giardia lamblia IHT',
	name_sr_cyrl = 'Giardia lamblia IHT',
	name_ru = 'Giardia lamblia ИХТ',
	name_de = 'Giardia lamblia IHT',
	name_tr = 'Giardia lamblia IHT'
 WHERE slug = 'giardia-lamblia-iht';

UPDATE lab_tests SET
	name_en = 'Glans Swab for Bacteria',
	name_sr = 'Bris glansa na bakterije',
	name_sr_cyrl = 'Брис гланса на бактерије',
	name_ru = 'Мазок с головки полового члена на бактерии',
	name_de = 'Glans-Abstrich auf Bakterien',
	name_tr = 'Glans Sürüntüsünde Bakteri'
 WHERE slug = 'glans-swab-bacteria';

UPDATE lab_tests SET
	name_en = 'Glans Swab for Fungi',
	name_sr = 'Bris glansa na gljivice',
	name_sr_cyrl = 'Брис гланса на гљивице',
	name_ru = 'Мазок с головки полового члена на грибы',
	name_de = 'Glans-Abstrich auf Pilze',
	name_tr = 'Glans Sürüntüsünde Mantar'
 WHERE slug = 'glans-swab-fungi';

UPDATE lab_tests SET
	name_ru = 'Антитела к глиадину IgA'
 WHERE slug = 'gliadin-iga-antibodies';

UPDATE lab_tests SET
	name_ru = 'Антитела к глиадину IgG'
 WHERE slug = 'gliadin-igg-antibodies';

UPDATE lab_tests SET
	name_en = 'Hair Swab for Fungi',
	name_ru = 'Посев мазка с волос на грибки',
	name_de = 'Haarabstrich auf Pilze',
	name_tr = 'Saç Sürüntüsünde Mantar'
 WHERE slug = 'hair-swab-fungi';

UPDATE lab_tests SET
	name_ru = 'Гепатит А IgM'
 WHERE slug = 'hav-igm';

UPDATE lab_tests SET
	name_en = 'Helicobacter pylori Antibodies',
	name_sr = 'Antitijela na Helicobacter pylori',
	name_sr_cyrl = 'Антитијела на Helicobacter pylori',
	name_ru = 'Антитела к Helicobacter pylori',
	name_de = 'Helicobacter-pylori-Antikörper',
	name_tr = 'Helicobacter pylori Antikorları'
 WHERE slug = 'helicobacter-pylori';

UPDATE lab_tests SET
	name_en = 'Helicobacter pylori Antigen in Feces',
	name_sr = 'Helicobacter pylori antigen u fecesu',
	name_sr_cyrl = 'Helicobacter pylori антиген у фецесу',
	name_ru = 'Антиген Helicobacter pylori в кале',
	name_de = 'Helicobacter pylori Antigen im Stuhl',
	name_tr = 'Gaitada Helicobacter pylori Antijeni'
 WHERE slug = 'helicobacter-pylori-antigen-in-feces';

UPDATE lab_tests SET
	name_en = 'Helicobacter pylori IgA',
	name_sr = 'Helicobacter pylori IgA',
	name_sr_cyrl = 'Helicobacter pylori IgA',
	name_ru = 'Антитела к Helicobacter pylori IgA',
	name_de = 'Helicobacter pylori IgA',
	name_tr = 'Helicobacter pylori IgA'
 WHERE slug = 'helicobacter-pylori-iga';

UPDATE lab_tests SET
	name_en = 'Helicobacter pylori IgG',
	name_sr = 'Helicobacter pylori IgG',
	name_sr_cyrl = 'Helicobacter pylori IgG',
	name_ru = 'Антитела к Helicobacter pylori IgG',
	name_de = 'Helicobacter pylori IgG',
	name_tr = 'Helicobacter pylori IgG'
 WHERE slug = 'helicobacter-pylori-igg';

UPDATE lab_tests SET
	name_en = 'Helicobacter pylori IgG IgA Panel'
 WHERE slug = 'helicobacter-pylori-igg-iga-panel';

UPDATE lab_tests SET
	name_ru = 'Гепатит Е'
 WHERE slug = 'hev';

UPDATE lab_tests SET
	name_sr = 'PH Pregled polipa grlića materice',
	name_sr_cyrl = 'ПХ Преглед полипа грлића материце',
	name_ru = 'Патогистологическое исследование полипа шейки матки'
 WHERE slug = 'histopathology-cervical-polyp-examination';

UPDATE lab_tests SET
	name_ru = 'Патогистологическое исследование биопсии толстой кишки'
 WHERE slug = 'histopathology-colon-biopsy';

UPDATE lab_tests SET
	name_ru = 'Патогистологическое исследование биопсии двенадцатиперстной кишки'
 WHERE slug = 'histopathology-duodenum-biopsy';

UPDATE lab_tests SET
	name_ru = 'Патогистологическое исследование биопсии средостения'
 WHERE slug = 'histopathology-mediastinum-biopsy';

UPDATE lab_tests SET
	name_sr = 'PH Iglena biopsija prostate više uzoraka',
	name_sr_cyrl = 'ПХ Иглена биопсија простате више узорака'
 WHERE slug = 'histopathology-needle-prostate-biopsy-multiple-samples';

UPDATE lab_tests SET
	name_sr = 'PH Pregled testisa (orhiektomija)',
	name_sr_cyrl = 'ПХ Преглед тестиса (орхиектомија)',
	name_ru = 'Патогистологическое исследование удаленного яичка (орхиэктомия)'
 WHERE slug = 'histopathology-orchiectomy-testis-examination';

UPDATE lab_tests SET
	name_de = 'Histopathologie Untersuchung der entfernten Brust'
 WHERE slug = 'histopathology-removed-breast-examination';

UPDATE lab_tests SET
	name_ru = 'Пересмотр патогистологического заключения'
 WHERE slug = 'histopathology-report-review';

UPDATE lab_tests SET
	name_ru = 'Патогистологическое исследование одиночной биопсии простаты'
 WHERE slug = 'histopathology-single-prostate-biopsy';

UPDATE lab_tests SET
	name_sr = 'PH biopsija želuca',
	name_sr_cyrl = 'ПХ биопсија желуца'
 WHERE slug = 'histopathology-stomach-biopsy';

UPDATE lab_tests SET
	name_de = 'Histopathologie Untersuchung eines subkutanen Tumors'
 WHERE slug = 'histopathology-subcutaneous-tumor-examination';

UPDATE lab_tests SET
	name_sr = 'PH TRUS prostate',
	name_sr_cyrl = 'ПХ ТРУС простате'
 WHERE slug = 'histopathology-trus-prostate';

UPDATE lab_tests SET
	name_sr = 'HIV 1 + 2 Ag Ab',
	name_sr_cyrl = 'HIV 1 + 2 Ag Ab',
	name_de = 'HIV 1 + 2 Ag Ak',
	name_tr = 'HIV 1 + 2 Ag Ab'
 WHERE slug = 'hiv-1-plus-2-ag-ab';

UPDATE lab_tests SET
	name_en = 'Hops Humulus lupulus IgE',
	name_sr = 'Hmelj Humulus lupulus IgE',
	name_sr_cyrl = 'Хмељ Humulus lupulus IgE',
	name_ru = 'Хмель Humulus lupulus IgE',
	name_de = 'Hopfen Humulus lupulus IgE',
	name_tr = 'Şerbetçiotu Humulus lupulus IgE'
 WHERE slug = 'hops-humulus-lupulus-ige';

UPDATE lab_tests SET
	name_sr = 'Aviditet IgG antitijela na HSV I',
	name_sr_cyrl = 'Авидитет IgG антитијела на HSV I',
	name_ru = 'Авидность антител IgG к ВПГ 1 типа'
 WHERE slug = 'hsv-i-igg-avidity';

UPDATE lab_tests SET
	name_sr = 'Aviditet IgG antitijela na HSV II',
	name_sr_cyrl = 'Авидитет IgG антитијела на HSV II',
	name_ru = 'Авидность антител IgG к ВПГ 2 типа'
 WHERE slug = 'hsv-ii-igg-avidity';

UPDATE lab_tests SET
	name_ru = 'Антитела к IA-2'
 WHERE slug = 'ia-2-antibodies';

UPDATE lab_tests SET
	name_sr = 'Imunohistohemijska analiza više od 10 antitijela',
	name_sr_cyrl = 'Имунохистохемијска анализа више од 10 антитијела'
 WHERE slug = 'immunohistochemistry-more-than-10-antibodies';

UPDATE lab_tests SET
	name_sr = 'Influenca A+B IHT',
	name_sr_cyrl = 'Инфлуенца A+B IHT',
	name_ru = 'Грипп А + В ИХТ',
	name_de = 'Influenza A+B IHT',
	name_tr = 'Grip A+B IHT'
 WHERE slug = 'influenza-a-plus-b-iht';

UPDATE lab_tests SET
	name_sr = 'Influenca A+B PCR',
	name_sr_cyrl = 'Инфлуенца A+B PCR',
	name_ru = 'Грипп А и В ПЦР'
 WHERE slug = 'influenza-a-plus-b-pcr';

UPDATE lab_tests SET
	name_ru = 'Грипп А и В – быстрый тест'
 WHERE slug = 'influenza-ab-rapid-test';

UPDATE lab_tests SET
	name_ru = 'Ингаляционная аллергопанель (30 аллергенов)',
	name_tr = 'İnhalasyon alerji paneli 30 alerjen'
 WHERE slug = 'inhalant-allergy-panel-30-allergens';

UPDATE lab_tests SET
	name_en = 'Kindergarten Microbiology, 2 Sites (Throat, Perianal Tape Test)',
	name_ru = 'Микробиологический анализ для детсада, 2 зоны (зев, соскоб на энтеробиоз)',
	name_de = 'Mikrobiologischer Befund für den Kindergarten, 2 Proben (Rachen, Perianalabklatsch)',
	name_tr = 'Anaokulu Mikrobiyoloji Testi, 2 Bölge (Boğaz, Perianal Bant Testi)'
 WHERE slug = 'kindergarten-microbiology-2';

UPDATE lab_tests SET
	name_en = 'Kindergarten Microbiology, 3 Sites (Throat, Nose, Perianal Tape Test)',
	name_ru = 'Микробиологический анализ для детсада, 3 зоны (зев, нос, соскоб на энтеробиоз)',
	name_de = 'Mikrobiologischer Befund für den Kindergarten, 3 Proben (Rachen, Nase, Perianalabklatsch)',
	name_tr = 'Anaokulu Mikrobiyoloji Testi, 3 Bölge (Boğaz, Burun, Perianal Bant Testi)'
 WHERE slug = 'kindergarten-microbiology-3';

UPDATE lab_tests SET
	name_sr = 'Lamelarna tijela u plodovoj vodi',
	name_sr_cyrl = 'Ламеларна тијела у плодовој води'
 WHERE slug = 'lamellar-bodies-in-amniotic-fluid';

UPDATE lab_tests SET
	name_de = 'Abstrich vom linken Auge'
 WHERE slug = 'left-eye-swab';

UPDATE lab_tests SET
	name_en = 'Left Eye Swab for Fungi',
	name_sr = 'Bris lijevog oka na gljivice',
	name_sr_cyrl = 'Брис лијевог ока на гљивице',
	name_ru = 'Мазок из левого глаза на грибы',
	name_de = 'Abstrich vom linken Auge auf Pilze',
	name_tr = 'Sol Göz Sürüntüsünde Mantar'
 WHERE slug = 'left-eye-swab-fungi';

UPDATE lab_tests SET
	name_en = 'Legionella pneumophila Antigen Urine',
	name_sr = 'Legionella pneumophila antigen u urinu',
	name_sr_cyrl = 'Legionella pneumophila антиген у урину',
	name_ru = 'Legionella pneumophila антиген в моче',
	name_de = 'Legionella pneumophila Antigen Urin',
	name_tr = 'İdrarda Legionella pneumophila Antijen'
 WHERE slug = 'legionella-pneumophila-antigen-urine';

UPDATE lab_tests SET
	name_en = 'Legionella pneumophila IgA ELISA'
 WHERE slug = 'legionella-pneumophila-iga-elisa';

UPDATE lab_tests SET
	name_en = 'Legionella pneumophila IgG',
	name_sr = 'Legionella pneumophila IgG',
	name_sr_cyrl = 'Legionella pneumophila IgG',
	name_ru = 'Антитела к Legionella pneumophila IgG',
	name_de = 'Legionella pneumophila IgG',
	name_tr = 'Legionella pneumophila IgG'
 WHERE slug = 'legionella-pneumophila-igg';

UPDATE lab_tests SET
	name_en = 'Legionella pneumophila IgM',
	name_sr = 'Legionella pneumophila IgM',
	name_sr_cyrl = 'Legionella pneumophila IgM',
	name_ru = 'Антитела к Legionella pneumophila IgM',
	name_de = 'Legionella pneumophila IgM',
	name_tr = 'Legionella pneumophila IgM'
 WHERE slug = 'legionella-pneumophila-igm';

UPDATE lab_tests SET
	name_en = 'Leishmania donovani Antibodies (Indirect Hemagglutination)'
 WHERE slug = 'leishmania-donovani-antibodies-indirect-hemagglutination';

UPDATE lab_tests SET
	name_en = 'Leishmania donovani IgG ELISA'
 WHERE slug = 'leishmania-donovani-igg-elisa';

UPDATE lab_tests SET
	name_en = 'Leishmania IgG/IgM',
	name_ru = 'Антитела к Leishmania IgG/IgM'
 WHERE slug = 'leishmania-igg-igm';

UPDATE lab_tests SET
	name_ru = 'Антитела к Leishmania IgM'
 WHERE slug = 'leishmania-igm-antibodies';

UPDATE lab_tests SET
	name_en = 'Lidocaine Xylocaine c232',
	name_sr = 'Lidokain Ksilokain c232',
	name_sr_cyrl = 'Лидокаин Ксилокаин c232',
	name_ru = 'Лидокаин Ксилокаин c232',
	name_de = 'Lidocain Xylocain c232',
	name_tr = 'Lidokain Ksilokain c232'
 WHERE slug = 'lidocaine-xylocaine-c232';

UPDATE lab_tests SET
	name_en = 'Listeria monocytogenes IgM',
	name_sr = 'Listeria monocytogenes IgM',
	name_sr_cyrl = 'Listeria monocytogenes IgM',
	name_ru = 'Listeria monocytogenes IgM',
	name_de = 'Listeria monocytogenes IgM',
	name_tr = 'Listeria monocytogenes IgM'
 WHERE slug = 'listeria-monocytogenes-igm';

UPDATE lab_tests SET
	name_en = 'Lobster f80',
	name_sr = 'Jastog f80',
	name_sr_cyrl = 'Јастог f80',
	name_ru = 'Омар f80',
	name_de = 'Hummer f80',
	name_tr = 'Istakoz f80'
 WHERE slug = 'lobster-f80';

UPDATE lab_tests SET
	name_en = 'Microscopic Examination for Treponema pallidum'
 WHERE slug = 'microscopic-examination-for-treponema-pallidum';

UPDATE lab_tests SET
	name_ru = 'Микроскопия мазка из уретры, влагалища или шейки матки на гонорею'
 WHERE slug = 'microscopic-examination-of-swab-for-gonorrhea';

UPDATE lab_tests SET
	name_ru = 'Monosticon (тест на мононуклеоз)'
 WHERE slug = 'monosticon';

UPDATE lab_tests SET
	name_en = 'Mussel f37',
	name_sr = 'Školjka f37',
	name_sr_cyrl = 'Шкољка f37',
	name_ru = 'Мидия f37',
	name_de = 'Muschel f37',
	name_tr = 'Midye f37'
 WHERE slug = 'mussel-f37';

UPDATE lab_tests SET
	name_en = 'Mycoplasma hominis Culture'
 WHERE slug = 'mycoplasma-hominis-culture';

UPDATE lab_tests SET
	name_en = 'Mycoplasma hominis/genitalium PCR'
 WHERE slug = 'mycoplasma-hominis-genitalium-pcr';

UPDATE lab_tests SET
	name_en = 'Mycoplasma hominis and Ureaplasma Culture',
	name_sr = 'Kultura na Mycoplasma hominis i Ureaplasma',
	name_sr_cyrl = 'Култура на Mycoplasma hominis и Ureaplasma',
	name_ru = 'Посев на Mycoplasma hominis и Ureaplasma',
	name_de = 'Kultur auf Mycoplasma hominis und Ureaplasma',
	name_tr = 'Mycoplasma hominis ve Ureaplasma kültürü'
 WHERE slug = 'mycoplasma-hominis-ureaplasma';

UPDATE lab_tests SET
	name_en = 'Mycoplasma pneumoniae IgA'
 WHERE slug = 'mycoplasma-pneumoniae-iga';

UPDATE lab_tests SET
	name_en = 'Mycoplasma pneumoniae IgG',
	name_sr = 'Mycoplasma pneumoniae IgG',
	name_sr_cyrl = 'Mycoplasma pneumoniae IgG',
	name_ru = 'Mycoplasma pneumoniae IgG',
	name_de = 'Mycoplasma pneumoniae IgG',
	name_tr = 'Mycoplasma pneumoniae IgG'
 WHERE slug = 'mycoplasma-pneumoniae-igg';

UPDATE lab_tests SET
	name_en = 'Mycoplasma pneumoniae IgM',
	name_sr = 'Mycoplasma pneumoniae IgM',
	name_sr_cyrl = 'Mycoplasma pneumoniae IgM',
	name_ru = 'Mycoplasma pneumoniae IgM',
	name_de = 'Mycoplasma pneumoniae IgM',
	name_tr = 'Mycoplasma pneumoniae IgM'
 WHERE slug = 'mycoplasma-pneumoniae-igm';

UPDATE lab_tests SET
	name_ru = 'Mycoplasma + Ureaplasma – мазок из половых путей',
	name_de = 'Mycoplasma + Ureaplasma – Genitalabstrich',
	name_tr = 'Mycoplasma + Ureaplasma – Genital Sürüntü'
 WHERE slug = 'mycoplasma-ureaplasma-genital-swab';

UPDATE lab_tests SET
	name_en = 'Nail Swab for Fungi',
	name_sr = 'Bris nokta na gljivice',
	name_sr_cyrl = 'Брис нокта на гљивице',
	name_ru = 'Мазок с ногтя на грибы',
	name_de = 'Nagelabstrich auf Pilze',
	name_tr = 'Tırnak Sürüntüsünde Mantar'
 WHERE slug = 'nail-swab-fungi';

UPDATE lab_tests SET
	name_de = 'Brust-Nadelbiopsie mit Her2- und Ki67-Rezeptoren',
	name_tr = 'Meme iğne biyopsisi Her2 ve Ki67 reseptörleri ile'
 WHERE slug = 'needle-breast-biopsy-with-her2-and-ki67-receptors';

UPDATE lab_tests SET
	name_en = 'Neisseria gonorrhoeae Culture',
	name_ru = 'Neisseria gonorrhoeae (культура)',
	name_tr = 'Neisseria gonorrhoeae Kültürü'
 WHERE slug = 'neisseria-gonorrhoeae-culture';

UPDATE lab_tests SET
	name_en = 'Neisseria gonorrhoeae PCR Swab'
 WHERE slug = 'neisseria-gonorrhoeae-pcr-swab';

UPDATE lab_tests SET
	name_en = 'Neisseria gonorrhoeae PCR in Urine',
	name_sr = 'Neisseria gonorrhoeae PCR u urinu',
	name_sr_cyrl = 'Neisseria gonorrhoeae PCR у урину',
	name_ru = 'Neisseria gonorrhoeae ПЦР в моче',
	name_de = 'Neisseria gonorrhoeae PCR im Urin',
	name_tr = 'İdrarda Neisseria gonorrhoeae PCR'
 WHERE slug = 'neisseria-gonorrhoeae-pcr-urine';

UPDATE lab_tests SET
	name_en = 'Neisseria gonorrhoeae Rapid Test',
	name_sr = 'Neisseria gonorrhoeae – DMP + brzi test',
	name_ru = 'Neisseria gonorrhoeae – быстрый тест',
	name_tr = 'Neisseria gonorrhoeae Hızlı Testi'
 WHERE slug = 'neisseria-gonorrhoeae-rapid-test';

UPDATE lab_tests SET
	name_ru = 'НИПТ Panorama базовый'
 WHERE slug = 'nipt-panorama-basic';

UPDATE lab_tests SET
	name_ru = 'НИПТ Panorama полная панель'
 WHERE slug = 'nipt-panorama-full-panel';

UPDATE lab_tests SET
	name_ru = 'НИПТ Panorama плюс'
 WHERE slug = 'nipt-panorama-plus';

UPDATE lab_tests SET
	name_en = 'Nose Swab for Bacteria',
	name_sr = 'Bris nosa na bakterije',
	name_sr_cyrl = 'Брис носа на бактерије',
	name_ru = 'Мазок из носа на бактерии',
	name_de = 'Nasenabstrich auf Bakterien',
	name_tr = 'Burun Sürüntüsünde Bakteri'
 WHERE slug = 'nose-swab-bacteria';

UPDATE lab_tests SET
	name_en = 'Nose Swab for Fungi',
	name_sr = 'Bris nosa na gljivice',
	name_sr_cyrl = 'Брис носа на гљивице',
	name_ru = 'Мазок из носа на грибы',
	name_de = 'Nasenabstrich auf Pilze',
	name_tr = 'Burun Sürüntüsünde Mantar'
 WHERE slug = 'nose-swab-fungi';

UPDATE lab_tests SET
	name_en = 'Octopus IgE f59',
	name_sr = 'Hobotnica IgE f59',
	name_sr_cyrl = 'Хоботница IgE f59',
	name_ru = 'Осьминог IgE f59',
	name_de = 'Oktopus IgE f59',
	name_tr = 'Ahtapot IgE f59'
 WHERE slug = 'octopus-ige-f59';

UPDATE lab_tests SET
	name_en = 'Oral Cavity Swab for Fungi',
	name_sr = 'Bris usne duplje na gljivice',
	name_sr_cyrl = 'Брис усне дупље на гљивице',
	name_ru = 'Мазок из полости рта на грибы',
	name_de = 'Mundhöhlenabstrich auf Pilze',
	name_tr = 'Ağız Boşluğu Sürüntüsünde Mantar'
 WHERE slug = 'oral-cavity-fungi';

UPDATE lab_tests SET
	name_en = 'Oral Cavity Swab for Bacteria',
	name_sr = 'Bris usne duplje na bakterije',
	name_sr_cyrl = 'Брис усне дупље на бактерије',
	name_ru = 'Мазок из полости рта на бактерии',
	name_de = 'Mundhöhlenabstrich auf Bakterien',
	name_tr = 'Ağız Boşluğu Sürüntüsünde Bakteri'
 WHERE slug = 'oral-cavity-swab-bacteria';

UPDATE lab_tests SET
	name_en = 'Palate Swab for Fungi',
	name_ru = 'Посев мазка с нёба на грибы',
	name_de = 'Gaumenabstrich auf Pilze',
	name_tr = 'Damak Sürüntüsünde Mantar'
 WHERE slug = 'palate-swab-fungi';

UPDATE lab_tests SET
	name_ru = 'Детская аллергопанель (30 аллергенов)'
 WHERE slug = 'pediatric-allergy-panel-30-allergens';

UPDATE lab_tests SET
	name_en = 'Penicilloyl G HSA c1',
	name_sr = 'Peniciloil G HSA c1',
	name_sr_cyrl = 'Пеницилоил G HSA c1',
	name_ru = 'Пенициллоил G HSA c1',
	name_de = 'Penicilloyl G HSA c1',
	name_tr = 'Penisiloil G HSA c1'
 WHERE slug = 'penicilloyl-g-hsa-c1';

UPDATE lab_tests SET
	name_en = 'Penicilloyl V HSA c2',
	name_sr = 'Peniciloil V HSA c2',
	name_sr_cyrl = 'Пеницилоил V HSA c2',
	name_ru = 'Пенициллоил V HSA c2',
	name_de = 'Penicilloyl V HSA c2',
	name_tr = 'Penisiloil V HSA c2'
 WHERE slug = 'penicilloyl-v-hsa-c2';

UPDATE lab_tests SET
	name_de = 'Perianaler Abklatsch (Klebestreifentest)',
	name_tr = 'Perianal selofan bant testi'
 WHERE slug = 'perianal-impression';

UPDATE lab_tests SET
	name_en = 'Perianal Swab for Fungi',
	name_sr = 'Perianalni bris na gljivice',
	name_sr_cyrl = 'Перианални брис на гљивице',
	name_ru = 'Перианальный мазок на грибы',
	name_de = 'Perianaler Abstrich auf Pilze',
	name_tr = 'Perianal Sürüntüde Mantar'
 WHERE slug = 'perianal-swab-fungi';

UPDATE lab_tests SET
	name_ru = 'Антитела к фосфолипидам IgG'
 WHERE slug = 'phospholipid-igg-antibodies';

UPDATE lab_tests SET
	name_ru = 'Антитела к фосфолипидам IgM'
 WHERE slug = 'phospholipid-igm-antibodies';

UPDATE lab_tests SET
	name_en = 'Pityrosporum orbiculare',
	name_sr = 'Pityrosporum orbiculare',
	name_sr_cyrl = 'Pityrosporum orbiculare',
	name_ru = 'Pityrosporum orbiculare',
	name_de = 'Pityrosporum orbiculare',
	name_tr = 'Pityrosporum orbiculare'
 WHERE slug = 'pityrosporum-orbiculare';

UPDATE lab_tests SET
	name_en = 'Microscopic Platelet Count',
	name_ru = 'Микроскопический подсчёт тромбоцитов'
 WHERE slug = 'platelet-count-microscopic';

UPDATE lab_tests SET
	name_en = 'Postoperative Wound Swab for Aerobic and Anaerobic Bacteria',
	name_sr = 'Bris postoperativne rane na aerobne i anaerobne bakterije',
	name_sr_cyrl = 'Брис постоперативне ране на аеробне и анаеробне бактерије',
	name_ru = 'Мазок из послеоперационной раны на аэробные и анаэробные бактерии',
	name_de = 'Postoperativer Wundabstrich auf aerobe und anaerobe Bakterien',
	name_tr = 'Postoperatif Yara Sürüntüsünde Aerobik ve Anaerobik Bakteri'
 WHERE slug = 'postoperative-wound-swab-anaerobic';

UPDATE lab_tests SET
	name_en = 'Prepuce Swab for Bacteria',
	name_sr = 'Bris prepucijuma na bakterije',
	name_sr_cyrl = 'Брис препуцијума на бактерије',
	name_ru = 'Мазок с крайней плоти на бактерии',
	name_de = 'Präputium-Abstrich auf Bakterien',
	name_tr = 'Sünnet Derisi Sürüntüsünde Bakteri'
 WHERE slug = 'prepuce-swab-bacteria';

UPDATE lab_tests SET
	name_en = 'Prepuce Swab for Fungi',
	name_sr = 'Bris prepucijuma na gljivice',
	name_sr_cyrl = 'Брис препуцијума на гљивице',
	name_ru = 'Мазок с крайней плоти на грибы',
	name_de = 'Präputium-Abstrich auf Pilze',
	name_tr = 'Sünnet Derisi Sürüntüsünde Mantar'
 WHERE slug = 'prepuce-swab-fungi';

UPDATE lab_tests SET
	name_en = 'Protozoa Stool Test (Giardia, Cryptosporidium, Entamoeba)',
	name_de = 'Protozoen-Stuhltest (Giardia, Cryptosporidium, Entamoeba)',
	name_tr = 'Protozoa Gaita Testi (Giardia, Cryptosporidium, Entamoeba)'
 WHERE slug = 'protozoa-stool-test';

UPDATE lab_tests SET
	name_tr = 'Paratiroid Hormonu'
 WHERE slug = 'pth';

UPDATE lab_tests SET
	name_en = 'Puncture Fluid for Aerobic Bacteria',
	name_sr = 'Punktat na aerobne bakterije',
	name_sr_cyrl = 'Пунктат на аеробне бактерије',
	name_ru = 'Пунктат на аэробные бактерии',
	name_de = 'Punktat auf aerobe Bakterien',
	name_tr = 'Ponksiyon Sıvısında Aerobik Bakteri'
 WHERE slug = 'punctate-aerobic';

UPDATE lab_tests SET
	name_en = 'Puncture Fluid for Aerobic and Anaerobic Bacteria',
	name_sr = 'Punktat na aerobne i anaerobne bakterije',
	name_sr_cyrl = 'Пунктат на аеробне и анаеробне бактерије',
	name_ru = 'Пунктат на аэробные и анаэробные бактерии',
	name_de = 'Punktat auf aerobe und anaerobe Bakterien',
	name_tr = 'Ponksiyon Sıvısında Aerobik ve Anaerobik Bakteri'
 WHERE slug = 'punctate-aerobic-anaerobic';

UPDATE lab_tests SET
	name_en = 'Puncture Fluid for Fungi',
	name_sr = 'Punktat na gljivice',
	name_sr_cyrl = 'Пунктат на гљивице',
	name_tr = 'Ponksiyon Sıvısında Mantar'
 WHERE slug = 'punctate-fungi';

UPDATE lab_tests SET
	name_ru = 'QuantiFERON (тест на туберкулёз)'
 WHERE slug = 'quantiferon';

UPDATE lab_tests SET
	name_en = 'Rectal Swab for Bacteria',
	name_sr = 'Rektalni bris na bakterije',
	name_sr_cyrl = 'Ректални брис на бактерије',
	name_ru = 'Ректальный мазок на бактерии',
	name_de = 'Rektalabstrich auf Bakterien',
	name_tr = 'Rektal Sürüntüde Bakteri'
 WHERE slug = 'rectal-swab-bacteria';

UPDATE lab_tests SET
	name_en = 'Rectal Swab for Fungi',
	name_sr = 'Rektalni bris na gljivice',
	name_sr_cyrl = 'Ректални брис на гљивице',
	name_ru = 'Ректальный мазок на грибы',
	name_de = 'Rektalabstrich auf Pilze',
	name_tr = 'Rektal Sürüntüde Mantar'
 WHERE slug = 'rectal-swab-fungi';

UPDATE lab_tests SET
	name_sr = 'Pregled odstranjene dojke i aksilarnih limfnih čvorova',
	name_sr_cyrl = 'Преглед одстрањене дојке и аксиларних лимфних чворова',
	name_ru = 'Исследование удаленной молочной железы и аксиллярных лимфоузлов',
	name_de = 'Untersuchung des Brustexzisats und der axillären Lymphknoten'
 WHERE slug = 'removed-breast-and-axillary-lymph-nodes-examination';

UPDATE lab_tests SET
	name_sr = 'Pregled odstranjene dojke sa receptorima Her2 i Ki67',
	name_de = 'Untersuchung des Brustexzisats mit Her2- und Ki67-Rezeptoren',
	name_tr = 'Çıkarılmış meme incelemesi Her2 ve Ki67 reseptörleri ile'
 WHERE slug = 'removed-breast-with-her2-and-ki67-receptors';

UPDATE lab_tests SET
	name_en = 'Right Eye Swab for Bacteria',
	name_sr = 'Bris desnog oka na bakterije',
	name_sr_cyrl = 'Брис десног ока на бактерије',
	name_ru = 'Мазок из правого глаза на бактерии',
	name_de = 'Abstrich vom rechten Auge auf Bakterien',
	name_tr = 'Sağ Göz Sürüntüsünde Bakteri'
 WHERE slug = 'right-eye-swab-bacteria';

UPDATE lab_tests SET
	name_en = 'Right Eye Swab for Fungi',
	name_sr = 'Bris desnog oka na gljivice',
	name_sr_cyrl = 'Брис десног ока на гљивице',
	name_ru = 'Мазок из правого глаза на грибы',
	name_de = 'Abstrich vom rechten Auge auf Pilze',
	name_tr = 'Sağ Göz Sürüntüsünde Mantar'
 WHERE slug = 'right-eye-swab-fungi';

UPDATE lab_tests SET
	name_sr = 'Aviditet IgG antitijela na virus rubeole',
	name_sr_cyrl = 'Авидитет IgG антитијела на вирус рубеоле',
	name_ru = 'Авидность антител IgG к вирусу краснухи'
 WHERE slug = 'rubella-igg-avidity';

UPDATE lab_tests SET
	name_sr = 'SARS-CoV-Ab IgG + IgM',
	name_sr_cyrl = 'SARS-CoV-Ab IgG + IgM',
	name_de = 'SARS-CoV-Ab IgG + IgM',
	name_tr = 'SARS-CoV-Ab IgG + IgM'
 WHERE slug = 'sars-cov-ab-igg-plus-igm';

UPDATE lab_tests SET
	name_en = 'Skin Ectoparasite Identification (Larva, Pupa or Adult)'
 WHERE slug = 'skin-ectoparasite-identification';

UPDATE lab_tests SET
	name_en = 'Skin Scraping for Fungi',
	name_sr = 'Strugotina kože na gljivice',
	name_sr_cyrl = 'Струготина коже на гљивице',
	name_ru = 'Соскоб кожи на грибы',
	name_de = 'Hautabschabung auf Pilze',
	name_tr = 'Cilt Kazıntısında Mantar'
 WHERE slug = 'skin-scraping-fungi';

UPDATE lab_tests SET
	name_en = 'Skin Swab for Bacteria',
	name_sr = 'Bris kože na bakterije',
	name_sr_cyrl = 'Брис коже на бактерије',
	name_ru = 'Мазок с кожи на бактерии',
	name_de = 'Hautabstrich auf Bakterien',
	name_tr = 'Cilt Sürüntüsünde Bakteri'
 WHERE slug = 'skin-swab-bacteria';

UPDATE lab_tests SET
	name_en = 'Skin Swab for Fungi',
	name_sr = 'Bris kože na gljivice',
	name_sr_cyrl = 'Брис коже на гљивице',
	name_ru = 'Мазок с кожи на грибы',
	name_de = 'Hautabstrich auf Pilze',
	name_tr = 'Cilt Sürüntüsünde Mantar'
 WHERE slug = 'skin-swab-fungi';

UPDATE lab_tests SET
	name_en = 'Sperm Culture for Bacteria',
	name_sr = 'Kultura sperme na bakterije',
	name_sr_cyrl = 'Култура сперме на бактерије',
	name_ru = 'Посев спермы на бактерии',
	name_de = 'Spermakultur auf Bakterien',
	name_tr = 'Sperm Kültüründe Bakteri'
 WHERE slug = 'sperm-culture-bacteria';

UPDATE lab_tests SET
	name_en = 'Sperm Culture for Fungi',
	name_sr = 'Kultura sperme na gljivice',
	name_sr_cyrl = 'Култура сперме на гљивице',
	name_ru = 'Посев спермы на грибы',
	name_de = 'Spermakultur auf Pilze',
	name_tr = 'Sperm Kültüründe Mantar'
 WHERE slug = 'sperm-culture-fungi';

UPDATE lab_tests SET
	name_en = 'Sputum Culture for Bacteria',
	name_sr = 'Kultura sputuma na bakterije',
	name_sr_cyrl = 'Култура спутума на бактерије',
	name_ru = 'Посев мокроты на бактерии',
	name_de = 'Sputumkultur auf Bakterien',
	name_tr = 'Balgam Kültüründe Bakteri'
 WHERE slug = 'sputum-bacteria';

UPDATE lab_tests SET
	name_en = 'Sputum Culture for Fungi',
	name_sr = 'Kultura sputuma na gljivice',
	name_sr_cyrl = 'Култура спутума на гљивице',
	name_ru = 'Посев мокроты на грибы',
	name_de = 'Sputumkultur auf Pilze',
	name_tr = 'Balgam Kültüründe Mantar'
 WHERE slug = 'sputum-fungi';

UPDATE lab_tests SET
	name_en = 'Squid IgE f258',
	name_sr = 'Lignja IgE f258',
	name_sr_cyrl = 'Лигња IgE f258',
	name_ru = 'Кальмар IgE f258',
	name_de = 'Tintenfisch IgE f258',
	name_tr = 'Kalamar IgE f258'
 WHERE slug = 'squid-ige-f258';

UPDATE lab_tests SET
	name_ru = 'STD Multiplex 2 – выявление 2 возбудителей ИППП'
 WHERE slug = 'std-multiplex-2';

UPDATE lab_tests SET
	name_ru = 'STD Multiplex 3 – выявление 3 возбудителей ИППП'
 WHERE slug = 'std-multiplex-3';

UPDATE lab_tests SET
	name_ru = 'STD Multiplex 4 – выявление 4 возбудителей ИППП'
 WHERE slug = 'std-multiplex-4';

UPDATE lab_tests SET
	name_ru = 'STD Multiplex 4 + HPV Quant 4 (ИППП + ВПЧ)'
 WHERE slug = 'std-multiplex-4-plus-hpv-quant-4';

UPDATE lab_tests SET
	name_ru = 'STD Multiplex 5 – выявление 5 возбудителей ИППП'
 WHERE slug = 'std-multiplex-5';

UPDATE lab_tests SET
	name_ru = 'STD Multiplex 6 – выявление 6 возбудителей ИППП'
 WHERE slug = 'std-multiplex-6';

UPDATE lab_tests SET
	name_ru = 'STD Multiplex 7 – выявление 7 возбудителей ИППП'
 WHERE slug = 'std-multiplex-7';

UPDATE lab_tests SET
	name_ru = 'Посев кала на бактерии'
 WHERE slug = 'stool-culture';

UPDATE lab_tests SET
	name_en = 'Stool Culture for Salmonella, Shigella and E. coli O157',
	name_ru = 'Посев кала на Salmonella, Shigella и E. coli O157',
	name_de = 'Stuhlkultur auf Salmonella, Shigella und E. coli O157',
	name_tr = 'Gaita Kültüründe Salmonella, Shigella ve E. coli O157'
 WHERE slug = 'stool-culture-salmonella-shigella-ecoli';

UPDATE lab_tests SET
	name_en = 'Stool Culture for Fungi',
	name_sr = 'Kultura stolice na gljivice',
	name_sr_cyrl = 'Култура столице на гљивице',
	name_ru = 'Посев кала на грибы',
	name_de = 'Stuhlkultur auf Pilze',
	name_tr = 'Gaita Kültüründe Mantar'
 WHERE slug = 'stool-fungi';

UPDATE lab_tests SET
	name_en = 'Strawberry IgE f44',
	name_sr = 'Jagoda IgE f44',
	name_sr_cyrl = 'Јагода IgE f44',
	name_ru = 'Клубника IgE f44',
	name_de = 'Erdbeere IgE f44',
	name_tr = 'Çilek IgE f44'
 WHERE slug = 'strawberry-ige-f44';

UPDATE lab_tests SET
	name_en = 'Strongyloides stercoralis IgG',
	name_sr = 'Strongyloides stercoralis IgG',
	name_sr_cyrl = 'Strongyloides stercoralis IgG',
	name_ru = 'Strongyloides stercoralis IgG',
	name_de = 'Strongyloides stercoralis IgG',
	name_tr = 'Strongyloides stercoralis IgG'
 WHERE slug = 'strongyloides-stercoralis-igg';

UPDATE lab_tests SET
	name_sr = 'Klinoidna biopsija dojke sa receptorima Her2 i Ki67',
	name_sr_cyrl = 'Клиноидна биопсија дојке са рецепторима Her2 и Ki67',
	name_de = 'Chirurgische Brustbiopsie mit Her2- und Ki67-Rezeptoren',
	name_tr = 'Cerrahi meme biyopsisi Her2 ve Ki67 reseptörleri ile'
 WHERE slug = 'surgical-breast-biopsy-with-her2-and-ki67-receptors';

UPDATE lab_tests SET
	name_de = 'Tuberkulose-Test'
 WHERE slug = 'tb-test';

UPDATE lab_tests SET
	name_en = 'Throat Swab for Bacteria',
	name_sr = 'Bris grla na bakterije',
	name_sr_cyrl = 'Брис грла на бактерије',
	name_ru = 'Мазок из горла на бактерии',
	name_de = 'Rachenabstrich auf Bakterien',
	name_tr = 'Boğaz Sürüntüsünde Bakteri'
 WHERE slug = 'throat-swab-bacteria';

UPDATE lab_tests SET
	name_en = 'Throat Swab for Fungi',
	name_sr = 'Bris grla na gljivice',
	name_sr_cyrl = 'Брис грла на гљивице',
	name_ru = 'Мазок из горла на грибы',
	name_de = 'Rachenabstrich auf Pilze',
	name_tr = 'Boğaz Sürüntüsünde Mantar'
 WHERE slug = 'throat-swab-fungi';

UPDATE lab_tests SET
	name_en = 'Tongue Swab for Bacteria',
	name_sr = 'Bris jezika na bakterije',
	name_sr_cyrl = 'Брис језика на бактерије',
	name_ru = 'Мазок с языка на бактерии',
	name_de = 'Zungenabstrich auf Bakterien',
	name_tr = 'Dil Sürüntüsünde Bakteri'
 WHERE slug = 'tongue-swab-bacteria';

UPDATE lab_tests SET
	name_en = 'Tongue Swab for Fungi',
	name_sr = 'Bris jezika na gljivice',
	name_sr_cyrl = 'Брис језика на гљивице',
	name_ru = 'Мазок с языка на грибы',
	name_de = 'Zungenabstrich auf Pilze',
	name_tr = 'Dil Sürüntüsünde Mantar'
 WHERE slug = 'tongue-swab-fungi';

UPDATE lab_tests SET
	name_en = 'Toxocara canis IgG',
	name_sr = 'Toxocara canis IgG',
	name_sr_cyrl = 'Toxocara canis IgG',
	name_ru = 'Toxocara canis IgG',
	name_de = 'Toxocara canis IgG',
	name_tr = 'Toxocara canis IgG'
 WHERE slug = 'toxocara-canis-igg';

UPDATE lab_tests SET
	name_en = 'Toxocara canis IgM Antibodies',
	name_sr = 'Toxocara canis IgM antitijela',
	name_sr_cyrl = 'Toxocara canis IgM антитијела',
	name_ru = 'Антитела к Toxocara canis IgM',
	name_de = 'Toxocara canis IgM Antikörper',
	name_tr = 'Toxocara canis IgM Antikorları'
 WHERE slug = 'toxocara-canis-igm-antibodies';

UPDATE lab_tests SET
	name_en = 'Toxoplasma gondii Detection - Stained Preparation'
 WHERE slug = 'toxoplasma-gondii-detection-stained-preparation';

UPDATE lab_tests SET
	name_sr = 'Aviditet IgG antitijela na toksoplazmu',
	name_sr_cyrl = 'Авидитет IgG антитијела на токсоплазму',
	name_ru = 'Авидность антител IgG к токсоплазме'
 WHERE slug = 'toxoplasma-igg-avidity';

UPDATE lab_tests SET
	name_en = 'TPHA Treponema pallidum',
	name_sr = 'TPHA Treponema pallidum',
	name_sr_cyrl = 'TPHA Treponema pallidum',
	name_ru = 'TPHA Treponema pallidum',
	name_de = 'TPHA Treponema pallidum',
	name_tr = 'TPHA Treponema pallidum'
 WHERE slug = 'tpha-treponema-pallidum';

UPDATE lab_tests SET
	name_ru = 'Антитела к трансглутаминазе IgA'
 WHERE slug = 'transglutaminase-iga-antibodies';

UPDATE lab_tests SET
	name_ru = 'Антитела к трансглутаминазе IgG'
 WHERE slug = 'transglutaminase-igg-antibodies';

UPDATE lab_tests SET
	name_en = 'Trichinella spiralis Antibodies (Indirect Immunofluorescence)'
 WHERE slug = 'trichinella-spiralis-antibodies-indirect-immunofluorescence';

UPDATE lab_tests SET
	name_en = 'Trichinella spiralis IgG',
	name_sr = 'Trichinella spiralis IgG',
	name_sr_cyrl = 'Trichinella spiralis IgG',
	name_ru = 'Trichinella spiralis IgG',
	name_de = 'Trichinella spiralis IgG',
	name_tr = 'Trichinella spiralis IgG'
 WHERE slug = 'trichinella-spiralis-igg';

UPDATE lab_tests SET
	name_en = 'Trichinella spiralis Total Antibodies',
	name_sr = 'Trichinella spiralis ukupna antitijela',
	name_sr_cyrl = 'Trichinella spiralis укупна антитијела',
	name_ru = 'Trichinella spiralis суммарные антитела',
	name_de = 'Trichinella spiralis Gesamt-Antikörper',
	name_tr = 'Trichinella spiralis Total Antikorlar'
 WHERE slug = 'trichinella-spiralis-total-antibodies';

UPDATE lab_tests SET
	name_sr = 'Trichomonas vaginalis – NMP + brzi test',
	name_ru = 'Trichomonas vaginalis – быстрый тест',
	name_tr = 'Trichomonas vaginalis Hızlı Testi'
 WHERE slug = 'trichomonas-rapid-test';

UPDATE lab_tests SET
	name_en = 'Trichomonas vaginalis IHT',
	name_sr = 'Trichomonas vaginalis IHT',
	name_sr_cyrl = 'Trichomonas vaginalis IHT',
	name_ru = 'Trichomonas vaginalis ИХТ',
	name_de = 'Trichomonas vaginalis IHT',
	name_tr = 'Trichomonas vaginalis IHT'
 WHERE slug = 'trichomonas-vaginalis-iht';

UPDATE lab_tests SET
	name_sr = 'Tripl test (biohemijski skrining 2. trimestra)',
	name_sr_cyrl = 'Трипл тест (биохемијски скрининг 2. триместра)',
	name_tr = 'Üçlü Test (2. Trimester Taraması)'
 WHERE slug = 'triple-test-second-trimester-screening';

UPDATE lab_tests SET
	name_sr = 'Troponin T visoke osjetljivosti',
	name_sr_cyrl = 'Тропонин T високе осјетљивости',
	name_ru = 'Тропонин Т высокочувствительный'
 WHERE slug = 'troponin-t-hs';

UPDATE lab_tests SET
	name_en = 'Umbilical Swab for Bacteria',
	name_de = 'Nabelabstrich auf Bakterien',
	name_tr = 'Göbek Sürüntüsünde Bakteri'
 WHERE slug = 'umbilicus-swab-bacteria';

UPDATE lab_tests SET
	name_en = 'Umbilical Swab for Fungi',
	name_de = 'Nabelabstrich auf Pilze',
	name_tr = 'Göbek Sürüntüsünde Mantar'
 WHERE slug = 'umbilicus-swab-fungi';

UPDATE lab_tests SET
	name_en = 'Ureaplasma parvum PCR',
	name_sr = 'Ureaplasma parvum PCR',
	name_sr_cyrl = 'Ureaplasma parvum PCR',
	name_ru = 'Ureaplasma parvum ПЦР',
	name_de = 'Ureaplasma parvum PCR',
	name_tr = 'Ureaplasma parvum PCR'
 WHERE slug = 'ureaplasma-parvum-pcr';

UPDATE lab_tests SET
	name_ru = 'Ureaplasma (ПЦР)',
	name_tr = 'Ureaplasma PCR'
 WHERE slug = 'ureaplasma-pcr';

UPDATE lab_tests SET
	name_en = 'Ureaplasma urealyticum Culture'
 WHERE slug = 'ureaplasma-urealyticum-culture';

UPDATE lab_tests SET
	name_en = 'Ureaplasma urealyticum IgA',
	name_sr = 'Ureaplasma urealyticum IgA',
	name_sr_cyrl = 'Ureaplasma urealyticum IgA',
	name_ru = 'Ureaplasma urealyticum IgA',
	name_de = 'Ureaplasma urealyticum IgA',
	name_tr = 'Ureaplasma urealyticum IgA'
 WHERE slug = 'ureaplasma-urealyticum-iga';

UPDATE lab_tests SET
	name_en = 'Ureaplasma urealyticum IgG',
	name_sr = 'Ureaplasma urealyticum IgG',
	name_sr_cyrl = 'Ureaplasma urealyticum IgG',
	name_ru = 'Ureaplasma urealyticum IgG',
	name_de = 'Ureaplasma urealyticum IgG',
	name_tr = 'Ureaplasma urealyticum IgG'
 WHERE slug = 'ureaplasma-urealyticum-igg';

UPDATE lab_tests SET
	name_en = 'Ureaplasma urealyticum IgM',
	name_sr = 'Ureaplasma urealyticum IgM',
	name_sr_cyrl = 'Ureaplasma urealyticum IgM',
	name_ru = 'Ureaplasma urealyticum IgM',
	name_de = 'Ureaplasma urealyticum IgM',
	name_tr = 'Ureaplasma urealyticum IgM'
 WHERE slug = 'ureaplasma-urealyticum-igm';

UPDATE lab_tests SET
	name_en = 'Ureaplasma urealyticum PCR',
	name_sr = 'Ureaplasma urealyticum PCR',
	name_sr_cyrl = 'Ureaplasma urealyticum PCR',
	name_ru = 'Ureaplasma urealyticum ПЦР',
	name_de = 'Ureaplasma urealyticum PCR',
	name_tr = 'Ureaplasma urealyticum PCR'
 WHERE slug = 'ureaplasma-urealyticum-pcr';

UPDATE lab_tests SET
	name_en = 'Ureaplasma urealyticum PCR Urine',
	name_sr = 'Ureaplasma urealyticum PCR urin',
	name_sr_cyrl = 'Ureaplasma urealyticum PCR урин',
	name_ru = 'Ureaplasma urealyticum ПЦР моча',
	name_de = 'Ureaplasma urealyticum PCR Urin',
	name_tr = 'Ureaplasma urealyticum PCR İdrar'
 WHERE slug = 'ureaplasma-urealyticum-pcr-urine';

UPDATE lab_tests SET
	name_en = 'Urethral Swab for Bacteria',
	name_sr = 'Bris uretre na bakterije',
	name_sr_cyrl = 'Брис уретре на бактерије',
	name_ru = 'Мазок из уретры на бактерии',
	name_de = 'Harnröhrenabstrich auf Bakterien',
	name_tr = 'Üretra Sürüntüsünde Bakteri'
 WHERE slug = 'urethral-swab-bacteria';

UPDATE lab_tests SET
	name_en = 'Urethral Swab for Fungi',
	name_sr = 'Bris uretre na gljivice',
	name_sr_cyrl = 'Брис уретре на гљивице',
	name_ru = 'Мазок из уретры на грибы',
	name_de = 'Harnröhrenabstrich auf Pilze',
	name_tr = 'Üretra Sürüntüsünde Mantar'
 WHERE slug = 'urethral-swab-fungi';

UPDATE lab_tests SET
	name_en = 'Urine Culture for Bacteria',
	name_sr = 'Urinokultura na bakterije',
	name_sr_cyrl = 'Уринокултура на бактерије',
	name_ru = 'Посев мочи на бактерии',
	name_de = 'Urinkultur auf Bakterien',
	name_tr = 'İdrar Kültüründe Bakteri'
 WHERE slug = 'urine-culture-bacteria';

UPDATE lab_tests SET
	name_en = 'Urine Culture for Fungi',
	name_sr = 'Kultura urina na gljivice',
	name_sr_cyrl = 'Култура урина на гљивице',
	name_ru = 'Посев мочи на грибы',
	name_de = 'Urinkultur auf Pilze',
	name_tr = 'İdrar Kültüründe Mantar'
 WHERE slug = 'urine-fungi';

UPDATE lab_tests SET
	name_en = 'Vaginal Swab for Bacteria',
	name_sr = 'Bris vagine na bakterije',
	name_sr_cyrl = 'Брис вагине на бактерије',
	name_ru = 'Мазок из влагалища на бактерии',
	name_de = 'Vaginalabstrich auf Bakterien',
	name_tr = 'Vajinal Sürüntüde Bakteri'
 WHERE slug = 'vaginal-swab-bacteria';

UPDATE lab_tests SET
	name_en = 'Vaginal Swab for Fungi',
	name_sr = 'Bris vagine na gljivice',
	name_sr_cyrl = 'Брис вагине на гљивице',
	name_ru = 'Мазок из влагалища на грибы',
	name_de = 'Vaginalabstrich auf Pilze',
	name_tr = 'Vajinal Sürüntüde Mantar'
 WHERE slug = 'vaginal-swab-fungi';

UPDATE lab_tests SET
	name_sr = 'Aviditet IgG antitijela na virus varičela-zoster',
	name_sr_cyrl = 'Авидитет IgG антитијела на вирус варичела-зостер',
	name_ru = 'Авидность антител IgG к вирусу варицелла-зостер'
 WHERE slug = 'varicella-zoster-igg-avidity';

UPDATE lab_tests SET
	name_sr = 'Varičela zoster virus IgG',
	name_sr_cyrl = 'Варичела зостер вирус IgG',
	name_ru = 'Вирус варицелла-зостер IgG',
	name_tr = 'Varisella zoster virüsü IgG'
 WHERE slug = 'varicella-zoster-virus-igg';

UPDATE lab_tests SET
	name_sr = 'Varičela zoster virus IgM',
	name_sr_cyrl = 'Варичела зостер вирус IgM',
	name_ru = 'Вирус варицелла-зостер IgM',
	name_tr = 'Varisella zoster virüsü IgM'
 WHERE slug = 'varicella-zoster-virus-igm';

UPDATE lab_tests SET
	name_en = 'Vibrio cholerae Culture',
	name_ru = 'Посев на Vibrio cholerae'
 WHERE slug = 'vibrio-cholerae-culture';

UPDATE lab_tests SET
	name_sr = 'Vanilmandelična kiselina',
	name_sr_cyrl = 'Ванилманделична киселина'
 WHERE slug = 'vma';

UPDATE lab_tests SET
	name_sr = 'Aktivnost von Willebrandovog faktora',
	name_sr_cyrl = 'Активност вон Willebrandovog фактора',
	name_ru = 'Активность фактора Виллебранда'
 WHERE slug = 'von-willebrand-factor-activity';

UPDATE lab_tests SET
	name_en = 'Vulvar Swab for Bacteria',
	name_sr = 'Bris vulve na bakterije',
	name_sr_cyrl = 'Брис вулве на бактерије',
	name_ru = 'Мазок с вульвы на бактерии',
	name_de = 'Vulvaabstrich auf Bakterien',
	name_tr = 'Vulvar Sürüntüde Bakteri'
 WHERE slug = 'vulvar-swab-bacteria';

UPDATE lab_tests SET
	name_en = 'Vulvar Swab for Fungi',
	name_sr = 'Bris vulve na gljivice',
	name_sr_cyrl = 'Брис вулве на гљивице',
	name_ru = 'Мазок с вульвы на грибы',
	name_de = 'Vulvaabstrich auf Pilze',
	name_tr = 'Vulvar Sürüntüde Mantar'
 WHERE slug = 'vulvar-swab-fungi';

UPDATE lab_tests SET
	name_en = 'Wound Swab for Aerobic Bacteria',
	name_sr = 'Bris rane na aerobne bakterije',
	name_sr_cyrl = 'Брис ране на аеробне бактерије',
	name_ru = 'Мазок из раны на аэробные бактерии',
	name_de = 'Wundabstrich auf aerobe Bakterien',
	name_tr = 'Yara Sürüntüsünde Aerobik Bakteri'
 WHERE slug = 'wound-swab-aerobic-bacteria';

UPDATE lab_tests SET
	name_en = 'Wound Swab for Bacteria',
	name_sr = 'Bris rane na bakterije',
	name_sr_cyrl = 'Брис ране на бактерије',
	name_ru = 'Мазок из раны на бактерии',
	name_de = 'Wundabstrich auf Bakterien',
	name_tr = 'Yara Sürüntüsünde Bakteri'
 WHERE slug = 'wound-swab-bacteria';

UPDATE lab_tests SET
	name_en = 'Wound Swab for Fungi',
	name_sr = 'Bris rane na gljivice',
	name_sr_cyrl = 'Брис ране на гљивице',
	name_ru = 'Мазок из раны на грибы',
	name_de = 'Wundabstrich auf Pilze',
	name_tr = 'Yara Sürüntüsünde Mantar'
 WHERE slug = 'wound-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Detekcija antimikrobnih antitela lateks aglutinacionim testom', 'sr' FROM lab_tests WHERE slug = 'antimicrobial-antibody-detection-by-latex-agglutination'
UNION ALL SELECT id, 'Детекција антимикробних антитела латекс аглутинационим тестом', 'sr-cyrl' FROM lab_tests WHERE slug = 'antimicrobial-antibody-detection-by-latex-agglutination';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Veliki kašalj IgG', 'sr' FROM lab_tests WHERE slug = 'bordetella-pertussis-igg'
UNION ALL SELECT id, 'Велики кашаљ IgG', 'sr-cyrl' FROM lab_tests WHERE slug = 'bordetella-pertussis-igg'
UNION ALL SELECT id, 'Pertusis IgG', 'sr' FROM lab_tests WHERE slug = 'bordetella-pertussis-igg'
UNION ALL SELECT id, 'Пертусис IgG', 'sr-cyrl' FROM lab_tests WHERE slug = 'bordetella-pertussis-igg'
UNION ALL SELECT id, 'Антитела к коклюшу IgG', 'ru' FROM lab_tests WHERE slug = 'bordetella-pertussis-igg'
UNION ALL SELECT id, 'Keuchhusten IgG', 'de' FROM lab_tests WHERE slug = 'bordetella-pertussis-igg'
UNION ALL SELECT id, 'Boğmaca IgG', 'tr' FROM lab_tests WHERE slug = 'bordetella-pertussis-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Lajmska bolest IgG', 'sr' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igg'
UNION ALL SELECT id, 'Лајмска болест IgG', 'sr-cyrl' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igg'
UNION ALL SELECT id, 'Borelioza IgG', 'sr' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igg'
UNION ALL SELECT id, 'Борелиоза IgG', 'sr-cyrl' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igg'
UNION ALL SELECT id, 'Боррелиоз IgG', 'ru' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igg'
UNION ALL SELECT id, 'Болезнь Лайма IgG', 'ru' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igg'
UNION ALL SELECT id, 'Borreliose IgG', 'de' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igg'
UNION ALL SELECT id, 'Lyme hastalığı IgG', 'tr' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Borrelia IgG Immunoblot', 'en' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igg-western-blot'
UNION ALL SELECT id, 'Иммуноблот на боррелиоз IgG', 'ru' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igg-western-blot'
UNION ALL SELECT id, 'Borrelien-Immunoblot IgG', 'de' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igg-western-blot';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Lajmska bolest IgM', 'sr' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igm'
UNION ALL SELECT id, 'Лајмска болест IgM', 'sr-cyrl' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igm'
UNION ALL SELECT id, 'Borelioza IgM', 'sr' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igm'
UNION ALL SELECT id, 'Борелиоза IgM', 'sr-cyrl' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igm'
UNION ALL SELECT id, 'Боррелиоз IgM', 'ru' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igm'
UNION ALL SELECT id, 'Borreliose IgM', 'de' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igm'
UNION ALL SELECT id, 'Lyme hastalığı IgM', 'tr' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Borrelia IgM Immunoblot', 'en' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igm-western-blot'
UNION ALL SELECT id, 'Иммуноблот на боррелиоз IgM', 'ru' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igm-western-blot'
UNION ALL SELECT id, 'Borrelien-Immunoblot IgM', 'de' FROM lab_tests WHERE slug = 'borrelia-burgdorferi-igm-western-blot';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Bruceloza IgM', 'sr' FROM lab_tests WHERE slug = 'brucella-igm'
UNION ALL SELECT id, 'Бруцелоза IgM', 'sr-cyrl' FROM lab_tests WHERE slug = 'brucella-igm'
UNION ALL SELECT id, 'Brucela IgM', 'sr' FROM lab_tests WHERE slug = 'brucella-igm'
UNION ALL SELECT id, 'Бруцела IgM', 'sr-cyrl' FROM lab_tests WHERE slug = 'brucella-igm'
UNION ALL SELECT id, 'Бруцеллёз IgM', 'ru' FROM lab_tests WHERE slug = 'brucella-igm'
UNION ALL SELECT id, 'Бруцелла IgM', 'ru' FROM lab_tests WHERE slug = 'brucella-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Посев на кампилобактер', 'ru' FROM lab_tests WHERE slug = 'campylobacter-culture';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Кандида IgM', 'ru' FROM lab_tests WHERE slug = 'candida-igm-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Hlamidija IHT', 'sr' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-iht'
UNION ALL SELECT id, 'Хламидија IHT', 'sr-cyrl' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-iht'
UNION ALL SELECT id, 'Хламидии ИХТ', 'ru' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-iht';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Авидность IgG к цитомегаловирусу', 'ru' FROM lab_tests WHERE slug = 'cmv-avidity'
UNION ALL SELECT id, 'ЦМВ IgG авидность', 'ru' FROM lab_tests WHERE slug = 'cmv-avidity';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Demodeks', 'sr' FROM lab_tests WHERE slug = 'demodex-species'
UNION ALL SELECT id, 'Демодекс', 'sr-cyrl' FROM lab_tests WHERE slug = 'demodex-species'
UNION ALL SELECT id, 'Анализ на демодекс', 'ru' FROM lab_tests WHERE slug = 'demodex-species'
UNION ALL SELECT id, 'Демодекоз', 'ru' FROM lab_tests WHERE slug = 'demodex-species';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Ehinokok IgG', 'sr' FROM lab_tests WHERE slug = 'echinococcus-igg-elisa'
UNION ALL SELECT id, 'Ехинокок IgG', 'sr-cyrl' FROM lab_tests WHERE slug = 'echinococcus-igg-elisa'
UNION ALL SELECT id, 'Эхинококк IgG', 'ru' FROM lab_tests WHERE slug = 'echinococcus-igg-elisa';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'EBV IgG', 'en' FROM lab_tests WHERE slug = 'epstein-barr-igg'
UNION ALL SELECT id, 'ВЭБ IgG', 'ru' FROM lab_tests WHERE slug = 'epstein-barr-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'EBV IgM', 'en' FROM lab_tests WHERE slug = 'epstein-barr-igm'
UNION ALL SELECT id, 'ВЭБ IgM', 'ru' FROM lab_tests WHERE slug = 'epstein-barr-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Anti-HAV IgM', 'en' FROM lab_tests WHERE slug = 'hav-igm'
UNION ALL SELECT id, 'Антитела к гепатиту А IgM', 'ru' FROM lab_tests WHERE slug = 'hav-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Helikobakter pilori', 'sr' FROM lab_tests WHERE slug = 'helicobacter-pylori'
UNION ALL SELECT id, 'Хеликобактер пилори', 'sr-cyrl' FROM lab_tests WHERE slug = 'helicobacter-pylori'
UNION ALL SELECT id, 'Антитела к хеликобактеру', 'ru' FROM lab_tests WHERE slug = 'helicobacter-pylori';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Helikobakter pilori IgA', 'sr' FROM lab_tests WHERE slug = 'helicobacter-pylori-iga'
UNION ALL SELECT id, 'Хеликобактер пилори IgA', 'sr-cyrl' FROM lab_tests WHERE slug = 'helicobacter-pylori-iga';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Helikobakter pilori IgG', 'sr' FROM lab_tests WHERE slug = 'helicobacter-pylori-igg'
UNION ALL SELECT id, 'Хеликобактер пилори IgG', 'sr-cyrl' FROM lab_tests WHERE slug = 'helicobacter-pylori-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Rapid Influenza Test', 'en' FROM lab_tests WHERE slug = 'influenza-a-plus-b-iht'
UNION ALL SELECT id, 'Brzi test na grip', 'sr' FROM lab_tests WHERE slug = 'influenza-a-plus-b-iht'
UNION ALL SELECT id, 'Брзи тест на грип', 'sr-cyrl' FROM lab_tests WHERE slug = 'influenza-a-plus-b-iht'
UNION ALL SELECT id, 'Экспресс-тест на грипп', 'ru' FROM lab_tests WHERE slug = 'influenza-a-plus-b-iht'
UNION ALL SELECT id, 'Influenza-Schnelltest', 'de' FROM lab_tests WHERE slug = 'influenza-a-plus-b-iht'
UNION ALL SELECT id, 'Grip hızlı testi', 'tr' FROM lab_tests WHERE slug = 'influenza-a-plus-b-iht';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Legionela IgG', 'sr' FROM lab_tests WHERE slug = 'legionella-pneumophila-igg'
UNION ALL SELECT id, 'Легионела IgG', 'sr-cyrl' FROM lab_tests WHERE slug = 'legionella-pneumophila-igg'
UNION ALL SELECT id, 'Легионелла IgG', 'ru' FROM lab_tests WHERE slug = 'legionella-pneumophila-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Legionela IgM', 'sr' FROM lab_tests WHERE slug = 'legionella-pneumophila-igm'
UNION ALL SELECT id, 'Легионела IgM', 'sr-cyrl' FROM lab_tests WHERE slug = 'legionella-pneumophila-igm'
UNION ALL SELECT id, 'Легионелла IgM', 'ru' FROM lab_tests WHERE slug = 'legionella-pneumophila-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Leishmania IgG IgM', 'en' FROM lab_tests WHERE slug = 'leishmania-igg-igm'
UNION ALL SELECT id, 'Lajšmanija IgG/IgM', 'sr' FROM lab_tests WHERE slug = 'leishmania-igg-igm'
UNION ALL SELECT id, 'Лајшманија IgG/IgM', 'sr-cyrl' FROM lab_tests WHERE slug = 'leishmania-igg-igm'
UNION ALL SELECT id, 'Лейшмания IgG/IgM', 'ru' FROM lab_tests WHERE slug = 'leishmania-igg-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Микроскопия на бледную трепонему', 'ru' FROM lab_tests WHERE slug = 'microscopic-examination-for-treponema-pallidum';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, '17-OHP', 'en' FROM lab_tests WHERE slug = '17-hydroxyprogesterone'
UNION ALL SELECT id, '17-OH Progesterone', 'en' FROM lab_tests WHERE slug = '17-hydroxyprogesterone'
UNION ALL SELECT id, '17-ОН-прогестерон', 'ru' FROM lab_tests WHERE slug = '17-hydroxyprogesterone'
UNION ALL SELECT id, '17-ОПГ', 'ru' FROM lab_tests WHERE slug = '17-hydroxyprogesterone';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Parathormone', 'en' FROM lab_tests WHERE slug = 'pth'
UNION ALL SELECT id, 'Паратгормон', 'ru' FROM lab_tests WHERE slug = 'pth';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Mono Test', 'en' FROM lab_tests WHERE slug = 'monosticon'
UNION ALL SELECT id, 'Test na mononukleozu', 'sr' FROM lab_tests WHERE slug = 'monosticon'
UNION ALL SELECT id, 'Тест на мононуклеозу', 'sr-cyrl' FROM lab_tests WHERE slug = 'monosticon'
UNION ALL SELECT id, 'Моностикон', 'ru' FROM lab_tests WHERE slug = 'monosticon'
UNION ALL SELECT id, 'Mononukleose-Test', 'de' FROM lab_tests WHERE slug = 'monosticon'
UNION ALL SELECT id, 'Mononükleoz testi', 'tr' FROM lab_tests WHERE slug = 'monosticon';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Mycoplasma Hominis Ureaplasma', 'en' FROM lab_tests WHERE slug = 'mycoplasma-hominis-ureaplasma'
UNION ALL SELECT id, 'Kultura na mikoplazmu i ureaplazmu', 'sr' FROM lab_tests WHERE slug = 'mycoplasma-hominis-ureaplasma'
UNION ALL SELECT id, 'Култура на микоплазму и уреаплазму', 'sr-cyrl' FROM lab_tests WHERE slug = 'mycoplasma-hominis-ureaplasma'
UNION ALL SELECT id, 'Посев на микоплазмы и уреаплазмы', 'ru' FROM lab_tests WHERE slug = 'mycoplasma-hominis-ureaplasma'
UNION ALL SELECT id, 'Mykoplasmen- und Ureaplasmenkultur', 'de' FROM lab_tests WHERE slug = 'mycoplasma-hominis-ureaplasma'
UNION ALL SELECT id, 'Mikoplazma ve üreaplazma kültürü', 'tr' FROM lab_tests WHERE slug = 'mycoplasma-hominis-ureaplasma';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Pinworm Test', 'en' FROM lab_tests WHERE slug = 'perianal-impression'
UNION ALL SELECT id, 'Selotejp test', 'sr' FROM lab_tests WHERE slug = 'perianal-impression'
UNION ALL SELECT id, 'Селотејп тест', 'sr-cyrl' FROM lab_tests WHERE slug = 'perianal-impression'
UNION ALL SELECT id, 'Test na dječje gliste', 'sr' FROM lab_tests WHERE slug = 'perianal-impression'
UNION ALL SELECT id, 'Тест на дјечје глисте', 'sr-cyrl' FROM lab_tests WHERE slug = 'perianal-impression'
UNION ALL SELECT id, 'Test na dečje gliste', 'sr' FROM lab_tests WHERE slug = 'perianal-impression'
UNION ALL SELECT id, 'Тест на дечје глисте', 'sr-cyrl' FROM lab_tests WHERE slug = 'perianal-impression'
UNION ALL SELECT id, 'Соскоб на энтеробиоз', 'ru' FROM lab_tests WHERE slug = 'perianal-impression'
UNION ALL SELECT id, 'Анализ на острицы', 'ru' FROM lab_tests WHERE slug = 'perianal-impression'
UNION ALL SELECT id, 'Madenwurm-Test', 'de' FROM lab_tests WHERE slug = 'perianal-impression'
UNION ALL SELECT id, 'Kıl kurdu testi', 'tr' FROM lab_tests WHERE slug = 'perianal-impression';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Kvantiferon', 'sr' FROM lab_tests WHERE slug = 'quantiferon'
UNION ALL SELECT id, 'Квантиферон', 'sr-cyrl' FROM lab_tests WHERE slug = 'quantiferon'
UNION ALL SELECT id, 'Квантифероновый тест', 'ru' FROM lab_tests WHERE slug = 'quantiferon';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Антитела к коронавирусу IgG и IgM', 'ru' FROM lab_tests WHERE slug = 'sars-cov-ab-igg-plus-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Toksokara IgG', 'sr' FROM lab_tests WHERE slug = 'toxocara-canis-igg'
UNION ALL SELECT id, 'Токсокара IgG', 'sr-cyrl' FROM lab_tests WHERE slug = 'toxocara-canis-igg'
UNION ALL SELECT id, 'Антитела к токсокарам IgG', 'ru' FROM lab_tests WHERE slug = 'toxocara-canis-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Авидность антител к токсоплазме', 'ru' FROM lab_tests WHERE slug = 'toxoplasma-igg-avidity'
UNION ALL SELECT id, 'Токсоплазма IgG авидность', 'ru' FROM lab_tests WHERE slug = 'toxoplasma-igg-avidity';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'РПГА на сифилис', 'ru' FROM lab_tests WHERE slug = 'tpha-treponema-pallidum'
UNION ALL SELECT id, 'Syphilis-Suchtest', 'de' FROM lab_tests WHERE slug = 'tpha-treponema-pallidum';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Trihineloza IgG', 'sr' FROM lab_tests WHERE slug = 'trichinella-spiralis-igg'
UNION ALL SELECT id, 'Трихинелоза IgG', 'sr-cyrl' FROM lab_tests WHERE slug = 'trichinella-spiralis-igg'
UNION ALL SELECT id, 'Трихинеллёз IgG', 'ru' FROM lab_tests WHERE slug = 'trichinella-spiralis-igg'
UNION ALL SELECT id, 'Антитела к трихинеллам IgG', 'ru' FROM lab_tests WHERE slug = 'trichinella-spiralis-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'VZV IgG', 'en' FROM lab_tests WHERE slug = 'varicella-zoster-virus-igg'
UNION ALL SELECT id, 'Chickenpox IgG', 'en' FROM lab_tests WHERE slug = 'varicella-zoster-virus-igg'
UNION ALL SELECT id, 'Ovčije boginje IgG', 'sr' FROM lab_tests WHERE slug = 'varicella-zoster-virus-igg'
UNION ALL SELECT id, 'Овчије богиње IgG', 'sr-cyrl' FROM lab_tests WHERE slug = 'varicella-zoster-virus-igg'
UNION ALL SELECT id, 'Ветряная оспа IgG', 'ru' FROM lab_tests WHERE slug = 'varicella-zoster-virus-igg'
UNION ALL SELECT id, 'Антитела к ветрянке IgG', 'ru' FROM lab_tests WHERE slug = 'varicella-zoster-virus-igg'
UNION ALL SELECT id, 'Windpocken IgG', 'de' FROM lab_tests WHERE slug = 'varicella-zoster-virus-igg'
UNION ALL SELECT id, 'Su çiçeği IgG', 'tr' FROM lab_tests WHERE slug = 'varicella-zoster-virus-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'VZV IgM', 'en' FROM lab_tests WHERE slug = 'varicella-zoster-virus-igm'
UNION ALL SELECT id, 'Chickenpox IgM', 'en' FROM lab_tests WHERE slug = 'varicella-zoster-virus-igm'
UNION ALL SELECT id, 'Ovčije boginje IgM', 'sr' FROM lab_tests WHERE slug = 'varicella-zoster-virus-igm'
UNION ALL SELECT id, 'Овчије богиње IgM', 'sr-cyrl' FROM lab_tests WHERE slug = 'varicella-zoster-virus-igm'
UNION ALL SELECT id, 'Ветряная оспа IgM', 'ru' FROM lab_tests WHERE slug = 'varicella-zoster-virus-igm'
UNION ALL SELECT id, 'Антитела к ветрянке IgM', 'ru' FROM lab_tests WHERE slug = 'varicella-zoster-virus-igm'
UNION ALL SELECT id, 'Windpocken IgM', 'de' FROM lab_tests WHERE slug = 'varicella-zoster-virus-igm'
UNION ALL SELECT id, 'Su çiçeği IgM', 'tr' FROM lab_tests WHERE slug = 'varicella-zoster-virus-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Cholera Culture', 'en' FROM lab_tests WHERE slug = 'vibrio-cholerae-culture'
UNION ALL SELECT id, 'Kultura na koleru', 'sr' FROM lab_tests WHERE slug = 'vibrio-cholerae-culture'
UNION ALL SELECT id, 'Култура на колеру', 'sr-cyrl' FROM lab_tests WHERE slug = 'vibrio-cholerae-culture'
UNION ALL SELECT id, 'Посев на холерный вибрион', 'ru' FROM lab_tests WHERE slug = 'vibrio-cholerae-culture'
UNION ALL SELECT id, 'Cholera-Kultur', 'de' FROM lab_tests WHERE slug = 'vibrio-cholerae-culture'
UNION ALL SELECT id, 'Kolera kültürü', 'tr' FROM lab_tests WHERE slug = 'vibrio-cholerae-culture';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Anti-GAD antitela', 'sr' FROM lab_tests WHERE slug = 'anti-gad-antibodies'
UNION ALL SELECT id, 'Анти-ГАД антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-gad-antibodies'
UNION ALL SELECT id, 'Антитела к глутаматдекарбоксилазе', 'ru' FROM lab_tests WHERE slug = 'anti-gad-antibodies'
UNION ALL SELECT id, 'Анти-GAD', 'ru' FROM lab_tests WHERE slug = 'anti-gad-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antikardiolipinska antitijela IgG', 'sr' FROM lab_tests WHERE slug = 'anticardiolipin-igg'
UNION ALL SELECT id, 'Антикардиолипинска антитијела IgG', 'sr-cyrl' FROM lab_tests WHERE slug = 'anticardiolipin-igg'
UNION ALL SELECT id, 'Cardiolipin-Antikörper IgG', 'de' FROM lab_tests WHERE slug = 'anticardiolipin-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antikardiolipinska antitijela IgM', 'sr' FROM lab_tests WHERE slug = 'anticardiolipin-igm'
UNION ALL SELECT id, 'Антикардиолипинска антитијела IgM', 'sr-cyrl' FROM lab_tests WHERE slug = 'anticardiolipin-igm'
UNION ALL SELECT id, 'Cardiolipin-Antikörper IgM', 'de' FROM lab_tests WHERE slug = 'anticardiolipin-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'dsDNA IgG antitela', 'sr' FROM lab_tests WHERE slug = 'dsdna-igg-antibodies'
UNION ALL SELECT id, 'dsDNA IgG антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'dsdna-igg-antibodies'
UNION ALL SELECT id, 'Антитела к двуспиральной ДНК IgG', 'ru' FROM lab_tests WHERE slug = 'dsdna-igg-antibodies'
UNION ALL SELECT id, 'Анти-дсДНК IgG', 'ru' FROM lab_tests WHERE slug = 'dsdna-igg-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Anti-dsDNA IgM', 'en' FROM lab_tests WHERE slug = 'dsdna-igm-antibodies'
UNION ALL SELECT id, 'dsDNA IgM antitela', 'sr' FROM lab_tests WHERE slug = 'dsdna-igm-antibodies'
UNION ALL SELECT id, 'dsDNA IgM антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'dsdna-igm-antibodies'
UNION ALL SELECT id, 'Антитела к двуспиральной ДНК IgM', 'ru' FROM lab_tests WHERE slug = 'dsdna-igm-antibodies'
UNION ALL SELECT id, 'Анти-дсДНК IgM', 'ru' FROM lab_tests WHERE slug = 'dsdna-igm-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Glijadin IgA antitela', 'sr' FROM lab_tests WHERE slug = 'gliadin-iga-antibodies'
UNION ALL SELECT id, 'Глијадин IgA антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'gliadin-iga-antibodies'
UNION ALL SELECT id, 'Антиглиадиновые антитела IgA', 'ru' FROM lab_tests WHERE slug = 'gliadin-iga-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Glijadin IgG antitela', 'sr' FROM lab_tests WHERE slug = 'gliadin-igg-antibodies'
UNION ALL SELECT id, 'Глијадин IgG антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'gliadin-igg-antibodies'
UNION ALL SELECT id, 'Антиглиадиновые антитела IgG', 'ru' FROM lab_tests WHERE slug = 'gliadin-igg-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'IA-2 antitela', 'sr' FROM lab_tests WHERE slug = 'ia-2-antibodies'
UNION ALL SELECT id, 'IA-2 антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'ia-2-antibodies'
UNION ALL SELECT id, 'Антитела к тирозинфосфатазе', 'ru' FROM lab_tests WHERE slug = 'ia-2-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antiphospholipid Antibodies IgG', 'en' FROM lab_tests WHERE slug = 'phospholipid-igg-antibodies'
UNION ALL SELECT id, 'Fosfolipid IgG antitela', 'sr' FROM lab_tests WHERE slug = 'phospholipid-igg-antibodies'
UNION ALL SELECT id, 'Фосфолипид IgG антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'phospholipid-igg-antibodies'
UNION ALL SELECT id, 'Antifosfolipidna antitijela IgG', 'sr' FROM lab_tests WHERE slug = 'phospholipid-igg-antibodies'
UNION ALL SELECT id, 'Антифосфолипидна антитијела IgG', 'sr-cyrl' FROM lab_tests WHERE slug = 'phospholipid-igg-antibodies'
UNION ALL SELECT id, 'Антифосфолипидные антитела IgG', 'ru' FROM lab_tests WHERE slug = 'phospholipid-igg-antibodies'
UNION ALL SELECT id, 'Antiphospholipid-Antikörper IgG', 'de' FROM lab_tests WHERE slug = 'phospholipid-igg-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antiphospholipid Antibodies IgM', 'en' FROM lab_tests WHERE slug = 'phospholipid-igm-antibodies'
UNION ALL SELECT id, 'Fosfolipid IgM antitela', 'sr' FROM lab_tests WHERE slug = 'phospholipid-igm-antibodies'
UNION ALL SELECT id, 'Фосфолипид IgM антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'phospholipid-igm-antibodies'
UNION ALL SELECT id, 'Antifosfolipidna antitijela IgM', 'sr' FROM lab_tests WHERE slug = 'phospholipid-igm-antibodies'
UNION ALL SELECT id, 'Антифосфолипидна антитијела IgM', 'sr-cyrl' FROM lab_tests WHERE slug = 'phospholipid-igm-antibodies'
UNION ALL SELECT id, 'Антифосфолипидные антитела IgM', 'ru' FROM lab_tests WHERE slug = 'phospholipid-igm-antibodies'
UNION ALL SELECT id, 'Antiphospholipid-Antikörper IgM', 'de' FROM lab_tests WHERE slug = 'phospholipid-igm-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Anti-tTG IgA', 'en' FROM lab_tests WHERE slug = 'transglutaminase-iga-antibodies'
UNION ALL SELECT id, 'Transglutaminaza IgA antitela', 'sr' FROM lab_tests WHERE slug = 'transglutaminase-iga-antibodies'
UNION ALL SELECT id, 'Трансглутаминаза IgA антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'transglutaminase-iga-antibodies'
UNION ALL SELECT id, 'Gewebstransglutaminase-IgA-Antikörper', 'de' FROM lab_tests WHERE slug = 'transglutaminase-iga-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Anti-tTG IgG', 'en' FROM lab_tests WHERE slug = 'transglutaminase-igg-antibodies'
UNION ALL SELECT id, 'Transglutaminaza IgG antitela', 'sr' FROM lab_tests WHERE slug = 'transglutaminase-igg-antibodies'
UNION ALL SELECT id, 'Трансглутаминаза IgG антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'transglutaminase-igg-antibodies'
UNION ALL SELECT id, 'Gewebstransglutaminase-IgG-Antikörper', 'de' FROM lab_tests WHERE slug = 'transglutaminase-igg-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Alergija na antibiotike', 'sr' FROM lab_tests WHERE slug = 'antibiotic-allergy-panel-10-allergens'
UNION ALL SELECT id, 'Алергија на антибиотике', 'sr-cyrl' FROM lab_tests WHERE slug = 'antibiotic-allergy-panel-10-allergens'
UNION ALL SELECT id, 'Аллергия на антибиотики', 'ru' FROM lab_tests WHERE slug = 'antibiotic-allergy-panel-10-allergens'
UNION ALL SELECT id, 'Панель аллергенов на антибиотики', 'ru' FROM lab_tests WHERE slug = 'antibiotic-allergy-panel-10-allergens';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Панель пищевых аллергенов', 'ru' FROM lab_tests WHERE slug = 'food-allergy-panel-30-allergens';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Intolerancija na hranu IgG', 'sr' FROM lab_tests WHERE slug = 'food-intolerance-panel-90-foods'
UNION ALL SELECT id, 'Интолеранција на храну IgG', 'sr-cyrl' FROM lab_tests WHERE slug = 'food-intolerance-panel-90-foods'
UNION ALL SELECT id, 'Пищевая непереносимость IgG', 'ru' FROM lab_tests WHERE slug = 'food-intolerance-panel-90-foods'
UNION ALL SELECT id, 'Непереносимость пищи', 'ru' FROM lab_tests WHERE slug = 'food-intolerance-panel-90-foods';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Панель ингаляционных аллергенов', 'ru' FROM lab_tests WHERE slug = 'inhalant-allergy-panel-30-allergens'
UNION ALL SELECT id, 'Респираторная аллергопанель', 'ru' FROM lab_tests WHERE slug = 'inhalant-allergy-panel-30-allergens';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Alergo panel za decu', 'sr' FROM lab_tests WHERE slug = 'pediatric-allergy-panel-30-allergens'
UNION ALL SELECT id, 'Алерго панел за децу', 'sr-cyrl' FROM lab_tests WHERE slug = 'pediatric-allergy-panel-30-allergens'
UNION ALL SELECT id, 'Педиатрическая панель аллергенов', 'ru' FROM lab_tests WHERE slug = 'pediatric-allergy-panel-30-allergens'
UNION ALL SELECT id, 'Аллергопанель для детей', 'ru' FROM lab_tests WHERE slug = 'pediatric-allergy-panel-30-allergens';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'High-Sensitivity Troponin T', 'en' FROM lab_tests WHERE slug = 'troponin-t-hs'
UNION ALL SELECT id, 'Troponin T visoke osetljivosti', 'sr' FROM lab_tests WHERE slug = 'troponin-t-hs'
UNION ALL SELECT id, 'Тропонин T високе осетљивости', 'sr-cyrl' FROM lab_tests WHERE slug = 'troponin-t-hs'
UNION ALL SELECT id, 'Высокочувствительный тропонин Т', 'ru' FROM lab_tests WHERE slug = 'troponin-t-hs';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Генетический анализ BRCA', 'ru' FROM lab_tests WHERE slug = 'brca1-brca2-genetic-test';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Bacteriological Examination Ear Swab', 'en' FROM lab_tests WHERE slug = 'bacteriological-examination-ear-swab'
UNION ALL SELECT id, 'Посев из уха', 'ru' FROM lab_tests WHERE slug = 'bacteriological-examination-ear-swab';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Cervical Swab Bacteria', 'en' FROM lab_tests WHERE slug = 'cervical-swab-bacteria'
UNION ALL SELECT id, 'Bris grlića materice na bakterije', 'sr' FROM lab_tests WHERE slug = 'cervical-swab-bacteria'
UNION ALL SELECT id, 'Брис грлића материце на бактерије', 'sr-cyrl' FROM lab_tests WHERE slug = 'cervical-swab-bacteria'
UNION ALL SELECT id, 'Мазок из цервикального канала на бактерии', 'ru' FROM lab_tests WHERE slug = 'cervical-swab-bacteria'
UNION ALL SELECT id, 'Gebärmutterhalsabstrich auf Bakterien', 'de' FROM lab_tests WHERE slug = 'cervical-swab-bacteria'
UNION ALL SELECT id, 'Rahim ağzı sürüntüsünde bakteri', 'tr' FROM lab_tests WHERE slug = 'cervical-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Cervical Swab Fungi', 'en' FROM lab_tests WHERE slug = 'cervical-swab-fungi'
UNION ALL SELECT id, 'Bris grlića materice na gljivice', 'sr' FROM lab_tests WHERE slug = 'cervical-swab-fungi'
UNION ALL SELECT id, 'Брис грлића материце на гљивице', 'sr-cyrl' FROM lab_tests WHERE slug = 'cervical-swab-fungi'
UNION ALL SELECT id, 'Мазок из цервикального канала на грибы', 'ru' FROM lab_tests WHERE slug = 'cervical-swab-fungi'
UNION ALL SELECT id, 'Gebärmutterhalsabstrich auf Pilze', 'de' FROM lab_tests WHERE slug = 'cervical-swab-fungi'
UNION ALL SELECT id, 'Rahim ağzı sürüntüsünde mantar', 'tr' FROM lab_tests WHERE slug = 'cervical-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Dermatophytes Hair Scraping', 'en' FROM lab_tests WHERE slug = 'dermatophytes-hair-scraping';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Dermatophytes Nail Scraping', 'en' FROM lab_tests WHERE slug = 'dermatophytes-nail-scraping'
UNION ALL SELECT id, 'Анализ на грибок ногтей', 'ru' FROM lab_tests WHERE slug = 'dermatophytes-nail-scraping'
UNION ALL SELECT id, 'Nagelpilz-Test', 'de' FROM lab_tests WHERE slug = 'dermatophytes-nail-scraping'
UNION ALL SELECT id, 'Tırnak mantarı testi', 'tr' FROM lab_tests WHERE slug = 'dermatophytes-nail-scraping';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Dermatophytes Skin Scraping', 'en' FROM lab_tests WHERE slug = 'dermatophytes-skin-scraping';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Wet Mount', 'en' FROM lab_tests WHERE slug = 'direct-microscopic-preparation'
UNION ALL SELECT id, 'Nativni preparat', 'sr' FROM lab_tests WHERE slug = 'direct-microscopic-preparation'
UNION ALL SELECT id, 'Нативни препарат', 'sr-cyrl' FROM lab_tests WHERE slug = 'direct-microscopic-preparation'
UNION ALL SELECT id, 'Нативный препарат', 'ru' FROM lab_tests WHERE slug = 'direct-microscopic-preparation'
UNION ALL SELECT id, 'Нативная микроскопия', 'ru' FROM lab_tests WHERE slug = 'direct-microscopic-preparation'
UNION ALL SELECT id, 'Nativpräparat', 'de' FROM lab_tests WHERE slug = 'direct-microscopic-preparation';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Glans Swab Bacteria', 'en' FROM lab_tests WHERE slug = 'glans-swab-bacteria'
UNION ALL SELECT id, 'Bris glavića penisa na bakterije', 'sr' FROM lab_tests WHERE slug = 'glans-swab-bacteria'
UNION ALL SELECT id, 'Брис главића пениса на бактерије', 'sr-cyrl' FROM lab_tests WHERE slug = 'glans-swab-bacteria'
UNION ALL SELECT id, 'Мазок с головки на бактерии', 'ru' FROM lab_tests WHERE slug = 'glans-swab-bacteria'
UNION ALL SELECT id, 'Eichelabstrich auf Bakterien', 'de' FROM lab_tests WHERE slug = 'glans-swab-bacteria'
UNION ALL SELECT id, 'Penis başı sürüntüsünde bakteri', 'tr' FROM lab_tests WHERE slug = 'glans-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Glans Swab Fungi', 'en' FROM lab_tests WHERE slug = 'glans-swab-fungi'
UNION ALL SELECT id, 'Bris glavića penisa na gljivice', 'sr' FROM lab_tests WHERE slug = 'glans-swab-fungi'
UNION ALL SELECT id, 'Брис главића пениса на гљивице', 'sr-cyrl' FROM lab_tests WHERE slug = 'glans-swab-fungi'
UNION ALL SELECT id, 'Мазок с головки на грибы', 'ru' FROM lab_tests WHERE slug = 'glans-swab-fungi'
UNION ALL SELECT id, 'Eichelabstrich auf Pilze', 'de' FROM lab_tests WHERE slug = 'glans-swab-fungi'
UNION ALL SELECT id, 'Penis başı sürüntüsünde mantar', 'tr' FROM lab_tests WHERE slug = 'glans-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Hair Swab Fungi', 'en' FROM lab_tests WHERE slug = 'hair-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Bris levog oka', 'sr' FROM lab_tests WHERE slug = 'left-eye-swab'
UNION ALL SELECT id, 'Брис левог ока', 'sr-cyrl' FROM lab_tests WHERE slug = 'left-eye-swab';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Left Eye Swab Fungi', 'en' FROM lab_tests WHERE slug = 'left-eye-swab-fungi'
UNION ALL SELECT id, 'Bris levog oka na gljivice', 'sr' FROM lab_tests WHERE slug = 'left-eye-swab-fungi'
UNION ALL SELECT id, 'Брис левог ока на гљивице', 'sr-cyrl' FROM lab_tests WHERE slug = 'left-eye-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Mikroskopski pregled na gonoreju', 'sr' FROM lab_tests WHERE slug = 'microscopic-examination-of-swab-for-gonorrhea'
UNION ALL SELECT id, 'Микроскопски преглед на гонореју', 'sr-cyrl' FROM lab_tests WHERE slug = 'microscopic-examination-of-swab-for-gonorrhea';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Nail Swab Fungi', 'en' FROM lab_tests WHERE slug = 'nail-swab-fungi'
UNION ALL SELECT id, 'Анализ ногтя на грибок', 'ru' FROM lab_tests WHERE slug = 'nail-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Nose Swab Bacteria', 'en' FROM lab_tests WHERE slug = 'nose-swab-bacteria'
UNION ALL SELECT id, 'Мазок из носа на флору', 'ru' FROM lab_tests WHERE slug = 'nose-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Nose Swab Fungi', 'en' FROM lab_tests WHERE slug = 'nose-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Oral Cavity Fungi', 'en' FROM lab_tests WHERE slug = 'oral-cavity-fungi'
UNION ALL SELECT id, 'Bris usta na gljivice', 'sr' FROM lab_tests WHERE slug = 'oral-cavity-fungi'
UNION ALL SELECT id, 'Брис уста на гљивице', 'sr-cyrl' FROM lab_tests WHERE slug = 'oral-cavity-fungi'
UNION ALL SELECT id, 'Мазок изо рта на грибы', 'ru' FROM lab_tests WHERE slug = 'oral-cavity-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Oral Cavity Swab Bacteria', 'en' FROM lab_tests WHERE slug = 'oral-cavity-swab-bacteria'
UNION ALL SELECT id, 'Bris usta na bakterije', 'sr' FROM lab_tests WHERE slug = 'oral-cavity-swab-bacteria'
UNION ALL SELECT id, 'Брис уста на бактерије', 'sr-cyrl' FROM lab_tests WHERE slug = 'oral-cavity-swab-bacteria'
UNION ALL SELECT id, 'Мазок изо рта на бактерии', 'ru' FROM lab_tests WHERE slug = 'oral-cavity-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Palate Swab Fungi', 'en' FROM lab_tests WHERE slug = 'palate-swab-fungi'
UNION ALL SELECT id, 'Мазок с нёба на грибы', 'ru' FROM lab_tests WHERE slug = 'palate-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Perianal Swab Fungi', 'en' FROM lab_tests WHERE slug = 'perianal-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Prepuce Swab Bacteria', 'en' FROM lab_tests WHERE slug = 'prepuce-swab-bacteria'
UNION ALL SELECT id, 'Мазок с крайней плоти на флору', 'ru' FROM lab_tests WHERE slug = 'prepuce-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Prepuce Swab Fungi', 'en' FROM lab_tests WHERE slug = 'prepuce-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Punctate Aerobic', 'en' FROM lab_tests WHERE slug = 'punctate-aerobic'
UNION ALL SELECT id, 'Посев пунктата на аэробы', 'ru' FROM lab_tests WHERE slug = 'punctate-aerobic'
UNION ALL SELECT id, 'Punktatkultur aerob', 'de' FROM lab_tests WHERE slug = 'punctate-aerobic';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Punctate Fungi', 'en' FROM lab_tests WHERE slug = 'punctate-fungi'
UNION ALL SELECT id, 'Kultura punktata na gljivice', 'sr' FROM lab_tests WHERE slug = 'punctate-fungi'
UNION ALL SELECT id, 'Култура пунктата на гљивице', 'sr-cyrl' FROM lab_tests WHERE slug = 'punctate-fungi'
UNION ALL SELECT id, 'Посев пунктата на грибы', 'ru' FROM lab_tests WHERE slug = 'punctate-fungi'
UNION ALL SELECT id, 'Punktat-Pilzkultur', 'de' FROM lab_tests WHERE slug = 'punctate-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Right Eye Swab Bacteria', 'en' FROM lab_tests WHERE slug = 'right-eye-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Right Eye Swab Fungi', 'en' FROM lab_tests WHERE slug = 'right-eye-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Skin Scraping Fungi', 'en' FROM lab_tests WHERE slug = 'skin-scraping-fungi'
UNION ALL SELECT id, 'Struganje kože na gljivice', 'sr' FROM lab_tests WHERE slug = 'skin-scraping-fungi'
UNION ALL SELECT id, 'Стругање коже на гљивице', 'sr-cyrl' FROM lab_tests WHERE slug = 'skin-scraping-fungi'
UNION ALL SELECT id, 'Hautgeschabsel auf Pilze', 'de' FROM lab_tests WHERE slug = 'skin-scraping-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Skin Swab Bacteria', 'en' FROM lab_tests WHERE slug = 'skin-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Skin Swab Fungi', 'en' FROM lab_tests WHERE slug = 'skin-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Sperm Culture Bacteria', 'en' FROM lab_tests WHERE slug = 'sperm-culture-bacteria'
UNION ALL SELECT id, 'Бакпосев спермы', 'ru' FROM lab_tests WHERE slug = 'sperm-culture-bacteria'
UNION ALL SELECT id, 'Посев эякулята', 'ru' FROM lab_tests WHERE slug = 'sperm-culture-bacteria'
UNION ALL SELECT id, 'Ejakulatkultur', 'de' FROM lab_tests WHERE slug = 'sperm-culture-bacteria'
UNION ALL SELECT id, 'Semen kültürü', 'tr' FROM lab_tests WHERE slug = 'sperm-culture-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Sperm Culture Fungi', 'en' FROM lab_tests WHERE slug = 'sperm-culture-fungi'
UNION ALL SELECT id, 'Посев эякулята на грибы', 'ru' FROM lab_tests WHERE slug = 'sperm-culture-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Sputum Bacteria', 'en' FROM lab_tests WHERE slug = 'sputum-bacteria'
UNION ALL SELECT id, 'Бакпосев мокроты', 'ru' FROM lab_tests WHERE slug = 'sputum-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Bris nosa na adenovirus', 'sr' FROM lab_tests WHERE slug = 'adenovirus-respiratory-test'
UNION ALL SELECT id, 'Брис носа на аденовирус', 'sr-cyrl' FROM lab_tests WHERE slug = 'adenovirus-respiratory-test'
UNION ALL SELECT id, 'Мазок на аденовирус', 'ru' FROM lab_tests WHERE slug = 'adenovirus-respiratory-test';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Breast Swab Fungi', 'en' FROM lab_tests WHERE slug = 'breast-swab-fungi'
UNION ALL SELECT id, 'Bris grudi na gljivice', 'sr' FROM lab_tests WHERE slug = 'breast-swab-fungi'
UNION ALL SELECT id, 'Брис груди на гљивице', 'sr-cyrl' FROM lab_tests WHERE slug = 'breast-swab-fungi'
UNION ALL SELECT id, 'Мазок из груди на грибы', 'ru' FROM lab_tests WHERE slug = 'breast-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Кампилобактер в кале', 'ru' FROM lab_tests WHERE slug = 'campylobacter-stool-test';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Kandida (kultura)', 'sr' FROM lab_tests WHERE slug = 'candida-culture'
UNION ALL SELECT id, 'Кандида (култура)', 'sr-cyrl' FROM lab_tests WHERE slug = 'candida-culture'
UNION ALL SELECT id, 'Кандида (культура)', 'ru' FROM lab_tests WHERE slug = 'candida-culture'
UNION ALL SELECT id, 'Посев на кандиду', 'ru' FROM lab_tests WHERE slug = 'candida-culture';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Chlamydia Genital Swab', 'en' FROM lab_tests WHERE slug = 'chlamydia-genital-swab'
UNION ALL SELECT id, 'Bris na hlamidiju', 'sr' FROM lab_tests WHERE slug = 'chlamydia-genital-swab'
UNION ALL SELECT id, 'Брис на хламидију', 'sr-cyrl' FROM lab_tests WHERE slug = 'chlamydia-genital-swab'
UNION ALL SELECT id, 'Мазок на хламидии', 'ru' FROM lab_tests WHERE slug = 'chlamydia-genital-swab'
UNION ALL SELECT id, 'Хламидиоз (мазок)', 'ru' FROM lab_tests WHERE slug = 'chlamydia-genital-swab'
UNION ALL SELECT id, 'Klamidya sürüntüsü', 'tr' FROM lab_tests WHERE slug = 'chlamydia-genital-swab';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Клостридиум диффициле – токсин A+B', 'ru' FROM lab_tests WHERE slug = 'clostridium-difficile-toxin-ab';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Dermatomycosis NMP', 'en' FROM lab_tests WHERE slug = 'dermatomycosis-nmp';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Kultura na dermatofite', 'sr' FROM lab_tests WHERE slug = 'dermatophytes-culture'
UNION ALL SELECT id, 'Култура на дерматофите', 'sr-cyrl' FROM lab_tests WHERE slug = 'dermatophytes-culture'
UNION ALL SELECT id, 'Посев на дерматофиты', 'ru' FROM lab_tests WHERE slug = 'dermatophytes-culture';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Биохимический скрининг 1 триместра', 'ru' FROM lab_tests WHERE slug = 'double-test-first-trimester-screening';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Ear Swab Bacteria', 'en' FROM lab_tests WHERE slug = 'ear-swab-bacteria'
UNION ALL SELECT id, 'Мазок из уха на флору', 'ru' FROM lab_tests WHERE slug = 'ear-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Eye Swab Bacteria', 'en' FROM lab_tests WHERE slug = 'eye-swab-bacteria'
UNION ALL SELECT id, 'Conjunctival Swab Culture', 'en' FROM lab_tests WHERE slug = 'eye-swab-bacteria'
UNION ALL SELECT id, 'Bris konjunktive', 'sr' FROM lab_tests WHERE slug = 'eye-swab-bacteria'
UNION ALL SELECT id, 'Брис конјунктиве', 'sr-cyrl' FROM lab_tests WHERE slug = 'eye-swab-bacteria'
UNION ALL SELECT id, 'Мазок с конъюнктивы', 'ru' FROM lab_tests WHERE slug = 'eye-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Eye Swab Fungi', 'en' FROM lab_tests WHERE slug = 'eye-swab-fungi'
UNION ALL SELECT id, 'Bris konjunktive na gljivice', 'sr' FROM lab_tests WHERE slug = 'eye-swab-fungi'
UNION ALL SELECT id, 'Брис конјунктиве на гљивице', 'sr-cyrl' FROM lab_tests WHERE slug = 'eye-swab-fungi'
UNION ALL SELECT id, 'Мазок с конъюнктивы на грибы', 'ru' FROM lab_tests WHERE slug = 'eye-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Kindergarten Microbiology 2', 'en' FROM lab_tests WHERE slug = 'kindergarten-microbiology-2'
UNION ALL SELECT id, 'Analize za vrtić – grlo i perianalni otisak', 'sr' FROM lab_tests WHERE slug = 'kindergarten-microbiology-2'
UNION ALL SELECT id, 'Анализе за вртић – грло и перианални отисак', 'sr-cyrl' FROM lab_tests WHERE slug = 'kindergarten-microbiology-2'
UNION ALL SELECT id, 'Анализы для детского сада: зев и энтеробиоз', 'ru' FROM lab_tests WHERE slug = 'kindergarten-microbiology-2';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Kindergarten Microbiology 3', 'en' FROM lab_tests WHERE slug = 'kindergarten-microbiology-3'
UNION ALL SELECT id, 'Analize za vrtić – grlo, nos i perianalni otisak', 'sr' FROM lab_tests WHERE slug = 'kindergarten-microbiology-3'
UNION ALL SELECT id, 'Анализе за вртић – грло, нос и перианални отисак', 'sr-cyrl' FROM lab_tests WHERE slug = 'kindergarten-microbiology-3'
UNION ALL SELECT id, 'Анализы для детского сада: зев, нос и энтеробиоз', 'ru' FROM lab_tests WHERE slug = 'kindergarten-microbiology-3';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Bris na mikoplazmu i ureaplazmu', 'sr' FROM lab_tests WHERE slug = 'mycoplasma-ureaplasma-genital-swab'
UNION ALL SELECT id, 'Брис на микоплазму и уреаплазму', 'sr-cyrl' FROM lab_tests WHERE slug = 'mycoplasma-ureaplasma-genital-swab'
UNION ALL SELECT id, 'Мазок на микоплазму и уреаплазму', 'ru' FROM lab_tests WHERE slug = 'mycoplasma-ureaplasma-genital-swab'
UNION ALL SELECT id, 'Микоплазма и уреаплазма в мазке', 'ru' FROM lab_tests WHERE slug = 'mycoplasma-ureaplasma-genital-swab'
UNION ALL SELECT id, 'Mikoplazma üreaplazma sürüntüsü', 'tr' FROM lab_tests WHERE slug = 'mycoplasma-ureaplasma-genital-swab';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Gonokok (kultura)', 'sr' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-culture'
UNION ALL SELECT id, 'Гонокок (култура)', 'sr-cyrl' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-culture'
UNION ALL SELECT id, 'Гонококк (культура)', 'ru' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-culture'
UNION ALL SELECT id, 'Посев на гонорею', 'ru' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-culture'
UNION ALL SELECT id, 'Gonore kültürü', 'tr' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-culture';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Brzi test na gonoreju', 'sr' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-rapid-test'
UNION ALL SELECT id, 'Брзи тест на гонореју', 'sr-cyrl' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-rapid-test'
UNION ALL SELECT id, 'Гонококк – быстрый тест', 'ru' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-rapid-test'
UNION ALL SELECT id, 'Экспресс-тест на гонорею', 'ru' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-rapid-test'
UNION ALL SELECT id, 'Gonore hızlı testi', 'tr' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-rapid-test';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Postoperative Wound Swab Anaerobic', 'en' FROM lab_tests WHERE slug = 'postoperative-wound-swab-anaerobic'
UNION ALL SELECT id, 'Посев из послеоперационной раны на аэробы и анаэробы', 'ru' FROM lab_tests WHERE slug = 'postoperative-wound-swab-anaerobic';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Protozoe u stolici', 'sr' FROM lab_tests WHERE slug = 'protozoa-stool-test'
UNION ALL SELECT id, 'Протозое у столици', 'sr-cyrl' FROM lab_tests WHERE slug = 'protozoa-stool-test'
UNION ALL SELECT id, 'Кал на простейшие', 'ru' FROM lab_tests WHERE slug = 'protozoa-stool-test'
UNION ALL SELECT id, 'Лямблии, криптоспоридии, амёбы в кале', 'ru' FROM lab_tests WHERE slug = 'protozoa-stool-test';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Punctate Aerobic Anaerobic', 'en' FROM lab_tests WHERE slug = 'punctate-aerobic-anaerobic'
UNION ALL SELECT id, 'Посев пунктата на аэробы и анаэробы', 'ru' FROM lab_tests WHERE slug = 'punctate-aerobic-anaerobic'
UNION ALL SELECT id, 'Punktatkultur aerob und anaerob', 'de' FROM lab_tests WHERE slug = 'punctate-aerobic-anaerobic';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Rectal Swab Bacteria', 'en' FROM lab_tests WHERE slug = 'rectal-swab-bacteria'
UNION ALL SELECT id, 'Мазок из прямой кишки на флору', 'ru' FROM lab_tests WHERE slug = 'rectal-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Rectal Swab Fungi', 'en' FROM lab_tests WHERE slug = 'rectal-swab-fungi'
UNION ALL SELECT id, 'Мазок из прямой кишки на грибы', 'ru' FROM lab_tests WHERE slug = 'rectal-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'STI Multiplex 2', 'en' FROM lab_tests WHERE slug = 'std-multiplex-2'
UNION ALL SELECT id, 'Polno prenosive infekcije – 2 patogena', 'sr' FROM lab_tests WHERE slug = 'std-multiplex-2'
UNION ALL SELECT id, 'Полно преносиве инфекције – 2 патогена', 'sr-cyrl' FROM lab_tests WHERE slug = 'std-multiplex-2'
UNION ALL SELECT id, 'ИППП мультиплекс на 2 возбудителя', 'ru' FROM lab_tests WHERE slug = 'std-multiplex-2';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'STI Multiplex 3', 'en' FROM lab_tests WHERE slug = 'std-multiplex-3'
UNION ALL SELECT id, 'Polno prenosive infekcije – 3 patogena', 'sr' FROM lab_tests WHERE slug = 'std-multiplex-3'
UNION ALL SELECT id, 'Полно преносиве инфекције – 3 патогена', 'sr-cyrl' FROM lab_tests WHERE slug = 'std-multiplex-3'
UNION ALL SELECT id, 'ИППП мультиплекс на 3 возбудителя', 'ru' FROM lab_tests WHERE slug = 'std-multiplex-3';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'STI Multiplex 4', 'en' FROM lab_tests WHERE slug = 'std-multiplex-4'
UNION ALL SELECT id, 'Polno prenosive infekcije – 4 patogena', 'sr' FROM lab_tests WHERE slug = 'std-multiplex-4'
UNION ALL SELECT id, 'Полно преносиве инфекције – 4 патогена', 'sr-cyrl' FROM lab_tests WHERE slug = 'std-multiplex-4'
UNION ALL SELECT id, 'ИППП мультиплекс на 4 возбудителя', 'ru' FROM lab_tests WHERE slug = 'std-multiplex-4';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'STI Multiplex 4 Plus HPV Quant 4', 'en' FROM lab_tests WHERE slug = 'std-multiplex-4-plus-hpv-quant-4'
UNION ALL SELECT id, 'ИППП мультиплекс на 4 возбудителя + ВПЧ', 'ru' FROM lab_tests WHERE slug = 'std-multiplex-4-plus-hpv-quant-4';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'STI Multiplex 5', 'en' FROM lab_tests WHERE slug = 'std-multiplex-5'
UNION ALL SELECT id, 'Polno prenosive infekcije – 5 patogena', 'sr' FROM lab_tests WHERE slug = 'std-multiplex-5'
UNION ALL SELECT id, 'Полно преносиве инфекције – 5 патогена', 'sr-cyrl' FROM lab_tests WHERE slug = 'std-multiplex-5'
UNION ALL SELECT id, 'ИППП мультиплекс на 5 возбудителей', 'ru' FROM lab_tests WHERE slug = 'std-multiplex-5';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'STI Multiplex 6', 'en' FROM lab_tests WHERE slug = 'std-multiplex-6'
UNION ALL SELECT id, 'Polno prenosive infekcije – 6 patogena', 'sr' FROM lab_tests WHERE slug = 'std-multiplex-6'
UNION ALL SELECT id, 'Полно преносиве инфекције – 6 патогена', 'sr-cyrl' FROM lab_tests WHERE slug = 'std-multiplex-6'
UNION ALL SELECT id, 'ИППП мультиплекс на 6 возбудителей', 'ru' FROM lab_tests WHERE slug = 'std-multiplex-6';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'STI Multiplex 7', 'en' FROM lab_tests WHERE slug = 'std-multiplex-7'
UNION ALL SELECT id, 'Polno prenosive infekcije – 7 patogena', 'sr' FROM lab_tests WHERE slug = 'std-multiplex-7'
UNION ALL SELECT id, 'Полно преносиве инфекције – 7 патогена', 'sr-cyrl' FROM lab_tests WHERE slug = 'std-multiplex-7'
UNION ALL SELECT id, 'ИППП мультиплекс на 7 возбудителей', 'ru' FROM lab_tests WHERE slug = 'std-multiplex-7';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Stool Culture Salmonella Shigella Ecoli', 'en' FROM lab_tests WHERE slug = 'stool-culture-salmonella-shigella-ecoli'
UNION ALL SELECT id, 'Koprokultura na salmonelu i šigelu', 'sr' FROM lab_tests WHERE slug = 'stool-culture-salmonella-shigella-ecoli'
UNION ALL SELECT id, 'Копрокултура на салмонелу и шигелу', 'sr-cyrl' FROM lab_tests WHERE slug = 'stool-culture-salmonella-shigella-ecoli'
UNION ALL SELECT id, 'Копрокультура на сальмонеллы и шигеллы', 'ru' FROM lab_tests WHERE slug = 'stool-culture-salmonella-shigella-ecoli'
UNION ALL SELECT id, 'Анализ кала на сальмонеллёз и шигеллёз', 'ru' FROM lab_tests WHERE slug = 'stool-culture-salmonella-shigella-ecoli';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Tuberculosis Test', 'en' FROM lab_tests WHERE slug = 'tb-test'
UNION ALL SELECT id, 'Test na tuberkulozu', 'sr' FROM lab_tests WHERE slug = 'tb-test'
UNION ALL SELECT id, 'Тест на туберкулозу', 'sr-cyrl' FROM lab_tests WHERE slug = 'tb-test';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Brzi test na trihomonas', 'sr' FROM lab_tests WHERE slug = 'trichomonas-rapid-test'
UNION ALL SELECT id, 'Брзи тест на трихомонас', 'sr-cyrl' FROM lab_tests WHERE slug = 'trichomonas-rapid-test'
UNION ALL SELECT id, 'Трихомонада – быстрый тест', 'ru' FROM lab_tests WHERE slug = 'trichomonas-rapid-test'
UNION ALL SELECT id, 'Экспресс-тест на трихомониаз', 'ru' FROM lab_tests WHERE slug = 'trichomonas-rapid-test'
UNION ALL SELECT id, 'Trikomonas hızlı testi', 'tr' FROM lab_tests WHERE slug = 'trichomonas-rapid-test';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Биохимический скрининг 2 триместра', 'ru' FROM lab_tests WHERE slug = 'triple-test-second-trimester-screening';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'PCR na ureaplazmu', 'sr' FROM lab_tests WHERE slug = 'ureaplasma-pcr'
UNION ALL SELECT id, 'PCR на уреаплазму', 'sr-cyrl' FROM lab_tests WHERE slug = 'ureaplasma-pcr'
UNION ALL SELECT id, 'Уреаплазма (ПЦР)', 'ru' FROM lab_tests WHERE slug = 'ureaplasma-pcr'
UNION ALL SELECT id, 'ПЦР на уреаплазму', 'ru' FROM lab_tests WHERE slug = 'ureaplasma-pcr'
UNION ALL SELECT id, 'Üreaplazma PCR', 'tr' FROM lab_tests WHERE slug = 'ureaplasma-pcr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Urine Culture Bacteria', 'en' FROM lab_tests WHERE slug = 'urine-culture-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Wound Swab Aerobic Bacteria', 'en' FROM lab_tests WHERE slug = 'wound-swab-aerobic-bacteria'
UNION ALL SELECT id, 'Посев из раны на аэробы', 'ru' FROM lab_tests WHERE slug = 'wound-swab-aerobic-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled polipa grlića materice', 'sr' FROM lab_tests WHERE slug = 'histopathology-cervical-polyp-examination'
UNION ALL SELECT id, 'Патохистолошки преглед полипа грлића материце', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-cervical-polyp-examination'
UNION ALL SELECT id, 'Гистология полипа шейки матки', 'ru' FROM lab_tests WHERE slug = 'histopathology-cervical-polyp-examination';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled biopsije debelog crijeva', 'sr' FROM lab_tests WHERE slug = 'histopathology-colon-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед биопсије дебелог цријева', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-colon-biopsy'
UNION ALL SELECT id, 'Гистология биопсии толстой кишки', 'ru' FROM lab_tests WHERE slug = 'histopathology-colon-biopsy'
UNION ALL SELECT id, 'Гистология биопсии толстого кишечника', 'ru' FROM lab_tests WHERE slug = 'histopathology-colon-biopsy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled biopsije duodenuma', 'sr' FROM lab_tests WHERE slug = 'histopathology-duodenum-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед биопсије дуоденума', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-duodenum-biopsy'
UNION ALL SELECT id, 'Patohistološki pregled biopsije dvanaestopalačnog crijeva', 'sr' FROM lab_tests WHERE slug = 'histopathology-duodenum-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед биопсије дванаестопалачног цријева', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-duodenum-biopsy'
UNION ALL SELECT id, 'Гистология биопсии двенадцатиперстной кишки', 'ru' FROM lab_tests WHERE slug = 'histopathology-duodenum-biopsy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled biopsije medijastinuma', 'sr' FROM lab_tests WHERE slug = 'histopathology-mediastinum-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед биопсије медијастинума', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-mediastinum-biopsy'
UNION ALL SELECT id, 'Гистология биопсии средостения', 'ru' FROM lab_tests WHERE slug = 'histopathology-mediastinum-biopsy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled iglene biopsije prostate više uzoraka', 'sr' FROM lab_tests WHERE slug = 'histopathology-needle-prostate-biopsy-multiple-samples'
UNION ALL SELECT id, 'Патохистолошки преглед иглене биопсије простате више узорака', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-needle-prostate-biopsy-multiple-samples'
UNION ALL SELECT id, 'Гистология игольной биопсии простаты (несколько образцов)', 'ru' FROM lab_tests WHERE slug = 'histopathology-needle-prostate-biopsy-multiple-samples';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled testisa nakon orhiektomije', 'sr' FROM lab_tests WHERE slug = 'histopathology-orchiectomy-testis-examination'
UNION ALL SELECT id, 'Патохистолошки преглед тестиса након орхиектомије', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-orchiectomy-testis-examination'
UNION ALL SELECT id, 'Гистология яичка после орхиэктомии', 'ru' FROM lab_tests WHERE slug = 'histopathology-orchiectomy-testis-examination';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled odstranjene dojke', 'sr' FROM lab_tests WHERE slug = 'histopathology-removed-breast-examination'
UNION ALL SELECT id, 'Патохистолошки преглед одстрањене дојке', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-removed-breast-examination'
UNION ALL SELECT id, 'Гистология удалённой молочной железы', 'ru' FROM lab_tests WHERE slug = 'histopathology-removed-breast-examination'
UNION ALL SELECT id, 'Гистология после мастэктомии', 'ru' FROM lab_tests WHERE slug = 'histopathology-removed-breast-examination';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Revizija patohistološkog nalaza', 'sr' FROM lab_tests WHERE slug = 'histopathology-report-review'
UNION ALL SELECT id, 'Ревизија патохистолошког налаза', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-report-review'
UNION ALL SELECT id, 'Пересмотр гистологических препаратов', 'ru' FROM lab_tests WHERE slug = 'histopathology-report-review';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled pojedinačne biopsije prostate', 'sr' FROM lab_tests WHERE slug = 'histopathology-single-prostate-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед појединачне биопсије простате', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-single-prostate-biopsy'
UNION ALL SELECT id, 'Гистология одиночной биопсии простаты', 'ru' FROM lab_tests WHERE slug = 'histopathology-single-prostate-biopsy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled biopsije želuca', 'sr' FROM lab_tests WHERE slug = 'histopathology-stomach-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед биопсије желуца', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-stomach-biopsy'
UNION ALL SELECT id, 'Гистология биопсии желудка', 'ru' FROM lab_tests WHERE slug = 'histopathology-stomach-biopsy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled potkožnog tumora', 'sr' FROM lab_tests WHERE slug = 'histopathology-subcutaneous-tumor-examination'
UNION ALL SELECT id, 'Патохистолошки преглед поткожног тумора', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-subcutaneous-tumor-examination'
UNION ALL SELECT id, 'Гистология подкожной опухоли', 'ru' FROM lab_tests WHERE slug = 'histopathology-subcutaneous-tumor-examination';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Sputum Fungi', 'en' FROM lab_tests WHERE slug = 'sputum-fungi'
UNION ALL SELECT id, 'Kultura ispljuvka na gljivice', 'sr' FROM lab_tests WHERE slug = 'sputum-fungi'
UNION ALL SELECT id, 'Култура испљувка на гљивице', 'sr-cyrl' FROM lab_tests WHERE slug = 'sputum-fungi'
UNION ALL SELECT id, 'Мокрота на грибы', 'ru' FROM lab_tests WHERE slug = 'sputum-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Throat Swab Bacteria', 'en' FROM lab_tests WHERE slug = 'throat-swab-bacteria'
UNION ALL SELECT id, 'Bris ždrijela na bakterije', 'sr' FROM lab_tests WHERE slug = 'throat-swab-bacteria'
UNION ALL SELECT id, 'Брис ждријела на бактерије', 'sr-cyrl' FROM lab_tests WHERE slug = 'throat-swab-bacteria'
UNION ALL SELECT id, 'Bris ždrela na bakterije', 'sr' FROM lab_tests WHERE slug = 'throat-swab-bacteria'
UNION ALL SELECT id, 'Брис ждрела на бактерије', 'sr-cyrl' FROM lab_tests WHERE slug = 'throat-swab-bacteria'
UNION ALL SELECT id, 'Мазок из зева на бактерии', 'ru' FROM lab_tests WHERE slug = 'throat-swab-bacteria'
UNION ALL SELECT id, 'Мазок из горла на флору', 'ru' FROM lab_tests WHERE slug = 'throat-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Throat Swab Fungi', 'en' FROM lab_tests WHERE slug = 'throat-swab-fungi'
UNION ALL SELECT id, 'Bris ždrijela na gljivice', 'sr' FROM lab_tests WHERE slug = 'throat-swab-fungi'
UNION ALL SELECT id, 'Брис ждријела на гљивице', 'sr-cyrl' FROM lab_tests WHERE slug = 'throat-swab-fungi'
UNION ALL SELECT id, 'Мазок из зева на грибы', 'ru' FROM lab_tests WHERE slug = 'throat-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Tongue Swab Bacteria', 'en' FROM lab_tests WHERE slug = 'tongue-swab-bacteria'
UNION ALL SELECT id, 'Мазок с языка на флору', 'ru' FROM lab_tests WHERE slug = 'tongue-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Tongue Swab Fungi', 'en' FROM lab_tests WHERE slug = 'tongue-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Umbilicus Swab Bacteria', 'en' FROM lab_tests WHERE slug = 'umbilicus-swab-bacteria'
UNION ALL SELECT id, 'Мазок с пупка на бактерии', 'ru' FROM lab_tests WHERE slug = 'umbilicus-swab-bacteria'
UNION ALL SELECT id, 'Мазок из пупочной ранки', 'ru' FROM lab_tests WHERE slug = 'umbilicus-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Umbilicus Swab Fungi', 'en' FROM lab_tests WHERE slug = 'umbilicus-swab-fungi'
UNION ALL SELECT id, 'Мазок с пупка на грибы', 'ru' FROM lab_tests WHERE slug = 'umbilicus-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Urethral Swab Bacteria', 'en' FROM lab_tests WHERE slug = 'urethral-swab-bacteria'
UNION ALL SELECT id, 'Мазок из уретры на флору', 'ru' FROM lab_tests WHERE slug = 'urethral-swab-bacteria'
UNION ALL SELECT id, 'Мазок из мочеиспускательного канала на бактерии', 'ru' FROM lab_tests WHERE slug = 'urethral-swab-bacteria'
UNION ALL SELECT id, 'Urethralabstrich auf Bakterien', 'de' FROM lab_tests WHERE slug = 'urethral-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Urethral Swab Fungi', 'en' FROM lab_tests WHERE slug = 'urethral-swab-fungi'
UNION ALL SELECT id, 'Мазок из мочеиспускательного канала на грибы', 'ru' FROM lab_tests WHERE slug = 'urethral-swab-fungi'
UNION ALL SELECT id, 'Urethralabstrich auf Pilze', 'de' FROM lab_tests WHERE slug = 'urethral-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Urine Fungi', 'en' FROM lab_tests WHERE slug = 'urine-fungi'
UNION ALL SELECT id, 'Urinokultura na gljivice', 'sr' FROM lab_tests WHERE slug = 'urine-fungi'
UNION ALL SELECT id, 'Уринокултура на гљивице', 'sr-cyrl' FROM lab_tests WHERE slug = 'urine-fungi'
UNION ALL SELECT id, 'Анализ мочи на грибы', 'ru' FROM lab_tests WHERE slug = 'urine-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Vaginal Swab Bacteria', 'en' FROM lab_tests WHERE slug = 'vaginal-swab-bacteria'
UNION ALL SELECT id, 'Vaginalni bris na bakterije', 'sr' FROM lab_tests WHERE slug = 'vaginal-swab-bacteria'
UNION ALL SELECT id, 'Вагинални брис на бактерије', 'sr-cyrl' FROM lab_tests WHERE slug = 'vaginal-swab-bacteria'
UNION ALL SELECT id, 'Бакпосев из влагалища', 'ru' FROM lab_tests WHERE slug = 'vaginal-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Vaginal Swab Fungi', 'en' FROM lab_tests WHERE slug = 'vaginal-swab-fungi'
UNION ALL SELECT id, 'Vaginalni bris na gljivice', 'sr' FROM lab_tests WHERE slug = 'vaginal-swab-fungi'
UNION ALL SELECT id, 'Вагинални брис на гљивице', 'sr-cyrl' FROM lab_tests WHERE slug = 'vaginal-swab-fungi'
UNION ALL SELECT id, 'Мазок на молочницу', 'ru' FROM lab_tests WHERE slug = 'vaginal-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Vulvar Swab Bacteria', 'en' FROM lab_tests WHERE slug = 'vulvar-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Vulvar Swab Fungi', 'en' FROM lab_tests WHERE slug = 'vulvar-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Wound Swab Bacteria', 'en' FROM lab_tests WHERE slug = 'wound-swab-bacteria'
UNION ALL SELECT id, 'Бакпосев из раны', 'ru' FROM lab_tests WHERE slug = 'wound-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Wound Swab Fungi', 'en' FROM lab_tests WHERE slug = 'wound-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Тест на 5 наркотиков', 'ru' FROM lab_tests WHERE slug = 'drug-panel-5-new';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Whooping Cough PCR', 'en' FROM lab_tests WHERE slug = 'bordetella-pertussis-pcr'
UNION ALL SELECT id, 'Veliki kašalj PCR', 'sr' FROM lab_tests WHERE slug = 'bordetella-pertussis-pcr'
UNION ALL SELECT id, 'Велики кашаљ PCR', 'sr-cyrl' FROM lab_tests WHERE slug = 'bordetella-pertussis-pcr'
UNION ALL SELECT id, 'Pertusis PCR', 'sr' FROM lab_tests WHERE slug = 'bordetella-pertussis-pcr'
UNION ALL SELECT id, 'Пертусис PCR', 'sr-cyrl' FROM lab_tests WHERE slug = 'bordetella-pertussis-pcr'
UNION ALL SELECT id, 'ПЦР на коклюш', 'ru' FROM lab_tests WHERE slug = 'bordetella-pertussis-pcr'
UNION ALL SELECT id, 'Бордетелла ПЦР', 'ru' FROM lab_tests WHERE slug = 'bordetella-pertussis-pcr'
UNION ALL SELECT id, 'Keuchhusten-PCR', 'de' FROM lab_tests WHERE slug = 'bordetella-pertussis-pcr'
UNION ALL SELECT id, 'Boğmaca PCR', 'tr' FROM lab_tests WHERE slug = 'bordetella-pertussis-pcr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Chlamydia Trachomatis Mycoplasma Hominis Genitalium PCR', 'en' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-mycoplasma-hominis-genitalium-pcr'
UNION ALL SELECT id, 'PCR na hlamidiju i mikoplazmu', 'sr' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-mycoplasma-hominis-genitalium-pcr'
UNION ALL SELECT id, 'PCR на хламидију и микоплазму', 'sr-cyrl' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-mycoplasma-hominis-genitalium-pcr'
UNION ALL SELECT id, 'ПЦР на хламидии и микоплазмы', 'ru' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-mycoplasma-hominis-genitalium-pcr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Chlamydia Trachomatis PCR Urine', 'en' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-pcr-urine'
UNION ALL SELECT id, 'Hlamidija PCR u urinu', 'sr' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-pcr-urine'
UNION ALL SELECT id, 'Хламидија PCR у урину', 'sr-cyrl' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-pcr-urine'
UNION ALL SELECT id, 'ПЦР на хламидии в моче', 'ru' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-pcr-urine'
UNION ALL SELECT id, 'Хламидии в моче', 'ru' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-pcr-urine'
UNION ALL SELECT id, 'Chlamydien-PCR im Urin', 'de' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-pcr-urine'
UNION ALL SELECT id, 'İdrarda klamidya PCR', 'tr' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-pcr-urine';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Chlamydia Trachomatis Plus Ureaplasma', 'en' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-plus-ureaplasma'
UNION ALL SELECT id, 'Hlamidija i ureaplazma', 'sr' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-plus-ureaplasma'
UNION ALL SELECT id, 'Хламидија и уреаплазма', 'sr-cyrl' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-plus-ureaplasma'
UNION ALL SELECT id, 'Хламидии и уреаплазма', 'ru' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-plus-ureaplasma';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Chlamydia Trachomatis Ureaplasma Urealyticum Mycoplasma Hominis Genitalium PCR', 'en' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-ureaplasma-urealyticum-mycoplasma-hominis-genitalium-pcr'
UNION ALL SELECT id, 'PCR na hlamidiju, ureaplazmu i mikoplazmu', 'sr' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-ureaplasma-urealyticum-mycoplasma-hominis-genitalium-pcr'
UNION ALL SELECT id, 'PCR на хламидију, уреаплазму и микоплазму', 'sr-cyrl' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-ureaplasma-urealyticum-mycoplasma-hominis-genitalium-pcr'
UNION ALL SELECT id, 'ПЦР на хламидии, уреаплазму и микоплазмы', 'ru' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-ureaplasma-urealyticum-mycoplasma-hominis-genitalium-pcr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Flu PCR', 'en' FROM lab_tests WHERE slug = 'influenza-a-plus-b-pcr'
UNION ALL SELECT id, 'PCR na grip', 'sr' FROM lab_tests WHERE slug = 'influenza-a-plus-b-pcr'
UNION ALL SELECT id, 'PCR на грип', 'sr-cyrl' FROM lab_tests WHERE slug = 'influenza-a-plus-b-pcr'
UNION ALL SELECT id, 'ПЦР на грипп', 'ru' FROM lab_tests WHERE slug = 'influenza-a-plus-b-pcr'
UNION ALL SELECT id, 'Grippe-PCR', 'de' FROM lab_tests WHERE slug = 'influenza-a-plus-b-pcr'
UNION ALL SELECT id, 'Grip PCR testi', 'tr' FROM lab_tests WHERE slug = 'influenza-a-plus-b-pcr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Mycoplasma Hominis Genitalium PCR', 'en' FROM lab_tests WHERE slug = 'mycoplasma-hominis-genitalium-pcr'
UNION ALL SELECT id, 'Mikoplazma hominis i genitalium PCR', 'sr' FROM lab_tests WHERE slug = 'mycoplasma-hominis-genitalium-pcr'
UNION ALL SELECT id, 'Микоплазма хоминис и гениталиум PCR', 'sr-cyrl' FROM lab_tests WHERE slug = 'mycoplasma-hominis-genitalium-pcr'
UNION ALL SELECT id, 'Микоплазма хоминис и гениталиум ПЦР', 'ru' FROM lab_tests WHERE slug = 'mycoplasma-hominis-genitalium-pcr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Neisseria Gonorrhoeae PCR Urine', 'en' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-pcr-urine'
UNION ALL SELECT id, 'Gonokok PCR u urinu', 'sr' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-pcr-urine'
UNION ALL SELECT id, 'Гонокок PCR у урину', 'sr-cyrl' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-pcr-urine'
UNION ALL SELECT id, 'ПЦР на гонорею в моче', 'ru' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-pcr-urine'
UNION ALL SELECT id, 'Гонококк в моче', 'ru' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-pcr-urine'
UNION ALL SELECT id, 'Gonokokken-PCR im Urin', 'de' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-pcr-urine'
UNION ALL SELECT id, 'İdrarda gonore PCR', 'tr' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-pcr-urine';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Ureaplazma parvum PCR', 'sr' FROM lab_tests WHERE slug = 'ureaplasma-parvum-pcr'
UNION ALL SELECT id, 'Уреаплазма парвум PCR', 'sr-cyrl' FROM lab_tests WHERE slug = 'ureaplasma-parvum-pcr'
UNION ALL SELECT id, 'Уреаплазма парвум ПЦР', 'ru' FROM lab_tests WHERE slug = 'ureaplasma-parvum-pcr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Ureaplazma urealyticum PCR', 'sr' FROM lab_tests WHERE slug = 'ureaplasma-urealyticum-pcr'
UNION ALL SELECT id, 'Уреаплазма urealyticum PCR', 'sr-cyrl' FROM lab_tests WHERE slug = 'ureaplasma-urealyticum-pcr'
UNION ALL SELECT id, 'Уреаплазма уреалитикум ПЦР', 'ru' FROM lab_tests WHERE slug = 'ureaplasma-urealyticum-pcr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled TRUS prostate', 'sr' FROM lab_tests WHERE slug = 'histopathology-trus-prostate'
UNION ALL SELECT id, 'Патохистолошки преглед ТРУС простате', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-trus-prostate'
UNION ALL SELECT id, 'Гистология ТРУС простаты', 'ru' FROM lab_tests WHERE slug = 'histopathology-trus-prostate';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'IHC More Than 10 Antibodies', 'en' FROM lab_tests WHERE slug = 'immunohistochemistry-more-than-10-antibodies'
UNION ALL SELECT id, 'Imunohistohemija više od 10 antitela', 'sr' FROM lab_tests WHERE slug = 'immunohistochemistry-more-than-10-antibodies'
UNION ALL SELECT id, 'Имунохистохемија више од 10 антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'immunohistochemistry-more-than-10-antibodies'
UNION ALL SELECT id, 'ИГХ более 10 антител', 'ru' FROM lab_tests WHERE slug = 'immunohistochemistry-more-than-10-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Iglena biopsija dojke sa HER2 i Ki-67', 'sr' FROM lab_tests WHERE slug = 'needle-breast-biopsy-with-her2-and-ki67-receptors'
UNION ALL SELECT id, 'Иглена биопсија дојке са ХЕР2 и Ки-67', 'sr-cyrl' FROM lab_tests WHERE slug = 'needle-breast-biopsy-with-her2-and-ki67-receptors'
UNION ALL SELECT id, 'Игольная биопсия груди с HER2 и Ki-67', 'ru' FROM lab_tests WHERE slug = 'needle-breast-biopsy-with-her2-and-ki67-receptors';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Исследование удаленной молочной железы и подмышечных лимфоузлов', 'ru' FROM lab_tests WHERE slug = 'removed-breast-and-axillary-lymph-nodes-examination';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Pregled odstranjene dojke sa HER2 i Ki-67', 'sr' FROM lab_tests WHERE slug = 'removed-breast-with-her2-and-ki67-receptors'
UNION ALL SELECT id, 'Преглед одстрањене дојке са ХЕР2 и Ки-67', 'sr-cyrl' FROM lab_tests WHERE slug = 'removed-breast-with-her2-and-ki67-receptors'
UNION ALL SELECT id, 'Исследование удаленной молочной железы с HER2 и Ki-67', 'ru' FROM lab_tests WHERE slug = 'removed-breast-with-her2-and-ki67-receptors';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Klinasta biopsija dojke sa HER2 i Ki-67', 'sr' FROM lab_tests WHERE slug = 'surgical-breast-biopsy-with-her2-and-ki67-receptors'
UNION ALL SELECT id, 'Клинаста биопсија дојке са ХЕР2 и Ки-67', 'sr-cyrl' FROM lab_tests WHERE slug = 'surgical-breast-biopsy-with-her2-and-ki67-receptors'
UNION ALL SELECT id, 'Клиновидная биопсия груди с HER2 и Ki-67', 'ru' FROM lab_tests WHERE slug = 'surgical-breast-biopsy-with-her2-and-ki67-receptors';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Lamelarna tela u plodovoj vodi', 'sr' FROM lab_tests WHERE slug = 'lamellar-bodies-in-amniotic-fluid'
UNION ALL SELECT id, 'Ламеларна тела у плодовој води', 'sr-cyrl' FROM lab_tests WHERE slug = 'lamellar-bodies-in-amniotic-fluid'
UNION ALL SELECT id, 'Laminarna tijela u plodovoj vodi', 'sr' FROM lab_tests WHERE slug = 'lamellar-bodies-in-amniotic-fluid'
UNION ALL SELECT id, 'Ламинарна тијела у плодовој води', 'sr-cyrl' FROM lab_tests WHERE slug = 'lamellar-bodies-in-amniotic-fluid';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'НИПТ Панорама базовый', 'ru' FROM lab_tests WHERE slug = 'nipt-panorama-basic';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'НИПТ Панорама полная панель', 'ru' FROM lab_tests WHERE slug = 'nipt-panorama-full-panel';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'НИПТ Панорама плюс', 'ru' FROM lab_tests WHERE slug = 'nipt-panorama-plus';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Blood Count Selected Parameters', 'en' FROM lab_tests WHERE slug = 'blood-count-selected-parameters'
UNION ALL SELECT id, 'ОАК с 3-частной формулой', 'ru' FROM lab_tests WHERE slug = 'blood-count-selected-parameters';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Клинический анализ крови', 'ru' FROM lab_tests WHERE slug = 'complete-blood-count'
UNION ALL SELECT id, 'Гемограмма', 'ru' FROM lab_tests WHERE slug = 'complete-blood-count'
UNION ALL SELECT id, 'Hemogram', 'tr' FROM lab_tests WHERE slug = 'complete-blood-count';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'CBC with Differential', 'en' FROM lab_tests WHERE slug = 'complete-blood-count-with-leukocyte-formula'
UNION ALL SELECT id, 'Развёрнутый анализ крови', 'ru' FROM lab_tests WHERE slug = 'complete-blood-count-with-leukocyte-formula'
UNION ALL SELECT id, 'Клинический анализ крови с лейкоформулой', 'ru' FROM lab_tests WHERE slug = 'complete-blood-count-with-leukocyte-formula';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Erythrocyte Resistance', 'en' FROM lab_tests WHERE slug = 'erythrocyte-resistance'
UNION ALL SELECT id, 'Osmotic Fragility Test', 'en' FROM lab_tests WHERE slug = 'erythrocyte-resistance'
UNION ALL SELECT id, 'Осмотическая стойкость эритроцитов', 'ru' FROM lab_tests WHERE slug = 'erythrocyte-resistance'
UNION ALL SELECT id, 'Ozmotik frajilite testi', 'tr' FROM lab_tests WHERE slug = 'erythrocyte-resistance';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Platelet Count Microscopic', 'en' FROM lab_tests WHERE slug = 'platelet-count-microscopic'
UNION ALL SELECT id, 'Подсчёт тромбоцитов в счётной камере', 'ru' FROM lab_tests WHERE slug = 'platelet-count-microscopic';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Активность фактора фон Виллебранда', 'ru' FROM lab_tests WHERE slug = 'von-willebrand-factor-activity';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'HIV 1/2 antigen i antitijela', 'sr' FROM lab_tests WHERE slug = 'hiv-1-plus-2-ag-ab'
UNION ALL SELECT id, 'HIV 1/2 антиген и антитијела', 'sr-cyrl' FROM lab_tests WHERE slug = 'hiv-1-plus-2-ag-ab'
UNION ALL SELECT id, 'Комбинированный тест на ВИЧ 1/2', 'ru' FROM lab_tests WHERE slug = 'hiv-1-plus-2-ag-ab';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Adenovirus Rotavirus in Stool', 'en' FROM lab_tests WHERE slug = 'adenovirus-rotavirus-in-stool'
UNION ALL SELECT id, 'Stolica na rotavirus', 'sr' FROM lab_tests WHERE slug = 'adenovirus-rotavirus-in-stool'
UNION ALL SELECT id, 'Столица на ротавирус', 'sr-cyrl' FROM lab_tests WHERE slug = 'adenovirus-rotavirus-in-stool'
UNION ALL SELECT id, 'Кал на ротавирус', 'ru' FROM lab_tests WHERE slug = 'adenovirus-rotavirus-in-stool'
UNION ALL SELECT id, 'Кал на аденовирус', 'ru' FROM lab_tests WHERE slug = 'adenovirus-rotavirus-in-stool'
UNION ALL SELECT id, 'Dışkıda rotavirüs', 'tr' FROM lab_tests WHERE slug = 'adenovirus-rotavirus-in-stool';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'C. difficile Toxin', 'en' FROM lab_tests WHERE slug = 'clostridium-difficile-toxin-a-and-b'
UNION ALL SELECT id, 'Клостридиум диффициле – токсин A и B', 'ru' FROM lab_tests WHERE slug = 'clostridium-difficile-toxin-a-and-b';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Helikobakter u stolici', 'sr' FROM lab_tests WHERE slug = 'helicobacter-pylori-antigen-in-feces'
UNION ALL SELECT id, 'Хеликобактер у столици', 'sr-cyrl' FROM lab_tests WHERE slug = 'helicobacter-pylori-antigen-in-feces'
UNION ALL SELECT id, 'Хеликобактер пилори в кале', 'ru' FROM lab_tests WHERE slug = 'helicobacter-pylori-antigen-in-feces'
UNION ALL SELECT id, 'Кал на хеликобактер', 'ru' FROM lab_tests WHERE slug = 'helicobacter-pylori-antigen-in-feces';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Kultura stolice na bakterije', 'sr' FROM lab_tests WHERE slug = 'stool-culture'
UNION ALL SELECT id, 'Култура столице на бактерије', 'sr-cyrl' FROM lab_tests WHERE slug = 'stool-culture'
UNION ALL SELECT id, 'Копрокультура', 'ru' FROM lab_tests WHERE slug = 'stool-culture'
UNION ALL SELECT id, 'Бакпосев кала', 'ru' FROM lab_tests WHERE slug = 'stool-culture';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Stool Fungi', 'en' FROM lab_tests WHERE slug = 'stool-fungi'
UNION ALL SELECT id, 'Stolica na gljivice', 'sr' FROM lab_tests WHERE slug = 'stool-fungi'
UNION ALL SELECT id, 'Столица на гљивице', 'sr-cyrl' FROM lab_tests WHERE slug = 'stool-fungi'
UNION ALL SELECT id, 'Кал на грибы', 'ru' FROM lab_tests WHERE slug = 'stool-fungi'
UNION ALL SELECT id, 'Dışkıda mantar', 'tr' FROM lab_tests WHERE slug = 'stool-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Vanillylmandelic Acid', 'en' FROM lab_tests WHERE slug = 'vma'
UNION ALL SELECT id, 'Vanililmandelična kiselina', 'sr' FROM lab_tests WHERE slug = 'vma'
UNION ALL SELECT id, 'Ванилилманделична киселина', 'sr-cyrl' FROM lab_tests WHERE slug = 'vma'
UNION ALL SELECT id, 'ВМК', 'ru' FROM lab_tests WHERE slug = 'vma'
UNION ALL SELECT id, 'VMS', 'de' FROM lab_tests WHERE slug = 'vma';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Варицелла Зостер IgG авидность', 'ru' FROM lab_tests WHERE slug = 'varicella-zoster-igg-avidity';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'ВЭБ IgG авидность', 'ru' FROM lab_tests WHERE slug = 'epstein-barr-igg-avidity';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Авидность антител к краснухе', 'ru' FROM lab_tests WHERE slug = 'rubella-igg-avidity'
UNION ALL SELECT id, 'Краснуха IgG авидность', 'ru' FROM lab_tests WHERE slug = 'rubella-igg-avidity';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'ВПГ II IgG авидность', 'ru' FROM lab_tests WHERE slug = 'hsv-ii-igg-avidity';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'ВПГ I IgG авидность', 'ru' FROM lab_tests WHERE slug = 'hsv-i-igg-avidity';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Аденовирус IgG авидность', 'ru' FROM lab_tests WHERE slug = 'adenovirus-igg-avidity';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Breast Swab Bacteria', 'en' FROM lab_tests WHERE slug = 'breast-swab-bacteria'
UNION ALL SELECT id, 'Bris grudi na bakterije', 'sr' FROM lab_tests WHERE slug = 'breast-swab-bacteria'
UNION ALL SELECT id, 'Брис груди на бактерије', 'sr-cyrl' FROM lab_tests WHERE slug = 'breast-swab-bacteria'
UNION ALL SELECT id, 'Мазок из груди на бактерии', 'ru' FROM lab_tests WHERE slug = 'breast-swab-bacteria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Ear Swab Fungi', 'en' FROM lab_tests WHERE slug = 'ear-swab-fungi'
UNION ALL SELECT id, 'Мазок из уха на грибок', 'ru' FROM lab_tests WHERE slug = 'ear-swab-fungi'
UNION ALL SELECT id, 'Анализ на отомикоз', 'ru' FROM lab_tests WHERE slug = 'ear-swab-fungi';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Антитела к микоплазме пневмонии IgA', 'ru' FROM lab_tests WHERE slug = 'mycoplasma-pneumoniae-iga';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Антитела к аденовирусу IgG', 'ru' FROM lab_tests WHERE slug = 'adenovirus-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Антитела к аденовирусу IgM', 'ru' FROM lab_tests WHERE slug = 'adenovirus-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitijela na koronavirus', 'sr' FROM lab_tests WHERE slug = 'anti-sars-cov'
UNION ALL SELECT id, 'Антитијела на коронавирус', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-sars-cov'
UNION ALL SELECT id, 'Antitela na koronavirus', 'sr' FROM lab_tests WHERE slug = 'anti-sars-cov'
UNION ALL SELECT id, 'Антитела на коронавирус', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-sars-cov'
UNION ALL SELECT id, 'Антитела к коронавирусу', 'ru' FROM lab_tests WHERE slug = 'anti-sars-cov'
UNION ALL SELECT id, 'Антитела к COVID-19', 'ru' FROM lab_tests WHERE slug = 'anti-sars-cov'
UNION ALL SELECT id, 'Corona-Antikörper', 'de' FROM lab_tests WHERE slug = 'anti-sars-cov'
UNION ALL SELECT id, 'Koronavirüs antikoru', 'tr' FROM lab_tests WHERE slug = 'anti-sars-cov';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Complement Fixation Test', 'en' FROM lab_tests WHERE slug = 'antimicrobial-antibody-detection-by-complement-fixation'
UNION ALL SELECT id, 'Detekcija antimikrobnih antitela reakcijom vezivanja komplementa', 'sr' FROM lab_tests WHERE slug = 'antimicrobial-antibody-detection-by-complement-fixation'
UNION ALL SELECT id, 'Детекција антимикробних антитела реакцијом везивања комплемента', 'sr-cyrl' FROM lab_tests WHERE slug = 'antimicrobial-antibody-detection-by-complement-fixation'
UNION ALL SELECT id, 'RVK', 'sr' FROM lab_tests WHERE slug = 'antimicrobial-antibody-detection-by-complement-fixation'
UNION ALL SELECT id, 'РВК', 'sr-cyrl' FROM lab_tests WHERE slug = 'antimicrobial-antibody-detection-by-complement-fixation'
UNION ALL SELECT id, 'Реакция связывания комплемента', 'ru' FROM lab_tests WHERE slug = 'antimicrobial-antibody-detection-by-complement-fixation'
UNION ALL SELECT id, 'KBR', 'de' FROM lab_tests WHERE slug = 'antimicrobial-antibody-detection-by-complement-fixation';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Detekcija antimikrobnih antitela ELISA testom', 'sr' FROM lab_tests WHERE slug = 'antimicrobial-antibody-detection-by-elisa'
UNION ALL SELECT id, 'Детекција антимикробних антитела ELISA тестом', 'sr-cyrl' FROM lab_tests WHERE slug = 'antimicrobial-antibody-detection-by-elisa';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Detekcija antimikrobnih antitela testom hemaglutinacije', 'sr' FROM lab_tests WHERE slug = 'antimicrobial-antibody-detection-by-hemagglutination'
UNION ALL SELECT id, 'Детекција антимикробних антитела тестом хемаглутинације', 'sr-cyrl' FROM lab_tests WHERE slug = 'antimicrobial-antibody-detection-by-hemagglutination'
UNION ALL SELECT id, 'Реакция гемагглютинации', 'ru' FROM lab_tests WHERE slug = 'antimicrobial-antibody-detection-by-hemagglutination';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Detekcija antimikrobnih antitela indirektnom imunofluorescencijom', 'sr' FROM lab_tests WHERE slug = 'antimicrobial-antibody-detection-by-indirect-immunofluorescence'
UNION ALL SELECT id, 'Детекција антимикробних антитела индиректном имунофлуоресценцијом', 'sr-cyrl' FROM lab_tests WHERE slug = 'antimicrobial-antibody-detection-by-indirect-immunofluorescence'
UNION ALL SELECT id, 'НРИФ', 'ru' FROM lab_tests WHERE slug = 'antimicrobial-antibody-detection-by-indirect-immunofluorescence';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Антистрептолизин-О', 'ru' FROM lab_tests WHERE slug = 'asto';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Brzi antigenski test', 'sr' FROM lab_tests WHERE slug = 'covid-19-antigen-test'
UNION ALL SELECT id, 'Брзи антигенски тест', 'sr-cyrl' FROM lab_tests WHERE slug = 'covid-19-antigen-test'
UNION ALL SELECT id, 'Экспресс-тест на COVID-19', 'ru' FROM lab_tests WHERE slug = 'covid-19-antigen-test'
UNION ALL SELECT id, 'Антигенный тест на коронавирус', 'ru' FROM lab_tests WHERE slug = 'covid-19-antigen-test'
UNION ALL SELECT id, 'Corona-Schnelltest', 'de' FROM lab_tests WHERE slug = 'covid-19-antigen-test'
UNION ALL SELECT id, 'Hızlı antijen testi', 'tr' FROM lab_tests WHERE slug = 'covid-19-antigen-test';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Антитела к вирусу Коксаки B IgG', 'ru' FROM lab_tests WHERE slug = 'coxsackie-b-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Антитела к вирусу Коксаки B IgM', 'ru' FROM lab_tests WHERE slug = 'coxsackie-b-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Антитела к вирусу Коксаки IgG', 'ru' FROM lab_tests WHERE slug = 'coxsackie-virus-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Антитела к вирусу Коксаки IgM', 'ru' FROM lab_tests WHERE slug = 'coxsackie-virus-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'CMV IgG', 'en' FROM lab_tests WHERE slug = 'cytomegalovirus-igg'
UNION ALL SELECT id, 'ЦМВ IgG', 'ru' FROM lab_tests WHERE slug = 'cytomegalovirus-igg'
UNION ALL SELECT id, 'Антитела к цитомегаловирусу IgG', 'ru' FROM lab_tests WHERE slug = 'cytomegalovirus-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'CMV IgM', 'en' FROM lab_tests WHERE slug = 'cytomegalovirus-igm'
UNION ALL SELECT id, 'ЦМВ IgM', 'ru' FROM lab_tests WHERE slug = 'cytomegalovirus-igm'
UNION ALL SELECT id, 'Антитела к цитомегаловирусу IgM', 'ru' FROM lab_tests WHERE slug = 'cytomegalovirus-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Витамин В9', 'ru' FROM lab_tests WHERE slug = 'folic-acid';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Kobalamin', 'sr' FROM lab_tests WHERE slug = 'vitamin-b12'
UNION ALL SELECT id, 'Витамин В12', 'ru' FROM lab_tests WHERE slug = 'vitamin-b12'
UNION ALL SELECT id, 'Цианокобаламин', 'ru' FROM lab_tests WHERE slug = 'vitamin-b12';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, '25-Hydroxyvitamin D', 'en' FROM lab_tests WHERE slug = 'vitamin-d-25-oh'
UNION ALL SELECT id, 'Витамин Д', 'ru' FROM lab_tests WHERE slug = 'vitamin-d-25-oh'
UNION ALL SELECT id, '25-гидроксивитамин D', 'ru' FROM lab_tests WHERE slug = 'vitamin-d-25-oh';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Hepatitis A Total Antibodies', 'en' FROM lab_tests WHERE slug = 'hav-total-antibodies'
UNION ALL SELECT id, 'Hepatitis A ukupna antitijela', 'sr' FROM lab_tests WHERE slug = 'hav-total-antibodies'
UNION ALL SELECT id, 'Хепатитис A укупна антитијела', 'sr-cyrl' FROM lab_tests WHERE slug = 'hav-total-antibodies'
UNION ALL SELECT id, 'HAV ukupna antitela', 'sr' FROM lab_tests WHERE slug = 'hav-total-antibodies'
UNION ALL SELECT id, 'ХАВ укупна антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'hav-total-antibodies'
UNION ALL SELECT id, 'Гепатит А суммарные антитела', 'ru' FROM lab_tests WHERE slug = 'hav-total-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Hepatitis B e Antigen', 'en' FROM lab_tests WHERE slug = 'hbeag'
UNION ALL SELECT id, 'Е-антиген гепатита В', 'ru' FROM lab_tests WHERE slug = 'hbeag';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Anti-HBs', 'en' FROM lab_tests WHERE slug = 'hbsab'
UNION ALL SELECT id, 'Антитела к поверхностному антигену гепатита В', 'ru' FROM lab_tests WHERE slug = 'hbsab';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Вирус простого герпеса 1 типа IgG', 'ru' FROM lab_tests WHERE slug = 'herpes-simplex-i-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'HSV1 IgM', 'en' FROM lab_tests WHERE slug = 'herpes-simplex-i-igm'
UNION ALL SELECT id, 'ВПГ1 IgM', 'ru' FROM lab_tests WHERE slug = 'herpes-simplex-i-igm'
UNION ALL SELECT id, 'Вирус простого герпеса 1 типа IgM', 'ru' FROM lab_tests WHERE slug = 'herpes-simplex-i-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Вирус простого герпеса 2 типа IgG', 'ru' FROM lab_tests WHERE slug = 'herpes-simplex-ii-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'HSV2 IgM', 'en' FROM lab_tests WHERE slug = 'herpes-simplex-ii-igm'
UNION ALL SELECT id, 'ВПГ2 IgM', 'ru' FROM lab_tests WHERE slug = 'herpes-simplex-ii-igm'
UNION ALL SELECT id, 'Вирус простого герпеса 2 типа IgM', 'ru' FROM lab_tests WHERE slug = 'herpes-simplex-ii-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'HIV antigen i antitijela', 'sr' FROM lab_tests WHERE slug = 'hiv-ag-ab'
UNION ALL SELECT id, 'HIV антиген и антитијела', 'sr-cyrl' FROM lab_tests WHERE slug = 'hiv-ag-ab'
UNION ALL SELECT id, 'Антиген и антитела к ВИЧ', 'ru' FROM lab_tests WHERE slug = 'hiv-ag-ab';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Test na malariju', 'sr' FROM lab_tests WHERE slug = 'malaria'
UNION ALL SELECT id, 'Тест на маларију', 'sr-cyrl' FROM lab_tests WHERE slug = 'malaria'
UNION ALL SELECT id, 'Анализ на малярию', 'ru' FROM lab_tests WHERE slug = 'malaria'
UNION ALL SELECT id, 'Malarya testi', 'tr' FROM lab_tests WHERE slug = 'malaria';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Male boginje IgG', 'sr' FROM lab_tests WHERE slug = 'measles-igg'
UNION ALL SELECT id, 'Мале богиње IgG', 'sr-cyrl' FROM lab_tests WHERE slug = 'measles-igg'
UNION ALL SELECT id, 'Антитела к кори IgG', 'ru' FROM lab_tests WHERE slug = 'measles-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Male boginje IgM', 'sr' FROM lab_tests WHERE slug = 'measles-igm'
UNION ALL SELECT id, 'Мале богиње IgM', 'sr-cyrl' FROM lab_tests WHERE slug = 'measles-igm'
UNION ALL SELECT id, 'Антитела к кори IgM', 'ru' FROM lab_tests WHERE slug = 'measles-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'ПИФ', 'ru' FROM lab_tests WHERE slug = 'microbial-antigen-detection-by-direct-immunofluorescence';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Serum Copper', 'en' FROM lab_tests WHERE slug = 'copper-in-serum'
UNION ALL SELECT id, 'Bakar u krvi', 'sr' FROM lab_tests WHERE slug = 'copper-in-serum'
UNION ALL SELECT id, 'Бакар у крви', 'sr-cyrl' FROM lab_tests WHERE slug = 'copper-in-serum'
UNION ALL SELECT id, 'Медь в крови', 'ru' FROM lab_tests WHERE slug = 'copper-in-serum';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Serum Zinc', 'en' FROM lab_tests WHERE slug = 'zinc-in-serum'
UNION ALL SELECT id, 'Cink u krvi', 'sr' FROM lab_tests WHERE slug = 'zinc-in-serum'
UNION ALL SELECT id, 'Цинк у крви', 'sr-cyrl' FROM lab_tests WHERE slug = 'zinc-in-serum'
UNION ALL SELECT id, 'Цинк в крови', 'ru' FROM lab_tests WHERE slug = 'zinc-in-serum';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Depakine', 'sr' FROM lab_tests WHERE slug = 'valproic-acid'
UNION ALL SELECT id, 'Депакине', 'sr-cyrl' FROM lab_tests WHERE slug = 'valproic-acid'
UNION ALL SELECT id, 'Вальпроат', 'ru' FROM lab_tests WHERE slug = 'valproic-acid'
UNION ALL SELECT id, 'Депакин', 'ru' FROM lab_tests WHERE slug = 'valproic-acid';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Adrenocorticotropic Hormone', 'en' FROM lab_tests WHERE slug = 'acth'
UNION ALL SELECT id, 'Corticotropin', 'en' FROM lab_tests WHERE slug = 'acth'
UNION ALL SELECT id, 'Кортикотропин', 'ru' FROM lab_tests WHERE slug = 'acth';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Андростенедион', 'ru' FROM lab_tests WHERE slug = 'androstenedione';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Тиреокальцитонин', 'ru' FROM lab_tests WHERE slug = 'calcitonin'
UNION ALL SELECT id, 'Kalzitonin', 'de' FROM lab_tests WHERE slug = 'calcitonin';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Гидрокортизон', 'ru' FROM lab_tests WHERE slug = 'cortisol';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Dehydroepiandrosterone Sulfate', 'en' FROM lab_tests WHERE slug = 'dhea-s'
UNION ALL SELECT id, 'ДГЭА-сульфат', 'ru' FROM lab_tests WHERE slug = 'dhea-s';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Östradiol', 'de' FROM lab_tests WHERE slug = 'estradiol';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Free Triiodothyronine', 'en' FROM lab_tests WHERE slug = 'free-t3'
UNION ALL SELECT id, 'Slobodni trijodtironin', 'sr' FROM lab_tests WHERE slug = 'free-t3'
UNION ALL SELECT id, 'Слободни тријодтиронин', 'sr-cyrl' FROM lab_tests WHERE slug = 'free-t3'
UNION ALL SELECT id, 'Трийодтиронин свободный', 'ru' FROM lab_tests WHERE slug = 'free-t3';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Free Thyroxine', 'en' FROM lab_tests WHERE slug = 'free-t4'
UNION ALL SELECT id, 'Slobodni tiroksin', 'sr' FROM lab_tests WHERE slug = 'free-t4'
UNION ALL SELECT id, 'Слободни тироксин', 'sr-cyrl' FROM lab_tests WHERE slug = 'free-t4'
UNION ALL SELECT id, 'Тироксин свободный', 'ru' FROM lab_tests WHERE slug = 'free-t4';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Follicle-Stimulating Hormone', 'en' FROM lab_tests WHERE slug = 'fsh';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Ингибин А', 'ru' FROM lab_tests WHERE slug = 'inhibin-a';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Ингибин В', 'ru' FROM lab_tests WHERE slug = 'inhibin-b';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Intact Parathyroid Hormone', 'en' FROM lab_tests WHERE slug = 'intact-pth'
UNION ALL SELECT id, 'Intaktni parathormon', 'sr' FROM lab_tests WHERE slug = 'intact-pth'
UNION ALL SELECT id, 'Интактни parathormon', 'sr-cyrl' FROM lab_tests WHERE slug = 'intact-pth'
UNION ALL SELECT id, 'Интактный паратгормон', 'ru' FROM lab_tests WHERE slug = 'intact-pth'
UNION ALL SELECT id, 'Intaktes Parathormon', 'de' FROM lab_tests WHERE slug = 'intact-pth';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Luteinizing Hormone', 'en' FROM lab_tests WHERE slug = 'lh'
UNION ALL SELECT id, 'Lüteinize Edici Hormon', 'tr' FROM lab_tests WHERE slug = 'lh';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Sex Hormone-Binding Globulin', 'en' FROM lab_tests WHERE slug = 'shbg'
UNION ALL SELECT id, 'Сексстероидсвязывающий глобулин', 'ru' FROM lab_tests WHERE slug = 'shbg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Thyroid-Stimulating Hormone', 'en' FROM lab_tests WHERE slug = 'tsh'
UNION ALL SELECT id, 'Tireotropni hormon', 'sr' FROM lab_tests WHERE slug = 'tsh'
UNION ALL SELECT id, 'Тиреотропни хормон', 'sr-cyrl' FROM lab_tests WHERE slug = 'tsh'
UNION ALL SELECT id, 'Анализ на ТТГ', 'ru' FROM lab_tests WHERE slug = 'tsh'
UNION ALL SELECT id, 'Thyreotropin', 'de' FROM lab_tests WHERE slug = 'tsh';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Zauške IgG', 'sr' FROM lab_tests WHERE slug = 'mumps-igg'
UNION ALL SELECT id, 'Заушке IgG', 'sr-cyrl' FROM lab_tests WHERE slug = 'mumps-igg'
UNION ALL SELECT id, 'Свинка IgG', 'ru' FROM lab_tests WHERE slug = 'mumps-igg'
UNION ALL SELECT id, 'Антитела к вирусу паротита IgG', 'ru' FROM lab_tests WHERE slug = 'mumps-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Zauške IgM', 'sr' FROM lab_tests WHERE slug = 'mumps-igm'
UNION ALL SELECT id, 'Заушке IgM', 'sr-cyrl' FROM lab_tests WHERE slug = 'mumps-igm'
UNION ALL SELECT id, 'Свинка IgM', 'ru' FROM lab_tests WHERE slug = 'mumps-igm'
UNION ALL SELECT id, 'Антитела к вирусу паротита IgM', 'ru' FROM lab_tests WHERE slug = 'mumps-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Антитела к парвовирусу B19 IgG', 'ru' FROM lab_tests WHERE slug = 'parvovirus-b19-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Антитела к парвовирусу B19 IgM', 'ru' FROM lab_tests WHERE slug = 'parvovirus-b19-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Антитела к краснухе IgG', 'ru' FROM lab_tests WHERE slug = 'rubella-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Антитела к краснухе IgM', 'ru' FROM lab_tests WHERE slug = 'rubella-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Антитела к S-белку SARS-CoV-2 IgG', 'ru' FROM lab_tests WHERE slug = 'sars-cov-2-igg-spike-protein'
UNION ALL SELECT id, 'Антитела к ковиду IgG (S-белок)', 'ru' FROM lab_tests WHERE slug = 'sars-cov-2-igg-spike-protein';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitijela na toksoplazmu IgG', 'sr' FROM lab_tests WHERE slug = 'toxoplasma-igg'
UNION ALL SELECT id, 'Антитијела на токсоплазму IgG', 'sr-cyrl' FROM lab_tests WHERE slug = 'toxoplasma-igg'
UNION ALL SELECT id, 'Антитела к токсоплазме IgG', 'ru' FROM lab_tests WHERE slug = 'toxoplasma-igg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitijela na toksoplazmu IgM', 'sr' FROM lab_tests WHERE slug = 'toxoplasma-igm'
UNION ALL SELECT id, 'Антитијела на токсоплазму IgM', 'sr-cyrl' FROM lab_tests WHERE slug = 'toxoplasma-igm'
UNION ALL SELECT id, 'Антитела к токсоплазме IgM', 'ru' FROM lab_tests WHERE slug = 'toxoplasma-igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'С-реактивный протеин', 'ru' FROM lab_tests WHERE slug = 'c-reactive-protein';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'РОЭ', 'ru' FROM lab_tests WHERE slug = 'erythrocyte-sedimentation-rate';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antinuklearna antitela', 'sr' FROM lab_tests WHERE slug = 'ana-antinuclear-antibodies'
UNION ALL SELECT id, 'Антинуклеарна антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'ana-antinuclear-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Anti-CCP antitela', 'sr' FROM lab_tests WHERE slug = 'anti-ccp-antibodies'
UNION ALL SELECT id, 'Anti-CCP антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-ccp-antibodies'
UNION ALL SELECT id, 'Antitijela na ciklični citrulinirani peptid', 'sr' FROM lab_tests WHERE slug = 'anti-ccp-antibodies'
UNION ALL SELECT id, 'Антитијела на циклични цитрулинирани пептид', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-ccp-antibodies'
UNION ALL SELECT id, 'Антитела к циклическому цитруллинированному пептиду', 'ru' FROM lab_tests WHERE slug = 'anti-ccp-antibodies'
UNION ALL SELECT id, 'Анти-ЦЦП', 'ru' FROM lab_tests WHERE slug = 'anti-ccp-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na tireoglobulin', 'sr' FROM lab_tests WHERE slug = 'anti-thyroglobulin-antibodies'
UNION ALL SELECT id, 'Антитела на тиреоглобулин', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-thyroglobulin-antibodies'
UNION ALL SELECT id, 'Анти-ТГ', 'ru' FROM lab_tests WHERE slug = 'anti-thyroglobulin-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na tireoperoksidazu', 'sr' FROM lab_tests WHERE slug = 'anti-tpo'
UNION ALL SELECT id, 'Антитела на тиреопероксидазу', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-tpo'
UNION ALL SELECT id, 'Antitijela na TPO', 'sr' FROM lab_tests WHERE slug = 'anti-tpo'
UNION ALL SELECT id, 'Антитијела на ТПО', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-tpo'
UNION ALL SELECT id, 'Анти-ТПО', 'ru' FROM lab_tests WHERE slug = 'anti-tpo';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na TSH receptor', 'sr' FROM lab_tests WHERE slug = 'anti-tshr'
UNION ALL SELECT id, 'Антитела на TSH рецептор', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-tshr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitela na jajnike', 'sr' FROM lab_tests WHERE slug = 'ovarian-antibodies'
UNION ALL SELECT id, 'Антитела на јајнике', 'sr-cyrl' FROM lab_tests WHERE slug = 'ovarian-antibodies'
UNION ALL SELECT id, 'Антиовариальные антитела', 'ru' FROM lab_tests WHERE slug = 'ovarian-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Ревмофактор', 'ru' FROM lab_tests WHERE slug = 'rheumatoid-factor';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Реакция Ваалера-Роуза', 'ru' FROM lab_tests WHERE slug = 'waaler-rose-test';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Zinc Transporter 8 Antibodies', 'en' FROM lab_tests WHERE slug = 'znt8-antibodies'
UNION ALL SELECT id, 'Antitela na ZnT8', 'sr' FROM lab_tests WHERE slug = 'znt8-antibodies'
UNION ALL SELECT id, 'Антитела на ЗнТ8', 'sr-cyrl' FROM lab_tests WHERE slug = 'znt8-antibodies'
UNION ALL SELECT id, 'Антитела к транспортеру цинка 8', 'ru' FROM lab_tests WHERE slug = 'znt8-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Angiotensin-Converting Enzyme', 'en' FROM lab_tests WHERE slug = 'ace'
UNION ALL SELECT id, 'Ангиотензинконвертирующий фермент', 'ru' FROM lab_tests WHERE slug = 'ace';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'ACP', 'en' FROM lab_tests WHERE slug = 'acid-phosphatase';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Gasne analize krvi', 'sr' FROM lab_tests WHERE slug = 'acid-base-status-ph-pco2-po2'
UNION ALL SELECT id, 'Гасне анализе крви', 'sr-cyrl' FROM lab_tests WHERE slug = 'acid-base-status-ph-pco2-po2'
UNION ALL SELECT id, 'КЩС', 'ru' FROM lab_tests WHERE slug = 'acid-base-status-ph-pco2-po2'
UNION ALL SELECT id, 'Газы крови', 'ru' FROM lab_tests WHERE slug = 'acid-base-status-ph-pco2-po2'
UNION ALL SELECT id, 'Blutgasanalyse', 'de' FROM lab_tests WHERE slug = 'acid-base-status-ph-pco2-po2'
UNION ALL SELECT id, 'Kan gazı analizi', 'tr' FROM lab_tests WHERE slug = 'acid-base-status-ph-pco2-po2';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Alpha-Amylase', 'en' FROM lab_tests WHERE slug = 'amylase'
UNION ALL SELECT id, 'Альфа-амилаза', 'ru' FROM lab_tests WHERE slug = 'amylase';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Аполипопротеин В', 'ru' FROM lab_tests WHERE slug = 'apolipoprotein-b';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'B2M', 'en' FROM lab_tests WHERE slug = 'beta-2-microglobulin'
UNION ALL SELECT id, 'Бета-2-микроглобулин', 'ru' FROM lab_tests WHERE slug = 'beta-2-microglobulin'
UNION ALL SELECT id, 'β2-микроглобулин', 'ru' FROM lab_tests WHERE slug = 'beta-2-microglobulin';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'β-CTX', 'en' FROM lab_tests WHERE slug = 'beta-crosslaps'
UNION ALL SELECT id, 'C-Terminal Telopeptide of Type I Collagen', 'en' FROM lab_tests WHERE slug = 'beta-crosslaps'
UNION ALL SELECT id, 'Бета-кросслапс', 'ru' FROM lab_tests WHERE slug = 'beta-crosslaps'
UNION ALL SELECT id, 'С-концевой телопептид коллагена I типа', 'ru' FROM lab_tests WHERE slug = 'beta-crosslaps';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Ukupni holesterol', 'sr' FROM lab_tests WHERE slug = 'cholesterol'
UNION ALL SELECT id, 'Укупни холестерол', 'sr-cyrl' FROM lab_tests WHERE slug = 'cholesterol'
UNION ALL SELECT id, 'Gesamtcholesterin', 'de' FROM lab_tests WHERE slug = 'cholesterol'
UNION ALL SELECT id, 'Total kolesterol', 'tr' FROM lab_tests WHERE slug = 'cholesterol';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Pseudocholinesterase', 'en' FROM lab_tests WHERE slug = 'cholinesterase'
UNION ALL SELECT id, 'Псевдохолинэстераза', 'ru' FROM lab_tests WHERE slug = 'cholinesterase';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Проба Реберга', 'ru' FROM lab_tests WHERE slug = 'creatinine-clearance';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Biohemija likvora', 'sr' FROM lab_tests WHERE slug = 'csf-biochemical-analysis'
UNION ALL SELECT id, 'Биохемија ликвора', 'sr-cyrl' FROM lab_tests WHERE slug = 'csf-biochemical-analysis'
UNION ALL SELECT id, 'Биохимия ликвора', 'ru' FROM lab_tests WHERE slug = 'csf-biochemical-analysis'
UNION ALL SELECT id, 'Биохимический анализ спинномозговой жидкости', 'ru' FROM lab_tests WHERE slug = 'csf-biochemical-analysis'
UNION ALL SELECT id, 'Beyin omurilik sıvısı biyokimyası', 'tr' FROM lab_tests WHERE slug = 'csf-biochemical-analysis';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Cerebrospinal Fluid Protein', 'en' FROM lab_tests WHERE slug = 'csf-protein-quantitative'
UNION ALL SELECT id, 'Proteini u likvoru', 'sr' FROM lab_tests WHERE slug = 'csf-protein-quantitative'
UNION ALL SELECT id, 'Протеини у ликвору', 'sr-cyrl' FROM lab_tests WHERE slug = 'csf-protein-quantitative'
UNION ALL SELECT id, 'Белок в ликворе', 'ru' FROM lab_tests WHERE slug = 'csf-protein-quantitative'
UNION ALL SELECT id, 'Белок спинномозговой жидкости', 'ru' FROM lab_tests WHERE slug = 'csf-protein-quantitative'
UNION ALL SELECT id, 'Liquoreiweiß', 'de' FROM lab_tests WHERE slug = 'csf-protein-quantitative';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Conjugated Bilirubin', 'en' FROM lab_tests WHERE slug = 'direct-bilirubin'
UNION ALL SELECT id, 'Связанный билирубин', 'ru' FROM lab_tests WHERE slug = 'direct-bilirubin'
UNION ALL SELECT id, 'Конъюгированный билирубин', 'ru' FROM lab_tests WHERE slug = 'direct-bilirubin';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Creatine Kinase', 'en' FROM lab_tests WHERE slug = 'ck'
UNION ALL SELECT id, 'Kreatin fosfokinaza', 'sr' FROM lab_tests WHERE slug = 'ck'
UNION ALL SELECT id, 'Креатин фосфокиназа', 'sr-cyrl' FROM lab_tests WHERE slug = 'ck'
UNION ALL SELECT id, 'Креатинфосфокиназа', 'ru' FROM lab_tests WHERE slug = 'ck';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Creatine Kinase MB', 'en' FROM lab_tests WHERE slug = 'ck-mb'
UNION ALL SELECT id, 'Kreatin fosfokinaza MB', 'sr' FROM lab_tests WHERE slug = 'ck-mb'
UNION ALL SELECT id, 'Креатин фосфокиназа МБ', 'sr-cyrl' FROM lab_tests WHERE slug = 'ck-mb'
UNION ALL SELECT id, 'Креатинфосфокиназа МВ', 'ru' FROM lab_tests WHERE slug = 'ck-mb';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Gamma-Glutamyl Transferase', 'en' FROM lab_tests WHERE slug = 'gamma-gt'
UNION ALL SELECT id, 'Gama GT', 'sr' FROM lab_tests WHERE slug = 'gamma-gt'
UNION ALL SELECT id, 'Гама ГТ', 'sr-cyrl' FROM lab_tests WHERE slug = 'gamma-gt'
UNION ALL SELECT id, 'Гамма-ГТ', 'ru' FROM lab_tests WHERE slug = 'gamma-gt'
UNION ALL SELECT id, 'ГГТП', 'ru' FROM lab_tests WHERE slug = 'gamma-gt'
UNION ALL SELECT id, 'Гамма-глутамилтранспептидаза', 'ru' FROM lab_tests WHERE slug = 'gamma-gt';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Сахар в крови', 'ru' FROM lab_tests WHERE slug = 'glucose'
UNION ALL SELECT id, 'Анализ крови на сахар', 'ru' FROM lab_tests WHERE slug = 'glucose'
UNION ALL SELECT id, 'Blutzucker', 'de' FROM lab_tests WHERE slug = 'glucose'
UNION ALL SELECT id, 'Kan şekeri', 'tr' FROM lab_tests WHERE slug = 'glucose';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Hemoglobin A1c', 'en' FROM lab_tests WHERE slug = 'hba1c'
UNION ALL SELECT id, 'Glikozilirani hemoglobin', 'sr' FROM lab_tests WHERE slug = 'hba1c'
UNION ALL SELECT id, 'Гликозилирани хемоглобин', 'sr-cyrl' FROM lab_tests WHERE slug = 'hba1c'
UNION ALL SELECT id, 'Гликогемоглобин', 'ru' FROM lab_tests WHERE slug = 'hba1c';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Dobar holesterol', 'sr' FROM lab_tests WHERE slug = 'hdl-cholesterol'
UNION ALL SELECT id, 'Добар холестерол', 'sr-cyrl' FROM lab_tests WHERE slug = 'hdl-cholesterol'
UNION ALL SELECT id, 'Липопротеины высокой плотности', 'ru' FROM lab_tests WHERE slug = 'hdl-cholesterol'
UNION ALL SELECT id, 'Gutes Cholesterin', 'de' FROM lab_tests WHERE slug = 'hdl-cholesterol'
UNION ALL SELECT id, 'İyi kolesterol', 'tr' FROM lab_tests WHERE slug = 'hdl-cholesterol';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Gvožđe u serumu', 'sr' FROM lab_tests WHERE slug = 'iron'
UNION ALL SELECT id, 'Гвожђе у серуму', 'sr-cyrl' FROM lab_tests WHERE slug = 'iron'
UNION ALL SELECT id, 'Сывороточное железо', 'ru' FROM lab_tests WHERE slug = 'iron';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Mliječna kiselina', 'sr' FROM lab_tests WHERE slug = 'lactate'
UNION ALL SELECT id, 'Млијечна киселина', 'sr-cyrl' FROM lab_tests WHERE slug = 'lactate'
UNION ALL SELECT id, 'Mlečna kiselina', 'sr' FROM lab_tests WHERE slug = 'lactate'
UNION ALL SELECT id, 'Млечна киселина', 'sr-cyrl' FROM lab_tests WHERE slug = 'lactate'
UNION ALL SELECT id, 'Milchsäure', 'de' FROM lab_tests WHERE slug = 'lactate'
UNION ALL SELECT id, 'Laktik asit', 'tr' FROM lab_tests WHERE slug = 'lactate';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Lactate Dehydrogenase', 'en' FROM lab_tests WHERE slug = 'ldh';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Loš holesterol', 'sr' FROM lab_tests WHERE slug = 'ldl-cholesterol'
UNION ALL SELECT id, 'Лош холестерол', 'sr-cyrl' FROM lab_tests WHERE slug = 'ldl-cholesterol'
UNION ALL SELECT id, 'Липопротеины низкой плотности', 'ru' FROM lab_tests WHERE slug = 'ldl-cholesterol'
UNION ALL SELECT id, 'Schlechtes Cholesterin', 'de' FROM lab_tests WHERE slug = 'ldl-cholesterol'
UNION ALL SELECT id, 'Kötü kolesterol', 'tr' FROM lab_tests WHERE slug = 'ldl-cholesterol';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Амилаза панкреатическая', 'ru' FROM lab_tests WHERE slug = 'pancreatic-amylase';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Анализ плеврального выпота', 'ru' FROM lab_tests WHERE slug = 'pleural-fluid-analysis';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'TEBK', 'de' FROM lab_tests WHERE slug = 'tibc';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Ukupne bjelančevine', 'sr' FROM lab_tests WHERE slug = 'total-protein'
UNION ALL SELECT id, 'Укупне бјеланчевине', 'sr-cyrl' FROM lab_tests WHERE slug = 'total-protein'
UNION ALL SELECT id, 'Ukupne belančevine', 'sr' FROM lab_tests WHERE slug = 'total-protein'
UNION ALL SELECT id, 'Укупне беланчевине', 'sr-cyrl' FROM lab_tests WHERE slug = 'total-protein'
UNION ALL SELECT id, 'Белок общий', 'ru' FROM lab_tests WHERE slug = 'total-protein';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Латентная железосвязывающая способность', 'ru' FROM lab_tests WHERE slug = 'uibc'
UNION ALL SELECT id, 'ЛЖСС', 'ru' FROM lab_tests WHERE slug = 'uibc';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Ureja', 'sr' FROM lab_tests WHERE slug = 'urea'
UNION ALL SELECT id, 'Уреја', 'sr-cyrl' FROM lab_tests WHERE slug = 'urea';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Urična kiselina', 'sr' FROM lab_tests WHERE slug = 'uric-acid'
UNION ALL SELECT id, 'Урична киселина', 'sr-cyrl' FROM lab_tests WHERE slug = 'uric-acid';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'F5 G1691A', 'en' FROM lab_tests WHERE slug = 'factor-v-leiden-locus-1691'
UNION ALL SELECT id, 'Leiden mutacija', 'sr' FROM lab_tests WHERE slug = 'factor-v-leiden-locus-1691'
UNION ALL SELECT id, 'Leiden мутација', 'sr-cyrl' FROM lab_tests WHERE slug = 'factor-v-leiden-locus-1691';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'PAI-1 4G/5G', 'en' FROM lab_tests WHERE slug = 'pai-1-675-4g-5g'
UNION ALL SELECT id, 'Полиморфизм гена PAI-1', 'ru' FROM lab_tests WHERE slug = 'pai-1-675-4g-5g';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'F2 G20210A', 'en' FROM lab_tests WHERE slug = 'prothrombin-ii-locus-20210-pcr'
UNION ALL SELECT id, 'Мутация гена протромбина', 'ru' FROM lab_tests WHERE slug = 'prothrombin-ii-locus-20210-pcr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Whiff Test', 'en' FROM lab_tests WHERE slug = 'amine-test'
UNION ALL SELECT id, 'Аминотест', 'ru' FROM lab_tests WHERE slug = 'amine-test'
UNION ALL SELECT id, 'Аминный тест', 'ru' FROM lab_tests WHERE slug = 'amine-test';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antibiotic Susceptibility Test', 'en' FROM lab_tests WHERE slug = 'antibiogram'
UNION ALL SELECT id, 'Osjetljivost na antibiotike', 'sr' FROM lab_tests WHERE slug = 'antibiogram'
UNION ALL SELECT id, 'Осјетљивост на антибиотике', 'sr-cyrl' FROM lab_tests WHERE slug = 'antibiogram'
UNION ALL SELECT id, 'Osetljivost na antibiotike', 'sr' FROM lab_tests WHERE slug = 'antibiogram'
UNION ALL SELECT id, 'Осетљивост на антибиотике', 'sr-cyrl' FROM lab_tests WHERE slug = 'antibiogram'
UNION ALL SELECT id, 'Антибиограмма', 'ru' FROM lab_tests WHERE slug = 'antibiogram'
UNION ALL SELECT id, 'Чувствительность к антибиотикам', 'ru' FROM lab_tests WHERE slug = 'antibiogram'
UNION ALL SELECT id, 'Resistenzbestimmung', 'de' FROM lab_tests WHERE slug = 'antibiogram'
UNION ALL SELECT id, 'Antibiotika-Empfindlichkeitstest', 'de' FROM lab_tests WHERE slug = 'antibiogram'
UNION ALL SELECT id, 'Antibiyotik duyarlılık testi', 'tr' FROM lab_tests WHERE slug = 'antibiogram';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Osjetljivost gljivica na antimikotike', 'sr' FROM lab_tests WHERE slug = 'antimycogram'
UNION ALL SELECT id, 'Осјетљивост гљивица на антимикотике', 'sr-cyrl' FROM lab_tests WHERE slug = 'antimycogram'
UNION ALL SELECT id, 'Osetljivost gljivica na antimikotike', 'sr' FROM lab_tests WHERE slug = 'antimycogram'
UNION ALL SELECT id, 'Осетљивост гљивица на антимикотике', 'sr-cyrl' FROM lab_tests WHERE slug = 'antimycogram'
UNION ALL SELECT id, 'Чувствительность грибов к антимикотикам', 'ru' FROM lab_tests WHERE slug = 'antimycogram'
UNION ALL SELECT id, 'Antimykotika-Empfindlichkeitstest', 'de' FROM lab_tests WHERE slug = 'antimycogram'
UNION ALL SELECT id, 'Antifungal duyarlılık testi', 'tr' FROM lab_tests WHERE slug = 'antimycogram';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Kultura krvi', 'sr' FROM lab_tests WHERE slug = 'blood-culture'
UNION ALL SELECT id, 'Култура крви', 'sr-cyrl' FROM lab_tests WHERE slug = 'blood-culture'
UNION ALL SELECT id, 'Посев крови', 'ru' FROM lab_tests WHERE slug = 'blood-culture'
UNION ALL SELECT id, 'Посев крови на стерильность', 'ru' FROM lab_tests WHERE slug = 'blood-culture'
UNION ALL SELECT id, 'Бакпосев крови', 'ru' FROM lab_tests WHERE slug = 'blood-culture';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Bris grlića materice na gonoreju', 'sr' FROM lab_tests WHERE slug = 'endocervical-swab-for-gonorrhea'
UNION ALL SELECT id, 'Брис грлића материце на гонореју', 'sr-cyrl' FROM lab_tests WHERE slug = 'endocervical-swab-for-gonorrhea'
UNION ALL SELECT id, 'Мазок из цервикального канала на гонорею', 'ru' FROM lab_tests WHERE slug = 'endocervical-swab-for-gonorrhea'
UNION ALL SELECT id, 'Zervixabstrich auf Gonorrhoe', 'de' FROM lab_tests WHERE slug = 'endocervical-swab-for-gonorrhea'
UNION ALL SELECT id, 'Rahim ağzı sürüntüsünde gonore', 'tr' FROM lab_tests WHERE slug = 'endocervical-swab-for-gonorrhea';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Bris oka na hlamidiju', 'sr' FROM lab_tests WHERE slug = 'eye-swab-chlamydia'
UNION ALL SELECT id, 'Брис ока на хламидију', 'sr-cyrl' FROM lab_tests WHERE slug = 'eye-swab-chlamydia'
UNION ALL SELECT id, 'Мазок из глаза на хламидии', 'ru' FROM lab_tests WHERE slug = 'eye-swab-chlamydia'
UNION ALL SELECT id, 'Göz sürüntüsünde klamidya', 'tr' FROM lab_tests WHERE slug = 'eye-swab-chlamydia';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Определение вида грибов', 'ru' FROM lab_tests WHERE slug = 'fungal-identification'
UNION ALL SELECT id, 'Pilzbestimmung', 'de' FROM lab_tests WHERE slug = 'fungal-identification';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Cervical Smear', 'en' FROM lab_tests WHERE slug = 'pap-papanicolaou-test'
UNION ALL SELECT id, 'Papanikolau test', 'sr' FROM lab_tests WHERE slug = 'pap-papanicolaou-test'
UNION ALL SELECT id, 'Папаниколау тест', 'sr-cyrl' FROM lab_tests WHERE slug = 'pap-papanicolaou-test'
UNION ALL SELECT id, 'Мазок на онкоцитологию', 'ru' FROM lab_tests WHERE slug = 'pap-papanicolaou-test'
UNION ALL SELECT id, 'Krebsabstrich', 'de' FROM lab_tests WHERE slug = 'pap-papanicolaou-test';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Strep Throat Test', 'en' FROM lab_tests WHERE slug = 'rapid-strep-a'
UNION ALL SELECT id, 'Экспресс-тест на ангину', 'ru' FROM lab_tests WHERE slug = 'rapid-strep-a';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Complete Blood Count with CRP', 'en' FROM lab_tests WHERE slug = 'cbc-with-crp'
UNION ALL SELECT id, 'Kompletna krvna slika + CRP', 'sr' FROM lab_tests WHERE slug = 'cbc-with-crp'
UNION ALL SELECT id, 'Комплетна крвна слика + CRP', 'sr-cyrl' FROM lab_tests WHERE slug = 'cbc-with-crp'
UNION ALL SELECT id, 'Общий анализ крови + СРБ', 'ru' FROM lab_tests WHERE slug = 'cbc-with-crp'
UNION ALL SELECT id, 'Клинический анализ крови + С-реактивный белок', 'ru' FROM lab_tests WHERE slug = 'cbc-with-crp'
UNION ALL SELECT id, 'Hemogram + CRP', 'tr' FROM lab_tests WHERE slug = 'cbc-with-crp';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Glucose Tolerance Test 3-point', 'en' FROM lab_tests WHERE slug = 'ogtt-3-point'
UNION ALL SELECT id, 'Opterećenje glukozom (0, 60, 120 min)', 'sr' FROM lab_tests WHERE slug = 'ogtt-3-point'
UNION ALL SELECT id, 'Оптерећење глукозом (0, 60, 120 мин)', 'sr-cyrl' FROM lab_tests WHERE slug = 'ogtt-3-point'
UNION ALL SELECT id, 'Глюкозотолерантный тест, 3 точки', 'ru' FROM lab_tests WHERE slug = 'ogtt-3-point'
UNION ALL SELECT id, 'Сахарная кривая, 3 точки', 'ru' FROM lab_tests WHERE slug = 'ogtt-3-point'
UNION ALL SELECT id, 'Şeker yükleme testi 3 nokta', 'tr' FROM lab_tests WHERE slug = 'ogtt-3-point';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Glucose Tolerance Test 5-point', 'en' FROM lab_tests WHERE slug = 'ogtt-5-point'
UNION ALL SELECT id, 'Opterećenje glukozom (0, 30, 60, 90, 120 min)', 'sr' FROM lab_tests WHERE slug = 'ogtt-5-point'
UNION ALL SELECT id, 'Оптерећење глукозом (0, 30, 60, 90, 120 мин)', 'sr-cyrl' FROM lab_tests WHERE slug = 'ogtt-5-point'
UNION ALL SELECT id, 'Глюкозотолерантный тест, 5 точек', 'ru' FROM lab_tests WHERE slug = 'ogtt-5-point'
UNION ALL SELECT id, 'Сахарная кривая, 5 точек', 'ru' FROM lab_tests WHERE slug = 'ogtt-5-point'
UNION ALL SELECT id, 'Şeker yükleme testi 5 nokta', 'tr' FROM lab_tests WHERE slug = 'ogtt-5-point';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Тромбофилия и фолатный цикл', 'ru' FROM lab_tests WHERE slug = 'thrombophilia-folate-panel';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled obostrane biopsije testisa', 'sr' FROM lab_tests WHERE slug = 'histopathology-bilateral-testis-biopsies'
UNION ALL SELECT id, 'Патохистолошки преглед обостране биопсије тестиса', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-bilateral-testis-biopsies'
UNION ALL SELECT id, 'Гистология двусторонней биопсии яичек', 'ru' FROM lab_tests WHERE slug = 'histopathology-bilateral-testis-biopsies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled tumora mozga', 'sr' FROM lab_tests WHERE slug = 'histopathology-brain-tumor-examination'
UNION ALL SELECT id, 'Патохистолошки преглед тумора мозга', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-brain-tumor-examination'
UNION ALL SELECT id, 'Гистология опухоли мозга', 'ru' FROM lab_tests WHERE slug = 'histopathology-brain-tumor-examination';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled bronhoskopske biopsije', 'sr' FROM lab_tests WHERE slug = 'histopathology-bronchoscopic-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед бронхоскопске биопсије', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-bronchoscopic-biopsy'
UNION ALL SELECT id, 'Гистология бронхоскопической биопсии', 'ru' FROM lab_tests WHERE slug = 'histopathology-bronchoscopic-biopsy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled biopsije grlića materice', 'sr' FROM lab_tests WHERE slug = 'histopathology-cervical-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед биопсије грлића материце', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-cervical-biopsy'
UNION ALL SELECT id, 'Гистология биопсии шейки матки', 'ru' FROM lab_tests WHERE slug = 'histopathology-cervical-biopsy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled biopsije grlića materice i kiretaže', 'sr' FROM lab_tests WHERE slug = 'histopathology-cervical-biopsy-and-curettage'
UNION ALL SELECT id, 'Патохистолошки преглед биопсије грлића материце и киретаже', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-cervical-biopsy-and-curettage'
UNION ALL SELECT id, 'Гистология биопсии шейки матки и соскоба', 'ru' FROM lab_tests WHERE slug = 'histopathology-cervical-biopsy-and-curettage';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled konizata', 'sr' FROM lab_tests WHERE slug = 'histopathology-conization-specimen'
UNION ALL SELECT id, 'Патохистолошки преглед конизата', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-conization-specimen'
UNION ALL SELECT id, 'Гистология конизата', 'ru' FROM lab_tests WHERE slug = 'histopathology-conization-specimen';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled konizata sa kiretažom', 'sr' FROM lab_tests WHERE slug = 'histopathology-conization-specimen-with-curettage'
UNION ALL SELECT id, 'Патохистолошки преглед конизата са киретажом', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-conization-specimen-with-curettage'
UNION ALL SELECT id, 'Гистология конизата и соскоба', 'ru' FROM lab_tests WHERE slug = 'histopathology-conization-specimen-with-curettage';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološka konsultacija', 'sr' FROM lab_tests WHERE slug = 'histopathology-consultation'
UNION ALL SELECT id, 'Патохистолошка консултација', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-consultation';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled kiretaže', 'sr' FROM lab_tests WHERE slug = 'histopathology-curettage'
UNION ALL SELECT id, 'Патохистолошки преглед киретаже', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-curettage'
UNION ALL SELECT id, 'Гистология соскоба', 'ru' FROM lab_tests WHERE slug = 'histopathology-curettage';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled endoskopske biopsije', 'sr' FROM lab_tests WHERE slug = 'histopathology-endoscopic-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед ендоскопске биопсије', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-endoscopic-biopsy'
UNION ALL SELECT id, 'Гистология эндоскопической биопсии', 'ru' FROM lab_tests WHERE slug = 'histopathology-endoscopic-biopsy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled frakcione kiretaže', 'sr' FROM lab_tests WHERE slug = 'histopathology-fractional-curettage-two-samples'
UNION ALL SELECT id, 'Патохистолошки преглед фракционе киретаже', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-fractional-curettage-two-samples'
UNION ALL SELECT id, 'Гистология раздельного диагностического выскабливания', 'ru' FROM lab_tests WHERE slug = 'histopathology-fractional-curettage-two-samples';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled biopsije larinksa', 'sr' FROM lab_tests WHERE slug = 'histopathology-larynx-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед биопсије ларинкса', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-larynx-biopsy'
UNION ALL SELECT id, 'Patohistološki pregled biopsije grkljana', 'sr' FROM lab_tests WHERE slug = 'histopathology-larynx-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед биопсије гркљана', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-larynx-biopsy'
UNION ALL SELECT id, 'Гистология биопсии гортани', 'ru' FROM lab_tests WHERE slug = 'histopathology-larynx-biopsy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled biopsije jetre', 'sr' FROM lab_tests WHERE slug = 'histopathology-liver-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед биопсије јетре', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-liver-biopsy'
UNION ALL SELECT id, 'Гистология биопсии печени', 'ru' FROM lab_tests WHERE slug = 'histopathology-liver-biopsy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled tumora pluća', 'sr' FROM lab_tests WHERE slug = 'histopathology-lung-tumor-examination'
UNION ALL SELECT id, 'Патохистолошки преглед тумора плућа', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-lung-tumor-examination'
UNION ALL SELECT id, 'Гистология опухоли лёгкого', 'ru' FROM lab_tests WHERE slug = 'histopathology-lung-tumor-examination';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled limfnog čvora', 'sr' FROM lab_tests WHERE slug = 'histopathology-lymph-node-examination'
UNION ALL SELECT id, 'Патохистолошки преглед лимфног чвора', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-lymph-node-examination'
UNION ALL SELECT id, 'Гистология лимфоузла', 'ru' FROM lab_tests WHERE slug = 'histopathology-lymph-node-examination';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled multiple biopsije', 'sr' FROM lab_tests WHERE slug = 'histopathology-multiple-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед мултипле биопсије', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-multiple-biopsy'
UNION ALL SELECT id, 'Гистология множественной биопсии', 'ru' FROM lab_tests WHERE slug = 'histopathology-multiple-biopsy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Гидрокарбонаты', 'ru' FROM lab_tests WHERE slug = 'bicarbonates'
UNION ALL SELECT id, 'Hydrogencarbonat', 'de' FROM lab_tests WHERE slug = 'bicarbonates';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Total Calcium', 'en' FROM lab_tests WHERE slug = 'calcium'
UNION ALL SELECT id, 'Ukupni kalcijum', 'sr' FROM lab_tests WHERE slug = 'calcium'
UNION ALL SELECT id, 'Укупни калцијум', 'sr-cyrl' FROM lab_tests WHERE slug = 'calcium'
UNION ALL SELECT id, 'Кальций общий', 'ru' FROM lab_tests WHERE slug = 'calcium';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Hloridi u mokraći', 'sr' FROM lab_tests WHERE slug = 'chloride-in-urine'
UNION ALL SELECT id, 'Хлориди у мокраћи', 'sr-cyrl' FROM lab_tests WHERE slug = 'chloride-in-urine'
UNION ALL SELECT id, 'Chlorid im Harn', 'de' FROM lab_tests WHERE slug = 'chloride-in-urine';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Free Calcium', 'en' FROM lab_tests WHERE slug = 'ionized-calcium'
UNION ALL SELECT id, 'Кальций ионизированный', 'ru' FROM lab_tests WHERE slug = 'ionized-calcium'
UNION ALL SELECT id, 'Свободный кальций', 'ru' FROM lab_tests WHERE slug = 'ionized-calcium'
UNION ALL SELECT id, 'Ionisiertes Calcium', 'de' FROM lab_tests WHERE slug = 'ionized-calcium';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Phosphate', 'en' FROM lab_tests WHERE slug = 'phosphorus'
UNION ALL SELECT id, 'Inorganic Phosphorus', 'en' FROM lab_tests WHERE slug = 'phosphorus'
UNION ALL SELECT id, 'Neorganski fosfor', 'sr' FROM lab_tests WHERE slug = 'phosphorus'
UNION ALL SELECT id, 'Неоргански фосфор', 'sr-cyrl' FROM lab_tests WHERE slug = 'phosphorus'
UNION ALL SELECT id, 'Фосфор неорганический', 'ru' FROM lab_tests WHERE slug = 'phosphorus';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled multiple biopsije prostate', 'sr' FROM lab_tests WHERE slug = 'histopathology-multiple-prostate-biopsies'
UNION ALL SELECT id, 'Патохистолошки преглед мултипле биопсије простате', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-multiple-prostate-biopsies'
UNION ALL SELECT id, 'Гистология множественной биопсии простаты', 'ru' FROM lab_tests WHERE slug = 'histopathology-multiple-prostate-biopsies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled iglene biopsije jetre, pluća, bubrega', 'sr' FROM lab_tests WHERE slug = 'histopathology-needle-biopsy-liver-lung-kidney'
UNION ALL SELECT id, 'Патохистолошки преглед иглене биопсије јетре, плућа, бубрега', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-needle-biopsy-liver-lung-kidney'
UNION ALL SELECT id, 'Гистология пункционной биопсии печени, лёгкого, почки', 'ru' FROM lab_tests WHERE slug = 'histopathology-needle-biopsy-liver-lung-kidney';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled iglene biopsije dojke', 'sr' FROM lab_tests WHERE slug = 'histopathology-needle-breast-biopsy-without-ihc'
UNION ALL SELECT id, 'Патохистолошки преглед иглене биопсије дојке', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-needle-breast-biopsy-without-ihc'
UNION ALL SELECT id, 'Гистология игольной биопсии молочной железы', 'ru' FROM lab_tests WHERE slug = 'histopathology-needle-breast-biopsy-without-ihc';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled iglene biopsije prostate', 'sr' FROM lab_tests WHERE slug = 'histopathology-needle-prostate-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед иглене биопсије простате', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-needle-prostate-biopsy'
UNION ALL SELECT id, 'Гистология игольной биопсии простаты', 'ru' FROM lab_tests WHERE slug = 'histopathology-needle-prostate-biopsy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled biopsije usne duplje', 'sr' FROM lab_tests WHERE slug = 'histopathology-oral-cavity-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед биопсије усне дупље', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-oral-cavity-biopsy'
UNION ALL SELECT id, 'Гистология биопсии полости рта', 'ru' FROM lab_tests WHERE slug = 'histopathology-oral-cavity-biopsy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled ostalih biopsija', 'sr' FROM lab_tests WHERE slug = 'histopathology-other-biopsies'
UNION ALL SELECT id, 'Патохистолошки преглед осталих биопсија', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-other-biopsies'
UNION ALL SELECT id, 'Гистология прочих биопсий', 'ru' FROM lab_tests WHERE slug = 'histopathology-other-biopsies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled biopsije pleure', 'sr' FROM lab_tests WHERE slug = 'histopathology-pleura-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед биопсије плеуре', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-pleura-biopsy'
UNION ALL SELECT id, 'Гистология биопсии плевры', 'ru' FROM lab_tests WHERE slug = 'histopathology-pleura-biopsy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled radikalne operacije', 'sr' FROM lab_tests WHERE slug = 'histopathology-radical-surgery'
UNION ALL SELECT id, 'Патохистолошки преглед радикалне операције', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-radical-surgery'
UNION ALL SELECT id, 'Гистология операционного материала радикальной операции', 'ru' FROM lab_tests WHERE slug = 'histopathology-radical-surgery';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Standardna patohistološka dijagnostika', 'sr' FROM lab_tests WHERE slug = 'histopathology-standard-diagnostics'
UNION ALL SELECT id, 'Стандардна патохистолошка дијагностика', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-standard-diagnostics'
UNION ALL SELECT id, 'Стандартная гистологическая диагностика', 'ru' FROM lab_tests WHERE slug = 'histopathology-standard-diagnostics';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled standardne biopsije kože i organa', 'sr' FROM lab_tests WHERE slug = 'histopathology-standard-skin-and-organ-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед стандардне биопсије коже и органа', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-standard-skin-and-organ-biopsy'
UNION ALL SELECT id, 'Гистология стандартной биопсии кожи и органов', 'ru' FROM lab_tests WHERE slug = 'histopathology-standard-skin-and-organ-biopsy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled hirurške biopsije dojke', 'sr' FROM lab_tests WHERE slug = 'histopathology-surgical-breast-biopsy-without-ihc'
UNION ALL SELECT id, 'Патохистолошки преглед хируршке биопсије дојке', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-surgical-breast-biopsy-without-ihc'
UNION ALL SELECT id, 'Гистология хирургической биопсии молочной железы', 'ru' FROM lab_tests WHERE slug = 'histopathology-surgical-breast-biopsy-without-ihc';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled biopsije testisa', 'sr' FROM lab_tests WHERE slug = 'histopathology-testis-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед биопсије тестиса', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-testis-biopsy'
UNION ALL SELECT id, 'Гистология биопсии яичка', 'ru' FROM lab_tests WHERE slug = 'histopathology-testis-biopsy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled biopsije štitne žlijezde', 'sr' FROM lab_tests WHERE slug = 'histopathology-thyroid-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед биопсије штитне жлијезде', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-thyroid-biopsy'
UNION ALL SELECT id, 'Гистология биопсии щитовидной железы', 'ru' FROM lab_tests WHERE slug = 'histopathology-thyroid-biopsy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Trichomoniasis Test', 'en' FROM lab_tests WHERE slug = 'trichomonas-test'
UNION ALL SELECT id, 'Мазок на трихомонады', 'ru' FROM lab_tests WHERE slug = 'trichomonas-test'
UNION ALL SELECT id, 'Анализ на трихомониаз', 'ru' FROM lab_tests WHERE slug = 'trichomonas-test';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Мазок из мочеиспускательного канала на гонорею', 'ru' FROM lab_tests WHERE slug = 'urethral-swab-for-gonorrhea'
UNION ALL SELECT id, 'Urethralabstrich auf Gonorrhoe', 'de' FROM lab_tests WHERE slug = 'urethral-swab-for-gonorrhea'
UNION ALL SELECT id, 'Üretra sürüntüsünde gonore', 'tr' FROM lab_tests WHERE slug = 'urethral-swab-for-gonorrhea';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Kultura urina na bakterije', 'sr' FROM lab_tests WHERE slug = 'urine-culture'
UNION ALL SELECT id, 'Култура урина на бактерије', 'sr-cyrl' FROM lab_tests WHERE slug = 'urine-culture'
UNION ALL SELECT id, 'Бакпосев мочи', 'ru' FROM lab_tests WHERE slug = 'urine-culture'
UNION ALL SELECT id, 'Посев мочи на флору', 'ru' FROM lab_tests WHERE slug = 'urine-culture';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Vaginalni iscjedak', 'sr' FROM lab_tests WHERE slug = 'vaginal-secretion'
UNION ALL SELECT id, 'Вагинални исцједак', 'sr-cyrl' FROM lab_tests WHERE slug = 'vaginal-secretion'
UNION ALL SELECT id, 'Vaginalni iscedak', 'sr' FROM lab_tests WHERE slug = 'vaginal-secretion'
UNION ALL SELECT id, 'Вагинални исцедак', 'sr-cyrl' FROM lab_tests WHERE slug = 'vaginal-secretion'
UNION ALL SELECT id, 'Выделения из влагалища', 'ru' FROM lab_tests WHERE slug = 'vaginal-secretion'
UNION ALL SELECT id, 'Вагинальное отделяемое', 'ru' FROM lab_tests WHERE slug = 'vaginal-secretion'
UNION ALL SELECT id, 'Vaginalausfluss', 'de' FROM lab_tests WHERE slug = 'vaginal-secretion'
UNION ALL SELECT id, 'Vajinal akıntı', 'tr' FROM lab_tests WHERE slug = 'vaginal-secretion';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Test na amfetamin', 'sr' FROM lab_tests WHERE slug = 'amphetamine'
UNION ALL SELECT id, 'Тест на амфетамин', 'sr-cyrl' FROM lab_tests WHERE slug = 'amphetamine';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Test na kokain', 'sr' FROM lab_tests WHERE slug = 'cocaine'
UNION ALL SELECT id, 'Тест на кокаин', 'sr-cyrl' FROM lab_tests WHERE slug = 'cocaine';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'МДМА', 'ru' FROM lab_tests WHERE slug = 'ecstasy'
UNION ALL SELECT id, 'Тест на экстази', 'ru' FROM lab_tests WHERE slug = 'ecstasy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Test na marihuanu', 'sr' FROM lab_tests WHERE slug = 'marijuana'
UNION ALL SELECT id, 'Тест на марихуану', 'sr-cyrl' FROM lab_tests WHERE slug = 'marijuana'
UNION ALL SELECT id, 'Каннабис', 'ru' FROM lab_tests WHERE slug = 'marijuana';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Test na morfin', 'sr' FROM lab_tests WHERE slug = 'morphine'
UNION ALL SELECT id, 'Тест на морфин', 'sr-cyrl' FROM lab_tests WHERE slug = 'morphine';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Hlamidija PCR', 'sr' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-real-time-pcr'
UNION ALL SELECT id, 'Хламидија PCR', 'sr-cyrl' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-real-time-pcr'
UNION ALL SELECT id, 'PCR na hlamidiju', 'sr' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-real-time-pcr'
UNION ALL SELECT id, 'PCR на хламидију', 'sr-cyrl' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-real-time-pcr'
UNION ALL SELECT id, 'ПЦР на хламидии', 'ru' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-real-time-pcr'
UNION ALL SELECT id, 'Chlamydien-PCR', 'de' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-real-time-pcr'
UNION ALL SELECT id, 'Klamidya PCR', 'tr' FROM lab_tests WHERE slug = 'chlamydia-trachomatis-real-time-pcr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Gardnerela PCR', 'sr' FROM lab_tests WHERE slug = 'gardnerella-vaginalis-real-time-pcr'
UNION ALL SELECT id, 'Гарднерела PCR', 'sr-cyrl' FROM lab_tests WHERE slug = 'gardnerella-vaginalis-real-time-pcr'
UNION ALL SELECT id, 'Гарднерелла ПЦР', 'ru' FROM lab_tests WHERE slug = 'gardnerella-vaginalis-real-time-pcr'
UNION ALL SELECT id, 'ПЦР на гарднереллу', 'ru' FROM lab_tests WHERE slug = 'gardnerella-vaginalis-real-time-pcr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Genotipizacija HPV 41 tip', 'sr' FROM lab_tests WHERE slug = 'hpv-41-genotypes-pcr'
UNION ALL SELECT id, 'Генотипизација HPV 41 тип', 'sr-cyrl' FROM lab_tests WHERE slug = 'hpv-41-genotypes-pcr'
UNION ALL SELECT id, 'Генотипирование ВПЧ 41 тип', 'ru' FROM lab_tests WHERE slug = 'hpv-41-genotypes-pcr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'ВПЧ Квант 21', 'ru' FROM lab_tests WHERE slug = 'hpv-quant-21';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'ВПЧ Квант 4', 'ru' FROM lab_tests WHERE slug = 'hpv-quant-4';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Mikoplazma genitalium PCR', 'sr' FROM lab_tests WHERE slug = 'mycoplasma-genitalium-real-time-pcr'
UNION ALL SELECT id, 'Микоплазма гениталиум PCR', 'sr-cyrl' FROM lab_tests WHERE slug = 'mycoplasma-genitalium-real-time-pcr'
UNION ALL SELECT id, 'Микоплазма гениталиум ПЦР', 'ru' FROM lab_tests WHERE slug = 'mycoplasma-genitalium-real-time-pcr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Mikoplazma hominis PCR', 'sr' FROM lab_tests WHERE slug = 'mycoplasma-hominis-real-time-pcr'
UNION ALL SELECT id, 'Микоплазма хоминис PCR', 'sr-cyrl' FROM lab_tests WHERE slug = 'mycoplasma-hominis-real-time-pcr'
UNION ALL SELECT id, 'Микоплазма хоминис ПЦР', 'ru' FROM lab_tests WHERE slug = 'mycoplasma-hominis-real-time-pcr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Gonorrhea PCR', 'en' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-real-time-pcr'
UNION ALL SELECT id, 'Gonokok PCR', 'sr' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-real-time-pcr'
UNION ALL SELECT id, 'Гонокок PCR', 'sr-cyrl' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-real-time-pcr'
UNION ALL SELECT id, 'PCR na gonoreju', 'sr' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-real-time-pcr'
UNION ALL SELECT id, 'PCR на гонореју', 'sr-cyrl' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-real-time-pcr'
UNION ALL SELECT id, 'ПЦР на гонорею', 'ru' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-real-time-pcr'
UNION ALL SELECT id, 'Гонококк ПЦР', 'ru' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-real-time-pcr'
UNION ALL SELECT id, 'Gonokokken-PCR', 'de' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-real-time-pcr'
UNION ALL SELECT id, 'Gonore PCR', 'tr' FROM lab_tests WHERE slug = 'neisseria-gonorrhoeae-real-time-pcr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Coronavirus PCR Test', 'en' FROM lab_tests WHERE slug = 'sars-cov-2-pcr'
UNION ALL SELECT id, 'PCR test na koronavirus', 'sr' FROM lab_tests WHERE slug = 'sars-cov-2-pcr'
UNION ALL SELECT id, 'PCR тест на коронавирус', 'sr-cyrl' FROM lab_tests WHERE slug = 'sars-cov-2-pcr'
UNION ALL SELECT id, 'ПЦР на коронавирус', 'ru' FROM lab_tests WHERE slug = 'sars-cov-2-pcr'
UNION ALL SELECT id, 'ПЦР-тест на ковид', 'ru' FROM lab_tests WHERE slug = 'sars-cov-2-pcr'
UNION ALL SELECT id, 'Corona-PCR-Test', 'de' FROM lab_tests WHERE slug = 'sars-cov-2-pcr'
UNION ALL SELECT id, 'Koronavirüs PCR testi', 'tr' FROM lab_tests WHERE slug = 'sars-cov-2-pcr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'PCR na trihomonase', 'sr' FROM lab_tests WHERE slug = 'trichomonas-vaginalis-real-time-pcr'
UNION ALL SELECT id, 'PCR на трихомонасе', 'sr-cyrl' FROM lab_tests WHERE slug = 'trichomonas-vaginalis-real-time-pcr'
UNION ALL SELECT id, 'ПЦР на трихомонады', 'ru' FROM lab_tests WHERE slug = 'trichomonas-vaginalis-real-time-pcr'
UNION ALL SELECT id, 'Trikomonas PCR', 'tr' FROM lab_tests WHERE slug = 'trichomonas-vaginalis-real-time-pcr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled TUR mokraćne bešike', 'sr' FROM lab_tests WHERE slug = 'histopathology-tur-bladder'
UNION ALL SELECT id, 'Патохистолошки преглед ТУР мокраћне бешике', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-tur-bladder'
UNION ALL SELECT id, 'Гистология ТУР мочевого пузыря', 'ru' FROM lab_tests WHERE slug = 'histopathology-tur-bladder';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled materice', 'sr' FROM lab_tests WHERE slug = 'histopathology-uterus-examination'
UNION ALL SELECT id, 'Патохистолошки преглед материце', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-uterus-examination'
UNION ALL SELECT id, 'Гистология матки', 'ru' FROM lab_tests WHERE slug = 'histopathology-uterus-examination';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Patohistološki pregled biopsije vulve', 'sr' FROM lab_tests WHERE slug = 'histopathology-vulvar-biopsy'
UNION ALL SELECT id, 'Патохистолошки преглед биопсије вулве', 'sr-cyrl' FROM lab_tests WHERE slug = 'histopathology-vulvar-biopsy'
UNION ALL SELECT id, 'Гистология биопсии вульвы', 'ru' FROM lab_tests WHERE slug = 'histopathology-vulvar-biopsy';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'IHC 5 to 10 Antibodies', 'en' FROM lab_tests WHERE slug = 'immunohistochemistry-5-to-10-antibodies'
UNION ALL SELECT id, 'Imunohistohemija 5 do 10 antitela', 'sr' FROM lab_tests WHERE slug = 'immunohistochemistry-5-to-10-antibodies'
UNION ALL SELECT id, 'Имунохистохемија 5 до 10 антитела', 'sr-cyrl' FROM lab_tests WHERE slug = 'immunohistochemistry-5-to-10-antibodies'
UNION ALL SELECT id, 'ИГХ 5-10 антител', 'ru' FROM lab_tests WHERE slug = 'immunohistochemistry-5-to-10-antibodies';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Imunohistohemija po jednom antitelu', 'sr' FROM lab_tests WHERE slug = 'immunohistochemistry-per-antibody'
UNION ALL SELECT id, 'Имунохистохемија по једном антителу', 'sr-cyrl' FROM lab_tests WHERE slug = 'immunohistochemistry-per-antibody';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Петлевая эксцизия шейки матки', 'ru' FROM lab_tests WHERE slug = 'leep-cervical-conization'
UNION ALL SELECT id, 'Schlingenkonisation', 'de' FROM lab_tests WHERE slug = 'leep-cervical-conization';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Tečna citologija', 'sr' FROM lab_tests WHERE slug = 'liquid-based-cytology'
UNION ALL SELECT id, 'Течна цитологија', 'sr-cyrl' FROM lab_tests WHERE slug = 'liquid-based-cytology'
UNION ALL SELECT id, 'Жидкостный ПАП-тест', 'ru' FROM lab_tests WHERE slug = 'liquid-based-cytology'
UNION ALL SELECT id, 'Flüssigkeitsbasierte Zytologie', 'de' FROM lab_tests WHERE slug = 'liquid-based-cytology';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Test opterećenja glukozom', 'sr' FROM lab_tests WHERE slug = 'oral-glucose-tolerance-test'
UNION ALL SELECT id, 'Тест оптерећења глукозом', 'sr-cyrl' FROM lab_tests WHERE slug = 'oral-glucose-tolerance-test'
UNION ALL SELECT id, 'Глюкозотолерантный тест', 'ru' FROM lab_tests WHERE slug = 'oral-glucose-tolerance-test'
UNION ALL SELECT id, 'Сахарная кривая', 'ru' FROM lab_tests WHERE slug = 'oral-glucose-tolerance-test'
UNION ALL SELECT id, 'Zuckerbelastungstest', 'de' FROM lab_tests WHERE slug = 'oral-glucose-tolerance-test'
UNION ALL SELECT id, 'Şeker yükleme testi', 'tr' FROM lab_tests WHERE slug = 'oral-glucose-tolerance-test';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Протиа ингаляционная панель 64 аллергена', 'ru' FROM lab_tests WHERE slug = 'protia-allergy-q64-inhalation-panel-64-allergens';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Протиа пищевая панель 72 аллергена', 'ru' FROM lab_tests WHERE slug = 'protia-allergy-q64-nutritive-panel-72-allergens';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Протиа комбинированная панель 63 аллергена', 'ru' FROM lab_tests WHERE slug = 'protia-allergy-q64s-combined-panel-63-allergens';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Протиа комбинированная панель 107 аллергенов', 'ru' FROM lab_tests WHERE slug = 'protia-allergy-q96m-combined-panel-107-allergens';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'TORCH Screen', 'en' FROM lab_tests WHERE slug = 'torch-panel'
UNION ALL SELECT id, 'TORCH infekcije', 'sr' FROM lab_tests WHERE slug = 'torch-panel'
UNION ALL SELECT id, 'TORCH инфекције', 'sr-cyrl' FROM lab_tests WHERE slug = 'torch-panel'
UNION ALL SELECT id, 'ТОРЧ-инфекции', 'ru' FROM lab_tests WHERE slug = 'torch-panel'
UNION ALL SELECT id, 'TORCH-инфекции', 'ru' FROM lab_tests WHERE slug = 'torch-panel'
UNION ALL SELECT id, 'TORCH-комплекс', 'ru' FROM lab_tests WHERE slug = 'torch-panel'
UNION ALL SELECT id, 'TORCH-Serologie', 'de' FROM lab_tests WHERE slug = 'torch-panel'
UNION ALL SELECT id, 'TORCH testi', 'tr' FROM lab_tests WHERE slug = 'torch-panel';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, '5-hidroksiindolsirćetna kiselina u 24h urinu', 'sr' FROM lab_tests WHERE slug = '5-hiaa-in-24h-urine'
UNION ALL SELECT id, '5-хидроксииндолсирћетна киселина у 24х урину', 'sr-cyrl' FROM lab_tests WHERE slug = '5-hiaa-in-24h-urine'
UNION ALL SELECT id, '5-ОИУК в суточной моче', 'ru' FROM lab_tests WHERE slug = '5-hiaa-in-24h-urine'
UNION ALL SELECT id, '5-гидроксииндолуксусная кислота в суточной моче', 'ru' FROM lab_tests WHERE slug = '5-hiaa-in-24h-urine';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Диастаза мочи', 'ru' FROM lab_tests WHERE slug = 'amylase-in-urine';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Клинический анализ мочи', 'ru' FROM lab_tests WHERE slug = 'complete-urinalysis'
UNION ALL SELECT id, 'Urinstatus', 'de' FROM lab_tests WHERE slug = 'complete-urinalysis'
UNION ALL SELECT id, 'Tam İdrar Tetkiki', 'tr' FROM lab_tests WHERE slug = 'complete-urinalysis';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Микроальбуминурия', 'ru' FROM lab_tests WHERE slug = 'microalbumin-in-urine';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, '24-Hour Urine Protein', 'en' FROM lab_tests WHERE slug = 'protein-in-24h-urine'
UNION ALL SELECT id, 'Суточная протеинурия', 'ru' FROM lab_tests WHERE slug = 'protein-in-24h-urine';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Analiza sperme', 'sr' FROM lab_tests WHERE slug = 'spermogram'
UNION ALL SELECT id, 'Анализа сперме', 'sr-cyrl' FROM lab_tests WHERE slug = 'spermogram'
UNION ALL SELECT id, 'Анализ эякулята', 'ru' FROM lab_tests WHERE slug = 'spermogram'
UNION ALL SELECT id, 'Samenanalyse', 'de' FROM lab_tests WHERE slug = 'spermogram'
UNION ALL SELECT id, 'Semen analizi', 'tr' FROM lab_tests WHERE slug = 'spermogram';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Альфафетопротеин', 'ru' FROM lab_tests WHERE slug = 'afp';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Антимюллеровский гормон', 'ru' FROM lab_tests WHERE slug = 'anti-mullerian-hormone';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Human Chorionic Gonadotropin', 'en' FROM lab_tests WHERE slug = 'beta-hcg'
UNION ALL SELECT id, 'Humani horionski gonadotropin', 'sr' FROM lab_tests WHERE slug = 'beta-hcg'
UNION ALL SELECT id, 'Хумани хорионски гонадотропин', 'sr-cyrl' FROM lab_tests WHERE slug = 'beta-hcg'
UNION ALL SELECT id, 'Хорионический гонадотропин', 'ru' FROM lab_tests WHERE slug = 'beta-hcg'
UNION ALL SELECT id, 'Анализ крови на ХГЧ', 'ru' FROM lab_tests WHERE slug = 'beta-hcg'
UNION ALL SELECT id, 'Humanes Choriongonadotropin', 'de' FROM lab_tests WHERE slug = 'beta-hcg'
UNION ALL SELECT id, 'İnsan koryonik gonadotropini', 'tr' FROM lab_tests WHERE slug = 'beta-hcg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Свободная бета-субъединица ХГЧ', 'ru' FROM lab_tests WHERE slug = 'free-beta-hcg';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Unconjugated Estriol', 'en' FROM lab_tests WHERE slug = 'free-estriol'
UNION ALL SELECT id, 'Эстриол свободный', 'ru' FROM lab_tests WHERE slug = 'free-estriol'
UNION ALL SELECT id, 'Неконъюгированный эстриол', 'ru' FROM lab_tests WHERE slug = 'free-estriol'
UNION ALL SELECT id, 'Freies Östriol', 'de' FROM lab_tests WHERE slug = 'free-estriol';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'ПАПП-А', 'ru' FROM lab_tests WHERE slug = 'papp-a'
UNION ALL SELECT id, 'Плазменный протеин А, ассоциированный с беременностью', 'ru' FROM lab_tests WHERE slug = 'papp-a';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Test na trudnoću', 'sr' FROM lab_tests WHERE slug = 'urine-pregnancy-test-hcg-qualitative'
UNION ALL SELECT id, 'Тест на трудноћу', 'sr-cyrl' FROM lab_tests WHERE slug = 'urine-pregnancy-test-hcg-qualitative'
UNION ALL SELECT id, 'Test za trudnoću', 'sr' FROM lab_tests WHERE slug = 'urine-pregnancy-test-hcg-qualitative'
UNION ALL SELECT id, 'Тест за трудноћу', 'sr-cyrl' FROM lab_tests WHERE slug = 'urine-pregnancy-test-hcg-qualitative';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Абсолютное количество эозинофилов', 'ru' FROM lab_tests WHERE slug = 'blood-eosinophils'
UNION ALL SELECT id, 'Eosinophilenzahl', 'de' FROM lab_tests WHERE slug = 'blood-eosinophils';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'RBC', 'en' FROM lab_tests WHERE slug = 'erythrocytes'
UNION ALL SELECT id, 'Crvena krvna zrnca', 'sr' FROM lab_tests WHERE slug = 'erythrocytes'
UNION ALL SELECT id, 'Црвена крвна зрнца', 'sr-cyrl' FROM lab_tests WHERE slug = 'erythrocytes'
UNION ALL SELECT id, 'Красные кровяные тельца', 'ru' FROM lab_tests WHERE slug = 'erythrocytes'
UNION ALL SELECT id, 'Rote Blutkörperchen', 'de' FROM lab_tests WHERE slug = 'erythrocytes'
UNION ALL SELECT id, 'Alyuvar', 'tr' FROM lab_tests WHERE slug = 'erythrocytes';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'HCT', 'en' FROM lab_tests WHERE slug = 'hematocrit';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'HGB', 'en' FROM lab_tests WHERE slug = 'hemoglobin';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'WBC Differential', 'en' FROM lab_tests WHERE slug = 'leukocyte-formula'
UNION ALL SELECT id, 'Лейкограмма', 'ru' FROM lab_tests WHERE slug = 'leukocyte-formula';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Bijela krvna zrnca', 'sr' FROM lab_tests WHERE slug = 'leukocytes'
UNION ALL SELECT id, 'Бијела крвна зрнца', 'sr-cyrl' FROM lab_tests WHERE slug = 'leukocytes'
UNION ALL SELECT id, 'Bela krvna zrnca', 'sr' FROM lab_tests WHERE slug = 'leukocytes'
UNION ALL SELECT id, 'Бела крвна зрнца', 'sr-cyrl' FROM lab_tests WHERE slug = 'leukocytes'
UNION ALL SELECT id, 'Weiße Blutkörperchen', 'de' FROM lab_tests WHERE slug = 'leukocytes'
UNION ALL SELECT id, 'Akyuvar', 'tr' FROM lab_tests WHERE slug = 'leukocytes';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Mean Corpuscular Hemoglobin', 'en' FROM lab_tests WHERE slug = 'mch'
UNION ALL SELECT id, 'Prosječna količina hemoglobina u eritrocitu', 'sr' FROM lab_tests WHERE slug = 'mch'
UNION ALL SELECT id, 'Просјечна количина хемоглобина у еритроциту', 'sr-cyrl' FROM lab_tests WHERE slug = 'mch'
UNION ALL SELECT id, 'Среднее содержание гемоглобина в эритроците', 'ru' FROM lab_tests WHERE slug = 'mch'
UNION ALL SELECT id, 'Mittleres korpuskuläres Hämoglobin', 'de' FROM lab_tests WHERE slug = 'mch'
UNION ALL SELECT id, 'Ortalama eritrosit hemoglobini', 'tr' FROM lab_tests WHERE slug = 'mch';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Mean Corpuscular Hemoglobin Concentration', 'en' FROM lab_tests WHERE slug = 'mchc'
UNION ALL SELECT id, 'Prosječna koncentracija hemoglobina u eritrocitima', 'sr' FROM lab_tests WHERE slug = 'mchc'
UNION ALL SELECT id, 'Просјечна концентрација хемоглобина у еритроцитима', 'sr-cyrl' FROM lab_tests WHERE slug = 'mchc'
UNION ALL SELECT id, 'Средняя концентрация гемоглобина в эритроците', 'ru' FROM lab_tests WHERE slug = 'mchc'
UNION ALL SELECT id, 'Mittlere korpuskuläre Hämoglobinkonzentration', 'de' FROM lab_tests WHERE slug = 'mchc'
UNION ALL SELECT id, 'Ortalama eritrosit hemoglobin konsantrasyonu', 'tr' FROM lab_tests WHERE slug = 'mchc';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Mean Corpuscular Volume', 'en' FROM lab_tests WHERE slug = 'mcv'
UNION ALL SELECT id, 'Prosječni volumen eritrocita', 'sr' FROM lab_tests WHERE slug = 'mcv'
UNION ALL SELECT id, 'Просјечни волумен еритроцита', 'sr-cyrl' FROM lab_tests WHERE slug = 'mcv'
UNION ALL SELECT id, 'Средний объём эритроцита', 'ru' FROM lab_tests WHERE slug = 'mcv'
UNION ALL SELECT id, 'Mittleres Erythrozytenvolumen', 'de' FROM lab_tests WHERE slug = 'mcv'
UNION ALL SELECT id, 'Ortalama eritrosit hacmi', 'tr' FROM lab_tests WHERE slug = 'mcv';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Krvne pločice', 'sr' FROM lab_tests WHERE slug = 'platelets'
UNION ALL SELECT id, 'Крвне плочице', 'sr-cyrl' FROM lab_tests WHERE slug = 'platelets'
UNION ALL SELECT id, 'Кровяные пластинки', 'ru' FROM lab_tests WHERE slug = 'platelets'
UNION ALL SELECT id, 'Blutplättchen', 'de' FROM lab_tests WHERE slug = 'platelets'
UNION ALL SELECT id, 'Kan pulcukları', 'tr' FROM lab_tests WHERE slug = 'platelets';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Reticulocyte Count', 'en' FROM lab_tests WHERE slug = 'reticulocytes';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Aktivirano parcijalno tromboplastinsko vreme', 'sr' FROM lab_tests WHERE slug = 'activated-partial-thromboplastin-time'
UNION ALL SELECT id, 'Активирано парцијално тромбопластинско време', 'sr-cyrl' FROM lab_tests WHERE slug = 'activated-partial-thromboplastin-time'
UNION ALL SELECT id, 'Каолин-кефалиновое время', 'ru' FROM lab_tests WHERE slug = 'activated-partial-thromboplastin-time';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'AT III', 'en' FROM lab_tests WHERE slug = 'antithrombin-iii'
UNION ALL SELECT id, 'АТ III', 'ru' FROM lab_tests WHERE slug = 'antithrombin-iii';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Vreme krvarenja', 'sr' FROM lab_tests WHERE slug = 'bleeding-time'
UNION ALL SELECT id, 'Време крварења', 'sr-cyrl' FROM lab_tests WHERE slug = 'bleeding-time';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Vreme koagulacije', 'sr' FROM lab_tests WHERE slug = 'coagulation-time'
UNION ALL SELECT id, 'Време коагулације', 'sr-cyrl' FROM lab_tests WHERE slug = 'coagulation-time';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Протеин С', 'ru' FROM lab_tests WHERE slug = 'protein-c';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'PT/INR', 'en' FROM lab_tests WHERE slug = 'prothrombin-time-pt-inr';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Trombinsko vreme', 'sr' FROM lab_tests WHERE slug = 'thrombin-time'
UNION ALL SELECT id, 'Тромбинско време', 'sr-cyrl' FROM lab_tests WHERE slug = 'thrombin-time';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'CA-125', 'en' FROM lab_tests WHERE slug = 'ca-125'
UNION ALL SELECT id, 'СА-125', 'ru' FROM lab_tests WHERE slug = 'ca-125';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Carcinoembryonic Antigen', 'en' FROM lab_tests WHERE slug = 'cea'
UNION ALL SELECT id, 'Раково-эмбриональный антиген', 'ru' FROM lab_tests WHERE slug = 'cea';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Хромогранин А', 'ru' FROM lab_tests WHERE slug = 'chromogranin-a';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Cytokeratin 19 Fragment', 'en' FROM lab_tests WHERE slug = 'cyfra-21-1'
UNION ALL SELECT id, 'Фрагмент цитокератина 19', 'ru' FROM lab_tests WHERE slug = 'cyfra-21-1';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Free Prostate-Specific Antigen', 'en' FROM lab_tests WHERE slug = 'free-psa'
UNION ALL SELECT id, 'Свободный простат-специфический антиген', 'ru' FROM lab_tests WHERE slug = 'free-psa';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Neuron-Specific Enolase', 'en' FROM lab_tests WHERE slug = 'nse'
UNION ALL SELECT id, 'Нейронспецифическая енолаза', 'ru' FROM lab_tests WHERE slug = 'nse'
UNION ALL SELECT id, 'Нейронспецифическая энолаза', 'ru' FROM lab_tests WHERE slug = 'nse';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Белок S100', 'ru' FROM lab_tests WHERE slug = 'protein-s-100';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Total PSA', 'en' FROM lab_tests WHERE slug = 'psa'
UNION ALL SELECT id, 'Ukupni PSA', 'sr' FROM lab_tests WHERE slug = 'psa'
UNION ALL SELECT id, 'Укупни PSA', 'sr-cyrl' FROM lab_tests WHERE slug = 'psa'
UNION ALL SELECT id, 'Общий ПСА', 'ru' FROM lab_tests WHERE slug = 'psa'
UNION ALL SELECT id, 'Gesamt-PSA', 'de' FROM lab_tests WHERE slug = 'psa';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Risk of Ovarian Malignancy Algorithm', 'en' FROM lab_tests WHERE slug = 'roma-index'
UNION ALL SELECT id, 'Индекс РОМА', 'ru' FROM lab_tests WHERE slug = 'roma-index';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Antitijela na hepatitis C', 'sr' FROM lab_tests WHERE slug = 'anti-hcv'
UNION ALL SELECT id, 'Антитијела на хепатитис C', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-hcv'
UNION ALL SELECT id, 'Antitela na hepatitis C', 'sr' FROM lab_tests WHERE slug = 'anti-hcv'
UNION ALL SELECT id, 'Антитела на хепатитис C', 'sr-cyrl' FROM lab_tests WHERE slug = 'anti-hcv'
UNION ALL SELECT id, 'Антитела к гепатиту С', 'ru' FROM lab_tests WHERE slug = 'anti-hcv'
UNION ALL SELECT id, 'Анализ на гепатит С', 'ru' FROM lab_tests WHERE slug = 'anti-hcv'
UNION ALL SELECT id, 'Hepatit C antikoru', 'tr' FROM lab_tests WHERE slug = 'anti-hcv';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Комплемент С3', 'ru' FROM lab_tests WHERE slug = 'c3-complement'
UNION ALL SELECT id, 'Компонент комплемента С3', 'ru' FROM lab_tests WHERE slug = 'c3-complement';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Комплемент С4', 'ru' FROM lab_tests WHERE slug = 'c4-complement'
UNION ALL SELECT id, 'Компонент комплемента С4', 'ru' FROM lab_tests WHERE slug = 'c4-complement';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Cerebrospinal Fluid Cytology', 'en' FROM lab_tests WHERE slug = 'csf-cytological-analysis'
UNION ALL SELECT id, 'Цитологическое исследование спинномозговой жидкости', 'ru' FROM lab_tests WHERE slug = 'csf-cytological-analysis'
UNION ALL SELECT id, 'Liquorzytologie', 'de' FROM lab_tests WHERE slug = 'csf-cytological-analysis';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Direct Antiglobulin Test', 'en' FROM lab_tests WHERE slug = 'direct-coombs-test'
UNION ALL SELECT id, 'Прямой тест Кумбса', 'ru' FROM lab_tests WHERE slug = 'direct-coombs-test'
UNION ALL SELECT id, 'Прямой антиглобулиновый тест', 'ru' FROM lab_tests WHERE slug = 'direct-coombs-test'
UNION ALL SELECT id, 'Direkter Antiglobulintest', 'de' FROM lab_tests WHERE slug = 'direct-coombs-test';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Австралийский антиген', 'ru' FROM lab_tests WHERE slug = 'hbsag'
UNION ALL SELECT id, 'Поверхностный антиген гепатита В', 'ru' FROM lab_tests WHERE slug = 'hbsag'
UNION ALL SELECT id, 'Hepatit B yüzey antijeni', 'tr' FROM lab_tests WHERE slug = 'hbsag';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Иммуноглобулин А', 'ru' FROM lab_tests WHERE slug = 'iga';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Иммуноглобулин Е', 'ru' FROM lab_tests WHERE slug = 'ige'
UNION ALL SELECT id, 'Общий IgE', 'ru' FROM lab_tests WHERE slug = 'ige';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Иммуноглобулин М', 'ru' FROM lab_tests WHERE slug = 'igm';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Indirect Antiglobulin Test', 'en' FROM lab_tests WHERE slug = 'indirect-coombs-test'
UNION ALL SELECT id, 'Непрямой тест Кумбса', 'ru' FROM lab_tests WHERE slug = 'indirect-coombs-test'
UNION ALL SELECT id, 'Непрямой антиглобулиновый тест', 'ru' FROM lab_tests WHERE slug = 'indirect-coombs-test'
UNION ALL SELECT id, 'Indirekter Antiglobulintest', 'de' FROM lab_tests WHERE slug = 'indirect-coombs-test';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Антиспермальные антитела', 'ru' FROM lab_tests WHERE slug = 'spermatozoa-antibodies-asa'
UNION ALL SELECT id, 'АСАТ', 'ru' FROM lab_tests WHERE slug = 'spermatozoa-antibodies-asa'
UNION ALL SELECT id, 'Antispermien-Antikörper', 'de' FROM lab_tests WHERE slug = 'spermatozoa-antibodies-asa'
UNION ALL SELECT id, 'Antisperm antikoru', 'tr' FROM lab_tests WHERE slug = 'spermatozoa-antibodies-asa';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, '5-Hydroxyindoleacetic Acid', 'en' FROM lab_tests WHERE slug = '5-hiaa'
UNION ALL SELECT id, '5-ОИУК', 'ru' FROM lab_tests WHERE slug = '5-hiaa'
UNION ALL SELECT id, '5-оксииндолуксусная кислота', 'ru' FROM lab_tests WHERE slug = '5-hiaa'
UNION ALL SELECT id, '5-HIES', 'de' FROM lab_tests WHERE slug = '5-hiaa';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Okultna krv u stolici', 'sr' FROM lab_tests WHERE slug = 'fecal-occult-blood'
UNION ALL SELECT id, 'Окултна крв у столици', 'sr-cyrl' FROM lab_tests WHERE slug = 'fecal-occult-blood'
UNION ALL SELECT id, 'Test na okultno krvarenje', 'sr' FROM lab_tests WHERE slug = 'fecal-occult-blood'
UNION ALL SELECT id, 'Тест на окултно крварење', 'sr-cyrl' FROM lab_tests WHERE slug = 'fecal-occult-blood'
UNION ALL SELECT id, 'Кал на скрытую кровь', 'ru' FROM lab_tests WHERE slug = 'fecal-occult-blood'
UNION ALL SELECT id, 'Тест на скрытую кровь', 'ru' FROM lab_tests WHERE slug = 'fecal-occult-blood'
UNION ALL SELECT id, 'Stuhltest auf okkultes Blut', 'de' FROM lab_tests WHERE slug = 'fecal-occult-blood'
UNION ALL SELECT id, 'Dışkıda gizli kan', 'tr' FROM lab_tests WHERE slug = 'fecal-occult-blood';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Кал на норовирус', 'ru' FROM lab_tests WHERE slug = 'norovirus-in-stool';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Jaja parazita u stolici', 'sr' FROM lab_tests WHERE slug = 'stool-parasites'
UNION ALL SELECT id, 'Јаја паразита у столици', 'sr-cyrl' FROM lab_tests WHERE slug = 'stool-parasites'
UNION ALL SELECT id, 'Stolica na parazite', 'sr' FROM lab_tests WHERE slug = 'stool-parasites'
UNION ALL SELECT id, 'Столица на паразите', 'sr-cyrl' FROM lab_tests WHERE slug = 'stool-parasites'
UNION ALL SELECT id, 'Кал на яйца глист', 'ru' FROM lab_tests WHERE slug = 'stool-parasites'
UNION ALL SELECT id, 'Анализ на глисты', 'ru' FROM lab_tests WHERE slug = 'stool-parasites'
UNION ALL SELECT id, 'Wurmeier im Stuhl', 'de' FROM lab_tests WHERE slug = 'stool-parasites'
UNION ALL SELECT id, 'Dışkıda parazit', 'tr' FROM lab_tests WHERE slug = 'stool-parasites';

-- Ошибочные синонимы из data/labtest-names/_synonym-removals.json
DELETE syn FROM lab_test_synonyms syn JOIN lab_tests e ON e.id = syn.lab_test_id
 WHERE e.slug = 'perianal-swab' AND syn.another_name COLLATE utf8mb4_unicode_ci = 'Pus Swab Culture';
DELETE syn FROM lab_test_synonyms syn JOIN lab_tests e ON e.id = syn.lab_test_id
 WHERE e.slug = 'perianal-swab' AND syn.another_name COLLATE utf8mb4_unicode_ci = 'Мазок гноя';
DELETE syn FROM lab_test_synonyms syn JOIN lab_tests e ON e.id = syn.lab_test_id
 WHERE e.slug = 'perianal-swab' AND syn.another_name COLLATE utf8mb4_unicode_ci = 'Eiterabstrich-Kultur';
DELETE syn FROM lab_test_synonyms syn JOIN lab_tests e ON e.id = syn.lab_test_id
 WHERE e.slug = 'perianal-swab' AND syn.another_name COLLATE utf8mb4_unicode_ci = 'İrin sürüntü kültürü';
DELETE syn FROM lab_test_synonyms syn JOIN lab_tests e ON e.id = syn.lab_test_id
 WHERE e.slug = 'perianal-swab' AND syn.another_name COLLATE utf8mb4_unicode_ci = 'Bris žmara';
DELETE syn FROM lab_test_synonyms syn JOIN lab_tests e ON e.id = syn.lab_test_id
 WHERE e.slug = 'perianal-swab' AND syn.another_name COLLATE utf8mb4_unicode_ci = 'Брис жмара';
DELETE syn FROM lab_test_synonyms syn JOIN lab_tests e ON e.id = syn.lab_test_id
 WHERE e.slug = 'antimicrobial-antibody-detection-by-complement-fixation' AND syn.another_name COLLATE utf8mb4_unicode_ci = 'Detekcija antimikrobnih antitijela reakcijom rezigracije komplementa';
DELETE syn FROM lab_test_synonyms syn JOIN lab_tests e ON e.id = syn.lab_test_id
 WHERE e.slug = 'antimicrobial-antibody-detection-by-complement-fixation' AND syn.another_name COLLATE utf8mb4_unicode_ci = 'Детекција антимикробних антитијела реакцијом резиграције комплемента';
DELETE syn FROM lab_test_synonyms syn JOIN lab_tests e ON e.id = syn.lab_test_id
 WHERE e.slug = 'urethral-swab-for-gonorrhea' AND syn.another_name COLLATE utf8mb4_unicode_ci = 'Gonorrhea';
DELETE syn FROM lab_test_synonyms syn JOIN lab_tests e ON e.id = syn.lab_test_id
 WHERE e.slug = 'urethral-swab-for-gonorrhea' AND syn.another_name COLLATE utf8mb4_unicode_ci = 'Гонорея';
DELETE syn FROM lab_test_synonyms syn JOIN lab_tests e ON e.id = syn.lab_test_id
 WHERE e.slug = 'vaginal-secretion' AND syn.another_name COLLATE utf8mb4_unicode_ci = 'Выделения';
DELETE syn FROM lab_test_synonyms syn JOIN lab_tests e ON e.id = syn.lab_test_id
 WHERE e.slug = 'trichomonas-test' AND syn.another_name COLLATE utf8mb4_unicode_ci = 'Преглед препарата на Трицхомонас вагиналис нативни';
DELETE syn FROM lab_test_synonyms syn JOIN lab_tests e ON e.id = syn.lab_test_id
 WHERE e.slug = 'nse' AND syn.another_name COLLATE utf8mb4_unicode_ci = 'НSE';

-- Старые синонимы, совпавшие с новым собственным названием (как 031): они
-- больше ничего не находят и засоряют подпись «найдено по …».
-- COLLATE обязателен: таблицы синонимов в utf8mb4_0900_ai_ci, каталог — в unicode_ci.
DELETE syn FROM lab_test_synonyms syn
  JOIN lab_tests e ON e.id = syn.lab_test_id
 WHERE syn.another_name COLLATE utf8mb4_unicode_ci = CASE syn.language
           WHEN 'en' THEN e.name_en
           WHEN 'sr' THEN e.name_sr
           WHEN 'sr-cyrl' THEN e.name_sr_cyrl
           WHEN 'ru' THEN e.name_ru
           WHEN 'de' THEN e.name_de
           WHEN 'tr' THEN e.name_tr
           ELSE NULL
       END;

COMMIT;
