# КЦЦГ: решения по составу врачей (2026-10-06)

Клиника: Klinički centar Crne Gore, slug `klinicki-centar-crne-gore-podgorica` (id 65 локально и на проде).
SQL: `server/sql/update-doctors-2026-10-kccg.sql`.

## Источник и перепроверка

- `wp-json/wp/v2/pages`: все 102 страницы, `content.rendered`, сняты 2026-10-06.
- Расписания амбулаторий — `/poliklinika/*`. Основная `poliklinika-kccg` правлена 2026-10-06, IBD — 2026-04-29, онкология — 2026-04-03, стоматология — 2026-08-06.
- Контактные блоки руководителей — `/klinike-i-centri/*`, плюс `/o-nama/`.
- По сравнению со срезом карты (2026-10-02) новых имён на страницах поликлиник и клиник нет.
- Все 69 `siteOnly` найдены на сайте, кроме «Marija Delić»: она нашлась, когда текстовые файлы стали именоваться по id страницы. У `/poliklinika/stomatoloska-poliklinika/` и `/klinike-i-centri/stomatoloska-poliklinika/` одинаковый slug.

## Отвязано: 0

`dbOnlyIsEvidence = false`, `dbOnlyCaveat`: стационарных врачей без амбулаторного приёма сайт не публикует. Отсутствие врача на сайте ничего не значит, поэтому `dbOnly` не трогали.

## Привязано существующих: 18

Все 18 уже есть в БД у других клиник (врачи КЦЦГ подрабатывают в частных). Полный тёзка, специальность совпадает с отделением. Добавлена только строка `doctor_clinics` с `position`. На проде все 18 slug существуют, к КЦЦГ (65) не привязан ни один (проверено через `/api/doctors/details`).

| slug | Где у нас сейчас | position в КЦЦГ |
|---|---|---|
| danko-natalic | SmartMed (gyn, perinatology) | GAK, Centar za patologiju trudnoće, načelnik |
| zanka-cerovic | Hipokrat (radiology) | Radiologija, Odjeljenje za CT i MR, načelnica |
| muhedin-kadic | Moj Lab pedijatrija (pediatric ENT) | IBD, Operacioni blok, načelnik; Ambulanta za ORL |
| dragan-nesovic | Natal Kids (radiology) | IBD, Odjeljenje za radiološku dijagnostiku, načelnik |
| dijana-asanovic | Konzilijum (cardiology) | Klinika za kardiologiju, VD direktorica |
| bozovic-bjanka | Milmedika (cardiology) | Kardiologija, Odjeljenje poluintenzivne njege, načelnica |
| mihailo-vukmirovic | Luca (cardiology) | Kardiologija, Odjeljenje za poremećaje srčanog ritma, načelnik |
| gordana-globarevic-vukcevic | Medicus Tim (gyn) | GAK, Porodilište, načelnica. На сайте «Globarević», в новости — «Globarević Vukčević». |
| jelena-paunovic | Natal (gyn) | GAK, Akušersko odjeljenje, načelnica |
| milorada-nesovic | Doktorica Mića, Natal Kids (pediatrics, neonatology) | GAK, Odjeljenje neonatologije, načelnica |
| milos-obradovic | SmartMed, Kerber (gyn, oncology) | GAK, Odjeljenje za ginekološku patologiju, načelnik |
| marija-abramovic | Moj Lab (radiology) | Radiologija, Odjeljenje za konvencionalnu dijagnostiku, načelnica |
| vojislav-mandic | Natal, Novi Cenex (radiology, mammology) | Radiologija, Odjeljenje za dijagnostiku bolesti dojki, načelnik |
| dragomir-madzgalj | Kerber (gastro) | Poliklinika, Gastroenterohepatološka ambulanta |
| nikola-delevic | Kerber (allergology, immunology) | Poliklinika, Alergološka ambulanta |
| jelena-borovinic-bojovic | Natal (internal, pulmonology) | Poliklinika, Pulmološka ambulanta |
| aleksandra-furtula | Kerber, Novi Cenex (endocrinology) | Poliklinika, Endokrinološka ambulanta |
| miladinovic-mirjana | Codra (pathology) | Centar za patologiju, VD direktorica |

Специальности существующим врачам не меняли и не добавляли.

