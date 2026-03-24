-- Insert Google Maps reviews for Novi Cenex Medical (Podgorica)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/cenex-medical-podgorica.sql

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = 59;
SET @doctor_katarina_mitrovic = 611;
SET @doctor_zoran_terzic = 660;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Soskic', 'https://lh3.googleusercontent.com/a-/ALV-UjUVnmTbBdu6oimSa51VLw9G1qg4rOyQ8kSrdMj7EkgoKK1liqZSTQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116477464431441148191/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116477464431441148191/reviews');
SET @user_jovana_soskic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116477464431441148191/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natasha Knezevic', 'https://lh3.googleusercontent.com/a-/ALV-UjUCwQ-DtTQIP3mhwhmoTboGQN4Bg3ArjzSTJs1nMCDrTBKGaiH_=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/115840822253120889768/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115840822253120889768/reviews');
SET @user_natasha_knezevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115840822253120889768/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Bijelic', 'https://lh3.googleusercontent.com/a-/ALV-UjWwxRpSBYRmBOu2nVNKfJ9o4SVHO5Wwr4MYhNj9esFRFhMHJ92U=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109263151483776869860/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109263151483776869860/reviews');
SET @user_ivan_bijelic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109263151483776869860/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mina Nurkovic', 'https://lh3.googleusercontent.com/a/ACg8ocK4TRczMZKYVn1jXeGZqBSs3ecw9O9N8RHnDTEyFMavk20-Mg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114556333369828580793/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114556333369828580793/reviews');
SET @user_mina_nurkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114556333369828580793/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Данијела Прелевић', 'https://lh3.googleusercontent.com/a-/ALV-UjVrh0rs72jHQuTQ6h_KTeVFHUdPXMIuGJmJ9Q657CfOWjt9t23eug=w36-h36-p-rp-mo-ba5-br100', 'https://www.google.com/maps/contrib/111134764343409696472/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111134764343409696472/reviews');
SET @user_danijela_prelevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111134764343409696472/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danijela Raspopovic', 'https://lh3.googleusercontent.com/a/ACg8ocItGNgRe5ostiMzdenwZG09YFCcvZs3oYTZUqcZoHtJjlGc8Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110989806175910210960/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110989806175910210960/reviews');
SET @user_danijela_raspopovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110989806175910210960/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ksenija Mijuskovic', 'https://lh3.googleusercontent.com/a/ACg8ocKaxSpcX-Djve6qdo-2StDJgCo3qZDx3wBfDNplCNw-4M_53w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106018559585349506820/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106018559585349506820/reviews');
SET @user_ksenija_mijuskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106018559585349506820/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vasilije', 'https://lh3.googleusercontent.com/a-/ALV-UjX6zrP_Bx8ObEmTX5z00sui3fUV0hcpNWLn5Gsw_DXj1ELCO3LFzA=w36-h36-p-rp-mo-ba6-br100', 'https://www.google.com/maps/contrib/109235998371718208797/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109235998371718208797/reviews');
SET @user_vasilije = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109235998371718208797/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Sarcevic', 'https://lh3.googleusercontent.com/a/ACg8ocLjAeloiW1DKC9m9_szTrrWv4hjBtVdrQZC5JEl5jSegOxGcQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110905715104712719089/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110905715104712719089/reviews');
SET @user_ana_sarcevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110905715104712719089/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luoyan', 'https://lh3.googleusercontent.com/a-/ALV-UjUmlEZFz0Xgr7NugRG19lgQoIhHQRLbNQ64ep3M6T_YYyrZJ5gD=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/117214584213419721466/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117214584213419721466/reviews');
SET @user_luoyan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117214584213419721466/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Fil Samsung', 'https://lh3.googleusercontent.com/a/ACg8ocKP0TVn2koKUSNikas55Lco0rOgB933w0MWGosuhMrX64B7TQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107336215390379559205/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107336215390379559205/reviews');
SET @user_fil_samsung = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107336215390379559205/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Valentina Minic', 'https://lh3.googleusercontent.com/a-/ALV-UjXOiqjM3oj98Np_srEUMl58Ah05nLdQL2KZQlXeE3yK2AtNbaRHgA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111404342028461587412/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111404342028461587412/reviews');
SET @user_valentina_minic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111404342028461587412/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Radulovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVd6-8r0RPPs_Fqk6aXIfGWi5lZ5Uw3XfUSDjkOYT-LzCM40auL=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/117038364267598170984/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117038364267598170984/reviews');
SET @user_nikola_radulovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117038364267598170984/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dana Radonjic', 'https://lh3.googleusercontent.com/a/ACg8ocKHEg7XMO26MlNifbDmrkjB2CMQ15VT9T9oaAiV53p9eJ5NjQlk=w36-h36-p-rp-mo-ba5-br100', 'https://www.google.com/maps/contrib/116207372534883155601/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116207372534883155601/reviews');
SET @user_dana_radonjic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116207372534883155601/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladan Micunovic', 'https://lh3.googleusercontent.com/a/ACg8ocImtmVRwpMxjCl728ky-TCy7laEwyNRHZWD_vnsdCDmc7pu-w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103073395299320046037/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103073395299320046037/reviews');
SET @user_vladan_micunovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103073395299320046037/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojan Cg', 'https://lh3.googleusercontent.com/a/ACg8ocJBXDyfkS30LtbV4Xhk3vEQ-ht7p25RVtVKnBUX7uvvTUwKog=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115042540384982276656/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115042540384982276656/reviews');
SET @user_bojan_cg = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115042540384982276656/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'B B', 'https://lh3.googleusercontent.com/a/ACg8ocJ3Aij9SeFnjSKnxn8MXFJ7dWNjcUgHS2PgECTsoYcN7i1dgQ=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/100319568342723236127/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100319568342723236127/reviews');
SET @user_b_b = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100319568342723236127/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ceca Djukic', 'https://lh3.googleusercontent.com/a/ACg8ocIIdaItqM9ecOhOermrv_9XxOr03Oe9OxhCeZEU3nw6p2W_ZlXL=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111043680739571667195/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111043680739571667195/reviews');
SET @user_ceca_djukic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111043680739571667195/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branko Merdovic', 'https://lh3.googleusercontent.com/a/ACg8ocLw7uwPqyMj1utCNtDAlPATlvo3-IClupahX6-7551ls2BX7g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103451984424632455051/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103451984424632455051/reviews');
SET @user_branko_merdovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103451984424632455051/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Budo', 'https://lh3.googleusercontent.com/a-/ALV-UjVbMyu-YEUsF-v_GI2IY0LhgT7AdwcZFevp6YRCLEY70LxtObo=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118171003026180834571/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118171003026180834571/reviews');
SET @user_budo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118171003026180834571/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lidija', 'https://lh3.googleusercontent.com/a-/ALV-UjVgGguHvCpIZB64OUFIz63oZS6V86ggWDTp_5um78x-yH6tg7dU=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109548649900269402182/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109548649900269402182/reviews');
SET @user_lidija = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109548649900269402182/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Srdjan Radovic', 'https://lh3.googleusercontent.com/a-/ALV-UjV-zkU-_y8QigREjlr8wk83i6RCavN0buR91604YytBPwPGijY5=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117083931754171835746/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117083931754171835746/reviews');
SET @user_srdjan_radovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117083931754171835746/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'srlee top', 'https://lh3.googleusercontent.com/a/ACg8ocJHyPVxo8DUbFA2CswJlMFN9cDL47iOvAi12XRHN1hjJpMvGg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113062029352881417372/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113062029352881417372/reviews');
SET @user_srlee_top = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113062029352881417372/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andrea Susic', 'https://lh3.googleusercontent.com/a/ACg8ocLC23ImJwLFvD3rOQNmkSC4kQAYuKC9jxFlk46LkTtGhOEdPA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105418665784839221622/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105418665784839221622/reviews');
SET @user_andrea_susic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105418665784839221622/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'milanudg', 'https://lh3.googleusercontent.com/a/ACg8ocKd1praql48Na0ZhokVbshpbj-J32O7aLzbnRVunGY7k9tCIw=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/107741100352001820435/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107741100352001820435/reviews');
SET @user_milanudg = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107741100352001820435/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'SoI Medun', 'https://lh3.googleusercontent.com/a-/ALV-UjWhRpBtmtimoJ09xAog1MZ8ud07CGyzWPzupVNXIcpzqbwL_GQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117378441628647667945/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117378441628647667945/reviews');
SET @user_soi_medun = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117378441628647667945/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sokrat', 'https://lh3.googleusercontent.com/a-/ALV-UjWthzRfIF0tl0-i1RQfHJFU_fw2__o7tGn07kxNwBrrh36mYGsb=w36-h36-p-rp-mo-ba5-br100', 'https://www.google.com/maps/contrib/110543121254141316273/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110543121254141316273/reviews');
SET @user_sokrat = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110543121254141316273/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_jovana_soskic, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/Ci9DQUlRQUNvZENodHljRjlvT25sMUxWTmpObG80ZHpNd01VZ3haV3hwZFZBeGJWRRAB',
    1, 'hr', 'Najgora klinika u Crnu Goru. Zakazano mi je bilo u 15 i 45, rekla sam da ću prikasniti a oni da će pričekati. Kad sam došla nakon 20 min doktor još uvijek nije stigao a čekaonica je bila puna. Nakon što je stigao čekala sam 40 min da bi mi uklonili jedan konac koji su propustili na prethodnom terminu. Izašla sam samo jer sam vidjela da su još troje smjestili ispred mene i da bih čekala još toliko.Prvi put sam čekala oko 50 min takođe a micanje par konaca je 80e.. Cijena usluga nikako ne odgovara kvalitetu usluga. Ne preporučujem nikako',
    'Najgora klinika u Crnu Goru. Zakazano mi je bilo u 15 i 45, rekla sam da ću prikasniti a oni da će pričekati. Kad sam došla nakon 20 min doktor još uvijek nije stigao a čekaonica je bila puna. Nakon što je stigao čekala sam 40 min da bi mi uklonili jedan konac koji su propustili na prethodnom terminu. Izašla sam samo jer sam vidjela da su još troje smjestili ispred mene i da bih čekala još toliko.Prvi put sam čekala oko 50 min takođe a micanje par konaca je 80e.. Cijena usluga nikako ne odgovara kvalitetu usluga. Ne preporučujem nikako', 'Најгора клиника у Црној Гори. Заказано ми је било у 15 и 45, рекла сам да ћу закаснити а они да ће сачекати. Кад сам дошла након 20 мин доктор још увек није стигао а чекаоница је била пуна. Након што је стигао чекала сам 40 мин да би ми уклонили један конац који су пропустили на претходном термину. Изашла сам само јер сам видела да су још троје сместили испред мене и да бих чекала још толико. Први пут сам чекала око 50 мин такође а скидање пар конаца је 80е.. Цена услуга никако не одговара квалитету услуга. Не препоручујем никако', 'The worst clinic in Montenegro. My appointment was at 15:45, I said I\'d be a bit late and they said they\'d wait. When I arrived after 20 minutes the doctor still hadn\'t shown up and the waiting room was full. After he arrived I waited 40 minutes just to have one stitch removed that they had missed at the previous appointment. I left only because I saw they had placed three more people ahead of me and I would have waited just as long again. The first time I also waited about 50 minutes and removing a couple of stitches costs 80 euros. The price of services in no way matches the quality of services. I do not recommend them at all.', 'Худшая клиника в Черногории. Мне было назначено на 15:45, я сказала, что немного опоздаю, а они сказали, что подождут. Когда я пришла через 20 минут, доктор ещё не появился, а зал ожидания был полон. После его прихода я ждала 40 минут, чтобы мне сняли один шов, который пропустили на предыдущем приёме. Я ушла только потому, что увидела, что ещё троих пропустили вперёд меня и мне пришлось бы ждать ещё столько же. В первый раз я тоже ждала около 50 минут, а снятие пары швов стоит 80 евро. Цена услуг никак не соответствует качеству. Не рекомендую ни в коем случае.', 'Die schlechteste Klinik in Montenegro. Mein Termin war um 15:45 Uhr, ich sagte, dass ich mich etwas verspäten würde, und sie sagten, sie würden warten. Als ich nach 20 Minuten ankam, war der Arzt noch nicht da und das Wartezimmer war voll. Nachdem er angekommen war, wartete ich 40 Minuten, damit man mir einen Faden entfernte, den sie beim vorherigen Termin übersehen hatten. Ich ging nur, weil ich sah, dass sie noch drei weitere Personen vor mir eingereiht hatten und ich genauso lange hätte warten müssen. Beim ersten Mal wartete ich ebenfalls etwa 50 Minuten, und das Entfernen von ein paar Fäden kostet 80 Euro. Der Preis der Leistungen entspricht in keiner Weise der Qualität. Ich empfehle sie auf keinen Fall.', 'Karadağ\'daki en kötü klinik. Randevum 15:45\'teydi, biraz geç kalacağımı söyledim ve onlar da bekleyeceklerini söyledi. 20 dakika sonra geldiğimde doktor hâlâ gelmemişti ve bekleme salonu doluydu. Doktor geldikten sonra, bir önceki randevuda atlanan bir dikişi çıkarmaları için 40 dakika bekledim. Sadece önüme üç kişi daha aldıklarını ve bir o kadar daha bekleyeceğimi görünce çıkıp gittim. İlk seferinde de yaklaşık 50 dakika bekledim ve birkaç dikişin çıkarılması 80 euro tutuyor. Hizmet fiyatları hiçbir şekilde hizmet kalitesiyle örtüşmüyor. Kesinlikle tavsiye etmiyorum.',
    0, '2026-02-24 00:00:00'),

