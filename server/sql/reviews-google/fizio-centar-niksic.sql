-- Insert Google Maps reviews for Fizio Centar - Nikšić
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/fizio-centar-niksic.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'fizio-centar-niksic');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_zilha_kojcin = (SELECT id FROM doctors WHERE slug = 'zilha-kojcin');
SET @doctor_predrag_calic = (SELECT id FROM doctors WHERE slug = 'predrag-calic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Radulovic', 'https://lh3.googleusercontent.com/a/ACg8ocKNrqEE0HbRKsz8kJIb4fy4Ijyf5wQ2J7LApJEdmdkRNdU4fA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/104181505039150058654/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104181505039150058654/reviews');
SET @user_marija_radulovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104181505039150058654/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tamara', 'https://lh3.googleusercontent.com/a-/ALV-UjXrc4wf_yfA-XyjkzFydYu3GsJ8nIbqFMakb_xNm3K2G6kEO2S_wQ=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/103156387049012832235/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103156387049012832235/reviews');
SET @user_tamara = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103156387049012832235/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'P Musikic', 'https://lh3.googleusercontent.com/a-/ALV-UjU2FIwZZVZGdIzeTISbwsA7UWGexGMqffjcee-QivnVGE2cm0CG=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/116651441733426038892/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116651441733426038892/reviews');
SET @user_p_musikic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116651441733426038892/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana', 'https://lh3.googleusercontent.com/a/ACg8ocJcSoUphBAdM09a1Mqisaf4W0u2UDsfXki--FlE4p5KNY_xrg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101962068842676180470/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101962068842676180470/reviews');
SET @user_ana = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101962068842676180470/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sandra Ivanović', 'https://lh3.googleusercontent.com/a/ACg8ocLsu4hjQisHZU-Iiv1hzbqOZU60G9qbdihQkghgh6oulpRBEA=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/111653993737145193617/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111653993737145193617/reviews');
SET @user_sandra_ivanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111653993737145193617/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena', 'https://lh3.googleusercontent.com/a/ACg8ocIeDfYEKuV1p_4uUTRenXKrBm7-5vxlnKmlsnjY-qPMwe356w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106615730770985439244/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106615730770985439244/reviews');
SET @user_jelena = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106615730770985439244/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojan Vuceljic', 'https://lh3.googleusercontent.com/a/ACg8ocJvDz8K8uV6_9GuD7wCOx6s-PBO801j2FThKV6KuejNWn-XXg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106501651455560753393/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106501651455560753393/reviews');
SET @user_bojan_vuceljic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106501651455560753393/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dusanka Lojpur', 'https://lh3.googleusercontent.com/a-/ALV-UjX99Pho4kXfKKocQB1g7d5JbdcLLOVCRC2zwiMPkw0pjgKn0IF9pg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105895746155883546860/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105895746155883546860/reviews');
SET @user_dusanka_lojpur = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105895746155883546860/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Darka Vukovic', 'https://lh3.googleusercontent.com/a/ACg8ocKT9CeHzSlpXaY-QInuo0JGCI8RUA-nl9CQ6k-4jv3wT1a5fg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113504587784711485723/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113504587784711485723/reviews');
SET @user_darka_vukovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113504587784711485723/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Kovacevic', 'https://lh3.googleusercontent.com/a-/ALV-UjUPeexUH4bA7RA3GWgaF5B78xFtND_rI-26YtovQMFa21wQe835vA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102873504029151490872/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102873504029151490872/reviews');
SET @user_jelena_kovacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102873504029151490872/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Djukanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjU9h3_V37MI1vBhndbzhFDmfAQJnWSpsmHOLfLCwNgTkMB0mnxo=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100172435272967454866/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100172435272967454866/reviews');
SET @user_ivana_djukanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100172435272967454866/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Bejat', 'https://lh3.googleusercontent.com/a-/ALV-UjWgFiKBOs6saW3nA2AYNXKqQ0FKU9ph3WtkRETh_MY_49-bNOU9=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105277046422550952337/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105277046422550952337/reviews');
SET @user_marko_bejat = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105277046422550952337/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mira Koprivica', 'https://lh3.googleusercontent.com/a-/ALV-UjUrXL_Ro_VZCXMmGOdZ28OukRq_-m_AfjIv5GdkcXRGRKZtVmjd=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103743304509508536516/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103743304509508536516/reviews');
SET @user_mira_koprivica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103743304509508536516/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Zeković', 'https://lh3.googleusercontent.com/a-/ALV-UjWvrCm9WQp3mX9q37ppQ7DgDkNZlFsRuAPMwkk3WKhkDZ7vwYh_ww=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102370296298823406238/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102370296298823406238/reviews');
SET @user_jelena_zekovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102370296298823406238/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Osmajic', 'https://lh3.googleusercontent.com/a/ACg8ocLlUVYVmvZVa38NLUJw1QCfId8IFpoh9OiUURv_xy98deNX6g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115225137199885100059/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115225137199885100059/reviews');
SET @user_maja_osmajic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115225137199885100059/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Loncar', 'https://lh3.googleusercontent.com/a-/ALV-UjUtc_VRwYgygrlDZ8yyb_CvvlV24SheuzkL_PkvAdl1K0W95cs=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108196858639915013910/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108196858639915013910/reviews');
SET @user_nikola_loncar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108196858639915013910/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pejović Miloš', 'https://lh3.googleusercontent.com/a-/ALV-UjVfeTzdAkbV96W-UhK0lPtFBF13JYdMfQ0enIBxJOXbPYmwoKLT=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111217562209186274815/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111217562209186274815/reviews');
SET @user_pejovi_milo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111217562209186274815/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Teodora Konatar', 'https://lh3.googleusercontent.com/a/ACg8ocItcbZZ8aPIzM2gmpvJ3RNtSHJQrXJk4QYJYQoC9Tbfp_eGdA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108405819554467634701/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108405819554467634701/reviews');
SET @user_teodora_konatar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108405819554467634701/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Petar Perovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWKdmgpgdimJANQ4nV1_lsIwF7iCKzYkgv1fzo0v3ZMY_ez5xUZ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103319944203168007035/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103319944203168007035/reviews');
SET @user_petar_perovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103319944203168007035/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja Zajovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUbfw9JKRyOPG9hebIqkdhLVufr60gA-N0QxrBfDX6R0NdkfKA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111729384512848873291/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111729384512848873291/reviews');
SET @user_sanja_zajovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111729384512848873291/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pedja Koprivica', 'https://lh3.googleusercontent.com/a/ACg8ocKtPzHjGPjE4PbD9Wn4Oap6GMPbLk-Aj8xmgmC-2u3HK4a-_g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109495331707068544818/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109495331707068544818/reviews');
SET @user_pedja_koprivica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109495331707068544818/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tamara Rudovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWZH976lDVt-nwYLlJhFB-IH4wmGUuFzrkmrHf9goZGX7rszOet=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105193319301631640035/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105193319301631640035/reviews');
SET @user_tamara_rudovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105193319301631640035/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dusko Teric', 'https://lh3.googleusercontent.com/a/ACg8ocKvGxi0_KHDDXGrozNUpGDqpcEjSJEK7I93QU3OU9_lchmdiw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100255045543157679441/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100255045543157679441/reviews');
SET @user_dusko_teric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100255045543157679441/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Iva Celebic', 'https://lh3.googleusercontent.com/a-/ALV-UjVXaf8IRWnX3OLBz95tncTJngkTKZdDmel0NEVLs11RT0MjzLGcVQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101972997082367017001/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101972997082367017001/reviews');
SET @user_iva_celebic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101972997082367017001/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Janko Gacevic', 'https://lh3.googleusercontent.com/a/ACg8ocJ-JlV6vMZ9rNST8KQ9usvTvyapRXw9T7Dk9Q1rJ3NOUh77aA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114154103040194546515/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114154103040194546515/reviews');
SET @user_janko_gacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114154103040194546515/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Grupkovic', 'https://lh3.googleusercontent.com/a/ACg8ocLx1KdhETpnQPNZhfy0T7Ug8yNVnN8YwQwFO5hiweO_hDuIWg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111511106601597603383/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111511106601597603383/reviews');
SET @user_jelena_grupkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111511106601597603383/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milenka-Seka Zizic', 'https://lh3.googleusercontent.com/a/ACg8ocK93uDAvDZ1vEwPfMFwABFTkUJpEEoZ8QtdLB9QGrZJZDYAjg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115677319423697646731/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115677319423697646731/reviews');
SET @user_milenkaseka_zizic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115677319423697646731/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ilija Andric', 'https://lh3.googleusercontent.com/a-/ALV-UjUofOn93J-l0-f2wHlUBgJwvWBYKCzmoT1iZdX43htOfSENYFTICA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111661509694479006345/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111661509694479006345/reviews');
SET @user_ilija_andric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111661509694479006345/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mrdelja Čvorović', 'https://lh3.googleusercontent.com/a-/ALV-UjWWxXwBFUlUTm65IHRa--GPRn49oNQbZXmKO1RJgPlSS7NIN0KX=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108359212021581707801/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108359212021581707801/reviews');
SET @user_mrdelja_vorovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108359212021581707801/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandar Vujacic', 'https://lh3.googleusercontent.com/a/ACg8ocI-kLEwpfDbDDdveGmob83UoWTMxGSs27UPJ-rKmnRHiSZIOg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112316518919587474173/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112316518919587474173/reviews');
SET @user_aleksandar_vujacic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112316518919587474173/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Soldatovic', 'https://lh3.googleusercontent.com/a/ACg8ocIL9yHsUN0wMdQJve4us9AR3Mqf2SJ3dWvzs5JcjYtp-zynTw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107707827718561930406/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107707827718561930406/reviews');
SET @user_jovana_soldatovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107707827718561930406/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tanja Nikolic', 'https://lh3.googleusercontent.com/a/ACg8ocKGzDpXVJ7FAVYfEDazRh7AGEBvWu5oXZUSzxxmevfag3xdGg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115051183711291048005/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115051183711291048005/reviews');
SET @user_tanja_nikolic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115051183711291048005/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vanja Bojanovic', 'https://lh3.googleusercontent.com/a/ACg8ocJNRXjd2PYi4V_1YOIzLREGWAkeJtxnn29IyRZAqkAAT2jyyA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115391887632904985136/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115391887632904985136/reviews');
SET @user_vanja_bojanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115391887632904985136/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dijana Mickovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUuYcJx8e7BiFEzrMsMGz4vrTbzOwqeTQ08uUi-mSV1P1CwTIGY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118161003456357559314/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118161003456357559314/reviews');
SET @user_dijana_mickovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118161003456357559314/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Uvis', 'https://lh3.googleusercontent.com/a-/ALV-UjUf5bWQPVCe6MbDHnmVDm2iezOgacuIwL-35NSjipjZcCGopA38tw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108722706938547001324/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108722706938547001324/reviews');
SET @user_uvis = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108722706938547001324/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ercan adıyaman', 'https://lh3.googleusercontent.com/a-/ALV-UjUXb-utiwlPIRzoB5AAGh-OVNycU_tzvHYTM-ikC3X3SXIAaOELwQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113167015452505357455/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113167015452505357455/reviews');
SET @user_ercan_adyaman = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113167015452505357455/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Draganic', 'https://lh3.googleusercontent.com/a/ACg8ocLPxzkkmq3MUKJ9zmtszw02YjtEwMdSuzdXN8E8AfmK9qZHkg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116788779528152080109/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116788779528152080109/reviews');
SET @user_ivana_draganic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116788779528152080109/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Tadic', 'https://lh3.googleusercontent.com/a/ACg8ocJ9z5XIDklPSB8Dv0yEVzLIsLJS-YpHOWSGV6N61o3aihx9EA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110197162323568734916/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110197162323568734916/reviews');
SET @user_nikola_tadic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110197162323568734916/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tanja Brady', 'https://lh3.googleusercontent.com/a-/ALV-UjXhy882LCHBYa9Vil0r_xrru0Nqb6IRVZzrr0bUD6kQmnxIXVuT=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114146092033800236055/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114146092033800236055/reviews');
SET @user_tanja_brady = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114146092033800236055/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kostic Vojin', 'https://lh3.googleusercontent.com/a/ACg8ocJxpT9jG_GZKgrbF5IhXN21zvvP6wNfZ_Rkd1w3s8_xM85oyQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102872156187490681306/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102872156187490681306/reviews');
SET @user_kostic_vojin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102872156187490681306/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Katarina Bulatovic', 'https://lh3.googleusercontent.com/a/ACg8ocKR7y1_Hp0vfdFlmPaK1TiV3WcDPRPCBcASO81mzl8VA9wnrQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113063481698221197477/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113063481698221197477/reviews');
SET @user_katarina_bulatovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113063481698221197477/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Biljana Damjanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWm4KuIX8D-y311w3IkzuZGPANl6g64qAf1xA2VpiUc9okHNW5y=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106231481892997197892/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106231481892997197892/reviews');
SET @user_biljana_damjanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106231481892997197892/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Janjić', 'https://lh3.googleusercontent.com/a-/ALV-UjX4tStcxP_VwJNedNtMguC3XVv9Uc6aVF9aXjCsXexqmYIuudIu=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114156286325678207407/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114156286325678207407/reviews');
SET @user_nikola_janji = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114156286325678207407/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Filip Jokic', 'https://lh3.googleusercontent.com/a-/ALV-UjXcToxV-g1a-_gD_t0WiAJn8vhho_oatgu515o2rCYxLpEtq816=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110070782702834225287/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110070782702834225287/reviews');
SET @user_filip_jokic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110070782702834225287/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Žarko D', 'https://lh3.googleusercontent.com/a/ACg8ocIcpimTL4qoFnwIIW5kTj9hm74RDRbKNFxIJcqzjWUwsVClCQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104609710264068786839/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104609710264068786839/reviews');
SET @user_arko_d = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104609710264068786839/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Predrag Calic', 'https://lh3.googleusercontent.com/a-/ALV-UjUEF7B442OpLrugM0KC2Tq9i8iNhZjbr02LU9ryDAas8LMyuajd=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112418157522722734655/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112418157522722734655/reviews');
SET @user_predrag_calic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112418157522722734655/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_marija_radulovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tVMFdGRmhZMDlIV25acmQxVXdURXhyU2tWcWJGRRAB',
    5, 'sr', 'Предобро искуство. Сви су веома љубазни. Све похвале доктору Велимиру❤️',
    'Predobro iskustvo. Svi su veoma ljubazni. Sve pohvale doktoru Velimiru❤️', 'Предобро искуство. Сви су веома љубазни. Све похвале доктору Велимиру❤️', NULL, NULL, NULL, NULL,
    0, '2026-03-13 16:01:13'),

