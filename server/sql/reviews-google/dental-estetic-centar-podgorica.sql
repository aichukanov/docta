-- Insert Google Maps reviews for Stomatoloska ordinacija "Dental&Estetic Centar"
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dental-estetic-centar-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dental-estetic-centar-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivona Lubeničica', 'https://lh3.googleusercontent.com/a-/ALV-UjXY2ec2GcFaqivhynwf6GdvISaRsD2HTZoSFcMLqKlQEclEpzD8Sg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/118213946697169435443/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118213946697169435443/reviews');
SET @user_ivona_lubeniica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118213946697169435443/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'AMIGDALA', 'https://lh3.googleusercontent.com/a-/ALV-UjWuzdCqoM4t9g2t0A_7sOvmNC-k6-yxpaI-g__uFGRjlJ0SxFNo=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/117851281000684574542/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117851281000684574542/reviews');
SET @user_amigdala = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117851281000684574542/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivona Antonijevic', 'https://lh3.googleusercontent.com/a-/ALV-UjUPZbWYHfzO1gwapALTJwO6g32LPbKHFdNmc-IO6VjOak2tvyI=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/112402835846430620933/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112402835846430620933/reviews');
SET @user_ivona_antonijevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112402835846430620933/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Mmm', 'https://lh3.googleusercontent.com/a/ACg8ocJbyg_5HUugwOncYSZDS86eK6hA_Gbae_z5ZOCA0yT-9mZ_wQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/114584710371116885740/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114584710371116885740/reviews');
SET @user_dragana_mmm = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114584710371116885740/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Fridrih Nice', 'https://lh3.googleusercontent.com/a/ACg8ocKwxEeB2yVXSNiu3KJzp1PskTm-7MNwUUV2quhqb-PPxdJ7sg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107611567494322951476/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107611567494322951476/reviews');
SET @user_fridrih_nice = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107611567494322951476/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maksim Sekulic', 'https://lh3.googleusercontent.com/a/ACg8ocIfC1CNHddAmf7GRjtlRHe5lSP6U0LNe_K96ibjAF7HhhurYw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107170565427801452602/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107170565427801452602/reviews');
SET @user_maksim_sekulic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107170565427801452602/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Perfect Magazine', 'https://lh3.googleusercontent.com/a-/ALV-UjW7ZluXKZMv9VLtN_Dt-JBB1MGwaXvKIj8-d57ZsTYDkltV-OQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101504466441992671736/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101504466441992671736/reviews');
SET @user_perfect_magazine = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101504466441992671736/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'jovana milonjić', 'https://lh3.googleusercontent.com/a/ACg8ocLcQKQXfi-yWEIV4gIXXLQ8YNZr85F5AOyUZyfgpuVElhoMBA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115620599680981953217/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115620599680981953217/reviews');
SET @user_jovana_milonji = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115620599680981953217/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milena Brajovic', 'https://lh3.googleusercontent.com/a/ACg8ocLlQ_itT4n-m_gc-IapLvKyu18tr2fK47TY0FyYDCIJvNtDsw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106326387406087955616/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106326387406087955616/reviews');
SET @user_milena_brajovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106326387406087955616/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Harley Q', 'https://lh3.googleusercontent.com/a/ACg8ocL4tB1p5-1Ip49EQnv6h3k_dHqPT8S7CBnTDD_tkI89RIC-2Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110252715681048549414/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110252715681048549414/reviews');
SET @user_harley_q = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110252715681048549414/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dental Medical Tourism', 'https://lh3.googleusercontent.com/a-/ALV-UjWuHrx3XtKoP1w7i8lFLPK_DPPIyxPFikc79ZzfSwXDvooVT80=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103271747651407826155/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103271747651407826155/reviews');
SET @user_dental_medical_tourism = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103271747651407826155/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kristijan Trajčeski', 'https://lh3.googleusercontent.com/a/ACg8ocK9LjFclOnnAb6y6TpXRFPTWILJABSt421II8HDvnT-_fptMg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110389846142723669702/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110389846142723669702/reviews');
SET @user_kristijan_trajeski = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110389846142723669702/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'eldin dacic', 'https://lh3.googleusercontent.com/a/ACg8ocKiHiz-TWymT9_VtDyDv8ap6xmpBglR962dFW65yXdWuMHlDg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101377757508471347829/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101377757508471347829/reviews');
SET @user_eldin_dacic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101377757508471347829/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Miodrag Glavatovic', 'https://lh3.googleusercontent.com/a/ACg8ocJgUsKMfquhpesSd6MhFV6EIc92-vSlGnp0RJitoN_M-Hwe=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100309888154755988621/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100309888154755988621/reviews');
SET @user_miodrag_glavatovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100309888154755988621/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandar Pejovic', 'https://lh3.googleusercontent.com/a/ACg8ocLLRmOLsTnZY-_QLqURn6hwh01od-1DrZau2yrVq9ZB07eoMQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107164697551538069893/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107164697551538069893/reviews');
SET @user_aleksandar_pejovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107164697551538069893/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nesha Nesha', 'https://lh3.googleusercontent.com/a/ACg8ocLRlucz_d-e1l-5iaIWTRNzk-X8ZeeQURq-7c0VkZPvXfCRvA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106240975732965596178/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106240975732965596178/reviews');
SET @user_nesha_nesha = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106240975732965596178/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nenad Pantelic', 'https://lh3.googleusercontent.com/a-/ALV-UjUDzf343F3yNF4N9OmyEMyJwaG_Fow2S0jSoiAIAZegtAycEbPpiQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104421279376059489691/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104421279376059489691/reviews');
SET @user_nenad_pantelic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104421279376059489691/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Davor Košir', 'https://lh3.googleusercontent.com/a-/ALV-UjUiSVphaIFtxKmFVkWKWdk1dzhQo06L4-usLAHSATUvwKVSbtLn=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105687576720058508112/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105687576720058508112/reviews');
SET @user_davor_koir = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105687576720058508112/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nick Arandjelovic', 'https://lh3.googleusercontent.com/a/ACg8ocLuwBSU7IXURz4o3I_2ZM-nvtJta0J8mVzygbveU4V8Owhlow=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111189180169682394635/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111189180169682394635/reviews');
SET @user_nick_arandjelovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111189180169682394635/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_ivona_lubeniica, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/ChZDSUhNMG9nS0VJQ0FnSURPOWVfVUNBEAE',
    1, 'hr', 'Ako biste voljeli da ne budete nagrđeni prekočite ovu ordinaciju zbog koje mi majka kuka posle 3 godine od njihovog "rada" za koji su plaćene debele pare. Ne možete to da brišete koliko ću ja toga da napišem bukvalno đe god stignem jer imam pravo na to!!!!!!',
    'Ako želite da izbegnete da vas vređaju, preskočite ovu kancelariju na koju se žali moja majka posle 3 godine njihovog "rada" za koji su plaćali velike pare. Ne možete to da obrišete, pisaću o tome bukvalno gde god mogu jer na to imam pravo!!!!!!', 'Ако желите да избегнете да вас вређају, прескочите ову канцеларију на коју се жали моја мајка после 3 године њиховог "рада" за који су плаћали велике паре. Не можете то да обришете, писаћу о томе буквално где год могу јер на то имам право!!!!!!', NULL, NULL, NULL, NULL,
    2, '2022-07-11 06:12:02'),

