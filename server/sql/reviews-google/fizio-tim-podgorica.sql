-- Insert Google Maps reviews for FIZIO TIM CRNA GORA
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/fizio-tim-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'fizio-tim-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_srdjan_kojic = (SELECT id FROM doctors WHERE slug = 'srdjan-kojic');
SET @doctor_alen_pepic = (SELECT id FROM doctors WHERE slug = 'alen-pepic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Shibox TV', 'https://lh3.googleusercontent.com/a-/ALV-UjWHUIOo2kc9BBPiQorn3g-TugEFN7TQlpmK9omxsAvwtCosasxq=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/116241773647754009049/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116241773647754009049/reviews');
SET @user_shibox_tv = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116241773647754009049/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Krsto Covic', 'https://lh3.googleusercontent.com/a-/ALV-UjUQqI0LefQ3D6aN5zvy4V1FkX3BdX_6b59U7QJ6_Bw-k-QL4-Da=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/115628573627215068324/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115628573627215068324/reviews');
SET @user_krsto_covic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115628573627215068324/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Milosevic', 'https://lh3.googleusercontent.com/a/ACg8ocIqvmnfAdSJcQbsM8opGT2YYO15mpwAmrKHjLypGKJ8eOTCFQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107708198163637307485/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107708198163637307485/reviews');
SET @user_milica_milosevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107708198163637307485/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ana djurovic', 'https://lh3.googleusercontent.com/a/ACg8ocLcH3qTn1Zk-IBFNXhVLIJnQprTH2X4ElAUeHBHtqdYRXfc4A=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101263058516156574360/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101263058516156574360/reviews');
SET @user_ana_djurovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101263058516156574360/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Ilincic', 'https://lh3.googleusercontent.com/a/ACg8ocKS5Xl4MsT8PzvbuZi4LgVTKriOXavdB1anms5bOWuzDxWeXw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/116015067598503105480/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116015067598503105480/reviews');
SET @user_luka_ilincic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116015067598503105480/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Knežević', 'https://lh3.googleusercontent.com/a-/ALV-UjWj9uRvRcYbu-RDGbRquL-wDbiTQdN4eaH-t4NdkXu2M6B2rOg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108753798872118967355/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108753798872118967355/reviews');
SET @user_ivana_kneevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108753798872118967355/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Matija Maksimović', 'https://lh3.googleusercontent.com/a-/ALV-UjX-IZZv0aTlj2y-GS28sSlBI2rngaNz-MDfw1rgQY07fO7rWZau=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110709747118359104966/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110709747118359104966/reviews');
SET @user_matija_maksimovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110709747118359104966/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Matija Maksimović', 'https://lh3.googleusercontent.com/a-/ALV-UjWgdmLGHSUQpCRchAgA7Wd3hMEWx59p3v_e0vyy18ciQUW1trw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105974109709562551542/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105974109709562551542/reviews');
SET @user_matija_maksimovi_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105974109709562551542/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Suzana Djuric', 'https://lh3.googleusercontent.com/a-/ALV-UjX38Dto6Moug8faS8Iq4PwjHy5ckmBH799SX3EITvU0LrMIYyW4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116651604125281896313/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116651604125281896313/reviews');
SET @user_suzana_djuric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116651604125281896313/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milovan Bubanja', 'https://lh3.googleusercontent.com/a-/ALV-UjX3RiDZxhEHxkZDtXdW-fB9M1lAHh5qC5YGz3nkD7NYMz1Rs3GX=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100522555646203921267/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100522555646203921267/reviews');
SET @user_milovan_bubanja = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100522555646203921267/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'nikola nikolic', 'https://lh3.googleusercontent.com/a-/ALV-UjXwGWa0F3CMsmkvPqHD4QwCLcZdniMpumyas8zeWnl_M5HtAYB6=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105253596188173491652/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105253596188173491652/reviews');
SET @user_nikola_nikolic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105253596188173491652/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Jovanovic Mrvosevic', 'https://lh3.googleusercontent.com/a-/ALV-UjV25aUIVGfliAq01gTY1QG-I1wjrYljbumkmekaHJYcRjcLCHHF=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112356215075485217736/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112356215075485217736/reviews');
SET @user_milica_jovanovic_mrvosevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112356215075485217736/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Hana Skoko', 'https://lh3.googleusercontent.com/a-/ALV-UjVuvEQ7wVIBTZiwKuMXkIEArblQWJVTuUV0Xi78LjmVwCITa84UTg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103067081327422205635/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103067081327422205635/reviews');
SET @user_hana_skoko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103067081327422205635/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Kojic', 'https://lh3.googleusercontent.com/a/ACg8ocLtjYn1nilJEC8LBMnluW14NVB4emaJUpeMpkDuXh5iVwO7Hw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113116174133653029567/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113116174133653029567/reviews');
SET @user_marija_kojic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113116174133653029567/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anja Raicevic', 'https://lh3.googleusercontent.com/a/ACg8ocLSVPmADiibyG4JDEU9x2kHBA57NwtERbiKMGu9ec6BB3sjHA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112198569483607307581/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112198569483607307581/reviews');
SET @user_anja_raicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112198569483607307581/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'sofija zivaljevic', 'https://lh3.googleusercontent.com/a/ACg8ocIm7fUnLGHR0y2oehGj5XxKxyMhHtuO3f-Qxrh05BhF0XSnIg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100055009229608252426/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100055009229608252426/reviews');
SET @user_sofija_zivaljevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100055009229608252426/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Srdjan Krstovic', 'https://lh3.googleusercontent.com/a/ACg8ocIb8sAm7k29vyVRG0USJ7iLf0uGUT464PPB3Q7fBCc7y-q4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102691157462751028295/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102691157462751028295/reviews');
SET @user_srdjan_krstovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102691157462751028295/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojan Brasanac', 'https://lh3.googleusercontent.com/a/ACg8ocLcHP7_MpgIeso93k56Y3xN5eQ_Y60lLyDesPq7zpe3HUk-DA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113268837030507591189/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113268837030507591189/reviews');
SET @user_bojan_brasanac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113268837030507591189/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Darko Zejnilovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXHKas8Rq_e1nV_ZsF9XTPttqEmahtRrIZBFUUjgmVMvElAGGPw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105445573877681385790/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105445573877681385790/reviews');
SET @user_darko_zejnilovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105445573877681385790/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandar Krcalovic', 'https://lh3.googleusercontent.com/a/ACg8ocJMrXInZDyQQsNBoxlaNQE1yi2wdSrH0g9YHrTnyuHAlnnlmg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113984076342430949330/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113984076342430949330/reviews');
SET @user_aleksandar_krcalovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113984076342430949330/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'alen Pepic', 'https://lh3.googleusercontent.com/a-/ALV-UjUcZTMZ-3uY4UQQwlc9-Xm5ZbIwemB3Kk0WjbXA5nf0wmopuWOyHA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116251046615658207281/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116251046615658207281/reviews');
SET @user_alen_pepic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116251046615658207281/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Boki Mne', 'https://lh3.googleusercontent.com/a/ACg8ocKVquiMkp3DCy3QTMjYdHOr5Sg_GPzweIPFjgJMUqwEz71x2g=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117453449177525312656/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117453449177525312656/reviews');
SET @user_boki_mne = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117453449177525312656/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragan Kojic', 'https://lh3.googleusercontent.com/a/ACg8ocJPyryd_bVgez50VBuFIL3tAdT7Pgjwdf0DqLG3r_39cb6Iyg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108412099395185595047/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108412099395185595047/reviews');
SET @user_dragan_kojic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108412099395185595047/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Strahinja Djurisic', 'https://lh3.googleusercontent.com/a-/ALV-UjVpz66dfEDuh6OPwyridPVCkLJ4p9z3yvT81_2i544kLeGsdfw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108446974483306097991/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108446974483306097991/reviews');
SET @user_strahinja_djurisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108446974483306097991/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aida Pepeljak', 'https://lh3.googleusercontent.com/a/ACg8ocL9DSUyOmlvPq7V1Bpau3unCBi9Zw-RBdsaumJGVCjfj92ULQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117589179685045861701/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117589179685045861701/reviews');
SET @user_aida_pepeljak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117589179685045861701/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanel Pepeljak', 'https://lh3.googleusercontent.com/a/ACg8ocKjAJBlY3k7zhWppJWLO3OqvKHsAcHnNXkEidFZR5uz1JW79Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110290551461103351378/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110290551461103351378/reviews');
SET @user_sanel_pepeljak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110290551461103351378/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojana Ćirović', 'https://lh3.googleusercontent.com/a/ACg8ocJnfhfzhHEPKtQJNCJVk5d5LXcfxr9Ml0TVlGBTWop5oge-tQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101701571457023688235/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101701571457023688235/reviews');
SET @user_bojana_irovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101701571457023688235/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'H P', 'https://lh3.googleusercontent.com/a/ACg8ocLHwry9lA2VIhFZ5Oz7r6AuPllRgLl0aIB32tiZ_Fb7itSWYg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104820959305804729908/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104820959305804729908/reviews');
SET @user_h_p = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104820959305804729908/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sandro Sandro', 'https://lh3.googleusercontent.com/a-/ALV-UjVGCqccK16V9tGdFWjZwqQkeZuI7mzX6u19keCk82PqTrZp_8LSGA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103472195824537931221/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103472195824537931221/reviews');
SET @user_sandro_sandro = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103472195824537931221/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zorana Radunovic', 'https://lh3.googleusercontent.com/a/ACg8ocKX2QrRTomxy1rx9Jf0MCArEec77p87RYLTZLRS6FtTZjHBzg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102375827288585198348/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102375827288585198348/reviews');
SET @user_zorana_radunovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102375827288585198348/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Esmeralda Kocan', 'https://lh3.googleusercontent.com/a-/ALV-UjVRR66CJwyWP1eN8z9xfI0sX7kd6Nwer93Cyq8ns_tv2du-exo=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109639306849916236798/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109639306849916236798/reviews');
SET @user_esmeralda_kocan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109639306849916236798/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branko Žižić', 'https://lh3.googleusercontent.com/a/ACg8ocJkKJh4paMbz_xMXYUmHybTfx4pOwflb1PPYd_HSTJxRuekEQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109759323351967739986/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109759323351967739986/reviews');
SET @user_branko_ii = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109759323351967739986/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'dragana Lipovina', 'https://lh3.googleusercontent.com/a/ACg8ocJq0CvZ4d9FieeBwUNAIxdBhzA3eztg6sC8MGM918dqFPC_9Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111383637395257188726/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111383637395257188726/reviews');
SET @user_dragana_lipovina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111383637395257188726/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dusan L', 'https://lh3.googleusercontent.com/a/ACg8ocLK8RszvdFgfygcqyxadJJkTVZx4PU-WQbgT7qMg_rRtTiS=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117688508191520920974/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117688508191520920974/reviews');
SET @user_dusan_l = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117688508191520920974/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Leonardo Ljucovic', 'https://lh3.googleusercontent.com/a/ACg8ocKW83qrNLVwvJ7JfK9V-Mx2yaO2zl5dlIKMrVb-T9ki5SuizA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117223049556262683912/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117223049556262683912/reviews');
SET @user_leonardo_ljucovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117223049556262683912/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'jovanka draskovic', 'https://lh3.googleusercontent.com/a/ACg8ocKBudzxWhG0RuB4VBvyqCKmHy8r2B52PTRAeP2S5PaZ6y0ysg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115520430735662053787/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115520430735662053787/reviews');
SET @user_jovanka_draskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115520430735662053787/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Miljan Jovovic', 'https://lh3.googleusercontent.com/a/ACg8ocI2doootvRMmnIJ8rKJCCpC15hYSws97HJzsbXadi8NafNQDg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111058935381076397669/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111058935381076397669/reviews');
SET @user_miljan_jovovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111058935381076397669/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anja Keržan', 'https://lh3.googleusercontent.com/a/ACg8ocI8opo8P_pAaxTJbyoYcr1zB50UeZc2WPvPWXEFKnW4243239hS=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103105035478448139900/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103105035478448139900/reviews');
SET @user_anja_keran = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103105035478448139900/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Vucinic', 'https://lh3.googleusercontent.com/a/ACg8ocKHQAqbSyIXhb0_HMSp3-bES-RbY7I8Ik3bjUlhsn-FNR4mlQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109631929458487789239/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109631929458487789239/reviews');
SET @user_nikola_vucinic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109631929458487789239/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Terglav', 'https://lh3.googleusercontent.com/a/ACg8ocIcJH20VSx63d-FVJ2aUgk6nGHZ6t24euYH3XtuJYIXhVA2CrM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110824080349845319485/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110824080349845319485/reviews');
SET @user_luka_terglav = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110824080349845319485/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, '[Dis] Ability Fitness', 'https://lh3.googleusercontent.com/a-/ALV-UjXY6b2J8JKfaw3uusKvLhg0xLbkO3x0vK0s_KSUcUCcnrwIks8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114651086419417594618/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114651086419417594618/reviews');
SET @user_dis_ability_fitness = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114651086419417594618/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelica Begovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVsutV4TvIg4KLCLaCC4Pc2rXJrN0W7bAiRoDoOsRaY653XVayd=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110028776173255167553/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110028776173255167553/reviews');
SET @user_jelica_begovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110028776173255167553/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirko Kuzman', 'https://lh3.googleusercontent.com/a-/ALV-UjVBoCv43CWUqqGBgD0RZwPDLqL3FmG83JKpFbs_j8DrIXSieFY=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100012240900091104965/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100012240900091104965/reviews');
SET @user_mirko_kuzman = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100012240900091104965/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Dedić', 'https://lh3.googleusercontent.com/a/ACg8ocIpaUCnWfcNBCkBODh3AIreJc013-Kf6tSaewnaNqF4FhWIrA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105159291409851648151/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105159291409851648151/reviews');
SET @user_luka_dedi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105159291409851648151/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Veljko Resetar', 'https://lh3.googleusercontent.com/a/ACg8ocJXU2llha1qCKlX6fp7_oSiZwVEvAmd01SosT3ncFy9-76nJg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106351604497170313289/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106351604497170313289/reviews');
SET @user_veljko_resetar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106351604497170313289/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Filip Miloš', 'https://lh3.googleusercontent.com/a/ACg8ocIhlDeiszLV3B--AfEFGhl_0-IA53DJbab2fRjJ12zcdQVSuZc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111571103890125494134/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111571103890125494134/reviews');
SET @user_filip_milo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111571103890125494134/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Banovic', 'https://lh3.googleusercontent.com/a/ACg8ocLHaLGTgAHy-9oNBqF2axMTC4Lkw8MSdl2qYzJOXsHoI6If2g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105793565968207064482/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105793565968207064482/reviews');
SET @user_jelena_banovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105793565968207064482/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Amer Sabotic', 'https://lh3.googleusercontent.com/a/ACg8ocLafk6GvRBfeVI259H1pJPQpmwSg4m3PD3OF8CoXJMEWI-AJg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113524677826633536326/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113524677826633536326/reviews');
SET @user_amer_sabotic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113524677826633536326/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sat Kula', 'https://lh3.googleusercontent.com/a/ACg8ocLH0su8scuRTdtEwBJqu_xOFfPOT__vHun_kPCgt5BzKJZCqw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117143958141699625813/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117143958141699625813/reviews');
SET @user_sat_kula = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117143958141699625813/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Amy Mne', 'https://lh3.googleusercontent.com/a-/ALV-UjX-_TXqv6hkABqfhPnUo-wl7H0r6i5YtpGXcFvp9DOWylsfXmKg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107298718704252957999/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107298718704252957999/reviews');
SET @user_amy_mne = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107298718704252957999/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'emina ramovic', 'https://lh3.googleusercontent.com/a/ACg8ocIBSweDmUOKYo9mQBy0S7OyXNWyE1YrV7CVL-BqdirhIsxieQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111169456065485139219/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111169456065485139219/reviews');
SET @user_emina_ramovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111169456065485139219/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljubo Novakovic', 'https://lh3.googleusercontent.com/a/ACg8ocJCGn4zQzKsN-oTGeY-qsdMCCGwYfgVIVed64IHQ1Hc-4299g=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112876184598790987441/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112876184598790987441/reviews');
SET @user_ljubo_novakovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112876184598790987441/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'dusanka zogovic', 'https://lh3.googleusercontent.com/a/ACg8ocJTsPzkkCFekfhQvvhdf-1dK9lP4pmx5_k3akn978gikzvmoEE=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117871997919691958512/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117871997919691958512/reviews');
SET @user_dusanka_zogovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117871997919691958512/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragan Pesic', 'https://lh3.googleusercontent.com/a-/ALV-UjXXMuHmryValO1DXnroHRq37JS2WF2kk7_0ZHwGsYnwNXgxU8Ha=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103303883480185739385/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103303883480185739385/reviews');
SET @user_dragan_pesic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103303883480185739385/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_shibox_tv, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5cFpFUnFPSGxLVlROalFVUlNNM2hsT0dkeUxVRRAB',
    5, 'sr', 'Велико задовољство ми је да напишем неколико речи о Физио тиму, јер су заиста заслужили сваку похвалу.

