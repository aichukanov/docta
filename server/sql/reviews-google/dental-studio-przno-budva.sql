-- Insert Google Maps reviews for DENTAL STUDIO PRŽNO
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dental-studio-przno-budva.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dental-studio-przno-budva');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_nikola_glusica = (SELECT id FROM doctors WHERE slug = 'nikola-glusica');
SET @doctor_nikolina_glusica = (SELECT id FROM doctors WHERE slug = 'nikolina-glusica');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Katherine', 'https://lh3.googleusercontent.com/a-/ALV-UjWEVuhFS5JjKpn9NR_UPJ12dQrutUfXr4WoIiEmiAo9K7DnHXVU=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/111270218495945571666/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111270218495945571666/reviews');
SET @user_katherine = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111270218495945571666/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Valeria Maevska', 'https://lh3.googleusercontent.com/a-/ALV-UjXCZ_qB6SWuq4PEbhZ883X1b0tdyU9LsexJRYsZrBmxC5qGaWJ2=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/100544223494320503597/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100544223494320503597/reviews');
SET @user_valeria_maevska = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100544223494320503597/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alexey ROSHCHUPKIN', 'https://lh3.googleusercontent.com/a/ACg8ocKFG7cTuIX5JwWV1QRZFmlLxSiLZdAM7NE_TkjVJGm7aLq0zA=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/102328858307217616775/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102328858307217616775/reviews');
SET @user_alexey_roshchupkin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102328858307217616775/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Draskovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWeTzUw_8Qx-h7nMYX1Z5S8PmoulW1oO35c7fA2Qj-qVF1FsRg=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/101476135140321902589/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101476135140321902589/reviews');
SET @user_ivan_draskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101476135140321902589/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'S.O. Group', 'https://lh3.googleusercontent.com/a-/ALV-UjX1NSo9X0reE9E5hGfuWQs6uMVd0fyL-FVHTq5VCC2kkfLQgvp7=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/108499053779775090107/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108499053779775090107/reviews');
SET @user_so_group = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108499053779775090107/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Елена Костенко', 'https://lh3.googleusercontent.com/a-/ALV-UjWPIn_YvunMz2Maq3YvO2XBQMkU03DwI56pq2Dt7z97DOykqdo=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112421541497395863130/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112421541497395863130/reviews');
SET @user_elena_kostenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112421541497395863130/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Лида Худобченок', 'https://lh3.googleusercontent.com/a-/ALV-UjWtiUZSf8qxpsvS_Y-kO3L1oDNvo8cnDjkRDl9Qm0g12SAeTkTgSQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102547961039432625068/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102547961039432625068/reviews');
SET @user_lida_khudobchenok = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102547961039432625068/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Adela Zec', 'https://lh3.googleusercontent.com/a/ACg8ocKrNshaYmYv4SAaz6KY68PIaCORIEsrsMRc4aGBStDQEB95Cg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114964837946601595703/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114964837946601595703/reviews');
SET @user_adela_zec = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114964837946601595703/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'All Bimm', 'https://lh3.googleusercontent.com/a-/ALV-UjXOhE7tg_QA9sMdZ5kg9rL1GhELOlZvjETJJZhLA-2-YGGoHIk=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107436952093996293283/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107436952093996293283/reviews');
SET @user_all_bimm = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107436952093996293283/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Burkakke 1337', 'https://lh3.googleusercontent.com/a-/ALV-UjVlQweKS90W13GwdixlBq-T8fSqMuvGQNJXcq2hN6XSdo0jg05j=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111409500398733363981/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111409500398733363981/reviews');
SET @user_burkakke_1337 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111409500398733363981/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Markovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVACmaArO-ozZo7jQOz8nhpcf0ns3VD_hULMGdVjD_NGBN-KEM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108152803232977905032/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108152803232977905032/reviews');
SET @user_dragana_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108152803232977905032/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nevenka Cvjetan', 'https://lh3.googleusercontent.com/a/ACg8ocK0wr6IkW4u3HNqljcuOtkfcQUB_osQNmqr2pbcHL7kibBUbA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115066426798756514014/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115066426798756514014/reviews');
SET @user_nevenka_cvjetan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115066426798756514014/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'm n', 'https://lh3.googleusercontent.com/a-/ALV-UjVpN77hVo1jOFdRNCrSK6ZNwl8XMTD0Welr3mOrSCUkfCpRpu06=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108407270548768220682/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108407270548768220682/reviews');
SET @user_m_n = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108407270548768220682/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'hallo Berlin', 'https://lh3.googleusercontent.com/a/ACg8ocJeplY13VjPa-1vFQkB9e8BEuArXY9uJr86jByVUqEDCOAnkQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112490847834806809378/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112490847834806809378/reviews');
SET @user_hallo_berlin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112490847834806809378/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Hendrik Rübenstahl', 'https://lh3.googleusercontent.com/a/ACg8ocIHrWCKgRFcQ0KdT3aOQtl-oKFHc_ZX8I6mEanLqJ_R_WuxWFo=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102549787675558394273/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102549787675558394273/reviews');
SET @user_hendrik_rbenstahl = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102549787675558394273/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lara Cvjetan', 'https://lh3.googleusercontent.com/a/ACg8ocLcECvLangNMbj-r1LqD_3cu3P65lMiIQLV7uhbXKHvswAZCQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103730876950872537565/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103730876950872537565/reviews');
SET @user_lara_cvjetan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103730876950872537565/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Birya', 'https://lh3.googleusercontent.com/a/ACg8ocI0DsrTHZD9IqBz1ndLAYOwfpxl2eQ_MWKsFUV_SMQgBNIVwg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106491756341729332007/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106491756341729332007/reviews');
SET @user_birya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106491756341729332007/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljupcho Jovanov', 'https://lh3.googleusercontent.com/a-/ALV-UjXqgKBzLJXTBdx2wAslMtM2NmgYmJqUuBRChYdBufcBoD5REBkg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110422094568426781810/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110422094568426781810/reviews');
SET @user_ljupcho_jovanov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110422094568426781810/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stuart Franklin', 'https://lh3.googleusercontent.com/a-/ALV-UjX3VRQbyhyO81uH8NFQe09PRF_Kw-knZnj9zZt6NT_PkPyAPv_0=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116140295021529502940/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116140295021529502940/reviews');
SET @user_stuart_franklin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116140295021529502940/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Hunter Killer', 'https://lh3.googleusercontent.com/a-/ALV-UjU_ASDwHCHsql6VsMmGYvhG-ODx5wXL6GA4kxOdDcqy9uRpYgA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117929007996055414153/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117929007996055414153/reviews');
SET @user_hunter_killer = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117929007996055414153/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Lalic', 'https://lh3.googleusercontent.com/a-/ALV-UjU_mlg2j2PvNl99uaL-GrvoHWEiQu8ZzqHnPQc8UhHFg-DLEqlV8Q=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101910395771142173538/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101910395771142173538/reviews');
SET @user_ivan_lalic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101910395771142173538/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danica Crnoglavac', 'https://lh3.googleusercontent.com/a-/ALV-UjWljAjl6o8bLj8G-22vJ6eagRQcxnzpt7VRupRqEbnfWm_SMeg3=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103289062470044680804/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103289062470044680804/reviews');
SET @user_danica_crnoglavac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103289062470044680804/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Thomas J Woods', 'https://lh3.googleusercontent.com/a-/ALV-UjWckYUW_W_HVkeDvpMt05Yyqj8thPHufX-rWGLZ8lKK0rfFFj2fQQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107227559448830758568/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107227559448830758568/reviews');
SET @user_thomas_j_woods = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107227559448830758568/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alex EH', 'https://lh3.googleusercontent.com/a-/ALV-UjUn65qymBDs9QqpKjgoT5l5yRpGjK595W3e6CwdHCbQD4g_VkbP=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116939547412766623561/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116939547412766623561/reviews');
SET @user_alex_eh = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116939547412766623561/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Надежда Ч', 'https://lh3.googleusercontent.com/a/ACg8ocKo9027GA-ltupmHWQKDZdhVwgW5kMZwddw6iNOnXH3S5fiyQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104146369817276856408/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104146369817276856408/reviews');
SET @user_nadezhda_ch = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104146369817276856408/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Дмитрий Волков', 'https://lh3.googleusercontent.com/a-/ALV-UjXg_eFUeNgyIR0HHwZEaccAwdbKufjRrwYIclB3hgpL0bNfwSjg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105397021133376694359/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105397021133376694359/reviews');
SET @user_dmitriy_volkov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105397021133376694359/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Алёна HDfoto', 'https://lh3.googleusercontent.com/a/ACg8ocLQHU1-0-bC1rsrDqpuFugBwZwnzRAshiaoEJUdzLXAyMiXyg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110535508596937285830/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110535508596937285830/reviews');
SET @user_alyona_hdfoto = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110535508596937285830/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sandra Mitrovic', 'https://lh3.googleusercontent.com/a/ACg8ocK6UzQGvjIPP6bXdrB6pvvTWR0BidmUcSpdLTCv2LHnGsRBNw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114050263997621368984/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114050263997621368984/reviews');
SET @user_sandra_mitrovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114050263997621368984/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Petkovic', 'https://lh3.googleusercontent.com/a/ACg8ocJWpycgrIMdS5oLnzasdyPb_IkMTFSkyxC50lPJedD-Ezq4Hg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112067186838206890180/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112067186838206890180/reviews');
SET @user_ana_petkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112067186838206890180/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mima Mitrovic', 'https://lh3.googleusercontent.com/a/ACg8ocLm8Z3fGBrduWrvMMVyki2meX5LsF3iiOdz4r7p20_tamhSvw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109831881903259346563/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109831881903259346563/reviews');
SET @user_mima_mitrovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109831881903259346563/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vesna Brguljan', 'https://lh3.googleusercontent.com/a/ACg8ocK_6TlhQXCkBZmp0_2fNgVh4ioCLmqpxlbEybtNr6Q4V5u1rQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115745774067684253215/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115745774067684253215/reviews');
SET @user_vesna_brguljan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115745774067684253215/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'mirela kovacevic', 'https://lh3.googleusercontent.com/a/ACg8ocKTUbTR7M9Q6kI15-fyiDL-pSxMJWKygUAxlJwEH-tgY4uHHw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106921039971978694151/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106921039971978694151/reviews');
SET @user_mirela_kovacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106921039971978694151/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tanja Kralj', 'https://lh3.googleusercontent.com/a/ACg8ocKOERARFRuoqkZMABBu6S177LbDr_cz08MCLDnd_HklFkisaA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105411594358870373680/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105411594358870373680/reviews');
SET @user_tanja_kralj = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105411594358870373680/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Simon Vujovic', 'https://lh3.googleusercontent.com/a/ACg8ocIkpsthFFRGJKM8kfJ7GppCZGHPrqCiflXO-qqFpz7Fns9z-Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118110918494852105729/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118110918494852105729/reviews');
SET @user_simon_vujovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118110918494852105729/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'marija otasevic', 'https://lh3.googleusercontent.com/a/ACg8ocKYjgGhI_VdlVlcUbB2_x_CN7cfu0a4NSbY8BRI8dQnpG6KcQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110752095806050465412/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110752095806050465412/reviews');
SET @user_marija_otasevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110752095806050465412/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branka Macanovic', 'https://lh3.googleusercontent.com/a/ACg8ocK_3dYHbhCDopUtnpfPPZfv7XbuVSBsV-3vE14ZGg_OTdifh6o=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109962677028825542874/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109962677028825542874/reviews');
SET @user_branka_macanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109962677028825542874/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Mitrovic', 'https://lh3.googleusercontent.com/a/ACg8ocJeLBNvg3ggkbbeeK5eh2tYrF8F_kj_97bsuuw7gA_bAw2abg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100201892020913457222/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100201892020913457222/reviews');
SET @user_marija_mitrovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100201892020913457222/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zoke Grujicic', 'https://lh3.googleusercontent.com/a/ACg8ocL3yTCWwZi4R2Vnwa6Jmis-ye0TD7lrW1-k76NjO9qeXaVhLQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105040146248524327007/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105040146248524327007/reviews');
SET @user_zoke_grujicic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105040146248524327007/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirko Hladni', 'https://lh3.googleusercontent.com/a-/ALV-UjWT9S2Dd25mnTwRMFdpj9hHp8C7LaYHj0OsV-U7qkgxxVUSJlw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106554479633708579666/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106554479633708579666/reviews');
SET @user_mirko_hladni = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106554479633708579666/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_katherine, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChdDSUhNMG9nS0VJQ0FnSUM3bHBDLXlnRRAB',
    5, 'ru', 'Лицензированный стоматолог Виталий из Украины - профессионал своего дела.
