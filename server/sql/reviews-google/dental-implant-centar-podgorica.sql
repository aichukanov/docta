-- Insert Google Maps reviews for Dental Implant Centar
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dental-implant-centar-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dental-implant-centar-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_vladan_kekovic = (SELECT id FROM doctors WHERE slug = 'vladan-kekovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojana Miljko', 'https://lh3.googleusercontent.com/a/ACg8ocKRSTeffAlKrVl75ISPp-ULy3nwvNHc4ZH4_tviHZff7X7MoYE=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/106257811215325752423/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106257811215325752423/reviews');
SET @user_bojana_miljko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106257811215325752423/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Iva Radulović', 'https://lh3.googleusercontent.com/a/ACg8ocK1qNF3fMzt3hgDsvaGu3dUrMd0CEQjOgoUsL4NjVcjZlEI7w=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/105787509167018626323/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105787509167018626323/reviews');
SET @user_iva_radulovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105787509167018626323/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mijo Batricevic', 'https://lh3.googleusercontent.com/a/ACg8ocIgFKUhFBC9dAKpbvejG9Iragrabk2K38tVRcXImz6M9XFZTg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/108042289333765904024/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108042289333765904024/reviews');
SET @user_mijo_batricevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108042289333765904024/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Markovic', 'https://lh3.googleusercontent.com/a/ACg8ocJtgBW0pzezATqoJPoyQ3Z2YI05aQH3yYjqNJ7IYtwgA9Ag6A=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/117795962789689342887/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117795962789689342887/reviews');
SET @user_ivana_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117795962789689342887/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andjelka Markovic', 'https://lh3.googleusercontent.com/a/ACg8ocIehawPudbxIYyJG_L8xgd3B1VUw8NsrJyoX9YDyGfiZMXf5g=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106836708083592546084/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106836708083592546084/reviews');
SET @user_andjelka_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106836708083592546084/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alexandr Simanov', 'https://lh3.googleusercontent.com/a/ACg8ocKcZ028c-MmgbLd8OflqM2ZAAfvEZeL47m9nmgXiVNPqR_rPA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108723011032636424482/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108723011032636424482/reviews');
SET @user_alexandr_simanov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108723011032636424482/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nađa Backović', 'https://lh3.googleusercontent.com/a/ACg8ocL0bJpQ4-xa5obM9J-N7qGf6-YnEr7G2Jre8wx1dJhPg8ocRA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101499139192567275342/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101499139192567275342/reviews');
SET @user_naa_backovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101499139192567275342/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tijana Djordjevic', 'https://lh3.googleusercontent.com/a/ACg8ocJs4WJrPOvOEzPIo2O_8gLgc3n9uOLloxlzNqXRZQKka0bo=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114608773575080925176/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114608773575080925176/reviews');
SET @user_tijana_djordjevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114608773575080925176/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Srdjan Djordjevic', 'https://lh3.googleusercontent.com/a-/ALV-UjW-CkoCFfHQhQ-pJJ0LJQ6q-pxSsqrDQKn8FzDLGa0iMbMT_jc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110657050990230399682/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110657050990230399682/reviews');
SET @user_srdjan_djordjevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110657050990230399682/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tijana Korosec', 'https://lh3.googleusercontent.com/a-/ALV-UjU3kjcXBiKCymImr8BqORGDcZktxVWgwQas3vn7UEzlfId16ryS=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115370654247945470780/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115370654247945470780/reviews');
SET @user_tijana_korosec = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115370654247945470780/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladana Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocIVyJgecsogg3UHFxi9qgjSyInEF-vc2UDmQCck3bnFOQWAUw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102975096862968568191/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102975096862968568191/reviews');
SET @user_vladana_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102975096862968568191/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Čomić', 'https://lh3.googleusercontent.com/a-/ALV-UjX5-d3ioIkXc1wp1vquiR-5n6CnJ8af_S3QibpTRFc7ykf_SAE=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111637346123629039605/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111637346123629039605/reviews');
SET @user_jovana_omi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111637346123629039605/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Lucic', 'https://lh3.googleusercontent.com/a-/ALV-UjVMcJpcta2sCoLMJq_Q0jvMxeBYKf_17P1GtoPvK1jAWjRaP-Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100659983198448533921/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100659983198448533921/reviews');
SET @user_luka_lucic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100659983198448533921/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andjela 21', 'https://lh3.googleusercontent.com/a-/ALV-UjUu4ZteN7sgrUN-jxr0sHQlH_oxfOvmGnUoxWB0PWFK08tLK2EA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112078594288452349136/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112078594288452349136/reviews');
SET @user_andjela_21 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112078594288452349136/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maxim Fomenko', 'https://lh3.googleusercontent.com/a-/ALV-UjW8GHuC91lfZpJng1MhDD7aL3c7iQ5iuMKxFHBy5la2Walzm9Vo=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106818771149008754264/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106818771149008754264/reviews');
SET @user_maxim_fomenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106818771149008754264/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_bojana_miljko, @clinic_id, @doctor_vladan_kekovic, 'google_maps',
    'places/ChIJwYoB47WUTRMROul9mAMmcIk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCelUzUmlMVWx6YkVWaWVEZzVhVlpwY2kxRFMyYxAB',
    5, 'bs', 'Dental Implant Centar – Vaš osmijeh u sigurnim rukama.
