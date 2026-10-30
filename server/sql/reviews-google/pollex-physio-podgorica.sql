-- Insert Google Maps reviews for PZU POLLEX PHYSIO
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/pollex-physio-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'pollex-physio-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'SOFIA JIOUAK', 'https://lh3.googleusercontent.com/a/ACg8ocKEsWyLxxI2LySOgv71O4YVxQ2TQfo3aI4IeMS1f8D_XHx-fW4=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/109896261044462287877/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109896261044462287877/reviews');
SET @user_sofia_jiouak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109896261044462287877/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'A B', 'https://lh3.googleusercontent.com/a/ACg8ocJFhBQ0G3lNE7ezGUHKBOgY8Qu9c06CW3M-bR099lgQvSYzag=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/105026101099755818649/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105026101099755818649/reviews');
SET @user_a_b = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105026101099755818649/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dana Koehler', 'https://lh3.googleusercontent.com/a/ACg8ocIir4xe0ju4iuW_jralU_sR8wi0apM8XqrRVqsXc5HdvRnGHg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/113338383533903297262/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113338383533903297262/reviews');
SET @user_dana_koehler = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113338383533903297262/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'JONA BVBA', 'https://lh3.googleusercontent.com/a/ACg8ocIwf4uiQOG0svkHaiCzd2erSosdhGBSUyx0m5nh20JDSI1LIpc=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/101229952374482638441/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101229952374482638441/reviews');
SET @user_jona_bvba = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101229952374482638441/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ranka Bogicevic', 'https://lh3.googleusercontent.com/a/ACg8ocLY06q5V3l0IZQxUwOd2blWuchcFT7pr6Zxq-MNWgqxiyOLWYw=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/102067102554132210385/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102067102554132210385/reviews');
SET @user_ranka_bogicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102067102554132210385/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladan Pupovic', 'https://lh3.googleusercontent.com/a/ACg8ocJNkx2DlQ6-Ft9E6E3LuAS_UldH3J3QbDdyIxmR9TGS9q0Byw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116152990671348882383/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116152990671348882383/reviews');
SET @user_vladan_pupovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116152990671348882383/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pavle Tosic', 'https://lh3.googleusercontent.com/a-/ALV-UjXJEBFVukVO-N3nzAVQNJjYspWD2GRuof3wwIvBLg6Iz5ujB48=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100603029615055495519/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100603029615055495519/reviews');
SET @user_pavle_tosic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100603029615055495519/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ann', 'https://lh3.googleusercontent.com/a/ACg8ocIHmMNOihHlnoMLiadN5q5BXE1rP1uurf93yfNpPdfUiwRaWw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108954571472412523012/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108954571472412523012/reviews');
SET @user_ann = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108954571472412523012/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Gobovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWu_bK-7OgzpwHA1NkBX6hlgujQurOExKN3wAfc5X0kuLq5PKQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100124938164304005866/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100124938164304005866/reviews');
SET @user_luka_gobovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100124938164304005866/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Popovic', 'https://lh3.googleusercontent.com/a-/ALV-UjU9uSLcFWt6xsxbzvgapKWHHFDnczVFsNrb3PaEUkvlTPz02DQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102563902149253035018/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102563902149253035018/reviews');
SET @user_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102563902149253035018/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radulovic Radulovic', 'https://lh3.googleusercontent.com/a/ACg8ocKh30dFpjsWnwQmzXdzeq6rsbBZGIpvefopByekYqwKq5ux-g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106809381523280963434/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106809381523280963434/reviews');
SET @user_radulovic_radulovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106809381523280963434/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Ceklic', 'https://lh3.googleusercontent.com/a-/ALV-UjXoLRBw5VK_q2oAZHG40rxwQHc6wqVkY3pPy-3ua2G4pKKPK9Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101770190006795787621/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101770190006795787621/reviews');
SET @user_jovana_ceklic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101770190006795787621/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirko Kekovic', 'https://lh3.googleusercontent.com/a/ACg8ocKsF4SXkqFHVLEBoDnC8UwQinaI8eT4dlvsdSrF7mi9-2Y1jA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115758320290947077065/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115758320290947077065/reviews');
SET @user_mirko_kekovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115758320290947077065/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branko Lalicic', 'https://lh3.googleusercontent.com/a-/ALV-UjUenBZcvGVIqifWswjN8I54kP1I2m_jYRpMi0PQhdW9Ur57VCMv=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113282813332857202215/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113282813332857202215/reviews');
SET @user_branko_lalicic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113282813332857202215/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'モト', 'https://lh3.googleusercontent.com/a/ACg8ocIaIVUS8aKg3WC0A1Nx4LkPkQdRYlxMPh0ZHiFfAckwR4DNcQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114902408659527603618/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114902408659527603618/reviews');
SET @user_user_114902408659527603618 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114902408659527603618/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ALEX YANG', 'https://lh3.googleusercontent.com/a/ACg8ocIS1XaCVum_5gDShZef7U-ApyRX7gCiYFWg7kMPzvytVXNBlA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115230107832421814102/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115230107832421814102/reviews');
SET @user_alex_yang = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115230107832421814102/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Лина Чернова', 'https://lh3.googleusercontent.com/a/ACg8ocJcFh92rSHJlZP65xGoz2F_tTLMq4jRlgZmCQqCijNBePtL1Q=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107140108043345424090/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107140108043345424090/reviews');
SET @user_lina_chernova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107140108043345424090/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Reglaza trapa Ivanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUNDa68DybSae6DJMWcQ7toeSDl_XLScjXSEh0QrDTJd1ZLwZ8=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105329914152382191040/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105329914152382191040/reviews');
SET @user_reglaza_trapa_ivanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105329914152382191040/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zhongshi Cong', 'https://lh3.googleusercontent.com/a/ACg8ocL0XBy2geXUm5WuP2Y9QU8_nUt04e2fA9dubKt72-iyf3w48A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105251585338486583067/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105251585338486583067/reviews');
SET @user_zhongshi_cong = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105251585338486583067/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'velimir djurdjic', 'https://lh3.googleusercontent.com/a/ACg8ocIN_9brhajSjJ5Dz00-lQo3Pe18d4OtHrV5l2f-DX6dYiIQzg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110246638998695948158/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110246638998695948158/reviews');
SET @user_velimir_djurdjic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110246638998695948158/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dejan Socanin', 'https://lh3.googleusercontent.com/a/ACg8ocJOFKgSC56MO3fFAXF5XQwA5K06GNW_GliNJ9DR8cGRq-OFzg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108176662557598958943/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108176662557598958943/reviews');
SET @user_dejan_socanin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108176662557598958943/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Akif OKTAR', 'https://lh3.googleusercontent.com/a-/ALV-UjXyV7i1UsmCjmpA2Gfc-gd3hl2vpLkIrz_JtQ2qFxYYfhpibhb6=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102739372782512814410/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102739372782512814410/reviews');
SET @user_akif_oktar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102739372782512814410/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'MONICA BIENDICHO MARCH', 'https://lh3.googleusercontent.com/a/ACg8ocLPNjZKRhcM2Qu9PdWgKxoBizV-FymosfGM6wcOTdIhSHxkpQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111145204530011656811/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111145204530011656811/reviews');
SET @user_monica_biendicho_march = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111145204530011656811/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sefa Aparici', 'https://lh3.googleusercontent.com/a-/ALV-UjVp5iByGjuhOU-5czrAX-8ncv1ulKyxlymYWvy1V9QWAi7D8LjM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108162862394819566475/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108162862394819566475/reviews');
SET @user_sefa_aparici = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108162862394819566475/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Damir Tomasic', 'https://lh3.googleusercontent.com/a-/ALV-UjWG--q6m50b3GMMsDg08iBUziLzVpfGhVj5C4wgeRCKBdU9Wm8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104535670766504266866/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104535670766504266866/reviews');
SET @user_damir_tomasic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104535670766504266866/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danilo P', 'https://lh3.googleusercontent.com/a/ACg8ocLMdPlX6kugJ27MnrKWu4dyoV5Bn46jBREKbDDbDeoaAJbxoQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100136356007083215966/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100136356007083215966/reviews');
SET @user_danilo_p = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100136356007083215966/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rados Dedic', 'https://lh3.googleusercontent.com/a/ACg8ocIbxKAMnbYhV9Hit-xGViP4ke-FIbUINrHhRAYLUJ3uVePwc18=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116445386393971182366/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116445386393971182366/reviews');
SET @user_rados_dedic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116445386393971182366/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladimir Rakočević', 'https://lh3.googleusercontent.com/a-/ALV-UjWxz39ysr30G4TaIGsuqXp-pbuVaG3J-wvzF8O0VddzfR-colRP=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110228557059499312533/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110228557059499312533/reviews');
SET @user_vladimir_rakoevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110228557059499312533/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandar Vučinić', 'https://lh3.googleusercontent.com/a-/ALV-UjXlygYWsrvZPr2Jzx_7jnThq3SlOMAPhoG3ftjMQcFKyZJ6ClHN=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100110178081174060277/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100110178081174060277/reviews');
SET @user_aleksandar_vuini = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100110178081174060277/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, '小峰章', 'https://lh3.googleusercontent.com/a/ACg8ocLRwB1YrdwPZlIfgGYNK0ebvNX1lQEpN5PdFWBocoSPG430HQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115527849659514248513/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115527849659514248513/reviews');
SET @user_user_115527849659514248513 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115527849659514248513/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branko Gusnic', 'https://lh3.googleusercontent.com/a/ACg8ocJEqHYnZeFSD4iDQ213Ko-lkafvn6s1y2rGJovA7UvuR4hEtg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117348723850992615003/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117348723850992615003/reviews');
SET @user_branko_gusnic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117348723850992615003/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milos Zeljkov Martinovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUYSdjPvyHZfo451viNrKGoGd5xvNnqCtHnk-DY9DGB03CFYNul=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104686543281505938591/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104686543281505938591/reviews');
SET @user_milos_zeljkov_martinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104686543281505938591/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Knezevic', 'https://lh3.googleusercontent.com/a/ACg8ocI1GQQAi1CbJTb-hyWKvjlQ5dTAJO1asR0rzXWPqTGUe9SJRQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110971498496379406578/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110971498496379406578/reviews');
SET @user_marko_knezevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110971498496379406578/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_sofia_jiouak, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSblZYRjVNMDV4Vld0bWNuZHhaVVpXTTFCRFZtYxAB',
    5, 'es', 'Alex es el nejor sin duda alguna.
