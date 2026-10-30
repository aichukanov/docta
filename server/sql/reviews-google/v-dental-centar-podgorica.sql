-- Insert Google Maps reviews for V Dental Centar
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/v-dental-centar-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'v-dental-centar-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_aleksandar_vukotic = (SELECT id FROM doctors WHERE slug = 'aleksandar-vukotic');
SET @doctor_zoran_vlahovic = (SELECT id FROM doctors WHERE slug = 'zoran-vlahovic');
SET @doctor_milan_martinovic = (SELECT id FROM doctors WHERE slug = 'milan-martinovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Martin Frost', 'https://lh3.googleusercontent.com/a-/ALV-UjXb3Xh2tDf89Yt266bmF_Y1g3KoCTnvLlT6zFeyf7atCZMNlJpxTw=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/101673079294272514375/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101673079294272514375/reviews');
SET @user_martin_frost = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101673079294272514375/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Batricevic', 'https://lh3.googleusercontent.com/a/ACg8ocIDAD5zq4h4CuK-aOsawt48UK28eVsiTgNTxW_kOeoW39pX4w=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111807605604539631243/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111807605604539631243/reviews');
SET @user_ivana_batricevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111807605604539631243/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Miljana Femic', 'https://lh3.googleusercontent.com/a-/ALV-UjX4IqiQSmo9wRuuVwvug_vfOR0vd5AGOD7okPsCOc-M5T4v_7W1=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/108886638904506818228/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108886638904506818228/reviews');
SET @user_miljana_femic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108886638904506818228/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danijela Djurisic', 'https://lh3.googleusercontent.com/a-/ALV-UjX1dzeHS4-NX3rZLijm35_rS9Wyfs0qRBLU-RZdZ7E8hoHxK8T9XQ=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/102085385945338649301/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102085385945338649301/reviews');
SET @user_danijela_djurisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102085385945338649301/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Kovacevic', 'https://lh3.googleusercontent.com/a-/ALV-UjU3d4WrbyUcVW7RsXkPGTdEsbOwDRLUnMn95hBh4MFYyIlr2KGG=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/104661833816141097775/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104661833816141097775/reviews');
SET @user_marija_kovacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104661833816141097775/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sretenka Simovic Govedarica', 'https://lh3.googleusercontent.com/a/ACg8ocJFkVQEAts_I653rCcIpx2Yhp6PUd4BP7xfVlonxvQipZXTlg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105197634882253003216/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105197634882253003216/reviews');
SET @user_sretenka_simovic_govedarica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105197634882253003216/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Дмитрий Чернов', 'https://lh3.googleusercontent.com/a/ACg8ocJrIRllWxfYDEgsEWIMONEjBmHeCPd5Z1eDfrSLtO_GqIv2BQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101125610541765084056/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101125610541765084056/reviews');
SET @user_dmitriy_chernov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101125610541765084056/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Pupovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUh-wUNiBxq2dSNefJoIFnY97j9FxV85kP9kv3f8lXc6SH2xqrx=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115356936309733791944/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115356936309733791944/reviews');
SET @user_ivan_pupovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115356936309733791944/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sladjana Boskovic', 'https://lh3.googleusercontent.com/a-/ALV-UjU2YNsnheE1b8zy2PO3jEWsoZVFiuRLw9gzzjJX_lvwoxfzmAsf=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100318726697364723512/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100318726697364723512/reviews');
SET @user_sladjana_boskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100318726697364723512/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mladen Popović', 'https://lh3.googleusercontent.com/a/ACg8ocLXsrfxuuYwA1vB3isXxJJ8eduLMQCtUkjsiX8mN2vnri0S7A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105217498860329367515/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105217498860329367515/reviews');
SET @user_mladen_popovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105217498860329367515/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andjela Mijatović', 'https://lh3.googleusercontent.com/a/ACg8ocKi4f9kpHtA6Oq7Z3dF-l6UT8z6xAknPp2XVMeXLDxkLIOqGrg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101272886375241082900/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101272886375241082900/reviews');
SET @user_andjela_mijatovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101272886375241082900/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Doing Stuff', 'https://lh3.googleusercontent.com/a-/ALV-UjWL6aV702KOa9j4B6G8d5iwKjBwX09yUn_78mpzxHhZdygIUkY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105988830172336924314/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105988830172336924314/reviews');
SET @user_doing_stuff = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105988830172336924314/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lana Petkovic', 'https://lh3.googleusercontent.com/a/ACg8ocJjCXtEtJEZllBQshpxGf_FhGjwBqrYpXj9JR-AYThwRqK_TQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117194633597539638832/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117194633597539638832/reviews');
SET @user_lana_petkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117194633597539638832/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'vukica mihailovic', 'https://lh3.googleusercontent.com/a/ACg8ocJbmX5GJ51nCIOGzMHNJAmrLbP3JSa4DQ7zW_7Bdsbp5ClOOA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106338158795167962245/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106338158795167962245/reviews');
SET @user_vukica_mihailovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106338158795167962245/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sladja Rakcevic', 'https://lh3.googleusercontent.com/a-/ALV-UjUTPtCnI6DlQZOMEtHANuOIO8mIc_hB8B6t3GbpyWdNoPPURs3_=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102719853788277839790/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102719853788277839790/reviews');
SET @user_sladja_rakcevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102719853788277839790/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Novakovic', 'https://lh3.googleusercontent.com/a/ACg8ocIy8pZg_uZKVg-717RQtnxz8B-m-dAnWZdhDwQtuTFQCijdtQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115622335460365945438/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115622335460365945438/reviews');
SET @user_marko_novakovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115622335460365945438/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra Vilotijevic', 'https://lh3.googleusercontent.com/a/ACg8ocKap3NgpCIOUu2qNiNMA9DmKb8FcOegIdDLC3mkbB0YNMAQlQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100278013169077554843/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100278013169077554843/reviews');
SET @user_aleksandra_vilotijevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100278013169077554843/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_martin_frost, @clinic_id, @doctor_milan_martinovic, 'google_maps',
    'places/ChIJq0zUMS7rTRMRx6_IYy9YQZo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tOMlRIZDBkRE42UWtGVVFWSlFTazB0ZDNSNldYYxAB',
    5, 'en', 'Absolutely loved my visit at V Dental. The whole team is super kind and genuinely personable, and Dr Martinovic is honestly the best dentist anyone has ever recommended to me. Everything feels professional but warm, and they actually take time to explain things and make you feel comfortable. Could not recommend them more.

