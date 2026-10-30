-- Insert Google Maps reviews for Mićunović Medical
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/micunovic-medical-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'micunovic-medical-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_miljan_micunovic = (SELECT id FROM doctors WHERE slug = 'miljan-micunovic');
SET @doctor_nenad_mracevic = (SELECT id FROM doctors WHERE slug = 'nenad-mracevic');
SET @doctor_medina_tuzovic = (SELECT id FROM doctors WHERE slug = 'medina-tuzovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jevrem Bjelopavlic', 'https://lh3.googleusercontent.com/a/ACg8ocJXuEn-LIH1yD2b-uZx8oPqqa9GyjojEYuzVBPEHmZkjrDoCQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/113778049198478695744/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113778049198478695744/reviews');
SET @user_jevrem_bjelopavlic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113778049198478695744/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Драган Асановић', 'https://lh3.googleusercontent.com/a-/ALV-UjU4SY7eUCNzzc8iot53Es4lFgXc2lrKppGpHFNCt6zhckHEiq9m5w=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/107239754915802598456/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107239754915802598456/reviews');
SET @user_dragan_asanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107239754915802598456/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Saulic', 'https://lh3.googleusercontent.com/a/ACg8ocI0cescI5yuV1bpx002mjAyytmFUYOwb7_rjmnokkszkrxf9g=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101883266001186650783/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101883266001186650783/reviews');
SET @user_jelena_saulic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101883266001186650783/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Djurovic', 'https://lh3.googleusercontent.com/a/ACg8ocJ92_0LGt9S4DauRzbDHO08Mi1hF1oXmIRYVcAD5r1tK6LzcR8=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/114400079185519262513/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114400079185519262513/reviews');
SET @user_jelena_djurovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114400079185519262513/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'RP MEDICAL', 'https://lh3.googleusercontent.com/a-/ALV-UjUApo3PdGEoyEmxYDdjH3ajqZN5RvbTdyb-IURM2EZLX_alWec=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101586730891336944969/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101586730891336944969/reviews');
SET @user_rp_medical = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101586730891336944969/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ich Ich', 'https://lh3.googleusercontent.com/a/ACg8ocLLGuR1h9HEf_tPeAeaiFE_Azwe6K8JFqFeJazcq4CKn5UpMA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108926407851127128290/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108926407851127128290/reviews');
SET @user_ich_ich = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108926407851127128290/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sara Micunovic', 'https://lh3.googleusercontent.com/a/ACg8ocLdAMO7Nt0AbO9w3s-qCMgXDE-MgsBFcOV6odY1gh0Ca3nWnQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103589334783012346783/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103589334783012346783/reviews');
SET @user_sara_micunovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103589334783012346783/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'tinasaljanin82', 'https://lh3.googleusercontent.com/a/ACg8ocJOSmYqZ9jjsKMKl3wO_gGy2GqKmAIPONgEJOWX9v46_f3nhxra=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104475520600068770748/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104475520600068770748/reviews');
SET @user_tinasaljanin82 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104475520600068770748/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danko Djurisic', 'https://lh3.googleusercontent.com/a/ACg8ocLsLoQAIOTHicvq196hjOr-hGw9yhbCbliilGVUtLiKJbfHeTrD=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116748653098793256656/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116748653098793256656/reviews');
SET @user_danko_djurisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116748653098793256656/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sandra Radevic', 'https://lh3.googleusercontent.com/a-/ALV-UjVmrBBAmA2Xsf9HWrV4YDGSCx7rS5QIRLJ2wCO4ZX1p9_RH6Zyz=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107905932036571822437/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107905932036571822437/reviews');
SET @user_sandra_radevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107905932036571822437/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'dado rakocevic', 'https://lh3.googleusercontent.com/a-/ALV-UjVG5p6Y5NS9w397ptgTAOLf0ipnoyGcHbhgYDdwRudfgGgrTECaqA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101476433111736978252/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101476433111736978252/reviews');
SET @user_dado_rakocevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101476433111736978252/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sneza SR', 'https://lh3.googleusercontent.com/a-/ALV-UjVg1OOLjjSRi9Ly1INqGlYQuumgqo11zy4eZlu2psROPdjZpxM2=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117340222740526433167/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117340222740526433167/reviews');
SET @user_sneza_sr = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117340222740526433167/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andrijana Sanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXTnn78EHSc8M6QW4KXIqbw_LIDULKpe7VhmUscAmz6kDjZ7Hi8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107658094291920730344/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107658094291920730344/reviews');
SET @user_andrijana_sanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107658094291920730344/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Emica Brajovic', 'https://lh3.googleusercontent.com/a/ACg8ocLwbsYCz0k4PYLtMsQn9ed63r9qv2NqHuvRlOLQLZ1-XJDLVPk=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111476755155840677332/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111476755155840677332/reviews');
SET @user_emica_brajovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111476755155840677332/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Predrag', 'https://lh3.googleusercontent.com/a/ACg8ocJRXY1SPujzrB4Z-4-rO5HNaEVrThOGRtjXRtgQW_kFgm56A6M=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115340948115729558428/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115340948115729558428/reviews');
SET @user_predrag = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115340948115729558428/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Beni Kajtazi', 'https://lh3.googleusercontent.com/a/ACg8ocKH2Kqr9TC_ZvNs-8or645MErGLxBdamSE7l34g_67EwKVMnA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110204422666130856642/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110204422666130856642/reviews');
SET @user_beni_kajtazi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110204422666130856642/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Katie Costello', 'https://lh3.googleusercontent.com/a/ACg8ocJFTikT8Z3L6s5P43LN26Wm86lGp4LjjM3noDu1tmYmvo-KZw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102378712145643807331/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102378712145643807331/reviews');
SET @user_katie_costello = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102378712145643807331/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sophie Marie', 'https://lh3.googleusercontent.com/a/ACg8ocItOYWBHsCOqLt87F2mHAMgcHPLp8ohcXxbX7eb4tr3x2R8Dg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105260824062994381742/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105260824062994381742/reviews');
SET @user_sophie_marie = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105260824062994381742/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Micunovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWVtpI3-J-OkaUcZ2EDL5cLhhd8VtPsuHh9_B4jG694b8mv9eAeEg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110408280934412961221/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110408280934412961221/reviews');
SET @user_nikola_micunovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110408280934412961221/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojan Bozovic', 'https://lh3.googleusercontent.com/a/ACg8ocKzk8WPzw1AVLO-zOfabrNyCI-1HGbDouOny95Ni4iIXCNzbA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107442910204265264210/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107442910204265264210/reviews');
SET @user_bojan_bozovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107442910204265264210/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'mastalica 01', 'https://lh3.googleusercontent.com/a-/ALV-UjVY8SAooHK_FW08AyDVV_H2yO6aaxuYMVS4vkePonwND7ujNObA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108955805088284801037/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108955805088284801037/reviews');
SET @user_mastalica_01 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108955805088284801037/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ilija Kopitovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXwt4neQmUPvwPbs5VWmuCau3Syk3Sf1UrlDkO5pkiwVojKzJkb=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111549344316702176181/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111549344316702176181/reviews');
SET @user_ilija_kopitovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111549344316702176181/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Juan Muqbel', 'https://lh3.googleusercontent.com/a/ACg8ocKGtenqJQMN3ImL-P-jn1ZObl47RfrhvMlHKwgZAN5g-GaywA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110359563115897524667/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110359563115897524667/reviews');
SET @user_juan_muqbel = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110359563115897524667/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Patrik Paljusevic', 'https://lh3.googleusercontent.com/a-/ALV-UjWNUSF6v6DWcgrJAJMlgGJyBl4rr2u9oIWXJ45B96rQdvU3Ed1n=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/118123592267210455797/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118123592267210455797/reviews');
SET @user_patrik_paljusevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118123592267210455797/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Filip_S', 'https://lh3.googleusercontent.com/a/ACg8ocLds5_hudGRt4ZdhnnTB0PoopiSbyDe60EdGiB7xFKP0tBf9Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104290152988414442697/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104290152988414442697/reviews');
SET @user_filips = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104290152988414442697/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljiljana Adžić', 'https://lh3.googleusercontent.com/a/ACg8ocJ9N9IQ3otvRqadFDjjK8OkvUyBaHn53DAnh1gbX-_8A6OAUkY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100497629401984704709/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100497629401984704709/reviews');
SET @user_ljiljana_adi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100497629401984704709/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stefani Pejić', 'https://lh3.googleusercontent.com/a/ACg8ocIU9itFeSlLxI4EYFZZHA2JmFrrjRKAtJ4G_7iIElhffeGFoA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116440340635964597780/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116440340635964597780/reviews');
SET @user_stefani_peji = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116440340635964597780/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stevan Nikolic', 'https://lh3.googleusercontent.com/a/ACg8ocKHGdnSCVqMv4xpb5Cn6Gd5z6YfEEnyWGzrYyXK9-tLV3lk=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102242775423643406903/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102242775423643406903/reviews');
SET @user_stevan_nikolic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102242775423643406903/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ante alduk', 'https://lh3.googleusercontent.com/a-/ALV-UjUBilAZiq6ZWV4Vs3DFl6IAVOR_zTERf-CQFn9lJ2ubEmxmuRAvNw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111889167520327323375/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111889167520327323375/reviews');
SET @user_ante_alduk = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111889167520327323375/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jasmina Dasic', 'https://lh3.googleusercontent.com/a-/ALV-UjXwCbFusaqpfJwmRzC_JYkeJ_y624GtCYFvHRvluGbAiTRDyeV6=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110654922049423140029/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110654922049423140029/reviews');
SET @user_jasmina_dasic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110654922049423140029/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Veljko Zlatičanin', 'https://lh3.googleusercontent.com/a/ACg8ocJFqeBJ-rGjzsZNU5TrdinW-PzgLhuyHGx9JqquNfif24lPJA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115547915752591586643/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115547915752591586643/reviews');
SET @user_veljko_zlatianin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115547915752591586643/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marijo Kapular', 'https://lh3.googleusercontent.com/a/ACg8ocJO1GzewLha1RfUnqQ0RoMiiE2oOLgsUMpuQiZBlRmG7eITsQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102676137378653834695/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102676137378653834695/reviews');
SET @user_marijo_kapular = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102676137378653834695/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mar', 'https://lh3.googleusercontent.com/a/ACg8ocID2lgep7TxAU7lHmjhrgVHeYV0iHMZ0biY5ahwhZ2BbEyqjg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101659693566884391611/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101659693566884391611/reviews');
SET @user_mar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101659693566884391611/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Inna L', 'https://lh3.googleusercontent.com/a-/ALV-UjU6y-JxsGSIpjZmkLukNE-VS8Qzil7lL-58GlC3RiZX0_D-5CcV=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111793118176390960657/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111793118176390960657/reviews');
SET @user_inna_l = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111793118176390960657/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'bakala karic', 'https://lh3.googleusercontent.com/a/ACg8ocJqPNqWtN-gXLMpmPexli4079hhBriv7pG5gqSomgKhCSLIpw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104384071328009507953/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104384071328009507953/reviews');
SET @user_bakala_karic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104384071328009507953/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natalija Markovic', 'https://lh3.googleusercontent.com/a/ACg8ocIbVPAmzXcq_0Qq6EY-Plxapc2CdM18fMlbgq_8oXIaCQdkiQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116859965369447412654/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116859965369447412654/reviews');
SET @user_natalija_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116859965369447412654/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Medina Mehmedovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXh9BJiXyt29N7_JXZd7ydUobfXdoI3dng-Jken63rMtDgPnpCFEQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108467844503224821432/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108467844503224821432/reviews');
SET @user_medina_mehmedovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108467844503224821432/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Cetkovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUQIHYUDC1kZ4I7B0dx9S6NxhGadeeREvSMkRep17ud1NEI5cO-=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107707846118425778849/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107707846118425778849/reviews');
SET @user_marija_cetkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107707846118425778849/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Theo known as Ellen', 'https://lh3.googleusercontent.com/a-/ALV-UjVgApJlPrUFgfZ65XCiz92JyOZ6u-MvxmOAKHLrToO7Ffncyng=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/118098542779729850381/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118098542779729850381/reviews');
SET @user_theo_known_as_ellen = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118098542779729850381/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lela', 'https://lh3.googleusercontent.com/a-/ALV-UjUXrg1E0vx0U_fDhHzaNmGKvsbP0qwKDFuWx8cZrJn-DN8W-O4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107138895359841664271/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107138895359841664271/reviews');
SET @user_lela = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107138895359841664271/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sara Micunovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVlFq0Zq6a9SnAg744g_K8D5XEtwqdY5VytBXPcS7ee3F8c8iM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112621322893913885375/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112621322893913885375/reviews');
SET @user_sara_micunovic_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112621322893913885375/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maras Dejan', 'https://lh3.googleusercontent.com/a/ACg8ocL0K9cXlkE5vpJF6FN7pvJxeTtyjUR_TbG8hwPaTr4cG-ys2Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100973006201994920043/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100973006201994920043/reviews');
SET @user_maras_dejan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100973006201994920043/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Mugosa', 'https://lh3.googleusercontent.com/a/ACg8ocJLkPUVUwA0iP50a3SywuefcZ11HvOVdCqF2vERrSTittWKmA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102698569282503023627/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102698569282503023627/reviews');
SET @user_jelena_mugosa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102698569282503023627/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Angie G', 'https://lh3.googleusercontent.com/a/ACg8ocJPBmQnniea9U1-MOiQNddlXC6DUydMkIjyDBJcJS_9egzWLA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112059874084304216567/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112059874084304216567/reviews');
SET @user_angie_g = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112059874084304216567/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zoka Rasovic', 'https://lh3.googleusercontent.com/a/ACg8ocL2FfDkHuS3kHmY9RmSDLmkz_bJC2vRFVbeBOvXIobqnqGJtw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117006080841218206060/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117006080841218206060/reviews');
SET @user_zoka_rasovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117006080841218206060/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tijana Mugosa', 'https://lh3.googleusercontent.com/a-/ALV-UjUaOqLsDfWIYfcye1dx9TlEiKlEQAMICbZe1sh7o3BMV4ICrQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104054123231646543046/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104054123231646543046/reviews');
SET @user_tijana_mugosa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104054123231646543046/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nenad Mracevic', 'https://lh3.googleusercontent.com/a/ACg8ocICgkj15zADpBGZtstvTPfpiXC6O_pgDu-e9GKO36m4KgKwnA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109133022382999938079/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109133022382999938079/reviews');
SET @user_nenad_mracevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109133022382999938079/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'danijela dzakovic', 'https://lh3.googleusercontent.com/a/ACg8ocLrtQ_m3hczzEkCw5pgbt2ekO8D7Od0xDDV0No0PAyNpaWybNn7=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110180322377866889876/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110180322377866889876/reviews');
SET @user_danijela_dzakovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110180322377866889876/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Joksimovic', 'https://lh3.googleusercontent.com/a/ACg8ocI44NvADiM-HI2MECegz_ZNkSKhGUFnsV0RmgDXDkIiTuvyRQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106100310256046397107/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106100310256046397107/reviews');
SET @user_ana_joksimovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106100310256046397107/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andjelija Cavic', 'https://lh3.googleusercontent.com/a/ACg8ocLHfQS_RBq1sq29YcpyNwlVeywiJxH8DDjXTRxDQ4lRZ_Zi_A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108853923527666419353/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108853923527666419353/reviews');
SET @user_andjelija_cavic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108853923527666419353/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tomislav Jerat', 'https://lh3.googleusercontent.com/a-/ALV-UjXhh718MIWeJ9rBoFB4zBBnnA1AGz-tj7Lj0l1h8CBZfB4Z1XfC=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116461023119272290909/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116461023119272290909/reviews');
SET @user_tomislav_jerat = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116461023119272290909/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Djuranovic', 'https://lh3.googleusercontent.com/a-/ALV-UjV9JlCndApT8DBtzNRYE6Mz0AWzOxmB85D4t66e6qX7Vr-40wNN=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106374425169155002433/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106374425169155002433/reviews');
SET @user_nikola_djuranovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106374425169155002433/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Roman Slingov', 'https://lh3.googleusercontent.com/a-/ALV-UjVIAHG2JBUkOhLJDKXAZG6PCHakOXIfwJbKV_8kr6-lB5cYxvgr=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115907925997427258203/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115907925997427258203/reviews');
SET @user_roman_slingov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115907925997427258203/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Miljan Mićunović', 'https://lh3.googleusercontent.com/a/ACg8ocIgR8PhYzxQvDNdV5FonEyYVBpsC42IT225p6Zy_9IzfkIc4A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114476935726242558078/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114476935726242558078/reviews');
SET @user_miljan_miunovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114476935726242558078/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'boskom 29', 'https://lh3.googleusercontent.com/a/ACg8ocJliineiSCBlrftOhqXAm1Py5t1eaSjfzJU-FJH8EqwwbhImg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106032391417628739713/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106032391417628739713/reviews');
SET @user_boskom_29 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106032391417628739713/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Miki Dragicevic', 'https://lh3.googleusercontent.com/a/ACg8ocLMnPKE5j06HDpb2NiS_tjrS_SHt5VKtAT-xI2zLydmxDeCBA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113220737651887950400/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113220737651887950400/reviews');
SET @user_miki_dragicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113220737651887950400/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Vukovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUOHiKKN_V0NSg4kSV8pVXxfraaGN9h6MJZlfVkKreTLyZARWNlrw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112985300068192380297/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112985300068192380297/reviews');
SET @user_ana_vukovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112985300068192380297/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dado Pejuskovic', 'https://lh3.googleusercontent.com/a/ACg8ocLDqpR3e6QkMK30WcCf8_s4RgcTuc1qWDTZCzHtHSLdlFmNSg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108729323029025976035/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108729323029025976035/reviews');
SET @user_dado_pejuskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108729323029025976035/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikica Kenneth', 'https://lh3.googleusercontent.com/a/ACg8ocJZ5psK2HU14BThpfiOO8hjpAbKCcRykmTQH6_v8Fjd-RKtog=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109492808109521504614/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109492808109521504614/reviews');
SET @user_nikica_kenneth = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109492808109521504614/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ned Vuk', 'https://lh3.googleusercontent.com/a/ACg8ocI1K_QTYwEQIhoHAiENTf1v73F-1D6qdyzEdMeGQQtMU_wv1g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102738582428860220465/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102738582428860220465/reviews');
SET @user_ned_vuk = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102738582428860220465/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Pavlicevic', 'https://lh3.googleusercontent.com/a/ACg8ocJf6NzHkGGRHqnfc-68uZpo6ouFdiz8J5qcr121MkH4tQaygw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108520908250010427192/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108520908250010427192/reviews');
SET @user_marko_pavlicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108520908250010427192/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'nikola velimirovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVphwdsPm1_opNHVSC2kuKbG4gM1CTJdu6cvBxE2tW125ZUk1Gg9w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104264985100747907019/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104264985100747907019/reviews');
SET @user_nikola_velimirovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104264985100747907019/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danijela Radenovic', 'https://lh3.googleusercontent.com/a/ACg8ocLiYgEcWxAFtes_w94opHyqnAl0YCMLgUr6NPpV3ABU66Wdvw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102161775313509789638/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102161775313509789638/reviews');
SET @user_danijela_radenovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102161775313509789638/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vedran Lunic', 'https://lh3.googleusercontent.com/a-/ALV-UjVdaWKbTl-kwo_cjCVZtzkJngkJgOcghnIaMkIjFl3VqtXdE2X6lA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105799326518823846336/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105799326518823846336/reviews');
SET @user_vedran_lunic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105799326518823846336/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milena Miranovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXapn2anZBWonny-DxHCez_188Z6fcFcUhKpNJDJ87JjkLMvyVJ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105747664241011212690/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105747664241011212690/reviews');
SET @user_milena_miranovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105747664241011212690/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'vladan stojovic', 'https://lh3.googleusercontent.com/a-/ALV-UjX4tJLZZ6_Fo0KDxoVoqWl5sxj41Jq_fUGasHT9sS9CNV3ZjPq-Lw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102966895782907076705/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102966895782907076705/reviews');
SET @user_vladan_stojovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102966895782907076705/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Micko Kadija', 'https://lh3.googleusercontent.com/a/ACg8ocLopYdDncBmTH1ZdZq1uSec7DB0HQTRS6Rux7__p3y4ZJmUkA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108485197612535663486/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108485197612535663486/reviews');
SET @user_micko_kadija = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108485197612535663486/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sandra.', 'https://lh3.googleusercontent.com/a/ACg8ocJ7EveKMKz59LFUlqw2xtg1oIpAHrrEI5wH3lxSpchJov84Tw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105786473293261477919/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105786473293261477919/reviews');
SET @user_sandra = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105786473293261477919/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sirenina Slina', 'https://lh3.googleusercontent.com/a/ACg8ocJ7um2pU6_ok0N6uOfCTrfBa95cMbrQ4-2ntrJGk20gfwBVLQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112702403935789483414/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112702403935789483414/reviews');
SET @user_sirenina_slina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112702403935789483414/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ananije Nenezic', 'https://lh3.googleusercontent.com/a-/ALV-UjXATT5ZhSfDqRV7BkQKZhXFGM2sOat8y1QGchfYmgCPlmPbi0eD=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104487316775854409846/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104487316775854409846/reviews');
SET @user_ananije_nenezic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104487316775854409846/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Lazarevic', 'https://lh3.googleusercontent.com/a/ACg8ocLo9hrY-K5HcamjLrVyEt3Yr_A3B78RcpKa-jlJdV8cRCS_rw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101569533438907780643/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101569533438907780643/reviews');
SET @user_jovana_lazarevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101569533438907780643/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andrijana Misolic', 'https://lh3.googleusercontent.com/a/ACg8ocJ7UfCvUeEeuP7fz4VfCYlhdKxdMdvkO1FH_hP64IPJ4XqVaA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103624517733893333262/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103624517733893333262/reviews');
SET @user_andrijana_misolic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103624517733893333262/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'emira mavriq', 'https://lh3.googleusercontent.com/a/ACg8ocLX_0L30dz8orA7Rl_s3i2ogWjxTezU6lCe3fl_rxqEOHXQ-g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110676383078145179258/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110676383078145179258/reviews');
SET @user_emira_mavriq = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110676383078145179258/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Ljubić', 'https://lh3.googleusercontent.com/a-/ALV-UjXfWIBdVSyCgz-N_2q_SUqt_two84LVw2tFQ3wXkyQev_13nsEx=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112948840963862938273/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112948840963862938273/reviews');
SET @user_nikola_ljubi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112948840963862938273/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Miodrag Stankovic', 'https://lh3.googleusercontent.com/a/ACg8ocIFozNWaemIjc3JTCXdQp6rxfVc3Zc_6n5tqLTNrlIM2B6S0tk=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106489108004320171861/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106489108004320171861/reviews');
SET @user_miodrag_stankovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106489108004320171861/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Miljan Novakovic', 'https://lh3.googleusercontent.com/a/ACg8ocIvAIt1fe5JCvilX6YDtlWbhGuXwB6chEU-T8MgYxzLnmKhxA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103519366786141588547/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103519366786141588547/reviews');
SET @user_miljan_novakovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103519366786141588547/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Hana Olajic', 'https://lh3.googleusercontent.com/a/ACg8ocIWfrWT54D8ImC-mAmDTEip-gtPdG3x57Ug5AtiyDO43r7Irxk=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105539298031963503367/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105539298031963503367/reviews');
SET @user_hana_olajic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105539298031963503367/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Katarina Jovanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjV20CJhxM8FXGA0bziF_K13whLTBPSp6rqKiJ6ZnfpIx3CYtA4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101362048798009379872/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101362048798009379872/reviews');
SET @user_katarina_jovanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101362048798009379872/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ksenija Bozovic', 'https://lh3.googleusercontent.com/a/ACg8ocKX_h-BfWC_8ks3MlHyYEKZ-JXkF_psllhLziZbGrI0wOn7IQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116833145498068656594/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116833145498068656594/reviews');
SET @user_ksenija_bozovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116833145498068656594/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radomir Pejovic', 'https://lh3.googleusercontent.com/a-/ALV-UjW5tgCKtWVxqeeRkjS4pT7zre9O1bPVNqub5SVTjHU8Olz9JrLO7g=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108101469747496772502/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108101469747496772502/reviews');
SET @user_radomir_pejovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108101469747496772502/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tanja Tatar', 'https://lh3.googleusercontent.com/a-/ALV-UjUKb_Gk61JEBDv-S1C_Qv3_g3DGbIns_aLoEzav-MZMtd5MoQk=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115646599927667873634/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115646599927667873634/reviews');
SET @user_tanja_tatar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115646599927667873634/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Miljan Micunovic', 'https://lh3.googleusercontent.com/a/ACg8ocLK_9FlMcjmSLTTJ4UpEGffFS2W4sbyUdQ0Z4KIBUs0eXdUJA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109849479199739331778/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109849479199739331778/reviews');
SET @user_miljan_micunovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109849479199739331778/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_jevrem_bjelopavlic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twSWRVaEJkRXBSUnpjd01EQXlMVFZLVDNsRVNtYxAB',
    5, 'sr', '10/10',
    '10/10', '10/10', NULL, NULL, NULL, NULL,
    0, '2025-07-03 20:07:12'),

