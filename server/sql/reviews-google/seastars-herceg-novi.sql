-- Insert Google Maps reviews for SeaStars “edukativni centar”
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/seastars-herceg-novi.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'seastars-herceg-novi');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_dragana_popovic = (SELECT id FROM doctors WHERE slug = 'dragana-popovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Gacevic', 'https://lh3.googleusercontent.com/a-/ALV-UjUSVXE-AemkY9WcYP8J3AmE7reEHbVGX7TSoq607BVVggJJQ7KVOA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111164567421587193298/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111164567421587193298/reviews');
SET @user_jelena_gacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111164567421587193298/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, '!?', 'https://lh3.googleusercontent.com/a-/ALV-UjWw4npOGUjh0MNSuV22KOgMjtm2a-1C4pCgWTwdY-tYef1O7916=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/104940041678974339499/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104940041678974339499/reviews');
SET @user_user_104940041678974339499 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104940041678974339499/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelka Ukropina', 'https://lh3.googleusercontent.com/a-/ALV-UjUrAkNLy3kEqua65O97tsIGqbwuH-pCaBgKQT8YD1GWMzRagTs=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/100062229338586851878/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100062229338586851878/reviews');
SET @user_jelka_ukropina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100062229338586851878/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danijela Sijerkovic', 'https://lh3.googleusercontent.com/a/ACg8ocKlJqOpvGObiM-Rk-o76BXaFfUE7qT8WIgtcbcZyAArTrm2PA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/102437153813570426111/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102437153813570426111/reviews');
SET @user_danijela_sijerkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102437153813570426111/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Rakocevic', 'https://lh3.googleusercontent.com/a/ACg8ocIFYGpNoZML_gpBbsvxnd6jpA6CB41k-T5N_z8xvJfvwdwdWQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/113087902791069911425/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113087902791069911425/reviews');
SET @user_milica_rakocevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113087902791069911425/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'sofija stojanovic', 'https://lh3.googleusercontent.com/a/ACg8ocJ2H68NaT62v-CTOt8RMD6FvDxTDoAeewUZbFiNw1K2LPs-vQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113393838806366674837/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113393838806366674837/reviews');
SET @user_sofija_stojanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113393838806366674837/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anastasija Đukić', 'https://lh3.googleusercontent.com/a/ACg8ocKusm-70V4Q1E9rnEg0WvoxcNIsIDVKMEuiuf_eQInU_WVPDQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113347013591843165417/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113347013591843165417/reviews');
SET @user_anastasija_uki = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113347013591843165417/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vesna Starovlah', 'https://lh3.googleusercontent.com/a/ACg8ocIjkBdhtROQRFrrMpsV3WWxVmae3PAICfsZTSn2Sqczn6HlKg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113442112536748348245/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113442112536748348245/reviews');
SET @user_vesna_starovlah = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113442112536748348245/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Grdinic', 'https://lh3.googleusercontent.com/a/ACg8ocItFptfUbyxVLPsBGfaTn32FXkxeIFUkT0O0kFGSqq2Lt_AhCI=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101406691927981802229/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101406691927981802229/reviews');
SET @user_jelena_grdinic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101406691927981802229/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Savovic 2', 'https://lh3.googleusercontent.com/a-/ALV-UjUnhFX756nASCOJqY6oEHBvSDl1T1wZHLyK4fELLeyChayyiAqk=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100118504106980038146/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100118504106980038146/reviews');
SET @user_savovic_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100118504106980038146/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kristina Pavićević', 'https://lh3.googleusercontent.com/a/ACg8ocJ7cJTRtNUe-1IQFd1KaN2TClmgnFuZvoeNjog248yL8gaKFg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110995264552410124087/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110995264552410124087/reviews');
SET @user_kristina_pavievi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110995264552410124087/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Aleksic', 'https://lh3.googleusercontent.com/a/ACg8ocIoSj18azBQZNW_X9njPg2VAEhyK3ITYi6z9bJ5scDiMFMLdA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106893719202455507718/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106893719202455507718/reviews');
SET @user_marija_aleksic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106893719202455507718/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Goran Baltic', 'https://lh3.googleusercontent.com/a/ACg8ocLrC8zZ5pqqGq6vVn8wulstwJioh0wtHV4j_v0nQ29CRIaPiw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118130680470456830955/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118130680470456830955/reviews');
SET @user_goran_baltic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118130680470456830955/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kristina Tripkovic', 'https://lh3.googleusercontent.com/a/ACg8ocJkTN6ufSqnSxbFDxnMkEPe2PaavjwV7g_6dDgjy9Ceu6-PAg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103232222338594007166/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103232222338594007166/reviews');
SET @user_kristina_tripkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103232222338594007166/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Irena Damjanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVHUD-x5YOVcaXB9pX8UHbYntHWk8BQVLGds1BHSN6ZuWQQcfffiw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104259666154984422630/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104259666154984422630/reviews');
SET @user_irena_damjanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104259666154984422630/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sara Slavic', 'https://lh3.googleusercontent.com/a/ACg8ocLYhDskCaEnVceinUZLMLY86GC_eJb3Xj4TPiafSFbcYzvMQg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109003037981360337127/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109003037981360337127/reviews');
SET @user_sara_slavic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109003037981360337127/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vojislav Uljarević', 'https://lh3.googleusercontent.com/a-/ALV-UjU5vF51U5avUaYmHHpjFpjR2d6JhvGBZYIRm8mhOmthb_OQzx2t=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105839347467824096971/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105839347467824096971/reviews');
SET @user_vojislav_uljarevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105839347467824096971/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojana Marsenic', 'https://lh3.googleusercontent.com/a/ACg8ocL8Kn2WkVLh6vTKbuRL7-vDV8kpKodqXL7ay3-z5TjZxc6Txg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109153789645229587496/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109153789645229587496/reviews');
SET @user_bojana_marsenic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109153789645229587496/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nemanja Tomkovic', 'https://lh3.googleusercontent.com/a/ACg8ocL_6eliUqX1EPa5MdghUt98z7d8bPAwSpGmgQRkTaQ3MUPqAA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104960805763543143537/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104960805763543143537/reviews');
SET @user_nemanja_tomkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104960805763543143537/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bobana Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocIOFZ4TiIJrhu8UnRw8P_ByJKkEAtiirWvtM0Y0uv71xpyMkw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109472540787419293459/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109472540787419293459/reviews');
SET @user_bobana_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109472540787419293459/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dejan Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocIbx8OqFGX3IVXF-zMawn-N8VZWXojLWw5mNpSY_4v-rk-20Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105979434064005093844/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105979434064005093844/reviews');
SET @user_dejan_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105979434064005093844/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Slavka Lakčević', 'https://lh3.googleusercontent.com/a/ACg8ocJbUedWDTBp0yO6lZvr2iNjdvrM9lU4BJRF3LytpetKxS5WFQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102631482273297428214/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102631482273297428214/reviews');
SET @user_slavka_lakevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102631482273297428214/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olivera Jelic', 'https://lh3.googleusercontent.com/a/ACg8ocLcKLH0daMh68-CEQEyYR7yVmeokIBy24ZH-42cYue5YCLBqg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105745663706669068028/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105745663706669068028/reviews');
SET @user_olivera_jelic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105745663706669068028/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'NVO Maskaproduction', 'https://lh3.googleusercontent.com/a-/ALV-UjU6IRJxOsfBgVKEIC-aImmFCptkr5NTaoihW75J2Medkureww=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111576648431808443547/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111576648431808443547/reviews');
SET @user_nvo_maskaproduction = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111576648431808443547/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Isidora Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocI07TMv1oJeyEitcZOBqTqHSzVF0zMLmyDaKfp7Ynn9h1L93w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111252659764494331142/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111252659764494331142/reviews');
SET @user_isidora_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111252659764494331142/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'pit bull pit bull', 'https://lh3.googleusercontent.com/a/ACg8ocIZYNfQjMlqgPtkmDrDA1vUFBPVTEyP0-bM0SEWb-OyOIzcxw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104651486551743490193/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104651486551743490193/reviews');
SET @user_pit_bull_pit_bull = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104651486551743490193/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja Sanja', 'https://lh3.googleusercontent.com/a/ACg8ocJFSEWZ2NSjMObYtL9rLN1CMODkcMxWJaW9ABLfjVV5TPq4Sw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101349217672902142720/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101349217672902142720/reviews');
SET @user_sanja_sanja = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101349217672902142720/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milena Saro Wines', 'https://lh3.googleusercontent.com/a-/ALV-UjVpGcIwSRuGdVTjwDDeaMpw2Cxt14onZA6ms5l47J7EmrozNSw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100165761979397338622/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100165761979397338622/reviews');
SET @user_milena_saro_wines = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100165761979397338622/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Biljana Bojovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVg_fXFUwXHnQtO2R2_AgcJPlLfatRvofBz03oUuilz05RzaduMvw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109063361837098679106/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109063361837098679106/reviews');
SET @user_biljana_bojovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109063361837098679106/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Todorovic', 'https://lh3.googleusercontent.com/a/ACg8ocJXB3Q5DehR3BXqgpRHA2nUp31-dMgPdPZX-iWMXalMmS79UQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100660099154390924836/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100660099154390924836/reviews');
SET @user_dragana_todorovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100660099154390924836/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojana Drpic', 'https://lh3.googleusercontent.com/a-/ALV-UjVzID7IPoOGuvnC6Kppg-azI4odht8hJ4xws4MIDRrPKvVcxR50=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106578486842415014802/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106578486842415014802/reviews');
SET @user_bojana_drpic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106578486842415014802/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljiljana Jaric Maslak', 'https://lh3.googleusercontent.com/a-/ALV-UjX2JqUBp-nSMChhwRjcXRd30NMExs_Q9RhU-EVVlcbzh0ZQ464=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111251577442454194059/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111251577442454194059/reviews');
SET @user_ljiljana_jaric_maslak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111251577442454194059/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nina Milinic', 'https://lh3.googleusercontent.com/a/ACg8ocIuJ9Sdh-eakdgNeqs-pBWtaHU0LMiABJuzUnU6SZeukRS9cA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103579927675742689302/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103579927675742689302/reviews');
SET @user_nina_milinic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103579927675742689302/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra Milic', 'https://lh3.googleusercontent.com/a/ACg8ocIfYfBAP8gRTq5eb5Im2E6AjAz2Vl4EXLDwoUwgjuhZw_vvnw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111720694917836358184/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111720694917836358184/reviews');
SET @user_aleksandra_milic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111720694917836358184/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirela Dasic', 'https://lh3.googleusercontent.com/a/ACg8ocKY4Fi9uc2bDkOr8oYJks06XnFf8xY_U7aVAuARgwEZxgubMQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106544971146120940616/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106544971146120940616/reviews');
SET @user_mirela_dasic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106544971146120940616/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikolina Nenezic', 'https://lh3.googleusercontent.com/a/ACg8ocKgRVvDP4cey4vTMDTJX8Abp1ZEiEneN5f_fnY0_aAEg39DMg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113977110978196328406/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113977110978196328406/reviews');
SET @user_nikolina_nenezic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113977110978196328406/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Emina Hajdarpasic', 'https://lh3.googleusercontent.com/a/ACg8ocI8hcrByZhIOX1ZmzrhZbPK2mekY0GAUXGevcKLlwcOTkgYvQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115277415071328723664/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115277415071328723664/reviews');
SET @user_emina_hajdarpasic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115277415071328723664/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Gradistanac', 'https://lh3.googleusercontent.com/a-/ALV-UjVABW3d11IfNgqVuFHrTIoi6Lgxz5klMas0CMQj2dwHDxGg7tEA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115573752071147052456/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115573752071147052456/reviews');
SET @user_jelena_gradistanac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115573752071147052456/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maša Rakočević', 'https://lh3.googleusercontent.com/a/ACg8ocKZLuRzCv5KtixXQNBHswD_JHTOZBpMQKStV5fL78I4ibm2yg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105198222798365613543/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105198222798365613543/reviews');
SET @user_maa_rakoevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105198222798365613543/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milo Janjusevic', 'https://lh3.googleusercontent.com/a/ACg8ocIvePP6DqEJsbx4BO_tiPHT7zins-6jJFUOXbusqWdX-LAM4w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104606831181425939170/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104606831181425939170/reviews');
SET @user_milo_janjusevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104606831181425939170/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Barjaktarovic', 'https://lh3.googleusercontent.com/a/ACg8ocKZ-rj51M5fX9umoMp0fe5TxThvW_Ze0ETNVmMm9-P-hgj1yA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116719228063495105463/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116719228063495105463/reviews');
SET @user_ivana_barjaktarovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116719228063495105463/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dijana Loncar', 'https://lh3.googleusercontent.com/a/ACg8ocKsQM888WbQlqK8mn6OX0GQbn0l1G37-x1re1pKjpHFNjV8dg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110488958880489111982/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110488958880489111982/reviews');
SET @user_dijana_loncar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110488958880489111982/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Kuc', 'https://lh3.googleusercontent.com/a/ACg8ocLp8egd9NaF2lwFdW8nE5qXWvYWmatr002Y1RQc-85hOqPPgg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109277104893359336620/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109277104893359336620/reviews');
SET @user_marija_kuc = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109277104893359336620/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra Scekic', 'https://lh3.googleusercontent.com/a-/ALV-UjVN55U7JJC4ewxDA0JjAjYhCxjO7cF7Bx2ALZ8lI4gpsGTRCeZzfw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116024587254845209886/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116024587254845209886/reviews');
SET @user_aleksandra_scekic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116024587254845209886/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Irena Buric', 'https://lh3.googleusercontent.com/a-/ALV-UjXwgpeZpiSTdkoCU7S4Aa_pCAcBRZH3RTsKLQGoJ9aiXhur3xac=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107386796291067432882/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107386796291067432882/reviews');
SET @user_irena_buric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107386796291067432882/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pedja Soskic', 'https://lh3.googleusercontent.com/a-/ALV-UjUe399fbCGjsNSTe11HVuKosARyea9e_mwAWq06J7-4FNrTi-Ik=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115257579753959217881/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115257579753959217881/reviews');
SET @user_pedja_soskic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115257579753959217881/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tiana Šaranović', 'https://lh3.googleusercontent.com/a/ACg8ocLu5jyj8bjvYKakgVd8PUYNmNgHbZZZoAqYKnjlJ-uwENlbZw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109478670369552369918/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109478670369552369918/reviews');
SET @user_tiana_aranovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109478670369552369918/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tanja Vojinovic', 'https://lh3.googleusercontent.com/a/ACg8ocJIPkc6eXjJIFcnw8sYsEe9yfSHXwMMywea3cIODHiJu41V8A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114967567835992830707/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114967567835992830707/reviews');
SET @user_tanja_vojinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114967567835992830707/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Violeta Lazarevic', 'https://lh3.googleusercontent.com/a/ACg8ocJK4BttmyJwB86HCxukvRM_xbunss8sjul2uy3RWTWLU45XKQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100132597081987483861/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100132597081987483861/reviews');
SET @user_violeta_lazarevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100132597081987483861/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Kujundzic', 'https://lh3.googleusercontent.com/a/ACg8ocKBFpgBUoc-4JLwcoqCqsbx2gY8t2khl6qQ4ESvXJB-5ey09w=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110619805318396416520/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110619805318396416520/reviews');
SET @user_jelena_kujundzic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110619805318396416520/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirjana Kovacevic', 'https://lh3.googleusercontent.com/a/ACg8ocIiYOwY6qJlDWwC9aw11e0Z_HwnqAKUiSsBJZHaagEe_xX2Dg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117776120965450391895/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117776120965450391895/reviews');
SET @user_mirjana_kovacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117776120965450391895/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladimir Vuckovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWtXWCH9b1AHGMmT-rOdWHVumyNHpc93o2FMm4t9suMYgr8LrxD=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105800806929930314221/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105800806929930314221/reviews');
SET @user_vladimir_vuckovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105800806929930314221/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Matković', 'https://lh3.googleusercontent.com/a-/ALV-UjXrYxCPlLp4-oXyctNGIAKIJtIqYEcNY6L5y5SZDBuu-nmV7jmA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112756509016275232101/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112756509016275232101/reviews');
SET @user_jelena_matkovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112756509016275232101/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Filip Sjekloca', 'https://lh3.googleusercontent.com/a/ACg8ocIGpFvc3OSTb5e_ADGF2O3QKNNRE66a1rD77U00AvKcqEUBiw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117000038659033033904/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117000038659033033904/reviews');
SET @user_filip_sjekloca = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117000038659033033904/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja Jasovic', 'https://lh3.googleusercontent.com/a-/ALV-UjV2eK5MA-L2WVGXBZnlsaO4SWzKyH2VpYANBtFmR5VODE3GQAB5=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114227875477939715670/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114227875477939715670/reviews');
SET @user_sanja_jasovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114227875477939715670/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Željka Vojinović', 'https://lh3.googleusercontent.com/a/ACg8ocL6wvfgmyxTDQfLzQXQEdy52QaJGuWjmslqin8NvDTN4qx1EQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110227860549009884142/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110227860549009884142/reviews');
SET @user_eljka_vojinovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110227860549009884142/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tatjana Dimitrijevic', 'https://lh3.googleusercontent.com/a-/ALV-UjXOVguW1S64ySuj_kCeVnekIu1g1THZ4FGIP3BGbnod3Bbanpc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116422107036462106407/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116422107036462106407/reviews');
SET @user_tatjana_dimitrijevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116422107036462106407/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Amanda Kukaj', 'https://lh3.googleusercontent.com/a/ACg8ocJrozUanwsmiEhR-2lHrjTxAu6ZsWeGkJqG_zKmlapBNjI3hQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108713272605812735650/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108713272605812735650/reviews');
SET @user_amanda_kukaj = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108713272605812735650/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Vojinovic', 'https://lh3.googleusercontent.com/a/ACg8ocJnibY2FT9jvdGQ5Y6jglRlNmpnMRwc-6KaeBBbyUI2-0z75A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117839964302261286632/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117839964302261286632/reviews');
SET @user_luka_vojinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117839964302261286632/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Vojinović', 'https://lh3.googleusercontent.com/a-/ALV-UjWRKAfaT_KlAq_b_V9ftrsTT1T9Xska9lkbgG5AHxHqmRjiuzykEQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108567788630902368717/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108567788630902368717/reviews');
SET @user_luka_vojinovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108567788630902368717/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Goca Gocki87', 'https://lh3.googleusercontent.com/a/ACg8ocLjT-acsA4Sui6tNFNu3KohF0VX_nqrb2U5PPSH69IbkIKCZg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107656024114597006299/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107656024114597006299/reviews');
SET @user_goca_gocki87 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107656024114597006299/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Teodora Maksimovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVw7fieDWGAoTsP0Q5RprHlTiSFcFNVzBWMY4WNr91Ty5Fre6M=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108911393102289970174/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108911393102289970174/reviews');
SET @user_teodora_maksimovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108911393102289970174/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Damjan Tomić', 'https://lh3.googleusercontent.com/a-/ALV-UjWokk6Ha8eZebNV2zWVJkhwgmR6nfRMPVMbYwoagbZn1ilo1ObI=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111155058541896749001/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111155058541896749001/reviews');
SET @user_damjan_tomi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111155058541896749001/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stanka K', 'https://lh3.googleusercontent.com/a/ACg8ocJ3hZ-yOiv3FznJX3EBberGWd1P1j0P78BqNDkK6igx9BjDfg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116879911700816468566/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116879911700816468566/reviews');
SET @user_stanka_k = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116879911700816468566/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tanja Colakovic', 'https://lh3.googleusercontent.com/a/ACg8ocKohEGVlYCiOrHskWVUXQ7SfuV1uanV1k20Ldt4BNdottmRJg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107431576894384564986/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107431576894384564986/reviews');
SET @user_tanja_colakovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107431576894384564986/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Valentina Filipovic', 'https://lh3.googleusercontent.com/a/ACg8ocJCO1WkgtjqoizF-r8ouHUG-7ajAOLlVacSjGOy2VfdlVSYQA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101168908933517567799/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101168908933517567799/reviews');
SET @user_valentina_filipovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101168908933517567799/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Valerija Pekic', 'https://lh3.googleusercontent.com/a/ACg8ocIMkNMBqMf6jd0tIuL64wXx_SG5PNpR697l36WqzAhhqPKReA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112065762116668629164/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112065762116668629164/reviews');
SET @user_valerija_pekic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112065762116668629164/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovanka Jovanka', 'https://lh3.googleusercontent.com/a-/ALV-UjVNPHhxexYCjSIe-iXuvPwB5pLaoWrn1jfD0gPUpS9u9uwK1JQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116505011817182917465/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116505011817182917465/reviews');
SET @user_jovanka_jovanka = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116505011817182917465/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Александра М.', 'https://lh3.googleusercontent.com/a-/ALV-UjXyJQ2TiTRP3KBSvYNU8XK4wghcO5y0qzrMe0VhlbUO2RHSlKs0sA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116383872119411066289/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116383872119411066289/reviews');
SET @user_aleksandra_m = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116383872119411066289/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lidija Leovac', 'https://lh3.googleusercontent.com/a/ACg8ocK88XoK4vOjanIlaS9VNgxSCYUkTgVSIF6O9Yh_JxFPUSQjYA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113075707916124442951/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113075707916124442951/reviews');
SET @user_lidija_leovac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113075707916124442951/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dino Bajraktarević', 'https://lh3.googleusercontent.com/a-/ALV-UjXwzaEIp_tpUZpMXq7Hmctc-x4gBbE2i6WbrJs6OKzu-yEOTFI=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118017056509960449715/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118017056509960449715/reviews');
SET @user_dino_bajraktarevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118017056509960449715/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Magda Miranovic', 'https://lh3.googleusercontent.com/a/ACg8ocJpnA8_jRidnn9UnyOw-6EDRnVoz_P51rsHKJKWIewhmZZ27Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101333618864764078696/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101333618864764078696/reviews');
SET @user_magda_miranovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101333618864764078696/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ivana uljarevic', 'https://lh3.googleusercontent.com/a/ACg8ocJjEoOOtwFNux2xvso-al2afzc6CDJbbZGqjRAQgXYAhYOfuQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104118203872302410507/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104118203872302410507/reviews');
SET @user_ivana_uljarevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104118203872302410507/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocIqrSbJjQX-pYTscnk4j13UQkIe1bbg14o1Yd_kr-vhbV5s8Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113837668072468848902/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113837668072468848902/reviews');
SET @user_jovana_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113837668072468848902/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milan Simrak', 'https://lh3.googleusercontent.com/a/ACg8ocKciCcdOYc38ye4rZLS8xPXINuwfD4yiV6xHxEaYC9wSfJoeQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115862908652030624473/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115862908652030624473/reviews');
SET @user_milan_simrak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115862908652030624473/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Lazovic', 'https://lh3.googleusercontent.com/a/ACg8ocKlE5aBIO7ry344neo4rQUQBHMpQLlI3URtkjiszf3PozwGqA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114513112530616444615/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114513112530616444615/reviews');
SET @user_jovana_lazovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114513112530616444615/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ranka Djurovic', 'https://lh3.googleusercontent.com/a/ACg8ocKxMg5UPeahm8RKC32JZCllRgvjCqu5S4P2iP-UODloQnezVw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114977134316461199332/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114977134316461199332/reviews');
SET @user_ranka_djurovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114977134316461199332/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tina', 'https://lh3.googleusercontent.com/a-/ALV-UjWsMql0vHw1QqdTL7tWW7cjzfeJnbqnDMWJbkevqUcNqfQZuxyj=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103127901214684392911/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103127901214684392911/reviews');
SET @user_tina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103127901214684392911/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Snezana Kovacevic', 'https://lh3.googleusercontent.com/a/ACg8ocK0O2vpfhQuflFtYPPI9oUgFjsSH_4C3IBZ_WKU2kxNaoXSEQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115065402752741174606/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115065402752741174606/reviews');
SET @user_snezana_kovacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115065402752741174606/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sandra Obradovic', 'https://lh3.googleusercontent.com/a/ACg8ocJaay6K-HGknOmVNsMauKHnnwtamby3TlmncG6_GyuRQiU-jQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114186487488015747942/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114186487488015747942/reviews');
SET @user_sandra_obradovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114186487488015747942/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Zmukic', 'https://lh3.googleusercontent.com/a/ACg8ocJxKxA7pjHaTGrmrUir_DDOwzTr6zF1FzpihcO95eq30dUSag=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110325852424106402821/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110325852424106402821/reviews');
SET @user_marija_zmukic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110325852424106402821/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Tunguz', 'https://lh3.googleusercontent.com/a/ACg8ocKjw7O8j4dVo0DqEUipNF4kxFeGeO1TvnV8qlvjNjIgQYGE4Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111888094357097242555/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111888094357097242555/reviews');
SET @user_jovana_tunguz = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111888094357097242555/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivona Tomasevic', 'https://lh3.googleusercontent.com/a/ACg8ocJQT6_u6fhquvVm1AhzI7rLj7fWTbNYFBao2DPShBQ5T_y4aQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107409205324800883252/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107409205324800883252/reviews');
SET @user_ivona_tomasevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107409205324800883252/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tanja Suran', 'https://lh3.googleusercontent.com/a/ACg8ocKZZJo7iOEkhgNjCxbFopxOksJUG8xNoXlKsO4U7vlVvbcJEQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116225929195191492424/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116225929195191492424/reviews');
SET @user_tanja_suran = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116225929195191492424/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Pejakovic', 'https://lh3.googleusercontent.com/a/ACg8ocILXwd08SwDLlIhjamOT8g0jTXu2gwhI142rWYLIjXWf6o71g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113674072653489344839/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113674072653489344839/reviews');
SET @user_ivana_pejakovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113674072653489344839/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'maja novakovic', 'https://lh3.googleusercontent.com/a/ACg8ocKCp1PpzYgVmfYQBhixiSuJr4s9kz_h__cVzvxQ-JGgnusJaw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107284512782871654112/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107284512782871654112/reviews');
SET @user_maja_novakovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107284512782871654112/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Vujisic', 'https://lh3.googleusercontent.com/a-/ALV-UjW77UYCrgst82JfEn3hmPxnp1HqTpO04Kxyl2rNMK8pOWsv3CEA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107866594211529074510/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107866594211529074510/reviews');
SET @user_ivana_vujisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107866594211529074510/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_jelena_gacevic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WalZsOUtha2xUYW13elJVazBWVll0U0RoSVJHYxAB',
    5, 'sr', 'Имали смо срећу да у пар наврата физиотарапеуткиња Војте Драгана Поповић у најранијем добу  ради  са мојим сином! Могу да кажем да сам презадовољна колико је посвећена, професионална и упорна.