Posjeta stomatologu rijetko je iskustvo kojem se radujemo, ali ordinacija Dental Implant Centar u Podgorici mijenja tu percepciju. Od samog ulaska, osjećala sam se izuzetno dobrodošlo i opušteno, što je ključno za ugodno iskustvo, pogotovo kada su u pitanju kompleksnije procedure.
Ono što ovu ordinaciju zaista izdvaja je profesionalnost i ljubaznost osoblja. Svaki član tima je pristupačan i spreman da odgovori na sva pitanja, čineći da se pacijent osjeća informisano i zbrinuto. Posebne pohvale idu dr. Kekoviću, maksilofacijalnom hirurgu, čija stručnost i posvećenost ulivaju povjerenje. Njegov pristup, uz jasno objašnjenje svake procedure, osigurao je da tačno znam šta mogu očekivati, što je uveliko smanjilo svaku potencijalnu nelagodnost.
Dental Implant nudi vrhunsku uslugu u prijatnom ambijentu, a kombinacija stručnosti i empatije čini ih idealnim izborom za sve vaše stomatološke i maksilofacijalne potrebe. Toplo preporučujem!',
    'Dental Implant Center – Vaš osmeh u sigurnim rukama.
Poseta stomatologu je retko iskustvo kome se radujemo, ali Dental Implant Center u Podgorici menja tu percepciju. Od trenutka kada sam ušao, osećao sam se izuzetno dobrodošlo i opušteno, što je ključno za prijatno iskustvo, posebno kada su u pitanju složenije procedure.
Ono što ovu kancelariju zaista izdvaja je profesionalnost i ljubaznost osoblja. Svaki član tima je pristupačan i spreman da odgovori na sva pitanja, tako da se pacijent oseća informisanim i zbrinutim. Posebna pohvala pripada dr Kekoviću, maksilofacijalnom hirurgu, čija stručnost i posvećenost uliva poverenje. Njegov pristup, zajedno sa jasnim objašnjenjem svake procedure, obezbedio je da tačno znam šta da očekujem, što je u velikoj meri smanjilo svaku potencijalnu nelagodnost.
Dental Implant nudi vrhunsku uslugu u prijatnom okruženju, a kombinacija stručnosti i empatije čini ih idealnim izborom za sve vaše stomatološke i maksilofacijalne potrebe. Toplo ih preporučujem!', 'Дентал Имплант Центер – Ваш осмех у сигурним рукама.
Посета стоматологу је ретко искуство коме се радујемо, али Дентал Имплант Центер у Подгорици мења ту перцепцију. Од тренутка када сам ушао, осећао сам се изузетно добродошло и опуштено, што је кључно за пријатно искуство, посебно када су у питању сложеније процедуре.
Оно што ову канцеларију заиста издваја је професионалност и љубазност особља. Сваки члан тима је приступачан и спреман да одговори на сва питања, тако да се пацијент осећа информисаним и збринутим. Посебна похвала припада др Кековићу, максилофацијалном хирургу, чија стручност и посвећеност улива поверење. Његов приступ, заједно са јасним објашњењем сваке процедуре, обезбедио је да тачно знам шта да очекујем, што је у великој мери смањило сваку потенцијалну нелагодност.
Дентал Имплант нуди врхунску услугу у пријатном окружењу, а комбинација стручности и емпатије чини их идеалним избором за све ваше стоматолошке и максилофацијалне потребе. Топло их препоручујем!', NULL, NULL, NULL, NULL,
    0, '2025-09-05 12:10:38'),

