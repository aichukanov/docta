# Группа hospitals: государственные больницы

Сверка составов врачей с сайтами 2026-10-06. Все сайты перепроверены curl'ом по `teamSources` из `map.json`.

SQL: `server/sql/update-doctors-2026-10-hospitals.sql`. Прогнан локально в транзакции дважды, второй прогон дал 0 строк, затем ROLLBACK. В файле нет числовых id: клиники, врачи и специальности указаны только по slug или name. Перед созданием каждого нового slug проверен на проде через `/api/doctors/details`: ни одного такого врача там нет.

| Клиника | Отвязано | Привязано существующих | Создано | Было → стало (локально) |
|---|---|---|---|---|
| bolnica-danilo-i-cetinje | 0 | 2 | 0 | 26 → 28 |
| opsta-bolnica-niksic | 0 | 3 | 10 | 46 → 59 |
| opsta-bolnica-berane | 1 | 2 | 5 | 26 → 32 |
| opsta-bolnica-pljevlja | 0 | 0 | 3 | 36 → 39 |
| specijalna-bolnica-za-plucne-bolesti-dr-jovan-bulajic-brezovik | 0 | 3 | 3 | 9 → 15 |
| specijalna-bolnica-za-psihijatriju-dobrota-kotor | 0 | 0 | 18 | 4 → 22 |
| opsta-bolnica-kotor | — | — | — | 22 → 22, изменён только website |

Перепривязок нет: ни одна из клиник группы не является сетью с филиалами.

Должности, которые сайт называет явно, вписаны в `doctor_clinics.position` новым врачам, а существующим — только если поле было пустым. Заполненные должности не перезаписывались, кроме двух случаев в Беране.

## Bolnica Danilo I Cetinje

Источники: `/osoblje-bolnice-danilo-i/` (полный список) и страницы отделений. Страницы `/doktori/`, педиатрии, хирургии и ORL по-прежнему отдают заглушку Maintenance Mode.

- **Отвязано:** никто. Все 26 наших врачей есть в полном списке.
- **Привязаны существующие:**
  - `gargovic-babovic-samira` — анестезиолог; на странице службы анестезии указана среди врачей отделения. У нас она уже была у Codra.
  - `jelena-bojanic` — радиолог, «Šef odsjeka za ultrazvuk». У нас она уже была у Hirurgija Dr Eli.
- **Не заведены:**
  - специализанты: Aleksa Bastać, Bojana Damjanović, Svetlana Đurović-Martinović, Nemanja Ivezić, Darinka Martinović, Aleksandra Šćekić;
  - Zoran Vujačić (`zoran-vujacic`, интернист у Moj Lab). Он упомянут только в тексте страницы интерны («načelnik od 1994»). В полном списке его нет, а подпись под фото на той же странице называет начальником Suzana Ivanović. Текст устарел.
- **Должности** вписаны в пустые поля: Ivan Ivanović — директор, плюс начальники анестезии, радиологии, гинекологии, отделения хумане репродукции и интерны, шефы отсека RTG и операционного блока.

## Opšta bolnica Nikšić

Источник: wp-json pages (151 страница), страницы отделений и кабинетов. Страницы «Dopunski rad» в проверку присутствия не включались.

- **Отвязано:** никто. Все 46 наших врачей есть на страницах отделений.
- **Привязаны существующие:** все трое — радиологи из «Kabinet za radiološku, UZ, CT i mamograf dijagnostiku».
  - `sanja-vrbica` — начальник кабинета. У нас она у Konzilijum и Medicus Tim.
  - `grupkovic-saska` — у нас у Milmedika Podgorica/Nikšić.
  - `marija-erakovic` — у нас у Hipokrat.
- **Созданы (10):**
  - Tanja Raičević — начальник отделения новорождённых;
  - Sanja Čizmović;
  - Snežana Grubač — педиатр и неонатолог;
  - Mirko Varajić — начальник акушерства;
  - Bojan Pešić — амбулатория общей хирургии;
  - Nada Grbović — начальник физикальной медицины;
  - Milena Šaranović;
  - Ranka Koprivica;
  - Andrija Radulović — не путать с `andrea-radulovic`, врачом общей медицины Moj Lab Budva;
  - Maja Mušikić — spec. kliničke biohemije, начальник лаборатории.