Чистая работа от имплантаций до детского приема.
Качество и сервис на хорошем уровне!
А морской вид из окна потрясающий 🫰
Рекомендую',
    'Licencirani stomatolog Vitalij iz Ukrajine je pravi profesionalac. Odličan rad, od implantata do pedijatrijskih pregleda. Odličan kvalitet i usluga! A pogled na more sa prozora je zapanjujući 🫰
Preporučujem.', 'Лиценцирани стоматолог Виталиј из Украјине је прави професионалац. Одличан рад, од имплантата до педијатријских прегледа. Одличан квалитет и услуга! А поглед на море са прозора је запањујући 🫰
Препоручујем.', NULL, 'Лицензированный стоматолог Виталий из Украины - профессионал своего дела.
Чистая работа от имплантаций до детского приема.
Качество и сервис на хорошем уровне!
А морской вид из окна потрясающий 🫰
Рекомендую', NULL, NULL,
    1, '2024-08-15 11:23:59'),

(@user_valeria_maevska, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChZDSUhNMG9nS0VJQ0FnSUNhMkw3bWZREAE',
    5, 'ru', 'RU | ENG

Всегда остаюсь под впечатлением от профессиональной и качественной работы этой стоматологии. Приятный персонал, который действительно заботится о своих пациентах. Очень рекомендую всем, кто ищет качественный сервис!

I\'m always impressed by the professionalism and quality of service. The staff are all super nice and truly seem to care about their patients. I highly recommend to anyone looking for quality service!',
    'RU | ENG

Uvek sam impresioniran profesionalnošću i kvalitetom usluge. Osoblje je super ljubazno i čini se da zaista brine o svojim pacijentima. Toplo preporučujem svima koji traže kvalitetnu uslugu!

Uvek sam impresioniran profesionalnošću i kvalitetom usluge. Osoblje je super ljubazno i čini se da zaista brine o svojim pacijentima. Toplo preporučujem svima koji traže kvalitetnu uslugu!', 'РУ | ЕНГ

Увек сам импресиониран професионалношћу и квалитетом услуге. Особље је супер љубазно и чини се да заиста брине о својим пацијентима. Топло препоручујем свима који траже квалитетну услугу!

Увек сам импресиониран професионалношћу и квалитетом услуге. Особље је супер љубазно и чини се да заиста брине о својим пацијентима. Топло препоручујем свима који траже квалитетну услугу!', NULL, 'RU | ENG

Всегда остаюсь под впечатлением от профессиональной и качественной работы этой стоматологии. Приятный персонал, который действительно заботится о своих пациентах. Очень рекомендую всем, кто ищет качественный сервис!

I\'m always impressed by the professionalism and quality of service. The staff are all super nice and truly seem to care about their patients. I highly recommend to anyone looking for quality service!', NULL, NULL,
    2, '2021-07-23 11:03:46'),

