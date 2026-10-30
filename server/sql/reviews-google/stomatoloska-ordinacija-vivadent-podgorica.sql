-- Insert Google Maps reviews for Stomatoloska ordinacija VIVADENT
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/stomatoloska-ordinacija-vivadent-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'stomatoloska-ordinacija-vivadent-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_jovanka_lekic = (SELECT id FROM doctors WHERE slug = 'jovanka-lekic');
SET @doctor_stefan_lekic = (SELECT id FROM doctors WHERE slug = 'stefan-lekic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Talya Lilith Venera', 'https://lh3.googleusercontent.com/a-/ALV-UjVM2tAECMWny1y-8joec6lbRIGsJiFLiW8vyHfW9DVKHY-rLvOZ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/113867620426386230084/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113867620426386230084/reviews');
SET @user_talya_lilith_venera = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113867620426386230084/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vesna Hasanagic', 'https://lh3.googleusercontent.com/a/ACg8ocLb_Uj_S4xvylwbon0nO6aRqqROjkV_R_ObfjNeJxpty5NVwQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101630836983549128941/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101630836983549128941/reviews');
SET @user_vesna_hasanagic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101630836983549128941/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Grigory S', 'https://lh3.googleusercontent.com/a/ACg8ocJu6BeC6jMmcNjMAPA84RDosunotg95TqTQgxljmUesPJXxwQ=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/117833759809801298134/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117833759809801298134/reviews');
SET @user_grigory_s = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117833759809801298134/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Smalzer', 'https://lh3.googleusercontent.com/a-/ALV-UjWiBOiih-VtCBXJSWfe68RhBM2Zc4b1rwNcIZbvt-aKPDcwxqe4=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/107129635073190360219/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107129635073190360219/reviews');
SET @user_ivan_smalzer = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107129635073190360219/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja Vuksanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXm07-OJt63sLzHrw-3bN7GhXynltne-tbGFbjPceFecnZV6A7SUA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/105525462173994609401/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105525462173994609401/reviews');
SET @user_sanja_vuksanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105525462173994609401/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jasna Pejovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVDxYPbE4ro1eB7fWw5nZOBULXw5_U3rcnM0-fL8N3jR3g8mvSZ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116053065218476566051/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116053065218476566051/reviews');
SET @user_jasna_pejovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116053065218476566051/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Said Kurbanov', 'https://lh3.googleusercontent.com/a/ACg8ocKsU_xT1BiAyDVsGPajN4ZhjkXpW8pQB1MXX6XlTMKLl1wWsg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113914194380504651824/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113914194380504651824/reviews');
SET @user_said_kurbanov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113914194380504651824/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Franeta David', 'https://lh3.googleusercontent.com/a-/ALV-UjVdezn4rD_DMZtlwU5cN6HbkwZPYZs73beR5F1DIApJXIEpdVJY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114161377326994374524/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114161377326994374524/reviews');
SET @user_franeta_david = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114161377326994374524/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Filip Klikovac', 'https://lh3.googleusercontent.com/a-/ALV-UjV0CqgdKgLCQJiHN23HyAhDkylmWddWhgymQF21kYrknidoYAHKQg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113554913331720317473/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113554913331720317473/reviews');
SET @user_filip_klikovac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113554913331720317473/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Piletic', 'https://lh3.googleusercontent.com/a-/ALV-UjXw5xiEcnby1lOsd-gdR0lYysh5GZaXiy4G15x5n7UkQ-qwKftv=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111504071525407502745/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111504071525407502745/reviews');
SET @user_marko_piletic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111504071525407502745/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Bečanović', 'https://lh3.googleusercontent.com/a-/ALV-UjVywf1hSEZVtB2f0e8nO6w0WFqsou6DHEYfUpwFL-cTYWdwWXKG=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105067736852344815342/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105067736852344815342/reviews');
SET @user_nikola_beanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105067736852344815342/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Suad Ajdarpasic', 'https://lh3.googleusercontent.com/a/ACg8ocIJIEFwNG9e4xARuiuHdp66zGfLFR6BrXWKSQdLZ-Jfc33CLw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109280281933439082823/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109280281933439082823/reviews');
SET @user_suad_ajdarpasic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109280281933439082823/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Đukić', 'https://lh3.googleusercontent.com/a-/ALV-UjXLRVAXCbLjrFcEuyFPzcAwKPboAiDl8NxTbHPq5PAn_eO48rF_=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102195842627979450203/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102195842627979450203/reviews');
SET @user_jelena_uki = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102195842627979450203/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Erak', 'https://lh3.googleusercontent.com/a-/ALV-UjWFRNixNPIWTsGtu8OITSFEQj4mIZOt1PByhm0af8CsCVTmcKVj=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105209636597532971791/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105209636597532971791/reviews');
SET @user_jelena_erak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105209636597532971791/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Hasan Etegül', 'https://lh3.googleusercontent.com/a/ACg8ocKHz35mEJM17Vns8jNtAOP2tM1utTjlJbrJBPvwatzepn7ElQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117875908891881586629/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117875908891881586629/reviews');
SET @user_hasan_etegl = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117875908891881586629/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_talya_lilith_venera, @clinic_id, NULL, 'google_maps',
    'places/ChIJW6ohrkDrTRMRp0sMhQl0oFc/reviews/ChdDSUhNMG9nS0VJQ0FnTURJb2FueXNnRRAB',
    5, 'bs', 'Divan tim stomatologa koji mi je davajuci strucne savjete i smjernice oporavio upalu desni. Radila sam par plombica na zubicima - sto je proteklo bezbolno uz zanimljive razgovore sa strucnim licima ordinacije. Moje povjerenje usmjereno ka Vivadent ordinaciji je potpuno opravdano. Osmjeh mi je blistav, zubi i desni zdrave, i pri svakom dolasku naucim nesto novo. Zubarku - NE MIJENJAM ! Sve pohvale za profesionalnost i posvecenost !',
    'Predivan tim stomatologa koji mi je davanjem stručnih saveta i uputstava izlečio moju upalu desni. Uradio sam nekoliko plombi na zubima – što je bilo bezbolno uz zanimljive razgovore sa stručnjacima u ordinaciji. Moje poverenje u ordinaciju Vivadent je potpuno opravdano. Moj osmeh je blistav, zubi i desni su zdravi, a svaki put kada dođem naučim nešto novo. NEĆU MENjAM STOMATOLOŠKU CELINU! Sve pohvale za profesionalnost i posvećenost!', 'Предиван тим стоматолога који ми је давањем стручних савета и упутстава излечио моју упалу десни. Урадио сам неколико пломби на зубима – што је било безболно уз занимљиве разговоре са стручњацима у ординацији. Моје поверење у ординацију Вивадент је потпуно оправдано. Мој осмех је блистав, зуби и десни су здрави, а сваки пут када дођем научим нешто ново. НЕЋУ МЕЊАМ СТОМАТОЛОШКУ ЦЕЛИНУ! Све похвале за професионалност и посвећеност!', NULL, NULL, NULL, NULL,
    0, '2025-04-10 14:05:04'),