(@user_tamara, @clinic_id, @doctor_zilha_kojcin, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChdDSUhNMG9nS0VJQ0FnSUROejYzOHBnRRAB',
    5, 'hr', 'Ovo je jedan sjajan tim mladih ljudi koji rade svoj posao sa svrhom!
Iskreno, bila sam skeptična: prvo, jer su jako mladi a drugo, nisam navikla da neko u našem gradu zaista radi svoj posao! Ali SVAKA ČAST cijelom timu!
Predivni, preljubazni i profesionalni!
Svi imaju sjajnu energiju ali Vojo i Zilha su priča za sebe!
Hvala vam puno i svaka preporuka!',
    'Ovo je sjajan tim mladih ljudi koji svoj posao rade sa svrhom!
Iskreno, bio sam skeptičan: prvo, zato što su veoma mladi, a drugo, nisam navikao da neko u našem gradu zaista radi svoj posao! Ali SVAKA ČAST celom timu!
Divno, veoma ljubazno i profesionalno!
Svi imaju veliku energiju ali Vojo i Zilha su priča za sebe!
Hvala vam puno i svaka preporuka!', 'Ово је сјајан тим младих људи који свој посао раде са сврхом!
Искрено, био сам скептичан: прво, зато што су веома млади, а друго, нисам навикао да неко у нашем граду заиста ради свој посао! Али СВАКА ЧАСТ целом тиму!
Дивно, веома љубазно и професионално!
Сви имају велику енергију али Војо и Зилха су прича за себе!
Хвала вам пуно и свака препорука!', NULL, NULL, NULL, NULL,
    0, '2024-01-27 09:16:28'),