Estuve de viaje en Podgorica y fui 2 veces a su clínica. Es muy atento y cuidadoso. Además que fue muy flexible con las citas. Sabe muy bien de lo que habla y tiene gran experiencia en su campo.
Sin duda, si vuelvo a Podgorica, volveré a visitarlo si hace falta.
Lo recomiendo 100%.',
    'Aleks je nesumnjivo najbolji.
Bio sam u Podgorici i dva puta sam posetio njegovu kliniku. Veoma je pažljiv i oprezan. Takođe je bio veoma fleksibilan sa zakazivanjem pregleda. Zna svoj posao i ima veliko iskustvo u svojoj oblasti. Bez sumnje, ako se vratim u Podgoricu, ponovo ću ga posetiti ako bude potrebno. Preporučujem ga 100%.', 'Алекс је несумњиво најбољи.
Био сам у Подгорици и два пута сам посетио његову клинику. Веома је пажљив и опрезан. Такође је био веома флексибилан са заказивањем прегледа. Зна свој посао и има велико искуство у својој области. Без сумње, ако се вратим у Подгорицу, поново ћу га посетити ако буде потребно. Препоручујем га 100%.', NULL, NULL, NULL, NULL,
    0, '2025-12-06 16:36:27'),

(@user_a_b, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xodFdYcERiR1pyU0VkeU5VeGtkakE0T1dOUVFYYxAB',
    5, 'bs', 'Aleksandar ima magnet i ultrazvuk u rukama!!! Primjenom iskustva, znanja, empatije i posvećenosti, sa savremenim aparatima i tehnikama oporavlja tijelo u nevjerovatno kratkom periodu. Profesionalizam na zavidnom nivou!

Sve preporuke 👌🏻',
    'Aleksandar ima magnet i ultrazvuk u rukama!!! Koristeći iskustvo, znanje, empatiju i posvećenost, savremenim uređajima i tehnikama, oporavlja telo u neverovatno kratkom roku. Profesionalnost na zavidnom nivou!

Sve preporuke 👌🏻', 'Александар има магнет и ултразвук у рукама!!! Користећи искуство, знање, емпатију и посвећеност, савременим уређајима и техникама, опоравља тело у невероватно кратком року. Професионалност на завидном нивоу!

Све препоруке 👌🏻', NULL, NULL, NULL, NULL,
    0, '2025-11-11 10:36:56'),

