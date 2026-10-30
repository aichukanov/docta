-- Insert Google Maps reviews for Stomatološka ordinacija - Dent-ES
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dent-es-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dent-es-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Maraš', 'https://lh3.googleusercontent.com/a/ACg8ocIA7UXPpNmK51JGrTbvRufcu6wHl_aBGa8r_ZU3Mckffr9ezqQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/117008766301284386898/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117008766301284386898/reviews');
SET @user_maja_mara = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117008766301284386898/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jummy Co', 'https://lh3.googleusercontent.com/a/ACg8ocITrxsS5A3ZPTYKPaEvnbU8Npor6sq8pLkF70Fn_qZuNVygYA=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/112486327495990997556/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112486327495990997556/reviews');
SET @user_jummy_co = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112486327495990997556/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Monika Vavroch', 'https://lh3.googleusercontent.com/a/ACg8ocJAnyQCCRmETC9YPLi50fBMMGGC9hIJJFukvxJMzgi5ziV9TQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/100467131316795392833/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100467131316795392833/reviews');
SET @user_monika_vavroch = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100467131316795392833/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'KURWА', 'https://lh3.googleusercontent.com/a-/ALV-UjVQ50qWDBdR-lsYvrIszzR44xYiQ7A1xQ7-uJ5sFtFJYs6sL9St=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/116134958678994756772/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116134958678994756772/reviews');
SET @user_kurwa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116134958678994756772/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tatiana Zatochnaia', 'https://lh3.googleusercontent.com/a/ACg8ocL__Zil6ZLKusdZiEG3m2JJDstcPzoTHg0kHZeVIJapzGJWEw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/117860173413004871812/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117860173413004871812/reviews');
SET @user_tatiana_zatochnaia = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117860173413004871812/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radius Neptus', 'https://lh3.googleusercontent.com/a/ACg8ocLy6ZA6yyUSxBWqAHKjC3VjVO4wyLSEpXAZ2baD2ldhuW-nIA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109239481872998226978/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109239481872998226978/reviews');
SET @user_radius_neptus = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109239481872998226978/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Мариjа Вуянович', 'https://lh3.googleusercontent.com/a/ACg8ocJaV2NM_TkNlRF-WprBSu0dsZPg4lgrESHM3aJadQCteEibHw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104185847590532835070/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104185847590532835070/reviews');
SET @user_marija_vuyanovich = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104185847590532835070/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Slavica Vukicevic', 'https://lh3.googleusercontent.com/a-/ALV-UjW2voV8OP53upQi83Bg49wIyV75IUmkFh71fic2f_fywcuV_OhP=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103900993125431041644/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103900993125431041644/reviews');
SET @user_slavica_vukicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103900993125431041644/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Gorica Bestic', 'https://lh3.googleusercontent.com/a-/ALV-UjWm27vJzqRr3IhfA-wCcnEky9IN1j798vAWv5DXONKW5ZVnmEFV5w=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111173993394348756781/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111173993394348756781/reviews');
SET @user_gorica_bestic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111173993394348756781/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Džemil Pejčinović', 'https://lh3.googleusercontent.com/a-/ALV-UjVWztVi6u6jLgo4nhFQFoFnSQvv8DKt6RDXRxzwayUKjwthKpA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110065200177253480439/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110065200177253480439/reviews');
SET @user_demil_pejinovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110065200177253480439/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana D', 'https://lh3.googleusercontent.com/a/ACg8ocJdxQBSLCXjU1Hptyh8pCLxO6bE55y440s605LfsN7Hq7X7WA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101184063187355575425/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101184063187355575425/reviews');
SET @user_ana_d = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101184063187355575425/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragan Pantovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXhPmVRKqroxT4wKpRV55Bgl6Pu-BPC4FJ2mVTciXiNMRnXgw7E=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107206099302916930600/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107206099302916930600/reviews');
SET @user_dragan_pantovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107206099302916930600/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branka Andjušić', 'https://lh3.googleusercontent.com/a/ACg8ocJcVlzvR6nG1jnCr8_dvh6Oekpqp5QG38RO8kfShcKMYXYMSg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112907350412487137988/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112907350412487137988/reviews');
SET @user_branka_andjui = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112907350412487137988/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_maja_mara, @clinic_id, NULL, 'google_maps',
    'places/ChIJyzoiodjqTRMRkYqHpi_xiNU/reviews/ChdDSUhNMG9nS0VJQ0FnTUN3OU8tMmx3RRAB',
    1, 'sr', '👎👎👎',
    '👎👎👎', '👎👎👎', NULL, NULL, NULL, NULL,
    0, '2025-03-17 00:51:32'),

