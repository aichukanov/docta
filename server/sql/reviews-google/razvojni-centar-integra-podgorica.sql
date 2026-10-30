-- Insert Google Maps reviews for Razvojni centar Integra
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/razvojni-centar-integra-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'razvojni-centar-integra-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_marko_minic = (SELECT id FROM doctors WHERE slug = 'marko-minic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Svetlana Zecevic', 'https://lh3.googleusercontent.com/a/ACg8ocK_eWovhSbQhzLhwaIJlVPeaXQ9te_ypP5rif32zI5CjV0S3w=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/116205694319972963629/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116205694319972963629/reviews');
SET @user_svetlana_zecevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116205694319972963629/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Bozovic', 'https://lh3.googleusercontent.com/a-/ALV-UjV8Q4Aayf0prqYdWnUyQf05kUSyOg4VJrxv9q0wfXezoBZ1cqMg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/112876612177089522521/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112876612177089522521/reviews');
SET @user_ivana_bozovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112876612177089522521/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kristina Božović', 'https://lh3.googleusercontent.com/a-/ALV-UjUdC9q1XIonL-Ea3Bo8nduqzMXrSskyhpRTLmp2RcwB3_YiMPvM=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/110724230532024364180/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110724230532024364180/reviews');
SET @user_kristina_boovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110724230532024364180/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Bijelic', 'https://lh3.googleusercontent.com/a-/ALV-UjWwxRpSBYRmBOu2nVNKfJ9o4SVHO5Wwr4MYhNj9esFRFhMHJ92U=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/109263151483776869860/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109263151483776869860/reviews');
SET @user_ivan_bijelic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109263151483776869860/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Slaven Jovanovic', 'https://lh3.googleusercontent.com/a/ACg8ocKcrpeJYQWPv-17eayiRMlkQP9A9WKa81bL28yycG2yCpUdww=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111741806341656111626/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111741806341656111626/reviews');
SET @user_slaven_jovanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111741806341656111626/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nada Minjevic', 'https://lh3.googleusercontent.com/a-/ALV-UjVYiqOMxJxTPd-SaEt7olgmqiOodoRTEXz5EzTbRts9pU1vRgDM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109626064771881577531/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109626064771881577531/reviews');
SET @user_nada_minjevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109626064771881577531/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'dali mrva', 'https://lh3.googleusercontent.com/a-/ALV-UjXGWBJ-U6RM6NuJHozq53hoP80LC5kBqgGXxfMl-4xwWDz6LO_RGQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108768980287004507049/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108768980287004507049/reviews');
SET @user_dali_mrva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108768980287004507049/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Djuretic', 'https://lh3.googleusercontent.com/a/ACg8ocLwpdrUzzoJRxj84jCKH4MY0k65a3XOaU2kuMF4XrIMZB4DKQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117327924183108018188/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117327924183108018188/reviews');
SET @user_maja_djuretic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117327924183108018188/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Momcilo Corsovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWaWLgrbVdW18Hwzl-NviFaucc8EiWV4tUy-9c1cEIHmjUzQIw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115747809905736909220/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115747809905736909220/reviews');
SET @user_momcilo_corsovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115747809905736909220/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ksenija Vesovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUxCm-xbJ2KZPxOJhF7m5NduHgcS00jYrzgcLAQp6tAaCS5Q3W-=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109025403683694277665/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109025403683694277665/reviews');
SET @user_ksenija_vesovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109025403683694277665/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ruzica Draganic', 'https://lh3.googleusercontent.com/a-/ALV-UjXXmcZdgMqq8M5fxz8S3_CRGTWNPS7WfEXNhn6xnne63iZPwH4t=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109846974346844114186/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109846974346844114186/reviews');
SET @user_ruzica_draganic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109846974346844114186/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dalibor Tomic', 'https://lh3.googleusercontent.com/a/ACg8ocKp_oVZhSHKVHLf9HDvXHv2U-tdgAFK9Kvd-ByjFnZLArQa1g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106667127669762723417/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106667127669762723417/reviews');
SET @user_dalibor_tomic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106667127669762723417/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Perovic', 'https://lh3.googleusercontent.com/a/ACg8ocK05jEZlhmBqM8D-qHOf2LRPdlqgSfoZUupDMRtCPokKN5-Ng=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115224164199505480672/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115224164199505480672/reviews');
SET @user_nikola_perovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115224164199505480672/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_svetlana_zecevic, @clinic_id, @doctor_marko_minic, 'google_maps',
    'places/ChIJhf2cS1jtTRMRDmrZU-NvYao/reviews/ChZDSUhNMG9nS0VJQ0FnTURBMDlYSGVnEAE',
    5, 'bs', 'Marko je izuzetan terapeut, koji svojom dubinom, toplinom i posvećenošću vodi kroz proces istinskog ličnog rasta.

