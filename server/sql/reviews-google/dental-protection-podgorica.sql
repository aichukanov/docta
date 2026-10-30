-- Insert Google Maps reviews for Dental Protection
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dental-protection-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dental-protection-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_zana_popovic = (SELECT id FROM doctors WHERE slug = 'zana-popovic');
SET @doctor_marko_popovic = (SELECT id FROM doctors WHERE slug = 'marko-popovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stefan Perosevic', 'https://lh3.googleusercontent.com/a/ACg8ocL7VomDp1CWu28YvpT6_Doh5YuG9LrRHiHFW4sQUS6Hp487=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111352656344102868490/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111352656344102868490/reviews');
SET @user_stefan_perosevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111352656344102868490/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Мама Миа Черногория', 'https://lh3.googleusercontent.com/a-/ALV-UjXomyU0xsvAClQAP3itD7jbzQxnhjU6sPzbLmioAAbOzEuZxOLS=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/118396065560190153712/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118396065560190153712/reviews');
SET @user_mama_mia_chernogoriya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118396065560190153712/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'dragana dedic', 'https://lh3.googleusercontent.com/a-/ALV-UjXHJj70hUhgG6x5wwEMST7LZe2J7PLPF31U43W-RRVtCOJbNEBN=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/104729682585768022853/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104729682585768022853/reviews');
SET @user_dragana_dedic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104729682585768022853/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zarko Miranovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUwsPWDPXCuLLElGVcsn3C73PwBUyfklLPEGbnoZ0Y1QtcTjOanAw=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/115722466213748945384/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115722466213748945384/reviews');
SET @user_zarko_miranovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115722466213748945384/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bosko Puric', 'https://lh3.googleusercontent.com/a-/ALV-UjXvuRmUV-J6obOUkVBz4lVFCWMjCy-vh3QGpKCgcQfgfsN19A7F=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/102426918971716325178/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102426918971716325178/reviews');
SET @user_bosko_puric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102426918971716325178/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Instalacija Maestral', 'https://lh3.googleusercontent.com/a/ACg8ocLvLTqb81UYaNthHP3XTYLeCCLvmlvLOIE_xxFNfQxNTM_v8g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103628050269745140229/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103628050269745140229/reviews');
SET @user_instalacija_maestral = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103628050269745140229/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sveti Stefan Čantići', 'https://lh3.googleusercontent.com/a/ACg8ocIdiMOjH8HLaVanqPEvrVS2XZdRAlTo0PCBp-4-1tvQ9aKP1g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108123459333134385888/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108123459333134385888/reviews');
SET @user_sveti_stefan_antii = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108123459333134385888/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bulajić Vladimir', 'https://lh3.googleusercontent.com/a/ACg8ocIC9mk4icLtEvDAGETT_5Gu7Xgsa10Q0yyAnQEE4glaj-hgBw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107057770682733676270/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107057770682733676270/reviews');
SET @user_bulaji_vladimir = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107057770682733676270/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bozidar Medigovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXnLQL4TbaqgKMLkXUI2ehpANDoopR2RYas51WixmY56IW4zglC=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101878011169119086761/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101878011169119086761/reviews');
SET @user_bozidar_medigovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101878011169119086761/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branko Medigovic', 'https://lh3.googleusercontent.com/a/ACg8ocKcgYLIj67-OQDOZyQdb0fRqMNiQ-03Dv0A91bmcBEjsJIaAQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101465713017674266012/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101465713017674266012/reviews');
SET @user_branko_medigovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101465713017674266012/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lidija Medigovic', 'https://lh3.googleusercontent.com/a/ACg8ocKtdZp2qZNPQLkBRCIK5PuzQ-gMYG_VlUlowu9OaxN9JrxHDA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102787577071264188265/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102787577071264188265/reviews');
SET @user_lidija_medigovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102787577071264188265/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojana Vulic', 'https://lh3.googleusercontent.com/a-/ALV-UjW4L5_BWgFOmlcwhfG-Q52sdg_m0W3KZCMsTQ45tEXo2D9K1hUY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111509741607810297051/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111509741607810297051/reviews');
SET @user_bojana_vulic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111509741607810297051/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lulemax Nakipop', 'https://lh3.googleusercontent.com/a-/ALV-UjWRDo-AhIOaaNde_4mGrhKvtczOHTN_2HPb6rStRyl4PlfY_OClwA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110763362472331065589/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110763362472331065589/reviews');
SET @user_lulemax_nakipop = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110763362472331065589/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica SZ', 'https://lh3.googleusercontent.com/a/ACg8ocIJLN1effsbvIB56jjV5qlcLBED5RjGLREdAcVbO7li4VOAFg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112489337113334290232/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112489337113334290232/reviews');
SET @user_milica_sz = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112489337113334290232/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Musa Husovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXKcF9R0FtpJPxVeSfbOgy_2LnTFNWFdXI9OkXxLB5G-hWUWw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117731437390190830754/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117731437390190830754/reviews');
SET @user_musa_husovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117731437390190830754/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Drljevic', 'https://lh3.googleusercontent.com/a/ACg8ocL26tbE7nozRarkja-T1NTcqFcSmNGGil4Y4-H_R5ePSyBbKS3z=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116385978384288527251/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116385978384288527251/reviews');
SET @user_dragana_drljevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116385978384288527251/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andjela Jovovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWr9egYbDiFifatTdexRfyQtONJuBf4kJ8Dw1CwFIExW6-C6LjR=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116984949786331577169/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116984949786331577169/reviews');
SET @user_andjela_jovovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116984949786331577169/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Janketic', 'https://lh3.googleusercontent.com/a-/ALV-UjUGEuVWFduXryV2mFvrrrTsQY7X6pgTYW4u6-Fvkbw7qLyd4VDfmA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117267715610373612805/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117267715610373612805/reviews');
SET @user_jovana_janketic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117267715610373612805/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stefan Vidic', 'https://lh3.googleusercontent.com/a/ACg8ocLBAHxZZp7mYZKfSE5zzihWjSQ5wYMDqDyq4u3kM0WC1_ZOvA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106841116640073829542/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106841116640073829542/reviews');
SET @user_stefan_vidic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106841116640073829542/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rajna Milacic', 'https://lh3.googleusercontent.com/a/ACg8ocJ7QbIX5Z_ZvP5nZyQALa4ZikTeL1eC168EaLgUCrCINndxFg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112847357173590145772/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112847357173590145772/reviews');
SET @user_rajna_milacic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112847357173590145772/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milena Živaljević', 'https://lh3.googleusercontent.com/a-/ALV-UjUNeWc4vlSaHBcQtnj3KhWDLbtMb1Fy2WPrf70IQ3r9kZxmV6RZ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102320117537696314024/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102320117537696314024/reviews');
SET @user_milena_ivaljevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102320117537696314024/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Viktor Sego', 'https://lh3.googleusercontent.com/a/ACg8ocJoljMYu7afBtI93JpkZgQ8bF4Zxuh6rJKNeE6-zj0aNBBChlE=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101804733552481019639/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101804733552481019639/reviews');
SET @user_viktor_sego = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101804733552481019639/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Selime Özteriş', 'https://lh3.googleusercontent.com/a/ACg8ocLUB2YL1i4N0Fb-YGiXIgH2pPI7jUUki0GPmolO71HBgzxEmg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101045747393524641339/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101045747393524641339/reviews');
SET @user_selime_zteri = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101045747393524641339/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maksim Đurić', 'https://lh3.googleusercontent.com/a/ACg8ocKyZZE4pWJGKG1Fg8VUSU8WwanRZxtUA0FD14GikMIloUWrRQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102514829982725473957/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102514829982725473957/reviews');
SET @user_maksim_uri = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102514829982725473957/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sabina Sabi', 'https://lh3.googleusercontent.com/a/ACg8ocJrpAGn98GoVvecXdYbZZCYwqdQZG2TaSvFi2cUHuWLuma04XuX=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105642956563054689227/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105642956563054689227/reviews');
SET @user_sabina_sabi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105642956563054689227/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Miso Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocIoquUhVHwtYMSJlJQyW5VBSyCzJiheeHs5nklntO2wD3JNEQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109893664033383654195/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109893664033383654195/reviews');
SET @user_miso_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109893664033383654195/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Josif Šundić', 'https://lh3.googleusercontent.com/a-/ALV-UjXX0ffBKN_E8nVGA7BpglEgH-AUyXCOWVlJn7rYRCjjA26QfTp4hg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115758085361334910653/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115758085361334910653/reviews');
SET @user_josif_undi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115758085361334910653/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanjay West', 'https://lh3.googleusercontent.com/a-/ALV-UjUefNSz9xxSLqN5GW1OTFvXdy1fz77EL8_aRbDaCoYLeukdYln9PQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111580618184985812833/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111580618184985812833/reviews');
SET @user_sanjay_west = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111580618184985812833/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'vojin todorovic', 'https://lh3.googleusercontent.com/a/ACg8ocIdPqGUvCTTv-DWnAXm3oT1ACaKe3tLwBJxD8E3yR81btMj0Q=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111210607078174058418/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111210607078174058418/reviews');
SET @user_vojin_todorovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111210607078174058418/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Amel E', 'https://lh3.googleusercontent.com/a/ACg8ocIZuMlCsu96yF7IU9AgTDQJsV0Hdyp4mxqh5Bz_uzL9r3IjQKs=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102981541223898178388/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102981541223898178388/reviews');
SET @user_amel_e = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102981541223898178388/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vuki', 'https://lh3.googleusercontent.com/a-/ALV-UjU8S54_3Urp-znLLsLrHYzMEfy0R5rv2ILhbLOLOvm4I6hB5jez=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108871854664965610046/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108871854664965610046/reviews');
SET @user_vuki = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108871854664965610046/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Travel Montenegro', 'https://lh3.googleusercontent.com/a-/ALV-UjUWIOWrvak6XY97uTAwzpl49dNxYxMxgM98y0RWKJ6q9uLIl-O2=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113630389526366530156/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113630389526366530156/reviews');
SET @user_travel_montenegro = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113630389526366530156/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Veljko Knezevic', 'https://lh3.googleusercontent.com/a/ACg8ocJ_P8pFxQhnUcWJLGZqSKnMuLiSTOUv5sT3qGRvyah0H3q0I4s=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117368058777299761439/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117368058777299761439/reviews');
SET @user_veljko_knezevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117368058777299761439/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Laura Gjokaj', 'https://lh3.googleusercontent.com/a-/ALV-UjVJ4aMhVvOvslauNarbEuSMlIp3Vfx6nekCrNxyTInEi_h_CFlDQA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100651281861856273092/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100651281861856273092/reviews');
SET @user_laura_gjokaj = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100651281861856273092/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Lipovac', 'https://lh3.googleusercontent.com/a-/ALV-UjVJ2d04rOQGuXbwgkFEEvJpaYr4c0JgdHeBcZFyqBMmt-S3snhkdQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109534311877531199636/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109534311877531199636/reviews');
SET @user_jovana_lipovac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109534311877531199636/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zeljko Rnkovic', 'https://lh3.googleusercontent.com/a/ACg8ocJK6fXQSga-f56RL5H_3pqUE9BFUWL2H4ujFK345Oveqce6=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105925466765077564546/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105925466765077564546/reviews');
SET @user_zeljko_rnkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105925466765077564546/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Radonjić', 'https://lh3.googleusercontent.com/a/ACg8ocLGg0rJLf_2LuR0gYvssjy25h2CQGsczSrteh_4okE31rhb7Og=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109436729750443427618/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109436729750443427618/reviews');
SET @user_ivan_radonji = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109436729750443427618/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragisa Rasovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUCAQJjGkaSv7ylTM2P8qY46DTm_U6-3k9-0sKWCEZvBPU9WqAW=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116476662805805313119/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116476662805805313119/reviews');
SET @user_dragisa_rasovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116476662805805313119/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lela Vojvodic', 'https://lh3.googleusercontent.com/a-/ALV-UjXr2-EMDEvOZONUjClI8ZxoeMGDwIQUbcDe31oM50ZFES_1Isispg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114089644033881428167/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114089644033881428167/reviews');
SET @user_lela_vojvodic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114089644033881428167/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladimir Crnogorac', 'https://lh3.googleusercontent.com/a/ACg8ocJnEM90DRn3YI2fvcwkYNMLybRxQNTcgDim5iRpDRbv4dHREA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100107348421721383211/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100107348421721383211/reviews');
SET @user_vladimir_crnogorac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100107348421721383211/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pro Auto', 'https://lh3.googleusercontent.com/a-/ALV-UjWc11hag-nTw-bhEXeUXnsVgU-1My1UM7QYuti-qkGJTbWzO04=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111687207018044030959/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111687207018044030959/reviews');
SET @user_pro_auto = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111687207018044030959/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Janko Bulatovic', 'https://lh3.googleusercontent.com/a/ACg8ocKog3SOaIy_V3ixFxuaeRVelCcjtVuqoH_C6Cr5LYxCclaWxA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110654017434358816656/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110654017434358816656/reviews');
SET @user_janko_bulatovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110654017434358816656/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_stefan_perosevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCSVNqWjNZbkkzVm04MlFtNU5iR1ExWTJwQ0xXYxAB',
    5, 'bs', 'Sve preporuke za doktoricu Zanu Popovic. Posjeduje savrsen spoj profesionalizma i razumijevanja za patijente. Svi zaposleni su jako fini i spremi da izadju u susret, a posebno Dragna Dedic. Svaki put kad sam usao sa brigom  izasaos sa osmijehom.',
    'Sve preporuke za dr Žanu Popović. Ona ima savršen spoj profesionalizma i razumevanja za pacijente. Svi zaposleni su veoma ljubazni i spremni da pomognu, a posebno Dragna Dedić. Svaki put kada sam pažljivo ulazio, izlazio sam sa osmehom.', 'Све препоруке за др Жану Поповић. Она има савршен спој професионализма и разумевања за пацијенте. Сви запослени су веома љубазни и спремни да помогну, а посебно Драгна Дедић. Сваки пут када сам пажљиво улазио, излазио сам са осмехом.', NULL, NULL, NULL, NULL,
    0, '2025-10-27 11:28:35'),

