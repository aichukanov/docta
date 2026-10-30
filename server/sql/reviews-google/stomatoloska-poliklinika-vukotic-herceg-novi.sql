-- Insert Google Maps reviews for Stomatološka Poliklinika "Vukotić"
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/stomatoloska-poliklinika-vukotic-herceg-novi.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'stomatoloska-poliklinika-vukotic-herceg-novi');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_ivan_vukotic = (SELECT id FROM doctors WHERE slug = 'ivan-vukotic');
SET @doctor_mladen_vukotic = (SELECT id FROM doctors WHERE slug = 'mladen-vukotic');
SET @doctor_tatjana_vukotic = (SELECT id FROM doctors WHERE slug = 'tatjana-vukotic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ognjen Vujicic', 'https://lh3.googleusercontent.com/a-/ALV-UjV1DJmy5yMtMIqAJ9yZxo34A95asbSzI_bvec_5XkV6dV7_gN0=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/110447892644442405070/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110447892644442405070/reviews');
SET @user_ognjen_vujicic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110447892644442405070/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksey Zimin', 'https://lh3.googleusercontent.com/a-/ALV-UjWQsuJpWIVzOJp_dK96x3CbUL1kSMQE5SvfKSljVy__MmeVvzNdcw=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/113554881157137233528/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113554881157137233528/reviews');
SET @user_aleksey_zimin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113554881157137233528/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Vukcevic', 'https://lh3.googleusercontent.com/a-/ALV-UjXkkLa5zxatr04xKmYwmq5KYgMHsLsGzlROmZWnz6_w8CaP2XU=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/113124746182941057666/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113124746182941057666/reviews');
SET @user_luka_vukcevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113124746182941057666/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ena Jovanov', 'https://lh3.googleusercontent.com/a/ACg8ocKPvuip_z9I9_ey248jjxR0jr7YVIKO3mGszcz429NvH4EfIg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/117822311417314093863/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117822311417314093863/reviews');
SET @user_ena_jovanov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117822311417314093863/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Miletic Demmel', 'https://lh3.googleusercontent.com/a-/ALV-UjUzHbUnYNrZMo1_AttKn_2EL71yfefdq7dghCzVCDlX7pTo7lMaFw=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/112566814418582581103/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112566814418582581103/reviews');
SET @user_ivana_miletic_demmel = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112566814418582581103/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Slobodan Vukotic', 'https://lh3.googleusercontent.com/a-/ALV-UjV8qpByt4QvrWo_UPuI7CSUNuAoCFWhDmS9F4gZcmhz4Y7TuNc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115981736924039535892/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115981736924039535892/reviews');
SET @user_slobodan_vukotic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115981736924039535892/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dobrica Antovska', 'https://lh3.googleusercontent.com/a/ACg8ocLw0jtjtsodRXy1DN4NF5aKkjiRgVd1kwlbsd5_IRYofcv8yA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109370997986156693638/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109370997986156693638/reviews');
SET @user_dobrica_antovska = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109370997986156693638/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milana Kovacevic', 'https://lh3.googleusercontent.com/a/ACg8ocIma-u2KFXSDHYXbfG2H5HQ-Xnny4IFllJ3spYGS_l54RZXaA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114017625266980655314/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114017625266980655314/reviews');
SET @user_milana_kovacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114017625266980655314/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Svetozar Ivanović', 'https://lh3.googleusercontent.com/a/ACg8ocLrNfuT3yU9H7UMTKylRraYQKc7a-VrhmSYtV29tLCa9R5c=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116657429270000357390/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116657429270000357390/reviews');
SET @user_svetozar_ivanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116657429270000357390/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Michele Sarlat', 'https://lh3.googleusercontent.com/a/ACg8ocIdFUhs4Y_XoBPlwjSjRICmfqC6d5CyWkNxF9Ol4DdrL9lRsQC6=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102785335951795363059/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102785335951795363059/reviews');
SET @user_michele_sarlat = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102785335951795363059/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'L', 'https://lh3.googleusercontent.com/a/ACg8ocJ-tDkCjGr_6MliQD5ag77AWhdW-uW5XiDeJSSywgwz0h2yUQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108063693225288131994/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108063693225288131994/reviews');
SET @user_user_108063693225288131994 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108063693225288131994/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'nbsvtrhcq', 'https://lh3.googleusercontent.com/a-/ALV-UjUUrncmNlRiaQgwdtj0216QFlIBoCne-vmHLas9IDHwyPp7T4lc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114415285453030555859/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114415285453030555859/reviews');
SET @user_nbsvtrhcq = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114415285453030555859/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tijana', 'https://lh3.googleusercontent.com/a/ACg8ocLyFkYxnL16aifUb4C94AMYaCAhL9GVlZnd2DlvpzouEODD5lA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105776095475147835718/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105776095475147835718/reviews');
SET @user_tijana = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105776095475147835718/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Avramovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUnRlGA11K1CTqaDpndmtBBVREHEBHBP3_uSQbTqHVY0kZckPmh8A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108352222763549801930/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108352222763549801930/reviews');
SET @user_jelena_avramovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108352222763549801930/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Verica Matovic', 'https://lh3.googleusercontent.com/a-/ALV-UjV0CAzmYXMG3FZG85aLqXqGkh0C85BQ90O0VqLpum6KaSM-NgWJ8w=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112564295600174653389/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112564295600174653389/reviews');
SET @user_verica_matovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112564295600174653389/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Biljana Bogicevic', 'https://lh3.googleusercontent.com/a-/ALV-UjU21PZLK2PGQPnAwsmuqEEC6gZXBrBWknUM9HG0veCoZn9JEkgh=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106386225982338145320/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106386225982338145320/reviews');
SET @user_biljana_bogicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106386225982338145320/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Barry', 'https://lh3.googleusercontent.com/a/ACg8ocJTLlDDz4UjeoKihEIpsJ1rdoJ9kSUxEkhK5wWRvcJ1P4DESA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116403862627792767989/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116403862627792767989/reviews');
SET @user_barry = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116403862627792767989/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'đoxi', 'https://lh3.googleusercontent.com/a-/ALV-UjXZMw1TZ6F1ibxyRFqDQQ2fAqexNBP_1eTz_btotNVyInowjGUT=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116378657742283014152/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116378657742283014152/reviews');
SET @user_oxi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116378657742283014152/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja Antic', 'https://lh3.googleusercontent.com/a-/ALV-UjWzg3RG4Zo-qoCQ_RYsz7sNZP-sPuSWPr0dcaDOK6fU0KhQ7v9G=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114442778647346163536/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114442778647346163536/reviews');
SET @user_sanja_antic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114442778647346163536/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zeljko Zack Scepanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXH9i0jqIJoa3LxcpAwmtIdCIWqHOQzbgzpDUpJ6Pp-tgmyQRs=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116212019504669792022/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116212019504669792022/reviews');
SET @user_zeljko_zack_scepanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116212019504669792022/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Yevgeniy Muratshayev', 'https://lh3.googleusercontent.com/a-/ALV-UjWjJFc2jkrX2SjN7W3QdIx1bc6rKv0Hpi9MFhaKJGnNKkETl_PbIA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116221210488037644178/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116221210488037644178/reviews');
SET @user_yevgeniy_muratshayev = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116221210488037644178/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mato DJURANOVIC', 'https://lh3.googleusercontent.com/a-/ALV-UjWZpZKdX3m-ysB_LvgPuEikhtYbpq79OqU9ZSUE8kawk1y4PnAu=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114071643746344899619/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114071643746344899619/reviews');
SET @user_mato_djuranovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114071643746344899619/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vasilije Golubin (Vasilije Golubin)', 'https://lh3.googleusercontent.com/a-/ALV-UjV5GXcJAzoGotQbHSEsug6sby_p3PMFQ4oMH9BAhOwGqZQAaFMc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107711161742079370384/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107711161742079370384/reviews');
SET @user_vasilije_golubin_vasilije_golubin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107711161742079370384/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Igor 5 6 91', 'https://lh3.googleusercontent.com/a-/ALV-UjV9jCpr0RXvyzXcKGrxWzzt6xKLBIsAxFfsawJwPSIVibnJLtMO=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104696585145881277283/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104696585145881277283/reviews');
SET @user_igor_5_6_91 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104696585145881277283/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vlaho Mihočević', 'https://lh3.googleusercontent.com/a-/ALV-UjXG__LnZOpdYmaQSFwJwUF2FvJHIZb5U5K2OlzW2qRd7iMu7J4RRQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100845918134270090592/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100845918134270090592/reviews');
SET @user_vlaho_mihoevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100845918134270090592/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'B. W. A 16.1', 'https://lh3.googleusercontent.com/a/ACg8ocI5L55_oKGHaAABa-8acdtCXUig9C-hIZ-VdHjmtzKXUuiLjA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107515470690069389675/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107515470690069389675/reviews');
SET @user_b_w_a_161 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107515470690069389675/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tatiana P', 'https://lh3.googleusercontent.com/a/ACg8ocJ0CM58ISWC1D6iaVWh62HrzVP9oxH3PQE4aKI5lwm-wqm9Vg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101523540408783393819/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101523540408783393819/reviews');
SET @user_tatiana_p = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101523540408783393819/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Wim Baeten', 'https://lh3.googleusercontent.com/a-/ALV-UjWAjifitaS2ygjUzudRfsaoEa5W4GQPxw86bXdBAN5xEon2iIo=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102654382362855490881/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102654382362855490881/reviews');
SET @user_wim_baeten = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102654382362855490881/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Tmusic', 'https://lh3.googleusercontent.com/a/ACg8ocI8BCgDOwt3GnuWi5RFUbHhwjx9-8Bo_g8kMLVPzEd7uq5l76Y=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113273505619408259646/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113273505619408259646/reviews');
SET @user_marija_tmusic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113273505619408259646/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Julija Krutalevica', 'https://lh3.googleusercontent.com/a-/ALV-UjVze3oOzFnoTbK7fj6HDZyXdcEw2To1um4wuNunsSrsC8KDYpl2=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112359772573339713552/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112359772573339713552/reviews');
SET @user_julija_krutalevica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112359772573339713552/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pedja Bozovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUeXCoThGB3LOteiCXewMyL_Xvv9S1eYBuIg3XL7Hs-SBB38bI=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115814245426727605323/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115814245426727605323/reviews');
SET @user_pedja_bozovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115814245426727605323/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Hadzi Luka Krivokapić', 'https://lh3.googleusercontent.com/a-/ALV-UjUgHwnwQLVe5tyQ5a3GoccRbkEuRsIs9UPOS-kJnWmsshfMHpw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102580047395817825578/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102580047395817825578/reviews');
SET @user_hadzi_luka_krivokapi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102580047395817825578/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Геннадий Александров', 'https://lh3.googleusercontent.com/a/ACg8ocKKopLf7c5bOnmOldgQ4kJutXQhoDdCIsurDE1E4FDP7yPZDKE0=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113074588618416813652/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113074588618416813652/reviews');
SET @user_gennadiy_aleksandrov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113074588618416813652/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Katica Bjelokosic', 'https://lh3.googleusercontent.com/a-/ALV-UjWx1mq94FcPdJvQ03TEreZqLxjgnAYNeyfZnW5tPlZDuzdQIGs=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109439895870351702379/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109439895870351702379/reviews');
SET @user_katica_bjelokosic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109439895870351702379/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_ognjen_vujicic, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VJQ0FnSUROLXJLRld3EAE',
    1, 'bs', 'Nakon sto mi je dio zuba dvojke pukao javio sam se ordinaciji Vukotic. Situacija je bila prilicno hitna jer sam u gradu bio na svega par dana, a na kraju cak i produzio ostanak kako bi doktor stigao da rijesi problem. Dr. Ivan je pogledao zub i rekao da je zub pokvaren, da je kvar dubok i da je potrebno odmah izvaditi zivac - naglasicu da me zub nikada nije zabolio, sto sam mu i rekao, jer vadjenje zivca obicno nije prvo rjesenje. Medjutim, doktor je izvadio zivac, stavio lijek u zub i zakazao termin za dodatno punjenje i plombiranje. Prilikom ponovnog dolaska doktoru, on je pokusao da plombira zub, medjutim nije uspio jer su desni pocele da mi krvare, te tako nestrpljiv i nervozan rekao da on to ne moze da uradi, ponovo mi stavio lijek i rekao i da se vratim kada mi se desni smire. Tada vec nisam imao vremena da dodatno produzavam ostanak u gradu koji sam vec produzio zbog njegove procjene problema, te ga pitao da li moze nekako, bilo kako da mi zavrsi zub da ne idem slomljenog i izbusenog zuba, na sta mi je on odgovorio da to sad niko ne moze da mi zavrsi, da nadjem nekoga u drugom gradu, kao i da bolje perem zube i poslao me kuci odvaljene dvojke. Da li je moguce da neko ko ima toliko godina iskustva ne moze da procjeni prije nego sto se upusti da radi popravku da moze da se desi nekakav slican problem kao krvarenje desni i da na tako neodgovaran nacin NE ZAVRSI posao. Dva dana nakon toga sam posao u drugu ordinaciju gdje mi je doktor stavio plombu bez ikakvih problema i krvarenja.
