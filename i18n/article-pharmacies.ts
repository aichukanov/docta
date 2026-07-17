// Контент статьи «Аптеки и лекарства в Черногории: рецепты, аналоги, что взять с собой».
// Факты сверены с montefarm.co.me (гос. сеть, ~45 аптек), fzocg.me (lista ljekova:
// основная ~1046 препаратов + доплатная ~89; аптеки по договору с Фондом),
// ezdravlje.me (eRecept, eApoteka, eNaručivanje), cinmed.me (реестр препаратов),
// benu.me и данными русскоязычных чатов о реальном опыте (2023–2026).
// Актуальность: июль 2026.
export default {
	messages: {
		en: {
			PharmaciesTitle:
				'Pharmacies and medications in Montenegro: prescriptions, analogs, what to bring',
			PharmaciesDescription:
				'How pharmacies work in Montenegro: prescription and written prescription rules, what to expect with a foreign prescription, medications covered by FZOCG, and how to find registered alternatives in the local medicine register. Current as of July 2026.',

			PhaToc_pharmacies:
				'How pharmacies work: Montefarm, private chains, on-duty',
			PhaToc_prescriptions:
				'Prescriptions: local, foreign, electronic and written',
			'PhaToc_fond-list': 'Free medications from the Fund list',
			PhaToc_analogs: 'Analogs of your usual drugs and what to bring',
			PhaToc_sources: 'Useful links and sources',

			PhaPharmacies1:
				'There are plenty of pharmacies (apoteka) in Montenegro, and they form two parallel systems. The state chain is ZU “Apoteke Crne Gore Montefarm” — about 45 pharmacies covering every municipality. The private side is dominated by two chains, Benu (on the market since 2017, the most widespread network) and Tea Medica (the largest private chain, operating since 2004), plus many independent pharmacies.',
			PhaPharmacies2:
				'The difference matters if you are insured: prescriptions covered by the Health Insurance Fund (FZOCG) are traditionally filled at Montefarm pharmacies, and more recently also at private pharmacies that signed a contract with the Fund (the list is published on fzocg.me). The eApoteka service on the eZdravlje portal shows which of the Fund-contracted pharmacies have your drug in stock. Without insurance you can buy at any pharmacy — at full price.',
			PhaPharmacies3:
				'Typical opening hours are roughly 7–8 a.m. to 9–10 p.m., and many pharmacies close on Sundays. Big towns have round-the-clock spots: in Podgorica the Montefarm “Kruševac” pharmacy (Bulevar Svetog Petra Cetinjskog) works 00–24; in Budva expats consistently point to the Benu opposite the bus station — open 24 hours, holidays included. For public holidays Montefarm publishes a list of on-duty pharmacies for every municipality.',
			PhaPharmacies4:
				'The prescription/OTC line may differ from what you are used to. Many formulations of ibuprofen and paracetamol, as well as some ointments and drops, are available without prescription; the dispensing mode must still be checked for the exact product. Forums contain reports of individual pharmacies selling adrenaline ampoules without a prescription. However, ',
			PhaPharmacies4Link: 'LIDOKAIN 2% - ADRENALIN GALENIKA',
			PhaPharmacies4End:
				' is marked prescription-only in our register. Treat forum reports as individual cases, not as a rule: do not rely on a pharmacy dispensing this product without a valid prescription. Pharmacists can help identify registered products, but substitution depends on the formulation, dose and dispensing rules.',

			PhaPrescriptions1:
				'A foreign prescription does not guarantee that a medicine will be dispensed in Montenegro. Some users report that individual pharmacies accepted a foreign paper prescription, but this is not a stable or official route: the pharmacist may refuse it and require a prescription that meets Montenegrin rules. Bring the foreign prescription and a medical report as documentation, but plan to obtain a local prescription, especially for antibiotics, psychotropic and controlled medicines.',
			PhaPrescriptions2:
				'With a zdravstvena knjižica, start with your izabrani doktor at the dom zdravlja. Without one, you can book a paid consultation at a dom zdravlja or private clinic; the quoted prices are only indicative and should be confirmed when booking. Bring a report listing the diagnosis, active substance, dosage and treatment history. The local doctor must make an independent clinical assessment and may issue a prescription, change the plan or refer you to the relevant specialist. The permitted quantity and renewal period depend on the medicine and indication.',
			PhaPrescriptions3:
				'The public system normally uses eRecept: the doctor enters the prescription and a contracted pharmacy retrieves it electronically. Montenegrin rules also allow a written prescription, provided it contains the required details. Acceptance of a private-clinic or written prescription can depend on the product and whether FZOCG is paying; confirm the format with the doctor and pharmacy instead of assuming that every prescription must be electronic.',
			PhaPrescriptions4:
				'Prescribing authority depends on the medicine, indication, level of care and, for FZOCG prescriptions, any specialist-report requirements. A doctor may document a treatment recommendation but direct you to an izabrani doktor or another specialist for the actual prescription. If you book specifically to continue therapy, ask whether that clinician can prescribe the exact medicine, while remembering that the final decision follows their assessment.',

			PhaFond1:
				'For people insured with FZOCG, the current lista ljekova determines which exact products and indications are covered in full and which require a copayment. The list, prescribing restrictions and contracted pharmacies change, so check the current FZOCG entry rather than relying on a fixed number of products or a universal 30-day rule.',
			PhaFond2:
				'Coverage can make some chronic therapies inexpensive, but the copayment depends on the exact product, indication, authorization and current list. One chat participant reported paying 30 cents for two packs of sertraline; this is an individual, dated example, not a price promise. Eligible patients may use eNaručivanje for repeat therapy when their prescription and clinical plan allow it.',
			PhaFond3:
				'All of this is available only with a zdravstvena knjižica — who is entitled to one and how to get it is covered in detail in our article',
			PhaFond3Link: 'about the Montenegrin healthcare system',
			PhaFond3End: '.',

			PhaAnalogs1:
				'Search by the international nonproprietary name (INN) in Latin script, because brand names and available packs differ. The same active substance does not automatically make two products interchangeable: strength, release form, excipients and clinical context matter. A pharmacist can identify registered options and explain whether substitution is permitted; for medicines such as levothyroxine or modified-release products, confirm a switch with the prescriber.',
			PhaAnalogs2:
				'You can check whether a drug is registered in Montenegro and whether it is sold over the counter in our',
			PhaAnalogs2Link: 'register of approved medicines',
			PhaAnalogs2Mid: ', and availability and prices — in the',
			PhaAnalogs2Link2: 'medications catalog',
			PhaAnalogs2End: '.',
			PhaAnalogs3:
				'Not every medicine is registered or consistently stocked in Montenegro. Ask a pharmacy whether an authorised wholesaler can legally procure or import the product; this is not available for every medicine and should not be assumed. Do not buy prescription medicines “second-hand” through chat groups: origin, storage conditions and authenticity cannot be verified, and advance-payment scams occur.',
			PhaAnalogs4:
				'If you are relocating while on regular therapy, arrange continuity before travel. Bring only a lawful personal-use quantity in original packaging, together with a recent medical report and prescription, and verify Montenegro and transit-country customs rules in advance — especially for controlled and psychotropic medicines. Contact a local clinician early. Do not stop treatment, change the dose or switch to a “local analog” without clinical advice.',

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
			PhaSourcesBenu:
				'Private chains — Benu (benu.me) and Tea Medica: pharmacies across the country.',
			PhaSourcesCatalog:
				'Need a doctor who will sort out your therapy and issue a prescription? Our catalog shows the languages each doctor speaks —',
			PhaSourcesCatalogLink: 'find a doctor who speaks your language',
			PhaSourcesCatalogEnd: '.',

			PhaCtaTitle: 'Looking for a specific medication?',
			PhaCtaText:
				'Check the availability and prices of specific drugs in Montenegro in our catalog.',
			PhaCtaButton: 'Medications catalog',
		},
		ru: {
			PharmaciesTitle:
				'Аптеки и лекарства в Черногории: рецепты, аналоги, что взять с собой',
			PharmaciesDescription:
				'Как работают аптеки в Черногории: электронные и бумажные рецепты, чего ожидать с иностранным рецептом, лекарства за счёт FZOCG и поиск зарегистрированных замен в местном реестре. Актуально на июль 2026 года.',

			PhaToc_pharmacies:
				'Как работают аптеки: Montefarm, частные сети, дежурные',
			PhaToc_prescriptions:
				'Рецепты: местные, иностранные, электронные и бумажные',
			'PhaToc_fond-list': 'Бесплатные лекарства по списку Фонда',
			PhaToc_analogs: 'Аналоги привычных препаратов и что взять с собой',
			PhaToc_sources: 'Полезные ссылки и источники',

			PhaPharmacies1:
				'Аптек (apoteka) в Черногории много, и устроены они в две параллельные системы. Государственная сеть — ZU «Apoteke Crne Gore Montefarm»: около 45 аптек во всех муниципалитетах страны. Частный сектор — прежде всего две сети: Benu (на рынке с 2017 года, самая разветвлённая) и Tea Medica (крупнейшая частная сеть, работает с 2004 года), плюс множество независимых аптек.',
			PhaPharmacies2:
				'Разница важна для застрахованных: лекарства по рецепту за счёт Фонда медицинского страхования (FZOCG) традиционно выдают аптеки Montefarm, а с недавних пор — и частные аптеки, заключившие договор с Фондом (список опубликован на fzocg.me). Сервис eApoteka на портале eZdravlje показывает, в какой из «фондовских» аптек препарат есть в наличии. Без страховки покупать можно в любой аптеке — по полной цене.',
			PhaPharmacies3:
				'Обычный график работы — примерно с 7–8 утра до 21–22 часов, по воскресеньям многие закрыты. В крупных городах есть круглосуточные точки: в Подгорице — Montefarm «Kruševac» (бульвар Св. Петра Цетинского, 00–24), в Будве переехавшие стабильно советуют Benu напротив автовокзала — она работает 24 часа, включая праздники. На праздники Montefarm публикует список дежурных аптек по каждому муниципалитету.',
			PhaPharmacies4:
				'Граница между рецептурными и безрецептурными препаратами может отличаться от привычной. Многие формы ибупрофена и парацетамола, некоторые мази и капли продаются без рецепта, но режим нужно проверять у конкретного препарата. На форумах встречаются сообщения, что отдельным покупателям удавалось приобрести ампулы адреналина без рецепта. Однако препарат ',
			PhaPharmacies4Link: 'LIDOKAIN 2% - ADRENALIN GALENIKA',
			PhaPharmacies4End:
				' в нашем реестре отмечен как рецептурный. Считайте сообщения форумов единичным опытом, а не правилом: рассчитывать на отпуск без действительного рецепта не следует. Фармацевт поможет найти зарегистрированные варианты, но возможность замены зависит от формы, дозировки и правил отпуска.',

			PhaPrescriptions1:
				'Иностранный рецепт не гарантирует отпуск лекарства в Черногории. По сообщениям пользователей, отдельные аптеки иногда принимали иностранные бумажные рецепты, но это не стабильный и не официальный маршрут: фармацевт может отказать и потребовать рецепт, соответствующий черногорским правилам. Возьмите иностранный рецепт и медицинское заключение как документацию, но заранее предусмотрите получение местного рецепта — особенно для антибиотиков, психотропных и контролируемых препаратов.',
			PhaPrescriptions2:
				'Со здравственной книжицей начните с izabrani doktor в доме здравля. Без книжицы можно записаться на платную консультацию в доме здравля или частной клинике; указанные цены — лишь ориентиры, их нужно уточнять при записи. Возьмите заключение с диагнозом, МНН, дозировкой и историей терапии. Местный врач проводит собственную оценку и может выписать рецепт, изменить схему или направить к профильному специалисту. Допустимое количество и порядок продления зависят от препарата и показания.',
			PhaPrescriptions3:
				'В государственной системе обычно используется eRecept: врач вносит назначение, а договорная аптека получает его электронно. Черногорские правила допускают и письменный рецепт, если в нём есть обязательные сведения. Приём рецепта частной клиники или бумажного бланка может зависеть от препарата и оплаты через FZOCG; заранее уточните формат у врача и аптеки, а не исходите из того, что любой рецепт обязан быть электронным.',
			PhaPrescriptions4:
				'Полномочия по назначению зависят от препарата, показания, уровня помощи и, для рецептов за счёт FZOCG, требований к заключению специалиста. Врач может оформить рекомендацию по терапии, но направить за рецептом к izabrani doktor или другому специалисту. Если записываетесь для продолжения лечения, заранее уточните, вправе ли врач назначать конкретный препарат, помня, что окончательное решение принимается после осмотра.',

			PhaFond1:
				'Для застрахованных в FZOCG актуальная lista ljekova определяет, какие конкретные препараты и показания оплачиваются полностью, а где нужна доплата. Состав списка, ограничения назначения и договорные аптеки меняются, поэтому проверяйте текущую запись FZOCG, а не ориентируйтесь на фиксированное число препаратов или универсальное правило о 30 днях.',
			PhaFond2:
				'Покрытие может сделать отдельные виды хронической терапии недорогими, но доплата зависит от конкретного препарата, показания, разрешения и текущего списка. Один участник чата сообщал, что заплатил 30 центов за две упаковки сертралина; это частный датированный пример, а не обещание цены. eNaručivanje доступен подходящим пациентам для повторной терапии, когда это допускают рецепт и план лечения.',
			PhaFond3:
				'Всё это доступно только со здравственной книжицей — кому она положена и как её оформить, подробно разбираем в статье',
			PhaFond3Link: 'о системе здравоохранения Черногории',
			PhaFond3End: '.',

			PhaAnalogs1:
				'Ищите препарат по международному непатентованному наименованию (МНН), записанному латиницей: бренды и доступные упаковки отличаются. Одинаковое действующее вещество не делает препараты автоматически взаимозаменяемыми — важны дозировка, форма высвобождения, вспомогательные вещества и клиническая ситуация. Фармацевт поможет найти зарегистрированные варианты и объяснит допустимость замены; для левотироксина и препаратов с модифицированным высвобождением согласуйте переход с врачом.',
			PhaAnalogs2:
				'Проверить, зарегистрирован ли препарат в Черногории и продаётся ли он без рецепта, можно в нашем',
			PhaAnalogs2Link: 'реестре лекарств',
			PhaAnalogs2Mid: ', а наличие и цены — в',
			PhaAnalogs2Link2: 'каталоге лекарств',
			PhaAnalogs2End: '.',
			PhaAnalogs3:
				'Не каждый препарат зарегистрирован или постоянно доступен в Черногории. Спросите аптеку, может ли уполномоченный поставщик законно заказать или импортировать его: это возможно не для всех лекарств и не гарантируется. Не покупайте рецептурные препараты «с рук» через чаты — происхождение, условия хранения и подлинность проверить нельзя, а также встречаются мошенники с предоплатой.',
			PhaAnalogs4:
				'Если вы переезжаете на постоянной терапии, заранее организуйте её продолжение. Везите только разрешённое количество для личного использования в оригинальной упаковке, вместе со свежим заключением и рецептом; заранее проверьте таможенные правила Черногории и стран транзита, особенно для контролируемых и психотропных препаратов. В первые недели обратитесь к местному врачу. Не прекращайте лечение, не меняйте дозировку и не переходите на «местный аналог» без медицинской консультации.',

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
			PhaSourcesBenu:
				'Частные сети — Benu (benu.me) и Tea Medica: аптеки по всей стране.',
			PhaSourcesCatalog:
				'Нужен врач, который разберётся в вашей терапии и выпишет рецепт? В нашем каталоге у врачей указаны языки приёма —',
			PhaSourcesCatalogLink: 'найдите врача, говорящего на вашем языке',
			PhaSourcesCatalogEnd: '.',

			PhaCtaTitle: 'Ищете конкретный препарат?',
			PhaCtaText:
				'Проверьте наличие и цены конкретных лекарств в Черногории в нашем каталоге.',
			PhaCtaButton: 'Каталог лекарств',
		},
		sr: {
			PharmaciesTitle:
				'Apoteke i ljekovi u Crnoj Gori: recepti, analozi, šta ponijeti sa sobom',
			PharmaciesDescription:
				'Kako rade apoteke u Crnoj Gori: elektronski i pisani recepti, šta očekivati sa stranim receptom, ljekovi na teret FZOCG i pronalaženje registrovanih zamjena u lokalnom registru. Važi za jul 2026.',

			PhaToc_pharmacies:
				'Kako rade apoteke: Montefarm, privatni lanci, dežurne',
			PhaToc_prescriptions: 'Recepti: lokalni, strani, elektronski i pisani',
			'PhaToc_fond-list': 'Besplatni ljekovi sa liste Fonda',
			PhaToc_analogs: 'Analozi uobičajenih ljekova i šta ponijeti sa sobom',
			PhaToc_sources: 'Korisni linkovi i izvori',

			PhaPharmacies1:
				'Apoteka u Crnoj Gori ima mnogo i čine dva paralelna sistema. Državni lanac je ZU „Apoteke Crne Gore Montefarm“ — oko 45 apoteka u svim opštinama. U privatnom sektoru dominiraju dva lanca: Benu (na tržištu od 2017, najrasprostranjenija mreža) i Tea Medica (najveći privatni lanac, radi od 2004), uz mnoštvo nezavisnih apoteka.',
			PhaPharmacies2:
				'Razlika je važna za osigurane: ljekovi na recept o trošku Fonda za zdravstveno osiguranje (FZOCG) tradicionalno se izdaju u apotekama Montefarma, a odnedavno i u privatnim apotekama koje su sklopile ugovor sa Fondom (spisak je objavljen na fzocg.me). Servis eApoteka na portalu eZdravlje pokazuje u kojoj od „fondovskih“ apoteka ima lijeka na zalihama. Bez osiguranja možete kupovati u bilo kojoj apoteci — po punoj cijeni.',
			PhaPharmacies3:
				'Uobičajeno radno vrijeme je otprilike od 7–8 ujutro do 21–22 sata, nedjeljom su mnoge zatvorene. U većim gradovima postoje neprekidna dežurstva: u Podgorici Montefarmova apoteka „Kruševac“ (Bulevar Svetog Petra Cetinjskog) radi 00–24; u Budvi doseljenici redovno preporučuju Benu preko puta autobuske stanice — radi 24 sata, uključujući praznike. Za praznike Montefarm objavljuje spisak dežurnih apoteka za svaku opštinu.',
			PhaPharmacies4:
				'Granica između ljekova na recept i bez recepta može se razlikovati od one na koju ste navikli. Mnogi oblici ibuprofena i paracetamola, kao i neke masti i kapi, dostupni su bez recepta, ali režim treba provjeriti za konkretan proizvod. Na forumima se pojavljuju navodi da su pojedine apoteke prodavale ampule adrenalina bez recepta. Međutim, ',
			PhaPharmacies4Link: 'LIDOKAIN 2% - ADRENALIN GALENIKA',
			PhaPharmacies4End:
				' je u našem registru označen kao lijek na recept. Iskustva sa foruma tretirajte kao pojedinačne slučajeve, a ne kao pravilo: ne računajte da će apoteka izdati ovaj lijek bez važećeg recepta. Farmaceut može pomoći da se pronađu registrovane opcije, ali zamjena zavisi od oblika, doze i pravila izdavanja.',

			PhaPrescriptions1:
				'Strani recept ne garantuje da će lijek biti izdat u Crnoj Gori. Neki korisnici navode da su pojedine apoteke prihvatile strani papirni recept, ali to nije stabilan ni zvaničan put: farmaceut ga može odbiti i tražiti recept usklađen sa crnogorskim pravilima. Ponesite strani recept i medicinski izvještaj kao dokumentaciju, ali planirajte dobijanje lokalnog recepta, naročito za antibiotike, psihotropne i kontrolisane ljekove.',
			PhaPrescriptions2:
				'Sa zdravstvenom knjižicom počnite kod izabranog doktora u domu zdravlja. Bez knjižice možete zakazati plaćenu konsultaciju u domu zdravlja ili privatnoj klinici; navedene cijene su samo orijentacione i treba ih potvrditi pri zakazivanju. Ponesite izvještaj sa dijagnozom, INN nazivom, dozom i istorijom terapije. Lokalni ljekar mora napraviti sopstvenu kliničku procjenu i može izdati recept, promijeniti plan ili vas uputiti odgovarajućem specijalisti. Količina i način obnavljanja zavise od lijeka i indikacije.',
			PhaPrescriptions3:
				'U javnom sistemu se uobičajeno koristi eRecept: ljekar unosi terapiju, a ugovorna apoteka je preuzima elektronski. Crnogorska pravila dopuštaju i pisani recept ako sadrži obavezne podatke. Prihvatanje recepta privatne klinike ili papirnog obrasca može zavisiti od lijeka i plaćanja preko FZOCG; format unaprijed provjerite sa ljekarom i apotekom.',
			PhaPrescriptions4:
				'Ovlašćenje za propisivanje zavisi od lijeka, indikacije, nivoa zaštite i, kod recepata na teret FZOCG, uslova vezanih za izvještaj specijaliste. Ljekar može preporučiti terapiju, ali vas za recept uputiti izabranom doktoru ili drugom specijalisti. Ako zakazujete pregled radi nastavka terapije, provjerite da li taj ljekar može propisati konkretan lijek; konačna odluka slijedi nakon pregleda.',

			PhaFond1:
				'Za osigurane u FZOCG važeća lista ljekova određuje koji se konkretni proizvodi i indikacije plaćaju u cjelosti, a gdje postoji doplata. Lista, ograničenja propisivanja i ugovorne apoteke se mijenjaju, zato provjerite aktuelnu stavku FZOCG umjesto fiksnog broja ljekova ili univerzalnog pravila o 30 dana.',
			PhaFond2:
				'Pokriće može učiniti pojedine hronične terapije jeftinim, ali doplata zavisi od konkretnog proizvoda, indikacije, odobrenja i važeće liste. Jedan učesnik četa naveo je da je dvije kutije sertralina platio 30 centi; to je pojedinačan, datiran primjer, a ne obećanje cijene. eNaručivanje je dostupno odgovarajućim pacijentima kada to dopuštaju recept i plan liječenja.',
			PhaFond3:
				'Sve ovo dostupno je samo sa zdravstvenom knjižicom — ko ima pravo na nju i kako se dobija, detaljno objašnjavamo u članku',
			PhaFond3Link: 'o zdravstvenom sistemu Crne Gore',
			PhaFond3End: '.',

			PhaAnalogs1:
				'Lijek tražite po internacionalnom nezaštićenom nazivu (INN), jer se brendovi i dostupna pakovanja razlikuju. Ista aktivna supstanca ne znači da su proizvodi automatski zamjenjivi: važni su doza, oblik oslobađanja, pomoćne supstance i klinički kontekst. Farmaceut može pronaći registrovane opcije i objasniti da li je zamjena dozvoljena; promjenu levotiroksina i preparata sa modifikovanim oslobađanjem potvrdite sa ljekarom.',
			PhaAnalogs2:
				'Da li je lijek registrovan u Crnoj Gori i da li se prodaje bez recepta, provjerite u našem',
			PhaAnalogs2Link: 'registru ljekova',
			PhaAnalogs2Mid: ', a dostupnost i cijene — u',
			PhaAnalogs2Link2: 'katalogu ljekova',
			PhaAnalogs2End: '.',
			PhaAnalogs3:
				'Nije svaki lijek registrovan niti stalno dostupan u Crnoj Gori. Pitajte apoteku može li ga ovlašćeni dobavljač zakonito nabaviti ili uvesti; to nije moguće za svaki lijek i nije zagarantovano. Ljekove na recept ne kupujte „iz ruke“ preko četova: porijeklo, uslove čuvanja i autentičnost nije moguće provjeriti, a pojavljuju se i prevare sa avansom.',
			PhaAnalogs4:
				'Ako se selite uz stalnu terapiju, unaprijed organizujte njen nastavak. Ponesite samo dozvoljenu količinu za ličnu upotrebu u originalnom pakovanju, uz svjež izvještaj i recept, i provjerite carinska pravila Crne Gore i tranzitnih zemalja, naročito za kontrolisane i psihotropne ljekove. Rano se javite lokalnom ljekaru. Ne prekidajte terapiju, ne mijenjajte dozu i ne prelazite na „lokalni analog“ bez medicinskog savjeta.',

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
			PhaSourcesBenu:
				'Privatni lanci — Benu (benu.me) i Tea Medica: apoteke širom zemlje.',
			PhaSourcesCatalog:
				'Treba vam ljekar koji će razumjeti vašu terapiju i napisati recept? U našem katalogu doktori imaju oznake jezika —',
			PhaSourcesCatalogLink: 'pronađite doktora koji govori vaš jezik',
			PhaSourcesCatalogEnd: '.',

			PhaCtaTitle: 'Tražite određeni lijek?',
			PhaCtaText:
				'Provjerite dostupnost i cijene konkretnih ljekova u Crnoj Gori u našem katalogu.',
			PhaCtaButton: 'Katalog ljekova',
		},
		'sr-cyrl': {
			PharmaciesTitle:
				'Апотеке и љекови у Црној Гори: рецепти, аналози, шта понијети са собом',
			PharmaciesDescription:
				'Како раде апотеке у Црној Гори: електронски и писани рецепти, шта очекивати са страним рецептом, љекови на терет ФЗОЦГ и проналажење регистрованих замјена у локалном регистру. Важи за јул 2026.',

			PhaToc_pharmacies:
				'Како раде апотеке: Montefarm, приватни ланци, дежурне',
			PhaToc_prescriptions: 'Рецепти: локални, страни, електронски и писани',
			'PhaToc_fond-list': 'Бесплатни љекови са листе Фонда',
			PhaToc_analogs: 'Аналози уобичајених љекова и шта понијети са собом',
			PhaToc_sources: 'Корисни линкови и извори',

			PhaPharmacies1:
				'Апотека у Црној Гори има много и чине два паралелна система. Државни ланац је ЗУ „Apoteke Crne Gore Montefarm“ — око 45 апотека у свим општинама. У приватном сектору доминирају два ланца: Benu (на тржишту од 2017, најраспрострањенија мрежа) и Tea Medica (највећи приватни ланац, ради од 2004), уз мноштво независних апотека.',
			PhaPharmacies2:
				'Разлика је важна за осигуране: љекови на рецепт о трошку Фонда за здравствено осигурање (ФЗОЦГ) традиционално се издају у апотекама Montefarma, а однедавно и у приватним апотекама које су склопиле уговор са Фондом (списак је објављен на fzocg.me). Сервис eApoteka на порталу eZdravlje показује у којој од „фондовских“ апотека има лијека на залихама. Без осигурања можете куповати у било којој апотеци — по пуној цијени.',
			PhaPharmacies3:
				'Уобичајено радно вријеме је отприлике од 7–8 ујутро до 21–22 сата, недјељом су многе затворене. У већим градовима постоје непрекидна дежурства: у Подгорици Montefarmova апотека „Крушевац“ (Булевар Светог Петра Цетињског) ради 00–24; у Будви досељеници редовно препоручују Benu преко пута аутобуске станице — ради 24 сата, укључујући празнике. За празнике Montefarm објављује списак дежурних апотека за сваку општину.',
			PhaPharmacies4:
				'Граница између љекова на рецепт и без рецепта може се разликовати од оне на коју сте навикли. Многи облици ибупрофена и парацетамола, као и неке масти и капи, доступни су без рецепта, али режим треба провјерити за конкретан производ. На форумима се појављују наводи да су поједине апотеке продавале ампуле адреналина без рецепта. Међутим, ',
			PhaPharmacies4Link: 'LIDOKAIN 2% - ADRENALIN GALENIKA',
			PhaPharmacies4End:
				' је у нашем регистру означен као лијек на рецепт. Искуства са форума третирајте као појединачне случајеве, а не као правило: не рачунајте да ће апотека издати овај лијек без важећег рецепта. Фармацеут може помоћи да се пронађу регистроване опције, али замјена зависи од облика, дозе и правила издавања.',

			PhaPrescriptions1:
				'Страни рецепт не гарантује да ће лијек бити издат у Црној Гори. Неки корисници наводе да су поједине апотеке прихватиле страни папирни рецепт, али то није стабилан ни званичан пут: фармацеут га може одбити и тражити рецепт усклађен са црногорским правилима. Понесите страни рецепт и медицински извјештај као документацију, али планирајте добијање локалног рецепта, нарочито за антибиотике, психотропне и контролисане љекове.',
			PhaPrescriptions2:
				'Са здравственом књижицом почните код изабраног доктора у дому здравља. Без књижице можете заказати плаћену консултацију у дому здравља или приватној клиници; наведене цијене су само оријентационе и треба их потврдити при заказивању. Понесите извјештај са дијагнозом, INN називом, дозом и историјом терапије. Локални љекар мора направити сопствену клиничку процјену и може издати рецепт, промијенити план или вас упутити одговарајућем специјалисти. Количина и начин обнављања зависе од лијека и индикације.',
			PhaPrescriptions3:
				'У јавном систему се уобичајено користи eRecept: љекар уноси терапију, а уговорна апотека је преузима електронски. Црногорска правила допуштају и писани рецепт ако садржи обавезне податке. Прихватање рецепта приватне клинике или папирног обрасца може зависити од лијека и плаћања преко ФЗОЦГ; формат унапријед провјерите са љекаром и апотеком.',
			PhaPrescriptions4:
				'Овлашћење за прописивање зависи од лијека, индикације, нивоа заштите и, код рецепата на терет ФЗОЦГ, услова везаних за извјештај специјалисте. Љекар може препоручити терапију, али вас за рецепт упутити изабраном доктору или другом специјалисти. Ако заказујете преглед ради наставка терапије, провјерите да ли тај љекар може прописати конкретан лијек; коначна одлука слиједи након прегледа.',

			PhaFond1:
				'За осигуране у ФЗОЦГ важећа lista ljekova одређује који се конкретни производи и индикације плаћају у цјелости, а гдје постоји доплата. Листа, ограничења прописивања и уговорне апотеке се мијењају, зато провјерите актуелну ставку ФЗОЦГ умјесто фиксног броја љекова или универзалног правила о 30 дана.',
			PhaFond2:
				'Покриће може учинити поједине хроничне терапије јефтиним, али доплата зависи од конкретног производа, индикације, одобрења и важеће листе. Један учесник чета навео је да је двије кутије сертралина платио 30 центи; то је појединачан, датиран примјер, а не обећање цијене. eNaručivanje је доступно одговарајућим пацијентима када то допуштају рецепт и план лијечења.',
			PhaFond3:
				'Све ово доступно је само са здравственом књижицом — ко има право на њу и како се добија, детаљно објашњавамо у чланку',
			PhaFond3Link: 'о здравственом систему Црне Горе',
			PhaFond3End: '.',

			PhaAnalogs1:
				'Лијек тражите по интернационалном незаштићеном називу (INN), јер се брендови и доступна паковања разликују. Иста активна супстанца не значи да су производи аутоматски замјењиви: важни су доза, облик ослобађања, помоћне супстанце и клинички контекст. Фармацеут може пронаћи регистроване опције и објаснити да ли је замјена дозвољена; промјену левотироксина и препарата са модификованим ослобађањем потврдите са љекаром.',
			PhaAnalogs2:
				'Да ли је лијек регистрован у Црној Гори и да ли се продаје без рецепта, провјерите у нашем',
			PhaAnalogs2Link: 'регистру љекова',
			PhaAnalogs2Mid: ', а доступност и цијене — у',
			PhaAnalogs2Link2: 'каталогу љекова',
			PhaAnalogs2End: '.',
			PhaAnalogs3:
				'Није сваки лијек регистрован нити стално доступан у Црној Гори. Питајте апотеку може ли га овлашћени добављач законито набавити или увести; то није могуће за сваки лијек и није загарантовано. Љекове на рецепт не купујте „из руке“ преко четова: поријекло, услове чувања и аутентичност није могуће провјерити, а појављују се и преваре са авансом.',
			PhaAnalogs4:
				'Ако се селите уз сталну терапију, унапријед организујте њен наставак. Понесите само дозвољену количину за личну употребу у оригиналном паковању, уз свјеж извјештај и рецепт, и провјерите царинска правила Црне Горе и транзитних земаља, нарочито за контролисане и психотропне љекове. Рано се јавите локалном љекару. Не прекидајте терапију, не мијењајте дозу и не прелазите на „локални аналог“ без медицинског савјета.',

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
			PhaSourcesBenu:
				'Приватни ланци — Benu (benu.me) и Tea Medica: апотеке широм земље.',
			PhaSourcesCatalog:
				'Треба вам љекар који ће разумјети вашу терапију и написати рецепт? У нашем каталогу доктори имају ознаке језика —',
			PhaSourcesCatalogLink: 'пронађите доктора који говори ваш језик',
			PhaSourcesCatalogEnd: '.',

			PhaCtaTitle: 'Тражите одређени лијек?',
			PhaCtaText:
				'Провјерите доступност и цијене конкретних љекова у Црној Гори у нашем каталогу.',
			PhaCtaButton: 'Каталог љекова',
		},
		de: {
			PharmaciesTitle:
				'Apotheken und Medikamente in Montenegro: Rezepte, Generika, was man mitnehmen sollte',
			PharmaciesDescription:
				'So funktionieren Apotheken in Montenegro: elektronische und schriftliche Rezepte, was bei einem ausländischen Rezept zu erwarten ist, FZOCG-finanzierte Medikamente und die Suche nach zugelassenen Alternativen im lokalen Register. Stand: Juli 2026.',

			PhaToc_pharmacies:
				'So funktionieren Apotheken: Montefarm, private Ketten, Notdienst',
			PhaToc_prescriptions:
				'Rezepte: lokal, ausländisch, elektronisch und schriftlich',
			'PhaToc_fond-list': 'Kostenlose Medikamente von der Fondsliste',
			PhaToc_analogs:
				'Pendants gewohnter Präparate und was man mitnehmen sollte',
			PhaToc_sources: 'Nützliche Links und Quellen',

			PhaPharmacies1:
				'Apotheken (apoteka) gibt es in Montenegro reichlich, und sie bilden zwei parallele Systeme. Die staatliche Kette ist die ZU „Apoteke Crne Gore Montefarm“ — rund 45 Apotheken in allen Gemeinden des Landes. Im privaten Sektor dominieren zwei Ketten: Benu (seit 2017 auf dem Markt, das dichteste Netz) und Tea Medica (die größte private Kette, tätig seit 2004), dazu viele unabhängige Apotheken.',
			PhaPharmacies2:
				'Der Unterschied ist für Versicherte wichtig: Medikamente auf Rezept zulasten des Krankenversicherungsfonds (FZOCG) geben traditionell die Montefarm-Apotheken aus, seit einiger Zeit auch private Apotheken mit Fondsvertrag (die Liste steht auf fzocg.me). Der Dienst eApoteka auf dem Portal eZdravlje zeigt, in welcher der Vertragsapotheken Ihr Medikament vorrätig ist. Ohne Versicherung können Sie in jeder Apotheke kaufen — zum vollen Preis.',
			PhaPharmacies3:
				'Übliche Öffnungszeiten sind etwa 7–8 Uhr bis 21–22 Uhr, sonntags sind viele geschlossen. In größeren Städten gibt es Rund-um-die-Uhr-Standorte: In Podgorica arbeitet die Montefarm-Apotheke „Kruševac“ (Bulevar Svetog Petra Cetinjskog) von 00 bis 24 Uhr; in Budva empfehlen Zugezogene beständig die Benu gegenüber dem Busbahnhof — 24 Stunden geöffnet, auch an Feiertagen. Zu Feiertagen veröffentlicht Montefarm eine Liste der Notdienst-Apotheken für jede Gemeinde.',
			PhaPharmacies4:
				'Die Grenze zwischen rezeptpflichtig und rezeptfrei kann von dem abweichen, was Sie gewohnt sind. Viele Formen von Ibuprofen und Paracetamol sowie manche Salben und Tropfen sind rezeptfrei erhältlich; der Abgabestatus muss dennoch für das konkrete Produkt geprüft werden. In Foren wird vereinzelt berichtet, dass Apotheken Adrenalin-Ampullen ohne Rezept verkauft hätten. Das Präparat ',
			PhaPharmacies4Link: 'LIDOKAIN 2% - ADRENALIN GALENIKA',
			PhaPharmacies4End:
				' ist in unserem Register jedoch als rezeptpflichtig gekennzeichnet. Behandeln Sie Forenberichte als Einzelfälle, nicht als Regel, und verlassen Sie sich nicht auf eine Abgabe ohne gültiges Rezept. Apotheker können zugelassene Optionen nennen; ob ein Austausch zulässig ist, hängt von Form, Dosis und Abgaberegeln ab.',

			PhaPrescriptions1:
				'Ein ausländisches Rezept garantiert keine Abgabe in Montenegro. Einige Nutzer berichten, dass einzelne Apotheken ausländische Papierrezepte akzeptiert hätten; dies ist aber kein stabiler oder offizieller Weg. Der Apotheker kann das Rezept ablehnen und ein den montenegrinischen Regeln entsprechendes Rezept verlangen. Nehmen Sie Rezept und Arztbericht als Dokumentation mit, planen Sie aber besonders bei Antibiotika, Psychopharmaka und kontrollierten Arzneimitteln ein lokales Rezept ein.',
			PhaPrescriptions2:
				'Mit einer zdravstvena knjižica beginnen Sie beim izabrani doktor im Dom zdravlja. Ohne Karte können Sie eine kostenpflichtige Konsultation im Dom zdravlja oder in einer Privatklinik buchen; genannte Preise sind nur Richtwerte und sollten bei der Terminvereinbarung bestätigt werden. Bringen Sie einen Bericht mit Diagnose, Wirkstoff, Dosis und Therapieverlauf mit. Der lokale Arzt nimmt eine eigene klinische Beurteilung vor und kann ein Rezept ausstellen, den Plan ändern oder an einen passenden Spezialisten überweisen. Menge und Verlängerung hängen von Arzneimittel und Indikation ab.',
			PhaPrescriptions3:
				'Im öffentlichen System wird üblicherweise eRecept genutzt: Der Arzt trägt die Verordnung ein, eine Vertragsapotheke ruft sie elektronisch ab. Die montenegrinischen Regeln erlauben auch ein schriftliches Rezept, sofern es die Pflichtangaben enthält. Ob ein Rezept einer Privatklinik oder ein Papierformular akzeptiert wird, kann vom Produkt und der Finanzierung durch FZOCG abhängen; klären Sie das Format vorab mit Arzt und Apotheke.',
			PhaPrescriptions4:
				'Die Verschreibungsbefugnis hängt von Arzneimittel, Indikation, Versorgungsebene und bei FZOCG-Rezepten von möglichen Facharztanforderungen ab. Ein Arzt kann eine Therapie empfehlen, Sie für das Rezept aber zum izabrani doktor oder zu einem anderen Spezialisten schicken. Fragen Sie bei einem Termin zur Fortsetzung einer Therapie vorab nach der Zuständigkeit; die endgültige Entscheidung erfolgt nach der Untersuchung.',

			PhaFond1:
				'Für FZOCG-Versicherte bestimmt die aktuelle lista ljekova, welche konkreten Produkte und Indikationen vollständig bezahlt werden und wo eine Zuzahlung anfällt. Liste, Verschreibungsbeschränkungen und Vertragsapotheken ändern sich; prüfen Sie deshalb den aktuellen FZOCG-Eintrag statt fester Produktzahlen oder einer pauschalen 30-Tage-Regel.',
			PhaFond2:
				'Die Kostenübernahme kann einzelne Dauertherapien günstig machen; die Zuzahlung hängt aber von Produkt, Indikation, Genehmigung und aktueller Liste ab. Ein Chatteilnehmer berichtete von 30 Cent für zwei Packungen Sertralin; das ist ein datiertes Einzelbeispiel, keine Preiszusage. eNaručivanje steht geeigneten Patienten zur Verfügung, wenn Rezept und Behandlungsplan es erlauben.',
			PhaFond3:
				'All das gibt es nur mit einer zdravstvena knjižica — wer Anspruch darauf hat und wie man sie bekommt, erklären wir ausführlich in unserem Artikel',
			PhaFond3Link: 'über das montenegrinische Gesundheitssystem',
			PhaFond3End: '.',

			PhaAnalogs1:
				'Suchen Sie nach dem internationalen Freinamen (INN), da Marken und verfügbare Packungen abweichen. Derselbe Wirkstoff macht Produkte nicht automatisch austauschbar: Dosis, Freisetzungsform, Hilfsstoffe und klinischer Kontext zählen. Ein Apotheker kann zugelassene Optionen nennen und erklären, ob ein Austausch zulässig ist; Änderungen bei Levothyroxin oder Präparaten mit veränderter Wirkstofffreisetzung sollten mit dem Arzt abgestimmt werden.',
			PhaAnalogs2:
				'Ob ein Medikament in Montenegro zugelassen ist und ob es rezeptfrei verkauft wird, prüfen Sie in unserem',
			PhaAnalogs2Link: 'Arzneimittelregister',
			PhaAnalogs2Mid: ', Verfügbarkeit und Preise — im',
			PhaAnalogs2Link2: 'Medikamentenkatalog',
			PhaAnalogs2End: '.',
			PhaAnalogs3:
				'Nicht jedes Arzneimittel ist in Montenegro zugelassen oder dauerhaft verfügbar. Fragen Sie die Apotheke, ob ein autorisierter Anbieter es rechtmäßig beschaffen oder importieren kann; dies ist nicht für jedes Mittel möglich und nicht garantiert. Kaufen Sie verschreibungspflichtige Medikamente nicht privat über Chats: Herkunft, Lagerung und Echtheit sind nicht überprüfbar, zudem gibt es Vorkassebetrug.',
			PhaAnalogs4:
				'Organisieren Sie bei einem Umzug die Fortsetzung Ihrer Dauertherapie vor der Reise. Nehmen Sie nur eine zulässige Menge für den Eigenbedarf in Originalverpackung sowie aktuellen Arztbericht und Rezept mit; prüfen Sie vorab die Zollregeln Montenegros und der Transitländer, besonders bei kontrollierten und psychotropen Arzneimitteln. Suchen Sie früh einen lokalen Arzt auf. Beenden oder ändern Sie die Therapie und die Dosis nicht ohne medizinischen Rat.',

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
			PhaSourcesBenu:
				'Private Ketten — Benu (benu.me) und Tea Medica: Apotheken im ganzen Land.',
			PhaSourcesCatalog:
				'Sie brauchen einen Arzt, der Ihre Therapie versteht und ein Rezept ausstellt? In unserem Katalog sind die Sprachen der Ärzte angegeben —',
			PhaSourcesCatalogLink: 'finden Sie einen Arzt, der Ihre Sprache spricht',
			PhaSourcesCatalogEnd: '.',

			PhaCtaTitle: 'Suchen Sie ein bestimmtes Medikament?',
			PhaCtaText:
				'Prüfen Sie Verfügbarkeit und Preise konkreter Medikamente in Montenegro in unserem Katalog.',
			PhaCtaButton: 'Medikamentenkatalog',
		},
		tr: {
			PharmaciesTitle:
				"Karadağ'da eczaneler ve ilaçlar: reçeteler, muadiller, yanınızda ne getirmelisiniz",
			PharmaciesDescription:
				"Karadağ'da eczaneler nasıl çalışır: elektronik ve yazılı reçeteler, yabancı reçeteyle ne beklenmeli, FZOCG kapsamındaki ilaçlar ve yerel kayıt sisteminde ruhsatlı alternatifleri bulma. Temmuz 2026 itibarıyla günceldir.",

			PhaToc_pharmacies:
				'Eczaneler nasıl çalışır: Montefarm, özel zincirler, nöbetçiler',
			PhaToc_prescriptions: 'Reçeteler: yerel, yabancı, elektronik ve yazılı',
			'PhaToc_fond-list': 'Fon listesinden ücretsiz ilaçlar',
			PhaToc_analogs:
				'Alışılmış ilaçların muadilleri ve yanınızda ne getirmelisiniz',
			PhaToc_sources: 'Faydalı bağlantılar ve kaynaklar',

			PhaPharmacies1:
				"Karadağ'da eczane (apoteka) boldur ve iki paralel sistem hâlinde çalışırlar. Devlet zinciri ZU „Apoteke Crne Gore Montefarm“dır — ülkenin tüm belediyelerinde yaklaşık 45 eczane. Özel tarafta iki zincir öne çıkar: Benu (2017'den beri piyasada, en yaygın ağ) ve Tea Medica (en büyük özel zincir, 2004'ten beri faaliyette); ayrıca çok sayıda bağımsız eczane vardır.",
			PhaPharmacies2:
				"Fark, sigortalılar için önemlidir: Sağlık Sigortası Fonu (FZOCG) hesabına reçeteli ilaçlar geleneksel olarak Montefarm eczanelerinde verilir; bir süredir Fon ile sözleşme imzalayan özel eczanelerde de alınabilir (liste fzocg.me'de yayımlanır). eZdravlje portalındaki eApoteka servisi, ilacınızın hangi „Fon“ eczanesinde stokta olduğunu gösterir. Sigortasız herhangi bir eczaneden alışveriş yapabilirsiniz — tam fiyatla.",
			PhaPharmacies3:
				"Olağan çalışma saatleri yaklaşık sabah 7–8'den akşam 21–22'ye kadardır; pazar günleri çoğu kapalıdır. Büyük şehirlerde 24 saat açık noktalar vardır: Podgorica'da Montefarm „Kruševac“ eczanesi (Bulevar Svetog Petra Cetinjskog) 00–24 çalışır; Budva'da yeni taşınanlar sürekli olarak otogarın karşısındaki Benu'yu önerir — tatiller dâhil 24 saat açıktır. Bayramlarda Montefarm her belediye için nöbetçi eczane listesi yayımlar.",
			PhaPharmacies4:
				'Reçeteli ve reçetesiz ilaç sınırı alıştığınızdan farklı olabilir. İbuprofen ve parasetamolün birçok formu ile bazı merhem ve damlalar reçetesizdir; yine de satış şekli belirli ürün için kontrol edilmelidir. Forumlarda bazı eczanelerin adrenalin ampullerini reçetesiz sattığına dair bireysel anlatımlar vardır. Ancak ',
			PhaPharmacies4Link: 'LIDOKAIN 2% - ADRENALIN GALENIKA',
			PhaPharmacies4End:
				' kendi kayıt sistemimizde reçeteli olarak işaretlidir. Forum anlatımlarını kural değil, bireysel vaka sayın ve geçerli reçete olmadan verileceğine güvenmeyin. Eczacı ruhsatlı seçenekleri bulmaya yardımcı olabilir; ikame, form, doz ve satış kurallarına bağlıdır.',

			PhaPrescriptions1:
				"Yabancı reçete, ilacın Karadağ'da verileceğini garanti etmez. Bazı kullanıcılar kimi eczanelerin yabancı kâğıt reçeteyi kabul ettiğini bildirir; ancak bu istikrarlı veya resmî bir yol değildir. Eczacı reçeteyi reddedip Karadağ kurallarına uygun reçete isteyebilir. Yabancı reçeteyi ve doktor raporunu belge olarak getirin, fakat özellikle antibiyotik, psikotrop ve kontrollü ilaçlar için yerel reçete almayı planlayın.",
			PhaPrescriptions2:
				"Zdravstvena knjižica varsa dom zdravlja'daki izabrani doktor ile başlayın. Yoksa dom zdravlja veya özel klinikte ücretli muayene randevusu alın; belirtilen fiyatlar yalnızca yaklaşık olup randevu sırasında doğrulanmalıdır. Tanı, etken madde, doz ve tedavi geçmişini içeren raporu getirin. Yerel doktor kendi klinik değerlendirmesini yapar; reçete yazabilir, planı değiştirebilir veya ilgili uzmana yönlendirebilir. Miktar ve yenileme şekli ilaca ve endikasyona bağlıdır.",
			PhaPrescriptions3:
				'Kamu sisteminde genellikle eRecept kullanılır: doktor reçeteyi sisteme girer, sözleşmeli eczane elektronik olarak görür. Karadağ kuralları gerekli bilgileri içeren yazılı reçeteye de izin verir. Özel klinik veya kâğıt reçetenin kabulü ürüne ve FZOCG ödemesine bağlı olabilir; formatı doktor ve eczaneyle önceden doğrulayın.',
			PhaPrescriptions4:
				'Reçete yetkisi ilaca, endikasyona, bakım düzeyine ve FZOCG reçetelerinde uzman raporu koşullarına bağlıdır. Bir doktor tedavi önerip reçete için sizi izabrani doktor veya başka bir uzmana yönlendirebilir. Tedaviyi sürdürmek için randevu alırken hekimin ilgili ilacı yazıp yazamayacağını sorun; son karar muayene sonrasında verilir.',

			PhaFond1:
				'FZOCG sigortalıları için güncel lista ljekova, hangi ürün ve endikasyonların tamamen karşılandığını ve nerede katkı payı gerektiğini belirler. Liste, reçete kısıtları ve sözleşmeli eczaneler değişir; sabit ilaç sayıları veya genel bir 30 gün kuralı yerine güncel FZOCG kaydını kontrol edin.',
			PhaFond2:
				'Karşılama bazı kronik tedavileri ucuzlatabilir; ancak katkı payı ürün, endikasyon, onay ve güncel listeye bağlıdır. Bir sohbet katılımcısı iki kutu sertralin için 30 sent ödediğini bildirmiştir; bu tarihli bireysel bir örnektir, fiyat vaadi değildir. eNaručivanje, reçete ve tedavi planı izin verdiğinde uygun hastalara açıktır.',
			PhaFond3:
				'Bütün bunlar yalnızca zdravstvena knjižica ile mümkündür — kimin hak sahibi olduğunu ve nasıl alınacağını şu makalede ayrıntılı anlatıyoruz:',
			PhaFond3Link: 'Karadağ sağlık sistemi hakkında',
			PhaFond3End: '.',

			PhaAnalogs1:
				'İlacı marka yerine uluslararası mülkiyetsiz adıyla (INN) arayın; markalar ve ambalajlar farklıdır. Aynı etken madde ürünleri otomatik olarak değiştirilebilir yapmaz: doz, salım biçimi, yardımcı maddeler ve klinik durum önemlidir. Eczacı ruhsatlı seçenekleri ve ikamenin izinli olup olmadığını açıklayabilir; levotiroksin ve değiştirilmiş salımlı ürünlerde değişikliği doktorla doğrulayın.',
			PhaAnalogs2:
				"Bir ilacın Karadağ'da ruhsatlı olup olmadığını ve reçetesiz satılıp satılmadığını",
			PhaAnalogs2Link: 'ilaç ruhsat kayıtlarımızda',
			PhaAnalogs2Mid: ', bulunabilirlik ve fiyatları ise',
			PhaAnalogs2Link2: 'ilaç kataloğumuzda',
			PhaAnalogs2End: ' kontrol edebilirsiniz.',
			PhaAnalogs3:
				"Her ilaç Karadağ'da ruhsatlı veya sürekli stokta değildir. Yetkili bir tedarikçinin ürünü yasal olarak temin ya da ithal edip edemeyeceğini eczaneye sorun; bu her ilaç için mümkün veya garantili değildir. Reçeteli ilaçları sohbet gruplarından elden almayın: kaynağı, saklama koşulları ve gerçekliği doğrulanamaz, ayrıca ön ödeme dolandırıcılığı görülür.",
			PhaAnalogs4:
				'Düzenli tedaviyle taşınıyorsanız devamını seyahatten önce planlayın. Yalnızca kişisel kullanım için izin verilen miktarı orijinal ambalajında, güncel doktor raporu ve reçeteyle getirin; özellikle kontrollü ve psikotrop ilaçlar için Karadağ ve transit ülkelerin gümrük kurallarını önceden kontrol edin. Yerel doktora erken başvurun. Tıbbi görüş olmadan tedaviyi kesmeyin, dozu değiştirmeyin veya yerel muadile geçmeyin.',

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
			PhaSourcesBenu:
				'Özel zincirler — Benu (benu.me) ve Tea Medica: ülke genelinde eczaneler.',
			PhaSourcesCatalog:
				'Tedavinizi anlayacak ve reçete yazacak bir doktor mu gerekiyor? Kataloğumuzda doktorların konuştuğu diller belirtilir —',
			PhaSourcesCatalogLink: 'dilinizi konuşan bir doktor bulun',
			PhaSourcesCatalogEnd: '.',

			PhaCtaTitle: 'Belirli bir ilaç mı arıyorsunuz?',
			PhaCtaText:
				"Belirli ilaçların Karadağ'daki bulunabilirliğini ve fiyatlarını kataloğumuzda kontrol edin.",
			PhaCtaButton: 'İlaç kataloğu',
		},
	},
};
