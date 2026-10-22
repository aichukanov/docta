// Контент статьи-расследования «Temel Dental в Подгорице: 2000 € на словах,
// 4000 € после оплаты» (slug temel-dental-case).
//
// ИСТОЧНИКИ И РЕШЕНИЯ (не удалять при правках):
// - Кейс — семья автора сайта; раскрытие конфликта интересов (TmdLead2) —
//   обязательный абзац, решение юзера от 2026-10-20. Не убирать и не смягчать:
//   он же объясняет, почему факты даны без «по словам пациентки» — автор был
//   свидетелем, переписка и платёжные документы из первых рук.
// - Слово «мошенничество» допустимо ТОЛЬКО внутри атрибутированной цитаты
//   отзыва («resmen dolandırıcılık», TmdRevPriceX) с оговоркой, что это слова
//   автора отзыва. В остальном тексте — нет.
// - Цены 180–300 € и 201,69 € (КЦЧГ) по услуге orthodontic-removable-plate-
//   appliance (#4044) — срез локальной БД 2026-10-20: 24 клиники, 8 с ценой
//   (180/200/201,69/220/240/250/250/300). При изменении прайсов обновить и
//   здесь, и в docs/drafts/article-temel-dental-case.ru.md.
// - Запрос клинике НЕ отправлен: публичной почты у клиники не нашлось
//   (2026-10-22), формулировки «запрос направлен» из текста убраны. Заготовка
//   письма — docs/drafts/letter-temel-dental.sr.md, на случай появления
//   канала. Если клиника ответит — дополнить TmdPos3 (все 6 локалей).
// - Научная база TmdSci3: систематические обзоры PMC5525446 (2017, Dental
//   Press J Orthod) и PMC11049362 (2024, Children) — ссылки в секции
//   «Источники» самой страницы.
// - Юрбаза: новый Zakon o zaštiti potrošača (02.2026), Zakon o fiskalizaciji
//   (46/2019, 73/2019, штрафы до 40 000 €), Zakon o pravima pacijenata
//   (40/2010, 40/2011). Неподтверждённое — в служебном блоке RU-мастера
//   (docs/drafts/article-temel-dental-case.ru.md), в статью не попало.
// - RU — мастер; «Темел Дентал» кириллицей упомянут один раз (TmdRevTg) —
//   это и поисковый ключ, не удалять. Бренды и названия законов во всех
//   локалях, включая sr-cyrl, остаются латиницей по общей конвенции.
export default {
	messages: {
		'en': {
			TmdTitle:
				'Temel Dental in Podgorica: €2,000 quoted, €4,000 after payment',
			TmdDescription:
				'A documented case at the Temel Dental clinic in Podgorica: a family paid €1,000 for treatment quoted at “around €2,000”, and days later learned the plan costs €4,000 and consists of different procedures. The clinic refuses a refund. Correspondence, reviews, Montenegrin law and a patient checklist.',
			TmdToc_case: 'Timeline: from a routine check-up to a “package price”',
			TmdToc_science: 'Can the lower jaw “expand on its own”?',
			TmdToc_flags: 'Five red flags',
			TmdToc_reviews: 'Reviews of Temel Dental: not an isolated case',
			TmdToc_position: "Temel Dental's position",
			TmdToc_law: 'What Montenegrin law says',
			TmdToc_checklist: 'Checklist: before you pay an orthodontist',
			TmdToc_paid: 'If you have already paid',
			TmdToc_docta: 'What docta.me will do',
			TmdToc_sources: 'Sources',
			TmdLead1a:
				'In October 2026, a mother brought her 11-year-old daughter to a routine check-up at the ',
			TmdLead1Link: 'Temel Dental',
			TmdLead1End:
				' clinic in Podgorica. Just a few days later the family found itself in a situation people rarely write about but often share in private: a treatment of “around €2,000” was discussed verbally at the consultation, €1,000 was paid — and only after the payment did the family learn from written correspondence that the full plan costs €4,000 and consists of procedures different from what the doctor had discussed. The clinic refuses to return the money.',
			TmdLead2:
				'Full disclosure first: this is the family of the person behind docta.me — his wife took their daughter to the consultation. The site is run by one person, so “the editorial team” in this text is him. We disclose this conflict of interest openly rather than hide it. Being close to the story also works for accuracy: the correspondence, the payment documents and the events themselves are known to the author first-hand, not as a retelling. We break the case down step by step, compare it with public reviews of the clinic and with Montenegrin law — and end with a checklist for avoiding a similar situation. The clinic’s position is included below, based on its replies in the correspondence.',
			TmdCase1:
				'At a routine check-up, a Temel Dental dentist referred the child to the clinic’s own orthodontist — a reasonable step in itself. At the consultation the orthodontist laid out a plan verbally: an expansion plate for the upper jaw for about six months, then aligners. He estimated the total cost at “around €2,000”: €1,000 upfront, then €100–200 per month for aligners, starting in six months. The lower jaw, according to the doctor, did not need expanding: it “expands on its own”.',
			TmdCase2:
				'The family paid €1,000: €800 by card and €200 in cash. No receipt was issued for the cash part. No written contract was signed, and the family received no written treatment plan with stages and prices — every agreement remained verbal.',
			TmdCase3a:
				'Within days of the payment, the parents compared prices and found that similar expansion plates cost around €200 at other clinics in Montenegro, while at Temel Dental this item had cost €800. The docta.me catalog confirms it: the service “',
			TmdCase3Link: 'removable orthodontic plate appliance',
			TmdCase3End:
				'” is listed in the price lists of 24 clinics, with published prices from €180 to €300 — including €201.69 at the state ',
			TmdCase3KccgLink: 'Clinical Center of Montenegro',
			TmdCase3Tail:
				'. The family wrote to the clinic, asking for the brand or model of the appliance and a breakdown of what the €1,000 covered.',
			TmdCase4:
				'The reply, as the correspondence shows: “There is no specific brand, this is made in dentistry every day by technicians.” The clinic then sent a long message with a “treatment plan”. It said the plan consists of plates for both jaws (€800 each) plus braces for €3,500–4,000; the “regular price” of the package is €5,100–5,600, but “the doctor offered a special package price of €4,000”.',
			TmdCase5:
				'This diverged from the consultation on two points. Braces appeared instead of the aligners that had been discussed. And the second plate — for the lower jaw — was the very one the doctor had called unnecessary at the consultation. The €4,000 figure was voiced for the first time only after the family had paid €1,000.',
			TmdCase6:
				'The patient asked to terminate the relationship and refund the payment: essentially no service had been provided — only impressions had been taken, there was no contract, no stages had been fixed in writing, and the receipt did not cover the full amount. The clinic refused to return the money. Here are quotes from its replies:',
			TmdQuote1: '“No orthodontic treatment in Montenegro costs 200 euros.”',
			TmdQuote2:
				'“The cost of the treatment is significantly higher, but we came to your aid and gave you a discount.”',
			TmdQuote3:
				'“No complex medical procedures were performed on you. Everything was done according to our current price list. Impressions were taken, you made a payment, and you were issued an invoice.”',
			TmdQuote4: '“All our actions are within the law.”',
			TmdCase7:
				'The clinic refused to share the treating doctor’s contact and suggested coming in on Monday to discuss everything with the doctors through an interpreter (the correspondence mentions a “Dr Alex”). After that, the director of the clinic’s head office in Turkey contacted the patient — she had been asked to do so. The patient laid out the whole situation to her again, point by point. No reply followed; the clinic still refuses to return the money. Meanwhile the family filed a chargeback request with their bank — the bank accepted it and is reviewing the case.',
			TmdSci1:
				'The doctor’s phrase about the lower jaw played a key role in this story — it is the “unnecessary” plate that later appeared in the plan at €800 — so it deserves a separate look.',
			TmdSci2:
				'Orthodontically, it is more correct to speak of the dental arch, not the jaw. The upper jaw in a child really can be expanded skeletally: until growth is complete, the midpalatal suture is pliable, and that is what expansion plates and appliances rely on. The lower jaw has no such suture, so it cannot be skeletally “expanded” by an appliance at all — a plate on the lower arch merely tips the teeth outwards.',
			TmdSci3:
				'“Spontaneous” changes of the lower arch after upper jaw expansion are indeed described in the scientific literature: the lower teeth may upright slightly and the arch may widen a little. But a 2017 systematic review rates these spontaneous changes as negligible — on the order of a millimetre, with no clinically significant difference from children who received no treatment at all; a 2024 review states that study results are contradictory. There is a kernel of science in the doctor’s phrase, but evidence-based orthodontics does not allow counting on any noticeable “it will expand on its own” effect.',
			TmdSci4:
				'We do not presume to judge what plan a particular child needs — that is a matter for an in-person consultation. The problem is elsewhere: the clinic’s two statements are incompatible. If the doctor was right and the lower-jaw plate is unnecessary, it has no place in a plan at €800. If it is necessary, the verbal estimate of “around €2,000” was knowingly incomplete. Between those two versions lie a few days — and a paid deposit.',
			TmdFlag1T: '1. The price changed after payment.',
			TmdFlag1X:
				'At the consultation — “around €2,000”; in correspondence after the payment — €4,000 “with a discount” off a “regular price” of €5,100–5,600. How it should be: the full cost of treatment and the price of each stage are fixed in writing before the first payment.',
			TmdFlag2T: '2. The treatment was swapped for a more expensive one.',
			TmdFlag2X:
				'Aligners turned into braces, and the “unnecessary” lower-jaw plate became part of the plan. How it should be: a change of plan means a new consultation and the patient’s new consent, not a line in a message.',
			TmdFlag3T: '3. No contract and no written plan.',
			TmdFlag3X:
				'In a dispute, each side retells verbal agreements its own way — and there is no way to verify them. How it should be: a written plan with the diagnosis, stages, timeline and prices is issued before treatment starts.',
			TmdFlag4T: '4. The receipt does not cover the full amount.',
			TmdFlag4X:
				'Of the €1,000, only the €800 paid by card is confirmed by documents. How it should be: a fiscal receipt for every payment — cash included — is the clinic’s legal obligation, not a favour.',
			TmdFlag5T: '5. No refund for a service not provided.',
			TmdFlag5X:
				'Only impressions were actually taken, yet the clinic refused to return the difference. How it should be: if treatment has not started, the patient has the right to withdraw; the clinic may retain the cost of work actually performed — and must justify it.',
			TmdRev1:
				'We studied public reviews of the clinic on Google Maps. The Temel Dental policlinic profile (Donja Gorica, Bulevar 21 Maj, Podgorica) has a 4.1 rating across 69 reviews; the clinic’s second profile — 4.2 across 84. The distribution is polarized: 51 five-star reviews, 14 one-star, almost nothing in between. A rating profile like that is a reason to read the negative reviews specifically: the same storylines repeat in them.',
			TmdRevPriceT: 'A higher price than quoted.',
			TmdRevPriceX:
				'A Turkish-language one-star review (about two months old) says: before a tooth extraction the examination quote was €80, “€150 if it’s surgical”; there was no surgery, the tooth was out in a minute, but €150 was charged anyway. An invoice was not provided on request — they promised to “send a photo”. The author calls what happened “resmen dolandırıcılık” — “outright fraud”; we stress these are the reviewer’s words, not ours. A Russian-language two-star review (a year old): “ANY ORTHODONTIST APPOINTMENT COSTS 100 euros” — €15 was quoted at booking, €100 in the chair, though all that was needed was to fit a spring and replace an elastic.',
			TmdRevUpsellT: 'Upselling.',
			TmdRevUpsellX:
				'An English-language one-star review: “It gets worse every time… I came with my mother to extract a tooth — they immediately started offering her additional services… They charged the maximum price although the procedure was not surgical.”',
			TmdRevQualityT: 'Complaints about quality.',
			TmdRevQualityX:
				'The author of another English-language review (“High prices and low quality”) claims the head dentist Ibrahim Temel ground down a healthy tooth, after which a crown was needed. Another writes: three months after a crown replacement, inflammation started under it and the doctor refused to replace it; after a wisdom tooth extraction a fragment was left in the gum.',
			TmdRevOrgT: 'Organization of appointments.',
			TmdRevOrgX:
				'In a Russian-language review (a year old), instead of the doctor who had fallen ill, the patient was seen by “some guy in a sweater, no scrubs”, assisted by the front-desk administrator. In another, the appointment was at 9:00 and the doctor had not appeared by 9:20; in its public reply the clinic cited “equipment problems”, which the author calls untrue.',
			TmdRevTg:
				'One more observation. In a Russian-language Telegram chat about healthcare in Montenegro, the clinic has been posting ads regularly since 2023 — dozens of posts. There are no organic discussions or patient recommendations there: the brand’s visibility in the Russian-speaking community was created by the clinic itself.',
			TmdPos1:
				'The clinic considers its actions lawful. Its arguments from the correspondence: impressions were taken, the patient paid, an invoice was issued; everything was done “according to the current price list” and “within the law”. The €200 plate price named by the parents is rejected: “No orthodontic treatment in Montenegro costs 200 euros.”',
			TmdPos2a: 'Published price lists say otherwise: a ',
			TmdPos2Link: 'removable orthodontic plate appliance',
			TmdPos2End:
				' costs from €180 to €300 at clinics across the country, including €201.69 at the Clinical Center of Montenegro.',
			TmdPos3:
				'The clinic presents the €4,000 package as a discount off a regular price of €5,100–5,600. Finally, the clinic offered an in-person meeting: come in on Monday and discuss the situation with the doctors with an interpreter present. If the clinic sends us a substantive comment, we will update this article.',
			TmdLawPriceT: 'The right to know the price in advance.',
			TmdLawPriceX:
				'The Consumer Protection Law (Zakon o zaštiti potrošača; parliament adopted its new version in February 2026) enshrines the consumer’s right to clear information about the price of goods or services before purchase. A verbal estimate of “around €2,000” that turns into €4,000 after payment sits poorly with that principle — but verbal agreements are hard to prove, which is exactly why a written plan matters.',
			TmdLawFiscalT: 'A fiscal receipt for every payment.',
			TmdLawFiscalX:
				'The Fiscalization Law (Zakon o fiskalizaciji u prometu proizvoda i usluga, “Sl. list CG” 46/2019 and 73/2019) requires every payment, including cash, to go through the fiscal system with a receipt issued. Legal entities face fines of up to €40,000 for violations.',
			TmdLawConsentT: 'Consent to treatment.',
			TmdLawConsentX:
				'The Law on Patients’ Rights (Zakon o pravima pacijenata, “Sl. list CG” 40/2010 and 40/2011) guarantees the right to information about proposed treatment and to consent to it; patient complaints are handled by the patients’ rights ombudsman (zaštitnik prava pacijenata). According to specialized press, patient-rights representatives were being introduced in dental practices as well.',
			TmdLawWhereT: 'Where to complain.',
			TmdLawWhereX:
				'The market inspection within the Administration for Inspection Affairs (Uprava za inspekcijske poslove) — for consumer rights violations and failure to issue a receipt. The Dental Chamber of Montenegro (Stomatološka komora Crne Gore, operating since 2016) — for doctors’ actions. The consumer organization CEZAP (Centar za zaštitu potrošača, cezap.me) advises on disputes. In any case, start with a written complaint with documents attached.',
			TmdCheck0:
				'Asking a doctor for a contract and an itemized estimate feels awkward — you want to trust your doctor, and that trust is what everything rests on. But a written plan is standard practice worldwide, and an honest clinic will not be offended by the request. Here is what to do before the first payment:',
			TmdCheck1:
				'Demand a written treatment plan: diagnosis, stages, timeline, the price of each stage and the total. No plan — no payment.',
			TmdCheck2:
				'Sign a contract with the clinic — on paper, with its legal details.',
			TmdCheck3:
				'Take a fiscal receipt for every payment, cash included. “We’ll send you a photo of the invoice” is not a receipt.',
			TmdCheck4:
				'Get a second opinion: a consultation with another orthodontist costs tens of euros and insures you against losing thousands.',
			TmdCheck5:
				'Don’t prepay for stages that start in six months — pay for a stage when it begins.',
			TmdCheck6:
				'Compare prices: clinic price lists for Montenegro are published on docta.me. A several-fold gap is a reason to ask questions before paying, not after.',
			TmdPaid0:
				'If you recognized your own story in this one, the first and most important thing: you are not to blame. Trusting a doctor is normal — that is how it should be; exploiting that trust is the clinic’s choice, not your mistake. Here is what you can do, calmly, step by step:',
			TmdPaid1:
				'Send the clinic a written claim (email works): what was paid, what was actually provided, a demand to return the difference, and a deadline to reply.',
			TmdPaid2:
				'Collect evidence: correspondence, receipts, card statements, photos of the price list at the clinic.',
			TmdPaid3:
				'Complain to the market inspection (Uprava za inspekcijske poslove) — especially if no receipt was issued or the price diverged from the price list.',
			TmdPaid4:
				'For the medical side of the dispute — a treatment plan changed without your consent — turn to the patients’ rights ombudsman and the Dental Chamber.',
			TmdPaid5:
				'If you paid by card, ask your bank about the chargeback procedure: it exists for card payments; you will need a description of the situation and the correspondence with the clinic. Review usually takes one to three months — be patient, that is a normal timeframe.',
			TmdPaid6: 'You can also seek advice from CEZAP.',
			TmdDocta1:
				'This case is not only about one clinic. It is about a practice where the final cost is voiced after the fact, and the patient has not a single document to argue with. docta.me is introducing a “caution” badge for clinics with documented complaints and a “clinic reputation” section where such complaints will be collected in a standardized form. The review by the heroine of this story is published as verified: the author saw every document in this case personally (see the conflict-of-interest disclosure at the top).',
			TmdDocta2:
				'If you have faced a similar practice — at this clinic or any other — write to us and attach documents. The more documented stories there are, the harder it is for this practice to remain the norm.',
			TmdSrcIntro:
				'The patient’s correspondence with the clinic and the payment documents are in the editor’s possession. Public reviews are from the Google Maps profiles of Temel Dental policlinic (Podgorica). Legal and scientific sources:',
			TmdSrcSci2017:
				'Systematic review (2017): spontaneous mandibular dentoalveolar changes after maxillary expansion',
			TmdSrcSci2024:
				'Systematic review (2024, Children): mandibular changes after RME, SME and leaf expander',
			TmdSrcZzp:
				'Zakon o zaštiti potrošača — the new Consumer Protection Law (Službeni list CG, February 2026)',
			TmdSrcFisk:
				'Zakon o fiskalizaciji — fiscal receipts and fines (paragraf.me)',
			TmdSrcPrava:
				'Zakon o pravima pacijenata — patients’ rights and the ombudsman (paragraf.me)',
			TmdSrcCezap: 'CEZAP — the Montenegrin consumer protection center',
			TmdCtaTitle: 'Check prices before you pay',
			TmdCtaText:
				'docta.me publishes the price lists of Montenegrin clinics — see what a service costs elsewhere.',
			TmdCtaButton: 'Compare prices',
		},
		'ru': {
			TmdTitle:
				'Temel Dental в Подгорице: 2000 € на словах, 4000 € после оплаты',
			TmdDescription:
				'Разбор случая в стоматологии Temel Dental (Подгорица): семья заплатила 1000 € за лечение «примерно на 2000 €», а через несколько дней узнала, что план стоит 4000 € и состоит из других процедур. Вернуть деньги клиника отказывается. Переписка, отзывы, законы Черногории, памятка.',
			TmdToc_case: 'Хронология: от планового осмотра до «пакетной стоимости»',
			TmdToc_science: 'Может ли нижняя челюсть «расшириться самостоятельно»?',
			TmdToc_flags: 'Пять красных флагов',
			TmdToc_reviews: 'Отзывы о Temel Dental: это не единичный случай',
			TmdToc_position: 'Позиция клиники Temel Dental',
			TmdToc_law: 'Что говорит закон Черногории',
			TmdToc_checklist: 'Памятка: прежде чем платить ортодонту',
			TmdToc_paid: 'Если вы уже заплатили',
			TmdToc_docta: 'Что сделает docta.me',
			TmdToc_sources: 'Источники',
			TmdLead1a:
				'В октябре 2026 года мать привела 11-летнюю дочь на плановый осмотр в клинику ',
			TmdLead1Link: 'Temel Dental',
			TmdLead1End:
				' в Подгорице. Всего через несколько дней семья оказалась в ситуации, о которой нечасто пишут, но часто рассказывают в частных разговорах: на консультации устно обсудили лечение «примерно на 2000 €», заплатили 1000 € — а уже после оплаты узнали из переписки, что полный план стоит 4000 € и состоит из других процедур, чем обсуждалось у врача. Вернуть деньги клиника отказывается.',
			TmdLead2:
				'Сразу о главном: это случай семьи автора docta.me — на консультацию дочь водила его жена. Сайт делает один человек, поэтому «редакция» в этом тексте — он и есть. Мы раскрываем этот конфликт интересов прямо, а не прячем. У близости к истории есть и обратная сторона, которая работает на точность: переписка, платёжные документы и сами события известны автору из первых рук, а не в пересказе. Мы разобрали случай по шагам, сопоставили его с публичными отзывами о клинике и с законодательством Черногории — и составили памятку, как не оказаться в похожей ситуации. Позиция клиники в материале приведена — по её ответам из переписки.',
			TmdCase1:
				'Стоматолог Temel Dental на плановом осмотре направил ребёнка к ортодонту той же клиники — шаг сам по себе обоснованный. На консультации ортодонт устно озвучил план: расширительная пластинка на верхнюю челюсть примерно на шесть месяцев, затем элайнеры. Общую стоимость врач оценил «около 2000 €»: 1000 € сразу, затем по 100–200 € в месяц за элайнеры — начиная через полгода. Нижнюю челюсть, со слов врача, расширять не нужно: она «расширяется самостоятельно».',
			TmdCase2:
				'Семья заплатила 1000 €: 800 € картой и 200 € наличными. Чек на наличную часть не выдали. Письменный договор не заключался, план лечения с этапами и ценами на бумаге семья тоже не получила — все договорённости остались устными.',
			TmdCase3a:
				'Уже через несколько дней после оплаты родители сравнили цены и выяснили, что аналогичные расширительные пластинки в других клиниках Черногории стоят порядка 200 €, тогда как у Temel Dental эта позиция обошлась в 800 €. Это подтверждает каталог docta.me: услуга «',
			TmdCase3Link: 'Ортодонтический съёмный пластинчатый аппарат',
			TmdCase3End:
				'» есть в прайсах 24 клиник, открытые цены — от 180 до 300 €, в том числе 201,69 € в государственном ',
			TmdCase3KccgLink: 'Клиническом центре Черногории',
			TmdCase3Tail:
				'. Семья написала в клинику: попросила назвать бренд или модель аппарата и расшифровать, что входит в уплаченную 1000 €.',
			TmdCase4:
				'Ответ, как следует из переписки: «Нет какой-то конкретной марки, это делается в стоматологии каждый день техниками». Затем клиника прислала длинное сообщение с «планом лечения». Из него следовало: план — это пластинки на обе челюсти (по 800 € каждая) плюс брекеты за 3500–4000 €; «обычная стоимость» пакета — 5100–5600 €, но «врач предложил специальную пакетную стоимость 4000 €».',
			TmdCase5:
				'С консультацией это расходилось в двух пунктах. Брекеты появились вместо обсуждавшихся элайнеров. А вторая пластинка — на нижнюю челюсть — это та самая, которую врач на консультации называл ненужной. Сумма 4000 € прозвучала впервые — уже после того, как семья внесла 1000 €.',
			TmdCase6:
				'Пациентка попросила расторгнуть отношения и вернуть оплату: услуга по существу не оказана — сделаны только слепки, договора нет, этапы письменно не зафиксированы, чек выдан не на всю сумму. Клиника вернуть деньги отказалась. Вот цитаты из её ответов:',
			TmdQuote1:
				'«В Черногории ни одно ортодонтическое лечение не стоит 200 евро».',
			TmdQuote2:
				'«Стоимость лечения значительно выше, но мы пришли вам на помощь и сделали скидку».',
			TmdQuote3:
				'«Вам не проводили никаких сложных медицинских процедур. Всё было сделано в соответствии с нашим действующим прейскурантом. У вас сняли слепки, вы произвели оплату, и вам был выдан счёт».',
			TmdQuote4: '«Все наши действия осуществляются в рамках закона».',
			TmdCase7:
				'Контакт лечащего врача клиника дать отказалась и предложила прийти в понедельник — обсудить всё с врачами через переводчика (в переписке упоминается «доктор Алекс»). После этого с пациенткой связалась директор головного офиса клиники в Турции — её попросили это сделать. Пациентка заново, по пунктам, изложила ей всю ситуацию. Ответа не последовало; возвращать деньги клиника отказывается. Тем временем семья подала в свой банк заявление на оспаривание платежа (chargeback) — банк принял его и рассматривает.',
			TmdSci1:
				'Фраза врача про нижнюю челюсть сыграла в этой истории ключевую роль — именно «ненужная» пластинка потом появилась в плане с ценой 800 €, — поэтому разберём её отдельно.',
			TmdSci2:
				'С точки зрения ортодонтии корректнее говорить не о челюсти, а о зубном ряде. Верхнюю челюсть у ребёнка действительно можно расширить скелетно: срединный нёбный шов до окончания роста податлив, на этом и построена работа расширительных пластинок и аппаратов. В нижней челюсти такого шва нет, поэтому расширить её аппаратом в скелетном смысле нельзя в принципе — пластинка на нижний ряд лишь наклоняет зубы наружу.',
			TmdSci3:
				'«Самостоятельные» изменения нижнего ряда после расширения верхней челюсти в научной литературе действительно описаны: нижние зубы могут немного выпрямиться, и ряд слегка расширяется. Но систематический обзор 2017 года оценивает эти спонтанные изменения как незначительные — порядка миллиметра, без клинически значимой разницы с детьми, которых не лечили вовсе; обзор 2024 года констатирует, что результаты исследований противоречивы. Научное зерно во фразе врача есть, но рассчитывать на заметный эффект «само расширится» доказательная ортодонтия не позволяет.',
			TmdSci4:
				'Редакция не берётся судить, какой план нужен конкретному ребёнку, — это вопрос очной консультации. Проблема в другом: два утверждения клиники несовместимы. Если врач был прав и пластинка на нижнюю челюсть не нужна, ей нечего делать в плане за 800 €. Если же она нужна — устная оценка «около 2000 €» была заведомо неполной. Между этими двумя версиями — несколько дней и внесённая предоплата.',
			TmdFlag1T: '1. Цена изменилась после оплаты.',
			TmdFlag1X:
				'На консультации — «около 2000 €», в переписке после оплаты — 4000 € «со скидкой» от «обычной стоимости» 5100–5600 €. Как должно быть: полная стоимость лечения и цена каждого этапа фиксируются письменно до первого платежа.',
			TmdFlag2T: '2. Состав лечения заменён на более дорогой.',
			TmdFlag2X:
				'Элайнеры превратились в брекеты, «ненужная» пластинка на нижнюю челюсть стала частью плана. Как должно быть: изменение плана — это новая консультация и новое согласие пациента, а не строка в сообщении.',
			TmdFlag3T: '3. Нет договора и письменного плана.',
			TmdFlag3X:
				'Устные договорённости в споре каждая сторона пересказывает по-своему — и проверить их невозможно. Как должно быть: письменный план с диагнозом, этапами, сроками и ценами выдаётся до начала лечения.',
			TmdFlag4T: '4. Чек выдан не на всю сумму.',
			TmdFlag4X:
				'Из 1000 € документами подтверждены только 800 €, уплаченные картой. Как должно быть: фискальный чек на каждый платёж — наличный в том числе — это обязанность клиники по закону, а не любезность.',
			TmdFlag5T: '5. Возврат за неоказанную услугу не произведён.',
			TmdFlag5X:
				'Фактически выполнены только слепки, но возвращать разницу клиника отказалась. Как должно быть: если лечение не началось, пациент вправе от него отказаться; удержать можно стоимость фактически выполненных работ — и её нужно обосновать.',
			TmdRev1:
				'Мы изучили публичные отзывы о клинике в Google Картах. Профиль Temel Dental policlinic (Donja Gorica, Bulevar 21 Maj, Подгорица) имеет рейтинг 4,1 при 69 отзывах; второй профиль той же клиники — 4,2 при 84. Распределение поляризованное: 51 отзыв на пять звёзд, 14 — на одну, середины почти нет. Такой профиль оценок — повод читать именно негативные отзывы: в них повторяются одни и те же сюжеты.',
			TmdRevPriceT: 'Цена выше озвученной.',
			TmdRevPriceX:
				'Автор отзыва на турецком (одна звезда, около двух месяцев назад) пишет: перед удалением зуба на осмотре назвали 80 €, «если будет операция — 150 €»; операции не было, зуб удалили за минуту, но взяли всё равно 150 €. Счёт на просьбу не выдали, пообещав «прислать фото». Произошедшее автор называет «resmen dolandırıcılık» — «откровенное мошенничество»; подчеркнём, что это слова автора отзыва, а не редакции. Русскоязычный отзыв на две звезды (год назад): «ЛЮБАЯ ЗАПИСЬ К ОРТОДОНТУ СТОИТ 100 евро» — при записи озвучили 15 €, в кресле оказалось 100 €, хотя нужно было лишь поставить пружину и заменить эластик.',
			TmdRevUpsellT: 'Навязывание услуг.',
			TmdRevUpsellX:
				'Отзыв на английском (одна звезда, перевод): «Каждый раз всё хуже… Пришла с матерью удалить зуб — ей сразу начали предлагать дополнительные услуги… Взяли максимальную цену, хотя процедура не была хирургической».',
			TmdRevQualityT: 'Претензии к качеству.',
			TmdRevQualityX:
				'Автор ещё одного англоязычного отзыва («High prices and low quality») утверждает, что главный стоматолог Ibrahim Temel обточил здоровый зуб, после чего понадобилась коронка. Другой пишет: через три месяца после замены коронки под ней началось воспаление, врач отказался её менять; при удалении зуба мудрости в десне остался осколок.',
			TmdRevOrgT: 'Организация приёма.',
			TmdRevOrgX:
				'В русскоязычном отзыве (год назад) — вместо заболевшего врача пациента принял «какой-то чувак без халата в свитере», ассистировал администратор с ресепшена. В другом — запись на 9:00, врач не появился и к 9:20; в публичном ответе клиника сослалась на «неполадки с оборудованием», что автор называет неправдой.',
			TmdRevTg:
				'Ещё одно наблюдение редакции. В русскоязычном Telegram-чате о медицине в Черногории клиника (её название там пишут и кириллицей: «Темел Дентал») с 2023 года регулярно размещает рекламу — десятки постов. Живых обсуждений и рекомендаций от пациентов там нет: видимость бренда в русскоязычном сообществе создана самой клиникой.',
			TmdPos1:
				'Клиника считает свои действия законными. Её аргументы из переписки: пациентке сняли слепки, она произвела оплату, ей был выдан счёт; всё сделано «в соответствии с действующим прейскурантом» и «в рамках закона». Названную родителями цену 200 € за пластинку клиника отвергает: «В Черногории ни одно ортодонтическое лечение не стоит 200 евро».',
			TmdPos2a: 'Опубликованные прайсы говорят об обратном: ',
			TmdPos2Link: 'съёмный пластинчатый аппарат',
			TmdPos2End:
				' в клиниках страны стоит от 180 до 300 €, в том числе 201,69 € в Клиническом центре Черногории.',
			TmdPos3:
				'Пакет на 4000 € клиника подаёт как скидку с обычной стоимости 5100–5600 €. Наконец, клиника предлагала очную встречу: прийти в понедельник и обсудить ситуацию с врачами с участием переводчика. Если клиника направит редакции развёрнутый комментарий, мы дополним материал.',
			TmdLawPriceT: 'Право знать цену заранее.',
			TmdLawPriceX:
				'Закон о защите потребителей (Zakon o zaštiti potrošača; в феврале 2026 года парламент принял его новую редакцию) закрепляет право потребителя на ясную информацию о цене товара или услуги до покупки. Устная оценка «около 2000 €», после оплаты превращающаяся в 4000 €, с этим принципом совместима плохо — но устные договорённости трудно доказывать, поэтому письменный план и важен.',
			TmdLawFiscalT: 'Фискальный чек — на каждый платёж.',
			TmdLawFiscalX:
				'Закон о фискализации (Zakon o fiskalizaciji u prometu proizvoda i usluga, «Sl. list CG» 46/2019 и 73/2019) обязывает проводить каждый платёж, включая наличные, через фискальную систему с выдачей чека. Юридическим лицам за нарушения грозят штрафы до 40 000 €.',
			TmdLawConsentT: 'Согласие на лечение.',
			TmdLawConsentX:
				'Закон о правах пациентов (Zakon o pravima pacijenata, «Sl. list CG» 40/2010 и 40/2011) гарантирует право на информацию о предлагаемом лечении и на согласие с ним; жалобы пациентов рассматривает защитник прав пациентов (zaštitnik prava pacijenata). По сообщениям профильной прессы, институт представителя по правам пациентов вводился и в стоматологических практиках.',
			TmdLawWhereT: 'Куда жаловаться.',
			TmdLawWhereX:
				'Рыночная инспекция в составе Управления по инспекционным делам (Uprava za inspekcijske poslove) — по нарушениям прав потребителей и невыдаче чека. Стоматологическая палата Черногории (Stomatološka komora Crne Gore, работает с 2016 года) — по действиям врачей. Потребительская организация CEZAP (Centar za zaštitu potrošača, cezap.me) консультирует по спорам. Начинать в любом случае стоит с письменного обращения с приложением документов.',
			TmdCheck0:
				'Просить у врача договор и смету неловко — врачу хочется доверять, на этом доверии всё и держится. Но письменный план — обычная мировая практика, и добросовестную клинику такая просьба не обидит. Вот что стоит сделать до первого платежа:',
			TmdCheck1:
				'Требуйте письменный план лечения: диагноз, этапы, сроки, цена каждого этапа и итоговая сумма. Нет плана — нет оплаты.',
			TmdCheck2: 'Заключите договор с клиникой — на бумаге, с реквизитами.',
			TmdCheck3:
				'Берите фискальный чек на каждый платёж, наличный в том числе. «Пришлём фото счёта» — не чек.',
			TmdCheck4:
				'Возьмите второе мнение: консультация у другого ортодонта стоит десятки евро и страхует от лишних трат в тысячи.',
			TmdCheck5:
				'Не платите вперёд за этапы, которые начнутся через полгода, — платите за этап тогда, когда он начинается.',
			TmdCheck6:
				'Сравните цены: на docta.me опубликованы прайсы клиник Черногории. Расхождение в разы — повод задавать вопросы до оплаты, а не после.',
			TmdPaid0:
				'Если вы узнали в этой истории свою, первое и главное: вы ни в чём не виноваты. Доверять врачу — нормально, так и должно быть; пользоваться этим доверием — выбор клиники, а не ваша ошибка. Вот что можно сделать — спокойно, по шагам:',
			TmdPaid1:
				'Направьте клинике письменную претензию (подойдёт и email): что оплачено, что фактически оказано, требование вернуть разницу и срок ответа.',
			TmdPaid2:
				'Соберите доказательства: переписку, чеки, выписку по карте, фото прейскуранта в клинике.',
			TmdPaid3:
				'Пожалуйтесь в рыночную инспекцию (Uprava za inspekcijske poslove) — особенно если чек не выдан или цена разошлась с прейскурантом.',
			TmdPaid4:
				'По медицинской стороне спора — замена плана лечения без вашего согласия — обращайтесь к защитнику прав пациентов и в Стоматологическую палату.',
			TmdPaid5:
				'Если платили картой, узнайте в своём банке о процедуре оспаривания платежа (chargeback): для карточных платежей она существует, понадобится описание ситуации и переписка с клиникой. Рассмотрение обычно занимает от одного до трёх месяцев — наберитесь терпения, это нормальные сроки.',
			TmdPaid6: 'За консультацией можно обратиться в CEZAP.',
			TmdDocta1:
				'Этот случай — не только про одну клинику. Он про практику, при которой итоговая стоимость озвучивается постфактум, а у пациента нет ни одного документа, чтобы спорить. Редакция вводит на сайте отметку «осторожно» для клиник с задокументированными жалобами и раздел «репутация клиники», где такие жалобы будут собираться в стандартизированном виде. Отзыв героини этого материала размещён как верифицированный: все документы по случаю автор видел лично (см. раскрытие конфликта интересов в начале статьи).',
			TmdDocta2:
				'Если вы сталкивались с похожей практикой — в этой или другой клинике — напишите нам и приложите документы. Чем больше задокументированных историй, тем труднее практике оставаться нормой.',
			TmdSrcIntro:
				'Переписка пациентки с клиникой и платёжные документы — в распоряжении редакции. Публичные отзывы — профили Temel Dental policlinic в Google Картах (Подгорица). Юридические и научные источники:',
			TmdSrcSci2017:
				'Систематический обзор (2017): спонтанные изменения нижнего зубного ряда после расширения верхней челюсти',
			TmdSrcSci2024:
				'Систематический обзор (2024, Children): изменения нижнего ряда после RME, SME и leaf-экспандера',
			TmdSrcZzp:
				'Zakon o zaštiti potrošača — новая редакция закона о защите потребителей (Službeni list CG, февраль 2026)',
			TmdSrcFisk:
				'Zakon o fiskalizaciji — фискальные чеки и штрафы (paragraf.me)',
			TmdSrcPrava:
				'Zakon o pravima pacijenata — права пациентов и защитник (paragraf.me)',
			TmdSrcCezap: 'CEZAP — потребительская организация Черногории',
			TmdCtaTitle: 'Проверяйте цены до оплаты',
			TmdCtaText:
				'На docta.me опубликованы прайсы клиник Черногории — посмотрите, сколько услуга стоит в других клиниках.',
			TmdCtaButton: 'Сравнить цены',
		},
		'sr': {
			TmdTitle:
				'Temel Dental u Podgorici: 2.000 € usmeno, 4.000 € nakon uplate',
			TmdDescription:
				'Dokumentovan slučaj u stomatološkoj klinici Temel Dental (Podgorica): porodica je platila 1.000 € za liječenje „od oko 2.000 €“, a nekoliko dana kasnije saznala da plan košta 4.000 € i da se sastoji od drugih procedura. Klinika odbija povraćaj novca. Prepiska, recenzije, crnogorski zakoni i podsjetnik za pacijente.',
			TmdToc_case: 'Hronologija: od kontrolnog pregleda do „paketne cijene“',
			TmdToc_science: 'Može li se donja vilica „proširiti sama“?',
			TmdToc_flags: 'Pet crvenih zastavica',
			TmdToc_reviews: 'Recenzije o Temel Dentalu: slučaj nije usamljen',
			TmdToc_position: 'Stav klinike Temel Dental',
			TmdToc_law: 'Šta kaže crnogorski zakon',
			TmdToc_checklist: 'Podsjetnik: prije nego što platite ortodontu',
			TmdToc_paid: 'Ako ste već platili',
			TmdToc_docta: 'Šta će uraditi docta.me',
			TmdToc_sources: 'Izvori',
			TmdLead1a:
				'U oktobru 2026. majka je dovela jedanaestogodišnju kćerku na kontrolni pregled u kliniku ',
			TmdLead1Link: 'Temel Dental',
			TmdLead1End:
				' u Podgorici. Već nekoliko dana kasnije porodica se našla u situaciji o kojoj se rijetko piše, ali se često priča privatno: na konsultaciji je usmeno dogovoreno liječenje „od oko 2.000 €“, plaćeno je 1.000 € — a tek nakon uplate porodica je iz prepiske saznala da cio plan košta 4.000 € i da se sastoji od drugih procedura, a ne onih o kojima je bilo riječi kod ljekara. Klinika odbija da vrati novac.',
			TmdLead2:
				'Prvo ono najvažnije: ovo je slučaj porodice autora sajta docta.me — kćerku je na konsultaciju vodila njegova supruga. Sajt vodi jedan čovjek, pa je „redakcija“ u ovom tekstu upravo on. Ovaj sukob interesa otvoreno objavljujemo, ne krijemo ga. Blizina priči ima i drugu stranu, koja radi za tačnost: prepiska, dokazi o plaćanju i sami događaji poznati su autoru iz prve ruke, a ne iz prepričavanja. Slučaj smo razložili korak po korak, uporedili ga sa javnim recenzijama o klinici i sa crnogorskim zakonima — i sastavili podsjetnik kako ne biste došli u sličnu situaciju. Stav klinike naveden je u tekstu — prema njenim odgovorima iz prepiske.',
			TmdCase1:
				'Stomatolog Temel Dentala je na kontrolnom pregledu uputio dijete ortodontu iste klinike — korak koji je sam po sebi opravdan. Na konsultaciji je ortodont usmeno iznio plan: pločica za širenje gornje vilice na oko šest mjeseci, zatim alajneri (providne folije). Ukupan trošak procijenio je na „oko 2.000 €“: 1.000 € odmah, zatim 100–200 € mjesečno za alajnere — počev kroz pola godine. Donju vilicu, po riječima ljekara, ne treba širiti: ona se „širi sama“.',
			TmdCase2:
				'Porodica je platila 1.000 €: 800 € karticom i 200 € u gotovini. Fiskalni račun za gotovinski dio nije izdat. Pisani ugovor nije zaključen, a porodica nije dobila ni plan liječenja sa fazama i cijenama na papiru — svi dogovori ostali su usmeni.',
			TmdCase3a:
				'Već nekoliko dana nakon uplate roditelji su uporedili cijene i utvrdili da slične pločice za širenje u drugim crnogorskim klinikama koštaju oko 200 €, dok je kod Temel Dentala ta stavka koštala 800 €. To potvrđuje i katalog docta.me: usluga „',
			TmdCase3Link: 'ortodontski pokretni pločasti aparat',
			TmdCase3End:
				'“ nalazi se u cjenovnicima 24 klinike, objavljene cijene idu od 180 do 300 € — uključujući 201,69 € u državnom ',
			TmdCase3KccgLink: 'Kliničkom centru Crne Gore',
			TmdCase3Tail:
				'. Porodica je pisala klinici: tražila je naziv brenda ili modela aparata i specifikaciju šta je obuhvaćeno uplaćenih 1.000 €.',
			TmdCase4:
				'Odgovor, kako proizilazi iz prepiske: „Ne postoji neka konkretna marka, to se u stomatologiji pravi svaki dan, rade ga tehničari.“ Klinika je zatim poslala dugačku poruku sa „planom liječenja“. Iz nje je slijedilo: plan čine pločice za obje vilice (po 800 €) plus fiksni aparat za 3.500–4.000 €; „redovna cijena“ paketa je 5.100–5.600 €, ali je „doktor ponudio specijalnu paketnu cijenu od 4.000 €“.',
			TmdCase5:
				'To se razlikovalo od konsultacije u dvije tačke. Fiksni aparat se pojavio umjesto alajnera o kojima je bilo riječi. A druga pločica — za donju vilicu — upravo je ona koju je ljekar na konsultaciji nazvao nepotrebnom. Iznos od 4.000 € prvi put je pomenut tek pošto je porodica uplatila 1.000 €.',
			TmdCase6:
				'Pacijentkinja je zatražila raskid i povraćaj uplaćenog: usluga suštinski nije pružena — uzeti su samo otisci, ugovora nema, faze nijesu pismeno utvrđene, račun nije izdat na cio iznos. Klinika je odbila da vrati novac. Evo citata iz njenih odgovora:',
			TmdQuote1:
				'„U Crnoj Gori nijedno ortodontsko liječenje ne košta 200 eura.“',
			TmdQuote2:
				'„Cijena liječenja je znatno viša, ali smo vam izašli u susret i dali popust.“',
			TmdQuote3:
				'„Nad vama nijesu izvođene nikakve složene medicinske procedure. Sve je urađeno u skladu sa našim važećim cjenovnikom. Uzeti su vam otisci, izvršili ste uplatu i izdat vam je račun.“',
			TmdQuote4: '„Sve naše radnje su u okviru zakona.“',
			TmdCase7:
				'Klinika je odbila da da kontakt ljekara koji vodi slučaj i predložila dolazak u ponedjeljak — da se sve razmotri sa ljekarima uz prevodioca (u prepisci se pominje „doktor Aleks“). Nakon toga se pacijentkinji javila direktorka centrale klinike u Turskoj — zamoljena je da to učini. Pacijentkinja joj je ponovo, tačku po tačku, izložila cijelu situaciju. Odgovor nije stigao; klinika i dalje odbija povraćaj novca. U međuvremenu je porodica svojoj banci podnijela zahtjev za osporavanje plaćanja (chargeback) — banka ga je primila i razmatra ga.',
			TmdSci1:
				'Rečenica ljekara o donjoj vilici odigrala je ključnu ulogu u ovoj priči — upravo se „nepotrebna“ pločica kasnije pojavila u planu sa cijenom od 800 € — pa je razmatramo posebno.',
			TmdSci2:
				'Sa stanovišta ortodoncije ispravnije je govoriti o zubnom nizu, a ne o vilici. Gornja vilica kod djeteta zaista može da se proširi skeletno: srednji nepčani šav je do završetka rasta popustljiv i na tome počiva rad pločica i aparata za širenje. U donjoj vilici takvog šava nema, pa se ona aparatom u skeletnom smislu uopšte ne može proširiti — pločica na donjem nizu samo naginje zube ka spolja.',
			TmdSci3:
				'„Spontane“ promjene donjeg niza nakon širenja gornje vilice u naučnoj literaturi zaista su opisane: donji zubi mogu blago da se usprave, a niz da se malo proširi. Ali sistematski pregled iz 2017. ocjenjuje te spontane promjene kao zanemarljive — reda veličine milimetra, bez klinički značajne razlike u odnosu na djecu koja uopšte nijesu liječena; pregled iz 2024. konstatuje da su rezultati istraživanja protivrječni. Naučno zrno u rečenici ljekara postoji, ali dokazna ortodoncija ne dozvoljava računanje na primjetan efekat „proširiće se sama“.',
			TmdSci4:
				'Ne upuštamo se u to kakav je plan potreban konkretnom djetetu — to je pitanje pregleda uživo. Problem je drugdje: dvije tvrdnje klinike su nespojive. Ako je ljekar bio u pravu i pločica za donju vilicu nije potrebna, njoj nema mjesta u planu od 800 €. Ako je pak potrebna — usmena procjena „oko 2.000 €“ bila je unaprijed nepotpuna. Između te dvije verzije — svega nekoliko dana i uplaćen avans.',
			TmdFlag1T: '1. Cijena se promijenila nakon uplate.',
			TmdFlag1X:
				'Na konsultaciji — „oko 2.000 €“, u prepisci nakon uplate — 4.000 € „sa popustom“ od „redovne cijene“ 5.100–5.600 €. Kako treba: puna cijena liječenja i cijena svake faze utvrđuju se pismeno prije prve uplate.',
			TmdFlag2T: '2. Sadržaj liječenja zamijenjen je skupljim.',
			TmdFlag2X:
				'Alajneri su postali fiksni aparat, a „nepotrebna“ pločica za donju vilicu postala je dio plana. Kako treba: izmjena plana znači novu konsultaciju i novu saglasnost pacijenta, a ne red u poruci.',
			TmdFlag3T: '3. Nema ugovora ni pisanog plana.',
			TmdFlag3X:
				'Usmene dogovore u sporu svaka strana prepričava na svoj način — i nemoguće ih je provjeriti. Kako treba: pisani plan sa dijagnozom, fazama, rokovima i cijenama uručuje se prije početka liječenja.',
			TmdFlag4T: '4. Račun nije izdat na cio iznos.',
			TmdFlag4X:
				'Od 1.000 € dokumentima je potvrđeno samo 800 € plaćenih karticom. Kako treba: fiskalni račun za svaku uplatu — i gotovinsku — zakonska je obaveza klinike, a ne ljubaznost.',
			TmdFlag5T: '5. Novac za nepruženu uslugu nije vraćen.',
			TmdFlag5X:
				'Stvarno su urađeni samo otisci, ali je klinika odbila da vrati razliku. Kako treba: ako liječenje nije počelo, pacijent ima pravo da od njega odustane; zadržati se može vrijednost stvarno izvedenih radova — i nju treba obrazložiti.',
			TmdRev1:
				'Pregledali smo javne recenzije o klinici na Google mapama. Profil Temel Dental policlinic (Donja Gorica, Bulevar 21 Maj, Podgorica) ima ocjenu 4,1 uz 69 recenzija; drugi profil iste klinike — 4,2 uz 84. Raspodjela je polarizovana: 51 recenzija sa pet zvjezdica, 14 sa jednom, sredine gotovo da nema. Takav profil ocjena je razlog da se čitaju upravo negativne recenzije: u njima se ponavljaju isti zapleti.',
			TmdRevPriceT: 'Cijena viša od najavljene.',
			TmdRevPriceX:
				'Autor recenzije na turskom (jedna zvjezdica, prije oko dva mjeseca) piše: prije vađenja zuba na pregledu je rečeno 80 €, „ako bude operacija — 150 €“; operacije nije bilo, zub je izvađen za minut, ali je ipak naplaćeno 150 €. Račun na molbu nijesu izdali, uz obećanje da će „poslati fotografiju“. Ono što se dogodilo autor naziva „resmen dolandırıcılık“ — „čista prevara“; naglašavamo da su to riječi autora recenzije, a ne redakcije. Recenzija na ruskom sa dvije zvjezdice (prije godinu dana): „SVAKI TERMIN KOD ORTODONTA KOŠTA 100 eura“ — pri zakazivanju je rečeno 15 €, u stolici je ispalo 100 €, iako je trebalo samo postaviti oprugu i zamijeniti gumicu.',
			TmdRevUpsellT: 'Nametanje usluga.',
			TmdRevUpsellX:
				'Recenzija na engleskom (jedna zvjezdica, prevod): „Svaki put sve gore… Došla sam s majkom da izvadi zub — odmah su počeli da joj nude dodatne usluge… Naplatili su maksimalnu cijenu iako procedura nije bila hirurška.“',
			TmdRevQualityT: 'Primjedbe na kvalitet.',
			TmdRevQualityX:
				'Autor još jedne recenzije na engleskom („High prices and low quality“) tvrdi da je glavni stomatolog Ibrahim Temel izbrusio zdrav zub, nakon čega je zatrebala krunica. Drugi piše: tri mjeseca nakon zamjene krunice ispod nje je počela upala, ljekar je odbio da je zamijeni; pri vađenju umnjaka u desni je ostao fragment.',
			TmdRevOrgT: 'Organizacija prijema.',
			TmdRevOrgX:
				'U recenziji na ruskom (prije godinu dana) — umjesto oboljelog ljekara pacijenta je primio „neki lik u džemperu, bez mantila“, a asistirala je administratorka sa recepcije. U drugoj — termin u 9.00, ljekar se nije pojavio ni do 9.20; u javnom odgovoru klinika se pozvala na „probleme sa opremom“, što autor naziva neistinom.',
			TmdRevTg:
				'Još jedno zapažanje redakcije. U ruskojezičnom Telegram-četu o medicini u Crnoj Gori klinika od 2023. redovno objavljuje reklame — desetine objava. Živih rasprava i preporuka pacijenata tamo nema: vidljivost brenda u ruskojezičnoj zajednici stvorila je sama klinika.',
			TmdPos1:
				'Klinika smatra da su njeni postupci zakoniti. Njeni argumenti iz prepiske: pacijentkinji su uzeti otisci, izvršila je uplatu, izdat joj je račun; sve je urađeno „u skladu sa važećim cjenovnikom“ i „u okviru zakona“. Cijenu od 200 € za pločicu koju su naveli roditelji klinika odbacuje: „U Crnoj Gori nijedno ortodontsko liječenje ne košta 200 eura.“',
			TmdPos2a: 'Objavljeni cjenovnici govore suprotno: ',
			TmdPos2Link: 'ortodontski pokretni pločasti aparat',
			TmdPos2End:
				' u klinikama širom zemlje košta od 180 do 300 €, uključujući 201,69 € u Kliničkom centru Crne Gore.',
			TmdPos3:
				'Paket od 4.000 € klinika predstavlja kao popust u odnosu na redovnu cijenu od 5.100–5.600 €. Najzad, klinika je nudila susret uživo: doći u ponedjeljak i razmotriti situaciju sa ljekarima uz prevodioca. Ako nam klinika dostavi sadržajan komentar, dopunićemo tekst.',
			TmdLawPriceT: 'Pravo da se cijena zna unaprijed.',
			TmdLawPriceX:
				'Zakon o zaštiti potrošača (novu verziju parlament je usvojio u februaru 2026) garantuje potrošaču jasnu informaciju o cijeni robe ili usluge prije kupovine. Usmena procjena „oko 2.000 €“ koja se nakon uplate pretvara u 4.000 € teško se miri s tim načelom — ali usmene dogovore je teško dokazati, zato je pisani plan i važan.',
			TmdLawFiscalT: 'Fiskalni račun za svaku uplatu.',
			TmdLawFiscalX:
				'Zakon o fiskalizaciji u prometu proizvoda i usluga („Sl. list CG“ 46/2019 i 73/2019) obavezuje da svaka uplata, uključujući gotovinu, prođe kroz fiskalni sistem uz izdavanje računa. Pravnim licima za prekršaje prijete kazne do 40.000 €.',
			TmdLawConsentT: 'Saglasnost za liječenje.',
			TmdLawConsentX:
				'Zakon o pravima pacijenata („Sl. list CG“ 40/2010 i 40/2011) garantuje pravo na informaciju o predloženom liječenju i na saglasnost; pritužbe pacijenata razmatra zaštitnik prava pacijenata. Prema pisanju stručnih medija, institut zaštitnika prava pacijenata uvođen je i u stomatološkim ordinacijama.',
			TmdLawWhereT: 'Kome se žaliti.',
			TmdLawWhereX:
				'Tržišnoj inspekciji u sastavu Uprave za inspekcijske poslove — za povrede prava potrošača i neizdavanje računa. Stomatološkoj komori Crne Gore (radi od 2016) — za postupke ljekara. Potrošačka organizacija CEZAP (Centar za zaštitu potrošača, cezap.me) savjetuje u sporovima. U svakom slučaju treba početi pisanim obraćanjem uz priložena dokumenta.',
			TmdCheck0:
				'Tražiti od ljekara ugovor i specifikaciju cijena jeste neprijatno — ljekaru želimo da vjerujemo, na tom povjerenju sve i počiva. Ali pisani plan je uobičajena svjetska praksa i savjesnu kliniku takva molba neće uvrijediti. Evo šta treba uraditi prije prve uplate:',
			TmdCheck1:
				'Tražite pisani plan liječenja: dijagnoza, faze, rokovi, cijena svake faze i ukupan iznos. Nema plana — nema uplate.',
			TmdCheck2:
				'Zaključite ugovor sa klinikom — na papiru, sa podacima firme.',
			TmdCheck3:
				'Uzimajte fiskalni račun za svaku uplatu, i gotovinsku. „Poslaćemo fotografiju računa“ nije račun.',
			TmdCheck4:
				'Potražite drugo mišljenje: konsultacija kod drugog ortodonta košta desetine eura, a čuva od suvišnih troškova u hiljadama.',
			TmdCheck5:
				'Ne plaćajte unaprijed faze koje počinju kroz pola godine — fazu platite kad počne.',
			TmdCheck6:
				'Uporedite cijene: na docta.me objavljeni su cjenovnici crnogorskih klinika. Razlika od nekoliko puta razlog je za pitanja prije uplate, a ne poslije.',
			TmdPaid0:
				'Ako ste u ovoj priči prepoznali svoju, prvo i najvažnije: nijeste ni za šta krivi. Vjerovati ljekaru je normalno, tako i treba; koristiti to povjerenje — izbor je klinike, a ne vaša greška. Evo šta se može uraditi — mirno, korak po korak:',
			TmdPaid1:
				'Uputite klinici pisanu reklamaciju (može i mejlom): šta je plaćeno, šta je stvarno pruženo, zahtjev za povraćaj razlike i rok za odgovor.',
			TmdPaid2:
				'Prikupite dokaze: prepisku, račune, izvod sa kartice, fotografije cjenovnika u klinici.',
			TmdPaid3:
				'Žalite se tržišnoj inspekciji (Uprava za inspekcijske poslove) — naročito ako račun nije izdat ili se cijena razišla sa cjenovnikom.',
			TmdPaid4:
				'Za medicinsku stranu spora — izmjena plana liječenja bez vaše saglasnosti — obratite se zaštitniku prava pacijenata i Stomatološkoj komori.',
			TmdPaid5:
				'Ako ste platili karticom, raspitajte se u banci o proceduri osporavanja plaćanja (chargeback): za kartična plaćanja ona postoji; trebaće opis situacije i prepiska sa klinikom. Razmatranje obično traje od jednog do tri mjeseca — budite strpljivi, to su normalni rokovi.',
			TmdPaid6: 'Za savjet se možete obratiti CEZAP-u.',
			TmdDocta1:
				'Ovaj slučaj nije samo priča o jednoj klinici. On je o praksi u kojoj se konačna cijena saopštava naknadno, a pacijent nema nijedan dokument kojim bi se sporio. docta.me uvodi oznaku „oprez“ za klinike sa dokumentovanim pritužbama i rubriku „reputacija klinike“, u kojoj će se takve pritužbe prikupljati u standardizovanom obliku. Recenzija junakinje ovog teksta objavljena je kao verifikovana: autor je sva dokumenta u ovom slučaju vidio lično (v. napomenu o sukobu interesa na početku).',
			TmdDocta2:
				'Ako ste se susreli sa sličnom praksom — u ovoj ili drugoj klinici — pišite nam i priložite dokumenta. Što je više dokumentovanih priča, teže je da takva praksa ostane norma.',
			TmdSrcIntro:
				'Prepiska pacijentkinje sa klinikom i dokazi o plaćanju nalaze se kod redakcije. Javne recenzije — profili Temel Dental policlinic na Google mapama (Podgorica). Pravni i naučni izvori:',
			TmdSrcSci2017:
				'Sistematski pregled (2017): spontane dentoalveolarne promjene donjeg niza nakon širenja gornje vilice',
			TmdSrcSci2024:
				'Sistematski pregled (2024, Children): promjene donjeg niza nakon RME, SME i leaf ekspandera',
			TmdSrcZzp:
				'Zakon o zaštiti potrošača — nova verzija (Službeni list CG, februar 2026)',
			TmdSrcFisk:
				'Zakon o fiskalizaciji — fiskalni računi i kazne (paragraf.me)',
			TmdSrcPrava:
				'Zakon o pravima pacijenata — prava pacijenata i zaštitnik (paragraf.me)',
			TmdSrcCezap: 'CEZAP — Centar za zaštitu potrošača Crne Gore',
			TmdCtaTitle: 'Provjerite cijene prije uplate',
			TmdCtaText:
				'Na docta.me objavljeni su cjenovnici crnogorskih klinika — pogledajte koliko usluga košta drugdje.',
			TmdCtaButton: 'Uporedi cijene',
		},
		'sr-cyrl': {
			TmdTitle:
				'Temel Dental у Подгорици: 2.000 € усмено, 4.000 € након уплате',
			TmdDescription:
				'Документован случај у стоматолошкој клиници Temel Dental (Подгорица): породица је платила 1.000 € за лијечење „од око 2.000 €“, а неколико дана касније сазнала да план кошта 4.000 € и да се састоји од других процедура. Клиника одбија повраћај новца. Преписка, рецензије, црногорски закони и подсјетник за пацијенте.',
			TmdToc_case: 'Хронологија: од контролног прегледа до „пакетне цијене“',
			TmdToc_science: 'Може ли се доња вилица „проширити сама“?',
			TmdToc_flags: 'Пет црвених заставица',
			TmdToc_reviews: 'Рецензије о Temel Dental-у: случај није усамљен',
			TmdToc_position: 'Став клинике Temel Dental',
			TmdToc_law: 'Шта каже црногорски закон',
			TmdToc_checklist: 'Подсјетник: прије него што платите ортодонту',
			TmdToc_paid: 'Ако сте већ платили',
			TmdToc_docta: 'Шта ће урадити docta.me',
			TmdToc_sources: 'Извори',
			TmdLead1a:
				'У октобру 2026. мајка је довела једанаестогодишњу кћерку на контролни преглед у клинику ',
			TmdLead1Link: 'Temel Dental',
			TmdLead1End:
				' у Подгорици. Већ неколико дана касније породица се нашла у ситуацији о којој се ријетко пише, али се често прича приватно: на консултацији је усмено договорено лијечење „од око 2.000 €“, плаћено је 1.000 € — а тек након уплате породица је из преписке сазнала да цио план кошта 4.000 € и да се састоји од других процедура, а не оних о којима је било ријечи код љекара. Клиника одбија да врати новац.',
			TmdLead2:
				'Прво оно најважније: ово је случај породице аутора сајта docta.me — кћерку је на консултацију водила његова супруга. Сајт води један човјек, па је „редакција“ у овом тексту управо он. Овај сукоб интереса отворено објављујемо, не кријемо га. Близина причи има и другу страну, која ради за тачност: преписка, докази о плаћању и сами догађаји познати су аутору из прве руке, а не из препричавања. Случај смо разложили корак по корак, упоредили га са јавним рецензијама о клиници и са црногорским законима — и саставили подсјетник како не бисте дошли у сличну ситуацију. Став клинике наведен је у тексту — према њеним одговорима из преписке.',
			TmdCase1:
				'Стоматолог Temel Dental-а је на контролном прегледу упутио дијете ортодонту исте клинике — корак који је сам по себи оправдан. На консултацији је ортодонт усмено изнио план: плочица за ширење горње вилице на око шест мјесеци, затим алајнери (провидне фолије). Укупан трошак проценио је на „око 2.000 €“: 1.000 € одмах, затим 100–200 € мјесечно за алајнере — почев кроз пола године. Доњу вилицу, по ријечима љекара, не треба ширити: она се „шири сама“.',
			TmdCase2:
				'Породица је платила 1.000 €: 800 € картицом и 200 € у готовини. Фискални рачун за готовински дио није издат. Писани уговор није закључен, а породица није добила ни план лијечења са фазама и цијенама на папиру — сви договори остали су усмени.',
			TmdCase3a:
				'Већ неколико дана након уплате родитељи су упоредили цијене и утврдили да сличне плочице за ширење у другим црногорским клиникама коштају око 200 €, док је код Temel Dental-а та ставка коштала 800 €. То потврђује и каталог docta.me: услуга „',
			TmdCase3Link: 'ортодонтски покретни плочасти апарат',
			TmdCase3End:
				'“ налази се у цјеновницима 24 клинике, објављене цијене иду од 180 до 300 € — укључујући 201,69 € у државном ',
			TmdCase3KccgLink: 'Клиничком центру Црне Горе',
			TmdCase3Tail:
				'. Породица је писала клиници: тражила је назив бренда или модела апарата и спецификацију шта је обухваћено уплаћених 1.000 €.',
			TmdCase4:
				'Одговор, како произилази из преписке: „Не постоји нека конкретна марка, то се у стоматологији прави сваки дан, раде га техничари.“ Клиника је затим послала дугачку поруку са „планом лијечења“. Из ње је слиједило: план чине плочице за обје вилице (по 800 €) плус фиксни апарат за 3.500–4.000 €; „редовна цијена“ пакета је 5.100–5.600 €, али је „доктор понудио специјалну пакетну цијену од 4.000 €“.',
			TmdCase5:
				'То се разликовало од консултације у двије тачке. Фиксни апарат се појавио умјесто алајнера о којима је било ријечи. А друга плочица — за доњу вилицу — управо је она коју је љекар на консултацији назвао непотребном. Износ од 4.000 € први пут је поменут тек пошто је породица уплатила 1.000 €.',
			TmdCase6:
				'Пацијенткиња је затражила раскид и повраћај уплаћеног: услуга суштински није пружена — узети су само отисци, уговора нема, фазе нијесу писмено утврђене, рачун није издат на цио износ. Клиника је одбила да врати новац. Ево цитата из њених одговора:',
			TmdQuote1:
				'„У Црној Гори ниједно ортодонтско лијечење не кошта 200 еура.“',
			TmdQuote2:
				'„Цијена лијечења је знатно виша, али смо вам изашли у сусрет и дали попуст.“',
			TmdQuote3:
				'„Над вама нијесу извођене никакве сложене медицинске процедуре. Све је урађено у складу са нашим важећим цјеновником. Узети су вам отисци, извршили сте уплату и издат вам је рачун.“',
			TmdQuote4: '„Све наше радње су у оквиру закона.“',
			TmdCase7:
				'Клиника је одбила да да контакт љекара који води случај и предложила долазак у понедјељак — да се све размотри са љекарима уз преводиоца (у преписци се помиње „доктор Алекс“). Након тога се пацијенткињи јавила директорка централе клинике у Турској — замољена је да то учини. Пацијенткиња јој је поново, тачку по тачку, изложила цијелу ситуацију. Одговор није стигао; клиника и даље одбија повраћај новца. У међувремену је породица својој банци поднијела захтјев за оспоравање плаћања (chargeback) — банка га је примила и разматра га.',
			TmdSci1:
				'Реченица љекара о доњој вилици одиграла је кључну улогу у овој причи — управо се „непотребна“ плочица касније појавила у плану са цијеном од 800 € — па је разматрамо посебно.',
			TmdSci2:
				'Са становишта ортодонције исправније је говорити о зубном низу, а не о вилици. Горња вилица код дјетета заиста може да се прошири скелетно: средњи непчани шав је до завршетка раста попустљив и на томе почива рад плочица и апарата за ширење. У доњој вилици таквог шва нема, па се она апаратом у скелетном смислу уопште не може проширити — плочица на доњем низу само нагиње зубе ка споља.',
			TmdSci3:
				'„Спонтане“ промјене доњег низа након ширења горње вилице у научној литератури заиста су описане: доњи зуби могу благо да се усправе, а низ да се мало прошири. Али систематски преглед из 2017. оцјењује те спонтане промјене као занемарљиве — реда величине милиметра, без клинички значајне разлике у односу на дјецу која уопште нијесу лијечена; преглед из 2024. констатује да су резултати истраживања противрјечни. Научно зрно у реченици љекара постоји, али доказна ортодонција не дозвољава рачунање на примјетан ефекат „прошириће се сама“.',
			TmdSci4:
				'Не упуштамо се у то какав је план потребан конкретном дјетету — то је питање прегледа уживо. Проблем је другдје: двије тврдње клинике су неспојиве. Ако је љекар био у праву и плочица за доњу вилицу није потребна, њој нема мјеста у плану од 800 €. Ако је пак потребна — усмена процјена „око 2.000 €“ била је унапријед непотпуна. Између те двије верзије — свега неколико дана и уплаћен аванс.',
			TmdFlag1T: '1. Цијена се промијенила након уплате.',
			TmdFlag1X:
				'На консултацији — „око 2.000 €“, у преписци након уплате — 4.000 € „са попустом“ од „редовне цијене“ 5.100–5.600 €. Како треба: пуна цијена лијечења и цијена сваке фазе утврђују се писмено прије прве уплате.',
			TmdFlag2T: '2. Садржај лијечења замијењен је скупљим.',
			TmdFlag2X:
				'Алајнери су постали фиксни апарат, а „непотребна“ плочица за доњу вилицу постала је дио плана. Како треба: измјена плана значи нову консултацију и нову сагласност пацијента, а не ред у поруци.',
			TmdFlag3T: '3. Нема уговора ни писаног плана.',
			TmdFlag3X:
				'Усмене договоре у спору свака страна препричава на свој начин — и немогуће их је провјерити. Како треба: писани план са дијагнозом, фазама, роковима и цијенама уручује се прије почетка лијечења.',
			TmdFlag4T: '4. Рачун није издат на цио износ.',
			TmdFlag4X:
				'Од 1.000 € документима је потврђено само 800 € плаћених картицом. Како треба: фискални рачун за сваку уплату — и готовинску — законска је обавеза клинике, а не љубазност.',
			TmdFlag5T: '5. Новац за непружену услугу није враћен.',
			TmdFlag5X:
				'Стварно су урађени само отисци, али је клиника одбила да врати разлику. Како треба: ако лијечење није почело, пацијент има право да од њега одустане; задржати се може вриједност стварно изведених радова — и њу треба образложити.',
			TmdRev1:
				'Прегледали смо јавне рецензије о клиници на Google мапама. Профил Temel Dental policlinic (Доња Горица, Булевар 21. мај, Подгорица) има оцјену 4,1 уз 69 рецензија; други профил исте клинике — 4,2 уз 84. Расподјела је поларизована: 51 рецензија са пет звјездица, 14 са једном, средине готово да нема. Такав профил оцјена је разлог да се читају управо негативне рецензије: у њима се понављају исти заплети.',
			TmdRevPriceT: 'Цијена виша од најављене.',
			TmdRevPriceX:
				'Аутор рецензије на турском (једна звјездица, прије око два мјесеца) пише: прије вађења зуба на прегледу је речено 80 €, „ако буде операција — 150 €“; операције није било, зуб је извађен за минут, али је ипак наплаћено 150 €. Рачун на молбу нијесу издали, уз обећање да ће „послати фотографију“. Оно што се догодило аутор назива „resmen dolandırıcılık“ — „чиста превара“; наглашавамо да су то ријечи аутора рецензије, а не редакције. Рецензија на руском са двије звјездице (прије годину дана): „СВАКИ ТЕРМИН КОД ОРТОДОНТА КОШТА 100 еура“ — при заказивању је речено 15 €, у столици је испало 100 €, иако је требало само поставити опругу и замијенити гумицу.',
			TmdRevUpsellT: 'Наметање услуга.',
			TmdRevUpsellX:
				'Рецензија на енглеском (једна звјездица, превод): „Сваки пут све горе… Дошла сам с мајком да извади зуб — одмах су почели да јој нуде додатне услуге… Наплатили су максималну цијену иако процедура није била хируршка.“',
			TmdRevQualityT: 'Примједбе на квалитет.',
			TmdRevQualityX:
				'Аутор још једне рецензије на енглеском („High prices and low quality“) тврди да је главни стоматолог Ibrahim Temel избрусио здрав зуб, након чега је затребала круница. Други пише: три мјесеца након замјене крунице испод ње је почела упала, љекар је одбио да је замијени; при вађењу умњака у десни је остао фрагмент.',
			TmdRevOrgT: 'Организација пријема.',
			TmdRevOrgX:
				'У рецензији на руском (прије годину дана) — умјесто обољелог љекара пацијента је примио „неки лик у џемперу, без мантила“, а асистирала је администраторка са рецепције. У другој — термин у 9.00, љекар се није појавио ни до 9.20; у јавном одговору клиника се позвала на „проблеме са опремом“, што аутор назива неистином.',
			TmdRevTg:
				'Још једно запажање редакције. У рускојезичном Telegram-чету о медицини у Црној Гори клиника од 2023. редовно објављује рекламе — десетине објава. Живих расправа и препорука пацијената тамо нема: видљивост бренда у рускојезичној заједници створила је сама клиника.',
			TmdPos1:
				'Клиника сматра да су њени поступци законити. Њени аргументи из преписке: пацијенткињи су узети отисци, извршила је уплату, издат јој је рачун; све је урађено „у складу са важећим цјеновником“ и „у оквиру закона“. Цијену од 200 € за плочицу коју су навели родитељи клиника одбацује: „У Црној Гори ниједно ортодонтско лијечење не кошта 200 еура.“',
			TmdPos2a: 'Објављени цјеновници говоре супротно: ',
			TmdPos2Link: 'ортодонтски покретни плочасти апарат',
			TmdPos2End:
				' у клиникама широм земље кошта од 180 до 300 €, укључујући 201,69 € у Клиничком центру Црне Горе.',
			TmdPos3:
				'Пакет од 4.000 € клиника представља као попуст у односу на редовну цијену од 5.100–5.600 €. Најзад, клиника је нудила сусрет уживо: доћи у понедјељак и размотрити ситуацију са љекарима уз преводиоца. Ако нам клиника достави садржајан коментар, допунићемо текст.',
			TmdLawPriceT: 'Право да се цијена зна унапријед.',
			TmdLawPriceX:
				'Закон о заштити потрошача (нову верзију парламент је усвојио у фебруару 2026) гарантује потрошачу јасну информацију о цијени робе или услуге прије куповине. Усмена процјена „око 2.000 €“ која се након уплате претвара у 4.000 € тешко се мири с тим начелом — али усмене договоре је тешко доказати, зато је писани план и важан.',
			TmdLawFiscalT: 'Фискални рачун за сваку уплату.',
			TmdLawFiscalX:
				'Закон о фискализацији у промету производа и услуга („Сл. лист ЦГ“ 46/2019 и 73/2019) обавезује да свака уплата, укључујући готовину, прође кроз фискални систем уз издавање рачуна. Правним лицима за прекршаје пријете казне до 40.000 €.',
			TmdLawConsentT: 'Сагласност за лијечење.',
			TmdLawConsentX:
				'Закон о правима пацијената („Сл. лист ЦГ“ 40/2010 и 40/2011) гарантује право на информацију о предложеном лијечењу и на сагласност; притужбе пацијената разматра заштитник права пацијената. Према писању стручних медија, институт заштитника права пацијената увођен је и у стоматолошким ординацијама.',
			TmdLawWhereT: 'Коме се жалити.',
			TmdLawWhereX:
				'Тржишној инспекцији у саставу Управе за инспекцијске послове — за повреде права потрошача и неиздавање рачуна. Стоматолошкој комори Црне Горе (ради од 2016) — за поступке љекара. Потрошачка организација CEZAP (Centar za zaštitu potrošača, cezap.me) савјетује у споровима. У сваком случају треба почети писаним обраћањем уз приложена документа.',
			TmdCheck0:
				'Тражити од љекара уговор и спецификацију цијена јесте непријатно — љекару желимо да вјерујемо, на том повјерењу све и почива. Али писани план је уобичајена свјетска пракса и савјесну клинику таква молба неће увриједити. Ево шта треба урадити прије прве уплате:',
			TmdCheck1:
				'Тражите писани план лијечења: дијагноза, фазе, рокови, цијена сваке фазе и укупан износ. Нема плана — нема уплате.',
			TmdCheck2: 'Закључите уговор са клиником — на папиру, са подацима фирме.',
			TmdCheck3:
				'Узимајте фискални рачун за сваку уплату, и готовинску. „Послаћемо фотографију рачуна“ није рачун.',
			TmdCheck4:
				'Потражите друго мишљење: консултација код другог ортодонта кошта десетине еура, а чува од сувишних трошкова у хиљадама.',
			TmdCheck5:
				'Не плаћајте унапријед фазе које почињу кроз пола године — фазу платите кад почне.',
			TmdCheck6:
				'Упоредите цијене: на docta.me објављени су цјеновници црногорских клиника. Разлика од неколико пута разлог је за питања прије уплате, а не послије.',
			TmdPaid0:
				'Ако сте у овој причи препознали своју, прво и најважније: нијесте ни за шта криви. Вјеровати љекару је нормално, тако и треба; користити то повјерење — избор је клинике, а не ваша грешка. Ево шта се може урадити — мирно, корак по корак:',
			TmdPaid1:
				'Упутите клиници писану рекламацију (може и мејлом): шта је плаћено, шта је стварно пружено, захтјев за повраћај разлике и рок за одговор.',
			TmdPaid2:
				'Прикупите доказе: преписку, рачуне, извод са картице, фотографије цјеновника у клиници.',
			TmdPaid3:
				'Жалите се тржишној инспекцији (Управа за инспекцијске послове) — нарочито ако рачун није издат или се цијена разишла са цјеновником.',
			TmdPaid4:
				'За медицинску страну спора — измјена плана лијечења без ваше сагласности — обратите се заштитнику права пацијената и Стоматолошкој комори.',
			TmdPaid5:
				'Ако сте платили картицом, распитајте се у банци о процедури оспоравања плаћања (chargeback): за картична плаћања она постоји; требаће опис ситуације и преписка са клиником. Разматрање обично траје од једног до три мјесеца — будите стрпљиви, то су нормални рокови.',
			TmdPaid6: 'За савјет се можете обратити CEZAP-у.',
			TmdDocta1:
				'Овај случај није само прича о једној клиници. Он је о пракси у којој се коначна цијена саопштава накнадно, а пацијент нема ниједан документ којим би се спорио. docta.me уводи ознаку „опрез“ за клинике са документованим притужбама и рубрику „репутација клинике“, у којој ће се такве притужбе прикупљати у стандардизованом облику. Рецензија јунакиње овог текста објављена је као верификована: аутор је сва документа у овом случају видио лично (в. напомену о сукобу интереса на почетку).',
			TmdDocta2:
				'Ако сте се сусрели са сличном праксом — у овој или другој клиници — пишите нам и приложите документа. Што је више документованих прича, теже је да таква пракса остане норма.',
			TmdSrcIntro:
				'Преписка пацијенткиње са клиником и докази о плаћању налазе се код редакције. Јавне рецензије — профили Temel Dental policlinic на Google мапама (Подгорица). Правни и научни извори:',
			TmdSrcSci2017:
				'Систематски преглед (2017): спонтане дентоалвеоларне промјене доњег низа након ширења горње вилице',
			TmdSrcSci2024:
				'Систематски преглед (2024, Children): промјене доњег низа након RME, SME и leaf експандера',
			TmdSrcZzp:
				'Закон о заштити потрошача — нова верзија (Службени лист ЦГ, фебруар 2026)',
			TmdSrcFisk:
				'Закон о фискализацији — фискални рачуни и казне (paragraf.me)',
			TmdSrcPrava:
				'Закон о правима пацијената — права пацијената и заштитник (paragraf.me)',
			TmdSrcCezap: 'CEZAP — Центар за заштиту потрошача Црне Горе',
			TmdCtaTitle: 'Провјерите цијене прије уплате',
			TmdCtaText:
				'На docta.me објављени су цјеновници црногорских клиника — погледајте колико услуга кошта другдје.',
			TmdCtaButton: 'Упореди цијене',
		},
		'de': {
			TmdTitle:
				'Temel Dental in Podgorica: 2.000 € mündlich, 4.000 € nach der Zahlung',
			TmdDescription:
				'Ein dokumentierter Fall in der Zahnklinik Temel Dental (Podgorica): Eine Familie zahlte 1.000 € an für eine Behandlung „um die 2.000 €“ — wenige Tage später hieß es, der Plan koste 4.000 € und bestehe aus anderen Leistungen. Die Rückerstattung lehnt die Klinik ab. Korrespondenz, Bewertungen, montenegrinische Gesetze und eine Checkliste.',
			TmdToc_case: 'Chronologie: von der Routinekontrolle zum „Paketpreis“',
			TmdToc_science: 'Kann sich der Unterkiefer „von selbst weiten“?',
			TmdToc_flags: 'Fünf rote Flaggen',
			TmdToc_reviews: 'Bewertungen zu Temel Dental: kein Einzelfall',
			TmdToc_position: 'Die Position von Temel Dental',
			TmdToc_law: 'Was das montenegrinische Gesetz sagt',
			TmdToc_checklist: 'Checkliste: bevor Sie einen Kieferorthopäden bezahlen',
			TmdToc_paid: 'Wenn Sie schon gezahlt haben',
			TmdToc_docta: 'Was docta.me tun wird',
			TmdToc_sources: 'Quellen',
			TmdLead1a:
				'Im Oktober 2026 brachte eine Mutter ihre 11-jährige Tochter zur Routinekontrolle in die Klinik ',
			TmdLead1Link: 'Temel Dental',
			TmdLead1End:
				' in Podgorica. Nur wenige Tage später fand sich die Familie in einer Situation wieder, über die selten geschrieben, aber oft privat erzählt wird: In der Beratung wurde mündlich eine Behandlung „um die 2.000 €“ besprochen, 1.000 € wurden gezahlt — und erst nach der Zahlung erfuhr die Familie aus der Korrespondenz, dass der vollständige Plan 4.000 € kostet und aus anderen Leistungen besteht als beim Arzt besprochen. Die Rückzahlung lehnt die Klinik ab.',
			TmdLead2:
				'Zuerst das Wichtigste: Es ist der Fall der Familie des Autors von docta.me — seine Frau ging mit der Tochter zur Beratung. Die Seite wird von einer Person betrieben, die „Redaktion“ in diesem Text ist also er. Wir legen diesen Interessenkonflikt offen, statt ihn zu verstecken. Die Nähe zur Geschichte hat auch eine Kehrseite, die der Genauigkeit dient: Korrespondenz, Zahlungsbelege und die Ereignisse selbst sind dem Autor aus erster Hand bekannt, nicht aus Nacherzählungen. Wir haben den Fall Schritt für Schritt aufgearbeitet, ihn mit öffentlichen Bewertungen der Klinik und mit montenegrinischem Recht abgeglichen — und eine Checkliste erstellt, wie man nicht in eine ähnliche Lage gerät. Die Position der Klinik ist im Text wiedergegeben — nach ihren Antworten aus der Korrespondenz.',
			TmdCase1:
				'Der Zahnarzt von Temel Dental überwies das Kind bei der Routinekontrolle an den Kieferorthopäden derselben Klinik — für sich genommen ein nachvollziehbarer Schritt. In der Beratung legte der Kieferorthopäde den Plan mündlich dar: eine Dehnplatte für den Oberkiefer für etwa sechs Monate, danach Aligner. Die Gesamtkosten schätzte er auf „um die 2.000 €“: 1.000 € sofort, dann 100–200 € pro Monat für Aligner — beginnend in einem halben Jahr. Den Unterkiefer müsse man laut Arzt nicht weiten: Er „weitet sich von selbst“.',
			TmdCase2:
				'Die Familie zahlte 1.000 €: 800 € mit Karte und 200 € in bar. Für den Baranteil wurde kein Kassenbeleg ausgestellt. Ein schriftlicher Vertrag wurde nicht geschlossen, einen schriftlichen Behandlungsplan mit Etappen und Preisen erhielt die Familie ebenfalls nicht — alle Absprachen blieben mündlich.',
			TmdCase3a:
				'Schon wenige Tage nach der Zahlung verglichen die Eltern die Preise und stellten fest, dass vergleichbare Dehnplatten in anderen Kliniken Montenegros rund 200 € kosten, während diese Position bei Temel Dental 800 € gekostet hatte. Der Katalog von docta.me bestätigt das: Die Leistung „',
			TmdCase3Link: 'herausnehmbare kieferorthopädische Dehnplatte',
			TmdCase3End:
				'“ steht in den Preislisten von 24 Kliniken, die veröffentlichten Preise reichen von 180 bis 300 € — darunter 201,69 € im staatlichen ',
			TmdCase3KccgLink: 'Klinischen Zentrum Montenegros',
			TmdCase3Tail:
				'. Die Familie schrieb der Klinik: Sie bat um Marke oder Modell des Geräts und um eine Aufschlüsselung, was die gezahlten 1.000 € umfassen.',
			TmdCase4:
				'Die Antwort laut Korrespondenz: „Es gibt keine bestimmte Marke, das wird in der Zahnmedizin jeden Tag von Technikern gefertigt.“ Dann schickte die Klinik eine lange Nachricht mit einem „Behandlungsplan“. Daraus ging hervor: Der Plan besteht aus Platten für beide Kiefer (je 800 €) plus einer festen Zahnspange für 3.500–4.000 €; der „reguläre Preis“ des Pakets liege bei 5.100–5.600 €, aber „der Arzt hat einen speziellen Paketpreis von 4.000 € angeboten“.',
			TmdCase5:
				'Das wich in zwei Punkten von der Beratung ab. Statt der besprochenen Aligner tauchte eine feste Zahnspange auf. Und die zweite Platte — für den Unterkiefer — war genau jene, die der Arzt in der Beratung für unnötig erklärt hatte. Die Summe von 4.000 € fiel zum ersten Mal, nachdem die Familie bereits 1.000 € gezahlt hatte.',
			TmdCase6:
				'Die Patientin bat darum, das Verhältnis zu beenden und die Zahlung zu erstatten: Die Leistung sei im Kern nicht erbracht — nur Abdrücke wurden genommen, es gibt keinen Vertrag, keine schriftlich fixierten Etappen, und der Beleg deckt nicht die volle Summe. Die Klinik lehnte die Rückzahlung ab. Zitate aus ihren Antworten:',
			TmdQuote1:
				'„In Montenegro kostet keine kieferorthopädische Behandlung 200 Euro.“',
			TmdQuote2:
				'„Die Behandlungskosten sind deutlich höher, aber wir sind Ihnen entgegengekommen und haben einen Rabatt gewährt.“',
			TmdQuote3:
				'„Bei Ihnen wurden keine komplexen medizinischen Eingriffe vorgenommen. Alles geschah gemäß unserer gültigen Preisliste. Es wurden Abdrücke genommen, Sie haben gezahlt, und Ihnen wurde eine Rechnung ausgestellt.“',
			TmdQuote4:
				'„Alle unsere Handlungen bewegen sich im Rahmen des Gesetzes.“',
			TmdCase7:
				'Den Kontakt des behandelnden Arztes gab die Klinik nicht heraus und schlug vor, am Montag zu kommen — um alles mit den Ärzten über einen Dolmetscher zu besprechen (in der Korrespondenz wird ein „Doktor Alex“ erwähnt). Danach meldete sich bei der Patientin die Direktorin der Zentrale der Klinik in der Türkei — man hatte sie darum gebeten. Die Patientin legte ihr die ganze Situation noch einmal Punkt für Punkt dar. Eine Antwort blieb aus; die Rückzahlung verweigert die Klinik weiterhin. Inzwischen hat die Familie bei ihrer Bank einen Chargeback-Antrag gestellt — die Bank hat ihn angenommen und prüft den Fall.',
			TmdSci1:
				'Der Satz des Arztes über den Unterkiefer spielte in dieser Geschichte eine Schlüsselrolle — genau die „unnötige“ Platte tauchte später mit 800 € im Plan auf —, deshalb schauen wir ihn uns gesondert an.',
			TmdSci2:
				'Kieferorthopädisch korrekter ist es, vom Zahnbogen zu sprechen, nicht vom Kiefer. Der Oberkiefer eines Kindes lässt sich tatsächlich skelettal weiten: Bis zum Wachstumsabschluss ist die mediane Gaumennaht nachgiebig, darauf beruhen Dehnplatten und -apparaturen. Im Unterkiefer gibt es keine solche Naht, er lässt sich mit einer Apparatur im skelettalen Sinn grundsätzlich nicht weiten — eine Platte am unteren Zahnbogen kippt die Zähne lediglich nach außen.',
			TmdSci3:
				'„Spontane“ Veränderungen des unteren Zahnbogens nach einer Oberkieferdehnung sind in der Fachliteratur tatsächlich beschrieben: Die unteren Zähne können sich leicht aufrichten, der Bogen kann sich etwas weiten. Doch eine systematische Übersichtsarbeit von 2017 bewertet diese spontanen Veränderungen als vernachlässigbar — in der Größenordnung eines Millimeters, ohne klinisch bedeutsamen Unterschied zu gänzlich unbehandelten Kindern; eine Übersicht von 2024 konstatiert widersprüchliche Studienergebnisse. Ein wissenschaftlicher Kern steckt im Satz des Arztes, aber auf einen spürbaren „Weitet-sich-von-selbst“-Effekt zu setzen, erlaubt die evidenzbasierte Kieferorthopädie nicht.',
			TmdSci4:
				'Welcher Plan für ein konkretes Kind nötig ist, maßen wir uns nicht an zu beurteilen — das ist Sache einer Untersuchung vor Ort. Das Problem liegt woanders: Die beiden Aussagen der Klinik sind unvereinbar. Hatte der Arzt recht und die Unterkieferplatte ist unnötig, hat sie in einem Plan für 800 € nichts verloren. Ist sie nötig — dann war die mündliche Schätzung „um die 2.000 €“ von vornherein unvollständig. Zwischen diesen beiden Versionen liegen wenige Tage — und eine geleistete Anzahlung.',
			TmdFlag1T: '1. Der Preis änderte sich nach der Zahlung.',
			TmdFlag1X:
				'In der Beratung — „um die 2.000 €“, in der Korrespondenz nach der Zahlung — 4.000 € „mit Rabatt“ auf einen „regulären Preis“ von 5.100–5.600 €. So sollte es sein: Die Gesamtkosten der Behandlung und der Preis jeder Etappe werden vor der ersten Zahlung schriftlich festgehalten.',
			TmdFlag2T: '2. Die Behandlung wurde gegen eine teurere getauscht.',
			TmdFlag2X:
				'Aus Alignern wurde eine feste Zahnspange, die „unnötige“ Unterkieferplatte wurde Teil des Plans. So sollte es sein: Eine Planänderung bedeutet eine neue Beratung und eine neue Einwilligung des Patienten, nicht eine Zeile in einer Nachricht.',
			TmdFlag3T: '3. Kein Vertrag, kein schriftlicher Plan.',
			TmdFlag3X:
				'Mündliche Absprachen erzählt im Streitfall jede Seite auf ihre Weise nach — überprüfen lässt sich nichts. So sollte es sein: Ein schriftlicher Plan mit Diagnose, Etappen, Fristen und Preisen wird vor Behandlungsbeginn ausgehändigt.',
			TmdFlag4T: '4. Der Beleg deckt nicht die volle Summe.',
			TmdFlag4X:
				'Von den 1.000 € sind nur die 800 € per Karte dokumentiert. So sollte es sein: Ein Kassenbeleg für jede Zahlung — auch bar — ist die gesetzliche Pflicht der Klinik, kein Entgegenkommen.',
			TmdFlag5T: '5. Keine Erstattung für eine nicht erbrachte Leistung.',
			TmdFlag5X:
				'Tatsächlich wurden nur Abdrücke genommen, doch die Klinik verweigert die Rückzahlung der Differenz. So sollte es sein: Hat die Behandlung nicht begonnen, darf der Patient zurücktreten; einbehalten werden darf der Wert der tatsächlich erbrachten Arbeiten — und der muss begründet werden.',
			TmdRev1:
				'Wir haben die öffentlichen Bewertungen der Klinik auf Google Maps ausgewertet. Das Profil Temel Dental policlinic (Donja Gorica, Bulevar 21 Maj, Podgorica) hat 4,1 bei 69 Bewertungen; das zweite Profil derselben Klinik — 4,2 bei 84. Die Verteilung ist polarisiert: 51 Fünf-Sterne-Bewertungen, 14 mit einem Stern, dazwischen fast nichts. Ein solches Profil ist ein Grund, gerade die negativen Bewertungen zu lesen: In ihnen wiederholen sich dieselben Muster.',
			TmdRevPriceT: 'Höherer Preis als angekündigt.',
			TmdRevPriceX:
				'Der Autor einer türkischsprachigen Ein-Stern-Bewertung (etwa zwei Monate alt) schreibt: Vor einer Zahnextraktion wurden bei der Untersuchung 80 € genannt, „bei einer Operation — 150 €“; es gab keine Operation, der Zahn war in einer Minute draußen, berechnet wurden trotzdem 150 €. Eine Rechnung gab es auf Nachfrage nicht, man versprach, „ein Foto zu schicken“. Das Geschehene nennt der Autor „resmen dolandırıcılık“ — „glatter Betrug“; wir betonen: Das sind die Worte des Bewerters, nicht unsere. Eine russischsprachige Zwei-Sterne-Bewertung (ein Jahr alt): „JEDER TERMIN BEIM KIEFERORTHOPÄDEN KOSTET 100 Euro“ — bei der Terminvergabe hieß es 15 €, im Stuhl wurden es 100 €, obwohl nur eine Feder einzusetzen und ein Gummizug zu wechseln war.',
			TmdRevUpsellT: 'Aufdrängen von Leistungen.',
			TmdRevUpsellX:
				'Eine englischsprachige Ein-Stern-Bewertung (Übersetzung): „Es wird jedes Mal schlimmer… Ich kam mit meiner Mutter, um einen Zahn ziehen zu lassen — sofort begann man, ihr Zusatzleistungen anzubieten… Berechnet wurde der Höchstpreis, obwohl der Eingriff nicht chirurgisch war.“',
			TmdRevQualityT: 'Beschwerden über die Qualität.',
			TmdRevQualityX:
				'Der Autor einer weiteren englischsprachigen Bewertung („High prices and low quality“) behauptet, der leitende Zahnarzt Ibrahim Temel habe einen gesunden Zahn beschliffen, danach sei eine Krone nötig geworden. Ein anderer schreibt: Drei Monate nach einem Kronenwechsel begann darunter eine Entzündung, der Arzt weigerte sich, sie zu ersetzen; nach einer Weisheitszahnextraktion blieb ein Splitter im Zahnfleisch.',
			TmdRevOrgT: 'Organisation der Termine.',
			TmdRevOrgX:
				'In einer russischsprachigen Bewertung (ein Jahr alt) empfing statt des erkrankten Arztes „irgendein Typ im Pullover, ohne Kittel“ den Patienten, assistiert von der Administratorin vom Empfang. In einer anderen: Termin um 9:00, der Arzt war um 9:20 noch nicht da; in ihrer öffentlichen Antwort verwies die Klinik auf „Geräteprobleme“, was der Autor als unwahr bezeichnet.',
			TmdRevTg:
				'Noch eine Beobachtung: In einem russischsprachigen Telegram-Chat über Medizin in Montenegro schaltet die Klinik seit 2023 regelmäßig Werbung — Dutzende Beiträge. Lebendige Diskussionen oder Empfehlungen von Patienten gibt es dort nicht: Die Sichtbarkeit der Marke in der russischsprachigen Community hat die Klinik selbst geschaffen.',
			TmdPos1:
				'Die Klinik hält ihr Vorgehen für rechtmäßig. Ihre Argumente aus der Korrespondenz: Es wurden Abdrücke genommen, die Patientin hat gezahlt, eine Rechnung wurde ausgestellt; alles geschah „gemäß der gültigen Preisliste“ und „im Rahmen des Gesetzes“. Den von den Eltern genannten Preis von 200 € für die Platte weist die Klinik zurück: „In Montenegro kostet keine kieferorthopädische Behandlung 200 Euro.“',
			TmdPos2a: 'Die veröffentlichten Preislisten sagen etwas anderes: Eine ',
			TmdPos2Link: 'herausnehmbare kieferorthopädische Dehnplatte',
			TmdPos2End:
				' kostet in Kliniken des Landes zwischen 180 und 300 €, darunter 201,69 € im Klinischen Zentrum Montenegros.',
			TmdPos3:
				'Das Paket für 4.000 € präsentiert die Klinik als Rabatt auf einen regulären Preis von 5.100–5.600 €. Schließlich bot die Klinik ein persönliches Treffen an: am Montag zu kommen und die Situation mit den Ärzten im Beisein eines Dolmetschers zu besprechen. Schickt uns die Klinik eine substanzielle Stellungnahme, ergänzen wir den Artikel.',
			TmdLawPriceT: 'Das Recht, den Preis vorab zu kennen.',
			TmdLawPriceX:
				'Das Verbraucherschutzgesetz (Zakon o zaštiti potrošača; das Parlament verabschiedete im Februar 2026 seine Neufassung) verankert das Recht der Verbraucher auf klare Preisinformationen vor dem Kauf. Eine mündliche Schätzung „um die 2.000 €“, die sich nach der Zahlung in 4.000 € verwandelt, verträgt sich schlecht mit diesem Prinzip — doch mündliche Absprachen sind schwer zu beweisen, genau deshalb ist der schriftliche Plan so wichtig.',
			TmdLawFiscalT: 'Ein Kassenbeleg für jede Zahlung.',
			TmdLawFiscalX:
				'Das Fiskalisierungsgesetz (Zakon o fiskalizaciji u prometu proizvoda i usluga, „Sl. list CG“ 46/2019 und 73/2019) verpflichtet dazu, jede Zahlung, auch bar, über das Fiskalsystem mit Belegausgabe abzuwickeln. Juristischen Personen drohen bei Verstößen Geldstrafen bis 40.000 €.',
			TmdLawConsentT: 'Einwilligung in die Behandlung.',
			TmdLawConsentX:
				'Das Patientenrechtegesetz (Zakon o pravima pacijenata, „Sl. list CG“ 40/2010 und 40/2011) garantiert das Recht auf Information über die vorgeschlagene Behandlung und auf Einwilligung; Patientenbeschwerden behandelt der Patientenrechtsbeauftragte (zaštitnik prava pacijenata). Laut Fachpresse wurden Patientenrechtsvertreter auch in Zahnarztpraxen eingeführt.',
			TmdLawWhereT: 'Wo man sich beschwert.',
			TmdLawWhereX:
				'Die Marktinspektion der Verwaltung für Inspektionsangelegenheiten (Uprava za inspekcijske poslove) — bei Verletzungen von Verbraucherrechten und fehlendem Beleg. Die Zahnärztekammer Montenegros (Stomatološka komora Crne Gore, aktiv seit 2016) — beim Handeln von Ärzten. Die Verbraucherorganisation CEZAP (Centar za zaštitu potrošača, cezap.me) berät bei Streitigkeiten. Beginnen sollte man in jedem Fall mit einer schriftlichen Eingabe samt Unterlagen.',
			TmdCheck0:
				'Einen Arzt um Vertrag und Kostenaufstellung zu bitten, fühlt sich unangenehm an — man möchte dem Arzt vertrauen, und auf diesem Vertrauen beruht alles. Doch ein schriftlicher Plan ist weltweit gängige Praxis, und eine seriöse Klinik nimmt eine solche Bitte nicht übel. Das sollten Sie vor der ersten Zahlung tun:',
			TmdCheck1:
				'Verlangen Sie einen schriftlichen Behandlungsplan: Diagnose, Etappen, Fristen, Preis jeder Etappe und Gesamtsumme. Kein Plan — keine Zahlung.',
			TmdCheck2:
				'Schließen Sie einen Vertrag mit der Klinik — auf Papier, mit Firmendaten.',
			TmdCheck3:
				'Nehmen Sie für jede Zahlung einen Kassenbeleg, auch bar. „Wir schicken ein Foto der Rechnung“ ist kein Beleg.',
			TmdCheck4:
				'Holen Sie eine Zweitmeinung ein: Eine Beratung bei einem anderen Kieferorthopäden kostet Dutzende Euro und schützt vor unnötigen Ausgaben in Tausenderhöhe.',
			TmdCheck5:
				'Zahlen Sie nicht im Voraus für Etappen, die erst in einem halben Jahr beginnen — zahlen Sie eine Etappe, wenn sie beginnt.',
			TmdCheck6:
				'Vergleichen Sie Preise: Auf docta.me sind die Preislisten montenegrinischer Kliniken veröffentlicht. Ein Unterschied um ein Mehrfaches ist ein Grund, Fragen vor der Zahlung zu stellen, nicht danach.',
			TmdPaid0:
				'Wenn Sie in dieser Geschichte Ihre eigene wiedererkannt haben, zuerst das Wichtigste: Sie tragen keine Schuld. Einem Arzt zu vertrauen ist normal — so soll es sein; dieses Vertrauen auszunutzen ist die Entscheidung der Klinik, nicht Ihr Fehler. Das können Sie tun — ruhig, Schritt für Schritt:',
			TmdPaid1:
				'Schicken Sie der Klinik eine schriftliche Reklamation (E-Mail genügt): was gezahlt wurde, was tatsächlich erbracht wurde, die Forderung nach Rückzahlung der Differenz und eine Antwortfrist.',
			TmdPaid2:
				'Sammeln Sie Beweise: Korrespondenz, Belege, Kartenauszug, Fotos der Preisliste in der Klinik.',
			TmdPaid3:
				'Beschweren Sie sich bei der Marktinspektion (Uprava za inspekcijske poslove) — besonders wenn kein Beleg ausgestellt wurde oder der Preis von der Preisliste abweicht.',
			TmdPaid4:
				'Für die medizinische Seite des Streits — ein ohne Ihre Einwilligung geänderter Behandlungsplan — wenden Sie sich an den Patientenrechtsbeauftragten und die Zahnärztekammer.',
			TmdPaid5:
				'Haben Sie mit Karte gezahlt, fragen Sie Ihre Bank nach dem Chargeback-Verfahren: Für Kartenzahlungen existiert es; Sie brauchen eine Schilderung der Situation und die Korrespondenz mit der Klinik. Die Prüfung dauert in der Regel ein bis drei Monate — haben Sie Geduld, das sind normale Fristen.',
			TmdPaid6: 'Rat bekommen Sie auch bei CEZAP.',
			TmdDocta1:
				'Dieser Fall handelt nicht nur von einer Klinik. Er handelt von einer Praxis, bei der der Endpreis nachträglich genannt wird und der Patient kein einziges Dokument zum Widersprechen hat. docta.me führt eine „Vorsicht“-Markierung für Kliniken mit dokumentierten Beschwerden ein sowie eine Rubrik „Klinik-Reputation“, in der solche Beschwerden standardisiert gesammelt werden. Die Bewertung der Heldin dieses Artikels ist als verifiziert veröffentlicht: Der Autor hat alle Dokumente dieses Falls persönlich gesehen (siehe die Offenlegung des Interessenkonflikts am Anfang).',
			TmdDocta2:
				'Wenn Sie Ähnliches erlebt haben — in dieser oder einer anderen Klinik — schreiben Sie uns und legen Sie Dokumente bei. Je mehr dokumentierte Geschichten es gibt, desto schwerer kann diese Praxis die Norm bleiben.',
			TmdSrcIntro:
				'Die Korrespondenz der Patientin mit der Klinik und die Zahlungsbelege liegen der Redaktion vor. Öffentliche Bewertungen — die Google-Maps-Profile von Temel Dental policlinic (Podgorica). Juristische und wissenschaftliche Quellen:',
			TmdSrcSci2017:
				'Systematische Übersichtsarbeit (2017): spontane dentoalveoläre Veränderungen des Unterkiefers nach Oberkieferdehnung',
			TmdSrcSci2024:
				'Systematische Übersichtsarbeit (2024, Children): Veränderungen des unteren Zahnbogens nach RME, SME und Leaf Expander',
			TmdSrcZzp:
				'Zakon o zaštiti potrošača — das neue Verbraucherschutzgesetz (Službeni list CG, Februar 2026)',
			TmdSrcFisk:
				'Zakon o fiskalizaciji — Kassenbelege und Geldstrafen (paragraf.me)',
			TmdSrcPrava:
				'Zakon o pravima pacijenata — Patientenrechte und der Beauftragte (paragraf.me)',
			TmdSrcCezap: 'CEZAP — Verbraucherschutzzentrum Montenegros',
			TmdCtaTitle: 'Preise vor der Zahlung prüfen',
			TmdCtaText:
				'Auf docta.me sind die Preislisten montenegrinischer Kliniken veröffentlicht — sehen Sie nach, was eine Leistung anderswo kostet.',
			TmdCtaButton: 'Preise vergleichen',
		},
		'tr': {
			TmdTitle:
				"Podgorica'daki Temel Dental: sözlü 2.000 €, ödeme sonrası 4.000 €",
			TmdDescription:
				"Podgorica'daki Temel Dental diş kliniğinde belgelenmiş bir vaka: aile, “yaklaşık 2.000 €” denilen tedavi için 1.000 € ödedi; birkaç gün sonra planın 4.000 € olduğunu ve başka işlemlerden oluştuğunu öğrendi. Klinik para iadesini reddediyor. Yazışmalar, yorumlar, Karadağ yasaları ve hasta rehberi.",
			TmdToc_case: 'Kronoloji: rutin muayeneden “paket fiyata”',
			TmdToc_science: 'Alt çene “kendi kendine genişler” mi?',
			TmdToc_flags: 'Beş kırmızı bayrak',
			TmdToc_reviews: 'Temel Dental yorumları: tek vaka değil',
			TmdToc_position: 'Temel Dental kliniğinin tutumu',
			TmdToc_law: 'Karadağ yasaları ne diyor',
			TmdToc_checklist: 'Rehber: ortodontiste ödeme yapmadan önce',
			TmdToc_paid: 'Zaten ödediyseniz',
			TmdToc_docta: 'docta.me ne yapacak',
			TmdToc_sources: 'Kaynaklar',
			TmdLead1a: "Ekim 2026'da bir anne, 11 yaşındaki kızını Podgorica'daki ",
			TmdLead1Link: 'Temel Dental',
			TmdLead1End:
				' kliniğine rutin muayeneye götürdü. Sadece birkaç gün sonra aile, hakkında nadiren yazılan ama özel sohbetlerde sık anlatılan bir durumla karşılaştı: konsültasyonda sözlü olarak “yaklaşık 2.000 €” tutarında bir tedavi konuşuldu, 1.000 € ödendi — ve ancak ödemeden sonra aile, yazışmalardan planın tamamının 4.000 € olduğunu ve doktorla konuşulandan farklı işlemlerden oluştuğunu öğrendi. Klinik parayı iade etmeyi reddediyor.',
			TmdLead2:
				"Önce en önemlisi: bu, docta.me'nin arkasındaki kişinin ailesinin başına geldi — kızını konsültasyona eşi götürdü. Siteyi tek kişi yürütüyor; bu metindeki “editör ekibi” de odur. Bu çıkar çatışmasını saklamadan açıkça bildiriyoruz. Hikâyeye yakınlığın doğruluğa çalışan bir yüzü de var: yazışmalar, ödeme belgeleri ve olayların kendisi yazar tarafından birinci elden biliniyor, aktarma değil. Vakayı adım adım inceledik, kliniğin herkese açık yorumlarıyla ve Karadağ yasalarıyla karşılaştırdık — benzer bir duruma düşmemeniz için bir rehber hazırladık. Kliniğin tutumu, yazışmalardaki yanıtlarına dayanarak metinde yer alıyor.",
			TmdCase1:
				"Temel Dental'deki diş hekimi rutin muayenede çocuğu aynı kliniğin ortodontistine yönlendirdi — kendi başına makul bir adım. Konsültasyonda ortodontist planı sözlü olarak anlattı: üst çene için yaklaşık altı ay genişletme apareyi, ardından şeffaf plaklar (aligner). Toplam maliyeti “yaklaşık 2.000 €” olarak verdi: 1.000 € peşin, altı ay sonra başlamak üzere aligner için ayda 100–200 €. Alt çenenin ise doktora göre genişletilmesine gerek yoktu: o “kendi kendine genişliyor”du.",
			TmdCase2:
				'Aile 1.000 € ödedi: 800 € kartla, 200 € nakit. Nakit kısım için fiş verilmedi. Yazılı sözleşme yapılmadı; aile, aşamaları ve fiyatları gösteren yazılı bir tedavi planı da almadı — tüm anlaşmalar sözlü kaldı.',
			TmdCase3a:
				"Ödemeden sadece birkaç gün sonra ebeveynler fiyatları karşılaştırdı ve benzer genişletme apareylerinin Karadağ'daki diğer kliniklerde yaklaşık 200 € olduğunu, Temel Dental'de ise bu kalemin 800 € tuttuğunu gördü. Bunu docta.me kataloğu da doğruluyor: “",
			TmdCase3Link: 'hareketli ortodontik plak apareyi',
			TmdCase3End:
				'” hizmeti 24 kliniğin fiyat listesinde yer alıyor; açık fiyatlar 180–300 € arasında — devlete ait ',
			TmdCase3KccgLink: 'Karadağ Klinik Merkezi',
			TmdCase3Tail:
				"'nde 201,69 €. Aile kliniğe yazarak apareyin marka veya modelini ve 1.000 €'nun neyi kapsadığını sordu.",
			TmdCase4:
				"Yazışmalardan görülen yanıt: “Belirli bir marka yok, bu diş hekimliğinde her gün teknisyenlerce yapılır.” Ardından klinik, “tedavi planı” içeren uzun bir mesaj gönderdi. Plana göre: her iki çene için plaklar (her biri 800 €) artı 3.500–4.000 € tutarında braket; paketin “normal fiyatı” 5.100–5.600 €, ama “doktor 4.000 €'luk özel paket fiyatı önerdi”.",
			TmdCase5:
				"Bu, konsültasyondan iki noktada ayrılıyordu. Konuşulan aligner'ların yerini braketler aldı. İkinci plak — alt çene için — doktorun konsültasyonda gereksiz dediği plağın ta kendisiydi. 4.000 € rakamı ilk kez, aile 1.000 € ödedikten sonra telaffuz edildi.",
			TmdCase6:
				'Hasta ilişkiyi sonlandırmayı ve ödemenin iadesini istedi: hizmet esasen verilmedi — yalnızca ölçü alındı, sözleşme yok, aşamalar yazılı değil, fiş tutarın tamamına kesilmedi. Klinik parayı iade etmeyi reddetti. Yanıtlarından alıntılar:',
			TmdQuote1: "“Karadağ'da hiçbir ortodontik tedavi 200 euro değildir.”",
			TmdQuote2:
				'“Tedavinin bedeli çok daha yüksek, ama size yardımcı olduk ve indirim yaptık.”',
			TmdQuote3:
				'“Size hiçbir karmaşık tıbbi işlem uygulanmadı. Her şey geçerli fiyat listemize uygun yapıldı. Ölçünüz alındı, ödeme yaptınız ve size fatura kesildi.”',
			TmdQuote4: '“Tüm işlemlerimiz yasalar çerçevesindedir.”',
			TmdCase7:
				"Klinik, tedaviyi yürüten doktorun iletişim bilgisini vermeyi reddetti ve pazartesi gelip her şeyi tercüman eşliğinde doktorlarla konuşmayı önerdi (yazışmalarda bir “Doktor Alex” geçiyor). Ardından hastayla kliniğin Türkiye'deki merkez ofisinin direktörü iletişime geçti — kendisinden bu istenmişti. Hasta tüm durumu ona madde madde yeniden anlattı. Yanıt gelmedi; klinik parayı iade etmeyi hâlâ reddediyor. Bu arada aile, bankasına ters ibraz (chargeback) başvurusu yaptı — banka başvuruyu kabul etti ve inceliyor.",
			TmdSci1:
				"Doktorun alt çeneyle ilgili sözü bu hikâyede kilit rol oynadı — sonradan 800 €'luk fiyatla planda beliren, işte o “gereksiz” plaktı — bu yüzden ayrıca ele alıyoruz.",
			TmdSci2:
				'Ortodonti açısından çeneden değil diş kavsinden söz etmek daha doğru. Çocukta üst çene gerçekten iskeletsel olarak genişletilebilir: büyüme tamamlanana dek orta damak süturu esnektir; genişletme plakları ve apareyleri buna dayanır. Alt çenede böyle bir sütur yoktur; bu yüzden onu aparey ile iskeletsel anlamda genişletmek mümkün değildir — alt diş kavsine takılan plak dişleri yalnızca dışa doğru eğer.',
			TmdSci3:
				'Üst çene genişletildikten sonra alt diş kavsindeki “kendiliğinden” değişimler bilimsel literatürde gerçekten tanımlanmış: alt dişler hafifçe dikleşebilir, kavis biraz genişleyebilir. Ama 2017 tarihli sistematik derleme bu kendiliğinden değişimleri ihmal edilebilir buluyor — milimetre düzeyinde, hiç tedavi görmeyen çocuklardan klinik olarak anlamlı farkı yok; 2024 derlemesi ise araştırma sonuçlarının çelişkili olduğunu söylüyor. Doktorun sözünde bilimsel bir çekirdek var, ama kanıta dayalı ortodonti “kendi kendine genişler” diye gözle görülür bir etkiye bel bağlamaya izin vermiyor.',
			TmdSci4:
				"Belirli bir çocuğa hangi planın gerektiği konusunda hüküm vermiyoruz — bu, yüz yüze muayenenin işidir. Sorun başka yerde: kliniğin iki ifadesi bağdaşmıyor. Doktor haklıysa ve alt çene plağı gereksizse, 800 €'luk kalemin planda yeri yok. Gerekliyse — “yaklaşık 2.000 €” sözlü tahmini baştan eksikti. Bu iki sürüm arasında yalnızca birkaç gün ve yatırılmış bir ön ödeme var.",
			TmdFlag1T: '1. Fiyat ödemeden sonra değişti.',
			TmdFlag1X:
				"Konsültasyonda — “yaklaşık 2.000 €”; ödemeden sonra yazışmada — 5.100–5.600 €'luk “normal fiyattan” “indirimli” 4.000 €. Olması gereken: tedavinin tam bedeli ve her aşamanın fiyatı ilk ödemeden önce yazılı olarak sabitlenir.",
			TmdFlag2T: '2. Tedavi içeriği daha pahalısıyla değiştirildi.',
			TmdFlag2X:
				"Aligner'lar brakete dönüştü, “gereksiz” alt çene plağı planın parçası oldu. Olması gereken: plan değişikliği, mesajdaki bir satır değil, yeni bir konsültasyon ve hastanın yeni onayı demektir.",
			TmdFlag3T: '3. Sözleşme ve yazılı plan yok.',
			TmdFlag3X:
				'Sözlü anlaşmaları bir anlaşmazlıkta her taraf kendine göre anlatır — doğrulamak imkânsızdır. Olması gereken: tanı, aşamalar, süreler ve fiyatları içeren yazılı plan tedaviye başlamadan verilir.',
			TmdFlag4T: '4. Fiş tutarın tamamına kesilmedi.',
			TmdFlag4X:
				"1.000 €'nun yalnızca kartla ödenen 800 €'su belgeyle doğrulanıyor. Olması gereken: nakit dâhil her ödeme için fiş, kliniğin yasal yükümlülüğüdür, bir iyilik değil.",
			TmdFlag5T: '5. Verilmeyen hizmetin iadesi yapılmadı.',
			TmdFlag5X:
				'Fiilen yalnızca ölçü alındı, ama klinik farkı iade etmeyi reddetti. Olması gereken: tedavi başlamadıysa hasta vazgeçebilir; yalnızca fiilen yapılan işin bedeli alıkonabilir — ve gerekçelendirilmelidir.',
			TmdRev1:
				"Kliniğin Google Haritalar'daki herkese açık yorumlarını inceledik. Temel Dental policlinic profili (Donja Gorica, Bulevar 21 Maj, Podgorica) 69 yorumla 4,1 puana sahip; aynı kliniğin ikinci profili 84 yorumla 4,2. Dağılım kutuplaşmış: 51 yorum beş yıldız, 14 yorum tek yıldız, ortası neredeyse yok. Böyle bir puan profili, özellikle olumsuz yorumları okumak için bir neden: aynı senaryolar tekrarlanıyor.",
			TmdRevPriceT: 'Söylenenden yüksek fiyat.',
			TmdRevPriceX:
				'Türkçe tek yıldızlı bir yorumun (yaklaşık iki ay önce) yazarı şöyle diyor: diş çekiminden önce muayenede 80 € denildi, “ameliyat olursa 150 €”; ameliyat olmadı, diş bir dakikada çekildi ama yine de 150 € alındı. İstenmesine rağmen fatura verilmedi, “fotoğrafını göndeririz” denildi. Yazar olanları “resmen dolandırıcılık” olarak nitelendiriyor; bunların yorum yazarının sözleri olduğunu, bizim değerlendirmemiz olmadığını vurgulayalım. Rusça iki yıldızlı bir yorum (bir yıl önce): “ORTODONTİSTE HER RANDEVU 100 euro” — randevuda 15 € denilmiş, koltukta 100 € çıkmış; oysa yalnızca yay takılıp lastik değiştirilecekti.',
			TmdRevUpsellT: 'Hizmet dayatma.',
			TmdRevUpsellX:
				'İngilizce tek yıldızlı bir yorum (çeviri): “Her seferinde daha kötü… Annemle diş çektirmeye geldim — ona hemen ek hizmetler önermeye başladılar… İşlem cerrahi olmadığı hâlde en yüksek fiyatı aldılar.”',
			TmdRevQualityT: 'Kalite şikâyetleri.',
			TmdRevQualityX:
				"Bir başka İngilizce yorumun (“High prices and low quality”) yazarı, başhekim Ibrahim Temel'in sağlam bir dişi kestiğini, sonrasında kuron gerektiğini iddia ediyor. Bir diğeri: kuron değişiminden üç ay sonra altında iltihap başlamış, doktor değiştirmeyi reddetmiş; yirmilik diş çekiminde diş etinde parça kalmış.",
			TmdRevOrgT: 'Randevu düzeni.',
			TmdRevOrgX:
				"Rusça bir yorumda (bir yıl önce) hastalanan doktorun yerine hastayı “önlüksüz, kazaklı bir adam” muayene etmiş; resepsiyondaki görevli asistanlık yapmış. Bir başkasında randevu 9.00'daymış, doktor 9.20'de hâlâ ortada yokmuş; klinik herkese açık yanıtında “ekipman arızasına” atıfta bulunmuş — yazar bunun doğru olmadığını söylüyor.",
			TmdRevTg:
				"Bir gözlem daha: Karadağ'daki sağlık konulu Rusça Telegram sohbetinde klinik 2023'ten beri düzenli reklam veriyor — onlarca gönderi. Orada hastalardan canlı tartışma ya da tavsiye yok: markanın Rusça konuşan topluluktaki görünürlüğünü kliniğin kendisi yaratmış.",
			TmdPos1:
				"Klinik, yaptıklarının yasal olduğu görüşünde. Yazışmalardaki savları: hastanın ölçüsü alındı, ödeme yapıldı, fatura kesildi; her şey “geçerli fiyat listesine uygun” ve “yasalar çerçevesinde” yapıldı. Ailenin plak için söylediği 200 €'yu klinik reddediyor: “Karadağ'da hiçbir ortodontik tedavi 200 euro değildir.”",
			TmdPos2a: 'Yayımlanmış fiyat listeleri aksini söylüyor: ',
			TmdPos2Link: 'hareketli ortodontik plak apareyi',
			TmdPos2End:
				" ülke genelindeki kliniklerde 180–300 € arası — Karadağ Klinik Merkezi'nde 201,69 €.",
			TmdPos3:
				"4.000 €'luk paketi klinik, 5.100–5.600 €'luk normal fiyattan indirim olarak sunuyor. Son olarak klinik yüz yüze görüşme önerdi: pazartesi gelip durumu tercüman eşliğinde doktorlarla konuşmak. Klinik bize kapsamlı bir yanıt gönderirse metni güncelleyeceğiz.",
			TmdLawPriceT: 'Fiyatı önceden bilme hakkı.',
			TmdLawPriceX:
				"Tüketici Koruma Kanunu (Zakon o zaštiti potrošača; parlamento yeni metnini Şubat 2026'da kabul etti), tüketicinin satın almadan önce mal veya hizmetin fiyatı hakkında açık bilgi alma hakkını güvence altına alıyor. Ödemeden sonra 4.000 €'ya dönüşen “yaklaşık 2.000 €” sözlü tahmini bu ilkeyle zor bağdaşır — ama sözlü anlaşmaları kanıtlamak güçtür; yazılı planın önemi de buradadır.",
			TmdLawFiscalT: 'Her ödemeye fiş.',
			TmdLawFiscalX:
				"Fişleştirme Kanunu (Zakon o fiskalizaciji u prometu proizvoda i usluga, “Sl. list CG” 46/2019 ve 73/2019), nakit dâhil her ödemenin fiş kesilerek mali sistemden geçirilmesini zorunlu kılıyor. Tüzel kişilere ihlaller için 40.000 €'ya kadar ceza öngörülüyor.",
			TmdLawConsentT: 'Tedaviye onay.',
			TmdLawConsentX:
				'Hasta Hakları Kanunu (Zakon o pravima pacijenata, “Sl. list CG” 40/2010 ve 40/2011) önerilen tedavi hakkında bilgi alma ve ona onay verme hakkını güvence altına alıyor; hasta şikâyetlerine hasta hakları koruyucusu (zaštitnik prava pacijenata) bakıyor. Sektör basınına göre hasta hakları temsilcileri diş kliniklerinde de uygulamaya konuluyordu.',
			TmdLawWhereT: 'Nereye şikâyet edilir.',
			TmdLawWhereX:
				"Tüketici hakları ihlalleri ve fiş kesilmemesi için — Denetim İşleri İdaresi (Uprava za inspekcijske poslove) bünyesindeki piyasa denetimi. Hekimlerin eylemleri için — Karadağ Diş Hekimleri Odası (Stomatološka komora Crne Gore, 2016'dan beri faal). Tüketici örgütü CEZAP (Centar za zaštitu potrošača, cezap.me) anlaşmazlıklarda danışmanlık veriyor. Her durumda, belgeleri ekleyerek yazılı başvuruyla başlamak gerekir.",
			TmdCheck0:
				'Bir doktordan sözleşme ve fiyat dökümü istemek insana tuhaf gelir — doktora güvenmek isteriz, her şey de bu güvene dayanır. Ama yazılı plan dünyada olağan uygulamadır ve dürüst bir klinik bu ricaya gücenmez. İlk ödemeden önce yapılması gerekenler:',
			TmdCheck1:
				'Yazılı tedavi planı isteyin: tanı, aşamalar, süreler, her aşamanın fiyatı ve toplam. Plan yoksa ödeme yok.',
			TmdCheck2:
				'Klinikle sözleşme yapın — kâğıt üzerinde, şirket bilgileriyle.',
			TmdCheck3:
				'Nakit dâhil her ödeme için fiş alın. “Faturanın fotoğrafını göndeririz” fiş değildir.',
			TmdCheck4:
				'İkinci görüş alın: başka bir ortodontistin konsültasyonu onlarca euro tutar ve binlerce euroluk gereksiz masraftan korur.',
			TmdCheck5:
				'Altı ay sonra başlayacak aşamaları peşin ödemeyin — aşamayı başladığında ödeyin.',
			TmdCheck6:
				"Fiyatları karşılaştırın: Karadağ kliniklerinin fiyat listeleri docta.me'de yayımlanıyor. Kat kat fark, soruları ödemeden önce sormak için bir nedendir, sonra değil.",
			TmdPaid0:
				'Bu hikâyede kendi hikâyenizi tanıdıysanız, önce en önemlisi: suçlu değilsiniz. Doktora güvenmek normaldir — öyle de olmalı; bu güveni kullanmak kliniğin seçimidir, sizin hatanız değil. Yapabilecekleriniz — sakin sakin, adım adım:',
			TmdPaid1:
				'Kliniğe yazılı şikâyet gönderin (e-posta da olur): ne ödendi, fiilen ne verildi, farkın iadesi talebi ve yanıt süresi.',
			TmdPaid2:
				'Kanıt toplayın: yazışmalar, fişler, kart ekstresi, klinikteki fiyat listesinin fotoğrafları.',
			TmdPaid3:
				'Piyasa denetimine (Uprava za inspekcijske poslove) şikâyet edin — özellikle fiş kesilmediyse veya fiyat listeden saptıysa.',
			TmdPaid4:
				'Anlaşmazlığın tıbbi tarafı için — onayınız olmadan değiştirilen tedavi planı — hasta hakları koruyucusuna ve Diş Hekimleri Odasına başvurun.',
			TmdPaid5:
				'Kartla ödediyseniz bankanıza ters ibraz (chargeback) prosedürünü sorun: kart ödemeleri için mevcuttur; durumun açıklaması ve klinikle yazışmalar gerekir. İnceleme genellikle bir ila üç ay sürer — sabırlı olun, bu normal bir süredir.',
			TmdPaid6: "Danışmanlık için CEZAP'a başvurabilirsiniz.",
			TmdDocta1:
				'Bu vaka yalnızca bir klinikle ilgili değil. Nihai fiyatın sonradan söylendiği ve hastanın elinde itiraz edecek tek bir belgenin olmadığı bir pratikle ilgili. docta.me, belgelenmiş şikâyetleri olan klinikler için “dikkat” işareti ve bu tür şikâyetlerin standart biçimde toplanacağı “klinik itibarı” bölümünü başlatıyor. Bu yazının kahramanının yorumu doğrulanmış olarak yayımlandı: yazar bu vakadaki tüm belgeleri bizzat gördü (baştaki çıkar çatışması açıklamasına bakın).',
			TmdDocta2:
				'Benzer bir uygulamayla karşılaştıysanız — bu klinikte ya da başkasında — bize yazın ve belgeleri ekleyin. Belgelenmiş hikâyeler çoğaldıkça bu pratiğin norm olarak kalması zorlaşır.',
			TmdSrcIntro:
				"Hastanın klinikle yazışmaları ve ödeme belgeleri editörün elindedir. Herkese açık yorumlar — Temel Dental policlinic'in Google Haritalar profilleri (Podgorica). Hukuki ve bilimsel kaynaklar:",
			TmdSrcSci2017:
				'Sistematik derleme (2017): üst çene genişletmesi sonrası alt kaviste kendiliğinden dentoalveolar değişimler',
			TmdSrcSci2024:
				'Sistematik derleme (2024, Children): RME, SME ve leaf expander sonrası alt kavis değişimleri',
			TmdSrcZzp:
				'Zakon o zaštiti potrošača — yeni Tüketici Koruma Kanunu (Službeni list CG, Şubat 2026)',
			TmdSrcFisk: 'Zakon o fiskalizaciji — fişler ve cezalar (paragraf.me)',
			TmdSrcPrava:
				'Zakon o pravima pacijenata — hasta hakları ve koruyucu (paragraf.me)',
			TmdSrcCezap: 'CEZAP — Karadağ tüketici koruma merkezi',
			TmdCtaTitle: 'Ödemeden önce fiyatları kontrol edin',
			TmdCtaText:
				"docta.me'de Karadağ kliniklerinin fiyat listeleri yayımlanıyor — hizmetin başka yerde ne kadar olduğuna bakın.",
			TmdCtaButton: 'Fiyatları karşılaştır',
		},
	},
};
