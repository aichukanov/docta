-- Insert Google Maps reviews for Center for Dental Implantology and Cosmetic Dentistry-Dental Montenegro
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dental-montenegro-budva.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dental-montenegro-budva');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_bojana_ivanovic = (SELECT id FROM doctors WHERE slug = 'bojana-ivanovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Сyзана', 'https://lh3.googleusercontent.com/a/ACg8ocLU1kQCW2kfhpnDXXpgv4w5UI6NoZN2BAeMJIvR-b3TUg2-HA=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/115671136306090333597/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115671136306090333597/reviews');
SET @user_syzana = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115671136306090333597/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nadezhda M', 'https://lh3.googleusercontent.com/a-/ALV-UjVdQmCMMeLYxwdVGkHHhtaVLGxFa4cKYZGSmRQpS1HU9_k7NtU=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/106186992477802262164/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106186992477802262164/reviews');
SET @user_nadezhda_m = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106186992477802262164/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ильдар Сафиуллин', 'https://lh3.googleusercontent.com/a/ACg8ocLD75JgPSdYGUCGlTZqgVxIKeCSoXa-ImsHbGUD0fTaThAvAw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107572533059717404800/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107572533059717404800/reviews');
SET @user_ildar_safiullin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107572533059717404800/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Лидия Сюльдина', 'https://lh3.googleusercontent.com/a-/ALV-UjVp-XP1mqkyAYPirlnqiJ7p2EJ2qJ6nF2jdNjgB6pJWuDVoaEGa=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/105281130537633708886/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105281130537633708886/reviews');
SET @user_lidiya_syuldina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105281130537633708886/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ольга Волкова', 'https://lh3.googleusercontent.com/a-/ALV-UjWjpBUQgIWQ2aYq5rU9Juj7x75X49Uy46a5vILYhVx7s7fqu5Pu=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106470499527632983035/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106470499527632983035/reviews');
SET @user_olga_volkova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106470499527632983035/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'EMMANUEL OLUKOJU', 'https://lh3.googleusercontent.com/a-/ALV-UjVWG9EXGWdCHSQMXh5l_qX3qy6rRPOUvVW1gsrbTOIuUZvIHSduVw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111669601667085811293/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111669601667085811293/reviews');
SET @user_emmanuel_olukoju = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111669601667085811293/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olga Kuznetsova', 'https://lh3.googleusercontent.com/a-/ALV-UjWWfKSTd8hJKENa1kBVpMDckVQWDk5SYan1V_ZNxRqD8dEErXFq=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101646567970189166510/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101646567970189166510/reviews');
SET @user_olga_kuznetsova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101646567970189166510/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kirill', 'https://lh3.googleusercontent.com/a/ACg8ocKa96dcTKqw5TFUtnSAbSK9fvnV1H3fgiljR7Gai-sDAqxbYDw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114163383500714722457/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114163383500714722457/reviews');
SET @user_kirill = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114163383500714722457/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Антон парахневич', 'https://lh3.googleusercontent.com/a/ACg8ocLy7UX5oBwWsvfZltq2Se7nMZCptRPpHNyyN0s3FjojvUyPEg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110946751695247631609/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110946751695247631609/reviews');
SET @user_anton_parakhnevich = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110946751695247631609/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tracy Simon', 'https://lh3.googleusercontent.com/a-/ALV-UjVBLRy0KVf1TuPjqB-B9wohXyHFni4e-Ih67o56MWsG6ZYz3zgZ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116100532843078360802/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116100532843078360802/reviews');
SET @user_tracy_simon = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116100532843078360802/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'anja milenkovic', 'https://lh3.googleusercontent.com/a/ACg8ocL6QY-0HpoyAyarJjXAC6wqnWhkilSIYFiPxZYSxpGzsfLUhQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104356151818758205557/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104356151818758205557/reviews');
SET @user_anja_milenkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104356151818758205557/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Evgenveg', 'https://lh3.googleusercontent.com/a/ACg8ocKEzQcWe8HKu-8wPq1eoLgk5A7TDTqjAtM1o1PXaOEMJFaXAA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113322565507089053315/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113322565507089053315/reviews');
SET @user_evgenveg = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113322565507089053315/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mary Mur', 'https://lh3.googleusercontent.com/a-/ALV-UjWyIcdPADkgsx2LgMFEaLJBUjCmKT_k2-1P9K4qdh0Nqi-rUb4O=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113319146990555290412/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113319146990555290412/reviews');
SET @user_mary_mur = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113319146990555290412/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Glišić', 'https://lh3.googleusercontent.com/a/ACg8ocIirqOguRYts9aRdX6foI5RsfqMDwFMZZCD-gm-Hnw_WzZ1mA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104535911496715842682/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104535911496715842682/reviews');
SET @user_ana_glii = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104535911496715842682/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sergey Kapinos', 'https://lh3.googleusercontent.com/a/ACg8ocKWABCB_jwHBzz5Zp_PqA1S277AkXmnDLkc18ornRkfihzKVw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105992959738600955002/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105992959738600955002/reviews');
SET @user_sergey_kapinos = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105992959738600955002/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pelin Saray', 'https://lh3.googleusercontent.com/a/ACg8ocK4m2uVHSXu9iVaTlFYeM53OEqWxn4cXVjhKYcHHUJQwlOhlA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116243186935884685670/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116243186935884685670/reviews');
SET @user_pelin_saray = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116243186935884685670/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Аnna Z', 'https://lh3.googleusercontent.com/a/ACg8ocK1BAXneRhJMSmR9RO99153g8ci-BoVqLAEFcBP5Y7Jl0zL6w=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101795410128651196053/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101795410128651196053/reviews');
SET @user_anna_z = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101795410128651196053/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Irina Skaterschikova', 'https://lh3.googleusercontent.com/a-/ALV-UjUVl9uCRwwddxpasw0A7MwKkEqxTSkz9BcUxa9VZaReo7oidhwbfw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102197794003281637038/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102197794003281637038/reviews');
SET @user_irina_skaterschikova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102197794003281637038/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Roman Grigoriadi', 'https://lh3.googleusercontent.com/a/ACg8ocLvlvESYYHgnU-312ap8daP9tOOjCzJ54lju4eJ97lvljq8yIo=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103352724288016002479/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103352724288016002479/reviews');
SET @user_roman_grigoriadi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103352724288016002479/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Константин Соколов', 'https://lh3.googleusercontent.com/a-/ALV-UjW6aeWxM5yKp2aOweUwdPJxwj38njIiyrNDCjL2EXlSNoe1HcTk=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117749776764916495926/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117749776764916495926/reviews');
SET @user_konstantin_sokolov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117749776764916495926/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Julia Lemke', 'https://lh3.googleusercontent.com/a-/ALV-UjUV9nM78CW7s3jO16M4toK3yTjHvKf0IDB4tA99l1DqwcqfS73G=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103484292971301969484/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103484292971301969484/reviews');
SET @user_julia_lemke = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103484292971301969484/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Monte Me', 'https://lh3.googleusercontent.com/a/ACg8ocK86OsUlMIftm4OmEENyUE_N2sp5IBY1-xsS8wK8DY1f7EK_g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116263217307869543230/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116263217307869543230/reviews');
SET @user_monte_me = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116263217307869543230/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladimirb55 Borisov', 'https://lh3.googleusercontent.com/a/ACg8ocLnYrazBp-A4l4TsKLMD2meQtbYYetLsQnnvZy2EBRGLSQRpg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104603482244789149971/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104603482244789149971/reviews');
SET @user_vladimirb55_borisov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104603482244789149971/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Александра Ходукина', 'https://lh3.googleusercontent.com/a/ACg8ocLmYALwTHSwtpOHaBhhn-Q7WhvydVotutkKo6HZKyAOPlesPA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101542608324185498681/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101542608324185498681/reviews');
SET @user_aleksandra_khodukina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101542608324185498681/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kate Stepanova', 'https://lh3.googleusercontent.com/a-/ALV-UjWvD6rVE05EZq3PrzYL6DCxXsLSsR9OD1uIYE55MYq9o5bm0QQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108190954047271465924/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108190954047271465924/reviews');
SET @user_kate_stepanova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108190954047271465924/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Квадро Движение', 'https://lh3.googleusercontent.com/a-/ALV-UjWGzlhEXmOdUum_urMgRjpVNqtTUwSJqjbUqkcM8lVUlsRtTyo=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118001451017445712283/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118001451017445712283/reviews');
SET @user_kvadro_dvizhenie = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118001451017445712283/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Культ Личности', 'https://lh3.googleusercontent.com/a/ACg8ocJk7Ws6OlVjqAJbvWayBUAw_pR_d26DpGURo1pEeSoG34puvA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115260116693998672196/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115260116693998672196/reviews');
SET @user_kult_lichnosti = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115260116693998672196/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vyacheslav Vlasov', 'https://lh3.googleusercontent.com/a-/ALV-UjVtATGWzIk3Kh5w4vS6lEc44LvM3584YWsuoCQG_uR0GIyA71o=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113459574417729337958/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113459574417729337958/reviews');
SET @user_vyacheslav_vlasov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113459574417729337958/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Yakov Volkov', 'https://lh3.googleusercontent.com/a-/ALV-UjUTBnlAnhBNlJpVbWok8FFDEgKvAWdFd-n1dDnmwJPqMJ7k08m9=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116621708796189180353/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116621708796189180353/reviews');
SET @user_yakov_volkov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116621708796189180353/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alexandra Savelyeva', 'https://lh3.googleusercontent.com/a/ACg8ocJCufBgb3NYyAvcdFOvQdTf7hfbZ9-OPGW9Li9_eOtfdvNNaA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116151467514216485588/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116151467514216485588/reviews');
SET @user_alexandra_savelyeva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116151467514216485588/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Полина Анохина', 'https://lh3.googleusercontent.com/a/ACg8ocIoR-4Kr9QqofOs0pGY1xvNc0jpGKDfuMUYbmdkOe_qIaee-A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103904364261424256788/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103904364261424256788/reviews');
SET @user_polina_anokhina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103904364261424256788/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Илья Вепринцев', 'https://lh3.googleusercontent.com/a-/ALV-UjXByiojJb02We2l8AJvvSb42Vzgwk_j83S0m3z9LuIoseLP70w=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110817506588615808765/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110817506588615808765/reviews');
SET @user_ilya_veprintsev = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110817506588615808765/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Selena Soler', 'https://lh3.googleusercontent.com/a-/ALV-UjWkLggbrW1s4CIfS1NUw8ovtyfgrVGQPteDT1JEZWLCfs2VtOIE=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108018802591469094956/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108018802591469094956/reviews');
SET @user_selena_soler = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108018802591469094956/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Вера Радаева', 'https://lh3.googleusercontent.com/a/ACg8ocI3SzWI22y5rf2RRVGmkVQYN0VRxjbEE9Ot0WbGnHv_qYr2=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115181524153059749796/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115181524153059749796/reviews');
SET @user_vera_radaeva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115181524153059749796/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Андрей Сажин', 'https://lh3.googleusercontent.com/a/ACg8ocI9XC5e-H9wiEQh26XK109AHhSp8m1nuyz8KImbB3jHN1sk6Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110223343627677283841/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110223343627677283841/reviews');
SET @user_andrey_sazhin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110223343627677283841/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Liuba R', 'https://lh3.googleusercontent.com/a-/ALV-UjUjcYOJpXGxAyd93xg-F7C82xqlHojJ34dlreIk-Mr5ikKq-4vBDg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112743518669813667821/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112743518669813667821/reviews');
SET @user_liuba_r = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112743518669813667821/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Furkan', 'https://lh3.googleusercontent.com/a/ACg8ocKvNrGwa5NSzbu8OZFrcoZqtfd6n9pLhBkHnaRYLwTzZL4Qyw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115009775848528465409/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115009775848528465409/reviews');
SET @user_furkan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115009775848528465409/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Richard Wannemacher', 'https://lh3.googleusercontent.com/a/ACg8ocKF4sJuS4OR6CRP6dNYkUJYcOY6efgG21wU7IebJ2Wkm4dAMg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107178438372192933172/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107178438372192933172/reviews');
SET @user_richard_wannemacher = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107178438372192933172/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kübra kaplan', 'https://lh3.googleusercontent.com/a/ACg8ocLsPuWy-i-c9lpqiAA_x68h01sZR7u1C6106DFgqmowUpJy-A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114898172427480274685/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114898172427480274685/reviews');
SET @user_kbra_kaplan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114898172427480274685/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ludwig Eugene', 'https://lh3.googleusercontent.com/a-/ALV-UjXV2a0h7YnWuHnCXHJmLdxbDkSoxWxlRQyx_CElLyYQjhiOv3fGAQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116733901672677768633/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116733901672677768633/reviews');
SET @user_ludwig_eugene = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116733901672677768633/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'A I', 'https://lh3.googleusercontent.com/a-/ALV-UjVsWiXwplJXJUgl6OMgX-hs1IoP9Nq76Rfg7MiF_qZDpOVTkt5rsg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100457020211248239906/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100457020211248239906/reviews');
SET @user_a_i = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100457020211248239906/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Julia Koimshidi', 'https://lh3.googleusercontent.com/a/ACg8ocLnEHnju1I5VtpcmyEzr6Cmax6ewCTrnwll6uWlA5s5z52QHA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109582573510344793327/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109582573510344793327/reviews');
SET @user_julia_koimshidi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109582573510344793327/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Евгений Ка', 'https://lh3.googleusercontent.com/a-/ALV-UjU1xQKA6lBK9VS_Rq4xxSU7MkqhHQ1ZYFG1Q_x0H7ypodEW6gsU=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102879032114182672525/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102879032114182672525/reviews');
SET @user_evgeniy_ka = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102879032114182672525/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mel', 'https://lh3.googleusercontent.com/a-/ALV-UjW0uaJ3hJrDuuNQ92k_06wxBuo3mZb986Ziahkj9YZLxwBjfGN3=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/118424905598900407880/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118424905598900407880/reviews');
SET @user_mel = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118424905598900407880/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandar Đorđević', 'https://lh3.googleusercontent.com/a-/ALV-UjW80BHMVJQnst6nSkFKpLR9_0KAiYcz4oSk2FljuNxyj8y7ocI=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107268975614045601405/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107268975614045601405/reviews');
SET @user_aleksandar_orevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107268975614045601405/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Vuckovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUPJsMPz7yc5aO_Uzc7qhdjq5jG2ACz729EPgVOxqIbbQcxqvg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113910611814739890113/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113910611814739890113/reviews');
SET @user_ana_vuckovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113910611814739890113/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milena Montenegro', 'https://lh3.googleusercontent.com/a/ACg8ocItZQDfS2RjAeAr7KWq7Atqbi2T2irn7GgfZqw6hdBMcST6UA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103471572311945194799/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103471572311945194799/reviews');
SET @user_milena_montenegro = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103471572311945194799/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Petar Abramovic', 'https://lh3.googleusercontent.com/a/ACg8ocJwyzSVScki_fNUSP7pjZ23MVCQmwZ1BLsk3QJlYBUMQVjnvg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116550575732161156493/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116550575732161156493/reviews');
SET @user_petar_abramovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116550575732161156493/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'DJ Tony MC Break', 'https://lh3.googleusercontent.com/a-/ALV-UjW1n0M-JBO7SEiVszG6-PglxQx0uLC-eCJpBMoB20Y6STZzISM=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110026246713485790495/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110026246713485790495/reviews');
SET @user_dj_tony_mc_break = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110026246713485790495/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_syzana, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSUNBMXJ1Z1JnEAE',
    5, 'sr', 'За 5☆ заслужна је  искључиво Др. Александра Јовановић !  Веома је професионална, сталожена, блага... немам замјерке на њен рад.
