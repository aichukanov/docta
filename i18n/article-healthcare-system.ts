// Контент статьи «Как устроена медицина в Черногории».
// Факты сверены с законом об обязательном медстраховании («Sl. list CG» 145/21, 048/24),
// инструкцией FZOCG для иностранных застрахованных и данными
// русскоязычных чатов о реальном опыте (2023–2026). Актуальность: июль 2026.
export default {
	messages: {
		'en': {
			'HcsToc_emergency': 'Emergency care: dial 124',
			'HcsToc_state-system': 'How the state system works',
			'HcsToc_knjizica': 'Zdravstvena knjižica: who is entitled',
			'HcsToc_without-knjizica': 'No health card? Paid options',
			'HcsToc_foreigners': 'EU citizens and bilateral agreements',
			'HcsToc_insurance': 'Private health insurance',
			'HcsToc_medications': 'Medications and prescriptions',
			'HcsToc_sources': 'Useful contacts and sources',

			HcsEmergency1:
				'The emergency medical number in Montenegro is 124 (police — 122, fire — 123; the European 112 also works and redirects to local services). Emergency medical units (hitna pomoć) operate at the dom zdravlja health centers in every municipality.',
			HcsEmergency2:
				'A practical detail newcomers learn quickly: ambulances rarely come to your home for non-life-threatening cases. With a fever — even a high one — you will most likely be told to come to the emergency point yourself, where doctors will treat you, refer you onward or take you to a hospital by ambulance if needed.',
			HcsEmergency3:
				'For serious conditions the main destination is the Urgentni centar of the Clinical Center of Montenegro (KCCG) in Podgorica, open 24/7. On the coast, acute cases go to the emergency rooms of the general hospitals (Kotor, Bar) or the hitna pomoć unit at the local dom zdravlja.',
			HcsEmergency4:
				'Emergency care is provided to everyone regardless of citizenship or insurance. It is free only if you are covered — by Montenegrin state insurance or via a bilateral agreement (see below). Otherwise you will be billed at official price lists: real-life example from 2023 — a laparoscopic appendectomy with two days in hospital in Podgorica cost about €1,200–1,500 for an uninsured patient, while an insured one pays nothing.',

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
				'Who is not entitled: foreigners whose residence permit is based on property ownership, company ownership without employment, or the digital nomad permit — the law simply has no category for them, and the old option of voluntarily buying into state insurance was not carried over into the current law. Note also: you cannot be insured in two countries at once — in practice the Fund asks first-time foreign applicants to prove they have deregistered from health insurance in their home country.',
			HcsKnjizica4:
				'How to get it: for employees the employer registers you with the Fund; then you visit the FZO branch / dom zdravlja with your residence permit to complete registration and choose your izabrani doktor. What it gives: free GP and referred specialist visits, hospital treatment, vaccinations under the national calendar, and medications from the Fund’s list free or nearly free. If you change employer, visit the Fund to update who insures you.',

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
				'The UK and Poland work on reciprocity: a valid GHIC/EHIC or even just proof of insurance plus a passport is enough for urgent care. Swiss, Swedish, Danish and Norwegian insured pay on the spot and claim reimbursement at home. In all cases only urgent/necessary care is covered — planned treatment and services over €150 require prior approval of your home insurer. A note specifically for German nationals: repatriation transport home is not covered — the DVKA explicitly recommends private travel insurance.',
			HcsForeigners4:
				'Russia, Ukraine, Kazakhstan and other CIS countries have no healthcare agreement with Montenegro. Citizens of these countries rely on paid medicine or private insurance unless they work in Montenegro and hold state insurance.',

			HcsInsurance1:
				'Private (voluntary) health insurance is offered by local insurers — Sava, Lovćen, Uniqa, Generali, Grawe. Outpatient packages start around €18 per month for people under 40; a typical “foreigner” policy costs about €300 per year with a coverage limit around €10,000. Standard exclusions apply: pre-existing and chronic conditions are not covered, and there are waiting periods (usually 2 months, 9 for childbirth). A policy is also a mandatory document for residence-permit applications.',
			HcsInsurance2:
				'Keep in mind: state clinics do not bill private insurers directly. In practice you either agree the visit with the insurer in advance or pay yourself and claim reimbursement — which is usually paid only to a Montenegrin bank account. For tourists, ordinary travel insurance with an assistance service remains the best option.',

			HcsMedications1:
				'Prescription drugs (antibiotics, psychotropics and many others) are sold strictly with a Montenegrin prescription — pharmacies do not accept foreign ones. Prescriptions are electronic: your izabrani doktor issues them free with a knjižica; without one, any licensed doctor can prescribe after a paid consultation. For the insured, medications from the Fund’s list are free or nearly free at Montefarm state pharmacies.',
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
		'ru': {
			'HcsToc_emergency': 'Экстренная помощь: номер 124',
			'HcsToc_state-system': 'Как устроена государственная система',
			'HcsToc_knjizica': 'Zdravstvena knjižica: кому положена',
			'HcsToc_without-knjizica': 'Без книжицы: платные варианты',
			'HcsToc_foreigners': 'Граждане ЕС и межгосударственные соглашения',
			'HcsToc_insurance': 'Частные страховки',
			'HcsToc_medications': 'Лекарства и рецепты',
			'HcsToc_sources': 'Полезные контакты и источники',

			HcsEmergency1:
				'Номер скорой помощи в Черногории — 124 (полиция — 122, пожарные — 123; общеевропейский 112 тоже работает и переключает на местные службы). Отделения скорой (hitna pomoć) работают при домах здравля в каждом муниципалитете.',
			HcsEmergency2:
				'Практическая деталь, с которой быстро сталкиваются все переехавшие: на дом бригада при неугрожающих жизни состояниях выезжает редко. С температурой — даже высокой — вам, скорее всего, скажут приехать в пункт скорой самостоятельно: там осмотрят, окажут помощь, направят дальше или отвезут в больницу на машине скорой, если это действительно нужно.',
			HcsEmergency3:
				'При серьёзных состояниях основной адрес — Urgentni centar Клинического центра Черногории (KCCG) в Подгорице, он работает круглосуточно. На побережье с острыми случаями едут в приёмные отделения общих больниц (Котор, Бар) или в hitna pomoć при местном доме здравля.',
			HcsEmergency4:
				'Экстренную помощь окажут любому — независимо от гражданства и страховки. Но бесплатной она будет только для застрахованных: по черногорской государственной страховке или по межгосударственному соглашению (см. ниже). Остальным выставят счёт по официальным тарифам. Реальный пример 2023 года: лапароскопическое удаление аппендикса с двумя днями стационара в Подгорице обошлось незастрахованному пациенту примерно в 1200–1500 €, застрахованный не платит ничего.',

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
				'Кому не положена: иностранцам с ВНЖ по недвижимости, владельцам фирм без трудоустройства и цифровым кочевникам — для них в законе просто нет основания, а возможность добровольно «вступить» в госстраховку за взнос в новый закон не перенесли. Ещё один нюанс: быть застрахованным в двух странах нельзя — на практике при первичном оформлении фонд требует у иностранца подтверждение отказа от медстраховки в стране гражданства.',
			HcsKnjizica4:
				'Как оформить: за наёмных работников заявление в фонд подаёт работодатель; дальше вы приходите в филиал FZO / дом здравля с бораваком, завершаете регистрацию и прикрепляетесь к izabrani doktor. Что даёт книжица: бесплатные приёмы у своего врача и по направлениям, стационар, прививки по национальному календарю, лекарства из списка фонда бесплатно или почти бесплатно. При смене работодателя нужно зайти в фонд и обновить данные о страхователе.',

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
				'Великобритания и Польша работают по принципу взаимности: для неотложной помощи достаточно паспорта и действующего GHIC/EHIC или иного подтверждения страховки. Застрахованные в Швейцарии, Швеции, Дании и Норвегии платят на месте и получают возмещение дома. Во всех случаях покрывается только неотложная/необходимая помощь — плановое лечение и услуги дороже 150 € требуют предварительного согласия домашнего страховщика. Отдельная оговорка для граждан Германии: транспортировка домой (репатриация) не покрывается — DVKA прямо рекомендует оформлять частную туристическую страховку.',
			HcsForeigners4:
				'России, Украины, Казахстана и других стран СНГ в этих списках нет — действующих соглашений о медицинской помощи с Черногорией у них не существует. Гражданам этих стран остаётся платная медицина или частная страховка — либо государственная страховка через работу в Черногории.',

			HcsInsurance1:
				'Частные (добровольные) страховки продают местные страховщики — Sava, Lovćen, Uniqa, Generali, Grawe. Амбулаторные пакеты начинаются примерно от 18 € в месяц для людей младше 40 лет; типовой полис «для иностранцев» стоит около 300 € в год с лимитом покрытия порядка 10 000 €. Стандартные исключения: хронические и существовавшие до покупки полиса заболевания не покрываются, действуют периоды ожидания (обычно 2 месяца, для родов — 9). Такой полис — ещё и обязательный документ при подаче на ВНЖ.',
			HcsInsurance2:
				'Важно понимать: государственные клиники не работают с частными страховыми напрямую. На практике визит либо заранее согласуют со страховой, либо платят сами и подают на возмещение — а его, как правило, перечисляют только на счёт в черногорском банке. Туристам по-прежнему разумнее всего обычная travel-страховка с ассистансом.',

			HcsMedications1:
				'Рецептурные препараты (антибиотики, психотропные и многие другие) продаются строго по черногорскому рецепту — иностранный аптека не примет. Рецепты электронные: по книжице их бесплатно выписывает izabrani doktor, без книжицы — любой лицензированный врач после платной консультации. Застрахованным лекарства из списка фонда отпускают бесплатно или почти бесплатно в государственных аптеках Montefarm.',
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
		'sr': {
			'HcsToc_emergency': 'Hitna pomoć: broj 124',
			'HcsToc_state-system': 'Kako funkcioniše državni sistem',
			'HcsToc_knjizica': 'Zdravstvena knjižica: ko ima pravo',
			'HcsToc_without-knjizica': 'Bez knjižice: plaćene opcije',
			'HcsToc_foreigners': 'Državljani EU i međudržavni sporazumi',
			'HcsToc_insurance': 'Privatna osiguranja',
			'HcsToc_medications': 'Ljekovi i recepti',
			'HcsToc_sources': 'Korisni kontakti i izvori',

			HcsEmergency1:
				'Broj hitne medicinske pomoći u Crnoj Gori je 124 (policija — 122, vatrogasci — 123; evropski broj 112 takođe radi i preusmjerava na lokalne službe). Jedinice hitne pomoći rade pri domovima zdravlja u svakoj opštini.',
			HcsEmergency2:
				'Praktičan detalj koji doseljenici brzo nauče: ekipa rijetko izlazi na kućnu adresu kada stanje ne ugrožava život. Sa temperaturom — čak i visokom — najvjerovatnije će vam reći da sami dođete u punkt hitne pomoći: tamo će vas pregledati, zbrinuti, uputiti dalje ili prevesti u bolnicu ako je zaista potrebno.',
			HcsEmergency3:
				'Za ozbiljna stanja glavna adresa je Urgentni centar Kliničkog centra Crne Gore (KCCG) u Podgorici, otvoren 24/7. Na primorju se akutni slučajevi voze u prijemna odjeljenja opštih bolnica (Kotor, Bar) ili u hitnu pomoć pri lokalnom domu zdravlja.',
			HcsEmergency4:
				'Hitna pomoć se pruža svima — bez obzira na državljanstvo i osiguranje. Besplatna je samo za osigurane: preko crnogorskog državnog osiguranja ili po međudržavnom sporazumu (vidi niže). Ostalima se ispostavlja račun po zvaničnom cjenovniku. Primjer iz prakse (2023): laparoskopska operacija slijepog crijeva sa dva dana bolničkog liječenja u Podgorici koštala je neosiguranog pacijenta oko 1.200–1.500 €, dok osigurani ne plaća ništa.',

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
				'Ko nema pravo: stranci sa boravkom po osnovu nekretnine, vlasnici firmi bez zaposlenja i digitalni nomadi — za njih u zakonu jednostavno ne postoji osnov, a mogućnost dobrovoljnog ulaska u državno osiguranje uz uplatu doprinosa nije prenijeta u važeći zakon. Još jedna napomena: ne možete biti osigurani u dvije države istovremeno — u praksi Fond od stranca pri prvoj registraciji traži potvrdu o odjavi zdravstvenog osiguranja u zemlji porijekla.',
			HcsKnjizica4:
				'Kako se dobija: za zaposlene prijavu Fondu podnosi poslodavac; zatim sa boravkom dolazite u filijalu FZO / dom zdravlja, završavate registraciju i birate izabranog doktora. Šta knjižica daje: besplatne preglede kod izabranog doktora i po uputu, bolničko liječenje, vakcinaciju po nacionalnom kalendaru, ljekove sa liste Fonda besplatno ili gotovo besplatno. Pri promjeni poslodavca treba otići u Fond i ažurirati podatke o osiguravaocu.',

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
				'Velika Britanija i Poljska funkcionišu po principu reciprociteta: za hitnu pomoć dovoljni su pasoš i važeći GHIC/EHIC ili drugi dokaz osiguranja. Osiguranici iz Švajcarske, Švedske, Danske i Norveške plaćaju na licu mjesta i traže refundaciju kod kuće. U svim slučajevima pokrivena je samo hitna/neophodna zaštita — planirano liječenje i usluge skuplje od 150 € zahtijevaju prethodnu saglasnost matičnog osiguravača. Napomena posebno za njemačke državljane: povratni transport kući nije pokriven — DVKA izričito preporučuje privatno putno osiguranje.',
			HcsForeigners4:
				'Rusija, Ukrajina, Kazahstan i druge zemlje ZND nisu na ovim listama — važeći sporazumi o zdravstvenoj zaštiti sa Crnom Gorom ne postoje. Državljanima tih zemalja ostaje plaćena medicina ili privatno osiguranje — ili državno osiguranje preko zaposlenja u Crnoj Gori.',

			HcsInsurance1:
				'Privatna (dobrovoljna) osiguranja prodaju lokalni osiguravači — Sava, Lovćen, Uniqa, Generali, Grawe. Vanbolnički paketi počinju od oko 18 € mjesečno za mlađe od 40 godina; tipična polisa „za strance“ košta oko 300 € godišnje sa limitom pokrića oko 10.000 €. Standardna isključenja: hronične bolesti i stanja nastala prije kupovine polise nisu pokriveni, važe periodi čekanja (obično 2 mjeseca, za porođaj 9). Ovakva polisa je ujedno i obavezan dokument pri podnošenju zahtjeva za boravak.',
			HcsInsurance2:
				'Važno je znati: državne klinike ne fakturišu privatnim osiguravačima direktno. U praksi se posjeta ili unaprijed usaglašava sa osiguravačem, ili sami platite pa tražite refundaciju — koja se po pravilu isplaćuje samo na račun u crnogorskoj banci. Za turiste je i dalje najrazumnije obično putno osiguranje sa asistencijom.',

			HcsMedications1:
				'Ljekovi na recept (antibiotici, psihotropni i mnogi drugi) prodaju se isključivo uz crnogorski recept — strani recept apoteka neće prihvatiti. Recepti su elektronski: uz knjižicu ih besplatno propisuje izabrani doktor, bez knjižice — bilo koji licencirani ljekar nakon plaćene konsultacije. Osiguranima se ljekovi sa liste Fonda izdaju besplatno ili gotovo besplatno u državnim apotekama Montefarm.',
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
			'HcsToc_emergency': 'Хитна помоћ: број 124',
			'HcsToc_state-system': 'Како функционише државни систем',
			'HcsToc_knjizica': 'Здравствена књижица: ко има право',
			'HcsToc_without-knjizica': 'Без књижице: плаћене опције',
			'HcsToc_foreigners': 'Држављани ЕУ и међудржавни споразуми',
			'HcsToc_insurance': 'Приватна осигурања',
			'HcsToc_medications': 'Љекови и рецепти',
			'HcsToc_sources': 'Корисни контакти и извори',

			HcsEmergency1:
				'Број хитне медицинске помоћи у Црној Гори је 124 (полиција — 122, ватрогасци — 123; европски број 112 такође ради и преусмјерава на локалне службе). Јединице хитне помоћи раде при домовима здравља у свакој општини.',
			HcsEmergency2:
				'Практичан детаљ који досељеници брзо науче: екипа ријетко излази на кућну адресу када стање не угрожава живот. Са температуром — чак и високом — највјероватније ће вам рећи да сами дођете у пункт хитне помоћи: тамо ће вас прегледати, збринути, упутити даље или превести у болницу ако је заиста потребно.',
			HcsEmergency3:
				'За озбиљна стања главна адреса је Ургентни центар Клиничког центра Црне Горе (КЦЦГ) у Подгорици, отворен 24/7. На приморју се акутни случајеви возе у пријемна одјељења општих болница (Котор, Бар) или у хитну помоћ при локалном дому здравља.',
			HcsEmergency4:
				'Хитна помоћ се пружа свима — без обзира на држављанство и осигурање. Бесплатна је само за осигуране: преко црногорског државног осигурања или по међудржавном споразуму (види ниже). Осталима се испоставља рачун по званичном цјеновнику. Примјер из праксе (2023): лапароскопска операција слијепог цријева са два дана болничког лијечења у Подгорици коштала је неосигураног пацијента око 1.200–1.500 €, док осигурани не плаћа ништа.',

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
				'Ко нема право: странци са боравком по основу некретнине, власници фирми без запослења и дигитални номади — за њих у закону једноставно не постоји основ, а могућност добровољног уласка у државно осигурање уз уплату доприноса није пренијета у важећи закон. Још једна напомена: не можете бити осигурани у двије државе истовремено — у пракси Фонд од странца при првој регистрацији тражи потврду о одјави здравственог осигурања у земљи поријекла.',
			HcsKnjizica4:
				'Како се добија: за запослене пријаву Фонду подноси послодавац; затим са боравком долазите у филијалу ФЗО / дом здравља, завршавате регистрацију и бирате изабраног доктора. Шта књижица даје: бесплатне прегледе код изабраног доктора и по упуту, болничко лијечење, вакцинацију по националном календару, љекове са листе Фонда бесплатно или готово бесплатно. При промјени послодавца треба отићи у Фонд и ажурирати податке о осигураваоцу.',

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
				'Велика Британија и Пољска функционишу по принципу реципроцитета: за хитну помоћ довољни су пасош и важећи GHIC/EHIC или други доказ осигурања. Осигураници из Швајцарске, Шведске, Данске и Норвешке плаћају на лицу мјеста и траже рефундацију код куће. У свим случајевима покривена је само хитна/неопходна заштита — планирано лијечење и услуге скупље од 150 € захтијевају претходну сагласност матичног осигуравача. Напомена посебно за њемачке држављане: повратни транспорт кући није покривен — DVKA изричито препоручује приватно путно осигурање.',
			HcsForeigners4:
				'Русија, Украјина, Казахстан и друге земље ЗНД нису на овим листама — важећи споразуми о здравственој заштити са Црном Гором не постоје. Држављанима тих земаља остаје плаћена медицина или приватно осигурање — или државно осигурање преко запослења у Црној Гори.',

			HcsInsurance1:
				'Приватна (добровољна) осигурања продају локални осигуравачи — Sava, Lovćen, Uniqa, Generali, Grawe. Ванболнички пакети почињу од око 18 € мјесечно за млађе од 40 година; типична полиса „за странце“ кошта око 300 € годишње са лимитом покрића око 10.000 €. Стандардна искључења: хроничне болести и стања настала прије куповине полисе нису покривени, важе периоди чекања (обично 2 мјесеца, за порођај 9). Оваква полиса је уједно и обавезан документ при подношењу захтјева за боравак.',
			HcsInsurance2:
				'Важно је знати: државне клинике не фактуришу приватним осигуравачима директно. У пракси се посјета или унапријед усаглашава са осигуравачем, или сами платите па тражите рефундацију — која се по правилу исплаћује само на рачун у црногорској банци. За туристе је и даље најразумније обично путно осигурање са асистенцијом.',

			HcsMedications1:
				'Љекови на рецепт (антибиотици, психотропни и многи други) продају се искључиво уз црногорски рецепт — страни рецепт апотека неће прихватити. Рецепти су електронски: уз књижицу их бесплатно прописује изабрани доктор, без књижице — било који лиценцирани љекар након плаћене консултације. Осигуранима се љекови са листе Фонда издају бесплатно или готово бесплатно у државним апотекама Montefarm.',
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
		'de': {
			'HcsToc_emergency': 'Notfallversorgung: Notruf 124',
			'HcsToc_state-system': 'So funktioniert das staatliche System',
			'HcsToc_knjizica': 'Zdravstvena knjižica: Wer hat Anspruch',
			'HcsToc_without-knjizica': 'Ohne Gesundheitskarte: bezahlte Optionen',
			'HcsToc_foreigners': 'EU-Bürger und bilaterale Abkommen',
			'HcsToc_insurance': 'Private Krankenversicherungen',
			'HcsToc_medications': 'Medikamente und Rezepte',
			'HcsToc_sources': 'Nützliche Kontakte und Quellen',

			HcsEmergency1:
				'Die Notrufnummer des Rettungsdienstes in Montenegro ist 124 (Polizei — 122, Feuerwehr — 123; die europäische 112 funktioniert ebenfalls und leitet an die lokalen Dienste weiter). Die Rettungsstellen (hitna pomoć) sind den Gesundheitszentren (dom zdravlja) in jeder Gemeinde angegliedert.',
			HcsEmergency2:
				'Ein praktisches Detail, das Zugezogene schnell lernen: Bei nicht lebensbedrohlichen Zuständen kommt selten ein Rettungswagen nach Hause. Mit Fieber — auch hohem — wird man Sie höchstwahrscheinlich bitten, selbst zur Rettungsstelle zu kommen: Dort werden Sie untersucht, versorgt, weiterverwiesen oder bei Bedarf ins Krankenhaus gebracht.',
			HcsEmergency3:
				'Bei ernsten Zuständen ist die wichtigste Adresse das Urgentni centar des Klinischen Zentrums von Montenegro (KCCG) in Podgorica, rund um die Uhr geöffnet. An der Küste fährt man mit akuten Fällen in die Notaufnahmen der allgemeinen Krankenhäuser (Kotor, Bar) oder zur hitna pomoć am örtlichen dom zdravlja.',
			HcsEmergency4:
				'Notfallhilfe erhält jeder — unabhängig von Staatsangehörigkeit und Versicherung. Kostenlos ist sie aber nur für Versicherte: über die montenegrinische staatliche Versicherung oder ein bilaterales Abkommen (siehe unten). Allen anderen wird nach offiziellen Tarifen Rechnung gestellt. Reales Beispiel aus 2023: Eine laparoskopische Blinddarmoperation mit zwei Tagen stationärem Aufenthalt in Podgorica kostete einen Unversicherten etwa 1.200–1.500 €, ein Versicherter zahlt nichts.',

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
				'Keinen Anspruch haben: Ausländer mit Aufenthalt auf Basis von Immobilienbesitz, Firmeninhaber ohne Anstellung und digitale Nomaden — für sie sieht das Gesetz schlicht keine Grundlage vor, und die frühere Möglichkeit, sich freiwillig gegen Beitrag einzukaufen, wurde nicht ins geltende Gesetz übernommen. Wichtig auch: Man kann nicht in zwei Ländern gleichzeitig versichert sein — in der Praxis verlangt der Fonds bei der Erstanmeldung von Ausländern einen Nachweis der Abmeldung von der Krankenversicherung im Herkunftsland.',
			HcsKnjizica4:
				'So erhalten Sie sie: Für Angestellte meldet der Arbeitgeber Sie beim Fonds an; anschließend gehen Sie mit Ihrem Aufenthaltstitel zur FZO-Filiale bzw. zum dom zdravlja, schließen die Registrierung ab und wählen Ihren izabrani doktor. Was das Heft bietet: kostenlose Besuche beim eigenen Arzt und nach Überweisung, stationäre Behandlung, Impfungen nach dem nationalen Kalender, Medikamente von der Fondsliste kostenlos oder fast kostenlos. Bei einem Arbeitgeberwechsel müssen die Versichererdaten beim Fonds aktualisiert werden.',

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
				'Großbritannien und Polen arbeiten nach dem Gegenseitigkeitsprinzip: Für die Notfallversorgung genügen Reisepass und eine gültige GHIC/EHIC oder ein anderer Versicherungsnachweis. Versicherte aus der Schweiz, Schweden, Dänemark und Norwegen zahlen vor Ort und beantragen die Erstattung zu Hause. In allen Fällen ist nur die dringend notwendige Versorgung abgedeckt — geplante Behandlungen und Leistungen über 150 € erfordern die vorherige Zustimmung der heimischen Kasse. Hinweis für deutsche Versicherte: Der Rücktransport nach Hause ist nicht gedeckt — die DVKA empfiehlt ausdrücklich eine private Reiseversicherung.',
			HcsForeigners4:
				'Russland, die Ukraine, Kasachstan und andere GUS-Staaten stehen auf keiner dieser Listen — gültige Abkommen über medizinische Versorgung mit Montenegro existieren nicht. Bürgern dieser Länder bleiben bezahlte Medizin oder eine private Versicherung — oder die staatliche Versicherung über eine Beschäftigung in Montenegro.',

			HcsInsurance1:
				'Private (freiwillige) Krankenversicherungen bieten lokale Versicherer an — Sava, Lovćen, Uniqa, Generali, Grawe. Ambulante Pakete beginnen bei etwa 18 € pro Monat für Personen unter 40; eine typische „Ausländer“-Police kostet rund 300 € pro Jahr mit einer Deckungssumme von etwa 10.000 €. Übliche Ausschlüsse: chronische und vorbestehende Erkrankungen sind nicht gedeckt, es gelten Wartezeiten (meist 2 Monate, 9 für Entbindungen). Eine solche Police ist zugleich Pflichtdokument beim Antrag auf einen Aufenthaltstitel.',
			HcsInsurance2:
				'Wichtig zu wissen: Staatliche Kliniken rechnen nicht direkt mit privaten Versicherern ab. In der Praxis stimmt man den Besuch entweder vorab mit dem Versicherer ab oder zahlt selbst und beantragt die Erstattung — die in der Regel nur auf ein montenegrinisches Bankkonto ausgezahlt wird. Für Touristen bleibt eine gewöhnliche Reiseversicherung mit Assistance die beste Wahl.',

			HcsMedications1:
				'Verschreibungspflichtige Medikamente (Antibiotika, Psychopharmaka und viele andere) werden ausschließlich gegen ein montenegrinisches Rezept verkauft — ausländische Rezepte akzeptiert die Apotheke nicht. Rezepte sind elektronisch: Mit knjižica stellt sie der izabrani doktor kostenlos aus, ohne Karte jeder lizenzierte Arzt nach einer bezahlten Konsultation. Versicherte erhalten Medikamente von der Fondsliste kostenlos oder fast kostenlos in den staatlichen Montefarm-Apotheken.',
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
		'tr': {
			'HcsToc_emergency': 'Acil yardım: 124 numarası',
			'HcsToc_state-system': 'Devlet sistemi nasıl işler',
			'HcsToc_knjizica': 'Zdravstvena knjižica: kimler hak sahibi',
			'HcsToc_without-knjizica': 'Sağlık kartı yoksa: ücretli seçenekler',
			'HcsToc_foreigners': 'AB vatandaşları ve ikili anlaşmalar',
			'HcsToc_insurance': 'Özel sağlık sigortaları',
			'HcsToc_medications': 'İlaçlar ve reçeteler',
			'HcsToc_sources': 'Faydalı iletişim bilgileri ve kaynaklar',

			HcsEmergency1:
				"Karadağ'da acil tıbbi yardım numarası 124'tür (polis — 122, itfaiye — 123; Avrupa ortak numarası 112 de çalışır ve yerel servislere yönlendirir). Acil yardım birimleri (hitna pomoć) her belediyedeki dom zdravlja sağlık merkezlerine bağlıdır.",
			HcsEmergency2:
				'Yeni taşınanların hızla öğrendiği pratik bir ayrıntı: hayati tehlike olmayan durumlarda ambulans eve nadiren gelir. Ateşiniz olduğunda — yüksek bile olsa — büyük olasılıkla acil yardım noktasına kendiniz gitmeniz söylenir: orada muayene edilir, tedavi edilir, sevk edilir veya gerçekten gerekiyorsa ambulansla hastaneye götürülürsünüz.',
			HcsEmergency3:
				"Ciddi durumlarda ana adres, Podgorica'daki Karadağ Klinik Merkezi'nin (KCCG) 7/24 açık Urgentni centar'ıdır. Sahil şehirlerinde akut vakalar genel hastanelerin acil servislerine (Kotor, Bar) veya yerel dom zdravlja'daki hitna pomoć'a götürülür.",
			HcsEmergency4:
				"Acil yardım, vatandaşlık ve sigorta durumuna bakılmaksızın herkese verilir. Ancak yalnızca sigortalılar için ücretsizdir: Karadağ devlet sigortası veya ikili anlaşma yoluyla (aşağıya bakın). Diğerlerine resmi tarifeler üzerinden fatura kesilir. 2023'ten gerçek bir örnek: Podgorica'da iki gün hastane yatışıyla laparoskopik apandisit ameliyatı sigortasız bir hastaya yaklaşık 1.200–1.500 €'ya mal oldu; sigortalı hiçbir şey ödemez.",

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
				'Kimler hak sahibi değil: gayrimenkul sahipliğine dayalı oturum izni olanlar, istihdam olmadan şirket sahipleri ve dijital göçebeler — kanunda onlar için bir dayanak yoktur ve prim ödeyerek gönüllü katılım imkânı yürürlükteki kanuna taşınmamıştır. Bir not daha: aynı anda iki ülkede sigortalı olamazsınız — uygulamada Fon, ilk kayıtta yabancıdan kendi ülkesindeki sağlık sigortasından çıkış belgesini ister.',
			HcsKnjizica4:
				'Nasıl alınır: çalışanlar için başvuruyu Fon’a işveren yapar; ardından oturum izninizle FZO şubesine / dom zdravlja’ya gidip kaydı tamamlar ve izabrani doktor’unuzu seçersiniz. Karne ne sağlar: kendi doktorunuzda ve sevkle ücretsiz muayeneler, hastane tedavisi, ulusal takvime göre aşılar, Fon listesindeki ilaçlar ücretsiz veya neredeyse ücretsiz. İşveren değiştiğinde Fon’a gidip sigortalayan bilgilerini güncellemek gerekir.',

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
				"Birleşik Krallık ve Polonya karşılıklılık ilkesiyle çalışır: acil yardım için pasaport ve geçerli GHIC/EHIC veya başka bir sigorta kanıtı yeterlidir. İsviçre, İsveç, Danimarka ve Norveç sigortalıları yerinde öder ve geri ödemeyi kendi ülkelerinde talep eder. Her durumda yalnızca acil/zorunlu bakım kapsanır — planlı tedaviler ve 150 €'yu aşan hizmetler kendi sigortacınızın ön onayını gerektirir. Özellikle Alman vatandaşları için not: eve dönüş nakli kapsam dışıdır — DVKA açıkça özel seyahat sigortası öneriyor.",
			HcsForeigners4:
				'Rusya, Ukrayna, Kazakistan ve diğer BDT ülkeleri bu listelerde yoktur — Karadağ ile yürürlükte sağlık anlaşmaları bulunmaz. Bu ülkelerin vatandaşlarına ücretli tıp veya özel sigorta kalır — ya da Karadağ’da çalışarak devlet sigortası.',

			HcsInsurance1:
				'Özel (gönüllü) sağlık sigortalarını yerel sigortacılar sunar — Sava, Lovćen, Uniqa, Generali, Grawe. Ayakta tedavi paketleri 40 yaş altı için ayda yaklaşık 18 €’dan başlar; tipik bir “yabancı” poliçesi yılda yaklaşık 300 €’ya, yaklaşık 10.000 € teminat limitiyle satılır. Standart istisnalar geçerlidir: kronik ve önceden var olan hastalıklar kapsanmaz, bekleme süreleri vardır (genellikle 2 ay, doğum için 9). Böyle bir poliçe aynı zamanda oturum izni başvurusunda zorunlu belgedir.',
			HcsInsurance2:
				'Bilinmesi gereken: devlet klinikleri özel sigortacılarla doğrudan çalışmaz. Uygulamada ziyaret ya önceden sigortacıyla mutabık kalınır ya da kendiniz ödeyip geri ödeme talep edersiniz — geri ödeme kural olarak yalnızca Karadağ’daki bir banka hesabına yapılır. Turistler için asistans hizmetli sıradan seyahat sigortası en makul seçenek olmaya devam ediyor.',

			HcsMedications1:
				'Reçeteli ilaçlar (antibiyotikler, psikotroplar ve diğerleri) yalnızca Karadağ reçetesiyle satılır — eczane yabancı reçeteyi kabul etmez. Reçeteler elektroniktir: karneyle izabrani doktor ücretsiz yazar; karne yoksa herhangi bir lisanslı doktor ücretli konsültasyon sonrası yazabilir. Sigortalılara Fon listesindeki ilaçlar devlet eczanesi Montefarm’da ücretsiz veya neredeyse ücretsiz verilir.',
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
