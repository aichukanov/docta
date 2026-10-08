# Кандидаты на добавление

Генерируется `node scripts/clinics/build-clinic-candidates.mjs`. Последняя сборка: **2026-10-08**.
Как устроено и как обновлять — [README.md](README.md), порядок работы — [PLAN.md](PLAN.md).

В очереди: 496 (1-я — 6, 2-я — 74, 3-я — 104, 4-я — 312). Уже в БД: 122. Исключено: 31. Вне Черногории (не учитываются): 37.

«Отзывы Google» — число отзывов на дату выгрузки места (`collectedAt`, март–сентябрь 2026); «скачано» — сколько отзывов уже лежит в файле места.

## 1. Прайс и врачи

| # | Клиника | Город | Сайт | Что есть | Отзывы Google | Где ещё есть | Источники |
|---|---|---|---|---|---|---|---|
| 1 | MOA clinic | podgorica | moa.clinic | прайс ~147 + врачей 9 | 0 | таблица | [прайс](https://moa.clinic/cjenovnik-usluga-dermatovenerologija/) [врачи](https://moa.clinic/) |
| 2 | Stomatološka ordinacija Lopičić | podgorica | stomatoloskaordinacija.me | прайс ~106 + врачей 3 | 61 |  | [прайс](https://www.stomatoloskaordinacija.me/cjenovnik) [врачи](https://www.stomatoloskaordinacija.me/o-nama) |
| 3 | OrthoExpert Physio Podgorica | podgorica | orthoexpert.me | прайс ~68 + врачей 3 | 14 |  | [прайс](https://www.orthoexpert.me/cenovnik) [врачи](https://www.orthoexpert.me/o-nama/lekari-fizioterapeuti) |
| 4 | DentArt | tivat | dentart.me | прайс ~46 + врачей 2 | 23 |  | [прайс](https://dentart.me/cenovnik/) [врачи](https://dentart.me/o-nama/) |
| 5 | Ordinacija Obradović Medical | podgorica | obradovicmedical.me | прайс ~12 + врачей 1 | 6 | таблица | [прайс](https://obradovicmedical.me/Cjenovnik_Obradovic_jun_2026.pdf) [врачи](https://obradovicmedical.me/) |
| 6 | Stomatološka ordinacija Prima Dent | podgorica | primadent.me | прайс ~32 + врачей 1 | 0 |  | [прайс](https://www.primadent.me/cjenovnik/) [врачи](https://www.primadent.me/) |

## 2. Хотя бы список услуг, цены или врачи

| # | Клиника | Город | Сайт | Что есть | Отзывы Google | Где ещё есть | Источники |
|---|---|---|---|---|---|---|---|
| 1 | Poliklinika Stojanović Medical | berane | → https://poliklinikastojanovic.me/cjenovnik-2/ | прайс, список услуг | 25 | dodoktora | [прайс](https://poliklinikastojanovic.me/cjenovnik-2/) |
| 2 | Klinika Podgorica / Feniks Medika | podgorica | feniks-medika.me | прайс, список услуг | 24 | таблица, dodoktora | [прайс](https://feniks-medika.me/wp-content/uploads/2023/03/CJENOVNIK-USLUGA-PZU-POLIKLINIKE-2022-2023.docx) |
| 3 | Cirkon Dental Lab - dental clinic and dental laboratory |  | cirkondentallab.com | прайс, список услуг | 0 | таблица | [прайс](https://www.cirkondentallab.com/cjenovnik) |
| 4 | ZU Dom zdravlja Nikšić | niksic | domzdravljaniksic.me | врачей 42, список услуг | 13 (скачано 10) |  | [врачи](https://domzdravljaniksic.me/izabrani-doktor/) |
| 5 | Health center Ulcinj | ulcinj | domzdravljaulcinj.me | врачей 31, список услуг | 13 |  | [врачи](https://domzdravljaulcinj.me/izabrani-doktori-za-djecu/) |
| 6 | JZU Dom zdravlja Dr Nika Labović | berane | domzdravljaberane.me | отдельные цены, врачей 27, список услуг | 1 | dodoktora | [прайс](https://domzdravljaberane.me/index.php/ljekarska-uvjerenja) [врачи](https://domzdravljaberane.me/index.php/brojevi-telefona-u-ordinacijama) |
| 7 | Health Center Rozaje | berane | dzrozaje.me | врачей 24, список услуг | 3 |  | [врачи](https://dzrozaje.me/organizacione-jedinice/) |
| 8 | Poliklinika DaVinci | podgorica | davincipoliklinika.me → https://davincipoliklinika.me/tim-davinci/ | врачей 18, список услуг | 14 | таблица, dodoktora | [прайс](https://davincipoliklinika.me/cjenovnik/) [врачи](https://davincipoliklinika.me/tim-davinci/) |
| 9 | Дом здравља Цетиње | cetinje | dzcetinje.me | отдельные цены, врачей 18, список услуг | 7 | dodoktora | [прайс](https://www.dzcetinje.me/images/dokumenta/Cjenovnik_i_saglasnost.pdf) [врачи](https://www.dzcetinje.me/index.php/srp/organizacija/timovi-izabranih-doktora) |
| 10 | Mela Sana | podgorica | melasana.me | врачей 13, список услуг | 24 | таблица, dodoktora | [врачи](http://www.melasana.me/all-doctors.html) |
| 11 | POLIKLINIKA AK MEDICA | bijelo-polje | akmedica.me | врачей 13, список услуг | 5 | таблица, dodoktora | [врачи](https://akmedica.me/nas-tim/) |
| 12 | Privatna ordinacija "Vuleković" | podgorica | vulekovic.me | врачей 11, список услуг | 9 | таблица | [врачи](https://vulekovic.me/nasi-ljekari/) |
| 13 | Mićunović Medical | podgorica | micunovicmedical.me | врачей 11, список услуг | 74 | таблица | [врачи](https://www.micunovicmedical.me/nas-tim/) |
| 14 | Moj Doktor | niksic | mojdoktor.co.me | отдельные цены, врачей 9, список услуг | 3 | таблица, dodoktora | [прайс](https://mojdoktor.co.me/laboratorijske-analize/) [врачи](https://mojdoktor.co.me/onama/) |
| 15 | V Dental Centar | budva | vdental.me | врачей 8, список услуг | 36 (скачано 10) | таблица, dodoktora | [врачи](https://www.vdental.me/doktori) |
| 16 | Internos Medical & Laboratorija | podgorica | internosmedical.me | врачей 8, список услуг | 17 | dodoktora | [врачи](https://internosmedical.me/) |
| 17 | Poliklinika - Dr Fatic Medical | podgorica | drfaticmedical.com | врачей 8, список услуг | 12 |  | [врачи](https://drfaticmedical.com/) |
| 18 | Fizio | podgorica | fiziopg.me | врачей 7, список услуг | 18 | таблица | [врачи](https://www.fiziopg.me/api.php?action=load) |
| 19 | Fizio Centar - Nikšić | niksic | fiziocentar.me | отдельные цены, врачей 6, список услуг | 39 | dodoktora | [прайс](https://fiziocentar.me/usluge/) [врачи](https://fiziocentar.me/o-nama/) |
| 20 | Poliklinika Dr Vuksanović | bar | drvuksanovic.me | врачей 6, список услуг | 29 | dodoktora | [врачи](https://drvuksanovic.me/wp-content/uploads/dokumenti/Raspored-zdravstvenih-radnika.pdf) |
| 21 | Axon fizikalna terapija | podgorica | → https://www.fizioaxon.com/ | врачей 5, список услуг | 35 | dodoktora | [врачи](https://www.fizioaxon.com/o-nama.html) |
| 22 | Dental Protection | podgorica | dentalprotection.me | врачей 4, список услуг | 31 | dodoktora | [врачи](https://dentalprotection.me/our-clinic/team/) |
| 23 | Dentix - Стоматолошка ординација Др.Ђурковић | niksic | djurkovicdent.me | врачей 4, список услуг | 31 (скачано 10) | таблица, dodoktora | [врачи](https://www.djurkovicdent.me/) |
| 24 | Stomatološka Poliklinika "Vukotić" | herceg-novi | dentalclinicvukotic.com | врачей 4, список услуг | 28 (скачано 6) | таблица | [врачи](https://dentalclinicvukotic.com/tim/) |
| 25 | Health & Wellbeing Retreat de ‘Mar - Vrmac | tivat | vrmacwellbeing.com | отдельные цены, врачей 4, список услуг | 3 |  | [прайс](https://vrmacwellbeing.com/health-wellbeing-programs/longevity-living-healthy-aging-program/) [врачи](https://vrmacwellbeing.com/about-us/) |
| 26 | Tafica Dental Clinic | ulcinj | tafica.com | врачей 4 | 15 |  | [врачи](https://www.tafica.com/) |
| 27 | Ana Medica | podgorica | → https://anamedica.me/ | врачей 3, список услуг | 49 |  | [врачи](https://anamedica.me/) |
| 28 | Center for Dental Implantology and Cosmetic Dentistry-Dental Montenegro | budva | dentalmontenegro.com | врачей 3, список услуг | 43 | таблица, dodoktora | [прайс](https://www.dentalmontenegro.com/me/cijene) [врачи](https://www.dentalmontenegro.com/me/o-nama) |
| 29 | Mercur Nera | podgorica | mercurnera.me → https://mercurnera.me/ | врачей 3, список услуг | 23 | таблица | [врачи](https://mercurnera.me/index.php?option=com_content&view=article&id=73&Itemid=491) |
| 30 | Stomatološka ordinacija Dentalux | tivat | dentalux.me | врачей 3, список услуг | 22 |  | [врачи](https://www.dentalux.me/me/naš-tim/) |
| 31 | Stomatološka ordinacija ,,dr Ševaljević'' / Dentist "dr Sevaljevic" | tivat | drsevaljevic.me | врачей 3, список услуг | 20 | dodoktora | [врачи](http://www.drsevaljevic.me/) |
| 32 | K-med Ambulanta i Pedijatrijska Ambulanta Bar 2 | bar | kmed.me | врачей 3, список услуг | 15 (скачано 7) | таблица | [врачи](https://kmed.me/) |
| 33 | Stomatološka ordinacija - Dent-ES | podgorica | dent-es.me | врачей 3, список услуг | 11 |  | [врачи](https://dent-es.me/strucni-tim/) |
| 34 | Razvojni centar Integra | podgorica | integracentar.me | врачей 3, список услуг | 9 |  | [врачи](https://integracentar.me/nas-tim-psihologa/) |
| 35 | Stomatoloska Ordinacija Ortholine | podgorica | ortholine.me → https://stomatologpodgorica.me/ | врачей 3, список услуг | 8 | таблица, dodoktora | [врачи](https://ortholine.me/o-nama) |
| 36 | PhysioCare Team | podgorica | physiocareteam.me | врачей 3, список услуг | 0 |  | [врачи](https://physiocareteam.me/) |
| 37 | Dr Radunovic - Chiropractic & Physical Therapy | podgorica | kiropraktika.me | врачей 2, список услуг | 82 | dodoktora | [врачи](https://kiropraktika.me/o-nama) |
| 38 | SeaStars “edukativni centar” za skoliozu i ranu dječiju terapiju | herceg-novi | seastarscentar.me | врачей 2, список услуг | 82 |  | [врачи](https://seastarscentar.me/o-centru) |
| 39 | Ambulanta | kotor | ginekologijakotor.com | врачей 2, список услуг | 62 |  | [врачи](https://ginekologijakotor.com/) |
| 40 | FIZIO TIM CRNA GORA | podgorica | fiziotim.me | врачей 2, список услуг | 42 | таблица, dodoktora | [врачи](https://fiziotim.me/nas-tim/) |
| 41 | DENTAL STUDIO PRŽNO | budva | dentalstudioglusica.me → https://dentalstudioglusica.me/ | врачей 2, список услуг | 34 | таблица | [врачи](https://dentalstudioglusica.me/o-nama/) |
| 42 | Dental Smile | tivat | dentalsmiletivat.com | врачей 2, список услуг | 28 |  | [врачи](https://www.dentalsmiletivat.com/o_nama) |
| 43 | Očna bolnica Oftalens Dr Koturović | podgorica | drkoturovic.me | врачей 2, список услуг | 28 |  | [врачи](https://drkoturovic.me/onama.html) |
| 44 | Opšta stomatološka ordinacija Mitranić | bar | mitranicdental.com | врачей 2, список услуг | 20 | таблица | [врачи](https://mitranicdental.com/o-nama/) |
| 45 | Ginekološko akušerska ordinacija "Filia" | tivat | filia.co.me | врачей 2, список услуг | 16 |  | [врачи](https://filia.co.me/o-nama/) |
| 46 | Pat Lab | podgorica | patlab.me | врачей 2, список услуг | 13 | dodoktora | [врачи](https://patlab.me/) |
| 47 | Stomatoloska ordinacija VIVADENT | podgorica | vivadent.me | врачей 2, список услуг | 13 |  | [врачи](https://vivadent.me/o-nama/) |
| 48 | Ordinacija Dr Janković | podgorica | montenegrodentalcare.com | врачей 2, список услуг | 2 |  | [прайс](https://www.montenegrodentalcare.com/indexen.php) [врачи](https://www.montenegrodentalcare.com/) |
| 49 | Kavarić Medical | podgorica | kavaricmedical.me | врачей 2, список услуг | 0 | таблица | [врачи](https://www.kavaricmedical.me/) |
| 50 | Fontis | podgorica | fontiscg.com | врачей 1, список услуг | 55 (скачано 10) |  | [врачи](https://fontiscg.com/nas-tim/) |
| 51 | IMC Fizio | podgorica | imcfizio.me | врачей 1, список услуг | 43 | таблица | [врачи](https://imcfizio.me/#o-nama) |
| 52 | Stomatološka ordinacija Stefanija Dental | podgorica | stefanijadental.me | врачей 1, список услуг | 37 | dodoktora | [врачи](https://stefanijadental.me/dr-stefanija/) |
| 53 | Diagnost - ultrasound diagnostic clinic Montenegro | budva | ultrazvuk.me | врачей 1, список услуг | 15 |  | [врачи](https://www.ultrazvuk.me/o-nama) |
| 54 | Todorovic Ophthalmology & Aesthetics Medicine | kotor | drtodorovic.com | врачей 1, список услуг | 15 |  | [врачи](https://drtodorovic.com/me/o-nama/) |
| 55 | dr Abramović | bar | drabramovic.com | врачей 1, список услуг | 6 | таблица | [врачи](https://www.drabramovic.com/o-nama/) |
| 56 | Specijalistička ordinacija dr Rahović | bijelo-polje | drrahovic.com | врачей 1, список услуг | 5 |  | [врачи](https://www.drrahovic.com/) |
| 57 | Vaskularna hirurgija Dr Fatic Medical | podgorica | vaskularnahirurgija.me | врачей 1, список услуг | 4 |  | [врачи](https://vaskularnahirurgija.me/biografija/) |
| 58 | Zdravstvena ustanova SANICARD | podgorica | sanicard.me | отдельные цены, врачей 1, список услуг | 2 | dodoktora | [прайс](https://sanicard.me/) [врачи](https://sanicard.me/o-nama/) |
| 59 | Медицинский Центр доктора ЗОБИНА | kotor | doctorzobin.com | врачей 1, список услуг | 1 |  | [прайс](https://www.doctorzobin.com/tseny/) [врачи](https://www.doctorzobin.com/doktora/mikhail_zobin/) |
| 60 | Estetska medicina | herceg-novi | timelessbeauty.com | врачей 1, список услуг | 0 |  | [врачи](https://www.timelessbeauty.com/meet-dr-borko/) |
| 61 | ORDINACIJA DR KALUDJEROVIC | podgorica | dermatolog-kaludjer.org | врачей 1, список услуг | 41 | таблица | [врачи](http://www.dermatolog-kaludjer.org/onama.html) |
| 62 | Stomatološka Ordinacija "Polident" Dom zdravlja Bijela | tivat | polident.me | врачей 1, список услуг | 30 | таблица | [врачи](https://polident.me/) |
| 63 | Dental Implant Center (Dr Keković) |  | drkekovic.com | врачей 1, список услуг | 0 | таблица, dodoktora | [врачи](https://www.drkekovic.com/dental-implant-centar.html) |
| 64 | PZU POLLEX PHYSIO | podgorica | pollexphysio.me (expiring_dead) → https://pollexphysio.com/ | список услуг | 25 | dodoktora |  |
| 65 | Stomatološka ordinacija Dr Numanović - Podgorica | podgorica | drnumanovic.me | список услуг | 22 |  | [врачи](https://drnumanovic.me/tim/) |
| 66 | Omnidental | bar | omnidental.me | список услуг | 20 | таблица |  |
| 67 | Stomatoloska ordinacija "Dental&Estetic Centar" | podgorica | dentalesteticcentar.com | список услуг | 12 |  |  |
| 68 | MEDCONTOUR INSTITUTE | budva | medcontour.me | список услуг | 8 |  | [прайс](https://medcontour.me/en/services) |
| 69 | MonteRehab | budva | monterehab.com | отдельные цены, список услуг | 8 |  | [прайс](https://monterehab.com/pricing) |
| 70 | Nova Medicina Rada | podgorica | novamedicinarada.com | список услуг | 7 |  |  |
| 71 | Ital-Dent | podgorica | ital-dent.com | список услуг | 6 |  |  |
| 72 | OssPhysio | bar | oss-physio.com | список услуг | 0 |  |  |
| 73 | Институт за јавно здравље | podgorica | ijzcg.me | список услуг | 64 |  |  |
| 74 | Stomatološka Ordinacija ĐUROVIĆ | berane | ordinacijadjurovic.me | список услуг | 19 |  | [прайс](https://ordinacijadjurovic.me/dentalni-turizam/) |

## 3. Только отзывы (≥ 10 в Google)

| # | Клиника | Город | Сайт | Что есть | Отзывы Google | Где ещё есть | Источники |
|---|---|---|---|---|---|---|---|
| 1 | Dr Baris Erturk Aesthetic / Aesthetic Medicine | budva | — | 122 отзывов в Google | 122 | таблица |  |
| 2 | BulatovićDent, stomatološka ordinacija | budva | bulatovicdent.me (parked) | 82 отзывов в Google | 82 |  |  |
| 3 | NeuroPRIMA | budva | — | 51 отзывов в Google | 51 |  |  |
| 4 | Stomatološka ambulanta "Redžepagić" | podgorica | — | 47 отзывов в Google | 47 |  |  |
| 5 | Dr Rašović | podgorica | — | 46 отзывов в Google | 46 |  |  |
| 6 | Jadranski put 6 | budva | — | 42 отзывов в Google | 42 | таблица |  |
| 7 | Tivari Dental & Clinic | ulcinj | — | 42 отзывов в Google | 42 | таблица |  |
| 8 | Dental Studio Dr Vukovic | kotor | — | 39 отзывов в Google | 39 | таблица |  |
| 9 | DENTAL CLINIC REIDENT | ulcinj | dentalclinicreident.com (free) | 37 отзывов в Google | 37 (скачано 40) | таблица |  |
| 10 | POLIKLINIKA KALINIĆ BAR | bar | — | 37 отзывов в Google | 37 | таблица |  |
| 11 | Fertilis - Ginekološko Akušerska Ordinacija | tivat | — | 36 отзывов в Google | 36 |  |  |
| 12 | Klinika Danica | podgorica | klinikadanica.com (dead) | 36 отзывов в Google | 36 |  |  |
| 13 | Ranka Dent | podgorica | — | 34 отзывов в Google | 34 |  |  |
| 14 | Dr Venco Micovic-stomatolog | podgorica | — | 33 отзывов в Google | 33 |  |  |
| 15 | Dental - M | bar | — | 31 отзывов в Google | 31 |  |  |
| 16 | KARDIO LAB | podgorica | — | 31 отзывов в Google | 31 |  |  |
| 17 | Stomatološka ordinacija Mrvošević | niksic | — | 31 отзывов в Google | 31 |  |  |
| 18 | Ordinacija "REICHEL" | kotor | — | 30 отзывов в Google | 30 |  |  |
| 19 | Poliklinika Neuron | bijelo-polje | — | 30 отзывов в Google | 30 |  |  |
| 20 | Dental Clinic DENTITIO | ulcinj | dentitio.me (dead) | 29 отзывов в Google | 29 | таблица |  |
| 21 | Dentalni i estetski centar Radulović | podgorica | — | 29 отзывов в Google | 29 |  |  |
| 22 | Dr Radovic | budva | businesssite.me | 29 отзывов в Google | 29 |  |  |
| 23 | Stomatološka Ordinacija Belldent - Dr.Stipanić | tivat | — | 29 отзывов в Google | 29 |  |  |
| 24 | Caninus Stomatoloska Ordinacija | herceg-novi | — | 28 отзывов в Google | 28 |  |  |
| 25 | ORL ordinacija "dr Jaćimović" | podgorica | — | 28 отзывов в Google | 28 |  |  |
| 26 | Stomatološka Ordinacija "Konjević" | herceg-novi | — | 28 отзывов в Google | 28 |  |  |
| 27 | Ginekološka ambulanta Dr. Mladenović | budva | — | 27 отзывов в Google | 27 |  |  |
| 28 | Pedijatrijska ambulanta Simonović | podgorica | — | 27 отзывов в Google | 27 |  |  |
| 29 | Stomatološka ordinacija “BAJMAK” | podgorica | — | 27 отзывов в Google | 27 |  |  |
| 30 | Dental Clinic “Pjerotic” | budva | pjerotic.me (free) | 26 отзывов в Google | 26 | таблица |  |
| 31 | Dr Kostic - Centar za stomatologiju i implantologiju | podgorica | — | 26 отзывов в Google | 26 |  |  |
| 32 | Stomatoloska ordinacija "Dr Sobic" | podgorica | — | 26 отзывов в Google | 26 |  |  |
| 33 | dzudovic.therapy | kotor | — | 24 отзывов в Google | 24 | dodoktora |  |
| 34 | Denta lab - stomatološka ordinacija | podgorica | — | 23 отзывов в Google | 23 |  |  |
| 35 | Poliklinika Medicus Plus | podgorica | medicusplus.me (expiring_dead) | 23 отзывов в Google | 23 | таблица |  |
| 36 | Stomatoloska ordinacija Mrdak/Podgorica | podgorica | — | 23 отзывов в Google | 23 |  |  |
| 37 | Mirković pedijatrijska ordinacija | budva | — | 22 отзывов в Google | 22 |  |  |
| 38 | PZU Opšta stomatološka ordinacija "dr Vlaović" | herceg-novi | — | 22 отзывов в Google | 22 |  |  |
| 39 | Razgovor sa psihologom | podgorica | — | 22 отзывов в Google | 22 |  |  |
| 40 | Sine Morbo | podgorica | — | 21 отзывов в Google | 21 |  |  |
| 41 | Eho Medica - Vucetic | budva | — | 20 отзывов в Google | 20 |  |  |
| 42 | KRAPOVIĆ MEDICAL | budva | — | 20 отзывов в Google | 20 |  |  |
| 43 | Ginekološka ordinacija Hera | podgorica | — | 19 отзывов в Google | 19 |  |  |
| 44 | Intermedica | herceg-novi | — | 19 отзывов в Google | 19 |  |  |
| 45 | Neuromedica Dr Slavica Vujisić | podgorica | neuromedica.me (free) | 19 отзывов в Google | 19 |  |  |
| 46 | Stomatološka ordinacija Bar - Dental Husović | bar | — | 19 отзывов в Google | 19 | таблица |  |
| 47 | Turisticka Ambulanta | budva | — | 19 отзывов в Google | 19 |  |  |
| 48 | Dental Art Centar | herceg-novi | — | 18 отзывов в Google | 18 |  |  |
| 49 | Fiziokultura Tivat | tivat | — | 18 отзывов в Google | 18 |  |  |
| 50 | Neurološka ambulanta ZEN dr Dautović | podgorica | — | 18 отзывов в Google | 18 |  |  |
| 51 | Stomatološka ordinacija K - Dental | podgorica | — | 18 отзывов в Google | 18 |  |  |
| 52 | Unimedica Pediatric Clinic | ulcinj | — | 18 отзывов в Google | 18 |  |  |
| 53 | Dental Studio Mijuskovic | niksic | — | 17 отзывов в Google | 17 |  |  |
| 54 | Fizioterapeut Djurovic Herceg Novi | herceg-novi | — | 17 отзывов в Google | 17 |  |  |
| 55 | Sanja DENT | bar | — | 17 отзывов в Google | 17 | таблица |  |
| 56 | Stomatoloska ordinacija Jašović | berane | — | 17 отзывов в Google | 17 |  |  |
| 57 | Zečević dental&aesthetic | niksic | — | 17 отзывов в Google | 17 |  |  |
| 58 | PZU Medalja Zdravlja | budva | medaljazdravlja.me | 16 отзывов в Google | 16 | таблица |  |
| 59 | dr Srdjan Medan | podgorica | — | 15 отзывов в Google | 15 |  |  |
| 60 | Ginekoloska ordinacija Sunce-M | bar | — | 15 отзывов в Google | 15 |  |  |
| 61 | Stomatoloska ordinacija ‚‚VANE" | podgorica | — | 15 отзывов в Google | 15 |  |  |
| 62 | Stomatološka ordinacija Dentalex | podgorica | — | 15 отзывов в Google | 15 | dodoktora |  |
| 63 | Stomatološka ordinacija dr Stojanović | podgorica | — | 15 отзывов в Google | 15 |  |  |
| 64 | Delić Polymedic | herceg-novi | delicpolymedic.com (parked) | 14 отзывов в Google | 14 |  | [врачи](https://ordinacije.me/mne/ordinacije/ordinacija-opste-prakse-delic-polymedic) |
| 65 | Dom zdravlja Zlatica | podgorica | — | 14 отзывов в Google | 14 |  |  |
| 66 | Kalota Stomatologija | bar | — | 14 отзывов в Google | 14 |  |  |
| 67 | Klinika Life | podgorica | — | 14 отзывов в Google | 14 |  |  |
| 68 | Rudo | podgorica | — | 14 отзывов в Google | 14 |  |  |
| 69 | Stomatološka ordinacija "DR RAIČEVIĆ" | podgorica | — | 14 отзывов в Google | 14 |  |  |
| 70 | Stomatološka ordinacija Dr. Ćorović | budva | — | 14 отзывов в Google | 14 |  |  |
| 71 | Stomatoloska ordinacija Mrdovic | podgorica | — | 14 отзывов в Google | 14 |  |  |
| 72 | Cardio Medic | herceg-novi | — | 13 отзывов в Google | 13 |  |  |
| 73 | Dentex BS | cetinje | — | 13 отзывов в Google | 13 |  |  |
| 74 | Fizio Mirli | podgorica | fiziomirli.com (dead) | 13 отзывов в Google | 13 |  |  |
| 75 | Fizio Teres | podgorica | — | 13 отзывов в Google | 13 |  |  |
| 76 | FIZIOTERAPIJA GILESPI | budva | — | 13 отзывов в Google | 13 |  |  |
| 77 | GastroMed | podgorica | — | 13 отзывов в Google | 13 |  |  |
| 78 | O R L Ordinacija Ulcinj | ulcinj | — | 13 отзывов в Google | 13 |  |  |
| 79 | Opšta stomatološka ordinacija dr Čanak | bar | — | 13 отзывов в Google | 13 |  |  |
| 80 | OTO Medica | ulcinj | — | 13 отзывов в Google | 13 |  |  |
| 81 | AM Dental Clinic / dr Almina Murić Zeković | podgorica | — | 12 отзывов в Google | 12 |  |  |
| 82 | Dr mr. Zlatica Popivoda Eskulap ginekološka ordinacija i ultrazvuk | bar | — | 12 отзывов в Google | 12 |  |  |
| 83 | Poliklinika Nikčević | niksic | — | 12 отзывов в Google | 12 |  |  |
| 84 | Stomatologija PERUNOVIC - Orthodontics and Pediatric Dental Care | podgorica | — | 12 отзывов в Google | 12 |  |  |
| 85 | Stomatološka ordinacija "Radovanović" | podgorica | — | 12 отзывов в Google | 12 |  |  |
| 86 | ABA Medica | ulcinj | — | 11 отзывов в Google | 11 |  |  |
| 87 | D-DENT Stomatološka ordinacija | podgorica | — | 11 отзывов в Google | 11 |  |  |
| 88 | Kaluđerović Dental Aesthetics | podgorica | — | 11 отзывов в Google | 11 |  |  |
| 89 | Ordinacija Leković Dentist | bar | — | 11 отзывов в Google | 11 |  |  |
| 90 | Prof. Dr. Maksim Lucic, ORL | herceg-novi | — | 11 отзывов в Google | 11 |  |  |
| 91 | Sano Dens - Stomatoloska ordinacija | podgorica | — | 11 отзывов в Google | 11 |  |  |
| 92 | Sorriso Stomatoloska | bar | — | 11 отзывов в Google | 11 | таблица |  |
| 93 | Stomatolog Dentist Dr Teuta Muçaj | ulcinj | — | 11 отзывов в Google | 11 |  |  |
| 94 | Stomatološka ordinacija "Decima" | podgorica | — | 11 отзывов в Google | 11 |  |  |
| 95 | Stomatoloska ordinacija Gedent | podgorica | — | 11 отзывов в Google | 11 |  |  |
| 96 | Stomatoloska ordinacija Pekovic | podgorica | — | 11 отзывов в Google | 11 |  |  |
| 97 | Z & R Dent | podgorica | — | 11 отзывов в Google | 11 |  |  |
| 98 | Dental Implant Centar | podgorica | — | 10 отзывов в Google | 10 | dodoktora |  |
| 99 | PhysioeS | podgorica | — | 10 отзывов в Google | 10 |  |  |
| 100 | Specijalistička ordinacija 'dr Mijanović' | niksic | — | 10 отзывов в Google | 10 |  |  |
| 101 | Stomatoloska ordinacija "ORVIT" | bar | — | 10 отзывов в Google | 10 | таблица |  |
| 102 | Stomatološka ordinacija Mandić | niksic | — | 10 отзывов в Google | 10 |  |  |
| 103 | Stomatološka ordinacija Sadagić | bijelo-polje | — | 10 отзывов в Google | 10 |  |  |
| 104 | Stomatološka Ordinacija Šestović | podgorica | — | 10 отзывов в Google | 10 |  |  |

## 4. Не в работе

Сайта с содержимым нет и меньше 10 отзывов. 312 мест, список — в `candidates.json` (`tier: 4`).

## Из таблицы: уже на сайте

| Вкладка | Строка таблицы | Клиника в БД | Услуг (с ценой) / анализов / врачей / отзывов | Что сделать |
|---|---|---|---|---|
| на разбор | Opšta bolnica Nikšić — odjeljenje pedijatrije | #141 opsta-bolnica-niksic | 2358 (2358) / 385 / 59 / 0 | врачи педиатрии со страницы отделения — сверить с data/clinic-teams/map.json |
| на разбор | Brezovik — odjeljenja | #139 specijalna-bolnica-za-plucne-bolesti-dr-jovan-bulajic-brezovik | 0 (0) / 0 / 15 / 0 | у клиники 0 услуг — перечень по отделениям |
| на разбор | Bona-lab prima | #67 bona-lab-prima-podgorica | 0 (0) / 1 / 2 / 0 | врачи из Никшича есть только в Instagram — нужны скриншоты |
| на разбор | Dom zdravlja Andrijevica | #129 dom-zdravlja-andrijevica | 0 (0) / 0 / 5 / 0 | у клиники 0 услуг — перечень текстом без цен на /usluge/ |
| на разбор | Dom zdravlja Bijelo Polje — doktori | #87 dom-zdravlja-bijelo-polje | 35 (26) / 0 / 43 / 20 | список врачей; сайт domzdravljabp.me на 2026-10-08 не отвечает |
| на разбор | KBC Kotor — kontakt | #133 opsta-bolnica-kotor | 0 (0) / 0 / 22 / 73 |  |
| Новые города | Bolnica Risan | #131 specijalna-bolnica-za-ortopediju-neurohirurgiju-i-neurologiju-vaso-cukovic-risan | 858 (681) / 115 / 42 / 92 |  |
| Новые города | JZU Opšta bolnica Kotor | #133 opsta-bolnica-kotor | 0 (0) / 0 / 22 / 73 |  |
| Новые города | KBC Kotor | #133 opsta-bolnica-kotor | 0 (0) / 0 / 22 / 73 |  |
| Красота | Aesthetic Medical Centar Barović | #108 aesthetic-medical-centar-barovic-dr-aleksandra-barovic | 0 (0) / 0 / 1 / 185 | услуги не добавлены (заметка в таблице) |
| готово | Luča medical | #82 luca-medical-podgorica | 61 (0) / 0 / 16 / 37 |  |
| готово | Medikid | #89 medikid-podgorica | 12 (0) / 0 / 9 / 17 |  |
| готово | Tesla Medical | #86 tesla-medical-berane | 122 (122) / 900 / 0 / 17 |  |
| готово | A Medic | #90 a-medic-plasticna-i-estetska-hirurgija | 88 (0) / 0 / 3 / 101 |  |
| готово | Oftalmološki centar Dr Raonić | #93 oftalmoloski-centar-dr-raonic-podgorica | 140 (0) / 0 / 8 / 98 |  |
| готово | Spa Medica | #81 spa-medica-podgorica | 49 (49) / 0 / 5 / 10 |  |
| готово | Teo Med | #94 teo-med-pedijatrijska-ambulanta-podgorica | 29 (0) / 0 / 4 / 27 |  |
| готово | Ordinacija Fizikalmed | #96 fizikalmed-fizikalna-ordinacija-podgorica | 0 (0) / 0 / 1 / 163 |  |
| готово | Stomatološka ordinacija Extradent | #98 extradent-stomatoloska-ordinacija-podgorica | 0 (0) / 0 / 1 / 154 |  |
| готово | Dental studio Gaćina | #97 dental-studio-gacina | 0 (0) / 0 / 2 / 117 |  |
| готово | Nova Medic | #101 nova-medic-poliklinika | 165 (165) / 0 / 3 / 155 |  |
| готово | Ordinacija Bošković | #100 dr-boskovic-ginekolosko-akuserska-ordinacija | 30 (30) / 3 / 1 / 19 |  |
| готово | Dr Ražnatović | #102 dr-raznatovic-stomatoloska-ordinacija | 104 (104) / 0 / 5 / 21 |  |
| готово | Fizio Centar Endorfin | #103 endorfin-fizio-centar-podgorica | 19 (0) / 0 / 7 / 115 |  |
| готово | Kulušić Dental Clinic | #99 kulusic-dental-clinic-niksic | 60 (43) / 0 / 7 / 93 |  |
| готово | Ordinacija Barović | #107 barovic-aesthetic-dental-centar | 39 (0) / 0 / 3 / 101 |  |
| готово | Prlja Medical | #109 dr-prlja-medical | 82 (82) / 0 / 2 / 51 |  |
| готово | Ordinacija Bellavista | #110 bellavista-stomatoloska-ordinacija | 27 (27) / 0 / 1 / 13 |  |
| готово | Dr Kukoljac | #111 dr-kukoljac-stomatoloska-ordinacija | 27 (27) / 0 / 1 / 15 |  |
| готово | Ginekološka ordinacija Ranko Medan | #112 ordinacija-medan | 24 (22) / 0 / 1 / 0 |  |
| готово | Doktorica Mica | #113 doktorica-mica-pedijatrijski-centar | 17 (17) / 0 / 21 / 25 |  |
| готово | Medtim | #114 medtim-privatna-bolnica | 150 (0) / 0 / 17 / 75 |  |
| готово | Dr Jovović oftalmologija | #115 dr-jovovic-oftalmoloska-ordinacija | 56 (56) / 0 / 4 / 59 |  |
| готово | Specialized hospital Ars Medica | #116 ars-medica-specijalna-bolnica | 205 (0) / 0 / 16 / 99 |  |
| готово | Mansa Medica Tivat | #118 mansa-medica-tivat | 47 (0) / 2 / 5 / 92 |  |
| готово | Centar za očne bolesti Miljković & Jankov | #119 laserfocus-centar-za-mikrohirurgiju-oka | 0 (0) / 0 / 2 / 41 | это LaserFocus (сообщил юзер 2026-10-08); заметка таблицы — «есть врач, который говорит по-русски»: сверить языки врачей LaserFocus. Старый домен miljkovicjankov.me не резолвится |
| готово | Ortho Centar | #120 ortho-centar | 25 (0) / 0 / 2 / 69 |  |
| готово | Dental Studio Vučetić | #122 dental-studio-vucetic | 31 (29) / 0 / 3 / 78 |  |
| готово | Dental Clinic Kovačević | #123 dental-clinic-kovacevic | 0 (0) / 0 / 3 / 44 |  |
| готово | Stomatološka ordinacija dr Ćetković | #124 dr-cetkovic-stomatoloska-ordinacija | 0 (0) / 0 / 1 / 28 |  |
| готово | Dr Veselinović | #125 dr-veselinovic-stomatoloska-klinika | 100 (0) / 0 / 4 / 65 |  |
| готово | Dom zdravlja Kotor | #126 dom-zdravlja-kotor | 19 (19) / 0 / 37 / 86 |  |
| готово | Dom zdravlja Kolašin | #128 dom-zdravlja-kolasin | 26 (26) / 0 / 22 / 0 |  |
| готово | Dom zdravlja Mojkovac | #127 dom-zdravlja-bosko-dedeic-mojkovac | 297 (297) / 36 / 10 / 0 |  |
| готово | Dom zdravlja Herceg Novi | #80 dom-zdravlja-herceg-novi | 365 (365) / 109 / 43 / 57 |  |
| готово | Bolnica Danilo I — ORL | #88 bolnica-danilo-i-cetinje | 2349 (2296) / 387 / 28 / 26 |  |
| готово | Bolnica Danilo I — osoblje | #88 bolnica-danilo-i-cetinje | 2349 (2296) / 387 / 28 / 26 |  |
| готово | Opšta bolnica Bijelo Polje | #130 opsta-bolnica-bijelo-polje | 0 (0) / 0 / 19 / 0 |  |
| готово | Dom zdravlja Bijelo Polje — izabrani doktori za odrasle | #87 dom-zdravlja-bijelo-polje | 35 (26) / 0 / 43 / 20 |  |
| готово | Dental Mušura | #142 stomatoloska-ordinacija-musura | 44 (0) / 0 / 5 / 69 |  |

## Заметки по кандидатам из таблицы

- **MOA clinic** (очередь 1) — Poliklinika 'Ministry of Aesthetics', WordPress+Brizy. Price lines with EUR counted per page: laser/inovativni (Emsculpt Neo, Emface, Exion, Alma lasers) 77, opšta hirurgija 37, estetska 17 (separate prices for 'lokalni 
- **Ordinacija Obradović Medical** (очередь 1) — ядерная медицина, есть прейскурант — Thyroid / nuclear-medicine ordinacija (kind 'other' — thyroid + ultrasound). PDF is a scan with a poor OCR text layer (pdftotext output garbled); 12 numbered items read: prvi pregled 
- **Klinika Podgorica / Feniks Medika** (очередь 2) — WordPress (тема Medical Circle), 9 страниц, все modified 2023-03. Прайс — DOCX «CJENOVNIK USLUGA PZU POLIKLINIKE “FENIKS MEDIKA”», ~301 строк с ценой: интерна/општа, гинекология (до histeroskopija 250/800 eur, konizacija
- **Cirkon Dental Lab - dental clinic and dental laboratory** (очередь 2) — Next.js, SSR-HTML читается. Ординация + собственная зуботехническая лаборатория, с 10.11.2005. /cjenovnik (есть в sitemap, в меню не видно) — 27 позиций с ценами: dijagnostika 3 (pregled 10 €, ortopan 25 €, intraoralni 1
- **Poliklinika DaVinci** (очередь 2) — WordPress. Страница /cjenovnik/ существует (в меню не ссылается), но это ЗАГЛУШКА шаблона: «Cjenovik oblast 1/2/3», «Operacija 1…4», «Ultrazvuk 35eur», «Specijalistički pregled 45eur», под каждым lorem ipsum — реальным п
- **Mela Sana** (очередь 2) — Статический HTML-шаблон. Услуги: Pregledi opšte prakse, Hirurgija, Pedijatrija, Ultrazvuk (7 видов УЗИ перечислены), Urologija, Psihijatrija, Neurologija, Interna medicina, Onkologija, ORL, Mentalno zdravlje djece, Sanit
- **POLIKLINIKA AK MEDICA** (очередь 2) — WordPress, 46 страниц в wp-json: 12 направлений (kardiologija, gastroenterologija, pulmologija, reumatologija, hematologija, endokrinologija, neurologija, alergologija, urologija, ultrazvučna dijagnostika, psihijatrija, 
- **Privatna ordinacija "Vuleković"** (очередь 2) — много врачей — Частная педиатрическая ординация с 2018. /nasi-ljekari/ — разделы: Opšta pedijatrija, Radiologija, Reumatologija za djecu, ORL, Alergologija, Dijetoterapija, Dermatologija (+ удаление образований Hyfrecato
- **Mićunović Medical** (очередь 2) — много врачей — WordPress (тема doctio). 3 направления: стоматология, гинекология, УЗИ 2D/3D/4D; на страницах услуг только описательный текст с перечислением в прозе (пломбы, эндодонтия, импланты Nobel Biocare/Sweden & Ma
- **Moj Doktor** (очередь 2) — есть неск анализов и врачей — WordPress (TLS needs -k). Only one price on the whole site: 'Kompletna krvna slika - 5.0€'. Lab page lists ~28 analyses without prices; ljekarska-uvjerenja lists 14 certificate types without
- **V Dental Centar** (очередь 2) — много врачей — Wix-сайт, текст читается в сыром HTML. Услуги (разделы): Oralna hirurgija, Implantologija, Kompjuterom vođena implantologija, Protetika, Digital Smile Design, Ortopedija vilica, Estetska stomatologija (вкл
- **Fizio** (очередь 2) — Самописный сайт: команда и терапии подгружаются JS из api.php?action=load (JSON: employees 7, therapies 14, partners 12, gallery 12). Терапии: INDIBA, K Laser, Compex, laser, limfna drenaža, magnetoforeza, Kinetec CPM (а
- **Dentix - Стоматолошка ординација Др.Ђурковић** (очередь 2) — Static template site (index/about/services/contact). No € or prices anywhere; /cjenovnik.html, /prices.html, /sitemap.xml = 404. Services on home: paradontologija, oralna hirurgija, implantologija, snimanje (3D/ortopan/R
- **Stomatološka Poliklinika "Vukotić"** (очередь 2) — 4 врача, Подгорица + Херцег — Основана в 1960. Услуги на главной: estetsko-rekonstruktivna, zubno liječenje (endo), protetika, parodontologija, oralna hirurgija, implantologija, ortopedija vilice, dječija i preventivna +
- **Center for Dental Implantology and Cosmetic Dentistry-Dental Montenegro** (очередь 2) — Страница /me/cijene есть в sitemap, но отдаёт пустой шаблон (только шапка/подвал) — цен нет. «Pregled sa predračunom, konsultacije i savet su besplatni». Услуги: Implantologija, Ortopedija, Terapija laserom, X-RAY ortopa
- **Mercur Nera** (очередь 2) — Joomla, футер «© Mercurnera 2013», сайт старый. Разделы услуг: ambulantno liječenje (УЗИ ~8 видов, Holter, ergometrija, kvantna/TENS терапия, патронаж), interna medicina (перечень субспециальностей), ginekologija, pedija
- **K-med Ambulanta i Pedijatrijska Ambulanta Bar 2** (очередь 2) — WordPress one-page (wp-json pages: home modified 2025-11-26, coming-soon). Seasonal tourist primary-care ambulances, 08–21h. Services: Pregledi (in ambulance or at location), Terapije (injekciona/inhalaciona/infuziona), 
- **Stomatoloska Ordinacija Ortholine** (очередь 2) — стоматология, есть 4 врача и ортоплан — WordPress; ortholine.me и stomatologpodgorica.me — один и тот же сайт (одинаковые страницы, page id 363). В шитe «4 врача» — на o-nama 3 врача + Katarina Žunjić (medicinska sestra)
- **FIZIO TIM CRNA GORA** (очередь 2) — 2 физиотерапевта — WordPress. Услуги (10, у каждой своя страница): Sportska rehabilitacija, Indiba-Tecar terapija, Elektroterapija, Shockwave, Limfna drenaža, Elektromišićna stimulacija, Cupping masaža, Dry needling i ak
- **DENTAL STUDIO PRŽNO** (очередь 2) — ДУБЛЬ записи №2 (dentalstudioglusica.me): сайт подписан «© Dental studio Pržno», адрес Pržno BB, Sveti Stefan, Instagram dental_studio_przno — это та же клиника. Найдено без WebSearch, по совпадению названия/адреса с уже
- **Opšta stomatološka ordinacija Mitranić** (очередь 2) — WordPress. Услуги из меню + wp-json: Preventivna, Dječja, Konzervativna stomatologija, Fiksna, Mobilna protetika, Ortodoncija, Izbjeljivanje, Implanti, Digitalna radiografija, Morpheus8, Estetska medicina (Hijaluronski f
- **Kavarić Medical** (очередь 2) — Простой статический сайт из 2 страниц (index, usluge), © 2016, шаблонный текст «Text o kompaniji» в подвале. Гинекология + урология: 16 пунктов (UZ, CTG, 3D UZ, PAPA/HPV/kolposkopija, spirala, sterilitet, spermogram, IUI
- **IMC Fizio** (очередь 2) — No euro prices anywhere (grep € / EUR on home and tecar page = 0; schema priceRange '$$'). Only promo '50% popusta na prvu sesiju odabrane terapije'. 13 service pages: Tecar, Elektroterapija, Ultrazvučna, Laseroterapija,
- **dr Abramović** (очередь 2) — WordPress, 4 страницы (wp-json modified 2022-03-11), футер «© 2020». Юрлицо — PZU A Medical. Услуги (3 группы, 11 пунктов): Digitalni rentgen (grudni koš, kosti/kičma/glava, sinusi, pasaža jednjaka i gastroduodenuma), 4D
- **ORDINACIJA DR KALUDJEROVIC** (очередь 2) — есть прейскурант, но 1 врач всего — Hosting has AES-cookie JS challenge (__test cookie); solved and read with curl. Static old FrontPage/Word-HTML site (2014 meta), mostly COVID-19 article links (1.php?br=215..231). onam
- **Stomatološka Ordinacija "Polident" Dom zdravlja Bijela** (очередь 2) — Фактически одностраничная заглушка: на главной — «Upoznajte Dr. Sandru Brkić» и 4 направления (Konzervativna, Protetika, Estetska, Dječija stomatologija), остальной контент — демо-текст темы (lorem ipsum, «New York, USA»
- **Dental Implant Center (Dr Keković)** (очередь 2) — 1 врач — Small static site (© 2019). Root page is a city chooser BEOGRAD / PODGORICA. Podgorica page = Dental Implant Centar: no service list, only prose mentioning implantologija, sinus-lift, vođena regeneracija kosti, 
- **Omnidental** (очередь 2) — на сайте нет врачей — Wix-сайт (sitemap: главная + 4 подстраницы, lastmod 2025-10-05). На главной перечень услуг 4 группами: Opšta stomatologija (12: pregled i digitalno snimanje, kamenac, Airflow, svjež dah, desni, osje
- **Dr Baris Erturk Aesthetic / Aesthetic Medicine** (очередь 3) — Сайт не найден. Искал: «Dr Baris Erturk Aesthetic Bečići Budva», «"Baris Erturk" aesthetic Montenegro», «Dr Barış Ertürk estetik Karadağ Budva» — только нерелевантные турецкие врачи на bookimed. curl bariserturk.com / dr
- **Jadranski put 6** (очередь 3) — в Google — место «Jadranski put 6» (Будва) по тому же адресу; опознано по разбору dodoktora.me — Сайт не найден. Это стоматология «Dental Health» (Dental Health Montenegro), Jadranski put XIII br.5, Budva — по данным коо
- **Tivari Dental & Clinic** (очередь 3) — Ульцинь — Сайт не найден. Искал: «Tivari Dental Clinic Ulcinj», «Tivari Dental Ulqin klinika dentare» — ничего по Ульциню. curl tivaridental.com — живой, но это «Klinika Dentare Tivari – Durrës» (Албания), другая клиника
- **Dental Studio Dr Vukovic** (очередь 3) — Сайт не найден. Искал: «Dental Studio Dr Vuković Kotor stari grad», «Vuković dental Kotor dentist old town» — только одноимённая клиника в Белграде (Voždovac). curl dentalstudiovukovic.me / drvukovic.me — не резолвятся.
- **DENTAL CLINIC REIDENT** (очередь 3) — Ульцинь — DNS: dentalclinicreident.com и www — Non-existent domain (NXDOMAIN), http/https не резолвятся. WebSearch «Dental Clinic Reident Ulcinj» нового сайта не нашёл (выдаёт хорватские Rident).
- **POLIKLINIKA KALINIĆ BAR** (очередь 3) — то же, что «Stomatološka i internistička ordinacija Bar» во вкладке «на сайте нет врачей» — POLIKLINIKA KALINIĆ BAR в Google — Сайт не найден. В Google-карточке сайт = registarfirmi.me (агрегатор). Искал: «Poliklinika Ka
- **Dental Clinic DENTITIO** (очередь 3) — Домен редиректит на https://www.dentitio.me/auth/login — страница входа «Cement E-Commerce» (чужой контент); TLS-сертификат не на этот домен (SEC_E_WRONG_PRINCIPAL), читалось с -k. WebSearch («Dentitio Ulcinj») нового са
- **Dental Clinic “Pjerotic”** (очередь 3) — домен свободен — Домен не существует: DNS NXDOMAIN (dns.google Status 3, SOA зоны .me) для pjerotic.me и www.pjerotic.me — домен не зарегистрирован/истёк. pjerotic.com, dentalpjerotic.me, pjeroticdental.com — тоже NXDOMA
- **Poliklinika Medicus Plus** (очередь 3) — на домене теперь чужой сервис (OffrIA API) — https://medicusplus.me/ returns JSON {"service":"OffrIA API",...} (FastAPI swagger at /docs) — unrelated service; http:// and www. give default 'Welcome to nginx!' page. No cl
- **Stomatološka ordinacija Bar - Dental Husović** (очередь 3) — заметок нет
- **Sanja DENT** (очередь 3) — заметок нет
- **PZU Medalja Zdravlja** (очередь 3) — Домен (с www и без, http и https) отдаёт 301 на https://www.instagram.com/Medaljazdravlja/ — собственного сайта нет, только Instagram (не читается). Профиль клиники (kind) по сайту не определить — NOT STATED. WebSearch «
- **Sorriso Stomatoloska** (очередь 3) — заметок нет
- **Stomatoloska ordinacija "ORVIT"** (очередь 3) — заметок нет
- **Bona Mente** (очередь 4) — есть прейскурант, медицина труда только — Сейчас на домене чистый WordPress по умолчанию (title «G», «Hello world!», «Sample Page», пост 2026-08-12). /cjenovnik, /cijene, /usluge — 404. Прейскурант из sheetNotes («есть п

## Исключено

- Animal Hospital Popovic (bar, veterina.me) — ветеринарная клиника
- MedicinaBar (bar, medicinabar.com) — портал НКО об истории медицины в Баре; сайт поликлиники — drmasonicic.com (БД #58)
- General Hospital (bijelo-polje, medicalcg.me) — не клиника: other medicalcg.me is 'Medical CG — Časopis & Crnogorski medicinski portal' (medical magazine/news portal, conferences, Sajam medicine), not the Opš
- Medikal Optik (bijelo-polje, medikaloptik.me) — оптика
- DoctorSi14Pharma (budva, si14pharma.com) — не клиника
- Katharsis (budva, katharsismne.me) — не клиника: aesthetic Одностраничный статический сайт Katharsis Wellness & Health (wellness/body shaping при отеле Slovenska Plaža). Блоки: Diagnosis and dietet
- Психіатрична клініка доктора Cидорчук (cetinje, ldmlsdrchk.com) — украинская клиника, к Черногории отношения нет
- Apoteka TEA MEDICA 21 (herceg-novi) — аптека
- Beauty Salon Relax Studio (herceg-novi) — салон красоты (тип «doctor» в Google ошибочный)
- Bioenergeticar Toplica Topić (herceg-novi, bioenergija.me) — биоэнергетик, не медицина
- Felix-Center for Massage & Cosmetics & Fitness (herceg-novi) — массаж, косметика, фитнес
- OPTIKA KUBURIC - Igalo (herceg-novi, optikakuburic.me) — оптика
- Ivadent Stomatološka Ordinacija (kotor, ivadent.me) — зуботехническая лаборатория, продаёт стоматологам
- Monte Medical (kotor, doctorinmontenegro.com) — агентство медицинского сопровождения (Monte Medical), своего приёма нет
- Audio BM - Slušni aparati (podgorica, audiobm.me) — слуховые аппараты, магазин
- Citiwell – Laserska epilacija (Podgorica, Centar) (podgorica, citiwell.me) — сеть лазерной эпиляции, не медицина
- Dental grupa Montenegro (podgorica, dentalgrupa-mne.com) — оптовый магазин стоматологических материалов
- Emergency Center (podgorica) — скорая помощь (Zavod za hitnu medicinsku pomoć)
- Health Center & Emergency (podgorica, hitna.me) — Завод за хитну медицинску помоћ — скорая помощь, не клиника для каталога
- Informativni centar Acibadem Podgorica/Crna Gora (podgorica, acibadem.rs) — информационный офис турецкой сети, приёма нет
- Iris Company - Salon za njegu i unapređivanje fizičkog stanja Podgorica (podgorica) — салон по уходу за телом
- Moj Dermatolog (podgorica, mojdermatolog.me) — SEO-справочник чужих клиник
- Poliklinika Medikol Podružnica Podgorica (podgorica, medikol.me) — ПЭТ/КТ Medikol физически в Codra Hospital (#28), черногорское юрлицо Medikol — не медучреждение; правильнее завести ПЭТ/КТ услугой Codra (разбор dodoktora.me)
- Predstavništvo LIV Hospital Crna Gora, Podgorica, Montenegro (podgorica, livhospital.me) — представительство турецкой больницы, приёма нет
- Солнечный клуб (podgorica, sclubmontenegro.ru) — не клиника
- Udruženje vodovoda Crne Gore (podgorica, udruzenjevodovoda.me) — ассоциация водоканалов, ошибка категории Google
- Ургентни центар (podgorica) — Ургентни центар КЦЦГ — часть клиники #65
- Massage therapy Tea (tivat) — массажист
- Hmp urgjenca ulqin (ulcinj) — скорая помощь Улцинь (Zavod za hitnu medicinsku pomoć)
- Zdravstvena stanica Žabljak-Emergency (zabljak) — скорая помощь Жабляк (Zavod za hitnu medicinsku pomoć)
- Healing Centar Montenegro (, healingcenter.me) — не клиника: other Сайт сам называет себя альтернативной медициной: korekcija atlasa, «namještanje organa» (visceralna osteopatija), dumo terapija, hidžama, akup
