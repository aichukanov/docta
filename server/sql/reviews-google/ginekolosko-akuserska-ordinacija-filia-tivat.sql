-- Insert Google Maps reviews for Ginekološko akušerska ordinacija "Filia"
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/ginekolosko-akuserska-ordinacija-filia-tivat.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'ginekolosko-akuserska-ordinacija-filia-tivat');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_julija_samardzic = (SELECT id FROM doctors WHERE slug = 'julija-samardzic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andjelka Tadic', 'https://lh3.googleusercontent.com/a/ACg8ocIZnvYVUMAYHU6_pZPkItmJ7M3LmMhsjcO9FKqy_dCr-ObjqQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101028132614049337726/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101028132614049337726/reviews');
SET @user_andjelka_tadic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101028132614049337726/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'andreja samardzic', 'https://lh3.googleusercontent.com/a-/ALV-UjWTIg7VohDmTcYQwiugj6Rp5RhEiBwebCE99Y-ooKETq_LTL04-xQ=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/109317696514217915040/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109317696514217915040/reviews');
SET @user_andreja_samardzic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109317696514217915040/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Atina Samardzic', 'https://lh3.googleusercontent.com/a/ACg8ocIvDO_6_WvPhrz6kvC7pAjaMKCNTdH7_LRkEzZDJD3yWKiL2g=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/116635262708863504285/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116635262708863504285/reviews');
SET @user_atina_samardzic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116635262708863504285/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zulfiyya Nizam', 'https://lh3.googleusercontent.com/a-/ALV-UjUuGerStn3o0NEEyXxScZ2VU3XAc3tQucJJ_kfMpZWtmeINRVY=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/111284891509523343307/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111284891509523343307/reviews');
SET @user_zulfiyya_nizam = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111284891509523343307/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Abeona RentAcar', 'https://lh3.googleusercontent.com/a/ACg8ocKij9sJfO4s8m5ZpH_c-FNcbVvlgB8mDwmCSQGEoqXpTN6D6g=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/104807513286193737441/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104807513286193737441/reviews');
SET @user_abeona_rentacar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104807513286193737441/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stefanie', 'https://lh3.googleusercontent.com/a/ACg8ocKRG0UG-EhSyOOIw00ORzCKNLFGVTOFI_mgaUy3vhL1g3iFIA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107341092969761033026/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107341092969761033026/reviews');
SET @user_stefanie = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107341092969761033026/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ирина Луценко', 'https://lh3.googleusercontent.com/a/ACg8ocIsWr_WUbBSJZagMoTQeZrrHZEr05MFrwohyALPuweJOKnVaw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106613145306806717107/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106613145306806717107/reviews');
SET @user_irina_lutsenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106613145306806717107/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anastasija Tubic', 'https://lh3.googleusercontent.com/a/ACg8ocK8UmkcZLKtp2mOPhciIRpKm-VlsUo-UvVgpCAdRpO0VcmE9Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114292714372593156730/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114292714372593156730/reviews');
SET @user_anastasija_tubic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114292714372593156730/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tamara Taca', 'https://lh3.googleusercontent.com/a-/ALV-UjWDOdcTE9ReeHtoyWPtU-FcaMLYwKh3k-9qWoaRQQuJiIgZSNrr=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110491345081046602809/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110491345081046602809/reviews');
SET @user_tamara_taca = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110491345081046602809/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Owl Troll', 'https://lh3.googleusercontent.com/a-/ALV-UjWAEe9VrknTm36TBFs4Rg55sZ_-0KrbIKhcX_gGfWyt9kPe93k=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117960653122190910568/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117960653122190910568/reviews');
SET @user_owl_troll = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117960653122190910568/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dusica Vasic', 'https://lh3.googleusercontent.com/a/ACg8ocJKo-LuhBv5ilcN6CFumJaB6xQAc6ghsUsOsJMChinCJ9VaLg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114477165910752808674/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114477165910752808674/reviews');
SET @user_dusica_vasic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114477165910752808674/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojana Ćalasan', 'https://lh3.googleusercontent.com/a/ACg8ocIf25Nuumlg0TTfx12zLOwGbbmBGep3ZzxHCeLgWTOgoUm9RQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104131698734229863845/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104131698734229863845/reviews');
SET @user_bojana_alasan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104131698734229863845/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dijana Crnogorac', 'https://lh3.googleusercontent.com/a-/ALV-UjWo3EXhjeMJD6Qjx037AXmmgYuwfkY9UbaqfZECOzeP8_RxQoVz=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115646920932992256695/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115646920932992256695/reviews');
SET @user_dijana_crnogorac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115646920932992256695/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Biljana Krivokapic', 'https://lh3.googleusercontent.com/a/ACg8ocJtuI-_DXFXvHo5Kdy8rL_3n924xVde8lWrFUd5ygi9BLCRbQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103522826735593000161/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103522826735593000161/reviews');
SET @user_biljana_krivokapic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103522826735593000161/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nadja Sekaric', 'https://lh3.googleusercontent.com/a-/ALV-UjUA2EW8gYyPr-bjdTMoEIo40TUnp1G0h-0eS-wOxbDHGZqKhLm8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114300109319034913337/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114300109319034913337/reviews');
SET @user_nadja_sekaric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114300109319034913337/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'violeta stevovic', 'https://lh3.googleusercontent.com/a/ACg8ocKGZ57gZhJEV-LURfEMgXrrN54KOPXFGgsNgBan-0sJ9pk-9w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113935988016534077760/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113935988016534077760/reviews');
SET @user_violeta_stevovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113935988016534077760/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Borka Scepanovic', 'https://lh3.googleusercontent.com/a/ACg8ocJqXmwxnUij65Sp_r_vPOrzPX8pozdvJlg3z0TxbKgx0VR-bQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107152404057323465688/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107152404057323465688/reviews');
SET @user_borka_scepanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107152404057323465688/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ksenija Fatic', 'https://lh3.googleusercontent.com/a/ACg8ocK7QbT9XusTzXltuKfxNlWwWCFHIS2z0AYRV1Xf6OWoEjjsdA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100395094973544562027/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100395094973544562027/reviews');
SET @user_ksenija_fatic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100395094973544562027/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojana Bojana', 'https://lh3.googleusercontent.com/a/ACg8ocK6Up18S2f7rOoyUbk6Kszxg7GWTlir_AgRRKsD14_F6PXcow=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104136212281930565774/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104136212281930565774/reviews');
SET @user_bojana_bojana = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104136212281930565774/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sofiaj Cerović', 'https://lh3.googleusercontent.com/a/ACg8ocJbowVnaFDuzEm7LFD2OUdWaC4KOkFRObJRw_16EV796Ry85Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108426980954844906968/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108426980954844906968/reviews');
SET @user_sofiaj_cerovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108426980954844906968/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vanja Samardzic', 'https://lh3.googleusercontent.com/a/ACg8ocL0K21HWNXnlbjRySZyT38lyemlfA_sOlCeYiKc2MOndE0AaA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107497803203329077063/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107497803203329077063/reviews');
SET @user_vanja_samardzic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107497803203329077063/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Драгана', 'https://lh3.googleusercontent.com/a/ACg8ocKM8FapgC85fOtTLX94ErCJYTlvkOWKINw8Jz8KcUUi9oeysNc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114706929452806003671/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114706929452806003671/reviews');
SET @user_dragana = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114706929452806003671/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_andjelka_tadic, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xnd05rUlJaSEF3YUZCSVRtVXhjMFI0ZG14NFpsRRAB',
    5, 'bs', 'Doktorka i njena koleginica su stručne, ljubazne i posvećene. Definitivno najbolja ordinacija u Tivtu! Sve preporuke!',
    'Doktorka i njena koleginica su profesionalne, ljubazne i posvećene. Definitivno najbolja ordinacija u Tivtu! Toplo preporučujem!', 'Докторка и њена колегиница су професионалне, љубазне и посвећене. Дефинитивно најбоља ординација у Тивту! Топло препоручујем!', NULL, NULL, NULL, NULL,
    0, '2026-02-23 19:07:19'),