Jedino pozitivno iskustvo sa ordinacijom Vukotic je doktorka Tatjana koja me prvobitno primila, bila veoma ljubazna i uputila me na doktora Ivana koji bi trebao biti specijalizovan za ovu vrstu problema.',
    'Nakon što mi je polomio dio drugog zuba, obratio sam se ordinaciji Vukotić. Situacija je bila prilično hitna jer sam bio u gradu samo nekoliko dana, a na kraju sam čak i produžio boravak kako bi lekar stigao da reši problem. dr. Ivan je pogledao zub i rekao da je zub truo, da je karijes dubok i da je potrebno hitno vaditi nerv – naglašavam da me zub nikada nije povredio, što sam mu i rekao, jer vađenje nerva obično nije prvo rešenje. Međutim, doktor je izvadio zub, stavio lek u zub i zakazao termin za dodatno plombiranje i plombiranje. Kada sam ponovo došla kod doktora, pokušao je da popuni zub, ali nije uspeo jer su mi počele krvariti desni, pa je nestrpljiv i nervozan rekao da ne može, ponovo mi je stavio lek i rekao da se vratim kada mi se desni smire. Tada nisam imao vremena da dodatno produžim svoj boravak u gradu, koji sam već produžio zbog njegove procene problema, pa sam ga pitao da li može nekako, na bilo koji način, da mi završi zub da ne bih morao da odem sa polomljenim i izbušenim zubom, na šta mi je on odgovorio da niko ne može da mi to sada završi, da nađem nekog u drugom gradu i da me pošalje u neki bolji grad, razred. Da li je moguće da neko sa toliko godina iskustva ne može da proceni pre nego što počne da radi popravku da može doći do nekog sličnog problema kao što je krvarenje desni i da na tako neprikladan način NE ZAVRŠI posao? Dva dana nakon toga otišao sam u drugu ordinaciju gde mi je doktor stavio plombu u zub bez problema i krvarenja.