Врло љубазна је и сестра Марина...
Све похвале.
Цијене већине услуга су као у другим ординацијама, али поједине су мало скупље.
Овом приликом препоручујем Др.Александру Јовановић!',
    'Za 5☆ zaslužna je  isključivo Dr. Aleksandra Jovanović !  Veoma je profesionalna, staložena, blaga... nemam zamjerke na njen rad.
Vrlo ljubazna je i sestra Marina...
Sve pohvale.
Cijene većine usluga su kao u drugim ordinacijama, ali pojedine su malo skuplje.
Ovom prilikom preporučujem Dr.Aleksandru Jovanović!', 'За 5☆ заслужна је  искључиво Др. Александра Јовановић !  Веома је професионална, сталожена, блага... немам замјерке на њен рад.
Врло љубазна је и сестра Марина...
Све похвале.
Цијене већине услуга су као у другим ординацијама, али поједине су мало скупље.
Овом приликом препоручујем Др.Александру Јовановић!', NULL, NULL, NULL, NULL,
    2, '2018-08-29 21:59:29'),

(@user_nadezhda_m, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/Ci9DQUlRQUNvZENodHljRjlvT25sNmQyaHViemxHWkVFMGVGWkNUV3hpVEY5QlYzYxAB',
    5, 'ru', 'Отличная стоматология! Современное оборудование и внимательное отношение к пациентам. Всё прошло быстро и безболезненно. Рекомендую! Были у доктора Даниса.',
    'Odlična stomatologija! Moderna oprema i pažljiva nega. Sve je bilo brzo i bezbolno. Toplo preporučujem! Bili smo kod dr Danisa.', 'Одлична стоматологија! Модерна опрема и пажљива нега. Све је било брзо и безболно. Топло препоручујем! Били смо код др Даниса.', NULL, 'Отличная стоматология! Современное оборудование и внимательное отношение к пациентам. Всё прошло быстро и безболезненно. Рекомендую! Были у доктора Даниса.', NULL, NULL,
    0, '2026-02-18 18:07:43'),

