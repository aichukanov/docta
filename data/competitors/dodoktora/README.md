# dodoktora.me — разбор конкурента (2026-10-08)

Обход по sitemap (390 URL), сверка с локальной БД, проверка кандидатов: сайты (curl), реестр CompanyWall, наш `data/google-places/` (снимок ~март–май 2026, API не дёргали).

- `clinic-candidates.json` — 44 учреждения, которых у нас нет: данные конкурента + вердикт + Google (рейтинг/кол-во/дата последнего отзыва) + врачи с их собственного сайта + источники.
- `doctor-candidates.json` — 16 врачей конкурента без точного совпадения в нашей БД.

## Что за сайт

- Новый: даты «Podaci provjereni» — август–октябрь 2026, в поисковиках почти не индексируется. Lovable + TanStack Start, Cloudflare.
- Объём: 98 медучреждений + 28 аптек, 253 врача (у нас 153 клиники, 1726 врачей).
- Нет цен, нет отзывов, нет фото врачей; услуги у клиники — короткий список из 2–9 пунктов.
- «AI-поиск» на GPT; заявлены языки sr/en/ru/tr, но отдельных URL под языки нет (`/en` → 404) — индексируется только черногорский.
- **Сильная сторона — работа с клиниками:** бесплатное «Potvrdite profil», плашка «Podaci potvrđeni od ustanove». Подтвердили уже 48 (включая аптеки): Konzilijum, SmartMed, Natal, Diagnostica, MedTim, Ars Medica, Medicus Tim, Naša medicina, Spa Medica, Vertebra и др. Платная видимость заявлена.
- Врачи: 237 из 253 точно совпадают с нашими, у 235 — та же клиника. Врачей берут с сайтов тех же клиник: Codra 82, Konzilijum 38, SmartMed 38, Milmedika 23, MedTim 17, Moj Lab 15.

## Клиники, которых у нас нет

Google = рейтинг/отзывов (последний отзыв) из нашего снимка Places.

### Добавлять (23)

| Клиника | Город | Google | Врачи на сайте | Замечания |
|---|---|---|---|---|
| Poliklinika Mela Sana | Подгорица | 4.2/24 | 16 | сайт не менялся с 2022 — состав может устареть |
| Poliklinika Da Vinci | Подгорица | 4.2/14 | 18 | дневной стационар, консультанты КЦЦГ/ВМА |
| Internos Medical Centar | Подгорица | 4.2/17 | 9 | с 2016, лаборатория |
| Feniks Medika | Подгорица | 3.0/24 | — | лаборатория, рентген, маммография; сайт 2023 |
| PZU PAT LAB | Подгорица | 4.7/13 | 2 | патоморфология + психиатрия, ~2025 |
| Sanicard | Подгорица | 5/2 | 1 | педиатрия/кардиология с 1993; два адреса на сайте |
| AXON (Fizio Axon) | Подгорица | 5/35 | 5 | новая (рег. 09.2025), физиатр + физиотерапевты |
| Dental Protection | Подгорица | 4.7/31 | 4 | сайт брошен с 2019 |
| Stefanija Dental | Подгорица | 5/37 | 1 | новая (сайт 11.2025) |
| Dental Implant Centar (Keković) | Подгорица | 4.2/10 | 1 | с 2017 |
| Ortholine | Подгорица | 4.5/8 | 3 | ортодонтия, с 2004 |
| V Dental Centar | Подгорица, Будва | 4.2/13 | 8 | расхождение номера дома (13/3 vs 313) |
| Poliklinika Dr Vuksanović | Бар (+ Улцинь) | 4.1/29 | 7 | лаборатория + медицина труда с 1999; список врачей PDF 09.2026; второй филиал в Улцине у конкурента не указан |
| Poliklinika Stojanović Medical | Беране | 5/25 | — | МРТ, КТ; **есть прайс** /cjenovnik-2/ |
| Dom zdravlja Dr Nika Labović | Беране | 5/1 | — | государственный ДЗ |
| Dom zdravlja Cetinje | Цетинье | 5/7 | 12 | государственный ДЗ, графики на 10.2026 |
| AK Medica | Биело-Поле | 4.6/5 | 13 | новая (~2025), сайт живой |
| Fizio centar Nikšić | Никшич | 4.9/39 | 7 физиотерапевтов | врачей нет |
| Poliklinika Nikčević | Никшич | 4.0/12 | 4 (от конкурента) | стоматология; сайта нет, но с 2004, 16 сотрудников |
| Đurković Dent | Никшич, Подгорица | 4.5/8 | 4 | |
| PZU Moj Doktor | Никшич | 3.7/3 | 4 | сайт сломан (SSL, 403), сама клиника реальна |
| Dental Montenegro | Будва (Бечичи) | 4.4/43 | — | с 2004, второй адрес — Splendid Dental |
| Stomatološka ordinacija Dr Ševaljević | Тиват | 4.6/20 | 3 | с 1997, сайт ~2015 |