Jedino pozitivno iskustvo sa ordinacijom Vukotić bila je dr Tatjana, koja me je u početku primila, bila veoma ljubazna i uputila me kod dr Ivana, koji bi trebalo da se specijalizuje za ovu vrstu problema.', 'Након што ми је поломио дио другог зуба, обратио сам се ординацији Вукотић. Ситуација је била прилично хитна јер сам био у граду само неколико дана, а на крају сам чак и продужио боравак како би лекар стигао да реши проблем. др. Иван је погледао зуб и рекао да је зуб труо, да је каријес дубок и да је потребно хитно вадити нерв – наглашавам да ме зуб никада није повредио, што сам му и рекао, јер вађење нерва обично није прво решење. Међутим, доктор је извадио зуб, ставио лек у зуб и заказао термин за додатно пломбирање и пломбирање. Када сам поново дошла код доктора, покушао је да попуни зуб, али није успео јер су ми почеле крварити десни, па је нестрпљив и нервозан рекао да не може, поново ми је ставио лек и рекао да се вратим када ми се десни смире. Тада нисам имао времена да додатно продужим свој боравак у граду, који сам већ продужио због његове процене проблема, па сам га питао да ли може некако, на било који начин, да ми заврши зуб да не бих морао да одем са поломљеним и избушеним зубом, на шта ми је он одговорио да нико не може да ми то сада заврши, да нађем неког у другом граду и да ме пошаље у неки бољи град, разред. Да ли је могуће да неко са толико година искуства не може да процени пре него што почне да ради поправку да може доћи до неког сличног проблема као што је крварење десни и да на тако неприкладан начин НЕ ЗАВРШИ посао? Два дана након тога отишао сам у другу ординацију где ми је доктор ставио пломбу у зуб без проблема и крварења.
Једино позитивно искуство са ординацијом Вукотић била је др Татјана, која ме је у почетку примила, била веома љубазна и упутила ме код др Ивана, који би требало да се специјализује за ову врсту проблема.', NULL, NULL, NULL, NULL,
    3, '2024-01-21 23:00:59'),

