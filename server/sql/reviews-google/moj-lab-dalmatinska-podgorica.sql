-- Insert Google Maps reviews for Moj Lab (Podgorica 1)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/moj-lab-dalmatinska-podgorica.sql

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = 5;
SET @doctor_divanovic = 132;
SET @doctor_damjanov = 135;
SET @doctor_sanja_cejovic = 171;
SET @doctor_bojana_mijatovic = 176;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radoncic', 'https://lh3.googleusercontent.com/a/ACg8ocLbZXa18HTm9LRH-f91tcjSoixBgFKe62O1hqmJ2BKHa7a5zA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113219148088054410905/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113219148088054410905/reviews');
SET @user_radoncic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113219148088054410905/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Valentina Sekulovic', 'https://lh3.googleusercontent.com/a/ACg8ocJ9-SRlgEo0g3Xlk_pKK1p6PtwEgMCUeM7vs3WDHBKHoJMq-A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107497837572277520325/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107497837572277520325/reviews');
SET @user_valentina_sekulovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107497837572277520325/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Stefanovic', 'https://lh3.googleusercontent.com/a/ACg8ocL8Cyg3T1TcCUnE63Trt70pLnfNzTJC-40rwy4AQwVDf2pnUg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112130570749030240483/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112130570749030240483/reviews');
SET @user_ivana_stefanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112130570749030240483/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana', 'https://lh3.googleusercontent.com/a/ACg8ocJ5kkQNYqo21CnGlLGLJd6a8K_MX6-bhrjQSqjW-bT0S958cw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108892576022784122798/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108892576022784122798/reviews');
SET @user_ana = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108892576022784122798/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Slaven Radunovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWisINuCpmQrZw13oHx7gX5OkHHKyzEylo5UExwWtxSWsk6wfhj=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117403791070052214162/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117403791070052214162/reviews');
SET @user_slaven_radunovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117403791070052214162/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bogdan Markuš', 'https://lh3.googleusercontent.com/a/ACg8ocILoN6BhOFBLzA_LEOtECLWsxjeqN7Vu-SqaY233ILZkVRrdQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108217656482785416303/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108217656482785416303/reviews');
SET @user_bogdan_marku = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108217656482785416303/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Emi Basic', 'https://lh3.googleusercontent.com/a-/ALV-UjXPIze4uoCDnUFJjNwtNVf7w6l63YH4EHw6LsFsQ5yf2bpX7pML=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/108770424617293420591/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108770424617293420591/reviews');
SET @user_emi_basic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108770424617293420591/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ratko miljanic', 'https://lh3.googleusercontent.com/a-/ALV-UjV0NRctsLRP6-oowxag52YYnhIoQ41jtiIR734y1ip4GsYfJsiH=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101374462602449426078/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101374462602449426078/reviews');
SET @user_ratko_miljanic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101374462602449426078/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Djina Lopicic', 'https://lh3.googleusercontent.com/a/ACg8ocIecUiQ_-6vqd3JpLTo8Y8Pz2FOtkfG_9tpwnXPs4s2HaB3toY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102193124245075314845/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102193124245075314845/reviews');
SET @user_djina_lopicic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102193124245075314845/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljubomir Maras', 'https://lh3.googleusercontent.com/a/ACg8ocIvdzrk0f-f5d7liW-gDQ7xLF5mErBUexOHRS1Lcj7BDVa_Xg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110095169904764161579/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110095169904764161579/reviews');
SET @user_ljubomir_maras = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110095169904764161579/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Spirited', 'https://lh3.googleusercontent.com/a-/ALV-UjXnyGUpE1tMj96pVB8APWfInnKHPFoNMMjxIBa5B1C2SVdK1V4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109216922846116007422/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109216922846116007422/reviews');
SET @user_spirited = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109216922846116007422/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mileva Stamatovic', 'https://lh3.googleusercontent.com/a/ACg8ocLbYBRmdFUKclMvOpxYQZlhz3TQYA25vNQHPONroHmiyIma1g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110256183729075356320/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110256183729075356320/reviews');
SET @user_mileva_stamatovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110256183729075356320/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Markovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXfC2kCoebisuW-MW9U5QSIuWx1xxE8Irflg_REdLYbLGSpyN8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106590493368471621300/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106590493368471621300/reviews');
SET @user_jelena_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106590493368471621300/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Егор Гаврилов', 'https://lh3.googleusercontent.com/a/ACg8ocJfxztOhFVxK7Ql9zos_A5ZUzh0WZGtIwt9NAknJmzt-sEpMQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112883184766891406357/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112883184766891406357/reviews');
SET @user_egor_gavrilov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112883184766891406357/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Web Radnik', 'https://lh3.googleusercontent.com/a/ACg8ocLjkn-Rb3YU8_o4mRfchoPGFGMKyqpAx1EVUzPCDrtC47_KUg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111408419122826349085/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111408419122826349085/reviews');
SET @user_web_radnik = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111408419122826349085/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Татьяна Кондратьева', 'https://lh3.googleusercontent.com/a-/ALV-UjVHi5pw_4tNmpZeQ9OtmSzu1QoG07sqeuAa9z_kKDU2t7mPfLLH=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112448506616660017539/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112448506616660017539/reviews');
SET @user_tatyana_kondrateva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112448506616660017539/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Андрей Дружков', 'https://lh3.googleusercontent.com/a/ACg8ocL2oV8ytFb-sMFsPgud7ioQHOVHjtunAnkjlsY8U57suovxUQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109457723040204378348/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109457723040204378348/reviews');
SET @user_andrey_druzhkov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109457723040204378348/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Egor Gavrilov', 'https://lh3.googleusercontent.com/a/ACg8ocJQr2AL4yxQIVpnAoZx5wzPsC7k6mTz1QNku6oq-qKlNYzyCQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111583615922097741544/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111583615922097741544/reviews');
SET @user_egor_gavrilov_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111583615922097741544/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olga Belkina', 'https://lh3.googleusercontent.com/a/ACg8ocKO0szytpzcac-y4wo-x-Xa7ThwutK1Zh_8yvpJxnlh4BwZwQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103247021168508682525/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103247021168508682525/reviews');
SET @user_olga_belkina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103247021168508682525/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mateo Kristijan Gilardi', 'https://lh3.googleusercontent.com/a-/ALV-UjW-yrFvQbrWNdgjHXGgEcw4G48YZi9irelkHIx-cwpwctFxvP-p=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/102536343912639694939/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102536343912639694939/reviews');
SET @user_mateo_kristijan_gilardi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102536343912639694939/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Emina Idrizović', 'https://lh3.googleusercontent.com/a/ACg8ocLoPH6k8P4y1pzm3tx1SbR-1G7htctWLlVQRJvBGRo1JJbnRg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111429577396662913738/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111429577396662913738/reviews');
SET @user_emina_idrizovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111429577396662913738/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Galević', 'https://lh3.googleusercontent.com/a/ACg8ocIFLDkLJIpuFeYbToENLMNxuKG-poFjp_UKJF21YasMgGWPJw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111886651181148480460/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111886651181148480460/reviews');
SET @user_dragana_galevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111886651181148480460/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'dragic vujisic', 'https://lh3.googleusercontent.com/a-/ALV-UjUJK7gxOdX7sLWSaZeE_Ym4_ECtkf57LV4RI7DC9nSHaxXn7zQwbw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114792661079046487935/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114792661079046487935/reviews');
SET @user_dragic_vujisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114792661079046487935/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Balkanka', 'https://lh3.googleusercontent.com/a-/ALV-UjUpXreBfMx4xoPqAQMdWRZoWhg4gL3UnsLUEV0Y7vTY0GodNao=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115987414945307477499/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115987414945307477499/reviews');
SET @user_balkanka = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115987414945307477499/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Florencia Calafat', 'https://lh3.googleusercontent.com/a-/ALV-UjX-0ZRVoZBnHTtHP2p1LbHd6GqfZ0mCKRIqZZsTtpqjH0-8zc-87A=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/114996239129143184092/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114996239129143184092/reviews');
SET @user_florencia_calafat = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114996239129143184092/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'KK KK', 'https://lh3.googleusercontent.com/a/ACg8ocLNlcNEiQgIifU23Y85hZiJhmfXQDbL6hs0Id3uOmg5xy6aSQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114878655185492096159/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114878655185492096159/reviews');
SET @user_kk_kk = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114878655185492096159/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Curovic', 'https://lh3.googleusercontent.com/a/ACg8ocIP_DCPg2QsGxXXSA4yOwlXiXFGiSbOfLB4x7F6NZ0UqVPUDQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104279081160180464191/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104279081160180464191/reviews');
SET @user_milica_curovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104279081160180464191/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Vojinović', 'https://lh3.googleusercontent.com/a-/ALV-UjUr7OaicoPqsv3laag4ol6wyYNTRVaXAZ9YuRNwrnTx49LP_mSIZg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109131359970302187576/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109131359970302187576/reviews');
SET @user_milica_vojinovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109131359970302187576/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'jovana vucenovic', 'https://lh3.googleusercontent.com/a/ACg8ocL-yF5Zgt1H3WFf_w3LnSGYfE-HPKcSynoVEW_l4OH8yQ2Xcw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105545773291793772779/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105545773291793772779/reviews');
SET @user_jovana_vucenovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105545773291793772779/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'LeXa', 'https://lh3.googleusercontent.com/a-/ALV-UjVO-Mx7D1RLxzSzc4ao05y683Vj_juX-bpCuwMjdwSMoVvFgkMN=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/101701476975703428090/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101701476975703428090/reviews');
SET @user_lexa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101701476975703428090/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Masa Ilincic', 'https://lh3.googleusercontent.com/a/ACg8ocJMMdAHvlXvhxdWHJKvkafH5pk3QiULNu5aqFEgEKUmYXmqYw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117768764585594943467/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117768764585594943467/reviews');
SET @user_masa_ilincic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117768764585594943467/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pro MN', 'https://lh3.googleusercontent.com/a-/ALV-UjXXOcXGp7fmPs5YVcu21P0uhXe1YNIDwotlpn4WzosXnIFNYkpJpw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111453424614940638510/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111453424614940638510/reviews');
SET @user_pro_mn = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111453424614940638510/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Irina Micunovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUZixes_3ijqvdjZe58r_0PCEEYP0shTnb613_ux4kTqO7BS_XC=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109529767202601199880/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109529767202601199880/reviews');
SET @user_irina_micunovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109529767202601199880/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sandra Resetar', 'https://lh3.googleusercontent.com/a/ACg8ocK0cpJngc72I86uFllhZW_Gab4agtE9MInrZ-BQzc_3VCco_30=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104824472760061585312/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104824472760061585312/reviews');
SET @user_sandra_resetar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104824472760061585312/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rados Pesic', 'https://lh3.googleusercontent.com/a/ACg8ocJsaZtFlM4vr2bzTd0Sw8FX4IZof6Tm0L6gPQYQY0YUgUPgLQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108552373252939698423/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108552373252939698423/reviews');
SET @user_rados_pesic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108552373252939698423/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mark Leach', 'https://lh3.googleusercontent.com/a/ACg8ocJHiuzXqcz0vLcHqp7WXjFTTs9fPSfmjwoovzLoQjolnFSf5g=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/103069979835118827865/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103069979835118827865/reviews');
SET @user_mark_leach = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103069979835118827865/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danilo Vukovic', 'https://lh3.googleusercontent.com/a-/ALV-UjU9m5t_31OfBhOZgy8VkuWs6WkhmlQJOcK91Z4cC751uokyrg5t=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110133678841451135044/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110133678841451135044/reviews');
SET @user_danilo_vukovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110133678841451135044/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mia Wallace', 'https://lh3.googleusercontent.com/a/ACg8ocJ-Z74UFCWzu-B_SOws_7mf8Z-FlTO81w8sZuT5jzDTO9oDdg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118041282354207774845/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118041282354207774845/reviews');
SET @user_mia_wallace = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118041282354207774845/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mira Popovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVS8yywvynUHFwglqjq0cQ6RduqsQ7tMk_ZN6agnrQDYkbxHLJb4Q=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/117005060993082731554/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117005060993082731554/reviews');
SET @user_mira_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117005060993082731554/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Balsa Radunovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWx_zHTKnFJFnFgIvBsQPr_t4Zft72OcobNu-GEX4NgCW4R8uA=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/112060999872158269957/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112060999872158269957/reviews');
SET @user_balsa_radunovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112060999872158269957/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mix1 em', 'https://lh3.googleusercontent.com/a/ACg8ocLAD88RchmQwp29TNR1ltNu9MnIR_x3tkfsZosQnb9hX4_Gsg=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/113049575727413388912/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113049575727413388912/reviews');
SET @user_mix1_em = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113049575727413388912/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lado Radman', 'https://lh3.googleusercontent.com/a/ACg8ocLOQ8yAKTZaQ705NPI94qRnaKhyk4paPQYU9ERnc11Oo1eStQ=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/110049347599602588639/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110049347599602588639/reviews');
SET @user_lado_radman = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110049347599602588639/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Gys Naude', 'https://lh3.googleusercontent.com/a-/ALV-UjUP-mZOFmC1ZBgCi8ZmcHqvsNKLeOFUIZL42KoKfSlFBSiFPAI=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112482055866039507099/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112482055866039507099/reviews');
SET @user_gys_naude = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112482055866039507099/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kat Christofer', 'https://lh3.googleusercontent.com/a-/ALV-UjUzATM4uhaA4FgK8lmKrO6BIY-LRg1bbToKPHd4vo69IfkjgaJPfQ=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/103667906166677823708/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103667906166677823708/reviews');
SET @user_kat_christofer = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103667906166677823708/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'OLJA LAKONIC', 'https://lh3.googleusercontent.com/a/ACg8ocJ51O9wuOv3_HqHeos4oOLAubdJPpnnR5JpsjK6hNfvnhzM2w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102726352436952611431/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102726352436952611431/reviews');
SET @user_olja_lakonic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102726352436952611431/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Len Brown', 'https://lh3.googleusercontent.com/a-/ALV-UjV71Lxp-7o0zuYVNUei8uLWkrG7Z6oGTnGWY9yWSR8ZkMHa1cPSkg=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/113433968037235034232/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113433968037235034232/reviews');
SET @user_len_brown = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113433968037235034232/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Zujovic', 'https://lh3.googleusercontent.com/a/ACg8ocJ07pRLMp4draxDzCyRTtgH-Tk09F25RFru-4QBEIQyF4JjvQ=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/100216119498209431375/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100216119498209431375/reviews');
SET @user_jovana_zujovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100216119498209431375/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_radoncic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSNE0wdDNZMkUwT0Rkc0xYUnRXbU56Y2xaNFdFRRAB',
    5, 'hr', 'Bio sam u Moj Labu kod dr Nataše Đuričanin. Sve je prošlo kako treba. Doktorka je bila korektna, objasnila šta treba i bila je ljubazna. Zadovoljan sam, preporuka.',
    'Bio sam u Moj Labu kod dr Nataše Đuričanin. Sve je prošlo kako treba. Doktorka je bila korektna, objasnila šta treba i bila je ljubazna. Zadovoljan sam, preporuka.', 'Био сам у Мој Лабу код др Наташе Ђуричанин. Све је прошло како треба. Докторка је била коректна, објаснила шта треба и била је љубазна. Задовољан сам, препорука.', 'I was at Moj Lab with Dr. Nataša Đuričanin. Everything went as it should. The doctor was correct, explained what was needed, and was kind. I am satisfied, I recommend.', 'Я был в Moj Lab у д-р Наташи Ђуричанин. Всё прошло как надо. Докторша была корректна, объяснила что нужно и была любезна. Доволен, рекомендую.', 'Ich war im Moj Lab bei Dr. Nataša Đuričanin. Alles verlief wie es sein sollte. Die Ärztin war korrekt, erklärte was nötig war und war freundlich. Ich bin zufrieden, Empfehlung.', 'Moj Lab\'da Dr. Nataša Đuričanin ile görüştüm. Her şey gerektiği gibi geçti. Doktor düzgündü, ne yapılması gerektiğini açıkladı ve kibardı. Memnunum, tavsiye ederim.',
    0, NULL),

