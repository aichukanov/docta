-- Insert Google Maps reviews for Internos Medical & Laboratorija
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/internos-medical-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'internos-medical-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Slavka Damjanovic Acin', 'https://lh3.googleusercontent.com/a/ACg8ocJbafyPgTSoYJvQCjxWRNgHdJB3moZi8JoKrms5V_vhuLLyaw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/114862806785957780918/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114862806785957780918/reviews');
SET @user_slavka_damjanovic_acin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114862806785957780918/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Darko Šiljegović', 'https://lh3.googleusercontent.com/a/ACg8ocJGfgVljA-KOwTeQuCqsLfY-BUXFmI94eH7tOPnFZVtX2HUaA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111285851811899701809/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111285851811899701809/reviews');
SET @user_darko_iljegovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111285851811899701809/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Milic', 'https://lh3.googleusercontent.com/a/ACg8ocIuVb2esNLRx389Z6xbJwRRkEF4urW7IJhT4b_MsovXt_eRhg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107191170081057832184/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107191170081057832184/reviews');
SET @user_marko_milic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107191170081057832184/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirjana Stepanovic', 'https://lh3.googleusercontent.com/a/ACg8ocKNCNuoAPGufIcmJV1s7xh43V4rCD45L4cxMXdHDu4PqfyxbQ=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/107012049592337321956/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107012049592337321956/reviews');
SET @user_mirjana_stepanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107012049592337321956/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikolina Martinovic', 'https://lh3.googleusercontent.com/a-/ALV-UjW3lDht8fXcgoByEtl9OqA12nwHhx0Dr4NGj0ugCIiqgvkKoioe=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/115289851692752687595/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115289851692752687595/reviews');
SET @user_nikolina_martinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115289851692752687595/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'natasa paladin', 'https://lh3.googleusercontent.com/a/ACg8ocLwQL-qYw7G66NZNAqIv1R7hguxS2Aq6pelB3RLY-ZBY4YLbA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102927012647084784342/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102927012647084784342/reviews');
SET @user_natasa_paladin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102927012647084784342/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jasmina Dasic', 'https://lh3.googleusercontent.com/a-/ALV-UjXwCbFusaqpfJwmRzC_JYkeJ_y624GtCYFvHRvluGbAiTRDyeV6=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110654922049423140029/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110654922049423140029/reviews');
SET @user_jasmina_dasic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110654922049423140029/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikolina Bojanic', 'https://lh3.googleusercontent.com/a/ACg8ocIkx-UAl4MZRlJiEjXl5VTuDf24yvUFtRUTCYr2C3mcXkmvKA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101894395639143358943/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101894395639143358943/reviews');
SET @user_nikolina_bojanic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101894395639143358943/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Magovčević', 'https://lh3.googleusercontent.com/a/ACg8ocKCGqANSPv5Ftx59FfsGZukwyt989BDBlT2OxZ9h8FHdbvf5Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108756506638821349150/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108756506638821349150/reviews');
SET @user_jelena_magovevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108756506638821349150/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja Dedovic', 'https://lh3.googleusercontent.com/a/ACg8ocL23XQhO7XG12jb_h6wOzzlFeJIyjWmUIRFH_j-pzuOQNxvUQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109775303860269847300/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109775303860269847300/reviews');
SET @user_sanja_dedovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109775303860269847300/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mika Milic', 'https://lh3.googleusercontent.com/a/ACg8ocJv7GtGuP0Tdi0NCORZBl_WBCWGWwAFjXMWFNZw7s_GTUXmZA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101258893447629408288/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101258893447629408288/reviews');
SET @user_mika_milic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101258893447629408288/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Сергей Кривой', 'https://lh3.googleusercontent.com/a-/ALV-UjVmcw0KsPF4zfNI7JUoO0wnEyw5mpPLszyrUIzV8tvml6LsveSx=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109362982647342987785/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109362982647342987785/reviews');
SET @user_sergey_krivoy = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109362982647342987785/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'sergej pavicevic', 'https://lh3.googleusercontent.com/a-/ALV-UjVxxXxdRPZVnMUu8E-R5gf-DOPhOuc4tvOPd6Lfb6xyyGh7rcGh=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101559965624507433893/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101559965624507433893/reviews');
SET @user_sergej_pavicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101559965624507433893/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rise Montenegro', 'https://lh3.googleusercontent.com/a-/ALV-UjXBgz_9P2bLOwz2PdmD6YIRumw4u0yqCV9tokNENFXkq727A7cY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105602293898421553616/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105602293898421553616/reviews');
SET @user_rise_montenegro = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105602293898421553616/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'VM', 'https://lh3.googleusercontent.com/a-/ALV-UjV2yaoRDSAs86SwV0g2qOFoIGX2KpEIJ3z5tEfL5AozLrDN3BKq=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111143330932337851829/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111143330932337851829/reviews');
SET @user_vm = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111143330932337851829/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Viktor Marijanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXoiZDoj5yRHNY0IudVAyRTGzjCW_FK8oRZ0ZJ2WsdfScbk3yHmlA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105930457474371169316/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105930457474371169316/reviews');
SET @user_viktor_marijanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105930457474371169316/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Suncica Sinanovic', 'https://lh3.googleusercontent.com/a/ACg8ocLyYebdUvfpdUzDqi6cYbobZpiCuizPejdmvR6YBtQXkPL7fQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110267015962689763666/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110267015962689763666/reviews');
SET @user_suncica_sinanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110267015962689763666/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Masa Mugosa', 'https://lh3.googleusercontent.com/a-/ALV-UjVQBDedKJz1PeTA1KjCdI5qT_6FBqwDRl0KfeOvCHeef6kBWRiYqw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105156630544571781785/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105156630544571781785/reviews');
SET @user_masa_mugosa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105156630544571781785/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_slavka_damjanovic_acin, @clinic_id, NULL, 'google_maps',
    'places/ChIJeTqm7EjrTRMRwOE9-ehR6jo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pCakxXSkpVbEpsY201Q1JHeFZaM1JYU3psTlUxRRAB',
    5, 'hr', 'Kad se pomene Poliklinika Internos Medical samo riječi hvale.Osoblje,menadžment,čista desetka.Posebno mjesto zauzima Jelena Magovcevic,njena profesionalnost,dobrota,ljubaznost .Svaka čast.Tople preporuke jer pacijenti su u najboljim rukama.',
    'Kada se pomene Internos Medikal Poliklinika, padaju mi na pamet samo reči hvale. Osoblje, menadžment, čista desetka. Jelena Magovčević zauzima posebno mesto, njen profesionalizam, ljubaznost i predanost. Svaka čast. Tople preporuke jer su pacijenti u najboljim rukama.', 'Када се помене Интернос Медикал Поликлиника, падају ми на памет само речи хвале. Особље, менаџмент, чиста десетка. Јелена Маговчевић заузима посебно место, њен професионализам, љубазност и преданост. Свака част. Топле препоруке јер су пацијенти у најбољим рукама.', NULL, NULL, NULL, NULL,
    0, '2026-02-17 19:22:22'),