(@user_aleksey_zimin, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNiaUlYQm5BRRAB',
    5, 'en', 'My fillling came out while i was vacationing in Herceg Novi. Doctor Vukotic was able to see me on short notice  and did a great job fixing my tooth. He spoke good English and listened to me very carefully. Thank you so much for your care!',
    'Plomba mi je izvađena dok sam bio na odmoru u Herceg Novom. Doktor Vukotić me je primio u kratkom roku i odlično je popravio moj zub. Govorio je dobro engleski i pažljivo me je saslušao. Hvala vam puno na brizi!', 'Пломба ми је извађена док сам био на одмору у Херцег Новом. Доктор Вукотић ме је примио у кратком року и одлично је поправио мој зуб. Говорио је добро енглески и пажљиво ме је саслушао. Хвала вам пуно на бризи!', 'My fillling came out while i was vacationing in Herceg Novi. Doctor Vukotic was able to see me on short notice  and did a great job fixing my tooth. He spoke good English and listened to me very carefully. Thank you so much for your care!', NULL, NULL, NULL,
    0, '2024-07-23 06:42:24'),

(@user_luka_vukcevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VJQ0FnSUROdnJpWFJnEAE',
    5, 'bs', 'Odlična dentalna usluga! Hvala ordinaciji "Vukotić" na profesionalizmu i izuzetnoj brizi koju pokazuju svojim pacijentima. Ordinacija je umirujućeg ambijenta, adekvatne higijene i zadovoljavajuće brzine kojom odgovaraju na potrebe klijenata.
Pet zvezdica!',
    'Odlična stomatološka usluga! Hvala ordinaciji „Vukotić“ na profesionalnosti i izuzetnoj brizi za pacijente. Ordinacija ima umirujuću atmosferu, adekvatnu higijenu i zadovoljavajuću brzinu kojom reaguju na potrebe klijenata.
Pet zvezdica!', 'Одлична стоматолошка услуга! Хвала ординацији „Вукотић“ на професионалности и изузетној бризи за пацијенте. Ординација има умирујућу атмосферу, адекватну хигијену и задовољавајућу брзину којом реагују на потребе клијената.
Пет звездица!', NULL, NULL, NULL, NULL,
    0, '2024-01-22 20:11:01'),

