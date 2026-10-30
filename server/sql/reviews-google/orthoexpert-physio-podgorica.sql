-- Insert Google Maps reviews for OrthoExpert Physio Podgorica
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/orthoexpert-physio-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'orthoexpert-physio-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_sonja_nejkov = (SELECT id FROM doctors WHERE slug = 'sonja-nejkov');
SET @doctor_srdjan_zivanovic = (SELECT id FROM doctors WHERE slug = 'srdjan-zivanovic');
SET @doctor_jelena_klikovac = (SELECT id FROM doctors WHERE slug = 'jelena-klikovac');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Jaksic', 'https://lh3.googleusercontent.com/a/ACg8ocKwnDRvO9kB4ulAbmtFoisaNEot5yVJGvZIaMA8IEBMsqYoRg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/112560293483191591792/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112560293483191591792/reviews');
SET @user_dragana_jaksic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112560293483191591792/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojana Markus', 'https://lh3.googleusercontent.com/a-/ALV-UjXORSfHm_bQudwSeietbTnF4appFdnK0gTyZhqAm3lw8e5DO09a=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/105051206392227505853/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105051206392227505853/reviews');
SET @user_bojana_markus = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105051206392227505853/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Igor Cetkovic', 'https://lh3.googleusercontent.com/a/ACg8ocJ4tsTOVzr3rOI5C1G6DODqm_zFoJ5k9ey1UveqfQJcVCTtdA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101582567565368221539/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101582567565368221539/reviews');
SET @user_igor_cetkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101582567565368221539/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Spasoje Vukmirovic', 'https://lh3.googleusercontent.com/a/ACg8ocKHPAU3XAHOICgHNIqdBy7GkTcxrnEvcK_xHdQWStfiNGcK6g=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/113388877241140992568/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113388877241140992568/reviews');
SET @user_spasoje_vukmirovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113388877241140992568/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Brankica Bojovic', 'https://lh3.googleusercontent.com/a/ACg8ocJc-QxlGK1_8ULaddj-3WlT2kRAdPog4JqRX7fYAr6vdtblhg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/103576165143383964380/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103576165143383964380/reviews');
SET @user_brankica_bojovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103576165143383964380/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Veliborka Dragomanovic', 'https://lh3.googleusercontent.com/a/ACg8ocL4oz4-NpsPS2QwI929siBQSXbug1wtsZP3i8yCNdXOwykIQg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105979589612212793242/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105979589612212793242/reviews');
SET @user_veliborka_dragomanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105979589612212793242/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natasa Todorovic', 'https://lh3.googleusercontent.com/a/ACg8ocIyAkpLE4nG0sF74ll66ICzX14vj8O3HgimcdLcehsWzM-i4Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110821023046885397059/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110821023046885397059/reviews');
SET @user_natasa_todorovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110821023046885397059/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jeja K', 'https://lh3.googleusercontent.com/a/ACg8ocKN-vIPcbiSQBqluOdO8ASYTkzc4JyKQ6ZUrFBlthvflSN45w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107225604775829362257/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107225604775829362257/reviews');
SET @user_jeja_k = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107225604775829362257/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Klikovac', 'https://lh3.googleusercontent.com/a/ACg8ocJHKoClUMP1vzgousOg97m7BRYnr9TPP_oAg_rRQViQ8SrPIg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105706127201276939608/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105706127201276939608/reviews');
SET @user_ivan_klikovac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105706127201276939608/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nidzo Maras', 'https://lh3.googleusercontent.com/a-/ALV-UjWo0j7EHSIkarwG_PqxX6zyR7EyPpRTPgI0BJa_3lRMlpA8P0u9=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100847393089144854270/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100847393089144854270/reviews');
SET @user_nidzo_maras = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100847393089144854270/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milos Djukic', 'https://lh3.googleusercontent.com/a/ACg8ocJnD3NTmxBk3hkus4UA7QoMBJkfkflQBDH1a4E1deC1EyFGZg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118061883636342597234/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118061883636342597234/reviews');
SET @user_milos_djukic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118061883636342597234/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Klikovac', 'https://lh3.googleusercontent.com/a/ACg8ocLA7rKrf1yITxhCg_RuldIttwQsSjbofpr5gIqmxCwB_NDGIw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115157876123722512514/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115157876123722512514/reviews');
SET @user_ivana_klikovac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115157876123722512514/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Gordana Vujadinovic', 'https://lh3.googleusercontent.com/a/ACg8ocIqf9mXD69Z1LvxTgb-46eyQJVvoIlXc7BJ5YfohjTax8CLLA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109672293413286132456/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109672293413286132456/reviews');
SET @user_gordana_vujadinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109672293413286132456/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola', 'https://lh3.googleusercontent.com/a/ACg8ocIeE8Hrsb-8XAGXs2j_fK86CqcLPb8bN6syOe1hr4HLJf_qtg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113987110622867727322/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113987110622867727322/reviews');
SET @user_nikola = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113987110622867727322/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dejan Jankovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWfinhwP44mV25Y6XEg5A2Hps2pR7zYwQhEFD9yBOdC1c9EygwVTA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116012008757858505035/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116012008757858505035/reviews');
SET @user_dejan_jankovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116012008757858505035/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zorica Đuranović', 'https://lh3.googleusercontent.com/a/ACg8ocIiPOLzJUdKkJ-jlRP_S17UhxRxPFmj0t0h-IVlsi26zq37vg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118046620819602666338/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118046620819602666338/reviews');
SET @user_zorica_uranovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118046620819602666338/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Grba', 'https://lh3.googleusercontent.com/a-/ALV-UjXYO0KQQrMJdQHAYcboVn0olYbba7vX_RymDpnPfWpLv3ehBneuHg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108217087042730453764/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108217087042730453764/reviews');
SET @user_nikola_grba = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108217087042730453764/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Banovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVnMaRnumbMMxatJZwE5uGO9-1PuTRRidO7bBXjPFS4KBSR4wff=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111403180783250843928/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111403180783250843928/reviews');
SET @user_ivana_banovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111403180783250843928/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra Golubovic', 'https://lh3.googleusercontent.com/a/ACg8ocIA1VfUkwWNpnChmlJjyuXdqqcWSBFc1BqTjp4hrrDxtIAtyA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104284019507434312684/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104284019507434312684/reviews');
SET @user_aleksandra_golubovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104284019507434312684/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mustafa Kolari', 'https://lh3.googleusercontent.com/a/ACg8ocLqgLS98s96QuX7BqVd8G7O6VeLLHuOQFfOYm2yfEQbWPYz_A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114498418481470588163/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114498418481470588163/reviews');
SET @user_mustafa_kolari = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114498418481470588163/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'MM', 'https://lh3.googleusercontent.com/a/ACg8ocJ5KBgMDDJMjZzPaCAshSn5QEvKc7_vVF85iE2aauLTDWocqg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105710767308855522676/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105710767308855522676/reviews');
SET @user_mm = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105710767308855522676/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vesna Kovacevic', 'https://lh3.googleusercontent.com/a/ACg8ocJyjLQR-SjO6Jbij6UKyeoI1zRKdLf26j7DBt6U0DkcScAuRw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116935410219195471457/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116935410219195471457/reviews');
SET @user_vesna_kovacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116935410219195471457/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zivana Bulatovic', 'https://lh3.googleusercontent.com/a/ACg8ocIiafg2Wsuj67hshbDftsLzmBlBnsUVdz0spnmwr5kWXaq5kw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105614849045662753871/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105614849045662753871/reviews');
SET @user_zivana_bulatovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105614849045662753871/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vukan Milutinovic', 'https://lh3.googleusercontent.com/a/ACg8ocK19ltRHrCZaUPcPE4zK8g0iOC2dt2-B0QQ2y_QBPAqPtXabg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112864786860131405037/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112864786860131405037/reviews');
SET @user_vukan_milutinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112864786860131405037/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Andjic', 'https://lh3.googleusercontent.com/a/ACg8ocKFxvjvn1e8nnpvs9CD97Qc4EcM6HqSTtJoMPOYOpJQL9H23A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113734009964613999738/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113734009964613999738/reviews');
SET @user_ivan_andjic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113734009964613999738/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Nikodijevic', 'https://lh3.googleusercontent.com/a/ACg8ocJEMKV1QPpnBIulYnwovP7iC5jDDibsGa1L3isP2RCGBZ1OkA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118374725645290737881/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118374725645290737881/reviews');
SET @user_nikola_nikodijevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118374725645290737881/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Đorđe Nejkov', 'https://lh3.googleusercontent.com/a/ACg8ocIlExsNLbhpPupcK3jHEDBWp6_4h6gBUMXUX6QlDR3V_IOFgjPS=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118044796196249590844/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118044796196249590844/reviews');
SET @user_ore_nejkov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118044796196249590844/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_dragana_jaksic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT205NFdVbHVlalJhWWs5UmNUSm5VVzltUjFaU09FRRAB',
    5, 'bs', 'OrthoExpert Physio Podgorica je mjesto gdje se medicina, stručnost i istinska briga o pacijentu spajaju u jednu izvanrednu cjelinu. Od prvog ulaska u ordinaciju jasno je da je tim maksimalno posvećen tome da svaki pacijent dobije najbolji mogući tretman i pažnju.