(@user_alexey_roshchupkin, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChdDSUhNMG9nS0VJQ0FnSUN1X3JmWDZRRRAB',
    5, 'en', 'Incredible clinic with fantastic personnel

I have just left the dental studio and I’m truly impressed. The place is spotlessly clean, with all the modern and sophisticated equipment but this is minor comparing to incredible doctors and medical personnel. I have come with an acute pain and lots of worries and was treated on a very high level of empathy and experience. Really looking forward to my next visit on Monday to have the hygiene done.
Thank you everyone at the clinic and I can not recommend it more to anyone who is looking for great dental service.',
    'Neverovatna klinika sa fantastičnim osobljem

Upravo sam napustio stomatološki studio i zaista sam impresioniran. Mesto je besprekorno čisto, sa svom modernom i sofisticiranom opremom, ali to je minorno u poređenju sa neverovatnim lekarima i medicinskim osobljem. Došao sam sa akutnim bolom i puno briga i lečen sam na veoma visokom nivou empatije i iskustva. Zaista se radujem svojoj sledećoj poseti u ponedeljak da obavim higijenu.
Hvala svima u klinici i ne mogu je više preporučiti bilo kome ko traži odličnu stomatološku uslugu.', 'Невероватна клиника са фантастичним особљем

Управо сам напустио стоматолошки студио и заиста сам импресиониран. Место је беспрекорно чисто, са свом модерном и софистицираном опремом, али то је минорно у поређењу са невероватним лекарима и медицинским особљем. Дошао сам са акутним болом и пуно брига и лечен сам на веома високом нивоу емпатије и искуства. Заиста се радујем својој следећој посети у понедељак да обавим хигијену.
Хвала свима у клиници и не могу је више препоручити било коме ко тражи одличну стоматолошку услугу.', 'Incredible clinic with fantastic personnel

I have just left the dental studio and I’m truly impressed. The place is spotlessly clean, with all the modern and sophisticated equipment but this is minor comparing to incredible doctors and medical personnel. I have come with an acute pain and lots of worries and was treated on a very high level of empathy and experience. Really looking forward to my next visit on Monday to have the hygiene done.
Thank you everyone at the clinic and I can not recommend it more to anyone who is looking for great dental service.', NULL, NULL, NULL,
    3, '2022-07-29 17:11:48'),