(@user_ena_jovanov, @clinic_id, @doctor_mladen_vukotic, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSUROM3RfbHVRRRAB',
    5, 'en', 'Exceptional dental clinic! The staff is highly professional, caring, and attentive. Dr. Mladen provided me with thorough and painless treatment. The clinic\'s cleanliness and modern equipment truly impressed me. I highly recommend their services.',
    'Izuzetna stomatološka ordinacija! Osoblje je visoko profesionalno, brižno i pažljivo. Dr Mladen mi je pružio temeljan i bezbolan tretman. Čistoća klinike i savremena oprema su me zaista impresionirali. Toplo preporučujem njihove usluge.', 'Изузетна стоматолошка ординација! Особље је високо професионално, брижно и пажљиво. Др Младен ми је пружио темељан и безболан третман. Чистоћа клинике и савремена опрема су ме заиста импресионирали. Топло препоручујем њихове услуге.', 'Exceptional dental clinic! The staff is highly professional, caring, and attentive. Dr. Mladen provided me with thorough and painless treatment. The clinic\'s cleanliness and modern equipment truly impressed me. I highly recommend their services.', NULL, NULL, NULL,
    0, '2024-01-22 20:00:21'),

(@user_ivana_miletic_demmel, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNlMmRTY293RRAB',
    2, 'hr', 'Nakon vrlo kratkog pregleda, pri kom stomatolog nije ni dotakao čitavu levu polovinu moje vilice, a kamoli uradio rendgen, izjavio je da imam karijes na tri zuba. To me je iznenadilo, jer sam bila na kontroli šest meseci ranije bez početka karijesa i na jednom, redovno perem zube i ne jedem slatko. Zacenio je popravku 70 evra i zakazao mi za sledeći dan. Ordinacija je bila prijatna, sa modernom opremom i tihom klasičnom muzikom u pozadini, a doktor grub i nervozan. Vukao mi je glavu levo i desno, grubo teglio usne i razvlačio usta, toliko da sam mislila da će ih raseći. U jednom momentu se glasno proderao na asistentkinju. Ispostavilo se da je jedan od zuba imao dubok kvar, kako je rekao, tako da je na kraju popravio dva, a ne tri zuba. Korektno je uradio posao, zubi su izgledali prirodno i bez vidljive razlike u boji. Kad sam ga upitala za treći zub rekao je da nema vremena jer ima drugog pacijenta, a onda pogledao zub još jednom i rekao da on zapravo i nema karijes. Naplatio mi je cenu koju smo prethodno dogovorili za tri zuba.',
    'Posle vrlo kratkog pregleda, tokom kojeg zubar nije ni dodirnuo celu levu polovinu moje vilice, a kamoli napravio rendgenski snimak, izjavio je da imam karijes na tri zuba. To me je iznenadilo, jer sam bila na kontroli šest meseci ranije bez početka karijesa, a jednom prilikom redovno perem zube i ne jedem slatkiše. Procenio je popravku na 70 evra i zakazao je za sledeći dan. Operacija je bila prijatna, sa modernom opremom i tihom klasičnom muzikom u pozadini, a doktor je bio grub i nervozan. Vukao mi je glavu levo-desno, grubo mi je vukao usne i rastezao usta, toliko da sam pomislila da će ih rasporiti. U jednom trenutku je glasno penetrirao u asistentkinju. Ispostavilo se da jedan od zuba ima dubok karijes, rekao je, pa je na kraju popravio dva zuba, a ne tri. Posao je uradio kako treba, zubi su izgledali prirodno i bez vidljive razlike u boji. Kada sam ga pitala za treći zub, rekao je da nema vremena jer ima drugog pacijenta, zatim je ponovo pogledao zub i rekao da zapravo nema karijes. Naplatio mi je cenu koju smo prethodno dogovorili za tri zuba.', 'После врло кратког прегледа, током којег зубар није ни додирнуо целу леву половину моје вилице, а камоли направио рендгенски снимак, изјавио је да имам каријес на три зуба. То ме је изненадило, јер сам била на контроли шест месеци раније без почетка каријеса, а једном приликом редовно перем зубе и не једем слаткише. Проценио је поправку на 70 евра и заказао је за следећи дан. Операција је била пријатна, са модерном опремом и тихом класичном музиком у позадини, а доктор је био груб и нервозан. Вукао ми је главу лево-десно, грубо ми је вукао усне и растезао уста, толико да сам помислила да ће их распорити. У једном тренутку је гласно пенетрирао у асистенткињу. Испоставило се да један од зуба има дубок каријес, рекао је, па је на крају поправио два зуба, а не три. Посао је урадио како треба, зуби су изгледали природно и без видљиве разлике у боји. Када сам га питала за трећи зуб, рекао је да нема времена јер има другог пацијента, затим је поново погледао зуб и рекао да заправо нема каријес. Наплатио ми је цену коју смо претходно договорили за три зуба.', NULL, NULL, NULL, NULL,
    7, '2022-09-18 05:51:09'),

