/**
 * Generates SQL migration to update changed reviews for JUST Dental Clinic.
 * Usage: node scripts/generate-just-dental-migration.mjs > server/sql/migrate-reviews-just-dental.sql
 */
import { readFileSync } from 'node:fs'
import { resolve, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = resolve(__dirname, '..')

const data = JSON.parse(readFileSync(resolve(ROOT, 'data/google-places/bar/stomatologi-just-dental-clinic.json'), 'utf-8'))
const tData = JSON.parse(readFileSync(resolve(ROOT, 'data/review-translations/insert-reviews-just-dental-translations.json'), 'utf-8'))
const PLACE_ID = data.id

const tMap = new Map(tData.reviews.map(r => [r.id, r]))

// Build mismatches
const mismatches = []
for (const r of data.reviews) {
  const id = r.name.split('/').pop()
  const origText = r.originalText?.text || ''
  const tr = tMap.get(id)
  if (tr && origText && tr.text !== origText) {
    mismatches.push({
      id,
      providerReviewId: `places/${PLACE_ID}/reviews/${id}`,
      author: r.authorAttribution.displayName,
      originalLang: r.originalText?.languageCode || 'ru',
      newText: origText,
      oldText: tr.text,
    })
  }
}

// ---------------------------------------------------------------------------
// New translations for each changed review
// ---------------------------------------------------------------------------
const translations = {
  // 1. Mariia Grigorenko — extended
  'Ci9DQUlRQUNvZENodHljRjlvT2pZMVNtUXlSVjlSVUhCWmJFSnFkbkJSUnpkVlUxRRAB': {
    sr: `Najbolje preporuke za stomatologiju Just Dental. Konstantin je najbolji doktor-stomatolog za mene. Bezuslovno mu verujem za lečenje i čišćenje svojih zuba. Veoma dugo nisam mogla da nađem takvog doktora u Crnoj Gori i srećna sam što ga sada imam. Takođe želim da se zahvalim doktorki Viktoriji što je uspela da se sprijatelji i stekne poverenje moje ćerke. To nije bilo lako. Želim procvat ovoj prekrasnoj klinici.`,
    sr_cyrl: `Најбоље препоруке за стоматологију Just Dental. Константин је најбољи доктор-стоматолог за мене. Безусловно му верујем за лечење и чишћење својих зуба. Веома дуго нисам могла да нађем таквог доктора у Црној Гори и срећна сам што га сада имам. Такође желим да се захвалим докторки Викторији што је успела да се спријатељи и стекне поверење моје ћерке. То није било лако. Желим процват овој прекрасној клиници.`,
    en: `The highest recommendations for Just Dental. Konstantin is the best dentist for me. I unconditionally trust him with the treatment and cleaning of my teeth. For a very long time I couldn't find such a doctor in Montenegro, and I'm glad I finally have one. I also want to thank Dr. Viktoria for managing to befriend and earn the trust of my daughter. It wasn't easy. I wish this wonderful clinic prosperity.`,
    de: `Die besten Empfehlungen für die Zahnklinik Just Dental. Konstantin ist für mich der beste Zahnarzt. Ich vertraue ihm bedingungslos die Behandlung und Reinigung meiner Zähne an. Sehr lange konnte ich in Montenegro keinen solchen Arzt finden, und ich bin froh, dass ich ihn jetzt habe. Außerdem möchte ich Dr. Viktoria danken, dass sie es geschafft hat, sich mit meiner Tochter anzufreunden und ihr Vertrauen zu gewinnen. Das war nicht einfach. Ich wünsche dieser wunderbaren Klinik viel Erfolg.`,
    tr: `Just Dental diş kliniği için en iyi tavsiyeler. Konstantin benim için en iyi diş hekimi. Dişlerimin tedavisi ve temizliği için ona kayıtsız şartsız güveniyorum. Karadağ'da uzun süre böyle bir doktor bulamadım ve artık bulduğum için çok mutluyum. Ayrıca kızımla arkadaş olmayı ve güvenini kazanmayı başaran Dr. Viktoriya'ya da teşekkür etmek istiyorum. Bu kolay değildi. Bu harika kliniğe başarılar diliyorum.`,
  },

  // 2. Martin Dugen — en original (was ru translation)
  'Ci9DQUlRQUNvZENodHljRjlvT2pRd05GRTBTVFZwWm5KVVJsWTNPVjlmU0hkWk1YYxAB': {
    ru: `Наконец-то действительно компетентная стоматологическая клиника в Баре.\n\nОчень рекомендую! Исключительно положительный опыт.`,
    sr: `Konačno zaista kompetentna stomatološka klinika u Baru.\n\nToplo preporučujem! Izuzetno pozitivno iskustvo.`,
    sr_cyrl: `Коначно заиста компетентна стоматолошка клиника у Бару.\n\nТопло препоручујем! Изузетно позитивно искуство.`,
    en: null, // will use original
    de: `Endlich eine wirklich kompetente Zahnklinik in Bar.\n\nSehr empfehlenswert! Ein außergewöhnlich positives Erlebnis.`,
    tr: `Sonunda Bar'da gerçekten yetkin bir diş kliniği.\n\nKesinlikle tavsiye ederim! Son derece olumlu bir deneyim.`,
  },

  // 3. Fariza Gatagova — extended ending
  'Ci9DQUlRQUNvZENodHljRjlvT25sR2NVeEdUamxuZFhGaFNDMWZWekF4V1RsM1ZrRRAB': {
    sr: `Mom dečku je otpao komad umnjaka, našla sam Konstantina po preporuci, pogledala recenzije na mapama i shvatila da nam je definitivno ovde mesto. Primili su nas posle svog radnog vremena, jer je moj momak imao jak bol. Sve je prošlo brzo, bezbolno, ujutru su nam pisali da pitaju kako se osećamo i dali sve preporuke. Hvala mnogo! Izuzetno preporučujem`,
    sr_cyrl: `Мом дечку је отпао комад умњака, нашла сам Константина по препоруци, погледала рецензије на мапама и схватила да нам је дефинитивно овде место. Примили су нас после свог радног времена, јер је мој момак имао јак бол. Све је прошло брзо, безболно, ујутру су нам писали да питају како се осећамо и дали све препоруке. Хвала много! Изузетно препоручујем`,
    en: `My boyfriend's wisdom tooth chipped, I found Konstantin through a recommendation, checked the reviews on maps, and realized this was definitely the right place. They saw us after their working hours because my boyfriend was in severe pain. Everything went quickly, painlessly, in the morning they wrote to ask how he was feeling and gave all the recommendations. Thank you so much! Highly recommend`,
    de: `Meinem Freund brach ein Stück vom Weisheitszahn ab. Ich fand Konstantin auf Empfehlung, schaute mir die Bewertungen auf den Karten an und wusste, dass wir genau hierhin müssen. Sie haben uns nach ihrer Arbeitszeit empfangen, da mein Freund starke Schmerzen hatte. Alles ging schnell, schmerzfrei, am nächsten Morgen schrieben sie uns, um nach dem Befinden zu fragen, und gaben alle Empfehlungen. Vielen Dank! Kann ich nur empfehlen`,
    tr: `Erkek arkadaşımın yirmilik dişinden bir parça koptu, Konstantin'i tavsiye üzerine buldum, haritalardaki yorumları inceledim ve kesinlikle buraya gelmemiz gerektiğini anladım. Mesai saatleri dışında bizi kabul ettiler çünkü erkek arkadaşımın şiddetli ağrısı vardı. Her şey hızlı ve ağrısız geçti, sabah nasıl hissettiğimizi sormak için yazdılar ve tüm tavsiyeleri verdiler. Çok teşekkürler! Kesinlikle tavsiye ederim`,
  },

  // 4. Lorenzo Alboiu — en original
  'Ci9DQUlRQUNvZENodHljRjlvT2s1NFpYZGlPSGh1U3pBeFNDMHlRMTlKTlRWU2RVRRAB': {
    ru: `Мне нужно было удалить зуб мудрости, и доктор Константин справился с этим идеально. Абсолютно никакой боли, я очень рекомендую эту клинику`,
    sr: `Trebalo mi je da izvadim umnjak i Dr. Konstantin se savršeno pobrinuo za to. Apsolutno nikakav bol, toplo preporučujem ovu kliniku`,
    sr_cyrl: `Требало ми је да извадим умњак и Др. Константин се савршено побринуо за то. Апсолутно никакав бол, топло препоручујем ову клинику`,
    en: null,
    de: `Ich musste meinen Weisheitszahn entfernen lassen und Dr. Konstantin hat das perfekt erledigt. Absolut keine Schmerzen, ich empfehle diese Klinik von Herzen`,
    tr: `Yirmilik dişimi çektirmem gerekiyordu ve Dr. Konstantin bunu mükemmel bir şekilde halletti. Kesinlikle hiç ağrı olmadı, bu kliniği gönülden tavsiye ederim`,
  },

  // 5. Bad Microba — en original
  'Ci9DQUlRQUNvZENodHljRjlvT21oYWJtaGFNbkJVVVdNNFZqVXRjMDFrZEVsek9XYxAB': {
    ru: `Хороший ответственный врач`,
    sr: `Dobar odgovoran lekar`,
    sr_cyrl: `Добар одговоран лекар`,
    en: null,
    de: `Ein guter, verantwortungsvoller Arzt`,
    tr: `İyi, sorumlu bir doktor`,
  },

  // 6. Kati — extended (old translations were empty!)
  'Ci9DQUlRQUNvZENodHljRjlvT21Nd1dsQnlMVjlUYm5Ka1FUQmpPR3hyVUhGcFNtYxAB': {
    sr: `Imam osiguranje u Nemačkoj koje pokriva stomatologiju, ali zube lečim u Crnoj Gori kod doktora Konstantina. Na godišnjem pregledu kod nemačkog doktora čujem samo oduševljene komentare o radu doktora, sve plombe i krunice na implantima su urađene savesno, implant je stavljao njegov kolega sa zlatnim rukama Kiril Arturovič. Moji rođaci i prijatelji se leče kod ovog doktora, samo pozitivna iskustva, veoma ne želim da ode iz Bara`,
    sr_cyrl: `Имам осигурање у Немачкој које покрива стоматологију, али зубе лечим у Црној Гори код доктора Константина. На годишњем прегледу код немачког доктора чујем само одушевљене коментаре о раду доктора, све пломбе и крунице на имплантима су урађене савесно, имплант је стављао његов колега са златним рукама Кирил Артуровић. Моји рођаци и пријатељи се лече код овог доктора, само позитивна искуства, веома не желим да оде из Бара`,
    en: `I have dental insurance in Germany, but I treat my teeth in Montenegro with Dr. Konstantin. At my annual checkup with the German doctor, I only hear enthusiastic reviews about the doctor's work — all fillings and crowns on implants are done conscientiously, the implant was placed by his colleague with golden hands, Kirill Arturovich. My relatives and friends all go to this doctor, only positive experiences, I really don't want him to leave Bar`,
    de: `Ich habe in Deutschland eine Versicherung, die Zahnmedizin abdeckt, aber meine Zähne behandle ich in Montenegro bei Dr. Konstantin. Bei der jährlichen Kontrolle beim deutschen Arzt höre ich nur begeisterte Kommentare über die Arbeit des Doktors, alle Füllungen und Kronen auf Implantaten sind gewissenhaft gemacht, das Implantat wurde von seinem Kollegen mit goldenen Händen, Kirill Arturowitsch, eingesetzt. Meine Verwandten und Freunde lassen sich bei diesem Arzt behandeln, nur positive Erfahrungen, ich möchte sehr nicht, dass er aus Bar wegzieht`,
    tr: `Almanya'da diş hekimliğini kapsayan sigortam var, ama dişlerimi Karadağ'da Dr. Konstantin'de tedavi ettiriyorum. Alman doktordaki yıllık kontrolde doktorun çalışması hakkında sadece coşkulu yorumlar duyuyorum, tüm dolgular ve implant üzeri kronlar özenle yapılmış, implantı altın elleriyle meslektaşı Kirill Arturoviç koymuş. Akrabalarım ve arkadaşlarım bu doktorda tedavi oluyor, sadece olumlu deneyimler, Bar'dan gitmesini hiç istemiyorum`,
  },

  // 7. Салон красоты Elit — massively extended
  'Ci9DQUlRQUNvZENodHljRjlvT2pKcFUzZFRUVTlPVkhwUVdrODBRWEZ0YWkwMGFWRRAB': {
    sr: `Želim da izrazim ogromnu zahvalnost stomatologiji Just i lično doktoru Konstantinu za potpuno nov nivo brige o zdravlju.🙏\nOd samog praga oseća se atmosfera sterilnosti, čistoće i reda. Sve blista, koriste se jednokratni instrumenti, a najnovija oprema uliva poverenje da će lečenje biti precizno i efikasno. Ovde se vidi da se bezbednost klijenata shvata veoma ozbiljno.✅🌿\nAli glavno blago klinike je, naravno, zubar Konstantin. Prvo, ima magične ruke, lečenje prolazi apsolutno bezbolno. A drugo, Konstantin je neverovatno prijatan, duševan i pozitivan čovek sa odličnim smislom za humor. Pronalazi pristup svakome, puni svojom dobrom energijom, priča zanimljive i vesele priče. Zahvaljujući tome, vreme u stolici proleti brzo i neprimećeno, ponekad čak žališ što je sve već završeno!))☺🪥\nOd praga se oseća da je timu Just zaista važno da se klijent oseća udobno, mirno i da bude zadovoljan rezultatom.\nSvakako preporučujem ovu kliniku svima koji cene visok profesionalizam, savremen pristup i zaista ljudski odnos. Hvala vam! Vi ste najbolji!🤩✌️🦷`,
    sr_cyrl: `Желим да изразим огромну захвалност стоматологији Just и лично доктору Константину за потпуно нов ниво бриге о здрављу.🙏\nОд самог прага осећа се атмосфера стерилности, чистоће и реда. Све блиста, користе се једнократни инструменти, а најновија опрема улива поверење да ће лечење бити прецизно и ефикасно. Овде се види да се безбедност клијената схвата веома озбиљно.✅🌿\nАли главно благо клинике је, наравно, зубар Константин. Прво, има магичне руке, лечење пролази апсолутно безболно. А друго, Константин је невероватно пријатан, душеван и позитиван човек са одличним смислом за хумор. Проналази приступ свакоме, пуни својом добром енергијом, прича занимљиве и веселе приче. Захваљујући томе, време у столици пролети брзо и непримећено, понекад чак жалиш што је све већ завршено!))☺🪥\nОд прага се осећа да је тиму Just заиста важно да се клијент осећа удобно, мирно и да буде задовољан резултатом.\nСвакако препоручујем ову клинику свима који цене висок професионализам, савремен приступ и заиста људски однос. Хвала вам! Ви сте најбољи!🤩✌️🦷`,
    en: `I want to express huge gratitude to Just dental clinic and personally to Dr. Konstantin for a completely new level of healthcare.🙏\nFrom the very entrance, you can feel the atmosphere of sterility, cleanliness, and order. Everything shines, disposable instruments are used, and the latest equipment inspires confidence that treatment will be precise and effective. It's clear that client safety is taken very seriously here.✅🌿\nBut the main treasure of the clinic is, of course, dentist Konstantin. First, he has magical hands — treatment is absolutely painless. And second, Konstantin is an incredibly pleasant, warm, and positive person with a great sense of humor. He finds an approach to everyone, charges you with his good energy, tells interesting and funny stories. Thanks to this, time in the chair flies by quickly and unnoticed, sometimes you even feel sorry it's already over!))☺🪥\nFrom the entrance you can feel that the Just team truly cares about the client feeling comfortable, calm, and satisfied with the result.\nI definitely recommend this clinic to everyone who values high professionalism, a modern approach, and genuinely human treatment. Thank you! You're the best!🤩✌️🦷`,
    de: `Ich möchte der Zahnarztpraxis Just und persönlich Dr. Konstantin meinen riesigen Dank für ein völlig neues Niveau der Gesundheitsversorgung aussprechen.🙏\nSchon ab der Schwelle spürt man die Atmosphäre von Sterilität, Sauberkeit und Ordnung. Alles glänzt, es werden Einweginstrumente verwendet, und die neueste Ausrüstung gibt Vertrauen, dass die Behandlung präzise und effektiv sein wird. Man sieht, dass die Sicherheit der Kunden hier sehr ernst genommen wird.✅🌿\nAber der Hauptschatz der Klinik ist natürlich Zahnarzt Konstantin. Erstens hat er magische Hände, die Behandlung verläuft absolut schmerzfrei. Und zweitens ist Konstantin ein unglaublich angenehmer, herzlicher und positiver Mensch mit großartigem Sinn für Humor. Er findet zu jedem einen Zugang, lädt mit seiner guten Energie auf, erzählt interessante und lustige Geschichten. Dadurch vergeht die Zeit im Stuhl schnell und unbemerkt, manchmal bedauert man sogar, dass schon alles vorbei ist!))☺🪥\nVon der Schwelle an spürt man, dass es dem Just-Team wirklich wichtig ist, dass sich der Kunde wohl und ruhig fühlt und mit dem Ergebnis zufrieden ist.\nIch empfehle diese Klinik jedem, der hohe Professionalität, einen modernen Ansatz und wirklich menschlichen Umgang schätzt. Danke! Ihr seid die Besten!🤩✌️🦷`,
    tr: `Just diş kliniğine ve kişisel olarak Dr. Konstantin'e sağlık hizmetinde tamamen yeni bir seviye için büyük teşekkürlerimi ifade etmek istiyorum.🙏\nDaha kapıdan girerken sterillik, temizlik ve düzen atmosferi hissediliyor. Her şey pırıl pırıl, tek kullanımlık aletler kullanılıyor ve en yeni ekipman tedavinin hassas ve etkili olacağına güven veriyor. Burada müşteri güvenliğinin çok ciddiye alındığı görülüyor.✅🌿\nAma kliniğin asıl hazinesi tabii ki diş hekimi Konstantin. Birincisi, sihirli elleri var, tedavi kesinlikle ağrısız geçiyor. İkincisi, Konstantin inanılmaz hoş, cana yakın ve pozitif biri, mükemmel bir espri anlayışı var. Herkese yaklaşım buluyor, iyi enerjisiyle şarj ediyor, ilginç ve eğlenceli hikayeler anlatıyor. Bu sayede koltukta geçen zaman hızla ve fark edilmeden geçiyor, bazen her şeyin bittiğine bile üzülüyorsun!))☺🪥\nKapıdan itibaren Just ekibinin müşterinin rahat, huzurlu hissetmesine ve sonuçtan memnun kalmasına gerçekten önem verdiği hissediliyor.\nYüksek profesyonelliğe, modern yaklaşıma ve gerçekten insani ilişkiye değer veren herkese bu kliniği kesinlikle tavsiye ederim. Teşekkürler! En iyisisiniz!🤩✌️🦷`,
  },

  // 8. Юлия — full negative review, significantly extended
  'Ci9DQUlRQUNvZENodHljRjlvT25Vd2RIcGlTVWd5Tkc1amFqaEdZMVV4VVd0UE0yYxAB': {
    sr: `Htela sam da se ograničim na ocenu, ali mi je stigao čudan komentar od klinike da sam pogrešila ostavljajući recenziju o nekom hotelu. Kad već tražite, objasniću. Pre godinu dana, pročitavši recenzije o tome kakav je Konstantin dobar lekar, izabrala sam kliniku Just Dental. Konstantin je uradio čišćenje i izlečio jedan zub. Nakon što su desni došle u normalu, primetila sam beli fragment u desni, pisala sam Konstantinu o tome. Pregledavši, pokušao je da ga izvadi pincetom, zatim je napravio snimak i zaprepastio me svojim zaključkom da je to "moja kost koja viri". Na pitanje "šta da radim?" odgovorio je da ne zna i da je potreban uži specijalista. Sa teškim osećajem da imam neku strašnu situaciju otišla sam iz Crne Gore. I tek posle 8 meseci sam se ohrabrila i otišla kod stomatologa u drugoj zemlji na redovan pregled. Ispostavilo se da je to mlečni zub, koji su mi izvadili za nekoliko minuta bez anestezije. Očigledno se Konstantin nije susretao sa mlečnim zubom kod odrasle osobe, ali njegova reakcija kada nešto nije krenulo kako treba bila je čudna, jednostavno se distancirao u istom trenutku. Obično u klinici daju dokument o pruženoj usluzi, on mi ništa nije dao, i to me je utvrdilo u misli da imam nešto loše. Razumem da je u Crnoj Gori teško uopšte naći lekara, ali imajte na umu da ako je sve u redu, Konstantin je sjajan, ali ako nešto pođe po zlu, može postupiti drugačije.`,
    sr_cyrl: `Хтела сам да се ограничим на оцену, али ми је стигао чудан коментар од клинике да сам погрешила остављајући рецензију о неком хотелу. Кад већ тражите, објаснићу. Пре годину дана, прочитавши рецензије о томе какав је Константин добар лекар, изабрала сам клинику Just Dental. Константин је урадио чишћење и излечио један зуб. Након што су десни дошле у нормалу, приметила сам бели фрагмент у десни, писала сам Константину о томе. Прегледавши, покушао је да га извади пинцетом, затим је направио снимак и запрепастио ме својим закључком да је то "моја кост која вири". На питање "шта да радим?" одговорио је да не зна и да је потребан ужи специјалиста. Са тешким осећајем да имам неку страшну ситуацију отишла сам из Црне Горе. И тек после 8 месеци сам се охрабрила и отишла код стоматолога у другој земљи на редован преглед. Испоставило се да је то млечни зуб, који су ми извадили за неколико минута без анестезије. Очигледно се Константин није сусретао са млечним зубом код одрасле особе, али његова реакција када нешто није кренуло како треба била је чудна, једноставно се дистанцирао у истом тренутку. Обично у клиници дају документ о пруженој услузи, он ми ништа није дао, и то ме је утврдило у мисли да имам нешто лоше. Разумем да је у Црној Гори тешко уопште наћи лекара, али имајте на уму да ако је све у реду, Константин је сјајан, али ако нешто пође по злу, може поступити другачије.`,
    en: `I wanted to just leave a rating, but I got a strange comment from the clinic saying I made a mistake leaving a review about some hotel. Since you're asking, let me explain. A year ago, after reading reviews about what a great doctor Konstantin is, I chose Just Dental clinic. Konstantin did a cleaning and treated one tooth. After my gums returned to normal, I noticed a white fragment in the gum and wrote to Konstantin about it. After examining it, he tried to remove it with tweezers, then took an X-ray and shocked me with his verdict that "it's my bone sticking out." When I asked "what should I do?" he said he didn't know and that a narrow specialist was needed. With a heavy feeling that I had some terrible situation, I left Montenegro. And only after 8 months I gathered the courage and went to a dentist in another country for a routine checkup. It turned out to be a baby tooth, which was removed in a few minutes without anesthesia. Apparently Konstantin hadn't encountered a baby tooth in an adult, but his reaction when something went wrong was strange — he simply distanced himself immediately. Usually a clinic gives you a document about the service provided, he gave me nothing, which reinforced my thought that something was wrong with me. I understand that in Montenegro it's hard to find a doctor at all, but keep in mind that if everything goes well, Konstantin is great, but if something goes wrong, he may act differently.`,
    de: `Ich wollte mich auf eine Bewertung beschränken, aber ich bekam einen seltsamen Kommentar von der Klinik, ich hätte mich geirrt und eine Bewertung über ein Hotel geschrieben. Da Sie fragen, erkläre ich es. Vor einem Jahr, nachdem ich die Bewertungen gelesen hatte, wie gut Dr. Konstantin ist, wählte ich die Just Dental Klinik. Konstantin machte eine Reinigung und behandelte einen Zahn. Nachdem das Zahnfleisch sich normalisiert hatte, bemerkte ich ein weißes Fragment im Zahnfleisch und schrieb Konstantin darüber. Nach der Untersuchung versuchte er es mit einer Pinzette zu entfernen, machte dann eine Aufnahme und schockierte mich mit seiner Diagnose, dass „mein Knochen herausragt". Auf die Frage „was soll ich tun?" antwortete er, er wisse es nicht und ein Facharzt sei nötig. Mit dem schweren Gefühl, eine schlimme Situation zu haben, verließ ich Montenegro. Erst nach 8 Monaten fasste ich Mut und ging in einem anderen Land zur Routineuntersuchung zum Zahnarzt. Es stellte sich heraus, dass es ein Milchzahn war, der in wenigen Minuten ohne Betäubung entfernt wurde. Offenbar war Konstantin noch nie einem Milchzahn bei einem Erwachsenen begegnet, aber seine Reaktion, als etwas schiefging, war seltsam — er distanzierte sich sofort. Normalerweise bekommt man in einer Klinik ein Dokument über die erbrachte Leistung, er gab mir nichts, was mich in dem Gedanken bestärkte, dass etwas Schlimmes vorliegt. Ich verstehe, dass es in Montenegro generell schwer ist, einen Arzt zu finden, aber bedenken Sie: wenn alles gut läuft, ist Konstantin großartig, aber wenn etwas schiefgeht, kann er sich anders verhalten.`,
    tr: `Sadece puanla yetinmek istemiştim ama klinikten garip bir yorum geldi, bir otel hakkında yanlışlıkla yorum bıraktığımı söylüyorlardı. Madem soruyorsunuz, açıklayayım. Bir yıl önce Konstantin'in ne kadar iyi bir doktor olduğuna dair yorumları okuyarak Just Dental kliniğini seçtim. Konstantin temizlik yaptı ve bir dişi tedavi etti. Diş etlerim normale döndükten sonra diş etinde beyaz bir parça fark ettim, Konstantin'e yazdım. Muayene ettikten sonra cımbızla çıkarmaya çalıştı, sonra röntgen çekti ve "kemiğim çıkıyor" teşhisiyle beni şok etti. "Ne yapmalıyım?" diye sorduğumda bilmediğini ve dar alan uzmanı gerektiğini söyledi. Korkunç bir durumum olduğu hissiyle Karadağ'dan ayrıldım. Ancak 8 ay sonra cesaretimi toplayıp başka bir ülkede rutin kontrol için diş hekimine gittim. Süt dişi olduğu ortaya çıktı, birkaç dakikada anestezisiz çıkardılar. Görünüşe göre Konstantin yetişkinde süt dişiyle karşılaşmamıştı, ama bir şeyler ters gittiğinde tepkisi garip oldu, o anda mesafelendi. Genellikle kliniklerde yapılan hizmetle ilgili belge verirler, o bana hiçbir şey vermedi ve bu bende kötü bir şey olduğu düşüncesini güçlendirdi. Karadağ'da doktor bulmanın zor olduğunu anlıyorum, ama şunu bilin: her şey yolunda giderse Konstantin harika, ama bir şeyler ters giderse farklı davranabilir.`,
  },

  // 9. Roman Shelagurov — en original
  'Ci9DQUlRQUNvZENodHljRjlvT2toUExVVklOVVpLUmxSWGNUUXlaM1JzTlU5bk1FRRAB': {
    ru: `Спасибо, доктор Константин. Вы сделали мой день ;)`,
    sr: `Hvala, doktore Konstantine. Ulepšali ste mi dan ;)`,
    sr_cyrl: `Хвала, докторе Константине. Улепшали сте ми дан ;)`,
    en: null,
    de: `Danke, Dr. Konstantin. Sie haben meinen Tag verschönert ;)`,
    tr: `Teşekkürler, Dr. Konstantin. Günümü güzelleştirdiniz ;)`,
  },

  // 10. Ed Radcliffe — en original
  'Ci9DQUlRQUNvZENodHljRjlvT2s5YU9HRk9TRkIwUjBKeVgyZEhaazVMUlUxMFFrRRAB': {
    ru: `Приехав из Великобритании, я посетил Викторию для чистки и полировки. Впечатления очень хорошие. Она была внимательна, профессиональна и выполнила свою работу превосходно. Очень рекомендую.`,
    sr: `Došavši iz Velike Britanije, posetio sam Viktoriju za čišćenje i poliranje. Bilo je veoma dobro iskustvo. Bila je pažljiva, profesionalna i odlično obavila posao. Toplo preporučujem.`,
    sr_cyrl: `Дошавши из Велике Британије, посетио сам Викторију за чишћење и полирање. Било је веома добро искуство. Била је пажљива, професионална и одлично обавила посао. Топло препоручујем.`,
    en: null,
    de: `Als Besucher aus Großbritannien ging ich zu Viktoria für eine Reinigung und Politur. Es war eine sehr gute Erfahrung. Sie war sorgfältig, professionell und hat ausgezeichnete Arbeit geleistet. Sehr empfehlenswert.`,
    tr: `İngiltere'den ziyarete gelerek Viktoriya'ya temizlik ve cilalama için gittim. Çok iyi bir deneyimdi. Dikkatli, profesyoneldi ve mükemmel iş çıkardı. Kesinlikle tavsiye ederim.`,
  },

  // 11. Yuliia Popova — extended
  'Ci9DQUlRQUNvZENodHljRjlvT2poNWRXNVdXWGxXWlRJNFlsSjNhbEJWUTNoUFZYYxAB': {
    sr: `Kako je dobro kad imaš dobrog stomatologa! Duplo je dobro kad se taj stomatolog dopada tvom detetu :) Već drugi put smo kod Viktorije, a sada ne vodimo samo dete, nego i sami idemo 🤗\nDivna doktorka Viktorija lako je našla zajednički jezik sa sinom, sa njom mu nije strašno, a to je veoma važno!`,
    sr_cyrl: `Како је добро кад имаш доброг стоматолога! Дупло је добро кад се тај стоматолог допада твом детету :) Већ други пут смо код Викторије, а сада не водимо само дете, него и сами идемо 🤗\nДивна докторка Викторија лако је нашла заједнички језик са сином, са њом му није страшно, а то је веома важно!`,
    en: `How great it is when you have a good dentist! It's doubly great when your child likes that dentist :) This is our second time with Viktoria, and now we don't just bring the kid, but go ourselves too 🤗\nWonderful Dr. Viktoria easily found common ground with our son, he's not scared with her, and that's very important!`,
    de: `Wie schön ist es, wenn man einen guten Zahnarzt hat! Doppelt schön, wenn dieser Zahnarzt auch deinem Kind gefällt :) Zum zweiten Mal schon bei Viktoria, und jetzt bringen wir nicht nur das Kind, sondern gehen auch selbst hin 🤗\nDie wunderbare Ärztin Viktoria fand leicht eine gemeinsame Sprache mit unserem Sohn, bei ihr hat er keine Angst, und das ist sehr wichtig!`,
    tr: `İyi bir diş hekimin olması ne güzel! Çocuğunun da o diş hekimini sevmesi iki kat güzel :) Viktoriya'ya ikinci kez geliyoruz, artık sadece çocuğu getirmiyoruz, kendimiz de gidiyoruz 🤗\nHarika Dr. Viktoriya oğlumuzla kolayca ortak dil buldu, onunla korkmuyor ve bu çok önemli!`,
  },

  // 12. Виктория Смирнова — extended
  'Ci9DQUlRQUNvZENodHljRjlvT21aaE9YY3lUWFp1TmxWSmVEVXpPREoxUzA5aVZYYxAB': {
    sr: `Želim da se zahvalim divnom doktoru Konstantinu Aleksejeviču!\nObratila sam se sa složenim, višestruko lečenim zubom i već nisam računala da ću rešiti ovaj problem u Crnoj Gori. Doktor je visokokvalifikovan, pažljiv i odgovoran. Zub posle lečenja izgleda kao rođeni, potpuno prirodno. Pre toga su mi lekari govorili da je nemoguće obnoviti boju zuba i da će situaciju ispraviti samo krunica.\nVeoma sam srećna što sam izabrala upravo ovu stomatologiju. Klinika je pogodno smeštena, osoblje je ljubazno. Preporučujem!`,
    sr_cyrl: `Желим да се захвалим дивном доктору Константину Алексејевичу!\nОбратила сам се са сложеним, вишеструко леченим зубом и већ нисам рачунала да ћу решити овај проблем у Црној Гори. Доктор је висококвалификован, пажљив и одговоран. Зуб после лечења изгледа као рођени, потпуно природно. Пре тога су ми лекари говорили да је немогуће обновити боју зуба и да ће ситуацију исправити само круница.\nВеома сам срећна што сам изабрала управо ову стоматологију. Клиника је погодно смештена, особље је љубазно. Препоручујем!`,
    en: `I want to thank the wonderful Dr. Konstantin Alekseevich!\nI came with a complex, repeatedly treated tooth and didn't expect to solve this problem in Montenegro. The doctor is highly qualified, attentive, and responsible. The tooth after treatment looks like a natural one, absolutely realistic. Before this, doctors told me it was impossible to restore the tooth color and only a crown could fix the situation.\nI'm very glad I chose this particular dental clinic. The clinic is conveniently located, the staff is friendly. Highly recommend!`,
    de: `Ich möchte dem wunderbaren Dr. Konstantin Aleksejewitsch danken!\nIch kam mit einem komplizierten, mehrfach behandelten Zahn und hatte nicht erwartet, dieses Problem in Montenegro lösen zu können. Der Arzt ist hochqualifiziert, aufmerksam und verantwortungsbewusst. Der Zahn sieht nach der Behandlung aus wie ein natürlicher, absolut naturgetreu. Zuvor sagten mir Ärzte, es sei unmöglich, die Zahnfarbe wiederherzustellen, und nur eine Krone könne die Situation verbessern.\nIch bin sehr froh, dass ich genau diese Zahnklinik gewählt habe. Die Klinik ist günstig gelegen, das Personal ist freundlich. Empfehle ich!`,
    tr: `Harika Dr. Konstantin Alekseyeviç'e teşekkür etmek istiyorum!\nKarmaşık, defalarca tedavi edilmiş bir dişle geldim ve bu sorunu Karadağ'da çözebileceğimi beklemiyordum. Doktor yüksek nitelikli, özenli ve sorumluluk sahibi. Tedaviden sonra diş doğal gibi görünüyor, tamamen gerçekçi. Öncesinde doktorlar bana diş rengini geri kazandırmanın imkansız olduğunu ve durumu ancak bir kronun düzeltebileceğini söylemişlerdi.\nTam da bu kliniği seçtiğim için çok mutluyum. Klinik uygun konumda, personel güler yüzlü. Tavsiye ederim!`,
  },

  // 13. Michael McAllister — en original, full text
  'Ci9DQUlRQUNvZENodHljRjlvT21sTExURmlPRXd0UkhBd1ZtOXRlVXAyU1RrM1ZVRRAB': {
    ru: `Я приехал в JUST, находясь в Черногории, чтобы заменить коронку. Клиника оказалась очень дружелюбной, профессиональной и по разумным ценам. Доктор Константин — очень опытный стоматолог с множеством сертификатов, которые заметно выставлены на обозрение. Новая коронка сидит идеально, и процесс был очень профессиональным. Без боли и очень точно — как родной зуб. Через пару недель я вернулся на чистку, и обслуживание было таким же отличным и дружелюбным. Очень рекомендую.`,
    sr: `Došao sam u JUST dok sam bio u Crnoj Gori da zamenim krunicu i klinika je bila veoma prijateljska, profesionalna i sa razumnim cenama. Dr. Konstantin je veoma vešt stomatolog sa mnogo sertifikata koji su istaknuto izloženi. Nova krunica savršeno stoji i proces je bio veoma stručan. Bez bola i veoma precizno, kao pravi zub. Vratio sam se na čišćenje par nedelja kasnije i usluga je bila isto tako odlična i prijatna. Toplo preporučujem.`,
    sr_cyrl: `Дошао сам у JUST док сам био у Црној Гори да заменим круницу и клиника је била веома пријатељска, професионална и са разумним ценама. Др. Константин је веома вешт стоматолог са много сертификата који су истакнуто изложени. Нова круница савршено стоји и процес је био веома стручан. Без бола и веома прецизно, као прави зуб. Вратио сам се на чишћење пар недеља касније и услуга је била исто тако одлична и пријатна. Топло препоручујем.`,
    en: null,
    de: `Ich kam zu JUST, während ich in Montenegro war, um eine Krone zu ersetzen, und die Klinik war sehr freundlich, professionell und preislich angemessen. Dr. Konstantin ist ein sehr erfahrener Zahnarzt mit vielen Zertifikaten, die gut sichtbar ausgestellt sind. Die neue Krone sitzt perfekt und der Prozess war sehr professionell. Schmerzfrei und sehr präzise — wie der originale Zahn. Ich kam ein paar Wochen später zur Reinigung zurück und der Service war genauso ausgezeichnet und freundlich. Sehr empfehlenswert.`,
    tr: `Karadağ'dayken bir kronu değiştirmek için JUST'a geldim ve klinik çok arkadaş canlısı, profesyonel ve makul fiyatlıydı. Dr. Konstantin birçok sertifikaya sahip çok yetenekli bir diş hekimi, sertifikalar belirgin şekilde sergileniyor. Yeni kron mükemmel oturuyor ve süreç çok profesyoneldi. Ağrı yok ve çok hassas — orijinal diş gibi. Birkaç hafta sonra temizlik için geri döndüm ve aynı mükemmel, güler yüzlü hizmeti aldım. Kesinlikle tavsiye ederim.`,
  },

  // 14. Анастасия Пукальчук — minor formatting changes, keep existing translations
  'Ci9DQUlRQUNvZENodHljRjlvT2s5dWEyNDBlbTA1UTNSMVFuUTVPSFZWY0dGaVMzYxAB': {
    _skipTranslations: true, // only update original_text
  },

  // 15. Сергій Оївчик — uk original
  'Ci9DQUlRQUNvZENodHljRjlvT25wdlYxbDBUWEYzVFV0VE9WVkNiamRsV2paU01uYxAB': {
    ru: `Сегодня удалял зуб в этой стоматологии. Что можно сказать — очень быстро и не больно. Современная клиника, опытный врач. Спасибо.`,
    sr: `Danas sam vadio zub u ovoj stomatologiji. Šta mogu da kažem — veoma brzo i bez bola. Moderna klinika, iskusan lekar. Hvala.`,
    sr_cyrl: `Данас сам вадио зуб у овој стоматологији. Шта могу да кажем — веома брзо и без бола. Модерна клиника, искусан лекар. Хвала.`,
    en: `Today I had a tooth extracted at this dental clinic. What can I say — very fast and painless. Modern clinic, experienced doctor. Thank you.`,
    de: `Heute habe ich mir in dieser Zahnarztpraxis einen Zahn ziehen lassen. Was kann ich sagen — sehr schnell und schmerzlos. Moderne Klinik, erfahrener Arzt. Danke.`,
    tr: `Bugün bu diş kliniğinde diş çektirdim. Ne diyebilirim — çok hızlı ve ağrısız. Modern klinik, deneyimli doktor. Teşekkürler.`,
  },

  // 16. Miljan Dasic — en original, full numbered list
  'ChdDSUhNMG9nS0VLdnAxZU9Uc2NIc3pBRRAB': {
    ru: `Сегодня мне представилась возможность увидеть и ощутить стоматологическое вмешательство совершенно с другой стороны. Конечно, как пациенту, который совершенно не любит время, проведённое у стоматолога.\n1. Никакой боли во время всего процесса.\n2. 100% сосредоточенность врача на протяжении всего времени. Постоянная проверка комфортности.\n3. Умелые и исключительно быстрые действия на каждом этапе.\n4. Всё новейшее оборудование, необходимое для успешного вмешательства, в одном месте.\n5. Гигиена на высшем уровне, задающая стандарты для других!\nГород Бар должен быть благодарен, что такой специалист живёт здесь.\nМне жаль, что 5 звёзд — это максимально возможная оценка.\nСпасибо!`,
    sr: `Danas sam imao priliku da vidim i doživim stomatološku intervenciju iz potpuno drugog ugla. Naravno, kao pacijent koji uopšte ne voli vreme provedeno kod stomatologa.\n1. Nikakav bol tokom celog procesa.\n2. 100% fokus stomatologa sve vreme. Stalna provera udobnosti.\n3. Vešti i izuzetno brzi potezi na svakom koraku.\n4. Sva najnovija oprema potrebna za uspešnu intervenciju na jednom mestu.\n5. Higijena na najvišem nivou koja postavlja standarde drugima!\nGrad Bar treba da bude zahvalan što takav stručnjak živi tamo.\nŽao mi je što je 5 zvezdica najviša moguća ocena.\nHvala!`,
    sr_cyrl: `Данас сам имао прилику да видим и доживим стоматолошку интервенцију из потпуно другог угла. Наравно, као пацијент који уопште не воли време проведено код стоматолога.\n1. Никакав бол током целог процеса.\n2. 100% фокус стоматолога све време. Стална провера удобности.\n3. Вешти и изузетно брзи потези на сваком кораку.\n4. Сва најновија опрема потребна за успешну интервенцију на једном месту.\n5. Хигијена на највишем нивоу која поставља стандарде другима!\nГрад Бар треба да буде захвалан што такав стручњак живи тамо.\nЖао ми је што је 5 звездица највиша могућа оцена.\nХвала!`,
    en: null,
    de: `Heute hatte ich die Gelegenheit, einen zahnärztlichen Eingriff aus einem völlig anderen Blickwinkel zu sehen und zu erleben. Natürlich als Patient, der die Zeit beim Zahnarzt überhaupt nicht mag.\n1. Kein Schmerz während des gesamten Prozesses.\n2. 100% Fokus des Zahnarztes die ganze Zeit. Ständige Überprüfung des Komforts.\n3. Geschickte und außergewöhnlich schnelle Bewegungen bei jedem Schritt.\n4. Die gesamte neueste Ausrüstung für einen erfolgreichen Eingriff an einem Ort.\n5. Hygiene auf höchstem Niveau, die Standards für andere setzt!\nDie Stadt Bar sollte dankbar sein, dass ein solcher Experte dort lebt.\nEs tut mir leid, dass 5 Sterne die höchstmögliche Bewertung ist.\nDanke!`,
    tr: `Bugün bir diş müdahalesini tamamen farklı bir açıdan görme ve deneyimleme fırsatım oldu. Tabii ki, diş hekiminde geçirilen zamanı hiç sevmeyen bir hasta olarak.\n1. Tüm süreç boyunca hiç ağrı yok.\n2. Diş hekiminin %100 odaklanması sürekli. Sürekli konfor kontrolü.\n3. Her adımda becerikli ve olağanüstü hızlı hareketler.\n4. Başarılı bir müdahale için gereken en yeni ekipmanların tamamı tek yerde.\n5. Başkalarına standart belirleyen en üst düzey hijyen!\nBar şehri böyle bir uzmanın orada yaşamasından minnettar olmalı.\n5 yıldızın mümkün olan en yüksek puan olmasına üzülüyorum.\nTeşekkürler!`,
  },

  // 17. Julia Suchkova — extended
  'ChZDSUhNMG9nS0VJQ0FnTUNndzZ2c1JnEAE': {
    sr: `Ogromno hvala Konstantinu i Tatjani za profesionalizam, ljudskost, pažljivost i individualni pristup zahtevnim pacijentima. Ja, kao osoba sa dentofobijom, ludim skokovima pritiska i paničnim napadima u stomatološkim ordinacijama, mogu sa sigurnošću da tvrdim — oni su profesionalci i pomoći će! Prvi put u životu, završivši lečenje, tražim zakazivanje za sledeći pregled. Ogromno HVALA`,
    sr_cyrl: `Огромно хвала Константину и Татјани за професионализам, људскост, пажљивост и индивидуални приступ захтевним пацијентима. Ја, као особа са дентофобијом, лудим скоковима притиска и паничним нападима у стоматолошким ординацијама, могу са сигурношћу да тврдим — они су професионалци и помоћи ће! Први пут у животу, завршивши лечење, тражим заказивање за следећи преглед. Огромно ХВАЛА`,
    en: `Huge thanks to Konstantin and Tatyana for their professionalism, humanity, sensitivity, and individual approach to difficult patients. As someone with dentophobia, wild blood pressure spikes, and panic attacks in dental offices, I can say with certainty — they are professionals and they will help! For the first time in my life, after finishing treatment, I'm asking for an appointment for the next visit. A huge THANK YOU`,
    de: `Riesiges Dankeschön an Konstantin und Tatjana für ihre Professionalität, Menschlichkeit, Einfühlsamkeit und den individuellen Umgang mit schwierigen Patienten. Ich, als Mensch mit Dentophobie, extremen Blutdruckschwankungen und Panikattacken in Zahnarztpraxen, kann mit Sicherheit sagen — sie sind Profis und sie helfen! Zum ersten Mal in meinem Leben bitte ich nach Abschluss der Behandlung um einen Termin für den nächsten Besuch. Ein riesiges DANKE`,
    tr: `Konstantin ve Tatyana'ya profesyonellikleri, insanlıkları, duyarlılıkları ve zor hastalara bireysel yaklaşımları için çok teşekkürler. Diş hekimi fobisi, şiddetli tansiyon dalgalanmaları ve diş muayenehanelerinde panik atak yaşayan biri olarak kesinlikle söyleyebilirim — onlar profesyonel ve yardımcı olacaklar! Hayatımda ilk kez tedaviyi bitirdikten sonra bir sonraki randevuyu istiyorum. Kocaman TEŞEKKÜRLER`,
  },

  // 18. Kristina — extended with parking
  'ChZDSUhNMG9nS0VJQ0FnTUNBaHNHeUR3EAE': {
    sr: `Radila sam čišćenje! Prosto super 🙌 Toliko je sve kvalitetno, pažljivo, profesionalno. Najlepši doktor! Oduševljenje 😌👌\nVeoma preporučujem!!\nAko se odvezete malo dalje, ima veliki besplatan parking.`,
    sr_cyrl: `Радила сам чишћење! Просто супер 🙌 Толико је све квалитетно, пажљиво, професионално. Најлепши доктор! Одушевљење 😌👌\nВеома препоручујем!!\nАко се одвезете мало даље, има велики бесплатан паркинг.`,
    en: `I had a cleaning done! Simply superb 🙌 Everything was so high-quality, careful, professional. The nicest doctor! Delighted 😌👌\nHighly recommend!!\nIf you drive a bit further, there's a large free parking lot.`,
    de: `Ich habe eine Zahnreinigung machen lassen! Einfach super 🙌 Alles so qualitativ hochwertig, sorgfältig, professionell. Ein äußerst angenehmer Arzt! Begeisterung 😌👌\nSehr zu empfehlen!!\nWenn man ein Stück weiterfährt, gibt es einen großen kostenlosen Parkplatz.`,
    tr: `Diş temizliği yaptırdım! Resmen süper 🙌 Her şey çok kaliteli, özenli, profesyonel. Çok hoş bir doktor! Hayran kaldım 😌👌\nKesinlikle tavsiye ederim!!\nBiraz daha ileriye giderseniz büyük ücretsiz bir otopark var.`,
  },

  // 19. Dmitriy Shestakov — extended
  'ChZDSUhNMG9nS0VJQ0FnTUNBeXE3TkVREAE': {
    sr: `Odličan lekar!\nDošao sam sa jakim bolom, ali je sve zakazano dve nedelje unapred, hvala što ste našli rešenje!\nLečenje je odlično, bez suvišnih reči i sve konkretno!`,
    sr_cyrl: `Одличан лекар!\nДошао сам са јаким болом, али је све заказано две недеље унапред, хвала што сте нашли решење!\nЛечење је одлично, без сувишних речи и све конкретно!`,
    en: `Excellent doctor!\nI came in with severe pain, but everything was booked two weeks ahead, thank you for finding a solution!\nThe treatment is excellent, no unnecessary words and everything to the point!`,
    de: `Ausgezeichneter Arzt!\nIch kam mit starken Schmerzen, aber alles war zwei Wochen im Voraus ausgebucht, danke, dass Sie eine Lösung gefunden haben!\nDie Behandlung ist ausgezeichnet, ohne überflüssige Worte und alles auf den Punkt!`,
    tr: `Mükemmel doktor!\nŞiddetli ağrıyla geldim ama her şey iki hafta öncesine kadar doluydu, bir çözüm bulduğunuz için teşekkürler!\nTedavi mükemmel, gereksiz söz yok ve her şey somut!`,
  },

  // 20. Татьяна — significantly extended
  'ChdDSUhNMG9nS0VJQ0FnSUR2MXNheDBBRRAB': {
    sr: `Stomatolog koga želite da preporučite prijateljima :)\n\nVeoma korektan, ljubazan, pažljiv u radu. Sa razumevanjem se odnosi prema anksioznim pacijentima — objašnjava sve što radi, daje pauze po potrebi, pažljiv je prema samopočuvstviju.\n\nKod Konstantina sam radila nekoliko plombi i lečila zapušten karijes — nikakvih primedbi, posle dužeg vremena sve je odlično.\n\nU ordinaciji postoji rendgen. Sam prostor klinike je prostran svetao kabinet, ima hol i toalet. Nedaleko od klinike uvek ima mesta za besplatan parking.`,
    sr_cyrl: `Стоматолог кога желите да препоручите пријатељима :)\n\nВеома коректан, љубазан, пажљив у раду. Са разумевањем се односи према анксиозним пацијентима — објашњава све што ради, даје паузе по потреби, пажљив је према самопочувствију.\n\nКод Константина сам радила неколико пломби и лечила запуштен каријес — никаквих примедби, после дужег времена све је одлично.\n\nУ ординацији постоји рендген. Сам простор клинике је простран светао кабинет, има хол и тоалет. Недалеко од клинике увек има места за бесплатан паркинг.`,
    en: `A dentist you want to recommend to friends :)\n\nVery proper, polite, careful in his work. He treats anxious patients with understanding — explains everything he does, gives breaks when needed, is attentive to how you're feeling.\n\nI had several fillings done and treated advanced cavities with Konstantin — no complaints, after a considerable time everything is excellent.\n\nThe office has an X-ray machine. The clinic itself is a spacious, bright office with a lobby and a restroom. There's always free parking available near the clinic.`,
    de: `Ein Zahnarzt, den man Freunden empfehlen möchte :)\n\nSehr korrekt, höflich, sorgfältig bei der Arbeit. Er geht verständnisvoll mit ängstlichen Patienten um — erklärt alles, was er tut, macht bei Bedarf Pausen, achtet auf das Befinden.\n\nBei Konstantin habe ich mehrere Füllungen machen und fortgeschrittene Karies behandeln lassen — keine Beanstandungen, nach längerer Zeit ist alles ausgezeichnet.\n\nIn der Praxis gibt es ein Röntgengerät. Die Klinik selbst ist ein geräumiges, helles Büro mit Empfangsbereich und Toilette. In der Nähe der Klinik gibt es immer kostenlose Parkplätze.`,
    tr: `Arkadaşlarınıza tavsiye etmek isteyeceğiniz bir diş hekimi :)\n\nÇok düzgün, nazik, işinde özenli. Kaygılı hastalara anlayışla yaklaşıyor — yaptığı her şeyi açıklıyor, gerektiğinde ara veriyor, nasıl hissettiğinize dikkat ediyor.\n\nKonstantin'de birkaç dolgu yaptırdım ve ilerlemiş çürükleri tedavi ettirdim — hiçbir şikayet yok, uzun süre sonra bile her şey mükemmel.\n\nMuayenehanede röntgen cihazı var. Klinik alanı geniş, aydınlık bir oda, lobisi ve tuvaleti var. Kliniğin yakınında her zaman ücretsiz park yeri bulunuyor.`,
  },

  // 21. Elena Steblyanko — significantly extended
  'ChZDSUhNMG9nS0VJQ0FnSURuMXNUWFZBEAE': {
    sr: `Svesrdno preporučujem usluge Konstantina.\nDa ispričam, znači. Išla sam na čišćenje zuba.\nSve precizno, brzo, kvalitetno.\nKabinet je moderan, uredan. Ima kutak za decu.\nRedak slučaj kad se mislilo na klijente sa potomstvom.\nNaravno, posebno je dragoceno što uz visoku kvalifikaciju, profesionalizam i kvalitet usluga ide i mogućnost komunikacije na maternjem jeziku bez naprezanja.\nVeoma sam impresionirana trudom i posvećenošću Konstantina. Tako organizovati svoju profesionalnu delatnost u imigraciji — to je visoka klasa.`,
    sr_cyrl: `Свесрдно препоручујем услуге Константина.\nДа испричам, значи. Ишла сам на чишћење зуба.\nСве прецизно, брзо, квалитетно.\nКабинет је модеран, уредан. Има кутак за децу.\nРедак случај кад се мислило на клијенте са потомством.\nНаравно, посебно је драгоцено што уз високу квалификацију, професионализам и квалитет услуга иде и могућност комуникације на матерњем језику без напрезања.\nВеома сам импресионирана трудом и посвећеношћу Константина. Тако организовати своју професионалну делатност у имиграцији — то је висока класа.`,
    en: `I wholeheartedly recommend Konstantin's services.\nSo let me tell you. I went for a teeth cleaning.\nEverything was precise, fast, high-quality.\nThe office is modern, neat. There's a children's corner.\nA rare case where they thought about clients with kids.\nOf course, it's especially valuable that along with high qualifications, professionalism, and quality of services comes the ability to communicate in your native language without strain.\nI'm very impressed by Konstantin's hard work and dedication. To organize your professional activity like this in immigration is truly top class.`,
    de: `Ich empfehle Konstantins Dienste aufs Wärmste.\nAlso, ich erzähle mal. Ich war zur Zahnreinigung.\nAlles präzise, schnell, qualitativ hochwertig.\nDie Praxis ist modern, ordentlich. Es gibt eine Kinderecke.\nEin seltener Fall, dass an Kunden mit Nachwuchs gedacht wurde.\nNatürlich ist es besonders wertvoll, dass neben hoher Qualifikation, Professionalität und Servicequalität auch die Möglichkeit besteht, sich in der Muttersprache zu verständigen.\nIch bin sehr beeindruckt von Konstantins Fleiß und Zielstrebigkeit. Seine berufliche Tätigkeit so in der Emigration zu organisieren — das ist höchste Klasse.`,
    tr: `Konstantin'in hizmetlerini hararetle tavsiye ederim.\nAnlatayım. Diş temizliğine gittim.\nHer şey düzgün, hızlı, kaliteli.\nMuayenehane modern, düzenli. Çocuk köşesi var.\nÇocuklu müşteriler düşünülmüş, nadir bir durum.\nTabii ki özellikle değerli olan, yüksek nitelik, profesyonellik ve hizmet kalitesinin yanında ana dilde rahatça iletişim kurabilme imkanı.\nKonstantin'in çalışkanlığı ve kararlılığından çok etkilendim. Göçte profesyonel faaliyetini böyle organize etmek — gerçekten üst düzey.`,
  },

  // 22. Владислав Жельнио — extended
  'ChZDSUhNMG9nS0VJQ0FnSUQ5aDZ5bEJnEAE': {
    sr: `Ostao sam pod utiskom. Jer posle pola godine avantura ovo je pravo svetlo na kraju stomatologije) Sve je sjajno od servisa, čistoće, profesionalizma do jednostavno ljudskog odnosa.\nOstao sam zadovoljan i ovo je jedan od onih kontakata u telefonskom imeniku koji se ne smeju izgubiti.\nKonstantine, Tatjana, hvala vam što postojite!`,
    sr_cyrl: `Остао сам под утиском. Јер после пола године авантура ово је право светло на крају стоматологије) Све је сјајно од сервиса, чистоће, професионализма до једноставно људског односа.\nОстао сам задовољан и ово је један од оних контаката у телефонском именику који се не смеју изгубити.\nКонстантине, Татјана, хвала вам што постојите!`,
    en: `I was impressed. Because after half a year of adventures, this is literally a light at the end of dentistry) Everything is wonderful — from the service, cleanliness, professionalism to simply the human attitude.\nI was satisfied and this is one of those contacts in the phone book that you can't afford to lose.\nKonstantin, Tatyana, thank you for being there!`,
    de: `Ich war beeindruckt. Denn nach einem halben Jahr voller Abenteuer ist das wirklich ein Licht am Ende der Zahnmedizin) Alles ist wunderbar — vom Service, der Sauberkeit, der Professionalität bis hin zur einfach menschlichen Einstellung.\nIch war zufrieden und das ist einer dieser Kontakte im Telefonbuch, die man nicht verlieren darf.\nKonstantin, Tatjana, danke, dass es euch gibt!`,
    tr: `Çok etkilendim. Çünkü yarım yıllık maceralardan sonra bu gerçekten diş hekimliğinin sonundaki ışık) Hizmetten temizliğe, profesyonellikten insani yaklaşıma kadar her şey harika.\nMemnun kaldım ve bu telefon rehberinde kaybedilmemesi gereken kişilerden biri.\nKonstantin, Tatyana, var olduğunuz için teşekkürler!`,
  },

  // 23. Alex Vas — en original
  'ChZDSUhNMG9nS0VJQ0FnSUNkc0t2V2FnEAE': {
    ru: `Очень рекомендую этого врача. Более 20 лет опыта, качественные материалы, современное оборудование и высокие стандарты лечения. Безболезненно и дружелюбно.`,
    sr: `Toplo preporučujem ovog lekara. Više od 20 godina iskustva, kvalitetni materijali, savremena oprema i visoki standardi lečenja. Bezbolno i prijateljski.`,
    sr_cyrl: `Топло препоручујем овог лекара. Више од 20 година искуства, квалитетни материјали, савремена опрема и високи стандарди лечења. Безболно и пријатељски.`,
    en: null,
    de: `Ich empfehle diesen Arzt sehr. Über 20 Jahre Erfahrung, hochwertige Materialien, moderne Ausstattung und hohe Behandlungsstandards. Schmerzfrei und freundlich.`,
    tr: `Bu doktoru kesinlikle tavsiye ederim. 20 yılı aşkın deneyim, kaliteli malzemeler, modern ekipman ve yüksek tedavi standartları. Ağrısız ve samimi.`,
  },

  // 24. Леся Близнюк — extended
  'ChZDSUhNMG9nS0VJQ0FnSUN0d05MY013EAE': {
    sr: `Sve se popravilo) pogodan položaj, kvalitetni materijali i dobar rad\novde sam stavljala ne samo plombu, već i složenu operaciju vađenja komplikovanog zuba, sve je prošlo odlično\ntako da svima savetujem da se obrate Konstantinu)`,
    sr_cyrl: `Све се поправило) погодан положај, квалитетни материјали и добар рад\nовде сам стављала не само пломбу, већ и сложену операцију вађења компликованог зуба, све је прошло одлично\nтако да свима саветујем да се обрате Константину)`,
    en: `Everything got better) convenient location, quality materials and good work\nI had not only a filling done here, but also a complex operation to remove a difficult tooth, everything went perfectly\nso I recommend everyone to go to Konstantin)`,
    de: `Alles hat sich verbessert) günstige Lage, hochwertige Materialien und gute Arbeit\nIch habe hier nicht nur eine Füllung machen lassen, sondern auch eine komplizierte Operation zur Entfernung eines schwierigen Zahns, alles lief großartig\nalso empfehle ich allen, sich an Konstantin zu wenden)`,
    tr: `Her şey düzeldi) uygun konum, kaliteli malzemeler ve iyi iş\nburada sadece dolgu değil, zor bir dişin çekimi için karmaşık bir operasyon da yaptırdım, her şey mükemmel geçti\nbu yüzden herkese Konstantin'e gitmelerini tavsiye ederim)`,
  },

  // 25. Игорь Петров — extended
  'ChZDSUhNMG9nS0VJQ0FnSUMxeUxqT1VBEAE': {
    sr: `Danas sam bio na čišćenju. Konstantin je super profesionalac, uradio je sve maksimalno komforno. Doći ću da uklonim karijes.\n\nHvala!!!`,
    sr_cyrl: `Данас сам био на чишћењу. Константин је супер професионалац, урадио је све максимално комфорно. Доћи ћу да уклоним каријес.\n\nХвала!!!`,
    en: `Today I had a cleaning. Konstantin is a super pro, did everything as comfortably as possible. I'll come back to fix a cavity.\n\nThank you!!!`,
    de: `Heute war ich bei der Zahnreinigung. Konstantin ist ein Super-Profi, hat alles maximal komfortabel gemacht. Ich komme wieder, um Karies behandeln zu lassen.\n\nDanke!!!`,
    tr: `Bugün diş temizliğindeydim. Konstantin süper bir profesyonel, her şeyi olabildiğince rahat yaptı. Çürük tedavisi için tekrar geleceğim.\n\nTeşekkürler!!!`,
  },

  // 26. Aleksandr Pristanskii — extended
  'ChZDSUhNMG9nS0VJQ0FnSUROb01IR0R3EAE': {
    sr: `Bili smo sa ćerkom. Veoma iskusan i profesionalan lekar. Odličan kabinet, nova savremena oprema. Ćerka panično se plaši stomatologa, ali pristup Konstantina Aleksejeviča deci zaslužuje divljenje — on nije samo izlečio bolestan zub, već je i oslobodio dete straha od odlaska kod stomatologa! Ćerka je na kraju sama tražila da ide kod njega na lečenje drugog zuba)`,
    sr_cyrl: `Били смо са ћерком. Веома искусан и професионалан лекар. Одличан кабинет, нова савремена опрема. Ћерка панично се плаши стоматолога, али приступ Константина Алексејевича деци заслужује дивљење — он није само излечио болестан зуб, већ је и ослободио дете страха од одласка код стоматолога! Ћерка је на крају сама тражила да иде код њега на лечење другог зуба)`,
    en: `We came with our daughter. A very experienced and professional doctor. Excellent office, new modern equipment. Our daughter has a panicky fear of dentists, but Konstantin Alekseevich's approach to children deserves admiration — he not only treated the aching tooth, but also freed the child from the fear of going to the dentist! In the end, our daughter herself asked to go to him for treatment of a second tooth)`,
    de: `Wir waren mit unserer Tochter da. Ein sehr erfahrener und professioneller Arzt. Hervorragende Praxis, neue moderne Ausstattung. Unsere Tochter hat panische Angst vor Zahnärzten, aber Konstantin Aleksejewitschs Umgang mit Kindern verdient Bewunderung — er hat nicht nur den kranken Zahn behandelt, sondern auch dem Kind die Angst vor dem Zahnarztbesuch genommen! Am Ende bat unsere Tochter selbst darum, zur Behandlung eines zweiten Zahns zu ihm zu gehen)`,
    tr: `Kızımızla birlikte gittik. Çok deneyimli ve profesyonel bir doktor. Mükemmel muayenehane, yeni modern ekipman. Kızımız diş hekimlerinden panik derecede korkuyor, ama Konstantin Alekseyeviç'in çocuklara yaklaşımı hayranlık uyandırıyor — sadece ağrıyan dişi tedavi etmekle kalmadı, çocuğu diş hekimine gitme korkusundan da kurtardı! Sonunda kızımız ikinci dişin tedavisi için kendisi gitmek istedi)`,
  },

  // 27. Grace — en original
  'ChZDSUhNMG9nS0VJQ0FnSUROd0tpc0RREAE': {
    ru: `Качественный сервис, высокий уровень обслуживания. Всё сделали оперативно и быстро. Очень рекомендую`,
    sr: `Kvalitetna usluga, visok nivo usluživanja. Sve su uradili efikasno i brzo. Toplo preporučujem`,
    sr_cyrl: `Квалитетна услуга, висок ниво услуживања. Све су урадили ефикасно и брзо. Топло препоручујем`,
    en: null,
    de: `Hochwertiger Service, hohes Serviceniveau. Alles wurde effizient und schnell erledigt. Sehr empfehlenswert`,
    tr: `Kaliteli hizmet, yüksek düzeyde bakım. Her şey hızlı ve verimli yapıldı. Kesinlikle tavsiye ederim`,
  },

  // 28. SudDenly — en original
  'ChdDSUhNMG9nS0VJQ0FnSUNOdF8yVGl3RRAB': {
    ru: `Лучшая стоматология в моей жизни!`,
    sr: `Najbolja stomatologija u mom životu!`,
    sr_cyrl: `Најбоља стоматологија у мом животу!`,
    en: null,
    de: `Die beste Zahnklinik in meinem Leben!`,
    tr: `Hayatımdaki en iyi diş kliniği!`,
  },

  // 29. Nadezhda Kolesnikova — extended
  'ChZDSUhNMG9nS0VJQ0FnSUNOeGFPX2ZREAE': {
    sr: `Izvanredan tim profesionalaca! Lečili smo se kod Konstantina celom porodicom tokom najmanje dvadeset godina, i uvek sa sjajnim rezultatom! Sigurna sam da nema problema sa kojim se doktor ne bi izborio, i veliki plus je što lečenje uvek ide u pravcu očuvanja sopstvenih zuba. Uvek preporučujemo prijateljima i poznanicima. Želimo sreću i procvat klinici! Nadamo se susretu u budućnosti!`,
    sr_cyrl: `Изванредан тим професионалаца! Лечили смо се код Константина целом породицом током најмање двадесет година, и увек са сјајним резултатом! Сигурна сам да нема проблема са којим се доктор не би изборио, и велики плус је што лечење увек иде у правцу очувања сопствених зуба. Увек препоручујемо пријатељима и познаницима. Желимо срећу и процват клиници! Надамо се сусрету у будућности!`,
    en: `A wonderful team of professionals! Our whole family has been treated by Konstantin for at least twenty years, and always with an excellent result! I'm sure there's no problem the doctor couldn't handle, and a big plus is that treatment is always aimed first and foremost at preserving your own teeth. We always recommend to friends and acquaintances. We wish the clinic good luck and prosperity! We hope to meet again in the future!`,
    de: `Ein wunderbares Team von Profis! Unsere ganze Familie wurde mindestens zwanzig Jahre lang bei Konstantin behandelt, und immer mit hervorragendem Ergebnis! Ich bin sicher, es gibt kein Problem, das der Arzt nicht bewältigen könnte, und ein großer Pluspunkt ist, dass die Behandlung immer in erster Linie auf den Erhalt der eigenen Zähne ausgerichtet ist. Wir empfehlen immer unseren Freunden und Bekannten. Wir wünschen der Klinik viel Glück und Erfolg! Wir hoffen auf ein Wiedersehen in der Zukunft!`,
    tr: `Harika bir profesyoneller ekibi! Tüm ailemiz en az yirmi yıldır Konstantin'de tedavi oluyoruz ve her zaman mükemmel sonuçlarla! Doktorun üstesinden gelemeyeceği bir sorun olmadığından eminim ve büyük bir artı da tedavinin her zaman öncelikle kendi dişlerin korunmasına yönelik olması. Her zaman arkadaşlarımıza ve tanıdıklarımıza tavsiye ediyoruz. Kliniğe başarılar ve gelişme diliyoruz! Gelecekte tekrar görüşmeyi umuyoruz!`,
  },

  // 30. Антон Сторожук — significantly extended
  'ChZDSUhNMG9nS0VJQ0FnSUNOMHY3RlBBEAE': {
    sr: `Nedavno sam u Crnoj Gori i, kad me je "pritisnulo", ruskog stomatologa u Kotoru i okolini nisam našao, pročitao sam čet o lekarima na Telegramu i otišao u Bar, o čemu uopšte ne žalim. Želim da izrazim ogromnu zahvalnost Konstantinu za njegov profesionalizam, razumevanje, smirenost i pristup vađenju zuba. Slučaj nije bio od najjednostavnijih, ali od prvog minuta komunikacije formiralo se maksimalno poverenje u lekara. Nikakav strah, zabrinutost i uznemirenost, anestezija je veoma jaka, doktor sa velikim iskustvom. Ukratko, ogromno hvala Konstantinu i njegovoj divnoj asistentkinji (nažalost, ime nisam zapamtio).`,
    sr_cyrl: `Недавно сам у Црној Гори и, кад ме је "притиснуло", руског стоматолога у Котору и околини нисам нашао, прочитао сам чет о лекарима на Телеграму и отишао у Бар, о чему уопште не жалим. Желим да изразим огромну захвалност Константину за његов професионализам, разумевање, смиреност и приступ вађењу зуба. Случај није био од најједноставнијих, али од првог минута комуникације формирало се максимално поверење у лекара. Никакав страх, забринутост и узнемиреност, анестезија је веома јака, доктор са великим искуством. Укратко, огромно хвала Константину и његовој дивној асистенткињи (нажалост, име нисам запамтио).`,
    en: `I'm new to Montenegro, and when it "hit" me, I couldn't find a Russian-speaking dentist in Kotor and the surrounding area, read a chat about doctors on Telegram and drove to Bar, which I don't regret at all. I want to express my huge gratitude to Konstantin for his professionalism, responsiveness, calmness, and approach to tooth extraction. The case wasn't one of the easiest, but from the very first minute of communication, maximum trust in the doctor was formed. No fear, apprehension, or anxiety, the anesthesia is very powerful, the doctor has extensive experience. In short, huge thanks to Konstantin and his wonderful assistant (unfortunately I didn't remember the name).`,
    de: `Ich bin erst seit Kurzem in Montenegro und als es mich "erwischt" hat, konnte ich in Kotor und Umgebung keinen russischsprachigen Zahnarzt finden, habe einen Chat über Ärzte auf Telegram gelesen und bin nach Bar gefahren, was ich überhaupt nicht bereue. Ich möchte Konstantin meine riesige Dankbarkeit aussprechen für seinen Professionalismus, sein Einfühlungsvermögen, seine Ruhe und seinen Ansatz bei der Zahnextraktion. Der Fall war nicht der einfachste, aber schon in der ersten Minute der Kommunikation entstand maximales Vertrauen in den Arzt. Keine Angst, Besorgnis oder Unruhe, die Betäubung ist sehr stark, der Arzt hat umfangreiche Erfahrung. Kurz gesagt, riesiges Danke an Konstantin und seine wunderbare Assistentin (leider habe ich den Namen nicht behalten).`,
    tr: `Karadağ'da yeniyim ve "bastırınca" Kotor ve çevresinde Rusça konuşan bir diş hekimi bulamadım, Telegram'da doktorlar hakkındaki sohbeti okudum ve Bar'a gittim, hiç pişman değilim. Konstantin'e profesyonelliği, duyarlılığı, sakinliği ve diş çekimine yaklaşımı için büyük minnettarlığımı ifade etmek istiyorum. Vaka en kolaylarından değildi, ama iletişimin ilk dakikasından itibaren doktora maksimum güven oluştu. Korku, endişe ve tedirginlik yok, anestezi çok güçlü, doktor geniş deneyime sahip. Kısacası, Konstantin'e ve harika asistanına (maalesef adını hatırlayamadım) çok teşekkürler.`,
  },

  // 31. Евгения Пыльнева — significantly extended
  'ChZDSUhNMG9nS0VJQ0FnSUQxbzlyc053EAE': {
    sr: `Ne želim da pričam o svom strahu od stomatologa, ovde ima puno takvih recenzija. Želim da ispričam o prijateljskoj atmosferi koja je pratila naš veoma dug prvi susret, slučaj je bio komplikovan i provela sam u stolici više od tri sata. Mnogo sam htela da ispričam u odgovor na vesele priče iz prakse doktora, ali čvrsta gumena maramica mi je smetala da govorim, odvajajući misteriju lečenja od mog lučenja pljuvačke)) Ja sam iskusna pacijentkinja i nesigurnog specijalista prepoznajem u prvim minutima lečenja, ovaj doktor zna i ume, ne popušta pacijentu, nego radi kako treba. Svi moji poznanici su već bili kod Konstantina i preporučuju ga svojim prijateljima. Poseban respekt za odličan vizograf, snimci odmah na monitoru pred pacijentom, prvi put sam to videla`,
    sr_cyrl: `Не желим да причам о свом страху од стоматолога, овде има пуно таквих рецензија. Желим да испричам о пријатељској атмосфери која је пратила наш веома дуг први сусрет, случај је био компликован и провела сам у столици више од три сата. Много сам хтела да испричам у одговор на веселе приче из праксе доктора, али чврста гумена марамица ми је сметала да говорим, одвајајући мистерију лечења од мог лучења пљувачке)) Ја сам искусна пацијенткиња и несигурног специјалисту препознајем у првим минутима лечења, овај доктор зна и уме, не попушта пацијенту, него ради како треба. Сви моји познаници су већ били код Константина и препоручују га својим пријатељима. Посебан респект за одличан визиограф, снимци одмах на монитору пред пацијентом, први пут сам то видела`,
    en: `I don't want to talk about my fear of the dentist — there are plenty of such reviews here. I want to tell about the friendly atmosphere that accompanied our very long first meeting, the case was complex and I spent over three hours in the chair. I wanted to tell a lot in response to the doctor's funny practice stories, but a sturdy rubber dam prevented me from talking, separating the mystery of treatment from my salivation)) I'm an experienced patient and I can spot an uncertain specialist in the first minutes of treatment — this doctor knows his craft, doesn't give in to the patient, but does things the right way. All my acquaintances have already been to Konstantin and recommend him to their friends. Special respect for the excellent visiograph — images appear on the monitor right in front of the patient instantly, I've never seen that before`,
    de: `Ich möchte nicht über meine Angst vor dem Zahnarzt erzählen, davon gibt es hier viele Bewertungen. Ich möchte von der freundschaftlichen Atmosphäre erzählen, die unsere sehr lange erste Begegnung begleitete, der Fall war kompliziert und ich verbrachte über drei Stunden im Stuhl. Ich wollte viel erzählen als Antwort auf die lustigen Geschichten aus der Praxis des Doktors, aber ein festes Gummituch hinderte mich am Sprechen und trennte das Mysterium der Behandlung von meinem Speichelfluss)) Ich bin eine erfahrene Patientin und erkenne einen unsicheren Spezialisten in den ersten Minuten der Behandlung — dieser Arzt weiß und kann, gibt nicht dem Patienten nach, sondern macht es richtig. Alle meine Bekannten waren schon bei Konstantin und empfehlen ihn ihren Freunden. Besonderer Respekt für den tollen Visiographen — Bilder erscheinen sofort auf dem Monitor vor dem Patienten, das habe ich zum ersten Mal gesehen`,
    tr: `Diş hekimi korkumdan bahsetmek istemiyorum, burada böyle yorumlar çok var. Çok uzun ilk görüşmemize eşlik eden dostane atmosferden bahsetmek istiyorum, vaka karmaşıktı ve koltukta üç saatten fazla geçirdim. Doktorun eğlenceli pratik hikayelerine karşılık çok şey anlatmak istedim, ama sağlam bir lastik örtü konuşmamı engelledi, tedavi gizemini tükürük salgımdan ayırarak)) Deneyimli bir hastayım ve güvensiz bir uzmanı tedavinin ilk dakikalarında tanırım — bu doktor bilir ve yapar, hastaya teslim olmaz, doğru olanı yapar. Tüm tanıdıklarım zaten Konstantin'e gitti ve arkadaşlarına tavsiye ediyor. Mükemmel viziyografa özel saygı — görüntüler anında hastanın önündeki monitöre çıkıyor, ilk kez böyle bir şey gördüm`,
  },

  // 32. Kristina Ryndina — en original
  'ChdDSUhNMG9nS0VJQ0FnSUMxLWEzRGpnRRAB': {
    ru: `Отличное лечение и превосходная квалификация! На выходных я очень болезненно сломала зуб, и единственным выходом было удалить остатки. Доктор принял меня уже на следующий день. Вся операция заняла 40 минут, отличная анестезия, без боли, очень стерильно. И шутки ;)`,
    sr: `Odlično lečenje i izvrsna kvalifikacija! Vikendom sam veoma bolno slomila zub i jedini način je bio da se izvade ostaci. Doktor mi je pružio uslugu već sledećeg dana. Cela operacija je trajala 40 minuta, odlična anestezija, bez bola, veoma sterilno. I šale ;)`,
    sr_cyrl: `Одлично лечење и изврсна квалификација! Викендом сам веома болно сломила зуб и једини начин је био да се изваде остаци. Доктор ми је пружио услугу већ следећег дана. Цела операција је трајала 40 минута, одлична анестезија, без бола, веома стерилно. И шале ;)`,
    en: null,
    de: `Ausgezeichnete Behandlung und hervorragende Qualifikation! Am Wochenende habe ich mir sehr schmerzhaft einen Zahn gebrochen, und der einzige Weg war, die Reste zu entfernen. Der Arzt hat mir schon am nächsten Tag geholfen. Die ganze Operation dauerte 40 Minuten, ausgezeichnete Betäubung, schmerzfrei, sehr steril. Und Witze ;)`,
    tr: `Mükemmel tedavi ve üstün yeterlilik! Hafta sonu çok ağrılı bir şekilde dişimi kırdım ve tek yol kalıntılarını çıkarmaktı. Doktor ertesi gün hizmet verdi. Tüm operasyon 40 dakika sürdü, mükemmel anestezi, ağrısız, çok steril. Ve şakalar ;)`,
  },

  // 33. Liuba R — extended
  'ChdDSUhNMG9nS0VJQ0FnSUMxNHRpOWhRRRAB': {
    sr: `Sa Konstantinom Aleksejevičem smo se upoznali još u decembru prošle godine. Imala sam prilično komplikovan slučaj — slomljen prednji zub. Lekar je pomogao konzervativno da se reši problem, tako da nisam ostala sa rupom umesto zuba čekajući implantaciju.\nU jesen sam već išla u novu kliniku na lečenje.\nOptimalan odnos cene i profesionalizma, samim tim i kvaliteta lečenja!\nKlinika je udobna, savremena oprema, prijatna atmosfera.\nPreporučujem!`,
    sr_cyrl: `Са Константином Алексејевичем смо се упознали још у децембру прошле године. Имала сам прилично компликован случај — сломљен предњи зуб. Лекар је помогао конзервативно да се реши проблем, тако да нисам остала са рупом уместо зуба чекајући имплантацију.\nУ јесен сам већ ишла у нову клинику на лечење.\nОптималан однос цене и професионализма, самим тим и квалитета лечења!\nКлиника је удобна, савремена опрема, пријатна атмосфера.\nПрепоручујем!`,
    en: `We first met Konstantin Alekseevich back in December last year. I had a rather complicated case — a broken front tooth. The doctor helped resolve the problem conservatively, so I wasn't left with a gap instead of a tooth while waiting for implantation.\nIn autumn I already went to the new clinic for treatment.\nOptimal price-to-professionalism ratio, and consequently, quality of treatment!\nThe clinic is cozy, modern equipment, pleasant atmosphere.\nRecommend!`,
    de: `Wir haben Konstantin Aleksejewitsch bereits im Dezember letzten Jahres kennengelernt. Ich hatte einen ziemlich komplizierten Fall — einen gebrochenen Frontzahn. Der Arzt half, das Problem konservativ zu lösen, sodass ich nicht mit einer Lücke statt eines Zahns auf die Implantation warten musste.\nIm Herbst ging ich bereits in die neue Klinik zur Behandlung.\nOptimales Preis-Leistungs-Verhältnis in Bezug auf Professionalität und damit auch Behandlungsqualität!\nDie Klinik ist gemütlich, moderne Ausstattung, angenehme Atmosphäre.\nEmpfehle ich!`,
    tr: `Konstantin Alekseyeviç'le geçen yıl Aralık ayında tanıştık. Oldukça karmaşık bir vakam vardı — kırık ön diş. Doktor sorunu konservatif olarak çözmeye yardımcı oldu, böylece implantasyonu beklerken diş yerine boşlukla kalmadım.\nSonbaharda zaten yeni kliniğe tedaviye gittim.\nFiyat ve profesyonellik oranı optimal, dolayısıyla tedavi kalitesi de!\nKlinik rahat, modern ekipman, hoş atmosfer.\nTavsiye ederim!`,
  },

  // 34. Irina Frank — extended
  'ChZDSUhNMG9nS0VJQ0FnSUMxX0lmcFd3EAE': {
    sr: `Ova stomatologija je spas za one koji traže dobrog stomatologa u Crnoj Gori (Baru)\nNakon mnogo neuspešnih poseta u Baru kod drugih stomatologa, bili smo veoma srećni što smo poslušali višestruke preporuke mojih poznanika da posetimo upravo Konstantina 👍🏻\nVeoma kompetentan specijalista u svojoj oblasti i prijatan u komunikaciji 😌`,
    sr_cyrl: `Ова стоматологија је спас за оне који траже доброг стоматолога у Црној Гори (Бару)\nНакон много неуспешних посета у Бару код других стоматолога, били смо веома срећни што смо послушали вишеструке препоруке мојих познаника да посетимо управо Константина 👍🏻\nВеома компетентан специјалиста у својој области и пријатан у комуникацији 😌`,
    en: `This dental clinic is a lifesaver for those looking for a good dentist in Montenegro (Bar)\nAfter many unsuccessful visits to other dentists in Bar, we were very glad we followed the repeated recommendations of my acquaintances to visit specifically Konstantin 👍🏻\nA very competent specialist in his field and pleasant to communicate with 😌`,
    de: `Diese Zahnklinik ist die Rettung für alle, die einen guten Zahnarzt in Montenegro (Bar) suchen\nNach vielen erfolglosen Besuchen bei anderen Zahnärzten in Bar waren wir sehr froh, den wiederholten Empfehlungen meiner Bekannten gefolgt zu sein, genau Konstantin zu besuchen 👍🏻\nEin sehr kompetenter Spezialist auf seinem Gebiet und angenehm im Umgang 😌`,
    tr: `Bu diş kliniği Karadağ'da (Bar) iyi bir diş hekimi arayanlar için kurtarıcı\nBar'da diğer diş hekimlerine yaptığımız birçok başarısız ziyaretten sonra, tanıdıklarımın defalarca tekrarlanan tavsiyelerini dinleyip tam olarak Konstantin'i ziyaret ettiğimize çok sevindik 👍🏻\nAlanında çok yetkin bir uzman ve iletişimi hoş 😌`,
  },

  // 35. Olga Gl — extended
  'ChZDSUhNMG9nS0VJQ0FnSUMxN09QMFBnEAE': {
    sr: `Veoma dobar lekar, na sva pitanja je dao odgovor, ispravio sve probleme koji su se pojavili za vreme života u Crnoj Gori! Samo dobri utisci. U kabinetu je sve čisto i uredno, snimke se mogu napraviti tu na licu mesta)) Ranije sam brinula da neću moći da nađem "svog" specijalista, ali Konstantin Aleksejević se pokazao kao super kul lekar! Hvala)`,
    sr_cyrl: `Веома добар лекар, на сва питања је дао одговор, исправио све проблеме који су се појавили за време живота у Црној Гори! Само добри утисци. У кабинету је све чисто и уредно, снимке се могу направити ту на лицу места)) Раније сам бринула да нећу моћи да нађем "свог" специјалисту, али Константин Алексејевић се показао као супер кул лекар! Хвала)`,
    en: `Very good doctor, answered all questions, fixed all the problems that appeared during life in Montenegro! Only good impressions. The office is clean and tidy, X-rays can be done right there)) I used to worry that I wouldn't be able to find "my" specialist, but Konstantin Alekseevich turned out to be a super cool doctor! Thanks)`,
    de: `Sehr guter Arzt, hat alle Fragen beantwortet, alle Probleme behoben, die während des Lebens in Montenegro aufgetreten sind! Nur gute Eindrücke. In der Praxis ist alles sauber und ordentlich, Röntgenbilder kann man direkt vor Ort machen)) Früher habe ich mir Sorgen gemacht, dass ich nicht "meinen" Spezialisten finden könnte, aber Konstantin Aleksejewitsch hat sich als super cooler Arzt herausgestellt! Danke)`,
    tr: `Çok iyi doktor, tüm sorulara cevap verdi, Karadağ'da yaşarken ortaya çıkan tüm sorunları düzeltti! Sadece güzel izlenimler. Muayenehanede her şey temiz ve düzenli, röntgenler hemen orada çekilebiliyor)) Daha önce "kendi" uzmanımı bulamayacağım diye endişeleniyordum, ama Konstantin Alekseyeviç süper harika bir doktor çıktı! Teşekkürler)`,
  },

  // 36. ASPEC Motorsport — massively extended
  'ChZDSUhNMG9nS0VJQ0FnSUMxMU9uWEN3EAE': {
    sr: `Odlična klinika. Lekar Konstantin Aleksejević je specijalista visoke kvalifikacije. Upoznao sam ga još u Rusiji. Dugo vremena sam se brinuo oko obraćanja stomatolozima, sećajući se kako je to uvek dugo, skupo i bolno. Zanemario sam situaciju. Obratio sam se Konstantinu kad sam više nije mogao da trpim bol. Osnovne probleme je uklonio odmah. Između ostalog, izvadio razrušeni umnjak za koji je lekaru trebalo 20 minuta. Bezbolno. U narednim posetama je reanimirao i ostale zube. Štaviše, dva osuđena na vađenje uspeo je da obnovi. Od tog trenutka prošlo je 2 ili 3 godine. Sada na preventivni pregled jednom u šest meseci, kao na praznik. Posle ličnog iskustva, poslao sam sve svoje rođake na lečenje. Savetujem svojim prijateljima i poznanicima. Između ostalog, i za estetska pitanja. Najviše mi odgovara visoka kvalifikacija, pedantan pristup, poznavanje savremenih tehnologija i metoda, odlična teorijska priprema, veliko iskustvo. Najvažnije za mene je odsustvo bola. Hvala. Recenziju ostavljam od sveg srca. Procvat klinici!`,
    sr_cyrl: `Одлична клиника. Лекар Константин Алексејевић је специјалиста високе квалификације. Упознао сам га још у Русији. Дуго времена сам се бринуо око обраћања стоматолозима, сећајући се како је то увек дуго, скупо и болно. Занемарио сам ситуацију. Обратио сам се Константину кад више нисам могао да трпим бол. Основне проблеме је уклонио одмах. Између осталог, извадио разрушени умњак за који је лекару требало 20 минута. Безболно. У наредним посетама је реанимирао и остале зубе. Штавише, два осуђена на вађење успео је да обнови. Од тог тренутка прошло је 2 или 3 године. Сада на превентивни преглед једном у шест месеци, као на празник. После личног искуства, послао сам све своје рођаке на лечење. Саветујем својим пријатељима и познаницима. Између осталог, и за естетска питања. Највише ми одговара висока квалификација, педантан приступ, познавање савремених технологија и метода, одлична теоријска припрема, велико искуство. Најважније за мене је одсуство бола. Хвала. Рецензију остављам од свег срца. Процват клиници!`,
    en: `Excellent clinic. Doctor Konstantin Alekseevich is a highly qualified specialist. I met him back in Russia. For a long time I was worried about going to dentists, remembering how it's always long, expensive, and painful. I neglected the situation. I went to Konstantin when I couldn't endure the pain anymore. He eliminated the main problems right away. Among other things, he removed a destroyed wisdom tooth, which took the doctor 20 minutes. Painless. In subsequent visits, he revived the other teeth as well. Moreover, two teeth that were sentenced to extraction he managed to restore. Two or three years have passed since then. Now I go for a preventive checkup every six months like it's a holiday. After my personal experience, I sent all my relatives for treatment. I recommend to my friends and acquaintances. Including for cosmetic issues. What suits me most is the high qualification, meticulous approach, knowledge of modern technologies and methods, excellent theoretical background, and extensive experience. The most important thing for me is the absence of pain. Thank you. I leave this review from the bottom of my heart. Prosperity to the clinic!`,
    de: `Ausgezeichnete Klinik. Arzt Konstantin Aleksejewitsch ist ein hochqualifizierter Spezialist. Ich habe ihn noch in Russland kennengelernt. Lange Zeit hatte ich Bedenken, zum Zahnarzt zu gehen, weil ich mich erinnerte, wie es immer lang, teuer und schmerzhaft ist. Ich habe die Situation vernachlässigt. Ich wandte mich an Konstantin, als ich die Schmerzen nicht mehr aushalten konnte. Die Hauptprobleme hat er sofort beseitigt. Unter anderem hat er einen zerstörten Weisheitszahn entfernt, wofür der Arzt 20 Minuten brauchte. Schmerzfrei. In den folgenden Besuchen hat er auch die restlichen Zähne wiederbelebt. Darüber hinaus konnte er zwei zum Ziehen verurteilte Zähne restaurieren. Seitdem sind 2 oder 3 Jahre vergangen. Jetzt gehe ich alle sechs Monate zur Vorsorge wie zu einem Fest. Nach meiner persönlichen Erfahrung habe ich alle meine Verwandten zur Behandlung geschickt. Ich empfehle meinen Freunden und Bekannten. Auch für ästhetische Fragen. Am meisten überzeugt mich die hohe Qualifikation, der akribische Ansatz, die Kenntnis moderner Technologien und Methoden, die ausgezeichnete theoretische Ausbildung und die umfangreiche Erfahrung. Das Wichtigste für mich ist die Schmerzfreiheit. Danke. Diese Bewertung schreibe ich von ganzem Herzen. Der Klinik viel Erfolg!`,
    tr: `Mükemmel klinik. Doktor Konstantin Alekseyeviç yüksek nitelikli bir uzman. Onunla daha Rusya'da tanıştım. Uzun süre diş hekimlerine gitme konusunda endişeliydim, her zaman ne kadar uzun, pahalı ve ağrılı olduğunu hatırlayarak. Durumu ihmal ettim. Acıya dayanamayınca Konstantin'e başvurdum. Ana sorunları hemen giderdi. Diğer şeylerin yanı sıra, yıkılmış bir yirmilik dişi çıkardı, bu doktora 20 dakika sürdü. Ağrısız. Sonraki ziyaretlerde diğer dişleri de canlandırdı. Üstelik çekime mahkum edilmiş iki dişi geri kazandırmayı başardı. O zamandan beri 2 veya 3 yıl geçti. Artık altı ayda bir koruyucu kontrole bayram gibi gidiyorum. Kişisel deneyimimden sonra tüm akrabalarımı tedaviye gönderdim. Arkadaşlarıma ve tanıdıklarıma tavsiye ediyorum. Estetik konular dahil. En çok yüksek nitelik, titiz yaklaşım, modern teknoloji ve yöntem bilgisi, mükemmel teorik altyapı ve geniş deneyim memnun ediyor. Benim için en önemlisi ağrının olmaması. Teşekkürler. Bu yorumu gönülden bırakıyorum. Kliniğe başarılar!`,
  },

  // 37. Дмитрий Беляков — extended
  'ChZDSUhNMG9nS0VJQ0FnSUMxcUpyNlBnEAE': {
    sr: `Prekrasna stomatologija. Nismo mislili da u Crnoj Gori postoje profesionalci takvog nivoa. JUST je zaista postala naša porodična stomatologija, gde se deca ne plaše da idu, a odrasli članovi porodice poveravaju zdravlje svojih zuba.\nZa to vreme je izlečen jedan zub kod odraslog, izvađena su dva kod mlađe ćerke (hvala Konstantinu za njegov pristup, dete sada uopšte ne povezuje zubara sa strahom), i izvađena su 3 kod starijeg sina (takođe hvala za pravovremenu pomoć).`,
    sr_cyrl: `Прекрасна стоматологија. Нисмо мислили да у Црној Гори постоје професионалци таквог нивоа. JUST је заиста постала наша породична стоматологија, где се деца не плаше да иду, а одрасли чланови породице поверавају здравље својих зуба.\nЗа то време је излечен један зуб код одраслог, извађена су два код млађе ћерке (хвала Константину за његов приступ, дете сада уопште не повезује зубара са страхом), и извађена су 3 код старијег сина (такође хвала за правовремену помоћ).`,
    en: `Wonderful dental clinic. We didn't think there were professionals of this level in Montenegro. JUST truly became our family dental clinic, where kids aren't afraid to go and adult family members trust the health of their teeth.\nDuring this time, one adult tooth was treated, two were extracted from our younger daughter (thanks to Konstantin for his approach — the child now doesn't associate the dentist with fear at all), and 3 were extracted from our older son (also thanks for the timely help).`,
    de: `Wunderbare Zahnklinik. Wir hätten nicht gedacht, dass es in Montenegro Profis auf diesem Niveau gibt. JUST ist wirklich zu unserer Familienzahnklinik geworden, wohin die Kinder ohne Angst gehen und die erwachsenen Familienmitglieder die Gesundheit ihrer Zähne anvertrauen.\nIn dieser Zeit wurde ein Zahn bei einem Erwachsenen behandelt, zwei wurden bei der jüngeren Tochter gezogen (Danke an Konstantin für seinen Ansatz — das Kind verbindet jetzt den Zahnarzt überhaupt nicht mehr mit Angst), und 3 wurden beim älteren Sohn gezogen (ebenfalls danke für die rechtzeitige Hilfe).`,
    tr: `Harika diş kliniği. Karadağ'da bu seviyede profesyoneller olduğunu düşünmemiştik. JUST gerçekten aile diş kliniğimiz oldu, çocukların gitmekten korkmadığı ve yetişkin aile üyelerinin dişlerinin sağlığını güvenle emanet ettiği bir yer.\nBu süre zarfında bir yetişkin diş tedavi edildi, küçük kızımızdan iki diş çekildi (yaklaşımı için Konstantin'e teşekkürler — çocuk artık diş hekimini korkuyla hiç ilişkilendirmiyor), ve büyük oğlumuzdan 3 diş çekildi (zamanında yardım için de teşekkürler).`,
  },

  // 38. Дарья Краснова — extended
  'ChdDSUhNMG9nS0VJQ0FnSUMxcUpDVnJBRRAB': {
    sr: `Prekrasna stomatologija!\nImam problematične zube i pronaći ovde nakon preseljenja dobrog stomatologa — bio je poklon (i neophodnost)!\n\nČist kabinet, prekrasan klijentski servis, profesionalan rad! Hvala!`,
    sr_cyrl: `Прекрасна стоматологија!\nИмам проблематичне зубе и пронаћи овде након пресељења доброг стоматолога — био је поклон (и неопходност)!\n\nЧист кабинет, прекрасан клијентски сервис, професионалан рад! Хвала!`,
    en: `Wonderful dental clinic!\nI have problematic teeth and finding a good dentist here after moving was a gift (and a necessity)!\n\nClean office, excellent client service, professional work! Thank you!`,
    de: `Wunderbare Zahnklinik!\nIch habe problematische Zähne und hier nach dem Umzug einen guten Zahnarzt zu finden war ein Geschenk (und eine Notwendigkeit)!\n\nSaubere Praxis, hervorragender Kundenservice, professionelle Arbeit! Danke!`,
    tr: `Harika diş kliniği!\nSorunlu dişlerim var ve taşındıktan sonra burada iyi bir diş hekimi bulmak bir hediye (ve zorunluluk) oldu!\n\nTemiz muayenehane, mükemmel müşteri hizmeti, profesyonel iş! Teşekkürler!`,
  },
}

// ---------------------------------------------------------------------------
// Generate SQL
// ---------------------------------------------------------------------------
function escapeSQL(str) {
  if (str == null) return 'NULL'
  return "'" + str.replace(/\\/g, '\\\\').replace(/'/g, "\\'") + "'"
}

const lines = []
lines.push('-- Migration: Update reviews with corrected original texts and translations')
lines.push('-- JUST Dental Clinic (Bar)')
lines.push('-- Generated by: node scripts/generate-just-dental-migration.mjs')
lines.push('')
lines.push('SET NAMES utf8mb4;')
lines.push('SET CHARACTER SET utf8mb4;')
lines.push('')

for (const m of mismatches) {
  const t = translations[m.id]
  if (!t) {
    console.error(`WARNING: No translations for ${m.author} (${m.id})`)
    continue
  }

  lines.push(`-- ${m.author}`)

  if (t._skipTranslations) {
    // Only update original_text
    lines.push(`UPDATE reviews SET`)
    lines.push(`  original_text = ${escapeSQL(m.newText)}`)
    lines.push(`WHERE provider = 'google_maps' AND provider_review_id = ${escapeSQL(m.providerReviewId)};`)
  } else {
    const isEnOriginal = m.originalLang === 'en'
    const isUkOriginal = m.originalLang === 'uk'
    const needsLangUpdate = isEnOriginal || isUkOriginal

    // For en/uk originals: text_en/text_ru handling
    const text_en = isEnOriginal ? escapeSQL(m.newText) : escapeSQL(t.en)
    const text_ru = (isEnOriginal || isUkOriginal) ? escapeSQL(t.ru) : escapeSQL(m.newText)

    lines.push(`UPDATE reviews SET`)
    lines.push(`  original_text = ${escapeSQL(m.newText)},`)
    if (needsLangUpdate) {
      lines.push(`  original_language = ${escapeSQL(m.originalLang)},`)
    }
    lines.push(`  text_sr = ${escapeSQL(t.sr)},`)
    lines.push(`  text_sr_cyrl = ${escapeSQL(t.sr_cyrl)},`)
    lines.push(`  text_en = ${text_en},`)
    lines.push(`  text_ru = ${text_ru},`)
    lines.push(`  text_de = ${escapeSQL(t.de)},`)
    lines.push(`  text_tr = ${escapeSQL(t.tr)}`)
    lines.push(`WHERE provider = 'google_maps' AND provider_review_id = ${escapeSQL(m.providerReviewId)};`)
  }
  lines.push('')
}

const sql = lines.join('\n')
process.stdout.write(sql)