(@user_p_musikic, @clinic_id, @doctor_predrag_calic, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GbFFrWlZlbDgwZEdsa1JGUkJiVzlaVDNCWVZrRRAB',
    5, 'bs', 'Strogo profesionalno osoblje, jako ljubazno i izuzetno strucno. Vrlo posveceni pacijentu, odlicna grupa mladih ljudi koja se do kraja trudi da ucini sve da se opet osjecate kao prije. Zbog slozenosti problema, zarad najboljih rezultata, Fizio Centar mi je na kraju dao 3 extra tretmana i terapije, besplatno :) hvala Predragu Calicu :)',
    'Strogo profesionalno osoblje, veoma ljubazno i izuzetno profesionalno. Veoma posvećeni pacijentu, sjajna grupa mladih ljudi koji daju sve od sebe da se osećate kao i ranije. Zbog složenosti problema, zarad najboljih rezultata, Fizio centar mi je na kraju poklonio 3 dodatna tretmana i terapije, besplatno :) hvala Predrag Čalić :)', 'Строго професионално особље, веома љубазно и изузетно професионално. Веома посвећени пацијенту, сјајна група младих људи који дају све од себе да се осећате као и раније. Због сложености проблема, зарад најбољих резултата, Физио центар ми је на крају поклонио 3 додатна третмана и терапије, бесплатно :) хвала Предраг Чалић :)', NULL, NULL, NULL, NULL,
    0, '2025-07-18 13:54:46'),

