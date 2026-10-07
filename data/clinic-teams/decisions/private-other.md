# Группа private-other: небольшие частные клиники

Синхронизация `doctor_clinics` с сайтами клиник по карте `data/clinic-teams/map.json`
(срез 2026-10-02). Все источники перепроверены curl'ом 2026-10-06: сырой HTML, wp-json,
JS-бандлы, у Masoničić — изображение графика работы. Составы прода и локальной базы
совпадают по всем 25 клиникам (`/api/doctors/list`).

SQL: `server/sql/update-doctors-2026-10-private-other.sql`. Прогнан локально в транзакции
дважды: первый прогон изменил 145 строк, второй — 0, потом ROLLBACK.

| Клиника | Отвязано | Привязано существующих | Создано новых | Было → стало |
|---|---|---|---|---|
| A3 Medical (Sutomore) | 2 | 1 | 2 | 17 → 18 |
| Bonomedica (Budva) | 4 | 1 | 0 | 14 → 11 |
| Dnevna bolnica Optimal | 0 | 0 | 0 | 1, не тронута |
| Svjetlost (Budva) | 0 | 0 | 1 | 5 → 6 |
| Normedica (Herceg Novi) | 1 | 1 | 0 | 7 → 7 |
| Codra Hospital | 0 | 2 | 0 | 89 → 91 |
| Humana reprodukcija | 1 | 1 | 1 | 8 → 9 |
| Dukley Dental | 0 | 0 | 2 | 2 → 4 |
| Apolonia Rašović | 2 | 0 | 0 | 6 → 4 |
| Dr Zejnilović | 1 | 0 | 1 | 14 → 14 |
| Medical Centar Budva | 1 | 0 | 1 | 8 → 8 |
| Poliklinika Dr Masoničić | 0 | 4 | 4 | 1 → 9 |
| Ordinacija Balans (Nikšić) | 0 | 3 | 5 | 3 → 11 |
| Spa Medica | 0 | 2 | 3 | 0 → 5 |
| Luca Medical | 0 | 1 | 1 | 14 → 16 |
| Oftalmološki centar Dr Raonić | 0 | 4 | 0 | 4 → 8 |
| Dr Filimanović | 0 | 0 | 0 | 6, не тронута |
| Doktorica Mica | 1 | 0 | 0 | 22 → 21 |
| Medtim | 0 | 0 | 1 | 16 → 17 |
| Ars Medica (специальная больница) | 0 | 0 | 1 | 15 → 16 |
| Ars Medica (стоматология) | 0 | 0 | 2 | 5 → 7 |
| Mansa Medica | 0 | 0 | 0 | 5, не тронута |
| Stomatološka ordinacija Mušura | 1 | 0 | 0 | 6 → 5 |
| iPodo | 0 | 0 | 0 | 1, не тронута |
| Novi Standard | 0 | 0 | 0 | 15, не тронута |
| **Итого** | **14** | **20** | **25** | |

Перепривязок нет: у этих клиник нет филиалов в нашей БД.

У отвязанных врачей строк в `clinic_medical_service_doctors` у этих клиник нет. SQL всё равно
удаляет их на случай, если на проде они есть.

Без клиник после прогона остаются 6 врачей: Dilinov Dmitrii, Bojović Svetlana,
Homjakova Tatjana, Zakirova Marija, Vinogradov Oleg, Nikola Mušura. Их не удаляли и не скрывали
(решение юзера).

## A3 Medical (Sutomore)

Источники: главная ME/RU/EN, `/me/surgicaloncology`, страницы специальностей, `/me/pricelist/`.

- **Отвязаны:** Dilinov Dmitrii (уролог) и Kolmakov Aleksandar (сосудистый хирург). Их нет ни в одной
  языковой версии. У Kolmakov остаётся ДЗ Будва.
- **Создан Obrad Vujadinović:** general_surgery и thoracic_surgery. На `/me/surgicaloncology` он
  «specijalista opšte i supspecijalista grudne hirurgije».
- **Создан Bojan Kovačević, prof. dr:** general_surgery. Он есть только в прайсе: «Specijalistički
  pregled prof. dr Bojana Kovačevića» в разделе «Specijalistički pregled hirurga». Специальность
  выведена из раздела.
