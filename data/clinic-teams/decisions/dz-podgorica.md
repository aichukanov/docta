# ДЗ Подгорица (Dom zdravlja Glavnog grada): врачи, решения 2026-10-06

Клиника `dom-zdravlja-podgorica` (id 140 и локально, и на проде). До синхронизации у клиники
в БД 0 врачей, поэтому отвязок нет: только привязка существующих и создание новых.

SQL: `server/sql/update-doctors-2026-10-dz-podgorica.sql`. Проверен в транзакции с ROLLBACK:
первый прогон — +142 врача, +177 привязок, второй прогон — 0 строк.

| | |
|---|---|
| Отвязано | 0 |
| Перепривязано | 0 |
| Привязано существующих | 35 |
| Создано новых | 142 |
| Итого врачей у клиники | 177 |

## Источник

Страница `https://www.dzpg.me/rasporedi-rada-zs/` (wp-json modified 2026-10-06), помесячные PDF
по службам. Сайт отдаёт заглушку Loopia на curl без браузерного User-Agent, нужен UA браузера.
Текст из PDF брался через PyMuPDF: `pdftotext` теряет ć/č/đ в части файлов.

Взят самый свежий опубликованный список по каждой службе:

| Служба | Источник | Дата |
|---|---|---|
| IDO, команды по ZS | `2026/07/IDO-doktori-jul-2026.pdf` | июль 2026. В карте ошибка: полные списки IDO есть и за июнь, и за июль. С августа есть только график выходных |
| IDO, выходные и праздники | `2026/10/Mjesecni_raspored_IDO_subota-nedelja-OKTOBAR-2026.pdf` (+ июль–сентябрь) | октябрь 2026 |
| IDD | `2026/04/RASPORED-RADA-IDD-27-30.04.2026.pdf` + ночные смены `IDD-Treca-smjena-jun/jul`, `IDD-nocna-smjena-avgust-2026.pdf` | 27–30.04.2026, ночные — июнь–август 2026 |
| IDŽ | `2026/10/RASPORED-RAD-OC-IDZ-oktobar-2026.pdf` | октябрь 2026 |
| Centar za mentalno zdravlje | `2026/10/Mentalno-zdravlje-oktobar-2026.pdf` | октябрь 2026 |
| RTG i UZ (радиологи) | `2026/10/Radiolozi-oktobar_novembar-2026.pdf` | октябрь–ноябрь 2026 |
| Internistička ambulanta | `2026/10/Raspored-rada-Internisticke-ambulante-za-oktobar-2026.pdf` | октябрь 2026 |
| Medicina rada | `2026/10/Medicina-rada-oktobar-2026.pdf` | октябрь 2026 |
| Sportska medicina | `2026/10/Sportska-medicina-oktobar-2026.pdf` | октябрь 2026 |
| Oftalmološka ambulanta | `2026/09/Oftalmoloska_ambulanta_septembar_2026.pdf` | сентябрь 2026 (за октябрь не опубликовано) |
| Laboratorija (биохимики) | `2026/09/Centar-za-laboratorijsku-dijagnostiku_biohemicari-septembar-2026.pdf` | сентябрь 2026 |
| Centar za plućne bolesti i TBC | `2026/05/Mjesecni_raspored_Centar-za-plucne-bolesti-i-TBC_jun_2026.pdf` | июнь 2026 (последний) |
| CDPP (djeca sa posebnim potrebama) | `2026/05/Mjesecni_raspored_CDPP_maj_2026-1.pdf` | май 2026 (последний) |
| Fizikalna terapija | `2026/05/Jedinica-za-fizikala_maj-2026.pdf` | май 2026 (последний) |
| Справочно: специальности, полные имена | `2026/04/Dopunski-rad-zaposlenih-januar_februar_mart_april_2026.pdf` | январь–апрель 2026 |

Centar za prevenciju и Patronaža — только медсёстры и техники.

Документ «Dopunski rad zaposlenih» (январь–апрель 2026) подтвердил специальности и правильное
написание имён. IDO-врачи в нём идут как «Dr med.» / «doktor medicine», то есть врачи общей
практики без специализации. Отсюда же «specijalista kliničke biohemije», «fizikalne medicine»,
«pneumoftiziolog», «medicine rada», а также написание «Ljirim Đokaj» и «Alma Crnovršanin Mucević».

## Правила, применённые ко всей клинике

- **Izabrani doktor za odrasle → `general_medicine`**, как у ДЗ Бар: там 22 врача
  general_medicine и ни одного family_medicine; у ДЗ Тиват 8 против 2. Исключение — Sanela
  Muminović: она уже есть в БД с family_medicine (Vaše zdravlje), специальность не трогали.
