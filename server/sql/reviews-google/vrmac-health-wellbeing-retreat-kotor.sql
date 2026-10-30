-- Insert Google Maps reviews for Health & Wellbeing Retreat de ‘Mar - Vrmac
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/vrmac-health-wellbeing-retreat-kotor.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'vrmac-health-wellbeing-retreat-kotor');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_marina_delic = (SELECT id FROM doctors WHERE slug = 'marina-delic');
SET @doctor_jovana_vukovic = (SELECT id FROM doctors WHERE slug = 'jovana-vukovic');
SET @doctor_fedis_kardovic = (SELECT id FROM doctors WHERE slug = 'fedis-kardovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'BLISS GAIA', 'https://lh3.googleusercontent.com/a/ACg8ocI18TEMp-PDEfyF-9Mo-xm95Po-BO7-6XQO0HQsOH7j-yOP4Q=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/114227139686140718370/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114227139686140718370/reviews');
SET @user_bliss_gaia = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114227139686140718370/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sinisa Mihajlovic', 'https://lh3.googleusercontent.com/a/ACg8ocIjCA5KyuQJqCFUZWyCmytvSU9dZOdF4MyS3WItiZzmXcptYw=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/103042444833824623673/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103042444833824623673/reviews');
SET @user_sinisa_mihajlovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103042444833824623673/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra Nenadic', 'https://lh3.googleusercontent.com/a-/ALV-UjXm13E9bLj1HDJ32wrZ6zHSNn6f67DSXZhHxEE7buF_2cF9NHKm=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/101493123305331388512/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101493123305331388512/reviews');
SET @user_aleksandra_nenadic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101493123305331388512/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ekaj', 'https://lh3.googleusercontent.com/a-/ALV-UjXrMeOvBvFX84U6CPmAIB-X61gLKcWaRksfLO-fib9IkPh4iQ3D=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108851085794351383211/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108851085794351383211/reviews');
SET @user_ekaj = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108851085794351383211/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jamila Vidas', 'https://lh3.googleusercontent.com/a/ACg8ocLQLvTBehfu_hZz6iUJj96zJog3-tYYZeeSMazQENTKeyyR8Q=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105824441953859451859/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105824441953859451859/reviews');
SET @user_jamila_vidas = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105824441953859451859/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Urban Media', 'https://lh3.googleusercontent.com/a-/ALV-UjUWcJxhVEtIK77Rxw2ugxBDUZBiVsO10HoOdCOo25ytt9VKFpQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116796291695450929134/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116796291695450929134/reviews');
SET @user_urban_media = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116796291695450929134/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dara Dzokic', 'https://lh3.googleusercontent.com/a/ACg8ocIkNP-FqVHpVbZuKIOaztew9pTrGvnULay0Dv-sxZSK3wYRlQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106398037476919957794/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106398037476919957794/reviews');
SET @user_dara_dzokic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106398037476919957794/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Chiave NS', 'https://lh3.googleusercontent.com/a/ACg8ocIiCYkLYG3tSFfed4wa1jWwkQWTrtsaFSfblrgGJmV_pzLLPw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109257329860821234700/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109257329860821234700/reviews');
SET @user_chiave_ns = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109257329860821234700/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Frazer Brookes', 'https://lh3.googleusercontent.com/a-/ALV-UjV5Gg7lMoQvS8A3wxxWM71EvWOkxm48QxsSV38Kuxxry4LE8z5d=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106097450215588344720/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106097450215588344720/reviews');
SET @user_frazer_brookes = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106097450215588344720/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_bliss_gaia, @clinic_id, NULL, 'google_maps',
    'places/ChIJAQAAZAo0TBMRgstKSiF85iY/reviews/ChZDSUhNMG9nS0VJQ0FnSUR2ckludERBEAE',
    5, 'en', 'I had the pleasure of experiencing the Vrmac Health and Wellbeing Centre at the Hyatt Hotel in Kotor, and it was nothing short of exceptional. From the moment I arrived, it was clear that this is a place where the focus is entirely on the wellbeing and recovery of its guests.

The centre is staffed by an incredibly skilled team of doctors and physiotherapists, each one bringing years of experience to help support your body’s recovery. Whether you’re seeking rehabilitation, relief from chronic pain, or simply want to rejuvenate, they offer personalized care tailored to your needs. The centre is also equipped with state-of-the-art technology for physical medicine, ensuring that every treatment is delivered with the highest level of expertise.

What truly sets Vrmac apart is the genuine care and attention you receive from every member of the team. The doctors, physiotherapists, and all the staff go above and beyond to make you feel not only physically better but also emotionally nurtured. Their warmth and professionalism create a comforting and reassuring environment that truly enhances the healing process.

In addition to the medical services, the centre offers a variety of beauty treatments and soothing massages, which complement the health services perfectly. After a session, you can unwind in the hotel’s luxurious facilities, including the serene pool, the rejuvenating spa, and the breathtaking natural surroundings of Kotor. The stunning views of the bay and the nearby mountains only add to the sense of peace and relaxation.

If you’re looking for a holistic approach to health, relaxation, and recovery, Vrmac Health and Wellbeing Centre at the Hyatt Hotel in Kotor is an absolute gem. It offers not just top-tier medical services but a comprehensive experience for both body and mind. I left feeling completely restored and with a deep sense of gratitude for the care and attention I received.
Highly recommended!',
    'Imao sam zadovoljstvo da doživim Dom zdravlja i blagostanja Vrmac u hotelu Hajat u Kotoru, i to je bilo izuzetno. Od trenutka kada sam stigao, bilo je jasno da je ovo mesto gde je u potpunosti fokus na dobrobiti i oporavku gostiju.

U Centru radi neverovatno vešt tim lekara i fizioterapeuta, od kojih svaki donosi godine iskustva kako bi pomogao u oporavku vašeg tela. Bez obzira da li tražite rehabilitaciju, oslobađanje od hroničnog bola ili jednostavno želite da se podmladite, oni nude personalizovanu negu prilagođenu vašim potrebama. Centar je takođe opremljen najsavremenijom tehnologijom za fizikalnu medicinu, osiguravajući da se svaki tretman pruža uz najviši nivo stručnosti.

Ono što Vrmac istinski izdvaja je iskrena briga i pažnja koju dobijate od svakog člana tima. Lekari, fizioterapeuti i svo osoblje rade sve više kako bi se osećali ne samo fizički bolje nego i emocionalno negovani. Njihova toplina i profesionalizam stvaraju utešno i umirujuće okruženje koje zaista poboljšava proces lečenja.

Pored medicinskih usluga, centar nudi razne kozmetičke tretmane i umirujuće masaže, koje savršeno dopunjuju zdravstvene usluge. Nakon sesije, možete se opustiti u luksuznim hotelskim sadržajima, uključujući spokojan bazen, spa centar za podmlađivanje i prirodno okruženje Kotora koji oduzima dah. Zapanjujući pogledi na zaliv i obližnje planine samo doprinose osećaju mira i opuštanja.

Ako tražite holistički pristup zdravlju, relaksaciji i oporavku, centar zdravlja i blagostanja Vrmac u hotelu Hajat u Kotoru je pravi dragulj. Nudi ne samo vrhunske medicinske usluge, već i sveobuhvatno iskustvo za telo i um. Otišao sam osećajući se potpuno obnovljen i sa dubokim osećajem zahvalnosti za brigu i pažnju koju sam dobio.
Toplo se preporučuje!', 'Имао сам задовољство да доживим Дом здравља и благостања Врмац у хотелу Хајат у Котору, и то је било изузетно. Од тренутка када сам стигао, било је јасно да је ово место где је у потпуности фокус на добробити и опоравку гостију.

У Центру ради невероватно вешт тим лекара и физиотерапеута, од којих сваки доноси године искуства како би помогао у опоравку вашег тела. Без обзира да ли тражите рехабилитацију, ослобађање од хроничног бола или једноставно желите да се подмладите, они нуде персонализовану негу прилагођену вашим потребама. Центар је такође опремљен најсавременијом технологијом за физикалну медицину, осигуравајући да се сваки третман пружа уз највиши ниво стручности.

Оно што Врмац истински издваја је искрена брига и пажња коју добијате од сваког члана тима. Лекари, физиотерапеути и сво особље раде све више како би се осећали не само физички боље него и емоционално неговани. Њихова топлина и професионализам стварају утешно и умирујуће окружење које заиста побољшава процес лечења.

Поред медицинских услуга, центар нуди разне козметичке третмане и умирујуће масаже, које савршено допуњују здравствене услуге. Након сесије, можете се опустити у луксузним хотелским садржајима, укључујући спокојан базен, спа центар за подмлађивање и природно окружење Котора који одузима дах. Запањујући погледи на залив и оближње планине само доприносе осећају мира и опуштања.

Ако тражите холистички приступ здрављу, релаксацији и опоравку, центар здравља и благостања Врмац у хотелу Хајат у Котору је прави драгуљ. Нуди не само врхунске медицинске услуге, већ и свеобухватно искуство за тело и ум. Отишао сам осећајући се потпуно обновљен и са дубоким осећајем захвалности за бригу и пажњу коју сам добио.
Топло се препоручује!', 'I had the pleasure of experiencing the Vrmac Health and Wellbeing Centre at the Hyatt Hotel in Kotor, and it was nothing short of exceptional. From the moment I arrived, it was clear that this is a place where the focus is entirely on the wellbeing and recovery of its guests.

The centre is staffed by an incredibly skilled team of doctors and physiotherapists, each one bringing years of experience to help support your body’s recovery. Whether you’re seeking rehabilitation, relief from chronic pain, or simply want to rejuvenate, they offer personalized care tailored to your needs. The centre is also equipped with state-of-the-art technology for physical medicine, ensuring that every treatment is delivered with the highest level of expertise.

What truly sets Vrmac apart is the genuine care and attention you receive from every member of the team. The doctors, physiotherapists, and all the staff go above and beyond to make you feel not only physically better but also emotionally nurtured. Their warmth and professionalism create a comforting and reassuring environment that truly enhances the healing process.

In addition to the medical services, the centre offers a variety of beauty treatments and soothing massages, which complement the health services perfectly. After a session, you can unwind in the hotel’s luxurious facilities, including the serene pool, the rejuvenating spa, and the breathtaking natural surroundings of Kotor. The stunning views of the bay and the nearby mountains only add to the sense of peace and relaxation.

If you’re looking for a holistic approach to health, relaxation, and recovery, Vrmac Health and Wellbeing Centre at the Hyatt Hotel in Kotor is an absolute gem. It offers not just top-tier medical services but a comprehensive experience for both body and mind. I left feeling completely restored and with a deep sense of gratitude for the care and attention I received.
Highly recommended!', NULL, NULL, NULL,
    1, '2024-12-18 09:29:35'),

