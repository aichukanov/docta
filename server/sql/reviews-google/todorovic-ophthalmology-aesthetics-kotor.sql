-- Insert Google Maps reviews for Todorovic Ophthalmology & Aesthetics Medicine
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/todorovic-ophthalmology-aesthetics-kotor.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'todorovic-ophthalmology-aesthetics-kotor');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_nenad_todorovic = (SELECT id FROM doctors WHERE slug = 'nenad-todorovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'stitari13 stitari13', 'https://lh3.googleusercontent.com/a/ACg8ocKa70W-QKQ23T2_m2YSF2SABigBjGHCw8bWGu94pxZxcx_PYA=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/116258702236323720613/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116258702236323720613/reviews');
SET @user_stitari13_stitari13 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116258702236323720613/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Даль Кикин', 'https://lh3.googleusercontent.com/a/ACg8ocIfJEQHiTcWAxR-xD5ah5-abcXrUPc2H8NfZrHPtzrpgRZKIw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/112860729219302153841/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112860729219302153841/reviews');
SET @user_dal_kikin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112860729219302153841/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'O S', 'https://lh3.googleusercontent.com/a/ACg8ocLfxxhSeBGtPJmoETnRRXzvLNavaKSZ3Zq1uHuoM9RHfudqRw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/110389559307941182360/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110389559307941182360/reviews');
SET @user_o_s = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110389559307941182360/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lasse R', 'https://lh3.googleusercontent.com/a/ACg8ocJ-92pJYd6-ZJRY9s19BiXIDAeesM7-b8jTr4NO6is1QMYi5j0=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/113594354755455024996/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113594354755455024996/reviews');
SET @user_lasse_r = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113594354755455024996/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anđela Roćenović', 'https://lh3.googleusercontent.com/a/ACg8ocI8RLsC0Khx_p3i3zSKZtQWIcdFbcwG0BhhIMYTxPn42zpnHg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/100608828988170836144/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100608828988170836144/reviews');
SET @user_anela_roenovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100608828988170836144/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sandra Velas', 'https://lh3.googleusercontent.com/a/ACg8ocJ9XUC60welzBYVm5ACLRwOS8Z10MJGidSK2Y_-Ei2fVa5xSw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105469503367265869856/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105469503367265869856/reviews');
SET @user_sandra_velas = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105469503367265869856/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elena Vukčević', 'https://lh3.googleusercontent.com/a/ACg8ocIvS_imzDWI0xtKbrIUbzZwdNbHib50ApAaF8C1L5fubBmNMQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103106690749303556045/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103106690749303556045/reviews');
SET @user_elena_vukevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103106690749303556045/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Juha Muilu', 'https://lh3.googleusercontent.com/a-/ALV-UjWshXVPRjj6_DBu_CLm1LTsVBVJrJK2gTUevXINhjX67hJVae1V=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106000091719310405051/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106000091719310405051/reviews');
SET @user_juha_muilu = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106000091719310405051/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Taylor Chatting', 'https://lh3.googleusercontent.com/a/ACg8ocIyu2qw1FL4UIAHbD9UvuFbg2QobBwQf7f8IS-EjevI7Do5tw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117441407887734601765/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117441407887734601765/reviews');
SET @user_taylor_chatting = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117441407887734601765/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Golović', 'https://lh3.googleusercontent.com/a/ACg8ocIiDIOYb_uHKh8cywwZK90TOMCJCwtzsgmfuxlEOmgRi5nGOg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111240064704252917481/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111240064704252917481/reviews');
SET @user_nikola_golovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111240064704252917481/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vojo Pavlovic', 'https://lh3.googleusercontent.com/a/ACg8ocJGBWpCt52tbhWdjKyAYRZCnQ7zLwHT6vyveUEJw1UXKPNr8Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114256019530977752837/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114256019530977752837/reviews');
SET @user_vojo_pavlovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114256019530977752837/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lazo Pavlovic', 'https://lh3.googleusercontent.com/a/ACg8ocLWEu35ayX5tajcZbG2lIiJ5s4HT07rkgjRhGG4JLH90_NnDQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104397014805464312819/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104397014805464312819/reviews');
SET @user_lazo_pavlovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104397014805464312819/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Umika', 'https://lh3.googleusercontent.com/a-/ALV-UjUXj4bVM4J3tieSowB0WdcdztZGJ38NPr0e5DaRTm89W9CxuwrM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109492339390566896648/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109492339390566896648/reviews');
SET @user_umika = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109492339390566896648/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andjela Lasica', 'https://lh3.googleusercontent.com/a-/ALV-UjU9rzTMXxMDkoZ-r-UcOTBKpmOByDqMFN_kt2ixtcKb8lmtf2I=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102437020580659010897/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102437020580659010897/reviews');
SET @user_andjela_lasica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102437020580659010897/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sasa Radojkovic', 'https://lh3.googleusercontent.com/a/ACg8ocLE1Uk79012nh8PsmwGQ0H0nuUWx4scyhGlXO6vmJqtpSRKEQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116713289146490131955/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116713289146490131955/reviews');
SET @user_sasa_radojkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116713289146490131955/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Sukovic', 'https://lh3.googleusercontent.com/a/ACg8ocJI78xvXcUbEjA5YCkfOEszTqDyCCW-3OAyPufpZDhCyi3Gkw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116029159520597025013/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116029159520597025013/reviews');
SET @user_maja_sukovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116029159520597025013/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirza Krcic', 'https://lh3.googleusercontent.com/a/ACg8ocIdOqobIZc_EJfe9WKCPXILwtLgILtkKBND91ZuARtLVIBziFQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101310749943531293235/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101310749943531293235/reviews');
SET @user_mirza_krcic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101310749943531293235/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'stana stojakovic', 'https://lh3.googleusercontent.com/a/ACg8ocJYH92McSwsuoTdYjirjs5R1NCPYu2hcOwzcYAvJqfujLRnMA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117780685045040083065/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117780685045040083065/reviews');
SET @user_stana_stojakovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117780685045040083065/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'majda aleksic', 'https://lh3.googleusercontent.com/a/ACg8ocKoDB-DwAyQpcBuh8A_KZ8vzBRz8GYOPWh2rzEteEtUlzMH4Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104051185356330500506/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104051185356330500506/reviews');
SET @user_majda_aleksic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104051185356330500506/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'milo vukovic', 'https://lh3.googleusercontent.com/a/ACg8ocIku1I_sQ1z-NVMnJ5fIiSBd-q30moJjJmTB_W_Hz5PY3T0JA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103827410888193199298/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103827410888193199298/reviews');
SET @user_milo_vukovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103827410888193199298/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sreten Aleksic', 'https://lh3.googleusercontent.com/a/ACg8ocI5IGs9iYw2Sja5KbuMszjeMGZCknTTF_OSLhuH8AZdzTBT8A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103978067798713749254/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103978067798713749254/reviews');
SET @user_sreten_aleksic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103978067798713749254/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nastasija Janic', 'https://lh3.googleusercontent.com/a/ACg8ocKAN50aIvr1UmxxjCiGCjuiqA32Sp6a4ZvJkh7x1FBaQ44o0g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105873226378941133874/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105873226378941133874/reviews');
SET @user_nastasija_janic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105873226378941133874/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ranko M', 'https://lh3.googleusercontent.com/a-/ALV-UjUe9QI-tFzks5y22lpbvLoxhpznlVdQot0n1gtmEx4CK7jIOGU=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116006981167927992331/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116006981167927992331/reviews');
SET @user_ranko_m = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116006981167927992331/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_stitari13_stitari13, @clinic_id, @doctor_nenad_todorovic, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGUFRGWTBMVmcxWjNVeGRFZG1NVUV6V2xCQ05WRRAB',
    5, 'bs', 'Doktor Todorović je prvo jedna ljudina pa doktor. Moju staru majku od 81 godine primio kao da ima 10 god. Sa toliko pazljivoscu i osjećaja. Vjerujem da ima prema svakom pacijentu isti takav odnos.