(@user_valentina_sekulovic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psTmFVTjNTbXBqTW04NVJVdDJhM1E0UVRNd05GRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-22 00:00:00'),

(@user_ivana_stefanovic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xOdWJrWXpWRFo1YjFBdFQyOXZSRFpDTFRSdGNrRRAB',
    5, 'bs', 'Vrlo pozitivno iskustvo kod dr Nataše. Tokom pregleda primjećuju se strpljenje i pristupačnost. Terapija je pogođena i brzo je dala dobre rezultate. Pohvala i za ljubazno osoblje i brzo zakazivanje termina. Sve je proteklo vrlo profesionalno i bez čekanja.',
    'Vrlo pozitivno iskustvo kod dr Nataše. Tokom pregleda primjećuju se strpljenje i pristupačnost. Terapija je pogođena i brzo je dala dobre rezultate. Pohvala i za ljubazno osoblje i brzo zakazivanje termina. Sve je proteklo vrlo profesionalno i bez čekanja.', 'Врло позитивно искуство код др Наташе. Током прегледа примећују се стрпљење и приступачност. Терапија је погођена и брзо је дала добре резултате. Похвала и за љубазно особље и брзо заказивање термина. Све је протекло врло професионално и без чекања.', 'Very positive experience with Dr. Nataša. During the examination, patience and approachability are noticeable. The therapy was spot on and quickly gave good results. Kudos also to the friendly staff and fast appointment scheduling. Everything proceeded very professionally and without waiting.', 'Очень положительный опыт у д-р Наташи. Во время осмотра заметны терпение и открытость. Терапия была подобрана точно и быстро дала хорошие результаты. Похвала и за любезный персонал и быстрое назначение. Всё прошло очень профессионально и без ожидания.', 'Sehr positive Erfahrung bei Dr. Nataša. Während der Untersuchung sind Geduld und Zugänglichkeit erkennbar. Die Therapie war treffend und gab schnell gute Ergebnisse. Lob auch für das freundliche Personal und die schnelle Terminvergabe. Alles verlief sehr professionell und ohne Wartezeit.', 'Dr. Nataša ile çok olumlu bir deneyim. Muayene sırasında sabır ve erişilebilirlik dikkat çekiyor. Tedavi yerinde belirlendi ve hızla iyi sonuçlar verdi. Nazik personel ve hızlı randevu için de takdirler. Her şey çok profesyonel ve bekleme olmaksızın geçti.',
    0, '2026-03-17 00:00:00'),

(@user_ana, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/Ci9DQUlRQUNvZENodHljRjlvT25BMlEweDJRM0ZRVm5CdmNXOXVTVTV2Ym5CTFNWRRAB',
    5, 'hr', 'Moj otac je bio na pregledu kod dr Nataše Vukotić Đuričanin i imao je vrlo dobro iskustvo. Doktorka je bila strpljiva, pažljivo je pregledala promjenu na koži i jasno objasnila šta je u pitanju i koje su dalje preporuke. Pristup je bio vrlo profesionalan i prijatan, što je mom ocu mnogo značilo.',
    'Moj otac je bio na pregledu kod dr Nataše Vukotić Đuričanin i imao je vrlo dobro iskustvo. Doktorka je bila strpljiva, pažljivo je pregledala promjenu na koži i jasno objasnila šta je u pitanju i koje su dalje preporuke. Pristup je bio vrlo profesionalan i prijatan, što je mom ocu mnogo značilo.', 'Мој отац је био на прегледу код др Наташе Вукотић Ђуричанин и имао је врло добро искуство. Докторка је била стрпљива, пажљиво је прегледала промену на кожи и јасно објаснила шта је у питању и које су даље препоруке. Приступ је био врло професионалан и пријатан, што је мом оцу много значило.', 'My father was examined by Dr. Nataša Vukotić Đuričanin and had a very good experience. The doctor was patient, carefully examined the skin lesion and clearly explained what the issue was and what the further recommendations are. The approach was very professional and pleasant, which meant a lot to my father.', 'Мой отец был на приёме у д-р Наташи Вукотић Ђуричанин и у него был очень хороший опыт. Докторша была терпелива, внимательно осмотрела изменение на коже и чётко объяснила в чём проблема и каковы дальнейшие рекомендации. Подход был очень профессиональным и приятным, что много значило для моего отца.', 'Mein Vater war zur Untersuchung bei Dr. Nataša Vukotić Đuričanin und hatte eine sehr gute Erfahrung. Die Ärztin war geduldig, untersuchte die Hautveränderung sorgfältig und erklärte klar, was das Problem ist und welche weiteren Empfehlungen es gibt. Der Umgang war sehr professionell und angenehm, was meinem Vater sehr viel bedeutete.', 'Babam Dr. Nataša Vukotić Đuričanin\'de muayene oldu ve çok iyi bir deneyim yaşadı. Doktor sabırlıydı, cilt değişikliğini dikkatlice inceledi ve sorunun ne olduğunu ve daha sonraki önerilerin neler olduğunu açıkça açıkladı. Yaklaşım çok profesyonel ve hoştu, bu babam için çok şey ifade etti.',
    0, '2026-03-17 00:00:00'),

(@user_slaven_radunovic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psV1ZrOTZURzFOYm1GeVgwcGFlV0puTWtSSk4wRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-02-24 00:00:00'),

(@user_bogdan_marku, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/Ci9DQUlRQUNvZENodHljRjlvT2padGRYcHhZMmhQZFdSbVUzTjRjRWN3UVRaek5sRRAB',
    1, 'bs', 'Izuzetno neprijatan i neprofesionalan odnos službenice na šalteru jutros u prvoj smjeni, u 11:30, 4.2.2026.

Dodatno, nakon što je njen kolega sugerisao da je njena greška (i to početnička), gospođa se nije ni izvinila već je u istom maniru završila svoju dužnost.',
    'Izuzetno neprijatan i neprofesionalan odnos službenice na šalteru jutros u prvoj smjeni, u 11:30, 4.2.2026.

Dodatno, nakon što je njen kolega sugerisao da je njena greška (i to početnička), gospođa se nije ni izvinila već je u istom maniru završila svoju dužnost.', 'Изузетно непријатан и непрофесионалан однос службенице на шалтеру јутрос у првој смени, у 11:30, 4.2.2026.

Додатно, након што је њен колега сугерисао да је њена грешка (и то почетничка), госпођа се није ни извинила већ је у истом маниру завршила своју дужност.', 'Extremely unpleasant and unprofessional attitude from the clerk at the counter this morning in the first shift, at 11:30, on 4.2.2026.

Additionally, after her colleague pointed out that it was her mistake (and a beginner\'s mistake at that), the lady did not even apologize but finished her duties in the same manner.', 'Крайне неприятное и непрофессиональное отношение сотрудницы на стойке сегодня утром в первую смену, в 11:30, 4.2.2026.

Вдобавок, после того как её коллега указал, что это была её ошибка (и к тому же элементарная), дама даже не извинилась и продолжила выполнять свои обязанности в том же духе.', 'Äußerst unangenehmes und unprofessionelles Verhalten der Mitarbeiterin am Schalter heute Morgen in der ersten Schicht, um 11:30 Uhr, am 4.2.2026.

Zusätzlich entschuldigte sich die Dame nicht einmal, nachdem ihr Kollege darauf hingewiesen hatte, dass es ihr Fehler war (und dazu noch ein Anfängerfehler), sondern beendete ihre Aufgabe auf dieselbe Weise.', 'Bu sabah ilk vardiyada, saat 11:30\'da, 4.2.2026\'da gişedeki görevlinin son derece hoş olmayan ve profesyonellikten uzak tutumu.

Bunun yanı sıra, meslektaşı bunun kendi hatası olduğunu (hem de başlangıç hatası) belirtmesine rağmen hanımefendi özür dilemeden görevini aynı tavırla tamamladı.',
    0, '2026-02-24 00:00:00'),

(@user_emi_basic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xOcFVIUkNORVZmWWpselZGVlRWMkp0V21sa2FVRRAB',
    5, 'bs', 'moderna aparatura i dobro osoblje. samo ako termina i cijena mora biti bolja koordinacija a ne da se sazivaju razni brojevi. mora sve biti umrezeno bolje.',
    'moderna aparatura i dobro osoblje. samo ako termina i cijena mora biti bolja koordinacija a ne da se sazivaju razni brojevi. mora sve biti umrezeno bolje.', 'Модерна апаратура и добро особље. Само ако термина и цена мора бити боља координација а не да се сазивају разни бројеви. Мора све бити умрежено боље.', 'Modern equipment and good staff. But regarding appointments and prices, there needs to be better coordination instead of calling various numbers. Everything needs to be better networked.', 'Современное оборудование и хороший персонал. Только по поводу записи и цен должна быть лучшая координация, а не обзванивать разные номера. Всё должно быть лучше связано.', 'Moderne Geräte und gutes Personal. Nur bei Terminen und Preisen muss eine bessere Koordination her, anstatt verschiedene Nummern anzurufen. Alles muss besser vernetzt sein.', 'Modern ekipman ve iyi personel. Sadece randevular ve fiyatlar konusunda çeşitli numaraları aramak yerine daha iyi koordinasyon olması gerekiyor. Her şeyin daha iyi ağa bağlı olması gerekiyor.',
    0, '2025-11-24 00:00:00'),

(@user_ratko_miljanic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/Ci9DQUlRQUNvZENodHljRjlvT21WNVJHaDZTMVJQWms1aFpWcFVWVkZxZEZnNE5WRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-24 00:00:00'),

(@user_djina_lopicic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/Ci9DQUlRQUNvZENodHljRjlvT25sUVdVRlFYM0pxYUhOWFowaDFWRFpSYVRodVVGRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-09-24 00:00:00'),

(@user_ljubomir_maras, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWVVZsSTFPVU0zUlRkWlJGTnRSWEZvWVc4MVpuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-09-24 00:00:00'),

(@user_spirited, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/Ci9DQUlRQUNvZENodHljRjlvT21KbVQyMDVkVFZhYkc1WFoxZHRZamhvZFVvNVJtYxAB',
    1, 'bs', 'Zakazan pregled mjesec dana unaprijed. Da bi mi dan pregleda javili da ta doktorica NE PRIHVATA privatno osiguranje, sa kojim oni imaju regularnu saradnju.

Ponudim da doplatim razliku (koja je inače samo 10e, osiguranju plaća 90e zbog ugovora, a ovako kada plaćate 100). Kažu da ne može, doktorica ne prihvata???

Sad ne znam dal sam ja lud ili?',
    'Zakazan pregled mjesec dana unaprijed. Da bi mi dan pregleda javili da ta doktorica NE PRIHVATA privatno osiguranje, sa kojim oni imaju regularnu saradnju.

Ponudim da doplatim razliku (koja je inače samo 10e, osiguranju plaća 90e zbog ugovora, a ovako kada plaćate 100). Kažu da ne može, doktorica ne prihvata???

Sad ne znam dal sam ja lud ili?', 'Заказан преглед месец дана унапред. Да би ми дан прегледа јавили да та докторица НЕ ПРИХВАТА приватно осигурање, са којим они имају регуларну сарадњу.

Понудим да доплатим разлику (која је иначе само 10е, осигурању плаћа 90е због уговора, а овако када плаћате 100). Кажу да не може, докторица не прихвата???

Сад не знам дал сам ја луд или?', 'Appointment scheduled a month in advance. Only to be told on the day of the appointment that the doctor DOES NOT ACCEPT private insurance, with which they have a regular cooperation.

I offered to pay the difference (which is only 10e, the insurance pays 90e due to the contract, otherwise you pay 100). They say it can\'t be done, the doctor doesn\'t accept???

Now I don\'t know if I\'m the crazy one here or what?', 'Записался на приём за месяц вперёд. И в день приёма сообщают, что эта докторша НЕ ПРИНИМАЕТ частную страховку, с которой у них регулярное сотрудничество.

Предложил доплатить разницу (которая всего 10е, страховка платит 90е по договору, а так платишь 100). Говорят — нельзя, докторша не принимает???

Теперь не знаю, я сумасшедший или как?', 'Termin einen Monat im Voraus gebucht. Nur um am Tag des Termins zu erfahren, dass die Ärztin KEINE private Krankenversicherung akzeptiert, mit der sie eine reguläre Zusammenarbeit haben.

Ich bot an, die Differenz nachzuzahlen (die übrigens nur 10e beträgt, die Versicherung zahlt 90e aufgrund des Vertrags, sonst zahlt man 100). Sie sagen, das geht nicht, die Ärztin akzeptiert das nicht???

Jetzt weiß ich nicht mehr, ob ich verrückt bin oder was?', 'Bir ay önceden randevu alındı. Muayene günü o doktorun özel sigortayı KABUL ETMEDİĞİ söylendi — oysa onların bu sigortayla düzenli bir işbirliği var.

Farkı tamamlamayı teklif ettim (fark sadece 10e, sigorta sözleşme nedeniyle 90e ödüyor, yoksa siz 100 ödüyorsunuz). Olmaz diyorlar, doktor kabul etmiyor???

Şimdi deli olan benim mi bilmiyorum?',
    0, '2025-08-24 00:00:00'),

(@user_mileva_stamatovic, @clinic_id, @doctor_damjanov, 'google_maps',
    'places/undefined/reviews/Ci9DQUlRQUNvZENodHljRjlvT201clgzVnVkbTAwZDB0YVYyVmhWR1V5VTNOcVpsRRAB',
    1, 'bs', 'Neprofesionalno ponasanje zaposlenih. Cekanje na pregled 6 mjeseci kod dr Damjanova zatim u cekaonici po zakazanom vremenu od 10 30 h ubacivanje preko reda. Pritom pregled kosta 100 e. Nepistovanje i grub pristup djetetu od 20 godina.',
    'Neprofesionalno ponasanje zaposlenih. Cekanje na pregled 6 mjeseci kod dr Damjanova zatim u cekaonici po zakazanom vremenu od 10 30 h ubacivanje preko reda. Pritom pregled kosta 100 e. Nepistovanje i grub pristup djetetu od 20 godina.', 'Непрофесионално понашање запослених. Чекање на преглед 6 месеци код др Дамјанова, затим у чекаоници по заказаном времену од 10:30 убацивање преко реда. Притом преглед кошта 100 е. Непоштовање и груб приступ детету од 20 година.', 'Unprofessional behavior of the staff. Waited 6 months for an appointment with Dr. Damjanov, then in the waiting room, despite a scheduled time of 10:30, being skipped in line. On top of that, the appointment costs 100€. Disrespect and rude treatment of a 20-year-old.', 'Непрофессиональное поведение персонала. Ждали 6 месяцев на приём к д-р Дамьянову, потом в приёмной, несмотря на назначенное время 10:30, кого-то вставили вперёд. При этом приём стоит 100е. Неуважение и грубое отношение к молодому человеку 20 лет.', 'Unprofessionelles Verhalten der Mitarbeiter. 6 Monate Wartezeit auf einen Termin bei Dr. Damjanov, dann im Wartezimmer trotz des vereinbarten Termins um 10:30 Uhr Vordrängen in der Schlange. Dazu kostet die Untersuchung 100€. Respektlosigkeit und grobe Behandlung eines 20-Jährigen.', 'Çalışanların profesyonellikten uzak davranışı. Dr. Damjanov\'a randevu için 6 ay bekleme, ardından 10:30 randevu saatine rağmen bekleme salonunda sıraya atlanması. Üstelik muayene 100€ tutuyor. 20 yaşındaki bir gence saygısızlık ve kaba davranış.',
    0, '2025-07-24 00:00:00'),

(@user_jelena_markovic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChdDSUhNMG9nS0VJQ0FnTUNZOE1xdjhnRRAB',
    1, 'bs', 'Iskreno uzas za jednu privatnu bolnicu, kao i sve u Podgorici relativno. Vi dajete novac a oni vas ne zarezuju dva posto.
Niko Vam nece naglasiti da se odjedjene dijagnostike cekaju nekoliko dana.
Na nivou 2010te godine i usluga i ponasanje napumpanih kvazi sestara.',
    'Iskreno uzas za jednu privatnu bolnicu, kao i sve u Podgorici relativno. Vi dajete novac a oni vas ne zarezuju dva posto.
Niko Vam nece naglasiti da se odjedjene dijagnostike cekaju nekoliko dana.
Na nivou 2010te godine i usluga i ponasanje napumpanih kvazi sestara.', 'Искрено, ужас за једну приватну болницу, као и све у Подгорици релативно. Ви дајете новац а они вас не заремују ни мало.
Нико Вам неће нагласити да се одређене дијагностике чекају неколико дана.
На нивоу 2010-те и услуга и понашање напумпаних квази сестара.', 'Honestly terrible for a private hospital, like everything in Podgorica relatively speaking. You pay money and they don\'t care about you at all.
No one will warn you that certain diagnostic procedures take several days.
The level of service and the attitude of the pompous quasi-nurses is stuck in 2010.', 'Честно говоря — ужас для частной больницы, как впрочем и всё в Подгорице в относительном смысле. Вы платите деньги, а они вас вообще не замечают.
Никто не предупредит, что некоторые диагностические процедуры нужно ждать несколько дней.
Уровень услуг и поведение напыщенных псевдосестёр — на уровне 2010 года.', 'Ehrlich gesagt ein Grauen für ein Privatkrankenhaus, wie alles in Podgorica relativ gesehen. Sie zahlen Geld und die kümmern sich kein bisschen um Sie.
Niemand wird Sie darauf hinweisen, dass bestimmte Diagnosen mehrere Tage Wartezeit haben.
Das Niveau des Service und das Verhalten der aufgeblasenen Quasi-Schwestern ist auf dem Stand von 2010.', 'Dürüst olmak gerekirse, bir özel hastane için korkunç — Podgorica\'daki her şey gibi nispeten. Para veriyorsunuz ama onlar sizi hiç umursamıyor.
Belirli teşhislerin birkaç gün bekleme gerektirdiğini kimse sizi uyarmayacak.
Hizmet kalitesi ve şişirilmiş sözde hemşirelerin tutumu 2010 yılı seviyesinde.',
    0, '2025-05-24 00:00:00'),

(@user_egor_gavrilov, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChdDSUhNMG9nS0VJQ0FnTUNJdHFtU3NBRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-04-24 00:00:00'),

(@user_web_radnik, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChdDSUhNMG9nS0VJQ0FnTUNJLXNmSTZ3RRAB',
    1, 'ru', 'Несмотря на отсительно высокую стоимость услуг - отношение просто как к кошельку, а не как к человеку. При этом, допускают критические ошибки даже при, как казалось бы, стандартных процедурах, из-за которых услуга так и не была оказана в итоге...',
    'Uprkos relativno visokim cenama usluga — odnos je jednostavno kao prema novčaniku, a ne prema čoveku. Pri tom, prave kritične greške čak i pri, čini se, standardnim procedurama, zbog kojih usluga na kraju nije ni pružena...', 'Упркос релативно високим ценама услуга — однос је просто као према новчанику, а не према човеку. При том, праве критичне грешке чак и при, чини се, стандардним процедурама, због којих услуга на крају није ни пружена...', 'Despite the relatively high cost of services, the attitude is simply as if you\'re just a wallet, not a human being. On top of that, they make critical mistakes even in seemingly standard procedures, due to which the service was ultimately never provided...', 'Несмотря на отсительно высокую стоимость услуг - отношение просто как к кошельку, а не как к человеку. При этом, допускают критические ошибки даже при, как казалось бы, стандартных процедурах, из-за которых услуга так и не была оказана в итоге...', 'Trotz der relativ hohen Servicekosten ist die Behandlung einfach wie bei einem Geldbeutel, nicht wie bei einem Menschen. Dazu machen sie kritische Fehler auch bei scheinbar standardmäßigen Verfahren, weshalb die Leistung am Ende gar nicht erbracht wurde...', 'Hizmetlerin nispeten yüksek maliyetine rağmen, tutum adeta bir cüzdan olarak görülüyorsunuz, insan değil. Üstelik görünüşte standart prosedürlerde bile kritik hatalar yapıyorlar, bu yüzden hizmet sonunda hiç verilmedi...',
    0, '2025-04-24 00:00:00'),

(@user_tatyana_kondrateva, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnTUNJMHBIREZBEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-04-24 00:00:00'),

(@user_andrey_druzhkov, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChdDSUhNMG9nS0VJQ0FnTUNJa3ZUM3VRRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-04-24 00:00:00'),

(@user_egor_gavrilov_2, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnTUR3eE9UVGJ3EAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_olga_belkina, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChdDSUhNMG9nS0VJQ0FnTUN3cDlXcGp3RRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_mateo_kristijan_gilardi, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnTUN3X2VISkl3EAE',
    1, 'hr', 'Jutros dovedem radnike cura mlada toliko tiha spora da sam jedva čekao da završim sa njima i htio biohemijske nalaze mora da se ide drugo mjesto jedno veliko nula minus za njih a pritom cijne i kadar ne idu zajedno',
    'Jutros dovedem radnike cura mlada toliko tiha spora da sam jedva čekao da završim sa njima i htio biohemijske nalaze mora da se ide drugo mjesto jedno veliko nula minus za njih a pritom cijne i kadar ne idu zajedno', 'Јутрос доведем раднике, цура млада толико тиха и спора да сам једва чекао да завршим са њима, и хтео биохемијске налазе, мора да се иде на друго место. Једно велико нула минус за њих, а притом цене и кадар не иду заједно.', 'This morning I brought in workers — the young girl was so quiet and slow that I could barely wait to be done with them, and I wanted biochemical results too — will have to go somewhere else. A big fat zero for them, and the prices and staff quality don\'t match.', 'Сегодня утром привёл рабочих — молодая девушка такая тихая и медленная, что я едва дождался конца, и хотел ещё биохимические анализы — придётся идти в другое место. Жирный ноль минус им, при этом цены и кадры не соответствуют.', 'Heute Morgen habe ich Arbeiter gebracht — das junge Mädchen war so ruhig und langsam, dass ich kaum warten konnte bis ich fertig war, und ich wollte auch Blutuntersuchungen machen lassen — muss woanders hingehen. Eine große Null minus für sie, und die Preise und das Personal passen nicht zusammen.', 'Bu sabah işçi getirdim — genç kız o kadar sessiz ve yavaştı ki onlarla işimi bitirmeyi zor bekledim, biyokimyasal tahlil de istedim — başka bir yere gitmek zorundayım. Onlar için büyük bir sıfır eksi, hem de fiyatlar ve personel kalitesi uyuşmuyor.',
    0, '2025-03-24 00:00:00'),

(@user_emina_idrizovi, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnSURfZ3BLTGFnEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_dragana_galevi, @clinic_id, @doctor_sanja_cejovic, 'google_maps',
    'places/undefined/reviews/ChdDSUhNMG9nS0VJQ0FnSUNfNGZDUG9nRRAB',
    5, 'sr', 'Дивно искуство са запосленима , а  овом приликом посебно истичем радиолога Др Сању Чејовић.
Професионалност, стручност и емпатија,  на узвишеном  нивоу.
Хвала вам дивна Др.Чејовић на свему.',
    'Divno iskustvo sa zaposlenima , a  ovom prilikom posebno ističem radiologa Dr Sanju Čejović.
Profesionalnost, stručnost i empatija,  na uzvišenom  nivou.
Hvala vam divna Dr.Čejović na svemu.', 'Дивно искуство са запосленима , а  овом приликом посебно истичем радиолога Др Сању Чејовић.
Професионалност, стручност и емпатија,  на узвишеном  нивоу.
Хвала вам дивна Др.Чејовић на свему.', 'A wonderful experience with the staff, and on this occasion I especially commend radiologist Dr. Sanja Čejović.
Professionalism, expertise and empathy at an elevated level.
Thank you, wonderful Dr. Čejović, for everything.', 'Замечательный опыт с сотрудниками, и по этому случаю особо отмечу радиолога др Сању Чеjовић.
Профессионализм, компетентность и эмпатия на высшем уровне.
Спасибо вам, чудесная Д-р Чеjовић, за всё.', 'Eine wunderbare Erfahrung mit dem Personal, und ich möchte besonders die Radiologin Dr. Sanja Čejović hervorheben.
Professionalität, Fachwissen und Empathie auf höchstem Niveau.
Vielen Dank, die wunderbare Dr. Čejović, für alles.', 'Personelje harika bir deneyim ve bu vesileyle radyolog Dr. Sanja Čejović\'i özellikle takdirle anmak istiyorum.
Profesyonellik, uzmanlık ve empati üst düzeyde.
Her şey için teşekkürler, harika Dr. Čejović.',
    0, '2025-03-24 00:00:00'),

(@user_dragic_vujisic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChdDSUhNMG9nS0VJQ0FnSUQzbzRDTTNRRRAB',
    5, 'hr', 'LJUBAZNI VEOMA DOBAR UTISAK SU OSTAVILI NA MENE.',
    'LJUBAZNI VEOMA DOBAR UTISAK SU OSTAVILI NA MENE.', 'ЉУБАЗНИ ВЕОМА ДОБАР УТИСАК СУ ОСТАВИЛИ НА МЕНЕ.', 'THEY WERE KIND AND LEFT A VERY GOOD IMPRESSION ON ME.', 'БЫЛИ ЛЮБЕЗНЫ И ОСТАВИЛИ НА МЕНЯ ОЧЕНЬ ХОРОШЕЕ ВПЕЧАТЛЕНИЕ.', 'SIE WAREN FREUNDLICH UND HABEN EINEN SEHR GUTEN EINDRUCK BEI MIR HINTERLASSEN.', 'NAZİKLERDİ VE BENDE ÇOK İYİ BİR İZLENİM BIRAKTILAR.',
    0, '2025-03-24 00:00:00'),

(@user_balkanka, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnSURid2RyNVh3EAE',
    1, 'hr', 'Uzasno ! Ja sam sokirana izasla i rekla ono mladoj sestri da nije to njena sramota nego glavnog sefa pred musterijama se toliko ponasao bahato da je uzas bilo',
    'Uzasno ! Ja sam sokirana izasla i rekla ono mladoj sestri da nije to njena sramota nego glavnog sefa pred musterijama se toliko ponasao bahato da je uzas bilo', 'Ужасно! Ја сам шокирана изашла и рекла оној младој сестри да није то њена срамота него главног шефа, koji се пред муштеријама толико понашао бахато да је ужас било.', 'Terrible! I left in shock and told that young nurse that it wasn\'t her fault but the head boss who behaved so arrogantly in front of customers that it was awful.', 'Ужасно! Я вышла в шоке и сказала той молодой медсестре, что это не её позор, а главного начальника, который вёл себя так высокомерно перед клиентами — просто кошмар.', 'Schrecklich! Ich bin schockiert rausgegangen und habe der jungen Schwester gesagt, dass das nicht ihre Schande ist, sondern die des Chefs, der sich vor den Kunden so arrogant verhielt, dass es ein Graus war.', 'Berbat! Şok içinde çıktım ve o genç hemşireye bunun onun utancı değil müşterilerin önünde bu kadar kibirli davranan müdürün utancı olduğunu söyledim, inanılmazdı.',
    0, '2025-03-24 00:00:00'),

(@user_florencia_calafat, @clinic_id, @doctor_bojana_mijatovic, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnSUNyc3N2b0FREAE',
    5, 'en', 'I don\'t understand why there are so many negative comments, my experience here was excellent. The ophthalmologist Bojana Mijatović was really excellent, very professional. Everyone speaks very good English so that made it easy to have a good experience. I will definitely come back.',
    'Ne razumem zašto ima toliko negativnih komentara, moje iskustvo ovde je bilo odlično. Oftalmolog Bojana Mijatović je bila zaista odlična, veoma profesionalna. Svi odlično govore engleski, što je olakšalo dobro iskustvo. Sigurno ću se vratiti.', 'Не разумем зашто има толико негативних коментара, моје искуство овде је bilo одлично. Офталмолог Бојана Мијатовић је bila заиста одлична, веома професионална. Сви одлично говоре енглески, što je olakšalo добро искуство. Сигурно ћу се вратити.', 'I don\'t understand why there are so many negative comments, my experience here was excellent. The ophthalmologist Bojana Mijatović was really excellent, very professional. Everyone speaks very good English so that made it easy to have a good experience. I will definitely come back.', 'Не понимаю, почему так много отрицательных отзывов — мой опыт здесь был отличным. Офтальмолог Бојана Мијатовић была действительно превосходна, очень профессиональна. Все отлично говорят по-английски, что сделало визит приятным. Обязательно вернусь.', 'Ich verstehe nicht, warum es so viele negative Kommentare gibt — meine Erfahrung hier war ausgezeichnet. Die Augenärztin Bojana Mijatović war wirklich hervorragend, sehr professionell. Alle sprechen sehr gut Englisch, was das Erlebnis angenehm machte. Ich werde definitiv wiederkommen.', 'Neden bu kadar çok olumsuz yorum var anlamıyorum, benim buradaki deneyimim mükemmeldi. Göz doktoru Bojana Mijatović gerçekten mükemmeldi, çok profesyoneldi. Herkes çok iyi İngilizce konuşuyor, bu da iyi bir deneyim yaşamayı kolaylaştırdı. Kesinlikle geri döneceğim.',
    0, '2025-03-24 00:00:00'),

(@user_kk_kk, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnSUM5bDlmdUhnEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_milica_curovic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnSUR0a3AzcFJBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_milica_vojinovi, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChdDSUhNMG9nS0VJQ0FnSUROc1puWTNnRRAB',
    5, 'hr', 'Ljubazno osoblje i sve se brzo zavrsava 😊 …',
    'Ljubazno osoblje i sve se brzo zavrsava 😊 …', 'Љубазно особље и све се брзо завршава 😊 …', 'Friendly staff and everything finishes quickly 😊 …', 'Любезный персонал и всё быстро заканчивается 😊 …', 'Freundliches Personal und alles geht schnell 😊 …', 'Nazik personel ve her şey hızlıca tamamlanıyor 😊 …',
    0, '2024-03-24 00:00:00'),

(@user_jovana_vucenovic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChdDSUhNMG9nS0VJQ0FnSUNWeV9HUTl3RRAB',
    1, 'bs', 'Jako lose iskustvo. Dosla sam na kliniku sa uputnom dijagnozom od istog doktora koji je radio intervenciju da bi mi na dan intervencije naplatili pregled 50€, malu intervenciju na kapku u trajanju od 15 min 180€ i poslije 7 dana kontrolni peegled opet 50€ a krajnji rezultat neuspjela intervencija koja mora da se ponovo obavlja i prepostavljam ponovo istim mehanizmom naplati.
Imam utisak da pacijente posmatraju samo kao izvor prihoda uz potpuni nedostatak ljudske i medicinske etike.Rekla bi sramno za jednu medicinsku ustanovu,cak i za privatnu.',
    'Jako lose iskustvo. Dosla sam na kliniku sa uputnom dijagnozom od istog doktora koji je radio intervenciju da bi mi na dan intervencije naplatili pregled 50€, malu intervenciju na kapku u trajanju od 15 min 180€ i poslije 7 dana kontrolni peegled opet 50€ a krajnji rezultat neuspjela intervencija koja mora da se ponovo obavlja i prepostavljam ponovo istim mehanizmom naplati.
Imam utisak da pacijente posmatraju samo kao izvor prihoda uz potpuni nedostatak ljudske i medicinske etike.Rekla bi sramno za jednu medicinsku ustanovu,cak i za privatnu.', 'Јако лоше искуство. Дошла сам на клинику са упутном дијагнозом од истог доктора koji је радио интервенцију, да би ми на дан интервенције наплатили преглед 50€, малу интервенцију на капку у трајању од 15 мин 180€ и после 7 дана контролни преглед опет 50€, а крајњи резултат — неуспела интервенција која мора да се поново обавља и претпостављам поново истим механизмом наплате.
Имам утисак да пацијенте посматрају само као извор прихода уз потпуни недостатак људске и медицинске етике. Рекла бих — срамно за једну медицинску установу, чак и за приватну.', 'Very bad experience. I came to the clinic with a referral diagnosis from the same doctor who performed the procedure, only to be charged 50€ for the examination on the day of the procedure, 180€ for a minor 15-minute eyelid procedure, and 50€ again for a follow-up check 7 days later — with the final result being a failed procedure that needs to be redone and, I presume, charged again the same way.
I get the impression that patients are seen only as a source of income, with a complete lack of human and medical ethics. I would say it\'s shameful for a medical institution, even a private one.', 'Очень плохой опыт. Пришла в клинику с направляющим диагнозом от того же врача, который проводил вмешательство, а в день процедуры с меня взяли 50€ за осмотр, 180€ за небольшое вмешательство на веке продолжительностью 15 мин, и через 7 дней снова 50€ за контрольный осмотр — в итоге неудавшаяся процедура, которую нужно повторять и, предполагаю, снова тем же механизмом оплаты.
У меня ощущение, что пациентов воспринимают только как источник дохода, при полном отсутствии человеческой и медицинской этики. Скажу — позорно для медицинского учреждения, даже частного.', 'Sehr schlechte Erfahrung. Ich kam mit einer Überweisungsdiagnose vom selben Arzt, der den Eingriff durchgeführt hat, in die Klinik, nur um am Tag des Eingriffs 50€ für die Untersuchung, 180€ für einen kleinen 15-minütigen Lideingriff und 7 Tage später wieder 50€ für eine Kontrolluntersuchung berechnet zu bekommen — das Endergebnis: ein gescheiterter Eingriff, der wiederholt werden muss und vermutlich wieder auf dieselbe Weise abgerechnet wird.
Ich habe den Eindruck, dass Patienten nur als Einkommensquelle betrachtet werden, bei völligem Mangel an menschlicher und medizinischer Ethik. Ich würde sagen: beschämend für eine medizinische Einrichtung, auch für eine private.', 'Çok kötü bir deneyim. Aynı prosedürü yapan doktordan alınan sevk tanısıyla kliniğe geldim, ancak prosedür günü muayene için 50€, 15 dakikalık küçük bir göz kapağı müdahalesi için 180€ ve 7 gün sonra kontrol muayenesi için yine 50€ ödettiler — nihai sonuç ise tekrarlanması gereken başarısız bir müdahale ve muhtemelen aynı ödeme mekanizmasıyla yeniden ücret.
Hasta olarak yalnızca bir gelir kaynağı olarak görüldüğünü, insani ve tıbbi etikten tamamen yoksun bir yaklaşım olduğunu düşünüyorum. Bir tıp kurumu için, özel bile olsa, utanç verici derim.',
    0, '2024-03-24 00:00:00'),

(@user_lexa, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnSUNGX3BEV2JnEAE',
    1, 'bs', 'Pacijenti dobijaju termin pregleda i onda čekaju 2 sata na isti (konkretno kod gostujuce pulmoloskinje koja je neljubazna, neprofesionalna i koja nikakav pregled ne vrsi, samo cita izvjestaje, ne dajuci ni dijagnozu ni misljenje). Ne postoje prioritetne kategorije, djevojka koja radi na šalteru apsolutno nema sluha za pacijente.
Klinika za zaobilaziti.',
    'Pacijenti dobijaju termin pregleda i onda čekaju 2 sata na isti (konkretno kod gostujuce pulmoloskinje koja je neljubazna, neprofesionalna i koja nikakav pregled ne vrsi, samo cita izvjestaje, ne dajuci ni dijagnozu ni misljenje). Ne postoje prioritetne kategorije, djevojka koja radi na šalteru apsolutno nema sluha za pacijente.
Klinika za zaobilaziti.', 'Пацијенти добијају термин прегледа и онда чекају 2 сата на исти (конкретно код гостујуће пулмолошкиње koja је нељубазна, непрофесионална и koja никакав преглед не врши, само чита извештаје, не дајући ни дијагнозу ни мишљење). Не постоје приоритетне категорије, девојка koja ради на шалтеру апсолутно нема слуха за пацијенте.
Клиника за заобилажење.', 'Patients get an appointment and then wait 2 hours for it (specifically with the visiting pulmonologist who is unfriendly, unprofessional, and doesn\'t actually examine anyone — just reads reports without giving a diagnosis or opinion). There are no priority categories, and the girl at the counter has absolutely no consideration for patients.
A clinic to avoid.', 'Пациенты получают запись на осмотр, а потом ждут 2 часа (конкретно у гастролирующей пульмонолога, которая нелюбезна, непрофессиональна и никакого осмотра не проводит — только читает отчёты, не давая ни диагноза, ни мнения). Нет приоритетных категорий, девушка на стойке совершенно не слышит пациентов.
Клиника, которую стоит обходить стороной.', 'Patienten erhalten einen Termin und warten dann 2 Stunden darauf (konkret bei der Gastpulmonologin, die unfreundlich und unprofessionell ist und keine Untersuchung durchführt — sie liest nur Berichte, ohne Diagnose oder Meinung). Es gibt keine Prioritätskategorien, und das Mädchen am Schalter hat absolut kein Verständnis für Patienten.
Eine Klinik, die man meiden sollte.', 'Hastalar randevu alıyor ve sonra 2 saat bekliyor (özellikle misafir akciğer hastalıkları uzmanı için — hiç muayene yapmıyor, sadece raporları okuyor, ne tanı ne de görüş veriyor). Öncelikli kategoriler yok, gişedeki kız hastaları hiç dinlemiyor.
Kaçınılması gereken bir klinik.',
    0, '2024-03-24 00:00:00'),

(@user_masa_ilincic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ1cWFXdElnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_pro_mn, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ1b1pqc0JREAE',
    1, 'bs', 'Ne javljaju se na telefon, ne šalju izvještaje, ne daju tačna uputstva pripreme za CT.',
    'Ne javljaju se na telefon, ne šalju izvještaje, ne daju tačna uputstva pripreme za CT.', 'Не јављају се на телефон, не шаљу извештаје, не дају тачна упутства припреме за ЦТ.', 'They don\'t answer the phone, don\'t send reports, and don\'t provide accurate preparation instructions for CT.', 'Не берут трубку, не отправляют заключения, не дают точных инструкций по подготовке к КТ.', 'Sie gehen nicht ans Telefon, schicken keine Berichte und geben keine genauen Vorbereitungsanweisungen für CT.', 'Telefona çıkmıyorlar, raporlar göndermiyor, BT için doğru hazırlık talimatları vermiyorlar.',
    0, '2024-03-24 00:00:00'),

(@user_irina_micunovic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnSUNaalpTY053EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_sandra_resetar, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnSURwdHVlSUJBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_rados_pesic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnSUN4MnNlUFVREAE',
    1, 'bs', 'Doktor lupa terapiju. Dobio sam na slijepo 35 dana antibiotika, i 15 dana kortikosteroida zbog krckanja ispod patele koljena.
Daju se i pisu terapije i misljenja na osnovu pregleda jednako dobrih kolega od prije godine i vise.
Posle toga, na drugom pregledu , na pitanje sta mi je, bukvalno mi nije doktorica znala dati odgovor, te sam kao "terapiju" dobio kolagen i kesice (kesice istog sastava kao prve kapsule, samo proizvodjac i z Srbije ali vj ih prodaju po dogovoru sa istima).',
    'Doktor lupa terapiju. Dobio sam na slijepo 35 dana antibiotika, i 15 dana kortikosteroida zbog krckanja ispod patele koljena.
Daju se i pisu terapije i misljenja na osnovu pregleda jednako dobrih kolega od prije godine i vise.
Posle toga, na drugom pregledu , na pitanje sta mi je, bukvalno mi nije doktorica znala dati odgovor, te sam kao "terapiju" dobio kolagen i kesice (kesice istog sastava kao prve kapsule, samo proizvodjac i z Srbije ali vj ih prodaju po dogovoru sa istima).', 'Доктор удара терапију на слепо. Добио сам 35 дана антибиотика и 15 дана кортикостероида zbog крцкања испод пателе колена.
Дају се и пишу терапије и мишљења на основу прегледа jednakoдобрих колега од пре годину и više.
После тога, на другом прегледу, на питање шта ми је, докторица буквално није знала да ми да одговор, те сам као "терапију" добио колаген и кесице (кесице истог sastava kao прве капсуле, само произвођач из Србије, ali ih verovatno продају по договору са истима).', 'The doctor prescribes treatment blindly. I was given 35 days of antibiotics and 15 days of corticosteroids for a cracking under my kneecap.
Therapies and opinions are issued based on examinations from equally competent colleagues done over a year ago.
Afterward, at the second appointment, when asked what was wrong with me, the doctor literally couldn\'t give me an answer, and as \'treatment\' I received collagen and sachets (sachets of the same composition as the first capsules, just from a Serbian manufacturer, but they probably sell them by arrangement with the same people).', 'Врач назначает лечение вслепую. Мне выписали 35 дней антибиотиков и 15 дней кортикостероидов из-за хруста под коленной чашечкой.
Терапии и мнения выдаются на основе осмотров «таких же хороших» коллег, сделанных год и более назад.
После этого, на втором приёме, на вопрос что со мной — докторша буквально не смогла дать ответ, и я получил как «лечение» коллаген и пакетики (пакетики того же состава, что и первые капсулы, только производитель из Сербии, но, видимо, продают их по договорённости с теми же).', 'Der Arzt verschreibt eine Therapie blind. Ich erhielt 35 Tage Antibiotika und 15 Tage Kortikosteroide wegen eines Knackens unter der Kniescheibe.
Therapien und Meinungen werden auf Grundlage von Untersuchungen gleich kompetenter Kollegen von vor einem Jahr oder länger ausgegeben.
Danach konnte die Ärztin beim zweiten Termin auf die Frage, was mit mir nicht stimmt, buchstäblich keine Antwort geben, und ich erhielt als \'Therapie\' Kollagen und Päckchen (Päckchen der gleichen Zusammensetzung wie die ersten Kapseln, nur vom Hersteller aus Serbien, aber wahrscheinlich über eine Vereinbarung mit denselben Leuten verkauft).', 'Doktor körü körüne tedavi uyguluyor. Diz kapağımın altındaki çıtırtı için 35 günlük antibiyotik ve 15 günlük kortikosteroid verildi.
Tedaviler ve görüşler, bir yıl veya daha önce yapılmış eşit derecede yetkin meslektaşların muayenelerine dayanarak yazılıp verilmektedir.
İkinci muayenede ne sorunum olduğu sorulduğunda doktor kelimenin tam anlamıyla cevap veremedi ve \'tedavi\' olarak kolajen ve tozlar aldım (ilk kapsüllerle aynı bileşimde tozlar, sadece Sırp üretici, ama muhtemelen aynı kişilerle anlaşarak satıyorlar).',
    0, '2024-03-24 00:00:00'),

(@user_mark_leach, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChdDSUhNMG9nS0VJQ0FnSURoaE52YTNnRRAB',
    1, 'en', 'Simply awful. Customer support doesn\'t reply and I couldn\'t make an appointment in two days. I guess I\'ll have to search somewhere else. I\'ve never seen a private clinic that doesn\'t care about their customers so much that they don\'t even bother to schedule an appointment',
    'Jednostavno strašno. Podrška ne odgovara i nisam mogao da zakažem termin u dva dana. Moraću da potražim negde drugde. Nikad nisam video privatnu kliniku koja toliko ne brine o pacijentima da se ne trude ni da zakaže termin.', 'Једноставно страшно. Подршка не одговара и нисам могао да закажем термин у два дана. Мораћу да потражим негде другде. Никад нисам видео приватну клинику koja толико не брине о пацијентима da se ne trude ni da zakažu termin.', 'Simply awful. Customer support doesn\'t reply and I couldn\'t make an appointment in two days. I guess I\'ll have to search somewhere else. I\'ve never seen a private clinic that doesn\'t care about their customers so much that they don\'t even bother to schedule an appointment', 'Просто ужасно. Служба поддержки не отвечает, и мне не удалось записаться за два дня. Придётся искать в другом месте. Никогда не видел частную клинику, которая настолько не заботится о своих клиентах, что не удосуживается даже записать на приём.', 'Einfach schrecklich. Der Kundendienst antwortet nicht und ich konnte in zwei Tagen keinen Termin bekommen. Ich muss wohl woanders suchen. Ich habe noch nie eine Privatklinik gesehen, der ihre Kunden so egal sind, dass sie sich nicht einmal die Mühe machen, einen Termin zu vereinbaren.', 'Basitçe korkunç. Müşteri desteği yanıt vermiyor ve iki günde randevu alamadım. Sanırım başka bir yer aramam gerekecek. Müşterilerini bu kadar önemsemeyen, randevu almak için bile zahmet göstermeyen bir özel klinik hiç görmedim.',
    0, '2023-03-24 00:00:00'),

(@user_danilo_vukovic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnSURCcnRUeVR3EAE',
    1, 'en', 'terrible experience',
    'strašno iskustvo', 'страшно искуство', 'terrible experience', 'ужасный опыт', 'schreckliche Erfahrung', 'korkunç bir deneyim',
    0, '2023-03-24 00:00:00'),

(@user_mia_wallace, @clinic_id, @doctor_divanovic, 'google_maps',
    'places/undefined/reviews/ChdDSUhNMG9nS0VJQ0FnSURCenAyS2xBRRAB',
    1, 'bs', 'Užasno iskustvo, od sestre Milice sa pulta koja zbog svog nevaspitanja ne umije ni da se obrati pacijentu na način koji ta pozicija zahtijeva, pa do menadzmenta koji u toku radnog vremena drži sastanak sa personalnom dok pacijenti koji su putovali 2 sata i dosli na zakazani termin cekaju. Da naglasim da sam došla samo zbog dobrog glasa o dr Divanovic koja je divna, ali nije samo ona dovoljna da bi opšti utisak bio bolji.
Sve u svemu PLEASE AVOID THIS PLACE!!!',
    'Užasno iskustvo, od sestre Milice sa pulta koja zbog svog nevaspitanja ne umije ni da se obrati pacijentu na način koji ta pozicija zahtijeva, pa do menadzmenta koji u toku radnog vremena drži sastanak sa personalnom dok pacijenti koji su putovali 2 sata i dosli na zakazani termin cekaju. Da naglasim da sam došla samo zbog dobrog glasa o dr Divanovic koja je divna, ali nije samo ona dovoljna da bi opšti utisak bio bolji.
Sve u svemu PLEASE AVOID THIS PLACE!!!', 'Ужасно искуство, од сестре Милице са пулта koja zbog свог невасипитања не уме ни да се обрати пацијенту на начин koji та позиција захтева, па до менаџмента koji у току радног времена држи sastanak са персоналом dok пацијенти koji су путовали 2 сата и дошли на заказани термин чекају. Да нагласим да сам дошла само zbog доброг гласа о др Диванових koja је дивна, али није само она довољна da bi општи утисак bio бољи.
Све у свему PLEASE AVOID THIS PLACE!!!', 'Terrible experience, from the nurse Milica at the desk who, due to her bad manners, can\'t even address a patient in the way that position requires, to management holding meetings with staff during working hours while patients who traveled 2 hours and arrived for scheduled appointments wait. I should emphasize that I came only because of the good reputation of Dr. Divanović who is wonderful, but she alone is not enough to improve the overall impression.
All in all PLEASE AVOID THIS PLACE!!!', 'Ужасный опыт — от медсестры Милицы на стойке, которая из-за своей невоспитанности не умеет даже обратиться к пациенту, как того требует её должность, до менеджмента, который в рабочее время проводит собрание с персоналом, пока пациенты, приехавшие за 2 часа и явившиеся на назначенный приём, ждут. Подчеркну, что пришла только из-за хорошей репутации д-р Диванович, которая чудесная, но одной её недостаточно, чтобы общее впечатление стало лучше.
В целом ПОЖАЛУЙСТА ИЗБЕГАЙТЕ ЭТОГО МЕСТА!!!', 'Schreckliche Erfahrung — von der Schwester Milica am Schalter, die aufgrund ihrer schlechten Manieren nicht einmal in der Lage ist, einen Patienten so anzusprechen, wie es diese Position erfordert, bis hin zum Management, das während der Arbeitszeit Besprechungen abhält, während Patienten, die 2 Stunden gereist sind und zum vereinbarten Termin gekommen sind, warten. Ich möchte betonen, dass ich nur wegen des guten Rufs von Dr. Divanović kam, die wunderbar ist, aber sie allein reicht nicht aus, um den allgemeinen Eindruck zu verbessern.
Alles in allem BITTE MEIDET DIESEN ORT!!!', 'Korkunç bir deneyim — gişedeki hemşire Milica\'dan başlayarak (görgüsüzlüğü nedeniyle bir hastaya pozisyonun gerektirdiği şekilde hitap bile edemiyor), 2 saat yol yapıp randevusuna gelen hastalar beklerken çalışma saatlerinde personelle toplantı yapan yönetime kadar. Belirtmek isterim ki yalnızca harika olan dr Divanović\'in iyi ünü nedeniyle geldim, ancak genel izlenimi iyileştirmek için o tek başına yeterli değil.
Sonuç olarak LÜTFEN BU YERDEN UZAK DURUN!!!',
    0, '2023-03-24 00:00:00'),

(@user_mira_popovic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnSUNCN19MZ0Z3EAE',
    5, 'hr', 'Ljubazni I efikasni',
    'Ljubazni I efikasni', 'Љубазни и ефикасни', 'Kind and efficient', 'Любезные и эффективные', 'Freundlich und effizient', 'Nazik ve verimli',
    0, '2023-03-24 00:00:00'),

(@user_balsa_radunovic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChRDSUhNMG9nS0VJQ0FnSURPXzk4YRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-03-24 00:00:00'),

(@user_mix1_em, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnSURXN3J6U1BREAE',
    1, 'bs', 'Pozvala sam da zakazem MSCT. Sestra mi je zakazala. Nije znala da mi kaze tacnu cenu pregleda. Rekla je oko 200e,pregled je bio 250,nije mi rekla sta treba da uradim od obaveznih analiza pre snimanja dok je nisam podsetila.
Dakle gospodo iz Moj Lab. Ukljucite snimanje razgovora da cujete koliko su vam sestre neupucene u posao kojim se bave',
    'Pozvala sam da zakazem MSCT. Sestra mi je zakazala. Nije znala da mi kaze tacnu cenu pregleda. Rekla je oko 200e,pregled je bio 250,nije mi rekla sta treba da uradim od obaveznih analiza pre snimanja dok je nisam podsetila.
Dakle gospodo iz Moj Lab. Ukljucite snimanje razgovora da cujete koliko su vam sestre neupucene u posao kojim se bave', 'Позвала сам да закажем MSCT. Сестра ми је заказала. Није знала да ми каже тачну цену прегледа. Рекла је oko 200е, преглед је bio 250, није ми рекла шта треба да урадим od обавезних analiza пре snimanja dok је нисам подсетила.
Дакле, господо из Мој Лаб. Укључите snimanje разговора да чујете колiko су вам сестре neupućene у посао kojim se baве.', 'I called to schedule an MSCT. The nurse scheduled it. She didn\'t know how to tell me the exact price. She said around 200e, the examination was 250e, and she didn\'t tell me what mandatory tests needed to be done before the scan until I reminded her.
So, gentlemen from Moj Lab — enable call recording so you can hear how uninformed your nurses are about the job they do.', 'Позвонила, чтобы записаться на МСКТ. Медсестра записала. Не смогла назвать точную цену. Сказала около 200е, а обследование стоило 250е; не сообщила, что нужно было сделать обязательные анализы перед снимком — пока я сама не напомнила.
Итак, господа из Moj Lab — включите запись разговоров, чтобы услышать, насколько ваши медсёстры не осведомлены о работе, которой занимаются.', 'Ich habe angerufen, um ein MSCT zu buchen. Die Schwester hat es eingetragen. Sie wusste nicht, mir den genauen Preis zu nennen. Sie sagte etwa 200€, die Untersuchung kostete 250€, und sie sagte mir nicht, welche Pflichtuntersuchungen vor dem Scan durchgeführt werden müssen — bis ich sie daran erinnerte.
Also, meine Herren von Moj Lab — schalten Sie die Gesprächsaufzeichnung ein, damit Sie hören können, wie ahnungslos Ihre Schwestern in dem Beruf sind, den sie ausüben.', 'MSCT randevusu için aradım. Hemşire randevu verdi. Muayenenin tam fiyatını söyleyemedi. Yaklaşık 200€ dedi, muayene 250€\'ydu ve çekim öncesinde yapılması gereken zorunlu analizleri hatırlatana kadar söylemedi.
Peki Moj Lab\'dan beyefendiler — hemşirelerinizin yaptıkları işten ne kadar habersiz olduğunu duymak için görüşme kaydını açın.',
    0, '2023-03-24 00:00:00'),

(@user_lado_radman, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnSURtbDRtcFNnEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_gys_naude, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChdDSUhNMG9nS0VJQ0FnSURxanRxUXZnRRAB',
    5, 'en', 'Very efficient and quick. I got a PCR test done for travel purposes at 11h30 and received my result via e-mail later the same day at 16h00. Not a problem to queue for about 30min. Just be prepared to queue in sun which at 38 degrees celcuis gets a bit hot after a while.',
    'Veoma efikasno i brzo. PCR test sam uradio u 11:30 za putne svrhe i rezultat dobio mejlom istog dana u 16:00. Nije problem čekati oko 30 min. Samo budite spremni da čekate na suncu, što pri 38 stepeni Celzijusa može postati vruće.', 'Веома ефикасно и брзо. PCR тест сам урадио у 11:30 за путне сврхе и резултат добио мejlom истог дана у 16:00. Није проблем чекати oko 30 мин. Само будите спремни да чекате на сунцу, što при 38 степени Целзијуса може постати вруће.', 'Very efficient and quick. I got a PCR test done for travel purposes at 11h30 and received my result via e-mail later the same day at 16h00. Not a problem to queue for about 30min. Just be prepared to queue in sun which at 38 degrees celcuis gets a bit hot after a while.', 'Очень эффективно и быстро. PCR-тест сделал в 11:30 для путешествия и получил результат по e-mail в тот же день в 16:00. 30 минут в очереди — не проблема. Только будьте готовы стоять на солнце, что при 38 градусах Цельсия через некоторое время становится жарко.', 'Sehr effizient und schnell. Ich habe um 11:30 Uhr einen PCR-Test für Reisezwecke gemacht und das Ergebnis am selben Tag um 16:00 Uhr per E-Mail erhalten. Eine Wartezeit von etwa 30 Minuten ist kein Problem. Seien Sie nur darauf vorbereitet, in der Sonne zu warten, was bei 38 Grad Celsius nach einer Weile etwas heiß wird.', 'Çok verimli ve hızlı. Seyahat amaçlı PCR testini 11:30\'da yaptırdım ve sonucu aynı gün 16:00\'da e-posta ile aldım. Yaklaşık 30 dakika bekleme sorun değil. Sadece güneşte beklemeye hazırlıklı olun — 38 derecede bir süre sonra biraz sıcak oluyor.',
    0, '2022-03-24 00:00:00'),

(@user_kat_christofer, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChdDSUhNMG9nS0VJQ0FnSURhOXBMdndRRRAB',
    5, 'en', 'Very professional, organized and quick result performed by friendly staff. Both women who handled my case were wonderful and spoke English. I made an appointment via email, arrived on time and given a form to fill out at the Document window. After that was entered into the computer and I paid via contactless card and given a receipt, I was swabbed at the second window. Results arrived via email within 4 hours. No queue when I went, just people milling around and not moving to side. Wear a mask.',
    'Veoma profesionalno, organizovano i brzo uz ljubazno osoblje. Obe žene koje su se bavile mojim slučajem bile su sjajne i govorile engleski. Zakazao sam mejlom, stigao na vreme i dobio formular za popunjavanje na šalteru za dokumenta. Potom me uneli u kompjuter, platio sam beskontaktnom karticom i dobio potvrdu, a zatim sam bio brisan na drugom šalteru. Rezultati su stigli mejlom za 4 sata. Kad sam ja bio, nije bilo reda, samo su se ljudi muvali okolo i nisu se pomicali. Nosite masku.', 'Веома професионално, организовано и брзо уз љубазно особље. Обе жене koje su se bавиле мojim случајем биле су сjajne и говориле енглески. Заказао сам мejлom, стигао на vreme и добио формулар za popunjavanje на šalteru za dokumenta. Потом ме унели у kompjuter, платио сам beskontaktnom картицом и добио потврду, а затим sam bio brisаn на drugom šalteru. Резултати су стигли мejlom za 4 сата. Кад сам ja bio, није bilo реда, само су се људи muvali okolo и нису se pomicali. Носите маску.', 'Very professional, organized and quick result performed by friendly staff. Both women who handled my case were wonderful and spoke English. I made an appointment via email, arrived on time and given a form to fill out at the Document window. After that was entered into the computer and I paid via contactless card and given a receipt, I was swabbed at the second window. Results arrived via email within 4 hours. No queue when I went, just people milling around and not moving to side. Wear a mask.', 'Очень профессионально, организованно и быстро — работает дружелюбный персонал. Обе женщины, занимавшиеся моим делом, были замечательны и говорили по-английски. Записался по электронной почте, пришёл вовремя и получил анкету для заполнения на стойке документов. После этого меня внесли в компьютер, оплатил бесконтактной картой и получил квитанцию, затем взяли мазок на втором окошке. Результаты пришли по e-mail в течение 4 часов. Очередей не было — просто люди ходили туда-сюда, не давая пройти. Надевайте маску.', 'Sehr professionell, organisiert und schnell durch freundliches Personal. Beide Frauen, die sich um meinen Fall kümmerten, waren wunderbar und sprachen Englisch. Ich habe per E-Mail einen Termin vereinbart, pünktlich erschienen und ein Formular zum Ausfüllen am Dokumentenschalter erhalten. Anschließend wurde ich im Computer erfasst, ich zahlte per kontaktloser Karte und erhielt eine Quittung, dann wurde ich am zweiten Schalter abgestrichen. Ergebnisse kamen per E-Mail innerhalb von 4 Stunden. Keine Schlange als ich dort war, nur Leute, die umherwanderten und nicht zur Seite gingen. Maske tragen.', 'Çok profesyonel, organize ve nazik personel tarafından hızlı biçimde gerçekleştirildi. Davamla ilgilenen iki kadın da harika ve İngilizce konuşuyordu. E-posta ile randevu aldım, vaktinde geldim ve Belge penceresinde doldurmak için form verildi. Ardından bilgisayara kaydedildim, temassız kartla ödeme yaptım ve fiş aldım, ikinci pencerede sürüntü alındı. Sonuçlar 4 saat içinde e-posta ile geldi. Gittiğimde sıra yoktu, sadece etrafta dolaşan ve kenara geçmeyen insanlar vardı. Maske takın.',
    0, '2022-03-24 00:00:00'),

(@user_olja_lakonic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChdDSUhNMG9nS0VJQ0FnSUNxallEWHlRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_len_brown, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChdDSUhNMG9nS0VJQ0FnSUNxa1otZXBRRRAB',
    5, 'en', 'Superb very fast and helpful service. If you need a PCR test and you are a tourist - go to this place!',
    'Odličan, veoma brz i koristan servis. Ako vam treba PCR test i turista ste — idite na ovo mesto!', 'Одличан, веома брз и користан сервис. Ако вам треба PCR тест и туриста сте — идите на ово место!', 'Superb very fast and helpful service. If you need a PCR test and you are a tourist - go to this place!', 'Отличный, очень быстрый и полезный сервис. Если вам нужен PCR-тест и вы турист — идите сюда!', 'Hervorragender, sehr schneller und hilfreicher Service. Wenn Sie einen PCR-Test brauchen und Tourist sind — gehen Sie zu diesem Ort!', 'Mükemmel, çok hızlı ve yardımsever hizmet. PCR testi ihtiyacınız varsa ve turistseniz — bu yere gidin!',
    0, '2022-03-24 00:00:00'),

(@user_jovana_zujovic, @clinic_id, NULL, 'google_maps',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnSUNxZ1A2Vk9nEAE',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