- **za djecu → `pediatrics`**, **za žene → `gynecology_obstetrics`**, остальные — по службе.
- `position` — служба и ZS/ZO или амбулатория, если они видны в графике. Подменных врачей
  (zamjena) записали на ZS, где они стабильно подменяют. Врачам, которые есть только в графике
  выходных или подменяют без закрепления, — просто «Izabrani doktor za odrasle».
- Фото нет: `photo_url` NULL. Язык — сербский.
- Новые врачи ищутся только по slug (шаблон «найти или создать»), поэтому агенты, создавшие одного
  и того же врача, сойдутся на одной записи.

## Привязаны существующие (35)

| Врач на сайте | slug в БД | Специальность | position |
|---|---|---|---|
| Sanela Muminović | `sanela-muminovic` | family_medicine (в БД, не менялась) | Izabrani doktor za odrasle, ZS Blok V |
| Ivana Novović | `ivana-novovic` | general_medicine | Izabrani doktor za odrasle, Ambulanta Zlatica |
| Dušica Gojković | `dusica-gojkovic` | pediatrics | Izabrani doktor za djecu, ZO Blok V |
| Ivana Lakićević | `ivana-lakicevic` | pediatrics | Izabrani doktor za djecu, ZO Stara Varoš |
| Anja Đurović | `anja-djurovic` | pediatrics | Izabrani doktor za djecu, ZO Stara Varoš |
| Rajka Pajović | `rajka-pajovic` | pediatrics | Izabrani doktor za djecu, ZO Stara Varoš |
| Biljana Raičević-Fuštar | `biljana-raicevic-fustar` | pediatrics | Načelnica OC Izabrani doktor za djecu |
| Ana Vukčević | `ana-vukcevic` | pediatrics | Izabrani doktor za djecu, ZO Stara Varoš |
| Edita Bašović | `edita-basovic` | pediatrics | Izabrani doktor za djecu, ZO Stari Aerodrom |
| Saida Zejnilović | `saida-zejnilovic` | pediatrics | Izabrani doktor za djecu, ZO Nova Varoš |
| Snežana Perazić | `snezana-perazic` | pediatrics | Izabrani doktor za djecu, ZO Zlatica |
| Snežana Šebek | `snezana-sebek` | pediatrics | Izabrani doktor za djecu |
| Alma Dervišević | `alma-dervisevic` | pediatrics | Izabrani doktor za djecu |
| Željka Ralević | `zeljka-ralevic` | gynecology_obstetrics | Izabrani doktor za žene, ZO Blok V |
| Milovan Jovanović | `milovan-jovanovic` | gynecology_obstetrics | Izabrani doktor za žene, ZO Blok V |
| Jelena Miranović | `jelena-terzic-miranovic` | gynecology_obstetrics | Izabrani doktor za žene, ZO Stari Aerodrom |
| Aleksandar Boljević | `aleksandar-boljevic` | gynecology_obstetrics | Izabrani doktor za žene, ZO Stari Aerodrom |
| Željka Stevović | `zeljka-stevovic` | gynecology_obstetrics | Izabrani doktor za žene, ZO Studentska ambulanta |
| Nataša Tomašević | `natasa-tomasevic` | gynecology_obstetrics | Izabrani doktor za žene, ZO Studentska ambulanta |
| Ersan Bašović | `ersan-basovic` | gynecology_obstetrics | Izabrani doktor za žene, ZO Tuzi |
| Milica Gazivoda | `milica-gazivoda` | gynecology_obstetrics | Izabrani doktor za žene, ZO Golubovci |
| Maida Burdžović | `maida-burdzovic` | psychiatry | Centar za mentalno zdravlje |
| Branka Purlija | `branka-purlija` | psychiatry | Centar za mentalno zdravlje |
| Anđa Bulajić Vuković | `andja-bulajic-vukovic` | psychiatry | Centar za mentalno zdravlje |
| Danilo Đurić | `djuric-danilo` | psychology | Centar za mentalno zdravlje (psiholog) |
| Alma Crnovršanin | `alma-crnovrsanin` | radiology | Centar za RTG i ultrazvučnu dijagnostiku |
| Ana Ičević | `ana-icevic` | radiology | Centar za RTG i ultrazvučnu dijagnostiku |
| Katarina Kalezić | `katarina-kalezic` | radiology | Centar za RTG i ultrazvučnu dijagnostiku |
| Jelena Obadović | `jelena-obadovic` | radiology | Centar za RTG i ultrazvučnu dijagnostiku |
| Enisa Pupović | `enisa-pupovic` | internal_medicine | Internistička ambulanta |
| Milenka Ušćumlić | `milenka-uscumlic` | occupational_medicine | Šef Centra za medicinu rada |
| Dubravka Lopičić Mirković | `dubravka-lopicic` | pulmonology | Šef Centra za plućne bolesti i TBC |
| Amer Halilović | `amer-halilovic` | pulmonology | Centar za plućne bolesti i TBC |
| Dragana Radunović | `dragana-radunovic` | Physical Medicine and Rehabilitation | Jedinica za fizikalnu terapiju primarnog nivoa |
| Danica Vešović | `danica-vesovic` | clinical_biochemistry | Centar za laboratorijsku dijagnostiku |