Што се тиче вјежби по Војте, на правом сте мјесту!',
    'Imali smo sreću da u par navrata fiziotarapeutkinja Vojte Dragana Popović u najranijem dobu  radi  sa mojim sinom! Mogu da kažem da sam prezadovoljna koliko je posvećena, profesionalna i uporna.
Što se tiče vježbi po Vojte, na pravom ste mjestu!', 'Имали смо срећу да у пар наврата физиотарапеуткиња Војте Драгана Поповић у најранијем добу  ради  са мојим сином! Могу да кажем да сам презадовољна колико је посвећена, професионална и упорна.
Што се тиче вјежби по Војте, на правом сте мјесту!', NULL, NULL, NULL, NULL,
    0, '2025-11-10 03:49:29'),

(@user_user_104940041678974339499, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xNNGEyTTBOMXB5U210bk5UZExNbk01V1ZSaE9FRRAB',
    5, 'sr', 'Свака част терапеуткињи!!',
    'Svaka čast terapeutkinji!!', 'Свака част терапеуткињи!!', NULL, NULL, NULL, NULL,
    0, '2026-01-13 12:11:33'),

(@user_jelka_ukropina, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxVWNFcGZRMUptTVZGek9HaHVlVkZVYzFkWFJVRRAB',
    5, 'hr', 'Prvi edukativni centar ovog tipa u gradu I siroj okolini...Odlican tim strucnjaka savremeni pristup I izuzetna posvecenost svakom djetetu.Veliki doprinos zajednici I ogromna podrska roditeljima.Sve preporuke.Lijepo sto postojite !',
    'Prvi edukativni centar ovog tipa u gradu i okolini... Odličan tim stručnjaka, moderan pristup i izuzetna posvećenost svakom detetu. Veliki doprinos zajednici i velika podrška roditeljima. Sve preporuke. Lepo je što postojiš!', 'Први едукативни центар овог типа у граду и околини... Одличан тим стручњака, модеран приступ и изузетна посвећеност сваком детету. Велики допринос заједници и велика подршка родитељима. Све препоруке. Лепо је што постојиш!', NULL, NULL, NULL, NULL,
    0, '2025-11-06 12:52:32'),