- **Не заведён:** Vojin Kadić. Он есть только на странице амбулатории ортопедии, которую последний раз правили в 2022-11. На странице отделения ортопедии (правка 2025-10) его место занимает Dejan Pavličić.
- **Должности** вписаны в пустые поля: Zoran Mrkić — директор, Sonja Lalović, Dragutin Višnjić, Sabahudin Pupović.

## Opšta bolnica (KBC) Berane

Источники: `/menadzerski-tim`, `/o-nama/menadzment`, 11 новостей из ленты.

- **Violeta Manović — НЕ отвязана** (решение координатора 2026-10-06): на `/menadzerski-tim` её нет, а её прежнюю должность «Šef Odsjeka intenzivnog liječenja» занимает Miladinović, но страница показывает только руководителей — это «больше не руководитель», а не «ушла». Привязка сохранена, снята только должность.
- **Решения координатора:** Đedović остаётся «Jovan Đedović» (без переименования); лаборатория Brezovik (Matić, Perović, Lučić) не заводится, пока специальность неизвестна.
- **Должности поменяны** (UPDATE с условием на старое значение):
  - Mirsad Markišić — «Načelnik Odjeljenja za anesteziju i reanimaciju»;
  - Milosav Miladinović — «Šef Odsjeka intenzivnog liječenja».
- **Привязаны существующие:**
  - `miroljub-todorovic` — ORL, привлечён к операционной программе (новость 11.09.2026);
  - `nikola-cvijovic` — офтальмолог из КЦЦГ, привлечён для анти-VEGF терапии (новость 02.03.2026).
- **Созданы (5):**
  - Milorad Magdelinić — директор, spec. hirurgije;
  - Goran Bulatović — ORL;
  - Nemanja Vuković — сосудистый хирург. Его же с тем же slug `nemanja-vukovic` создаёт агент КЦЦГ (`update-doctors-2026-10-kccg.sql`): это тот же человек, «найти или создать» сведёт записи в одну;
  - Saveta Obradović Kljajić — офтальмолог;
  - Jasmina Međedović — офтальмолог.
- **Не заведены:**
  - 7 специализантов из новости от 01.10.2026: Dragišić, Paunović, Šarkinović, Damjanović, Ćorović, Bojić, Ivanović;
  - Slobodan Ćulafić — провёл разовую эмболизацию (новость 2025-07);
  - `slavko-djuraskovic` — нейрохирург КЦЦГ, в 2025-07 начал вести приём в Беране «za sada, dva puta mjesečno». Свежего подтверждения нет, а `siteOnly` в карте его не включал.
- **Не тронуты:**
  - Rajko Karličić — уже отвязан;
  - `aleksandar-babovic-2` — уже привязан как начальник кардиологии.

## Opšta bolnica Pljevlja

Источник: все страницы отделений и амбулаторий из меню, плюс менеджмент.

- **Не отвязана:** `ana-mrdak` (психиатрия). Отдельной страницы психиатрии на сайте нет, а страница отделения «Detoksikacija», где мог бы работать психиатр, пустая. В истории больницы упомянуто отделение «neurologija i psihijatrija». Значит, отсутствие на сайте не доказывает, что она ушла.
- **Созданы (3):**
  - Radoman Čolović — кардиолог;
  - Jovan Peruničić — «kardiolog – konsultant»;
  - Davor Cvijović — хирург.
- **Должности** вписаны в пустые поля: начальник неврологии Sabrina Hadžiosmanović, начальник педиатрии Maja Terzić, помощник директора по медицинским вопросам Strahinja Vraneš.
- **Не тронуты:**
  - `tarik-kojundzic` — уже переименован;
  - `ivanka-stevancevic`. На сайте она «Ivanka Brajović Stevančević», имя не меняли.

## Specijalna bolnica za plućne bolesti Brezovik

