// Контент статьи «Анализы и чекапы в Черногории: лаборатории, цены, без направления».
// Факты сверены с правилником FZOCG о листах ожидания (КТ/МРТ в списке услуг),
// прайс-листами лабораторий (invitro.co.me, mojlab.me), условиями Uniqa
// и данными русскоязычных чатов о реальном опыте (2023–2026). Актуальность: июль 2026.
export default {
	messages: {
		en: {
			LabTestsArticleTitle:
				'Lab Tests and Check-ups in Montenegro: Labs, Prices and Referrals',
			LabTestsArticleDescription:
				'Routine private laboratory tests, current price guidance, which tests may need a clinician order, the state route through izabrani doktor, CT and MRI access, preventive screening and safe interpretation. Reviewed July 2026.',

			'LtcToc_private-labs': 'Private labs: routine tests and referral rules',
			'LtcToc_state-route': 'The state route: uput, free, but with queues',
			LtcToc_imaging: 'Ultrasound, CT and MRI: where it is faster',
			LtcToc_checkups: 'Check-up packages (sistematski pregled)',
			LtcToc_results: 'How to read results: units and reference ranges',
			LtcToc_sources: 'Sources and useful links',

			LtcPrivate1:
				'Many private laboratories accept self-paying patients for common routine blood and urine tests without a referral or insurance, often by walk-in. Booking, preparation, turnaround and referral requirements vary; specialised, genetic, pathology and clinically interpreted tests may require an order or consultation. Confirm fasting and sample instructions with the laboratory before attending.',
			LtcPrivate2:
				'Prices are charged per parameter. Reference points from 2025–2026 price lists: complete blood count ~5 €, glucose ~2 €, cholesterol ~3 €, standard biochemistry parameters 1.5–3 € each, TSH and thyroid hormones 5–10 €, vitamin D ~20 €, tumor markers ~13 € each. A home visit for a blood draw costs about 10 €.',
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

			LtcImaging1:
				'Private clinics commonly offer ultrasound, but same-day access and the need for a referral depend on the clinic and examination. Ask who performs and reports the study, what preparation is needed, whether a clinician request is required and the current price before booking.',
			LtcImaging2:
				'Private CT and MRI are available by appointment, but a clinic may require a referral, clinical question, recent creatinine or other documents. CT uses ionising radiation; contrast CT or MRI has additional kidney, allergy and pregnancy considerations, while MRI requires metal and implant screening. Confirm the scanner, protocol, preparation and total price in advance.',
			LtcImaging3:
				'With a knjižica, MRI and CT are free, but this is exactly where the queues are longest: with an uput you join a waiting list, and the wait can range from several weeks to months. The quality of the written report varies in both private and state centers — ask for the scan on a disc or a download link and show it to your treating doctor.',
			LtcImaging4: 'Clinics with ultrasound, CT and MRI can be found in the',
			LtcImaging4Link: 'clinics catalog',
			LtcImaging4End: '.',

			LtcCheckup1:
				'Montenegro does not offer one universal annual adult check-up for everyone, but targeted public screening and preventive programmes may exist for eligible age or risk groups. Ask the izabrani doktor or current public-health programme about eligibility. Private clinics sell sistematski pregled packages, with contents and prices that vary from clinic to clinic.',
			LtcCheckup2:
				'Laboratories and clinics sell women, men and general check-up packages. Before purchasing, compare each included test with age, symptoms, family history and previous results; more tests are not automatically better and can lead to incidental findings.',
			LtcCheckup3:
				'A review appointment with a doctor helps interpret the results and decide whether any follow-up is actually needed.',

			LtcResults1:
				'Results are issued in Serbian (Latin script) with international parameter abbreviations — LEU, ERY, HGB, GLU and so on — so they are readable even without the language. Private labs send a PDF by e-mail; state results are available via eZdravlje.',
			LtcResults2:
				'The main trap is units of measurement and reference ranges: they may differ from what you are used to. The classic example is vitamin D: local labs usually report it in ng/ml, while many other countries use nmol/l (a factor of 2.5) — a “normal” local value is easy to mistake for a deficiency and vice versa. Always compare a result only against the reference ranges of the lab that ran the test.',
			LtcResults3:
				'Abnormal values are best discussed with a doctor: a GP or specialist consultation costs 20–50 €, and they will read the results in the context of your symptoms and history.',

			LtcSources0:
				'The information is current as of July 2026. Prices are reference points from lab price lists and patient experience in 2024–2026 — check the current price list before your visit. Official sources:',
			LtcSourcesFzo:
				'Health Insurance Fund of Montenegro (FZOCG) — waiting-list rules and lists by institution: fzocg.me;',
			LtcSourcesKccg:
				'Clinical Center of Montenegro — published waiting lists by specialty: kccg.me;',
			LtcSourcesEzdravlje:
				'eZdravlje portal — booking, e-prescriptions and lab results (eNalaz): ezdravlje.me;',
			LtcSourcesUniqa:
				'Uniqa — voluntary health insurance with an annual check-up option: uniqa.me;',
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
		ru: {
			LabTestsArticleTitle:
				'Анализы и чекапы в Черногории: лаборатории, цены и направления',
			LabTestsArticleDescription:
				'Рутинные анализы в частных лабораториях, ориентиры цен, когда нужно назначение врача, бесплатный маршрут через izabrani doktor, КТ и МРТ, профилактический скрининг и безопасный разбор результатов. Проверено в июле 2026 года.',

			'LtcToc_private-labs':
				'Частные лаборатории: рутинные анализы и направления',
			'LtcToc_state-route':
				'Государственный путь: uput, бесплатно, но с очередями',
			LtcToc_imaging: 'УЗИ, КТ и МРТ: где быстрее',
			LtcToc_checkups: 'Чекап-пакеты (sistematski pregled)',
			LtcToc_results: 'Как читать результаты: единицы и референсы',
			LtcToc_sources: 'Источники и полезные ссылки',

			LtcPrivate1:
				'Многие частные лаборатории принимают платных пациентов на распространённые анализы крови и мочи без направления и страховки, часто без записи. Но запись, подготовка, срок готовности и необходимость назначения различаются; специализированные, генетические, патоморфологические и требующие клинической интерпретации исследования могут потребовать направление или консультацию. До визита уточните у лаборатории голодание и правила забора.',
			LtcPrivate2:
				'Цены считаются за каждый показатель отдельно. Ориентиры по прайсам 2025–2026 годов: общий анализ крови ~5 €, глюкоза ~2 €, холестерин ~3 €, стандартные биохимические показатели по 1,5–3 € за позицию, ТТГ и гормоны щитовидной железы 5–10 €, витамин D ~20 €, онкомаркеры ~13 € за каждый. Выезд на дом для забора крови стоит около 10 €.',
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

			LtcImaging1:
				'Частные клиники часто предлагают УЗИ, но приём в тот же день и необходимость направления зависят от учреждения и вида исследования. До записи спросите, кто выполняет и описывает УЗИ, нужна ли подготовка и заявка врача и какова полная актуальная цена.',
			LtcImaging2:
				'КТ и МРТ доступны в частном секторе по записи, но клиника может запросить направление, клинический вопрос, свежий креатинин или другие документы. КТ использует ионизирующее излучение; контраст для КТ или МРТ требует учёта функции почек, аллергий и беременности, а перед МРТ проверяют металл и импланты. Заранее уточните аппарат, протокол, подготовку и полную цену.',
			LtcImaging3:
				'По книжице МРТ и КТ бесплатны, но именно на них очереди самые заметные: с uput вы попадаете в лист ожидания, и ждать можно от нескольких недель до месяцев. Качество описания снимков различается и в частных, и в государственных центрах — попросите записать исследование на диск или прислать ссылку и покажите его лечащему врачу.',
			LtcImaging4: 'Клиники с УЗИ, КТ и МРТ ищите в',
			LtcImaging4Link: 'каталоге клиник',
			LtcImaging4End: '.',

			LtcCheckup1:
				'Единой ежегодной диспансеризации для всех взрослых в Черногории нет, но для отдельных возрастных групп и рисков могут действовать целевые государственные программы скрининга и профилактики. Право на участие уточняйте у izabrani doktor или в актуальной программе общественного здоровья. Частные клиники продают пакеты sistematski pregled — состав и цена различаются от клиники к клинике.',
			LtcCheckup2:
				'Лаборатории и клиники продают женские, мужские и общие чекап-пакеты. Перед покупкой сопоставьте каждый анализ с возрастом, симптомами, семейным анамнезом и прежними результатами: больше тестов не всегда лучше, а случайные находки могут привести к лишним обследованиям.',
			LtcCheckup3:
				'Отдельный приём для разбора результатов поможет понять, действительно ли нужно дальнейшее обследование.',

			LtcResults1:
				'Результаты выдают на сербском (латиницей) с международными сокращениями показателей — LEU, ERY, HGB, GLU и так далее, так что прочитать их можно и без знания языка. Частные лаборатории присылают PDF на почту, государственные результаты доступны через eZdravlje.',
			LtcResults2:
				'Главная ловушка — единицы измерения и референсные диапазоны: они могут отличаться от привычных вам. Классический пример — витамин D: местные лаборатории обычно считают его в ng/ml, тогда как во многих других странах используют нмоль/л (коэффициент 2,5) — «нормальное» местное значение легко принять за дефицит и наоборот. Сравнивайте результат только с референсами той лаборатории, которая делала анализ.',
			LtcResults3:
				'Отклонения лучше обсудить с врачом: приём терапевта или узкого специалиста стоит 20–50 €, и он оценит результаты в контексте ваших жалоб и истории.',

			LtcSources0:
				'Информация актуальна на июль 2026 года. Цены — ориентиры из прайсов лабораторий и опыта пациентов 2024–2026 годов; перед визитом проверяйте актуальный прайс. Официальные источники:',
			LtcSourcesFzo:
				'Фонд медицинского страхования Черногории (FZOCG) — правила листов ожидания и списки по учреждениям: fzocg.me;',
			LtcSourcesKccg:
				'Клинический центр Черногории — опубликованные листы ожидания по направлениям: kccg.me;',
			LtcSourcesEzdravlje:
				'Портал eZdravlje — запись, электронные рецепты и результаты анализов (eNalaz): ezdravlje.me;',
			LtcSourcesUniqa:
				'Uniqa — добровольные медицинские страховки с опцией годового систематского прегледа: uniqa.me;',
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
		sr: {
			LabTestsArticleTitle:
				'Analize i check-up u Crnoj Gori: laboratorije, cijene i uputi',
			LabTestsArticleDescription:
				'Rutinske privatne analize, orijentiri cijena, kada je potreban nalog ljekara, državni put preko izabranog doktora, CT i MR, preventivni skrining i bezbjedno tumačenje. Provjereno u julu 2026.',

			'LtcToc_private-labs': 'Privatne laboratorije: rutinske analize i uputi',
			'LtcToc_state-route': 'Državni put: uput, besplatno, ali uz redove',
			LtcToc_imaging: 'Ultrazvuk, CT i MR: gdje je brže',
			LtcToc_checkups: 'Check-up paketi (sistematski pregled)',
			LtcToc_results:
				'Kako čitati rezultate: jedinice i referentne vrijednosti',
			LtcToc_sources: 'Izvori i korisni linkovi',

			LtcPrivate1:
				'Mnoge privatne laboratorije primaju pacijente koji sami plaćaju za uobičajene analize krvi i urina bez uputa i osiguranja, često bez zakazivanja. Zakazivanje, priprema, rok i potreba za nalogom razlikuju se; specijalizovani, genetski, patološki i testovi koji traže kliničko tumačenje mogu zahtijevati uput ili konsultaciju. Prije dolaska provjerite gladovanje i uzimanje uzorka.',
			LtcPrivate2:
				'Cijene se računaju po svakom parametru posebno. Orijentiri iz cjenovnika 2025–2026: kompletna krvna slika ~5 €, glukoza ~2 €, holesterol ~3 €, standardni biohemijski parametri po 1,5–3 € po stavci, TSH i hormoni štitne žlijezde 5–10 €, vitamin D ~20 €, tumor markeri ~13 € po svakom. Dolazak na kućnu adresu radi vađenja krvi košta oko 10 €.',
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

			LtcImaging1:
				'Privatne klinike često nude ultrazvuk, ali termin istog dana i potreba za uputom zavise od ustanove i pregleda. Prije zakazivanja pitajte ko radi i opisuje pregled, kakva je priprema, treba li zahtjev ljekara i koja je ukupna cijena.',
			LtcImaging2:
				'Privatni CT i MR dostupni su uz zakazivanje, ali klinika može tražiti uput, kliničko pitanje, svježi kreatinin ili dokumentaciju. CT koristi jonizujuće zračenje; kontrast za CT ili MR zahtijeva procjenu bubrega, alergija i trudnoće, a MR provjeru metala i implantata. Unaprijed provjerite aparat, protokol, pripremu i cijenu.',
			LtcImaging3:
				'Uz knjižicu su MR i CT besplatni, ali su upravo tu redovi najuočljiviji: sa uputom ulazite na listu čekanja, a čeka se od nekoliko nedjelja do nekoliko mjeseci. Kvalitet opisa snimaka razlikuje se i u privatnim i u državnim centrima — tražite da vam snimak narežu na disk ili pošalju link i pokažite ga ljekaru koji vas liječi.',
			LtcImaging4: 'Klinike sa ultrazvukom, CT i MR potražite u',
			LtcImaging4Link: 'katalogu klinika',
			LtcImaging4End: '.',

			LtcCheckup1:
				'Crna Gora nema jedan univerzalni godišnji pregled za sve odrasle, ali mogu postojati ciljani javni skrininzi i preventivni programi za određeni uzrast ili rizik. Pravo provjerite kod izabranog doktora ili u važećem programu javnog zdravlja. Privatni sistematski paketi razlikuju se po sadržaju i cijeni od klinike do klinike.',
			LtcCheckup2:
				'Laboratorije i klinike prodaju ženske, muške i opšte check-up pakete. Svaki test uporedite sa godinama, simptomima, porodičnom istorijom i ranijim nalazima; više testova nije automatski bolje i može otkriti slučajne nalaze.',
			LtcCheckup3:
				'Poseban pregled kod ljekara pomaže da se rezultati protumače i odluči da li je dalje praćenje zaista potrebno.',

			LtcResults1:
				'Rezultati se izdaju na srpskom (latinicom) sa međunarodnim skraćenicama parametara — LEU, ERY, HGB, GLU i tako dalje, pa su čitljivi i bez znanja jezika. Privatne laboratorije šalju PDF na e-mail, državni rezultati dostupni su preko portala eZdravlje.',
			LtcResults2:
				'Glavna zamka su mjerne jedinice i referentne vrijednosti: mogu se razlikovati od onih na koje ste navikli. Klasičan primjer je vitamin D: lokalne laboratorije ga obično iskazuju u ng/ml, dok mnoge druge zemlje koriste nmol/l (koeficijent 2,5) — „normalnu“ lokalnu vrijednost lako je pogrešno protumačiti kao deficit i obrnuto. Rezultat poredite isključivo sa referentnim vrijednostima laboratorije koja je analizu radila.',
			LtcResults3:
				'Odstupanja je bolje razgovoriti sa ljekarom: pregled ljekara opšte prakse ili specijaliste košta 20–50 €, a ljekar će rezultate procijeniti u kontekstu vaših tegoba i istorije bolesti.',

			LtcSources0:
				'Informacije važe za jul 2026. Cijene su orijentiri iz cjenovnika laboratorija i iskustva pacijenata 2024–2026 — prije posjete provjerite aktuelni cjenovnik. Zvanični izvori:',
			LtcSourcesFzo:
				'Fond za zdravstveno osiguranje Crne Gore (FZOCG) — pravila listi čekanja i liste po ustanovama: fzocg.me;',
			LtcSourcesKccg:
				'Klinički centar Crne Gore — objavljene liste čekanja po oblastima: kccg.me;',
			LtcSourcesEzdravlje:
				'Portal eZdravlje — zakazivanje, eRecept i rezultati analiza (eNalaz): ezdravlje.me;',
			LtcSourcesUniqa:
				'Uniqa — dobrovoljna zdravstvena osiguranja sa opcijom godišnjeg sistematskog pregleda: uniqa.me;',
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
				'Анализе и check-up у Црној Гори: лабораторије, цијене и упути',
			LabTestsArticleDescription:
				'Рутинске приватне анализе, оријентири цијена, када је потребан налог љекара, државни пут преко изабраног доктора, CT и MR, превентивни скрининг и безбједно тумачење. Провјерено у јулу 2026.',

			'LtcToc_private-labs': 'Приватне лабораторије: рутинске анализе и упути',
			'LtcToc_state-route': 'Државни пут: упут, бесплатно, али уз редове',
			LtcToc_imaging: 'Ултразвук, ЦТ и МР: гдје је брже',
			LtcToc_checkups: 'Check-up пакети (систематски преглед)',
			LtcToc_results:
				'Како читати резултате: јединице и референтне вриједности',
			LtcToc_sources: 'Извори и корисни линкови',

			LtcPrivate1:
				'Многе приватне лабораторије примају пацијенте који сами плаћају за уобичајене анализе крви и урина без упута и осигурања, често без заказивања. Заказивање, припрема, рок и потреба за налогом разликују се; специјализовани, генетски, патолошки и тестови који траже клиничко тумачење могу захтијевати упут или консултацију. Прије доласка провјерите гладовање и узимање узорка.',
			LtcPrivate2:
				'Цијене се рачунају по сваком параметру посебно. Оријентири из цјеновника 2025–2026: комплетна крвна слика ~5 €, глукоза ~2 €, холестерол ~3 €, стандардни биохемијски параметри по 1,5–3 € по ставци, TSH и хормони штитне жлијезде 5–10 €, витамин D ~20 €, тумор маркери ~13 € по сваком. Долазак на кућну адресу ради вађења крви кошта око 10 €.',
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

			LtcImaging1:
				'Приватне клинике често нуде ултразвук, али термин истог дана и потреба за упутом зависе од установе и прегледа. Прије заказивања питајте ко ради и описује преглед, каква је припрема, треба ли захтјев љекара и која је укупна цијена.',
			LtcImaging2:
				'Приватни CT и MR доступни су уз заказивање, али клиника може тражити упут, клиничко питање, свјежи креатинин или документацију. CT користи јонизујуће зрачење; контраст за CT или MR захтијева процјену бубрега, алергија и трудноће, а MR провјеру метала и имплантата. Унапријед провјерите апарат, протокол, припрему и цијену.',
			LtcImaging3:
				'Уз књижицу су МР и ЦТ бесплатни, али су управо ту редови најуочљивији: са упутом улазите на листу чекања, а чека се од неколико недјеља до неколико мјесеци. Квалитет описа снимака разликује се и у приватним и у државним центрима — тражите да вам снимак нарежу на диск или пошаљу линк и покажите га љекару који вас лијечи.',
			LtcImaging4: 'Клинике са ултразвуком, ЦТ и МР потражите у',
			LtcImaging4Link: 'каталогу клиника',
			LtcImaging4End: '.',

			LtcCheckup1:
				'Црна Гора нема један универзални годишњи преглед за све одрасле, али могу постојати циљани јавни скрининзи и превентивни програми за одређени узраст или ризик. Право провјерите код изабраног доктора или у важећем програму јавног здравља. Приватни систематски пакети разликују се по садржају и цијени од клинике до клинике.',
			LtcCheckup2:
				'Лабораторије и клинике продају женске, мушке и опште check-up пакете. Сваки тест упоредите са годинама, симптомима, породичном историјом и ранијим налазима; више тестова није аутоматски боље и може открити случајне налазе.',
			LtcCheckup3:
				'Посебан преглед код љекара помаже да се резултати протумаче и одлучи да ли је даље праћење заиста потребно.',

			LtcResults1:
				'Резултати се издају на српском (латиницом) са међународним скраћеницама параметара — LEU, ERY, HGB, GLU и тако даље, па су читљиви и без знања језика. Приватне лабораторије шаљу PDF на e-mail, државни резултати доступни су преко портала eZdravlje.',
			LtcResults2:
				'Главна замка су мјерне јединице и референтне вриједности: могу се разликовати од оних на које сте навикли. Класичан примјер је витамин D: локалне лабораторије га обично исказују у ng/ml, док многе друге земље користе nmol/l (коефицијент 2,5) — „нормалну“ локалну вриједност лако је погрешно протумачити као дефицит и обрнуто. Резултат поредите искључиво са референтним вриједностима лабораторије која је анализу радила.',
			LtcResults3:
				'Одступања је боље разговорити са љекаром: преглед љекара опште праксе или специјалисте кошта 20–50 €, а љекар ће резултате процијенити у контексту ваших тегоба и историје болести.',

			LtcSources0:
				'Информације важе за јул 2026. Цијене су оријентири из цјеновника лабораторија и искуства пацијената 2024–2026 — прије посјете провјерите актуелни цјеновник. Званични извори:',
			LtcSourcesFzo:
				'Фонд за здравствено осигурање Црне Горе (ФЗОЦГ) — правила листи чекања и листе по установама: fzocg.me;',
			LtcSourcesKccg:
				'Клинички центар Црне Горе — објављене листе чекања по областима: kccg.me;',
			LtcSourcesEzdravlje:
				'Портал eZdravlje — заказивање, еРецепт и резултати анализа (eNalaz): ezdravlje.me;',
			LtcSourcesUniqa:
				'Uniqa — добровољна здравствена осигурања са опцијом годишњег систематског прегледа: uniqa.me;',
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
		de: {
			LabTestsArticleTitle:
				'Laboranalysen und Check-ups in Montenegro: Labore, Preise und Überweisungen',
			LabTestsArticleDescription:
				'Übliche private Labortests, Preisrichtwerte, wann eine ärztliche Anordnung nötig ist, der staatliche Weg über izabrani doktor, CT und MRT, Vorsorge und sichere Befundinterpretation. Geprüft im Juli 2026.',

			'LtcToc_private-labs': 'Private Labore: Routinetests und Überweisungen',
			'LtcToc_state-route':
				'Der staatliche Weg: uput, kostenlos, aber mit Wartezeiten',
			LtcToc_imaging: 'Ultraschall, CT und MRT: wo es schneller geht',
			LtcToc_checkups: 'Check-up-Pakete (sistematski pregled)',
			LtcToc_results: 'Befunde richtig lesen: Einheiten und Referenzwerte',
			LtcToc_sources: 'Quellen und nützliche Links',

			LtcPrivate1:
				'Viele Privatlabore nehmen Selbstzahler für übliche Blut- und Urintests ohne Überweisung und Versicherung an, oft ohne Termin. Termin, Vorbereitung, Bearbeitungszeit und Auftragspflicht variieren; Spezial-, Genetik-, Pathologie- und klinisch zu interpretierende Tests können eine Anordnung oder Beratung erfordern. Nüchternheit und Probenanleitung vorher beim Labor klären.',
			LtcPrivate2:
				'Abgerechnet wird pro Parameter. Anhaltspunkte aus den Preislisten 2025–2026: großes Blutbild ~5 €, Glukose ~2 €, Cholesterin ~3 €, biochemische Standardparameter je 1,5–3 €, TSH und Schilddrüsenhormone 5–10 €, Vitamin D ~20 €, Tumormarker je ~13 €. Ein Hausbesuch zur Blutentnahme kostet etwa 10 €.',
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

			LtcImaging1:
				'Privatkliniken bieten häufig Ultraschall an, doch Termin am selben Tag und Überweisungspflicht hängen von Einrichtung und Untersuchung ab. Vor Buchung fragen, wer untersucht und befundet, welche Vorbereitung und ärztliche Anforderung nötig sind und wie hoch der Gesamtpreis ist.',
			LtcImaging2:
				'Private CT und MRT sind nach Termin verfügbar, doch die Klinik kann Überweisung, klinische Frage, aktuelles Kreatinin oder Unterlagen verlangen. CT verwendet ionisierende Strahlung; Kontrast bei CT oder MRT erfordert Prüfung von Niere, Allergien und Schwangerschaft, MRT zudem von Metall und Implantaten. Gerät, Protokoll, Vorbereitung und Gesamtpreis vorher bestätigen.',
			LtcImaging3:
				'Mit knjižica sind MRT und CT kostenlos, aber genau hier sind die Wartezeiten am längsten: Mit dem uput kommen Sie auf eine Warteliste, und das Warten kann mehrere Wochen bis Monate dauern. Die Qualität der schriftlichen Befunde schwankt in privaten wie staatlichen Zentren — lassen Sie sich die Aufnahmen auf einer CD oder als Download-Link geben und zeigen Sie sie Ihrem behandelnden Arzt.',
			LtcImaging4: 'Kliniken mit Ultraschall, CT und MRT finden Sie im',
			LtcImaging4Link: 'Klinikkatalog',
			LtcImaging4End: '.',

			LtcCheckup1:
				'Montenegro hat keine einheitliche jährliche Vorsorge für alle Erwachsenen, doch zielgerichtete öffentliche Screening- und Präventionsprogramme können für bestimmte Alters- oder Risikogruppen bestehen. Anspruch beim izabrani doktor oder aktuellen Gesundheitsprogramm prüfen. Private sistematski-Pakete unterscheiden sich in Inhalt und Preis von Klinik zu Klinik.',
			LtcCheckup2:
				'Labore und Kliniken verkaufen Frauen-, Männer- und allgemeine Check-up-Pakete. Jeden Test mit Alter, Symptomen, Familienanamnese und Vorbefunden abgleichen; mehr Tests sind nicht automatisch besser und können Zufallsbefunde erzeugen.',
			LtcCheckup3:
				'Ein Besprechungstermin beim Arzt hilft, die Ergebnisse einzuordnen und zu klären, ob Nachuntersuchungen wirklich nötig sind.',

			LtcResults1:
				'Befunde werden auf Serbisch (in lateinischer Schrift) mit internationalen Parameterkürzeln ausgestellt — LEU, ERY, HGB, GLU und so weiter — und sind damit auch ohne Sprachkenntnisse lesbar. Private Labore schicken ein PDF per E-Mail, staatliche Ergebnisse sind über eZdravlje abrufbar.',
			LtcResults2:
				'Die größte Falle sind Maßeinheiten und Referenzbereiche: Sie können von den gewohnten abweichen. Das klassische Beispiel ist Vitamin D: Lokale Labore geben es meist in ng/ml an, während viele andere Länder nmol/l verwenden (Faktor 2,5) — ein „normaler“ lokaler Wert wird leicht für einen Mangel gehalten und umgekehrt. Vergleichen Sie ein Ergebnis nur mit den Referenzwerten des Labors, das die Analyse durchgeführt hat.',
			LtcResults3:
				'Abweichungen bespricht man am besten mit einem Arzt: Eine Konsultation beim Allgemeinarzt oder Facharzt kostet 20–50 €, und er bewertet die Werte im Kontext Ihrer Beschwerden und Vorgeschichte.',

			LtcSources0:
				'Stand der Informationen: Juli 2026. Die Preise sind Anhaltspunkte aus Laborpreislisten und Patientenerfahrungen 2024–2026 — prüfen Sie vor dem Besuch die aktuelle Preisliste. Offizielle Quellen:',
			LtcSourcesFzo:
				'Krankenversicherungsfonds Montenegros (FZOCG) — Wartelistenregeln und Listen nach Einrichtungen: fzocg.me;',
			LtcSourcesKccg:
				'Klinisches Zentrum Montenegros — veröffentlichte Wartelisten nach Fachgebieten: kccg.me;',
			LtcSourcesEzdravlje:
				'Portal eZdravlje — Terminbuchung, E-Rezepte und Laborergebnisse (eNalaz): ezdravlje.me;',
			LtcSourcesUniqa:
				'Uniqa — freiwillige Krankenversicherungen mit jährlicher Check-up-Option: uniqa.me;',
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
		tr: {
			LabTestsArticleTitle:
				'Karadağ Tahlilleri ve Check-up: Laboratuvarlar, Fiyatlar ve Sevk',
			LabTestsArticleDescription:
				'Rutin özel testler, fiyat göstergeleri, hekim isteminin ne zaman gerektiği, izabrani doktor üzerinden devlet yolu, BT ve MR, koruyucu tarama ve güvenli sonuç yorumu. Temmuz 2026 tarihinde incelendi.',

			'LtcToc_private-labs':
				'Özel laboratuvarlar: rutin testler ve sevk kuralları',
			'LtcToc_state-route': 'Devlet yolu: uput, ücretsiz ama sıralı',
			LtcToc_imaging: 'Ultrason, BT ve MR: nerede daha hızlı',
			LtcToc_checkups: 'Check-up paketleri (sistematski pregled)',
			LtcToc_results: 'Sonuçlar nasıl okunur: birimler ve referans aralıkları',
			LtcToc_sources: 'Kaynaklar ve faydalı bağlantılar',

			LtcPrivate1:
				'Birçok özel laboratuvar yaygın kan ve idrar testlerinde kendi ödeyen hastaları sevksiz ve sigortasız, çoğu kez randevusuz kabul eder. Randevu, hazırlık, sonuç süresi ve istem gereği değişir; uzmanlık, genetik, patoloji ve klinik yorum gerektiren testler sevk veya görüşme isteyebilir. Açlık ve örnek kurallarını önceden laboratuvardan doğrulayın.',
			LtcPrivate2:
				'Fiyatlar her parametre için ayrı hesaplanır. 2025–2026 fiyat listelerinden örnekler: tam kan sayımı ~5 €, glukoz ~2 €, kolesterol ~3 €, standart biyokimya parametreleri kalem başına 1,5–3 €, TSH ve tiroid hormonları 5–10 €, D vitamini ~20 €, tümör belirteçleri her biri ~13 €. Evde kan alma hizmeti yaklaşık 10 € tutar.',
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

			LtcImaging1:
				'Özel klinikler sıkça ultrason sunar, ancak aynı gün erişim ve sevk gereği kuruma ve incelemeye bağlıdır. Randevudan önce kimin çekip raporladığını, hazırlığı, hekim istemi gereğini ve toplam güncel fiyatı sorun.',
			LtcImaging2:
				'Özel BT ve MR randevuyla bulunur, ancak klinik sevk, klinik soru, yeni kreatinin veya belge isteyebilir. BT iyonlaştırıcı radyasyon kullanır; BT veya MR kontrastı böbrek, alerji ve gebelik değerlendirmesi, MR ise metal ve implant taraması gerektirir. İnceleme ve kontrast gereğini nitelikli hekim belirlemelidir. Cihazı, protokolü, hazırlığı ve toplam fiyatı önceden doğrulayın.',
			LtcImaging3:
				'Karneyle MR ve BT ücretsizdir, ancak en uzun sıralar tam da buradadır: uput ile bekleme listesine girersiniz ve bekleyiş birkaç haftadan aylara uzayabilir. Görüntü raporlarının kalitesi hem özel hem devlet merkezlerinde değişkendir — tetkiki diske yazdırın veya bağlantı isteyin ve tedavi eden doktorunuza gösterin.',
			LtcImaging4: 'Ultrason, BT ve MR yapan klinikleri',
			LtcImaging4Link: 'klinik kataloğunda',
			LtcImaging4End: ' bulabilirsiniz.',

			LtcCheckup1:
				'Karadağ tüm yetişkinler için tek evrensel yıllık kontrol sunmaz, ancak belirli yaş veya risk grupları için hedefli kamusal tarama ve korunma programları olabilir. Uygunluğu izabrani doktor veya güncel halk sağlığı programından sorun. Özel sistematski paketleri içerik ve fiyat bakımından değişir ve kişisel önerinin yerini tutmaz.',
			LtcCheckup2:
				'Laboratuvar ve klinikler kadın, erkek ve genel kontrol paketleri satar. Her testi yaş, belirti, aile öyküsü ve önceki sonuçlarla karşılaştırın; daha çok test otomatik olarak daha iyi değildir ve rastlantısal bulgular doğurabilir. Sigorta ekleri ve yıllık haklar değişir; marka örneği yerine güncel yazılı koşulları doğrulayın.',
			LtcCheckup3:
				'Yalnız ticari panelden tarama programı kurmayın. Yaş, cinsiyet, gebelik, aile öyküsü, yaşam tarzı ve belirtilerden başlayıp korunmayı hekimle planlayın. Sonuç görüşmesi gerçekten izlem gerekip gerekmediğini belirlemeye yardımcı olur.',

			LtcResults1:
				'Sonuçlar Sırpça (Latin alfabesiyle) ve uluslararası parametre kısaltmalarıyla verilir — LEU, ERY, HGB, GLU vb. — bu yüzden dil bilmeden de okunabilir. Özel laboratuvarlar PDF’i e-postayla gönderir; devlet sonuçlarına eZdravlje üzerinden erişilir.',
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
			LtcSourcesUniqa:
				'Uniqa — yıllık check-up seçenekli gönüllü sağlık sigortaları: uniqa.me;',
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