Физио тим је екипа изузетних професионалаца који свој посао раде са знањем, посвећеношћу и искреном бригом према сваком клијенту. Од првог контакта осети се пријатна атмосфера, љубазност и спремност да се саслуша проблем до детаља. Њихов приступ није шаблонски  сваком се приступа индивидуално, са пажњом и јасним циљем да се постигну најбољи могући резултати.

Мени су лично много помогли. Захваљујући њиховој стручности, стрпљењу и континуираном праћењу напретка, осетио/осетила сам значајно побољшање. Оно што их издваја јесте комбинација врхунског знања и људског приступа увек су спремни да објасне поступак, дају савет и пруже подршку током целог процеса опоравка.

Посебно бих истакао Срђу, који је један од бољих масера и заиста признат познавалац своје струке. Његова техника, сигурност у раду и осећај за проблем који третира уливају велико поверење. Видљиво је да иза њега стоји велико искуство и континуирано усавршавање. Уз професионалност, Срђу краси и одлична комуникација и посвећеност, што целокупно искуство чини још пријатнијим.

Физио тим је пример како треба да изгледа један стручан, организован и људски оријентисан тим. Свакоме ко тражи квалитетну физиотерапију и врхунску масажу, од срца бих их препоручио.Šibalić Andrej parasnowborder.',
    'Veliko zadovoljstvo mi je da napišem nekoliko reči o Fizio timu, jer su zaista zaslužili svaku pohvalu.

