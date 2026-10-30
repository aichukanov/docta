-- Insert Google Maps reviews for Očna bolnica Oftalens Dr Koturović
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/ocna-bolnica-oftalens-dr-koturovic-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'ocna-bolnica-oftalens-dr-koturovic-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_zoran_koturovic = (SELECT id FROM doctors WHERE slug = 'zoran-koturovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljilja Crncevic', 'https://lh3.googleusercontent.com/a/ACg8ocLuEw56CsTs1fqvoilefGZeYD5M7liBNqPyR9G8BTVPw0klUw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/108530226766315020937/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108530226766315020937/reviews');
SET @user_ljilja_crncevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108530226766315020937/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Petar Damljanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWRTEajnpi7G_11W6iziHtyFP9gRyOjiVL-zXM5kFl6IO8rf9awkg=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/110901823938899776137/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110901823938899776137/reviews');
SET @user_petar_damljanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110901823938899776137/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Martinovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXzyTBFQzI77BrupJPfvZeXqS6t3V-L9kkLWVZCMhFa2AtP-GRt=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111995948920894117829/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111995948920894117829/reviews');
SET @user_ana_martinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111995948920894117829/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'T D', 'https://lh3.googleusercontent.com/a-/ALV-UjVDZoDU5vY1lDhATeHghZou8DEAdL6XMpR-chp8xLr6B2boxec=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101788611739161299775/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101788611739161299775/reviews');
SET @user_t_d = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101788611739161299775/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Martina Ivanovic', 'https://lh3.googleusercontent.com/a/ACg8ocKx9OtlWNve_h9s2P4g2O5ilIr500zjLo-cmbARtDLmPsYMLQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101335823034936144735/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101335823034936144735/reviews');
SET @user_martina_ivanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101335823034936144735/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Radulovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWCEVti6z3kbRvtfqRxgWZshM756XBYvXI9lSMmLhaX4qWahlPt=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101991152150491420092/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101991152150491420092/reviews');
SET @user_nikola_radulovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101991152150491420092/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Mimović', 'https://lh3.googleusercontent.com/a-/ALV-UjVswizM5FCjhp1ezpa1AAR-joZq96h_mfNRM7PDvUQpBiUQg4pU=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113207698630802181531/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113207698630802181531/reviews');
SET @user_ivan_mimovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113207698630802181531/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kruska Jedic', 'https://lh3.googleusercontent.com/a/ACg8ocI39t60FSzhG790lG2y_Z7c5q-KCyVuK26NFxTf1OoOpwrOdA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107503624581390600083/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107503624581390600083/reviews');
SET @user_kruska_jedic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107503624581390600083/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'LG Kompanija', 'https://lh3.googleusercontent.com/a/ACg8ocLvtTWG3J1YTSVJ0Ms7KsEujpqaHFozrMvb2lt6Iu_UvHo9hA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101628805336675226531/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101628805336675226531/reviews');
SET @user_lg_kompanija = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101628805336675226531/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jasmin Sulejmanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjX8Dp68TpA50fuP4roo6uEMmtjwOk0dyvcI5vMypUWzeuTsOMI_Pw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102493066175458346784/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102493066175458346784/reviews');
SET @user_jasmin_sulejmanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102493066175458346784/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Emir Kalac', 'https://lh3.googleusercontent.com/a/ACg8ocKMcBZgQQuhYoopIOEGgXb8ZIp7o1z8JIl7O5q7UCzgTyiMjQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105109149139187113985/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105109149139187113985/reviews');
SET @user_emir_kalac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105109149139187113985/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rafet Jasavic', 'https://lh3.googleusercontent.com/a/ACg8ocKeJUCnj9MdQeJbFXznpxGmd62N-ZINrHQ-sA971cRNZqZnqw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113046976955484077874/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113046976955484077874/reviews');
SET @user_rafet_jasavic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113046976955484077874/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Biljana Petanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVfeXgiYJGK6lR1B1jCBXqb0cHFUV_cAdm2MzeMAyl2CY9SCWIp=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107411293200851975032/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107411293200851975032/reviews');
SET @user_biljana_petanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107411293200851975032/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Miloš Rakočević', 'https://lh3.googleusercontent.com/a-/ALV-UjW9-N0HgZXSg5fT4UmBzMgdEgXm-HiQjhdNCOAqI6z3D5_F9etlwg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105474741467032404791/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105474741467032404791/reviews');
SET @user_milo_rakoevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105474741467032404791/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladimir Jovanovic', 'https://lh3.googleusercontent.com/a/ACg8ocKKu4_C0F6x112litONmo3mie-XRKsAqOhs5XchgOFymA_91A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110150944160785011332/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110150944160785011332/reviews');
SET @user_vladimir_jovanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110150944160785011332/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'spasoje rakonjac', 'https://lh3.googleusercontent.com/a/ACg8ocK-YNuwsxxQ8IQMzNBqqe_KCprzvag4XY7nRZ0y32gtVUGtmw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100165792917236941345/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100165792917236941345/reviews');
SET @user_spasoje_rakonjac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100165792917236941345/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'zdravko jasovic', 'https://lh3.googleusercontent.com/a/ACg8ocKr6I4FwyJ77q2s32Tajkum1T2qa2AM6k8H7z5fmOH0zY9AkQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108947474352015040892/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108947474352015040892/reviews');
SET @user_zdravko_jasovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108947474352015040892/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragan Ratkovic', 'https://lh3.googleusercontent.com/a/ACg8ocLVQ-fke8fA0i6_z0US-9y743BGgvIfYTQcIECfokdwm9culYs=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112679496734639954654/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112679496734639954654/reviews');
SET @user_dragan_ratkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112679496734639954654/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Unknown Unknown', 'https://lh3.googleusercontent.com/a/ACg8ocIsXNMyOJ2o25sqT26Z3pmgQp-XSfvY2U92CZERadwBS2u-Og=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109610454643588469801/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109610454643588469801/reviews');
SET @user_unknown_unknown = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109610454643588469801/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mini Traveler', 'https://lh3.googleusercontent.com/a-/ALV-UjVDyYZzCvNevTwoG0_Y7aLSgvtuEv_mW3mRXm05T3m7_M-tkNY=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108575166845021575243/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108575166845021575243/reviews');
SET @user_mini_traveler = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108575166845021575243/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olivera Slavnic', 'https://lh3.googleusercontent.com/a/ACg8ocInnUqZbpNZ63Zyo7CqJ1A81qiwx9Rr_idl14g5T3ZruRrimA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114940260028550227251/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114940260028550227251/reviews');
SET @user_olivera_slavnic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114940260028550227251/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stojan Trajkovski', 'https://lh3.googleusercontent.com/a/ACg8ocJP0tESGPPclu9yNB9GidgT3mKFBpaUd0hsDIocJ89vV1fIvg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104794628246322193357/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104794628246322193357/reviews');
SET @user_stojan_trajkovski = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104794628246322193357/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alo Alo', 'https://lh3.googleusercontent.com/a/ACg8ocItzI7fw4KhECt9fCBqa6tIwdyjJIO8_ugBfK9iIH-hmG8LIQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107071673421233901382/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107071673421233901382/reviews');
SET @user_alo_alo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107071673421233901382/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ALFA Nekretnine', 'https://lh3.googleusercontent.com/a-/ALV-UjU2HrHpbUytKa0PGSXI3Ddqdt2HGmXtcsjhgexpYhb8XOYZzOw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100761076846767187223/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100761076846767187223/reviews');
SET @user_alfa_nekretnine = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100761076846767187223/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mrki Mrki', 'https://lh3.googleusercontent.com/a/ACg8ocL9L4-EaBqn7aKBkf-6TWiJvpkrLy5cGAl3_g_OtOoP5k6TnA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116554425093593266927/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116554425093593266927/reviews');
SET @user_mrki_mrki = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116554425093593266927/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Maksimovic', 'https://lh3.googleusercontent.com/a/ACg8ocK84cLivXinyxzkDM0qkoCZOe21_fEa4ddmNDL-RjnklGgV=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102147169204155921916/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102147169204155921916/reviews');
SET @user_marija_maksimovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102147169204155921916/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nk281 Df', 'https://lh3.googleusercontent.com/a/ACg8ocIh2xEFx4mi6k2ZX1D5xbWM8OjoW9OkhASRkh3E0Gq7nnqJzg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103649004766762750651/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103649004766762750651/reviews');
SET @user_nk281_df = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103649004766762750651/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_ljilja_crncevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/Ci9DQUlRQUNvZENodHljRjlvT21KcGRVTmtXVVZuVEdoUk5WcHFXWE5sYmpoVWJXYxAB',
    1, 'hr', 'Posla sam na pregled ne sluteći da ću posle pogrešne dijagnoze i terapije, sad se boriti za vid na desnom oku.',
    'Otišao sam na pregled, ne sluteći da ću se posle pogrešne dijagnoze i lečenja sada boriti za vid na desnom oku.', 'Отишао сам на преглед, не слутећи да ћу се после погрешне дијагнозе и лечења сада борити за вид на десном оку.', NULL, NULL, NULL, NULL,
    0, '2025-10-24 07:22:35'),

