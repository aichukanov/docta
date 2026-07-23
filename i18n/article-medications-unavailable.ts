// Контент статьи «Чего нет в аптеках Черногории: привычные лекарства из
// России и Украины». Справочный YMYL-обзор наличия, НЕ рекомендация по замене:
// конкретную альтернативу и дозировку подбирает врач/фармацевт по действующему
// веществу (МНН приводим латиницей). Действующие вещества, которые ЕСТЬ в ЧГ,
// вынесены ссылками в каталог (substanceIds): активированный уголь (523),
// лоратадин (498), дезлоратадин (178), фексофенадин (259), парацетамол (635),
// ибупрофен (364) — id сверены по med_substances (только active-препараты).
// Источники: опыт русскоязычных сообществ ЧГ (2023–2026, data/chat-exports/
// _analysis/whats-not-available.md), реестр CInMED (cinmed.me), списки FZOCG.
// Осельтамивир/цетиризин в реестре не найдены — не линкуются и не подаются как
// доступные. Ввоз (Корвалол/фенобарбитал) — с юр-оговоркой. Актуальность: июль 2026.
export default {
	messages: {
		'en': {
			UnaTitle:
				"Medications you won't find in Montenegro: your usual home first-aid kit",
			UnaDescription:
				'Enterosgel, rehydration salts, cetirizine, miramistin, suprastin, corvalol — which drugs from a Russian or Ukrainian home kit you won’t find in Montenegro, why, how to look for a substitute by active ingredient, and what to keep in mind when bringing medicines from home. Current as of July 2026.',

			'UnaToc_why': 'Why your usual kit falls short here',
			'UnaToc_gaps': "What's really missing and how to find a substitute",
			'UnaToc_antivirals': 'Antivirals and immunomodulators: a break in tradition',
			'UnaToc_import': "What's risky or forbidden to bring in",
			'UnaToc_access':
				"It's not only about the substance: prescriptions and access",
			'UnaToc_sources': 'Caveats and sources',

			UnaWhy1:
				'One of the first things people notice after moving to Montenegro is that the home first-aid kit they are used to simply cannot be reassembled here: half the familiar names are not sold. It is not a shortage — the Montenegrin market follows the European and Balkan formulary, which differs markedly from the Russian and Ukrainian one. Some drugs common in the former USSR were never registered here, and others belong to treatment traditions that European medicine does not share at all.',
			UnaWhy2:
				'Below is what people from those countries most often look for and fail to find, based on the experience of Montenegro’s Russian-speaking communities. It is an overview of what is on the shelves, not a prescription: choosing a substitute and its dosage is a job for a doctor or pharmacist.',

			UnaGaps1:
				'The simplest approach is to look for a drug by its international nonproprietary name (INN) rather than the familiar brand: with it, a pharmacist will find whatever is registered in the country. For some familiar remedies, though, there is no over-the-counter equivalent by active substance at all:',
			UnaGapsSorbents:
				'Sorbents. Enterosgel and Polisorb are not sold — people often ask others to bring them. Of the intestinal sorbents, ',
			UnaGapsSorbentsLink: 'activated charcoal',
			UnaGapsSorbentsEnd: ' is freely available in pharmacies.',
			UnaGapsAntisepticsA:
				'Wound antiseptics. Chlorhexidine and miramistin in their familiar form are hard to find, and there is no dioxidine; the children’s classics are missing too — brilliant green (zelyonka), fucorcin, calamine. The standard European antiseptics are available here: ',
			UnaGapsAntisepticsPovidone: 'povidone-iodine',
			UnaGapsAntisepticsMid: ' (Betadine) and ',
			UnaGapsAntisepticsOctenidine: 'octenidine',
			UnaGapsAntisepticsEnd: ' (Octenisept).',
			UnaGapsAntihistaminesA:
				'Antihistamines. Tavegil (clemastine) is not sold, and neither is cetirizine (Zyrtec) — levocetirizine (Xyzal) is usually brought in from Serbia. Suprastin’s active substance, however, is available here: ',
			UnaGapsAntihistaminesChloropyramine: 'chloropyramine',
			UnaGapsAntihistaminesMid: ' is sold as ',
			UnaGapsAntihistaminesSynopen: 'Synopen',
			UnaGapsAntihistaminesMid2:
				' (injections and a topical gel). Among tablet H1 blockers, pharmacies stock ',
			UnaGapsAntihistaminesLink1: 'loratadine',
			UnaGapsAntihistaminesLink2: 'desloratadine',
			UnaGapsAntihistaminesLink3: 'fexofenadine',
			UnaGapsAntihistaminesEnd:
				'. Oral drops are almost absent — mostly tablets and syrups. Fenistil’s active substance, ',
			UnaGapsAntihistaminesDimetindene: 'dimetindene',
			UnaGapsAntihistaminesDimMid: ', is registered, but only as a gel — ',
			UnaGapsAntihistaminesFlenty: 'Flenty',
			UnaGapsAntihistaminesTail: '; the familiar oral drops are not sold.',
			UnaGapsRehydration:
				'Rehydration salts. Pharmacy-grade rehydration powder (Regidron) is not available. Sports electrolyte sachets are sold, but many contain sugar, which is undesirable during an intestinal infection — check the composition.',
			UnaGapsAnalgesicsA:
				'Combination analgesics. Familiar over-the-counter combination tablets like Pentalgin are essentially not sold; the multi-component options here are mostly cold remedies, Coldrex-style: ',
			UnaGapsAnalgesicsCaffetin: 'Caffetin Cold',
			UnaGapsAnalgesicsMid: ', ',
			UnaGapsAnalgesicsTylolHot: 'Tylol Hot',
			UnaGapsAnalgesicsMid2:
				' and the like. As for painkillers, the individual substances — ',
			UnaGapsAnalgesicsLink1: 'paracetamol',
			UnaGapsAnalgesicsLink2: 'ibuprofen',
			UnaGapsAnalgesicsEnd: ' — are sold freely.',
			UnaGapsSpasmoA:
				'Antispasmodics. No-Spa (drotaverine) and papaverine are not sold. Of the GI antispasmodics, pharmacies stock, for example, ',
			UnaGapsSpasmoMebeverine: 'mebeverine',
			UnaGapsSpasmoEnd:
				' — but a pharmacist will advise what fits your case.',
			UnaGapsMisc:
				'Individual items. By community reports, you will not find Doctor MOM, Kameton, Validol, Heptral (ademetionine), Panangin or Asparkam (potassium and magnesium aspartate); sibutramine is not sold under any name.',
			UnaGaps2:
				'You can check whether a specific drug is registered in Montenegro and how it is dispensed in our ',
			UnaGaps2Link: 'register of medicines',
			UnaGaps2End: '.',

			UnaAntivirals1:
				'A separate story is the antivirals and immunomodulators familiar in Russia and Ukraine: Viferon, Arbidol, Cycloferon, Kagocel, Polyoxidonium, Citovir, Ergoferon. Montenegro does not have them, and this is not a local shortage: this class of drugs is essentially not used outside Russia and the former USSR and is not part of European medical practice. Looking here for something to boost immunity during a cold is pointless — it simply does not exist in the local range. Nor are there separate preventive antivirals for children.',
			UnaAntivirals2:
				'This does not mean viral infections cannot be treated: against specific pathogens there are drugs with proven efficacy, which a doctor prescribes by indication — but that is targeted treatment, not a preventive course.',
			UnaAntivirals3a:
				'A similar story is the nootropics and metabolic remedies from the usual post-Soviet kit: Actovegin, Mexidol, Cerebrolysin, Phenibut, Meldonium. Montenegro does not have them, for the same reason — no evidence base recognised in European practice. A few vascular agents do exist, though — for example ',
			UnaAntivirals3Vinpocetine: 'vinpocetine',
			UnaAntivirals3Mid: ' or ',
			UnaAntivirals3Cinnarizine: 'cinnarizine',
			UnaAntivirals3End: '.',

			'UnaToc_glp1': 'Diabetes and weight-loss injections',
			UnaGlp1a:
				'A separate topic is the GLP-1 agonists (semaglutide, tirzepatide) that people in Russia and Ukraine now widely inject for weight loss. Semaglutide is available in Montenegro: ',
			UnaGlp1Ozempic: 'Ozempic',
			UnaGlp1Mid: ' (for type 2 diabetes) and ',
			UnaGlp1Wegovy: 'Wegovy',
			UnaGlp1End:
				' (for weight loss) are registered — both injectable and prescription-only. Tirzepatide (Mounjaro) is not yet in the local registry.',
			UnaGlp12:
				'These are serious prescription drugs with contraindications and side effects: a doctor prescribes them by indication (diabetes, obesity) and titrates the dose gradually — they are not something to inject for quick weight loss without supervision. Be aware of shortages too: semaglutide periodically goes out of stock worldwide.',
			UnaGlp13a:
				'Diabetes itself is well covered: modern insulin analogues are available, along with oral drugs — ',
			UnaGlp13Metformin: 'metformin',
			UnaGlp13Mid: ', ',
			UnaGlp13Dapagliflozin: 'dapagliflozin',
			UnaGlp13End:
				' (Forxiga), empagliflozin (Jardiance), gliptins. With a knjižica, drugs on the Fund list are almost free; without insurance you pay out of pocket, but they are available.',

			UnaImport1:
				'Some of what is missing you may want to bring from home — and here there is a legal nuance. Corvalol and Valocordin contain phenobarbital, which in many countries is a controlled substance: importing such drugs may be restricted or prohibited, even if they are sold freely back home. The same applies to strong painkillers and psychotropic medicines.',
			UnaImport2:
				'General rule: before travelling, check the customs rules of Montenegro and of any transit country. Medicines for personal use are usually allowed in reasonable quantities, in original packaging and with a prescription or a doctor’s report stating the active substance and dosage. For borderline drugs it is better to carry documentary proof of the prescription — or not to bring them at all.',

			UnaAccess1:
				'Often the problem is not that the substance is missing but that it will not be sold to you without a prescription. Antibiotics, sleeping pills, antidepressants and most prescription drugs are not dispensed over the counter in Montenegro. And a foreign prescription — Russian, Ukrainian, any — is not valid in a local pharmacy: you need a local one. At a private clinic that is usually a paper prescription with the doctor’s stamp and signature; the electronic prescription (eRecept) is mainly used for Fund-subsidised dispensing.',
			UnaAccess2:
				'So the familiar routine has to be rebuilt: get a local prescription from a doctor by active substance, and if the drug is not registered in Montenegro, look in neighbouring Serbia or Bosnia, where the range is wider, or order it through a pharmacy. How prescriptions, the Fund lists and the search for analogs work is covered in detail in our article ',
			UnaAccess2Link: 'on pharmacies and medications in Montenegro',
			UnaAccess2End: '.',

			UnaSources0:
				'This overview draws on the experience of Montenegro’s Russian-speaking communities (2023–2026) and is current as of July 2026. Availability and rules change; the material is for reference and does not replace a consultation with a doctor or pharmacist. Verify against the primary sources:',
			UnaSourcesCinmed:
				'CInMED — the Institute for Medicines and Medical Devices of Montenegro, the official register of approved drugs: cinmed.me;',
			UnaSourcesFzo: "FZOCG — the Health Insurance Fund's drug lists: fzocg.me.",
			UnaSourcesDoctors:
				'Need a doctor to sort out your therapy and issue a local prescription? Our catalog shows the languages each doctor speaks — ',
			UnaSourcesDoctorsLink: 'find a doctor who speaks your language',
			UnaSourcesDoctorsEnd: '.',

			UnaCtaTitle: 'Looking for a specific medication?',
			UnaCtaText:
				'Check whether it is registered in Montenegro and how it is dispensed in our catalog.',
			UnaCtaButton: 'Medications catalog',
		},
		'ru': {
			UnaTitle:
				'Чего нет в аптеках Черногории: привычные лекарства из России и Украины',
			UnaDescription:
				'Энтеросгель, Регидрон, Зиртек, Мирамистин, Супрастин, Корвалол, Пенталгин — что из домашней аптечки не найти в Черногории, чем это объясняется, как искать замену по действующему веществу и что учесть при ввозе из дома. Актуально на июль 2026 года.',

			'UnaToc_why': 'Почему привычной аптечки здесь не хватает',
			'UnaToc_gaps': 'Чего действительно нет и как искать замену',
			'UnaToc_antivirals': 'Противовирусные и иммуномодуляторы: разрыв традиций',
			'UnaToc_import': 'Что рискованно или нельзя ввозить',
			'UnaToc_access': 'Дело не только в веществе: рецепты и доступ',
			'UnaToc_sources': 'Оговорки и источники',

			UnaWhy1:
				'Переехав в Черногорию, многие первым делом обнаруживают, что привычную домашнюю аптечку здесь не собрать: половины названий в аптеках просто нет. Дело не в дефиците — черногорский рынок ориентирован на европейский и балканский формуляр, а он заметно отличается от российского и украинского. Часть препаратов, привычных в СНГ, здесь никогда не регистрировали, а часть относится к лечебным традициям, которых в европейской медицине нет вовсе.',
			UnaWhy2:
				'Ниже — то, что из домашней аптечки чаще всего ищут и не находят, по опыту русскоязычных сообществ Черногории. Это обзор наличия, а не назначение: подобрать замену и дозировку должен врач или фармацевт.',

			UnaGaps1:
				'Проще всего искать лекарство по международному непатентованному наименованию (МНН), а не по знакомому бренду: по нему фармацевт подберёт то, что зарегистрировано в стране. Но у части привычных средств прямого аналога по действующему веществу в свободной продаже нет:',
			UnaGapsSorbents:
				'Сорбенты. Энтеросгеля и Полисорба в продаже нет — их часто просят привезти. Из энтеросорбентов в аптеках свободно продаётся ',
			UnaGapsSorbentsLink: 'активированный уголь',
			UnaGapsSorbentsEnd: '.',
			UnaGapsAntisepticsA:
				'Антисептики для ран. Хлоргексидин и Мирамистин в привычном виде найти трудно, Диоксидина нет; нет и детской классики — зелёнки, фукорцина, каламина. Стандартные для Европы антисептики здесь есть: ',
			UnaGapsAntisepticsPovidone: 'повидон-йод',
			UnaGapsAntisepticsMid: ' (Betadine) и ',
			UnaGapsAntisepticsOctenidine: 'октенидин',
			UnaGapsAntisepticsEnd: ' (Octenisept).',
			UnaGapsAntihistaminesA:
				'Антигистаминные. Клемастина (Тавегил / Tavegil) и цетиризина (Зиртек / Zyrtec) в свободной продаже нет; левоцетиризин (Ксизал / Xyzal) обычно везут из Сербии. А вот действующее вещество Супрастина здесь есть: ',
			UnaGapsAntihistaminesChloropyramine: 'хлоропирамин',
			UnaGapsAntihistaminesMid: ' продаётся как ',
			UnaGapsAntihistaminesSynopen: 'Synopen',
			UnaGapsAntihistaminesMid2:
				' (инъекции и гель). Из таблетированных H1-блокаторов в наличии ',
			UnaGapsAntihistaminesLink1: 'лоратадин',
			UnaGapsAntihistaminesLink2: 'дезлоратадин',
			UnaGapsAntihistaminesLink3: 'фексофенадин',
			UnaGapsAntihistaminesEnd:
				'. Капель для приёма внутрь почти нет — в основном таблетки и сиропы. Действующее вещество Фенистила, ',
			UnaGapsAntihistaminesDimetindene: 'диметинден',
			UnaGapsAntihistaminesDimMid: ', зарегистрировано, но только как гель — ',
			UnaGapsAntihistaminesFlenty: 'Flenty',
			UnaGapsAntihistaminesTail: '; привычных капель для приёма внутрь нет.',
			UnaGapsRehydration:
				'Средства для регидратации. Аптечного Регидрона нет. Спортивные саше с электролитами продаются, но многие с сахаром, что при кишечной инфекции нежелательно — проверяйте состав.',
			UnaGapsAnalgesicsA:
				'Комбинированные анальгетики. Привычных безрецептурных комбинаций в таблетках, как Пенталгин, по сути нет; многокомпонентное здесь — в основном простудные средства, аналоги Колдрекса: ',
			UnaGapsAnalgesicsCaffetin: 'Caffetin Cold',
			UnaGapsAnalgesicsMid: ', ',
			UnaGapsAnalgesicsTylolHot: 'Tylol Hot',
			UnaGapsAnalgesicsMid2: ' и подобные. Отдельные обезболивающие — ',
			UnaGapsAnalgesicsLink1: 'парацетамол',
			UnaGapsAnalgesicsLink2: 'ибупрофен',
			UnaGapsAnalgesicsEnd: ' — продаются свободно.',
			UnaGapsSpasmoA:
				'Спазмолитики. Дротаверина (Но-шпа / No-Spa) и папаверина в свободной продаже нет. Из спазмолитиков для ЖКТ в аптеках есть, например, ',
			UnaGapsSpasmoMebeverine: 'мебеверин',
			UnaGapsSpasmoEnd:
				' — но чем заменить в вашем случае, подскажет фармацевт.',
			UnaGapsMisc:
				'Точечные позиции. По отзывам, не найти Доктор МОМ, Каметон, Валидол, Гептрал (адеметионин), Панангин и Аспаркам (аспарагинат калия и магния); сибутрамина нет ни под каким названием.',
			UnaGaps2:
				'Проверить, зарегистрирован ли конкретный препарат в Черногории и как он отпускается, можно в нашем ',
			UnaGaps2Link: 'реестре лекарств',
			UnaGaps2End: '.',

			UnaAntivirals1:
				'Отдельная история — противовирусные и иммуномодуляторы, привычные в России и Украине: Виферон, Арбидол, Циклоферон, Кагоцел, Полиоксидоний, Цитовир, Эргоферон. В Черногории их нет, и это не локальный дефицит: этот класс препаратов практически не применяется за пределами России и стран СНГ и в европейскую медицинскую практику не входит. Искать здесь аналог, чтобы поднять иммунитет при простуде, бесполезно — его просто нет в местной номенклатуре. Нет и отдельных противовирусных для профилактики у детей.',
			UnaAntivirals2:
				'Это не значит, что вирусные инфекции нечем лечить: против конкретных возбудителей есть препараты с доказанной эффективностью, и врач назначает их по показаниям и по рецепту — но это точечное лечение, а не курс для профилактики.',
			UnaAntivirals3a:
				'Похожая история — ноотропы и метаболические средства из привычного набора: Актовегин, Мексидол, Церебролизин, Фенибут, Милдронат (мельдоний). В Черногории их нет по той же причине: доказательная база не признана в европейской практике. Отдельные сосудистые препараты всё же есть — например, ',
			UnaAntivirals3Vinpocetine: 'винпоцетин',
			UnaAntivirals3Mid: ' или ',
			UnaAntivirals3Cinnarizine: 'циннаризин',
			UnaAntivirals3End: '.',

			'UnaToc_glp1': 'Диабет и уколы для похудения',
			UnaGlp1a:
				'Отдельная тема — агонисты ГПП-1, которые в России и Украине массово колют для похудения. Семаглутид (в России — Семавик, Велгия, Квинсента) в Черногории есть: зарегистрированы ',
			UnaGlp1Ozempic: 'Ozempic',
			UnaGlp1Mid: ' (при диабете 2 типа) и ',
			UnaGlp1Wegovy: 'Wegovy',
			UnaGlp1End:
				' (для снижения веса) — оба в виде инъекций и строго по рецепту. Тирзепатид (в России — Седжаро и Тирзетта, в мире — Mounjaro) в местном реестре пока не значится.',
			UnaGlp12:
				'Это серьёзные рецептурные препараты с противопоказаниями и побочными эффектами: их назначает врач по показаниям (диабет, ожирение) и постепенно подбирает дозу — колоть их ради быстрого похудения без наблюдения не стоит. Стоит учесть и перебои: семаглутид периодически пропадает из аптек по всему миру.',
			UnaGlp13a:
				'С самим диабетом проблем нет: доступны инсулины (современные аналоги) и таблетированные препараты — ',
			UnaGlp13Metformin: 'метформин',
			UnaGlp13Mid: ', ',
			UnaGlp13Dapagliflozin: 'дапаглифлозин',
			UnaGlp13End:
				' (Форсига / Forxiga), эмпаглифлозин (Джардинс / Jardiance), глиптины. Со здравственной книжицей препараты из списка Фонда почти бесплатны, без неё — за свой счёт, но в продаже они есть.',

			UnaImport1:
				'Что-то из недостающего хочется довезти из дома — и здесь есть юридический нюанс. Корвалол и Валокордин содержат фенобарбитал, а он во многих странах относится к контролируемым веществам: ввоз таких препаратов может быть ограничен или запрещён, даже если дома они продаются свободно. То же касается сильнодействующих обезболивающих и психотропных средств.',
			UnaImport2:
				'Общее правило: перед поездкой проверьте таможенные правила Черногории и страны транзита. Лекарства для личного применения обычно разрешено ввозить в разумном количестве, в оригинальной упаковке и с рецептом или заключением врача, где указаны действующее вещество и дозировка. На спорные препараты лучше иметь документальное подтверждение назначения — или не ввозить их вовсе.',

			UnaAccess1:
				'Часто дело не в том, что вещества нет, а в том, что его не продадут без рецепта. Антибиотики, снотворные, антидепрессанты и большинство рецептурных препаратов в Черногории без рецепта не отпускают. При этом иностранный рецепт — российский, украинский, любой — в местной аптеке недействителен: нужен местный. В частной клинике это обычно бумажный рецепт с печатью и подписью врача; электронный (eRecept) в основном используют для получения лекарств по линии Фонда.',
			UnaAccess2:
				'Поэтому привычную схему приходится перестраивать: получить местный рецепт у врача по действующему веществу, а если препарат в Черногории не зарегистрирован — искать в соседних Сербии или Боснии, где ассортимент шире, либо заказывать через аптеку. Как устроены рецепты, списки Фонда и поиск аналогов, подробно разбираем в статье ',
			UnaAccess2Link: 'об аптеках и лекарствах в Черногории',
			UnaAccess2End: '.',

			UnaSources0:
				'Обзор основан на опыте русскоязычных сообществ Черногории (2023–2026) и актуален на июль 2026 года. Наличие и правила меняются; материал справочный и не заменяет консультацию врача или фармацевта. Проверяйте по первоисточникам:',
			UnaSourcesCinmed:
				'CInMED — Институт лекарств и медицинских изделий Черногории, официальный реестр зарегистрированных препаратов: cinmed.me;',
			UnaSourcesFzo:
				'FZOCG — списки лекарств Фонда медицинского страхования: fzocg.me.',
			UnaSourcesDoctors:
				'Нужен врач, который подберёт терапию и выпишет местный рецепт? В нашем каталоге указаны языки приёма — ',
			UnaSourcesDoctorsLink: 'найдите врача, говорящего на вашем языке',
			UnaSourcesDoctorsEnd: '.',

			UnaCtaTitle: 'Ищете конкретный препарат?',
			UnaCtaText:
				'Проверьте, зарегистрирован ли он в Черногории и как отпускается, в нашем каталоге.',
			UnaCtaButton: 'Каталог лекарств',
		},
		'sr': {
			UnaTitle: 'Ljekovi koje nećete naći u Crnoj Gori: vaša uobičajena kućna apoteka',
			UnaDescription:
				'Enterosgel, so za rehidrataciju, cetirizine, Miramistin, Suprastin, Corvalol — koji se ljekovi iz ruske ili ukrajinske kućne apoteke ne mogu naći u Crnoj Gori, zašto, kako tražiti zamjenu po aktivnoj supstanci i šta imati u vidu pri unosu ljekova od kuće. Važi za jul 2026.',

			'UnaToc_why': 'Zašto uobičajena apoteka ovdje nije dovoljna',
			'UnaToc_gaps': 'Čega zaista nema i kako tražiti zamjenu',
			'UnaToc_antivirals': 'Antivirotici i imunomodulatori: prekid tradicije',
			'UnaToc_import': 'Šta je rizično ili zabranjeno unositi',
			'UnaToc_access': 'Nije stvar samo u supstanci: recepti i dostupnost',
			'UnaToc_sources': 'Napomene i izvori',

			UnaWhy1:
				'Jedna od prvih stvari koju ljudi primijete nakon preseljenja u Crnu Goru jeste da kućnu apoteku na koju su navikli ovdje jednostavno ne mogu ponovo sastaviti: polovine poznatih naziva nema u prodaji. Nije riječ o nestašici — crnogorsko tržište prati evropski i balkanski formular, koji se osjetno razlikuje od ruskog i ukrajinskog. Dio ljekova uobičajenih u bivšem SSSR-u ovdje nikada nije ni registrovan, a dio pripada tradicijama liječenja koje evropska medicina uopšte ne dijeli.',
			UnaWhy2:
				'U nastavku je ono što ljudi iz tih zemalja najčešće traže i ne nalaze, na osnovu iskustva ruskogovorećih zajednica u Crnoj Gori. Ovo je pregled onoga što ima na policama, a ne propisivanje terapije: izbor zamjene i doze posao je ljekara ili farmaceuta.',

			UnaGaps1:
				'Najjednostavnije je lijek tražiti po internacionalnom nezaštićenom nazivu (INN), a ne po poznatom brendu: po njemu će farmaceut pronaći ono što je registrovano u zemlji. Ipak, za dio uobičajenih sredstava direktnog ekvivalenta po aktivnoj supstanci u slobodnoj prodaji uopšte nema:',
			UnaGapsSorbents:
				'Sorbenti. Enterosgela i Polisorba nema u prodaji — često se traži da ih neko donese od kuće. Od crijevnih sorbenata u apotekama se slobodno prodaje ',
			UnaGapsSorbentsLink: 'aktivni ugalj',
			UnaGapsSorbentsEnd: '.',
			UnaGapsAntisepticsA:
				'Antiseptici za rane. Hlorheksidin i Miramistin u poznatom obliku teško je naći, a dioksidina nema; nema ni dječje klasike — brilijantnog zelenila (zelenka), fukorcina, kalamina. Standardni evropski antiseptici ovdje postoje: ',
			UnaGapsAntisepticsPovidone: 'povidon-jod',
			UnaGapsAntisepticsMid: ' (Betadine) i ',
			UnaGapsAntisepticsOctenidine: 'oktenidin',
			UnaGapsAntisepticsEnd: ' (Octenisept).',
			UnaGapsAntihistaminesA:
				'Antihistaminici. Tavegila (clemastine) nema, nema ni cetirizina (Zyrtec) — levocetirizin (Xyzal) obično se donosi iz Srbije. Ali aktivna supstanca Suprastina ovdje postoji: ',
			UnaGapsAntihistaminesChloropyramine: 'chloropyramine',
			UnaGapsAntihistaminesMid: ' se prodaje kao ',
			UnaGapsAntihistaminesSynopen: 'Synopen',
			UnaGapsAntihistaminesMid2:
				' (injekcije i gel). Od tabletnih H1-blokatora u apotekama ima ',
			UnaGapsAntihistaminesLink1: 'loratadin',
			UnaGapsAntihistaminesLink2: 'desloratadin',
			UnaGapsAntihistaminesLink3: 'feksofenadin',
			UnaGapsAntihistaminesEnd:
				'. Kapi za oralnu upotrebu gotovo da nema — uglavnom tablete i sirupi. Aktivna supstanca Fenistila, ',
			UnaGapsAntihistaminesDimetindene: 'dimetinden',
			UnaGapsAntihistaminesDimMid: ', registrovana je, ali samo kao gel — ',
			UnaGapsAntihistaminesFlenty: 'Flenty',
			UnaGapsAntihistaminesTail: '; uobičajenih kapi za oralnu upotrebu nema.',
			UnaGapsRehydration:
				'Sredstva za rehidrataciju. Apotekarskog praška za rehidrataciju (Regidron) nema. Sportske kesice sa elektrolitima se prodaju, ali mnoge sadrže šećer, što kod crijevne infekcije nije poželjno — provjerite sastav.',
			UnaGapsAnalgesicsA:
				'Kombinovani analgetici. Uobičajenih bezreceptnih kombinacija u tabletama poput Pentalgina praktično nema; višekomponentni preparati su ovdje uglavnom sredstva protiv prehlade, tipa Coldrex: ',
			UnaGapsAnalgesicsCaffetin: 'Caffetin Cold',
			UnaGapsAnalgesicsMid: ', ',
			UnaGapsAnalgesicsTylolHot: 'Tylol Hot',
			UnaGapsAnalgesicsMid2: ' i slično. Od analgetika, pojedinačne supstance — ',
			UnaGapsAnalgesicsLink1: 'paracetamol',
			UnaGapsAnalgesicsLink2: 'ibuprofen',
			UnaGapsAnalgesicsEnd: ' — prodaju se slobodno.',
			UnaGapsSpasmoA:
				'Spazmolitici. No-Spa (drotaverin) i papaverin se ne prodaju. Od spazmolitika za probavu u apotekama ima, na primjer, ',
			UnaGapsSpasmoMebeverine: 'mebeverin',
			UnaGapsSpasmoEnd:
				' — ali šta odgovara u vašem slučaju, savjetovaće farmaceut.',
			UnaGapsMisc:
				'Pojedinačne pozicije. Po iskustvima zajednice, nećete naći Doctor MOM, Kameton, Validol, Heptral (ademetionin), Panangin ni Asparkam (aspartat kalijuma i magnezijuma); sibutramine se ne prodaje ni pod jednim imenom.',
			UnaGaps2:
				'Da li je konkretan lijek registrovan u Crnoj Gori i kako se izdaje, možete provjeriti u našem ',
			UnaGaps2Link: 'registru ljekova',
			UnaGaps2End: '.',

			UnaAntivirals1:
				'Posebna priča su antivirotici i imunomodulatori uobičajeni u Rusiji i Ukrajini: Viferon, Arbidol, Cycloferon, Kagocel, Polyoxidonium, Citovir, Ergoferon. U Crnoj Gori ih nema, i to nije lokalna nestašica: ova klasa ljekova praktično se ne koristi izvan Rusije i zemalja bivšeg SSSR-a i nije dio evropske medicinske prakse. Tražiti ovdje nešto za jačanje imuniteta tokom prehlade nema smisla — toga jednostavno nema u lokalnom asortimanu. Nema ni posebnih antivirotika za prevenciju kod djece.',
			UnaAntivirals2:
				'To ne znači da se virusne infekcije ne mogu liječiti: protiv konkretnih uzročnika postoje ljekovi sa dokazanom djelotvornošću, koje ljekar propisuje po indikaciji — ali to je ciljano liječenje, a ne preventivna kura.',
			UnaAntivirals3a:
				'Slična priča su nootropici i metabolički preparati iz uobičajenog postsovjetskog kompleta: Actovegin, Mexidol, Cerebrolysin, Phenibut, Meldonium. U Crnoj Gori ih nema, iz istog razloga — dokazna osnova nije priznata u evropskoj praksi. Poneki vaskularni preparat ipak postoji — na primjer ',
			UnaAntivirals3Vinpocetine: 'vinpocetin',
			UnaAntivirals3Mid: ' ili ',
			UnaAntivirals3Cinnarizine: 'cinarizin',
			UnaAntivirals3End: '.',

			'UnaToc_glp1': 'Dijabetes i injekcije za mršavljenje',
			UnaGlp1a:
				'Posebna tema su agonisti GLP-1 (semaglutid, tirzepatid), koje u Rusiji i Ukrajini masovno ubrizgavaju radi mršavljenja. Semaglutid u Crnoj Gori postoji: registrovani su ',
			UnaGlp1Ozempic: 'Ozempic',
			UnaGlp1Mid: ' (za dijabetes tipa 2) i ',
			UnaGlp1Wegovy: 'Wegovy',
			UnaGlp1End:
				' (za smanjenje tjelesne težine) — oba u obliku injekcija i strogo na recept. Tirzepatid (Mounjaro) za sada nije u lokalnom registru.',
			UnaGlp12:
				'To su ozbiljni ljekovi na recept sa kontraindikacijama i neželjenim dejstvima: propisuje ih ljekar po indikaciji (dijabetes, gojaznost) i dozu podiže postepeno — nisu za ubrizgavanje radi brzog mršavljenja bez nadzora. Imajte u vidu i nestašice: semaglutid povremeno nestaje sa zaliha širom svijeta.',
			UnaGlp13a:
				'Sa samim dijabetesom nema problema: dostupni su savremeni analozi insulina i tabletni ljekovi — ',
			UnaGlp13Metformin: 'metformin',
			UnaGlp13Mid: ', ',
			UnaGlp13Dapagliflozin: 'dapagliflozin',
			UnaGlp13End:
				' (Forxiga), empagliflozin (Jardiance), gliptini. Uz zdravstvenu knjižicu ljekovi sa liste Fonda su gotovo besplatni; bez osiguranja plaćate sami, ali ih ima u prodaji.',

			UnaImport1:
				'Nešto od onoga čega nema poželjećete da donesete od kuće — i tu postoji pravni detalj. Corvalol i Valocordin sadrže phenobarbital, koji je u mnogim zemljama kontrolisana supstanca: unos takvih ljekova može biti ograničen ili zabranjen, čak i ako se kod kuće prodaju slobodno. Isto važi za jake analgetike i psihotropne ljekove.',
			UnaImport2:
				'Opšte pravilo: prije puta provjerite carinska pravila Crne Gore i svake zemlje tranzita. Ljekovi za ličnu upotrebu obično su dozvoljeni u razumnim količinama, u originalnom pakovanju i uz recept ili izvještaj ljekara u kojem su navedeni aktivna supstanca i doza. Za sporne ljekove bolje je nositi dokumentovanu potvrdu o propisanoj terapiji — ili ih uopšte ne unositi.',

			UnaAccess1:
				'Često problem nije u tome što supstance nema, nego što vam je neće prodati bez recepta. Antibiotici, tablete za spavanje, antidepresivi i većina ljekova na recept u Crnoj Gori se ne izdaju bez recepta. Pri tome strani recept — ruski, ukrajinski, bilo koji — u lokalnoj apoteci ne važi: potreban je domaći. U privatnoj klinici to je obično papirni recept sa pečatom i potpisom ljekara; elektronski recept (eRecept) uglavnom se koristi za izdavanje ljekova o trošku Fonda.',
			UnaAccess2:
				'Zato uobičajenu rutinu treba iznova posložiti: dobiti lokalni recept od ljekara po aktivnoj supstanci, a ako lijek nije registrovan u Crnoj Gori — potražiti ga u susjednoj Srbiji ili Bosni, gdje je asortiman širi, ili ga naručiti preko apoteke. Kako funkcionišu recepti, liste Fonda i traženje analoga, detaljno objašnjavamo u našem članku ',
			UnaAccess2Link: 'o apotekama i ljekovima u Crnoj Gori',
			UnaAccess2End: '.',

			UnaSources0:
				'Ovaj pregled se oslanja na iskustvo ruskogovorećih zajednica u Crnoj Gori (2023–2026) i važi za jul 2026. Dostupnost i pravila se mijenjaju; materijal je informativan i ne zamjenjuje konsultaciju sa ljekarom ili farmaceutom. Provjerite u primarnim izvorima:',
			UnaSourcesCinmed:
				'CInMED — Institut za ljekove i medicinska sredstva Crne Gore, zvanični registar odobrenih ljekova: cinmed.me;',
			UnaSourcesFzo: 'FZOCG — liste ljekova Fonda za zdravstveno osiguranje: fzocg.me.',
			UnaSourcesDoctors:
				'Treba vam ljekar koji će posložiti vašu terapiju i izdati lokalni recept? U našem katalogu naznačeni su jezici koje svaki doktor govori — ',
			UnaSourcesDoctorsLink: 'pronađite doktora koji govori vaš jezik',
			UnaSourcesDoctorsEnd: '.',

			UnaCtaTitle: 'Tražite određeni lijek?',
			UnaCtaText:
				'Provjerite da li je registrovan u Crnoj Gori i kako se izdaje u našem katalogu.',
			UnaCtaButton: 'Katalog ljekova',
		},
		'sr-cyrl': {
			UnaTitle: 'Љекови које нећете наћи у Црној Гори: ваша уобичајена кућна апотека',
			UnaDescription:
				'Enterosgel, соли за рехидратацију, цетиризин, Miramistin, Suprastin, Corvalol — шта од уобичајене кућне апотеке нећете наћи у Црној Гори, чиме се то објашњава, како тражити замјену по активној супстанци и шта имати у виду при уносу љекова из домовине. Важи за јул 2026.',

			'UnaToc_why': 'Зашто уобичајена апотека овдје није довољна',
			'UnaToc_gaps': 'Чега заиста нема и како тражити замјену',
			'UnaToc_antivirals': 'Противвирусни љекови и имуномодулатори: раскид с традицијом',
			'UnaToc_import': 'Шта је ризично или забрањено уносити',
			'UnaToc_access': 'Није ствар само у супстанци: рецепти и доступност',
			'UnaToc_sources': 'Ограде и извори',

			UnaWhy1:
				'Једна од првих ствари које људи примијете након селидбе у Црну Гору јесте да кућну апотеку на коју су навикли овдје једноставно не могу поново да саставе: половине познатих назива нема у продаји. Није ствар у несташици — црногорско тржиште прати европски и балкански формулар, а он се знатно разликује од руског и украјинског. Дио љекова уобичајених у бившем СССР-у овдје никада није ни регистрован, а дио припада традицијама лијечења којих у европској медицини уопште нема.',
			UnaWhy2:
				'У наставку је оно што људи из тих земаља најчешће траже и не налазе, према искуству рускоговорних заједница у Црној Гори. Ово је преглед онога што има на полицама, а не препорука терапије: избор замјене и дозу треба да одреди љекар или фармацеут.',

			UnaGaps1:
				'Најједноставније је лијек тражити по интернационалном незаштићеном називу (INN), а не по познатом бренду: по њему ће фармацеут наћи оно што је регистровано у земљи. Али за дио уобичајених средстава директног еквивалента по активној супстанци у слободној продаји уопште нема:',
			UnaGapsSorbents:
				'Сорбенти. Enterosgel и Polisorb се не продају — често моле да им их неко донесе. Од цријевних сорбената у апотекама слободно се продаје ',
			UnaGapsSorbentsLink: 'активни угаљ',
			UnaGapsSorbentsEnd: '.',
			UnaGapsAntisepticsA:
				'Антисептици за ране. Хлорхексидин и Miramistin у уобичајеном облику тешко се налазе, а диоксидина нема; нема ни дјечје класике — бриљантног зеленила, фукорцина, каламина. Стандардни европски антисептици овдје постоје: ',
			UnaGapsAntisepticsPovidone: 'повидон-јод',
			UnaGapsAntisepticsMid: ' (Betadine) и ',
			UnaGapsAntisepticsOctenidine: 'октенидин',
			UnaGapsAntisepticsEnd: ' (Octenisept).',
			UnaGapsAntihistaminesA:
				'Антихистаминици. Tavegil (клемастин) нема, нема ни цетиризина (Zyrtec) — левоцетиризин (Xyzal) обично се доноси из Србије. Али активна супстанца лијека Suprastin овдје постоји: ',
			UnaGapsAntihistaminesChloropyramine: 'хлоропирамин',
			UnaGapsAntihistaminesMid: ' се продаје као ',
			UnaGapsAntihistaminesSynopen: 'Synopen',
			UnaGapsAntihistaminesMid2:
				' (инјекције и гел). Од таблетних H1-блокатора у апотекама има ',
			UnaGapsAntihistaminesLink1: 'лоратадин',
			UnaGapsAntihistaminesLink2: 'дезлоратадин',
			UnaGapsAntihistaminesLink3: 'фексофенадин',
			UnaGapsAntihistaminesEnd:
				'. Капи за оралну употребу готово да нема — углавном таблете и сирупи. Активна супстанца Fenistila, ',
			UnaGapsAntihistaminesDimetindene: 'диметинден',
			UnaGapsAntihistaminesDimMid: ', регистрована је, али само као гел — ',
			UnaGapsAntihistaminesFlenty: 'Flenty',
			UnaGapsAntihistaminesTail: '; уобичајених капи за оралну употребу нема.',
			UnaGapsRehydration:
				'Средства за рехидратацију. Апотекарског праха за рехидратацију (Regidron) нема. Продају се спортске кесице са електролитима, али многе садрже шећер, што је код цријевне инфекције непожељно — провјерите састав.',
			UnaGapsAnalgesicsA:
				'Комбиновани аналгетици. Уобичајених безрецептних комбинација у таблетама попут Pentalgina практично нема; вишекомпонентни препарати су овдје углавном средства против прехладе, типа Coldrex: ',
			UnaGapsAnalgesicsCaffetin: 'Caffetin Cold',
			UnaGapsAnalgesicsMid: ', ',
			UnaGapsAnalgesicsTylolHot: 'Tylol Hot',
			UnaGapsAnalgesicsMid2: ' и слично. Од аналгетика, појединачне супстанце — ',
			UnaGapsAnalgesicsLink1: 'парацетамол',
			UnaGapsAnalgesicsLink2: 'ибупрофен',
			UnaGapsAnalgesicsEnd: ' — продају се слободно.',
			UnaGapsSpasmoA:
				'Спазмолитици. No-Spa (дротаверин) и папаверин се не продају. Од спазмолитика за пробаву у апотекама има, на примјер, ',
			UnaGapsSpasmoMebeverine: 'мебеверин',
			UnaGapsSpasmoEnd:
				' — али шта одговара у вашем случају, савјетоваће фармацеут.',
			UnaGapsMisc:
				'Појединачне позиције. По искуству заједница, нећете наћи Doctor MOM, Kameton, Validol, Heptral (адеметионин), Panangin ни Asparkam (аспартат калијума и магнезијума); сибутрамина нема ни под једним називом.',
			UnaGaps2:
				'Да ли је одређени лијек регистрован у Црној Гори и како се издаје, можете провјерити у нашем ',
			UnaGaps2Link: 'регистру љекова',
			UnaGaps2End: '.',

			UnaAntivirals1:
				'Посебна прича су противвирусни љекови и имуномодулатори познати у Русији и Украјини: Viferon, Arbidol, Cycloferon, Kagocel, Polyoxidonium, Citovir, Ergoferon. У Црној Гори их нема, и то није локална несташица: ова класа љекова се практично не користи изван Русије и земаља бившег СССР-а и не улази у европску медицинску праксу. Тражити овдје нешто за подизање имунитета током прехладе нема смисла — тога једноставно нема у локалној номенклатури. Нема ни посебних противвирусних љекова за превенцију код дјеце.',
			UnaAntivirals2:
				'То не значи да се вирусне инфекције немају чиме лијечити: против конкретних узрочника постоје љекови са доказаном ефикасношћу, које љекар прописује по индикацији — али то је циљано лијечење, а не превентивна кура.',
			UnaAntivirals3a:
				'Слична прича су ноотропици и метаболички препарати из уобичајеног постсовјетског комплета: Actovegin, Mexidol, Cerebrolysin, Phenibut, Meldonium. У Црној Гори их нема, из истог разлога — доказна основа није призната у европској пракси. Понеки васкуларни препарат ипак постоји — на примјер ',
			UnaAntivirals3Vinpocetine: 'винпоцетин',
			UnaAntivirals3Mid: ' или ',
			UnaAntivirals3Cinnarizine: 'цинаризин',
			UnaAntivirals3End: '.',

			'UnaToc_glp1': 'Дијабетес и ињекције за мршављење',
			UnaGlp1a:
				'Посебна тема су агонисти GLP-1 (семаглутид, тирзепатид), које у Русији и Украјини масовно убризгавају ради мршављења. Семаглутид у Црној Гори постоји: регистровани су ',
			UnaGlp1Ozempic: 'Ozempic',
			UnaGlp1Mid: ' (за дијабетес типа 2) и ',
			UnaGlp1Wegovy: 'Wegovy',
			UnaGlp1End:
				' (за смањење тјелесне тежине) — оба у облику ињекција и строго на рецепт. Тирзепатид (Mounjaro) за сада није у локалном регистру.',
			UnaGlp12:
				'То су озбиљни љекови на рецепт са контраиндикацијама и нежељеним дејствима: прописује их љекар по индикацији (дијабетес, гојазност) и дозу подиже постепено — нису за убризгавање ради брзог мршављења без надзора. Имајте у виду и несташице: семаглутид повремено нестаје са залиха широм свијета.',
			UnaGlp13a:
				'Са самим дијабетесом нема проблема: доступни су савремени аналози инсулина и таблетни љекови — ',
			UnaGlp13Metformin: 'метформин',
			UnaGlp13Mid: ', ',
			UnaGlp13Dapagliflozin: 'дапаглифлозин',
			UnaGlp13End:
				' (Forxiga), емпаглифлозин (Jardiance), глиптини. Уз здравствену књижицу љекови са листе Фонда су готово бесплатни; без осигурања плаћате сами, али их има у продаји.',

			UnaImport1:
				'Нешто од онога чега нема пожелите да довезете из домовине — и ту постоји правни детаљ. Corvalol и Valocordin садрже фенобарбитал, који је у многим земљама контролисана супстанца: увоз таквих љекова може бити ограничен или забрањен, чак и ако се код куће продају слободно. Исто важи за јаке аналгетике и психотропне љекове.',
			UnaImport2:
				'Опште правило: прије пута провјерите царинска правила Црне Горе и сваке земље транзита. Љекови за личну употребу обично се смију уносити у разумним количинама, у оригиналном паковању и уз рецепт или извјештај љекара у ком су наведени активна супстанца и доза. За спорне љекове боље је носити документовану потврду о прописаној терапији — или их уопште не уносити.',

			UnaAccess1:
				'Често проблем није у томе што супстанце нема, него у томе што вам је неће продати без рецепта. Антибиотици, таблете за спавање, антидепресиви и већина љекова на рецепт у Црној Гори се без рецепта не издају. При томе страни рецепт — руски, украјински, било који — у локалној апотеци не важи: потребан је домаћи. У приватној клиници то је обично папирни рецепт са печатом и потписом љекара; електронски рецепт (eRecept) углавном се користи за издавање љекова о трошку Фонда.',
			UnaAccess2:
				'Зато уобичајену рутину треба изнова поставити: добити локални рецепт од љекара по активној супстанци, а ако лијек није регистрован у Црној Гори — тражити у сусједној Србији или Босни, гдје је асортиман шири, или га наручити преко апотеке. Како функционишу рецепти, листе Фонда и потрага за аналозима, детаљно објашњавамо у нашем чланку ',
			UnaAccess2Link: 'о апотекама и љековима у Црној Гори',
			UnaAccess2End: '.',

			UnaSources0:
				'Овај преглед се заснива на искуству рускоговорних заједница у Црној Гори (2023–2026) и важи за јул 2026. Доступност и правила се мијењају; материјал је информативан и не замјењује консултацију са љекаром или фармацеутом. Провјерите у примарним изворима:',
			UnaSourcesCinmed:
				'CInMED — Институт за љекове и медицинска средства Црне Горе, званични регистар одобрених љекова: cinmed.me;',
			UnaSourcesFzo: 'ФЗОЦГ — листе љекова Фонда за здравствено осигурање: fzocg.me.',
			UnaSourcesDoctors:
				'Треба вам љекар који ће средити вашу терапију и издати локални рецепт? У нашем каталогу су наведени језици које доктори говоре — ',
			UnaSourcesDoctorsLink: 'пронађите доктора који говори ваш језик',
			UnaSourcesDoctorsEnd: '.',

			UnaCtaTitle: 'Тражите одређени лијек?',
			UnaCtaText:
				'Провјерите да ли је регистрован у Црној Гори и како се издаје, у нашем каталогу.',
			UnaCtaButton: 'Каталог љекова',
		},
		'de': {
			UnaTitle:
				'Medikamente, die Sie in Montenegro nicht finden: Ihre gewohnte Hausapotheke',
			UnaDescription:
				'Enterosgel, Rehydratationssalze, Cetirizin, Miramistin, Suprastin, Corvalol — welche Medikamente aus einer russischen oder ukrainischen Hausapotheke Sie in Montenegro nicht finden, warum das so ist, wie Sie über den Wirkstoff ein Pendant suchen und was Sie beim Mitbringen von Medikamenten von zu Hause beachten sollten. Stand: Juli 2026.',

			'UnaToc_why': 'Warum die gewohnte Hausapotheke hier nicht ausreicht',
			'UnaToc_gaps': 'Was wirklich fehlt und wie Sie ein Pendant finden',
			'UnaToc_antivirals': 'Antivirale Mittel und Immunmodulatoren: ein Traditionsbruch',
			'UnaToc_import': 'Was riskant oder verboten einzuführen ist',
			'UnaToc_access': 'Es geht nicht nur um den Wirkstoff: Rezepte und Zugang',
			'UnaToc_sources': 'Vorbehalte und Quellen',

			UnaWhy1:
				'Eines der ersten Dinge, die man nach dem Umzug nach Montenegro bemerkt, ist, dass sich die gewohnte Hausapotheke hier schlicht nicht zusammenstellen lässt: Die Hälfte der vertrauten Namen wird nicht verkauft. Es ist kein Versorgungsengpass — der montenegrinische Markt folgt dem europäischen und balkanischen Arzneiformular, das sich vom russischen und ukrainischen deutlich unterscheidet. Manche in der ehemaligen UdSSR verbreiteten Medikamente wurden hier nie zugelassen, andere gehören zu Behandlungstraditionen, die die europäische Medizin gar nicht teilt.',
			UnaWhy2:
				'Im Folgenden finden Sie, wonach Menschen aus diesen Ländern am häufigsten suchen und was sie nicht finden — nach den Erfahrungen der russischsprachigen Communitys in Montenegro. Es ist ein Überblick über das, was in den Regalen steht, keine Verordnung: Ein Pendant und dessen Dosierung auszuwählen, ist Sache eines Arztes oder Apothekers.',

			UnaGaps1:
				'Am einfachsten suchen Sie ein Medikament über den internationalen Freinamen (INN) statt über die vertraute Marke: Damit findet der Apotheker, was im Land zugelassen ist. Für einige vertraute Mittel gibt es allerdings gar kein rezeptfreies Pendant nach Wirkstoff:',
			UnaGapsSorbents:
				'Sorbentien. Enterosgel und Polisorb werden nicht verkauft — man bittet oft darum, sie mitzubringen. Von den Darmsorbentien ist in den Apotheken frei erhältlich: ',
			UnaGapsSorbentsLink: 'Aktivkohle',
			UnaGapsSorbentsEnd: '.',
			UnaGapsAntisepticsA:
				'Wundantiseptika. Chlorhexidin und Miramistin in ihrer gewohnten Form sind schwer zu finden, Dioxidin gibt es nicht; auch die Kinderklassiker fehlen — Brillantgrün (Zeljonka), Fukorzin, Calaminlotion. Die üblichen europäischen Antiseptika sind hier erhältlich: ',
			UnaGapsAntisepticsPovidone: 'Povidon-Iod',
			UnaGapsAntisepticsMid: ' (Betadine) und ',
			UnaGapsAntisepticsOctenidine: 'Octenidin',
			UnaGapsAntisepticsEnd: ' (Octenisept).',
			UnaGapsAntihistaminesA:
				'Antihistaminika. Tavegil (clemastine) gibt es nicht, Cetirizin (Zyrtec) ebenso wenig — Levocetirizin (Xyzal) wird meist aus Serbien mitgebracht. Der Wirkstoff von Suprastin ist hier aber erhältlich: ',
			UnaGapsAntihistaminesChloropyramine: 'chloropyramine',
			UnaGapsAntihistaminesMid: ' wird als ',
			UnaGapsAntihistaminesSynopen: 'Synopen',
			UnaGapsAntihistaminesMid2:
				' (Injektionen und ein Gel) verkauft. Von den Tabletten-H1-Blockern führen die Apotheken ',
			UnaGapsAntihistaminesLink1: 'Loratadin',
			UnaGapsAntihistaminesLink2: 'Desloratadin',
			UnaGapsAntihistaminesLink3: 'Fexofenadin',
			UnaGapsAntihistaminesEnd:
				'. Tropfen zum Einnehmen gibt es kaum — überwiegend Tabletten und Sirupe. Der Wirkstoff von Fenistil, ',
			UnaGapsAntihistaminesDimetindene: 'Dimetinden',
			UnaGapsAntihistaminesDimMid: ', ist zugelassen, aber nur als Gel — ',
			UnaGapsAntihistaminesFlenty: 'Flenty',
			UnaGapsAntihistaminesTail: '; die gewohnten Tropfen zum Einnehmen gibt es nicht.',
			UnaGapsRehydration:
				'Rehydratationssalze. Rehydratationspulver in Apothekenqualität (Regidron) gibt es nicht. Sportelektrolyte in Beuteln werden verkauft, viele enthalten aber Zucker, was bei einer Darminfektion unerwünscht ist — prüfen Sie die Zusammensetzung.',
			UnaGapsAnalgesicsA:
				'Kombinierte Analgetika. Gewohnte rezeptfreie Kombinationstabletten wie Pentalgin gibt es praktisch nicht; mehrkomponentige Präparate sind hier vor allem Erkältungsmittel im Coldrex-Stil: ',
			UnaGapsAnalgesicsCaffetin: 'Caffetin Cold',
			UnaGapsAnalgesicsMid: ', ',
			UnaGapsAnalgesicsTylolHot: 'Tylol Hot',
			UnaGapsAnalgesicsMid2:
				' und Ähnliches. An Schmerzmitteln sind die einzelnen Wirkstoffe — ',
			UnaGapsAnalgesicsLink1: 'Paracetamol',
			UnaGapsAnalgesicsLink2: 'Ibuprofen',
			UnaGapsAnalgesicsEnd: ' — frei verkäuflich.',
			UnaGapsSpasmoA:
				'Spasmolytika. No-Spa (Drotaverin) und Papaverin werden nicht verkauft. Von den Magen-Darm-Spasmolytika führen die Apotheken etwa ',
			UnaGapsSpasmoMebeverine: 'Mebeverin',
			UnaGapsSpasmoEnd:
				' — was in Ihrem Fall passt, sagt Ihnen der Apotheker.',
			UnaGapsMisc:
				'Einzelne Positionen. Nach Berichten aus den Communitys finden Sie weder Doctor MOM, Kameton, Validol, Heptral (Ademetionin) noch Panangin oder Asparkam (Kalium- und Magnesiumaspartat); Sibutramin wird unter keinem Namen verkauft.',
			UnaGaps2:
				'Ob ein bestimmtes Medikament in Montenegro zugelassen ist und wie es abgegeben wird, können Sie in unserem ',
			UnaGaps2Link: 'Arzneimittelregister',
			UnaGaps2End: ' prüfen.',

			UnaAntivirals1:
				'Eine eigene Geschichte sind die in Russland und der Ukraine vertrauten antiviralen Mittel und Immunmodulatoren: Viferon, Arbidol, Cycloferon, Kagocel, Polyoxidonium, Citovir, Ergoferon. In Montenegro gibt es sie nicht, und das ist kein lokaler Engpass: Diese Wirkstoffklasse wird außerhalb Russlands und der ehemaligen UdSSR praktisch nicht verwendet und ist nicht Teil der europäischen medizinischen Praxis. Hier nach etwas zu suchen, das bei einer Erkältung die Immunabwehr stärkt, ist zwecklos — im lokalen Sortiment gibt es das schlicht nicht. Auch gesonderte antivirale Mittel zur Vorbeugung für Kinder gibt es nicht.',
			UnaAntivirals2:
				'Das heißt nicht, dass Virusinfektionen nicht behandelbar wären: Gegen bestimmte Erreger gibt es Medikamente mit nachgewiesener Wirksamkeit, die ein Arzt nach Indikation verordnet — aber das ist eine gezielte Behandlung, keine vorbeugende Kur.',
			UnaAntivirals3a:
				'Eine ähnliche Geschichte sind die Nootropika und Stoffwechselmittel aus dem gewohnten postsowjetischen Sortiment: Actovegin, Mexidol, Cerebrolysin, Phenibut, Meldonium. In Montenegro gibt es sie nicht, aus demselben Grund — keine in der europäischen Praxis anerkannte Evidenz. Einzelne Gefäßmittel gibt es allerdings — etwa ',
			UnaAntivirals3Vinpocetine: 'Vinpocetin',
			UnaAntivirals3Mid: ' oder ',
			UnaAntivirals3Cinnarizine: 'Cinnarizin',
			UnaAntivirals3End: '.',

			'UnaToc_glp1': 'Diabetes und Abnehmspritzen',
			UnaGlp1a:
				'Ein eigenes Thema sind die GLP-1-Agonisten (Semaglutid, Tirzepatid), die in Russland und der Ukraine inzwischen massenhaft zum Abnehmen gespritzt werden. Semaglutid ist in Montenegro erhältlich: Zugelassen sind ',
			UnaGlp1Ozempic: 'Ozempic',
			UnaGlp1Mid: ' (bei Typ-2-Diabetes) und ',
			UnaGlp1Wegovy: 'Wegovy',
			UnaGlp1End:
				' (zur Gewichtsreduktion) — beide als Injektion und streng verschreibungspflichtig. Tirzepatid (Mounjaro) ist im lokalen Register bislang nicht geführt.',
			UnaGlp12:
				'Das sind ernsthafte verschreibungspflichtige Medikamente mit Gegenanzeigen und Nebenwirkungen: Ein Arzt verordnet sie nach Indikation (Diabetes, Adipositas) und steigert die Dosis schrittweise — nichts, was man ohne Aufsicht zum schnellen Abnehmen spritzt. Rechnen Sie auch mit Lieferengpässen: Semaglutid ist weltweit immer wieder vergriffen.',
			UnaGlp13a:
				'Mit dem Diabetes selbst gibt es keine Probleme: Moderne Insulinanaloga sind verfügbar, dazu orale Medikamente — ',
			UnaGlp13Metformin: 'Metformin',
			UnaGlp13Mid: ', ',
			UnaGlp13Dapagliflozin: 'Dapagliflozin',
			UnaGlp13End:
				' (Forxiga), Empagliflozin (Jardiance), Gliptine. Mit knjižica sind Medikamente von der Fondsliste fast kostenlos; ohne Versicherung zahlen Sie selbst, erhältlich sind sie aber.',
			UnaImport1:
				'Manches von dem, was fehlt, möchten Sie vielleicht von zu Hause mitbringen — und hier gibt es einen rechtlichen Haken. Corvalol und Valocordin enthalten Phenobarbital, das in vielen Ländern als kontrollierte Substanz gilt: Die Einfuhr solcher Medikamente kann eingeschränkt oder verboten sein, selbst wenn sie zu Hause frei verkauft werden. Dasselbe gilt für starke Schmerzmittel und Psychopharmaka.',
			UnaImport2:
				'Als Faustregel gilt: Prüfen Sie vor der Reise die Zollvorschriften Montenegros und jedes Transitlandes. Medikamente für den Eigenbedarf dürfen in der Regel in angemessener Menge eingeführt werden, in der Originalverpackung und mit Rezept oder einem Arztbericht, der Wirkstoff und Dosierung nennt. Für Grenzfälle führen Sie besser einen Verordnungsnachweis mit — oder bringen sie gar nicht erst mit.',

			UnaAccess1:
				'Oft liegt das Problem nicht darin, dass der Wirkstoff fehlt, sondern darin, dass er Ihnen ohne Rezept nicht verkauft wird. Antibiotika, Schlafmittel, Antidepressiva und die meisten verschreibungspflichtigen Medikamente werden in Montenegro nicht rezeptfrei abgegeben. Und ein ausländisches Rezept — ein russisches, ukrainisches, egal welches — gilt in einer lokalen Apotheke nicht: Sie brauchen ein einheimisches. In einer Privatklinik ist das meist ein Papierrezept mit Stempel und Unterschrift des Arztes; das elektronische Rezept (eRecept) wird vor allem für die Abgabe zulasten des Fonds genutzt.',
			UnaAccess2:
				'Deshalb müssen Sie die gewohnte Routine umstellen: sich vom Arzt ein lokales Rezept nach Wirkstoff ausstellen lassen und, falls das Medikament in Montenegro nicht zugelassen ist, im benachbarten Serbien oder Bosnien suchen, wo das Sortiment größer ist, oder es über eine Apotheke bestellen. Wie Rezepte, die Fondslisten und die Suche nach Pendants funktionieren, erläutern wir ausführlich in unserem Artikel ',
			UnaAccess2Link: 'über Apotheken und Medikamente in Montenegro',
			UnaAccess2End: '.',

			UnaSources0:
				'Dieser Überblick beruht auf den Erfahrungen der russischsprachigen Communitys in Montenegro (2023–2026) und hat den Stand Juli 2026. Verfügbarkeit und Regeln ändern sich; das Material dient der Orientierung und ersetzt nicht die Beratung durch einen Arzt oder Apotheker. Prüfen Sie anhand der Primärquellen:',
			UnaSourcesCinmed:
				'CInMED — das Institut für Arzneimittel und Medizinprodukte Montenegros, das offizielle Register zugelassener Präparate: cinmed.me;',
			UnaSourcesFzo:
				'FZOCG — die Medikamentenlisten des Krankenversicherungsfonds: fzocg.me.',
			UnaSourcesDoctors:
				'Brauchen Sie einen Arzt, der Ihre Therapie klärt und ein lokales Rezept ausstellt? In unserem Katalog sind die Sprachen der Ärzte angegeben — ',
			UnaSourcesDoctorsLink: 'finden Sie einen Arzt, der Ihre Sprache spricht',
			UnaSourcesDoctorsEnd: '.',

			UnaCtaTitle: 'Suchen Sie ein bestimmtes Medikament?',
			UnaCtaText:
				'Prüfen Sie in unserem Katalog, ob es in Montenegro zugelassen ist und wie es abgegeben wird.',
			UnaCtaButton: 'Medikamentenkatalog',
		},
		'tr': {
			UnaTitle: "Karadağ'da bulamayacağınız ilaçlar: alıştığınız evdeki ilaç dolabı",
			UnaDescription:
				"Enterosgel, rehidrasyon tuzları, setirizin, miramistin, suprastin, corvalol — Rus veya Ukrayna evindeki ilaç dolabından hangi ilaçları Karadağ'da bulamayacağınız, bunun nedeni, etken maddeye göre nasıl muadil aranacağı ve ilaçları ülkenizden getirirken nelere dikkat edilmesi gerektiği. Temmuz 2026 itibarıyla günceldir.",

			'UnaToc_why': 'Alışık olduğunuz ilaç dolabı burada neden yetersiz kalıyor',
			'UnaToc_gaps': 'Gerçekte neyin eksik olduğu ve muadilin nasıl bulunacağı',
			'UnaToc_antivirals': 'Antiviraller ve immünomodülatörler: gelenekten kopuş',
			'UnaToc_import': 'Ülkeye sokması riskli veya yasak olanlar',
			'UnaToc_access': 'Mesele yalnızca etken madde değil: reçeteler ve erişim',
			'UnaToc_sources': 'Çekinceler ve kaynaklar',

			UnaWhy1:
				"Karadağ'a taşındıktan sonra insanların ilk fark ettiği şeylerden biri, alıştıkları evdeki ilaç dolabını burada bir araya getiremeyecekleridir: tanıdık isimlerin yarısı satılmıyor. Bu bir kıtlık değil — Karadağ pazarı, Rusya ve Ukrayna'dakinden belirgin biçimde farklı olan Avrupa ve Balkan formülerini izler. Eski SSCB'de yaygın olan bazı ilaçlar burada hiç ruhsatlandırılmadı, bir kısmı ise Avrupa tıbbının hiç paylaşmadığı tedavi geleneklerine ait.",
			UnaWhy2:
				"Aşağıda, Karadağ'ın Rusça konuşan topluluklarının deneyimine dayanarak, bu ülkelerden gelenlerin en sık aradığı ve bulamadığı şeyler var. Bu, raflarda ne olduğunun bir özetidir, bir tedavi önerisi değil: muadili ve dozunu seçmek doktorun veya eczacının işidir.",

			UnaGaps1:
				'En basit yol, ilacı tanıdık markasıyla değil uluslararası mülkiyetsiz adıyla (INN) aramaktır: bununla eczacı, ülkede ruhsatlı olan neyse onu bulur. Yine de bazı tanıdık ilaçların etken maddeye göre reçetesiz bir karşılığı hiç yoktur:',
			UnaGapsSorbents:
				'Sorbentler. Enterosgel ve Polisorb satılmıyor — sık sık başkalarından getirmeleri istenir. Bağırsak sorbentlerinden ',
			UnaGapsSorbentsLink: 'aktif kömür',
			UnaGapsSorbentsEnd: ' eczanelerde serbestçe bulunur.',
			UnaGapsAntisepticsA:
				'Yara antiseptikleri. Klorheksidin ve miramistin bilinen biçimiyle zor bulunur, dioksidin ise yoktur; çocukluğun klasikleri de eksik — briyantin yeşili (zelyonka), fukorsin, kalamin. Standart Avrupa antiseptikleri ise burada var: ',
			UnaGapsAntisepticsPovidone: 'povidon iyot',
			UnaGapsAntisepticsMid: ' (Betadine) ve ',
			UnaGapsAntisepticsOctenidine: 'oktenidin',
			UnaGapsAntisepticsEnd: ' (Octenisept).',
			UnaGapsAntihistaminesA:
				'Antihistaminikler. Tavegil (klemastin) yoktur, setirizin (Zyrtec) de yoktur — levosetirizin (Xyzal) genellikle Sırbistan\'dan getirilir. Ama Suprastin\'in etken maddesi ',
			UnaGapsAntihistaminesChloropyramine: 'kloropiramin',
			UnaGapsAntihistaminesMid: ' burada ',
			UnaGapsAntihistaminesSynopen: 'Synopen',
			UnaGapsAntihistaminesMid2:
				' adıyla bulunur (enjeksiyon ve jel). Tablet H1 blokerlerinden eczanelerde ',
			UnaGapsAntihistaminesLink1: 'loratadin',
			UnaGapsAntihistaminesLink2: 'desloratadin',
			UnaGapsAntihistaminesLink3: 'feksofenadin',
			UnaGapsAntihistaminesEnd:
				' bulunur. Ağızdan alınan damla neredeyse yoktur — çoğunlukla tablet ve şurup. Fenistil’in etken maddesi ',
			UnaGapsAntihistaminesDimetindene: 'dimetinden',
			UnaGapsAntihistaminesDimMid: ' kayıtlıdır, ama yalnızca jel olarak — ',
			UnaGapsAntihistaminesFlenty: 'Flenty',
			UnaGapsAntihistaminesTail: '; alışılmış ağızdan damla ise bulunmaz.',
			UnaGapsRehydration:
				'Rehidrasyon tuzları. Eczane tipi rehidrasyon tozu (Regidron) bulunmaz. Sporcular için elektrolit saşeleri satılır, ama çoğu şeker içerir ve bu, bağırsak enfeksiyonu sırasında istenmez — içeriği kontrol edin.',
			UnaGapsAnalgesicsA:
				'Kombine ağrı kesiciler. Pentalgin gibi alışılmış reçetesiz kombinasyon tabletleri neredeyse yok; buradaki çok bileşenli ürünler daha çok Coldrex tipi soğuk algınlığı ilaçları: ',
			UnaGapsAnalgesicsCaffetin: 'Caffetin Cold',
			UnaGapsAnalgesicsMid: ', ',
			UnaGapsAnalgesicsTylolHot: 'Tylol Hot',
			UnaGapsAnalgesicsMid2:
				' ve benzerleri. Ağrı kesici olarak tek tek etken maddeler — ',
			UnaGapsAnalgesicsLink1: 'parasetamol',
			UnaGapsAnalgesicsLink2: 'ibuprofen',
			UnaGapsAnalgesicsEnd: ' — serbestçe satılır.',
			UnaGapsSpasmoA:
				'Antispazmodikler. No-Spa (drotaverin) ve papaverin satılmaz. Sindirim sistemi antispazmodiklerinden eczanelerde örneğin ',
			UnaGapsSpasmoMebeverine: 'mebeverin',
			UnaGapsSpasmoEnd:
				' bulunur — ama sizin durumunuza ne uyar, eczacı söyler.',
			UnaGapsMisc:
				'Tekil ürünler. Topluluk paylaşımlarına göre Doctor MOM, Kameton, Validol, Heptral (ademetionin), Panangin ve Asparkam (potasyum ve magnezyum aspartat) bulunmaz; sibutramin hiçbir adla satılmaz.',
			UnaGaps2:
				"Belirli bir ilacın Karadağ'da ruhsatlı olup olmadığını ve nasıl satıldığını ",
			UnaGaps2Link: 'ilaç ruhsat kayıtlarımızda',
			UnaGaps2End: ' kontrol edebilirsiniz.',

			UnaAntivirals1:
				"Ayrı bir konu, Rusya ve Ukrayna'da bilinen antiviraller ve immünomodülatörlerdir: Viferon, Arbidol, Cycloferon, Kagocel, Polyoxidonium, Citovir, Ergoferon. Karadağ'da bunlar yoktur ve bu yerel bir kıtlık değildir: bu ilaç sınıfı esasen Rusya ve eski SSCB dışında kullanılmaz ve Avrupa tıp pratiğinin parçası değildir. Soğuk algınlığında bağışıklığı güçlendirmek için burada bir şey aramak boşunadır — yerel ürün yelpazesinde basitçe yoktur. Çocuklar için ayrı koruyucu antiviraller de yoktur.",
			UnaAntivirals2:
				'Bu, viral enfeksiyonların tedavi edilemeyeceği anlamına gelmez: belirli patojenlere karşı etkinliği kanıtlanmış ilaçlar vardır ve bunları doktor endikasyona göre reçeteyle yazar — ama bu hedefe yönelik bir tedavidir, koruyucu bir kür değil.',
			UnaAntivirals3a:
				"Benzer bir durum, alışılmış post-Sovyet setindeki nootropikler ve metabolik ilaçlardır: Actovegin, Mexidol, Cerebrolysin, Phenibut, Meldonium. Karadağ'da bunlar yok, aynı nedenle — Avrupa pratiğinde tanınan bir kanıt temeli yok. Yine de bazı damar ilaçları var — örneğin ",
			UnaAntivirals3Vinpocetine: 'vinpoketin',
			UnaAntivirals3Mid: ' veya ',
			UnaAntivirals3Cinnarizine: 'sinarizin',
			UnaAntivirals3End: '.',

			'UnaToc_glp1': 'Diyabet ve zayıflama iğneleri',
			UnaGlp1a:
				"Ayrı bir konu, Rusya ve Ukrayna'da zayıflamak için yaygın biçimde enjekte edilen GLP-1 agonistleridir (semaglutid, tirzepatid). Semaglutid Karadağ'da mevcut: ",
			UnaGlp1Ozempic: 'Ozempic',
			UnaGlp1Mid: ' (tip 2 diyabet için) ve ',
			UnaGlp1Wegovy: 'Wegovy',
			UnaGlp1End:
				' (kilo vermek için) ruhsatlıdır — ikisi de enjeksiyon biçiminde ve kesinlikle reçeteyle. Tirzepatid (Mounjaro) şimdilik yerel kayıtlarda yok.',
			UnaGlp12:
				'Bunlar kontrendikasyonları ve yan etkileri olan ciddi reçeteli ilaçlardır: doktor endikasyona göre (diyabet, obezite) yazar ve dozu kademeli artırır — gözetimsiz, hızlı kilo vermek için yapılacak iğneler değildir. Tedarik sıkıntılarını da hesaba katın: semaglutid dünya genelinde zaman zaman tükeniyor.',
			UnaGlp13a:
				'Diyabetin kendisiyle sorun yok: modern insülin analogları ve ağızdan alınan ilaçlar mevcut — ',
			UnaGlp13Metformin: 'metformin',
			UnaGlp13Mid: ', ',
			UnaGlp13Dapagliflozin: 'dapagliflozin',
			UnaGlp13End:
				' (Forxiga), empagliflozin (Jardiance), gliptinler. Sağlık karnesiyle Fon listesindeki ilaçlar neredeyse ücretsizdir; sigortasız kendiniz ödersiniz, ama bulunurlar.',
			UnaImport1:
				"Eksik olanların bir kısmını ülkenizden getirmek isteyebilirsiniz — ve burada hukuki bir ayrıntı var. Corvalol ve Valocordin, birçok ülkede kontrole tabi bir madde olan fenobarbital içerir: bu tür ilaçların ülkeye sokulması, ülkenizde serbestçe satılsalar bile kısıtlanmış veya yasaklanmış olabilir. Aynı şey güçlü ağrı kesiciler ve psikotrop ilaçlar için de geçerlidir.",
			UnaImport2:
				"Genel kural: yola çıkmadan önce Karadağ'ın ve varsa transit ülkenin gümrük kurallarını kontrol edin. Kişisel kullanım için ilaçların makul miktarlarda, orijinal ambalajında ve etken madde ile dozu belirten bir reçete veya doktor raporuyla getirilmesine genellikle izin verilir. Sınırdaki ilaçlar için reçetenin belgeli kanıtını yanınızda taşımak — ya da onları hiç getirmemek — daha iyidir.",

			UnaAccess1:
				"Çoğu zaman sorun etken maddenin bulunmaması değil, reçetesiz size satılmamasıdır. Antibiyotikler, uyku ilaçları, antidepresanlar ve reçeteli ilaçların çoğu Karadağ'da reçetesiz verilmez. Ayrıca yabancı bir reçete — Rus, Ukrayna, herhangi biri — yerel eczanede geçerli değildir: yerel bir reçete gerekir. Özel klinikte bu genellikle doktorun kaşesi ve imzası bulunan kâğıt bir reçetedir; elektronik reçete (eRecept) daha çok Fon üzerinden ilaç alımı için kullanılır.",
			UnaAccess2:
				"Bu yüzden alışılmış düzeni yeniden kurmak gerekir: doktordan etken maddeye göre yerel bir reçete alın ve ilaç Karadağ'da ruhsatlı değilse, ürün yelpazesinin daha geniş olduğu komşu Sırbistan veya Bosna'da arayın ya da bir eczane aracılığıyla sipariş edin. Reçetelerin, Fon listelerinin ve muadil aramanın nasıl işlediğini ",
			UnaAccess2Link: "Karadağ'da eczaneler ve ilaçlar hakkındaki makalemizde",
			UnaAccess2End: ' ayrıntılı olarak ele alıyoruz.',

			UnaSources0:
				"Bu özet, Karadağ'ın Rusça konuşan topluluklarının deneyimine (2023–2026) dayanır ve Temmuz 2026 itibarıyla günceldir. Bulunabilirlik ve kurallar değişir; içerik bilgilendirme amaçlıdır ve doktor veya eczacı danışmasının yerini tutmaz. Birincil kaynaklardan doğrulayın:",
			UnaSourcesCinmed:
				'CInMED — Karadağ İlaç ve Tıbbi Cihaz Enstitüsü, ruhsatlı ilaçların resmî kaydı: cinmed.me;',
			UnaSourcesFzo: "FZOCG — Sağlık Sigortası Fonu'nun ilaç listeleri: fzocg.me.",
			UnaSourcesDoctors:
				'Tedavinizi düzenleyecek ve yerel bir reçete yazacak bir doktor mu gerekiyor? Kataloğumuzda her doktorun konuştuğu diller belirtilir — ',
			UnaSourcesDoctorsLink: 'dilinizi konuşan bir doktor bulun',
			UnaSourcesDoctorsEnd: '.',

			UnaCtaTitle: 'Belirli bir ilaç mı arıyorsunuz?',
			UnaCtaText:
				"Karadağ'da ruhsatlı olup olmadığını ve nasıl satıldığını kataloğumuzda kontrol edin.",
			UnaCtaButton: 'İlaç kataloğu',
		},
	},
};
