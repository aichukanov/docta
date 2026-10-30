-- Insert Google Maps reviews for Dr Viller AMBULANTA OPŠTE MEDICINE
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/drviller-reheart-tivat.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'drviller-reheart-tivat');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_civkina_ekaterina = (SELECT id FROM doctors WHERE slug = 'civkina-ekaterina');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'RA', 'https://lh3.googleusercontent.com/a-/ALV-UjVlYkgK421_jkTlshkzkSn01_diIAkI47TObkqoM1tpgy6v35za=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/103515283455449230314/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103515283455449230314/reviews');
SET @user_ra = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103515283455449230314/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Katrin L', 'https://lh3.googleusercontent.com/a-/ALV-UjX1Icf-vdR3DOusZZe4djEjHkUnzBqlfDPXtdnGxvWuuFYfUd3hHw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111577668954930580660/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111577668954930580660/reviews');
SET @user_katrin_l = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111577668954930580660/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Кристина Андреева', 'https://lh3.googleusercontent.com/a/ACg8ocIgNytVh6kJj-2UWnZhVvXu-WwnCELQZJane5J5PqcKl8CkgQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115864952728880284479/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115864952728880284479/reviews');
SET @user_kristina_andreeva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115864952728880284479/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Наталья Лапердина', 'https://lh3.googleusercontent.com/a-/ALV-UjVJgOlps-FcAms9HTGQLXRmhrrKvSu53kiAei0iW7yvs4jusSg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105498072417168105007/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105498072417168105007/reviews');
SET @user_natalya_laperdina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105498072417168105007/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Valeria Klitvina', 'https://lh3.googleusercontent.com/a/ACg8ocLrqr4-FzzMQD8MTwKu6V6NGxX0eapSstWuXBZR6ZrUX2uxoQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106593582412862245323/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106593582412862245323/reviews');
SET @user_valeria_klitvina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106593582412862245323/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Алексей Марфенков', 'https://lh3.googleusercontent.com/a-/ALV-UjUuID9DUL5GMyyE9CxnoyII-IK0eFQF7fGrUFxKwo1TWa-5ER8s=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101030300134763581238/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101030300134763581238/reviews');
SET @user_aleksey_marfenkov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101030300134763581238/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Дмитрий Б (DmitriyB)', 'https://lh3.googleusercontent.com/a/ACg8ocIxLDYh66s7mS6u7sgWM22QtJU_AOmjf0QXP7vj2ZEbmltyzQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117409685287651450253/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117409685287651450253/reviews');
SET @user_dmitriy_b_dmitriyb = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117409685287651450253/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anton Panton', 'https://lh3.googleusercontent.com/a/ACg8ocLN2-0eqCOtmMMmAvscJdiXZuiUczAzdIPSws2FNnxjh2j_-g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107525261842424758687/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107525261842424758687/reviews');
SET @user_anton_panton = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107525261842424758687/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Светлана Ивлева', 'https://lh3.googleusercontent.com/a/ACg8ocKfy9sJj-q9ebo5ljRBXtZZVaMBygwZjQ9i5YDv2bZ8yOJRXA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100706503608526284909/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100706503608526284909/reviews');
SET @user_svetlana_ivleva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100706503608526284909/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'oksana pimanova', 'https://lh3.googleusercontent.com/a-/ALV-UjW-6Pz-JO3F6lbl2z5QAgtP2g5skISab_oNH73hUILczr0NqNmv=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109478233194230301719/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109478233194230301719/reviews');
SET @user_oksana_pimanova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109478233194230301719/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Наталья Лелюшкина', 'https://lh3.googleusercontent.com/a/ACg8ocKFp7blo84Bcx7Gkd4hh8MNyBIiNDtHaJjs32aLREaT7dCT=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105623870458352497114/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105623870458352497114/reviews');
SET @user_natalya_lelyushkina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105623870458352497114/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natali D', 'https://lh3.googleusercontent.com/a/ACg8ocL5-xZjMMEOY8AvdLhfuQoD0F6-seqIkAa7JK5weJJAedfQdA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106775379758622839137/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106775379758622839137/reviews');
SET @user_natali_d = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106775379758622839137/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alex Stone', 'https://lh3.googleusercontent.com/a-/ALV-UjVKVJxilclXmK-tgy3ouvAa2sxT9lofQtgtqJg7CHtAcbskLwY=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100101283025013474420/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100101283025013474420/reviews');
SET @user_alex_stone = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100101283025013474420/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elena Bulgakova', 'https://lh3.googleusercontent.com/a-/ALV-UjVoeeJ8Cu525kIMMjzSPXizVQjBgP1se8sWnbgjOzNAmPtd3hMu=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100328171374359276056/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100328171374359276056/reviews');
SET @user_elena_bulgakova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100328171374359276056/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Paul Sartr', 'https://lh3.googleusercontent.com/a-/ALV-UjV47hQqbutOOtMCAVYaT9VwZfli1GRP0i8Jdi3J18_BXDO8Y0tC=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116895781668729060340/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116895781668729060340/reviews');
SET @user_paul_sartr = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116895781668729060340/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_ra, @clinic_id, @doctor_civkina_ekaterina, 'google_maps',
    'places/ChIJn1poawAxTBMR267c0sW3AvY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSUlMwODRjVGc1WkZCQ01tVjJVa1p4TWxscVUwRRAB',
    5, 'ru', 'Посещал данную ординарию по вопросам тахикардии и болезненных ощущений в области сердца, хочу выразить благодарность профессору-кардиологу Александру Григорьевичу.