(@user_sinisa_mihajlovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJAQAAZAo0TBMRgstKSiF85iY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNKLV9iVzhBRRAB',
    5, 'hr', 'Kao što se vidi na mojim slikama od 3.7.2023., sada je to Hotel HYATT REGENCY.
Ima i punjač za eletrične automobile.',
    'Kao što možete videti na mojim slikama od 3.7.2023, to je sada hotel HYATT REGENCY.
Takođe ima punjač za električne automobile.', 'Као што можете видети на мојим сликама од 3.7.2023, то је сада хотел HYATT REGENCY.
Такође има пуњач за електричне аутомобиле.', NULL, NULL, NULL, NULL,
    0, '2023-07-05 21:58:12'),

(@user_aleksandra_nenadic, @clinic_id, NULL, 'google_maps',
    'places/ChIJAQAAZAo0TBMRgstKSiF85iY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNyaVBMUktREAE',
    5, 'en', 'Modern rehab and wellness centre with great staff and service, superb diagnostics and doctor led teams. Great programs and encompassed within Hyatt Regency Kotor Bay Resort complex. Highly recommended for wellbeing programs as well as medical treatments. They have anti ageing and cosmetic treatments and an array of body shaping treatments and take great care in focusing on your personalized plan and program.',
    'Moderan rehabilitacioni i velnes centar sa odličnim osobljem i uslugom, vrhunskom dijagnostikom i timovima predvođenim lekarima. Odlični programi i obuhvaćeni u kompleksu Hiatt Regenci Kotor Bai Resort. Veoma se preporučuje za programe blagostanja, kao i za medicinske tretmane. Imaju tretmane protiv starenja i kozmetičke tretmane i niz tretmana za oblikovanje tela i veoma pažljivo se fokusiraju na vaš personalizovani plan i program.', 'Модеран рехабилитациони и велнес центар са одличним особљем и услугом, врхунском дијагностиком и тимовима предвођеним лекарима. Одлични програми и обухваћени у комплексу Хиатт Регенци Котор Баи Ресорт. Веома се препоручује за програме благостања, као и за медицинске третмане. Имају третмане против старења и козметичке третмане и низ третмана за обликовање тела и веома пажљиво се фокусирају на ваш персонализовани план и програм.', 'Modern rehab and wellness centre with great staff and service, superb diagnostics and doctor led teams. Great programs and encompassed within Hyatt Regency Kotor Bay Resort complex. Highly recommended for wellbeing programs as well as medical treatments. They have anti ageing and cosmetic treatments and an array of body shaping treatments and take great care in focusing on your personalized plan and program.', NULL, NULL, NULL,
    1, '2024-07-03 13:38:28'),

