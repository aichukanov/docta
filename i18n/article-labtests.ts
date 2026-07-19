// Контент статьи «Анализы и чекапы в Черногории: лаборатории, цены, без направления».
// Факты сверены с правилником FZOCG о листах ожидания (КТ/МРТ в списке услуг),
// прайс-листами лабораторий (invitro.co.me, mojlab.me), условиями Uniqa
// и данными русскоязычных чатов о реальном опыте (2023–2026). Актуальность: июль 2026.
export default {
	messages: {
		'en': {
			LabTestsArticleTitle:
				'Lab Tests and Check-ups in Montenegro: Labs, Prices, No Referral Needed',
			LabTestsArticleDescription:
				'Where to get tested in Montenegro: private labs with no referral and their prices, the free route via your izabrani doktor, MRI and CT waiting lists, check-up packages and how to read the results. Updated July 2026.',

			'LtcToc_private-labs': 'Private labs: no referral, no appointment',
			'LtcToc_state-route': 'The state route: uput, free, but with queues',
			'LtcToc_imaging': 'Ultrasound, CT and MRI: where it is faster',
			'LtcToc_checkups': 'Check-up packages (sistematski pregled)',
			'LtcToc_results': 'How to read results: units and reference ranges',
			'LtcToc_sources': 'Sources and useful links',

			LtcPrivate1a:
				'Getting a blood test is one of the easiest medical tasks in Montenegro: you can walk into a private laboratory without a referral, without an appointment and without insurance. Labs work on a first-come basis — and there is usually no queue at all; results of basic tests are ready the same day and arrive by e-mail. The largest chain is ',
			LtcPrivate1MojLabLink: 'Moj Lab',
			LtcPrivate1b: ' (nine cities, from Podgorica and Budva to Ulcinj); ',
			LtcPrivate1InVitroLink: 'In Vitro',
			LtcPrivate1c: ' and ',
			LtcPrivate1BonaLabLink: 'Bona-lab prima',
			LtcPrivate1d: ' operate in Podgorica, and many polyclinics (',
			LtcPrivate1KonzilijumLink: 'Konzilijum',
			LtcPrivate1e: ', ',
			LtcPrivate1MilmedikaLink: 'Milmedika',
			LtcPrivate1f:
				') run their own labs. Bar also has two large labs of its own — ',
			LtcPrivate1ZejnilovicLink: 'Zejnilović',
			LtcPrivate1g: ' and ',
			LtcPrivate1NoviStandardLink: 'Novi Standard',
			LtcPrivate1h: '.',
			LtcPrivate2a:
				'Prices are charged per parameter. Reference points from 2025–2026 price lists: ',
			LtcPrivate2CbcLink: 'complete blood count',
			LtcPrivate2b: ' ~5 €, ',
			LtcPrivate2GlucoseLink: 'glucose',
			LtcPrivate2c: ' ~2 €, ',
			LtcPrivate2CholesterolLink: 'cholesterol',
			LtcPrivate2d: ' ~3 €, ',
			LtcPrivate2BiochemistryLink: 'standard biochemistry parameters',
			LtcPrivate2e: ' 1.5–3 € each, ',
			LtcPrivate2TshLink: 'TSH',
			LtcPrivate2f: ' and ',
			LtcPrivate2HormonesLink: 'thyroid hormones',
			LtcPrivate2g: ' 5–10 €, ',
			LtcPrivate2VitaminDLink: 'vitamin D',
			LtcPrivate2h: ' ~20 €, ',
			LtcPrivate2TumorMarkersLink: 'tumor markers',
			LtcPrivate2i:
				' ~13 € each. A home visit for a blood draw costs about 10 €.',
			LtcPrivate3:
				'A single “comprehensive biochemistry” item familiar from other countries may simply not exist in the price list — parameters are picked one by one, so agree the list with your doctor in advance. The alternative is ready-made panels: basic biochemistry ~30 €, thyroid 13–52 € depending on the hormone set, women’s ~47 €, men’s ~52 €, children’s ~20 €, allergy panels 33–43 €.',
			LtcPrivate4:
				'Prices for specific tests across labs and clinics are easy to compare in our',
			LtcPrivate4Link: 'lab tests catalog',
			LtcPrivate4End: '.',

			LtcState1:
				'With a zdravstvena knjižica, lab tests are free: your izabrani doktor at the dom zdravlja orders them. Blood is drawn there in the morning; a complete blood count (KKS) is usually ready the same afternoon, while hormone results can take one to two weeks. You collect results from your doctor’s nurse, and they also appear in your personal account on the eZdravlje portal (eNalaz).',
			LtcState2:
				'Anything beyond the basics requires an uput — a referral issued by your izabrani doktor, usually following a specialist’s recommendation. Non-urgent diagnostics that cannot be performed within 30 days officially go onto waiting lists — under the Fund’s rules this explicitly includes radiological diagnostics (CT and MRI). The lists are published by the hospitals themselves and by FZOCG, and you can track your position using a personal code.',
			LtcState3:
				'Without a knjižica, state institutions charge official tariffs — and in a hospital each lab parameter can cost noticeably more than in a private lab, so for the uninsured private labs are usually both cheaper and faster. State tariffs and clinic prices are collected in our',
			LtcState3Link: 'catalog of medical services',
			LtcState3End: '.',

			LtcImaging1UzLink: 'Ultrasound',
			LtcImaging1a:
				' is available in private clinics without any referral almost everywhere — often on the same day. Typical prices: 20–50 € per scan; a specialist consultation together with an ultrasound usually comes to 50–90 €.',
			LtcImaging2a: '',
			LtcImaging2MriLink: 'MRI',
			LtcImaging2b: ' and ',
			LtcImaging2CtLink: 'CT',
			LtcImaging2c:
				' are also available privately without an uput: an MRI of one region costs around 90–120 €, a CT scan 60–120 € depending on the region and clinic. Scanners are available in Podgorica, Budva, Sutomore and Radanovići; appointments are usually within days, not months. It is worth calling ahead to check that the scanner is working and until what time.',
			LtcImaging3:
				'With a knjižica, MRI and CT are free, but this is exactly where the queues are longest: with an uput you join a waiting list, and the wait can range from several weeks to months. The quality of the written report varies in both private and state centers — ask for the scan on a disc or a download link and show it to your treating doctor.',
			LtcImaging4: 'Clinics with ultrasound, CT and MRI can be found in the',
			LtcImaging4Link: 'clinics catalog',
			LtcImaging4End: '.',

			LtcCheckup1:
				'There is no state-run preventive screening program for adults in Montenegro — a preventive exam here is called a sistematski pregled and is offered by private clinics as a paid package: a GP exam, ECG, ultrasound and basic labs. In patients’ experience, a comprehensive visit with an exam, ultrasound and blood tests comes to roughly 80–90 €; extended packages at larger clinics cost more.',
			LtcCheckup2:
				'Check-up packages for women and men are regularly offered by the big chains (for example Moj Lab), polyclinics like Milmedika and hospitals such as Codra Hospital. If you hold voluntary insurance, check your policy terms: Uniqa, for instance, has offered an annual sistematski pregled worth up to 100 € added to any package, not counted against the policy limit — but insurer terms change, so confirm the current wording with Uniqa or your agent before relying on it.',
			LtcCheckup3:
				'A budget option is to assemble the check-up yourself from lab panels (a women’s or men’s panel is ~47–52 €) plus a single GP consultation to review the results.',

			LtcResults1:
				'Results are issued in the local language (Latin script) with international parameter abbreviations — LEU, ERY, HGB, GLU and so on — so they are readable even without the language. Private labs send a PDF by e-mail; state results are available via eZdravlje.',
			LtcResults2:
				'The main trap is units of measurement and reference ranges: they may differ from what you are used to. The classic example is vitamin D: local labs usually report it in ng/ml, while many other countries use nmol/l (a factor of 2.5) — a “normal” local value is easy to mistake for a deficiency and vice versa. Always compare a result only against the reference ranges of the lab that ran the test.',
			LtcResults3:
				'Do not interpret abnormal values on your own: a GP or specialist consultation costs 20–50 €, and the doctor will read the results in the context of your symptoms and history.',

			LtcSources0:
				'The information is current as of July 2026. Prices are reference points from lab price lists and patient experience in 2024–2026 — check the current price list before your visit. Official sources:',
			LtcSourcesFzo:
				'Health Insurance Fund of Montenegro (FZOCG) — waiting-list rules and lists by institution: fzocg.me;',
			LtcSourcesKccg:
				'Clinical Center of Montenegro — published waiting lists by specialty: kccg.me;',
			LtcSourcesEzdravlje:
				'eZdravlje portal — booking, e-prescriptions and lab results (eNalaz): ezdravlje.me;',
			LtcSourcesLabs:
				'Laboratory price lists — published on the chains’ websites, e.g. mojlab.me and invitro.co.me.',
			LtcSourcesCatalog:
				'Need a doctor to explain your results in your language? Our catalog lists the languages each doctor speaks —',
			LtcSourcesCatalogLink: 'find your doctor',
			LtcSourcesCatalogEnd: '.',

			LtcCtaTitle: 'Compare lab test prices',
			LtcCtaText:
				'The docta.me catalog covers hundreds of lab tests with prices at laboratories and clinics across Montenegro — from a complete blood count to hormone panels.',
			LtcCtaButton: 'Open the lab tests catalog',
		},
		'ru': {
			LabTestsArticleTitle:
				'Анализы и чекапы в Черногории: лаборатории, цены, без направления',
			LabTestsArticleDescription:
				'Где сдать анализы в Черногории: частные лаборатории без направления и цены, бесплатный путь через izabrani doktor, очереди на МРТ и КТ, чекап-пакеты и как читать результаты. Актуально на июль 2026 года.',

			'LtcToc_private-labs': 'Частные лаборатории: без направления и записи',
			'LtcToc_state-route': 'Государственный путь: uput, бесплатно, но с очередями',
			'LtcToc_imaging': 'УЗИ, КТ и МРТ: где быстрее',
			'LtcToc_checkups': 'Чекап-пакеты (sistematski pregled)',
			'LtcToc_results': 'Как читать результаты: единицы и референсы',
			'LtcToc_sources': 'Источники и полезные ссылки',

			LtcPrivate1a:
				'Сдать анализы — одна из самых простых медицинских задач в Черногории: в частную лабораторию можно прийти без направления, без записи и без страховки. Работают в порядке живой очереди, которой чаще всего просто нет; результаты базовых анализов готовы в тот же день и приходят на e-mail. Крупнейшая сеть — ',
			LtcPrivate1MojLabLink: 'Moj Lab',
			LtcPrivate1b: ' (девять городов, от Подгорицы и Будвы до Улциня), в Подгорице работают ',
			LtcPrivate1InVitroLink: 'In Vitro',
			LtcPrivate1c: ' и ',
			LtcPrivate1BonaLabLink: 'Bona-lab prima',
			LtcPrivate1d: ', свои лаборатории есть и у многих поликлиник (',
			LtcPrivate1KonzilijumLink: 'Konzilijum',
			LtcPrivate1e: ', ',
			LtcPrivate1MilmedikaLink: 'Milmedika',
			LtcPrivate1f: '). В Баре тоже есть свои крупные лаборатории — ',
			LtcPrivate1ZejnilovicLink: 'Zejnilović',
			LtcPrivate1g: ' и ',
			LtcPrivate1NoviStandardLink: 'Novi Standard',
			LtcPrivate1h: '.',
			LtcPrivate2a:
				'Цены считаются за каждый показатель отдельно. Ориентиры по прайсам 2025–2026 годов: ',
			LtcPrivate2CbcLink: 'общий анализ крови',
			LtcPrivate2b: ' ~5 €, ',
			LtcPrivate2GlucoseLink: 'глюкоза',
			LtcPrivate2c: ' ~2 €, ',
			LtcPrivate2CholesterolLink: 'холестерин',
			LtcPrivate2d: ' ~3 €, ',
			LtcPrivate2BiochemistryLink: 'стандартные биохимические показатели',
			LtcPrivate2e: ' по 1,5–3 € за позицию, ',
			LtcPrivate2TshLink: 'ТТГ',
			LtcPrivate2f: ' и ',
			LtcPrivate2HormonesLink: 'гормоны щитовидной железы',
			LtcPrivate2g: ' 5–10 €, ',
			LtcPrivate2VitaminDLink: 'витамин D',
			LtcPrivate2h: ' ~20 €, ',
			LtcPrivate2TumorMarkersLink: 'онкомаркеры',
			LtcPrivate2i:
				' ~13 € за каждый. Выезд на дом для забора крови стоит около 10 €.',
			LtcPrivate3:
				'Привычной по другим странам единой позиции «биохимический анализ крови» в прайсе может не оказаться — показатели выбирают по одному, поэтому список лучше заранее согласовать с врачом. Альтернатива — готовые панели: базовая биохимическая ~30 €, щитовидная железа 13–52 € в зависимости от набора гормонов, женская ~47 €, мужская ~52 €, детская ~20 €, аллергопанели 33–43 €.',
			LtcPrivate4:
				'Цены на конкретные анализы в лабораториях и клиниках удобно сравнить в нашем',
			LtcPrivate4Link: 'каталоге анализов',
			LtcPrivate4End: '.',

			LtcState1:
				'Со zdravstvena knjižica анализы бесплатны: их назначает izabrani doktor в вашем доме здравля. Кровь сдают там же с утра; общий анализ (KKS) обычно готов уже после обеда, а результатов гормонов можно ждать одну-две недели. Результаты отдаёт медсестра вашего врача, а ещё они появляются в личном кабинете на портале eZdravlje (eNalaz).',
			LtcState2:
				'На всё, что дальше базового набора, нужен uput — направление, которое izabrani doktor выписывает обычно по рекомендации специалиста. Несрочные обследования, которые невозможно сделать в течение 30 дней, официально попадают в листы ожидания — по правилам фонда это прямо касается и радиологической диагностики (КТ и МРТ). Списки публикуют сами больницы и FZOCG, продвижение по листу можно отслеживать по персональному коду.',
			LtcState3:
				'Без книжицы государственные учреждения принимают по официальным тарифам — причём в больнице каждый лабораторный показатель может стоить заметно дороже, чем в частной лаборатории, так что незастрахованным частные лаборатории обычно и дешевле, и быстрее. Государственные тарифы и цены клиник собраны в нашем',
			LtcState3Link: 'каталоге медицинских услуг',
			LtcState3End: '.',

			LtcImaging1UzLink: 'УЗИ',
			LtcImaging1a:
				' в частных клиниках делают без направления практически везде — часто в тот же день. Ориентир по ценам: 20–50 € за исследование; приём специалиста вместе с УЗИ обычно выходит в 50–90 €.',
			LtcImaging2a: '',
			LtcImaging2MriLink: 'МРТ',
			LtcImaging2b: ' и ',
			LtcImaging2CtLink: 'КТ',
			LtcImaging2c:
				' в частном секторе тоже доступны без uput: МРТ одной зоны стоит порядка 90–120 €, КТ — 60–120 € в зависимости от зоны и клиники. Аппараты есть в Подгорице, Будве, Сутоморе, Радановичах; запись обычно на ближайшие дни, а не месяцы. Перед поездкой стоит позвонить и уточнить, работает ли аппарат и до которого часа.',
			LtcImaging3:
				'По книжице МРТ и КТ бесплатны, но именно на них очереди самые заметные: с uput вы попадаете в лист ожидания, и ждать можно от нескольких недель до месяцев. Качество описания снимков различается и в частных, и в государственных центрах — попросите записать исследование на диск или прислать ссылку и покажите его лечащему врачу.',
			LtcImaging4: 'Клиники с УЗИ, КТ и МРТ ищите в',
			LtcImaging4Link: 'каталоге клиник',
			LtcImaging4End: '.',

			LtcCheckup1:
				'Государственной диспансеризации для взрослых в Черногории нет — профилактический осмотр здесь называется sistematski pregled и предлагается частными клиниками как платный пакет: осмотр терапевта, ЭКГ, УЗИ, базовые анализы. По опыту пациентов, комплексный визит с осмотром, УЗИ и анализами обходится примерно в 80–90 €; расширенные пакеты крупных клиник стоят дороже.',
			LtcCheckup2:
				'Чекап-пакеты для женщин и мужчин регулярно предлагают крупные сети (например, Moj Lab), поликлиники вроде Milmedika и больницы уровня Codra Hospital. Если у вас добровольная страховка, проверьте условия: например, Uniqa предлагала докупить к любому пакету годовой систематский преглед на сумму до 100 €, не расходующий лимит полиса, — но условия страховщиков меняются, уточните актуальную формулировку у Uniqa или своего агента, прежде чем на это рассчитывать.',
			LtcCheckup3:
				'Бюджетный вариант — собрать чекап самостоятельно из лабораторных панелей (женская или мужская панель ~47–52 €) плюс один приём терапевта для разбора результатов.',

			LtcResults1:
				'Результаты выдают на местном языке (латиницей) с международными сокращениями показателей — LEU, ERY, HGB, GLU и так далее, так что прочитать их можно и без знания языка. Частные лаборатории присылают PDF на почту, государственные результаты доступны через eZdravlje.',
			LtcResults2:
				'Главная ловушка — единицы измерения и референсные диапазоны: они могут отличаться от привычных вам. Классический пример — витамин D: местные лаборатории обычно считают его в ng/ml, тогда как во многих других странах используют нмоль/л (коэффициент 2,5) — «нормальное» местное значение легко принять за дефицит и наоборот. Сравнивайте результат только с референсами той лаборатории, которая делала анализ.',
			LtcResults3:
				'Не интерпретируйте отклонения самостоятельно: приём терапевта или узкого специалиста стоит 20–50 €, и врач оценит результаты в контексте ваших жалоб и истории.',

			LtcSources0:
				'Информация актуальна на июль 2026 года. Цены — ориентиры из прайсов лабораторий и опыта пациентов 2024–2026 годов; перед визитом проверяйте актуальный прайс. Официальные источники:',
			LtcSourcesFzo:
				'Фонд медицинского страхования Черногории (FZOCG) — правила листов ожидания и списки по учреждениям: fzocg.me;',
			LtcSourcesKccg:
				'Клинический центр Черногории — опубликованные листы ожидания по направлениям: kccg.me;',
			LtcSourcesEzdravlje:
				'Портал eZdravlje — запись, электронные рецепты и результаты анализов (eNalaz): ezdravlje.me;',
			LtcSourcesLabs:
				'Прайс-листы лабораторий — публикуются на сайтах сетей, например mojlab.me и invitro.co.me.',
			LtcSourcesCatalog:
				'Нужен врач, который объяснит результаты на вашем языке? В нашем каталоге у врачей указаны языки приёма —',
			LtcSourcesCatalogLink: 'найдите своего врача',
			LtcSourcesCatalogEnd: '.',

			LtcCtaTitle: 'Сравните цены на анализы',
			LtcCtaText:
				'В каталоге docta.me — сотни анализов с ценами в лабораториях и клиниках Черногории: от общего анализа крови до гормональных панелей.',
			LtcCtaButton: 'Открыть каталог анализов',
		},
		'sr': {
			LabTestsArticleTitle:
				'Analize i check-up u Crnoj Gori: laboratorije, cijene, bez uputa',
			LabTestsArticleDescription:
				'Gdje uraditi analize u Crnoj Gori: privatne laboratorije bez uputa i cijene, besplatan put preko izabranog doktora, liste čekanja za MR i CT, check-up paketi i kako čitati rezultate. Ažurirano: jul 2026.',

			'LtcToc_private-labs': 'Privatne laboratorije: bez uputa i zakazivanja',
			'LtcToc_state-route': 'Državni put: uput, besplatno, ali uz redove',
			'LtcToc_imaging': 'Ultrazvuk, CT i MR: gdje je brže',
			'LtcToc_checkups': 'Check-up paketi (sistematski pregled)',
			'LtcToc_results': 'Kako čitati rezultate: jedinice i referentne vrijednosti',
			'LtcToc_sources': 'Izvori i korisni linkovi',

			LtcPrivate1a:
				'Uraditi analize jedan je od najjednostavnijih medicinskih zadataka u Crnoj Gori: u privatnu laboratoriju možete doći bez uputa, bez zakazivanja i bez osiguranja. Radi se po redosljedu dolaska — a reda najčešće uopšte nema; rezultati osnovnih analiza gotovi su istog dana i stižu na e-mail. Najveći lanac je ',
			LtcPrivate1MojLabLink: 'Moj Lab',
			LtcPrivate1b: ' (devet gradova, od Podgorice i Budve do Ulcinja); u Podgorici rade ',
			LtcPrivate1InVitroLink: 'In Vitro',
			LtcPrivate1c: ' i ',
			LtcPrivate1BonaLabLink: 'Bona-lab prima',
			LtcPrivate1d: ', a sopstvene laboratorije imaju i mnoge poliklinike (',
			LtcPrivate1KonzilijumLink: 'Konzilijum',
			LtcPrivate1e: ', ',
			LtcPrivate1MilmedikaLink: 'Milmedika',
			LtcPrivate1f: '). Bar takođe ima svoje velike laboratorije — ',
			LtcPrivate1ZejnilovicLink: 'Zejnilović',
			LtcPrivate1g: ' i ',
			LtcPrivate1NoviStandardLink: 'Novi Standard',
			LtcPrivate1h: '.',
			LtcPrivate2a:
				'Cijene se računaju po svakom parametru posebno. Orijentiri iz cjenovnika 2025–2026: ',
			LtcPrivate2CbcLink: 'kompletna krvna slika',
			LtcPrivate2b: ' ~5 €, ',
			LtcPrivate2GlucoseLink: 'glukoza',
			LtcPrivate2c: ' ~2 €, ',
			LtcPrivate2CholesterolLink: 'holesterol',
			LtcPrivate2d: ' ~3 €, ',
			LtcPrivate2BiochemistryLink: 'standardni biohemijski parametri',
			LtcPrivate2e: ' po 1,5–3 € po stavci, ',
			LtcPrivate2TshLink: 'TSH',
			LtcPrivate2f: ' i ',
			LtcPrivate2HormonesLink: 'hormoni štitne žlijezde',
			LtcPrivate2g: ' 5–10 €, ',
			LtcPrivate2VitaminDLink: 'vitamin D',
			LtcPrivate2h: ' ~20 €, ',
			LtcPrivate2TumorMarkersLink: 'tumor markeri',
			LtcPrivate2i:
				' ~13 € po svakom. Dolazak na kućnu adresu radi vađenja krvi košta oko 10 €.',
			LtcPrivate3:
				'Jedinstvene stavke „kompletna biohemija“ poznate iz drugih zemalja u cjenovniku možda uopšte nema — parametri se biraju pojedinačno, pa je spisak najbolje unaprijed dogovoriti sa ljekarom. Alternativa su gotovi paneli: osnovni biohemijski ~30 €, štitna žlijezda 13–52 € u zavisnosti od seta hormona, ženski ~47 €, muški ~52 €, dječiji ~20 €, alergo-paneli 33–43 €.',
			LtcPrivate4:
				'Cijene konkretnih analiza po laboratorijama i klinikama lako je uporediti u našem',
			LtcPrivate4Link: 'katalogu analiza',
			LtcPrivate4End: '.',

			LtcState1:
				'Uz zdravstvenu knjižicu analize su besplatne: propisuje ih izabrani doktor u vašem domu zdravlja. Krv se vadi tamo ujutru; kompletna krvna slika (KKS) obično je gotova već poslije podne, dok se na rezultate hormona čeka jednu do dvije nedjelje. Rezultate izdaje sestra vašeg doktora, a pojavljuju se i u ličnom nalogu na portalu eZdravlje (eNalaz).',
			LtcState2:
				'Za sve dalje od osnovnog seta potreban je uput — izdaje ga izabrani doktor, obično po preporuci specijaliste. Nehitni pregledi koji se ne mogu obaviti u roku od 30 dana zvanično idu na liste čekanja — po pravilima Fonda to se izričito odnosi i na radiološku dijagnostiku (CT i MR). Liste objavljuju same bolnice i FZOCG, a kretanje po listi može se pratiti preko ličnog koda.',
			LtcState3:
				'Bez knjižice državne ustanove naplaćuju po zvaničnim tarifama — pri čemu u bolnici svaki laboratorijski parametar može koštati primjetno više nego u privatnoj laboratoriji, pa su neosiguranima privatne laboratorije obično i jeftinije i brže. Državne tarife i cijene klinika sakupljene su u našem',
			LtcState3Link: 'katalogu medicinskih usluga',
			LtcState3End: '.',

			LtcImaging1UzLink: 'Ultrazvuk',
			LtcImaging1a:
				' se u privatnim klinikama radi bez uputa praktično svuda — često istog dana. Orijentir cijena: 20–50 € po pregledu; pregled specijaliste zajedno sa ultrazvukom obično izađe 50–90 €.',
			LtcImaging2a: '',
			LtcImaging2MriLink: 'MR',
			LtcImaging2b: ' i ',
			LtcImaging2CtLink: 'CT',
			LtcImaging2c:
				' su u privatnom sektoru takođe dostupni bez uputa: MR jedne regije košta oko 90–120 €, CT 60–120 € u zavisnosti od regije i klinike. Aparati postoje u Podgorici, Budvi, Sutomoru i Radanovićima; termin je obično u narednim danima, a ne mjesecima. Prije polaska vrijedi pozvati i provjeriti da li aparat radi i do koliko sati.',
			LtcImaging3:
				'Uz knjižicu su MR i CT besplatni, ali su upravo tu redovi najuočljiviji: sa uputom ulazite na listu čekanja, a čeka se od nekoliko nedjelja do nekoliko mjeseci. Kvalitet opisa snimaka razlikuje se i u privatnim i u državnim centrima — tražite da vam snimak narežu na disk ili pošalju link i pokažite ga ljekaru koji vas liječi.',
			LtcImaging4: 'Klinike sa ultrazvukom, CT i MR potražite u',
			LtcImaging4Link: 'katalogu klinika',
			LtcImaging4End: '.',

			LtcCheckup1:
				'Državnog programa preventivnih pregleda za odrasle u Crnoj Gori nema — preventivni pregled ovdje se zove sistematski pregled i privatne klinike ga nude kao plaćeni paket: pregled ljekara opšte prakse, EKG, ultrazvuk, osnovne analize. Po iskustvu pacijenata, kompletna posjeta sa pregledom, ultrazvukom i analizama izađe otprilike 80–90 €; prošireni paketi većih klinika koštaju više.',
			LtcCheckup2:
				'Check-up pakete za žene i muškarce redovno nude veliki lanci (na primjer Moj Lab), poliklinike poput Milmedike i bolnice ranga Codra Hospital. Ako imate dobrovoljno osiguranje, provjerite uslove: Uniqa je, na primjer, nudila mogućnost da se uz svaki paket dokupi godišnji sistematski pregled u vrijednosti do 100 €, koji ne troši limit polise — ali uslovi osiguravača se mijenjaju, pa prije nego što na to računate provjerite aktuelnu formulaciju kod Uniqa ili svog agenta.',
			LtcCheckup3:
				'Budžetska varijanta je da check-up sastavite sami od laboratorijskih panela (ženski ili muški panel ~47–52 €) plus jedan pregled kod ljekara opšte prakse radi tumačenja rezultata.',

			LtcResults1:
				'Rezultati se izdaju na lokalnom jeziku (latinicom) sa međunarodnim skraćenicama parametara — LEU, ERY, HGB, GLU i tako dalje, pa su čitljivi i bez znanja jezika. Privatne laboratorije šalju PDF na e-mail, državni rezultati dostupni su preko portala eZdravlje.',
			LtcResults2:
				'Glavna zamka su mjerne jedinice i referentne vrijednosti: mogu se razlikovati od onih na koje ste navikli. Klasičan primjer je vitamin D: lokalne laboratorije ga obično iskazuju u ng/ml, dok mnoge druge zemlje koriste nmol/l (koeficijent 2,5) — „normalnu“ lokalnu vrijednost lako je pogrešno protumačiti kao deficit i obrnuto. Rezultat poredite isključivo sa referentnim vrijednostima laboratorije koja je analizu radila.',
			LtcResults3:
				'Odstupanja ne tumačite sami: pregled ljekara opšte prakse ili specijaliste košta 20–50 €, a ljekar će rezultate procijeniti u kontekstu vaših tegoba i istorije bolesti.',

			LtcSources0:
				'Informacije važe za jul 2026. Cijene su orijentiri iz cjenovnika laboratorija i iskustva pacijenata 2024–2026 — prije posjete provjerite aktuelni cjenovnik. Zvanični izvori:',
			LtcSourcesFzo:
				'Fond za zdravstveno osiguranje Crne Gore (FZOCG) — pravila listi čekanja i liste po ustanovama: fzocg.me;',
			LtcSourcesKccg:
				'Klinički centar Crne Gore — objavljene liste čekanja po oblastima: kccg.me;',
			LtcSourcesEzdravlje:
				'Portal eZdravlje — zakazivanje, eRecept i rezultati analiza (eNalaz): ezdravlje.me;',
			LtcSourcesLabs:
				'Cjenovnici laboratorija — objavljuju se na sajtovima lanaca, npr. mojlab.me i invitro.co.me.',
			LtcSourcesCatalog:
				'Treba vam ljekar koji će rezultate objasniti na vašem jeziku? U našem katalogu doktori imaju oznake jezika —',
			LtcSourcesCatalogLink: 'pronađite svog doktora',
			LtcSourcesCatalogEnd: '.',

			LtcCtaTitle: 'Uporedite cijene analiza',
			LtcCtaText:
				'U katalogu docta.me nalaze se stotine analiza sa cijenama u laboratorijama i klinikama Crne Gore — od kompletne krvne slike do hormonskih panela.',
			LtcCtaButton: 'Otvori katalog analiza',
		},
		'sr-cyrl': {
			LabTestsArticleTitle:
				'Анализе и check-up у Црној Гори: лабораторије, цијене, без упута',
			LabTestsArticleDescription:
				'Гдје урадити анализе у Црној Гори: приватне лабораторије без упута и цијене, бесплатан пут преко изабраног доктора, листе чекања за МР и ЦТ, check-up пакети и како читати резултате. Ажурирано: јул 2026.',

			'LtcToc_private-labs': 'Приватне лабораторије: без упута и заказивања',
			'LtcToc_state-route': 'Државни пут: упут, бесплатно, али уз редове',
			'LtcToc_imaging': 'Ултразвук, ЦТ и МР: гдје је брже',
			'LtcToc_checkups': 'Check-up пакети (систематски преглед)',
			'LtcToc_results': 'Како читати резултате: јединице и референтне вриједности',
			'LtcToc_sources': 'Извори и корисни линкови',

			LtcPrivate1a:
				'Урадити анализе један је од најједноставнијих медицинских задатака у Црној Гори: у приватну лабораторију можете доћи без упута, без заказивања и без осигурања. Ради се по редосљеду доласка — а реда најчешће уопште нема; резултати основних анализа готови су истог дана и стижу на e-mail. Највећи ланац је ',
			LtcPrivate1MojLabLink: 'Moj Lab',
			LtcPrivate1b: ' (девет градова, од Подгорице и Будве до Улциња); у Подгорици раде ',
			LtcPrivate1InVitroLink: 'In Vitro',
			LtcPrivate1c: ' и ',
			LtcPrivate1BonaLabLink: 'Bona-lab prima',
			LtcPrivate1d: ', а сопствене лабораторије имају и многе поликлинике (',
			LtcPrivate1KonzilijumLink: 'Konzilijum',
			LtcPrivate1e: ', ',
			LtcPrivate1MilmedikaLink: 'Milmedika',
			LtcPrivate1f: '). Бар такође има своје велике лабораторије — ',
			LtcPrivate1ZejnilovicLink: 'Zejnilović',
			LtcPrivate1g: ' и ',
			LtcPrivate1NoviStandardLink: 'Novi Standard',
			LtcPrivate1h: '.',
			LtcPrivate2a:
				'Цијене се рачунају по сваком параметру посебно. Оријентири из цјеновника 2025–2026: ',
			LtcPrivate2CbcLink: 'комплетна крвна слика',
			LtcPrivate2b: ' ~5 €, ',
			LtcPrivate2GlucoseLink: 'глукоза',
			LtcPrivate2c: ' ~2 €, ',
			LtcPrivate2CholesterolLink: 'холестерол',
			LtcPrivate2d: ' ~3 €, ',
			LtcPrivate2BiochemistryLink: 'стандардни биохемијски параметри',
			LtcPrivate2e: ' по 1,5–3 € по ставци, ',
			LtcPrivate2TshLink: 'TSH',
			LtcPrivate2f: ' и ',
			LtcPrivate2HormonesLink: 'хормони штитне жлијезде',
			LtcPrivate2g: ' 5–10 €, ',
			LtcPrivate2VitaminDLink: 'витамин D',
			LtcPrivate2h: ' ~20 €, ',
			LtcPrivate2TumorMarkersLink: 'тумор маркери',
			LtcPrivate2i:
				' ~13 € по сваком. Долазак на кућну адресу ради вађења крви кошта око 10 €.',
			LtcPrivate3:
				'Јединствене ставке „комплетна биохемија“ познате из других земаља у цјеновнику можда уопште нема — параметри се бирају појединачно, па је списак најбоље унапријед договорити са љекаром. Алтернатива су готови панели: основни биохемијски ~30 €, штитна жлијезда 13–52 € у зависности од сета хормона, женски ~47 €, мушки ~52 €, дјечији ~20 €, алерго-панели 33–43 €.',
			LtcPrivate4:
				'Цијене конкретних анализа по лабораторијама и клиникама лако је упоредити у нашем',
			LtcPrivate4Link: 'каталогу анализа',
			LtcPrivate4End: '.',

			LtcState1:
				'Уз здравствену књижицу анализе су бесплатне: прописује их изабрани доктор у вашем дому здравља. Крв се вади тамо ујутру; комплетна крвна слика (ККС) обично је готова већ послије подне, док се на резултате хормона чека једну до двије недјеље. Резултате издаје сестра вашег доктора, а појављују се и у личном налогу на порталу eZdravlje (eNalaz).',
			LtcState2:
				'За све даље од основног сета потребан је упут — издаје га изабрани доктор, обично по препоруци специјалисте. Нехитни прегледи који се не могу обавити у року од 30 дана званично иду на листе чекања — по правилима Фонда то се изричито односи и на радиолошку дијагностику (ЦТ и МР). Листе објављују саме болнице и ФЗОЦГ, а кретање по листи може се пратити преко личног кода.',
			LtcState3:
				'Без књижице државне установе наплаћују по званичним тарифама — при чему у болници сваки лабораторијски параметар може коштати примјетно више него у приватној лабораторији, па су неосигуранима приватне лабораторије обично и јефтиније и брже. Државне тарифе и цијене клиника сакупљене су у нашем',
			LtcState3Link: 'каталогу медицинских услуга',
			LtcState3End: '.',

			LtcImaging1UzLink: 'Ултразвук',
			LtcImaging1a:
				' се у приватним клиникама ради без упута практично свуда — често истог дана. Оријентир цијена: 20–50 € по прегледу; преглед специјалисте заједно са ултразвуком обично изађе 50–90 €.',
			LtcImaging2a: '',
			LtcImaging2MriLink: 'МР',
			LtcImaging2b: ' и ',
			LtcImaging2CtLink: 'ЦТ',
			LtcImaging2c:
				' су у приватном сектору такође доступни без упута: МР једне регије кошта око 90–120 €, ЦТ 60–120 € у зависности од регије и клинике. Апарати постоје у Подгорици, Будви, Сутомору и Радановићима; термин је обично у наредним данима, а не мјесецима. Прије поласка вриједи позвати и провјерити да ли апарат ради и до колико сати.',
			LtcImaging3:
				'Уз књижицу су МР и ЦТ бесплатни, али су управо ту редови најуочљивији: са упутом улазите на листу чекања, а чека се од неколико недјеља до неколико мјесеци. Квалитет описа снимака разликује се и у приватним и у државним центрима — тражите да вам снимак нарежу на диск или пошаљу линк и покажите га љекару који вас лијечи.',
			LtcImaging4: 'Клинике са ултразвуком, ЦТ и МР потражите у',
			LtcImaging4Link: 'каталогу клиника',
			LtcImaging4End: '.',

			LtcCheckup1:
				'Државног програма превентивних прегледа за одрасле у Црној Гори нема — превентивни преглед овдје се зове систематски преглед и приватне клинике га нуде као плаћени пакет: преглед љекара опште праксе, ЕКГ, ултразвук, основне анализе. По искуству пацијената, комплетна посјета са прегледом, ултразвуком и анализама изађе отприлике 80–90 €; проширени пакети већих клиника коштају више.',
			LtcCheckup2:
				'Check-up пакете за жене и мушкарце редовно нуде велики ланци (на примјер Moj Lab), поликлинике попут Milmedike и болнице ранга Codra Hospital. Ако имате добровољно осигурање, провјерите услове: Uniqa је, на примјер, нудила могућност да се уз сваки пакет докупи годишњи систематски преглед у вриједности до 100 €, који не троши лимит полисе — али услови осигуравача се мијењају, па прије него што на то рачунате провјерите актуелну формулацију код Uniqa или свог агента.',
			LtcCheckup3:
				'Буџетска варијанта је да check-up саставите сами од лабораторијских панела (женски или мушки панел ~47–52 €) плус један преглед код љекара опште праксе ради тумачења резултата.',

			LtcResults1:
				'Резултати се издају на локалном језику (латиницом) са међународним скраћеницама параметара — LEU, ERY, HGB, GLU и тако даље, па су читљиви и без знања језика. Приватне лабораторије шаљу PDF на e-mail, државни резултати доступни су преко портала eZdravlje.',
			LtcResults2:
				'Главна замка су мјерне јединице и референтне вриједности: могу се разликовати од оних на које сте навикли. Класичан примјер је витамин D: локалне лабораторије га обично исказују у ng/ml, док многе друге земље користе nmol/l (коефицијент 2,5) — „нормалну“ локалну вриједност лако је погрешно протумачити као дефицит и обрнуто. Резултат поредите искључиво са референтним вриједностима лабораторије која је анализу радила.',
			LtcResults3:
				'Одступања не тумачите сами: преглед љекара опште праксе или специјалисте кошта 20–50 €, а љекар ће резултате процијенити у контексту ваших тегоба и историје болести.',

			LtcSources0:
				'Информације важе за јул 2026. Цијене су оријентири из цјеновника лабораторија и искуства пацијената 2024–2026 — прије посјете провјерите актуелни цјеновник. Званични извори:',
			LtcSourcesFzo:
				'Фонд за здравствено осигурање Црне Горе (ФЗОЦГ) — правила листи чекања и листе по установама: fzocg.me;',
			LtcSourcesKccg:
				'Клинички центар Црне Горе — објављене листе чекања по областима: kccg.me;',
			LtcSourcesEzdravlje:
				'Портал eZdravlje — заказивање, еРецепт и резултати анализа (eNalaz): ezdravlje.me;',
			LtcSourcesLabs:
				'Цјеновници лабораторија — објављују се на сајтовима ланаца, нпр. mojlab.me и invitro.co.me.',
			LtcSourcesCatalog:
				'Треба вам љекар који ће резултате објаснити на вашем језику? У нашем каталогу доктори имају ознаке језика —',
			LtcSourcesCatalogLink: 'пронађите свог доктора',
			LtcSourcesCatalogEnd: '.',

			LtcCtaTitle: 'Упоредите цијене анализа',
			LtcCtaText:
				'У каталогу docta.me налазе се стотине анализа са цијенама у лабораторијама и клиникама Црне Горе — од комплетне крвне слике до хормонских панела.',
			LtcCtaButton: 'Отвори каталог анализа',
		},
		'de': {
			LabTestsArticleTitle:
				'Laboranalysen und Check-ups in Montenegro: Labore, Preise, ohne Überweisung',
			LabTestsArticleDescription:
				'Wo man in Montenegro Laborwerte bestimmen lässt: private Labore ohne Überweisung und ihre Preise, der kostenlose Weg über den izabrani doktor, Wartelisten für MRT und CT, Check-up-Pakete und wie man die Befunde liest. Stand: Juli 2026.',

			'LtcToc_private-labs': 'Private Labore: ohne Überweisung und Termin',
			'LtcToc_state-route': 'Der staatliche Weg: uput, kostenlos, aber mit Wartezeiten',
			'LtcToc_imaging': 'Ultraschall, CT und MRT: wo es schneller geht',
			'LtcToc_checkups': 'Check-up-Pakete (sistematski pregled)',
			'LtcToc_results': 'Befunde richtig lesen: Einheiten und Referenzwerte',
			'LtcToc_sources': 'Quellen und nützliche Links',

			LtcPrivate1a:
				'Blut abnehmen zu lassen ist eine der einfachsten medizinischen Aufgaben in Montenegro: In ein privates Labor kommt man ohne Überweisung, ohne Termin und ohne Versicherung. Bedient wird nach Reihenfolge des Erscheinens — meist gibt es gar keine Schlange; die Ergebnisse der Basisanalysen sind noch am selben Tag fertig und kommen per E-Mail. Die größte Kette ist ',
			LtcPrivate1MojLabLink: 'Moj Lab',
			LtcPrivate1b: ' (neun Städte, von Podgorica und Budva bis Ulcinj); in Podgorica arbeiten ',
			LtcPrivate1InVitroLink: 'In Vitro',
			LtcPrivate1c: ' und ',
			LtcPrivate1BonaLabLink: 'Bona-lab prima',
			LtcPrivate1d: ', und viele Polikliniken (',
			LtcPrivate1KonzilijumLink: 'Konzilijum',
			LtcPrivate1e: ', ',
			LtcPrivate1MilmedikaLink: 'Milmedika',
			LtcPrivate1f:
				') betreiben eigene Labore. Auch Bar hat eigene große Labore — ',
			LtcPrivate1ZejnilovicLink: 'Zejnilović',
			LtcPrivate1g: ' und ',
			LtcPrivate1NoviStandardLink: 'Novi Standard',
			LtcPrivate1h: '.',
			LtcPrivate2a:
				'Abgerechnet wird pro Parameter. Anhaltspunkte aus den Preislisten 2025–2026: ',
			LtcPrivate2CbcLink: 'großes Blutbild',
			LtcPrivate2b: ' ~5 €, ',
			LtcPrivate2GlucoseLink: 'Glukose',
			LtcPrivate2c: ' ~2 €, ',
			LtcPrivate2CholesterolLink: 'Cholesterin',
			LtcPrivate2d: ' ~3 €, ',
			LtcPrivate2BiochemistryLink: 'biochemische Standardparameter',
			LtcPrivate2e: ' je 1,5–3 €, ',
			LtcPrivate2TshLink: 'TSH',
			LtcPrivate2f: ' und ',
			LtcPrivate2HormonesLink: 'Schilddrüsenhormone',
			LtcPrivate2g: ' 5–10 €, ',
			LtcPrivate2VitaminDLink: 'Vitamin D',
			LtcPrivate2h: ' ~20 €, ',
			LtcPrivate2TumorMarkersLink: 'Tumormarker',
			LtcPrivate2i:
				' je ~13 €. Ein Hausbesuch zur Blutentnahme kostet etwa 10 €.',
			LtcPrivate3:
				'Die aus anderen Ländern gewohnte Sammelposition „komplette Biochemie“ fehlt in der Preisliste unter Umständen ganz — die Parameter werden einzeln ausgewählt, die Liste stimmt man daher am besten vorab mit dem Arzt ab. Die Alternative sind fertige Panels: Basis-Biochemie ~30 €, Schilddrüse 13–52 € je nach Hormonumfang, Frauen-Panel ~47 €, Männer-Panel ~52 €, Kinder-Panel ~20 €, Allergie-Panels 33–43 €.',
			LtcPrivate4:
				'Die Preise konkreter Analysen in Laboren und Kliniken vergleichen Sie bequem in unserem',
			LtcPrivate4Link: 'Katalog der Laboranalysen',
			LtcPrivate4End: '.',

			LtcState1:
				'Mit einer zdravstvena knjižica sind Laboranalysen kostenlos: Sie werden vom izabrani doktor in Ihrem dom zdravlja verordnet. Blut wird dort morgens abgenommen; das Blutbild (KKS) ist meist schon am Nachmittag fertig, auf Hormonergebnisse wartet man ein bis zwei Wochen. Die Befunde gibt die Schwester Ihres Arztes aus, außerdem erscheinen sie im persönlichen Konto auf dem Portal eZdravlje (eNalaz).',
			LtcState2:
				'Für alles über die Basisdiagnostik hinaus braucht es einen uput — eine Überweisung, die der izabrani doktor in der Regel auf Empfehlung eines Facharztes ausstellt. Nicht dringende Untersuchungen, die nicht innerhalb von 30 Tagen durchgeführt werden können, kommen offiziell auf Wartelisten — nach den Regeln des Fonds gilt das ausdrücklich auch für die radiologische Diagnostik (CT und MRT). Die Listen veröffentlichen die Krankenhäuser selbst und der FZOCG; die eigene Position lässt sich über einen persönlichen Code verfolgen.',
			LtcState3:
				'Ohne knjižica rechnen staatliche Einrichtungen nach offiziellen Tarifen ab — wobei im Krankenhaus jeder Laborparameter spürbar teurer sein kann als im privaten Labor; für Unversicherte sind private Labore daher meist billiger und schneller zugleich. Staatliche Tarife und Klinikpreise finden Sie in unserem',
			LtcState3Link: 'Katalog medizinischer Leistungen',
			LtcState3End: '.',

			LtcImaging1UzLink: 'Ultraschall',
			LtcImaging1a:
				' gibt es in Privatkliniken praktisch überall ohne Überweisung — oft noch am selben Tag. Preisorientierung: 20–50 € pro Untersuchung; eine Facharztkonsultation samt Ultraschall kommt meist auf 50–90 €.',
			LtcImaging2a: 'Auch ',
			LtcImaging2MriLink: 'MRT',
			LtcImaging2b: ' und ',
			LtcImaging2CtLink: 'CT',
			LtcImaging2c:
				' sind privat ohne uput zugänglich: Ein MRT einer Region kostet etwa 90–120 €, ein CT 60–120 € je nach Region und Klinik. Geräte gibt es in Podgorica, Budva, Sutomore und Radanovići; Termine gibt es in der Regel innerhalb von Tagen, nicht Monaten. Vor der Fahrt lohnt ein Anruf, ob das Gerät läuft und bis wann.',
			LtcImaging3:
				'Mit knjižica sind MRT und CT kostenlos, aber genau hier sind die Wartezeiten am längsten: Mit dem uput kommen Sie auf eine Warteliste, und das Warten kann mehrere Wochen bis Monate dauern. Die Qualität der schriftlichen Befunde schwankt in privaten wie staatlichen Zentren — lassen Sie sich die Aufnahmen auf einer CD oder als Download-Link geben und zeigen Sie sie Ihrem behandelnden Arzt.',
			LtcImaging4: 'Kliniken mit Ultraschall, CT und MRT finden Sie im',
			LtcImaging4Link: 'Klinikkatalog',
			LtcImaging4End: '.',

			LtcCheckup1:
				'Ein staatliches Vorsorgeprogramm für Erwachsene gibt es in Montenegro nicht — die Vorsorgeuntersuchung heißt hier sistematski pregled und wird von Privatkliniken als bezahltes Paket angeboten: Untersuchung beim Allgemeinarzt, EKG, Ultraschall, Basisanalysen. Nach den Erfahrungen von Patienten kostet ein umfassender Besuch mit Untersuchung, Ultraschall und Laborwerten etwa 80–90 €; erweiterte Pakete größerer Kliniken sind teurer.',
			LtcCheckup2:
				'Check-up-Pakete für Frauen und Männer bieten regelmäßig die großen Ketten (zum Beispiel Moj Lab), Polikliniken wie Milmedika und Häuser vom Rang des Codra Hospital an. Wer eine freiwillige Versicherung hat, sollte die Bedingungen prüfen: Bei Uniqa ließ sich beispielsweise zu jedem Paket ein jährlicher sistematski pregled im Wert von bis zu 100 € hinzubuchen, der das Policenlimit nicht verbraucht — Versicherungsbedingungen ändern sich jedoch, prüfen Sie den aktuellen Stand vorab bei Uniqa oder Ihrem Vermittler.',
			LtcCheckup3:
				'Die Budget-Variante: den Check-up selbst aus Laborpanels zusammenstellen (Frauen- oder Männer-Panel ~47–52 €) plus eine einzige Konsultation beim Allgemeinarzt zur Besprechung der Ergebnisse.',

			LtcResults1:
				'Befunde werden in der Landessprache (in lateinischer Schrift) mit internationalen Parameterkürzeln ausgestellt — LEU, ERY, HGB, GLU und so weiter — und sind damit auch ohne Sprachkenntnisse lesbar. Private Labore schicken ein PDF per E-Mail, staatliche Ergebnisse sind über eZdravlje abrufbar.',
			LtcResults2:
				'Die größte Falle sind Maßeinheiten und Referenzbereiche: Sie können von den gewohnten abweichen. Das klassische Beispiel ist Vitamin D: Lokale Labore geben es meist in ng/ml an, während viele andere Länder nmol/l verwenden (Faktor 2,5) — ein „normaler“ lokaler Wert wird leicht für einen Mangel gehalten und umgekehrt. Vergleichen Sie ein Ergebnis nur mit den Referenzwerten des Labors, das die Analyse durchgeführt hat.',
			LtcResults3:
				'Interpretieren Sie Abweichungen nicht selbst: Eine Konsultation beim Allgemeinarzt oder Facharzt kostet 20–50 €, und der Arzt bewertet die Werte im Kontext Ihrer Beschwerden und Vorgeschichte.',

			LtcSources0:
				'Stand der Informationen: Juli 2026. Die Preise sind Anhaltspunkte aus Laborpreislisten und Patientenerfahrungen 2024–2026 — prüfen Sie vor dem Besuch die aktuelle Preisliste. Offizielle Quellen:',
			LtcSourcesFzo:
				'Krankenversicherungsfonds Montenegros (FZOCG) — Wartelistenregeln und Listen nach Einrichtungen: fzocg.me;',
			LtcSourcesKccg:
				'Klinisches Zentrum Montenegros — veröffentlichte Wartelisten nach Fachgebieten: kccg.me;',
			LtcSourcesEzdravlje:
				'Portal eZdravlje — Terminbuchung, E-Rezepte und Laborergebnisse (eNalaz): ezdravlje.me;',
			LtcSourcesLabs:
				'Preislisten der Labore — veröffentlicht auf den Websites der Ketten, z. B. mojlab.me und invitro.co.me.',
			LtcSourcesCatalog:
				'Sie brauchen einen Arzt, der die Befunde in Ihrer Sprache erklärt? In unserem Katalog sind die Sprachen der Ärzte angegeben —',
			LtcSourcesCatalogLink: 'finden Sie Ihren Arzt',
			LtcSourcesCatalogEnd: '.',

			LtcCtaTitle: 'Vergleichen Sie die Analysepreise',
			LtcCtaText:
				'Der docta.me-Katalog umfasst Hunderte Laboranalysen mit Preisen in Laboren und Kliniken Montenegros — vom Blutbild bis zu Hormonpanels.',
			LtcCtaButton: 'Katalog der Laboranalysen öffnen',
		},
		'tr': {
			LabTestsArticleTitle:
				"Karadağ'da Tahliller ve Check-up: Laboratuvarlar, Fiyatlar, Sevk Gerekmez",
			LabTestsArticleDescription:
				"Karadağ'da tahlil nerede yaptırılır: sevksiz özel laboratuvarlar ve fiyatları, izabrani doktor üzerinden ücretsiz yol, MR ve BT bekleme listeleri, check-up paketleri ve sonuçların nasıl okunacağı. Güncellik: Temmuz 2026.",

			'LtcToc_private-labs': 'Özel laboratuvarlar: sevksiz ve randevusuz',
			'LtcToc_state-route': 'Devlet yolu: uput, ücretsiz ama sıralı',
			'LtcToc_imaging': 'Ultrason, BT ve MR: nerede daha hızlı',
			'LtcToc_checkups': 'Check-up paketleri (sistematski pregled)',
			'LtcToc_results': 'Sonuçlar nasıl okunur: birimler ve referans aralıkları',
			'LtcToc_sources': 'Kaynaklar ve faydalı bağlantılar',

			LtcPrivate1a:
				"Tahlil yaptırmak Karadağ'daki en kolay tıbbi işlerden biridir: özel laboratuvara sevksiz, randevusuz ve sigortasız gidebilirsiniz. Geliş sırasına göre çalışılır — çoğu zaman sıra hiç olmaz; temel tahlillerin sonuçları aynı gün hazırdır ve e-postayla gelir. En büyük zincir ",
			LtcPrivate1MojLabLink: "Moj Lab'dır",
			LtcPrivate1b: " (Podgorica ve Budva'dan Ulcinj'e dokuz şehir); Podgorica'da ",
			LtcPrivate1InVitroLink: 'In Vitro',
			LtcPrivate1c: ' ve ',
			LtcPrivate1BonaLabLink: 'Bona-lab prima',
			LtcPrivate1d: ' çalışır, birçok polikliniğin (',
			LtcPrivate1KonzilijumLink: 'Konzilijum',
			LtcPrivate1e: ', ',
			LtcPrivate1MilmedikaLink: 'Milmedika',
			LtcPrivate1f:
				") de kendi laboratuvarı vardır. Bar'da da kendi büyük laboratuvarları var — ",
			LtcPrivate1ZejnilovicLink: 'Zejnilović',
			LtcPrivate1g: ' ve ',
			LtcPrivate1NoviStandardLink: 'Novi Standard',
			LtcPrivate1h: '.',
			LtcPrivate2a:
				'Fiyatlar her parametre için ayrı hesaplanır. 2025–2026 fiyat listelerinden örnekler: ',
			LtcPrivate2CbcLink: 'tam kan sayımı',
			LtcPrivate2b: ' ~5 €, ',
			LtcPrivate2GlucoseLink: 'glukoz',
			LtcPrivate2c: ' ~2 €, ',
			LtcPrivate2CholesterolLink: 'kolesterol',
			LtcPrivate2d: ' ~3 €, ',
			LtcPrivate2BiochemistryLink: 'standart biyokimya parametreleri',
			LtcPrivate2e: ' kalem başına 1,5–3 €, ',
			LtcPrivate2TshLink: 'TSH',
			LtcPrivate2f: ' ve ',
			LtcPrivate2HormonesLink: 'tiroid hormonları',
			LtcPrivate2g: ' 5–10 €, ',
			LtcPrivate2VitaminDLink: 'D vitamini',
			LtcPrivate2h: ' ~20 €, ',
			LtcPrivate2TumorMarkersLink: 'tümör belirteçleri',
			LtcPrivate2i:
				' her biri ~13 €. Evde kan alma hizmeti yaklaşık 10 € tutar.',
			LtcPrivate3:
				"Başka ülkelerden alışıldık tek kalem 'kapsamlı biyokimya' fiyat listesinde hiç olmayabilir — parametreler tek tek seçilir, bu yüzden listeyi önceden doktorunuzla netleştirmek en iyisidir. Alternatif hazır panellerdir: temel biyokimya ~30 €, tiroid 13–52 € (hormon setine göre), kadın paneli ~47 €, erkek paneli ~52 €, çocuk paneli ~20 €, alerji panelleri 33–43 €.",
			LtcPrivate4:
				'Belirli tahlillerin laboratuvar ve kliniklerdeki fiyatlarını',
			LtcPrivate4Link: 'tahlil kataloğumuzda',
			LtcPrivate4End: ' kolayca karşılaştırabilirsiniz.',

			LtcState1:
				"Zdravstvena knjižica ile tahliller ücretsizdir: bunları dom zdravlja'daki izabrani doktor'unuz ister. Kan sabah orada alınır; tam kan sayımı (KKS) genellikle aynı gün öğleden sonra hazırdır, hormon sonuçları ise bir-iki hafta sürebilir. Sonuçları doktorunuzun hemşiresi verir; ayrıca eZdravlje portalındaki kişisel hesabınızda (eNalaz) görünür.",
			LtcState2:
				"Temel setin ötesindeki her şey için uput gerekir — bunu izabrani doktor genellikle uzman tavsiyesi üzerine yazar. 30 gün içinde yapılamayan acil olmayan tetkikler resmî olarak bekleme listelerine girer — Fon'un kurallarına göre bu, radyolojik tanıyı (BT ve MR) da açıkça kapsar. Listeleri hastanelerin kendileri ve FZOCG yayımlar; listedeki ilerlemenizi kişisel kodla takip edebilirsiniz.",
			LtcState3:
				'Karne olmadan devlet kurumları resmî tarifelerle çalışır — üstelik hastanede her laboratuvar parametresi özel laboratuvardakinden belirgin biçimde pahalı olabilir; sigortasızlar için özel laboratuvarlar genellikle hem daha ucuz hem daha hızlıdır. Devlet tarifeleri ve klinik fiyatları',
			LtcState3Link: 'tıbbi hizmetler kataloğumuzda',
			LtcState3End: ' toplanmıştır.',

			LtcImaging1UzLink: 'Ultrason',
			LtcImaging1a:
				' özel kliniklerde hemen her yerde sevksiz yapılır — çoğu zaman aynı gün. Fiyat aralığı: tetkik başına 20–50 €; uzman muayenesi artı ultrason genellikle 50–90 € tutar.',
			LtcImaging2a: '',
			LtcImaging2MriLink: 'MR',
			LtcImaging2b: ' ve ',
			LtcImaging2CtLink: 'BT',
			LtcImaging2c:
				" de özel sektörde uput'suz erişilebilir: bir bölgenin MR'ı yaklaşık 90–120 €, BT 60–120 € (bölgeye ve kliniğe göre). Cihazlar Podgorica, Budva, Sutomore ve Radanovići'de bulunur; randevu genellikle aylar değil, önümüzdeki günler içindir. Yola çıkmadan arayıp cihazın çalışıp çalışmadığını ve saat kaça kadar çalıştığını sormakta fayda var.",
			LtcImaging3:
				'Karneyle MR ve BT ücretsizdir, ancak en uzun sıralar tam da buradadır: uput ile bekleme listesine girersiniz ve bekleyiş birkaç haftadan aylara uzayabilir. Görüntü raporlarının kalitesi hem özel hem devlet merkezlerinde değişkendir — tetkiki diske yazdırın veya bağlantı isteyin ve tedavi eden doktorunuza gösterin.',
			LtcImaging4: 'Ultrason, BT ve MR yapan klinikleri',
			LtcImaging4Link: 'klinik kataloğunda',
			LtcImaging4End: ' bulabilirsiniz.',

			LtcCheckup1:
				"Karadağ'da yetişkinler için devlet eliyle yürütülen bir tarama programı yoktur — koruyucu muayene burada sistematski pregled olarak adlandırılır ve özel klinikler tarafından ücretli paket olarak sunulur: pratisyen muayenesi, EKG, ultrason, temel tahliller. Hastaların deneyimine göre muayene, ultrason ve tahlilleri içeren kapsamlı bir ziyaret yaklaşık 80–90 € tutar; büyük kliniklerin genişletilmiş paketleri daha pahalıdır.",
			LtcCheckup2:
				"Kadınlar ve erkekler için check-up paketlerini büyük zincirler (örneğin Moj Lab), Milmedika gibi poliklinikler ve Codra Hospital düzeyindeki hastaneler düzenli olarak sunar. Gönüllü sigortanız varsa koşulları kontrol edin: örneğin Uniqa, her pakete poliçe limitini tüketmeyen, 100 €’ya kadar değerde yıllık sistematik muayene eklenmesine izin veriyordu — ancak sigorta koşulları değişebilir, buna güvenmeden önce güncel durumu Uniqa'dan veya acentenizden teyit edin.",
			LtcCheckup3:
				'Bütçe dostu seçenek: check-up’ı laboratuvar panellerinden kendiniz oluşturmak (kadın veya erkek paneli ~47–52 €) ve sonuçları değerlendirmek için tek bir pratisyen muayenesi eklemek.',

			LtcResults1:
				'Sonuçlar yerel dilde (Latin alfabesiyle) ve uluslararası parametre kısaltmalarıyla verilir — LEU, ERY, HGB, GLU vb. — bu yüzden dil bilmeden de okunabilir. Özel laboratuvarlar PDF’i e-postayla gönderir; devlet sonuçlarına eZdravlje üzerinden erişilir.',
			LtcResults2:
				'Asıl tuzak ölçü birimleri ve referans aralıklarıdır: alışık olduklarınızdan farklı olabilir. Klasik örnek D vitaminidir: yerel laboratuvarlar genellikle ng/ml kullanırken birçok başka ülke nmol/l kullanır (katsayı 2,5) — “normal” bir yerel değeri eksiklik sanmak (ya da tersi) kolaydır. Sonucu yalnızca tahlili yapan laboratuvarın referans aralıklarıyla karşılaştırın.',
			LtcResults3:
				'Sapmaları kendi başınıza yorumlamayın: pratisyen veya uzman muayenesi 20–50 € tutar ve doktor sonuçları şikâyetleriniz ve geçmişiniz bağlamında değerlendirir.',

			LtcSources0:
				'Bilgiler Temmuz 2026 itibarıyla günceldir. Fiyatlar, 2024–2026 laboratuvar fiyat listelerinden ve hasta deneyimlerinden alınan referans değerlerdir — ziyaretten önce güncel fiyat listesini kontrol edin. Resmî kaynaklar:',
			LtcSourcesFzo:
				'Karadağ Sağlık Sigortası Fonu (FZOCG) — bekleme listesi kuralları ve kurumlara göre listeler: fzocg.me;',
			LtcSourcesKccg:
				'Karadağ Klinik Merkezi — alanlara göre yayımlanan bekleme listeleri: kccg.me;',
			LtcSourcesEzdravlje:
				'eZdravlje portalı — randevu, e-reçete ve tahlil sonuçları (eNalaz): ezdravlje.me;',
			LtcSourcesLabs:
				'Laboratuvar fiyat listeleri — zincirlerin sitelerinde yayımlanır, örn. mojlab.me ve invitro.co.me.',
			LtcSourcesCatalog:
				'Sonuçları kendi dilinizde açıklayacak bir doktor mu lazım? Kataloğumuzda doktorların konuştuğu diller belirtilir —',
			LtcSourcesCatalogLink: 'doktorunuzu bulun',
			LtcSourcesCatalogEnd: '.',

			LtcCtaTitle: 'Tahlil fiyatlarını karşılaştırın',
			LtcCtaText:
				"docta.me kataloğunda Karadağ'daki laboratuvar ve kliniklerdeki fiyatlarıyla yüzlerce tahlil var — tam kan sayımından hormon panellerine.",
			LtcCtaButton: 'Tahlil kataloğunu aç',
		},
	},
};