(@user_petar_damljanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/Ci9DQUlRQUNvZENodHljRjlvT25OT1gydHFialkyY25acFVrZFBjRE01Wm5FNVQyYxAB',
    5, 'bs', 'Divno iskustvo! Ljubazno i nasmejano osoblje. Lekar je veoma stručan i posvećen.  Sve objašnjava jasno i pažljivo što uliva veliko poverenje i sigurnost.',
    'Divno iskustvo! Ljubazno i nasmejano osoblje. Doktor je veoma profesionalan i posvećen. Sve jasno i pažljivo objašnjava, što uliva veliko poverenje i sigurnost.', 'Дивно искуство! Љубазно и насмејано особље. Доктор је веома професионалан и посвећен. Све јасно и пажљиво објашњава, што улива велико поверење и сигурност.', NULL, NULL, NULL, NULL,
    0, '2025-08-30 05:31:22'),

(@user_ana_martinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2paR1FrUm5aVlpsY0ZONVRua3dUa2RTVDJWQ1JXYxAB',
    5, 'hr', 'Odličan stručnjak. Sve preporuke!',
    'Odličan stručnjak. Sve preporuke!', 'Одличан стручњак. Све препоруке!', NULL, NULL, NULL, NULL,
    0, '2026-03-06 20:22:04'),

