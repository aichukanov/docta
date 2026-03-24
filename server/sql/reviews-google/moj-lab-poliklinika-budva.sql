-- Insert Google Maps reviews for Moj Lab (Budva)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/moj-lab-poliklinika-budva.sql

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = 7;
SET @doctor_marina_pejovic = 112;
SET @doctor_dragica_becic = 182;
SET @doctor_vesna_vucetic = 178;
SET @doctor_mladen_perisic = 179;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radoje Nikolic', 'https://lh3.googleusercontent.com/a/ACg8ocIxHncYbo5FAE_MhtkBQFZCpw4bGRiZ2c4EX6oUXrFYG_rgHg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106171469851681952384/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106171469851681952384/reviews');
SET @user_radoje_nikolic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106171469851681952384/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Konstantin', 'https://lh3.googleusercontent.com/a-/ALV-UjXqY8cEYDhReZicA7eG3fAL28eWBBeSdh6rKwLyVc6jR2Tkhb_F=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/112327737620401480556/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112327737620401480556/reviews');
SET @user_konstantin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112327737620401480556/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nevena Jovanovic', 'https://lh3.googleusercontent.com/a/ACg8ocKUKRTAO26OaXqSYyLtXdjFfz-WsCLutoH2pxXe95d_0KLFEQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111805355489505562815/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111805355489505562815/reviews');
SET @user_nevena_jovanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111805355489505562815/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Екатерина Иванова', 'https://lh3.googleusercontent.com/a-/ALV-UjVXlWotKGoennjQrUyngkwzz9mgQ_LciYKIXN4s_gQ4gks3eOOF=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/111876503941804132181/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111876503941804132181/reviews');
SET @user_ekaterina_ivanova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111876503941804132181/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Mikovic', 'https://lh3.googleusercontent.com/a/ACg8ocLMOZpixotNDBMBmQ4Q8E3oIpAUMWDADvnME4jnAzfjoGweSw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113486291443898713128/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113486291443898713128/reviews');
SET @user_luka_mikovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113486291443898713128/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Velickovic', 'https://lh3.googleusercontent.com/a-/ALV-UjU25OZGpfe4XC07ZjCtwnPpoVjxfnDcUBU-j6b9dDOOgMQe_2HhxA=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/100274855293708199693/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100274855293708199693/reviews');
SET @user_marija_velickovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100274855293708199693/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sara Gabr', 'https://lh3.googleusercontent.com/a-/ALV-UjXVotieyDozaPv4VNlrzyBGOeaj9n1NdYu1H_1OFST8kHWLqVwJ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105566388393353827565/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105566388393353827565/reviews');
SET @user_sara_gabr = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105566388393353827565/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladimir Vukmirovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWqQzkwKLgsG2RW23ehsqDP4pLX-YgtEEnPuWkHHP-b3oTEA8ZM=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/107328510178617981618/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107328510178617981618/reviews');
SET @user_vladimir_vukmirovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107328510178617981618/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kristina Kuburovic', 'https://lh3.googleusercontent.com/a/ACg8ocIF9PINmZl6o05K4O_zHXORJYEP02kRCUXdjJc5uOyez-CJP_Vn=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/115417809655050347632/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115417809655050347632/reviews');
SET @user_kristina_kuburovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115417809655050347632/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'An Buf', 'https://lh3.googleusercontent.com/a/ACg8ocKfy08QyI0CHKl7TslREOsKZ-VeRfRAftV4BaOwScxROQVKHw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110275484463421098512/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110275484463421098512/reviews');
SET @user_an_buf = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110275484463421098512/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olga Kuznetsova', 'https://lh3.googleusercontent.com/a-/ALV-UjWWfKSTd8hJKENa1kBVpMDckVQWDk5SYan1V_ZNxRqD8dEErXFq=w36-h36-p-rp-mo-ba5-br100', 'https://www.google.com/maps/contrib/101646567970189166510/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101646567970189166510/reviews');
SET @user_olga_kuznetsova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101646567970189166510/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vadim Smirnov', 'https://lh3.googleusercontent.com/a/ACg8ocKpMCxq_uGrLncGxCmUUkQkpeIEFxZRfjwSnumDSbcgvKVC=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117951428294291699847/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117951428294291699847/reviews');
SET @user_vadim_smirnov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117951428294291699847/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milan Ivkov', 'https://lh3.googleusercontent.com/a/ACg8ocKoSHnwLAX8Jwtys-Mgey541vXcF2Af4Vdnc86pFeF2b3diLA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117040412166000587756/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117040412166000587756/reviews');
SET @user_milan_ivkov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117040412166000587756/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Semenova Ekaterina', 'https://lh3.googleusercontent.com/a/ACg8ocIda19a9JdAhCkR02bs14FbCrrcLLj6MPRs8x3ac6UEW4V0lw=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/102115776130216411216/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102115776130216411216/reviews');
SET @user_semenova_ekaterina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102115776130216411216/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladimir PS', 'https://lh3.googleusercontent.com/a/ACg8ocKFpM1LEpd5JLCcekn-_UN4Zg_O-Y38U8nuOKILQkOZRvCOsg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117387259679208015595/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117387259679208015595/reviews');
SET @user_vladimir_ps = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117387259679208015595/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'sneza', 'https://lh3.googleusercontent.com/a-/ALV-UjUXfq4bbZZMtZUOk2Ar30XQHd0MGksz-Pama4nGzf-Xybbelu8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102635962415870884176/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102635962415870884176/reviews');
SET @user_sneza = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102635962415870884176/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Knezevic', 'https://lh3.googleusercontent.com/a/ACg8ocINbTC2Fa-4jPucfS1RGoGXZ4Bo5p6FDzf5QmM84o6B05CIPg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104412870369043115609/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104412870369043115609/reviews');
SET @user_nikola_knezevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104412870369043115609/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natasa Boskovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVcSxpdTWyAbf-siBGXMdXntjfvpsxGexCK72bH1_P_-9YzTOjh=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113965408277507913244/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113965408277507913244/reviews');
SET @user_natasa_boskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113965408277507913244/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sertaç Hamza', 'https://lh3.googleusercontent.com/a/ACg8ocK59m_UxCJ7_BrfuTIgVasT-qe-iISb5rYDF-_VHVKce_dmww=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109548956230583709625/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109548956230583709625/reviews');
SET @user_serta_hamza = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109548956230583709625/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Kekovic', 'https://lh3.googleusercontent.com/a/ACg8ocJxuMv3R4qamHIZp_s-hvKvoLf6Zrm3vz__SNNL2eCyCSvdpA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109124350344093254070/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109124350344093254070/reviews');
SET @user_marija_kekovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109124350344093254070/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lejla Vukovic', 'https://lh3.googleusercontent.com/a/ACg8ocKIByOg91_fUs5GrsTJqvZD5ZdXTKucBh6KZ5nnUkchHBHdEw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107878491666132016987/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107878491666132016987/reviews');
SET @user_lejla_vukovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107878491666132016987/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'I Dr', 'https://lh3.googleusercontent.com/a/ACg8ocLdL75MYr0lxZ1-yPHffbQse2nEAKWqqhJ6jiymJoSZ7wVh8g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113255273392678227756/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113255273392678227756/reviews');
SET @user_i_dr = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113255273392678227756/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Александра Христенко', 'https://lh3.googleusercontent.com/a/ACg8ocIGENY9sqMJxJxMJzH4Lpu6Cz9pb-2a_q-yrEuias1z8tfKcA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106261581381203520062/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106261581381203520062/reviews');
SET @user_aleksandra_khristenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106261581381203520062/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ipek I', 'https://lh3.googleusercontent.com/a-/ALV-UjVk1W-nTERwptNAIN4FoxMpeZeZH5bya3B3U8UiNTXjDkde4gc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111838355446668419737/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111838355446668419737/reviews');
SET @user_ipek_i = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111838355446668419737/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Svitlana Vyshnevska', 'https://lh3.googleusercontent.com/a-/ALV-UjWZtfoWFWqPGyA4Uv9gubIB6Rxi8MSH6el8LB3Vdllb3W0i1eug=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/102744558527202136762/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102744558527202136762/reviews');
SET @user_svitlana_vyshnevska = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102744558527202136762/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Зиля Абзалова', 'https://lh3.googleusercontent.com/a/ACg8ocJKKNLj_LIHF0Oj38NiMiryEZTXnQNOJmwTVNIiq9igyQz_kw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116758834243182641827/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116758834243182641827/reviews');
SET @user_zilya_abzalova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116758834243182641827/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natalia', 'https://lh3.googleusercontent.com/a/ACg8ocJ8L97aGpbUNE1Wa001LSWxbVI0KMJKuVprGGcWt09nZjq6Hg=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/109605084787218653614/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109605084787218653614/reviews');
SET @user_natalia = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109605084787218653614/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'cenker sahin', 'https://lh3.googleusercontent.com/a-/ALV-UjUMDHNIhIho2HZhu4tX4oiJcQ-_h1O4ieA6Bj4voxxcien2dtc=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/101079819273015277651/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101079819273015277651/reviews');
SET @user_cenker_sahin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101079819273015277651/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikishin Aleksandr', 'https://lh3.googleusercontent.com/a/ACg8ocKwm6cClX3AZ4cMxtB8935a_JV2ArdQUJcyYUZnaed8t2ihKw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109985950027472847282/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109985950027472847282/reviews');
SET @user_nikishin_aleksandr = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109985950027472847282/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jarosław Szczuka', 'https://lh3.googleusercontent.com/a/ACg8ocLTrtnHt5HRriMiuA5sSDRxIfVdXQ66_sLZtxoTnTGepUyLiA=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/117423839055945523583/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117423839055945523583/reviews');
SET @user_jarosaw_szczuka = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117423839055945523583/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Armin 91', 'https://lh3.googleusercontent.com/a/ACg8ocLmFSe9wwnLhLDlDOiilfu2UlFs9nwGISdp0l-KMPg3_yag_A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112520507716067020961/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112520507716067020961/reviews');
SET @user_armin_91 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112520507716067020961/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stefan Maslovar', 'https://lh3.googleusercontent.com/a-/ALV-UjWqKzEsgXciQd2YF0IlLsWDTzTQFxl0xGMrLNL1xrrpOjq_Gdo6=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/110790430300260062613/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110790430300260062613/reviews');
SET @user_stefan_maslovar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110790430300260062613/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dajana Mirkoivic', 'https://lh3.googleusercontent.com/a/ACg8ocIuEe1f3EojES3PZmeXbwbH8V4H5r__zz2e3XgLUrFMOlCwS2I=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106342773692523047732/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106342773692523047732/reviews');
SET @user_dajana_mirkoivic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106342773692523047732/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'sandra jevtic', 'https://lh3.googleusercontent.com/a/ACg8ocKgSY_D_VaisO4TUNWUsHlno0jLo1ZAJOppYJfNvwFckLn3mA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112030096988500367314/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112030096988500367314/reviews');
SET @user_sandra_jevtic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112030096988500367314/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Viktor Stojanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXCklMn-648HHKsP4bxna7kS_wT9QCwukO-pzLI2c2KhyfFl2X6=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100440137549273500330/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100440137549273500330/reviews');
SET @user_viktor_stojanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100440137549273500330/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Школа Ђокићи', 'https://lh3.googleusercontent.com/a-/ALV-UjUeKIWhQz_e40hO3klaR7pZMmZT9Fy00jw6zEe9tSRbEkCsB1tw=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/106780311616434902858/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106780311616434902858/reviews');
SET @user_shkola_djokici = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106780311616434902858/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Srdjan Spasić', 'https://lh3.googleusercontent.com/a-/ALV-UjUAW1Fa83JvF69j0EOcHldzSSm0IWVzcmcey4EHk2gVvS2vsruCfg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101327035382450635306/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101327035382450635306/reviews');
SET @user_srdjan_spasi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101327035382450635306/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Serhii Viktorovich Doldin', 'https://lh3.googleusercontent.com/a-/ALV-UjXZuwfW8lydYM9c5G1JQTOx9lOknepzwuaBv6-ExOq1K723LDdm=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108585294872940547234/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108585294872940547234/reviews');
SET @user_serhii_viktorovich_doldin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108585294872940547234/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladana Goločevac', 'https://lh3.googleusercontent.com/a-/ALV-UjV3RcPCUZwYhX2auJeqghigXfrIhQ62FJJ3X2B4h7lKjteEbRnY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105889422549738862089/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105889422549738862089/reviews');
SET @user_vladana_goloevac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105889422549738862089/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladimir Ashikhmin', 'https://lh3.googleusercontent.com/a-/ALV-UjVk_BwkN4yZgr54BNi5xKFZOoc1EZLRMZvsS7ArWkzhbxjm_5WEOw=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/103710425812734742025/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103710425812734742025/reviews');
SET @user_vladimir_ashikhmin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103710425812734742025/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'M S', 'https://lh3.googleusercontent.com/a-/ALV-UjWX8z7sMxKBtCOFGf6ZwKxav5RpE3chrPHDwQFgS83gK7OBiEtE=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/108700376737736431802/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108700376737736431802/reviews');
SET @user_m_s = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108700376737736431802/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Hungry Ghost', 'https://lh3.googleusercontent.com/a-/ALV-UjV7VUgsN6Sz5cKTMZJ7b40iN6FrqxHJDBsypbBpeLJ6FolcKlVj=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/100956703510317704123/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100956703510317704123/reviews');
SET @user_hungry_ghost = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100956703510317704123/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alex Zh', 'https://lh3.googleusercontent.com/a/ACg8ocLOrXAdc3ZWbG8bQknHo8EK4JekAguuPA2hk-LqHT1qK__oack=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/103839555134626713899/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103839555134626713899/reviews');
SET @user_alex_zh = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103839555134626713899/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andjelka Rakita', 'https://lh3.googleusercontent.com/a/ACg8ocKUvUFQbEwQnwut-0zujhhcwfINue_vKfd1wMNH7tLdOfRs9g=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/109868106559886226972/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109868106559886226972/reviews');
SET @user_andjelka_rakita = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109868106559886226972/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branka Boskovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUbnDdDWU4qf1H9Qe4kDTSXfAQNF8gbsyYl1SKWD2WLqOkl2yCX=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/107403445475782961623/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107403445475782961623/reviews');
SET @user_branka_boskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107403445475782961623/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Oleg Kipriianov', 'https://lh3.googleusercontent.com/a-/ALV-UjUOYHNeLwp0-kXFYV3SIQbreXAr2PKui0OAji6M4MTD2fXrX_ctrw=w36-h36-p-rp-mo-ba5-br100', 'https://www.google.com/maps/contrib/118025817538181561702/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118025817538181561702/reviews');
SET @user_oleg_kipriianov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118025817538181561702/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'УДРУЖЕЊЕ ВЕЛИКО КОЛО', 'https://lh3.googleusercontent.com/a-/ALV-UjV6pWa1Cih578g0jWJ1wu4UtKRl7uage3JFYF5cy45wn5XLobdJpw=w36-h36-p-rp-mo-ba6-br100', 'https://www.google.com/maps/contrib/104275021296925126980/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104275021296925126980/reviews');
SET @user_udruzhenje_veliko_kolo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104275021296925126980/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nataša Bošković', 'https://lh3.googleusercontent.com/a/ACg8ocJTyk5n_gLpdSlxr9tOz8BKm9kwmuS7nFTl8O05HZXPJjn6Dg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112816995909499333559/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112816995909499333559/reviews');
SET @user_nataa_bokovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112816995909499333559/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra Rajovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWZkj8kJ_-gLC72TRdrOffn_o3b49TGk0QQ4IhE2uE57yGPoo4uhw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113335598095163860531/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113335598095163860531/reviews');
SET @user_aleksandra_rajovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113335598095163860531/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Isidora Vitezovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWj1wBU3pVGQMLWBAdLg1C-qpq7FlNRaEPKt-5hP6fVbJvJYQD6=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/115586745359132322952/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115586745359132322952/reviews');
SET @user_isidora_vitezovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115586745359132322952/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Алексей Подгорный', 'https://lh3.googleusercontent.com/a/ACg8ocLeG7o0OFC76Dz7UHSRJXeT64NN24UJixT2S_v43lGxpYzt=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107741067734952712868/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107741067734952712868/reviews');
SET @user_aleksey_podgornyy = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107741067734952712868/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Djordje Klac', 'https://lh3.googleusercontent.com/a/ACg8ocLEffE8oDC-M1Rj8oojU7jnINzYKg72TKhFGZ69PPxnKUK0ww=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102359213227917758093/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102359213227917758093/reviews');
SET @user_djordje_klac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102359213227917758093/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ling Mollenkopf', 'https://lh3.googleusercontent.com/a/ACg8ocIfEbTp6--rneDobhopVUED5EnOlcvxT1ZA_ECNFC2BaF-zqgU=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/110569434522128759270/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110569434522128759270/reviews');
SET @user_ling_mollenkopf = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110569434522128759270/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Konstantin Gavrilov', 'https://lh3.googleusercontent.com/a-/ALV-UjUmD58nDrrtEKRknwYKIK_CDVcd2t-Gyr6RqNt1v6npa8ENMWbI=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/100770397894119447133/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100770397894119447133/reviews');
SET @user_konstantin_gavrilov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100770397894119447133/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'bice bolje', 'https://lh3.googleusercontent.com/a/ACg8ocJkqU45dcb5digbok-Hz7XRaifsuayCx2qIsgvmrMGMytNqwA=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/109500103413299648496/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109500103413299648496/reviews');
SET @user_bice_bolje = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109500103413299648496/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Dojkic', 'https://lh3.googleusercontent.com/a-/ALV-UjXco1aNjiYJgGD9RQlY8rhfytF5zBBdXpa882b4sb1npHM6USQ=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/115120552996293003997/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115120552996293003997/reviews');
SET @user_dragana_dojkic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115120552996293003997/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Terzic', 'https://lh3.googleusercontent.com/a-/ALV-UjW6nu5KyGEsXFCZaVO_VrHw0YN5alF7nHDB-7Aso8Mi5XmiZ2gx=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111629164646058137866/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111629164646058137866/reviews');
SET @user_jovana_terzic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111629164646058137866/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'S B', 'https://lh3.googleusercontent.com/a-/ALV-UjXi-DrYeDe1ElRQxeRORpq7ohpVYnQ131nP028tO8gAIMf0H4YJ=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/102529313260287061201/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102529313260287061201/reviews');
SET @user_s_b = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102529313260287061201/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Анастасия Миронова', 'https://lh3.googleusercontent.com/a/ACg8ocIbnQ5QXefpdCtoz6kzLfC1zal3Mb7mxI94kL9lGnNKR4V-qA=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/103427202981721596360/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103427202981721596360/reviews');
SET @user_anastasiya_mironova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103427202981721596360/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Deagle Double', 'https://lh3.googleusercontent.com/a/ACg8ocJoohcGmZ6khXk5aexrd-qQq16zCoqH2HUN7i-gS7_XXQibvg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101407727933437372362/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101407727933437372362/reviews');
SET @user_deagle_double = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101407727933437372362/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Papic', 'https://lh3.googleusercontent.com/a/ACg8ocJBu6-0VXsC1xp4OkUZHNL3Q42YH0wKsGIdwJHe8UPRlBChWg=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/114246512498707105181/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114246512498707105181/reviews');
SET @user_nikola_papic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114246512498707105181/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'IGOR DUDCHENKO', 'https://lh3.googleusercontent.com/a-/ALV-UjVnWl676h6F-cWHzIHhJnOh2Hf4ucnA7znaor6z7GgisLjC_x1a8A=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/110565694167511603102/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110565694167511603102/reviews');
SET @user_igor_dudchenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110565694167511603102/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sima Savic', 'https://lh3.googleusercontent.com/a-/ALV-UjW_qk5FrGh7bsjbm3HqP-Rpw68HSctNqYOZ8dcgUEVk9m0WiDw0=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/116336945323721095757/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116336945323721095757/reviews');
SET @user_sima_savic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116336945323721095757/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branko Dragisic', 'https://lh3.googleusercontent.com/a-/ALV-UjVefhASna8JbRHL5tWnj15hmtOg2jhkIHpfm3yjoYUuCa0iZQkFJA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116537378538677511876/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116537378538677511876/reviews');
SET @user_branko_dragisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116537378538677511876/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tamara Burkova', 'https://lh3.googleusercontent.com/a-/ALV-UjXliC9Lnnl3Af5KEnMMGTiMZDFvLxyGkkXplM4sk1Ii2v0iNoKa=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/107935910100220053654/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107935910100220053654/reviews');
SET @user_tamara_burkova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107935910100220053654/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mehveş Yamanyılmaz', 'https://lh3.googleusercontent.com/a-/ALV-UjUf2AcfDzChkMbBJFCuMOqeKCkxySUVpB2itEHXdH-jCwQjYaoL=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/114231659450015432235/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114231659450015432235/reviews');
SET @user_mehve_yamanylmaz = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114231659450015432235/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'djurkovic mladen', 'https://lh3.googleusercontent.com/a/ACg8ocLQ_eqb78MEa8RSuqwzI0YT1k8nHzuODuDDn-KkNcPGzXrYdQ=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/116387589531642542548/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116387589531642542548/reviews');
SET @user_djurkovic_mladen = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116387589531642542548/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Their mother', 'https://lh3.googleusercontent.com/a-/ALV-UjWa6p4-zGaAdnU4ekKVqU-Y8NXFOkkHfT8YGm6R5jB23x5IWadCOA=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/111614297615535793404/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111614297615535793404/reviews');
SET @user_their_mother = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111614297615535793404/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branislava Pleskic', 'https://lh3.googleusercontent.com/a-/ALV-UjUDxU2zPFVhjzr5WZrm2Mfm19JEQ8KOJ0PnkL2HV9FITFCNgjLS=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114599569881800383963/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114599569881800383963/reviews');
SET @user_branislava_pleskic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114599569881800383963/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Надежда Майоршина', 'https://lh3.googleusercontent.com/a-/ALV-UjVZeItoscT3Swii_rwsp8aUcNJrN68AKF58ioA997MrMvWL1N7b=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115532650300656649152/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115532650300656649152/reviews');
SET @user_nadezhda_mayorshina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115532650300656649152/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nenad Vasic', 'https://lh3.googleusercontent.com/a/ACg8ocJcpjhuE64iTXRWvJQQwTxp6WOKLQMz4HxJrG_OuCtB8SaPyg=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/102171098634066260428/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102171098634066260428/reviews');
SET @user_nenad_vasic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102171098634066260428/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Виктор Кушнарев', 'https://lh3.googleusercontent.com/a/ACg8ocJXWosxXu2dkkFaCCdxZH4fO_0sLajECJu6FiUsCTR4Aleg2Q=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/105139091143179837729/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105139091143179837729/reviews');
SET @user_viktor_kushnarev = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105139091143179837729/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'robin brown', 'https://lh3.googleusercontent.com/a/ACg8ocIQQh3ktOTZTd7np7Jr5hlWsTWI5t6JPr7LNRKViib_X9SiTQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102941825909476424994/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102941825909476424994/reviews');
SET @user_robin_brown = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102941825909476424994/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ljupco matasev', 'https://lh3.googleusercontent.com/a/ACg8ocJM0kDjLJAJPtA7AQ6NDdHF63kJswcquGL3tP-7pElwkRRR2Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105577149175622162917/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105577149175622162917/reviews');
SET @user_ljupco_matasev = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105577149175622162917/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'leila akhmetova', 'https://lh3.googleusercontent.com/a/ACg8ocLE_q9ZzwHLuG9J7MtE8dCDZpbEuo73LciFHkq6amdMpoSNBGg=w36-h36-p-rp-mo-ba5-br100', 'https://www.google.com/maps/contrib/113229791522895400307/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113229791522895400307/reviews');
SET @user_leila_akhmetova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113229791522895400307/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vera Stanivuk', 'https://lh3.googleusercontent.com/a/ACg8ocIl7cj4duxrZeCXg2HJvTXpZ8LAtoPjOqTLeUotR3qIHquLtg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115703895241659504006/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115703895241659504006/reviews');
SET @user_vera_stanivuk = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115703895241659504006/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'danijela dj', 'https://lh3.googleusercontent.com/a-/ALV-UjVWShSyjbXS-6Dln-CnkBWMjowGaXKB5l7TEVWdKQ8plffX5WY=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/103462123294041240490/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103462123294041240490/reviews');
SET @user_danijela_dj = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103462123294041240490/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Daniela Beuntker', 'https://lh3.googleusercontent.com/a/ACg8ocK66aFT5fcLMbS_YrkT3U4MOZV5C8sYI5NqKZcT8Rf1mohy3g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111109670288936118197/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111109670288936118197/reviews');
SET @user_daniela_beuntker = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111109670288936118197/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Vergic', 'https://lh3.googleusercontent.com/a-/ALV-UjWcfPdIf2PIu2YCoKXKmTrNzWS9BsazMkZX_m3HraA_ODLf0Pc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101051449939710098582/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101051449939710098582/reviews');
SET @user_dragana_vergic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101051449939710098582/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nicolas Marioni', 'https://lh3.googleusercontent.com/a-/ALV-UjU3kHsOeHTJtO-o_zWQesH3Eg_r-vPd0OGjdGUxB3bzwQC5Po1V=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113391303947886172264/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113391303947886172264/reviews');
SET @user_nicolas_marioni = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113391303947886172264/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'goran vuksanovic', 'https://lh3.googleusercontent.com/a/ACg8ocLUSN_DnAv6iGd45qn7jUHi5ijUuGWH9--PrUFXhoTWQdANQQ=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/112314727386610607858/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112314727386610607858/reviews');
SET @user_goran_vuksanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112314727386610607858/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Аня Воронь', 'https://lh3.googleusercontent.com/a-/ALV-UjW5lAycrdroCEhkjJtApQclqgWbhUTIk4R50tS4wpOHFojGnvSymA=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/115246413387901313039/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115246413387901313039/reviews');
SET @user_anya_voron = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115246413387901313039/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vatamanița Mariana', 'https://lh3.googleusercontent.com/a-/ALV-UjXIGAjTq-7piaHE_72M8BeYZNvE5NjsKTF1hk5tCM1a6iR2Vpvj=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103699043435512243699/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103699043435512243699/reviews');
SET @user_vatamania_mariana = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103699043435512243699/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vida Ivanovic', 'https://lh3.googleusercontent.com/a/ACg8ocJebkk0lwxkvuV9lS2xrddhPYdwwuBWk77n2uLmW8O_oWUGQHg4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113875527133308265799/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113875527133308265799/reviews');
SET @user_vida_ivanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113875527133308265799/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra Breschke', 'https://lh3.googleusercontent.com/a/ACg8ocKWW2xca3UT7ClmDGuv2MyJy7PzuBp1t9cXoexYVHky8XmmrQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108565646047695363021/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108565646047695363021/reviews');
SET @user_aleksandra_breschke = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108565646047695363021/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Marjanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVZBVqiayStVsUWLUrbwGzvhKNeFwuCKppu9EJKsYlCGOqaGhNt=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/104311658833861634969/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104311658833861634969/reviews');
SET @user_jelena_marjanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104311658833861634969/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nevena Cabarkapa', 'https://lh3.googleusercontent.com/a/ACg8ocJ_CajLv40XjisF6SgvkcRx3DLQuYw7-LNz6jUBd6CLcy55Zw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116209099834524033423/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116209099834524033423/reviews');
SET @user_nevena_cabarkapa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116209099834524033423/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Александр Могилев', 'https://lh3.googleusercontent.com/a-/ALV-UjXSgXVBU5qQ6QL-GtOikHmU7WgLaaWR9gjesoxg55tp3ihrdEk=w36-h36-p-rp-mo-ba5-br100', 'https://www.google.com/maps/contrib/109023236730725942955/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109023236730725942955/reviews');
SET @user_aleksandr_mogilev = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109023236730725942955/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Melik Türkmenoğlu', 'https://lh3.googleusercontent.com/a/ACg8ocLMOh_TvncSfV3k9-nwyYTIcBvNFiu18-UqBr_2-gA0sCdAtQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103280729096831629751/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103280729096831629751/reviews');
SET @user_melik_trkmenolu = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103280729096831629751/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Denis Bo', 'https://lh3.googleusercontent.com/a/ACg8ocIU-DKeb-40CvU4mhD8f6B2MYBAxG91Hg2d28Hwlg7JpWsE4A=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/117681879916422325756/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117681879916422325756/reviews');
SET @user_denis_bo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117681879916422325756/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Evgenia Kolesnikova', 'https://lh3.googleusercontent.com/a/ACg8ocKhAi6lRP2RkmZ28utiN4THtLex68t8QiOI8Pnm_ZneaJoZoA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102607298256922655602/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102607298256922655602/reviews');
SET @user_evgenia_kolesnikova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102607298256922655602/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'DV', 'https://lh3.googleusercontent.com/a/ACg8ocKAu6kVFe-sscaXg9NMjeWF_xaUcITIIO2itzVJvfFmE0EZYg=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/113699552178436695496/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113699552178436695496/reviews');
SET @user_dv = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113699552178436695496/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pierluigi Salvatore', 'https://lh3.googleusercontent.com/a-/ALV-UjWn3YLuYWg6whIwHMzVI9MoYhGa-DpZ-Glq4Aubr0pHchhiH0FNmA=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/103789280763780647271/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103789280763780647271/reviews');
SET @user_pierluigi_salvatore = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103789280763780647271/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Žarko', 'https://lh3.googleusercontent.com/a-/ALV-UjVg-CJno1J8tE6pELK8gE1jxXPiRANTySO9Q5Ml46CvyMOz-PGn=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/100608304023658106628/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100608304023658106628/reviews');
SET @user_arko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100608304023658106628/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ivan ivan', 'https://lh3.googleusercontent.com/a/ACg8ocIdQVars0kbzAOiCgaioTudv-Ta8HiA2e1N9vM4W3m3EWpwLA=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/107917433330706301583/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107917433330706301583/reviews');
SET @user_ivan_ivan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107917433330706301583/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Šaranski ribolov Carp fishing', 'https://lh3.googleusercontent.com/a-/ALV-UjVI79EKn-Z8HmaYnk4GKpufEHgX2ZAleQkL5viJUX6tR6lbxmlZ=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/100441318114310814008/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100441318114310814008/reviews');
SET @user_aranski_ribolov_carp_fishing = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100441318114310814008/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Zec', 'https://lh3.googleusercontent.com/a/ACg8ocLSZ88nZMD4fNdtnfU0fhNcDIJ9TI-mVnPukstOPEIlxQtGQA=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/100270153521662189699/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100270153521662189699/reviews');
SET @user_marko_zec = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100270153521662189699/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dejan Kaluđerović', 'https://lh3.googleusercontent.com/a/ACg8ocI4If1hf4lH6ix8aqBtXl2bTkUaCo45dQhGqhCK368u9PS9Kw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107905124715293412828/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107905124715293412828/reviews');
SET @user_dejan_kaluerovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107905124715293412828/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirjana Jovic', 'https://lh3.googleusercontent.com/a/ACg8ocI7sGla9hhzP6CNPQ2-oeO0oQ5oMIGEFtQopy-VIdDjDi3UlNIx=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113417683954963511968/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113417683954963511968/reviews');
SET @user_mirjana_jovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113417683954963511968/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Анастасия Власова', 'https://lh3.googleusercontent.com/a-/ALV-UjW8YVk4j0KlFSc6nwxTbl4YqBmLo6wnKm_H0JD-7sQUQkj0R9RP=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118196031599443913709/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118196031599443913709/reviews');
SET @user_anastasiya_vlasova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118196031599443913709/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Евгений -', 'https://lh3.googleusercontent.com/a/ACg8ocK1ZYFav4YhhToyYKeaAXIAHO8d48AHaLsEiiFsKq4uthywZns=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/100055825979883023327/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100055825979883023327/reviews');
SET @user_evgeniy = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100055825979883023327/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Yevgeniya Vasylevskaya', 'https://lh3.googleusercontent.com/a-/ALV-UjWQOzTmxYYohX7OFyKt7ii4jeFkRBQ4HhB3qoyYV3yfZnHpscotAg=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/112820902539354573173/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112820902539354573173/reviews');
SET @user_yevgeniya_vasylevskaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112820902539354573173/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Daria Trepke', 'https://lh3.googleusercontent.com/a-/ALV-UjVZtPc7m-r-JmIs-Z2GerGCnj355YEsGXZv_ec7jAMam9kH0H--=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/103505896137734767048/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103505896137734767048/reviews');
SET @user_daria_trepke = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103505896137734767048/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra Rosic', 'https://lh3.googleusercontent.com/a/ACg8ocLr8EN3UJnaCfoez2OhaBqkIWC-1AbVJ4yF2M7vvdGlrjLA1Q=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/114259072327132831159/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114259072327132831159/reviews');
SET @user_aleksandra_rosic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114259072327132831159/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljiljana Jaric Maslak', 'https://lh3.googleusercontent.com/a-/ALV-UjX2JqUBp-nSMChhwRjcXRd30NMExs_Q9RhU-EVVlcbzh0ZQ464=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/111251577442454194059/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111251577442454194059/reviews');
SET @user_ljiljana_jaric_maslak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111251577442454194059/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milletvekili', 'https://lh3.googleusercontent.com/a-/ALV-UjVF4-KgLZ-XCL82302bXUv7tSrUc6vbRdL5DRvbAzVeNO-0nVO3=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/108144000633885161680/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108144000633885161680/reviews');
SET @user_milletvekili = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108144000633885161680/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Purić', 'https://lh3.googleusercontent.com/a-/ALV-UjU_UzkyvtuKcQJPlRGFkcvm8329fr4Os82_yRHdCRWgYlc68jLt=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/111452093231167582189/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111452093231167582189/reviews');
SET @user_marija_puri = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111452093231167582189/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Shkelqim Muqa', 'https://lh3.googleusercontent.com/a/ACg8ocKwA7wEa_WaOYldAw6o9qvAWRl89HA5um3c55eayPXn68s6nQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107482429075265811892/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107482429075265811892/reviews');
SET @user_shkelqim_muqa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107482429075265811892/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandar', 'https://lh3.googleusercontent.com/a/ACg8ocKmMrkW2il848HPPTZIEiyAJkiBo5EbnznDGeoDk82IzufBYg=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/109200550967063629035/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109200550967063629035/reviews');
SET @user_aleksandar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109200550967063629035/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Boris Lukic', 'https://lh3.googleusercontent.com/a-/ALV-UjXx-qumETXJXX7uT7lxEbfvLekdAoZIbIp8VKVRvzJZreUYb1K5=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/108768298053275640653/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108768298053275640653/reviews');
SET @user_boris_lukic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108768298053275640653/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Елена Сергеева', 'https://lh3.googleusercontent.com/a/ACg8ocKqxKRsoy8xUs7vgPCWOjknvlUtnGqjTWNz6OzEUlWDQzJR8Q=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/113967596368723496500/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113967596368723496500/reviews');
SET @user_elena_sergeeva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113967596368723496500/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Goran Rudakov', 'https://lh3.googleusercontent.com/a-/ALV-UjWAVgziwkO-OacK8uJYTwdVBZCBBmwJs0ihWrb-H9qhjTHtT92F=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/105820064696076876379/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105820064696076876379/reviews');
SET @user_goran_rudakov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105820064696076876379/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radomir Petrović (Rade)', 'https://lh3.googleusercontent.com/a-/ALV-UjVttAx1zEFuzPalKkmlpE89tRL5hbFqqfcGoNv0oLvOGZBHDM5x9g=w36-h36-p-rp-mo-ba6-br100', 'https://www.google.com/maps/contrib/102165363744132777251/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102165363744132777251/reviews');
SET @user_radomir_petrovi_rade = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102165363744132777251/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Perisa Piletic', 'https://lh3.googleusercontent.com/a-/ALV-UjUZRpSdy1OtzNyyi1DXII5stNE7tVMPtmAOcl-W3XZRw2GLPt1qAA=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/108312672309706004469/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108312672309706004469/reviews');
SET @user_perisa_piletic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108312672309706004469/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ekaterina Hag', 'https://lh3.googleusercontent.com/a-/ALV-UjVYLxBtZuBWsn81A0N5nKOCmRULLBDdB6fwLc2UV8i1ygodh1p0=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106426676885250787081/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106426676885250787081/reviews');
SET @user_ekaterina_hag = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106426676885250787081/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tal Schechter', 'https://lh3.googleusercontent.com/a-/ALV-UjUDjsFOVP7GjH0pVePsWRk3xFGYukEJ7gBQ6UqqCvIrH5fVo-A-=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/116387010963421644160/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116387010963421644160/reviews');
SET @user_tal_schechter = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116387010963421644160/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'lynne adams', 'https://lh3.googleusercontent.com/a/ACg8ocJJ9Qg9C2HKRuJOJPQcbWKW6xke25aZmOqmqTQV7yy4VNKaaw=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/103567563559837927297/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103567563559837927297/reviews');
SET @user_lynne_adams = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103567563559837927297/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Krsto Mačić', 'https://lh3.googleusercontent.com/a/ACg8ocK4nmINQCCJx8ip_2slTM0-WMYYF33KOryA7xX1Q_6AEPxl=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/109572766567670569159/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109572766567670569159/reviews');
SET @user_krsto_mai = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109572766567670569159/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pavel Ostrikov', 'https://lh3.googleusercontent.com/a-/ALV-UjWosqqnyn4Q2nUrzwyPXCMzsSp2jqc4eVPyu0hMmPsOkTzMB4c=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104701188987187041408/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104701188987187041408/reviews');
SET @user_pavel_ostrikov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104701188987187041408/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Максим Олейник', 'https://lh3.googleusercontent.com/a-/ALV-UjURPyXCBBjridttEsU8ph2OTA9rnZz8bayfZBv5-5SS4edbUBOh=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/104694894536417289636/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104694894536417289636/reviews');
SET @user_maksim_oleynik = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104694894536417289636/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandar Stevanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVze_6gqYFlvsF0bC50EqDIlrfaiJHOjZVVOlWT4Z7ltZTw-Dbd=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/112031036415036960252/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112031036415036960252/reviews');
SET @user_aleksandar_stevanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112031036415036960252/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Denis Anufriev', 'https://lh3.googleusercontent.com/a-/ALV-UjWSyLI56Q_fAxq9iqo-yNpnsiCRanrFRyhbty_8zLMhuJDhEqJRXA=w36-h36-p-rp-mo-ba5-br100', 'https://www.google.com/maps/contrib/100709153672430823408/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100709153672430823408/reviews');
SET @user_denis_anufriev = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100709153672430823408/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Djurdja Vukicevic exNokovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUGB-6hOel7MksvxX4Sgf3xpborAfCXaGnpiA6pRFCUaSQ2__kB=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/114492417268137291019/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114492417268137291019/reviews');
SET @user_djurdja_vukicevic_exnokovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114492417268137291019/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stefi 333', 'https://lh3.googleusercontent.com/a/ACg8ocJk8eT0RImmLGO1BgsRQZoWe2UIOR50dTUmYdcOApOoZAV6Dg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107266104910206464913/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107266104910206464913/reviews');
SET @user_stefi_333 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107266104910206464913/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Snezana Mijanovic', 'https://lh3.googleusercontent.com/a/ACg8ocKhZcnL5RLKEe0G5at3-msuYTNU0qRa7Jvak9xkJV4UwLS3oQ=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/104128534535524874665/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104128534535524874665/reviews');
SET @user_snezana_mijanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104128534535524874665/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Helg Berg (HelgBergStudioTravel)', 'https://lh3.googleusercontent.com/a-/ALV-UjWpwK8wsqnH-742axlqjM62EJck1a70J6gkLNpoJuKBrY0_-ZaQSQ=w36-h36-p-rp-mo-ba6-br100', 'https://www.google.com/maps/contrib/100236977328085680715/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100236977328085680715/reviews');
SET @user_helg_berg_helgbergstudiotravel = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100236977328085680715/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'HelgBergStudio. OÜ', 'https://lh3.googleusercontent.com/a-/ALV-UjX3ITmfZfmUUukQD26BeFN0wt2wi1mOrUVpTaKFJuRgPlus3Y7C=w36-h36-p-rp-mo-ba5-br100', 'https://www.google.com/maps/contrib/105278769853207279240/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105278769853207279240/reviews');
SET @user_helgbergstudio_o = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105278769853207279240/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Perovic', 'https://lh3.googleusercontent.com/a/ACg8ocJsbb3aB6MB028iTFWwjXc_sgfBSY_2am9tVCfjrYxffJFAqw=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/117728600112200899648/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117728600112200899648/reviews');
SET @user_nikola_perovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117728600112200899648/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Євгенія Mesh', 'https://lh3.googleusercontent.com/a-/ALV-UjVxGixkpR499jIFz7srhAs2VZ7VsygZz1sD5eN8A6I67S5RDEJyxg=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/102406016308754587147/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102406016308754587147/reviews');
SET @user_yevgeniya_mesh = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102406016308754587147/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Darina Serova', 'https://lh3.googleusercontent.com/a-/ALV-UjXw0nyeY-9TLtYilvLi0f5YoivS4qEfcq59zQTkjL-Y9WVMwpjp=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/115348909295963659061/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115348909295963659061/reviews');
SET @user_darina_serova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115348909295963659061/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ALEKSEI IVANOV', 'https://lh3.googleusercontent.com/a/ACg8ocIwZLcFXxD7wOo5xtHPSck6qsDCpiXeip_MEfoEud1H_vx3MA=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/113943532459899717060/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113943532459899717060/reviews');
SET @user_aleksei_ivanov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113943532459899717060/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Helen Kõiva', 'https://lh3.googleusercontent.com/a-/ALV-UjVlJb4X4psUtYhhmoAYxyR7icoUsqVhKxLcyUO-l0eEyYgCMZY8=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/108210282619225220160/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108210282619225220160/reviews');
SET @user_helen_kiva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108210282619225220160/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, '5H Habits, health, hobbies,happiness & help', 'https://lh3.googleusercontent.com/a-/ALV-UjVRpp5ZRdnESHBEtJQ5e7sGaSE9YfI8lIskmvnsyb55x0O_nNCJ=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/113207405222297389467/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113207405222297389467/reviews');
SET @user_5h_habits_health_hobbieshappiness_help = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113207405222297389467/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladimir Tadić', 'https://lh3.googleusercontent.com/a/ACg8ocJproLi92XQUn9XzQ2WYkJJvN7vqTSi1ij_kLhcXbmJZUfbsQ=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/111301082593753729776/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111301082593753729776/reviews');
SET @user_vladimir_tadi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111301082593753729776/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'שמעון שכטר', 'https://lh3.googleusercontent.com/a/ACg8ocI10TZPqAJ6OCdN0NllB_TWX1Qz9IQGx6HRdcgj9IN-vvkABuFW=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102823723804311338015/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102823723804311338015/reviews');
SET @user_user_102823723804311338015 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102823723804311338015/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'מעיין עזרא', 'https://lh3.googleusercontent.com/a-/ALV-UjXVacjeFA2yWdMsx0ilK7khKoOHSq2Pk1q1eDLY6fnv-MDJWE0=w36-h36-p-rp-mo-ba5-br100', 'https://www.google.com/maps/contrib/110987590813180932193/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110987590813180932193/reviews');
SET @user_user_110987590813180932193 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110987590813180932193/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'İlhan Aydin', 'https://lh3.googleusercontent.com/a-/ALV-UjUuCtaePVNQf7cFyEtmppcq7M-G0jFz6T0QIPC8XF2dRSbGAiEg=w36-h36-p-rp-mo-ba5-br100', 'https://www.google.com/maps/contrib/117756736672953849312/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117756736672953849312/reviews');
SET @user_lhan_aydin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117756736672953849312/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Олесь Олесь', 'https://lh3.googleusercontent.com/a/ACg8ocJFOGW78zLFeVGCbUL1EchiDv7l6FO_iCgcsPAYqHgxL45-Uw=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/103186278169155689069/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103186278169155689069/reviews');
SET @user_oles_oles = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103186278169155689069/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zarina', 'https://lh3.googleusercontent.com/a-/ALV-UjUCw2vrEBhb6U046uWyjsDda2pL6sj9sLiXvMijbjXnlG5pSIPVnw=w36-h36-p-rp-mo-ba7-br100', 'https://www.google.com/maps/contrib/103696902495547969115/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103696902495547969115/reviews');
SET @user_zarina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103696902495547969115/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Josef Černý', 'https://lh3.googleusercontent.com/a/ACg8ocJ5D2rWOn8p5D39SZCQWaWSg-IBMog5GNQlp0sJqhUeEVZA4Q=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/113947272903604526642/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113947272903604526642/reviews');
SET @user_josef_ern = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113947272903604526642/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radmila Rada', 'https://lh3.googleusercontent.com/a/ACg8ocKaQ1akG8tBP0gNcQskk10A0zdlA6k2bF-ZHRbVYOIS-vPZ7A=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/114435558354333013600/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114435558354333013600/reviews');
SET @user_radmila_rada = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114435558354333013600/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mina Eva Demiroglu', 'https://lh3.googleusercontent.com/a-/ALV-UjXPnSpmY9wF8IYGrMr1K9yLWQP6JYFIDW-Vk9Ook7MGDK1yMozp=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/114711910246323654699/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114711910246323654699/reviews');
SET @user_mina_eva_demiroglu = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114711910246323654699/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Irena Kvesić', 'https://lh3.googleusercontent.com/a/ACg8ocKiVGb3UoHGhNYoUn_NYnS0wWBqdEuxTbEB3bbqvaBlF5E4dQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104558295757943419572/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104558295757943419572/reviews');
SET @user_irena_kvesi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104558295757943419572/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zoran Dragovic', 'https://lh3.googleusercontent.com/a/ACg8ocLTMiLd_ppBkDVM8XPG7Jz2fwdrYkSqIUvOijvHvrfHe_S2ww=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/103891635451733655720/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103891635451733655720/reviews');
SET @user_zoran_dragovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103891635451733655720/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ирина Кононова', 'https://lh3.googleusercontent.com/a/ACg8ocJpq4Q_OZrcsq8jHtiGXCmH6YjSohrBXfgNJeDsaS095jdoRw=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/103323196773577464313/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103323196773577464313/reviews');
SET @user_irina_kononova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103323196773577464313/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Romain Boitard', 'https://lh3.googleusercontent.com/a/ACg8ocJHjgxZd-CIeQeta_e1fHRnGiBsjQ7Irzo9ilCegHZtmrsTgg=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/114131595309704760979/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114131595309704760979/reviews');
SET @user_romain_boitard = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114131595309704760979/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kuzey Sütcü', 'https://lh3.googleusercontent.com/a-/ALV-UjW2j72Bxz5cotsIrZ9cuDwfAoxocPCi1iK-dFUd5NnNuYb8dpnf=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/107965086895389495271/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107965086895389495271/reviews');
SET @user_kuzey_stc = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107965086895389495271/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'J B', 'https://lh3.googleusercontent.com/a/ACg8ocLzYZ9zGSQbqaBRNTtyw7BXeD4Z5b9IzpX4gYrQ2zAVJXstOg=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/109932325684800266848/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109932325684800266848/reviews');
SET @user_j_b = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109932325684800266848/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mariia Sizikova', 'https://lh3.googleusercontent.com/a-/ALV-UjU6Zemm2dvlRNINhFKQZDERKGqzc5TtFJYv1BB8f5ezvWvQ5Cns=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/106358079005665109564/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106358079005665109564/reviews');
SET @user_mariia_sizikova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106358079005665109564/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dr Predrag Vasic', 'https://lh3.googleusercontent.com/a-/ALV-UjWEd0ZpQDs9JFBPclCq1XxB1IvD0ghqeIosYoK9Jhhm7wL7QbsKdw=w36-h36-p-rp-mo-ba6-br100', 'https://www.google.com/maps/contrib/106064866776189340794/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106064866776189340794/reviews');
SET @user_dr_predrag_vasic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106064866776189340794/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ekaterina Evdokimova', 'https://lh3.googleusercontent.com/a-/ALV-UjUsGhBeeH2EW-cc4NuM8sZATPw_p4nCxe8D9ZfyXIm2hVKrMRxD=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117190912975422440909/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117190912975422440909/reviews');
SET @user_ekaterina_evdokimova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117190912975422440909/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Адвокат Андрусенко Даріюш', 'https://lh3.googleusercontent.com/a-/ALV-UjXcXjb3EOe3oQqYyPQDBeSPnF9xnb94dc2Ib52_GdpJxlRnC10=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107511681438279278102/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107511681438279278102/reviews');
SET @user_advokat_andrusenko_dariyush = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107511681438279278102/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Lu', 'https://lh3.googleusercontent.com/a-/ALV-UjVJ3B0ka2W5FJXftzUtKfw2FHcAPZwgw51f6WYVPlO1Zd3lYhI=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105411075900690398977/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105411075900690398977/reviews');
SET @user_jelena_lu = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105411075900690398977/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Redas Klionovskis', 'https://lh3.googleusercontent.com/a-/ALV-UjVngVxYO3uE80Ff9esMazsTVXmpqCaeiwGL7QYqK0bYNzd1Ts1t=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104712389866492464425/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104712389866492464425/reviews');
SET @user_redas_klionovskis = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104712389866492464425/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Murat Kurtaran', 'https://lh3.googleusercontent.com/a/ACg8ocKzzdiff9H-ZXK4m0ky_fJA_GcEgkp2aTcrIrxCJv_kAzIJPw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116843452005317673043/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116843452005317673043/reviews');
SET @user_murat_kurtaran = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116843452005317673043/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'בני א.', 'https://lh3.googleusercontent.com/a-/ALV-UjWhTL9pAVp3NO7qEzjLBeoS_Je8xRvUx_QFM2USSTQIZqdpjuXf=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/105431582554055225073/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105431582554055225073/reviews');
SET @user_user_105431582554055225073 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105431582554055225073/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'טיולים בבולגריה וסרביה ארז פייביש', 'https://lh3.googleusercontent.com/a-/ALV-UjW1ya0ylVOxzKCLMOYMS_2wjtfgmcXdCxMc5iBq9FrXXtONJKDxCg=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/116494655100037688803/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116494655100037688803/reviews');
SET @user_user_116494655100037688803 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116494655100037688803/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Laura Lobmaier', 'https://lh3.googleusercontent.com/a-/ALV-UjUc6HQzWltp5Ld9SGBhAyVqf_dYmDHA__aA8W5U9NikTEn-2q6F=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/108838850146725077406/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108838850146725077406/reviews');
SET @user_laura_lobmaier = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108838850146725077406/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Adam Cullen', 'https://lh3.googleusercontent.com/a-/ALV-UjUV4tsgG2zCETuwgd7tZlCL09DsWlA5WzKLOCtHVawbT2RsOJQL=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/105545005308829136430/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105545005308829136430/reviews');
SET @user_adam_cullen = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105545005308829136430/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Oleksandr', 'https://lh3.googleusercontent.com/a/ACg8ocIAsxIX-aw9Mgj-C5TjZySRfTjUxWWkjrqUGYx9t5Hfww2Z2Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110782919911623005007/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110782919911623005007/reviews');
SET @user_oleksandr = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110782919911623005007/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ahmet BABA', 'https://lh3.googleusercontent.com/a-/ALV-UjVsVaLgdnobU2hoIP3mD_pqzsyZzPVQ6BEMc6_za_5piIK0eFrmHg=w36-h36-p-rp-mo-ba5-br100', 'https://www.google.com/maps/contrib/104108280126606184823/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104108280126606184823/reviews');
SET @user_ahmet_baba = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104108280126606184823/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivona R', 'https://lh3.googleusercontent.com/a/ACg8ocLhEy4-eQFE8KMqLdqwP5OOgZwHFNeSD7s0sH559bRV9bewrw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104531566226869039584/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104531566226869039584/reviews');
SET @user_ivona_r = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104531566226869039584/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lesia Melnychenko', 'https://lh3.googleusercontent.com/a-/ALV-UjXuRUIcr9PLOteLfhBKVh9p6rJ11Y5JqTR1wCi5QkwhxtRafu0s=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/106642596096185599860/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106642596096185599860/reviews');
SET @user_lesia_melnychenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106642596096185599860/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sessiz Rota', 'https://lh3.googleusercontent.com/a-/ALV-UjXYMU91kHe_gdl_XJV5ZfzEbHJ907Y7DeRXdFUUqdGpE0gKNfo=w36-h36-p-rp-mo-ba5-br100', 'https://www.google.com/maps/contrib/105710255697049231535/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105710255697049231535/reviews');
SET @user_sessiz_rota = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105710255697049231535/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Уфимцев Егор', 'https://lh3.googleusercontent.com/a/ACg8ocLWMkr7LTtsePJdMNn_yNNUhQuTUHFDdkLTMv3AAISh1Enljg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103810114133632202955/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103810114133632202955/reviews');
SET @user_ufimtsev_egor = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103810114133632202955/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Svetlana', 'https://lh3.googleusercontent.com/a-/ALV-UjV-eRHqpH2--t8gdd8uFNiczoIexRqygTfppSBxomDDNYTIwPwXcg=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/107607884969494340732/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107607884969494340732/reviews');
SET @user_svetlana = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107607884969494340732/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alessandro Rivale', 'https://lh3.googleusercontent.com/a-/ALV-UjXQ9ceecTvGJ6BXVE-oKdg4lx-Yzb6u28Y-wyFijg1KciB8PQ4QRw=w36-h36-p-rp-mo-ba5-br100', 'https://www.google.com/maps/contrib/101369113500736139115/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101369113500736139115/reviews');
SET @user_alessandro_rivale = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101369113500736139115/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andrey Kuznetsov', 'https://lh3.googleusercontent.com/a-/ALV-UjWl1s3IxCIqlHVRKAmUYrloP8bT8ZVRKPqpfM3VdZac_yizbKOWwg=w36-h36-p-rp-mo-ba5-br100', 'https://www.google.com/maps/contrib/116138991211381099204/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116138991211381099204/reviews');
SET @user_andrey_kuznetsov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116138991211381099204/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ольга Бальс', 'https://lh3.googleusercontent.com/a-/ALV-UjUbgG978FhHMaK7caFydU0hYHhcv-kFNQppj5hhGSTKmvg82pY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107978225267383009429/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107978225267383009429/reviews');
SET @user_olga_bals = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107978225267383009429/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'אסנת חנינה', 'https://lh3.googleusercontent.com/a/ACg8ocKIBqfuFb6wa5QUUQoeWU6lD7gSwmFxnnRO6SqFAQq6gzVJxA=w36-h36-p-rp-mo-ba5-br100', 'https://www.google.com/maps/contrib/117087516023669088637/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117087516023669088637/reviews');
SET @user_user_117087516023669088637 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117087516023669088637/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Михаил Мотов', 'https://lh3.googleusercontent.com/a/ACg8ocIyvEIOZg1FMyuAd3P_POvfY-K-TAGN_54IwbZ0UC8wFTZ6Ow=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/108027661954216454199/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108027661954216454199/reviews');
SET @user_mikhail_motov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108027661954216454199/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'One Friday', 'https://lh3.googleusercontent.com/a-/ALV-UjUXylDsqS7eQDcXXXQY7fFxni6FvSN_xRztAvS4jTiGOPDf2V5M7Q=w36-h36-p-rp-mo-ba6-br100', 'https://www.google.com/maps/contrib/114790774527668029825/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114790774527668029825/reviews');
SET @user_one_friday = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114790774527668029825/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Borislav Kovacevic', 'https://lh3.googleusercontent.com/a/ACg8ocJrGzvGcvD6pfDjifbnDDT3F0JyvcrZ_jUoFMDkb7cY4ohoAQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103847314094494695374/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103847314094494695374/reviews');
SET @user_borislav_kovacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103847314094494695374/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Оксана Нещадина', 'https://lh3.googleusercontent.com/a-/ALV-UjXtXTWyCrJ-VkrlWXFJwsQuJmGRDUTKq5R3Gbzy_RcPQYQHPwo=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/108419372144713400108/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108419372144713400108/reviews');
SET @user_oksana_neshchadina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108419372144713400108/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Татьяна Лебедева', 'https://lh3.googleusercontent.com/a/ACg8ocIFd0ZSeCeI3DaWjZNDBz8lFjxMB1-l810TvLd8buUyGRa6Sg=w36-h36-p-rp-mo-ba6-br100', 'https://www.google.com/maps/contrib/111682193930358352377/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111682193930358352377/reviews');
SET @user_tatyana_lebedeva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111682193930358352377/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Darja', 'https://lh3.googleusercontent.com/a-/ALV-UjUy-40cgoz06aF8oeskkbtMWMIAL01qHYfJZUKmVGNdT91Jz8tr=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108144178989734609169/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108144178989734609169/reviews');
SET @user_darja = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108144178989734609169/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'М г', 'https://lh3.googleusercontent.com/a-/ALV-UjVJ27BEt7poGjRR5Ot1IYIigGBdPlO5uybDYmBImPSPmpCdPHDH=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111932600141911906287/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111932600141911906287/reviews');
SET @user_m_g = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111932600141911906287/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Caro H', 'https://lh3.googleusercontent.com/a-/ALV-UjVuxlmTVnizcoIykTON_snL6zdjXoQo1HIk_bt77THgOmg0KIsmhg=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/116037120179926795645/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116037120179926795645/reviews');
SET @user_caro_h = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116037120179926795645/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Вадим Гавриш', 'https://lh3.googleusercontent.com/a-/ALV-UjUMRTYXEIFOTjAqQjC3_jqq3ogH5UlXbNQgFtDW8F-5KDrLWYVG=w36-h36-p-rp-mo-ba5-br100', 'https://www.google.com/maps/contrib/116890666678689234084/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116890666678689234084/reviews');
SET @user_vadim_gavrish = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116890666678689234084/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'VADIM CREATOR', 'https://lh3.googleusercontent.com/a-/ALV-UjXRv3ncHv0AwnmqgREs6yJhr3ucOtmNhYoIDbhZMcERnexHy2kw=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/100127974979791283412/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100127974979791283412/reviews');
SET @user_vadim_creator = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100127974979791283412/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vadim Bogdanov', 'https://lh3.googleusercontent.com/a-/ALV-UjXfSoCnr2j_ddvvbYnuWSS0NgjTdbCILYqEUzX4I7hKDg_UXG0X=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/118360682332807476439/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118360682332807476439/reviews');
SET @user_vadim_bogdanov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118360682332807476439/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jabbo', 'https://lh3.googleusercontent.com/a/ACg8ocJ_fzEmj3qqLcZJ6B3pyEknkUnxoBOZvS3rwJyQfBSvG_AMNA=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/105873764657457464880/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105873764657457464880/reviews');
SET @user_jabbo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105873764657457464880/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'אסנת כהן', 'https://lh3.googleusercontent.com/a-/ALV-UjUEG-MM9yx4VqJODblXX1RyvJS5TtSr_BusdGhcN4KniZkt70s=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/106866786942202092855/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106866786942202092855/reviews');
SET @user_user_106866786942202092855 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106866786942202092855/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sveta Svetik', 'https://lh3.googleusercontent.com/a/ACg8ocJ3O1xB0DYGSoiKpZjfmRR1kLQUKcyuAa7elQCzjI_xg1MF1w=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/109122316831459837915/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109122316831459837915/reviews');
SET @user_sveta_svetik = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109122316831459837915/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'יוסי קטיפה', 'https://lh3.googleusercontent.com/a-/ALV-UjXkkcEMvGB5fPMvxAuymxJIAuGL6gVLpPf7xbjDyUI8mvEFiVwfUQ=w36-h36-p-rp-mo-ba5-br100', 'https://www.google.com/maps/contrib/110869791883263964323/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110869791883263964323/reviews');
SET @user_user_110869791883263964323 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110869791883263964323/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'yuri vi', 'https://lh3.googleusercontent.com/a-/ALV-UjUZmM4X0X7bNgErtf2qn04SGYDzDzAhaWpC_MpC8EQCyE9xdBXU=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105580499022409771949/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105580499022409771949/reviews');
SET @user_yuri_vi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105580499022409771949/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Isilay Undemir', 'https://lh3.googleusercontent.com/a-/ALV-UjXL_GHybSFRYK1D1OZCN2ELlFeK0c-wBkvAy9bGHmbRR7mkbYDt=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110007520447825677172/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110007520447825677172/reviews');
SET @user_isilay_undemir = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110007520447825677172/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Kustudic', 'https://lh3.googleusercontent.com/a-/ALV-UjWCd_6_t1wd_f11JvH3x5_O1_2VytnYxtZgJSpJSHXgvPdu0DQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106237475868107701520/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106237475868107701520/reviews');
SET @user_marko_kustudic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106237475868107701520/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ADRIATICPOINT CONSTRUCTION MONTENEGRO', 'https://lh3.googleusercontent.com/a-/ALV-UjVlTpo1ogHRhuP6l0q1przS2FwXIvldIxOF4oSHdTd5wo8wAwnN=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106994443511974375931/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106994443511974375931/reviews');
SET @user_adriaticpoint_construction_montenegro = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106994443511974375931/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Doruk Uenal', 'https://lh3.googleusercontent.com/a-/ALV-UjWDo-U9rtQWFgMcEx84yRSYe1yxNJ03zCxPazngKgenUSeb8bMC=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117114557846975841421/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117114557846975841421/reviews');
SET @user_doruk_uenal = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117114557846975841421/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Delfo Hagen', 'https://lh3.googleusercontent.com/a-/ALV-UjWoj6roq4S3LgYDQUoq6TPWGD0vEigNp6yRgkz-2XwIvPZvPogg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113818142236077046520/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113818142236077046520/reviews');
SET @user_delfo_hagen = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113818142236077046520/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zoran', 'https://lh3.googleusercontent.com/a/ACg8ocI9nH0a6ordA3_js4FMcfTTVy4YIFvpGM0qXtGgIxqXz0Eefw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113130476448276204866/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113130476448276204866/reviews');
SET @user_zoran = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113130476448276204866/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olga', 'https://lh3.googleusercontent.com/a/ACg8ocJfihZxTTALZQzAnHFBEpCKKpZqI4-xdc6yMDRZBdE8sFwooko=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/104982697213158443006/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104982697213158443006/reviews');
SET @user_olga = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104982697213158443006/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_radoje_nikolic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT25OS01tTkNSbWxmVHpGMVNsbEVOMjlUUm5CWk5IYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, NULL),

