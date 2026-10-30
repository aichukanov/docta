-- Insert Google Maps reviews for Poliklinika Stojanović Medical
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/poliklinika-stojanovic-medical-berane.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'poliklinika-stojanovic-medical-berane');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'One Media PG', 'https://lh3.googleusercontent.com/a-/ALV-UjUcRUflBEejB4qsdQMZv08jipNO3K8NrhErI1RWA-bqZLW8eGY=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/104402458364521012805/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104402458364521012805/reviews');
SET @user_one_media_pg = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104402458364521012805/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Daniel Stankowski', 'https://lh3.googleusercontent.com/a-/ALV-UjV5FnX1c0C4OawOG6l6xIeQxbJJ_PReJGilQ9dkbauLE0PE2y6f=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/106440044194965416684/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106440044194965416684/reviews');
SET @user_daniel_stankowski = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106440044194965416684/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tamara Pantović', 'https://lh3.googleusercontent.com/a-/ALV-UjUD_D-pcBJ5KUb2QkVDOgsnuJyIkoVR_7Cx3PYtDs206UCWpdA=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/100773738822068590868/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100773738822068590868/reviews');
SET @user_tamara_pantovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100773738822068590868/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alan Hadrovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXYC2kdB3EsXuQb4xi0P2Jabg8RnRO-JzUC13ohU72kyF7RFkjs=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107608210538292029541/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107608210538292029541/reviews');
SET @user_alan_hadrovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107608210538292029541/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vasko Zugic', 'https://lh3.googleusercontent.com/a-/ALV-UjUbvoYUivjGyrqr1rhondiohH0JZN6gN6hluNnMlD2zmVRMD2Ra=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101683428075060223420/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101683428075060223420/reviews');
SET @user_vasko_zugic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101683428075060223420/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zofia Głowacka', 'https://lh3.googleusercontent.com/a/ACg8ocJEtmavay3k-p7muNN_Hbtu8p_RdXV7pxTwD1wdVKISAxT4MqU=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112092969864522424695/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112092969864522424695/reviews');
SET @user_zofia_gowacka = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112092969864522424695/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Slavica Ivanovic', 'https://lh3.googleusercontent.com/a/ACg8ocICMNvtTfrALbYL0UFmotBHjhzi-SYywUkPttp3M3fJtfa3sQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107382952890410349412/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107382952890410349412/reviews');
SET @user_slavica_ivanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107382952890410349412/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nina Obradović', 'https://lh3.googleusercontent.com/a-/ALV-UjWC-uYvAjANxzBMqa1xra2RXVxx86yLsprDDRF5pDpl33o35KIGcg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107151327531579123046/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107151327531579123046/reviews');
SET @user_nina_obradovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107151327531579123046/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Bulatovic', 'https://lh3.googleusercontent.com/a/ACg8ocKQlinhmxHV-mV5KsTejX6pRt5dXIDOKZ3pYRwaJAzOxjC9T7M=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108421115090731118868/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108421115090731118868/reviews');
SET @user_jelena_bulatovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108421115090731118868/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ryme', 'https://lh3.googleusercontent.com/a-/ALV-UjXYAGK3nvquGZT2AAe-BN9AdAiALCh5mB0i2-9QHXBSUGcJlmA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113439821923704414652/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113439821923704414652/reviews');
SET @user_ryme = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113439821923704414652/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kerim Zubcevic', 'https://lh3.googleusercontent.com/a/ACg8ocJS-3lZRIACuqivE4iVpHP3sJ5JFfNNRhvArsy3XFLXgshd6Q=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103458220095808525815/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103458220095808525815/reviews');
SET @user_kerim_zubcevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103458220095808525815/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Azra Taranis', 'https://lh3.googleusercontent.com/a/ACg8ocL2tFGxr3nFwlx5CoMqi5rp2i2FMkbgmwIUiquWuSTAvb1PJw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106339494713547506470/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106339494713547506470/reviews');
SET @user_azra_taranis = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106339494713547506470/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alisa Baj', 'https://lh3.googleusercontent.com/a/ACg8ocJZozdKq6UDNQNoyxEKNAs846VJnvIAw3Zj16XMHR--uZrTRbrd=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108669307685020919621/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108669307685020919621/reviews');
SET @user_alisa_baj = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108669307685020919621/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zlata Halilovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUv8TO0c_ar0aupPkvjKi6gkE8yRcOEMVCaLVATfkFgrlwwF90=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103777533280909163543/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103777533280909163543/reviews');
SET @user_zlata_halilovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103777533280909163543/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Biljana', 'https://lh3.googleusercontent.com/a/ACg8ocKL3VUBxeOqsvzPh8SPdTYAfKL3FFVl0etofASF_JpwctMuaw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100830816992909516123/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100830816992909516123/reviews');
SET @user_biljana = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100830816992909516123/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mileva Jankovic', 'https://lh3.googleusercontent.com/a/ACg8ocI0e65MthuRrLR1rz6QPGhewp6pnEc4e3C9vEOdPvXF8MA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117816305154325804737/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117816305154325804737/reviews');
SET @user_mileva_jankovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117816305154325804737/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Guberinic', 'https://lh3.googleusercontent.com/a-/ALV-UjWt-OXIM3ARKRlKi8voNvFfQd7Eux0VvuG5M8W1aDs75LNT3V6K=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114275930751847563877/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114275930751847563877/reviews');
SET @user_marko_guberinic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114275930751847563877/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'marko stojanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWYoKMH8QdICFaLJ3BYXtqiWhW0KSjiEbPit7PqE9W3Qn40vEo=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106439045075076180402/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106439045075076180402/reviews');
SET @user_marko_stojanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106439045075076180402/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nele Montenegro', 'https://lh3.googleusercontent.com/a-/ALV-UjU-D7heUfT7NcC2giD3hdWtuQi3UcdUUarnooPvs2_ljtJU3aok=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117338768342912905564/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117338768342912905564/reviews');
SET @user_nele_montenegro = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117338768342912905564/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aca Milenkovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUOlxwgw5w661jID3TzMx9AmSeQtzV8BZBrFflbYsAfJfpUsGXu=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101926334236124435653/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101926334236124435653/reviews');
SET @user_aca_milenkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101926334236124435653/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Stojanovic', 'https://lh3.googleusercontent.com/a/ACg8ocJTGyXRtfphDn7-Lwxo-3nv3VguLpuhJMUpz_od44wJ7NiTDw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105278853683835650233/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105278853683835650233/reviews');
SET @user_marija_stojanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105278853683835650233/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marijana Vukic', 'https://lh3.googleusercontent.com/a/ACg8ocJw4zF4zu-paELGSvFKo39LYx9Jn6lxx3lk_7WgjOaRJ_zetw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116703219565520713202/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116703219565520713202/reviews');
SET @user_marijana_vukic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116703219565520713202/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Miljana Knežević', 'https://lh3.googleusercontent.com/a/ACg8ocJuqanhVZ-dRs_8_t-eNEkFQNgBEKgfwDvwuQN2uWzb1yJqxA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104527150810961778063/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104527150810961778063/reviews');
SET @user_miljana_kneevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104527150810961778063/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mihail Lozanovski', 'https://lh3.googleusercontent.com/a/ACg8ocIjkfarIVj1D6iRQlcL2_AtnQ1pnmWEhJ6G2Au3K6v0ZtFH0Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111873217244145775227/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111873217244145775227/reviews');
SET @user_mihail_lozanovski = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111873217244145775227/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Filip Gasevic', 'https://lh3.googleusercontent.com/a-/ALV-UjW5K42LUuOS2iX6JSJhY8Uj3s8HJJMgaBgUfG3OwhteYeLL8fBQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100290351847264446023/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100290351847264446023/reviews');
SET @user_filip_gasevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100290351847264446023/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Matija Stojanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUhVKb10pOPn2L7PftGJ7vIiZOFQMIoOFi3GISkAKyLCnU3Gh3E=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114829108822255046679/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114829108822255046679/reviews');
SET @user_matija_stojanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114829108822255046679/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Barbara Simovic', 'https://lh3.googleusercontent.com/a-/ALV-UjU-AtDXhq_fUiWnjF2h5jy4uspLAbHCf66eYJ2Y0quIKOjPvkM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117797827157636516489/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117797827157636516489/reviews');
SET @user_barbara_simovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117797827157636516489/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_one_media_pg, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ2cWVxVEd3EAE',
    5, 'sr', 'Број 1 поликлинка на сјеверу ЦГ!',
    'Broj 1 poliklinka na sjeveru CG!', 'Број 1 поликлинка на сјеверу ЦГ!', NULL, NULL, NULL, NULL,
    3, '2021-10-03 23:07:04'),