(@user_ildar_safiullin, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSUNsdy1tRlZ3EAE',
    5, 'ru', 'С детства была проблема со стоматологами,много каких зубов загубили. В ЧГ побывал в нескольких клиниках, но только в Dental Montenegro смог найти врача в лице Евдокимовой Виктории Александровны,которая смогла исправить очень многое и добиться результата о котором раньше и не мечтал. Хочу так же отметить внимательность, пунктуальность и профессионализм данного врача, не смотря на ее молодость. Это первый стоматолог который столько внимания уделяет не только лечению, но и процедуре ухода за зубами, объясняет что правильный уход и профилактика - лучше чем лечение.',
    'Imam problema sa zubarima od detinjstva; izgubila sam mnogo zuba. Posetila sam nekoliko klinika u Crnoj Gori, ali tek u Dental Montenegro sam pronašla doktorku, Viktoriju Aleksandrovnu Evdokimovu, koja je uspela da ispravi mnoge probleme i postigne rezultate o kojima nisam ni sanjala. Takođe želim da pohvalim njenu pažljivost, tačnost i profesionalizam, uprkos mladosti. Ona je prva zubarka koja toliko pažnje posvećuje ne samo lečenju već i nezi zuba, objašnjavajući da su pravilna nega i prevencija bolji od lečenja.', 'Имам проблема са зубарима од детињства; изгубила сам много зуба. Посетила сам неколико клиника у Црној Гори, али тек у Дентал Монтенегро сам пронашла докторку, Викторију Александровну Евдокимову, која је успела да исправи многе проблеме и постигне резултате о којима нисам ни сањала. Такође желим да похвалим њену пажљивост, тачност и професионализам, упркос младости. Она је прва зубарка која толико пажње посвећује не само лечењу већ и нези зуба, објашњавајући да су правилна нега и превенција бољи од лечења.', NULL, 'С детства была проблема со стоматологами,много каких зубов загубили. В ЧГ побывал в нескольких клиниках, но только в Dental Montenegro смог найти врача в лице Евдокимовой Виктории Александровны,которая смогла исправить очень многое и добиться результата о котором раньше и не мечтал. Хочу так же отметить внимательность, пунктуальность и профессионализм данного врача, не смотря на ее молодость. Это первый стоматолог который столько внимания уделяет не только лечению, но и процедуре ухода за зубами, объясняет что правильный уход и профилактика - лучше чем лечение.', NULL, NULL,
    4, '2023-11-25 17:34:35'),

(@user_lidiya_syuldina, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUNCd3VhYWlnRRAB',
    5, 'ru', 'Благодарю Викторию за осмотр и чистку. Большой плюс для меня, что она из России и говорит по-русски☺️ И вызывает уважение поход, где врач ориентируется на мои ощущения и предлагает понаблюдать и приходить, если появятся другие симптомы или через 6 месяцев на контроль. А не так, что вот тут есть пятнышко, давайте сразу пломбу)) Поэтому обязательно приду еще на регулярный осмотр. Чистка очень тщательная, используются современные методы (кое-чего я даже раньше не видела - порошка от налета, например). Стоимость комплексной чистки 65€. Совершенно без боли и даже десна нигде не кровила (обычно у меня после чистки была кровь).
Благодарю☺️

Фото внутри забыла сделать, так что фото конвертика, который мне дали на выходе.
Место положения неочень удобное для пешеходов, но я за 20 минут дошла пешком до центра Будвы. На карте казалось дальше))

PS: живу в Черногории год и веду блог в Инстаграм lidaplus - рада новым знакомствам тут.',
    'Zahvaljujem Viktoriji na pregledu i čišćenju. Za mene je veliki plus što je iz Rusije i što govori ruski. ☺ I poštujem posetu, gde se doktor fokusira na moja osećanja i predlaže praćenje i povratak ako se pojave drugi simptomi ili na pregled za 6 meseci. Nije kao: „Evo mesta, hajde da odmah napunimo“. Dakle, svakako ću se vraćati na redovne preglede. Čišćenje je veoma temeljno, savremenim metodama (nešto što ranije nisam ni videla, poput praha protiv plaka). Cena sveobuhvatnog čišćenja je 65 €. Bilo je potpuno bezbolno, a desni mi nisu ni krvarile (obično krvarim nakon čišćenja).
Hvala. ☺

Zaboravio sam da slikam unutrašnjost, pa ću na izlasku fotografisati kovertu koju su mi dali.
Lokacija nije baš zgodna za pješake, ali do centra Budve sam prošetao za 20 minuta. Činilo se dalje na mapi))

PS: Živim u Crnoj Gori godinu dana i vodim blog na Instagramu, lidaplus – drago mi je što ovdje upoznajem nove ljude.', 'Захваљујем Викторији на прегледу и чишћењу. За мене је велики плус што је из Русије и што говори руски. ☺ И поштујем посету, где се доктор фокусира на моја осећања и предлаже праћење и повратак ако се појаве други симптоми или на преглед за 6 месеци. Није као: „Ево места, хајде да одмах напунимо“. Дакле, свакако ћу се враћати на редовне прегледе. Чишћење је веома темељно, савременим методама (нешто што раније нисам ни видела, попут праха против плака). Цена свеобухватног чишћења је 65 €. Било је потпуно безболно, а десни ми нису ни крвариле (обично крварим након чишћења).
Хвала. ☺

Заборавио сам да сликам унутрашњост, па ћу на изласку фотографисати коверту коју су ми дали.
Локација није баш згодна за пјешаке, али до центра Будве сам прошетао за 20 минута. Чинило се даље на мапи))

ПС: Живим у Црној Гори годину дана и водим блог на Инстаграму, лидаплус – драго ми је што овдје упознајем нове људе.', NULL, 'Благодарю Викторию за осмотр и чистку. Большой плюс для меня, что она из России и говорит по-русски☺️ И вызывает уважение поход, где врач ориентируется на мои ощущения и предлагает понаблюдать и приходить, если появятся другие симптомы или через 6 месяцев на контроль. А не так, что вот тут есть пятнышко, давайте сразу пломбу)) Поэтому обязательно приду еще на регулярный осмотр. Чистка очень тщательная, используются современные методы (кое-чего я даже раньше не видела - порошка от налета, например). Стоимость комплексной чистки 65€. Совершенно без боли и даже десна нигде не кровила (обычно у меня после чистки была кровь).
Благодарю☺️

Фото внутри забыла сделать, так что фото конвертика, который мне дали на выходе.
Место положения неочень удобное для пешеходов, но я за 20 минут дошла пешком до центра Будвы. На карте казалось дальше))

PS: живу в Черногории год и веду блог в Инстаграм lidaplus - рада новым знакомствам тут.', NULL, NULL,
    6, '2022-12-20 15:52:59'),

(@user_olga_volkova, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSUNsLWJIZU5BEAE',
    5, 'ru', 'Хочу сказать огромное спасибо доктору Виктории! ❤️ Наблюдаемся у нее всей семьей, скоро начнем водить самого младшего сына. Доктор Виктория очень добрая, заботливая и внимательная. Лечиться у такого доктора- одно удовольствие!',
    'Želim da kažem veliko hvala dr Viktoriji! ❤ Cela naša porodica je vidi, a uskoro ćemo tamo i našeg najmlađeg sina. Dr Viktorija je veoma ljubazna, brižna i pažljiva. Zadovoljstvo je lečiti se kod takvog doktora!', 'Желим да кажем велико хвала др Викторији! ❤ Цела наша породица је види, а ускоро ћемо тамо и нашег најмлађег сина. Др Викторија је веома љубазна, брижна и пажљива. Задовољство је лечити се код таквог доктора!', NULL, 'Хочу сказать огромное спасибо доктору Виктории! ❤️ Наблюдаемся у нее всей семьей, скоро начнем водить самого младшего сына. Доктор Виктория очень добрая, заботливая и внимательная. Лечиться у такого доктора- одно удовольствие!', NULL, NULL,
    4, '2023-11-22 12:50:50'),