(@user_konstantin, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twd1MwZEhVRXQ1U1dVeVNuRlFRMlUzTmt4d2NVRRAB',
    2, 'ru', 'Сходил на анализ крови, получил "наркоманский" синяк на память.
Спасибо медсестрам Mojlab за мой новый образ!!!',
    'Otišao sam na analizu krvi, dobio "narkomansku" modrice za uspomenu.
Hvala medicinskim sestrama Mojlab na mom novom izgledu!!!', 'Отишао сам на анализу крви, добио "нарkomанску" модрицу за успомену.
Хвала медицинским сестрама Mojlab на мом новом изгледу!!!', 'Went for a blood test, got a "junkie" bruise as a souvenir.
Thanks to the nurses at Mojlab for my new look!!!', 'Сходил на анализ крови, получил "наркоманский" синяк на память.
Спасибо медсестрам Mojlab за мой новый образ!!!', 'Ich war zur Blutentnahme, habe mir als Erinnerung einen "Junkies"-Bluterguss geholt.
Danke den Krankenschwestern von Mojlab für mein neues Aussehen!!!', 'Kan tahlili için gittim, hatıra olarak "eroin bağımlısı" morluğu kazandım.
Mojlab\'ın hemşirelerine yeni görünümüm için teşekkürler!!!',
    0, '2026-03-21 00:00:00'),

