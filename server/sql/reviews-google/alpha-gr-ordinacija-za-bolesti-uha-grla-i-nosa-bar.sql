-- Insert Google Maps reviews for Orl ambulanta "AlphaGR" Radjenovic
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/alpha-gr-ordinacija-za-bolesti-uha-grla-i-nosa-bar.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'alpha-gr-ordinacija-za-bolesti-uha-grla-i-nosa-bar');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_radjenovic_gordana = (SELECT id FROM doctors WHERE slug = 'radjenovic-gordana');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanija Szelag', 'https://lh3.googleusercontent.com/a/ACg8ocKtchRwp13gffIIu46qwsXUr2q2MFa30w4k4y9cAE2vlT7U1Q=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/102323470641435269166/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102323470641435269166/reviews');
SET @user_sanija_szelag = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102323470641435269166/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Snizhana', 'https://lh3.googleusercontent.com/a/ACg8ocIcUEYJE5_eKgbbu4P16JHP5pXd_AWkZcZrdJea_QdplX34Ag=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/111313017442271997763/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111313017442271997763/reviews');
SET @user_snizhana = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111313017442271997763/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nada Andjelkovic', 'https://lh3.googleusercontent.com/a/ACg8ocKx3rA8PWH4RhkSRKQqoUqXhsrd8983CRTZQiv_S4Q3HE__vA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111743704387845009932/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111743704387845009932/reviews');
SET @user_nada_andjelkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111743704387845009932/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Torsten Fricke', 'https://lh3.googleusercontent.com/a/ACg8ocJCAfTYIdoMxjAr3AgZCSLteOfW9v3ED-kdU9COLDj0NTeYcQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/114169556410792367402/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114169556410792367402/reviews');
SET @user_torsten_fricke = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114169556410792367402/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Letica Rokvić', 'https://lh3.googleusercontent.com/a/ACg8ocLfZHuzHmjZW53g1rCcy0dTHq4Fyp5hm2LjvNoXLKe2wQD99g=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/104570922143739355197/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104570922143739355197/reviews');
SET @user_letica_rokvi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104570922143739355197/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'leonora bunjaku', 'https://lh3.googleusercontent.com/a-/ALV-UjUem6WZBGYbBHZq5XMdBlOV-UqZiLqzQHjRP9grNRC5pyE_DslA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115628422303980531447/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115628422303980531447/reviews');
SET @user_leonora_bunjaku = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115628422303980531447/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Жељко Јочић', 'https://lh3.googleusercontent.com/a-/ALV-UjUhmEW4mXB8vpuEsggwIqoEqCxLtRh_ZNcrbl9idruHo_MsOIlr=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117775625857056313774/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117775625857056313774/reviews');
SET @user_zheljko_jochic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117775625857056313774/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ognjen Drašković', 'https://lh3.googleusercontent.com/a/ACg8ocLQXelrPy7TredIb9KcqGm9tXFCY_6AJM2Ks_bfiDx4LLDvqw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103803286985635077938/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103803286985635077938/reviews');
SET @user_ognjen_drakovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103803286985635077938/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Janko Joksimovic', 'https://lh3.googleusercontent.com/a/ACg8ocIwViw4FPH-cd9PwoePOKsTOp5rlvu30uwCT0uDLRj8HRtOEw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114834973656775769821/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114834973656775769821/reviews');
SET @user_janko_joksimovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114834973656775769821/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jozica Malic', 'https://lh3.googleusercontent.com/a/ACg8ocJObKgKzoVEwLxoMVrx5GnamQAAkbnsWV3hXQdjN7jwDemNCA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111178186709833255148/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111178186709833255148/reviews');
SET @user_jozica_malic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111178186709833255148/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marina Bogdanovic', 'https://lh3.googleusercontent.com/a/ACg8ocJpS10ps9SkXRIzvS2H7x8AfuucZ7SpGdpJ3eFiPGxgDZLzAA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114351555211159434679/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114351555211159434679/reviews');
SET @user_marina_bogdanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114351555211159434679/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nebojša Jovanović', 'https://lh3.googleusercontent.com/a/ACg8ocLfqyIOLYY1SDKPFwAuTsIqmAQYzpNWoWXexLiE4ROMM03m-Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116065707443977656456/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116065707443977656456/reviews');
SET @user_neboja_jovanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116065707443977656456/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Spasic', 'https://lh3.googleusercontent.com/a-/ALV-UjV9y51g5kr8fpktxFoDM7OPFy4-qML7QhrXcyx7wbNbxfUXtZJ2=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112510241296600504667/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112510241296600504667/reviews');
SET @user_jelena_spasic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112510241296600504667/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivica Rokvic', 'https://lh3.googleusercontent.com/a/ACg8ocKqY4tAcgP_YvFu30PTw04gzca2nu9ouIxmuqzBy2HWxmDlXg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116465779927440431961/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116465779927440431961/reviews');
SET @user_ivica_rokvic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116465779927440431961/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Smiljka Mirković', 'https://lh3.googleusercontent.com/a/ACg8ocLOc66eBo5UpRhSPTcw06d7bA105_D-2HzSxGeQvbnkHgC7Ag=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116837734922960798818/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116837734922960798818/reviews');
SET @user_smiljka_mirkovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116837734922960798818/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anita Soljanin', 'https://lh3.googleusercontent.com/a-/ALV-UjVAcN7CUfbYVCczgcoo-aZxg6p1B3M7kVkTrugdb-nRSq-NFUoO=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109626577780764236472/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109626577780764236472/reviews');
SET @user_anita_soljanin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109626577780764236472/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Medina Mevic', 'https://lh3.googleusercontent.com/a-/ALV-UjUX5FO-ylISLVIBPVe3ZbjZ_jVbBdzDcjqUKpZ32YW46asHOt4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104582392503780292709/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104582392503780292709/reviews');
SET @user_medina_mevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104582392503780292709/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Biljana Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocJQRbrxR4O0XXlgonchg-XwJVE12yt9xy13nOCpP1KfGgjSHw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102746059318300510122/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102746059318300510122/reviews');
SET @user_biljana_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102746059318300510122/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rajna Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocJSifJFO5PXDrwdGmxg9GQFo1OSqp2MjrKl7GXOxj_WqUtpDQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116304042643615240350/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116304042643615240350/reviews');
SET @user_rajna_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116304042643615240350/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anastasia Kachurina', 'https://lh3.googleusercontent.com/a-/ALV-UjX7kuuu32EN-WHg1uMBc156X0h-nYbJyOCn49RCfxi3h1-0fp7_=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116838482059232577089/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116838482059232577089/reviews');
SET @user_anastasia_kachurina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116838482059232577089/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ermin Crnovrsanin', 'https://lh3.googleusercontent.com/a/ACg8ocKUylqA-tAOABXn8QucsHZFR--y-V4kxBo38jfDjFz9PfUNgQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101189970073928591525/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101189970073928591525/reviews');
SET @user_ermin_crnovrsanin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101189970073928591525/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Oleksandra', 'https://lh3.googleusercontent.com/a-/ALV-UjXFv2aHxCafXETF9tn1YYnh9OriWSEZNdwQiJohtNAmQ9kWlZyZwg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111713572772811594328/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111713572772811594328/reviews');
SET @user_oleksandra = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111713572772811594328/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sava Vujic', 'https://lh3.googleusercontent.com/a-/ALV-UjXbRrd5UYaLTdfFEY3CYmdRZ6PXyoeErL7kyGF_UrLh9-RrkhY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115775691428277441517/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115775691428277441517/reviews');
SET @user_sava_vujic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115775691428277441517/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mauro PETRANOVIC', 'https://lh3.googleusercontent.com/a-/ALV-UjWJWaSawFj1K11h4Ap6ojbVSGmMdIMpTW5_6Iypqm6HDCw8jZLq=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117024306777448298746/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117024306777448298746/reviews');
SET @user_mauro_petranovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117024306777448298746/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branislav Milićević', 'https://lh3.googleusercontent.com/a-/ALV-UjWApVq78HQSH0e_DvkYyiJy504NWNxI1YJxh1yTW_MOqdB7HRk=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114419388370476664471/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114419388370476664471/reviews');
SET @user_branislav_milievi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114419388370476664471/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mira Prentovic', 'https://lh3.googleusercontent.com/a/ACg8ocLQV7tL9tnT_IwaGDGNIhHfxqI-tfH1gJwb0gmZ9e6I22TVHg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115543759418597449196/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115543759418597449196/reviews');
SET @user_mira_prentovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115543759418597449196/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dina Crnovrsanin', 'https://lh3.googleusercontent.com/a-/ALV-UjXxgMHKMmH4y9_XSgPYeS6hqSDE_c8JPE5xWeFAip9CysXBJfss=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102621131181132343484/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102621131181132343484/reviews');
SET @user_dina_crnovrsanin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102621131181132343484/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Darija Popovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXe6TjynztH2OiAETGd2gzxKlwhPn-Sr-AmkrR7WTLtFZ2KIzeO=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118055649554465578466/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118055649554465578466/reviews');
SET @user_darija_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118055649554465578466/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_sanija_szelag, @clinic_id, @doctor_radjenovic_gordana, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xKRFMwRlNUV2xrTVd4d1JYRnpSVzAzWDFBM2NsRRAB',
    5, 'de', 'Als wir diesen Sommer im Urlaub in Montenegro waren, bekam mein Mann plötzlich Ohrenschmerzen, die mehrere Tage nicht besser wurden. Wir wollten der Sache auf den Grund gehen und haben so Dr. Gordana Radjenovic gefunden. Sie hat uns super betreut, die Ursache direkt gefunden und uns die richtigen Medikamente verschrieben, sodass innerhalb von 24h alle Schmerzen komplett verschwunden waren. Nochmals vielen Dank dafür! Wir können Dr. Gordana Radjenovic wärmstens jedem empfehlen!',
    'Dok je ovog leta bio na odmoru u Crnoj Gori, moj muž je iznenada osetio bol u uhu koji je trajao nekoliko dana. Želeli smo da dođemo do suštine problema i pronašli smo dr Gordanu Rađenović. Pružila je odličnu negu, brzo je utvrdila uzrok i prepisala odgovarajuće lekove, tako da je sav bol potpuno nestao u roku od 24 sata. Hvala vam još jednom puno! Svima toplo preporučujemo dr Gordanu Rađenović!', 'Док је овог лета био на одмору у Црној Гори, мој муж је изненада осетио бол у уху који је трајао неколико дана. Желели смо да дођемо до суштине проблема и пронашли смо др Гордану Рађеновић. Пружила је одличну негу, брзо је утврдила узрок и преписала одговарајуће лекове, тако да је сав бол потпуно нестао у року од 24 сата. Хвала вам још једном пуно! Свима топло препоручујемо др Гордану Рађеновић!', NULL, NULL, 'Als wir diesen Sommer im Urlaub in Montenegro waren, bekam mein Mann plötzlich Ohrenschmerzen, die mehrere Tage nicht besser wurden. Wir wollten der Sache auf den Grund gehen und haben so Dr. Gordana Radjenovic gefunden. Sie hat uns super betreut, die Ursache direkt gefunden und uns die richtigen Medikamente verschrieben, sodass innerhalb von 24h alle Schmerzen komplett verschwunden waren. Nochmals vielen Dank dafür! Wir können Dr. Gordana Radjenovic wärmstens jedem empfehlen!', NULL,
    0, '2025-08-03 09:02:01'),