(@user_andreja_samardzic, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/Ci9DQUlRQUNvZENodHljRjlvT25kS1Z6ZzRSMUZwWldkeVJFVXRUMk13ZW5sbkxVRRAB',
    5, 'en', 'Gynecologist with extensive experience in practice, always kind, patient, gentle, all recommendations for a doctor in Tivat.
There is a private parking lot on site, it is easy to find the location',
    'Ginekolog sa bogatim iskustvom u praksi, uvek ljubazan, strpljiv, nežan, sve preporuke za lekara u Tivtu.
Postoji privatni parking na licu mesta, lako je pronaći lokaciju.', 'Гинеколог са богатим искуством у пракси, увек љубазан, стрпљив, нежан, све препоруке за лекара у Тивту.
Постоји приватни паркинг на лицу места, лако је пронаћи локацију.', 'Gynecologist with extensive experience in practice, always kind, patient, gentle, all recommendations for a doctor in Tivat.
There is a private parking lot on site, it is easy to find the location', NULL, NULL, NULL,
    0, '2026-01-19 15:21:44'),

(@user_atina_samardzic, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/Ci9DQUlRQUNvZENodHljRjlvT210cmNYQjBlRGxrYmxZNVpWQTJXVkExUTB0SFNrRRAB',
    5, 'bs', 'Doktorica je izuzetno ljubazna strucna i pristupacna, posebno cijenim njenu smirenost i empatiju. Osjecam se potpuno sigurno u rukama ove doktorice.',
    'Doktorka je izuzetno ljubazna, profesionalna i pristupačna, posebno cenim njenu smirenost i empatiju. Osećam se potpuno sigurno u rukama ovog doktora.', 'Докторка је изузетно љубазна, професионална и приступачна, посебно ценим њену смиреност и емпатију. Осећам се потпуно сигурно у рукама овог доктора.', NULL, NULL, NULL, NULL,
    0, '2025-08-16 10:03:28'),