(@user_slobodan_vukotic, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GbWEyVjRka3cxWkhoYWVrcHhOa1J3YlVkdlZuYxAB',
    5, 'bs', 'Ljudi me na poziv primili sa bolovima, završili intervenciju za 15min, sve sa čekanjem da anestezija proradi. Hvala Dr. Vukotiću, spasili ste mi letovanje.',
    'Ljudi me na poziv primili sa bolovima, završili intervenciju za 15min, sve sa čekanjem da anestezija proradi. Hvala Dr. Vukotiću, spasili ste mi letovanje.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_dobrica_antovska, @clinic_id, @doctor_ivan_vukotic, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkeVlVUm9SMGxsVjBSV1lqZElTekZDV1VOSlMzYxAB',
    5, 'bg', 'Mnogu sum zadovolna od dr. Ivan Vukotic! Bev na odmor vo Herceg Novi i preku nokta dobiv zabobolka, i slednoto utro bev ljubezno primena kako iten slucaj. Vi blagodaram za vasata ljubeznost, expertizam i strucnost! Srdecno Ve preporacuvam kako kvaliteten stomatolog!',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_milana_kovacevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tkT2QxcHBVVEZoWlhSUmFEUmZZbTQzYjI5NldtYxAB',
    1, 'hr', 'Malo je reći sram vas bilo! Naplatite fino,a kad ispadne plomba za nedelju dana pravite se ludi,i nema šanse doći do termina da to opet odradite ovaj put kako treba. Sram vas bilo.',
    'Malo je reći sram vas bilo! Naplatite fino,a kad ispadne plomba za nedelju dana pravite se ludi,i nema šanse doći do termina da to opet odradite ovaj put kako treba. Sram vas bilo.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_svetozar_ivanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kdmFtWklOM1JVVjBzM1dHVndhMGRTY2tSV1VVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_michele_sarlat, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSVFIyMTZiRlZLUkRoNlQwdDZOM0Y0ZG14dVFYYxAB',
    5, 'en', 'I arrived at 8:30pm one evening, without an appointment, interested in obtaining  a second opinion, regarding some expensive dental work recommended by a highly regarded dentist in Madrid. After a short wait, Preuzmite attended me and provided me with an honest, professional  opinion, that the work was not necessary at this moment, to keep watch on the condition.  I highly recommend this dentist. It\'s so rare to find honesty and such professionalism these days. Thank you! Michele',
    NULL, NULL, 'I arrived at 8:30pm one evening, without an appointment, interested in obtaining  a second opinion, regarding some expensive dental work recommended by a highly regarded dentist in Madrid. After a short wait, Preuzmite attended me and provided me with an honest, professional  opinion, that the work was not necessary at this moment, to keep watch on the condition.  I highly recommend this dentist. It\'s so rare to find honesty and such professionalism these days. Thank you! Michele', NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_user_108063693225288131994, @clinic_id, @doctor_mladen_vukotic, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkZmJHVk9Vbll0VUdwUGFrTlRTMVk0ZW0xM1oyYxAB',
    5, 'bs', 'Sve preporuke! Doktor Mladen je vrlo pazljiv i ogroman strucnjak!',
    'Sve preporuke! Doktor Mladen je vrlo pazljiv i ogroman strucnjak!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_nbsvtrhcq, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwVmEyNXFSekphYW05Q1pITjROek0yT1cxNkxVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_tijana, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSQlgxOTJSVzlzTW5wSFVWaEhXbFZ6TlRKWlFtYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jelena_avramovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GRVNDMWlWWFJuWWpadk5HaEdjWFp3Y2pka1IyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_verica_matovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VObXYtby1Id29UQVpBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_biljana_bogicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VJQ0FnTUNnNHI2VUtBEAE',
    5, 'hr', 'Super sve!!!',
    'Super sve!!!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_barry, @clinic_id, @doctor_ivan_vukotic, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNmOU5fUWZBEAE',
    5, 'en', 'I’ve been going for several years now to dr. Ivan, very happy with it. Twice a year, cleaning, check, and anything else that needs to happen. Perfect.',
    NULL, NULL, 'I’ve been going for several years now to dr. Ivan, very happy with it. Twice a year, cleaning, check, and anything else that needs to happen. Perfect.', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_oxi, @clinic_id, @doctor_tatjana_vukotic, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VJQ0FnSUROdnZpUUZREAE',
    5, 'en', 'The team is friendly, and Dr. Tatjana is incredibly skilled.
They explained the procedure clearly and ensured my comfort throughout.
The clinic is spotless, creating a welcoming environment.💟',
    NULL, NULL, 'The team is friendly, and Dr. Tatjana is incredibly skilled.
They explained the procedure clearly and ensured my comfort throughout.
The clinic is spotless, creating a welcoming environment.💟', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_sanja_antic, @clinic_id, @doctor_ivan_vukotic, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VJQ0FnSURlLWV1MEVnEAE',
    5, 'bs', 'Veoma ljubazan i stalozen tim koji radi strucno, temeljno i efikasno. Dr Ivan se potrudio da mi fino objasni moju situaciju sa zubima, sta treba uraditi i zasto. Sve preporuke.',
    'Veoma ljubazan i stalozen tim koji radi strucno, temeljno i efikasno. Dr Ivan se potrudio da mi fino objasni moju situaciju sa zubima, sta treba uraditi i zasto. Sve preporuke.', NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_zeljko_zack_scepanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSUQyOC1tR29BRRAB',
    5, 'en', 'Superb ✌✌✌✌',
    NULL, NULL, 'Superb ✌✌✌✌', NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_yevgeniy_muratshayev, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VJQ0FnSURXdnA3S0VnEAE',
    5, 'en', 'These are real professionals',
    NULL, NULL, 'These are real professionals', NULL, NULL, NULL,
    1, '2022-10-29 00:00:00'),