Tim je vrhunski, a pristup pacijentu besprekoran.

Posebno želim da pohvalim dr Srđana Živanovića čija stručnost, smirenost i jasno objašnjavanje svakog dijagnostičkog i medicinskog postupka ulivaju ogroman osjećaj sigurnosti. Njegov pristup je profesionalan, ali i nevjerovatno ljudski - idealan spoj koji pacijentima znači više nego što se može opisati.

Dr Sonja Neikov se izdvaja preciznošću, posvećenošću i velikom empatijom. Svojim znanjem i pažljivim pristupom uliva povjerenje od samog početka, a njena sposobnost da prepozna suštinu problema i prilagodi terapiju je za svaku pohvalu.

Među sjajnim članovima tima posebno bih istakla Jelenu Klikovac, fizioterapeut sa nevjerovatno nježnim, ali izuzetno efikasnim pristupom. Njene terapije, savjeti i tehnike čine ogromnu razliku - ne samo u oporavku, već i u osjećaju da ste zaista u pravim rukama. Jelena osvaja svojom toplinom, profesionalnošću i posvećenošću svakom pacijentu.

Ukratko: OrthoExpert Physio Podgorica je ordinacija u koju ulazite sa problemom, a izlazite sa osjećajem da ste dio tima koji zaista brine o vama. Najtoplija preporuka, bez imalo dileme.',
    'OrthoEkpert Phisio Podgorica je mjesto gdje se medicina, stručnost i istinska briga o pacijentima spajaju u jednu izvanrednu cjelinu. Od trenutka kada uđete u ordinaciju, jasno je da je tim u potpunosti posvećen tome da svaki pacijent dobije najbolji mogući tretman i pažnju.