Njegova sposobnost da brzo prepozna obrasce i dinamiku odnosa pomogla mi je da ostvarim značajne promjene. U pravom trenutku postavlja prava pitanja i nevjerovatno precizno pomaže da se sagleda suština problema, otvarajući prostor za dublje razumijevanje.
Ono što ga posebno izdvaja jeste njegova empatija i sposobnost da pruži osjećaj sigurnosti i prihvaćenosti.

Kroz kombinaciju transakcione analize i geštalt terapije, pomogao mi je da osvijestim obrasce iz prošlosti i način na koji oni utiču na moj sadašnji život. Zahvaljujući radu s njim, ne samo da sam promijenila način na koji doživljavam sebe, već sam i razvila dublju povezanost sa sobom, stekla unutrašnju sigurnost i počela da živim s više lakoće i unutrašnjeg mira.

Svaka nova seansa donosi priliku za nove spoznaje i predstavlja još jedan korak u ličnom rastu.

Ne mogu ga dovoljno preporučiti – njegov rad je neprocjenjiv za svakoga ko želi dublje razumijevanje sebe i život u većem skladu sa sobom.',
    'Marko je izuzetan terapeut, koji me svojom dubinom, toplinom i posvećenošću vodi kroz proces istinskog ličnog rasta.

Njegova sposobnost da brzo prepozna obrasce i dinamiku odnosa pomogla mi je da napravim značajne promene. On postavlja prava pitanja u pravo vreme i sa neverovatnom preciznošću pomaže da se sagleda suština problema, otvarajući prostor za dublje razumevanje.

Ono što ga posebno izdvaja je njegova empatija i sposobnost da pruži osećaj sigurnosti i prihvatanja.

Kroz kombinaciju transakcione analize i geštalt terapije, pomogao mi je da postanem svestan prošlih obrazaca i načina na koji oni utiču na moj sadašnji život. Zahvaljujući radu sa njim, ne samo da sam promenio način na koji sebe doživljavam, već sam i razvio dublju vezu sa sobom, stekao unutrašnju sigurnost i počeo da živim lakšim i unutrašnjim mirom.

Svaka nova sesija donosi priliku za nove uvide i predstavlja još jedan korak u ličnom razvoju.

Ne mogu ga dovoljno preporučiti – njegov rad je neprocenjiv za svakoga ko želi dublje razumevanje sebe i život u većoj harmoniji sa sobom.', 'Марко је изузетан терапеут, који ме својом дубином, топлином и посвећеношћу води кроз процес истинског личног раста.

Његова способност да брзо препозна обрасце и динамику односа помогла ми је да направим значајне промене. Он поставља права питања у право време и са невероватном прецизношћу помаже да се сагледа суштина проблема, отварајући простор за дубље разумевање.

Оно што га посебно издваја је његова емпатија и способност да пружи осећај сигурности и прихватања.

Кроз комбинацију трансакционе анализе и гешталт терапије, помогао ми је да постанем свестан прошлих образаца и начина на који они утичу на мој садашњи живот. Захваљујући раду са њим, не само да сам променио начин на који себе доживљавам, већ сам и развио дубљу везу са собом, стекао унутрашњу сигурност и почео да живим лакшим и унутрашњим миром.

