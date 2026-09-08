// Только ОПИСАНИЯ статей — для карточек на листинге /articles.
//
// Парный модуль к i18n/article-title.ts. Листинг печатает у каждой статьи
// заголовок и описание, а импортировал ради этого ПЯТЬ полных словарей
// целиком, то есть тексты статей на шести локалях. Заголовки уехали в
// article-title.ts, описания — сюда; тексты остались на своих страницах.
//
// Файл СГЕНЕРИРОВАН и обязан совпадать с исходными словарями дословно:
// второго описания у статьи быть не должно. Расхождение и лишние ключи
// ловит tests/unit/article-slugs.spec.ts.
// Меняешь описание статьи — правь ОБА файла.
export default {
	messages: {
		'en': {
			Articles: 'Articles',
			ArticlesDescription:
				'Useful articles about healthcare in Montenegro: Russian-speaking doctors, clinics with multilingual support, and more.',
			AlgDescription:
				'Cetirizine (Zyrtec, Zodak) is not registered in Montenegro. Which antihistamines are sold here with or without a prescription, and how to match yours by ingredient.',
			BirthInMontenegroDescription:
				'Where to give birth in Montenegro: maternity wards of state hospitals and the private option, prenatal care, cost of childbirth without insurance, epidural availability, newborn paperwork and patronage nurse visits. Current as of July 2026.',
			ChildHealthcareDescription:
				'How pediatric care works in Montenegro: the izabrani pediatrician at the dom zdravlja, the Montenegrin vaccination calendar, certificates for kindergarten and school, care without a zdravstvena knjižica, and what to do in an emergency.',
			ClinicsWithLanguageSupportDescription:
				'A curated directory of listed clinics that report consultations in different languages. Coverage and language availability are not guaranteed; confirm the specific clinician, language and appointment directly with the clinic.',
			DentistryDescription:
				'What a filling, an extraction, a crown or an implant costs in Montenegro, who gets free dental care with the zdravstvena knjižica, how to find the on-call dentist for acute pain at night or on holidays, and how to choose a clinic. Updated July 2026.',
			HealthcareSystemDescription:
				'Emergency number 124, dom zdravlja vs private clinics, the zdravstvena knjižica health card, care options for EU citizens and other foreigners — a practical guide to the Montenegrin healthcare system.',
			LabTestsArticleDescription:
				'Routine private tests, price guidance, when a clinician order may be needed, the state route, CT and MRI, preventive screening and safe result interpretation. Reviewed July 2026.',
			MentalHealthDescription:
				'How mental health care works in Montenegro: state mental health centers and psychiatric hospitals, finding a therapist who speaks your language, continuing your medication after relocation, prices with and without the zdravstvena knjižica, and where to turn in a crisis.',
			PharmaciesDescription:
				'How pharmacies work in Montenegro: pharmacy networks and duty services, e-prescriptions, why a foreign prescription does not guarantee dispensing, Fund-covered medicines, and how to search the local medicine registry by product or active ingredient. Reviewed July 2026.',
			ResidenceInsuranceDescription:
				'Why every boravak application needs health insurance, how long a policy each city asks for — from 40 days in Podgorica to 2 years in Budva — prices at Sava, Lovćen and Uniqa, what the policy actually covers and who gets state insurance instead. Updated July 2026.',
			RussianSpeakingDoctorsDescription:
				'A curated directory of listed doctors in Montenegro who report speaking Russian, grouped by specialty. Coverage is not complete; confirm current practice, language level, licence and appointment details directly.',
			TouristHealthcareDescription:
				'Emergency number 124, the turistička ambulanta at local health centers, private clinics and hospital ERs, what treatment really costs without insurance, EHIC and bilateral agreements, travel insurance tips and pharmacies — a practical guide for tourists in Montenegro.',
			UnaDescription:
				'Enterosgel, Miramistin, Suprastin — which drugs from a Russian or Ukrainian home kit you won’t find in Montenegro, and how to find a substitute by active ingredient.',
			WeekendMedicalHelpDescription:
				'Where to get medical help on a Saturday or Sunday in Montenegro: 24-hour and on-duty pharmacies, hospitals with 24/7 admission, private clinics open on weekends.',
			CityHcDescription_bar:
				'Medical help in Bar: ambulance 124, Dom zdravlja Bar in the center, the Blažo Orlandić hospital in Stari Bar, private clinics, laboratories and pharmacies.',
			CityHcDescription_budva:
				'Where to get medical help in Budva: ambulance 124, Dom zdravlja Budva, the tourist ambulanta, private clinics and laboratories, pharmacies — a practical guide.',
			CityHcDescription_kotor:
				'Medical help in Kotor: ambulance 124, Kotor General Hospital serving the whole Boka bay, Dom zdravlja Kotor and the specialized hospital in Risan.',
			CityHcDescription_podgorica:
				'Medical help in Podgorica: ambulance 124, the Clinical Center of Montenegro and its Urgent Care Center, Dom zdravlja, private clinics and 24-hour pharmacies.',
		},
		'ru': {
			Articles: 'Статьи',
			ArticlesDescription:
				'Полезные статьи о здравоохранении в Черногории: русскоязычные врачи, клиники с языковой поддержкой и многое другое.',
			AlgDescription:
				'Цетиризина (Зиртек, Зодак) в реестре Черногории нет. Какие антигистаминные продают без рецепта и по рецепту и чем заменить привычный бренд по действующему веществу.',
			BirthInMontenegroDescription:
				'Где рожать в Черногории: роддома государственных больниц и частный вариант, ведение беременности, цены родов без страховки, доступность эпидуральной анестезии, документы для новорождённого и патронаж. Актуально на июль 2026 года.',
			ChildHealthcareDescription:
				'Как устроена детская медицина в Черногории: выбранный педиатр в dom zdravlja, черногорский календарь прививок, справки для сада и школы, помощь без здравственной книжицы и действия в экстренных ситуациях.',
			ClinicsWithLanguageSupportDescription:
				'Редакционный каталог добавленных клиник, которые сообщают о консультациях на разных языках. Полнота и доступность языка не гарантируются: подтверждайте конкретного врача, язык и запись непосредственно в клинике.',
			DentistryDescription:
				'Сколько стоят пломба, удаление зуба, коронка и имплант в Черногории, кому стоматология бесплатна по здравственной книжице, как найти дежурного стоматолога при острой боли ночью и в праздники и как выбрать клинику. Актуально на июль 2026 года.',
			HealthcareSystemDescription:
				'Экстренный номер 124, dom zdravlja и частные клиники, здравственная книжица, помощь для граждан ЕС и других иностранцев — практический гид по системе здравоохранения Черногории.',
			LabTestsArticleDescription:
				'Рутинные частные анализы, ориентиры цен, когда нужно назначение врача, бесплатный маршрут, КТ и МРТ, профилактический скрининг и безопасный разбор результатов. Проверено в июле 2026 года.',
			MentalHealthDescription:
				'Как устроена помощь в сфере ментального здоровья в Черногории: государственные центры ментального здоровья и психиатрические больницы, поиск терапевта на своём языке, продолжение медикаментозного лечения после переезда, цены с книжицей и без, куда обращаться в кризисной ситуации.',
			PharmaciesDescription:
				'Как работают аптеки в Черногории: аптечные сети и дежурства, электронные рецепты, почему иностранный рецепт не гарантирует отпуск, лекарства с покрытием Фонда и поиск по собственному реестру лекарств по названию или действующему веществу. Проверено в июле 2026 года.',
			ResidenceInsuranceDescription:
				'Зачем при подаче на боравак нужна медицинская страховка, на какой срок её требуют в разных городах — от 40 дней в Подгорице до 2 лет в Будве, — цены Sava, Lovćen и Uniqa, что полис реально покрывает и кому вместо него положена государственная страховка. Актуально на июль 2026.',
			RussianSpeakingDoctorsDescription:
				'Редакционный каталог добавленных врачей в Черногории, которые указывают русский язык, с группировкой по специальностям. Каталог не претендует на полноту: уточняйте место работы, уровень языка, лицензию и запись напрямую.',
			TouristHealthcareDescription:
				'Экстренный номер 124, туристическая амбуланта при доме здравля, частные клиники и приёмные отделения больниц, реальные цены без страховки, EHIC и двусторонние соглашения, советы по travel-страховке и аптеки — практический гид для туристов в Черногории.',
			UnaDescription:
				'Энтеросгель, Мирамистин, Супрастин — чего из привычной домашней аптечки не найти в Черногории и как искать замену по действующему веществу. Актуально на июль 2026.',
			WeekendMedicalHelpDescription:
				'Где получить медицинскую помощь в субботу и воскресенье в Черногории: круглосуточные и дежурные аптеки, больницы с круглосуточным приёмом, частные клиники.',
			CityHcDescription_bar:
				'Медицинская помощь в Баре: скорая 124, Dom zdravlja Bar в центре города, больница «Блажо Орландич» в Старом Баре, частные клиники, лаборатории и аптеки.',
			CityHcDescription_budva:
				'Куда обращаться за медицинской помощью в Будве: скорая 124, Dom zdravlja Budva, туристическая амбулатория, частные клиники и лаборатории, аптеки — практический гид.',
			CityHcDescription_kotor:
				'Медицинская помощь в Которе: скорая 124, Општа больница Котор, обслуживающая всю Боку, Dom zdravlja Kotor и специализированная больница в Рисане.',
			CityHcDescription_podgorica:
				'Медицинская помощь в Подгорице: скорая 124, Клинический центр Черногории и Ургентный центр, Dom zdravlja, частные клиники и лаборатории, круглосуточные аптеки.',
		},
		'sr': {
			Articles: 'Članci',
			ArticlesDescription:
				'Korisni članci o zdravstvenoj zaštiti u Crnoj Gori: doktori koji govore ruski, klinike sa višejezičnom podrškom i još mnogo toga.',
			AlgDescription:
				'Cetirizina (Zyrtec, Zodak) nema u registru Crne Gore. Koji antihistaminici se ovdje izdaju bez recepta i na recept i kako naći poznati brend po aktivnoj supstanci.',
			BirthInMontenegroDescription:
				'Gdje se porađa u Crnoj Gori: porodilišta državnih bolnica i privatna opcija, vođenje trudnoće, cijena porođaja bez osiguranja, dostupnost epiduralne analgezije, dokumenti za novorođenče i patronaža. Važi za jul 2026.',
			ChildHealthcareDescription:
				'Kako funkcioniše dječja medicina u Crnoj Gori: izabrani pedijatar u domu zdravlja, crnogorski kalendar vakcinacije, potvrde za vrtić i školu, pomoć bez zdravstvene knjižice i postupanje u hitnim situacijama.',
			ClinicsWithLanguageSupportDescription:
				'Uređeni katalog unesenih klinika koje navode konsultacije na različitim jezicima. Potpunost i jezička dostupnost nijesu garantovane; provjerite konkretnog doktora, jezik i termin direktno sa klinikom.',
			DentistryDescription:
				'Koliko koštaju plomba, vađenje zuba, krunica i implantat u Crnoj Gori, ko ima pravo na besplatnog izabranog stomatologa, kako do pripravnog stomatologa kod akutnog bola noću i praznicima i kako izabrati ordinaciju. Ažurirano: jul 2026.',
			HealthcareSystemDescription:
				'Broj hitne pomoći 124, dom zdravlja i privatne klinike, zdravstvena knjižica, njega za državljane EU i druge strance — praktični vodič kroz zdravstveni sistem Crne Gore.',
			LabTestsArticleDescription:
				'Rutinske privatne analize, cijene, kada je potreban nalog ljekara, državni put, CT i MR, preventivni skrining i bezbjedno tumačenje. Provjereno u julu 2026.',
			MentalHealthDescription:
				'Kako funkcioniše zaštita mentalnog zdravlja u Crnoj Gori: državni centri za mentalno zdravlje i psihijatrijske bolnice, kako naći terapeuta koji govori vaš jezik, nastavak terapije ljekovima nakon preseljenja, cijene sa zdravstvenom knjižicom i bez nje, kome se obratiti u kriznoj situaciji.',
			PharmaciesDescription:
				'Kako rade apoteke u Crnoj Gori: mreže i dežurstva, elektronski recepti, zašto strani recept ne garantuje izdavanje, ljekovi koje pokriva Fond i pretraga našeg registra po nazivu ili aktivnoj supstanci. Provjereno u julu 2026.',
			ResidenceInsuranceDescription:
				'Zašto je za zahtjev za boravak potrebno zdravstveno osiguranje, na koji period polisu traže u različitim gradovima — od 40 dana u Podgorici do 2 godine u Budvi — cijene kod Sava, Lovćen i Uniqa osiguranja, šta polisa stvarno pokriva i ko umjesto nje dobija državno osiguranje. Ažurirano: jul 2026.',
			RussianSpeakingDoctorsDescription:
				'Uređeni katalog unesenih doktora u Crnoj Gori koji navode ruski jezik, grupisan po specijalnosti. Katalog nije potpun; direktno provjerite mjesto rada, nivo jezika, licencu i termin.',
			TouristHealthcareDescription:
				'Broj hitne pomoći 124, turistička ambulanta pri domu zdravlja, privatne klinike i bolnička prijemna odjeljenja, stvarne cijene bez osiguranja, EHIC i bilateralni sporazumi, savjeti za putno osiguranje i apoteke — praktični vodič za turiste u Crnoj Gori.',
			UnaDescription:
				'Enterosgel, Miramistin, Suprastin — čega iz uobičajene kućne apoteke nema u Crnoj Gori i kako tražiti zamjenu po aktivnoj supstanci. Važi za jul 2026.',
			WeekendMedicalHelpDescription:
				'Gdje potražiti medicinsku pomoć subotom ili nedjeljom u Crnoj Gori: non-stop i dežurne apoteke, bolnice sa non-stop prijemom, privatne klinike vikendom.',
			CityHcDescription_bar:
				'Medicinska pomoć u Baru: hitna 124, Dom zdravlja Bar u centru, Opšta bolnica „Blažo Orlandić" u Starom Baru, privatne klinike, laboratorije i apoteke.',
			CityHcDescription_budva:
				'Gdje potražiti medicinsku pomoć u Budvi: hitna 124, Dom zdravlja Budva, turistička ambulanta, privatne klinike i laboratorije, apoteke — praktični vodič.',
			CityHcDescription_kotor:
				'Medicinska pomoć u Kotoru: hitna 124, Opšta bolnica Kotor koja pokriva cijelu Boku, Dom zdravlja Kotor, specijalna bolnica u Risnu, privatne laboratorije i apoteke.',
			CityHcDescription_podgorica:
				'Medicinska pomoć u Podgorici: hitna 124, Klinički centar Crne Gore i Urgentni centar, dom zdravlja, privatne klinike i laboratorije, non-stop apoteke.',
		},
		'de': {
			Articles: 'Artikel',
			ArticlesDescription:
				'Nützliche Artikel über das Gesundheitswesen in Montenegro: russischsprachige Ärzte, Kliniken mit mehrsprachiger Unterstützung und mehr.',
			AlgDescription:
				'Cetirizin (Zyrtec, Zodak) ist in Montenegro nicht zugelassen. Welche Antihistaminika es hier mit und ohne Rezept gibt und wie Sie Ersatz über den Wirkstoff finden.',
			BirthInMontenegroDescription:
				'Wo man in Montenegro entbindet: Geburtsstationen der staatlichen Krankenhäuser und die private Option, Schwangerschaftsvorsorge, Kosten der Geburt ohne Versicherung, Verfügbarkeit der PDA, Papiere für das Neugeborene und Hebammen-Hausbesuche. Stand: Juli 2026.',
			ChildHealthcareDescription:
				'So funktioniert die Kindermedizin in Montenegro: der izabrani-Kinderarzt im Dom zdravlja, der montenegrinische Impfkalender, Atteste für Kindergarten und Schule, Versorgung ohne zdravstvena knjižica und das richtige Verhalten im Notfall.',
			ClinicsWithLanguageSupportDescription:
				'Ein redaktionell gepflegtes Verzeichnis eingetragener Kliniken, die Beratungen in verschiedenen Sprachen angeben. Vollständigkeit und Sprachverfügbarkeit sind nicht garantiert; konkreten Arzt, Sprache und Termin direkt bestätigen.',
			DentistryDescription:
				'Was Füllung, Zahnextraktion, Krone oder Implantat in Montenegro kosten, wer mit der zdravstvena knjižica Anspruch auf kostenlose Zahnbehandlung hat, wie man bei akuten Schmerzen nachts und an Feiertagen den Bereitschaftszahnarzt findet und wie man eine Praxis auswählt. Stand: Juli 2026.',
			HealthcareSystemDescription:
				'Notrufnummer 124, Dom zdravlja und Privatkliniken, die Gesundheitskarte zdravstvena knjižica, Versorgung für EU-Bürger und andere Ausländer — ein praktischer Leitfaden zum montenegrinischen Gesundheitssystem.',
			LabTestsArticleDescription:
				'Übliche private Tests, Preisrichtwerte, wann eine ärztliche Anordnung nötig ist, staatlicher Weg, CT und MRT, Vorsorge und sichere Befundinterpretation. Geprüft im Juli 2026.',
			MentalHealthDescription:
				'Wie die psychische Gesundheitsversorgung in Montenegro funktioniert: staatliche Zentren für mentale Gesundheit und psychiatrische Kliniken, einen Therapeuten in Ihrer Sprache finden, die Medikation nach dem Umzug fortsetzen, Preise mit und ohne zdravstvena knjižica und wohin man sich in einer Krise wendet.',
			PharmaciesDescription:
				'Apotheken in Montenegro: Netze und Bereitschaft, E-Rezepte, warum ein ausländisches Rezept keine Abgabe garantiert, vom Fonds gedeckte Arzneimittel und Suche im eigenen Register nach Produkt oder Wirkstoff. Geprüft im Juli 2026.',
			ResidenceInsuranceDescription:
				'Warum jeder Boravak-Antrag eine Krankenversicherung braucht, für welche Dauer die Städte eine Police verlangen — von 40 Tagen in Podgorica bis 2 Jahren in Budva —, Preise bei Sava, Lovćen und Uniqa, was die Police wirklich abdeckt und wer stattdessen die staatliche Versicherung erhält. Stand: Juli 2026.',
			RussianSpeakingDoctorsDescription:
				'Ein redaktionell gepflegtes Verzeichnis eingetragener Ärzte in Montenegro, die Russisch angeben, nach Fachgebiet. Es ist nicht vollständig; Praxis, Sprachniveau, Zulassung und Termin direkt bestätigen.',
			TouristHealthcareDescription:
				'Notrufnummer 124, die turistička ambulanta am örtlichen Gesundheitszentrum, Privatkliniken und Notaufnahmen, reale Preise ohne Versicherung, EHIC und bilaterale Abkommen, Tipps zur Reiseversicherung und Apotheken — ein praktischer Leitfaden für Touristen in Montenegro.',
			UnaDescription:
				'Enterosgel, Miramistin, Suprastin — welche Medikamente aus der gewohnten Hausapotheke es in Montenegro nicht gibt und wie Sie über den Wirkstoff ein Pendant finden.',
			WeekendMedicalHelpDescription:
				'Medizinische Hilfe am Samstag oder Sonntag in Montenegro: 24-Stunden- und Notdienst-Apotheken, Krankenhäuser mit 24-Stunden-Aufnahme, Privatkliniken am Wochenende.',
			CityHcDescription_bar:
				'Medizinische Hilfe in Bar: Notruf 124, Dom zdravlja Bar im Zentrum, das Krankenhaus Blažo Orlandić in Stari Bar, Privatkliniken, Labore und Apotheken.',
			CityHcDescription_budva:
				'Wo Sie in Budva medizinische Hilfe bekommen: Notruf 124, Dom zdravlja Budva, Touristenambulanz, Privatkliniken und Labore, Apotheken — ein praktischer Leitfaden.',
			CityHcDescription_kotor:
				'Medizinische Hilfe in Kotor: Notruf 124, das Allgemeine Krankenhaus Kotor für die ganze Boka-Bucht, Dom zdravlja Kotor und die Spezialklinik in Risan.',
			CityHcDescription_podgorica:
				'Medizinische Hilfe in Podgorica: Notruf 124, das Klinische Zentrum Montenegros mit Urgentni centar, Dom zdravlja, Privatkliniken und Labore, 24-Stunden-Apotheken.',
		},
		'tr': {
			Articles: 'Makaleler',
			ArticlesDescription:
				"Karadağ'daki sağlık hizmetleri hakkında yararlı makaleler: Rusça konuşan doktorlar, çok dilli destek sunan klinikler ve daha fazlası.",
			AlgDescription:
				'Setirizin (Zyrtec, Zodak) Karadağ’da ruhsatlı değil. Eczanelerde reçetesiz ve reçeteyle hangi antihistaminikler var, markanızı etkin maddesinden nasıl bulursunuz.',
			BirthInMontenegroDescription:
				"Karadağ'da nerede doğum yapılır: devlet hastanelerinin doğumhaneleri ve özel seçenek, gebelik takibi, sigortasız doğumun maliyeti, epidural imkânı, yenidoğan evrakları ve ev ziyareti hemşiresi. Temmuz 2026 itibarıyla günceldir.",
			ChildHealthcareDescription:
				"Karadağ'da çocuk sağlığı hizmetleri nasıl işler: dom zdravlja'daki izabrani çocuk doktoru, Karadağ aşı takvimi, kreş ve okul için raporlar, zdravstvena knjižica olmadan sağlık hizmeti ve acil durumlarda yapılacaklar.",
			ClinicsWithLanguageSupportDescription:
				'Farklı dillerde görüşme bildiren kayıtlı kliniklerin düzenlenmiş kataloğu. Tamlık ve dil erişimi garanti değildir; belirli hekimi, dili ve randevuyu klinikten doğrulayın.',
			DentistryDescription:
				"Karadağ'da dolgu, diş çekimi, kuron ve implant ne kadar tutar; zdravstvena knjižica ile kimler ücretsiz diş tedavisi alır; gece ve tatillerde şiddetli ağrıda nöbetçi diş hekimine nasıl ulaşılır; klinik nasıl seçilir. Temmuz 2026 itibarıyla günceldir.",
			HealthcareSystemDescription:
				'Acil numarası 124, dom zdravlja ve özel klinikler, zdravstvena knjižica sağlık kartı, AB vatandaşları ve diğer yabancılar için sağlık hizmetleri — Karadağ sağlık sistemine pratik bir rehber.',
			LabTestsArticleDescription:
				'Rutin özel testler, fiyatlar, hekim isteminin ne zaman gerektiği, devlet yolu, BT ve MR, koruyucu tarama ve güvenli sonuç yorumu. Temmuz 2026 tarihinde incelendi.',
			MentalHealthDescription:
				'Karadağ’da ruh sağlığı hizmetleri nasıl işler: devlet ruh sağlığı merkezleri ve psikiyatri hastaneleri, kendi dilinizde terapist bulma, taşındıktan sonra ilaç tedavisine devam etme, zdravstvena knjižica ile ve olmadan fiyatlar, kriz durumunda nereye başvurulur.',
			PharmaciesDescription:
				'Karadağ eczaneleri: ağlar ve nöbet, e-reçeteler, yabancı reçetenin neden ilaç verilmesini garanti etmediği, Fon kapsamındaki ilaçlar ve kendi sicilimizde ürün veya etken maddeyle arama. Temmuz 2026 tarihinde incelendi.',
			ResidenceInsuranceDescription:
				"Boravak başvurusunda sağlık sigortası neden zorunlu, şehirler poliçeyi hangi süre için istiyor — Podgorica'da 40 günden Budva'da 2 yıla —, Sava, Lovćen ve Uniqa fiyatları, poliçenin gerçekte neyi kapsadığı ve kimin bunun yerine devlet sigortası aldığı. Güncelleme: Temmuz 2026.",
			RussianSpeakingDoctorsDescription:
				'Karadağ genelinde Rusça bildiren kayıtlı doktorların uzmanlığa göre düzenlenmiş kataloğu. Tam değildir; çalışma yeri, dil düzeyi, ruhsat ve randevuyu doğrudan doğrulayın.',
			TouristHealthcareDescription:
				"Acil numarası 124, dom zdravlja'daki turistička ambulanta, özel klinikler ve hastane acil servisleri, sigortasız tedavinin gerçek fiyatları, EHIC ve ikili anlaşmalar, seyahat sigortası ipuçları ve eczaneler — Karadağ'daki turistler için pratik bir rehber.",
			UnaDescription:
				"Enterosgel, miramistin, suprastin — alıştığınız evdeki ilaç dolabından hangi ilaçlar Karadağ'da bulunmuyor ve etken maddeye göre muadil nasıl aranır.",
			WeekendMedicalHelpDescription:
				"Karadağ'da cumartesi veya pazar günü nereden tıbbi yardım alınır: 24 saat açık ve nöbetçi eczaneler, 7/24 kabul yapan hastaneler, hafta sonu açık özel klinikler.",
			CityHcDescription_bar:
				"Bar'da tıbbi yardım: ambulans 124, merkezdeki Dom zdravlja Bar, Stari Bar'daki Blažo Orlandić hastanesi, özel klinikler, laboratuvarlar ve eczaneler.",
			CityHcDescription_budva:
				"Budva'da tıbbi yardım nereden alınır: ambulans 124, Dom zdravlja Budva, turist polikliniği, özel klinikler ve laboratuvarlar, eczaneler — pratik rehber.",
			CityHcDescription_kotor:
				"Kotor'da tıbbi yardım: ambulans 124, tüm Boka körfezine hizmet veren Kotor Genel Hastanesi, Dom zdravlja Kotor ve Risan'daki ihtisas hastanesi.",
			CityHcDescription_podgorica:
				"Podgorica'da tıbbi yardım: ambulans 124, Karadağ Klinik Merkezi ve Acil Merkezi, Dom zdravlja, özel klinikler ve laboratuvarlar, nöbetçi eczaneler.",
		},
		'sr-cyrl': {
			Articles: 'Чланци',
			ArticlesDescription:
				'Корисни чланци о здравственој заштити у Црној Гори: доктори који говоре руски, клинике са вишејезичном подршком и још много тога.',
			AlgDescription:
				'Цетиризина (Zyrtec, Zodak) нема у регистру Црне Горе. Који антихистаминици се овдје издају без рецепта и на рецепт и како наћи познати бренд по активној супстанци.',
			BirthInMontenegroDescription:
				'Гдје се порађа у Црној Гори: породилишта државних болница и приватна опција, вођење трудноће, цијена порођаја без осигурања, доступност епидуралне аналгезије, документи за новорођенче и патронажа. Важи за јул 2026.',
			ChildHealthcareDescription:
				'Како функционише дјечја медицина у Црној Гори: изабрани педијатар у дому здравља, црногорски календар вакцинације, потврде за вртић и школу, помоћ без здравствене књижице и поступање у хитним ситуацијама.',
			ClinicsWithLanguageSupportDescription:
				'Уређени каталог унесених клиника које наводе консултације на различитим језицима. Потпуност и језичка доступност нијесу гарантоване; провјерите конкретног доктора, језик и термин директно са клиником.',
			DentistryDescription:
				'Колико коштају пломба, вађење зуба, круница и имплантат у Црној Гори, ко има право на бесплатног изабраног стоматолога, како до приправног стоматолога код акутног бола ноћу и празницима и како изабрати ординацију. Ажурирано: јул 2026.',
			HealthcareSystemDescription:
				'Број хитне помоћи 124, дом здравља и приватне клинике, здравствена књижица, њега за држављане ЕУ и друге странце — практични водич кроз здравствени систем Црне Горе.',
			LabTestsArticleDescription:
				'Рутинске приватне анализе, цијене, када је потребан налог љекара, државни пут, CT и MR, превентивни скрининг и безбједно тумачење. Провјерено у јулу 2026.',
			MentalHealthDescription:
				'Како функционише заштита менталног здравља у Црној Гори: државни центри за ментално здравље и психијатријске болнице, како наћи терапеута који говори ваш језик, наставак терапије љековима након пресељења, цијене са здравственом књижицом и без ње, коме се обратити у кризној ситуацији.',
			PharmaciesDescription:
				'Како раде апотеке у Црној Гори: мреже и дежурства, електронски рецепти, зашто страни рецепт не гарантује издавање, љекови које покрива Фонд и претрага нашег регистра по називу или активној супстанци. Провјерено у јулу 2026.',
			ResidenceInsuranceDescription:
				'Зашто је за захтјев за боравак потребно здравствено осигурање, на који период полису траже у различитим градовима — од 40 дана у Подгорици до 2 године у Будви — цијене код Sava, Lovćen и Uniqa осигурања, шта полиса стварно покрива и ко умјесто ње добија државно осигурање. Ажурирано: јул 2026.',
			RussianSpeakingDoctorsDescription:
				'Уређени каталог унесених доктора у Црној Гори који наводе руски језик, груписан по специјалности. Каталог није потпун; директно провјерите мјесто рада, ниво језика, лиценцу и термин.',
			TouristHealthcareDescription:
				'Број хитне помоћи 124, туристичка амбуланта при дому здравља, приватне клинике и болничка пријемна одјељења, стварне цијене без осигурања, EHIC и билатерални споразуми, савјети за путно осигурање и апотеке — практични водич за туристе у Црној Гори.',
			UnaDescription:
				'Enterosgel, Miramistin, Suprastin — чега из уобичајене кућне апотеке нема у Црној Гори и како тражити замјену по активној супстанци. Важи за јул 2026.',
			WeekendMedicalHelpDescription:
				'Гдје потражити медицинску помоћ суботом или недјељом у Црној Гори: нон-стоп и дежурне апотеке, болнице са нон-стоп пријемом, приватне клинике викендом.',
			CityHcDescription_bar:
				'Медицинска помоћ у Бару: хитна 124, Дом здравља Бар у центру, Општа болница „Блажо Орландић" у Старом Бару, приватне клинике, лабораторије и апотеке.',
			CityHcDescription_budva:
				'Гдје потражити медицинску помоћ у Будви: хитна 124, Дом здравља Будва, туристичка амбуланта, приватне клинике и лабораторије, апотеке — практични водич.',
			CityHcDescription_kotor:
				'Медицинска помоћ у Котору: хитна 124, Општа болница Котор која покрива цијелу Боку, Дом здравља Котор, специјална болница у Рисну, приватне лабораторије и апотеке.',
			CityHcDescription_podgorica:
				'Медицинска помоћ у Подгорици: хитна 124, Клинички центар Црне Горе и Ургентни центар, дом здравља, приватне клинике и лабораторије, нон-стоп апотеке.',
		},
	},
};
