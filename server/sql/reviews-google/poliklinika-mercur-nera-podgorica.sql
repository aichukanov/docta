-- Insert Google Maps reviews for Mercur Nera
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/poliklinika-mercur-nera-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'poliklinika-mercur-nera-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_snezana_corac = (SELECT id FROM doctors WHERE slug = 'snezana-corac');
SET @doctor_predrag_rakocevic = (SELECT id FROM doctors WHERE slug = 'predrag-rakocevic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nastas\'a Volfovskaya', 'https://lh3.googleusercontent.com/a-/ALV-UjWAr2H234d54-ZxSyktUTsC26kNVVk1jWuYHsgjlheInh8KCi8H=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/106438308273787537974/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106438308273787537974/reviews');
SET @user_nastasa_volfovskaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106438308273787537974/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Stefanovic', 'https://lh3.googleusercontent.com/a/ACg8ocK9i3YXpzXtbiwPIhsgNLrcA5WJCjCa1c3DLxoyIZy7rWwT5w=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/116054394872453473409/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116054394872453473409/reviews');
SET @user_nikola_stefanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116054394872453473409/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alen Bikić', 'https://lh3.googleusercontent.com/a-/ALV-UjUD-fgCG_HfLR3ds1Iki6CYnhpqg_01Ot44XCfU9Ad7K8laex6G=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/104051648600231270589/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104051648600231270589/reviews');
SET @user_alen_biki = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104051648600231270589/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'We\'ll See', 'https://lh3.googleusercontent.com/a/ACg8ocImX32ZPdPr3Q5URN2sxJ9RoCMGzTyT63FlCALdgjlxHMoCsg=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/112128116500818995505/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112128116500818995505/reviews');
SET @user_well_see = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112128116500818995505/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Dragovic', 'https://lh3.googleusercontent.com/a-/ALV-UjU3FcVVV0Y5ZvxcYuPvSH9qmssezsPdEThUSN7osIu8NS6cfrqv=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/112723012854979842566/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112723012854979842566/reviews');
SET @user_milica_dragovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112723012854979842566/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Roberto Morić', 'https://lh3.googleusercontent.com/a-/ALV-UjXhNrANbcHqIPU-g6TDweuX12EbYvPDuFHO0VH6huogjbK0tcRh=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116431302983187954146/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116431302983187954146/reviews');
SET @user_roberto_mori = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116431302983187954146/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kristina Popovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXUvJa6vEmws_0bYLGHfIPE8c4181K77uWyRGg9WpPwhhyXAKo=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105439731241440160501/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105439731241440160501/reviews');
SET @user_kristina_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105439731241440160501/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'MILENA VLAHOVIC', 'https://lh3.googleusercontent.com/a/ACg8ocJ2fVKzqEOHF-OvJrM-N_A-fLg1f99L-1XMzhEcm_UXpl8D1Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117088762707814889993/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117088762707814889993/reviews');
SET @user_milena_vlahovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117088762707814889993/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vasilije Vukovic', 'https://lh3.googleusercontent.com/a/ACg8ocJC0y1w4Nj6V8mP5e3Jm8MSFEr-6KLTiduvBROu4CUA6Nr6OA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103784276836787216066/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103784276836787216066/reviews');
SET @user_vasilije_vukovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103784276836787216066/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natasa Stankovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVmxRgkrPxTya1hX-w5FUmWmHwApCuP731zGh_Vs0pB_AIlkvn2=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103027700066672253057/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103027700066672253057/reviews');
SET @user_natasa_stankovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103027700066672253057/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milorad Ivanović', 'https://lh3.googleusercontent.com/a-/ALV-UjXr7a47HNd3i4h3uxS1r7Oq_O3WeAiXtpyRTYRQl9_uIVt1euX2BQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102904316315733394938/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102904316315733394938/reviews');
SET @user_milorad_ivanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102904316315733394938/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Boris Risteski', 'https://lh3.googleusercontent.com/a/ACg8ocIZq1VwVXB2vCbyKiVhVxmRLPQ_ph-21d0SNIhKO694kpmL6rE=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114221857475309183897/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114221857475309183897/reviews');
SET @user_boris_risteski = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114221857475309183897/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Svetlana Kraljević', 'https://lh3.googleusercontent.com/a-/ALV-UjXnMlp9DjARREBm3zekf_J26CiGSOUb1ku7L-d2w0ZFD6bprS7b=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109812757571538906095/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109812757571538906095/reviews');
SET @user_svetlana_kraljevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109812757571538906095/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Globarevic', 'https://lh3.googleusercontent.com/a/ACg8ocJG0C3Aoc21wX0vmX_2O4WiYxPUwF2swPGsMPdIGUkaJSiA6Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114127411065230992228/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114127411065230992228/reviews');
SET @user_milica_globarevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114127411065230992228/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zorica Vujičić', 'https://lh3.googleusercontent.com/a-/ALV-UjVmMToaGh7A4-t3m04HJ2vIXExO8FxRoS0KwzMjKKoIGC1zn1nd=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116710144906822006951/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116710144906822006951/reviews');
SET @user_zorica_vujii = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116710144906822006951/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stana Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocId1pZgHu7tTDsdntngKzpt63zoE9Rebm9Ehe-UYgCHxFWFhA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101277953225473246030/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101277953225473246030/reviews');
SET @user_stana_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101277953225473246030/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danijela Jeremic', 'https://lh3.googleusercontent.com/a/ACg8ocIKQqGWCDuHN0viCM3U0BPHzsA1DERrvHGKL7lxUd55nuJDSg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110685431090937688608/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110685431090937688608/reviews');
SET @user_danijela_jeremic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110685431090937688608/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lma Lma', 'https://lh3.googleusercontent.com/a/ACg8ocJ62La9r518PlNnc5SV7jBTAxR9uvHnAOjPSyVajGaJz4a6rA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108081730843624520581/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108081730843624520581/reviews');
SET @user_lma_lma = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108081730843624520581/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Dragutinovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXBfQd4G_cOivMGn5MtOG1h9U8Bnq8-4Cyrok-ZWzp-x4QjxH7h=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104043092962301379934/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104043092962301379934/reviews');
SET @user_ana_dragutinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104043092962301379934/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Violeta Dimitrijevic', 'https://lh3.googleusercontent.com/a-/ALV-UjXtjMF6g_BvEVnhYwETBJ9YjIIqO5K9CFNv1Tcm4Yb4UDOOW2ZzVA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106441714890705406640/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106441714890705406640/reviews');
SET @user_violeta_dimitrijevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106441714890705406640/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danica Pesic', 'https://lh3.googleusercontent.com/a/ACg8ocKz2w27oRNW6UKT5uVqpnzJucfYuUXiusBS-9CVP0Hh8-MBHQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113702894539538084249/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113702894539538084249/reviews');
SET @user_danica_pesic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113702894539538084249/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radovan Radojević', 'https://lh3.googleusercontent.com/a-/ALV-UjX5dX1Gonb9Efr_9EFhd0SCwN46X2jwlEe1O69UDWzbYneuUvH_=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105977946703564418543/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105977946703564418543/reviews');
SET @user_radovan_radojevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105977946703564418543/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_nastasa_volfovskaya, @clinic_id, @doctor_predrag_rakocevic, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KWWJVWmxlbTlOZFdsMVRrMHlZa1pTVEhKeVRGRRAB',
    5, 'hr', 'Cele trudnoće otišla kod doktora Predraga Radočevića i sam baš zadovoljna. Sve objašnjava jasno i strukturno, istovremeno, što je moguće brižnije i prijateljske. Baš je zadovoljna! Lepi su administratori. Sve su dobri i pažljivi.',
    'Išla sam kod dr Predraga Radočevića tokom cele trudnoće i veoma sam zadovoljna. Sve objašnjava jasno i strukturirano, a istovremeno, što je moguće brižniji i ljubazniji. Veoma sam zadovoljna! Administratori su ljubazni. Svi su dobri i pažljivi.', 'Ишла сам код др Предрага Радочевића током целе трудноће и веома сам задовољна. Све објашњава јасно и структурирано, а истовремено, што је могуће брижнији и љубазнији. Веома сам задовољна! Администратори су љубазни. Сви су добри и пажљиви.', NULL, NULL, NULL, NULL,
    0, '2026-01-19 10:16:28'),

