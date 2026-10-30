-- Insert Google Maps reviews for Dental Smile
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dental-smile-tivat.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dental-smile-tivat');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_danijela_sindik = (SELECT id FROM doctors WHERE slug = 'danijela-sindik');
SET @doctor_nevena_djuricic = (SELECT id FROM doctors WHERE slug = 'nevena-djuricic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ilya Golovachev', 'https://lh3.googleusercontent.com/a/ACg8ocIY4bJertHt2OaxiLYZrlhHOkDb7DQAw-Qzm04N9H7ishXx7Q=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/103328745771959333470/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103328745771959333470/reviews');
SET @user_ilya_golovachev = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103328745771959333470/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milan Kovacevic', 'https://lh3.googleusercontent.com/a-/ALV-UjWRHZjQe5fVW_f7PjFml7B0qFhOrbgTO-uMQOAsSOzGcSx04Xqd=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106765056400255714125/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106765056400255714125/reviews');
SET @user_milan_kovacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106765056400255714125/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ira Tzourou', 'https://lh3.googleusercontent.com/a-/ALV-UjVX_-hXiMxq6GwibEGQare4IcfcJiQpUtkuGb1xAwG6bgsjFS8=s128-c0x00000000-cc-rp-mo-ba6', 'https://www.google.com/maps/contrib/115998795640476176537/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115998795640476176537/reviews');
SET @user_ira_tzourou = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115998795640476176537/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olga Sidorova', 'https://lh3.googleusercontent.com/a/ACg8ocKlJxgcDuXDYRz-JnMv715wyz_P1byhWuMeZRKmrNRTS1rTQg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101957471800609855214/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101957471800609855214/reviews');
SET @user_olga_sidorova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101957471800609855214/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'faruk yıldırım', 'https://lh3.googleusercontent.com/a-/ALV-UjUQD63F8-wdUdgPu0uQ7CCfjEpYpCwKCcipLfWmWyh_f8vnWAU=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107318133696134365128/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107318133696134365128/reviews');
SET @user_faruk_yldrm = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107318133696134365128/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Suncica Sljukic', 'https://lh3.googleusercontent.com/a/ACg8ocK4kR--XeGDqeq3QKs2kbOEI65lfSkaSynvA_ZFm_xjPfUViA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108287190259379087604/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108287190259379087604/reviews');
SET @user_suncica_sljukic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108287190259379087604/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zivko Cirjanic', 'https://lh3.googleusercontent.com/a/ACg8ocJdjVBPI654KyWdpAdYck5jbMAMAi1RE_7XCdyr_IlQB8786g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111113589153433123336/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111113589153433123336/reviews');
SET @user_zivko_cirjanic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111113589153433123336/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'mirjana rautovic', 'https://lh3.googleusercontent.com/a/ACg8ocK4j9eOWzOb1bMOrmYNFhS9xoU8Fz79Iou_KtDT-vpSrKGH9Q=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115076232543147051801/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115076232543147051801/reviews');
SET @user_mirjana_rautovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115076232543147051801/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirko Bulajic', 'https://lh3.googleusercontent.com/a-/ALV-UjXRlRZbzkZYqZ8cBP8CfLyxxn0UNdeWNkPtCUcCAh5Ivk_E0zA1=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108105988634452135701/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108105988634452135701/reviews');
SET @user_mirko_bulajic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108105988634452135701/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'HakanK', 'https://lh3.googleusercontent.com/a/ACg8ocI0eGjVtLk2o-HG6cp9mbVw7MsITTEm6pX9A6bFoDwRzmTBueg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111458179498559008750/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111458179498559008750/reviews');
SET @user_hakank = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111458179498559008750/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Niklas Jack', 'https://lh3.googleusercontent.com/a/ACg8ocLfs19KMLqAor_4uDFlA5q8ZmxUFyBLjoBQeGaGUGWav9etIg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117380748292452286663/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117380748292452286663/reviews');
SET @user_niklas_jack = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117380748292452286663/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dejan', 'https://lh3.googleusercontent.com/a-/ALV-UjU42ZNHOCOZKuelTasYjr9gbTmkyxdqriLtM4haZUi8y2yXXxkY=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107804676589937224551/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107804676589937224551/reviews');
SET @user_dejan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107804676589937224551/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja Burazin', 'https://lh3.googleusercontent.com/a/ACg8ocKeOQKZLVfRoxUVCz7wKSYs1i5xQ0jZrsaQOKFzz_1GgrDpCw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113182869748884621623/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113182869748884621623/reviews');
SET @user_sanja_burazin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113182869748884621623/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maksim Zakharov', 'https://lh3.googleusercontent.com/a/ACg8ocL5erPWuuR1I6GwKwqKpTd23yGf24MVC4vrAmM_1ddbbnlrEYw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115507616414514538668/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115507616414514538668/reviews');
SET @user_maksim_zakharov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115507616414514538668/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Lucic', 'https://lh3.googleusercontent.com/a-/ALV-UjU8tZo7SZtDvKdhU9B9GmUSK6mdJYPKHmBuYjHFY2izlPOO59Dc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101891765841629970084/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101891765841629970084/reviews');
SET @user_luka_lucic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101891765841629970084/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Екатерина Врублевская', 'https://lh3.googleusercontent.com/a-/ALV-UjWQXpgiJ__wP196Fjp4ekD4ML-s_ehN4uZNNVm91YlFfaETXmu1-A=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109959085880864647538/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109959085880864647538/reviews');
SET @user_ekaterina_vrublevskaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109959085880864647538/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Meryem Mara', 'https://lh3.googleusercontent.com/a/ACg8ocKYWuLNJOGhM_-t61ksv8o3Zi4-Z-05CFwq-j4wGB2w61vvIQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117093825603031087753/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117093825603031087753/reviews');
SET @user_meryem_mara = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117093825603031087753/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sedef Tekin', 'https://lh3.googleusercontent.com/a-/ALV-UjUslZ32w7WTzNAjM241Q34EwnmK4eB7AwY7X5VsDvHFhKG001Pa=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101122588776031235737/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101122588776031235737/reviews');
SET @user_sedef_tekin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101122588776031235737/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Valentina Brkan', 'https://lh3.googleusercontent.com/a-/ALV-UjWCNY11ZWvV4lZ3unTWY4RwbCt0gsTM7Xl7VTPaYC4G1GaFe-C7=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105262469652379309511/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105262469652379309511/reviews');
SET @user_valentina_brkan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105262469652379309511/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vanja Kovacevic', 'https://lh3.googleusercontent.com/a/ACg8ocKDWPuCpdeVeBdxcVbadhlwqzosiXNff-wh-4sNOyRvd8Qfdw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116608970155724779652/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116608970155724779652/reviews');
SET @user_vanja_kovacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116608970155724779652/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'James Benning', 'https://lh3.googleusercontent.com/a-/ALV-UjXE4JTybtkqju3A9LpK5ld-3QhDJvxfMHbRGRXE-GfICbTb9Dc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117605983798156730844/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117605983798156730844/reviews');
SET @user_james_benning = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117605983798156730844/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Budo', 'https://lh3.googleusercontent.com/a-/ALV-UjVbMyu-YEUsF-v_GI2IY0LhgT7AdwcZFevp6YRCLEY70LxtObo=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/118171003026180834571/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118171003026180834571/reviews');
SET @user_budo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118171003026180834571/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Biljana Bauk', 'https://lh3.googleusercontent.com/a-/ALV-UjVGyRgfek0F-SlTb9ps5Y_NCSPl1Y9JsbH83e51Lq0GkieVrZuTyg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105000304893128842644/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105000304893128842644/reviews');
SET @user_biljana_bauk = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105000304893128842644/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kristina R', 'https://lh3.googleusercontent.com/a/ACg8ocKRbDx9aVcPtjzzN07llcD1Kglz62B_EASLU0g7I4ALoueh0yJp=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110776116066178757611/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110776116066178757611/reviews');
SET @user_kristina_r = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110776116066178757611/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Juskovic', 'https://lh3.googleusercontent.com/a/ACg8ocJiIh_31unBn11C5XnAXItc0E7gPgm42X_4NrtlCCLQ66MyPg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114757667348362913996/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114757667348362913996/reviews');
SET @user_maja_juskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114757667348362913996/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'DOKILE', 'https://lh3.googleusercontent.com/a-/ALV-UjUPkNBPKxMgubSjrixzL66Yk1tMI7Wod1ta4Wo0LyU-7PzuXhfc=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102536852865511504460/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102536852865511504460/reviews');
SET @user_dokile = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102536852865511504460/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marina Perovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWUCFy0G_adpL_F20Xs8jQBkSt-7GyfRLtFTzRnMsnx0Y8n8Wjnig=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113465534779398947743/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113465534779398947743/reviews');
SET @user_marina_perovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113465534779398947743/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milorad Mitrovic', 'https://lh3.googleusercontent.com/a/ACg8ocJXTABjhNG6LAh7C5VxI2GGDwJFuDDPNDbHScM52dI9R9Un5g=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100023294057476479203/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100023294057476479203/reviews');
SET @user_milorad_mitrovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100023294057476479203/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Klinci Village Resort Montenegro', 'https://lh3.googleusercontent.com/a-/ALV-UjVVulTCP-MsTuONWOUwVUW3B2FnfDCy6sB_PKNf8y-SjkdtI_Lq=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102864751836895449800/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102864751836895449800/reviews');
SET @user_klinci_village_resort_montenegro = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102864751836895449800/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Viktorija Samardžić', 'https://lh3.googleusercontent.com/a-/ALV-UjU9wpL9ClnEqxBmXUIOHP9yqT6dE6lFlom1ZoeBLU6Nn4JTsSFt=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102531496487726760200/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102531496487726760200/reviews');
SET @user_viktorija_samardi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102531496487726760200/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Celil Göde', 'https://lh3.googleusercontent.com/a-/ALV-UjUM5TRXEdQrX44IicdqTgM8IL8kh7dx8xEEqH2C_oqaXPUq77y-=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117130424857479887659/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117130424857479887659/reviews');
SET @user_celil_gde = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117130424857479887659/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_ilya_golovachev, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKc1ZXUklja2w2ZFRkT1JrNUZhVmxLWDNGeVJYYxAB',
    5, 'en', 'I’m absolutely delighted with my visit! 🦷
