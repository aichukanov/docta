# Tesla Medical: цены с сайта (2026-10-02)

Клиника `tesla-medical-berane` (Беране), id 86 и локально, и на проде (`/api/clinics/details`).
До синхронизации на проде 77 услуг с ценами, анализов 0; прод = локальная построчно (`/api/services/list`).

Два SQL, порядок не важен:

- `server/sql/insert-clinic-prices-tesla-medical-berane.sql` — услуги с /cene/;
- `server/sql/insert-clinic-prices-tesla-medical-berane-lab.sql` — лаборатория из двух PDF. Оба PDF помечены владельцем
  «radna verzija» (черновик); применять решено (юзер, 2026-10-05).

Оба прогнаны локально в транзакции с ROLLBACK, дважды подряд: результат совпадает с блоком VERIFICATION, повтор ничего не меняет.

**Применено 2026-10-05 — локально и на проде.** Прод сверен по API построчно: 121 активная услуга + `spinal-decompression`
с `is_obsolete`, 882 анализа (275 из них — через `/api/labtests/details`, в карточку списка цена Tesla не попадает);
все цены и диапазоны совпали с SQL, `isOutdated` нет ни у одной строки.

**Спорные анализы разобраны 2026-10-06** — третий SQL `server/sql/update-clinic-prices-tesla-medical-berane-disputed.sql`
(лаборатория, раздел 2). Перед сборкой локальная БД = прод для клиники: 882 строки, `/api/labtests/details` по каждому slug.
Прогнан локально в транзакции с ROLLBACK дважды: второй прогон — 0 затронутых строк. **Не применён** ни локально, ни на проде.

## Источники и даты

| Источник | Снимок | Дата прайса | Откуда дата |
|---|---|---|---|
| https://www.teslamedical.me/cene/ | `2026-10-02-cene.html`, `2026-10-02-cene.wp-json.json` | 2020-01-13 | wp-json pages/57 `modified` |
| …/uploads/2019/11/cenovnik-biohemija-radna-verzija.pdf | `2026-10-02-cenovnik-biohemija-radna-verzija.pdf` | 2019-11-26 | Last-Modified и CreationDate PDF (Excel 2016) |
| …/uploads/2019/11/cenovnik-mikrobiologija.pdf | `2026-10-02-cenovnik-mikrobiologija.pdf` | 2019-11-26 | то же |

Снимки — `data/clinic-pricelists/sources/tesla-medical-berane/`.

**`is_price_outdated` не ставится нигде** (решение юзера 2026-10-05): кроме даты прайса, признаков устаревания нет.
Проверены 17 отзывов Google (6 с текстом): цены упоминают два — 2025 «cijene povoljne» и 2022 «PCR test 69€ i rade ga u Podgoricu u MojLab»
(PCR в прайсе нет; заодно видно, что часть анализов уходит в Moj Lab — вероятный смысл меток `#`).

**Как читался PDF биохимии.** Excel разложил колонки по страницам: на страницах 1–18 раздел, на 19–36 название, на 37–54 цена.
Строки склеены по y-координате (PyMuPDF). В `pdftotext -layout` цены съезжают на строку — его не использовать.
Метки `#` / `##` в названиях — служебные пометки лаборатории, расшифровки на сайте нет. Похоже на отправку в партнёрскую лабораторию.

# Услуги

| | Строк сайта | |
|---|---|---|
| Меняется цена | 0 | все совпавшие цены = сайту |
| Совпадает | 76 | 75 строк клиники, не трогаются |
| Спорные | 1 строка клиники | раздел 2 — нужно решение |
| У нас есть, на сайте нет | 1 | раздел 3 — `spinal-decompression` → `is_obsolete` |
| На сайте есть, у нас нет | 43 | раздел 4 — 42 новых строк, 6 новых записей каталога |

## 1. Меняется цена

Нет. Все 76 строк сайта, которые у клиники уже были, стоят столько же, сколько в БД: цены в БД — из этого же прайса 2020 года.

Совпадают (две строки сайта на одну запись: «EMNG donjih» и «EMNG gornjih» по 45 € → `emng-de-or-ge`):

| Запись каталога | Название на сайте | € |
|---|---|---|
| `cardiologist-examination` | Specijalisticki pregled kardiologa | 30 |
| `cardiologist-examination-with-ecg-and-echocardiography-heart-ultrasound` | Specijalisticki pregled kardiologa plus eho srca | 50 |
| `follow-up-cardiologist-examination` | Kontrolni kardioloski pregled | 20 |
| `arrhythmologist-electrophysiologist-examination` | Pregled arimologa-elektrofiziologa | 50 |
| `holter-ecg-24h` | Holter EKG-a | 50 |
| `holter-blood-pressure-24h` | Holter Pritiska | 50 |
| `stress-echocardiography` | Stres eho test | 120 |
| `ergometry-stress-test` | Ergometrija -test opterecenja | 50 |
| `spirometry` | Spirometrija | 20 |
| `electric-cardioversion` | Elektrokonverzija | 350 |
| `first-gastroenterologist-examination` | Specijalisticki pregled gastroenterologa | 30 |
| `follow-up-gastroenterologist-examination` | Kontrolni gastroeneteroloski pregled | 20 |
| `gastroscopy-with-anesthesia` | Gastroskopija u anesteziji | 150 |
| `colonoscopy-with-anesthesia` | Kolonoskopija u anesteziji | 180 |
| `breath-urea-test` | BUT test | 50 |
| `abdominal-paracentesis` | Punkcija ascita | 80 |
| `anorectal-clinical-examination` | Digitorektalni pregled (rektalni tuse) | 20 |
| `first-neurologist-examination` | Specijalisticki neuroloski pregled | 30 |
| `follow-up-neurologist-examination` | Kontrolni pregled neurologa | 15 |
| `emng-de-or-ge` | EMNG sniman donjih ekstremiteta / EMNG snimanje gornjih ekstremiteta | 45 |
| `emng-de-and-ge` | EMNG snimanje gornjih i donjih ekstremiteta | 75 |
| `electroencephalography` | EEG | 40 |
| `eeg-after-sleep-deprivation` | EEG posle deprivacije sna | 50 |
| `professor-neurologist-examination` | Specijalisticki neuroloski pregled profesora doktora | 50 |
| `follow-up-professor-neurologist-examination` | Kontrolni neuroloski pregled profesora doktora | 20 |
| `general-practitioner-examination` | Pregled specijaliste opste prakse | 30 |
| `follow-up-general-practitioner-examination` | Kontrolni pregled kod doktora opste prakse | 15 |
| `home-visit-city-center` | Pregled specijaliste opste prakse na terenu -grad | 40 |
| `home-visit-suburban` | Pregled specijaliste opste prakse na terenu – periferija | 50 |
| `intramuscular-injection` | Davanje intramuskularne terapije + cena leka | 5 |
| `intravenous-medication-application` | Davanje intravenske terapije + cena leka | 10 |
| `intramuscular-injection-home-visit-city` | Davanje intramuskularne terapije patronaza grad + cena leka | 10 |
| `intramuscular-injection-home-visit-suburban` | Davanje intramuskularne terapije patronaza periferija + cena leka | 15 |
| `intravenous-therapy-home-visit-city` | Davanje intravenske terapije patronaza grad + cena leka | 15 |
| `intravenous-therapy-home-visit-suburban` | Davanje intravenske terapije patronaza periferije + cena leka | 20 |
| `first-physiatrist-examination` | Specijalistiizicki pregled fiijatra | 40 |
| `follow-up-physiatrist-examination` | Kontrolni pregled fizijatra | 20 |
| `kinesiotherapy` | Kinezi terapija | 12 |
| `kinesiotherapy-for-children-with-deformities` | Stimulativne vjezbe kod djece | 7 |
| `electrotherapy` | Elektroterapija | 12 |
| `shock-wave-therapy` | Shock wave | 15 |
| `laser-therapy` | Laser visokog inteziteta | 12 |
| `spine-scan` | Spine scan | 7 |
| `therapeutic-massage-partial` | Manuelna masaza | 15 |
| `therapeutic-massage-complete` | Manuelna masaza | 25 |
| `urologist-examination-with-ultrasound` | Specijalisticki pregled urologa sa ultrazvukom | 50 |
| `urologist-examination` | Specijalisticki pregled urologa | 30 |
| `follow-up-urologist-examination` | Kontrolni pregled urologa | 15 |
| `gynecological-examination-with-ultrasound-and-colposcopy` | Specijalisticki pregled ginekologa sa ultrazvukom i kolposkopijom | 50 |
| `gynecological-specialist-examination` | Specijalisticki pregled ginekologa | 30 |
| `gynecological-ultrasound` | Ginekoloski ultrazvuk | 30 |
| `colposcopy` | Kolposkopija | 25 |
| `pap-test-with-smear-collection` | PAPA test | 15 |
| `rheumatologist-examination` | Specijalisticki pregled | 30 |
| `follow-up-rheumatologist-examination` | Kontrolni pregled reumatologa | 15 |
| `endocrinologist-examination-with-ultrasound` | Specijalisticki pregled i ultrazvuk | 50 |
| `professor-endocrinologist-examination` | Specijalisticki pregled prof dr | 40 |
| `follow-up-endocrinologist-examination` | Kontroli pregled endokrinologa | 20 |
| `dermatologist-examination` | Specijalisticki pregled | 35 |
| `follow-up-dermatologist-examination` | Kontrolni pregled dermatologa | 20 |
| `chemical-peeling-face` | Hemiski piling lica | 70 |
| `chemical-peeling-back` | Hemiski piling ledja | 100 |
| `abdomen-ultrasound` | Ultrazvuk abdomena | 25 |
| `breast-ultrasound` | Ultravuk dojke | 25 |
| `orthopedic-ultrasound-single-joint` | Ultrazvuk koljena | 25 |
| `soft-tissue-ultrasound` | Ultrazvuk mekih tkiva | 25 |
| `neck-ultrasound` | Ultrazvuk vrata | 25 |
| `thyroid-ultrasound` | Ultrazvuk stitne zlijezde | 25 |
| `doppler-renal-arteries` | Kolor dopler bubrega | 35 |
| `doppler-lower-extremity-blood-vessels` | Kolor dopler d.ekstremiteta | 35 |
| `doppler-upper-extremity-blood-vessels` | Kolor dopler g.ekstremiteta | 35 |
| `doppler-neck-blood-vessels` | Kolor dopler vrata | 35 |
| `x-ray-reading` | RTG SA OPISOM | 25 |
| `hyperbaric-oxygen-therapy-session` | Jedan ulazak – tretman u hiperbričnoj komori | 40 |
| `hyperbaric-oxygen-therapy-with-wound-care` | Jedan ulazak – tretman sa previjanjem -obradom rane | 60 |

## 2. Спорные

| # | На сайте | € | Кандидаты | В чём сомнение |
|---|---|---|---|---|
| 1 | Kolor dopler d.ekstremiteta | 35 | `lower-extremity-color-doppler` (строка клиники) | вторая строка под ту же позицию сайта «Kolor dopler d.ekstremiteta» (35 €), рядом с doppler-lower-extremity-blood-vessels (35 €). Записи каталога — дубли друг друга (как и пара upper-extremity-color-doppler / doppler-upper-extremity-blood-vessels); решать слиянием каталога, а не пометкой у одной клиники. |

Мелкое, но в SQL оставлено как было: «RTG SA OPISOM» 25 € висит на `x-ray-reading` («Čitanje rendgena»). На сайте это скорее
снимок с описанием, а не чтение чужого снимка, но общей записи «рентген с описанием» в каталоге нет. Цена совпадает, строка не тронута.

## 3. У нас есть, на сайте нет

| Запись каталога | € | Решение |
|---|---|---|
| `spinal-decompression` («Spinalna dekompresija») | 13 | на сайте такой позиции нет; цена 13 € и место в разделе — у «Trakcija». Пересажено на `mechanical-spinal-traction` («Trakcija kičmenog stuba na aparatu»), старая строка `is_obsolete = 1` |

## 4. На сайте есть, у нас нет

В этом же SQL. МРТ и КТ у клиники не было вовсе. Три КТ без указания контраста («CT abdomena i male karlice», «CT pluća, abdomena i male karlice»,
«CT mekih tkiva vrata i grudnog koša») заведены как исследования с контрастом — решение юзера 2026-10-05: по ценам соседних строк это они.

| Запись каталога | Название на сайте | € |
|---|---|---|
| `echocardiography-heart-ultrasound` | Eho srca | 40 |
| `mechanical-spinal-traction` | Trakcija | 13 |
| `mri-brain` | MR glave | 120 |
| `mri-soft-tissue-neck` | MR mekih tkiva vrata | 130 |
| `mri-brain-with-mra` | MR glave sa angiografijom | 180 |
| `mri-pituitary-gland-sella-turcica` | MR hipofize sa kontrastom | 160 |
| `mri-brain-and-cervical-spine` | MR glave i vratnog dijela kicme | 200 |
| `mri-thorax-and-mediastinum` | MR grudnog kosa | 140 |
| `mri-abdomen` | MR abdomena | 140 |
| `mri-cholangiography-mrcp` | MRCP | 140 |
| `mri-pelvic-organs` | MR male karlice | 130 |
| `mri-single-joint` | MR zglobova | 130 |
| `mri-lumbosacral-spine` | MR L/S kicme | 120 |
| `mri-two-spine-segments` | MR LS kicme i TH kicme / MR LS kicme i C kicme | 200 |
| `mri-full-spine` | MR kompletnog kicmenog stuba | 280 |
| `mri-knee-joint` | MR koljena | 130 |
| `mri-contrast-agent` **(новая)** | Kontrast | 35 |
| `msct-abdomen-and-pelvis-with-contrast` | CT abdomena i male karlice | 160 |
| `msct-abdomen-with-contrast` | CT abdomena sa kontrastom | 110 |
| `msct-angiography-abdominal-aorta-and-lower-extremities` | CT angiografija abdominalne aorte i donjih ekstremitata | 180 |
| `msct-angiography-head-and-neck-vessels` | CT angiografija glave i vrata | 140 |
| `msct-angiography-pulmonary-arteries-pte` | CT angoigrafija pluća | 130 |
| `msct-angiography-aorta` | CT aortografija | 140 |
| `msct-cervical-spine` | CT C kičme | 70 |
| `msct-two-spine-segments` | CT C kičme i LS kičme | 120 |
| `msct-head-and-cervical-spine` **(новая)** | CT glave i C kicme | 120 |
| `msct-head-endocranium-without-contrast` | Ct glave nativa | 70 |
| `msct-head-endocranium-with-contrast` | CT glave sa kontrastom | 100 |
| `msct-knee` **(новая)** | CT koljena | 70 |
| `msct-coronary-angiography` | CT koronarografija | 180 |
| `msct-lumbosacral-spine` | CT LS kicme | 70 |
| `msct-pelvis-with-contrast` **(новая)** | CT male karlice sa kontrastom | 110 |
| `msct-soft-tissue-neck-with-contrast` | CT mekih tkiva vrata sa kontrastom | 110 |
| `msct-chest-and-abdomen-with-contrast` | Ct pluća i abdomena sa kontrastom | 170 |
| `msct-thorax-chest-with-contrast` | CT pluća sa kontrastom | 100 |
| `msct-shoulder` **(новая)** | CT ramena | 70 |
| `msct-thoracic-spine` | CT TH kicme | 70 |
| `msct-ivu-intravenous-urography` | CT urografija | 130 |
| `msct-chest-abdomen-pelvis-with-contrast` | CT pluća, abdomena i male karlice | 210 |
| `msct-neck-and-chest-with-contrast` | CT mekih tkiva vrata i grudnog kosa | 170 |
| `lower-abdomen-ultrasound` | Ultrazvuk male karlice | 25 |
| `pelvic-color-doppler` **(новая)** | Kolor dopler karlice | 35 |

«MR LS kičme i TH kičme» и «MR LS kičme i C kičme» (обе 200 €) — одна запись `mri-two-spine-segments`: в каталоге МРТ двух отделов
не делится по сочетаниям.

### Новые записи каталога услуг

| name_en | name_sr | slug | Почему |
|---|---|---|---|
| MRI Contrast Agent | MR kontrastno sredstvo | `mri-contrast-agent` | есть только `ct-contrast-agent` |
| MSCT Head and Cervical Spine | CT glave i vratnog dijela kičme | `msct-head-and-cervical-spine` | есть МРТ этой пары (`mri-brain-and-cervical-spine`), КТ нет |
| MSCT Knee | CT koljena | `msct-knee` | КТ коленного сустава нет, есть только общие «одна регия» |
| MSCT Pelvis with Contrast | CT male karlice sa kontrastom | `msct-pelvis-with-contrast` | есть только `msct-pelvis-native` |
| MSCT Shoulder | CT ramena | `msct-shoulder` | КТ плеча нет |
| Pelvic Color Doppler | Kolor dopler krvnih sudova male karlice | `pelvic-color-doppler` | допплера сосудов малого таза нет |

# Лаборатория

Новый прайс: анализов у клиники не было.

| | Строк прайса | |
|---|---|---|
| Всего строк в двух PDF | 1014 | биохимия 893, микробиология 121 |
| Без цены («0.00», «/», пусто) | 39 | не заводятся, список ниже |
| Раздел «Usluge» | 5 | → 3 строки услуг (раздел 5) |
| Заведено | 925 | → 882 строк `clinic_lab_tests`: 633 на существующие записи, 249 на новые |
| Спорные | 30 | раздел 2 — решены 2026-10-06: +18 строк `clinic_lab_tests` и 1 правка диапазона, 2 сведены к стоящим строкам, 8 исключены |
| «nakon provere DNK» | 6 | раздел 3 — не заведены |
| Исключены | 9 | раздел 4 — не анализ пациента |

Сопоставление делали 8 параллельных агентов по разделам прайса. Каждый slug проверен по каталогу; slug-множество каталога анализов на проде
и локально совпадает (1774 записи на 2026-10-05, `/api/labtests/list`); за время работы другие импорты завели 52 записи, которые здесь
предлагались новыми, — строки переставлены на них. Спорные пересмотрены 2026-10-05: где кандидат один и разумный, он поставлен в SQL (59 строк). Кириллица новых записей — `scripts/common/sr-cyrl-names.mjs` плюс пословная правка:
аббревиатуры, символы генов и латинские биномы оставлены латиницей, как в каталоге (MTHFR, PAI-1, DNK).

## 1. Несколько строк прайса на одну запись

Одинаковые названия с разной ценой — диапазоном (`price` … `price_max`). Причина второй цены в прайсе не указана.