Tim je vrhunski, a pristup pacijentu besprekoran.

Posebno bih pohvalio dr Srđana Živanovića, čija stručnost, smirenost i jasno objašnjenje svake dijagnostičke i medicinske procedure ulivaju izuzetan osećaj sigurnosti. Njegov pristup je profesionalan, ali i neverovatno ljudski - idealna kombinacija koja pacijentima znači više nego što se može opisati.

Dr Sonja Nejkov ističe se preciznošću, posvećenošću i velikom empatijom. Svojim znanjem i pažljivim pristupom od samog početka uliva poverenje, a njena sposobnost da prepozna suštinu problema i prilagodi terapiju je za svaku pohvalu.

Među sjajnim članovima tima posebno bih izdvojio Jelenu Klikovac, fizioterapeuta sa neverovatno nežnim, ali izuzetno efikasnim pristupom. Njene terapije, saveti i tehnike čine ogromnu razliku - ne samo u oporavku, već iu osećaju da ste zaista u dobrim rukama. Jelena pleni svojom toplinom, profesionalnošću i posvećenošću svakom pacijentu.

Ukratko: OrthoEkpert Phisio Podgorica je praksa u koju ulazite sa problemom, a izlazite sa osjećajem da ste dio tima koji zaista brine o vama. Najtoplija preporuka, bez ikakvog oklevanja.', 'ОртхоЕкперт Пхисио Подгорица је мјесто гдје се медицина, стручност и истинска брига о пацијентима спајају у једну изванредну цјелину. Од тренутка када уђете у ординацију, јасно је да је тим у потпуности посвећен томе да сваки пацијент добије најбољи могући третман и пажњу.
Тим је врхунски, а приступ пацијенту беспрекоран.

Посебно бих похвалио др Срђана Живановића, чија стручност, смиреност и јасно објашњење сваке дијагностичке и медицинске процедуре уливају изузетан осећај сигурности. Његов приступ је професионалан, али и невероватно људски - идеална комбинација која пацијентима значи више него што се може описати.

