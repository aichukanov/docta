-- Insert Google Maps reviews for Moj Lab Pedijatria (Podgorica)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/moj-lab-pedijatrija-podgorica.sql

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = 9;
SET @doctor_branka_samardzija = 191;
SET @doctor_milica_sofranac = 195;
SET @doctor_tanja_filipovic = 201;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vanja Karadzic', 'https://lh3.googleusercontent.com/a/ACg8ocKl2o8ukUYPIt_6zWSJM_ZB0nFocksMSDBBFWF1OB_C86AmsQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116968520777036589102/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116968520777036589102/reviews');
SET @user_vanja_karadzic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116968520777036589102/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ognjen Radunović', 'https://lh3.googleusercontent.com/a-/ALV-UjVVx1PHvVkcKX3xrzsJmCYp5zFTEIEcrgR9cuB7Kovhq3YbdGCc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118431731780390720934/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118431731780390720934/reviews');
SET @user_ognjen_radunovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118431731780390720934/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'milica bo', 'https://lh3.googleusercontent.com/a/ACg8ocJ_9M8B0vHDh4Ud3WlZFvOKeA9Tvah03gyVfAGDMfS86jI6iA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117683371399341973446/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117683371399341973446/reviews');
SET @user_milica_bo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117683371399341973446/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Arina Alenina', 'https://lh3.googleusercontent.com/a-/ALV-UjXzHLvBbttt75z3TuCiNlXHj6sRI30elRbjIN2VuZYP3ZGGlRo=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108124206849279488674/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108124206849279488674/reviews');
SET @user_arina_alenina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108124206849279488674/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nataliya Watson', 'https://lh3.googleusercontent.com/a-/ALV-UjWBo180fhX3RAA87VJilmvcpyjOreXVVEg9Z6JfefCA5nmMsCET=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116813812334094740829/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116813812334094740829/reviews');
SET @user_nataliya_watson = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116813812334094740829/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Albert Spenser (Peter)', 'https://lh3.googleusercontent.com/a-/ALV-UjUkCdX5ZzGyBCE02CPcxkzw7MTbsj2tZEvMAixYdhTI995GOQ16kQ=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/100760148339064887565/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100760148339064887565/reviews');
SET @user_albert_spenser_peter = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100760148339064887565/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alisa Arovic', 'https://lh3.googleusercontent.com/a-/ALV-UjV2lV1PlZbLNloDzJoSJH8oZQ6wdPBzGCs-pxP8n76YkgM3Nq5E=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101041819621987183338/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101041819621987183338/reviews');
SET @user_alisa_arovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101041819621987183338/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ema Koljenovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUv2S6uWKHCG0sPPwn6sPsA9VQZPji8m0pLsUaU65NOmbq4ftRN=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100317590355595520580/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100317590355595520580/reviews');
SET @user_ema_koljenovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100317590355595520580/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Majda Muhovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXZfw0yogCB0uxOv9-N_Gf4St_e018fQcmsWBwCv4bCeINwTYMiYw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108076185342366632783/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108076185342366632783/reviews');
SET @user_majda_muhovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108076185342366632783/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Эля К', 'https://lh3.googleusercontent.com/a/ACg8ocJ_yYgE04GVaJQDCr3T9AJjeGGZ7AgufZ6VwiL73pcKNtCxtg=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/109417291251068265250/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109417291251068265250/reviews');
SET @user_elya_k = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109417291251068265250/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Baja Rakcevic', 'https://lh3.googleusercontent.com/a/ACg8ocLOTPjHK8HzpNasPA0bduX93CasRjn_pJPQ6omaXxJLS_j_Aw=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/109418618784636865517/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109418618784636865517/reviews');
SET @user_baja_rakcevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109418618784636865517/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Larisa Šipčić', 'https://lh3.googleusercontent.com/a-/ALV-UjUoXg1AolBEhWX5LEt8LIOm5lB2N6LUCKSSHWIjx8FTeJanwt71Lw=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/108743537100747824120/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108743537100747824120/reviews');
SET @user_larisa_ipi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108743537100747824120/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'I N', 'https://lh3.googleusercontent.com/a/ACg8ocL5k1Ii3b7wiqwlQVJ6IaSHl8n3yoa7RDL_Scffxt3C_dfz5bg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106865542709838357426/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106865542709838357426/reviews');
SET @user_i_n = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106865542709838357426/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lala Gasimli', 'https://lh3.googleusercontent.com/a-/ALV-UjWRqzpJm9f7kv45gXmnPkv_at94XRrR-dF70XidUFNW4a5owFoC=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103589704301764742157/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103589704301764742157/reviews');
SET @user_lala_gasimli = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103589704301764742157/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Полина Казаченко', 'https://lh3.googleusercontent.com/a-/ALV-UjVTJOkrb3OHqcPO_f8wfuSEAaDuOCSK08BtA_Oc6fFOTYpsCN_q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109197147941629167623/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109197147941629167623/reviews');
SET @user_polina_kazachenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109197147941629167623/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danica Hardt', 'https://lh3.googleusercontent.com/a/ACg8ocLSgVBUSURSqOdop9YGMMBTM0NOV9RBIw0Ool1zR3niuFd2nw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110785233274107216906/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110785233274107216906/reviews');
SET @user_danica_hardt = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110785233274107216906/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vasilije Savkovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVlRFFk7nSw8QhQ-tx-vrW0o6wEkUL2DFqPFI_Yz_NKrJOhCGNd=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105640545245030395146/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105640545245030395146/reviews');
SET @user_vasilije_savkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105640545245030395146/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Darko Spalevic', 'https://lh3.googleusercontent.com/a/ACg8ocJy8Q0zlBYijYQMh276Bw4FxuZApGmzfE7OIxDD6d1EUff9xA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117500699392091617156/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117500699392091617156/reviews');
SET @user_darko_spalevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117500699392091617156/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'NESRİN AKSU BEKTAŞ', 'https://lh3.googleusercontent.com/a-/ALV-UjXF71TTIbH1BceEdL_Xoy5ReBSLbfHZzma68A0tLaaopwdfzVCvqg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109849955491431588843/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109849955491431588843/reviews');
SET @user_nesrn_aksu_bekta = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109849955491431588843/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zeljana Gobovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWzaz2icITdswHe5A80QvyP3VxoQUV250Ah865Rdy0y_vR3zv0=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103894249138524303149/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103894249138524303149/reviews');
SET @user_zeljana_gobovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103894249138524303149/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Medoni Medoni', 'https://lh3.googleusercontent.com/a-/ALV-UjVwi2QnABeKOXYmMIA2E2zJ3RyUfDLjuoX3hJq5l-pl1z1pc1IO=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112832721773687047458/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112832721773687047458/reviews');
SET @user_medoni_medoni = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112832721773687047458/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Flawless Podgorica', 'https://lh3.googleusercontent.com/a/ACg8ocIw3cZw3MDi2o6MHJlxcEQ_dZX-brZUBcZ4PCFAyAnYi2BDwA=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/102358108397391668572/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102358108397391668572/reviews');
SET @user_flawless_podgorica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102358108397391668572/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena', 'https://lh3.googleusercontent.com/a/ACg8ocJh8rsXr3cooovBnz43CZvX7aRX27WQxNi521zWRU9f8ph1Cw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114115026523600516674/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114115026523600516674/reviews');
SET @user_jelena = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114115026523600516674/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mina Radulovic', 'https://lh3.googleusercontent.com/a-/ALV-UjViudiepVlVN66rncvFq1eK14eS6kfOhvs8bX2tFovCEQKE5GjJZQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100274811949575807486/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100274811949575807486/reviews');
SET @user_mina_radulovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100274811949575807486/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Evgeniia Muraveva', 'https://lh3.googleusercontent.com/a-/ALV-UjXjwgZK_uxgeNHrAHT8BttIWaQv1gu-3aAymRAbscnF_nTFMx_O3A=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/105936294938868761726/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105936294938868761726/reviews');
SET @user_evgeniia_muraveva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105936294938868761726/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_vanja_karadzic, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25SMVJGbDBMVnBmYzB0Tk0yMTBZV015Y0RaaFJGRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, NULL),

