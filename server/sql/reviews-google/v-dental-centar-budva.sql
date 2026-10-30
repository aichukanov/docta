-- Insert Google Maps reviews for V Dental Centar
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/v-dental-centar-budva.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'v-dental-centar-budva');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_bojan_miladinovic = (SELECT id FROM doctors WHERE slug = 'bojan-miladinovic');
SET @doctor_iva_stanjevic = (SELECT id FROM doctors WHERE slug = 'iva-stanjevic');
SET @doctor_ivana_srzentic = (SELECT id FROM doctors WHERE slug = 'ivana-srzentic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Слободан Карић', 'https://lh3.googleusercontent.com/a-/ALV-UjVUr8BZRIBCM9wF6GgYMoydmJWvQu4nrgmK6Ue6I1YHzdnPRhrmDw=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/107676842280412027961/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107676842280412027961/reviews');
SET @user_slobodan_karic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107676842280412027961/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Микола Фостик', 'https://lh3.googleusercontent.com/a-/ALV-UjWaQay53BAiPAuL_hZAOgkEUucya6M7fHsdOoQnIV9XqYm4Wtrm=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/104577049780752185263/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104577049780752185263/reviews');
SET @user_mikola_fostik = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104577049780752185263/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dejana', 'https://lh3.googleusercontent.com/a-/ALV-UjW2QLgmsfmUJs1edEY414MvGKVO8OzsGlMAfnH0fCEPvf1eXS4=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/111938094479377178829/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111938094479377178829/reviews');
SET @user_dejana = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111938094479377178829/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Iva Onia', 'https://lh3.googleusercontent.com/a/ACg8ocKw1W7gQZH_aRflbKqTXhrY_8hrx9I0Ke1cbXLo9ouOFJapSQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/104623879650329834300/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104623879650329834300/reviews');
SET @user_iva_onia = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104623879650329834300/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'CANSU EMİRAL', 'https://lh3.googleusercontent.com/a/ACg8ocJcqCZOgxgir-ebTbErvw5KXVvg30Zw-38ABBIv68xsnOs4cQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106334442545067586997/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106334442545067586997/reviews');
SET @user_cansu_emral = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106334442545067586997/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ratko djurisic', 'https://lh3.googleusercontent.com/a/ACg8ocIgC17aEGFTIum3PoahPXC2s49nblfYI47zQdkomRuOBYEZzg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102012029181641293409/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102012029181641293409/reviews');
SET @user_ratko_djurisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102012029181641293409/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milos Micunovic', 'https://lh3.googleusercontent.com/a/ACg8ocJ_X4Tbccrrf_9xlyhRlCqYRs42b-CG75sDax54Vv0RpuyBfg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103723015690110488583/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103723015690110488583/reviews');
SET @user_milos_micunovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103723015690110488583/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Petkovic', 'https://lh3.googleusercontent.com/a/ACg8ocITzjT_fjknJYn05Qrqt97E3LRXjWVEzxuMLg4EkSdsqvT3Jw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107826291224988043605/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107826291224988043605/reviews');
SET @user_ana_petkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107826291224988043605/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Martinovic', 'https://lh3.googleusercontent.com/a/ACg8ocJU_1gVp3bht7X5WU4c-KHuVJS5C96EnIsjsF70jm6OGmfhJA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114838935857410358498/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114838935857410358498/reviews');
SET @user_ana_martinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114838935857410358498/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ognjen', 'https://lh3.googleusercontent.com/a-/ALV-UjV00q4WwcJVw6Vl2pH4xxOH-Co1A9wRRrn4UTHqLaI7zBAh0Vg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105060129921942468253/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105060129921942468253/reviews');
SET @user_ognjen = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105060129921942468253/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milan Scekic', 'https://lh3.googleusercontent.com/a-/ALV-UjWG3d8yzhcD_Rn_vnywe3MUs-4UtS3hxAko57FJ44ja2DhipQ7rzA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104495679507888105319/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104495679507888105319/reviews');
SET @user_milan_scekic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104495679507888105319/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Hogar Terrible', 'https://lh3.googleusercontent.com/a/ACg8ocJBzga7VeG7SD78MIYgSYR6QoIBtnAJnsoIoljgfSkpKbDptg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113709171435073399388/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113709171435073399388/reviews');
SET @user_hogar_terrible = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113709171435073399388/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Strahinja', 'https://lh3.googleusercontent.com/a-/ALV-UjVXnX5TkuYugKz_zkHzxfcMxBqkxzcFtH12ykLZ53dt-HHshrY1=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113160359248152685789/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113160359248152685789/reviews');
SET @user_maja_strahinja = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113160359248152685789/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Adrian Reinhardt', 'https://lh3.googleusercontent.com/a/ACg8ocJctjVuNn3rFhBrTpUV43dLgkrk2531pJ2gdaffsGns5dLsSw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102211195613842569453/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102211195613842569453/reviews');
SET @user_adrian_reinhardt = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102211195613842569453/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Karolina Nikolic', 'https://lh3.googleusercontent.com/a-/ALV-UjXEazY8LrNhSycGEEq6GQhWuI1EaVMAvUtppn8IcfAK0CWU6eAj=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112191055659669779998/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112191055659669779998/reviews');
SET @user_karolina_nikolic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112191055659669779998/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Vuckovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUPJsMPz7yc5aO_Uzc7qhdjq5jG2ACz729EPgVOxqIbbQcxqvg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113910611814739890113/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113910611814739890113/reviews');
SET @user_ana_vuckovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113910611814739890113/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandar Brcic Kostic', 'https://lh3.googleusercontent.com/a/ACg8ocKyWeQUlE-dCDCakQIBEoFSplcY6Puoogaq7lAIeiPxidh87Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110167110616201523112/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110167110616201523112/reviews');
SET @user_aleksandar_brcic_kostic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110167110616201523112/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragan Vukicevic', 'https://lh3.googleusercontent.com/a/ACg8ocJXS9_TehD8kegT3rGqCMKMh4czo7QiP0Yaep85aWK7G_3DHg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116918925785436533164/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116918925785436533164/reviews');
SET @user_dragan_vukicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116918925785436533164/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branislava Stojkovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUNBMQh_PH8Ir22htp-9fE18ea0dmAEQgCVd1alx0dpeU7PIZKqCQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106685319468264183444/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106685319468264183444/reviews');
SET @user_branislava_stojkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106685319468264183444/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena', 'https://lh3.googleusercontent.com/a/ACg8ocK6aCj85bdr0ONNmqw_74hoaZl2l6LEjatNjPWB2k66gy4bZQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106989621739812206693/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106989621739812206693/reviews');
SET @user_jelena = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106989621739812206693/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dusan Andrejic', 'https://lh3.googleusercontent.com/a-/ALV-UjVk2gMXZUM1x9rVSVUmoVFMjC16OwaZb51fX6TP8ImWUHwVU2LApA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104200092834956270682/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104200092834956270682/reviews');
SET @user_dusan_andrejic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104200092834956270682/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocLcl638IApLkuWBN6vn4k3QVjcLybN16TKLXEuAj--6IkeKtQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100231234693166598878/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100231234693166598878/reviews');
SET @user_maja_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100231234693166598878/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pićan Milica', 'https://lh3.googleusercontent.com/a-/ALV-UjWTrzGZ6oMakE5yMhgFFXV3a38ZPCzE0O5-8xDpbdxfcyec-Evw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116545447330423231743/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116545447330423231743/reviews');
SET @user_pian_milica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116545447330423231743/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natasa Davidovic', 'https://lh3.googleusercontent.com/a/ACg8ocIChH5l-VAGPBBcvEnVczIRL2LrEX0g8h5oTXRHIc59DuqDPQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108286869147415099714/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108286869147415099714/reviews');
SET @user_natasa_davidovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108286869147415099714/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Borka Kankaras', 'https://lh3.googleusercontent.com/a-/ALV-UjXcgplmZ9cQTRuCn_MKG5ITon1nKbQBLh17v6iQzyD68OdyYSY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101706927357355592100/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101706927357355592100/reviews');
SET @user_borka_kankaras = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101706927357355592100/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dejan Stijepovic', 'https://lh3.googleusercontent.com/a/ACg8ocJ2FVoUpyEoJ1UV6AqI81zVnT-aVRB8lXnY4WgPtEVfTIyTkg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105676720314926926976/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105676720314926926976/reviews');
SET @user_dejan_stijepovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105676720314926926976/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojana Lainovic', 'https://lh3.googleusercontent.com/a/ACg8ocJonocj2MX54rRw9rKH-Qy9RLfUkdiz4h8oDbX0EzOStI489A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103196448880768124034/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103196448880768124034/reviews');
SET @user_bojana_lainovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103196448880768124034/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Kilibarda', 'https://lh3.googleusercontent.com/a/ACg8ocIg_H6YtUQ9ZdFTd_Pu5VMnuSwbGWTf6RmUC6YSRirjioOSNw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106307562209384172242/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106307562209384172242/reviews');
SET @user_milica_kilibarda = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106307562209384172242/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Marko Đokić', 'https://lh3.googleusercontent.com/a-/ALV-UjWpMCkvH7-klFsMn3_CGJhcvbZrmGemogxBOOzOerZrrMIoeVt0=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113196425897236100955/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113196425897236100955/reviews');
SET @user_milica_marko_oki = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113196425897236100955/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marijana Nikolic', 'https://lh3.googleusercontent.com/a/ACg8ocIDnv_IEDJUUgJu-aiqUJPiXx8b81_2VzKGiO2xYC5635SrrQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111983767416109511620/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111983767416109511620/reviews');
SET @user_marijana_nikolic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111983767416109511620/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natasa Corluka', 'https://lh3.googleusercontent.com/a/ACg8ocI6W8-JF0gTZzGrKW7yn3Zx5yvfyUIAASGkOIgpKK1DytsKUg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108299584244103509233/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108299584244103509233/reviews');
SET @user_natasa_corluka = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108299584244103509233/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Bjelica', 'https://lh3.googleusercontent.com/a/ACg8ocJr1815DI3DF4Ilw7IUoLsgeMhbyeH-FaHgIJHUSJJZkCXbFA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115144910753026735364/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115144910753026735364/reviews');
SET @user_marija_bjelica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115144910753026735364/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Новица Чађеновић', 'https://lh3.googleusercontent.com/a-/ALV-UjVTdom0bERwhz6RTPVd5OmmCA-egaZVnrgcs_3VtAMcDC3MyxFD=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108680048382361207011/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108680048382361207011/reviews');
SET @user_novitsa_chadjenovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108680048382361207011/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Z M', 'https://lh3.googleusercontent.com/a/ACg8ocINaMiOJppAq4VLYxNJp_cbtkTsS2aSfiOxI6eOGrn7gZKDH2I=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106117009996833152666/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106117009996833152666/reviews');
SET @user_z_m = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106117009996833152666/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Momcilovic', 'https://lh3.googleusercontent.com/a/ACg8ocIK7tCDSoZxtiNW_ZXoTC4SCUSj0-uRBbWVoS65L3hDrf4OWw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100566592662678589254/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100566592662678589254/reviews');
SET @user_ana_momcilovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100566592662678589254/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natalija Kankaras', 'https://lh3.googleusercontent.com/a/ACg8ocIdQSsPnpeipNGbD7ccwjAtdUJ74yHs3sqSFi7F_tg-Q_lSHg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118057093511998106580/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118057093511998106580/reviews');
SET @user_natalija_kankaras = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118057093511998106580/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Polina Zafirova', 'https://lh3.googleusercontent.com/a/ACg8ocJH4hSghw-1MJV7Mi1qqquBOPqYpy2QDhn2ywkfe65Qckh2_Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106286843607144454447/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106286843607144454447/reviews');
SET @user_polina_zafirova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106286843607144454447/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'N K', 'https://lh3.googleusercontent.com/a-/ALV-UjV8knz45dKQU51ns0OiVlTuNza0v9xia3hjumtStNIzyhEQw0Gq8A=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105056685945757264596/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105056685945757264596/reviews');
SET @user_n_k = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105056685945757264596/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jasna Radovic', 'https://lh3.googleusercontent.com/a/ACg8ocI3kK9zAOkEI7I9-iPHGt-JsVRFxzFJTJLU0ZbECKQMti3Uww=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104868565952806801372/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104868565952806801372/reviews');
SET @user_jasna_radovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104868565952806801372/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Caroline', 'https://lh3.googleusercontent.com/a-/ALV-UjU-VMFRGGD0kA3Hg0dYrP7YiNK1YpVYfhQ1Oj2ylfe0-VsCHBI=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108895374460047217239/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108895374460047217239/reviews');
SET @user_caroline = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108895374460047217239/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Pajovic', 'https://lh3.googleusercontent.com/a/ACg8ocJqNW7ypEG59uqye0Er8ua3CAEv_-2PPl6bhdNv2Y9tMzIv4w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100278182161042763592/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100278182161042763592/reviews');
SET @user_marija_pajovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100278182161042763592/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Balsa Draskovic', 'https://lh3.googleusercontent.com/a/ACg8ocLPmAtbceI3Kq1OXFkihbB9HFyMhr964j9Lzva1zVNyIzbabg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104209195463226669911/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104209195463226669911/reviews');
SET @user_balsa_draskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104209195463226669911/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sara Marianovich', 'https://lh3.googleusercontent.com/a-/ALV-UjWwMP5eKX9d9FEYDOstSqXcxMRmqu_w4_kLMR2YiVwekA9rgUgY=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105677434778888588622/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105677434778888588622/reviews');
SET @user_sara_marianovich = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105677434778888588622/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Miletic Lajko', 'https://lh3.googleusercontent.com/a-/ALV-UjU417CbMkwSMLjIBA0ioDLzrdzIKUkCEUCD3Dg62qE8DSTPqCpC=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114028749610684374970/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114028749610684374970/reviews');
SET @user_dragana_miletic_lajko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114028749610684374970/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Joanne Williams', 'https://lh3.googleusercontent.com/a-/ALV-UjVK6ZMnMU5i9nhW5LcpXqk1gU3bWAzVf1K3Wiz4njWiKaq2hm_y=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117980294783220013676/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117980294783220013676/reviews');
SET @user_joanne_williams = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117980294783220013676/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Мария', 'https://lh3.googleusercontent.com/a/ACg8ocJ3E6INv_s_gUdIB1V5dOrdL6hJmis4Pcg_wQDrrxWZH169SA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108723140458034204265/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108723140458034204265/reviews');
SET @user_mariya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108723140458034204265/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sergej Vukovic', 'https://lh3.googleusercontent.com/a/ACg8ocJTUFVZliBWD_Jc4wWIfu6WwxnXWj0qyk-wTG34WLf4ueXvmA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103950805768493900549/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103950805768493900549/reviews');
SET @user_sergej_vukovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103950805768493900549/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Zafirovik', 'https://lh3.googleusercontent.com/a/ACg8ocI3l43wjEGxZdowrEhdsSe_Gn8uunErZWb4YNo-Us54Tc6B4N8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103234228126886682241/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103234228126886682241/reviews');
SET @user_marija_zafirovik = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103234228126886682241/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'milica djurasevic', 'https://lh3.googleusercontent.com/a/ACg8ocLkwqh4uL0McTiS_0d6M4IJlKbBC3paZkCusk6SiB4rrVra8w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105689569089334422201/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105689569089334422201/reviews');
SET @user_milica_djurasevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105689569089334422201/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sinisa Lucic', 'https://lh3.googleusercontent.com/a-/ALV-UjW6o4p6o7lRH36iZRh5Fv49f9v_ur2X0PI3WOKifGvLaThPEz4=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105680038884884607200/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105680038884884607200/reviews');
SET @user_sinisa_lucic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105680038884884607200/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aida Pupović', 'https://lh3.googleusercontent.com/a-/ALV-UjWP5eWyAIhfIUdiWZOd3PTHDfPrXsTM2U_C9OJX8vNF2dd7Bota=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108840713727154650031/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108840713727154650031/reviews');
SET @user_aida_pupovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108840713727154650031/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladana Pejović', 'https://lh3.googleusercontent.com/a-/ALV-UjXkeDUOuKD5uAHl41W_lS3ZIBFhHgNki7XGbScnDzTic5R2lIxL=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105005038722618178829/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105005038722618178829/reviews');
SET @user_vladana_pejovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105005038722618178829/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alois Alfons', 'https://lh3.googleusercontent.com/a/ACg8ocK7ghD0UYdI6unChvQD72fN4n11a8vQT08UWJNc9I1cRo1cTA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100478790068381773703/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100478790068381773703/reviews');
SET @user_alois_alfons = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100478790068381773703/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Strahinja', 'https://lh3.googleusercontent.com/a/ACg8ocICuUdXkhLqvUG9WSeZRzvEtR2TahcMd2SV21DZ1Ldb2RaRrA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100632247279347555463/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100632247279347555463/reviews');
SET @user_ana_strahinja = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100632247279347555463/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Terzic', 'https://lh3.googleusercontent.com/a-/ALV-UjW6nu5KyGEsXFCZaVO_VrHw0YN5alF7nHDB-7Aso8Mi5XmiZ2gx=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111629164646058137866/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111629164646058137866/reviews');
SET @user_jovana_terzic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111629164646058137866/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelisaveta Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocL3J3OpwAryfiZ_TjjphCTsIJjev1MZwJHzjJNQoxu1ee1F4g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109139836896318729300/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109139836896318729300/reviews');
SET @user_jelisaveta_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109139836896318729300/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mariana Ambrose', 'https://lh3.googleusercontent.com/a/ACg8ocKF159H8zc3BuSscG26ZNKOL941dUYj4fk9NN_5TdE_3koquw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110033481845725787213/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110033481845725787213/reviews');
SET @user_mariana_ambrose = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110033481845725787213/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andrey Rasulov', 'https://lh3.googleusercontent.com/a-/ALV-UjWTkMFBovz0iuDycwrlqJJvTIaqB-Jq56EbEPBlWVyHsGoUWWDS=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108203208283507075641/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108203208283507075641/reviews');
SET @user_andrey_rasulov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108203208283507075641/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sasa Zindovic', 'https://lh3.googleusercontent.com/a/ACg8ocK8qXdUpF6W0Q_0NadFgiahsMSHeIkfbg2tq6QW-aOQp78rPw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107194418344201223692/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107194418344201223692/reviews');
SET @user_sasa_zindovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107194418344201223692/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natacha Krstovic', 'https://lh3.googleusercontent.com/a/ACg8ocK7inHfpy80-kyh9xiGZH96GRZSKM77-5DmYEbL9cDj-gIOpQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106156048368001522823/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106156048368001522823/reviews');
SET @user_natacha_krstovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106156048368001522823/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Željko Krsmanović', 'https://lh3.googleusercontent.com/a-/ALV-UjXwhILwlkisfuvcoytfeS1wU5cBQtValeqov3Ums4HsfAGw3Oliow=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103906498897686704118/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103906498897686704118/reviews');
SET @user_eljko_krsmanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103906498897686704118/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ERZA PAJAZITI', 'https://lh3.googleusercontent.com/a/ACg8ocLf2HVk1QJMR57TzW0e-9eHYSDRLUzIcRFEfiOM8E5rCQbCMiM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112630867906265852500/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112630867906265852500/reviews');
SET @user_erza_pajaziti = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112630867906265852500/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Arcedessa', 'https://lh3.googleusercontent.com/a/ACg8ocLH2ose4k1kVKIjIEAzgcauW0BodVdabVXUKBvKW8svcKOxGyQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107640187534144945940/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107640187534144945940/reviews');
SET @user_arcedessa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107640187534144945940/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'mehves dolerr', 'https://lh3.googleusercontent.com/a/ACg8ocLBGxT_jahvILpw9d8G3dDqmKH_fmvYgtRSGYc9t1i5zexaYw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109426882356689089573/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109426882356689089573/reviews');
SET @user_mehves_dolerr = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109426882356689089573/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anna Bikeieva', 'https://lh3.googleusercontent.com/a-/ALV-UjXrYAhkbG9jkhrHWMkSxUq-UZoo5MED2xuQlv064n2rSe6sA4aInA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108917780374563098579/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108917780374563098579/reviews');
SET @user_anna_bikeieva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108917780374563098579/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nemanja Potpara', 'https://lh3.googleusercontent.com/a/ACg8ocLRZktfwrLAQftYoqSzvi7Gl4QsO7kNpuGtg1f22nb8rEz0Ig=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107595703525772832571/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107595703525772832571/reviews');
SET @user_nemanja_potpara = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107595703525772832571/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladana Garic', 'https://lh3.googleusercontent.com/a-/ALV-UjVWmxJ0XbDQV2T37YiczDnm_mk4oVUT44d1XZUrrRJ1jJRJknE=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103260206223925981167/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103260206223925981167/reviews');
SET @user_vladana_garic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103260206223925981167/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Slobodan djurisic', 'https://lh3.googleusercontent.com/a/ACg8ocLQWZZNQtKVoqeOq_7eftq6R15xssxsTfYyAjwk1-1YJgtUpw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117503040753012849643/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117503040753012849643/reviews');
SET @user_slobodan_djurisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117503040753012849643/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja Zecevic', 'https://lh3.googleusercontent.com/a/ACg8ocJvervvISAi8ACaGRtwu7MDdT3JdAO62G_4HHvBCtCX0Z_3GQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106557632897984239567/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106557632897984239567/reviews');
SET @user_sanja_zecevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106557632897984239567/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Racichfhfsbkmvsbk', 'https://lh3.googleusercontent.com/a/ACg8ocKMQJ67eZLWxSCV7bARjdnxcPlrwE2l6cQhtswCcjLviSGIvQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105990769524003298295/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105990769524003298295/reviews');
SET @user_ana_racichfhfsbkmvsbk = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105990769524003298295/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirjana Nikocevic', 'https://lh3.googleusercontent.com/a/ACg8ocKHx6aOI15spvJxoaSpEu9KiSrzVVjblVQskQh2DErJg7GGDA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114241401428962839976/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114241401428962839976/reviews');
SET @user_mirjana_nikocevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114241401428962839976/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andjela Vukotic', 'https://lh3.googleusercontent.com/a-/ALV-UjVkBRmhj2CorJ10RV8zvGXQP8WP09wahWW--Pypi5EsMT7V4d89=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117691275097200142083/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117691275097200142083/reviews');
SET @user_andjela_vukotic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117691275097200142083/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mevljud Amet', 'https://lh3.googleusercontent.com/a/ACg8ocJg3vi4-J_H_2khPTVd-43AcyqEttJaRsvnGSiNU6DDKDaocOr2=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110322444149449964053/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110322444149449964053/reviews');
SET @user_mevljud_amet = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110322444149449964053/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_slobodan_karic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChdDSUhNMG9nS0VJQ0FnSURSanREZTZRRRAB',
    5, 'sr', 'Све је као у Швајцарској.',
    'Sve je kao u Švajcarskoj.', 'Све је као у Швајцарској.', NULL, NULL, NULL, NULL,
    0, '2023-04-25 07:30:26'),