Fizio tim je ekipa izuzetnih profesionalaca koji svoj posao rade sa znanjem, posvećenošću i iskrenom brigom prema svakom klijentu. Od prvog kontakta oseti se prijatna atmosfera, ljubaznost i spremnost da se sasluša problem do detalja. Njihov pristup nije šablonski  svakom se pristupa individualno, sa pažnjom i jasnim ciljem da se postignu najbolji mogući rezultati.

Meni su lično mnogo pomogli. Zahvaljujući njihovoj stručnosti, strpljenju i kontinuiranom praćenju napretka, osetio/osetila sam značajno poboljšanje. Ono što ih izdvaja jeste kombinacija vrhunskog znanja i ljudskog pristupa uvek su spremni da objasne postupak, daju savet i pruže podršku tokom celog procesa oporavka.

Posebno bih istakao Srđu, koji je jedan od boljih masera i zaista priznat poznavalac svoje struke. Njegova tehnika, sigurnost u radu i osećaj za problem koji tretira ulivaju veliko poverenje. Vidljivo je da iza njega stoji veliko iskustvo i kontinuirano usavršavanje. Uz profesionalnost, Srđu krasi i odlična komunikacija i posvećenost, što celokupno iskustvo čini još prijatnijim.

Fizio tim je primer kako treba da izgleda jedan stručan, organizovan i ljudski orijentisan tim. Svakome ko traži kvalitetnu fizioterapiju i vrhunsku masažu, od srca bih ih preporučio.Šibalić Andrej parasnowborder.', 'Велико задовољство ми је да напишем неколико речи о Физио тиму, јер су заиста заслужили сваку похвалу.

Физио тим је екипа изузетних професионалаца који свој посао раде са знањем, посвећеношћу и искреном бригом према сваком клијенту. Од првог контакта осети се пријатна атмосфера, љубазност и спремност да се саслуша проблем до детаља. Њихов приступ није шаблонски  сваком се приступа индивидуално, са пажњом и јасним циљем да се постигну најбољи могући резултати.