(@user_zulfiyya_nizam, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KU1IxOWpUVzVOUkdsUk9XSmFSekV4U2tJdFJFRRAB',
    5, 'ru', 'Прекрасный доктор Юлия,спасибо вам огромное за профессионализм,доброту и теплоту ❤️ С уважением, Зульфия ❤️❤️',
    'Divna doktorka Julija, hvala vam puno na profesionalizmu, ljubaznosti i toplini ❤ S poštovanjem, Zulfija ❤❤', 'Дивна докторка Јулија, хвала вам пуно на професионализму, љубазности и топлини ❤ С поштовањем, Зулфија ❤❤', NULL, 'Прекрасный доктор Юлия,спасибо вам огромное за профессионализм,доброту и теплоту ❤️ С уважением, Зульфия ❤️❤️', NULL, NULL,
    0, '2025-10-29 10:57:07'),

(@user_abeona_rentacar, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/Ci9DQUlRQUNvZENodHljRjlvT213MUxWWkhXVE56VEZwQ1pubHhRbkJOU0hKUVZuYxAB',
    5, 'bs', 'Jako prijatna, i profesionalna usluga. Vrlo detaljna i sve objasni. Preporucujem svakome🙂🙏',
    'Veoma prijatna i profesionalna usluga. Veoma detaljno i sve objašnjava. Preporučujem svima 🙂🙏', 'Веома пријатна и професионална услуга. Веома детаљно и све објашњава. Препоручујем свима 🙂🙏', NULL, NULL, NULL, NULL,
    0, '2025-08-16 12:49:53'),

(@user_stefanie, @clinic_id, @doctor_julija_samardzic, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/Ci9DQUlRQUNvZENodHljRjlvT25sa2RHRllObU40YzJ0WU5YbGlWMEpuV0dGdVVWRRAB',
    5, 'en', 'Highly recommend Dr. Samardžić. She’s an excellent gynecologist. Knowledgeable, kind and very patient.',
    NULL, NULL, 'Highly recommend Dr. Samardžić. She’s an excellent gynecologist. Knowledgeable, kind and very patient.', NULL, NULL, NULL,
    0, '2026-10-24 00:00:00'),

(@user_irina_lutsenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xReFRYSXhWSGg0VkdoZldIZzJORFJ1Y3poVVFYYxAB',
    5, 'en', 'Very professional, highly recommended dr. Julia',
    NULL, NULL, 'Very professional, highly recommended dr. Julia', NULL, NULL, NULL,
    0, '2026-10-08 00:00:00'),