(@user_mikola_fostik, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GUGNtbHpXRUZ5TFdoMmIzbEtjVFo2ZVhBd1VYYxAB',
    1, 'en', 'Denied a 3D tooth scan after finding out I was treating and aligning my teeth with another doctor. Although when making an appointment, the girl at the reception said that she could do it without any problems and only had to pay for the service. The doctors themselves were very rude and shouting.',
    NULL, NULL, 'Denied a 3D tooth scan after finding out I was treating and aligning my teeth with another doctor. Although when making an appointment, the girl at the reception said that she could do it without any problems and only had to pay for the service. The doctors themselves were very rude and shouting.', NULL, NULL, NULL,
    0, '2026-01-12 22:16:02'),

(@user_dejana, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tJMlJ6bDJlRjlWYVZWMVYwVkpRVGh0VjNCck4zYxAB',
    5, 'hr', 'Hvala puno na izuzetnom pristupu meni kao pacijentu. 👏🌺
Hvala što ste mi izašli u susret na jedan efikasan, i profesionalan način. Neobično je reći ali ću se sa zadovoljstvom vratiti kod vas u maju za nastavak rada na mojim zubima.
Sve preporuke!
Dejana',
    'Hvala vam puno na izuzetnom pristupu meni kao pacijentu. 👏🌺
Hvala vam što ste mi izašli u susret na efikasan i profesionalan način. Čudno je reći, ali rado ću se vratiti kod vas u maju da nastavim da radim na svojim zubima.
Sve preporuke!
Dejana', 'Хвала вам пуно на изузетном приступу мени као пацијенту. 👏🌺
Хвала вам што сте ми изашли у сусрет на ефикасан и професионалан начин. Чудно је рећи, али радо ћу се вратити код вас у мају да наставим да радим на својим зубима.
Све препоруке!
Дејана', NULL, NULL, NULL, NULL,
    0, '2026-02-14 13:21:32'),