(@user_iva_radulovi, @clinic_id, @doctor_vladan_kekovic, 'google_maps',
    'places/ChIJwYoB47WUTRMROul9mAMmcIk/reviews/ChZDSUhNMG9nS0VJQ0FnTUNRZ1pYUlZREAE',
    5, 'bs', 'Sve preporuke! Dr Keković je izuzetno profesionalan i ljubazan. Nakon iznošenja plana rada i samog procesa ugradnje implanata, moja mama ima osmjeh koji više ne skida sa lica! Svaka čast i hvala dr Keković!',
    'Sve preporuke! Dr Keković je izuzetno stručan i ljubazan. Nakon prezentovanja plana rada i procesa ugradnje implantata, moja majka ima osmeh koji ne može da skine sa lica! Čestitamo i hvala dr Kekoviću!', 'Све препоруке! Др Кековић је изузетно стручан и љубазан. Након презентовања плана рада и процеса уградње имплантата, моја мајка има осмех који не може да скине са лица! Честитамо и хвала др Кековићу!', NULL, NULL, NULL, NULL,
    0, '2025-03-04 20:42:33'),

(@user_mijo_batricevic, @clinic_id, @doctor_vladan_kekovic, 'google_maps',
    'places/ChIJwYoB47WUTRMROul9mAMmcIk/reviews/ChdDSUhNMG9nS0VKQy05YVdFcVBYaTZnRRAB',
    5, 'bs', 'Od srca preporučujem !
Profesionalac,strpljiv,detaljan.
Prezadovoljan sam tretmanom i rezultatima.
Veliko hvala dr. Keković.',
    'Od sveg srca preporučujem!
Profesionalno, strpljivo, detaljno.
Veoma sam zadovoljan tretmanom i rezultatima.
Veliko hvala dr Kekoviću.', 'Од свег срца препоручујем!
Професионално, стрпљиво, детаљно.
Веома сам задовољан третманом и резултатима.
Велико хвала др Кековићу.', NULL, NULL, NULL, NULL,
    0, '2025-05-11 08:31:15'),

(@user_ivana_markovic, @clinic_id, @doctor_vladan_kekovic, 'google_maps',
    'places/ChIJwYoB47WUTRMROul9mAMmcIk/reviews/ChdDSUhNMG9nS0VJQ0FnSURYdi1UU2pRRRAB',
    1, 'bs', 'Nadmeno ponasanje doktora i nepofesionalan pristup pacijentu. Sreca da je to pokazao na samom startu jer sam zamalo prihvatila ugradnju impantata, pa na vrijeme i odustala. U strucnost nisam ni imala priliku da se uvjerim zahvaljujuci takvom ponasanju i nepostovanju potencijalnog pacijenta. Doktor Kekovic, koji ujedno voli da se bavi i psihologijom, neka ovu recenziju shvati kao konstruktivnu sugestiju :-)
Sto se mene i moje posjete tice jedno iskustvo (lose) vise i to je to.',
    'Arogantno ponašanje doktora i neprofesionalan pristup pacijentu. Sreća je što je to pokazao na samom početku jer sam skoro prihvatila implantat, a onda na vreme odustala. Nisam čak ni imala priliku da vidim stručnost zahvaljujući takvom ponašanju i nepoštovanju potencijalnog pacijenta. Doktor Keković, koji voli da se bavi i psihologijom, trebalo bi da ovu recenziju shvati kao konstruktivan predlog :-)
Što se mene i moje posete tiče, još jedno (loše) iskustvo i to je to.', 'Арогантно понашање доктора и непрофесионалан приступ пацијенту. Срећа је што је то показао на самом почетку јер сам скоро прихватила имплантат, а онда на време одустала. Нисам чак ни имала прилику да видим стручност захваљујући таквом понашању и непоштовању потенцијалног пацијента. Доктор Кековић, који воли да се бави и психологијом, требало би да ову рецензију схвати као конструктиван предлог :-)
Што се мене и моје посете тиче, још једно (лоше) искуство и то је то.', NULL, NULL, NULL, NULL,
    1, '2024-11-01 13:25:12'),