(@user_natasha_knezevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/Ci9DQUlRQUNvZENodHljRjlvT214aFkzbGxXbkJCVVZBNVVXZ3dVMUJzYTBGTU4xRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-02-24 00:00:00'),

(@user_ivan_bijelic, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/Ci9DQUlRQUNvZENodHljRjlvT21SeVdsbzVVbEo2Um1OdlEyVkhSVzlVYVRSb2VrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-24 00:00:00'),

(@user_mina_nurkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChZDSUhNMG9nS0VMM0gtczZBbmRhSGZREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-06-24 00:00:00'),

(@user_danijela_prelevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChZDSUhNMG9nS0VQTHBvTUxxMlBqdlFnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-06-24 00:00:00'),

(@user_danijela_raspopovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChZDSUhNMG9nS0VJQ0FnTUNneTRmcUtBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_ksenija_mijuskovic, @clinic_id, @doctor_katarina_mitrovic, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChZDSUhNMG9nS0VJQ0FnTUNnazZ2NElnEAE',
    1, 'hr', 'Izuzetno neodgovoran pristup pacijentu!
Dr Katarina kasnila 25 minuta, poslije cega sam odustala od pregleda!',
    'Izuzetno neodgovoran pristup pacijentu!
Dr Katarina kasnila 25 minuta, poslije cega sam odustala od pregleda!', 'Изузетно неодговоран приступ пацијенту!
Др Катарина каснила 25 минута, после чега сам одустала од прегледа!', 'Extremely irresponsible approach to patients!
Dr Katarina was 25 minutes late, after which I gave up on the appointment!', 'Крайне безответственный подход к пациенту!
Др Катарина опоздала на 25 минут, после чего я отказалась от приёма!', 'Äußerst unverantwortlicher Umgang mit Patienten!
Dr. Katarina kam 25 Minuten zu spät, woraufhin ich die Untersuchung abgebrochen habe!', 'Son derece sorumsuz bir hasta yaklaşımı!
Dr Katarina 25 dakika geç kaldı, bunun üzerine muayeneden vazgeçtim!',
    0, '2025-03-24 00:00:00'),

(@user_vasilije, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChdDSUhNMG9nS0VJQ0FnTUNBdi1UcW53RRAB',
    5, 'bs', 'Prva klinika Estetske hirurgije u Crnoj Gori . Imaju ljekare svih specijalnosti .
Ljubaznos osoblja , stručnost lekara i tehničkog osoblja na vrlo visokom nivou . Higijena prostorija klinike bezprekorna . Cijene povojne  za svakoga . Toplo preporučujem . Najbolji su !',
    'Prva klinika Estetske hirurgije u Crnoj Gori . Imaju ljekare svih specijalnosti .
Ljubaznos osoblja , stručnost lekara i tehničkog osoblja na vrlo visokom nivou . Higijena prostorija klinike bezprekorna . Cijene povojne  za svakoga . Toplo preporučujem . Najbolji su !', 'Прва клиника Естетске хирургије у Црној Гори. Имају лекаре свих специјалности.
Љубазност особља, стручност лекара и техничког особља на врло високом нивоу. Хигијена просторија клинике беспрекорна. Цене приступачне за свакога. Топло препоручујем. Најближи су!', 'The first Aesthetic Surgery clinic in Montenegro. They have doctors of all specialties.
The kindness of the staff, the expertise of the doctors and technical personnel are at a very high level. The hygiene of the clinic premises is impeccable. Prices are affordable for everyone. Highly recommended. They are the best!', 'Первая клиника Эстетической хирургии в Черногории. У них есть врачи всех специальностей.
Любезность персонала, профессионализм врачей и технического персонала на очень высоком уровне. Гигиена помещений клиники безупречна. Цены доступные для всех. Горячо рекомендую. Они лучшие!', 'Die erste Klinik für Ästhetische Chirurgie in Montenegro. Sie haben Ärzte aller Fachrichtungen.
Die Freundlichkeit des Personals, die Fachkompetenz der Ärzte und des technischen Personals sind auf einem sehr hohen Niveau. Die Hygiene der Klinikräume ist makellos. Die Preise sind für jeden erschwinglich. Ich empfehle sie wärmstens. Sie sind die Besten!', 'Karadağ\'daki ilk Estetik Cerrahi kliniği. Her uzmanlıktan doktorları var.
Personelin nezaketi, doktorların ve teknik personelin uzmanlığı çok yüksek düzeyde. Klinik odalarının hijyeni kusursuz. Fiyatlar herkes için uygun. Şiddetle tavsiye ederim. En iyileri onlar!',
    0, '2025-03-24 00:00:00'),

(@user_ana_sarcevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChZDSUhNMG9nS0VJQ0FnSUN2bktidGV3EAE',
    1, 'bs', 'Najgora klinika na svijetu , neodgovornost svw najgore za kompletnu kliniku , na zalost imala sam intervenciju kod njih , nikada nikome ne bih preporucila ovu kliniku , seste su uzasno neljubazne  , kontrolu nisam mogla da zakazem kod njih jer svaki put kad bih zvala receno mi je javicemo vam kad nam se doktor javi a to je nikad . Uzassssssssssss',
    'Najgora klinika na svijetu , neodgovornost svw najgore za kompletnu kliniku , na zalost imala sam intervenciju kod njih , nikada nikome ne bih preporucila ovu kliniku , seste su uzasno neljubazne  , kontrolu nisam mogla da zakazem kod njih jer svaki put kad bih zvala receno mi je javicemo vam kad nam se doktor javi a to je nikad . Uzassssssssssss', 'Најгора клиника на свету, неодговорност свега најгоре за комплетну клинику, на жалост имала сам интервенцију код њих, никада никоме не бих препоручила ову клинику, сестре су ужасно нељубазне, контролу нисам могла да закажем код њих јер сваки пут кад бих звала речено ми је јавићемо вам кад нам се доктор јави а то је никад. Узаssssssssssss', 'The worst clinic in the world, the irresponsibility of everything is worst for the whole clinic, unfortunately I had a procedure with them, I would never recommend this clinic to anyone, the nurses are terribly unfriendly, I couldn\'t make a follow-up appointment because every time I called I was told we\'ll get back to you when the doctor gets back to us — which is never. Horrifyinggggggggg', 'Худшая клиника в мире, безответственность всего и вся — худшее во всей клинике, к сожалению, у меня была процедура у них, я никогда никому не порекомендую эту клинику, медсёстры ужасно невежливые, я не могла записаться на контрольный осмотр, потому что каждый раз, когда я звонила, мне говорили: мы вам перезвоним, когда нам ответит доктор — а это никогда. Ужаасссссссссс', 'Die schlechteste Klinik der Welt, die Unverantwortlichkeit von allem ist das Schlimmste an der gesamten Klinik, leider hatte ich einen Eingriff bei ihnen, ich würde diese Klinik niemandem empfehlen, die Schwestern sind schrecklich unfreundlich, ich konnte keinen Kontrolltermin vereinbaren, weil mir jedes Mal, wenn ich anrief, gesagt wurde: wir melden uns, wenn sich der Arzt bei uns meldet — was niemals passiert. Entsetzlichhhhhhhhhh', 'Dünyanın en kötü kliniği, her şeyin sorumsuzluğu tüm klinik için en kötüsü, maalesef orada bir müdahale geçirdim, bu kliniği hiç kimseye tavsiye etmezdim, hemşireler inanılmaz derecede kaba, takip randevusu alamadım çünkü her aradığımda bana doktor bize geri döndüğünde sizi arayacağız denildi — ki bu hiç olmadı. Dehşeeeeeeeeeeet',
    0, '2025-03-24 00:00:00'),

(@user_luoyan, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChdDSUhNMG9nS0VJQ0FnSURYeDVPRzFnRRAB',
    1, 'en', 'This is literally the WORST clinic I\'ve been to in Podgorica. They answer fast, but this is literally their only advantage. Doctors are totally uninterested in patients, interventions are painful, you are not given any anesthesia, and when you come for the second appointment you are told the nurse or the doctor is not here, and you have to wait at least an hour or probably more! Never go here if you have a choice.',
    'Ovo je bukvalno NAJGORA klinika u kojoj sam bila u Podgorici. Brzo odgovaraju na pozive, ali to je bukvalno jedina njihova prednost. Doktori su potpuno nezainteresovani za pacijente, intervencije su bolne, ne daju vam nikakvu anesteziju, a kad dođete na drugi termin kažu vam da medicinska sestra ili doktor nisu tu i morate čekati najmanje sat vremena ili verovatno više! Nikada ne idite ovde ako imate izbora.', 'Ово је буквално НАЈГОРА клиника у којој сам била у Подгорици. Брзо одговарају на позиве, али то је буквално једина њихова предност. Доктори су потпуно незаинтересовани за пацијенте, интервенције су болне, не дају вам никакву анестезију, а кад дођете на други термин кажу вам да медицинска сестра или доктор нису ту и морате чекати најмање сат времена или вероватно више! Никада не идите овде ако имате избора.', 'This is literally the WORST clinic I\'ve been to in Podgorica. They answer fast, but this is literally their only advantage. Doctors are totally uninterested in patients, interventions are painful, you are not given any anesthesia, and when you come for the second appointment you are told the nurse or the doctor is not here, and you have to wait at least an hour or probably more! Never go here if you have a choice.', 'Это буквально ХУДШАЯ клиника, в которой я была в Подгорице. Они быстро отвечают на звонки, но это буквально их единственное преимущество. Врачи совершенно не интересуются пациентами, процедуры болезненны, вам не дают никакой анестезии, а когда вы приходите на второй приём, вам говорят, что медсестры или врача нет на месте, и приходится ждать не менее часа, а то и больше! Никогда не ходите сюда, если у вас есть выбор.', 'Das ist buchstäblich die SCHLECHTESTE Klinik, die ich in Podgorica besucht habe. Sie antworten schnell, aber das ist buchstäblich ihr einziger Vorteil. Die Ärzte sind völlig desinteressiert an den Patienten, die Eingriffe sind schmerzhaft, es wird keine Anästhesie gegeben, und wenn man zum zweiten Termin kommt, wird man informiert, dass die Krankenschwester oder der Arzt nicht da ist, und man muss mindestens eine Stunde oder wahrscheinlich noch länger warten! Gehen Sie hier niemals hin, wenn Sie die Wahl haben.', 'Bu, Podgorica\'da gittiğim kelimenin tam anlamıyla EN KÖTÜ klinik. Hızlı cevap veriyorlar ama bu kelimenin tam anlamıyla tek avantajları. Doktorlar hastalarla tamamen ilgisiz, müdahaleler acı verici, hiç anestezi yapılmıyor ve ikinci randevuya geldiğinizde hemşire ya da doktorun orada olmadığı söyleniyor, en az bir saat ya da daha fazla beklemeniz gerekiyor! Seçeneğiniz varsa buraya asla gitmeyin.',
    0, '2025-03-24 00:00:00'),

(@user_fil_samsung, @clinic_id, @doctor_zoran_terzic, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChdDSUhNMG9nS0VJQ0FnSUNYNkp6RC13RRAB',
    5, 'bs', 'Moji utisci. Svaki put kada sam ih zvao, odmah su se javili i dali mi tačne informacije. Ekipa uljudna. Dr Terzić blag i profesionalan. Čekao sam 15 minuta. Posao završen u roku od 20-30 minuta. Platio 200 evra. Što se mene tiče, preporučiću ih drugima.',
    'Moji utisci. Svaki put kada sam ih zvao, odmah su se javili i dali mi tačne informacije. Ekipa uljudna. Dr Terzić blag i profesionalan. Čekao sam 15 minuta. Posao završen u roku od 20-30 minuta. Platio 200 evra. Što se mene tiče, preporučiću ih drugima.', 'Моји утисци. Сваки пут када сам их звао, одмах су се јавили и дали ми тачне информације. Екипа уљудна. Др Терзић благ и професионалан. Чекао сам 15 минута. Посао завршен у року од 20-30 минута. Платио 200 евра. Што се мене тиче, препоручићу их другима.', 'My impressions. Every time I called them, they answered immediately and gave me accurate information. The team is polite. Dr Terzić is gentle and professional. I waited 15 minutes. The job was done within 20-30 minutes. I paid 200 euros. As far as I\'m concerned, I will recommend them to others.', 'Мои впечатления. Каждый раз, когда я им звонил, они сразу отвечали и давали точную информацию. Команда вежливая. Др Терзич мягкий и профессиональный. Ждал 15 минут. Работа выполнена за 20-30 минут. Заплатил 200 евро. Что касается меня, я порекомендую их другим.', 'Meine Eindrücke. Jedes Mal, wenn ich sie angerufen habe, haben sie sofort abgehoben und mir genaue Informationen gegeben. Das Team ist höflich. Dr. Terzić ist sanft und professionell. Ich wartete 15 Minuten. Die Arbeit wurde innerhalb von 20-30 Minuten erledigt. Ich habe 200 Euro bezahlt. Was mich betrifft, werde ich sie anderen empfehlen.', 'İzlenimlerim. Her aradığımda hemen cevap verdiler ve doğru bilgi verdiler. Ekip kibardı. Dr Terzić nazik ve profesioneldi. 15 dakika bekledim. İş 20-30 dakika içinde tamamlandı. 200 euro ödedim. Benim açımdan, onları başkalarına tavsiye edeceğim.',
    0, '2025-03-24 00:00:00'),

(@user_valentina_minic, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChZDSUhNMG9nS0VJQ0FnSURqOHBiVER3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_nikola_radulovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChdDSUhNMG9nS0VJQ0FnSUNseXVmS2hBRRAB',
    4, 'bs', 'Profesionalni i tačni još da si cijene malo manje bilo bi 5 zvjezdica',
    'Profesionalni i tačni još da si cijene malo manje bilo bi 5 zvjezdica', 'Професионални и тачни, још да су цене мало мање било би 5 звездица', 'Professional and punctual, if only the prices were a little lower it would be 5 stars', 'Профессиональные и пунктуальные, если бы цены были чуть ниже — было бы 5 звёзд', 'Professionell und pünktlich, wenn die Preise nur etwas niedriger wären, würde ich 5 Sterne geben', 'Profesyonel ve dakik, fiyatlar biraz daha düşük olsaydı 5 yıldız olurdu',
    0, '2024-03-24 00:00:00'),

(@user_dana_radonjic, @clinic_id, @doctor_katarina_mitrovic, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChZDSUhNMG9nS0VJQ0FnSUNKMklTWVR3EAE',
    4, 'bs', 'Ovo mjesto je preskupo ,nadam se da je opravdanje to sto ovdje ordiniraju strucni ljekari..Za druge doktore ne znam,ali bih pohvalila mladu Dr.Katarinu Raspopovic.Njeno znanje,strucnost i pristup treba da su primjer svim njenim kolegama.Izuzetno prijatna i ljubazna.',
    'Ovo mjesto je preskupo ,nadam se da je opravdanje to sto ovdje ordiniraju strucni ljekari..Za druge doktore ne znam,ali bih pohvalila mladu Dr.Katarinu Raspopovic.Njeno znanje,strucnost i pristup treba da su primjer svim njenim kolegama.Izuzetno prijatna i ljubazna.', 'Ово место је прескупо, надам се да је оправдање то што овде ординирају стручни лекари. За друге докторе не знам, али бих похвалила младу Др. Катарину Распоповић. Њено знање, стручност и приступ треба да су пример свим њеним колегама. Изузетно пријатна и љубазна.', 'This place is too expensive, I hope the justification is that qualified doctors practice here. I can\'t speak for other doctors, but I would like to praise the young Dr. Katarina Raspopović. Her knowledge, expertise and approach should be an example to all her colleagues. Extremely pleasant and kind.', 'Это место слишком дорогое, надеюсь, оправданием служит то, что здесь практикуют квалифицированные врачи. За других врачей не скажу, но хотела бы похвалить молодого Доктора Катарину Распопович. Её знания, профессионализм и подход должны быть примером для всех её коллег. Исключительно приятная и любезная.', 'Dieser Ort ist zu teuer, ich hoffe, die Rechtfertigung ist, dass hier qualifizierte Ärzte praktizieren. Über andere Ärzte kann ich nichts sagen, aber ich möchte die junge Dr. Katarina Raspopović loben. Ihr Wissen, ihre Fachkompetenz und ihr Umgang sollten ein Vorbild für alle ihre Kollegen sein. Äußerst angenehm und freundlich.', 'Bu yer çok pahalı, umarım bunun gerekçesi burada uzman doktorların çalışmasıdır. Diğer doktorlar hakkında bilmiyorum, ama genç Dr. Katarina Raspopović\'i övmek isterim. Bilgisi, uzmanlığı ve yaklaşımı tüm meslektaşlarına örnek olmalı. Son derece hoş ve nazik.',
    0, '2024-03-24 00:00:00'),

(@user_vladan_micunovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChdDSUhNMG9nS0VJQ0FnSUNCcTczam9RRRAB',
    1, 'bs', 'Usluga 0 na pregled hirurga cekali smo 1 h vremena sto je ispod nivo svih nerazvijenih drzava , a cijene astronomske , strucnost doktora takodje upitna stvarno nikome ne bih preporucio ovu kliniku',
    'Usluga 0 na pregled hirurga cekali smo 1 h vremena sto je ispod nivo svih nerazvijenih drzava , a cijene astronomske , strucnost doktora takodje upitna stvarno nikome ne bih preporucio ovu kliniku', 'Услуга 0, на преглед хирурга чекали смо 1 х времена што је испод нивоа свих неразвијених држава, а цене астрономске, стручност доктора такође упитна, стварно никоме не бих препоручио ову клинику', 'Service 0, we waited 1 hour to see the surgeon which is below the standard of all underdeveloped countries, the prices are astronomical, the competence of the doctors is also questionable, I truly would not recommend this clinic to anyone', 'Сервис 0, на осмотр хирурга мы ждали 1 час, что ниже уровня всех слаборазвитых стран, цены астрономические, профессионализм врачей тоже под вопросом, я действительно никому не порекомендую эту клинику', 'Service 0, wir warteten 1 Stunde auf eine Untersuchung beim Chirurgen, was unter dem Niveau aller Entwicklungsländer liegt, die Preise sind astronomisch, die Kompetenz der Ärzte ist ebenfalls fraglich, ich würde diese Klinik wirklich niemandem empfehlen', 'Hizmet 0, cerrahı görmek için 1 saat bekledik ki bu tüm az gelişmiş ülkelerin altında bir standart, fiyatlar astronomik, doktorların yetkinliği de şüpheli, bu kliniği gerçekten hiç kimseye tavsiye etmezdim',
    0, '2023-03-24 00:00:00'),

(@user_bojan_cg, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChZDSUhNMG9nS0VJQ0FnSUNCdXBQdlBBEAE',
    1, 'hr', 'Usluga i ljubaznost ispod nivoa najgorih državnih ambulanti. Ukoliko želite da čekate u redu, kao i u KBCu, a da masno platite, onda slobodno odaberite ovu nazovi kliniku. Morate da čekate, je jedino što je izustila neljubazna persona u vidu medicinske sestre, nakon pola sata čekanja,uz dodatak da stvarno ne zna koliko ćemo morati još čekati. Sve ono što je kod njih trebalo da košta veoma pareno, završeno je u drugoj ordinaciji za 0 eura. A mnogo važnije od cijene je čekanje od 0 minuta u odnosu na dogovoreni termin, krajnje ljubazan i profesionalan odnos svih zaposlenih.',
    'Usluga i ljubaznost ispod nivoa najgorih državnih ambulanti. Ukoliko želite da čekate u redu, kao i u KBCu, a da masno platite, onda slobodno odaberite ovu nazovi kliniku. Morate da čekate, je jedino što je izustila neljubazna persona u vidu medicinske sestre, nakon pola sata čekanja,uz dodatak da stvarno ne zna koliko ćemo morati još čekati. Sve ono što je kod njih trebalo da košta veoma pareno, završeno je u drugoj ordinaciji za 0 eura. A mnogo važnije od cijene je čekanje od 0 minuta u odnosu na dogovoreni termin, krajnje ljubazan i profesionalan odnos svih zaposlenih.', 'Услуга и љубазност испод нивоа најгорих државних амбуланти. Уколико желите да чекате у реду, као и у КБЦ-у, а да масно платите, онда слободно одаберите ову такозвану клинику. Морате да чекате — jedино što је изустила нељубазна персона у виду медицинске сестре, након пола сата чекања, уз додатак да стварно не зна колико ћемо морати још чекати. Све оно što је код њих требало да кошта веома скупо, завршено је у другој ординацији за 0 евра. А много важније од цене је чекање од 0 минута у односу на договорени термин, крајње љубазан и професионалан однос свих запослених.', 'Service and friendliness below the level of the worst public clinics. If you want to stand in a queue just like at a public hospital and pay through the nose for it, then feel free to choose this so-called clinic. You have to wait — that was the only thing the unfriendly persona in the form of a nurse managed to say after half an hour of waiting, adding that she truly doesn\'t know how much longer we\'ll have to wait. Everything that was supposed to cost a lot here was done at another practice for 0 euros. And much more important than the price is a 0-minute wait compared to the agreed appointment time, and an extremely friendly and professional attitude from all staff.', 'Сервис и любезность ниже уровня худших государственных поликлиник. Если вы хотите стоять в очереди, как в государственной больнице, и при этом дорого платить — смело выбирайте эту так называемую клинику. Вы обязаны ждать — единственное, что выдавила из себя недружелюбная особа в виде медсестры после получасового ожидания, добавив, что она действительно не знает, сколько ещё нам придётся ждать. Всё то, что у них должно было стоить очень дорого, было сделано в другом кабинете за 0 евро. А гораздо важнее цены — ожидание 0 минут относительно договорённого времени и крайне любезное и профессиональное отношение всех сотрудников.', 'Service und Freundlichkeit unter dem Niveau der schlechtesten staatlichen Ambulanzen. Wenn Sie in einer Schlange warten wollen wie in einer Universitätsklinik und dafür noch viel bezahlen, dann wählen Sie ruhig diese sogenannte Klinik. Sie müssen warten — das war das Einzige, was die unfreundliche Person in Gestalt einer Krankenschwester nach einer halben Stunde Warten herausbrachte, mit dem Zusatz, dass sie wirklich nicht weiß, wie lange wir noch warten müssen. Alles, was bei ihnen sehr teuer sein sollte, wurde in einer anderen Praxis für 0 Euro erledigt. Und viel wichtiger als der Preis ist eine Wartezeit von 0 Minuten im Vergleich zum vereinbarten Termin und ein äußerst freundlicher und professioneller Umgang aller Mitarbeiter.', 'Hizmet ve nezaket, en kötü devlet kliniklerinin bile altında. Bir devlet hastanesinde olduğu gibi sıraya girmek ve bunun için bol para ödemek istiyorsanız, bu sözde kliniği seçmekte özgürsünüz. Beklemek zorundasınız — bu, yarım saat bekledikten sonra hemşire kılığındaki sevimsiz kişinin söyleyebildiği tek şeydi; üstelik ne kadar daha beklememiz gerektiğini gerçekten bilmediğini de ekledi. Onlarda çok pahalıya mal olması gereken her şey, başka bir muayehanede 0 euroya yapıldı. Ve fiyattan çok daha önemli olan şey, belirlenen randevu saatine kıyasla 0 dakika bekleme süresi ve tüm çalışanların son derece nazik ve profesyonel tutumudur.',
    0, '2023-03-24 00:00:00'),

(@user_b_b, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChZDSUhNMG9nS0VJQ0FnSUN1cWViN093EAE',
    1, 'bs', 'Zgrozena činom da su n.n osobi dali podatke šta sam i koliko radila u njihovoj klinici . Mislim da ne treba dalje',
    'Zgrozena činom da su n.n osobi dali podatke šta sam i koliko radila u njihovoj klinici . Mislim da ne treba dalje', 'Згрожена чином да су непознатој особи дали податке шта сам и колико радила у њиховој клиници. Мислим да не треба даље', 'Disgusted by the fact that they gave an unknown person information about what procedures I had and how many I had done at their clinic. I think that says enough.', 'Возмущена тем, что они передали неизвестному лицу данные о том, что и сколько раз я делала в их клинике. Думаю, дальше объяснять не нужно.', 'Entsetzt darüber, dass sie einer unbekannten Person mitgeteilt haben, was ich und wie viel ich in ihrer Klinik gemacht habe. Ich glaube, das sagt alles.', 'Kliniklerinde ne yaptığım ve ne kadar yaptığım hakkındaki bilgileri kimliği belirsiz bir kişiye verdiklerinden dolayı iğrendim. Sanırım daha fazlasını söylemeye gerek yok.',
    0, '2023-03-24 00:00:00'),

(@user_ceca_djukic, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChZDSUhNMG9nS0VJQ0FnSURXdDdUc0xREAE',
    5, 'bs', 'Dr Fatic izuzetno strucan, steta sto nemamo vise takvih doktora, sestra Jovana prijatna i uvek spremna da pacijentim izadje u susret.',
    'Dr Fatic izuzetno strucan, steta sto nemamo vise takvih doktora, sestra Jovana prijatna i uvek spremna da pacijentim izadje u susret.', 'Др Фатић изузетно стручан, штета што немамо више таквих доктора, сестра Јована пријатна и увек спремна да пацијентима изађе у сусрет.', 'Dr Fatić is extremely skilled, it\'s a shame we don\'t have more doctors like him, nurse Jovana is pleasant and always ready to accommodate patients.', 'Др Фатич исключительно профессионален, жаль, что у нас нет больше таких врачей, медсестра Йована приятная и всегда готова пойти навстречу пациентам.', 'Dr. Fatić ist äußerst kompetent, schade, dass wir nicht mehr solche Ärzte haben, Schwester Jovana ist angenehm und immer bereit, den Patienten entgegenzukommen.', 'Dr Fatić son derece yetenekli, bu kadar az böyle doktorumuz olması ne yazık ki, hemşire Jovana hoş biri ve her zaman hastalara yardımcı olmaya hazır.',
    0, '2023-03-24 00:00:00'),

(@user_branko_merdovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChZDSUhNMG9nS0VJQ0FnSURHcXFIbVJBEAE',
    1, 'bs', 'Izuzetno negativno iskustvo, pocevsi od doktora specijaliste koji je bio jako arogantan, pa tako i ostatak pomocnog osoblja koji, u najmanju ruku, nisu bili ni od kakve pomoci niti koristi.',
    'Izuzetno negativno iskustvo, pocevsi od doktora specijaliste koji je bio jako arogantan, pa tako i ostatak pomocnog osoblja koji, u najmanju ruku, nisu bili ni od kakve pomoci niti koristi.', 'Изузетно негативно искуство, почевши од доктора специјалисте који је био јако арогантан, па тако и остатак помоћног особља који, у најмању руку, нису били ни од какве помоћи нити користи.', 'Extremely negative experience, starting with the specialist doctor who was very arrogant, and likewise the rest of the support staff who were, to say the least, of no help or use whatsoever.', 'Крайне негативный опыт, начиная с врача-специалиста, который был очень высокомерным, и так же остальной вспомогательный персонал, который, мягко говоря, не был ни в чём полезен.', 'Äußerst negative Erfahrung, angefangen beim Facharzt, der sehr arrogant war, sowie dem restlichen Hilfspersonal, das, gelinde gesagt, keinerlei Hilfe oder Nutzen war.', 'Son derece olumsuz bir deneyim, çok kibirli olan uzman doktordan başlayarak, en hafif ifadeyle hiçbir yardımı veya faydası olmayan destek personelinin geri kalanına kadar.',
    0, '2022-03-24 00:00:00'),

(@user_budo, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ2LTRYY09BEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-24 00:00:00'),

(@user_lidija, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2Nl9MNnVBRRAB',
    1, 'bs', 'Cirkus a ne klinika.Sramota na koji način funkcioniše jedna zdravstvena ustanova.',
    'Cirkus a ne klinika.Sramota na koji način funkcioniše jedna zdravstvena ustanova.', 'Циркус а не клиника. Срамота на који начин функционише једна здравствена установа.', 'A circus, not a clinic. It\'s a shame how a healthcare institution can function this way.', 'Цирк, а не клиника. Позор, что медицинское учреждение может так работать.', 'Ein Zirkus, keine Klinik. Eine Schande, wie eine Gesundheitseinrichtung funktionieren kann.', 'Klinik değil sirk. Bir sağlık kurumunun bu şekilde işlemesi utanç verici.',
    0, '2022-03-24 00:00:00'),

(@user_srdjan_radovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChZDSUhNMG9nS0VJQ0FnSUM2Z3BTcEZBEAE',
    1, 'hr', 'Preskupi, arogantne sestre, tranjav ambijent... Zaobicu ih drugi put.',
    'Preskupi, arogantne sestre, tranjav ambijent... Zaobicu ih drugi put.', 'Прескупи, арогантне сестре, запуштен амбијент... Заобићу их други пут.', 'Too expensive, arrogant nurses, shabby atmosphere... I\'ll avoid them next time.', 'Слишком дорого, высокомерные медсёстры, запущенная атмосфера... В следующий раз обойду стороной.', 'Zu teuer, arrogante Schwestern, schäbige Atmosphäre... Ich werde sie beim nächsten Mal meiden.', 'Çok pahalı, kibirli hemşireler, bakımsız ortam... Bir dahaki sefere onları atlayacağım.',
    0, '2022-03-24 00:00:00'),

(@user_srlee_top, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChdDSUhNMG9nS0VJQ0FnSURjb3VlYzZnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-03-24 00:00:00'),

(@user_andrea_susic, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChZDSUhNMG9nS0VJQ0FnSUMwb0thaEJnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-03-24 00:00:00'),

(@user_milanudg, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChdDSUhNMG9nS0VJQ0FnSUNnMGJLem5nRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-03-24 00:00:00'),

(@user_soi_medun, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChZDSUhNMG9nS0VJQ0FnSUNnNEtMQkpBEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-03-24 00:00:00'),

(@user_sokrat, @clinic_id, NULL, 'google_maps',
    'places/ChIJo4WevlXrTRMR0YZi_iBQNAE/reviews/ChZDSUhNMG9nS0VJQ0FnSUNRdktUamJnEAE',
    5, 'bs', 'Red, rad  i  disciplina. Zadovoljan kao klijent u svim oblastima pruzanja
zdravstvene usluge ! Preporucujem ih svima !',
    'Red, rad  i  disciplina. Zadovoljan kao klijent u svim oblastima pruzanja
zdravstvene usluge ! Preporucujem ih svima !', 'Ред, рад и дисциплина. Задовољан као клијент у свим областима пружања
здравствене услуге! Препоручујем их свима!', 'Order, work and discipline. Satisfied as a client in all areas of healthcare service! I recommend them to everyone!', 'Порядок, труд и дисциплина. Доволен как клиент во всех сферах оказания медицинских услуг! Рекомендую всем!', 'Ordnung, Arbeit und Disziplin. Als Kunde in allen Bereichen der Gesundheitsversorgung zufrieden! Ich empfehle sie allen!', 'Düzen, çalışma ve disiplin. Sağlık hizmetinin tüm alanlarında müşteri olarak memnunum! Herkese tavsiye ederim!',
    0, '2018-03-24 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