(@user_dana_koehler, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5RVF6RTJibEowT0ZwUFozQkJOMWh5Tmt0SGVIYxAB',
    5, 'bs', 'Došla sam sa jakim bolovima, kao što su rasprostranjeni bolovi u mišićima koji nisu prolazili. Nakon što su mi dali terapiju, bolovi su skoro potpuno nestali!',
    'Došao sam sa jakim bolom, kao što je rašireni bol u mišićima koji nije hteo da nestane. Nakon što su mi dali terapiju, bol je skoro potpuno nestao!', 'Дошао сам са јаким болом, као што је раширени бол у мишићима који није хтео да нестане. Након што су ми дали терапију, бол је скоро потпуно нестао!', NULL, NULL, NULL, NULL,
    0, '2025-11-08 18:48:00'),

(@user_jona_bvba, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/ChZDSUhNMG9nS0VJQ0FnSURIOXRYWld3EAE',
    5, 'en', 'Very professional physiotherapist, really friendly and communicative.
Every time I am in Montenegro, I go to see him because of his good quality treatments.
Thank you Aleksandar for all your help !',
    'Veoma profesionalan fizioterapeut, zaista ljubazan i komunikativan.
Svaki put kada sam u Crnoj Gori idem kod njega zbog kvalitetnih tretmana.
Hvala Aleksandre na pomoći!', 'Веома професионалан физиотерапеут, заиста љубазан и комуникативан.
Сваки пут када сам у Црној Гори идем код њега због квалитетних третмана.
Хвала Александре на помоћи!', 'Very professional physiotherapist, really friendly and communicative.
Every time I am in Montenegro, I go to see him because of his good quality treatments.
Thank you Aleksandar for all your help !', NULL, NULL, NULL,
    1, '2024-09-15 21:23:34'),