(@user_iva_onia, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pCc1pWaE1ibkZEWjIxS1ozVTRTMjVIYUdOc1prRRAB',
    5, 'en', 'I had very pleasant experiences as it can be in denial office. I had toothache for few days and I come here without any appointment. Even though it was quite crowded in the waiting area they kindly asked me to  wait and  that doctor would see me as soon as possible. After10-15 min they did  x ray, doctor gave me anesthesia  ,solved the problem.
Very polite and helpful staff, nice studio with moden equipment . Great team work!!! Gladly recommend',
    'Imao sam veoma prijatna iskustva, kao što to može biti u ordinaciji za odbijanja. Imao sam zubobolju nekoliko dana i došao sam ovde bez ikakvog zakazivanja. Iako je bilo dosta gužve u čekaonici, ljubazno su me zamolili da sačekam i da će me lekar primiti što je pre moguće. Posle 10-15 minuta su uradili rendgen, lekar mi je dao anesteziju i rešio problem.
Veoma ljubazno i uslužno osoblje, lep studio sa modernom opremom. Odličan timski rad!!! Rado preporučujem.', 'Имао сам веома пријатна искуства, као што то може бити у ординацији за одбијања. Имао сам зубобољу неколико дана и дошао сам овде без икаквог заказивања. Иако је било доста гужве у чекаоници, љубазно су ме замолили да сачекам и да ће ме лекар примити што је пре могуће. После 10-15 минута су урадили рендген, лекар ми је дао анестезију и решио проблем.
Веома љубазно и услужно особље, леп студио са модерном опремом. Одличан тимски рад!!! Радо препоручујем.', 'I had very pleasant experiences as it can be in denial office. I had toothache for few days and I come here without any appointment. Even though it was quite crowded in the waiting area they kindly asked me to  wait and  that doctor would see me as soon as possible. After10-15 min they did  x ray, doctor gave me anesthesia  ,solved the problem.
Very polite and helpful staff, nice studio with moden equipment . Great team work!!! Gladly recommend', NULL, NULL, NULL,
    0, '2025-09-16 16:39:55'),