- **Привязан существующий Nebojša Crnogorac** (`nebojsa-crnogorac`, работает в Ars Medica и Hirurgija
  dr Eli). На сайте он «onkološki hirurg, specijalista za hirurgiju dojke», поэтому к general_surgery
  добавлены oncologic_surgery и mammology.

## Bonomedica (Budva)

Источник — `/doktori/`, опубликован 2026-09-18, на странице 11 врачей.

- **Отвязаны:**
  - Ana Penda — у неё остаются SmartMed, ДЗ и ОБ Котор;
  - Bojović Svetlana — клиник больше нет;
  - Toma Nišavić — остаются Hipokrat и КЦЦГ;
  - Vasko Roganović — остаётся ДЗ Будва.
- **Привязана существующая Aida Kovačević** (`aida-kovacevic`, кардиолог Medicus Tim). На сайте
  она «specijalista interne medicine, subspecijalista kardiologije». Полная тёзка с той же
  специальностью.

## Dnevna bolnica Optimal (Podgorica)

Сайт заброшен: шаблон 2016 года, все загрузки 2016/02–04. Список врачей явно старый, поэтому
Paškovski, Files-Bradarić и Gargović **не заведены**. Sergej Alpatov остаётся: dbOnly пуст.

## Svjetlost Eye Clinic (Budva)

- **Создана Nada Džaković:** ophthalmology, фото с сайта. Она есть только в блоке «Naš tim» на
  `/o-nama/`, рядом с Gabrić, без специальности. Клиника офтальмологическая, других данных нет.
- Пятеро загребских врачей на `/nasi-doktori/` совпадают с нашими.

## Normedica (Herceg Novi)

На `ljekari.html` (правка 2026-08-04) три интерниста. Карточка Milica Subotić спрятана в
HTML-комментарии — считаем, что она ушла (у нас её и не было). При этом с главной ссылаются
страницы хирургии, урологии, ортопедии, ревматологии, пульмонологии и дерматологии без имён
врачей. Значит, список на `ljekari.html` полный не по всем направлениям.

- **Отвязана Homjakova Tatjana** (кардиолог). Страница кардиологии (правка 2026-08-04) называет
  единственного кардиолога — Prof. dr Olivera Đokić.
- **Не тронуты:**
  - Darko Topić (хирург/уролог) — у хирургии и урологии на сайте нет имён;
  - Dušan Mustur (физиатр);
  - Bjeković Tatjana (анестезиолог) — для гастро- и колоноскопии «sa anestezijom» нужен
    анестезиолог, а анестезиологов сайты не публикуют.

  Их отсутствие на сайте ничего не доказывает.
- **Привязана существующая Saška Grupković** (`grupkovic-saska`, радиолог Milmedika). Страница
  «Centar za hipertenziju» (2023, на неё ссылается текущая главная): «U Centru rade … Dr Saska
  Grupkovic Radiolog».
- **Andrijana Kostić не заведена** — вопрос. Она на той же странице («Internista-Kardiolog»).
  У нас есть `mirkovic-kostic-andrijana`, кардиолог в Ars Medica и Milmedika Nikšić: возможно, это
  она, но по сайту личность не установить.

## Codra Hospital (Podgorica)

wp-json CPT `member`, в ME-версии 90 записей.

- **Привязаны существующие:**
  - Batrić Vukčević (`batric-vukcevic`, хирург КЦЦГ и Konzilijum) — на Codra «Specijalista opšte
    hirurgije, od 2024 specijalista u KCCG»;
  - Boris Dašić (`boris-dasic`, хирург КЦЦГ и ОБ Беране) — профиль без специальности, тот же
    хирург.
- У Ljiljana Bobić три профиля на сайте, у нас одна запись — ничего не делали.
- `tamara-milenkaya` уже переименована.

## Humana reprodukcija (Budva)

Источник — `/me/s/tim`.

- **Отвязан Darko Topić:** его нет на сайте. У него остаются ОБ Котор, ДЗ Херцег-Нови, Risan и
  Normedica.
- **Привязан существующий Željko Lazović** (`lazovic-zeljko`, гинеколог Danilo, Natal и Milmedika
  Nikšić). На Humana «specijalista ginekologije i akušerstva, subspecijalista za fertilitet i sterilitet».
