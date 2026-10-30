-- Insert Google Maps reviews for K-med Ambulanta i Pedijatrijska Ambulanta Bar 2
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/k-med-ambulanta-bar.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'k-med-ambulanta-bar');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Анна Ставрова', 'https://lh3.googleusercontent.com/a-/ALV-UjXwXPmZ1nJ7IGAU5V91HGNismFMG26MTv_jGWbq7lpPkFBCMbhd=s128-c0x00000000-cc-rp-mo-ba6', 'https://www.google.com/maps/contrib/110062395535812623736/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110062395535812623736/reviews');
SET @user_anna_stavrova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110062395535812623736/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ruslan Zagrutdinov', 'https://lh3.googleusercontent.com/a/ACg8ocIezXxkXyRwevJwaWBfH0urPyGJNg7qRCfZ3-IEHJ0e8qRTtw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/102287216719189828617/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102287216719189828617/reviews');
SET @user_ruslan_zagrutdinov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102287216719189828617/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'L.A Morais.V', 'https://lh3.googleusercontent.com/a-/ALV-UjXjnYUVFblAQBhm2bNrOCpWJfLYihCuIThGo7yR7a0p2yYsx2f-=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/110756188554475320971/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110756188554475320971/reviews');
SET @user_la_moraisv = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110756188554475320971/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elle Durakovic', 'https://lh3.googleusercontent.com/a/ACg8ocKgnmVyS5ylutvMGZrz1XRiGWeir9srhak0p7YNyfuzFClx3w=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/110708675235084199737/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110708675235084199737/reviews');
SET @user_elle_durakovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110708675235084199737/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ipko Gerina', 'https://lh3.googleusercontent.com/a/ACg8ocK8uOlAguIt2tDrjUGl1-GA5ybtc4aIriRnaibJV2q66EjhmA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/117071251789874743663/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117071251789874743663/reviews');
SET @user_ipko_gerina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117071251789874743663/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nastasija Milosevic Sopta', 'https://lh3.googleusercontent.com/a-/ALV-UjWNui7AitId4LM0ImyAga8hbe6oUn_S66oFTJZY1SbDXgWftBPS=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115186213888758301914/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115186213888758301914/reviews');
SET @user_nastasija_milosevic_sopta = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115186213888758301914/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jasmina Dragovic', 'https://lh3.googleusercontent.com/a-/ALV-UjU8fTbO3o7p3A9x8Ma9gzpeq_eeRssAQKkVVRtqbgEj8bKEbSNW=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100073128294794161143/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100073128294794161143/reviews');
SET @user_jasmina_dragovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100073128294794161143/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marianne Mäder-Felber', 'https://lh3.googleusercontent.com/a-/ALV-UjVXfqL15t74XUENha-ZBR-G50_MvVoW4qw3333IonmUvpRzT1Eq=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103910038459730467299/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103910038459730467299/reviews');
SET @user_marianne_mderfelber = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103910038459730467299/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alejna Begljer', 'https://lh3.googleusercontent.com/a/ACg8ocIaRfqjO0_qne2D50UMdFLWkFUg9c0NiwsLqj_SotUhXI_Z9Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110884841276338648816/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110884841276338648816/reviews');
SET @user_alejna_begljer = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110884841276338648816/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tamara', 'https://lh3.googleusercontent.com/a/ACg8ocJRxNVTbqgNlynhgwoNLnJBus5Ug3DS5yg1LLoa4jGWQN5C-Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107237208402360162961/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107237208402360162961/reviews');
SET @user_tamara = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107237208402360162961/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anastasija Kontic', 'https://lh3.googleusercontent.com/a-/ALV-UjX98WVV79t9wSLRzL0nQW8DQQMQFgFoRwhbeQaAA0oVN-VcOxgIrA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112809877808517006967/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112809877808517006967/reviews');
SET @user_anastasija_kontic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112809877808517006967/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Ivanovic', 'https://lh3.googleusercontent.com/a/ACg8ocItFrR9hzSPeFi3QSO9BmGwgPYX7psO501F0DfxOG1gKRVvYA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111085056822713019862/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111085056822713019862/reviews');
SET @user_jovana_ivanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111085056822713019862/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Igor Petrov', 'https://lh3.googleusercontent.com/a-/ALV-UjX37UE9DsNMVzQc79C44Ur1nHvtrVcenyW8pKYgbYq-1N_gOwE=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104438573423603239347/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104438573423603239347/reviews');
SET @user_igor_petrov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104438573423603239347/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mia Kestner', 'https://lh3.googleusercontent.com/a-/ALV-UjWFw2ZJFzzzpT47YKABmzC0LF1VD3oeuP-juXW4vwoxaIHSvik=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102331165623823390612/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102331165623823390612/reviews');
SET @user_mia_kestner = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102331165623823390612/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Emina Nasufovic', 'https://lh3.googleusercontent.com/a/ACg8ocJ3v1RtIai7CSzOWh_qgLxOSGM6fJi1g5FAo26VPNNykUotmQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110159440936728679318/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110159440936728679318/reviews');
SET @user_emina_nasufovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110159440936728679318/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_anna_stavrova, @clinic_id, NULL, 'google_maps',
    'places/ChIJq2ERcwB1ThMRmxfuKUAW7sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWNFFtdE5kVjkxUTJWbFFtRk1lalZITjJoMU5IYxAB',
    5, 'ru', 'Приём педиатра стоил 70 евро. Отлично, что можно прийти с грудничком. Делают полный осмотр, снимают показатели. Удобное расположение клиники в центре города.',
    'Pregled kod pedijatra je koštao 70 evra. Odlično je što mogu da dođem sa bebom. Oni rade kompletan pregled i uzimaju merenja. Klinika je pogodno smeštena u centru grada.', 'Преглед код педијатра је коштао 70 евра. Одлично је што могу да дођем са бебом. Они раде комплетан преглед и узимају мерења. Клиника је погодно смештена у центру града.', NULL, 'Приём педиатра стоил 70 евро. Отлично, что можно прийти с грудничком. Делают полный осмотр, снимают показатели. Удобное расположение клиники в центре города.', NULL, NULL,
    0, '2025-12-29 18:41:22'),

