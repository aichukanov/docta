// Контент статьи «Как устроена медицина в Черногории».
// Факты сверены с законом об обязательном медстраховании («Sl. list CG» 145/21, 048/24),
// инструкцией FZOCG для иностранных застрахованных и данными
// русскоязычных чатов о реальном опыте (2023–2026). Актуальность: июль 2026.
export default {
	messages: {
		en: {
			HcsToc_emergency: 'Emergency care: dial 124',
			'HcsToc_state-system': 'How the state system works',
			HcsToc_knjizica: 'Zdravstvena knjižica: who is entitled',
			'HcsToc_without-knjizica': 'No health card? Paid options',
			HcsToc_foreigners: 'EU citizens and bilateral agreements',
			HcsToc_insurance: 'Private health insurance',
			HcsToc_medications: 'Medications and prescriptions',
			HcsToc_sources: 'Useful contacts and sources',

			HcsEmergency1:
				'The emergency medical number in Montenegro is 124 (police — 122, fire — 123; the European 112 also works and redirects to local services). Emergency medical units (hitna pomoć) operate at the dom zdravlja health centers in every municipality.',
			HcsEmergency2:
				'The emergency dispatcher assesses the call and decides whether to send a team or advise attendance at a hitna pomoć point. Do not judge urgency by fever alone: call 124 or 112 for breathing difficulty, chest pain, severe injury, loss of consciousness, seizures, signs of stroke or rapid deterioration, follow the instructions, and do not drive yourself if unsafe.',
			HcsEmergency3:
				'For serious conditions the main destination is the Urgentni centar of the Clinical Center of Montenegro (KCCG) in Podgorica, open 24/7. On the coast, acute cases go to the emergency rooms of the general hospitals (Kotor, Bar) or the hitna pomoć unit at the local dom zdravlja.',
			HcsEmergency4:
				'State emergency services will not turn you away over citizenship or insurance status: care comes first, and an uninsured patient is billed afterwards at the official DRG tariffs — the same ones listed in our catalog of medical services and prices.',

			HcsState1:
				'Public healthcare has three tiers, plus specialized hospitals (orthopedics in Risan, pulmonology in Brezovik, psychiatry in Dobrota):',
			HcsStateLevel1:
				'Dom zdravlja — the primary care center in every municipality: GPs, pediatricians, gynecologists, basic diagnostics, vaccinations;',
			HcsStateLevel2:
				'Opšta bolnica — general hospitals in Bar, Kotor, Nikšić, Berane, Bijelo Polje, Cetinje and Pljevlja;',
			HcsStateLevel3:
				'Klinički centar Crne Gore (KCCG) in Podgorica — the country’s main multi-specialty hospital, where complex cases are referred.',
			HcsState2:
				'Primary care is built around the izabrani doktor — the chosen GP you register with at your dom zdravlja. They treat you, issue prescriptions and referrals (uput) to specialists and diagnostics, and book specialist appointments for you. Queues exist for some specialists and scans; waiting lists are published by hospitals and the insurance fund.',
			HcsState3:
				'The system is largely digital: the eZdravlje portal (ezdravlje.me) offers online booking, e-prescriptions (paper prescriptions are essentially phased out) and lab results. Insurance status is checked electronically, and since 2020 a Montenegrin electronic ID card can replace the paper health booklet.',

			HcsKnjizica1:
				'The zdravstvena knjižica (the “green booklet”) is the document of a person insured with the Health Insurance Fund of Montenegro (FZOCG). Since 1 January 2022 health-insurance contributions have been abolished (the “Europe Now” reform) — the system is financed from the state budget, but insured status is still defined by the insurance law (“Sl. list CG” 145/21).',
			HcsKnjizica2:
				'Who is entitled: Montenegrin citizens and foreigners with permanent or temporary residence who work in Montenegro — employees, entrepreneurs and self-employed — plus pensioners, registered unemployed and some other categories. Family members (spouse, children) holding a family-reunification residence permit are insured through the working family member.',
			HcsKnjizica3:
				'A residence permit based on property ownership, company ownership or digital-nomad status does not by itself give you the right to compulsory insurance. Before cancelling other cover, confirm your eligibility and the required documents directly with FZOCG.',
			HcsKnjizica4:
				'For employees, registration normally starts through the employer, followed by steps at FZOCG and primary care. Some services involve co-payments or are limited by the Fund’s medicine list. Confirm the current procedure and coverage with FZOCG, especially after a job or status change.',

			HcsWithout1:
				'No knjižica? Every dom zdravlja has a paid option — often called the turistička ambulanta — where the uninsured see a doctor at official rates, typically €25–30 per consultation. You cannot register with an izabrani doktor, but one-off visits are possible.',
			HcsWithout2:
				'Private clinics and practices are the everyday choice of most uninsured expats: a GP or specialist consultation costs €30–50, a comprehensive visit with ultrasound and lab tests around €80. Only a few private clinics have inpatient and surgical capacity (in Podgorica and Sutomore) — in an acute surgical emergency a private clinic will most likely redirect you to a state hospital.',
			HcsWithout3:
				'State institutions bill uninsured patients at official tariffs — you can browse them in our',
			HcsWithout3Link: 'catalog of medical services and prices',
			HcsWithout3End: '.',
			HcsWithout4:
				'Lab tests can be done in private laboratories without any referral — compare prices in the',
			HcsWithout4Link: 'lab tests catalog',
			HcsWithout4End: '.',

			HcsForeigners1:
				'Montenegro is not an EU member, so the European Health Insurance Card (EHIC) as such is not valid here. However, Montenegro has bilateral social-security agreements: citizens insured in Serbia, Slovenia, Croatia, Bosnia and Herzegovina, North Macedonia, Austria, Germany, Czechia, Slovakia, Hungary, the Netherlands, Belgium, Luxembourg, Italy, Turkey and Bulgaria receive urgent care in Montenegrin state facilities at the expense of their home insurance fund.',
			HcsForeigners2:
				'How it works: before travelling, obtain a certificate from your home fund (e.g. form SRB/MNE 111 in Serbia, ČR/YU 111 in Czechia; German, Austrian, Slovenian and Luxembourgish insured can simply use their EHIC as the entitlement document). In Montenegro exchange it at the local FZOCG branch for the INO 1 health list, then use state institutions like a local patient. In a genuine emergency hospitals must treat you first and let you regularize paperwork afterwards.',
			HcsForeigners3:
				'Planned treatment under an agreement normally needs prior authorisation. Before travelling, confirm the required forms and the reimbursement route with your home fund and FZOCG.',
			HcsForeigners4:
				'Russia, Ukraine, Kazakhstan and other CIS countries have no healthcare agreement with Montenegro. Citizens of these countries rely on paid medicine or private insurance unless they work in Montenegro and hold state insurance.',

			HcsInsurance1:
				'Price, limits, exclusions and waiting periods for a private policy depend on the insurer, age, medical history and package. Before buying, check three things: exclusions for pre-existing and chronic conditions, waiting periods, and the deductible. A policy accepted as residence-permit evidence is not necessarily comprehensive health cover.',
			HcsInsurance2:
				'Direct billing and reimbursement depend on the insurer, provider and prior authorisation; state or private ownership alone does not determine the route. Get written confirmation of the provider, service, documents, payment method, bank-account requirements and deadline. For tourists, it’s worth comparing policies by assistance service, exclusions and coverage limits.',

			HcsMedications1:
				'Antibiotics, psychotropics and other prescription medicines require a valid prescription under Montenegrin rules. A foreign prescription isn’t officially recognised, but in practice some pharmacies do accept one — that’s a pattern expats report in local chats; how consistent it is varies by pharmacy. For antibiotics, psychotropics or any ongoing therapy, it’s more reliable to plan a local doctor’s consultation and get a Montenegrin prescription. The doctor independently decides whether to prescribe, change the plan or refer. Covered medicines are dispensed by pharmacies contracted with the Fund, not only Montefarm; verify each medicine in our registry.',
			HcsMedications2:
				'Availability and prices of specific drugs in Montenegro can be checked in our',
			HcsMedications2Link: 'medications catalog',
			HcsMedications2End: '.',

			HcsSources0:
				'The information is current as of July 2026. Rules change — for decisions that matter, verify with official sources:',
			HcsSourcesPhones:
				'Emergency numbers: 124 — ambulance, 122 — police, 123 — fire, 112 — single European number;',
			HcsSourcesFzo:
				'Health Insurance Fund of Montenegro (FZOCG) — insurance rules and bilateral-agreement procedures: fzocg.me;',
			HcsSourcesEzdravlje:
				'eZdravlje portal — online booking, e-prescriptions, insurance status: ezdravlje.me;',
			HcsSourcesWaiting:
				'Hospital waiting lists — published by FZOCG and the Clinical Center: kccg.me;',
			HcsSourcesGovUk:
				'UK residents — official guidance on reciprocal healthcare with Montenegro: gov.uk.',
			HcsSourcesCatalog:
				'Looking for a specific doctor or clinic? Our catalog covers doctors with language filters —',
			HcsSourcesCatalogLink: 'find a doctor who speaks your language',
			HcsSourcesCatalogEnd: '.',
		},
		ru: {
			HcsToc_emergency: 'Экстренная помощь: номер 124',
			'HcsToc_state-system': 'Как устроена государственная система',
			HcsToc_knjizica: 'Zdravstvena knjižica: кому положена',
			'HcsToc_without-knjizica': 'Без книжицы: платные варианты',
			HcsToc_foreigners: 'Граждане ЕС и межгосударственные соглашения',
			HcsToc_insurance: 'Частные страховки',
			HcsToc_medications: 'Лекарства и рецепты',
			HcsToc_sources: 'Полезные контакты и источники',

			HcsEmergency1:
				'Номер скорой помощи в Черногории — 124 (полиция — 122, пожарные — 123; общеевропейский 112 тоже работает и переключает на местные службы). Отделения скорой (hitna pomoć) работают при домах здравля в каждом муниципалитете.',
			HcsEmergency2:
				'Срочность оценивает диспетчер: он решает, направить ли бригаду или рекомендовать поездку в hitna pomoć. Не оценивайте тяжесть только по температуре: при затруднённом дыхании, боли в груди, тяжёлой травме, потере сознания, судорогах, признаках инсульта или быстром ухудшении звоните 124 или 112, выполняйте инструкции и не садитесь за руль, если это небезопасно.',
			HcsEmergency3:
				'При серьёзных состояниях основной адрес — Urgentni centar Клинического центра Черногории (KCCG) в Подгорице, он работает круглосуточно. На побережье с острыми случаями едут в приёмные отделения общих больниц (Котор, Бар) или в hitna pomoć при местном доме здравля.',
			HcsEmergency4:
				'Государственная неотложная помощь не откажет из-за гражданства или отсутствия страховки: помощь оказывают сразу, а счёт незастрахованному пациенту выставляют потом — по официальным тарифам Фонда (DRG), которые можно посмотреть в нашем каталоге медицинских услуг и цен.',

			HcsState1:
				'Государственная медицина устроена в три уровня, плюс специализированные больницы (ортопедия в Рисане, пульмонология в Брезовике, психиатрия в Доброте):',
			HcsStateLevel1:
				'Dom zdravlja — центр первичной помощи в каждом муниципалитете: терапевты, педиатры, гинекологи, базовая диагностика, прививки;',
			HcsStateLevel2:
				'Opšta bolnica — общие больницы в Баре, Которе, Никшиче, Беране, Биело-Поле, Цетине и Плевле;',
			HcsStateLevel3:
				'Klinički centar Crne Gore (KCCG) в Подгорице — главная многопрофильная больница страны, куда направляют сложные случаи.',
			HcsState2:
				'Первичное звено построено вокруг izabrani doktor — «выбранного врача», к которому вы прикрепляетесь в своём доме здравля. Он лечит, выписывает рецепты и направления (uput) к специалистам и на диагностику, сам записывает вас к специалисту. К отдельным специалистам и обследованиям есть очереди; списки ожидания больницы и фонд публикуют открыто.',
			HcsState3:
				'Система в значительной мере цифровая: портал eZdravlje (ezdravlje.me) — запись к врачу, электронные рецепты (бумажные практически выведены из оборота), результаты анализов. Статус страховки проверяется электронно, а с 2020 года вместо бумажной книжицы можно активировать черногорскую электронную личную карту.',

			HcsKnjizica1:
				'Zdravstvena knjižica («зелёная книжица») — документ застрахованного в Фонде медицинского страхования Черногории (FZOCG). С 1 января 2022 года взносы на медстрахование отменены (реформа «Европа сейчас») — система финансируется из бюджета, но круг застрахованных по-прежнему определяет закон об обязательном медицинском страховании («Sl. list CG» 145/21).',
			HcsKnjizica2:
				'Кому положена: гражданам Черногории и иностранцам с постоянным или временным ВНЖ, которые работают в стране — наёмным работникам, предпринимателям, самозанятым; а также пенсионерам, зарегистрированным безработным и ряду других категорий. Члены семьи (супруг, дети) с ВНЖ по воссоединению семьи страхуются «через» работающего члена семьи.',
			HcsKnjizica3:
				'ВНЖ по недвижимости, владение фирмой или статус цифрового кочевника сами по себе не дают права на обязательное страхование. До отказа от другой страховки подтвердите своё право и список документов непосредственно в FZOCG.',
			HcsKnjizica4:
				'Для работника регистрация обычно начинается через работодателя, затем оформляются шаги в FZOCG и в первичной помощи. Часть услуг предполагает доплаты или ограничена списком лекарств Фонда. Уточняйте процедуру и покрытие в FZOCG, особенно после смены работы или статуса.',

			HcsWithout1:
				'Нет книжицы? В каждом доме здравля есть платный приём для незастрахованных — его часто называют «туристической амбулантой»: консультация по официальному тарифу, обычно 25–30 €. Прикрепиться к izabrani doktor без книжицы нельзя, но разово попасть к врачу — можно.',
			HcsWithout2:
				'Частные клиники и ординации — повседневный выбор большинства незастрахованных переехавших: приём терапевта или специалиста стоит 30–50 €, комплексный визит с УЗИ и анализами — около 80 €. Стационар и операционные есть лишь у нескольких частных клиник (в Подгорице и Сутоморе) — при остром хирургическом состоянии частная клиника, скорее всего, перенаправит вас в государственную больницу.',
			HcsWithout3:
				'Государственные учреждения выставляют незастрахованным счета по официальным тарифам — их можно посмотреть в нашем',
			HcsWithout3Link: 'каталоге медицинских услуг и цен',
			HcsWithout3End: '.',
			HcsWithout4:
				'Анализы можно сдать в частных лабораториях без всякого направления — цены удобно сравнить в',
			HcsWithout4Link: 'каталоге анализов',
			HcsWithout4End: '.',

			HcsForeigners1:
				'Черногория не входит в ЕС, поэтому европейская карта EHIC сама по себе здесь не действует. Зато у страны есть двусторонние соглашения о социальном обеспечении: застрахованным в Сербии, Словении, Хорватии, Боснии и Герцеговине, Северной Македонии, Австрии, Германии, Чехии, Словакии, Венгрии, Нидерландах, Бельгии, Люксембурге, Италии, Турции и Болгарии неотложную помощь в государственных учреждениях оказывают за счёт их домашнего фонда.',
			HcsForeigners2:
				'Как это работает: перед поездкой возьмите в своём фонде справку (например, форма SRB/MNE 111 в Сербии, ČR/YU 111 в Чехии; застрахованным в Германии, Австрии, Словении и Люксембурге достаточно их EHIC как документа-основания). В Черногории её обменивают в филиале FZOCG на форму INO 1 — и дальше вы обслуживаетесь в госучреждениях как местный пациент. В настоящей экстренной ситуации обязаны сначала оказать помощь, а бумаги оформить потом.',
			HcsForeigners3:
				'Плановое лечение по соглашению обычно требует предварительного разрешения. До поездки уточните нужные формы и порядок возмещения у домашнего фонда и FZOCG.',
			HcsForeigners4:
				'России, Украины, Казахстана и других стран СНГ в этих списках нет — действующих соглашений о медицинской помощи с Черногорией у них не существует. Гражданам этих стран остаётся платная медицина или частная страховка — либо государственная страховка через работу в Черногории.',

			HcsInsurance1:
				'Цена, лимиты, исключения и периоды ожидания частного полиса зависят от страховщика, возраста, анамнеза и пакета. Перед покупкой проверьте три вещи: исключения для уже имеющихся и хронических болезней, периоды ожидания и франшизу. Полис, который МУП принимает как документ для ВНЖ, не обязательно даёт широкое медицинское покрытие.',
			HcsInsurance2:
				'Прямой расчёт и возмещение зависят от страховщика, учреждения и предварительного согласования; принадлежность клиники к государственному или частному сектору сама по себе не определяет маршрут. Получите письменное подтверждение клиники, услуги, документов, способа оплаты, требований к банковскому счёту и срока подачи. Туристам стоит сравнивать полисы по ассистансу, исключениям и лимитам покрытия.',

			HcsMedications1:
				'Антибиотики, психотропные и другие рецептурные препараты требуют действительного рецепта по правилам Черногории. Иностранный рецепт формально не признаётся, но на практике некоторые аптеки его всё же принимают — так сообщают пользователи русскоязычных чатов; насколько это распространено, зависит от конкретной аптеки. Для антибиотиков, психотропных препаратов и другой важной терапии надёжнее сразу спланировать консультацию местного врача и получить черногорский рецепт. Врач самостоятельно решает, выписать ли препарат, изменить схему или направить к специалисту. Покрываемые лекарства отпускают аптеки, работающие по договору с Фондом, а не только Montefarm; конкретный препарат проверяйте в нашем реестре.',
			HcsMedications2:
				'Наличие и цены конкретных препаратов в Черногории можно проверить в нашем',
			HcsMedications2Link: 'каталоге лекарств',
			HcsMedications2End: '.',

			HcsSources0:
				'Информация актуальна на июль 2026 года. Правила меняются — для важных решений сверяйтесь с официальными источниками:',
			HcsSourcesPhones:
				'Экстренные номера: 124 — скорая, 122 — полиция, 123 — пожарные, 112 — единый европейский номер;',
			HcsSourcesFzo:
				'Фонд медицинского страхования Черногории (FZOCG) — правила страхования и процедуры по межгосударственным соглашениям: fzocg.me;',
			HcsSourcesEzdravlje:
				'Портал eZdravlje — запись к врачу, электронные рецепты, проверка статуса страховки: ezdravlje.me;',
			HcsSourcesWaiting:
				'Списки ожидания в больницах — публикуют FZOCG и Клинический центр: kccg.me;',
			HcsSourcesGovUk:
				'Для жителей Великобритании — официальная памятка о взаимной медицинской помощи с Черногорией: gov.uk.',
			HcsSourcesCatalog:
				'Ищете конкретного врача или клинику? В нашем каталоге у врачей указаны языки приёма —',
			HcsSourcesCatalogLink: 'найдите врача, говорящего на вашем языке',
			HcsSourcesCatalogEnd: '.',
		},
		sr: {
			HcsToc_emergency: 'Hitna pomoć: broj 124',
			'HcsToc_state-system': 'Kako funkcioniše državni sistem',
			HcsToc_knjizica: 'Zdravstvena knjižica: ko ima pravo',
			'HcsToc_without-knjizica': 'Bez knjižice: plaćene opcije',
			HcsToc_foreigners: 'Državljani EU i međudržavni sporazumi',
			HcsToc_insurance: 'Privatna osiguranja',
			HcsToc_medications: 'Ljekovi i recepti',
			HcsToc_sources: 'Korisni kontakti i izvori',

			HcsEmergency1:
				'Broj hitne medicinske pomoći u Crnoj Gori je 124 (policija — 122, vatrogasci — 123; evropski broj 112 takođe radi i preusmjerava na lokalne službe). Jedinice hitne pomoći rade pri domovima zdravlja u svakoj opštini.',
			HcsEmergency2:
				'Dispečer procjenjuje poziv i odlučuje da li šalje ekipu ili savjetuje dolazak u hitnu pomoć. Ne procjenjujte hitnost samo po temperaturi: kod otežanog disanja, bola u grudima, teške povrede, gubitka svijesti, napada, znakova moždanog udara ili brzog pogoršanja pozovite 124 ili 112, slijedite uputstva i ne vozite sami ako nije bezbjedno.',
			HcsEmergency3:
				'Za ozbiljna stanja glavna adresa je Urgentni centar Kliničkog centra Crne Gore (KCCG) u Podgorici, otvoren 24/7. Na primorju se akutni slučajevi voze u prijemna odjeljenja opštih bolnica (Kotor, Bar) ili u hitnu pomoć pri lokalnom domu zdravlja.',
			HcsEmergency4:
				'Hitni pristup ne treba odlagati zbog državljanstva ili osiguranja, ali račun zavisi od važećeg prava, usluge i međunarodnog aranžmana. Ne pretpostavljajte da svaki osigurani pacijent ne plaća ništa. Cijena operacije koju je pacijent naveo 2023. nije tarifa; neosigurani treba da traži detaljan račun i provjeri pravo na refundaciju.',

			HcsState1:
				'Državno zdravstvo ima tri nivoa, uz specijalne bolnice (ortopedija u Risnu, plućne bolesti u Brezoviku, psihijatrija u Dobroti):',
			HcsStateLevel1:
				'Dom zdravlja — centar primarne zaštite u svakoj opštini: izabrani doktori za odrasle, pedijatri, ginekolozi, osnovna dijagnostika, vakcinacija;',
			HcsStateLevel2:
				'Opšta bolnica — u Baru, Kotoru, Nikšiću, Beranama, Bijelom Polju, Cetinju i Pljevljima;',
			HcsStateLevel3:
				'Klinički centar Crne Gore (KCCG) u Podgorici — glavna multidisciplinarna bolnica u koju se upućuju složeni slučajevi.',
			HcsState2:
				'Primarna zaštita počiva na izabranom doktoru kod koga se registrujete u svom domu zdravlja. On vas liječi, propisuje ljekove i izdaje upute za specijaliste i dijagnostiku, i sam zakazuje pregled kod specijaliste. Za pojedine specijaliste i preglede postoje redovi; liste čekanja bolnice i Fond javno objavljuju.',
			HcsState3:
				'Sistem je u velikoj mjeri digitalizovan: portal eZdravlje (ezdravlje.me) nudi eZakazivanje, eRecept (papirni recepti su praktično izbačeni iz upotrebe) i eNalaz. Status osiguranja se provjerava elektronski, a od 2020. umjesto papirne knjižice može se aktivirati elektronska lična karta.',

			HcsKnjizica1:
				'Zdravstvena knjižica je dokument osiguranika Fonda za zdravstveno osiguranje Crne Gore (FZOCG). Od 1. januara 2022. doprinosi za zdravstveno osiguranje su ukinuti (program „Evropa sad“) — sistem se finansira iz budžeta, ali krug osiguranika i dalje određuje Zakon o obaveznom zdravstvenom osiguranju („Sl. list CG“ 145/21).',
			HcsKnjizica2:
				'Ko ima pravo: crnogorski državljani i stranci sa stalnim ili privremenim boravkom koji rade u Crnoj Gori — zaposleni, preduzetnici i lica koja obavljaju samostalnu djelatnost; takođe penzioneri, nezaposleni na evidenciji Zavoda i još neke kategorije. Članovi porodice (supružnik, djeca) sa boravkom radi spajanja porodice osiguravaju se preko zaposlenog člana porodice.',
			HcsKnjizica3:
				'Pravo na obavezno osiguranje zavisi od važeće zakonske kategorije i činjenica konkretnog slučaja; boravak po osnovu nekretnine, vlasništvo firme ili status digitalnog nomada sami ne garantuju pokriće. Usklađivanje sa osiguranjem u drugoj državi i dokumenti koje traži FZOCG takođe zavise od primjenjivih pravila. Prije odjave drugog osiguranja provjerite pravo i dokumente direktno kod FZOCG.',
			HcsKnjizica4:
				'Za zaposlene registracija obično počinje preko poslodavca, zatim slijede koraci u FZOCG i primarnoj zaštiti. Prava zavise od aktivnog statusa, uputa, ugovorne ustanove, nacionalnog programa i liste ljekova Fonda; doplate i isključenja su mogući. Aktuelni postupak i pokriće provjerite kod FZOCG, naročito poslije promjene posla ili statusa.',

			HcsWithout1:
				'Nemate knjižicu? U svakom domu zdravlja postoji plaćeni pregled za neosigurane — često se zove turistička ambulanta: konsultacija po zvaničnoj tarifi, obično 25–30 €. Bez knjižice se ne možete registrovati kod izabranog doktora, ali pojedinačni pregledi su mogući.',
			HcsWithout2:
				'Privatne klinike i ordinacije svakodnevni su izbor većine neosiguranih stranaca: pregled ljekara opšte prakse ili specijaliste košta 30–50 €, kompletna posjeta sa ultrazvukom i analizama oko 80 €. Stacionar i operacione sale ima samo nekoliko privatnih klinika (u Podgorici i Sutomoru) — kod akutnog hirurškog stanja privatna klinika će vas najvjerovatnije preusmjeriti u državnu bolnicu.',
			HcsWithout3:
				'Državne ustanove neosiguranima naplaćuju po zvaničnim tarifama — možete ih pogledati u našem',
			HcsWithout3Link: 'katalogu medicinskih usluga i cijena',
			HcsWithout3End: '.',
			HcsWithout4:
				'Laboratorijske analize možete uraditi u privatnim laboratorijama bez ikakvog uputa — cijene uporedite u',
			HcsWithout4Link: 'katalogu analiza',
			HcsWithout4End: '.',

			HcsForeigners1:
				'Crna Gora nije članica EU, pa evropska kartica zdravstvenog osiguranja (EHIC) sama po sebi ovdje ne važi. Postoje, međutim, bilateralni sporazumi o socijalnom osiguranju: osiguranicima iz Srbije, Slovenije, Hrvatske, Bosne i Hercegovine, Sjeverne Makedonije, Austrije, Njemačke, Češke, Slovačke, Mađarske, Holandije, Belgije, Luksemburga, Italije, Turske i Bugarske hitna zdravstvena zaštita u državnim ustanovama pruža se na teret njihovog matičnog fonda.',
			HcsForeigners2:
				'Kako funkcioniše: prije putovanja uzmite potvrdu svog fonda (npr. obrazac SRB/MNE 111 u Srbiji, ČR/YU 111 u Češkoj; osiguranicima iz Njemačke, Austrije, Slovenije i Luksemburga dovoljna je njihova EHIC kartica). U Crnoj Gori se potvrda u filijali FZOCG zamjenjuje za zdravstveni list INO 1 — i dalje se liječite u državnim ustanovama kao domaći pacijent. U stvarnoj hitnoj situaciji prvo su dužni da vam pomognu, a papiri se sređuju naknadno.',
			HcsForeigners3:
				'Pokriće po uzajamnosti i sporazumima zavisi od države, osiguranog statusa, svrhe boravka, medicinske neophodnosti i dokumentacije. Planirano liječenje obično traži prethodno odobrenje, ali ne oslanjajte se na univerzalni novčani prag ili samo pasoš. Prije puta provjerite obrasce i refundaciju kod matičnog fonda i FZOCG.',
			HcsForeigners4:
				'Rusija, Ukrajina, Kazahstan i druge zemlje ZND nisu na ovim listama — važeći sporazumi o zdravstvenoj zaštiti sa Crnom Gorom ne postoje. Državljanima tih zemalja ostaje plaćena medicina ili privatno osiguranje — ili državno osiguranje preko zaposlenja u Crnoj Gori.',

			HcsInsurance1:
				'Cijena, limiti, isključenja i karence privatne polise zavise od osiguravača, godina, zdravstvene istorije i paketa; navedeni iznosi su samo orijentacioni. Provjerite pravila za postojeće i hronične bolesti, ljekove, trudnoću i porođaj, karence, franšizu, mrežu i refundaciju. Polisa prihvaćena kao dokaz za boravak nije nužno sveobuhvatno zdravstveno pokriće.',
			HcsInsurance2:
				'Direktno plaćanje i refundacija zavise od osiguravača, ustanove i prethodnog odobrenja; državno ili privatno vlasništvo samo ne određuje put. Tražite pisanu potvrdu ustanove, usluge, dokumenata, načina plaćanja, računa i roka. Turisti treba da porede asistenciju, isključenja i limite, a ne da jedan tip polise smatraju uvijek najboljim.',

			HcsMedications1:
				'Antibiotici, psihotropni i drugi ljekovi na recept zahtijevaju važeći recept po crnogorskim pravilima. Strani recept ne garantuje izdavanje: neki korisnici navode da ga je pojedina apoteka prihvatila, ali farmaceut može odbiti, pa planirajte lokalnu procjenu ljekara. Ljekar samostalno odlučuje da li propisuje, mijenja plan ili upućuje specijalisti. Pokrivene ljekove izdaju apoteke sa ugovorom sa Fondom, ne samo Montefarm; konkretan lijek provjerite u našem registru.',
			HcsMedications2:
				'Dostupnost i cijene konkretnih ljekova u Crnoj Gori provjerite u našem',
			HcsMedications2Link: 'katalogu ljekova',
			HcsMedications2End: '.',

			HcsSources0:
				'Informacije važe za jul 2026. Pravila se mijenjaju — za važne odluke provjerite zvanične izvore:',
			HcsSourcesPhones:
				'Brojevi za hitne slučajeve: 124 — hitna pomoć, 122 — policija, 123 — vatrogasci, 112 — jedinstveni evropski broj;',
			HcsSourcesFzo:
				'Fond za zdravstveno osiguranje Crne Gore (FZOCG) — pravila osiguranja i procedure po međudržavnim sporazumima: fzocg.me;',
			HcsSourcesEzdravlje:
				'Portal eZdravlje — zakazivanje, eRecept, provjera statusa osiguranja: ezdravlje.me;',
			HcsSourcesWaiting:
				'Liste čekanja u bolnicama — objavljuju FZOCG i Klinički centar: kccg.me;',
			HcsSourcesGovUk:
				'Za stanovnike Velike Britanije — zvanično uputstvo o recipročnoj zdravstvenoj zaštiti sa Crnom Gorom: gov.uk.',
			HcsSourcesCatalog:
				'Tražite određenog doktora ili kliniku? U našem katalogu doktori imaju oznake jezika —',
			HcsSourcesCatalogLink: 'pronađite doktora koji govori vaš jezik',
			HcsSourcesCatalogEnd: '.',
		},
		'sr-cyrl': {
			HcsToc_emergency: 'Хитна помоћ: број 124',
			'HcsToc_state-system': 'Како функционише државни систем',
			HcsToc_knjizica: 'Здравствена књижица: ко има право',
			'HcsToc_without-knjizica': 'Без књижице: плаћене опције',
			HcsToc_foreigners: 'Држављани ЕУ и међудржавни споразуми',
			HcsToc_insurance: 'Приватна осигурања',
			HcsToc_medications: 'Љекови и рецепти',
			HcsToc_sources: 'Корисни контакти и извори',

			HcsEmergency1:
				'Број хитне медицинске помоћи у Црној Гори је 124 (полиција — 122, ватрогасци — 123; европски број 112 такође ради и преусмјерава на локалне службе). Јединице хитне помоћи раде при домовима здравља у свакој општини.',
			HcsEmergency2:
				'Диспечер процјењује позив и одлучује да ли шаље екипу или савјетује долазак у хитну помоћ. Не процјењујте хитност само по температури: код отежаног дисања, бола у грудима, тешке повреде, губитка свијести, напада, знакова можданог удара или брзог погоршања позовите 124 или 112, слиједите упутства и не возите сами ако није безбједно.',
			HcsEmergency3:
				'За озбиљна стања главна адреса је Ургентни центар Клиничког центра Црне Горе (КЦЦГ) у Подгорици, отворен 24/7. На приморју се акутни случајеви возе у пријемна одјељења општих болница (Котор, Бар) или у хитну помоћ при локалном дому здравља.',
			HcsEmergency4:
				'Хитни приступ не треба одлагати због држављанства или осигурања, али рачун зависи од важећег права, услуге и међународног аранжмана. Не претпостављајте да сваки осигурани пацијент не плаћа ништа. Цијена операције коју је пацијент навео 2023. није тарифа; неосигурани треба да тражи детаљан рачун и провјери право на рефундацију.',

			HcsState1:
				'Државно здравство има три нивоа, уз специјалне болнице (ортопедија у Рисну, плућне болести у Брезовику, психијатрија у Доброти):',
			HcsStateLevel1:
				'Дом здравља — центар примарне заштите у свакој општини: изабрани доктори за одрасле, педијатри, гинеколози, основна дијагностика, вакцинација;',
			HcsStateLevel2:
				'Општа болница — у Бару, Котору, Никшићу, Беранама, Бијелом Пољу, Цетињу и Пљевљима;',
			HcsStateLevel3:
				'Клинички центар Црне Горе (КЦЦГ) у Подгорици — главна мултидисциплинарна болница у коју се упућују сложени случајеви.',
			HcsState2:
				'Примарна заштита почива на изабраном доктору код кога се региструјете у свом дому здравља. Он вас лијечи, прописује љекове и издаје упуте за специјалисте и дијагностику, и сам заказује преглед код специјалисте. За поједине специјалисте и прегледе постоје редови; листе чекања болнице и Фонд јавно објављују.',
			HcsState3:
				'Систем је у великој мјери дигитализован: портал eZdravlje (ezdravlje.me) нуди еЗаказивање, еРецепт (папирни рецепти су практично избачени из употребе) и еНалаз. Статус осигурања се провјерава електронски, а од 2020. умјесто папирне књижице може се активирати електронска лична карта.',

			HcsKnjizica1:
				'Здравствена књижица је документ осигураника Фонда за здравствено осигурање Црне Горе (ФЗОЦГ). Од 1. јануара 2022. доприноси за здравствено осигурање су укинути (програм „Европа сад“) — систем се финансира из буџета, али круг осигураника и даље одређује Закон о обавезном здравственом осигурању („Сл. лист ЦГ“ 145/21).',
			HcsKnjizica2:
				'Ко има право: црногорски држављани и странци са сталним или привременим боравком који раде у Црној Гори — запослени, предузетници и лица која обављају самосталну дјелатност; такође пензионери, незапослени на евиденцији Завода и још неке категорије. Чланови породице (супружник, дјеца) са боравком ради спајања породице осигуравају се преко запосленог члана породице.',
			HcsKnjizica3:
				'Право на обавезно осигурање зависи од важеће законске категорије и чињеница конкретног случаја; боравак по основу некретнине, власништво фирме или статус дигиталног номада сами не гарантују покриће. Усклађивање са осигурањем у другој држави и документи које тражи FZOCG такође зависе од примјењивих правила. Прије одјаве другог осигурања провјерите право и документе директно код FZOCG.',
			HcsKnjizica4:
				'За запослене регистрација обично почиње преко послодавца, затим слиједе кораци у FZOCG и примарној заштити. Права зависе од активног статуса, упута, уговорне установе, националног програма и листе љекова Фонда; доплате и искључења су могући. Актуелни поступак и покриће провјерите код FZOCG, нарочито послије промјене посла или статуса.',

			HcsWithout1:
				'Немате књижицу? У сваком дому здравља постоји плаћени преглед за неосигуране — често се зове туристичка амбуланта: консултација по званичној тарифи, обично 25–30 €. Без књижице се не можете регистровати код изабраног доктора, али појединачни прегледи су могући.',
			HcsWithout2:
				'Приватне клинике и ординације свакодневни су избор већине неосигураних странаца: преглед љекара опште праксе или специјалисте кошта 30–50 €, комплетна посјета са ултразвуком и анализама око 80 €. Стационар и операционе сале има само неколико приватних клиника (у Подгорици и Сутомору) — код акутног хируршког стања приватна клиника ће вас највјероватније преусмјерити у државну болницу.',
			HcsWithout3:
				'Државне установе неосигуранима наплаћују по званичним тарифама — можете их погледати у нашем',
			HcsWithout3Link: 'каталогу медицинских услуга и цијена',
			HcsWithout3End: '.',
			HcsWithout4:
				'Лабораторијске анализе можете урадити у приватним лабораторијама без икаквог упута — цијене упоредите у',
			HcsWithout4Link: 'каталогу анализа',
			HcsWithout4End: '.',

			HcsForeigners1:
				'Црна Гора није чланица ЕУ, па европска картица здравственог осигурања (EHIC) сама по себи овдје не важи. Постоје, међутим, билатерални споразуми о социјалном осигурању: осигураницима из Србије, Словеније, Хрватске, Босне и Херцеговине, Сјеверне Македоније, Аустрије, Њемачке, Чешке, Словачке, Мађарске, Холандије, Белгије, Луксембурга, Италије, Турске и Бугарске хитна здравствена заштита у државним установама пружа се на терет њиховог матичног фонда.',
			HcsForeigners2:
				'Како функционише: прије путовања узмите потврду свог фонда (нпр. образац SRB/MNE 111 у Србији, ČR/YU 111 у Чешкој; осигураницима из Њемачке, Аустрије, Словеније и Луксембурга довољна је њихова EHIC картица). У Црној Гори се потврда у филијали ФЗОЦГ замјењује за здравствени лист ИНО 1 — и даље се лијечите у државним установама као домаћи пацијент. У стварној хитној ситуацији прво су дужни да вам помогну, а папири се сређују накнадно.',
			HcsForeigners3:
				'Покриће по узајамности и споразумима зависи од државе, осигураног статуса, сврхе боравка, медицинске неопходности и документације. Планирано лијечење обично тражи претходно одобрење, али не ослањајте се на универзални новчани праг или само пасош. Прије пута провјерите обрасце и рефундацију код матичног фонда и FZOCG.',
			HcsForeigners4:
				'Русија, Украјина, Казахстан и друге земље ЗНД нису на овим листама — важећи споразуми о здравственој заштити са Црном Гором не постоје. Држављанима тих земаља остаје плаћена медицина или приватно осигурање — или државно осигурање преко запослења у Црној Гори.',

			HcsInsurance1:
				'Цијена, лимити, искључења и каренце приватне полисе зависе од осигуравача, година, здравствене историје и пакета; наведени износи су само оријентациони. Провјерите правила за постојеће и хроничне болести, љекове, трудноћу и порођај, каренце, франшизу, мрежу и рефундацију. Полиса прихваћена као доказ за боравак није нужно свеобухватно здравствено покриће.',
			HcsInsurance2:
				'Директно плаћање и рефундација зависе од осигуравача, установе и претходног одобрења; државно или приватно власништво само не одређује пут. Тражите писану потврду установе, услуге, докумената, начина плаћања, рачуна и рока. Туристи треба да пореде асистенцију, искључења и лимите, а не да један тип полисе сматрају увијек најбољим.',

			HcsMedications1:
				'Антибиотици, психотропни и други љекови на рецепт захтијевају важећи рецепт по црногорским правилима. Страни рецепт не гарантује издавање: неки корисници наводе да га је поједина апотека прихватила, али фармацеут може одбити, па планирајте локалну процјену љекара. Љекар самостално одлучује да ли прописује, мијења план или упућује специјалисти. Покривене љекове издају апотеке са уговором са Фондом, не само Montefarm; конкретан лијек провјерите у нашем регистру.',
			HcsMedications2:
				'Доступност и цијене конкретних љекова у Црној Гори провјерите у нашем',
			HcsMedications2Link: 'каталогу љекова',
			HcsMedications2End: '.',

			HcsSources0:
				'Информације важе за јул 2026. Правила се мијењају — за важне одлуке провјерите званичне изворе:',
			HcsSourcesPhones:
				'Бројеви за хитне случајеве: 124 — хитна помоћ, 122 — полиција, 123 — ватрогасци, 112 — јединствени европски број;',
			HcsSourcesFzo:
				'Фонд за здравствено осигурање Црне Горе (ФЗОЦГ) — правила осигурања и процедуре по међудржавним споразумима: fzocg.me;',
			HcsSourcesEzdravlje:
				'Портал eZdravlje — заказивање, еРецепт, провјера статуса осигурања: ezdravlje.me;',
			HcsSourcesWaiting:
				'Листе чекања у болницама — објављују ФЗОЦГ и Клинички центар: kccg.me;',
			HcsSourcesGovUk:
				'За становнике Велике Британије — званично упутство о реципрочној здравственој заштити са Црном Гором: gov.uk.',
			HcsSourcesCatalog:
				'Тражите одређеног доктора или клинику? У нашем каталогу доктори имају ознаке језика —',
			HcsSourcesCatalogLink: 'пронађите доктора који говори ваш језик',
			HcsSourcesCatalogEnd: '.',
		},
		de: {
			HcsToc_emergency: 'Notfallversorgung: Notruf 124',
			'HcsToc_state-system': 'So funktioniert das staatliche System',
			HcsToc_knjizica: 'Zdravstvena knjižica: Wer hat Anspruch',
			'HcsToc_without-knjizica': 'Ohne Gesundheitskarte: bezahlte Optionen',
			HcsToc_foreigners: 'EU-Bürger und bilaterale Abkommen',
			HcsToc_insurance: 'Private Krankenversicherungen',
			HcsToc_medications: 'Medikamente und Rezepte',
			HcsToc_sources: 'Nützliche Kontakte und Quellen',

			HcsEmergency1:
				'Die Notrufnummer des Rettungsdienstes in Montenegro ist 124 (Polizei — 122, Feuerwehr — 123; die europäische 112 funktioniert ebenfalls und leitet an die lokalen Dienste weiter). Die Rettungsstellen (hitna pomoć) sind den Gesundheitszentren (dom zdravlja) in jeder Gemeinde angegliedert.',
			HcsEmergency2:
				'Der Disponent beurteilt den Anruf und entscheidet über einen Einsatz oder empfiehlt den Weg zur hitna pomoć. Dringlichkeit nicht allein am Fieber messen: Bei Atemnot, Brustschmerz, schwerer Verletzung, Bewusstlosigkeit, Krampfanfällen, Schlaganfallzeichen oder rascher Verschlechterung 124 oder 112 anrufen, Anweisungen folgen und nicht selbst fahren, wenn dies unsicher wäre.',
			HcsEmergency3:
				'Bei ernsten Zuständen ist die wichtigste Adresse das Urgentni centar des Klinischen Zentrums von Montenegro (KCCG) in Podgorica, rund um die Uhr geöffnet. An der Küste fährt man mit akuten Fällen in die Notaufnahmen der allgemeinen Krankenhäuser (Kotor, Bar) oder zur hitna pomoć am örtlichen dom zdravlja.',
			HcsEmergency4:
				'Notfallzugang sollte nicht wegen Staatsangehörigkeit oder Versicherung verzögert werden; die Rechnung hängt jedoch von Anspruch, Leistung und Abkommen ab. Nicht annehmen, jeder Versicherte zahle nichts. Ein von Patienten genannter Operationspreis aus 2023 ist kein Tarif; Unversicherte sollten eine Einzelrechnung verlangen und Erstattungsrechte prüfen.',

			HcsState1:
				'Das staatliche Gesundheitswesen hat drei Ebenen, dazu Spezialkliniken (Orthopädie in Risan, Lungenheilkunde in Brezovik, Psychiatrie in Dobrota):',
			HcsStateLevel1:
				'Dom zdravlja — das Primärversorgungszentrum in jeder Gemeinde: Allgemeinärzte, Kinderärzte, Gynäkologen, Basisdiagnostik, Impfungen;',
			HcsStateLevel2:
				'Opšta bolnica — allgemeine Krankenhäuser in Bar, Kotor, Nikšić, Berane, Bijelo Polje, Cetinje und Pljevlja;',
			HcsStateLevel3:
				'Klinički centar Crne Gore (KCCG) in Podgorica — das wichtigste multidisziplinäre Krankenhaus des Landes, an das komplexe Fälle überwiesen werden.',
			HcsState2:
				'Die Primärversorgung ist um den izabrani doktor aufgebaut — den „gewählten Arzt“, bei dem Sie sich in Ihrem dom zdravlja registrieren. Er behandelt Sie, stellt Rezepte und Überweisungen (uput) zu Fachärzten und zur Diagnostik aus und vereinbart die Facharzttermine für Sie. Bei manchen Fachärzten und Untersuchungen gibt es Wartezeiten; die Wartelisten werden von Krankenhäusern und dem Fonds veröffentlicht.',
			HcsState3:
				'Das System ist weitgehend digital: Das Portal eZdravlje (ezdravlje.me) bietet Online-Terminbuchung, E-Rezepte (Papierrezepte sind praktisch abgeschafft) und Laborergebnisse. Der Versicherungsstatus wird elektronisch geprüft, und seit 2020 kann die elektronische Identitätskarte das papierne Gesundheitsheft ersetzen.',

			HcsKnjizica1:
				'Die zdravstvena knjižica (das „grüne Heft“) ist das Dokument eines Versicherten des montenegrinischen Krankenversicherungsfonds (FZOCG). Seit dem 1. Januar 2022 sind die Krankenversicherungsbeiträge abgeschafft (Reform „Europa jetzt“) — das System wird aus dem Staatshaushalt finanziert, den Kreis der Versicherten bestimmt aber weiterhin das Versicherungsgesetz („Sl. list CG“ 145/21).',
			HcsKnjizica2:
				'Anspruch haben: montenegrinische Staatsbürger und Ausländer mit dauerhaftem oder befristetem Aufenthalt, die in Montenegro arbeiten — Angestellte, Unternehmer und Selbständige; außerdem Rentner, gemeldete Arbeitslose und einige weitere Kategorien. Familienangehörige (Ehepartner, Kinder) mit Aufenthaltstitel zur Familienzusammenführung werden über das erwerbstätige Familienmitglied versichert.',
			HcsKnjizica3:
				'Der Anspruch auf Pflichtversicherung hängt von der aktuellen gesetzlichen Kategorie und dem Einzelfall ab; Aufenthalt wegen Immobilie, Firmeneigentum oder Digitalnomadenstatus garantiert für sich allein keinen Schutz. Koordination mit einer Versicherung im Ausland und die von FZOCG verlangten Nachweise richten sich ebenfalls nach den anwendbaren Regeln. Vor Kündigung anderer Versicherung Anspruch und Unterlagen direkt bei FZOCG bestätigen.',
			HcsKnjizica4:
				'Bei Beschäftigten beginnt die Anmeldung meist über den Arbeitgeber, gefolgt von Schritten bei FZOCG und Primärversorgung. Leistungen hängen von aktivem Status, Überweisung, Vertragseinrichtung, nationalem Programm und Arzneimittelliste ab; Zuzahlungen oder Ausschlüsse sind möglich. Aktuellen Ablauf und Schutz besonders nach Job- oder Statuswechsel bei FZOCG prüfen.',

			HcsWithout1:
				'Keine knjižica? In jedem dom zdravlja gibt es eine bezahlte Sprechstunde für Unversicherte — oft „turistička ambulanta“ genannt: eine Konsultation zum offiziellen Tarif, meist 25–30 €. Ohne Karte können Sie sich nicht bei einem izabrani doktor registrieren, einzelne Besuche sind aber möglich.',
			HcsWithout2:
				'Privatkliniken und Praxen sind die Alltagswahl der meisten unversicherten Ausländer: Eine Konsultation beim Allgemeinarzt oder Facharzt kostet 30–50 €, ein umfassender Besuch mit Ultraschall und Laboranalysen etwa 80 €. Nur wenige Privatkliniken verfügen über Betten und Operationssäle (in Podgorica und Sutomore) — bei einem akuten chirurgischen Notfall wird eine Privatklinik Sie höchstwahrscheinlich an ein staatliches Krankenhaus verweisen.',
			HcsWithout3:
				'Staatliche Einrichtungen rechnen bei Unversicherten nach offiziellen Tarifen ab — Sie finden sie in unserem',
			HcsWithout3Link: 'Katalog medizinischer Leistungen und Preise',
			HcsWithout3End: '.',
			HcsWithout4:
				'Laboruntersuchungen sind in privaten Laboren ohne Überweisung möglich — vergleichen Sie die Preise im',
			HcsWithout4Link: 'Katalog der Laboranalysen',
			HcsWithout4End: '.',

			HcsForeigners1:
				'Montenegro ist kein EU-Mitglied, daher gilt die Europäische Krankenversicherungskarte (EHIC) hier als solche nicht. Es bestehen jedoch bilaterale Sozialversicherungsabkommen: Versicherte aus Serbien, Slowenien, Kroatien, Bosnien und Herzegowina, Nordmazedonien, Österreich, Deutschland, Tschechien, der Slowakei, Ungarn, den Niederlanden, Belgien, Luxemburg, Italien, der Türkei und Bulgarien erhalten dringend notwendige Behandlungen in staatlichen Einrichtungen zulasten ihrer heimischen Kasse.',
			HcsForeigners2:
				'So funktioniert es: Besorgen Sie sich vor der Reise eine Bescheinigung Ihrer Kasse (z. B. Formular SRB/MNE 111 in Serbien, ČR/YU 111 in Tschechien; für deutsche, österreichische, slowenische und luxemburgische Versicherte genügt die EHIC als Anspruchsnachweis). In Montenegro tauschen Sie sie in der örtlichen FZOCG-Filiale gegen den Behandlungsschein INO 1 — danach werden Sie in staatlichen Einrichtungen wie ein einheimischer Patient behandelt. In einem echten Notfall muss zuerst behandelt werden; die Papiere werden nachgereicht.',
			HcsForeigners3:
				'Leistungen aus Gegenseitigkeit und Abkommen hängen von Land, Versicherungsstatus, Aufenthaltszweck, medizinischer Notwendigkeit und Unterlagen ab. Geplante Behandlung braucht meist Vorabgenehmigung; verlassen Sie sich nicht auf eine universelle Geldgrenze oder nur einen Pass. Formulare und Erstattung vor Reise beim Heimatfonds und FZOCG prüfen.',
			HcsForeigners4:
				'Russland, die Ukraine, Kasachstan und andere GUS-Staaten stehen auf keiner dieser Listen — gültige Abkommen über medizinische Versorgung mit Montenegro existieren nicht. Bürgern dieser Länder bleiben bezahlte Medizin oder eine private Versicherung — oder die staatliche Versicherung über eine Beschäftigung in Montenegro.',

			HcsInsurance1:
				'Preis, Grenzen, Ausschlüsse und Wartezeiten privater Policen hängen von Versicherer, Alter, Vorgeschichte und Tarif ab; genannte Beträge sind nur Richtwerte. Bedingungen für bestehende und chronische Erkrankungen, Arzneimittel, Schwangerschaft und Geburt, Wartezeiten, Selbstbehalt, Netzwerk und Erstattung prüfen. Eine als Aufenthaltsnachweis akzeptierte Police ist nicht zwingend umfassender Krankenversicherungsschutz.',
			HcsInsurance2:
				'Direktabrechnung und Erstattung hängen von Versicherer, Einrichtung und Vorabgenehmigung ab; staatlich oder privat bestimmt den Weg nicht allein. Einrichtung, Leistung, Unterlagen, Zahlungsweg, Kontoanforderung und Frist schriftlich bestätigen lassen. Touristen sollten Assistance, Ausschlüsse und Grenzen vergleichen, statt einen Policentyp allgemein als besten anzusehen.',

			HcsMedications1:
				'Antibiotika, Psychopharmaka und andere rezeptpflichtige Arzneimittel erfordern ein nach montenegrinischen Regeln gültiges Rezept. Ein ausländisches Rezept garantiert keine Abgabe: Einige Nutzer berichten von einer Annahme durch einzelne Apotheken, doch der Apotheker kann ablehnen; planen Sie eine lokale ärztliche Beurteilung. Der Arzt entscheidet eigenständig über Verordnung, Änderung oder Überweisung. Erstattete Arzneimittel geben Vertragsapotheken des Fonds ab, nicht nur Montefarm; das konkrete Mittel in unserem Register prüfen.',
			HcsMedications2:
				'Verfügbarkeit und Preise konkreter Medikamente in Montenegro finden Sie in unserem',
			HcsMedications2Link: 'Medikamentenkatalog',
			HcsMedications2End: '.',

			HcsSources0:
				'Stand der Informationen: Juli 2026. Regeln ändern sich — prüfen Sie wichtige Entscheidungen anhand offizieller Quellen:',
			HcsSourcesPhones:
				'Notrufnummern: 124 — Rettungsdienst, 122 — Polizei, 123 — Feuerwehr, 112 — einheitliche europäische Nummer;',
			HcsSourcesFzo:
				'Krankenversicherungsfonds Montenegros (FZOCG) — Versicherungsregeln und Verfahren nach bilateralen Abkommen: fzocg.me;',
			HcsSourcesEzdravlje:
				'Portal eZdravlje — Terminbuchung, E-Rezept, Prüfung des Versicherungsstatus: ezdravlje.me;',
			HcsSourcesWaiting:
				'Wartelisten der Krankenhäuser — veröffentlicht von FZOCG und dem Klinischen Zentrum: kccg.me;',
			HcsSourcesGovUk:
				'Für Einwohner Großbritanniens — offizielle Hinweise zur gegenseitigen Gesundheitsversorgung mit Montenegro: gov.uk.',
			HcsSourcesCatalog:
				'Sie suchen einen bestimmten Arzt oder eine Klinik? In unserem Katalog sind die Sprachen der Ärzte angegeben —',
			HcsSourcesCatalogLink: 'finden Sie einen Arzt, der Ihre Sprache spricht',
			HcsSourcesCatalogEnd: '.',
		},
		tr: {
			HcsToc_emergency: 'Acil yardım: 124 numarası',
			'HcsToc_state-system': 'Devlet sistemi nasıl işler',
			HcsToc_knjizica: 'Zdravstvena knjižica: kimler hak sahibi',
			'HcsToc_without-knjizica': 'Sağlık kartı yoksa: ücretli seçenekler',
			HcsToc_foreigners: 'AB vatandaşları ve ikili anlaşmalar',
			HcsToc_insurance: 'Özel sağlık sigortaları',
			HcsToc_medications: 'İlaçlar ve reçeteler',
			HcsToc_sources: 'Faydalı iletişim bilgileri ve kaynaklar',

			HcsEmergency1:
				"Karadağ'da acil tıbbi yardım numarası 124'tür (polis — 122, itfaiye — 123; Avrupa ortak numarası 112 de çalışır ve yerel servislere yönlendirir). Acil yardım birimleri (hitna pomoć) her belediyedeki dom zdravlja sağlık merkezlerine bağlıdır.",
			HcsEmergency2:
				'Operatör çağrıyı değerlendirir ve ekip gönderme veya hitna pomoć noktasına gitme önerisine karar verir. Aciliyeti yalnız ateşe göre belirlemeyin: nefes darlığı, göğüs ağrısı, ağır yaralanma, bilinç kaybı, nöbet, inme belirtisi veya hızlı kötüleşmede 124 ya da 112 numarasını arayın, talimatları izleyin ve güvenli değilse kendiniz araç kullanmayın.',
			HcsEmergency3:
				"Ciddi durumlarda ana adres, Podgorica'daki Karadağ Klinik Merkezi'nin (KCCG) 7/24 açık Urgentni centar'ıdır. Sahil şehirlerinde akut vakalar genel hastanelerin acil servislerine (Kotor, Bar) veya yerel dom zdravlja'daki hitna pomoć'a götürülür.",
			HcsEmergency4:
				'Acil erişim vatandaşlık veya sigorta nedeniyle geciktirilmemelidir; fatura güncel hakka, hizmete ve uluslararası düzene bağlıdır. Her sigortalının hiç ödeme yapmadığını varsaymayın. Hastanın 2023 için bildirdiği ameliyat fiyatı tarife değildir; sigortasız hasta ayrıntılı fatura alıp geri ödeme hakkını kontrol etmelidir.',

			HcsState1:
				'Devlet sağlık sistemi üç kademelidir; ayrıca uzmanlaşmış hastaneler vardır (Risan’da ortopedi, Brezovik’te göğüs hastalıkları, Dobrota’da psikiyatri):',
			HcsStateLevel1:
				'Dom zdravlja — her belediyedeki birinci basamak sağlık merkezi: pratisyenler, çocuk doktorları, kadın doğum uzmanları, temel tanı, aşılar;',
			HcsStateLevel2:
				'Opšta bolnica — Bar, Kotor, Nikšić, Berane, Bijelo Polje, Cetinje ve Pljevlja’daki genel hastaneler;',
			HcsStateLevel3:
				'Podgorica’daki Klinički centar Crne Gore (KCCG) — ülkenin karmaşık vakaların sevk edildiği ana çok branşlı hastanesi.',
			HcsState2:
				'Birinci basamak, izabrani doktor — dom zdravlja’nızda kaydolduğunuz “seçilmiş doktor” — etrafında kuruludur. Sizi tedavi eder, reçete ve uzmanlara/tanıya sevk (uput) yazar, uzman randevunuzu kendisi alır. Bazı uzmanlar ve tetkikler için sıralar vardır; bekleme listelerini hastaneler ve Fon açıkça yayımlar.',
			HcsState3:
				'Sistem büyük ölçüde dijitaldir: eZdravlje portalı (ezdravlje.me) çevrimiçi randevu, e-reçete (kâğıt reçeteler fiilen kaldırıldı) ve tahlil sonuçları sunar. Sigorta durumu elektronik olarak doğrulanır; 2020’den beri kâğıt karnenin yerine Karadağ elektronik kimlik kartı kullanılabilir.',

			HcsKnjizica1:
				'Zdravstvena knjižica (“yeşil karne”), Karadağ Sağlık Sigortası Fonu’nda (FZOCG) sigortalı olan kişinin belgesidir. 1 Ocak 2022’den beri sağlık sigortası primleri kaldırılmıştır (“Şimdi Avrupa” reformu) — sistem devlet bütçesinden finanse edilir, ancak sigortalıların kapsamını yine sigorta kanunu (“Sl. list CG” 145/21) belirler.',
			HcsKnjizica2:
				'Kimler hak sahibi: Karadağ vatandaşları ve Karadağ’da çalışan daimi veya geçici oturum izinli yabancılar — çalışanlar, girişimciler ve serbest meslek sahipleri; ayrıca emekliler, kayıtlı işsizler ve bazı diğer kategoriler. Aile birleşimi oturum izni olan aile üyeleri (eş, çocuklar) çalışan aile üyesi üzerinden sigortalanır.',
			HcsKnjizica3:
				'Zorunlu sigorta hakkı güncel yasal kategoriye ve kişisel duruma bağlıdır; taşınmaz, şirket sahipliği veya dijital göçebe statüsü tek başına kapsamı garanti etmez. Başka ülkedeki sigortayla koordinasyon ve FZOCG tarafından istenen belgeler de uygulanabilir kurallara bağlıdır. Diğer sigortayı iptal etmeden önce hakkı ve belgeleri doğrudan FZOCG kurumundan doğrulayın.',
			HcsKnjizica4:
				'Çalışanlarda kayıt genellikle işverenle başlar, ardından FZOCG ve birinci basamak adımları gelir. Haklar aktif statü, sevk, sözleşmeli kurum, ulusal program ve Fon ilaç listesine bağlıdır; katkı veya istisna olabilir. Güncel süreç ve kapsamı özellikle iş ya da statü değişince FZOCG kurumundan doğrulayın.',

			HcsWithout1:
				'Karneniz yok mu? Her dom zdravlja’da sigortasızlar için ücretli muayene vardır — genellikle turistička ambulanta denir: resmi tarifeyle konsültasyon, genellikle 25–30 €. Karne olmadan izabrani doktor’a kaydolamazsınız, ancak tek seferlik muayeneler mümkündür.',
			HcsWithout2:
				'Özel klinikler ve muayenehaneler sigortasız yabancıların günlük tercihidir: pratisyen veya uzman muayenesi 30–50 €, ultrason ve tahlillerle kapsamlı bir ziyaret yaklaşık 80 € tutar. Yataklı servis ve ameliyathane yalnızca birkaç özel klinikte vardır (Podgorica ve Sutomore’de) — akut cerrahi bir durumda özel klinik sizi büyük olasılıkla devlet hastanesine yönlendirir.',
			HcsWithout3:
				'Devlet kurumları sigortasızlara resmi tarifeler üzerinden fatura keser — bunları',
			HcsWithout3Link: 'tıbbi hizmetler ve fiyatlar kataloğumuzda',
			HcsWithout3End: ' görebilirsiniz.',
			HcsWithout4:
				'Tahliller özel laboratuvarlarda sevk olmadan yapılabilir — fiyatları',
			HcsWithout4Link: 'tahlil kataloğunda',
			HcsWithout4End: ' karşılaştırın.',

			HcsForeigners1:
				"Karadağ AB üyesi değildir, bu yüzden Avrupa Sağlık Sigortası Kartı (EHIC) burada tek başına geçerli değildir. Ancak ikili sosyal güvenlik anlaşmaları vardır: Sırbistan, Slovenya, Hırvatistan, Bosna-Hersek, Kuzey Makedonya, Avusturya, Almanya, Çekya, Slovakya, Macaristan, Hollanda, Belçika, Lüksemburg, İtalya, Türkiye ve Bulgaristan'da sigortalı olanlara, devlet kurumlarında acil sağlık hizmeti kendi ülkelerindeki fon hesabına verilir.",
			HcsForeigners2:
				"Nasıl işler: yolculuktan önce kendi fonunuzdan belge alın (ör. Sırbistan'da SRB/MNE 111, Çekya'da ČR/YU 111 formu; Almanya, Avusturya, Slovenya ve Lüksemburg sigortalılarına EHIC kartları yeterlidir). Karadağ'da bu belge yerel FZOCG şubesinde INO 1 sağlık belgesiyle değiştirilir — sonrasında devlet kurumlarında yerli hasta gibi hizmet alırsınız. Gerçek bir acil durumda önce tedavi etmek zorundadırlar; evraklar sonradan tamamlanır.",
			HcsForeigners3:
				'Karşılıklılık ve anlaşma kapsamı ülke, sigortalı statüsü, kalış amacı, tıbbi gereklilik ve belgelere bağlıdır. Planlı tedavi genellikle ön onay ister; evrensel para eşiğine veya yalnız pasaporta güvenmeyin. Yolculuktan önce formları ve geri ödemeyi kendi fonunuz ve FZOCG kurumundan doğrulayın.',
			HcsForeigners4:
				'Rusya, Ukrayna, Kazakistan ve diğer BDT ülkeleri bu listelerde yoktur — Karadağ ile yürürlükte sağlık anlaşmaları bulunmaz. Bu ülkelerin vatandaşlarına ücretli tıp veya özel sigorta kalır — ya da Karadağ’da çalışarak devlet sigortası.',

			HcsInsurance1:
				'Özel poliçe fiyatı, limiti, istisnaları ve bekleme süreleri sigortacıya, yaşa, sağlık geçmişine ve pakete göre değişir; verilen tutarlar yalnız göstergedir. Mevcut ve kronik hastalıklar, ilaçlar, gebelik ve doğum, bekleme, muafiyet, ağ ve geri ödeme koşullarını okuyun. Oturum belgesi olarak kabul edilen poliçe mutlaka kapsamlı sağlık koruması sağlamaz.',
			HcsInsurance2:
				'Doğrudan ödeme ve geri ödeme sigortacı, kurum ve ön onaya bağlıdır; kamu veya özel olması yolu tek başına belirlemez. Kurumu, hizmeti, belgeleri, ödeme şeklini, hesap gereğini ve süreyi yazılı doğrulayın. Turistler bir poliçe türünü evrensel en iyi saymak yerine asistans, istisna ve limitleri karşılaştırmalıdır.',

			HcsMedications1:
				'Antibiyotikler, psikotrop ilaçlar ve diğer reçeteli ürünler Karadağ kurallarına uygun geçerli reçete gerektirir. Yabancı reçete ilacın verilmesini garanti etmez: bazı kullanıcılar belirli eczanelerin kabul ettiğini bildirir, ancak eczacı reddedebilir; yerel hekim değerlendirmesini planlayın. Hekim reçete, plan değişikliği veya sevk kararını bağımsız verir. Kapsanan ilaçları yalnız Montefarm değil, Fonla sözleşmeli eczaneler verir; belirli ilacı kendi sicilimizde kontrol edin.',
			HcsMedications2:
				'Belirli ilaçların Karadağ’daki mevcudiyetini ve fiyatlarını',
			HcsMedications2Link: 'ilaç kataloğumuzda',
			HcsMedications2End: ' kontrol edebilirsiniz.',

			HcsSources0:
				'Bilgiler Temmuz 2026 itibarıyla günceldir. Kurallar değişir — önemli kararlar için resmi kaynaklara başvurun:',
			HcsSourcesPhones:
				'Acil numaralar: 124 — ambulans, 122 — polis, 123 — itfaiye, 112 — ortak Avrupa numarası;',
			HcsSourcesFzo:
				'Karadağ Sağlık Sigortası Fonu (FZOCG) — sigorta kuralları ve ikili anlaşma prosedürleri: fzocg.me;',
			HcsSourcesEzdravlje:
				'eZdravlje portalı — randevu, e-reçete, sigorta durumu sorgulama: ezdravlje.me;',
			HcsSourcesWaiting:
				'Hastane bekleme listeleri — FZOCG ve Klinik Merkez yayımlar: kccg.me;',
			HcsSourcesGovUk:
				'Birleşik Krallık’ta yaşayanlar için — Karadağ ile karşılıklı sağlık hizmetine dair resmi rehber: gov.uk.',
			HcsSourcesCatalog:
				'Belirli bir doktor veya klinik mi arıyorsunuz? Kataloğumuzda doktorların konuştuğu diller belirtilir —',
			HcsSourcesCatalogLink: 'dilinizi konuşan bir doktor bulun',
			HcsSourcesCatalogEnd: '.',
		},
	},
};