(@user_emmanuel_olukoju, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xweFNWWm5VV2d0V2pCT2FsQkpTV3hDTlV4b1kzYxAB',
    5, 'en', 'Wonderful service from the reception to the dentist.',
    NULL, NULL, 'Wonderful service from the reception to the dentist.', NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_olga_kuznetsova, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tKNU5sZEhWVzF6U2s4d1RtYzVjRE5QUkRCUlUzYxAB',
    5, 'ru', 'Отличная клиника с современным оборудованием и потрясающими врачами. Особенно хотелось бы отметить доктора Даниса, который профессионал своего дела и с полуслова всё понимает и делает всё очень комфортно для пациента. Ценник чуть выше среднего. Но это стоит того, чтобы отдаться в надежные руки. Карты принимают.',
    NULL, NULL, NULL, 'Отличная клиника с современным оборудованием и потрясающими врачами. Особенно хотелось бы отметить доктора Даниса, который профессионал своего дела и с полуслова всё понимает и делает всё очень комфортно для пациента. Ценник чуть выше среднего. Но это стоит того, чтобы отдаться в надежные руки. Карты принимают.', NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_kirill, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5eE9XTlFUMVJYTUhBdGFGSmxNRWh5Y1hSTVMzYxAB',
    5, 'en', 'I had dental treatment with Dr. Aleksa. He is an amazing person and an excellent professional. You immediately notice how carefully he listens to your concerns. He is very tactful in communication and extremely attentive in his work. There are no hidden motives or unnecessary treatments — he recommends only what you genuinely need.

I am sure there are many other excellent specialists at this clinic as well, especially since it is owned by a highly experienced professional. But if you are booked with Aleksa, you will be in safe hands.

Thank you to the clinic and to Aleksa! I will always remember you with great warmth.',
    NULL, NULL, 'I had dental treatment with Dr. Aleksa. He is an amazing person and an excellent professional. You immediately notice how carefully he listens to your concerns. He is very tactful in communication and extremely attentive in his work. There are no hidden motives or unnecessary treatments — he recommends only what you genuinely need.

I am sure there are many other excellent specialists at this clinic as well, especially since it is owned by a highly experienced professional. But if you are booked with Aleksa, you will be in safe hands.

Thank you to the clinic and to Aleksa! I will always remember you with great warmth.', NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_anton_parakhnevich, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/Ci9DQUlRQUNvZENodHljRjlvT25aUlNHcFpNbU5JYm5CVVZqUlBTVkIyZFMxRlZWRRAB',
    5, 'ru', 'Отдыхал в Каменово, пришел по острой боли. Все было очень вежливо, доброжелательно. Доктор Владимир все сделал супер. Рекомендую данную клинику.',
    NULL, NULL, NULL, 'Отдыхал в Каменово, пришел по острой боли. Все было очень вежливо, доброжелательно. Доктор Владимир все сделал супер. Рекомендую данную клинику.', NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_tracy_simon, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/Ci9DQUlRQUNvZENodHljRjlvT2taS01rZ3RaSGs0UzFWSVJURlNXbmw0Ym5SV2JuYxAB',
    5, 'en', 'Very lovely staff , good communication and painless procedure 150% would recommend this 🥰😘❤️',
    NULL, NULL, 'Very lovely staff , good communication and painless procedure 150% would recommend this 🥰😘❤️', NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_anja_milenkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKRlNEWklRa0oyVldKSFIyUkdXVE0yZVc1SmVsRRAB',
    5, 'hr', 'Neizmerno sam zahvalna doktorima koji su mi izasli u susret i resili me bola i muke,precisto mesto i preljubazno osoblje.Svaka preporuka 🫶🏻🙌🏻',
    'Neizmerno sam zahvalna doktorima koji su mi izasli u susret i resili me bola i muke,precisto mesto i preljubazno osoblje.Svaka preporuka 🫶🏻🙌🏻', NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_evgenveg, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/Ci9DQUlRQUNvZENodHljRjlvT25OUFIzZHBZemhKWW5sTlVUSnRlSGx3Vld4WGVXYxAB',
    5, 'en', 'Doctor and assistant are very professional. The dental treatment was carried out in several stages, over several days - this is a professional approach, not to rush. In my rare case i have three canals and they did everything fine. The equipment is modern and even has RGB lights. They can took an x-ray picture and if you need to see an x-ray image yourself to see the results of your treatment, you can request it and they will send it within a few days',
    NULL, NULL, 'Doctor and assistant are very professional. The dental treatment was carried out in several stages, over several days - this is a professional approach, not to rush. In my rare case i have three canals and they did everything fine. The equipment is modern and even has RGB lights. They can took an x-ray picture and if you need to see an x-ray image yourself to see the results of your treatment, you can request it and they will send it within a few days', NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_mary_mur, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/Ci9DQUlRQUNvZENodHljRjlvT25aT1pEaDFOa0pEWm1NMk9IWjFWMkowY0daV2FFRRAB',
    5, 'ru', 'Имела форс-мажорную ситуацию, с которой сегодня быстро справилась врач Александра, большое спасибо, я благодарна и рекомендую!))

Также пару лет назад в филиале в Сплендиде прием у ортодонта у другого врача был комфортным, не запомнила имя, прием вел мужчина',
    NULL, NULL, NULL, 'Имела форс-мажорную ситуацию, с которой сегодня быстро справилась врач Александра, большое спасибо, я благодарна и рекомендую!))

Также пару лет назад в филиале в Сплендиде прием у ортодонта у другого врача был комфортным, не запомнила имя, прием вел мужчина', NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ana_glii, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pjemQzbFFZVXBDTUVkbFdGSnNObHBWTkdkSGVXYxAB',
    1, 'hr', 'Zgrožena sam koliko doktor nema pojma i nema strpljenja i ne zna jezik a ne zna ni posao',
    'Zgrožena sam koliko doktor nema pojma i nema strpljenja i ne zna jezik a ne zna ni posao', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_sergey_kapinos, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VKZUpsTVNtOXFLU2J3EAE',
    5, 'ru', 'Был на консультации и лечении в клинике Dental Montenegro. Договаривался о визите заранее. Связь на высшем уровне. Можно выбрать день, время. Удалял зуб и консультировался о дальнейшем лечении и протезировании. Всё супер, чётко и профессионально распределяют лечение. Обьясняют по этапно, что нужно делать и для чего. Персонал в клинике на высшем уровне. Я специально прилетал именно в эту клинику и не ошибся.',
    NULL, NULL, NULL, 'Был на консультации и лечении в клинике Dental Montenegro. Договаривался о визите заранее. Связь на высшем уровне. Можно выбрать день, время. Удалял зуб и консультировался о дальнейшем лечении и протезировании. Всё супер, чётко и профессионально распределяют лечение. Обьясняют по этапно, что нужно делать и для чего. Персонал в клинике на высшем уровне. Я специально прилетал именно в эту клинику и не ошибся.', NULL, NULL,
    1, '2025-10-29 00:00:00'),