(@user_ana, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT25weU0zRmZaREJsWjNObFVWcHNRelJFUm1oQ0xYYxAB',
    5, 'hr', 'Već nakon kratkog vremena primijetila sam značajan napredak.
Ekipa je sjajna - stručni, ljubazni i maksimalno posvećeni.
Oporavak ne mora biti borba kad imaš prave ljude uz sebe, zato od srca preporučujem Fiziocentar. 🍀',
    'Posle kratkog vremena primetio sam značajan napredak. Tim je odličan - profesionalan, ljubazan i izuzetno posvećen. Oporavak ne mora biti borba kada imate prave ljude pored sebe, zbog čega od sveg srca preporučujem Fiziocentar. 🍀', 'После кратког времена приметио сам значајан напредак. Тим је одличан - професионалан, љубазан и изузетно посвећен. Опоравак не мора бити борба када имате праве људе поред себе, због чега од свег срца препоручујем Физиоцентар. 🍀', NULL, NULL, NULL, NULL,
    0, '2025-07-28 15:51:58'),

(@user_sandra_ivanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChdDSUhNMG9nS0VJQ0FnTURJdmF5OWdBRRAB',
    5, 'bs', 'Prijatno mjesto, utisak kao da ste u nekoj uglednoj inostranoj klinici. Pristup profesionalan. Odusevljenje u svakom smislu.

Skoro deset godina osjecam pritisak u koljenima, nesigurnost da potrcim, povremeno klecanje i pritom pad, nakon nekoliko tretmana u Fizio centru sam prvi put nakon toliko godina potrcala bez bola i sigurno. Osjecaj je nevjerovatan, tek ocekujem napredak nakon zavrsetka terapije. Nijesam vjerovala da napokon ne osjecam u koljenima tezinu i blokadu u pokretima.',
    'Prijatno mesto, utisak je kao da ste u renomiranoj stranoj klinici. Profesionalni pristup. Entuzijazam u svakom smislu.

Skoro deset godina osećam pritisak u kolenima, nesigurnost da trčim, povremeno klečanje i padanje, posle nekoliko tretmana u Fizio centru sam prvi put posle toliko godina trčala bez bolova i bezbedno. Osećaj je neverovatan, samo čekam napredak nakon završetka terapije. Nisam verovala da konačno ne osećam težinu u kolenima i blokadu u pokretima.', 'Пријатно место, утисак је као да сте у реномираној страној клиници. Професионални приступ. Ентузијазам у сваком смислу.

Скоро десет година осећам притисак у коленима, несигурност да трчим, повремено клечање и падање, после неколико третмана у Физио центру сам први пут после толико година трчала без болова и безбедно. Осећај је невероватан, само чекам напредак након завршетка терапије. Нисам веровала да коначно не осећам тежину у коленима и блокаду у покретима.', NULL, NULL, NULL, NULL,
    0, '2025-04-27 22:17:09'),

