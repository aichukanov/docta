-- Insert Google Maps reviews for Stomatološka ordinacija ,,dr Ševaljević'' / Dentist "dr Sevaljevic"
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dr-sevaljevic-tivat.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dr-sevaljevic-tivat');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_marina_sevaljevic = (SELECT id FROM doctors WHERE slug = 'marina-sevaljevic');
SET @doctor_jovan_sevaljevic = (SELECT id FROM doctors WHERE slug = 'jovan-sevaljevic');
SET @doctor_branko_sevaljevic = (SELECT id FROM doctors WHERE slug = 'branko-sevaljevic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Santexnik Elektrik', 'https://lh3.googleusercontent.com/a/ACg8ocIvidtORuazw5t_06Z8YPrgpxrri0Y8Nv6hlD8my0EATcG9xg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111064225940217225701/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111064225940217225701/reviews');
SET @user_santexnik_elektrik = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111064225940217225701/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra F.', 'https://lh3.googleusercontent.com/a-/ALV-UjVFJddhXIkXWB4Okp3DRlcJ9f7IsdTksggd1aa2eK_PY8J5C-H_vg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/109863937956100470805/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109863937956100470805/reviews');
SET @user_aleksandra_f = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109863937956100470805/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milan Filipović', 'https://lh3.googleusercontent.com/a-/ALV-UjXS7ZdU8eN8bo_wpJU6ITPwfk4uFd_vFlCsWi4JVi-ZRx6IWge_=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/108528285595802466165/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108528285595802466165/reviews');
SET @user_milan_filipovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108528285595802466165/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocIMJyw-pQbDT_SAmTNNldwhHwfhVUAKRttvJFTCHpOe2uuJHg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111871462044381899921/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111871462044381899921/reviews');
SET @user_marija_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111871462044381899921/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Evelina Anderson', 'https://lh3.googleusercontent.com/a-/ALV-UjWsvrIUsNyrMLKqSPSkNc_Ie4dCaHGDIveYyViB90S2qVh7Mvg=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/100383172069757733541/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100383172069757733541/reviews');
SET @user_evelina_anderson = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100383172069757733541/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Богдан Сень', 'https://lh3.googleusercontent.com/a/ACg8ocLo8j9HzP-ZoSVyl-YB8JlI6vuJl1g-2ZC-TvWmek2_0mxLtQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111367012594219729840/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111367012594219729840/reviews');
SET @user_bogdan_sen = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111367012594219729840/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'nebojsa Gerik', 'https://lh3.googleusercontent.com/a/ACg8ocKfuDElm-WlFIO9M6KHFOq0MKZewrKSzfop7h-6QvGuGeDSxw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113518921617904314438/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113518921617904314438/reviews');
SET @user_nebojsa_gerik = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113518921617904314438/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mladen Veselinovic', 'https://lh3.googleusercontent.com/a/ACg8ocJXtybCeihKekws4lcNNsEgioEkLVqdhU_RxmdKW3RSomZlMQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117579037832373967475/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117579037832373967475/reviews');
SET @user_mladen_veselinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117579037832373967475/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'J Č', 'https://lh3.googleusercontent.com/a/ACg8ocKd1h37Y1dj7zU2ducUabafrQi5uDUmkKDId1iWu_CDdVbwOPhd=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115033491067337786766/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115033491067337786766/reviews');
SET @user_user_115033491067337786766 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115033491067337786766/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Majda Milankov', 'https://lh3.googleusercontent.com/a/ACg8ocJs_wXNTqke2hTd3l-UxGYpR0lKQoKQGM7QvFXiKLDEezjp6w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114072026771939992635/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114072026771939992635/reviews');
SET @user_majda_milankov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114072026771939992635/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandar Đorđević', 'https://lh3.googleusercontent.com/a-/ALV-UjW80BHMVJQnst6nSkFKpLR9_0KAiYcz4oSk2FljuNxyj8y7ocI=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107268975614045601405/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107268975614045601405/reviews');
SET @user_aleksandar_orevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107268975614045601405/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branka Jevrić', 'https://lh3.googleusercontent.com/a-/ALV-UjXdS5FEEwjaW1KTtljtMZqximWqmqwctFEz2mRPrPbJUVLQ4Og=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109643013970815172665/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109643013970815172665/reviews');
SET @user_branka_jevri = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109643013970815172665/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Samardzic', 'https://lh3.googleusercontent.com/a-/ALV-UjUD_K8ebX1Nc7uPERyFFyEPXZkdIabywkMGXywuNgJpX3QxOXckmw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100190131373093902018/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100190131373093902018/reviews');
SET @user_jovana_samardzic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100190131373093902018/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nina SEVALJEVIC', 'https://lh3.googleusercontent.com/a-/ALV-UjUA6K48mVeyS9uiMWtVFmn_a1dLZRdtFkJ9cJ091d-ZlsGEZcWa=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101512321679653402592/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101512321679653402592/reviews');
SET @user_nina_sevaljevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101512321679653402592/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Bartko', 'https://lh3.googleusercontent.com/a-/ALV-UjWNBc94K4vFLHwlrOCW2jBA0HAPwSa574SUqQrhKYMKLZZ3iNM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114312469205458290096/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114312469205458290096/reviews');
SET @user_ana_bartko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114312469205458290096/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tigran Rubenovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVspS6y8Fk9qNEIKzm6Xd4XCWt0AFAVRcytZ8b7W_kzUdlgdPp6=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111209179425261258275/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111209179425261258275/reviews');
SET @user_tigran_rubenovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111209179425261258275/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Leo Bosnjak', 'https://lh3.googleusercontent.com/a/ACg8ocKQbIZKTXhECNL9T5NLgfaFhNpT7ezdftD3dkG9MyQeGQ3f-w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110007954467073353863/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110007954467073353863/reviews');
SET @user_leo_bosnjak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110007954467073353863/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ivan klacar', 'https://lh3.googleusercontent.com/a-/ALV-UjUk1KfLJWrrTOTL360dIpcKGEqwyfa9WFwJATNCg9euvTUwyzXZ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104255384614060972939/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104255384614060972939/reviews');
SET @user_ivan_klacar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104255384614060972939/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stojan Tokic', 'https://lh3.googleusercontent.com/a-/ALV-UjXKAY3Cfvwxxx3STm5odtocEJegF7gqMlc-wEea5-E8-NB3UEhMhw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101826709624697456934/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101826709624697456934/reviews');
SET @user_stojan_tokic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101826709624697456934/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Misha Tofil', 'https://lh3.googleusercontent.com/a/ACg8ocLi1qkKEJMxc4TUkWjIN152i3Ek1KyL9TRzEmNNgL78NjvvK9U=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103148667966431679911/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103148667966431679911/reviews');
SET @user_misha_tofil = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103148667966431679911/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Filip Savovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVnnQVfWJHl8bsu2V8bG-xJcMj4i9FACou1lSOjeYTRZy2RZ02L9Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113815262614464974419/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113815262614464974419/reviews');
SET @user_filip_savovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113815262614464974419/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tatjana Jerotic', 'https://lh3.googleusercontent.com/a/ACg8ocJcQEb1ha0a0u9beTHAi7aLX4V7g1qj7_eGCs5AeMp89PN1hA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113761373928700134599/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113761373928700134599/reviews');
SET @user_tatjana_jerotic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113761373928700134599/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_santexnik_elektrik, @clinic_id, @doctor_branko_sevaljevic, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GbWJrWkdiV1YyUkZjNFh6VlpXa1Z2WW5OWmMxRRAB',
    5, 'ru', 'Branko Sevaljeviic стаматолог. (Тиват) Очень хороший врач. Работает безболезненно. И можно договориться с ценой',
    'Branko Ševaljević, stomatolog. (Tivat) Veoma dobar doktor. Bezbolan rad. A cena po dogovoru.', 'Бранко Шеваљевић, стоматолог. (Тиват) Веома добар доктор. Безболан рад. А цена по договору.', NULL, 'Branko Sevaljeviic стаматолог. (Тиват) Очень хороший врач. Работает безболезненно. И можно договориться с ценой', NULL, NULL,
    0, '2025-08-30 10:52:42'),