(@user_jummy_co, @clinic_id, NULL, 'google_maps',
    'places/ChIJyzoiodjqTRMRkYqHpi_xiNU/reviews/ChZDSUhNMG9nS0VJQ0FnSUNKbExQaUpREAE',
    1, 'en', 'I would rather kill myself than come here again. I feel more pain after the visit than ever before. Doctor handled me with no care

Update: I went to a more expensive looking clinic Sotir and the cavities treatment costs there 45 euros and the experience was far less painful, and here I had to pay 80 euros for an awful treatment so there\'s absolutely no reason to go to this clinic',
    'Radije bih se ubio nego ponovo došao ovde. Osećam više bola posle posete nego ikad pre. Doktor me je tretirao bez brige.

Ažuriranje: Otišao sam u skuplju kliniku Sotir i lečenje karijesa tamo košta 45 evra i iskustvo je bilo daleko manje bolno, a ovde sam morao da platim 80 evra za užasan tretman, tako da nema apsolutno nikakvog razloga da idem u ovu kliniku.', 'Радије бих се убио него поново дошао овде. Осећам више бола после посете него икад пре. Доктор ме је третирао без бриге.

Ажурирање: Отишао сам у скупљу клинику Сотир и лечење каријеса тамо кошта 45 евра и искуство је било далеко мање болно, а овде сам морао да платим 80 евра за ужасан третман, тако да нема апсолутно никаквог разлога да идем у ову клинику.', 'I would rather kill myself than come here again. I feel more pain after the visit than ever before. Doctor handled me with no care

Update: I went to a more expensive looking clinic Sotir and the cavities treatment costs there 45 euros and the experience was far less painful, and here I had to pay 80 euros for an awful treatment so there\'s absolutely no reason to go to this clinic', NULL, NULL, NULL,
    0, '2023-06-23 06:39:23'),

(@user_monika_vavroch, @clinic_id, NULL, 'google_maps',
    'places/ChIJyzoiodjqTRMRkYqHpi_xiNU/reviews/ChdDSUhNMG9nS0VJQ0FnSUNlc2VtVTZ3RRAB',
    5, 'en', 'I’m a visitor from Czech republic who came to this dentist emergency. I was in big pain, the doctor gave me an excellent treatment without any wait. Both the nurse and the doctor were very kind and helpful. They offered a follow-up. One of the best dentist office I have ever been to. Top-end service!',
    'Ja sam posetilac iz Češke Republike koji je došao na ovu stomatološku hitnu pomoć. Imao sam jake bolove, doktor mi je pružio odličan tretman bez ikakvog čekanja. I medicinska sestra i doktor su bili veoma ljubazni i uslužni. Ponudili su praćenje. Jedna od najboljih stomatoloških ordinacija u kojima sam ikada bio. Vrhunska usluga!', 'Ја сам посетилац из Чешке Републике који је дошао на ову стоматолошку хитну помоћ. Имао сам јаке болове, доктор ми је пружио одличан третман без икаквог чекања. И медицинска сестра и доктор су били веома љубазни и услужни. Понудили су праћење. Једна од најбољих стоматолошких ординација у којима сам икада био. Врхунска услуга!', 'I’m a visitor from Czech republic who came to this dentist emergency. I was in big pain, the doctor gave me an excellent treatment without any wait. Both the nurse and the doctor were very kind and helpful. They offered a follow-up. One of the best dentist office I have ever been to. Top-end service!', NULL, NULL, NULL,
    2, '2022-09-16 19:06:24'),

(@user_kurwa, @clinic_id, NULL, 'google_maps',
    'places/ChIJyzoiodjqTRMRkYqHpi_xiNU/reviews/ChZDSUhNMG9nS0VJQ0FnSURlaGYzYVVREAE',
    5, 'ru', 'Постоянный запах курева и мертвой крысы на последнем этаже
Я конечно не против, все клево
А также прошу восстановить кольцо для баскетбола для детишек во дворе. Детишки не могут  поиграть с мячиком во дворе 🏀',
    'Stalno se oseća miris cigaretnog dima i mrtvih pacova na poslednjem spratu.
Ne smeta mi, naravno, sve je odlično. Takođe vas molim da vratite košarkaški obruč za decu u dvorištu. Deca ne mogu da se igraju loptom u dvorištu. 🏀', 'Стално се осећа мирис цигаретног дима и мртвих пацова на последњем спрату.
Не смета ми, наравно, све је одлично. Такође вас молим да вратите кошаркашки обруч за децу у дворишту. Деца не могу да се играју лоптом у дворишту. 🏀', NULL, 'Постоянный запах курева и мертвой крысы на последнем этаже
Я конечно не против, все клево
А также прошу восстановить кольцо для баскетбола для детишек во дворе. Детишки не могут  поиграть с мячиком во дворе 🏀', NULL, NULL,
    2, '2022-10-14 21:41:50'),