Др Соња Нејков истиче се прецизношћу, посвећеношћу и великом емпатијом. Својим знањем и пажљивим приступом од самог почетка улива поверење, а њена способност да препозна суштину проблема и прилагоди терапију је за сваку похвалу.

Међу сјајним члановима тима посебно бих издвојио Јелену Кликовац, физиотерапеута са невероватно нежним, али изузетно ефикасним приступом. Њене терапије, савети и технике чине огромну разлику - не само у опоравку, већ иу осећају да сте заиста у добрим рукама. Јелена плени својом топлином, професионалношћу и посвећеношћу сваком пацијенту.

Укратко: ОртхоЕкперт Пхисио Подгорица је пракса у коју улазите са проблемом, а излазите са осјећајем да сте дио тима који заиста брине о вама. Најтоплија препорука, без икаквог оклевања.', NULL, NULL, NULL, NULL,
    0, '2025-11-18 13:09:24'),

(@user_bojana_markus, @clinic_id, @doctor_srdjan_zivanovic, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21oalZsaFVOemRFYWsxbmVWRjJlRmMzWjBaMVdtYxAB',
    5, 'hr', 'Sve pohvale za stručnost i pristup dr Živanovića. Osoblje maksimalno ljubazno.',
    'Sve pohvale za stručnost i pristup dr Živanovića. Osoblje je izuzetno ljubazno.', 'Све похвале за стручност и приступ др Живановића. Особље је изузетно љубазно.', NULL, NULL, NULL, NULL,
    0, '2025-11-18 13:59:14'),

(@user_igor_cetkovic, @clinic_id, @doctor_srdjan_zivanovic, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25FMWQwZ3pZaTFHYWtVd1VqaFNXbTg1WmtWdU9WRRAB',
    5, 'hr', 'Prezadovoljan sam iskustvom u ordinaciji i veoma zahvalan dr Živanoviću i osoblju.',
    'Veoma sam zadovoljan iskustvom u ordinaciji i veoma sam zahvalan dr Živanoviću i osoblju.', 'Веома сам задовољан искуством у ординацији и веома сам захвалан др Живановићу и особљу.', NULL, NULL, NULL, NULL,
    0, '2025-11-18 11:24:35'),