(@user_amigdala, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GeU1rbDZiRUZLTkVvdE9WcDVhMmxxTUd0cE0xRRAB',
    5, 'bs', 'Moje preporuke, ljubaznost i profesionalizam na nivou',
    'Moje preporuke, ljubaznost i profesionalizam na najvišem nivou', 'Моје препоруке, љубазност и професионализам на највишем нивоу', NULL, NULL, NULL, NULL,
    0, '2025-07-17 11:39:52'),

(@user_ivona_antonijevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/ChZDSUhNMG9nS0VJQ0FnSUR1ekttNE1BEAE',
    5, 'hr', 'Svaka preporuka! Profesionalizam i ljubaznost ostavljaju bez teksta. Definitivno najbolji 😁',
    'Toplo preporučujem! Profesionalizam i ljubaznost ostavljaju bez reči. Definitivno najbolji 😁', 'Топло препоручујем! Професионализам и љубазност остављају без речи. Дефинитивно најбољи 😁', NULL, NULL, NULL, NULL,
    2, '2022-08-15 09:02:19'),

(@user_dragana_mmm, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/ChZDSUhNMG9nS0VJQ0FnSUR1OE1uOFFREAE',
    5, 'bs', 'Savrseni najbolji od srca svima preporucujem😬😬😬👌👌👌',
    'Savršeno, najbolje, preporučujem svima od srca😬😬😬👌👌👌', 'Савршено, најбоље, препоручујем свима од срца😬😬😬👌👌👌', NULL, NULL, NULL, NULL,
    1, '2022-08-11 19:31:18'),

