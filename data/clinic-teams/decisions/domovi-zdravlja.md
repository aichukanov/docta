# Группа domovi-zdravlja: дома здоровья (кроме ДЗ Подгорица), решения 2026-10-06

Сверка составов врачей с сайтами. Все сайты перепроверены curl'ом 2026-10-06 по `teamSources` из `map.json`: сырой HTML, wp-json, `?rest_route=`. Где сайт менялся, смотрели снимки Wayback.

SQL: `server/sql/update-doctors-2026-10-domovi-zdravlja.sql`. Прогнан локально в транзакции: первый прогон — 313 строк, второй — 0, затем ROLLBACK. В файле нет числовых id: клиники, врачи и специальности указаны только по slug или name. Все новые slug проверены и локально, и на проде (`/api/doctors/details`): таких врачей нет нигде. Состав врачей всех 10 клиник на проде совпадает с локальной базой (`/api/doctors/list`).

| Клиника | Отвязано | Привязано существующих | Создано | Было → стало |
|---|---|---|---|---|
| dom-zdravlja-herceg-novi | 4 | 1 | 42 | 4 → 43 |
| dom-zdravlja-budva | 5 | 0 | 3 | 37 → 35 |
| dom-zdravlja-tivat | 9 | 0 | 3 | 25 → 19 |
| dom-zdravlja-bar | 0 | 0 | 1 | 39 → 40 |
| dom-zdravlja-dimitrije-dika-marenic-danilovgrad | 0 | 0 | 0 | 15 → 15 |
| dom-zdravlja-bijelo-polje | 0 | 0 | 1 | 42 → 43 |
| dom-zdravlja-bosko-dedeic-mojkovac | 0 | 0 | 8 | 2 → 10 |
| dom-zdravlja-kolasin | 0 | 0 | 7 | 15 → 22 |
| dom-zdravlja-andrijevica | 0 | 0 | 5 | 0 → 5 |
| dom-zdravlja-kotor | 0 | 1 | 3 | 33 → 37 |
| **Итого** | **18** | **2** | **73** | |

Перепривязок нет: сетей с филиалами в группе нет.

После отвязки без клиник остаются четверо: `sladjana-strahinic`, `svetlana-slavkovic`, `veselin-vusurovic`, `vesna-milutinovic`. Их не удаляем и не скрываем, это решение юзера. Строк в `clinic_medical_service_doctors` у отвязанных врачей нет, но `DELETE` для этих клиник в файле всё равно стоит.

## Единые правила специальностей

- **Izabrani doktor za odrasle** — `general_medicine`. Если сайт пишет «spec. porodične medicine» — `family_medicine`, так уже сделано в Котор, Бело-Поле и Будве. «Spec. opšte medicine» тоже остаётся `general_medicine`.
- **Izabrani doktor za djecu** — `pediatrics`.
- **Izabrani doktor za žene** — `gynecology_obstetrics`. Когда сайт явно называет врача «doktor medicine» без специализации, добавляется ещё `general_medicine`. Так уже записана Bojana Vuković в ДЗ Бар.
- **ХЭС, эпидемиолог, гигиенист** — `infectious_diseases`. Так записаны Lalović (Будва), Mršulja (Тиват), Jeknić и Erović (Бело-Поле).
- **Спортивная медицина** — `general_medicine`, как у Marinković (Бар).
- **Логопед** — `speech_therapy`, **психолог** — `psychology`, **физиотерапевт** — `Physiotherapy`. Такие специалисты в БД уже есть у ДЗ Бар и ДЗ Котор.
- Специализанты не заводятся. Уже привязанных специализантов (Anđela Milić, Jelena Zekić и др. в Будве) не трогаем.
- `position` ставится по формулировке сайта, у существующих привязок не меняется.

## dom-zdravlja-herceg-novi

**Источник.** Еженедельный пост «Raspored rada izabranih doktora 05.10.–11.10.2026» (wp-json post 4376, modified 2026-10-04). Это более свежая редакция, чем в карте (28.09–04.10).