(@user_ranka_bogicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNUZzR2aHJnRRAB',
    5, 'fr', 'Un physiothérapeute fantastique, qui vous accueille toujours avec le sourire et avec le désir et la volonté de vous aider. Après la première fois, je savais que c\'était ça, un physiothérapeute qui sait ce qu\'il faut faire pour se sentir à nouveau mieux et sans douleur, toutes les recommandations. Je reviendrai, c\'est sûr. 5⭐️',
    'Fantastičan fizioterapeut, koji vas uvek dočeka sa osmehom i sa željom i željom da vam pomogne. Već nakon prvog puta sam znao da je to to, fizioterapeut koji zna šta treba da uradi da se ponovo osećam bolje i bez bolova, sve preporuke. sigurno ću se vratiti. 5⭐', 'Фантастичан физиотерапеут, који вас увек дочека са осмехом и са жељом и жељом да вам помогне. Већ након првог пута сам знао да је то то, физиотерапеут који зна шта треба да уради да се поново осећам боље и без болова, све препоруке. сигурно ћу се вратити. 5⭐', NULL, NULL, NULL, NULL,
    1, '2024-05-18 11:47:11'),

(@user_vladan_pupovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21ZdE5GcFdhV0ZuVEY5b2R6UklORWQ0Wmt4MGVrRRAB',
    5, 'hr', 'Odličan odnos prema klijentima, visok nivo profesionalnosti i veliko znanje! Sve preporuke za sve koji žele brz oporavak, stručnu pomoć i sigurnu njegu!!!',
    'Odličan odnos prema klijentima, visok nivo profesionalnosti i veliko znanje! Sve preporuke za sve koji žele brz oporavak, stručnu pomoć i sigurnu njegu!!!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-29 00:00:00'),

