# Группа networks: сети клиник с филиалами

Решения по синхронизации врачей Milmedika, Moj Lab, Hipokrat и Endorfin с сайтами.
Сайты перепроверены 2026-10-06. Прод на эту дату совпадает с локалью по составу всех
клиник группы (сверено через `/api/doctors/list`).

SQL: `server/sql/update-doctors-2026-10-networks.sql`. Прогнан локально в транзакции
дважды: первый прогон — 418 строк, второй — 0. Потом ROLLBACK.

## Milmedika

Источник — Sanity CMS (`k9l9g2jg.apicdn.sanity.io`, тип `doctor`, `language == "me"`,
104 записи). Привязки ставятся строго по `practiceLocation`. sitemap не использовался:
в нём 8 удалённых врачей, их `/biografija/*` отдают 404.

| Филиал | Было | Стало | Сайт |
|---|---|---|---|
| milmedika-podgorica | 41 | 39 | 39 |
| milmedika-niksic | 67 | 64 | 64 |
| milmedika-tivat | 33 | 35 | 35 |
| milmedika-budva | 29 | 29 | 29 |

**Отвязаны от всех филиалов: врачей нет в CMS (9).**

- Нет в CMS, `/biografija/*` отдаёт 404 (8): `albijanic-drago` (Podgorica, Nikšić), `colakovic-slavka`,
  `djurisic-borislav-miso`, `filipovic-aleksandar`, `milovanovic-tamara`, `radojicic-jelena`
  (все Nikšić), `gacevic-milomir` (Nikšić, Tivat), `natasa-vukotic-djuricanin` (Podgorica, Nikšić, Tivat).
- Не было в CMS никогда (1): `emil-nasufovic` (Nikšić). В его биографии на mojlab.me сказано:
  «2024–2026 konsultant urolog, Milmedika». Сейчас он в разделе Bolnica у Moj Lab.

Nataša Vukotić Đuričanin и Emil Nasufović ниже привязаны к Moj Lab.

**Перепривязаны по practiceLocation (10 врачей)**

| Врач | Снят | Добавлен | practiceLocation |
|---|---|---|---|
| `djordjevic-dikic-ana` | Nikšić | — | Podgorica |
| `drincic-nenezic-tanja` | Nikšić | — | Podgorica |
| `adzic-milena` | Tivat | — | Podgorica |
| `novosel-dusanka` | Tivat | — | Podgorica, Nikšić |
| `ivanovic-milos` | Tivat | Nikšić | Podgorica, Budva, Nikšić |
| `doknic-mirjana` | — | Tivat | Nikšić, Podgorica, Tivat |
| `miskulin-mladen` | — | Tivat | Nikšić, Tivat |
| `malisic-korac-marija` | — | Tivat | Budva, Tivat |
| `milica-vusurovic` | — | Nikšić, Tivat | Nikšić, Tivat (в БД уже был: SmartMed, ОБ Котор, ДЗ Тиват) |
| `branko-lutovac` | — | Nikšić, Tivat | Nikšić, Tivat (в БД уже был: КЦЦГ). Фото взято из Sanity, своего не было |

**Созданы (5).** Фото — внешние URL `cdn.sanity.io`.

- `predrag-matic` — doc. dr, vascular_surgery. Филиалы Nikšić и Tivat. Титул «Doc. dr» указан в биографии, в карточке стоит «Dr».
- `slobodan-vukanic` — gynecology_obstetrics. Nikšić, Tivat.
- `dobrila-radovanov` — pediatrics, genetics («subspecijalista kliničke genetike»). Nikšić.
- `predrag-stevanovic` — prof. dr, anesthesiology. Nikšić.
- `ilija-tripkovic` — prim. dr, general_surgery и gastrointestial_surgery (digestivna hirurgija). Nikšić.

**Не тронуто.** Остальные врачи совпадают с practiceLocation. Специализанты из CMS (Grujić,
Šturanović, Vasiljević) уже были в БД, их привязки совпадают с сайтом. Новых специализантов нет.

## Moj Lab