**Отвязано (4).** Ни в одном из постов-расписаний этих врачей нет. Все четверо работают в ОБ Котор, привязки к ней сохраняются.
- `ana-penda`
- `darko-topic`
- `milos-milic`
- `milovan-radosavljevic`

**Привязан существующий (1).** `oliver-adrovic` — ортопед Специальной больницы Рисан, по четвергам принимает в «Ortopedska ambulanta». Полный тёзка с той же специальностью.

**Создано (42).**
- Педиатры (5): Maja Popović, Nataša Milović, Dragan Maksimović, Dragana Knežević, Olivera Mentović.
- Izabrani za odrasle (11): Vesna Kovač, Tanja Zgradić, Sanja Čeprnić, Sanja Topić, Nenad Jeremić, Marija Stanišić, Zinaida Miljković, Danka Krivokapić, Tamara Piljević, Goran Komar, Ana Popović. Ana Popović заведена как `ana-popovic-2`: slug `ana-popovic` занят дерматологом КЦЦГ, `popovic-ana` — кардиологом Codra. Это разные люди.
- Гинекологи (2): Alenka Srdanović, Ana Džakula Dosković.
- Амбулатории Игало и Биела (3): Đorđe Daničić, Gorčin Čvorović, Ksenija Vasileva.
- Пульмонологи (2): Darinka Kovačić, Emilija Nikolić. Nikolić появилась в расписании после среза карты.
- Психиатры (2): Sanela Kusturica, Jovica Dostinić.
- Радиологи (2): Igor Milinić, Mladen Perčinkovski.
- Микробиолог: Milo Zgradić.
- ХЭС (2): Stefa Glušac, Slađana Zgradić.
- Интернисты (3): Gordana Miludinović Stojanović, Danijela Ranđelović, Gordana Rajović.
- Хирург: Nenad Sekulić. Офтальмолог: Ljiljana Maksimović. Медицина труда: Aleksandra Kolundžić.
- Спортивная медицина: Jasmina Živković.
- Гемодиализ: Biljana Dapčević, `nephrology` (см. вопросы).
- Немедики центра для детей с особыми потребностями и физиотерапии (4): логопеды Filip Rajčević и Nikolina Tišma Knežić, психолог Jelena Pejović, Bobath-терапевт Valentina Buha (`Physiotherapy`).

Написание имён сверено по 85 постам-расписаниям. «Sladjana», «Randjelović» на сайте записаны через dj, в БД — через đ. «Miludinović» стоит во всех 85 постах, оставлено как на сайте. Gordana Stojanović из файла KCCG — генетик КЦЦГ, это другой человек, и slug у неё другой.

## dom-zdravlja-budva

**Источник.** `/spisak-ljekara` и страницы служб, все правлены 2026-07-28…08-22. Снимки Wayback: `/spisak-ljekara` от 2026-03-13 и `/izabrani-doktori-za-djecu` от 2026-05-18.

**Отвязано (5).**
- `ana-penda`, `lidija-krtolica`: на сайте их нет нигде, поиск по wp-json — 0.
- `sladjana-strahinic`, `vesna-milutinovic`: в списке от марта 2026 они были, в редакции 2026-07-28 их убрали. Это свидетельство ухода.
- `veselin-vusurovic`: в списках до мая 2026 был «Dr Veselin Vušurović spec pedijatrije i subspec neonatologije», в редакции 2026-07-28 его нет. Его место заняла Sandra Bošković.

**possibleMatch Veselin ↔ Velimir.** Это один человек. Официальный штатный список ДЗ Будва (до мая 2026) пишет **Veselin**. «Velimir» есть только в новости 2024 года, перепечатанной с RTV Budva, — опечатка ТВ. Имя в БД верное, не меняем.

**Создано (3).**
- Sandra Bošković — pediatrics.
- Dželadina Velinov — clinical_biochemistry.
- Bojan Vučinić — radiology.