- **Создан Ivan Gazivoda:** anesthesiology. В заголовке карточки «Ivan Gzivoda», в тексте
  «Ivan Gazivoda, specijalista anesteziologije sa reanimatologijom… sa Cetinja». Записей Gazivoda
  Ivan в БД нет. Фото на сайте отдаёт 404, поэтому без фото.
- Milenko Tadić остаётся анестезиологом (решение юзера). Эмбриологи у нас уже есть, новых не
  заводили.

## Dukley Dental Clinic (Budva)

`partial_team`: сайт называет только двух врачей.

- **Созданы:**
  - Tihomir Jović — dentistry, position «Upravnik klinike». На сайте «Klinikom upravlja dr Tihomir
    Jović», пародонтолог, а специальности «пародонтолог» в справочнике нет;
  - Nikola Bogdanović — dentistry.
- Dubrovska Olga и Šabardina Olga **не отвязаны**: список на сайте неполный.

## Apolonia Rašović (Podgorica)

Источник — `/mne/team` и `/en/team`, RU-версия пустая.

- **Отвязаны** Poljakov Kiril и Zakirova Marija: их нет ни в одной языковой версии. У Poljakov
  остаётся Dental Expert Tivat.

## Dr Zejnilović (Bar)

Next.js: массив doctors лежит в JS-бандле, состав сверен с `sitemap.xml` — 13 врачей.

- **Отвязан Čavić Milorad** (гастроэнтеролог), остаётся КЦЦГ.
- Marko Stoiljkov **не отвязан**: в «Dopunski rad» ОБ Бар есть разрешение подрабатывать в PZU
  «Dr Zejnilović».
- **Создан Zoran Ivović:** urology. На сайте имя «dr Zoran Ivoić», а slug — `dr-zoran-ivovic`.
  «Ivoić» считаем опечаткой, Ivović — реальная фамилия.
- Nataša Jušković не тронута.

## Medical Centar Budva

Источники: `/me/strucni-tim`, `/me/poliklinika/*`.

- **Отвязан Vinogradov Oleg** (невролог): нигде на сайте нет, неврологии в меню нет.
- **Создана Milena Perošević, prim. dr sc.:** pediatrics и pediatric_gastroenterology. На
  `/me/poliklinika/pedijatrija`: «Od 09–17h ordinira Prim. dr sc. Milena Perošević pedijatar –
  gastroenterolog».

## Poliklinika Dr Masoničić (Bar)

Источники: `/nas-tim/`, `/team-group/nasi-konsultanti/` и график «Raspored rada septembar 2026»
(изображение, решение № 347 от 04.09.2026). Поста за октябрь ещё нет.

- **Привязаны существующие** (position «Konsultant»):
  - Emir Muzurović — эндокринолог;
  - Nikola Bakić — гематолог, он же в Balans;
  - Nikola Pavlović — кардиолог;
  - Olivera Bošković — эндокринолог.
- **Созданы:**
  - Mirko Šaranović — cardiology, «Konsultant». Карточка «Dr Šaranović Mirko» висит на
    `/team-members/dr-brick-wall/`. В БД есть только другие Šaranović (Đorđije, Mitar, Sandra);
  - Milena Kerić — radiology. Position не задан: на сайте она в консультантах, а в графике
    числится сотрудником («radiolog», в отпуске);
  - Svetlana Aligrudić — rheumatology и internal_medicine, «Konsultant»;
  - Anastasija Rudović — Physiotherapy. Она в графике на сентябрь 2026 как «fizioterapeut».
    Специальность 94 есть, физиотерапевты уже есть у Endorfin и ДЗ.
- Фото не ставили: картинки на страницах команды — общие фото клиники или заглушка-аватар.

## Ordinacija Balans (Nikšić)

Источник — слайдер «Naš tim» на главной. Специальности взяты из видимых подписей карточек.
Атрибуты `data-title` у слайдов устаревшие и сдвинуты на один.

- **Привязаны существующие** (все в Nikšić или Podgorica, специальность совпадает):
  - Sabahudin Pupović — подпись «Internista kardiolog», добавлена cardiology. Он же работает в
    Konzilijum и ОБ Никшич;
  - Andrija Vujović — подпись «Internista nefrolog», добавлена nephrology. Он же в ОБ Никшич;
  - Olivera Bojović — «Specijalista pneumoftiziolog», пульмолог больницы Brezovik в Nikšić.