(@user_mato_djuranovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VJQ0FnSUM2cUs3NEd3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_vasilije_golubin_vasilije_golubin, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNhN2RHZ21BRRAB',
    1, 'bg', 'Neprofesionalni,nekulturni,',
    NULL, NULL, NULL, NULL, NULL, NULL,
    1, '2021-10-29 00:00:00'),

(@user_igor_5_6_91, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNLeUl6Y0N3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_vlaho_mihoevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSUN5M0pxcTVnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_b_w_a_161, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNpcl95VmNBEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_tatiana_p, @clinic_id, @doctor_ivan_vukotic, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNpal9ENm53RRAB',
    5, 'ru', 'Спасибо доктору Ивану и ассистентке Анне за высокий профессионализм, аккуратность, стерильность, внимательность, тактичность, корректность и терпение, за мои здоровые зубы и роскошную улыбку )))
Рекомендую клинику Вукотич!',
    NULL, NULL, NULL, 'Спасибо доктору Ивану и ассистентке Анне за высокий профессионализм, аккуратность, стерильность, внимательность, тактичность, корректность и терпение, за мои здоровые зубы и роскошную улыбку )))
Рекомендую клинику Вукотич!', NULL, NULL,
    1, '2021-10-29 00:00:00'),

(@user_wim_baeten, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNDeTczeURnEAE',
    5, 'en', 'Excellent! Very professional, passionate and perfectionist. Could not be more pleased with the end result',
    NULL, NULL, 'Excellent! Very professional, passionate and perfectionist. Could not be more pleased with the end result', NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_marija_tmusic, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VJQ0FnSURjeHBqZVdBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_julija_krutalevica, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSURjaVBlNDRBRRAB',
    5, 'en', 'Best dentistry I\'ve ever been to. Very professional, thorough, highly qualified doctors, modern equipment and friendly quiet atmosphere.',
    NULL, NULL, 'Best dentistry I\'ve ever been to. Very professional, thorough, highly qualified doctors, modern equipment and friendly quiet atmosphere.', NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_pedja_bozovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSUQwdXZfTzhnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_hadzi_luka_krivokapi, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSURFNDgzZXZnRRAB',
    5, 'hr', 'Vrhunska ordinacija',
    'Vrhunska ordinacija', NULL, NULL, NULL, NULL, NULL,
    1, '2019-10-29 00:00:00'),

(@user_gennadiy_aleksandrov, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNRb0lESm9BRRAB',
    5, 'ru', 'Стоматологическую помощь оказали быстро и качественно. Приемлемые цены.',
    NULL, NULL, NULL, 'Стоматологическую помощь оказали быстро и качественно. Приемлемые цены.', NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_katica_bjelokosic, @clinic_id, NULL, 'google_maps',
    'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSURBLXF5T3pnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2016-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tkT2QxcHBVVEZoWlhSUmFEUmZZbTQzYjI5NldtYxAB'),
  'clinic', @clinic_id,
  'Poštovana,