Источник — mojlab.me (Webflow):

- `/doktori`: 150 карточек, пагинация 1–2, третья страница повторяет вторую;
- все 150 страниц `/doktori/<slug>`;
- 55 страниц отделений `bolnica/*`, `poliklinika/*`, `pedijatrija/*` — по ним видно, к какому разделу относится врач;
- блок «Najave» на `/doktori` — анонсы приёмов с локацией.

Филиал сайт не называет. Привязки ставились по правилу из промпта:

- раздел Bolnica → `moj-lab-bolnica-podgorica`;
- раздел Pedijatrija → педиатрия. Город из биографии, иначе `moj-lab-pedijatrija-podgorica`;
- раздел Poliklinika → существующие привязки к поликлиникам не трогались. Врачу без привязки
  к поликлинике сети ставится `moj-lab-podgorica-1`, если биография или «Najave» не называют другой город.
- Карточки без отделения шли как Poliklinika. Исключение — лабораторные специалисты, см. ниже.
- Врачам раздела Bolnica, уже привязанным к поликлиникам, эти привязки оставлены. Добавлена
  только bolnica: у сайта нет данных, что поликлинику они не ведут.

| Клиника | Было | Стало |
|---|---|---|
| moj-lab-podgorica-1 (Dalmatinska) | 71 | 83 |
| moj-lab-podgorica-2 (Donja Gorica) | 0 | 0 — сайт её врачей не выделяет |
| moj-lab-budva | 25 | 23 |
| moj-lab-ulcinj | 8 | 5 |
| moj-lab-pedijatrija-podgorica | 16 | 25 |
| moj-lab-pedijatrija-budva | 0 | 1 |
| moj-lab-pedijatrija-ulcinj | 0 | 1 |
| moj-lab-bolnica-podgorica | 0 | 89 |
| moj-lab-laboratorija-budva | 0 | 1 |
| moj-lab-laboratorija-podgorica-moskovska | 0 | 4 |
| остальные 7 лабораторий | 0 | 0 |

**Отвязаны от всех клиник Moj Lab (17).** Этих врачей на сайте сети нет: ни в списке, ни на страницах отделений, ни в биографиях.

- `aleksandar-zekic`, `vesna-ivancevic` — были в Budva.
- `vojislav-vucetic` — Podgorica 1 и Budva.
- `miroslav-knezevic`, `valentina-vujovic` — Podgorica 1 и Ulcinj.
- Только Podgorica 1: `bojana-mijatovic-pavlovic`, `iva-tomasevic`, `ivan-popovic`, `marija-stolic`,
  `marko-music`, `milos-raspopovic`, `olivera-nikolic`, `slobodan-cirkovic`, `vera-djurisic`,
  `violeta-mihailovic-vucinic`, `zoja-stankovic`, `zoran-zikic`.

`marija-stolic` не путать со «Stolić» из графика Hipokrat: там Ilija Stolić, невролог.

**Переименование (possibleMatch).** Было `dijana-raceta-macic` «Dijana Račeta Mačić», стало
`dijana-raceta-masic` «Dijana Račeta Mašić».

- Написание «Mašić» подтверждают два источника: mojlab.me и список специалистов радиологии Медицинского факультета
  УЦГ (ucg.ac.me, «Spiska studenata.pdf», «9. Dijana Račeta Mašić — položila specijalistički ispit»).
- «Mačić» встречается только в имени файла фото на mojlab.me.
- Старый slug сохранён в `slug_redirects`.

**Перенесены в педиатрию своего города (2).**

- `dragica-becic`: снята поликлиника Budva, добавлены `moj-lab-pedijatrija-budva` и bolnica. В биографии:
  «Specijalista pedijatrije, Moj Lab Pedijatrija, Budva». Привязка к педиатрии Podgorica оставлена.
- `pavle-marnikovic`: снята поликлиника Ulcinj, добавлена `moj-lab-pedijatrija-ulcinj`. Он 23 года
  педиатр ДЗ Ulcinj, в 2012–2021 — его директор. Привязка к Ulcinj стояла вместо педиатрии,
  которой в БД не было. Привязка к педиатрии Podgorica оставлена.