(@user_darko_iljegovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJeTqm7EjrTRMRwOE9-ehR6jo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t0dFdUaDRZbEZaYVZoWVYzZ3RhRzltU214dmFIYxAB',
    5, 'hr', 'Samo rijeci hvale za ovu Polikliniku.Osoblje,cistoca,sve cista petica.Posebna pohvala za Jelenu Magovcevic,plijeni svojom dobrotom i ljubaznocsu',
    'Samo reči hvale za ovu Polikliniku. Osoblje, čistoća, sve je čista petica. Posebne pohvale za Jelenu Magovčević, pleni svojom ljubaznošću i blagošću.', 'Само речи хвале за ову Поликлинику. Особље, чистоћа, све је чиста петица. Посебне похвале за Јелену Маговчевић, плени својом љубазношћу и благошћу.', NULL, NULL, NULL, NULL,
    0, '2026-02-17 19:17:47'),

(@user_marko_milic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeTqm7EjrTRMRwOE9-ehR6jo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKNGJXSnBWMWRHYW5rdFJpMW9aakJ3Wm1GRVVGRRAB',
    5, 'bs', 'Pohvale za labartoriju.Jako brza i precizna labartoriska dijagnostika.',
    'Pohvale za laboratoriju. Veoma brza i precizna laboratorijska dijagnostika.', 'Похвале за лабораторију. Веома брза и прецизна лабораторијска дијагностика.', NULL, NULL, NULL, NULL,
    0, '2025-12-04 09:39:41'),