(@user_mama_mia_chernogoriya, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21sMlZrcEZZMlZxVUZWbVRuSnpabEZITUZOVmFVRRAB',
    5, 'ru', 'Одлична клиника, све је пажљиво и стерилно. Вадила сам умњаке — све је прошло као магија, за око 5 минута. Особље је веома, веома љубазно. Док сам седела у чекаоници, видело се како се људи враћају са захвалношћу и чоколадама. Веома сам задовољна радом клинике и професионализмом лекара.
Замечательная клиника, все внимательно, стерильно, вырывала зубы мудрости - все прошло просто как волшебство, в течение 5 мин, очень очень  доброжелательный персонал. Пока сидела в очереди видно как люди с благодарностями, шоколадками возвращаются. Я очень довольна работой клиники и профессионализмом врачей.',
    'Divna klinika, veoma pažljiva i sterilna. Doktoru je trebalo 5 minuta da izvadi umnjake. Doktor je veoma ljubazan i uslužan. Doktor je veoma pažljiv i sterilan. Izvadili su mi umnjake - sve je prošlo kao magija, u roku od 5 minuta. Osoblje je bilo veoma ljubazno. Dok sam čekala u redu, videla sam ljude kako se vraćaju sa zahvalnošću i čokoladama. Veoma sam zadovoljna klinikom i profesionalizmom lekara.', 'Дивна клиника, веома пажљива и стерилна. Доктору је требало 5 минута да извади умњаке. Доктор је веома љубазан и услужан. Доктор је веома пажљив и стерилан. Извадили су ми умњаке - све је прошло као магија, у року од 5 минута. Особље је било веома љубазно. Док сам чекала у реду, видела сам људе како се враћају са захвалношћу и чоколадама. Веома сам задовољна клиником и професионализмом лекара.', NULL, 'Одлична клиника, све је пажљиво и стерилно. Вадила сам умњаке — све је прошло као магија, за око 5 минута. Особље је веома, веома љубазно. Док сам седела у чекаоници, видело се како се људи враћају са захвалношћу и чоколадама. Веома сам задовољна радом клинике и професионализмом лекара.
Замечательная клиника, все внимательно, стерильно, вырывала зубы мудрости - все прошло просто как волшебство, в течение 5 мин, очень очень  доброжелательный персонал. Пока сидела в очереди видно как люди с благодарностями, шоколадками возвращаются. Я очень довольна работой клиники и профессионализмом врачей.', NULL, NULL,
    0, '2025-12-22 13:14:52'),