(@user_ruslan_zagrutdinov, @clinic_id, NULL, 'google_maps',
    'places/ChIJq2ERcwB1ThMRmxfuKUAW7sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2taTWNUWXdhVEoxYzBjNVUweDJRM1ZNUm5kcldXYxAB',
    1, 'ru', 'Пишут, что все было хорошо, а я не согласен, у меня не все было хорошо. За осмотр дочки взяли 65 евро из которых 48 евро сам осмотр (ок) и 17 евро за то, что медсестра приложила к пальцу дочки приборчик для измерения пульса и кислорода в крови.. но это ВСЕГДА входит в услуги осмотра врачом, во всех клиниках Черногории. Я живу тут 16 лет и у меня 5 детей, я знаю о чем говорю. Будьте внимательны, мне стало обидно за 17 евро, которые мне вписали, они не лишние.',
    'Kažu da je sve bilo u redu, ali se ne slažem; nije sve bilo u redu za mene. Pregled moje ćerke je koštao 65 evra, uključujući 48 evra za sam pregled i 17 evra za medicinsku sestru koja je držala aparat na prstu moje ćerke da bi izmerila puls i nivo kiseonika u krvi. Ali to je UVEK uključeno u lekarski pregled u svim crnogorskim klinikama. Živim ovde 16 godina i imam petoro dece, tako da znam o čemu pričam. Budite oprezni, uvredila sam se zbog 17 evra koje su mi naplatili; to nije bilo dodatno.', 'Кажу да је све било у реду, али се не слажем; није све било у реду за мене. Преглед моје ћерке је коштао 65 евра, укључујући 48 евра за сам преглед и 17 евра за медицинску сестру која је држала апарат на прсту моје ћерке да би измерила пулс и ниво кисеоника у крви. Али то је УВЕК укључено у лекарски преглед у свим црногорским клиникама. Живим овде 16 година и имам петоро деце, тако да знам о чему причам. Будите опрезни, увредила сам се због 17 евра које су ми наплатили; то није било додатно.', NULL, 'Пишут, что все было хорошо, а я не согласен, у меня не все было хорошо. За осмотр дочки взяли 65 евро из которых 48 евро сам осмотр (ок) и 17 евро за то, что медсестра приложила к пальцу дочки приборчик для измерения пульса и кислорода в крови.. но это ВСЕГДА входит в услуги осмотра врачом, во всех клиниках Черногории. Я живу тут 16 лет и у меня 5 детей, я знаю о чем говорю. Будьте внимательны, мне стало обидно за 17 евро, которые мне вписали, они не лишние.', NULL, NULL,
    0, '2026-03-06 16:30:48'),