(@user_tatiana_zatochnaia, @clinic_id, NULL, 'google_maps',
    'places/ChIJyzoiodjqTRMRkYqHpi_xiNU/reviews/ChZDSUhNMG9nS0VJQ0FnSUN1bU0zWUN3EAE',
    5, 'en', 'Excellent delicate doctor - helped to solve my problem by 5! without waiting! thank you very much!',
    'Odličan delikatan doktor - pomogao mi je da rešim problem do 5! bez čekanja! hvala vam puno!', 'Одличан деликатан доктор - помогао ми је да решим проблем до 5! без чекања! хвала вам пуно!', 'Excellent delicate doctor - helped to solve my problem by 5! without waiting! thank you very much!', NULL, NULL, NULL,
    1, '2022-07-20 10:20:50'),

(@user_radius_neptus, @clinic_id, NULL, 'google_maps',
    'places/ChIJyzoiodjqTRMRkYqHpi_xiNU/reviews/Ci9DQUlRQUNvZENodHljRjlvT25sblpFUldSM05FVnpOSWMyWm1WRGMwVTFGVmVWRRAB',
    5, 'bs', 'Fantastična usluga,razgovor,pažnja a rade PERFEKTNO,PAŽLJIVO,BEZBOLNO!
SVE NAJBOLJE IMAM ZA CJELOKUPAN TIM A IZDVAJAM Dr. JELENA RAŠKOVIĆ (mlada osoba a profesionalna u svakom smislu službenog poziva)',
    'Fantastična usluga,razgovor,pažnja a rade PERFEKTNO,PAŽLJIVO,BEZBOLNO!
SVE NAJBOLJE IMAM ZA CJELOKUPAN TIM A IZDVAJAM Dr. JELENA RAŠKOVIĆ (mlada osoba a profesionalna u svakom smislu službenog poziva)', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_marija_vuyanovich, @clinic_id, NULL, 'google_maps',
    'places/ChIJyzoiodjqTRMRkYqHpi_xiNU/reviews/Ci9DQUlRQUNvZENodHljRjlvT21salJIRkJPVEl3V0U5a1FXbzRibUpaYkhacVYxRRAB',
    5, 'bs', 'Sve pohvale! Danas nam je dete prvi put uklanjalo karijes i sve je prošlo bez suza i straha! Doktorka ima poseban dar za rad sa decom – odmah je stekla poverenje našeg mališana i učinila da se oseća sigurno i opušteno. Na kraju je cak i dobio diplomu za hrabrost!
Suprug i ja smo oduševljeni i od srca preporučujemo ovu ordinaciju svim roditeljima. Hvala na predivnom iskustvu!',
    'Sve pohvale! Danas nam je dete prvi put uklanjalo karijes i sve je prošlo bez suza i straha! Doktorka ima poseban dar za rad sa decom – odmah je stekla poverenje našeg mališana i učinila da se oseća sigurno i opušteno. Na kraju je cak i dobio diplomu za hrabrost!
Suprug i ja smo oduševljeni i od srca preporučujemo ovu ordinaciju svim roditeljima. Hvala na predivnom iskustvu!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_slavica_vukicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJyzoiodjqTRMRkYqHpi_xiNU/reviews/ChZDSUhNMG9nS0VJQ0FnSURUazRPNmZREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_gorica_bestic, @clinic_id, NULL, 'google_maps',
    'places/ChIJyzoiodjqTRMRkYqHpi_xiNU/reviews/ChZDSUhNMG9nS0VJQ0FnSURCaHZlYkdBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_demil_pejinovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJyzoiodjqTRMRkYqHpi_xiNU/reviews/ChdDSUhNMG9nS0VJQ0FnSURDd3JuTDJBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_ana_d, @clinic_id, NULL, 'google_maps',
    'places/ChIJyzoiodjqTRMRkYqHpi_xiNU/reviews/ChdDSUhNMG9nS0VJQ0FnSURFODcyejJRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_dragan_pantovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJyzoiodjqTRMRkYqHpi_xiNU/reviews/ChdDSUhNMG9nS0VJQ0FnSUN3Z0tPdzVRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_branka_andjui, @clinic_id, NULL, 'google_maps',
    'places/ChIJyzoiodjqTRMRkYqHpi_xiNU/reviews/ChdDSUhNMG9nS0VJQ0FnSUNBbkkzcDVnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2017-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
