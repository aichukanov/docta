-- Insert Google Maps reviews for Stomatološka ordinacija Dr Numanović - Podgorica
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/numanovic-dental-aesthetic-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'numanovic-dental-aesthetic-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_eldin_numanovic = (SELECT id FROM doctors WHERE slug = 'eldin-numanovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragan Krgovic', 'https://lh3.googleusercontent.com/a/ACg8ocIe01SKTffKQE4FnSOY09e9x_gy_YgVM6sWxdQGQJkqMOnLjQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111823605340603517804/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111823605340603517804/reviews');
SET @user_dragan_krgovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111823605340603517804/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Biljana Brnovic', 'https://lh3.googleusercontent.com/a/ACg8ocJMzGe0W5GdM3FWT5HkknG6NL1sXQ8ABI9B7mEuUsrZ_lHmoA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/110633928894631031507/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110633928894631031507/reviews');
SET @user_biljana_brnovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110633928894631031507/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Denisa Krgovic', 'https://lh3.googleusercontent.com/a/ACg8ocJMJw6Uzh_AxvNwFI8YPty14Ucfo8aOt_QE0Gj4GUBF6gHxSA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/117639587369129162123/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117639587369129162123/reviews');
SET @user_denisa_krgovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117639587369129162123/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rejhan Omeranovic', 'https://lh3.googleusercontent.com/a/ACg8ocJq9CHzOZQowiPcIbT6yK8oj_ppx2wMjuQ19mgdZTaN7Pi2=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/108574998894766018886/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108574998894766018886/reviews');
SET @user_rejhan_omeranovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108574998894766018886/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Demir Ramovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVE5oNM7SiaNoDki8b7OBeET_nfmuHej8QdsRD0qa-377zkxORygw=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/106967619695713787556/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106967619695713787556/reviews');
SET @user_demir_ramovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106967619695713787556/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Emir Delijic', 'https://lh3.googleusercontent.com/a/ACg8ocIyxPk5CDar-4Yjg5mRG9l2cQdv99v8rkeT-_YE5zX0mr2NhA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104383563942331341501/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104383563942331341501/reviews');
SET @user_emir_delijic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104383563942331341501/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandar Mijovic', 'https://lh3.googleusercontent.com/a/ACg8ocIEnBAIfK3TguO3hwPWxbq--tHunQKUVzwzmQWBMo1OQP6-uQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108874756455057945359/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108874756455057945359/reviews');
SET @user_aleksandar_mijovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108874756455057945359/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Draskovic', 'https://lh3.googleusercontent.com/a/ACg8ocKJk4KNEgV2NKpI3Gm10Rcocj0DJlAZnxNvdeb1pAS-L_NwbQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107804823112789505646/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107804823112789505646/reviews');
SET @user_luka_draskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107804823112789505646/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'semra spahic', 'https://lh3.googleusercontent.com/a/ACg8ocJs-_tZhUJgCO9Crs2RDfVgq66Bc76kO1W9_pIEQCjQO8cjdA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104907337472374865479/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104907337472374865479/reviews');
SET @user_semra_spahic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104907337472374865479/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Đurišić', 'https://lh3.googleusercontent.com/a-/ALV-UjUtIyquMEDxbfXvnXcPE9EsYAyYmLMS4AsxhTlSdoBnUFkvPGOH=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106164808245781017219/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106164808245781017219/reviews');
SET @user_ivana_urii = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106164808245781017219/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dijana Calic', 'https://lh3.googleusercontent.com/a/ACg8ocIrj559zLgb3mMRKT5agNJERqGzUNzTU0SpaByJp89AX3ejPm_j=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113850701858401648252/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113850701858401648252/reviews');
SET @user_dijana_calic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113850701858401648252/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elma Ramovic', 'https://lh3.googleusercontent.com/a/ACg8ocLPgPvR-nU8vwFS-GV-wLndSDUF8tG08iZlt0xN6GcN-SmhRQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115354510491934556733/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115354510491934556733/reviews');
SET @user_elma_ramovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115354510491934556733/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pavle Nikolic', 'https://lh3.googleusercontent.com/a/ACg8ocJVB6-NaYMvNcRbVYu5p7b3ZMfUoNi3vEANF6TGIm8PPXyf3A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118385310470927532777/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118385310470927532777/reviews');
SET @user_pavle_nikolic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118385310470927532777/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Veljko Globarevic', 'https://lh3.googleusercontent.com/a/ACg8ocIPAX7ZrMZQuLAFNwa3dfEJ2ZLLh1jAGAOTjLBz_cEKQsu2Bw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105096509543781435023/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105096509543781435023/reviews');
SET @user_veljko_globarevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105096509543781435023/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kristina Djulejic', 'https://lh3.googleusercontent.com/a-/ALV-UjWgCzaButrXKzmwawvO6o-zxLN5rcx-Yvlk_88X8BhiYpAO7G-B=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102980962562513407672/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102980962562513407672/reviews');
SET @user_kristina_djulejic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102980962562513407672/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Keevin Prince', 'https://lh3.googleusercontent.com/a/ACg8ocISnVwXNy4583fDW6fQctLOhXEby9It6OHLYVMA_fVweMosUg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108974612804626153690/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108974612804626153690/reviews');
SET @user_keevin_prince = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108974612804626153690/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Maras', 'https://lh3.googleusercontent.com/a-/ALV-UjXFc3ZD6FhosjPn4mtpPg5P8mKdUaqjvuOLFOYLJVHSOIKsLTg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114864374279806489965/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114864374279806489965/reviews');
SET @user_marko_maras = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114864374279806489965/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Šćepan Drašković', 'https://lh3.googleusercontent.com/a-/ALV-UjWjPaRXUJq8AHZ28c2dpTVOR4VXI4-KN68DHvuqfmqgsLHbEwFkSw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117645270596917568522/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117645270596917568522/reviews');
SET @user_epan_drakovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117645270596917568522/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jeka Drašković', 'https://lh3.googleusercontent.com/a/ACg8ocIXCFty232JYdiCpY67qFDKPh1Uwol09J--ZPlr4uWY5n2y2Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112723242446428340231/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112723242446428340231/reviews');
SET @user_jeka_drakovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112723242446428340231/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragoje Drašković', 'https://lh3.googleusercontent.com/a/ACg8ocLeOzRZpIIAJGGOj_vPeKtTPWtv_f3UWETyp-cVs0M_EYjIiQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100966128473950694026/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100966128473950694026/reviews');
SET @user_dragoje_drakovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100966128473950694026/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Novak Drašković', 'https://lh3.googleusercontent.com/a-/ALV-UjXHSOYnPxZohz1MENylZMukK17SrPxnygWZJ3hc-i5_SuXgDiDQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109954788288102551166/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109954788288102551166/reviews');
SET @user_novak_drakovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109954788288102551166/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Amar Numanovic', 'https://lh3.googleusercontent.com/a/ACg8ocJhNXNnN11_HlupAcTC3nkaktZFozReM3EnagWAaXKwTQcQwg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105986066111667789804/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105986066111667789804/reviews');
SET @user_amar_numanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105986066111667789804/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Filip Femic', 'https://lh3.googleusercontent.com/a/ACg8ocLb02yIhq-6Z93T2wJ3IWDhv1i3_yaVc_xhWg75UHwVFadslQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103283192749718001928/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103283192749718001928/reviews');
SET @user_filip_femic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103283192749718001928/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_dragan_krgovic, @clinic_id, @doctor_eldin_numanovic, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tKdlNUaHBhMUV6WlVsNFYyUkNSekIwWkV0amExRRAB',
    5, 'bs', 'Pozdrav, zelim da pohvalim rad stomatoloske ordinacije “ Numanovic “, koji se se prije svega odnosi na profesionalan i odgovoran pristup svom pozivu, a sto se ogleda kroz postignute rezultate u pruzanju stomatoloskih usluga, ciji sam i ja jedan od korisnika.