Источники: 7 страниц отделений и служб, расписание амбулатории, `/kontakt/`, konzilijumi.

- **Отвязано:** никто. Все 9 наших врачей на месте.
- **Привязаны существующие:**
  - `marija-stolic` — интернист-онколог, начальник пульмоонкологии. У нас она у Moj Lab Podgorica с той же специальностью;
  - `perovic-dejan` — радиолог, начальник радиологии. У нас у Milmedika Nikšić, тот же город;
  - `rade-kovac` — радиолог.
- **Созданы (3), все интернисты:**
  - Slobodan Guzina — начальник отделения интенсивной терапии;
  - Ana Vukićević Delić;
  - Danilo Ćosović.
- **Не заведены, потому что специальность не указана:**
  - Gordana Matić (начальник), Zorana Perović, Stevan Lučić — Služba laboratorijske dijagnostike, у каждого только «dr». Биохимик это или микробиолог, неизвестно;
  - Zorana Marić — упомянута только в konzilijumе по MSCT.
- **Должности** вписаны в пустые поля: начальники отделений Toljić, Bojović, Vukosavljević.

## Specijalna bolnica za psihijatriju Dobrota Kotor

Источник: wp-json pages (28 страниц).

- **Не отвязаны:** `ivana-stijovic`, `jelena-perunovic`, `mladen-donkovic` — по указанию. Поля «Ordinirajući ljekar» у интернистской, эпидемиологической, детской и ургентной служб пустые.
- **Đedović — один человек.** Наш `jovan-djedovic` и «Prim. dr Jovo Đedović», директор больницы, одно лицо: Jovo — уменьшительное от Jovan, специальность та же. Изменения:
  - `position` = «Direktor»;
  - `professional_title` = «prim. dr»;
  - `photo_url` — фото со страницы `/menadzment/`.

  Имя `name_sr` не менял. Других источников с полным именем не нашлось. Сайт больницы везде пишет «Jovo», и в договорах о дополнительной работе тоже.
- **Созданы (18).**
  - Психиатры (12): Boris Ćorić (менеджмент, начальник отделения, фото с сайта), Tanja Mijatović Papić, Neda Grbović, Jovana Bogdanović, Danijela Miladinović, Milica Vučetić, Milka Bulatović Nišavić, Ana Stanković, Nikola Radoman, Vesna Blagojević, Sandra Vlahović, Aleksandar Tomčuk. Начальникам отделений вписаны должности.
  - Ana Stanković заведена как `ana-stankovic-2` и ищется только по slug. `ana-stankovic` — другой человек: врач общей медицины Novi Standard.
  - Nikola Radoman — «specijalista neuropsihijatrije», поэтому у него две специальности: психиатрия и неврология.
  - Stevan Radoman — оральный хирург, стоматологическая амбулатория.
  - Marija Kaluđerović — анестезиолог, член Этического комитета больницы как представитель профессиональных органов.
  - Психологи (4), специальность psychology; в БД 28 психологов у других клиник:
    - Kristina Bećir Veriš — начальник службы, spec. med. psihologije. Карта её не нашла;
    - Olivera Marković — spec. med. psihologije;
    - Ljiljana Matković и Ivana Mihailović — dipl. psiholog.
- **Не заведены:**
  - специализанты психиатрии: Aleksandra Yafimenka, Katarina Sekulić, Anela Moco (в списке dopunski rad она «Ljekar na specijalizaciji iz psihijatrije»);
  - психологи на специализации по медицинской психологии: Stanislava Porobić, Milica Samardžić;
  - dr Ivana Bulatović — только заявитель по запросу о свободном доступе к информации.

## Opšta bolnica Kotor

- Врачи не тронуты (22). Проверить их нечем: jzuobkotor.me заброшен, а kbckotor.me имён не публикует.
- `clinics.website`: `https://kbckotor.me;https://jzuobkotor.me` → `https://kbckotor.me`. UPDATE срабатывает, только если в поле пусто или стоит это старое значение. На проде сейчас то же старое значение.