(@user_dragan_asanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSUR5M0tuSy1BRRAB',
    5, 'sr', 'Најбољи доктори',
    'Najbolji doktori', 'Најбољи доктори', NULL, NULL, NULL, NULL,
    1, '2021-02-27 22:39:35'),

(@user_jelena_saulic, @clinic_id, @doctor_miljan_micunovic, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT25jelZEaFRZamRmVkcxRGNWcEljVjgyU2twd1RXYxAB',
    5, 'bs', 'Neopisivo divno iskustvo i ordinacija za svaku preporuku. Od samog ulaska oseća se pažnja, toplina i profesionalizam. Osoblje ima neverovatnu sposobnost da umiri pacijenta, strpljivo i jasno objasni svaki korak i ne započinje intervenciju dok se ne uveri da je pacijent potpuno opušten i spreman.
Izuzetnu zahvalnost i pohvale upućujem doktoru Miljanu Mićunoviću, doktorici Ani i svim sestrama – njihova ljubaznost, nežnost i posvećenost su zaista na najvišem nivou. Tokom čitave intervencije vlada prijatna atmosfera, uz osmeh, šalu i osećaj potpune sigurnosti, tako da se zahvat gotovo i ne oseti.
Retko se sreće ovakav tim koji spaja vrhunsko znanje, ljudskost i iskrenu brigu o pacijentima. Od srca preporučujem svima, čak i onima koji imaju strah od zubara.',
    'Neopisivo divno iskustvo i ordinacija za svaku preporuku. Od samog ulaska oseća se pažnja, toplina i profesionalizam. Osoblje ima neverovatnu sposobnost da umiri pacijenta, strpljivo i jasno objasni svaki korak i ne započinje intervenciju dok se ne uveri da je pacijent potpuno opušten i spreman.
Izuzetnu zahvalnost i pohvale upućujem doktoru Miljanu Mićunoviću, doktorici Ani i svim sestrama – njihova ljubaznost, nežnost i posvećenost su zaista na najvišem nivou. Tokom čitave intervencije vlada prijatna atmosfera, uz osmeh, šalu i osećaj potpune sigurnosti, tako da se zahvat gotovo i ne oseti.
Retko se sreće ovakav tim koji spaja vrhunsko znanje, ljudskost i iskrenu brigu o pacijentima. Od srca preporučujem svima, čak i onima koji imaju strah od zubara.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-05 21:26:05'),

(@user_jelena_djurovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tsNVVubERjMWxRTlVOcFMxUlRTMVV3WW5GbFoxRRAB',
    5, 'en', 'I recently visited Mićunović Medical for dental treatment and was thoroughly impressed with the entire experience. The staff is exceptionally friendly, professional, and attentive, making sure every patient feels comfortable and welcome from the moment they arrive. The team works efficiently, explaining every step of the procedure and answering all my questions with patience and expertise. My treatment was completely painless and I felt genuinely cared for throughout the whole process. I highly recommend Mićunović Medical to anyone looking for top-quality care and outstanding service!',
    'Nedavno sam posetio Mićunović Medical radi lečenja zuba i bio sam potpuno impresioniran celokupnim iskustvom. Osoblje je izuzetno ljubazno, profesionalno i pažljivo, osiguravajući da se svaki pacijent oseća prijatno i dobrodošlo od trenutka kada stigne. Tim radi efikasno, objašnjavajući svaki korak procedure i odgovarajući na sva moja pitanja sa strpljenjem i stručnošću. Moj tretman je bio potpuno bezbolan i osećao sam se iskreno zbrinutim tokom celog procesa. Toplo preporučujem Mićunović Medical svima koji traže vrhunsku negu i izvanrednu uslugu!', 'Недавно сам посетио Мићуновић Медицал ради лечења зуба и био сам потпуно импресиониран целокупним искуством. Особље је изузетно љубазно, професионално и пажљиво, осигуравајући да се сваки пацијент осећа пријатно и добродошло од тренутка када стигне. Тим ради ефикасно, објашњавајући сваки корак процедуре и одговарајући на сва моја питања са стрпљењем и стручношћу. Мој третман је био потпуно безболан и осећао сам се искрено збринутим током целог процеса. Топло препоручујем Мићуновић Медицал свима који траже врхунску негу и изванредну услугу!', 'I recently visited Mićunović Medical for dental treatment and was thoroughly impressed with the entire experience. The staff is exceptionally friendly, professional, and attentive, making sure every patient feels comfortable and welcome from the moment they arrive. The team works efficiently, explaining every step of the procedure and answering all my questions with patience and expertise. My treatment was completely painless and I felt genuinely cared for throughout the whole process. I highly recommend Mićunović Medical to anyone looking for top-quality care and outstanding service!', NULL, NULL, NULL,
    0, '2025-10-10 07:16:00'),

(@user_rp_medical, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGblJUUlhMV055U25aS1FYRXlWVzlJVXpWUGJtYxAB',
    5, 'en', 'I recently had dental implants done at Mićunović Medical in Podgorica, and I can say with confidence that this clinic stands out in every aspect — from technology to patient care.',
    'Nedavno sam ugradio zubne implantate u Mićunović Medical u Podgorici i sa sigurnošću mogu reći da se ova klinika izdvaja u svakom pogledu – od tehnologije do nege pacijenata.', 'Недавно сам уградио зубне имплантате у Мићуновић Медицал у Подгорици и са сигурношћу могу рећи да се ова клиника издваја у сваком погледу – од технологије до неге пацијената.', 'I recently had dental implants done at Mićunović Medical in Podgorica, and I can say with confidence that this clinic stands out in every aspect — from technology to patient care.', NULL, NULL, NULL,
    1, '2025-10-09 15:41:12'),

(@user_ich_ich, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkeFdUZG9kVVJWVkZoZlRGQmFjVGxOWTNZNVNXYxAB',
    5, 'de', 'Obwohl ich extra von Wien nach Montenegro geflogen bin, um diese Klinik zu besuchen, wurden meine Erwartungen sogar übertroffen! ❤️ Ich hatte im Vorfeld viel Positives über die Klinik gehört und kann jetzt aus eigener Erfahrung sagen, dass sich die Reise absolut gelohnt hat. Vom ersten Moment an habe ich mich gut aufgehoben und professionell betreut gefühlt. Das gesamte Team war freundlich, herzlich und kompetent.
Ich bin sehr zufrieden und kann die Klinik von Herzen weiterempfehlen. Vielen Dank für die tolle Betreuung und die positive Erfahrung! ❤️',
    NULL, NULL, NULL, NULL, 'Obwohl ich extra von Wien nach Montenegro geflogen bin, um diese Klinik zu besuchen, wurden meine Erwartungen sogar übertroffen! ❤️ Ich hatte im Vorfeld viel Positives über die Klinik gehört und kann jetzt aus eigener Erfahrung sagen, dass sich die Reise absolut gelohnt hat. Vom ersten Moment an habe ich mich gut aufgehoben und professionell betreut gefühlt. Das gesamte Team war freundlich, herzlich und kompetent.
Ich bin sehr zufrieden und kann die Klinik von Herzen weiterempfehlen. Vielen Dank für die tolle Betreuung und die positive Erfahrung! ❤️', NULL,
    0, '2026-10-22 00:00:00'),

(@user_sara_micunovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwUlRIUXlZM0JNV0ZKbk9IVTJja1Z2Y21OVVJIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_tinasaljanin82, @clinic_id, @doctor_miljan_micunovic, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT21SUFVWQnhURmhVVVdkdFVVNWpPRXhKUTFGWlNYYxAB',
    5, 'en', 'Dr. Miljan Micunović and his entire team in Podgorica are truly amazing. I came from New York and had extensive full-mouth dental surgery and treatment with him, and I couldn’t be happier with the results. He is extremely professional, knowledgeable, patient, and made me feel comfortable through every step of such a big procedure.
One thing I really appreciated was how responsive they were. Anytime I had a question or any concern, they answered my messages very quickly and always made sure I was okay. That gave me so much peace of mind, especially coming from another country.
A very special thank you to Dr.Elizabeth , who helped Dr. Miljan throughout my treatment. She was incredibly kind, caring, helpful, and always there whenever I needed anything. The entire staff treated me with so much care and professionalism.
I’m extremely grateful to Dr. Miljan, and the whole team for everything they did for me. I would absolutely recommend them to anyone looking for exceptional dental and implant care in Podgorica, Montenegro—even if you’re traveling from New York like I did.',
    NULL, NULL, 'Dr. Miljan Micunović and his entire team in Podgorica are truly amazing. I came from New York and had extensive full-mouth dental surgery and treatment with him, and I couldn’t be happier with the results. He is extremely professional, knowledgeable, patient, and made me feel comfortable through every step of such a big procedure.
One thing I really appreciated was how responsive they were. Anytime I had a question or any concern, they answered my messages very quickly and always made sure I was okay. That gave me so much peace of mind, especially coming from another country.
A very special thank you to Dr.Elizabeth , who helped Dr. Miljan throughout my treatment. She was incredibly kind, caring, helpful, and always there whenever I needed anything. The entire staff treated me with so much care and professionalism.
I’m extremely grateful to Dr. Miljan, and the whole team for everything they did for me. I would absolutely recommend them to anyone looking for exceptional dental and implant care in Podgorica, Montenegro—even if you’re traveling from New York like I did.', NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_danko_djurisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT21RdFFUQlRhV1J0TTJZMVRUVkRTVWQ1UmxWdE1tYxAB',
    1, 'bs', 'Raspad sistema. Radio mi je tri plombe od kojih su dvije opale nakon 15 dana.',
    'Raspad sistema. Radio mi je tri plombe od kojih su dvije opale nakon 15 dana.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_sandra_radevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT25Kck5WZGFOakpyUmpBd2MwdzJTWFIwUW5sTFRFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_dado_rakocevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT2poamVrSlBUSEZRWjJWaVVrbHFPSFJtT1hBd1NHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_sneza_sr, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT21wb1ozUkhTVkpDZEd4Q0xUbFdTVkJHTVRWMFZVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_andrijana_sanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT25Kb2EyRm1SSFZIVVVoU1ZXRk1PV1poWVU5NlRHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_emica_brajovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tFM09FVktNMWQzU3pZMlQyVjNlbFEzYzJkaWFYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_predrag, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kUVdsRTRVREpwTmtaeGNTMXZhRnByVjFNM1lYYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_beni_kajtazi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tGNlZWVjBSMnMwV0VKNmQxTkpjbVZsU3psWWNVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_katie_costello, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT20xeGRGRk5ZblJWZVc5NFFtNWFUek5KTmw5Q1NVRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_sophie_marie, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tJdFFWODFZbEIxVFU5VlRWWjZRV0U0VkZsU04xRRAB',
    1, 'en', 'Very unprofessional dentist. Terrible communication. Save your precious time and avoid.',
    NULL, NULL, 'Very unprofessional dentist. Terrible communication. Save your precious time and avoid.', NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_nikola_micunovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT2sxZmVrRjNVbXB5Wm1wc00zWnRYemMyV21oc1EyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_bojan_bozovic, @clinic_id, @doctor_nenad_mracevic, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KWk1tbzRWREJTUVdKaE0wTkZOVmxZYXpaWVMzYxAB',
    5, 'hr', 'Odličana ordinacija. Posebne pohvale za Dr. Nenada Mracevića, vrlo stručan i ljubazan.',
    'Odličana ordinacija. Posebne pohvale za Dr. Nenada Mracevića, vrlo stručan i ljubazan.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_mastalica_01, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT21oV1NWVkZTMWRyV0hOb2NrTnNOVzV1VERKeE9HYxAB',
    5, 'hr', 'The Best 🤗 Ljubazni, profesionalni.Sve preporuke.',
    'The Best 🤗 Ljubazni, profesionalni.Sve preporuke.', NULL, NULL, NULL, NULL, NULL,
    1, '2025-10-29 00:00:00'),

(@user_ilija_kopitovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT21OeVJtbHpVbE5aUjE5clFYZG1NRTQ0WDFwd1NWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_juan_muqbel, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT25rNFdrWjVhazlXZDI5SWNtWkdTMll6ZFhGRGNsRRAB',
    5, 'en', 'I travelled all the way from the UK to have my dental treatment here, and I couldn’t be happier with my experience! The team was incredibly friendly, professional, and attentive—making me feel welcome from the very first visit. They understood my tight schedule as a traveller and ensured quick, efficient service without compromising on quality.

On top of the excellent care, I even got to enjoy some sunshine during my trip—a perfect bonus! The pricing was also very competitive compared to what I’d find back home.

I highly recommend this clinic to anyone, especially those considering dental tourism. Outstanding service, skilled professionals, and a smooth, hassle-free experience. 10/10!"**
Thanks',
    NULL, NULL, 'I travelled all the way from the UK to have my dental treatment here, and I couldn’t be happier with my experience! The team was incredibly friendly, professional, and attentive—making me feel welcome from the very first visit. They understood my tight schedule as a traveller and ensured quick, efficient service without compromising on quality.

On top of the excellent care, I even got to enjoy some sunshine during my trip—a perfect bonus! The pricing was also very competitive compared to what I’d find back home.

I highly recommend this clinic to anyone, especially those considering dental tourism. Outstanding service, skilled professionals, and a smooth, hassle-free experience. 10/10!"**
Thanks', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_patrik_paljusevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/Ci9DQUlRQUNvZENodHljRjlvT21WVVZXYzROSGRyUjBwRVVIZzJhVGw2V21kd1EyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_filips, @clinic_id, @doctor_miljan_micunovic, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnTURveDRXRGJBEAE',
    5, 'en', 'I\'ve had two impacted wisdom teeth:

First one was fully horizontal - extraction was done surgically, no pain. They took care of me with checkups after the procedure, 10/10 experience and communication.

Second one was angled upwards, before the procedure, they analysed the possibility of extracting it normally(without surgical intervention) - and they did it successfully. So my recovery was much faster, and the procedure is safer.

Very happy with my surgeon Miljan Mićunović and the staff with him. Feel free to come to them, you will be in safe hands (coming from me who was always afraid of dentistry)',
    NULL, NULL, 'I\'ve had two impacted wisdom teeth:

First one was fully horizontal - extraction was done surgically, no pain. They took care of me with checkups after the procedure, 10/10 experience and communication.

Second one was angled upwards, before the procedure, they analysed the possibility of extracting it normally(without surgical intervention) - and they did it successfully. So my recovery was much faster, and the procedure is safer.

Very happy with my surgeon Miljan Mićunović and the staff with him. Feel free to come to them, you will be in safe hands (coming from me who was always afraid of dentistry)', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ljiljana_adi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnTUNvcXBIekt3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_stefani_peji, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnTUNncEt6SUN3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_stevan_nikolic, @clinic_id, @doctor_miljan_micunovic, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnTURBLW9ucHpnRRAB',
    5, 'de', 'Wir sind aus der Schweiz nach Podgorica gereist und hatten das große Vergnügen, Dr. Miljan Micunovic und sein wunderbares Team kennenzulernen. Vom ersten Moment an wurden wir herzlich empfangen und fühlten uns sofort in besten Händen. Dr. Micunovic ist ein äußerst kompetenter und einfühlsamer Zahnarzt, der sich Zeit nimmt, um alle Fragen zu beantworten und eine individuelle Behandlung anzubieten. Die Praxis ist modern ausgestattet und strahlt eine angenehme, vertrauensvolle Atmosphäre aus.

Das gesamte Team im Micunovic Medical ist einfach top – freundlich, professionell und stets bemüht, den Patienten das Gefühl zu geben, gut aufgehoben zu sein. Wir sind absolut begeistert von der Qualität der Behandlung und der Betreuung, die wir erhalten haben. Unsere Erwartungen wurden nicht nur erfüllt, sondern weit übertroffen. Wir können Dr. Micunovic und sein Team wärmstens empfehlen!',
    NULL, NULL, NULL, NULL, 'Wir sind aus der Schweiz nach Podgorica gereist und hatten das große Vergnügen, Dr. Miljan Micunovic und sein wunderbares Team kennenzulernen. Vom ersten Moment an wurden wir herzlich empfangen und fühlten uns sofort in besten Händen. Dr. Micunovic ist ein äußerst kompetenter und einfühlsamer Zahnarzt, der sich Zeit nimmt, um alle Fragen zu beantworten und eine individuelle Behandlung anzubieten. Die Praxis ist modern ausgestattet und strahlt eine angenehme, vertrauensvolle Atmosphäre aus.

Das gesamte Team im Micunovic Medical ist einfach top – freundlich, professionell und stets bemüht, den Patienten das Gefühl zu geben, gut aufgehoben zu sein. Wir sind absolut begeistert von der Qualität der Behandlung und der Betreuung, die wir erhalten haben. Unsere Erwartungen wurden nicht nur erfüllt, sondern weit übertroffen. Wir können Dr. Micunovic und sein Team wärmstens empfehlen!', NULL,
    0, '2025-10-29 00:00:00'),

(@user_ante_alduk, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSURfbVlDSXJ3RRAB',
    5, 'hr', 'Najbolja ekipa i sve pohvale',
    'Najbolja ekipa i sve pohvale', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jasmina_dasic, @clinic_id, @doctor_miljan_micunovic, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSUR2c1pYa1RnEAE',
    5, 'en', 'I have been a regular patient for the last 15 years. I am very satisfied with them.
Dr. Miljan and the entire team do their work impeccably and are very dedicated to it.',
    NULL, NULL, 'I have been a regular patient for the last 15 years. I am very satisfied with them.
Dr. Miljan and the entire team do their work impeccably and are very dedicated to it.', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_veljko_zlatianin, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSUNQZy12ejJ3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_marijo_kapular, @clinic_id, @doctor_miljan_micunovic, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSUNYNFA3NVp3EAE',
    5, 'hr', 'Pohvale za dr. Miljana i cijelo osoblje klinike. Sve preporuke onima koji se informiraju.',
    'Pohvale za dr. Miljana i cijelo osoblje klinike. Sve preporuke onima koji se informiraju.', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_mar, @clinic_id, @doctor_miljan_micunovic, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSUNYNE83emRREAE',
    5, 'bs', 'Dr. Miljan je veliki gospodin. Lp',
    'Dr. Miljan je veliki gospodin. Lp', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_inna_l, @clinic_id, @doctor_medina_tuzovic, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSURubzRTYlZnEAE',
    5, 'ru', 'Ходим с мужем сюда по мере необходимости . Отличная стоматология , сервис хороший и хорошие специалисты. Доктор Medina T. отличный специалист,мы очень довольны.',
    NULL, NULL, NULL, 'Ходим с мужем сюда по мере необходимости . Отличная стоматология , сервис хороший и хорошие специалисты. Доктор Medina T. отличный специалист,мы очень довольны.', NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_bakala_karic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSURuOW8tYzlBRRAB',
    5, 'bs', 'Vise od 2 decenije sam pacijent Dr Pera,covek koji mi je pokazao da stomatologija nije bauk,da odlazak kod stomatologa moze proci i uz osmeh.Odgvornost ,postovanje pacijenta ,gde novac nije primarna stvar
retko danas u medicini mozete videti.Zelim da traju i dalje ,jer zaista su bez svake konkurencije.',
    'Vise od 2 decenije sam pacijent Dr Pera,covek koji mi je pokazao da stomatologija nije bauk,da odlazak kod stomatologa moze proci i uz osmeh.Odgvornost ,postovanje pacijenta ,gde novac nije primarna stvar
retko danas u medicini mozete videti.Zelim da traju i dalje ,jer zaista su bez svake konkurencije.', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_natalija_markovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSURudk15YmhBRRAB',
    5, 'en', 'Great clinic! I’m very satisfied with doctors and staff also everything is new, very well equipped and clean! All recommendations!👍👍👍',
    NULL, NULL, 'Great clinic! I’m very satisfied with doctors and staff also everything is new, very well equipped and clean! All recommendations!👍👍👍', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_medina_mehmedovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSURudk1UVTB3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_marija_cetkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSURua0xmejRnRRAB',
    5, 'bs', 'Na svetskom nivou, klinika,oprema i izuzetan kolektiv !!!👌🫶💯✨💫',
    'Na svetskom nivou, klinika,oprema i izuzetan kolektiv !!!👌🫶💯✨💫', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_theo_known_as_ellen, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSUN6MDV5Wl9nRRAB',
    4, 'en', 'The doctors are true masters, they were so attentive and careful, they explained everything they were doing and always told me if I was not gonna feel anything or it’s gonna be unpleasant before every procedure and kept making sure I felt good. And it’s all in English which I appreciate a lot. For me being a naturally very anxious person this experience was top-notch comfortable.
The clinic itself is brand new and sparkling clean, the equipment is very modern.

The only thing is that it was a bit disorganised, I had to come three times to get braces removed the first one the doctor didn’t show up, the second time they had a look and booked me for the third appointment incl braces removal, an xray and a cleaning, and during the third time another doctor wanted to reschedule since they didn’t have some of the tools and didn’t expect to remove braces, finally found the way and removed the braces but didn’t do the xray, the cleaning with another doctor that day wasn’t done properly as I discovered only later when I got home.',
    NULL, NULL, 'The doctors are true masters, they were so attentive and careful, they explained everything they were doing and always told me if I was not gonna feel anything or it’s gonna be unpleasant before every procedure and kept making sure I felt good. And it’s all in English which I appreciate a lot. For me being a naturally very anxious person this experience was top-notch comfortable.
The clinic itself is brand new and sparkling clean, the equipment is very modern.

The only thing is that it was a bit disorganised, I had to come three times to get braces removed the first one the doctor didn’t show up, the second time they had a look and booked me for the third appointment incl braces removal, an xray and a cleaning, and during the third time another doctor wanted to reschedule since they didn’t have some of the tools and didn’t expect to remove braces, finally found the way and removed the braces but didn’t do the xray, the cleaning with another doctor that day wasn’t done properly as I discovered only later when I got home.', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_lela, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSURyc2ZMUHBBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_sara_micunovic_2, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSUMxLWJMY0VBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_maras_dejan, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSURMdVBfaFBnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_jelena_mugosa, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSURMMkxxcThRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_angie_g, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSURMbU5laFVnEAE',
    5, 'bs', 'Najbolji doktori, ljubazne sestre i administrativne radnice, sve preporuke 🙂',
    'Najbolji doktori, ljubazne sestre i administrativne radnice, sve preporuke 🙂', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_zoka_rasovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSURMbUlmWDhBRRAB',
    5, 'hr', 'Najbolji doktori i ljubazno osoblje. Sve preporuke! ⭐️⭐️⭐️⭐️⭐️',
    'Najbolji doktori i ljubazno osoblje. Sve preporuke! ⭐️⭐️⭐️⭐️⭐️', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_tijana_mugosa, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSURMbUx2MnlnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_nenad_mracevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSURMbU52RnZ3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_danijela_dzakovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSUNUM05mRmVnEAE',
    5, 'bs', 'Najbolji tim,  od medicinske sestre do doktora,uvjek ispostovani za sve ,dr Miljan a i dr Medina (divna ,strpljiva brza sa toliko paznje i ljubavi prilazi djeci....).',
    'Najbolji tim,  od medicinske sestre do doktora,uvjek ispostovani za sve ,dr Miljan a i dr Medina (divna ,strpljiva brza sa toliko paznje i ljubavi prilazi djeci....).', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_ana_joksimovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSUNUakkyYmZBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_andjelija_cavic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSUNEOHJUamxBRRAB',
    5, 'bs', 'Odlicno iskustvo. Savremena tehnika, doktori dobri, ljubazni i komunikativni. Nisu alavi na pare! Sve u svemu svaka preporuka!!!',
    'Odlicno iskustvo. Savremena tehnika, doktori dobri, ljubazni i komunikativni. Nisu alavi na pare! Sve u svemu svaka preporuka!!!', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_tomislav_jerat, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSUQxME0tUVh3EAE',
    5, 'bs', 'Dosli smo iz Splita, odusevljeni smo uslugom i krajnjim rezultatom. Preporuka za cijeli tim! Svaka cast',
    'Dosli smo iz Splita, odusevljeni smo uslugom i krajnjim rezultatom. Preporuka za cijeli tim! Svaka cast', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_nikola_djuranovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSUMxOTdTZFFnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_roman_slingov, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSURsM1p1azl3RRAB',
    5, 'en', 'Best dentistry I’v been going to for the decades.',
    NULL, NULL, 'Best dentistry I’v been going to for the decades.', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_miljan_miunovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSUNsdC1fUHh3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_boskom_29, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSUNsdWFtb3d3RRAB',
    5, 'hr', 'Najbolji!
Svaka preporuka za Micunovic Medical tim! :)',
    'Najbolji!
Svaka preporuka za Micunovic Medical tim! :)', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_miki_dragicevic, @clinic_id, @doctor_miljan_micunovic, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSURwOUo2S2RBEAE',
    5, 'bs', 'Jednostavno dr Miljan Micunovic je dragulj stomatologije sto se tice najzahtjevnijih zahvata, a sto je najvaznije potpuno bezbolno. Mislim da je Crna Gora pocastvovana sto ordiniraju u Podgorici. Iz  licnog iskustva ne postoji te preporuke na bilo kojeg stomatologa koji bi mi mogao i prici po znanju, struci, pristupu, profesionalnosti dr. Miljanu Micunovicu. Miki Dragicevic zahvalan dr. Miljanu Micunovicu i timu doktora i da ne zaboravim sve rijeci hvale za anesteziologa. Jednostavno mislio sam da nikad necu pobijediti strah od zubara ali posle njihove intervencije strah je nestao.',
    'Jednostavno dr Miljan Micunovic je dragulj stomatologije sto se tice najzahtjevnijih zahvata, a sto je najvaznije potpuno bezbolno. Mislim da je Crna Gora pocastvovana sto ordiniraju u Podgorici. Iz  licnog iskustva ne postoji te preporuke na bilo kojeg stomatologa koji bi mi mogao i prici po znanju, struci, pristupu, profesionalnosti dr. Miljanu Micunovicu. Miki Dragicevic zahvalan dr. Miljanu Micunovicu i timu doktora i da ne zaboravim sve rijeci hvale za anesteziologa. Jednostavno mislio sam da nikad necu pobijediti strah od zubara ali posle njihove intervencije strah je nestao.', NULL, NULL, NULL, NULL, NULL,
    2, '2023-10-29 00:00:00'),

