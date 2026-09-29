# Вопросы, которые агенты не решали сами

Собирается по отчётам батчей. Раздел «Нужно решение» — для пользователя; очевидные правки вне ростеров вносит ручной батч `fix-90` (см. «Решено»).

## Нужно решение

| Услуга | Батч | Вопрос |
|---|---|---|
| radical-mastectomy | fix-06 | FZOCG шире всех локалей (Halsted, надключичные узлы, ex tempore); en «Axillary Evacuation» — калька. Не менялось. |
| 6477 (FZOCG D05104) | fix-05 | В FZOCG «talusa ili kalkaneusa», во всех локалях пяточная кость потеряна, отдельной услуги под неё нет. Дописать «или пяточной кости»? |
| metatarsal-osteotomy (6462, D05088) | fix-04, review-04 | В FZOCG «Ostektomija», а в прайсе клиники под тем же кодом — «Osteotomija». Не менялось. |
| supracondylar-…-closed (D05115) | review-08 | en/sr «closed», FZOCG «closed or open». Починен только обрыв в de. |
| half-palmar-fasciectomy (D05114) | review-03 | в sr/ru иссечение «до половины» фасции, а тариф — «более половины». Переименовать услугу или отвязать тариф. |
| hallux-valgus-…-x-ostectomy | review-03 | «X-ostektomija» прочитано как экзостэктомия (стандартная операция при hallux valgus), поправлены все 5 локалей. Если толкование неверное — откатить. |
| intertrochanteric-… (D05151) | review-03 | в FZOCG «otvorena (složena)», в названия не перенесено; похоже на обрыв «zatvorena ili otvorena», как у соседних позиций. |
| incarcerated-hernia-operation (D02029) | review-15 | по тарифу — без резекции кишки, рядом 5970 «with Bowel Resection»; ни одно название этого не говорит. Дописать «без резекции кишки»? |
| hepatectomy ↔ liver-resection | review-15 | названия неразличимы; по FZOCG одна — обширная резекция (D02261), другая — сегментарная (D02154). Развести названиями. |
| pilonidal-sinus-surgical-treatment ↔ pilonidal-cyst-surgery-classic | review-15 | неразличимы; по FZOCG открытое иссечение (D02001) и иссечение с первичным швом (D02023). Развести. |
| emng-de-and-ge, emng-de-or-ge | review-19 | «DE/GE» прочитано как donji/gornji ekstremiteti (нижние/верхние конечности) — вывод агента, сверить с клиникой |
| aspiration | review-25 | во всех локалях просто «Аспирация» — чего именно, не сказано, тарифа нет |
| thyroidectomy | review-25 | категория Pulmonology и специальность ophthalmology похожи на ошибку; sr/de «операция щитовидной железы» шире, чем en/ru/tr и FZOCG «Totalna tireoidektomija» |
| lacrimal-duct-probing-adults (2287) | review-23 | sr «Propiranje suznih puteva» — промывание (так же поняли de, tr), а en, ru, slug и тариф X06064 — зондирование. Если промывание — дубль lacrimal-duct-irrigation (1628, X06062); если зондирование — править sr, de, tr. |
| targeted-upper-gi-tract-x-ray (J06020) | review-20 | «за снимок» дописано по FZOCG; убрать, если клиники берут за исследование целиком |
| intramuscular-therapy-2 | review-24 | что значит «2» — неизвестно, первоисточника нет; похоже на дубль |
| Осмотры специалиста/субспециалиста 2061–2066, 2174–2181, 2312 | review-29 | вне ростеров (меньше 3 клиник), остались кальками («Специализированный осмотр»); в ростерах серия исправлена на «Осмотр врача-специалиста» |
| Пакеты систематического осмотра (2072–2078, 2186, 7018–7020 и пакеты 1–2) | review-29 | серия шире батча — переименовывать всю разом, иначе номера разъедутся; пока только синонимы «Чекап», «Health Check-up Package N» |
| vertebral-body-… (X09076) | review-08 | Название восстановлено по FZOCG во всех локалях (шейный отдел + Halo-тракция). Если услуга клиник шире — откатить. |