(@user_danijela_sijerkovic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCR2RsbHBaV053WlRkb2VrSnlSV1oyU1VSTlEwRRAB',
    5, 'bs', 'Sjajan edukativni centar, nešto što je našem gradu baš nedostajalo, sa vrhunskim timom stručnjaka, na čelu sa našom Draganom.
Sve preporuke!
Puno uspijeha u daljem radu!🍀',
    'Sjajan edukativni centar, nešto što je zaista nedostajalo našem gradu, sa odličnim timom stručnjaka, predvođenim našim Draganom.
Sve preporuke!
Srećno u daljem radu!🍀', 'Сјајан едукативни центар, нешто што је заиста недостајало нашем граду, са одличним тимом стручњака, предвођеним нашим Драганом.
Све препоруке!
Срећно у даљем раду!🍀', NULL, NULL, NULL, NULL,
    0, '2025-11-05 16:03:11'),

(@user_milica_rakocevic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GNU9VaENjSGt4T0hONVN6bDVUR2hyVWpKeGNHYxAB',
    5, 'hr', 'Imala sam priliku da sarađujem sa terapeutkinjom Draganom koja je radila sa mojim djetetom i želim da izrazim iskreno zadovoljstvo njenim radom. Pokazala je visok nivo stručnosti, posvećenosti i topline u pristupu. Njena strpljivost, razumijevanje i iskrena briga za dijete doprinijeli su velikom napretku i osjećaju povjerenja. Od srca je preporučujem svakom roditelju koji traži stručnu i empatičnu podršku za svoje dijete.',
    'Imala sam priliku da radim sa terapeutom Draganom koja je radila sa mojim detetom i želim da izrazim iskreno zadovoljstvo njenim radom. Pokazala je visok nivo stručnosti, posvećenosti i topline u svom pristupu. Njeno strpljenje, razumevanje i iskrena briga o detetu doprineli su velikom napretku i osećaju poverenja. Od srca je preporučujem svakom roditelju koji traži profesionalnu i empatičnu podršku za svoje dete.', 'Имала сам прилику да радим са терапеутом Драганом која је радила са мојим дететом и желим да изразим искрено задовољство њеним радом. Показала је висок ниво стручности, посвећености и топлине у свом приступу. Њено стрпљење, разумевање и искрена брига о детету допринели су великом напретку и осећају поверења. Од срца је препоручујем сваком родитељу који тражи професионалну и емпатичну подршку за своје дете.', NULL, NULL, NULL, NULL,
    0, '2025-11-05 18:20:59'),