(@user_ognjen_radunovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WV2RHZzFjamhQV0ZadllWUnBSWGhpYUZKcVMxRRAB',
    5, 'hr', 'Nista osim samih pohvala! Svi zaposleni su maksimalno profesionalni i uvijek izlaze u susret. Posebno cijenim njihov pristup djeci i strpljenje ❤️',
    'Nista osim samih pohvala! Svi zaposleni su maksimalno profesionalni i uvijek izlaze u susret. Posebno cijenim njihov pristup djeci i strpljenje ❤️', 'Ништа осим самих похвала! Сви запослени су максимално професионални и увек излазе у сусрет. Посебно цијеним њихов приступ дјеци и стрпљење ❤️', 'Nothing but praise! All staff are extremely professional and always accommodating. I especially appreciate their approach to children and their patience ❤️', 'Только похвалы! Все сотрудники максимально профессиональны и всегда идут навстречу. Особенно ценю их подход к детям и терпение ❤️', 'Nichts als Lob! Alle Mitarbeiter sind äußerst professionell und immer entgegenkommend. Ich schätze besonders ihren Umgang mit Kindern und ihre Geduld ❤️', 'Sadece övgü! Tüm çalışanlar son derece profesyonel ve her zaman yardımsever. Özellikle çocuklara yaklaşımlarını ve sabırlarını takdir ediyorum ❤️',
    0, '2026-03-10 00:00:00'),