Мени су лично много помогли. Захваљујући њиховој стручности, стрпљењу и континуираном праћењу напретка, осетио/осетила сам значајно побољшање. Оно што их издваја јесте комбинација врхунског знања и људског приступа увек су спремни да објасне поступак, дају савет и пруже подршку током целог процеса опоравка.

Посебно бих истакао Срђу, који је један од бољих масера и заиста признат познавалац своје струке. Његова техника, сигурност у раду и осећај за проблем који третира уливају велико поверење. Видљиво је да иза њега стоји велико искуство и континуирано усавршавање. Уз професионалност, Срђу краси и одлична комуникација и посвећеност, што целокупно искуство чини још пријатнијим.

Физио тим је пример како треба да изгледа један стручан, организован и људски оријентисан тим. Свакоме ко тражи квалитетну физиотерапију и врхунску масажу, од срца бих их препоручио.Šibalić Andrej parasnowborder.', NULL, NULL, NULL, NULL,
    0, '2026-02-26 22:18:10'),

(@user_krsto_covic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCZmNsZElhekJPVVZkclMwbzRSVFJ0TUU1TFdsRRAB',
    5, 'hr', 'Veoma pozitivno iskustvo. Profesionalan i prijatan tim, fizijatar detaljan i posvećen, sve jasno objašnjeno. Osjeća se ozbiljan i stručan pristup pacijentu. Preporuka za svakoga kome je potrebna kvalitetna fizikalna terapija. 👍',
    'Veoma pozitivno iskustvo. Profesionalan i prijatan tim, detaljan i posvećen fizioterapeut, sve je jasno objašnjeno. Oseća se ozbiljan i profesionalan pristup pacijentu. Preporučujem svima kojima je potrebna kvalitetna fizikalna terapija. 👍', 'Веома позитивно искуство. Професионалан и пријатан тим, детаљан и посвећен физиотерапеут, све је јасно објашњено. Осећа се озбиљан и професионалан приступ пацијенту. Препоручујем свима којима је потребна квалитетна физикална терапија. 👍', NULL, NULL, NULL, NULL,
    0, '2026-02-07 19:10:03'),

(@user_milica_milosevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT25Ga1RIYzRkRGxsTkRReWRreHJURk40ZWxSdGNrRRAB',
    5, 'hr', 'Sve pohvale za članove “Fiziotima”! Zaista su sjajni, stručni i odgovorni. Brinu o pacijentima i u profesionalnom i ljudskom smislu, što je danas retkost.
Puna podrška i preporuka svima koji imaju potrebe za fizikalnom terapijom.',
    'Čestitam članovima „Fiziotima“! Zaista su sjajni, profesionalni i odgovorni. Brinu o pacijentima i u profesionalnom i u ljudskom smislu, što je danas retkost.
Puna podrška i preporuka svima kojima je potrebna fizikalna terapija.', 'Честитам члановима „Физиотима“! Заиста су сјајни, професионални и одговорни. Брину о пацијентима и у професионалном и у људском смислу, што је данас реткост.
Пуна подршка и препорука свима којима је потребна физикална терапија.', NULL, NULL, NULL, NULL,
    0, '2026-02-07 20:05:41'),

(@user_ana_djurovic, @clinic_id, @doctor_srdjan_kojic, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pZNU5EZHpTa1JrVlhCSGVtTnVhRFY0UW5sMlRsRRAB',
    5, 'hr', 'Milica i Srđan su pravi profesionalci! Uvijek dočekuju stranke s osmijehom i lijepim riječima, što mi svaki dolazak čini ugodnim.  Njihova ljubaznost i posvećenost poslu su zaista za svaku pohvalu. Preporučujem ih svima!',
    'Milica i Srđan su pravi profesionalci! Uvek dočekuju svoje klijente sa osmehom i lepim rečima, što svaku posetu čini prijatnom. Njihova ljubaznost i posvećenost poslu su zaista za svaku pohvalu. Preporučujem ih svima!', 'Милица и Срђан су прави професионалци! Увек дочекују своје клијенте са осмехом и лепим речима, што сваку посету чини пријатном. Њихова љубазност и посвећеност послу су заиста за сваку похвалу. Препоручујем их свима!', NULL, NULL, NULL, NULL,
    0, '2026-02-06 09:51:39'),

(@user_luka_ilincic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwbFoyRTBaVTB0VmxZM1FUaEVjVzVuU0VvNE9WRRAB',
    5, 'bs', 'Tvrdim da je ovo najbolja ekipa u Crnoj Gori – posvećeni su, odgovorni i u svakom trenutku daju maksimum kako bi pacijenti bili zadovoljni. Posebno bih izdvojio energiju koja je konstantno na visokom nivou, pa boravak kod njih, uprkos bolu zbog povreda, predstavlja pravo zadovoljstvo. Svakome bih preporučio da im se obrati već pri najmanjoj nelagodnosti.',
    'Tvrdim da je ovo najbolja ekipa u Crnoj Gori – posvećeni su, odgovorni i u svakom trenutku daju maksimum kako bi pacijenti bili zadovoljni. Posebno bih izdvojio energiju koja je konstantno na visokom nivou, pa boravak kod njih, uprkos bolu zbog povreda, predstavlja pravo zadovoljstvo. Svakome bih preporučio da im se obrati već pri najmanjoj nelagodnosti.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-28 07:57:03'),

(@user_ivana_kneevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21ocVlUWnFOMjlZWkRKWGJWTkliRFpaY21jM1pHYxAB',
    5, 'bs', 'Prvi utisak već na samom ulazu je izuzetno pozitivan — prostor je besprekorno čist, moderan i ugodan, a atmosfera mirna i opuštajuća. Čitav tim i osoblje na recepciji su neopisivo ljubazni, nasmejani i profesionalni, tako da se od prvog momenta osećate dobrodošlo i u sigurnim rukama.',
    'Prvi utisak već na samom ulazu je izuzetno pozitivan — prostor je besprekorno čist, moderan i ugodan, a atmosfera mirna i opuštajuća. Čitav tim i osoblje na recepciji su neopisivo ljubazni, nasmejani i profesionalni, tako da se od prvog momenta osećate dobrodošlo i u sigurnim rukama.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-22 00:00:00'),

