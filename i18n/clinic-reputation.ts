// Раздел «Репутация» и бейдж «Осторожно» (prd/clinic-reputation/).
//
// Формулировки жалоб — фиксированный словарь: коды в БД
// (clinic_complaints.complaint_type = enums/clinic-complaint-type.ts),
// тексты только здесь. Правила формулировок: факты без оценочных и
// уголовно-правовых слов, настоящее время, описывают практику, а не намерение.
// Complaint<N> — полная формулировка в разделе, Complaint<N>Short — короткий
// ярлык для тултипа бейджа (перечисление через запятую).
// Чип статуса несёт эпистемику: confirmed — редакция видела документы,
// unconfirmed — только обращения пациентов.
export default {
	messages: {
		'en': {
			ReputationTitle: 'Reputation',
			Caution: 'Caution',
			CautionTooltip: 'Caution: {labels}',
			Complaint1: 'Pushing services the patient did not ask for',
			Complaint1Short: 'imposed services',
			Complaint2: 'Final cost significantly higher than quoted before treatment',
			Complaint2Short: 'final cost above the quote',
			Complaint3: 'No contract or written treatment plan provided',
			Complaint3Short: 'no contract or treatment plan',
			Complaint4: 'Fiscal receipt not issued for the full amount paid',
			Complaint4Short: 'receipt not for the full amount',
			Complaint5: 'Refusal to refund prepayment for services not provided',
			Complaint5Short: 'prepayment not refunded',
			Complaint6: 'Patient complaints about treatment quality',
			Complaint6Short: 'treatment quality',
			ConfirmedByEditors: 'Confirmed by the editorial team',
			ConfirmedByEditorsHint:
				'The docta.me team has reviewed supporting documents: correspondence, payment records or medical reports',
			Unconfirmed: 'Unconfirmed',
			UnconfirmedHint:
				'Based on patient reports; the editorial team has no documentary evidence',
			ClinicResponseTitle: 'Official response from the clinic',
			SeePinnedReview: 'Review about this case',
			SeeArticle: 'Case review article',
			ReputationFooter:
				'This section is maintained by the docta.me team based on patient reports and submitted documents. The clinic can send an official response to {email} — we will publish it here.',
			ReviewsCautionNotice: 'This clinic has confirmed patient complaints.',
			ReviewsCautionLink: 'See the Reputation section',
		},
		'ru': {
			ReputationTitle: 'Репутация',
			Caution: 'Осторожно',
			CautionTooltip: 'Осторожно: {labels}',
			Complaint1: 'Навязывание услуг, о которых пациент не просил',
			Complaint1Short: 'навязанные услуги',
			Complaint2:
				'Итоговая стоимость существенно выше озвученной до начала лечения',
			Complaint2Short: 'итоговая стоимость выше озвученной',
			Complaint3: 'Договор и письменный план лечения не выдаются',
			Complaint3Short: 'нет договора и плана лечения',
			Complaint4: 'Фискальный чек выдаётся не на всю сумму оплаты',
			Complaint4Short: 'чек не на всю сумму',
			Complaint5: 'Отказ вернуть предоплату за неоказанные услуги',
			Complaint5Short: 'невозврат предоплаты',
			Complaint6: 'Жалобы пациентов на качество лечения',
			Complaint6Short: 'качество лечения',
			ConfirmedByEditors: 'Подтверждено редакцией',
			ConfirmedByEditorsHint:
				'Редакция docta.me проверила документы: переписку, платёжные документы или заключения',
			Unconfirmed: 'Не подтверждено',
			UnconfirmedHint:
				'Основано на обращениях пациентов; документального подтверждения у редакции нет',
			ClinicResponseTitle: 'Официальный ответ клиники',
			SeePinnedReview: 'Отзыв по этому случаю',
			SeeArticle: 'Разбор случая',
			ReputationFooter:
				'Раздел ведёт редакция docta.me на основании обращений пациентов и предоставленных документов. Клиника может направить официальный ответ на {email} — мы опубликуем его здесь.',
			ReviewsCautionNotice: 'У клиники есть подтверждённые жалобы пациентов.',
			ReviewsCautionLink: 'Подробнее в разделе «Репутация»',
		},
		'sr': {
			ReputationTitle: 'Reputacija',
			Caution: 'Oprez',
			CautionTooltip: 'Oprez: {labels}',
			Complaint1: 'Nametanje usluga koje pacijent nije tražio',
			Complaint1Short: 'nametnute usluge',
			Complaint2:
				'Konačna cijena znatno viša od najavljene prije početka liječenja',
			Complaint2Short: 'konačna cijena viša od najavljene',
			Complaint3: 'Ugovor i pisani plan liječenja se ne izdaju',
			Complaint3Short: 'nema ugovora ni plana liječenja',
			Complaint4: 'Fiskalni račun se ne izdaje na cijeli iznos uplate',
			Complaint4Short: 'račun nije na cijeli iznos',
			Complaint5: 'Odbijanje povraćaja avansa za nepružene usluge',
			Complaint5Short: 'avans nije vraćen',
			Complaint6: 'Žalbe pacijenata na kvalitet liječenja',
			Complaint6Short: 'kvalitet liječenja',
			ConfirmedByEditors: 'Potvrdila redakcija',
			ConfirmedByEditorsHint:
				'Redakcija docta.me je provjerila dokumente: prepisku, dokaze o plaćanju ili nalaze',
			Unconfirmed: 'Nepotvrđeno',
			UnconfirmedHint:
				'Zasnovano na prijavama pacijenata; redakcija nema dokumentovanu potvrdu',
			ClinicResponseTitle: 'Zvaničan odgovor klinike',
			SeePinnedReview: 'Recenzija o ovom slučaju',
			SeeArticle: 'Analiza slučaja',
			ReputationFooter:
				'Ovu rubriku vodi redakcija docta.me na osnovu prijava pacijenata i dostavljenih dokumenata. Klinika može poslati zvaničan odgovor na {email} — objavićemo ga ovdje.',
			ReviewsCautionNotice: 'Ova klinika ima potvrđene žalbe pacijenata.',
			ReviewsCautionLink: 'Više u rubrici Reputacija',
		},
		'sr-cyrl': {
			ReputationTitle: 'Репутација',
			Caution: 'Опрез',
			CautionTooltip: 'Опрез: {labels}',
			Complaint1: 'Наметање услуга које пацијент није тражио',
			Complaint1Short: 'наметнуте услуге',
			Complaint2:
				'Коначна цијена знатно виша од најављене прије почетка лијечења',
			Complaint2Short: 'коначна цијена виша од најављене',
			Complaint3: 'Уговор и писани план лијечења се не издају',
			Complaint3Short: 'нема уговора ни плана лијечења',
			Complaint4: 'Фискални рачун се не издаје на цијели износ уплате',
			Complaint4Short: 'рачун није на цијели износ',
			Complaint5: 'Одбијање повраћаја аванса за непружене услуге',
			Complaint5Short: 'аванс није враћен',
			Complaint6: 'Жалбе пацијената на квалитет лијечења',
			Complaint6Short: 'квалитет лијечења',
			ConfirmedByEditors: 'Потврдила редакција',
			ConfirmedByEditorsHint:
				'Редакција docta.me је провјерила документе: преписку, доказе о плаћању или налазе',
			Unconfirmed: 'Непотврђено',
			UnconfirmedHint:
				'Засновано на пријавама пацијената; редакција нема документовану потврду',
			ClinicResponseTitle: 'Званичан одговор клинике',
			SeePinnedReview: 'Рецензија о овом случају',
			SeeArticle: 'Анализа случаја',
			ReputationFooter:
				'Ову рубрику води редакција docta.me на основу пријава пацијената и достављених докумената. Клиника може послати званичан одговор на {email} — објавићемо га овдје.',
			ReviewsCautionNotice: 'Ова клиника има потврђене жалбе пацијената.',
			ReviewsCautionLink: 'Више у рубрици Репутација',
		},
		'de': {
			ReputationTitle: 'Reputation',
			Caution: 'Vorsicht',
			CautionTooltip: 'Vorsicht: {labels}',
			Complaint1: 'Aufdrängen von Leistungen, die der Patient nicht angefragt hat',
			Complaint1Short: 'aufgedrängte Leistungen',
			Complaint2: 'Endpreis deutlich höher als vor Behandlungsbeginn genannt',
			Complaint2Short: 'Endpreis über dem genannten',
			Complaint3: 'Kein Vertrag und kein schriftlicher Behandlungsplan',
			Complaint3Short: 'kein Vertrag, kein Behandlungsplan',
			Complaint4: 'Kassenbeleg nicht über den vollen Zahlungsbetrag',
			Complaint4Short: 'Beleg nicht über die volle Summe',
			Complaint5:
				'Verweigerung der Rückerstattung einer Anzahlung für nicht erbrachte Leistungen',
			Complaint5Short: 'Anzahlung nicht erstattet',
			Complaint6: 'Patientenbeschwerden über die Behandlungsqualität',
			Complaint6Short: 'Behandlungsqualität',
			ConfirmedByEditors: 'Von der Redaktion bestätigt',
			ConfirmedByEditorsHint:
				'Die docta.me-Redaktion hat Belege geprüft: Korrespondenz, Zahlungsnachweise oder Befunde',
			Unconfirmed: 'Unbestätigt',
			UnconfirmedHint:
				'Beruht auf Patientenmeldungen; der Redaktion liegen keine Belege vor',
			ClinicResponseTitle: 'Offizielle Stellungnahme der Klinik',
			SeePinnedReview: 'Bewertung zu diesem Fall',
			SeeArticle: 'Analyse des Falls',
			ReputationFooter:
				'Diese Rubrik pflegt die docta.me-Redaktion auf Grundlage von Patientenmeldungen und eingereichten Unterlagen. Die Klinik kann eine offizielle Stellungnahme an {email} senden — wir veröffentlichen sie hier.',
			ReviewsCautionNotice:
				'Für diese Klinik liegen bestätigte Patientenbeschwerden vor.',
			ReviewsCautionLink: 'Mehr im Abschnitt Reputation',
		},
		'tr': {
			ReputationTitle: 'İtibar',
			Caution: 'Dikkat',
			CautionTooltip: 'Dikkat: {labels}',
			Complaint1: 'Hastanın istemediği hizmetlerin dayatılması',
			Complaint1Short: 'dayatılan hizmetler',
			Complaint2:
				'Nihai ücretin tedavi öncesi söylenenden belirgin şekilde yüksek olması',
			Complaint2Short: 'söylenenden yüksek ücret',
			Complaint3: 'Sözleşme ve yazılı tedavi planı verilmemesi',
			Complaint3Short: 'sözleşme ve plan yok',
			Complaint4: 'Ödemenin tamamı için fiş kesilmemesi',
			Complaint4Short: 'fiş tam tutarda değil',
			Complaint5: 'Verilmeyen hizmetler için ön ödemenin iade edilmemesi',
			Complaint5Short: 'ön ödeme iade edilmedi',
			Complaint6: 'Tedavi kalitesine ilişkin hasta şikâyetleri',
			Complaint6Short: 'tedavi kalitesi',
			ConfirmedByEditors: 'Editör ekibi tarafından doğrulandı',
			ConfirmedByEditorsHint:
				'docta.me ekibi belgeleri inceledi: yazışmalar, ödeme belgeleri veya raporlar',
			Unconfirmed: 'Doğrulanmamış',
			UnconfirmedHint:
				'Hasta bildirimlerine dayanır; ekibin elinde belge bulunmamaktadır',
			ClinicResponseTitle: 'Kliniğin resmî yanıtı',
			SeePinnedReview: 'Bu vakayla ilgili yorum',
			SeeArticle: 'Vaka incelemesi',
			ReputationFooter:
				'Bu bölüm, hasta bildirimleri ve sunulan belgelere dayanarak docta.me ekibi tarafından yönetilir. Klinik, {email} adresine resmî bir yanıt gönderebilir — yanıtı burada yayımlarız.',
			ReviewsCautionNotice:
				'Bu klinik hakkında doğrulanmış hasta şikâyetleri var.',
			ReviewsCautionLink: 'Ayrıntılar İtibar bölümünde',
		},
	},
};
