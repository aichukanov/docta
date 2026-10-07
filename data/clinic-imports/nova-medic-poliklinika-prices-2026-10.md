# Nova Medic Poliklinika: синхронизация цен с сайтом (2026-10-02)

Источник — [novamedic.me/cjenovnik/](https://novamedic.me/cjenovnik/), снят 2026-10-02; `modified` в wp-json — 2026-09-30.
Сверено с продом построчно: id на проде 101, локальная БД совпадает с продом полностью (162 строки, цены и флаги).
Снимки — `data/clinic-pricelists/sources/nova-medic-poliklinika/`: страница, wp-json прайса, все 41 страница сайта, Wayback 2026-05-14.

| | Строк | |
|---|---|---|
| Меняется цена | 3 | раздел 1 |
| Совпадает | 97 | не трогаем |
| Спорные | 1 | раздел 2 — решено, но стоит взглянуть |
| У нас есть, на сайте нет | 62 | раздел 3 — is_obsolete = 1 |
| На сайте есть, у нас нет | 4 | раздел 4 — 3 добавляем, 1 не заводим |

## Откуда расхождение 162 против ~115

2026-09-30 клиника перепрофилировалась на дерматологию и эстетику. Из прайса, из меню сайта и из «Naš tim» исчезли терапия, эндокринология, пульмонология, УЗИ, физиатрия с физиотерапией, ЛФК и массажем, хиджама и ботокс Xeomin. В майском снимке прайса (Wayback 2026-05-14) все эти разделы ещё есть, и цены всех 61 позиции в нашей БД совпадают с ним один в один: первичный импорт 2026-04-16 делался с прайса той эпохи. 62-я строка — эпиляция всего лица (жен.) — не значится ни в майском, ни в текущем прайсе.

Разбивки одной позиции сайта на несколько у нас нет: зоны эпиляции, CO2, мезотерапии и количество процедур совпадают с сайтом строка в строку. Цен со страниц услуг, которых не было бы в /cjenovnik/, тоже нет: из 41 страницы цены есть на четырёх (Lola, Exilis для тела, антицеллюлит, летний пакет), и все они дублируют прайс. Блоки `vc_raw_html` расшифрованы.

## 1. Меняется цена

| # | Запись каталога | Название на сайте | Было | Стало | Примечание |
|---|---|---|---|---|---|
| 1 | Uklanjanje kondiloma tečnim azotom sa pregledom `svc:condyloma-cryotherapy-removal-with-examination` | DERMATOVENEROLOGIJA › Uklanjanje kondiloma tečnim azotom sa pregledom | 100 | **150** | в мае было 100 |
| 2 | Skinbuilder – LOLA `svc:skinbuilder-lola-biorevitalization` | ESTETSKA MEDICINA › BIOREVITALIZACIJA › Skinbuilder – LOLA | 250 | **220** | то же на /lola-tretman/: «Redovna cijena 220€»; ниже там же устаревший блок «Redovna cijena 250€ / Vaša cijena 225€» |
| 3 | Presoterapija 30 min. – paket 10 tretmana `svc:pressotherapy-30-min-package-10-treatments` | TRETMANI TIJELA › PRESOTERAPIJA PAKET 10 TRETMANA › Presoterapija – aparaturna limfna drenaža 30 min. | 100 | **120** | в снимке 2026-05-14 тоже 120 € |

## 2. Спорные

| Запись каталога | Сейчас | Кандидат на сайте | Цена на сайте | Почему спорно |
|---|---|---|---|---|
| Biopsija kože sa patohistološkim nalazom `svc:skin-biopsy-with-histopathology-report` | у клиники нет | DERMATOVENEROLOGIJA › Dermatološki pregled sa biopsijom kože i analizom uzorka | 150 | осмотр + биопсия + гистология одной ценой. Отдельной записи «осмотр с биопсией» в каталоге нет, а «Biopsija kože sa patohistološkim nalazom» по смыслу то же («analiza uzorka» = патогистология), поэтому строка в SQL **есть**, формулировка клиники добавлена синонимом. Если нужна отдельная запись, строку из раздела 2 SQL надо убрать |

## 3. У нас есть, на сайте нет

Страницы услуг проверены у всех строк: список страниц из wp-json (`/wp-json/wp/v2/pages?per_page=100`, их 41), текст и расшифрованные блоки `vc_raw_html`, а также ответ сервера на старые URL. Колонка «В мае» — строка из снимка 2026-05-14.

### Botox Xeomin — 5

Раздел BOTOX на 2026-05-14 содержал строки Bocouture и Xeomin, на 2026-09-30 остался только Bocouture. Отдельной страницы про ботокс нет: /botox/ отдаёт 301 на главную.

| Запись каталога | Цена у нас | В мае |
|---|---|---|
| Botox Xeomin – 1 regija `svc:botox-xeomin-1-region` | 250 | Botox – 1 regija (Xeomin) €250 |
| Botox Xeomin – 2 regije `svc:botox-xeomin-2-regions` | 300 | Botox – 2 regije (Xeomin) €300 |
| Botox Xeomin – 3 regije `svc:botox-xeomin-3-regions` | 350 | Botox – 3 regije (Xeomin) €350 |
| Hiperhidroza pazuha Xeomin `svc:axillary-hyperhidrosis-botox-xeomin` | 500 | Hiperhidroza pazuha (Xeomin) €500 |
| Hiperhidroza šaka Xeomin `svc:palmar-hyperhidrosis-botox-xeomin` | 500 | Hiperhidroza šaka (Xeomin) €500 |

### Физиатрия, физиотерапия, ЛФК, массаж, хиджама — 38

Разделы FIZIJATRIJA, FIZIKALNA TERAPIJA (+ PAKETI), VJEŽBE (+ PAKETI), MASAŽE, CUPPING из прайса удалены. Страниц услуг тоже больше нет: /fizikalna-terapija/, /masaze/, /pregled-fizijatra/, /shockwave-terapija/, /kineziterapija/, /cupping-terapija-hidzama/ отдают 301 на главную или на вложения; в wp-json/pages их нет. Из «Naš tim» убраны физиатры dr Dragana Radunović и dr Marina Delić и три физиотерапевта.

| Запись каталога | Цена у нас | В мае |
|---|---|---|
| Prvi pregled fizijatra `svc:first-physiatrist-examination` | 50 | Specijalistički pregled fizijatra €50 |
| Kontrolni pregled fizijatra `svc:follow-up-physiatrist-examination` | 40 | Kontrolni pregled fizijatra €40 |
| Konsultacija sa fizijatrom `svc:physiatrist-consultation` | 10 | Konsultacije sa fizijatrom €10 |
| Intramuskularna injekcija `svc:intramuscular-injection` | 15 | Intramuskularna injekcija – aplikacija sa lijekom €15 |
| Elektroterapija `svc:electrotherapy` | 15 | Elektroterapija €15 |
| Laseroterapija `svc:laser-therapy` | 15 | Laseroterapija €15 |
| Ultrazvučna terapija `svc:ultrasound-therapy` | 15 | Ultrazvučna terapija €15 |
| Magnetoterapija `svc:magnetic-therapy` | 15 | Magnetna terapija €15 |
| Ultrazvučna terapija sa analgetikom `svc:ultrasound-therapy-with-analgesic` | 20 | Ultrazvučna terapija sa analgetikom €20 |
| Suvo iglanje `svc:dry-needling` | 25 | Dry needling terapija €25 |
| Terapija udarnim talasima `svc:shock-wave-therapy` | 15 | Shockwave terapija €15 |
| Silver paket – fizikalna terapija 10 tretmana `svc:physical-therapy-silver-package-10-treatments` | 200 | Silver paket – fizikalna terapija … 10 tretmana €200 |
| Gold paket – fizikalna terapija 10 + kineziterapija 5 tretmana `svc:physical-therapy-gold-package-15-treatments` | 300 | Gold paket – fizikalna terapija 10 tretmana + kineziterapija 5 tretmana €300 |
| Platinum paket – fizikalna terapija 10 + kineziterapija 5 + masaža 5 `svc:physical-therapy-platinum-package-20-treatments` | 350 | Platinum paket – fizikalna terapija x10 + kineziterapija x5 + masaža bolne regije x5 €350 |
| Shockwave terapija 10 tretmana `svc:shockwave-therapy-package-10-treatments` | 100 | Shockwave terapija 10 tretmana €100 |
| Kineziterapija – 30 min. `svc:kinesiotherapy-30-min` | 20 | Kineziterapija – 30 min. €20 |
| Kineziterapija – 45 min. `svc:kinesiotherapy-45-min` | 25 | Kineziterapija – 45 min. €25 |
| SCHROTH metoda – 45 min. `svc:schroth-method-45-min` | 25 | SCHROTH metoda – 45 min. €25 |
| SCHROTH metoda 45 min. – drugo dijete iz porodice `svc:schroth-method-45-min-second-child` | 20 | SCHROTH metoda – 45 min. za drugo dijete iz porodice €20 |
| Kineziterapija 30 min. – paket 10 tretmana `svc:kinesiotherapy-30-min-package-10-treatments` | 150 | VJEŽBE PAKETI › Kineziterapija – 30 min. €150 |
| Kineziterapija 45 min. – paket 10 tretmana `svc:kinesiotherapy-45-min-package-10-treatments` | 200 | VJEŽBE PAKETI › Kineziterapija – 45 min. €200 |
| SCHROTH metoda – paket 10 tretmana `svc:schroth-method-package-10-treatments` | 250 | VJEŽBE PAKETI › SCHROTH metoda – 45 min. €250 |
| SCHROTH metoda drugo dijete – paket 10 tretmana `svc:schroth-method-second-child-package-10-treatments` | 200 | VJEŽBE PAKETI › SCHROTH metoda – 45 min. za drugo dijete €200 |
| Visceralna osteopatija `svc:visceral-osteopathy` | 30 | Visceralna osteopatija €30 |
| Švedska terapeutska masaža 30 min. `svc:swedish-therapeutic-massage-30-min` | 25 | Švedska terapeutska masaža 30 min. €25 |
| Švedska terapeutska masaža 45 min. `svc:swedish-therapeutic-massage-45-min` | 30 | Švedska terapeutska masaža 45 min. €30 |
| Švedska terapeutska masaža 60 min. `svc:swedish-therapeutic-massage-60-min` | 45 | Švedska terapeutska masaža 60 min. €45 |
| Masaža trudnica 30 min. `svc:pregnancy-massage-30-min` | 20 | Masaža trudnica 30 min. €20 |
| Masaža trudnica 45 min. `svc:pregnancy-massage-45-min` | 30 | Masaža trudnica 45 min. €30 |
| Sportska masaža 30 min `svc:sports-massage-30-min` | 30 | Sportska masaža 30 min. €30 |
| Sportska masaža 45 min `svc:sports-massage-45-min` | 40 | Sportska masaža 45 min. €40 |
| Sportska masaža 60 min `svc:sports-massage-60-min` | 50 | Sportska masaža 60 min. €50 |
| Manuelna limfna drenaža 30 min. `svc:manual-lymphatic-drainage-30-min` | 30 | Manuelna limfna drenaža 30 min. €30 |
| Manuelna limfna drenaža 40 min. `svc:manual-lymphatic-drainage-40-min` | 40 | Manuelna limfna drenaža 40 min. €40 |
| Manuelna limfna drenaža 60 min. `svc:manual-lymphatic-drainage-60-min` | 60 | Manuelna limfna drenaža 60 min. €60 |
| Suva hidžama – leđa `svc:dry-cupping-back` | 30 | Dry cupping (suva hidžama) leđa €30 |
| Vlažna hidžama – leđa `svc:wet-cupping-back` | 40 | Wet cupping (vlažna hidžama) leđa €40 |
| Hidžama – cijelo tijelo `svc:cupping-full-body` | 60 | Cupping cijelo tijelo €60 |

### Терапия, эндокринология, пульмология, УЗИ — 18

Разделы INTERNA MEDICINA, ENDOKRINOLOGIJA, PULMOLOGIJA, ULTRAZVUČNI PREGLEDI из прайса удалены, из меню сайта тоже. /pregled-interniste/ и /pregled-endokrinologa/ отдают 301 на главную. Страницы /interna-medicina-1/, /kardioloski-pregled/, /holter/, /ultrazvucni-pregledi/, /ultrazvuk-*/, /dopler-krvnih-sudova/ ещё опубликованы, но цен на них нет, и ссылаются они только друг на друга (сироты, правились 2026-06-02 и 2026-07-17). Из «Naš tim» убран dr Borislav Mandić (терапевт, эндокринолог).

| Запись каталога | Цена у нас | В мае |
|---|---|---|
| Internistički pregled `svc:internist-examination` | 50 | Specijalistički pregled interniste €50 |
| Pregled interniste sa EKG-om `svc:internist-examination-with-ecg` | 60 | Specijalistički pregled interniste sa EKG-om €60 |
| Kontrolni internistički pregled `svc:follow-up-internist-examination` | 40 | Kontrolni pregled interniste €40 |
| EKG `svc:ecg` | 15 | EKG (bez kompletnog ljekarskog pregleda) €15 |
| Pregled endokrinologa `svc:endocrinologist-examination` | 50 | Specijalistički pregled endokrinologa €50 |
| Pregled endokrinologa sa ultrazvukom štitne žlijezde `svc:endocrinologist-examination-with-thyroid-ultrasound` | 90 | Specijalistički pregled endokrinologa sa UZ štitaste žlijezde €90 |
| Kontrolni pregled endokrinologa `svc:follow-up-endocrinologist-examination` | 40 | Kontrolni pregled endokrinologa €40 |
| Pregled pulmologa `svc:pulmonologist-examination` | 50 | Specijalistički pregled pulmologa €50 |
| Kontrolni pregled subspecijaliste pulmologa `svc:follow-up-pulmonologist-examination` | 40 | Kontrolni pregled pulmologa €40 |
| Ultrazvuk mekih tkiva `svc:soft-tissue-ultrasound` | 50 | UZ mekih tkiva €50 |
| Ultrazvuk štitne žlijezde `svc:thyroid-ultrasound` | 50 | UZ štitaste žlijezde €50 |
| Ultrazvuk dojki `svc:breast-ultrasound` | 50 | UZ dojki €50 |
| Ultrazvuk abdomena i bubrega `svc:abdomen-and-kidney-ultrasound` | 50 | UZ abdomena i bubrega €50 |
| Ultrazvuk donjeg dijela abdomena `svc:lower-abdomen-ultrasound` | 50 | UZ male karlice €50 |
| Ultrazvuk jednog zgloba `svc:orthopedic-ultrasound-single-joint` | 50 | UZ zgloba €50 |
| Dopler krvnih sudova `svc:blood-vessels-doppler` | 50 | Dopler krvnih sudova €50 |
| Kontrolni ultrazvučni pregled `svc:follow-up-ultrasound-examination` | 40 | Kontrolni UZ pregled €40 |
| Ultrazvučni pregled više segmenata `svc:multi-segment-ultrasound-examination` | 80 | UZ pregled više segmenata €80 |

### Эпиляция всего лица (жен.) — 1

В таблице эпиляции нет строки «cijelo lice» ни сейчас, ни в снимке 2026-05-14 (13 женских зон, все остальные у нас есть). На /laserska-epilacija/ цен нет. Откуда строка пришла при импорте 2026-04-16, установить не удалось.

| Запись каталога | Цена у нас | В мае |
|---|---|---|
| Laserska epilacija – cijelo lice (žene) `svc:laser-hair-removal-full-face-women` | 50 | — (нет и в мае) |

## 4. На сайте есть, у нас нет

| Название на сайте | Цена | Решение |
|---|---|---|
| DERMATOVENEROLOGIJA › Kontrolni dermoskopski pregled | 50 | новая запись каталога `svc:follow-up-dermatologist-examination-with-dermatoscopy` |
| DERMATOVENEROLOGIJA › Dermatološki pregled sa biopsijom kože i analizom uzorka | 150 | существующая запись Biopsija kože sa patohistološkim nalazom `svc:skin-biopsy-with-histopathology-report` |
| AKCIJSKI PAKETI › LASERSKA EPILACIJA › Laserska epilacija nogu i intimne regije 6 tretmana | 312 | новая запись каталога `svc:laser-hair-removal-legs-and-intimate-area-package-6-treatments` |
| AKCIJSKI PAKETI › LJETNJI Anti Aging & Fresh Skin PAKET — «Ljetnji reset za lice, kožu i sigurniji osjećaj tokom ljeta» | 640 | не заводим: сезонная акция, все три процедуры есть отдельными строками |

## Новые записи каталога

| name_en | name_sr | Категория / специальность |
|---|---|---|
| Follow-up Dermatologist Examination with Dermatoscopy | Kontrolni pregled dermatologa sa dermatoskopijom | 24 / 7 |
| Laser Hair Removal Legs and Intimate Area Package 6 Treatments | Laserska epilacija nogu i intimne regije – 6 tretmana | 24 / 7 |

## Заметки

- «Filer 1ml (Neauvia, Helene) €530» на сайте — опечатка третьей строки, должно быть 3 ml (в мае «Fileri 3ml (Neauvia/Helene) €530»). Сопоставлено с `hyaluronic-fillers-3ml`.
- На /lola-tretman/ две цены: «Redovna cijena 220€» в шапке и промоблок «Redovna cijena 250€ / Vaša cijena 225€» ниже. В прайсе 2026-09-30 — 220, её и берём. На летней странице «RRS HA Long Lasting Skin Booster» (это та же процедура LOLA) стоит 250 — июльская цена.
- К клинике в БД привязаны 9 человек, в «Naš tim» на 2026-09-30 из них трое (Lagator, Bošković, Biro) и медсестра Marija Vešović (у нас её нет). В мае там были ещё Borislav Mandić (терапевт, эндокринолог), Dragana Radunović и Marina Delić (физиатры) и физиотерапевты Mapp Miloš Kuzmanović, Milena Marković, Anja Asanović — все шестеро убраны вместе с разделами. Врачей этот SQL не трогает.
- Попутно: у `dermatologist-examination-with-dermatoscopy` (2311) специальность 14 (пульмонология) вместо 7 (дерматовенерология). Этот SQL её не правит.