(@user_pelin_saray, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnTUNZeHFUd3R3RRAB',
    1, 'en', 'We are From 🇬🇧 Never again!!! Horrible experience! ❌❌❌ I will not recommend anyone in England!
I and my partner have been there for the first time on 21st April. They did CBCT (Deep scanning) They took €120 and they even did not explain or talk with us. They were so unprofessional! I never ever experienced this before. They only work for money. They made us feel so bad. They don’t care about their patients. They need to make it up for us… I want refund!!!',
    NULL, NULL, 'We are From 🇬🇧 Never again!!! Horrible experience! ❌❌❌ I will not recommend anyone in England!
I and my partner have been there for the first time on 21st April. They did CBCT (Deep scanning) They took €120 and they even did not explain or talk with us. They were so unprofessional! I never ever experienced this before. They only work for money. They made us feel so bad. They don’t care about their patients. They need to make it up for us… I want refund!!!', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_anna_z, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnTURRNWNPaC1nRRAB',
    5, 'ru', 'Была сегодня на приеме у доктора Захара (на русском). Захар мне нарастил сколотый зуб (6ка) идеально, была отколота половина, теперь зуб как новый, еще сделали чистку. Все очень доброжелательно, профессионально и комфортно. Рада, что нашла своего стоматолога🫶
Отличный врач, отличная клиника, новое свежее оборудование. Рекомендую',
    NULL, NULL, NULL, 'Была сегодня на приеме у доктора Захара (на русском). Захар мне нарастил сколотый зуб (6ка) идеально, была отколота половина, теперь зуб как новый, еще сделали чистку. Все очень доброжелательно, профессионально и комфортно. Рада, что нашла своего стоматолога🫶
Отличный врач, отличная клиника, новое свежее оборудование. Рекомендую', NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_irina_skaterschikova, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUNQNXFhOTVnRRAB',
    5, 'ru', 'Отзыв о враче-стоматологе Ксении Александровне Демчишиной

С 2010 года 80% моих обращений за стоматологической помощью были к Ксении Александровне. За эти годы я неоднократно убеждалась в ее профессионализме, опыте и заботливом отношении.
На протяжении многих лет Ксения лечила мне кариес, проводила регулярные гигиенические чистки раз в год, а также выполняла сложные процедуры подготовки к протезированию. В частности, за один прием она провела стачивание зубов, чистку и пломбирование каналов, а также укрепление четырёх зубов штифтами. Несмотря на объем и сложность работы, это не стало для меня испытанием. С тех пор прошло уже 12 лет, и за это время не возникло ни одной проблемы с этими зубами и протезом.
Когда я получила травму лица, и мой протез сильно откололся, Ксения оперативно отремонтировала его, чтобы сохранить эстетику до установки нового. Протезирование я проходила в другом городе, и врач, который этим занимался, высоко оценил качество работы Ксении 12-летней давности. Зубы под протезом оказались в хорошем состоянии, а штифты не потребовали замены.
Ксения Александровна также помогала моей маме, которая лечила у неё кариес и меняла коронку. Мама часто вспоминает её как лучшего стоматолога, с которым ей когда-либо приходилось работать. Теперь и мой супруг планирует комплексное лечение у Ксении, несмотря на то, что ему для этого придётся летать из Испании в Черногорию.
За все эти годы Ксения зарекомендовала себя как настоящий профессионал, которому я и моя семья полностью доверяем. Она никогда не навязывает лишних процедур, всегда предлагает несколько вариантов, если лечение дорогостоящее, и подробно объясняет разницу между ними.

Я искренне рекомендую Ксению Александровну Демчишину всем, кто ищет опытного, внимательного и честного стоматолога. С ней вы можете быть уверены в качестве лечения!

#Гигиеническая чистка
#Отбеливание зубов
#Лечение кариеса
#Протезирование
#Отзыв от клиента
#Будва стоматолог
#Честный отзыв
#Черногория',
    NULL, NULL, NULL, 'Отзыв о враче-стоматологе Ксении Александровне Демчишиной

С 2010 года 80% моих обращений за стоматологической помощью были к Ксении Александровне. За эти годы я неоднократно убеждалась в ее профессионализме, опыте и заботливом отношении.
На протяжении многих лет Ксения лечила мне кариес, проводила регулярные гигиенические чистки раз в год, а также выполняла сложные процедуры подготовки к протезированию. В частности, за один прием она провела стачивание зубов, чистку и пломбирование каналов, а также укрепление четырёх зубов штифтами. Несмотря на объем и сложность работы, это не стало для меня испытанием. С тех пор прошло уже 12 лет, и за это время не возникло ни одной проблемы с этими зубами и протезом.
Когда я получила травму лица, и мой протез сильно откололся, Ксения оперативно отремонтировала его, чтобы сохранить эстетику до установки нового. Протезирование я проходила в другом городе, и врач, который этим занимался, высоко оценил качество работы Ксении 12-летней давности. Зубы под протезом оказались в хорошем состоянии, а штифты не потребовали замены.
Ксения Александровна также помогала моей маме, которая лечила у неё кариес и меняла коронку. Мама часто вспоминает её как лучшего стоматолога, с которым ей когда-либо приходилось работать. Теперь и мой супруг планирует комплексное лечение у Ксении, несмотря на то, что ему для этого придётся летать из Испании в Черногорию.
За все эти годы Ксения зарекомендовала себя как настоящий профессионал, которому я и моя семья полностью доверяем. Она никогда не навязывает лишних процедур, всегда предлагает несколько вариантов, если лечение дорогостоящее, и подробно объясняет разницу между ними.

Я искренне рекомендую Ксению Александровну Демчишину всем, кто ищет опытного, внимательного и честного стоматолога. С ней вы можете быть уверены в качестве лечения!

#Гигиеническая чистка
#Отбеливание зубов
#Лечение кариеса
#Протезирование
#Отзыв от клиента
#Будва стоматолог
#Честный отзыв
#Черногория', NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_roman_grigoriadi, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUMzcVBHN3lnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_konstantin_sokolov, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSURaNkpuWVNnEAE',
    1, 'ru', 'Обратился. Ещё ничего не сделали, а запросили уже 60 евро.
Если есть возможность, то поищите другую клинику. Эту обходите стороной.',
    NULL, NULL, NULL, 'Обратился. Ещё ничего не сделали, а запросили уже 60 евро.
Если есть возможность, то поищите другую клинику. Эту обходите стороной.', NULL, NULL,
    4, '2024-10-29 00:00:00'),

(@user_julia_lemke, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUM3NHBtT3BBRRAB',
    5, 'de', 'Sehr schön',
    NULL, NULL, NULL, NULL, 'Sehr schön', NULL,
    1, '2024-10-29 00:00:00'),

(@user_monte_me, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSURUbHJQT0NnEAE',
    5, 'ru', 'Высококласные услуги!
Не больно и не страшно)!',
    NULL, NULL, NULL, 'Высококласные услуги!
Не больно и не страшно)!', NULL, NULL,
    1, '2024-10-29 00:00:00'),

(@user_vladimirb55_borisov, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSUNUZ2RIRkh3EAE',
    5, 'ru', 'Крутая клиника, доктор Данис -лучший!! Быстро , четко , профессионально.',
    NULL, NULL, NULL, 'Крутая клиника, доктор Данис -лучший!! Быстро , четко , профессионально.', NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_aleksandra_khodukina, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSUREX18tc053EAE',
    5, 'en', 'Very kind and professional doctors! Highly recommended!',
    NULL, NULL, 'Very kind and professional doctors! Highly recommended!', NULL, NULL, NULL,
    1, '2024-10-29 00:00:00'),

(@user_kate_stepanova, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUREdGFxSDdnRRAB',
    5, 'en', 'I recommend this clinic .
Good service, guaranteed quality.',
    NULL, NULL, 'I recommend this clinic .
Good service, guaranteed quality.', NULL, NULL, NULL,
    1, '2024-10-29 00:00:00'),