(@user_jelena, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT25CdVYySm9lbmx4TVhsQlJFSkZPV1JvVVVjd01HYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_bojan_vuceljic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT205TFlVeDBXbFpUWmpRMlRVOTBha2RZZG04NFgyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_dusanka_lojpur, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pOamVVVk9SbVJ0YVVkM1YyWTJia293WWxCM1VHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_darka_vukovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT210ZlNsVkJja3hPVkVoR2EzSkNabnAxUVRKNFRHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_jelena_kovacevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xOMWVrZElhVVJ6VjFGVVlYVjBOVjkyUkZWMmVrRRAB',
    5, 'hr', 'Bez premca',
    'Bez premca', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_ivana_djukanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGMGRWVjRWRUkwUmsxRFN6SnZhWHB5VVdaSWEzYxAB',
    5, 'hr', 'Sjajan tim! Sve pohvale.😊',
    'Sjajan tim! Sve pohvale.😊', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_marko_bejat, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tGTFpWWlFZWGx5TTJGNFNHaHVURUY1YW1OcmIzYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_mira_koprivica, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tSMk4xWklZWHAxYTJ3NE9XaFpUbTlrV0RFM1pFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_jelena_zekovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s4dFkycDBTMkZzTUVwV1JHeEVjSFZGYUVZMlptYxAB',
    5, 'hr', 'Profesionalni, ljubaznost za 10, divni ...',
    'Profesionalni, ljubaznost za 10, divni ...', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_maja_osmajic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WYVZYQkNUekEwWVZJeWIwZHRNVEZ1TFhSdldWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_nikola_loncar, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2taVWNpMXlZbGN3TWxKWVkxUmtUbVZoV21wMk1XYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_pejovi_milo, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pOS2NERnBabVZQWjNoTmRtWkZla0YzYVhCaWIwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_teodora_konatar, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT201aU9FOXROMEZuVURkUWJsZDVjalpRTFZGcmEzYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_petar_perovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT21Oak1tNVFOSHBTVWpjMk1IbDBhR0ZhYlhabFNGRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_sanja_zajovic, @clinic_id, @doctor_zilha_kojcin, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT25aclN6UklVVUZIUkdodlowTnVTV2czWXpKMlExRRAB',
    5, 'hr', 'Sjajan tim. Svi su baš ljubazni i stručni.
Zilhi posebno hvala, pomogla mi je puno 🩷🩷🩷🩷',
    'Sjajan tim. Svi su baš ljubazni i stručni.
Zilhi posebno hvala, pomogla mi je puno 🩷🩷🩷🩷', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_pedja_koprivica, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tjNVRtWnRkalJoWVV4U1JXVmlOV2hmU0U0dFgxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_tamara_rudovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCRk4yTjJSWHBLY1V0amIyOHpXbVIzVjNkWVpXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dusko_teric, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/Ci9DQUlRQUNvZENodHljRjlvT21WSVIzTTBNMWhLVWtFMWNVdHdiazV0T1U0dFpsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_iva_celebic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChZDSUhNMG9nS0VJQ0FnTURnaTVYaUJ3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_janko_gacevic, @clinic_id, @doctor_zilha_kojcin, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChdDSUhNMG9nS0VJQ0FnTUNBZ0xTczNBRRAB',
    5, 'bs', 'Divno osoblje, veoma ljubazni i profesionalni, preporucio bih svakom ko ima bolove u zglobovima, ledjima ili bilo kakvu potrebu za fizickom terapijom. Pozdrav za Zilhu <3',
    'Divno osoblje, veoma ljubazni i profesionalni, preporucio bih svakom ko ima bolove u zglobovima, ledjima ili bilo kakvu potrebu za fizickom terapijom. Pozdrav za Zilhu <3', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jelena_grupkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChZDSUhNMG9nS0VJQ0FnSUR2MnBTVEh3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_milenkaseka_zizic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChZDSUhNMG9nS0VJQ0FnSUNQemZTRUJREAE',
    5, 'bs', 'Jako strucna i posvecena ekipa svakom pacijentu.
Najbolji Centar  za fizikalnu terapiju u Crnoj Gori!',
    'Jako strucna i posvecena ekipa svakom pacijentu.
Najbolji Centar  za fizikalnu terapiju u Crnoj Gori!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ilija_andric, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChdDSUhNMG9nS0VJQ0FnSUMzdy0tY3BRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_mrdelja_vorovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChdDSUhNMG9nS0VJQ0FnSURYeEpiQ3JBRRAB',
    5, 'hr', 'Najbolji! 🦾',
    'Najbolji! 🦾', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_aleksandar_vujacic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChdDSUhNMG9nS0VJQ0FnSUNYMm9YMjNRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_jovana_soldatovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChZDSUhNMG9nS0VJQ0FnSURudEpTaE5REAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_tanja_nikolic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChdDSUhNMG9nS0VJQ0FnSURuMUthdzd3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_vanja_bojanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChdDSUhNMG9nS0VJQ0FnSUNueklmQ3R3RRAB',
    5, 'hr', 'Stručni, posvećeni i ljubazni! Sve pohvale za ovaj tim ❤️',
    'Stručni, posvećeni i ljubazni! Sve pohvale za ovaj tim ❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_dijana_mickovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChdDSUhNMG9nS0VJQ0FnSUNuakwyenRBRRAB',
    5, 'bs', 'Sve je odlično 🥰🥰🥰',
    'Sve je odlično 🥰🥰🥰', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_uvis, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChZDSUhNMG9nS0VJQ0FnSURIMzRLSFNnEAE',
    5, 'en', 'The staff members here are exceptionally helpful and friendly. Thank you a lot!',
    NULL, NULL, 'The staff members here are exceptionally helpful and friendly. Thank you a lot!', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_ercan_adyaman, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChdDSUhNMG9nS0VJQ0FnSURIczVxT2l3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_ivana_draganic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChdDSUhNMG9nS0VJQ0FnSURIZzZHdHlnRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_nikola_tadic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChdDSUhNMG9nS0VJQ0FnSUNINy1PcjhnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_tanja_brady, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChZDSUhNMG9nS0VJQ0FnSUNIOTdERWF3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_kostic_vojin, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ3cDVyRU1nEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_katarina_bulatovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ3cDh5Qzd3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_biljana_damjanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ3eDhPOGlnRRAB',
    5, 'hr', 'Najbolji🧡',
    'Najbolji🧡', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_nikola_janji, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ3eDhPY3pBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_filip_jokic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ3aTV2RUR3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_arko_d, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ3c19ieXRBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_predrag_calic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ3xVS22pTRMRqiUQtvA-Pf0/reviews/ChZDSUhNMG9nS0VJQ0FnSURicUpDZlN3EAE',
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
