# Poliklinika Natal: сверка цен с сайтом (2026-10)

Источник — poliklinikanatal.me/cjenovnik/ (цены, HTML) + wp-json/wp/v2/cjenovnik (названия, раздел, modified), сняты 2026-10-02;
страница /pod-usluge/rendgen/ — 2026-10-05. Всё в `data/clinic-pricelists/sources/poliklinika-natal-podgorica/`. Позиции правились с 2025-12-01 по 2026-04-21.
Прод = локальная БД (86 услуг, 26 анализов, сверено построчно). SQL — `server/sql/insert-clinic-prices-poliklinika-natal-podgorica.sql`;
слияние дублей УЗИ мозга младенца — `server/sql/merge-infant-brain-ultrasound-duplicates.sql`.

| | Строк | |
|---|---|---|
| Меняется цена | 10 | раздел 1 |
| Перепривязка | 1 | раздел 2 |
| Совпадает | 99 | 73 услуги + 26 анализов (все PCR-мазки уже в clinic_lab_tests), не трогаем; список — раздел 6 |
| У нас есть, на сайте нет | 2 | раздел 3 → is_obsolete |
| На сайте есть, у нас нет | 24 | раздел 4: 6 добавлены в SQL, 18 педиатрии — отдельной клиникой |
| Спорные | 0 | решения 2026-10-05 — раздел 5 |

## 1. Меняется цена

| # | Запись каталога | Название на сайте | modified | Было→**стало** |
|---|---|---|---|---|
| 1 | Infuziona terapija `svc:infusion-therapy` | Intervenska infuzija u ordinaciji | 2026-03-21 | 20→**35** |
| 2 | Punkcija ciste na dojkama `svc:breast-cyst-puncture` | Punkcija ciste na dojkama | 2026-03-21 | 80→**90** |
| 3 | Prvi pregled ORL specijaliste `svc:first-ent-examination` | ORL pregled | 2026-03-21 | 40→**50** |
| 4 | Digitalna dermoskopija do 5 mladeža `svc:digital-dermoscopy-up-to-5-moles` | Digitalna dermoskopija I FotoFinder ATBM digitalnim dermoskopom | 2026-04-01 | 80→**90** |
| 5 | Dermatoskopija `svc:dermatoscopy` | Dermoskopija | 2026-04-01 | 60→**70** |
| 6 | Pregled dermatologa `svc:dermatologist-examination` | Dermatološki pregled | 2026-03-21 | 50→**60** |
| 7 | RTG grudnog koša `svc:x-ray-chest` | Rendgen | 2026-03-21 | 30→**40** |
| 8 | Ultrazvuk abdomena `svc:abdomen-ultrasound` | Ultrazvuk abdomena | 2026-03-21 | 40→**50** |
| 9 | Ultrazvuk štitne žlijezde `svc:thyroid-ultrasound` | Ultrazvuk štitaste žlijezde | 2026-03-21 | 40→**50** |
| 10 | Sistematski ginekološki pregled - paket usluga `svc:systematic-gynecological-examination-package` | Sistematski ginekološki pregled | 2026-03-21 | 130→**140** |

Это все позиции, которые клиника правила 2026-03-21 и 2026-04-01, кроме новой «Usluga davanje intravenske terapije» (раздел 4).

## 2. Перепривязка

| Название на сайте | Цена | Было | Стало |
|---|---|---|---|
| Reumatološki ultrazvuk MSK | 50 | Ultrazvuk jednog zgloba `svc:orthopedic-ultrasound-single-joint` | Mišićno-skeletni ultrazvuk `svc:musculoskeletal-ultrasound` |

## 3. У нас есть, на сайте нет

| Запись каталога | Цена | Почему is_obsolete |
|---|---|---|
| Digitalna dermoskopija više od 5 mladeža `svc:digital-dermoscopy-more-than-5-moles` | 100 | на сайте одна цифровая дермоскопия: запись wp-json 1816 со slug …-do-5-mladeza, из названия уточнение «do 5 mladeža» убрали 2026-04-01; «više od 5» на сайте нет |
| Kontrolni specijalistički pregled `svc:follow-up-specialist-examination` | 40 | общего «Kontrolni specijalistički pregled» на сайте нет; это бывший «Kontrolni pregled reumatologa» (запись 1775 создана без названия 2025-12-02, название дали 2025-12-03), он теперь своей строкой |