(@user_mirjana_stepanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeTqm7EjrTRMRwOE9-ehR6jo/reviews/ChZDSUhNMG9nS0VPYURvSTZqdU8zcVhREAE',
    1, 'bs', 'Neprofesionalne sestre, cekanje na red vise od 1h, iako sam imala zakazan termin kod doktora. Iskreno za nase pare ,mozemo da biramo kliniku ima mnogo boljih u PG.',
    'Neprofesionalne medicinske sestre, čekanje u redu duže od 1 sata, iako sam imala zakazan termin kod lekara. Iskreno, za naš novac, možemo da biramo kliniku, ima mnogo boljih u PG.', 'Непрофесионалне медицинске сестре, чекање у реду дуже од 1 сата, иако сам имала заказан термин код лекара. Искрено, за наш новац, можемо да бирамо клинику, има много бољих у ПГ.', NULL, NULL, NULL, NULL,
    0, '2025-06-08 05:51:35'),

(@user_nikolina_martinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeTqm7EjrTRMRwOE9-ehR6jo/reviews/ChdDSUhNMG9nS0VJQ0FnTURBOEthR2x3RRAB',
    1, 'bs', 'Izuzetna nekultura i neprofesionalost od strane djevojke koja radi na recepciji.

Da je radila na znanju, koliko na ustima, bilo bi odlicno.',
    'Izuzetna grubost i neprofesionalnost devojke koja radi na recepciji.

Da je radila na znanju, koliko na rečima, bilo bi odlično.', 'Изузетна грубост и непрофесионалност девојке која ради на рецепцији.

Да је радила на знању, колико на речима, било би одлично.', NULL, NULL, NULL, NULL,
    0, '2025-02-06 11:37:10'),