(@user_snizhana, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUNxdl9fbkVnEAE',
    5, 'ru', 'Посетила сегодня тут ЛОРа, так как ухо было заложено уже 5 дней, после всех ныряний. Всё прошло отлично, хорошая медсестра, отличный врач, довольно всё оперативно (так как была без записи, была небольшая очередь, аж 1 человек))). Стоимость 30 евро. В них входит консультация ,процедуры и лекартвеные манипуляции на месте. Не бойтесь обращаться. Надеюсь отзыв кому-то поможет. Спасибо данному специалисту!',
    'Danas sam posetila ORL specijalistu jer mi je uvo bilo začepljeno pet dana posle svih ronjenja. Sve je prošlo odlično, medicinska sestra je bila sjajna, doktor je bio odličan, i sve je urađeno prilično brzo (pošto sam otišla bez zakazivanja, bio je kratak red, samo jedna osoba). Cena je bila 30 evra. Ovo uključuje konsultacije, procedure i lekove na licu mesta. Ne bojte se da ih kontaktirate. Nadam se da će ova recenzija nekome pomoći. Hvala ovom specijalisti!', 'Данас сам посетила ОРЛ специјалисту јер ми је уво било зачепљено пет дана после свих роњења. Све је прошло одлично, медицинска сестра је била сјајна, доктор је био одличан, и све је урађено прилично брзо (пошто сам отишла без заказивања, био је кратак ред, само једна особа). Цена је била 30 евра. Ово укључује консултације, процедуре и лекове на лицу места. Не бојте се да их контактирате. Надам се да ће ова рецензија некоме помоћи. Хвала овом специјалисти!', NULL, 'Посетила сегодня тут ЛОРа, так как ухо было заложено уже 5 дней, после всех ныряний. Всё прошло отлично, хорошая медсестра, отличный врач, довольно всё оперативно (так как была без записи, была небольшая очередь, аж 1 человек))). Стоимость 30 евро. В них входит консультация ,процедуры и лекартвеные манипуляции на месте. Не бойтесь обращаться. Надеюсь отзыв кому-то поможет. Спасибо данному специалисту!', NULL, NULL,
    1, '2021-06-24 12:25:35'),