(@user_t_d, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2poYVdsbzNZalZ5UjFCVlJrUnNVR3AxZGpreGRHYxAB',
    5, 'bs', 'Imala sam jako lepo iskustvo u Oftalensu, osoblje je izuzetno ljubazno, a intervencija je prosla odlicno. Jedini savet je da budete uporni oko zakazivanja, jer je ponekad potrebno pozvati nekoliko puta dok ne dobijete termin. 5*',
    'Imao sam veoma lepo iskustvo u Oftalensu, osoblje je izuzetno ljubazno, a procedura je prošla odlično. Jedini savet je da budete uporni oko zakazivanja, jer ponekad morate da zovete nekoliko puta pre nego što dobijete termin. 5*', 'Имао сам веома лепо искуство у Офталенсу, особље је изузетно љубазно, а процедура је прошла одлично. Једини савет је да будете упорни око заказивања, јер понекад морате да зовете неколико пута пре него што добијете термин. 5*', NULL, NULL, NULL, NULL,
    0, '2025-07-17 21:24:17'),

(@user_martina_ivanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSTFZHZG1SR1pXVW5SSUxYaDZiREZ2U1hsRVJVRRAB',
    5, 'hr', 'Jako pristupacni, ljubazni i stručni doktori. Na sva naša pitanja su odmah imali odgovore.
Za svaku preporuku!',
    'Veoma pristupačni, ljubazni i profesionalni lekari. Imali su trenutne odgovore na sva naša pitanja.
Za svaku preporuku!', 'Веома приступачни, љубазни и професионални лекари. Имали су тренутне одговоре на сва наша питања.
За сваку препоруку!', NULL, NULL, NULL, NULL,
    0, '2025-06-19 12:56:11'),