## 4. На сайте есть, у нас нет

### Добавлено в SQL

| Название на сайте | Цена | Запись каталога |
|---|---|---|
| Kontrolni pregled reumatologa | 40 | Kontrolni pregled reumatologa `svc:follow-up-rheumatologist-examination` |
| Usluga davanje intravenske terapije | 30 | Usluga davanja intravenske terapije `svc:iv-therapy-service` |
| Rendgen | 40 | Rendgen cervikalnog (vratnog) dijela kičme `svc:x-ray-cervical-spine` |
| Rendgen | 40 | Rendgen torakalnog dijela kičme `svc:x-ray-thoracic-spine` |
| Rendgen | 40 | Rendgen lumbalnog dijela kičme i sakruma `svc:x-ray-lumbar-spine-and-sacrum` |
| Rendgen | 40 | Snimanje ekstremiteta za svaki snimak `svc:extremity-x-ray-per-image` |

### Педиатрия — отдельной клиникой

Раздел «pedijatrija» (18 позиций, все созданы 2026-04-21) — это **«Pedijatrija Natal Kids»**: Drugog Crnogorskog bataljona 2H, kod Vezirovog mosta, Podgorica; +382 20 273 274, +382 66 273 274, info@pedijatrijanatal.me; пн–пт 08–20, сб 08–16 (подвал /pod-usluge/djecija-radiologija/). У клиники 54 адрес Studentska 16. Решение 2026-10-05: заводим отдельной клиникой после этой синхронизации.

**2026-10-06: импорт подготовлен** — `server/sql/insert-clinic-pedijatrija-natal-kids-podgorica.sql`, запись `data/clinic-imports/pedijatrija-natal-kids-podgorica.json`. Отличие от таблицы ниже: «Pregled dječijeg radiologa (jedna regija)» не новой записью, а ценой 50 € на области УЗИ (как рентген поликлиники), поэтому новых записей каталога 3, а не 4. Исходное предложение:

| Название на сайте | Цена | Запись каталога | Заметка |
|---|---|---|---|
| Pregled pedijatra | 50 | Pedijatrijski pregled `svc:pediatric-examination` |  |
| Kontrolni pregled pedijatra | 40 | Kontrolni pedijatrijski pregled `svc:follow-up-pediatric-examination` |  |
| Konsultacija pedijatra | 30 | Savjet pedijatrije `svc:pediatric-counseling` |  |
| Ultrazvuk kukova | 40 | Ultrazvuk kukova kod djece `svc:pediatric-hip-ultrasound` |  |
| Kućna posjeta pedijatra | 150 | **новая**: Pediatrician Home Visit / Kućna posjeta pedijatra |  |
| Sistematski pregled novorođenčeta | 60 | Sistematski pregled odojčeta `svc:systematic-infant-examination` | новорождённый ⊂ грудной; синоним «Sistematski pregled novorođenčeta» |
| Sistematski pregled za školu | 60 | Preventivni pregled za upis u vrtić i školu `svc:preventive-examination-for-kindergarten-and-school-enrollment` | синоним «Sistematski pregled za školu» |
| Pregled neonatologa | 60 | Pregled neonatologa `svc:neonatologist-examination` |  |
| Ultrazvuk mozga kod beba (CNS) | 50 | Ultrazvuk mozga beba `svc:infant-brain-ultrasound-neurosonography` | после merge-infant-brain-ultrasound-duplicates.sql — единственная запись УЗИ мозга младенца |
| Pregled dječijeg pulmologa | 120 | Pregled pedijatra pulmologa `svc:pediatric-pulmonologist-examination` |  |
| Pregled dječijeg kardiologa sa ultrazvukom i EKG-om | 120 | Pregled pedijatra kardiologa sa ultrazvukom srca i EKG-om `svc:pediatric-cardiologist-examination-with-echocardiography` |  |
| Pregled dječijeg gastroenterologa | 120 | Pregled pedijatra gastroenterologa `svc:pediatric-gastroenterologist-examination` |  |
| Pregled dječijeg neurologa | 100 | Pregled pedijatra neurologa `svc:pediatric-neurologist-examination` |  |
| Pregled dječijeg fizijatara | 100 | Subspecijalistički pregled dječijeg fizijatra `svc:subspecialist-pediatric-physiatrist-examination` |  |
| Pregled dječijeg ortopeda | 60 | **новая**: Pediatric Orthopedist Examination / Pregled dječjeg ortopeda |  |
| Pregled dječijeg urologa | 50 | **новая**: Pediatric Urologist Examination / Pregled dječjeg urologa |  |
| ORL pregled djece | 50 | Pregled dječjeg ORL specijaliste `svc:pediatric-ent-examination` |  |
| Pregled dječijeg radiologa (jedna regija) | 50 | **новая**: Pediatric Radiologist Examination (Single Region) / Pregled dječjeg radiologa (jedna regija) | УЗИ: на /pod-usluge/djecija-radiologija/ только ультразвуковые исследования |