(@user_ekaj, @clinic_id, NULL, 'google_maps',
    'places/ChIJAQAAZAo0TBMRgstKSiF85iY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t0cVV6YzRZbVJLWmxCeVlqVlRSM1ZXZWtOaFZFRRAB',
    5, 'en', 'We had an absolutely wonderful experience with the medical clinic at the Hyatt. My son became ill while we were traveling, and after several stressful days we specifically moved to this hotel because it had an on-site medical clinic. It was the best decision we could have made.
Dr. Marina Delić was thorough, compassionate and took wonderful care of my son. Jovana Vukovic was incredible and kind.  They provided exactly the care he needed, checked in with us, and we finally began to see real improvement.
Being sick far from home can be frightening, and having this level of medical care gave us enormous peace of mind. We are incredibly grateful to the entire team. Truly outstanding care.
And the hotel itself? So lovely—with pools, beaches, restaurants and everything we could possibly need in recovery mode. Highly recommend!!!',
    NULL, NULL, 'We had an absolutely wonderful experience with the medical clinic at the Hyatt. My son became ill while we were traveling, and after several stressful days we specifically moved to this hotel because it had an on-site medical clinic. It was the best decision we could have made.
Dr. Marina Delić was thorough, compassionate and took wonderful care of my son. Jovana Vukovic was incredible and kind.  They provided exactly the care he needed, checked in with us, and we finally began to see real improvement.
Being sick far from home can be frightening, and having this level of medical care gave us enormous peace of mind. We are incredibly grateful to the entire team. Truly outstanding care.
And the hotel itself? So lovely—with pools, beaches, restaurants and everything we could possibly need in recovery mode. Highly recommend!!!', NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_jamila_vidas, @clinic_id, NULL, 'google_maps',
    'places/ChIJAQAAZAo0TBMRgstKSiF85iY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GUmFqZFlaUzEwT1d4bFpYSkxSRVJHWkVGaFVXYxAB',
    5, 'en', 'Words cannot truly describe how extraordinary Dr. Delic and her team—Ivana, Jovana & Fedis—are.It is honestly no exaggeration when I say: they saved my life.I ended up in Dr. Delic\'s hands at the very last minute with acute burnout. I don\'t even know exactly what happened next, but I was welcomed with so much incredible love, care, warmth, and extreme competence. I was treated for three weeks and stabilized so well that I was already able to ease back into light work after just two weeks.

I have experienced many medical treatments and therapists both in Germany and abroad, but I have rarely encountered such a combination of profound humanity and professional expertise in a team. With every single one of them, I felt so incredibly valued as an individual, with deep empathy and great care, that my nervous system truly reset—all set against the breathtaking backdrop of the Bay of Kotor.

Dear Dr. Delic, dear Ivana, dearest Jovana, dearest Fedis: thank you so much for everything. My body and I are already looking forward to coming back. You are true angels, and I am filled with so much gratitude for your dedication during one of the most difficult phases of my life. Because of you, I have found hope again that I can make it!

See you soon, your Mila.',
    NULL, NULL, 'Words cannot truly describe how extraordinary Dr. Delic and her team—Ivana, Jovana & Fedis—are.It is honestly no exaggeration when I say: they saved my life.I ended up in Dr. Delic\'s hands at the very last minute with acute burnout. I don\'t even know exactly what happened next, but I was welcomed with so much incredible love, care, warmth, and extreme competence. I was treated for three weeks and stabilized so well that I was already able to ease back into light work after just two weeks.

I have experienced many medical treatments and therapists both in Germany and abroad, but I have rarely encountered such a combination of profound humanity and professional expertise in a team. With every single one of them, I felt so incredibly valued as an individual, with deep empathy and great care, that my nervous system truly reset—all set against the breathtaking backdrop of the Bay of Kotor.

Dear Dr. Delic, dear Ivana, dearest Jovana, dearest Fedis: thank you so much for everything. My body and I are already looking forward to coming back. You are true angels, and I am filled with so much gratitude for your dedication during one of the most difficult phases of my life. Because of you, I have found hope again that I can make it!

See you soon, your Mila.', NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_urban_media, @clinic_id, NULL, 'google_maps',
    'places/ChIJAQAAZAo0TBMRgstKSiF85iY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoYWVIVllSWHB6WmpkQmRsa3phV2g0Ym5kZlZGRRAB',
    1, 'en', 'I would not recommend this place, we had horrible experience with a “doctor” his mane was “bald chernogorec” as he described himself, he was speaking russian tang and did not understand English. Not a real hospital, not a real doctor….this is kindergarten not hospital.',
    NULL, NULL, 'I would not recommend this place, we had horrible experience with a “doctor” his mane was “bald chernogorec” as he described himself, he was speaking russian tang and did not understand English. Not a real hospital, not a real doctor….this is kindergarten not hospital.', NULL, NULL, NULL,
    1, '2026-09-29 00:00:00'),