The new location was a little harder to find, though the space inside is clearly a visual and spatial upgrade.',
    'Apsolutno sam uživao u poseti V Dental-u. Čitav tim je super ljubazan i iskreno prijatan, a dr Martinović je iskreno najbolji zubar koga mi je iko ikada preporučio. Sve deluje profesionalno, ali toplo, i zaista odvajaju vreme da objasne stvari i učine da se osećate prijatno. Ne mogu ih više preporučiti.

Nova lokacija je bila malo teža za pronaći, iako je prostor unutra očigledno vizuelno i prostorno unapređen.', 'Апсолутно сам уживао у посети V Dental-у. Читав тим је супер љубазан и искрено пријатан, а др Мартиновић је искрено најбољи зубар кога ми је ико икада препоручио. Све делује професионално, али топло, и заиста одвајају време да објасне ствари и учине да се осећате пријатно. Не могу их више препоручити.

Нова локација је била мало тежа за пронаћи, иако је простор унутра очигледно визуелно и просторно унапређен.', 'Absolutely loved my visit at V Dental. The whole team is super kind and genuinely personable, and Dr Martinovic is honestly the best dentist anyone has ever recommended to me. Everything feels professional but warm, and they actually take time to explain things and make you feel comfortable. Could not recommend them more.

The new location was a little harder to find, though the space inside is clearly a visual and spatial upgrade.', NULL, NULL, NULL,
    0, '2025-12-11 09:06:56'),

(@user_ivana_batricevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJq0zUMS7rTRMRx6_IYy9YQZo/reviews/ChdDSUhNMG9nS0VJQ0FnSUQtel9INnhnRRAB',
    5, 'hr', 'Najbolji doktor ;a to mogu da kažem kao pacijent koji je imao jedan od najtežih hirurških  zahvata. U  nijednom trenutku nisam osjećala strah znajući koliko je ozbiljna situacija . Beskrajno hvala doktoru Saši i njegovom timu 🤝 Topla preporuka svima. 😊',
    'Najbolji doktor; i to mogu reći kao pacijent koji je imao jednu od najtežih hirurških procedura. Nijednog trenutka se nisam uplašio znajući koliko je situacija ozbiljna. Beskrajno hvala doktoru Saši i njegovom timu 🤝 Toplo preporučujem svima. 😊', 'Најбољи доктор; и то могу рећи као пацијент који је имао једну од најтежих хируршких процедура. Ниједног тренутка се нисам уплашио знајући колико је ситуација озбиљна. Бескрајно хвала доктору Саши и његовом тиму 🤝 Топло препоручујем свима. 😊', NULL, NULL, NULL, NULL,
    0, '2022-12-12 17:49:34'),