Takodje, ljubaznost i kvaliteni uslovi koje nudi ordinacija su sastavni dio mog ukupnog misljenja i ovog komentara.
Srecno u daljem radu !',
    'Pozdrav, zelim da pohvalim rad stomatoloske ordinacije “ Numanovic “, koji se se prije svega odnosi na profesionalan i odgovoran pristup svom pozivu, a sto se ogleda kroz postignute rezultate u pruzanju stomatoloskih usluga, ciji sam i ja jedan od korisnika.
Takodje, ljubaznost i kvaliteni uslovi koje nudi ordinacija su sastavni dio mog ukupnog misljenja i ovog komentara.
Srecno u daljem radu !', NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-11 16:28:14'),

(@user_biljana_brnovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT21neWFITTJOME56ZFRjMldFNDBZVkI0U0ROTGVVRRAB',
    5, 'hr', '"Topla preporuka za stomatologa, izuzetno stručan, pažljiv i profesionalan.Sve zahvate objašnjava jasno, radi bezbolno i s velikom posvećnošću pacijentu.Ordinacija je moderna i uredna i osjećaj povjerenja od prvog dolaska".',
    'Topla preporuka za stomatologa, izuzetno stručan, pažljiv i profesionalan. Jasno objašnjava sve procedure, radi bezbolno i sa velikom posvećenošću pacijentu. Ordinacija je moderna i uredna i postoji osećaj poverenja od prve posete.', 'Топла препорука за стоматолога, изузетно стручан, пажљив и професионалан. Јасно објашњава све процедуре, ради безболно и са великом посвећеношћу пацијенту. Ординација је модерна и уредна и постоји осећај поверења од прве посете.', NULL, NULL, NULL, NULL,
    0, '2026-01-11 13:02:21'),

