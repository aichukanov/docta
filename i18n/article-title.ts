// Только ЗАГОЛОВКИ статей — для группы «Статьи» в глобальном поиске.
//
// Поиск живёт в первом экране главной и печатает заголовок статьи
// (`ARTICLE_SEARCH.titleKey`, common/articles.ts). Раньше ради этих
// восемнадцати строк он статически импортировал пять словарей целиком —
// `articles`, `article-medications-unavailable`, `article-allergy-medicines`,
// `article-city-healthcare`, `article-weekend-medical-help` — то есть ПОЛНЫЕ
// ТЕКСТЫ статей на шести локалях: 347 КБ raw (102 КБ gzip) из 882 КБ веса
// лендинга. Заголовки переехали сюда, тексты остались на своих страницах.
//
// Файл СГЕНЕРИРОВАН из тех же словарей и обязан совпадать с ними дословно:
// второго названия у статьи быть не должно (см. i18n/article-search.ts).
// Расхождение ловит tests/unit/article-slugs.spec.ts — он сверяет каждый ключ
// в каждой локали с исходным словарём и падает на лишних ключах.
// Меняешь заголовок статьи — правь ОБА файла.
export default {
	messages: {
		'en': {
			UnaTitle:
				"Medications you won't find in Montenegro: your usual home first-aid kit",
			AlgTitle:
				'Allergy medicines in Montenegro: what to take instead of Zyrtec',
			PharmaciesTitle:
				'Pharmacies and medications in Montenegro: prescriptions, analogs, what to bring',
			BirthInMontenegroTitle:
				'Giving Birth in Montenegro: State Maternity Ward or Private Clinic',
			ResidenceInsuranceTitle:
				'Health insurance for a residence permit in Montenegro',
			ChildHealthcareTitle:
				'A child in Montenegro: pediatricians, vaccinations, kindergarten and school certificates',
			MentalHealthTitle:
				'Psychologists, psychiatrists and antidepressants in Montenegro',
			DentistryTitle:
				'Dentistry in Montenegro: prices, clinics and what state insurance covers',
			LabTestsArticleTitle:
				'Lab Tests and Check-ups in Montenegro: Labs, Prices and Referrals',
			TouristHealthcareTitle:
				'Getting sick on holiday in Montenegro: where tourists can get help',
			WeekendMedicalHelpTitle:
				'Pharmacies and clinics in Montenegro open on weekends',
			HealthcareSystemTitle:
				'How healthcare works in Montenegro: a guide for expats',
			RussianSpeakingDoctorsTitle: 'Russian-speaking doctors in Montenegro',
			ClinicsWithLanguageSupportTitle:
				'Clinics with multilingual support in Montenegro',
			CityHcTitle_budva:
				'Healthcare in Budva: emergency care, Dom zdravlja and private clinics',
			CityHcTitle_podgorica:
				'Healthcare in Podgorica: Clinical Center, emergency care and private clinics',
			CityHcTitle_kotor:
				'Healthcare in Kotor: general hospital, Dom zdravlja and emergency care',
			CityHcTitle_bar:
				'Healthcare in Bar: hospital, Dom zdravlja and private clinics',
		},
		'ru': {
			UnaTitle:
				'Чего нет в аптеках Черногории: привычные лекарства из России и Украины',
			AlgTitle: 'Чем заменить Зиртек в Черногории: антигистаминные в аптеках',
			PharmaciesTitle:
				'Аптеки и лекарства в Черногории: рецепты, аналоги, что взять с собой',
			BirthInMontenegroTitle:
				'Роды в Черногории: государственный роддом или частная клиника',
			ResidenceInsuranceTitle: 'Медицинская страховка для ВНЖ в Черногории',
			ChildHealthcareTitle:
				'Ребёнок в Черногории: педиатры, прививки, справки в сад и школу',
			MentalHealthTitle: 'Психологи, психиатры и антидепрессанты в Черногории',
			DentistryTitle:
				'Стоматология в Черногории: цены, клиники и что покрывает книжица',
			LabTestsArticleTitle:
				'Анализы и чекапы в Черногории: лаборатории, цены и направления',
			TouristHealthcareTitle:
				'Заболел в отпуске в Черногории: куда обращаться туристу',
			WeekendMedicalHelpTitle:
				'Аптеки и клиники в Черногории, открытые в выходные',
			HealthcareSystemTitle:
				'Как устроена медицина в Черногории: гид для переехавших',
			RussianSpeakingDoctorsTitle: 'Русскоязычные врачи в Черногории',
			ClinicsWithLanguageSupportTitle:
				'Клиники с языковой поддержкой в Черногории',
			CityHcTitle_budva:
				'Медицина в Будве: скорая, Dom zdravlja и частные клиники',
			CityHcTitle_podgorica:
				'Медицина в Подгорице: Клинический центр, скорая и частные клиники',
			CityHcTitle_kotor:
				'Медицина в Которе: больница, Dom zdravlja и скорая помощь',
			CityHcTitle_bar:
				'Медицина в Баре: больница, Dom zdravlja и частные клиники',
		},
		'sr': {
			UnaTitle:
				'Ljekovi koje nećete naći u Crnoj Gori: vaša uobičajena kućna apoteka',
			AlgTitle:
				'Čime zamijeniti Zyrtec u Crnoj Gori: antihistaminici u apotekama',
			PharmaciesTitle:
				'Apoteke i ljekovi u Crnoj Gori: recepti, analozi, šta ponijeti sa sobom',
			BirthInMontenegroTitle:
				'Porođaj u Crnoj Gori: državno porodilište ili privatna klinika',
			ResidenceInsuranceTitle: 'Zdravstveno osiguranje za boravak u Crnoj Gori',
			ChildHealthcareTitle:
				'Dijete u Crnoj Gori: pedijatri, vakcine, potvrde za vrtić i školu',
			MentalHealthTitle: 'Psiholozi, psihijatri i antidepresivi u Crnoj Gori',
			DentistryTitle:
				'Stomatologija u Crnoj Gori: cijene, klinike i šta pokriva zdravstvena knjižica',
			LabTestsArticleTitle:
				'Analize i check-up u Crnoj Gori: laboratorije, cijene i uputi',
			TouristHealthcareTitle:
				'Bolest na odmoru u Crnoj Gori: gdje turista može dobiti pomoć',
			WeekendMedicalHelpTitle:
				'Apoteke i klinike u Crnoj Gori otvorene vikendom',
			HealthcareSystemTitle:
				'Kako funkcioniše zdravstvo u Crnoj Gori: vodič za strance',
			RussianSpeakingDoctorsTitle: 'Doktori koji govore ruski u Crnoj Gori',
			ClinicsWithLanguageSupportTitle:
				'Klinike sa višejezičnom podrškom u Crnoj Gori',
			CityHcTitle_budva:
				'Zdravstvo u Budvi: hitna pomoć, dom zdravlja i privatne klinike',
			CityHcTitle_podgorica:
				'Zdravstvo u Podgorici: Klinički centar, hitna pomoć i privatne klinike',
			CityHcTitle_kotor:
				'Zdravstvo u Kotoru: opšta bolnica, dom zdravlja i hitna pomoć',
			CityHcTitle_bar:
				'Zdravstvo u Baru: bolnica, dom zdravlja i privatne klinike',
		},
		'sr-cyrl': {
			UnaTitle:
				'Љекови које нећете наћи у Црној Гори: ваша уобичајена кућна апотека',
			AlgTitle:
				'Чиме замијенити Zyrtec у Црној Гори: антихистаминици у апотекама',
			PharmaciesTitle:
				'Апотеке и љекови у Црној Гори: рецепти, аналози, шта понијети са собом',
			BirthInMontenegroTitle:
				'Порођај у Црној Гори: државно породилиште или приватна клиника',
			ResidenceInsuranceTitle: 'Здравствено осигурање за боравак у Црној Гори',
			ChildHealthcareTitle:
				'Дијете у Црној Гори: педијатри, вакцине, потврде за вртић и школу',
			MentalHealthTitle: 'Психолози, психијатри и антидепресиви у Црној Гори',
			DentistryTitle:
				'Стоматологија у Црној Гори: цијене, клинике и шта покрива здравствена књижица',
			LabTestsArticleTitle:
				'Анализе и check-up у Црној Гори: лабораторије, цијене и упути',
			TouristHealthcareTitle:
				'Болест на одмору у Црној Гори: гдје туриста може добити помоћ',
			WeekendMedicalHelpTitle:
				'Апотеке и клинике у Црној Гори отворене викендом',
			HealthcareSystemTitle:
				'Како функционише здравство у Црној Гори: водич за странце',
			RussianSpeakingDoctorsTitle: 'Доктори који говоре руски у Црној Гори',
			ClinicsWithLanguageSupportTitle:
				'Клинике са вишејезичном подршком у Црној Гори',
			CityHcTitle_budva:
				'Здравство у Будви: хитна помоћ, дом здравља и приватне клинике',
			CityHcTitle_podgorica:
				'Здравство у Подгорици: Клинички центар, хитна помоћ и приватне клинике',
			CityHcTitle_kotor:
				'Здравство у Котору: општа болница, дом здравља и хитна помоћ',
			CityHcTitle_bar:
				'Здравство у Бару: болница, дом здравља и приватне клинике',
		},
		'de': {
			UnaTitle:
				'Medikamente, die Sie in Montenegro nicht finden: Ihre gewohnte Hausapotheke',
			AlgTitle:
				'Zyrtec in Montenegro ersetzen: Antihistaminika in den Apotheken',
			PharmaciesTitle:
				'Apotheken und Medikamente in Montenegro: Rezepte, Generika, was man mitnehmen sollte',
			BirthInMontenegroTitle:
				'Entbindung in Montenegro: staatliche Geburtsstation oder Privatklinik',
			ResidenceInsuranceTitle:
				'Krankenversicherung für die Aufenthaltsgenehmigung in Montenegro',
			ChildHealthcareTitle:
				'Kind in Montenegro: Kinderärzte, Impfungen, Atteste für Kindergarten und Schule',
			MentalHealthTitle:
				'Psychologen, Psychiater und Antidepressiva in Montenegro',
			DentistryTitle:
				'Zahnmedizin in Montenegro: Preise, Kliniken und was die staatliche Versicherung abdeckt',
			LabTestsArticleTitle:
				'Laboranalysen und Check-ups in Montenegro: Labore, Preise und Überweisungen',
			TouristHealthcareTitle:
				'Krank im Urlaub in Montenegro: Wohin als Tourist?',
			WeekendMedicalHelpTitle:
				'Apotheken und Kliniken in Montenegro, die am Wochenende geöffnet haben',
			HealthcareSystemTitle:
				'So funktioniert das Gesundheitswesen in Montenegro: ein Leitfaden für Zugezogene',
			RussianSpeakingDoctorsTitle: 'Russischsprachige Ärzte in Montenegro',
			ClinicsWithLanguageSupportTitle:
				'Kliniken mit mehrsprachiger Unterstützung in Montenegro',
			CityHcTitle_budva:
				'Medizin in Budva: Notfallhilfe, Dom zdravlja und Privatkliniken',
			CityHcTitle_podgorica:
				'Medizin in Podgorica: Klinisches Zentrum, Notfallhilfe und Privatkliniken',
			CityHcTitle_kotor:
				'Medizin in Kotor: Allgemeines Krankenhaus, Dom zdravlja und Notfallhilfe',
			CityHcTitle_bar:
				'Medizin in Bar: Krankenhaus, Dom zdravlja und Privatkliniken',
		},
		'tr': {
			UnaTitle:
				"Karadağ'da bulamayacağınız ilaçlar: alıştığınız evdeki ilaç dolabı",
			AlgTitle:
				'Karadağ’da Zyrtec yerine ne var: eczanelerde antihistaminikler',
			PharmaciesTitle:
				"Karadağ'da eczaneler ve ilaçlar: reçeteler, muadiller, yanınızda ne getirmelisiniz",
			BirthInMontenegroTitle:
				"Karadağ'da Doğum: Devlet Doğumhanesi mi, Özel Klinik mi",
			ResidenceInsuranceTitle: 'Karadağ oturum izni için sağlık sigortası',
			ChildHealthcareTitle:
				"Karadağ'da çocuk: çocuk doktorları, aşılar, kreş ve okul raporları",
			MentalHealthTitle:
				'Karadağ’da psikologlar, psikiyatristler ve antidepresanlar',
			DentistryTitle:
				"Karadağ'da diş hekimliği: fiyatlar, klinikler ve devlet sigortasının kapsadıkları",
			LabTestsArticleTitle:
				'Karadağ Tahlilleri ve Check-up: Laboratuvarlar, Fiyatlar ve Sevk',
			TouristHealthcareTitle:
				"Karadağ'da tatilde hastalanmak: turist nereye başvurmalı",
			WeekendMedicalHelpTitle:
				"Karadağ'da hafta sonu açık eczaneler ve klinikler",
			HealthcareSystemTitle:
				"Karadağ'da sağlık sistemi nasıl işler: yeni taşınanlar için rehber",
			RussianSpeakingDoctorsTitle: "Karadağ'da Rusça konuşan doktorlar",
			ClinicsWithLanguageSupportTitle:
				"Karadağ'da çok dilli destek sunan klinikler",
			CityHcTitle_budva:
				"Budva'da sağlık hizmetleri: acil yardım, Dom zdravlja ve özel klinikler",
			CityHcTitle_podgorica:
				"Podgorica'da sağlık hizmetleri: Klinik Merkez, acil yardım ve özel klinikler",
			CityHcTitle_kotor:
				"Kotor'da sağlık hizmetleri: genel hastane, Dom zdravlja ve acil yardım",
			CityHcTitle_bar:
				"Bar'da sağlık hizmetleri: hastane, Dom zdravlja ve özel klinikler",
		},
	},
};