Пояснения:

- `jelena-terzic-miranovic` — «Jelena Miranović» в IDŽ; слита миграцией 049.
- `dubravka-lopicic` — на сайте ДЗ «Lopičić Mirković», шеф Centra za plućne bolesti;
  пульмонолог в обоих местах. Имя записи не меняли.
- `alma-crnovrsanin` — в документе ДЗ полное имя «Alma Crnovršanin Mucević», радиолог; имя записи не меняли.
- `djuric-danilo` — психолог Codra, на сайте ДЗ «Đurić Danilo psiholog»: та же специальность, тот же город.
- `danica-vesovic` — «pharm. Danica Vešović» в смене биохимиков; в БД mr ph, clinical_biochemistry.
- `dragana-radunovic` — физиатр, в БД без клиник. В карте её не было, нашлась в графике Fizikalna terapija.
- `amer-halilovic` — пульмонолог Konzilijum. Это подтверждает специальность в TBC-центре ДЗ.
- `milica-gazivoda` (гинеколог, SmartMed), а не `milica-gazivoda-2` (детский аллерголог КЦЦГ).
- `snezana-sebek`, `alma-dervisevic` — педиатры IDD по документу «Dopunski rad» (январь–апрель 2026).
  В графике 27–30.04 их нет. Alma Dervišević и Alma Drešević — разные люди: в документе обе в
  одном списке.

## Созданы новые (142)