(@user_anastasija_tubic, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/Ci9DQUlRQUNvZENodHljRjlvT21KSWVtVjVObVpyZDBWTlpYTkxjREZNWnpKaFNVRRAB',
    5, 'hr', 'Predivne i profesionalne! Sve preporuke!',
    'Predivne i profesionalne! Sve preporuke!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_tamara_taca, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWS1RqUllhWEpHVFZkU1YwVkdWMjB6ZFRKRU9VRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_owl_troll, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWM1NWZG9NRm93ZEdkSFl6Rm9ORVV5Tm5kc1MxRRAB',
    5, 'ru', 'Доктор Юлия и её коллега работают очень деликатно и профессионально, добрые и отзывчивые люди. Все делают очень аккуратно и все максимально доступно объясняют.
Доктор говорит хорошо на английском языке, с пониманием относится к пациентам с плохим знанием языка🙏❤️

Очень рекомендую к посещению ✨✨✨

Записаться было очень просто, все цены и услуги можно узнать по номеру телефона(Viber).
Кабинет чистый, оборудование хорошее, атмосфера уютная.
Анализы присылают на почту.',
    NULL, NULL, NULL, 'Доктор Юлия и её коллега работают очень деликатно и профессионально, добрые и отзывчивые люди. Все делают очень аккуратно и все максимально доступно объясняют.
Доктор говорит хорошо на английском языке, с пониманием относится к пациентам с плохим знанием языка🙏❤️

Очень рекомендую к посещению ✨✨✨

Записаться было очень просто, все цены и услуги можно узнать по номеру телефона(Viber).
Кабинет чистый, оборудование хорошее, атмосфера уютная.
Анализы присылают на почту.', NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_dusica_vasic, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tGdVR6aFZaMDVhTXpsWk1FMXFRbWxLWHpSbmNXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_bojana_alasan, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s1MlNVTjNUbTlvTWtsRWFtdE1NRlV3UlRSUmRrRRAB',
    5, 'hr', 'Krajnja profesionalnost, sve pohvale takođe za zaposlene.
Preporuka za sve žene, nećete se pokajati.
Divna, smirena, strpljiva doktorica..
Slobodno sve pitajte bez sramezljivosti i straha, ona ce vam objasniti sve na najbolji i najtopliji mogući način.',
    'Krajnja profesionalnost, sve pohvale takođe za zaposlene.
Preporuka za sve žene, nećete se pokajati.
Divna, smirena, strpljiva doktorica..
Slobodno sve pitajte bez sramezljivosti i straha, ona ce vam objasniti sve na najbolji i najtopliji mogući način.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_dijana_crnogorac, @clinic_id, @doctor_julija_samardzic, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/ChdDSUhNMG9nS0VJQ0FnTUNneHZHM3lnRRAB',
    5, 'bs', 'Profesionalni, struna, posvecena, doktorica Julija💗
Topla preporuka za sve kojima je njena pomoć potrebna.',
    'Profesionalni, struna, posvecena, doktorica Julija💗
Topla preporuka za sve kojima je njena pomoć potrebna.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_biljana_krivokapic, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/ChdDSUhNMG9nS0VJQ0FnTUNneHFIWl9BRRAB',
    5, 'hr', 'Najbolja! Moja preporuka.',
    'Najbolja! Moja preporuka.', NULL, NULL, NULL, NULL, NULL,
    1, '2025-10-29 00:00:00'),

(@user_nadja_sekaric, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/ChZDSUhNMG9nS0VJQ0FnTUNneHJ6VFhREAE',
    5, 'bs', 'Potpisujem da nema profesionalnije i prijatnije doktorice!
Preporuka kao kuca!♥️ sve na nivou🥰',
    'Potpisujem da nema profesionalnije i prijatnije doktorice!
Preporuka kao kuca!♥️ sve na nivou🥰', NULL, NULL, NULL, NULL, NULL,
    1, '2025-10-29 00:00:00'),

(@user_violeta_stevovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/ChZDSUhNMG9nS0VJQ0FnTUNneHNEZ0t3EAE',
    5, 'hr', 'Doktorka je veoma posvećena i stručna!
Prwzadovoljna sam uslugama i savetima.
Moja preporuka.',
    'Doktorka je veoma posvećena i stručna!
Prwzadovoljna sam uslugama i savetima.
Moja preporuka.', NULL, NULL, NULL, NULL, NULL,
    1, '2025-10-29 00:00:00'),

(@user_borka_scepanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/ChZDSUhNMG9nS0VJQ0FnTUNnaHRIc1J3EAE',
    5, 'hr', 'Pristupačna i profesionalna,definitivno je preporučujem svima.',
    'Pristupačna i profesionalna,definitivno je preporučujem svima.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ksenija_fatic, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/ChdDSUhNMG9nS0VJQ0FnTUNnaHBIM25nRRAB',
    5, 'hr', 'Preljubazna i predobra doktorica',
    'Preljubazna i predobra doktorica', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_bojana_bojana, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/ChZDSUhNMG9nS0VJQ0FnTUNnaHNIVUhnEAE',
    5, 'hr', 'Sve preporuke! Profesionalnost i stručnost, sve na jednom mjestu.',
    'Sve preporuke! Profesionalnost i stručnost, sve na jednom mjestu.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_sofiaj_cerovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/ChdDSUhNMG9nS0VJQ0FnTUNnaHNHY2xRRRAB',
    5, 'hr', 'Krajnje profesionalno,sve preporuke.',
    'Krajnje profesionalno,sve preporuke.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_vanja_samardzic, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/ChdDSUhNMG9nS0VJQ0FnTUNnaG83V2dRRRAB',
    5, 'hr', 'Sve preporuke. Ljubaznost, strucnost, sve na jednom mjestu!',
    'Sve preporuke. Ljubaznost, strucnost, sve na jednom mjestu!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dragana, @clinic_id, NULL, 'google_maps',
    'places/ChIJnx6daAAxTBMRv3yePloZC4c/reviews/ChdDSUhNMG9nS0VJQ0FnTUNnaHViTnVRRRAB',
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