Свака нова сесија доноси прилику за нове увиде и представља још један корак у личном развоју.

Не могу га довољно препоручити – његов рад је непроцењив за свакога ко жели дубље разумевање себе и живот у већој хармонији са собом.', NULL, NULL, NULL, NULL,
    2, '2025-02-11 16:59:44'),

(@user_ivana_bozovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhf2cS1jtTRMRDmrZU-NvYao/reviews/ChdDSUhNMG9nS0VJQ0FnTUNJbWNQWjd3RRAB',
    5, 'hr', 'Već dva mjeseca sam član grupne psihoterapije u Razvojnom centru Integra. Od prvog susreta osjetila sam njihovu toplinu, razumijevanje i iskrenu želju da nam pomognu. Njihov pristup je kombinacija profesionalizma i empatije, što stvara sigurno okruženje u kojem možemo slobodno izražavati svoje misli i emocije.
Njihova podrška nije samo profesionalna, već i ljudska, pa čini da se osjećam istinski viđeno i prihvaćeno. Najviše mi se sviđa što ne daju gotova rješenja, već me vode prema tome da pronađem odgovore u sebi. Ovakav pristup mi je pomaže da steknem dublje razumijevanje svojih emocija.
Od srca preporučujem svima koji traže sigurno mjesto za lični razvoj i emocionalnu podršku!',
    'Već dva meseca sam član grupne psihoterapije u Razvojnom centru Integra. Od prvog susreta osetio sam njihovu toplinu, razumevanje i iskrenu želju da nam pomognu. Njihov pristup je kombinacija profesionalizma i empatije, što stvara bezbedno okruženje u kome možemo slobodno da izrazimo svoje misli i emocije.
Njihova podrška nije samo profesionalna, već i ljudska, zbog čega se osećam zaista viđenim i prihvaćenim. Najviše volim to što ne daju gotova rešenja, već me usmeravaju da odgovore pronađem u sebi. Ovaj pristup mi je pomogao da bolje razumem svoje emocije.
Od srca ih preporučujem svima koji traže sigurno mesto za lični razvoj i emocionalnu podršku!', 'Већ два месеца сам члан групне психотерапије у Развојном центру Интегра. Од првог сусрета осетио сам њихову топлину, разумевање и искрену жељу да нам помогну. Њихов приступ је комбинација професионализма и емпатије, што ствара безбедно окружење у коме можемо слободно да изразимо своје мисли и емоције.
Њихова подршка није само професионална, већ и људска, због чега се осећам заиста виђеним и прихваћеним. Највише волим то што не дају готова решења, већ ме усмеравају да одговоре пронађем у себи. Овај приступ ми је помогао да боље разумем своје емоције.
Од срца их препоручујем свима који траже сигурно место за лични развој и емоционалну подршку!', NULL, NULL, NULL, NULL,
    0, '2025-04-03 07:53:10'),

