// Контент серии статей «Медицина в {городе}» (Будва, Подгорица, Котор, Бар).
// Ключи: общие (CityHc*) + по-городские (CityHc*_budva / _podgorica / _kotor / _bar).
// Источники: телеграм-чат medicina_montenegro (экспорт 2026-03), каталог docta.me.
export default {
	messages: {
		en: {
			// Shared
			CityHcToc_overview: 'What the city offers',
			CityHcToc_emergency: 'Emergency care',
			CityHcToc_state: 'Public healthcare',
			CityHcToc_private: 'Private clinics and laboratories',
			CityHcToc_pharmacies: 'Pharmacies and on-call services',
			CityHcEmergencyShared:
				'Call 124 or 112 for a medical emergency. The dispatcher assesses urgency and decides whether to send a team or advise attendance at a hitna pomoć point. Do not assume it is faster or safe to travel independently: follow instructions and do not drive yourself if there is breathing difficulty, chest pain, loss of consciousness, severe injury, seizure, stroke signs or rapid deterioration.',
			CityHcLinkEnd: '.',
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
				'The private sector is well developed: private polyclinics, laboratories and dental offices operate in town, and in many of them you can communicate in English or Russian. Inpatient treatment and advanced diagnostics mean a trip to nearby Kotor or Podgorica.',
			CityHcEmergency1_budva:
				'The emergency unit (hitna pomoć) in Budva is located at the Dom zdravlja and works around the clock. According to expat chat reports, it also sees children — you can go there directly with a child.',
			CityHcEmergency2_budva:
				'For serious injuries and conditions requiring hospitalization, patients from Budva are referred to the hospital in Kotor (about half an hour away) or to the Clinical Center of Montenegro in Podgorica. The referral (uputnica) is issued by the hitna pomoć doctor.',
			CityHcState1_budva:
				'Dom zdravlja Budva is the public primary care center: GPs (izabrani doktor), pediatrics, a laboratory and treatment rooms. For holders of the zdravstvena knjižica health card, visits are free or almost free.',
			CityHcState2_budva:
				'In summer the center runs a tourist ambulanta — paid appointments for visitors without the health card. The Dom zdravlja also offers seasonal flu vaccination and occasional free campaigns such as HIV and hepatitis testing.',
			CityHcState3_budva:
				'Hospital care for Budva residents is provided by the general hospital in Kotor and the Clinical Center in Podgorica. Planned examinations under the health card require a referral from your chosen doctor.',
			CityHcPrivate1_budva:
				'Budva has plenty of private clinics and laboratories, from general polyclinics to dentistry and ophthalmology. The Russian-speaking expat chat most often mentions the Moj Lab laboratory and the Milmedika and BonoMedica clinics — all of them are listed in our catalog.',
			CityHcPrivateCatalog_budva:
				'For an up-to-date list with addresses, prices and reviews, see the catalog:',
			CityHcPrivateLink_budva: 'private clinics in Budva',
			CityHcLabs_budva:
				'Many private laboratories accept self-paying patients for common routine tests without a referral, but specialised tests may require an order, preparation or appointment. Confirm directly. Listed tests and available prices are in',
			CityHcLabsLink_budva: 'lab tests in Budva',
			CityHcPharmacy1_budva:
				'There are many pharmacies in Budva, and in season most work seven days a week. Prescription drugs (antibiotics above all) formally require a prescription from a Montenegrin doctor — a private clinic doctor can issue one.',
			CityHcPharmacy2_budva:
				'Pharmacy opening hours and duty rosters change seasonally; do not rely on a chat report or a named 24-hour pharmacy without same-day confirmation. Check the pharmacy directly or ask the local dom zdravlja. A pharmacy is not a substitute for emergency assessment.',
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
			CityHcPrivate1_podgorica:
				'Podgorica offers the widest choice of private medicine: private hospitals with surgery and MRI (the chat most often mentions Codra Hospital and the Hipokrat polyclinics), Moj Lab laboratories, Milmedika, Poliklinika Filipović and dozens of others.',
			CityHcPrivateCatalog_podgorica:
				'Listed clinics with available prices and reviews are in the catalog; coverage is not complete, so confirm services directly:',
			CityHcPrivateLink_podgorica: 'private clinics in Podgorica',
			CityHcLabs_podgorica:
				'Many private laboratories accept self-paying patients for common routine tests without a referral, but specialised tests may require an order, preparation or appointment. Confirm directly. Listed tests and available prices are in',
			CityHcLabsLink_podgorica: 'lab tests in Podgorica',
			CityHcPharmacy1_podgorica:
				'Podgorica has state and private pharmacies, but the current overnight duty roster and location can change. Confirm same-day opening hours directly with the pharmacy or local official information rather than relying on an old 24-hour listing.',
			CityHcPharmacy2_podgorica:
				'Prescription medicines require a prescription valid under Montenegrin rules. A foreign prescription may be accepted in an individual case but does not guarantee dispensing and the pharmacist may refuse; arrange local clinical assessment when continuity matters.',
			CityHcCtaButton_podgorica: 'Clinics in Podgorica',

			// Kotor
			CityHcTitle_kotor:
				'Healthcare in Kotor: general hospital, Dom zdravlja and emergency care',
			CityHcDescription_kotor:
				'Medical help in Kotor: ambulance 124, Kotor General Hospital serving the whole Boka bay, Dom zdravlja Kotor, the specialized hospital in Risan, private laboratories and pharmacies.',
			CityHcOverview1_kotor:
				'Kotor is the medical hub of the Boka Kotorska bay: it hosts the Kotor General Hospital (Opšta bolnica Kotor), which serves the whole coastal area including Tivat, Budva and Herceg Novi. Primary care is provided by Dom zdravlja Kotor with its ambulance service.',
			CityHcOverview2_kotor:
				'Nearby, in Risan, there is the specialized public hospital Vaso Ćuković for orthopedics, neurosurgery and neurology, which receives patients from all over the country. The private sector is more modest than in Budva or Podgorica, but laboratories and private doctors are available.',
			CityHcEmergency1_kotor:
				'In an emergency, go to hitna pomoć at Dom zdravlja Kotor or directly to the admission unit of the Kotor hospital: injuries, pediatric emergencies and infections from along the coast are brought here (the hospital has pediatric and infectious disease wards).',
			CityHcEmergency2_kotor:
				'Note: for foreigners without the health card and insurance, hospital treatment is paid according to the price list, and inpatient bills can be substantial. If you have an insurance policy, clarify the procedure with your insurer in advance; you can ask for a cost estimate before treatment starts.',
			CityHcState1_kotor:
				'Kotor General Hospital is a multi-specialty inpatient facility: surgery, pediatrics, gynecology, an infectious diseases ward, X-ray. Patients are referred here from the primary care centers of Budva, Tivat and Herceg Novi.',
			CityHcState2_kotor:
				'Dom zdravlja Kotor is the public primary care center: chosen doctor, pediatrician, laboratory. With the zdravstvena knjižica, visits are free, and your chosen GP issues prescriptions for subsidized medicines.',
			CityHcState3_kotor:
				'The specialized hospital Vaso Ćuković in Risan, a short drive along the bay, is the national center for orthopedics, neurosurgery and neurology. Kotor also hosts the state specialized psychiatric hospital.',
			CityHcPrivate1_kotor:
				'Among private services, the chat most often mentions the SmartMed laboratory in Kotor; in Radanovići (Kotor municipality) there is a Hipokrat polyclinic with MRI. For a wider choice of private specialists, Kotor residents usually travel to Budva or Podgorica.',
			CityHcPrivateCatalog_kotor:
				'See what is available in the town itself in the catalog:',
			CityHcPrivateLink_kotor: 'private clinics in Kotor',
			CityHcLabs_kotor:
				'Many private laboratories accept self-paying patients for common routine tests without a referral, but specialised tests may require an order, preparation or appointment. Confirm directly. Listed tests and available prices are in',
			CityHcLabsLink_kotor: 'lab tests in Kotor',
			CityHcPharmacy1_kotor:
				'Pharmacies operate in the Old Town and the newer districts; in season the hours are extended. There may be no 24-hour pharmacy in Kotor — keep a stock of your regular medicines at home.',
			CityHcPharmacy2_kotor:
				'Opening hours and duty rosters change, especially by season. Confirm the current open pharmacy directly or through local official information; do not rely on a statement that no 24-hour pharmacy exists. Keep lawful continuity supplies for regular treatment and use urgent medical services for acute symptoms.',
			CityHcCtaButton_kotor: 'Clinics in Kotor',

			// Bar
			CityHcTitle_bar:
				'Healthcare in Bar: hospital, Dom zdravlja and private clinics',
			CityHcDescription_bar:
				'Medical help in Bar: ambulance 124, Dom zdravlja Bar in the center, the Blažo Orlandić hospital in Stari Bar, private clinics, laboratories and pharmacies.',
			CityHcOverview1_bar:
				'Bar has the full set of public healthcare: Dom zdravlja Bar (the primary care center with the ambulance service) in the city center and the Blažo Orlandić General Hospital in Stari Bar — a round-the-clock inpatient facility.',
			CityHcOverview2_bar:
				'The private sector is notable: polyclinics, a private day hospital, laboratories and many dental offices. In Sutomore (Bar municipality) there is a private hospital with CT and MRI.',
			CityHcEmergency1_bar:
				'In an emergency: hitna pomoć is located at the Dom zdravlja in the center of Bar. For injuries and conditions requiring hospitalization you can go directly to the hospital in Stari Bar — the admission unit works around the clock.',
			CityHcEmergency2_bar:
				'The scheme shared in the chat: first hitna — they will examine you and issue a referral to the hospital if needed; or straight to the hospital admission unit when it is obvious that inpatient care is required.',
			CityHcState1_bar:
				'The Blažo Orlandić General Hospital is a multi-specialty facility: surgery, gynecology and a maternity ward, pediatrics, X-ray and CT, physiotherapy. Treatment is free with the health card; for others it is paid by the price list.',
			CityHcState2_bar:
				'Dom zdravlja Bar is the primary care level: chosen doctor, pediatrics, laboratory, vaccination (including some travel vaccines).',
			CityHcState3_bar:
				'Specialized examinations not available in Bar are done by referral in Podgorica — the Clinical Center is about an hour away.',
			CityHcPrivate1_bar:
				'Among private facilities, the chat most often names the Novi Standard polyclinic, the Dr Zejnilović day hospital and Medical Vraneš; there are many private dental offices. In Sutomore, the private A3 Medical hospital offers CT and MRI.',
			CityHcPrivateCatalog_bar:
				'Listed clinics with available prices and reviews are in the catalog; coverage is not complete, so confirm services directly:',
			CityHcPrivateLink_bar: 'private clinics in Bar',
			CityHcLabs_bar:
				'Many private laboratories accept self-paying patients for common routine tests without a referral, but specialised tests may require an order, preparation or appointment. Confirm directly. Listed tests and available prices are in',
			CityHcLabsLink_bar: 'lab tests in Bar',
			CityHcPharmacy1_bar:
				'Pharmacies are spread across the center and Šušanj; chat members often recommend the Lenapharm pharmacy in Šušanj, where you can communicate in Russian.',
			CityHcPharmacy2_bar:
				'Opening hours and duty rosters change, so verify the current open pharmacy directly or through local official information. Do not go to an emergency department solely to obtain a routine medicine; use emergency care for acute medical need. Prescription dispensing follows Montenegrin rules and a foreign prescription is not guaranteed.',
			CityHcCtaButton_bar: 'Clinics in Bar',
		},
		ru: {
			// Общие
			CityHcToc_overview: 'Что есть в городе',
			CityHcToc_emergency: 'Экстренная помощь',
			CityHcToc_state: 'Государственная медицина',
			CityHcToc_private: 'Частные клиники и лаборатории',
			CityHcToc_pharmacies: 'Аптеки и дежурные службы',
			CityHcEmergencyShared:
				'При медицинской угрозе звоните 124 или 112. Диспетчер оценивает срочность и решает, направить ли бригаду или рекомендовать поездку в hitna pomoć. Не считайте, что ехать самостоятельно всегда быстрее и безопасно: выполняйте инструкции и не садитесь за руль при затруднённом дыхании, боли в груди, потере сознания, тяжёлой травме, судорогах, признаках инсульта или быстром ухудшении.',
			CityHcLinkEnd: '.',
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
				'Частный сектор развит хорошо: в городе работают частные поликлиники, лаборатории и стоматологии, во многих можно объясниться на русском или английском. Стационарное лечение и сложная диагностика — это поездка в соседний Котор или Подгорицу.',
			CityHcEmergency1_budva:
				'Служба скорой помощи (hitna pomoć) в Будве находится при Dom zdravlja и принимает круглосуточно. Судя по опыту участников русскоязычных чатов, там есть и детский приём — с ребёнком можно ехать напрямую.',
			CityHcEmergency2_budva:
				'При серьёзных травмах и состояниях, требующих госпитализации, из Будвы направляют в больницу Котора (около получаса езды) или в Клинический центр Черногории в Подгорице. Направление (uputnica) выдаёт врач hitna pomoć.',
			CityHcState1_budva:
				'Dom zdravlja Budva — государственная поликлиника: терапевты (izabrani doktor), педиатрия, лаборатория, процедурные кабинеты. Для обладателей здравственной книжицы (zdravstvena knjižica) приёмы бесплатны или почти бесплатны.',
			CityHcState2_budva:
				'Летом при поликлинике работает туристическая амбулатория (turistička ambulanta) — платный приём для гостей без книжицы. Также в Dom zdravlja проводят сезонную вакцинацию от гриппа и периодические бесплатные акции, например тестирование на ВИЧ и гепатиты.',
			CityHcState3_budva:
				'Больничное лечение жители Будвы получают в Опште больнице Котора и в Клиническом центре в Подгорице. На плановые обследования по книжице нужно направление от выбранного врача.',
			CityHcPrivate1_budva:
				'Частных клиник и лабораторий в Будве много: от терапевтических поликлиник до стоматологий и офтальмологии. В русскоязычном чате чаще всего упоминают лабораторию Moj Lab и клиники Milmedika и BonoMedica — все они есть в нашем каталоге.',
			CityHcPrivateCatalog_budva:
				'Актуальный список с адресами, ценами и отзывами — в каталоге:',
			CityHcPrivateLink_budva: 'частные клиники Будвы',
			CityHcLabs_budva:
				'Многие частные лаборатории принимают платно на распространённые рутинные анализы без направления, но для специализированных исследований могут понадобиться назначение, подготовка или запись. Уточняйте напрямую. Добавленные анализы и доступные цены — в разделе',
			CityHcLabsLink_budva: 'анализы в Будве',
			CityHcPharmacy1_budva:
				'Аптек в Будве много, в сезон большинство работает без выходных. Рецептурные препараты (в первую очередь антибиотики) формально продаются по рецепту черногорского врача — его выпишет и врач частной клиники.',
			CityHcPharmacy2_budva:
				'Часы работы аптек и график дежурств меняются по сезону; не рассчитывайте на сообщение из чата или названную круглосуточную аптеку без проверки в тот же день. Позвоните в аптеку или уточните у местного dom zdravlja. Аптека не заменяет экстренную оценку состояния.',
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
			CityHcPrivate1_podgorica:
				'Выбор частной медицины в Подгорице самый широкий: частные госпитали с хирургией и МРТ (в чате чаще всего упоминают Codra Hospital и поликлиники Hipokrat), лаборатории Moj Lab, клиники Milmedika, Poliklinika Filipović и десятки других.',
			CityHcPrivateCatalog_podgorica:
				'Полный список с ценами и отзывами — в каталоге:',
			CityHcPrivateLink_podgorica: 'частные клиники Подгорицы',
			CityHcLabs_podgorica:
				'Многие частные лаборатории принимают платно на распространённые рутинные анализы без направления, но для специализированных исследований могут понадобиться назначение, подготовка или запись. Уточняйте напрямую. Добавленные анализы и доступные цены — в разделе',
			CityHcLabsLink_podgorica: 'анализы в Подгорице',
			CityHcPharmacy1_podgorica:
				'В Подгорице есть государственные и частные аптеки, но актуальный ночной график и адрес дежурной аптеки могут меняться. Проверяйте часы работы в тот же день напрямую или по местной официальной информации, а не по старому списку круглосуточных точек.',
			CityHcPharmacy2_podgorica:
				'Рецептурные препараты требуют рецепта, действительного по правилам Черногории. Иностранный рецепт иногда могут принять в конкретном случае, но он не гарантирует отпуск, а фармацевт вправе отказать; если важна непрерывность лечения, заранее организуйте местную врачебную консультацию.',
			CityHcCtaButton_podgorica: 'Клиники Подгорицы',

			// Котор
			CityHcTitle_kotor:
				'Медицина в Которе: больница, Dom zdravlja и скорая помощь',
			CityHcDescription_kotor:
				'Медицинская помощь в Которе: скорая 124, Општа больница Котор, обслуживающая всю Боку, Dom zdravlja Kotor, специализированная больница в Рисане, частные лаборатории и аптеки.',
			CityHcOverview1_kotor:
				'Котор — медицинский центр Боки Которской: здесь находится Општа больница Котор (Opšta bolnica Kotor), обслуживающая всё побережье залива, включая Тиват, Будву и Херцег-Нови. Первичное звено — Dom zdravlja Kotor со службой скорой помощи.',
			CityHcOverview2_kotor:
				'Рядом, в Рисане, работает специализированная государственная больница «Васо Чукович» — ортопедия, нейрохирургия и неврология, туда направляют пациентов со всей страны. Частный сектор скромнее, чем в Будве или Подгорице, но лаборатории и частные врачи в городе есть.',
			CityHcEmergency1_kotor:
				'В экстренных случаях — hitna pomoć при Dom zdravlja Kotor или сразу приёмное отделение больницы Котора: сюда с побережья везут травмы, детские неотложные состояния и инфекции (в больнице есть детское и инфекционное отделения).',
			CityHcEmergency2_kotor:
				'Учтите: для иностранцев без здравственной книжицы и страховки лечение в больнице платное по прейскуранту, и счета за стационар бывают ощутимыми. Если есть полис — заранее уточните у страховой порядок обращения; смету можно попросить до начала лечения.',
			CityHcState1_kotor:
				'Општа больница Котор — многопрофильный стационар: хирургия, педиатрия, гинекология, инфекционное отделение, рентген. Сюда направляют из домов здравля Будвы, Тивата и Херцег-Нови.',
			CityHcState2_kotor:
				'Dom zdravlja Kotor — государственная поликлиника: выбранный врач, педиатр, лаборатория. По здравственной книжице приёмы бесплатны, рецепты на льготные лекарства выписывает выбранный терапевт.',
			CityHcState3_kotor:
				'Специализированная больница «Васо Чукович» в Рисане, в короткой поездке вдоль залива, — государственный центр ортопедии, нейрохирургии и неврологии. Также в Которе находится государственная специализированная психиатрическая больница.',
			CityHcPrivate1_kotor:
				'Из частных служб в чатах чаще всего упоминают лабораторию SmartMed в Которе; в Радановичах (община Котор) работает поликлиника Hipokrat с МРТ. За широким выбором частных специалистов жители Котора обычно ездят в Будву или Подгорицу.',
			CityHcPrivateCatalog_kotor:
				'Что есть в самом городе — смотрите в каталоге:',
			CityHcPrivateLink_kotor: 'частные клиники Котора',
			CityHcLabs_kotor:
				'Многие частные лаборатории принимают платно на распространённые рутинные анализы без направления, но для специализированных исследований могут понадобиться назначение, подготовка или запись. Уточняйте напрямую. Добавленные анализы и доступные цены — в разделе',
			CityHcLabsLink_kotor: 'анализы в Которе',
			CityHcPharmacy1_kotor:
				'Аптеки работают в Старом городе и новых районах; в сезон график расширяется. Круглосуточной аптеки в Которе может не быть — запас постоянных лекарств лучше держать дома.',
			CityHcPharmacy2_kotor:
				'Часы работы и дежурства меняются, особенно по сезону. Проверяйте открытую аптеку напрямую или по местной официальной информации и не полагайтесь на утверждение, что круглосуточной аптеки точно нет. Для постоянного лечения заранее держите законный запас, а при острых симптомах обращайтесь за медицинской помощью.',
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
				'Dom zdravlja Bar — первичное звено: выбранный врач, педиатрия, лаборатория, вакцинация (в том числе некоторые прививки для путешественников).',
			CityHcState3_bar:
				'Плановые узкие обследования, которых нет в Баре, делают по направлению в Подгорице — Клинический центр примерно в часе езды.',
			CityHcPrivate1_bar:
				'Из частных учреждений в чатах чаще всего называют поликлинику Novi Standard, дневную больницу Dr Zejnilović и Medical Vraneš; много частных стоматологий. В Сутоморе частная больница A3 Medical делает КТ и МРТ.',
			CityHcPrivateCatalog_bar:
				'Полный список с ценами и отзывами — в каталоге:',
			CityHcPrivateLink_bar: 'частные клиники Бара',
			CityHcLabs_bar:
				'Многие частные лаборатории принимают платно на распространённые рутинные анализы без направления, но для специализированных исследований могут понадобиться назначение, подготовка или запись. Уточняйте напрямую. Добавленные анализы и доступные цены — в разделе',
			CityHcLabsLink_bar: 'анализы в Баре',
			CityHcPharmacy1_bar:
				'Аптеки распределены по центру и Шушаню; участники чата часто рекомендуют аптеку Lenapharm в Шушане, где можно объясниться по-русски.',
			CityHcPharmacy2_bar:
				'Часы работы и дежурства меняются: проверяйте открытую аптеку напрямую или по местной официальной информации. Не обращайтесь в приёмное отделение только ради обычного лекарства; экстренная помощь предназначена для острой медицинской необходимости. Рецептурный отпуск регулируется правилами Черногории, а иностранный рецепт ничего не гарантирует.',
			CityHcCtaButton_bar: 'Клиники Бара',
		},
		sr: {
			// Zajednički
			CityHcToc_overview: 'Šta grad nudi',
			CityHcToc_emergency: 'Hitna pomoć',
			CityHcToc_state: 'Državno zdravstvo',
			CityHcToc_private: 'Privatne klinike i laboratorije',
			CityHcToc_pharmacies: 'Apoteke i dežurne službe',
			CityHcEmergencyShared:
				'Kod medicinske hitnosti pozovite 124 ili 112. Dispečer procjenjuje hitnost i odlučuje da li šalje ekipu ili savjetuje dolazak u hitnu pomoć. Ne pretpostavljajte da je samostalni put brži ili bezbjedan: slijedite uputstva i ne vozite kod otežanog disanja, bola u grudima, gubitka svijesti, teške povrede, napada, znakova moždanog udara ili brzog pogoršanja.',
			CityHcLinkEnd: '.',
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
				'Privatni sektor je dobro razvijen: u gradu rade privatne poliklinike, laboratorije i stomatološke ordinacije, a u mnogima se možete sporazumjeti na engleskom ili ruskom. Bolničko liječenje i složena dijagnostika znače put do Kotora ili Podgorice.',
			CityHcEmergency1_budva:
				'Hitna pomoć u Budvi nalazi se pri Domu zdravlja i radi non-stop. Prema iskustvima iz četova, prima i djecu — sa djetetom možete doći direktno.',
			CityHcEmergency2_budva:
				'Kod ozbiljnih povreda i stanja koja zahtijevaju hospitalizaciju, pacijenti se iz Budve upućuju u bolnicu u Kotoru (oko pola sata vožnje) ili u Klinički centar Crne Gore u Podgorici. Uput izdaje ljekar hitne pomoći.',
			CityHcState1_budva:
				'Dom zdravlja Budva je državna ustanova primarne zaštite: izabrani doktori, pedijatrija, laboratorija i intervencije. Za vlasnike zdravstvene knjižice pregledi su besplatni ili gotovo besplatni.',
			CityHcState2_budva:
				'Ljeti pri domu zdravlja radi turistička ambulanta — pregledi uz plaćanje za goste bez knjižice. Dom zdravlja organizuje i sezonsku vakcinaciju protiv gripa, kao i povremene besplatne akcije, npr. testiranje na HIV i hepatitise.',
			CityHcState3_budva:
				'Bolničko liječenje stanovnici Budve dobijaju u Opštoj bolnici Kotor i u Kliničkom centru u Podgorici. Za planirane preglede po knjižici potreban je uput izabranog doktora.',
			CityHcPrivate1_budva:
				'Privatnih klinika i laboratorija u Budvi ima mnogo: od opštih poliklinika do stomatologije i oftalmologije. U četu na ruskom jeziku najčešće se pominju laboratorija Moj Lab i klinike Milmedika i BonoMedica — sve su u našem katalogu.',
			CityHcPrivateCatalog_budva:
				'Aktuelni spisak sa adresama, cijenama i recenzijama nalazi se u katalogu:',
			CityHcPrivateLink_budva: 'privatne klinike u Budvi',
			CityHcLabs_budva:
				'Mnoge privatne laboratorije primaju uz plaćanje za uobičajene rutinske analize bez uputa, ali specijalizovani testovi mogu tražiti nalog, pripremu ili termin. Provjerite direktno. Unesene analize i dostupne cijene su u odjeljku',
			CityHcLabsLink_budva: 'analize u Budvi',
			CityHcPharmacy1_budva:
				'Apoteka u Budvi ima mnogo, a u sezoni većina radi svakog dana. Ljekovi na recept (prije svega antibiotici) formalno se izdaju uz recept crnogorskog ljekara — može ga izdati i ljekar privatne klinike.',
			CityHcPharmacy2_budva:
				'Radno vrijeme i dežurstva apoteka mijenjaju se sezonski; ne oslanjajte se na čet ili navedenu non-stop apoteku bez provjere istog dana. Pozovite apoteku ili pitajte dom zdravlja. Apoteka ne zamjenjuje hitnu medicinsku procjenu.',
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
			CityHcPrivate1_podgorica:
				'Izbor privatne medicine u Podgorici je najširi: privatne bolnice sa hirurgijom i magnetnom rezonancom (u četu se najčešće pominju Codra Hospital i poliklinike Hipokrat), laboratorije Moj Lab, Milmedika, Poliklinika Filipović i deseci drugih.',
			CityHcPrivateCatalog_podgorica:
				'Kompletan spisak sa cijenama i recenzijama je u katalogu:',
			CityHcPrivateLink_podgorica: 'privatne klinike u Podgorici',
			CityHcLabs_podgorica:
				'Mnoge privatne laboratorije primaju uz plaćanje za uobičajene rutinske analize bez uputa, ali specijalizovani testovi mogu tražiti nalog, pripremu ili termin. Provjerite direktno. Unesene analize i dostupne cijene su u odjeljku',
			CityHcLabsLink_podgorica: 'analize u Podgorici',
			CityHcPharmacy1_podgorica:
				'Podgorica ima državne i privatne apoteke, ali noćno dežurstvo i lokacija mogu se mijenjati. Provjerite radno vrijeme istog dana direktno ili kroz lokalne zvanične informacije, ne preko starog non-stop spiska.',
			CityHcPharmacy2_podgorica:
				'Ljekovi na recept traže recept važeći po crnogorskim pravilima. Strani recept može biti prihvaćen u pojedinačnom slučaju, ali ne garantuje izdavanje i farmaceut može odbiti; kada je kontinuitet važan, organizujte lokalnu procjenu ljekara.',
			CityHcCtaButton_podgorica: 'Klinike u Podgorici',

			// Kotor
			CityHcTitle_kotor:
				'Zdravstvo u Kotoru: opšta bolnica, dom zdravlja i hitna pomoć',
			CityHcDescription_kotor:
				'Medicinska pomoć u Kotoru: hitna 124, Opšta bolnica Kotor koja pokriva cijelu Boku, Dom zdravlja Kotor, specijalna bolnica u Risnu, privatne laboratorije i apoteke.',
			CityHcOverview1_kotor:
				'Kotor je medicinski centar Boke Kotorske: tu se nalazi Opšta bolnica Kotor, koja pokriva cijelo područje zaliva, uključujući Tivat, Budvu i Herceg Novi. Primarnu zaštitu pruža Dom zdravlja Kotor sa službom hitne pomoći.',
			CityHcOverview2_kotor:
				'U obližnjem Risnu radi specijalna državna bolnica „Vaso Ćuković" — ortopedija, neurohirurgija i neurologija — u koju dolaze pacijenti iz cijele zemlje. Privatni sektor je skromniji nego u Budvi ili Podgorici, ali laboratorija i privatnih ljekara ima.',
			CityHcEmergency1_kotor:
				'U hitnim slučajevima idite u hitnu pomoć pri Domu zdravlja Kotor ili direktno na prijemno odjeljenje kotorske bolnice: ovamo se sa primorja dovoze povrede, dječja urgentna stanja i infekcije (bolnica ima dječje i infektivno odjeljenje).',
			CityHcEmergency2_kotor:
				'Imajte u vidu: za strance bez zdravstvene knjižice i osiguranja bolničko liječenje se plaća po cjenovniku, a računi za stacionar mogu biti visoki. Ako imate polisu, unaprijed provjerite proceduru sa osiguravačem; predračun možete tražiti prije početka liječenja.',
			CityHcState1_kotor:
				'Opšta bolnica Kotor je višespecijalistički stacionar: hirurgija, pedijatrija, ginekologija, infektivno odjeljenje, rendgen. Ovamo upućuju domovi zdravlja Budve, Tivta i Herceg Novog.',
			CityHcState2_kotor:
				'Dom zdravlja Kotor je državna ustanova primarne zaštite: izabrani doktor, pedijatar, laboratorija. Uz zdravstvenu knjižicu pregledi su besplatni, a recepte za ljekove sa liste izdaje izabrani doktor.',
			CityHcState3_kotor:
				'Specijalna bolnica „Vaso Ćuković" u Risnu, na kratkoj vožnji uz zaliv, državni je centar za ortopediju, neurohirurgiju i neurologiju. U Kotoru se nalazi i državna specijalna psihijatrijska bolnica.',
			CityHcPrivate1_kotor:
				'Od privatnih službi u četovima se najčešće pominje laboratorija SmartMed u Kotoru; u Radanovićima (opština Kotor) radi poliklinika Hipokrat sa magnetnom rezonancom. Po širi izbor privatnih specijalista stanovnici Kotora obično idu u Budvu ili Podgoricu.',
			CityHcPrivateCatalog_kotor:
				'Šta postoji u samom gradu pogledajte u katalogu:',
			CityHcPrivateLink_kotor: 'privatne klinike u Kotoru',
			CityHcLabs_kotor:
				'Mnoge privatne laboratorije primaju uz plaćanje za uobičajene rutinske analize bez uputa, ali specijalizovani testovi mogu tražiti nalog, pripremu ili termin. Provjerite direktno. Unesene analize i dostupne cijene su u odjeljku',
			CityHcLabsLink_kotor: 'analize u Kotoru',
			CityHcPharmacy1_kotor:
				'Apoteke rade u Starom gradu i novijim djelovima; u sezoni je radno vrijeme duže. Non-stop apoteke u Kotoru možda nema — zalihu stalnih ljekova držite kod kuće.',
			CityHcPharmacy2_kotor:
				'Radno vrijeme i dežurstva mijenjaju se, naročito sezonski. Provjerite otvorenu apoteku direktno ili kroz zvanične lokalne podatke; ne oslanjajte se na tvrdnju da non-stop apoteke sigurno nema. Za redovnu terapiju držite zakonitu zalihu, a kod akutnih simptoma koristite medicinsku službu.',
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
				'Dom zdravlja Bar je primarni nivo: izabrani doktor, pedijatrija, laboratorija, vakcinacija (uključujući neke vakcine za putnike).',
			CityHcState3_bar:
				'Specijalistički pregledi kojih nema u Baru rade se po uputu u Podgorici — Klinički centar je na oko sat vremena vožnje.',
			CityHcPrivate1_bar:
				'Od privatnih ustanova u četovima se najčešće pominju poliklinika Novi Standard, dnevna bolnica Dr Zejnilović i Medical Vraneš; ima mnogo privatnih stomatologa. U Sutomoru privatna bolnica A3 Medical nudi CT i magnetnu rezonancu.',
			CityHcPrivateCatalog_bar:
				'Kompletan spisak sa cijenama i recenzijama je u katalogu:',
			CityHcPrivateLink_bar: 'privatne klinike u Baru',
			CityHcLabs_bar:
				'Mnoge privatne laboratorije primaju uz plaćanje za uobičajene rutinske analize bez uputa, ali specijalizovani testovi mogu tražiti nalog, pripremu ili termin. Provjerite direktno. Unesene analize i dostupne cijene su u odjeljku',
			CityHcLabsLink_bar: 'analize u Baru',
			CityHcPharmacy1_bar:
				'Apoteke su raspoređene po centru i Šušnju; učesnici četa često preporučuju apoteku Lenapharm u Šušnju, gdje se možete sporazumjeti i na ruskom.',
			CityHcPharmacy2_bar:
				'Radno vrijeme i dežurstva mijenjaju se, pa otvorenu apoteku provjerite direktno ili kroz zvanične lokalne podatke. Ne idite u hitni prijem samo radi redovnog lijeka; hitna pomoć je za akutnu medicinsku potrebu. Izdavanje na recept prati crnogorska pravila, a strani recept nije garancija.',
			CityHcCtaButton_bar: 'Klinike u Baru',
		},
		'sr-cyrl': {
			// Заједнички
			CityHcToc_overview: 'Шта град нуди',
			CityHcToc_emergency: 'Хитна помоћ',
			CityHcToc_state: 'Државно здравство',
			CityHcToc_private: 'Приватне клинике и лабораторије',
			CityHcToc_pharmacies: 'Апотеке и дежурне службе',
			CityHcEmergencyShared:
				'Код медицинске хитности позовите 124 или 112. Диспечер процјењује хитност и одлучује да ли шаље екипу или савјетује долазак у хитну помоћ. Не претпостављајте да је самостални пут бржи или безбједан: слиједите упутства и не возите код отежаног дисања, бола у грудима, губитка свијести, тешке повреде, напада, знакова можданог удара или брзог погоршања.',
			CityHcLinkEnd: '.',
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
				'Приватни сектор је добро развијен: у граду раде приватне поликлинике, лабораторије и стоматолошке ординације, а у многима се можете споразумјети на енглеском или руском. Болничко лијечење и сложена дијагностика значе пут до Котора или Подгорице.',
			CityHcEmergency1_budva:
				'Хитна помоћ у Будви налази се при Дому здравља и ради нон-стоп. Према искуствима из четова, прима и дјецу — са дјететом можете доћи директно.',
			CityHcEmergency2_budva:
				'Код озбиљних повреда и стања која захтијевају хоспитализацију, пацијенти се из Будве упућују у болницу у Котору (око пола сата вожње) или у Клинички центар Црне Горе у Подгорици. Упут издаје љекар хитне помоћи.',
			CityHcState1_budva:
				'Дом здравља Будва је државна установа примарне заштите: изабрани доктори, педијатрија, лабораторија и интервенције. За власнике здравствене књижице прегледи су бесплатни или готово бесплатни.',
			CityHcState2_budva:
				'Љети при дому здравља ради туристичка амбуланта — прегледи уз плаћање за госте без књижице. Дом здравља организује и сезонску вакцинацију против грипа, као и повремене бесплатне акције, нпр. тестирање на ХИВ и хепатитисе.',
			CityHcState3_budva:
				'Болничко лијечење становници Будве добијају у Општој болници Котор и у Клиничком центру у Подгорици. За планиране прегледе по књижици потребан је упут изабраног доктора.',
			CityHcPrivate1_budva:
				'Приватних клиника и лабораторија у Будви има много: од општих поликлиника до стоматологије и офталмологије. У чету на руском језику најчешће се помињу лабораторија Moj Lab и клинике Milmedika и BonoMedica — све су у нашем каталогу.',
			CityHcPrivateCatalog_budva:
				'Актуелни списак са адресама, цијенама и рецензијама налази се у каталогу:',
			CityHcPrivateLink_budva: 'приватне клинике у Будви',
			CityHcLabs_budva:
				'Многе приватне лабораторије примају уз плаћање за уобичајене рутинске анализе без упута, али специјализовани тестови могу тражити налог, припрему или термин. Провјерите директно. Унесене анализе и доступне цијене су у одјељку',
			CityHcLabsLink_budva: 'анализе у Будви',
			CityHcPharmacy1_budva:
				'Апотека у Будви има много, а у сезони већина ради сваког дана. Љекови на рецепт (прије свега антибиотици) формално се издају уз рецепт црногорског љекара — може га издати и љекар приватне клинике.',
			CityHcPharmacy2_budva:
				'Радно вријеме и дежурства апотека мијењају се сезонски; не ослањајте се на чет или наведену нон-стоп апотеку без провјере истог дана. Позовите апотеку или питајте дом здравља. Апотека не замјењује хитну медицинску процјену.',
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
			CityHcPrivate1_podgorica:
				'Избор приватне медицине у Подгорици је најшири: приватне болнице са хирургијом и магнетном резонанцом (у чету се најчешће помињу Codra Hospital и поликлинике Hipokrat), лабораторије Moj Lab, Milmedika, Poliklinika Filipović и десеци других.',
			CityHcPrivateCatalog_podgorica:
				'Комплетан списак са цијенама и рецензијама је у каталогу:',
			CityHcPrivateLink_podgorica: 'приватне клинике у Подгорици',
			CityHcLabs_podgorica:
				'Многе приватне лабораторије примају уз плаћање за уобичајене рутинске анализе без упута, али специјализовани тестови могу тражити налог, припрему или термин. Провјерите директно. Унесене анализе и доступне цијене су у одјељку',
			CityHcLabsLink_podgorica: 'анализе у Подгорици',
			CityHcPharmacy1_podgorica:
				'Подгорица има државне и приватне апотеке, али ноћно дежурство и локација могу се мијењати. Провјерите радно вријеме истог дана директно или кроз локалне званичне информације, не преко старог нон-стоп списка.',
			CityHcPharmacy2_podgorica:
				'Љекови на рецепт траже рецепт важећи по црногорским правилима. Страни рецепт може бити прихваћен у појединачном случају, али не гарантује издавање и фармацеут може одбити; када је континуитет важан, организујте локалну процјену љекара.',
			CityHcCtaButton_podgorica: 'Клинике у Подгорици',

			// Котор
			CityHcTitle_kotor:
				'Здравство у Котору: општа болница, дом здравља и хитна помоћ',
			CityHcDescription_kotor:
				'Медицинска помоћ у Котору: хитна 124, Општа болница Котор која покрива цијелу Боку, Дом здравља Котор, специјална болница у Рисну, приватне лабораторије и апотеке.',
			CityHcOverview1_kotor:
				'Котор је медицински центар Боке Которске: ту се налази Општа болница Котор, која покрива цијело подручје залива, укључујући Тиват, Будву и Херцег Нови. Примарну заштиту пружа Дом здравља Котор са службом хитне помоћи.',
			CityHcOverview2_kotor:
				'У оближњем Рисну ради специјална државна болница „Васо Ћуковић" — ортопедија, неурохирургија и неурологија — у коју долазе пацијенти из цијеле земље. Приватни сектор је скромнији него у Будви или Подгорици, али лабораторија и приватних љекара има.',
			CityHcEmergency1_kotor:
				'У хитним случајевима идите у хитну помоћ при Дому здравља Котор или директно на пријемно одјељење которске болнице: овамо се са приморја довозе повреде, дјечја ургентна стања и инфекције (болница има дјечје и инфективно одјељење).',
			CityHcEmergency2_kotor:
				'Имајте у виду: за странце без здравствене књижице и осигурања болничко лијечење се плаћа по цјеновнику, а рачуни за стационар могу бити високи. Ако имате полису, унапријед провјерите процедуру са осигуравачем; предрачун можете тражити прије почетка лијечења.',
			CityHcState1_kotor:
				'Општа болница Котор је вишеспецијалистички стационар: хирургија, педијатрија, гинекологија, инфективно одјељење, рендген. Овамо упућују домови здравља Будве, Тивта и Херцег Новог.',
			CityHcState2_kotor:
				'Дом здравља Котор је државна установа примарне заштите: изабрани доктор, педијатар, лабораторија. Уз здравствену књижицу прегледи су бесплатни, а рецепте за љекове са листе издаје изабрани доктор.',
			CityHcState3_kotor:
				'Специјална болница „Васо Ћуковић" у Рисну, на краткој вожњи уз залив, државни је центар за ортопедију, неурохирургију и неурологију. У Котору се налази и државна специјална психијатријска болница.',
			CityHcPrivate1_kotor:
				'Од приватних служби у четовима се најчешће помиње лабораторија SmartMed у Котору; у Радановићима (општина Котор) ради поликлиника Hipokrat са магнетном резонанцом. По шири избор приватних специјалиста становници Котора обично иду у Будву или Подгорицу.',
			CityHcPrivateCatalog_kotor:
				'Шта постоји у самом граду погледајте у каталогу:',
			CityHcPrivateLink_kotor: 'приватне клинике у Котору',
			CityHcLabs_kotor:
				'Многе приватне лабораторије примају уз плаћање за уобичајене рутинске анализе без упута, али специјализовани тестови могу тражити налог, припрему или термин. Провјерите директно. Унесене анализе и доступне цијене су у одјељку',
			CityHcLabsLink_kotor: 'анализе у Котору',
			CityHcPharmacy1_kotor:
				'Апотеке раде у Старом граду и новијим дјеловима; у сезони је радно вријеме дуже. Нон-стоп апотеке у Котору можда нема — залиху сталних љекова држите код куће.',
			CityHcPharmacy2_kotor:
				'Радно вријеме и дежурства мијењају се, нарочито сезонски. Провјерите отворену апотеку директно или кроз званичне локалне податке; не ослањајте се на тврдњу да нон-стоп апотеке сигурно нема. За редовну терапију држите закониту залиху, а код акутних симптома користите медицинску службу.',
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
				'Дом здравља Бар је примарни ниво: изабрани доктор, педијатрија, лабораторија, вакцинација (укључујући неке вакцине за путнике).',
			CityHcState3_bar:
				'Специјалистички прегледи којих нема у Бару раде се по упуту у Подгорици — Клинички центар је на око сат времена вожње.',
			CityHcPrivate1_bar:
				'Од приватних установа у четовима се најчешће помињу поликлиника Novi Standard, дневна болница Dr Zejnilović и Medical Vraneš; има много приватних стоматолога. У Сутомору приватна болница A3 Medical нуди CT и магнетну резонанцу.',
			CityHcPrivateCatalog_bar:
				'Комплетан списак са цијенама и рецензијама је у каталогу:',
			CityHcPrivateLink_bar: 'приватне клинике у Бару',
			CityHcLabs_bar:
				'Многе приватне лабораторије примају уз плаћање за уобичајене рутинске анализе без упута, али специјализовани тестови могу тражити налог, припрему или термин. Провјерите директно. Унесене анализе и доступне цијене су у одјељку',
			CityHcLabsLink_bar: 'анализе у Бару',
			CityHcPharmacy1_bar:
				'Апотеке су распоређене по центру и Шушњу; учесници чета често препоручују апотеку Lenapharm у Шушњу, гдје се можете споразумјети и на руском.',
			CityHcPharmacy2_bar:
				'Радно вријеме и дежурства мијењају се, па отворену апотеку провјерите директно или кроз званичне локалне податке. Не идите у хитни пријем само ради редовног лијека; хитна помоћ је за акутну медицинску потребу. Издавање на рецепт прати црногорска правила, а страни рецепт није гаранција.',
			CityHcCtaButton_bar: 'Клинике у Бару',
		},
		de: {
			// Gemeinsam
			CityHcToc_overview: 'Was die Stadt bietet',
			CityHcToc_emergency: 'Notfallversorgung',
			CityHcToc_state: 'Staatliche Medizin',
			CityHcToc_private: 'Private Kliniken und Labore',
			CityHcToc_pharmacies: 'Apotheken und Notdienste',
			CityHcEmergencyShared:
				'Bei medizinischem Notfall 124 oder 112 anrufen. Der Disponent beurteilt die Dringlichkeit und entscheidet über Einsatz oder Anfahrt zur hitna pomoć. Gehen Sie nicht davon aus, dass eigenes Fahren schneller oder sicher ist: Anweisungen folgen und bei Atemnot, Brustschmerz, Bewusstlosigkeit, schwerer Verletzung, Krampfanfall, Schlaganfallzeichen oder rascher Verschlechterung nicht selbst fahren.',
			CityHcLinkEnd: '.',
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
				'Der private Sektor ist gut entwickelt: In der Stadt arbeiten private Polikliniken, Labore und Zahnarztpraxen, in vielen kann man sich auf Englisch oder Russisch verständigen. Stationäre Behandlung und aufwendige Diagnostik bedeuten eine Fahrt nach Kotor oder Podgorica.',
			CityHcEmergency1_budva:
				'Die Notaufnahme (hitna pomoć) in Budva befindet sich am Dom zdravlja und arbeitet rund um die Uhr. Nach Berichten aus Expat-Chats werden dort auch Kinder behandelt — mit einem Kind können Sie direkt hinfahren.',
			CityHcEmergency2_budva:
				'Bei schweren Verletzungen und stationär zu behandelnden Zuständen werden Patienten aus Budva ins Krankenhaus Kotor (etwa eine halbe Stunde) oder ins Klinische Zentrum Montenegros in Podgorica überwiesen. Die Überweisung (uputnica) stellt der Arzt der hitna pomoć aus.',
			CityHcState1_budva:
				'Das Dom zdravlja Budva ist das staatliche Gesundheitszentrum: Hausärzte (izabrani doktor), Pädiatrie, Labor und Behandlungsräume. Für Inhaber der Gesundheitskarte zdravstvena knjižica sind Besuche kostenlos oder fast kostenlos.',
			CityHcState2_budva:
				'Im Sommer arbeitet dort eine Touristenambulanz (turistička ambulanta) — kostenpflichtige Termine für Gäste ohne Gesundheitskarte. Außerdem gibt es saisonale Grippeimpfungen und gelegentlich kostenlose Aktionen, etwa HIV- und Hepatitis-Tests.',
			CityHcState3_budva:
				'Krankenhausversorgung erhalten die Einwohner Budvas im Allgemeinen Krankenhaus Kotor und im Klinischen Zentrum in Podgorica. Geplante Untersuchungen über die Gesundheitskarte erfordern eine Überweisung des gewählten Arztes.',
			CityHcPrivate1_budva:
				'Private Kliniken und Labore gibt es in Budva viele — von allgemeinen Polikliniken bis zu Zahnmedizin und Augenheilkunde. Im russischsprachigen Chat werden am häufigsten das Labor Moj Lab sowie die Kliniken Milmedika und BonoMedica genannt — alle sind in unserem Katalog.',
			CityHcPrivateCatalog_budva:
				'Die aktuelle Liste mit Adressen, Preisen und Bewertungen finden Sie im Katalog:',
			CityHcPrivateLink_budva: 'Privatkliniken in Budva',
			CityHcLabs_budva:
				'Viele Privatlabore nehmen Selbstzahler für übliche Routinetests ohne Überweisung an; Spezialtests können jedoch Anordnung, Vorbereitung oder Termin erfordern. Direkt bestätigen. Eingetragene Tests und verfügbare Preise stehen im Bereich',
			CityHcLabsLink_budva: 'Laboranalysen in Budva',
			CityHcPharmacy1_budva:
				'Apotheken gibt es in Budva viele, in der Saison arbeiten die meisten täglich. Verschreibungspflichtige Medikamente (vor allem Antibiotika) erfordern formal ein Rezept eines montenegrinischen Arztes — auch ein Arzt einer Privatklinik kann es ausstellen.',
			CityHcPharmacy2_budva:
				'Apothekenzeiten und Bereitschaft ändern sich saisonal; nicht ohne tagesaktuelle Bestätigung auf Chatbericht oder genannte 24-Stunden-Apotheke vertrauen. Direkt bei der Apotheke oder dem dom zdravlja nachfragen. Eine Apotheke ersetzt keine Notfalluntersuchung.',
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
			CityHcPrivate1_podgorica:
				'Die Auswahl an privater Medizin ist in Podgorica am größten: Privatkrankenhäuser mit Chirurgie und MRT (im Chat werden am häufigsten Codra Hospital und die Hipokrat-Polikliniken genannt), die Labore Moj Lab, Milmedika, Poliklinika Filipović und Dutzende weitere.',
			CityHcPrivateCatalog_podgorica:
				'Die vollständige Liste mit Preisen und Bewertungen finden Sie im Katalog:',
			CityHcPrivateLink_podgorica: 'Privatkliniken in Podgorica',
			CityHcLabs_podgorica:
				'Viele Privatlabore nehmen Selbstzahler für übliche Routinetests ohne Überweisung an; Spezialtests können jedoch Anordnung, Vorbereitung oder Termin erfordern. Direkt bestätigen. Eingetragene Tests und verfügbare Preise stehen im Bereich',
			CityHcLabsLink_podgorica: 'Laboranalysen in Podgorica',
			CityHcPharmacy1_podgorica:
				'Podgorica hat staatliche und private Apotheken, doch Nachtdienst und Standort können wechseln. Öffnung am selben Tag direkt oder über lokale amtliche Information prüfen, nicht über eine alte 24-Stunden-Liste.',
			CityHcPharmacy2_podgorica:
				'Rezeptpflichtige Arzneimittel erfordern ein nach montenegrinischen Regeln gültiges Rezept. Ein ausländisches Rezept kann im Einzelfall akzeptiert werden, garantiert aber keine Abgabe und der Apotheker kann ablehnen; bei wichtiger Therapiefortsetzung lokale ärztliche Beurteilung organisieren.',
			CityHcCtaButton_podgorica: 'Kliniken in Podgorica',

			// Kotor
			CityHcTitle_kotor:
				'Medizin in Kotor: Allgemeines Krankenhaus, Dom zdravlja und Notfallhilfe',
			CityHcDescription_kotor:
				'Medizinische Hilfe in Kotor: Notruf 124, das Allgemeine Krankenhaus Kotor für die ganze Boka-Bucht, Dom zdravlja Kotor, die Spezialklinik in Risan, private Labore und Apotheken.',
			CityHcOverview1_kotor:
				'Kotor ist das medizinische Zentrum der Bucht von Kotor: Hier befindet sich das Allgemeine Krankenhaus Kotor (Opšta bolnica Kotor), das die gesamte Küstenregion einschließlich Tivat, Budva und Herceg Novi versorgt. Die Grundversorgung übernimmt das Dom zdravlja Kotor mit Rettungsdienst.',
			CityHcOverview2_kotor:
				'Im nahen Risan arbeitet die staatliche Spezialklinik Vaso Ćuković für Orthopädie, Neurochirurgie und Neurologie, die Patienten aus dem ganzen Land aufnimmt. Der private Sektor ist bescheidener als in Budva oder Podgorica, aber Labore und Privatärzte sind vorhanden.',
			CityHcEmergency1_kotor:
				'Im Notfall: hitna pomoć am Dom zdravlja Kotor oder direkt die Aufnahme des Krankenhauses Kotor — hierhin werden Verletzungen, pädiatrische Notfälle und Infektionen von der ganzen Küste gebracht (das Krankenhaus hat eine Kinder- und eine Infektionsabteilung).',
			CityHcEmergency2_kotor:
				'Beachten Sie: Für Ausländer ohne Gesundheitskarte und Versicherung ist die Krankenhausbehandlung nach Preisliste kostenpflichtig, und stationäre Rechnungen können erheblich sein. Mit einer Police klären Sie das Vorgehen vorab mit dem Versicherer; einen Kostenvoranschlag können Sie vor Behandlungsbeginn verlangen.',
			CityHcState1_kotor:
				'Das Allgemeine Krankenhaus Kotor ist ein Krankenhaus mit vielen Fachabteilungen: Chirurgie, Pädiatrie, Gynäkologie, Infektionsabteilung, Röntgen. Hierhin überweisen die Gesundheitszentren von Budva, Tivat und Herceg Novi.',
			CityHcState2_kotor:
				'Das Dom zdravlja Kotor ist das staatliche Gesundheitszentrum: gewählter Arzt, Kinderarzt, Labor. Mit der Gesundheitskarte sind Besuche kostenlos; Rezepte für subventionierte Medikamente stellt der gewählte Arzt aus.',
			CityHcState3_kotor:
				'Die Spezialklinik Vaso Ćuković in Risan, eine kurze Fahrt die Bucht entlang, ist das nationale Zentrum für Orthopädie, Neurochirurgie und Neurologie. In Kotor gibt es außerdem die staatliche psychiatrische Spezialklinik.',
			CityHcPrivate1_kotor:
				'Von den privaten Angeboten wird im Chat am häufigsten das Labor SmartMed in Kotor genannt; in Radanovići (Gemeinde Kotor) arbeitet eine Hipokrat-Poliklinik mit MRT. Für eine größere Auswahl privater Spezialisten fahren die Einwohner Kotors meist nach Budva oder Podgorica.',
			CityHcPrivateCatalog_kotor:
				'Was es in der Stadt selbst gibt, sehen Sie im Katalog:',
			CityHcPrivateLink_kotor: 'Privatkliniken in Kotor',
			CityHcLabs_kotor:
				'Viele Privatlabore nehmen Selbstzahler für übliche Routinetests ohne Überweisung an; Spezialtests können jedoch Anordnung, Vorbereitung oder Termin erfordern. Direkt bestätigen. Eingetragene Tests und verfügbare Preise stehen im Bereich',
			CityHcLabsLink_kotor: 'Laboranalysen in Kotor',
			CityHcPharmacy1_kotor:
				'Apotheken gibt es in der Altstadt und in den neueren Vierteln; in der Saison sind die Öffnungszeiten länger. Eine 24-Stunden-Apotheke gibt es in Kotor möglicherweise nicht — halten Sie einen Vorrat Ihrer Dauermedikamente zu Hause.',
			CityHcPharmacy2_kotor:
				'Öffnungszeiten und Bereitschaft ändern sich, besonders saisonal. Offene Apotheke direkt oder über amtliche lokale Angaben prüfen; nicht auf die Aussage vertrauen, es gebe sicher keinen Nachtdienst. Für Dauertherapie einen legalen Vorrat planen und bei akuten Symptomen medizinische Hilfe nutzen.',
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
				'Das Dom zdravlja Bar ist die Grundversorgung: gewählter Arzt, Pädiatrie, Labor, Impfungen (einschließlich einiger Reiseimpfungen).',
			CityHcState3_bar:
				'Spezialuntersuchungen, die es in Bar nicht gibt, werden per Überweisung in Podgorica gemacht — das Klinische Zentrum ist rund eine Stunde entfernt.',
			CityHcPrivate1_bar:
				'Von den privaten Einrichtungen nennt der Chat am häufigsten die Poliklinik Novi Standard, die Tagesklinik Dr Zejnilović und Medical Vraneš; dazu viele private Zahnarztpraxen. In Sutomore bietet das private Krankenhaus A3 Medical CT und MRT an.',
			CityHcPrivateCatalog_bar:
				'Die vollständige Liste mit Preisen und Bewertungen finden Sie im Katalog:',
			CityHcPrivateLink_bar: 'Privatkliniken in Bar',
			CityHcLabs_bar:
				'Viele Privatlabore nehmen Selbstzahler für übliche Routinetests ohne Überweisung an; Spezialtests können jedoch Anordnung, Vorbereitung oder Termin erfordern. Direkt bestätigen. Eingetragene Tests und verfügbare Preise stehen im Bereich',
			CityHcLabsLink_bar: 'Laboranalysen in Bar',
			CityHcPharmacy1_bar:
				'Apotheken verteilen sich über das Zentrum und Šušanj; Chat-Teilnehmer empfehlen oft die Apotheke Lenapharm in Šušanj, wo man sich auch auf Russisch verständigen kann.',
			CityHcPharmacy2_bar:
				'Öffnungszeiten und Bereitschaft ändern sich; offene Apotheke direkt oder amtlich prüfen. Nicht nur für ein reguläres Arzneimittel zur Notaufnahme gehen; Notfallversorgung ist für akuten medizinischen Bedarf. Rezeptabgabe folgt montenegrinischen Regeln, ein ausländisches Rezept ist keine Garantie.',
			CityHcCtaButton_bar: 'Kliniken in Bar',
		},
		tr: {
			// Ortak
			CityHcToc_overview: 'Şehirde neler var',
			CityHcToc_emergency: 'Acil yardım',
			CityHcToc_state: 'Devlet sağlık hizmetleri',
			CityHcToc_private: 'Özel klinikler ve laboratuvarlar',
			CityHcToc_pharmacies: 'Eczaneler ve nöbetçi hizmetler',
			CityHcEmergencyShared:
				'Tıbbi acilde 124 veya 112 numarasını arayın. Operatör aciliyeti değerlendirip ekip veya hitna pomoć noktasına gidiş önerisine karar verir. Kendi imkânınızla gitmenin her zaman hızlı veya güvenli olduğunu varsaymayın: talimatları izleyin ve nefes darlığı, göğüs ağrısı, bilinç kaybı, ağır yaralanma, nöbet, inme belirtisi veya hızlı kötüleşmede araç kullanmayın.',
			CityHcLinkEnd: '.',
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
				"Özel sektör iyi gelişmiştir: şehirde özel poliklinikler, laboratuvarlar ve diş klinikleri çalışır; birçoğunda İngilizce veya Rusça anlaşabilirsiniz. Yatarak tedavi ve ileri teşhis için Kotor'a veya Podgorica'ya gitmek gerekir.",
			CityHcEmergency1_budva:
				"Budva'daki acil servis (hitna pomoć) Dom zdravlja binasındadır ve gece gündüz çalışır. Sohbet gruplarındaki deneyimlere göre çocuklar da kabul edilir — çocuğunuzla doğrudan gidebilirsiniz.",
			CityHcEmergency2_budva:
				"Ciddi yaralanmalarda ve hastane yatışı gerektiren durumlarda hastalar Budva'dan Kotor'daki hastaneye (yaklaşık yarım saat) veya Podgorica'daki Karadağ Klinik Merkezi'ne sevk edilir. Sevk belgesini (uputnica) hitna pomoć doktoru verir.",
			CityHcState1_budva:
				'Dom zdravlja Budva devlet birinci basamak merkezidir: aile hekimleri (izabrani doktor), pediatri, laboratuvar ve müdahale odaları. Sağlık kartı (zdravstvena knjižica) sahipleri için muayeneler ücretsiz veya sembolik ücretlidir.',
			CityHcState2_budva:
				'Yazın burada turist polikliniği çalışır — kartı olmayan ziyaretçiler için ücretli muayene. Dom zdravlja ayrıca mevsimlik grip aşısı ve zaman zaman HIV ile hepatit testi gibi ücretsiz kampanyalar düzenler.',
			CityHcState3_budva:
				"Budva sakinleri hastane tedavisini Kotor Genel Hastanesi'nde ve Podgorica'daki Klinik Merkez'de alır. Kartla planlı tetkikler için seçili doktorun sevki gerekir.",
			CityHcPrivate1_budva:
				"Budva'da çok sayıda özel klinik ve laboratuvar vardır: genel polikliniklerden diş hekimliği ve göz kliniklerine kadar. Rusça sohbet grubunda en sık Moj Lab laboratuvarı ile Milmedika ve BonoMedica klinikleri anılır — hepsi kataloğumuzdadır.",
			CityHcPrivateCatalog_budva:
				'Adresler, fiyatlar ve yorumlarla güncel liste katalogda:',
			CityHcPrivateLink_budva: "Budva'daki özel klinikler",
			CityHcLabs_budva:
				'Birçok özel laboratuvar yaygın rutin testlerde kendi ödeyen hastaları sevksiz kabul eder; uzman testler istem, hazırlık veya randevu gerektirebilir. Doğrudan doğrulayın. Kayıtlı testler ve mevcut fiyatlar şu bölümde',
			CityHcLabsLink_budva: "Budva'da tahliller",
			CityHcPharmacy1_budva:
				"Budva'da çok eczane vardır; sezonda çoğu her gün açıktır. Reçeteli ilaçlar (özellikle antibiyotikler) resmen Karadağlı bir doktorun reçetesiyle satılır — özel klinik doktoru da yazabilir.",
			CityHcPharmacy2_budva:
				'Eczane saatleri ve nöbet listesi mevsime göre değişir; aynı gün doğrulamadan sohbet bildirimi veya adı verilen gece eczanesine güvenmeyin. Eczaneyi ya da dom zdravlja kurumunu arayın. Eczane acil değerlendirmenin yerini tutmaz.',
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
			CityHcPrivate1_podgorica:
				"Podgorica'da özel tıp seçenekleri en geniştir: cerrahi ve MR yapılan özel hastaneler (sohbette en sık Codra Hospital ve Hipokrat poliklinikleri anılır), Moj Lab laboratuvarları, Milmedika, Poliklinika Filipović ve onlarcası.",
			CityHcPrivateCatalog_podgorica:
				'Kayıtlı klinikler, mevcut fiyatlar ve yorumlar katalogdadır; kapsam tam değildir, hizmeti doğrudan doğrulayın:',
			CityHcPrivateLink_podgorica: "Podgorica'daki özel klinikler",
			CityHcLabs_podgorica:
				'Birçok özel laboratuvar yaygın rutin testlerde kendi ödeyen hastaları sevksiz kabul eder; uzman testler istem, hazırlık veya randevu gerektirebilir. Doğrudan doğrulayın. Kayıtlı testler ve mevcut fiyatlar şu bölümde',
			CityHcLabsLink_podgorica: "Podgorica'da tahliller",
			CityHcPharmacy1_podgorica:
				'Podgorica devlet ve özel eczanelere sahiptir, ancak gece nöbeti ve konumu değişebilir. Aynı gün saatleri doğrudan veya yerel resmi bilgiden doğrulayın; eski gece listesine güvenmeyin.',
			CityHcPharmacy2_podgorica:
				'Reçeteli ilaçlar Karadağ kurallarına uygun geçerli reçete gerektirir. Yabancı reçete tekil durumda kabul edilebilir, ancak ilacın verilmesini garanti etmez ve eczacı reddedebilir; tedavi devamlılığı önemliyse yerel hekim değerlendirmesi planlayın.',
			CityHcCtaButton_podgorica: 'Podgorica klinikleri',

			// Kotor
			CityHcTitle_kotor:
				"Kotor'da sağlık hizmetleri: genel hastane, Dom zdravlja ve acil yardım",
			CityHcDescription_kotor:
				"Kotor'da tıbbi yardım: ambulans 124, tüm Boka körfezine hizmet veren Kotor Genel Hastanesi, Dom zdravlja Kotor, Risan'daki ihtisas hastanesi, özel laboratuvarlar ve eczaneler.",
			CityHcOverview1_kotor:
				'Kotor, Boka Kotorska körfezinin tıp merkezidir: Tivat, Budva ve Herceg Novi dahil tüm körfez bölgesine hizmet veren Kotor Genel Hastanesi (Opšta bolnica Kotor) buradadır. Birinci basamak hizmeti, acil servisiyle Dom zdravlja Kotor verir.',
			CityHcOverview2_kotor:
				"Yakındaki Risan'da ortopedi, beyin cerrahisi ve nöroloji alanında uzmanlaşmış, ülkenin her yerinden hasta kabul eden devlet ihtisas hastanesi Vaso Ćuković çalışır. Özel sektör Budva veya Podgorica'ya göre mütevazıdır, ancak laboratuvarlar ve özel doktorlar vardır.",
			CityHcEmergency1_kotor:
				"Acil durumda Dom zdravlja Kotor'daki hitna pomoć'a veya doğrudan Kotor hastanesinin acil kabulüne gidin: kıyı boyunca yaralanmalar, çocuk acilleri ve enfeksiyonlar buraya getirilir (hastanede çocuk ve enfeksiyon servisleri vardır).",
			CityHcEmergency2_kotor:
				'Dikkat: sağlık kartı ve sigortası olmayan yabancılar için hastane tedavisi fiyat listesine göre ücretlidir ve yatış faturaları yüklü olabilir. Poliçeniz varsa başvuru prosedürünü sigortacınızla önceden netleştirin; tedaviye başlamadan maliyet tahmini isteyebilirsiniz.',
			CityHcState1_kotor:
				'Kotor Genel Hastanesi çok branşlı bir hastanedir: cerrahi, pediatri, jinekoloji, enfeksiyon servisi, röntgen. Budva, Tivat ve Herceg Novi sağlık merkezleri hastaları buraya sevk eder.',
			CityHcState2_kotor:
				'Dom zdravlja Kotor devlet birinci basamak merkezidir: seçili doktor, çocuk doktoru, laboratuvar. Sağlık kartıyla muayeneler ücretsizdir; listedeki ilaçların reçetesini seçili doktor yazar.',
			CityHcState3_kotor:
				"Körfez boyunca kısa bir sürüş mesafesindeki Risan'daki Vaso Ćuković ihtisas hastanesi, ortopedi, beyin cerrahisi ve nörolojide ulusal merkezdir. Kotor'da ayrıca devlet ihtisas psikiyatri hastanesi bulunur.",
			CityHcPrivate1_kotor:
				"Özel hizmetlerden sohbetlerde en sık Kotor'daki SmartMed laboratuvarı anılır; Radanovići'de (Kotor belediyesi) MR yapılan bir Hipokrat polikliniği çalışır. Daha geniş özel uzman seçeneği için Kotorlular genellikle Budva'ya veya Podgorica'ya gider.",
			CityHcPrivateCatalog_kotor:
				'Şehrin kendisinde ne olduğunu katalogda görün:',
			CityHcPrivateLink_kotor: "Kotor'daki özel klinikler",
			CityHcLabs_kotor:
				'Birçok özel laboratuvar yaygın rutin testlerde kendi ödeyen hastaları sevksiz kabul eder; uzman testler istem, hazırlık veya randevu gerektirebilir. Doğrudan doğrulayın. Kayıtlı testler ve mevcut fiyatlar şu bölümde',
			CityHcLabsLink_kotor: "Kotor'da tahliller",
			CityHcPharmacy1_kotor:
				"Eczaneler Eski Şehir'de ve yeni semtlerde çalışır; sezonda çalışma saatleri uzar. Kotor'da gece açık eczane olmayabilir — düzenli ilaçlarınızın yedeğini evde bulundurun.",
			CityHcPharmacy2_kotor:
				'Saatler ve nöbetler özellikle mevsimsel değişir. Açık eczaneyi doğrudan veya yerel resmi bilgiden doğrulayın; gece eczanesi kesinlikle yoktur sözüne güvenmeyin. Sürekli tedavi için yasal stok planlayın, akut belirtide tıbbi hizmet kullanın.',
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
				'Dom zdravlja Bar birinci basamaktır: seçili doktor, pediatri, laboratuvar, aşılama (bazı seyahat aşıları dahil).',
			CityHcState3_bar:
				"Bar'da olmayan uzmanlık tetkikleri sevkle Podgorica'da yapılır — Klinik Merkez yaklaşık bir saat uzaklıktadır.",
			CityHcPrivate1_bar:
				"Özel kurumlardan sohbetlerde en sık Novi Standard polikliniği, Dr Zejnilović gündüz hastanesi ve Medical Vraneš anılır; çok sayıda özel diş kliniği vardır. Sutomore'deki özel A3 Medical hastanesi BT ve MR sunar.",
			CityHcPrivateCatalog_bar:
				'Kayıtlı klinikler, mevcut fiyatlar ve yorumlar katalogdadır; kapsam tam değildir, hizmeti doğrudan doğrulayın:',
			CityHcPrivateLink_bar: "Bar'daki özel klinikler",
			CityHcLabs_bar:
				'Birçok özel laboratuvar yaygın rutin testlerde kendi ödeyen hastaları sevksiz kabul eder; uzman testler istem, hazırlık veya randevu gerektirebilir. Doğrudan doğrulayın. Kayıtlı testler ve mevcut fiyatlar şu bölümde',
			CityHcLabsLink_bar: "Bar'da tahliller",
			CityHcPharmacy1_bar:
				"Eczaneler merkezde ve Šušanj'da bulunur; sohbet üyeleri Rusça anlaşılabilen Šušanj'daki Lenapharm eczanesini sık önerir.",
			CityHcPharmacy2_bar:
				'Saatler ve nöbetler değişir; açık eczaneyi doğrudan veya resmi yerel bilgiden doğrulayın. Yalnız rutin ilaç için acil servise gitmeyin; acil bakım akut tıbbi gereksinim içindir. Reçeteli verme Karadağ kurallarına tabidir ve yabancı reçete garanti değildir.',
			CityHcCtaButton_bar: 'Bar klinikleri',
		},
	},
};
