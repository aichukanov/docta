// Контент статьи «Психологи, психиатры и антидепрессанты в Черногории».
// Факты сверены с публичными данными учреждений (Specijalna bolnica za psihijatriju
// Dobrota, KCCG, FZOCG) и данными русскоязычных чатов о реальном опыте (2023–2026).
// Статья — о навигации по системе, без медицинских рекомендаций по подбору
// и дозировке препаратов. Актуальность: июль 2026.
export default {
	messages: {
		en: {
			MentalHealthTitle:
				'Psychologists, psychiatrists and antidepressants in Montenegro',
			MentalHealthDescription:
				'How mental health care works in Montenegro: state mental health centers and psychiatric hospitals, finding a therapist who speaks your language, continuing your medication after relocation, prices with and without the zdravstvena knjižica, and where to turn in a crisis.',

			MhmToc_system: 'How mental health care is organized',
			MhmToc_therapy: 'Therapy: finding a specialist in your language',
			MhmToc_prescriptions: 'Prescriptions: continuing treatment after moving',
			MhmToc_costs: 'What it costs: with and without a knjižica',
			MhmToc_crisis: 'Crisis situations: where to get urgent help',
			MhmToc_sources: 'Useful contacts and sources',

			MhmSystem1:
				'Taking care of your mental health is as normal a part of medicine as treating any other condition, and Montenegro has dedicated public infrastructure for it:',
			MhmSystemLevel1:
				'Centri za mentalno zdravlje — mental health centers within the dom zdravlja primary-care network. Staffing, available services and opening hours vary by municipality. A 2022 review listed services in seven municipalities, but that is a historical snapshot rather than a current directory; confirm the available team and hours with your local dom zdravlja;',
			MhmSystemLevel2:
				'Klinika za psihijatriju of the Clinical Center of Montenegro (KCCG) in Podgorica and the psychiatric ward of the general hospital in Nikšić — inpatient psychiatric treatment;',
			MhmSystemLevel3:
				'Specijalna bolnica za psihijatriju “Dobrota” in Kotor (founded in 1953) — the country’s only specialized psychiatric hospital, which also treats addictions.',
			MhmSystem2:
				'For the insured, care at the mental health centers is free, and in practice the route starts at your izabrani doktor, who issues the referral (uput); prescriptions are then handled electronically. The national mental health strategy (2019–2023, with a follow-up programme announced for 2025–2026) bets on exactly this kind of outpatient care close to home, but the centers remain understaffed. Private psychiatrists see patients in clinics in Podgorica and on the coast without any referral — for many foreigners this is the main option because of language and faster appointments.',
			MhmSystem3:
				'How the state system, the zdravstvena knjižica and the izabrani doktor work in general is covered in our overview of the',
			MhmSystem3Link: 'healthcare system in Montenegro',
			MhmSystem3End: '.',

			MhmTherapy1:
				'A quick note on terms: a psychiatrist is a medical doctor and may diagnose and prescribe. A psychologist is not a physician unless separately medically qualified. “Psychotherapist” describes a type of training and work and may refer to either a physician or a non-physician; prescribing depends on a medical licence, not on the psychotherapist title. Seeing any of them is ordinary self-care, not a “last resort”.',
			MhmTherapy2:
				'State insurance covers psychiatric care — consultations, hospital treatment and medications from the Fund’s list; consultations at the mental health centers are free for the insured too. What is scarce is regular long-term talk therapy: the centers are severely understaffed, so ongoing psychotherapy is almost always private.',
			MhmTherapy3:
				'Russian- and English-speaking psychologists and psychotherapists work in person in several Montenegrin cities and online. Ads and expat-chat reports at the time of review often mentioned €40–60 per session; this is an anecdotal range, not a current quote. Rules for professional titles, licensing and cross-border online practice differ, so check the provider’s base profession, degree, licence or registration where applicable, psychotherapy training, supervision, confidentiality policy and complaint route. Support groups are also reported in Budva and Bar; confirm the current schedule with the organiser.',
			MhmTherapy4: 'You can look for in-person specialists in our ',
			MhmTherapy4Link: 'doctors catalog',
			MhmTherapy4Mid:
				', and clinics with a psychiatrist or psychologist in the ',
			MhmTherapy4ClinicsLink: 'clinics catalog',
			MhmTherapy4End: '.',

			MhmRx1:
				'Antidepressants, anxiolytics, sleep medications and other psychotropic medicines are prescription medicines in Montenegro. A foreign prescription does not guarantee dispensing: some people report that individual pharmacies accepted one, but a pharmacist may refuse and you should not rely on this, especially for psychotropic or controlled medicines. The public system normally uses eRecept, while written prescriptions may also be used where the rules allow. Always discuss starting, changing or stopping treatment with a qualified clinician.',
			MhmRx2:
				'If you are relocating while on treatment, arrange continuity with your prescriber before travel. Carry only a lawful personal-use quantity in original packaging, together with the prescription and a medical report stating the INN in Latin script, dose and treatment history. Check the medicine in our registry and verify current customs rules before crossing the border. Do not stop suddenly, change the dose or substitute a product without clinical advice.',
			MhmRx3:
				'With a knjižica, start with your izabrani doktor. They may refer you to a psychiatrist; the exact prescribing and renewal route depends on the medicine, indication and any specialist-report requirements of the Health Insurance Fund. Covered medicines may be dispensed by a contracted pharmacy, which is not limited to Montefarm. One chat report from late 2023 mentioned a 30-cent co-payment for two packs of sertraline, but that individual example is not a price or coverage promise. Renewal timing follows the prescription and treatment plan.',
			MhmRx4:
				'Without a knjižica, you can request a paid consultation at a dom zdravlja service or a private clinic. Prices previously reported around €20–30 are only indicative; ask for the current fee before the visit. The clinician independently assesses the history and may issue a local prescription, change the plan or refer you to a psychiatrist. The permitted quantity and renewal interval depend on the medicine and clinical plan.',
			MhmRx5:
				'Check the availability and prices of specific medications in our',
			MhmRx5Link: 'medications catalog',
			MhmRx5End: '.',

			MhmCosts1:
				'With a knjižica, coverage depends on current eligibility, referral rules, the contracted provider and whether the medicine and indication meet Fund conditions; co-payments may apply. Confirm the route and cost before non-urgent care.',
			MhmCosts2:
				'Prices reported in expat chats and advertisements are dated estimates, not quotes. Ask the provider for the current consultation fee and what it includes before booking, and check each medicine in our registry and with the dispensing pharmacy.',
			MhmCosts3:
				'Availability of sustained psychotherapy in the public system varies by municipality and capacity. If using a remote therapist in another country, verify qualifications, legal ability to serve you, privacy, emergency arrangements and coordination with any local prescriber; do not split medication decisions across uncoordinated providers.',

			MhmCrisis1:
				'If you or someone nearby has a suicide plan or access to means, has taken an overdose, is experiencing psychosis or severe agitation, or cannot stay safe, do not leave the person alone. Call 112 or 124, go to the nearest hitna pomoć or hospital emergency department, and ask a trusted person to stay until help arrives. Emergency access should not be delayed because of citizenship or insurance, although charges may later depend on status and coverage.',
			MhmCrisis2:
				'At the time of review we could not identify a stable, dedicated national mental-health crisis line; contacts can change, so verify current local information. In an acute crisis use 112 or 124 or go to the nearest emergency service. A mental health center may help during its working hours, but availability varies. Do not rely on an overseas online service as the only emergency route.',
			MhmCrisis3:
				'Reaching out for help is a form of self-care, not weakness. If there is immediate danger, use the emergency route above. If the danger is not immediate, contact a trusted person and a qualified clinician and agree on a safety and follow-up plan.',

			MhmSources0:
				'The information is current as of July 2026. Rules and contacts change — verify with primary sources:',
			MhmSourcesPhones:
				'Emergency numbers: 124 — ambulance, 112 — the single European number;',
			MhmSourcesDobrota:
				'Specijalna bolnica za psihijatriju “Dobrota” (Kotor) — the country’s specialized psychiatric hospital: psihijatrijakotor.com;',
			MhmSourcesKccg:
				'Psychiatric clinic of the Clinical Center of Montenegro (KCCG): kccg.me;',
			MhmSourcesFzo:
				'Health Insurance Fund of Montenegro (FZOCG) — what state insurance covers: fzocg.me;',
			MhmSourcesEzdravlje:
				'eZdravlje portal — e-prescriptions and appointments: ezdravlje.me.',
			MhmSourcesCatalog:
				'Looking for a specialist? In our catalog you can filter doctors by specialty, city and consultation language —',
			MhmSourcesCatalogLink: 'psychiatrists in Montenegro',
			MhmSourcesCatalogEnd: '.',

			MhmCtaTitle: 'Need a psychiatrist or a psychotherapist?',
			MhmCtaText:
				'The catalog lets you filter doctors by city, specialty and consultation language.',
			MhmCtaButton: 'Psychiatrists in Montenegro',
		},
		ru: {
			MentalHealthTitle: 'Психологи, психиатры и антидепрессанты в Черногории',
			MentalHealthDescription:
				'Как устроена помощь в сфере ментального здоровья в Черногории: государственные центры ментального здоровья и психиатрические больницы, поиск терапевта на своём языке, продолжение медикаментозного лечения после переезда, цены с книжицей и без, куда обращаться в кризисной ситуации.',

			MhmToc_system: 'Как устроена помощь в сфере ментального здоровья',
			MhmToc_therapy: 'Терапия: как найти специалиста на своём языке',
			MhmToc_prescriptions: 'Рецепты: как продолжить лечение после переезда',
			MhmToc_costs: 'Сколько это стоит: с книжицей и без',
			MhmToc_crisis: 'Кризисные ситуации: где получить срочную помощь',
			MhmToc_sources: 'Полезные контакты и источники',

			MhmSystem1:
				'Забота о ментальном здоровье — такая же нормальная часть медицины, как лечение любой другой болезни, и в Черногории для неё есть отдельная государственная инфраструктура:',
			MhmSystemLevel1:
				'Centri za mentalno zdravlje — центры ментального здоровья в структуре домов здравля. Состав команды, услуги и часы работы различаются по муниципалитетам. В обзоре 2022 года были перечислены семь муниципалитетов, но это исторический срез, а не актуальный справочник: уточняйте доступных специалистов и расписание в своём доме здравля;',
			MhmSystemLevel2:
				'Klinika za psihijatriju Клинического центра Черногории (KCCG) в Подгорице и психиатрическое отделение общей больницы в Никшиче — стационарное лечение;',
			MhmSystemLevel3:
				'Specijalna bolnica za psihijatriju «Dobrota» в Которе (основана в 1953 году) — единственная специализированная психиатрическая больница страны; здесь же лечат зависимости.',
			MhmSystem2:
				'Для застрахованных помощь в центрах ментального здоровья бесплатна, и на практике маршрут начинается у izabrani doktor — он выписывает направление (uput), дальше рецепты идут электронно. Государственная стратегия защиты ментального здоровья (2019–2023, с продолжением программы на 2025–2026) делает ставку именно на такую амбулаторную помощь рядом с домом, но центрам по-прежнему не хватает специалистов. Частные психиатры принимают в клиниках Подгорицы и на побережье без направления — для многих иностранцев это основной вариант из-за языка и скорости записи.',
			MhmSystem3:
				'Как в целом устроены госсистема, zdravstvena knjižica и izabrani doktor — в нашем обзоре',
			MhmSystem3Link: 'системы здравоохранения Черногории',
			MhmSystem3End: '.',

			MhmTherapy1:
				'Коротко о терминах: психиатр — врач, который может ставить диагноз и назначать препараты. Психолог не является врачом, если отдельно не получил медицинскую квалификацию. «Психотерапевт» — это роль и подготовка: так может работать как врач, так и специалист без медицинской лицензии; право выписывать рецепты зависит именно от врачебной лицензии, а не от названия профессии. Обратиться за помощью — обычная забота о себе, а не «крайняя мера».',
			MhmTherapy2:
				'Государственная страховка покрывает психиатрическую помощь — приёмы, стационар и лекарства из списка фонда; консультации в центрах ментального здоровья для застрахованных тоже бесплатны. Дефицит — в регулярной длительной разговорной терапии: центры серьёзно недоукомплектованы, поэтому постоянная психотерапия почти всегда частная.',
			MhmTherapy3:
				'Русско- и англоязычные психологи и психотерапевты принимают очно в нескольких городах Черногории и онлайн. На момент проверки в объявлениях и чатах часто встречался диапазон 40–60 € за сеанс, но это пользовательские данные, а не актуальная оферта. Правила для профессиональных названий, лицензирования и трансграничной онлайн-практики различаются: проверяйте базовую профессию, диплом, лицензию или регистрацию там, где она требуется, обучение психотерапии, супервизию, конфиденциальность и порядок подачи жалоб. О группах поддержки сообщали в Будве и Баре; расписание уточняйте у организаторов.',
			MhmTherapy4: 'Очных специалистов ищите в нашем ',
			MhmTherapy4Link: 'каталоге врачей',
			MhmTherapy4Mid: ', а клиники с психиатром или психологом — в ',
			MhmTherapy4ClinicsLink: 'каталоге клиник',
			MhmTherapy4End: '.',

			MhmRx1:
				'Антидепрессанты, анксиолитики, снотворные и другие психотропные препараты в Черногории относятся к рецептурным. Иностранный рецепт не гарантирует отпуск: некоторые люди сообщают, что отдельные аптеки его принимали, но фармацевт вправе отказать, и рассчитывать на это не стоит — особенно для психотропных и контролируемых препаратов. В государственной системе обычно действует eRecept; в предусмотренных правилами случаях возможен и письменный рецепт. Начало, замену и отмену лечения обсуждайте с квалифицированным врачом.',
			MhmRx2:
				'Если вы переезжаете на фоне лечения, заранее согласуйте его непрерывность со своим врачом. Везите только разрешённое для личного использования количество в оригинальной упаковке, вместе с рецептом и заключением, где указаны МНН латиницей, дозировка и история лечения. Проверьте препарат в нашем реестре и заранее уточните действующие таможенные правила. Не прекращайте приём резко, не меняйте дозу и не заменяйте препарат без медицинской консультации.',
			MhmRx3:
				'С книжицей начните с izabrani doktor. Он может направить к психиатру; точный порядок назначения и продления зависит от препарата, показания и требований Фонда к заключению специалиста. Покрываемое лекарство можно получить в аптеке, работающей по договору с Фондом, — не только в Montefarm. В одном сообщении из чата конца 2023 года упоминалась доплата 30 центов за две упаковки сертралина, но это частный пример, а не обещание цены или покрытия. Срок продления определяют рецепт и план лечения.',
			MhmRx4:
				'Без книжицы можно обратиться на платный приём в службу дома здравля или частную клинику. Ранее встречавшиеся цены около 20–30 € — лишь ориентир; актуальную стоимость спрашивайте до визита. Врач самостоятельно оценивает историю лечения и может выписать местный рецепт, изменить схему или направить к психиатру. Допустимое количество и срок продления зависят от препарата и клинического плана.',
			MhmRx5: 'Наличие и цены конкретных препаратов проверяйте в нашем',
			MhmRx5Link: 'каталоге лекарств',
			MhmRx5End: '.',

			MhmCosts1:
				'С книжицей покрытие зависит от действующего права, правил направления, договорного учреждения и того, соответствует ли лекарство и показание условиям Фонда; возможны доплаты. До неэкстренного обращения уточняйте маршрут и стоимость.',
			MhmCosts2:
				'Цены из чатов и объявлений — датированные ориентиры, а не оферта. До записи спросите актуальную стоимость консультации и что в неё входит, а конкретное лекарство проверьте в нашем реестре и в аптеке.',
			MhmCosts3:
				'Доступность длительной психотерапии в государственной системе зависит от муниципалитета и нагрузки. При работе с онлайн-терапевтом из другой страны проверяйте квалификацию, законность помощи по месту вашего нахождения, конфиденциальность, план на случай кризиса и координацию с местным врачом; решения о лекарствах не должны приниматься несогласованными специалистами.',

			MhmCrisis1:
				'Если у человека есть план самоубийства или доступ к средствам, произошла передозировка, начался психоз или сильное возбуждение либо человек не может гарантировать собственную безопасность, не оставляйте его одного. Звоните 112 или 124, направляйтесь в ближайшую hitna pomoć или приёмное отделение и попросите близкого побыть рядом до приезда помощи. Доступ к экстренной помощи не следует откладывать из-за гражданства или страховки, однако счёт впоследствии может зависеть от статуса и покрытия.',
			MhmCrisis2:
				'На момент проверки нам не удалось найти стабильную отдельную национальную линию помощи при психическом кризисе; контакты могут меняться, поэтому проверяйте актуальную местную информацию. В остром кризисе звоните 112 или 124 либо направляйтесь в ближайшую экстренную службу. В рабочие часы может помочь центр ментального здоровья, но его доступность зависит от муниципалитета. Не полагайтесь на зарубежный онлайн-сервис как на единственный экстренный маршрут.',
			MhmCrisis3:
				'Попросить о помощи — это забота о себе, а не слабость. При непосредственной опасности используйте экстренный маршрут выше. Если опасность не немедленная, свяжитесь с близким человеком и квалифицированным специалистом и вместе составьте план безопасности и дальнейшей помощи.',

			MhmSources0:
				'Информация актуальна на июль 2026 года. Правила и контакты меняются — сверяйтесь с первоисточниками:',
			MhmSourcesPhones:
				'Экстренные номера: 124 — скорая помощь, 112 — единый европейский номер;',
			MhmSourcesDobrota:
				'Specijalna bolnica za psihijatriju «Dobrota» (Котор) — специализированная психиатрическая больница страны: psihijatrijakotor.com;',
			MhmSourcesKccg:
				'Клиника психиатрии Клинического центра Черногории (KCCG): kccg.me;',
			MhmSourcesFzo:
				'Фонд медицинского страхования Черногории (FZOCG) — что покрывает госстраховка: fzocg.me;',
			MhmSourcesEzdravlje:
				'Портал eZdravlje — электронные рецепты и запись: ezdravlje.me.',
			MhmSourcesCatalog:
				'Ищете специалиста? В каталоге можно отфильтровать врачей по специальности, городу и языку приёма —',
			MhmSourcesCatalogLink: 'психиатры в Черногории',
			MhmSourcesCatalogEnd: '.',

			MhmCtaTitle: 'Нужен психиатр или психотерапевт?',
			MhmCtaText:
				'В каталоге — врачи с фильтрами по городу, специальности и языку приёма.',
			MhmCtaButton: 'Психиатры в Черногории',
		},
		sr: {
			MentalHealthTitle: 'Psiholozi, psihijatri i antidepresivi u Crnoj Gori',
			MentalHealthDescription:
				'Kako funkcioniše zaštita mentalnog zdravlja u Crnoj Gori: državni centri za mentalno zdravlje i psihijatrijske bolnice, kako naći terapeuta koji govori vaš jezik, nastavak terapije ljekovima nakon preseljenja, cijene sa zdravstvenom knjižicom i bez nje, kome se obratiti u kriznoj situaciji.',

			MhmToc_system: 'Kako je organizovana zaštita mentalnog zdravlja',
			MhmToc_therapy: 'Terapija: kako naći stručnjaka na svom jeziku',
			MhmToc_prescriptions:
				'Recepti: kako nastaviti liječenje nakon preseljenja',
			MhmToc_costs: 'Koliko to košta: sa knjižicom i bez nje',
			MhmToc_crisis: 'Krizne situacije: gdje dobiti hitnu pomoć',
			MhmToc_sources: 'Korisni kontakti i izvori',

			MhmSystem1:
				'Briga o mentalnom zdravlju jednako je normalan dio medicine kao i liječenje bilo koje druge bolesti, a Crna Gora za nju ima posebnu državnu infrastrukturu:',
			MhmSystemLevel1:
				'Centri za mentalno zdravlje dio su mreže domova zdravlja. Sastav tima, dostupne usluge i radno vrijeme razlikuju se po opštinama. Pregled iz 2022. naveo je usluge u sedam opština, ali to je istorijski presjek, a ne aktuelni imenik; provjerite tim i termine u svom domu zdravlja;',
			MhmSystemLevel2:
				'Klinika za psihijatriju Kliničkog centra Crne Gore (KCCG) u Podgorici i psihijatrijsko odjeljenje opšte bolnice u Nikšiću — bolničko liječenje;',
			MhmSystemLevel3:
				'Specijalna bolnica za psihijatriju „Dobrota“ u Kotoru (osnovana 1953) — jedina specijalizovana psihijatrijska bolnica u zemlji; tu se liječe i bolesti zavisnosti.',
			MhmSystem2:
				'Za osigurane je pomoć u centrima za mentalno zdravlje besplatna, a put u praksi počinje kod izabranog doktora — on izdaje uput, recepti dalje idu elektronski. Državna strategija zaštite mentalnog zdravlja (2019–2023, sa nastavkom programa za 2025–2026) računa upravo na ovakvu ambulantnu zaštitu blizu kuće, ali centrima i dalje nedostaju stručnjaci. Privatni psihijatri primaju u klinikama u Podgorici i na primorju bez uputa — za mnoge strance to je glavna opcija zbog jezika i brže dostupnosti termina.',
			MhmSystem3:
				'Kako u cjelini funkcionišu državni sistem, zdravstvena knjižica i izabrani doktor — u našem pregledu',
			MhmSystem3Link: 'zdravstvenog sistema Crne Gore',
			MhmSystem3End: '.',

			MhmTherapy1:
				'Kratko o pojmovima: psihijatar je ljekar i može postaviti dijagnozu i propisati ljekove. Psiholog nije ljekar ako nema i posebnu medicinsku kvalifikaciju. „Psihoterapeut“ opisuje vrstu obuke i rada i može biti ljekar ili stručnjak bez medicinske licence; pravo propisivanja zavisi od ljekarske licence, a ne od naziva psihoterapeut. Traženje pomoći je uobičajena briga o sebi, a ne „krajnja mjera“.',
			MhmTherapy2:
				'Državno osiguranje pokriva psihijatrijsku zaštitu — preglede, bolničko liječenje i ljekove sa liste Fonda; konsultacije u centrima za mentalno zdravlje za osigurane su takođe besplatne. Deficit postoji kod redovne dugotrajne razgovorne terapije: centri su ozbiljno potkapacitirani, pa je stalna psihoterapija gotovo uvijek privatna.',
			MhmTherapy3:
				'Psiholozi i psihoterapeuti koji govore ruski ili engleski rade uživo u više crnogorskih gradova i onlajn. U vrijeme provjere oglasi i iskustva iz četova često su pominjali 40–60 € po seansi; to je anegdotalni raspon, a ne aktuelna ponuda. Pravila za stručna zvanja, licence i prekogranični onlajn rad razlikuju se, zato provjerite osnovnu profesiju, diplomu, licencu ili registraciju gdje je potrebna, psihoterapijsku obuku, superviziju, povjerljivost i način podnošenja prigovora. Grupe podrške prijavljene su u Budvi i Baru; aktuelni raspored provjerite kod organizatora.',
			MhmTherapy4: 'Stručnjake koji primaju uživo potražite u našem ',
			MhmTherapy4Link: 'katalogu doktora',
			MhmTherapy4Mid: ', a klinike sa psihijatrom ili psihologom u ',
			MhmTherapy4ClinicsLink: 'katalogu klinika',
			MhmTherapy4End: '.',

			MhmRx1:
				'Antidepresivi, anksiolitici, ljekovi za spavanje i drugi psihotropni ljekovi u Crnoj Gori izdaju se na recept. Strani recept ne garantuje izdavanje: neki korisnici navode da ga je pojedina apoteka prihvatila, ali farmaceut može odbiti i na to se ne treba oslanjati, naročito kod psihotropnih ili kontrolisanih ljekova. Javni sistem uobičajeno koristi eRecept, dok je pisani recept moguć kada ga pravila dozvoljavaju. Početak, promjenu ili prekid terapije uvijek dogovorite sa kvalifikovanim ljekarom.',
			MhmRx2:
				'Ako se selite tokom liječenja, unaprijed dogovorite kontinuitet sa svojim ljekarom. Nosite samo zakonom dozvoljenu količinu za ličnu upotrebu u originalnom pakovanju, uz recept i izvještaj sa INN nazivom latinicom, dozom i istorijom terapije. Provjerite lijek u našem registru i važeća carinska pravila prije prelaska granice. Ne prekidajte terapiju naglo, ne mijenjajte dozu i ne zamjenjujte preparat bez savjeta ljekara.',
			MhmRx3:
				'Sa knjižicom počnite kod izabranog doktora. On vas može uputiti psihijatru; tačan put propisivanja i obnavljanja zavisi od lijeka, indikacije i zahtjeva Fonda za izvještaj specijaliste. Lijek koji se pokriva može se podići u apoteci sa ugovorom sa Fondom, ne samo u Montefarmu. Jedno iskustvo iz četa krajem 2023. pominjalo je doplatu od 30 centi za dvije kutije sertralina, ali taj pojedinačni primjer nije obećanje cijene ili pokrića. Rok obnove određuju recept i plan liječenja.',
			MhmRx4:
				'Bez knjižice možete zatražiti pregled koji se plaća u službi doma zdravlja ili privatnoj klinici. Ranije pominjane cijene oko 20–30 € samo su orijentacione; aktuelnu cijenu pitajte prije pregleda. Ljekar samostalno procjenjuje istoriju liječenja i može izdati lokalni recept, promijeniti plan ili uputiti psihijatru. Dozvoljena količina i rok obnove zavise od lijeka i kliničkog plana.',
			MhmRx5: 'Dostupnost i cijene konkretnih ljekova provjerite u našem',
			MhmRx5Link: 'katalogu ljekova',
			MhmRx5End: '.',

			MhmCosts1:
				'Sa knjižicom pokriće zavisi od važećeg prava, uputa, ugovorne ustanove i uslova Fonda za lijek i indikaciju; doplate su moguće. Prije nehitne njege provjerite put i trošak.',
			MhmCosts2:
				'Cijene iz četova i oglasa datirani su orijentiri, ne ponuda. Prije zakazivanja pitajte aktuelnu cijenu i šta uključuje, a konkretan lijek provjerite u našem registru i apoteci.',
			MhmCosts3:
				'Dostupnost dugotrajne psihoterapije u javnom sistemu zavisi od opštine i kapaciteta. Kod onlajn terapeuta iz druge države provjerite kvalifikacije, zakonitost rada, privatnost, plan za krizu i koordinaciju sa lokalnim ljekarom; odluke o ljekovima ne treba dijeliti među neusaglašenim pružaocima.',

			MhmCrisis1:
				'Ako osoba ima plan samoubistva ili pristup sredstvima, uzela je prekomjernu dozu, ima psihozu ili jaku uznemirenost ili ne može ostati bezbjedna, ne ostavljajte je samu. Pozovite 112 ili 124, pođite u najbližu hitnu pomoć ili bolnički prijem i zamolite osobu od povjerenja da ostane do dolaska pomoći. Hitni pristup ne treba odlagati zbog državljanstva ili osiguranja, iako kasniji trošak može zavisiti od statusa i pokrića.',
			MhmCrisis2:
				'U vrijeme provjere nijesmo našli stabilnu posebnu nacionalnu liniju za krize mentalnog zdravlja; kontakti se mogu mijenjati, pa provjerite aktuelne lokalne podatke. U akutnoj krizi pozovite 112 ili 124 ili idite u najbližu hitnu službu. Centar za mentalno zdravlje može pomoći u radno vrijeme, ali dostupnost varira. Ne oslanjajte se na strani onlajn servis kao jedini hitni put.',
			MhmCrisis3:
				'Tražiti pomoć znači brinuti o sebi, a ne pokazati slabost. Ako postoji neposredna opasnost, koristite hitni put iznad. Ako opasnost nije neposredna, javite se osobi od povjerenja i kvalifikovanom stručnjaku i zajedno napravite plan bezbjednosti i daljeg praćenja.',

			MhmSources0:
				'Informacije važe za jul 2026. Pravila i kontakti se mijenjaju — provjerite primarne izvore:',
			MhmSourcesPhones:
				'Brojevi za hitne slučajeve: 124 — hitna pomoć, 112 — jedinstveni evropski broj;',
			MhmSourcesDobrota:
				'Specijalna bolnica za psihijatriju „Dobrota“ (Kotor) — specijalizovana psihijatrijska bolnica u zemlji: psihijatrijakotor.com;',
			MhmSourcesKccg:
				'Klinika za psihijatriju Kliničkog centra Crne Gore (KCCG): kccg.me;',
			MhmSourcesFzo:
				'Fond za zdravstveno osiguranje Crne Gore (FZOCG) — šta pokriva državno osiguranje: fzocg.me;',
			MhmSourcesEzdravlje:
				'Portal eZdravlje — eRecept i zakazivanje: ezdravlje.me.',
			MhmSourcesCatalog:
				'Tražite stručnjaka? U katalogu doktore možete filtrirati po specijalnosti, gradu i jeziku pregleda —',
			MhmSourcesCatalogLink: 'psihijatri u Crnoj Gori',
			MhmSourcesCatalogEnd: '.',

			MhmCtaTitle: 'Potreban vam je psihijatar ili psihoterapeut?',
			MhmCtaText:
				'U katalogu su doktori sa filterima po gradu, specijalnosti i jeziku pregleda.',
			MhmCtaButton: 'Psihijatri u Crnoj Gori',
		},
		'sr-cyrl': {
			MentalHealthTitle: 'Психолози, психијатри и антидепресиви у Црној Гори',
			MentalHealthDescription:
				'Како функционише заштита менталног здравља у Црној Гори: државни центри за ментално здравље и психијатријске болнице, како наћи терапеута који говори ваш језик, наставак терапије љековима након пресељења, цијене са здравственом књижицом и без ње, коме се обратити у кризној ситуацији.',

			MhmToc_system: 'Како је организована заштита менталног здравља',
			MhmToc_therapy: 'Терапија: како наћи стручњака на свом језику',
			MhmToc_prescriptions: 'Рецепти: како наставити лијечење након пресељења',
			MhmToc_costs: 'Колико то кошта: са књижицом и без ње',
			MhmToc_crisis: 'Кризне ситуације: гдје добити хитну помоћ',
			MhmToc_sources: 'Корисни контакти и извори',

			MhmSystem1:
				'Брига о менталном здрављу једнако је нормалан дио медицине као и лијечење било које друге болести, а Црна Гора за њу има посебну државну инфраструктуру:',
			MhmSystemLevel1:
				'Центри за ментално здравље дио су мреже домова здравља. Састав тима, доступне услуге и радно вријеме разликују се по општинама. Преглед из 2022. навео је услуге у седам општина, али то је историјски пресјек, а не актуелни именик; провјерите тим и термине у свом дому здравља;',
			MhmSystemLevel2:
				'Клиника за психијатрију Клиничког центра Црне Горе (КЦЦГ) у Подгорици и психијатријско одјељење опште болнице у Никшићу — болничко лијечење;',
			MhmSystemLevel3:
				'Специјална болница за психијатрију „Доброта“ у Котору (основана 1953) — једина специјализована психијатријска болница у земљи; ту се лијече и болести зависности.',
			MhmSystem2:
				'За осигуране је помоћ у центрима за ментално здравље бесплатна, а пут у пракси почиње код изабраног доктора — он издаје упут, рецепти даље иду електронски. Државна стратегија заштите менталног здравља (2019–2023, са наставком програма за 2025–2026) рачуна управо на овакву амбулантну заштиту близу куће, али центрима и даље недостају стручњаци. Приватни психијатри примају у клиникама у Подгорици и на приморју без упута — за многе странце то је главна опција због језика и брже доступности термина.',
			MhmSystem3:
				'Како у цјелини функционишу државни систем, здравствена књижица и изабрани доктор — у нашем прегледу',
			MhmSystem3Link: 'здравственог система Црне Горе',
			MhmSystem3End: '.',

			MhmTherapy1:
				'Кратко о појмовима: психијатар је љекар и може поставити дијагнозу и прописати љекове. Психолог није љекар ако нема и посебну медицинску квалификацију. „Психотерапеут“ описује врсту обуке и рада и може бити љекар или стручњак без медицинске лиценце; право прописивања зависи од љекарске лиценце, а не од назива психотерапеут. Тражење помоћи је уобичајена брига о себи, а не „крајња мјера“.',
			MhmTherapy2:
				'Државно осигурање покрива психијатријску заштиту — прегледе, болничко лијечење и љекове са листе Фонда; консултације у центрима за ментално здравље за осигуране су такође бесплатне. Дефицит постоји код редовне дуготрајне разговорне терапије: центри су озбиљно поткапацитирани, па је стална психотерапија готово увијек приватна.',
			MhmTherapy3:
				'Психолози и психотерапеути који говоре руски или енглески раде уживо у више црногорских градова и онлајн. У вријеме провјере огласи и искуства из четова често су помињали 40–60 € по сеанси; то је анегдотални распон, а не актуелна понуда. Правила за стручна звања, лиценце и прекогранични онлајн рад разликују се, зато провјерите основну професију, диплому, лиценцу или регистрацију гдје је потребна, психотерапијску обуку, супервизију, повјерљивост и начин подношења приговора. Групе подршке пријављене су у Будви и Бару; актуелни распоред провјерите код организатора.',
			MhmTherapy4: 'Стручњаке који примају уживо потражите у нашем ',
			MhmTherapy4Link: 'каталогу доктора',
			MhmTherapy4Mid: ', а клинике са психијатром или психологом у ',
			MhmTherapy4ClinicsLink: 'каталогу клиника',
			MhmTherapy4End: '.',

			MhmRx1:
				'Антидепресиви, анксиолитици, љекови за спавање и други психотропни љекови у Црној Гори издају се на рецепт. Страни рецепт не гарантује издавање: неки корисници наводе да га је поједина апотека прихватила, али фармацеут може одбити и на то се не треба ослањати, нарочито код психотропних или контролисаних љекова. Јавни систем уобичајено користи еРецепт, док је писани рецепт могућ када га правила дозвољавају. Почетак, промјену или прекид терапије увијек договорите са квалификованим љекаром.',
			MhmRx2:
				'Ако се селите током лијечења, унапријед договорите континуитет са својим љекаром. Носите само законом дозвољену количину за личну употребу у оригиналном паковању, уз рецепт и извјештај са INN називом латиницом, дозом и историјом терапије. Провјерите лијек у нашем регистру и важећа царинска правила прије преласка границе. Не прекидајте терапију нагло, не мијењајте дозу и не замјењујте препарат без савјета љекара.',
			MhmRx3:
				'Са књижицом почните код изабраног доктора. Он вас може упутити психијатру; тачан пут прописивања и обнављања зависи од лијека, индикације и захтјева Фонда за извјештај специјалисте. Лијек који се покрива може се подићи у апотеци са уговором са Фондом, не само у Montefarmu. Једно искуство из чета крајем 2023. помињало је доплату од 30 центи за двије кутије сертралина, али тај појединачни примјер није обећање цијене или покрића. Рок обнове одређују рецепт и план лијечења.',
			MhmRx4:
				'Без књижице можете затражити преглед који се плаћа у служби дома здравља или приватној клиници. Раније помињане цијене око 20–30 € само су оријентационе; актуелну цијену питајте прије прегледа. Љекар самостално процјењује историју лијечења и може издати локални рецепт, промијенити план или упутити психијатру. Дозвољена количина и рок обнове зависе од лијека и клиничког плана.',
			MhmRx5: 'Доступност и цијене конкретних љекова провјерите у нашем',
			MhmRx5Link: 'каталогу љекова',
			MhmRx5End: '.',

			MhmCosts1:
				'Са књижицом покриће зависи од важећег права, упута, уговорне установе и услова Фонда за лијек и индикацију; доплате су могуће. Прије нехитне његе провјерите пут и трошак.',
			MhmCosts2:
				'Цијене из четова и огласа датирани су оријентири, не понуда. Прије заказивања питајте актуелну цијену и шта укључује, а конкретан лијек провјерите у нашем регистру и апотеци.',
			MhmCosts3:
				'Доступност дуготрајне психотерапије у јавном систему зависи од општине и капацитета. Код онлајн терапеута из друге државе провјерите квалификације, законитост рада, приватност, план за кризу и координацију са локалним љекаром; одлуке о љековима не треба дијелити међу неусаглашеним пружаоцима.',

			MhmCrisis1:
				'Ако особа има план самоубиства или приступ средствима, узела је прекомјерну дозу, има психозу или јаку узнемиреност или не може остати безбједна, не остављајте је саму. Позовите 112 или 124, пођите у најближу хитну помоћ или болнички пријем и замолите особу од повјерења да остане до доласка помоћи. Хитни приступ не треба одлагати због држављанства или осигурања, иако каснији трошак може зависити од статуса и покрића.',
			MhmCrisis2:
				'У вријеме провјере нијесмо нашли стабилну посебну националну линију за кризе менталног здравља; контакти се могу мијењати, па провјерите актуелне локалне податке. У акутној кризи позовите 112 или 124 или идите у најближу хитну службу. Центар за ментално здравље може помоћи у радно вријеме, али доступност варира. Не ослањајте се на страни онлајн сервис као једини хитни пут.',
			MhmCrisis3:
				'Тражити помоћ значи бринути о себи, а не показати слабост. Ако постоји непосредна опасност, користите хитни пут изнад. Ако опасност није непосредна, јавите се особи од повјерења и квалификованом стручњаку и заједно направите план безбједности и даљег праћења.',

			MhmSources0:
				'Информације важе за јул 2026. Правила и контакти се мијењају — провјерите примарне изворе:',
			MhmSourcesPhones:
				'Бројеви за хитне случајеве: 124 — хитна помоћ, 112 — јединствени европски број;',
			MhmSourcesDobrota:
				'Специјална болница за психијатрију „Доброта“ (Котор) — специјализована психијатријска болница у земљи: psihijatrijakotor.com;',
			MhmSourcesKccg:
				'Клиника за психијатрију Клиничког центра Црне Горе (КЦЦГ): kccg.me;',
			MhmSourcesFzo:
				'Фонд за здравствено осигурање Црне Горе (ФЗОЦГ) — шта покрива државно осигурање: fzocg.me;',
			MhmSourcesEzdravlje:
				'Портал eZdravlje — еРецепт и заказивање: ezdravlje.me.',
			MhmSourcesCatalog:
				'Тражите стручњака? У каталогу докторе можете филтрирати по специјалности, граду и језику прегледа —',
			MhmSourcesCatalogLink: 'психијатри у Црној Гори',
			MhmSourcesCatalogEnd: '.',

			MhmCtaTitle: 'Потребан вам је психијатар или психотерапеут?',
			MhmCtaText:
				'У каталогу су доктори са филтерима по граду, специјалности и језику прегледа.',
			MhmCtaButton: 'Психијатри у Црној Гори',
		},
		de: {
			MentalHealthTitle:
				'Psychologen, Psychiater und Antidepressiva in Montenegro',
			MentalHealthDescription:
				'Wie die psychische Gesundheitsversorgung in Montenegro funktioniert: staatliche Zentren für mentale Gesundheit und psychiatrische Kliniken, einen Therapeuten in Ihrer Sprache finden, die Medikation nach dem Umzug fortsetzen, Preise mit und ohne zdravstvena knjižica und wohin man sich in einer Krise wendet.',

			MhmToc_system: 'So ist die psychische Gesundheitsversorgung organisiert',
			MhmToc_therapy: 'Therapie: einen Spezialisten in Ihrer Sprache finden',
			MhmToc_prescriptions: 'Rezepte: die Behandlung nach dem Umzug fortsetzen',
			MhmToc_costs: 'Was es kostet: mit und ohne knjižica',
			MhmToc_crisis: 'Krisensituationen: wo es dringend Hilfe gibt',
			MhmToc_sources: 'Nützliche Kontakte und Quellen',

			MhmSystem1:
				'Die Sorge um die psychische Gesundheit ist ein ebenso normaler Teil der Medizin wie die Behandlung jeder anderen Erkrankung — und Montenegro hat dafür eine eigene staatliche Infrastruktur:',
			MhmSystemLevel1:
				'Centri za mentalno zdravlje sind Teil des primärärztlichen Netzes der dom zdravlja. Teamzusammensetzung, Leistungen und Öffnungszeiten unterscheiden sich je nach Gemeinde. Eine Übersicht von 2022 nannte Angebote in sieben Gemeinden; das ist jedoch eine historische Momentaufnahme und kein aktuelles Verzeichnis. Erfragen Sie Team und Zeiten beim örtlichen dom zdravlja;',
			MhmSystemLevel2:
				'Die Klinika za psihijatriju des Klinischen Zentrums von Montenegro (KCCG) in Podgorica und die psychiatrische Abteilung des allgemeinen Krankenhauses in Nikšić — stationäre Behandlung;',
			MhmSystemLevel3:
				'Die Specijalna bolnica za psihijatriju „Dobrota“ in Kotor (gegründet 1953) — das einzige spezialisierte psychiatrische Krankenhaus des Landes; hier werden auch Abhängigkeitserkrankungen behandelt.',
			MhmSystem2:
				'Für Versicherte ist die Hilfe in den Zentren für mentale Gesundheit kostenlos, und in der Praxis beginnt der Weg beim izabrani doktor — er stellt die Überweisung (uput) aus, die Rezepte laufen danach elektronisch. Die staatliche Strategie für psychische Gesundheit (2019–2023, mit einem Anschlussprogramm für 2025–2026) setzt genau auf solche wohnortnahe ambulante Versorgung, doch die Zentren bleiben unterbesetzt. Private Psychiater empfangen in Kliniken in Podgorica und an der Küste ohne Überweisung — für viele Ausländer ist das wegen der Sprache und der schnelleren Termine die Hauptoption.',
			MhmSystem3:
				'Wie das staatliche System, die zdravstvena knjižica und der izabrani doktor insgesamt funktionieren, lesen Sie in unserem Überblick über das',
			MhmSystem3Link: 'Gesundheitssystem Montenegros',
			MhmSystem3End: '.',

			MhmTherapy1:
				'Kurz zu den Begriffen: Ein Psychiater ist Arzt und darf diagnostizieren und Medikamente verordnen. Ein Psychologe ist ohne zusätzliche medizinische Qualifikation kein Arzt. „Psychotherapeut“ bezeichnet eine Ausbildung und Tätigkeit und kann ein Arzt oder Nichtarzt sein; die Verordnungsbefugnis richtet sich nach der ärztlichen Zulassung, nicht nach der Bezeichnung Psychotherapeut. Hilfe zu suchen ist normale Selbstfürsorge und kein „letzter Ausweg“.',
			MhmTherapy2:
				'Die staatliche Versicherung deckt die psychiatrische Versorgung ab — Konsultationen, stationäre Behandlung und Medikamente von der Fondsliste; Beratungen in den Zentren für mentale Gesundheit sind für Versicherte ebenfalls kostenlos. Knapp ist die regelmäßige langfristige Gesprächstherapie: Die Zentren sind stark unterbesetzt, daher läuft dauerhafte Psychotherapie fast immer privat.',
			MhmTherapy3:
				'Russisch- und englischsprachige Psychologen und Psychotherapeuten arbeiten in mehreren Städten Montenegros und online. Anzeigen und Expat-Berichte nannten zum Prüfzeitpunkt häufig 40–60 € pro Sitzung; das ist eine anekdotische Spanne und kein aktuelles Angebot. Regeln für Berufsbezeichnungen, Zulassung und grenzüberschreitende Online-Arbeit unterscheiden sich. Prüfen Sie Grundberuf, Abschluss, Zulassung oder Registrierung soweit erforderlich, Psychotherapieausbildung, Supervision, Vertraulichkeit und Beschwerdeweg. Für Budva und Bar wurden Selbsthilfegruppen gemeldet; aktuelle Termine beim Veranstalter erfragen.',
			MhmTherapy4: 'Spezialisten mit Präsenzterminen finden Sie in unserem ',
			MhmTherapy4Link: 'Ärztekatalog',
			MhmTherapy4Mid: ', Kliniken mit Psychiater oder Psychologe im ',
			MhmTherapy4ClinicsLink: 'Klinikkatalog',
			MhmTherapy4End: '.',

			MhmRx1:
				'Antidepressiva, Anxiolytika, Schlafmittel und andere Psychopharmaka sind in Montenegro verschreibungspflichtig. Ein ausländisches Rezept garantiert keine Abgabe: Einzelne Nutzer berichten von einer Annahme durch manche Apotheken, doch der Apotheker darf ablehnen und darauf sollte man sich insbesondere bei psychotropen oder kontrollierten Arzneimitteln nicht verlassen. Im öffentlichen System ist eRecept üblich; ein Papierrezept kann in den gesetzlich vorgesehenen Fällen möglich sein. Beginn, Änderung oder Absetzen der Therapie immer mit einem qualifizierten Arzt besprechen.',
			MhmRx2:
				'Wenn Sie während einer Behandlung umziehen, klären Sie die Weiterbehandlung vor der Reise mit dem verordnenden Arzt. Führen Sie nur eine gesetzlich zulässige Menge für den persönlichen Bedarf in Originalverpackung mit, dazu Rezept und Arztbericht mit INN in lateinischer Schrift, Dosis und Therapieverlauf. Prüfen Sie das Arzneimittel in unserem Register und die aktuellen Zollregeln vor dem Grenzübertritt. Nicht abrupt absetzen, die Dosis ändern oder das Präparat ohne ärztlichen Rat austauschen.',
			MhmRx3:
				'Mit knjižica beginnen Sie beim izabrani doktor. Er kann zum Psychiater überweisen; der genaue Verordnungs- und Verlängerungsweg hängt vom Arzneimittel, der Indikation und den Anforderungen des Fonds an einen Facharztbericht ab. Ein erstattetes Arzneimittel kann in einer Vertragsapotheke abgegeben werden, nicht nur bei Montefarm. Ein Chatbericht von Ende 2023 nannte 30 Cent Zuzahlung für zwei Packungen Sertralin; dieses Einzelbeispiel ist keine Preis- oder Leistungszusage. Fristen richten sich nach Rezept und Behandlungsplan.',
			MhmRx4:
				'Ohne knjižica können Sie eine kostenpflichtige Konsultation bei einem dom zdravlja oder einer Privatklinik anfragen. Früher genannte Preise um 20–30 € sind nur Richtwerte; fragen Sie vor dem Termin nach dem aktuellen Honorar. Der Arzt beurteilt die Vorgeschichte eigenständig und kann ein lokales Rezept ausstellen, den Plan ändern oder zum Psychiater überweisen. Zulässige Menge und Verlängerungsfrist hängen von Arzneimittel und Behandlungsplan ab.',
			MhmRx5:
				'Verfügbarkeit und Preise konkreter Medikamente prüfen Sie in unserem',
			MhmRx5Link: 'Medikamentenkatalog',
			MhmRx5End: '.',

			MhmCosts1:
				'Mit knjižica hängt die Deckung von aktuellem Anspruch, Überweisung, Vertragseinrichtung und den Fondsbedingungen für Arzneimittel und Indikation ab; Zuzahlungen sind möglich. Weg und Kosten vor nicht dringender Versorgung klären.',
			MhmCosts2:
				'Preise aus Chats und Anzeigen sind datierte Richtwerte, kein Angebot. Aktuelles Honorar und Leistungsumfang vor Buchung erfragen und das konkrete Arzneimittel in unserem Register und bei der Apotheke prüfen.',
			MhmCosts3:
				'Verfügbarkeit langfristiger Psychotherapie im öffentlichen System hängt von Gemeinde und Kapazität ab. Bei Online-Therapie aus dem Ausland Qualifikation, rechtliche Zulässigkeit, Datenschutz, Krisenplan und Koordination mit dem lokalen Arzt prüfen; Arzneimittelentscheidungen nicht auf unkoordinierte Anbieter verteilen.',

			MhmCrisis1:
				'Wenn eine Person einen Suizidplan oder Zugang zu Mitteln hat, eine Überdosis genommen hat, psychotisch oder stark erregt ist oder nicht sicher bleiben kann, lassen Sie sie nicht allein. Rufen Sie 112 oder 124, gehen Sie zur nächsten hitna pomoć oder Notaufnahme und bitten Sie eine Vertrauensperson, bis zum Eintreffen der Hilfe zu bleiben. Notfallzugang sollte nicht wegen Staatsangehörigkeit oder Versicherung verzögert werden; spätere Kosten können jedoch von Status und Deckung abhängen.',
			MhmCrisis2:
				'Zum Prüfzeitpunkt konnten wir keine stabile, eigene nationale Krisenhotline für psychische Notlagen ermitteln; Kontakte können sich ändern, daher aktuelle lokale Angaben prüfen. In einer akuten Krise 112 oder 124 anrufen oder zur nächsten Notfallstelle gehen. Ein Zentrum für mentale Gesundheit kann während seiner Öffnungszeiten helfen, doch die Verfügbarkeit variiert. Verlassen Sie sich nicht ausschließlich auf einen ausländischen Online-Dienst.',
			MhmCrisis3:
				'Um Hilfe zu bitten ist Selbstfürsorge, keine Schwäche. Bei unmittelbarer Gefahr nutzen Sie den oben beschriebenen Notfallweg. Ist die Gefahr nicht unmittelbar, wenden Sie sich an eine Vertrauensperson und eine qualifizierte Fachkraft und vereinbaren Sie einen Sicherheits- und Nachsorgeplan.',

			MhmSources0:
				'Stand der Informationen: Juli 2026. Regeln und Kontakte ändern sich — prüfen Sie die Primärquellen:',
			MhmSourcesPhones:
				'Notrufnummern: 124 — Rettungsdienst, 112 — einheitliche europäische Nummer;',
			MhmSourcesDobrota:
				'Specijalna bolnica za psihijatriju „Dobrota“ (Kotor) — das spezialisierte psychiatrische Krankenhaus des Landes: psihijatrijakotor.com;',
			MhmSourcesKccg:
				'Psychiatrische Klinik des Klinischen Zentrums von Montenegro (KCCG): kccg.me;',
			MhmSourcesFzo:
				'Krankenversicherungsfonds Montenegros (FZOCG) — was die staatliche Versicherung abdeckt: fzocg.me;',
			MhmSourcesEzdravlje:
				'Portal eZdravlje — E-Rezepte und Terminbuchung: ezdravlje.me.',
			MhmSourcesCatalog:
				'Sie suchen einen Spezialisten? In unserem Katalog können Sie Ärzte nach Fachrichtung, Stadt und Sprache filtern —',
			MhmSourcesCatalogLink: 'Psychiater in Montenegro',
			MhmSourcesCatalogEnd: '.',

			MhmCtaTitle: 'Sie brauchen einen Psychiater oder Psychotherapeuten?',
			MhmCtaText:
				'Im Katalog finden Sie Ärzte mit Filtern nach Stadt, Fachrichtung und Sprache.',
			MhmCtaButton: 'Psychiater in Montenegro',
		},
		tr: {
			MentalHealthTitle:
				'Karadağ’da psikologlar, psikiyatristler ve antidepresanlar',
			MentalHealthDescription:
				'Karadağ’da ruh sağlığı hizmetleri nasıl işler: devlet ruh sağlığı merkezleri ve psikiyatri hastaneleri, kendi dilinizde terapist bulma, taşındıktan sonra ilaç tedavisine devam etme, zdravstvena knjižica ile ve olmadan fiyatlar, kriz durumunda nereye başvurulur.',

			MhmToc_system: 'Ruh sağlığı hizmetleri nasıl örgütlenmiştir',
			MhmToc_therapy: 'Terapi: kendi dilinizde uzman bulmak',
			MhmToc_prescriptions: 'Reçeteler: taşındıktan sonra tedaviye devam etmek',
			MhmToc_costs: 'Maliyetler: knjižica ile ve olmadan',
			MhmToc_crisis: 'Kriz durumları: acil yardım nereden alınır',
			MhmToc_sources: 'Faydalı iletişim bilgileri ve kaynaklar',

			MhmSystem1:
				'Ruh sağlığına özen göstermek, tıbbın diğer her hastalığın tedavisi kadar olağan bir parçasıdır ve Karadağ’da bunun için ayrı bir devlet altyapısı vardır:',
			MhmSystemLevel1:
				'Centri za mentalno zdravlje, dom zdravlja birinci basamak ağı içindeki ruh sağlığı merkezleridir. Ekip, hizmetler ve çalışma saatleri belediyeye göre değişir. 2022 tarihli bir inceleme yedi belediyedeki hizmetleri sıralamıştı; bu güncel bir rehber değil, tarihsel bir kesittir. Mevcut ekip ve saatleri yerel dom zdravlja’dan doğrulayın;',
			MhmSystemLevel2:
				'Podgorica’daki Karadağ Klinik Merkezi’nin (KCCG) Klinika za psihijatriju’su ve Nikšić genel hastanesinin psikiyatri servisi — yatarak tedavi;',
			MhmSystemLevel3:
				'Kotor’daki Specijalna bolnica za psihijatriju “Dobrota” (1953’te kuruldu) — ülkenin tek uzmanlaşmış psikiyatri hastanesi; bağımlılıklar da burada tedavi edilir.',
			MhmSystem2:
				'Sigortalılar için ruh sağlığı merkezlerindeki yardım ücretsizdir ve pratikte yol izabrani doktor’dan başlar — sevki (uput) o yazar, reçeteler sonrasında elektronik ilerler. Devletin ruh sağlığı stratejisi (2019–2023, 2025–2026 için devam programı duyuruldu) tam da bu tür eve yakın ayaktan bakıma odaklanıyor, ancak merkezlerde personel eksikliği sürüyor. Özel psikiyatristler Podgorica’daki ve sahildeki kliniklerde sevksiz hasta kabul eder — dil ve daha hızlı randevu nedeniyle birçok yabancı için ana seçenek budur.',
			MhmSystem3:
				'Devlet sisteminin, zdravstvena knjižica’nın ve izabrani doktor’un genel olarak nasıl işlediğini',
			MhmSystem3Link: 'Karadağ sağlık sistemi rehberimizde',
			MhmSystem3End: ' bulabilirsiniz.',

			MhmTherapy1:
				'Terimler hakkında kısaca: psikiyatrist bir hekimdir; tanı koyabilir ve ilaç yazabilir. Psikolog, ayrıca tıbbi yeterliliği yoksa hekim değildir. “Psikoterapist” bir eğitim ve çalışma türünü anlatır; hekim veya hekim olmayan bir uzman olabilir. Reçete yazma yetkisi psikoterapist unvanına değil, hekimlik ruhsatına bağlıdır. Yardım istemek sıradan bir öz bakımdır, “son çare” değildir.',
			MhmTherapy2:
				'Devlet sigortası psikiyatrik bakımı kapsar — muayeneler, yatarak tedavi ve Fon listesindeki ilaçlar; ruh sağlığı merkezlerindeki görüşmeler de sigortalılar için ücretsizdir. Kıt olan, düzenli uzun süreli konuşma terapisidir: merkezlerde ciddi personel eksikliği vardır, bu yüzden sürekli psikoterapi neredeyse her zaman özeldir.',
			MhmTherapy3:
				'Rusça veya İngilizce konuşan psikologlar ve psikoterapistler Karadağ’ın çeşitli şehirlerinde ve çevrimiçi çalışır. İnceleme sırasında ilanlar ve göçmen sohbetleri seans başına sıkça 40–60 € aralığını anıyordu; bu güncel fiyat teklifi değil, kullanıcı bildirimidir. Mesleki unvan, ruhsat ve sınır ötesi çevrimiçi çalışma kuralları değişir. Temel mesleği, diplomayı, gerektiğinde ruhsat veya kaydı, psikoterapi eğitimini, süpervizyonu, gizlilik politikasını ve şikâyet yolunu kontrol edin. Budva ve Bar’da destek grupları bildirildi; güncel programı düzenleyiciden doğrulayın.',
			MhmTherapy4: 'Yüz yüze görüşen uzmanları ',
			MhmTherapy4Link: 'doktor kataloğumuzda',
			MhmTherapy4Mid: ', psikiyatrist veya psikolog bulunan klinikleri ',
			MhmTherapy4ClinicsLink: 'klinik kataloğunda',
			MhmTherapy4End: ' arayabilirsiniz.',

			MhmRx1:
				'Antidepresanlar, anksiyolitikler, uyku ilaçları ve diğer psikotrop ilaçlar Karadağ’da reçeteye tabidir. Yabancı reçete ilacın verilmesini garanti etmez: bazı kullanıcılar belirli eczanelerin reçeteyi kabul ettiğini bildirir, ancak eczacı reddedebilir ve özellikle psikotrop veya kontrollü ilaçlarda buna güvenilmemelidir. Kamu sisteminde eRecept olağandır; kuralların izin verdiği durumlarda yazılı reçete de mümkün olabilir. Tedaviye başlamayı, değişikliği veya bırakmayı nitelikli bir hekimle görüşün.',
			MhmRx2:
				'Tedavi sırasında taşınıyorsanız devamlılığı yolculuktan önce ilacı yazan hekimle planlayın. Yalnızca yasal kişisel kullanım miktarını özgün ambalajında; reçete ve Latin harfleriyle INN, doz ve tedavi geçmişini içeren raporla taşıyın. İlacı kendi sicilimizde ve güncel gümrük kurallarında önceden kontrol edin. Hekim önerisi olmadan ilacı aniden bırakmayın, dozu değiştirmeyin veya başka ürüne geçmeyin.',
			MhmRx3:
				'Knjižica ile izabrani doktor’dan başlayın. Sizi psikiyatriste sevk edebilir; reçete ve yenileme yolu ilaca, endikasyona ve Fonun uzman raporu şartlarına bağlıdır. Kapsanan ilaç yalnızca Montefarm’dan değil, Fonla sözleşmeli bir eczaneden alınabilir. 2023 sonundaki bir sohbet bildirimi iki kutu sertralin için 30 sent katkı payından söz ediyordu; bu tekil örnek fiyat veya kapsam taahhüdü değildir. Yenileme süresi reçete ve tedavi planına bağlıdır.',
			MhmRx4:
				'Knjižica olmadan dom zdravlja hizmetinde veya özel klinikte ücretli muayene isteyebilirsiniz. Daha önce bildirilen 20–30 € civarı fiyatlar yalnızca göstergedir; güncel ücreti randevudan önce sorun. Hekim tedavi geçmişini bağımsız değerlendirir ve yerel reçete yazabilir, planı değiştirebilir veya psikiyatriste sevk edebilir. İzin verilen miktar ve yenileme aralığı ilaca ve klinik plana bağlıdır.',
			MhmRx5: 'Belirli ilaçların bulunabilirliğini ve fiyatlarını',
			MhmRx5Link: 'ilaç kataloğumuzda',
			MhmRx5End: ' kontrol edin.',

			MhmCosts1:
				'Knjižica ile kapsam; güncel hak, sevk, sözleşmeli kurum ve ilaç ile endikasyon için Fon koşullarına bağlıdır; katkı payı olabilir. Acil olmayan bakım öncesi yolu ve maliyeti doğrulayın.',
			MhmCosts2:
				'Sohbet ve ilan fiyatları tarihli göstergedir, teklif değildir. Randevudan önce güncel ücreti ve içeriğini sorun; belirli ilacı kendi sicilimizde ve eczanede kontrol edin.',
			MhmCosts3:
				'Kamuda uzun süreli psikoterapi erişimi belediye ve kapasiteye bağlıdır. Başka ülkedeki çevrimiçi terapistin niteliğini, yasal hizmet yetkisini, gizliliği, kriz planını ve yerel hekimle koordinasyonu doğrulayın; ilaç kararlarını koordinasyonsuz sağlayıcılar arasında bölmeyin.',

			MhmCrisis1:
				'Bir kişinin intihar planı veya araçlara erişimi varsa, aşırı doz aldıysa, psikoz ya da ağır ajitasyon yaşıyorsa veya güvenli kalamıyorsa onu yalnız bırakmayın. 112’yi veya 124’ü arayın, en yakın hitna pomoć ya da hastane aciline gidin ve yardım gelene kadar güvendiğiniz birinin yanında kalmasını sağlayın. Acil erişim vatandaşlık veya sigorta nedeniyle geciktirilmemelidir; sonraki ücretler statü ve kapsama göre değişebilir.',
			MhmCrisis2:
				'İnceleme sırasında ruh sağlığı krizleri için istikrarlı, özel bir ulusal hat belirleyemedik; iletişim bilgileri değişebileceğinden güncel yerel bilgiyi doğrulayın. Akut krizde 112 veya 124’ü arayın ya da en yakın acil servise gidin. Ruh sağlığı merkezi çalışma saatlerinde yardımcı olabilir, ancak erişilebilirlik değişir. Yabancı bir çevrimiçi hizmeti tek acil yol olarak kullanmayın.',
			MhmCrisis3:
				'Yardım istemek öz bakımdır, zayıflık değildir. Doğrudan tehlike varsa yukarıdaki acil yolu kullanın. Tehlike doğrudan değilse güvendiğiniz biriyle ve nitelikli bir uzmanla iletişime geçip güvenlik ve takip planı oluşturun.',

			MhmSources0:
				'Bilgiler Temmuz 2026 itibarıyla günceldir. Kurallar ve iletişim bilgileri değişir — birincil kaynakları kontrol edin:',
			MhmSourcesPhones:
				'Acil numaralar: 124 — ambulans, 112 — ortak Avrupa numarası;',
			MhmSourcesDobrota:
				'Specijalna bolnica za psihijatriju “Dobrota” (Kotor) — ülkenin uzmanlaşmış psikiyatri hastanesi: psihijatrijakotor.com;',
			MhmSourcesKccg:
				'Karadağ Klinik Merkezi’nin (KCCG) psikiyatri kliniği: kccg.me;',
			MhmSourcesFzo:
				'Karadağ Sağlık Sigortası Fonu (FZOCG) — devlet sigortasının kapsamı: fzocg.me;',
			MhmSourcesEzdravlje:
				'eZdravlje portalı — e-reçete ve randevu: ezdravlje.me.',
			MhmSourcesCatalog:
				'Uzman mı arıyorsunuz? Katalogda doktorları uzmanlık, şehir ve muayene diline göre filtreleyebilirsiniz —',
			MhmSourcesCatalogLink: 'Karadağ’daki psikiyatristler',
			MhmSourcesCatalogEnd: '.',

			MhmCtaTitle: 'Psikiyatrist veya psikoterapist mi gerekiyor?',
			MhmCtaText:
				'Katalogda doktorlar şehir, uzmanlık ve muayene dili filtreleriyle listelenir.',
			MhmCtaButton: 'Karadağ’daki psikiyatristler',
		},
	},
};