## 5. Решения 2026-10-05

- **«Rendgen» 40 €** → x-ray-chest 30→40. Страница /pod-usluge/rendgen/: «Snimanje željene regije (pluća, kostiju, ekstremiteta, kičme…)» — снимок одной любой области, видов клиника не перечисляет. Общую запись «рентген» не заводим; цену 40 получают записи названных областей: лёгкие — x-ray-chest (30→40), позвоночник — шейный, грудной и поясничный отделы (цена за отдел на каждой записи, как у Milmedika, A3 и ДЗ), конечности — extremity-x-ray-per-image. «Kosti» — общее слово, покрыто конечностями и позвоночником, отдельно не заводим. У extremity-x-ray-per-image добавлены категория X-Ray, радиология и синонимы — раньше её не было в разделе рентгена.
- **«Kontrolni specijalistički pregled»** → is_obsolete (раздел 3).
- **«Reumatološki ultrazvuk MSK»** → перепривязан на musculoskeletal-ultrasound (раздел 2).
- **«Aplikacija lijeka» 10 €** остаётся на intramuscular-injection: общей записи «введение лекарства» в каталоге нет, а в/в, инфузия, внутрисуставная инъекция и прогестерон в прайсе Natal отдельными строками — остаётся обычная инъекция. У intramuscular-injection уже есть синоним «Aplikacija lijeka intramuskularno».
- **Три записи УЗИ мозга младенца** — одно исследование (нейросонография через родничок): слиты в infant-brain-ultrasound-neurosonography отдельным файлом.

Замечено попутно (цены совпадают, строки не трогали):
- «Drugi ekspertski ultrazvuk» (90) стоит на follow-up-expert-ultrasound «Kontrolni ekspertski ultrazvuk». На сайте это «Drugi ekspertski ultrazvuk u trudnoći (20–24. nedjelja)» — скрининг II триместра, а не повторный осмотр; «Prvi» — 11–13 недель. Записей под скрининги триместров в каталоге нет.
- «Kardiološki pregled, ultrazvuk i EKG» (80) стоит на cardiologist-examination-with-ultrasound — ЭКГ в названии записи нет.

## 6. Совпадает