**Не заведены.** 13 консультантов из docx 2024 года («Spisak zaposlenih konsultanata iz drugih ustanova»). Документ старый, это не штат ДЗ Будва. Уже привязанных Milić Petar и Pratljačić Dragan оставили как есть: в `dbOnly` их нет.

## dom-zdravlja-tivat

**Источник.** Страницы организационных единиц (wp-json) и график смен на главной за 05.10–11.10.2026.

**Отвязано (9).** На сайте нет ни одного из них, поиск по wp-json pages и posts — 0.
- `ana-penda`
- `bojan-vucetic`
- `igor-bjeladinovic`
- `jelena-pajcin`
- `jelena-perunovic`
- `lidija-krtolica`
- `milica-vusurovic`
- `nevenka-becir`
- `svetlana-slavkovic`

Директорка в интервью 2026-07 говорит, что сейчас главная проблема ДЗ — педиатрия, а специалисты по интерне и радиологии появятся только в следующем году. Это сходится с отсутствием Vušurović, Bećir и радиологов. Все, кроме Slavković, остаются привязаны к ОБ Котор.

**Создано (3).**
- Nada Kovačević — Prim. dr, general_medicine.
- Ljiljana Soković — general_medicine.
- Sanela Preljević Gašanin — pediatrics.

**Не тронуто.**
- «Dr M.Ryzhov» из графика смен — это наш `mihail-rizov`, сербская транслитерация Рыжов. Уже привязан.
- «Dr A.Rakočević» был только в графике предыдущей недели, с одним инициалом. Личность не установить, в текущем графике его нет — не заведён.

## dom-zdravlja-bar

**Создано (1).** Sonja Mitrović — pulmonology, Centar za plućne bolesti i TBC.

**Не тронуто (3 db_only из карты).**
- `momira-vukelic` есть на подстранице `/centar-za-prevenciju/savjetovaliste-za-djecu` как «dr Momira Vukelić, spec. pedijatar».
- `snezana-barjaktarovic-labovic` есть на `/savjetovaliste-za-prevenciju-hiv-aids` как «sub.spec. higijene». Карта эти подстраницы не смотрела.
- `milenka-vranes-grujicic` (медицина труда): на странице «Medicina rada» имён нет вообще, отсутствие не доказательство. Её нет и в docx о dopunskom radu 2025–2026.

## dom-zdravlja-dimitrije-dika-marenic-danilovgrad

**Не тронуто.**
- `djogo-aleksandar`: гостующий эндокринолог указан в расписании специалистов только специальностью («Endokrinolog — srijeda 13h»), без имени. Отсутствие не доказательство.
- `milica-sofranac`: страница педиатрии описывает смены без неё, но она без даты (Joomla © 2017). Уверенности нет, поэтому не отвязываем.

**Не добавлена.** Milena Dragović («ordinira u ZS Spuž», страница без даты). Тёзка с той же специальностью есть в свежих расписаниях ДЗ Подгорица (IDO май и выходные сентябрь 2026). Агент ДЗ Подгорица создаёт `milena-dragovic`. Скорее всего, врач перешла в Подгорицу, а страница Даниловграда устарела. Вынесено в вопросы.

## dom-zdravlja-bijelo-polje

**Свежесть источников.** Директор на сайте указан тремя разными людьми. Самая свежая — dr Sonja Veličković: она в шапке всего сайта и на `/o-nama/direktorica`, а сайт обновлялся новостями в сентябре 2026. Сводная таблица `/o-nama/doktori` с «Dobardžić Majda — DIREKTORICA» поэтому старше, чем живые списки izabranih. Это же видно по другим базам: Anđa Vuković Bulajić у нас психиатр Kerber, Ismihana Erović — педиатр ОБ Бело-Поле, Adisa Martinović — микробиолог ОБ Бело-Поле (в таблице ещё специализант).

**Создано (1).** Slobodan Nanevski — microbiology. Он есть не только в старой таблице, но и на странице службы `/centar-za-dijagnostiku`: «Doktor: Slobodan Nanevski spec. mikrobiologije».