(@user_la_moraisv, @clinic_id, NULL, 'google_maps',
    'places/ChIJq2ERcwB1ThMRmxfuKUAW7sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xKM1RrOWlNbTUxVVdaVk1tdHFPV1Z3WTNSZlQwRRAB',
    5, 'en', 'We had such a great experience here! Everyone was super kind and welcoming, and the doctor was really patient and easy to talk to. He took the time to explain everything, which made us feel so much more relaxed and the fact that the doctor speaks english was a big plus for me. The clinic is clean and very well organized too. Definitely recommend! 😊 Definitely the best pediatric clinic in town!',
    'Imali smo tako sjajno iskustvo ovde! Svi su bili super ljubazni i gostoljubivi, a doktor je bio veoma strpljiv i lako je bilo razgovarati sa njim. Odvojio je vreme da sve objasni, što nas je učinilo mnogo opuštenijim, a činjenica da doktor govori engleski je bila veliki plus za mene. Klinika je čista i veoma dobro organizovana. Svakako preporučujem! 😊 Definitivno najbolja pedijatrijska klinika u gradu!', 'Имали смо тако сјајно искуство овде! Сви су били супер љубазни и гостољубиви, а доктор је био веома стрпљив и лако је било разговарати са њим. Одвојио је време да све објасни, што нас је учинило много опуштенијим, а чињеница да доктор говори енглески је била велики плус за мене. Клиника је чиста и веома добро организована. Свакако препоручујем! 😊 Дефинитивно најбоља педијатријска клиника у граду!', 'We had such a great experience here! Everyone was super kind and welcoming, and the doctor was really patient and easy to talk to. He took the time to explain everything, which made us feel so much more relaxed and the fact that the doctor speaks english was a big plus for me. The clinic is clean and very well organized too. Definitely recommend! 😊 Definitely the best pediatric clinic in town!', NULL, NULL, NULL,
    0, '2026-04-30 08:07:21'),

(@user_elle_durakovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJq2ERcwB1ThMRmxfuKUAW7sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4V1RrSnVORk5hVkdsM1NYazRTVFJUVVd0UFJsRRAB',
    5, 'en', 'After moving from Australia, it was really important for me to find a pediatrician I could trust. I was used to a certain standard of care, and I can honestly say I’ve found that with Dr Kavaric. He also provides care amd support after the appointment which gives me reassurance as a parent.

Puno sam zahvalna sto imamo Dr Kavarica u gradu Bar, sve pohvale za njega i team K Med!!!',
    'Nakon što sam se preselio iz Australije, bilo mi je veoma važno da pronađem pedijatra kome mogu da verujem. Navikao sam na određeni standard nege i mogu iskreno reći da sam to pronašao sa dr Kavarićem. On takođe pruža negu i podršku nakon pregleda, što mi kao roditelju daje sigurnost.

Puno sam zahvalan što imamo dr Kavaricu u diplomi Bar, sve pohvale za njega i tim K Med!!!', 'Након што сам се преселио из Аустралије, било ми је веома важно да пронађем педијатра коме могу да верујем. Навикао сам на одређени стандард неге и могу искрено рећи да сам то пронашао са др Каварићем. Он такође пружа негу и подршку након прегледа, што ми као родитељу даје сигурност.

Пуно сам захвалан што имамо др Каварицу у дипломи Бар, све похвале за њега и тим К Мед!!!', 'After moving from Australia, it was really important for me to find a pediatrician I could trust. I was used to a certain standard of care, and I can honestly say I’ve found that with Dr Kavaric. He also provides care amd support after the appointment which gives me reassurance as a parent.

Puno sam zahvalna sto imamo Dr Kavarica u gradu Bar, sve pohvale za njega i team K Med!!!', NULL, NULL, NULL,
    0, '2026-04-29 04:30:27'),

(@user_ipko_gerina, @clinic_id, NULL, 'google_maps',
    'places/ChIJq2ERcwB1ThMRmxfuKUAW7sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21aVWN6VlVTa1J4U0VOMlRGZEZOa1ZuYlhJMWEyYxAB',
    5, 'hr', 'Novo u nasem gradu
Bili smo kod K-med na pregled sa bebom prezadovoljni smo vasom ljubaznoscu i profesionalizmom
Sve pohvale i preporuke',
    'Novo u našem gradu
Bili smo u K-medu na pregledu sa našom bebom i veoma smo zadovoljni vašom ljubaznošću i profesionalizmom
Sve pohvale i preporuke', 'Ново у нашем граду
Били смо у К-меду на прегледу са нашом бебом и веома смо задовољни вашом љубазношћу и професионализмом
Све похвале и препоруке', NULL, NULL, NULL, NULL,
    0, '2026-03-10 10:32:23'),