(@user_matija_maksimovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSblUwTnRNV3RpT0RWclkwTndkRmwyUVRKWGNIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-22 00:00:00'),

(@user_matija_maksimovi_2, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psbFVEWlhPVTFtV25aaVJrcG5Nbmt0VW5Bd2JFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-22 00:00:00'),

(@user_suzana_djuric, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21wZmMwdFZUbVV6VTBoRFZVNTJOa2RGYlVadlRtYxAB',
    5, 'hr', 'Sve pohvale za Fizio Tim centar! Ono što mi je najvažnije jeste da je bol, zbog kojeg sam došla, prošao zahvaljujući njihovom radu i stručnosti. Cijeli tim čini da se osjećate sigurno i da ste u pravim rukama. Od srca ih preporučujem svima kojima je potrebna kvalitetna fizioterapija.',
    'Sve pohvale za Fizio Tim centar! Ono što mi je najvažnije jeste da je bol, zbog kojeg sam došla, prošao zahvaljujući njihovom radu i stručnosti. Cijeli tim čini da se osjećate sigurno i da ste u pravim rukama. Od srca ih preporučujem svima kojima je potrebna kvalitetna fizioterapija.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-22 00:00:00'),

(@user_milovan_bubanja, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT25sVmRVUXRjMHhhVEhKNk5WaDJTV1l3Y3poNk9XYxAB',
    5, 'sr', 'Похвале, препоруке.. све 5!🙌',
    'Pohvale, preporuke.. sve 5!🙌 …', 'Похвале, препоруке.. све 5!🙌 …', NULL, NULL, NULL, NULL,
    0, '2026-10-15 00:00:00'),

(@user_nikola_nikolic, @clinic_id, @doctor_srdjan_kojic, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGUmFUaEtiRmREZEhkWlJrWk9NMlJKZGxwbGRuYxAB',
    5, 'hr', 'Sve pohvale za Srdjana i cijeli tim...Rezultati su nakon prvog tretmana bili vidljivi!',
    'Sve pohvale za Srdjana i cijeli tim...Rezultati su nakon prvog tretmana bili vidljivi!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-15 00:00:00'),

(@user_milica_jovanovic_mrvosevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT25JMVkxVlBTMEZzWTJOVWNrdDNORXhOYVZGeFdFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_hana_skoko, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT205dFJ6TkJOMFJPTm1zMlJWQk9kVTE0T1hGaFptYxAB',
    5, 'bs', 'Sve pohvale za Fizio tim! Ljubaznost, profesionalnost, stručnost i posvećenost na nivou. Velika preporuka.',
    'Sve pohvale za Fizio tim! Ljubaznost, profesionalnost, stručnost i posvećenost na nivou. Velika preporuka.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_marija_kojic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xNMlFqVXRkVTk2Y0ZjeGVXSXplbEZqUjE5ME0xRRAB',
    5, 'hr', 'Odlično iskustvo u ordinaciji Fizio Tim. Profesionalan pristup i prijatna atmosfera. Posebna pohvala za Anicu – divna, pažljiva i izuzetno stručna. Preporučujem od srca!',
    'Odlično iskustvo u ordinaciji Fizio Tim. Profesionalan pristup i prijatna atmosfera. Posebna pohvala za Anicu – divna, pažljiva i izuzetno stručna. Preporučujem od srca!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_anja_raicevic, @clinic_id, @doctor_srdjan_kojic, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT25OaVVtbHRRM2hKTTE5aU9VUXlURzVmTVVsNGMyYxAB',
    5, 'bs', 'Imam izuzetno pozitivno iskustvo sa celim timom. Srdjan je vec na prvom pregledu veoma precizno procenio moj problem i odredio mi terapiju koja je vrlo brzo pocela da daje rezultate. Devojke koje su mi radile tretmane su divne, pazljive i strucne. Pored samih terapija, dobila sam i mnogo korisnih saveta vezano za treninge, vezbe i svakodnevne aktivnosti, kako bih izbegla da ponovo napravim isti problem. Preporuka od srca💖',
    'Imam izuzetno pozitivno iskustvo sa celim timom. Srdjan je vec na prvom pregledu veoma precizno procenio moj problem i odredio mi terapiju koja je vrlo brzo pocela da daje rezultate. Devojke koje su mi radile tretmane su divne, pazljive i strucne. Pored samih terapija, dobila sam i mnogo korisnih saveta vezano za treninge, vezbe i svakodnevne aktivnosti, kako bih izbegla da ponovo napravim isti problem. Preporuka od srca💖', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_sofija_zivaljevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tSdk5qSnJUazVGVGpGSFFuaFlPSGhFYjJsd1pVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_srdjan_krstovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psSFdUTnJVWGMyYVdWQ1RVcDVWalJvVmw4eU5GRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_bojan_brasanac, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT205NVEzSlNkalpuWlRkSVRFWlhlSGhKWjNaaGJGRRAB',
    5, 'bs', 'Vrhunski tretman, atmosfera takođe. Milica top, vlada iz sjenke😀',
    'Vrhunski tretman, atmosfera takođe. Milica top, vlada iz sjenke😀', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_darko_zejnilovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tkd1ltc3pZVkl5UW5OVFZrZEtWREJxTmw5YVQzYxAB',
    5, 'hr', 'Najbolji, najljubazniji i najstrucniji! Svaka cast za kolektiv! 💪',
    'Najbolji, najljubazniji i najstrucniji! Svaka cast za kolektiv! 💪', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_aleksandar_krcalovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT205SlRrVXpORzVGWkMxR2RFMWxlbnBFU2t4NlJVRRAB',
    5, 'bs', 'Odlicna ekipa, profesionalnan tretman',
    'Odlicna ekipa, profesionalnan tretman', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_alen_pepic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT25oc09HZEZiemx1VFZRd2FFaHhZV1JSTTJOdlQwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_boki_mne, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21Sa1dVSlNkVEF3VkdoWU5FOXZOMUZpVDBSZmIzYxAB',
    5, 'hr', 'Profesionalci',
    'Profesionalci', NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_dragan_kojic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSQ1VVWnBabk5FTFRGM1N6QnpTV0kxWTBOM1RXYxAB',
    5, 'bs', 'Odlično iskustvo sa ovom ustanovom. Profesionalni i posvećeni, uz savremenu opremu. Preporučujem. Hvala svima.',
    'Odlično iskustvo sa ovom ustanovom. Profesionalni i posvećeni, uz savremenu opremu. Preporučujem. Hvala svima.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_strahinja_djurisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2poSFpTMXNiVlY1YlVOZlFqUmpjRXhIZERWUE9VRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_aida_pepeljak, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5a1JIWmZRMUJqYjNKdFRscG5jVnBUY1dGamIwRRAB',
    5, 'hr', 'Sve pohvale za tim i cjelokupnu uslugu.',
    'Sve pohvale za tim i cjelokupnu uslugu.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-29 00:00:00'),

(@user_sanel_pepeljak, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT205WFVVMHpVM3BTTTNoSFMyeExOa3BJV0hCM2NXYxAB',
    5, 'hr', 'Profesionalna ekipa sa visegodisnjim iskustvom
Sve preporuke',
    'Profesionalna ekipa sa visegodisnjim iskustvom
Sve preporuke', NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-29 00:00:00'),

(@user_bojana_irovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSd1RtOUZaUzF6Uld0NVlXRmxSRWxYY1ZOVGVuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-29 00:00:00'),

(@user_h_p, @clinic_id, @doctor_srdjan_kojic, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pOSlgzWjZZM0Z2U0hGV2RXUnhRMVp4YlZsNlRGRRAB',
    5, 'bs', 'Srđan i Milica su predivan tim, vrlo profesionalni, pažljivi i posvećeni. Topla preporuka svima kojima je potrebna kvalitetna fizikalna podrška!',
    'Srđan i Milica su predivan tim, vrlo profesionalni, pažljivi i posvećeni. Topla preporuka svima kojima je potrebna kvalitetna fizikalna podrška!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_sandro_sandro, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT201WFQwSlViMHRsVFRCak1tUkxVREJPYVMxVGVIYxAB',
    5, 'en', 'The best fizio in podgorica',
    NULL, NULL, 'The best fizio in podgorica', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_zorana_radunovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WeU0wSnlSMjlFTUhKdFExSm1kRVJvYzFBdGVWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_esmeralda_kocan, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT214U1gwdGxVeTE0UzFOMFRuVjRXRkJMYVVwM1FYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_branko_ii, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2toM1EzQnpNVzl1Ym1aeVFuQldia1JLVjJKZmVrRRAB',
    5, 'en', 'The Best service. I recommend!',
    NULL, NULL, 'The Best service. I recommend!', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dragana_lipovina, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GcllWcDZUbEZyWjJWQmVuTjJXbTU1T1RKTFkxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dusan_l, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkM1N5MU1jRTVyUld3M1VVWlRNRTVxZEdGclIwRRAB',
    5, 'hr', 'Sve pohvale i preporuke za Fizio Tim👌',
    'Sve pohvale i preporuke za Fizio Tim👌', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_leonardo_ljucovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21keE4wcEZjVUZZUTFCeVRGOVBOVU5qYUdaVVoyYxAB',
    5, 'hr', 'Odlično iskustvo, nakon teške povrede. Sve pohvale za osoblje, naročito za Ogija i Jasmina.',
    'Odlično iskustvo, nakon teške povrede. Sve pohvale za osoblje, naročito za Ogija i Jasmina.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jovanka_draskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xWZlEwaHBXRWx4TVRNMFV6RldTVFZhYnpGYU5FRRAB',
    5, 'hr', 'Sve pohvale za fizio tim.',
    'Sve pohvale za fizio tim.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_miljan_jovovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoelRXaHVSRkp1ZUc1emQwOWpkRzFLVFZCV1ptYxAB',
    5, 'bs', 'Sve pohvale za tim fizio tim. Svi su izuzetno profesionalni, ljubazni, saslusaju pacijenta i daju korisne savjete. Instrumenti sa kojima rade su savremeni. Meni su pomogli sa rehabilitacijom povrede koljena. Nakon tretmana ocigledan je napredak.',
    'Sve pohvale za tim fizio tim. Svi su izuzetno profesionalni, ljubazni, saslusaju pacijenta i daju korisne savjete. Instrumenti sa kojima rade su savremeni. Meni su pomogli sa rehabilitacijom povrede koljena. Nakon tretmana ocigledan je napredak.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_anja_keran, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21KcldrOUxaVEp6ZFhOMGJIaDZWbUZSUjJsc1RXYxAB',
    5, 'en', 'Professional staff and great service. They have a lot of advanced physiotherapeutic devices and provide great and effective treatments. I highly recommend.',
    NULL, NULL, 'Professional staff and great service. They have a lot of advanced physiotherapeutic devices and provide great and effective treatments. I highly recommend.', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_nikola_vucinic, @clinic_id, @doctor_srdjan_kojic, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twSFFtSnFSbXgxUlV4cVQzQTJiWFZMTTA1d1drRRAB',
    5, 'bs', 'Sve pohvale za Fizio tim. Pravi profesionalci,  na celu sa najboljim fizioterapeutom Srdjom Kojicem.',
    'Sve pohvale za Fizio tim. Pravi profesionalci,  na celu sa najboljim fizioterapeutom Srdjom Kojicem.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_luka_terglav, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GVVUxWTJRbmt4VGpOT01YVlpSVlE1T1ZGdmVtYxAB',
    5, 'en', 'Great results after therapy, professional service.',
    NULL, NULL, 'Great results after therapy, professional service.', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dis_ability_fitness, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21SNWQzVnVMWEo2UlZGVlRUVmFSRzF1WWtkR1ZtYxAB',
    5, 'hr', 'Odličan rad stručnog osoblja, nemam riječi. Sve preporuke, momci su tu da vam pomognu i da vas oslobode bilo kakve fizičke tegobe imali.
Još jednom sve preporuke',
    'Odličan rad stručnog osoblja, nemam riječi. Sve preporuke, momci su tu da vam pomognu i da vas oslobode bilo kakve fizičke tegobe imali.
Još jednom sve preporuke', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jelica_begovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psV1dVcERVMFptWVc1TlluVmhZbW8yV1U1RFJuYxAB',
    5, 'hr', 'Predivno iskustvo. Ljubazno osoblje. Zaposlena Anica, izuzetno profesionalna, pažljiva. Sve pohvale.',
    'Predivno iskustvo. Ljubazno osoblje. Zaposlena Anica, izuzetno profesionalna, pažljiva. Sve pohvale.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_mirko_kuzman, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21sdmEwZzRSalZRWWpWME9ITlJjM05CZEZabWQwRRAB',
    5, 'hr', 'Prezadovoljan sam uslugom. Problem sa tetivom riješen u optimalnom roku.',
    'Prezadovoljan sam uslugom. Problem sa tetivom riješen u optimalnom roku.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_luka_dedi, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pjelZVMWthMmRoUkVkaGRtWmxVbkZmZEV4dk0wRRAB',
    5, 'en', 'Great service and very pleasent people!',
    NULL, NULL, 'Great service and very pleasent people!', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_veljko_resetar, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21ZNWExQnFWRFUwZVhGc1pteERZa04wUjJKbVNsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_filip_milo, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GR2NtMVRlV3h1TjFkMVQwY3hjVVl6ZDNSSk9XYxAB',
    5, 'hr', 'Stručno osoblje, odlična opremljenost i najbolji odnos prema klijentima. Sve preporuke!',
    'Stručno osoblje, odlična opremljenost i najbolji odnos prema klijentima. Sve preporuke!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jelena_banovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tsQlNGODVPVmR0Y1ZWU1JGUnVZMFZGYUZCdmNuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_amer_sabotic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT25vNFkybDRaR1ZDVjBwSWQzVkpTRzF4VjNBME0yYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_sat_kula, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2poU1NraHZVME5wYlhVMllWcHlZblIxV25Sd1FYYxAB',
    5, 'hr', 'Odlično iskustvo. Povreda skočnog zgloba mi je riješena u optimalnom roku. Savjesni i odgovorni. Hvala.',
    'Odlično iskustvo. Povreda skočnog zgloba mi je riješena u optimalnom roku. Savjesni i odgovorni. Hvala.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_amy_mne, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoRlRIUkJUMWh6U0hsNU1rNTFia2h2VGxOemFsRRAB',
    1, 'en', 'I don\'t recommend this place.  Not professional doctor.',
    NULL, NULL, 'I don\'t recommend this place.  Not professional doctor.', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_emina_ramovic, @clinic_id, @doctor_alen_pepic, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/ChdDSUhNMG9nS0VQT2dnSUt6N083SXNBRRAB',
    5, 'hr', 'Najbolji fizioterapeut u Crnoj Gori, Alen Pepic. Nakon visemjescnih tretmana u Americi napredak sam vidjela tek posle Alenovog tretmana.',
    'Najbolji fizioterapeut u Crnoj Gori, Alen Pepic. Nakon visemjescnih tretmana u Americi napredak sam vidjela tek posle Alenovog tretmana.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ljubo_novakovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/ChZDSUhNMG9nS0VJQ0FnSUQzNTdLREdBEAE',
    5, 'hr', 'Profesionalci…',
    'Profesionalci…', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dusanka_zogovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/ChZDSUhNMG9nS0VJQ0FnSUNIZ0lYWUJBEAE',
    5, 'hr', 'Uvijek na visini zadatka👍',
    'Uvijek na visini zadatka👍', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_dragan_pesic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/ChdDSUhNMG9nS0VJQ0FnSUNicl8yQXV3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5cFpFUnFPSGxLVlROalFVUlNNM2hsT0dkeUxVRRAB'),
  'clinic', @clinic_id,
  'Hvala puno Andrej. Puno sreće i zdravlja na Olimpijskim igrama.', 'hr',
  'Hvala puno Andrej. Puno sreće i zdravlja na Olimpijskim igrama.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-03-01 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCZmNsZElhekJPVVZkclMwbzRSVFJ0TUU1TFdsRRAB'),
  'clinic', @clinic_id,
  'Hvala Vam puno Krsto.', 'hr',
  'Hvala Vam puno Krsto.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-03-01 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT25Ga1RIYzRkRGxsTkRReWRreHJURk40ZWxSdGNrRRAB'),
  'clinic', @clinic_id,
  'Hvala Vam puno Milice.', 'hr',
  'Hvala Vam puno Milice.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-03-01 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pZNU5EZHpTa1JrVlhCSGVtTnVhRFY0UW5sMlRsRRAB'),
  'clinic', @clinic_id,
  'Hvala Vam puno Ana.', 'hr',
  'Hvala Vam puno Ana.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-03-01 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwbFoyRTBaVTB0VmxZM1FUaEVjVzVuU0VvNE9WRRAB'),
  'clinic', @clinic_id,
  'Hvala Vam puno.', 'hr',
  'Hvala Vam puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-12-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21ocVlUWnFOMjlZWkRKWGJWTkliRFpaY21jM1pHYxAB'),
  'clinic', @clinic_id,
  'Hvala puno Ivana.', 'hr',
  'Hvala puno Ivana.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-10-22 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSblUwTnRNV3RpT0RWclkwTndkRmwyUVRKWGNIYxAB'),
  'clinic', @clinic_id,
  'Hvala puno g. Maksimović', 'hr',
  'Hvala puno g. Maksimović', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-10-22 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psbFVEWlhPVTFtV25aaVJrcG5Nbmt0VW5Bd2JFRRAB'),
  'clinic', @clinic_id,
  'Hvala puno Matija.', 'hr',
  'Hvala puno Matija.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-10-22 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21wZmMwdFZUbVV6VTBoRFZVNTJOa2RGYlVadlRtYxAB'),
  'clinic', @clinic_id,
  'Hvala Vam puno.', 'hr',
  'Hvala Vam puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-10-22 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT25sVmRVUXRjMHhhVEhKNk5WaDJTV1l3Y3poNk9XYxAB'),
  'clinic', @clinic_id,
  'Hvala puno Milovane😊', 'hr',
  'Hvala puno Milovane😊', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGUmFUaEtiRmREZEhkWlJrWk9NMlJKZGxwbGRuYxAB'),
  'clinic', @clinic_id,
  'Hvala Vam puno Nikola.', 'hr',
  'Hvala Vam puno Nikola.', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT25JMVkxVlBTMEZzWTJOVWNrdDNORXhOYVZGeFdFRRAB'),
  'clinic', @clinic_id,
  'Hvala puno.', 'hr',
  'Hvala puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-08-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT205dFJ6TkJOMFJPTm1zMlJWQk9kVTE0T1hGaFptYxAB'),
  'clinic', @clinic_id,
  'Hvala Vam puno.', 'hr',
  'Hvala Vam puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-07-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xNMlFqVXRkVTk2Y0ZjeGVXSXplbEZqUjE5ME0xRRAB'),
  'clinic', @clinic_id,
  'Hvala Vam puno.', 'hr',
  'Hvala Vam puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-06-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT25OaVVtbHRRM2hKTTE5aU9VUXlURzVmTVVsNGMyYxAB'),
  'clinic', @clinic_id,
  'Hvala puno Anja. Drago nam je da ste zadovoljni.', 'hr',
  'Hvala puno Anja. Drago nam je da ste zadovoljni.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-06-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tSdk5qSnJUazVGVGpGSFFuaFlPSGhFYjJsd1pVRRAB'),
  'clinic', @clinic_id,
  'Hvala puno!', 'hr',
  'Hvala puno!', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-05-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psSFdUTnJVWGMyYVdWQ1RVcDVWalJvVmw4eU5GRRAB'),
  'clinic', @clinic_id,
  'Hvala puno.', 'hr',
  'Hvala puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-05-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT205NVEzSlNkalpuWlRkSVRFWlhlSGhKWjNaaGJGRRAB'),
  'clinic', @clinic_id,
  'Hvala puno.', 'hr',
  'Hvala puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-05-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tkd1ltc3pZVkl5UW5OVFZrZEtWREJxTmw5YVQzYxAB'),
  'clinic', @clinic_id,
  'Hvala puno.', 'hr',
  'Hvala puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-03-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT205SlRrVXpORzVGWkMxR2RFMWxlbnBFU2t4NlJVRRAB'),
  'clinic', @clinic_id,
  'Hvala puno.', 'hr',
  'Hvala puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-03-01 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT25oc09HZEZiemx1VFZRd2FFaHhZV1JSTTJOdlQwRRAB'),
  'clinic', @clinic_id,
  'Hvala puno.', 'hr',
  'Hvala puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-03-01 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21Sa1dVSlNkVEF3VkdoWU5FOXZOMUZpVDBSZmIzYxAB'),
  'clinic', @clinic_id,
  'Hvala puno.', 'hr',
  'Hvala puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-01-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSQ1VVWnBabk5FTFRGM1N6QnpTV0kxWTBOM1RXYxAB'),
  'clinic', @clinic_id,
  'Hvala Vam puno.', 'hr',
  'Hvala Vam puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-01-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2poSFpTMXNiVlY1YlVOZlFqUmpjRXhIZERWUE9VRRAB'),
  'clinic', @clinic_id,
  'Hvala puno.', 'hr',
  'Hvala puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-01-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5a1JIWmZRMUJqYjNKdFRscG5jVnBUY1dGamIwRRAB'),
  'clinic', @clinic_id,
  'Hvala Vam puno.', 'hr',
  'Hvala Vam puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-12-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT205WFVVMHpVM3BTTTNoSFMyeExOa3BJV0hCM2NXYxAB'),
  'clinic', @clinic_id,
  'Hvala Vam puno.', 'hr',
  'Hvala Vam puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-12-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSd1RtOUZaUzF6Uld0NVlXRmxSRWxYY1ZOVGVuYxAB'),
  'clinic', @clinic_id,
  'Hvala Vam puno.', 'hr',
  'Hvala Vam puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-12-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pOSlgzWjZZM0Z2U0hGV2RXUnhRMVp4YlZsNlRGRRAB'),
  'clinic', @clinic_id,
  'Hvala Vam puno.', 'hr',
  'Hvala Vam puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-11-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT201WFQwSlViMHRsVFRCak1tUkxVREJPYVMxVGVIYxAB'),
  'clinic', @clinic_id,
  'Thank you very much.', 'en',
  NULL, NULL, 'Thank you very much.', NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WeU0wSnlSMjlFTUhKdFExSm1kRVJvYzFBdGVWRRAB'),
  'clinic', @clinic_id,
  'Hvala puno.', 'hr',
  'Hvala puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT214U1gwdGxVeTE0UzFOMFRuVjRXRkJMYVVwM1FYYxAB'),
  'clinic', @clinic_id,
  'Thank you very much.', 'en',
  NULL, NULL, 'Thank you very much.', NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2toM1EzQnpNVzl1Ym1aeVFuQldia1JLVjJKZmVrRRAB'),
  'clinic', @clinic_id,
  'Thank you Branko. All the best.', 'en',
  NULL, NULL, 'Thank you Branko. All the best.', NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GcllWcDZUbEZyWjJWQmVuTjJXbTU1T1RKTFkxRRAB'),
  'clinic', @clinic_id,
  'Hvala Vam puno.', 'hr',
  'Hvala Vam puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkM1N5MU1jRTVyUld3M1VVWlRNRTVxZEdGclIwRRAB'),
  'clinic', @clinic_id,
  'Hvala puno Dušane.', 'hr',
  'Hvala puno Dušane.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21keE4wcEZjVUZZUTFCeVRGOVBOVU5qYUdaVVoyYxAB'),
  'clinic', @clinic_id,
  'Hvala puno komšo', 'hr',
  'Hvala puno komšo', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xWZlEwaHBXRWx4TVRNMFV6RldTVFZhYnpGYU5FRRAB'),
  'clinic', @clinic_id,
  'Hvala Vam puno.', 'hr',
  'Hvala Vam puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoelRXaHVSRkp1ZUc1emQwOWpkRzFLVFZCV1ptYxAB'),
  'clinic', @clinic_id,
  'Hvala puno. Svako dobro.', 'hr',
  'Hvala puno. Svako dobro.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21KcldrOUxaVEp6ZFhOMGJIaDZWbUZSUjJsc1RXYxAB'),
  'clinic', @clinic_id,
  'Thank you very much😊', 'en',
  NULL, NULL, 'Thank you very much😊', NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twSFFtSnFSbXgxUlV4cVQzQTJiWFZMTTA1d1drRRAB'),
  'clinic', @clinic_id,
  'Hvala Vam puno Nikola.', 'hr',
  'Hvala Vam puno Nikola.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GVVUxWTJRbmt4VGpOT01YVlpSVlE1T1ZGdmVtYxAB'),
  'clinic', @clinic_id,
  'Thank you very much😊', 'en',
  NULL, NULL, 'Thank you very much😊', NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21SNWQzVnVMWEo2UlZGVlRUVmFSRzF1WWtkR1ZtYxAB'),
  'clinic', @clinic_id,
  'Hvala puno. Svako dobro.', 'hr',
  'Hvala puno. Svako dobro.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psV1dVcERVMFptWVc1TlluVmhZbW8yV1U1RFJuYxAB'),
  'clinic', @clinic_id,
  'Hvala Vam puno. Svako dobro.', 'hr',
  'Hvala Vam puno. Svako dobro.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21sdmEwZzRSalZRWWpWME9ITlJjM05CZEZabWQwRRAB'),
  'clinic', @clinic_id,
  'Hvala puno. Svako dobro.', 'hr',
  'Hvala puno. Svako dobro.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pjelZVMWthMmRoUkVkaGRtWmxVbkZmZEV4dk0wRRAB'),
  'clinic', @clinic_id,
  'Hvala puno Luka. Svako dobro.', 'hr',
  'Hvala puno Luka. Svako dobro.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21ZNWExQnFWRFUwZVhGc1pteERZa04wUjJKbVNsRRAB'),
  'clinic', @clinic_id,
  'Thank you.', 'en',
  NULL, NULL, 'Thank you.', NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GR2NtMVRlV3h1TjFkMVQwY3hjVVl6ZDNSSk9XYxAB'),
  'clinic', @clinic_id,
  'Hvala puno Filipe. Svako dobro.', 'hr',
  'Hvala puno Filipe. Svako dobro.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tsQlNGODVPVmR0Y1ZWU1JGUnVZMFZGYUZCdmNuYxAB'),
  'clinic', @clinic_id,
  'Hvala puno Jelena.', 'hr',
  'Hvala puno Jelena.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT25vNFkybDRaR1ZDVjBwSWQzVkpTRzF4VjNBME0yYxAB'),
  'clinic', @clinic_id,
  'Hvala puno.', 'hr',
  'Hvala puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2poU1NraHZVME5wYlhVMllWcHlZblIxV25Sd1FYYxAB'),
  'clinic', @clinic_id,
  'Thank you very much.', 'en',
  NULL, NULL, 'Thank you very much.', NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoRlRIUkJUMWh6U0hsNU1rNTFia2h2VGxOemFsRRAB'),
  'clinic', @clinic_id,
  'Pozdrav za Vas. Možete li se predstaviti i šta Vam nije odgovaralo, da popravimo?! Hvala puno.', 'hr',
  'Pozdrav za Vas. Možete li se predstaviti i šta Vam nije odgovaralo, da popravimo?! Hvala puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/ChdDSUhNMG9nS0VQT2dnSUt6N083SXNBRRAB'),
  'clinic', @clinic_id,
  'Hvala Vam puno.', 'hr',
  'Hvala Vam puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/ChZDSUhNMG9nS0VJQ0FnSUQzNTdLREdBEAE'),
  'clinic', @clinic_id,
  'Hvala Vam puno!', 'hr',
  'Hvala Vam puno!', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/ChZDSUhNMG9nS0VJQ0FnSUNIZ0lYWUJBEAE'),
  'clinic', @clinic_id,
  'Hvala puno.', 'hr',
  'Hvala puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJhRgbph3rTRMR6FfMAsrhluk/reviews/ChdDSUhNMG9nS0VJQ0FnSUNicl8yQXV3RRAB'),
  'clinic', @clinic_id,
  'Hvala puno!', 'hr',
  'Hvala puno!', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2024-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