(@user_vesna_hasanagic, @clinic_id, @doctor_jovanka_lekic, 'google_maps',
    'places/ChIJW6ohrkDrTRMRp0sMhQl0oFc/reviews/ChdDSUhNMG9nS0VJQ0FnSUNyZzVhbXZRRRAB',
    5, 'bs', 'Nosila sam fiksni aparat dvije i po godine. Moj problem je bio izuzetno komplikovan, doktori kod kojih sam išla rekli su da se u mojim godinama ne može riješiti. Međutim, tokom prve posjete, doktorica Jovanka Lekić mi je saopštila da je moj problem rješiv. Na početku terapije objasnila je koliko ću nositi aparat, koliko će lukova promijeniti i tako je bilo! Neizmjerno sam joj zahvalna na strpljenju, ljubaznosti, profesionalnosti, a takođe i na sjajnom rezultatu na kraju terapije! Sve preporuke za doktoricu Jovanku Lekić! ❤️',
    'Nosio sam fiksne proteze dve i po godine. Moj problem je bio izuzetno komplikovan, doktori kod kojih sam išao rekli su da se to ne može rešiti u mojim godinama. Međutim, prilikom prve posete dr Jovanka Lekić mi je rekla da je moj problem rešiv. Na početku terapije mi je objasnila koliko dugo ću nositi aparatić, koliko će lukova promeniti i to je to! Neizmerno sam joj zahvalan na strpljenju, ljubaznosti, profesionalnosti, kao i na odličnom rezultatu na kraju terapije! Sve preporuke za dr Jovanku Lekić! ❤', 'Носио сам фиксне протезе две и по године. Мој проблем је био изузетно компликован, доктори код којих сам ишао рекли су да се то не може решити у мојим годинама. Међутим, приликом прве посете др Јованка Лекић ми је рекла да је мој проблем решив. На почетку терапије ми је објаснила колико дуго ћу носити апаратић, колико ће лукова променити и то је то! Неизмерно сам јој захвалан на стрпљењу, љубазности, професионалности, као и на одличном резултату на крају терапије! Све препоруке за др Јованку Лекић! ❤', NULL, NULL, NULL, NULL,
    1, '2024-07-10 16:08:55'),