Otkako je operisala tešku kataraktu na desnom oku evo 4 mjeseca idemo na kontrole kod dr. Todorovica uz njegovu profesionalnost moja majka vidi mnogo bolje. I ljubazno osoblje koje radi za njega.
Doktoru je na prvo mjesto zdravlje pacijenata, a bilo smo kod dr doktora rusa koji ima svoju kliniku u PG. Kod njega se prvo placa pa tek onda na pregled. A odnos prema pacijentu je hladan i odvratan!
Sve preporuke za Dr. Todorovica',
    'Dr Todorović je prvo osoba, a zatim lekar. Prema mojoj 81-godišnjoj majci se ponašao kao da ima 10 godina. Sa toliko brige i naklonosti. Verujem da ima isti stav prema svakom pacijentu.
Od kada je pre 4 meseca imala tešku operaciju katarakte na desnom oku, idemo kod dr Todorovića na kontrole i zahvaljujući njegovom profesionalizmu, moja majka mnogo bolje vidi. I ljubaznom osoblju koje radi za njega.
Doktor stavlja zdravlje svojih pacijenata na prvo mesto, a mi smo išli kod dr Rusa koji ima svoju kliniku u PG. Prvo plati, pa tek onda dobija pregled. A njegov stav prema pacijentu je hladan i odvratan!
Sve preporuke za dr Todorovića', 'Др Тодоровић је прво особа, а затим лекар. Према мојој 81-годишњој мајци се понашао као да има 10 година. Са толико бриге и наклоности. Верујем да има исти став према сваком пацијенту.
Од када је пре 4 месеца имала тешку операцију катаракте на десном оку, идемо код др Тодоровића на контроле и захваљујући његовом професионализму, моја мајка много боље види. И љубазном особљу које ради за њега.
Доктор ставља здравље својих пацијената на прво место, а ми смо ишли код др Руса који има своју клинику у ПГ. Прво плати, па тек онда добија преглед. А његов став према пацијенту је хладан и одвратан!
Све препоруке за др Тодоровића', NULL, NULL, NULL, NULL,
    0, '2025-08-12 16:11:28'),