(@user_daniel_stankowski, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/Ci9DQUlRQUNvZENodHljRjlvT21wcVJsbEpjVlJpVm14MU4xbHRaVE54YjNKSU1IYxAB',
    5, 'en', 'Positively surprised with the visit.
My wife needed an urgent appointment related to her pregnancy. Even though the reception desk wasn\'t speaking English, with the help of Google translate we managed to explain the issue.

After waiting 30 min we met Dr. Damir, who was professional, carrying and spoke fluent English!

Highly recommend the clinic!',
    'Pozitivno iznenađen posetom.
Mojoj supruzi je bio potreban hitan pregled u vezi sa trudnoćom. Iako na recepciji nisu govorili engleski, uz pomoć Gugl prevodioca uspeli smo da objasnimo problem.

Nakon 30 minuta čekanja, upoznali smo dr Damira, koji je bio profesionalan, fin i tečno je govorio engleski!

Toplo preporučujem kliniku!', 'Позитивно изненађен посетом.
Мојој супрузи је био потребан хитан преглед у вези са трудноћом. Иако на рецепцији нису говорили енглески, уз помоћ Гугл преводиоца успели смо да објаснимо проблем.

Након 30 минута чекања, упознали смо др Дамира, који је био професионалан, фин и течно је говорио енглески!

Топло препоручујем клинику!', 'Positively surprised with the visit.
My wife needed an urgent appointment related to her pregnancy. Even though the reception desk wasn\'t speaking English, with the help of Google translate we managed to explain the issue.

After waiting 30 min we met Dr. Damir, who was professional, carrying and spoke fluent English!

Highly recommend the clinic!', NULL, NULL, NULL,
    0, '2025-06-17 04:15:42'),

