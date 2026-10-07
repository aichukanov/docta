# Группа private-pg: крупные частные поликлиники Подгорицы

Синхронизация `doctor_clinics` с сайтами клиник по карте `data/clinic-teams/map.json`
(срез 2026-10-02). Все источники перепроверены curl'ом 2026-10-06, сырым HTML, wp-json или
JSON API. Состав прода совпал с локальным по всем 9 клиникам (`/api/doctors/list`).

SQL: `server/sql/update-doctors-2026-10-private-pg.sql`. Прогнан локально в транзакции
дважды: первый прогон дал 313 строк, второй 0, затем ROLLBACK.

| Клиника | Отвязано | Привязано существующих | Создано новых | Было → стало |
|---|---|---|---|---|
| SmartMed Podgorica | 34 | 3 | 11 | 88 → 68 |
| Vaše zdravlje | 13 | 4 | 1 | 21 → 13 |
| Konzilijum | 9 | 7 | 3 | 51 → 52 |
| Novi Cenex Medical | 4 | 5 | 4 | 38 → 43 |
| Poliklinika Diagnostica | 2 | 4 | 9 | 11 → 22 |
| Rezidencija zdravlja Kerber | 4 | 1 | 2 | 34 → 33 |
| Poliklinika Natal | 5 | 4 | 0 | 33 → 32 |
| Pedijatrija Natal Kids | 0 | 0 | 0 | 15, не тронута |
| Naša medicina | 4 | 2 | 2 | 9 → 9 |
| **Итого** | **75** | **30** | **32** | |

Перепривязок между филиалами нет: у этих клиник филиалов в нашей БД нет.

После прогона 44 врача остаются без клиник. Их не удаляли и не скрывали (решение юзера).

## SmartMed Podgorica

Источники: `/doktori` (полный список по отделениям) и `/aktuelno/ordinirajuci-doktori`
(приглашённые профессора), с 2026-10-02 состав не менялся.

**Отвязано (34).** Все 32 врача из `dbOnly`. Ни на `/doktori`, ни на страницах услуг их
нет:

- лаборатория и биохимия: Ana Laban, Danica Vešović, Jovana Stojić, Marina Vučeljić,
  Mirjana Vojvodić;
- педиатры: Aleksandra Bošković, Anja Đurović, Ivana Lakićević, Jelena Vukicević,
  Vladimir Dedović;
- гинекологи: Aleksandra Spasić Jokmanović, Antonia Mihaljević, Bojan Vučetić,
  Miloš Obradović (остаётся в Kerber), Tamara Radoman;
- радиологи: Danijela Lončar, Jelena Zekić, Nikola Kastratović;
- эстетическая медицина: Danica Izgarević, Mladen Rakuš;
- остальные: Adžić Milena, Ajša Kalač, Aleksandar Vlahović, Jelena Labudović,
  Jovica Milovanović, Miketić Ivana (гематолог), Nataša Vlahović, Nevenka Lukovac Janjić,
  Vasiljka Davidović.

Milić Petar и Velimir Milošević нашлись на bonomedica, Vladimir Vujović на A3. В SmartMed
их нет, и привязки к другим клиникам у них остаются. Сверх списка отвязаны Irena Marić и
Milica Vušurović: их страницы `/doktori/dr-irena-maric` и `/doktori/dr-milica-vusurovic`
есть только в sitemap, из списка на них не ссылаются, поэтому обе считаются ушедшими.

**Привязаны существующие (3):**

- `albijanic-drago` — тот же человек и та же специальность (детская хирургия и детская
  урология), он же в Milmedika;
- `sladjana-coric` — интернист и кардиолог из Kerber;
- `olivera-miketic` — эндокринолог. Это ответ на вопрос из BACKLOG: после отвязки SmartMed
  Kotor она работает в SmartMed Podgorica, на `/doktori` указана как «Dr Olivera Miketić,
  specijalista interne medicine, subspecijalista endokrinologije». Специальность совпадает,
  запись одна, поэтому только привязка. С гематологом Ivana Miketić это разные люди.

**Созданы (11):** Maja Karadžić, Nevena Jovičić, Stefan Đorđević, Nevena Popovac,
Dejan Orlić, Danilo Ćosović, Milovan Dimitrijević, Jelena Laković, Snežana Blagojević,
Ivona Dragović, Maja Milosavljević. Фото — с `/SmartMed/*` сайта. У Stefan Đorđević
специальности pediatrics и rheumatology: детской ревматологии в справочнике нет.

**Не заведены:**

- Jovan Ivović — есть только на старой акционной странице `/usluge/urologija` («до конца
  декабря»), в меню он не входит. Действующая `/usluge/urologija-1` называет только
  Marko Albijanić;
- Milica Radusinović — страница пустая, специальность не указана;
- Milena Mraković (физиотерапевт) и Anđela Golubović (психолог) уже привязаны, их не
  трогали;