(@user_cansu_emral, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xZM1FsWXRNbVo0Y1RacmQxVkRPRGxUVlZFMlNYYxAB',
    1, 'en', 'I came to this dentist to have my teeth cleaned, but my white teeth are now yellow. When I went to explain the situation to her,she said, "It\'s either because you drink coffee or because you smoke." She said, "That\'s not my problem." Even though I don\'t smoke and don\'t drink more than one coffee a day, she\'s never helpful and never admits that his procedure was wrong or that he performed the wrong procedure. I don\'t recommend this doctor to anyone. Be careful who you work with when you come here.Mu dentists name Nada pjerotic . Please pay attention to this name.',
    'Došao sam kod ovog zubara da mi očisti zube, ali su mi beli zubi sada žuti. Kada sam otišao da joj objasnim situaciju, rekla je: „Ili zato što piješ kafu ili zato što pušiš“. Rekla je: "To nije moj problem." Iako ne pušim i ne pijem više od jedne kafe dnevno, ona nikada ne pomaže i nikada ne priznaje da je njegova procedura bila pogrešna ili da je uradio pogrešan postupak. Ne preporučujem ovog doktora nikome. Pazite sa kim radite kada dolazite. Mu zubari imenuju Nadu Pjerotić. Obratite pažnju na ovo ime.', 'Дошао сам код овог зубара да ми очисти зубе, али су ми бели зуби сада жути. Када сам отишао да јој објасним ситуацију, рекла је: „Или зато што пијеш кафу или зато што пушиш“. Рекла је: "То није мој проблем." Иако не пушим и не пијем више од једне кафе дневно, она никада не помаже и никада не признаје да је његова процедура била погрешна или да је урадио погрешан поступак. Не препоручујем овог доктора никоме. Пазите са ким радите када долазите. Му зубари именују Наду Пјеротић. Обратите пажњу на ово име.', 'I came to this dentist to have my teeth cleaned, but my white teeth are now yellow. When I went to explain the situation to her,she said, "It\'s either because you drink coffee or because you smoke." She said, "That\'s not my problem." Even though I don\'t smoke and don\'t drink more than one coffee a day, she\'s never helpful and never admits that his procedure was wrong or that he performed the wrong procedure. I don\'t recommend this doctor to anyone. Be careful who you work with when you come here.Mu dentists name Nada pjerotic . Please pay attention to this name.', NULL, NULL, NULL,
    1, '2025-09-16 12:26:20'),