(@user_ivan_draskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChdDSUhNMG9nS0VJQ0FnSUMyLU1PODVBRRAB',
    5, 'bs', 'Profesionalno i efikasno su mi uradili implant.
Preporuka svakome ko zeli da opet ima osmijeh uz povoljne cijene i vrhunski kvalitet',
    'Ugradili su mi implantat profesionalno i efikasno.
Preporučujem svima koji žele ponovo da se osmehnu po pristupačnim cenama i vrhunskom kvalitetu', 'Уградили су ми имплантат професионално и ефикасно.
Препоручујем свима који желе поново да се осмехну по приступачним ценама и врхунском квалитету', NULL, NULL, NULL, NULL,
    1, '2022-04-12 11:54:47'),

(@user_so_group, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChZDSUhNMG9nS0VJQ0FnSUM1dThMMk9nEAE',
    5, 'ru', 'Чистая пятерка, от сервиса до персонала. Здесь вся наша семья делает ультразвуковую чистку зубов 2 раза в год,  когда необходимо лечим кариес, исправляем прикус младшей дочке. Эта стоматологическая практика предлагает широкий спектр услуг. Владельцами является супружеская пара доктора Никола и Николина, прекрасные люди и профессионалы своего дела.
Прекрасный бонус: вид на море со стоматологического кресла.',
    'Solidna petica, od servisa do osoblja. Cela naša porodica se ovde dva puta godišnje ultrazvučno čisti zube, po potrebi lečimo karijes, ispravljamo zagriz naše najmlađe ćerke. Ova stomatološka ordinacija nudi širok spektar usluga. Vlasnici su bračni par, doktori Nikola i Nikolina, divni ljudi i profesionalci u svojoj oblasti. Divan bonus: pogled na more sa zubarske stolice.', 'Солидна петица, од сервиса до особља. Цела наша породица се овде два пута годишње ултразвучно чисти зубе, по потреби лечимо каријес, исправљамо загриз наше најмлађе ћерке. Ова стоматолошка ординација нуди широк спектар услуга. Власници су брачни пар, доктори Никола и Николина, дивни људи и професионалци у својој области. Диван бонус: поглед на море са зубарске столице.', NULL, 'Чистая пятерка, от сервиса до персонала. Здесь вся наша семья делает ультразвуковую чистку зубов 2 раза в год,  когда необходимо лечим кариес, исправляем прикус младшей дочке. Эта стоматологическая практика предлагает широкий спектр услуг. Владельцами является супружеская пара доктора Никола и Николина, прекрасные люди и профессионалы своего дела.
Прекрасный бонус: вид на море со стоматологического кресла.', NULL, NULL,
    1, '2023-10-17 11:21:54'),