(@user_andjelka_markovic, @clinic_id, @doctor_vladan_kekovic, 'google_maps',
    'places/ChIJwYoB47WUTRMROul9mAMmcIk/reviews/ChZDSUhNMG9nS0VJQ0FnSURUOXEzS0RBEAE',
    5, 'bs', 'Spoj ogromne profesionalnosti, strucnosti, posvecenosti, i nadasve dobre energije. Kao prezadovoljan pacijent, kome je uradjeno all on 6  u obje vilice, toplo preporucujem Dr. Kekovica i njegov tim, kao pravo rjesenje za svakog ko je u dilemi “gdje dovesti zube do savrsenstva”.',
    'Kombinacija ogromnog profesionalizma, stručnosti, posvećenosti i iznad svega dobre energije. Kao veoma zadovoljan pacijent, koji je prošao sve na 6 u obe vilice, toplo preporučujem dr Kekovića i njegov tim, kao pravo rešenje za sve koji su u dilemi „gde da dovedu zube do savršenstva“.', 'Комбинација огромног професионализма, стручности, посвећености и изнад свега добре енергије. Као веома задовољан пацијент, који је прошао све на 6 у обе вилице, топло препоручујем др Кековића и његов тим, као право решење за све који су у дилеми „где да доведу зубе до савршенства“.', NULL, NULL, NULL, NULL,
    0, '2024-05-24 15:26:36'),