(@user_tamara_pantovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/ChZDSUhNMG9nS0VJQ0FnTUNnXzU3MmF3EAE',
    5, 'hr', 'Doktor Stojanović je vrhunski dijagnostičar, čije mišljenje nikada nije pobijeno od strane bilo koje institucije, čak ni u velikim medicinskim centrima kao što je Beograd. Sve preporuke za odlazak kod ovog izuzetnog stručnjaka.',
    'Doktor Stojanović je vrhunski dijagnostičar, čije mišljenje nikada nije opovrgla ni jedna ustanova, pa ni u velikim medicinskim centrima poput Beograda. Sve preporuke za odlazak kod ovog izuzetnog specijaliste.', 'Доктор Стојановић је врхунски дијагностичар, чије мишљење никада није оповргла ни једна установа, па ни у великим медицинским центрима попут Београда. Све препоруке за одлазак код овог изузетног специјалисте.', NULL, NULL, NULL, NULL,
    0, '2025-02-21 21:22:18'),

(@user_alan_hadrovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kwMFJWSmtOMnRxZG5CNlVVcFFVelZzWWxBeFFsRRAB',
    5, 'en', 'Fast service, professional, and the staff is very polite and helpful.',
    'Brza usluga, profesionalno, a osoblje je veoma ljubazno i uslužno.', 'Брза услуга, професионално, а особље је веома љубазно и услужно.', 'Fast service, professional, and the staff is very polite and helpful.', NULL, NULL, NULL,
    0, '2025-12-17 17:54:55'),

(@user_vasko_zugic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/ChdDSUhNMG9nS0VJQ0FnSUR5NGYzNXNRRRAB',
    5, 'bs', 'Sigurno jedino mjesto na cijelom sjeveru Crne Gore, a mozda i šire, koje se može pohvaliti najsavremenijom dijagnostičkom aparaturom i izuzetno stručnim kadrom na jednom mjestu. Svaka čast sve pohvale!',
    'Sigurno jedino mjesto na cijelom sjeveru Crne Gore, a možda i šire, koje se može pohvaliti najsavremenijom dijagnostičkom opremom i izuzetno stručnim kadrom na jednom mjestu. Sve najbolje, sve pohvale!', 'Сигурно једино мјесто на цијелом сјеверу Црне Горе, а можда и шире, које се може похвалити најсавременијом дијагностичком опремом и изузетно стручним кадром на једном мјесту. Све најбоље, све похвале!', NULL, NULL, NULL, NULL,
    5, '2021-03-10 12:42:29'),