(@user_ratko_djurisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tGTWNrcDFPVFZSZUZRMFpsTnNZbGcxUW1KR2VGRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_milos_micunovic, @clinic_id, @doctor_bojan_miladinovic, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21aRWJsRkpZM0V3T0ZwbGJsZEhSREpCYldsaFQxRRAB',
    5, 'hr', 'Sve pohvale za dr Bojana i njegovu asistentkinju Nađu! 😊 Izvadio sam kod njih dva zuba i mogu reći da je cijelo iskustvo bilo mnogo lakše nego što sam očekivao. Nisam osjetio praktično ništa, a cijeli tim je bio profesionalan, ljubazan i pažljiv. Hvala im na odličnom pristupu i sigurnosti koju pružaju pacijentu. Za svaku preporuku! 👏🦷',
    'Sve pohvale za dr Bojana i njegovu asistentkinju Nađu! 😊 Izvadio sam kod njih dva zuba i mogu reći da je cijelo iskustvo bilo mnogo lakše nego što sam očekivao. Nisam osjetio praktično ništa, a cijeli tim je bio profesionalan, ljubazan i pažljiv. Hvala im na odličnom pristupu i sigurnosti koju pružaju pacijentu. Za svaku preporuku! 👏🦷', NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_ana_petkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21wclZGSkRWRVpCZVdoblgwaGpkVVJwTUdRemEyYxAB',
    1, 'bs', 'Dosla sam sa jakim bolom, rekli su mi da su u guzvii da ne mogu da me prime (sa jakim bolom da ponovim) mogu samo da mi snime zub na sta sam pristala.u cekaonici je u tom trenutku bilo troje ljudi i jedno dete (njima je to velika guzva) poslali su me kod dr Corovica koji me takodje nije primio zbog guzve iako sam rekla da imam jak bolom koji traje u tom trenutku dva dana. Kad sam se vratila ponovo u V dental ( proslo je maksimalno 10 min od prve posete) u cekaonici nije bili nikoga i tada su me primili uz opravdanja da su im otkazali pacijenti idt…. Dr Bojan kako oni kazu “specijalista” mi je “ocistio zub” za manje od minut i stavio lek i izasao to je to . Posto mi je pre toga dao anesteziju cim je delovanje anestezije proslo mene je zub poceo jos vise da boli sledecg dana sam dosla ponovo gde mi je on samo zamenio lek isto brzinom svetlosti jer on je  “specijalista” .zub me je boleo svih 11 dana koliko je trebalo da stoji lek. Htela sam da mi Dr Ivana zavrsi lecenje zuba ali su tada rekli da ona nece da me primi jer je u pitanju veliki zub i to ona ne radi . Sve u svemu otisla sam kod drugog stomatologa u drugom gradu koji mi je izvukao taj lek koji je bio skroz crn a zub pod jakom upalom koju sada lecim i koja ce da potraje. Katastrofalno iskustvo .sestra koja sa njim radi je takodje neprijatna i kao da se igra zubara a ne da stvarno radi taamo. Katastrofa i katastrofa od ovog Dr Bojana koji nema pojma sta radi.',
    'Dosla sam sa jakim bolom, rekli su mi da su u guzvii da ne mogu da me prime (sa jakim bolom da ponovim) mogu samo da mi snime zub na sta sam pristala.u cekaonici je u tom trenutku bilo troje ljudi i jedno dete (njima je to velika guzva) poslali su me kod dr Corovica koji me takodje nije primio zbog guzve iako sam rekla da imam jak bolom koji traje u tom trenutku dva dana. Kad sam se vratila ponovo u V dental ( proslo je maksimalno 10 min od prve posete) u cekaonici nije bili nikoga i tada su me primili uz opravdanja da su im otkazali pacijenti idt…. Dr Bojan kako oni kazu “specijalista” mi je “ocistio zub” za manje od minut i stavio lek i izasao to je to . Posto mi je pre toga dao anesteziju cim je delovanje anestezije proslo mene je zub poceo jos vise da boli sledecg dana sam dosla ponovo gde mi je on samo zamenio lek isto brzinom svetlosti jer on je  “specijalista” .zub me je boleo svih 11 dana koliko je trebalo da stoji lek. Htela sam da mi Dr Ivana zavrsi lecenje zuba ali su tada rekli da ona nece da me primi jer je u pitanju veliki zub i to ona ne radi . Sve u svemu otisla sam kod drugog stomatologa u drugom gradu koji mi je izvukao taj lek koji je bio skroz crn a zub pod jakom upalom koju sada lecim i koja ce da potraje. Katastrofalno iskustvo .sestra koja sa njim radi je takodje neprijatna i kao da se igra zubara a ne da stvarno radi taamo. Katastrofa i katastrofa od ovog Dr Bojana koji nema pojma sta radi.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_ana_martinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tOdVZrSkZUa0p6YkdwUE5UQlNaazlYTTFKR1UwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_ognjen, @clinic_id, @doctor_bojan_miladinovic, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GQ2FDMUpVQzFUV0VaYU9FbHNNMmswWDBkalpsRRAB',
    5, 'hr', 'Sve preporuke za V Dental! Ekipa je vrhunska, atmosfera skroz opuštena, a ordinacija moderna, čista desetka. Ono što me je najviše oduševilo je to što se odmah osjeti da stvarno žele da pomognu pacijentu na najbolji mogući način. Posebno bih izdvojio dr Nađu koja mi je izliječila korijen, zuba, stavila nove cirkonske mostove i još dosta gratis estetskih i preventivnih zahvata. Novi mostovi su tako dobro i prijatno sjeli da sam od prvog sekunda oduševljen kako to izgleda i kakav je osjećaj! Takođe, svaka čast dr Bojanu koji mi je spasio šesticu koja je bila vjerovatno za vađenje. Cijelo osoblje je drugarski raspoloženo, ljubazno i prije svega profesionalno.',
    'Sve preporuke za V Dental! Ekipa je vrhunska, atmosfera skroz opuštena, a ordinacija moderna, čista desetka. Ono što me je najviše oduševilo je to što se odmah osjeti da stvarno žele da pomognu pacijentu na najbolji mogući način. Posebno bih izdvojio dr Nađu koja mi je izliječila korijen, zuba, stavila nove cirkonske mostove i još dosta gratis estetskih i preventivnih zahvata. Novi mostovi su tako dobro i prijatno sjeli da sam od prvog sekunda oduševljen kako to izgleda i kakav je osjećaj! Takođe, svaka čast dr Bojanu koji mi je spasio šesticu koja je bila vjerovatno za vađenje. Cijelo osoblje je drugarski raspoloženo, ljubazno i prije svega profesionalno.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_milan_scekic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21wTVkxSjZOakJDUzJSeVpqaE1NbUpaY1VkTlFtYxAB',
    5, 'bs', 'Sve pohvale za ordinaciju i kompletan tim. Ovim putem bih iskoristio priliku da se posebno zahvalim Dr. Nadji koja mi je vratila osmjeh na licu...',
    'Sve pohvale za ordinaciju i kompletan tim. Ovim putem bih iskoristio priliku da se posebno zahvalim Dr. Nadji koja mi je vratila osmjeh na licu...', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_hogar_terrible, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tGSE9XeGhXbkJGTUdoRk5YQklWRVpqZVdKRk9YYxAB',
    5, 'de', 'Diese netten und hilfsbereiten Menschen sind wirklich sehr freundlich und professionell!
Meine Füllung war herausgefallen. Ich wurde sofort empfangen, mir wurde eine provisorische Füllung eingesetzt, und am nächsten Tag war alles schnell und in hoher Qualität erledigt.
Gliederung für jede Empfehlung.',
    NULL, NULL, NULL, NULL, 'Diese netten und hilfsbereiten Menschen sind wirklich sehr freundlich und professionell!
Meine Füllung war herausgefallen. Ich wurde sofort empfangen, mir wurde eine provisorische Füllung eingesetzt, und am nächsten Tag war alles schnell und in hoher Qualität erledigt.
Gliederung für jede Empfehlung.', NULL,
    0, '2026-06-29 00:00:00'),

(@user_maja_strahinja, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xOVVptVjRXVzg0UnpGWlRURm5UMmt6Y1d4NGJVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_adrian_reinhardt, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xWWFluZFhiVlJPUTBacFFXOHljVEJ4UmxadFJsRRAB',
    5, 'de', 'Füllung bei meinem Zahn ist rausgefallen und mir wurde innerhalb 30 Minuten inklusive Wartezeit die Füllung wieder eingesetzt. Super Arbeit! Gerne wieder',
    NULL, NULL, NULL, NULL, 'Füllung bei meinem Zahn ist rausgefallen und mir wurde innerhalb 30 Minuten inklusive Wartezeit die Füllung wieder eingesetzt. Super Arbeit! Gerne wieder', NULL,
    0, '2026-06-29 00:00:00'),