(@user_dragana_dedic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25ObWVYUkJNblpOV0VoblQzcHNkMmMyWnpobVIwRRAB',
    5, 'hr', 'Uvijek nasmijani, ljubazni i profesionalni! Hvala što brinete o mom osmijehu!“',
    'Uvek nasmejani, ljubazni i profesionalni! Hvala ti što brineš o mom osmehu!', 'Увек насмејани, љубазни и професионални! Хвала ти што бринеш о мом осмеху!', NULL, NULL, NULL, NULL,
    0, '2025-10-27 10:55:06'),

(@user_zarko_miranovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNfak5qUlJnEAE',
    5, 'bs', 'Od prvog dana kada sam postao pacijent Dental Protectiona, moje iskustvo je bilo izvanredno. Tim je izuzetno profesionalan, ljubazan i posvećen svakom pacijentu. Svaki moj dolazak je protekao u opuštenoj atmosferi, uz pažnju prema detaljima i maksimalnu posvećenost mom dentalnom zdravlju.

Što se tiče usluga, one su na najvišem nivou. Koriste najsavremenije metode i tehnologiju, a svaka procedura je objašnjena jasno i detaljno, što mi uliva dodatno povjerenje. Takođe, higijena i sterilnost su na vrhunskom nivou, što je za mene jako važno.

Preporučujem Dental Protection svima koji traže stručnost, pristupačnost i vrhunsku brigu o dentalnom zdravlju. Hvala im što su učinili da se osjećam sigurno i zadovoljno pri svakom dolasku!

Ocjena: ⭐⭐⭐⭐⭐',
    'Od prvog dana kada sam postao pacijent u Dental Protekšnu, moje iskustvo je bilo izuzetno. Tim je izuzetno profesionalan, ljubazan i posvećen svakom pacijentu. Svaka moja poseta je sprovedena u opuštenoj atmosferi, sa pažnjom posvećenom detaljima i maksimalnom posvećenošću mom stomatološkom zdravlju.

Što se tiče usluga, one su na najvišem nivou. Koriste najsavremenije metode i tehnologiju, a svaka procedura je jasno i detaljno objašnjena, što mi daje dodatno samopouzdanje. Takođe, higijena i sterilnost su na najvišem nivou, što mi je veoma važno.

Preporučujem Dental Protekšn svima koji traže stručnost, pristupačnost i vrhunsku stomatološku negu. Hvala vam što ste mi pružili osećaj sigurnosti i zadovoljstva svakom posetom!

Ocena: ⭐⭐⭐⭐⭐', 'Од првог дана када сам постао пацијент у Дентал Протекшну, моје искуство је било изузетно. Тим је изузетно професионалан, љубазан и посвећен сваком пацијенту. Свака моја посета је спроведена у опуштеној атмосфери, са пажњом посвећеном детаљима и максималном посвећеношћу мом стоматолошком здрављу.

Што се тиче услуга, оне су на највишем нивоу. Користе најсавременије методе и технологију, а свака процедура је јасно и детаљно објашњена, што ми даје додатно самопоуздање. Такође, хигијена и стерилност су на највишем нивоу, што ми је веома важно.

Препоручујем Дентал Протекшн свима који траже стручност, приступачност и врхунску стоматолошку негу. Хвала вам што сте ми пружили осећај сигурности и задовољства сваком посетом!

Оцена: ⭐⭐⭐⭐⭐', NULL, NULL, NULL, NULL,
    0, '2025-01-13 12:37:27'),