(@user_milica_bo, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCcWVGaG5VemcyWlRFdFExTkxTVGhtVTBrdFpXYxAB',
    5, 'hr', 'Danas sam došla sa strahom i velikom tremom u ambulantu. Zelim da pohvalim i da se zahvalim laborantu Mirjani, na izuzetnoj profesionalnosti, s obzirom da je uočila moj strah pristupila mi je vrlo umirujuće i profesionalno. Smirila me, ulila povjerenje i sve strpljivo objasnila prije nego što je započela proceduru testa zbog kojeg sam došla. Vađenje krvi i cijeli test prošli su mnogo lakše nego što sam očekivala. Zaista se osjeti kada neko svoj posao radi savjesno i sa ljudskošću. Hvala na toplini, uvijek ste moj izbor!',
    'Danas sam došla sa strahom i velikom tremom u ambulantu. Zelim da pohvalim i da se zahvalim laborantu Mirjani, na izuzetnoj profesionalnosti, s obzirom da je uočila moj strah pristupila mi je vrlo umirujuće i profesionalno. Smirila me, ulila povjerenje i sve strpljivo objasnila prije nego što je započela proceduru testa zbog kojeg sam došla. Vađenje krvi i cijeli test prošli su mnogo lakše nego što sam očekivala. Zaista se osjeti kada neko svoj posao radi savjesno i sa ljudskošću. Hvala na toplini, uvijek ste moj izbor!', 'Данас сам дошла са страхом и великом тремом у амбуланту. Желим да похвалим и захвалим се лаборанту Мирјани на изузетној професионалности, с обзиром да је уочила мој страх, приступила ми је врло умирујуће и професионално. Смирила ме, улила повјерење и све стрпљиво објаснила прије него што је започела процедуру теста због ког сам дошла. Вађење крви и цијели тест прошли су много лакше него што сам очекивала. Заиста се осјети кад неко свој посао ради савјесно и са људскошћу. Хвала на топлини, увијек сте мој избор!', 'I came to the clinic today with fear and great anxiety. I want to praise and thank lab technician Mirjana for her exceptional professionalism — she noticed my fear and approached me in a very calming and professional manner. She reassured me, gave me confidence, and patiently explained everything before starting the test procedure. The blood draw and the entire test went much easier than I expected. You can really tell when someone does their job conscientiously and with humanity. Thank you for the warmth, you are always my choice!', 'Сегодня я пришла в амбулаторию со страхом и большим волнением. Хочу похвалить и поблагодарить лаборанта Мирьяну за исключительный профессионализм — она заметила мой страх и подошла ко мне очень успокаивающе и профессионально. Успокоила меня, вселила уверенность и терпеливо всё объяснила перед началом процедуры. Забор крови и весь тест прошли намного легче, чем я ожидала. Действительно чувствуется, когда человек делает своё дело добросовестно и с человечностью. Спасибо за тепло, вы всегда мой выбор!', 'Ich kam heute voller Angst und großer Aufregung in die Ambulanz. Ich möchte die Laborantin Mirjana für ihre außergewöhnliche Professionalität loben und ihr danken — sie bemerkte meine Angst und ging sehr beruhigend und professionell auf mich ein. Sie beruhigte mich, gab mir Vertrauen und erklärte alles geduldig, bevor sie mit dem Test begann. Die Blutentnahme und der gesamte Test verliefen viel einfacher als erwartet. Man merkt wirklich, wenn jemand seinen Job gewissenhaft und mit Menschlichkeit ausführt. Danke für die Wärme, Sie sind immer meine Wahl!', 'Bugün muayehaneye korku ve büyük bir heyecanla geldim. Laboratuvar teknisyeni Mirjana\'yı olağanüstü profesyonelliği için övmek ve teşekkür etmek istiyorum — korkumu fark etti ve bana çok sakinleştirici ve profesyonel bir şekilde yaklaştı. Beni sakinleştirdi, güven verdi ve teste başlamadan önce her şeyi sabırla açıkladı. Kan alma ve tüm test beklediğimden çok daha kolay geçti. Birinin işini vicdanlı ve insanlıkla yaptığı gerçekten hissediliyor. Sıcaklık için teşekkürler, her zaman benim tercihimsiniz!',
    0, '2026-02-24 00:00:00'),