(@user_karolina_nikolic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GTmIxWlVUVVpGYUVsR2FFZEdNbkZJTlVaalgxRRAB',
    5, 'bs', 'Visoki nivo profesionalizma.  Posvecenost doktorke Iva , doktorke Nadje sa timom je za primjer.
Hvala  posebno sestri Ani  !',
    'Visoki nivo profesionalizma.  Posvecenost doktorke Iva , doktorke Nadje sa timom je za primjer.
Hvala  posebno sestri Ani  !', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_ana_vuckovic, @clinic_id, @doctor_ivana_srzentic, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xablRUVmpibFp6U3pJM1pVYzVZMWxzV1Y5Q1YxRRAB',
    5, 'en', 'I had an excellent experience at this dental center and couldn\'t be happier with the care I received. From the very first visit, the entire team was welcoming, kind, and highly professional. The level of service is truly top-notch, and you immediately feel that you\'re in the hands of people who genuinely care about their patients.

A special thank you to Dr. Ivana, who is an outstanding dentist. Her professionalism, expertise, attention to detail, and caring approach made every visit a pleasant experience. I would also like to mention Marina, whose kindness, support, and helpfulness made the whole process even more comfortable.

I highly recommend this dental center to anyone looking for exceptional dental care. Thank you to the whole team for your outstanding work!',
    NULL, NULL, 'I had an excellent experience at this dental center and couldn\'t be happier with the care I received. From the very first visit, the entire team was welcoming, kind, and highly professional. The level of service is truly top-notch, and you immediately feel that you\'re in the hands of people who genuinely care about their patients.

A special thank you to Dr. Ivana, who is an outstanding dentist. Her professionalism, expertise, attention to detail, and caring approach made every visit a pleasant experience. I would also like to mention Marina, whose kindness, support, and helpfulness made the whole process even more comfortable.

I highly recommend this dental center to anyone looking for exceptional dental care. Thank you to the whole team for your outstanding work!', NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_aleksandar_brcic_kostic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s1bFUzTkpTa3Q0ZWw5VFEyMU1UVEZ1Wkhsb1NIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_dragan_vukicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21aTFVUVjRYMGw2Um10MGRFRmFRbkZaY0VSR05IYxAB',
    5, 'hr', 'Sve pohvale',
    'Sve pohvale', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_branislava_stojkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xJNE0wVjNRMnB3UmtsdWVVZFNVa0kzVVVoT1RHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_jelena, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xST05DMXdkREpOWDAwek5rRm1hVWx2VTJSM1RWRRAB',
    5, 'hr', 'Najbolja ordinacija,sve pohvale',
    'Najbolja ordinacija,sve pohvale', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_dusan_andrejic, @clinic_id, @doctor_iva_stanjevic, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKdmNURkVUbnBHY0dWaldFcGFUSFpaVkdsdlMyYxAB',
    5, 'hr', 'Najbolja ordinacija u kojoj sam bio,sve pohvale za Dr Stanjevic i sestru Anu',
    'Najbolja ordinacija u kojoj sam bio,sve pohvale za Dr Stanjevic i sestru Anu', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_maja_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GRk5VOU1VMWN6V1VFeVZqUlhhVU56TUdoYWFWRRAB',
    5, 'bs', 'Najbolji u Budvi 👌 Preporuke za dr Ivu i Nadju 🤩',
    'Najbolji u Budvi 👌 Preporuke za dr Ivu i Nadju 🤩', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_pian_milica, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KRGVFVXpiWEo1YWtoVldUWnRaa0ZUZVhReFRFRRAB',
    5, 'hr', 'Najbolji doktori, najbolje sestre! Nemaju konkurenciju. Tople preporuke za najbolju ordinaciju u Crnoj Gori',
    'Najbolji doktori, najbolje sestre! Nemaju konkurenciju. Tople preporuke za najbolju ordinaciju u Crnoj Gori', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_natasa_davidovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT205UU5WcFFRVmhRY2xSeVQxQm5ka2hVY0UxcFYxRRAB',
    5, 'hr', 'Sve pohvale za ordinaciju i kompletan tim! Izuzetno profesionalni, ljubazni . Preporuka svima koji traže vrhunsku uslugu,prezadovoljna sam .',
    'Sve pohvale za ordinaciju i kompletan tim! Izuzetno profesionalni, ljubazni . Preporuka svima koji traže vrhunsku uslugu,prezadovoljna sam .', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_borka_kankaras, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25sWmJrdERPRGt4T1ZGRVNUZFVWRmRhY0U5aFZXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_dejan_stijepovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSS2EwUk5NREZoVkRaVVpETXRNV0o1T1hjeFYxRRAB',
    5, 'hr', 'Sjajni!',
    'Sjajni!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_bojana_lainovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xWaE0xUTNRbEpVUmt0Q1VVZEhaVTVKV0U1NFkzYxAB',
    5, 'bs', 'Hvala vam od srca na profesionalnosti,strpljenju i prelepom osmehu!Vi ste neko ko u potpunosti uklanja svaki strah od zubara.Sve pohvale za dr IVU i njen tim..Njihova strucnost,neznost tokom rada i ljubaznost cine da odlazak kod stomatologa vise nije stresan..',
    'Hvala vam od srca na profesionalnosti,strpljenju i prelepom osmehu!Vi ste neko ko u potpunosti uklanja svaki strah od zubara.Sve pohvale za dr IVU i njen tim..Njihova strucnost,neznost tokom rada i ljubaznost cine da odlazak kod stomatologa vise nije stresan..', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_milica_kilibarda, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25sSWVrSnJNMWcxWnpkWmNXaHRZaTEwVlVOeGVWRRAB',
    5, 'hr', 'Izuzetno stručno i ljubazno osoblje!
Topla preporuka svima.',
    'Izuzetno stručno i ljubazno osoblje!
Topla preporuka svima.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_milica_marko_oki, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tOR2EzbERhWGgxYjFkS01rdEVNMUJZWW0xdmFHYxAB',
    5, 'hr', 'Sve pohvale za ljubaznost osoblja!Jedina ordinacija koja uvijek izadje u susret svim pacijentima❤️',
    'Sve pohvale za ljubaznost osoblja!Jedina ordinacija koja uvijek izadje u susret svim pacijentima❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_marijana_nikolic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25OaVNHbEtNbmt4VG14SlVEazNXRXhwUVdOTlRHYxAB',
    5, 'bs', 'Naravno, evo kratke recenzije:

⭐⭐⭐⭐⭐

Veoma sam zadovoljna uslugom i kvalitetom rada u V-Dental!😊
Osoblje je ljubazno, profesionalno i posvećeno pacijentima, a tretmani su urađeni pažljivo i kvalitetno. Ambijent je prijatan, a cijelo iskustvo uliva povjerenje. Sve preporuke! 😊',
    'Naravno, evo kratke recenzije:

⭐⭐⭐⭐⭐

Veoma sam zadovoljna uslugom i kvalitetom rada u V-Dental!😊
Osoblje je ljubazno, profesionalno i posvećeno pacijentima, a tretmani su urađeni pažljivo i kvalitetno. Ambijent je prijatan, a cijelo iskustvo uliva povjerenje. Sve preporuke! 😊', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_natasa_corluka, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25sb01rTkdXamhLTkVVNFRuTXpOWGRCTFd0NlRVRRAB',
    5, 'bs', 'Sve pohvale za doktore ! Preljubazno osoblje, posebno za sestru Anu Cadjenovic Martinovic ❤️',
    'Sve pohvale za doktore ! Preljubazno osoblje, posebno za sestru Anu Cadjenovic Martinovic ❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_marija_bjelica, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25aRFlUSkJjWE51ZW1SQ1oweG5ibEEwUW1Oek9GRRAB',
    5, 'hr', 'Sve pohvale za stučan tim doktora i divne  medicinske sestre.
Topla preporuka.',
    'Sve pohvale za stučan tim doktora i divne  medicinske sestre.
Topla preporuka.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_novitsa_chadjenovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2taZmNrdEZUV3h6UjFRNGNsZFBkR2xGZDJaRGVrRRAB',
    5, 'sr', 'Више од 10 година сам њихов пацијент. Све похвале за врхунске докторе, и прељубазне сестре! Свака препорука!',
    'Više od 10 godina sam njihov pacijent. Sve pohvale za vrhunske doktore, i preljubazne sestre! Svaka preporuka!', 'Више од 10 година сам њихов пацијент. Све похвале за врхунске докторе, и прељубазне сестре! Свака препорука!', NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_z_m, @clinic_id, @doctor_bojan_miladinovic, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWbVUyVndZM3BuVlRaWGNERkVPRVF5Ym1jd01YYxAB',
    5, 'hr', 'Sve pohvale za osoblje posebno za Nataliju Kankaras.Predivna i preljubazna.Cistio sam kamenac to je radio doktor Bojan koji je takodje perfektan.Sve pohvale🫶',
    'Sve pohvale za osoblje posebno za Nataliju Kankaras.Predivna i preljubazna.Cistio sam kamenac to je radio doktor Bojan koji je takodje perfektan.Sve pohvale🫶', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_ana_momcilovic, @clinic_id, @doctor_ivana_srzentic, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkQ1dtUlNObnBqUTNOYWJsTTJOR3hSZW05T1JsRRAB',
    5, 'hr', '„Sve preporuke za V Dental Centar u Budvi! Posebno želim da pohvalim dr Ivanu Srzentić, koja je izuzetno prijatna, ljubazna i profesionalna. Od prvog pregleda sam se osjećala sigurno i opušteno zahvaljujući njenom pristupu i stručnosti. Prezadovoljna sam svojim novim osmijehom i cjelokupnim iskustvom.
Hvala dr Srzentić i cijelom timu na vrhunskoj usluzi – od srca preporučujem svima!”',
    '„Sve preporuke za V Dental Centar u Budvi! Posebno želim da pohvalim dr Ivanu Srzentić, koja je izuzetno prijatna, ljubazna i profesionalna. Od prvog pregleda sam se osjećala sigurno i opušteno zahvaljujući njenom pristupu i stručnosti. Prezadovoljna sam svojim novim osmijehom i cjelokupnim iskustvom.
Hvala dr Srzentić i cijelom timu na vrhunskoj usluzi – od srca preporučujem svima!”', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_natalija_kankaras, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xOdFdUaEdUemhUV2pkUmIwazRhbUZKZEdaVE5WRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_polina_zafirova, @clinic_id, @doctor_ivana_srzentic, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tjMVN6RmFZbVZqUWtWNlgyYzNSSGw0U3pSbFltYxAB',
    5, 'en', '​"Highly recommend V Dental Center and the wonderful Dr. Ivana Srzentić! Exceptional professionalism, dedication to patients, and top-notch service. Dr. Ivana is incredibly gentle, patient, and thorough, which provides complete peace of mind and eliminates any fear of the dentist\'s chair. The clinic is modernly equipped, and the atmosphere is very pleasant. A warm recommendation to anyone looking for premium dental care!"',
    NULL, NULL, '​"Highly recommend V Dental Center and the wonderful Dr. Ivana Srzentić! Exceptional professionalism, dedication to patients, and top-notch service. Dr. Ivana is incredibly gentle, patient, and thorough, which provides complete peace of mind and eliminates any fear of the dentist\'s chair. The clinic is modernly equipped, and the atmosphere is very pleasant. A warm recommendation to anyone looking for premium dental care!"', NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_n_k, @clinic_id, @doctor_ivana_srzentic, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21sU1RVd3dja28xU21KUGVDMHhUM1ZCTWpkd1QyYxAB',
    1, 'hr', 'Evo, pišem recenziju nakon nekoliko godina.
Liječio sam se kod doktorice Srzentić i, nažalost, moje iskustvo nije bilo pozitivno. Komunikacija i odnos prema pacijentu nisu bili na nivou koji sam očekivao, a ni rezultatom zahvata nisam bio zadovoljan.
I danas smatram da usluga koju sam dobio nije opravdala moja očekivanja, iako sam je uredno platio.
Ovo je moje lično iskustvo i zbog njega ne bih ponovo izabrao ovu ordinaciju.',
    'Evo, pišem recenziju nakon nekoliko godina.
Liječio sam se kod doktorice Srzentić i, nažalost, moje iskustvo nije bilo pozitivno. Komunikacija i odnos prema pacijentu nisu bili na nivou koji sam očekivao, a ni rezultatom zahvata nisam bio zadovoljan.
I danas smatram da usluga koju sam dobio nije opravdala moja očekivanja, iako sam je uredno platio.
Ovo je moje lično iskustvo i zbog njega ne bih ponovo izabrao ovu ordinaciju.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_jasna_radovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSak1YZHJiMDAyYkZZMVRHOWpPSE15VmtKNWJXYxAB',
    5, 'hr', 'Najbolji!',
    'Najbolji!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_caroline, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tJd1NWQlNkWEpQYVVJM1JXSmtZMXBwT0ZFME9FRRAB',
    1, 'en', 'Personnel extrêmement désagréable, with a clear impression that they are doing you a favor by even letting you into their premises.
I came in for a crown, which was ground down to the point that the porcelain layer was removed, exposing a large area of metal. The result: an unaesthetic, metallic, and poorly fitted tooth.
There was also an issue with another tooth.
Poor workmanship, I had to get it redone elsewhere. I strongly do not recommend.',
    NULL, NULL, 'Personnel extrêmement désagréable, with a clear impression that they are doing you a favor by even letting you into their premises.
I came in for a crown, which was ground down to the point that the porcelain layer was removed, exposing a large area of metal. The result: an unaesthetic, metallic, and poorly fitted tooth.
There was also an issue with another tooth.
Poor workmanship, I had to get it redone elsewhere. I strongly do not recommend.', NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_marija_pajovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21jNFZrNUhTbEpwYnpSalNrRTBVR2htTld0UVdrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_balsa_draskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xWak1rRjBXbWhQVFVOSmMzVkxOR3hvT0ZReWVWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_sara_marianovich, @clinic_id, @doctor_ivana_srzentic, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwMFZWRTFXbTloY1RCMFRGUk1iak5vZUhaRWQwRRAB',
    5, 'es', 'Acudí a este Centro Dental por una urgencia y me atendieron sin espera y muy amablemente. El centro es moderno, muy bien equipado y con ubicación excelente (en la primera planta del Hotel Tre Canne). Maravillosa doctora Ivana Srzentic, muy profesional y atenta. No puedo estar más contenta y agradecida por su trato y solución a mi dolencia. Recomendable 100%',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dragana_miletic_lajko, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2toTlpUTXRXa3ByYmt0UVZuQnViREYzWkU5d05XYxAB',
    5, 'en', 'Preffesional and helpful!!!',
    NULL, NULL, 'Preffesional and helpful!!!', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_joanne_williams, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCVWVTMDNNblZ2ZW1kYVFVZzRXR0ZHYTJORFEyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_mariya, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWclRVdzVUM3B2WXpSNmR6bGhPRm94WTFWT1owRRAB',
    1, 'ru', 'Обратились по срочному с ребёнком. Плюс: приняли. Минус: ничего толкового не сделали, использовали старый протокол. Помучали ребенка, но проблему не решили, отправили домой "приходите завтра...а потом еще когда-нибудь". И это всё из-за молочного шатающегося зуба. Пришлось идти к другому врачу решать этот вопрос. В итоге: здесь отдали 30 € за мучение и нулевого решения вопроса. И возможно даже вовсе подвергли нас опасности своими сомнительными советами. В поликлинике же напротив всего за 25 евро оказали за реальную помощь и потом были на связи, можно сказать спасли нас.
Понравилось, что на рессепшене были вежливы и хотели все же помочь. Не понравилось, что врач была груба и резка. У меня от волнения все слова повылетали из головы на всех языках, я путалась в них, но это нормально, как по мне. А она на меня ещё из-за этого бухтела и раздражалась. В общем, ощущения остались очень неприятными. Лучше бы просто отказали нам, если честно. Мы бы сразу к другому доктору пошли. Кстати, напротив. Так что пробуйте искать дальше. Крайне, не рекомендую эту клинику.',
    NULL, NULL, NULL, 'Обратились по срочному с ребёнком. Плюс: приняли. Минус: ничего толкового не сделали, использовали старый протокол. Помучали ребенка, но проблему не решили, отправили домой "приходите завтра...а потом еще когда-нибудь". И это всё из-за молочного шатающегося зуба. Пришлось идти к другому врачу решать этот вопрос. В итоге: здесь отдали 30 € за мучение и нулевого решения вопроса. И возможно даже вовсе подвергли нас опасности своими сомнительными советами. В поликлинике же напротив всего за 25 евро оказали за реальную помощь и потом были на связи, можно сказать спасли нас.
Понравилось, что на рессепшене были вежливы и хотели все же помочь. Не понравилось, что врач была груба и резка. У меня от волнения все слова повылетали из головы на всех языках, я путалась в них, но это нормально, как по мне. А она на меня ещё из-за этого бухтела и раздражалась. В общем, ощущения остались очень неприятными. Лучше бы просто отказали нам, если честно. Мы бы сразу к другому доктору пошли. Кстати, напротив. Так что пробуйте искать дальше. Крайне, не рекомендую эту клинику.', NULL, NULL,
    2, '2025-10-29 00:00:00'),