(@user_fridrih_nice, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/ChZDSUhNMG9nS0VJQ0FnSUR1ek82NFVnEAE',
    5, 'hr', 'Jednostavno najbolji u gradu 👍👍',
    'Jednostavno najbolji u gradu 👍👍', 'Једноставно најбољи у граду 👍👍', NULL, NULL, NULL, NULL,
    0, '2022-08-15 08:31:45'),

(@user_maksim_sekulic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pJdFpuaGFjR3hXV1VFeGNHSmpNakZvWTJWdFJXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, NULL),

(@user_perfect_magazine, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/Ci9DQUlRQUNvZENodHljRjlvT21ORU4wTldiVGN4WTNCcE1teFVhMFZuUzNSbU0zYxAB',
    5, 'bs', 'Odlazak kod stomatologa za mnoge od nas godinama je spojen sa neprijatnošću i odlaganjem. Međutim, iskustvo koje pruža dental estetic centar potpuno mijenja tu percepciju i postavlja nove standarde u dentalnoj njezi.',
    'Odlazak kod stomatologa za mnoge od nas godinama je spojen sa neprijatnošću i odlaganjem. Međutim, iskustvo koje pruža dental estetic centar potpuno mijenja tu percepciju i postavlja nove standarde u dentalnoj njezi.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-15 00:00:00'),