| slug | name_sr | Специальность | position | Источник |
|---|---|---|---|---|
| `marina-bugarin` | Marina Bugarin | general_medicine | Izabrani doktor za odrasle, ZS Blok V | IDO jul |
| `veselin-kandic` | Veselin Kandić | general_medicine | Izabrani doktor za odrasle, ZS Blok V | IDO jul |
| `ivana-jovanovic-2` | Ivana Jovanović | general_medicine | Izabrani doktor za odrasle, ZS Blok V | IDO jul |
| `jasmina-kajabegovic-martinovic` | Jasmina Kajabegović Martinović | general_medicine | Izabrani doktor za odrasle, ZS Blok V | IDO jul |
| `aldijana-zekovic` | Aldijana Zeković | general_medicine | Izabrani doktor za odrasle, ZS Blok V | IDO jul |
| `slobodanka-marojevic` | Slobodanka Marojević | general_medicine | Izabrani doktor za odrasle, ZS Blok V | IDO jul |
| `nela-sekulic` | Nela Sekulić | general_medicine | Izabrani doktor za odrasle, ZS Blok V | IDO jul |
| `zorica-boricic` | Zorica Boričić | general_medicine | Izabrani doktor za odrasle, ZS Blok V | IDO jul |
| `milena-cojic` | Milena Cojić | general_medicine | Izabrani doktor za odrasle, ZS Blok V | IDO jul |
| `ana-tmusic` | Ana Tmušić | general_medicine | Izabrani doktor za odrasle, ZS Blok V | IDO jul |
| `amina-sahmanovic` | Amina Šahmanović | general_medicine | Izabrani doktor za odrasle, ZS Blok V | IDO jul |
| `jelena-stojovic` | Jelena Stojović | general_medicine | Izabrani doktor za odrasle, ZS Blok V | IDO jul |
| `tijana-petric` | Tijana Petrić | general_medicine | Izabrani doktor za odrasle, ZS Blok V | IDO jul |
| `vesko-kovijanic` | Vesko Kovijanić | general_medicine | Izabrani doktor za odrasle, ZS Blok V | IDO jul |
| `gordana-babic` | Gordana Babić | general_medicine | Izabrani doktor za odrasle, ZS Stara Varoš | IDO jul |
| `ivana-despotovic` | Ivana Despotović | general_medicine | Izabrani doktor za odrasle, ZS Stara Varoš | IDO jul |
| `milijana-vujovic` | Milijana Vujović | general_medicine | Izabrani doktor za odrasle, ZS Stara Varoš | IDO jul |
| `jelena-stankovic` | Jelena Stanković | general_medicine | Izabrani doktor za odrasle, ZS Stara Varoš | IDO jul |
| `radmila-bojic` | Radmila Bojić | general_medicine | Izabrani doktor za odrasle, ZS Stara Varoš | IDO jul |
| `snezana-mikavica` | Snežana Mikavica | general_medicine | Izabrani doktor za odrasle, ZS Stara Varoš | IDO jul |
| `marija-vukovic` | Marija Vuković | general_medicine | Izabrani doktor za odrasle, ZS Stara Varoš | IDO jul |
| `marijana-simonovic` | Marijana Simonović | general_medicine | Izabrani doktor za odrasle, ZS Stara Varoš | IDO jul |
| `dragana-perovic` | Dragana Perović | general_medicine | Izabrani doktor za odrasle, ZS Stara Varoš | IDO jul |
| `jelena-radusinovic` | Jelena Radusinović | general_medicine | Izabrani doktor za odrasle, ZS Stara Varoš | IDO jul |
| `stefan-prascevic` | Stefan Praščević | general_medicine | Izabrani doktor za odrasle, ZS Stari Aerodrom | IDO jul |
| `rosa-brinic` | Rosa Brinić | general_medicine | Izabrani doktor za odrasle, ZS Stari Aerodrom | IDO jul |
| `dragoslava-cipranic` | Dragoslava Ćipranić | general_medicine | Izabrani doktor za odrasle, ZS Stari Aerodrom | IDO jul |
| `natasa-radonjic` | Nataša Radonjić | general_medicine | Izabrani doktor za odrasle, ZS Stari Aerodrom | IDO jul |
| `denisa-frljuckic` | Denisa Frljučkić | general_medicine | Izabrani doktor za odrasle, ZS Stari Aerodrom | IDO jul |
| `liridon-dushaj` | Liridon Dushaj | general_medicine | Izabrani doktor za odrasle, ZS Stari Aerodrom | IDO jul |
| `radojka-lekic` | Radojka Lekić | general_medicine | Izabrani doktor za odrasle, ZS Nova Varoš | IDO jul |
| `adela-dizdarevic` | Adela Dizdarević | general_medicine | Izabrani doktor za odrasle, ZS Nova Varoš | IDO jul |
| `selena-kenic` | Selena Kenić | general_medicine | Izabrani doktor za odrasle, ZS Nova Varoš | IDO jul |
| `snezana-micanovic` | Snežana Mićanović | general_medicine | Izabrani doktor za odrasle, ZS Nova Varoš | IDO jul |
| `merzika-hodzic` | Merzika Hodžić | general_medicine | Izabrani doktor za odrasle, ZS Nova Varoš | IDO jul |
| `jasna-kalac-cekic` | Jasna Kalač-Čekić | general_medicine | Izabrani doktor za odrasle, ZS Nova Varoš | IDO jul |
| `branka-grujevic` | Branka Grujević | general_medicine | Izabrani doktor za odrasle, ZS Nova Varoš | IDO jul |
| `anela-omeragic` | Anela Omeragić | general_medicine | Izabrani doktor za odrasle, ZS Nova Varoš | IDO jul |
| `natalija-popovic-petric` | Natalija Popović-Petrić | general_medicine | Izabrani doktor za odrasle, ZS Nova Varoš | IDO jul |
| `marija-bulatovic` | Marija Bulatović | general_medicine | Izabrani doktor za odrasle, ZS Nova Varoš | IDO jul |
| `miljana-janjusevic` | Miljana Janjušević | general_medicine | Izabrani doktor za odrasle, ZS Nova Varoš | IDO jul |
| `biljana-danaj` | Biljana Danaj | general_medicine | Izabrani doktor za odrasle, ZS Nova Varoš | IDO jul |
| `novak-prascevic` | Novak Praščević | general_medicine | Izabrani doktor za odrasle, ZS Nova Varoš | IDO jul |
| `jelena-cetkovic` | Jelena Ćetković | general_medicine | Izabrani doktor za odrasle, ZS Nova Varoš | IDO jul |
| `jelena-ivanovic` | Jelena Ivanović | general_medicine | Izabrani doktor za odrasle, ZS Nova Varoš | IDO jul |
| `maja-lalicic` | Maja Laličić | general_medicine | Izabrani doktor za odrasle, ZS Nova Varoš | IDO jul |
| `elvidina-numanovic` | Elvidina Numanović | general_medicine | Izabrani doktor za odrasle, Studentski centar | IDO jul |
| `ena-vesovic` | Ena Vešović | general_medicine | Izabrani doktor za odrasle, Studentski centar | IDO jul |
| `jadranka-papic-radunovic` | Jadranka Papić-Radunović | general_medicine | Izabrani doktor za odrasle, Studentski centar | IDO jul |
| `rade-vlahovic` | Rade Vlahović | general_medicine | Izabrani doktor za odrasle, Studentski centar | IDO jul |
| `mirjana-dobrovic-milosevic` | Mirjana Dobrović-Milošević | general_medicine | Izabrani doktor za odrasle, Studentski centar | IDO jul |
| `branko-popadic` | Branko Popadić | general_medicine | Izabrani doktor za odrasle, Studentski centar | IDO jul |
| `natasa-nisavic` | Nataša Nišavić | general_medicine | Izabrani doktor za odrasle, ZS Konik | IDO jul |
| `melisa-spahic` | Melisa Spahić | general_medicine | Izabrani doktor za odrasle, ZS Konik | IDO jul |
| `danica-knezevic` | Danica Knežević | general_medicine | Izabrani doktor za odrasle, ZS Konik | IDO jul |
| `milena-pelicic` | Milena Peličić | general_medicine | Izabrani doktor za odrasle, ZS Konik | IDO jul |
| `nedzmija-berisa` | Nedžmija Beriša | general_medicine | Izabrani doktor za odrasle, ZS Konik | IDO jul |
| `tereze-dreshaj` | Tereze Dreshaj | general_medicine | Izabrani doktor za odrasle, ZS Konik | IDO jul |
| `halil-dukovic` | Halil Duković | general_medicine | Izabrani doktor za odrasle, ZS Tuzi | IDO jul |
| `sejla-batilovic` | Šejla Batilović | general_medicine | Izabrani doktor za odrasle, ZS Tuzi | IDO jul |
| `marina-radovic` | Marina Radović | general_medicine | Izabrani doktor za odrasle, ZS Golubovci | IDO jul |
| `anita-vujicic` | Anita Vujičić | general_medicine | Izabrani doktor za odrasle, ZS Golubovci | IDO jul |
| `dusica-knezevic` | Dušica Knežević | general_medicine | Izabrani doktor za odrasle, ZS Golubovci | IDO jul |
| `vesna-djuretic` | Vesna Đuretić | general_medicine | Izabrani doktor za odrasle, ZS Golubovci | IDO jul |
| `marina-jacimovic` | Marina Jaćimović | general_medicine | Izabrani doktor za odrasle, ZS Golubovci | IDO jul |
| `ljiljana-djurovic` | Ljiljana Đurović | general_medicine | Izabrani doktor za odrasle, Ambulanta Zabjelo – Jerevanska | IDO jul |
| `svetlana-terzic` | Svetlana Terzić | general_medicine | Izabrani doktor za odrasle, Ambulanta Zabjelo – Jerevanska | IDO jul |
| `danijela-siljkovic` | Danijela Šiljković | general_medicine | Izabrani doktor za odrasle, Ambulanta Zabjelo – Jerevanska | IDO jul |
| `lidija-samardzic` | Lidija Samardžić | general_medicine | Izabrani doktor za odrasle, Ambulanta Zabjelo – Jerevanska | IDO jul |
| `branka-djurisic` | Branka Đurišić | general_medicine | Izabrani doktor za odrasle, Ambulanta Zlatica | IDO jul |
| `ljiljana-markovic` | Ljiljana Marković | general_medicine | Izabrani doktor za odrasle, Ambulanta Zlatica | IDO jul |
| `vesna-milicevic` | Vesna Milićević | general_medicine | Izabrani doktor za odrasle, Ambulanta Zlatica | IDO jul |
| `mihajlo-vukanic` | Mihajlo Vukanić | general_medicine | Izabrani doktor za odrasle, Ambulanta Zlatica | IDO jul |
| `jasminka-zec-saveljic` | Jasminka Zec-Saveljić | general_medicine | Izabrani doktor za odrasle, Ambulanta Zlatica | IDO jul |
| `erna-hot` | Erna Hot | general_medicine | Izabrani doktor za odrasle, Ambulanta Zlatica | IDO jul |
| `andjela-aletic` | Anđela Aletić | general_medicine | Izabrani doktor za odrasle, Ambulanta Zlatica | IDO jul |
| `jasna-furtula` | Jasna Furtula | general_medicine | Izabrani doktor za odrasle, Ambulanta Zlatica | IDO jul |
| `jelena-damjanovic` | Jelena Damjanović | general_medicine | Izabrani doktor za odrasle, Ambulanta Donja Gorica; izabrani doktor za djecu, ZO Blok V | IDO jul + IDD apr |
| `marija-medjedovic` | Marija Međedović | general_medicine | Izabrani doktor za odrasle, Ambulanta Donja Gorica | IDO jul |
| `stojan-terzic` | Stojan Terzić | general_medicine | Izabrani doktor za odrasle, Ambulanta Donja Gorica | IDO jul |
| `elenora-vujosevic` | Elenora Vujošević | general_medicine | Izabrani doktor za odrasle, Ambulanta Donja Gorica | IDO jul |
| `dusan-popovic` | Dušan Popović | general_medicine | Izabrani doktor za odrasle, Ambulanta Gornja Gorica | IDO jul |
| `ljirim-djokaj` | Ljirim Đokaj | general_medicine | Izabrani doktor za odrasle, Ambulanta Gornja Gorica | IDO jul |
| `bogdan-zogovic` | Bogdan Zogović | general_medicine | Izabrani doktor za odrasle, Ambulanta KAP-a | IDO jul |
| `kenan-katana` | Kenan Katana | general_medicine | Izabrani doktor za odrasle, terenske (seoske) ambulante | IDO jul |
| `bozica-ostojic` | Božica Ostojić | general_medicine | Izabrani doktor za odrasle | IDO maj + vikend okt |
| `marija-zujovic` | Marija Žujović | general_medicine | Izabrani doktor za odrasle | IDO maj + vikend okt |
| `milena-dragovic` | Milena Dragović | general_medicine | Izabrani doktor za odrasle | IDO maj + vikend sep |
| `sanja-saric` | Sanja Šarić | general_medicine | Izabrani doktor za odrasle | IDO jun + vikend sep |
| `djeneta-kuc` | Đeneta Kuč | general_medicine | Izabrani doktor za odrasle | IDO maj + vikend okt |
| `ajla-muric` | Ajla Murić | general_medicine | Izabrani doktor za odrasle | IDO vikend sep-okt |
| `andrej-bakalbasic` | Andrej Bakalbašić | general_medicine | Izabrani doktor za odrasle | IDO vikend jul-okt |
| `lida-ademovic` | Lida Ademović | general_medicine | Izabrani doktor za odrasle | IDO vikend avg-okt |
| `nikola-zelovic` | Nikola Zelović | general_medicine | Izabrani doktor za odrasle | IDO vikend okt |
| `nikolina-boljevic` | Nikolina Boljević | general_medicine | Izabrani doktor za odrasle | IDO vikend okt |
| `tamara-besovic` | Tamara Bešović | general_medicine | Izabrani doktor za odrasle | IDO vikend jul-okt |
| `gordana-bijelic` | Gordana Bijelić | pediatrics | Izabrani doktor za djecu, ZO Blok V | IDD apr |
| `haki-mavric` | Haki Mavrić | pediatrics | Izabrani doktor za djecu, ZO Blok V | IDD apr |
| `gordana-marojevic` | Gordana Marojević | pediatrics | Izabrani doktor za djecu, ZO Stara Varoš | IDD apr |
| `aida-perizovic-osmanovic` | Aida Perizović-Osmanović | pediatrics | Izabrani doktor za djecu, ZO Stari Aerodrom | IDD apr |
| `alma-dresevic` | Alma Drešević | pediatrics | Izabrani doktor za djecu, ZO Stari Aerodrom | IDD apr |
| `ljiljana-plamenac` | Ljiljana Plamenac | pediatrics | Izabrani doktor za djecu, ZO Stari Aerodrom | IDD apr |
| `mirjana-tijanic-malidzan` | Mirjana Tijanić Malidžan | pediatrics | Izabrani doktor za djecu, ZO Nova Varoš | IDD apr |
| `milutinka-grgur` | Milutinka Grgur | pediatrics | Izabrani doktor za djecu, ZO Nova Varoš | IDD apr |
| `jela-knezevic` | Jela Knežević | pediatrics | Izabrani doktor za djecu, ZO Nova Varoš | IDD apr |
| `sucuri-hodzic` | Šućuri Hodžić | pediatrics | Izabrani doktor za djecu, ZO Konik | IDD apr |
| `merica-ademovic` | Merica Ademović | pediatrics | Izabrani doktor za djecu, ZO Tuzi | IDD apr |
| `nikoleta-badnjar` | Nikoleta Badnjar | pediatrics | Izabrani doktor za djecu, ZO Golubovci | IDD apr |
| `slobodan-vukotic` | Slobodan Vukotić | pediatrics | Izabrani doktor za djecu, ZO Zlatica | IDD apr |
| `mirela-hodzic` | Mirela Hodžić | pediatrics | Izabrani doktor za djecu | IDD noćna jun-avg |
| `ivan-vukcevic` | Ivan Vukčević | pediatrics | Izabrani doktor za djecu | IDD noćna jul-avg |
| `tamara-milovic` | Tamara Milović | pediatrics | Izabrani doktor za djecu | dopunski jan-apr |
| `vanja-popovic` | Vanja Popović | gynecology_obstetrics | Izabrani doktor za žene, ZO Blok V | IDZ okt |
| `mersiha-frljuckic` | Mersiha Frljučkić | gynecology_obstetrics | Izabrani doktor za žene, ZO Blok V | IDZ okt |
| `biljana-dakic-poltikovic` | Biljana Dakić-Poltiković | gynecology_obstetrics | Izabrani doktor za žene, ZO Blok V | IDZ okt |
| `mitra-mugosa` | Mitra Mugoša | gynecology_obstetrics | Izabrani doktor za žene, ZO Blok V | IDZ okt |
| `ljiljana-vuceljic` | Ljiljana Vučeljić | psychiatry | Centar za mentalno zdravlje | CMZ okt |
| `ljubinko-kaludjerovic` | Ljubinko Kaluđerović | psychiatry | Centar za mentalno zdravlje | CMZ okt |
| `ivana-siljak` | Ivana Šiljak | psychiatry | Centar za mentalno zdravlje | CMZ okt |
| `milena-slovinic` | Milena Slovinić | psychiatry | Centar za mentalno zdravlje | CMZ okt |
| `marko-djurdjic` | Marko Đurđić | psychology | Centar za mentalno zdravlje (spec. medicinske psihologije) | CMZ okt |
| `bojan-medojevic` | Bojan Medojević | radiology | Centar za RTG i ultrazvučnu dijagnostiku | RTG okt-nov |
| `nikola-pejovic-2` | Nikola Pejović | radiology | Centar za RTG i ultrazvučnu dijagnostiku | RTG okt-nov |
| `srdjan-perazic` | Srđan Perazić | internal_medicine | Internistička ambulanta | INT okt |
| `maras-nikpreljaj` | Maraš Nikpreljaj | internal_medicine | Internistička ambulanta | INT okt |
| `vesna-braunovic` | Vesna Braunović | internal_medicine | Internistička ambulanta | INT okt |
| `svetlana-kekovic` | Svetlana Keković | occupational_medicine | Centar za medicinu rada | MR okt |
| `savica-mickovic` | Savica Mićković | occupational_medicine | Centar za medicinu rada | MR okt |
| `cvetana-vukajlovic` | Cvetana Vukajlović | occupational_medicine | Centar za medicinu rada | MR okt |
| `andrea-pejovic-jelenkovic` | Andrea Pejović Jelenković | psychology | Centar za medicinu rada (psiholog) | MR okt |
| `tomislav-simun` | Tomislav Šimun | ophthalmology | Šef Oftalmološke ambulante | OFT sep |
| `mirela-hadrovic` | Mirela Hadrović | ophthalmology | Oftalmološka ambulanta | OFT sep |
| `snezana-mitrovic` | Snežana Mitrović | general_medicine | Centar za sportsku medicinu (spec. sportske medicine) | SPORT okt |
| `dalibor-coric` | Dalibor Ćorić | general_medicine | Centar za sportsku medicinu (spec. sportske medicine) | SPORT okt |
| `sasenko-ceranic` | Sašenko Ćeranić | general_medicine | Centar za sportsku medicinu (spec. sportske medicine) | SPORT okt |
| `stanka-mrdak` | Stanka Mrdak | pediatrics | Centar za djecu sa posebnim potrebama | CDPP maj |
| `dusko-dziknic` | Duško Džiknić | speech_therapy | Centar za djecu sa posebnim potrebama (logoped) | CDPP maj |
| `dubravka-lazarevic-terzic` | Dubravka Lazarević-Terzić | psychology | Centar za djecu sa posebnim potrebama (psiholog) | CDPP maj |
| `aleksandra-klisic` | Aleksandra Klisić | clinical_biochemistry | Šefica Centra za laboratorijsku dijagnostiku | LAB sep |
| `ozrenka-kurgas` | Ozrenka Kurgaš | clinical_biochemistry | Centar za laboratorijsku dijagnostiku | LAB sep |
| `mirela-sebek` | Mirela Šebek | clinical_biochemistry | Centar za laboratorijsku dijagnostiku | LAB sep |
| `andrea-ivanovic` | Andrea Ivanović | clinical_biochemistry | Centar za laboratorijsku dijagnostiku | LAB sep |