(@user_kvadro_dvizhenie, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSUROaVplOFpBEAE',
    5, 'ru', 'Здравствуйте, меня зовут Илья, я зооволонтер и хотел бы написать честный отзыв о работе Виктории для всех кто ищет врача стоматолога в Будве.

К этому врачу я попал после того, как изучил Телеграм, где Виктория показывала примеры своих работ. Я заметил, что она лечит детей, и для меня это стало основным критерием - я понял, что этому доктору можно доверять, ведь детей не обманешь.

Скажу сразу, что я очень боялся стоматологии и врачей в целом с детства, и это сохранилось и во взрослом возрасте. Я очень редко посещал стоматологические клиники, и это было только в экстренных случаях, когда зуб болел 2-3 дня.

Однажды в осенний дождливый день, когда ветер завывал  настолько сильно что двигал черепицу на вилле, где я живу, я увидел работу Виктории по отбеливанию зубов и понял, что уровень её работы весьма высок. Мне понравились примеры до и после, и я решил, что хочу сделать то же, потому что желтые зубы мне порядком надоели, и я захотел их отбелить.

Я списался с Викторией и задал ряд вопросов о том, больно ли делать отбеливание, не вредно ли это для эмали зубов, какие есть ограничения и так далее. Получив исчерпывающую консультацию, я убедился в компетентности и клиентоориентированности врача и записался на первичный приём. Учитывая, что я не обращался к стоматологу с лечением примерно 10 лет, у меня, конечно, был кариес. Чтобы понять, где он точно находится, я решил сделать гигиеническую чистку зубов, последний раз делавшуюся мной 2-3 года назад. Помню это прекрасное чувство чистых и гладких зубов.

Посетив Викторию и сделав гигиеническую чистку зубов, мы столкнулись с тем, что у меня на 6 зубах (точнее, между ними) был обнаружен кариес, который, конечно, надо было лечить. Я очень боялся, но согласился пройти процедуру лечения всех зубов, ещё раз доверившись Виктории. Это заняло определённое время и около 5 посещений в сумме. Хочу отметить, что несмотря на мои страхи и опасения потерять сознание или просто умереть от нервных переживаний, всё прошло максимально гладко, безопасно и без боли. Я реально не ожидал, что современная анестезия и профессионализм врача могут творить чудеса. За все 5 сеансов лечения зубов мне ни разу не сделали больно, более того, я могу сказать, что если закрыть глаза, то можно просто уснуть на приёме! Это невероятно, но факт.

Пролечив все зубы, я полностью доверился этому замечательному и внимательному врачу. На каждый сеанс я приходил уже без боязни. Мне было максимально комфортно и уютно, я чувствовал себя в безопасности. Да, так бывает, взрослый мужчина может бояться кабинета стоматолога, но в этот раз мой страх был побеждён.

После того как все зубы были пролечены, я конечно сделал отбеливание зубов как и было запланировано. Процедура заняла всего один сеанс. Как и обещала Виктория, это совсем не больно и даже не было неприятно.

Теперь мои зубы белые, здоровые и красиво выглядят.

Я не боюсь больше стоматологии, как боялся раньше. Хочу выразить большую благодарность Виктории за проведённое лечение, оказанную помощь, консультации и в целом за человеческое, порядочное отношение к клиенту. С ней всегда было комфортно, безопасно, и главное - я получил тот результат, на который рассчитывал.

Если в Будве или даже в Черногории вы ищете для себя или ребёнка настоящего профессионального врача и не знаете, кому довериться, я смело могу рекомендовать Викторию.

#Гигиеническая чистка
#Отбеливание зубов
#Лечение кариеса
#Отзыв от клиента
#Будва стоматолог
#Честный отзыв
#Черногория',
    NULL, NULL, NULL, 'Здравствуйте, меня зовут Илья, я зооволонтер и хотел бы написать честный отзыв о работе Виктории для всех кто ищет врача стоматолога в Будве.

К этому врачу я попал после того, как изучил Телеграм, где Виктория показывала примеры своих работ. Я заметил, что она лечит детей, и для меня это стало основным критерием - я понял, что этому доктору можно доверять, ведь детей не обманешь.

Скажу сразу, что я очень боялся стоматологии и врачей в целом с детства, и это сохранилось и во взрослом возрасте. Я очень редко посещал стоматологические клиники, и это было только в экстренных случаях, когда зуб болел 2-3 дня.

Однажды в осенний дождливый день, когда ветер завывал  настолько сильно что двигал черепицу на вилле, где я живу, я увидел работу Виктории по отбеливанию зубов и понял, что уровень её работы весьма высок. Мне понравились примеры до и после, и я решил, что хочу сделать то же, потому что желтые зубы мне порядком надоели, и я захотел их отбелить.

Я списался с Викторией и задал ряд вопросов о том, больно ли делать отбеливание, не вредно ли это для эмали зубов, какие есть ограничения и так далее. Получив исчерпывающую консультацию, я убедился в компетентности и клиентоориентированности врача и записался на первичный приём. Учитывая, что я не обращался к стоматологу с лечением примерно 10 лет, у меня, конечно, был кариес. Чтобы понять, где он точно находится, я решил сделать гигиеническую чистку зубов, последний раз делавшуюся мной 2-3 года назад. Помню это прекрасное чувство чистых и гладких зубов.

Посетив Викторию и сделав гигиеническую чистку зубов, мы столкнулись с тем, что у меня на 6 зубах (точнее, между ними) был обнаружен кариес, который, конечно, надо было лечить. Я очень боялся, но согласился пройти процедуру лечения всех зубов, ещё раз доверившись Виктории. Это заняло определённое время и около 5 посещений в сумме. Хочу отметить, что несмотря на мои страхи и опасения потерять сознание или просто умереть от нервных переживаний, всё прошло максимально гладко, безопасно и без боли. Я реально не ожидал, что современная анестезия и профессионализм врача могут творить чудеса. За все 5 сеансов лечения зубов мне ни разу не сделали больно, более того, я могу сказать, что если закрыть глаза, то можно просто уснуть на приёме! Это невероятно, но факт.

Пролечив все зубы, я полностью доверился этому замечательному и внимательному врачу. На каждый сеанс я приходил уже без боязни. Мне было максимально комфортно и уютно, я чувствовал себя в безопасности. Да, так бывает, взрослый мужчина может бояться кабинета стоматолога, но в этот раз мой страх был побеждён.

После того как все зубы были пролечены, я конечно сделал отбеливание зубов как и было запланировано. Процедура заняла всего один сеанс. Как и обещала Виктория, это совсем не больно и даже не было неприятно.

Теперь мои зубы белые, здоровые и красиво выглядят.

Я не боюсь больше стоматологии, как боялся раньше. Хочу выразить большую благодарность Виктории за проведённое лечение, оказанную помощь, консультации и в целом за человеческое, порядочное отношение к клиенту. С ней всегда было комфортно, безопасно, и главное - я получил тот результат, на который рассчитывал.

Если в Будве или даже в Черногории вы ищете для себя или ребёнка настоящего профессионального врача и не знаете, кому довериться, я смело могу рекомендовать Викторию.

#Гигиеническая чистка
#Отбеливание зубов
#Лечение кариеса
#Отзыв от клиента
#Будва стоматолог
#Честный отзыв
#Черногория', NULL, NULL,
    3, '2024-10-29 00:00:00'),

(@user_kult_lichnosti, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUNsbmV1LTRRRRAB',
    5, 'ru', 'Хочу оставить отзыв о клинике, а конкретно о враче Евдокимовой Виктории. Переехал в Черногорию не так давно и, конечно, занялся поиском врачей. Стоматолог входит в мой список обязательных к посещению каждые пол года. Но учитывая, что я не был у врача год в связи с переездом, у меня разболелся зуб, которому была нужна срочная помощь. По поиску в Гугл я набрал клинику и вот самая первая куда я решил обратиться и не зря!! На ресепшене меня встретил доброжелательный администратор и нашел ближайшей свободное время, через несколько дней я приехал на лечение и попал к замечательному  доктору Виктории. Самое главное, что без боли и процедура была комфортная, боль ушла. Как я благодарен, спасибо Вам большое.
Буду рекомендовать всем друзьям и знакомым. Клиника находится вдоль дороги рядом с отелем дюклей, в клинике есть рентген аппарат. Что немаловажно !
P.s счастливый теперь уже Ваш постоянный пациент !',
    NULL, NULL, NULL, 'Хочу оставить отзыв о клинике, а конкретно о враче Евдокимовой Виктории. Переехал в Черногорию не так давно и, конечно, занялся поиском врачей. Стоматолог входит в мой список обязательных к посещению каждые пол года. Но учитывая, что я не был у врача год в связи с переездом, у меня разболелся зуб, которому была нужна срочная помощь. По поиску в Гугл я набрал клинику и вот самая первая куда я решил обратиться и не зря!! На ресепшене меня встретил доброжелательный администратор и нашел ближайшей свободное время, через несколько дней я приехал на лечение и попал к замечательному  доктору Виктории. Самое главное, что без боли и процедура была комфортная, боль ушла. Как я благодарен, спасибо Вам большое.
Буду рекомендовать всем друзьям и знакомым. Клиника находится вдоль дороги рядом с отелем дюклей, в клинике есть рентген аппарат. Что немаловажно !
P.s счастливый теперь уже Ваш постоянный пациент !', NULL, NULL,
    3, '2024-10-29 00:00:00'),

(@user_vyacheslav_vlasov, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSUNsbmVtdGF3EAE',
    5, 'ru', 'Сделал у Виктории air flow и чистку зубного камня. За 15 лет что я делаю эту процедуру ещё никто не делал настолько качественно и мягко. Я в шоке что так можно было. В случае пломб и других процедур буду теперь ходить. Так что если вдруг отъеду в этой Черногории от аппендицита, то хотя бы с чистыми и здоровыми зубами. :)',
    NULL, NULL, NULL, 'Сделал у Виктории air flow и чистку зубного камня. За 15 лет что я делаю эту процедуру ещё никто не делал настолько качественно и мягко. Я в шоке что так можно было. В случае пломб и других процедур буду теперь ходить. Так что если вдруг отъеду в этой Черногории от аппендицита, то хотя бы с чистыми и здоровыми зубами. :)', NULL, NULL,
    3, '2024-10-29 00:00:00'),

(@user_yakov_volkov, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUNsLWVHVHVRRRAB',
    5, 'ru', 'Лечил у доктора Виктории кариес и теперь хожу регулярно на проф.гигиену. Хочу отметить мастерство и профессионализм доктора. Все делает четко, аккуратно и безболезненно! При первом визите мне были даны подробные рекомендации по домашнему уходу и разъяснения на все мои вопросы.',
    NULL, NULL, NULL, 'Лечил у доктора Виктории кариес и теперь хожу регулярно на проф.гигиену. Хочу отметить мастерство и профессионализм доктора. Все делает четко, аккуратно и безболезненно! При первом визите мне были даны подробные рекомендации по домашнему уходу и разъяснения на все мои вопросы.', NULL, NULL,
    4, '2024-10-29 00:00:00'),

(@user_alexandra_savelyeva, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSUNsNmRpWFdnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_polina_anokhina, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUNscWJucDdRRRAB',
    5, 'ru', 'Клиника очень хорошая, доктора замечательные) лечусь сама и рекомендовала  бы другим!',
    NULL, NULL, NULL, 'Клиника очень хорошая, доктора замечательные) лечусь сама и рекомендовала  бы другим!', NULL, NULL,
    4, '2024-10-29 00:00:00'),