(@user_miljana_femic, @clinic_id, NULL, 'google_maps',
    'places/ChIJq0zUMS7rTRMRx6_IYy9YQZo/reviews/ChdDSUhNMG9nS0VJQ0FnSUQwNExTTGhBRRAB',
    1, 'bs', 'Zakazala sam termin 5 dana unaprijed. U cekaonici sam ( na zakazanom terminu) cekala 35 minuta. Uredno sam se javila na recepciji da imam mucnine i bol u glavi zbog trudnoce i da mi je zao sto sam cekala bezuspjesno. Nisam dobila ni rijec ,,izvini", vec da je pacijent dosao prije mene. Zaista sam razocarana.',
    'Zakazala sam termin 5 dana unapred. Čekala sam u čekaonici (u zakazano vreme) 35 minuta. Uredno sam prijavila na recepciji da imam mučninu i glavobolju zbog trudnoće i da mi je žao što sam bezuspešno čekala. Nisam dobila ni reč „izvini“, već da je pacijentkinja došla pre mene. Zaista sam razočarana.', 'Заказала сам термин 5 дана унапред. Чекала сам у чекаоници (у заказано време) 35 минута. Уредно сам пријавила на рецепцији да имам мучнину и главобољу због трудноће и да ми је жао што сам безуспешно чекала. Нисам добила ни реч „извини“, већ да је пацијенткиња дошла пре мене. Заиста сам разочарана.', NULL, NULL, NULL, NULL,
    2, '2019-10-18 09:30:36'),

(@user_danijela_djurisic, @clinic_id, @doctor_zoran_vlahovic, 'google_maps',
    'places/ChIJq0zUMS7rTRMRx6_IYy9YQZo/reviews/ChdDSUhNMG9nS0VJQ0FnTURRaV9HQW9nRRAB',
    5, 'bs', 'Dr. Zoran Vlahović je definitivno najbolji oralni hirurg u Crnoj Gori.',
    'Dr Zoran Vlahović je definitivno najbolji oralni hirurg u Crnoj Gori.', 'Др Зоран Влаховић је дефинитивно најбољи орални хирург у Црној Гори.', NULL, NULL, NULL, NULL,
    1, '2025-03-14 06:29:00'),

(@user_marija_kovacevic, @clinic_id, @doctor_aleksandar_vukotic, 'google_maps',
    'places/ChIJq0zUMS7rTRMRx6_IYy9YQZo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21ZMFluRlFOVWhyUlhsMFEyZG5Nek0yVVZCQ1JtYxAB',
    5, 'hr', 'SAŠA VUKOTIC NAJBOLJI DOKTOR.',
    'SAŠA VUKOTIĆ NAJBOLjI LEKAR.', 'САША ВУКОТИЋ НАЈБОЉИ ЛЕКАР.', NULL, NULL, NULL, NULL,
    0, '2026-01-06 14:12:49'),

(@user_sretenka_simovic_govedarica, @clinic_id, NULL, 'google_maps',
    'places/ChIJq0zUMS7rTRMRx6_IYy9YQZo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xWclJsb3dYM1pFTlU1UVpGZHVWbUkyU3pJMllrRRAB',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-15 00:00:00'),

(@user_dmitriy_chernov, @clinic_id, NULL, 'google_maps',
    'places/ChIJq0zUMS7rTRMRx6_IYy9YQZo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25nelN6STVkV2MzWjNsWFYwNU1Rak5VV0ZRMWJsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_ivan_pupovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJq0zUMS7rTRMRx6_IYy9YQZo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5TlVtTjFkRnAyU2xnNFprWmtiMVp0VjBWRFRVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_sladjana_boskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJq0zUMS7rTRMRx6_IYy9YQZo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xBMVozZGZibTB6WVROVE1HOTZZVUZtTVVad2VrRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_mladen_popovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJq0zUMS7rTRMRx6_IYy9YQZo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25kcWMwaFZOVW90UTFGYVJVdDJjVzk2ZVdoWlRrRRAB',
    2, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_andjela_mijatovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJq0zUMS7rTRMRx6_IYy9YQZo/reviews/ChdDSUhNMG9nS0VJQ0FnSURkaUtleGdnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_doing_stuff, @clinic_id, NULL, 'google_maps',
    'places/ChIJq0zUMS7rTRMRx6_IYy9YQZo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNod29xRmlRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_lana_petkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJq0zUMS7rTRMRx6_IYy9YQZo/reviews/ChdDSUhNMG9nS0VJQ0FnSURhb0xENzJ3RRAB',
    2, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_vukica_mihailovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJq0zUMS7rTRMRx6_IYy9YQZo/reviews/ChdDSUhNMG9nS0VJQ0FnSUMwdklDUDRnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_sladja_rakcevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJq0zUMS7rTRMRx6_IYy9YQZo/reviews/ChZDSUhNMG9nS0VJQ0FnSURJeWFicVVREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_marko_novakovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJq0zUMS7rTRMRx6_IYy9YQZo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNBeE5fZk5nEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_aleksandra_vilotijevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJq0zUMS7rTRMRx6_IYy9YQZo/reviews/ChdDSUhNMG9nS0VJQ0FnSURnek5tR3dnRRAB',
    5, 'en', 'Excellent!',
    NULL, NULL, 'Excellent!', NULL, NULL, NULL,
    1, '2017-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