(@user_denisa_krgovic, @clinic_id, @doctor_eldin_numanovic, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkUmNqbGhZVXR2U20xc00zWTRhbmx3T1ZCR05YYxAB',
    5, 'bs', 'Odradila sam obje vilice kod dr.Eldina prije 4 godine i preeezadovljna sam uslugom koju mi je pruzio.Vrlo profesionalni mladi ljudi rade u ordinaciji i pruzaju vrhunske usluge.Moja topla preporuka za njih i podrzavam i preporucujem svima da ih posjete jer znam da ce dijeliti moje misljenje i vracati se uvjek a biti docekani sa osnjehom🙏',
    'Pre 4 godine sam imao obe vilice kod dr Eldina i veoma sam zadovoljan uslugom koju mi je pružio. U ordinaciji rade veoma profesionalni mladi ljudi koji pružaju vrhunske usluge. Toplo ih preporučujem i podržavam i preporučujem svima da ih posete jer znam da će deliti moje mišljenje i uvek se vraćati i biti dočekani sa osmehom🙏', 'Пре 4 године сам имао обе вилице код др Елдина и веома сам задовољан услугом коју ми је пружио. У ординацији раде веома професионални млади људи који пружају врхунске услуге. Топло их препоручујем и подржавам и препоручујем свима да их посете јер знам да ће делити моје мишљење и увек се враћати и бити дочекани са осмехом🙏', NULL, NULL, NULL, NULL,
    0, '2026-01-11 16:13:08'),

(@user_rejhan_omeranovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCbllVbHNPSGxQTUcxT1pqWnZTbkZDZEdoeVdYYxAB',
    5, 'hr', 'Ja sam oduševljen, radio sam komplet gornje zube bez ikakvog bola i ispali su mi savršeni. Dolazim da radim i donje',
    'Oduševljena sam, gornje zube sam izlečila bez ikakvog bola i ispali su savršeno. Dolazim da izlečim i donje zube.', 'Одушевљена сам, горње зубе сам излечила без икаквог бола и испали су савршено. Долазим да излечим и доње зубе.', NULL, NULL, NULL, NULL,
    0, '2026-01-10 15:45:39'),

(@user_demir_ramovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tGTVgwSXpjVFJ5UzNONk1IWXRabUZ4ZHpKVlozYxAB',
    5, 'bs', 'Vrhunski zubar.
Bezbolno, sto je meni bilo najvaznije.
Nalazi se u centru Podgorice, brza, kvalitetna usluga.
Preporuka svima...',
    'Vrhunski zubar. Bezbolno, što mi je bilo najvažnije. Nalazi se u centru Podgorice, brza, kvalitetna usluga. Preporučujem svima...', 'Врхунски зубар. Безболно, што ми је било најважније. Налази се у центру Подгорице, брза, квалитетна услуга. Препоручујем свима...', NULL, NULL, NULL, NULL,
    0, '2026-01-11 12:27:09'),