(@user_elena_kostenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s0eVEyZzVXQzAwWkVkTE9HUnBVRWREV0hSTGJFRRAB',
    5, 'ru', 'Хочу от всей души поблагодарить доктора Виталия и его замечательную ассистентку Миланку!
Вчера пришла на лечение одного зуба. Сначала мне сделали рентген, и доктор очень внимательно и спокойно всё объяснил — без спешки, всё понятно и профессионально.
Когда начали лечить шестёрку, доктор совершенно случайно заметил кариес на пятёрке, который визуально практически невозможно было увидеть. Он сразу обратил на это внимание, сделал дополнительную анестезию и предложил пролечить и этот зуб, чтобы не упустить проблему. В итоге вместо запланированного часа мы провели в кабинете почти два часа — и я ни на минуту не пожалела об этом.
Для меня это показатель настоящего профессионализма: доктор не работает «по времени», а действительно внимательно относится к пациенту и делает свою работу так, как сделал бы для себя.
У Виталия действительно золотые руки. Видно, что он не просто врач по профессии — он доктор по призванию. Очень грамотный, внимательный и аккуратный специалист.
И отдельное спасибо Миланке! Такая добрая, улыбчивая и заботливая ассистентка, что в какой-то момент я поймала себя на мысли: я словно пришла не к стоматологу, а в гости к хорошим друзьям.
Всё современно, чисто, спокойно, а самое главное — чувствуется человеческое отношение и любовь к своей работе.
Спасибо вам большое, Виталий и Миланка! Теперь я знаю, к кому можно спокойно идти лечить зубы и кому действительно можно доверять',
    NULL, NULL, NULL, 'Хочу от всей души поблагодарить доктора Виталия и его замечательную ассистентку Миланку!
Вчера пришла на лечение одного зуба. Сначала мне сделали рентген, и доктор очень внимательно и спокойно всё объяснил — без спешки, всё понятно и профессионально.
Когда начали лечить шестёрку, доктор совершенно случайно заметил кариес на пятёрке, который визуально практически невозможно было увидеть. Он сразу обратил на это внимание, сделал дополнительную анестезию и предложил пролечить и этот зуб, чтобы не упустить проблему. В итоге вместо запланированного часа мы провели в кабинете почти два часа — и я ни на минуту не пожалела об этом.
Для меня это показатель настоящего профессионализма: доктор не работает «по времени», а действительно внимательно относится к пациенту и делает свою работу так, как сделал бы для себя.
У Виталия действительно золотые руки. Видно, что он не просто врач по профессии — он доктор по призванию. Очень грамотный, внимательный и аккуратный специалист.
И отдельное спасибо Миланке! Такая добрая, улыбчивая и заботливая ассистентка, что в какой-то момент я поймала себя на мысли: я словно пришла не к стоматологу, а в гости к хорошим друзьям.
Всё современно, чисто, спокойно, а самое главное — чувствуется человеческое отношение и любовь к своей работе.
Спасибо вам большое, Виталий и Миланка! Теперь я знаю, к кому можно спокойно идти лечить зубы и кому действительно можно доверять', NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_lida_khudobchenok, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tZeGNuVlpaRk5KTm1sVFFrZDZNazlETkZkeWRsRRAB',
    5, 'ru', 'Профессионально, чисто, аккуратно, с душой! У Николы и Николины оперировала пародонтоз, лазером, отличный результат. У доктора ставила коронки, отличное сопровождение, подготовка под коронки, лечение, современные материалы, очень на высоком уровне! Коронки сели как влитые, очень довольна результатом!',
    NULL, NULL, NULL, 'Профессионально, чисто, аккуратно, с душой! У Николы и Николины оперировала пародонтоз, лазером, отличный результат. У доктора ставила коронки, отличное сопровождение, подготовка под коронки, лечение, современные материалы, очень на высоком уровне! Коронки сели как влитые, очень довольна результатом!', NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_adela_zec, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tsd2FEZDZlV0ZmYWtweGFXZE5ZbTFvWkZoa2QzYxAB',
    5, 'hr', 'Odlična klinika sa fantastičnim osobljem.Veliko hvala sestri Mariji za podršku,uz nju je sve lakše.Prvi put sam bila opuštena u stomatološkoj ordinaciji.',
    'Odlična klinika sa fantastičnim osobljem.Veliko hvala sestri Mariji za podršku,uz nju je sve lakše.Prvi put sam bila opuštena u stomatološkoj ordinaciji.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_all_bimm, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/Ci9DQUlRQUNvZENodHljRjlvT2toUlFrRkJabTUwVlUxNmFFaHdjM0ZvU1VKcWMxRRAB',
    5, 'en', 'Very polite and attentive staff, the job was done good (cleaning)',
    NULL, NULL, 'Very polite and attentive staff, the job was done good (cleaning)', NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_burkakke_1337, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/Ci9DQUlRQUNvZENodHljRjlvT25SWWFUSlFUa2cwY1ZRd01GbDNXV3RpVFdaRFRrRRAB',
    5, 'en', 'Very clean clinic and a really pleasant, friendly staff. I had a great experience and would definitely recommend it to anyone looking for quality dental care.
Surgeon Vitali is the king!',
    NULL, NULL, 'Very clean clinic and a really pleasant, friendly staff. I had a great experience and would definitely recommend it to anyone looking for quality dental care.
Surgeon Vitali is the king!', NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_dragana_markovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tFM1dUZHRkMGROUzNneFprMVdOVkl4ZHpkemRuYxAB',
    5, 'hr', 'Prezadovoljna sam uslugom i pristupom. Sve je bilo profesionalno i bezbolno. Sve pohvale za cijeli tim.Hvala na savršenom osmjehu!',
    'Prezadovoljna sam uslugom i pristupom. Sve je bilo profesionalno i bezbolno. Sve pohvale za cijeli tim.Hvala na savršenom osmjehu!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_nevenka_cvjetan, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GWWJUZEdhMTl4TTBOMVNGRnRaVmhXVTNwbVZVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_m_n, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t0U2QxOXlhbUZIUkdKbVZqSm1UVTlaYjJKbk9IYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-29 00:00:00'),