### Тёзки в БД — другой человек, отдельная запись

- `ivana-jovanovic-2` — IDO, ZS Blok V. `ivana-jovanovic` в БД — нейрохирург КЦЦГ.
- `nikola-pejovic-2` — радиолог ДЗ. `nikola-pejovic` в БД — врач общей практики ДЗ Будва.
- `jelena-ivanovic` — IDO, ZS Nova Varoš. В БД есть `ivanovic-jelena` — радиолог Milmedika/Konzilijum/Danilo.
- `jela-knezevic` (педиатр IDD) ≠ `jelena-knezevic` (гинеколог Natal).
- `marija-medjedovic` (IDO, Donja Gorica) ≠ `maida-medjedovic` (общая практика, Naša medicina).
  Во всех графиках и в «Dopunski rad» — «Marija».
- `mirela-sebek` (биохимик) ≠ `sebek-mirko` (пульмонолог).

### Опечатки и дубли в PDF — слиты, выбрано написание

| Выбрано | Варианты в PDF | Почему |
|---|---|---|
| Jasmina Kajabegović Martinović | Kjabegović-Martinović, Kajabegović | «Kajabegović» в командных списках |
| Ljirim Đokaj | Lirim Đokaj (графики выходных) | «Ljirim» в командных списках и в официальном «Dopunski rad» |
| Mihajlo Vukanić | Mihailo | «Mihajlo» в командных списках |
| Tereze Dreshaj | Tereza (графики выходных) | «Tereze» во всех командных списках IDO, албанская форма |
| Đeneta Kuč | Đenet Kuč | «Đeneta» встречается чаще |
| Nedžmija Beriša | Beriša Nedžmija | порядок «имя фамилия» |
| Jasminka Zec-Saveljić | Jasmina Zec-Saveljić, Jasminka Zec | командные списки и «Dopunski rad» |
| Tijana Petrić | Tijana Petrović (выходные, май) | Petrić везде, кроме одного места |
| Lidija Samardžić | Smardžić | опечатка |
| Vesna Đuretić | Vesana | опечатка |
| Biljana Raičević-Fuštar | Raričević Fuštar | опечатка; в БД уже `biljana-raicevic-fustar` |
| Srđan Perazić | Srdjan | сербское написание, slug тот же |
| Maraš Nikpreljaj | «Dr Nikpreljaj Maraš» (интернисты) | в «Dopunski rad» 2022: «Dr Maraš Nikpreljaj, internista»; Maraš — албанское мужское имя (Marash) |
| Milovan Jovanović | «Milovaj» в «Dopunski rad» | опечатка; в БД `milovan-jovanovic` |