(@user_spasoje_vukmirovic, @clinic_id, @doctor_sonja_nejkov, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21oRE4wSlFiVVYxTUZNdFFYQkdlVUpVUkUxMlpXYxAB',
    5, 'bs', 'Sjajna doktorka Nejkov!!! Puna podrška za start 🤗👋',
    'Sjajna doktorka Nejkov!!! Puna podrška za start 🤗👋', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-18 21:26:19'),

(@user_brankica_bojovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GQ2NtdzNWVUk0VTNOc2MwVk1VMDlTU0d0MmJGRRAB',
    5, 'hr', 'Sve preporuke.Sjajan tim!!!',
    'Sve preporuke. Great team!!!', 'Све препоруке. Греат теам!!!', NULL, NULL, NULL, NULL,
    0, '2025-11-18 11:32:36'),

(@user_veliborka_dragomanovic, @clinic_id, @doctor_srdjan_zivanovic, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT214eldWVjNiRU54UzBGNmRqQm1SWFp6T0daSWMzYxAB',
    5, 'hr', 'Od mene iskrene pohvale, veliko hvala i najtoplija preporuka od srca! Najbolji dr Živanović, i cijelo osoblje. Hvala! ❤️',
    'Od mene iskrene pohvale, veliko hvala i najtoplija preporuka od srca! Najbolji dr Živanović, i cijelo osoblje. Hvala! ❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_natasa_todorovic, @clinic_id, @doctor_srdjan_zivanovic, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s0dFdVRjVTRXRwVDBnMk9WZElVMFpvWlZkaU5rRRAB',
    5, 'hr', 'Najdivnije osoblje i dr Živanović!',
    'Najdivnije osoblje i dr Živanović!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_jeja_k, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25OaWFrWnRYMUpKUVhsTWQybDNWVVJqUnpRNWJXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_ivan_klikovac, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pOUk9WQmZUV3BPT0hwdVpGcExiemhrZUhsWVJIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_nidzo_maras, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT214ZlJsWlpTMkZXVG1aeE0xbzJZblJ4TFdaZmNVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_milos_djukic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21OdGExZFphbHBtZVc0dGFUQkxUR05EZGxZeFNtYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_ivana_klikovac, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21aUk1HMXJTVVJsTUZKUE9XbE9VbnB3ZUZWaVdYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_gordana_vujadinovic, @clinic_id, @doctor_srdjan_zivanovic, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKa01UbDROMEpLVURSTFFtNTRVbFZ0V2pGYVIzYxAB',
    5, 'bs', 'Izuzetno pozitivno iskustvo sa pregledom kod dr Živanovića. Stručan i posvećen pristup pacijentu i veoma ljubazno osoblje.
Preporuka...',
    'Izuzetno pozitivno iskustvo sa pregledom kod dr Živanovića. Stručan i posvećen pristup pacijentu i veoma ljubazno osoblje.
Preporuka...', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_nikola, @clinic_id, @doctor_srdjan_zivanovic, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGd1RGWlJlbEJJUjJveU56bEpUa1pIYzBOTmNrRRAB',
    5, 'bs', 'Sve pohvale za dr Živanovića.
Na prvom mjestu sjajan čovjek, a pored toga odličan i stručan ljekar.
Sve preporuke za njega.
Nikola Bogetić',
    'Sve pohvale za dr Živanovića.
Na prvom mjestu sjajan čovjek, a pored toga odličan i stručan ljekar.
Sve preporuke za njega.
Nikola Bogetić', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_dejan_jankovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25aR01YbEljMVU1ZDIwME9HdDBaVzV3V0ZCcU1WRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_zorica_uranovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25kR05XVjBRbXR1Vm5SWFJtZEpPRVk0T0hvM2RHYxAB',
    5, 'hr', 'Sve preporuke za divan tim!',
    'Sve preporuke za divan tim!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_nikola_grba, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxQ1dHdGZaWGxzTlZwUVZGSTRTbEJVUjJscmVHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_ivana_banovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twUU4zaENhWEpEVmpWS1dEVnpSaTFGV0hod2VXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_aleksandra_golubovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21NM1JGSkJVbmxQUWpneVIyVnlVVEphYlc1V1RWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_mustafa_kolari, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xveFpFNUdkakJaZVRCR09VaHJWMkZTZVZoUGMyYxAB',
    5, 'bs', 'Imala sam veoma pozitivno iskustvo u ovoj klinici. Osoblje je izuzetno ljubazno, profesionalno i posvećeno pacijentima. Posebno bih željela da pohvalim doktorku Sonju Nejkov i doktora Srđana Živanovića na njihovoj stručnosti, strpljenju i pažnji. Zaista se vidi da rade svoj posao sa velikom odgovornošću i brigom prema pacijentima. Sve preporuke za ovu kliniku!',
    'Imala sam veoma pozitivno iskustvo u ovoj klinici. Osoblje je izuzetno ljubazno, profesionalno i posvećeno pacijentima. Posebno bih željela da pohvalim doktorku Sonju Nejkov i doktora Srđana Živanovića na njihovoj stručnosti, strpljenju i pažnji. Zaista se vidi da rade svoj posao sa velikom odgovornošću i brigom prema pacijentima. Sve preporuke za ovu kliniku!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_mm, @clinic_id, @doctor_sonja_nejkov, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tJeVZreFZlRWhwY1VzNFZtaEZNVWR2Vm10MmMyYxAB',
    5, 'sk', 'Dr Nejkov! ✊👌🏼',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_vesna_kovacevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pCRVJXRkxSSGd5TWtwaWEzQldXbXRHYkdKeFgzYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_zivana_bulatovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twU1MzaG9ha0Z5UWpod1NWbGlaMkp3VFhGRlZXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_vukan_milutinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21sTmJGRm9aV0ZpU3pOMVNGVXlUV2xWVGpFMVRHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_ivan_andjic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2poTVJXbGFhR3RIUkUxSlIxVk9RM2RVTW5kSE5IYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_nikola_nikodijevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psWlZqaFpjbWxFTjJGaFltOU5PVmhSWkVabFNGRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_ore_nejkov, @clinic_id, NULL, 'google_maps',
    'places/ChIJhfDvLo_rTRMRosr6ahUrUwI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21zMmQzVnBhSFUyTnpsRU56WnBYM1pEY3pVemVHYxAB',
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