**Существующим врачам добавлены привязки**

- bolnica — 61 врач, список в SQL. Все из раздела Bolnica.
  - Ни к одной клинике Moj Lab не были привязаны: `ana-music`, `damir-muhovic` (в биографии «Načelnik
    Poliklinike, Opšta bolnica Moj Lab»), `danojla-dakic`, `darko-nisavic`, `emil-nasufovic`,
    `ivanovic-jelena`, `maja-mirocevic-rotolo`, `maja-rabrenovic`, `marina-vukovic` (с 01.01.2026 в
    Bolnica Moj Lab, до этого Endorfin), `milenko-tadic`, `milorada-nesovic`, `rade-kovac`,
    `grupkovic-saska`, `sinisa-drekalovic`, `srdjan-medan`, `violeta-manovic`.
  - `bosko-cejovic` (specijalizant radiologije) уже был в БД и привязан к Podgorica 1, ему тоже добавлена bolnica.
- pedijatrija-podgorica (6): `aleksandra-brasnjo`, `darko-nisavic`, `goran-banjac`, `pekovic-dragana`,
  `tomo-plamenac`, `jelena-vukicevic`. У Vukićević карточка без отделения, но она педиатр-неонатолог.
- podgorica-1 (11) — раздел Poliklinika или карточка без отделения, привязки к поликлинике не было:
  `aleksandra-radojicic`, `ana-music`, `damir-muhovic`, `grupkovic-saska`, `muhedin-kadic`,
  `natasa-radovic`, `natasa-vukotic-djuricanin`, `nebojsa-jovanovic`, `rade-kovac`, `sasa-radovic`, `violeta-manovic`.
- budva (2):
  - `katica-raskovic` — вся карьера в ДЗ Budva/Petrovac, сейчас Medical Centar Budva;
  - `zlata-kovacevic` — в «Najave» приём 12 и 14 октября в «Poliklinika Budva».

**Специальности, исправленные по сайту**

- `dragan-sorat`: добавлена general_surgery, сняты internal_medicine и oncology. На сайте: «Specijalista
  opšte hirurgije», шеф абдоминальной хирургии Bolnice Moj Lab, в 2010–2023 хирург ОБ Цетине.
  Внутренняя медицина и онкология в БД ошибочны.
- `darko-nisavic`: добавлена orthopedics_traumatology. Была только pediatric_orthopedics.
- `muhedin-kadic`: добавлена otorhinolaryngology. Была только pediatric_ent, а на сайте он ORL во всех трёх разделах.
- `jelena-vukicevic`: добавлена neonatology.

**Созданы (45).** Полный список — в итоговом ответе и в разделе 5 SQL.

- Bolnica: 28. Из них 5 привязаны ещё и к Podgorica 1 — они есть и в разделе Poliklinika; 2 педиатра (Mavrić, Knežević) — ещё и к педиатрии Podgorica.
- Poliklinika: 11 только в Podgorica 1.
- Pedijatrija: 1 только в педиатрии Podgorica (Ida Jovanović), плюс 2 педиатра из строки Bolnica.
- Лаборатории: 5.
- Фото — внешние URL `cdn.prod.website-files.com`. У пяти на сайте заглушка (Blank.avif,
  placeholder.svg, общий photo.jpg), им `photo_url = NULL`: Baković, Dedeić, Kačar, Friščić, Gligorović Barhanović.
- Языки — только те, что указаны в биографиях. Пассивное знание не учитывалось.
- `balsa-stanisic` и `milos-jovanovic` создаёт и агент KCCG. Это те же сосудистые хирурги КЦЦГ,
  записи сойдутся по slug или имени.
- `cagatay-ozturk`: имя в турецком написании «Çağatay Öztürk», slug задан вручную. `generateSlug`
  выбросил бы ç, ğ, ö, ü.

**Лабораторные специалисты.**