(@user_aleksandra_f, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/ChdDSUhNMG9nS0VJQ0FnSUN4Mzd5X2tnRRAB',
    5, 'en', 'This dental practice is  clean and beautiful, with modern equipment. The price is really reasonable. The Doctor is knowledgeable and professional, friendly with patients, and experienced. He did a great job on my fillings. He uses the best materials. I highly recommend him.  Credit cards are accepted.',
    'Ova stomatološka ordinacija je čista i lepa, sa modernom opremom. Cena je zaista razumna. Doktor je stručan i profesionalan, ljubazan prema pacijentima i iskusan. Odlično je uradio moje plombe. Koristi najbolje materijale. Toplo ga preporučujem. Prihvataju se kreditne kartice.', 'Ова стоматолошка ординација је чиста и лепа, са модерном опремом. Цена је заиста разумна. Доктор је стручан и професионалан, љубазан према пацијентима и искусан. Одлично је урадио моје пломбе. Користи најбоље материјале. Топло га препоручујем. Прихватају се кредитне картице.', 'This dental practice is  clean and beautiful, with modern equipment. The price is really reasonable. The Doctor is knowledgeable and professional, friendly with patients, and experienced. He did a great job on my fillings. He uses the best materials. I highly recommend him.  Credit cards are accepted.', NULL, NULL, NULL,
    3, '2023-05-29 16:13:31'),