(@user_zofia_gowacka, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t0cWFGcEZYM2c1TVVreVduTXlNMGxSZWtjeFJWRRAB',
    5, 'en', 'I arrived to this clinic in a lot of stress after I was rushed in the hospital to do MRI. They were so helpful and agreed to do it immediately and accommodated with getting my description from radiologist fast. The person conducting the MRI spoke perfect english and acted very professional and kind. I was taken care of and safe. Thank you so much! I recommend this place.',
    NULL, NULL, 'I arrived to this clinic in a lot of stress after I was rushed in the hospital to do MRI. They were so helpful and agreed to do it immediately and accommodated with getting my description from radiologist fast. The person conducting the MRI spoke perfect english and acted very professional and kind. I was taken care of and safe. Thank you so much! I recommend this place.', NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_slavica_ivanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/Ci9DQUlRQUNvZENodHljRjlvT205UWVXNXdYMVJuWW1WSkxWWnZZMUJRYkRob1ltYxAB',
    5, 'hr', 'Stručnost i posvećenost doktora i osoblja Poliklinike Stojanović Medikal sve pohvale,
preporuka!',
    'Stručnost i posvećenost doktora i osoblja Poliklinike Stojanović Medikal sve pohvale,
preporuka!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_nina_obradovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tGek5HWkhOV2R5VDJSVmRVaGlhell6VURkalprRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_jelena_bulatovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2poVVpWVmhOV3R2UkhscFZYSTNNamd3ZVV4VmJXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_ryme, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tKV1pXWmFla0ZGYm5kVVJsRnNTMHhyYVhVMlJGRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_kerim_zubcevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/Ci9DQUlRQUNvZENodHljRjlvT25ORVNsWXdiM2t3VEZKMk1ETnVNek5KZURCWFRHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_azra_taranis, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tSaWNWSlVabU5yWDE5ZmRVOTRVRU5WWlhwZmJrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_alisa_baj, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/ChdDSUhNMG9nS0VJQ0FnSUNfcktURnZRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_zlata_halilovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/ChZDSUhNMG9nS0VJQ0FnSUR2ejYzUUhBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_biljana, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ3LXEtaFR3EAE',
    5, 'de', 'Alles gute und großes Lob für Dr. Stojanovic und seine Mitarbeiter!',
    NULL, NULL, NULL, NULL, 'Alles gute und großes Lob für Dr. Stojanovic und seine Mitarbeiter!', NULL,
    1, '2024-10-29 00:00:00'),

(@user_mileva_jankovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/ChdDSUhNMG9nS0VJQ0FnSURicjVtaHVnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_marko_guberinic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/ChdDSUhNMG9nS0VJQ0FnSUNMcWYtem9BRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_marko_stojanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/ChdDSUhNMG9nS0VJQ0FnSUNabkpQSHJRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_nele_montenegro, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/ChZDSUhNMG9nS0VJQ0FnSURHdGNTWlB3EAE',
    5, 'sr-Latn', '👌',
    NULL, NULL, NULL, NULL, NULL, NULL,
    3, '2022-10-29 00:00:00'),

(@user_aca_milenkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/ChdDSUhNMG9nS0VJQ0FnSUNxX3V6d19RRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_marija_stojanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/ChZDSUhNMG9nS0VJQ0FnSUNLc3VqRVdBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_marijana_vukic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/ChdDSUhNMG9nS0VJQ0FnSUR5a1lEd293RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_miljana_kneevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/ChdDSUhNMG9nS0VJQ0FnSUR5NFllZWhRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_mihail_lozanovski, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/ChdDSUhNMG9nS0VJQ0FnSUR5NFlXc3B3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_filip_gasevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/ChZDSUhNMG9nS0VJQ0FnSUR5NGJuYkxnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_matija_stojanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/ChdDSUhNMG9nS0VJQ0FnSUR5NFk2VHJRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_barbara_simovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuSXfN7GTUhMRdCC_32memt0/reviews/ChZDSUhNMG9nS0VJQ0FnSUR5NFk3UkRBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