- медсёстры, call-центр и администрация, включая Mr vms Marijana Bogavac.

## Vaše zdravlje

Источник: актуальная `/strucni-tim/` (lastmod 2026-04-24), с 2026-10-02 не менялась. Наша
БД была собрана со старой `/strucni-tim1/`.

**Отвязано (13):** вся гинекология (Muković, Boljević, Šimun, Smiljka Vukčević), а также
Klisić (психотерапевт), Bošković, Pupović, Burdžović, Ušćumlić, Jovićević Kračunov
(остаётся в Naša medicina), Radunović, Nikola Pavlović (остаётся в Natal) и
Radojka Vukčević.

**Привязаны существующие (4):** `senad-kalac-2` (психиатр, с хирургом `senad-kalac` не
путать), `bozovic-bjanka` (кардиолог, Milmedika), `jovan-bubanja` (ревматолог, КЦЦГ),
`amer-halilovic` (пульмонолог, раньше был в Konzilijum).

**Создан (1):** Vesko Kovijanić, doktor opšte medicine. На сайте у всех вместо фото
стоковая заглушка, поэтому фото не ставили.

**Не заведены, хотя есть в siteOnly карты (4):** Maja Miročević Rotolo, Aleksandra Klisić,
Marija Abramović, Balša Vujović. Они упоминаются только на страницах услуг 2021–2022 годов.
Там же стоят ушедшие Pupović, Bošković, Pavlović и Burdžović, а с апреля 2026 эти страницы
перекрывает новый полный штат. Добавлять людей по тем же страницам, по которым других
отвязываем, было бы непоследовательно.

## Konzilijum

Источники: `/nas-tim/` (38 врачей, правка 2025-11) и блоки врачей на страницах отделений
(2022–2024, ссылки из меню «Usluge»). Запросы шли с паузой 2 с, заглушки Loopia не
попадались.

**Отвязано (9):** Amer Halilović (теперь в Vaše zdravlje), Damir Muhović, Dijana Asanović,
Maja Miročević Rotolo, Mirjana Gotić, Nermin Abdić, Sabahudin Pupović, Velimir Milošević,
Vladimir Jovanović. Ни на `/nas-tim/`, ни на одной из 21 страницы отделений их нет: grep по
фамилиям пуст. Asanović, Pupović и Miročević Rotolo остались только на страницах 2021 года,
на которые ничто не ссылается. Вместе с привязками удалено 65 строк
`clinic_medical_service_doctors`: Abdić 13, Muhović 11, Milošević 11, Asanović 10,
Miročević Rotolo 10, Pupović 9, Gotić 1.

**Привязаны существующие (7):**

- `senad-kalac` — хирург со страницы `/endokrina-hirurgija/` (2024). Добавлена
  специальность endocrine_surgery: на сайте «supspecijalista endokrine hirurgije»;
- `tahir-kalac` — общий хирург со страницы `/vaskularna-hirurgija/` (2024). В карте его не
  было, нашёлся при перепроверке;
- `jovan-bubanja` (`/reumatologija/`), `slavisa-rabrenovic` (`/endokrinologija/`),
  `vesko-vujicic` (`/hematologija/`);
- `sabrina-hadziosmanovic` и `zeljka-rogac` (`/neurologija/`). Hadžiosmanović — тот же
  невролог, что в ОБ Плевля.

**Созданы (3):**

- Milutin Bulajić — гастроэнтеролог, `/gastroenterologija/`;
- Gordana Reljić — интернист, `/interna-medicina/`;
- `aleksandra-radojicic-2` — Doc. dr Aleksandra Radojičić, невролог, `/neurologija/`.
  В БД уже есть `aleksandra-radojicic` — детский офтальмолог из Moj Lab Pedijatrija.
  Специальности разные, поэтому это другой человек, и запись ищется только по slug.

**Не тронуты:** Aleksandar Spasić — в карте он в `matched` (страница «Hirurgija»).

## Novi Cenex Medical

Источник: `/nasi-ljekari/` — меню и блок биографий. Сайт взломан, поэтому только curl, без
исполнения JS.

**Отвязано (4):** Aleksandra Furtula (страница эндокринологии пустая; она остаётся в
Kerber, где есть на сайте), Dubravka Lopičić, Miloš Gačević, Saša Ljuština. Поиск wp-json
по фамилиям пуст.

**Привязаны существующие (5):**

- `albijanic-drago`, `nemanja-vukcevic` — детская хирургия;
- `zeljko-jelic` — общий хирург, полный тёзка общего хирурга ОБ Плевля;
- `asanin-ilija` — общий хирург. В биографии на сайте прямо сказано «OB Nikšić», это тот
  же человек;
- `nevena-cadjenovic` — на сайте «Nevena Čađenović Šelmić», дерматовенеролог (с двойной
  фамилией по браку), он же в КЦЦГ. Добавлены allergology и immunology: на сайте
  «subspecijalista alergologije i kliničke imunologije». Имя в БД не меняли.