Dr. Katarina did several fillings, removed the root canals, and performed a professional teeth cleaning — all completely pain-free. She is an outstanding dentist: attentive, gentle, and truly skilled. Everything was done with great care, and the whole experience was incredibly comfortable. The results are simply amazing. Thank you, Dr. Katarina, for your excellent work and genuine care for your patients. I will definitely be coming back only to you!',
    'Apsolutno sam oduševljena svojom posetom! 🦷
Dr Katarina je uradila nekoliko plombi, uklonila korenske kanale i obavila profesionalno čišćenje zuba — sve potpuno bez bola. Ona je izvanredan stomatolog: pažljiva, nežna i zaista vešta. Sve je urađeno sa velikom pažnjom, a celokupno iskustvo je bilo neverovatno udobno. Rezultati su jednostavno neverovatni. Hvala vam, dr Katarina, na vašem odličnom radu i iskrenoj brizi o vašim pacijentima. Definitivno ću se vraćati samo vama!', 'Апсолутно сам одушевљена својом посетом! 🦷
Др Катарина је урадила неколико пломби, уклонила коренске канале и обавила професионално чишћење зуба — све потпуно без бола. Она је изванредан стоматолог: пажљива, нежна и заиста вешта. Све је урађено са великом пажњом, а целокупно искуство је било невероватно удобно. Резултати су једноставно невероватни. Хвала вам, др Катарина, на вашем одличном раду и искреној бризи о вашим пацијентима. Дефинитивно ћу се враћати само вама!', 'I’m absolutely delighted with my visit! 🦷
Dr. Katarina did several fillings, removed the root canals, and performed a professional teeth cleaning — all completely pain-free. She is an outstanding dentist: attentive, gentle, and truly skilled. Everything was done with great care, and the whole experience was incredibly comfortable. The results are simply amazing. Thank you, Dr. Katarina, for your excellent work and genuine care for your patients. I will definitely be coming back only to you!', NULL, NULL, NULL,
    0, '2025-08-13 22:54:42'),