- **Созданы:**
  - Biljana Savić — internal_medicine;
  - Vera Svorcan Đurđevac — radiology (видимая подпись «RADIOLOG», в `data-title` старое
    «reumatolog»);
  - Nada Krivokapić — Physical Medicine and Rehabilitation, с фото. На сайте «Dr … Spec. med.
    sporta», а спортивной медицины в справочнике нет. Ближайшая по смыслу — физикальная медицина
    в физикальном центре, старая подпись тоже «fizijatar»;
  - Marko Kovačević — Physiotherapy, с фото;
  - Ivana Kovačević — Physiotherapy. На её карточке сайт по ошибке повторяет текст «Marko
    Kovačević», но alt фото и имя файла — «Ivana Kovačević». Фото отдаёт 404.
- Milena Adžić (страница 2022) не заведена.

## Spa Medica (Podgorica)

Источник — `/wp-json/wp/v2/our-team`, 6 записей.

- **Привязаны существующие:**
  - Aleksandra Savić — физиатр КЦЦГ и ДЗ Колашин, та же специальность;
  - Igor Mandić — ортопед КЦЦГ, на сайте «stalno zaposlen u KCCG».
- **Созданы физиотерапевты** (Physiotherapy, «Bachelor primijenjene fizioterapije»): Andrija
  Damjanović и Sandra Bujiša с фото, Lidija Marinković без фото — на её карточке стоковое
  «employee-2».
- Ivana Kopitović («Fizioterapeutski tehničar», средняя медшкола) не заведена: техник.

## Luca Medical (Podgorica)

- **Привязана существующая Sanja Borozan** (эндокринолог, КЦЦГ и Zejnilović): страница
  `/dr-sanja-borozan/` есть в меню.
- **Создана Irena Šubarić:** pulmonology, фото со страницы `/dr-irena-subaric/`, которая есть в
  меню. В сетке «Naš tim» нет ни её, ни Borozan.
- Ana Nenezić остаётся. В сетке она есть, хотя её страница отдаёт 404.

## Oftalmološki centar Dr Raonić (Podgorica)

Источник — `/osoblje/`, правка 2026-09-14, плюс страницы-биографии. Все четверо — врачи КЦЦГ,
которые у нас уже есть.

- **Привязаны:**
  - Jelena Vuković (`jelena-vukovic`, pediatric_ophthalmology) — биография: «oftalmološka oboljenja
    djece i adolescenata, strabizam», добавлена ophthalmology;
  - Sabina Hasanagić;
  - Jelena Radović — «oftalmohirurg», добавлена ophtalmic_surgery;
  - Maja Đurović — «oftalmohirurg», добавлена ophtalmic_surgery.

## Dr Filimanović (Podgorica)

Ничего не меняли. Prof. dr Dejan Ćetković упомянут только на странице оральной хирургии 2023 года.
В полном списке команды (`/stomatolog-podgorica/`, правка 2026-01-23) его нет, оральный хирург
там Ivan Šoć. Считаем, что Ćetković не работает, и не заводим его. Sandra Đaletić остаётся и у
Barović.

## Doktorica Mica (pedijatrijski centar)

- **Отвязана Snežana Pavićević**, остаётся КЦЦГ. Её нет на `/nas-tim/` и `/our-team/` (правка
  2026-09-22). Психологов и логопеда трогать не пришлось — они уже есть.

## Medtim (privatna bolnica)

- **Создан Dejan Marinković:** endocrinology. Запись CPT `team` от 2026-07-21, «Endokrinolog
  Podgorica». Фото не ставили: файл называется `Dr.webp` и похож на заглушку.

## Ars Medica (специальная больница и стоматология)

- **Специальная больница — создан Prof. dr Aleksandar Ljubić:** gynecology_obstetrics и
  perinatology. Он есть только в EN-команде IVF: «gynaecology specialist, subspecialty in
  perinatology».
- **Стоматология — созданы Dražen Nikčević и Aleksa Raičković:** dentistry, оба с фото.
  - На `/stomatologija/nas-tim/` два варианта блока. По CSS Divi `.et_pb_row_6` (с Zoran Mirković
    в консультантах) скрыт на десктопе, а ряды 1–5 (с Raičković) скрыты на телефоне. Актуальным
    считаем десктопный блок и Raičković заводим.
  - Zoran Mirković остаётся: мобильный блок с ним всё ещё виден.