| Запись каталога | Название на сайте | Цена |
|---|---|---|
| Trombofolatni panel 4+4 SNP `lab:thrombofolate-panel-44-snp` | Trombofolatni panel 4+4 SNP | 120 |
| Folatni metabolizam panel 4 SNP `lab:folate-metabolism-panel-4-snp` | Folatni metabolizam panel 4 SNP | 60 |
| Trombofilija panel 8SNP `lab:thrombophilia-panel-8-snp` | Trombofilija panel 8SNP | 100 |
| Femoflor 16 i HPV-quant-15 `lab:femoflor-16-and-hpv-quant-15` | Femoflor 16 i HPV-quant-15 | 160 |
| Femoflor Screen i HPV-quant-21 `lab:femoflor-screen-and-hpv-quant-21` | Femoflor Screen i HPV-quant-21 | 180 |
| PANEL 14 (14 patogena) `lab:std-panel-14-pcr` | PANEL 14 (Chlamydia trachomatis, Neisseria gonorrhoeae, Mycoplasma genitalium, Mycoplasma hominis, Trichomonas vaginalis, Ureaplasma parvum, Ureaplasma urealyticum, HPV-quant-4, HSV 1/2, Candida albicans, Gardnerella vaginalis) | 160 |
| PANEL 12 (12 patogena plus HPV) `lab:std-panel-12-pcr` | PANEL 12 (Chlamydia trachomatis Neisseria gonorrhoeae Mycoplasma genitalium Mycoplasma hominis Trichomonas vaginalis Ureaplasma parvum Ureaplasma urealyticum, HPV-quant-4,HSV 1/2) | 120 |
| PANEL 7 (7 patogena) `lab:std-panel-7-pcr` | PANEL 7 (Chlamydia trachomatis, Neisseria gonorrhoeae, Mycoplasma genitalium, Mycoplasma hominis, Trichomonas vaginalis, Ureaplasma parvum, Ureaplasma urealyticum) | 90 |
| PANEL 3 (Chlamydia, Mycoplasma hominis, Ureaplasma urealyticum) `lab:std-panel-3-pcr` | PANEL 3 (Chlamydia trachomatis, Mycoplasma hominis, Ureaplasma urealyticum) | 80 |
| Androflor `lab:androflor` | Androflor | 85 |
| Androflor screen `lab:androflor-screen` | Androflor screen | 150 |
| Femoflor 16 `lab:femoflor-16` | Femoflor 16 | 110 |
| Femoflor screen `lab:femoflor-screen` | Femoflor screen | 85 |
| HPV Quant 21 – 21 tip `lab:hpv-quant-21` | HPV-quant-21 | 105 |
| HPV-quant-15 `lab:hpv-quant-15-types-pcr` | HPV-quant-15 | 80 |
| HPV Quant 4 – tipovi 6, 11, 16, 18 `lab:hpv-quant-4` | HPV-quant-4 | 60 |
| UMC multiplex `lab:umc-multiplex` | UMC multiplex | 55 |
| Gardnerella vaginalis (Real-Time PCR) `lab:gardnerella-vaginalis-real-time-pcr` | Gardnerella vaginalis | 30 |
| Candida albicans PCR `lab:candida-albicans-pcr` | Candida albicans | 30 |
| Trichomonas vaginalis (Real-Time PCR) `lab:trichomonas-vaginalis-real-time-pcr` | Trichomonas vaginalis | 30 |
| Ureaplasma urealyticum PCR `lab:ureaplasma-urealyticum-pcr` | Ureaplasma urealyticum | 30 |
| Ureaplasma parvum PCR `lab:ureaplasma-parvum-pcr` | Ureaplasma parvum | 30 |
| Mycoplasma hominis (Real-Time PCR) `lab:mycoplasma-hominis-real-time-pcr` | Mycoplasma hominis | 30 |
| Mycoplasma genitalium (Real-Time PCR) `lab:mycoplasma-genitalium-real-time-pcr` | Mycoplasma genitalium | 30 |
| Neisseria gonorrhoeae PCR bris `lab:neisseria-gonorrhoeae-pcr-swab` | Neisseria gonorrhoeae | 30 |
| Chlamydia trachomatis PCR bris `lab:chlamydia-trachomatis-pcr-swab` | Chlamydia trachomatis | 30 |
| Injekcija progesterona `svc:progesterone-injection` | Injekcija progesterona | 10 |
| Aplikacija lijeka intraartikularno `svc:intra-articular-injection` | Aplikacija injekcije interartikularna | 50 |
| Intramuskularna injekcija `svc:intramuscular-injection` | Aplikacija lijeka | 10 |
| Biopsija štitaste žlijezde tankom iglom sa Ph nalazom `svc:thyroid-fine-needle-biopsy-with-histopathology` | Biopsija štitaste žlijezde tankom iglom sa Ph nalazom | 120 |
| Biopsija štitaste žlijezde `svc:thyroid-biopsy` | Biopsija štitaste žlijezde tankom iglom | 90 |
| Pregled i ultrazvuk štitaste žlijezde `svc:thyroid-examination-with-ultrasound` | Pregled i ultrazvuk štitaste žlijezde | 90 |
| Skidanje konaca `svc:suture-removal` | Skidanje konaca | 30 |
| Prevoj povrede `svc:wound-dressing` | Previjanje | 20 |
| Hirurško uklanjanje mladeža sa Ph nalazom `svc:surgical-mole-removal-with-histopathology` | Hirurško uklanjanje mladeža sa Ph nalazom | 185 |
| Punkcija sa Ph nalazom `svc:puncture-with-histopathology` | Punkcija sa Ph nalazom | 100 |
| Pregled maksilofacijalnog hirurga `svc:maxillofacial-surgeon-examination` | Pregled maksilofacijalnog hirurga | 50 |
| Pregled hirurga onkologa `svc:oncological-surgeon-examination` | Pregled hirurga onkologa | 90 |
| Neurološki pregled kolor dopler krvnih sudova glave i vrata `svc:neurology-examination-with-head-and-neck-doppler` | Neurološki pregled, kolor dopler krvnih sudova glave i vrata | 200 |
| Dopler krvnih sudova vrata `svc:doppler-neck-blood-vessels` | Kolor dopler krvnih sudova vrata | 50 |
| Kolor dopler krvnih sudova glave `svc:doppler-head-blood-vessels` | Kolor dopler krvnih sudova glave | 80 |
| Prvi pregled neurologa `svc:first-neurologist-examination` | Neurološki pregled | 100 |
| Kontrola ORL profesora `svc:follow-up-professor-ent-examination` | Kontrola ORL profesora (gostujući ljekar) | 60 |
| Radiotalasna konhoplastika `svc:radiowave-conchoplasty` | Radiotalasna konhoplastika | 330 |
| Ispiranje uha od cerumena `svc:cerumen-ear-irrigation` | Ispiranje ušiju | 10 |
| Timpanometrija `svc:tympanometry` | Timpanometrija | 10 |
| Audiometrija `svc:audiometry` | Audiometrija | 10 |
| ORL pregled profesora `svc:professor-ent-examination` | ORL pregled profesora (gostujući ljekar) | 90 |
| Pregled reumatologa `svc:rheumatologist-examination` | Pregled reumatologa | 70 |
| Pregled kardiologa sa ultrazvukom `svc:cardiologist-examination-with-ultrasound` | Kardiološki pregled, ultrazvuk i EKG | 80 |
| Ehokardiografija (ultrazvuk srca) `svc:echocardiography-heart-ultrasound` | EHO srca (kardiološki ultrazvuk) | 60 |
| Holter EKG-a - 24h snimanje srčane aktivnosti `svc:holter-ecg-24h` | Holter EKG-a (Schiller) | 60 |
| Pregled kardiologa sa EKG-om `svc:cardiologist-examination-with-ecg` | Kardiološki pregled i EKG | 60 |
| Bronhodilatatorni test - spirometrija sa lijekom `svc:bronchodilator-test` | Spirometrija BDT | 40 |
| Spirometrija `svc:spirometry` | Spirometrija | 30 |
| Kontrolni pregled subspecijaliste pulmologa `svc:follow-up-pulmonologist-examination` | Kontrola pulmologa | 40 |
| Pregled pulmologa `svc:pulmonologist-examination` | Pregled pulmologa | 60 |
| Stručno mišljenje hematologa-onkologa `svc:hematologist-oncologist-expert-opinion` | Stručno mišljenje hematologa-onkologa prof. dr Nadežde Basare putem email-a | 300 |
| Pregled hematologa-onkologa `svc:hematologist-oncologist-consultation` | Pregled hematologa-onkologa prof. dr Nadežde Basare | 300 |
| Uklanjanje kožnih promjena radiotalasima `svc:radiowave-skin-lesion-removal` | Uklanjanje kožnih promjena radiotalasima | 60 |
| Mapa mladeža čitavog tijela digitalnim dermoskopom `svc:total-body-mole-mapping-digital-dermoscopy` | Mapa mladeža čitavog tijela FotoFinder ATBM digitalnim dermoskopom(total body scan) | 120 |
| Dermoskopija profesora `svc:professor-dermatoscopy` | Dermoskopija profesora (gostujući ljekar) | 90 |
| Dermatološki pregled profesora `svc:professor-dermatologist-examination` | Dermatološki pregled profesora (gostujući ljekar) | 90 |
| CORE biopsija sa Ph nalazom i receptorima `svc:core-biopsy-with-histopathology-and-receptors` | CORE biopsija sa Ph nalazom i receptorima | 325 |
| CORE biopsija sa Ph nalazom `svc:core-biopsy-with-histopathology` | CORE biopsija sa Ph nalazom | 175 |
| Pregled ultrazvuk i digitalna 3D mamografija profesora `svc:professor-breast-examination-package` | Pregled, ultrazvuk i digitalna 3D mamografija (gostujući ljekar) | 160 |
| Digitalna 3D tomosinteza mamografija profesora `svc:professor-3d-tomosynthesis-mammography` | Digitalna 3D (tomosinteza) mamografija (gostujući ljekar) | 110 |
| Digitalna 3D tomosinteza mamografija `svc:3d-digital-tomosynthesis-mammography` | Digitalna 3D (tomosinteza) mamografija | 90 |
| Dopler krvnih sudova `svc:blood-vessels-doppler` | Kolor dopler krvnih sudova | 50 |
| Ultrazvuk tri regije profesora `svc:professor-ultrasound-three-regions` | Ultrazvuk tri regije profesora (gostujući doktor) | 180 |
| Ultrazvuk dvije regije profesora `svc:professor-ultrasound-two-regions` | Ultrazvuk dvije regije profesora (gostujući doktor) | 160 |
| Ultrazvuk jedne regije profesora `svc:professor-ultrasound-single-region` | Ultrazvuk jedne regije profesora (gostujući ljekar) | 110 |
| Ultrazvuk dojki `svc:breast-ultrasound` | Ultrazvuk dojki | 50 |
| Radiotalasno uklanjanje kondiloma III stepen `svc:genital-condyloma-removal-grade-3` | Radiotalasno uklanjanje kondiloma - III stepen | 300 |
| Uklanjanje genitalnih kondiloma II stepen `svc:genital-condyloma-removal-grade-2` | Radiotalasno uklanjanje kondiloma - II stepen | 200 |
| Uklanjanje genitalnih kondiloma I stepen `svc:genital-condyloma-removal-grade-1` | Radiotalasno uklanjanje kondiloma - I stepen | 100 |
| Kratka konsultacija ljekara `svc:brief-doctor-visit-consultation` | Konsultacija | 20 |
| Uklanjanje intrauterinog uloška (IUD) `svc:iud-removal` | Uklanjanje spirale | 50 |
| Postavljanje intrauterinog uloška (IUD) `svc:iud-insertion` | Stavljanje spirale | 70 |
| CTG II `svc:ctg-extended-fetal-monitoring` | CTG II | 20 |
| CTG monitoring (praćenje otkucaja srca ploda i kontrakcija) `svc:ctg-fetal-monitoring` | CTG I | 15 |
| Folikulometrija `svc:folliculometry` | Folikulometrija | 30 |
| Subspecijalistički pregled para za fertilitet `svc:fertility-couple-subspecialist-examination` | Subspecijalistički pregled para za fertilitet | 60 |
| Eksplorativna kiretaža sa anestezijom `svc:exploratory-curettage-with-anesthesia` | Eksplorativna kiretaža sa anestezijom | 300 |
| Eksplorativna kiretaža bez anestezije `svc:exploratory-curettage-without-anesthesia` | Eksplorativna kiretaža bez anestezije | 240 |
| Biopsija grlića materice `svc:cervical-biopsy` | Biopsija grlića materice | 150 |
| Loop ekscizija sa Ph nalazom `svc:leep-excision-with-histopathology` | Loop ekscizija sa Ph nalazom | 480 |
| PAPA test sa uzimanjem brisa `svc:pap-test-with-smear-collection` | PAPA test | 25 |
| Kolposkopija profesora `svc:professor-colposcopy` | Kolposkopija (gostujući ljekar) | 60 |
| Kolposkopija (pregled grlića materice) `svc:colposcopy` | Kolposkopija | 50 |
| Ginekološki pregled profesora `svc:professor-gynecological-examination` | Ginekološki pregled profesora (gostujući ljekar) | 60 |
| Ekspertski ultrazvuk profesora `svc:professor-expert-pregnancy-ultrasound` | Ekspertski ultrazvuk profesora (gostujući ljekar) | 100 |
| Specijalistički ginekološki pregled sa ultrazvukom `svc:gynecological-specialist-examination-with-ultrasound` | Ultrazvuk i ginekološki pregled | 80 |
| 4D ultrazvuk `svc:4d-pregnancy-ultrasound` | 4D ultrazvuk | 90 |
| Kontrolni ekspertski ultrazvuk `svc:follow-up-expert-ultrasound` | Drugi ekspertski ultrazvuk | 90 |
| Ekspertski ultrazvuk u trudnoći `svc:expert-pregnancy-ultrasound` | Prvi ekspertski ultrazvuk | 70 |
| Ultrazvučni pregled perinatologa `svc:perinatologist-ultrasound-examination` | Ultrazvučni pregled perinatologa | 60 |
| Ginekološki ultrazvuk `svc:gynecological-ultrasound` | Ultrazvučni pregled | 50 |
| Specijalistički ginekološki pregled `svc:gynecological-specialist-examination` | Ginekološki pregled | 40 |