(@user_sergej_vukovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGRWRGbGplalZJYjAxUWRVUTJOVXh2WmxWeGRWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_marija_zafirovik, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChZDSUhNMG9nS0VKbXdndHFfeXQzMGJnEAE',
    1, 'bs', 'Jedno od najgorih iskustava koje sam imala! Osoba koja radi na punktu za zakazivanje je neverovatno neljubazna i nezainteresovana za pacijente. Umesto da pomogne, bila je arogantna, bez trunke empatije, i ostavila me da se osećam kao da sam na pogrešnom mestu. Ne bih nikome preporučila da ovde traži uslugu. Katastrofa!',
    'Jedno od najgorih iskustava koje sam imala! Osoba koja radi na punktu za zakazivanje je neverovatno neljubazna i nezainteresovana za pacijente. Umesto da pomogne, bila je arogantna, bez trunke empatije, i ostavila me da se osećam kao da sam na pogrešnom mestu. Ne bih nikome preporučila da ovde traži uslugu. Katastrofa!', NULL, NULL, NULL, NULL, NULL,
    1, '2025-10-29 00:00:00'),

(@user_milica_djurasevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChZDSUhNMG9nS0VJQ0FnTUNBcTQzTE5REAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_sinisa_lucic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChZDSUhNMG9nS0VJQ0FnSURfeGREMVVREAE',
    5, 'bs', 'Profesionalna i ljubazna usluga, za svaku preporuku',
    'Profesionalna i ljubazna usluga, za svaku preporuku', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_aida_pupovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChdDSUhNMG9nS0VJQ0FnSUR2eXN2aGtRRRAB',
    5, 'hr', 'Svima preporučujem V -dental🤗',
    'Svima preporučujem V -dental🤗', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_vladana_pejovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChdDSUhNMG9nS0VJQ0FnSUMzNVk3WXhBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_alois_alfons, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNyMUxQYU5nEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_ana_strahinja, @clinic_id, @doctor_ivana_srzentic, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNqNHV5SnZ3RRAB',
    5, 'hr', 'Najdivnija doktorica Ivana Srzentić',
    'Najdivnija doktorica Ivana Srzentić', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_jovana_terzic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChdDSUhNMG9nS0VJQ0FnSUM5eWJqdWhnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_jelisaveta_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChdDSUhNMG9nS0VJQ0FnSUM5a0x2TW1BRRAB',
    5, 'bs', 'Sva ekipa ali sva divna… tu su bili za sve sto mi je trebalo. Rekla sam im da se vracam na brod 1og uradili su nemoguce da bi mi izasli u susret. A sto se tice rada i kvaliteta nema ih ravnih na Balkanu. To isto mogu reci jer je moja sestra isla do Bg svako je htio da joj vadi zub a ova ekipa joj je em spasila zub em napravila kao da je novi. Tako da… ja sam ne srecna vec presrecna i uslugom i kvalitetom rada- Vesna Cabarkapa',
    'Sva ekipa ali sva divna… tu su bili za sve sto mi je trebalo. Rekla sam im da se vracam na brod 1og uradili su nemoguce da bi mi izasli u susret. A sto se tice rada i kvaliteta nema ih ravnih na Balkanu. To isto mogu reci jer je moja sestra isla do Bg svako je htio da joj vadi zub a ova ekipa joj je em spasila zub em napravila kao da je novi. Tako da… ja sam ne srecna vec presrecna i uslugom i kvalitetom rada- Vesna Cabarkapa', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_mariana_ambrose, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNabV95dzNnRRAB',
    5, 'en', 'Excellent dental  clinic with the   most modern  technology  which  meets  all your  dental  needs.
From  laser  and ultrasound  dental  cleaning ,great attention  to  gum care, surgical  extractions,crown and implant work  with  best  quality  materials  ,meeting  world and  European standards.

Well  organized  and professional
staff   and pleasant  athmosphere.

This office is run by a dental  surgeon,  an exceptional  and lovely woman ,as well  as  a  great dentist, with  an extraordinary     team of doctors  and  nurses.

Highly recommend !!!',
    NULL, NULL, 'Excellent dental  clinic with the   most modern  technology  which  meets  all your  dental  needs.
From  laser  and ultrasound  dental  cleaning ,great attention  to  gum care, surgical  extractions,crown and implant work  with  best  quality  materials  ,meeting  world and  European standards.

Well  organized  and professional
staff   and pleasant  athmosphere.

This office is run by a dental  surgeon,  an exceptional  and lovely woman ,as well  as  a  great dentist, with  an extraordinary     team of doctors  and  nurses.

Highly recommend !!!', NULL, NULL, NULL,
    1, '2024-10-29 00:00:00'),