(@user_grigory_s, @clinic_id, @doctor_stefan_lekic, 'google_maps',
    'places/ChIJW6ohrkDrTRMRp0sMhQl0oFc/reviews/ChdDSUhNMG9nS0VJQ0FnSURsX05QWjdRRRAB',
    5, 'ru', 'Отличная стоматология. Пришлось обратиться за удалением 8-ки. Я очень волновался. Но хирург Стефан Лекић отлично все сделал - быстро, и я почти ничего не чувствовал в процессе. А главное - спокойно живу без обезболивающего после отхождения наркоза. Хвала пуно!',
    'Odlična stomatologija. Morao sam da izvadim osmi zub. Bio sam jako nervozan. Ali hirurg Stefan Lekić je odlično odradio posao – brzo, a ja sam jedva nešto osetio tokom zahvata. I što je najvažnije, sada mogu da živim udobno bez lekova protiv bolova nakon što anestezija prestane. Neka ti je hvala!', 'Одлична стоматологија. Морао сам да извадим осми зуб. Био сам јако нервозан. Али хирург Стефан Лекић је одлично одрадио посао – брзо, а ја сам једва нешто осетио током захвата. И што је најважније, сада могу да живим удобно без лекова против болова након што анестезија престане. Нека ти је хвала!', NULL, 'Отличная стоматология. Пришлось обратиться за удалением 8-ки. Я очень волновался. Но хирург Стефан Лекић отлично все сделал - быстро, и я почти ничего не чувствовал в процессе. А главное - спокойно живу без обезболивающего после отхождения наркоза. Хвала пуно!', NULL, NULL,
    1, '2023-11-30 22:35:24'),

(@user_ivan_smalzer, @clinic_id, NULL, 'google_maps',
    'places/ChIJW6ohrkDrTRMRp0sMhQl0oFc/reviews/ChZDSUhNMG9nS0VJQ0FnSUN4MGNQQURBEAE',
    5, 'en', 'Best dentist clinic in Podgorica. Highly professional and really friendly',
    NULL, NULL, 'Best dentist clinic in Podgorica. Highly professional and really friendly', NULL, NULL, NULL,
    2, '2023-05-19 20:35:39'),

(@user_sanja_vuksanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJW6ohrkDrTRMRp0sMhQl0oFc/reviews/ChdDSUhNMG9nS0VJQ0FnTURJMG8zZ19BRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-04-08 14:29:16'),

(@user_jasna_pejovic, @clinic_id, @doctor_stefan_lekic, 'google_maps',
    'places/ChIJW6ohrkDrTRMRp0sMhQl0oFc/reviews/Ci9DQUlRQUNvZENodHljRjlvT20xVmVEZHphbW93WjFvM2FEQkJXR3RTTkdGQ2JIYxAB',
    5, 'en', 'Amazing professional, Dr Stefan Lekić.
He was very kind and patient with my son.
He gave us very specific advice and further guidance on solving a problem with',
    NULL, NULL, 'Amazing professional, Dr Stefan Lekić.
He was very kind and patient with my son.
He gave us very specific advice and further guidance on solving a problem with', NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_said_kurbanov, @clinic_id, NULL, 'google_maps',
    'places/ChIJW6ohrkDrTRMRp0sMhQl0oFc/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GdVdHeEliR2xsTFZReE0zRnhSekZOWVZORlZVRRAB',
    5, 'ru', 'В последнее время была проведена процедура удаления зуба мудрости. Рекомендацию по данному вмешательству дал специалист. Процесс прошел в целом успешно и без осложнений. Желаемым улучшением стало бы внимание к санитарным условиям. Опыт восстановления после данной манипуляции был положительным.',
    NULL, NULL, NULL, 'В последнее время была проведена процедура удаления зуба мудрости. Рекомендацию по данному вмешательству дал специалист. Процесс прошел в целом успешно и без осложнений. Желаемым улучшением стало бы внимание к санитарным условиям. Опыт восстановления после данной манипуляции был положительным.', NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_franeta_david, @clinic_id, NULL, 'google_maps',
    'places/ChIJW6ohrkDrTRMRp0sMhQl0oFc/reviews/ChZDSUhNMG9nS0VJQ0FnSURidG9fSEVnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_filip_klikovac, @clinic_id, NULL, 'google_maps',
    'places/ChIJW6ohrkDrTRMRp0sMhQl0oFc/reviews/ChdDSUhNMG9nS0VJQ0FnSURaMFlmdnNBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_marko_piletic, @clinic_id, NULL, 'google_maps',
    'places/ChIJW6ohrkDrTRMRp0sMhQl0oFc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNCcnV2SlZBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_nikola_beanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJW6ohrkDrTRMRp0sMhQl0oFc/reviews/ChZDSUhNMG9nS0VJQ0FnSURXdUxqbkpBEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_suad_ajdarpasic, @clinic_id, NULL, 'google_maps',
    'places/ChIJW6ohrkDrTRMRp0sMhQl0oFc/reviews/ChdDSUhNMG9nS0VJQ0FnSUNzck9TMDZRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_jelena_uki, @clinic_id, NULL, 'google_maps',
    'places/ChIJW6ohrkDrTRMRp0sMhQl0oFc/reviews/ChdDSUhNMG9nS0VJQ0FnSUMwcGR5c2tRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_jelena_erak, @clinic_id, NULL, 'google_maps',
    'places/ChIJW6ohrkDrTRMRp0sMhQl0oFc/reviews/ChZDSUhNMG9nS0VJQ0FnSURJaGVQbmF3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_hasan_etegl, @clinic_id, NULL, 'google_maps',
    'places/ChIJW6ohrkDrTRMRp0sMhQl0oFc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNBNGJhU1VREAE',
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