(@user_arina_alenina, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21sTUxVWm1NRkpGWTBSMWRYbFBSbVJ0YTFOWVQyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-02-24 00:00:00'),

(@user_nataliya_watson, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/Ci9DQUlRQUNvZENodHljRjlvT20xcWJHOXZOazFDWkdwdFp6WkhTMDFOTjFGM1VsRRAB',
    5, 'en', 'I would like to express my gratitude to the staff  at Moj lab in Podgorica. The beautiful nurse who took my blood test was very professional considering that my veins are almost impossible to find. The young lady at the reception was very friendly, polite and organized. Thank you all very much!',
    'Želeo bih da izrazim zahvalnost osoblju u Moj lab-u u Podgorici. Divna sestra koja mi je uzela krv bila je veoma profesionalna s obzirom da su moje vene gotovo nemoguće pronaći. Mlada gospođica na recepciji bila je veoma prijatna, ljubazna i organizovana. Hvala vam svima puno!', 'Желио бих да изразим захвалност особљу у Мој лаб-у у Подгорици. Дивна сестра која ми је узела крв била је веома професионална с обзиром да су моје вене готово немогуће пронаћи. Млада господица на рецепцији била је веома пријатна, љубазна и организована. Хвала вам свима пуно!', 'I would like to express my gratitude to the staff  at Moj lab in Podgorica. The beautiful nurse who took my blood test was very professional considering that my veins are almost impossible to find. The young lady at the reception was very friendly, polite and organized. Thank you all very much!', 'Хочу выразить благодарность персоналу Moj lab в Подгорице. Замечательная медсестра, которая брала у меня кровь, была очень профессиональна, учитывая, что мои вены практически невозможно найти. Молодая девушка на ресепции была очень дружелюбной, вежливой и организованной. Большое спасибо всем!', 'Ich möchte dem Personal von Moj lab in Podgorica meinen Dank aussprechen. Die freundliche Krankenschwester, die mir Blut abnahm, war sehr professionell, da meine Venen fast nicht zu finden sind. Die junge Dame an der Rezeption war sehr freundlich, höflich und organisiert. Vielen Dank an alle!', 'Podgorica\'daki Moj lab personeline minnettarlığımı ifade etmek istiyorum. Kan testi yapan güzel hemşire, damarlarımı bulmak neredeyse imkânsız olmasına rağmen çok profesyoneldi. Resepsiyondaki genç bayan çok arkadaş canlısı, kibar ve organizeydi. Hepinize çok teşekkürler!',
    0, '2026-01-24 00:00:00'),

(@user_albert_spenser_peter, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21oTk1YRllka2hCVDJSblIzVjZRVXh2WDNSQmRIYxAB',
    5, 'bs', 'Dr Pekovic Gastroentrolog,Profesionalan Pristup,doza Empatije i Humanosti sa preciznim upustvima kako pomoci Bebi od 5 mjeseci koja ima alergije na "krvlji protein" iz formule za odojcad.
Takojde bih Pohvali kompetan tim Sestara koj su ljubazne i pazljive.
Sve preporuke za Roditelje!',
    'Dr Pekovic Gastroentrolog,Profesionalan Pristup,doza Empatije i Humanosti sa preciznim upustvima kako pomoci Bebi od 5 mjeseci koja ima alergije na "krvlji protein" iz formule za odojcad.
Takojde bih Pohvali kompetan tim Sestara koj su ljubazne i pazljive.
Sve preporuke za Roditelje!', 'Др Пековић гастроентеролог, професионалан приступ, доза емпатије и хуманости са прецизним упутствима како помоћи беби од 5 мјесеци која има алергије на „крвни протеин“ из формуле за одојчад.
Такође бих похвалио компетентан тим сестара које су љубазне и пажљиве.
Све препоруке за родитеље!', 'Dr Pekovic, gastroenterologist — professional approach, a dose of empathy and humanity with precise instructions on how to help a 5-month-old baby with allergies to "milk protein" from infant formula.
I would also like to praise the competent team of nurses who are kind and attentive.
Highly recommended for parents!', 'Доктор Пекович, гастроэнтеролог — профессиональный подход, доза эмпатии и человечности с точными инструкциями о том, как помочь 5-месячному малышу с аллергией на "молочный белок" из детской смеси.
Также хочу похвалить компетентную команду медсестёр, которые добры и внимательны.
Всячески рекомендую для родителей!', 'Dr. Pekovic, Gastroenterologe — professionelle Vorgehensweise, eine Portion Empathie und Menschlichkeit mit präzisen Anweisungen, wie man einem 5 Monate alten Baby mit einer Allergie gegen „Milchprotein“ aus der Säuglingsnahrung helfen kann.
Ich möchte auch das kompetente Pflegeteam loben, das freundlich und aufmerksam ist.
Alle Empfehlungen für Eltern!', 'Dr Pekovic, gastroenterolog — profesyonel yaklaşım, mama formulasındaki "süt proteini"ne alerjisi olan 5 aylık bir bebeğe nasıl yardım edileceğine dair kesin talimatlarla birlikte empati ve insanlık dozu.
Ayrıca nazik ve özenli hemşire ekibini de övmek isterim.
Ebeveynlere tüm tavsiyeler!',
    0, '2025-12-24 00:00:00'),

(@user_alisa_arovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwNlVsUkpVbUpOYmxaNU4wSjRYMlF6Y3pWc2NuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-24 00:00:00'),

(@user_ema_koljenovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tvMmRtZFJRa3R1UjA1dGFVeFRUa042V0ROR1psRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-24 00:00:00'),

(@user_majda_muhovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xsRk1rTlVPSE5RVTBOWVNFRlBkMHhmVVhaVFRVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-24 00:00:00'),

(@user_elya_k, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xKeFYwWjVUbXBqZG1Sbk5qWnFiMU5RTTFKTFRWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-24 00:00:00'),

(@user_baja_rakcevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5ZmMyUmtNMDVMU1hwVVJubG1TbkF0UlhWcldGRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-24 00:00:00'),

(@user_larisa_ipi, @clinic_id, @doctor_branka_samardzija, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25CaldsOUlTMVpmUjFneFIwSTVRMHB6ZEdWeFQzYxAB',
    5, 'bs', 'Dr Branka Samardžija-Jovanović, odličan i temeljan pedijatar, sve nam je objasnila do najsitnijih detalja, pregledala našu bebu sa maksimalnom posvećenošću.',
    'Dr Branka Samardžija-Jovanović, odličan i temeljan pedijatar, sve nam je objasnila do najsitnijih detalja, pregledala našu bebu sa maksimalnom posvećenošću.', 'Др Бранка Самарџија-Јовановић, одличан и темељан педијатар, све нам је објаснила до најситнијих детаља, прегледала нашу бебу са максималном посвећеношћу.', 'Dr Branka Samardžija-Jovanović, an excellent and thorough pediatrician, explained everything to us in the finest detail and examined our baby with maximum dedication.', 'Доктор Бранка Самарджия-Йованович — отличный и основательный педиатр, объяснила нам всё до мельчайших деталей и осмотрела нашего малыша с максимальной самоотдачей.', 'Dr. Branka Samardžija-Jovanović, eine ausgezeichnete und gründliche Kinderärztin, hat uns alles bis ins kleinste Detail erklärt und unser Baby mit höchster Hingabe untersucht.', 'Dr Branka Samardžija-Jovanović, mükemmel ve titiz bir pediatrist — her şeyi en ince ayrıntısına kadar anlattı ve bebeğimizi en yüksek özveriyle muayene etti.',
    0, '2025-08-24 00:00:00'),

(@user_i_n, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/ChdDSUhNMG9nS0VJNmI0NkxEdGRyRWpRRRAB',
    1, 'hr', 'Bili smo zadovoljni uslugom
Ali vise nismo
Nalaz običnog urina čekamo cijeli dan. Sumnjam u vjerodostojnost istog! Loše ! Pogotovo kada pričamo o malim bebama!',
    'Bili smo zadovoljni uslugom
Ali vise nismo
Nalaz običnog urina čekamo cijeli dan. Sumnjam u vjerodostojnost istog! Loše ! Pogotovo kada pričamo o malim bebama!', 'Били смо задовољни услугом
Али више нисмо
Налаз обичног урина чекамо цио дан. Сумњам у вјеродостојност истог! Лоше! Поготово кад причамо о малим бебама!', 'We were satisfied with the service
But no longer
We\'ve been waiting all day for a simple urine test result. I doubt its reliability! Poor! Especially when we\'re talking about small babies!', 'Мы были довольны услугами
Но больше нет
Обычный анализ мочи ждём весь день. Сомневаюсь в его достоверности! Плохо! Особенно когда речь идёт о маленьких детях!', 'Wir waren mit dem Service zufrieden
Aber nicht mehr
Wir warten den ganzen Tag auf den Befund eines einfachen Urintests. Ich zweifle an der Zuverlässigkeit! Schlecht! Besonders wenn wir über kleine Babys sprechen!', 'Hizmetinden memnunduk
Ama artık değiliz
Basit bir idrar testi sonucunu bütün gün bekliyoruz. Güvenilirliğinden şüphe ediyorum! Kötü! Özellikle küçük bebeklerden bahsediyorsak!',
    0, '2025-06-24 00:00:00'),

(@user_lala_gasimli, @clinic_id, @doctor_milica_sofranac, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/ChdDSUhNMG9nS0VJQ0FnTURRbTlQUm5RRRAB',
    1, 'en', 'I deeply regret having wasted so much time at your clinic. Dr. Milica’s incorrect treatment of influenza led to unnecessary medication.

I have now learned that the strong medications  that I gave my child due to the wrong diagnosis not only harmed my daughter’s health but also caused financial loss.',
    'Duboko žalim što sam proveo toliko vremena u vašoj klinici. Pogrešno lečenje gripa od strane Dr. Milice dovelo je do nepotrebnih lekova.

Sada sam saznao da su jaki lekovi koje sam dao svom detetu zbog pogrešne dijagnoze ne samo naštetili zdravlju moje ćerke, već su uzrokovali i finansijske gubitke.', 'Дубоко жалим што сам провео толико времена у вашој клиници. Погрешно лијечење грипа од стране Др. Милице довело је до непотребних лијекова.

Сада сам сазнао да су јаки лијекови које сам дао свом дјетету због погрешне дијагнозе не само наштетили здрављу моје кћерке, већ су узроковали и финансијске губитке.', 'I deeply regret having wasted so much time at your clinic. Dr. Milica’s incorrect treatment of influenza led to unnecessary medication.

I have now learned that the strong medications  that I gave my child due to the wrong diagnosis not only harmed my daughter’s health but also caused financial loss.', 'Я глубоко сожалею, что потратил столько времени в вашей клинике. Неправильное лечение гриппа доктором Милицей привело к ненужным лекарствам.

Теперь я узнал, что сильные препараты, которые я давал ребёнку из-за неправильного диагноза, не только навредили здоровью моей дочери, но и повлекли финансовые потери.', 'Es tut mir sehr leid, so viel Zeit in Ihrer Klinik verschwendet zu haben. Die falsche Behandlung von Influenza durch Dr. Milica führte zu unnötiger Medikation.

Ich habe nun erfahren, dass die starken Medikamente, die ich meinem Kind aufgrund der falschen Diagnose gegeben habe, nicht nur die Gesundheit meiner Tochter geschädigt, sondern auch finanzielle Verluste verursacht haben.', 'Kliniğinizde bu kadar zaman harcadığım için çok üzgünüm. Dr. Milica\'nın yanlış grip tedavisi gereksiz ilaç kullanımına yol açtı.

Şimdi öğrendim ki yanlış teşhis nedeniyle çocuğuma verdiğim güçlü ilaçlar kızımın sağlığına zarar vermekle kalmadı, aynı zamanda maddi kayba da neden oldu.',
    0, '2025-03-24 00:00:00'),

(@user_polina_kazachenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/ChdDSUhNMG9nS0VJQ0FnTUNnanBTcV9RRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_danica_hardt, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/ChZDSUhNMG9nS0VJQ0FnSUM3eGVEak1BEAE',
    5, 'bs', 'Sve pohvale, jako ljubazni, odlicna doktorica, odlicne sestre I sve cisto.',
    'Sve pohvale, jako ljubazni, odlicna doktorica, odlicne sestre I sve cisto.', 'Све похвале, јако љубазни, одлична докторица, одличне сестре и све чисто.', 'All praise, very kind, excellent doctor, excellent nurses and everything clean.', 'Одни похвалы — очень добросердечные, отличный врач, отличные медсёстры, и всё чисто.', 'Alles Lob, sehr freundlich, ausgezeichnete Ärztin, ausgezeichnete Schwestern und alles sauber.', 'Sadece övgü — çok nazik, mükemmel doktor, mükemmel hemşireler ve her şey temiz.',
    0, '2025-03-24 00:00:00'),

(@user_vasilije_savkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/ChZDSUhNMG9nS0VJQ0FnSURibExxQkNnEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_darko_spalevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/ChdDSUhNMG9nS0VJQ0FnSUR6NDlQTHJ3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_nesrn_aksu_bekta, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/ChZDSUhNMG9nS0VJQ0FnSUR6cnFmWVdBEAE',
    5, 'tr', 'Kapıdan girdiğimiz andan itibaren tüm personel bizimle ilgilendi. Doktorumuz harikaydı, hemşireler ilgili, güleryüzlü ve  harikaydı. Tertemiz pırıl pırıl bir klinik. Teşekkürler 💙🙏 …',
    'Od trenutka kada smo ušli na vrata, sve osoblje se pobrinulo za nas. Naš doktor je bio sjajan, medicinske sestre pažljive, nasmejane i sjajne. Potpuno čista, blistava klinika. Hvala 💙🙏 …', 'Од тренутка када смо ушли на врата, сво особље се побринуло за нас. Наш доктор је био сјајан, медицинске сестре пажљиве, насмијане и сјајне. Потпуно чиста, блистава клиника. Хвала 💙🙏 …', 'From the moment we walked through the door, all the staff took care of us. Our doctor was wonderful, the nurses attentive, cheerful and wonderful. A spotlessly clean, sparkling clinic. Thank you 💙🙏 …', 'С момента, как мы вошли в дверь, весь персонал занимался нами. Наш врач был замечательным, медсёстры внимательными, улыбчивыми и прекрасными. Безупречно чистая, сияющая клиника. Спасибо 💙🙏 …', 'Vom Moment, als wir die Tür betraten, kümmerte sich das gesamte Personal um uns. Unser Arzt war wunderbar, die Schwestern aufmerksam, fröhlich und großartig. Eine blitzsaubere, strahlende Klinik. Danke 💙🙏 …', 'Kapıdan girdiğimiz andan itibaren tüm personel bizimle ilgilendi. Doktorumuz harikaydı, hemşireler ilgili, güleryüzlü ve  harikaydı. Tertemiz pırıl pırıl bir klinik. Teşekkürler 💙🙏 …',
    0, '2025-03-24 00:00:00'),

(@user_zeljana_gobovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/ChdDSUhNMG9nS0VJQ0FnSURUenJ1UTFnRRAB',
    5, 'bs', 'Strucnost na nivou sa najboljim doktorima,sve preporuke i pohvale.',
    'Strucnost na nivou sa najboljim doktorima,sve preporuke i pohvale.', 'Стручност на нивоу са најближим докторима, све препоруке и похвале.', 'Expertise on par with the best doctors — all recommendations and praise.', 'Профессионализм на уровне лучших врачей — одни рекомендации и похвалы.', 'Fachkompetenz auf dem Niveau der besten Ärzte — alles Empfehlungen und Lob.', 'En iyi doktorlarla aynı seviyede uzmanlık — tüm tavsiyeler ve övgüler.',
    0, '2025-03-24 00:00:00'),

(@user_medoni_medoni, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/ChZDSUhNMG9nS0VJQ0FnSURObUlXdVRnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00'),

(@user_flawless_podgorica, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/ChdDSUhNMG9nS0VJQ0FnSUNCN3ZmYmtRRRAB',
    5, 'hr', 'Super iskustvo, odgovoran pristup',
    'Super iskustvo, odgovoran pristup', 'Супер искуство, одговоран приступ', 'Great experience, responsible approach', 'Отличный опыт, ответственный подход', 'Tolles Erlebnis, verantwortungsvoller Ansatz', 'Harika deneyim, sorumlu yaklaşım',
    0, '2023-03-24 00:00:00'),

(@user_jelena, @clinic_id, @doctor_tanja_filipovic, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/ChdDSUhNMG9nS0VJQ0FnSUNCN05QRTR3RRAB',
    5, 'bs', 'Pulmolog - doktorica Filipović sve pohvale za pristup i posvećenost. Sestre u laboratoriji takođe odlične.',
    'Pulmolog - doktorica Filipović sve pohvale za pristup i posvećenost. Sestre u laboratoriji takođe odlične.', 'Пулмолог — докторица Филиповић све похвале за приступ и посвећеност. Сестре у лабораторији такође одличне.', 'Pulmonologist — Dr. Filipović, all praise for her approach and dedication. The nurses in the laboratory are also excellent.', 'Пульмонолог — доктор Филипович, одни похвалы за подход и самоотдачу. Медсёстры в лаборатории также превосходны.', 'Pulmologin — Doktorin Filipović, alles Lob für ihren Ansatz und ihre Hingabe. Die Schwestern im Labor sind ebenfalls ausgezeichnet.', 'Pulmonolog — Dr. Filipović, yaklaşımı ve özverisi için tüm övgüler. Laboratuvardaki hemşireler de mükemmel.',
    0, '2023-03-24 00:00:00'),

(@user_mina_radulovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/ChZDSUhNMG9nS0VJQ0FnSUQtbXJYcWRnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-03-24 00:00:00'),

(@user_evgeniia_muraveva, @clinic_id, NULL, 'google_maps',
    'places/ChIJAxnHJSXrTRMRvjMVcWtNhfI/reviews/ChdDSUhNMG9nS0VJQ0FnSUQtc09MajBRRRAB',
    1, 'bs', 'analiza je kontaminirana tokom prenosa između laboratorija',
    'analiza je kontaminirana tokom prenosa između laboratorija', 'Анализа је контаминирана током преноса између лабораторија', 'The sample was contaminated during transfer between laboratories', 'Анализ был загрязнён при транспортировке между лабораториями', 'Die Probe wurde beim Transfer zwischen den Labors kontaminiert', 'Numune laboratuvarlar arasındaki transfer sırasında kirletildi',
    0, '2023-03-24 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