- Sascha A. Jovanovic (UCLA) и Bernard Touati (Paris) **не заведены**. Это зарубежные почётные
  консультанты в блоке «Konsultanti», не штат.
- Čabarkapa — эмбриолог, у нас уже есть.

## Mansa Medica (Tivat)

Не тронута. Сайт заброшен: Last-Modified 2020-03, домен из шапки не работает. Отвязку Natalija
Petranović не делаем: старый список не доказывает, что она ушла.

## Stomatološka ordinacija Mušura

- **Отвязан Nikola Mušura.** В команде `/me/nas-tim` его нет, на `/me/istorijat` он упомянут
  студентом. Клиник у него больше нет.

## iPodo

`partial_team`, имён нет — не тронута.

## Novi Standard

Бандл `index-CHoW9DRC.js` (Last-Modified 2026-08-19): 17 записей, из них 2 RTG-техника. С нашими 15
расхождений нет — ничего не делали.

## Созданные врачи

| slug | name_sr | специальности | клиника |
|---|---|---|---|
| obrad-vujadinovic | Obrad Vujadinović | general_surgery, thoracic_surgery | a3-medical-sutomore |
| bojan-kovacevic | Bojan Kovačević | general_surgery | a3-medical-sutomore |
| nada-dzakovic | Nada Džaković | ophthalmology | svjetlost-eye-clinic-budva |
| ivan-gazivoda | Ivan Gazivoda | anesthesiology | humana-reprodukcija-budva |
| tihomir-jovic | Tihomir Jović | dentistry | dukley-dental-clinic-budva |
| nikola-bogdanovic | Nikola Bogdanović | dentistry | dukley-dental-clinic-budva |
| zoran-ivovic | Zoran Ivović | urology | dr-zejnilovic-pzu-dnevna-bolnica |
| milena-perosevic | Milena Perošević | pediatrics, pediatric_gastroenterology | medical-centar-budva |
| mirko-saranovic | Mirko Šaranović | cardiology | poliklinika-dr-masonicic-bar |
| milena-keric | Milena Kerić | radiology | poliklinika-dr-masonicic-bar |
| svetlana-aligrudic | Svetlana Aligrudić | rheumatology, internal_medicine | poliklinika-dr-masonicic-bar |
| anastasija-rudovic | Anastasija Rudović | Physiotherapy | poliklinika-dr-masonicic-bar |
| biljana-savic | Biljana Savić | internal_medicine | ordinacija-balans-niksic |
| vera-svorcan-djurdjevac | Vera Svorcan Đurđevac | radiology | ordinacija-balans-niksic |
| nada-krivokapic | Nada Krivokapić | Physical Medicine and Rehabilitation | ordinacija-balans-niksic |
| marko-kovacevic | Marko Kovačević | Physiotherapy | ordinacija-balans-niksic |
| ivana-kovacevic | Ivana Kovačević | Physiotherapy | ordinacija-balans-niksic |
| andrija-damjanovic | Andrija Damjanović | Physiotherapy | spa-medica-podgorica |
| sandra-bujisa | Sandra Bujiša | Physiotherapy | spa-medica-podgorica |
| lidija-marinkovic | Lidija Marinković | Physiotherapy | spa-medica-podgorica |
| irena-subaric | Irena Šubarić | pulmonology | luca-medical-podgorica |
| dejan-marinkovic | Dejan Marinković | endocrinology | medtim-privatna-bolnica |
| aleksandar-ljubic | Aleksandar Ljubić | gynecology_obstetrics, perinatology | ars-medica-specijalna-bolnica |
| drazen-nikcevic | Dražen Nikčević | dentistry | ars-medica-dental-clinic |
| aleksa-raickovic | Aleksa Raičković | dentistry | ars-medica-dental-clinic |

## Вопросы

- **Andrijana Kostić (Normedica, «Internista-Kardiolog», Centar za hipertenziju):** это
  `mirkovic-kostic-andrijana` (кардиолог Ars Medica / Milmedika Nikšić) — привязать, завести
  отдельную запись или не заводить, раз страница 2023 года?

- **Andrijana Kostić** (Normedica, страница Centar za hipertenziju 2023) — не привязана (решение координатора 2026-10-06): в актуальном списке врачей Normedica её нет, источник 2023 года; то же правило, что для Ćetković у Filimanović.