(@user_bosko_puric, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xodGFEZDFaemt0TjJKbFZHNWtlbEJxUld4clMwRRAB',
    5, 'hr', 'Ljubazni i profesionalni, svaka preporuka!',
    'Ljubazni i profesionalni, toplo preporučujem!', 'Љубазни и професионални, топло препоручујем!', NULL, NULL, NULL, NULL,
    0, '2025-11-12 11:37:30'),

(@user_instalacija_maestral, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tSUlJYUnVjRXhuZVdwYVIwNWlWVXRKVnpkRFVFRRAB',
    5, 'hr', 'Samo pohvale, jer definitivno im je svaki pacijent na prvom mjestu',
    'Samo pohvale, jer definitivno im je svaki pacijent na prvom mjestu', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_sveti_stefan_antii, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGSVUzQk9jRlpOVm5SSlJHUlBWWEpFVGpab1NXYxAB',
    5, 'hr', 'Uvjek izlazimo zadovoljni kada god odemo u dental protection, jer se maksimalno trude oko svakog pacijenta, nebitan uzrast i godine',
    'Uvjek izlazimo zadovoljni kada god odemo u dental protection, jer se maksimalno trude oko svakog pacijenta, nebitan uzrast i godine', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_bulaji_vladimir, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25Wd05XeFFTbVEyTkVKd1lUQnNXV1ZETVVWd1RtYxAB',
    5, 'hr', 'Za mene jednostavno najbolji u svom poslu, i uvjek samo pohvale i preporuke od mene',
    'Za mene jednostavno najbolji u svom poslu, i uvjek samo pohvale i preporuke od mene', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_bozidar_medigovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21SRFpGQmFVbVEzWmxKdGJrNVhjRU40VVU0MkxXYxAB',
    5, 'bs', 'Posebne pohvale za Doktorku Žanu Popović i njen odabrani tim, definitivno se svakom pacijentu posveti maksimalno i trudi se da sve detaljno i jednostavno objasni kad je kvar na zubu, u koji tretman je po njoj najbolji.

Uvjek će mi prva adresa biti dental protection kad god budem osjecao potrebu',
    'Posebne pohvale za Doktorku Žanu Popović i njen odabrani tim, definitivno se svakom pacijentu posveti maksimalno i trudi se da sve detaljno i jednostavno objasni kad je kvar na zubu, u koji tretman je po njoj najbolji.

Uvjek će mi prva adresa biti dental protection kad god budem osjecao potrebu', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_branko_medigovic, @clinic_id, @doctor_marko_popovic, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21KWGRVcDNaSEZyWTE5V1FXVjJRbkpUZVdkeGRGRRAB',
    5, 'bs', 'Kao penzioner koji je imao velike probleme i sa gornjim i donjim zubima, mogu samo da kažem da sam prezadovoljan kako su mi posvećeni doktori u toj ordinaciji pomogli, i maksimalno se trudili da mi komplikovani tretmani što lakše padnu.

Uvjek ću ih posjećivati kad god imam neki problem, ili da je u pitanju redovna kontrola.

Posebna zahvalnost Doktoru Marku',
    'Kao penzioner koji je imao velike probleme i sa gornjim i donjim zubima, mogu samo da kažem da sam prezadovoljan kako su mi posvećeni doktori u toj ordinaciji pomogli, i maksimalno se trudili da mi komplikovani tretmani što lakše padnu.

Uvjek ću ih posjećivati kad god imam neki problem, ili da je u pitanju redovna kontrola.

Posebna zahvalnost Doktoru Marku', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_lidija_medigovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT20xcU5YbFBiRlZpYkdaU09XMVdZVzF5VkdnMU5YYxAB',
    5, 'hr', 'Malo je reći da sam uvjek prezadovoljna kada izađem iz njihove ordinacije, jer se svi maksimalno trude oko mene kao jednog od njihovog pacijenta da se prvo osjećam prijatno, i da me ništa ne boli u toku prepravke zuba, koja ponekad može biti komplikovana.

Već dugo dolazim u dental protection i uvjek ću dolaziti, i ne predstavlja mi problem da putujem iz petrovca na moru, jer znam da sam tamo u sigurnim rukama, i da mogu biti skroz bezbrižna.

Svima preporučujem',
    'Malo je reći da sam uvjek prezadovoljna kada izađem iz njihove ordinacije, jer se svi maksimalno trude oko mene kao jednog od njihovog pacijenta da se prvo osjećam prijatno, i da me ništa ne boli u toku prepravke zuba, koja ponekad može biti komplikovana.

Već dugo dolazim u dental protection i uvjek ću dolaziti, i ne predstavlja mi problem da putujem iz petrovca na moru, jer znam da sam tamo u sigurnim rukama, i da mogu biti skroz bezbrižna.

Svima preporučujem', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_bojana_vulic, @clinic_id, @doctor_zana_popovic, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2toNmNrWXRWVUo0TkZWVGJGbG9TR3d6WDFoWVVIYxAB',
    5, 'hr', 'Sve preporuke za ovu polikliniku. Profesionalan i ljubazan kolektiv. Doktorica Zana je njezna, pažljiva i stručna. Imala sam ogroman strah od vađenja osmica ali sve je bilo gotovo za 10 minuta. Anestezija skoro da se ne osjeti. Divna žena, veliki stručnjak sa velikim iskustvom u svom poslu.',
    'Sve preporuke za ovu polikliniku. Profesionalan i ljubazan kolektiv. Doktorica Zana je njezna, pažljiva i stručna. Imala sam ogroman strah od vađenja osmica ali sve je bilo gotovo za 10 minuta. Anestezija skoro da se ne osjeti. Divna žena, veliki stručnjak sa velikim iskustvom u svom poslu.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_lulemax_nakipop, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2paYWJWVjFTRWhXZVc1dU5GRlhhVUZQWDB0T1RIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_milica_sz, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tKdVh5MXZPSFJQZUdsYVpHRmlValU0TjBoRVRFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_musa_husovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twWmIyVnNaamRCYmw5eVJtbFlTMjB0YzNWblQwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_dragana_drljevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KRGJreExTRzkyT0hsTVptOXdibkJrUVhwVVFtYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_andjela_jovovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2paMk9VaHNTbGhmU2tWUFpXbzFVMk16UmpCTlZuYxAB',
    5, 'hr', 'Sjajni!',
    'Sjajni!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jovana_janketic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xVMFkwWXllSGhXWVhVdGNGbGtUWGxIVVROUWRHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_stefan_vidic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21wclFrRnVhV056TjJ0dVJIcDJNRkYxTVhnelkxRRAB',
    5, 'hr', 'Sve pohvale i topla preporuka.',
    'Sve pohvale i topla preporuka.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_rajna_milacic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21sRE5saGFabnBSWm5OamFWQlZPV2hXTkU1UFlYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_milena_ivaljevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tRMFQyUjZaMTl6UWtKdVRIUjNZV04xWVVWc2MzYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_viktor_sego, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChdDSUhNMG9nS0VObWhoNEhsNXZPT3J3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_selime_zteri, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChRDSUhNMG9nS0VLYlpoWV8yM09wRBAB',
    5, 'tr', 'Çok korkarak gittim.Ama iyiki gitmişim diyerek çıktım Teşekkürler Temel Dental Podgorica🙏',
    NULL, NULL, NULL, NULL, NULL, 'Çok korkarak gittim.Ama iyiki gitmişim diyerek çıktım Teşekkürler Temel Dental Podgorica🙏',
    0, '2025-10-29 00:00:00'),

