// Контент статьи «Чем заменить Зиртек в Черногории». Справочный YMYL-обзор
// НАЛИЧИЯ, а не рекомендация по замене: конкретное вещество и дозировку
// подбирает врач или фармацевт.
//
// Факты сверены по реестру (med_medicines / med_substances, только is_active=1)
// и продублированы проверкой фасетов на проде 2026-08-31:
//   цетиризин и левоцетиризин — в med_substances ОТСУТСТВУЮТ (проверка на
//     живом cinmed.me 2026-08-28: по МНН, по брендам и по ATC R06AE — 0);
//   без рецепта: лоратадин 498 (PRESSING табл. 10 мг + сироп 5 мг/5 мл),
//     фексофенадин 259 (ALLEGRA, ALERIX 120 мг), азеластин 70 (ALLERGODIL
//     спрей), диметинден 190 (FLENTY гель), хлоропирамин 357 (SYNOPEN мазь);
//   по рецепту: дезлоратадин 178 (AERIUS 5 мг и раствор 0,5 мг/мл, LORDES,
//     AEROGAL, ALERIZON), биластин 94 (ALERGOFEN 20 мг), кетотифен 431
//     (GALITIFEN сироп), мометазон 558 (NASONEX), азеластин+флутиказон
//     (DYMISTA, FLUFETAN), олопатадин 617 (KYARA капли), монтелукаст 559
//     (SINGULAIR, ALVOKAST), хлоропирамин в инъекциях (SYNOPEN 20mg/2ml).
// Нет в реестре: клемастин (Тавегил), мебгидролин (Диазолин), гидроксизин
//   (Атаракс), кромоглициевая кислота, автоинъектор адреналина (адреналин
//   встречается только в стоматологических анестетиках). AVAMYS (флутиказона
//   фуроат) в реестре есть, но is_active=0 — «без действующей лицензии»,
//   ссылкой не выносится.
// Осторожно с глазными каплями: PROCULIN/HEMOKULIN (нафазолин) и VISET
//   (тетризолин) безрецептурные, но это СОСУДОСУЖИВАЮЩИЕ, не антигистаминные;
//   единственные антигистаминные капли — рецептурная KYARA.
// DRAMINA/DIMIGAL/RODAVAN N (дименгидринат) попадают в фасет «Аллергия» по
//   ATC R06, но продаются от укачивания — оговорено в тексте.
// Практика «вожу из Сербии» — опыт русскоязычных сообществ ЧГ (2023–2026,
//   data/chat-exports, чат medicina_montenegro). Боснию не упоминаем: в чатах
//   она встречается, но по реестру ALMBIH не проверялась.
//
// ПРАВИЛО ССЫЛОК (важно при правках): текст ссылки должен однозначно указывать
//   на ОДНУ карточку. Если у бренда в реестре несколько карточек (PRESSING —
//   таблетки и сироп, AERIUS — таблетки и раствор, SYNOPEN — мазь и инъекции),
//   ссылка ставится на форму («таблетки 10 мг») или включает её («SYNOPEN,
//   мазь 10 мг/г»), а не на голое название бренда — иначе одна из форм молча
//   остаётся без ссылки. У монтелукаста карточек четыре, поэтому там ссылка
//   только на фасет вещества, брендовых ссылок нет.
//
// ФОРМУЛИРОВКИ: везде явно сказано, где вещество, а где бренд («лоратадин —
//   действующее вещество Кларитина»), иначе читатель не понимает, какое из двух
//   названий спрашивать в аптеке.
// ИМЕНА БРЕНДОВ в ru: при первом упоминании зарубежного бренда даём обе формы —
//   «Ксизал / Xyzal» в перечислении, «Кларитина (Claritin)» в косвенном падеже
//   (конвенция из article-medications-unavailable); дальше по тексту только
//   русская форма, а если рядом уже стоит латинское название местного препарата
//   того же бренда (AERIUS, ALLERGODIL, NASONEX, SINGULAIR) — вторую форму не
//   дублируем. Названия препаратов из реестра ЧГ не переводим вообще.
// Актуальность: август 2026.
export default {
	messages: {
		'en': {
			AlgTitle:
				'Allergy medicines in Montenegro: what to take instead of Zyrtec',
			AlgDescription:
				'Cetirizine (Zyrtec, Zodak) is not registered in Montenegro. Which antihistamines are sold here with or without a prescription, and how to match yours by ingredient.',

			AlgToc_zyrtec: 'Cetirizine is not registered here',
			AlgToc_otc: 'What you can buy over the counter',
			AlgToc_rx: 'What needs a prescription',
			AlgToc_brands: 'Your brand, the local ingredient',
			AlgToc_kids: 'For children: syrup instead of drops',
			AlgToc_bring: 'What to bring, and what to buy in Serbia',
			AlgToc_recipe: 'How to get a local prescription',
			AlgToc_sources: 'Caveats and sources',

			AlgZyrtec1:
				'Zyrtec, Zodak, Cetrin and Allertec are different brands of one active ingredient: cetirizine. Not a single medicine containing it is registered in Montenegro — cetirizine is absent from the CInMED register. So there is no point walking from pharmacy to pharmacy: this is not about one shop or a supply gap.',
			AlgZyrtec2:
				'The same goes for levocetirizine (Xyzal, Suprastinex): it is not in the register either. Montenegro’s Russian-speaking communities have been giving the same answer for years — cetirizine gets brought in from Serbia.',
			AlgZyrtec3:
				'The reason is the formulary rather than a shortage. Montenegro follows the European and Balkan range, where the second-generation H1 blockers on the shelf are loratadine, desloratadine, fexofenadine and bilastine. They belong to the same class as cetirizine, but they are different substances — which one suits you is a decision for a doctor or a pharmacist, not for a lookup table.',

			AlgOtc1: 'Montenegrin pharmacies sell these without a prescription:',
			AlgOtcLoratadineSubstance: 'Loratadine',
			AlgOtcLoratadineMid:
				' — the active ingredient of Claritin. Pharmacies here sell it under the name PRESSING: ',
			AlgOtcLoratadineTablets: '10 mg tablets',
			AlgOtcLoratadineOr: ' or a ',
			AlgOtcLoratadineSyrup: '5 mg/5 ml syrup',
			AlgOtcLoratadineEnd: '.',
			AlgOtcFexofenadineSubstance: 'Fexofenadine',
			AlgOtcFexofenadineMid1:
				' — the active ingredient of Allegra and Telfast. Here the brand names are familiar too: ',
			AlgOtcFexofenadineBrand1: 'ALLEGRA',
			AlgOtcFexofenadineMid2: ' and ',
			AlgOtcFexofenadineBrand2: 'ALERIX',
			AlgOtcFexofenadineEnd: ', 120 mg tablets.',
			AlgOtcAzelastineSubstance: 'Azelastine',
			AlgOtcAzelastineMid:
				' — the active ingredient of the Allergodil nasal spray. The local brand name is the same: ',
			AlgOtcAzelastineBrand: 'ALLERGODIL',
			AlgOtcAzelastineEnd: '.',
			AlgOtcDimetindeneSubstance: 'Dimetindene',
			AlgOtcDimetindeneMid:
				' — the active ingredient of Fenistil. Here it exists only as a gel, sold as ',
			AlgOtcDimetindeneBrand: 'FLENTY',
			AlgOtcDimetindeneEnd: '. There are no oral drops with it.',
			AlgOtcChloropyramineSubstance: 'Chloropyramine',
			AlgOtcChloropyramineMid:
				' — the active ingredient of Suprastin. Over the counter it comes as ',
			AlgOtcChloropyramineBrand: 'SYNOPEN ointment, 10 mg/g',
			AlgOtcChloropyramineEnd:
				'. There are no tablets, and the injections need a prescription.',
			AlgOtc2:
				'Eye drops are the weak spot. PROCULIN, HEMOKULIN and VISET are sold freely, but they are decongestants (naphazoline and tetryzoline): they take the redness away without touching the allergic reaction itself. The only true antihistamine eye drops in the register are prescription-only.',
			AlgOtc3:
				'In the catalog’s Allergy category you will also come across DRAMINA, DIMIGAL and RODAVAN N. Their ingredient, dimenhydrinate, really is a first-generation H1 blocker, but here it is sold for motion sickness, not for allergy.',

			AlgRx1:
				'Everything else needs a prescription — including medicines that sit on the open shelf in other countries:',
			AlgRxDesloratadineSubstance: 'Desloratadine',
			AlgRxDesloratadineMid:
				' — the active ingredient of Aerius and Clarinex; the local brand is spelled AERIUS and comes as ',
			AlgRxDesloratadineTablets: '5 mg tablets',
			AlgRxDesloratadineAnd: ' and a ',
			AlgRxDesloratadineSolution: '0.5 mg/ml oral solution',
			AlgRxDesloratadineEnd:
				', plus the generics LORDES, AEROGAL and ALERIZON.',
			AlgRxBilastineSubstance: 'Bilastine',
			AlgRxBilastineMid:
				' — the same active ingredient as in Bilaxten and Clatra. The local brand name is ',
			AlgRxBilastineBrand: 'ALERGOFEN',
			AlgRxBilastineEnd: ', 20 mg tablets.',
			AlgRxKetotifenSubstance: 'Ketotifen',
			AlgRxKetotifenMid:
				' — the active ingredient of Zaditen. Here it exists only as the syrup ',
			AlgRxKetotifenBrand: 'GALITIFEN',
			AlgRxKetotifenEnd:
				'. No ketotifen tablets or eye drops are registered here.',
			AlgRxMometasoneSubstance: 'Mometasone',
			AlgRxMometasoneMid:
				' — the steroid nasal spray known elsewhere as Nasonex; the local product is ',
			AlgRxMometasoneBrand: 'NASONEX',
			AlgRxMometasoneMid2:
				'. There is also an azelastine-and-fluticasone combination: the sprays ',
			AlgRxMometasoneBrand2: 'DYMISTA',
			AlgRxMometasoneMid3: ' and ',
			AlgRxMometasoneBrand3: 'FLUFETAN',
			AlgRxMometasoneEnd:
				'. Avamys (fluticasone furoate) is in the register but has no valid licence.',
			AlgRxOlopatadineSubstance: 'Olopatadine',
			AlgRxOlopatadineMid:
				' — the only antihistamine eye drops in the register, sold as ',
			AlgRxOlopatadineBrand: 'KYARA',
			AlgRxOlopatadineEnd:
				'; the same active ingredient as in Patanol and Opatanol.',
			AlgRxMontelukastSubstance: 'Montelukast',
			AlgRxMontelukastEnd:
				' — not an antihistamine but a leukotriene blocker, used for asthma and severe allergic rhinitis. Locally the brands are SINGULAIR and ALVOKAST, in tablets and chewable tablets.',
			AlgRxChloropyramineA: 'Chloropyramine also comes as injections — ',
			AlgRxChloropyramineBrand: 'SYNOPEN 20 mg/2 ml',
			AlgRxChloropyramineEnd:
				'. That is something for a doctor or an ambulance crew, not for a home kit.',
			AlgRx2:
				'Severe reactions are handled with steroids in tablets and injections, and a doctor decides on those. There is a local quirk worth knowing: systemic prednisolone tablets are not in the register at all (prednisolone appears only in local forms — suppositories, eye drops), while the systemic steroids that do come as tablets are prednisone (NIZON, PRONISON), methylprednisolone (MEDROL) and dexamethasone. If you are continuing a treatment started at home, the local name will almost certainly be a different one. The adrenaline auto-injector people carry for anaphylaxis is a separate story, see below.',

			AlgBrands1:
				'A short cross-check: the brand you know, its active ingredient in brackets, and where that ingredient stands in Montenegro.',
			AlgBrandsCetirizine:
				'Zyrtec, Zodak, Cetrin, Allertec (cetirizine) — not in the register.',
			AlgBrandsLevocetirizine:
				'Xyzal, Suprastinex (levocetirizine) — not in the register.',
			AlgBrandsLoratadine:
				'Claritin, Lorano, Lomilan (loratadine) — available as PRESSING, tablets and syrup, over the counter.',
			AlgBrandsDesloratadine:
				'Clarinex, Aerius, Dezal (desloratadine) — available as AERIUS, LORDES, AEROGAL and ALERIZON, on prescription.',
			AlgBrandsFexofenadine:
				'Allegra, Telfast (fexofenadine) — available as ALLEGRA and ALERIX, over the counter.',
			AlgBrandsBilastine:
				'Bilaxten, Clatra, Nixar (bilastine) — available as ALERGOFEN, on prescription.',
			AlgBrandsChloropyramine:
				'Suprastin (chloropyramine) — available, but not as tablets: SYNOPEN ointment over the counter, SYNOPEN injections on prescription.',
			AlgBrandsDimetindene:
				'Fenistil (dimetindene) — only the FLENTY gel; no oral drops.',
			AlgBrandsKetotifen:
				'Zaditen (ketotifen) — only the GALITIFEN syrup, on prescription.',
			AlgBrandsOld:
				'Tavegil (clemastine), Diazolin (mebhydrolin), Atarax (hydroxyzine) — these substances are not in the register at all.',
			AlgBrandsAzelastine:
				'Allergodil (azelastine) — the ALLERGODIL nasal spray is over the counter; there are no azelastine eye drops here.',
			AlgBrandsNasal:
				'Nasonex (mometasone) — available as NASONEX, on prescription; Avamys (fluticasone furoate) has no valid licence, and we found no cromoglicic acid in the register.',
			AlgBrandsEye:
				'Patanol and Opatanol (olopatadine) — available as KYARA, on prescription; Singulair (montelukast) — SINGULAIR and ALVOKAST, on prescription.',
			AlgBrands2a:
				'At the counter it is easier to name the active ingredient than the brand: with it, a pharmacist will find whatever is registered in the country. You can check a specific ingredient and how it is dispensed in our ',
			AlgBrands2Link: 'medicine catalog',
			AlgBrands2End: '.',

			AlgKids1:
				'The oral drops parents are used to — cetirizine or Fenistil drops — do not exist here. Syrups and solutions take their place: the loratadine syrup (PRESSING) is over the counter, while the desloratadine 0.5 mg/ml solution (AERIUS, ALERIZON) and the ketotifen syrup (GALITIFEN) need a prescription.',
			AlgKids2:
				'A child’s dose depends on weight and age, so it is a conversation with a doctor or pharmacist: the catalog shows the form and the strength of a medicine, never a paediatric dose.',
			AlgKids3a: 'If a child’s allergy is more than a one-off, a ',
			AlgKids3Link: 'paediatric allergist',
			AlgKids3End:
				' is the right specialist — there are only a few in the country, mostly in private clinics.',

			AlgBring1:
				'If cetirizine or levocetirizine is specifically what works for you, there are two options: bring a supply from home, or buy it in neighbouring Serbia, where both are sold freely and cheaply. That is what people do — they stock up on a visa run or ask someone to bring a box.',
			AlgBring2:
				'Medicines for personal use may normally be brought in in reasonable quantities and in their original packaging; for prescription medicines it is worth carrying the prescription or a doctor’s note stating the substance and the dose. Import rules differ between Montenegro and the countries you transit — check them before you travel.',
			AlgBring3:
				'One thing to plan for separately: we did not find an adrenaline auto-injector (EpiPen, Anapen) in the Montenegrin register — adrenaline appears there only inside dental anaesthetics. If you carry an auto-injector, bring your own, watch the expiry date, and agree an action plan with a doctor in advance. For signs of anaphylaxis, call an ambulance on 124 immediately.',

			AlgRecipe1:
				'A foreign prescription is not valid in a Montenegrin pharmacy — you need a local one. In a private clinic that is usually a paper prescription with the doctor’s stamp and signature; the electronic one (eRecept) is mostly used for medicines dispensed through the Health Insurance Fund.',
			AlgRecipe2a:
				'For desloratadine, bilastine or a steroid nasal spray you can go to an ',
			AlgRecipe2Link: 'allergist',
			AlgRecipe2Mid:
				', while ordinary seasonal rhinitis — pollen season, in other words — is well within the scope of a family doctor or the doctor on duty at a private clinic. Our catalog lists the languages each doctor sees patients in — ',
			AlgRecipe2Link2: 'find a doctor who speaks your language',
			AlgRecipe2End: '.',
			AlgRecipe3a:
				'How pharmacies, duty rotas and Fund lists work is covered in our article ',
			AlgRecipe3Link: 'on pharmacies and medications in Montenegro',
			AlgRecipe3End: '.',

			AlgSources0:
				'Availability was checked against the CInMED register: the absence of cetirizine and levocetirizine was verified on cinmed.me directly — by international name, by brand names and by ATC group. The overview is current as of August 2026; registrations change, and this text is a reference, not a substitute for advice from a doctor or pharmacist. Verify against the primary sources:',
			AlgSourcesCinmed:
				'CInMED — the Montenegrin Institute for Medicines and Medical Devices, the official register of authorised medicines: cinmed.me;',
			AlgSourcesFzo:
				'FZOCG — the medicine lists of the Health Insurance Fund: fzocg.me.',
			AlgSourcesCommunity:
				'The practice of buying cetirizine in Serbia comes from the experience of Montenegro’s Russian-speaking communities (2023–2026).',
			AlgSourcesRelatedA:
				'What else from a familiar home first-aid kit is missing here is collected in our article ',
			AlgSourcesRelatedLink: 'on medications you won’t find in Montenegro',
			AlgSourcesRelatedEnd: '.',

			AlgCtaTitle: 'See what pharmacies stock for allergies',
			AlgCtaText:
				'The Allergy category in our catalog: medicines, dosage forms and how each one is dispensed.',
			AlgCtaButton: 'Allergy medicines',
		},
		'ru': {
			AlgTitle: 'Чем заменить Зиртек в Черногории: антигистаминные в аптеках',
			AlgDescription:
				'Цетиризина (Зиртек, Зодак) в реестре Черногории нет. Какие антигистаминные продают без рецепта и по рецепту и чем заменить привычный бренд по действующему веществу.',

			AlgToc_zyrtec: 'Цетиризина в Черногории нет',
			AlgToc_otc: 'Что можно купить без рецепта',
			AlgToc_rx: 'Что отпускают по рецепту',
			AlgToc_brands: 'Домашний бренд — местное вещество',
			AlgToc_kids: 'Детям: сироп вместо капель',
			AlgToc_bring: 'Что привезти и что купить в Сербии',
			AlgToc_recipe: 'Как получить местный рецепт',
			AlgToc_sources: 'Оговорки и источники',

			AlgZyrtec1:
				'За названиями Зиртек / Zyrtec, Зодак, Цетрин и Аллертек стоит одно действующее вещество — цетиризин. В Черногории не зарегистрировано ни одного препарата с ним: цетиризина нет в реестре CInMED. Поэтому обходить аптеки бесполезно — дело не в конкретной аптеке и не в перебоях поставок.',
			AlgZyrtec2:
				'То же с левоцетиризином (Ксизал / Xyzal, Супрастинекс) — его в реестре тоже нет. Русскоязычные сообщества Черногории уже несколько лет отвечают на этот вопрос одинаково: цетиризин везут из Сербии.',
			AlgZyrtec3:
				'Причина не в дефиците, а в ассортименте рынка: Черногория идёт по европейскому и балканскому формуляру, где из H1-блокаторов второго поколения на полке стоят лоратадин, дезлоратадин, фексофенадин и биластин. Это тот же класс, что и цетиризин, но другие вещества — какое подойдёт именно вам, решает врач или фармацевт, а не таблица соответствий.',

			AlgOtc1: 'Без рецепта в черногорских аптеках можно купить:',
			AlgOtcLoratadineSubstance: 'Лоратадин',
			AlgOtcLoratadineMid:
				' — действующее вещество Кларитина (Claritin). Здесь его продают под названием PRESSING: ',
			AlgOtcLoratadineTablets: 'таблетки 10 мг',
			AlgOtcLoratadineOr: ' или ',
			AlgOtcLoratadineSyrup: 'сироп 5 мг/5 мл',
			AlgOtcLoratadineEnd: '.',
			AlgOtcFexofenadineSubstance: 'Фексофенадин',
			AlgOtcFexofenadineMid1:
				' — действующее вещество Аллегры и Телфаста (Telfast). Здесь и названия знакомые: ',
			AlgOtcFexofenadineBrand1: 'ALLEGRA',
			AlgOtcFexofenadineMid2: ' и ',
			AlgOtcFexofenadineBrand2: 'ALERIX',
			AlgOtcFexofenadineEnd: ', таблетки 120 мг.',
			AlgOtcAzelastineSubstance: 'Азеластин',
			AlgOtcAzelastineMid:
				' — действующее вещество спрея для носа Аллергодил. Местное название такое же: ',
			AlgOtcAzelastineBrand: 'ALLERGODIL',
			AlgOtcAzelastineEnd: '.',
			AlgOtcDimetindeneSubstance: 'Диметинден',
			AlgOtcDimetindeneMid:
				' — действующее вещество Фенистила (Fenistil). Здесь оно есть только в виде геля, препарат ',
			AlgOtcDimetindeneBrand: 'FLENTY',
			AlgOtcDimetindeneEnd: '. Капель для приёма внутрь с ним нет.',
			AlgOtcChloropyramineSubstance: 'Хлоропирамин',
			AlgOtcChloropyramineMid:
				' — действующее вещество Супрастина (Suprastin). Без рецепта продаётся как ',
			AlgOtcChloropyramineBrand: 'SYNOPEN, мазь 10 мг/г',
			AlgOtcChloropyramineEnd: '. Таблеток нет, инъекции — по рецепту.',
			AlgOtc2:
				'С глазными каплями хуже: безрецептурные PROCULIN, HEMOKULIN и VISET — это сосудосуживающие капли с нафазолином и тетризолином. Они убирают покраснение, но на саму аллергическую реакцию не действуют. Единственные настоящие антигистаминные капли в реестре — рецептурные.',
			AlgOtc3:
				'В каталоге в категории «Аллергия» попадаются ещё DRAMINA, DIMIGAL и RODAVAN N. Дименгидринат в них действительно H1-блокатор первого поколения, но продают его от укачивания, а не от аллергии.',

			AlgRx1:
				'Остальное здесь рецептурное — включая то, что в других странах лежит на открытой полке:',
			AlgRxDesloratadineSubstance: 'Дезлоратадин',
			AlgRxDesloratadineMid:
				' — действующее вещество Эриуса; здесь тот же бренд пишется AERIUS и продаётся как ',
			AlgRxDesloratadineTablets: 'таблетки 5 мг',
			AlgRxDesloratadineAnd: ' и ',
			AlgRxDesloratadineSolution: 'раствор для приёма внутрь 0,5 мг/мл',
			AlgRxDesloratadineEnd: ', плюс дженерики LORDES, AEROGAL и ALERIZON.',
			AlgRxBilastineSubstance: 'Биластин',
			AlgRxBilastineMid:
				' — то же действующее вещество, что в Никсаре (Nixar) и Bilaxten. Местное название — ',
			AlgRxBilastineBrand: 'ALERGOFEN',
			AlgRxBilastineEnd: ', таблетки 20 мг.',
			AlgRxKetotifenSubstance: 'Кетотифен',
			AlgRxKetotifenMid:
				' — действующее вещество Задитена (Zaditen). Здесь есть только сироп ',
			AlgRxKetotifenBrand: 'GALITIFEN',
			AlgRxKetotifenEnd:
				'. Таблеток и глазных капель с кетотифеном в реестре нет.',
			AlgRxMometasoneSubstance: 'Мометазон',
			AlgRxMometasoneMid:
				' — гормональный спрей для носа, известный как Назонекс; местный препарат — ',
			AlgRxMometasoneBrand: 'NASONEX',
			AlgRxMometasoneMid2:
				'. Есть и комбинация азеластина с флутиказоном — спреи ',
			AlgRxMometasoneBrand2: 'DYMISTA',
			AlgRxMometasoneMid3: ' и ',
			AlgRxMometasoneBrand3: 'FLUFETAN',
			AlgRxMometasoneEnd:
				'. Авамис (Avamys, флутиказона фуроат) в реестре есть, но действующей лицензии у него нет.',
			AlgRxOlopatadineSubstance: 'Олопатадин',
			AlgRxOlopatadineMid:
				' — единственные антигистаминные глазные капли в реестре, препарат ',
			AlgRxOlopatadineBrand: 'KYARA',
			AlgRxOlopatadineEnd: '; то же вещество, что в Опатаноле (Opatanol).',
			AlgRxMontelukastSubstance: 'Монтелукаст',
			AlgRxMontelukastEnd:
				' — не антигистаминное, а антилейкотриеновое средство при астме и тяжёлом аллергическом рините. Здесь это препараты SINGULAIR и ALVOKAST, в таблетках и жевательных таблетках.',
			AlgRxChloropyramineA: 'Хлоропирамин есть и в инъекциях — ',
			AlgRxChloropyramineBrand: 'SYNOPEN 20 мг/2 мл',
			AlgRxChloropyramineEnd:
				'. Это средство для врача и скорой, а не для домашней аптечки.',
			AlgRx2:
				'При тяжёлых реакциях в ход идут гормоны в таблетках и инъекциях, и назначает их врач. Тут есть местная особенность: системного преднизолона в таблетках в реестре нет (преднизолон встречается только в местных формах — свечи, глазные капли), а из системных гормонов в таблетках есть преднизон (NIZON, PRONISON), метилпреднизолон (MEDROL) и дексаметазон. Если вы продолжаете назначенную дома терапию, местное название почти наверняка будет другим. С автоинъектором адреналина, который носят при анафилаксии, история отдельная — о нём ниже.',

			AlgBrands1:
				'Короткая сверка: домашний бренд, его действующее вещество в скобках и что с этим веществом в Черногории.',
			AlgBrandsCetirizine:
				'Зиртек / Zyrtec, Зодак, Цетрин, Аллертек (цетиризин) — в реестре нет.',
			AlgBrandsLevocetirizine:
				'Ксизал / Xyzal, Супрастинекс (левоцетиризин) — в реестре нет.',
			AlgBrandsLoratadine:
				'Кларитин, Ломилан, Лорано (лоратадин) — есть: PRESSING, таблетки и сироп, без рецепта.',
			AlgBrandsDesloratadine:
				'Эриус, Дезал, Лордестин (дезлоратадин) — есть: AERIUS, LORDES, AEROGAL, ALERIZON, по рецепту.',
			AlgBrandsFexofenadine:
				'Аллегра, Телфаст, Фексадин (фексофенадин) — есть: ALLEGRA и ALERIX, без рецепта.',
			AlgBrandsBilastine:
				'Никсар, Bilaxten, Clatra (биластин) — есть: ALERGOFEN, по рецепту.',
			AlgBrandsChloropyramine:
				'Супрастин (хлоропирамин) — есть, но не в таблетках: мазь SYNOPEN без рецепта, инъекции SYNOPEN по рецепту.',
			AlgBrandsDimetindene:
				'Фенистил (диметинден) — только гель FLENTY, капель для приёма внутрь нет.',
			AlgBrandsKetotifen:
				'Задитен (кетотифен) — только сироп GALITIFEN, по рецепту.',
			AlgBrandsOld:
				'Тавегил / Tavegil (клемастин), Диазолин / Diazolin (мебгидролин), Атаракс / Atarax (гидроксизин) — этих веществ в реестре нет вообще.',
			AlgBrandsAzelastine:
				'Аллергодил (азеластин) — спрей для носа ALLERGODIL без рецепта; глазных капель с азеластином здесь нет.',
			AlgBrandsNasal:
				'Назонекс (мометазон) — есть NASONEX, по рецепту; у Авамиса (флутиказона фуроат) действующей лицензии нет, а кромоглициевой кислоты в реестре мы не нашли.',
			AlgBrandsEye:
				'Опатанол (олопатадин) — есть как KYARA, по рецепту; Сингуляр (монтелукаст) — SINGULAIR и ALVOKAST, по рецепту.',
			AlgBrands2a:
				'В аптеке проще назвать действующее вещество, а не бренд: по нему фармацевт найдёт то, что зарегистрировано в стране. Проверить конкретное вещество и режим отпуска можно в нашем ',
			AlgBrands2Link: 'каталоге лекарств',
			AlgBrands2End: '.',

			AlgKids1:
				'Привычных детских капель для приёма внутрь — цетиризиновых или фенистиловых — в Черногории нет. Вместо них сироп и раствор: сироп с лоратадином (PRESSING) продаётся без рецепта, раствор дезлоратадина 0,5 мг/мл (AERIUS, ALERIZON) и сироп с кетотифеном (GALITIFEN) — по рецепту.',
			AlgKids2:
				'Дозу ребёнку подбирают по весу и возрасту — это разговор с врачом или фармацевтом: в каталоге видно форму выпуска и дозировку препарата, но не детскую дозу.',
			AlgKids3a: 'Если аллергия у ребёнка не разовая история, приём ведёт ',
			AlgKids3Link: 'детский аллерголог',
			AlgKids3End:
				' — таких специалистов в стране немного, в основном в частных клиниках.',

			AlgBring1:
				'Если вам подходит именно цетиризин или левоцетиризин, вариантов два: привезти запас из дома или купить в соседней Сербии — там они в свободной продаже и стоят недорого. Так и делают: закупаются по дороге на визаран или просят привезти знакомых.',
			AlgBring2:
				'Лекарства для личного применения обычно разрешено ввозить в разумном количестве и в оригинальной упаковке, а на рецептурные лучше иметь рецепт или заключение врача с указанием вещества и дозировки. Правила ввоза у Черногории и стран транзита свои — проверьте перед поездкой.',
			AlgBring3:
				'Отдельно про тяжёлые реакции: автоинъектора адреналина (EpiPen, Anapen) в черногорском реестре мы не нашли — адреналин встречается там только в составе стоматологических анестетиков. Если вы носите автоинъектор, везите свой, следите за сроком годности и заранее обсудите с врачом, что делать при реакции. При признаках анафилаксии — сразу скорая, 124.',

			AlgRecipe1:
				'Иностранный рецепт в черногорской аптеке недействителен — нужен местный. В частной клинике это обычно бумажный рецепт с печатью и подписью врача; электронный (eRecept) в основном используют для лекарств по линии Фонда медицинского страхования.',
			AlgRecipe2a:
				'За рецептом на дезлоратадин, биластин или гормональный спрей можно идти к ',
			AlgRecipe2Link: 'аллергологу',
			AlgRecipe2Mid:
				', а с обычным сезонным ринитом (пыльца, цветение) справится семейный врач или дежурный врач частной клиники. В нашем каталоге у каждого врача указаны языки приёма — ',
			AlgRecipe2Link2: 'найдите врача, говорящего на вашем языке',
			AlgRecipe2End: '.',
			AlgRecipe3a:
				'Как устроены аптеки, дежурства и списки Фонда, подробно разбираем в статье ',
			AlgRecipe3Link: 'об аптеках и лекарствах в Черногории',
			AlgRecipe3End: '.',

			AlgSources0:
				'Наличие сверено по реестру CInMED: отсутствие цетиризина и левоцетиризина проверялось на cinmed.me напрямую — по международному названию, по названиям брендов и по ATC-группе. Обзор актуален на август 2026 года; регистрации меняются, а сам текст справочный и не заменяет консультацию врача или фармацевта. Проверяйте по первоисточникам:',
			AlgSourcesCinmed:
				'CInMED — Институт лекарств и медицинских изделий Черногории, официальный реестр зарегистрированных препаратов: cinmed.me;',
			AlgSourcesFzo:
				'FZOCG — списки лекарств Фонда медицинского страхования: fzocg.me.',
			AlgSourcesCommunity:
				'Практика с покупкой цетиризина в Сербии — из опыта русскоязычных сообществ Черногории (2023–2026).',
			AlgSourcesRelatedA:
				'Что ещё из привычной домашней аптечки здесь не найти, собрано в статье ',
			AlgSourcesRelatedLink: 'о недостающих лекарствах',
			AlgSourcesRelatedEnd: '.',

			AlgCtaTitle: 'Смотрите, что есть от аллергии',
			AlgCtaText:
				'Категория «Аллергия» в каталоге: препараты, формы выпуска и режим отпуска.',
			AlgCtaButton: 'Лекарства от аллергии',
		},
		'sr': {
			AlgTitle:
				'Čime zamijeniti Zyrtec u Crnoj Gori: antihistaminici u apotekama',
			AlgDescription:
				'Cetirizina (Zyrtec, Zodak) nema u registru Crne Gore. Koji antihistaminici se ovdje izdaju bez recepta i na recept i kako naći poznati brend po aktivnoj supstanci.',

			AlgToc_zyrtec: 'Cetirizina u Crnoj Gori nema',
			AlgToc_otc: 'Šta se može kupiti bez recepta',
			AlgToc_rx: 'Šta se izdaje na recept',
			AlgToc_brands: 'Poznati brend — lokalna supstanca',
			AlgToc_kids: 'Za djecu: sirup umjesto kapi',
			AlgToc_bring: 'Šta donijeti, a šta kupiti u Srbiji',
			AlgToc_recipe: 'Kako doći do lokalnog recepta',
			AlgToc_sources: 'Napomene i izvori',

			AlgZyrtec1:
				'Zyrtec, Zodak, Cetrin i Allertec različiti su brendovi jedne aktivne supstance — cetirizina. U Crnoj Gori nije registrovan ni jedan lijek sa njim: cetirizina nema u registru CInMED-a. Zato nema smisla obilaziti apoteke — nije stvar u jednoj apoteci ni u prekidu snabdijevanja.',
			AlgZyrtec2:
				'Isto važi i za levocetirizin (Xyzal, Suprastinex) — ni njega nema u registru. Ruskogovoreće zajednice u Crnoj Gori već godinama daju isti odgovor: cetirizin se donosi iz Srbije.',
			AlgZyrtec3:
				'Razlog nije nestašica, nego asortiman tržišta: Crna Gora prati evropski i balkanski formular, u kojem su od H1-blokatora druge generacije na polici loratadin, desloratadin, feksofenadin i bilastin. To je ista grupa kao cetirizin, ali su to druge supstance — koja vama odgovara, odlučuje ljekar ili farmaceut, a ne tabela ekvivalenata.',

			AlgOtc1: 'Bez recepta se u crnogorskim apotekama može kupiti:',
			AlgOtcLoratadineSubstance: 'Loratadin',
			AlgOtcLoratadineMid:
				' — aktivna supstanca Claritina. Ovdje se prodaje pod imenom PRESSING: ',
			AlgOtcLoratadineTablets: 'tablete 10 mg',
			AlgOtcLoratadineOr: ' ili ',
			AlgOtcLoratadineSyrup: 'sirup 5 mg/5 ml',
			AlgOtcLoratadineEnd: '.',
			AlgOtcFexofenadineSubstance: 'Feksofenadin',
			AlgOtcFexofenadineMid1:
				' — aktivna supstanca Allegre i Telfasta. Ovdje su i imena poznata: ',
			AlgOtcFexofenadineBrand1: 'ALLEGRA',
			AlgOtcFexofenadineMid2: ' i ',
			AlgOtcFexofenadineBrand2: 'ALERIX',
			AlgOtcFexofenadineEnd: ', tablete 120 mg.',
			AlgOtcAzelastineSubstance: 'Azelastin',
			AlgOtcAzelastineMid:
				' — aktivna supstanca nazalnog spreja Allergodil. Lokalno ime je isto: ',
			AlgOtcAzelastineBrand: 'ALLERGODIL',
			AlgOtcAzelastineEnd: '.',
			AlgOtcDimetindeneSubstance: 'Dimetinden',
			AlgOtcDimetindeneMid:
				' — aktivna supstanca Fenistila. Ovdje postoji samo kao gel, lijek ',
			AlgOtcDimetindeneBrand: 'FLENTY',
			AlgOtcDimetindeneEnd: '. Kapi za oralnu upotrebu sa njim nema.',
			AlgOtcChloropyramineSubstance: 'Hloropiramin',
			AlgOtcChloropyramineMid:
				' — aktivna supstanca Suprastina. Bez recepta se prodaje kao ',
			AlgOtcChloropyramineBrand: 'SYNOPEN, mast 10 mg/g',
			AlgOtcChloropyramineEnd:
				'. Tableta nema, a injekcije se izdaju na recept.',
			AlgOtc2:
				'Sa kapima za oči je teže: PROCULIN, HEMOKULIN i VISET se prodaju slobodno, ali to su vazokonstriktori (nafazolin i tetrizolin) — uklanjaju crvenilo, a na samu alergijsku reakciju ne djeluju. Jedine prave antihistaminske kapi u registru izdaju se na recept.',
			AlgOtc3:
				'U katalogu, u kategoriji alergija, naći ćete i DRAMINU, DIMIGAL i RODAVAN N. Njihov dimenhidrinat zaista je H1-blokator prve generacije, ali se ovdje prodaje protiv mučnine u vozilu, a ne protiv alergije.',

			AlgRx1:
				'Ostalo se ovdje izdaje na recept — uključujući i ono što u drugim zemljama stoji na slobodnoj polici:',
			AlgRxDesloratadineSubstance: 'Desloratadin',
			AlgRxDesloratadineMid:
				' — aktivna supstanca Aeriusa; lokalni brend piše se AERIUS i dolazi kao ',
			AlgRxDesloratadineTablets: 'tablete 5 mg',
			AlgRxDesloratadineAnd: ' i ',
			AlgRxDesloratadineSolution: 'oralni rastvor 0,5 mg/ml',
			AlgRxDesloratadineEnd: ', plus generici LORDES, AEROGAL i ALERIZON.',
			AlgRxBilastineSubstance: 'Bilastin',
			AlgRxBilastineMid:
				' — ista aktivna supstanca kao u Bilaxtenu i Clatri. Lokalno ime je ',
			AlgRxBilastineBrand: 'ALERGOFEN',
			AlgRxBilastineEnd: ', tablete 20 mg.',
			AlgRxKetotifenSubstance: 'Ketotifen',
			AlgRxKetotifenMid:
				' — aktivna supstanca Zaditena. Ovdje postoji samo sirup ',
			AlgRxKetotifenBrand: 'GALITIFEN',
			AlgRxKetotifenEnd:
				'. Tableta i kapi za oči sa ketotifenom u registru nema.',
			AlgRxMometasoneSubstance: 'Mometazon',
			AlgRxMometasoneMid:
				' — hormonski sprej za nos, drugdje poznat kao Nasonex; lokalni lijek je ',
			AlgRxMometasoneBrand: 'NASONEX',
			AlgRxMometasoneMid2:
				'. Postoji i kombinacija azelastina i flutikazona — sprejevi ',
			AlgRxMometasoneBrand2: 'DYMISTA',
			AlgRxMometasoneMid3: ' i ',
			AlgRxMometasoneBrand3: 'FLUFETAN',
			AlgRxMometasoneEnd:
				'. Avamys (flutikazon furoat) postoji u registru, ali bez važeće licence.',
			AlgRxOlopatadineSubstance: 'Olopatadin',
			AlgRxOlopatadineMid:
				' — jedine antihistaminske kapi za oči u registru, lijek ',
			AlgRxOlopatadineBrand: 'KYARA',
			AlgRxOlopatadineEnd: '; ista supstanca kao u Opatanolu.',
			AlgRxMontelukastSubstance: 'Montelukast',
			AlgRxMontelukastEnd:
				' — nije antihistaminik, nego antileukotrijen za astmu i teži alergijski rinitis. Ovdje su to ljekovi SINGULAIR i ALVOKAST, u tabletama i tabletama za žvakanje.',
			AlgRxChloropyramineA: 'Hloropiramin postoji i u injekcijama — ',
			AlgRxChloropyramineBrand: 'SYNOPEN 20 mg/2 ml',
			AlgRxChloropyramineEnd:
				'. To je sredstvo za ljekara i hitnu pomoć, a ne za kućnu apoteku.',
			AlgRx2:
				'Kod težih reakcija koriste se hormoni u tabletama i injekcijama, a propisuje ih ljekar. Postoji i lokalna posebnost: sistemskog prednizolona u tabletama u registru nema (prednizolon se javlja samo u lokalnim oblicima — supozitorije, kapi za oči), a od sistemskih hormona u tabletama ima prednizon (NIZON, PRONISON), metilprednizolon (MEDROL) i deksametazon. Ako nastavljate terapiju započetu kod kuće, lokalni naziv će skoro sigurno biti drugi. Sa auto-injektorom adrenalina, koji se nosi zbog anafilaksije, priča je drugačija — o tome ispod.',

			AlgBrands1:
				'Kratka provjera: brend koji poznajete, njegova aktivna supstanca u zagradi i status te supstance u Crnoj Gori.',
			AlgBrandsCetirizine:
				'Zyrtec, Zodak, Cetrin, Allertec (cetirizin) — nema ih u registru.',
			AlgBrandsLevocetirizine:
				'Xyzal, Suprastinex (levocetirizin) — nema ih u registru.',
			AlgBrandsLoratadine:
				'Claritin, Lorano, Lomilan (loratadin) — ima: PRESSING, tablete i sirup, bez recepta.',
			AlgBrandsDesloratadine:
				'Aerius, Dezal, Azomyr (desloratadin) — ima: AERIUS, LORDES, AEROGAL, ALERIZON, na recept.',
			AlgBrandsFexofenadine:
				'Allegra, Telfast (feksofenadin) — ima: ALLEGRA i ALERIX, bez recepta.',
			AlgBrandsBilastine:
				'Bilaxten, Clatra, Nixar (bilastin) — ima: ALERGOFEN, na recept.',
			AlgBrandsChloropyramine:
				'Suprastin (hloropiramin) — ima, ali ne u tabletama: mast SYNOPEN bez recepta, injekcije SYNOPEN na recept.',
			AlgBrandsDimetindene:
				'Fenistil (dimetinden) — samo gel FLENTY, kapi za oralnu upotrebu nema.',
			AlgBrandsKetotifen:
				'Zaditen (ketotifen) — samo sirup GALITIFEN, na recept.',
			AlgBrandsOld:
				'Tavegil (klemastin), Diazolin (mebhidrolin), Atarax (hidroksizin) — tih supstanci u registru nema uopšte.',
			AlgBrandsAzelastine:
				'Allergodil (azelastin) — sprej za nos ALLERGODIL bez recepta; kapi za oči sa azelastinom ovdje nema.',
			AlgBrandsNasal:
				'Nasonex (mometazon) — ima NASONEX, na recept; Avamys (flutikazon furoat) nema važeću licencu, a kromoglicinsku kiselinu u registru nismo našli.',
			AlgBrandsEye:
				'Opatanol i Patanol (olopatadin) — ima kao KYARA, na recept; Singulair (montelukast) — SINGULAIR i ALVOKAST, na recept.',
			AlgBrands2a:
				'U apoteci je lakše navesti aktivnu supstancu nego brend: po njoj će farmaceut naći ono što je registrovano u zemlji. Konkretnu supstancu i način izdavanja možete provjeriti u našem ',
			AlgBrands2Link: 'registru ljekova',
			AlgBrands2End: '.',

			AlgKids1:
				'Uobičajenih dječjih kapi za oralnu upotrebu — sa cetirizinom ili tipa Fenistila — u Crnoj Gori nema. Umjesto njih idu sirup i rastvor: sirup sa loratadinom (PRESSING) izdaje se bez recepta, a rastvor desloratadina 0,5 mg/ml (AERIUS, ALERIZON) i sirup sa ketotifenom (GALITIFEN) na recept.',
			AlgKids2:
				'Dozu za dijete određuju po težini i uzrastu — to je razgovor sa ljekarom ili farmaceutom: u katalogu se vidi oblik i jačina lijeka, ali ne i dječja doza.',
			AlgKids3a: 'Ako alergija kod djeteta nije jednokratna, prima ',
			AlgKids3Link: 'dječji alergolog',
			AlgKids3End:
				' — takvih specijalista u zemlji je malo, najviše u privatnim klinikama.',

			AlgBring1:
				'Ako vam odgovara upravo cetirizin ili levocetirizin, postoje dvije opcije: donijeti zalihu od kuće ili kupiti u susjednoj Srbiji, gdje se prodaju slobodno i nisu skupi. Tako se i radi: kupuje se putem na vizaran ili se moli neko da donese.',
			AlgBring2:
				'Ljekove za ličnu upotrebu obično je dozvoljeno unositi u razumnoj količini i u originalnom pakovanju, a za one na recept bolje je imati recept ili nalaz ljekara sa navedenom supstancom i dozom. Pravila unosa Crna Gora i tranzitne zemlje imaju svoja — provjerite ih prije putovanja.',
			AlgBring3:
				'Posebno o težim reakcijama: auto-injektor adrenalina (EpiPen, Anapen) u crnogorskom registru nismo našli — adrenalin se u njemu javlja samo u sastavu stomatoloških anestetika. Ako nosite auto-injektor, donesite svoj, pratite rok trajanja i unaprijed sa ljekarom dogovorite plan za slučaj reakcije. Kod znakova anafilaksije — odmah hitna pomoć, 124.',

			AlgRecipe1:
				'Strani recept u crnogorskoj apoteci ne vrijedi — potreban je lokalni. U privatnoj klinici to je obično papirni recept sa pečatom i potpisom ljekara; elektronski (eRecept) najviše se koristi za ljekove preko Fonda za zdravstveno osiguranje.',
			AlgRecipe2a:
				'Za recept na desloratadin, bilastin ili hormonski sprej možete kod ',
			AlgRecipe2Link: 'alergologa',
			AlgRecipe2Mid:
				', a sa običnim sezonskim rinitisom (polen, cvjetanje) izaći će na kraj i porodični ljekar ili ljekar na dežurstvu u privatnoj klinici. U našem katalogu je za svakog ljekara naveden jezik na kojem prima — ',
			AlgRecipe2Link2: 'nađite ljekara koji govori vaš jezik',
			AlgRecipe2End: '.',
			AlgRecipe3a:
				'Kako funkcionišu apoteke, dežurstva i liste Fonda, detaljno obrađujemo u tekstu ',
			AlgRecipe3Link: 'o apotekama i ljekovima u Crnoj Gori',
			AlgRecipe3End: '.',

			AlgSources0:
				'Dostupnost je provjerena u registru CInMED-a: odsustvo cetirizina i levocetirizina provjereno je direktno na cinmed.me — po internacionalnom nazivu, po nazivima brendova i po ATC grupi. Pregled važi za avgust 2026; registracije se mijenjaju, a sam tekst je informativan i ne zamjenjuje savjet ljekara ili farmaceuta. Provjerite u primarnim izvorima:',
			AlgSourcesCinmed:
				'CInMED — Institut za ljekove i medicinska sredstva Crne Gore, službeni registar registrovanih ljekova: cinmed.me;',
			AlgSourcesFzo:
				'FZOCG — liste ljekova Fonda za zdravstveno osiguranje: fzocg.me.',
			AlgSourcesCommunity:
				'Praksa kupovine cetirizina u Srbiji potiče iz iskustva ruskogovorećih zajednica u Crnoj Gori (2023–2026).',
			AlgSourcesRelatedA:
				'Šta se još iz uobičajene kućne apoteke ovdje ne može naći, sabrano je u tekstu ',
			AlgSourcesRelatedLink: 'o ljekovima kojih nema u Crnoj Gori',
			AlgSourcesRelatedEnd: '.',

			AlgCtaTitle: 'Pogledajte šta ima protiv alergije',
			AlgCtaText:
				'Kategorija alergija u našem registru: ljekovi, farmaceutski oblici i način izdavanja.',
			AlgCtaButton: 'Ljekovi protiv alergije',
		},
		'sr-cyrl': {
			AlgTitle:
				'Чиме замијенити Zyrtec у Црној Гори: антихистаминици у апотекама',
			AlgDescription:
				'Цетиризина (Zyrtec, Zodak) нема у регистру Црне Горе. Који антихистаминици се овдје издају без рецепта и на рецепт и како наћи познати бренд по активној супстанци.',

			AlgToc_zyrtec: 'Цетиризина у Црној Гори нема',
			AlgToc_otc: 'Шта се може купити без рецепта',
			AlgToc_rx: 'Шта се издаје на рецепт',
			AlgToc_brands: 'Познати бренд — локална супстанца',
			AlgToc_kids: 'За дјецу: сируп умјесто капи',
			AlgToc_bring: 'Шта донијети, а шта купити у Србији',
			AlgToc_recipe: 'Како доћи до локалног рецепта',
			AlgToc_sources: 'Напомене и извори',

			AlgZyrtec1:
				'Zyrtec, Zodak, Cetrin и Allertec различити су брендови једне активне супстанце — цетиризина. У Црној Гори није регистрован ни један лијек са њим: цетиризина нема у регистру CInMED-а. Зато нема смисла обилазити апотеке — није ствар у једној апотеци ни у прекиду снабдијевања.',
			AlgZyrtec2:
				'Исто важи и за левоцетиризин (Xyzal, Suprastinex) — ни њега нема у регистру. Рускоговорне заједнице у Црној Гори већ годинама дају исти одговор: цетиризин се доноси из Србије.',
			AlgZyrtec3:
				'Разлог није несташица, него асортиман тржишта: Црна Гора прати европски и балкански формулар, у којем су од H1-блокатора друге генерације на полици лоратадин, деслоратадин, фексофенадин и биластин. То је иста група као цетиризин, али су то друге супстанце — која вама одговара, одлучује љекар или фармацеут, а не табела еквивалената.',

			AlgOtc1: 'Без рецепта се у црногорским апотекама може купити:',
			AlgOtcLoratadineSubstance: 'Лоратадин',
			AlgOtcLoratadineMid:
				' — активна супстанца Claritina. Овдје се продаје под именом PRESSING: ',
			AlgOtcLoratadineTablets: 'таблете 10 mg',
			AlgOtcLoratadineOr: ' или ',
			AlgOtcLoratadineSyrup: 'сируп 5 mg/5 ml',
			AlgOtcLoratadineEnd: '.',
			AlgOtcFexofenadineSubstance: 'Фексофенадин',
			AlgOtcFexofenadineMid1:
				' — активна супстанца Allegre и Telfasta. Овдје су и имена позната: ',
			AlgOtcFexofenadineBrand1: 'ALLEGRA',
			AlgOtcFexofenadineMid2: ' и ',
			AlgOtcFexofenadineBrand2: 'ALERIX',
			AlgOtcFexofenadineEnd: ', таблете 120 mg.',
			AlgOtcAzelastineSubstance: 'Азеластин',
			AlgOtcAzelastineMid:
				' — активна супстанца назалног спреја Allergodil. Локално име је исто: ',
			AlgOtcAzelastineBrand: 'ALLERGODIL',
			AlgOtcAzelastineEnd: '.',
			AlgOtcDimetindeneSubstance: 'Диметинден',
			AlgOtcDimetindeneMid:
				' — активна супстанца Fenistila. Овдје постоји само као гел, лијек ',
			AlgOtcDimetindeneBrand: 'FLENTY',
			AlgOtcDimetindeneEnd: '. Капи за оралну употребу са њим нема.',
			AlgOtcChloropyramineSubstance: 'Хлоропирамин',
			AlgOtcChloropyramineMid:
				' — активна супстанца Suprastina. Без рецепта се продаје као ',
			AlgOtcChloropyramineBrand: 'SYNOPEN, маст 10 mg/g',
			AlgOtcChloropyramineEnd:
				'. Таблета нема, а инјекције се издају на рецепт.',
			AlgOtc2:
				'Са капима за очи је теже: PROCULIN, HEMOKULIN и VISET се продају слободно, али то су вазоконстриктори (нафазолин и тетризолин) — уклањају црвенило, а на саму алергијску реакцију не дјелују. Једине праве антихистаминске капи у регистру издају се на рецепт.',
			AlgOtc3:
				'У каталогу, у категорији алергија, наћи ћете и DRAMINU, DIMIGAL и RODAVAN N. Њихов дименхидринат заиста је H1-блокатор прве генерације, али се овдје продаје против мучнине у возилу, а не против алергије.',

			AlgRx1:
				'Остало се овдје издаје на рецепт — укључујући и оно што у другим земљама стоји на слободној полици:',
			AlgRxDesloratadineSubstance: 'Деслоратадин',
			AlgRxDesloratadineMid:
				' — активна супстанца Aeriusa; локални бренд пише се AERIUS и долази као ',
			AlgRxDesloratadineTablets: 'таблете 5 mg',
			AlgRxDesloratadineAnd: ' и ',
			AlgRxDesloratadineSolution: 'орални раствор 0,5 mg/ml',
			AlgRxDesloratadineEnd: ', плус генерици LORDES, AEROGAL и ALERIZON.',
			AlgRxBilastineSubstance: 'Биластин',
			AlgRxBilastineMid:
				' — иста активна супстанца као у Bilaxtenu и Clatri. Локално име је ',
			AlgRxBilastineBrand: 'ALERGOFEN',
			AlgRxBilastineEnd: ', таблете 20 mg.',
			AlgRxKetotifenSubstance: 'Кетотифен',
			AlgRxKetotifenMid:
				' — активна супстанца Zaditena. Овдје постоји само сируп ',
			AlgRxKetotifenBrand: 'GALITIFEN',
			AlgRxKetotifenEnd:
				'. Таблета и капи за очи са кетотифеном у регистру нема.',
			AlgRxMometasoneSubstance: 'Мометазон',
			AlgRxMometasoneMid:
				' — хормонски спреј за нос, другдје познат као Nasonex; локални лијек је ',
			AlgRxMometasoneBrand: 'NASONEX',
			AlgRxMometasoneMid2:
				'. Постоји и комбинација азеластина и флутиказона — спрејеви ',
			AlgRxMometasoneBrand2: 'DYMISTA',
			AlgRxMometasoneMid3: ' и ',
			AlgRxMometasoneBrand3: 'FLUFETAN',
			AlgRxMometasoneEnd:
				'. Avamys (флутиказон фуроат) постоји у регистру, али без важеће лиценце.',
			AlgRxOlopatadineSubstance: 'Олопатадин',
			AlgRxOlopatadineMid:
				' — једине антихистаминске капи за очи у регистру, лијек ',
			AlgRxOlopatadineBrand: 'KYARA',
			AlgRxOlopatadineEnd: '; иста супстанца као у Opatanolu.',
			AlgRxMontelukastSubstance: 'Монтелукаст',
			AlgRxMontelukastEnd:
				' — није антихистаминик, него антилеукотријен за астму и тежи алергијски ринитис. Овдје су то љекови SINGULAIR и ALVOKAST, у таблетама и таблетама за жвакање.',
			AlgRxChloropyramineA: 'Хлоропирамин постоји и у инјекцијама — ',
			AlgRxChloropyramineBrand: 'SYNOPEN 20 mg/2 ml',
			AlgRxChloropyramineEnd:
				'. То је средство за љекара и хитну помоћ, а не за кућну апотеку.',
			AlgRx2:
				'Код тежих реакција користе се хормони у таблетама и инјекцијама, а прописује их љекар. Постоји и локална посебност: системског преднизолона у таблетама у регистру нема (преднизолон се јавља само у локалним облицима — супозиторије, капи за очи), а од системских хормона у таблетама има преднизон (NIZON, PRONISON), метилпреднизолон (MEDROL) и дексаметазон. Ако настављате терапију започету код куће, локални назив ће скоро сигурно бити други. Са ауто-инјектором адреналина, који се носи због анафилаксије, прича је другачија — о томе испод.',

			AlgBrands1:
				'Кратка провјера: бренд који познајете, његова активна супстанца у загради и статус те супстанце у Црној Гори.',
			AlgBrandsCetirizine:
				'Zyrtec, Zodak, Cetrin, Allertec (цетиризин) — нема их у регистру.',
			AlgBrandsLevocetirizine:
				'Xyzal, Suprastinex (левоцетиризин) — нема их у регистру.',
			AlgBrandsLoratadine:
				'Claritin, Lorano, Lomilan (лоратадин) — има: PRESSING, таблете и сируп, без рецепта.',
			AlgBrandsDesloratadine:
				'Aerius, Dezal, Azomyr (деслоратадин) — има: AERIUS, LORDES, AEROGAL, ALERIZON, на рецепт.',
			AlgBrandsFexofenadine:
				'Allegra, Telfast (фексофенадин) — има: ALLEGRA и ALERIX, без рецепта.',
			AlgBrandsBilastine:
				'Bilaxten, Clatra, Nixar (биластин) — има: ALERGOFEN, на рецепт.',
			AlgBrandsChloropyramine:
				'Suprastin (хлоропирамин) — има, али не у таблетама: маст SYNOPEN без рецепта, инјекције SYNOPEN на рецепт.',
			AlgBrandsDimetindene:
				'Fenistil (диметинден) — само гел FLENTY, капи за оралну употребу нема.',
			AlgBrandsKetotifen:
				'Zaditen (кетотифен) — само сируп GALITIFEN, на рецепт.',
			AlgBrandsOld:
				'Tavegil (клемастин), Diazolin (мебхидролин), Atarax (хидроксизин) — тих супстанци у регистру нема уопште.',
			AlgBrandsAzelastine:
				'Allergodil (азеластин) — спреј за нос ALLERGODIL без рецепта; капи за очи са азеластином овдје нема.',
			AlgBrandsNasal:
				'Nasonex (мометазон) — има NASONEX, на рецепт; Avamys (флутиказон фуроат) нема важећу лиценцу, а кромоглицинску киселину у регистру нисмо нашли.',
			AlgBrandsEye:
				'Opatanol и Patanol (олопатадин) — има као KYARA, на рецепт; Singulair (монтелукаст) — SINGULAIR и ALVOKAST, на рецепт.',
			AlgBrands2a:
				'У апотеци је лакше навести активну супстанцу него бренд: по њој ће фармацеут наћи оно што је регистровано у земљи. Конкретну супстанцу и начин издавања можете провјерити у нашем ',
			AlgBrands2Link: 'регистру љекова',
			AlgBrands2End: '.',

			AlgKids1:
				'Уобичајених дјечјих капи за оралну употребу — са цетиризином или типа Fenistila — у Црној Гори нема. Умјесто њих иду сируп и раствор: сируп са лоратадином (PRESSING) издаје се без рецепта, а раствор деслоратадина 0,5 mg/ml (AERIUS, ALERIZON) и сируп са кетотифеном (GALITIFEN) на рецепт.',
			AlgKids2:
				'Дозу за дијете одређују по тежини и узрасту — то је разговор са љекаром или фармацеутом: у каталогу се види облик и јачина лијека, али не и дјечја доза.',
			AlgKids3a: 'Ако алергија код дјетета није једнократна, прима ',
			AlgKids3Link: 'дјечји алерголог',
			AlgKids3End:
				' — таквих специјалиста у земљи је мало, највише у приватним клиникама.',

			AlgBring1:
				'Ако вам одговара управо цетиризин или левоцетиризин, постоје двије опције: донијети залиху од куће или купити у сусједној Србији, гдје се продају слободно и нису скупи. Тако се и ради: купује се путем на визаран или се моли неко да донесе.',
			AlgBring2:
				'Љекове за личну употребу обично је дозвољено уносити у разумној количини и у оригиналном паковању, а за оне на рецепт боље је имати рецепт или налаз љекара са наведеном супстанцом и дозом. Правила уноса Црна Гора и транзитне земље имају своја — провјерите их прије путовања.',
			AlgBring3:
				'Посебно о тежим реакцијама: ауто-инјектор адреналина (EpiPen, Anapen) у црногорском регистру нисмо нашли — адреналин се у њему јавља само у саставу стоматолошких анестетика. Ако носите ауто-инјектор, донесите свој, пратите рок трајања и унапријед са љекаром договорите план за случај реакције. Код знакова анафилаксије — одмах хитна помоћ, 124.',

			AlgRecipe1:
				'Страни рецепт у црногорској апотеци не вриједи — потребан је локални. У приватној клиници то је обично папирни рецепт са печатом и потписом љекара; електронски (eRecept) највише се користи за љекове преко Фонда за здравствено осигурање.',
			AlgRecipe2a:
				'За рецепт на деслоратадин, биластин или хормонски спреј можете код ',
			AlgRecipe2Link: 'алерголога',
			AlgRecipe2Mid:
				', а са обичним сезонским ринитисом (полен, цвјетање) изаћи ће на крај и породични љекар или љекар на дежурству у приватној клиници. У нашем каталогу је за сваког љекара наведен језик на којем прима — ',
			AlgRecipe2Link2: 'нађите љекара који говори ваш језик',
			AlgRecipe2End: '.',
			AlgRecipe3a:
				'Како функционишу апотеке, дежурства и листе Фонда, детаљно обрађујемо у тексту ',
			AlgRecipe3Link: 'о апотекама и љековима у Црној Гори',
			AlgRecipe3End: '.',

			AlgSources0:
				'Доступност је провјерена у регистру CInMED-а: одсуство цетиризина и левоцетиризина провјерено је директно на cinmed.me — по интернационалном називу, по називима брендова и по ATC групи. Преглед важи за август 2026; регистрације се мијењају, а сам текст је информативан и не замјењује савјет љекара или фармацеута. Провјерите у примарним изворима:',
			AlgSourcesCinmed:
				'CInMED — Институт за љекове и медицинска средства Црне Горе, службени регистар регистрованих љекова: cinmed.me;',
			AlgSourcesFzo:
				'FZOCG — листе љекова Фонда за здравствено осигурање: fzocg.me.',
			AlgSourcesCommunity:
				'Пракса куповине цетиризина у Србији потиче из искуства рускоговорних заједница у Црној Гори (2023–2026).',
			AlgSourcesRelatedA:
				'Шта се још из уобичајене кућне апотеке овдје не може наћи, сабрано је у тексту ',
			AlgSourcesRelatedLink: 'о љековима којих нема у Црној Гори',
			AlgSourcesRelatedEnd: '.',

			AlgCtaTitle: 'Погледајте шта има против алергије',
			AlgCtaText:
				'Категорија алергија у нашем регистру: љекови, фармацеутски облици и начин издавања.',
			AlgCtaButton: 'Љекови против алергије',
		},
		'de': {
			AlgTitle:
				'Zyrtec in Montenegro ersetzen: Antihistaminika in den Apotheken',
			AlgDescription:
				'Cetirizin (Zyrtec, Zodak) ist in Montenegro nicht zugelassen. Welche Antihistaminika es hier mit und ohne Rezept gibt und wie Sie Ersatz über den Wirkstoff finden.',

			AlgToc_zyrtec: 'Cetirizin ist hier nicht zugelassen',
			AlgToc_otc: 'Was es rezeptfrei gibt',
			AlgToc_rx: 'Was ein Rezept braucht',
			AlgToc_brands: 'Gewohnte Marke, lokaler Wirkstoff',
			AlgToc_kids: 'Für Kinder: Sirup statt Tropfen',
			AlgToc_bring: 'Mitbringen oder in Serbien kaufen',
			AlgToc_recipe: 'Wie Sie ein lokales Rezept bekommen',
			AlgToc_sources: 'Hinweise und Quellen',

			AlgZyrtec1:
				'Zyrtec, Zodak, Cetrin und Allertec sind verschiedene Marken eines einzigen Wirkstoffs: Cetirizin. In Montenegro ist kein einziges Präparat damit zugelassen — Cetirizin fehlt im Register des CInMED. Es lohnt sich also nicht, Apotheke für Apotheke abzuklappern: es liegt nicht an einer Filiale und nicht an einem Lieferengpass.',
			AlgZyrtec2:
				'Dasselbe gilt für Levocetirizin (Xyzal, Suprastinex) — ebenfalls nicht im Register. Die russischsprachigen Communitys in Montenegro geben seit Jahren dieselbe Antwort: Cetirizin wird aus Serbien mitgebracht.',
			AlgZyrtec3:
				'Der Grund ist nicht ein Mangel, sondern das Sortiment: Montenegro folgt dem europäischen und balkanischen Formular, in dem von den H1-Blockern der zweiten Generation Loratadin, Desloratadin, Fexofenadin und Bilastin im Regal stehen. Dieselbe Klasse wie Cetirizin, aber andere Wirkstoffe — welcher für Sie passt, entscheiden Ärztin, Arzt oder Apotheke, nicht eine Umrechnungstabelle.',

			AlgOtc1: 'Rezeptfrei bekommen Sie in montenegrinischen Apotheken:',
			AlgOtcLoratadineSubstance: 'Loratadin',
			AlgOtcLoratadineMid:
				' — der Wirkstoff von Lorano und Claritin. Hier heißt das Präparat PRESSING: ',
			AlgOtcLoratadineTablets: 'Tabletten 10 mg',
			AlgOtcLoratadineOr: ' oder ',
			AlgOtcLoratadineSyrup: 'Sirup 5 mg/5 ml',
			AlgOtcLoratadineEnd: '.',
			AlgOtcFexofenadineSubstance: 'Fexofenadin',
			AlgOtcFexofenadineMid1:
				' — der Wirkstoff von Telfast. Hier sind die Markennamen ebenfalls bekannt: ',
			AlgOtcFexofenadineBrand1: 'ALLEGRA',
			AlgOtcFexofenadineMid2: ' und ',
			AlgOtcFexofenadineBrand2: 'ALERIX',
			AlgOtcFexofenadineEnd: ', Tabletten 120 mg.',
			AlgOtcAzelastineSubstance: 'Azelastin',
			AlgOtcAzelastineMid:
				' — der Wirkstoff des Nasensprays Allergodil. Der lokale Markenname ist derselbe: ',
			AlgOtcAzelastineBrand: 'ALLERGODIL',
			AlgOtcAzelastineEnd: '.',
			AlgOtcDimetindeneSubstance: 'Dimetinden',
			AlgOtcDimetindeneMid:
				' — der Wirkstoff von Fenistil. Hier gibt es ihn nur als Gel, das Präparat ',
			AlgOtcDimetindeneBrand: 'FLENTY',
			AlgOtcDimetindeneEnd: '. Tropfen zum Einnehmen damit gibt es nicht.',
			AlgOtcChloropyramineSubstance: 'Chloropyramin',
			AlgOtcChloropyramineMid:
				' — der Wirkstoff von Suprastin. Rezeptfrei gibt es ihn als ',
			AlgOtcChloropyramineBrand: 'SYNOPEN Salbe, 10 mg/g',
			AlgOtcChloropyramineEnd:
				'. Tabletten gibt es nicht, die Injektionen sind rezeptpflichtig.',
			AlgOtc2:
				'Bei Augentropfen sieht es schlechter aus: PROCULIN, HEMOKULIN und VISET sind frei verkäuflich, aber es sind abschwellende Tropfen (Naphazolin und Tetryzolin) — sie nehmen die Rötung, wirken aber nicht auf die allergische Reaktion. Die einzigen echten antihistaminischen Augentropfen im Register sind rezeptpflichtig.',
			AlgOtc3:
				'In der Katalogkategorie Allergie begegnen Ihnen außerdem DRAMINA, DIMIGAL und RODAVAN N. Ihr Dimenhydrinat ist tatsächlich ein H1-Blocker der ersten Generation, wird hier aber gegen Reisekrankheit verkauft, nicht gegen Allergie.',

			AlgRx1:
				'Alles Weitere ist hier rezeptpflichtig — auch das, was in anderen Ländern frei im Regal steht:',
			AlgRxDesloratadineSubstance: 'Desloratadin',
			AlgRxDesloratadineMid:
				' — der Wirkstoff von Aerius; die lokale Marke schreibt sich AERIUS und kommt als ',
			AlgRxDesloratadineTablets: 'Tabletten 5 mg',
			AlgRxDesloratadineAnd: ' und als ',
			AlgRxDesloratadineSolution: 'Lösung zum Einnehmen 0,5 mg/ml',
			AlgRxDesloratadineEnd:
				', dazu die Generika LORDES, AEROGAL und ALERIZON.',
			AlgRxBilastineSubstance: 'Bilastin',
			AlgRxBilastineMid:
				' — derselbe Wirkstoff wie in Bilaxten und Clatra. Der lokale Markenname ist ',
			AlgRxBilastineBrand: 'ALERGOFEN',
			AlgRxBilastineEnd: ', Tabletten 20 mg.',
			AlgRxKetotifenSubstance: 'Ketotifen',
			AlgRxKetotifenMid:
				' — der Wirkstoff von Zaditen. Hier gibt es ihn nur als Sirup ',
			AlgRxKetotifenBrand: 'GALITIFEN',
			AlgRxKetotifenEnd:
				'. Ketotifen-Tabletten und -Augentropfen sind hier nicht zugelassen.',
			AlgRxMometasoneSubstance: 'Mometason',
			AlgRxMometasoneMid:
				' — das Kortisonnasenspray, das anderswo Nasonex heißt; das lokale Präparat ist ',
			AlgRxMometasoneBrand: 'NASONEX',
			AlgRxMometasoneMid2:
				'. Es gibt auch die Kombination aus Azelastin und Fluticason — die Sprays ',
			AlgRxMometasoneBrand2: 'DYMISTA',
			AlgRxMometasoneMid3: ' und ',
			AlgRxMometasoneBrand3: 'FLUFETAN',
			AlgRxMometasoneEnd:
				'. Avamys (Fluticasonfuroat) steht im Register, hat aber keine gültige Zulassung.',
			AlgRxOlopatadineSubstance: 'Olopatadin',
			AlgRxOlopatadineMid:
				' — die einzigen antihistaminischen Augentropfen im Register, hier als ',
			AlgRxOlopatadineBrand: 'KYARA',
			AlgRxOlopatadineEnd: '; derselbe Wirkstoff wie in Opatanol.',
			AlgRxMontelukastSubstance: 'Montelukast',
			AlgRxMontelukastEnd:
				' — kein Antihistaminikum, sondern ein Leukotrien-Antagonist bei Asthma und schwerer allergischer Rhinitis. Hier heißen die Präparate SINGULAIR und ALVOKAST, als Tabletten und Kautabletten.',
			AlgRxChloropyramineA: 'Chloropyramin gibt es auch als Injektion — ',
			AlgRxChloropyramineBrand: 'SYNOPEN 20 mg/2 ml',
			AlgRxChloropyramineEnd:
				'. Das ist etwas für Praxis und Rettungsdienst, nicht für die Hausapotheke.',
			AlgRx2:
				'Bei schweren Reaktionen kommen Kortikosteroide als Tabletten und Injektionen zum Einsatz, und darüber entscheidet der Arzt. Eine lokale Besonderheit ist wichtig: systemische Prednisolon-Tabletten sind hier nicht zugelassen (Prednisolon kommt nur in lokalen Formen vor — Zäpfchen, Augentropfen), als systemische Kortikosteroide in Tablettenform gibt es Prednison (NIZON, PRONISON), Methylprednisolon (MEDROL) und Dexamethason. Wenn Sie eine zu Hause begonnene Therapie fortsetzen, wird der lokale Name mit hoher Wahrscheinlichkeit ein anderer sein. Der Adrenalin-Autoinjektor, den man bei Anaphylaxie bei sich trägt, ist ein Sonderfall — dazu unten.',

			AlgBrands1:
				'Kurzer Abgleich: die Marke, die Sie kennen, ihr Wirkstoff in Klammern und der Status dieses Wirkstoffs in Montenegro.',
			AlgBrandsCetirizine:
				'Zyrtec, Zodak, Cetrin, Allertec (Cetirizin) — nicht im Register.',
			AlgBrandsLevocetirizine:
				'Xyzal, Suprastinex (Levocetirizin) — nicht im Register.',
			AlgBrandsLoratadine:
				'Lorano, Claritin, Lomilan (Loratadin) — vorhanden: PRESSING, Tabletten und Sirup, rezeptfrei.',
			AlgBrandsDesloratadine:
				'Aerius, Dezal, Azomyr (Desloratadin) — vorhanden: AERIUS, LORDES, AEROGAL, ALERIZON, rezeptpflichtig.',
			AlgBrandsFexofenadine:
				'Telfast, Allegra (Fexofenadin) — vorhanden: ALLEGRA und ALERIX, rezeptfrei.',
			AlgBrandsBilastine:
				'Bilaxten, Clatra, Nixar (Bilastin) — vorhanden: ALERGOFEN, rezeptpflichtig.',
			AlgBrandsChloropyramine:
				'Suprastin (Chloropyramin) — vorhanden, aber nicht als Tablette: SYNOPEN Salbe rezeptfrei, SYNOPEN Injektionen rezeptpflichtig.',
			AlgBrandsDimetindene:
				'Fenistil (Dimetinden) — nur das FLENTY Gel, keine Tropfen zum Einnehmen.',
			AlgBrandsKetotifen:
				'Zaditen (Ketotifen) — nur der GALITIFEN Sirup, rezeptpflichtig.',
			AlgBrandsOld:
				'Tavegil (Clemastin), Diazolin (Mebhydrolin), Atarax (Hydroxyzin) — diese Wirkstoffe fehlen im Register vollständig.',
			AlgBrandsAzelastine:
				'Allergodil (Azelastin) — das Nasenspray ALLERGODIL ist rezeptfrei; Augentropfen mit Azelastin gibt es hier nicht.',
			AlgBrandsNasal:
				'Nasonex (Mometason) — vorhanden als NASONEX, rezeptpflichtig; Avamys (Fluticasonfuroat) hat keine gültige Zulassung, und Cromoglicinsäure haben wir im Register nicht gefunden.',
			AlgBrandsEye:
				'Opatanol, Patanol (Olopatadin) — vorhanden als KYARA, rezeptpflichtig; Singulair (Montelukast) — SINGULAIR und ALVOKAST, rezeptpflichtig.',
			AlgBrands2a:
				'In der Apotheke ist es einfacher, den Wirkstoff zu nennen als die Marke: damit findet das Personal, was im Land zugelassen ist. Einen konkreten Wirkstoff und die Abgabeform können Sie in unserem ',
			AlgBrands2Link: 'Arzneimittelregister',
			AlgBrands2End: ' prüfen.',

			AlgKids1:
				'Die gewohnten Tropfen zum Einnehmen für Kinder — mit Cetirizin oder wie bei Fenistil — gibt es in Montenegro nicht. An ihre Stelle treten Sirup und Lösung: der Loratadin-Sirup (PRESSING) ist rezeptfrei, die Desloratadin-Lösung 0,5 mg/ml (AERIUS, ALERIZON) und der Ketotifen-Sirup (GALITIFEN) sind rezeptpflichtig.',
			AlgKids2:
				'Die Dosis für ein Kind richtet sich nach Gewicht und Alter — das ist ein Gespräch mit Arzt oder Apotheke: der Katalog zeigt Darreichungsform und Stärke, nie eine Kinderdosis.',
			AlgKids3a: 'Wenn die Allergie eines Kindes kein Einzelfall ist, ist ein ',
			AlgKids3Link: 'Kinderallergologe',
			AlgKids3End:
				' zuständig — es gibt nur wenige im Land, überwiegend in Privatkliniken.',

			AlgBring1:
				'Wenn genau Cetirizin oder Levocetirizin für Sie funktioniert, gibt es zwei Wege: einen Vorrat von zu Hause mitbringen oder im benachbarten Serbien kaufen, wo beide frei und günstig erhältlich sind. Genau so machen es viele: Einkauf auf dem Visa-Run oder über Bekannte.',
			AlgBring2:
				'Arzneimittel für den persönlichen Bedarf dürfen in der Regel in angemessener Menge und in der Originalpackung eingeführt werden; bei rezeptpflichtigen Mitteln ist ein Rezept oder ein Arztschreiben mit Wirkstoff und Dosierung sinnvoll. Montenegro und die Transitländer haben je eigene Einfuhrregeln — prüfen Sie sie vor der Reise.',
			AlgBring3:
				'Ein Punkt für sich sind schwere Reaktionen: einen Adrenalin-Autoinjektor (EpiPen, Anapen) haben wir im montenegrinischen Register nicht gefunden — Adrenalin kommt dort nur in Zahnanästhetika vor. Wenn Sie einen Autoinjektor tragen, bringen Sie Ihren eigenen mit, achten Sie auf das Verfallsdatum und besprechen Sie den Notfallplan vorab mit einer Ärztin oder einem Arzt. Bei Anzeichen einer Anaphylaxie sofort den Rettungsdienst rufen: 124.',

			AlgRecipe1:
				'Ein ausländisches Rezept gilt in einer montenegrinischen Apotheke nicht — Sie brauchen ein lokales. In einer Privatklinik ist das meist ein Papierrezept mit Stempel und Unterschrift; das elektronische (eRecept) wird vor allem für Arzneimittel über den Krankenversicherungsfonds genutzt.',
			AlgRecipe2a:
				'Für ein Rezept auf Desloratadin, Bilastin oder ein Kortisonspray können Sie zu einer ',
			AlgRecipe2Link: 'Allergologin oder einem Allergologen',
			AlgRecipe2Mid:
				' gehen; bei gewöhnlichem Heuschnupfen — also der Pollen-Saison — genügt die Hausärztin oder der Bereitschaftsarzt einer Privatklinik. In unserem Katalog steht bei jedem Arzt, in welchen Sprachen er behandelt — ',
			AlgRecipe2Link2: 'finden Sie einen Arzt, der Ihre Sprache spricht',
			AlgRecipe2End: '.',
			AlgRecipe3a:
				'Wie Apotheken, Notdienste und Fondslisten funktionieren, behandeln wir im Beitrag ',
			AlgRecipe3Link: 'über Apotheken und Medikamente in Montenegro',
			AlgRecipe3End: '.',

			AlgSources0:
				'Die Verfügbarkeit wurde im CInMED-Register geprüft: das Fehlen von Cetirizin und Levocetirizin wurde direkt auf cinmed.me verifiziert — über den internationalen Namen, über die Markennamen und über die ATC-Gruppe. Stand des Überblicks: August 2026. Zulassungen ändern sich, und der Text ist eine Orientierung, kein Ersatz für die Beratung durch Arzt oder Apotheke. Prüfen Sie an den Primärquellen:',
			AlgSourcesCinmed:
				'CInMED — das montenegrinische Institut für Arzneimittel und Medizinprodukte, das offizielle Register zugelassener Arzneimittel: cinmed.me;',
			AlgSourcesFzo:
				'FZOCG — die Arzneimittellisten des Krankenversicherungsfonds: fzocg.me.',
			AlgSourcesCommunity:
				'Die Praxis, Cetirizin in Serbien zu kaufen, stammt aus der Erfahrung der russischsprachigen Communitys in Montenegro (2023–2026).',
			AlgSourcesRelatedA:
				'Was aus einer gewohnten Hausapotheke hier sonst noch fehlt, haben wir im Beitrag ',
			AlgSourcesRelatedLink: 'über fehlende Medikamente in Montenegro',
			AlgSourcesRelatedEnd: ' gesammelt.',

			AlgCtaTitle: 'Sehen Sie, was es gegen Allergien gibt',
			AlgCtaText:
				'Die Kategorie Allergie in unserem Register: Präparate, Darreichungsformen und Abgabestatus.',
			AlgCtaButton: 'Allergiemittel',
		},
		'tr': {
			AlgTitle:
				'Karadağ’da Zyrtec yerine ne var: eczanelerde antihistaminikler',
			AlgDescription:
				'Setirizin (Zyrtec, Zodak) Karadağ’da ruhsatlı değil. Eczanelerde reçetesiz ve reçeteyle hangi antihistaminikler var, markanızı etkin maddesinden nasıl bulursunuz.',

			AlgToc_zyrtec: 'Setirizin burada ruhsatlı değil',
			AlgToc_otc: 'Reçetesiz alınabilenler',
			AlgToc_rx: 'Reçete gerektirenler',
			AlgToc_brands: 'Bildiğiniz marka, yerel etkin madde',
			AlgToc_kids: 'Çocuklar için: damla yerine şurup',
			AlgToc_bring: 'Ne getirmeli, Sırbistan’dan ne almalı',
			AlgToc_recipe: 'Yerel reçete nasıl alınır',
			AlgToc_sources: 'Uyarılar ve kaynaklar',

			AlgZyrtec1:
				'Zyrtec, Zodak, Cetrin ve Allertec tek bir etkin maddenin farklı markalarıdır: setirizin. Karadağ’da bu maddeyi içeren tek bir ilaç bile ruhsatlı değil — setirizin CInMED kaydında yok. Bu yüzden eczane eczane dolaşmanın anlamı yok: sorun tek bir eczanede ya da tedarikte değil.',
			AlgZyrtec2:
				'Aynısı levosetirizin (Xyzal, Suprastinex) için de geçerli — o da kayıtta yok. Karadağ’daki Rusça konuşan topluluklar yıllardır aynı yanıtı veriyor: setirizin Sırbistan’dan getiriliyor.',
			AlgZyrtec3:
				'Sebep bir kıtlık değil, pazarın ürün yelpazesi: Karadağ, ikinci nesil H1 blokerlerinden rafta loratadin, desloratadin, feksofenadin ve bilastinin bulunduğu Avrupa ve Balkan formülerini izliyor. Bunlar setirizinle aynı sınıftan, ama farklı maddelerdir — hangisinin size uyduğuna bir eşdeğerlik tablosu değil, hekim veya eczacı karar verir.',

			AlgOtc1: 'Karadağ eczanelerinde reçetesiz alabilecekleriniz:',
			AlgOtcLoratadineSubstance: 'Loratadin',
			AlgOtcLoratadineMid:
				' — Claritine’in etkin maddesi. Burada PRESSING adıyla satılıyor: ',
			AlgOtcLoratadineTablets: '10 mg tablet',
			AlgOtcLoratadineOr: ' veya ',
			AlgOtcLoratadineSyrup: '5 mg/5 ml şurup',
			AlgOtcLoratadineEnd: '.',
			AlgOtcFexofenadineSubstance: 'Feksofenadin',
			AlgOtcFexofenadineMid1:
				' — Telfast ve Fexadyne’in etkin maddesi. Buradaki marka adları da tanıdık: ',
			AlgOtcFexofenadineBrand1: 'ALLEGRA',
			AlgOtcFexofenadineMid2: ' ve ',
			AlgOtcFexofenadineBrand2: 'ALERIX',
			AlgOtcFexofenadineEnd: ', 120 mg tablet.',
			AlgOtcAzelastineSubstance: 'Azelastin',
			AlgOtcAzelastineMid:
				' — Allergodil burun spreyinin etkin maddesi. Buradaki marka adı da aynı: ',
			AlgOtcAzelastineBrand: 'ALLERGODIL',
			AlgOtcAzelastineEnd: '.',
			AlgOtcDimetindeneSubstance: 'Dimetinden',
			AlgOtcDimetindeneMid:
				' — Fenistil’in etkin maddesi. Burada yalnızca jel formunda var: ',
			AlgOtcDimetindeneBrand: 'FLENTY',
			AlgOtcDimetindeneEnd: '. Ağızdan alınan damlası yok.',
			AlgOtcChloropyramineSubstance: 'Kloropiramin',
			AlgOtcChloropyramineMid:
				' — Suprastin’in etkin maddesi. Reçetesiz olarak ',
			AlgOtcChloropyramineBrand: 'SYNOPEN merhem, 10 mg/g',
			AlgOtcChloropyramineEnd:
				' şeklinde bulunuyor. Tablet formu yok, enjeksiyonlar reçeteli.',
			AlgOtc2:
				'Göz damlalarında durum daha zayıf: PROCULIN, HEMOKULIN ve VISET serbestçe satılıyor, ama bunlar damar büzücü damlalar (nafazolin ve tetrizolin) — kızarıklığı geçirir, alerjik tepkiye etki etmez. Kayıttaki tek gerçek antihistaminik göz damlası reçeteyle veriliyor.',
			AlgOtc3:
				'Katalogda alerji kategorisinde DRAMINA, DIMIGAL ve RODAVAN N de karşınıza çıkar. İçlerindeki dimenhidrinat gerçekten birinci nesil bir H1 blokeridir, ama burada alerji için değil, taşıt tutmasına karşı satılıyor.',

			AlgRx1:
				'Gerisi burada reçeteli — başka ülkelerde raftan alınanlar dahil:',
			AlgRxDesloratadineSubstance: 'Desloratadin',
			AlgRxDesloratadineMid:
				' — Aerius’un etkin maddesi; buradaki marka AERIUS olarak yazılıyor ve şu formlarda var: ',
			AlgRxDesloratadineTablets: '5 mg tablet',
			AlgRxDesloratadineAnd: ' ve ',
			AlgRxDesloratadineSolution: '0,5 mg/ml oral çözelti',
			AlgRxDesloratadineEnd:
				', ayrıca LORDES, AEROGAL ve ALERIZON jenerikleri.',
			AlgRxBilastineSubstance: 'Bilastin',
			AlgRxBilastineMid:
				' — Bilaxten ve Clatra ile aynı etkin madde. Buradaki marka adı ',
			AlgRxBilastineBrand: 'ALERGOFEN',
			AlgRxBilastineEnd: ', 20 mg tablet.',
			AlgRxKetotifenSubstance: 'Ketotifen',
			AlgRxKetotifenMid:
				' — Zaditen’in etkin maddesi. Burada yalnızca şurup olarak var: ',
			AlgRxKetotifenBrand: 'GALITIFEN',
			AlgRxKetotifenEnd: '. Ketotifenli tablet ve göz damlası kayıtta yok.',
			AlgRxMometasoneSubstance: 'Mometazon',
			AlgRxMometasoneMid:
				' — başka ülkelerde Nasonex adıyla bilinen kortizonlu burun spreyi; buradaki ilaç ',
			AlgRxMometasoneBrand: 'NASONEX',
			AlgRxMometasoneMid2: '. Azelastin ve flutikazon kombinasyonu da var — ',
			AlgRxMometasoneBrand2: 'DYMISTA',
			AlgRxMometasoneMid3: ' ve ',
			AlgRxMometasoneBrand3: 'FLUFETAN',
			AlgRxMometasoneEnd:
				' spreyleri. Avamys (flutikazon furoat) kayıtta var, ancak geçerli ruhsatı yok.',
			AlgRxOlopatadineSubstance: 'Olopatadin',
			AlgRxOlopatadineMid:
				' — kayıttaki tek antihistaminik göz damlası, burada ',
			AlgRxOlopatadineBrand: 'KYARA',
			AlgRxOlopatadineEnd: ' adıyla; Patanol ile aynı etkin madde.',
			AlgRxMontelukastSubstance: 'Montelukast',
			AlgRxMontelukastEnd:
				' — antihistaminik değil, astım ve ağır alerjik rinitte kullanılan lökotrien antagonisti. Buradaki ilaçlar SINGULAIR ve ALVOKAST; tablet ve çiğneme tableti formunda.',
			AlgRxChloropyramineA: 'Kloropiramin enjeksiyon formunda da var — ',
			AlgRxChloropyramineBrand: 'SYNOPEN 20 mg/2 ml',
			AlgRxChloropyramineEnd:
				'. Bu, ev eczanesi için değil, hekim ve acil ekipleri içindir.',
			AlgRx2:
				'Ağır tepkilerde tablet ve enjeksiyon formunda kortikosteroidler devreye giriyor ve bunlara hekim karar verir. Yerel bir ayrıntı önemli: sistemik prednizolon tableti kayıtta hiç yok (prednizolon yalnızca lokal formlarda geçiyor — fitil, göz damlası); tablet formundaki sistemik kortikosteroidler prednizon (NIZON, PRONISON), metilprednizolon (MEDROL) ve deksametazondur. Ülkenizde başlanan bir tedaviyi sürdürüyorsanız buradaki ad neredeyse kesin farklı olacak. Anafilaksi için taşınan adrenalin oto-enjektörü ayrı bir konu — aşağıda.',

			AlgBrands1:
				'Kısa bir karşılaştırma: bildiğiniz marka, parantez içinde etkin maddesi ve o maddenin Karadağ’daki durumu.',
			AlgBrandsCetirizine:
				'Zyrtec, Zodak, Cetrin, Allertec (setirizin) — kayıtta yok.',
			AlgBrandsLevocetirizine:
				'Xyzal, Suprastinex (levosetirizin) — kayıtta yok.',
			AlgBrandsLoratadine:
				'Claritine, Lorano, Lomilan (loratadin) — var: PRESSING, tablet ve şurup, reçetesiz.',
			AlgBrandsDesloratadine:
				'Aerius, Desalergo (desloratadin) — var: AERIUS, LORDES, AEROGAL, ALERIZON, reçeteli.',
			AlgBrandsFexofenadine:
				'Telfast, Fexadyne (feksofenadin) — var: ALLEGRA ve ALERIX, reçetesiz.',
			AlgBrandsBilastine:
				'Bilaxten, Clatra (bilastin) — var: ALERGOFEN, reçeteli.',
			AlgBrandsChloropyramine:
				'Suprastin (kloropiramin) — var, ama tablet olarak değil: SYNOPEN merhem reçetesiz, SYNOPEN enjeksiyon reçeteli.',
			AlgBrandsDimetindene:
				'Fenistil (dimetinden) — yalnızca FLENTY jeli; ağızdan alınan damla yok.',
			AlgBrandsKetotifen:
				'Zaditen (ketotifen) — yalnızca GALITIFEN şurubu, reçeteli.',
			AlgBrandsOld:
				'Tavegil (klemastin), Diazolin (mebhidrolin), Atarax (hidroksizin) — bu maddeler kayıtta hiç yok.',
			AlgBrandsAzelastine:
				'Allergodil (azelastin) — ALLERGODIL burun spreyi reçetesiz; azelastinli göz damlası burada yok.',
			AlgBrandsNasal:
				'Nasonex (mometazon) — NASONEX olarak var, reçeteli; Avamys (flutikazon furoat) geçerli ruhsata sahip değil, kromoglisik asidi ise kayıtta bulamadık.',
			AlgBrandsEye:
				'Patanol, Pataday (olopatadin) — KYARA olarak var, reçeteli; Singulair (montelukast) — SINGULAIR ve ALVOKAST, reçeteli.',
			AlgBrands2a:
				'Eczanede marka yerine etkin maddeyi söylemek daha kolay: onunla eczacı ülkede ruhsatlı olanı bulur. Belirli bir etkin maddeyi ve nasıl verildiğini ',
			AlgBrands2Link: 'ilaç kataloğumuzda',
			AlgBrands2End: ' kontrol edebilirsiniz.',

			AlgKids1:
				'Çocuklar için alışılmış ağızdan damlalar — setirizinli ya da Fenistil türü — Karadağ’da yok. Yerlerini şurup ve çözelti alıyor: loratadinli şurup (PRESSING) reçetesiz, desloratadin 0,5 mg/ml çözelti (AERIUS, ALERIZON) ve ketotifenli şurup (GALITIFEN) reçeteli.',
			AlgKids2:
				'Çocuk dozu kiloya ve yaşa göre belirlenir; bu, hekim veya eczacıyla konuşulacak bir konudur: katalogda ilacın formu ve dozu görünür, çocuk dozu görünmez.',
			AlgKids3a: 'Çocuktaki alerji tek seferlik değilse ',
			AlgKids3Link: 'çocuk alerji uzmanı',
			AlgKids3End:
				' ilgilenir — ülkede bu uzmanlar az sayıda ve çoğunlukla özel kliniklerde.',

			AlgBring1:
				'Size özellikle setirizin veya levosetirizin uyuyorsa iki yol var: evden bir miktar getirmek ya da komşu Sırbistan’da almak — orada ikisi de serbest ve ucuz. Nitekim öyle yapılıyor: vize turunda alınıyor ya da gelen birinden rica ediliyor.',
			AlgBring2:
				'Kişisel kullanım için ilaçlar genellikle makul miktarda ve orijinal ambalajında getirilebilir; reçeteli olanlar için etkin madde ve dozun yazdığı reçete ya da hekim raporu yanınızda olsun. Karadağ’ın ve transit ülkelerin giriş kuralları farklıdır — yolculuktan önce kontrol edin.',
			AlgBring3:
				'Ağır tepkiler ayrı bir başlık: adrenalin oto-enjektörünü (EpiPen, Anapen) Karadağ kaydında bulamadık — adrenalin orada yalnızca diş anestezikleri içinde geçiyor. Oto-enjektör taşıyorsanız kendinizin olanı getirin, son kullanma tarihini takip edin ve tepki halinde ne yapacağınızı hekiminizle önceden konuşun. Anafilaksi belirtilerinde hemen ambulansı arayın: 124.',

			AlgRecipe1:
				'Yabancı reçete Karadağ eczanesinde geçerli değil — yerel bir reçete gerekir. Özel klinikte bu genellikle hekim kaşesi ve imzası bulunan kâğıt reçetedir; elektronik reçete (eRecept) daha çok Sağlık Sigortası Fonu üzerinden verilen ilaçlar için kullanılıyor.',
			AlgRecipe2a:
				'Desloratadin, bilastin veya kortizonlu sprey reçetesi için bir ',
			AlgRecipe2Link: 'alerji uzmanına',
			AlgRecipe2Mid:
				' gidebilirsiniz; sıradan mevsimsel rinit, yani polen mevsimi için aile hekimi ya da özel klinikteki nöbetçi hekim yeterli olur. Kataloğumuzda her hekimin hangi dillerde hasta kabul ettiği yazılıdır — ',
			AlgRecipe2Link2: 'dilinizi konuşan bir hekim bulun',
			AlgRecipe2End: '.',
			AlgRecipe3a:
				'Eczanelerin, nöbet düzeninin ve Fon listelerinin nasıl işlediğini ',
			AlgRecipe3Link: 'Karadağ’da eczaneler ve ilaçlar yazımızda',
			AlgRecipe3End: ' ayrıntılı olarak ele alıyoruz.',

			AlgSources0:
				'Bulunabilirlik CInMED kaydından doğrulandı: setirizin ve levosetirizinin bulunmadığı cinmed.me üzerinde doğrudan kontrol edildi — uluslararası ad, marka adları ve ATC grubu üzerinden. Bu özet Ağustos 2026 itibarıyla geçerlidir; ruhsatlar değişir ve metin bilgilendirme amaçlıdır, hekim veya eczacı danışmasının yerini tutmaz. Birincil kaynaklardan doğrulayın:',
			AlgSourcesCinmed:
				'CInMED — Karadağ İlaç ve Tıbbi Cihaz Enstitüsü, ruhsatlı ilaçların resmî kaydı: cinmed.me;',
			AlgSourcesFzo:
				'FZOCG — Sağlık Sigortası Fonu’nun ilaç listeleri: fzocg.me.',
			AlgSourcesCommunity:
				'Setirizini Sırbistan’dan alma pratiği, Karadağ’ın Rusça konuşan topluluklarının deneyiminden geliyor (2023–2026).',
			AlgSourcesRelatedA:
				'Alışık olduğunuz ev eczanesinden burada başka nelerin bulunmadığını ',
			AlgSourcesRelatedLink: 'Karadağ’da bulunmayan ilaçlar yazımızda',
			AlgSourcesRelatedEnd: ' topladık.',

			AlgCtaTitle: 'Alerji için nelerin bulunduğuna bakın',
			AlgCtaText:
				'Kataloğumuzdaki alerji kategorisi: ilaçlar, farmasötik formlar ve veriliş şekli.',
			AlgCtaButton: 'Alerji ilaçları',
		},
	},
};
