// Контент статьи «Аптеки и лекарства в Черногории: рецепты, аналоги, что взять с собой».
// Факты сверены с montefarm.co.me (гос. сеть, ~45 аптек), fzocg.me (lista ljekova:
// основная ~1046 препаратов + доплатная ~89; аптеки по договору с Фондом),
// ezdravlje.me (eRecept, eApoteka, eNaručivanje), cinmed.me (реестр препаратов),
// benu.me и данными русскоязычных чатов о реальном опыте (2023–2026).
// Актуальность: июль 2026.
export default {
	messages: {
		'en': {
			PharmaciesTitle:
				'Pharmacies and medications in Montenegro: prescriptions, analogs, what to bring',
			PharmaciesDescription:
				'How pharmacies work in Montenegro: the state Montefarm chain and private Benu and Tea Medica, on-duty pharmacies, e-prescriptions and why foreign prescriptions are not accepted, free medications from the Fund list, and how to find local analogs of your usual drugs. Current as of July 2026.',

			'PhaToc_pharmacies': 'How pharmacies work: Montefarm, private chains, on-duty',
			'PhaToc_prescriptions': 'Prescriptions: Montenegrin and electronic only',
			'PhaToc_fond-list': 'Free medications from the Fund list',
			'PhaToc_analogs': 'Analogs of your usual drugs and what to bring',
			'PhaToc_sources': 'Useful links and sources',

			PhaPharmacies1:
				'There are plenty of pharmacies (apoteka) in Montenegro, and they form two parallel systems. The state chain is ZU “Apoteke Crne Gore Montefarm” — about 45 pharmacies covering every municipality. The private side is dominated by two chains, Benu (on the market since 2017, the most widespread network) and Tea Medica (the largest private chain, operating since 2004), plus many independent pharmacies.',
			PhaPharmacies2:
				'The difference matters if you are insured: prescriptions covered by the Health Insurance Fund (FZOCG) are traditionally filled at Montefarm pharmacies, and more recently also at private pharmacies that signed a contract with the Fund (the list is published on fzocg.me). The eApoteka service on the eZdravlje portal shows which of the Fund-contracted pharmacies have your drug in stock. Without insurance you can buy at any pharmacy — at full price.',
			PhaPharmacies3:
				'Typical opening hours are roughly 7–8 a.m. to 9–10 p.m., and many pharmacies close on Sundays. Big towns have round-the-clock spots: Podgorica has three — Montefarm “Kruševac” (Bulevar Svetog Petra Cetinjskog 45/a), BENU on Moskovska 22, and Holos 7 on Bulevar Oktobarske Revolucije 31; in Budva it’s the BENU opposite the bus station; in Nikšić, Montefarm “Gojko Darić” on Radoja Dakića bb. For public holidays Montefarm publishes a list of on-duty pharmacies for every municipality.',
			PhaPharmacies4:
				'The prescription/OTC line is drawn differently than you may be used to. Antibiotic tablets, sleeping pills, antidepressants and most “serious” drugs are strictly prescription-only — no amount of persuasion helps. On the other hand, painkillers (ibuprofen — sold here mostly as Brufen — and paracetamol), many ointments and drops, and even, according to expat forums, ',
			PhaPharmacies4Link: 'adrenaline ampoules',
			PhaPharmacies4End:
				' are sold freely. Adrenaline is a potent emergency drug, though: it is not something to self-administer without medical training or a doctor-confirmed reason (such as a diagnosed severe allergy) — if you might need it, get it prescribed and get shown how to use it first. Pharmacists are usually happy to help you find an analog, and on the coast many speak English.',

			PhaPrescriptions1:
				'The main rule: foreign prescriptions are not valid in Montenegrin pharmacies — neither Russian, nor EU, nor any other. The stories in expat chats repeat year after year: with a home-country prescription in hand you will not be sold the drug; at best you will be advised to show it to a local doctor. The prescription must be Montenegrin.',
			PhaPrescriptions2:
				'Getting one is not hard. With a zdravstvena knjižica your izabrani doktor at the dom zdravlja issues prescriptions for free. Without one, any licensed doctor can prescribe after a paid consultation: roughly €10–25 at a dom zdravlja, €30–50 at a private clinic. Bring your home prescription or a doctor’s report with the active substance and dosage — the local doctor will re-issue it as a Montenegrin prescription. One caveat: nobody will prescribe “a year’s supply” — a prescription usually covers up to a month of treatment, so refills mean coming back.',
			PhaPrescriptions3:
				'Prescriptions are electronic (eRecept): the doctor enters them into the system and the pharmacy sees them under your number. A handwritten paper prescription will most likely be refused — a real case from February 2025: a doctor wrote a child’s prescription by hand because the drug was missing from the e-system, and the pharmacy would not hand over the medication that was physically sitting in its fridge until an electronic prescription appeared. Private-clinic prescriptions (with the doctor’s and the clinic’s stamps) are usually accepted when you pay full price, but some pharmacies may still send you to the dom zdravlja for an e-prescription.',
			PhaPrescriptions4:
				'One more local quirk: not every doctor will write the prescription — only the “right” one. A real example: at the Kotor hospital an ENT gave the patient a treatment report but sent them to a GP at the dom zdravlja for the actual prescription; psychotropic drugs are prescribed by a psychiatrist or neurologist. If you book a visit just for a prescription, check in advance that the doctor can prescribe your specific drug.',

			PhaFond1:
				'For those insured with FZOCG there is a “positive list” of medications (lista ljekova): the basic list — over a thousand drugs that the Fund covers in full — and the supplementary list of about 90 more, where the patient pays the price difference. One prescription covers one drug for at most 30 days of treatment.',
			PhaFond2a:
				'In practice this means nearly free therapy for chronic conditions. A telling story from an expat chat: a local psychiatrist’s prescription for ',
			PhaFond2SertralineLink: 'sertraline (Zoloft)',
			PhaFond2b:
				', a state pharmacy — and “we paid 30 cents for 2 packs”. Chronic patients can also use the eNaručivanje service to order repeat therapy electronically, without visiting the doctor each time.',
			PhaFond3:
				'All of this is available only with a zdravstvena knjižica — who is entitled to one and how to get it is covered in detail in our article',
			PhaFond3Link: 'about the Montenegrin healthcare system',
			PhaFond3End: '.',

			PhaAnalogs1a:
				'Familiar brand names are rarely found in Montenegro, but the active substances are the same: the market is supplied by Balkan and European manufacturers (Hemofarm, Krka, Alkaloid, Galenika and others). So search for a drug by its international nonproprietary name (INN) written in Latin script, not by brand: not “Nurofen” but ',
			PhaAnalogs1IbuprofenLink: 'ibuprofen',
			PhaAnalogs1b: ' (the local equivalent is Brufen), not “Euthyrox” but ',
			PhaAnalogs1LevothyroxineLink: 'levothyroxine',
			PhaAnalogs1c:
				'. Given the active substance, a pharmacist will find the local analog.',
			PhaAnalogs2:
				'You can check whether a drug is registered in Montenegro and whether it is sold over the counter in our',
			PhaAnalogs2Link: 'register of approved medicines',
			PhaAnalogs2End: '.',
			PhaAnalogs3:
				'Not everything can be found: the market is small, some drugs are simply not registered in Montenegro — a pharmacy will not sell them even with a prescription — and registered ones occasionally disappear from stock. In such cases pharmacies can order medications from Serbia or Bosnia — ask on the spot. Avoid buying prescription drugs “second-hand” via chat groups: legality and safety aside, prepayment scammers do appear there. Two examples worth knowing: cyclosporine (sold abroad as Ikervis or Restasis eye drops) has no local analog — only plain lubricating eye drops are available; valacyclovir and famciclovir aren’t registered either, only acyclovir is, and only as tablets or a skin cream — there is no eye ointment form.',
			PhaAnalogs4:
				'If you are relocating and take something regularly, it is reasonable to bring a supply for the first months — in personal-use quantities and original packaging — plus a recent doctor’s report with the INN and dosages: it makes getting a local prescription much easier. For strong painkillers and psychotropic drugs, check the customs rules of Montenegro and your transit country in advance — proof of prescription is normally required. Some people just keep bringing their medication from home indefinitely, and that works too — but if you would rather not depend on trips back, switching to a local analog with a doctor in the first few weeks is the more resilient option.',

			PhaSources0:
				'The information is current as of July 2026. Assortments, lists and rules change — verify with the primary sources:',
			PhaSourcesMontefarm:
				'Montefarm — the state pharmacy chain: addresses, hours, on-duty pharmacies: montefarm.co.me;',
			PhaSourcesFzo:
				'FZOCG — the Fund’s drug lists (basic and supplementary) and pharmacies contracted by the Fund: fzocg.me;',
			PhaSourcesEzdravlje:
				'eZdravlje portal — eRecept (your prescriptions) and eApoteka (drug availability in Fund pharmacies): ezdravlje.me;',
			PhaSourcesCinmed:
				'CInMED — the Institute for Medicines and Medical Devices of Montenegro, the official register of approved drugs: cinmed.me;',
			PhaSourcesBenu: 'Private chains — ',
			PhaSourcesBenuLink: 'Benu',
			PhaSourcesBenuMid: ' and ',
			PhaSourcesTeaMedicaLink: 'Tea Medica',
			PhaSourcesBenuEnd: ': pharmacies across the country.',
			PhaSourcesCatalog:
				'Need a doctor who will sort out your therapy and issue a prescription? Our catalog shows the languages each doctor speaks —',
			PhaSourcesCatalogLink: 'find a doctor who speaks your language',
			PhaSourcesCatalogEnd: '.',

			PhaCtaTitle: 'Looking for a specific medication?',
			PhaCtaText:
				'Check whether it is registered in Montenegro and how it is dispensed in our catalog.',
			PhaCtaButton: 'Medications catalog',
		},
		'ru': {
			PharmaciesTitle:
				'Аптеки и лекарства в Черногории: рецепты, аналоги, что взять с собой',
			PharmaciesDescription:
				'Как работают аптеки в Черногории: государственная сеть Montefarm и частные Benu и Tea Medica, дежурные аптеки, электронные рецепты и почему иностранный рецепт не примут, бесплатные лекарства по списку Фонда и как искать аналоги привычных препаратов. Актуально на июль 2026 года.',

			'PhaToc_pharmacies': 'Как работают аптеки: Montefarm, частные сети, дежурные',
			'PhaToc_prescriptions': 'Рецепты: только черногорские и только электронные',
			'PhaToc_fond-list': 'Бесплатные лекарства по списку Фонда',
			'PhaToc_analogs': 'Аналоги привычных препаратов и что взять с собой',
			'PhaToc_sources': 'Полезные ссылки и источники',

			PhaPharmacies1:
				'Аптек (apoteka) в Черногории много, и устроены они в две параллельные системы. Государственная сеть — ZU «Apoteke Crne Gore Montefarm»: около 45 аптек во всех муниципалитетах страны. Частный сектор — прежде всего две сети: Benu (на рынке с 2017 года, самая разветвлённая) и Tea Medica (крупнейшая частная сеть, работает с 2004 года), плюс множество независимых аптек.',
			PhaPharmacies2:
				'Разница важна для застрахованных: лекарства по рецепту за счёт Фонда медицинского страхования (FZOCG) традиционно выдают аптеки Montefarm, а с недавних пор — и частные аптеки, заключившие договор с Фондом (список опубликован на fzocg.me). Сервис eApoteka на портале eZdravlje показывает, в какой из «фондовских» аптек препарат есть в наличии. Без страховки покупать можно в любой аптеке — по полной цене.',
			PhaPharmacies3:
				'Обычный график работы — примерно с 7–8 утра до 21–22 часов, по воскресеньям многие закрыты. В крупных городах есть круглосуточные точки: в Подгорице их три — Montefarm «Kruševac» (бульвар Св. Петра Цетинского, 45/а), BENU на Московской, 22, и Holos 7 на бульваре Октябрьской революции, 31; в Будве — Benu напротив автовокзала; в Никшиче — Montefarm «Gojko Darić» на Radoja Dakića bb. На праздники Montefarm публикует список дежурных аптек по каждому муниципалитету.',
			PhaPharmacies4:
				'Граница «рецептурное/безрецептурное» проходит не так, как вы, возможно, привыкли. Таблетированные антибиотики, снотворные, антидепрессанты и большинство «серьёзных» препаратов — строго по рецепту, уговорить фармацевта не выйдет. Зато обезболивающие (ибупрофен — здесь это чаще Brufen — и парацетамол), многие мази, капли и даже, по опыту форумов, ',
			PhaPharmacies4Link: 'ампулы адреналина',
			PhaPharmacies4End:
				' продаются свободно. Адреналин — сильнодействующий экстренный препарат: колоть его самостоятельно без медицинской подготовки или подтверждённого врачом показания (например, диагностированной тяжёлой аллергии) не стоит — если он может понадобиться, получите рецепт и инструктаж у врача заранее. Фармацевты обычно охотно помогают подобрать аналог; на побережье многие говорят по-английски.',

			PhaPrescriptions1:
				'Главное правило: иностранные рецепты в черногорских аптеках не действуют — ни российские, ни европейские, никакие. Истории в чатах повторяются из года в год: с домашним рецептом на руках препарат не продадут, максимум посоветуют показать его местному врачу. Рецепт должен быть черногорским.',
			PhaPrescriptions2:
				'Получить его несложно. Со здравственной книжицей рецепты бесплатно выписывает izabrani doktor в доме здравля. Без книжицы рецепт выпишет любой лицензированный врач после платной консультации: в доме здравля это порядка 10–25 €, в частной клинике — 30–50 €. Возьмите с собой домашний рецепт или заключение врача с действующим веществом и дозировкой — на их основании местный врач оформит черногорский рецепт. Нюанс: «на год вперёд» не выпишут — рецепт обычно покрывает до месяца лечения, за продлением придётся приходить снова.',
			PhaPrescriptions3:
				'Рецепты электронные (eRecept): врач вносит назначение в систему, и аптека видит его по вашему номеру. Бумажный рецепт «от руки» аптека, скорее всего, не примет — реальный случай февраля 2025 года: врач выписал ребёнку рецепт вручную, потому что препарата не оказалось в электронной программе, и аптека отказалась выдать лекарство, которое физически лежало у неё в холодильнике, пока не появился электронный рецепт. Рецепты частных клиник (с печатью врача и учреждения) при покупке за свои деньги обычно принимают, но иногда могут отправить за электронным рецептом в дом здравля.',
			PhaPrescriptions4:
				'Ещё одна местная особенность: рецепт выпишет не любой врач, а «профильный». Реальный пример: в которской больнице ЛОР выдал пациенту назначение, но за самим рецептом отправил к терапевту в дом здравля; психотропные препараты выписывает психиатр или невролог. Если записываетесь к врачу ради рецепта, заранее уточните, сможет ли он выписать именно ваш препарат.',

			PhaFond1:
				'Для застрахованных в FZOCG действует «позитивный список» лекарств (lista ljekova): основной список (osnovna lista) — больше тысячи препаратов, которые Фонд оплачивает полностью, и доплатный (doplatna) — ещё около 90, где пациент доплачивает разницу в цене. По одному рецепту выдают один препарат максимум на 30 дней лечения.',
			PhaFond2a:
				'На практике это означает почти бесплатную терапию хронических заболеваний. Показательная история из чата: рецепт на ',
			PhaFond2SertralineLink: 'сертралин (Золофт)',
			PhaFond2b:
				' от местного психиатра, государственная аптека — и «за 2 пачки отдали 30 центов». Хроническим пациентам доступен сервис eNaručivanje — повторную терапию можно заказать электронно, не приходя к врачу каждый раз.',
			PhaFond3:
				'Всё это доступно только со здравственной книжицей — кому она положена и как её оформить, подробно разбираем в статье',
			PhaFond3Link: 'о системе здравоохранения Черногории',
			PhaFond3End: '.',

			PhaAnalogs1a:
				'Привычные торговые названия в Черногории почти не встречаются, но действующие вещества те же: рынок наполняют балканские и европейские производители (Hemofarm, Krka, Alkaloid, Galenika и другие). Поэтому ищите препарат не по бренду, а по международному непатентованному наименованию (МНН), записанному латиницей: не «Нурофен», а ',
			PhaAnalogs1IbuprofenLink: 'ibuprofen',
			PhaAnalogs1b: ' (местный аналог — Brufen), не «Эутирокс», а ',
			PhaAnalogs1LevothyroxineLink: 'levotiroksin',
			PhaAnalogs1c: '. По действующему веществу фармацевт подберёт местный аналог.',
			PhaAnalogs2:
				'Проверить, зарегистрирован ли препарат в Черногории и продаётся ли он без рецепта, можно в нашем',
			PhaAnalogs2Link: 'реестре лекарств',
			PhaAnalogs2End: '.',
			PhaAnalogs3:
				'Находится не всё: рынок маленький, отдельные препараты в Черногории просто не зарегистрированы — аптека не продаст их даже по рецепту, — а зарегистрированные периодически пропадают из наличия. В таких случаях аптеки привозят лекарства под заказ из Сербии или Боснии — спросите на месте. Покупать рецептурные препараты «с рук» через чаты не стоит: помимо законности и безопасности, там встречаются мошенники, исчезающие после предоплаты. Два показательных примера: циклоспорину (за рубежом — глазные капли Икервис или Рестасис) местного аналога нет — есть только обычные увлажняющие капли; валацикловир и фамцикловир тоже не зарегистрированы, есть только ацикловир — и то в виде таблеток и крема для рук, глазной мази нет.',
			PhaAnalogs4:
				'Если вы переезжаете и принимаете что-то постоянно, разумно взять с собой запас на первые месяцы — в личных количествах и в оригинальных упаковках — и свежее заключение врача с МНН и дозировками: с ним получить местный рецепт заметно проще. Для сильнодействующих и психотропных препаратов заранее проверьте таможенные правила Черногории и страны транзита — как правило, требуется подтверждение назначения от врача. Многие так и живут, периодически привозя препараты «оттуда», — это тоже рабочий вариант. Но если не хочется зависеть от поездок, в первые недели можно вместе с врачом подобрать местный аналог.',

			PhaSources0:
				'Информация актуальна на июль 2026 года. Ассортимент, списки и правила меняются — сверяйтесь с первоисточниками:',
			PhaSourcesMontefarm:
				'Montefarm — государственная аптечная сеть: адреса, график, дежурные аптеки: montefarm.co.me;',
			PhaSourcesFzo:
				'FZOCG — списки лекарств Фонда (основной и доплатный) и аптеки, работающие по договору с Фондом: fzocg.me;',
			PhaSourcesEzdravlje:
				'Портал eZdravlje — eRecept (ваши рецепты) и eApoteka (наличие препаратов в аптеках Фонда): ezdravlje.me;',
			PhaSourcesCinmed:
				'CInMED — Институт лекарств и медицинских изделий Черногории, официальный реестр зарегистрированных препаратов: cinmed.me;',
			PhaSourcesBenu: 'Частные сети — ',
			PhaSourcesBenuLink: 'Benu',
			PhaSourcesBenuMid: ' и ',
			PhaSourcesTeaMedicaLink: 'Tea Medica',
			PhaSourcesBenuEnd: ': аптеки по всей стране.',
			PhaSourcesCatalog:
				'Нужен врач, который разберётся в вашей терапии и выпишет рецепт? В нашем каталоге у врачей указаны языки приёма —',
			PhaSourcesCatalogLink: 'найдите врача, говорящего на вашем языке',
			PhaSourcesCatalogEnd: '.',

			PhaCtaTitle: 'Ищете конкретный препарат?',
			PhaCtaText:
				'Проверьте, зарегистрирован ли он в Черногории и как отпускается, в нашем каталоге.',
			PhaCtaButton: 'Каталог лекарств',
		},
		'sr': {
			PharmaciesTitle:
				'Apoteke i ljekovi u Crnoj Gori: recepti, analozi, šta ponijeti sa sobom',
			PharmaciesDescription:
				'Kako rade apoteke u Crnoj Gori: državni lanac Montefarm i privatni Benu i Tea Medica, dežurne apoteke, elektronski recepti i zašto strani recept neće biti prihvaćen, besplatni ljekovi sa liste Fonda i kako tražiti analoge uobičajenih preparata. Važi za jul 2026.',

			'PhaToc_pharmacies': 'Kako rade apoteke: Montefarm, privatni lanci, dežurne',
			'PhaToc_prescriptions': 'Recepti: samo crnogorski i samo elektronski',
			'PhaToc_fond-list': 'Besplatni ljekovi sa liste Fonda',
			'PhaToc_analogs': 'Analozi uobičajenih ljekova i šta ponijeti sa sobom',
			'PhaToc_sources': 'Korisni linkovi i izvori',

			PhaPharmacies1:
				'Apoteka u Crnoj Gori ima mnogo i čine dva paralelna sistema. Državni lanac je ZU „Apoteke Crne Gore Montefarm“ — oko 45 apoteka u svim opštinama. U privatnom sektoru dominiraju dva lanca: Benu (na tržištu od 2017, najrasprostranjenija mreža) i Tea Medica (najveći privatni lanac, radi od 2004), uz mnoštvo nezavisnih apoteka.',
			PhaPharmacies2:
				'Razlika je važna za osigurane: ljekovi na recept o trošku Fonda za zdravstveno osiguranje (FZOCG) tradicionalno se izdaju u apotekama Montefarma, a odnedavno i u privatnim apotekama koje su sklopile ugovor sa Fondom (spisak je objavljen na fzocg.me). Servis eApoteka na portalu eZdravlje pokazuje u kojoj od „fondovskih“ apoteka ima lijeka na zalihama. Bez osiguranja možete kupovati u bilo kojoj apoteci — po punoj cijeni.',
			PhaPharmacies3:
				'Uobičajeno radno vrijeme je otprilike od 7–8 ujutro do 21–22 sata, nedjeljom su mnoge zatvorene. U većim gradovima postoje neprekidna dežurstva: Podgorica ih ima tri — Montefarm „Kruševac“ (Bulevar Svetog Petra Cetinjskog 45/a), BENU na Moskovskoj 22 i Holos 7 na Bulevaru oktobarske revolucije 31; u Budvi je to Benu preko puta autobuske stanice; u Nikšiću Montefarm „Gojko Darić“ na Radoja Dakića bb. Za praznike Montefarm objavljuje spisak dežurnih apoteka za svaku opštinu.',
			PhaPharmacies4:
				'Granica „na recept / bez recepta“ ne prolazi tamo gdje ste možda navikli. Antibiotici u tabletama, tablete za spavanje, antidepresivi i većina „ozbiljnih“ ljekova — strogo na recept, farmaceuta nećete nagovoriti. S druge strane, analgetici (ibuprofen — ovdje najčešće Brufen — i paracetamol), mnoge masti, kapi, pa čak i, po iskustvu sa foruma, ',
			PhaPharmacies4Link: 'ampule adrenalina',
			PhaPharmacies4End:
				' prodaju se slobodno. Adrenalin je jak hitni lijek: ne treba ga sami ubrizgavati bez medicinske obuke ili indikacije koju je potvrdio ljekar (npr. dijagnostikovane teške alergije) — ako vam možda zatreba, nabavite recept i uputstvo od ljekara unaprijed. Farmaceuti obično rado pomažu da se nađe analog; na primorju mnogi govore engleski.',

			PhaPrescriptions1:
				'Glavno pravilo: strani recepti u crnogorskim apotekama ne važe — ni ruski, ni iz EU, nikakvi. Priče u četovima ponavljaju se iz godine u godinu: sa domaćim receptom u ruci lijek vam neće prodati, u najboljem slučaju će savjetovati da ga pokažete lokalnom ljekaru. Recept mora biti crnogorski.',
			PhaPrescriptions2:
				'Do njega nije teško doći. Sa zdravstvenom knjižicom recepte besplatno propisuje izabrani doktor u domu zdravlja. Bez knjižice recept će napisati bilo koji licencirani ljekar nakon plaćene konsultacije: u domu zdravlja to je oko 10–25 €, u privatnoj klinici 30–50 €. Ponesite domaći recept ili izvještaj ljekara sa aktivnom supstancom i dozom — na osnovu njih lokalni ljekar će izdati crnogorski recept. Napomena: „za godinu unaprijed“ niko neće propisati — recept obično pokriva do mjesec dana terapije, pa za produženje morate doći ponovo.',
			PhaPrescriptions3:
				'Recepti su elektronski (eRecept): ljekar unosi terapiju u sistem i apoteka je vidi po vašem broju. Papirni recept „pisan rukom“ apoteka najvjerovatnije neće prihvatiti — stvaran slučaj iz februara 2025: ljekar je djetetu napisao recept rukom jer lijeka nije bilo u elektronskom programu, i apoteka je odbila da izda lijek koji je fizički stajao u njenom frižideru dok se nije pojavio elektronski recept. Recepte privatnih klinika (sa pečatom ljekara i ustanove) pri kupovini o svom trošku obično prihvataju, ali ponekad mogu da vas pošalju po elektronski recept u dom zdravlja.',
			PhaPrescriptions4:
				'Još jedna lokalna posebnost: recept ne piše bilo koji ljekar, nego „nadležni“. Stvaran primjer: u kotorskoj bolnici ORL je pacijentu dao izvještaj sa terapijom, ali ga je po sam recept poslao kod izabranog doktora u dom zdravlja; psihotropne ljekove propisuje psihijatar ili neurolog. Ako zakazujete pregled samo radi recepta, unaprijed provjerite može li ljekar propisati baš vaš lijek.',

			PhaFond1:
				'Za osigurane u FZOCG važi „pozitivna lista“ ljekova (lista ljekova): osnovna lista — više od hiljadu ljekova koje Fond plaća u potpunosti, i doplatna — još oko 90, gdje pacijent doplaćuje razliku u cijeni. Na jedan recept izdaje se jedan lijek za najviše 30 dana liječenja.',
			PhaFond2a:
				'U praksi to znači gotovo besplatnu terapiju hroničnih bolesti. Ilustrativna priča iz četa: recept za ',
			PhaFond2SertralineLink: 'sertralin (Zoloft)',
			PhaFond2b:
				' od lokalnog psihijatra, državna apoteka — i „za 2 kutije dali smo 30 centi“. Hroničnim pacijentima dostupan je servis eNaručivanje — ponovljenu terapiju možete naručiti elektronski, bez odlaska kod ljekara svaki put.',
			PhaFond3:
				'Sve ovo dostupno je samo sa zdravstvenom knjižicom — ko ima pravo na nju i kako se dobija, detaljno objašnjavamo u članku',
			PhaFond3Link: 'o zdravstvenom sistemu Crne Gore',
			PhaFond3End: '.',

			PhaAnalogs1a:
				'Uobičajeni strani zaštićeni nazivi u Crnoj Gori se gotovo ne sreću, ali aktivne supstance su iste: tržište snabdijevaju balkanski i evropski proizvođači (Hemofarm, Krka, Alkaloid, Galenika i drugi). Zato lijek tražite ne po brendu, nego po internacionalnom nezaštićenom nazivu (INN): ne „Nurofen“, nego ',
			PhaAnalogs1IbuprofenLink: 'ibuprofen',
			PhaAnalogs1b: ' (lokalni ekvivalent je Brufen), ne „Euthyrox“, nego ',
			PhaAnalogs1LevothyroxineLink: 'levotiroksin',
			PhaAnalogs1c: '. Po aktivnoj supstanci farmaceut će naći lokalni analog.',
			PhaAnalogs2:
				'Da li je lijek registrovan u Crnoj Gori i da li se prodaje bez recepta, provjerite u našem',
			PhaAnalogs2Link: 'registru ljekova',
			PhaAnalogs2End: '.',
			PhaAnalogs3:
				'Ne nalazi se sve: tržište je malo, pojedini ljekovi u Crnoj Gori jednostavno nisu registrovani — apoteka ih neće prodati ni uz recept — a registrovani povremeno nestaju sa zaliha. U takvim slučajevima apoteke naručuju ljekove iz Srbije ili Bosne — pitajte na licu mjesta. Ljekove na recept ne kupujte „iz ruke“ preko četova: pored zakonitosti i bezbjednosti, tamo se javljaju i prevaranti koji nestaju nakon avansa. Dva pokazna primjera: ciklosporinu (u inostranstvu — kapi za oči Ikervis ili Restasis) nema lokalnog analoga — dostupne su samo obične kapi za vlaženje; valaciklovir i famciklovir takođe nisu registrovani, postoji samo aciklovir — i to u obliku tableta i kreme za ruke, mast za oči ne postoji.',
			PhaAnalogs4:
				'Ako se selite i nešto stalno uzimate, razumno je ponijeti zalihe za prve mjesece — u količinama za ličnu upotrebu i u originalnim pakovanjima — i svjež izvještaj ljekara sa INN nazivima i dozama: sa njim je dobijanje lokalnog recepta znatno lakše. Za jake analgetike i psihotropne ljekove unaprijed provjerite carinska pravila Crne Gore i zemlje tranzita — po pravilu je potrebna potvrda ljekara o terapiji. Mnogi tako i žive, povremeno donoseći ljekove „odande“ — i to je rješenje koje funkcioniše. Ali ako ne želite da zavisite od putovanja, u prvim sedmicama možete sa ljekarom pronaći lokalni analog.',

			PhaSources0:
				'Informacije važe za jul 2026. Asortiman, liste i pravila se mijenjaju — provjerite u primarnim izvorima:',
			PhaSourcesMontefarm:
				'Montefarm — državni lanac apoteka: adrese, radno vrijeme, dežurne apoteke: montefarm.co.me;',
			PhaSourcesFzo:
				'FZOCG — liste ljekova Fonda (osnovna i doplatna) i apoteke sa ugovorom sa Fondom: fzocg.me;',
			PhaSourcesEzdravlje:
				'Portal eZdravlje — eRecept (vaši recepti) i eApoteka (dostupnost ljekova u apotekama Fonda): ezdravlje.me;',
			PhaSourcesCinmed:
				'CInMED — Institut za ljekove i medicinska sredstva Crne Gore, zvanični registar odobrenih ljekova: cinmed.me;',
			PhaSourcesBenu: 'Privatni lanci — ',
			PhaSourcesBenuLink: 'Benu',
			PhaSourcesBenuMid: ' i ',
			PhaSourcesTeaMedicaLink: 'Tea Medica',
			PhaSourcesBenuEnd: ': apoteke širom zemlje.',
			PhaSourcesCatalog:
				'Treba vam ljekar koji će razumjeti vašu terapiju i napisati recept? U našem katalogu doktori imaju oznake jezika —',
			PhaSourcesCatalogLink: 'pronađite doktora koji govori vaš jezik',
			PhaSourcesCatalogEnd: '.',

			PhaCtaTitle: 'Tražite određeni lijek?',
			PhaCtaText:
				'Provjerite da li je registrovan u Crnoj Gori i kako se izdaje u našem katalogu.',
			PhaCtaButton: 'Katalog ljekova',
		},
		'sr-cyrl': {
			PharmaciesTitle:
				'Апотеке и љекови у Црној Гори: рецепти, аналози, шта понијети са собом',
			PharmaciesDescription:
				'Како раде апотеке у Црној Гори: државни ланац Montefarm и приватни Benu и Tea Medica, дежурне апотеке, електронски рецепти и зашто страни рецепт неће бити прихваћен, бесплатни љекови са листе Фонда и како тражити аналоге уобичајених препарата. Важи за јул 2026.',

			'PhaToc_pharmacies': 'Како раде апотеке: Montefarm, приватни ланци, дежурне',
			'PhaToc_prescriptions': 'Рецепти: само црногорски и само електронски',
			'PhaToc_fond-list': 'Бесплатни љекови са листе Фонда',
			'PhaToc_analogs': 'Аналози уобичајених љекова и шта понијети са собом',
			'PhaToc_sources': 'Корисни линкови и извори',

			PhaPharmacies1:
				'Апотека у Црној Гори има много и чине два паралелна система. Државни ланац је ЗУ „Apoteke Crne Gore Montefarm“ — око 45 апотека у свим општинама. У приватном сектору доминирају два ланца: Benu (на тржишту од 2017, најраспрострањенија мрежа) и Tea Medica (највећи приватни ланац, ради од 2004), уз мноштво независних апотека.',
			PhaPharmacies2:
				'Разлика је важна за осигуране: љекови на рецепт о трошку Фонда за здравствено осигурање (ФЗОЦГ) традиционално се издају у апотекама Montefarma, а однедавно и у приватним апотекама које су склопиле уговор са Фондом (списак је објављен на fzocg.me). Сервис eApoteka на порталу eZdravlje показује у којој од „фондовских“ апотека има лијека на залихама. Без осигурања можете куповати у било којој апотеци — по пуној цијени.',
			PhaPharmacies3:
				'Уобичајено радно вријеме је отприлике од 7–8 ујутро до 21–22 сата, недјељом су многе затворене. У већим градовима постоје непрекидна дежурства: Подгорица их има три — Montefarm „Крушевац“ (Булевар Светог Петра Цетињског 45/а), BENU на Московској 22 и Holos 7 на Булевару октобарске револуције 31; у Будви је то Benu преко пута аутобуске станице; у Никшићу Montefarm „Gojko Darić“ на Radoja Dakića bb. За празнике Montefarm објављује списак дежурних апотека за сваку општину.',
			PhaPharmacies4:
				'Граница „на рецепт / без рецепта“ не пролази тамо гдје сте можда навикли. Антибиотици у таблетама, таблете за спавање, антидепресиви и већина „озбиљних“ љекова — строго на рецепт, фармацеута нећете наговорити. С друге стране, аналгетици (ибупрофен — овдје најчешће Brufen — и парацетамол), многе масти, капи, па чак и, по искуству са форума, ',
			PhaPharmacies4Link: 'ампуле адреналина',
			PhaPharmacies4End:
				' продају се слободно. Адреналин је јак хитни лијек: не треба га сами убризгавати без медицинске обуке или индикације коју је потврдио љекар (нпр. дијагностиковане тешке алергије) — ако вам можда затреба, набавите рецепт и упутство од љекара унапријед. Фармацеути обично радо помажу да се нађе аналог; на приморју многи говоре енглески.',

			PhaPrescriptions1:
				'Главно правило: страни рецепти у црногорским апотекама не важе — ни руски, ни из ЕУ, никакви. Приче у четовима понављају се из године у годину: са домаћим рецептом у руци лијек вам неће продати, у најбољем случају ће савјетовати да га покажете локалном љекару. Рецепт мора бити црногорски.',
			PhaPrescriptions2:
				'До њега није тешко доћи. Са здравственом књижицом рецепте бесплатно прописује изабрани доктор у дому здравља. Без књижице рецепт ће написати било који лиценцирани љекар након плаћене консултације: у дому здравља то је око 10–25 €, у приватној клиници 30–50 €. Понесите домаћи рецепт или извјештај љекара са активном супстанцом и дозом — на основу њих локални љекар ће издати црногорски рецепт. Напомена: „за годину унапријед“ нико неће прописати — рецепт обично покрива до мјесец дана терапије, па за продужење морате доћи поново.',
			PhaPrescriptions3:
				'Рецепти су електронски (eRecept): љекар уноси терапију у систем и апотека је види по вашем броју. Папирни рецепт „писан руком“ апотека највјероватније неће прихватити — стваран случај из фебруара 2025: љекар је дјетету написао рецепт руком јер лијека није било у електронском програму, и апотека је одбила да изда лијек који је физички стајао у њеном фрижидеру док се није појавио електронски рецепт. Рецепте приватних клиника (са печатом љекара и установе) при куповини о свом трошку обично прихватају, али понекад могу да вас пошаљу по електронски рецепт у дом здравља.',
			PhaPrescriptions4:
				'Још једна локална посебност: рецепт не пише било који љекар, него „надлежни“. Стваран примјер: у которској болници ОРЛ је пацијенту дао извјештај са терапијом, али га је по сам рецепт послао код изабраног доктора у дом здравља; психотропне љекове прописује психијатар или неуролог. Ако заказујете преглед само ради рецепта, унапријед провјерите може ли љекар прописати баш ваш лијек.',

			PhaFond1:
				'За осигуране у ФЗОЦГ важи „позитивна листа“ љекова (lista ljekova): основна листа — више од хиљаду љекова које Фонд плаћа у потпуности, и доплатна — још око 90, гдје пацијент доплаћује разлику у цијени. На један рецепт издаје се један лијек за највише 30 дана лијечења.',
			PhaFond2a:
				'У пракси то значи готово бесплатну терапију хроничних болести. Илустративна прича из чета: рецепт за ',
			PhaFond2SertralineLink: 'сертралин (Zoloft)',
			PhaFond2b:
				' од локалног психијатра, државна апотека — и „за 2 кутије дали смо 30 центи“. Хроничним пацијентима доступан је сервис eNaručivanje — поновљену терапију можете наручити електронски, без одласка код љекара сваки пут.',
			PhaFond3:
				'Све ово доступно је само са здравственом књижицом — ко има право на њу и како се добија, детаљно објашњавамо у чланку',
			PhaFond3Link: 'о здравственом систему Црне Горе',
			PhaFond3End: '.',

			PhaAnalogs1a:
				'Уобичајени страни заштићени називи у Црној Гори се готово не срећу, али активне супстанце су исте: тржиште снабдијевају балкански и европски произвођачи (Hemofarm, Krka, Alkaloid, Galenika и други). Зато лијек тражите не по бренду, него по интернационалном незаштићеном називу (INN): не „Нурофен“, него ',
			PhaAnalogs1IbuprofenLink: 'ибупрофен',
			PhaAnalogs1b: ' (локални еквивалент је Brufen), не „Euthyrox“, него ',
			PhaAnalogs1LevothyroxineLink: 'левотироксин',
			PhaAnalogs1c: '. По активној супстанци фармацеут ће наћи локални аналог.',
			PhaAnalogs2:
				'Да ли је лијек регистрован у Црној Гори и да ли се продаје без рецепта, провјерите у нашем',
			PhaAnalogs2Link: 'регистру љекова',
			PhaAnalogs2End: '.',
			PhaAnalogs3:
				'Не налази се све: тржиште је мало, поједини љекови у Црној Гори једноставно нису регистровани — апотека их неће продати ни уз рецепт — а регистровани повремено нестају са залиха. У таквим случајевима апотеке наручују љекове из Србије или Босне — питајте на лицу мјеста. Љекове на рецепт не купујте „из руке“ преко четова: поред законитости и безбједности, тамо се јављају и преваранти који нестају након аванса. Два показна примјера: циклоспорину (у иностранству — капи за очи Ikervis или Restasis) нема локалног аналога — доступне су само обичне капи за влажење; валацикловир и фамцикловир такође нису регистровани, постоји само ацикловир — и то у облику таблета и креме за руке, маст за очи не постоји.',
			PhaAnalogs4:
				'Ако се селите и нешто стално узимате, разумно је понијети залихе за прве мјесеце — у количинама за личну употребу и у оригиналним паковањима — и свјеж извјештај љекара са INN називима и дозама: са њим је добијање локалног рецепта знатно лакше. За јаке аналгетике и психотропне љекове унапријед провјерите царинска правила Црне Горе и земље транзита — по правилу је потребна потврда љекара о терапији. Многи тако и живе, повремено доносећи љекове „оданде“ — и то је рјешење које функционише. Али ако не желите да зависите од путовања, у првим седмицама можете са љекаром пронаћи локални аналог.',

			PhaSources0:
				'Информације важе за јул 2026. Асортиман, листе и правила се мијењају — провјерите у примарним изворима:',
			PhaSourcesMontefarm:
				'Montefarm — државни ланац апотека: адресе, радно вријеме, дежурне апотеке: montefarm.co.me;',
			PhaSourcesFzo:
				'ФЗОЦГ — листе љекова Фонда (основна и доплатна) и апотеке са уговором са Фондом: fzocg.me;',
			PhaSourcesEzdravlje:
				'Портал eZdravlje — eRecept (ваши рецепти) и eApoteka (доступност љекова у апотекама Фонда): ezdravlje.me;',
			PhaSourcesCinmed:
				'CInMED — Институт за љекове и медицинска средства Црне Горе, званични регистар одобрених љекова: cinmed.me;',
			PhaSourcesBenu: 'Приватни ланци — ',
			PhaSourcesBenuLink: 'Benu',
			PhaSourcesBenuMid: ' и ',
			PhaSourcesTeaMedicaLink: 'Tea Medica',
			PhaSourcesBenuEnd: ': апотеке широм земље.',
			PhaSourcesCatalog:
				'Треба вам љекар који ће разумјети вашу терапију и написати рецепт? У нашем каталогу доктори имају ознаке језика —',
			PhaSourcesCatalogLink: 'пронађите доктора који говори ваш језик',
			PhaSourcesCatalogEnd: '.',

			PhaCtaTitle: 'Тражите одређени лијек?',
			PhaCtaText:
				'Провјерите да ли је регистрован у Црној Гори и како се издаје у нашем каталогу.',
			PhaCtaButton: 'Каталог љекова',
		},
		'de': {
			PharmaciesTitle:
				'Apotheken und Medikamente in Montenegro: Rezepte, Generika, was man mitnehmen sollte',
			PharmaciesDescription:
				'So funktionieren Apotheken in Montenegro: die staatliche Kette Montefarm und die privaten Benu und Tea Medica, Notdienst-Apotheken, E-Rezepte und warum ausländische Rezepte nicht akzeptiert werden, kostenlose Medikamente von der Fondsliste und wie man lokale Pendants gewohnter Präparate findet. Stand: Juli 2026.',

			'PhaToc_pharmacies': 'So funktionieren Apotheken: Montefarm, private Ketten, Notdienst',
			'PhaToc_prescriptions': 'Rezepte: nur montenegrinisch und nur elektronisch',
			'PhaToc_fond-list': 'Kostenlose Medikamente von der Fondsliste',
			'PhaToc_analogs': 'Pendants gewohnter Präparate und was man mitnehmen sollte',
			'PhaToc_sources': 'Nützliche Links und Quellen',

			PhaPharmacies1:
				'Apotheken (apoteka) gibt es in Montenegro reichlich, und sie bilden zwei parallele Systeme. Die staatliche Kette ist die ZU „Apoteke Crne Gore Montefarm“ — rund 45 Apotheken in allen Gemeinden des Landes. Im privaten Sektor dominieren zwei Ketten: Benu (seit 2017 auf dem Markt, das dichteste Netz) und Tea Medica (die größte private Kette, tätig seit 2004), dazu viele unabhängige Apotheken.',
			PhaPharmacies2:
				'Der Unterschied ist für Versicherte wichtig: Medikamente auf Rezept zulasten des Krankenversicherungsfonds (FZOCG) geben traditionell die Montefarm-Apotheken aus, seit einiger Zeit auch private Apotheken mit Fondsvertrag (die Liste steht auf fzocg.me). Der Dienst eApoteka auf dem Portal eZdravlje zeigt, in welcher der Vertragsapotheken Ihr Medikament vorrätig ist. Ohne Versicherung können Sie in jeder Apotheke kaufen — zum vollen Preis.',
			PhaPharmacies3:
				'Übliche Öffnungszeiten sind etwa 7–8 Uhr bis 21–22 Uhr, sonntags sind viele geschlossen. In größeren Städten gibt es Rund-um-die-Uhr-Standorte: Podgorica hat drei — Montefarm „Kruševac“ (Bulevar Svetog Petra Cetinjskog 45/a), BENU in der Moskovska 22 und Holos 7 im Bulevar Oktobarske Revolucije 31; in Budva ist es die Benu gegenüber dem Busbahnhof; in Nikšić die Montefarm „Gojko Darić“ in der Radoja Dakića bb. Zu Feiertagen veröffentlicht Montefarm eine Liste der Notdienst-Apotheken für jede Gemeinde.',
			PhaPharmacies4:
				'Die Grenze zwischen rezeptpflichtig und rezeptfrei verläuft anders, als Sie es vielleicht gewohnt sind. Antibiotika in Tablettenform, Schlafmittel, Antidepressiva und die meisten „ernsthaften“ Präparate gibt es strikt nur auf Rezept — Überredung hilft nicht. Dafür werden Schmerzmittel (Ibuprofen — hier meist als Brufen — und Paracetamol), viele Salben, Tropfen und laut Foren sogar ',
			PhaPharmacies4Link: 'Adrenalin-Ampullen',
			PhaPharmacies4End:
				' frei verkauft. Adrenalin ist allerdings ein starkes Notfallmedikament: Es sollte nicht ohne medizinische Schulung oder eine ärztlich bestätigte Indikation (etwa eine diagnostizierte schwere Allergie) selbst gespritzt werden — wer es eventuell braucht, sollte es sich vorab verschreiben und die Anwendung zeigen lassen. Apotheker helfen in der Regel gern bei der Suche nach einem Pendant; an der Küste sprechen viele Englisch.',

			PhaPrescriptions1:
				'Die wichtigste Regel: Ausländische Rezepte gelten in montenegrinischen Apotheken nicht — weder russische noch EU-Rezepte, keine. Die Geschichten in den Chats wiederholen sich Jahr für Jahr: Mit einem heimischen Rezept in der Hand bekommen Sie das Medikament nicht; bestenfalls rät man Ihnen, es einem lokalen Arzt zu zeigen. Das Rezept muss montenegrinisch sein.',
			PhaPrescriptions2:
				'Eines zu bekommen ist nicht schwer. Mit einer zdravstvena knjižica stellt der izabrani doktor im Dom zdravlja Rezepte kostenlos aus. Ohne Karte verschreibt jeder lizenzierte Arzt nach einer bezahlten Konsultation: im Dom zdravlja etwa 10–25 €, in einer Privatklinik 30–50 €. Nehmen Sie Ihr heimisches Rezept oder einen Arztbericht mit Wirkstoff und Dosierung mit — auf dieser Grundlage stellt der lokale Arzt ein montenegrinisches Rezept aus. Ein Hinweis: „Für ein Jahr im Voraus“ verschreibt niemand — ein Rezept deckt üblicherweise bis zu einem Monat Therapie, für die Verlängerung muss man wiederkommen.',
			PhaPrescriptions3:
				'Rezepte sind elektronisch (eRecept): Der Arzt trägt die Verordnung ins System ein, und die Apotheke sieht sie unter Ihrer Nummer. Ein handgeschriebenes Papierrezept wird die Apotheke höchstwahrscheinlich ablehnen — ein realer Fall vom Februar 2025: Ein Arzt schrieb das Rezept für ein Kind von Hand, weil das Medikament im E-System fehlte, und die Apotheke weigerte sich, das Medikament herauszugeben, das physisch in ihrem Kühlschrank lag, bis ein elektronisches Rezept vorlag. Rezepte von Privatkliniken (mit Stempel des Arztes und der Einrichtung) werden beim Kauf auf eigene Kosten meist akzeptiert, manchmal schickt man Sie aber für ein E-Rezept in den Dom zdravlja.',
			PhaPrescriptions4:
				'Noch eine lokale Eigenheit: Nicht jeder Arzt stellt das Rezept aus, sondern nur der „zuständige“. Ein reales Beispiel: Im Krankenhaus Kotor gab der HNO-Arzt dem Patienten einen Befund mit Therapie, schickte ihn für das eigentliche Rezept aber zum Hausarzt in den Dom zdravlja; Psychopharmaka verschreibt ein Psychiater oder Neurologe. Wenn Sie einen Termin nur wegen eines Rezepts buchen, klären Sie vorab, ob der Arzt genau Ihr Medikament verschreiben kann.',

			PhaFond1:
				'Für FZOCG-Versicherte gilt eine „Positivliste“ der Medikamente (lista ljekova): die Basisliste — über tausend Präparate, die der Fonds vollständig bezahlt — und die Zuzahlungsliste mit rund 90 weiteren, bei denen der Patient die Preisdifferenz zuzahlt. Pro Rezept wird ein Medikament für höchstens 30 Behandlungstage abgegeben.',
			PhaFond2a:
				'In der Praxis bedeutet das eine fast kostenlose Dauertherapie. Eine bezeichnende Geschichte aus einem Chat: Rezept für ',
			PhaFond2SertralineLink: 'Sertralin (Zoloft)',
			PhaFond2b:
				' vom lokalen Psychiater, staatliche Apotheke — und „für 2 Packungen zahlten wir 30 Cent“. Chronisch Kranken steht der Dienst eNaručivanje zur Verfügung — die Wiederholungstherapie lässt sich elektronisch bestellen, ohne jedes Mal zum Arzt zu gehen.',
			PhaFond3:
				'All das gibt es nur mit einer zdravstvena knjižica — wer Anspruch darauf hat und wie man sie bekommt, erklären wir ausführlich in unserem Artikel',
			PhaFond3Link: 'über das montenegrinische Gesundheitssystem',
			PhaFond3End: '.',

			PhaAnalogs1a:
				'Gewohnte Markennamen findet man in Montenegro kaum, die Wirkstoffe sind aber dieselben: Den Markt versorgen Balkan- und europäische Hersteller (Hemofarm, Krka, Alkaloid, Galenika und andere). Suchen Sie ein Medikament daher nicht nach der Marke, sondern nach dem internationalen Freinamen (INN) in lateinischer Schrift: nicht „Nurofen“, sondern ',
			PhaAnalogs1IbuprofenLink: 'ibuprofen',
			PhaAnalogs1b: ' (das lokale Pendant heißt Brufen), nicht „Euthyrox“, sondern ',
			PhaAnalogs1LevothyroxineLink: 'levothyroxin',
			PhaAnalogs1c: '. Anhand des Wirkstoffs findet der Apotheker das lokale Pendant.',
			PhaAnalogs2:
				'Ob ein Medikament in Montenegro zugelassen ist und ob es rezeptfrei verkauft wird, prüfen Sie in unserem',
			PhaAnalogs2Link: 'Arzneimittelregister',
			PhaAnalogs2End: '.',
			PhaAnalogs3:
				'Nicht alles ist zu finden: Der Markt ist klein, manche Präparate sind in Montenegro schlicht nicht zugelassen — die Apotheke verkauft sie auch mit Rezept nicht —, und zugelassene verschwinden gelegentlich aus dem Bestand. In solchen Fällen bestellen Apotheken Medikamente aus Serbien oder Bosnien — fragen Sie vor Ort. Kaufen Sie verschreibungspflichtige Medikamente nicht „von privat“ über Chats: Abgesehen von Legalität und Sicherheit tauchen dort auch Betrüger auf, die nach der Vorauszahlung verschwinden. Zwei anschauliche Beispiele: Für Ciclosporin (im Ausland als Ikervis oder Restasis Augentropfen) gibt es kein lokales Pendant — erhältlich sind nur einfache befeuchtende Augentropfen; Valaciclovir und Famciclovir sind ebenfalls nicht zugelassen, nur Aciclovir — und das nur als Tabletten oder Handcreme, eine Augensalbe gibt es nicht.',
			PhaAnalogs4:
				'Wenn Sie umziehen und dauerhaft etwas einnehmen, ist es vernünftig, einen Vorrat für die ersten Monate mitzunehmen — in Mengen für den Eigenbedarf und in Originalverpackungen — sowie einen aktuellen Arztbericht mit INN und Dosierungen: Damit ist das lokale Rezept deutlich leichter zu bekommen. Bei starken Schmerzmitteln und Psychopharmaka prüfen Sie vorab die Zollregeln Montenegros und des Transitlandes — in der Regel ist ein ärztlicher Verordnungsnachweis erforderlich. Manche bringen ihre Medikamente auch dauerhaft weiter „von zu Hause“ mit — das funktioniert ebenfalls. Wer aber nicht von Reisen abhängig sein möchte, kann in den ersten Wochen gemeinsam mit einem Arzt auf ein lokales Pendant umsteigen.',

			PhaSources0:
				'Stand der Informationen: Juli 2026. Sortimente, Listen und Regeln ändern sich — prüfen Sie die Primärquellen:',
			PhaSourcesMontefarm:
				'Montefarm — die staatliche Apothekenkette: Adressen, Öffnungszeiten, Notdienst-Apotheken: montefarm.co.me;',
			PhaSourcesFzo:
				'FZOCG — die Medikamentenlisten des Fonds (Basis- und Zuzahlungsliste) und Vertragsapotheken: fzocg.me;',
			PhaSourcesEzdravlje:
				'Portal eZdravlje — eRecept (Ihre Rezepte) und eApoteka (Verfügbarkeit in Fondsapotheken): ezdravlje.me;',
			PhaSourcesCinmed:
				'CInMED — das Institut für Arzneimittel und Medizinprodukte Montenegros, das offizielle Register zugelassener Präparate: cinmed.me;',
			PhaSourcesBenu: 'Private Ketten — ',
			PhaSourcesBenuLink: 'Benu',
			PhaSourcesBenuMid: ' und ',
			PhaSourcesTeaMedicaLink: 'Tea Medica',
			PhaSourcesBenuEnd: ': Apotheken im ganzen Land.',
			PhaSourcesCatalog:
				'Sie brauchen einen Arzt, der Ihre Therapie versteht und ein Rezept ausstellt? In unserem Katalog sind die Sprachen der Ärzte angegeben —',
			PhaSourcesCatalogLink: 'finden Sie einen Arzt, der Ihre Sprache spricht',
			PhaSourcesCatalogEnd: '.',

			PhaCtaTitle: 'Suchen Sie ein bestimmtes Medikament?',
			PhaCtaText:
				'Prüfen Sie in unserem Katalog, ob es in Montenegro zugelassen ist und wie es abgegeben wird.',
			PhaCtaButton: 'Medikamentenkatalog',
		},
		'tr': {
			PharmaciesTitle:
				"Karadağ'da eczaneler ve ilaçlar: reçeteler, muadiller, yanınızda ne getirmelisiniz",
			PharmaciesDescription:
				"Karadağ'da eczaneler nasıl çalışır: devlet zinciri Montefarm ile özel Benu ve Tea Medica, nöbetçi eczaneler, e-reçeteler ve yabancı reçetelerin neden kabul edilmediği, Fon listesinden ücretsiz ilaçlar ve alıştığınız ilaçların yerel muadillerini bulma yolları. Temmuz 2026 itibarıyla günceldir.",

			'PhaToc_pharmacies': 'Eczaneler nasıl çalışır: Montefarm, özel zincirler, nöbetçiler',
			'PhaToc_prescriptions': 'Reçeteler: yalnızca Karadağ reçetesi ve yalnızca elektronik',
			'PhaToc_fond-list': 'Fon listesinden ücretsiz ilaçlar',
			'PhaToc_analogs': 'Alışılmış ilaçların muadilleri ve yanınızda ne getirmelisiniz',
			'PhaToc_sources': 'Faydalı bağlantılar ve kaynaklar',

			PhaPharmacies1:
				"Karadağ'da eczane (apoteka) boldur ve iki paralel sistem hâlinde çalışırlar. Devlet zinciri ZU „Apoteke Crne Gore Montefarm“dır — ülkenin tüm belediyelerinde yaklaşık 45 eczane. Özel tarafta iki zincir öne çıkar: Benu (2017'den beri piyasada, en yaygın ağ) ve Tea Medica (en büyük özel zincir, 2004'ten beri faaliyette); ayrıca çok sayıda bağımsız eczane vardır.",
			PhaPharmacies2:
				"Fark, sigortalılar için önemlidir: Sağlık Sigortası Fonu (FZOCG) hesabına reçeteli ilaçlar geleneksel olarak Montefarm eczanelerinde verilir; bir süredir Fon ile sözleşme imzalayan özel eczanelerde de alınabilir (liste fzocg.me'de yayımlanır). eZdravlje portalındaki eApoteka servisi, ilacınızın hangi „Fon“ eczanesinde stokta olduğunu gösterir. Sigortasız herhangi bir eczaneden alışveriş yapabilirsiniz — tam fiyatla.",
			PhaPharmacies3:
				"Olağan çalışma saatleri yaklaşık sabah 7–8'den akşam 21–22'ye kadardır; pazar günleri çoğu kapalıdır. Büyük şehirlerde 24 saat açık noktalar vardır: Podgorica'da üç tane var — Montefarm „Kruševac“ (Bulevar Svetog Petra Cetinjskog 45/a), Moskovska 22'deki BENU ve Bulevar Oktobarske Revolucije 31'deki Holos 7; Budva'da otogarın karşısındaki Benu; Nikšić'te Radoja Dakića bb'deki Montefarm „Gojko Darić“. Bayramlarda Montefarm her belediye için nöbetçi eczane listesi yayımlar.",
			PhaPharmacies4:
				"Reçeteli/reçetesiz sınırı alıştığınız yerden geçmez. Tablet antibiyotikler, uyku ilaçları, antidepresanlar ve „ciddi“ ilaçların çoğu kesinlikle reçeteyle satılır — eczacıyı ikna edemezsiniz. Buna karşılık ağrı kesiciler (ibuprofen — burada çoğunlukla Brufen — ve parasetamol), birçok merhem, damla ve hatta forumlardaki deneyimlere göre ",
			PhaPharmacies4Link: 'adrenalin ampulleri',
			PhaPharmacies4End:
				" serbestçe satılır. Ancak adrenalin güçlü bir acil durum ilacıdır: tıbbi eğitim almadan veya bir doktorun onayladığı bir gerekçe (örneğin teşhis edilmiş ciddi bir alerji) olmadan kendi kendinize enjekte etmeyin — ihtiyacınız olabileceğini düşünüyorsanız önce bir doktordan reçete ve kullanım talimatı alın. Eczacılar muadil bulmaya genellikle severek yardım eder; sahil şehirlerinde birçoğu İngilizce konuşur.",

			PhaPrescriptions1:
				"Ana kural: yabancı reçeteler Karadağ eczanelerinde geçerli değildir — ne Rus, ne AB, hiçbiri. Sohbetlerdeki hikâyeler yıldan yıla tekrarlanır: elinizde ülkenizden bir reçeteyle ilacı satmazlar; en iyi ihtimalle onu yerel bir doktora göstermenizi önerirler. Reçete Karadağ reçetesi olmalıdır.",
			PhaPrescriptions2:
				"Almak zor değildir. Zdravstvena knjižica ile reçeteleri dom zdravlja'daki izabrani doktor ücretsiz yazar. Karne yoksa, ücretli bir konsültasyondan sonra herhangi bir lisanslı doktor reçete yazabilir: dom zdravlja'da yaklaşık 10–25 €, özel klinikte 30–50 €. Yanınıza ülkenizdeki reçeteyi veya etken madde ve dozu içeren doktor raporunu alın — yerel doktor bunlara dayanarak Karadağ reçetesi düzenler. Bir ayrıntı: „bir yıllık“ reçete yazılmaz — reçete genellikle bir aya kadar tedaviyi kapsar; uzatmak için yeniden gitmek gerekir.",
			PhaPrescriptions3:
				"Reçeteler elektroniktir (eRecept): doktor tedaviyi sisteme girer ve eczane numaranızla görür. El yazısı kâğıt reçeteyi eczane büyük olasılıkla kabul etmez — Şubat 2025'ten gerçek bir olay: ilaç elektronik programda olmadığı için doktor çocuğun reçetesini elle yazdı ve eczane, elektronik reçete oluşana kadar buzdolabında fiilen duran ilacı vermeyi reddetti. Özel klinik reçeteleri (doktor ve kurum kaşeli) kendi cebinizden ödemede genellikle kabul edilir, ancak bazen sizi e-reçete için dom zdravlja'ya gönderebilirler.",
			PhaPrescriptions4:
				"Bir yerel özellik daha: reçeteyi her doktor değil, „yetkili“ doktor yazar. Gerçek bir örnek: Kotor hastanesinde KBB uzmanı hastaya tedavi raporu verdi, ama asıl reçete için dom zdravlja'daki pratisyene gönderdi; psikotrop ilaçları psikiyatr veya nörolog yazar. Yalnızca reçete için randevu alıyorsanız, doktorun tam olarak sizin ilacınızı yazıp yazamayacağını önceden öğrenin.",

			PhaFond1:
				"FZOCG sigortalıları için „pozitif ilaç listesi“ (lista ljekova) geçerlidir: temel liste — Fon'un tamamını karşıladığı binden fazla ilaç — ve hastanın fiyat farkını ödediği yaklaşık 90 ilaçlık ek liste. Bir reçeteyle en fazla 30 günlük tedavi için tek ilaç verilir.",
			PhaFond2a:
				'Pratikte bu, kronik hastalıkların neredeyse ücretsiz tedavisi demektir. Sohbetten çarpıcı bir hikâye: yerel psikiyatrdan ',
			PhaFond2SertralineLink: 'sertralin (Zoloft)',
			PhaFond2b:
				' reçetesi, devlet eczanesi — ve „2 kutu için 30 sent ödedik“. Kronik hastalar eNaručivanje servisini kullanabilir — tekrarlanan tedavi, her seferinde doktora gitmeden elektronik olarak sipariş edilebilir.',
			PhaFond3:
				"Bütün bunlar yalnızca zdravstvena knjižica ile mümkündür — kimin hak sahibi olduğunu ve nasıl alınacağını şu makalede ayrıntılı anlatıyoruz:",
			PhaFond3Link: 'Karadağ sağlık sistemi hakkında',
			PhaFond3End: '.',

			PhaAnalogs1a:
				"Alışık olduğunuz ticari markalar Karadağ'da neredeyse bulunmaz, ancak etken maddeler aynıdır: piyasayı Balkan ve Avrupa üreticileri besler (Hemofarm, Krka, Alkaloid, Galenika ve diğerleri). Bu yüzden ilacı markayla değil, Latin harfleriyle yazılmış uluslararası mülkiyetsiz adıyla (INN) arayın: „Nurofen“ değil ",
			PhaAnalogs1IbuprofenLink: 'ibuprofen',
			PhaAnalogs1b: ' (yerel karşılığı Brufen), „Euthyrox“ değil ',
			PhaAnalogs1LevothyroxineLink: 'levotiroksin',
			PhaAnalogs1c: '. Etken maddeye göre eczacı yerel muadili bulur.',
			PhaAnalogs2:
				"Bir ilacın Karadağ'da ruhsatlı olup olmadığını ve reçetesiz satılıp satılmadığını",
			PhaAnalogs2Link: 'ilaç ruhsat kayıtlarımızda',
			PhaAnalogs2End: ' kontrol edebilirsiniz.',
			PhaAnalogs3:
				"Her şey bulunmaz: pazar küçüktür, bazı ilaçlar Karadağ'da hiç ruhsatlı değildir — eczane bunları reçeteyle bile satmaz — ruhsatlılar da zaman zaman stoklardan kaybolur. Böyle durumlarda eczaneler ilaçları Sırbistan veya Bosna'dan sipariş eder — yerinde sorun. Reçeteli ilaçları sohbet grupları üzerinden „elden“ satın almayın: yasallık ve güvenlik bir yana, ön ödemeden sonra ortadan kaybolan dolandırıcılar da görülür. İki somut örnek: siklosporinin (yurt dışında Ikervis veya Restasis göz damlası) yerel bir muadili yoktur — yalnızca sıradan nemlendirici göz damlaları bulunur; valasiklovir ve famsiklovir de ruhsatlı değildir, yalnızca asiklovir vardır — o da yalnızca tablet ve el kremi olarak, göz merhemi formu yoktur.",
			PhaAnalogs4:
				"Taşınıyorsanız ve düzenli ilaç kullanıyorsanız, ilk aylar için yanınıza yedek almak mantıklıdır — kişisel kullanım miktarlarında ve orijinal ambalajlarında — ayrıca INN adları ve dozları içeren güncel bir doktor raporu: onunla yerel reçete almak çok daha kolaydır. Güçlü ağrı kesiciler ve psikotrop ilaçlar için Karadağ'ın ve transit ülkenin gümrük kurallarını önceden kontrol edin — kural olarak doktorun tedavi onayı gerekir. Bazıları ilaçlarını sürekli „oradan“ getirmeye devam eder — bu da işe yarayan bir yöntemdir. Ama seyahate bağımlı olmak istemiyorsanız, ilk haftalarda doktorla birlikte yerel bir muadile geçebilirsiniz.",

			PhaSources0:
				'Bilgiler Temmuz 2026 itibarıyla günceldir. Ürün yelpazesi, listeler ve kurallar değişir — birincil kaynaklardan doğrulayın:',
			PhaSourcesMontefarm:
				'Montefarm — devlet eczane zinciri: adresler, çalışma saatleri, nöbetçi eczaneler: montefarm.co.me;',
			PhaSourcesFzo:
				'FZOCG — Fon ilaç listeleri (temel ve ek) ve Fon ile sözleşmeli eczaneler: fzocg.me;',
			PhaSourcesEzdravlje:
				'eZdravlje portalı — eRecept (reçeteleriniz) ve eApoteka (Fon eczanelerinde ilaç bulunabilirliği): ezdravlje.me;',
			PhaSourcesCinmed:
				'CInMED — Karadağ İlaç ve Tıbbi Cihaz Enstitüsü, ruhsatlı ilaçların resmî kaydı: cinmed.me;',
			PhaSourcesBenu: 'Özel zincirler — ',
			PhaSourcesBenuLink: 'Benu',
			PhaSourcesBenuMid: ' ve ',
			PhaSourcesTeaMedicaLink: 'Tea Medica',
			PhaSourcesBenuEnd: ': ülke genelinde eczaneler.',
			PhaSourcesCatalog:
				'Tedavinizi anlayacak ve reçete yazacak bir doktor mu gerekiyor? Kataloğumuzda doktorların konuştuğu diller belirtilir —',
			PhaSourcesCatalogLink: 'dilinizi konuşan bir doktor bulun',
			PhaSourcesCatalogEnd: '.',

			PhaCtaTitle: 'Belirli bir ilaç mı arıyorsunuz?',
			PhaCtaText:
				"Karadağ'da ruhsatlı olup olmadığını ve nasıl satıldığını kataloğumuzda kontrol edin.",
			PhaCtaButton: 'İlaç kataloğu',
		},
	},
};