(@user_nikola_radulovic, @clinic_id, @doctor_zoran_koturovic, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2toelowdHNUMTlETlRrMldrbDJWMU14VXpsamRFRRAB',
    5, 'bs', 'Izuzetno iskustvo sa doktorom Koturovićem i osobljem koje je drugi put operisalo moju majku. Doktor je izuzetan čovek i veoma posvećen svom pozivu. Besprekorno su obavili operaciju katarakte, a nakon nje smo dobili detaljno uputstvo o potrebnoj terapiji, navedeno po satima. Pre 5 godina je na drugom oku izvedena dosta komplikovanija operacija ablacije retine, a sada se po ponovnom pregledu ustanovilo da je kvalitet vida ostao na 100% nivou. Zahvalnost i sve preporuke za doktora Koturovića i njegov tim.',
    'Izuzetno iskustvo sa doktorom Koturovićem i osobljem koje je drugi put operisalo moju majku. Doktor je izuzetan čovek i veoma posvećen svom pozivu. Besprekorno su obavili operaciju katarakte, a nakon nje smo dobili detaljno uputstvo o potrebnoj terapiji, navedeno po satima. Pre 5 godina je na drugom oku izvedena dosta komplikovanija operacija ablacije retine, a sada se po ponovnom pregledu ustanovilo da je kvalitet vida ostao na 100% nivou. Zahvalnost i sve preporuke za doktora Koturovića i njegov tim.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-15 00:00:00'),

(@user_ivan_mimovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xnMGJFRnZORTlWVDBOcWRVdHRjVTlSY1U1b2RtYxAB',
    1, 'bs', 'Veoma loše iskustvo. U zakazanom terminu (18:30 h) ordinacija bila zaključana, iako piše da je radno vrijeme popodne od 17 h. Doktor je došao sa dvadeset minuta zakašnjenja, tek nakon mog poziva telefonom. Tokom pregleda nije mi dao odgovore na postavljena pitanja. Pročitao sam na njihovom sajtu da je moguće platiti karticom i nisam ponio novac. Doktor je  insistirao je na plaćanju kešom pa sam se morao vraćati kući za novac.',
    'Veoma loše iskustvo. U zakazanom terminu (18:30 h) ordinacija bila zaključana, iako piše da je radno vrijeme popodne od 17 h. Doktor je došao sa dvadeset minuta zakašnjenja, tek nakon mog poziva telefonom. Tokom pregleda nije mi dao odgovore na postavljena pitanja. Pročitao sam na njihovom sajtu da je moguće platiti karticom i nisam ponio novac. Doktor je  insistirao je na plaćanju kešom pa sam se morao vraćati kući za novac.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_kruska_jedic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWaVNrZzFjV010YmxKeFdYZDNlazFhYTFsR2NtYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_lg_kompanija, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xJMVEwMW1UMFIzWkV4VVgxUndZVll5Y0dKVllXYxAB',
    5, 'hr', 'Odlično sve. Hvala doktoru',
    'Odlično sve. Hvala doktoru', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_jasmin_sulejmanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/Ci9DQUlRQUNvZENodHljRjlvT205QmEzRjZUMUIzTjJoNmR6RldjbXR3Vm5RNFVrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_emir_kalac, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/ChdDSUhNMG9nS0VJQ0FnTUNnNFpTbXVBRRAB',
    1, 'bs', 'Mislim da se tu sve vrti da uzimaju ljudima pare slabo sta pomoci tu ima toliko nestrucno i neljubazno rade da to nigde nema trka niti objasne sta posle njih cega da se pridrzava covjek ako osjete da imas para onda te povrate na kontrolu i vrte te ako nemas onda kazu zao nam je imate jos bolnica privatnih,bjezite na vrijeme za beograd kod ozbiljnih i kvalitetnih doktora kad ti vec uzimaju pare bar ljudi saslusaju i sprovedu sve kako treba',
    'Mislim da se tu sve vrti da uzimaju ljudima pare slabo sta pomoci tu ima toliko nestrucno i neljubazno rade da to nigde nema trka niti objasne sta posle njih cega da se pridrzava covjek ako osjete da imas para onda te povrate na kontrolu i vrte te ako nemas onda kazu zao nam je imate jos bolnica privatnih,bjezite na vrijeme za beograd kod ozbiljnih i kvalitetnih doktora kad ti vec uzimaju pare bar ljudi saslusaju i sprovedu sve kako treba', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_rafet_jasavic, @clinic_id, @doctor_zoran_koturovic, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/ChdDSUhNMG9nS0VJQ0FnSUM3eDZPZmp3RRAB',
    5, 'bs', 'E moj titograde puno sam ponosan na tebe,a posebno na doctora koturovica koji mi je napravio operaciju oka cak bolje i od americkih doctora bog da mu da dug zivot dobrom covjeku',
    'E moj titograde puno sam ponosan na tebe,a posebno na doctora koturovica koji mi je napravio operaciju oka cak bolje i od americkih doctora bog da mu da dug zivot dobrom covjeku', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_biljana_petanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/ChdDSUhNMG9nS0VJQ0FnSURSNjYzbHhnRRAB',
    1, 'hr', 'Da moze dala bih 0',
    'Da moze dala bih 0', NULL, NULL, NULL, NULL, NULL,
    3, '2023-10-29 00:00:00'),