(@user_nikola_stefanovic, @clinic_id, @doctor_snezana_corac, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChdDSUhNMG9nS0VJQ0FnSURKaDZiNjF3RRAB',
    1, 'bs', 'Hematolog Ćorac krajnje neprofesionalna, drska, bezobrazna. Jako loš odnos sa pacijentima. Nikako je ne bih preporučio! Što dalje od nje! Jer ipak njene usluge mi plaćamo da bi ona imala tako katastrofalno ponašanje prema pacijentima.',
    'Hematolog Ćorac je izuzetno neprofesionalan, bezobrazan i grub. Veoma loš odnos sa pacijentima. Ne bih je nikako preporučio! Klonite je se! Na kraju krajeva, mi plaćamo njene usluge da bi se ona tako katastrofalno ponašala prema pacijentima.', 'Хематолог Ћорац је изузетно непрофесионалан, безобразан и груб. Веома лош однос са пацијентима. Не бих је никако препоручио! Клоните је се! На крају крајева, ми плаћамо њене услуге да би се она тако катастрофално понашала према пацијентима.', NULL, NULL, NULL, NULL,
    2, '2023-07-23 23:08:58'),

(@user_alen_biki, @clinic_id, NULL, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChZDSUhNMG9nS0VJQ0FnSUNzN2VuOWVREAE',
    5, 'bs', 'Veoma ljubazno osoblje, profesionalci i veoma kooperativni. Čast mi je sarađivati sa njima.',
    'Veoma ljubazno osoblje, profesionalno i veoma saradljivo. Čast je sarađivati sa njima.', 'Веома љубазно особље, професионално и веома сарадљиво. Част је сарађивати са њима.', NULL, NULL, NULL, NULL,
    1, '2020-02-10 20:18:34'),