| Запись | Строки прайса | € |
|---|---|---|
| `karyotype-from-abortion-material` | B071 Kariotip fetusa iz abortnog materijala (130) / B072 Kariotip fetusa iz abortnog materijala (250) | 130–250 |
| `karyotype-from-amniotic-fluid` | B073 Kariotip iz amnionske tečnosti (230) / B074 Kariotip iz amnionske tečnosti (170) | 170–230 |
| `karyotype-from-chorionic-villi` | B076 Kariotip iz horionskih resica (190) / B077 Kariotip iz horionskih resica (100) | 100–190 |
| `microalbumin-in-urine` | B356 Albumini u urinu (Mikroalbuminurija) (5) / B848 Mikroalbumini - drugi jutarnji urin (6) | 5–6 |
| `coagulation-factor-vii` | B474 Koagulacioni faktor VII (23) / B475 Koagulacioni faktor VII (28) | 23–28 |
| `herpes-simplex-ii-igm` | B606 HSV 2 IgM (13) / B610 HSV-2 IgM (10) / B874 HSV2-IgM (10) | 10–13 |
| `duchenne-muscular-dystrophy` | B699 Dišenova Muskularna Distrofija-DMD (Distrofin) (800) / B700 Dišenova Muskularna Distrofija-DMD (Distrofin) (710) | 710–800 |
| `pneumocystis-jirovecii-pcr` | B770 Pneumocystis carinii DNA (150) / B771 Pneumocystis carinii DNA (120) | 120–150 |
| `jc-virus-pcr` | B794 Polioma JCV Virus DNA (112) / B876 JC-Polyoma virus DNA (110) | 110–112 |
| `mycoplasma-hominis-culture` | M010 Biopsijski materijal- Mycoplasma hominis (10) / M050 Cervikalni bris-Mycoplasma hominis (11) / M078 Sperma- Mycoplasma hominis (12) / M093 Uretralni bris- Mycoplasma hominis (12) | 10–12 |
| `ureaplasma-urealyticum-culture` | M011 Biopsijski materijal- Ureaplasma urealyticum (10) / M048 Cervikalni bris- Ureaplasma urealyticum (12) / M079 Sperma- Ureaplasma urealyticum (12) / M094 Uretralni bris- Ureaplasma Urealiticum (12) | 10–12 |
| `chlamydia-genital-swab` | M046 Cervikalni bris- Chlamidiae trachomatis (11) / M091 Uretralni bris- Chlamidiae trachomatis (12) | 11–12 |

Строки-дубли с той же ценой сведены к одной строке клиники молча (например, CMV IgG в «Mikrobiologija» и в «Virusološki parametri»).

## 2. Спорные — решены 2026-10-06

Все 30 строк закрыты, вопросов юзеру не осталось. SQL — `server/sql/update-clinic-prices-tesla-medical-berane-disputed.sql`
(не применён). Правила решения: если в каталоге один разумный кандидат, строка ставится на него. Две цены одного теста: стандартная
цена идёт в SQL, вторая — в `excluded` с причиной. Новая запись каталога заводится, только если её точно нет (поиск по `name_*`,
синонимам и кодам по всему каталогу, без обрезки). `is_price_outdated` не ставится.

Итог: в SQL 20 строк прайса (18 новых строк клиники и 1 правка диапазона), 2 строки сведены к уже стоящим строкам, 8 исключены.
Новых записей каталога 13 — таблица ниже.

### В SQL

| ID | В прайсе | € | Решение | Почему |
|---|---|---|---|---|
| B013 + B034 | IgE-At Aspergillus screen 3 / IgE-RAST-Aspergillus Profil | 15 / 14 | **новая** `aspergillus-fumigatus-ige-m3`, диапазон 14–15 | Обе строки — IgE к Aspergillus по цене одиночного аллергена. Смесь mx4 в том же прайсе стоит 49 €. Одиночного m3 в каталоге не было |
| B048 | IgG-RAST Eritromicin | 15 | **новая** `erythromycin-ige` | Весь блок лекарственных RAST — IgE по 15 €, «IgG» здесь опечатка. Эритромицина в каталоге не было ни в каком классе |
| B054 | Skrining alergena na ribu (fx74) | 49 | **новая** `fish-mix-fx74` | Решает код: fx74 ≠ FP2. Запись заведена по образцу соседних `seafood-mix-fx2` и `food-mix-fx5`. Возможный дубль с `fish-mix-fp2` — в хвосте раздела 6 |
| B456 | Droge u urinu - kvalitativno | 25 | `psychoactive-substances-panel-5-10-parameters` | Панель без указанного состава. Это единственная запись, которая не фиксирует число веществ (FZOCG Z02091, у государственных больниц 26,25 €) |
| B566 | Antitela prema Hanta virusu | 11 | **новая** `hantavirus-antibodies` | Класс антител не указан, а в каталоге только раздельные IgG/IgM. Сделано так же, как `malaria-antibodies` и `enterovirus-antibodies` этого импорта |
| B639 | RSV Antitela | 12 | **новая** `rsv-antibodies` | То же: класс не указан |
| B665 | Detekcija "Long DNA" | 18 | **новая** `long-dna-test` | Маркер колоректального рака. `genetic-analysis-stool` (480 €) — другой тест. Материал в названии записи не указан, потому что в прайсе его нет |
| B687 | Skrining na nasledne kancere (30 gena) | 220 | **новая** `hereditary-cancer-panel-30-genes` | Панели на 30 генов в каталоге нет. HerediGEN 33, Sentis и pan-cancer — другие продукты |
| B688 | Skipping mutacija u 14. exonu gena za DPD | 140 | `dihydropyrimidine-dehydrogenase` | DPYD*2A — основной вариант генотипирования DPD. Запись каталога генетическая (категория GENETICS, EDTA) |
| B701 | Dišenova Muskularna Distrofija-Tip 1 | 590 | **новая** `myotonic-dystrophy-type-1-dm1-genetic-test` | У Дюшенна нет типов, а «тип 1/2» — это миотоническая дистрофия DM1/DM2. Строки ушли в алфавит под «Dišenova» вслед за DMD. Отдельная строка «Miotonična distrofija (DMPK gen)» — без цены, она добавлена синонимом к DM1 |
| B702 | Dišenova Muskularna Distrofija-Tip 2 | 590 | **новая** `myotonic-dystrophy-type-2-dm2-genetic-test` | DM2 (CNBP) |
| B713 | Mikrodelecijski sindromi | 110 | **новая** `microdeletion-syndromes-panel` | Общая панель микроделеций без перечня. В каталоге были только Angelman/Prader-Willi (B711, 130 €) и Y-хромосома |
| B780 | Detekcija prisustva i genotipizacija HPV | 77 | `hpv-genotyping-pcr` | Число типов не указано. Подходит общая запись «Genotipizacija HPV - PCR» (KCCG K04004), а панели с числом типов — нет |
| B807 | Profil Pre-Eklamsije | 110 | `preeclampsia-screening-after-12-weeks` | Лабораторный «профиль» (несколько аналитов без УЗИ и давления) — это sFlt-1/PlGF, тест второй половины беременности. Скрининг первого триместра лабораторией отдельно не продаётся |
| B818 | Diferencijacija karnitina | 29 | **новая** `total-and-free-carnitine` | Это фракции карнитина. `carnitine-acylcarnitine-profile` — МС-профиль (137 € у Novi Standard), а `acylcarnitine-profile` у клиники уже стоит отдельной строкой B805 |
| B835 | HER-2 receptori | 34 | **новая** `her2-in-serum` | Раздел «Tumor markeri», где все позиции сывороточные. Кандидат каталога — тканевые рецепторы HER2+ER+PR, другой материал |
| B867 | EBV-Profil | 75 | **новая** `epstein-barr-antibody-profile` | Состав не указан. `epstein-barr-igg-igm-panel` — определённый состав (IgG+IgM), не то же |
| B525 | Cyclosporin A Monoklonalni (Neoral, Sandimmune) | 57 | `cyclosporine-level` | Две цены одного теста, второй записи в каталоге нет. Стандартной взята строка из раздела иммуносупрессантов: она на одном уровне с такролимусом и эверолимусом (57 €). B504 — в исключённых |
| M009 | Biopsijski materijal- Chlamidiae trachomatis | 10 | `chlamydia-genital-swab`: 11–12 → **10–12** (UPDATE с условием на старую цену) | Так же сделано с Mycoplasma/Ureaplasma этого прайса: биопсийный материал вошёл в диапазон записи по возбудителю (10–12). Культура `chlamydia-trachomatis-culture` (30–37 € по FZOCG) — другой метод |

### Сведены к уже стоящим строкам (цена та же, SQL не меняет)

| ID | В прайсе | € | Строка клиники |
|---|---|---|---|
| B179 | Retikulociti-Apsolutni broj | 1.5 | `reticulocytes` 1.5 (B178) — тот же тест, абсолютное число считается из того же анализа |
| B246 | Auto-Antitela BP 230 gC | 15 | `anti-bp230-antibodies` 15 (B245) — тот же аналит на рекомбинантном C-домене; добавлен синоним `BP230-gC` |

### Исключены (в `excluded` записи импорта)

| ID | В прайсе | € | Почему |
|---|---|---|---|
| B002 | (f78) IgG-RAST-Kazein | 15 | Дубль B038 «IgE-RAST-Kazein» (15 €, уже стоит `casein-ige-f78`). «IgG» — опечатка, как у эритромицина в том же блоке; в прайсе и другие аллергены записаны дважды (e5) |
| B114 | Prolaktin - PEG | 8 | Часть теста на макропролактин, а у клиники уже стоит `macroprolactin` 19 € (B110 «Profil Makroprolaktina») |
| B181 | Slobodni hemoglobin | 12 | Материал не указан. Рядом B182 «u plazmi» за 40 € — эта строка уже стоит. Второй записи под 12 € в каталоге нет |
| B500 | Benzodiazepini (Urin) | 14 | Вторая цена (раздел «Lekovi», вероятно количественно). У клиники уже `benzodiazepines` 4 € (B449, качественно), количественной записи в каталоге нет |
| B595 | Epstein barr-VCA IgG | 37 | Тот же аналит, что «EBV IgG» (антитела к VCA), с меткой `##`. Стандартная цена `epstein-barr-igg` 13 € уже стоит |
| B596 | Epstein-barr-VCA-IgM | 37 | То же для IgM: `epstein-barr-igm` 13 € |
| B869 | HBV konfirmatorni test | 200 | Состав не указан. 200 € в 15 раз дороже подтверждения HBsAg (11,90–14,28 €), так что это не оно. Заводить запись под неизвестный тест нельзя |
| B504 | Cyclosporin A (Monoklonalni) | 16 | Вторая цена циклоспорина, см. B525 |

### Новые записи каталога (13)

| name_en | name_sr | slug |
|---|---|---|
| Aspergillus fumigatus IgE m3 | Plijesan Aspergillus fumigatus IgE m3 | `aspergillus-fumigatus-ige-m3` |
| Epstein-Barr Antibody Profile | Profil antitijela na Epstein-Barr virus | `epstein-barr-antibody-profile` |
| Erythromycin IgE | Eritromicin IgE | `erythromycin-ige` |
| Fish Mix fx74 | Miks riba fx74 | `fish-mix-fx74` |
| Hantavirus Antibodies | Antitijela na Hanta virus | `hantavirus-antibodies` |
| HER2 in Serum | HER2 u serumu | `her2-in-serum` |
| Hereditary Cancer Panel (30 Genes) | Skrining na nasljedne karcinome (30 gena) | `hereditary-cancer-panel-30-genes` |
| Long DNA Test | Detekcija Long DNA | `long-dna-test` |
| Microdeletion Syndromes Panel | Mikrodelecijski sindromi (panel) | `microdeletion-syndromes-panel` |
| Myotonic Dystrophy Type 1 (DM1) Genetic Test | Miotonična distrofija tip 1 (DM1) — genetsko ispitivanje | `myotonic-dystrophy-type-1-dm1-genetic-test` |
| Myotonic Dystrophy Type 2 (DM2) Genetic Test | Miotonična distrofija tip 2 (DM2) — genetsko ispitivanje | `myotonic-dystrophy-type-2-dm2-genetic-test` |
| RSV Antibodies | Antitijela na RSV | `rsv-antibodies` |
| Total and Free Carnitine | Ukupni i slobodni karnitin | `total-and-free-carnitine` |

Кириллица сгенерирована `scripts/common/sr-cyrl-names.mjs` и поправлена вручную: DM1/DM2 и HER2 оставлены латиницей, как FSHD1 и HER2
в каталоге. До сборки на проде проверено через `/api/labtests/details`, что ни одного из этих slug нет, а все кандидаты есть. Свободность 19 синонимов
проверена в локальной БД.

## 3. «nakon provere DNK» — не заведены

Вторая, более дешёвая строка того же генетического теста «после проверки ДНК» — повтор на уже выделенной и проверенной ДНК.
У клиники остаётся основная цена.

| ID | В прайсе | € | Запись (основная цена) |
|---|---|---|---|
| B667 | Detekcija mikrosatelitske nestabilnosti (MSI) (nakon provere DNK) | 5 | `microsatellite-instability` — 25 |
| B670 | Mutacija V600E u 15. egzonu BRAF gena (nakon provere DNK) | 34 | `braf-mutation` — 54 |
| B673 | Mutacije u 12. i 13. kodonu K-RAS gena (nakon provere DNK) | 26 | `kras-mutations-codons-12-and-13` — 46 |
| B682 | Mutacije u EGFR genu - 18, 19, 20. i 21. egzon (nakon provere DNK) | 75 | `egfr-gene-mutations-exons-18-21` — 95 |
| B684 | Mutacije u N-RAS genu - 12, 13. i 61. kodon (nakon provere DNK) | 75 | `nras-mutations-codons-12-13-and-61` — 95 |
| B741 | Očinstvo - poređenje genetičkih profila nakon provere DNK (otac + dete) | 190 | `paternity-testing-pcr` — 240 |

## 4. Исключены

| ID | В прайсе | € | Почему |
|---|---|---|---|
| B686 | Provera kvaliteta DNK u parafinskom kalupu | 20 | техническая операция: контроль качества ДНК из парафинового блока перед анализом |
| B708 | Izolacija DNK-Kolonice | 24 | техническая операция: выделение ДНК (из колоний/образца), не самостоятельный анализ |
| B749 | Provera kvaliteta DNK u biološkim uzorcima | 50 | техническая операция: контроль качества ДНК в образце перед анализом |
| M063 | Kontrola efikasnosti sterilizacije | 9 | Контроль эффективности стерилизации — санитарный/технический контроль, не анализ пациента |
| M064 | Kontrola sterilnosti- aerozagađenja | 4 | Контроль стерильности воздуха — санитарный контроль помещений |
| M065 | Kontrola sterilnosti- brisevi površina | 6 | Контроль стерильности, смывы с поверхностей — санитарный контроль |
| M066 | Kontrola sterilnosti rastvora | 6 | Контроль стерильности растворов — технический контроль |
| M070 | Otisak prstiju bakteriološki | 6 | Бактериологический отпечаток пальцев — санитарно-гигиенический контроль рук персонала, не диагностика пациента |
| M114 | Inaktivacija seruma | 3 | Инактивация сыворотки — техническая операция |

Без цены (не заводятся): B060 «ACIDO/BAZNI status» (0.00); B062 «Glukoza u urinu- Kvantitativno» (0.00); B063 «HOMA-IR Index» (0.00); B065 «Kreatinin u urinu» (0.00); B082 «Konsultacija - genetički savet» (0.00); B085 «Citološka punkcija» (0.00); B086 «Citološki pregled brisa» (0.00); B087 «Citološki pregled endoskopskih briseva» (0.00); B088 «Citološki pregled perifernog razmaza krvi» (0.00); B089 «Citološki pregled punktata» (0.00); B090 «Citološki pregled sputuma» (0.00); B091 «Citološki pregled sternalnog punktata» (0.00); B092 «Citološki pregled telesnih tečnosti» (0.00); B093 «Citološki pregled urina» (0.00); B094 «Lupus (LE ćelije)» (0.00); B095 «Mijelokultura - CFU-MG» (0.00); B125 «Aldosteron/Renin - Odnos» (0.00); B129 «Kortizol iz pljuvačke» (0.00); B194 «RhD Faktor» (пусто); B278 «Pemphigus/Penfigoidna Panel» (пусто); B336 «Inseminacija - priprema uzorka sperme» (0.00); B352 «Osmolaritet Seruma» (0.00); B406 «Glukoza» (пусто); B483 «Lupus Antikoagulans-Index» (пусто); B484 «Lupus antikoagulans-Potvrdni» (пусто); B491 «Von-Willebrand Ac/VWF:Ag odnos» (пусто); B496 «VWF: Odnos (Aktivnost/Antigen)» (пусто); B498 «9-Hydroxy-Risperidon» (пусто); B531 «Albumini u likvoru» (пусто); B534 «Hloridi u likvoru (CSF)» (пусто); B535 «Proteini u likvoru» (пусто); B542 «Oksalati u urinu» (0.00); B563 «Antitela na Brucellu (IgG, A,M)» (пусто); B585 «Coxiella burnetii Antitela (Faza 1+2)» (пусто); B714 «Miotonična distrofija (DMPK gen)» (пусто); B736 «Mutacije u SPRED1 genu (Legijus sindrom)» (0.00); M113 «Faktor rizika» (0.00); M115 «Index ateroskleroze» (0.00); M116 «Osteopontin» (0.00).

## 5. Раздел «Usluge» → услуги

| Запись каталога услуг | В прайсе | € |
|---|---|---|
| `venous-blood-draw` | Uzimanje uzorka 1 | 1 |
| `iv-cannula-application` | Braunila 3 | 3 |
| `field-sampling` | Patronaža centar 5 / Patronaža periferija 8 / Patronaža udaljena naselja 10 | 5–10 |

«Patronaža» в лабораторном прайсе — выезд на забор по трём зонам. В каталоге одна запись `field-sampling` («Uzimanje uzorka na terenu»), поэтому диапазоном.

## 6. Ошибки каталога, найденные по ходу

Не правились, в SQL не трогаются. Отдельная задача.

- **Коды аллергенов.** d1 (Dermatophagoides pteronyssinus) стоит синонимом у `house-dust-mite-ige-h2`, а код d1 — у `storage-mite-ige-d1`;
  g12 (культурная рожь) подписан как «ljulj» (райграс), рожь — под g14; g6 (тимофеевка) стоит у `cat-hair-ige-g6`, тимофеевка — под g2 и g16;
  `egg-white-ige-e1` (белок яйца — f1), `paracetamol-acetaminophen-ige-c2`, `rye-ige-f4` — коды не те.
  Добавилось 2026-10-06: `fish-mix-fx74` (заведена по коду) и `fish-mix-fp2` (Novi Standard), возможно, одна смесь рыб под разными кодами.
- **Почти-дубли** (взята запись, у которой больше клиник): `nt-probnp` / `pro-bnp`; `beta-2-glycoprotein-i-igg/igm` / `beta-2-glycoprotein-1-igg/igm`;
  `aquaporin-4-antibodies` / `aquaporin-antibodies`; `diamine-oxidase` / `diamine-oxidase-dao-histamine`; `free-metanephrine` / `free-metanephrine-in-plasma`;
  `vma` / `vma-in-urine`; `penicilloyl-g/v` в вариантах `-ige` и `-hsa`.
- **Услуги:** `lower-extremity-color-doppler` / `doppler-lower-extremity-blood-vessels` и `upper-extremity-color-doppler` / `doppler-upper-extremity-blood-vessels`.

## 7. Новые записи каталога анализов (249)

Для сверки с параллельными агентами.