(@user_sofija_stojanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKTVprbExWbkJ2ZFdWcGVHSTRUbmhIVEV0RExVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-24 00:00:00'),

(@user_anastasija_uki, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kS1NrSndWbTlQTlVVd1VIUjVUWFpmWlRSTFgyYxAB',
    5, 'hr', 'SeaStars edukativni centar je pravo mjesto za svakoga ko želi stručan pristup, prijatnu atmosferu i vidljive rezultate. Dragana je izuzetna fizioterapeutkinja – posvećena, pažljiva i uvijek spremna da pomogne. U njenom radu se vide ogromno znanje, iskustvo i ljubav prema poslu. Sve objašnjava jasno i detaljno, a termini su prilagođeni svakom klijentu pojedinačno.
Pored profesionalnosti, Dragana unosi toplinu i pozitivnu energiju u svaki susret, pa se u njenom centru osjećate opušteno i sigurno. Posebno se izdvaja njena ljudskost, strpljenje i iskrena želja da svakome pruži podršku i pomogne da napreduje. Kod Dragane se ne osjeća samo stručnost već i veliko srce, pažnja i razumijevanje koje svaki susret čine posebnim.
SeaStars nije samo mjesto za tretmane, već i za edukaciju, motivaciju i lični napredak. Dragana je osoba koja svojim radom, znanjem i toplinom uliva povjerenje i ostavlja divan utisak. Zaista je lijepo vidjeti nekoga ko svoj posao radi s toliko ljubavi, predanosti i iskrene brige za druge.
Topla preporuka svima koji žele kvalitet, sigurnost, podršku i osmijeh koji liječi! Dragani svaka čast na svemu što radi i na divnoj energiji koju nesebično dijeli sa drugima. ♥️🥰🍀',
    'SeaStars edukativni centar je pravo mjesto za svakoga ko želi stručan pristup, prijatnu atmosferu i vidljive rezultate. Dragana je izuzetna fizioterapeutkinja – posvećena, pažljiva i uvijek spremna da pomogne. U njenom radu se vide ogromno znanje, iskustvo i ljubav prema poslu. Sve objašnjava jasno i detaljno, a termini su prilagođeni svakom klijentu pojedinačno.
Pored profesionalnosti, Dragana unosi toplinu i pozitivnu energiju u svaki susret, pa se u njenom centru osjećate opušteno i sigurno. Posebno se izdvaja njena ljudskost, strpljenje i iskrena želja da svakome pruži podršku i pomogne da napreduje. Kod Dragane se ne osjeća samo stručnost već i veliko srce, pažnja i razumijevanje koje svaki susret čine posebnim.
SeaStars nije samo mjesto za tretmane, već i za edukaciju, motivaciju i lični napredak. Dragana je osoba koja svojim radom, znanjem i toplinom uliva povjerenje i ostavlja divan utisak. Zaista je lijepo vidjeti nekoga ko svoj posao radi s toliko ljubavi, predanosti i iskrene brige za druge.
Topla preporuka svima koji žele kvalitet, sigurnost, podršku i osmijeh koji liječi! Dragani svaka čast na svemu što radi i na divnoj energiji koju nesebično dijeli sa drugima. ♥️🥰🍀', NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-24 00:00:00'),

(@user_vesna_starovlah, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xZNU1VOUxPRVJIYTFGWk1EWm9TbkZmTldZdFVrRRAB',
    5, 'hr', 'Sve preporuke za Draganu! Izuzetno je stručna, posvećena i strpljiva. Sve detaljno objašnjava i uvijek izdvaja vrijeme da odgovori na sva naša pitanja. Vidi se da iskreno voli svoj posao i radi ga sa puno pažnje i ljubavi. Hvala joj na svemu!',
    'Sve preporuke za Draganu! Izuzetno je stručna, posvećena i strpljiva. Sve detaljno objašnjava i uvijek izdvaja vrijeme da odgovori na sva naša pitanja. Vidi se da iskreno voli svoj posao i radi ga sa puno pažnje i ljubavi. Hvala joj na svemu!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-23 00:00:00'),

(@user_jelena_grdinic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tSWlUzUTJja055Vlc0d2IzUkZUbmh4Y0VGb1luYxAB',
    5, 'hr', 'Ako želite najbolje svom djetetu, to je ovo! Ako želite ljudskost, toplinu, stručnost na najvišem nivou, to je opet ovo!
Predivne Dragana i Iva! Hvala što se osjećamo kao kod kuće! ❤️',
    'Ako želite najbolje svom djetetu, to je ovo! Ako želite ljudskost, toplinu, stručnost na najvišem nivou, to je opet ovo!
Predivne Dragana i Iva! Hvala što se osjećamo kao kod kuće! ❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-15 00:00:00'),

(@user_savovic_2, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GMUxUWnZjVTFmU2kxb2JqaFpVRUpFVUZkZlozYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-08 00:00:00'),

(@user_kristina_pavievi, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT210blRuVlNkV0ZpYlZJdFFUWldlbWRWZUhkMVZXYxAB',
    5, 'bs', 'Za Draganu sam saznala sasvim slucajno, spletom okolnosti. Kada kazu da se tako namjesti. Trebali smo otici kod fizijatra u institutu u Igalu sa bebom od 2 ipo mjeseca. Bilo nam je receno da dodjemo tog petka. Dosli smo, platili uredno, ali nas doktorka nije htjela primiti. Tada smo po preporuci bili proslijedjeni kod Dragane. Ona je jedna veoma strucna zena, a pored toga prijatna, puna razumjevanja i empatije. Sve mi je objasnila i pokazala. Beba ima hipertonus i asimetriju. Nakon 3 dana odbijanja da okrene glavu ka desno, vec posle prvog tretmana je to ucinio. Prezadovoljni smo i prezahvalni. Preporuka od srca 💗',
    'Za Draganu sam saznala sasvim slucajno, spletom okolnosti. Kada kazu da se tako namjesti. Trebali smo otici kod fizijatra u institutu u Igalu sa bebom od 2 ipo mjeseca. Bilo nam je receno da dodjemo tog petka. Dosli smo, platili uredno, ali nas doktorka nije htjela primiti. Tada smo po preporuci bili proslijedjeni kod Dragane. Ona je jedna veoma strucna zena, a pored toga prijatna, puna razumjevanja i empatije. Sve mi je objasnila i pokazala. Beba ima hipertonus i asimetriju. Nakon 3 dana odbijanja da okrene glavu ka desno, vec posle prvog tretmana je to ucinio. Prezadovoljni smo i prezahvalni. Preporuka od srca 💗', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_marija_aleksic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pGb1MzTkpSbXd5VG5sUWJGcG9OVWs0WW5ZeU1FRRAB',
    5, 'hr', 'Sve preporuke! Posvećenost, stručnost i ljubav prema radu sa djecom vide se na svakom koraku!',
    'Sve preporuke! Posvećenost, stručnost i ljubav prema radu sa djecom vide se na svakom koraku!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_goran_baltic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WQk5XeFVYMVY1UmkxblpYWnNVVEZDTTNGdU0zYxAB',
    5, 'hr', 'Stručnost i posvećenost svakom pacijentu....,
Hvala što postoji te!!!!!',
    'Stručnost i posvećenost svakom pacijentu....,
Hvala što postoji te!!!!!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_kristina_tripkovic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GR1kxZ3dhMVZMWDB4d2JtSnZjMGt6TFVGRFVrRRAB',
    5, 'bs', 'Samo zelim da pohvalim rad,trud ,predanost i strpljene ! Prezadovoljna sam nacinom rada,rezultatima . Jedno veliko BRAVO za nasu Draganu !',
    'Samo zelim da pohvalim rad,trud ,predanost i strpljene ! Prezadovoljna sam nacinom rada,rezultatima . Jedno veliko BRAVO za nasu Draganu !', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_irena_damjanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4NWRFWkdhWE55YlVOeFgwRXhMVlIyVldSc1FsRRAB',
    5, 'hr', 'Predani i stručni terapeuti, pristup prema roditelju i djeci je zaista nešto posebno što ova ustanova nudi. Sve preporuke za uspješan rad 🌟🌟🌟🌟🌟',
    'Predani i stručni terapeuti, pristup prema roditelju i djeci je zaista nešto posebno što ova ustanova nudi. Sve preporuke za uspješan rad 🌟🌟🌟🌟🌟', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_sara_slavic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4aVoxZ3hWazFrV2pOWFl6Um9hbGxLYzFaSFUwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_vojislav_uljarevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tGRU5tVk5UWEZIT1hSdVJEWlRXbFpJV1VWek1VRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_bojana_marsenic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSWlQxa3hja1U1Um01aWJYcFVOM2R3U1VKRGFIYxAB',
    5, 'hr', 'Vrlo profesionalan i topao pristup, s puno pažnje i razumijevanja za potrebe bebe. Svaki dolazak bio je ugodno iskustvo, a rezultati terapije su odlični.',
    'Vrlo profesionalan i topao pristup, s puno pažnje i razumijevanja za potrebe bebe. Svaki dolazak bio je ugodno iskustvo, a rezultati terapije su odlični.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_nemanja_tomkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2poRE1FdHRSWE0zWjJWNFQzcHJWRlpuVERoMk9WRRAB',
    5, 'hr', 'Sve pohvale za stručni tim. Profesionalni su i veoma ljubazni. Velika preporuka.',
    'Sve pohvale za stručni tim. Profesionalni su i veoma ljubazni. Velika preporuka.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_bobana_popovic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT200ME5pMXJYMXBSYmpBdE9YUXdPSFV4YkhwalpXYxAB',
    5, 'en', 'Dragana is extremely dedicated to her job and is a person to always push a little more and try to accomplish the most the can. I especially appreciated she would prolong the session if she sees a child can handle it. She has a passion for the work she does and to me, as a parent, that was extremely important because I felt she really, honestly cared instead of just doing her job.

If you are looking for Vojta therapist in Herceg Novi, look no further. She is the best!',
    NULL, NULL, 'Dragana is extremely dedicated to her job and is a person to always push a little more and try to accomplish the most the can. I especially appreciated she would prolong the session if she sees a child can handle it. She has a passion for the work she does and to me, as a parent, that was extremely important because I felt she really, honestly cared instead of just doing her job.

If you are looking for Vojta therapist in Herceg Novi, look no further. She is the best!', NULL, NULL, NULL,
    0, '2025-12-29 00:00:00'),

(@user_dejan_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tOTlkzWTFTVVZaTm5wd01HdDNVVzFoWkhBM01sRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-29 00:00:00'),

(@user_slavka_lakevi, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t0VGQwNWhiV1JOWm5abVlXRTFXblpoZG5admJIYxAB',
    5, 'bs', 'Kada bi samo imali Draganu u Bijelom Polju! Ona postavlja standarde fizioterapije, motiviše roditelje, a djeca je sama biraju...rezultati su neizostavni.
Nadam se da je čuvate kao "malo vode na dlanu" !',
    'Kada bi samo imali Draganu u Bijelom Polju! Ona postavlja standarde fizioterapije, motiviše roditelje, a djeca je sama biraju...rezultati su neizostavni.
Nadam se da je čuvate kao "malo vode na dlanu" !', NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-29 00:00:00'),

(@user_olivera_jelic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21Gc00ybEtVRjkzZGtKdlRuTXhSVWhWV1VSWU5HYxAB',
    5, 'bs', 'Dragana i njen tim su izuzetno strucni i posveceni svom poslu. Vjezbe su prilagodjene potebama klijenta i  u svakom trenutku se pazi na pravilno izvodjenje.
Atmosfera u centru je profesionalna i vrlo prijatna. Topla preporuka svima koji zele kvalitetan, strucan  i personalizovan pristup.',
    'Dragana i njen tim su izuzetno strucni i posveceni svom poslu. Vjezbe su prilagodjene potebama klijenta i  u svakom trenutku se pazi na pravilno izvodjenje.
Atmosfera u centru je profesionalna i vrlo prijatna. Topla preporuka svima koji zele kvalitetan, strucan  i personalizovan pristup.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-29 00:00:00'),

(@user_nvo_maskaproduction, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21VMFpUWkRXamxUUVVGVVlqQkdTR1ZGYlMxRlduYxAB',
    5, 'hr', 'Sve pohvale za tim iz SeaStars-a! Stručni, ljubazni i profesionalni u radu sa djecom. Topla preporuka',
    'Sve pohvale za tim iz SeaStars-a! Stručni, ljubazni i profesionalni u radu sa djecom. Topla preporuka', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_isidora_popovic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21nMVprWlpVVEJRY0hOb0xYUklVRFozVVdaSVJYYxAB',
    5, 'bs', 'Dragana je odlican terapeut, koji pre svega vodi racuna o najbitnijoj stvari, a to je simetrija tela i kicme i gleda do detalja nijasne koje nastanu u svakom trenutku. Svoje znanje nesebicno prenosi roditeljima do detalja kako bi ih osposobila da mogu da ordade svoj deo posla u potpunosti jer jedino tako u kombinaciji sa dobrim terapeutom koji to razume su rezultati sigurni. Usavrsava se stalno i neprekidno nadogradjuje znanje kako bi dala maksimum pacijentu. Daje fokus ranoj intervenciji koja je mnogo bitna u svakom problemu i pokusava da se sto ranije dijagnostikuju potencijalne smetnje kako bi se predupredili brojni problemi kasnije. Sve preporuke!',
    'Dragana je odlican terapeut, koji pre svega vodi racuna o najbitnijoj stvari, a to je simetrija tela i kicme i gleda do detalja nijasne koje nastanu u svakom trenutku. Svoje znanje nesebicno prenosi roditeljima do detalja kako bi ih osposobila da mogu da ordade svoj deo posla u potpunosti jer jedino tako u kombinaciji sa dobrim terapeutom koji to razume su rezultati sigurni. Usavrsava se stalno i neprekidno nadogradjuje znanje kako bi dala maksimum pacijentu. Daje fokus ranoj intervenciji koja je mnogo bitna u svakom problemu i pokusava da se sto ranije dijagnostikuju potencijalne smetnje kako bi se predupredili brojni problemi kasnije. Sve preporuke!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_pit_bull_pit_bull, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s1ck9YcHhVMlZqUjFWbE5FSlRRbHB4VGtKZk5uYxAB',
    5, 'bs', 'Svaka preporuka...posveceni, i.prije svega strucni!!!',
    'Svaka preporuka...posveceni, i.prije svega strucni!!!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_sanja_sanja, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5V1ExaEJPVjlMYkhOTVpXUjZOWE10VUhwc09WRRAB',
    5, 'hr', 'Sve preporuke❤️',
    'Sve preporuke❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_milena_saro_wines, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGaVdGSlNXbVpDUlZsV01GSlRTVWhpVTFWcmEyYxAB',
    5, 'bs', 'Naš sin Ivo je po rođenju imao hipotoniju koja je rezultirala kašnjenjem u motornom razvoju.  Uz konstantnu terapiju i Draganinu veliku pomoć i posvećenost uspjeli smo da ga dovedemo u sjedeći položaj i odatle nastavimo sa mukotrpnim radom. Dragana je terapeut kojem ništa nije teško za pacijenta i zajedno sa roditeljima se bori da terapija da rezultata i pomogne djetetu.',
    'Naš sin Ivo je po rođenju imao hipotoniju koja je rezultirala kašnjenjem u motornom razvoju.  Uz konstantnu terapiju i Draganinu veliku pomoć i posvećenost uspjeli smo da ga dovedemo u sjedeći položaj i odatle nastavimo sa mukotrpnim radom. Dragana je terapeut kojem ništa nije teško za pacijenta i zajedno sa roditeljima se bori da terapija da rezultata i pomogne djetetu.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_biljana_bojovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xWTWRFWjRRa1V0ZVhKaVZHMWxkMFZxTkhwQ1VXYxAB',
    5, 'bs', 'Terapeut koji ima empatije ,izuzetno znanje i pristup kako malim tako i velikim pacijentima ujedno drugarima....jedno rijecu sve pohvale za rad',
    'Terapeut koji ima empatije ,izuzetno znanje i pristup kako malim tako i velikim pacijentima ujedno drugarima....jedno rijecu sve pohvale za rad', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_dragana_todorovic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKVFVHNUJaakppTlRkUVIxTnlhR3BIWVRsbFRrRRAB',
    5, 'bs', 'Sve pohvale za dragu Draganu, posvecenu, njeznu, predanu, pouzdanu terapeutkinju! Svako dobro! 🤩😘',
    'Sve pohvale za dragu Draganu, posvecenu, njeznu, predanu, pouzdanu terapeutkinju! Svako dobro! 🤩😘', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_bojana_drpic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21oQ05sSjJZbmd0ZFd4U2VWQkdNWEppUW5VeFZIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_ljiljana_jaric_maslak, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tkQ1QwbElSVXRqVVdFdE0wNXVXbk5XZVdZMFpGRRAB',
    5, 'hr', 'Sve pohvale i puno uspeha u daljem radu.....',
    'Sve pohvale i puno uspeha u daljem radu.....', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_nina_milinic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xjMllrUnhjV2xxZVVWbmNUaEZjV1ZOU0hWeFlWRRAB',
    5, 'bs', 'Dragana nam je mnogo pomogla svojim predanim i odgovornim radom. Sve preporuke za nju.',
    'Dragana nam je mnogo pomogla svojim predanim i odgovornim radom. Sve preporuke za nju.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_aleksandra_milic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT210TWMwbENabEJSZVhBeFNsSTNRbDlGU21jNGEzYxAB',
    5, 'hr', 'Sve pohvale i tople preporuke za našu terapeutkinju Draganu❤️😊💪',
    'Sve pohvale i tople preporuke za našu terapeutkinju Draganu❤️😊💪', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_mirela_dasic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoQloyVldja2xJV1daeVFVVmFVbFJhYmpCRFgzYxAB',
    5, 'bs', 'Ne poznajem boljeg djecijeg terapeuta a ni predanijeg svom poslu od nase Dragane Popovic.Gago moja, zelim da se u potpunosti ostvaris u onome sto najvise volis i cemu stremis.I da ces biti najveca podrska i pomoc svim malim i velikim drugarima u njihovom ozdravljenju.
♥️♥️♥️',
    'Ne poznajem boljeg djecijeg terapeuta a ni predanijeg svom poslu od nase Dragane Popovic.Gago moja, zelim da se u potpunosti ostvaris u onome sto najvise volis i cemu stremis.I da ces biti najveca podrska i pomoc svim malim i velikim drugarima u njihovom ozdravljenju.
♥️♥️♥️', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_nikolina_nenezic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGR1dEQmhWbEpSYzJsSlN6SkpNRWRHVlVWUFIxRRAB',
    5, 'bs', 'Posle operacije kičme, zahvaljujući Dragani, moj oporavak je bio organizovan, siguran i uspješan. Njeno znanje, pristup i energija čine veliku razliku. Sa radošću preporučujem njen edukativni centar svakome ko želi ozbiljan i stručan pristup rehabilitaciji. 👏',
    'Posle operacije kičme, zahvaljujući Dragani, moj oporavak je bio organizovan, siguran i uspješan. Njeno znanje, pristup i energija čine veliku razliku. Sa radošću preporučujem njen edukativni centar svakome ko želi ozbiljan i stručan pristup rehabilitaciji. 👏', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_emina_hajdarpasic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tKTldIVXRWREphYVVWdFpGSnVObDlyT1ZGWFZGRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_jelena_gradistanac, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s1blJXNUxYM05KUkdFemRpMWhiSFp4YUVwdk9XYxAB',
    5, 'hr', 'Sve preporuke za predivnu Gagu! 🥳🌷💕',
    'Sve preporuke za predivnu Gagu! 🥳🌷💕', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_maa_rakoevi, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSdVEzTkZSR0ZYTXpsa2FubFNkWGhpYURWSGFsRRAB',
    5, 'hr', 'Toplo preporučujem fizioterapeutkinju Draganu zbog njene ogromne stručnosti, profesionalnog pristupa i empatije prema pacijentima.',
    'Toplo preporučujem fizioterapeutkinju Draganu zbog njene ogromne stručnosti, profesionalnog pristupa i empatije prema pacijentima.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_milo_janjusevic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2sweExWTm9OVTQxUTJSRmRDMUVTa2RUYzIxRFNYYxAB',
    5, 'bs', 'Draganu poznajem dugi niz godina jer sam roditelj čija su djeca bila na fizikalnom tretmanu kod nje.
Pored izuzetnih ljudskih kvaliteta i toplog i nenametljivog pristupa u radu sa djecom, Dragana je osoba koja posjeduje najviše stepene stručnih kvalifikacija za primjenu Bobath koncepta i Vojtine metode habilitacije neurorizične djece, uz obimno znanje i iskustvo i iz ostalih metoda koje tretiraju ovu problematiku. Sva djeca i roditelji koji dođu kod nje na tretman, na pravoj su adresi.

Želim mnogo uspjeha u radu!',
    'Draganu poznajem dugi niz godina jer sam roditelj čija su djeca bila na fizikalnom tretmanu kod nje.
Pored izuzetnih ljudskih kvaliteta i toplog i nenametljivog pristupa u radu sa djecom, Dragana je osoba koja posjeduje najviše stepene stručnih kvalifikacija za primjenu Bobath koncepta i Vojtine metode habilitacije neurorizične djece, uz obimno znanje i iskustvo i iz ostalih metoda koje tretiraju ovu problematiku. Sva djeca i roditelji koji dođu kod nje na tretman, na pravoj su adresi.

Želim mnogo uspjeha u radu!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_ivana_barjaktarovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25ZMWVUWkhUbkpxYkdsSFl6RmhSMlJaZERVMlluYxAB',
    5, 'sl', 'Najboljiiii ❤️❤️',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_dijana_loncar, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kbVpFWmpZM2cyU25VMWFuWndhamhEUWtORWRWRRAB',
    5, 'en', 'The best!!',
    NULL, NULL, 'The best!!', NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_marija_kuc, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2taMFptTXhkVWN6Y21SM05EQTNiM2xEU2psU0xXYxAB',
    5, 'hr', 'Divno je što postojiš, onog dana kad sam te upoznala prepoznala sam taj istinski žar u tebi i da radiš ono što voliš i daješ hiljadu posto sebe i za svu djecu s kojima radiš,. Bravo🙏♥️',
    'Divno je što postojiš, onog dana kad sam te upoznala prepoznala sam taj istinski žar u tebi i da radiš ono što voliš i daješ hiljadu posto sebe i za svu djecu s kojima radiš,. Bravo🙏♥️', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_aleksandra_scekic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21nMmVrTkJhM0E1VjBWbGMyWXpYM2hSUlZwd1FuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_irena_buric, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s1elpGZEVTR2hZTmtkcFVrWnRVMUZ5U1hGSVYxRRAB',
    5, 'hr', 'Sve pohvale i preporuke! Srećna sto sam te upoznala! ❤️',
    'Sve pohvale i preporuke! Srećna sto sam te upoznala! ❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_pedja_soskic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xOb2NIRmhabVJ6U3kxZmMzRmZla1JJVmxSZmVsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_tiana_aranovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21SR1FYZ3lVbGxhVG1kRVJsSnVXRTlCTFVSTGFFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_tanja_vojinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tseWRUSkVUbFJ2UjA0elpuRkNka1ZTUkZCUFMwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_violeta_lazarevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2toNlZWSmxaM0EyZVZRd1MyTmtjR2x3YUY5NWFrRRAB',
    5, 'hr', 'Sve pohvale za profesionalnost i pristup pacijentima! Vidimo se opet i hvala!',
    'Sve pohvale za profesionalnost i pristup pacijentima! Vidimo se opet i hvala!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_jelena_kujundzic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT214SFFqTldkVFpWZWtoVGIyaG1UV1J1WmtWTWNrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_mirjana_kovacevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25jeU9GWnRZVXhKUzJzNU9VWndNMTlIVUdvMlVsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_vladimir_vuckovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25adlZVTkJNVFZZYldGRFVucFNaVGRCV0ZGR05GRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_jelena_matkovi, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2toWGJFeDRSMFpTYVhjek9GcE5SbUZWUmpWaVVWRRAB',
    5, 'hr', 'Sve pohvale za Draganu Popović. Pravi profesionalac u svom poslu. Ovakav centar je zaista trebao našem gradu. Sve preporuke',
    'Sve pohvale za Draganu Popović. Pravi profesionalac u svom poslu. Ovakav centar je zaista trebao našem gradu. Sve preporuke', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_filip_sjekloca, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21WZmFWQldSelp6Vm1oV1gxUjBhbUY0UXpoU1psRRAB',
    5, 'bs', 'Sve preporuke za koleginicu Draganu 👍🙂',
    'Sve preporuke za koleginicu Draganu 👍🙂', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_sanja_jasovic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tKV1drTk9jR0ZTV2xwM09VeE1Na1pJV2pSYU5XYxAB',
    5, 'hr', 'Edukativni centar SeaStars je sjajno mjesto s profesionalnim i posvećenim timom. Posebno želim pohvaliti fizioterapeutkinju Draganu Popović – stručnu, ljubaznu i pažljivu. Zahvaljujući njenom pristupu, rezultati su vidljivi, a svaka terapija prijatna i motivišuća. Topla preporuka!',
    'Edukativni centar SeaStars je sjajno mjesto s profesionalnim i posvećenim timom. Posebno želim pohvaliti fizioterapeutkinju Draganu Popović – stručnu, ljubaznu i pažljivu. Zahvaljujući njenom pristupu, rezultati su vidljivi, a svaka terapija prijatna i motivišuća. Topla preporuka!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_eljka_vojinovi, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25CWVFrTnZjRUoyWHpSUlkwdFhVMWhrU0RaNlRtYxAB',
    5, 'bs', 'Sve preporuke za fizioterapeutkinju Draganu Popovic .Strucna ,profesionalac u svom poslu ,maksimalno posvecena.Dragana je zaista posebna❤️',
    'Sve preporuke za fizioterapeutkinju Draganu Popovic .Strucna ,profesionalac u svom poslu ,maksimalno posvecena.Dragana je zaista posebna❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_tatjana_dimitrijevic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tSME4xTXpRM2hJY1ZWUVFVNTBXRmhtUXkxQ1RXYxAB',
    5, 'bs', 'Dragana je izuzetno posvećen neuro-razvojni i Schroth terapeut.
U njenom Centru za motorni razvoj, prevenciju i korekciju posturalnih deformiteta oseća se mir, znanje i ogromna ljubav prema deci.
Stručna, pažljiva i nežna – pravi oslonac i za roditelje i za bebe.
Od srca preporučujem!',
    'Dragana je izuzetno posvećen neuro-razvojni i Schroth terapeut.
U njenom Centru za motorni razvoj, prevenciju i korekciju posturalnih deformiteta oseća se mir, znanje i ogromna ljubav prema deci.
Stručna, pažljiva i nežna – pravi oslonac i za roditelje i za bebe.
Od srca preporučujem!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_amanda_kukaj, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25OUWVsQTRjSFF4VXpoT05XSXlTMmRZYmtGV1lVRRAB',
    5, 'en', 'Thank you for the incredible care and kindness you’ve shown my daughter,Dragana. Your patience, encouragement, and dedication have made such a difference in her recovery. We’re so grateful for the positive impact you’ve had on her journey.',
    NULL, NULL, 'Thank you for the incredible care and kindness you’ve shown my daughter,Dragana. Your patience, encouragement, and dedication have made such a difference in her recovery. We’re so grateful for the positive impact you’ve had on her journey.', NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_luka_vojinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkM1NqbHZNVzg1ZFVrMlNYQnFNM290YzNRdE0wRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_luka_vojinovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tRME9HUXphR2RvVmt4T1ZHcHFUVTQzY0U0eGQxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_goca_gocki87, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tZM2QyaEJja0pNTUY5WWJITnpMVjkxZDI4MlpYYxAB',
    5, 'hr', 'Dragana je savršen fizioterapeut,puna znanja,razumijevanja i ljubavi koju nesebicno pruza djeci. Sve pohvale i preporuke.',
    'Dragana je savršen fizioterapeut,puna znanja,razumijevanja i ljubavi koju nesebicno pruza djeci. Sve pohvale i preporuke.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_teodora_maksimovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21wQlZ6SlBRMmREYVV0a1pFRndjbW96ZURaT1dXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_damjan_tomi, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWRFVHeHdTbWRUT0dwUGNGTnpSRmxJTWxCSWVVRRAB',
    5, 'hr', 'Fizioterapeutkinja Dragana je izuzetna u svom poslu, uvijek pokazuje veliku posvećenost, pažnju i spremnost da pomogne. Njeni tretmani su profesionalni, efikasni i prilagođeni individualnim potrebama svakog pacijenta. Toplo je preporučujem svima koji traže stručnost uz ljudskost i pozitivnu energiju. 😁',
    'Fizioterapeutkinja Dragana je izuzetna u svom poslu, uvijek pokazuje veliku posvećenost, pažnju i spremnost da pomogne. Njeni tretmani su profesionalni, efikasni i prilagođeni individualnim potrebama svakog pacijenta. Toplo je preporučujem svima koji traže stručnost uz ljudskost i pozitivnu energiju. 😁', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_stanka_k, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25CSFlUQlRVbEJwVDFORVNuUmhVa3hGUmtKVldVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_tanja_colakovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT204MWVtZDZjRFpHUlZsd1lrOVBiMWxqYm5CQk0yYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_valentina_filipovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT210MVoyaFlOekl5UzBJeE9UbGhUVEJuUzJNMGRGRRAB',
    5, 'hr', 'Izvanredan edukativni centar! Stručan i posvećen tim, odličan pristup djeci, i vidljiv napredak kroz svaki susret.
Topla preporuka! ❤️❤️',
    'Izvanredan edukativni centar! Stručan i posvećen tim, odličan pristup djeci, i vidljiv napredak kroz svaki susret.
Topla preporuka! ❤️❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_valerija_pekic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25kQ04yMXFTbFZ2V0ZwUldERnBMWFU0Y0ZaaU5FRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_jovanka_jovanka, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25Gall6VllUWEJwWVhaNFpHMHpkamszZERWSFdHYxAB',
    5, 'hr', 'Najbolji centar',
    'Najbolji centar', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_aleksandra_m, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21zdFRFVnZWVXBzTVZGdWNFTnpYelZzVkhoR2VFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_lidija_leovac, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2sxd2RXMUdObXRvZDBGdk9XeFhTbFE0TVdGemEyYxAB',
    5, 'hr', 'SeaStars edukativni centar je zaista poseban prostor posvećen podršci djeci s teškoćama u razvoju.

Tim čine stručne, empatične i pažljive osobe koje pristupaju svakom djetetu s puno razumijevanja, strpljenja i topline. Njihova želja da pomognu napredovanju djece primjetna je u svakom segmentu rada, a roditelji nerijetko ističu koliko njihov pristup donosi stvarne rezultate.

Topla preporuka za sve koji traže sigurno, stručno i podržavajuće okruženje za svoje dijete. ❤️',
    'SeaStars edukativni centar je zaista poseban prostor posvećen podršci djeci s teškoćama u razvoju.

Tim čine stručne, empatične i pažljive osobe koje pristupaju svakom djetetu s puno razumijevanja, strpljenja i topline. Njihova želja da pomognu napredovanju djece primjetna je u svakom segmentu rada, a roditelji nerijetko ističu koliko njihov pristup donosi stvarne rezultate.

Topla preporuka za sve koji traže sigurno, stručno i podržavajuće okruženje za svoje dijete. ❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_dino_bajraktarevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25keGVHNTZjVU5PUW10SlVHRkZZMWt3TFhaTFMwRRAB',
    5, 'hr', 'Sve pohvale,prije svega dobri ljudi a onda i veliki znalci u svom poslu,tople preporuke svima.👌',
    'Sve pohvale,prije svega dobri ljudi a onda i veliki znalci u svom poslu,tople preporuke svima.👌', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_magda_miranovic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT20xc2MxWTNhazkxWTJKMVluTnJPSGx1WTFCUGNHYxAB',
    5, 'hr', 'Najbolja nasa Dragana,sve preporuke🤩🤩',
    'Najbolja nasa Dragana,sve preporuke🤩🤩', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_ivana_uljarevic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2toaGJXcEJVVW8xWlc0d1MxOUhXa0pzTVZvNWVXYxAB',
    5, 'bs', 'Dragana Popović-temeljna, pažljiva i posvećena svakom detalju. Kod nje se odmah osjeti poverenje i profesionalnost! Sve detaljno objasni, – vidi se da zaista voli to što radi. Preporuka svima koji žele stručnog i brižnog fizioterapeuta!',
    'Dragana Popović-temeljna, pažljiva i posvećena svakom detalju. Kod nje se odmah osjeti poverenje i profesionalnost! Sve detaljno objasni, – vidi se da zaista voli to što radi. Preporuka svima koji žele stručnog i brižnog fizioterapeuta!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_jovana_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tGeFdrYzVUWFJwUW14dGNXZGFhaTFuZEhJM01VRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_milan_simrak, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21STlMzWlBSVzFwYjFRNVNEaHFiR280U1ZsdmRuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_jovana_lazovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSTFIwRjNMVk5QUWxGcmJFODRRa3AwUkVGQ1NrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_ranka_djurovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5WFpFRjNTSGhETFVadFJrNXNMWFUxZDAxWFUzYxAB',
    5, 'hr', 'Sve pohvale za ceo tim.Topla preporuka.
👏👏👏',
    'Sve pohvale za ceo tim.Topla preporuka.
👏👏👏', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_tina, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25wSFVGZ3liRXRtYVVzeE1sSTJkVlpaYm1kbFUzYxAB',
    5, 'hr', 'Izuzetno stručan tim koji nesebično vodi brigu o svojim pacijentima.
Prijatna atmosfera sa ljubaznim osobljem, zadobiće vaše poverenje već pri prvom susretu.
Puno sreće u daljem radu od srca.
🩷',
    'Izuzetno stručan tim koji nesebično vodi brigu o svojim pacijentima.
Prijatna atmosfera sa ljubaznim osobljem, zadobiće vaše poverenje već pri prvom susretu.
Puno sreće u daljem radu od srca.
🩷', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_snezana_kovacevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5Q2FXcEhlRzFFZDJwR2VXcFZhVUpzZVZoM09FRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_sandra_obradovic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21aS1MwWllkbkoyT0RGclFYZHdRbWR0UWtwMlFWRRAB',
    5, 'hr', 'Sve pohvale za novootvoreni edukativni centar, posebno za izvanrednu Draganu Popović!',
    'Sve pohvale za novootvoreni edukativni centar, posebno za izvanrednu Draganu Popović!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_marija_zmukic, @clinic_id, @doctor_dragana_popovic, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WWU5sQkZObFZOVjFKTVRUWjNWalJVTnkxVWRrRRAB',
    5, 'bs', 'Sve pohvale za ceo tim, posebno za Dr. Draganu Popovic! Moje dijete je doslo sa vecim problemom kicme i nepravilnog disanja i vec posle par casova rada sa njom rezulatari su bili znatno bolji👏. Idemo dalje sve do konacnog cilja💪',
    'Sve pohvale za ceo tim, posebno za Dr. Draganu Popovic! Moje dijete je doslo sa vecim problemom kicme i nepravilnog disanja i vec posle par casova rada sa njom rezulatari su bili znatno bolji👏. Idemo dalje sve do konacnog cilja💪', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_jovana_tunguz, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25sTlJFWktaREpYZVUxcmVWUmpSVGhRV2paQ2JIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_ivona_tomasevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tVMFMxcHpjVTlCWm5wTmNGODJTa0o2WDFjeFgzYxAB',
    5, 'hr', 'Sve preporuke za SeaStars🫶',
    'Sve preporuke za SeaStars🫶', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_tanja_suran, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s1MFIzVk5VbkJFU2pCMGRrbFZWMVpOTUMxM1duYxAB',
    5, 'hr', 'Sjajan tim i prelijepa atmosfera.Moje dijete uziva da ide i puno je naucila .Iskrene preporuke svima i hvala im sto postoje.',
    'Sjajan tim i prelijepa atmosfera.Moje dijete uziva da ide i puno je naucila .Iskrene preporuke svima i hvala im sto postoje.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_ivana_pejakovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25scFZrdFZkMmhvVDBGM1gweDJWbmRoY25wcmFYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_maja_novakovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kWlNHdzBZM1pmYm1KTlpERlJTMVpPYzNOZlVGRRAB',
    5, 'bs', 'Fenomenalni, strucni, najbolje vjezbe za skoliozu! Sve pohvale za Sea Stars',
    'Fenomenalni, strucni, najbolje vjezbe za skoliozu! Sve pohvale za Sea Stars', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_ivana_vujisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tkNVZtNVpkWGMxYTNaVlIyOVdWWHBuZGt0cVozYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kS1NrSndWbTlQTlVVd1VIUjVUWFpmWlRSTFgyYxAB'),
  'clinic', @clinic_id,
  'Od srca hvala ❤️🙏❤️', 'hr',
  'Od srca hvala ❤️🙏❤️', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-10-24 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJL79BQtA7TBMRcOIzlP2p4sA/reviews/Ci9DQUlRQUNvZENodHljRjlvT200ME5pMXJYMXBSYmpBdE9YUXdPSFV4YkhwalpXYxAB'),
  'clinic', @clinic_id,
  'I am truly honored to be your therapist,thank you!❤️', 'en',
  NULL, NULL, 'I am truly honored to be your therapist,thank you!❤️', NULL, NULL, NULL,
  'google_maps', '2025-12-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