(@user_well_see, @clinic_id, NULL, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChZDSUhNMG9nS0VJQ0FnSUNpbEtySkx3EAE',
    1, 'en', 'Too expensive to renew RCL medical certificates. €280 while my husband gets it done for only $100 in Ukraine',
    'Preskupo je obnavljanje lekarskih sertifikata za licencirane učesnike. 280 evra, dok moj muž to radi za samo 100 dolara u Ukrajini.', 'Прескупо је обнављање лекарских сертификата за лиценциране учеснике. 280 евра, док мој муж то ради за само 100 долара у Украјини.', 'Too expensive to renew RCL medical certificates. €280 while my husband gets it done for only $100 in Ukraine', NULL, NULL, NULL,
    3, '2020-10-22 17:01:09'),

(@user_milica_dragovic, @clinic_id, @doctor_snezana_corac, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChZDSUhNMG9nS0VJQ0FnSUNtaGNtTUFnEAE',
    5, 'hr', 'Dr Ćorac, profesionalna i  ljubazna. Vec 7 godina sam korisnik usluga mercur nere. Sve preporuke I pohvale',
    'dr Ćorac, stručan i ljubazan. Već 7 godina sam korisnik usluga Merkur Nere. Sve preporuke i pohvale', 'др Ћорац, стручан и љубазан. Већ 7 година сам корисник услуга Меркур Нере. Све препоруке и похвале', NULL, NULL, NULL, NULL,
    0, '2022-01-03 17:43:44'),

(@user_roberto_mori, @clinic_id, NULL, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChZDSUhNMG9nS0VJQ0FnSUNabTVUalN3EAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_kristina_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChZDSUhNMG9nS0VJQ0FnSUN4d2JmdVpREAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_milena_vlahovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChZDSUhNMG9nS0VJQ0FnSUN4aXI3X1JnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_vasilije_vukovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChZDSUhNMG9nS0VJQ0FnSURSbVlqZExREAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_natasa_stankovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChZDSUhNMG9nS0VJQ0FnSUNoNDR2OUNREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_milorad_ivanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChdDSUhNMG9nS0VJQ0FnSURheHRIN29BRRAB',
    5, 'hr', 'Kvalitetne usluge, ljubaznos.',
    'Kvalitetne usluge, ljubaznos.', NULL, NULL, NULL, NULL, NULL,
    1, '2021-10-29 00:00:00'),

(@user_boris_risteski, @clinic_id, NULL, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChZDSUhNMG9nS0VJQ0FnSURxXzdTZFNBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_svetlana_kraljevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChdDSUhNMG9nS0VJQ0FnSUNxcmRUNS1RRRAB',
    1, 'hr', 'Neljubaznost osoblja',
    'Neljubaznost osoblja', NULL, NULL, NULL, NULL, NULL,
    4, '2021-10-29 00:00:00'),

(@user_milica_globarevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChZDSUhNMG9nS0VJQ0FnSURDc2QzTlhnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_zorica_vujii, @clinic_id, NULL, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChdDSUhNMG9nS0VJQ0FnSURjaDR2a2hnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_stana_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChdDSUhNMG9nS0VJQ0FnSURzaGFyWF93RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_danijela_jeremic, @clinic_id, NULL, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChdDSUhNMG9nS0VJQ0FnSUNzekt1TmtRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_lma_lma, @clinic_id, @doctor_snezana_corac, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChdDSUhNMG9nS0VJQ0FnSURNaDZEUjNnRRAB',
    1, 'hr', 'Neljubazno osoblje, losa saradnja sa doktoricom Ćorac, losa usluga..

Unkind staff, poor cooperation with dr Ćorac, poor service..',
    'Neljubazno osoblje, losa saradnja sa doktoricom Ćorac, losa usluga..

Unkind staff, poor cooperation with dr Ćorac, poor service..', NULL, NULL, NULL, NULL, NULL,
    7, '2020-10-29 00:00:00'),

(@user_ana_dragutinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChZDSUhNMG9nS0VJQ0FnSUM0NGFMVGRREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_violeta_dimitrijevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChdDSUhNMG9nS0VJQ0FnSUNJaGV5RXB3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_danica_pesic, @clinic_id, NULL, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChZDSUhNMG9nS0VJQ0FnSUR3dE5mMUNnEAE',
    5, 'en', 'Dr  Filipović jeste exelents.,the Best hirurg Magister of medical',
    NULL, NULL, 'Dr  Filipović jeste exelents.,the Best hirurg Magister of medical', NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_radovan_radojevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJARdxydjqTRMRs1L64zL89Gw/reviews/ChdDSUhNMG9nS0VJQ0FnSURnemVPbHRRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