(@user_milan_filipovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4cmFERnBlVzl5ZW1sSE5raHJiRnBtT0hwSVpXYxAB',
    5, 'bs', 'Primila nas preko reda, problem rešen, dete zadovoljno.

Pozdrav iz Kruševca.',
    'Dočekala nas je bez odlaganja, problem rešen, dete srećno.

Pozdrav iz Kruševca.', 'Дочекала нас је без одлагања, проблем решен, дете срећно.

Поздрав из Крушевца.', NULL, NULL, NULL, NULL,
    0, '2025-08-17 17:18:05'),

(@user_marija_popovic, @clinic_id, @doctor_jovan_sevaljevic, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/ChdDSUhNMG9nS0VJQ0FnSUNKbE03bDZ3RRAB',
    1, 'bs', 'Kao turista, morala sam zbog bola da posetim zubara. Dr Jovan je ostvio toliko los utisak, nadobudan, uobrazen, nepristupacan, nemam reci. Jedva sam cekala da izadjem iz te ordinacije. Zaobidjite ih u sirokom luku!',
    'Kao turista, morao sam da posetim zubara zbog bolova. Dr Jovan je ostavio tako loš utisak, arogantan, arogantan, nepristupačan, nemam reči. Jedva sam čekao da izađem iz te kancelarije. Izbegavajte ih što je više moguće!', 'Као туриста, морао сам да посетим зубара због болова. Др Јован је оставио тако лош утисак, арогантан, арогантан, неприступачан, немам речи. Једва сам чекао да изађем из те канцеларије. Избегавајте их што је више могуће!', NULL, NULL, NULL, NULL,
    2, '2023-06-21 13:34:48'),

(@user_evelina_anderson, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/ChZDSUhNMG9nS0VJQ0FnSURaOFpMUE93EAE',
    5, 'en', 'Absolutely fantastic dentist
Managed to save my tooth after having major gangrene
Thank you so Much',
    'Apsolutno fantastičan zubar
Uspeo sam da spasem zub nakon teške gangrene
Hvala vam puno', 'Апсолутно фантастичан зубар
Успео сам да спасем зуб након тешке гангрене
Хвала вам пуно', 'Absolutely fantastic dentist
Managed to save my tooth after having major gangrene
Thank you so Much', NULL, NULL, NULL,
    2, '2023-10-03 10:18:51'),