(@user_ilya_veprintsev, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSUNsb2VMT0t3EAE',
    5, 'ru', 'Мне повезло попасть к доктору Виктории. Она буквально спасла мне зуб, кроме того это была самая комфортная проф гигиена в моей жизни. Огромное спасибо!',
    NULL, NULL, NULL, 'Мне повезло попасть к доктору Виктории. Она буквально спасла мне зуб, кроме того это была самая комфортная проф гигиена в моей жизни. Огромное спасибо!', NULL, NULL,
    4, '2024-10-29 00:00:00'),

(@user_selena_soler, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSURGejlxQUtBEAE',
    1, 'ru', 'Мне не повезло лечиться у Евдокимовой Виктории. Удивительно что в такой крупной клиники работают такие отвратительные врачи. Мне нужно было поменять пломбу в зубе. Врачу были предоставлены снимки зуба и озвучена ясная просьба. Заменить пломбу в седьмом зубе. Лечение началось с того что врач не смог с первого раза правильно ввести обезболивающее и пришлось ввести аж две ампулы хотя требовалось всего половина. А после часа сверления оказалось что Виктория рассвеплила соседний шестой зуб, который не нуждался в лечении. Что происходило в голове у доктора на протяжении всего этого времени и почему она рассверлила зуб не нуждающийся в лечении не понятно. Но мало того она не извенилась и не признала своей ошибки. Взяла деньги за лечение двух зубов вместо одного и поставила временную пломбу с обещаниям потом всё исправить так как исправить свою ошибку у неё уже не было времени. А ещё через несколько дней она вообще стала отрицать свою причастность к рассверленному зубу в хамской манере заявляя что она хороший доктор. В итоге мне пришлось искать другого врача что бы исправить ошибку Виктории. И залечить рассверленный ею по ошибки зуб.  Никогда не встречала таких не профессионалов, которые лишены каких либо человеческих качеств и просто элементарной ответственности за свои поступки.',
    NULL, NULL, NULL, 'Мне не повезло лечиться у Евдокимовой Виктории. Удивительно что в такой крупной клиники работают такие отвратительные врачи. Мне нужно было поменять пломбу в зубе. Врачу были предоставлены снимки зуба и озвучена ясная просьба. Заменить пломбу в седьмом зубе. Лечение началось с того что врач не смог с первого раза правильно ввести обезболивающее и пришлось ввести аж две ампулы хотя требовалось всего половина. А после часа сверления оказалось что Виктория рассвеплила соседний шестой зуб, который не нуждался в лечении. Что происходило в голове у доктора на протяжении всего этого времени и почему она рассверлила зуб не нуждающийся в лечении не понятно. Но мало того она не извенилась и не признала своей ошибки. Взяла деньги за лечение двух зубов вместо одного и поставила временную пломбу с обещаниям потом всё исправить так как исправить свою ошибку у неё уже не было времени. А ещё через несколько дней она вообще стала отрицать свою причастность к рассверленному зубу в хамской манере заявляя что она хороший доктор. В итоге мне пришлось искать другого врача что бы исправить ошибку Виктории. И залечить рассверленный ею по ошибки зуб.  Никогда не встречала таких не профессионалов, которые лишены каких либо человеческих качеств и просто элементарной ответственности за свои поступки.', NULL, NULL,
    6, '2024-10-29 00:00:00'),

(@user_vera_radaeva, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSUNaM2JUR1lREAE',
    5, 'ru', 'Долго выбирала клинику в Черногории, потому что боялась некачественного лечения. Остановилась на этой, полностью довольна своим выбором! Приятный врач, удобное кресло, высокое качество работы, спасибо!',
    NULL, NULL, NULL, 'Долго выбирала клинику в Черногории, потому что боялась некачественного лечения. Остановилась на этой, полностью довольна своим выбором! Приятный врач, удобное кресло, высокое качество работы, спасибо!', NULL, NULL,
    4, '2023-10-29 00:00:00'),

(@user_andrey_sazhin, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSURoaklHaHhBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_liuba_r, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSUQtdjRiVGVBEAE',
    2, 'ru', 'Вроде бы, приличная клиника, хороший сайт, хорошие отзывы.
Но мой опыт взаимодействия с клиникой оказался неудачным!
Я пыталась записаться в клинику через форму обратной связи. Ответ не получила. Записалась по телефону. Объяснила ситуацию, но меня записали к терапевту, который не мог бы мне составить план действий. Мне не сказали изначально, что имплантолог приезжает только по воскресеньям. Ехала из Бара. Озвучили в одном филиале одну стоимость работ. Поехала со снимком во второй, чтобы получить финальную консультацию и принять решение о работе. В итоге услышала цену в 2 раза выше! Сложилось ощущение, что в стоимость дорога врача заложена, который едет из Белграда! Итого стоимость установки одного импланта выше 2000евро! И это Черногория!! При этом предоплату предлагали внести в первом филиале, без финального понимания ценообразования! Можно было бы сильно удивиться по итогу...

Да, вежливые врачи! Удобно, что говорят по-русски. Возможно, качество работы у них было бы хорошее, но такой прайс.. это космос!! Да и подход...

А ещё снимок сделали за 30евро. А он 2д
Пришла с ним в другую клинику, мне сказали, что он бесполезен! И нужен 3д для установки импланта.

В общем, не рекомендую эту клинику - пустая трата времени и денег!!!',
    NULL, NULL, NULL, 'Вроде бы, приличная клиника, хороший сайт, хорошие отзывы.
Но мой опыт взаимодействия с клиникой оказался неудачным!
Я пыталась записаться в клинику через форму обратной связи. Ответ не получила. Записалась по телефону. Объяснила ситуацию, но меня записали к терапевту, который не мог бы мне составить план действий. Мне не сказали изначально, что имплантолог приезжает только по воскресеньям. Ехала из Бара. Озвучили в одном филиале одну стоимость работ. Поехала со снимком во второй, чтобы получить финальную консультацию и принять решение о работе. В итоге услышала цену в 2 раза выше! Сложилось ощущение, что в стоимость дорога врача заложена, который едет из Белграда! Итого стоимость установки одного импланта выше 2000евро! И это Черногория!! При этом предоплату предлагали внести в первом филиале, без финального понимания ценообразования! Можно было бы сильно удивиться по итогу...

Да, вежливые врачи! Удобно, что говорят по-русски. Возможно, качество работы у них было бы хорошее, но такой прайс.. это космос!! Да и подход...

А ещё снимок сделали за 30евро. А он 2д
Пришла с ним в другую клинику, мне сказали, что он бесполезен! И нужен 3д для установки импланта.

В общем, не рекомендую эту клинику - пустая трата времени и денег!!!', NULL, NULL,
    7, '2023-10-29 00:00:00'),

(@user_furkan, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUQtOF91X3hBRRAB',
    1, 'tr', 'Kesinlikle gitmeyin önce dolguyu söktü ardından dişin nasıl çekileceğini bilmiyorum diyerek işleme devam etmedi ve onun yüzünden 3 gündür acı çekiyorum ve üzerine birde para ödedim',
    NULL, NULL, NULL, NULL, NULL, 'Kesinlikle gitmeyin önce dolguyu söktü ardından dişin nasıl çekileceğini bilmiyorum diyerek işleme devam etmedi ve onun yüzünden 3 gündür acı çekiyorum ve üzerine birde para ödedim',
    2, '2023-10-29 00:00:00'),

(@user_richard_wannemacher, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSUMtbkxDZ0JREAE',
    5, 'en', 'Exelent! Topp service and very nice people and staff. I can highly recomend them if you need any dentalwork done. For me, beeing from Norway, the prices are very cheap. Se you in the spring 👍😁',
    NULL, NULL, 'Exelent! Topp service and very nice people and staff. I can highly recomend them if you need any dentalwork done. For me, beeing from Norway, the prices are very cheap. Se you in the spring 👍😁', NULL, NULL, NULL,
    3, '2022-10-29 00:00:00'),

(@user_kbra_kaplan, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUMtb05TaXhBRRAB',
    1, 'en', 'Dissapointment.. I have been in many countries.  This is the worst clinic ever.  They tell you that will make canal treatment but when you go they say that no we didnt say this. They give you appointment but when you go there is no doctor.  Never again..',
    NULL, NULL, 'Dissapointment.. I have been in many countries.  This is the worst clinic ever.  They tell you that will make canal treatment but when you go they say that no we didnt say this. They give you appointment but when you go there is no doctor.  Never again..', NULL, NULL, NULL,
    3, '2022-10-29 00:00:00'),

(@user_ludwig_eugene, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUQyNHFfbnN3RRAB',
    5, 'en', 'Great job and great service! Very profesional doctor with definetily huge experience.',
    NULL, NULL, 'Great job and great service! Very profesional doctor with definetily huge experience.', NULL, NULL, NULL,
    1, '2022-10-29 00:00:00'),