## Возможные дубли — на слияние (очередь дедупликации)

| Пара | Батч | Почему |
|---|---|---|
| lymphatic-drainage-complete ↔ 7383 «Manuelna limfna drenaža» | review-06 | FZOCG M02002 привязан к первой, название позиции совпадает со второй |
| thermotherapy-cryotherapy ↔ 7385 «Krioterapija i kriomasaža» | review-06 | FZOCG M02004 |
| thermotherapy-parafango ↔ 7387 «Parafin i fango terapija» | review-06 | FZOCG M02019 |
| shoulder-sling-mitella ↔ arm-sling-immobilization (3331) | review-08 | одно и то же средство иммобилизации; синонимов первой не дано |
| total-knee-replacement ↔ 4696 «Total Knee Arthroplasty» | review-08 | синоним «Total Knee Arthroplasty» отброшен валидатором как чужое название — это и есть дубль |
| breast-ultrasound ↔ breast-ultrasound-examination (7089) | review-11 | дубль |
| blood-vessels-doppler ↔ 7225 «Doppler sonografija velikih krvnih sudova» | review-11 | та же позиция FZOCG J07012 |
| ophthalmological-ultrasound ↔ ophthalmic-ultrasound-a-scan-and-b-scan (5463) | review-11 | |
| pediatric-hip-ultrasound ↔ 7218 «Infant Hip Ultrasound» | review-11 | |
| thyroid-biopsy ↔ 3765 (пункция), 3727 (тонкоигольная биопсия) | review-11 | проверить на дубли |
| ceramic-crown-on-gold ↔ metal-ceramic-crown-gold | review-12 | керамика на золоте — это металлокерамика на золотом сплаве |
| intraoral-x-ray ↔ 4041, 7228 | review-14 | |
| panoramic-x-ray ↔ 4042, 7227 (FZOCG J11001), 7229 | review-14 | |
| prick-test-inhalation-allergens ↔ 7101 | review-14 | название X02001 в fzocg-sekundarna — мусор OCR |
| epigastric-hernia-operation ↔ 6101 «Epigastric Hernia Repair» | review-15 | |
| carpal-tunnel-surgery ↔ carpal-tunnel-decompression | review-19 | |
| doppler-neck-blood-vessels ↔ 7222 «Doppler sonografija vrata» (J07009) | review-19 | |
| panoramic-jaw-x-ray ↔ 7229 (ортопантомограмма, J11003) ↔ panoramic-x-ray | review-19 | синонимов первой не дано |
| urinary-catheter-placement ↔ bladder-catheterization | review-18 | X01032 — катетеризация только у женщин |
| ear-irrigation ↔ cerumen-ear-irrigation | review-22 | синонимов про серную пробку первой не дано |
| paranasal-sinus-x-ray-per-image ↔ x-ray-paranasal-sinuses | review-22 | |
| pleural-puncture, thoracentesis ↔ 7103 (диагностическая, X02013), 7104 (лечебная, X02014) | review-25 | |
| spirometry-recording-and-reading ↔ spirometry | review-25 | тот же код X02011 |
| x-ray-abdomen-native ↔ 7217 plain-abdominal-x-ray | review-20 | тот же код J06015 |
| x-ray-chest-heart ↔ x-ray-chest-and-heart ↔ x-ray-chest (2297) | review-20 | de и tr совпадали дословно |
| mri-pelvic-organs ↔ mri-pelvis (3812) | review-20 | тот же код J09017 |
| mri-pituitary ↔ 3795 «MR hipofize» | review-20 | |
| x-ray-paranasal-sinuses ↔ 7207 paranasal-sinus-x-ray-per-image | review-21 | |
| x-ray-thigh ↔ 3216 «Рентген бедренной кости» | review-21 | |
| x-ray-urinary-tract-native ↔ 7216 plain-urinary-tract-x-ray | review-21 | тот же код J06013 |
| cerumen ↔ 7045; ущемлённая грыжа ↔ 7064; увеличение губ ↔ 4186; септоринопластика 6314 ↔ 3509 | review-17 | |
| кардиоверсия 3297 ↔ 5826; ecg ↔ 3559; эхокардиография 7226 ↔ 1991; эргометрия 1945 ↔ 2302; Холтер АД 7411 ↔ 1993; Холтер ЭКГ 7410 ↔ 1992; carotid 3574 ↔ 7222; Ашерман 3407 ↔ 5916 | review-26 | синонимы в каждой паре отданы одной услуге |
| inhalation-administration ↔ inhalation-therapy; intra-articular-injection ↔ local-joint-medication-injection; intramuscular-medication-application ↔ 1592; intravenous-medication-application ↔ 7770; venous-blood-draw ↔ 5804; surgical-suture-removal ↔ 2054 suture-removal; artificial-anus-care ↔ 5295 stoma-care | review-24 | |
| colposcopy ↔ 7083; ctg-fetal-monitoring ↔ 7090; iud-insertion ↔ 7081; iud-removal ↔ 7082 | review-27 | синонимы отклонены как точные названия дублей |
| medical-certificate-for-general-work ↔ 4976 pre-employment-medical-certificate | review-29 | |
| mri-pelvis ↔ mri-pelvic-organs (3171) | review-31 | тот же J09017 (с другой стороны — review-20) |
| bone-augmentation-biooss ↔ 4590 «Knochenaufbau» | review-12 | если 4590 — общая костная пластика без бренда, общие синонимы («Наращивание кости», «Bone Grafting») перенести к ней |
| sinus-lift-with-augmentation ↔ dental-sinus-lift (4031) | review-16 | синус-лифтинг почти всегда идёт с аугментацией; синонимы первой не даны, чтобы не забирать запросы у 4031 |