(@user_hallo_berlin, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/Ci9DQUlRQUNvZENodHljRjlvT25CclZIbzBWVUpQWVdWUkxYRnBXVkU0VUU1MFpHYxAB',
    5, 'de', 'Wir kamen sehr spontan, ein unfassbar nettes Praxisteam! Super schnelle und effektive Behandlung! Vielen Dank!',
    NULL, NULL, NULL, NULL, 'Wir kamen sehr spontan, ein unfassbar nettes Praxisteam! Super schnelle und effektive Behandlung! Vielen Dank!', NULL,
    0, '2025-10-29 00:00:00'),

(@user_hendrik_rbenstahl, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xWRk9YRklaR2RqWXpCdFUzWklUVmxRU1RaeGNXYxAB',
    5, 'en', 'Super nice and competent team 👍',
    NULL, NULL, 'Super nice and competent team 👍', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_lara_cvjetan, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/Ci9DQUlRQUNvZENodHljRjlvT25oaGJUSnViRVJWT0dzMk1XOW9YMjFCUW1RemNIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_birya, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChZDSUhNMG9nS0VJQ0FnTUNBeW9yVGJnEAE',
    5, 'ru', 'Виталий отличный врач. В стоматологии приятно делать зубы',
    NULL, NULL, NULL, 'Виталий отличный врач. В стоматологии приятно делать зубы', NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ljupcho_jovanov, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChdDSUhNMG9nS0VJQ0FnSURmdmVQZGxBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_stuart_franklin, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChZDSUhNMG9nS0VJQ0FnSURudkxLbWVBEAE',
    5, 'en', 'Excellent Dental work for a very reasonable price. Couldn’t recommend them enough 🙏',
    NULL, NULL, 'Excellent Dental work for a very reasonable price. Couldn’t recommend them enough 🙏', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_hunter_killer, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChZDSUhNMG9nS0VJQ0FnSUNIaDUzNkFREAE',
    5, 'ru', 'Внимательный доктор . Удалил жене зуб совершенно безболезненно',
    NULL, NULL, NULL, 'Внимательный доктор . Удалил жене зуб совершенно безболезненно', NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_ivan_lalic, @clinic_id, @doctor_nikolina_glusica, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChdDSUhNMG9nS0VJQ0FnSUNIbVpfWXp3RRAB',
    5, 'hr', 'Najbolja zubarka Nikolina 🙂',
    'Najbolja zubarka Nikolina 🙂', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_danica_crnoglavac, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChZDSUhNMG9nS0VJQ0FnSUNIbWNPUUhREAE',
    5, 'hr', 'Najbolji tim🩵',
    'Najbolji tim🩵', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_thomas_j_woods, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChZDSUhNMG9nS0VJQ0FnSUM3MzQyMFFnEAE',
    5, 'en', 'Absolutely first class dental praxis. We had to get emergency work done and it was wonderful. Thoroughly recommend.',
    NULL, NULL, 'Absolutely first class dental praxis. We had to get emergency work done and it was wonderful. Thoroughly recommend.', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_alex_eh, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChZDSUhNMG9nS0VJQ0FnSUNycUxiLWVREAE',
    1, 'ru', 'Никому не советую здесь ставить импланты. Сделали ужасно пришлось в другой клинике переделывать',
    NULL, NULL, NULL, 'Никому не советую здесь ставить импланты. Сделали ужасно пришлось в другой клинике переделывать', NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_nadezhda_ch, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChdDSUhNMG9nS0VJQ0FnSUNUOVlldjBRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_dmitriy_volkov, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChZDSUhNMG9nS0VJQ0FnSUNCNWM3R0hnEAE',
    1, 'en', 'The filling in my tooth fell out. They told me 55€ and it will be new.  I came, first for some reason they did a full x-ray, for 25 €, and they told me that I had a lot of inflammation, then they did an “free” x-ray of the tooth, although they could do it right away, without a full x-ray. The inflammation was confirmed.  They advised to remove the tooth or it would be a very long treatment for about half a year.  The extraction of the tooth they said would be very complicated, with the operation and cutting of the gums, which costs 250€, the treatment is even more expensive.  I left, in Budva I had a filling replaced by real dentists for 30€, everything is in order, for more than two months, there is no inflammation.  This clinic only wants your money and thinks about fictional illnesses, but does not treat you!',
    NULL, NULL, 'The filling in my tooth fell out. They told me 55€ and it will be new.  I came, first for some reason they did a full x-ray, for 25 €, and they told me that I had a lot of inflammation, then they did an “free” x-ray of the tooth, although they could do it right away, without a full x-ray. The inflammation was confirmed.  They advised to remove the tooth or it would be a very long treatment for about half a year.  The extraction of the tooth they said would be very complicated, with the operation and cutting of the gums, which costs 250€, the treatment is even more expensive.  I left, in Budva I had a filling replaced by real dentists for 30€, everything is in order, for more than two months, there is no inflammation.  This clinic only wants your money and thinks about fictional illnesses, but does not treat you!', NULL, NULL, NULL,
    1, '2023-10-29 00:00:00'),

