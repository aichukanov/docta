-- Insert Google Maps reviews for ORDINACIJA DR KALUDJEROVIC
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/ordinacija-dr-kaludjerovic-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'ordinacija-dr-kaludjerovic-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_velimir_kaludjerovic = (SELECT id FROM doctors WHERE slug = 'velimir-kaludjerovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sladjana Bojovic', 'https://lh3.googleusercontent.com/a/ACg8ocKUtOgiNtuxVIKfzpmTUNXVO8Odd_g6jlKbM4f-3whkNbt-YQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/116000805055449478178/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116000805055449478178/reviews');
SET @user_sladjana_bojovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116000805055449478178/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danica Lakovic', 'https://lh3.googleusercontent.com/a-/ALV-UjU0Bt0tslA4lrd5BkM3OYcQW0iuyGkGx-GAYS2rNwRWsqjL5kCX=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/115832946232335567923/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115832946232335567923/reviews');
SET @user_danica_lakovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115832946232335567923/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Victoria Dalas', 'https://lh3.googleusercontent.com/a/ACg8ocISSCmiGUVoXtYaZy4NjW7sxHMzne-kRPy9iCSQxgWyTxumxQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/117935432479137866479/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117935432479137866479/reviews');
SET @user_victoria_dalas = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117935432479137866479/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jevto Bojovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXrjV0lgLVowNSL9NMUZhP9PcoK35z197nyQ4b8IgiR48MGyfob=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/108997651406846367221/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108997651406846367221/reviews');
SET @user_jevto_bojovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108997651406846367221/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Filip Marinovic', 'https://lh3.googleusercontent.com/a/ACg8ocKt4eCLdyjiK3mijqR2VeQyVQPqpe8bzQ-tK4PkL5LCe7wOJA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/109058282442959674817/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109058282442959674817/reviews');
SET @user_filip_marinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109058282442959674817/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ja sam sigurno', 'https://lh3.googleusercontent.com/a/ACg8ocJOO2RX_jTfgVqofzRJyRVjWYcX_bKeNPLiYERpz3r5VtOkvg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108528657337220746256/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108528657337220746256/reviews');
SET @user_ja_sam_sigurno = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108528657337220746256/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lazar B', 'https://lh3.googleusercontent.com/a/ACg8ocJYVWTsxjtm6rkTyFu5TPylbVhkM-e1jq9PyDcCdzlymU9vkA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104164820631791787531/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104164820631791787531/reviews');
SET @user_lazar_b = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104164820631791787531/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lazar Malisic', 'https://lh3.googleusercontent.com/a-/ALV-UjWZA1i-klHQjyQO4by_V8npVYiHcgoHuAYfpydSNuO238AyqSprMA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106441150863903585184/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106441150863903585184/reviews');
SET @user_lazar_malisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106441150863903585184/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Michael Danuschenkov', 'https://lh3.googleusercontent.com/a-/ALV-UjVOEujL39RN5CIupvzcoe2MdN4wHSbF4O9jCT5sPcZELf7L96Au=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109717591139024767071/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109717591139024767071/reviews');
SET @user_michael_danuschenkov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109717591139024767071/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dzemil Corovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUDuJZcRrZtY1_mSopF3Jwq4ITf4ED0t6NLEGy_AD2SaShQ15JZ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109645089914642096370/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109645089914642096370/reviews');
SET @user_dzemil_corovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109645089914642096370/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Kaljevic', 'https://lh3.googleusercontent.com/a/ACg8ocLvNnt6-GO02dVuxw3KhVuWy1HFMkWnZBRh5NJHFXBAoTB0rA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117141572069049658668/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117141572069049658668/reviews');
SET @user_ivan_kaljevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117141572069049658668/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dajana Vukic', 'https://lh3.googleusercontent.com/a-/ALV-UjXqykV4KmAqXGJRr4MbBNHPXUGDrvgEhFB3pFAiCaDlYk7ImX0f-g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113237976494587550871/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113237976494587550871/reviews');
SET @user_dajana_vukic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113237976494587550871/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Никола Томашевић', 'https://lh3.googleusercontent.com/a/ACg8ocKpeT93QkX-slTaSv8AUrXF_mdghj4uXuYT7b40BmMujYug8g=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102579132200969349534/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102579132200969349534/reviews');
SET @user_nikola_tomashevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102579132200969349534/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_sladjana_bojovic, @clinic_id, @doctor_velimir_kaludjerovic, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5VE1HWlljMnBrUlVONVpYcHFVVzFNVTBoUWVWRRAB',
    5, 'bs', 'Sve pohvale za dr Kaludejrovica,posle tri ipo mjeseca lutanja od dr do dr konacno ljekar na prvi pogled nasao dijagnozu..uz veliki zahvalnost njemu..u pitanju je bilo posl operacije spoljna infekcija dje je dr Štilet tvrdioo da je nedje i najgore na ruci..sto je dr Kaludjerovic odmah od oka znao sta je..VELIKO HVALAA NA LJUBAZNOSTI I VELIKM ZNANJU I VELIKM PRIJE SVEGA COVJEKU I NAJBOLJI DERMATOLOG',
    'Sve pohvale za dr Kaludejrovića, posle tri i po meseca lutanja od lekara do lekara, doktor je konačno na prvi pogled našao dijagnozu..sa velikom zahvalnošću prema njemu..to je bila spoljna infekcija posle operacije gde je dr Štilet tvrdio da je negde i da je najgore bilo na ruci..da je dr Kaluđerović odmah znao. VAŠA LjUBAZNOST I VELIKO ZNANjE I PRE SVEGA ČOVEKU I NAJBOLjEM DERMATOLOGU', 'Све похвале за др Калудејровића, после три и по месеца лутања од лекара до лекара, доктор је коначно на први поглед нашао дијагнозу..са великом захвалношћу према њему..то је била спољна инфекција после операције где је др Штилет тврдио да је негде и да је најгоре било на руци..да је др Калуђеровић одмах знао. ВАША ЉУБАЗНОСТ И ВЕЛИКО ЗНАЊЕ И ПРЕ СВЕГА ЧОВЕКУ И НАЈБОЉЕМ ДЕРМАТОЛОГУ', NULL, NULL, NULL, NULL,
    1, '2025-11-22 10:09:13'),