## Похоже на ошибочную привязку к тарифу FZOCG

| Услуга | Код | Что в прайсе |
|---|---|---|
| tongue-tumors | X07060 | лимфоузел шеи, не язык |
| electrocochleography | X07112 | аспирационная биопсия |
| metatarsal-bone-fracture | D05083 | тарзальные кости — для них есть отдельная услуга |
| subcutaneous-plantar-or-toe-fasciotomy | D05033 | в прайсе тенолиз сгибателей стопы, не фасциотомия (review-08) |
| thyroid-biopsy | X01036 | катетеризация мочевого пузыря; специальность orthopedics_traumatology тоже похожа на ошибку (review-11) |
| hartmann-reconstruction | D02230 | сама операция Гартмана, а не реконструкция после неё (review-15) |
| cholecystectomy-with-t-tube-drainage | D02013 | холецистэктомия с интраоперационной холангиографией, не Т-дренаж; по смыслу ближе к 6076 (review-15) |
| lymph-node-biopsy-or-excision | X01025 (fzocg-pzz) | в ПЗЗ этот код — «Stavljanje IUD»; коды pzz и sekundarna пересекаются, привязка к не тому прайсу (review-18) |
| abdominal-paracentesis | X01046 | «Endotrahealna intubacija» (review-22) |
| body-plethysmography | X17006 | градиент CO2 (review-25) |
| inhalation-therapy | X01010 | в sekundarna «Tuberkulinsko testiranje», в pzz «Davanje inhalacije» — сдвиг названий в тарифе (review-25) |
| optical-coherence-tomography-oct | X06080 (sekundarna) | «Skijaskopija kod djece»; ОКТ под этим кодом только в van-mreze (review-23) |
| mri-soft-tissue-neck | J09019/J09020 | коды не совпадают между sekundarna и van-mreze (review-20) |
| laparoscopic-myomectomy | D01037 | это гистероскопическая (review-26) |
| salpingo-oophorectomy | D01044 | только трубы (review-26) |
| total-laparoscopic-hysterectomy | D01061 | операция Вертгейма (review-26) |
| hysteroscopy-asherman | D01030 | диагностическая (review-26) |
| iv-cannula-application | X01033 | катетеризация мочевого пузыря (review-24) |
| oxygen-administration | X01006 (sekundarna) | клизма (review-24) |
| suture-removal | X01015 (sekundarna) | первичная обработка раны (review-24) |
| pregnancy-preventive-examination-by-calendar | A01010 | «Preventivni pregled djece do 15 godina u slučaju epidemije» — отвязать (review-27) |
| nasogastric-tube (NG) | X01023 (fzocg-pzz) | «Davanje metadona» — привязка к не тому прайсу (review-29) |
| aspiration-puncture-of-abscess-or-hematoma (5294) | X01011 (pzz) | тариф пункции подкожных гематом привязан к 5294, а по смыслу это 7048 anterior-hematoma-puncture (review-30) |
| 6945, 6946 | Y04003, Y04004 | имена тарифов съехали на соседние позиции; OCR и прайс Danilo подтверждают названия услуг (review-31) |
| msct-head-and-neck-native | J08005 | «MSCT angiografija vrata i mozga bez kontrasta» — это КТ-ангиография, а услуга — нативная КТ головы и шеи (review-10) |