(@user_alyona_hdfoto, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChdDSUhNMG9nS0VJQ0FnSUMyb3VtN3lRRRAB',
    5, 'ru', 'Прекрасные специалисты! Для меня-они лучшие в сфере профилактики и лечения зубов в Черногории. Мне всегда уютно у них, нет страха,что сделают что-то не так. В их студии всё,начиная от докторов-профессионалов, до оборудования,которое они используют-на высшем уровне! Спасибо за ваш профессионализм! ❤️❤️❤️🌹🌹🌹',
    NULL, NULL, NULL, 'Прекрасные специалисты! Для меня-они лучшие в сфере профилактики и лечения зубов в Черногории. Мне всегда уютно у них, нет страха,что сделают что-то не так. В их студии всё,начиная от докторов-профессионалов, до оборудования,которое они используют-на высшем уровне! Спасибо за ваш профессионализм! ❤️❤️❤️🌹🌹🌹', NULL, NULL,
    1, '2022-10-29 00:00:00'),

(@user_sandra_mitrovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChdDSUhNMG9nS0VJQ0FnSUMyeE9MMnpRRRAB',
    5, 'en', 'A very professional team , great approach to patients , and wonderful results . Highly reccomend 👏',
    NULL, NULL, 'A very professional team , great approach to patients , and wonderful results . Highly reccomend 👏', NULL, NULL, NULL,
    2, '2022-10-29 00:00:00'),