(@user_ana_vukovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSUR4OU5tMTlnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_dado_pejuskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSUNSeTZMSGZBEAE',
    5, 'hr', 'Samo riječi hvale, za sve zaposlene...',
    'Samo riječi hvale, za sve zaposlene...', NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_nikica_kenneth, @clinic_id, @doctor_miljan_micunovic, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSURCdXV5alB3EAE',
    5, 'fr', 'Un excellent accompagnement   au niveau de conseils, de diagnostic  et de suivi. Malgré la complexité de ma situation dentaire, Dr Miljan Micunivic a réussi à répondre à mes exigences  contrairement à ses autres collègues dentistes. Doté d‘une nature calme et patiente, Dr Micunovic a su être à  mon écoute en respectant mes besoins et mes demandes.  De meme , un grand Merci également  à son équipe pour leur  professionnalisme et leur  humanisme. Je  recommande  vivement le cabinet de dr Miljan Micunovic!,,',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_ned_vuk, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSUQyc09PLUZREAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_marko_pavlicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSURXX3AzMVFnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_nikola_velimirovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSUNtMDk3dnZnRRAB',
    1, 'hr', 'najgori zubar ikad. vise me bole zubi posle nego pre',
    'najgori zubar ikad. vise me bole zubi posle nego pre', NULL, NULL, NULL, NULL, NULL,
    2, '2022-10-29 00:00:00'),