(@user_alexandr_simanov, @clinic_id, NULL, 'google_maps',
    'places/ChIJwYoB47WUTRMROul9mAMmcIk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xsMlRqVlVWR3BTUlRGTmVtWnFZVzl1WmxwTFRtYxAB',
    1, 'ru', 'Всё очень плохо, низко-квалифицированые специалисты, цены космические ,высокие. Персонал грубый и безответственный.',
    NULL, NULL, NULL, 'Всё очень плохо, низко-квалифицированые специалисты, цены космические ,высокие. Персонал грубый и безответственный.', NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_naa_backovi, @clinic_id, @doctor_vladan_kekovic, 'google_maps',
    'places/ChIJwYoB47WUTRMROul9mAMmcIk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5MVdWcGxhR2RIVmxKUmIyZzFWVFZ5U1ROclEwRRAB',
    5, 'hr', 'Od srca sve preporuke!  Izuzetno sam zadovoljna kompletnom uslugom i rezultatima. Radila sam krunice, implante, botoks i hijaluron, i svaki tretman je odrađen vrhunski, profesionalno i s velikom pažnjom prema detaljima. Dr Keković je  ljubazan, stručan i uvijek spreman da odgovori na sva pitanja, a atmosfera u ordinaciji ulijeva povjerenje od prvog dolaska. Rezultati su nadmašili moja očekivanja i konačno mogu sa osmijehom reći da sam prezadovoljna 🙂. Hvala na vrhunskom radu i posvećenosti – iskrene preporuke svima koji traže kvalitet, stručnost i vrhunsku njegu!
Hvala vam što ste mi vratili osmijeh i samopouzdanje. Vidimo se i ubuduće! 😊',
    'Od srca sve preporuke!  Izuzetno sam zadovoljna kompletnom uslugom i rezultatima. Radila sam krunice, implante, botoks i hijaluron, i svaki tretman je odrađen vrhunski, profesionalno i s velikom pažnjom prema detaljima. Dr Keković je  ljubazan, stručan i uvijek spreman da odgovori na sva pitanja, a atmosfera u ordinaciji ulijeva povjerenje od prvog dolaska. Rezultati su nadmašili moja očekivanja i konačno mogu sa osmijehom reći da sam prezadovoljna 🙂. Hvala na vrhunskom radu i posvećenosti – iskrene preporuke svima koji traže kvalitet, stručnost i vrhunsku njegu!
Hvala vam što ste mi vratili osmijeh i samopouzdanje. Vidimo se i ubuduće! 😊', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_tijana_djordjevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJwYoB47WUTRMROul9mAMmcIk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xVNGFqWjBWR0YzWkZScGEyaEtNbEF3UkdkVFkyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_srdjan_djordjevic, @clinic_id, @doctor_vladan_kekovic, 'google_maps',
    'places/ChIJwYoB47WUTRMROul9mAMmcIk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5TWJVbHBSbTlUVGxWU2FtTXdPV0ZrUnpKcU1VRRAB',
    5, 'bs', 'Sve preporuke za ljubazan pristup celom timu, mirnu ruku doktora Vladana Kekovića i savršenu uslugu 🙏
Najtoplije preporuku!',
    'Sve preporuke za ljubazan pristup celom timu, mirnu ruku doktora Vladana Kekovića i savršenu uslugu 🙏
Najtoplije preporuku!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_tijana_korosec, @clinic_id, NULL, 'google_maps',
    'places/ChIJwYoB47WUTRMROul9mAMmcIk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2swMU5rVnhVVEZmTkcxNmVFOUdUMVIzZDA5blFsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_vladana_popovic, @clinic_id, @doctor_vladan_kekovic, 'google_maps',
    'places/ChIJwYoB47WUTRMROul9mAMmcIk/reviews/ChZDSUhNMG9nS0VLSFdfX1dQdm83elZBEAE',
    5, 'en', 'The best surgical and implantology center in the region. Dr. Keković is an expert in his field.',
    NULL, NULL, 'The best surgical and implantology center in the region. Dr. Keković is an expert in his field.', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jovana_omi, @clinic_id, NULL, 'google_maps',
    'places/ChIJwYoB47WUTRMROul9mAMmcIk/reviews/ChZDSUhNMG9nS0VJQ0FnTUNRMmJXa1BBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_luka_lucic, @clinic_id, NULL, 'google_maps',
    'places/ChIJwYoB47WUTRMROul9mAMmcIk/reviews/ChdDSUhNMG9nS0VJQ0FnTUNRZ2Z2VXVnRRAB',
    5, 'bs', 'Sve preporuke, bezbolno ugradjen implant.Sve je bilo gotovo za 15 minuta.',
    'Sve preporuke, bezbolno ugradjen implant.Sve je bilo gotovo za 15 minuta.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_andjela_21, @clinic_id, NULL, 'google_maps',
    'places/ChIJwYoB47WUTRMROul9mAMmcIk/reviews/ChZDSUhNMG9nS0VJQ0FnSURYeWRMcWNREAE',
    1, 'hr', 'Vrlo neprofesionalno ponasanje.',
    'Vrlo neprofesionalno ponasanje.', NULL, NULL, NULL, NULL, NULL,
    1, '2024-10-29 00:00:00'),

(@user_maxim_fomenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJwYoB47WUTRMROul9mAMmcIk/reviews/ChZDSUhNMG9nS0VJQ0FnSUNMOEptdkZnEAE',
    5, 'en', 'A very good and professional dental center. Helped me to fix my SGS implant that got loose and fixed a cavity found during the inspection. Highly recommend.',
    NULL, NULL, 'A very good and professional dental center. Helped me to fix my SGS implant that got loose and fixed a cavity found during the inspection. Highly recommend.', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