(@user_emir_delijic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t0NFIydFFNVlJhUjI5a1EzaFJTMGgwUkcwelZGRRAB',
    5, 'hr', 'Drugar moj iz srednje stomatolog za pohvalu. Svaka preporuka!',
    'Drugar moj iz srednje stomatolog za pohvalu. Svaka preporuka!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_aleksandar_mijovic, @clinic_id, @doctor_eldin_numanovic, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT214eVJGRTJkSFZrZEY5bVEzVlJVUzFHY0U5RlZrRRAB',
    5, 'hr', 'Vrhunska usluga i briga o pacijentima. Dr. Eldin je vrlo ljubazan i profesionalan. Sve pohvale i preporuke!',
    'Vrhunska usluga i briga o pacijentima. Dr. Eldin je vrlo ljubazan i profesionalan. Sve pohvale i preporuke!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_luka_draskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKUmRHODJSREJaV0VWc1NUUTRhMjh4WTFSYU5rRRAB',
    5, 'hr', 'Prva liga',
    'Prva liga', NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_semra_spahic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT205b1JucFRkMmh2U2xST04yWTFXVEJ3VVZKbGVWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_ivana_urii, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5eFoxZEtTRVEwWkRkR00yRm5lVGRxWmpOdlRWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_dijana_calic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tacVEzaE1iWEZYU2xsT1JUQlFlVWRmYWtaaE4wRRAB',
    5, 'hr', 'Profesionalni, pazljivi i ljubazni 🤩',
    'Profesionalni, pazljivi i ljubazni 🤩', NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_elma_ramovic, @clinic_id, @doctor_eldin_numanovic, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSNVVHOUZjVGQzYzAxUWRHTTVTWFpoVjNGTFkwRRAB',
    5, 'hr', 'Najbolji stomatolog u Podgorici.
Ako zelite najljepši osmjeh, posjetite ordinaciju Numanovic ✨️❤️',
    'Najbolji stomatolog u Podgorici.
Ako zelite najljepši osmjeh, posjetite ordinaciju Numanovic ✨️❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_pavle_nikolic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KbFRtVTJNVEZLZFc1cFFqUklTelZ3V1RobGFsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_veljko_globarevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2taalZtaGhOakpyWHpWSk5IVlBkWE5HTW5CalFsRRAB',
    5, 'bs', 'Veoma profesionalna ordinacija u Podgorici sa odlicnom uslugom. Sve pohvale!',
    'Veoma profesionalna ordinacija u Podgorici sa odlicnom uslugom. Sve pohvale!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_kristina_djulejic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT21RM05GUkROMmhoWjBNeExXbFdjRUpQUTNaT1NWRRAB',
    5, 'bs', 'Odlicna, stomatološka ordinacija u Podgorici. Prezadovoljna sam uslugom!',
    'Odlicna, stomatološka ordinacija u Podgorici. Prezadovoljna sam uslugom!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_keevin_prince, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/ChZDSUhNMG9nS0VJQ0FnSUN4NzdYUE53EAE',
    5, 'bs', 'Vrhunska stomatološka ordinacija u Podgorici. Brzo, bezbolno i kvalitetno!',
    'Vrhunska stomatološka ordinacija u Podgorici. Brzo, bezbolno i kvalitetno!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_marko_maras, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT25rM1JGQkRlV2d6WDJGNWMwMXRVblJZVGpSUWVXYxAB',
    5, 'bs', 'Najbolja ordinacija u Podgorici!!Sve pohvale za zaposlene,veoma ljubazni i profesionalni!',
    'Najbolja ordinacija u Podgorici!!Sve pohvale za zaposlene,veoma ljubazni i profesionalni!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_epan_drakovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT200M1pUVmZSRWQzWWs5bmNXeHdkRlpMYWpsTmIxRRAB',
    5, 'hr', 'Profesionalnost, stručnost, ljubaznost... Sve preporuke.',
    'Profesionalnost, stručnost, ljubaznost... Sve preporuke.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_jeka_drakovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT21ST1dESnBjVWw0VDJoSE1XTXRXWGxqTTFOeFZFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_dragoje_drakovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT25sblJGVm9kV0pVZDNKbk9GcEZhbXhYZGtoeFExRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_novak_drakovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tKNk5WUkRlbGgxU0ZwUWVGOWlUWGx3Y1Y5bFVIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_amar_numanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/ChZDSUhNMG9nS0VJQ0FnSUN4NzQyQVRBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_filip_femic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNXZ28yNmZREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ73Ry4dXrTRMRm2ShmpTyQfc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tGTVgwSXpjVFJ5UzNONk1IWXRabUZ4ZHpKVlozYxAB'),
  'clinic', @clinic_id,
  'Hvala Vam Demire!
Uvijek nam je drago kada pacijent iz ordinacije izađe zadovoljan i nasmijan!', 'hr',
  'Hvala Vam Demire!
Uvijek nam je drago kada pacijent iz ordinacije izađe zadovoljan i nasmijan!', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