(@user_kristina_boovi, @clinic_id, @doctor_marko_minic, 'google_maps',
    'places/ChIJhf2cS1jtTRMRDmrZU-NvYao/reviews/ChdDSUhNMG9nS0VJQ0FnTUNJeGRUcWpBRRAB',
    5, 'bs', 'Dugo sam trazila psihoterapeuta koji ce me zaista razumjeti i pomoci mi. U Razvojnom centru Integra pronasla sam spoj strucnosti, profesionalizma, iskustva i empatije.
Vec na prvom susretu sa psihoterapeutom Markom, osjetila sam njegovu potpunu posvecenost, sigurnost, prihvacenost i iskreno razumijevanje.
Danas, kada je mnogima ovaj posao samo biznis, Marko prije svega djeluje vodjen ljudskim i etickim vrijednostima. To potvrdjuje i cinjenica da nesebicno pomaze ljudima kroz besplatne grupne terapije, cime se rijetko koji  razvojni centar moze pohvaliti, a meni dodatno uliva povjerenje, i potvrdjuje da sam pametno izabrala.
Birajuci ovaj centar, birate da krenete putem promjene kojoj tezite.',
    'Već duže vreme tražim psihoterapeuta koji bi me istinski razumeo i pomogao. U Razvojnom centru Integra pronašao sam spoj stručnosti, profesionalnosti, iskustva i empatije.
Već pri prvom susretu sa psihoterapeutom Markom osetila sam njegovu potpunu posvećenost, sigurnost, prihvatanje i iskreno razumevanje.
Danas, kada je za mnoge ovaj posao samo posao, Marko kao da se vodi pre svega ljudskim i etičkim vrednostima. To potvrđuje i činjenica da nesebično pomaže ljudima kroz besplatnu grupnu terapiju, čime se malo koji razvojni centar može pohvaliti, a to mi dodatno uliva poverenje i potvrđuje da sam se mudro opredelio.
Izborom ovog centra, birate da krenete putem promene kojoj težite.', 'Већ дуже време тражим психотерапеута који би ме истински разумео и помогао. У Развојном центру Интегра пронашао сам спој стручности, професионалности, искуства и емпатије.
Већ при првом сусрету са психотерапеутом Марком осетила сам његову потпуну посвећеност, сигурност, прихватање и искрено разумевање.
Данас, када је за многе овај посао само посао, Марко као да се води пре свега људским и етичким вредностима. То потврђује и чињеница да несебично помаже људима кроз бесплатну групну терапију, чиме се мало који развојни центар може похвалити, а то ми додатно улива поверење и потврђује да сам се мудро определио.
Избором овог центра, бирате да кренете путем промене којој тежите.', NULL, NULL, NULL, NULL,
    0, '2025-04-03 13:59:14'),

(@user_ivan_bijelic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhf2cS1jtTRMRDmrZU-NvYao/reviews/Ci9DQUlRQUNvZENodHljRjlvT210T2JGUTJlbkJFTWxkalVYZEhUMjlQZUhnM09IYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-09-10 14:29:26'),

(@user_slaven_jovanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhf2cS1jtTRMRDmrZU-NvYao/reviews/ChdDSUhNMG9nS0VJQ0FnTURBMDY3MHdBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-02-11 16:44:11'),

(@user_nada_minjevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhf2cS1jtTRMRDmrZU-NvYao/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxeVRVMHRTMk5wUjJoUmJFOXdZMlpwUlZVelprRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_dali_mrva, @clinic_id, NULL, 'google_maps',
    'places/ChIJhf2cS1jtTRMRDmrZU-NvYao/reviews/Ci9DQUlRQUNvZENodHljRjlvT2poemNrMDNMV1pRYjFsNFUxUlhaMm8zUVVkbU9XYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_maja_djuretic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhf2cS1jtTRMRDmrZU-NvYao/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKbWFFRldTbFJpZEdSZlQweENhRTlhWlVacFFrRRAB',
    5, 'bs', 'Prijatna i podržavajuća atmosfera, posvećenost i razumijevanje.',
    'Prijatna i podržavajuća atmosfera, posvećenost i razumijevanje.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_momcilo_corsovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhf2cS1jtTRMRDmrZU-NvYao/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGWmJFSndiMmMyYVhjM2RWQkZNbkZmTTNkV1RGRRAB',
    5, 'hr', 'Sve pohvale za cijeli tim Integrinih terapeuta.',
    'Sve pohvale za cijeli tim Integrinih terapeuta.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_ksenija_vesovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhf2cS1jtTRMRDmrZU-NvYao/reviews/ChdDSUhNMG9nS0VJQ0FnTURBNDR1RG53RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ruzica_draganic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhf2cS1jtTRMRDmrZU-NvYao/reviews/ChdDSUhNMG9nS0VJQ0FnTURBbmJ1RnlRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dalibor_tomic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhf2cS1jtTRMRDmrZU-NvYao/reviews/ChdDSUhNMG9nS0VJQ0FnTURBbmV2ZWhRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_nikola_perovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhf2cS1jtTRMRDmrZU-NvYao/reviews/ChZDSUhNMG9nS0VJQ0FnSUQzeDQ2SkNnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