**Не заведены (6).** Marina Mešter Kljajević, Anđa Vuković Bulajić, Nataša Ćorović, Snežana Jeremić, Ismihana Erović, Adisa Martinović. Их нет ни в одном живом списке, только в устаревшей таблице.

`dbOnly` у клиники пуст, отвязок нет.

## dom-zdravlja-bosko-dedeic-mojkovac

**Источник.** Посты `?p=225/228/229/232/240` через `index.php?rest_route=`, правлены 2026-06…07.

**Создано (8).**
- Izabrani za odrasle, general_medicine (5): Milovan Bogavac, Nataša Tmušić Bogavac, Marko Blažević, Sanja Baković Barac, Sanja Ćetković.
- Педиатр: Miloje Zejak.
- Гинеколог: Maja Vujisić, она же директорка с марта 2025.
- Психолог ЦМЗ: Tijana Stanić.

На страницах только командные фото с сёстрами — `photo_url` не ставили.

**Не заведён.** Adil Begović — специализант.

Minić и Strunjaš на месте.

## dom-zdravlja-kolasin

**Источник.** `/timovi-izabranih-ljekara/` (wp-json modified 2026-05-26).

**Создано (7).**
- Radovan Selić, Ksenija Popović — general_medicine.
- Milena Lalić, Jadranka Vučinić — family_medicine.
- Danka Marković — gynecology_obstetrics + general_medicine: izabrani za žene без специализации, рядом со «spec. ginekologije» Đurovićem.
- Ivan Đurović — gynecology_obstetrics.
- Nikola Damjanović — radiology.

**Не заведены.**
- Nađa Damjanović: в декрете, а её имя — среди новых специализантов КБЦ Беране с 01.10.2026.
- Anđela Šćepanović: «spec. zdravstvene njege», это медсестра.

**Не тронуто.** Все 15 наших врачей — приходящие консультанты из PDF 2022 года. Это не доказательство ухода, их не отвязываем.

## dom-zdravlja-andrijevica

**Источник.** wp-json posts, 100 последних постов 2024–2026.

**Создано (5).**
- Izabrani za odrasle, general_medicine (3): Anđelija Popović, Veselinka Paunović, Džemail Gilić. Anđelija — по посту 2026-07-10 («Anđelijom»), в посте 2026-09-06 опечатка «Ađelija».
- Danijela Đekić — izabrani za djecu, pediatrics.
- Jugoslav Račić — izabrani za žene, gynecology_obstetrics.

**Не заведены.**
- Nađa Radević: временная замена из КБЦ Беране в 2025 году.
- Željko Božović: частная стоматология-партнёр.
- Budimir Ivanović: трансфузиология Беране.
- Dragana Vučević: депутат.
- Rajko Karličić: умер.

## dom-zdravlja-kotor

**Источник.** Таблицы служб (wp-json, правлены 2025-07…09).

**Создано (3).**
- Aleksandar Stjepčević, Anela Moco — general_medicine.
- Dijana Božović — физиотерапевт, Physiotherapy.

**Привязан существующий (1).** Kristina Mašanović, молекулярный биолог Centar za mikrobiološku dijagnostiku. Запись `masanovic-kristina` (molecular_biology) уже есть у Milmedika Budva.

**Не тронуто.**
- Dejana Ašanin Ivezaj (интернист, новость 2026-08) — это наш `dejana-asanin`, уже привязана.
- Все 14 db_only: у сайта `dbOnlyCaveat` — консультанты не публикуются.

## Вопросы

- Milena Dragović (ДЗ Даниловград, ZS Spuž, страница без даты) и `milena-dragovic` из файла ДЗ Подгорица (IDO 2026) — один человек? Варианты: (а) один, перешла в Подгорицу — Даниловград не привязывать (сейчас так); (б) работает в обоих — добавить привязку к Даниловграду.
- Biljana Dapčević (ДЗ Херцег-Нови, «Odjeljenje hemodijalize», специальность на сайте не указана). Варианты: (а) nephrology (сейчас так); (б) internal_medicine; (в) general_medicine — как Tošić на гемодиализе в Будве.