Не приняты как отдельные врачи: «Tamara Martinović» — склейка строк «dr Tamara / Bešović» с
соседним «Kjabegović-/Martinović»; «Jasmina Mikavica» — та же склейка с Snežana Mikavica;
«Aldijana Đurović» — единичное упоминание в выходных сентября, по всей видимости смесь Aldijana
Zeković и Ljiljana Đurović.

### Решения по отдельным врачам

- **Jelena Damjanović** — одна запись, `general_medicine`. Она есть в команде IDO (Ambulanta
  Donja Gorica, апрель–июль), в IDD (ZO Blok V в апреле, ночные смены июль–август) и в «Dopunski rad»
  как «Izabrani doktor za djecu». Педиатр в команде IDO для взрослых не работает, а врач общей
  практики в IDD может. Считаем, что это один врач общей практики на двух службах.
- **Medicina rada: врачей 4, а не 5.** По ячейкам таблицы шапка «DOKTORI» объединяет колонки 1–4
  (Ušćumlić, Keković, Mićković, Vukajlović), а «MEDICINSKE SESTRE» — 5–9. Anka Bašović — медсестра,
  не заведена. Специальность medicine rada подтверждена у Ušćumlić и Vukajlović («Dopunski rad»).
- **Sportska medicina** (Mitrović, Ćorić, Ćeranić — «spec. sportske medicine»): в справочнике
  нет спортивной медицины. Поставлен `general_medicine`, а «spec. sportske medicine» записан в position.