(@user_danica_lakovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCSVJHSkJPRWswUWtoTVJqWkdaMHR4WWpRMGVGRRAB',
    1, 'bs', 'Nažalost, moje iskustvo sa ovom ordinacijom je krajnje razočaravajuće. Od samog dolaska, bilo je jasno da profesionalizam nije prioritet. Pregled nije obavljen u ordinaciji, već u hodniku, bez ikakve privatnosti i osnovne medicinske etike.

Ljekar se tokom pregleda obraćao isključivo osobi koja je bila sa mnom, a ne meni kao pacijentu. Pritom je razgovor bio o temama koje nemaju nikakve veze sa mojim zdravstvenim stanjem, što je dodatno pojačalo osjećaj nepoštovanja i nesigurnosti.

Najveći problem je što je dijagnoza postavljena bez detaljnog pregleda i bez ikakvih dodatnih analiza, djelovalo je kao puko nagađanje. Takav pristup može biti i opasan, posebno kada su u pitanju dermatološki i alergološki problemi koji zahtijevaju ozbiljnu procjenu.

Smatram da ovakva praksa ne bi trebalo da funkcioniše pod oznakom medicinske ustanove. Apsolutno ne preporučujem ovu ordinaciju nikome ko traži stručan, posvećen i odgovoran medicinski tretman.',
    'Nažalost, moje iskustvo sa ovom ordinacijom je izuzetno razočaravajuće. Od trenutka kada sam stigao, bilo je jasno da profesionalizam nije prioritet. Pregled nije obavljen u ordinaciji, već u hodniku, bez ikakve privatnosti ili osnovne medicinske etike.

Tokom pregleda, lekar je razgovarao isključivo sa osobom koja je bila sa mnom, a ne sa mnom kao pacijentom. Razgovor se vodio o temama koje nisu imale nikakve veze sa mojim zdravstvenim stanjem, što je dodatno pojačalo osećaj nepoštovanja i nesigurnosti.

Najveći problem je što je dijagnoza postavljena bez detaljnog pregleda i bez ikakvih dodatnih testova, delovala je kao puka pretpostavka. Takav pristup može biti opasan, posebno kada su u pitanju dermatološki i alergološki problemi koji zahtevaju ozbiljnu procenu.

Smatram da ovakva praksa ne bi trebalo da posluje pod imenom medicinske ustanove. Apsolutno ne preporučujem ovu ordinaciju nikome ko traži profesionalan, posvećen i odgovoran medicinski tretman.', 'Нажалост, моје искуство са овом ординацијом је изузетно разочаравајуће. Од тренутка када сам стигао, било је јасно да професионализам није приоритет. Преглед није обављен у ординацији, већ у ходнику, без икакве приватности или основне медицинске етике.

Током прегледа, лекар је разговарао искључиво са особом која је била са мном, а не са мном као пацијентом. Разговор се водио о темама које нису имале никакве везе са мојим здравственим стањем, што је додатно појачало осећај непоштовања и несигурности.

Највећи проблем је што је дијагноза постављена без детаљног прегледа и без икаквих додатних тестова, деловала је као пука претпоставка. Такав приступ може бити опасан, посебно када су у питању дерматолошки и алерголошки проблеми који захтевају озбиљну процену.

Сматрам да оваква пракса не би требало да послује под именом медицинске установе. Апсолутно не препоручујем ову ординацију никоме ко тражи професионалан, посвећен и одговоран медицински третман.', NULL, NULL, NULL, NULL,
    0, '2025-08-08 01:06:46'),