(@user_a_i, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2bGY3dDJnRRAB',
    5, 'en', 'I had a fantastic experience here. The service was fast, efficient, affordable, and very friendly. I would recommend Dental Montenegro to all of my friends and family! Thank you so much for the fantastic experience!',
    NULL, NULL, 'I had a fantastic experience here. The service was fast, efficient, affordable, and very friendly. I would recommend Dental Montenegro to all of my friends and family! Thank you so much for the fantastic experience!', NULL, NULL, NULL,
    1, '2021-10-29 00:00:00'),

(@user_julia_koimshidi, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2NHZfaTF3RRAB',
    5, 'ru', 'Знакома с этой клиникой с 2010 года, лечила зубы, в последствии ставили коронки и виниры. Сервис был на высоте. Проблем нет до сих пор. При посещении московского стоматолога: его удивило качество коронок и сказал, что наши технологии не позволяют слелать такие качественные коронки. Спасибо за мою уверенную и ослепительно красивую улыбку🥰',
    NULL, NULL, NULL, 'Знакома с этой клиникой с 2010 года, лечила зубы, в последствии ставили коронки и виниры. Сервис был на высоте. Проблем нет до сих пор. При посещении московского стоматолога: его удивило качество коронок и сказал, что наши технологии не позволяют слелать такие качественные коронки. Спасибо за мою уверенную и ослепительно красивую улыбку🥰', NULL, NULL,
    5, '2021-10-29 00:00:00'),

(@user_evgeniy_ka, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSURpbVotRWdnRRAB',
    5, 'ru', 'Доктор говорит по-русски, обучалась в Первом Меде в Питере.',
    NULL, NULL, NULL, 'Доктор говорит по-русски, обучалась в Первом Меде в Питере.', NULL, NULL,
    2, '2021-10-29 00:00:00'),

(@user_mel, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSUNzOW9MRkp3EAE',
    5, 'en', 'I was traveling through and my retainer came loose. I decided to come here because the communication was easy and transparent via Mail and they spoke good English.
When I arrived everybody was super nice. I was a little nervous and Dr. Nikolina Glusica was very understanding and made smalltalk with me so I could relax.
The treatment was clean, fast and professional.
I highly recommend them!',
    NULL, NULL, 'I was traveling through and my retainer came loose. I decided to come here because the communication was easy and transparent via Mail and they spoke good English.
When I arrived everybody was super nice. I was a little nervous and Dr. Nikolina Glusica was very understanding and made smalltalk with me so I could relax.
The treatment was clean, fast and professional.
I highly recommend them!', NULL, NULL, NULL,
    4, '2020-10-29 00:00:00'),

(@user_aleksandar_orevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSURNb0kyRUNnEAE',
    5, 'hr', 'Nikad bolje iskustvo kod stomatologa!',
    'Nikad bolje iskustvo kod stomatologa!', NULL, NULL, NULL, NULL, NULL,
    2, '2020-10-29 00:00:00'),

(@user_ana_vuckovic, @clinic_id, @doctor_bojana_ivanovic, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSUMwc2RuSUh3EAE',
    5, 'en', 'It was quite difficult for me to choose a right dentist. This choice turned out definitely the right one!  Staff is very professional and polite. The treatment was fast and with great results. Special thanks to Marina and to Dr. Bojana Ivanovic. I would recommend this center without hesitation!',
    NULL, NULL, 'It was quite difficult for me to choose a right dentist. This choice turned out definitely the right one!  Staff is very professional and polite. The treatment was fast and with great results. Special thanks to Marina and to Dr. Bojana Ivanovic. I would recommend this center without hesitation!', NULL, NULL, NULL,
    3, '2019-10-29 00:00:00'),

(@user_milena_montenegro, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSURZeHB1eGJnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_petar_abramovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSUNJamVLdFZnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_dj_tony_mc_break, @clinic_id, NULL, 'google_maps',
    'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUNRX0pfZTd3RRAB',
    5, 'en', 'Dental Cliniv Budva recension
A well run efficient dental practice with polite and friendly dentists and nurses.
-Quick and easy treatment
-Just as I wanted, a quick and easy check up with teeth cleaning. The staff are all really friendly and they made the process very easy
-this one was recommended and honestly I am super impressed, great staff, spoles facilities, modern equipment , everything I could wish for
-Great dental practice
-Very high standard of dentistry which is usually found in expensive private practices. Highly recommended.
- I both clean my teeth and did whittning to my teeth, I fel 40 years younger.
-No more fear going to the dentist!
-Everything was well organised, quickly done, both staff at the reception and during the treatment were extremely kind and polite_Good offers and good prices
- Great Place to combine Holiday with dental treatment
- Lots Hotels front of dental clinic. Bus stop just a 50m away, Beach just 500m away
-I\'m one of those people who is normally not a fan of going to the dentist, but this clinic makes a difference by making you feel very welcome. Definitely would recommend it.
-My Dentist is friendly and professional.
-I’ve never liked going to the dentist, this dentist though has many Quality’s, the receptionists are helpful and outgoing and really polite.
-The dentist who had the tast to work on my teeth is by far the best dentist ive ever seen. To keep this short they made me feel relaxed, comfortable and kept me well informed of the process and could even have a bit of banter. Would like to say thanks',
    NULL, NULL, 'Dental Cliniv Budva recension
A well run efficient dental practice with polite and friendly dentists and nurses.
-Quick and easy treatment
-Just as I wanted, a quick and easy check up with teeth cleaning. The staff are all really friendly and they made the process very easy
-this one was recommended and honestly I am super impressed, great staff, spoles facilities, modern equipment , everything I could wish for
-Great dental practice
-Very high standard of dentistry which is usually found in expensive private practices. Highly recommended.
- I both clean my teeth and did whittning to my teeth, I fel 40 years younger.
-No more fear going to the dentist!
-Everything was well organised, quickly done, both staff at the reception and during the treatment were extremely kind and polite_Good offers and good prices
- Great Place to combine Holiday with dental treatment
- Lots Hotels front of dental clinic. Bus stop just a 50m away, Beach just 500m away
-I\'m one of those people who is normally not a fan of going to the dentist, but this clinic makes a difference by making you feel very welcome. Definitely would recommend it.
-My Dentist is friendly and professional.
-I’ve never liked going to the dentist, this dentist though has many Quality’s, the receptionists are helpful and outgoing and really polite.
-The dentist who had the tast to work on my teeth is by far the best dentist ive ever seen. To keep this short they made me feel relaxed, comfortable and kept me well informed of the process and could even have a bit of banter. Would like to say thanks', NULL, NULL, NULL,
    4, '2018-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUQtOF91X3hBRRAB'),
  'clinic', @clinic_id,
  'Vrlo ste nepristojni! Dat vam je antibiotik i receno je da treba da izvadite zub posle antibiotske terapije. Platili ste samo ortopan snimak!', 'hr',
  'Vrlo ste nepristojni! Dat vam je antibiotik i receno je da treba da izvadite zub posle antibiotske terapije. Platili ste samo ortopan snimak!', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2023-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChZDSUhNMG9nS0VJQ0FnSUMtbkxDZ0JREAE'),
  'clinic', @clinic_id,
  'Thank you dear Richard ! See you soon 🍀', 'en',
  NULL, NULL, 'Thank you dear Richard ! See you soon 🍀', NULL, NULL, NULL,
  'google_maps', '2023-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUMtb05TaXhBRRAB'),
  'clinic', @clinic_id,
  'Zao nam je sto napisali ovu objavu,objasnili smo vam da niste dobro razumeli.', 'hr',
  'Zao nam je sto napisali ovu objavu,objasnili smo vam da niste dobro razumeli.', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUQyNHFfbnN3RRAB'),
  'clinic', @clinic_id,
  'Thank a lot 🍀', 'en',
  NULL, NULL, 'Thank a lot 🍀', NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2bGY3dDJnRRAB'),
  'clinic', @clinic_id,
  'Thank you dear Alice 🙏
And see you soon 🍀', 'en',
  NULL, NULL, 'Thank you dear Alice 🙏
And see you soon 🍀', NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2NHZfaTF3RRAB'),
  'clinic', @clinic_id,
  'Thank you dear Julia. We are very grateful for your review 🌹', 'en',
  NULL, NULL, 'Thank you dear Julia. We are very grateful for your review 🌹', NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJLcP15BbUTRMRC61qGgrhtCw/reviews/ChdDSUhNMG9nS0VJQ0FnSURpbVotRWdnRRAB'),
  'clinic', @clinic_id,
  'Thank you dear Evgenii 🍀', 'en',
  NULL, NULL, 'Thank you dear Evgenii 🍀', NULL, NULL, NULL,
  'google_maps', '2022-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