(@user_dara_dzokic, @clinic_id, @doctor_marina_delic, 'google_maps',
    'places/ChIJAQAAZAo0TBMRgstKSiF85iY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21wTE5ETkxhbWg1UjIxWmVteHpMVmgwVDAxV09XYxAB',
    5, 'bs', 'Letovanje i Vrmac centar dobitna kombinacija 2026.god.Fantastičan program divne dr.Marine Delić učinio je da se osećam preporođeno,opušteno i spremno za nove obaveze..Mislim da je ovo mesto gde ću se sigurno vratiti.',
    'Letovanje i Vrmac centar dobitna kombinacija 2026.god.Fantastičan program divne dr.Marine Delić učinio je da se osećam preporođeno,opušteno i spremno za nove obaveze..Mislim da je ovo mesto gde ću se sigurno vratiti.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_chiave_ns, @clinic_id, NULL, 'google_maps',
    'places/ChIJAQAAZAo0TBMRgstKSiF85iY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pCVlUyNXpWazB0VUY5eWNGQldPRUp0T0dZMlMzYxAB',
    5, 'bs', 'Divno iskustvo i veliko olaksanje,posle puno godina, uspeli su da mi smanje osecaj bola u ledjima i povecaju pokretljivost.Hvala svima a posebno doktorki Delic, terapeutima Fedisu i Jovani.Toplo preporucujem ovo divno iskustvo isceljivanja i druzenja',
    'Divno iskustvo i veliko olaksanje,posle puno godina, uspeli su da mi smanje osecaj bola u ledjima i povecaju pokretljivost.Hvala svima a posebno doktorki Delic, terapeutima Fedisu i Jovani.Toplo preporucujem ovo divno iskustvo isceljivanja i druzenja', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_frazer_brookes, @clinic_id, NULL, 'google_maps',
    'places/ChIJAQAAZAo0TBMRgstKSiF85iY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tKblIycEhkM0oyVlRKTExUaEVObmN4YUUxVmFIYxAB',
    5, 'en', 'Fedi the Physio was incredible. I arrived with a big problem with my neck. After only 2 sessions it felt as good as new.',
    NULL, NULL, 'Fedi the Physio was incredible. I arrived with a big problem with my neck. After only 2 sessions it felt as good as new.', NULL, NULL, NULL,
    0, '2026-06-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