(@user_danijela_radenovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ2NUtmZFl3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_vedran_lunic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSUNxcjdmLUtREAE',
    2, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_milena_miranovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSUNxNHBuOGxBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_vladan_stojovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSURDOXZQRDd3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_micko_kadija, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSURzdVlta0xBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_sandra, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSURNbWNlSmVREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_sirenina_slina, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSUQwZ0pXR2pBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_ananije_nenezic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSURZai15amdBRRAB',
    5, 'en', 'Excellent dentists!',
    NULL, NULL, 'Excellent dentists!', NULL, NULL, NULL,
    2, '2019-10-29 00:00:00'),

(@user_jovana_lazarevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSURRbnZTcGRBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_andrijana_misolic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSUN3aGNyUUlREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_emira_mavriq, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSUNBN19tWjlBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2017-10-29 00:00:00'),

(@user_nikola_ljubi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSURRMHJDUUhBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2016-10-29 00:00:00'),

(@user_miodrag_stankovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSURRMHR1MnlBRRAB',
    5, 'bs', 'Odlicni!',
    'Odlicni!', NULL, NULL, NULL, NULL, NULL,
    0, '2016-10-29 00:00:00'),

(@user_miljan_novakovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSURRcDVPa1J3EAE',
    5, 'bs', 'Savrseno!!!',
    'Savrseno!!!', NULL, NULL, NULL, NULL, NULL,
    0, '2014-10-29 00:00:00'),

(@user_hana_olajic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSUN3amQ2TmtRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2014-10-29 00:00:00'),

(@user_katarina_jovanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSUN3cElHOXdRRRAB',
    5, 'hr', 'Strucno i kvalitetno! Najbolji ste!',
    'Strucno i kvalitetno! Najbolji ste!', NULL, NULL, NULL, NULL, NULL,
    1, '2014-10-29 00:00:00'),

(@user_ksenija_bozovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSUNRaTVUMmZREAE',
    5, 'hr', 'Profesionalnost,strucnost i ljubaznost!',
    'Profesionalnost,strucnost i ljubaznost!', NULL, NULL, NULL, NULL, NULL,
    0, '2014-10-29 00:00:00'),

(@user_radomir_pejovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSUN3N3FtLXFBRRAB',
    5, 'hr', 'Doktor Pero i tim za zube čini magiju i umjetičko djelo.

Rade Rapido Radares',
    'Doktor Pero i tim za zube čini magiju i umjetičko djelo.

Rade Rapido Radares', NULL, NULL, NULL, NULL, NULL,
    1, '2014-10-29 00:00:00'),

(@user_tanja_tatar, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChdDSUhNMG9nS0VJQ0FnSUNBd2VYNTN3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2014-10-29 00:00:00'),

(@user_miljan_micunovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1VxH0hTrTRMRyy8OYWPH7kU/reviews/ChZDSUhNMG9nS0VJQ0FnSURneXFPa0lnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2013-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