Акцентирую внимание на том, что сеанс кардиолога был продолжительным: очень вдумчиво собран анамнез, просмотрены принесенные медицинские документы, проведена ЭКГ и дан ряд рекомендаций для улучшения моего состояния. Также были озвучены причины, с которыми предстоит работать в дальнейшем. Всего прием занял порядка 50 минут и с уверенностью могу сказать, что это наиболее ценный визит к кардиологу, на которых мне доводилось бывать.

Также ранее уже бывал в ординации Виллера у аллерголога Екатерины Александровны. Могу однозначно рекомендовать, если необходимо получить квалифицированную помощь аллерголога в Черногории - на своем опыте знаю, что очень сложно найти врача с данным профилем.

Еще раз выражаю благодарность!',
    'Posetila sam ovu kliniku zbog tahikardije i bolova u srcu i želim da izrazim svoju zahvalnost profesoru Aleksandru Grigorijeviču, kardiologu.

Želela bih da naglasim da je seans kardiologa bio dug: pažljivo je prikupio moju medicinsku istoriju, pregledao moju medicinsku dokumentaciju, uradio EKG i dao niz preporuka za poboljšanje mog stanja. Takođe je objasnio osnovne uzroke koje treba rešiti. Čitav pregled je trajao oko 50 minuta i mogu sa sigurnošću reći da je ovo bila najvrednija poseta kardiologu koju sam ikada imala.

Takođe sam ranije posetila alergologa Ekaterinu Aleksandrovnu u Vilerovoj klinici. Svakako je mogu preporučiti ako vam je potrebna kvalifikovana alergološka nega u Crnoj Gori — znam iz ličnog iskustva da je veoma teško pronaći lekara ove specijalnosti.

Hvala vam još jednom!', 'Посетила сам ову клинику због тахикардије и болова у срцу и желим да изразим своју захвалност професору Александру Григоријевичу, кардиологу.

Желела бих да нагласим да је сеанс кардиолога био дуг: пажљиво је прикупио моју медицинску историју, прегледао моју медицинску документацију, урадио ЕКГ и дао низ препорука за побољшање мог стања. Такође је објаснио основне узроке које треба решити. Читав преглед је трајао око 50 минута и могу са сигурношћу рећи да је ово била највреднија посета кардиологу коју сам икада имала.