U vezi sa Vašim komentarom, želimo da Vas obavijestimo da se osoba sa navedenim imenom i prezimenom ne nalazi u našoj kartoteci od 1996. godine.
Što se tiče Vaše primjedbe na naš rad, odnosno reklamacije u vezi sa plombom, uvijek stojimo na raspolaganju svim našim pacijentima za kontrolu i otklanjanje eventualnih problema. Međutim, zbog unaprijed zakazanih termina i radnog vremena ordinacije, nismo uvijek u mogućnosti da odmah izađemo u susret, osim u hitnim slučajevima.
Za sve dalje informacije i dogovor, molimo Vas da se obratite Poliklinici.
Srdačan pozdrav.', 'bs',
  'Poštovana,
U vezi sa Vašim komentarom, želimo da Vas obavijestimo da se osoba sa navedenim imenom i prezimenom ne nalazi u našoj kartoteci od 1996. godine.
Što se tiče Vaše primjedbe na naš rad, odnosno reklamacije u vezi sa plombom, uvijek stojimo na raspolaganju svim našim pacijentima za kontrolu i otklanjanje eventualnih problema. Međutim, zbog unaprijed zakazanih termina i radnog vremena ordinacije, nismo uvijek u mogućnosti da odmah izađemo u susret, osim u hitnim slučajevima.
Za sve dalje informacije i dogovor, molimo Vas da se obratite Poliklinici.
Srdačan pozdrav.', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VJQ0FnSURlLWV1MEVnEAE'),
  'clinic', @clinic_id,
  'Hvala Vam Sanja na pozitivnim kritikama.', 'hr',
  'Hvala Vam Sanja na pozitivnim kritikama.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2022-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSUQyOC1tR29BRRAB'),
  'clinic', @clinic_id,
  'Hvala lijepo.', 'hr',
  'Hvala lijepo.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2022-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VJQ0FnSURXdnA3S0VnEAE'),
  'clinic', @clinic_id,
  'Thank you.', 'en',
  NULL, NULL, 'Thank you.', NULL, NULL, NULL,
  'google_maps', '2022-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VJQ0FnSUM2cUs3NEd3EAE'),
  'clinic', @clinic_id,
  'Hvala lijepo.', 'hr',
  'Hvala lijepo.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2021-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNhN2RHZ21BRRAB'),
  'clinic', @clinic_id,
  'Hvala na iskrenosti.', 'hr',
  'Hvala na iskrenosti.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2021-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNLeUl6Y0N3EAE'),
  'clinic', @clinic_id,
  'Hvala lijepo.', 'hr',
  'Hvala lijepo.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2021-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSUN5M0pxcTVnRRAB'),
  'clinic', @clinic_id,
  'Hvala lijepo.', 'hr',
  'Hvala lijepo.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2021-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNpal9ENm53RRAB'),
  'clinic', @clinic_id,
  'Thank you for such a detailed review. It was our pleasure.', 'en',
  NULL, NULL, 'Thank you for such a detailed review. It was our pleasure.', NULL, NULL, NULL,
  'google_maps', '2021-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNDeTczeURnEAE'),
  'clinic', @clinic_id,
  'Thank you a lot sir.', 'en',
  NULL, NULL, 'Thank you a lot sir.', NULL, NULL, NULL,
  'google_maps', '2021-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChZDSUhNMG9nS0VJQ0FnSURjeHBqZVdBEAE'),
  'clinic', @clinic_id,
  'Hvala lijepo.', 'hr',
  'Hvala lijepo.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2021-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSURjaVBlNDRBRRAB'),
  'clinic', @clinic_id,
  'Thank you a lot for such a simple, but complete review.', 'en',
  NULL, NULL, 'Thank you a lot for such a simple, but complete review.', NULL, NULL, NULL,
  'google_maps', '2021-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSUQwdXZfTzhnRRAB'),
  'clinic', @clinic_id,
  'Hvala lijepo.', 'hr',
  'Hvala lijepo.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2021-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSURFNDgzZXZnRRAB'),
  'clinic', @clinic_id,
  'Hvala lijepo.', 'hr',
  'Hvala lijepo.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2021-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNRb0lESm9BRRAB'),
  'clinic', @clinic_id,
  'Thank you!', 'en',
  NULL, NULL, 'Thank you!', NULL, NULL, NULL,
  'google_maps', '2021-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJzWFUxIA8TBMRaBtLQ_tb2Qo/reviews/ChdDSUhNMG9nS0VJQ0FnSURBLXF5T3pnRRAB'),
  'clinic', @clinic_id,
  'Hvala lijepo', 'hr',
  'Hvala lijepo', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2021-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