## Ошибка в тарифе, а не в названии

| Тариф | Батч | Что |
|---|---|---|
| J06019 | review-19 | «po Fileru» — в OCR «Fišeru» |
| J06028 | review-19 | «Intervencijska» — в OCR и прайсе Никшича «Intravenska» |
| J06059 | review-19 | несёт текст J06029; в OCR «Intravenozna cistografija» |
| X01050, X01058, X01014, X01034, X01055, X01032 | review-18 | привязка к коду верная, но `name_sr_latin` сдвинут на соседнюю позицию; верные имена — в `fzocg/sekundarna-ostalo/paddleocr/base.items.json`. Услуги: joint-puncture, minor-local-anesthesia, primary-wound-care-without-sutures, rapid-blood-glucose-test, tube-feeding-per-meal, urinary-catheter-placement |
| X01070 | review-18 | «febrolnat» — ошибка OCR, в исходнике «flebomat» |
| X01011, X01047, X01049, X01051 (sekundarna) | review-17 | названия кодов сдвинуты |
| X10001 (medical_service_tariffs) | review-07 | `name_sr_latin` «…manjih lezija» — ошибка OCR, в исходном прайсе FZOCG и у Danilo «malignih». Название услуги excision-of-malignant-skin-lesions верное. |

## Решено