(@user_milo_rakoevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/ChdDSUhNMG9nS0VJQ0FnSUNCMGY2cS1RRRAB',
    1, 'bs', 'Neprofesionalan i bahat doktor. Za izbjegavanje u širokom luku. Ne preporučujem nikom.',
    'Neprofesionalan i bahat doktor. Za izbjegavanje u širokom luku. Ne preporučujem nikom.', NULL, NULL, NULL, NULL, NULL,
    2, '2023-10-29 00:00:00'),

(@user_vladimir_jovanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/ChZDSUhNMG9nS0VJQ0FnSUQtLTR2Yk9BEAE',
    1, 'hr', 'Veoma loše iskustvo. Pošao sa uputom od izabranog doktora uzeli broj telefona zapisali ime i rekli da će zvati oko termina, ni nakon godinu dana pozvali nisu.',
    'Veoma loše iskustvo. Pošao sa uputom od izabranog doktora uzeli broj telefona zapisali ime i rekli da će zvati oko termina, ni nakon godinu dana pozvali nisu.', NULL, NULL, NULL, NULL, NULL,
    5, '2023-10-29 00:00:00'),

(@user_spasoje_rakonjac, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/ChZDSUhNMG9nS0VJQ0FnSUQyd0xURkZBEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_zdravko_jasovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2ZzZiaHhBRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_dragan_ratkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/ChdDSUhNMG9nS0VJQ0FnSUNhMEtpVXZnRRAB',
    3, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_unknown_unknown, @clinic_id, @doctor_zoran_koturovic, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/ChZDSUhNMG9nS0VJQ0FnSUR5MUozSVF3EAE',
    5, 'en', 'Thanks a lot for your help dr Koturovic and Marija! I will recommend your hospital to all my friends!',
    NULL, NULL, 'Thanks a lot for your help dr Koturovic and Marija! I will recommend your hospital to all my friends!', NULL, NULL, NULL,
    2, '2021-10-29 00:00:00'),

(@user_mini_traveler, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/ChZDSUhNMG9nS0VJQ0FnSURTMGREdVRREAE',
    4, 'hr', 'Osoblje na prijemnom bi moglo malo više ljubaznosti da pokaže jer ono što se kaže nismo kod njih kuci došli pa ajde... a što se tiče doktora najsrdačnije pohvale na stručnosti, ljubaznosti, humoru, profesionalnosti i posvećenosti!!!',
    'Osoblje na prijemnom bi moglo malo više ljubaznosti da pokaže jer ono što se kaže nismo kod njih kuci došli pa ajde... a što se tiče doktora najsrdačnije pohvale na stručnosti, ljubaznosti, humoru, profesionalnosti i posvećenosti!!!', NULL, NULL, NULL, NULL, NULL,
    3, '2021-10-29 00:00:00'),