(@user_natasa_paladin, @clinic_id, NULL, 'google_maps',
    'places/ChIJeTqm7EjrTRMRwOE9-ehR6jo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25ReVptUjJOakYzY0hKMlRuVmhRblZaZFMwdGIxRRAB',
    1, 'bs', 'Bjezite sto dalje od ginekologa Jokmanovica! Godinu ipo dana je vukao moju majku za nos pod izgovorom da ne moze da je operise zbog eserihije koju je evidentno imala zbog ginekoloskih problema a ne zbog loseg imuniteta! Godinu ipo je pila antibiotike uzalud, i sto je najgore od svega, stanje joj se na kraju zakomplikovalo pa je imala hitnu operaciju. Nesposobnjakovic, izuzetno smo razocarani njegovim neznanjem, kao da je pocetnik a ne djed od 70 godina! Na srecu, uspjesno ju je operisala doktorka Vesovic u Baru, a ti Jokmanovicu sto prije u penziju!!',
    'Bjezite sto dalje od ginekologa Jokmanovica! Godinu ipo dana je vukao moju majku za nos pod izgovorom da ne moze da je operise zbog eserihije koju je evidentno imala zbog ginekoloskih problema a ne zbog loseg imuniteta! Godinu ipo je pila antibiotike uzalud, i sto je najgore od svega, stanje joj se na kraju zakomplikovalo pa je imala hitnu operaciju. Nesposobnjakovic, izuzetno smo razocarani njegovim neznanjem, kao da je pocetnik a ne djed od 70 godina! Na srecu, uspjesno ju je operisala doktorka Vesovic u Baru, a ti Jokmanovicu sto prije u penziju!!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_jasmina_dasic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeTqm7EjrTRMRwOE9-ehR6jo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pZNFdqbHVTM0pDTUdscmFFeGtTRlpXZFRCQloxRRAB',
    5, 'en', 'I truly cannot thank Internos Medical Laboratory and Dr. Raičević enough for the wonderful care and support I received throughout my entire pregnancy.

From my very first visit until the end of my pregnancy, I always felt that I was in safe, caring, and professional hands. Dr. Raičević was incredibly kind, patient, attentive, and thorough. Every appointment gave me reassurance and confidence, and I always felt that my concerns were listened to and taken seriously.

The entire team at Internos was wonderful. Everyone was welcoming, respectful, and compassionate, and they created an environment where I always felt comfortable and cared for. During such an important and emotional period of my life, their professionalism and kindness meant more to me than I can express.

Pregnancy can come with many worries and uncertainties, but having doctors and staff who genuinely care makes such a huge difference. I am extremely grateful for every appointment, every explanation, and every moment of reassurance they gave me.

A special thank you to Dr. Raičević for being such an amazing doctor and for taking such good care of me throughout my pregnancy. I will always remember the kindness, dedication, and professionalism I experienced there.

I wholeheartedly recommend Internos Medical Laboratory and Dr. Raičević to every woman looking for excellent care, compassion, and professionalism. Thank you from the bottom of my heart for making my pregnancy journey feel safer, calmer, and so much more special. ❤️',
    NULL, NULL, 'I truly cannot thank Internos Medical Laboratory and Dr. Raičević enough for the wonderful care and support I received throughout my entire pregnancy.

From my very first visit until the end of my pregnancy, I always felt that I was in safe, caring, and professional hands. Dr. Raičević was incredibly kind, patient, attentive, and thorough. Every appointment gave me reassurance and confidence, and I always felt that my concerns were listened to and taken seriously.

The entire team at Internos was wonderful. Everyone was welcoming, respectful, and compassionate, and they created an environment where I always felt comfortable and cared for. During such an important and emotional period of my life, their professionalism and kindness meant more to me than I can express.

Pregnancy can come with many worries and uncertainties, but having doctors and staff who genuinely care makes such a huge difference. I am extremely grateful for every appointment, every explanation, and every moment of reassurance they gave me.

A special thank you to Dr. Raičević for being such an amazing doctor and for taking such good care of me throughout my pregnancy. I will always remember the kindness, dedication, and professionalism I experienced there.

I wholeheartedly recommend Internos Medical Laboratory and Dr. Raičević to every woman looking for excellent care, compassion, and professionalism. Thank you from the bottom of my heart for making my pregnancy journey feel safer, calmer, and so much more special. ❤️', NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_nikolina_bojanic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeTqm7EjrTRMRwOE9-ehR6jo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GdU9FUXRSbFYzUzNOMlZXOUpVR05zT0hWSU5FRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jelena_magovevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJeTqm7EjrTRMRwOE9-ehR6jo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xscmNVdEtRMEYwYTFJNGRVWnJkRFF3VlZVeGRtYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_sanja_dedovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeTqm7EjrTRMRwOE9-ehR6jo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2sxVVZrUnFUazlCY1VaWmFEQTBiRUU0WDJ4NE4wRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_mika_milic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeTqm7EjrTRMRwOE9-ehR6jo/reviews/ChZDSUhNMG9nS0VNV0s0SjZHemVTeFpBEAE',
    5, 'hr', 'Sve pohvale',
    'Sve pohvale', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_sergey_krivoy, @clinic_id, NULL, 'google_maps',
    'places/ChIJeTqm7EjrTRMRwOE9-ehR6jo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNsdC1qcXhBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_sergej_pavicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeTqm7EjrTRMRwOE9-ehR6jo/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ2LUw3LVVnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_rise_montenegro, @clinic_id, NULL, 'google_maps',
    'places/ChIJeTqm7EjrTRMRwOE9-ehR6jo/reviews/ChZDSUhNMG9nS0VJQ0FnSURTeTlydU13EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_vm, @clinic_id, NULL, 'google_maps',
    'places/ChIJeTqm7EjrTRMRwOE9-ehR6jo/reviews/ChdDSUhNMG9nS0VJQ0FnSURTeTlxcXRnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_viktor_marijanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeTqm7EjrTRMRwOE9-ehR6jo/reviews/ChdDSUhNMG9nS0VJQ0FnSURTeTlyVWtnRRAB',
    5, 'en', '👌🏻',
    NULL, NULL, '👌🏻', NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_suncica_sinanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeTqm7EjrTRMRwOE9-ehR6jo/reviews/ChZDSUhNMG9nS0VJQ0FnSURzb1pTRUxnEAE',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_masa_mugosa, @clinic_id, NULL, 'google_maps',
    'places/ChIJeTqm7EjrTRMRwOE9-ehR6jo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNveHFQMnVRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