| name_en | name_sr | slug | Строки |
|---|---|---|---|
| 11-Deoxycorticosterone | 11-dezoksikortikosteron | `11-deoxycorticosterone` | B121 |
| 7-Dehydrocholesterol | 7-dehidroholesterol | `7-dehydrocholesterol` | B538 |
| Acetylsalicylic Acid IgE | Acetilsalicilna kiselina IgE | `acetylsalicylic-acid-ige` | B015 |
| Acetylsalicylic Acid Level | Nivo acetilsalicilne kiseline | `acetylsalicylic-acid-level` | B499 |
| Acid-Fast Bacilli Direct Smear | Direktni preparat na bacil tuberkuloze | `acid-fast-bacilli-direct-smear` | B658 |
| ADAMTS13 Gene Analysis | Genetsko ispitivanje ADAMTS13 gena | `adamts13-gene-analysis` | B689 |
| Adenovirus PCR | Adenovirus PCR | `adenovirus-pcr` | B777 |
| Amino Acid Profile in 24h Urine | Profil aminokiselina u 24h urinu | `amino-acid-profile-in-24h-urine` | B547 |
| Amniotic Fluid Culture | Bakteriološki pregled plodove vode | `amniotic-fluid-culture` | M001 |
| Amoxicillin IgE | Amoksicilin IgE | `amoxicillin-ige` | B016 |
| AMPA1 Receptor Antibodies | Antitijela na AMPA1 receptor | `ampa1-receptor-antibodies` | B294 |
| AMPA2 Receptor Antibodies | Antitijela na AMPA2 receptor | `ampa2-receptor-antibodies` | B295 |
| Amylase Isoenzymes | Izoenzimi amilaze | `amylase-isoenzymes` | B376 |
| Anaplasma phagocytophilum IgG | Anaplasma phagocytophilum IgG | `anaplasma-phagocytophilum-igg` | B550 |
| Anaplasma phagocytophilum IgM | Anaplasma phagocytophilum IgM | `anaplasma-phagocytophilum-igm` | B551 |
| Anti-BP180 Antibodies | Anti-BP180 antitijela | `anti-bp180-antibodies` | B244 |
| Anti-BP230 Antibodies | Anti-BP230 antitijela | `anti-bp230-antibodies` | B245 |
| Anti-Desmoglein 1 Antibodies | Antitijela na dezmoglein 1 | `anti-desmoglein-1-antibodies` | B225 |
| Anti-Desmoglein 3 Antibodies | Antitijela na dezmoglein 3 | `anti-desmoglein-3-antibodies` | B226 |
| Anti-Epidermal Basement Membrane Antibodies | Antitijela na bazalnu membranu epidermisa | `anti-epidermal-basement-membrane-antibodies` | B227 |
| Anti-Epidermal Intercellular Substance Antibodies | Antitijela na interćelijsku supstancu epidermisa | `anti-epidermal-intercellular-substance-antibodies` | B251 |
| Anti-Histone Antibodies | Antihistonska antitijela | `anti-histone-antibodies` | B200 |
| Anti-MCV Antibodies | Antitijela na mutirani citrulinirani vimentin (anti-MCV) | `anti-mcv-antibodies` | B277 |
| Anti-Mi-2 Antibodies | Anti-Mi-2 antitijela | `anti-mi-2-antibodies` | B253 |
| Anti-N-Type Calcium Channel Antibodies | Antitijela na kalcijumske kanale N-tipa | `anti-n-type-calcium-channel-antibodies` | B202 |
| Anti-P/Q-Type Calcium Channel Antibodies | Antitijela na kalcijumske kanale P/Q-tipa | `anti-p-q-type-calcium-channel-antibodies` | B204 |
| Anti-PLA2R Antibodies | Antitijela na receptor fosfolipaze A2 (PLA2R) | `anti-pla2r-antibodies` | B211 |
| Anti-RNP-70 Antibodies | Anti-RNP-70 antitijela | `anti-rnp-70-antibodies` | B206 |
| Anti-Yo Antibodies | Anti-Yo antitijela | `anti-yo-antibodies` | B243 |
| Antimony in Blood | Antimon u krvi | `antimony-in-blood` | M106 |
| Antioxidant Capacity of Lipid-Soluble Substances | Antioksidativni kapacitet liposolubilnih supstanci | `antioxidant-capacity-of-lipid-soluble-substances` | B536 |
| APC Gene Mutations (Exon 15, Codons 1085-1160) | Mutacije u APC genu (15. egzon, kodoni 1085–1160) | `apc-gene-mutations-exon-15-codons-1085-1160` | B674 |
| APOB Gene Mutation (Familial Defective ApoB-100) | Mutacija APOB gena (familijarni defektni ApoB-100) | `apob-gene-mutation-familial-defective-apob-100` | B691 |
| Apolipoprotein E Genotyping | Genotipizacija apolipoproteina E | `apolipoprotein-e-genotyping` | B692 |
| Ascaris lumbricoides IgG | Ascaris lumbricoides IgG | `ascaris-lumbricoides-igg` | M117 |
| Aspergillus Total Antibodies | Aspergillus ukupna antitijela | `aspergillus-total-antibodies` | B568 |
| ATP7B Full Gene Sequencing | Mutacije u ATP7B genu — cijeli gen (Wilsonova bolest) | `atp7b-full-gene-sequencing` | B721 |
| ATP7B Known Familial Mutation Test | Mutacije u ATP7B genu — član porodice, poznata mutacija (Wilsonova bolest) | `atp7b-known-familial-mutation-test` | B722 |
| Babesia IgG | Babesia IgG | `babesia-igg` | B569 |
| Babesia IgM | Babesia IgM | `babesia-igm` | B570 |
| Bacterial Identification by MALDI-TOF MS | Identifikacija bakterija MALDI-TOF MS metodom | `bacterial-identification-by-maldi-tof-ms` | M067 |
| Bacterial Vaginosis Test | Test na bakterijsku vaginozu | `bacterial-vaginosis-test` | M004 |
| Barium in Serum | Barijum u serumu | `barium-in-serum` | M108 |
| Becker Muscular Dystrophy Genetic Test | Bekerova mišićna distrofija — genetsko ispitivanje | `becker-muscular-dystrophy-genetic-test` | B693 |
| Beta-Trace Protein | Beta-trace protein u sekretu | `beta-trace-protein` | B532 |
| Biliary Atresia Genetic Test | Bilijarna atrezija — genetsko ispitivanje | `biliary-atresia-genetic-test` | B694 |
| Biopsy Material Mycobacterial Culture (Lowenstein-Jensen) | Kultura biopsijskog materijala na mikobakterije (Löwenstein-Jensen) | `biopsy-material-mycobacterial-culture-lowenstein-jensen` | M006 |
| Borrelia burgdorferi IgG in CSF | Borrelia burgdorferi IgG u likvoru | `borrelia-burgdorferi-igg-in-csf` | B560 |
| Borrelia burgdorferi IgM in CSF | Borrelia burgdorferi IgM u likvoru | `borrelia-burgdorferi-igm-in-csf` | B562 |
| BRCA1 Full Gene Sequencing | Mutacije u BRCA1 genu (cijeli gen) | `brca1-full-gene-sequencing` | B675 |
| BRCA1 Known Familial Mutation Test | Mutacije u BRCA1 genu (član porodice – poznata mutacija) | `brca1-known-familial-mutation-test` | B676 |
| BRCA1 Partial Sequencing | Mutacije u BRCA1 genu (parcijalno sekvenciranje) | `brca1-partial-sequencing` | B677 |
| BRCA2 Full Gene Sequencing | Mutacije u BRCA2 genu (cijeli gen) | `brca2-full-gene-sequencing` | B678 |
| BRCA2 Known Familial Mutation Test | Mutacije u BRCA2 genu (član porodice – poznata mutacija) | `brca2-known-familial-mutation-test` | B679 |
| BRCA2 Partial Sequencing | Mutacije u BRCA2 genu (parcijalno sekvenciranje) | `brca2-partial-sequencing` | B680 |
| Bromazepam Level | Nivo bromazepama | `bromazepam-level` | B501 |
| Bronchial Aspirate Culture for Bacteria | Kultura bronhoaspirata na bakterije | `bronchial-aspirate-culture-for-bacteria` | M041 |
| Bronchial Aspirate Culture for Fungi | Kultura bronhoaspirata na gljivice | `bronchial-aspirate-culture-for-fungi` | M042 |
| BTNL2 Gene Mutations (Exons 5 and 6) | Mutacije u BTNL2 genu — 5. i 6. egzon (sarkoidoza) | `btnl2-gene-mutations-exons-5-and-6` | B724 |
| C1 Inhibitor Functional | Funkcionalni C1 inhibitor | `c1-inhibitor-functional` | B300 |
| Candida Antigen | Candida antigen | `candida-antigen` | B813 |
| Candida IgA Antibodies | Candida IgA antitijela | `candida-iga-antibodies` | B578 |
| Cannabinoids in Urine LC-MS | Kanabinoidi u urinu LC-MS | `cannabinoids-in-urine-lc-ms` | B454 |
| Carnitine in Urine | Karnitin u urinu | `carnitine-in-urine` | B344 |
| CASPR2 Antibodies | Antitijela na CASPR2 | `caspr2-antibodies` | B301 |
| Cefaclor IgE | Cefaklor IgE | `cefaclor-ige` | B036 |
| Cefalotin IgE | Cefalotin IgE | `cefalotin-ige` | B037 |
| Chlamydia psittaci IgA | Chlamydia psittaci IgA | `chlamydia-psittaci-iga` | B814 |
| Chlamydia psittaci IgG | Chlamydia psittaci IgG | `chlamydia-psittaci-igg` | B815 |
| Chlamydia psittaci IgM | Chlamydia psittaci IgM | `chlamydia-psittaci-igm` | B816 |
| Cholestasis Gene Panel (15 Genes) | Panel — holestaza (15 gena) | `cholestasis-gene-panel-15-genes` | B743 |
| Chromium in Serum | Hrom u serumu | `chromium-in-serum` | B429 |
| Chromium in Urine | Hrom u urinu | `chromium-in-urine` | B430 |
| Chromosomal Aberration Test | Test hromozomskih aberacija | `chromosomal-aberration-test` | B070 |
| CK Isoenzymes | Izoenzimi kreatin kinaze | `ck-isoenzymes` | B381 |
| Cladosporium herbarum IgE m2 | Plijesan Cladosporium herbarum IgE m2 | `cladosporium-herbarum-ige-m2` | B049 |
| Clonazepam Level | Nivo klonazepama | `clonazepam-level` | B502 |
| Clostridium difficile PCR | Clostridium difficile PCR | `clostridium-difficile-pcr` | B757 |
| Clozapine Level | Nivo klozapina | `clozapine-level` | B503 |
| Cobalt in Blood | Kobalt u krvi | `cobalt-in-blood` | B431 |
| Cocaine in Urine GC-MS | Kokain u urinu GC-MS | `cocaine-in-urine-gc-ms` | B455 |
| Codeine IgE | Kodein IgE | `codeine-ige` | B017 |
| Complexed PSA | Kompleksirani PSA | `complexed-psa` | B831 |
| Copeptin | Kopeptin | `copeptin` | B141 |
| Cotinine in Serum | Kotinin u serumu | `cotinine-in-serum` | B325 |
| Coxsackie Virus IgG in CSF | Koksaki virus IgG u likvoru | `coxsackie-virus-igg-in-csf` | B865 |
| Cryofibrinogen | Kriofibrinogen | `cryofibrinogen` | B191 |
| Cryptococcus neoformans PCR | Cryptococcus neoformans PCR | `cryptococcus-neoformans-pcr` | B758 |
| Cyclic AMP in Plasma | Ciklični AMP u plazmi | `cyclic-amp-in-plasma` | B139 |
| Cyclic AMP in Urine | Ciklični AMP u urinu | `cyclic-amp-in-urine` | B140 |
| CYP27A1 Gene Analysis | Genetsko ispitivanje CYP27A1 gena | `cyp27a1-gene-analysis` | B696 |
| Cytomegalovirus PCR Quantitative | Citomegalovirus PCR kvantitativni | `cytomegalovirus-pcr-quantitative` | B779 |
| DHEA | Dehidroepiandrosteron | `dhea` | B100 |
| DNA Kinship Test Additional Person | DNK test srodstva — dodatni član porodice | `dna-kinship-test-additional-person` | B710, B740 |
| Dog Dander IgE e5 | Pseća perut IgE e5 | `dog-dander-ige-e5` | B006, B012 |
| Doxycycline IgE | Doksiciklin IgE | `doxycycline-ige` | B019 |
| DSP Gene Mutations (Exon 24) | Mutacije u DSP genu — 24. egzon | `dsp-gene-mutations-exon-24` | B718 |
| Echinococcus Antigen | Echinococcus antigen | `echinococcus-antigen` | M118 |
| EGFR Gene Mutations (Exons 18-21) | Mutacije u EGFR genu (egzoni 18–21) | `egfr-gene-mutations-exons-18-21` | B681, B682 |
| Enterovirus Antibodies | Antitijela na enteroviruse (Coxsackie, ECHO, Polio) | `enterovirus-antibodies` | B594 |
| Erythrocyte Porphyrins | Porfirini u eritrocitima | `erythrocyte-porphyrins` | B545 |
| Exocrine Pancreas Antibodies | Antitijela na egzokrini pankreas | `exocrine-pancreas-antibodies` | B298 |
| Extended Antibiogram (E-test) | Prošireni antibiogram (E-test) | `extended-antibiogram-e-test` | M073 |
| F9 Gene Mutations and Deletions (Hemophilia B) | Mutacije i delecije u F9 genu (hemofilija B) | `f9-gene-mutations-and-deletions-hemophilia-b` | B719 |
| Facioscapulohumeral Muscular Dystrophy (FSHD1) Genetic Test | Facioskapulohumeralna mišićna distrofija (FSHD1) — genetsko ispitivanje | `facioscapulohumeral-muscular-dystrophy-fshd1-genetic-test` | B745 |
| FGF-23 | Faktor rasta fibroblasta 23 | `fgf-23` | B184 |
| FGFR2 Gene Mutations (Exon 7) | Mutacije u FGFR2 genu — 7. egzon (Apertov sindrom) | `fgfr2-gene-mutations-exon-7` | B727 |
| Flecainide Level | Nivo flekainida | `flecainide-level` | B508 |
| Food Intolerance Panel 95 Foods | Intolerancija na hranu 95 namirnica | `food-intolerance-panel-95-foods` | B057 |
| Food Mix fx5 | Miks namirnica fx5 | `food-mix-fx5` | B052 |
| Formic Acid in Urine | Mravlja kiselina u urinu | `formic-acid-in-urine` | B850 |
| Free Carnitine in Serum | Slobodni karnitin u serumu | `free-carnitine-in-serum` | B343 |
| Free Hemoglobin in Plasma | Slobodni hemoglobin u plazmi | `free-hemoglobin-in-plasma` | B182 |
| Free Protein S | Slobodni protein S | `free-protein-s` | B488 |
| Fructose in Semen | Fruktoza u spermi | `fructose-in-semen` | B328 |
| GABA-B Receptor Antibodies | Antitijela na GABA-B receptor | `gaba-b-receptor-antibodies` | B302 |
| Gallstone Analysis | Analiza kamena iz žučne kese | `gallstone-analysis` | B320 |
| Ganglioside Antibodies IgM | Antitijela na gangliozide IgM | `ganglioside-antibodies-igm` | B264 |
| Ganglioside IgG Antibodies | Antitijela na gangliozide IgG | `ganglioside-igg-antibodies` | B263 |
| GBA Gene Mutations (Exons 2, 9, 10 and 11) | Mutacije u GBA genu — egzoni 2, 9, 10 i 11 (Gošeova bolest) | `gba-gene-mutations-exons-2-9-10-and-11` | B728 |
| GD1a Antibodies IgG | Antitijela na gangliozid GD1a IgG | `gd1a-antibodies-igg` | B265 |
| GD1a Antibodies IgM | Antitijela na gangliozid GD1a IgM | `gd1a-antibodies-igm` | B266 |
| GD1b Antibodies IgG | Antitijela na gangliozid GD1b IgG | `gd1b-antibodies-igg` | B267 |
| GD1b Antibodies IgM | Antitijela na gangliozid GD1b IgM | `gd1b-antibodies-igm` | B268 |
| Genetic DNA Profile | Genetički DNK profil | `genetic-dna-profile` | B703 |
| Genotoxicity Test | Test genotoksičnosti | `genotoxicity-test` | B084 |
| Gentamicin IgE | Gentamicin IgE | `gentamicin-ige` | B020 |
| GLDH Glutamate Dehydrogenase | GLDH glutamat dehidrogenaza | `gldh-glutamate-dehydrogenase` | B383 |
| Glucose Challenge Test (O'Sullivan) | O'Sullivanov test (glukoza 1h nakon 50 g) | `glucose-challenge-test-o-sullivan` | B409 |
| Glucose in CSF | Glukoza u likvoru | `glucose-in-csf` | B533 |
| GM1 Antibodies Total | Ukupna antitijela na gangliozid GM1 | `gm1-antibodies-total` | B269 |
| GM2 Antibodies IgG | Antitijela na gangliozid GM2 IgG | `gm2-antibodies-igg` | B270 |
| GM2 Antibodies IgM | Antitijela na gangliozid GM2 IgM | `gm2-antibodies-igm` | B271 |
| Haloperidol Level | Nivo haloperidola | `haloperidol-level` | B509 |
| HAMA Human Anti-Mouse Antibodies | HAMA humana antimišja antitijela | `hama-human-anti-mouse-antibodies` | B274 |
| Helicobacter pylori PCR in Stool | Helicobacter pylori PCR u stolici | `helicobacter-pylori-pcr-in-stool` | B763 |
| Helicobacter pylori Urea Breath Test | Izdisajni urea test na Helicobacter pylori | `helicobacter-pylori-urea-breath-test` | B618 |
| Hereditary Disease Carrier Screening (400 Mutations) | Skrining na nasljedne bolesti (400 mutacija) | `hereditary-disease-carrier-screening-400-mutations` | B753 |
| Hereditary Thrombophilia Panel 9 Mutations | Panel nasljednih trombofilija 9 mutacija | `hereditary-thrombophilia-panel-9-mutations` | B805 |
| Herpes Simplex Virus 1/2 and Varicella Zoster Virus PCR | Herpes simplex virus 1/2 i varičela zoster virus PCR | `herpes-simplex-virus-1-2-and-varicella-zoster-virus-pcr` | B793 |
| HFE Known Familial Mutation Test | Mutacije u HFE genu — član porodice, poznata mutacija (hemohromatoza) | `hfe-known-familial-mutation-test` | B730 |
| HIF1A Gene Mutation (Sports Genetics) | Sportska analiza — mutacija u HIF1A genu | `hif1a-gene-mutation-sports-genetics` | B751 |
| HIV PCR RNA Qualitative | HIV PCR RNK kvalitativni | `hiv-pcr-rna-qualitative` | B789 |
| HLA-DRB1 Typing | HLA-DRB1 tipizacija | `hla-drb1-typing` | B707 |
| House Dust Mix hx2 | Miks kućne prašine hx2 | `house-dust-mix-hx2` | B014 |
| Hyaluronic Acid | Hijaluronska kiselina | `hyaluronic-acid` | B330 |
| IgE Antibodies to Bovine Insulin | IgE antitijela na goveđi insulin | `ige-antibodies-to-bovine-insulin` | B021 |
| IgE Antibodies to Porcine Insulin | IgE antitijela na svinjski insulin | `ige-antibodies-to-porcine-insulin` | B032 |
| IGF-2 | Insulinu-sličan faktor rasta 2 | `igf-2` | B148 |
| Imatinib Level | Nivo imatiniba | `imatinib-level` | B510 |
| Immunoelectrophoresis Protein CSF | Imunoelektroforeza proteina likvora | `immunoelectrophoresis-protein-csf` | B288 |
| Indomethacin IgE | Indometacin IgE | `indomethacin-ige` | B024 |
| Influenza A Virus IgA | Influenca A virus IgA | `influenza-a-virus-iga` | B613, B614 |
| Inhalant Allergen Screen sx1 | Skrining inhalacionih alergena sx1 | `inhalant-allergen-screen-sx1` | B055 |
| Intact Proinsulin | Intaktni proinsulin | `intact-proinsulin` | B153 |
| Interleukin-1 Alpha | Interleukin-1 alfa | `interleukin-1-alpha` | B309 |
| Interleukin-10 | Interleukin-10 | `interleukin-10` | B307 |
| Interleukin-8 | Interleukin-8 | `interleukin-8` | B311 |
| Iodine in Random Urine | Jod u slučajnom urinu | `iodine-in-random-urine` | B339 |
| JAG1 Gene Mutations (Exon 4) | Mutacije u JAG1 genu — 4. egzon (Alagilleov sindrom) | `jag1-gene-mutations-exon-4` | B717 |
| JC Virus PCR | JC virus PCR | `jc-virus-pcr` | B794, B876 |
| Karyotype from Abortion Material | Kariotip ploda iz abortivnog materijala | `karyotype-from-abortion-material` | B071, B072 |
| Karyotype from Amniotic Fluid | Kariotip iz plodove vode | `karyotype-from-amniotic-fluid` | B073, B074 |
| Karyotype from Amniotic Fluid Twins | Kariotip iz plodove vode (blizanci) | `karyotype-from-amniotic-fluid-twins` | B075 |
| Karyotype from Bone Marrow | Kariotip iz koštane srži | `karyotype-from-bone-marrow` | B078 |
| Karyotype from Chorionic Villi | Kariotip iz horionskih čupica | `karyotype-from-chorionic-villi` | B076, B077 |
| Karyotype from Cordocentesis Blood | Kariotip iz krvi dobijene kordocentezom | `karyotype-from-cordocentesis-blood` | B079 |
| Keto Acids | Keto kiseline | `keto-acids` | B819 |
| Ketones in Urine | Ketoni u urinu | `ketones-in-urine` | B064 |
| KIM-1 in Urine | KIM-1 u urinu | `kim-1-in-urine` | B306 |
| KRAS Mutations (Codons 12 and 13) | Mutacije u 12. i 13. kodonu KRAS gena | `kras-mutations-codons-12-and-13` | B672, B673 |
| Legionella pneumophila PCR | Legionella pneumophila PCR | `legionella-pneumophila-pcr` | B764 |
| Listeria monocytogenes IgG | Listeria monocytogenes IgG | `listeria-monocytogenes-igg` | B626 |
| Lochia Swab Culture Anaerobic | Bakteriološko ispitivanje brisa lohija - anaerobno | `lochia-swab-culture-anaerobic` | M023 |
| Lymphocyte Subpopulations | Subpopulacije limfocita | `lymphocyte-subpopulations` | B195 |
| Malaria Antibodies | Antitijela na malariju | `malaria-antibodies` | M119 |
| Maternity Test (Mother and Child) | Test materinstva — poređenje genetičkih profila (majka i dijete) | `maternity-test-mother-and-child` | B709 |
| MC4R Gene Mutations | Mutacije u MC4R genu (gojaznost) | `mc4r-gene-mutations` | B731 |
| MC4R Known Familial Mutation Test | Mutacije u MC4R genu — član porodice, poznata mutacija (gojaznost) | `mc4r-known-familial-mutation-test` | B732 |
| Methylmalonic Acid in Urine | Metilmalonska kiselina u urinu | `methylmalonic-acid-in-urine` | B884 |
| MODY 3 (HNF1A Gene) | MODY 3 — HNF1A (TCF1) gen | `mody-3-hnf1a-gene` | B715 |
| Mold Mix mx2 | Miks plijesni mx2 | `mold-mix-mx2` | B051 |
| Molybdenum in Blood | Molibden u krvi | `molybdenum-in-blood` | B434 |
| Molybdenum in Serum | Molibden u serumu | `molybdenum-in-serum` | B435 |
| Molybdenum in Urine | Molibden u urinu | `molybdenum-in-urine` | B436 |
| Mycobacterium leprae PCR | Mycobacterium leprae PCR | `mycobacterium-leprae-pcr` | B765 |
| Mycobacterium tuberculosis Culture (Aspirate) | Kultura aspirata na Mycobacterium tuberculosis | `mycobacterium-tuberculosis-culture-aspirate` | B657 |
| Mycobacterium tuberculosis Culture (Sputum) | Kultura sputuma na Mycobacterium tuberculosis | `mycobacterium-tuberculosis-culture-sputum` | B662 |
| Mycobacterium tuberculosis Culture (Urine) | Kultura urina na Mycobacterium tuberculosis | `mycobacterium-tuberculosis-culture-urine` | B663 |
| Mycobacterium tuberculosis in Pleural Fluid | Mycobacterium tuberculosis u pleuralnom punktatu | `mycobacterium-tuberculosis-in-pleural-fluid` | M072 |
| Mycophenolic Acid Level | Nivo mikofenolne kiseline | `mycophenolic-acid-level` | B513 |
| Mycoplasma pneumoniae PCR | Mycoplasma pneumoniae PCR | `mycoplasma-pneumoniae-pcr` | B768 |
| Myoglobin in Urine | Mioglobin u urinu | `myoglobin-in-urine` | B365 |
| N-Acetyl-Beta-Glucosaminidase NAG | N-acetil-beta-glukozaminidaza NAG | `n-acetyl-beta-glucosaminidase-nag` | B321 |
| N-Desmethylclozapine Level | Nivo N-dezmetilklozapina | `n-desmethylclozapine-level` | B505 |
| Neopterin in Serum | Neopterin u serumu | `neopterin-in-serum` | B304 |
| Nickel in Blood | Nikal u krvi | `nickel-in-blood` | B437 |
| NRAS Mutations (Codons 12, 13 and 61) | Mutacije u NRAS genu (kodoni 12, 13 i 61) | `nras-mutations-codons-12-13-and-61` | B683, B684 |
| Nutrigenetic Lipid Metabolism Panel (9 Mutations) | Nutrigenetika — metabolizam lipida, triglicerida i masnih kiselina (9 mutacija) | `nutrigenetic-lipid-metabolism-panel-9-mutations` | B738 |
| Paliperidone Level | Nivo paliperidona | `paliperidone-level` | B514 |
| Pancreatic Elastase 1 in Serum | Pankreasna elastaza 1 u serumu | `pancreatic-elastase-1-in-serum` | B396 |
| Parvovirus B19 PCR | Parvovirus B19 PCR | `parvovirus-b19-pcr` | B792 |
| Peritoneal Dialysis Catheter Exit Site Swab Culture | Bakteriološki pregled brisa izlazišta katetera za peritonealnu dijalizu | `peritoneal-dialysis-catheter-exit-site-swab-culture` | M005 |
| Phenacetin IgE | Fenacetin IgE | `phenacetin-ige` | B028 |
| Placental Alkaline Phosphatase | Placentalna alkalna fosfataza | `placental-alkaline-phosphatase` | B837 |
| Plasminogen | Plazminogen | `plasminogen` | B485 |
| Pneumocystis jirovecii PCR | Pneumocystis jirovecii PCR | `pneumocystis-jirovecii-pcr` | B770, B771 |
| Poliovirus Antibodies | Antitijela na poliovirus | `poliovirus-antibodies` | B877 |
| Potassium in Erythrocytes | Kalijum u eritrocitima | `potassium-in-erythrocytes` | B340 |
| PROCR Gene Haplotype | Haplotip PROCR gena (endotelni receptor proteina C) | `procr-gene-haplotype` | B797 |
| Protein Creatinine Ratio | Odnos proteini/kreatinin u urinu | `protein-creatinine-ratio` | B366 |
| Protein in Dialysate | Proteini u dijalizatu | `protein-in-dialysate` | B368 |
| Quantitative Aspirate Culture | Kvantitativna kultura aspirata | `quantitative-aspirate-culture` | M003 |
| Risperidone Level | Nivo risperidona | `risperidone-level` | B515 |
| Rivaroxaban Level | Nivo rivaroksabana | `rivaroxaban-level` | B516 |
| RSV Antigen in BAL | RSV antigen u bronhoalveolarnom lavatu | `rsv-antigen-in-bal` | B640 |
| Salivary Stone Analysis | Analiza kamena iz pljuvačne žlijezde | `salivary-stone-analysis` | B318 |
| Seafood Mix fx2 | Miks morskih plodova fx2 | `seafood-mix-fx2` | B053 |
| Septin 9 (mSEPT9) Methylation Test | Metilirani Septin 9 (mSEPT9) — skrining kolorektalnog karcinoma iz krvi | `septin-9-msept9-methylation-test` | B668 |
| Sertraline Level | Nivo sertralina | `sertraline-level` | B517 |
| Sex Chromosome Aneuploidy PCR (X, Y) | Aneuploidije polnih hromozoma X i Y — PCR | `sex-chromosome-aneuploidy-pcr-x-y` | B747 |
| SLC2A1 Gene Mutations (GLUT1 Deficiency) | Mutacije u SLC2A1 genu (deficijencija GLUT1) | `slc2a1-gene-mutations-glut1-deficiency` | B734 |
| Sodium in Erythrocytes | Natrijum u eritrocitima | `sodium-in-erythrocytes` | B347 |
| Sotalol Level | Nivo sotalola | `sotalol-level` | B518 |
| Spinocerebellar Ataxia Type 1 (SCA1) | Spinocerebelarna ataksija tip 1 (SCA1) | `spinocerebellar-ataxia-type-1-sca1` | B750 |
| Sports Genetics Panel (HIF1A, ACTN3, ACE) | Sportski paket — HIF1A, ACTN3 i ACE geni | `sports-genetics-panel-hif1a-actn3-ace` | B752 |
| SPR Gene Mutations (Sepiapterin Reductase Deficiency) | Mutacije u SPR genu (deficijencija sepiapterin reduktaze) | `spr-gene-mutations-sepiapterin-reductase-deficiency` | B735 |
| Sulfamethoxazole IgE | Sulfametoksazol IgE | `sulfamethoxazole-ige` | B031 |
| Superoxide Dismutase | Superoksid dismutaza | `superoxide-dismutase` | B537 |
| Synovial Fluid Direct Microscopic Preparation | Direktni mikroskopski preparat sinovijalne tečnosti | `synovial-fluid-direct-microscopic-preparation` | M112 |
| Targeted Mutation Analysis on Request (1 Sequence) | Detekcija mutacija po zahtjevu (1 sekvenca) | `targeted-mutation-analysis-on-request-1-sequence` | B698 |
| Tetrachloroethylene PER | Tetrahloretilen PER | `tetrachloroethylene-per` | B069 |
| Thymidine Kinase | Timidin kinaza | `thymidine-kinase` | B842 |
| TMPRSS6 Gene Mutations (IRIDA) | Mutacije u TMPRSS6 genu (IRIDA — sideropenijska anemija rezistentna na željezo) | `tmprss6-gene-mutations-irida` | B737 |
| TP53 Gene Mutations (Exons 5-8) | Mutacije u TP53 genu (egzoni 5–8) | `tp53-gene-mutations-exons-5-8` | B685 |
| Treponema pallidum IgG Western Blot | Treponema pallidum IgG antitijela (Western Blot) | `treponema-pallidum-igg-western-blot` | B646 |
| Treponema pallidum PCR | Treponema pallidum PCR | `treponema-pallidum-pcr` | B773 |
| Trimethoprim IgE | Trimetoprim IgE | `trimethoprim-ige` | B033 |
| Tropheryma whipplei PCR | Tropheryma whipplei PCR | `tropheryma-whipplei-pcr` | B775 |
| Trypsin in Serum | Tripsin u serumu | `trypsin-in-serum` | B354 |
| Urethral Swab Culture Anaerobic | Bakteriološko ispitivanje uretralnog brisa - anaerobno | `urethral-swab-culture-anaerobic` | M090 |
| Urethral Swab Microscopy for Gardnerella | Direktni mikroskopski preparat uretralnog brisa na Gardnerella | `urethral-swab-microscopy-for-gardnerella` | M087 |
| Urine Specific Gravity | Specifična težina urina | `urine-specific-gravity` | B856 |
| Vaginal Swab Microscopy for Gardnerella vaginalis | Direktni mikroskopski preparat vaginalnog brisa na Gardnerella vaginalis | `vaginal-swab-microscopy-for-gardnerella-vaginalis` | M104 |
| Varicella Zoster Virus PCR | Varičela zoster virus PCR | `varicella-zoster-virus-pcr` | B796 |
| VGKC Potassium Channel Antibodies | Antitijela na kalijumove kanale VGKC | `vgkc-potassium-channel-antibodies` | B297 |
| Yersinia IgA Antibodies | Yersinia IgA antitijela | `yersinia-iga-antibodies` | B654 |
| Yersinia IgM Antibodies | Yersinia IgM antitijela | `yersinia-igm-antibodies` | B656 |
| Zinc in Semen | Cink u spermi | `zinc-in-semen` | B446 |

## 8. Сопоставлено с существующими записями (633)

| ID | В прайсе | € | Запись каталога |
|---|---|---|---|
| B001 | (f77) IgE-RAST Beta-Lactoglobulin (Mleko) | 16 | `beta-lactoglobulin-ige-f77` — Beta-laktoglobulin IgE f77 |
| B003 | d1 (Dermatophagoides pteronyssinus-Kućne grinje) | 16 | `house-dust-mite-ige-h2` — Grinja kućne prašine IgE h2 |
| B004 | Diaminooksidaza (DAO) | 13 | `diamine-oxidase-dao-histamine` — Diamin oksidaza DAO histamin |
| B005 | e1 (Perut mačke) | 16 | `cat-epithelium-and-hair-ige-e1` — Mačji epitel i dlaka IgE e1 |
| B007 | ECP (Eosinofilni Katjonski Protein) | 31 | `ecp-eosinophil-cationic-protein` — ECP eozinofilni katjonski protein |
| B008 | f76 (IgE-RAST Alfa-Lactalbumin (Mleko)) | 16 | `alpha-lactalbumin-ige-f76` — Alfa-laktalbumin IgE f76 |
| B009 | g12 (Kultivisana raž) | 16 | `rye-pollen-ige-g14` — Raženi polen IgE g14 |
| B010 | g6 (Popino prase) | 16 | `timothy-ige-g2` — Timotejeva trava IgE g2 |
| B011 | IgE | 10 | `ige` — Imunoglobulin E |
| B018 | IgE-RAST Diclofenac | 15 | `diclofenac-ige-c281` — Diklofenak IgE c281 |
| B022 | IgE-RAST Humani insulin | 15 | `ige-antibodies-to-human-insulin` — IgE antitijela na humani insulin |
| B023 | IgE-RAST Ibuprofen | 15 | `ibuprofen-ige-c286` — Ibuprofen IgE c286 |
| B025 | IgE-RAST Paracetamol | 15 | `paracetamol-acetaminophen-ige-c2` — Paracetamol acetaminofen IgE c2 |
| B026 | IgE-RAST Penicilin G | 15 | `penicilloyl-g-ige-c1` — Peniciloil G IgE c1 |
| B027 | IgE-RAST Penicilin V | 15 | `penicilloyl-v-ige-c2` — Peniciloil V IgE c2 |
| B029 | IgE-RAST pšenično brašno (f4) | 19 | `wheat-flour-ige-f4` — Pšenično brašno IgE f4 |
| B030 | IgE-RAST soja (f14) | 19 | `soy-ige-f14` — Soja IgE f14 |
| B035 | IgE-RAST-Belance jajeta | 15 | `egg-white-ige-e1` — Belance IgE e1 |
| B038 | IgE-RAST-Kazein | 15 | `casein-ige-f78` — Kazein IgE f78 |
| B039 | IgE-RAST-Kikiriki | 15 | `peanut-ige-f13` — Kikiriki IgE f13 |
| B040 | IgE-RAST-Kravlje mleko (F2) | 15 | `milk-ige-f2` — Mlijeko IgE f2 |
| B041 | IgE-RAST-Lignje | 16 | `squid-ige-f258` — Lignja IgE f258 |
| B042 | IgE-RAST-Osa (i3) | 15 | `wasp-ige-i3` — Osa IgE i3 |
| B043 | IgE-RAST-Otrov stršljena | 15 | `hornet-ige-i75` — Stršljen IgE i75 |
| B044 | IgE-RAST-Pčelinji otrov (i1) | 15 | `bee-ige-i1` — Pčela IgE i1 |
| B045 | IgE-RAST-Pistaći | 15 | `pistachio-ige-f203` — Pistaći IgE f203 |
| B046 | IgE-RAST-Riba | 15 | `cod-ige-f3` — Bakalar IgE f3 |
| B047 | IgE-RAST-Tunjevina | 16 | `tuna-ige-f40` — Tuna IgE f40 |
| B050 | Skrining alergena na Aspergillus(mx4) | 49 | `mold-mix-mx4` — Miks plesni mx4 |
| B056 | t3 (Srebrna breza) | 16 | `birch-ige-t3` — Breza IgE t3 |
| B058 | Triptaza | 13 | `tryptase` — Triptaza |
| B059 | w6 (Pelin) | 16 | `mugwort-ige-w6` — Pelen IgE w6 |
| B061 | Beta Amiloid | 60 | `beta-amyloid` — Beta-amiloid |
| B066 | Masne kiseline, "very long chain" (C22-C26) | 60 | `very-long-chain-fatty-acids-c22-c26` — Masne kiseline vrlo dugog lanca C22-C26 |
| B067 | Mokraćna kiselina u serumu | 3 | `uric-acid` — Mokraćna kiselina |
| B068 | PTHrP | 55 | `pthrp` — PTHrP paratireoidni hormon-vezani protein |
| B080 | Kariotip iz periferne krvi | 120 | `karyotype-from-peripheral-blood` — Kariotip iz periferne krvi |
| B081 | Kariotip iz periferne krvi (oba roditelja) | 120 | `karyotype-from-peripheral-blood` — Kariotip iz periferne krvi |
| B083 | Mikronukleus test | 50 | `micronucleus-test` — Mikronu test |
| B096 | Papanikolau | 15 | `pap-papanicolaou-test` — PAP test |
| B097 | Spermogram | 20 | `spermogram` — Spermogram |
| B098 | Anti Mullerian Hormon (AMH) | 29 | `anti-mullerian-hormone` — Anti-Milerov hormon |
| B099 | Beta HCG | 14 | `beta-hcg` — Beta HCG |
| B101 | DHEA-S (Dehidroepiandrosteron sulfat) | 9 | `dhea-s` — Dehidroepiandrosteron sulfat |
| B102 | Dihidrotestosteron (DHT) | 20 | `dihydrotestosterone` — Dihidrotestosteron |
| B103 | Estradiol | 8 | `estradiol` — Estradiol |
| B104 | FBETA HCG | 14 | `free-beta-hcg` — Slobodni beta HCG |
| B105 | Free testosteron | 8 | `free-testosterone` — Slobodni testosteron |
| B106 | FSH | 8 | `fsh` — Folikulostimulirajući hormon |
| B107 | Inhibin A | 35 | `inhibin-a` — Inhibin A |
| B108 | Inhibin B | 35 | `inhibin-b` — Inhibin B |
| B109 | LH | 8 | `lh` — Luteinizirajući hormon |
| B110 | Profil Makroprolaktina | 19 | `macroprolactin` — Makroprolaktin |
| B111 | Progesteron | 8 | `progesterone` — Progesteron |
| B112 | Progesteron (pg/ml) | 8 | `progesterone` — Progesteron |
| B113 | Prolaktin | 8 | `prolactin` — Prolaktin |
| B115 | SHBG | 8 | `shbg` — Globulin koji vezuje polne hormone |
| B116 | Testosteron | 8 | `testosterone` — Testosteron |
| B117 | ACTH (Adenokortikotropni hormon) | 13 | `acth` — Adrenokortikotropni hormon |
| B118 | Hormon rasta | 13 | `growth-hormone` — Hormon rasta |
| B119 | IGF1 (Somatomedin C) | 10 | `igf-1` — Insulinu-sličan faktor rasta 1 |
| B120 | 1,25-Dihydroxy-Vitamin D | 49 | `vitamin-125-oh2-d` — Vitamin 1,25 OH2 D |
| B122 | 3-Metoksi Tiramin | 39 | `3-methoxytyramine-in-urine` — 3-metoksitiramin u urinu |
| B123 | Aldosteron -18-glucuronid u urinu | 12 | `aldosterone-in-24h-urine` — Aldosteron u 24h urinu |
| B124 | Aldosteron u serumu | 12 | `aldosterone` — Aldosteron |
| B126 | Androstendion | 13 | `androstenedione` — Androstendion |
| B127 | Kateholamini - Plazma | 35 | `catecholamines-in-plasma` — Kateholamini u plazmi |
| B128 | Kateholamini (urin) | 35 | `catecholamines-in-24h-urine` — Kateholamini u 24h urinu |
| B130 | Kortizol u serumu | 10 | `cortisol` — Kortizol |
| B131 | Metanefrin (urin 24h) | 23 | `metanephrine-in-urine` — Metanefrin u urinu |
| B132 | Normetanefrin u urinu (24h) | 23 | `free-normetanephrine-in-24h-urine` — Slobodni normetanefrin u 24h urinu |
| B133 | Renin-direktni (Koncentracija) | 15 | `renin` — Renin |
| B134 | Slobodni metanefrin-Plazma | 39 | `free-metanephrine-in-plasma` — Slobodni metanefrin u plazmi |
| B135 | Slobodni normetanefrin-Plazma | 39 | `normetanephrine-in-plasma` — Normetanefrin u plazmi |
| B136 | VMA (Vanil mandelična kiselina) | 11 | `vma` — Vanilmandelična kiselina |
| B137 | 17-OH progesteron | 10 | `17-hydroxyprogesterone` — 17-hidroksiprogesteron |
| B138 | ADH (Antidiuretični hormon, Vazopresin) | 30 | `adh-antidiuretic-hormone` — ADH antidiuretski hormon |
| B142 | C-Peptid | 12 | `c-peptide` — C-peptid |
| B143 | EGF (Epidermalni faktor rasta) | 18 | `egf-epidermal-growth-factor` — EGF faktor epidermalnog rasta |
| B144 | Estron (E1) | 30 | `estrone` — Estron |
| B145 | Gastrin | 12 | `gastrin` — Gastrin |
| B146 | Glukagon | 18 | `glucagon` — Glukagon |
| B147 | Hromogranin A (CgA) | 30 | `chromogranin-a` — Hromogranin A |
| B149 | IGFBP-3 | 10 | `igfbp-3` — IGFBP-3 |
| B150 | Insulin | 12 | `insulin` — Insulin |
| B151 | LEPTIN | 10 | `leptin` — Leptin |
| B152 | NT-proBNP | 32 | `nt-probnp` — NT-proBNP |
| B154 | PTH | 13 | `pth` — Paratireoidni hormon |
| B155 | Serotonin (serum) | 32 | `serotonin` — Serotonin |
| B156 | Serotonin u urinu | 32 | `serotonin-in-24h-urine` — Serotonin u 24h urinu |
| B157 | Vazoaktivni intestinalni peptid (VIP) | 50 | `vasoactive-intestinal-polypeptide` — Vazoaktivni intestinalni polipeptid |
| B158 | FT3 | 10 | `free-t3` — Slobodni T3 |
| B159 | FT4 | 10 | `free-t4` — Slobodni T4 |
| B160 | T3 | 5 | `t3` — Trijodtironin |
| B161 | T4 | 5 | `t4` — Tiroksin |
| B162 | TSH | 5 | `tsh` — Tireostimulirajući hormon |
| B163 | Calprotectin | 38 | `calprotectin` — Kalprotektin |
| B164 | Helicobacter Pylori antigen u fecesu | 12 | `helicobacter-pylori-antigen-in-feces` — Helicobacter pylori antigen u fecesu |
| B165 | Laktoferin u fecesu | 31 | `lactoferrin` — Laktoferin |
| B166 | Okultno krvarenje | 7 | `fecal-occult-blood` — Okultno krvarenje u stolici |
| B167 | Pankreasna Elastaza 1 (Feces) | 31 | `pancreatic-elastase-in-stool` — Pankreasna elastaza u stolici |
| B168 | Elektroforeza Hemoglobina | 23 | `hemoglobin-electrophoresis` — Elektroforeza hemoglobina |
| B169 | Eozinofili u komori | 2 | `blood-eosinophils` — Eozinofili u krvi |
| B170 | Eozinofili u razmazu iz nosa | 2 | `nasal-eosinophils` — Eozinofili u nosu |
| B171 | Eritrociti | 2 | `erythrocytes` — Eritrociti |
| B172 | Hematokrit | 2 | `hematocrit` — Hematokrit |
| B173 | Hemoglobin | 2 | `hemoglobin` — Hemoglobin |
| B174 | Kompletna krvna slika | 5 | `complete-blood-count` — Kompletna krvna slika |
| B175 | Leukociti | 1 | `leukocytes` — Leukociti |
| B176 | Leukocitna formula | 2 | `leukocyte-formula` — Leukocitna formula |
| B177 | Methemoglobin | 10 | `methemoglobin` — Methemoglobin |
| B178 | Retikulociti | 1.5 | `reticulocytes` — Retikulociti |
| B180 | Sedimentacija eritrocita | 1 | `erythrocyte-sedimentation-rate` — Brzina sedimentacije eritrocita |
| B183 | Trombociti | 1 | `platelets` — Trombociti |
| B185 | Free Estriol | 10 | `free-estriol` — Slobodni estriol |
| B186 | Reverzni T3 | 40 | `reverse-t3` — Reverzni T3 |
| B187 | Coombs-ov test - direktan | 14 | `direct-coombs-test` — Direktan Kumbsov test |
| B188 | Coombs-ov test - indirektan | 14 | `indirect-coombs-test` — Indirektni Kumbsov test |
| B189 | Helper - T limfociti (CD4+) | 33 | `t-lymphocytes-cd4` — T-limfociti CD4+ |
| B190 | Hladni aglutinini | 4 | `cold-agglutinins` — Hladni aglutinini |
| B192 | Krioglobulini | 4 | `cryoglobulins` — Krioglobulini |
| B193 | Krvna Grupa | 13 | `blood-group-and-rh-factor` — Krvna grupa i Rh faktor |
| B196 | ANCA Profil | 68 | `anca-profile` — ANCA profil |
| B197 | Anti ds-DNA Skrining | 13 | `dsdna-antibodies` — dsDNA antitijela |
| B198 | Anti-Fosfolipid Skrining IgG | 13 | `phospholipid-igg-antibodies` — Fosfolipid IgG antitijela |
| B199 | Anti-Fosfolipid Skrining IgM | 13 | `phospholipid-igm-antibodies` — Fosfolipid IgM antitijela |
| B201 | Anti-MOG Antitela | 10 | `mog-myelin-oligodendrocyte-glycoprotein` — MOG mijelin oligodendrocit glikoprotein |
| B203 | Anti-Nukleozomalna IgG At | 11 | `nucleosomal-antibodies` — Nukleozomska antitijela |
| B205 | Anti-RNP/Sm | 11 | `anti-rnp-sm-antibodies` — Anti-RNP/Sm antitijela |
| B207 | Antitela prema Cardiolipinu (IgG) | 13 | `anticardiolipin-igg` — Antikardiolipin IgG |
| B208 | Antitela prema Cardiolipinu (IgM) | 13 | `anticardiolipin-igm` — Antikardiolipin IgM |
| B209 | Antitela prema Glijadinu (IgA) | 13 | `gliadin-iga-antibodies` — Glijadin IgA antitijela |
| B210 | Antitela prema Glijadinu (IgG) | 13 | `gliadin-igg-antibodies` — Glijadin IgG antitijela |
| B212 | Antitela prema solubilnom antigenu jetre (SLE/LP autoantitela) | 30 | `anti-sla-lp-antibodies` — Anti-SLA LP antitijela |
| B213 | Antitela prema tkivnoj transglutaminazi (IgA) | 13 | `transglutaminase-iga-antibodies` — Transglutaminaza IgA antitijela |
| B214 | Antitela prema tkivnoj transglutaminazi (IgG) | 13 | `transglutaminase-igg-antibodies` — Transglutaminaza IgG antitijela |
| B215 | Antitela prema β2-Glikoproteinu I (IgG) | 13 | `beta-2-glycoprotein-i-igg` — Beta-2 glikoprotein I IgG |
| B216 | Antitela prema β2-Glikoproteinu I (IgM) | 13 | `beta-2-glycoprotein-i-igm` — Beta-2 glikoprotein I IgM |
| B217 | ASCA IgA | 12 | `asca-iga` — ASCA IgA |
| B218 | ASCA IgG | 12 | `asca-igg` — ASCA IgG |
| B219 | Auto Antitela na adrenalni korteks | 12 | `adrenal-antibodies` — Antitijela na nadbubrežnu žlijezdu |
| B220 | Auto antitela prema intrinsic faktoru | 12 | `intrinsic-factor-antibodies` — Antitijela na intrinzički faktor |
| B221 | Auto antitela prema ribozomima | 18 | `anti-ribosomal-p-antibodies` — Antitijela na ribozomalni P protein |
| B222 | Auto-antitela (IgG) prema antigenima nukleusa (ANA) | 12 | `ana-antinuclear-antibodies` — ANA antinuklearna antitijela |
| B223 | Auto-antitela (IgG) prema bazalnoj glomeluralnoj membrani (GBM) | 12 | `gbm-antibodies` — GBM antitijela na bazalnu membranu glomerula |
| B224 | Auto-antitela (IgG) prema centromeri B | 12 | `centromere-protein-b-antibodies` — Centromer protein B antitijela |
| B228 | Auto-antitela (IgG) prema glatkoj muskulaturi (ASMA) | 20 | `anti-smooth-muscle-antibodies-asma` — Antitijela na glatke mišiće ASMA |
| B229 | Auto-antitela (IgG) prema glutamat-dekarboksilazi (GAD) | 24 | `anti-gad-antibodies` — Anti-GAD antitijela |
| B230 | Auto-antitela (IgG) prema Hu | 15 | `anti-hu-antibodies` — Anti-Hu antitijela |
| B231 | Auto-antitela (IgG) prema Jo-1 | 13 | `anti-jo-1-antibodies` — Anti-Jo-1 antitijela |
| B232 | Auto-antitela (IgG) prema mijeloperoksidazi (MPO, p-ANCA) | 13 | `anca-p-anti-mpo` — ANCA-P Anti-MPO |
| B233 | Auto-antitela (IgG) prema parijetalnim ćelijama | 12 | `anti-parietal-cell-antibodies-apa` — Antitijela na parijetalne ćelije APA |
| B234 | Auto-antitela (IgG) prema Proteinazi 3 (PR3, c-ANCA) | 12 | `anca-c-anti-pr3` — ANCA-C Anti-PR3 |
| B235 | Auto-antitela (IgG) prema receptorima za NMDAR (CSF) | 15 | `nmdar-antibodies-in-csf` — NMDAR antitijela u likvoru |
| B236 | Auto-antitela (IgG) prema receptorima za NMDAR (Serum) | 15 | `nmdar-antibodies-in-serum` — NMDAR antitijela u serumu |
| B237 | Auto-antitela (IgG) prema Scl 70 | 12 | `anti-scl-70-antibodies` — Anti-Scl-70 antitijela |
| B238 | Auto-antitela (IgG) prema Sm | 14 | `anti-sm-antibodies` — Anti-SM antitijela |
| B239 | Auto-antitela (IgG) prema SS-A (Rӧ) | 14 | `anti-ro-ssa-antibodies` — Anti-Ro SSA antitijela |
| B240 | Auto-antitela (IgG) prema SS-B (La) | 14 | `anti-la-ssb-antibodies` — Anti-La SSB antitijela |
| B241 | Auto-antitela (IgG) prema tireoglobulinu (ATG) | 12 | `anti-thyroglobulin-antibodies` — Antitijela na tireoglobulin |
| B242 | Auto-antitela (IgG) prema TPO (AMC) | 12 | `anti-tpo` — Antitijela na tireoperoksidazu |
| B247 | Auto-antitela prema mitohondrijama (AMA-M2) | 16 | `ama-antimitochondrial-m2` — AMA antimitohondrijska M2 |
| B248 | Autoantitela prema Aquaporinu 4 | 23 | `aquaporin-4-antibodies` — Akvaporin-4 antitijela |
| B249 | Auto-antitela prema CCP/RA (IgG) | 15 | `anti-ccp-antibodies` — Anti-CCP antitijela |
| B250 | Auto-antitela prema ds-DNA (IgG) | 13 | `dsdna-igg-antibodies` — dsDNA IgG antitijela |
| B252 | Auto-antitela prema insulinu (IAA) | 13 | `anti-insulin-antibodies` — Antitijela na insulin |
| B254 | Auto-antitela prema mikrozomima jetre i bubrega (LKM1) | 10 | `lkm-1-antibodies` — LKM-1 antitijela |
| B255 | Auto-antitela prema ovarijumu (steroidnim ćelijama) | 10 | `ovarian-antibodies` — Antitijela na jajnike |
| B256 | Auto-antitela prema pankreasnim ostrvcima (ICA) | 26 | `ica-antibodies` — ICA antitijela na ostrvske ćelije |
| B257 | Auto-antitela prema receptorima na TSH | 18 | `anti-tshr` — Antitijela na TSH receptor |
| B293 | (Tiroid stimulišućii imunoglobulini) | 18 | `anti-tshr` — Antitijela na TSH receptor |
| B258 | Auto-antitela prema receptorima za acetilholin | 39 | `acetylcholine-receptor-antibodies` — Antitijela na acetilholinski receptor |
| B259 | Auto-antitela prema retikulinu | 15 | `reticulin-antibodies` — Retikulinska antitijela |
| B260 | Auto-antitela prema spermatozoidima (ASA) | 10 | `spermatozoa-antibodies-asa` — Antitijela na spermatozoide ASA |
| B261 | Auto-antitela prema tirozinfosfatazi (IA-2) | 18 | `ia-2-antibodies` — IA-2 antitijela |
| B262 | ENA skrining | 15 | `ena-screening` — ENA skrining |
| B272 | GQ1b-autoantitela IgG | 30 | `gq1b-antibodies-igg` — Antitijela na gangliozid GQ1b IgG |
| B273 | GQ1b-autoantitela IgM | 30 | `gq1b-antibodies-igm` — Antitijela na gangliozid GQ1b IgM |
| B275 | Imuni kompleksi - PEG | 10 | `immune-complexes-peg` — Imuni kompleksi PEG |
| B276 | MuSK Auto antitela | 15 | `musk-antibodies` — MUSK antitijela |
| B279 | Anti-C 1q | 10 | `anti-c1q-antibodies` — Anti-C1q antitijela |
| B280 | Anti-trombocitna At | 20 | `platelet-iga-igm-igg-antibodies` — Trombocitna IgA IgM IgG antitijela |
| B281 | C3c | 8 | `c3-complement` — C3 komplement |
| B282 | C4 | 8 | `c4-complement` — C4 komplement |
| B283 | CH-100 (Totalna hemolitička aktivnost komplementa) | 9 | `total-complement-ch50` — Ukupni komplement CH50 |
| B284 | IgA | 10 | `iga` — Imunoglobulin A |
| B285 | IgG | 10 | `igg` — Imunoglobulin G |
| B286 | IgG subklase (IgG 1,2,3,4) | 22 | `igg-subclasses` — IgG podklase |
| B287 | IgM | 10 | `igm` — Imunoglobulin M |
| B289 | Imunoelektroforeza u serumu | 37 | `immunoelectrophoresis-protein-serum` — Imunoelektroforeza proteina seruma |
| B290 | Imunoelektroforeza u serumu | 37 | `immunoelectrophoresis-protein-serum` — Imunoelektroforeza proteina seruma |
| B291 | Imunoelektroforeza u urinu | 28 | `immunoelectrophoresis-protein-urine` — Imunoelektroforeza proteina urina |
| B292 | RF | 4 | `rheumatoid-factor` — Reumatoidni faktor |
| B296 | Auto antitela prema antigenime jetre | 170 | `liver-autoantibody-panel-13-antigens` — Panel autoantitijela jetre (AMA-M2, M2-3E, Sp100, PML, gp210, LKM-1, LC-1, SLA/LP, SS-A native, Ro-52, Scl-70, Centromer A, Centromer B) |
| B299 | C1-Esterase-Inhibitor (koncentracija) | 17 | `c1-inhibitor` — C1 inhibitor |
| B303 | HLA-C | 230 | `hla-c-typing` — HLA-C tipizacija |
| B305 | NGAL u urinu | 51 | `ngal-in-urine` — NGAL u urinu |
| B308 | IL-6 | 31 | `interleukin-6` — Interleukin-6 |
| B310 | Interleukin 1-beta | 48 | `interleukin-1-beta` — Interleukin-1 beta |
| B312 | TNF-Alfa | 27 | `tnf-alpha-tumor-necrosis-factor` — TNF-alfa faktor nekroze tumora |
| B313 | ACE (Angiotenzin konverting enzim) | 16 | `ace` — Angiotenzin konvertujući enzim |
| B314 | Aldolaza (Serum) | 8 | `aldolase` — Aldolaza |
| B315 | Aluminijum u serumu | 22 | `aluminum` — Aluminijum |
| B316 | Amonijum (plazma) | 11 | `ammonia-nh3` — Amonijak NH3 |
| B317 | Analiza kamena iz bubrega | 13 | `kidney-stone-analysis` — Analiza kamena iz bubrega |
| B319 | Analiza kamena iz urina | 13 | `kidney-stone-analysis` — Analiza kamena iz bubrega |
| B322 | Bikarbonati | 3 | `bicarbonates` — Bikarbonati |
| B323 | Ceruloplazmin | 11 | `ceruloplasmin` — Ceruloplazmin |
| B324 | Citrati u urinu 24h | 16 | `citrate-in-24h-urine` — Citrat u 24h urinu |
| B326 | Delta-Aminolevulinska kiselina | 24 | `delta-aminolevulinic-acid` — Delta-aminolevulinska kiselina |
| B327 | Etil alkohol | 3 | `alcohol-in-blood` — Alkohol u krvi |
| B329 | G-6-PDH U eritrocitima | 4 | `glucose-6-phosphate-dehydrogenase` — Glukoza-6-fosfat dehidrogenaza |
| B331 | Histamin u plazmi | 8 | `histamine-in-blood` — Histamin u krvi |
| B332 | Histamin u urinu 24h | 8 | `histamine-in-urine` — Histamin u urinu |
| B333 | Hloridi u serumu | 3 | `chloride` — Hlorid |
| B334 | Hloridi u urinu 24h | 3 | `chloride-in-24h-urine` — Hlorid u 24h urinu |
| B335 | Homocistein | 23 | `homocysteine` — Homocistein |
| B337 | Jod u serumu | 27 | `iodine-in-serum` — Jod u serumu |
| B338 | Jod-24h Urin | 27 | `iodine-in-24h-urine` — Jod u 24h urinu |
| B341 | Kalijum u serumu | 4 | `potassium` — Kalijum |
| B342 | Kalijum u urinu 24h | 4 | `potassium-in-24h-urine` — Kalijum u 24h urinu |
| B345 | Magnezijum u serumu | 4 | `magnesium` — Magnezijum |
| B346 | Magnezijum u urinu | 4 | `magnesium-in-urine` — Magnezijum u urinu |
| B348 | Natrijum u serumu | 4 | `sodium` — Natrijum |
| B349 | Natrijum u urinu 24h | 4 | `sodium-in-24h-urine` — Natrijum u 24h urinu |
| B350 | Neorganski fosfat u serumu | 4 | `phosphorus` — Fosfor |
| B351 | Neorganski fosfat u urinu 24h | 4 | `phosphorus-in-24h-urine` — Fosfor u 24h urinu |
| B353 | Profil Cistatin C | 18 | `cystatin-c` — Cistatin C |
| B355 | Albumini u serumu | 2 | `albumin` — Albumin |
| B356 | Albumini u urinu (Mikroalbuminurija) | 5 | `microalbumin-in-urine` — Mikroalbumin u urinu |
| B848 | Mikroalbumini - drugi jutarnji urin | 6 | `microalbumin-in-urine` — Mikroalbumin u urinu |
| B357 | Alfa-1 kiseli glikoprotein | 12 | `alpha-1-acid-glycoprotein` — Alfa-1 kiseli glikoprotein |
| B358 | Alfa1-antitripsin | 10 | `alpha-1-antitrypsin` — Alfa-1 antitripsin |
| B359 | Alfa2-makroglobulin | 10 | `alpha-2-macroglobulin` — Alfa-2 makroglobulin |
| B360 | Elektroforeza proteina u serumu | 6 | `protein-electrophoresis-serum` — Elektroforeza proteina seruma |
| B361 | Elektroforeza proteina u urinu | 6 | `protein-electrophoresis-urine` — Elektroforeza proteina urina |
| B362 | Haptoglobin | 10 | `haptoglobin` — Haptoglobin |
| B363 | Holo-Transcobalamin (Holo-TC) | 18 | `holotranscobalamin` — Holotranskobalamin |
| B364 | Izoelektrofokusiranje na oligoklonalne imunoglobuline | 44 | `oligoclonal-igg-bands-in-serum` — Oligoklonalne IgG trake u serumu |
| B367 | Proteini - serum | 2 | `total-protein` — Ukupni proteini |
| B369 | Transtiretin (Prealbumin) | 6 | `prealbumin` — Prealbumin |
| B370 | Alkalna Fosfataza (Izoenzimi) | 9 | `alkaline-phosphatase-isoenzymes` — Izoenzimi alkalne fosfataze |
| B371 | Alkalna Fosfataza (Izoenzimi) | 9 | `alkaline-phosphatase-isoenzymes` — Izoenzimi alkalne fosfataze |
| B372 | ALP (Alkalna Fosfataza) | 2 | `alkaline-phosphatase` — Alkalna fosfataza |
| B373 | ALT (SGPT) | 2 | `alt` — Alanin aminotransferaza |
| B374 | Amilaza u serumu | 3 | `amylase` — Amilaza |
| B375 | Amilaza u urinu | 3 | `amylase-in-urine` — Amilaza u urinu |
| B377 | AST (SGOT) | 2 | `ast` — Aspartat aminotransferaza |
| B378 | Bilirubin - direktni | 2 | `direct-bilirubin` — Direktni bilirubin |
| B379 | Bilirubin - ukupni | 2 | `total-bilirubin` — Ukupni bilirubin |
| B380 | CK (Kreatin Kinaza) | 3 | `ck` — Kreatin kinaza |
| B382 | Gama-GT | 2 | `gamma-gt` — Gama-glutamil transferaza |
| B384 | Holesterol | 2 | `cholesterol` — Holesterol |
| B385 | Holinesteraza | 2 | `cholinesterase` — Holinesteraza |
| B386 | Jonizovani kalcijum | 4 | `ionized-calcium` — Jonizovani kalcijum |
| B387 | Kalcijum u serumu | 4 | `calcium` — Kalcijum |
| B388 | Kalcijum u urinu 24h | 4 | `calcium-in-24h-urine` — Kalcijum u 24h urinu |
| B389 | Kisela fosfataza | 2 | `acid-phosphatase` — Kisela fosfataza |
| B390 | Kreatinin u serumu | 2 | `creatinine` — Kreatinin |
| B391 | Kreatinin u urinu 24h | 2 | `creatinine-in-24h-urine` — Kreatinin u 24h urinu |
| B392 | LDH | 2 | `ldh` — Laktat dehidrogenaza |
| B393 | LDH | 2 | `ldh` — Laktat dehidrogenaza |
| B394 | LDH-Izoenzimi | 18 | `ldh-isoenzymes` — Izoenzimi LDH |
| B395 | Lipaza | 5 | `lipase` — Lipaza |
| B397 | Prostatična fosfataza | 2 | `prostatic-acid-phosphatase` — Prostatična kisela fosfataza |
| B398 | Urea u serumu | 2 | `urea` — Urea |
| B399 | Urea u urinu 24h | 2 | `urea-in-24h-urine` — Urea u 24h urinu |
| B400 | Amiloid A (serum) | 13 | `serum-amyloid-a` — Serumski amiloid A |
| B401 | C- reaktivni protein (CRP) | 5 | `c-reactive-protein` — C-reaktivni protein |
| B402 | hs-CRP | 5 | `high-sensitivity-c-reactive-protein` — C-reaktivni protein visoke osjetljivosti |
| B403 | Procalcitonin | 30 | `procalcitonin` — Prokalcitonin |
| B404 | Fruktozamin | 2 | `fructosamine` — Fruktozamin |
| B405 | Glukoza | 2 | `glucose` — Glukoza |
| B407 | Glukoza iz prsta | 1 | `glucose-from-capillary-blood` — Glukoza iz kapilarne krvi |
| B408 | HbA1C | 12 | `hba1c` — Glikovani hemoglobin |
| B410 | Eritropoetin | 40 | `erythropoietin` — Eritropoetin |
| B411 | Feritin | 10 | `ferritin` — Feritin |
| B412 | Gvožđe | 3 | `iron` — Gvožđe |
| B413 | sTfR | 16 | `soluble-transferrin-receptor` — Solubilni transferinski receptor |
| B414 | TIBC | 3 | `tibc` — Ukupni kapacitet vezivanja gvožđa |
| B415 | Transferin | 5 | `transferrin` — Transferin |
| B416 | UIBC | 3 | `uibc` — Neiskorišćeni kapacitet vezivanja gvožđa |
| B417 | Beta - CrossLaps | 14 | `beta-crosslaps` — Beta-CrossLaps |
| B418 | Osteokalcitonin | 13 | `osteocalcin` — Osteokalcin |
| B419 | Apo - A1 (Apolipoprotein A1) | 4 | `apoa-i` — Apolipoprotein A-I |
| B420 | Apo - B (Apolipoprotein B) | 4 | `apolipoprotein-b` — Apolipoprotein B |
| B421 | HDL holesterol | 3 | `hdl-cholesterol` — HDL holesterol |
| B422 | LDL holesterol | 3 | `ldl-cholesterol` — LDL holesterol |
| B423 | Lipoprotein (a) | 6 | `lipoprotein-a` — Lipoprotein A |
| B424 | Masne kiseline, neesterifikovane (NEFA) | 20 | `non-esterified-fatty-acids` — Neesterifikovane masne kiseline |
| B425 | Trigliceridi | 2 | `triglycerides` — Trigliceridi |
| B426 | Bakar u serumu | 5 | `copper-in-serum` — Bakar u serumu |
| B427 | Bakar u urinu 24h | 11 | `copper-in-24h-urine` — Bakar u 24h urinu |
| B428 | Hrom-Krv-nosioci endoproteza | 26 | `chromium-in-blood` — Hrom u krvi |
| B432 | Kobalt-Serum | 26 | `cobalt-in-serum` — Kobalt u serumu |
| B433 | Kobalt-Urin | 26 | `cobalt-in-urine` — Kobalt u urinu |
| B438 | Nikl-Serum | 26 | `nickel-in-serum` — Nikal u serumu |
| B439 | Nikl-Urin | 26 | `nickel-in-urine` — Nikal u urinu |
| B440 | Olovo u krvi | 13 | `lead-in-blood` — Olovo u krvi |
| B441 | Olovo-Urin | 13 | `lead-in-24h-urine` — Olovo u 24h urinu |
| B442 | Selen u krvi | 20 | `selenium` — Selen |
| B443 | Selen-Serum/Plazma | 20 | `selenium` — Selen |
| B444 | Selen-Serum/Plazma | 20 | `selenium` — Selen |
| B445 | Zink u serumu | 6 | `zinc-in-serum` — Cink u serumu |
| B447 | CK - MB | 8 | `ck-mb` — Kreatin kinaza MB |
| B448 | Mioglobin u serumu | 7 | `myoglobin` — Mioglobin |
| B449 | Troponin I | 12 | `troponin-i` — Troponin I |
| B450 | Troponin T | 12 | `troponin-t-hs` — Troponin T visoke osjetljivosti |
| B451 | Arsen | 22 | `arsenic-in-serum` — Arsen u serumu |
| B452 | Barbiturati u urinu - kvalitativno | 4 | `barbiturates` — Barbiturati |
| B453 | Bezodiazepini u urinu - kvalitativno | 4 | `benzodiazepines` — Benzodiazepini |
| B457 | Fenciklidin u urinu - kvalitativno | 4 | `phencyclidine` — Fenciklidin |
| B458 | Fenol u urinu | 16 | `phenol-in-urine` — Fenol u urinu |
| B459 | Hipurna kiselina u urinu | 32 | `hippuric-acid` — Hipurična kiselina |
| B460 | Živa (Hg) u krvi | 23 | `mercury-in-blood` — Živa u krvi |
| B461 | Živa (Hg) u urinu | 23 | `mercury-in-urine` — Živa u urinu |
| B462 | Anti Xa (LMWH) | 20 | `heparin-anti-xa-activity` — Anti-Xa aktivnost heparina |
| B463 | Antitrombin (aktivnost) | 6 | `antithrombin-iii` — Antitrombin III |
| B464 | APCR (rezistencija na aktivisani protein C) | 20 | `apcr-resistance-to-activated-protein-c` — APCR rezistencija na aktivirani protein C |
| B465 | aPTT | 5 | `activated-partial-thromboplastin-time` — Aktivirano parcijalno tromboplastinsko vrijeme |
| B466 | D-dimer | 18 | `d-dimer` — D-dimer |
| B467 | D-dimer | 18 | `d-dimer` — D-dimer |
| B468 | Fibrinogen | 3 | `fibrinogen` — Fibrinogen |
| B469 | Fibrinogen | 3 | `fibrinogen` — Fibrinogen |
| B470 | INR | 4 | `prothrombin-time-pt-inr` — Protrombinsko vrijeme PT INR |
| B489 | Protrombinsko vreme | 4 | `prothrombin-time-pt-inr` — Protrombinsko vrijeme PT INR |
| B471 | Koagulacioni faktor II | 23 | `coagulation-factor-ii` — Faktor koagulacije II |
| B472 | Koagulacioni faktor IX | 23 | `factor-ix` — Faktor IX |
| B473 | Koagulacioni faktor V | 23 | `coagulation-factor-v` — Faktor koagulacije V |
| B474 | Koagulacioni faktor VII | 23 | `coagulation-factor-vii` — Faktor koagulacije VII |
| B475 | Koagulacioni faktor VII | 28 | `coagulation-factor-vii` — Faktor koagulacije VII |
| B476 | Koagulacioni faktor VIII | 24 | `coagulation-factor-viii` — Faktor koagulacije VIII |
| B477 | Koagulacioni faktor X | 24 | `factor-x` — Faktor X |
| B478 | Koagulacioni faktor XI | 28 | `factor-xi` — Faktor XI |
| B479 | Koagulacioni faktor XII | 28 | `factor-xii-hageman` — Faktor XII Hageman |
| B480 | Koagulacioni faktor XIII | 13 | `coagulation-factor-xiii` — Faktor koagulacije XIII |
| B481 | Koncentracija Antitrombina | 11 | `antithrombin-iii-antigen` — Antitrombin III, antigen |
| B482 | Lupus antikoagulans | 17 | `lupus-anticoagulant` — Lupus antikoagulans |
| B486 | Protein C- Aktivnost | 23 | `protein-c` — Protein C |
| B487 | Protein S - Aktivnost | 23 | `protein-s` — Protein S |
| B490 | Trombinsko vreme | 4 | `thrombin-time` — Trombinsko vrijeme |
| B492 | Von-Willebrand Faktor (Aktivnost) | 20 | `von-willebrand-factor-activity` — Aktivnost von Willebrandovog faktora |
| B493 | Von-Willebrand Faktor (Antigen) | 20 | `von-willebrand-factor-antigen` — Von Willebrand faktor antigen |
| B494 | Vreme koagulacije | 1.5 | `coagulation-time` — Vrijeme koagulacije |
| B495 | Vreme krvarenja | 1.5 | `bleeding-time` — Vrijeme krvarenja |
| B497 | 10-hydroxyoxcarbazepin | 10 | `oxcarbazepine-level` — Nivo okskarbamazepina |
| B506 | Digoxin | 14 | `digoxin-level` — Nivo digoksina |
| B507 | EFTIL (Valproična kiselina) | 11 | `valproic-acid` — Valproična kiselina |
| B511 | Levetiracetam (Keppra) | 57 | `levetiracetam-level` — Nivo levetiracetama |
| B512 | Litijum | 3 | `lithium` — Litijum |
| B519 | Topiramat | 61 | `topiramate-level` — Nivo topiramata |
| B520 | Carbamazepin (Tegretol) | 10 | `carbamazepine-level` — Nivo karbamazepina |
| B521 | Lamotrigine (Lamictal) | 23 | `lamotrigine-level` — Nivo lamotrigina |
| B522 | Phenobarbiton | 10 | `phenobarbital-level` — Nivo fenobarbitala |
| B523 | Adalimumab-Antitela | 76 | `adalimumab-antibodies` — Antitijela na adalimumab |
| B524 | Adalimumab-Koncentracija | 52 | `adalimumab-level` — Nivo adalimumaba |
| B526 | Everolimus (Certican ®) | 57 | `everolimus-level` — Nivo everolimusa |
| B527 | Infliximab- Antitela | 26 | `infliximab-antibodies` — Antitijela na infliksimab |
| B528 | Infliximab-Koncentracija | 44 | `infliximab-level` — Nivo infliksimaba |
| B529 | Rapamycin (Sirolimus) | 50 | `sirolimus-level` — Nivo sirolimusa |
| B530 | Tacrolimus (Prograf)- Koncentracija | 57 | `tacrolimus-level` — Nivo takrolimusa |
| B539 | Cistin u urinu 24 h | 16 | `cystine-in-24h-urine` — Cistin u 24h urinu |
| B540 | Koproporfirini u urinu | 11 | `coproporphyrins` — Koproporirfini |
| B541 | Laktati (plazma) | 11 | `lactate` — Laktat |
| B543 | Oksalati u urinu 24h | 13 | `oxalate-in-24h-urine` — Oksalat u 24h urinu |
| B544 | Piruvati u plazmi | 13 | `pyruvate` — Piruvat |
| B546 | Profil Amino kiselina u serumu | 37 | `amino-acid-profile-in-serum` — Profil aminokiselina u serumu |
| B548 | Adenovirus IgG | 18 | `adenovirus-igg` — Adenovirus IgG |
| B549 | Adenovirus IgM | 18 | `adenovirus-igm` — Adenovirus IgM |
| B552 | Anti- HEV IgG | 24 | `anti-hev-igg-elisa` — Anti hepatitis E virus IgG - ELISA |
| B553 | Anti-HAV-IgM | 13 | `hav-igm` — Hepatitis A IgM |
| B554 | Anti-HBc-Ukupna antitela | 11 | `anti-hbc-total-elisa` — Anti HBc antitijela - ELISA |
| B555 | Anti-HBe | 11 | `anti-hbe-elisa` — Anti HBe antitijela - ELISA |
| B556 | Anti-HBs | 11 | `hbsab` — HBsAb |
| B557 | Anti-HEV IgM | 24 | `anti-hev-igm-elisa` — Anti hepatitis E virus IgM - ELISA |
| B558 | Anti-Streptolizin O (ASTO) | 10 | `asto` — ASTO antistreptolizin O |
| B559 | Antitela (IgG) prema Borelia burgdorferi | 13 | `borrelia-burgdorferi-igg` — Borrelia burgdorferi IgG |
| B561 | Antitela (IgM) prema Borelia burgdorferi | 13 | `borrelia-burgdorferi-igm` — Borrelia burgdorferi IgM |
| B564 | Antitela prema Chlamydia trachomatis (IgG) | 27 | `chlamydia-trachomatis-igg` — Chlamydia trachomatis IgG |
| B565 | Antitela prema Chlamydia trachomatis (IgM) | 27 | `chlamydia-trachomatis-igm` — Chlamydia trachomatis IgM |
| B567 | Aspergillus galactomannan Ag | 15 | `galactomannan-test-aspergillus` — Galaktomananski test Aspergillus |
| B571 | Bartonella henselae- IgG | 28 | `bartonella-henselae-igg` — Bartonella henselae IgG |
| B572 | Bartonella henselae IgM | 28 | `bartonella-henselae-igm` — Bartonella henselae IgM |
| B573 | Bartonella quintana IgG | 28 | `bartonella-quintana-igg` — Bartonella quintana IgG |
| B574 | Bartonella quintana IgM | 28 | `bartonella-quintana-igm` — Bartonella quintana IgM |
| B575 | Borelia burgdorferi IgG At (Western Blot) | 33 | `borrelia-burgdorferi-igg-western-blot` — Borrelia burgdorferi IgG Western Blot |
| B576 | Borelia burgdorferi IgM At (Western Blot) | 33 | `borrelia-burgdorferi-igm-western-blot` — Borrelia burgdorferi IgM Western Blot |
| B577 | Brucella-At | 11 | `brucella-abortus-antibodies-agglutination` — Anti Brucella abortus antitijela - aglutinacija |
| B579 | Candida IgG Antitela | 25 | `candida-igg-antibodies` — Candida IgG antitijela |
| B580 | Candida IgM Antitela | 25 | `candida-igm-antibodies` — Candida IgM antitijela |
| B581 | Chlamydia pneumoniae IgG | 27 | `chlamydia-pneumoniae-igg` — Chlamydia pneumoniae IgG |
| B582 | Chlamydia pneumoniae IgM | 27 | `chlamydia-pneumoniae-igm` — Chlamydia pneumoniae IgM |
| B583 | CMV-IgG | 13 | `cytomegalovirus-igg` — Citomegalovirus IgG |
| B864 | CMV-IgG | 13 | `cytomegalovirus-igg` — Citomegalovirus IgG |
| B584 | CMV-IgM | 13 | `cytomegalovirus-igm` — Citomegalovirus IgM |
| B586 | Coxsackie - IgM | 15 | `coxsackie-virus-igm` — Koksaki virus IgM |
| B587 | Coxsackie IgG | 15 | `coxsackie-virus-igg` — Koksaki virus IgG |
| B588 | Cysticercosis-Antitela | 45 | `cysticercosis-igg` — Cisticerkoza IgG |
| B589 | EBV EBNA IgG -At | 36 | `epstein-barr-ebna-igg` — Epstein-Barr EBNA IgG |
| B590 | EBV IgG | 13 | `epstein-barr-igg` — Epstein-Barr IgG |
| B866 | EBV-IgG | 13 | `epstein-barr-igg` — Epstein-Barr IgG |
| B591 | EBV IgM | 13 | `epstein-barr-igm` — Epstein-Barr IgM |
| B592 | Echinococcus IgG At | 12 | `echinococcus-igg-elisa` — Echinococcus IgG ELISA |
| B593 | Echinococcus-ukupna antitela | 28 | `echinococcus-granulosus-antibodies-indirect-hemagglutination` — Anti Echinococcus granulosus antitijela - indirektna hemaglutinacija |
| B597 | Francisella Tularensis IgG | 11 | `francisella-tularensis-igg` — Francisella tularensis IgG |
| B598 | Francisella Tularensis IgM | 11 | `francisella-tularensis-igm` — Francisella tularensis IgM |
| B599 | Haemophilus influenzae-IgG At | 23 | `haemophilus-influenzae-igg` — Haemophilus influenzae IgG |
| B600 | HBeAg | 14 | `hbeag` — HBeAg |
| B601 | HBs Antigen | 11 | `hbsag` — HBsAg |
| B602 | Helicobacter pylori- IgA | 12 | `helicobacter-pylori-iga` — Helicobacter pylori IgA |
| B603 | Helicobacter pylori- IgG | 12 | `helicobacter-pylori-igg` — Helicobacter pylori IgG |
| B604 | HIV 1/2 (Combi) | 10 | `hiv-ag-ab` — HIV Ag-Ab |
| B605 | HIV 1/2 (Combi) | 10 | `hiv-ag-ab` — HIV Ag-Ab |
| B606 | HSV 2 IgM | 13 | `herpes-simplex-ii-igm` — Herpes Simplex II IgM |
| B610 | HSV-2 IgM | 10 | `herpes-simplex-ii-igm` — Herpes Simplex II IgM |
| B874 | HSV2-IgM | 10 | `herpes-simplex-ii-igm` — Herpes Simplex II IgM |
| B607 | HSV-1 IgG | 13 | `herpes-simplex-i-igg` — Herpes Simplex I IgG |
| B608 | HSV-1/2 u uretralnom brisu | 28 | `herpes-simplex-virus-type-1-2-pcr` — Herpes Simplex Virus tip 1 2 PCR |
| B609 | HSV-2 IgG | 10 | `herpes-simplex-ii-igg` — Herpes Simplex II IgG |
| B611 | Humani Herpes Virus-Tip 6 (IgG) | 14 | `human-herpesvirus-6-igg` — Humani herpesvirus 6 IgG |
| B612 | Humani Herpes Virus-Tip 6 (IgM) | 14 | `human-herpesvirus-6-igm` — Humani herpesvirus 6 IgM |
| B615 | Influenza A IgG At | 11 | `influenza-a-virus-igg-elisa` — Anti influenza A virus IgG - ELISA |
| B616 | Influenza B IgA At | 11 | `influenza-b-virus-iga` — Influenca B virus IgA |
| B617 | Influenza B IgG At | 11 | `influenza-b-virus-igg-elisa` — Anti influenza B virus IgG - ELISA |
| B619 | Legionella At (IgM) | 38 | `legionella-pneumophila-igm` — Legionella pneumophila IgM |
| B620 | Legionella At (IgG) | 29 | `legionella-pneumophila-igg` — Legionella pneumophila IgG |
| B621 | Legionella pneumophila (Antigen) | 14 | `legionella-pneumophila-antigen-urine` — Legionella pneumophila antigen u urinu |
| B622 | Leishmania donovani Antitela | 16 | `leishmania-donovani-antibodies-indirect-hemagglutination` — Anti Leishmania donovani antitijela - indirektna hemaglutinacija |
| B623 | Leishmania donovani IgG | 16 | `leishmania-donovani-igg-elisa` — Anti Leishmania donovani IgG - ELISA |
| B624 | Leptospira IgG | 23 | `leptospira-igg-elisa` — Anti Leptospira IgG - ELISA |
| B625 | Leptospira IgM | 23 | `leptospira-igm-elisa` — Anti Leptospira IgM - ELISA |
| B627 | Morbilli IgG | 14 | `measles-igg` — Morbili IgG |
| B628 | Morbilli (Measle) IgM | 14 | `measles-igm` — Morbili IgM |
| B629 | MUMPS IgG | 12 | `mumps-igg` — Zaušnjaci IgG |
| B630 | MUMPS IgM | 12 | `mumps-igm` — Zaušnjaci IgM |
| B631 | Mycoplasma pneumoniae IgG | 14 | `mycoplasma-pneumoniae-igg` — Mycoplasma pneumoniae IgG |
| B632 | Mycoplasma pneumoniae IgM | 14 | `mycoplasma-pneumoniae-igm` — Mycoplasma pneumoniae IgM |
| B633 | Parainfluenza 1,2,3-IgA | 11 | `parainfluenza-virus-1-2-3-iga` — Parainfluenca virus 1, 2, 3 IgA |
| B634 | Parainfluenza 1,2,3-IgG | 11 | `parainfluenza-virus-1-2-3-igg` — Parainfluenca virus 1, 2, 3 IgG |
| B635 | Parvovirus B19 -IgG | 12 | `parvovirus-b19-igg` — Parvovirus B19 IgG |
| B636 | Parvovirus B19- IgM | 12 | `parvovirus-b19-igm` — Parvovirus B19 IgM |
| B637 | Pneumococcus -IgG At | 23 | `streptococcus-pneumoniae-igg` — Streptococcus pneumoniae IgG |
| B638 | Rota/Adeno virus - feces | 15 | `adenovirus-rotavirus-in-stool` — Adenovirus i rotavirus u stolici |
| B641 | Strongyloides stercoralis IgG | 33 | `strongyloides-stercoralis-igg` — Strongyloides stercoralis IgG |
| B642 | Tetanus antitela | 23 | `tetanus-antibodies` — Antitijela na tetanus |
| B643 | Toxocara canis antitela (IgG) | 30 | `toxocara-canis-igg` — Toxocara canis IgG |
| B644 | Toxoplasma IgG-Aviditet | 46 | `toxoplasma-igg-avidity` — Aviditet IgG antitijela na toksoplazmu |
| B645 | TPHA | 10 | `tpha-treponema-pallidum` — TPHA Treponema pallidum |
| B647 | Treponema pallidum IgM At (Western Blot) | 34 | `treponema-pallidum-igm-western-blot` — Treponema pallidum IgM antitijela (Western Blot) |
| B648 | Trichinella spiralis IgG | 11 | `trichinella-spiralis-igg` — Trichinella spiralis IgG |
| B649 | Ukupna At prema Treponema Pallidum | 9 | `treponema-pallidum-total-antibodies` — Treponema pallidum ukupna antitijela |
| B650 | VDRL (Cardiolipin mikroflokulacioni test) | 20 | `vdrl` — VDRL |
| B651 | VZV IgG | 34 | `varicella-zoster-virus-igg` — Varičela zoster virus IgG |
| B652 | VZV IgG-Aviditet | 13 | `varicella-zoster-igg-avidity` — Aviditet IgG antitijela na virus varičela-zoster |
| B653 | VZV-IgM | 13 | `varicella-zoster-virus-igm` — Varičela zoster virus IgM |
| B655 | Yersinia IgG At | 23 | `yersinia-igg-antibodies` — Yersinia IgG antitijela |
| B659 | M.Tuberculosis Complex-DNA | 60 | `mycobacterium-tuberculosis-complex-pcr` — Mycobacterium tuberculosis complex PCR |
| B660 | M.Tuberculosis Complex-DNA | 60 | `mycobacterium-tuberculosis-complex-pcr` — Mycobacterium tuberculosis complex PCR |
| B661 | QuantiFERON-TB GOLD | 49 | `quantiferon` — QuantiFERON |
| B664 | BCR/ABL fuzioni transkript | 220 | `bcr-abl-molecular-detection` — BCR ABL molekularna detekcija |
| B666 | Detekcija mikrosatelitske nestabilnosti (MSI) | 25 | `microsatellite-instability` — Mikrosatelitna nestabilnost |
| B669 | Mutacija V600E u 15. egzonu BRAF gena | 54 | `braf-mutation` — BRAF mutacija |
| B671 | Mutacija V617F u JAK2 genu | 80 | `jak2-v617f-mutation` — Mutacija V617F u JAK2 genu |
| B690 | Alfa-1 antitripsin - genotip | 81 | `alpha-1-antitrypsin-genotyping` — Alfa-1 antitripsin genotipizacija |
| B695 | CAG tripletski ponovci u HTT genu (Hantingtonova bolest) | 98 | `huntington-disease-analysis` — Analiza Hantingtonove bolesti |
| B697 | Detekcija HLA-DQ2 i HLA-DQ8 genotipa (Intolerancija na gluten) | 86 | `hla-dq2-dq8-typing` — HLA DQ2 DQ8 tipizacija |
| B699 | Dišenova Muskularna Distrofija-DMD (Distrofin) | 800 | `duchenne-muscular-dystrophy` — Duchennova mišićna distrofija |
| B700 | Dišenova Muskularna Distrofija-DMD (Distrofin) | 710 | `duchenne-muscular-dystrophy` — Duchennova mišićna distrofija |
| B704 | HLA Tipizacija (A Lokus) | 83 | `hla-a-typing` — HLA tipizacija (lokus A) |
| B705 | HLA Tipizacija (B Lokus) | 83 | `hla-b-typing` — HLA tipizacija (lokus B) |
| B706 | HLA-B27 Antigen | 83 | `hla-b27-antigen` — HLA B27 antigen |
| B711 | Microdelecijski sindromi:Angelman/Prader Willy | 130 | `microdeletion-syndromes-angelman` — Sindrom mikrodelecije Angelman |
| B712 | Mikrodelecije Y hromozoma - AZFa, AZFb, AZFc regioni | 79 | `y-chromosome-microdeletion` — Mikrodelecije Y hromozoma |
| B716 | Mutacija u 6. kodonu HBB gena (Srpasta anemija) | 31 | `sickle-cell-mutation-hbb-codon-6` — Mutacija u 6. kodonu HBB gena (srpasta anemija) |
| B720 | Mutacije i delecije u HBB genu (Beta talasemija) | 98 | `beta-thalassemia-pcr` — Beta-talasemija PCR |
| B723 | Mutacije u ATP7B genu (Vilsonova bolest) | 120 | `wilson-disease-pcr` — Wilsonova bolest PCR |
| B725 | Mutacije u CFTR genu (Cistična fibroza) | 106 | `cystic-fibrosis-34-mutations` — Cistična fibroza 34 mutacije |
| B726 | Mutacije u CYP21A2 genu (Kongenitalna adrenalna hiperplazija) | 280 | `21-hydroxylase-cyp21a2` — 21-hidroksilaza CYP21A2 |
| B729 | Mutacije u HFE genu (Hemohromatoza) | 150 | `hemochromatosis-pcr-c282y` — Hemohro matoza PCR C282Y |
| B733 | Mutacije u MCM6 genu (Intolerancija na laktozu) | 67 | `lactose-intolerance-pcr` — Nepodnošljivost laktoze PCR |
| B739 | Očinstvo - poređenje genetičkih profila (otac + dete) | 240 | `paternity-testing-pcr` — Test očinstva PCR |
| B742 | Očinstvo (otac + dete) - genetičko ispitivanje | 240 | `paternity-testing-pcr` — Test očinstva PCR |
| B744 | PCA3 mRNA-Score | 240 | `pca3-score-prostate-cancer` — PCA3 skor kancer prostate |
| B746 | PCR-Friedreich ataxia | 98 | `friedreich-ataxia` — Friedreichova ataksija |
| B748 | Postnatalne aneuploidije(hromozomi: 13,18,21,X,Y) PCR | 96 | `numerical-aberration-analysis-chromosomes` — Analiza numeričke aberacije hromozoma |
| B754 | Bordetella pertussis DNA | 110 | `bordetella-pertussis-pcr` — Bordetella pertussis PCR |
| B755 | Borrelia burgdorferi DNA | 63 | `borrelia-burgdorferi-pcr` — Borrelia burgdorferi PCR |
| B756 | Chlamydia trachomatis DNK | 20 | `chlamydia-trachomatis-real-time-pcr` — Chlamydia trachomatis (Real-Time PCR) |
| B759 | Detekcija prisustva polno prenosivih patogena (6 patogena) | 87 | `std-multiplex-6` — STD Multiplex 6 – detekcija 6 patogena |
| B760 | Detekcija prisustva polno prenosivih patogena (6 patogena) | 87 | `std-multiplex-6` — STD Multiplex 6 – detekcija 6 patogena |
| B761 | Detekcija prisustva polno prenosivih patogena (6 patogena) | 87 | `std-multiplex-6` — STD Multiplex 6 – detekcija 6 patogena |
| B762 | Detekcija prisustva polno prenosivih patogena (6 patogena) | 87 | `std-multiplex-6` — STD Multiplex 6 – detekcija 6 patogena |
| B766 | Mycoplasma genitalium DNK | 20 | `mycoplasma-genitalium-real-time-pcr` — Mycoplasma genitalium (Real-Time PCR) |
| B767 | Mycoplasma hominis DNK | 20 | `mycoplasma-hominis-real-time-pcr` — Mycoplasma hominis (Real-Time PCR) |
| B769 | Neisseria gonorrhoeae DNK | 20 | `neisseria-gonorrhoeae-real-time-pcr` — Neisseria gonorrhoeae (Real-Time PCR) |
| B772 | Toxoplasma gondii DNA | 11 | `toxoplasma-gondii-pcr` — Toxoplasma gondii PCR |
| B774 | Trichomonas vaginalis | 20 | `trichomonas-vaginalis-real-time-pcr` — Trichomonas vaginalis (Real-Time PCR) |
| B776 | Ureaplasma urealyticum DNK | 20 | `ureaplasma-urealyticum-pcr` — Ureaplasma urealyticum PCR |
| B778 | CMV (Citomegalovirus) DNA | 58 | `cytomegalovirus-pcr` — Citomegalovirus PCR |
| B781 | EBV-DNA (PCR) | 110 | `epstein-barr-virus-pcr` — Epstein-Barr virus PCR |
| B782 | HBV DNK (Kvalitativna analiza Hepatitis B virusa) | 81 | `hbv-pcr-dna-qualitative` — HBV PCR DNK kvalitativni |
| B783 | HBV DNK (Kvantitativna analiza Hepatitis B virusa) | 81 | `hbv-pcr-dna-quantitative` — HBV PCR DNK kvantitativni |
| B787 | Hepatitis B - DNA - kvantitativno | 81 | `hbv-pcr-dna-quantitative` — HBV PCR DNK kvantitativni |
| B784 | HCV RNK (Kvalitativna analiza Hepatitis C virusa) | 6 | `hcv-pcr-rna-qualitative` — HCV PCR RNK kvalitativni |
| B785 | HCV RNK (Kvantitativna analiza Hepatitis C virusa) | 120 | `hcv-pcr-rna-quantitative` — HCV PCR RNK kvantitativni |
| B786 | HCV-Genotipizacija | 270 | `hcv-rna-genotyping` — HCV RNK genotipizacija |
| B788 | HIV - RNA - kvantitativno | 94 | `hiv-pcr-rna-quantitative` — HIV PCR RNK kvantitativni |
| B790 | HIV RNK (Kvantitativna analiza HIV-a) | 94 | `hiv-pcr-rna-quantitative` — HIV PCR RNK kvantitativni |
| B791 | Humani-Herpes-Virus-Tip-6-DNA | 130 | `human-herpesvirus-6-pcr` — Humani herpesvirus 6 PCR |
| B795 | Polioma-BK virus DNA | 112 | `bk-virus-pcr` — BK virus PCR |
| B798 | Mutacija u genu za faktor koagulacije II (Protrombin II; G20210A) | 31 | `prothrombin-ii-locus-20210-pcr` — Protrombin II lokus 20210 PCR |
| B799 | Mutacija u genu za faktor koagulacije V (A4070G) | 31 | `factor-v-hr2-locus-4070` — Faktor V HR2 lokus 4070 |
| B800 | Mutacija u genu za faktor koagulacije V (R506Q, Leiden V) | 31 | `factor-v-leiden-locus-1691` — Faktor V Leiden lokus 1691 |
| B801 | Mutacija u genu za faktor koagulacije XIII (V34L) | 31 | `factor-xiii-locus-v34l` — Faktor XIII lokus V34L |
| B802 | Mutacija u genu za metilentetrahidrofolat reduktazu (MTHFR; C677T) | 31 | `mthfr-locus-677-pcr` — MTHFR lokus 677 PCR |
| B803 | Mutacija u genu za MTHFR (A1298C) | 31 | `mthfr-locus-1298` — MTHFR lokus 1298 |
| B804 | Panel - nasledne trombofilije 3 mutacije (Leiden V, Protrombin II, MTHFR) | 95 | `thrombophilia-3-genes-3-loci` — Trombofilija 3 gena 3 lokusa |
| B806 | Polimorfizam u genu za Plazminogen Aktivator Inhibitor-1 (PAI-1) | 46 | `pai-1-675-4g-5g` — PAI-1 675 4G 5G |
| B808 | DOUBLE test | 25 | `double-test-first-trimester-screening` — Dabl test (biohemijski skrining 1. trimestra) |
| B809 | Quadruple-("Q") test | 49 | `quadruple-test` — Četvorostruki test |
| B810 | TRIPLE Test | 28 | `triple-test-second-trimester-screening` — Tripl test (biohemijski skrining 2. trimestra) |
| B811 | Waaler Rose | 7 | `waaler-rose-test` — Valer-Rouz test |
| B812 | Bordetella pertussis IgG | 24 | `bordetella-pertussis-igg` — Bordetella pertussis IgG |
| B817 | Acilkarnitin Profil | 29 | `acylcarnitine-profile` — Profil acilkarnitina |
| B820 | Screening antitela | 13 | `irregular-antibody-screening` — Ispitivanje iregularnih antitijela — screening test |
| B821 | 5-Hidroksiindol sirćetna kiselina | 12 | `5-hiaa` — 5-hidroksiindolsirćetna kiselina |
| B822 | AFP (α1-Fetoprotein) | 13 | `afp` — Alfa fetoprotein |
| B823 | Beta2 - mikroglobulin u serumu | 12 | `beta-2-microglobulin` — Beta-2 mikroglobulin |
| B824 | CA-125 | 13 | `ca-125` — Onkomarker CA 125 |
| B825 | CA-15-3 | 13 | `ca-15-3` — Onkomarker CA 15-3 |
| B826 | CA-19-9 | 13 | `ca-19-9` — Onkomarker CA 19-9 |
| B827 | CA-50 | 28 | `ca-50` — Onkomarker CA 50 |
| B828 | CA-72-4 | 13 | `ca-72-4` — Onkomarker CA 72-4 |
| B829 | Calcitonin | 13 | `calcitonin` — Kalcitonin |
| B830 | CEA | 13 | `cea` — Karcinoembrionalni antigen |
| B832 | CYFRA 21-1 | 14 | `cyfra-21-1` — CYFRA 21-1 |
| B833 | FPSA/PSA/ Index | 18 | `psa-plus-free-psa` — PSA plus slobodni PSA |
| B834 | HE4 | 23 | `he4` — Humani epididimalni protein 4 |
| B836 | NSE | 13 | `nse` — Neuron-specifična enolaza |
| B838 | PSA | 13 | `psa` — Prostatični specifični antigen |
| B839 | PSA-Free | 13 | `free-psa` — Slobodni PSA |
| B840 | S-100 | 20 | `protein-s-100` — Protein S-100 |
| B841 | SCC (squamous cell carcinoma antigen) | 25 | `scc-squamous-cell-carcinoma-antigen` — SCC antigen skvamoznih ćelija |
| B843 | Tireoglobulin | 11 | `thyroglobulin` — Tireoglobulin |
| B844 | Bence Jones proteinurija (kvalitativno) | 3 | `bence-jones-protein` — Bens Džons proteini |
| B845 | Beta2-mikroglobulin u urinu | 10 | `beta-2-microglobulin-in-urine` — Beta-2 mikroglobulin u urinu |
| B846 | Klirens kreatinina | 10 | `creatinine-clearance` — Klirens kreatinina |
| B847 | Klirens uree | 10 | `urea-clearance` — Klirens ureje |
| B849 | Mokraćna kiselina u urinu 24h | 2 | `uric-acid-in-24h-urine` — Mokraćna kiselina u 24h urinu |
| B851 | Osmolalitet-urin | 5 | `urine-osmolality` — Osmolalnost urina |
| B852 | Pregled urina | 3 | `complete-urinalysis` — Kompletan pregled urina |
| B853 | Proteini u urinu - kvalitativno | 4 | `protein-in-urine` — Proteini u urinu |
| B854 | Proteini u urinu 24h | 4 | `protein-in-24h-urine` — Proteini u 24h urinu |
| B855 | Pyridinijum "crosslinks" u urinu | 16 | `pyridinium-crosslinks-in-urine` — Piridinijumske unakrsne veze u urinu |
| B862 | Anti-HCV | 13 | `anti-hcv` — Anti-HCV |
| B863 | CMV IgG-Aviditet | 31 | `cmv-avidity` — Aviditet IgG antitijela na CMV |
| B868 | HbC IgM At | 24 | `anti-hbc-igm-elisa` — Anti HBc IgM antitijela - ELISA |
| B870 | HCV-RIBA | 55 | `anti-hcv-antibodies-immunoblot` — Anti hepatitis C virus antitijela - imuno blot |
| B871 | HIV-p24 Antigen | 17 | `hiv-p24-antigen-elisa` — Ispitivanje prisustva p24 antigena - ELISA |
| B872 | HIV-Potvrdni test (Imunoblot) | 34 | `anti-hiv-1-western-blot-confirmation` — Anti HIV 1 antitijela - potvrdni test - western blot |
| B873 | HSV1-IgM | 10 | `herpes-simplex-i-igm` — Herpes Simplex I IgM |
| B875 | HTLV I/II | 9 | `htlv-i-ii-antibodies` — Antitijela na HTLV I/II |
| B878 | Rubella IgG | 12 | `rubella-igg` — Rubela IgG |
| B879 | Rubella IgG-Aviditet | 31 | `rubella-igg-avidity` — Aviditet IgG antitijela na virus rubeole |
| B880 | Rubella IgM | 12 | `rubella-igm` — Rubela IgM |
| B881 | Coenzmye Q10 (Ubichinon) | 35 | `coenzyme-q10` — Koenzim Q10 |
| B882 | Folna kiselina (Vitamin B9) | 10 | `folic-acid` — Folna kiselina |
| B883 | Metil Malonska kiselina (Serum) | 62 | `methylmalonic-acid` — Metilmalonska kiselina |
| B885 | Vitamin A (Retinol) | 62 | `vitamin-a` — Vitamin A |
| B886 | Vitamin B1(Tiamin) | 23 | `vitamin-b1-level` — Nivo vitamina B1 |
| B887 | Vitamin B12 | 11 | `vitamin-b12` — Vitamin B12 |
| B888 | Vitamin B6 (Piridoksal Fosfat) | 56 | `vitamin-b6-level` — Nivo vitamina B6 |
| B889 | Vitamin C | 48 | `vitamin-c-level` — Nivo vitamina C |
| B890 | Vitamin D (25(OH)D3; 25(OH)D2) | 20 | `vitamin-d-25-oh` — Vitamin D 25-OH |
| B891 | Vitamin E | 21 | `vitamin-e-level` — Nivo vitamina E |
| B892 | Vitamin H (Biotin) | 21 | `vitamin-h-b7-biotin-level` — Vitamin H B7 biotin nivo |
| B893 | Vitamin K | 27 | `vitamin-k1-level` — Nivo vitamina K1 |
| M002 | Antimikogram | 16 | `antimycogram` — Izrada antimikograma |
| M007 | Biopsijski materijal- anaerobno | 10 | `tissue-biopsy-culture-anaerobic` — Bakteriološko ispitivanje isječka tkiva - anaerobno |
| M008 | Biopsijski materijal- bakteriološki | 5 | `tissue-biopsy-culture-aerobic` — Bakteriološko ispitivanje isječka tkiva - aerobno |
| M010 | Biopsijski materijal- Mycoplasma hominis | 10 | `mycoplasma-hominis-culture` — Kultura na Mycoplasma hominis |
| M050 | Cervikalni bris-Mycoplasma hominis | 11 | `mycoplasma-hominis-culture` — Kultura na Mycoplasma hominis |
| M078 | Sperma- Mycoplasma hominis | 12 | `mycoplasma-hominis-culture` — Kultura na Mycoplasma hominis |
| M093 | Uretralni bris- Mycoplasma hominis | 12 | `mycoplasma-hominis-culture` — Kultura na Mycoplasma hominis |
| M011 | Biopsijski materijal- Ureaplasma urealyticum | 10 | `ureaplasma-urealyticum-culture` — Kultura na Ureaplasma urealyticum |
| M048 | Cervikalni bris- Ureaplasma urealyticum | 12 | `ureaplasma-urealyticum-culture` — Kultura na Ureaplasma urealyticum |
| M079 | Sperma- Ureaplasma urealyticum | 12 | `ureaplasma-urealyticum-culture` — Kultura na Ureaplasma urealyticum |
| M094 | Uretralni bris- Ureaplasma Urealiticum | 12 | `ureaplasma-urealyticum-culture` — Kultura na Ureaplasma urealyticum |
| M012 | Borrelia burgdoferi DNA, Krpelj | 41 | `borrelia-burgdorferi-pcr-in-tick` — Borrelia burgdorferi PCR u krpelju |
| M013 | Bris dojke bakteriološki | 6 | `breast-swab-bacteria` — Bris dojke na bakterije |
| M014 | Bris dojke mikološki | 6 | `breast-swab-fungi` — Bris dojke na gljivice |
| M015 | Bris glansa- bakteriološki | 6 | `glans-swab-bacteria` — Bris glansa na bakterije |
| M016 | Bris glansa- mikološki | 6 | `glans-swab-fungi` — Bris glansa na gljivice |
| M017 | Bris grla- mikološki | 6 | `throat-swab-fungi` — Bris grla na gljivice |
| M018 | Bris grla-bakteriološki | 6 | `throat-swab-bacteria` — Bris grla na bakterije |
| M019 | Bris jezika- bakteriološki | 6 | `tongue-swab-bacteria` — Bris jezika na bakterije |
| M020 | Bris jezika- mikološki | 6 | `tongue-swab-fungi` — Bris jezika na gljivice |
| M021 | Bris kože- mikološki | 6 | `skin-swab-fungi` — Bris kože na gljivice |
| M022 | Bris kože-bakteriološki | 6 | `skin-swab-bacteria` — Bris kože na bakterije |
| M024 | Bris lohija bakteriološki | 6 | `lochia-swab-culture-aerobic` — Bakteriološko ispitivanje brisa lohija - aerobno |
| M025 | Bris nosa- mikološki | 6 | `nose-swab-fungi` — Bris nosa na gljivice |
| M026 | Bris nosa-bakteriološki | 6 | `nose-swab-bacteria` — Bris nosa na bakterije |
| M027 | Bris oka - bakteriološki | 6 | `eye-swab-bacteria` — Bris oka na bakterije |
| M028 | Bris oka- Chlamidiae trachomatis | 12 | `eye-swab-chlamydia` — Bris oka – hlamidija |
| M029 | Bris oka- mikološki | 6 | `eye-swab-fungi` — Bris oka na gljivice |
| M030 | Bris prepucijuma- bakteriološki | 6 | `prepuce-swab-bacteria` — Bris prepucijuma na bakterije |
| M031 | Bris prepucijuma- mikološki | 7 | `prepuce-swab-fungi` — Bris prepucijuma na gljivice |
| M032 | Bris rane- anaerobno | 10 | `wound-swab-culture-anaerobic` — Bakteriološko ispitivanje brisa rane - anaerobno |
| M033 | Bris rane mikološki | 7 | `wound-swab-fungi` — Bris rane na gljivice |
| M034 | Bris rane-bakteriološki | 6 | `wound-swab-bacteria` — Bris rane na bakterije |
| M035 | Bris uha- mikološki | 7 | `ear-swab-fungi` — Bris uha na gljivice |
| M036 | Bris uha-bakteriološki | 6 | `bacteriological-examination-ear-swab` — Bakteriološki pregled brisa uha |
| M037 | Bris usne duplje-bakteriološki | 6 | `oral-cavity-swab-bacteria` — Bris usne duplje na bakterije |
| M038 | Bris usne duplje-mikološki | 7 | `oral-cavity-fungi` — Bris usne duplje na gljivice |
| M039 | Bris vulve- bakteriološki | 7 | `vulvar-swab-bacteria` — Bris vulve na bakterije |
| M040 | Bris vulve- mikološki | 7 | `vulvar-swab-fungi` — Bris vulve na gljivice |
| M043 | Campylobacter spp | 8 | `campylobacter-culture` — Campylobacter sp. (kultura) |
| M044 | CB (dir.prep)- na N. gonorrhoeoe | 5 | `microscopic-examination-of-swab-for-gonorrhea` — Pregled preparata uretralnog, vaginalnog ili cervikalnog brisa na gonoreju |
| M088 | Uretralni bris (dir.prep)- na N. Gonorrhoeoe | 5 | `microscopic-examination-of-swab-for-gonorrhea` — Pregled preparata uretralnog, vaginalnog ili cervikalnog brisa na gonoreju |
| M045 | Cervikalni bris- anaerobno | 11 | `cervical-swab-culture-anaerobic` — Bakteriološko ispitivanje cervikalnog brisa - anaerobno |
| M046 | Cervikalni bris- Chlamidiae trachomatis | 11 | `chlamydia-genital-swab` — Chlamydia trachomatis – genitalni bris |
| M091 | Uretralni bris- Chlamidiae trachomatis | 12 | `chlamydia-genital-swab` — Chlamydia trachomatis – genitalni bris |
| M047 | Cervikalni bris- mikološki | 8 | `cervical-swab-fungi` — Bris cerviksa na gljivice |
| M049 | Cervikalni bris-bakteriološki | 7 | `cervical-swab-bacteria` — Bris cerviksa na bakterije |
| M051 | Clostridium difficile Toxin A i B | 24 | `clostridium-difficile-toxin-a-and-b` — Clostridium difficile toksin A i B |
| M052 | Demodex | 4 | `demodex-species` — Pregled na Demodex |
| M053 | Feces- bakteriološki | 6 | `stool-culture` — Koprokultura |
| M054 | Feces- mikološki | 7 | `stool-fungi` — Kultura stolice na gljivice |
| M055 | Feces- parazitološki (helminti) | 6 | `stool-parasites` — Paraziti u stolici |
| M056 | Feces-Protozoe | 6 | `stool-microscopic-examination-for-protozoa` — Mikroskopski pregled stolice na protozoe (metoda koncentracije) |
| M057 | Grupa vaginalnog sekreta | 7 | `vaginal-discharge-dmp` — Vaginalni sekret - grupa (DMP) |
| M058 | Hemokultura - anaerobno | 12 | `blood-culture-anaerobic` — Bakteriološko ispitivanje krvi - anaerobno |
| M059 | Hemokultura-aerobno | 12 | `blood-culture-aerobic` — Bakteriološko ispitivanje krvi - aerobno |
| M060 | Intravaskularni kateter | 12 | `intravascular-catheter-tip-swab-culture-aerobic` — Bakteriološko ispitivanje vrha intravaskularnog katetera - aerobno |
| M061 | Iscedak dojke bakteriološki | 7 | `nipple-discharge-bacteria` — Iscedak bradavice bakterije |
| M062 | Iscedak dojke mikološki | 8 | `nipple-discharge-fungi` — Iscedak bradavice gljivice |
| M068 | Mikološki pregled dlake | 7 | `dermatophytes-hair-scraping` — Pregled preparata na dermatomikoze dlake |
| M069 | Mikološki pregled strugotine kože | 11 | `dermatophytes-skin-scraping` — Strugotina kože na dermatofite |
| M071 | Perianalni otisak | 4 | `perianal-impression` — Perianalni otisak |
| M074 | Punktat - bakteriološki | 7 | `punctate-aerobic` — Punktat na aerobne bakterije |
| M075 | Pyo kultura - anaerobno | 11 | `abscess-content-culture-anaerobic` — Bakteriološko ispitivanje sadržaja abscesa - anaerobno |
| M076 | Rektalni bris | 7 | `rectal-swab-bacteria` — Rektalni bris na bakterije |
| M077 | Sperma- mikološki | 7 | `sperm-culture-fungi` — Kultura sperme na gljivice |
| M080 | Sperma-bakteriološki | 7 | `sperm-culture-bacteria` — Kultura sperme na bakterije |
| M081 | Sputum- bakteriološki | 6 | `sputum-bacteria` — Kultura sputuma na bakterije |
| M082 | Sputum- mikološki | 7 | `sputum-fungi` — Kultura sputuma na gljivice |
| M083 | Streptococcus agalactiae (Beta-hem strept B) | 13 | `gbs-culture` — GBS kultura |
| M084 | Streptococcus pyogenes-Brzi test | 6 | `rapid-strep-a` — Brzi test na streptokoke A |
| M085 | Strugotina kože- mikološki | 7 | `skin-scraping-fungi` — Strugotina kože na gljivice |
| M086 | Strugotina nokta- mikološki | 8 | `nail-scraping-fungi` — Strugotina nokta gljivice |
| M089 | Uretralni bris (dir.prep.)- na Trichomonas spp. | 5 | `trichomonas-test-urethral` — Test na trihomonase uretra |
| M092 | Uretralni bris- mikološki | 7 | `urethral-swab-fungi` — Bris uretre na gljivice |
| M095 | Uretralni bris-bakteriološki | 7 | `urethral-swab-bacteria` — Bris uretre na bakterije |
| M096 | Urin- Chlamidiae trachomatis | 12 | `chlamydia-trachomatis-pcr-urine` — Chlamydia trachomatis PCR u urinu |
| M097 | Urin- mikološki | 7 | `urine-fungi` — Kultura urina na gljivice |
| M098 | Urin-bakteriološki | 6 | `urine-culture` — Urinokultura |
| M099 | Vaginalni bris - direktni preparat | 7 | `direct-microscopic-preparation-vaginal` — Direktan mikroskopski preparat vagina |
| M100 | Vaginalni bris (dir.prep)-na Trichomonas vaginalis | 5 | `trichomonas-test` — Test na trihomonase |
| M101 | Vaginalni bris- anaerobno | 10 | `vaginal-swab-culture-anaerobic` — Bakteriološko ispitivanje vaginalnog brisa - anaerobno |
| M102 | Vaginalni bris- mikološki | 7 | `vaginal-swab-fungi` — Bris vagine na gljivice |
| M103 | Vaginalni bris-bakteriološki | 7 | `vaginal-swab-bacteria` — Bris vagine na bakterije |
| M105 | Žuč- bakteriološki | 7 | `bile-culture-aerobic` — Bakteriološko ispitivanje žuči - aerobno |
| M107 | Antimon (Sb)-Urine | 29 | `antimony-in-urine` — Antimon u urinu |
| M109 | Kadmijum-Krv | 27 | `cadmium-in-blood` — Kadmijum u krvi |
| M110 | Kadmijum-Urin | 27 | `cadmium-in-24h-urine` — Kadmijum u 24h urinu |
| M111 | Direktni preparat | 6 | `direct-microscopic-preparation` — Direktan mikroskopski preparat |
| M120 | TOXO IgG | 11 | `toxoplasma-igg` — Toksoplazma IgG |
| M121 | TOXO IgM | 11 | `toxoplasma-igm` — Toksoplazma IgM |