(@user_victoria_dalas, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4eFV6VTVhVms0YURFM1dreFJNR3htZFZaMGQwRRAB',
    1, 'bs', 'Mislim da je ovom doktoru odavno vrjeme da ode u penziju!!!! Potpuno nekompotentan, daje pogrešne dijagnoze kao i lijecenje, uz to vrlo drzak i neljubazan. Zaista da ima mogućnost bez ijedne zvezdice ne bih mu ni ovu jednu stavila!',
    'Mislim da je ovom doktoru odavno vrjeme da ode u penziju!!!! Potpuno nekompotentan, daje pogrešne dijagnoze kao i lijecenje, uz to vrlo drzak i neljubazan. Zaista da ima mogućnost bez ijedne zvezdice ne bih mu ni ovu jednu stavila!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-04 08:49:16'),

(@user_jevto_bojovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChZDSUhNMG9nS0VQWFNoOHl1bjV2YmRBEAE',
    1, 'bs', 'Čitam loše komentare drugih, pomislih kako su teški ovi ljudi. I ipak odem na pregled. Doktor i koleginica  su  stvarno kreteni nepristojni. Da nepovjeruješ.',
    'Čitao sam tuđe loše komentare, i pomislio kako su ti ljudi teški. I svejedno sam otišao na pregled. Doktor i njegov kolega su zaista bezobrazni kreteni. Ne biste verovali.', 'Читао сам туђе лоше коментаре, и помислио како су ти људи тешки. И свеједно сам отишао на преглед. Доктор и његов колега су заиста безобразни кретени. Не бисте веровали.', NULL, NULL, NULL, NULL,
    0, '2025-06-13 11:38:29'),

(@user_filip_marinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSUNjNjZ6NnRBRRAB',
    5, 'bs', 'Doktor je prvi u struci, a već više od tri decenije i u širem okruženju ,Nije onaj koji od jednog pregleda želi da napravi tri,tj da prvo uplaši bolesnika a onda ga u više navrata „liječi“ što se nekada može sresti kod nekih.Radi ovaj posao više od 40-ak godina .Pouzdan i uvijek na visini zadatka,i vijek ulije povjerenje.Principijelan u struci a kada je kvalitet struke je bez kompromisa. Popu pop a bobu bob , zbog čega kod neke malograđanštine izgleda grub.',
    'Lekar je prvi u struci, a već više od tri decenije u širem okruženju nije taj koji od jednog pregleda želi da napravi tri, odnosno da prvo uplaši pacijenta, a zatim ga više puta „leči“, što se kod nekih ponekad može videti. Ovim poslom se bavi više od 40 godina. Pouzdan i uvek na visini zadatka, a godine ulivaju poverenje. U profesiji je principijelan i kada je u pitanju kvalitet profesije, beskompromisan. Pop za pop i bob za bob, zbog čega deluje grubo prema nekoj malograđanštini.', 'Лекар је први у струци, а већ више од три деценије у ширем окружењу није тај који од једног прегледа жели да направи три, односно да прво уплаши пацијента, а затим га више пута „лечи“, што се код неких понекад може видети. Овим послом се бави више од 40 година. Поуздан и увек на висини задатка, а године уливају поверење. У професији је принципијелан и када је у питању квалитет професије, бескомпромисан. Поп за поп и боб за боб, због чега делује грубо према некој малограђанштини.', NULL, NULL, NULL, NULL,
    0, '2023-08-06 11:02:57'),

