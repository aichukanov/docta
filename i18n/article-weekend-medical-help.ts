// Контент статьи «Аптеки и клиники в Черногории, открытые в выходные».
// Источники: montefarm.co.me (список дежурных аптек на праздники),
// apoteke.me (справочник аптек с фильтром по круглосуточным),
// собственная база данных docta.me (график работы клиник, clinic_working_hours).
// Актуальность: июль 2026.
export default {
	messages: {
		en: {
			WeekendMedicalHelpTitle:
				'Pharmacies and clinics in Montenegro open on weekends',
			WeekendMedicalHelpDescription:
				'Where to get medical help on a Saturday or Sunday in Montenegro: round-the-clock and on-duty pharmacies, hospitals with 24/7 admission, and private clinics and laboratories that stay open on weekends. Current as of July 2026.',

			WmhToc_overview: 'What is open, and what is not',
			WmhToc_pharmacies: 'Pharmacies: round-the-clock and on-duty',
			WmhToc_hospitals: 'Hospitals: emergency care is always available',
			WmhToc_clinics: 'Private clinics and labs open on weekends',
			WmhToc_sources: 'Sources',

			WmhOverview1:
				'On Saturdays many public dom zdravlja clinics in Montenegro work a shorter day, and on Sunday almost everything is closed except hospitals and some pharmacies. Weekends are not the time for a routine doctor visit — but if you need medication, a test or urgent care, there are real options, and we have collected them by city.',
			WmhOverview2:
				'The short version: for anything that cannot wait until Monday, go straight to the emergency unit of the nearest state hospital or call 124; for a prescription or an everyday medicine, use one of the round-the-clock or on-duty pharmacies below; for a lab test or a specialist appointment, a private clinic is usually your best bet — several of them keep shorter but real weekend hours.',

			WmhPharmacies1:
				'Permanent 24-hour pharmacies are scarce. Podgorica has three: Montefarm “Kruševac” (Bulevar Svetog Petra Cetinjskog 45/a), BENU on Moskovska 22, and Holos 7 on Bulevar Oktobarske Revolucije 31. Budva has one — BENU opposite the bus station (Sportska Hala 11). Nikšić has Montefarm “Gojko Darić” (Radoja Dakića bb). Kotor, Bar, Tivat, Herceg Novi, Bijelo Polje and the rest of the country have no permanent round-the-clock pharmacy. Addresses and round-the-clock status can change — confirm before a late-night trip.',
			WmhPharmacies2:
				'Where there is no permanent 24-hour pharmacy, an on-duty system covers public holidays: Montefarm designates one pharmacy per municipality as the duty pharmacy for the day. The list is different every time and is published on montefarm.co.me shortly before the date, so check it right before the holiday rather than relying on a previous visit.',
			WmhPharmacies3:
				'How prescriptions work, what is sold without one, and which medicines are free under the health card — all covered in our article',
			WmhPharmaciesLink: 'on pharmacies and medications in Montenegro',
			WmhPharmaciesEnd: '.',

			WmhHospitals1a:
				'Admission units at state hospitals accept emergency patients around the clock, seven days a week — Saturday or Sunday makes no difference. This applies to the ',
			WmhHospitals1KccgLink: 'Clinical Center of Montenegro (KCCG)',
			WmhHospitals1b: ' in Podgorica, the ',
			WmhHospitals1KotorLink: 'general hospital in Kotor',
			WmhHospitals1c: ', the ',
			WmhHospitals1BarLink: '“Blažo Orlandić” general hospital in Bar',
			WmhHospitals1d: ', the ',
			WmhHospitals1BijeloPoljeLink: 'general hospital in Bijelo Polje',
			WmhHospitals1e: ', ',
			WmhHospitals1MeljineLink: 'Meljine hospital',
			WmhHospitals1f: ' in Herceg Novi, and ',
			WmhHospitals1DaniloLink: 'Danilo I hospital',
			WmhHospitals1g: ' in Cetinje.',
			WmhHospitals2:
				'The country’s one private hospital,',
			WmhHospitalsLink: 'Codra Hospital',
			WmhHospitalsMid: 'in Podgorica, also runs 24/7, weekends included. Routine appointments under the health card at public clinics normally do not run on weekends — only urgent cases through an admission unit or ambulance (124).',
			WmhHospitalsEnd: '',

			WmhClinicsIntro:
				'Below are the private clinics and labs that see patients on weekends in Montenegro, by city:',
			WmhClinicsPodgoricaLabel: 'Podgorica:',
			WmhClinicsHipokratLink: 'Hipokrat Poliklinika',
			WmhClinicsPodgoricaA: ' — Saturday and Sunday, 7:30 a.m.–10 p.m.; ',
			WmhClinicsMilmedikaPgLink: 'Milmedika Podgorica',
			WmhClinicsPodgoricaB: ' — Saturday and Sunday, 8 a.m.–8 p.m.; ',
			WmhClinicsMojLabPgLink: 'Moj Lab',
			WmhClinicsPodgoricaC: ' and its ',
			WmhClinicsMojLabPedLink: 'pediatric branch',
			WmhClinicsPodgoricaD: ' — Saturday until 8 p.m., Sunday until 1 p.m.; ',
			WmhClinicsMedikidLink: 'Medikid',
			WmhClinicsPodgoricaE:
				' (pediatrics) — Saturday until 8 p.m., Sunday until noon.',
			WmhClinicsBudvaLabel: 'Budva:',
			WmhClinicsMilmedikaBdLink: 'Milmedika Budva',
			WmhClinicsBudvaA: ' (8 a.m.–8 p.m. both days) and ',
			WmhClinicsMojLabBdLink: 'Moj Lab Budva',
			WmhClinicsBudvaB: ' (8 a.m.–9 p.m. both days).',
			WmhClinicsBarLabel: 'Bar:',
			WmhClinicsMasonicicLink: 'the Dr Masoničić polyclinic',
			WmhClinicsBarA: ' (8 a.m.–8 p.m.) and ',
			WmhClinicsA3Link: 'A3 Medical',
			WmhClinicsBarB: ' in Sutomore (8 a.m.–9 p.m.).',
			WmhClinicsTivatLabel: 'Tivat:',
			WmhClinicsMansaLink: 'Mansa Medica',
			WmhClinicsTivatA: ' (also sees children) and ',
			WmhClinicsDentalExpertLink: 'Dental Expert',
			WmhClinicsTivatB: ' (a dental clinic).',
			WmhClinicsNiksicLabel: 'Nikšić:',
			WmhClinicsMilmedikaNkLink: 'Milmedika Nikšić',
			WmhClinicsNiksicA: ' (8 a.m.–8 p.m.).',
			WmhClinicsCatalog:
				'Hours change, so check the current schedule of a specific clinic on its page in our',
			WmhClinicsLink: 'clinic catalog',
			WmhClinicsEnd: '.',

			WmhSources0:
				'The information is current as of July 2026. Pharmacy and clinic hours can change — verify before you go:',
			WmhSourcesMontefarm:
				'Montefarm — on-duty pharmacies for public holidays, by municipality: montefarm.co.me;',
			WmhSourcesCatalog:
				'Our clinic catalog lists working hours for every listed clinic.',

			WmhCtaTitle: 'Need a clinic that is open right now?',
			WmhCtaText:
				'Our clinic catalog shows the working hours of every clinic — find one open near you.',
			WmhCtaButton: 'Open the clinic catalog',
		},
		ru: {
			WeekendMedicalHelpTitle:
				'Аптеки и клиники в Черногории, открытые в выходные',
			WeekendMedicalHelpDescription:
				'Где получить медицинскую помощь в субботу и воскресенье в Черногории: круглосуточные и дежурные аптеки, больницы с круглосуточным приёмом, частные клиники и лаборатории, работающие по выходным. Актуально на июль 2026 года.',

			WmhToc_overview: 'Что открыто, а что нет',
			WmhToc_pharmacies: 'Аптеки: круглосуточные и дежурные',
			WmhToc_hospitals: 'Больницы: неотложная помощь есть всегда',
			WmhToc_clinics: 'Частные клиники и лаборатории по выходным',
			WmhToc_sources: 'Источники',

			WmhOverview1:
				'По субботам многие государственные поликлиники (dom zdravlja) в Черногории работают укороченный день, а в воскресенье закрыто почти всё, кроме больниц и части аптек. Для планового визита к врачу выходные не подходят — но если нужно лекарство, анализ или неотложная помощь, варианты есть, и мы собрали их по городам.',
			WmhOverview2:
				'Короткое правило: с симптомами, которые не терпят до понедельника, — сразу в приёмное отделение ближайшей государственной больницы или на 124; с рецептом или обычным лекарством — в одну из круглосуточных или дежурных аптек ниже; с анализом или приёмом узкого специалиста обычно лучше всего подходит частная клиника — у части из них по выходным сокращённый, но рабочий график.',

			WmhPharmacies1:
				'Постоянных круглосуточных аптек в стране немного. В Подгорице их три: Montefarm «Kruševac» (бульвар Св. Петра Цетинского, 45/а), BENU на Московской, 22, и Holos 7 на бульваре Октябрьской революции, 31. В Будве — одна, BENU напротив автовокзала (Sportska Hala, 11). В Никшиче — Montefarm «Gojko Darić» (Radoja Dakića bb). В Которе, Баре, Тивате, Херцег-Нови, Биело-Поле и остальной части страны постоянной круглосуточной точки нет. Адреса и круглосуточный режим могут измениться — уточняйте перед поздней поездкой.',
			WmhPharmacies2:
				'Там, где своей круглосуточной аптеки нет, на государственные праздники действует система дежурств: Montefarm назначает одну аптеку в каждом муниципалитете дежурной на день. Список каждый раз новый и публикуется на montefarm.co.me незадолго до даты, поэтому смотреть его нужно прямо перед праздником, а не полагаться на прошлый визит.',
			WmhPharmacies3:
				'Как работает рецепт, что продаётся без него и какие лекарства положены бесплатно по книжице — подробно разбираем в статье',
			WmhPharmaciesLink: 'об аптеках и лекарствах в Черногории',
			WmhPharmaciesEnd: '.',

			WmhHospitals1a:
				'Приёмные отделения государственных больниц принимают неотложных пациентов круглосуточно и без выходных — суббота или воскресенье на это не влияют. Это касается ',
			WmhHospitals1KccgLink: 'Клинического центра Черногории (KCCG)',
			WmhHospitals1b: ' в Подгорице, ',
			WmhHospitals1KotorLink: 'общей больницы в Которе',
			WmhHospitals1c: ', ',
			WmhHospitals1BarLink: 'общей больницы «Блажо Орландич» в Баре',
			WmhHospitals1d: ', ',
			WmhHospitals1BijeloPoljeLink: 'общей больницы в Биело-Поле',
			WmhHospitals1e: ', ',
			WmhHospitals1MeljineLink: 'больницы Мельине',
			WmhHospitals1f: ' в Херцег-Нови и ',
			WmhHospitals1DaniloLink: 'больницы «Данило I»',
			WmhHospitals1g: ' в Цетинье.',
			WmhHospitals2: 'Единственная частная больница страны —',
			WmhHospitalsLink: 'Codra Hospital',
			WmhHospitalsMid:
				'в Подгорице — тоже работает круглосуточно, включая выходные. Плановый приём по здравственной книжице в государственных поликлиниках по субботам и воскресеньям, как правило, не работает — только неотложные случаи через приёмное отделение или скорую (124).',
			WmhHospitalsEnd: '',

			WmhClinicsIntro:
				'Ниже — частные клиники и лаборатории, которые по выходным принимают пациентов в Черногории, по городам:',
			WmhClinicsPodgoricaLabel: 'Подгорица:',
			WmhClinicsHipokratLink: 'Hipokrat Poliklinika',
			WmhClinicsPodgoricaA: ' — суббота и воскресенье, 7:30–22:00; ',
			WmhClinicsMilmedikaPgLink: 'Milmedika Podgorica',
			WmhClinicsPodgoricaB: ' — суббота и воскресенье, 8:00–20:00; ',
			WmhClinicsMojLabPgLink: 'Moj Lab',
			WmhClinicsPodgoricaC: ' и его ',
			WmhClinicsMojLabPedLink: 'педиатрическое отделение',
			WmhClinicsPodgoricaD: ' — суббота до 20:00, воскресенье до 13:00; ',
			WmhClinicsMedikidLink: 'Medikid',
			WmhClinicsPodgoricaE:
				' (педиатрия) — суббота до 20:00, воскресенье до 12:00.',
			WmhClinicsBudvaLabel: 'Будва:',
			WmhClinicsMilmedikaBdLink: 'Milmedika Budva',
			WmhClinicsBudvaA: ' (8:00–20:00 оба дня) и ',
			WmhClinicsMojLabBdLink: 'Moj Lab Budva',
			WmhClinicsBudvaB: ' (8:00–21:00 оба дня).',
			WmhClinicsBarLabel: 'Бар:',
			WmhClinicsMasonicicLink: 'поликлиника Dr Masoničić',
			WmhClinicsBarA: ' (8:00–20:00) и ',
			WmhClinicsA3Link: 'A3 Medical',
			WmhClinicsBarB: ' в Сутоморе (8:00–21:00).',
			WmhClinicsTivatLabel: 'Тиват:',
			WmhClinicsMansaLink: 'Mansa Medica',
			WmhClinicsTivatA: ' (принимает и детей) и ',
			WmhClinicsDentalExpertLink: 'Dental Expert',
			WmhClinicsTivatB: ' (стоматология).',
			WmhClinicsNiksicLabel: 'Никшич:',
			WmhClinicsMilmedikaNkLink: 'Milmedika Nikšić',
			WmhClinicsNiksicA: ' (8:00–20:00).',
			WmhClinicsCatalog:
				'Часы могут меняться — актуальный график конкретной клиники смотрите на её странице в',
			WmhClinicsLink: 'каталоге клиник',
			WmhClinicsEnd: '.',

			WmhSources0:
				'Информация актуальна на июль 2026 года. Часы работы аптек и клиник могут меняться — уточняйте перед визитом:',
			WmhSourcesMontefarm:
				'Montefarm — дежурные аптеки на праздники по каждому муниципалитету: montefarm.co.me;',
			WmhSourcesCatalog:
				'В нашем каталоге клиник указан график работы каждой из них.',

			WmhCtaTitle: 'Нужна клиника, открытая прямо сейчас?',
			WmhCtaText:
				'В каталоге docta.me указаны часы работы каждой клиники — найдите открытую поблизости.',
			WmhCtaButton: 'Открыть каталог клиник',
		},
		sr: {
			WeekendMedicalHelpTitle:
				'Apoteke i klinike u Crnoj Gori otvorene vikendom',
			WeekendMedicalHelpDescription:
				'Gdje potražiti medicinsku pomoć subotom ili nedjeljom u Crnoj Gori: non-stop i dežurne apoteke, bolnice sa non-stop prijemom, privatne klinike i laboratorije koje rade vikendom. Važi za jul 2026.',

			WmhToc_overview: 'Šta je otvoreno, a šta nije',
			WmhToc_pharmacies: 'Apoteke: non-stop i dežurne',
			WmhToc_hospitals: 'Bolnice: hitna pomoć je uvijek dostupna',
			WmhToc_clinics: 'Privatne klinike i laboratorije vikendom',
			WmhToc_sources: 'Izvori',

			WmhOverview1:
				'Subotom mnogi domovi zdravlja u Crnoj Gori rade skraćeno, a nedjeljom je zatvoreno gotovo sve osim bolnica i dijela apoteka. Vikend nije vrijeme za redovnu posjetu ljekaru — ali ako vam treba lijek, analiza ili hitna pomoć, opcije postoje, i sakupili smo ih po gradovima.',
			WmhOverview2:
				'Kratko pravilo: sa simptomima koji ne mogu čekati do ponedjeljka — pravo u prijemno odjeljenje najbliže državne bolnice ili na 124; sa receptom ili uobičajenim lijekom — u jednu od non-stop ili dežurnih apoteka ispod; za analizu ili pregled užeg specijaliste obično je najbolje rješenje privatna klinika — dio njih vikendom radi skraćeno, ali stvarno radi.',

			WmhPharmacies1:
				'Stalnih non-stop apoteka u zemlji ima malo. Podgorica ih ima tri: Montefarm „Kruševac“ (Bulevar Svetog Petra Cetinjskog 45/a), BENU na Moskovskoj 22 i Holos 7 na Bulevaru oktobarske revolucije 31. Budva ima jednu — BENU preko puta autobuske stanice (Sportska Hala 11). Nikšić ima Montefarm „Gojko Darić“ (Radoja Dakića bb). Kotor, Bar, Tivat, Herceg Novi, Bijelo Polje i ostatak zemlje nemaju stalnu non-stop apoteku. Adrese i non-stop režim rada mogu se promijeniti — provjerite prije noćne posjete.',
			WmhPharmacies2:
				'Tamo gdje nema stalne non-stop apoteke, za praznike važi sistem dežurstava: Montefarm određuje po jednu apoteku u svakoj opštini kao dežurnu za taj dan. Spisak je svaki put drugačiji i objavljuje se na montefarm.co.me neposredno prije datuma, pa ga provjerite tik pred praznik, a ne po ranijoj posjeti.',
			WmhPharmacies3:
				'Kako funkcioniše recept, šta se prodaje bez njega i koji ljekovi su besplatni uz zdravstvenu knjižicu — detaljno u našem članku',
			WmhPharmaciesLink: 'o apotekama i ljekovima u Crnoj Gori',
			WmhPharmaciesEnd: '.',

			WmhHospitals1a:
				'Prijemna odjeljenja državnih bolnica primaju hitne pacijente non-stop, svih sedam dana u nedjelji — subota ili nedjelja ne mijenjaju ništa. Ovo važi za ',
			WmhHospitals1KccgLink: 'Klinički centar Crne Gore (KCCG)',
			WmhHospitals1b: ' u Podgorici, ',
			WmhHospitals1KotorLink: 'opštu bolnicu u Kotoru',
			WmhHospitals1c: ', ',
			WmhHospitals1BarLink: 'opštu bolnicu „Blažo Orlandić“ u Baru',
			WmhHospitals1d: ', ',
			WmhHospitals1BijeloPoljeLink: 'opštu bolnicu u Bijelom Polju',
			WmhHospitals1e: ', ',
			WmhHospitals1MeljineLink: 'bolnicu Meljine',
			WmhHospitals1f: ' u Herceg Novom i ',
			WmhHospitals1DaniloLink: 'bolnicu Danilo I',
			WmhHospitals1g: ' u Cetinju.',
			WmhHospitals2: 'Jedina privatna bolnica u zemlji,',
			WmhHospitalsLink: 'Codra Hospital',
			WmhHospitalsMid:
				'u Podgorici, takođe radi non-stop, uključujući vikend. Redovni pregledi po zdravstvenoj knjižici u domovima zdravlja subotom i nedjeljom po pravilu ne rade — samo hitni slučajevi preko prijemnog odjeljenja ili hitne pomoći (124).',
			WmhHospitalsEnd: '',

			WmhClinicsIntro:
				'Ispod su privatne klinike i laboratorije koje vikendom primaju pacijente u Crnoj Gori, po gradovima:',
			WmhClinicsPodgoricaLabel: 'Podgorica:',
			WmhClinicsHipokratLink: 'Hipokrat Poliklinika',
			WmhClinicsPodgoricaA: ' — subota i nedjelja, 7:30–22:00; ',
			WmhClinicsMilmedikaPgLink: 'Milmedika Podgorica',
			WmhClinicsPodgoricaB: ' — subota i nedjelja, 8:00–20:00; ',
			WmhClinicsMojLabPgLink: 'Moj Lab',
			WmhClinicsPodgoricaC: ' i njegovo ',
			WmhClinicsMojLabPedLink: 'pedijatrijsko odjeljenje',
			WmhClinicsPodgoricaD: ' — subota do 20:00, nedjelja do 13:00; ',
			WmhClinicsMedikidLink: 'Medikid',
			WmhClinicsPodgoricaE:
				' (pedijatrija) — subota do 20:00, nedjelja do 12:00.',
			WmhClinicsBudvaLabel: 'Budva:',
			WmhClinicsMilmedikaBdLink: 'Milmedika Budva',
			WmhClinicsBudvaA: ' (8:00–20:00 oba dana) i ',
			WmhClinicsMojLabBdLink: 'Moj Lab Budva',
			WmhClinicsBudvaB: ' (8:00–21:00 oba dana).',
			WmhClinicsBarLabel: 'Bar:',
			WmhClinicsMasonicicLink: 'poliklinika Dr Masoničić',
			WmhClinicsBarA: ' (8:00–20:00) i ',
			WmhClinicsA3Link: 'A3 Medical',
			WmhClinicsBarB: ' u Sutomoru (8:00–21:00).',
			WmhClinicsTivatLabel: 'Tivat:',
			WmhClinicsMansaLink: 'Mansa Medica',
			WmhClinicsTivatA: ' (prima i djecu) i ',
			WmhClinicsDentalExpertLink: 'Dental Expert',
			WmhClinicsTivatB: ' (stomatološka klinika).',
			WmhClinicsNiksicLabel: 'Nikšić:',
			WmhClinicsMilmedikaNkLink: 'Milmedika Nikšić',
			WmhClinicsNiksicA: ' (8:00–20:00).',
			WmhClinicsCatalog:
				'Radno vrijeme se mijenja — aktuelan raspored konkretne klinike provjerite na njenoj stranici u',
			WmhClinicsLink: 'katalogu klinika',
			WmhClinicsEnd: '.',

			WmhSources0:
				'Informacije važe za jul 2026. Radno vrijeme apoteka i klinika se mijenja — provjerite prije posjete:',
			WmhSourcesMontefarm:
				'Montefarm — dežurne apoteke za praznike po opštinama: montefarm.co.me;',
			WmhSourcesCatalog:
				'U našem katalogu klinika naznačeno je radno vrijeme svake od njih.',

			WmhCtaTitle: 'Treba vam klinika koja je otvorena upravo sada?',
			WmhCtaText:
				'U katalogu docta.me naznačeno je radno vrijeme svake klinike — pronađite otvorenu u blizini.',
			WmhCtaButton: 'Otvorite katalog klinika',
		},
		'sr-cyrl': {
			WeekendMedicalHelpTitle:
				'Апотеке и клинике у Црној Гори отворене викендом',
			WeekendMedicalHelpDescription:
				'Гдје потражити медицинску помоћ суботом или недјељом у Црној Гори: нон-стоп и дежурне апотеке, болнице са нон-стоп пријемом, приватне клинике и лабораторије које раде викендом. Важи за јул 2026.',

			WmhToc_overview: 'Шта је отворено, а шта није',
			WmhToc_pharmacies: 'Апотеке: нон-стоп и дежурне',
			WmhToc_hospitals: 'Болнице: хитна помоћ је увијек доступна',
			WmhToc_clinics: 'Приватне клинике и лабораторије викендом',
			WmhToc_sources: 'Извори',

			WmhOverview1:
				'Суботом многи домови здравља у Црној Гори раде скраћено, а недјељом је затворено готово све осим болница и дијела апотека. Викенд није вријеме за редовну посјету љекару — али ако вам треба лијек, анализа или хитна помоћ, опције постоје, и сакупили смо их по градовима.',
			WmhOverview2:
				'Кратко правило: са симптомима који не могу чекати до понедјељка — право у пријемно одјељење најближе државне болнице или на 124; са рецептом или уобичајеним лијеком — у једну од нон-стоп или дежурних апотека испод; за анализу или преглед ужег специјалисте обично је најбоље рјешење приватна клиника — дио њих викендом ради скраћено, али стварно ради.',

			WmhPharmacies1:
				'Сталних нон-стоп апотека у земљи има мало. Подгорица их има три: Montefarm „Крушевац“ (Булевар Светог Петра Цетињског 45/а), BENU на Московској 22 и Holos 7 на Булевару октобарске револуције 31. Будва има једну — BENU преко пута аутобуске станице (Sportska Hala 11). Никшић има Montefarm „Gojko Darić“ (Radoja Dakića bb). Котор, Бар, Тиват, Херцег Нови, Бијело Поље и остатак земље немају сталну нон-стоп апотеку. Адресе и нон-стоп режим рада могу се промијенити — провјерите прије ноћне посјете.',
			WmhPharmacies2:
				'Тамо гдје нема сталне нон-стоп апотеке, за празнике важи систем дежурстава: Montefarm одређује по једну апотеку у свакој општини као дежурну за тај дан. Списак је сваки пут другачији и објављује се на montefarm.co.me непосредно прије датума, па га провјерите тик пред празник, а не по ранијој посјети.',
			WmhPharmacies3:
				'Како функционише рецепт, шта се продаје без њега и који љекови су бесплатни уз здравствену књижицу — детаљно у нашем чланку',
			WmhPharmaciesLink: 'о апотекама и љековима у Црној Гори',
			WmhPharmaciesEnd: '.',

			WmhHospitals1a:
				'Пријемна одјељења државних болница примају хитне пацијенте нон-стоп, свих седам дана у недјељи — субота или недјеља не мијењају ништа. Ово важи за ',
			WmhHospitals1KccgLink: 'Клинички центар Црне Горе (КЦЦГ)',
			WmhHospitals1b: ' у Подгорици, ',
			WmhHospitals1KotorLink: 'општу болницу у Котору',
			WmhHospitals1c: ', ',
			WmhHospitals1BarLink: 'општу болницу „Блажо Орландић“ у Бару',
			WmhHospitals1d: ', ',
			WmhHospitals1BijeloPoljeLink: 'општу болницу у Бијелом Пољу',
			WmhHospitals1e: ', ',
			WmhHospitals1MeljineLink: 'болницу Мељине',
			WmhHospitals1f: ' у Херцег Новом и ',
			WmhHospitals1DaniloLink: 'болницу Данило I',
			WmhHospitals1g: ' у Цетињу.',
			WmhHospitals2: 'Једина приватна болница у земљи,',
			WmhHospitalsLink: 'Codra Hospital',
			WmhHospitalsMid:
				'у Подгорици, такође ради нон-стоп, укључујући викенд. Редовни прегледи по здравственој књижици у домовима здравља суботом и недјељом по правилу не раде — само хитни случајеви преко пријемног одјељења или хитне помоћи (124).',
			WmhHospitalsEnd: '',

			WmhClinicsIntro:
				'Испод су приватне клинике и лабораторије које викендом примају пацијенте у Црној Гори, по градовима:',
			WmhClinicsPodgoricaLabel: 'Подгорица:',
			WmhClinicsHipokratLink: 'Hipokrat Poliklinika',
			WmhClinicsPodgoricaA: ' — субота и недјеља, 7:30–22:00; ',
			WmhClinicsMilmedikaPgLink: 'Milmedika Podgorica',
			WmhClinicsPodgoricaB: ' — субота и недјеља, 8:00–20:00; ',
			WmhClinicsMojLabPgLink: 'Moj Lab',
			WmhClinicsPodgoricaC: ' и његово ',
			WmhClinicsMojLabPedLink: 'педијатријско одјељење',
			WmhClinicsPodgoricaD: ' — субота до 20:00, недјеља до 13:00; ',
			WmhClinicsMedikidLink: 'Medikid',
			WmhClinicsPodgoricaE:
				' (педијатрија) — субота до 20:00, недјеља до 12:00.',
			WmhClinicsBudvaLabel: 'Будва:',
			WmhClinicsMilmedikaBdLink: 'Milmedika Budva',
			WmhClinicsBudvaA: ' (8:00–20:00 оба дана) и ',
			WmhClinicsMojLabBdLink: 'Moj Lab Budva',
			WmhClinicsBudvaB: ' (8:00–21:00 оба дана).',
			WmhClinicsBarLabel: 'Бар:',
			WmhClinicsMasonicicLink: 'поликлиника Dr Masoničić',
			WmhClinicsBarA: ' (8:00–20:00) и ',
			WmhClinicsA3Link: 'A3 Medical',
			WmhClinicsBarB: ' у Сутомору (8:00–21:00).',
			WmhClinicsTivatLabel: 'Тиват:',
			WmhClinicsMansaLink: 'Mansa Medica',
			WmhClinicsTivatA: ' (прима и дјецу) и ',
			WmhClinicsDentalExpertLink: 'Dental Expert',
			WmhClinicsTivatB: ' (стоматолошка клиника).',
			WmhClinicsNiksicLabel: 'Никшић:',
			WmhClinicsMilmedikaNkLink: 'Milmedika Nikšić',
			WmhClinicsNiksicA: ' (8:00–20:00).',
			WmhClinicsCatalog:
				'Радно вријеме се мијења — актуелан распоред конкретне клинике провјерите на њеној страници у',
			WmhClinicsLink: 'каталогу клиника',
			WmhClinicsEnd: '.',

			WmhSources0:
				'Информације важе за јул 2026. Радно вријеме апотека и клиника се мијења — провјерите прије посјете:',
			WmhSourcesMontefarm:
				'Montefarm — дежурне апотеке за празнике по општинама: montefarm.co.me;',
			WmhSourcesCatalog:
				'У нашем каталогу клиника назначено је радно вријеме сваке од њих.',

			WmhCtaTitle: 'Треба вам клиника која је отворена управо сада?',
			WmhCtaText:
				'У каталогу docta.me назначено је радно вријеме сваке клинике — пронађите отворену у близини.',
			WmhCtaButton: 'Отворите каталог клиника',
		},
		de: {
			WeekendMedicalHelpTitle:
				'Apotheken und Kliniken in Montenegro, die am Wochenende geöffnet haben',
			WeekendMedicalHelpDescription:
				'Wo Sie in Montenegro samstags oder sonntags medizinische Hilfe finden: durchgehend geöffnete und Notdienst-Apotheken, Krankenhäuser mit 24-Stunden-Aufnahme sowie private Kliniken und Labore, die am Wochenende geöffnet sind. Stand: Juli 2026.',

			WmhToc_overview: 'Was geöffnet ist — und was nicht',
			WmhToc_pharmacies: 'Apotheken: durchgehend und im Notdienst',
			WmhToc_hospitals: 'Krankenhäuser: Notfallversorgung gibt es immer',
			WmhToc_clinics: 'Private Kliniken und Labore am Wochenende',
			WmhToc_sources: 'Quellen',

			WmhOverview1:
				'Samstags arbeiten viele staatliche dom-zdravlja-Zentren in Montenegro verkürzt, sonntags ist fast alles geschlossen außer Krankenhäusern und einigen Apotheken. Das Wochenende eignet sich nicht für einen normalen Arztbesuch — aber wenn Sie ein Medikament, eine Untersuchung oder dringende Hilfe brauchen, gibt es echte Optionen, die wir hier nach Städten zusammengestellt haben.',
			WmhOverview2:
				'Die Kurzregel: Bei Symptomen, die nicht bis Montag warten können, direkt in die Notaufnahme des nächsten staatlichen Krankenhauses oder 124 anrufen; für ein Rezept oder ein alltägliches Medikament eine der unten genannten durchgehend geöffneten oder Notdienst-Apotheken nutzen; für eine Laboruntersuchung oder einen Facharzttermin ist meist eine Privatklinik die beste Wahl — einige haben am Wochenende verkürzte, aber reguläre Öffnungszeiten.',

			WmhPharmacies1:
				'Dauerhaft rund um die Uhr geöffnete Apotheken sind selten. Podgorica hat drei: Montefarm „Kruševac“ (Bulevar Svetog Petra Cetinjskog 45/a), BENU in der Moskovska 22 und Holos 7 im Bulevar Oktobarske Revolucije 31. Budva hat eine — die BENU gegenüber dem Busbahnhof (Sportska Hala 11). Nikšić hat die Montefarm „Gojko Darić“ (Radoja Dakića bb). Kotor, Bar, Tivat, Herceg Novi, Bijelo Polje und der Rest des Landes haben keine dauerhafte 24-Stunden-Apotheke. Adressen und der 24-Stunden-Betrieb können sich ändern — vor einem späten Besuch bitte bestätigen.',
			WmhPharmacies2:
				'Wo es keine dauerhafte 24-Stunden-Apotheke gibt, greift an Feiertagen ein Notdienstsystem: Montefarm bestimmt pro Gemeinde eine Apotheke als Notdienst für den Tag. Die Liste ist jedes Mal anders und wird kurz vor dem Termin auf montefarm.co.me veröffentlicht — prüfen Sie sie also unmittelbar vor dem Feiertag, statt sich auf einen früheren Besuch zu verlassen.',
			WmhPharmacies3:
				'Wie Rezepte funktionieren, was rezeptfrei erhältlich ist und welche Medikamente mit der Gesundheitskarte kostenlos sind, behandeln wir ausführlich in unserem Artikel',
			WmhPharmaciesLink: 'über Apotheken und Medikamente in Montenegro',
			WmhPharmaciesEnd: '.',

			WmhHospitals1a:
				'Die Notaufnahmen staatlicher Krankenhäuser nehmen Notfallpatienten rund um die Uhr an, sieben Tage die Woche — Samstag oder Sonntag ändern daran nichts. Das gilt für das ',
			WmhHospitals1KccgLink: 'Klinische Zentrum Montenegros (KCCG)',
			WmhHospitals1b: ' in Podgorica, das ',
			WmhHospitals1KotorLink: 'Allgemeine Krankenhaus in Kotor',
			WmhHospitals1c: ', das ',
			WmhHospitals1BarLink:
				'Allgemeine Krankenhaus „Blažo Orlandić“ in Bar',
			WmhHospitals1d: ', das ',
			WmhHospitals1BijeloPoljeLink:
				'Allgemeine Krankenhaus in Bijelo Polje',
			WmhHospitals1e: ', das ',
			WmhHospitals1MeljineLink: 'Krankenhaus Meljine',
			WmhHospitals1f: ' in Herceg Novi und das ',
			WmhHospitals1DaniloLink: 'Krankenhaus Danilo I',
			WmhHospitals1g: ' in Cetinje.',
			WmhHospitals2: 'Das einzige Privatkrankenhaus des Landes,',
			WmhHospitalsLink: 'Codra Hospital',
			WmhHospitalsMid:
				'in Podgorica, arbeitet ebenfalls rund um die Uhr, auch am Wochenende. Reguläre Termine mit der Gesundheitskarte finden in staatlichen Zentren samstags und sonntags in der Regel nicht statt — nur Notfälle über die Notaufnahme oder den Rettungsdienst (124).',
			WmhHospitalsEnd: '',

			WmhClinicsIntro:
				'Im Folgenden die privaten Kliniken und Labore, die in Montenegro am Wochenende Patienten empfangen, nach Städten:',
			WmhClinicsPodgoricaLabel: 'Podgorica:',
			WmhClinicsHipokratLink: 'Hipokrat Poliklinika',
			WmhClinicsPodgoricaA: ' — Samstag und Sonntag, 7:30–22 Uhr; ',
			WmhClinicsMilmedikaPgLink: 'Milmedika Podgorica',
			WmhClinicsPodgoricaB: ' — Samstag und Sonntag, 8–20 Uhr; ',
			WmhClinicsMojLabPgLink: 'Moj Lab',
			WmhClinicsPodgoricaC: ' und seine ',
			WmhClinicsMojLabPedLink: 'Kinderabteilung',
			WmhClinicsPodgoricaD: ' — Samstag bis 20 Uhr, Sonntag bis 13 Uhr; ',
			WmhClinicsMedikidLink: 'Medikid',
			WmhClinicsPodgoricaE:
				' (Kinderklinik) — Samstag bis 20 Uhr, Sonntag bis 12 Uhr.',
			WmhClinicsBudvaLabel: 'Budva:',
			WmhClinicsMilmedikaBdLink: 'Milmedika Budva',
			WmhClinicsBudvaA: ' (8–20 Uhr an beiden Tagen) und ',
			WmhClinicsMojLabBdLink: 'Moj Lab Budva',
			WmhClinicsBudvaB: ' (8–21 Uhr an beiden Tagen).',
			WmhClinicsBarLabel: 'Bar:',
			WmhClinicsMasonicicLink: 'die Poliklinik Dr Masoničić',
			WmhClinicsBarA: ' (8–20 Uhr) und ',
			WmhClinicsA3Link: 'A3 Medical',
			WmhClinicsBarB: ' in Sutomore (8–21 Uhr).',
			WmhClinicsTivatLabel: 'Tivat:',
			WmhClinicsMansaLink: 'Mansa Medica',
			WmhClinicsTivatA: ' (behandelt auch Kinder) und ',
			WmhClinicsDentalExpertLink: 'Dental Expert',
			WmhClinicsTivatB: ' (eine Zahnklinik).',
			WmhClinicsNiksicLabel: 'Nikšić:',
			WmhClinicsMilmedikaNkLink: 'Milmedika Nikšić',
			WmhClinicsNiksicA: ' (8–20 Uhr).',
			WmhClinicsCatalog:
				'Die Zeiten ändern sich — den aktuellen Zeitplan einer bestimmten Klinik finden Sie auf ihrer Seite in unserem',
			WmhClinicsLink: 'Klinik-Katalog',
			WmhClinicsEnd: '.',

			WmhSources0:
				'Die Informationen sind auf dem Stand von Juli 2026. Öffnungszeiten von Apotheken und Kliniken ändern sich — prüfen Sie diese vor dem Besuch:',
			WmhSourcesMontefarm:
				'Montefarm — Notdienst-Apotheken für Feiertage, nach Gemeinde: montefarm.co.me;',
			WmhSourcesCatalog:
				'Unser Klinik-Katalog zeigt die Öffnungszeiten jeder gelisteten Klinik.',

			WmhCtaTitle: 'Brauchen Sie eine Klinik, die gerade jetzt geöffnet hat?',
			WmhCtaText:
				'Unser Klinik-Katalog zeigt die Öffnungszeiten jeder Klinik — finden Sie eine geöffnete in Ihrer Nähe.',
			WmhCtaButton: 'Klinik-Katalog öffnen',
		},
		tr: {
			WeekendMedicalHelpTitle:
				"Karadağ'da hafta sonu açık eczaneler ve klinikler",
			WeekendMedicalHelpDescription:
				"Karadağ'da cumartesi veya pazar günü nereden tıbbi yardım alınır: 24 saat açık ve nöbetçi eczaneler, 7/24 kabul yapan hastaneler, hafta sonu açık özel klinikler ve laboratuvarlar. Temmuz 2026 itibarıyla günceldir.",

			WmhToc_overview: 'Ne açık, ne kapalı',
			WmhToc_pharmacies: 'Eczaneler: 24 saat açık ve nöbetçi',
			WmhToc_hospitals: 'Hastaneler: acil bakım her zaman mevcuttur',
			WmhToc_clinics: 'Hafta sonu açık özel klinikler ve laboratuvarlar',
			WmhToc_sources: 'Kaynaklar',

			WmhOverview1:
				"Karadağ'da cumartesileri birçok devlet dom zdravlja merkezi kısaltılmış saatlerle çalışır, pazar günleri ise hastaneler ve bazı eczaneler dışında hemen her şey kapalıdır. Hafta sonu rutin bir doktor ziyareti için uygun değildir — ama ilaca, tahlile veya acil yardıma ihtiyacınız varsa gerçek seçenekler var; bunları şehir şehir topladık.",
			WmhOverview2:
				"Kısa kural şu: Pazartesiyi bekleyemeyecek belirtiler varsa doğrudan en yakın devlet hastanesinin acil servisine gidin ya da 124'ü arayın. Reçete veya günlük bir ilaç gerekiyorsa aşağıdaki 24 saat açık ya da nöbetçi eczanelerden birini kullanın. Tahlil veya uzman muayenesi için ise genellikle en iyi seçenek özel bir kliniktir — bazıları hafta sonu kısaltılmış ama gerçek saatlerle çalışır.",

			WmhPharmacies1:
				"Kalıcı 24 saat açık eczaneler azdır. Podgorica'da üç tane var: Montefarm „Kruševac“ (Bulevar Svetog Petra Cetinjskog 45/a), Moskovska 22'deki BENU ve Bulevar Oktobarske Revolucije 31'deki Holos 7. Budva'da bir tane var — otogarın karşısındaki BENU (Sportska Hala 11). Nikšić'te Montefarm „Gojko Darić“ (Radoja Dakića bb) var. Kotor, Bar, Tivat, Herceg Novi, Bijelo Polje ve ülkenin geri kalanında kalıcı 24 saat açık eczane yoktur. Adresler ve 24 saat açık olma durumu değişebilir — geç saatte gitmeden önce teyit edin.",
			WmhPharmacies2:
				"Kalıcı 24 saat açık eczanenin olmadığı yerlerde, resmi tatillerde nöbetçi sistemi devreye girer: Montefarm her belediyede o gün için bir eczaneyi nöbetçi olarak belirler. Liste her seferinde farklıdır ve tarihten kısa süre önce montefarm.co.me'de yayımlanır; bu yüzden önceki bir ziyarete güvenmek yerine tatilden hemen önce kontrol edin.",
			WmhPharmacies3:
				"Reçetenin nasıl işlediğini, reçetesiz ne satıldığını ve sağlık kartıyla hangi ilaçların ücretsiz olduğunu",
			WmhPharmaciesLink: "Karadağ'da eczaneler ve ilaçlar",
			WmhPharmaciesEnd: ' hakkındaki makalemizde ayrıntılı olarak ele aldık.',

			WmhHospitals1a:
				"Devlet hastanelerinin acil servisleri, haftanın yedi günü, cumartesi veya pazar fark etmeksizin acil hastaları gece gündüz kabul eder. Bu, Podgorica'daki ",
			WmhHospitals1KccgLink: "Karadağ Klinik Merkezi'ni (KCCG)",
			WmhHospitals1b: ', ',
			WmhHospitals1KotorLink: "Kotor Genel Hastanesi'ni",
			WmhHospitals1c: ", Bar'daki ",
			WmhHospitals1BarLink: '„Blažo Orlandić“ Genel Hastanesi\'ni',
			WmhHospitals1d: ', ',
			WmhHospitals1BijeloPoljeLink: "Bijelo Polje Genel Hastanesi'ni",
			WmhHospitals1e: ", Herceg Novi'deki ",
			WmhHospitals1MeljineLink: 'Meljine hastanesini',
			WmhHospitals1f: " ve Cetinje'deki ",
			WmhHospitals1DaniloLink: 'Danilo I hastanesini',
			WmhHospitals1g: ' kapsar.',
			WmhHospitals2: "Ülkenin tek özel hastanesi olan",
			WmhHospitalsLink: 'Codra Hospital',
			WmhHospitalsMid:
				"da Podgorica'da hafta sonu dahil gece gündüz çalışır. Sağlık kartıyla rutin muayeneler devlet merkezlerinde cumartesi ve pazar günleri genellikle yapılmaz — yalnızca acil servis veya ambulans (124) üzerinden acil vakalar kabul edilir.",
			WmhHospitalsEnd: '',

			WmhClinicsIntro:
				"Karadağ'da hafta sonu hasta kabul eden özel klinikler ve laboratuvarlar, şehir şehir:",
			WmhClinicsPodgoricaLabel: 'Podgorica:',
			WmhClinicsHipokratLink: 'Hipokrat Poliklinika',
			WmhClinicsPodgoricaA: ' — cumartesi ve pazar, 7:30–22:00; ',
			WmhClinicsMilmedikaPgLink: 'Milmedika Podgorica',
			WmhClinicsPodgoricaB: ' — cumartesi ve pazar, 8:00–20:00; ',
			WmhClinicsMojLabPgLink: 'Moj Lab',
			WmhClinicsPodgoricaC: ' ve ',
			WmhClinicsMojLabPedLink: 'pediatri şubesi',
			WmhClinicsPodgoricaD: " — cumartesi 20:00'a, pazar 13:00'e kadar; ",
			WmhClinicsMedikidLink: 'Medikid',
			WmhClinicsPodgoricaE:
				" (pediatri) — cumartesi 20:00'a, pazar öğlene kadar.",
			WmhClinicsBudvaLabel: 'Budva:',
			WmhClinicsMilmedikaBdLink: 'Milmedika Budva',
			WmhClinicsBudvaA: ' (her iki gün 8:00–20:00) ve ',
			WmhClinicsMojLabBdLink: 'Moj Lab Budva',
			WmhClinicsBudvaB: ' (her iki gün 8:00–21:00).',
			WmhClinicsBarLabel: 'Bar:',
			WmhClinicsMasonicicLink: 'Dr Masoničić polikliniği',
			WmhClinicsBarA: ' (8:00–20:00) ve ',
			WmhClinicsA3Link: 'A3 Medical',
			WmhClinicsBarB: ' (Sutomore, 8:00–21:00).',
			WmhClinicsTivatLabel: 'Tivat:',
			WmhClinicsMansaLink: 'Mansa Medica',
			WmhClinicsTivatA: ' (çocuk hastaları da kabul eder) ve ',
			WmhClinicsDentalExpertLink: 'Dental Expert',
			WmhClinicsTivatB: ' (diş kliniği).',
			WmhClinicsNiksicLabel: 'Nikšić:',
			WmhClinicsMilmedikaNkLink: 'Milmedika Nikšić',
			WmhClinicsNiksicA: ' (8:00–20:00).',
			WmhClinicsCatalog: 'Saatler değişebilir — güncel programı',
			WmhClinicsLink: 'klinik kataloğu',
			WmhClinicsEnd: ' üzerinden kontrol edin.',

			WmhSources0:
				'Bilgiler Temmuz 2026 itibarıyla günceldir. Eczane ve klinik saatleri değişebilir — gitmeden önce doğrulayın:',
			WmhSourcesMontefarm:
				'Montefarm — belediyeye göre resmi tatil nöbetçi eczaneleri: montefarm.co.me;',
			WmhSourcesCatalog:
				'Klinik kataloğumuzda listelenen her kliniğin çalışma saatleri belirtilir.',

			WmhCtaTitle: 'Şu anda açık bir klinik mi arıyorsunuz?',
			WmhCtaText:
				'Klinik kataloğumuzda her kliniğin çalışma saatleri gösterilir — yakınınızda açık birini bulun.',
			WmhCtaButton: 'Klinik kataloğunu açın',
		},
	},
};