Такође сам раније посетила алерголога Екатерину Александровну у Вилеровој клиници. Свакако је могу препоручити ако вам је потребна квалификована алерголошка нега у Црној Гори — знам из личног искуства да је веома тешко пронаћи лекара ове специјалности.

Хвала вам још једном!', NULL, 'Посещал данную ординарию по вопросам тахикардии и болезненных ощущений в области сердца, хочу выразить благодарность профессору-кардиологу Александру Григорьевичу.

Акцентирую внимание на том, что сеанс кардиолога был продолжительным: очень вдумчиво собран анамнез, просмотрены принесенные медицинские документы, проведена ЭКГ и дан ряд рекомендаций для улучшения моего состояния. Также были озвучены причины, с которыми предстоит работать в дальнейшем. Всего прием занял порядка 50 минут и с уверенностью могу сказать, что это наиболее ценный визит к кардиологу, на которых мне доводилось бывать.

Также ранее уже бывал в ординации Виллера у аллерголога Екатерины Александровны. Могу однозначно рекомендовать, если необходимо получить квалифицированную помощь аллерголога в Черногории - на своем опыте знаю, что очень сложно найти врача с данным профилем.

Еще раз выражаю благодарность!', NULL, NULL,
    1, '2026-02-13 15:10:12'),

(@user_katrin_l, @clinic_id, NULL, 'google_maps',
    'places/ChIJn1poawAxTBMR267c0sW3AvY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pnd2RIcDNhbUZLVEV4NE5HSmFUbko1YlZoV01GRRAB',
    5, 'ru', 'Хочу выразить искреннюю благодарность Александру Григорьевичу Виллеру за профессионализм и внимательное отношение к пациенту. Был на приёме вчера в Тивате, и остались исключительно положительные впечатления. Доктор внимательно выслушал, подробно всё объяснил, ответил на вопросы и вызвал доверие своим подходом. Очень приятно встретить специалиста, который сочетает высокий профессионализм с человеческим отношением. Однозначно рекомендую!',
    NULL, NULL, NULL, 'Хочу выразить искреннюю благодарность Александру Григорьевичу Виллеру за профессионализм и внимательное отношение к пациенту. Был на приёме вчера в Тивате, и остались исключительно положительные впечатления. Доктор внимательно выслушал, подробно всё объяснил, ответил на вопросы и вызвал доверие своим подходом. Очень приятно встретить специалиста, который сочетает высокий профессионализм с человеческим отношением. Однозначно рекомендую!', NULL, NULL,
    0, '2026-10-27 00:00:00'),

(@user_kristina_andreeva, @clinic_id, NULL, 'google_maps',
    'places/ChIJn1poawAxTBMR267c0sW3AvY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xrME1ERnpiamhQUkdsa1ZFNXBUbXRmWTJsQ1JYYxAB',
    5, 'ru', 'Александр Григорьевич очень внимательный врач.  Профессионал со стажем. Уточнил все детали касающиеся моего здоровья. Провел грамотное обследование и назначил необходимое лечение. Безумно рада найти такого специалиста.',
    NULL, NULL, NULL, 'Александр Григорьевич очень внимательный врач.  Профессионал со стажем. Уточнил все детали касающиеся моего здоровья. Провел грамотное обследование и назначил необходимое лечение. Безумно рада найти такого специалиста.', NULL, NULL,
    0, '2026-10-08 00:00:00'),

(@user_natalya_laperdina, @clinic_id, NULL, 'google_maps',
    'places/ChIJn1poawAxTBMR267c0sW3AvY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tNdFQwcGpOSFIwZVV0alZIRk9ORkZsVTNGUExWRRAB',
    5, 'ru', 'Внимательный вдумчивый врач, провел необходимые исследования, выдал заключение и рекомендации. Все очень комфортно, благодарна доктору!',
    NULL, NULL, NULL, 'Внимательный вдумчивый врач, провел необходимые исследования, выдал заключение и рекомендации. Все очень комфортно, благодарна доктору!', NULL, NULL,
    0, '2026-10-08 00:00:00'),

