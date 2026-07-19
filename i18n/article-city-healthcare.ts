// Контент серии статей «Медицина в {городе}» (Будва, Подгорица, Котор, Бар).
// Ключи: общие (CityHc*) + по-городские (CityHc*_budva / _podgorica / _kotor / _bar).
// Источники: телеграм-чат medicina_montenegro (экспорт 2026-03), каталог docta.me.
export default {
	messages: {
		'en': {
			// Shared
			'CityHcToc_overview': 'What the city offers',
			'CityHcToc_emergency': 'Emergency care',
			'CityHcToc_state': 'Public healthcare',
			'CityHcToc_private': 'Private clinics and laboratories',
			'CityHcToc_pharmacies': 'Pharmacies and on-call services',
			CityHcEmergencyShared:
				'The nationwide ambulance number in Montenegro is 124. Dispatchers speak Montenegrin and usually understand basic English. Ambulances mostly go out to severe cases: if your condition allows, it is often faster to get to the emergency unit (hitna pomoć) yourself.',
			CityHcLinkEnd: '.',
			CityHcWeekendText:
				'A full list of pharmacies and clinics open on weekends across Montenegro is in a separate',
			CityHcWeekendLink: 'article',
			CityHcCtaTitle: 'Need a clinic near you?',
			CityHcCtaText:
				'In the catalog you can filter clinics by city and language — with a map, prices and reviews.',

			// Budva
			CityHcTitle_budva:
				'Healthcare in Budva: emergency care, Dom zdravlja and private clinics',
			CityHcDescription_budva:
				'Where to get medical help in Budva: ambulance 124, Dom zdravlja Budva, the tourist ambulanta, private clinics and laboratories, pharmacies — a practical guide.',
			CityHcOverview1_budva:
				"Budva is Montenegro's main resort town, and its medical infrastructure serves both residents and the seasonal flow of visitors. The key public facility is Dom zdravlja Budva (the primary care center), which hosts the ambulance service and a seasonal tourist ambulanta. The town has no public hospital of its own.",
			CityHcOverview2_budva:
				'The private sector is well developed: general polyclinics, labs, several dental clinics, a gynecology clinic and two ophthalmology clinics offering laser eye surgery — English or Russian is spoken in many of them.',
			CityHcEmergency1_budva:
				'The emergency unit (hitna pomoć) in Budva is located at the Dom zdravlja and works around the clock. According to expat chat reports, it also sees children — you can go there directly with a child.',
			CityHcEmergency2a_budva:
				'For serious injuries and conditions requiring hospitalization, patients from Budva are referred to the ',
			CityHcEmergency2KotorLink_budva: 'hospital in Kotor',
			CityHcEmergency2b_budva: ' (about half an hour away) or to the ',
			CityHcEmergency2KccgLink_budva: 'Clinical Center of Montenegro',
			CityHcEmergency2c_budva:
				' in Podgorica. The referral (uputnica) is issued by the hitna pomoć doctor.',
			CityHcState1_budva:
				'Dom zdravlja Budva is the public primary care center: GPs (izabrani doktor), pediatrics, a laboratory and treatment rooms. For holders of the zdravstvena knjižica health card, visits are free or almost free.',
			CityHcState2_budva:
				'In summer the center runs a tourist ambulanta — paid appointments for visitors without the health card. The Dom zdravlja also offers seasonal flu vaccination and occasional free campaigns such as HIV and hepatitis testing. Several doctors there speak Russian, some also English.',
			CityHcState3_budva:
				'Planned hospitalization and specialist care follow the same route — Kotor or Podgorica — on referral from your chosen doctor. Judging by the specialties of its staff, the general hospital in Kotor is a multi-department facility: internal medicine, general surgery, gynecology and obstetrics, radiology, pediatrics, urology and several other fields.',
			CityHcStateCatalog_budva: 'The institution’s page on docta.me — address, reviews and services:',
			CityHcStateLink_budva: 'Dom Zdravlja Budva',
			CityHcPrivate1_budva:
				'Budva has plenty of private clinics and laboratories — from general polyclinics and the Moj Lab laboratory chain to dentistry, gynecology and ophthalmology with laser eye surgery. A more or less complete list of what is in our catalog:',
			CityHcPvGroupLabel_Polyclinic: 'General polyclinics',
			CityHcPvMilmedika: 'Milmedika Budva',
			CityHcPvMojLab: 'Moj Lab Budva',
			CityHcPvBonoMedica: 'BonoMedica',
			CityHcPvMedicalCentar: 'Medical Centar Budva',
			CityHcPvGroupLabel_Dental: 'Dental clinics',
			CityHcPvDukley: 'Dukley Dental Clinic',
			CityHcPvReDent: 'ReDent',
			CityHcPvZecevic: 'Zečević Dental',
			CityHcPvGroupLabel_Ophthalmology: 'Ophthalmology, laser eye surgery',
			CityHcPvLaserFocus: 'LaserFocus',
			CityHcPvSvjetlost: 'Svjetlost Eye Clinic',
			CityHcPvGroupLabel_Gynecology: 'Gynecology',
			CityHcPvGroupLabel_Cardiology: 'Cardiology',
			CityHcPvGroupLabel_Physiotherapy: 'Physiotherapy',
			CityHcPvGroupLabel_RussianDental: 'Dental clinics with Russian-speaking doctors',
			CityHcPvGroupLabel_PolyclinicHospital: 'Polyclinics and hospitals',
			CityHcPvGroupLabel_SurgicalHospital: 'Private hospitals with surgery',
			CityHcPvGroupLabel_AestheticSurgery: 'Plastic and aesthetic surgery',
			CityHcPvHumana: 'Humana reprodukcija',
			CityHcPrivateCatalog_budva:
				'For an up-to-date list with addresses, prices and reviews, see the catalog:',
			CityHcPrivateLink_budva: 'private clinics in Budva',
			CityHcLabs_budva:
				"You can also get tested without a doctor's referral — paid, at any private laboratory. See the list of tests with prices in the section",
			CityHcLabsLink_budva: 'lab tests in Budva',
			CityHcPharmacy1_budva:
				'There are many pharmacies in Budva, and in season most work seven days a week. Prescription drugs (antibiotics above all) formally require a prescription from a Montenegrin doctor — a private clinic doctor can issue one.',
			CityHcPharmacy2_budva:
				'Chat members point to a 24-hour pharmacy near the bus station — BENU at Sportska Hala 11, also listed on Montefarm’s own duty roster. Schedules can still shift, so check locally; at night, in an acute situation, it is more reliable to go straight to hitna pomoć.',
			CityHcCtaButton_budva: 'Clinics in Budva',

			// Podgorica
			CityHcTitle_podgorica:
				'Healthcare in Podgorica: Clinical Center, emergency care and private clinics',
			CityHcDescription_podgorica:
				'Medical help in Podgorica: ambulance 124, the Clinical Center of Montenegro and its Urgent Care Center, Dom zdravlja, private clinics and laboratories, 24-hour pharmacies.',
			CityHcOverview1_podgorica:
				"Podgorica is Montenegro's medical capital with the most complete infrastructure in the country. The key institution is the Clinical Center of Montenegro (KCCG), where complex patients are referred from all over the country. The city also has the Dom zdravlja with branches in different districts, the Institute of Public Health and the Blood Transfusion Institute.",
			CityHcOverview2_podgorica:
				'The private sector is the largest in the country: multi-specialty clinics, private hospitals with surgery, dozens of laboratories and dental offices. If you cannot find a service in your town, it most likely exists in Podgorica.',
			CityHcEmergency1_podgorica:
				"Round-the-clock emergency care is provided by the Urgent Care Center (Urgentni centar) at the Clinical Center: in acute situations you will be seen without a referral. Children are seen around the clock at the Institute for Children's Diseases on the KCCG campus.",
			CityHcEmergency2_podgorica:
				'The city ambulance service (hitna pomoć) also works 24/7 and will take the patient to the Urgent Care Center when needed.',
			CityHcState1_podgorica:
				"The Clinical Center of Montenegro is the country's main hospital: surgery, cardiology, oncology, a maternity ward and every narrow specialty. Planned hospitalization and consultations require a referral from your chosen doctor (izabrani doktor) under the zdravstvena knjižica health card; without the card, services are paid according to the price list.",
			CityHcState2_podgorica:
				'Dom zdravlja Podgorica is a network of public primary care centers (several blocks in different districts): general practice, pediatrics, laboratory, a mental health center.',
			CityHcState3_podgorica:
				'The Institute of Public Health (Institut za javno zdravlje) handles vaccination, including travel vaccines. The Blood Transfusion Institute (Zavod za transfuziju krvi) accepts donors and does blood group testing.',
			CityHcStateCatalog_podgorica: 'KCCG’s page on docta.me — departments, reviews and services:',
			CityHcStateLink_podgorica: 'Klinički Centar Crne Gore',
			CityHcPrivate1_podgorica:
				'Podgorica has the widest choice of private medicine in the country — for example, Konzilijum has MRI and a broad range of operations, and Ars Medica is a large surgical and aesthetic hospital. Here are the main facilities by profile (the full list — dozens of clinics — is in the catalog):',
			CityHcPvKonzilijum: 'Konzilijum',
			CityHcPvArsMedica: 'Ars Medica',
			CityHcPvMedtim: 'Medtim',
			CityHcPvCodraHospital: 'Codra Hospital',
			CityHcPvAMedic: 'A Medic',
			CityHcPvHipokratPg: 'Hipokrat',
			CityHcPvMojLabPg: 'Moj Lab',
			CityHcPvMilmedikaPg: 'Milmedika',
			CityHcPvFilipovicPg: 'Poliklinika Filipović',
			CityHcPrivateCatalog_podgorica:
				'The full list with prices and reviews is in the catalog:',
			CityHcPrivateLink_podgorica: 'private clinics in Podgorica',
			CityHcLabs_podgorica:
				'Tests can be done privately without a referral at any laboratory. Prices and addresses are in the section',
			CityHcLabsLink_podgorica: 'lab tests in Podgorica',
			CityHcPharmacy1_podgorica:
				'Podgorica has hundreds of pharmacies: the state Montefarm chain and private networks. Three are open round the clock: Montefarm "Kruševac" (Bulevar Svetog Petra Cetinjskog 45/a), BENU on Moskovska 22, and Holos 7 on Bulevar Oktobarske Revolucije 31. Addresses and round-the-clock status can change — confirm before a late-night trip.',
			CityHcPharmacy2_podgorica:
				'Many drugs sold freely elsewhere require a Montenegrin prescription here. If a medicine is out of stock, ask for an analog by active ingredient — brand names often differ.',
			CityHcCtaButton_podgorica: 'Clinics in Podgorica',

			// Kotor
			CityHcTitle_kotor:
				'Healthcare in Kotor: general hospital, Dom zdravlja and emergency care',
			CityHcDescription_kotor:
				'Medical help in Kotor: ambulance 124, Kotor General Hospital serving the whole Boka bay, Dom zdravlja Kotor, the specialized hospital in Risan, private laboratories and pharmacies.',
			CityHcOverview1_kotor:
				'Kotor is the medical hub of the Boka Kotorska bay: it hosts the Kotor General Hospital (Opšta bolnica Kotor), which serves the whole coastal area including Tivat, Budva and Herceg Novi. Primary care is provided by Dom zdravlja Kotor with its ambulance service.',
			CityHcOverview2_kotor:
				'Nearby — in Risan and Dobrota — are two specialized state hospitals: one for orthopedics, one psychiatric. The private sector in Kotor itself is smaller than in Budva or Podgorica, but there is something: a lab, polyclinics, cardiology and dental clinics.',
			CityHcEmergency1_kotor:
				'In an emergency, go to hitna pomoć at Dom zdravlja Kotor or directly to the admission unit of the Kotor hospital: injuries, pediatric emergencies and infections from along the coast are brought here (the hospital has pediatric and infectious disease wards).',
			CityHcEmergency2_kotor:
				'Note: for foreigners without the health card and insurance, hospital treatment is paid according to the price list, and inpatient bills can be substantial. If you have an insurance policy, clarify the procedure with your insurer in advance; you can ask for a cost estimate before treatment starts.',
			CityHcState1_kotor:
				'The general hospital in Kotor is a multi-department facility serving the whole Bay of Kotor (Budva, Tivat, Herceg Novi). Judging by its medical staff, it has departments for internal medicine, general surgery, gynecology and obstetrics, radiology, pediatrics, urology and infectious diseases, plus several narrower specialties.',
			CityHcState2_kotor:
				'Dom zdravlja Kotor is the public primary care center: chosen doctor, pediatrician, laboratory. With the zdravstvena knjižica, visits are free, and your chosen GP issues prescriptions for subsidized medicines.',
			CityHcState3a_kotor: 'The specialized ',
			CityHcState3VasoLink_kotor: '"Vaso Ćuković" hospital',
			CityHcState3b_kotor:
				' in Risan (about half an hour along the bay from Kotor) is the national center for orthopedics, neurosurgery and neurology — patients are referred here from across the country, not just the coast. Kotor, in the Dobrota area, is also home to the specialized psychiatric hospital ',
			CityHcState3DobrotaLink_kotor: '"Dobrota"',
			CityHcState3c_kotor:
				' — the only dedicated psychiatric hospital in Montenegro (other cities only have outpatient psychiatric care or a department within a general hospital).',
			CityHcStateCatalog_kotor: 'The hospital’s page on docta.me — departments, reviews and services:',
			CityHcStateLink_kotor: 'Opšta bolnica Kotor',
			CityHcPrivate1_kotor:
				'The private sector in Kotor itself is small: a lab, a couple of polyclinics, a cardiology clinic, dental offices and physiotherapy. For a wider choice, Kotor residents usually go to Budva or Podgorica. What is available locally, per our catalog:',
			CityHcPvSmartMed: 'SmartMed Kotor',
			CityHcPvHipokratRadanovici: 'Hipokrat Radanovići',
			CityHcPvInterCardio: 'Inter Cardio',
			CityHcPvDentalStudioVucetic: 'Dental Studio Vučetić',
			CityHcPvDrCetkovic: 'Dr Ćetković',
			CityHcPvOrthoCentarKotor: 'Ortho Centar',
			CityHcPvEndorfinRadanovici: 'Endorfin Radanovići',
			CityHcPrivateCatalog_kotor:
				'See what is available in the town itself in the catalog:',
			CityHcPrivateLink_kotor: 'private clinics in Kotor',
			CityHcLabs_kotor:
				'Private laboratories accept tests without a referral. The list with prices is in the section',
			CityHcLabsLink_kotor: 'lab tests in Kotor',
			CityHcPharmacy1_kotor:
				'Pharmacies operate in the Old Town and the newer districts; in season the hours are extended. There may be no 24-hour pharmacy in Kotor — keep a stock of your regular medicines at home.',
			CityHcPharmacy2_kotor:
				'At night, in an acute situation, go to hitna pomoć or the hospital admission unit: they will examine you and provide the first medicines.',
			CityHcCtaButton_kotor: 'Clinics in Kotor',

			// Bar
			CityHcTitle_bar:
				'Healthcare in Bar: hospital, Dom zdravlja and private clinics',
			CityHcDescription_bar:
				"Medical help in Bar: ambulance 124, Dom zdravlja Bar in the center, the Blažo Orlandić hospital in Stari Bar, private clinics, laboratories and pharmacies.",
			CityHcOverview1_bar:
				"Bar has the full set of public healthcare: Dom zdravlja Bar (the primary care center with the ambulance service) in the city center and the Blažo Orlandić General Hospital in Stari Bar — a round-the-clock inpatient facility.",
			CityHcOverview2_bar:
				'The private sector is notable: polyclinics, a private day hospital, laboratories and many dental offices. In Sutomore (Bar municipality) there is a private hospital with CT and MRI.',
			CityHcEmergency1_bar:
				'In an emergency: hitna pomoć is located at the Dom zdravlja in the center of Bar. For injuries and conditions requiring hospitalization you can go directly to the hospital in Stari Bar — the admission unit works around the clock.',
			CityHcEmergency2_bar:
				'The scheme shared in the chat: first hitna — they will examine you and issue a referral to the hospital if needed; or straight to the hospital admission unit when it is obvious that inpatient care is required.',
			CityHcState1_bar:
				"The Blažo Orlandić General Hospital is a multi-specialty facility: surgery, gynecology and a maternity ward, pediatrics, X-ray and CT, physiotherapy. Treatment is free with the health card; for others it is paid by the price list.",
			CityHcState2_bar:
				'Dom zdravlja Bar is the primary care level: chosen doctor, pediatrics, laboratory, vaccination (including some travel vaccines). Some doctors there speak Russian or English — ask when booking.',
			CityHcState3_bar:
				'Specialized examinations not available in Bar are done by referral in Podgorica — the Clinical Center is about an hour away.',
			CityHcStateCatalog_bar: 'The hospital’s page on docta.me — departments, reviews and services:',
			CityHcStateLink_bar: 'Opšta Bolnica "Blažo Orlandić"',
			CityHcPrivate1_bar:
				'Bar and Sutomore have several sizeable private clinics and labs — for instance, A3 Medical in Sutomore offers CT and MRI, and provides a free interpreter (Russian, English) for your appointment. Bar has an especially large number of dental clinics, including some with Russian-speaking doctors; there are also ENT, urology and gynecology practices. A more or less complete list, per our catalog:',
			CityHcPvNoviStandardBar: 'Novi Standard',
			CityHcPvDrZejnilovic: 'Dr Zejnilović',
			CityHcPvMedicalVranes: 'Medical Vraneš',
			CityHcPvA3Medical: 'A3 Medical',
			CityHcPvJustDental: 'Just Dental',
			CityHcPvPavlinDental: 'Pavlin',
			CityHcPvDrDebelja: 'Dr Debelja',
			CityHcPvGroupLabel_OtherDental: 'Other dental clinics',
			CityHcPvBuntic: 'Buntić',
			CityHcPvDrSimonovic: 'Dr Simonović',
			CityHcPvDrBajagic: 'Dr Bajagić',
			CityHcPvDrZejak: 'Dr Zejak',
			CityHcPvGacina: 'Gaćina',
			CityHcPvJovoticDent: 'Jovetić Dent',
			CityHcPvCicmil: 'Cicmil',
			CityHcPrivateCatalog_bar:
				'The full list with prices and reviews is in the catalog:',
			CityHcPrivateLink_bar: 'private clinics in Bar',
			CityHcLabs_bar:
				'Tests are accepted without a referral at private laboratories. The list with prices is in the section',
			CityHcLabsLink_bar: 'lab tests in Bar',
			CityHcPharmacy1_bar:
				'Pharmacies are spread across the center and Šušanj.',
			CityHcLenapharmText_bar: 'Chat members especially often recommend',
			CityHcLenapharmAfter_bar: 'in Šušanj — staff there answer in Russian.',
			CityHcPharmacy2_bar:
				'There may be no 24-hour pharmacy — at night go to hitna pomoć or the hospital admission unit. Prescription drugs are sold with a prescription from a Montenegrin doctor.',
			CityHcCtaButton_bar: 'Clinics in Bar',
		},
		'ru': {
			// Общие
			'CityHcToc_overview': 'Что есть в городе',
			'CityHcToc_emergency': 'Экстренная помощь',
			'CityHcToc_state': 'Государственная медицина',
			'CityHcToc_private': 'Частные клиники и лаборатории',
			'CityHcToc_pharmacies': 'Аптеки и дежурные службы',
			CityHcEmergencyShared:
				'Единый номер скорой помощи в Черногории — 124. Диспетчеры говорят на черногорском, базовый английский обычно понимают. На вызовы на дом скорая выезжает в основном в тяжёлых случаях: если состояние позволяет, быстрее самостоятельно добраться до дежурной службы (hitna pomoć).',
			CityHcLinkEnd: '.',
			CityHcWeekendText:
				'Полный список аптек и клиник Черногории, открытых по выходным, — в отдельной',
			CityHcWeekendLink: 'статье',
			CityHcCtaTitle: 'Нужна клиника рядом с вами?',
			CityHcCtaText:
				'В каталоге можно фильтровать клиники по городу и языку — с картой, ценами и отзывами.',

			// Будва
			CityHcTitle_budva:
				'Медицина в Будве: скорая, Dom zdravlja и частные клиники',
			CityHcDescription_budva:
				'Куда обращаться за медицинской помощью в Будве: скорая 124, Dom zdravlja Budva, туристическая амбулатория, частные клиники и лаборатории, аптеки — практический гид.',
			CityHcOverview1_budva:
				'Будва — главный туристический город Черногории, и медицинская инфраструктура здесь рассчитана и на местных жителей, и на сезонный поток гостей. Основное государственное учреждение — Dom zdravlja Budva (поликлиника), при котором работают служба скорой помощи и сезонная туристическая амбулатория. Собственной государственной больницы в городе нет.',
			CityHcOverview2_budva:
				'Частный сектор развит хорошо: поликлиники широкого профиля, лаборатории, несколько стоматологий, гинекологическая клиника и две офтальмологические клиники с лазерной хирургией глаза — во многих можно объясниться на русском или английском.',
			CityHcEmergency1_budva:
				'Служба скорой помощи (hitna pomoć) в Будве находится при Dom zdravlja и принимает круглосуточно. Судя по опыту участников русскоязычных чатов, там есть и детский приём — с ребёнком можно ехать напрямую.',
			CityHcEmergency2a_budva:
				'При серьёзных травмах и состояниях, требующих госпитализации, из Будвы направляют в ',
			CityHcEmergency2KotorLink_budva: 'больницу Котора',
			CityHcEmergency2b_budva: ' (около получаса езды) или в ',
			CityHcEmergency2KccgLink_budva: 'Клинический центр Черногории',
			CityHcEmergency2c_budva:
				' в Подгорице. Направление (uputnica) выдаёт врач hitna pomoć.',
			CityHcState1_budva:
				'Dom zdravlja Budva — государственная поликлиника: терапевты (izabrani doktor), педиатрия, лаборатория, процедурные кабинеты. Для обладателей здравственной книжицы (zdravstvena knjižica) приёмы бесплатны или почти бесплатны.',
			CityHcState2_budva:
				'Летом при поликлинике работает туристическая амбулатория (turistička ambulanta) — платный приём для гостей без книжицы. Также в Dom zdravlja проводят сезонную вакцинацию от гриппа и периодические бесплатные акции, например тестирование на ВИЧ и гепатиты. Среди врачей есть несколько говорящих по-русски, некоторые — и по-английски.',
			CityHcState3_budva:
				'Плановая госпитализация и специализированная помощь — тот же маршрут (Котор или Подгорица), по направлению от выбранного врача. Судя по специальностям врачей, Општа больница Котора — многопрофильный стационар: терапия, общая хирургия, гинекология и акушерство, радиология, педиатрия, урология и ряд других направлений.',
			CityHcStateCatalog_budva: 'Страница учреждения на docta.me — с адресом, отзывами и списком услуг:',
			CityHcStateLink_budva: 'Dom Zdravlja Budva',
			CityHcPrivate1_budva:
				'Частных клиник и лабораторий в Будве много — от терапевтических поликлиник и сети лабораторий Moj Lab до стоматологий, гинекологии и офтальмологии с лазерной хирургией глаза. Более-менее полный список того, что есть в нашем каталоге:',
			CityHcPvGroupLabel_Polyclinic: 'Поликлиники широкого профиля',
			CityHcPvMilmedika: 'Milmedika Budva',
			CityHcPvMojLab: 'Moj Lab Budva',
			CityHcPvBonoMedica: 'BonoMedica',
			CityHcPvMedicalCentar: 'Medical Centar Budva',
			CityHcPvGroupLabel_Dental: 'Стоматологии',
			CityHcPvDukley: 'Dukley Dental Clinic',
			CityHcPvReDent: 'ReDent',
			CityHcPvZecevic: 'Zečević Dental',
			CityHcPvGroupLabel_Ophthalmology: 'Офтальмология, лазерная хирургия глаза',
			CityHcPvLaserFocus: 'LaserFocus',
			CityHcPvSvjetlost: 'Svjetlost Eye Clinic',
			CityHcPvGroupLabel_Gynecology: 'Гинекология',
			CityHcPvGroupLabel_Cardiology: 'Кардиология',
			CityHcPvGroupLabel_Physiotherapy: 'Физиотерапия',
			CityHcPvGroupLabel_RussianDental:
				'Стоматологии с русскоговорящими врачами',
			CityHcPvGroupLabel_PolyclinicHospital: 'Поликлиники и больницы',
			CityHcPvGroupLabel_SurgicalHospital: 'Частные госпитали с хирургией',
			CityHcPvGroupLabel_AestheticSurgery:
				'Пластическая и эстетическая хирургия',
			CityHcPvHumana: 'Humana reprodukcija',
			CityHcPrivateCatalog_budva:
				'Актуальный список с адресами, ценами и отзывами — в каталоге:',
			CityHcPrivateLink_budva: 'частные клиники Будвы',
			CityHcLabs_budva:
				'Сдать анализы можно и без направления врача — платно в любой частной лаборатории. Список анализов с ценами смотрите в разделе',
			CityHcLabsLink_budva: 'анализы в Будве',
			CityHcPharmacy1_budva:
				'Аптек в Будве много, в сезон большинство работает без выходных. Рецептурные препараты (в первую очередь антибиотики) формально продаются по рецепту черногорского врача — его выпишет и врач частной клиники.',
			CityHcPharmacy2_budva:
				'Участники чатов указывают на круглосуточную аптеку у автовокзала — это BENU (Sportska Hala, 11), она же в официальном списке дежурных аптек Montefarm. График всё равно может меняться — уточняйте на месте; ночью при острой ситуации надёжнее обращаться сразу в hitna pomoć.',
			CityHcCtaButton_budva: 'Клиники Будвы',

			// Подгорица
			CityHcTitle_podgorica:
				'Медицина в Подгорице: Клинический центр, скорая и частные клиники',
			CityHcDescription_podgorica:
				'Медицинская помощь в Подгорице: скорая 124, Клинический центр Черногории и Ургентный центр, Dom zdravlja, частные клиники и лаборатории, круглосуточные аптеки.',
			CityHcOverview1_podgorica:
				'Подгорица — медицинская столица Черногории: здесь самая полная инфраструктура в стране. Главное учреждение — Клинический центр Черногории (KCCG), куда направляют сложных пациентов со всей страны. Также работают Dom zdravlja с филиалами в разных районах, Институт общественного здоровья и Институт переливания крови.',
			CityHcOverview2_podgorica:
				'Частный сектор — самый крупный в стране: многопрофильные клиники, частные госпитали с хирургией, десятки лабораторий и стоматологий. Если нужную услугу не нашли в своём городе, скорее всего, она есть в Подгорице.',
			CityHcEmergency1_podgorica:
				'Круглосуточная экстренная помощь — Ургентный центр (Urgentni centar) при Клиническом центре: в острых состояниях сюда принимают и без направления. Детей круглосуточно принимает Институт болезней детей (детская больница) на территории KCCG.',
			CityHcEmergency2_podgorica:
				'Городская служба hitna pomoć также работает круглосуточно и при необходимости сама доставляет пациента в Ургентный центр.',
			CityHcState1_podgorica:
				'Клинический центр Черногории — главная больница страны: хирургия, кардиология, онкология, роддом и все узкие специальности. Плановая госпитализация и консультации — по направлению выбранного врача (izabrani doktor) по здравственной книжице; без книжицы услуги платные по прейскуранту.',
			CityHcState2_podgorica:
				'Dom zdravlja Podgorica — сеть государственных поликлиник (несколько блоков в разных районах города): терапия, педиатрия, лаборатория, центр ментального здоровья.',
			CityHcState3_podgorica:
				'Институт общественного здоровья (Institut za javno zdravlje) занимается в том числе вакцинацией, включая прививки для путешественников. Институт переливания крови (Zavod za transfuziju krvi) принимает доноров и делает анализы группы крови.',
			CityHcStateCatalog_podgorica: 'Страница KCCG на docta.me — с отделениями, отзывами и услугами:',
			CityHcStateLink_podgorica: 'Klinički Centar Crne Gore',
			CityHcPrivate1_podgorica:
				'Выбор частной медицины в Подгорице самый широкий в стране — например, в Konzilijum есть МРТ и большой выбор операций, а Ars Medica — крупный хирургический и эстетический госпиталь. Вот основные заведения по профилю (полный список — десятки клиник — в каталоге):',
			CityHcPvKonzilijum: 'Konzilijum',
			CityHcPvArsMedica: 'Ars Medica',
			CityHcPvMedtim: 'Medtim',
			CityHcPvCodraHospital: 'Codra Hospital',
			CityHcPvAMedic: 'A Medic',
			CityHcPvHipokratPg: 'Hipokrat',
			CityHcPvMojLabPg: 'Moj Lab',
			CityHcPvMilmedikaPg: 'Milmedika',
			CityHcPvFilipovicPg: 'Poliklinika Filipović',
			CityHcPrivateCatalog_podgorica:
				'Полный список с ценами и отзывами — в каталоге:',
			CityHcPrivateLink_podgorica: 'частные клиники Подгорицы',
			CityHcLabs_podgorica:
				'Анализы можно сдать платно без направления в любой частной лаборатории. Цены и адреса — в разделе',
			CityHcLabsLink_podgorica: 'анализы в Подгорице',
			CityHcPharmacy1_podgorica:
				'Аптек в Подгорице сотни: государственная сеть Montefarm и частные сети. Три работают круглосуточно: Montefarm «Kruševac» (бульвар Св. Петра Цетинского, 45/а), BENU на Московской, 22, и Holos 7 на бульваре Октябрьской революции, 31. Адреса и круглосуточный режим могут измениться — уточняйте перед поздней поездкой.',
			CityHcPharmacy2_podgorica:
				'Многие препараты, которые в других странах продаются свободно, здесь требуют рецепта черногорского врача. Если лекарства нет в наличии, спрашивайте аналог по действующему веществу — торговые названия часто отличаются.',
			CityHcCtaButton_podgorica: 'Клиники Подгорицы',

			// Котор
			CityHcTitle_kotor:
				'Медицина в Которе: больница, Dom zdravlja и скорая помощь',
			CityHcDescription_kotor:
				'Медицинская помощь в Которе: скорая 124, Општа больница Котор, обслуживающая всю Боку, Dom zdravlja Kotor, специализированная больница в Рисане, частные лаборатории и аптеки.',
			CityHcOverview1_kotor:
				'Котор — медицинский центр Боки Которской: здесь находится Општа больница Котор (Opšta bolnica Kotor), обслуживающая всё побережье залива, включая Тиват, Будву и Херцег-Нови. Первичное звено — Dom zdravlja Kotor со службой скорой помощи.',
			CityHcOverview2_kotor:
				'Рядом с городом — в Рисане и Доброте — работают две специализированные государственные больницы: ортопедическая и психиатрическая. Частный сектор в самом Которе скромнее, чем в Будве или Подгорице, но кое-что есть — лаборатория, поликлиники, кардиология, стоматологии.',
			CityHcEmergency1_kotor:
				'В экстренных случаях — hitna pomoć при Dom zdravlja Kotor или сразу приёмное отделение больницы Котора: сюда с побережья везут травмы, детские неотложные состояния и инфекции (в больнице есть детское и инфекционное отделения).',
			CityHcEmergency2_kotor:
				'Учтите: для иностранцев без здравственной книжицы и страховки лечение в больнице платное по прейскуранту, и счета за стационар бывают ощутимыми. Если есть полис — заранее уточните у страховой порядок обращения; смету можно попросить до начала лечения.',
			CityHcState1_kotor:
				'Општа больница Котор — многопрофильный стационар, обслуживающий всю Боку Которскую (Будву, Тиват, Херцег-Нови). Судя по составу врачей, здесь есть отделения внутренних болезней, общей хирургии, гинекологии и акушерства, радиологии, педиатрии, урологии и инфекционное, а также ряд более узких специальностей.',
			CityHcState2_kotor:
				'Dom zdravlja Kotor — государственная поликлиника: выбранный врач, педиатр, лаборатория. По здравственной книжице приёмы бесплатны, рецепты на льготные лекарства выписывает выбранный терапевт.',
			CityHcState3a_kotor: 'Специализированная больница ',
			CityHcState3VasoLink_kotor: '«Васо Чукович»',
			CityHcState3b_kotor:
				' в Рисане (в получасе вдоль залива от Котора) — государственный центр ортопедии, нейрохирургии и неврологии: сюда направляют пациентов со всей страны, а не только с побережья. Также в Которе, в районе Доброта, находится специализированная психиатрическая больница ',
			CityHcState3DobrotaLink_kotor: '«Доброта»',
			CityHcState3c_kotor:
				' — единственный в Черногории специализированный психиатрический стационар (в других городах есть только амбулаторная психиатрическая помощь или отделение в составе обычной больницы).',
			CityHcStateCatalog_kotor: 'Страница больницы на docta.me — с отделениями, отзывами и услугами:',
			CityHcStateLink_kotor: 'Opšta bolnica Kotor',
			CityHcPrivate1_kotor:
				'Частный сектор в самом Которе небольшой: лаборатория, пара поликлиник, кардиологическая клиника, стоматологии и физиотерапия. За более широким выбором жители Котора обычно едут в Будву или Подгорицу. Что есть на месте — по нашему каталогу:',
			CityHcPvSmartMed: 'SmartMed Kotor',
			CityHcPvHipokratRadanovici: 'Hipokrat Radanovići',
			CityHcPvInterCardio: 'Inter Cardio',
			CityHcPvDentalStudioVucetic: 'Dental Studio Vučetić',
			CityHcPvDrCetkovic: 'Dr Ćetković',
			CityHcPvOrthoCentarKotor: 'Ortho Centar',
			CityHcPvEndorfinRadanovici: 'Endorfin Radanovići',
			CityHcPrivateCatalog_kotor:
				'Что есть в самом городе — смотрите в каталоге:',
			CityHcPrivateLink_kotor: 'частные клиники Котора',
			CityHcLabs_kotor:
				'Частные лаборатории принимают анализы без направления. Список с ценами — в разделе',
			CityHcLabsLink_kotor: 'анализы в Которе',
			CityHcPharmacy1_kotor:
				'Аптеки работают в Старом городе и новых районах; в сезон график расширяется. Круглосуточной аптеки в Которе может не быть — запас постоянных лекарств лучше держать дома.',
			CityHcPharmacy2_kotor:
				'Ночью при острой ситуации обращайтесь в hitna pomoć или в приёмное отделение больницы: там осмотрят и дадут первые препараты.',
			CityHcCtaButton_kotor: 'Клиники Котора',

			// Бар
			CityHcTitle_bar:
				'Медицина в Баре: больница, Dom zdravlja и частные клиники',
			CityHcDescription_bar:
				'Медицинская помощь в Баре: скорая 124, Dom zdravlja Bar в центре города, больница «Блажо Орландич» в Старом Баре, частные клиники, лаборатории и аптеки.',
			CityHcOverview1_bar:
				'В Баре есть полный набор государственной медицины: Dom zdravlja Bar (поликлиника со службой скорой помощи) в центре города и Општа больница «Блажо Орландич» в Старом Баре — круглосуточный стационар.',
			CityHcOverview2_bar:
				'Частный сектор заметный: поликлиники, частная дневная больница, лаборатории и много стоматологий. В Сутоморе (община Бар) работает частная больница с КТ и МРТ.',
			CityHcEmergency1_bar:
				'Экстренно: hitna pomoć находится при Dom zdravlja в центре Бара. При травмах и состояниях, требующих стационара, можно ехать сразу в больницу в Старом Баре — приёмное отделение работает круглосуточно.',
			CityHcEmergency2_bar:
				'Схема из чата: сначала hitna — там осмотрят и при необходимости выдадут направление в больницу; либо напрямую в приёмное отделение больницы, если очевидно, что нужен стационар.',
			CityHcState1_bar:
				'Општа больница «Блажо Орландич» — многопрофильный стационар: хирургия, гинекология с роддомом, педиатрия, рентген и КТ, физиотерапия. По здравственной книжице лечение бесплатно, для остальных — по прейскуранту.',
			CityHcState2_bar:
				'Dom zdravlja Bar — первичное звено: выбранный врач, педиатрия, лаборатория, вакцинация (в том числе некоторые прививки для путешественников). Среди врачей есть говорящие по-русски и по-английски — уточняйте при записи.',
			CityHcState3_bar:
				'Плановые узкие обследования, которых нет в Баре, делают по направлению в Подгорице — Клинический центр примерно в часе езды.',
			CityHcStateCatalog_bar: 'Страница больницы на docta.me — с отделениями, отзывами и услугами:',
			CityHcStateLink_bar: 'Opšta Bolnica "Blažo Orlandić"',
			CityHcPrivate1_bar:
				'В Баре и Сутоморе несколько крупных частных клиник и лабораторий — например, в Сутоморе A3 Medical делает КТ и МРТ, и бесплатно предоставляет переводчика на приём (русский, английский). Стоматологий в Баре особенно много, есть и с русскоговорящими врачами; также есть ЛОР, урология и гинекология. Более-менее полный список — по нашему каталогу:',
			CityHcPvNoviStandardBar: 'Novi Standard',
			CityHcPvDrZejnilovic: 'Dr Zejnilović',
			CityHcPvMedicalVranes: 'Medical Vraneš',
			CityHcPvA3Medical: 'A3 Medical',
			CityHcPvJustDental: 'Just Dental',
			CityHcPvPavlinDental: 'Pavlin',
			CityHcPvDrDebelja: 'Dr Debelja',
			CityHcPvGroupLabel_OtherDental: 'Другие стоматологии',
			CityHcPvBuntic: 'Buntić',
			CityHcPvDrSimonovic: 'Dr Simonović',
			CityHcPvDrBajagic: 'Dr Bajagić',
			CityHcPvDrZejak: 'Dr Zejak',
			CityHcPvGacina: 'Gaćina',
			CityHcPvJovoticDent: 'Jovetić Dent',
			CityHcPvCicmil: 'Cicmil',
			CityHcPrivateCatalog_bar:
				'Полный список с ценами и отзывами — в каталоге:',
			CityHcPrivateLink_bar: 'частные клиники Бара',
			CityHcLabs_bar:
				'Частные лаборатории принимают анализы без направления. Список с ценами — в разделе',
			CityHcLabsLink_bar: 'анализы в Баре',
			CityHcPharmacy1_bar: 'Аптеки распределены по центру и Шушаню.',
			CityHcLenapharmText_bar: 'Участники чата особенно часто хвалят аптеку',
			CityHcLenapharmAfter_bar: 'в Шушане — там отвечают по-русски.',
			CityHcPharmacy2_bar:
				'Круглосуточной аптеки может не оказаться — ночью обращайтесь в hitna pomoć или приёмное отделение больницы. Рецептурные препараты продаются по рецепту черногорского врача.',
			CityHcCtaButton_bar: 'Клиники Бара',
		},
		'sr': {
			// Zajednički
			'CityHcToc_overview': 'Šta grad nudi',
			'CityHcToc_emergency': 'Hitna pomoć',
			'CityHcToc_state': 'Državno zdravstvo',
			'CityHcToc_private': 'Privatne klinike i laboratorije',
			'CityHcToc_pharmacies': 'Apoteke i dežurne službe',
			CityHcEmergencyShared:
				'Jedinstveni broj hitne pomoći u Crnoj Gori je 124. Dispečeri govore crnogorski, a obično razumiju osnovni engleski. Ekipe uglavnom izlaze na teren u težim slučajevima: ako stanje dozvoljava, često je brže da sami dođete do hitne pomoći.',
			CityHcLinkEnd: '.',
			CityHcWeekendText:
				'Kompletan spisak apoteka i klinika u Crnoj Gori otvorenih vikendom je u posebnom',
			CityHcWeekendLink: 'članku',
			CityHcCtaTitle: 'Potrebna vam je klinika u vašoj blizini?',
			CityHcCtaText:
				'U katalogu možete filtrirati klinike po gradu i jeziku — sa mapom, cijenama i recenzijama.',

			// Budva
			CityHcTitle_budva:
				'Zdravstvo u Budvi: hitna pomoć, dom zdravlja i privatne klinike',
			CityHcDescription_budva:
				'Gdje potražiti medicinsku pomoć u Budvi: hitna 124, Dom zdravlja Budva, turistička ambulanta, privatne klinike i laboratorije, apoteke — praktični vodič.',
			CityHcOverview1_budva:
				'Budva je glavni turistički grad Crne Gore, pa je medicinska infrastruktura prilagođena i mještanima i sezonskom prilivu gostiju. Glavna državna ustanova je Dom zdravlja Budva, pri kojem rade služba hitne pomoći i sezonska turistička ambulanta. Grad nema sopstvenu državnu bolnicu.',
			CityHcOverview2_budva:
				'Privatni sektor je dobro razvijen: poliklinike opšteg profila, laboratorije, nekoliko stomatoloških ordinacija, ginekološka klinika i dvije oftalmološke klinike sa laserskom hirurgijom oka — u mnogima se možete sporazumjeti na engleskom ili ruskom.',
			CityHcEmergency1_budva:
				'Hitna pomoć u Budvi nalazi se pri Domu zdravlja i radi non-stop. Prema iskustvima iz četova, prima i djecu — sa djetetom možete doći direktno.',
			CityHcEmergency2a_budva:
				'Kod ozbiljnih povreda i stanja koja zahtijevaju hospitalizaciju, pacijenti se iz Budve upućuju u ',
			CityHcEmergency2KotorLink_budva: 'bolnicu u Kotoru',
			CityHcEmergency2b_budva: ' (oko pola sata vožnje) ili u ',
			CityHcEmergency2KccgLink_budva: 'Klinički centar Crne Gore',
			CityHcEmergency2c_budva: ' u Podgorici. Uput izdaje ljekar hitne pomoći.',
			CityHcState1_budva:
				'Dom zdravlja Budva je državna ustanova primarne zaštite: izabrani doktori, pedijatrija, laboratorija i intervencije. Za vlasnike zdravstvene knjižice pregledi su besplatni ili gotovo besplatni.',
			CityHcState2_budva:
				'Ljeti pri domu zdravlja radi turistička ambulanta — pregledi uz plaćanje za goste bez knjižice. Dom zdravlja organizuje i sezonsku vakcinaciju protiv gripa, kao i povremene besplatne akcije, npr. testiranje na HIV i hepatitise. Među ljekarima ima nekoliko koji govore ruski, a neki i engleski.',
			CityHcState3_budva:
				'Planirana hospitalizacija i specijalistička pomoć idu istim putem — Kotor ili Podgorica — uz uput izabranog doktora. Sudeći po specijalnostima ljekara, Opšta bolnica Kotor je višeodjeljenska ustanova: interna medicina, opšta hirurgija, ginekologija i akušerstvo, radiologija, pedijatrija, urologija i još nekoliko oblasti.',
			CityHcStateCatalog_budva: 'Stranica ustanove na docta.me — adresa, recenzije i usluge:',
			CityHcStateLink_budva: 'Dom Zdravlja Budva',
			CityHcPrivate1_budva:
				'Privatnih klinika i laboratorija u Budvi ima mnogo — od opštih poliklinika i lanca laboratorija Moj Lab do stomatologije, ginekologije i oftalmologije sa laserskom hirurgijom oka. Manje-više kompletan spisak onoga što je u našem katalogu:',
			CityHcPvGroupLabel_Polyclinic: 'Poliklinike opšteg profila',
			CityHcPvMilmedika: 'Milmedika Budva',
			CityHcPvMojLab: 'Moj Lab Budva',
			CityHcPvBonoMedica: 'BonoMedica',
			CityHcPvMedicalCentar: 'Medical Centar Budva',
			CityHcPvGroupLabel_Dental: 'Stomatologije',
			CityHcPvDukley: 'Dukley Dental Clinic',
			CityHcPvReDent: 'ReDent',
			CityHcPvZecevic: 'Zečević Dental',
			CityHcPvGroupLabel_Ophthalmology:
				'Oftalmologija, laserska hirurgija oka',
			CityHcPvLaserFocus: 'LaserFocus',
			CityHcPvSvjetlost: 'Svjetlost Eye Clinic',
			CityHcPvGroupLabel_Gynecology: 'Ginekologija',
			CityHcPvGroupLabel_Cardiology: 'Kardiologija',
			CityHcPvGroupLabel_Physiotherapy: 'Fizioterapija',
			CityHcPvGroupLabel_RussianDental:
				'Stomatologije sa ljekarima koji govore ruski',
			CityHcPvGroupLabel_PolyclinicHospital: 'Poliklinike i bolnice',
			CityHcPvGroupLabel_SurgicalHospital: 'Privatne bolnice sa hirurgijom',
			CityHcPvGroupLabel_AestheticSurgery:
				'Plastična i estetska hirurgija',
			CityHcPvHumana: 'Humana reprodukcija',
			CityHcPrivateCatalog_budva:
				'Aktuelni spisak sa adresama, cijenama i recenzijama nalazi se u katalogu:',
			CityHcPrivateLink_budva: 'privatne klinike u Budvi',
			CityHcLabs_budva:
				'Analize možete uraditi i bez uputa — uz plaćanje, u bilo kojoj privatnoj laboratoriji. Spisak analiza sa cijenama pogledajte u sekciji',
			CityHcLabsLink_budva: 'analize u Budvi',
			CityHcPharmacy1_budva:
				'Apoteka u Budvi ima mnogo, a u sezoni većina radi svakog dana. Ljekovi na recept (prije svega antibiotici) formalno se izdaju uz recept crnogorskog ljekara — može ga izdati i ljekar privatne klinike.',
			CityHcPharmacy2_budva:
				'Učesnici četova pominju non-stop apoteku kod autobuske stanice — to je BENU (Sportska Hala 11), koja je i na zvaničnom spisku dežurnih apoteka Montefarma. Raspored se ipak može mijenjati, provjerite na licu mjesta; noću je u hitnim situacijama pouzdanije otići pravo u hitnu pomoć.',
			CityHcCtaButton_budva: 'Klinike u Budvi',

			// Podgorica
			CityHcTitle_podgorica:
				'Zdravstvo u Podgorici: Klinički centar, hitna pomoć i privatne klinike',
			CityHcDescription_podgorica:
				'Medicinska pomoć u Podgorici: hitna 124, Klinički centar Crne Gore i Urgentni centar, dom zdravlja, privatne klinike i laboratorije, non-stop apoteke.',
			CityHcOverview1_podgorica:
				'Podgorica je medicinska prijestonica Crne Gore sa najpotpunijom infrastrukturom u zemlji. Ključna ustanova je Klinički centar Crne Gore (KCCG), u koji se upućuju složeni pacijenti iz cijele zemlje. Tu su i dom zdravlja sa punktovima po raznim djelovima grada, Institut za javno zdravlje i Zavod za transfuziju krvi.',
			CityHcOverview2_podgorica:
				'Privatni sektor je najveći u zemlji: višespecijalističke klinike, privatne bolnice sa hirurgijom, deseci laboratorija i stomatoloških ordinacija. Ako neku uslugu ne nađete u svom gradu, najvjerovatnije postoji u Podgorici.',
			CityHcEmergency1_podgorica:
				'Non-stop urgentnu pomoć pruža Urgentni centar pri Kliničkom centru: u akutnim stanjima primaju i bez uputa. Djecu non-stop prima Institut za bolesti djece u krugu KCCG.',
			CityHcEmergency2_podgorica:
				'Gradska hitna pomoć takođe radi non-stop i po potrebi sama prevozi pacijenta u Urgentni centar.',
			CityHcState1_podgorica:
				'Klinički centar Crne Gore je glavna bolnica u zemlji: hirurgija, kardiologija, onkologija, porodilište i sve uže specijalnosti. Planirana hospitalizacija i konsultacije idu uz uput izabranog doktora po zdravstvenoj knjižici; bez knjižice usluge se plaćaju po cjenovniku.',
			CityHcState2_podgorica:
				'Dom zdravlja Podgorica je mreža državnih ustanova primarne zaštite (nekoliko blokova po djelovima grada): opšta medicina, pedijatrija, laboratorija, centar za mentalno zdravlje.',
			CityHcState3_podgorica:
				'Institut za javno zdravlje bavi se, između ostalog, vakcinacijom, uključujući vakcine za putnike. Zavod za transfuziju krvi prima donore i radi analize krvnih grupa.',
			CityHcStateCatalog_podgorica: 'Stranica KCCG na docta.me — odjeljenja, recenzije i usluge:',
			CityHcStateLink_podgorica: 'Klinički Centar Crne Gore',
			CityHcPrivate1_podgorica:
				'Podgorica ima najširi izbor privatne medicine u zemlji — na primjer, Konzilijum ima magnetnu rezonancu i širok izbor operacija, a Ars Medica je velika hirurška i estetska bolnica. Evo glavnih ustanova po profilu (kompletan spisak — deseci klinika — je u katalogu):',
			CityHcPvKonzilijum: 'Konzilijum',
			CityHcPvArsMedica: 'Ars Medica',
			CityHcPvMedtim: 'Medtim',
			CityHcPvCodraHospital: 'Codra Hospital',
			CityHcPvAMedic: 'A Medic',
			CityHcPvHipokratPg: 'Hipokrat',
			CityHcPvMojLabPg: 'Moj Lab',
			CityHcPvMilmedikaPg: 'Milmedika',
			CityHcPvFilipovicPg: 'Poliklinika Filipović',
			CityHcPrivateCatalog_podgorica:
				'Kompletan spisak sa cijenama i recenzijama je u katalogu:',
			CityHcPrivateLink_podgorica: 'privatne klinike u Podgorici',
			CityHcLabs_podgorica:
				'Analize se rade privatno bez uputa u bilo kojoj laboratoriji. Cijene i adrese su u sekciji',
			CityHcLabsLink_podgorica: 'analize u Podgorici',
			CityHcPharmacy1_podgorica:
				'U Podgorici postoje stotine apoteka: državni lanac Montefarm i privatni lanci. Tri rade non-stop: Montefarm „Kruševac" (Bulevar Svetog Petra Cetinjskog 45/a), BENU na Moskovskoj 22 i Holos 7 na Bulevaru oktobarske revolucije 31. Adrese i non-stop režim rada mogu se promijeniti — provjerite prije noćne posjete.',
			CityHcPharmacy2_podgorica:
				'Mnogi ljekovi koji se drugdje prodaju slobodno ovdje traže recept crnogorskog ljekara. Ako lijeka nema, pitajte za analog po aktivnoj supstanci — komercijalni nazivi se često razlikuju.',
			CityHcCtaButton_podgorica: 'Klinike u Podgorici',

			// Kotor
			CityHcTitle_kotor:
				'Zdravstvo u Kotoru: opšta bolnica, dom zdravlja i hitna pomoć',
			CityHcDescription_kotor:
				'Medicinska pomoć u Kotoru: hitna 124, Opšta bolnica Kotor koja pokriva cijelu Boku, Dom zdravlja Kotor, specijalna bolnica u Risnu, privatne laboratorije i apoteke.',
			CityHcOverview1_kotor:
				'Kotor je medicinski centar Boke Kotorske: tu se nalazi Opšta bolnica Kotor, koja pokriva cijelo područje zaliva, uključujući Tivat, Budvu i Herceg Novi. Primarnu zaštitu pruža Dom zdravlja Kotor sa službom hitne pomoći.',
			CityHcOverview2_kotor:
				'U blizini — u Risanu i Dobroti — rade dvije specijalizovane državne bolnice: jedna za ortopediju, druga psihijatrijska. Privatni sektor u samom Kotoru je skromniji nego u Budvi ili Podgorici, ali nešto ima: laboratorija, poliklinike, kardiologija i stomatologije.',
			CityHcEmergency1_kotor:
				'U hitnim slučajevima idite u hitnu pomoć pri Domu zdravlja Kotor ili direktno na prijemno odjeljenje kotorske bolnice: ovamo se sa primorja dovoze povrede, dječja urgentna stanja i infekcije (bolnica ima dječje i infektivno odjeljenje).',
			CityHcEmergency2_kotor:
				'Imajte u vidu: za strance bez zdravstvene knjižice i osiguranja bolničko liječenje se plaća po cjenovniku, a računi za stacionar mogu biti visoki. Ako imate polisu, unaprijed provjerite proceduru sa osiguravačem; predračun možete tražiti prije početka liječenja.',
			CityHcState1_kotor:
				'Opšta bolnica Kotor je višeodjeljenska ustanova koja opslužuje cijelu Boku Kotorsku (Budvu, Tivat, Herceg Novi). Sudeći po sastavu ljekara, tu postoje odjeljenja interne medicine, opšte hirurgije, ginekologije i akušerstva, radiologije, pedijatrije, urologije i infektivno odjeljenje, kao i niz užih specijalnosti.',
			CityHcState2_kotor:
				'Dom zdravlja Kotor je državna ustanova primarne zaštite: izabrani doktor, pedijatar, laboratorija. Uz zdravstvenu knjižicu pregledi su besplatni, a recepte za ljekove sa liste izdaje izabrani doktor.',
			CityHcState3a_kotor: 'Specijalna bolnica ',
			CityHcState3VasoLink_kotor: '„Vaso Ćuković"',
			CityHcState3b_kotor:
				' u Risanu (oko pola sata duž zaliva od Kotora) — državni centar za ortopediju, neurohirurgiju i neurologiju: ovdje se upućuju pacijenti iz cijele zemlje, ne samo sa primorja. U Kotoru, u dijelu Dobrota, nalazi se i specijalna psihijatrijska bolnica ',
			CityHcState3DobrotaLink_kotor: '„Dobrota"',
			CityHcState3c_kotor:
				' — jedina specijalizovana psihijatrijska bolnica u Crnoj Gori (u drugim gradovima postoji samo ambulantna psihijatrijska pomoć ili odjeljenje u sklopu opšte bolnice).',
			CityHcStateCatalog_kotor: 'Stranica bolnice na docta.me — odjeljenja, recenzije i usluge:',
			CityHcStateLink_kotor: 'Opšta bolnica Kotor',
			CityHcPrivate1_kotor:
				'Privatni sektor u samom Kotoru je mali: laboratorija, par poliklinika, kardiološka klinika, stomatologije i fizioterapija. Za širi izbor stanovnici Kotora obično idu u Budvu ili Podgoricu. Šta postoji na licu mjesta — po našem katalogu:',
			CityHcPvSmartMed: 'SmartMed Kotor',
			CityHcPvHipokratRadanovici: 'Hipokrat Radanovići',
			CityHcPvInterCardio: 'Inter Cardio',
			CityHcPvDentalStudioVucetic: 'Dental Studio Vučetić',
			CityHcPvDrCetkovic: 'Dr Ćetković',
			CityHcPvOrthoCentarKotor: 'Ortho Centar',
			CityHcPvEndorfinRadanovici: 'Endorfin Radanovići',
			CityHcPrivateCatalog_kotor:
				'Šta postoji u samom gradu pogledajte u katalogu:',
			CityHcPrivateLink_kotor: 'privatne klinike u Kotoru',
			CityHcLabs_kotor:
				'Privatne laboratorije primaju analize bez uputa. Spisak sa cijenama je u sekciji',
			CityHcLabsLink_kotor: 'analize u Kotoru',
			CityHcPharmacy1_kotor:
				'Apoteke rade u Starom gradu i novijim djelovima; u sezoni je radno vrijeme duže. Non-stop apoteke u Kotoru možda nema — zalihu stalnih ljekova držite kod kuće.',
			CityHcPharmacy2_kotor:
				'Noću se u akutnoj situaciji obratite hitnoj pomoći ili prijemnom odjeljenju bolnice: tamo će vas pregledati i dati prve ljekove.',
			CityHcCtaButton_kotor: 'Klinike u Kotoru',

			// Bar
			CityHcTitle_bar:
				'Zdravstvo u Baru: bolnica, dom zdravlja i privatne klinike',
			CityHcDescription_bar:
				'Medicinska pomoć u Baru: hitna 124, Dom zdravlja Bar u centru, Opšta bolnica „Blažo Orlandić" u Starom Baru, privatne klinike, laboratorije i apoteke.',
			CityHcOverview1_bar:
				'Bar ima kompletan set državnog zdravstva: Dom zdravlja Bar (sa službom hitne pomoći) u centru grada i Opštu bolnicu „Blažo Orlandić" u Starom Baru — stacionar koji radi non-stop.',
			CityHcOverview2_bar:
				'Privatni sektor je primjetan: poliklinike, privatna dnevna bolnica, laboratorije i mnogo stomatoloških ordinacija. U Sutomoru (opština Bar) radi privatna bolnica sa CT-om i magnetnom rezonancom.',
			CityHcEmergency1_bar:
				'U hitnom slučaju: hitna pomoć se nalazi pri Domu zdravlja u centru Bara. Kod povreda i stanja koja traže stacionar možete ići direktno u bolnicu u Starom Baru — prijemno odjeljenje radi non-stop.',
			CityHcEmergency2_bar:
				'Shema iz četa: prvo hitna — tamo će vas pregledati i po potrebi dati uput za bolnicu; ili pravo na prijemno odjeljenje bolnice kad je očigledno da je potreban stacionar.',
			CityHcState1_bar:
				'Opšta bolnica „Blažo Orlandić" je višespecijalistička ustanova: hirurgija, ginekologija sa porodilištem, pedijatrija, rendgen i CT, fizikalna terapija. Uz zdravstvenu knjižicu liječenje je besplatno; za ostale se plaća po cjenovniku.',
			CityHcState2_bar:
				'Dom zdravlja Bar je primarni nivo: izabrani doktor, pedijatrija, laboratorija, vakcinacija (uključujući neke vakcine za putnike). Neki ljekari tu govore ruski ili engleski — pitajte prilikom zakazivanja.',
			CityHcState3_bar:
				'Specijalistički pregledi kojih nema u Baru rade se po uputu u Podgorici — Klinički centar je na oko sat vremena vožnje.',
			CityHcStateCatalog_bar: 'Stranica bolnice na docta.me — odjeljenja, recenzije i usluge:',
			CityHcStateLink_bar: 'Opšta bolnica „Blažo Orlandić"',
			CityHcPrivate1_bar:
				'U Baru i Sutomoru ima nekoliko velikih privatnih klinika i laboratorija — na primjer, A3 Medical u Sutomoru radi CT i magnetnu rezonancu, i besplatno obezbjeđuje prevodioca (ruski, engleski) za pregled. Bar ima posebno mnogo stomatoloških ordinacija, uključujući one sa ljekarima koji govore ruski; ima i ORL, urologiju i ginekologiju. Manje-više kompletan spisak, po našem katalogu:',
			CityHcPvNoviStandardBar: 'Novi Standard',
			CityHcPvDrZejnilovic: 'Dr Zejnilović',
			CityHcPvMedicalVranes: 'Medical Vraneš',
			CityHcPvA3Medical: 'A3 Medical',
			CityHcPvJustDental: 'Just Dental',
			CityHcPvPavlinDental: 'Pavlin',
			CityHcPvDrDebelja: 'Dr Debelja',
			CityHcPvGroupLabel_OtherDental: 'Ostale stomatologije',
			CityHcPvBuntic: 'Buntić',
			CityHcPvDrSimonovic: 'Dr Simonović',
			CityHcPvDrBajagic: 'Dr Bajagić',
			CityHcPvDrZejak: 'Dr Zejak',
			CityHcPvGacina: 'Gaćina',
			CityHcPvJovoticDent: 'Jovetić Dent',
			CityHcPvCicmil: 'Cicmil',
			CityHcPrivateCatalog_bar:
				'Kompletan spisak sa cijenama i recenzijama je u katalogu:',
			CityHcPrivateLink_bar: 'privatne klinike u Baru',
			CityHcLabs_bar:
				'Analize se primaju bez uputa u privatnim laboratorijama. Spisak sa cijenama je u sekciji',
			CityHcLabsLink_bar: 'analize u Baru',
			CityHcPharmacy1_bar: 'Apoteke su raspoređene po centru i Šušnju.',
			CityHcLenapharmText_bar: 'Učesnici četa posebno često preporučuju apoteku',
			CityHcLenapharmAfter_bar: 'u Šušnju — tamo odgovaraju i na ruskom.',
			CityHcPharmacy2_bar:
				'Non-stop apoteke možda nema — noću se obratite hitnoj pomoći ili prijemnom odjeljenju bolnice. Ljekovi na recept izdaju se uz recept crnogorskog ljekara.',
			CityHcCtaButton_bar: 'Klinike u Baru',
		},
		'sr-cyrl': {
			// Заједнички
			'CityHcToc_overview': 'Шта град нуди',
			'CityHcToc_emergency': 'Хитна помоћ',
			'CityHcToc_state': 'Државно здравство',
			'CityHcToc_private': 'Приватне клинике и лабораторије',
			'CityHcToc_pharmacies': 'Апотеке и дежурне службе',
			CityHcEmergencyShared:
				'Јединствени број хитне помоћи у Црној Гори је 124. Диспечери говоре црногорски, а обично разумију основни енглески. Екипе углавном излазе на терен у тежим случајевима: ако стање дозвољава, често је брже да сами дођете до хитне помоћи.',
			CityHcLinkEnd: '.',
			CityHcWeekendText:
				'Комплетан списак апотека и клиника у Црној Гори отворених викендом је у посебном',
			CityHcWeekendLink: 'чланку',
			CityHcCtaTitle: 'Потребна вам је клиника у вашој близини?',
			CityHcCtaText:
				'У каталогу можете филтрирати клинике по граду и језику — са мапом, цијенама и рецензијама.',

			// Будва
			CityHcTitle_budva:
				'Здравство у Будви: хитна помоћ, дом здравља и приватне клинике',
			CityHcDescription_budva:
				'Гдје потражити медицинску помоћ у Будви: хитна 124, Дом здравља Будва, туристичка амбуланта, приватне клинике и лабораторије, апотеке — практични водич.',
			CityHcOverview1_budva:
				'Будва је главни туристички град Црне Горе, па је медицинска инфраструктура прилагођена и мјештанима и сезонском приливу гостију. Главна државна установа је Дом здравља Будва, при којем раде служба хитне помоћи и сезонска туристичка амбуланта. Град нема сопствену државну болницу.',
			CityHcOverview2_budva:
				'Приватни сектор је добро развијен: поликлинике општег профила, лабораторије, неколико стоматолошких ординација, гинеколошка клиника и двије офталмолошке клинике са ласерском хирургијом ока — у многима се можете споразумјети на енглеском или руском.',
			CityHcEmergency1_budva:
				'Хитна помоћ у Будви налази се при Дому здравља и ради нон-стоп. Према искуствима из четова, прима и дјецу — са дјететом можете доћи директно.',
			CityHcEmergency2a_budva:
				'Код озбиљних повреда и стања која захтијевају хоспитализацију, пацијенти се из Будве упућују у ',
			CityHcEmergency2KotorLink_budva: 'болницу у Котору',
			CityHcEmergency2b_budva: ' (око пола сата вожње) или у ',
			CityHcEmergency2KccgLink_budva: 'Клинички центар Црне Горе',
			CityHcEmergency2c_budva: ' у Подгорици. Упут издаје љекар хитне помоћи.',
			CityHcState1_budva:
				'Дом здравља Будва је државна установа примарне заштите: изабрани доктори, педијатрија, лабораторија и интервенције. За власнике здравствене књижице прегледи су бесплатни или готово бесплатни.',
			CityHcState2_budva:
				'Љети при дому здравља ради туристичка амбуланта — прегледи уз плаћање за госте без књижице. Дом здравља организује и сезонску вакцинацију против грипа, као и повремене бесплатне акције, нпр. тестирање на ХИВ и хепатитисе. Међу љекарима има неколико који говоре руски, а неки и енглески.',
			CityHcState3_budva:
				'Планирана хоспитализација и специјалистичка помоћ иду истим путем — Котор или Подгорица — уз упут изабраног доктора. Судећи по специјалностима љекара, Општа болница Котор је вишеодјељенска установа: интерна медицина, општа хирургија, гинекологија и акушерство, радиологија, педијатрија, урологија и још неколико области.',
			CityHcStateCatalog_budva: 'Страница установе на docta.me — адреса, рецензије и услуге:',
			CityHcStateLink_budva: 'Дом Здравља Будва',
			CityHcPrivate1_budva:
				'Приватних клиника и лабораторија у Будви има много — од општих поликлиника и ланца лабораторија Moj Lab до стоматологије, гинекологије и офталмологије са ласерском хирургијом ока. Мање-више комплетан списак онога што је у нашем каталогу:',
			CityHcPvGroupLabel_Polyclinic: 'Поликлинике општег профила',
			CityHcPvMilmedika: 'Milmedika Budva',
			CityHcPvMojLab: 'Moj Lab Budva',
			CityHcPvBonoMedica: 'BonoMedica',
			CityHcPvMedicalCentar: 'Medical Centar Budva',
			CityHcPvGroupLabel_Dental: 'Стоматологије',
			CityHcPvDukley: 'Dukley Dental Clinic',
			CityHcPvReDent: 'ReDent',
			CityHcPvZecevic: 'Zečević Dental',
			CityHcPvGroupLabel_Ophthalmology:
				'Офталмологија, ласерска хирургија ока',
			CityHcPvLaserFocus: 'LaserFocus',
			CityHcPvSvjetlost: 'Svjetlost Eye Clinic',
			CityHcPvGroupLabel_Gynecology: 'Гинекологија',
			CityHcPvGroupLabel_Cardiology: 'Кардиологија',
			CityHcPvGroupLabel_Physiotherapy: 'Физиотерапија',
			CityHcPvGroupLabel_RussianDental:
				'Стоматологије са љекарима који говоре руски',
			CityHcPvGroupLabel_PolyclinicHospital: 'Поликлинике и болнице',
			CityHcPvGroupLabel_SurgicalHospital: 'Приватне болнице са хирургијом',
			CityHcPvGroupLabel_AestheticSurgery:
				'Пластична и естетска хирургија',
			CityHcPvHumana: 'Humana reprodukcija',
			CityHcPrivateCatalog_budva:
				'Актуелни списак са адресама, цијенама и рецензијама налази се у каталогу:',
			CityHcPrivateLink_budva: 'приватне клинике у Будви',
			CityHcLabs_budva:
				'Анализе можете урадити и без упута — уз плаћање, у било којој приватној лабораторији. Списак анализа са цијенама погледајте у секцији',
			CityHcLabsLink_budva: 'анализе у Будви',
			CityHcPharmacy1_budva:
				'Апотека у Будви има много, а у сезони већина ради сваког дана. Љекови на рецепт (прије свега антибиотици) формално се издају уз рецепт црногорског љекара — може га издати и љекар приватне клинике.',
			CityHcPharmacy2_budva:
				'Учесници четова помињу нон-стоп апотеку код аутобуске станице — то је BENU (Sportska Hala 11), која је и на званичном списку дежурних апотека Montefarma. Распоред се ипак може мијењати, провјерите на лицу мјеста; ноћу је у хитним ситуацијама поузданије отићи право у хитну помоћ.',
			CityHcCtaButton_budva: 'Клинике у Будви',

			// Подгорица
			CityHcTitle_podgorica:
				'Здравство у Подгорици: Клинички центар, хитна помоћ и приватне клинике',
			CityHcDescription_podgorica:
				'Медицинска помоћ у Подгорици: хитна 124, Клинички центар Црне Горе и Ургентни центар, дом здравља, приватне клинике и лабораторије, нон-стоп апотеке.',
			CityHcOverview1_podgorica:
				'Подгорица је медицинска пријестоница Црне Горе са најпотпунијом инфраструктуром у земљи. Кључна установа је Клинички центар Црне Горе (КЦЦГ), у који се упућују сложени пацијенти из цијеле земље. Ту су и дом здравља са пунктовима по разним дјеловима града, Институт за јавно здравље и Завод за трансфузију крви.',
			CityHcOverview2_podgorica:
				'Приватни сектор је највећи у земљи: вишеспецијалистичке клинике, приватне болнице са хирургијом, десеци лабораторија и стоматолошких ординација. Ако неку услугу не нађете у свом граду, највјероватније постоји у Подгорици.',
			CityHcEmergency1_podgorica:
				'Нон-стоп ургентну помоћ пружа Ургентни центар при Клиничком центру: у акутним стањима примају и без упута. Дјецу нон-стоп прима Институт за болести дјеце у кругу КЦЦГ.',
			CityHcEmergency2_podgorica:
				'Градска хитна помоћ такође ради нон-стоп и по потреби сама превози пацијента у Ургентни центар.',
			CityHcState1_podgorica:
				'Клинички центар Црне Горе је главна болница у земљи: хирургија, кардиологија, онкологија, породилиште и све уже специјалности. Планирана хоспитализација и консултације иду уз упут изабраног доктора по здравственој књижици; без књижице услуге се плаћају по цјеновнику.',
			CityHcState2_podgorica:
				'Дом здравља Подгорица је мрежа државних установа примарне заштите (неколико блокова по дјеловима града): општа медицина, педијатрија, лабораторија, центар за ментално здравље.',
			CityHcState3_podgorica:
				'Институт за јавно здравље бави се, између осталог, вакцинацијом, укључујући вакцине за путнике. Завод за трансфузију крви прима доноре и ради анализе крвних група.',
			CityHcStateCatalog_podgorica: 'Страница КЦЦГ на docta.me — одјељења, рецензије и услуге:',
			CityHcStateLink_podgorica: 'Клинички Центар Црне Горе',
			CityHcPrivate1_podgorica:
				'Подгорица има најшири избор приватне медицине у земљи — на примјер, Konzilijum има магнетну резонанцу и широк избор операција, а Ars Medica је велика хируршка и естетска болница. Ево главних установа по профилу (комплетан списак — десетине клиника — је у каталогу):',
			CityHcPvKonzilijum: 'Konzilijum',
			CityHcPvArsMedica: 'Ars Medica',
			CityHcPvMedtim: 'Medtim',
			CityHcPvCodraHospital: 'Codra Hospital',
			CityHcPvAMedic: 'A Medic',
			CityHcPvHipokratPg: 'Hipokrat',
			CityHcPvMojLabPg: 'Moj Lab',
			CityHcPvMilmedikaPg: 'Milmedika',
			CityHcPvFilipovicPg: 'Poliklinika Filipović',
			CityHcPrivateCatalog_podgorica:
				'Комплетан списак са цијенама и рецензијама је у каталогу:',
			CityHcPrivateLink_podgorica: 'приватне клинике у Подгорици',
			CityHcLabs_podgorica:
				'Анализе се раде приватно без упута у било којој лабораторији. Цијене и адресе су у секцији',
			CityHcLabsLink_podgorica: 'анализе у Подгорици',
			CityHcPharmacy1_podgorica:
				'У Подгорици постоје стотине апотека: државни ланац Montefarm и приватни ланци. Три раде нон-стоп: Montefarm „Крушевац" (Булевар Светог Петра Цетињског 45/а), BENU на Московској 22 и Holos 7 на Булевару октобарске револуције 31. Адресе и нон-стоп режим рада могу се промијенити — провјерите прије ноћне посјете.',
			CityHcPharmacy2_podgorica:
				'Многи љекови који се другдје продају слободно овдје траже рецепт црногорског љекара. Ако лијека нема, питајте за аналог по активној супстанци — комерцијални називи се често разликују.',
			CityHcCtaButton_podgorica: 'Клинике у Подгорици',

			// Котор
			CityHcTitle_kotor:
				'Здравство у Котору: општа болница, дом здравља и хитна помоћ',
			CityHcDescription_kotor:
				'Медицинска помоћ у Котору: хитна 124, Општа болница Котор која покрива цијелу Боку, Дом здравља Котор, специјална болница у Рисну, приватне лабораторије и апотеке.',
			CityHcOverview1_kotor:
				'Котор је медицински центар Боке Которске: ту се налази Општа болница Котор, која покрива цијело подручје залива, укључујући Тиват, Будву и Херцег Нови. Примарну заштиту пружа Дом здравља Котор са службом хитне помоћи.',
			CityHcOverview2_kotor:
				'У близини — у Рисану и Доброти — раде двије специјализоване државне болнице: једна за ортопедију, друга психијатријска. Приватни сектор у самом Котору је скромнији него у Будви или Подгорици, али нешто има: лабораторија, поликлинике, кардиологија и стоматологије.',
			CityHcEmergency1_kotor:
				'У хитним случајевима идите у хитну помоћ при Дому здравља Котор или директно на пријемно одјељење которске болнице: овамо се са приморја довозе повреде, дјечја ургентна стања и инфекције (болница има дјечје и инфективно одјељење).',
			CityHcEmergency2_kotor:
				'Имајте у виду: за странце без здравствене књижице и осигурања болничко лијечење се плаћа по цјеновнику, а рачуни за стационар могу бити високи. Ако имате полису, унапријед провјерите процедуру са осигуравачем; предрачун можете тражити прије почетка лијечења.',
			CityHcState1_kotor:
				'Општа болница Котор је вишеодјељенска установа која опслужује цијелу Боку Которску (Будву, Тиват, Херцег Нови). Судећи по саставу љекара, ту постоје одјељења интерне медицине, опште хирургије, гинекологије и акушерства, радиологије, педијатрије, урологије и инфективно одјељење, као и низ ужих специјалности.',
			CityHcState2_kotor:
				'Дом здравља Котор је државна установа примарне заштите: изабрани доктор, педијатар, лабораторија. Уз здравствену књижицу прегледи су бесплатни, а рецепте за љекове са листе издаје изабрани доктор.',
			CityHcState3a_kotor: 'Специјална болница ',
			CityHcState3VasoLink_kotor: '„Васо Чуковић"',
			CityHcState3b_kotor:
				' у Рисану (око пола сата дуж залива од Котора) — државни центар за ортопедију, неурохирургију и неурологију: овдје се упућују пацијенти из цијеле земље, не само са приморја. У Котору, у дијелу Доброта, налази се и специјална психијатријска болница ',
			CityHcState3DobrotaLink_kotor: '„Доброта"',
			CityHcState3c_kotor:
				' — једина специјализована психијатријска болница у Црној Гори (у другим градовима постоји само амбулантна психијатријска помоћ или одјељење у склопу опште болнице).',
			CityHcStateCatalog_kotor: 'Страница болнице на docta.me — одјељења, рецензије и услуге:',
			CityHcStateLink_kotor: 'Општа болница Котор',
			CityHcPrivate1_kotor:
				'Приватни сектор у самом Котору је мали: лабораторија, пар поликлиника, кардиолошка клиника, стоматологије и физиотерапија. За шири избор становници Котора обично иду у Будву или Подгорицу. Шта постоји на лицу мјеста — по нашем каталогу:',
			CityHcPvSmartMed: 'SmartMed Kotor',
			CityHcPvHipokratRadanovici: 'Hipokrat Radanovići',
			CityHcPvInterCardio: 'Inter Cardio',
			CityHcPvDentalStudioVucetic: 'Dental Studio Vučetić',
			CityHcPvDrCetkovic: 'Dr Ćetković',
			CityHcPvOrthoCentarKotor: 'Ortho Centar',
			CityHcPvEndorfinRadanovici: 'Endorfin Radanovići',
			CityHcPrivateCatalog_kotor:
				'Шта постоји у самом граду погледајте у каталогу:',
			CityHcPrivateLink_kotor: 'приватне клинике у Котору',
			CityHcLabs_kotor:
				'Приватне лабораторије примају анализе без упута. Списак са цијенама је у секцији',
			CityHcLabsLink_kotor: 'анализе у Котору',
			CityHcPharmacy1_kotor:
				'Апотеке раде у Старом граду и новијим дјеловима; у сезони је радно вријеме дуже. Нон-стоп апотеке у Котору можда нема — залиху сталних љекова држите код куће.',
			CityHcPharmacy2_kotor:
				'Ноћу се у акутној ситуацији обратите хитној помоћи или пријемном одјељењу болнице: тамо ће вас прегледати и дати прве љекове.',
			CityHcCtaButton_kotor: 'Клинике у Котору',

			// Бар
			CityHcTitle_bar:
				'Здравство у Бару: болница, дом здравља и приватне клинике',
			CityHcDescription_bar:
				'Медицинска помоћ у Бару: хитна 124, Дом здравља Бар у центру, Општа болница „Блажо Орландић" у Старом Бару, приватне клинике, лабораторије и апотеке.',
			CityHcOverview1_bar:
				'Бар има комплетан сет државног здравства: Дом здравља Бар (са службом хитне помоћи) у центру града и Општу болницу „Блажо Орландић" у Старом Бару — стационар који ради нон-стоп.',
			CityHcOverview2_bar:
				'Приватни сектор је примјетан: поликлинике, приватна дневна болница, лабораторије и много стоматолошких ординација. У Сутомору (општина Бар) ради приватна болница са CT-ом и магнетном резонанцом.',
			CityHcEmergency1_bar:
				'У хитном случају: хитна помоћ се налази при Дому здравља у центру Бара. Код повреда и стања која траже стационар можете ићи директно у болницу у Старом Бару — пријемно одјељење ради нон-стоп.',
			CityHcEmergency2_bar:
				'Шема из чета: прво хитна — тамо ће вас прегледати и по потреби дати упут за болницу; или право на пријемно одјељење болнице кад је очигледно да је потребан стационар.',
			CityHcState1_bar:
				'Општа болница „Блажо Орландић" је вишеспецијалистичка установа: хирургија, гинекологија са породилиштем, педијатрија, рендген и CT, физикална терапија. Уз здравствену књижицу лијечење је бесплатно; за остале се плаћа по цјеновнику.',
			CityHcState2_bar:
				'Дом здравља Бар је примарни ниво: изабрани доктор, педијатрија, лабораторија, вакцинација (укључујући неке вакцине за путнике). Неки љекари ту говоре руски или енглески — питајте приликом заказивања.',
			CityHcState3_bar:
				'Специјалистички прегледи којих нема у Бару раде се по упуту у Подгорици — Клинички центар је на око сат времена вожње.',
			CityHcStateCatalog_bar: 'Страница болнице на docta.me — одјељења, рецензије и услуге:',
			CityHcStateLink_bar: 'Општа болница „Блажо Орландић"',
			CityHcPrivate1_bar:
				'У Бару и Сутомору има неколико великих приватних клиника и лабораторија — на примјер, A3 Medical у Сутомору ради CT и магнетну резонанцу, и бесплатно обезбјеђује преводиоца (руски, енглески) за преглед. Бар има посебно много стоматолошких ординација, укључујући оне са љекарима који говоре руски; има и ОРЛ, урологију и гинекологију. Мање-више комплетан списак, по нашем каталогу:',
			CityHcPvNoviStandardBar: 'Novi Standard',
			CityHcPvDrZejnilovic: 'Dr Zejnilović',
			CityHcPvMedicalVranes: 'Medical Vraneš',
			CityHcPvA3Medical: 'A3 Medical',
			CityHcPvJustDental: 'Just Dental',
			CityHcPvPavlinDental: 'Pavlin',
			CityHcPvDrDebelja: 'Dr Debelja',
			CityHcPvGroupLabel_OtherDental: 'Остале стоматологије',
			CityHcPvBuntic: 'Buntić',
			CityHcPvDrSimonovic: 'Dr Simonović',
			CityHcPvDrBajagic: 'Dr Bajagić',
			CityHcPvDrZejak: 'Dr Zejak',
			CityHcPvGacina: 'Gaćina',
			CityHcPvJovoticDent: 'Jovetić Dent',
			CityHcPvCicmil: 'Cicmil',
			CityHcPrivateCatalog_bar:
				'Комплетан списак са цијенама и рецензијама је у каталогу:',
			CityHcPrivateLink_bar: 'приватне клинике у Бару',
			CityHcLabs_bar:
				'Анализе се примају без упута у приватним лабораторијама. Списак са цијенама је у секцији',
			CityHcLabsLink_bar: 'анализе у Бару',
			CityHcPharmacy1_bar: 'Апотеке су распоређене по центру и Шушњу.',
			CityHcLenapharmText_bar: 'Учесници чета посебно често препоручују апотеку',
			CityHcLenapharmAfter_bar: 'у Шушњу — тамо одговарају и на руском.',
			CityHcPharmacy2_bar:
				'Нон-стоп апотеке можда нема — ноћу се обратите хитној помоћи или пријемном одјељењу болнице. Љекови на рецепт издају се уз рецепт црногорског љекара.',
			CityHcCtaButton_bar: 'Клинике у Бару',
		},
		'de': {
			// Gemeinsam
			'CityHcToc_overview': 'Was die Stadt bietet',
			'CityHcToc_emergency': 'Notfallversorgung',
			'CityHcToc_state': 'Staatliche Medizin',
			'CityHcToc_private': 'Private Kliniken und Labore',
			'CityHcToc_pharmacies': 'Apotheken und Notdienste',
			CityHcEmergencyShared:
				'Die landesweite Notrufnummer für den Rettungsdienst in Montenegro ist 124. Die Disponenten sprechen Montenegrinisch und verstehen meist einfaches Englisch. Der Rettungsdienst fährt vor allem zu schweren Fällen raus: Wenn der Zustand es erlaubt, ist es oft schneller, selbst zur Notaufnahme (hitna pomoć) zu fahren.',
			CityHcLinkEnd: '.',
			CityHcWeekendText:
				'Eine vollständige Liste der am Wochenende geöffneten Apotheken und Kliniken in Montenegro finden Sie in einem eigenen',
			CityHcWeekendLink: 'Artikel',
			CityHcCtaTitle: 'Brauchen Sie eine Klinik in Ihrer Nähe?',
			CityHcCtaText:
				'Im Katalog können Sie Kliniken nach Stadt und Sprache filtern — mit Karte, Preisen und Bewertungen.',

			// Budva
			CityHcTitle_budva:
				'Medizin in Budva: Notfallhilfe, Dom zdravlja und Privatkliniken',
			CityHcDescription_budva:
				'Wo Sie in Budva medizinische Hilfe bekommen: Notruf 124, Dom zdravlja Budva, Touristenambulanz, Privatkliniken und Labore, Apotheken — ein praktischer Leitfaden.',
			CityHcOverview1_budva:
				'Budva ist Montenegros wichtigster Urlaubsort, und die medizinische Infrastruktur ist auf Einheimische wie auf den saisonalen Gästestrom ausgelegt. Die zentrale staatliche Einrichtung ist das Dom zdravlja Budva (Gesundheitszentrum) mit Rettungsdienst und saisonaler Touristenambulanz. Ein eigenes staatliches Krankenhaus hat die Stadt nicht.',
			CityHcOverview2_budva:
				'Der Privatsektor ist gut entwickelt: allgemeinmedizinische Polikliniken, Labore, mehrere Zahnarztpraxen, eine gynäkologische Klinik und zwei Augenkliniken mit Laser-Augenchirurgie — in vielen wird Englisch oder Russisch gesprochen.',
			CityHcEmergency1_budva:
				'Die Notaufnahme (hitna pomoć) in Budva befindet sich am Dom zdravlja und arbeitet rund um die Uhr. Nach Berichten aus Expat-Chats werden dort auch Kinder behandelt — mit einem Kind können Sie direkt hinfahren.',
			CityHcEmergency2a_budva:
				'Bei schweren Verletzungen und stationär zu behandelnden Zuständen werden Patienten aus Budva ins ',
			CityHcEmergency2KotorLink_budva: 'Krankenhaus Kotor',
			CityHcEmergency2b_budva: ' (etwa eine halbe Stunde) oder ins ',
			CityHcEmergency2KccgLink_budva: 'Klinische Zentrum Montenegros',
			CityHcEmergency2c_budva:
				' in Podgorica überwiesen. Die Überweisung (uputnica) stellt der Arzt der hitna pomoć aus.',
			CityHcState1_budva:
				'Das Dom zdravlja Budva ist das staatliche Gesundheitszentrum: Hausärzte (izabrani doktor), Pädiatrie, Labor und Behandlungsräume. Für Inhaber der Gesundheitskarte zdravstvena knjižica sind Besuche kostenlos oder fast kostenlos.',
			CityHcState2_budva:
				'Im Sommer arbeitet dort eine Touristenambulanz (turistička ambulanta) — kostenpflichtige Termine für Gäste ohne Gesundheitskarte. Außerdem gibt es saisonale Grippeimpfungen und gelegentlich kostenlose Aktionen, etwa HIV- und Hepatitis-Tests. Einige Ärzte dort sprechen Russisch, manche auch Englisch.',
			CityHcState3_budva:
				'Geplante Krankenhausaufenthalte und Facharztbehandlungen laufen über denselben Weg — Kotor oder Podgorica — mit Überweisung des gewählten Arztes. Nach den Fachrichtungen des Personals zu urteilen, ist das Allgemeine Krankenhaus Kotor eine Einrichtung mit mehreren Abteilungen: Innere Medizin, Allgemeinchirurgie, Gynäkologie und Geburtshilfe, Radiologie, Pädiatrie, Urologie und weitere Fachbereiche.',
			CityHcStateCatalog_budva: 'Die Seite der Einrichtung auf docta.me — Adresse, Bewertungen und Leistungen:',
			CityHcStateLink_budva: 'Dom Zdravlja Budva',
			CityHcPrivate1_budva:
				'Private Kliniken und Labore gibt es in Budva viele — von allgemeinen Polikliniken und der Laborkette Moj Lab bis zu Zahnmedizin, Gynäkologie und Augenheilkunde mit Laser-Augenchirurgie. Eine mehr oder weniger vollständige Liste dessen, was in unserem Katalog steht:',
			CityHcPvGroupLabel_Polyclinic: 'Allgemeine Polikliniken',
			CityHcPvMilmedika: 'Milmedika Budva',
			CityHcPvMojLab: 'Moj Lab Budva',
			CityHcPvBonoMedica: 'BonoMedica',
			CityHcPvMedicalCentar: 'Medical Centar Budva',
			CityHcPvGroupLabel_Dental: 'Zahnkliniken',
			CityHcPvDukley: 'Dukley Dental Clinic',
			CityHcPvReDent: 'ReDent',
			CityHcPvZecevic: 'Zečević Dental',
			CityHcPvGroupLabel_Ophthalmology: 'Augenheilkunde, Laser-Augenchirurgie',
			CityHcPvLaserFocus: 'LaserFocus',
			CityHcPvSvjetlost: 'Svjetlost Eye Clinic',
			CityHcPvGroupLabel_Gynecology: 'Gynäkologie',
			CityHcPvGroupLabel_Cardiology: 'Kardiologie',
			CityHcPvGroupLabel_Physiotherapy: 'Physiotherapie',
			CityHcPvGroupLabel_RussianDental:
				'Zahnkliniken mit russischsprachigen Ärzten',
			CityHcPvGroupLabel_PolyclinicHospital: 'Polikliniken und Krankenhäuser',
			CityHcPvGroupLabel_SurgicalHospital: 'Privatkliniken mit Chirurgie',
			CityHcPvGroupLabel_AestheticSurgery:
				'Plastische und ästhetische Chirurgie',
			CityHcPvHumana: 'Humana reprodukcija',
			CityHcPrivateCatalog_budva:
				'Die aktuelle Liste mit Adressen, Preisen und Bewertungen finden Sie im Katalog:',
			CityHcPrivateLink_budva: 'Privatkliniken in Budva',
			CityHcLabs_budva:
				'Analysen sind auch ohne ärztliche Überweisung möglich — kostenpflichtig in jedem privaten Labor. Die Liste der Tests mit Preisen finden Sie im Bereich',
			CityHcLabsLink_budva: 'Laboranalysen in Budva',
			CityHcPharmacy1_budva:
				'Apotheken gibt es in Budva viele, in der Saison arbeiten die meisten täglich. Verschreibungspflichtige Medikamente (vor allem Antibiotika) erfordern formal ein Rezept eines montenegrinischen Arztes — auch ein Arzt einer Privatklinik kann es ausstellen.',
			CityHcPharmacy2_budva:
				'Chat-Teilnehmer verweisen auf eine 24-Stunden-Apotheke am Busbahnhof — die BENU (Sportska Hala 11), die auch auf Montefarms offizieller Notdienstliste steht. Die Zeiten können sich trotzdem ändern, fragen Sie vor Ort nach; nachts ist es im Akutfall zuverlässiger, direkt zur hitna pomoć zu fahren.',
			CityHcCtaButton_budva: 'Kliniken in Budva',

			// Podgorica
			CityHcTitle_podgorica:
				'Medizin in Podgorica: Klinisches Zentrum, Notfallhilfe und Privatkliniken',
			CityHcDescription_podgorica:
				'Medizinische Hilfe in Podgorica: Notruf 124, das Klinische Zentrum Montenegros mit Urgentni centar, Dom zdravlja, Privatkliniken und Labore, 24-Stunden-Apotheken.',
			CityHcOverview1_podgorica:
				'Podgorica ist die medizinische Hauptstadt Montenegros mit der vollständigsten Infrastruktur des Landes. Die wichtigste Einrichtung ist das Klinische Zentrum Montenegros (KCCG), an das komplexe Patienten aus dem ganzen Land überwiesen werden. Dazu kommen das Dom zdravlja mit Zweigstellen in verschiedenen Stadtteilen, das Institut für öffentliche Gesundheit und das Institut für Bluttransfusion.',
			CityHcOverview2_podgorica:
				'Der private Sektor ist der größte des Landes: Kliniken mit vielen Fachrichtungen, Privatkrankenhäuser mit Chirurgie, Dutzende Labore und Zahnarztpraxen. Was Sie in Ihrer Stadt nicht finden, gibt es höchstwahrscheinlich in Podgorica.',
			CityHcEmergency1_podgorica:
				'Die Notfallversorgung rund um die Uhr übernimmt das Urgentni centar am Klinischen Zentrum: In akuten Fällen wird man ohne Überweisung angenommen. Kinder behandelt rund um die Uhr das Institut für Kinderkrankheiten auf dem KCCG-Gelände.',
			CityHcEmergency2_podgorica:
				'Der städtische Rettungsdienst (hitna pomoć) arbeitet ebenfalls rund um die Uhr und bringt Patienten bei Bedarf selbst ins Urgentni centar.',
			CityHcState1_podgorica:
				'Das Klinische Zentrum Montenegros ist das wichtigste Krankenhaus des Landes: Chirurgie, Kardiologie, Onkologie, Geburtsstation und alle Spezialgebiete. Geplante Krankenhausaufenthalte und Konsultationen erfordern eine Überweisung des gewählten Arztes über die Gesundheitskarte; ohne Karte sind die Leistungen nach Preisliste kostenpflichtig.',
			CityHcState2_podgorica:
				'Das Dom zdravlja Podgorica ist ein Netz staatlicher Gesundheitszentren (mehrere Blöcke in verschiedenen Stadtteilen): Allgemeinmedizin, Pädiatrie, Labor, Zentrum für psychische Gesundheit.',
			CityHcState3_podgorica:
				'Das Institut für öffentliche Gesundheit (Institut za javno zdravlje) übernimmt unter anderem Impfungen, einschließlich Reiseimpfungen. Das Institut für Bluttransfusion (Zavod za transfuziju krvi) nimmt Spender an und bestimmt Blutgruppen.',
			CityHcStateCatalog_podgorica: 'Die Seite des KCCG auf docta.me — Abteilungen, Bewertungen und Leistungen:',
			CityHcStateLink_podgorica: 'Klinički Centar Crne Gore',
			CityHcPrivate1_podgorica:
				'Podgorica hat die größte Auswahl an privater Medizin im Land — Konzilijum bietet beispielsweise MRT und eine breite Auswahl an Operationen, und Ars Medica ist ein großes chirurgisch-ästhetisches Krankenhaus. Hier die wichtigsten Einrichtungen nach Profil (die vollständige Liste — Dutzende Kliniken — finden Sie im Katalog):',
			CityHcPvKonzilijum: 'Konzilijum',
			CityHcPvArsMedica: 'Ars Medica',
			CityHcPvMedtim: 'Medtim',
			CityHcPvCodraHospital: 'Codra Hospital',
			CityHcPvAMedic: 'A Medic',
			CityHcPvHipokratPg: 'Hipokrat',
			CityHcPvMojLabPg: 'Moj Lab',
			CityHcPvMilmedikaPg: 'Milmedika',
			CityHcPvFilipovicPg: 'Poliklinika Filipović',
			CityHcPrivateCatalog_podgorica:
				'Die vollständige Liste mit Preisen und Bewertungen finden Sie im Katalog:',
			CityHcPrivateLink_podgorica: 'Privatkliniken in Podgorica',
			CityHcLabs_podgorica:
				'Analysen sind ohne Überweisung in jedem privaten Labor möglich. Preise und Adressen finden Sie im Bereich',
			CityHcLabsLink_podgorica: 'Laboranalysen in Podgorica',
			CityHcPharmacy1_podgorica:
				'In Podgorica gibt es Hunderte Apotheken: die staatliche Kette Montefarm und private Ketten. Drei sind rund um die Uhr geöffnet: Montefarm „Kruševac" (Bulevar Svetog Petra Cetinjskog 45/a), BENU in der Moskovska 22 und Holos 7 im Bulevar Oktobarske Revolucije 31. Adressen und der 24-Stunden-Betrieb können sich ändern — vor einem späten Besuch bitte bestätigen.',
			CityHcPharmacy2_podgorica:
				'Viele anderswo frei verkäufliche Medikamente erfordern hier ein montenegrinisches Rezept. Ist ein Medikament nicht vorrätig, fragen Sie nach einem Analogon nach Wirkstoff — die Handelsnamen unterscheiden sich oft.',
			CityHcCtaButton_podgorica: 'Kliniken in Podgorica',

			// Kotor
			CityHcTitle_kotor:
				'Medizin in Kotor: Allgemeines Krankenhaus, Dom zdravlja und Notfallhilfe',
			CityHcDescription_kotor:
				'Medizinische Hilfe in Kotor: Notruf 124, das Allgemeine Krankenhaus Kotor für die ganze Boka-Bucht, Dom zdravlja Kotor, die Spezialklinik in Risan, private Labore und Apotheken.',
			CityHcOverview1_kotor:
				'Kotor ist das medizinische Zentrum der Bucht von Kotor: Hier befindet sich das Allgemeine Krankenhaus Kotor (Opšta bolnica Kotor), das die gesamte Küstenregion einschließlich Tivat, Budva und Herceg Novi versorgt. Die Grundversorgung übernimmt das Dom zdravlja Kotor mit Rettungsdienst.',
			CityHcOverview2_kotor:
				'In der Nähe — in Risan und Dobrota — gibt es zwei spezialisierte staatliche Krankenhäuser: eines für Orthopädie, eines für Psychiatrie. Der Privatsektor in Kotor selbst ist kleiner als in Budva oder Podgorica, aber es gibt einiges: ein Labor, Polikliniken, eine Kardiologie- und Zahnkliniken.',
			CityHcEmergency1_kotor:
				'Im Notfall: hitna pomoć am Dom zdravlja Kotor oder direkt die Aufnahme des Krankenhauses Kotor — hierhin werden Verletzungen, pädiatrische Notfälle und Infektionen von der ganzen Küste gebracht (das Krankenhaus hat eine Kinder- und eine Infektionsabteilung).',
			CityHcEmergency2_kotor:
				'Beachten Sie: Für Ausländer ohne Gesundheitskarte und Versicherung ist die Krankenhausbehandlung nach Preisliste kostenpflichtig, und stationäre Rechnungen können erheblich sein. Mit einer Police klären Sie das Vorgehen vorab mit dem Versicherer; einen Kostenvoranschlag können Sie vor Behandlungsbeginn verlangen.',
			CityHcState1_kotor:
				'Das Allgemeine Krankenhaus Kotor ist eine Einrichtung mit mehreren Abteilungen, die die gesamte Bucht von Kotor versorgt (Budva, Tivat, Herceg Novi). Nach der Zusammensetzung des Personals zu urteilen, gibt es Abteilungen für Innere Medizin, Allgemeinchirurgie, Gynäkologie und Geburtshilfe, Radiologie, Pädiatrie, Urologie und Infektionskrankheiten sowie mehrere engere Fachbereiche.',
			CityHcState2_kotor:
				'Das Dom zdravlja Kotor ist das staatliche Gesundheitszentrum: gewählter Arzt, Kinderarzt, Labor. Mit der Gesundheitskarte sind Besuche kostenlos; Rezepte für subventionierte Medikamente stellt der gewählte Arzt aus.',
			CityHcState3a_kotor: 'Das Spezialkrankenhaus ',
			CityHcState3VasoLink_kotor: '„Vaso Ćuković"',
			CityHcState3b_kotor:
				' in Risan (etwa eine halbe Stunde entlang der Bucht von Kotor) ist das landesweite Zentrum für Orthopädie, Neurochirurgie und Neurologie — Patienten werden von überall im Land hierher überwiesen, nicht nur von der Küste. In Kotor, im Stadtteil Dobrota, befindet sich außerdem das spezialisierte psychiatrische Krankenhaus ',
			CityHcState3DobrotaLink_kotor: '„Dobrota"',
			CityHcState3c_kotor:
				' — das einzige spezialisierte psychiatrische Krankenhaus Montenegros (in anderen Städten gibt es nur ambulante psychiatrische Versorgung oder eine Abteilung innerhalb eines Allgemeinkrankenhauses).',
			CityHcStateCatalog_kotor: 'Die Seite des Krankenhauses auf docta.me — Abteilungen, Bewertungen und Leistungen:',
			CityHcStateLink_kotor: 'Opšta bolnica Kotor',
			CityHcPrivate1_kotor:
				'Der Privatsektor in Kotor selbst ist klein: ein Labor, ein paar Polikliniken, eine Kardiologieklinik, Zahnarztpraxen und Physiotherapie. Für eine größere Auswahl fahren Einwohner Kotors meist nach Budva oder Podgorica. Was es vor Ort gibt, laut unserem Katalog:',
			CityHcPvSmartMed: 'SmartMed Kotor',
			CityHcPvHipokratRadanovici: 'Hipokrat Radanovići',
			CityHcPvInterCardio: 'Inter Cardio',
			CityHcPvDentalStudioVucetic: 'Dental Studio Vučetić',
			CityHcPvDrCetkovic: 'Dr Ćetković',
			CityHcPvOrthoCentarKotor: 'Ortho Centar',
			CityHcPvEndorfinRadanovici: 'Endorfin Radanovići',
			CityHcPrivateCatalog_kotor:
				'Was es in der Stadt selbst gibt, sehen Sie im Katalog:',
			CityHcPrivateLink_kotor: 'Privatkliniken in Kotor',
			CityHcLabs_kotor:
				'Private Labore nehmen Analysen ohne Überweisung an. Die Liste mit Preisen finden Sie im Bereich',
			CityHcLabsLink_kotor: 'Laboranalysen in Kotor',
			CityHcPharmacy1_kotor:
				'Apotheken gibt es in der Altstadt und in den neueren Vierteln; in der Saison sind die Öffnungszeiten länger. Eine 24-Stunden-Apotheke gibt es in Kotor möglicherweise nicht — halten Sie einen Vorrat Ihrer Dauermedikamente zu Hause.',
			CityHcPharmacy2_kotor:
				'Nachts wenden Sie sich im Akutfall an die hitna pomoć oder die Krankenhausaufnahme: Dort werden Sie untersucht und erhalten die ersten Medikamente.',
			CityHcCtaButton_kotor: 'Kliniken in Kotor',

			// Bar
			CityHcTitle_bar:
				'Medizin in Bar: Krankenhaus, Dom zdravlja und Privatkliniken',
			CityHcDescription_bar:
				'Medizinische Hilfe in Bar: Notruf 124, Dom zdravlja Bar im Zentrum, das Krankenhaus Blažo Orlandić in Stari Bar, Privatkliniken, Labore und Apotheken.',
			CityHcOverview1_bar:
				'Bar verfügt über das komplette Angebot staatlicher Medizin: das Dom zdravlja Bar (Gesundheitszentrum mit Rettungsdienst) im Stadtzentrum und das Allgemeine Krankenhaus Blažo Orlandić in Stari Bar — ein rund um die Uhr arbeitendes Krankenhaus.',
			CityHcOverview2_bar:
				'Der private Sektor ist beachtlich: Polikliniken, eine private Tagesklinik, Labore und viele Zahnarztpraxen. In Sutomore (Gemeinde Bar) arbeitet ein privates Krankenhaus mit CT und MRT.',
			CityHcEmergency1_bar:
				'Im Notfall: Die hitna pomoć befindet sich am Dom zdravlja im Zentrum von Bar. Bei Verletzungen und stationär zu behandelnden Zuständen können Sie direkt ins Krankenhaus in Stari Bar fahren — die Aufnahme arbeitet rund um die Uhr.',
			CityHcEmergency2_bar:
				'Das im Chat geteilte Schema: zuerst zur hitna — dort wird man untersucht und bei Bedarf ans Krankenhaus überwiesen; oder direkt zur Krankenhausaufnahme, wenn offensichtlich stationäre Behandlung nötig ist.',
			CityHcState1_bar:
				'Das Allgemeine Krankenhaus Blažo Orlandić ist ein Haus mit vielen Fachabteilungen: Chirurgie, Gynäkologie mit Geburtsstation, Pädiatrie, Röntgen und CT, Physiotherapie. Mit der Gesundheitskarte ist die Behandlung kostenlos, sonst nach Preisliste.',
			CityHcState2_bar:
				'Das Dom zdravlja Bar ist die Grundversorgung: gewählter Arzt, Pädiatrie, Labor, Impfungen (einschließlich einiger Reiseimpfungen). Einige Ärzte dort sprechen Russisch oder Englisch — fragen Sie bei der Terminvereinbarung.',
			CityHcState3_bar:
				'Spezialuntersuchungen, die es in Bar nicht gibt, werden per Überweisung in Podgorica gemacht — das Klinische Zentrum ist rund eine Stunde entfernt.',
			CityHcStateCatalog_bar: 'Die Seite des Krankenhauses auf docta.me — Abteilungen, Bewertungen und Leistungen:',
			CityHcStateLink_bar: 'Opšta Bolnica „Blažo Orlandić"',
			CityHcPrivate1_bar:
				'In Bar und Sutomore gibt es mehrere größere Privatkliniken und Labore — zum Beispiel bietet A3 Medical in Sutomore CT und MRT an und stellt kostenlos einen Dolmetscher (Russisch, Englisch) für den Termin. Bar hat besonders viele Zahnkliniken, darunter auch russischsprachige; außerdem gibt es HNO, Urologie und Gynäkologie. Eine mehr oder weniger vollständige Liste, laut unserem Katalog:',
			CityHcPvNoviStandardBar: 'Novi Standard',
			CityHcPvDrZejnilovic: 'Dr Zejnilović',
			CityHcPvMedicalVranes: 'Medical Vraneš',
			CityHcPvA3Medical: 'A3 Medical',
			CityHcPvJustDental: 'Just Dental',
			CityHcPvPavlinDental: 'Pavlin',
			CityHcPvDrDebelja: 'Dr Debelja',
			CityHcPvGroupLabel_OtherDental: 'Weitere Zahnkliniken',
			CityHcPvBuntic: 'Buntić',
			CityHcPvDrSimonovic: 'Dr Simonović',
			CityHcPvDrBajagic: 'Dr Bajagić',
			CityHcPvDrZejak: 'Dr Zejak',
			CityHcPvGacina: 'Gaćina',
			CityHcPvJovoticDent: 'Jovetić Dent',
			CityHcPvCicmil: 'Cicmil',
			CityHcPrivateCatalog_bar:
				'Die vollständige Liste mit Preisen und Bewertungen finden Sie im Katalog:',
			CityHcPrivateLink_bar: 'Privatkliniken in Bar',
			CityHcLabs_bar:
				'Analysen werden in privaten Laboren ohne Überweisung angenommen. Die Liste mit Preisen finden Sie im Bereich',
			CityHcLabsLink_bar: 'Laboranalysen in Bar',
			CityHcPharmacy1_bar: 'Apotheken verteilen sich über das Zentrum und Šušanj.',
			CityHcLenapharmText_bar: 'Chat-Teilnehmer empfehlen besonders oft die Apotheke',
			CityHcLenapharmAfter_bar: 'in Šušanj — dort wird auch auf Russisch geantwortet.',
			CityHcPharmacy2_bar:
				'Eine 24-Stunden-Apotheke gibt es möglicherweise nicht — nachts wenden Sie sich an die hitna pomoć oder die Krankenhausaufnahme. Verschreibungspflichtige Medikamente gibt es gegen Rezept eines montenegrinischen Arztes.',
			CityHcCtaButton_bar: 'Kliniken in Bar',
		},
		'tr': {
			// Ortak
			'CityHcToc_overview': 'Şehirde neler var',
			'CityHcToc_emergency': 'Acil yardım',
			'CityHcToc_state': 'Devlet sağlık hizmetleri',
			'CityHcToc_private': 'Özel klinikler ve laboratuvarlar',
			'CityHcToc_pharmacies': 'Eczaneler ve nöbetçi hizmetler',
			CityHcEmergencyShared:
				"Karadağ'da ambulansın ülke çapındaki numarası 124'tür. Operatörler Karadağca konuşur, genellikle temel İngilizceyi anlar. Ambulans çoğunlukla ağır vakalara çıkar: durumunuz elveriyorsa, acil servise (hitna pomoć) kendi imkanınızla gitmek çoğu zaman daha hızlıdır.",
			CityHcLinkEnd: '.',
			CityHcWeekendText:
				"Karadağ genelinde hafta sonu açık eczane ve kliniklerin tam listesi ayrı bir",
			CityHcWeekendLink: 'makalede',
			CityHcCtaTitle: 'Yakınınızda bir klinik mi arıyorsunuz?',
			CityHcCtaText:
				'Katalogda klinikleri şehre ve dile göre filtreleyebilirsiniz — harita, fiyatlar ve yorumlarla.',

			// Budva
			CityHcTitle_budva:
				"Budva'da sağlık hizmetleri: acil yardım, Dom zdravlja ve özel klinikler",
			CityHcDescription_budva:
				"Budva'da tıbbi yardım nereden alınır: ambulans 124, Dom zdravlja Budva, turist polikliniği, özel klinikler ve laboratuvarlar, eczaneler — pratik rehber.",
			CityHcOverview1_budva:
				"Budva, Karadağ'ın başlıca turizm şehridir; sağlık altyapısı hem yerel halka hem de sezonluk ziyaretçi akışına göre kurulmuştur. Temel devlet kurumu, acil yardım servisi ve sezonluk turist polikliniğinin (turistička ambulanta) bulunduğu Dom zdravlja Budva'dır. Şehrin kendi devlet hastanesi yoktur.",
			CityHcOverview2_budva:
				"Özel sektör oldukça gelişmiştir: genel poliklinikler, laboratuvarlar, birkaç diş kliniği, bir jinekoloji kliniği ve lazer göz cerrahisi sunan iki göz kliniği bulunur — birçoğunda İngilizce veya Rusça konuşulur.",
			CityHcEmergency1_budva:
				"Budva'daki acil servis (hitna pomoć) Dom zdravlja binasındadır ve gece gündüz çalışır. Sohbet gruplarındaki deneyimlere göre çocuklar da kabul edilir — çocuğunuzla doğrudan gidebilirsiniz.",
			CityHcEmergency2a_budva:
				"Ciddi yaralanmalarda ve hastane yatışı gerektiren durumlarda hastalar Budva'dan ",
			CityHcEmergency2KotorLink_budva: "Kotor'daki hastaneye",
			CityHcEmergency2b_budva: ' (yaklaşık yarım saat) veya ',
			CityHcEmergency2KccgLink_budva: "Podgorica'daki Karadağ Klinik Merkezi'ne",
			CityHcEmergency2c_budva:
				' sevk edilir. Sevk belgesini (uputnica) hitna pomoć doktoru verir.',
			CityHcState1_budva:
				'Dom zdravlja Budva devlet birinci basamak merkezidir: aile hekimleri (izabrani doktor), pediatri, laboratuvar ve müdahale odaları. Sağlık kartı (zdravstvena knjižica) sahipleri için muayeneler ücretsiz veya sembolik ücretlidir.',
			CityHcState2_budva:
				'Yazın burada turist polikliniği çalışır — kartı olmayan ziyaretçiler için ücretli muayene. Dom zdravlja ayrıca mevsimlik grip aşısı ve zaman zaman HIV ile hepatit testi gibi ücretsiz kampanyalar düzenler. Doktorlardan bazıları Rusça, bazıları da İngilizce konuşur.',
			CityHcState3_budva:
				"Planlı hastane yatışı ve uzman bakımı da aynı yolu izler — Kotor veya Podgorica — seçili doktorun sevkiyle. Hekim kadrosunun uzmanlıklarına bakılırsa, Kotor Genel Hastanesi çok bölümlü bir kurumdur: iç hastalıkları, genel cerrahi, kadın hastalıkları ve doğum, radyoloji, pediatri, üroloji ve birkaç başka alan.",
			CityHcStateCatalog_budva: "Kurumun docta.me'deki sayfası — adres, yorumlar ve hizmetler:",
			CityHcStateLink_budva: 'Dom Zdravlja Budva',
			CityHcPrivate1_budva:
				"Budva'da çok sayıda özel klinik ve laboratuvar vardır — genel polikliniklerden ve Moj Lab laboratuvar zincirinden diş hekimliği, jinekoloji ve lazer göz cerrahisi sunan göz kliniklerine kadar. Kataloğumuzdaki aşağı yukarı eksiksiz liste:",
			CityHcPvGroupLabel_Polyclinic: 'Genel poliklinikler',
			CityHcPvMilmedika: 'Milmedika Budva',
			CityHcPvMojLab: 'Moj Lab Budva',
			CityHcPvBonoMedica: 'BonoMedica',
			CityHcPvMedicalCentar: 'Medical Centar Budva',
			CityHcPvGroupLabel_Dental: 'Diş klinikleri',
			CityHcPvDukley: 'Dukley Dental Clinic',
			CityHcPvReDent: 'ReDent',
			CityHcPvZecevic: 'Zečević Dental',
			CityHcPvGroupLabel_Ophthalmology: 'Göz hastalıkları, lazer göz cerrahisi',
			CityHcPvLaserFocus: 'LaserFocus',
			CityHcPvSvjetlost: 'Svjetlost Eye Clinic',
			CityHcPvGroupLabel_Gynecology: 'Jinekoloji',
			CityHcPvGroupLabel_Cardiology: 'Kardiyoloji',
			CityHcPvGroupLabel_Physiotherapy: 'Fizyoterapi',
			CityHcPvGroupLabel_RussianDental:
				'Rusça konuşan doktorlarla diş klinikleri',
			CityHcPvGroupLabel_PolyclinicHospital: 'Poliklinikler ve hastaneler',
			CityHcPvGroupLabel_SurgicalHospital: 'Cerrahi sunan özel hastaneler',
			CityHcPvGroupLabel_AestheticSurgery: 'Plastik ve estetik cerrahi',
			CityHcPvHumana: 'Humana reprodukcija',
			CityHcPrivateCatalog_budva:
				'Adresler, fiyatlar ve yorumlarla güncel liste katalogda:',
			CityHcPrivateLink_budva: "Budva'daki özel klinikler",
			CityHcLabs_budva:
				'Tahlilleri doktor sevki olmadan da — ücretli olarak herhangi bir özel laboratuvarda — yaptırabilirsiniz. Fiyatlarıyla tahlil listesi şu bölümde:',
			CityHcLabsLink_budva: "Budva'da tahliller",
			CityHcPharmacy1_budva:
				"Budva'da çok eczane vardır; sezonda çoğu her gün açıktır. Reçeteli ilaçlar (özellikle antibiyotikler) resmen Karadağlı bir doktorun reçetesiyle satılır — özel klinik doktoru da yazabilir.",
			CityHcPharmacy2_budva:
				"Sohbet üyeleri otogar yakınındaki 24 saat açık eczaneden söz ediyor — bu, Montefarm'ın resmi nöbetçi listesinde de yer alan BENU (Sportska Hala 11). Yine de saatler değişebilir, yerinde teyit edin; gece acil durumda doğrudan hitna pomoć'a gitmek daha güvenilirdir.",
			CityHcCtaButton_budva: 'Budva klinikleri',

			// Podgorica
			CityHcTitle_podgorica:
				"Podgorica'da sağlık hizmetleri: Klinik Merkez, acil yardım ve özel klinikler",
			CityHcDescription_podgorica:
				"Podgorica'da tıbbi yardım: ambulans 124, Karadağ Klinik Merkezi ve Acil Merkezi, Dom zdravlja, özel klinikler ve laboratuvarlar, nöbetçi eczaneler.",
			CityHcOverview1_podgorica:
				"Podgorica, ülkenin en eksiksiz altyapısına sahip Karadağ'ın tıp başkentidir. Temel kurum, ülkenin her yerinden karmaşık vakaların sevk edildiği Karadağ Klinik Merkezi'dir (KCCG). Şehirde ayrıca farklı semtlerde şubeleri olan Dom zdravlja, Halk Sağlığı Enstitüsü ve Kan Transfüzyonu Enstitüsü bulunur.",
			CityHcOverview2_podgorica:
				"Özel sektör ülkenin en büyüğüdür: çok branşlı klinikler, cerrahi yapılan özel hastaneler, onlarca laboratuvar ve diş kliniği. Kendi şehrinizde bulamadığınız hizmet büyük olasılıkla Podgorica'da vardır.",
			CityHcEmergency1_podgorica:
				"Kesintisiz acil bakımı Klinik Merkez'deki Acil Merkezi (Urgentni centar) sağlar: akut durumlarda sevksiz kabul edilirsiniz. Çocuklara KCCG yerleşkesindeki Çocuk Hastalıkları Enstitüsü gece gündüz bakar.",
			CityHcEmergency2_podgorica:
				"Şehir ambulans servisi (hitna pomoć) de kesintisiz çalışır ve gerektiğinde hastayı Acil Merkezi'ne kendisi götürür.",
			CityHcState1_podgorica:
				'Karadağ Klinik Merkezi ülkenin ana hastanesidir: cerrahi, kardiyoloji, onkoloji, doğumhane ve tüm yan dallar. Planlı yatış ve konsültasyonlar sağlık kartıyla seçili doktorun (izabrani doktor) sevkiyle olur; kartsız hizmetler fiyat listesine göre ücretlidir.',
			CityHcState2_podgorica:
				'Dom zdravlja Podgorica, farklı semtlerdeki birkaç bloktan oluşan devlet birinci basamak ağıdır: dahiliye, pediatri, laboratuvar, ruh sağlığı merkezi.',
			CityHcState3_podgorica:
				'Halk Sağlığı Enstitüsü (Institut za javno zdravlje) seyahat aşıları dahil aşılamayla ilgilenir. Kan Transfüzyonu Enstitüsü (Zavod za transfuziju krvi) donör kabul eder ve kan grubu testleri yapar.',
			CityHcStateCatalog_podgorica: "KCCG'nin docta.me'deki sayfası — bölümler, yorumlar ve hizmetler:",
			CityHcStateLink_podgorica: 'Klinički Centar Crne Gore',
			CityHcPrivate1_podgorica:
				"Podgorica ülkedeki en geniş özel tıp seçeneğine sahiptir — örneğin Konzilijum'da MR ve geniş bir ameliyat yelpazesi var, Ars Medica ise büyük bir cerrahi ve estetik hastanedir. İşte profillerine göre başlıca kurumlar (tam liste — onlarca klinik — katalogda):",
			CityHcPvKonzilijum: 'Konzilijum',
			CityHcPvArsMedica: 'Ars Medica',
			CityHcPvMedtim: 'Medtim',
			CityHcPvCodraHospital: 'Codra Hospital',
			CityHcPvAMedic: 'A Medic',
			CityHcPvHipokratPg: 'Hipokrat',
			CityHcPvMojLabPg: 'Moj Lab',
			CityHcPvMilmedikaPg: 'Milmedika',
			CityHcPvFilipovicPg: 'Poliklinika Filipović',
			CityHcPrivateCatalog_podgorica:
				'Fiyatlar ve yorumlarla tam liste katalogda:',
			CityHcPrivateLink_podgorica: "Podgorica'daki özel klinikler",
			CityHcLabs_podgorica:
				'Tahliller herhangi bir özel laboratuvarda sevksiz, ücretli yapılır. Fiyatlar ve adresler şu bölümde:',
			CityHcLabsLink_podgorica: "Podgorica'da tahliller",
			CityHcPharmacy1_podgorica:
				"Podgorica'da yüzlerce eczane vardır: devlet zinciri Montefarm ve özel zincirler. Üçü 24 saat açıktır: Montefarm „Kruševac\" (Bulevar Svetog Petra Cetinjskog 45/a), Moskovska 22'deki BENU ve Bulevar Oktobarske Revolucije 31'deki Holos 7. Adresler ve 24 saat açık olma durumu değişebilir — geç saatte gitmeden önce teyit edin.",
			CityHcPharmacy2_podgorica:
				'Başka yerlerde serbest satılan birçok ilaç burada Karadağlı doktor reçetesi ister. İlaç stokta yoksa etken maddeye göre muadilini sorun — ticari adlar sıkça farklıdır.',
			CityHcCtaButton_podgorica: 'Podgorica klinikleri',

			// Kotor
			CityHcTitle_kotor:
				"Kotor'da sağlık hizmetleri: genel hastane, Dom zdravlja ve acil yardım",
			CityHcDescription_kotor:
				"Kotor'da tıbbi yardım: ambulans 124, tüm Boka körfezine hizmet veren Kotor Genel Hastanesi, Dom zdravlja Kotor, Risan'daki ihtisas hastanesi, özel laboratuvarlar ve eczaneler.",
			CityHcOverview1_kotor:
				'Kotor, Boka Kotorska körfezinin tıp merkezidir: Tivat, Budva ve Herceg Novi dahil tüm körfez bölgesine hizmet veren Kotor Genel Hastanesi (Opšta bolnica Kotor) buradadır. Birinci basamak hizmeti, acil servisiyle Dom zdravlja Kotor verir.',
			CityHcOverview2_kotor:
				"Yakında — Risan ve Dobrota'da — iki uzman devlet hastanesi bulunur: biri ortopedi, diğeri psikiyatri. Kotor'un kendisindeki özel sektör Budva veya Podgorica'ya göre daha küçüktür, ama bir şeyler var: bir laboratuvar, poliklinikler, kardiyoloji ve diş klinikleri.",
			CityHcEmergency1_kotor:
				"Acil durumda Dom zdravlja Kotor'daki hitna pomoć'a veya doğrudan Kotor hastanesinin acil kabulüne gidin: kıyı boyunca yaralanmalar, çocuk acilleri ve enfeksiyonlar buraya getirilir (hastanede çocuk ve enfeksiyon servisleri vardır).",
			CityHcEmergency2_kotor:
				'Dikkat: sağlık kartı ve sigortası olmayan yabancılar için hastane tedavisi fiyat listesine göre ücretlidir ve yatış faturaları yüklü olabilir. Poliçeniz varsa başvuru prosedürünü sigortacınızla önceden netleştirin; tedaviye başlamadan maliyet tahmini isteyebilirsiniz.',
			CityHcState1_kotor:
				"Kotor Genel Hastanesi, tüm Kotor Körfezi'ne (Budva, Tivat, Herceg Novi) hizmet veren çok bölümlü bir kurumdur. Hekim kadrosuna bakılırsa, iç hastalıkları, genel cerrahi, kadın hastalıkları ve doğum, radyoloji, pediatri, üroloji ve enfeksiyon hastalıkları bölümleri ile birkaç dar uzmanlık alanı bulunur.",
			CityHcState2_kotor:
				'Dom zdravlja Kotor devlet birinci basamak merkezidir: seçili doktor, çocuk doktoru, laboratuvar. Sağlık kartıyla muayeneler ücretsizdir; listedeki ilaçların reçetesini seçili doktor yazar.',
			CityHcState3a_kotor:
				"Risan'daki (Kotor'dan körfez boyunca yaklaşık yarım saat) uzman ",
			CityHcState3VasoLink_kotor: '"Vaso Ćuković" hastanesi',
			CityHcState3b_kotor:
				", ortopedi, nöroşirürji ve nöroloji için ülke çapında sevk merkezidir — hastalar yalnızca kıyıdan değil, ülkenin her yerinden buraya gönderilir. Kotor'un Dobrota semtinde ise uzman psikiyatri hastanesi ",
			CityHcState3DobrotaLink_kotor: '"Dobrota"',
			CityHcState3c_kotor:
				" bulunur — Karadağ'daki tek uzman psikiyatri hastanesi (diğer şehirlerde yalnızca ayaktan psikiyatri hizmeti veya genel hastane bünyesinde bir bölüm bulunur).",
			CityHcStateCatalog_kotor: "Hastanenin docta.me'deki sayfası — bölümler, yorumlar ve hizmetler:",
			CityHcStateLink_kotor: 'Opšta bolnica Kotor',
			CityHcPrivate1_kotor:
				"Kotor'un kendisindeki özel sektör küçüktür: bir laboratuvar, birkaç poliklinik, bir kardiyoloji kliniği, diş klinikleri ve fizyoterapi. Daha geniş seçenek için Kotor sakinleri genellikle Budva'ya veya Podgorica'ya gider. Yerinde bulunanlar, kataloğumuza göre:",
			CityHcPvSmartMed: 'SmartMed Kotor',
			CityHcPvHipokratRadanovici: 'Hipokrat Radanovići',
			CityHcPvInterCardio: 'Inter Cardio',
			CityHcPvDentalStudioVucetic: 'Dental Studio Vučetić',
			CityHcPvDrCetkovic: 'Dr Ćetković',
			CityHcPvOrthoCentarKotor: 'Ortho Centar',
			CityHcPvEndorfinRadanovici: 'Endorfin Radanovići',
			CityHcPrivateCatalog_kotor:
				'Şehrin kendisinde ne olduğunu katalogda görün:',
			CityHcPrivateLink_kotor: "Kotor'daki özel klinikler",
			CityHcLabs_kotor:
				'Özel laboratuvarlar sevksiz tahlil kabul eder. Fiyatlı liste şu bölümde:',
			CityHcLabsLink_kotor: "Kotor'da tahliller",
			CityHcPharmacy1_kotor:
				"Eczaneler Eski Şehir'de ve yeni semtlerde çalışır; sezonda çalışma saatleri uzar. Kotor'da gece açık eczane olmayabilir — düzenli ilaçlarınızın yedeğini evde bulundurun.",
			CityHcPharmacy2_kotor:
				"Gece akut bir durumda hitna pomoć'a veya hastanenin acil kabulüne başvurun: orada muayene edilir ve ilk ilaçlar verilir.",
			CityHcCtaButton_kotor: 'Kotor klinikleri',

			// Bar
			CityHcTitle_bar:
				"Bar'da sağlık hizmetleri: hastane, Dom zdravlja ve özel klinikler",
			CityHcDescription_bar:
				"Bar'da tıbbi yardım: ambulans 124, merkezdeki Dom zdravlja Bar, Stari Bar'daki Blažo Orlandić hastanesi, özel klinikler, laboratuvarlar ve eczaneler.",
			CityHcOverview1_bar:
				"Bar'da devlet sağlık hizmetlerinin tamamı vardır: şehir merkezinde acil servisiyle Dom zdravlja Bar ve Stari Bar'da gece gündüz çalışan yataklı Blažo Orlandić Genel Hastanesi.",
			CityHcOverview2_bar:
				"Özel sektör dikkat çekicidir: poliklinikler, özel bir gündüz hastanesi, laboratuvarlar ve çok sayıda diş kliniği. Sutomore'de (Bar belediyesi) BT ve MR yapılan özel bir hastane çalışır.",
			CityHcEmergency1_bar:
				"Acil durumda: hitna pomoć, Bar merkezindeki Dom zdravlja'dadır. Yaralanmalarda ve yatış gerektiren durumlarda doğrudan Stari Bar'daki hastaneye gidebilirsiniz — acil kabul gece gündüz çalışır.",
			CityHcEmergency2_bar:
				'Sohbette paylaşılan yol: önce hitna — muayene ederler, gerekirse hastaneye sevk verirler; yatış gerektiği açıksa doğrudan hastanenin acil kabulüne gidin.',
			CityHcState1_bar:
				'Blažo Orlandić Genel Hastanesi çok branşlıdır: cerrahi, jinekoloji ve doğumhane, pediatri, röntgen ve BT, fizik tedavi. Sağlık kartıyla tedavi ücretsizdir; diğerleri için fiyat listesine göre ücretlidir.',
			CityHcState2_bar:
				'Dom zdravlja Bar birinci basamaktır: seçili doktor, pediatri, laboratuvar, aşılama (bazı seyahat aşıları dahil). Bazı doktorlar Rusça veya İngilizce konuşur — randevu alırken sorun.',
			CityHcState3_bar:
				"Bar'da olmayan uzmanlık tetkikleri sevkle Podgorica'da yapılır — Klinik Merkez yaklaşık bir saat uzaklıktadır.",
			CityHcStateCatalog_bar: "Hastanenin docta.me'deki sayfası — bölümler, yorumlar ve hizmetler:",
			CityHcStateLink_bar: 'Opšta Bolnica "Blažo Orlandić"',
			CityHcPrivate1_bar:
				"Bar ve Sutomore'de birkaç büyük özel klinik ve laboratuvar var — örneğin Sutomore'deki A3 Medical BT ve MR çekimi yapıyor ve muayeneye ücretsiz tercüman (Rusça, İngilizce) sağlıyor. Bar'da özellikle çok sayıda diş kliniği var, bazıları Rusça konuşan doktorlarla; ayrıca KBB, üroloji ve jinekoloji var. Kataloğumuza göre aşağı yukarı eksiksiz liste:",
			CityHcPvNoviStandardBar: 'Novi Standard',
			CityHcPvDrZejnilovic: 'Dr Zejnilović',
			CityHcPvMedicalVranes: 'Medical Vraneš',
			CityHcPvA3Medical: 'A3 Medical',
			CityHcPvJustDental: 'Just Dental',
			CityHcPvPavlinDental: 'Pavlin',
			CityHcPvDrDebelja: 'Dr Debelja',
			CityHcPvGroupLabel_OtherDental: 'Diğer diş klinikleri',
			CityHcPvBuntic: 'Buntić',
			CityHcPvDrSimonovic: 'Dr Simonović',
			CityHcPvDrBajagic: 'Dr Bajagić',
			CityHcPvDrZejak: 'Dr Zejak',
			CityHcPvGacina: 'Gaćina',
			CityHcPvJovoticDent: 'Jovetić Dent',
			CityHcPvCicmil: 'Cicmil',
			CityHcPrivateCatalog_bar: 'Fiyatlar ve yorumlarla tam liste katalogda:',
			CityHcPrivateLink_bar: "Bar'daki özel klinikler",
			CityHcLabs_bar:
				'Özel laboratuvarlar sevksiz tahlil kabul eder. Fiyatlı liste şu bölümde:',
			CityHcLabsLink_bar: "Bar'da tahliller",
			CityHcPharmacy1_bar: "Eczaneler merkezde ve Šušanj'da bulunur.",
			CityHcLenapharmText_bar: 'Sohbet üyeleri özellikle sık şu eczaneyi önerir:',
			CityHcLenapharmAfter_bar: "Šušanj'da — orada Rusça da yanıt verirler.",
			CityHcPharmacy2_bar:
				"Gece açık eczane olmayabilir — gece hitna pomoć'a veya hastanenin acil kabulüne başvurun. Reçeteli ilaçlar Karadağlı doktor reçetesiyle satılır.",
			CityHcCtaButton_bar: 'Bar klinikleri',
		},
	},
};