(@user_dal_kikin, @clinic_id, @doctor_nenad_todorovic, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/Ci9DQUlRQUNvZENodHljRjlvT2taNWR6ZHhNRXN3U0ZBNE9Ga3RTelE1TUhSQlduYxAB',
    1, 'ru', 'Всё ниже — мой личный опыт и моё мнение.

У меня сложилось впечатление, что я столкнулся с мошенничеством.

Познакомился с доктором Тодоровичем, когда он работал в поликлинике Smart Med.

Видимо, у него много «талантов», если он работал терапевтом, а сейчас переквалифицировался в офтальмологи. Не удивлюсь, если он также гинеколог, маммолог, онколог и космонавт.

Этот «доктор» поставил мне диагноз — воспаление лёгких — и сообщил, что если я не пройду у них курс капельниц и антибиотиков, меня могут госпитализировать, где, по его словам, лечение стоит 600 евро в день.

Стоимость назначенного им курса превысила бы 1000 евро. После капельниц моё лицо опухло до неузнаваемости уже на следующий день.

На следующий день я обратился в Дом здравля, и там диагноз не подтвердился.
Врач сказала, что, по её мнению, доктор Тодорович не является специалистом.

Для полной уверенности я сделал рентген в Будве — лёгкие оказались абсолютно чистыми.

По моему опыту, подобные методы выглядят как запугивание и навязывание дорогого лечения.

Это моё личное мнение, никому ничего не навязываю, но я бы рекомендовал избегать этого врача и обращаться за консультацией в Дом здравля в Тивате или Будве.',
    'Sve što je navedeno ispod je moje lično iskustvo i mišljenje.

Osećala sam se kao da me prevare.

Upoznala sam dr Todorovića kada je radio u klinici Smart Med.

Mora da ima mnogo „talenata“, ako je ranije radio kao lekar opšte prakse, a sada se prekvalifikovao za oftalmologa. Ne bi me iznenadilo da je i ginekolog, mamolog, onkolog i kosmonaut.

Ovaj „doktor“ mi je dijagnostikovao upalu pluća i rekao mi da ako ne završim kurs intravenozne terapije i antibiotika, mogu biti hospitalizovana, gde bi, prema njegovim rečima, lečenje koštalo 600 evra dnevno.

Cena kursa koji mi je prepisao premašila bi 1.000 evra. Nakon intravenozne terapije, moje lice je bilo otečeno do neprepoznatljivosti već sledećeg dana.

Sledećeg dana sam otišla u Dom zdravlja, gde dijagnoza nije potvrđena. Doktorka je rekla da ne misli da je dr Todorović specijalista.

Da bih bila potpuno sigurna, uradila sam rendgen u Budvi — pluća su mi bila potpuno čista.

Po mom iskustvu, takve metode deluju kao zastrašivanje i pritisak da se kupi skup tretman.

Ovo je moje lično mišljenje i nikome ništa ne prisiljavam, ali bih preporučio da izbegavate ovog lekara i da potražite konsultacije u Domu zdravlja u Tivtu ili Budvi.', 'Све што је наведено испод је моје лично искуство и мишљење.

Осећала сам се као да ме преваре.

Упознала сам др Тодоровића када је радио у клиници Смарт Мед.

Мора да има много „талената“, ако је раније радио као лекар опште праксе, а сада се преквалификовао за офталмолога. Не би ме изненадило да је и гинеколог, мамолог, онколог и космонаут.

Овај „доктор“ ми је дијагностиковао упалу плућа и рекао ми да ако не завршим курс интравенозне терапије и антибиотика, могу бити хоспитализована, где би, према његовим речима, лечење коштало 600 евра дневно.

Цена курса који ми је преписао премашила би 1.000 евра. Након интравенозне терапије, моје лице је било отечено до непрепознатљивости већ следећег дана.

Следећег дана сам отишла у Дом здравља, где дијагноза није потврђена. Докторка је рекла да не мисли да је др Тодоровић специјалиста.

Да бих била потпуно сигурна, урадила сам рендген у Будви — плућа су ми била потпуно чиста.

По мом искуству, такве методе делују као застрашивање и притисак да се купи скуп третман.

Ово је моје лично мишљење и никоме ништа не присиљавам, али бих препоручио да избегавате овог лекара и да потражите консултације у Дому здравља у Тивту или Будви.', NULL, 'Всё ниже — мой личный опыт и моё мнение.

У меня сложилось впечатление, что я столкнулся с мошенничеством.

Познакомился с доктором Тодоровичем, когда он работал в поликлинике Smart Med.

Видимо, у него много «талантов», если он работал терапевтом, а сейчас переквалифицировался в офтальмологи. Не удивлюсь, если он также гинеколог, маммолог, онколог и космонавт.

Этот «доктор» поставил мне диагноз — воспаление лёгких — и сообщил, что если я не пройду у них курс капельниц и антибиотиков, меня могут госпитализировать, где, по его словам, лечение стоит 600 евро в день.

Стоимость назначенного им курса превысила бы 1000 евро. После капельниц моё лицо опухло до неузнаваемости уже на следующий день.

На следующий день я обратился в Дом здравля, и там диагноз не подтвердился.
Врач сказала, что, по её мнению, доктор Тодорович не является специалистом.

Для полной уверенности я сделал рентген в Будве — лёгкие оказались абсолютно чистыми.

По моему опыту, подобные методы выглядят как запугивание и навязывание дорогого лечения.

Это моё личное мнение, никому ничего не навязываю, но я бы рекомендовал избегать этого врача и обращаться за консультацией в Дом здравля в Тивате или Будве.', NULL, NULL,
    0, '2025-08-29 13:47:27'),