(@user_pavle_tosic, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2toRlprVTFZMTlZZEVOWE5sUjZhbUl3TUVOTlQwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-24 00:00:00'),

(@user_ann, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkd1ZYcEtTMVE1Y3pkME9GVkNlVEZoZFZwcU0wRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-22 00:00:00'),

(@user_luka_gobovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5TmRrdGFRbXN6YWtaWE4zQnpXbFpITkd0bGVVRRAB',
    5, 'bs', 'Preko 2 godine saradnje. Uz redovne terapije i konsultacije za svakodnevnicu bez bola! Sveka preporuka!',
    'Preko 2 godine saradnje. Uz redovne terapije i konsultacije za svakodnevnicu bez bola! Sveka preporuka!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWVlJIQnlieTExY0haak5GTklURWhTY21wMk1HYxAB',
    5, 'hr', 'Jako prijatan ambijent, sjajan tim , pravi profesionalci!',
    'Jako prijatan ambijent, sjajan tim , pravi profesionalci!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_radulovic_radulovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21oNE1sWmhlUzFxVG01NVVuQlBPVEJHVW10dVlXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_jovana_ceklic, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s1emMzWTRSVEZNTWs5Mk0wWnlXR3Q0ZVRSM1lXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_mirko_kekovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xNM1pWZENaVGxWVkdScExWRTFWMVpTVERGVFFYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_branko_lalicic, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KRFEwNTRPRTlSTTIxcWRrVlBaaTEyTFZOT1dsRRAB',
    5, 'en', 'Dr. Brajko is the best in town 🦾',
    NULL, NULL, 'Dr. Brajko is the best in town 🦾', NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_user_114902408659527603618, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pOM2RHODRjMm93ZWxWVFIyMXNVa1pFTFhGakxWRRAB',
    5, 'bs', 'Ja sam došao iz Japana na fudbalsko usavršavanje. Tokom jedne fudbalske utakmice došlo je do kontakta i zadobio sam rupturu mišića tipa II. Zbog toga nisam mogao da igram fudbal i bližio se dan mog povratka kući, a da nisam mogao da se vratim na teren. Bilo je dana kada sam od tuge i frustracije čak i zaplakao.

Međutim, zahvaljujući svakodnevnim terapijama i velikoj brizi koju sam dobio u ovoj bolnici, moj oporavak je napredovao mnogo brže nego što sam očekivao i sada se očekuje da ću se vratiti na teren za manje od mjesec dana.

Siguran sam da bih bez ove pomoći imao problema sa ovom povredom više od tri mjeseca. Iskreno sam vam zahvalan za sve što ste učinili za mene. Hvala vam od srca.',
    'Ja sam došao iz Japana na fudbalsko usavršavanje. Tokom jedne fudbalske utakmice došlo je do kontakta i zadobio sam rupturu mišića tipa II. Zbog toga nisam mogao da igram fudbal i bližio se dan mog povratka kući, a da nisam mogao da se vratim na teren. Bilo je dana kada sam od tuge i frustracije čak i zaplakao.

Međutim, zahvaljujući svakodnevnim terapijama i velikoj brizi koju sam dobio u ovoj bolnici, moj oporavak je napredovao mnogo brže nego što sam očekivao i sada se očekuje da ću se vratiti na teren za manje od mjesec dana.

Siguran sam da bih bez ove pomoći imao problema sa ovom povredom više od tri mjeseca. Iskreno sam vam zahvalan za sve što ste učinili za mene. Hvala vam od srca.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_alex_yang, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/Ci9DQUlRQUNvZENodHljRjlvT20wMlJXcDNOMjFZY25Cc1RHWktWREZyU20xQmRuYxAB',
    5, 'zh', '我的背和肩胛骨疼痛已经很多年了，Alex给我解释了病痛的根本原因，并在短时期内教我自我长期锻炼和治疗的方法，这对我来说是非常重要的。他们的环境很好，服务也很棒。',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_lina_chernova, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWRFJIbGxVRVJVUW1oM2VIVm1XbFpCZFVWRU9HYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_reglaza_trapa_ivanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/Ci9DQUlRQUNvZENodHljRjlvT205YVpWSjZRbWhaUjJsdFVrdzFjemxpWmtGdFpFRRAB',
    5, 'hr', 'Broj 1 u Crnoj Gori !
Topla preporuka.',
    'Broj 1 u Crnoj Gori !
Topla preporuka.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_zhongshi_cong, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pBelVFVjVUbDlyWHpsU2JFbExkMk5qZFZCdVMyYxAB',
    5, 'en', 'very nice experience, with top rate quality and devices, and therapist is very patient , check if it went well with you.',
    NULL, NULL, 'very nice experience, with top rate quality and devices, and therapist is very patient , check if it went well with you.', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_velimir_djurdjic, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/ChdDSUhNMG9nS0VJQ0FnTUNJbG9ldjNnRRAB',
    5, 'hr', 'Ljubazan, profesionalan, sve preporuke.',
    'Ljubazan, profesionalan, sve preporuke.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dejan_socanin, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/ChdDSUhNMG9nS0VJQ0FnTUNJbHNlSHNRRRAB',
    5, 'hr', 'Nema greske! Na pravom ste mestu , svaka preporuka 💪.',
    'Nema greske! Na pravom ste mestu , svaka preporuka 💪.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_akif_oktar, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/ChZDSUhNMG9nS0VJQ0FnTUNJdk1QakxREAE',
    5, 'en', 'The best physio in the region',
    NULL, NULL, 'The best physio in the region', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_monica_biendicho_march, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/ChdDSUhNMG9nS0VJQ0FnTUNJMElqei1RRRAB',
    5, 'es', 'Atención al paciente espléndida. Manifiesta gran empatía y aplica técnicas innovadoras y curativas. Gracias a su profesionalidad he mejorado muchísimo. Lo recomiendo 100%.',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_sefa_aparici, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/ChdDSUhNMG9nS0VJQ0FnTUNJMFBEcTVRRRAB',
    5, 'es', 'Gran fisioterapeuta muy profesional, acudimos a su clínica con una emergencia mientras estábamos de viaje en Podgorica, nos ayudó en todo, incluso  estuvo pendiente nuestro por WhatsApp',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_damir_tomasic, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/ChdDSUhNMG9nS0VJQ0FnTUR3eE5DQm9BRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_danilo_p, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/ChZDSUhNMG9nS0VJQ0FnTUNndXZIOVdBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_rados_dedic, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/ChZDSUhNMG9nS0VJQ0FnTUNnNHNEcURnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_vladimir_rakoevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNYMEpIVmZBEAE',
    5, 'hr', 'Profesionalan rad 👌',
    'Profesionalan rad 👌', NULL, NULL, NULL, NULL, NULL,
    1, '2024-10-29 00:00:00'),

(@user_aleksandar_vuini, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNkaU5EN2FBEAE',
    5, 'en', 'Shortly after the surgery of the knee(torn meniscus repair) which was carried out in the Independent London Hospital in the UK, I had a fantastic chance to work on my pysiotherarpy rehabilitation with Aleksandar who is a fabulous professional with an impressive track record. He is a subject matter expert whose knowledge is based in academic educational background.
I was delighted by the professional dedication and commitment he showed to me as a patient. His set of exercises assigned to me were very well structured, methodical and ultimately very effective which is the most important. He was continually providing deep and thorough insight about the process of rehabilitation, describing the exercises in detail and illustrating their effect on the joints and muscles. He seems very passionate and enthusiastic about his jobs which motivates a patient to put more effort and raise the bar constantly. Aleksandar has a great social skills which make you feel relaxed and comfortable during the appointment in his office. I would strongly recommend Aleksandar to any individual looking for a professional pysiotherarpy.',
    NULL, NULL, 'Shortly after the surgery of the knee(torn meniscus repair) which was carried out in the Independent London Hospital in the UK, I had a fantastic chance to work on my pysiotherarpy rehabilitation with Aleksandar who is a fabulous professional with an impressive track record. He is a subject matter expert whose knowledge is based in academic educational background.
I was delighted by the professional dedication and commitment he showed to me as a patient. His set of exercises assigned to me were very well structured, methodical and ultimately very effective which is the most important. He was continually providing deep and thorough insight about the process of rehabilitation, describing the exercises in detail and illustrating their effect on the joints and muscles. He seems very passionate and enthusiastic about his jobs which motivates a patient to put more effort and raise the bar constantly. Aleksandar has a great social skills which make you feel relaxed and comfortable during the appointment in his office. I would strongly recommend Aleksandar to any individual looking for a professional pysiotherarpy.', NULL, NULL, NULL,
    1, '2024-10-29 00:00:00'),

(@user_user_115527849659514248513, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/ChdDSUhNMG9nS0VJQ0FnSURwNHJURTVnRRAB',
    5, 'ja', 'しっかりと個々の怪我にアプローチしていて
完治へと近づいた。とても良かった。',
    NULL, NULL, NULL, NULL, NULL, NULL,
    1, '2023-10-29 00:00:00'),

(@user_branko_gusnic, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/ChZDSUhNMG9nS0VJQ0FnSURKbko3NlpREAE',
    5, 'bs', 'Odlican pristup pacijentu, detaljan pregled, strucno savetovanje i tretman pacijenta. Sve preporuke!!',
    'Odlican pristup pacijentu, detaljan pregled, strucno savetovanje i tretman pacijenta. Sve preporuke!!', NULL, NULL, NULL, NULL, NULL,
    2, '2023-10-29 00:00:00'),

(@user_milos_zeljkov_martinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNlelozQ0RnEAE',
    5, 'bs', 'Profesionalac prije svega. Preporodio me je. Sve preporuke',
    'Profesionalac prije svega. Preporodio me je. Sve preporuke', NULL, NULL, NULL, NULL, NULL,
    2, '2022-10-29 00:00:00'),

(@user_marko_knezevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJfaGYgC3rTRMRHWWeeXeO6Wo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNzaTgtMTZnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
