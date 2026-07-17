// Контент статьи «Медицинская страховка для ВНЖ в Черногории».
// Правовая база сверена с Zakon o strancima («Sl. list CG» 12/2018, консолидированная версия)
// и продуктами страховщиков (sava.co.me, lovcen-osiguranje.me, uniqa.me).
// Требования по городам — опыт заявителей из чатов переехавших (2025–2026),
// в тексте так и атрибутировано. Актуальность: июль 2026.
export default {
	messages: {
		en: {
			ResidenceInsuranceTitle:
				'Health insurance for a residence permit in Montenegro',
			ResidenceInsuranceDescription:
				'Why every boravak application needs health insurance, how long a policy each city asks for — from 40 days in Podgorica to 2 years in Budva — prices at Sava, Lovćen and Uniqa, what the policy actually covers and who gets state insurance instead. Updated July 2026.',

			'RipToc_why-required': 'Why the permit requires insurance',
			RipToc_duration: 'How long a policy each city wants',
			RipToc_buying: 'Where and how to buy a policy',
			RipToc_coverage: 'What the policy actually covers',
			RipToc_knjizica: 'Who gets state insurance instead',
			RipToc_sources: 'Sources and disclaimer',

			RipWhy1:
				'The requirement comes from the Law on Foreigners (Zakon o strancima, “Sl. list CG” 12/2018 with later amendments): Article 43, paragraph 1, item 3 lists among the conditions for temporary residence that the applicant “ima zdravstveno osiguranje” — has health insurance. It applies to every permit type: work, family reunification, property ownership, study, digital nomad.',
			RipWhy2:
				'The implementing rules accept three kinds of proof: a travel or health insurance policy from an insurer authorized in Montenegro, insurance under an international social-security treaty, or Montenegrin mandatory (state) insurance. In practice in 2025–2026 MUP offices expect a local “zdravstveno osiguranje stranaca” policy — a product every major local insurer sells: Sava, Lovćen, Uniqa, Generali, Grawe.',
			RipWhy3:
				'The law does not say how long the policy must be valid — and that is where the differences begin. Each MUP office interprets the requirement its own way: some accept a policy covering only the application review period (30–60 days), others demand coverage for the entire future permit, i.e. up to 2 years.',
			RipWhy4:
				'Applicants in expat communities explain the logic behind the trend: historically the policy was only needed for the review period, because employees and company directors receive state insurance (zdravstvena knjižica) once the permit is issued. Digital nomads and other non-working categories never get the knjižica — so full-period insurance requirements have been spreading from one MUP office to another.',

			RipDuration1:
				'There is no published nationwide rule — what follows is applicant experience from 2025–2026, and it changes without notice. By city (mostly digital-nomad and similar “non-working” applications):',
			RipDurationBudva:
				'Budva — the strictest: a 2-year policy for both the first application and renewal (a rule applicants report since spring 2025). There is a Sava office near the MUP building; a 2-year policy costs about €504;',
			RipDurationCoast:
				'Bar, Tivat, Ulcinj — 2 years as well; in Ulcinj a 40-day policy was rejected and the applicant had to buy a 2-year one the same day;',
			RipDurationCetinje:
				'Cetinje — 2 years plus a statement from a Montenegrin bank; applicants generally advise against applying there;',
			RipDurationPodgorica:
				'Podgorica — short policies are accepted: 60 days (€35), 40 days, one–two months;',
			RipDurationHercegNovi:
				'Herceg Novi — 3 months is enough, cases with 2 months were also accepted;',
			RipDurationFamily:
				'Family reunification (spajanje porodice) — the minimum is 30 days per person, and every family member, including children, needs their own policy; people usually buy 40 days (~€30) as a buffer.',
			RipDuration2:
				'One more pattern from applicant reports: if the review drags on past your policy’s validity, the MUP may request a fresh one. A real case from 2026: a 40-day Sava policy expired while a family-reunification application was still being processed — the office asked for a new policy before issuing the card.',
			RipDuration3:
				'Requirements differ by office and can change. Before buying, ask the MUP office handling the application for the required duration and acceptable document format, preferably in writing. Local applicant reports can show what to ask about but are not an official rule and should not be the sole basis for purchase.',

			RipBuying1:
				'The easiest way is an insurer’s office: you come with just a passport, and in about ten minutes they print the policy form with a “wet” stamp and hand you two copies — one for the MUP file, one for you. Offices of Sava, Lovćen and Uniqa exist in every larger town, often within walking distance of the MUP building.',
			RipBuying2:
				'Buying online is possible and sometimes cheaper, but printouts of e-policies regularly cause problems: Sava offices refuse to stamp policies bought online, and MUP clerks accept an unstamped printout only after phoning the insurer to verify it — some do, some simply turn it away.',
			RipBuying3:
				'Offices and websites do not always sell the same thing: in Herceg Novi the Sava office refused to issue a 2-year policy (maximum one year in person) while the same 2-year product exists online. If you need a long policy, check availability in advance.',
			RipBuying4:
				'International insurance (Genki, SafetyWing and similar) was still accepted by some offices in 2023; by 2025–2026 MUP offices almost always want a policy from a local insurer.',
			RipPrices0:
				'Reference prices from applicant reports, July 2026 (mostly Sava; other insurers are close):',
			RipPricesShort: '40 days — about €30; 60 days — €35;',
			RipPrices3m:
				'3 months — around €50 for one adult, €84–86 for a family policy covering up to 3 persons (online price);',
			RipPricesYear:
				'1 year — roughly €200–300 depending on the insurer (Uniqa quoted €300);',
			RipPrices2y:
				'2 years — €504 (the standard “nomad” policy for Budva-type requirements). The coverage limit of a typical policy is about €10,000.',

			RipCoverage1:
				'These policies commonly target unforeseen acute illness and accidents, but the actual benefits, medicines, tests, limits, deductibles and exclusions are defined by the individual wording. Do not assume a policy will pay for an event because another family received reimbursement; obtain the terms and, where possible, written pre-authorisation.',
			RipCoverage2:
				'What is not covered: chronic and pre-existing conditions (a claim was refused because the insurer classified the case as chronic), vitamins and supplements, and anything that started before the policy was bought. Extended packages without these exclusions exist but cost considerably more.',
			RipCoverage3:
				'Many products use reimbursement: the patient pays and submits the required invoices and medical records. Direct billing is possible only when the insurer confirms the provider and case in advance; a phone call alone is not a guarantee. Ask in writing about authorisation, required documents, payment account and time limit before treatment when the situation is not urgent.',
			RipCoverage4:
				'Forum reports about one insurer paying more reliably than another are anecdotal and are not a fair basis for ranking insurers. Compare published wording, complaint handling and the regulator information. Whether treatment that began under an expired policy remains covered depends on the occurrence definition and continuity clauses; obtain written confirmation for the specific case.',
			RipCoverage5:
				'If you end up paying out of pocket anyway, compare clinics and their prices in our',
			RipCoverage5Link: 'clinic catalog',
			RipCoverage5End: '.',

			RipKnjizica1:
				'If residence is based on qualifying employment, the employer normally initiates registration for compulsory insurance once the legal conditions are met. Do not cancel the private policy merely because the application is pending: confirm that FZOCG status is active and ask MUP what proof must remain valid. State benefits are governed by referral, provider, programme and Fund-list rules rather than being unlimited full coverage.',
			RipKnjizica2:
				'Eligibility for compulsory state insurance depends on the current legal category and individual facts. Digital-nomad status, property ownership or company ownership without employment does not by itself create cover, but do not treat this article as an eligibility decision. Family-member cover and coordination with foreign insurance also depend on applicable rules. Confirm the basis and documents directly with FZOCG before relying on private insurance alone.',
			RipKnjizica3:
				'How the state system works, what the knjižica gives and what paid options exist without it — see our guide',
			RipKnjizica3Link: 'how healthcare works in Montenegro',
			RipKnjizica3End: '.',

			RipSources0:
				'Figures and practice described here are current as of July 2026. City requirements change quickly — always verify before applying:',
			RipSourcesLaw:
				'Zakon o strancima (“Sl. list CG” 12/2018, with amendments), Article 43 — the health-insurance condition for temporary residence: paragraf.me;',
			RipSourcesInsurers:
				'insurers’ products for foreigners: sava.co.me, lovcen-osiguranje.me, uniqa.me;',
			RipSourcesMup:
				'current requirements of your municipality — the MUP (Ministry of Interior) office where you apply: gov.me;',
			RipSourcesChat:
				'city-by-city durations, prices and office practices are compiled from applicant reports in expat communities (2025–2026) — treat them as experience of real applications, not as official rules.',
		},
		ru: {
			ResidenceInsuranceTitle: 'Медицинская страховка для ВНЖ в Черногории',
			ResidenceInsuranceDescription:
				'Зачем при подаче на боравак нужна медицинская страховка, на какой срок её требуют в разных городах — от 40 дней в Подгорице до 2 лет в Будве, — цены Sava, Lovćen и Uniqa, что полис реально покрывает и кому вместо него положена государственная страховка. Актуально на июль 2026.',

			'RipToc_why-required': 'Почему для ВНЖ нужна страховка',
			RipToc_duration: 'На какой срок требуют в разных городах',
			RipToc_buying: 'Где и как купить полис',
			RipToc_coverage: 'Что полис реально покрывает',
			RipToc_knjizica: 'Кому вместо полиса положена госстраховка',
			RipToc_sources: 'Источники и оговорка',

			RipWhy1:
				'Требование идёт из закона об иностранцах (Zakon o strancima, «Sl. list CG» 12/2018 с последующими изменениями): статья 43, пункт 1, подпункт 3 среди условий временного ВНЖ называет то, что заявитель «ima zdravstveno osiguranje» — имеет медицинскую страховку. Это касается всех оснований: работа, воссоединение семьи, недвижимость, учёба, цифровой кочевник.',
			RipWhy2:
				'Подзаконные акты допускают три вида подтверждения: полис туристической или медицинской страховки от страховщика, работающего в Черногории, страховку по международному соглашению или черногорскую обязательную (государственную) страховку. На практике в 2025–2026 годах МУПы ждут местный полис «zdravstveno osiguranje stranaca» — такой продукт есть у всех крупных страховщиков: Sava, Lovćen, Uniqa, Generali, Grawe.',
			RipWhy3:
				'На какой срок должен действовать полис, закон не говорит — и именно здесь начинаются различия. Каждый МУП трактует требование по-своему: где-то достаточно полиса на период рассмотрения заявки (30–60 дней), а где-то требуют покрытие на весь срок будущего ВНЖ — то есть до 2 лет.',
			RipWhy4:
				'Заявители в чатах переехавших объясняют логику происходящего так: исторически страховка была нужна только на время рассмотрения, потому что наёмные работники и директора фирм после выдачи ВНЖ получают государственную страховку (zdravstvena knjižica). Цифровым кочевникам и другим «неработающим» категориям книжица не положена вовсе — поэтому требование страховки на весь срок постепенно расползается из одного МУПа в другой.',

			RipDuration1:
				'Единого опубликованного правила нет — ниже опыт заявителей 2025–2026 годов, и он меняется без предупреждения. По городам (в основном подачи цифровых кочевников и похожих «неработающих» оснований):',
			RipDurationBudva:
				'Будва — строже всех: полис на 2 года и при первичной подаче, и при продлении (правило, о котором заявители сообщают с весны 2025 года). Рядом со зданием МУП есть офис Sava; полис на 2 года стоит около 504 €;',
			RipDurationCoast:
				'Бар, Тиват, Улцинь — тоже 2 года; в Улцине полис на 40 дней не приняли, и заявителю пришлось в тот же день купить двухлетний;',
			RipDurationCetinje:
				'Цетине — 2 года плюс справка из черногорского банка; заявители в целом советуют туда не подаваться;',
			RipDurationPodgorica:
				'Подгорица — принимают короткие полисы: 60 дней (35 €), 40 дней, месяц-два;',
			RipDurationHercegNovi:
				'Херцег-Нови — достаточно 3 месяцев, были случаи и с 2 месяцами;',
			RipDurationFamily:
				'Воссоединение семьи (spajanje porodice) — минимум 30 дней на человека, причём полис нужен каждому члену семьи, включая детей; обычно берут 40 дней (~30 €) с запасом.',
			RipDuration2:
				'Ещё одна закономерность из отчётов заявителей: если рассмотрение затягивается и полис успевает истечь, МУП может запросить новый. Реальный случай 2026 года: полис Sava на 40 дней закончился, пока рассматривали заявку на воссоединение, — и перед выдачей карточки попросили донести свежий.',
			RipDuration3:
				'Требования различаются между отделениями и меняются. Перед покупкой спросите именно в МУП, который принимает заявление, какой срок и формат документа нужны сейчас, по возможности получите ответ письменно. Местные отчёты заявителей помогают понять, что уточнить, но не являются официальным правилом и не должны быть единственным основанием для покупки.',

			RipBuying1:
				'Проще всего — офис страховой: приходите с одним паспортом, и минут за десять вам распечатают бланк полиса с «мокрой» печатью и выдадут два экземпляра — один в дело МУПа, второй вам. Офисы Sava, Lovćen и Uniqa есть в каждом крупном городе, часто в пешей доступности от здания МУП.',
			RipBuying2:
				'Купить онлайн можно, и иногда это дешевле, но распечатки электронных полисов регулярно вызывают проблемы: офисы Sava отказываются ставить печати на купленные онлайн полисы, а сотрудники МУП принимают распечатку без печати только после звонка страховщику для проверки — кто-то звонит, а кто-то просто разворачивает.',
			RipBuying3:
				'Офисы и сайты не всегда продают одно и то же: в Херцег-Нови офис Sava отказался оформить полис на 2 года (лично — максимум год), хотя онлайн такой продукт есть. Если нужен длинный полис — проверьте доступность заранее.',
			RipBuying4:
				'Международные страховки (Genki, SafetyWing и подобные) в 2023 году некоторые отделения ещё принимали; к 2025–2026 годам МУПы почти всегда хотят полис местного страховщика.',
			RipPrices0:
				'Ориентировочные цены из отчётов заявителей, июль 2026 (в основном Sava; у других страховщиков близко):',
			RipPricesShort: '40 дней — около 30 €; 60 дней — 35 €;',
			RipPrices3m:
				'3 месяца — около 50 € на одного взрослого, 84–86 € за семейный полис до 3 человек (цена онлайн);',
			RipPricesYear:
				'1 год — примерно 200–300 € в зависимости от страховщика (Uniqa называла 300 €);',
			RipPrices2y:
				'2 года — 504 € (стандартный «номадский» полис под требования типа будванских). Лимит покрытия типового полиса — около 10 000 €.',

			RipCoverage1:
				'Такие полисы обычно рассчитаны на внезапную острую болезнь и несчастный случай, но конкретные услуги, лекарства, анализы, лимиты, франшизы и исключения определяет договор. Не считайте случай покрытым только потому, что другой семье что-то возместили: изучите правила и по возможности получите письменное предварительное согласование.',
			RipCoverage2:
				'Что не покрывается: хронические и существовавшие до покупки заболевания (был случай отказа в выплате, потому что страховщик счёл случай хроническим), витамины и добавки, а также всё, что началось до оформления полиса. Расширенные пакеты без этих исключений существуют, но стоят заметно дороже.',
			RipCoverage3:
				'Во многих продуктах действует возмещение: пациент платит и подаёт требуемые счета и медицинские документы. Прямой расчёт возможен только после подтверждения страховщиком конкретной клиники и случая; одного звонка недостаточно для гарантии. Если ситуация не экстренная, заранее письменно уточните согласование, документы, счёт для выплаты и срок рассмотрения.',
			RipCoverage4:
				'Отзывы о том, что один страховщик платит надёжнее другого, — частный опыт и недостаточное основание для рейтинга компаний. Сравнивайте опубликованные правила, работу с жалобами и сведения регулятора. Продолжится ли покрытие лечения, начатого при истёкшем полисе, зависит от определения страхового события и условий непрерывности; по конкретному случаю просите письменный ответ.',
			RipCoverage5:
				'Если всё же придётся платить из своего кармана — сравните клиники и их цены в нашем',
			RipCoverage5Link: 'каталоге клиник',
			RipCoverage5End: '.',

			RipKnjizica1:
				'Если ВНЖ основан на трудоустройстве, работодатель обычно начинает регистрацию в обязательном страховании после выполнения законных условий. Не отменяйте частный полис только потому, что заявление рассматривается: подтвердите активный статус в FZOCG и спросите МУП, до какого момента должен действовать документ. Государственное покрытие ограничено правилами направлений, договорных учреждений, программ и списка Фонда и не является безлимитным.',
			RipKnjizica2:
				'Право на государственную обязательную страховку зависит от актуального законного основания и обстоятельств человека. Статус цифрового кочевника, недвижимость или владение фирмой без трудоустройства сами по себе не создают покрытие, но статья не заменяет решение о вашем праве. Страхование членов семьи и координация с иностранной страховкой также зависят от правил. До того как полагаться только на частный полис, подтвердите основание и документы непосредственно в FZOCG.',
			RipKnjizica3:
				'Как устроена государственная система, что даёт книжица и какие есть платные варианты без неё — в нашем гиде',
			RipKnjizica3Link: 'как устроена медицина в Черногории',
			RipKnjizica3End: '.',

			RipSources0:
				'Цифры и практика в статье актуальны на июль 2026 года. Требования городов меняются быстро — перед подачей обязательно перепроверяйте:',
			RipSourcesLaw:
				'Zakon o strancima («Sl. list CG» 12/2018, с изменениями), статья 43 — условие о медицинской страховке для временного ВНЖ: paragraf.me;',
			RipSourcesInsurers:
				'продукты страховщиков для иностранцев: sava.co.me, lovcen-osiguranje.me, uniqa.me;',
			RipSourcesMup:
				'актуальные требования вашего муниципалитета — отделение МУП (МВД), куда вы подаётесь: gov.me;',
			RipSourcesChat:
				'сроки, цены и практика по городам собраны из отчётов заявителей в сообществах переехавших (2025–2026) — относитесь к ним как к опыту реальных подач, а не официальным правилам.',
		},
		sr: {
			ResidenceInsuranceTitle: 'Zdravstveno osiguranje za boravak u Crnoj Gori',
			ResidenceInsuranceDescription:
				'Zašto je za zahtjev za boravak potrebno zdravstveno osiguranje, na koji period polisu traže u različitim gradovima — od 40 dana u Podgorici do 2 godine u Budvi — cijene kod Sava, Lovćen i Uniqa osiguranja, šta polisa stvarno pokriva i ko umjesto nje dobija državno osiguranje. Ažurirano: jul 2026.',

			'RipToc_why-required': 'Zašto je za boravak potrebno osiguranje',
			RipToc_duration: 'Na koji period traže u različitim gradovima',
			RipToc_buying: 'Gdje i kako kupiti polisu',
			RipToc_coverage: 'Šta polisa stvarno pokriva',
			RipToc_knjizica: 'Ko umjesto polise dobija državno osiguranje',
			RipToc_sources: 'Izvori i napomena',

			RipWhy1:
				'Zahtjev proizilazi iz Zakona o strancima („Sl. list CG“ 12/2018 sa kasnijim izmjenama): član 43, stav 1, tačka 3 među uslovima za privremeni boravak navodi da podnosilac „ima zdravstveno osiguranje“. Ovo važi za sve osnove: rad, spajanje porodice, nekretninu, školovanje, digitalnog nomada.',
			RipWhy2:
				'Podzakonski akti prihvataju tri vrste dokaza: polisu putnog ili zdravstvenog osiguranja osiguravača ovlašćenog u Crnoj Gori, osiguranje po međunarodnom sporazumu ili crnogorsko obavezno (državno) osiguranje. U praksi 2025–2026. filijale MUP-a očekuju lokalnu polisu „zdravstveno osiguranje stranaca“ — takav proizvod ima svaki veći osiguravač: Sava, Lovćen, Uniqa, Generali, Grawe.',
			RipWhy3:
				'Koliko dugo polisa mora da važi, zakon ne kaže — i tu počinju razlike. Svaka filijala MUP-a tumači zahtjev na svoj način: negdje je dovoljna polisa za period razmatranja zahtjeva (30–60 dana), a negdje traže pokriće za cijeli period budućeg boravka — dakle do 2 godine.',
			RipWhy4:
				'Podnosioci u zajednicama doseljenika ovako objašnjavaju logiku: istorijski je polisa bila potrebna samo za period razmatranja, jer zaposleni i direktori firmi nakon izdavanja boravka dobijaju državno osiguranje (zdravstvenu knjižicu). Digitalni nomadi i druge „neradne“ kategorije knjižicu ne dobijaju nikada — pa se zahtjev za osiguranjem na cijeli period postepeno širi iz jedne filijale MUP-a u drugu.',

			RipDuration1:
				'Jedinstveno objavljeno pravilo ne postoji — slijedi iskustvo podnosilaca iz 2025–2026, koje se mijenja bez najave. Po gradovima (uglavnom zahtjevi digitalnih nomada i sličnih „neradnih“ osnova):',
			RipDurationBudva:
				'Budva — najstroža: polisa na 2 godine i kod prve podaje i kod produženja (pravilo o kojem podnosioci izvještavaju od proljeća 2025). Pored zgrade MUP-a postoji filijala Sava osiguranja; polisa na 2 godine košta oko 504 €;',
			RipDurationCoast:
				'Bar, Tivat, Ulcinj — takođe 2 godine; u Ulcinju polisa na 40 dana nije prihvaćena i podnosilac je istog dana morao kupiti dvogodišnju;',
			RipDurationCetinje:
				'Cetinje — 2 godine plus potvrda iz crnogorske banke; podnosioci uglavnom savjetuju da se tamo ne podnosi zahtjev;',
			RipDurationPodgorica:
				'Podgorica — prihvataju se kratke polise: 60 dana (35 €), 40 dana, mjesec-dva;',
			RipDurationHercegNovi:
				'Herceg Novi — dovoljno je 3 mjeseca, bilo je slučajeva i sa 2 mjeseca;',
			RipDurationFamily:
				'Spajanje porodice — minimum je 30 dana po osobi, pri čemu polisu mora imati svaki član porodice, uključujući djecu; obično se kupuje 40 dana (~30 €) sa rezervom.',
			RipDuration2:
				'Još jedna pravilnost iz izvještaja podnosilaca: ako se razmatranje oduži i polisa istekne, MUP može zatražiti novu. Stvaran slučaj iz 2026: polisa Sava na 40 dana istekla je dok je zahtjev za spajanje porodice još bio u obradi — i prije izdavanja kartice tražili su da se donese svježa.',
			RipDuration3:
				'Zahtjevi se razlikuju među kancelarijama i mijenjaju se. Prije kupovine pitajte MUP koji prima zahtjev koji rok i format dokumenta trenutno traži, po mogućnosti pisanim putem. Lokalna iskustva podnosilaca pomažu da znate šta pitati, ali nijesu zvanično pravilo i ne treba da budu jedini osnov za kupovinu.',

			RipBuying1:
				'Najjednostavnije je u filijali osiguravača: dođete samo sa pasošem i za desetak minuta štampaju vam obrazac polise sa „mokrim“ pečatom i daju dva primjerka — jedan za dosije MUP-a, drugi za vas. Filijale Sava, Lovćen i Uniqa osiguranja postoje u svakom većem gradu, često na pješačkoj udaljenosti od zgrade MUP-a.',
			RipBuying2:
				'Kupovina onlajn je moguća i ponekad jeftinija, ali odštampane e-polise redovno prave probleme: filijale Sava osiguranja odbijaju da stave pečat na polise kupljene onlajn, a službenici MUP-a prihvataju odštampanu polisu bez pečata tek nakon telefonske provjere kod osiguravača — neko zove, a neko jednostavno vrati.',
			RipBuying3:
				'Filijale i sajtovi ne prodaju uvijek isto: u Herceg Novom filijala Sava osiguranja odbila je da izda polisu na 2 godine (lično — najviše godinu), iako onlajn takav proizvod postoji. Ako vam treba duga polisa — provjerite dostupnost unaprijed.',
			RipBuying4:
				'Međunarodna osiguranja (Genki, SafetyWing i slična) 2023. su neke filijale još prihvatale; do 2025–2026. MUP gotovo uvijek traži polisu lokalnog osiguravača.',
			RipPrices0:
				'Orijentacione cijene iz izvještaja podnosilaca, jul 2026 (uglavnom Sava; kod drugih osiguravača slično):',
			RipPricesShort: '40 dana — oko 30 €; 60 dana — 35 €;',
			RipPrices3m:
				'3 mjeseca — oko 50 € za jednu odraslu osobu, 84–86 € za porodičnu polisu do 3 osobe (onlajn cijena);',
			RipPricesYear:
				'1 godina — otprilike 200–300 € u zavisnosti od osiguravača (Uniqa je navela 300 €);',
			RipPrices2y:
				'2 godine — 504 € (standardna „nomadska“ polisa za zahtjeve tipa budvanskih). Limit pokrića tipične polise je oko 10.000 €.',

			RipCoverage1:
				'Ove polise su obično namijenjene iznenadnoj akutnoj bolesti i nezgodi, ali konkretne usluge, ljekove, testove, limite, franšize i isključenja određuju uslovi. Ne pretpostavljajte pokriće zato što je druga porodica dobila refundaciju; pročitajte pravila i, kada je moguće, tražite pisano prethodno odobrenje.',
			RipCoverage2:
				'Šta nije pokriveno: hronične bolesti i stanja nastala prije kupovine (bilo je odbijanja isplate jer je osiguravač slučaj ocijenio kao hroničan), vitamini i suplementi, kao i sve što je počelo prije zaključenja polise. Prošireni paketi bez ovih isključenja postoje, ali koštaju znatno više.',
			RipCoverage3:
				'Mnogi proizvodi rade kroz refundaciju: pacijent plaća i dostavlja tražene račune i medicinsku dokumentaciju. Direktno plaćanje moguće je samo kada osiguravač unaprijed potvrdi ustanovu i slučaj; sam poziv nije garancija. Ako nije hitno, pisano provjerite odobrenje, dokumente, račun za isplatu i rok obrade.',
			RipCoverage4:
				'Iskustva sa foruma da jedan osiguravač plaća pouzdanije od drugog anegdotalna su i nijesu dovoljan osnov za rangiranje. Uporedite objavljene uslove, postupak prigovora i podatke regulatora. Da li liječenje započeto pod isteklom polisom ostaje pokriveno zavisi od definicije događaja i klauzula o kontinuitetu; tražite pisanu potvrdu za konkretan slučaj.',
			RipCoverage5:
				'Ako ipak budete plaćali iz svog džepa — uporedite klinike i njihove cijene u našem',
			RipCoverage5Link: 'katalogu klinika',
			RipCoverage5End: '.',

			RipKnjizica1:
				'Ako je boravak zasnovan na zaposlenju koje daje pravo, poslodavac obično pokreće obavezno osiguranje kada su ispunjeni zakonski uslovi. Ne otkazujte privatnu polisu samo zato što je zahtjev u obradi: potvrdite aktivan status u FZOCG i pitajte MUP do kada dokaz mora važiti. Državno pokriće prati pravila uputa, ustanova, programa i liste Fonda i nije neograničeno.',
			RipKnjizica2:
				'Pravo na obavezno državno osiguranje zavisi od važećeg pravnog osnova i pojedinačnih činjenica. Status digitalnog nomada, nekretnina ili vlasništvo firme bez zaposlenja sami ne stvaraju pokriće, ali ovaj tekst nije odluka o pravu. Osiguranje porodice i usklađivanje sa stranom polisom takođe zavise od pravila. Prije oslanjanja samo na privatnu polisu provjerite osnov i dokumente direktno kod FZOCG.',
			RipKnjizica3:
				'Kako funkcioniše državni sistem, šta daje knjižica i koje plaćene opcije postoje bez nje — u našem vodiču',
			RipKnjizica3Link: 'kako funkcioniše zdravstvo u Crnoj Gori',
			RipKnjizica3End: '.',

			RipSources0:
				'Brojke i praksa iz članka važe za jul 2026. Zahtjevi gradova se brzo mijenjaju — prije podnošenja obavezno provjerite:',
			RipSourcesLaw:
				'Zakon o strancima („Sl. list CG“ 12/2018, sa izmjenama), član 43 — uslov o zdravstvenom osiguranju za privremeni boravak: paragraf.me;',
			RipSourcesInsurers:
				'proizvodi osiguravača za strance: sava.co.me, lovcen-osiguranje.me, uniqa.me;',
			RipSourcesMup:
				'aktuelni zahtjevi vaše opštine — filijala MUP-a u kojoj podnosite zahtjev: gov.me;',
			RipSourcesChat:
				'periodi, cijene i praksa po gradovima prikupljeni su iz izvještaja podnosilaca u zajednicama doseljenika (2025–2026) — tretirajte ih kao iskustvo stvarnih podnošenja, a ne kao zvanična pravila.',
		},
		'sr-cyrl': {
			ResidenceInsuranceTitle: 'Здравствено осигурање за боравак у Црној Гори',
			ResidenceInsuranceDescription:
				'Зашто је за захтјев за боравак потребно здравствено осигурање, на који период полису траже у различитим градовима — од 40 дана у Подгорици до 2 године у Будви — цијене код Sava, Lovćen и Uniqa осигурања, шта полиса стварно покрива и ко умјесто ње добија државно осигурање. Ажурирано: јул 2026.',

			'RipToc_why-required': 'Зашто је за боравак потребно осигурање',
			RipToc_duration: 'На који период траже у различитим градовима',
			RipToc_buying: 'Гдје и како купити полису',
			RipToc_coverage: 'Шта полиса стварно покрива',
			RipToc_knjizica: 'Ко умјесто полисе добија државно осигурање',
			RipToc_sources: 'Извори и напомена',

			RipWhy1:
				'Захтјев произилази из Закона о странцима („Сл. лист ЦГ“ 12/2018 са каснијим измјенама): члан 43, став 1, тачка 3 међу условима за привремени боравак наводи да подносилац „има здравствено осигурање“. Ово важи за све основе: рад, спајање породице, некретнину, школовање, дигиталног номада.',
			RipWhy2:
				'Подзаконски акти прихватају три врсте доказа: полису путног или здравственог осигурања осигуравача овлашћеног у Црној Гори, осигурање по међународном споразуму или црногорско обавезно (државно) осигурање. У пракси 2025–2026. филијале МУП-а очекују локалну полису „здравствено осигурање странаца“ — такав производ има сваки већи осигуравач: Sava, Lovćen, Uniqa, Generali, Grawe.',
			RipWhy3:
				'Колико дуго полиса мора да важи, закон не каже — и ту почињу разлике. Свака филијала МУП-а тумачи захтјев на свој начин: негдје је довољна полиса за период разматрања захтјева (30–60 дана), а негдје траже покриће за цијели период будућег боравка — дакле до 2 године.',
			RipWhy4:
				'Подносиоци у заједницама досељеника овако објашњавају логику: историјски је полиса била потребна само за период разматрања, јер запослени и директори фирми након издавања боравка добијају државно осигурање (здравствену књижицу). Дигитални номади и друге „нерадне“ категорије књижицу не добијају никада — па се захтјев за осигурањем на цијели период постепено шири из једне филијале МУП-а у другу.',

			RipDuration1:
				'Јединствено објављено правило не постоји — слиједи искуство подносилаца из 2025–2026, које се мијења без најаве. По градовима (углавном захтјеви дигиталних номада и сличних „нерадних“ основа):',
			RipDurationBudva:
				'Будва — најстрожа: полиса на 2 године и код прве подаје и код продужења (правило о којем подносиоци извјештавају од прољећа 2025). Поред зграде МУП-а постоји филијала Sava осигурања; полиса на 2 године кошта око 504 €;',
			RipDurationCoast:
				'Бар, Тиват, Улцињ — такође 2 године; у Улцињу полиса на 40 дана није прихваћена и подносилац је истог дана морао купити двогодишњу;',
			RipDurationCetinje:
				'Цетиње — 2 године плус потврда из црногорске банке; подносиоци углавном савјетују да се тамо не подноси захтјев;',
			RipDurationPodgorica:
				'Подгорица — прихватају се кратке полисе: 60 дана (35 €), 40 дана, мјесец-два;',
			RipDurationHercegNovi:
				'Херцег Нови — довољно је 3 мјесеца, било је случајева и са 2 мјесеца;',
			RipDurationFamily:
				'Спајање породице — минимум је 30 дана по особи, при чему полису мора имати сваки члан породице, укључујући дјецу; обично се купује 40 дана (~30 €) са резервом.',
			RipDuration2:
				'Још једна правилност из извјештаја подносилаца: ако се разматрање одужи и полиса истекне, МУП може затражити нову. Стваран случај из 2026: полиса Sava на 40 дана истекла је док је захтјев за спајање породице још био у обради — и прије издавања картице тражили су да се донесе свјежа.',
			RipDuration3:
				'Захтјеви се разликују међу канцеларијама и мијењају се. Прије куповине питајте МУП који прима захтјев који рок и формат документа тренутно тражи, по могућности писаним путем. Локална искуства подносилаца помажу да знате шта питати, али нијесу званично правило и не треба да буду једини основ за куповину.',

			RipBuying1:
				'Најједноставније је у филијали осигуравача: дођете само са пасошем и за десетак минута штампају вам образац полисе са „мокрим“ печатом и дају два примјерка — један за досије МУП-а, други за вас. Филијале Sava, Lovćen и Uniqa осигурања постоје у сваком већем граду, често на пјешачкој удаљености од зграде МУП-а.',
			RipBuying2:
				'Куповина онлајн је могућа и понекад јефтинија, али одштампане е-полисе редовно праве проблеме: филијале Sava осигурања одбијају да ставе печат на полисе купљене онлајн, а службеници МУП-а прихватају одштампану полису без печата тек након телефонске провјере код осигуравача — неко зове, а неко једноставно врати.',
			RipBuying3:
				'Филијале и сајтови не продају увијек исто: у Херцег Новом филијала Sava осигурања одбила је да изда полису на 2 године (лично — највише годину), иако онлајн такав производ постоји. Ако вам треба дуга полиса — провјерите доступност унапријед.',
			RipBuying4:
				'Међународна осигурања (Genki, SafetyWing и слична) 2023. су неке филијале још прихватале; до 2025–2026. МУП готово увијек тражи полису локалног осигуравача.',
			RipPrices0:
				'Оријентационе цијене из извјештаја подносилаца, јул 2026 (углавном Sava; код других осигуравача слично):',
			RipPricesShort: '40 дана — око 30 €; 60 дана — 35 €;',
			RipPrices3m:
				'3 мјесеца — око 50 € за једну одраслу особу, 84–86 € за породичну полису до 3 особе (онлајн цијена);',
			RipPricesYear:
				'1 година — отприлике 200–300 € у зависности од осигуравача (Uniqa је навела 300 €);',
			RipPrices2y:
				'2 године — 504 € (стандардна „номадска“ полиса за захтјеве типа будванских). Лимит покрића типичне полисе је око 10.000 €.',

			RipCoverage1:
				'Ове полисе су обично намијењене изненадној акутној болести и незгоди, али конкретне услуге, љекове, тестове, лимите, франшизе и искључења одређују услови. Не претпостављајте покриће зато што је друга породица добила рефундацију; прочитајте правила и, када је могуће, тражите писано претходно одобрење.',
			RipCoverage2:
				'Шта није покривено: хроничне болести и стања настала прије куповине (било је одбијања исплате јер је осигуравач случај оцијенио као хроничан), витамини и суплементи, као и све што је почело прије закључења полисе. Проширени пакети без ових искључења постоје, али коштају знатно више.',
			RipCoverage3:
				'Многи производи раде кроз рефундацију: пацијент плаћа и доставља тражене рачуне и медицинску документацију. Директно плаћање могуће је само када осигуравач унапријед потврди установу и случај; сам позив није гаранција. Ако није хитно, писано провјерите одобрење, документе, рачун за исплату и рок обраде.',
			RipCoverage4:
				'Искуства са форума да један осигуравач плаћа поузданије од другог анегдотална су и нијесу довољан основ за рангирање. Упоредите објављене услове, поступак приговора и податке регулатора. Да ли лијечење започето под истеклом полисом остаје покривено зависи од дефиниције догађаја и клаузула о континуитету; тражите писану потврду за конкретан случај.',
			RipCoverage5:
				'Ако ипак будете плаћали из свог џепа — упоредите клинике и њихове цијене у нашем',
			RipCoverage5Link: 'каталогу клиника',
			RipCoverage5End: '.',

			RipKnjizica1:
				'Ако је боравак заснован на запослењу које даје право, послодавац обично покреће обавезно осигурање када су испуњени законски услови. Не отказујте приватну полису само зато што је захтјев у обради: потврдите активан статус у FZOCG и питајте МУП до када доказ мора важити. Државно покриће прати правила упута, установа, програма и листе Фонда и није неограничено.',
			RipKnjizica2:
				'Право на обавезно државно осигурање зависи од важећег правног основа и појединачних чињеница. Статус дигиталног номада, некретнина или власништво фирме без запослења сами не стварају покриће, али овај текст није одлука о праву. Осигурање породице и усклађивање са страном полисом такође зависе од правила. Прије ослањања само на приватну полису провјерите основ и документе директно код FZOCG.',
			RipKnjizica3:
				'Како функционише државни систем, шта даје књижица и које плаћене опције постоје без ње — у нашем водичу',
			RipKnjizica3Link: 'како функционише здравство у Црној Гори',
			RipKnjizica3End: '.',

			RipSources0:
				'Бројке и пракса из чланка важе за јул 2026. Захтјеви градова се брзо мијењају — прије подношења обавезно провјерите:',
			RipSourcesLaw:
				'Закон о странцима („Сл. лист ЦГ“ 12/2018, са измјенама), члан 43 — услов о здравственом осигурању за привремени боравак: paragraf.me;',
			RipSourcesInsurers:
				'производи осигуравача за странце: sava.co.me, lovcen-osiguranje.me, uniqa.me;',
			RipSourcesMup:
				'актуелни захтјеви ваше општине — филијала МУП-а у којој подносите захтјев: gov.me;',
			RipSourcesChat:
				'периоди, цијене и пракса по градовима прикупљени су из извјештаја подносилаца у заједницама досељеника (2025–2026) — третирајте их као искуство стварних подношења, а не као званична правила.',
		},
		de: {
			ResidenceInsuranceTitle:
				'Krankenversicherung für die Aufenthaltsgenehmigung in Montenegro',
			ResidenceInsuranceDescription:
				'Warum jeder Boravak-Antrag eine Krankenversicherung braucht, für welche Dauer die Städte eine Police verlangen — von 40 Tagen in Podgorica bis 2 Jahren in Budva —, Preise bei Sava, Lovćen und Uniqa, was die Police wirklich abdeckt und wer stattdessen die staatliche Versicherung erhält. Stand: Juli 2026.',

			'RipToc_why-required':
				'Warum der Aufenthaltstitel eine Versicherung erfordert',
			RipToc_duration: 'Welche Laufzeit die einzelnen Städte verlangen',
			RipToc_buying: 'Wo und wie man eine Police kauft',
			RipToc_coverage: 'Was die Police wirklich abdeckt',
			RipToc_knjizica: 'Wer stattdessen die staatliche Versicherung bekommt',
			RipToc_sources: 'Quellen und Vorbehalt',

			RipWhy1:
				'Die Anforderung stammt aus dem Ausländergesetz (Zakon o strancima, „Sl. list CG“ 12/2018 mit späteren Änderungen): Artikel 43 Absatz 1 Nummer 3 nennt unter den Bedingungen für den befristeten Aufenthalt, dass der Antragsteller „ima zdravstveno osiguranje“ — eine Krankenversicherung hat. Das gilt für jeden Aufenthaltstyp: Arbeit, Familienzusammenführung, Immobilienbesitz, Studium, Digitalnomade.',
			RipWhy2:
				'Die Durchführungsvorschriften akzeptieren drei Nachweise: eine Reise- oder Krankenversicherungspolice eines in Montenegro zugelassenen Versicherers, eine Versicherung nach einem internationalen Abkommen oder die montenegrinische Pflichtversicherung. In der Praxis erwarten die MUP-Stellen 2025–2026 eine lokale Police „zdravstveno osiguranje stranaca“ — ein Produkt, das jeder größere Versicherer anbietet: Sava, Lovćen, Uniqa, Generali, Grawe.',
			RipWhy3:
				'Wie lange die Police gelten muss, sagt das Gesetz nicht — und genau hier beginnen die Unterschiede. Jede MUP-Stelle legt die Anforderung eigenständig aus: Manche akzeptieren eine Police nur für die Bearbeitungszeit des Antrags (30–60 Tage), andere verlangen Deckung für die gesamte künftige Aufenthaltsdauer, also bis zu 2 Jahre.',
			RipWhy4:
				'Antragsteller in Expat-Communities erklären die Logik dahinter so: Früher brauchte man die Police nur für die Bearbeitungszeit, weil Angestellte und Firmendirektoren nach Erteilung des Titels die staatliche Versicherung (zdravstvena knjižica) erhalten. Digitalnomaden und andere „nicht erwerbstätige“ Kategorien bekommen die knjižica nie — deshalb breitet sich die Forderung nach einer Police für die gesamte Laufzeit von einer MUP-Stelle zur nächsten aus.',

			RipDuration1:
				'Eine veröffentlichte landesweite Regel gibt es nicht — das Folgende ist Antragsteller-Erfahrung aus 2025–2026 und ändert sich ohne Ankündigung. Nach Städten (überwiegend Anträge von Digitalnomaden und ähnlichen „nicht erwerbstätigen“ Kategorien):',
			RipDurationBudva:
				'Budva — am strengsten: eine 2-Jahres-Police sowohl beim Erstantrag als auch bei der Verlängerung (eine Regel, von der Antragsteller seit Frühjahr 2025 berichten). Nahe dem MUP-Gebäude gibt es eine Sava-Filiale; die 2-Jahres-Police kostet etwa 504 €;',
			RipDurationCoast:
				'Bar, Tivat, Ulcinj — ebenfalls 2 Jahre; in Ulcinj wurde eine 40-Tage-Police abgelehnt, und der Antragsteller musste noch am selben Tag eine 2-Jahres-Police kaufen;',
			RipDurationCetinje:
				'Cetinje — 2 Jahre plus Bescheinigung einer montenegrinischen Bank; Antragsteller raten generell davon ab, dort einzureichen;',
			RipDurationPodgorica:
				'Podgorica — kurze Policen werden akzeptiert: 60 Tage (35 €), 40 Tage, ein bis zwei Monate;',
			RipDurationHercegNovi:
				'Herceg Novi — 3 Monate reichen, auch Fälle mit 2 Monaten wurden akzeptiert;',
			RipDurationFamily:
				'Familienzusammenführung (spajanje porodice) — Minimum sind 30 Tage pro Person, und jedes Familienmitglied, auch Kinder, braucht eine eigene Police; üblicherweise kauft man 40 Tage (~30 €) als Puffer.',
			RipDuration2:
				'Noch ein Muster aus den Berichten: Zieht sich die Bearbeitung über die Gültigkeit der Police hinaus, kann das MUP eine neue verlangen. Ein realer Fall aus 2026: Eine 40-Tage-Police von Sava lief ab, während ein Familienzusammenführungsantrag noch bearbeitet wurde — vor Ausgabe der Karte wurde eine frische Police nachgefordert.',
			RipDuration3:
				'Anforderungen unterscheiden sich je nach Dienststelle und ändern sich. Fragen Sie vor dem Kauf die zuständige MUP-Stelle nach Laufzeit und akzeptiertem Dokumentformat, möglichst schriftlich. Lokale Erfahrungsberichte zeigen, was zu klären ist, sind aber keine amtliche Regel und sollten nicht alleinige Kaufgrundlage sein.',

			RipBuying1:
				'Am einfachsten ist die Filiale eines Versicherers: Sie kommen nur mit dem Pass, und in etwa zehn Minuten wird das Policenformular mit „nassem“ Stempel gedruckt — Sie erhalten zwei Exemplare, eines für die MUP-Akte, eines für sich. Filialen von Sava, Lovćen und Uniqa gibt es in jeder größeren Stadt, oft fußläufig zum MUP-Gebäude.',
			RipBuying2:
				'Der Online-Kauf ist möglich und manchmal günstiger, aber Ausdrucke von E-Policen machen regelmäßig Probleme: Sava-Filialen weigern sich, online gekaufte Policen zu stempeln, und MUP-Beamte akzeptieren einen ungestempelten Ausdruck nur nach telefonischer Verifizierung beim Versicherer — manche rufen an, andere weisen ihn schlicht zurück.',
			RipBuying3:
				'Filialen und Websites verkaufen nicht immer dasselbe: In Herceg Novi weigerte sich die Sava-Filiale, eine 2-Jahres-Police auszustellen (vor Ort maximal ein Jahr), obwohl es das Produkt online gibt. Wer eine lange Police braucht, sollte die Verfügbarkeit vorab klären.',
			RipBuying4:
				'Internationale Versicherungen (Genki, SafetyWing und ähnliche) wurden 2023 von einigen Stellen noch akzeptiert; 2025–2026 verlangen die MUP-Stellen fast immer eine Police eines lokalen Versicherers.',
			RipPrices0:
				'Richtpreise aus Antragsteller-Berichten, Juli 2026 (überwiegend Sava; andere Versicherer liegen ähnlich):',
			RipPricesShort: '40 Tage — etwa 30 €; 60 Tage — 35 €;',
			RipPrices3m:
				'3 Monate — rund 50 € für einen Erwachsenen, 84–86 € für eine Familienpolice für bis zu 3 Personen (Online-Preis);',
			RipPricesYear:
				'1 Jahr — grob 200–300 € je nach Versicherer (Uniqa nannte 300 €);',
			RipPrices2y:
				'2 Jahre — 504 € (die Standard-„Nomaden“-Police für Anforderungen wie in Budva). Die Deckungssumme einer typischen Police liegt bei etwa 10.000 €.',

			RipCoverage1:
				'Diese Policen zielen meist auf unerwartete akute Krankheit und Unfälle; konkrete Leistungen, Arzneimittel, Tests, Grenzen, Selbstbehalte und Ausschlüsse bestimmt der Vertrag. Nehmen Sie Deckung nicht an, nur weil eine andere Familie Erstattung erhielt. Lesen Sie die Bedingungen und holen Sie möglichst eine schriftliche Vorabgenehmigung ein.',
			RipCoverage2:
				'Nicht abgedeckt sind: chronische und vorbestehende Erkrankungen (eine Erstattung wurde verweigert, weil der Versicherer den Fall als chronisch einstufte), Vitamine und Nahrungsergänzungsmittel sowie alles, was vor dem Abschluss der Police begann. Erweiterte Pakete ohne diese Ausschlüsse existieren, kosten aber deutlich mehr.',
			RipCoverage3:
				'Viele Produkte erstatten nachträglich: Der Patient zahlt und reicht Rechnungen und medizinische Unterlagen ein. Direktabrechnung ist nur möglich, wenn der Versicherer Leistungserbringer und Fall vorab bestätigt; ein Anruf allein ist keine Garantie. Wenn es nicht dringend ist, Genehmigung, Unterlagen, Auszahlungskonto und Frist vorher schriftlich klären.',
			RipCoverage4:
				'Forenberichte, ein Versicherer zahle zuverlässiger als ein anderer, sind anekdotisch und keine faire Rangliste. Vergleichen Sie veröffentlichte Bedingungen, Beschwerdeverfahren und Aufsichtsinformationen. Ob unter einer abgelaufenen Police begonnene Behandlung weiter gedeckt ist, hängt von Ereignisdefinition und Fortsetzungsklauseln ab; schriftliche Bestätigung zum Einzelfall verlangen.',
			RipCoverage5:
				'Wenn Sie ohnehin selbst zahlen müssen — vergleichen Sie Kliniken und ihre Preise in unserem',
			RipCoverage5Link: 'Klinikkatalog',
			RipCoverage5End: '.',

			RipKnjizica1:
				'Beruht der Aufenthalt auf anspruchsbegründender Beschäftigung, leitet der Arbeitgeber die Pflichtversicherung gewöhnlich nach Erfüllung der Voraussetzungen ein. Die Privatpolice nicht nur wegen eines laufenden Antrags kündigen: aktiven FZOCG-Status bestätigen und MUP nach der nötigen Gültigkeit fragen. Staatliche Leistungen folgen Überweisungs-, Vertrags-, Programm- und Fondslistenregeln und sind keine unbegrenzte Vollversicherung.',
			RipKnjizica2:
				'Der Anspruch auf staatliche Pflichtversicherung hängt von Rechtsgrund und Einzelfall ab. Digitalnomadenstatus, Immobilie oder Firmeneigentum ohne Beschäftigung schaffen allein keine Deckung; dieser Text ist keine Anspruchsentscheidung. Familienversicherung und Koordination mit ausländischer Versicherung richten sich ebenfalls nach den Regeln. Grundlage und Unterlagen direkt bei FZOCG prüfen, bevor Sie nur auf eine private Police vertrauen.',
			RipKnjizica3:
				'Wie das staatliche System funktioniert, was die knjižica bietet und welche bezahlten Optionen es ohne sie gibt — in unserem Leitfaden',
			RipKnjizica3Link: 'so funktioniert das Gesundheitswesen in Montenegro',
			RipKnjizica3End: '.',

			RipSources0:
				'Zahlen und Praxis in diesem Artikel sind auf dem Stand von Juli 2026. Die Anforderungen der Städte ändern sich schnell — prüfen Sie vor der Antragstellung unbedingt:',
			RipSourcesLaw:
				'Zakon o strancima („Sl. list CG“ 12/2018, mit Änderungen), Artikel 43 — die Krankenversicherungsbedingung für den befristeten Aufenthalt: paragraf.me;',
			RipSourcesInsurers:
				'Produkte der Versicherer für Ausländer: sava.co.me, lovcen-osiguranje.me, uniqa.me;',
			RipSourcesMup:
				'aktuelle Anforderungen Ihrer Gemeinde — die MUP-Stelle (Innenministerium), bei der Sie den Antrag stellen: gov.me;',
			RipSourcesChat:
				'Laufzeiten, Preise und Behördenpraxis je Stadt stammen aus Berichten von Antragstellern in Expat-Communities (2025–2026) — verstehen Sie sie als Erfahrung realer Anträge, nicht als offizielle Regeln.',
		},
		tr: {
			ResidenceInsuranceTitle: 'Karadağ oturum izni için sağlık sigortası',
			ResidenceInsuranceDescription:
				"Boravak başvurusunda sağlık sigortası neden zorunlu, şehirler poliçeyi hangi süre için istiyor — Podgorica'da 40 günden Budva'da 2 yıla —, Sava, Lovćen ve Uniqa fiyatları, poliçenin gerçekte neyi kapsadığı ve kimin bunun yerine devlet sigortası aldığı. Güncelleme: Temmuz 2026.",

			'RipToc_why-required': 'Oturum izni için sigorta neden gerekli',
			RipToc_duration: 'Şehirler hangi süreyi istiyor',
			RipToc_buying: 'Poliçe nereden ve nasıl alınır',
			RipToc_coverage: 'Poliçe gerçekte neyi kapsar',
			RipToc_knjizica: 'Bunun yerine kim devlet sigortası alır',
			RipToc_sources: 'Kaynaklar ve uyarı',

			RipWhy1:
				'Şart, Yabancılar Kanunu\'ndan (Zakon o strancima, "Sl. list CG" 12/2018, sonraki değişikliklerle) gelir: 43. maddenin 1. fıkrasının 3. bendi, geçici oturum koşulları arasında başvuranın "ima zdravstveno osiguranje" — sağlık sigortasına sahip olmasını sayar. Bu, tüm izin türleri için geçerlidir: çalışma, aile birleşimi, gayrimenkul, eğitim, dijital göçebe.',
			RipWhy2:
				'Uygulama kuralları üç tür kanıt kabul eder: Karadağ\'da yetkili bir sigortacının seyahat veya sağlık sigortası poliçesi, uluslararası anlaşma kapsamında sigorta veya Karadağ zorunlu (devlet) sigortası. Uygulamada 2025–2026\'da MUP ofisleri yerel "zdravstveno osiguranje stranaca" poliçesi bekler — bu ürün her büyük yerel sigortacıda vardır: Sava, Lovćen, Uniqa, Generali, Grawe.',
			RipWhy3:
				'Poliçenin ne kadar süre geçerli olması gerektiğini kanun söylemez — farklılıklar da tam burada başlar. Her MUP ofisi şartı kendine göre yorumlar: bazıları yalnızca başvuru inceleme dönemini (30–60 gün) kapsayan poliçeyi kabul eder, bazıları ise gelecekteki iznin tamamı için — yani 2 yıla kadar — teminat ister.',
			RipWhy4:
				'Göçmen topluluklarındaki başvuru sahipleri bu eğilimin mantığını şöyle açıklıyor: eskiden poliçe yalnızca inceleme dönemi için gerekiyordu, çünkü çalışanlar ve şirket direktörleri izin verildikten sonra devlet sigortasını (zdravstvena knjižica) alır. Dijital göçebeler ve diğer "çalışmayan" kategoriler knjižica\'yı hiçbir zaman alamaz — bu yüzden tüm dönem için sigorta şartı bir MUP ofisinden diğerine yayılıyor.',

			RipDuration1:
				'Yayımlanmış ülke çapında bir kural yok — aşağıdakiler 2025–2026 başvuru deneyimidir ve habersiz değişir. Şehirlere göre (çoğunlukla dijital göçebe ve benzeri "çalışmayan" başvurular):',
			RipDurationBudva:
				'Budva — en katı olanı: hem ilk başvuruda hem yenilemede 2 yıllık poliçe (başvuranların 2025 baharından beri bildirdiği kural). MUP binasının yakınında bir Sava şubesi var; 2 yıllık poliçe yaklaşık 504 €;',
			RipDurationCoast:
				"Bar, Tivat, Ulcinj — yine 2 yıl; Ulcinj'de 40 günlük poliçe reddedildi ve başvuran aynı gün 2 yıllık poliçe almak zorunda kaldı;",
			RipDurationCetinje:
				'Cetinje — 2 yıl artı Karadağ bankasından hesap belgesi; başvuranlar genel olarak oraya başvurmamayı öneriyor;',
			RipDurationPodgorica:
				'Podgorica — kısa poliçeler kabul ediliyor: 60 gün (35 €), 40 gün, bir-iki ay;',
			RipDurationHercegNovi:
				'Herceg Novi — 3 ay yeterli, 2 ayla kabul edilen vakalar da oldu;',
			RipDurationFamily:
				'Aile birleşimi (spajanje porodice) — kişi başı minimum 30 gün; çocuklar dahil her aile üyesinin kendi poliçesi olmalı; genellikle pay bırakmak için 40 günlük (~30 €) alınıyor.',
			RipDuration2:
				"Başvuru raporlarından bir başka örüntü: inceleme poliçenizin geçerliliğini aşarsa, MUP yenisini isteyebilir. 2026'dan gerçek bir vaka: 40 günlük Sava poliçesi, aile birleşimi başvurusu hâlâ işlemdeyken doldu — kart verilmeden önce taze bir poliçe istendi.",
			RipDuration3:
				'Gereklilikler ofise göre değişir ve güncellenebilir. Satın almadan önce başvuruyu alan MUP ofisine gereken süreyi ve belge biçimini, mümkünse yazılı olarak sorun. Yerel başvuru deneyimleri ne sorulacağını gösterebilir, ancak resmi kural değildir ve satın almanın tek dayanağı olmamalıdır.',

			RipBuying1:
				'En kolay yol sigortacının şubesidir: yalnızca pasaportla gelirsiniz, yaklaşık on dakikada poliçe formunu "ıslak" kaşeyle basıp size iki nüsha verirler — biri MUP dosyası, biri sizin için. Sava, Lovćen ve Uniqa şubeleri her büyük şehirde vardır, çoğu zaman MUP binasına yürüme mesafesindedir.',
			RipBuying2:
				'Online satın almak mümkün ve bazen daha ucuz, ancak e-poliçe çıktıları düzenli olarak sorun çıkarır: Sava şubeleri online alınan poliçelere kaşe basmayı reddeder; MUP memurları kaşesiz çıktıyı ancak sigortacıyı telefonla arayıp doğruladıktan sonra kabul eder — kimi arar, kimi ise doğrudan geri çevirir.',
			RipBuying3:
				"Şubeler ve siteler her zaman aynı şeyi satmaz: Herceg Novi'de Sava şubesi 2 yıllık poliçe düzenlemeyi reddetti (yüz yüze en fazla bir yıl), oysa aynı ürün online mevcut. Uzun poliçe gerekiyorsa müsaitliği önceden kontrol edin.",
			RipBuying4:
				"Uluslararası sigortalar (Genki, SafetyWing ve benzerleri) 2023'te bazı ofislerce hâlâ kabul ediliyordu; 2025–2026 itibarıyla MUP ofisleri neredeyse her zaman yerel sigortacının poliçesini istiyor.",
			RipPrices0:
				'Başvuru raporlarından referans fiyatlar, Temmuz 2026 (çoğunlukla Sava; diğer sigortacılar yakın):',
			RipPricesShort: '40 gün — yaklaşık 30 €; 60 gün — 35 €;',
			RipPrices3m:
				'3 ay — bir yetişkin için yaklaşık 50 €, 3 kişiye kadar aile poliçesi için 84–86 € (online fiyat);',
			RipPricesYear:
				'1 yıl — sigortacıya göre kabaca 200–300 € (Uniqa 300 € teklif etti);',
			RipPrices2y:
				'2 yıl — 504 € (Budva tipi şartlar için standart "göçebe" poliçesi). Tipik poliçenin teminat limiti yaklaşık 10.000 €.',

			RipCoverage1:
				'Bu poliçeler genellikle beklenmedik akut hastalık ve kazayı hedefler; belirli hizmetleri, ilaçları, testleri, limitleri, muafiyeti ve istisnaları sözleşme belirler. Başka aile geri ödeme aldı diye kapsam varsaymayın; koşulları okuyun ve mümkünse yazılı ön onay alın.',
			RipCoverage2:
				'Kapsanmayanlar: kronik ve önceden var olan hastalıklar (sigortacı vakayı kronik saydığı için bir geri ödeme reddedildi), vitaminler ve takviyeler, ayrıca poliçe alınmadan önce başlayan her şey. Bu istisnaları içermeyen genişletilmiş paketler var, ancak belirgin şekilde daha pahalı.',
			RipCoverage3:
				'Birçok ürün geri ödeme usulüyle işler: hasta öder, fatura ve tıbbi belgeleri sunar. Doğrudan ödeme yalnız sigortacı kurum ve vakayı önceden doğrularsa mümkündür; telefon görüşmesi tek başına garanti değildir. Acil değilse onayı, belgeleri, ödeme hesabını ve süreyi önceden yazılı sorun.',
			RipCoverage4:
				'Bir sigortacının diğerinden daha güvenilir ödediğine ilişkin forum deneyimleri anekdottur ve sıralama için yeterli değildir. Yayımlanmış koşulları, şikâyet sürecini ve düzenleyici bilgilerini karşılaştırın. Süresi dolan poliçe altında başlayan tedavinin devamı olay tanımına ve süreklilik maddelerine bağlıdır; somut vaka için yazılı yanıt isteyin.',
			RipCoverage5:
				'Yine de cebinizden ödemek zorunda kalırsanız — klinikleri ve fiyatlarını',
			RipCoverage5Link: 'klinik kataloğumuzda',
			RipCoverage5End: ' karşılaştırın.',

			RipKnjizica1:
				'Oturum hak doğuran çalışmaya dayanıyorsa işveren yasal koşullar karşılanınca zorunlu sigorta kaydını genellikle başlatır. Başvuru sürüyor diye özel poliçeyi iptal etmeyin: FZOCG statüsünün aktifliğini doğrulayın ve belgenin ne kadar geçerli kalacağını MUP ofisine sorun. Devlet kapsamı sevk, sözleşmeli kurum, program ve Fon listesi kurallarına bağlıdır ve sınırsız değildir.',
			RipKnjizica2:
				'Devlet zorunlu sigorta hakkı güncel hukuki dayanağa ve kişisel duruma bağlıdır. Dijital göçebe statüsü, taşınmaz veya çalışmasız şirket sahipliği tek başına kapsam yaratmaz; bu metin hak kararı değildir. Aile kapsamı ve yabancı sigortayla koordinasyon da kurallara bağlıdır. Yalnız özel poliçeye güvenmeden önce dayanak ve belgeleri doğrudan FZOCG kurumundan doğrulayın.',
			RipKnjizica3:
				'Devlet sistemi nasıl işler, knjižica ne sağlar ve onsuz hangi ücretli seçenekler var —',
			RipKnjizica3Link: "Karadağ'da sağlık sistemi nasıl işler",
			RipKnjizica3End: ' rehberimizde.',

			RipSources0:
				'Makaledeki rakamlar ve uygulama Temmuz 2026 itibarıyla günceldir. Şehirlerin şartları hızla değişir — başvurmadan önce mutlaka doğrulayın:',
			RipSourcesLaw:
				'Zakon o strancima ("Sl. list CG" 12/2018, değişikliklerle), 43. madde — geçici oturum için sağlık sigortası şartı: paragraf.me;',
			RipSourcesInsurers:
				'sigortacıların yabancılara yönelik ürünleri: sava.co.me, lovcen-osiguranje.me, uniqa.me;',
			RipSourcesMup:
				'belediyenizin güncel şartları — başvurduğunuz MUP (İçişleri Bakanlığı) ofisi: gov.me;',
			RipSourcesChat:
				'şehirlere göre süreler, fiyatlar ve ofis uygulamaları göçmen topluluklarındaki başvuru raporlarından derlenmiştir (2025–2026) — bunları resmi kurallar olarak değil, gerçek başvuruların deneyimi olarak değerlendirin.',
		},
	},
};