(@user_bogdan_sen, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkeVJXcHFTRE5tZVZKWFpHOXJjR2xmTVUwdFZFRRAB',
    1, 'en', 'The dentist refused to continue treating the tooth; the conditions are unsanitary, he works without gloves, and he is rude.',
    NULL, NULL, 'The dentist refused to continue treating the tooth; the conditions are unsanitary, he works without gloves, and he is rude.', NULL, NULL, NULL,
    0, '2026-10-22 00:00:00'),

(@user_nebojsa_gerik, @clinic_id, @doctor_marina_sevaljevic, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pOdGFFcGphVGxNYUVOaVFrVlZaV2QzU0V0TVdGRRAB',
    5, 'bg', 'Preodobra usluga kako turisti so soprugata imase bolki so umnikot se javivme odma ni dadoa termin doktorot bese povise od profesionalen sekoj ces  I za nego I za doktorkata marina golem pozdrav od makedonija',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_mladen_veselinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twcVRuaEdhVFZOU0Vabk5XRjRWMnQ1V2tzeExWRRAB',
    5, 'hr', 'Jednom rečiju Prezadovoljan sam.',
    'Jednom rečiju Prezadovoljan sam.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_user_115033491067337786766, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GdlUzbDNlVWRLYVc5aU1rdFlNVlJIT0RobVduYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_majda_milankov, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/ChdDSUhNMG9nS0VJQ0FnSUNuOVBTN2t3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_aleksandar_orevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/ChZDSUhNMG9nS0VJQ0FnSUNGMVpHRFdBEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_branka_jevri, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/ChZDSUhNMG9nS0VJQ0FnSUNSMS1uSmNREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_jovana_samardzic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/ChdDSUhNMG9nS0VJQ0FnSUNoc3N6NHVBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_nina_sevaljevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/ChdDSUhNMG9nS0VJQ0FnSUNlajRyOXJnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_ana_bartko, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/ChdDSUhNMG9nS0VJQ0FnSUN1dnVyWjFnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_tigran_rubenovic, @clinic_id, @doctor_jovan_sevaljevic, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/ChdDSUhNMG9nS0VJQ0FnSUNZalotUnpRRRAB',
    5, 'ru', 'Огромное спасибо доктору Йовану. Великолепный доктор и легкая рука.',
    NULL, NULL, NULL, 'Огромное спасибо доктору Йовану. Великолепный доктор и легкая рука.', NULL, NULL,
    3, '2019-10-29 00:00:00'),

(@user_leo_bosnjak, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/ChZDSUhNMG9nS0VJQ0FnSUNncy1fck5REAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_ivan_klacar, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/ChdDSUhNMG9nS0VJQ0FnSURRc2VycThBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_stojan_tokic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/ChdDSUhNMG9nS0VJQ0FnSURncDYyenFRRRAB',
    5, 'hr', 'Veoma ljubazni. Doktorica za pohvalu 😊',
    'Veoma ljubazni. Doktorica za pohvalu 😊', NULL, NULL, NULL, NULL, NULL,
    3, '2016-10-29 00:00:00'),

(@user_misha_tofil, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/ChZDSUhNMG9nS0VJQ0FnSUNncHIyNEV3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2015-10-29 00:00:00'),

(@user_filip_savovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/ChZDSUhNMG9nS0VJQ0FnSUNndTlxOVJREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2014-10-29 00:00:00'),

(@user_tatjana_jerotic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yC6VJwxTBMRLu4wgJzWJCU/reviews/ChZDSUhNMG9nS0VJQ0FnSURRaHBYVWFnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2014-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