(@user_valeria_klitvina, @clinic_id, NULL, 'google_maps',
    'places/ChIJn1poawAxTBMR267c0sW3AvY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25obE1GVmFlbmhGYTJGQ1FUQk9RVEZ1YzNsM2RFRRAB',
    5, 'ru', 'Профессионально, качественно, результативно. Рекомендую.',
    NULL, NULL, NULL, 'Профессионально, качественно, результативно. Рекомендую.', NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_aleksey_marfenkov, @clinic_id, NULL, 'google_maps',
    'places/ChIJn1poawAxTBMR267c0sW3AvY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21OUVVWVkhZakpTU1ZsU1lYY3hWbk5hWVhOU1drRRAB',
    5, 'ru', 'Хорошая клиника с современным оснащением. Приём ведёт профессиональный и приятный в общении доктор',
    NULL, NULL, NULL, 'Хорошая клиника с современным оснащением. Приём ведёт профессиональный и приятный в общении доктор', NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_dmitriy_b_dmitriyb, @clinic_id, NULL, 'google_maps',
    'places/ChIJn1poawAxTBMR267c0sW3AvY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tkWWFHWXdhamhwY2tGNGFVWlFRbWwxYkhSQ1NrRRAB',
    5, 'ru', 'Рекомендую. Доктор детально изучает проблему, не навязывает лишние услуги и назначенное лечение действительно помогает.
Напротив кабинета есть хорошая недорогая парковка',
    NULL, NULL, NULL, 'Рекомендую. Доктор детально изучает проблему, не навязывает лишние услуги и назначенное лечение действительно помогает.
Напротив кабинета есть хорошая недорогая парковка', NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_anton_panton, @clinic_id, NULL, 'google_maps',
    'places/ChIJn1poawAxTBMR267c0sW3AvY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkNGNTMTNZVjkxUmt4S1MzZDBOalJFZVdweGQxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_svetlana_ivleva, @clinic_id, NULL, 'google_maps',
    'places/ChIJn1poawAxTBMR267c0sW3AvY/reviews/Ci9DQUlRQUNvZENodHljRjlvT210V2RXUTNWbTlSTFVKVU9XWldSbEl3YUc1cWFXYxAB',
    5, 'ru', 'Александр Григорьевич специалист самого высокого уровня! Консультация по поводу коррекции лечения после инфаркта и стенирования. Клиника располагает к спокойному общению.  Доктор очень внимательно и тщательно проводит приём, вникает во все тонкости состояния пациента. Назначено актуальное лечение. Спасибо большое!  Лучший  доктор в Черногории.',
    NULL, NULL, NULL, 'Александр Григорьевич специалист самого высокого уровня! Консультация по поводу коррекции лечения после инфаркта и стенирования. Клиника располагает к спокойному общению.  Доктор очень внимательно и тщательно проводит приём, вникает во все тонкости состояния пациента. Назначено актуальное лечение. Спасибо большое!  Лучший  доктор в Черногории.', NULL, NULL,
    1, '2026-08-29 00:00:00'),