- Врачи: `gordana-jelusic` (microbiology, «načelnica Mikrobiološke laboratorije, Moj Lab, Podgorica»),
  `marija-friscic` (clinical_biochemistry, биографии нет), `sladjana-anicic` (pathological_anatomy,
  «Moj Lab, Podgorica»). Привязаны к `moj-lab-laboratorija-podgorica-moskovska` — она соответствует
  `/lokacije/laboratorija-podgorica`.
- Магистры фармации, медицинские биохимики (mr ph):
  - `najdana-gligorovic-barhanovic` — «direktorica Laboratorije Poliklinike Moj Lab, Podgorica»,
    привязана туда же;
  - `ana-martinovic` — «PZU Moj Lab, Budva», привязана к `moj-lab-laboratorija-budva`.

  Таких специалистов в БД уже заводили: четыре mr ph clinical_biochemistry у SmartMed, один у Zejnilović.

**Не заведены.**

- Эмбриологи `andrijana-jovanovic` и `zorana-vucinic` — биологи, специальности в справочнике нет.
- Специализантов среди новых нет. Anja Magdelinić и Marija Radević в карточках указаны как врачи
  общей практики Moj Lab, хотя в биографиях у них специализация по патологии в КЦЦГ. Заведены как general_medicine.

**Не тронуто.**

- Остальные совпавшие привязки: Budva-врачи из биографий (Novićević, Medojević, Ljubiša Maslovar,
  Pejović, Marović, Vučetić, Jovović, Kustudić, Perišić) уже стоят в Budva.
- `moj-lab-podgorica-2`: сайт не называет ни одного врача Donja Gorica.
- `dragica-gudelj` / `dragica-gudelj-brezovik`: привязка идёт к первой записи, она уже была в Moj Lab.
  Один ли это человек, не проверялось — это вне группы.

## Hipokrat

Источники:

- `/hipokrat/doctors` — 27 врачей, общий список трёх филиалов;
- `/hipokrat/raspored` — график на 6–12.10.2026. В нём: Podgorica — Mikulić, Abdić, Nišavić, Stolić,
  Đurović; Radanovići — Popović, Stolić; Nikšić — Šćekić, Stolić.

| Филиал | Было | Стало |
|---|---|---|
| hipokrat-poliklinika-podgorica | 27 | 26 |
| hipokrat-poliklinika-radanovici | 28 | 23 |
| hipokrat-poliklinika-niksic | 27 | 24 |

**Отвязаны (5).** При перепроверке на сайте их нет.

- От всех трёх филиалов: `alma-crnovrsanin`, `dragan-masulovic`, `rade-kovac`, `vladan-cipovic`.
- От Radanovići: `lidija-krtolica`, другой привязки к Hipokrat у неё не было.

Crnovršanin и Kovač есть в Moj Lab, там их привязки сохранены.

**Привязаны существующие (2).**

- `nikola-luburic` → Podgorica. Радиолог: на сайте в разделе Radiologija, в БД радиолог Konzilijum и Risan. В графике его нет.
- `rade-scekic` → Nikšić по графику. На сайте он в разделе Hirurgija, где и нейрохирурги Popović и
  Đurović. В БД он нейрохирург Risan. С Rade Kovač (радиолог) это разные люди. Имя исправлено:
  «Sćekić» → «Šćekić», slug прежний.

**Созданы (2).** В графике недели их нет, поэтому привязаны к Podgorica. Фото на сайте — общая заглушка `(1).png`, поэтому NULL.

- `milos-veljkovic` — neurology.
- `radmila-ognjenovic` — neurology.

Остальные 23 врача привязаны ко всем трём филиалам. Так и оставлено: график показывает только 7 дней.

## Endorfin

Ничего не меняется. `/nas-tim/` (dateModified 2026-10-05) показывает те же 7 карточек, что и в БД.
Marina Vuković есть только в скрытой модальной биографии, карточки нет. Её биография на mojlab.me
подтверждает переход: «Endorfin … Od 1. januara 2026 — Bolnica Moj Lab». К Endorfin её не привязываем.
В БД она уже есть, её привязка к Moj Lab Bolnica — в разделе Moj Lab.