## Создано новых: 47

Все созданы по шаблону «найти или создать»: имя, имя в обратном порядке, slug. Язык у всех один, сербский. Фото на сайте нет, `photo_url` = NULL. Специальность выбрана по отделению или амбулатории. В `position` записаны отделение и должность, как их называет сайт. На проде ни одного из 47 slug нет (API отвечает 204).

Решения, которые требовали выбора:

- **Maša Raonić.** На сайте «Raonič» (č вместо ć), это опечатка. Записали Raonić.
- **Marija Delić = Maja Delić.** Один человек, у обеих записей один email `maja.delic@kccg.me`. Взяли «Marija Delić» с более новой страницы стоматологической поликлиники (2026-08).
- **Danijela Subotić, Zorica Stanišić, Lidija Krstajić Mijović, Tatjana Džarić** есть только на старой странице `/klinike-i-centri/stomatoloska-poliklinika/` (2025-07), там они načelnice. На новой странице (2026-08) начальниками названы Šahmanović (детская стоматология) и Biljana Milošević (протетика), у ортопедии челюстей и пародонтологии начальник не указан. Привязали всех четверых, но в `position` только отделение, без «načelnica».
- **Пародонтология** (Džarić): такой специальности в справочнике нет, поставили `dentistry`, как у Ana Bulatović.
- **Детская стоматология** (Šahmanović, Subotić): `dentistry` + `pediatric_dentistry`, как у остальных детских стоматологов в БД.
- **Лабораторная диагностика** (Terzić Stanić, Manđarelo): `clinical_biochemistry`, ближайшая специальность в справочнике.
- **Gordana Stojanović:** `genetics` + `immunology`. В анонсе лекции КМЕ она «spec. imunologije, supspec. kliničke genetike».
- **Iva Ivanović** (Centar za rani razvoj, direktorica): `psychiatry`. На сайте КЦЦГ специальность не указана, детский и подростковый психиатр она по материалу UNICEF.
- **Jelena Kovačević:** `psychiatry`. В карте указано «Odjeljenje za psihoze», это неверно: она начальник отделения дневного лечения детей и подростков. В анонсе КМЕ она «specijalista dječije psihijatrije».
- **Saša Raičević:** на `/o-nama/` он «Prof. dr, KCCG (predstavnik zaposlenih)», член Odbora direktora, специальности на сайте нет. По профилю на сайте UCG он гинеколог-акушер, поставили `gynecology_obstetrics`.
- **Tanja Nenezić** (Centar za patologiju, molekularne analize) — новая запись. В БД есть `drincic-nenezic-tanja`, кардиолог Milmedika: другая специальность, по регламенту это другой человек.
- **Lidija Banjac** (Centar za neonatologiju): `pediatrics` + `neonatology`, как у Milorada Nešović.
- **Mirjana Đurović** (Institut za onkologiju, brahiterapija): «specijalista radiologije, subspecijalista onkolog», поэтому `radiology` + `oncology`.
- **Genetics** (89) в БД пока без врачей, но специальность есть в enum и i18n.

## Не тронуто

- **Gordana Bašović** — это `gordana-ristic-basovic`: у обеих записей email `gordana.basovic@kccg.me`, она уже привязана к КЦЦГ. На странице онкологии она дважды: директор и начальник Centra za radioterapiju.
- **Goran Batrićević** не заведён. Он начальник Odjeljenja intenzivne njege на `hirurska-klinika` и `klinika-za-vaskularnu-hirurgiju-2`, но email у него в обоих местах `goran.sokovic@kccg.me`: имя или почта на сайте ошибочны. Специальность (интенсивная терапия при сосудистой хирургии: анестезиолог или хирург) не указана. Вопрос юзеру.
- **Ivana Čurović Šoškić** (Centar za sudsku medicinu) — судебная медицина. Такой специальности в справочнике нет, пациентов она не принимает. Не заведена.
- **Senad Kalač** (`senad-kalac`, `senad-kalac-2`) — по заданию не трогали.
- **dbOnly** — не трогали, см. выше.

## Попутно замечено (не правилось)

- `bozovic-bjanka`: в `name_sr` «Božovic Bjanka», без диакритики в фамилии. Правильно — Božović.