(@user_oksana_pimanova, @clinic_id, NULL, 'google_maps',
    'places/ChIJn1poawAxTBMR267c0sW3AvY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xsUmNGOUJVSGd3ZVZaSFdXVndiMVY2UkV4dmNtYxAB',
    5, 'ru', 'Добрый день.
Доктор Виллер Александр Григорьевичь - специалист широкого профиля и высокого уровня. Советую.',
    NULL, NULL, NULL, 'Добрый день.
Доктор Виллер Александр Григорьевичь - специалист широкого профиля и высокого уровня. Советую.', NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_natalya_lelyushkina, @clinic_id, NULL, 'google_maps',
    'places/ChIJn1poawAxTBMR267c0sW3AvY/reviews/Ci9DQUlRQUNvZENodHljRjlvT205WmNrWlBNbTVNVkU5ZmQyRnBWMjA1WDNwa2IzYxAB',
    5, 'ru', 'На приёме была впервые и осталась очень довольна. Кабинет расположен в удобном месте, рядом парковка, приятная атмосфера и чистота. Александр Григорьевич  внимательно выслушал все мои опасения, уделил достаточно времени на обследования, дал рекомендации . Профессионализм и доброжелательность на высшем уровне !  Искренне рекомендую обращаться к dr.Viller ⭐️⭐️⭐️⭐️⭐️',
    NULL, NULL, NULL, 'На приёме была впервые и осталась очень довольна. Кабинет расположен в удобном месте, рядом парковка, приятная атмосфера и чистота. Александр Григорьевич  внимательно выслушал все мои опасения, уделил достаточно времени на обследования, дал рекомендации . Профессионализм и доброжелательность на высшем уровне !  Искренне рекомендую обращаться к dr.Viller ⭐️⭐️⭐️⭐️⭐️', NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_natali_d, @clinic_id, NULL, 'google_maps',
    'places/ChIJn1poawAxTBMR267c0sW3AvY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xKMFgxQk5NVk5uUW1kdlVsaGhjVEZuWkZNNFpGRRAB',
    5, 'ru', 'Лучший доктор, доброжелательный, вежливый, всегда внимательно выслушает❤️',
    NULL, NULL, NULL, 'Лучший доктор, доброжелательный, вежливый, всегда внимательно выслушает❤️', NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_alex_stone, @clinic_id, NULL, 'google_maps',
    'places/ChIJn1poawAxTBMR267c0sW3AvY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xaQlpGZFRjVFZzT0VkZlZYZ3pjbWRsY1dKNU5tYxAB',
    5, 'ru', 'Лучший доктор, всегда внимательный и самое главное, настоящий профессионал.
Все рекомендации 🙏🏻🙏🏻',
    NULL, NULL, NULL, 'Лучший доктор, всегда внимательный и самое главное, настоящий профессионал.
Все рекомендации 🙏🏻🙏🏻', NULL, NULL,
    1, '2026-07-29 00:00:00'),

(@user_elena_bulgakova, @clinic_id, NULL, 'google_maps',
    'places/ChIJn1poawAxTBMR267c0sW3AvY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwVVIwWldhMm96V0RoMGFHOTZia3BXWjBobFJYYxAB',
    5, 'ru', 'Приятная атмосфера в кабинете. Внимательное отношение к проблеме. Комфортный прием и проведение процедур.
Доктор объясняет понятно и отвечает на все вопросы. После приема есть понимание, что делать и какие шаги ещё нужны. Всё по делу и спокойно.
Спасибо за прием!',
    NULL, NULL, NULL, 'Приятная атмосфера в кабинете. Внимательное отношение к проблеме. Комфортный прием и проведение процедур.
Доктор объясняет понятно и отвечает на все вопросы. После приема есть понимание, что делать и какие шаги ещё нужны. Всё по делу и спокойно.
Спасибо за прием!', NULL, NULL,
    1, '2026-05-29 00:00:00'),

(@user_paul_sartr, @clinic_id, NULL, 'google_maps',
    'places/ChIJn1poawAxTBMR267c0sW3AvY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21ORk9WSm5jV1Z3VFdwemNHWk9aVU40YzFkVlkzYxAB',
    5, 'ru', 'Консультация у Александра Григорьевича дала максимальную ясность по моей ситуации. Доктор очень вдумчиво и тщательно проводит приём. Дает индивидуальные рекомендации. Один из лучших медицинских специалистов в Черногории.',
    NULL, NULL, NULL, 'Консультация у Александра Григорьевича дала максимальную ясность по моей ситуации. Доктор очень вдумчиво и тщательно проводит приём. Дает индивидуальные рекомендации. Один из лучших медицинских специалистов в Черногории.', NULL, NULL,
    1, '2026-05-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