(@user_nada_andjelkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUNHanNTMnFnRRAB',
    5, 'bs', 'Zakazala sam pregled kod Orl specijalitet za dete. Sestra me je ljubazno dočekala tačno u zakazanom terminu. Doktorka se sa puno nežnosti obhodila prema detetu, tako da je pregled sjajno prošao bez placa za razliku od ranijih poseta lekarima.
Divno iskustvo. Moje preporuke.

.',
    'Zakazala sam pregled u Dečjoj specijalističkoj ordinaciji Orl. Medicinska sestra me je ljubazno dočekala u zakazano vreme. Doktorka je postupala sa detetom sa puno nežnosti, tako da je pregled prošao odlično, bez ikakve muke, za razliku od prethodnih poseta lekarima.
Divno iskustvo. Moje preporuke.

.', 'Заказала сам преглед у Дечјој специјалистичкој ординацији Орл. Медицинска сестра ме је љубазно дочекала у заказано време. Докторка је поступала са дететом са пуно нежности, тако да је преглед прошао одлично, без икакве муке, за разлику од претходних посета лекарима.
Дивно искуство. Моје препоруке.

.', NULL, NULL, NULL, NULL,
    0, '2021-10-29 08:05:18'),

(@user_torsten_fricke, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUNwby1yeVh3EAE',
    5, 'de', 'Unser Kind wurde bestens betreut und versorgt. Gute Englisch Kenntnisse. Vorgefertigte Zettel auch auf deutsch für Medikamente Einnahmen.',
    'Naše dete je dobilo odličnu negu i pažnju. Dobro znanje engleskog jezika. Uputstva za lekove su takođe data na nemačkom jeziku.', 'Наше дете је добило одличну негу и пажњу. Добро знање енглеског језика. Упутства за лекове су такође дата на немачком језику.', NULL, NULL, 'Unser Kind wurde bestens betreut und versorgt. Gute Englisch Kenntnisse. Vorgefertigte Zettel auch auf deutsch für Medikamente Einnahmen.', NULL,
    1, '2023-08-09 13:14:15'),