### Пограничные: реальны, но одиночная практика или нет сайта

| Клиника | Город | Google | Почему не в основном списке |
|---|---|---|---|
| Ordinacija Dr Radunović | Подгорица | 4.9/82 | хиропрактика, один врач |
| NeuroPrima | Будва, Подгорица | 4.4/51 | сайта нет; в Places — Будва |
| Fizio Tim | Подгорица | 4.9/42 | только 2 физиотерапевта |
| Dental Health | Будва | 4.6/42 | сайта нет; в Places — под названием «Jadranski put 6» по тому же адресу |
| Pollex Physio | Подгорица | 5/25 | шаблонный сайт, физиотерапия |
| Dentalex | Подгорица | 5/15 | только Facebook, последний отзыв 2023 |
| Ordinacija Bralić | Рожае | 5/7 | только Instagram |
| Dentaland | Подгорица | 5/6 | сайта и соцсетей нет |
| Dental Studio Cerović | Подгорица | 4.2/5 | с 2011, но ни сайта, ни соцсетей |
| Fizio Family | Подгорица | 5/3 | один сотрудник, Instagram ~2,8 тыс. |

### Не добавлять

- Dental Care (Цетинье), Dental Plaza M, MGM Dental, Stomatološka ordinacija Dr Stojanović, Fizio centar Kojović — нет ни сайта, ни отзывов.
- Džudović Therapy (массажист), Healing Center Montenegro (альтернативная медицина), Nova Physio, Physio T — не медучреждения или существование не подтверждается.
- Standard Poliklinika — старое имя нашего Novi Standard (тот же телефон и соцсети; standard.me заброшен).
- Poliklinika Medikol — ПЭТ/КТ физически стоит в Codra Hospital, черногорское юрлицо Medikol медицинским учреждением не является. Правильнее добавить ПЭТ/КТ услугой к Codra.

## Филиалы наших сетей, которых нет у нас

| Сеть | Филиал у конкурента |
|---|---|
| Konzilijum | Radanovići bb, Kotor, +382 32 670 670 |
| Diagnostica | Tuzi bb (лаборатория + педиатрия), +382 67 128 575; Golubovci bb, Zeta, +382 67 633 777; «Diagnostica II – Laboratorija» (Подгорица) |
| Dr Zejnilović | лаборатория, Ulica Slobode 17, Bijelo Polje, +382 50 200 810 |
| A3 Medical | Pedijatrijski centar Bar |
| Dr Masoničić | Fizikalna terapija Bar |
| Poliklinika Filipović | Master Kvart |
| SmartMed | «Ginekologija»; основной адрес у конкурента — Milutina Vučinića bb, Blok IX, у нас — Trg Božane Vučinić 1 |
| Novi Standard | Подгорица (Moskovska 87) и лаборатория в Улцине — на novistandard.me Подгорицы нет, надо проверить |

## Врачи

Почти вся база врачей конкурента у нас уже есть. Не совпали по имени:

- **Уже у нас, другое написание:** Branimir (Brano) Vlahović, Miodrag (Miša) Ostojić, Ljiljana (Ćirković) Natalić, Ljilja = Bobić Ljiljana, Sergei = Sergej Alpatov.
- **Optimal:** Aleksandar Paškovski и Edita Files-Bradarić уже есть в `data/clinic-teams/map.json` как siteOnly. Edita есть в БД, но не привязана ни к одной клинике — привязать к Optimal. Sara Gargović у конкурента записана офтальмологом, а на сайте Optimal она анестезиолог КЦЦГ с 2002 года; возможно, это наша Gargović-Babović Samira (анестезиолог Codra/Danilo).
- **В клиниках, которых у нас нет:** Poliklinika Nikčević — Dejan Nikčević, Jovan Vujović, Matija Vujović, Miljan Janković; Dental Protection — Marko Popović, Žana Popović, Novak Popović (на сайте клиники детский стоматолог — Milovan Popović), Petar Popović (у нас ортодонт с тем же именем в Kulušić, Никшич; возможно, тот же человек); Moj Doktor — Ljiljana Adžić; Dental Care Cetinje — Maja Jovović.

Основной источник новых врачей — сайты новых клиник: Da Vinci 18, Mela Sana 16, AK Medica 13, ДЗ Цетинье 12, Internos 9, V Dental 8, Vuksanović 7. Списки лежат в `clinic-candidates.json` → `doctors_on_site`. Перед импортом их нужно сверить с сайтом: агенты собирали их по-быстрому, а у Vuksanović диакритику в части имён восстановили наугад.