(@user_ja_sam_sigurno, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSURnck9xX2xnRRAB',
    5, 'hr', 'Veoma solidan, pravi doktor.',
    'Veoma solidan, pravi doktor.', NULL, NULL, NULL, NULL, NULL,
    4, '2026-09-29 00:00:00'),

(@user_lazar_b, @clinic_id, @doctor_velimir_kaludjerovic, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2trdE0wUnZUa0Y2U2tOQmNEVnVTWGM1VG1WallVRRAB',
    5, 'bs', 'Imao sam nesto na glavi probao liječiti vise puta sa raznim lijekovima mastima ali bezuspjesno to je trajalo nekih 10 godina odustao sam bio od liječenja. Kolega mi je preporucio dr Kaluđerović i rijesio mi je problem za mjesec dana i sad trenutno nista ne koristim ne vraca se problem veliko hvala doktoru...',
    'Imao sam nesto na glavi probao liječiti vise puta sa raznim lijekovima mastima ali bezuspjesno to je trajalo nekih 10 godina odustao sam bio od liječenja. Kolega mi je preporucio dr Kaluđerović i rijesio mi je problem za mjesec dana i sad trenutno nista ne koristim ne vraca se problem veliko hvala doktoru...', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_lazar_malisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKcE9GUm9Ua2RXWldaR2NtZ3diRWhWWTB4b1puYxAB',
    1, 'bs', 'Prelose iskustvo, doktor nagadja terapije, kada se dodje na pregled on se zaniva samo na onome sta mu ispricas da ti je problem, nikakav pregled tijela ili zbog cega se vec dolazi
3 mjeseca sam lijecen kod doktora i na kraju sam posao kod drugog koji je na prepricanu situaciju i nacin rada odgovorio sarkasticnim osnijehom ne zeleci da ista komentarise ali se iz tog osmijeha dosta shvatilo.
Pritom od svakog pregleda ponavlja se ista terapije koja prethodno nije uspjela.',
    'Prelose iskustvo, doktor nagadja terapije, kada se dodje na pregled on se zaniva samo na onome sta mu ispricas da ti je problem, nikakav pregled tijela ili zbog cega se vec dolazi
3 mjeseca sam lijecen kod doktora i na kraju sam posao kod drugog koji je na prepricanu situaciju i nacin rada odgovorio sarkasticnim osnijehom ne zeleci da ista komentarise ali se iz tog osmijeha dosta shvatilo.
Pritom od svakog pregleda ponavlja se ista terapije koja prethodno nije uspjela.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_michael_danuschenkov, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2paMWNuVkpRVTVEY25jeWR6ZG1iRU53VlhNNWFrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_dzemil_corovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/Ci9DQUlRQUNvZENodHljRjlvT21WaFZUbDNTSE5OUkdaT1ZVVnFWMGxRTFhkdmIxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-29 00:00:00'),

(@user_ivan_kaljevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWdFZuSTFZWFUzVm1Oa1JrVTJSMHB2WldJeE4xRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_dajana_vukic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/Ci9DQUlRQUNvZENodHljRjlvT25nNFNreGpTRzFZYlZnNGJHSXhTbWRtWlhsc2VtYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_nikola_tomashevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCTVFscHlaMHMwYjAxSVZFMW1USEZoY1dOTmNWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