(@user_maksim_uri, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChZDSUhNMG9nS0VJQ0FnTUNnOTRYSEFnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_sabina_sabi, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNfdllURDd3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_miso_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChZDSUhNMG9nS0VJQ0FnSUQzMUwyLVpREAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_josif_undi, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChdDSUhNMG9nS0VJQ0FnSURYa3R2dm93RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_sanjay_west, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChdDSUhNMG9nS0VJQ0FnSURucl9YODJnRRAB',
    5, 'en', 'Very good work, and they are fast.',
    NULL, NULL, 'Very good work, and they are fast.', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_vojin_todorovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNIaS1hZGR3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_amel_e, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChdDSUhNMG9nS0VJQ0FnSUN0dmNPZjVRRRAB',
    5, 'hr', 'Preporuka za Dr. Emu',
    'Preporuka za Dr. Emu', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_vuki, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChdDSUhNMG9nS0VJQ0FnSUN6eE02VzBnRRAB',
    5, 'bs', 'Preporuka, steta sto zubar Zogovic ne radi',
    'Preporuka, steta sto zubar Zogovic ne radi', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_travel_montenegro, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNUanBteE5BEAE',
    5, 'hr', 'Vrhunski doktori i osoblje. Sve pohvale',
    'Vrhunski doktori i osoblje. Sve pohvale', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_veljko_knezevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChZDSUhNMG9nS0VJQ0FnSUM5M1BiVkZBEAE',
    1, 'en', 'My girlfriends implant tooth fell out all together with screw.',
    NULL, NULL, 'My girlfriends implant tooth fell out all together with screw.', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_laura_gjokaj, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChZDSUhNMG9nS0VJQ0FnSURkc0lXYWJREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_jovana_lipovac, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNOaUxIcEZBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_zeljko_rnkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNGM2VITmZnEAE',
    3, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_ivan_radonji, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChZDSUhNMG9nS0VJQ0FnSUM1bEwtQkp3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_dragisa_rasovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNaMGN1YkdREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_lela_vojvodic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChdDSUhNMG9nS0VJQ0FnSUQybW9ENXV3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_vladimir_crnogorac, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChdDSUhNMG9nS0VJQ0FnSURVX1ppanN3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_pro_auto, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNVNUlPWmRREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_janko_bulatovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR1VVqhTrTRMR8AW3tk2L5Lo/reviews/ChdDSUhNMG9nS0VJQ0FnSUR3a0tXSWhnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