(@user_andrey_rasulov, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChZDSUhNMG9nS0VJQ0FnSUR0bUtYTGN3EAE',
    4, 'ru', '+ Удобная локация стоматологии
+ Удобный график работы, можно сделать 3D снимок без предварительной записи
+ Вежливый доктор
- Цена за снимок 100€, неважно зуб, половина или вся челюсть. В Черногории есть и дешевле',
    NULL, NULL, NULL, '+ Удобная локация стоматологии
+ Удобный график работы, можно сделать 3D снимок без предварительной записи
+ Вежливый доктор
- Цена за снимок 100€, неважно зуб, половина или вся челюсть. В Черногории есть и дешевле', NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_sasa_zindovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChdDSUhNMG9nS0VJQ0FnSUN0cU9tTmd3RRAB',
    1, 'hr', 'Katastrofa osoblje uzas',
    'Katastrofa osoblje uzas', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_natacha_krstovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChdDSUhNMG9nS0VJQ0FnSURaemVXSTVnRRAB',
    5, 'en', 'Amazing staff with professional skills and knowledge. I have been using them for years and only have positive feedbacks. Highly recommending this place. Thank you for being so nice and professional',
    NULL, NULL, 'Amazing staff with professional skills and knowledge. I have been using them for years and only have positive feedbacks. Highly recommending this place. Thank you for being so nice and professional', NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_eljko_krsmanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChZDSUhNMG9nS0VJQ0FnSUR4OFBhd0VnEAE',
    4, 'en', 'Ok',
    NULL, NULL, 'Ok', NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_erza_pajaziti, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChdDSUhNMG9nS0VJQ0FnSURSdVoyRjVBRRAB',
    1, 'en', 'I went to this dental center with my boyfriend while we were in vacations with an emergency case, the staff was extremely rude!! A shame for a medical place to be filled with people with such a negative vibe, and not at all ready to help people when needed, plus we were tourists!!!',
    NULL, NULL, 'I went to this dental center with my boyfriend while we were in vacations with an emergency case, the staff was extremely rude!! A shame for a medical place to be filled with people with such a negative vibe, and not at all ready to help people when needed, plus we were tourists!!!', NULL, NULL, NULL,
    2, '2023-10-29 00:00:00'),

(@user_arcedessa, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNocGFiM2t3RRAB',
    5, 'ru', 'Делала  снимок 3D-KT. Персонал компетентен и вежлив. Оборудование отличное. Рабочий график очень удобный. Общение на русском не проблема, чему я очень рада,тк пока не владею сербским. Планирую посетить это место ещё))',
    NULL, NULL, NULL, 'Делала  снимок 3D-KT. Персонал компетентен и вежлив. Оборудование отличное. Рабочий график очень удобный. Общение на русском не проблема, чему я очень рада,тк пока не владею сербским. Планирую посетить это место ещё))', NULL, NULL,
    2, '2023-10-29 00:00:00'),

(@user_mehves_dolerr, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChdDSUhNMG9nS0VJQ0FnSURCbTlMV3RnRRAB',
    5, 'en', 'Very proffesional and modern clinic. Helpful staff. Was a little difficult to get the first appointment because I was speaking only in English but then all was so easy and good.',
    NULL, NULL, 'Very proffesional and modern clinic. Helpful staff. Was a little difficult to get the first appointment because I was speaking only in English but then all was so easy and good.', NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_anna_bikeieva, @clinic_id, @doctor_ivana_srzentic, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChdDSUhNMG9nS0VJQ0FnSUQyX3BXMTF3RRAB',
    5, 'ru', 'Спасибо огромное!! Прекрасный доктор Ивана Срзентич!! Помогла моей дочке с острой болью! Очень приятная и добрая!',
    NULL, NULL, NULL, 'Спасибо огромное!! Прекрасный доктор Ивана Срзентич!! Помогла моей дочке с острой болью! Очень приятная и добрая!', NULL, NULL,
    1, '2022-10-29 00:00:00'),

(@user_nemanja_potpara, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChdDSUhNMG9nS0VJQ0FnSUR5bzVxMTJRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_vladana_garic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChdDSUhNMG9nS0VJQ0FnSURTbC12NHlBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_slobodan_djurisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChdDSUhNMG9nS0VJQ0FnSURza3ZTbHhRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_sanja_zecevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNzaTdxcVZ3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_ana_racichfhfsbkmvsbk, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNnaUxMMWd3RRAB',
    5, 'hr', 'Sve pohvale🏅',
    'Sve pohvale🏅', NULL, NULL, NULL, NULL, NULL,
    1, '2018-10-29 00:00:00'),

(@user_mirjana_nikocevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNBdi15T0pBEAE',
    2, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_andjela_vukotic, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNROHBTYUt3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2017-10-29 00:00:00'),

(@user_mevljud_amet, @clinic_id, NULL, 'google_maps',
    'places/ChIJg_lkyoTUTRMRCKjZP3Y_mxo/reviews/ChZDSUhNMG9nS0VJQ0FnSURRck5qbFN3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2017-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