(@user_letica_rokvi, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChZDSUhNMG9nS0VJQ0FnTUNZb2VLR0ZREAE',
    5, 'hr', 'Izuzetna profesionalna usluga….ljubaznost, a pre svega strucnost na najvišem nivou !!!',
    'Izuzetna profesionalna usluga...ljubaznost, a pre svega stručnost na najvišem nivou!!!', 'Изузетна професионална услуга...љубазност, а пре свега стручност на највишем нивоу!!!', NULL, NULL, NULL, NULL,
    0, '2025-05-04 20:19:54'),

(@user_leonora_bunjaku, @clinic_id, @doctor_radjenovic_gordana, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s1TmRXUkVhRXcyVUdkSmVHMXBlRTAxZGt0VlNWRRAB',
    5, 'en', 'Excellent experiences at this private ENT clinic in Bar for myself and my family! Dr. Gordana is incredibly professional, thorough, and genuinely caring. She takes the time for proper examination, explains everything clearly, and offers the most appropriate treatment plan that never fails. The Nurse is friendly and efficient, appointments are on time, and visits feel calm and reassuring rather than rushed. I would highly recommend this clinic to anyone in Bar looking for a skilled and attentive ENT specialist. Five stars, without hesitation!',
    NULL, NULL, 'Excellent experiences at this private ENT clinic in Bar for myself and my family! Dr. Gordana is incredibly professional, thorough, and genuinely caring. She takes the time for proper examination, explains everything clearly, and offers the most appropriate treatment plan that never fails. The Nurse is friendly and efficient, appointments are on time, and visits feel calm and reassuring rather than rushed. I would highly recommend this clinic to anyone in Bar looking for a skilled and attentive ENT specialist. Five stars, without hesitation!', NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_zheljko_jochic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT25JeVdTMHhZVVozVUdwb1ExZEdkVlJhWVdOeFZsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_ognjen_drakovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT21zMVdYRmlRME5FV0ZSUVpXSTJNM1JIYTJGQ04zYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_janko_joksimovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pGZmFtSXRlRlpGZEZwSVdEaExVSGQyY2w5TWVFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_jozica_malic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twNVdWVnVjRm8xYVRWNWNEVllSa3A0TkdWc09FRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_marina_bogdanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4WE9ISk9ibkZ5YkdkME1TMW9RMkY0VGpoa1dXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_neboja_jovanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tKT1VGQmFOMGRqZVZST2JubFVTVVZOYlV0NFVuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jelena_spasic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT25OTVVsQkxWR3hIWlhGeE5sOW1hVXBFVW5CVmJGRRAB',
    5, 'hr', 'Sve preporuke',
    'Sve preporuke', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ivica_rokvic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChZDSUhNMG9nS0VJQ0FnTUNZb1lESEpREAE',
    5, 'hr', 'Profesionalna usluga,',
    'Profesionalna usluga,', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_smiljka_mirkovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChdDSUhNMG9nS0VJQ0FnTUNZMEpyU21BRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_anita_soljanin, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUNfdDV5NkZ3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_medina_mevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUNfOUk2VWFBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_biljana_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUN2cThmeUVnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_rajna_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUN2eTdXOTdRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_anastasia_kachurina, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUN2NDlfaElREAE',
    5, 'en', 'Professional medical care and attentive doctor. Thank you!',
    NULL, NULL, 'Professional medical care and attentive doctor. Thank you!', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ermin_crnovrsanin, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUM3Z3ViaGdBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_oleksandra, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUR6djQ2emd3RRAB',
    5, 'uk', 'Уважна доктор, все вислухала, не квапилась, призначає адекватне лікування, рекомендую',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_sava_vujic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUNkcnB5ZkdREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_mauro_petranovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUNkdG9MQkVnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_branislav_milievi, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUNsdXFpZzNBRRAB',
    5, 'hr', 'Izvrstan stručnjak i profesionalnost kakva se sve teže pronalazi.',
    'Izvrstan stručnjak i profesionalnost kakva se sve teže pronalazi.', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_mira_prentovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUNGMlpMSE13EAE',
    5, 'bs', 'Sjajan ljekar i pouzdan dijagnostičar, za svako poštovanje!',
    'Sjajan ljekar i pouzdan dijagnostičar, za svako poštovanje!', NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_dina_crnovrsanin, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChZDSUhNMG9nS0VJQ0FnSURCeU1HSE5BEAE',
    5, 'hr', 'Super profesionalno!',
    'Super profesionalno!', NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_darija_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFRWNch91ThMRKGA60QCrNVQ/reviews/ChZDSUhNMG9nS0VJQ0FnSURtamEzZk9BEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