| Услуга | Решение |
|---|---|
| esophagogastrectomy-…-cervical-esophagostomy (6895) | Правка fix-06 принята: первоисточник FZOCG D28083 — «primarnom intratorakalnom anastomozom na vratu», то есть анастомоз, а не стома; старое «шейная эзофагостома» было ошибкой раскрытия сокращения прайса. |
| packed-red-blood-cells rh+/rh− (6910, 6911) | fix-90: ru «отмытых эритроцитов» → «эритроцитной массы», tr «Yıkanmış eritrosit» → «Eritrosit süspansiyonu». В sr «deplazmatisanih eritrocita» — это эритроцитная масса; отмытые эритроциты — отдельная услуга 5814. |
| breast-implant-replacement | fix-90: sr «Zamena grudnih implantanata» → «Zamjena grudnih implantata» |
| calf-implants (3520) | fix-90: sr «Ugradnja potkolenh implantanata» → «Ugradnja potkoljeničnih implantata» |
| inguinal-hernioplasty-with-hydrocele-excision (6002) | fix-90: sr «Hernioplastica» → «Hernioplastika», как в FZOCG D02072 |
| Серия «лечение пульпита» (review-14 + review-16) | review-16 приведён к формату review-14: «Liječenje pulpitisa N-korijenog zuba (mašinski / NiTi)», «Лечение пульпита N-корневого зуба (машинная обработка каналов / NiTi)», de «Pulpitisbehandlung eines …wurzeligen Zahns (…)». Немецкая серия гангрены в review-13 — к тому же виду. |
| 6513 (D05140) | review-04: название клиники было обрублено на «SA ILI BEZ», импорт дописал «с/без трансплантата». По FZOCG «с/без» — про стилоидэктомию лучевой кости, трансплантат входит всегда. Переписаны все 5 локалей. |
| 6404 radius-and-ulna-diaphysis (D05014) | review-04: название клиники обрублено на «SA PROS», совпадает с началом D05014 — это открытый (сложный) перелом, а не «проширенная репозиция»; «proširenom repozicijom» — неверное прочтение обрывка. Переписаны все 5 локалей. |
| Серия прижигания 5332/5333/5343/5344/5345 | review-17: «малых/средних/крупных/обширных/множественных» переводчик додумал по обрубку прайса Danilo «…BEN». По FZOCG X02031–45, прайсу Никшича и шагу цены (~12,5 €) это 1/2/3/4/5+ образований — переименовано по числу. Слаги (-small/-medium/…) остались. |
| Фурункул (FZOCG X01049) | review-17: «mastitisa» в sr было додумано по обрубку «…MA»; по FZOCG — «manjeg kožnog ili potkožnog abscesa, paronihije ili hematoma». |
| Серии рентгенов, «Bett-Tag», пульпит | Соседним батчам передано выравнивание: review-21 — «Rendgen …» в sr и «боковые проекции» (сделано); review-31 — «Pflegetag». |
| Кракозябры и невидимые символы | «Rendgen ┼бake», «obe ┼бake», «тАУ» исправлены батчами review-20/21. Мягкие переносы в 25 названиях («Гернио-пластика») вычищаются сборщиком по всему каталогу в 036. |
| fix-90, дополнение | повязки ambulatory-medium / operation-small-i — к серии review-24 (tr «ambulans» — машина скорой, стало «poliklinik»); смешение алфавитов: tr «sklerotеrapisi», ru «AРК» (раскрыто как аномальная ретинальная корреспонденция), ru «уретероcигмостомой»; sr «Face lifting …» → «Lifting lica …», «Full (kompletna) …» → «Kompletna …». |
| anterior-hematoma-puncture (7048) | review-30: «prednjih» — ошибка чтения скана ДЗ Херцег-Нови под кодом X01011; у Колашина и в FZOCG ПЗЗ — «Punkcija potkožnih hematoma». Переименованы все 5 локалей; синонимы про подкожную гематому у 5294 сняты, чтобы не перетягивали запросы. |
| hospital-care-for-involuntarily-hospitalized-patient (Y01026) | review-30: по скану FZOCG позиция включает и пациентов с мерой обязательного лечения — вторая группа была потеряна во всех локалях, дописана. |
| Операционные «tier I / II» | review-31 расшифровал по документу FZOCG: I — операционные общих больниц (Y05001–05), II — Клинического центра и специальных больниц (Y05006–10). Пять позиций вне ростеров (tier-i-over-180, tier-ii-5-20/51-120/121-180/over-180) выровнены в fix-90. |
| 37 конфликтов fix/review | Поле, поправленное обоими шагами по-разному (`_conflicts.md`). Во всех 37 версия шага 2 не хуже, чаще полнее: восстановлено по FZOCG («с внутренней или наружной фиксацией», «на уровне предплечья»), кальки убраны («Ревизия» вместо «Эксплорации», «Закрытая репозиция» вместо «Манипулятивной»), серии выровнены. Переопределений нет. |