(@user_o_s, @clinic_id, NULL, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/Ci9DQUlRQUNvZENodHljRjlvT21SMWVsazBkbVZEVFV3emREZEpTbE10VDBGek5GRRAB',
    5, 'en', 'This office is busy but the service is excellent. The doctor takes his time to explain everything and the front office is very kind. Thank you 🙏',
    'Ova ordinacija je gužva, ali je usluga odlična. Doktor odvaja vreme da sve objasni, a osoblje na recepciji je veoma ljubazno. Hvala vam 🙏', 'Ова ординација је гужва, али је услуга одлична. Доктор одваја време да све објасни, а особље на рецепцији је веома љубазно. Хвала вам 🙏', 'This office is busy but the service is excellent. The doctor takes his time to explain everything and the front office is very kind. Thank you 🙏', NULL, NULL, NULL,
    0, '2026-02-09 18:11:23'),

(@user_lasse_r, @clinic_id, @doctor_nenad_todorovic, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/ChZDSUhNMG9nS0VQYjZtZnFxOWEtSWFREAE',
    5, 'en', 'Todorovic agreed to remove my tear duct surgery suture and wrote me a new recipe for eye drops I had forgotten, even though he already had a very tight schedule, since I was traveling and had no possibility to wait. He was easy to communicate with via email and the procedure went well.

The clinic was easy to find, it was on the ground floor and had a big logo on the window. The cost of the visit was 100€ in total.

Hvala!',
    'Todorović je pristao da mi ukloni šav od operacije suznog kanala i napisao mi je novi recept za kapi za oči koje sam zaboravila, iako je već imao veoma zgusnut raspored, pošto sam putovala i nisam imala mogućnost da čekam. Bilo je lako komunicirati sa njim putem imejla i postupak je prošao dobro.

Kliniku je bilo lako pronaći, bila je u prizemlju i imala je veliki logo na izlogu. Cena posete je bila ukupno 100€.

Hvala!', 'Тодоровић је пристао да ми уклони шав од операције сузног канала и написао ми је нови рецепт за капи за очи које сам заборавила, иако је већ имао веома згуснут распоред, пошто сам путовала и нисам имала могућност да чекам. Било је лако комуницирати са њим путем имејла и поступак је прошао добро.

Клинику је било лако пронаћи, била је у приземљу и имала је велики лого на излогу. Цена посете је била укупно 100€.

Хвала!', 'Todorovic agreed to remove my tear duct surgery suture and wrote me a new recipe for eye drops I had forgotten, even though he already had a very tight schedule, since I was traveling and had no possibility to wait. He was easy to communicate with via email and the procedure went well.

The clinic was easy to find, it was on the ground floor and had a big logo on the window. The cost of the visit was 100€ in total.

Hvala!', NULL, NULL, NULL,
    0, '2025-06-04 05:46:31'),