**Созданы (4):**

- Milija Mimović — общий хирург, в биографии указан английский язык;
- Srđan Perazić — интернист и кардиолог;
- Žan Mrdović — анестезиолог;
- Valentin Sojar — Prim., общий хирург и проктолог из Iatros (Любляна), приезжающий
  консультант.

## Poliklinika Diagnostica

Источник: `api.diagnostica.me/api/public/bootstrap`, teamCategoryId = ljekari, 22 записи,
все active. Bojana Miljić и Marko Buta нет ни в одной категории.

**Отвязано (2):** Bojana Miljić, Marko Buta.

**Привязаны существующие (4):** `radomir-rakocevic`, `emilija-delevic`,
`biljana-andrijasevic` (психолог, как в Cenex), `slavisa-rabrenovic`.

**Созданы (9):**

- Zoran Vratnica — микробиолог;
- Aleksandra Stanišić — mr ph, медицинский биохимик; заведена как clinical_biochemistry, по
  образцу mr ph-биохимиков, которые уже есть в БД;
- Violeta Peković — радиолог;
- Stanka Nikač и Natalija Pavličić — психиатры;
- Milisav Lalević — ЛОР;
- Angel Trenevski — офтальмолог;
- Prof. dr Mileta Golubović — патолог (pathological_anatomy);
- Omer Adžović — педиатр.

Английский добавлен тем, у кого API указывает «Engleski»: Vratnica, Stanišić, Lalević.
Фото `/assets/doctors/*.jpg` — стоковые заглушки шаблона (имена файлов чужие), их не
ставили.

## Rezidencija zdravlja Kerber

Источники: `/doktori/` и team-member-sitemap (2026-05-05).

**Отвязано (4):** Anđa Bulajić Vuković (она в графике ЦМЗ ДЗ Подгорица), Jovana Pešić,
Maja Velimirov, Svjetlana Raičević.

**Оставлена, хотя была в dbOnly:** `vasiljkova-jelena` (Василькова Елена). На сайте она
теперь «dr Elena Bukova»: фото на её странице — `dr-elena-vasilkova.jpg`. Это тот же
человек, вероятно, сменивший фамилию по браку, поэтому привязка сохранена и новая запись не
заведена. Имя в БД не меняли.

**Привязана существующая (1):** `veljovic-radoman-marijana`, дерматовенеролог (Milmedika
Nikšić, ДЗ Даниловград). Фото на её странице у Kerber чужое (Furtula), поэтому его не
трогали.

**Созданы (2):** Teodora Jovanović (интернист и кардиолог), Tanja Šaranović (интернист и
гастроэнтеролог), фото с сайта.

Русские врачи — транслитерации уже заведённых: Tsyvkina = `civkina-ekaterina`,
Sosnovskaia = `sosnovska-tatjana`, Vorobeva = `vorobjeva-ljudmila`. Дубль `jelena-miranovic`
слит ещё в 049.

## Poliklinika Natal / Pedijatrija Natal Kids

Источник: wp-json CPT `nas-tim`, 47 записей, последняя правка 2026-10-01. Педиатрия
(usluge = 18) — это Natal Kids: все 15 записей уже привязаны, ничего не меняли.

**Отвязано от Natal (5):** Irena Marić (остаётся в КЦЦГ и Medikid), Jelena Jovović,
Ljubomir Petričević, Nataša Vukotić Đuričanin, Snežana Rakić.

**Привязаны существующие (4):**

- `vladimir-prelevic` — нефролог;
- `vukadinovic-snezana` — дерматолог;
- `eldin-sabovic` — уролог. На сайте он стоит в разделе «Interna medicina», но с подписью
  «Specijalista urologije», что совпадает с нашей записью;
- `dusanka-radovic` — радиолог.

**Новых нет.**

## Naša medicina

Источник: `/o-nama/`, команда обновлена 2026-06.

**Отвязано (4):** Ankica Ivanović, Edita Files Bradarić, Maida Međedović,
Marina Nerić Kozarev. Marina на сайте не названа нигде. Jelena Nerić — другой человек.

**Привязаны существующие (2):** `radojicic-jelena` (офтальмолог), `jelena-milonjic`
(психиатр).

**Созданы (2):**

- Mevlida Gusinjac — медицина труда, фото с сайта;
- Jelena Nerić — магистр психологии, основательница и директор. В прайсе клиники есть
  психологические услуги («Cjenovnik psiholog»), специальность psychology в справочнике
  есть, и психологи в БД уже заведены. В `doctor_clinics.position` записано
  «Osnivač i izvršni direktor».

## Замечено попутно, не правилось

- `bozovic-bjanka`: в имени нет диакритики («Božovic Bjanka», кириллица «Божовиц»). Это
  запись Milmedika.
- Natal Kids: id локально 188, на проде 161. SQL работает только по slug.