(@user_nastasija_milosevic_sopta, @clinic_id, NULL, 'google_maps',
    'places/ChIJq2ERcwB1ThMRmxfuKUAW7sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxV01reDZaek5wZGpkRE4zTktUV2RRY2xOb1ZsRRAB',
    2, 'bs', 'Doktor je jako responsivan i predusrertljiv dok ne dodjete na pregled (=dok ne platite), nakon toga mu se gubi svaki trag. Iako je shvatio hitnost situacije u nasem slucaju tokom pregleda, gde je delovao iskreno zabrinuto i sam ponudio svoju dostupnost telefonom 24h, nakon pregleda i visestrukih poziva za konsultacijom, nismo uspeli da dodjemo do doktora. Hvala svakako!',
    'Doktor je jako responsivan i predusrertljiv dok ne dodjete na pregled (=dok ne platite), nakon toga mu se gubi svaki trag. Iako je shvatio hitnost situacije u nasem slucaju tokom pregleda, gde je delovao iskreno zabrinuto i sam ponudio svoju dostupnost telefonom 24h, nakon pregleda i visestrukih poziva za konsultacijom, nismo uspeli da dodjemo do doktora. Hvala svakako!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_jasmina_dragovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJq2ERcwB1ThMRmxfuKUAW7sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWT1ZFTkNUM1pwWVdFMGREZHFiMUZCYUZoZk1VRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_marianne_mderfelber, @clinic_id, NULL, 'google_maps',
    'places/ChIJq2ERcwB1ThMRmxfuKUAW7sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pCS1YxbGxkRWR4WmtaVWFHUmlUa3BYVVRCVFVYYxAB',
    5, 'hr', 'Bili smo danas u 21 sat sa našom malom kćerkom u K-Med-u. Odmah smo dobili termin. Osoblje nas je dočekalo veoma srdačno.Ljekar je bio nevjerovatno pažljiv. Sve je detaljno pregledao. Osjećali smo se u sigurnim rukama i dobili smo vrhunske informacije.Najbolji dio: Naša kćerka je čak dobila plišanu igračku na poklon! Osjećala se veoma prijatno kod ovog ljekara.Prezadovoljni smo i od sada ćemo uvijek dolaziti ovdje. Sve preporuke – ovdje zaista imaju veliko srce za djecu!',
    'Bili smo danas u 21 sat sa našom malom kćerkom u K-Med-u. Odmah smo dobili termin. Osoblje nas je dočekalo veoma srdačno.Ljekar je bio nevjerovatno pažljiv. Sve je detaljno pregledao. Osjećali smo se u sigurnim rukama i dobili smo vrhunske informacije.Najbolji dio: Naša kćerka je čak dobila plišanu igračku na poklon! Osjećala se veoma prijatno kod ovog ljekara.Prezadovoljni smo i od sada ćemo uvijek dolaziti ovdje. Sve preporuke – ovdje zaista imaju veliko srce za djecu!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_alejna_begljer, @clinic_id, NULL, 'google_maps',
    'places/ChIJq2ERcwB1ThMRmxfuKUAW7sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tJdFZIQktlV05DTW05QlNUVldjekZNZEZwRE0wRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_tamara, @clinic_id, NULL, 'google_maps',
    'places/ChIJq2ERcwB1ThMRmxfuKUAW7sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkVlUzaEZWRGh0Y0ZwM1ZqRndZMDF1VVVoeWJGRRAB',
    5, 'en', 'Very professional and caring for patients. Huge recommendation for K-med!',
    NULL, NULL, 'Very professional and caring for patients. Huge recommendation for K-med!', NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_anastasija_kontic, @clinic_id, NULL, 'google_maps',
    'places/ChIJq2ERcwB1ThMRmxfuKUAW7sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25SblUyMDBhMkp4VVdSNlNGSlpOMmxDUlZwbVFXYxAB',
    5, 'hr', 'Jako profesionalni i efikasni!
Svaka pohvala!',
    'Jako profesionalni i efikasni!
Svaka pohvala!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_jovana_ivanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJq2ERcwB1ThMRmxfuKUAW7sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pZMU5VTmFMWGhVVVhaQlkyNVhZelp6VEdwU1FuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_igor_petrov, @clinic_id, NULL, 'google_maps',
    'places/ChIJq2ERcwB1ThMRmxfuKUAW7sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tkblNrdFBTbk5KVFhGSFFUZGFhSEU1Y2pZNVFuYxAB',
    5, 'ru', 'Хорошее впечатление после приема. Осмотр прошел быстро, назначение помогло, через 3 дня ребенок здоров.',
    NULL, NULL, NULL, 'Хорошее впечатление после приема. Осмотр прошел быстро, назначение помогло, через 3 дня ребенок здоров.', NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_mia_kestner, @clinic_id, NULL, 'google_maps',
    'places/ChIJq2ERcwB1ThMRmxfuKUAW7sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKVVEwZHJkWFZCUTBsU1l6QlpVRTlVUVdKYVVYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_emina_nasufovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJq2ERcwB1ThMRmxfuKUAW7sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSc1NtRmZWMG8yZEZoTVowMVJTSEJCYm1oU1NHYxAB',
    5, 'hr', 'Divno iskustvo sa doktorom i med.sestrom u ambulanti K med.',
    'Divno iskustvo sa doktorom i med.sestrom u ambulanti K med.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