- **Amer Halilović** — пульмонолог: так у него в БД (Konzilijum).
- **Stanka Mrdak** — «doktor» CDPP (май 2026), специальность не указана. Поставлен `pediatrics`
  по службе: центр для детей, начальница — педиатр.
- **Биохимики** (Klisić — «Doc. dr, spec. kliničke biohemije», Kurgaš, Šebek, Ivanović) — `clinical_biochemistry`.
  В справочнике она есть, и в БД уже 16 таких специалистов у других клиник.
- **Психологи** (Đurđić — spec. medicinske psihologije, Pejović Jelenković, Lazarević-Terzić) —
  `psychology`. **Логопед** Duško Džiknić — `speech_therapy`. Оба направления у ДЗ Бар уже есть.
  **Дефектолог** Irena Šćepanović не заведена: специальности нет.
- **Tamara Milović** — педиатр IDD по «Dopunski rad» (19.03.2026, «specijalista pedijatar»), в графиках
  её нет. Заведена, потому что сайт ДЗ представляет её как педиатра IDD.

## Не заведены

- **Luka Gošović** (IDO, Ambulanta Zlatica) — в командах апреля–июня есть, в июльской команде и в
  графиках выходных июля–октября нет. Похоже, ушёл.
- **IDO-врачи только из «Dopunski rad» за январь–апрель:** Daria Vuiovich, Matija Bojić, Nataša Popović,
  Andrijana Rakočević, Božidar Ćaćić, Ksenija Zečević. Ни в одном графике с апреля по октябрь их нет.
- **Jelena Đurović** (психиатр, CMZ) — только в «Dopunski rad» за январь, в графиках CMZ май–октябрь её нет.
- **Не врачи:** медсёстры и техники всех служб, Anka Bašović (медсестра медицины труда), дефектолог.
- **Директор** dr Dragana Durković — администрация, в графиках не врач.

## Не тронуто

- Имена существующих записей (`dubravka-lopicic`, `alma-crnovrsanin`) не расширены до двойных фамилий из документов ДЗ.
- Специальности существующих врачей не менялись.