(@user_anela_roenovi, @clinic_id, @doctor_nenad_todorovic, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/ChdDSUhNMG9nS0VJQ0FnSURIM3YtcXBRRRAB',
    5, 'bs', 'Sve pohvale za doktora Todorovića!
Doktor kome prepustam brigu o mom licu.
Srećno otvaranje klinike! Sve najbolje u daljem radu.
A sad idem da zakažem termin na vrijeme. 🙂',
    'Sve pohvale za dr Todorovića!
Doktor kome verujem da se brine o mom licu.
Srećno otvaranje klinike! Sve najbolje u daljem radu.
A sada idem da zakažem termin na vreme. 🙂', 'Све похвале за др Тодоровића!
Доктор коме верујем да се брине о мом лицу.
Срећно отварање клинике! Све најбоље у даљем раду.
А сада идем да закажем термин на време. 🙂', NULL, NULL, NULL, NULL,
    0, '2024-09-16 12:16:21'),

(@user_sandra_velas, @clinic_id, NULL, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psdlRtTXhMV05FU1ZGa1VteEtZa1owTkZGVlNrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-26 00:00:00'),

(@user_elena_vukevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tFek0zQktZV0p3YzJwS2NXZGxZM2RZUW5FMlRIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_juha_muilu, @clinic_id, NULL, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5U1ZGWjJORVZLTlVOd1lXMXRWRzUwTURkblNtYxAB',
    5, 'en', 'Good, professional service. It was possible to make an appointment during the weekend for an urgent case via WhatsApp.',
    NULL, NULL, 'Good, professional service. It was possible to make an appointment during the weekend for an urgent case via WhatsApp.', NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_taylor_chatting, @clinic_id, @doctor_nenad_todorovic, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/Ci9DQUlRQUNvZENodHljRjlvT21ad1dWRnpOa2xtZW1SWU4waEpNbUZQU0VSME5HYxAB',
    5, 'en', 'I was traveling from the U.S. and staying in Tivat. I suddenly found myself needing an opthamologist to conduct an exam and rule out anything serious. We found Dr. Todorovic online and took a taxi out to see him. He communicated with me via WhatsApp on a Sunday, got us scheduled for the very next morning, was patient with us as our taxi got stuck in horrible traffic, and his staff stayed late and called us a return taxi. The office is clean. They spoke to me in perfect English and made me feel comfortable while faced with a scary situation. If you find yourself traveling (or if you live here) and need an opthamologist, I recommend him! Thank you, Dr. Todorovic for your professionalism and patience!',
    NULL, NULL, 'I was traveling from the U.S. and staying in Tivat. I suddenly found myself needing an opthamologist to conduct an exam and rule out anything serious. We found Dr. Todorovic online and took a taxi out to see him. He communicated with me via WhatsApp on a Sunday, got us scheduled for the very next morning, was patient with us as our taxi got stuck in horrible traffic, and his staff stayed late and called us a return taxi. The office is clean. They spoke to me in perfect English and made me feel comfortable while faced with a scary situation. If you find yourself traveling (or if you live here) and need an opthamologist, I recommend him! Thank you, Dr. Todorovic for your professionalism and patience!', NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_nikola_golovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/Ci9DQUlRQUNvZENodHljRjlvT2trd1JFZEliV2hFYVRodlpGWTVieTB5ZERWTFVrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_vojo_pavlovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/Ci9DQUlRQUNvZENodHljRjlvT2poaVVESjFjVE0yY1ZCdWFtVXlibUpyYmkwNGNWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_lazo_pavlovic, @clinic_id, @doctor_nenad_todorovic, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/Ci9DQUlRQUNvZENodHljRjlvT25ZNU1EUjViR2RYV21oTFF5MUdUVFJ1WjJnMGVtYxAB',
    5, 'sr', 'Sve pohvale za dr.Todorovica i njegov tim!',
    'Sve pohvale za dr.Todorovica i njegov tim!', 'Sve pohvale za dr.Todorovica i njegov tim!', NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_umika, @clinic_id, @doctor_nenad_todorovic, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/Ci9DQUlRQUNvZENodHljRjlvT21sS2MweEVTVTFIYmpCRU5USlFhMGhMVVRKTWVuYxAB',
    5, 'hr', 'Sve pohvale za dr. Todorovica i osoblje klinike. 😇',
    'Sve pohvale za dr. Todorovica i osoblje klinike. 😇', NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_andjela_lasica, @clinic_id, @doctor_nenad_todorovic, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xZMU5GTktialprVnpONGNEa3llVFppYm5weFkzYxAB',
    5, 'hr', 'Sve pohvale za Kliniku Todorović! Profesionalnost, ljubaznost i posvećenost pacijentu su na najvišem nivou. Od samog dolaska osjećate se sigurno i u dobrim rukama. Tim je izuzetno stručan, a usluga vrhunska. Iskrene preporuke svima koji žele kvalitet, stručnost i vrhunsku njegu. Za nas ste bez konkurencije – najbolji! ⭐⭐⭐⭐⭐',
    'Sve pohvale za Kliniku Todorović! Profesionalnost, ljubaznost i posvećenost pacijentu su na najvišem nivou. Od samog dolaska osjećate se sigurno i u dobrim rukama. Tim je izuzetno stručan, a usluga vrhunska. Iskrene preporuke svima koji žele kvalitet, stručnost i vrhunsku njegu. Za nas ste bez konkurencije – najbolji! ⭐⭐⭐⭐⭐', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_sasa_radojkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tjeVlYcEtRemR2VjJ4SVRubGZRbTA1WkRBeVMyYxAB',
    5, 'en', 'Proffesional care on all levels. Full recomendation.',
    NULL, NULL, 'Proffesional care on all levels. Full recomendation.', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_maja_sukovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/ChZDSUhNMG9nS0VOWGU2b2FLMWVqeWRBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_mirza_krcic, @clinic_id, NULL, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/ChdDSUhNMG9nS0VJQ0FnSURIaVlQRWd3RRAB',
    5, 'hr', 'Profesionalan odnos prema pacijentima. Kvalitetna usluga. Sve pohvale!',
    'Profesionalan odnos prema pacijentima. Kvalitetna usluga. Sve pohvale!', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_stana_stojakovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/ChdDSUhNMG9nS0VJQ0FnSURIdnVuMGpRRRAB',
    5, 'bs', 'Vrlo profesionalni.Vrlo tačni i ljubazni...Sve preporuke...',
    'Vrlo profesionalni.Vrlo tačni i ljubazni...Sve preporuke...', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_majda_aleksic, @clinic_id, NULL, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/ChZDSUhNMG9nS0VJQ0FnSURIZ2FmR01BEAE',
    5, 'en', 'A modern surgery with wonderful and friendly staff.. the professional team follows modern trends, enters into the knowledge, equipment and materials they work with. Highly recommended...',
    NULL, NULL, 'A modern surgery with wonderful and friendly staff.. the professional team follows modern trends, enters into the knowledge, equipment and materials they work with. Highly recommended...', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_milo_vukovic, @clinic_id, @doctor_nenad_todorovic, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/ChZDSUhNMG9nS0VJQ0FnSURIZ2ZpY0tBEAE',
    5, 'bs', 'Sve pohvale za doktora Todorovica, za njegovu strucnost i ljubaznost. Vec duzi period sam njegov pacijent i najiskrenije ga preporucujem svima.',
    'Sve pohvale za doktora Todorovica, za njegovu strucnost i ljubaznost. Vec duzi period sam njegov pacijent i najiskrenije ga preporucujem svima.', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_sreten_aleksic, @clinic_id, NULL, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/ChZDSUhNMG9nS0VJQ0FnSURIX3ZpMll3EAE',
    5, 'bs', 'Sam pristup doktora i uslugu koju dobijete su na maksimalnom mogucem nivou. Sve preporuke za ovu ordinaciju!!!',
    'Sam pristup doktora i uslugu koju dobijete su na maksimalnom mogucem nivou. Sve preporuke za ovu ordinaciju!!!', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_nastasija_janic, @clinic_id, NULL, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/ChZDSUhNMG9nS0VJQ0FnSURIdnI3SmF3EAE',
    5, 'en', 'The best aesthetics and ophthalmology doctor I’ve ever met,he’s so professional and gentle,also not to mention the kindness and effort he puts in his work.Literally the best ophthalmology and aesthetics clinic in Montenegro.',
    NULL, NULL, 'The best aesthetics and ophthalmology doctor I’ve ever met,he’s so professional and gentle,also not to mention the kindness and effort he puts in his work.Literally the best ophthalmology and aesthetics clinic in Montenegro.', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_ranko_m, @clinic_id, NULL, 'google_maps',
    'places/ChIJN_zVzNMzTBMRGfsXFs-82Xs/reviews/ChdDSUhNMG9nS0VJQ0FnSURIdnBpYzZnRRAB',
    5, 'en', 'Great!',
    NULL, NULL, 'Great!', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