(@user_milan_kovacevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChdDSUhNMG9nS0VJS0ZrcFBROXFxZWtnRRAB',
    5, 'hr', 'Doktorica Katarina zaslužuje sve pohvale i najvišu ocjenu! Od samog ulaska u ordinaciju, njen pristup uliva povjerenje i sigurnost. Iako je mlada, odiše ogromnim znanjem, sigurnošću u radu i profesionalnošću koju često ne viđamo ni kod mnogo iskusnijih stomatologa.

Pristup pacijentu joj je topao i pažljiv, sve objašnjava strpljivo i detaljno, a njen rad je pedantan, precizan i bez greške. Osjeća se da voli ono što radi, i to se direktno prenosi na pacijenta – osjećao sam se potpuno opušteno i sigurno tokom cijelog tretmana.

Imponuje vidjeti tako mladu osobu s tolikom strašću, znanjem i odgovornošću. Velika preporuka svima koji traže stomatologa kome se može vjerovati. Katarina je pravi primjer kako stručnost i ljudskost mogu ići ruku pod ruku.

Nakon mnogo godina neodlazaka kod zubara, osjećao sam strah i nelagodu, ali zahvaljujući njenom pristupu, to je nestalo već pri prvom susretu. Danas se osjećam odlično, sa osmijehom na licu, zahvaljujući upravo njoj.

Velika preporuka svima koji traže stomatologa kome se može vjerovati, koji radi s ljubavlju i znanjem. Katarina je sjajan primjer mlade stručnjakinje kojoj je pred sobom velika karijera!',
    'Doktorica Katarina zaslužuje sve pohvale i najvišu ocjenu! Od samog ulaska u ordinaciju, njen pristup uliva povjerenje i sigurnost. Iako je mlada, odiše ogromnim znanjem, sigurnošću u radu i profesionalnošću koju često ne viđamo ni kod mnogo iskusnijih stomatologa.

Pristup pacijentu joj je topao i pažljiv, sve objašnjava strpljivo i detaljno, a njen rad je pedantan, precizan i bez greške. Osjeća se da voli ono što radi, i to se direktno prenosi na pacijenta – osjećao sam se potpuno opušteno i sigurno tokom cijelog tretmana.

Imponuje vidjeti tako mladu osobu s tolikom strašću, znanjem i odgovornošću. Velika preporuka svima koji traže stomatologa kome se može vjerovati. Katarina je pravi primjer kako stručnost i ljudskost mogu ići ruku pod ruku.

Nakon mnogo godina neodlazaka kod zubara, osjećao sam strah i nelagodu, ali zahvaljujući njenom pristupu, to je nestalo već pri prvom susretu. Danas se osjećam odlično, sa osmijehom na licu, zahvaljujući upravo njoj.

Velika preporuka svima koji traže stomatologa kome se može vjerovati, koji radi s ljubavlju i znanjem. Katarina je sjajan primjer mlade stručnjakinje kojoj je pred sobom velika karijera!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-05-31 19:30:52'),

(@user_ira_tzourou, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChdDSUhNMG9nS0VJQ0FnSURWXzZpazlnRRAB',
    5, 'el', 'Η γιατρός ξέρει αγγλικά και αυτό βοηθάει πολύ.  Είναι επαγγελματίας και συνεπείς. Χαίρομαι να βλέπω σοκολατένια λόγο Χριστουγέννων:)',
    'Doktorka govori engleski i to mnogo pomaže. Profesionalna je i dosledna. Drago mi je da vidim čokolade za Božić :)', 'Докторка говори енглески и то много помаже. Професионална је и доследна. Драго ми је да видим чоколаде за Божић :)', NULL, NULL, NULL, NULL,
    0, '2023-12-19 19:18:04'),

(@user_olga_sidorova, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChdDSUhNMG9nS0VJM0p6ZkNTbWF2ZDJ3RRAB',
    5, 'bs', 'Brzo i bezbolno su stavili plombu u zub moje ćerke! Preporučujem dr Katarinu👏👏👏',
    'Brzo i bezbolno su popunili zub moje ćerke! Preporučujem dr Katarinu👏👏👏', 'Брзо и безболно су попунили зуб моје ћерке! Препоручујем др Катарину👏👏👏', NULL, NULL, NULL, NULL,
    0, '2025-05-28 09:49:47'),

(@user_faruk_yldrm, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChdDSUhNMG9nS0VJQ0FnSURycF91WjZnRRAB',
    5, 'tr', 'Öncelikle bu kliniği sectigim için Çok şanslıyım doktorları muhteşem karşılama on üzerinden on ilgi alaka süper doktorum Katerina hanım dişlerimle çok güzel ilgilendi tedavisini süper bir şekilde tamamladı ve herkese tavsiye ederim',
    'Pre svega, veoma sam srećan što sam izabrao ovu kliniku. Lekari su divni, doček deset od deset, pažnja je velika, moja super doktorka Katerina je veoma lepo brinula o mojim zubima, završila tretman na super način i preporučujem svima.', 'Пре свега, веома сам срећан што сам изабрао ову клинику. Лекари су дивни, дочек десет од десет, пажња је велика, моја супер докторка Катерина је веома лепо бринула о мојим зубима, завршила третман на супер начин и препоручујем свима.', NULL, NULL, NULL, 'Öncelikle bu kliniği sectigim için Çok şanslıyım doktorları muhteşem karşılama on üzerinden on ilgi alaka süper doktorum Katerina hanım dişlerimle çok güzel ilgilendi tedavisini süper bir şekilde tamamladı ve herkese tavsiye ederim',
    0, '2024-07-20 22:17:23'),

(@user_suncica_sljukic, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/Ci9DQUlRQUNvZENodHljRjlvT25kWldXOXRRMHQ1YW05RWFXRXRkSHBRUmpOSlRtYxAB',
    1, 'bs', 'Pogresan zub lecen. Dr tvrdi da je petica u pitanju, nju je “sanirala”, da bi se na kraju ispostavilo da je gangrena napala sedmicu, koju ona na snimku nije videla. Toliko o strucnosti. Vazno da se uzme sto vise para. Da mogu nulu bih dala! Nikada vise!!! Zaobilazite u sirokom luku!',
    'Pogresan zub lecen. Dr tvrdi da je petica u pitanju, nju je “sanirala”, da bi se na kraju ispostavilo da je gangrena napala sedmicu, koju ona na snimku nije videla. Toliko o strucnosti. Vazno da se uzme sto vise para. Da mogu nulu bih dala! Nikada vise!!! Zaobilazite u sirokom luku!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_zivko_cirjanic, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kcVQyeENVMFExVGxkVWEyVnZlRXRPYVY5QldHYxAB',
    5, 'en', 'My husband and wish to thank the staff and specially DR. Daniela for her patients and treatments  I have received with great care and attention to detail with everthing  explained . The level is
ona par with  the U.k. if not above.
Thank You so very  much with regards from
Mara (Maca) Cirjanic Birmingham England.',
    NULL, NULL, 'My husband and wish to thank the staff and specially DR. Daniela for her patients and treatments  I have received with great care and attention to detail with everthing  explained . The level is
ona par with  the U.k. if not above.
Thank You so very  much with regards from
Mara (Maca) Cirjanic Birmingham England.', NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_mirjana_rautovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twbGFHSXdWMEpKYzFOemMwUjBOelIzU20xeU5GRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_mirko_bulajic, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twNGMwMTRYeTFCWW5WUlZISjVZV2hTZEhOZldtYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_hakank, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoSU5qaDZlbXhIZDFCaWNHSnVXWGswWVhSNFMwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_niklas_jack, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChdDSUhNMG9nS0VJQ0FnSURmZ3ZEaDhBRRAB',
    1, 'en', 'Don’t be here. They didn’t wash my teeth very clean, even break one of them a scratch. And many teeth haven’t been touched at all… the worst experience ever have.',
    NULL, NULL, 'Don’t be here. They didn’t wash my teeth very clean, even break one of them a scratch. And many teeth haven’t been touched at all… the worst experience ever have.', NULL, NULL, NULL,
    1, '2025-10-29 00:00:00'),

(@user_dejan, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChZDSUhNMG9nS0VJQ0FnSUN6d3RIak5REAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_sanja_burazin, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChdDSUhNMG9nS0VJQ0FnSUN6MkxlemxnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_maksim_zakharov, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChZDSUhNMG9nS0VJQ0FnSURkNW82Y1pREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_luka_lucic, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChZDSUhNMG9nS0VJQ0FnSUM1NUp1cmRREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_ekaterina_vrublevskaya, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChdDSUhNMG9nS0VJQ0FnSURadXNERzBnRRAB',
    5, 'ru', 'Лучшая клиника в Тивате',
    NULL, NULL, NULL, 'Лучшая клиника в Тивате', NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_meryem_mara, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChdDSUhNMG9nS0VJQ0FnSUNoMEtpYzR3RRAB',
    1, 'en', 'Big unprofessionals',
    NULL, NULL, 'Big unprofessionals', NULL, NULL, NULL,
    2, '2023-10-29 00:00:00'),

(@user_sedef_tekin, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChZDSUhNMG9nS0VJQ0FnSURla0pEZkpnEAE',
    5, 'en', 'They are so helpful. Thanks them a lot🥰',
    NULL, NULL, 'They are so helpful. Thanks them a lot🥰', NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_valentina_brkan, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChZDSUhNMG9nS0VJQ0FnSUR1MEtURGNREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_vanja_kovacevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChZDSUhNMG9nS0VJQ0FnSUQyd19PR1FnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_james_benning, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChZDSUhNMG9nS0VJQ0FnSURXN292TGR3EAE',
    5, 'en', 'Having lived all over the world I can honestly say this is the best dentist I have been to! They are very caring and the quality of service is incredible. I highly recommend going to Dental Smile.',
    NULL, NULL, 'Having lived all over the world I can honestly say this is the best dentist I have been to! They are very caring and the quality of service is incredible. I highly recommend going to Dental Smile.', NULL, NULL, NULL,
    3, '2022-10-29 00:00:00'),

(@user_budo, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChdDSUhNMG9nS0VJQ0FnSUNXcHVEdjR3RRAB',
    5, 'bs', 'Sve pohvale.Stručnost i izuzetna korektnost.',
    'Sve pohvale.Stručnost i izuzetna korektnost.', NULL, NULL, NULL, NULL, NULL,
    2, '2022-10-29 00:00:00'),

(@user_biljana_bauk, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChZDSUhNMG9nS0VJQ0FnSURheTRxdGJBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_kristina_r, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChdDSUhNMG9nS0VJQ0FnSUN5cWZpRm9RRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_maja_juskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChdDSUhNMG9nS0VJQ0FnSUNjdmFudl9nRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_dokile, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChdDSUhNMG9nS0VJQ0FnSUNzMHNTSl93RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_marina_perovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChZDSUhNMG9nS0VJQ0FnSUMwcTRqVU1REAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_milorad_mitrovic, @clinic_id, @doctor_danijela_sindik, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChdDSUhNMG9nS0VJQ0FnSUNVbnViNnhBRRAB',
    5, 'hr', 'Dr. Danijela Sindik, vrhunski strucnjak. Sve pohvale!',
    'Dr. Danijela Sindik, vrhunski strucnjak. Sve pohvale!', NULL, NULL, NULL, NULL, NULL,
    4, '2019-10-29 00:00:00'),

(@user_klinci_village_resort_montenegro, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChZDSUhNMG9nS0VJQ0FnSUNRdzRTX1hnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_viktorija_samardi, @clinic_id, NULL, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChZDSUhNMG9nS0VJQ0FnSURnN1p1Wk5REAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_celil_gde, @clinic_id, @doctor_nevena_djuricic, 'google_maps',
    'places/ChIJydO23XcxTBMRzyYOeS5QKa4/reviews/ChdDSUhNMG9nS0VJQ0FnSURndHM3WXp3RRAB',
    1, 'en', 'They are using very old treatment methods and forbidden medicines in most of the countries. Nevena Đuričić is rude and  ignorant. When I asked few questions about the procedure of the treatment; she said “if you don’t like, you can go to your country”.  I left my treatment in the middle and I found a new dentist. And we learned that the treatment she did until now was completely unsuccessful. She tried to do the canal treatment without finding the nerves!',
    NULL, NULL, 'They are using very old treatment methods and forbidden medicines in most of the countries. Nevena Đuričić is rude and  ignorant. When I asked few questions about the procedure of the treatment; she said “if you don’t like, you can go to your country”.  I left my treatment in the middle and I found a new dentist. And we learned that the treatment she did until now was completely unsuccessful. She tried to do the canal treatment without finding the nerves!', NULL, NULL, NULL,
    10, '2018-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