(@user_nevena_jovanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pCRWVGRnRVa0ZITkRKR1YzbzBXbFJEWldwb1duYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-02-24 00:00:00'),

(@user_ekaterina_ivanova, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT210bFRrOUdNSEpGZFVaM1Ftb3RlbU5uVERaRFZGRRAB',
    5, 'ru', 'Приятные сотрудники в лаборатории, результаты анализов быстро приходят на почту.',
    'Prijatno osoblje u laboratoriji, rezultati analiza brzo stižu na e-mail.', 'Пријатно особље у лабораторији, резултати анализа брзо стижу на е-мејл.', 'Pleasant staff at the laboratory, test results arrive quickly by email.', 'Приятные сотрудники в лаборатории, результаты анализов быстро приходят на почту.', 'Angenehmes Personal im Labor, Testergebnisse kommen schnell per E-Mail.', 'Laboratuvarda hoş personel, tahlil sonuçları e-postaya hızlı geliyor.',
    0, '2026-02-24 00:00:00'),

(@user_luka_mikovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT25sWFFUWmtlalJIYlRoaVNEaDFhbVV0ZW1SNVFsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-02-24 00:00:00'),

(@user_marija_velickovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT25BNWNXMDFSQzF1Y3pGMVVuQmtWbk5rYms5WE9FRRAB',
    1, 'hr', 'Ne preporučujem ovu kliniku jer su neodgovorni .Jedno ti kažu kad plaćas i onda čekaj',
    'Ne preporučujem ovu kliniku jer su neodgovorni .Jedno ti kažu kad plaćas i onda čekaj', 'Не препоручујем ову клинику јер су неодговорни. Једно ти кажу кад плаћаш и онда чекај.', 'I do not recommend this clinic because they are irresponsible. They tell you one thing when you pay and then you wait.', 'Не рекомендую эту клинику, так как они безответственны. Говорят одно, когда платишь, а потом жди.', 'Ich empfehle diese Klinik nicht, da sie unverantwortlich sind. Sie sagen dir eines, wenn du zahlst, und dann wartest du.', 'Bu kliniği önermiyorum çünkü sorumsuzlar. Ödeme yaparken bir şey söylüyorlar, sonra bekliyorsunuz.',
    0, '2026-01-24 00:00:00'),

(@user_sara_gabr, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT20xSlJtbHRVbTVETkc1alQxZEtTMTkwWlVwZlNIYxAB',
    1, 'en', 'How could they refused to help a pregnant woman to get her daily injection even when they have all the local government documents. No morals',
    'Kako su mogli odbiti pomoć trudnici da dobije svoju dnevnu injekciju čak i kada imaju sve lokalne vladine dokumente. Nikakav moral.', 'Како су могли одбити помоћ трудници да добије своју дневну ињекцију чак и када имају све локалне владине документе. Никакав морал.', 'How could they refused to help a pregnant woman to get her daily injection even when they have all the local government documents. No morals', 'Как они могли отказать беременной женщине в ежедневной инъекции, даже при наличии всех документов от местных органов власти. Никакой морали.', 'Wie konnten sie einer schwangeren Frau ihre tägliche Injektion verweigern, obwohl alle behördlichen Dokumente vorlagen. Keine Moral.', 'Tüm yerel hükümet belgelerine sahip olmalarına rağmen hamile bir kadına günlük enjeksiyonunu yaptırmayı nasıl reddedebilirler. Ahlaktan yoksunlar.',
    0, '2026-01-24 00:00:00'),

(@user_vladimir_vukmirovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tsUWIyTTFOSFF0UzBneGEwcGZaaTFTU25sdk9WRRAB',
    1, 'hr', 'Najgora moguća ustanova. Kao i osoblje. Izbjegavati ih!',
    'Najgora moguća ustanova. Kao i osoblje. Izbjegavati ih!', 'Најгора могућа установа. Као и особље. Избегавати их!', 'The worst possible institution. Same goes for the staff. Avoid them!', 'Худшее заведение из возможных. Как и персонал. Избегайте их!', 'Die schlimmste mögliche Einrichtung. Wie auch das Personal. Meidet sie!', 'Mümkün olan en kötü kurum. Personel de aynı şekilde. Onlardan uzak durun!',
    0, '2025-12-24 00:00:00'),

(@user_kristina_kuburovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWRk1XeDNjR1F5UmpOMlVYaHRRalZ1Vms5Q09HYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-24 00:00:00'),

(@user_an_buf, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t0c1pWVjZYMmN6VDJJMGFuQkZiM1JQTkY4eVRFRRAB',
    1, 'ru', 'Ни разу, ни разу вовремя не приняли в этом заведении. Сейчас вообще с острой болью по записи и приходится ждать двух людей.',
    'Ni jednom, ni jednom me nisu primili na vreme u ovoj ustanovi. Sada sam čak i sa akutnim bolom po zakazanom terminu i moram da čekam dvoje ljudi.', 'Ни једном, ни једном ме нису примили на вријеме у овој установи. Сада сам чак и са акутним болом по заказаном термину и морам да чекам двоје људи.', 'Not once, not once have they seen me on time in this establishment. Now even with acute pain and an appointment I have to wait for two people ahead of me.', 'Ни разу, ни разу вовремя не приняли в этом заведении. Сейчас вообще с острой болью по записи и приходится ждать двух людей.', 'Kein einziges Mal, kein einziges Mal haben sie mich in dieser Einrichtung pünktlich empfangen. Jetzt muss ich sogar mit akuten Schmerzen mit Termin noch auf zwei Personen warten.', 'Bu kurumda hiç, hiç zamanında kabul edilmedim. Şimdi ise akut ağrıyla randevulu geldim ve iki kişiyi beklemek zorundayım.',
    0, '2025-11-24 00:00:00'),

(@user_olga_kuznetsova, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT25oME5rWlhhMDlITkRaSGNqQnBaV2xXYzNkb2RWRRAB',
    5, 'ru', 'Все быстро без очереди взяли анализы. Говорят на Английском. Прислали результаты на почту быстро и во время. Очень милые девушки работают. Ценник адекватный.',
    'Sve brzo, bez reda uzeli su uzorke. Govore engleski. Rezultate su brzo i na vreme poslali na e-mail. Rade veoma ljubazne devojke. Cene su pristupačne.', 'Све брзо, без реда узели су узорке. Говоре енглески. Резултате су брзо и на вријеме послали на е-мејл. Раде веома љубазне дјевојке. Цијене су приступачне.', 'Everything was quick, no queue for the tests. They speak English. Sent the results by email quickly and on time. Very nice girls work there. Prices are reasonable.', 'Все быстро без очереди взяли анализы. Говорят на Английском. Прислали результаты на почту быстро и во время. Очень милые девушки работают. Ценник адекватный.', 'Alles schnell, ohne Warteschlange wurden die Tests gemacht. Sie sprechen Englisch. Die Ergebnisse wurden schnell und pünktlich per E-Mail zugeschickt. Sehr nette Mädchen arbeiten dort. Preise sind angemessen.', 'Her şey hızlı, sıra beklemeden tahliller alındı. İngilizce konuşuyorlar. Sonuçları e-posta ile hızlı ve zamanında gönderdiler. Çok güzel kızlar çalışıyor. Fiyatlar makul.',
    0, '2025-11-24 00:00:00'),

(@user_vadim_smirnov, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT25OYWNUbFZjVmx6UVRRMk9EZHhlVEl5UjNoamQxRRAB',
    5, 'ru', 'Через страховую делал здесь рентген. Сделали оперативно.',
    'Kroz osiguranje sam ovde radio rendgen. Uradili su ga brzo.', 'Кроз осигурање сам овдје радио рендген. Урадили су га брзо.', 'Had an X-ray done here through insurance. They did it promptly.', 'Через страховую делал здесь рентген. Сделали оперативно.', 'Habe hier über die Versicherung ein Röntgenbild machen lassen. Es wurde prompt erledigt.', 'Sigortam aracılığıyla burada röntgen çektirdim. Hızlı bir şekilde yaptılar.',
    0, '2025-10-24 00:00:00'),

(@user_milan_ivkov, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSamVrTTNSVXhwWVUxdVJVazVjMHBtU0RKdlIzYxAB',
    5, 'bs', 'Sve pohvale za tim! Čisto, uredno, ljubazno, profesionalno, empatija za 10.
Ako već morate, dođite ovde, provereno viŝe puta..',
    'Sve pohvale za tim! Čisto, uredno, ljubazno, profesionalno, empatija za 10.
Ako već morate, dođite ovde, provereno viŝe puta..', 'Све похвале за тим! Чисто, уредно, љубазно, професионално, емпатија за 10.
Ако већ морате, дођите овде, проверено више пута..', 'All praise to the team! Clean, tidy, friendly, professional, empathy 10/10.
If you must go somewhere, come here, proven multiple times..', 'Все хвалю команду! Чисто, аккуратно, вежливо, профессионально, эмпатия на 10.
Если уж нужно, приходите сюда, проверено не раз..', 'Alles Lob für das Team! Sauber, ordentlich, freundlich, professionell, Empathie auf 10.
Wenn ihr schon müsst, kommt hierher, mehrfach bewährt..', 'Ekibe her türlü övgü! Temiz, düzenli, nazik, profesyonel, empati 10/10.
Eğer gitmeniz gerekiyorsa, buraya gelin, defalarca kanıtlandı..',
    0, '2025-09-24 00:00:00'),

(@user_semenova_ekaterina, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSNU1tOU5WemxHTFV0YU5sVjVTSEowWjJNNFNXYxAB',
    5, 'en', 'Very helpful and friendly pediators, who really cares. Doctor can find right words for teen-ager for brief and friendly explanation about skin condition and care. …',
    'Veoma korisni i prijatni pedijatri, kojima je zaista stalo. Doktor zna da nađe prave reči za tinejdžere za kratko i prijatno objašnjenje o stanju kože i nezi. …', 'Веома корисни и пријатни педијатри, којима је заиста стало. Доктор зна да нађе праве речи за тинејџере за кратко и пријатно објашњење о стању коже и њези. …', 'Very helpful and friendly pediators, who really cares. Doctor can find right words for teen-ager for brief and friendly explanation about skin condition and care. …', 'Очень полезные и дружелюбные педиатры, которым действительно не всё равно. Врач умеет найти нужные слова для подростка, кратко и доброжелательно объясняя состояние кожи и уход за ней. …', 'Sehr hilfreiche und freundliche Kinderärzte, denen es wirklich wichtig ist. Der Arzt findet die richtigen Worte für Teenager, um kurz und freundlich den Hautzustand und die Pflege zu erklären. …', 'Gerçekten önem veren çok yardımsever ve dostane pediatristler. Doktor, cilt durumu ve bakımı hakkında kısa ve dostane bir açıklama için gençlere doğru kelimeleri bulmayı biliyor. …',
    0, '2025-09-24 00:00:00'),

(@user_vladimir_ps, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pGMFMwbHlPVjlET0VwWFEybzRaMHBWTmsxVWJVRRAB',
    1, 'ru', 'Не рекомендую обращаться с серьезными проблемами. Супруга была с очевидными признаками аппендицита, сделали осмотр, анализы, УЗИ и прописали только антибиотики. На следующий день пришлось делать срочную операцию уже по дороге в Сербию. Врач, который делал операцию, удивился, что диагноз не поставили раньше.',
    'Ne preporučujem da dolazite sa ozbiljnim problemima. Supruga je imala očigledne simptome appendicitisa, uradili su pregled, analize, ultrazvuk i propisali samo antibiotike. Sledećeg dana morali smo hitnu operaciju već na putu za Srbiju. Hirurg koji je operisao začudio se što dijagnoza nije postavljena ranije.', 'Не препоручујем да долазите са озбиљним проблемима. Супруга је имала очигледне симптоме апендицитиса, урадили су преглед, анализе, ултразвук и прописали само антибиотике. Сљедећег дана морали смо хитну операцију већ на путу за Србију. Хирург који је оперисао зачудио се што дијагноза није постављена раније.', 'I do not recommend coming here with serious problems. My wife had obvious signs of appendicitis — they did an examination, tests, ultrasound, and prescribed only antibiotics. The next day we had to do an emergency surgery on the way to Serbia. The surgeon who operated was surprised the diagnosis had not been made earlier.', 'Не рекомендую обращаться с серьезными проблемами. Супруга была с очевидными признаками аппендицита, сделали осмотр, анализы, УЗИ и прописали только антибиотики. На следующий день пришлось делать срочную операцию уже по дороге в Сербию. Врач, который делал операцию, удивился, что диагноз не поставили раньше.', 'Ich empfehle nicht, mit ernsthaften Problemen hierher zu kommen. Meine Frau hatte offensichtliche Zeichen einer Appendizitis — sie untersuchten sie, machten Tests, Ultraschall und verschrieben nur Antibiotika. Am nächsten Tag musste auf dem Weg nach Serbien eine Notoperation durchgeführt werden. Der Chirurg wunderte sich, dass die Diagnose nicht früher gestellt worden war.', 'Ciddi problemlerle buraya gelmenizi tavsiye etmiyorum. Eşimde bariz apandisit belirtileri vardı — muayene, tahlil, ultrason yaptılar ve yalnızca antibiyotik yazdılar. Ertesi gün Sırbistan\'a giderken acil ameliyat gerekti. Ameliyatı yapan cerrah tanının neden daha önce konulmadığına şaşırdı.',
    0, '2025-08-24 00:00:00'),

(@user_sneza, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5eVEwODVUMFJHVXpsbk9FNXJSa0pCUnpBMlVHYxAB',
    5, 'hr', 'Pohvale za cijeli tim laboratorije,posebno za sestru Mirjanu-Miru 🤗
Uvijek ljubazna,susretljiva i spremna da pomogne u svakoj situaciji. …',
    'Pohvale za cijeli tim laboratorije,posebno za sestru Mirjanu-Miru 🤗
Uvijek ljubazna,susretljiva i spremna da pomogne u svakoj situaciji. …', 'Похвале за цео тим лабораторије, посебно за сестру Мирјану-Миру 🤗
Увек љубазна, сусретљива и спремна да помогне у свакој ситуацији. …', 'Praise for the entire laboratory team, especially for nurse Mirjana-Mira 🤗
Always friendly, accommodating and ready to help in every situation. …', 'Похвала всей команде лаборатории, особенно медсестре Мирьяне-Мире 🤗
Всегда приветливая, отзывчивая и готовая помочь в любой ситуации. …', 'Lob für das gesamte Laborteam, besonders für Krankenschwester Mirjana-Mira 🤗
Immer freundlich, zuvorkommend und bereit in jeder Situation zu helfen. …', 'Laboratuvar ekibinin tamamına övgüler, özellikle hemşire Mirjana-Mira\'ya 🤗
Her zaman nazik, anlayışlı ve her durumda yardıma hazır. …',
    0, '2025-08-24 00:00:00'),

(@user_nikola_knezevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT2taNFdTMW9iWHBJUkZnNFIzUlpNRWx1T0VjMGVGRRAB',
    5, 'bs', 'Odavno vecu ljubaznost i profesionalnost nisam dozivio. Mira, Nadja i Andjela med. sestre koje zrače plemenitoscu i dobrotom. Sve pohvale za njih tri, svaka cast samo nastavite tako!',
    'Odavno vecu ljubaznost i profesionalnost nisam dozivio. Mira, Nadja i Andjela med. sestre koje zrače plemenitoscu i dobrotom. Sve pohvale za njih tri, svaka cast samo nastavite tako!', 'Одавно већу љубазност и професионалност нисам доживео. Mira, Nadja и Andjela мед. сестре које зраче племенитошћу и добротом. Све похвале за њих три, свака част само наставите тако!', 'I haven\'t experienced such kindness and professionalism in a long time. Mira, Nadja and Andjela are medical nurses who radiate nobility and goodness. All praise for those three, well done — just keep it up!', 'Давно не встречал такой вежливости и профессионализма. Mira, Nadja и Andjela — медсёстры, излучающие благородство и доброту. Все хвалы этим троим, так держать!', 'So viel Freundlichkeit und Professionalität habe ich schon lange nicht mehr erlebt. Mira, Nadja und Andjela sind Krankenschwestern, die Adel und Güte ausstrahlen. Alles Lob für diese drei, weiter so!', 'Uzun zamandır bu kadar nezaket ve profesyonellikle karşılaşmamıştım. Mira, Nadja ve Andjela asalet ve iyilik yayan hemşireler. Bu üçüne her türlü övgü, aferin — böyle devam edin!',
    0, '2025-07-24 00:00:00'),

(@user_natasa_boskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSQlRtOXpMWG81U21OclpHRm5PWFUwU1drME1YYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-07-24 00:00:00'),

(@user_serta_hamza, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSVFZrMUNNa2hVVVRSM1dUVnJaMmQxWjBOVFltYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-07-24 00:00:00'),

(@user_marija_kekovic, @clinic_id, @doctor_dragica_becic, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VOaXF6cU9ybk1YclBnEAE',
    5, 'cs', 'Doktorka Becic 👍 …',
    'Doktorka Becic 👍 …', 'Докторка Becic 👍 …', 'Doctor Becic 👍 …', 'Доктор Becic 👍 …', 'Ärztin Becic 👍 …', 'Doktor Becic 👍 …',
    0, '2025-06-24 00:00:00'),

(@user_lejla_vukovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VKSFFvXy1KNXA2VEl3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-06-24 00:00:00'),

(@user_i_dr, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnTUNveXEzZUNBEAE',
    1, 'ru', 'Сдал анализ на антибиотики и бактерии. (он в 4 раза дороже обычного) Через 5 часов прислали общий анализ (который не нужен) с припиской "бактерий не найдено" без количества колоний (CFU/ml). И по протоколу, бактериологический посев выдерживается не менее 24часов. То есть они тупо сделали не тот анализ и наврали что все ок.',
    'Predao sam analizu na antibiotike i bakterije. (ona je 4 puta skuplja od obične) Nakon 5 sati poslali su opštu analizu (koja nije bila potrebna) sa napomenom "bakterije nisu pronađene" bez broja kolonija (CFU/ml). A prema protokolu, bakteriološka kultura se čuva najmanje 24 sata. Znači, jednostavno su uradili pogrešnu analizu i slagali da je sve u redu.', 'Предао сам анализу на антибиотике и бактерије. (она је 4 пута скупља од обичне) Након 5 сати послали су општу анализу (која није била потребна) са напоменом "бактерије нису пронађене" без броја колонија (CFU/ml). А према протоколу, бактериолошка култура се чува најмање 24 сата. Значи, једноставно су урадили погрешну анализу и солгали да је све у реду.', 'I submitted a test for antibiotics and bacteria (it is 4 times more expensive than usual). After 5 hours they sent a general test (which was not needed) with the note "no bacteria found" without colony count (CFU/ml). And according to protocol, a bacteriological culture is kept for at least 24 hours. In other words, they simply did the wrong test and lied that everything was fine.', 'Сдал анализ на антибиотики и бактерии. (он в 4 раза дороже обычного) Через 5 часов прислали общий анализ (который не нужен) с припиской "бактерий не найдено" без количества колоний (CFU/ml). И по протоколу, бактериологический посев выдерживается не менее 24часов. То есть они тупо сделали не тот анализ и наврали что все ок.', 'Ich habe einen Test auf Antibiotika und Bakterien abgegeben. (er ist 4 Mal teurer als der normale) Nach 5 Stunden schickten sie eine allgemeine Analyse (die nicht benötigt wurde) mit dem Vermerk "keine Bakterien gefunden" ohne Kolonienanzahl (CFU/ml). Und laut Protokoll wird eine bakteriologische Kultur mindestens 24 Stunden aufbewahrt. Das heißt, sie haben einfach den falschen Test gemacht und gelogen, dass alles in Ordnung ist.', 'Antibiyotik ve bakteri testi yaptırdım. (normal testın 4 katı pahalı) 5 saat sonra koloni sayısı (CFU/ml) belirtilmeksizin "bakteri bulunamadı" notu ile genel analizi (gerekmeyen) gönderdiler. Protokole göre bakteriyolojik kültür en az 24 saat bekletilir. Yani basitçe yanlış test yaptılar ve her şeyin yolunda olduğunu söylediler.',
    0, '2025-04-24 00:00:00'),

(@user_aleksandra_khristenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnTURJdzdTc2lnRRAB',
    1, 'ru', 'Поход в клинику Maj Lab — настоящая катастрофа. Пришла с подозрением на пневмонию. Врач померила давление, сказала: «Низкое. Горло красное. Думаю, это не пневмония». На этом диагностика могла бы закончиться — она даже не собиралась слушать лёгкие, пока я настойчиво не попросила.

После прослушивания сказала, что слышит хрипы в правом лёгком и «лучше пропить антибиотик». Ни анализов, ни рентгена — просто сразу антибиотик, на глазок. Я настояла на рентгене. Его сделали, но оказалось, что результат и заключение будут готовы только через сутки и пришлют их на почту.

Сутки прошли, прошло уже полтора дня — рентген так и не прислали. Напоминаю: я пришла с подозрением на пневмонию.

75 евро — в никуда. А назначенное лечение больше похоже на гадание на кофейной гуще. Если хотите выбросить деньги и рискнуть здоровьем — вам сюда.',
    'Poseta klinici Maj Lab — prava katastrofa. Došla sam sa sumnjom na upalu pluća. Doktorka je izmerila pritisak i rekla: «Nizak. Grlo crveno. Mislim da nije upala pluća». Na tome bi dijagnostika mogla i da se završi — nije ni nameravala da sluša pluća dok nisam uporno tražila.

Nakon slušanja rekla je da čuje šumove u desnom pluću i «bolje je da popijete antibiotik». Ni analiza, ni rendgena — samo odmah antibiotik, na oko. Insistirala sam na rendgenu. Uradili su ga, ali se ispostavilo da će rezultat i zaključak biti gotovi tek za dan i poslat će ih na e-mail.

Dan je prošao, prošlo je već dan i po — rendgen tako i nije poslat. Podsetiću: došla sam sa sumnjom na upalu pluća.

75 evra — u ništa. A propisano lečenje više liči na gatanje iz taloga kafe. Ako želite da bacite novac i rizikujete zdravlje — dođite ovde.', 'Посета клиници Maj Lab — права катастрофа. Дошла сам са сумњом на упалу плућа. Докторка је измерила притисак и рекла: «Низак. Грло црвено. Мислим да није упала плућа». На томе би дијагностика могла и да се заврши — није ни намеравала да слуша плућа док нисам упорно тражила.

Након слушања рекла је да чује шумове у десном плућу и «боље је да попијете антибиотик». Ни анализа, ни рендгена — само одмах антибиотик, на око. Инсистирала сам на рендгену. Урадили су га, али се испоставило да ће резултат и закључак бити готови тек за дан и послат ће их на е-мејл.

Дан је прошао, прошло је већ дан и по — рендген тако и није послат. Подсетићу: дошла сам са сумњом на упалу плућа.

75 евра — у ништа. А прописано лечење више личи на гатање из талога кафе. Ако желите да бацате новац и ризикујете здравље — дођите овде.', 'A visit to Maj Lab clinic is a real disaster. I came with a suspicion of pneumonia. The doctor measured my blood pressure and said: "Low. Throat is red. I don\'t think it\'s pneumonia." The diagnosis could have ended there — she wasn\'t even going to listen to my lungs until I persistently asked.

After listening she said she heard wheezing in the right lung and "better to take an antibiotic." No tests, no X-ray — just an antibiotic right away, by eye. I insisted on an X-ray. They did it, but it turned out the result and conclusion would only be ready the next day and would be sent by email.

A day passed, then a day and a half — the X-ray was never sent. I remind you: I came with a suspicion of pneumonia.

75 euros — for nothing. And the prescribed treatment looks more like reading coffee grounds. If you want to throw your money away and risk your health — come here.', 'Поход в клинику Maj Lab — настоящая катастрофа. Пришла с подозрением на пневмонию. Врач померила давление, сказала: «Низкое. Горло красное. Думаю, это не пневмония». На этом диагностика могла бы закончиться — она даже не собиралась слушать лёгкие, пока я настойчиво не попросила.

После прослушивания сказала, что слышит хрипы в правом лёгком и «лучше пропить антибиотик». Ни анализов, ни рентгена — просто сразу антибиотик, на глазок. Я настояла на рентгене. Его сделали, но оказалось, что результат и заключение будут готовы только через сутки и пришлют их на почту.

Сутки прошли, прошло уже полтора дня — рентген так и не прислали. Напоминаю: я пришла с подозрением на пневмонию.

75 евро — в никуда. А назначенное лечение больше похоже на гадание на кофейной гуще. Если хотите выбросить деньги и рискнуть здоровьем — вам сюда.', 'Ein Besuch in der Klinik Maj Lab ist eine echte Katastrophe. Ich kam mit dem Verdacht auf Lungenentzündung. Die Ärztin maß meinen Blutdruck und sagte: «Niedrig. Hals ist rot. Ich glaube, es ist keine Lungenentzündung.» Damit hätte die Diagnose enden können — sie wollte gar nicht meine Lunge abhören, bis ich hartnäckig darauf bestand.

Nach dem Abhören sagte sie, sie höre Rasselgeräusche in der rechten Lunge und «es wäre besser, ein Antibiotikum zu nehmen». Keine Tests, kein Röntgen — einfach sofort ein Antibiotikum, auf gut Glück. Ich bestand auf einem Röntgenbild. Sie machten es, aber es stellte sich heraus, dass das Ergebnis und die Schlussfolgerung erst in einem Tag fertig sein würden und per E-Mail geschickt würden.

Ein Tag verging, dann anderthalb Tage — das Röntgenbild wurde nie geschickt. Zur Erinnerung: Ich kam mit dem Verdacht auf Lungenentzündung.

75 Euro — umsonst. Und die verschriebene Behandlung sieht mehr wie Kaffeesatzlesen aus. Wenn Sie Geld verschwenden und Ihre Gesundheit riskieren wollen — kommen Sie hierher.', 'Maj Lab kliniğine gitmek gerçek bir felaket. Zatürre şüphesiyle geldim. Doktor tansiyonumu ölçtü ve şunu söyledi: «Düşük. Boğaz kızarmış. Sanmıyorum zatürre olsun». Teşhis burada bitebilirdi — ısrar etmesem akciğerlerimi dinlemeyi bile düşünmüyordu.

Dinledikten sonra sağ akciğerde hırıltı duyduğunu ve «bir antibiyotik içmek daha iyi olur» dedi. Ne test ne röntgen — sadece hemen antibiyotik, göz kararıyla. Röntgen konusunda ısrar ettim. Yaptılar ama sonuç ve raporun ancak bir gün sonra hazır olacağını ve e-posta ile gönderileceğini öğrendim.

Bir gün geçti, bir buçuk gün geçti — röntgen hâlâ gönderilmedi. Hatırlatayım: zatürre şüphesiyle geldim.

75 euro — boşa gitti. Önerilen tedavi ise kahve falına bakmaktan farksız. Para harcamak ve sağlığınızı riske atmak istiyorsanız — buraya gelin.',
    0, '2025-04-24 00:00:00'),

(@user_ipek_i, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnTUNJMXVHaGhBRRAB',
    1, 'en', 'Be careful the pharmacy may sell you different products',
    'Budite oprezni, apoteka vam može prodati drugačije proizvode.', 'Будите опрезни, апотека вам може продати другачије производе.', 'Be careful the pharmacy may sell you different products', 'Будьте осторожны — в аптеке вам могут продать другие препараты.', 'Seien Sie vorsichtig, die Apotheke kann Ihnen andere Produkte verkaufen.', 'Dikkatli olun, eczane size farklı ürünler satabilir.',
    0, '2025-04-24 00:00:00'),

(@user_svitlana_vyshnevska, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnTUNnektmY2xRRRAB',
    5, 'ru', 'Отличный сервис! Спасибо за помощь и вежливое обслуживание.',
    'Odličan servis! Hvala na pomoći i ljubaznoj usluzi.', 'Одличан сервис! Хвала на помоћи и љубазној услузи.', 'Excellent service! Thank you for the help and polite treatment.', 'Отличный сервис! Спасибо за помощь и вежливое обслуживание.', 'Ausgezeichneter Service! Danke für die Hilfe und den höflichen Umgang.', 'Mükemmel hizmet! Yardım ve nazik ilgi için teşekkürler.',
    0, '2025-03-24 00:00:00'),

(@user_zilya_abzalova, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNfbWVUMU53EAE',
    1, 'ru', 'Отвратная, не профессиональная лаборатория, сдала мазок из носа, не смогли определить количество бактерий в мазке, а от количества зависит терапия для лечения, разница большая, или просто мазь использовать или курс антибиотиков пропить, никакого конкретного ответа не добилась за свои деньги, не советую обращаться, и это притом, что общалась на черногорском.',
    'Odvratna, neprofesionalna laboratorija. Dala sam bris iz nosa, nisu uspeli da odrede broj bakterija u brisu, a od tog broja zavisi terapija — razlika je velika: ili samo mast koristiti ili popiti kurs antibiotika. Nikakav konkretan odgovor nisam dobila za svoj novac. Ne savetuje se, a to uprkos tome što sam komunicirala na crnogorskom.', 'Одвратна, непрофесионална лабораторија. Дала сам брис из носа, нису успели да одреде број бактерија у брису, а од тог броја зависи терапија — разлика је велика: или само маст користити или попити курс антибиотика. Никакав конкретан одговор нисам добила за свој новац. Не саветује се, а то упркос томе што сам комуницирала на црногорском.', 'Disgusting, unprofessional laboratory. I submitted a nasal swab — they could not determine the number of bacteria in the swab, and the treatment depends on that count; the difference is significant: either use just an ointment or take a course of antibiotics. I got no concrete answer for my money. I do not recommend going there, and this despite the fact that I communicated in Montenegrin.', 'Отвратная, не профессиональная лаборатория, сдала мазок из носа, не смогли определить количество бактерий в мазке, а от количества зависит терапия для лечения, разница большая, или просто мазь использовать или курс антибиотиков пропить, никакого конкретного ответа не добилась за свои деньги, не советую обращаться, и это притом, что общалась на черногорском.', 'Widerliches, unprofessionelles Labor. Ich habe einen Nasenabstrich abgegeben — sie konnten die Anzahl der Bakterien im Abstrich nicht bestimmen, dabei hängt die Behandlung genau davon ab; der Unterschied ist groß: entweder nur eine Salbe verwenden oder eine Antibiotikakur durchführen. Für mein Geld habe ich keine konkrete Antwort bekommen. Ich empfehle es nicht, obwohl ich auf Montenegrinisch kommuniziert habe.', 'İğrenç, profesyonelden uzak bir laboratuvar. Burundan sürüntü verdi — svabdaki bakteri sayısını belirleyemediler; oysa tedavi o sayıya bağlı: ya sadece merhem kullanmak ya da antibiyotik tedavisi almak gerekiyor. Paramın karşılığında somut bir yanıt alamadım. Gitmenizi tavsiye etmiyorum; üstelik Karadağca konuşmama rağmen.',
    0, '2025-03-24 00:00:00'),

(@user_natalia, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUN2NjlYWmRREAE',
    1, 'ru', 'Была сегодня на осмотре у гениколога, поставил возможный диагноз, сказал сдать анализы проверить. Я объяснила что уже сдавала эти анализы, они чистые, он все равно сказал сдать, так как уверен, что болезнь подтвердится. Выписал "на всякий случай" таблетки, которые помогут "от всего". В итоге анализы чистые, к решению проблемы ближе не стала, 100 евро потратила',
    'Bila sam danas na pregledu kod ginekologa, postavio moguću dijagnozu, rekao da uradim analize da proverim. Objasnila sam da sam već radila te analize i da su čiste, on je svejedno rekao da ih uradim jer je siguran da će se bolest potvrditi. Ispisao je "za svaki slučaj" tablete koje će pomoći "od svega". Na kraju analize su čiste, nisam bliže rešenju problema, potrošila sam 100 evra.', 'Била сам данас на прегледу код гинеколога, поставио могућу дијагнозу, рекао да урадим анализе да проверим. Објаснила сам да сам већ радила те анализе и да су чисте, он је свеједно рекао да их урадим јер је сигуран да ће се болест потврдити. Исписао је "за сваки случај" таблете које ће помоћи "од свега". На крају анализе су чисте, нисам ближе решењу проблема, потрошила сам 100 евра.', 'I visited a gynecologist today — he gave a possible diagnosis and said to get some tests done to check. I explained that I had already done those tests and they were clean, but he still said to redo them because he was sure the illness would be confirmed. He prescribed "just in case" tablets that would help "with everything". In the end the tests were clean, I am no closer to solving my problem, and I spent 100 euros.', 'Была сегодня на осмотре у гениколога, поставил возможный диагноз, сказал сдать анализы проверить. Я объяснила что уже сдавала эти анализы, они чистые, он все равно сказал сдать, так как уверен, что болезнь подтвердится. Выписал "на всякий случай" таблетки, которые помогут "от всего". В итоге анализы чистые, к решению проблемы ближе не стала, 100 евро потратила', 'Ich war heute beim Gynäkologen, er stellte eine mögliche Diagnose und sagte, ich solle Tests machen. Ich erklärte, dass ich diese Tests bereits gemacht hatte und sie sauber waren, trotzdem sagte er, ich solle sie wiederholen, da er sicher sei, dass die Krankheit bestätigt werde. Er verschrieb "vorsichtshalber" Tabletten, die "gegen alles" helfen würden. Am Ende waren die Tests sauber, ich bin meiner Problemlösung keinen Schritt nähergekommen und habe 100 Euro ausgegeben.', 'Bugün jinekolog muayenesine gittim, olası tanı koydu ve kontrol için tahlil yaptırmamı söyledi. Bu tahlilleri zaten yaptırdığımı ve temiz çıktığını açıkladım, yine de yaptırmamı söyledi çünkü hastalığın doğrulanacağından emin olduğunu belirtti. "Her ihtimale karşı" "her şeye yarayan" tabletler yazdı. Sonunda tahliller temiz çıktı, sorunuma çözüm bulamadım ve 100 euro harcadım.',
    0, '2025-03-24 00:00:00'),

(@user_cenker_sahin, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUQzdVlQdnh3RRAB',
    1, 'tr', 'Kızımın ateşi çıktığı için götürdüm ve muayene oldu. Doktor kan ve idrar tahlili istedi. Yan tarfında bulunan labaratuarda tahlilleri yaptırdık. Tahliller ve muayene ücreti toplam 41 € tuttu. Tahlil sonucu çkkınca doktora götürdün ve şaşırtıcı şekilde doktor çıkmış. Yarın saat 13:00\'de gelecek dediler. Ertesi gün doktora sonuçları göstermek için gittim ve kuzıma saçma sapan artık eczanelerde olmayan bir ilaç yazdı. Saatlerce ilacı aradım ama bulamadım. En sonında tekrar hastaneye gidrrek ilacı değiştirmesini söyledim. Ayrıca benden ekstra 25 € daha aldılar. Tahlil sonuçlarını bir gün sonra doktora gösterdim diye. Kısmen dolandırıldığıma inansam da bu saçma insanların bilgisiz olduğu gerçeğini değiştirmiyor.',
    'Odveo sam ćerku jer je imala temperaturu i pregledali su je. Doktor je tražio krvne i urinarne analize. Analize smo uradili u laboratoriji koja se nalazi pored. Analize i pregled su ukupno koštali 41 €. Kada su rezultati bili gotovi, odveo sam ih doktoru, ali začudo doktor nije bio tu. Rekli su da će doći sutra u 13:00. Sledećeg dana sam otišao da pokažem doktoru rezultate i kćerki je ispisao besmislen lek koji više ne postoji u apotekama. Satima sam tražio lek ali ga nisam mogao naći. Na kraju sam se vratio u bolnicu i tražio da promeni lek. Uzeli su i dodatnih 25 € jer sam rezultate pokazao doktoru dan kasnije. Iako delimično verujem da sam prevaren, to ne menja činjenicu da su ovi apsurdni ljudi neznalice.', 'Одвео сам ћерку јер је имала температуру и прегледали су је. Доктор је тражио крвне и уринарне анализе. Анализе смо урадили у лабораторији која се налази поред. Анализе и преглед су укупно коштали 41 €. Када су резултати били готови, одвео сам их доктору, али зачудо доктор није био ту. Рекли су да ће доћи сутра у 13:00. Сљедећег дана сам отишао да покажем доктору резултате и кћерки је исписао бесмислен лек који више не постоји у апотекама. Сатима сам тражио лек али га нисам могао наћи. На крају сам се вратио у болницу и тражио да промени лек. Узели су и додатних 25 € јер сам резултате показао доктору дан касније. Иако делимично верујем да сам преварен, то не мења чињеницу да су ови апсурдни људи незналице.', 'I took my daughter because she had a fever and she was examined. The doctor requested blood and urine tests. We had the tests done at the laboratory next door. The tests and consultation totaled 41 €. When the results were ready I took them to the doctor, but surprisingly the doctor had left. They said he would come back tomorrow at 13:00. The next day I went to show the doctor the results and he prescribed my daughter a nonsensical medication that is no longer available in pharmacies. I searched for the medicine for hours but could not find it. In the end I went back to the hospital and asked him to change the prescription. They also charged me an extra 25 € because I showed the results to the doctor a day later. Even though I partly believe I was scammed, it doesn\'t change the fact that these absurd people are incompetent.', 'Привёл дочку из-за температуры, её осмотрели. Врач назначил анализы крови и мочи. Мы сдали анализы в лаборатории, которая находится рядом. Итого за анализы и осмотр вышло 41 €. Когда результаты были готовы, я принёс их врачу, но, к удивлению, врача не оказалось. Сказали, что придёт завтра в 13:00. На следующий день я пришёл показать результаты, и он выписал дочке бессмысленный препарат, которого уже нет в аптеках. Часами искал лекарство — не нашёл. В итоге вернулся в клинику и попросил заменить рецепт. С меня также взяли дополнительно 25 € за то, что я показал результаты врачу на следующий день. Хотя я частично считаю, что меня обманули, это не меняет того факта, что эти абсурдные люди некомпетентны.', 'Ich brachte meine Tochter wegen Fieber, sie wurde untersucht. Der Arzt verlangte Blut- und Urinuntersuchungen. Wir ließen die Tests im benachbarten Labor durchführen. Tests und Untersuchung kosteten insgesamt 41 €. Als die Ergebnisse fertig waren, brachte ich sie zum Arzt, aber zu meiner Überraschung war der Arzt weg. Sie sagten, er komme morgen um 13:00 Uhr. Am nächsten Tag ging ich, um dem Arzt die Ergebnisse zu zeigen, und er verschrieb meiner Tochter ein unsinniges Medikament, das es in Apotheken nicht mehr gibt. Ich suchte stundenlang nach dem Medikament, fand es aber nicht. Am Ende kehrte ich ins Krankenhaus zurück und bat ihn, das Rezept zu ändern. Sie berechneten mir auch zusätzlich 25 €, weil ich dem Arzt die Ergebnisse einen Tag später gezeigt hatte. Obwohl ich teilweise glaube, betrogen worden zu sein, ändert das nichts an der Tatsache, dass diese absurden Menschen inkompetent sind.', 'Kızımın ateşi çıktığı için götürdüm ve muayene oldu. Doktor kan ve idrar tahlili istedi. Yan tarfında bulunan labaratuarda tahlilleri yaptırdık. Tahliller ve muayene ücreti toplam 41 € tuttu. Tahlil sonucu çkkınca doktora götürdün ve şaşırtıcı şekilde doktor çıkmış. Yarın saat 13:00\'de gelecek dediler. Ertesi gün doktora sonuçları göstermek için gittim ve kuzıma saçma sapan artık eczanelerde olmayan bir ilaç yazdı. Saatlerce ilacı aradım ama bulamadım. En sonında tekrar hastaneye gidrrek ilacı değiştirmesini söyledim. Ayrıca benden ekstra 25 € daha aldılar. Tahlil sonuçlarını bir gün sonra doktora gösterdim diye. Kısmen dolandırıldığıma inansam da bu saçma insanların bilgisiz olduğu gerçeğini değiştirmiyor.',
    0, '2025-03-24 00:00:00'),

(@user_nikishin_aleksandr, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNudGZLWVVREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_jarosaw_szczuka, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURIZ2JlNDNnRRAB',
    5, 'pl', 'Korzystając z pomocy laryngologa. Starsza pani doktor bardzo troskliwy zajęła się moim przypadkiem. Wszyscy uprzejmi i pomocni.',
    'Koristio sam usluge otorinolaringologa. Starija doktorka se veoma pažljivo posvetila mom slučaju. Svi su bili ljubazni i od pomoći.', 'Користио сам услуге оториноларинголога. Старија докторка се веома пажљиво посветила мом случају. Сви су били љубазни и од помоћи.', 'I used the services of an ENT doctor. The older female doctor took very caring care of my case. Everyone was polite and helpful.', 'Обратился к ЛОР-врачу. Пожилая женщина-доктор очень внимательно занялась моим случаем. Все вежливые и готовые помочь.', 'Ich nahm die Dienste eines HNO-Arztes in Anspruch. Die ältere Frau Doktor kümmerte sich sehr fürsorglich um meinen Fall. Alle waren höflich und hilfsbereit.', 'KBB uzmanının yardımından yararlandım. Yaşlı bayan doktor davama çok özenle ilgilendi. Herkes nazik ve yardımseverdi.',
    0, '2025-03-24 00:00:00'),

(@user_armin_91, @clinic_id, @doctor_marina_pejovic, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNINy1IUEZBEAE',
    5, 'bs', 'Sve pohvale za osoblje, kako sestre, a pogotovo za dr Marinu Pejović otorinolaringologa.',
    'Sve pohvale za osoblje, kako sestre, a pogotovo za dr Marinu Pejović otorinolaringologa.', 'Све похвале за особље, kako сестре, а поготово за др Marinu Pejović оториноларинголога.', 'All praise for the staff, both the nurses and especially for dr Marina Pejović the ENT specialist.', 'Все хвалы персоналу — как медсёстрам, так и особенно доктору Marina Pejović, оториноларингологу.', 'Alles Lob für das Personal, sowohl die Schwestern als auch besonders für Dr. Marina Pejović, die HNO-Spezialistin.', 'Personelin tamamına övgüler, hem hemşireler hem de özellikle KBB uzmanı dr Marina Pejović için.',
    0, '2025-03-24 00:00:00'),

(@user_stefan_maslovar, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNINXVtTmVREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_dajana_mirkoivic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNINnZfcDBRRRAB',
    1, 'bs', 'Recepcioneri neljubazni ,na upit da je beba bolesna i da  trebamo hitnu pomoć ,bez konsultacije sa pedijatrom nam kaže da prednost imaju zakazani pacijenti i da ne može da nas primi u naredna 2h .

Ranije smo takodje bili pacijenti u istoj klinici gdje su doktori ljubazni i detaljni ali recepcija ocjena 1.',
    'Recepcioneri neljubazni ,na upit da je beba bolesna i da  trebamo hitnu pomoć ,bez konsultacije sa pedijatrom nam kaže da prednost imaju zakazani pacijenti i da ne može da nas primi u naredna 2h .

Ranije smo takodje bili pacijenti u istoj klinici gdje su doktori ljubazni i detaljni ali recepcija ocjena 1.', 'Рецепционери су љубазни — кад смо рекли да је беба болесна и да нам треба хитна помоћ, без консултације са педијатром, рекли су нам да предност имају заказани пацијенти и да нас не могу примити у наредна 2 сата.

Раније смо такође били пацијенти у истој клиници гдје су доктори љубазни и детаљни, али рецепција — оцјена 1.', 'The receptionists are unfriendly — when we said the baby was sick and we needed urgent help, without consulting a pediatrician they told us that scheduled patients have priority and they cannot see us for the next 2 hours.

We have previously also been patients at the same clinic where the doctors are kind and thorough, but reception gets a rating of 1.', 'Администраторы недружелюбные — когда мы сказали, что ребёнок болен и нам нужна экстренная помощь, без консультации с педиатром нам ответили, что приоритет у записанных пациентов и принять нас не смогут в ближайшие 2 часа.

Ранее мы тоже были пациентами той же клиники, где врачи внимательные и детальные, но стойка регистрации — оценка 1.', 'Die Rezeptionisten sind unfreundlich — als wir sagten, dass das Baby krank ist und wir dringende Hilfe brauchen, sagten sie uns ohne Rücksprache mit dem Kinderarzt, dass angemeldete Patienten Vorrang haben und sie uns in den nächsten 2 Stunden nicht aufnehmen können.

Wir waren früher ebenfalls Patienten in derselben Klinik, wo die Ärzte freundlich und gründlich sind, aber die Rezeption — Bewertung 1.', 'Resepsiyonistler nazik değil — bebeğin hasta olduğunu ve acil yardıma ihtiyacımız olduğunu söylediğimizde, pediatristle görüşmeden randevulu hastaların öncelikli olduğunu ve önümüzdeki 2 saat içinde bizi kabul edemeyeceklerini söylediler.

Daha önce de aynı kliniğin hastasıydık; doktorlar nazik ve ayrıntılı ama resepsiyon — puan 1.',
    0, '2025-03-24 00:00:00'),

(@user_sandra_jevtic, @clinic_id, @doctor_vesna_vucetic, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNIOHZxV0N3EAE',
    5, 'bs', 'Dete (2god.) sa stomacnim virusom, uspešno oporavljeno, uz pravu terapiju, izbegnuta infuzija. Hvala puno svima, a posebno dr.ped.Vesni 🥰! …',
    'Dete (2god.) sa stomacnim virusom, uspešno oporavljeno, uz pravu terapiju, izbegnuta infuzija. Hvala puno svima, a posebno dr.ped.Vesni 🥰! …', 'Дете (2 год.) са стомачним вирусом, успешно опорављено, уз праву терапију, избегнута инфузија. Хвала пуно свима, а посебно др.пед.Vesni 🥰! …', 'Child (2 y.o.) with a stomach virus, successfully recovered with the right therapy, infusion avoided. Many thanks to everyone, and especially to dr.ped.Vesna 🥰! …', 'Ребёнок (2 года) с желудочным вирусом, успешно выздоровел при правильном лечении, капельница не понадобилась. Большое спасибо всем, а особенно dr.ped.Vesni 🥰! …', 'Kind (2 J.) mit Magenvirus, dank der richtigen Therapie erfolgreich erholt, Infusion vermieden. Vielen Dank an alle, besonders an dr.ped.Vesna 🥰! …', 'Çocuk (2 yaşında) mide virüsüyle, doğru tedavi sayesinde başarıyla iyileşti, infüzyon yapılmadan atlatıldı. Herkese çok teşekkürler, özellikle dr.ped.Vesna\'ya 🥰! …',
    0, '2025-03-24 00:00:00'),

(@user_viktor_stojanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNIZ0xmM25RRRAB',
    5, 'bs', 'Po prvi put sam u policlinic Moj lab. Sve pohvale za osoblje Miru i Milenu koje su svojim ljubaznim pristupom i profesionalnoscu ucinile moju posetu laksom. Sve pohvale 🤗 …',
    'Po prvi put sam u policlinic Moj lab. Sve pohvale za osoblje Miru i Milenu koje su svojim ljubaznim pristupom i profesionalnoscu ucinile moju posetu laksom. Sve pohvale 🤗 …', 'По први пут сам у поликлиници Moj lab. Све похвале за особље Миру и Милену које су својим љубазним приступом и професионалношћу учиниле моју посету лакшом. Све похвале 🤗 …', 'First time at Moj lab polyclinic. All praise for the staff Mira and Milena who made my visit easier with their kind approach and professionalism. All praise 🤗 …', 'Первый раз в поликлинике Moj lab. Все хвалы персоналу — Мире и Милене, которые своим добродушным подходом и профессионализмом сделали мой визит легче. Все хвалы 🤗 …', 'Zum ersten Mal in der Poliklinik Moj lab. Alles Lob für das Personal Mira und Milena, die meinen Besuch mit ihrer freundlichen Art und Professionalität erleichtert haben. Alles Lob 🤗 …', 'Moj lab polikliniğinde ilk kez bulundum. Nazik yaklaşımları ve profesyonellikleri ile ziyaretimi kolaylaştıran Mira ve Milena personeline tüm övgüler. Her türlü övgüyü hak ediyorlar 🤗 …',
    0, '2025-03-24 00:00:00'),

(@user_shkola_djokici, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ3OFpYYlZBEAE',
    5, 'hr', 'Imao sam zdravstvenu nezgodu u vidu gnojne angine. Stručni ljudi su me oporavili za manje od 24h.
Ljubazni, strpljivi i predusretljivi su svi zaposleni koje sam sreo ovde(dva različita doktora i tri različite sestre).
Cene su više nego korektne!
Topla preporuka svakom ko ima zdravstveni problem je upravo ova klinika. Nećete se pokajati!',
    'Imao sam zdravstvenu nezgodu u vidu gnojne angine. Stručni ljudi su me oporavili za manje od 24h.
Ljubazni, strpljivi i predusretljivi su svi zaposleni koje sam sreo ovde(dva različita doktora i tri različite sestre).
Cene su više nego korektne!
Topla preporuka svakom ko ima zdravstveni problem je upravo ova klinika. Nećete se pokajati!', 'Имао сам здравствени проблем у виду гнојне ангине. Стручни људи су ме опоравили за мање од 24х.
Љубазни, стрпљиви и предусретљиви су сви запослени које сам срео овде (два различита доктора и три различите сестре).
Цене су више него коректне!
Топла препорука свакоме ко има здравствени проблем је управо ова клиника. Нећете се покајати!', 'I had a health issue in the form of purulent tonsillitis. The skilled staff had me recovered in less than 24 hours.
All the employees I met here were kind, patient and accommodating (two different doctors and three different nurses).
Prices are more than fair!
I warmly recommend this clinic to anyone who has a health problem. You will not regret it!', 'У меня был гнойный тонзиллит. Опытные специалисты поставили меня на ноги менее чем за 24 часа.
Все сотрудники, которых я встретил здесь, были вежливыми, терпеливыми и внимательными (два разных врача и три разные медсестры).
Цены более чем адекватные!
Горячо рекомендую эту клинику всем, у кого есть проблемы со здоровьем. Не пожалеете!', 'Ich hatte ein gesundheitliches Problem in Form einer eitrigen Mandelentzündung. Fachkundige Mitarbeiter haben mich in weniger als 24 Stunden genesen lassen.
Alle Mitarbeiter, denen ich hier begegnet bin, waren freundlich, geduldig und zuvorkommend (zwei verschiedene Ärzte und drei verschiedene Schwestern).
Die Preise sind mehr als fair!
Ich empfehle diese Klinik wärmstens jedem, der ein gesundheitliches Problem hat. Sie werden es nicht bereuen!', 'İrinli anjin şeklinde bir sağlık sorunum vardı. Uzman kişiler beni 24 saatten kısa sürede iyileştirdi.
Burada karşılaştığım tüm çalışanlar (iki farklı doktor ve üç farklı hemşire) nazik, sabırlı ve anlayışlıydı.
Fiyatlar fazlasıyla makul!
Sağlık sorunu olan herkese bu kliniği sıcakça tavsiye ederim. Pişman olmayacaksınız!',
    0, '2025-03-24 00:00:00'),

(@user_srdjan_spasi, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUM3emJqUzBnRRAB',
    1, 'sr', '15.08.2024 били смо принуђени да посетимо клинику у Будви због повреде ноге детета узраста 10 година. Особље на пулту  је било пријатно али не и стручно јер ми је било потребно 10 минута да објасним шта је разлог нашег доласка и да нисам проблем ја већ дете. 😅Након урађеног рендгенског снимка дедетове ноге нико нас није позвао телефоном као што смо се и договорили већ су само послали мејл са извештајем доктора, који је написао да НЕМА уочљиве фрактуре стопала! А ми после завршили у Рисну и ставили детету гипс јер је прелом стопала био очигледан!

Толико о стручности лекара са којим клиника сарађује барем у нашем случају!😤😤

Једине похвале мед техничару Иви који је перфектно уз лично ангажовање снимио дететову ногу и сам видео онако НЕ СТРУЧНО да има прелома! Повећајте човеку плату заслужио је!',
    '15.08.2024 bili smo prinuđeni da posetimo kliniku u Budvi zbog povrede noge deteta uzrasta 10 godina. Osoblje na pultu  je bilo prijatno ali ne i stručno jer mi je bilo potrebno 10 minuta da objasnim šta je razlog našeg dolaska i da nisam problem ja već dete. 😅Nakon urađenog rendgenskog snimka dedetove noge niko nas nije pozvao telefonom kao što smo se i dogovorili već su samo poslali mejl sa izveštajem doktora, koji je napisao da NEMA uočljive frakture stopala! A mi posle završili u Risnu i stavili detetu gips jer je prelom stopala bio očigledan!

Toliko o stručnosti lekara sa kojim klinika sarađuje barem u našem slučaju!😤😤

Jedine pohvale med tehničaru Ivi koji je perfektno uz lično angažovanje snimio detetovu nogu i sam video onako NE STRUČNO da ima preloma! Povećajte čoveku platu zaslužio je!', '15.08.2024 били смо принуђени да посетимо клинику у Будви због повреде ноге детета узраста 10 година. Особље на пулту  је било пријатно али не и стручно јер ми је било потребно 10 минута да објасним шта је разлог нашег доласка и да нисам проблем ја већ дете. 😅Након урађеног рендгенског снимка дедетове ноге нико нас није позвао телефоном као што смо се и договорили већ су само послали мејл са извештајем доктора, који је написао да НЕМА уочљиве фрактуре стопала! А ми после завршили у Рисну и ставили детету гипс јер је прелом стопала био очигледан!

Толико о стручности лекара са којим клиника сарађује барем у нашем случају!😤😤

Једине похвале мед техничару Иви који је перфектно уз лично ангажовање снимио дететову ногу и сам видео онако НЕ СТРУЧНО да има прелома! Повећајте човеку плату заслужио је!', '15.08.2024 we were forced to visit the clinic in Budva due to an injury to a 10-year-old child\'s leg. The front desk staff were pleasant but not professional — it took me 10 minutes to explain what the reason for our visit was and that the problem was not me but the child. 😅 After the X-ray of the child\'s leg was done, no one called us as agreed — they just sent an email with the doctor\'s report, which stated that there is NO visible fracture of the foot! We then ended up in Risan and had the child put in a cast because the foot fracture was obvious!

So much for the competence of the doctor the clinic works with, at least in our case!😤😤

The only praise goes to medical technician Iva, who with personal dedication perfectly took the X-ray of the child\'s leg and herself could see, in that SO UNPROFESSIONAL way, that there was a fracture! Give this person a raise — she deserves it!', '15.08.2024 мы были вынуждены посетить клинику в Будве из-за травмы ноги ребёнка 10 лет. Персонал на стойке был приятным, но некомпетентным — мне потребовалось 10 минут, чтобы объяснить, зачем мы пришли и что проблема не у меня, а у ребёнка. 😅 После рентгена ноги ребёнка нас никто не позвонил, как и договаривались, — просто прислали письмо с заключением врача, который написал, что НЕТ видимого перелома стопы! А мы потом оказались в Рисане и наложили ребёнку гипс, потому что перелом стопы был очевиден!

Вот такова компетентность врача, с которым сотрудничает клиника, по крайней мере в нашем случае!😤😤

Единственная похвала — медтехнику Иви, который с личным участием идеально снял ногу ребёнка и сам по-своему НЕПРОФЕССИОНАЛЬНО увидел, что есть перелом! Поднимите человеку зарплату — он заслужил!', '15.08.2024 waren wir gezwungen, die Klinik in Budva wegen einer Beinverletzung eines 10-jährigen Kindes aufzusuchen. Das Personal an der Rezeption war freundlich, aber nicht kompetent — es dauerte 10 Minuten, bis ich erklärt hatte, warum wir da waren und dass das Problem nicht ich, sondern das Kind war. 😅 Nachdem das Röntgenbild vom Bein des Kindes gemacht wurde, rief uns niemand an, wie vereinbart — sie schickten nur eine E-Mail mit dem Arztbericht, in dem stand, dass KEINE sichtbare Fußfraktur vorhanden ist! Wir landeten dann in Risan und ließen dem Kind einen Gips anlegen, weil der Fußbruch offensichtlich war!

So viel zur Kompetenz des Arztes, mit dem die Klinik zusammenarbeitet, zumindest in unserem Fall!😤😤

Einziges Lob gilt dem medizinischen Techniker Iva, der mit persönlichem Einsatz das Röntgenbild des Kinderbeins perfekt aufgenommen hat und selbst SO UNPROFESSIONELL erkannte, dass ein Bruch vorliegt! Geben Sie dieser Person eine Gehaltserhöhung — sie hat es verdient!', '15.08.2024 tarihinde 10 yaşındaki çocuğun bacak yaralanması nedeniyle Budva\'daki kliniği ziyaret etmek zorunda kaldık. Resepsiyondaki personel hoştu ama profesyonel değildi — neden geldiğimizi ve sorunun bende değil çocukta olduğunu anlatmam 10 dakika sürdü. 😅 Çocuğun bacak röntgeni çekildikten sonra, anlaştığımız gibi kimse bizi aramadı — sadece doktorun raporunu içeren bir e-posta gönderdiler; raporda ayakta GÖRÜNÜR bir kırık BULUNMADIĞI yazıyordu! Sonunda Risan\'a gittik ve ayak kırığı aşikar olduğu için çocuğa alçı taktırdık!

En azından bizim durumumuzda klinikle çalışan doktorun yeterliliği bu kadar!😤😤

Tek övgü, kişisel çabasıyla çocuğun bacak röntgenini mükemmel çeken ve kırık olduğunu o kadar GAYRİPROFESYONEL bir şekilde kendisi de gören tıbbi teknisyen Iva\'ya! Bu kişinin maaşını artırın — hak ediyor!',
    0, '2025-03-24 00:00:00'),

(@user_serhii_viktorovich_doldin, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUM3eVl6SUt3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_vladana_goloevac, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNyMy15MVhREAE',
    1, 'bs', 'Danas sam povela prijatelja stranaca koji je povrijedio nogu prvo su nas poslali kod doktora opste prakse koji ga je pregledao ukupno 1 min i nista konkretno nije rekao pa valjda jedan doktor neko misljenje moze da iskaze ,zatim smo posli na RTG snimanje a tehnicar muskarac koji radi tamo nas je jos gore docekao pitam ga sto misli kaze ne znam onda ima komentar da je slomljeno pa eto nije siguran ,zatim Vaš sistem da se ti snicmi salju doktoru putem mejla i da putem mejla doktor odgovara je stvarno nevjerovatno nesto a za kraj pristup sestre koja radi na recepciji je krajnje uzasan toliko jedna drska osoba pa moje oci to nisu gledale,zaista tako se sa pacijentom stranim drzavljaninom ne postupa.Izvjestaj koji nam je doktor napisao doktor opste prakse sadrzi jednu recenicu ,ja se stidim takvog izvjestaja i akk je situacija koju sam mu opisala sa njegovom nogom daleko ozbiljniji.Stvarno bih voljela da vasi nadredjeni obrate paznju na ponasanje vasih zaposlenih',
    'Danas sam povela prijatelja stranaca koji je povrijedio nogu prvo su nas poslali kod doktora opste prakse koji ga je pregledao ukupno 1 min i nista konkretno nije rekao pa valjda jedan doktor neko misljenje moze da iskaze ,zatim smo posli na RTG snimanje a tehnicar muskarac koji radi tamo nas je jos gore docekao pitam ga sto misli kaze ne znam onda ima komentar da je slomljeno pa eto nije siguran ,zatim Vaš sistem da se ti snicmi salju doktoru putem mejla i da putem mejla doktor odgovara je stvarno nevjerovatno nesto a za kraj pristup sestre koja radi na recepciji je krajnje uzasan toliko jedna drska osoba pa moje oci to nisu gledale,zaista tako se sa pacijentom stranim drzavljaninom ne postupa.Izvjestaj koji nam je doktor napisao doktor opste prakse sadrzi jednu recenicu ,ja se stidim takvog izvjestaja i akk je situacija koju sam mu opisala sa njegovom nogom daleko ozbiljniji.Stvarno bih voljela da vasi nadredjeni obrate paznju na ponasanje vasih zaposlenih', 'Данас сам повела пријатеља странца који је повредио ногу, прво су нас послали код доктора опште праксе који га је прегледао укупно 1 мин и ништа конкретно није рекао, па ваљда један доктор неко мишљење може да искаже. Затим смо пошли на РТГ снимање, а техничар мушкарац који ради тамо нас је још горе дочекао, питам га шта мисли, каже не знам, онда има коментар да је сломљено па ето није сигуран. Затим, ваш систем да се ти снимци шаљу доктору путем мејла и да путем мејла доктор одговара је стварно невероватно нешто. А за крај, приступ сестре која ради на рецепцији је крајње ужасан, толико једна дрска особа, па моје очи то нису гледале. Заиста, тако се са пацијентом страним држављанином не поступа. Извештај који нам је доктор написао, доктор опште праксе, садржи једну реченицу — ја се стидим таквог извештаја, и ситуација коју сам му описала са његовом ногом је далеко озбиљнија. Стварно бих волела да ваши надређени обрате пажњу на понашање ваших запослених.', 'Today I brought a foreign friend who had injured his leg. First they sent us to a general practitioner who examined him for a total of 1 minute and said nothing concrete — surely a doctor can at least offer some opinion. Then we went for an X-ray, and the male technician there received us even worse. I asked him what he thought, he said he didn\'t know, then commented that it might be broken but he wasn\'t sure. Then your system of sending images to the doctor by email and having the doctor respond by email is truly unbelievable. And to top it all off, the attitude of the nurse at reception was absolutely dreadful — such an arrogant person, my eyes couldn\'t believe it. This is truly no way to treat a foreign patient. The report the general practitioner wrote for us contains one sentence — I am ashamed of such a report, and the situation I described to him about his leg is far more serious. I would truly like your superiors to pay attention to the behavior of your employees.', 'Сегодня я привела иностранного друга, который повредил ногу. Сначала нас отправили к врачу общей практики, который осмотрел его в общей сложности 1 минуту и не сказал ничего конкретного — уж врач-то мог бы высказать какое-то мнение. Затем мы пошли на рентген, а техник-мужчина, работающий там, встретил нас ещё хуже. Спрашиваю его, что он думает, — говорит, не знаю, потом комментирует, что, возможно, сломано, но не уверен. Затем ваша система, при которой снимки отправляются врачу по электронной почте и врач тоже отвечает по почте, — это просто невероятно. И в завершение, отношение медсестры на ресепшне было совершенно ужасным — настолько наглый человек, мои глаза такого не видели. Действительно, так с иностранным пациентом не обращаются. Отчёт, который написал нам врач общей практики, содержит одно предложение — мне стыдно за такой отчёт, а ситуация, которую я ему описала с его ногой, гораздо серьёзнее. Я действительно хотела бы, чтобы ваше руководство обратило внимание на поведение ваших сотрудников.', 'Heute habe ich einen ausländischen Freund mitgebracht, der sich das Bein verletzt hatte. Zunächst schickten sie uns zu einem Allgemeinmediziner, der ihn insgesamt 1 Minute lang untersuchte und nichts Konkretes sagte — ein Arzt sollte zumindest eine Meinung äußern können. Dann gingen wir zum Röntgen, und der männliche Techniker dort empfing uns noch schlechter. Ich fragte ihn, was er denke, er sagte, er wisse es nicht, dann meinte er, es könnte gebrochen sein, aber er sei sich nicht sicher. Dann ist Ihr System, bei dem die Aufnahmen per E-Mail an den Arzt geschickt werden und der Arzt per E-Mail antwortet, wirklich unglaublich. Und zum Schluss war die Haltung der Schwester an der Rezeption absolut schrecklich — so eine unverschämte Person, meine Augen konnten es kaum glauben. So behandelt man keinen ausländischen Patienten. Der Bericht, den der Allgemeinmediziner für uns geschrieben hat, enthält einen einzigen Satz — ich schäme mich für einen solchen Bericht, und die Situation, die ich ihm mit seinem Bein beschrieben habe, ist weit ernster. Ich würde wirklich gerne, dass Ihre Vorgesetzten auf das Verhalten Ihrer Mitarbeiter achten.', 'Bugün bacağını yaralamış yabancı bir arkadaşımı getirdim. Önce bizi genel pratisyen hekime gönderdiler, o da toplamda 1 dakika muayene etti ve somut hiçbir şey söylemedi — en azından bir doktor görüş bildirebilmelidir. Sonra röntgene gittik ve oradaki erkek teknisyen bizi daha da kötü karşıladı. Ne düşündüğünü sordum, bilmiyorum dedi, sonra kırık olabilir ama emin değilim diye yorum yaptı. Ardından, görüntülerin e-posta ile doktora gönderildiği ve doktorun e-posta ile yanıt verdiği sisteminiz gerçekten inanılmaz. Son olarak, resepsiyondaki hemşirenin tutumu son derece berbattı — bu kadar küstah biri, gözlerim buna şahit olmak zorunda kaldı. Gerçekten, yabancı uyruklu bir hastayla böyle davranılmaz. Genel pratisyen hekimin bizim için yazdığı rapor tek bir cümle içeriyor — böyle bir rapordan utanıyorum, bacağı hakkında anlattığım durum çok daha ciddi. Yöneticilerinizin gerçekten çalışanlarınızın davranışlarına dikkat etmesini istiyorum.',
    0, '2025-03-24 00:00:00'),

(@user_vladimir_ashikhmin, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNybmRQR0d3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_m_s, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNyNkszX2VnEAE',
    5, 'en', 'Very nice clinic, well equipped, very pleasant people. I had a trauma, came late, they found a doctor, gave me a medicine and now the wounds are healed. €30-40 for a visit, good price. They also have parking. Everyone smiles, speaks English and very responsive. If smth happens they will help.',
    'Vrlo lijepa klinika, dobro opremljena, veoma prijatni ljudi. Imao/la sam traumatsku povredu, došao/la kasno, pronašli su doktora, dali mi lijek i sada su rane zarasle. 30-40€ za posjet, dobra cijena. Imaju i parking. Svi se smiješe, govore engleski i veoma su odzivni. Ako se nešto desi, pomoći će.', 'Врло лијепа клиника, добро опремљена, веома пријатни људи. Имао/ла сам трауматску повреду, дошао/ла касно, пронашли су доктора, дали ми лијек и сада су ране зарасле. 30-40€ за посјет, добра цијена. Имају и паркинг. Сви се смијеше, говоре енглески и веома су одзивни. Ако се нешто деси, помоћи ће.', 'Very nice clinic, well equipped, very pleasant people. I had a trauma, came late, they found a doctor, gave me a medicine and now the wounds are healed. €30-40 for a visit, good price. They also have parking. Everyone smiles, speaks English and very responsive. If smth happens they will help.', 'Очень хорошая клиника, хорошо оснащена, очень приятные люди. У меня была травма, пришёл(а) поздно, нашли врача, дали лекарство, и теперь раны зажили. 30-40€ за визит — хорошая цена. Также есть парковка. Все улыбаются, говорят по-английски и очень отзывчивы. Если что-то случится — помогут.', 'Sehr schöne Klinik, gut ausgestattet, sehr angenehme Menschen. Ich hatte ein Trauma, kam spät, sie fanden einen Arzt, gaben mir ein Medikament und jetzt sind die Wunden verheilt. 30-40€ für einen Besuch, guter Preis. Sie haben auch Parkplätze. Alle lächeln, sprechen Englisch und sind sehr reaktionsschnell. Wenn etwas passiert, werden sie helfen.', 'Çok güzel bir klinik, iyi donanımlı, çok hoş insanlar. Bir travmam vardı, geç geldim, bir doktor buldular, bana ilaç verdiler ve şimdi yaralar iyileşti. Ziyaret için 30-40€, iyi fiyat. Ayrıca otoparkları var. Herkes gülümsüyor, İngilizce konuşuyor ve çok ilgili. Bir şey olursa yardımcı olacaklar.',
    0, '2025-03-24 00:00:00'),

(@user_hungry_ghost, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUN6LS1ycGtRRRAB',
    5, 'en', 'Very courteous professional and prompt service.',
    'Veoma ljubazna, profesionalna i brza usluga.', 'Веома љубазна, професионална и брза услуга.', 'Very courteous professional and prompt service.', 'Очень вежливое, профессиональное и оперативное обслуживание.', 'Sehr höflicher, professioneller und prompter Service.', 'Çok nazik, profesyonel ve hızlı hizmet.',
    0, '2025-03-24 00:00:00'),

(@user_alex_zh, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNUOThTYTFnRRAB',
    5, 'en', 'Friendly staff and good service',
    'Ljubazno osoblje i dobra usluga.', 'Љубазно особље и добра услуга.', 'Friendly staff and good service', 'Дружелюбный персонал и хорошее обслуживание.', 'Freundliches Personal und guter Service.', 'Güler yüzlü personel ve iyi hizmet.',
    0, '2025-03-24 00:00:00'),

(@user_andjelka_rakita, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNULVpmME5BEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_branka_boskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUQxNDlYME9nEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_oleg_kipriianov, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNUdk1mRlV3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_udruzhenje_veliko_kolo, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURqLVl1eXBnRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_nataa_bokovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURqOHVhX0VREAE',
    3, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_aleksandra_rajovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURqaVBiLWF3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_isidora_vitezovic, @clinic_id, @doctor_mladen_perisic, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURqaU5URTl3RRAB',
    5, 'hr', 'Veoma ljubazni, sve pohvale za divnog dr Perišića i ostatak tima!',
    'Veoma ljubazni, sve pohvale za divnog dr Perišića i ostatak tima!', 'Веома љубазни, све похвале за дивног др Perišića и остатак тима!', 'Very kind, all the praise for the wonderful dr Perišić and the rest of the team!', 'Очень любезны, все похвалы замечательному dr Perišić и остальной команде!', 'Sehr freundlich, alles Lob für den wunderbaren dr Perišić und den Rest des Teams!', 'Çok nazikler, harika dr Perišić ve ekibinin geri kalanına tüm övgüler!',
    0, '2025-03-24 00:00:00'),

(@user_aleksey_podgornyy, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNqOHM3Z0d3EAE',
    1, 'ru', 'Обходите это место стороной! Вам там не окажут реальную помощь, разведут на деньги и всё!
Заболел Коклюшем, сделали рентген лёгких,заплатил 35 евро.Прислали на почту, разбирайся как говорится сам, с них слова не вытянешь.
Пришёл второй раз уже к доктору, думал, что сейчас учитывая мои явные симптомы, он назначит лечение, но нет, отправили зачем-то на анализ крови.Заплатил 48 евро.
Прислали сново какие-то непонятные буквы и цифры, ни слова о диагнозе, просто треш!
Итог: если хотите просто сдать анализы, просто отдать деньги за бутафорию в виде нормальной медицины, добро пожаловать к этим псевдоврачам!
Когда сам болеешь уже вторую неделю, задыхаешься, блюёшь, мозги начинают работать лучше любых клиник.
Это здание "медицинским" можно назвать только по внешнему виду, а так, обычная жёсткая коммерция!!!',
    'Zaobiđite ovo mjesto! Tamo vam neće pružiti pravu pomoć, samo će vas oderati i to je sve!
Razboljeo sam se od velikog kašlja, uradili su rendgen pluća, platio 35 eura. Poslali na mejl, snalazi se kako znaš, iz njih ne možeš izvući ni reč.
Došao drugi put, već kod doktora, mislio sam da će s obzirom na moje jasne simptome propisati liječenje, ali ne — iz nekog razloga su me uputili na analizu krvi. Platio 48 eura.
Ponovo su poslali neka nerazumljiva slova i cifre, ni reči o dijagnozi, samo smeće!
Zaključak: ako želite samo da radite pretrage, samo da date novac za paravan u vidu normalne medicine, dobrodošli ovim pseudoljekarima!
Kad si bolestan već drugu nedjelju, gušiš se, povaćaš, mozak počne da radi bolje od ikoje klinike.
Ova zgrada se može nazvati "medicinskom" samo po izgledu, a inače, obična gruba komercijala!!!', 'Заобиђите ово мјесто! Тамо вам неће пружити праву помоћ, само ће вас одерати и то је све!
Разбољео сам се од великог кашља, урадили су рендген плућа, платио 35 еура. Послали на мејл, сналази се како знаш, из њих не можеш извући ни ријеч.
Дошао други пут, већ код доктора, мислио сам да ће с обзиром на моје јасне симптоме прописати лијечење, али не — из неког разлога су ме упутили на анализу крви. Платио 48 еура.
Поново су послали нека неразумљива слова и цифре, ни ријечи о дијагнози, само смеће!
Закључак: ако желите само да радите претраге, само да дате новац за параван у виду нормалне медицине, добродошли овим псеудољекарима!
Кад си болестан већ другу недјељу, гушиш се, поваћаш, мозак почне да ради боље од икоје клинике.
Ова зграда се може назвати „медицинском“ само по изгледу, а иначе, обична груба комерцијала!!!', 'Stay away from this place! They won\'t give you real help there, they\'ll just take your money and that\'s it!
I got whooping cough, they did a chest X-ray, I paid 35 euros. Sent to email — figure it out yourself, you can\'t get a word out of them.
Came a second time, to the doctor now, I thought that given my obvious symptoms he would prescribe treatment, but no — for some reason they sent me for a blood test. Paid 48 euros.
Again they sent some incomprehensible letters and numbers, not a word about the diagnosis, just trash!
Conclusion: if you want to just get tests done, just throw money away for a facade of real medicine, welcome to these pseudo-doctors!
When you\'ve been sick for two weeks, gasping for breath, vomiting, your brain starts working better than any clinic.
This building can only be called "medical" by its appearance — in reality, just plain hard commerce!!!', 'Обходите это место стороной! Вам там не окажут реальную помощь, разведут на деньги и всё!
Заболел Коклюшем, сделали рентген лёгких,заплатил 35 евро.Прислали на почту, разбирайся как говорится сам, с них слова не вытянешь.
Пришёл второй раз уже к доктору, думал, что сейчас учитывая мои явные симптомы, он назначит лечение, но нет, отправили зачем-то на анализ крови.Заплатил 48 евро.
Прислали сново какие-то непонятные буквы и цифры, ни слова о диагнозе, просто треш!
Итог: если хотите просто сдать анализы, просто отдать деньги за бутафорию в виде нормальной медицины, добро пожаловать к этим псевдоврачам!
Когда сам болеешь уже вторую неделю, задыхаешься, блюёшь, мозги начинают работать лучше любых клиник.
Это здание "медицинским" можно назвать только по внешнему виду, а так, обычная жёсткая коммерция!!!', 'Meidet diesen Ort! Dort wird euch keine echte Hilfe geleistet, man holt euch nur das Geld aus der Tasche und das war\'s!
Ich erkrankte an Keuchhusten, sie machten ein Lungen-Röntgen, ich zahlte 35 Euro. Per E-Mail zugeschickt — komm damit selbst klar, kein Wort ist aus ihnen herauszukriegen.
Kam ein zweites Mal, diesmal zum Arzt, ich dachte, er würde angesichts meiner offensichtlichen Symptome eine Behandlung verschreiben, aber nein — aus irgendeinem Grund schickten sie mich zur Blutuntersuchung. Zahlte 48 Euro.
Wieder schickten sie irgendwelche unverständlichen Buchstaben und Zahlen, kein Wort zur Diagnose, einfach Mist!
Fazit: Wenn ihr nur Tests machen wollt, einfach Geld für eine Fassade normaler Medizin hinwerfen möchtet, willkommen bei diesen Pseudo-Ärzten!
Wenn man selbst schon zwei Wochen krank ist, nach Luft schnappt, sich übergibt, arbeitet das Gehirn besser als jede Klinik.
Dieses Gebäude kann nur äußerlich als „medizinisch” bezeichnet werden — in Wirklichkeit ist es ganz normaler knallharter Kommerz!!!', 'Bu yerden uzak durun! Orada size gerçek yardım yapmayacaklar, sadece paranızı alacaklar ve bu kadar!
Boğmaca oldum, akciğer röntgeni çektiler, 35 euro ödedim. E-posta ile gönderdiler — kendin çöz, onlardan tek kelime çekemezsiniz.
İkinci kez geldim, bu sefer doktora, belirgin semptomlarıma göre tedavi önereceğini sanıyordum, ama hayır — nedense kan tahlili için gönderdiler. 48 euro ödedim.
Yine anlaşılmaz harfler ve rakamlar gönderdiler, teşhis hakkında tek kelime yok, sadece çöp!
Sonuç: Sadece test yaptırmak, normal tıp görüntüsü için para vermek istiyorsanız, bu sahte doktorlara hoş geldiniz!
Kendi iki haftadır hasta olunca, nefes alamıyorsun, kusuyorsun, beyin her klinikten iyi çalışmaya başlıyor.
Bu bina "tıbbi" olarak yalnızca görünüşüyle nitelendirilebilir — yoksa sıradan, katı bir ticaret anlayışı!!!',
    0, '2025-03-24 00:00:00'),

(@user_djordje_klac, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUREMWFHZkZBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_ling_mollenkopf, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNEdHVfM19RRRAB',
    5, 'en', 'Great service, friendly staff, quick and Im truly impressed',
    'Odlična usluga, ljubazno osoblje, brzo i zaista sam impresioniran/a.', 'Одлична услуга, љубазно особље, брзо и заиста сам импресиониран/а.', 'Great service, friendly staff, quick and Im truly impressed', 'Отличное обслуживание, дружелюбный персонал, быстро, и я действительно впечатлён(а).', 'Toller Service, freundliches Personal, schnell und ich bin wirklich beeindruckt.', 'Harika hizmet, güler yüzlü personel, hızlı ve gerçekten etkilendim.',
    0, '2025-03-24 00:00:00'),

(@user_konstantin_gavrilov, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ5eDZMWmVnEAE',
    5, 'ru', 'Забор анализов и лаборатория в этом же месте, поэтому результаты приходят очень быстро. Для простых анализов обычно в этот же день. Вежливый персонал.',
    'Uzimanje uzoraka i laboratorija su na istom mestu, pa rezultati stižu veoma brzo. Za jednostavne analize obično isti dan. Ljubazno osoblje.', 'Узимање узорака и лабораторија су на истом мјесту, па резултати стижу веома брзо. Заједноставне анализе обично исти дан. Љубазно особље.', 'Blood collection and the laboratory are in the same place, so results come very quickly. For simple tests usually the same day. Polite staff.', 'Забор анализов и лаборатория в этом же месте, поэтому результаты приходят очень быстро. Для простых анализов обычно в этот же день. Вежливый персонал.', 'Die Blutabnahme und das Labor befinden sich am selben Ort, daher kommen die Ergebnisse sehr schnell. Bei einfachen Tests in der Regel noch am selben Tag. Freundliches Personal.', 'Kan alma ve laboratuvar aynı yerde olduğundan sonuçlar çok hızlı geliyor. Basit testler için genellikle aynı gün. Nazik personel.',
    0, '2024-03-24 00:00:00'),

(@user_bice_bolje, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUM5N19YeXRnRRAB',
    3, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_dragana_dojkic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUM5emV5SkdBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_jovana_terzic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUM5eWFUeW9RRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_s_b, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUN0ZzV2ZWZnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_anastasiya_mironova, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUN0OU9PWGlnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_deagle_double, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUN0eUpTajdBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_nikola_papic, @clinic_id, @doctor_dragica_becic, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUROeDhYYndRRRAB',
    5, 'hr', '10+ za Doktoricu Bečić!',
    '10+ za Doktoricu Bečić!', '10+ за Докторицу Bečić!', '10+ for Dr. Bečić!', '10+ доктору Bečić!', '10+ für Ärztin Bečić!', 'Doktor Bečić\'e 10+!',
    0, '2024-03-24 00:00:00'),

(@user_igor_dudchenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUROc2JfT2VREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_sima_savic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUMxM2Zyb0x3EAE',
    5, 'bs', 'Veoma p
rofesionalni, ljubazni preporucujem, veliki pozdrav iz Beograda',
    'Veoma p
rofesionalni, ljubazni preporucujem, veliki pozdrav iz Beograda', 'Веома професионални, љубазни, препоручујем, велики поздрав из Београда.', 'Very professional, kind, I recommend, big greetings from Belgrade.', 'Очень профессиональны, любезны, рекомендую, большой привет из Белграда.', 'Sehr professionell, freundlich, ich empfehle sie, viele Grüße aus Belgrad.', 'Çok profesyonel, nazik, tavsiye ederim, Belgrad\'dan büyük selamlar.',
    0, '2024-03-24 00:00:00'),

(@user_branko_dragisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNWcE1qNmhBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_tamara_burkova, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURsMFBhVGpBRRAB',
    5, 'ru', 'Мой лаб,хочу отметить что есть очень хороший доктор кардиолог. Oranđelovič.подробно все объяснила,доступно,дала надежду.',
    'Moj lab — želim da napomenem da ima veoma dobar doktor kardiolog. Oranđelovič. Detaljno je sve objasnila, razumljivo, dala nadu.', 'Moj lab — желим да напоменем да има веома добар доктор кардиолог. Oranđelovič. Детаљно је све објаснила, разумљиво, дала наду.', 'Moj lab — I want to note that there is a very good cardiologist. Oranđelovič. She explained everything in detail, clearly, and gave hope.', 'Мой лаб,хочу отметить что есть очень хороший доктор кардиолог. Oranđelovič.подробно все объяснила,доступно,дала надежду.', 'Moj lab — ich möchte anmerken, dass es eine sehr gute Kardiologin gibt. Oranđelovič. Sie hat alles ausführlich erklärt, verständlich, und Hoffnung gegeben.', 'Moj lab — çok iyi bir kardiyolog olduğunu belirtmek isterim. Oranđelovič. Her şeyi ayrıntılı ve anlaşılır biçimde açıkladı, umut verdi.',
    0, '2024-03-24 00:00:00'),

(@user_mehve_yamanylmaz, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNscC02Sl9nRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_djurkovic_mladen, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNsMjQzZGdnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_their_mother, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUM1cDV1Q2hRRRAB',
    4, 'ru', 'Нормальная лаборатория. Результат прислали в тот же день. По ценам сложно сказать, выбор не большой, но знатоки говорят, что цены нормальные и даже дешевле. Кровь взяли больно, но это видимо случайность, потому что сразу спросили больно ли. Пока ждала, такое произошло только со мной. Чисто, быстро, сойдет.',
    'Normalna laboratorija. Rezultate su poslali isti dan. Što se tijena tiče, teško je reći — izbor nije veliki, ali poznavači kažu da su cijene normalne i čak jeftinije. Vađenje krvi je bilo bolno, ali to je vjerovatno slučajnost, jer su odmah pitali da li boli. Dok sam čekala, samo meni se to desilo. Čisto, brzo, prihvatljivo.', 'Нормална лабораторија. Резултате су послали исти дан. Што се тијена тиче, тешко је рећи — избор није велики, али познаваоци кажу да су цијене нормалне и чак јефтиније. Вађење крви је било болно, али то је вјероватно случајност, јер су одмах питали да ли боли. Dok сам чекала, само мени се то десило. Чисто, брзо, прихватљиво.', 'A normal laboratory. They sent the results the same day. As for prices, it\'s hard to say — the selection is not large, but those in the know say the prices are fair and even cheaper. The blood draw was painful, but apparently it was a coincidence because they immediately asked if it hurt. While I was waiting, it only happened to me. Clean, fast, it\'ll do.', 'Нормальная лаборатория. Результат прислали в тот же день. По ценам сложно сказать, выбор не большой, но знатоки говорят, что цены нормальные и даже дешевле. Кровь взяли больно, но это видимо случайность, потому что сразу спросили больно ли. Пока ждала, такое произошло только со мной. Чисто, быстро, сойдет.', 'Ein normales Labor. Die Ergebnisse wurden noch am selben Tag geschickt. Was die Preise betrifft, ist es schwer zu sagen — die Auswahl ist nicht groß, aber Kenner sagen, die Preise sind in Ordnung und sogar günstiger. Die Blutabnahme war schmerzhaft, aber das war offenbar ein Zufall, da sie sofort fragten, ob es wehtut. Während ich wartete, ist das nur mir passiert. Sauber, schnell, geht in Ordnung.', 'Normal bir laboratuvar. Sonuçları aynı gün gönderdiler. Fiyatlar konusunda söylemek zor — seçenek fazla değil ama bilenler fiyatların normal, hatta daha ucuz olduğunu söylüyor. Kan alma acıtıcıydı ama bu muhtemelen bir tesadüf çünkü hemen acıyıp acımadığını sordular. Beklerken bu sadece benim başıma geldi. Temiz, hızlı, idare eder.',
    0, '2024-03-24 00:00:00'),

(@user_branislava_pleskic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUM1b1lYREl3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_nadezhda_mayorshina, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUM1bFA3YkdREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_nenad_vasic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURaemVUc2hBRRAB',
    5, 'hr', 'Profesionalni i brzi',
    'Profesionalni i brzi', 'Професионални и брзи.', 'Professional and fast.', 'Профессиональны и быстры.', 'Professionell und schnell.', 'Profesyonel ve hızlı.',
    0, '2024-03-24 00:00:00'),

(@user_viktor_kushnarev, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURabWZDRm1RRRAB',
    5, 'ru', 'Вежливо, оперативно',
    'Ljubazno, operativno.', 'Љубазно, оперативно.', 'Polite and efficient.', 'Вежливо, оперативно', 'Höflich und effizient.', 'Nazik ve hızlı.',
    0, '2024-03-24 00:00:00'),

(@user_robin_brown, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNaMnZDX3BBRRAB',
    4, 'en', 'Very professional and helpful',
    'Veoma profesionalni i od pomoći.', 'Веома професионални и од помоћи.', 'Very professional and helpful', 'Очень профессиональны и отзывчивы.', 'Sehr professionell und hilfsbereit.', 'Çok profesyonel ve yardımsever.',
    0, '2024-03-24 00:00:00'),

(@user_ljupco_matasev, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNaNHVqRHZnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_leila_akhmetova, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNaeUo2cUNBEAE',
    5, 'ru', 'Очень хорошие опытные врачи, удобно что рядом можно сдать анализы и не ждать долго, ренген отдельно,  аппаратура очень качественная и быстро все сделали, отдельное спасибо мед.персоналу которые быстро и качественно делают уколы',
    'Veoma dobri iskusni ljekari, zgodno je što se u blizini mogu raditi analize i ne čekati dugo, rendgen je posebno, oprema je veoma kvalitetna i sve su brzo uradili, posebna zahvalnost med. osoblju koje brzo i kvalitetno daju injekcije.', 'Веома добри искусни љекари, згодно је што се у близини могу радити анализе и не чекати дуго, рендген је посебно, опрема је веома квалитетна и све су брзо урадили, посебна захвалност мед. особљу које брзо и квалитетно даје инјекције.', 'Very good experienced doctors, it\'s convenient that you can get tests done nearby without waiting long, X-ray is separate, the equipment is very high quality and they did everything quickly, special thanks to the medical staff who give injections quickly and professionally.', 'Очень хорошие опытные врачи, удобно что рядом можно сдать анализы и не ждать долго, ренген отдельно,  аппаратура очень качественная и быстро все сделали, отдельное спасибо мед.персоналу которые быстро и качественно делают уколы', 'Sehr gute erfahrene Ärzte, es ist praktisch, dass man nebenan Tests machen kann, ohne lange zu warten, Röntgen ist separat, die Geräte sind sehr hochwertig und alles wurde schnell erledigt, besonderen Dank an das medizinische Personal, das Injektionen schnell und professionell verabreicht.', 'Çok iyi deneyimli doktorlar, yakınında uzun beklemeden test yaptırabilmek çok kullanışlı, röntgen ayrı bir yerde, ekipmanlar çok kaliteli ve her şeyi hızla yaptılar, enjeksiyonları hızlı ve profesyonelce yapan tıbbi personele ayrıca teşekkürler.',
    0, '2024-03-24 00:00:00'),

(@user_vera_stanivuk, @clinic_id, @doctor_dragica_becic, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURwMF9QcFRnEAE',
    5, 'hr', 'Sve pohvale za doktorku pedijatrije Dragicu Bečić, koja je vrlo profesionalna, ljubazna, strpljiva i stručna! Takođe, sve pohvale i za sestru Mariju koja je jako strpljivo i pažljivo mog petogodišnjeg sina priključila na infuziju. Istakla bih i higijenu u čitavoj ustanovi koja je na visokom nivou!',
    'Sve pohvale za doktorku pedijatrije Dragicu Bečić, koja je vrlo profesionalna, ljubazna, strpljiva i stručna! Takođe, sve pohvale i za sestru Mariju koja je jako strpljivo i pažljivo mog petogodišnjeg sina priključila na infuziju. Istakla bih i higijenu u čitavoj ustanovi koja je na visokom nivou!', 'Све похвале за докторку педијатрије Dragicu Bečić, која је врло професионална, љубазна, стрпљива и стручна! Такође, све похвале и за сестру Mariju која је јако стрпљиво и пажљиво мог петогодишњег сина прикључила на инфузију. Истакла бих и хигијену у читавој установи која је на високом нивоу!', 'All praise to the pediatrician Dragica Bečić, who is very professional, kind, patient and competent! Also, all praise to nurse Marija who very patiently and carefully connected my five-year-old son to the IV drip. I would also highlight the hygiene throughout the entire facility, which is at a high level!', 'Все похвалы педиатру Dragica Bečić, которая очень профессиональна, любезна, терпелива и компетентна! Также все похвалы медсестре Marija, которая очень терпеливо и аккуратно подключила моего пятилетнего сына к капельнице. Отдельно отмечу гигиену во всём учреждении, которая находится на высоком уровне!', 'Alles Lob für die Kinderärztin Dragica Bečić, die sehr professionell, freundlich, geduldig und kompetent ist! Außerdem alles Lob für Schwester Marija, die meinen fünfjährigen Sohn sehr geduldig und sorgfältig an den Tropf angeschlossen hat. Ich möchte auch die Hygiene in der gesamten Einrichtung hervorheben, die auf hohem Niveau ist!', 'Çocuk doktoru Dragica Bečić\'e tüm övgüler — çok profesyonel, nazik, sabırlı ve yetkin! Ayrıca beş yaşındaki oğlumu çok sabırlı ve dikkatli bir şekilde seruma bağlayan hemşire Marija\'ya da tüm övgüler. Tüm tesisteki hijyeni de özellikle vurgulamak isterim — son derece yüksek seviyede!',
    0, '2024-03-24 00:00:00'),

(@user_danijela_dj, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURwcmNUeDZBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_daniela_beuntker, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURwa2REZjRnRRAB',
    5, 'de', 'Ich wollte eine Kontrolle, ob ich eine tiefe Beinvenenthrombose habe. Telefonisch habe ich 2 Stunden später einen Termin bekommen. Exakt auf die Minute bin ich untersucht worden. Die Ärztin war mega freundlich, sehr genau und hat mir alles sehr gut auf englisch erklärt. Auch die Damen und der Herr am Empfang waren sehr freundlich. Sehr zu empfehlen.',
    'Htio/la sam provjeru da li imam duboku vensku trombozu noge. Telefonski sam dobio/la termin 2 sata kasnije. Pregledali su me tačno na minutu. Doktorica je bila mega ljubazna, veoma precizna i sve mi je vrlo dobro objasnila na engleskom. I dame i gospodin na recepciji su bili veoma ljubazni. Toplo preporučujem.', 'Хтио/ла сам провјеру да ли имам дубоку венску тромбозу ноге. Телефонски сам добио/ла термин 2 сата касније. Прегледали су ме тачно на минуту. Докторица је била мега љубазна, веома прецизна и све ми је врло добро објаснила на енглеском. И даме и господин на рецепцији су били веома љубазни. Топло препоручујем.', 'I wanted a check to see whether I have a deep vein thrombosis. I got an appointment by phone 2 hours later. I was examined exactly on time, to the minute. The doctor was incredibly friendly, very thorough and explained everything very well in English. The ladies and the gentleman at reception were also very friendly. Highly recommended.', 'Я хотел(а) провериться, есть ли у меня тромбоз глубоких вен ноги. По телефону мне дали запись через 2 часа. Меня осмотрели точно в назначенное время. Врач была очень дружелюбна, очень внимательна и всё очень хорошо объяснила на английском. Также дамы и господин на ресепшне были очень любезны. Очень рекомендую.', 'Ich wollte eine Kontrolle, ob ich eine tiefe Beinvenenthrombose habe. Telefonisch habe ich 2 Stunden später einen Termin bekommen. Exakt auf die Minute bin ich untersucht worden. Die Ärztin war mega freundlich, sehr genau und hat mir alles sehr gut auf englisch erklärt. Auch die Damen und der Herr am Empfang waren sehr freundlich. Sehr zu empfehlen.', 'Derin ven trombozu olup olmadığını kontrol ettirmek istedim. Telefonla 2 saat sonrası için randevu aldım. Tam dakikasında muayene edildim. Doktor son derece güler yüzlüydü, çok titizdi ve her şeyi İngilizce olarak çok iyi açıkladı. Resepsiyondaki hanımlar ve bay da çok güler yüzlüydü. Kesinlikle tavsiye ederim.',
    0, '2024-03-24 00:00:00'),

(@user_dragana_vergic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURwZ1lUZEFREAE',
    5, 'en', 'Super..!',
    'Super..!', 'Супер..!', 'Super..!', 'Супер..!', 'Super..!', 'Süper..!',
    0, '2024-03-24 00:00:00'),

(@user_nicolas_marioni, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURwLXBxV2ZnEAE',
    5, 'en', 'A very well-equipped establishment, with professional, competent staff who listen to patients.
I was treated and diagnosed for an intestinal infection. The nurses took the time to listen to me and diagnose the right solution for my recovery.

Many thanks to all the medical team for your help. I returned to France as planned and am currently being followed up for further tests.

I recommend this establishment. Go without fear.

NB: 10% discount on health costs if you pay with your Visa Premier bank card.',
    'Veoma dobro opremljena ustanova, sa profesionalnim, kompetentnim osobljem koje sluša pacijente.
Bio/la sam tretiran/a i dijagnosticiran/a zbog crijevne infekcije. Sestre su posvetile vrijeme da me sasluša i dijagnosticira pravo rješenje za moj oporavak.

Hvala puno cijelom medicinskom timu na pomoći. Vratio/la sam se u Francusku kako je planirano i trenutno sam pod pratnjom zbog daljnjih testova.

Preporučujem ovu ustanovu. Idite bez straha.

Napomena: 10% popusta na zdravstvene troškove ako platite Visa Premier bankovnom karticom.', 'Веома добро опремљена установа, са професионалним, компетентним особљем које слуша пацијенте.
Био/ла сам третиран/а и дијагносцитан/а због цријевне инфекције. Сестре су посветиле вријеме да ме саслуша и дијагносцира право рјешење за мој опоравак.

Хвала пуно цијелом медицинском тиму на помоћи. Вратио/ла сам се у Француску kako је планирано и тренутно сам под праћењем због даљњих тестова.

Препоручујем ову установу. Идите без страха.

Напомена: 10% попуста на здравствене трошкове ако платите Visa Premier банковном картицом.', 'A very well-equipped establishment, with professional, competent staff who listen to patients.
I was treated and diagnosed for an intestinal infection. The nurses took the time to listen to me and diagnose the right solution for my recovery.

Many thanks to all the medical team for your help. I returned to France as planned and am currently being followed up for further tests.

I recommend this establishment. Go without fear.

NB: 10% discount on health costs if you pay with your Visa Premier bank card.', 'Очень хорошо оснащённое учреждение с профессиональным, компетентным персоналом, который прислушивается к пациентам.
Меня лечили и поставили диагноз — кишечная инфекция. Медсёстры нашли время выслушать меня и подобрать правильное решение для моего выздоровления.

Большое спасибо всей медицинской команде за помощь. Я вернулся(ась) во Францию по плану и сейчас прохожу наблюдение для дальнейших анализов.

Рекомендую это учреждение. Идите без страха.

Примечание: скидка 10% на медицинские расходы при оплате банковской картой Visa Premier.', 'Eine sehr gut ausgestattete Einrichtung mit professionellem, kompetentem Personal, das auf die Patienten hört.
Ich wurde wegen einer Darminfektion behandelt und diagnostiziert. Die Schwestern nahmen sich die Zeit, mir zuzuhören und die richtige Lösung für meine Genesung zu finden.

Vielen Dank an das gesamte medizinische Team für Ihre Hilfe. Ich bin wie geplant nach Frankreich zurückgekehrt und werde derzeit für weitere Tests nachbeobachtet.

Ich empfehle diese Einrichtung. Gehen Sie ohne Angst.

Hinweis: 10% Rabatt auf Gesundheitskosten bei Zahlung mit der Visa Premier Bankkarte.', 'Hastaları dinleyen profesyonel, yetkin personele sahip çok iyi donanımlı bir tesis.
Bağırsak enfeksiyonu nedeniyle tedavi edildim ve teşhis konuldu. Hemşireler beni dinlemek ve iyileşmem için doğru çözümü bulmak için zaman ayırdı.

Tüm tıbbi ekibe yardımları için çok teşekkürler. Planlandığı gibi Fransa\'ya döndüm ve şu anda ileri testler için takip edilmekteyim.

Bu tesisi tavsiye ederim. Çekinmeden gidin.

Not: Visa Premier banka kartıyla ödeme yaparsanız sağlık masraflarında %10 indirim.',
    0, '2024-03-24 00:00:00'),

(@user_goran_vuksanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURwMG9hSDVnRRAB',
    5, 'hr', 'Profesionalni i dobri',
    'Profesionalni i dobri', 'Професионални и добри.', 'Professional and good.', 'Профессиональны и хороши.', 'Professionell und gut.', 'Profesyonel ve iyi.',
    0, '2024-03-24 00:00:00'),

(@user_anya_voron, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURweE9hclZnEAE',
    3, 'ru', 'Цены достаточно высоки, каждый приём выходит около 70 евро.
Врач Весна- прекрасный врач, 100% советую!

Но сервис оставляет желать лучшего. Я жду уже 40!! минут чтобы ТОЛЬКО  записать ребёнка ко врачу.
Ресепшн не особо доброжелателен, на простые вопросы отвечает с раздражением, это очень не приятно.

Прошу обратить внимание руководства на то, как ваши сотрудники встречают пациентов.
При таком ценнике сервис должен быть соответствующий, клиенты не должны ждать чтобы просто записаться.',
    'Cijene su dosta visoke, svaki pregled izlazi oko 70 eura.
Doktorica Vesna — odličan doktor, 100% preporučujem!

Ali servis ostavlja mnogo toga za željeti. Čekam već 40!! minuta samo da ZAPIŠEM dijete kod doktora.
Recepcija nije posebno ljubazna, na jednostavna pitanja odgovara s razdraženošću, a to je veoma neugodno.

Molim rukovodstvo da obrati pažnju na to kako vaši zaposleni dočekuju pacijente.
Pri ovakvim cijenama servis bi trebao biti odgovarajući — klijenti ne bi trebali čekati samo da se zakaže termin.', 'Цијене су доста високе, сваки преглед излази око 70 еура.
Докторица Vesna — одличан доктор, 100% препоручујем!

Али сервис оставља много тога за жељети. Чекам већ 40!! минута само да ЗАПИШЕМ дијете код доктора.
Рецепција није посебно љубазна, на једноставна питања одговара са раздраженошћу, а то је веома непријатно.

Молим руководство да обрати пажњу на то kako ваши запослени дочекују пацијенте.
При оваквим цијенама сервис би требао бити одговарајући — клијенти не би требали чекати само да се закаже термин.', 'Prices are quite high, each visit comes to around 70 euros.
Dr. Vesna — an excellent doctor, 100% recommend!

But the service leaves a lot to be desired. I have been waiting 40!! minutes just to BOOK an appointment for my child.
The reception is not particularly friendly, responding to simple questions with irritation, which is very unpleasant.

I ask management to pay attention to how your staff receive patients.
At these prices the service should match — clients should not have to wait just to make an appointment.', 'Цены достаточно высоки, каждый приём выходит около 70 евро.
Врач Весна- прекрасный врач, 100% советую!

Но сервис оставляет желать лучшего. Я жду уже 40!! минут чтобы ТОЛЬКО  записать ребёнка ко врачу.
Ресепшн не особо доброжелателен, на простые вопросы отвечает с раздражением, это очень не приятно.

Прошу обратить внимание руководства на то, как ваши сотрудники встречают пациентов.
При таком ценнике сервис должен быть соответствующий, клиенты не должны ждать чтобы просто записаться.', 'Die Preise sind ziemlich hoch, jeder Besuch kommt auf etwa 70 Euro.
Ärztin Vesna — eine ausgezeichnete Ärztin, 100% empfehlenswert!

Aber der Service lässt zu wünschen übrig. Ich warte bereits 40!! Minuten, nur um mein Kind beim Arzt ANZUMELDEN.
Der Empfang ist nicht besonders freundlich, beantwortet einfache Fragen mit Gereiztheit, was sehr unangenehm ist.

Ich bitte die Geschäftsleitung, darauf zu achten, wie Ihre Mitarbeiter die Patienten empfangen.
Bei diesen Preisen sollte der Service entsprechend sein — Kunden sollten nicht warten müssen, nur um einen Termin zu vereinbaren.', 'Fiyatlar oldukça yüksek, her ziyaret yaklaşık 70 avroya çıkıyor.
Doktor Vesna — mükemmel bir doktor, %100 tavsiye ederim!

Ancak hizmet çok şey bırakıyor istenecek. Çocuğumu doktora KAYIT yaptırmak için 40!! dakikadır bekliyorum.
Resepsiyon pek de güler yüzlü değil, basit sorulara sinirle yanıt veriyor, bu çok nahoş.

Yönetimden çalışanlarınızın hastaları nasıl karşıladığına dikkat etmesini rica ediyorum.
Bu fiyat etiketiyle hizmet de buna uygun olmalı — müşteriler sadece randevu almak için beklemek zorunda kalmamalı.',
    0, '2024-03-24 00:00:00'),

(@user_vatamania_mariana, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURwOEpxZGF3EAE',
    5, 'en', 'Good service, attentive doctors',
    'Dobra usluga, pažljivi doktori.', 'Добра услуга, пажљиви доктори.', 'Good service, attentive doctors', 'Хорошее обслуживание, внимательные врачи.', 'Guter Service, aufmerksame Ärzte.', 'İyi hizmet, ilgili doktorlar.',
    0, '2024-03-24 00:00:00'),

(@user_vida_ivanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURwOExpNEh3EAE',
    1, 'bs', 'Veceras u 20:30 h sam dovela svog trogodišnjeg sina da primi nešto protiv visoke temperature jer sirup koji sam mu dala nije odreagovao,takođe i infuziju.
Sestre su mi rekle da ne mogu da nas prime jer zatvaraju,a rade do 21 h,ja sam im pokazala izvještaj ljekara i zamolila ih da nas prime jer gori,ništa,samo su slegle ramenima pokupile se i posle,nisam sigurna da li je jedna od njih bila doktorica.
Najgore od svega je bilo sto su isped nas prošle autom i podigle rampu i spustile je,nisu sačekale da mi izadjemo tako da sam ja sa bolesnim djetetom sa visokom  temperaturom ostala zaglavljena u autu.
Na sreću ima dobrih ljudi koji su pristigli u pomoć tako da smo uspjeli da izadjemo nekako pored spuštene rampe a da ne ostetim auto.
Hvala djevojci koja radi u apoteci pored.
Ovo nije prvi put da je osoblje,ne u labarotoriji,nego na prijemu ,bilo drsko nezaineteresovano i neljubazno.
Zaobilazite ih u velikom luku, bez obzira na malo pristupacnije cijene u odnosu na ostale labarotorije.
Ljudskost na prvom mjestu.',
    'Veceras u 20:30 h sam dovela svog trogodišnjeg sina da primi nešto protiv visoke temperature jer sirup koji sam mu dala nije odreagovao,takođe i infuziju.
Sestre su mi rekle da ne mogu da nas prime jer zatvaraju,a rade do 21 h,ja sam im pokazala izvještaj ljekara i zamolila ih da nas prime jer gori,ništa,samo su slegle ramenima pokupile se i posle,nisam sigurna da li je jedna od njih bila doktorica.
Najgore od svega je bilo sto su isped nas prošle autom i podigle rampu i spustile je,nisu sačekale da mi izadjemo tako da sam ja sa bolesnim djetetom sa visokom  temperaturom ostala zaglavljena u autu.
Na sreću ima dobrih ljudi koji su pristigli u pomoć tako da smo uspjeli da izadjemo nekako pored spuštene rampe a da ne ostetim auto.
Hvala djevojci koja radi u apoteci pored.
Ovo nije prvi put da je osoblje,ne u labarotoriji,nego na prijemu ,bilo drsko nezaineteresovano i neljubazno.
Zaobilazite ih u velikom luku, bez obzira na malo pristupacnije cijene u odnosu na ostale labarotorije.
Ljudskost na prvom mjestu.', 'Вечерас у 20:30 ч сам довела свог трогодишњег сина да прими нешто против високе температуре јер сируп који сам му дала није одреаговао, такође и инфузију.
Сестре су ми рекле да не могу да нас приме јер затварају, а раде до 21 ч, ја сам им показала извјештај љекара и замолила их да нас приме јер гори, ништа, само су слегле раменима скупиле се и после, нисам сигурна да ли јеједна од њих била докторица.
Најгоре од свега је било што су испред нас прошле аутом и подигле рампу и спустиле је, нису сачекале да ми изађемо тако да сам ја са болесним дијететом са високом температуром остала загљављена у ауту.
На срећу има добрих људи који су пристигли у помоћ тако да смо успјели да изађемо некако поред спуштене рампе а да не оштетим ауто.
Хвала дјевојци која ради у апотеци поред.
Ово није први пут да је особље, не у лабораторији, него на пријему, било дрско, незаинтересовано и нељубазно.
Заобилазите их у великом луку, без обзира на мало приступачније цијене у односу на остале лабораторије.
Људскост на првом мјесту.', 'This evening at 8:30 PM I brought my three-year-old son to receive something for his high fever because the syrup I had given him hadn\'t worked, and also for an IV drip.
The nurses told me they couldn\'t see us because they were closing, even though they work until 9 PM. I showed them the doctor\'s report and asked them to take us in because he was burning up — nothing, they just shrugged, gathered their things and left. I\'m not sure if one of them was a doctor.
The worst of it all was that they drove out in front of us, raised the barrier and lowered it — they didn\'t wait for us to exit, so I was stuck in the car with a sick child running a high fever.
Luckily some kind people came to help so we managed to get out somehow beside the lowered barrier without damaging the car.
Thank you to the girl working at the pharmacy next door.
This is not the first time the staff — not in the lab, but at reception — have been arrogant, disinterested and unfriendly.
Avoid them by a wide margin, regardless of their slightly more accessible prices compared to other laboratories.
Humanity comes first.', 'Сегодня вечером в 20:30 я привела своего трёхлетнего сына, чтобы ему дали что-нибудь от высокой температуры, потому что сироп не помог, а также поставили капельницу.
Медсёстры сказали, что не могут нас принять, потому что закрываются, хотя работают до 21:00. Я показала им заключение врача и попросила принять, потому что ребёнок горит — ничего, просто пожали плечами, собрались и ушли. Не уверена, была ли одна из них врачом.
Хуже всего было то, что они проехали мимо нас на машине, подняли шлагбаум и опустили его — не подождали, пока мы выедем, так что я с больным ребёнком с высокой температурой застряла в машине.
К счастью, нашлись добрые люди, которые помогли, и мы как-то смогли выбраться мимо опущенного шлагбаума без повреждений.
Спасибо девушке из соседней аптеки.
Это не первый раз, когда персонал — не в лаборатории, а на приёме — ведёт себя нагло, безразлично и нелюбезно.
Обходите их стороной, несмотря на немного более доступные цены по сравнению с другими лабораториями.
Человечность прежде всего.', 'Heute Abend um 20:30 Uhr brachte ich meinen dreijährigen Sohn, damit er etwas gegen das hohe Fieber bekommt, da der Sirup, den ich ihm gegeben hatte, nicht gewirkt hatte, und auch einen Tropf.
Die Schwestern sagten mir, sie könnten uns nicht aufnehmen, weil sie schließen — dabei arbeiten sie bis 21 Uhr. Ich zeigte ihnen den Arztbericht und bat sie, uns aufzunehmen, weil er brannte. Nichts — sie zuckten nur mit den Schultern, packten ihre Sachen und gingen. Ich bin nicht sicher, ob eine von ihnen Ärztin war.
Das Schlimmste war, dass sie mit dem Auto an uns vorbeifuhren, die Schranke hochzogen und wieder herunterlassen — sie warteten nicht darauf, dass wir herausfahren können, sodass ich mit meinem kranken Kind mit hohem Fieber im Auto feststeckte.
Glücklicherweise kamen gute Menschen zur Hilfe, sodass wir es irgendwie neben der heruntergelassenen Schranke heraus schafften, ohne das Auto zu beschädigen.
Danke an das Mädchen, das in der Apotheke nebenan arbeitet.
Es ist nicht das erste Mal, dass das Personal — nicht im Labor, sondern an der Rezeption — arrogant, desinteressiert und unfreundlich war.
Meidet sie in einem großen Bogen, ungeachtet der etwas zugänglicheren Preise im Vergleich zu anderen Labors.
Menschlichkeit geht vor.', 'Bu akşam saat 20:30\'da, verdiğim şurup işe yaramadığı için yüksek ateşine karşı bir şey alması ve serum takılması için üç yaşındaki oğlumu getirdim.
Hemşireler kapandıkları için bizi kabul edemeyeceklerini söyledi, oysa saat 21:00\'a kadar çalışıyorlar. Doktor raporunu gösterdim ve oğlum ateş içinde yandığı için bizi almalarını istedim — hiçbir şey, sadece omuz silktiler, toplanıp gittiler. Birinin doktor olup olmadığından bile emin değilim.
En kötüsü şuydu ki önümüzden araçla geçip bariyer kaldırdılar ve indirdiler — çıkışımızı beklemediler, böylece yüksek ateşli hasta çocuğumla arabada mahsur kaldım.
Neyse ki yardımına koşan iyi insanlar sayesinde arabayı hasarsız biçimde indirilmiş bariyerin yanından bir şekilde çıkabildik.
Yandaki eczanede çalışan kıza teşekkürler.
Personelin — laboratuvarda değil, resepsiyonda — küstah, ilgisiz ve kaba olması bu ilk kez değil.
Diğer laboratuvarlara kıyasla biraz daha uygun fiyatlarına rağmen onlardan uzak durun.
İnsanlık her şeyden önce gelir.',
    0, '2024-03-24 00:00:00'),

(@user_aleksandra_breschke, @clinic_id, @doctor_dragica_becic, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNwejVYcU1BEAE',
    5, 'de', 'Wir waren bei moj lab mit unserem Sohn, der auf einen Seeigel getreten ist und Schmerzen hatte. Das Personal hat uns freundlich empfangen und die Ärztin Frau Dr. Bečić war sehr professionelle und liebevoll zu unserem Kind. Wir waren sehr zufrieden mit der Behandlung. Klare Weiterempfehleung.',
    'Bili smo u Moj lab sa našim sinom koji je stao na morskog ježa i osjećao bolove. Osoblje nas je ljubazno primilo, a doktorica Bečić je bila veoma profesionalna i nježna prema našem djetetu. Bili smo veoma zadovoljni tretmanom. Jasna preporuka.', 'Били смо у Moj lab са нашим сином који је стао на морског јежа и осјећао болове. Особље нас је љубазно примило, а докторица Bečić је била веома професионална и нјежна према нашем дијетету. Били смо веома задовољни третманом. Јасна препорука.', 'We went to Moj lab with our son, who had stepped on a sea urchin and was in pain. The staff welcomed us warmly and the doctor, Dr. Bečić, was very professional and caring towards our child. We were very satisfied with the treatment. A clear recommendation.', 'Мы были в Moj lab с нашим сыном, который наступил на морского ежа и испытывал боль. Персонал встретил нас дружелюбно, а доктор Bečić была очень профессиональна и внимательна к нашему ребёнку. Мы были очень довольны лечением. Однозначно рекомендуем.', 'Wir waren bei moj lab mit unserem Sohn, der auf einen Seeigel getreten ist und Schmerzen hatte. Das Personal hat uns freundlich empfangen und die Ärztin Frau Dr. Bečić war sehr professionelle und liebevoll zu unserem Kind. Wir waren sehr zufrieden mit der Behandlung. Klare Weiterempfehleung.', 'Moj lab\'a deniz kirpisi üzerine basmış ve ağrı çeken oğlumuzla birlikte gittik. Personel bizi güler yüzle karşıladı ve Dr. Bečić çocuğumuza karşı çok profesyonel ve sevecendi. Tedaviden çok memnun kaldık. Kesinlikle tavsiye ederiz.',
    0, '2024-03-24 00:00:00'),

(@user_jelena_marjanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNwaDlTUmR3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_nevena_cabarkapa, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNwZzhfTzVBRRAB',
    1, 'bs', 'Neljubazne sestre, ceka se i pored zakazanog tremina vise od pola sata, niko se ne izvinjava zbog toga. Bukvalno im je muka da pricaju.',
    'Neljubazne sestre, ceka se i pored zakazanog tremina vise od pola sata, niko se ne izvinjava zbog toga. Bukvalno im je muka da pricaju.', 'Нељубазне сестре, чека се и поред заказаног термина више од пола сата, нико се не извињава због тога. Буквално им је мука да причају.', 'Unfriendly nurses, you wait more than half an hour even with a scheduled appointment, and nobody apologises for it. They literally can\'t be bothered to talk.', 'Нелюбезные медсёстры, даже с записью ждёшь больше получаса, и никто не извиняется. Им буквально в тягость разговаривать.', 'Unfreundliche Schwestern, man wartet trotz eines vereinbarten Termins mehr als eine halbe Stunde, niemand entschuldigt sich dafür. Es ist ihnen buchstäblich lästig zu reden.', 'Güler yüzsüz hemşireler, randevunuz olsa bile yarım saatten fazla bekliyorsunuz ve kimse özür dilemiyor. Konuşmak onlara kelimenin tam anlamıyla eziyet gibi geliyor.',
    0, '2024-03-24 00:00:00'),

(@user_aleksandr_mogilev, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNwcWZicWVBEAE',
    4, 'ru', 'Неплохая клиника и достаточно дорогая, за снимок и укол обезбола взяли 70€, в отделении Будвы нет травмотолога!!!! В целом все доброжелательны и стараются помочь!',
    'Nije loša klinika i dosta je skupa — za snimak i injekciju anestetika uzeli su 70€, u odjeljenju Budve nema traumatologa!!!! Generalno, svi su dobronamjerni i trude se da pomognu!', 'Није лоша клиника и доста је скупа — за снимак и ињекцију анестетика узели су 70€, у одјељењу Будве нема трауматолога!!!! Генерално, сви су добронамјерни и труде се да помогну!', 'Not a bad clinic and quite expensive — they charged 70€ for an X-ray and a painkiller injection. The Budva branch has no traumatologist!!!! Overall everyone is friendly and tries to help!', 'Неплохая клиника и достаточно дорогая, за снимок и укол обезбола взяли 70€, в отделении Будвы нет травмотолога!!!! В целом все доброжелательны и стараются помочь!', 'Keine schlechte Klinik, aber ziemlich teuer — für eine Röntgenaufnahme und eine Schmerzspritze wurden 70€ berechnet. In der Filiale in Budva gibt es keinen Traumatologen!!!! Insgesamt sind alle freundlich und bemühen sich zu helfen!', 'Fena bir klinik değil ama oldukça pahalı — röntgen ve ağrı kesici enjeksiyon için 70€ aldılar. Budva şubesinde travmatolog yok!!!! Genel olarak herkes güler yüzlü ve yardımcı olmaya çalışıyor!',
    0, '2024-03-24 00:00:00'),

(@user_melik_trkmenolu, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNwMGJQLWFBEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_denis_bo, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNwMHBySDB3RRAB',
    5, 'ru', 'Были у педиатора с больным ребёнком. Приняли сразу же.
Весна отлично говорит на русском.
Всё грамотно осмотрела, назначила анализы, которые немедленно сдали в их же лаборатории в соседнем подъезде. Результаты тестов были готовы очень быстро. Это помогло правильно определить лечение.
Цены приемлемые, на повторные приёмы цена ниже.
Рекомендую.
У мед.центра есть своя парковка. Но для нас её открыть не смогли. Запарковаться вокруг не просто.',
    'Bili smo kod pedijatra sa bolesnim djetetom. Primili su nas odmah.
Vesna odlično govori ruski.
Sve je kompetentno pregledala, naručila analize koje smo odmah uradili u njihovoj laboratoriji u susjednom ulazu. Rezultati testova su bili gotovi veoma brzo. To je pomoglo da se pravilno odredi liječenje.
Cijene su prihvatljive, na ponovne posjete cijena je niža.
Preporučujem.
Medicinski centar ima svoju parkiraonu. Ali za nas je nisu mogli otvoriti. Parkirati se okolo nije lako.', 'Били смо код педијатра са болесним дијететом. Примили су нас одмах.
Vesna одлично говори руски.
Све је компетентно прегледала, наручила анализе које смо одмах урадили у њиховој лабораторији у сусједном улазу. Резултати тестова су били готови веома брзо. То је помогло да се правилно одреди лијечење.
Цијене су прихватљиве, на поновне посјете цијена је нижа.
Препоручујем.
Медицински центар има своју паркираону. Али за нас је нису могли отворити. Паркирати се около није лако.', 'We visited the pediatrician with a sick child. They received us right away.
Vesna speaks Russian excellently.
She examined everything competently, ordered tests which we immediately took at their laboratory in the adjacent entrance. The test results were ready very quickly. This helped determine the right treatment.
Prices are reasonable, with a lower price for repeat visits.
I recommend.
The medical centre has its own parking. But they couldn\'t open it for us. Parking nearby is not easy.', 'Были у педиатора с больным ребёнком. Приняли сразу же.
Весна отлично говорит на русском.
Всё грамотно осмотрела, назначила анализы, которые немедленно сдали в их же лаборатории в соседнем подъезде. Результаты тестов были готовы очень быстро. Это помогло правильно определить лечение.
Цены приемлемые, на повторные приёмы цена ниже.
Рекомендую.
У мед.центра есть своя парковка. Но для нас её открыть не смогли. Запарковаться вокруг не просто.', 'Wir waren mit einem kranken Kind beim Kinderarzt. Sie haben uns sofort empfangen.
Vesna spricht ausgezeichnet Russisch.
Sie hat alles kompetent untersucht, Tests angeordnet, die wir sofort in ihrem Labor im Nachbareingang abgegeben haben. Die Testergebnisse waren sehr schnell fertig. Das half dabei, die richtige Behandlung zu bestimmen.
Die Preise sind akzeptabel, bei Wiederholungsbesuchen ist der Preis niedriger.
Ich empfehle es.
Das medizinische Zentrum hat einen eigenen Parkplatz. Aber für uns konnten sie ihn nicht öffnen. Das Parken in der Umgebung ist nicht einfach.', 'Hasta çocuğumuzla pediatriste gittik. Bizi hemen kabul ettiler.
Vesna mükemmel Rusça konuşuyor.
Her şeyi yetkin biçimde muayene etti, hemen yanındaki girişlerindeki laboratuvarda yaptırdığımız testleri istedi. Test sonuçları çok hızlı hazır oldu. Bu, doğru tedaviyi belirlemeye yardımcı oldu.
Fiyatlar makul, tekrar ziyaretlerde fiyat daha düşük.
Tavsiye ederim.
Tıp merkezinin kendi otoparkı var. Ama bizim için açamadılar. Çevrede park etmek kolay değil.',
    0, '2024-03-24 00:00:00'),

(@user_evgenia_kolesnikova, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUN4dDRETHlnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_dv, @clinic_id, @doctor_mladen_perisic, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUN4aGIyMWlnRRAB',
    5, 'hr', 'Izuzetni, profesionalni i ljubazni.
Dr Mladen Perišić izuzetan čovjek i doktor.
Sve pohvale!',
    'Izuzetni, profesionalni i ljubazni.
Dr Mladen Perišić izuzetan čovjek i doktor.
Sve pohvale!', 'Изузетни, професионални и љубазни.
Dr Mladen Perišić изузетан човјек и доктор.
Све похвале!', 'Exceptional, professional and kind.
Dr Mladen Perišić is an exceptional person and doctor.
All the praise!', 'Исключительны, профессиональны и любезны.
Dr Mladen Perišić — выдающийся человек и врач.
Все похвалы!', 'Außergewöhnlich, professionell und freundlich.
Dr Mladen Perišić ist ein außergewöhnlicher Mensch und Arzt.
Alles Lob!', 'Olağanüstü, profesyonel ve nazik.
Dr Mladen Perišić olağanüstü bir insan ve doktor.
Tüm övgüler!',
    0, '2024-03-24 00:00:00'),

(@user_pierluigi_salvatore, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURSNW95UWJ3EAE',
    1, 'en', 'I was there for a wound, they told me that I must go somewhere else and for this fantastic suggestion I paid 40€.',
    'Bio sam tamo zbog rane, rekli su mi da moram ići negdje drugdje i za ovaj fantastičan prijedlog sam platio 40€.', 'Био сам тамо због ране, рекли су ми да морам ићи негдје другдје и за овај фантастичан приједлог сам платио 40€.', 'I was there for a wound, they told me that I must go somewhere else and for this fantastic suggestion I paid 40€.', 'Я пришёл туда с раной, мне сказали, что нужно обратиться в другое место, и за этот замечательный совет я заплатил 40€.', 'Ich war dort wegen einer Wunde, man sagte mir, ich müsse woanders hingehen, und für diesen fantastischen Vorschlag habe ich 40€ bezahlt.', 'Bir yara için oraya gittim, başka bir yere gitmem gerektiğini söylediler ve bu harika öneri için 40€ ödedim.',
    0, '2024-03-24 00:00:00'),

(@user_arko, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURSZ0xuY3V3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_ivan_ivan, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNSazVxU3JnRRAB',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_aranski_ribolov_carp_fishing, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURobnNXUGRBEAE',
    5, 'hr', 'Vrlo stručni, predusretljivi, ljubazni!
Pa kad te sa osmjehom dočekaju, odma\' ti lakše 🙂 …',
    'Vrlo stručni, predusretljivi, ljubazni!
Pa kad te sa osmjehom dočekaju, odma\' ti lakše 🙂 …', 'Врло стручни, предусретљиви, љубазни!
Па кад те са осмјехом дочекају, одма\' ти лакше 🙂 …', 'Very professional, attentive, and kind!
When they greet you with a smile, you immediately feel better 🙂 …', 'Очень профессиональные, внимательные, доброжелательные!
Когда встречают с улыбкой, сразу становится легче 🙂 …', 'Sehr fachkundig, zuvorkommend und freundlich!
Wenn sie einen mit einem Lächeln empfangen, fühlt man sich gleich besser 🙂 …', 'Çok uzman, ilgili ve nazik!
Sizi gülümseyerek karşıladıklarında, hemen kendinizi daha iyi hissediyorsunuz 🙂 …',
    0, '2023-03-24 00:00:00'),

(@user_marko_zec, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURoMUxLMXdBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-03-24 00:00:00'),

(@user_dejan_kaluerovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNobjVLdXlRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-03-24 00:00:00'),

(@user_mirjana_jovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNoX2VQaFl3EAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-03-24 00:00:00'),

(@user_anastasiya_vlasova, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNoNEpHbDhRRRAB',
    5, 'ru', 'Сдавали общий анализ крови, показатели дефицита железа,витамины - оформление прошло за пару минут,доброжелательно, взятие крови еще быстрее, результат был готов в этот же день и пришел на указанную мной почту.Большое спасибо за оперативность и удобство!:)',
    'Radili smo opštu krvnu sliku, pokazatelje deficita gvožđa, vitamine — prijem je prošao za par minuta, ljubazno, uzimanje krvi još brže, rezultat je bio gotov istog dana i stigao na e-mail koji sam naveo. Hvala puno na efikasnosti i pogodnosti! :)', 'Радили смо општу крвну слику, показатеље дефицита гвожђа, витамине — пријем је прошао за пар минута, љубазно, узимање крви још брже, резултат је био готов истог дана и стигао на е-маил који сам навео. Хвала пуно на ефикасности и погодности! :)', 'We did a complete blood count, iron deficiency indicators, vitamins — the registration took a couple of minutes, very friendly, blood draw even faster, the result was ready the same day and came to the email I provided. Thank you so much for the efficiency and convenience! :)', 'Сдавали общий анализ крови, показатели дефицита железа,витамины - оформление прошло за пару минут,доброжелательно, взятие крови еще быстрее, результат был готов в этот же день и пришел на указанную мной почту.Большое спасибо за оперативность и удобство!:)', 'Wir haben ein großes Blutbild machen lassen, Eisenmangelwerte, Vitamine — die Anmeldung dauerte nur ein paar Minuten, sehr freundlich, die Blutabnahme war noch schneller, das Ergebnis war noch am selben Tag fertig und kam an die von mir angegebene E-Mail. Vielen Dank für die Schnelligkeit und den Komfort! :)', 'Tam kan sayımı, demir eksikliği göstergeleri ve vitaminler için test yaptırdık — kayıt birkaç dakika sürdü, çok dostane bir şekilde, kan alımı daha da hızlıydı, sonuç aynı gün hazırdı ve belirttiğim e-postaya geldi. Hız ve kolaylık için çok teşekkürler! :)',
    0, '2023-03-24 00:00:00'),

(@user_evgeniy, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURCcnM3Sm1nRRAB',
    5, 'ru', 'Ходили к терапевту, с гриппом. В принципе на английском+сербском мы поняли врача, симптомы объясняли заготовками на сербском.
Главное, что получили рецепт на антибиотики, прописали пробиотик, витамины, в общем абсолютно нормальный пакет местных лекарств, чего и хотели. Анализы тоже выписали, но как рекомендация, мы на ресепции отмазались, что потом запишемся. Приём стоило где-то 30 евро, столько же вышли лекарства в аптеке. Нормально.',
    'Išli smo kod terapeuta, s gripom. U principu na engleskom+srpskom razumeli smo doktora, simptome smo objašnjavali unapred pripremljenim frazama na srpskom.
Najvažnije je da smo dobili recept za antibiotike, propisan je probiotik, vitamini, ukratko sasvim normalan paket lokalnih lekova, što smo i hteli. Analize su nam takođe prepisali, ali kao preporuku — na recepciji smo se izvukli da ćemo se kasnije naručiti. Pregled je koštao oko 30 evra, lekovi u apoteci isto toliko. Normalno.', 'Ишли смо код терапеута, с грипом. У принципу на енглеском+српском разумели смо доктора, симптоме смо објашњавали унапред припремљеним фразама на српском.
Најважније је да смо добили рецепт за антибиотике, прописан је пробиотик, витамини, укратко сасвим нормалан пакет локалних лекова, што смо и хтели. Анализе су нам такође преписали, али као препоруку — на рецепцији смо се извукли да ћемо се касније наручити. Преглед је коштао око 30 евра, лекови у апотеци исто толико. Нормално.', 'We went to the GP with the flu. We more or less understood the doctor in English + Serbian, we explained symptoms using pre-prepared phrases in Serbian.
The main thing is that we got a prescription for antibiotics, a probiotic was prescribed, vitamins — in general, a completely standard package of local medicines, which is what we wanted. They also prescribed tests, but as a recommendation — at the reception we got out of it by saying we\'d book later. The appointment cost around 30 euros, the medicines at the pharmacy cost the same. Fine.', 'Ходили к терапевту, с гриппом. В принципе на английском+сербском мы поняли врача, симптомы объясняли заготовками на сербском.
Главное, что получили рецепт на антибиотики, прописали пробиотик, витамины, в общем абсолютно нормальный пакет местных лекарств, чего и хотели. Анализы тоже выписали, но как рекомендация, мы на ресепции отмазались, что потом запишемся. Приём стоило где-то 30 евро, столько же вышли лекарства в аптеке. Нормально.', 'Wir gingen mit einer Grippe zum Allgemeinmediziner. Im Prinzip haben wir den Arzt auf Englisch+Serbisch verstanden, die Symptome erklärten wir mit vorbereiteten Formulierungen auf Serbisch.
Das Wichtigste ist, dass wir ein Rezept für Antibiotika bekommen haben, ein Probiotikum wurde verschrieben, Vitamine — insgesamt ein völlig normales Paket lokaler Medikamente, was wir wollten. Blutuntersuchungen wurden auch ausgestellt, aber als Empfehlung — an der Rezeption haben wir uns damit herausgeredet, dass wir uns später anmelden würden. Die Konsultation kostete ca. 30 Euro, die Medikamente in der Apotheke genauso viel. In Ordnung.', 'Grip nedeniyle pratisyen hekime gittik. Prensipte İngilizce+Sırpça doktoru anladık, semptomları Sırpça önceden hazırlanmış ifadelerle anlattık.
En önemlisi antibiyotik reçetesi aldık, probiyotik ve vitamin yazıldı — kısacası istediğimiz tamamen normal bir yerel ilaç paketi. Tahliller de yazıldı ama tavsiye olarak — resepsiyonda sonra randevu alacağımızı söyleyerek kurtulduk. Muayene yaklaşık 30 Euro\'ya mal oldu, eczanedeki ilaçlar da aynı kadar. Normal.',
    0, '2023-03-24 00:00:00'),

(@user_yevgeniya_vasylevskaya, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNCdC1iT2RREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-03-24 00:00:00'),

(@user_daria_trepke, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNCNjh6N3lBRRAB',
    5, 'ru', 'Быстро оказали помощь и направили на анализы.',
    NULL, NULL, NULL, 'Быстро оказали помощь и направили на анализы.', NULL, NULL,
    0, '2023-03-24 00:00:00'),

(@user_aleksandra_rosic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUQtZzRTUDdnRRAB',
    5, 'bs', 'Super su. I cene su odlicne.',
    'Super su. I cene su odlicne.', 'Супер су. И цене су одличне.', 'They are great. And the prices are excellent.', 'Отличные. И цены тоже отличные.', 'Sie sind super. Und die Preise sind ausgezeichnet.', 'Hariкalar. Ve fiyatlar da mükemmel.',
    0, '2023-03-24 00:00:00'),

(@user_ljiljana_jaric_maslak, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUMtd1l1ejFBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-03-24 00:00:00'),

(@user_milletvekili, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNlOWFpVnNRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-03-24 00:00:00'),

(@user_marija_puri, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNlMUtXUF9nRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-03-24 00:00:00'),

(@user_shkelqim_muqa, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUR1eWRuVXZ3RRAB',
    5, 'de', 'Ich und meine schwangere Frau gingen nach eine Covid Infektion in die Behandlung zu MojLab.
Das freundliche und kompetente Team konnte perfekt Englisch, was für und als Touristen super war!
Ich empfehle diese Klinik jedem Tourist.
Danke an das tolle Team von MojLab',
    'Ja i moja trudna supruga otišli smo na lečenje u MojLab nakon Covid infekcije.
Ljubazni i kompetentni tim je savršeno govorio engleski, što je za nas kao turiste bilo odlično!
Preporučujem ovu kliniku svakom turistu.
Hvala sjajnom timu MojLab-a', 'Ја и моја трудна супруга отишли смо на лечење у MojLab након Ковид инфекције.
Љубазни и компетентни тим је савршено говорио енглески, што је за нас као туристе било одлично!
Препоручујем ову клинику сваком туристи.
Хвала сјајном тиму MojLab-а', 'My pregnant wife and I went to MojLab for treatment after a Covid infection.
The friendly and competent team spoke perfect English, which was great for us as tourists!
I recommend this clinic to every tourist.
Thanks to the great team at MojLab', 'Мы с беременной женой обратились за лечением в MojLab после заражения Covid.
Дружелюбная и компетентная команда прекрасно говорила по-английски, что для нас как для туристов было отлично!
Рекомендую эту клинику каждому туристу.
Спасибо замечательной команде MojLab', 'Ich und meine schwangere Frau gingen nach eine Covid Infektion in die Behandlung zu MojLab.
Das freundliche und kompetente Team konnte perfekt Englisch, was für und als Touristen super war!
Ich empfehle diese Klinik jedem Tourist.
Danke an das tolle Team von MojLab', 'Hamile eşim ve ben Covid enfeksiyonunun ardından MojLab\'a tedavi için gittik.
Dostane ve yetkin ekip mükemmel İngilizce konuşuyordu, bu da turistler olarak bizim için harikaydı!
Bu kliniği her turiste tavsiye ediyorum.
MojLab\'ın harika ekibine teşekkürler',
    0, '2023-03-24 00:00:00'),

(@user_aleksandar, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUR1cXZLUEdBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-03-24 00:00:00'),

(@user_boris_lukic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUR1c3A2Nm1nRRAB',
    5, 'de', 'Haben uns im Urlaub super geholfen',
    'Odlično su nam pomogli tokom odmora', 'Одлично су нам помогли током одмора', 'They helped us wonderfully during our vacation', 'Отлично помогли нам во время отпуска', 'Haben uns im Urlaub super geholfen', 'Tatilde bize harika yardımcı oldular',
    0, '2023-03-24 00:00:00'),

(@user_elena_sergeeva, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUN1Z2E3ZElnEAE',
    1, 'ru', '1 адрес неверный
2 пришла к 20:00,"сказали что не работают, хотя на двери указано, что работают до 21:00😬 …',
    '1 adresa je pogrešna
2 došla sam u 20:00, rekli su da ne rade, iako je na vratima naznačeno da rade do 21:00 😬 …', '1 адреса је погрешна
2 дошла сам у 20:00, рекли су да не раде, иако је на вратима назначено да раде до 21:00 😬 …', '1 the address is wrong
2 I came at 20:00, they said they were closed, even though the door says they work until 21:00 😬 …', '1 адрес неверный
2 пришла к 20:00,"сказали что не работают, хотя на двери указано, что работают до 21:00😬 …', '1 Die Adresse ist falsch
2 Ich kam um 20:00 Uhr, sie sagten, sie haben nicht geöffnet, obwohl an der Tür steht, dass sie bis 21:00 Uhr geöffnet haben 😬 …', '1 adres yanlış
2 saat 20:00\'de geldim, kapıda 21:00\'e kadar açık olduklarını yazdığı halde çalışmadıklarını söylediler 😬 …',
    0, '2023-03-24 00:00:00'),

(@user_goran_rudakov, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUQyeTVlV09nEAE',
    4, 'hr', 'Brzi , profesionalni !',
    'Brzi , profesionalni !', 'Брзи, професионални!', 'Fast and professional!', 'Быстро и профессионально!', 'Schnell und professionell!', 'Hızlı ve profesyonel!',
    0, '2023-03-24 00:00:00'),

(@user_radomir_petrovi_rade, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUQycExQMU5BEAE',
    1, 'hr', 'Katastrofa, neažurni i nesposobni👎 …',
    'Katastrofa, neažurni i nesposobni👎 …', 'Катастрофа, неажурни и неспособни 👎 …', 'Catastrophe, inefficient and incompetent 👎 …', 'Катастрофа, безответственные и некомпетентные 👎 …', 'Katastrophe, unzuverlässig und inkompetent 👎 …', 'Felaket, verimsiz ve yetersiz 👎 …',
    0, '2023-03-24 00:00:00'),

(@user_perisa_piletic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUQyNE1tNXNRRRAB',
    2, 'hr', 'Dobri su',
    'Dobri su', 'Добри су', 'They are good', 'Хорошие', 'Sie sind gut', 'İyiler',
    0, '2023-03-24 00:00:00'),

(@user_ekaterina_hag, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUMyallMYVZnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-03-24 00:00:00'),

(@user_tal_schechter, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUMyakx2Y1FREAE',
    5, 'en', 'I went here for a rapid test. I don\'t know what all negative reviews are about. It was quick and easy. The receptionists/nurses were pleasant. I had no wait. In 20 minutes, I received the result by email. I was shopping nearby and also asked for a print-out. They did this too, with no problem and no waiting.',
    'Došao sam ovde zbog brzog testa. Ne znam o čemu govore svi negativni komentari. Bilo je brzo i lako. Recepcionerke/medicinske sestre su bile prijatne. Nisam čekao. Za 20 minuta dobio sam rezultat e-mailom. Kupovao sam u blizini i tražio i ispis. Uradili su i to, bez problema i bez čekanja.', 'Дошао сам овде због брзог теста. Не знам о чему говоре сви негативни коментари. Било је брзо и лако. Рецепционерке/медицинске сестре су биле пријатне. Нисам чекао. За 20 минута добио сам резултат е-маилом. Куповао сам у близини и тражио и испис. Урадили су и то, без проблема и без чекања.', 'I went here for a rapid test. I don\'t know what all negative reviews are about. It was quick and easy. The receptionists/nurses were pleasant. I had no wait. In 20 minutes, I received the result by email. I was shopping nearby and also asked for a print-out. They did this too, with no problem and no waiting.', 'Пришёл сюда ради экспресс-теста. Не знаю, о чём все негативные отзывы. Всё прошло быстро и легко. Администраторы/медсёстры были приятными. Ждать не пришлось. Через 20 минут получил результат по электронной почте. Я был в магазинах поблизости и попросил распечатку. Сделали и это — без проблем и без ожидания.', 'Ich kam hier für einen Schnelltest. Ich weiß nicht, worum es bei all den negativen Bewertungen geht. Es war schnell und einfach. Die Rezeptionistinnen/Krankenschwestern waren angenehm. Ich musste nicht warten. In 20 Minuten erhielt ich das Ergebnis per E-Mail. Ich war in der Nähe einkaufen und bat auch um einen Ausdruck. Das haben sie auch gemacht, ohne Probleme und ohne Wartezeit.', 'Hızlı test için buraya geldim. Tüm olumsuz yorumların ne hakkında olduğunu anlamıyorum. Hızlı ve kolaydı. Resepsiyon görevlileri/hemşireler nazikti. Beklemedim. 20 dakika içinde sonucu e-postayla aldım. Yakında alışveriş yapıyordum ve çıktı da istedim. Bunu da hiç sorunsuz ve bekletmeden yaptılar.',
    0, '2023-03-24 00:00:00'),

(@user_lynne_adams, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURXcjdMQy13RRAB',
    3, 'en', 'Great service but didn\'t receive results on email so phoned checked email  they said they would send again but no joy so had to collect in person !!',
    'Odlična usluga, ali nisam dobio rezultate na e-mail, pa sam nazvao i provjerio e-mail, rekli su da će ponovo poslati, ali bezuspješno, pa sam morao lično doći po njih!!', 'Одлична услуга, али нисам добио резултате на е-маил, па сам назвао и провјерио е-маил, рекли су да ће поново послати, али безуспјешно, па сам морао лично доћи по њих!!', 'Great service but didn\'t receive results on email so phoned checked email  they said they would send again but no joy so had to collect in person !!', 'Отличный сервис, но результаты на почту не пришли — позвонил, проверил почту, сказали, что отправят снова, но так и не пришли, пришлось забирать лично!!', 'Toller Service, aber ich habe die Ergebnisse nicht per E-Mail erhalten, also habe ich angerufen und die E-Mail überprüft, sie sagten, sie würden es erneut senden, aber nichts kam, also musste ich sie persönlich abholen!!', 'Harika hizmet ama sonuçları e-postayla almadım, bu yüzden aradım ve e-postayı kontrol ettim, tekrar göndereceklerini söylediler ama gelmedi, bu yüzden bizzat almak zorunda kaldım!!',
    0, '2023-03-24 00:00:00'),

(@user_krsto_mai, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURXckpxUzh3RRAB',
    5, 'en', 'Super 👌 …',
    'Super 👌 …', 'Супер 👌 …', 'Super 👌 …', 'Супер 👌 …', 'Super 👌 …', 'Süper 👌 …',
    0, '2022-03-24 00:00:00'),

(@user_pavel_ostrikov, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNXakppR2lRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_maksim_oleynik, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURteWZ6REhREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_aleksandar_stevanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURtOGZiaDB3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_denis_anufriev, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURtZ2ZEbU13EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_djurdja_vukicevic_exnokovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURtbHQtU19RRRAB',
    2, 'bs', 'Rezultati se cekaju dugo. Ima puno boljih labaratorija',
    'Rezultati se cekaju dugo. Ima puno boljih labaratorija', 'Резултати се чекају дуго. Има пуно бољих лабораторија', 'You wait a long time for results. There are many better laboratories.', 'Результатов ждать долго. Есть много лучших лабораторий.', 'Man wartet lange auf die Ergebnisse. Es gibt viele bessere Laboratorien.', 'Sonuçlar için uzun süre bekliyorsunuz. Çok daha iyi laboratuvarlar var.',
    0, '2022-03-24 00:00:00'),

(@user_stefi_333, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURHMjlQUU1nEAE',
    1, 'bs', 'Moja je preporuka da izbegavate!
Uradio sam neke nalaze i trebali su biti gotovi za dva dana, mjesec dana je proslo i nema ni traga ni glasa od rezultata.
A sad mi se ni ne javljaju na telefon.
Ali mogli su da naplate odmah!!!!!!!
Topla preporuka da ne idete ovde!',
    'Moja je preporuka da izbegavate!
Uradio sam neke nalaze i trebali su biti gotovi za dva dana, mjesec dana je proslo i nema ni traga ni glasa od rezultata.
A sad mi se ni ne javljaju na telefon.
Ali mogli su da naplate odmah!!!!!!!
Topla preporuka da ne idete ovde!', 'Моја препорука је да избегавате!
Радио сам неке налазе и требали су бити готови за два дана, прошао је месец дана и нема ни трага ни гласа од резултата.
А сад ми се ни не јављају на телефон.
Али могли су да наплате одмах!!!!!!!
Топла препорука да не идете овде!', 'My recommendation is to avoid this place!
I had some tests done and they were supposed to be ready in two days, a month has passed and there\'s no trace of the results.
And now they don\'t even answer the phone.
But they were able to charge immediately!!!!!!!
Strong recommendation not to go here!', 'Мой совет — избегайте этого места!
Сдал анализы, должны были быть готовы за два дня, прошёл месяц — никаких результатов.
А теперь ещё и на телефон не берут.
Но деньги взяли сразу!!!!!!!
Настоятельно рекомендую сюда не ходить!', 'Meine Empfehlung ist, diesen Ort zu meiden!
Ich habe einige Untersuchungen machen lassen, die in zwei Tagen fertig sein sollten, ein Monat ist vergangen und von den Ergebnissen keine Spur.
Und jetzt gehen sie nicht mal mehr ans Telefon.
Aber bezahlen konnten sie sofort!!!!!!!
Dringende Empfehlung, nicht hierher zu gehen!', 'Tavsiyem bu yerden kaçının!
Bazı testler yaptırdım, iki günde hazır olması gerekiyordu, bir ay geçti ve sonuçlardan hiç haber yok.
Şimdi ise telefona bile çıkmıyorlar.
Ama ödemeyi hemen alabildiler!!!!!!!
Buraya gitmemenizi şiddetle tavsiye ederim!',
    0, '2022-03-24 00:00:00'),

(@user_snezana_mijanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUM2aFo2c2hnRRAB',
    5, 'hr', 'Profesionalno I nadasve ljubazno osoblje',
    'Profesionalno I nadasve ljubazno osoblje', 'Професионално и надасве љубазно особље', 'Professional and above all very friendly staff', 'Профессиональный и прежде всего очень вежливый персонал', 'Professionelles und vor allem sehr freundliches Personal', 'Profesyonel ve her şeyden önce çok nazik personel',
    0, '2022-03-24 00:00:00'),

(@user_helg_berg_helgbergstudiotravel, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNHdGZXVUV3EAE',
    5, 'ru', 'Сделали быстро ПЦР. Единственная лаборатория в Будве, которая работает в выходные дни.',
    'Brzo su uradili PCR. Jedina laboratorija u Budvi koja radi vikendom.', 'Брзо су урадили ПЦР. Једина лабораторија у Будви која ради викендом.', 'They did the PCR quickly. The only laboratory in Budva that works on weekends.', 'Сделали быстро ПЦР. Единственная лаборатория в Будве, которая работает в выходные дни.', 'Den PCR haben sie schnell gemacht. Das einzige Labor in Budva, das an Wochenenden arbeitet.', 'PCR\'ı hızlı yaptılar. Budva\'da hafta sonları çalışan tek laboratuvar.',
    0, '2022-03-24 00:00:00'),

(@user_helgbergstudio_o, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNHZ2FMb1Z3EAE',
    5, 'ru', 'Делал здесь ПЦР. Единственное место в Будве которое работает в выходные',
    'Radio sam ovde PCR. Jedino mesto u Budvi koje radi vikendom', 'Радио сам овде ПЦР. Једино место у Будви које ради викендом', 'I did a PCR here. The only place in Budva that works on weekends', 'Делал здесь ПЦР. Единственное место в Будве которое работает в выходные', 'Ich habe hier einen PCR gemacht. Der einzige Ort in Budva, der an Wochenenden arbeitet', 'Burada PCR yaptırdım. Budva\'da hafta sonları açık olan tek yer',
    0, '2022-03-24 00:00:00'),

(@user_nikola_perovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNHanZEWmJBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_yevgeniya_mesh, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNHN091WkVREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_darina_serova, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNHaUtYRDV3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_aleksei_ivanov, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2djVtbmlBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_helen_kiva, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ2MF9XWERBEAE',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_5h_habits_health_hobbieshappiness_help, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2azRma193RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_vladimir_tadi, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ2MllmMVFnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_user_102823723804311338015, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2N3FUaDFnRRAB',
    1, 'en', 'poor service unkind people. it\'s takes hours. don\'t go there if you have another choice',
    'loša usluga, neljubazni ljudi. traje satima. ne idite tamo ako imate drugi izbor', 'лоша услуга, нељубазни људи. траје сатима. не идите тамо ако имате други избор', 'poor service unkind people. it\'s takes hours. don\'t go there if you have another choice', 'плохой сервис, недружелюбные люди. занимает часы. не ходите туда, если есть альтернатива', 'schlechter Service, unfreundliche Menschen. Es dauert Stunden. Gehen Sie nicht dorthin, wenn Sie eine andere Wahl haben', 'kötü hizmet, kaba insanlar. saatler alıyor. başka seçeneğiniz varsa oraya gitmeyin',
    0, '2022-03-24 00:00:00'),

(@user_user_110987590813180932193, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ2NnB2UWVREAE',
    4, 'he', 'עובדים לאט.... תשובות מהירות',
    'Rade sporo.... brzi rezultati', 'Раде споро.... брзи резултати', 'They work slowly.... quick results', 'Работают медленно.... быстрые результаты', 'Sie arbeiten langsam.... schnelle Ergebnisse', 'Yavaş çalışıyorlar.... hızlı sonuçlar',
    0, '2022-03-24 00:00:00'),

(@user_lhan_aydin, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChRDSUhNMG9nS0VJQ0FnSUQ2eXI0MBAB',
    4, 'tr', 'Bu ülkeye göre fazla çalışkanlar',
    'Previše su marljivi za ovu zemlju', 'Превише су марљиви за ову земљу', 'They are too hardworking for this country', 'Слишком трудолюбивые для этой страны', 'Sie sind zu fleißig für dieses Land', 'Bu ülkeye göre fazla çalışkanlar',
    0, '2022-03-24 00:00:00'),

(@user_oles_oles, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ2eElMQk93EAE',
    3, 'uk', 'Їхньому персоналу потрібно пройти стажування по спілкуванню з клієнтом в Українській мережі Sinevo)))',
    'Njihovo osoblje treba da prođe obuku o komunikaciji s klijentima u ukrajinskoj mreži Sinevo)))', 'Њихово особље треба да прође обуку о комуникацији са клијентима у украјинској мрежи Sinevo)))', 'Their staff needs to undergo training on customer communication at the Ukrainian Sinevo network)))', 'Их персоналу нужно пройти стажировку по общению с клиентами в украинской сети Sinevo)))', 'Ihr Personal muss eine Schulung zur Kundenkommunikation beim ukrainischen Netzwerk Sinevo absolvieren)))', 'Personellerinin Ukrayna Sinevo ağında müşteri iletişimi konusunda staj yapması gerekiyor)))',
    0, '2022-03-24 00:00:00'),

(@user_zarina, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUM2NThXRUxBEAE',
    3, 'en', 'Very small laboratory/ clinic.  Line is formed outside.  No clear direction honestly. Came here to do my PCR test. The first clinician took care of all my information and was professional.  The staff member who did my swabs here was very rude and I didn\'t appreciate her or how she did my samples (she wore braces).',
    'Vrlo mali laboratorij/klinika. Red se formira napolju. Iskreno, nema jasnih uputstava. Došao sam ovde da uradim PCR test. Prva kliničarka se pobrinula za sve moje podatke i bila je profesionalna. Osoblje koje mi je uzelo briseve bilo je veoma nekulturno i nisam bio zadovoljan ni njom ni načinom na koji je uzela uzorke (nosila je aparatić).', 'Врло мали лабораторијум/клиника. Ред се формира напољу. Искрено, нема јасних упутстава. Дошао сам овде да урадим ПЦР тест. Прва клиничарка се побринула за све моје податке и била је професионална. Особље које ми је узело брисеве било је веома некултурно и нисам био задовољан ни њом ни начином на који је узела узорке (носила је апаратић).', 'Very small laboratory/ clinic.  Line is formed outside.  No clear direction honestly. Came here to do my PCR test. The first clinician took care of all my information and was professional.  The staff member who did my swabs here was very rude and I didn\'t appreciate her or how she did my samples (she wore braces).', 'Очень маленькая лаборатория/клиника. Очередь формируется на улице. Честно, никакой чёткой навигации. Пришёл сюда сделать ПЦР-тест. Первый специалист занялся всеми моими данными и был профессионален. Сотрудница, которая брала у меня мазки, была очень грубой — я остался недоволен и ею, и тем, как она собирала образцы (у неё были брекеты).', 'Sehr kleines Labor/Klinik. Die Schlange bildet sich draußen. Ehrlich gesagt keine klare Orientierung. Ich kam hierher, um meinen PCR-Test zu machen. Der erste Kliniker hat sich um alle meine Daten gekümmert und war professionell. Die Mitarbeiterin, die meine Abstriche gemacht hat, war sehr unhöflich und ich war weder mit ihr noch mit der Art, wie sie meine Proben entnommen hat, zufrieden (sie trug eine Zahnspange).', 'Çok küçük bir laboratuvar/klinik. Kuyruğu dışarıda oluşuyor. Dürüst olmak gerekirse hiçbir yönlendirme yok. PCR testimi yaptırmak için buraya geldim. İlk klinisyen tüm bilgilerimi aldı ve profesyoneldi. Sürüntü örneklerimi alan personel çok kabaydı ve ne kendisinden ne de örnekleri alma şeklinden memnun kaldım (diş teli takıyordu).',
    0, '2022-03-24 00:00:00'),

(@user_josef_ern, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUM2bTlDdmpBRRAB',
    1, 'en', 'Very slowly, I was waiting 2 hours to get antigen test.',
    'Veoma sporo, čekao sam 2 sata da uradim antigenski test.', 'Веома споро, чекао сам 2 сата да урадим антигенски тест.', 'Very slowly, I was waiting 2 hours to get antigen test.', 'Очень медленно, я ждал 2 часа, чтобы сделать антигенный тест.', 'Sehr langsam, ich habe 2 Stunden auf meinen Antigen-Test gewartet.', 'Çok yavaş, antijen testimi yaptırmak için 2 saat bekledim.',
    0, '2022-03-24 00:00:00'),

(@user_radmila_rada, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUM2N3VHZEJ3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_mina_eva_demiroglu, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUM2c3FqcnRRRRAB',
    5, 'ru', 'Быстро сделали PCR test. Сдали в 10 утра, в 8 вечера того же дня уже пришли готовые результаты по почте.',
    'Brzo su uradili PCR test. Predali smo u 10 ujutro, a u 8 uveče istog dana već su stigli gotovi rezultati na e-mail.', 'Брзо су урадили ПЦР тест. Предали смо у 10 ујутро, а у 8 увече истог дана већ су стигли готови резултати на е-маил.', 'They did the PCR test quickly. We submitted at 10 in the morning, and by 8 in the evening of the same day the ready results had already arrived by email.', 'Быстро сделали PCR test. Сдали в 10 утра, в 8 вечера того же дня уже пришли готовые результаты по почте.', 'Den PCR-Test haben sie schnell gemacht. Wir haben um 10 Uhr morgens abgegeben, und um 20 Uhr desselben Tages kamen bereits die fertigen Ergebnisse per E-Mail.', 'PCR testini hızlı yaptılar. Sabah 10\'da verdik, aynı günün akşam 8\'inde hazır sonuçlar e-postayla geldi.',
    0, '2022-03-24 00:00:00'),

(@user_irena_kvesi, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUM2Z3JMUnRRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_zoran_dragovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUM2c016QS1nRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_irina_kononova, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUM2a01uSTBRRRAB',
    3, 'ru', 'Ну очень долгое обслуживание!Персонал отвлекается на других клиентов во время процедур.',
    'Ну veoma sporo uslužavanje! Osoblje se odvlači na druge klijente tokom procedura.', 'Ну веома споро услуживање! Особље се одвлачи на друге клијенте током процедура.', 'Oh so very slow service! The staff gets distracted by other clients during procedures.', 'Ну очень долгое обслуживание!Персонал отвлекается на других клиентов во время процедур.', 'Wirklich sehr langsamer Service! Das Personal lässt sich während der Behandlungen von anderen Kunden ablenken.', 'Gerçekten çok yavaş hizmet! Personel işlemler sırasında diğer müşterilerle ilgilenip dağılıyor.',
    0, '2022-03-24 00:00:00'),

(@user_romain_boitard, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUM2b0xla2Z3EAE',
    1, 'en', 'Terrible service, really rude staff',
    'Užasna usluga, stvarno grubi osoblje', 'Ужасна услуга, стварно груби особље', 'Terrible service, really rude staff', 'Ужасный сервис, действительно грубый персонал', 'Schrecklicher Service, wirklich unhöfliches Personal', 'Berbat hizmet, gerçekten kaba personel',
    0, '2022-03-24 00:00:00'),

(@user_kuzey_stc, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURhdF9YOTVRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_j_b, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURha1lDSzRnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_mariia_sizikova, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURhbnBhMHh3RRAB',
    1, 'en', 'The WORST clinic ever. Never recommend this place. You can get there with emergency question and wait 15 min until stuff finish smoking. Problem with communication with stuff. Receptionists are rude and don’t even try to help.
I live quite far from clinic and my family got sick with covid. I tried to get them by phone (I called 50 times since 11am-7pm NO ONE ANSWER PHONE.
I arrived in clinic specially with one question: do you do tests at home? Can you come over and do test (for sure we are ready to pay more )
The receptionist gave me the same number and tell try to call again . And email - nobody never answered me
After 2 days no one did not answer . and bla bla bla in the end 5 days passed NOONE came to test us

Dear people, please learn how to work and do your job well
You ARE PRIVATE CLINIC be nice with people',
    'NAJGORA klinika ikad. Nikad ne preporučujem ovo mjesto. Možete doći s hitnim pitanjem i čekati 15 minuta dok osoblje završi s pušenjem. Problem s komunikacijom s osobljem. Recepcioneri su grubi i ne pokušavaju čak ni pomoći.
Živim prilično daleko od klinike i moja porodica je oboljela od covida. Pokušao sam ih dobiti telefonom (zvao sam 50 puta od 11h do 19h NIKO NE ODGOVARA NA TELEFON.
Došao sam u kliniku posebno s jednim pitanjem: da li radite testove kod kuće? Možete li doći i uraditi test (sigurno smo spremni platiti više)
Receptioner mi je dao isti broj i rekao da pokušam ponovo nazvati. I email - niko mi nikada nije odgovorio
Nakon 2 dana niko nije odgovorio. i bla bla bla na kraju je prošlo 5 dana NIKO nije došao da nas testira

Dragi ljudi, molim vas naučite kako da radite i dobro obavljate svoj posao
VI STE PRIVATNA KLINIKA budite ljubazni prema ljudima', 'НАЈГОРА клиника икад. Никад не препоручујем ово мјесто. Можете доћи с хитним питањем и чекати 15 минута dok особље заврши с пушењем. Проблем с комуникацијом с особљем. Рецепционери су груби и не покушавају чак ни помоћи.
Живим прилично далеко од клинике и моја породица је оболела од ковида. Покушао сам их добити телефоном (звао сам 50 пута од 11х до 19х НИКО НЕ ОДГОВАРА НА ТЕЛЕФОН.
Дошао сам у клинику посебно с једним питањем: да ли радите тестове код куће? Можете ли доћи и урадити тест (сигурно смо спремни платити више)
Рецепционер ми је дао исти број и рекао да покушам поново назвати. И имеjл — нико ми никада није одговорио
Након 2 дана нико није одговорио. и бла бла бла на крају је прошло 5 дана НИКО није дошао да нас тестира

Драги људи, молим вас научите како да радите и добро обављате свој посао
ВИ СТЕ ПРИВАТНА КЛИНИКА будите љубазни према људима', 'The WORST clinic ever. Never recommend this place. You can get there with emergency question and wait 15 min until stuff finish smoking. Problem with communication with stuff. Receptionists are rude and don’t even try to help.
I live quite far from clinic and my family got sick with covid. I tried to get them by phone (I called 50 times since 11am-7pm NO ONE ANSWER PHONE.
I arrived in clinic specially with one question: do you do tests at home? Can you come over and do test (for sure we are ready to pay more )
The receptionist gave me the same number and tell try to call again . And email - nobody never answered me
After 2 days no one did not answer . and bla bla bla in the end 5 days passed NOONE came to test us

Dear people, please learn how to work and do your job well
You ARE PRIVATE CLINIC be nice with people', 'ХУДШАЯ клиника из всех. Никогда не рекомендую это место. Вы можете прийти с экстренным вопросом и ждать 15 минут, пока персонал докурит. Проблемы с общением с персоналом. Администраторы грубят и даже не пытаются помочь.
Я живу довольно далеко от клиники, и моя семья заболела ковидом. Я пытался дозвониться (звонил 50 раз с 11 утра до 7 вечера — НИКТО НЕ БЕРЁТ ТРУБКУ.
Я специально приехал в клинику с одним вопросом: делаете ли вы тесты на дому? Можете ли приехать и сделать тест (мы готовы заплатить больше)
Администратор дала мне тот же номер и сказала попробовать позвонить ещё раз. И по email — мне никто так и не ответил
Через 2 дня никто не ответил. и бла бла бла, в итоге прошло 5 дней — НИКТО не приехал нас тестировать

Дорогие люди, пожалуйста, научитесь работать и хорошо выполнять свою работу
ВЫ ЧАСТНАЯ КЛИНИКА — будьте вежливы с людьми', 'Die SCHLECHTESTE Klinik überhaupt. Ich empfehle diesen Ort niemals. Man kann mit einer dringenden Frage hinkommen und 15 Minuten warten, bis das Personal mit dem Rauchen fertig ist. Problem mit der Kommunikation mit dem Personal. Die Rezeptionisten sind unhöflich und versuchen nicht einmal zu helfen.
Ich lebe ziemlich weit von der Klinik entfernt und meine Familie erkrankte an Covid. Ich versuchte sie telefonisch zu erreichen (ich rief 50 Mal von 11 bis 19 Uhr an — NIEMAND ANTWORTET AM TELEFON.
Ich kam extra mit einer Frage in die Klinik: Machen Sie Tests zu Hause? Können Sie vorbeikommen und den Test machen (wir sind bereit, mehr zu zahlen)
Die Rezeptionistin gab mir dieselbe Nummer und sagte, ich solle es nochmal versuchen. Und per E-Mail — niemand hat mir jemals geantwortet
Nach 2 Tagen hat niemand geantwortet. und bla bla bla am Ende vergingen 5 Tage — NIEMAND kam, um uns zu testen

Liebe Leute, bitte lernt zu arbeiten und eure Arbeit gut zu machen
Sie sind eine PRIVATKLINIK — seien Sie nett zu den Menschen', 'Şimdiye kadar gördüğüm EN KÖTÜ klinik. Bu yeri asla tavsiye etmem. Acil bir soruyla gidebilir ve personel sigara içmeyi bitirene kadar 15 dakika bekleyebilirsiniz. Personelle iletişim sorunu var. Resepsiyonistler kaba ve yardım etmeye bile çalışmıyor.
Klinikten oldukça uzakta yaşıyorum ve ailem covid\'e yakalandı. Telefonla ulaşmaya çalıştım (sabah 11\'den akşam 7\'ye kadar 50 kez aradım — KİMSE TELEFONA ÇIKMIYOR.
Kliniğe özellikle bir soruyla gittim: evde test yapıyor musunuz? Gelip test yapabilir misiniz? (daha fazla ödemeye hazırız)
Resepsiyonist bana aynı numarayı verdi ve tekrar aramayı denememi söyledi. E-posta ise — kimse bana hiç cevap vermedi
2 gün sonra kimse cevap vermedi. ve falan filan sonunda 5 gün geçti — bizi test etmeye KİMSE gelmedi

Sevgili insanlar, lütfen nasıl çalışacağınızı ve işinizi iyi yapacağınızı öğrenin
SİZ ÖZEL BİR KLİNİKSİNİZ — insanlara iyi davranın',
    0, '2022-03-24 00:00:00'),

(@user_dr_predrag_vasic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURhenBLOVlREAE',
    3, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_ekaterina_evdokimova, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURhcE9mNnhRRRAB',
    2, 'ru', 'Мне необходимо было сделать антигеновый тест. Очередь была человек 20 (кроме меня все пришли делать ПЦР). Через 50 минут ожидания (передо мной оставалось 3 чел) вышла сотрудница, которая в очень грубой форме всем сообщила, что они смогут принять только тех, кто пришел делает пцр тесты. Ответить на вопрос, почему они об этом сообщают только через 50 мин ожидания на жаре 36° не захотела, со всеми была довольно груба. И только после того, как я сообщила, что беременна (это сложно не заметить), жду 50 мин на жаре и сделаю ПЦР тест (а не антигеновый), чтобы не идти в другую лабораторию и не ждать там, меня приняли. В итоге всё-таки сделали антигеновый тест.',
    'Morala sam da uradim antigenski test. Red je bio oko 20 osoba (svi osim mene su došli da rade PCR). Nakon 50 minuta čekanja (ispred mene su ostale 3 osobe) izašla je radnica koja je svima vrlo grubo saopštila da mogu primiti samo one koji su došli da rade PCR testove. Nije htjela odgovoriti na pitanje zašto to saopštavaju tek nakon 50 minuta čekanja na vrućini od 36°, sa svima je bila prilično gruba. I tek nakon što sam rekla da sam trudna (to je teško ne primijetiti), čekam 50 minuta na vrućini i uradiću PCR test (a ne antigenski), da ne bih išla u drugu laboratoriju i čekala tamo, primili su me. Na kraju su ipak uradili antigenski test.', 'Морала сам да урадим антигенски тест. Ред је био око 20 особа (сви осим мене су дошли да раде ПЦР). Након 50 минута чекања (испред мене су остале 3 особе) изашла је радница која је свима врло грубо саопштила да могу примити само оне који су дошли да раде ПЦР тестове. Није хтела одговорити на питање зашто то саопштавају тек након 50 минута чекања на врућини од 36°, са свима је била прилично груба. И тек након што сам рекла да сам трудна (то је тешко не приметити), чекам 50 минута на врућини и урадићу ПЦР тест (а не антигенски), да не бих ишла у другу лабораторију и чекала тамо, примили су ме. На крају су ипак урадили антигенски тест.', 'I needed to get an antigen test. The queue was about 20 people (everyone except me came to do PCR). After 50 minutes of waiting (3 people were left ahead of me) a staff member came out and very rudely informed everyone that they could only accept those who came for PCR tests. She refused to answer the question of why they were only announcing this after 50 minutes of waiting in 36° heat, and was quite rude to everyone. Only after I said that I was pregnant (which is hard to miss), had been waiting 50 minutes in the heat and would do a PCR test (not antigen) so as not to go to another lab and wait there — did they accept me. In the end they did the antigen test after all.', 'Мне необходимо было сделать антигеновый тест. Очередь была человек 20 (кроме меня все пришли делать ПЦР). Через 50 минут ожидания (передо мной оставалось 3 чел) вышла сотрудница, которая в очень грубой форме всем сообщила, что они смогут принять только тех, кто пришел делает пцр тесты. Ответить на вопрос, почему они об этом сообщают только через 50 мин ожидания на жаре 36° не захотела, со всеми была довольно груба. И только после того, как я сообщила, что беременна (это сложно не заметить), жду 50 мин на жаре и сделаю ПЦР тест (а не антигеновый), чтобы не идти в другую лабораторию и не ждать там, меня приняли. В итоге всё-таки сделали антигеновый тест.', 'Ich musste einen Antigentest machen. Die Warteschlange war etwa 20 Personen lang (alle außer mir kamen für einen PCR-Test). Nach 50 Minuten Warten (3 Personen waren noch vor mir) kam eine Mitarbeiterin heraus und teilte allen sehr unhöflich mit, dass sie nur diejenigen annehmen können, die für PCR-Tests gekommen sind. Sie wollte die Frage nicht beantworten, warum sie das erst nach 50 Minuten Warten in der 36°-Hitze mitteilen, und war zu allen ziemlich unhöflich. Erst nachdem ich sagte, dass ich schwanger bin (das ist schwer zu übersehen), 50 Minuten in der Hitze warte und einen PCR-Test machen würde (keinen Antigentest), um nicht in ein anderes Labor zu gehen und dort zu warten — ließen sie mich rein. Am Ende haben sie doch noch den Antigentest gemacht.', 'Antijen testi yaptırmam gerekiyordu. Kuyrukta yaklaşık 20 kişi vardı (benden başka herkes PCR testi için gelmişti). 50 dakika bekledikten sonra (önümde 3 kişi kalmıştı) bir çalışan çıktı ve herkese çok kaba bir şekilde yalnızca PCR testi için gelenleri kabul edebileceklerini söyledi. Neden bunu ancak 36° sıcakta 50 dakika bekledikten sonra haber verdiklerini sormaya yanıt vermedi ve herkese oldukça kaba davrandı. Ancak hamilem (bunu fark etmemek zor), 50 dakikadır sıcakta bekliyorum ve başka bir laboratuvara gidip orada beklemek zorunda kalmamak için antijen değil PCR testi yaptıracağım dedikten sonra beni kabul ettiler. Sonunda antijen testini yaptılar.',
    0, '2022-03-24 00:00:00'),

(@user_advokat_andrusenko_dariyush, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURheUlxMmRnEAE',
    4, 'ru', 'Делал тест антиген, 20 минут и результат на почте. Но ждать на улице пришлось часа 1,5. Очень медленно',
    'Radio sam antigenski test, 20 minuta i rezultat na mejlu. Ali na ulici sam morao čekati oko 1,5 sat. Veoma sporo', 'Радио сам антигенски тест, 20 минута и резултат на мejлу. Али на улици сам морао чекати око 1,5 сат. Веома споро', 'I did an antigen test, 20 minutes and the result was in my email. But I had to wait outside for about 1.5 hours. Very slow', 'Делал тест антиген, 20 минут и результат на почте. Но ждать на улице пришлось часа 1,5. Очень медленно', 'Ich habe einen Antigentest gemacht, 20 Minuten und das Ergebnis war in meiner E-Mail. Aber ich musste draußen etwa 1,5 Stunden warten. Sehr langsam', 'Antijen testi yaptırdım, 20 dakika ve sonuç e-postama geldi. Ama dışarıda yaklaşık 1,5 saat beklemek zorunda kaldım. Çok yavaş',
    0, '2022-03-24 00:00:00'),

(@user_jelena_lu, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNheC15OWlBRRAB',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_redas_klionovskis, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNhdzUyNVF3EAE',
    3, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_murat_kurtaran, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNhdGM3UkpBEAE',
    3, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_user_105431582554055225073, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNhc2Z1ODVBRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_user_116494655100037688803, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNhOXZ2UEFnEAE',
    5, 'en', 'Very efficient, excellent service to the tourist !, printed answers on the same day.
Especially Maya at the reception, very nice. Thanks for the help.
Erez Travel Guide from Israel',
    'Vrlo efikasno, odlična usluga za turiste!, štampani odgovori istog dana.
Posebno Maya na recepciji, veoma ljubazna. Hvala na pomoći.
Erez Travel Guide from Israel', 'Врло ефикасно, одлична услуга за туристе!, штампани одговори истог дана.
Посебно Maya на рецепцији, веома љубазна. Хвала на помоћи.
Erez Travel Guide from Israel', 'Very efficient, excellent service to the tourist !, printed answers on the same day.
Especially Maya at the reception, very nice. Thanks for the help.
Erez Travel Guide from Israel', 'Очень эффективно, отличный сервис для туристов!, распечатанные результаты в тот же день.
Особенно Maya на ресепшене, очень приятная. Спасибо за помощь.
Erez Travel Guide from Israel', 'Sehr effizient, ausgezeichneter Service für Touristen!, gedruckte Ergebnisse noch am selben Tag.
Besonders Maya an der Rezeption, sehr nett. Danke für die Hilfe.
Erez Travel Guide from Israel', 'Çok verimli, turistlere mükemmel hizmet!, aynı gün basılı sonuçlar.
Özellikle resepsiyondaki Maya, çok nazik. Yardım için teşekkürler.
Erez Travel Guide from Israel',
    0, '2022-03-24 00:00:00'),

(@user_laura_lobmaier, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNhdHEtSjR3RRAB',
    5, 'en', 'Good prices and quick results',
    'Dobre cijene i brzi rezultati', 'Добре цијене и брзи резултати', 'Good prices and quick results', 'Хорошие цены и быстрые результаты', 'Gute Preise und schnelle Ergebnisse', 'İyi fiyatlar ve hızlı sonuçlar',
    0, '2022-03-24 00:00:00'),

(@user_adam_cullen, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNhaW9fb1N3EAE',
    4, 'en', 'Not the best at answering the phone, have to call a few times but when you get through the staff are informative, helpful and very pleasant. Testing was smooth and efficient. Got my results in an appropriate amount of time. Pleased with the service I received could possibly just do with more reception staff for the phones.',
    'Nisu najbolji kad je odgovaranje na telefon u pitanju, morali ste nazvati nekoliko puta, ali kada se dočekate osoblje je informativno, od pomoći i veoma ljubazno. Testiranje je bilo glatko i efikasno. Dobio sam rezultate za odgovarajući vremenski period. Zadovoljan uslugom koju sam primio, ali bi moglo koristiti više recepcionara za telefone.', 'Нису најбољи кад је одговарање на телефон у питању, морали сте назвати неколико пута, али када се дочекате особље је информативно, од помоћи и веома љубазно. Тестирање је било глатко и ефикасно. Добио сам резултате за одговарајући временски период. Задовољан услугом коју сам примио, али би могло користити више рецепционара за телефоне.', 'Not the best at answering the phone, have to call a few times but when you get through the staff are informative, helpful and very pleasant. Testing was smooth and efficient. Got my results in an appropriate amount of time. Pleased with the service I received could possibly just do with more reception staff for the phones.', 'С ответами на телефон не всё гладко — приходится звонить несколько раз, но когда дозваниваешься, персонал информативен, готов помочь и очень приятен. Процедура тестирования прошла гладко и эффективно. Получил результаты в разумные сроки. Доволен обслуживанием, однако не помешало бы больше сотрудников на ресепшене для работы с телефонными звонками.', 'Nicht die Besten beim Abheben des Telefons, man muss ein paar Mal anrufen, aber wenn man durchkommt, ist das Personal informativ, hilfsbereit und sehr angenehm. Das Testen verlief reibungslos und effizient. Ergebnisse in angemessener Zeit erhalten. Mit dem erhaltenen Service zufrieden, könnte jedoch einfach mehr Empfangspersonal für die Telefone gebrauchen.', 'Telefona cevap vermekte pek iyi değiller, birkaç kez aramanız gerekiyor ama bağlandığınızda personel bilgi verici, yardımsever ve çok hoş. Test süreci sorunsuz ve verimli geçti. Sonuçlarımı uygun bir sürede aldım. Aldığım hizmetten memnunum, yalnızca telefonlar için daha fazla resepsiyon personeli işe yarardı.',
    0, '2022-03-24 00:00:00'),

(@user_oleksandr, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNhOHIyeDdRRRAB',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_ahmet_baba, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNhekxxUFBREAE',
    3, 'en', 'Less helping people could be more polite',
    'Osoblje koje manje pomaže moglo bi biti ljubaznije', 'Особље које мање помаже могло би бити љубазније', 'Less helping people could be more polite', 'Персонал, который меньше помогает, мог бы хотя бы быть вежливее', 'Weniger hilfsbereite Mitarbeiter könnten wenigstens höflicher sein', 'Daha az yardımcı olan kişiler en azından daha kibar olabilirdi',
    0, '2022-03-24 00:00:00'),

(@user_ivona_r, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNhakt1UjlBRRAB',
    1, 'bs', 'Nakon čekanja od 2 i pol sata na suncu za testiranje, a radno vrijeme je do 15:00. U 14:40 izlazi gospodja koja radi u laboratoriju i kaže da zatvaraju i da idemo drugdje na testiranje. Vrlo neprofesionalni, spori… izbjegavajte!',
    'Nakon čekanja od 2 i pol sata na suncu za testiranje, a radno vrijeme je do 15:00. U 14:40 izlazi gospodja koja radi u laboratoriju i kaže da zatvaraju i da idemo drugdje na testiranje. Vrlo neprofesionalni, spori… izbjegavajte!', 'Након чекања од 2 и по сата на сунцу за тестирање, а радно вријеме је до 15:00. У 14:40 излази госпођа која ради у лабораторији и каже да затварају и да идемо другдје на тестирање. Врло непрофесионални, спори… избјегавајте!', 'After waiting 2 and a half hours in the sun for testing, with working hours until 15:00. At 14:40 a lady who works in the laboratory comes out and says they are closing and that we should go elsewhere for testing. Very unprofessional, slow… avoid!', 'После 2,5 часов ожидания на солнце для тестирования, при рабочем времени до 15:00. В 14:40 выходит дама, которая работает в лаборатории, и говорит, что они закрываются и чтобы мы шли на тестирование в другое место. Очень непрофессионально, медленно… избегайте!', 'Nach 2,5 Stunden Warten in der Sonne für einen Test, bei Öffnungszeiten bis 15:00 Uhr. Um 14:40 Uhr kommt eine Dame, die im Labor arbeitet, und sagt, dass sie schließen und wir woanders zum Testen gehen sollen. Sehr unprofessionell, langsam… meiden!', 'Çalışma saatleri 15:00\'e kadar olmasına rağmen test için güneşte 2,5 saat bekledikten sonra. Saat 14:40\'ta laboratuvarda çalışan bir bayan çıkıyor ve kapandıklarını ve test için başka yere gitmemizi söylüyor. Çok profesyonelsiz, yavaşlar… kaçının!',
    0, '2022-03-24 00:00:00'),

(@user_lesia_melnychenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNhOU9QZFhBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_sessiz_rota, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNhMkttcXFnRRAB',
    4, 'tr', 'Daha kibar olabilirler',
    NULL, NULL, NULL, NULL, NULL, 'Daha kibar olabilirler',
    0, '2022-03-24 00:00:00'),

(@user_ufimtsev_egor, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNhNk5tdTlnRRAB',
    5, 'ru', 'Быстрый пцр тест, без замечаний',
    'Brz PCR test, bez primjedbi', 'Брз ПЦР тест, без примједби', 'Quick PCR test, no complaints', 'Быстрый пцр тест, без замечаний', 'Schneller PCR-Test, keine Beanstandungen', 'Hızlı PCR testi, şikayetsiz',
    0, '2022-03-24 00:00:00'),

(@user_svetlana, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNhc1B1MkJBEAE',
    3, 'ru', 'Не внимательный персонал, хотя качество услуг нормальное',
    'Osoblje nije pažljivo, mada je kvalitet usluga normalan', 'Особље није пажљиво, мада је квалитет услуга нормалан', 'Inattentive staff, although the quality of services is normal', 'Не внимательный персонал, хотя качество услуг нормальное', 'Unaufmerksames Personal, obwohl die Servicequalität in Ordnung ist', 'Dikkatsiz personel, ancak hizmet kalitesi normal',
    0, '2022-03-24 00:00:00'),

(@user_alessandro_rivale, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURxXzhHblVREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_andrey_kuznetsov, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURxbHJqdU9REAE',
    5, 'en', 'All was done well',
    'Sve je urađeno dobro', 'Све је урађено добро', 'All was done well', 'Всё было сделано хорошо', 'Alles wurde gut gemacht', 'Her şey iyi yapıldı',
    0, '2022-03-24 00:00:00'),

(@user_olga_bals, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURxaWRhdEJBEAE',
    5, 'ru', 'Вежливые сотрудницы, говорят на английском, результат пцр теста пришёл в тот же день на почту, вечером. Приблизительно 7-8 часов готовился тест. Сдавать лучше заранее.',
    'Ljubazne radnice, govore engleski, rezultat PCR testa stigao je isti dan na mejl, uveče. Otprilike 7-8 sati se čeka na test. Bolje predati uzorak unaprijed.', 'Љубазне раднице, говоре енглески, резултат ПЦР теста стигао је исти дан на мejл, увече. Приближно 7-8 сати се чека на тест. Боље предати узорак унапријед.', 'Polite staff, they speak English, the PCR test result arrived the same day by email, in the evening. The test takes approximately 7-8 hours to prepare. It is better to submit early.', 'Вежливые сотрудницы, говорят на английском, результат пцр теста пришёл в тот же день на почту, вечером. Приблизительно 7-8 часов готовился тест. Сдавать лучше заранее.', 'Freundliches Personal, spricht Englisch, das PCR-Testergebnis kam noch am selben Tag per E-Mail, abends. Der Test dauert ungefähr 7-8 Stunden. Am besten früh abgeben.', 'Nazik personel, İngilizce konuşuyorlar, PCR testi sonucu aynı gün akşam e-posta ile geldi. Test yaklaşık 7-8 saat hazırlanıyor. Erken vermek daha iyi.',
    0, '2022-03-24 00:00:00'),

(@user_user_117087516023669088637, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURxenFMLXJBRRAB',
    4, 'he', 'יעילים מאוד.
מנומסים.
קבלנו תשובות של בדיקת הקומונה במילון תוך מספר שעות - כפי שהבטיחו.',
    'Veoma efikasni.
Ljubazni.
Dobili smo rezultate koronavirus testa za nekoliko sati - kao što su obećali.', 'Веома ефикасни.
Љубазни.
Добили смо резултате коронавирус теста за неколико сати - као што су обећали.', 'Very efficient.
Polite.
We received the corona test results within a few hours - as promised.', 'Очень эффективны.
Вежливы.
Мы получили результаты теста на коронавирус в течение нескольких часов — как и обещали.', 'Sehr effizient.
Höflich.
Wir haben die Corona-Testergebnisse innerhalb weniger Stunden erhalten - wie versprochen.', 'Çok verimli.
Kibar.
Korona testi sonuçlarını birkaç saat içinde aldık - söz verdikleri gibi.',
    0, '2022-03-24 00:00:00'),

(@user_mikhail_motov, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURxcHR2bElREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_one_friday, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURxaXJDWEhBEAE',
    5, 'ru', 'ПЦР тест стоит 49€. Сдаете с 9:00 до 12:00, результат получаете после 16:00 в этот же день. Плюс, дублируют на почту. Очередей особо нет. Персонал говорит на английском.',
    'PCR test košta 49€. Predajete od 9:00 do 12:00, rezultat dobijate poslije 16:00 istog dana. Plus, šalju i na mejl. Redova uglavnom nema. Osoblje govori engleski.', 'ПЦР тест кошта 49€. Предајете од 9:00 до 12:00, резултат добијате послије 16:00 истог дана. Плус, шаљу и на мejл. Редова углавном нема. Особље говори енглески.', 'PCR test costs 49€. You submit from 9:00 to 12:00, results are received after 16:00 the same day. Plus, they send a duplicate by email. There are basically no queues. Staff speaks English.', 'ПЦР тест стоит 49€. Сдаете с 9:00 до 12:00, результат получаете после 16:00 в этот же день. Плюс, дублируют на почту. Очередей особо нет. Персонал говорит на английском.', 'PCR-Test kostet 49€. Abgabe von 9:00 bis 12:00 Uhr, Ergebnisse noch am selben Tag nach 16:00 Uhr. Zusätzlich werden sie per E-Mail zugeschickt. Kaum Warteschlangen. Personal spricht Englisch.', 'PCR testi 49€. Sabah 9:00\'dan 12:00\'ye kadar veriyorsunuz, sonucu aynı gün 16:00\'dan sonra alıyorsunuz. Ayrıca e-posta ile de gönderiyorlar. Kuyruk yok denecek kadar az. Personel İngilizce konuşuyor.',
    0, '2022-03-24 00:00:00'),

(@user_borislav_kovacevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURxOHZEQl9RRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_oksana_neshchadina, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURxN00yc1hBEAE',
    5, 'uk', 'Здавали з чоловіком швидкі тести для в\'їзду В Хорватію. Швидко, якісно. Тести працівник брала просто і  ніжно. Рекомендую.',
    'Muž i ja smo radili brze testove za ulazak u Hrvatsku. Brzo, kvalitetno. Radnica je uzimala uzorke jednostavno i nježno. Preporučujem.', 'Муж и ја смо радили брзе тестове за улазак у Хрватску. Брзо, квалитетно. Радница је узимала узорке једноставно и нежно. Препоручујем.', 'My husband and I did rapid tests for entry into Croatia. Fast, quality service. The staff member took the samples simply and gently. I recommend.', 'Сдавали с мужем быстрые тесты для въезда в Хорватию. Быстро, качественно. Сотрудница брала тесты просто и нежно. Рекомендую.', 'Mein Mann und ich haben Schnelltests für die Einreise nach Kroatien gemacht. Schnell, qualitativ. Die Mitarbeiterin hat die Tests einfach und sanft abgenommen. Ich empfehle es.', 'Kocamla Hırvatistan\'a giriş için hızlı test yaptırdık. Hızlı, kaliteli. Çalışan testleri basit ve nazikçe aldı. Tavsiye ederim.',
    0, '2022-03-24 00:00:00'),

(@user_tatyana_lebedeva, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURxN015b2FREAE',
    5, 'ru', 'Анализы на Ковид по разумной цене,быстро, профессионально',
    'Analize na Covid po razumnoj cijeni, brzo, profesionalno', 'Анализе на Ковид по разумној цијени, брзо, професионално', 'Covid tests at a reasonable price, fast, professional', 'Анализы на Ковид по разумной цене,быстро, профессионально', 'Covid-Tests zu einem vernünftigen Preis, schnell, professionell', 'Makul fiyata Covid testleri, hızlı, profesyonel',
    0, '2022-03-24 00:00:00'),

(@user_darja, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURxOUxIdm1BRRAB',
    1, 'en', 'The samples are always sent to another city, you can\'t possibly get them in short time. If it is urgent like for my small baby, never ever go here.',
    'Uzorci se uvijek šalju u drugi grad, ne možete ih dobiti u kratkom roku. Ako je hitno, kao što je bio slučaj s mojim malim djetetom, nikada ne dolazite ovdje.', 'Узорци се увijek шаљу у други град, не можете их добити у кратком року. Ако је хитно, као што је био случај с мојим малим дијетом, никада не долазите овдје.', 'The samples are always sent to another city, you can\'t possibly get them in short time. If it is urgent like for my small baby, never ever go here.', 'Образцы всегда отправляются в другой город, вы не сможете получить результаты в короткие сроки. Если это срочно, как в случае с моим маленьким ребёнком, никогда сюда не ходите.', 'Die Proben werden immer in eine andere Stadt geschickt, man kann sie unmöglich schnell bekommen. Wenn es dringend ist, wie bei meinem kleinen Baby, gehen Sie hier niemals hin.', 'Örnekler her zaman başka bir şehre gönderiliyor, kısa sürede alamazsınız. Küçük bebeğimde olduğu gibi acil bir durum söz konusuysa, asla buraya gelmeyin.',
    0, '2022-03-24 00:00:00'),

(@user_m_g, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURxbE03QVZBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_caro_h, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURxNExqM0h3EAE',
    1, 'en', 'The lady told me that she would send my results vía email 30\' after the test.
She never did it. I had to cross all the city AGAIN, beacuse I needed them ASAP.
I have a friend who made a PCR and she never recived the results, so she had to do an antigen test and wait.
There\'s a big problem with The email service! I would rather they don\'t offer this option if they aren\'t going to do it at the end.',
    'Gospođa mi je rekla da će mi poslati rezultate putem mejla 30 minuta nakon testa.
Nikad to nije uradila. Morao sam PONOVO preći cijeli grad, jer su mi bili hitno potrebni.
Imam prijatelja koji je radio PCR i nikad nije dobio rezultate, pa je morao raditi antigenski test i čekati.
Postoji veliki problem s uslugom slanja mejlova! Radije bih da ne nude tu opciju ako to ionako neće uraditi.', 'Госпођа ми је рекла да ће ми послати резултате путем мejла 30 минута након теста.
Никад то није урадила. Морао сам ПОНОВО прећи цијели град, јер су ми били хитно потребни.
Имам пријатеља који је радио ПЦР и никад није добио резултате, па је морао радити антигенски тест и чекати.
Постоји велики проблем с услугом слања мejлова! Радије бих да не нуде ту опцију ако то ионако неће урадити.', 'The lady told me that she would send my results vía email 30\' after the test.
She never did it. I had to cross all the city AGAIN, beacuse I needed them ASAP.
I have a friend who made a PCR and she never recived the results, so she had to do an antigen test and wait.
There\'s a big problem with The email service! I would rather they don\'t offer this option if they aren\'t going to do it at the end.', 'Дама сказала мне, что пришлёт результаты по электронной почте через 30 минут после теста.
Она так и не сделала этого. Мне пришлось СНОВА пересечь весь город, потому что они были нужны срочно.
У меня есть подруга, которая сделала ПЦР и так и не получила результаты, поэтому ей пришлось делать антигенный тест и ждать.
С услугой отправки по электронной почте большая проблема! Лучше бы они вообще не предлагали эту опцию, если в итоге всё равно не выполняют.', 'Die Dame sagte mir, dass sie mir meine Ergebnisse 30 Minuten nach dem Test per E-Mail schicken würde.
Sie hat es nie getan. Ich musste NOCHMAL die ganze Stadt durchqueren, weil ich sie so schnell wie möglich brauchte.
Ich habe eine Freundin, die einen PCR gemacht hat und nie die Ergebnisse erhalten hat, also musste sie einen Antigentest machen und warten.
Es gibt ein großes Problem mit dem E-Mail-Service! Ich würde es vorziehen, wenn sie diese Option gar nicht anbieten würden, wenn sie es am Ende sowieso nicht tun.', 'Bayan bana testi yaptıktan 30 dakika sonra sonuçları e-posta ile göndereceğini söyledi.
Hiç göndermedi. Acilen ihtiyacım olduğu için tüm şehri YENİDEN geçmek zorunda kaldım.
PCR yaptıran bir arkadaşım var ve sonuçları hiç ulaşmadı, bu yüzden antijen testi yaptırıp beklemek zorunda kaldı.
E-posta hizmetiyle büyük bir sorun var! Sonunda yerine getirmeyeceklerse bu seçeneği hiç sunmamaları daha iyi olurdu.',
    0, '2022-03-24 00:00:00'),

(@user_vadim_gavrish, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNxNDZMbk93EAE',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_vadim_creator, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNxN2NYLXhRRRAB',
    5, 'ru', 'Хорошее обслуживание, приветливый персонал. Ответ через несколько часов!',
    'Dobra usluga, ljubazno osoblje. Odgovor za nekoliko sati!', 'Добра услуга, љубазно особље. Одговор за неколико сати!', 'Good service, friendly staff. Results in a few hours!', 'Хорошее обслуживание, приветливый персонал. Ответ через несколько часов!', 'Guter Service, freundliches Personal. Antwort in wenigen Stunden!', 'İyi hizmet, güler yüzlü personel. Birkaç saat içinde cevap!',
    0, '2022-03-24 00:00:00'),

(@user_vadim_bogdanov, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNxX3VlSVJ3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_jabbo, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNxbnVtZ3Z3RRAB',
    1, 'en', 'I was told that my test results would be emailed to me by a certain time. The results were never emailed. I had to leave my friends at the beach walk a very long way to the lab to get my results. Then walk all the way back to the beach . I won’t be back.',
    'Rečeno mi je da će mi rezultati testa biti poslani mejlom u određeno vrijeme. Rezultati nikada nisu stigli mejlom. Morao sam napustiti prijatelje na plaži i pješačiti veoma dugo do laboratorije da bih dobio rezultate. Zatim pješačiti cijeli put natrag do plaže. Neću se više vraćati.', 'Речено ми је да ће ми резултати теста бити послани мejлом у одређено вријеме. Резултати никада нису стигли мejлом. Морао сам напустити пријатеље на плажи и пјешачити веома дуго до лабораторије да бих добио резултате. Затим пјешачити цијели пут натраг до плаже. Нећу се више враћати.', 'I was told that my test results would be emailed to me by a certain time. The results were never emailed. I had to leave my friends at the beach walk a very long way to the lab to get my results. Then walk all the way back to the beach . I won’t be back.', 'Мне сказали, что результаты теста будут отправлены на почту к определённому времени. Результаты так и не пришли. Мне пришлось оставить друзей на пляже и пешком идти очень далеко до лаборатории, чтобы забрать результаты. А потом идти всю дорогу обратно на пляж. Больше не вернусь.', 'Man sagte mir, dass meine Testergebnisse bis zu einem bestimmten Zeitpunkt per E-Mail zugeschickt werden. Die Ergebnisse wurden nie per E-Mail verschickt. Ich musste meine Freunde am Strand zurücklassen und einen sehr langen Weg zum Labor gehen, um meine Ergebnisse zu holen. Dann den ganzen Weg zurück zum Strand laufen. Ich werde nicht wiederkommen.', 'Test sonuçlarımın belirli bir saatte e-posta ile gönderileceği söylendi. Sonuçlar hiç e-posta ile gönderilmedi. Arkadaşlarımı plajda bırakıp sonuçlarımı almak için laboratuvara çok uzun bir yol yürümek zorunda kaldım. Sonra tekrar plaja kadar yürümek. Bir daha gelmeyeceğim.',
    0, '2022-03-24 00:00:00'),

(@user_user_106866786942202092855, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNxZ3RxZGNREAE',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_sveta_svetik, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNxNU9PWHNRRRAB',
    5, 'ru', 'Быстро сделали тест, в другом городе в этой лаборатории уже распечатать его. Результаты пришли на посту в течение 20-ти минут. Отлично',
    'Brzo su uradili test, u drugom gradu u ovoj laboratoriji ga već odštampati. Rezultati su stigli na poštu za 20 minuta. Odlično', 'Брзо су урадили тест, у другом граду у овој лабораторији га већ одштампати. Резултати су стигли на пошту за 20 минута. Одлично', 'The test was done quickly, and in another city at this lab you can already print it out. Results arrived by email within 20 minutes. Excellent', 'Быстро сделали тест, в другом городе в этой лаборатории уже распечатать его. Результаты пришли на посту в течение 20-ти минут. Отлично', 'Der Test wurde schnell gemacht, in einer anderen Stadt in diesem Labor kann man ihn bereits ausdrucken. Ergebnisse kamen innerhalb von 20 Minuten per E-Mail. Ausgezeichnet', 'Testi hızlı yaptılar, başka bir şehirde bu laboratuvarda zaten yazdırabilirsiniz. Sonuçlar 20 dakika içinde e-postaya geldi. Mükemmel',
    0, '2022-03-24 00:00:00'),

(@user_user_110869791883263964323, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNxdVBQRnVBRRAB',
    5, 'he', 'לכל הנופשים בבדווה מונטנגרו.בדיקת קורנה לחוזרים לארץ.יעיל ומאד מהיר.תשובות עוד באותו הערב.מומלץ מאד',
    'Za sve odmornike u Budvi, Crna Gora. Corona test za povratak u zemlju. Efikasno i veoma brzo. Rezultati još iste večeri. Toplo preporučujem', 'За све одморнике у Будви, Црна Гора. Corona тест за повратак у земљу. Ефикасно и веома брзо. Резултати још исте вечери. Топло препоручујем', 'For all vacationers in Budva, Montenegro. Corona test for returning to the country. Efficient and very fast. Results the same evening. Highly recommended', 'Всем отдыхающим в Будве, Черногория. Тест на коронавирус для возвращающихся на родину. Эффективно и очень быстро. Результаты в тот же вечер. Очень рекомендую', 'Für alle Urlauber in Budva, Montenegro. Corona-Test für die Rückkehr ins Land. Effizient und sehr schnell. Ergebnisse noch am selben Abend. Sehr empfehlenswert', 'Karadağ Budva\'daki tüm tatilcilere. Ülkeye dönüş için korona testi. Verimli ve çok hızlı. Sonuçlar aynı akşam. Kesinlikle tavsiye edilir',
    0, '2022-03-24 00:00:00'),

(@user_yuri_vi, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURLbDZQOHZRRRAB',
    3, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_isilay_undemir, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURLamFPM29nRRAB',
    1, 'en', 'The lady at the reception desk is extremely rude and refuses to give even the slightest piece of information you ask for.
She only yells at foreigners to go outside and wait without informing properly. Horrible experience for us.
If we had another chance to get PCR test as a tourist, we would be running away from this lab',
    'Gospođa na recepciji je izuzetno gruba i odbija dati i najmanji djelić informacije koji zatražite.
Samo viče na strance da izađu i čekaju napolju bez odgovarajućeg obavještavanja. Užasno iskustvo za nas.
Kad bismo imali drugu šansu da se testiramo PCR-om kao turisti, bježali bismo od ove laboratorije', 'Госпођа на рецепцији је изузетно груба и одбија дати и најмањи дјелић информације коју затражите.
Само виче на странце да изађу и чекају напољу без одговарајућег обавјештавања. Ужасно искуство за нас.
Кад бисмо имали другу шансу да се тестирамо ПЦР-ом као туристи, бјежали бисмо од ове лабораторије', 'The lady at the reception desk is extremely rude and refuses to give even the slightest piece of information you ask for.
She only yells at foreigners to go outside and wait without informing properly. Horrible experience for us.
If we had another chance to get PCR test as a tourist, we would be running away from this lab', 'Женщина на стойке ресепшена крайне груба и отказывается давать даже малейшую информацию, которую вы просите.
Она только кричит на иностранцев, чтобы те вышли и ждали снаружи, не информируя должным образом. Ужасный опыт для нас.
Если бы у нас был ещё один шанс сдать ПЦР-тест как туристы, мы бы бежали от этой лаборатории', 'Die Dame an der Rezeption ist äußerst unhöflich und weigert sich, auch nur die geringste Information zu geben, nach der man fragt.
Sie schreit nur Ausländer an, nach draußen zu gehen und zu warten, ohne ordentlich zu informieren. Schreckliche Erfahrung für uns.
Wenn wir als Touristen noch eine Chance hätten, einen PCR-Test zu machen, würden wir vor diesem Labor davonlaufen', 'Resepsiyondaki bayan son derece kaba ve sorduğunuz en küçük bilgiyi bile vermeyi reddediyor.
Sadece yabancılara dışarı çıkıp beklemeleri için bağırıyor, düzgün bilgilendirme yapmıyor. Bizim için korkunç bir deneyimdi.
Turist olarak PCR testi yaptırmak için bir daha şansımız olsaydı, bu laboratuvardan kaçardık',
    0, '2022-03-24 00:00:00'),

(@user_marko_kustudic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSURLbHFfenpnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_adriaticpoint_construction_montenegro, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSURLdk9fVGFBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_doruk_uenal, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUNLaEtINFVBEAE',
    5, 'en', 'I had a good experience...',
    'Imao sam dobro iskustvo...', 'Имао сам добро искуство...', 'I had a good experience...', 'У меня был хороший опыт...', 'Ich hatte eine gute Erfahrung...', 'İyi bir deneyim yaşadım...',
    0, '2022-03-24 00:00:00'),

(@user_delfo_hagen, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUNLaE1IRm9BRRAB',
    5, 'en', 'Good service',
    'Dobra usluga', 'Добра услуга', 'Good service', 'Хороший сервис', 'Guter Service', 'İyi hizmet',
    0, '2022-03-24 00:00:00'),

(@user_zoran, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChZDSUhNMG9nS0VJQ0FnSUR5aWFpV01nEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-03-24 00:00:00'),

(@user_olga, @clinic_id, NULL, 'google_maps',
    'places/ChIJHfFt8SHVTRMR6W1Pm-V3v7A/reviews/ChdDSUhNMG9nS0VJQ0FnSUR5cHJYOHhRRRAB',
    1, 'hr', 'Imala sam lose iskustvo sa laboratorijom. I don\'t recommend it.',
    'Imala sam lose iskustvo sa laboratorijom. I don\'t recommend it.', 'Имала сам лоше искуство са лабораторијом. I don\'t recommend it.', 'I had a bad experience with the laboratory. I don\'t recommend it.', 'У меня был плохой опыт с этой лабораторией. Не рекомендую.', 'Ich hatte eine schlechte Erfahrung mit dem Labor. Ich empfehle es nicht.', 'Laboratuvarla kötü bir deneyim yaşadım. Tavsiye etmiyorum.',
    0, '2021-03-24 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