(@user_olivera_slavnic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/ChZDSUhNMG9nS0VJQ0FnSURDci1tdURnEAE',
    1, 'bs', 'Zbrzan pregled. Promasena i dioptrija i apsolutno sve sto se moglo promasiti. Naocari neupotrebljive. Jedina svijetla tacka je divna medicinska sestra.',
    'Zbrzan pregled. Promasena i dioptrija i apsolutno sve sto se moglo promasiti. Naocari neupotrebljive. Jedina svijetla tacka je divna medicinska sestra.', NULL, NULL, NULL, NULL, NULL,
    3, '2020-10-29 00:00:00'),

(@user_stojan_trajkovski, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/ChdDSUhNMG9nS0VJQ0FnSUM4M2ZYOHVRRRAB',
    1, 'bs', 'Doktor jako neprofesionalno uradio pregled.
Nema vremena da saslusa pacijenta.
Pregled uradio kao da zuri, da sto prije zavrsi sa pacijentom. Ili mu se nije radilo, ili sto prije da nas makne sa vrata. Da ima 0, stavio bih 0.
Pohvale za med.sestru, jako ljubazna i fina.',
    'Doktor jako neprofesionalno uradio pregled.
Nema vremena da saslusa pacijenta.
Pregled uradio kao da zuri, da sto prije zavrsi sa pacijentom. Ili mu se nije radilo, ili sto prije da nas makne sa vrata. Da ima 0, stavio bih 0.
Pohvale za med.sestru, jako ljubazna i fina.', NULL, NULL, NULL, NULL, NULL,
    6, '2020-10-29 00:00:00'),

(@user_alo_alo, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/ChZDSUhNMG9nS0VJQ0FnSURnaGEyY05nEAE',
    2, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_alfa_nekretnine, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/ChZDSUhNMG9nS0VJQ0FnSURRdHBLd0xnEAE',
    5, 'en', 'Specialist for your eyes',
    NULL, NULL, 'Specialist for your eyes', NULL, NULL, NULL,
    0, '2017-10-29 00:00:00'),

(@user_mrki_mrki, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/ChdDSUhNMG9nS0VJQ0FnSURRdC1tendRRRAB',
    1, 'bs', 'Strasno lose. Dobio sam uput od izabranig doktora koji mi je preporucio ovu ordinaciju. Nazvao sam da zakazem rekli su mi ostavite nam broj pa cemo vas zvati kad bude slobodno. Posle pet dana sam ja zvao njih, receno mi je da nisu zaboravili ali nemaju slobodno. Na moje pitanje kad ce bit okvirno makar da znam, dobio sam odgovor da moram da cekam dok ne bude. Ok, ici cu nedje drugo jer mi treba doktor. Onda pitanje "a sta vam je?"  . Nista, nista trazicu doktora. Hvala.',
    'Strasno lose. Dobio sam uput od izabranig doktora koji mi je preporucio ovu ordinaciju. Nazvao sam da zakazem rekli su mi ostavite nam broj pa cemo vas zvati kad bude slobodno. Posle pet dana sam ja zvao njih, receno mi je da nisu zaboravili ali nemaju slobodno. Na moje pitanje kad ce bit okvirno makar da znam, dobio sam odgovor da moram da cekam dok ne bude. Ok, ici cu nedje drugo jer mi treba doktor. Onda pitanje "a sta vam je?"  . Nista, nista trazicu doktora. Hvala.', NULL, NULL, NULL, NULL, NULL,
    5, '2017-10-29 00:00:00'),

(@user_marija_maksimovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/ChZDSUhNMG9nS0VJQ0FnSURBc3RYREZBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2017-10-29 00:00:00'),

(@user_nk281_df, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfHowEbrTRMRkoGZRCr1aVE/reviews/ChdDSUhNMG9nS0VJQ0FnSUNRME5pVTJ3RRAB',
    1, 'ru', NULL,
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