(@user_ana_petkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChdDSUhNMG9nS0VJQ0FnSUMyaE4yaTBBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_mima_mitrovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChdDSUhNMG9nS0VJQ0FnSUMyaExuc3h3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_vesna_brguljan, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChdDSUhNMG9nS0VJQ0FnSUMyaEtuaTZnRRAB',
    5, 'bs', 'Jednom rijecju PERFEKTNI ! U prelijepom ambijentu ordinacija pruza sve na jednom mjestu .Uz visok nivo znanja i sposobnosti  puni razumjevanja i strpljenja za pacijenta.Nikola Nikolina i Zorka su  pravi primjer posvecenosti pacijentu i njegovim potrebama . Da vas osmjeh ponovo zablista posjetite Dental studio Przno:)',
    'Jednom rijecju PERFEKTNI ! U prelijepom ambijentu ordinacija pruza sve na jednom mjestu .Uz visok nivo znanja i sposobnosti  puni razumjevanja i strpljenja za pacijenta.Nikola Nikolina i Zorka su  pravi primjer posvecenosti pacijentu i njegovim potrebama . Da vas osmjeh ponovo zablista posjetite Dental studio Przno:)', NULL, NULL, NULL, NULL, NULL,
    2, '2022-10-29 00:00:00'),

(@user_mirela_kovacevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChZDSUhNMG9nS0VJQ0FnSUMyaElyS1VnEAE',
    5, 'hr', 'Strucni, strpljivi, ljubazni🥰',
    'Strucni, strpljivi, ljubazni🥰', NULL, NULL, NULL, NULL, NULL,
    1, '2022-10-29 00:00:00'),

(@user_tanja_kralj, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChdDSUhNMG9nS0VJQ0FnSUMyaEtMMXZnRRAB',
    5, 'en', 'very professional and kind!',
    NULL, NULL, 'very professional and kind!', NULL, NULL, NULL,
    1, '2022-10-29 00:00:00'),

(@user_simon_vujovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChdDSUhNMG9nS0VJQ0FnSUMyaE1TRzlnRRAB',
    5, 'bs', 'Uz dobar tim stomatologa pobijedili smo strah koji smo imali prilikom vadjenja zuba...Osmjehom i strucnoscu ,pristupom kod djece pobjedjuju sve tegobe koje djeca ima odlaskom kod zubara.',
    'Uz dobar tim stomatologa pobijedili smo strah koji smo imali prilikom vadjenja zuba...Osmjehom i strucnoscu ,pristupom kod djece pobjedjuju sve tegobe koje djeca ima odlaskom kod zubara.', NULL, NULL, NULL, NULL, NULL,
    1, '2022-10-29 00:00:00'),

(@user_marija_otasevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChZDSUhNMG9nS0VJQ0FnSUMyaEtqSVBnEAE',
    5, 'bs', 'Savrseno opremljen "Studio" i kao takav je u sijenci strucnog,predusretljivog,ljubaznog osoblja,  koji u jednom dolasku resavaju probleme!
Pozdrav za Dr.Nikolu i Dr.Nikolinu!',
    'Savrseno opremljen "Studio" i kao takav je u sijenci strucnog,predusretljivog,ljubaznog osoblja,  koji u jednom dolasku resavaju probleme!
Pozdrav za Dr.Nikolu i Dr.Nikolinu!', NULL, NULL, NULL, NULL, NULL,
    1, '2022-10-29 00:00:00'),

(@user_branka_macanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChZDSUhNMG9nS0VJQ0FnSUMyLU43SGFBEAE',
    5, 'bs', 'Sve preporuke za njih. Detaljni, pazljivi, sve najbolje  😊',
    'Sve preporuke za njih. Detaljni, pazljivi, sve najbolje  😊', NULL, NULL, NULL, NULL, NULL,
    1, '2022-10-29 00:00:00'),

(@user_marija_mitrovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChdDSUhNMG9nS0VJQ0FnSUMyLU5LUDhnRRAB',
    5, 'bs', 'Zubari koji su uspeli da me oslobode visegodisnjeg straha... Veoma strpljivi, ljubazni i strucni. Topla preporuka
❤️',
    'Zubari koji su uspeli da me oslobode visegodisnjeg straha... Veoma strpljivi, ljubazni i strucni. Topla preporuka
❤️', NULL, NULL, NULL, NULL, NULL,
    2, '2022-10-29 00:00:00'),

(@user_zoke_grujicic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChZDSUhNMG9nS0VJQ0FnSUMyLU1LNk1BEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_mirko_hladni, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1S6cCobVTRMRKa9sXal5EB4/reviews/ChdDSUhNMG9nS0VJQ0FnSURLa3Q2cW1nRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