(@user_jovana_milonji, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSWk0yUk9XbDh3TFdabWNscDVTVUoxVlVJd2RVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-15 00:00:00'),

(@user_milena_brajovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/Ci9DQUlRQUNvZENodHljRjlvT21oTVpFRTJTR1JhUWs5Q1kzazJTbFZITjBodU4zYxAB',
    5, 'sr', 'Изузетно квалитетна и професионална услуга, све похвале, сјајни.',
    'Izuzetno kvalitetna i profesionalna usluga, sve pohvale, sjajni.', 'Изузетно квалитетна и професионална услуга, све похвале, сјајни.', NULL, NULL, NULL, NULL,
    0, '2026-10-15 00:00:00'),

(@user_harley_q, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tNMFZEUnVVRkp5Y0VwM1VtVTBPV0Y2YzNab2RWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-15 00:00:00'),

(@user_dental_medical_tourism, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/ChdDSUhNMG9nS0VJQ0FnSUR1X0xUcm53RRAB',
    5, 'bs', 'U stomatološkoj ordinaciji "dental estetici centar" u Podgorici možete očekivati odlično iskustvo. Prostor je savremeno opremljen i uredan. Stručnost i pažnja prema pacijentima, Osoblje je izuzetno profesionalno i prijatno, što stvara ugodnu atmosferu tokom posete. Ova ordinacija je preporučena svakome ko traži kvalitetnu i pažljivu stomatološku i estetsku uslugu.',
    'U stomatološkoj ordinaciji "dental estetici centar" u Podgorici možete očekivati odlično iskustvo. Prostor je savremeno opremljen i uredan. Stručnost i pažnja prema pacijentima, Osoblje je izuzetno profesionalno i prijatno, što stvara ugodnu atmosferu tokom posete. Ova ordinacija je preporučena svakome ko traži kvalitetnu i pažljivu stomatološku i estetsku uslugu.', NULL, NULL, NULL, NULL, NULL,
    1, '2026-10-15 00:00:00'),

(@user_kristijan_trajeski, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WblVWUTBSWFJKTjNCbFExZExjV0ZCY25sbWVtYxAB',
    5, 'en', 'Excellent service. I am very pleased with their way of work. The staff is kind, patient and willing to listen to my requests even if those requests may seem a bit unusual to them. If the doctors can put up with me, I am confident they can handle anything. Would definitively recommend giving them a visit.',
    NULL, NULL, 'Excellent service. I am very pleased with their way of work. The staff is kind, patient and willing to listen to my requests even if those requests may seem a bit unusual to them. If the doctors can put up with me, I am confident they can handle anything. Would definitively recommend giving them a visit.', NULL, NULL, NULL,
    1, '2026-10-01 00:00:00'),

(@user_eldin_dacic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5b2MxY3RNMFpVVG5JNWJUZDVVMWMzVWpsbU1GRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_miodrag_glavatovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/ChdDSUhNMG9nS0VKVEtsZlQyNlBicW1BRRAB',
    5, 'hr', 'Super usluga',
    'Super usluga', NULL, NULL, NULL, NULL, NULL,
    1, '2025-10-29 00:00:00'),

(@user_aleksandar_pejovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNYaGFfcVh3EAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_nesha_nesha, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/ChZDSUhNMG9nS0VJQ0FnSURIZzRQMVFBEAE',
    5, 'en', 'exelent',
    NULL, NULL, 'exelent', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_nenad_pantelic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/ChdDSUhNMG9nS0VJQ0FnSURELWM2dHBRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_davor_koir, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNCMTVXZUpREAE',
    1, 'hr', 'Preskupo!',
    'Preskupo!', NULL, NULL, NULL, NULL, NULL,
    2, '2023-10-29 00:00:00'),

(@user_nick_arandjelovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/ChdDSUhNMG9nS0VJQ0FnSUR1ek5ibWxnRRAB',
    5, 'bs', 'Super su !!! Preporucujem svima 😁😁',
    'Super su !!! Preporucujem svima 😁😁', NULL, NULL, NULL, NULL, NULL,
    2, '2022-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: Insert review replies (owner responses)
-- ═══════════════════════════════════════════════════════════════

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/Ci9DQUlRQUNvZENodHljRjlvT21ORU4wTldiVGN4WTNCcE1teFVhMFZuUzNSbU0zYxAB'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-10-15 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSWk0yUk9XbDh3TFdabWNscDVTVUoxVlVJd2RVRRAB'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-10-15 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/Ci9DQUlRQUNvZENodHljRjlvT21oTVpFRTJTR1JhUWs5Q1kzazJTbFZITjBodU4zYxAB'),
  'clinic', @clinic_id,
  'Hvala na ocjeni i na 11god povjerenja🥰', 'hr',
  'Hvala na ocjeni i na 11god povjerenja🥰', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-10-15 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tNMFZEUnVVRkp5Y0VwM1VtVTBPV0Y2YzNab2RWRRAB'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-10-15 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/ChdDSUhNMG9nS0VJQ0FnSUR1X0xUcm53RRAB'),
  'clinic', @clinic_id,
  'Hvala na saradnji i na ocjeni', 'hr',
  'Hvala na saradnji i na ocjeni', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-10-15 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ2UUYSb3rTRMRCFwiFhxaskc/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WblVWUTBSWFJKTjNCbFExZExjV0ZCY25sbWVtYxAB'),
  'clinic', @clinic_id,
  'Hvala puno na lijepim rijecima!', 'hr',
  'Hvala puno na lijepim rijecima!', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-10-15 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
