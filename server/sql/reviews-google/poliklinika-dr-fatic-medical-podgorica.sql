-- Insert Google Maps reviews for Poliklinika - Dr Fatic Medical
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/poliklinika-dr-fatic-medical-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'poliklinika-dr-fatic-medical-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_nikola_fatic = (SELECT id FROM doctors WHERE slug = 'nikola-fatic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Martinovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVoo1_PASMx7N81tdkX0zC96XgR-PI8wUfNt03MIpVunFQtiwFv=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/109238469954923163768/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109238469954923163768/reviews');
SET @user_ivana_martinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109238469954923163768/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nani “Nanipsy”', 'https://lh3.googleusercontent.com/a-/ALV-UjWASMvsNniwM3OZAAn7aotIOaQ4ql90YXBgvaOAOk0j39sjNNPKmQ=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/104178925731000518006/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104178925731000518006/reviews');
SET @user_nani_nanipsy = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104178925731000518006/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'marijana Senel', 'https://lh3.googleusercontent.com/a/ACg8ocLR000kxIAlrg43XGRMy8R7GhnwkNGoMXuUFT41gafPWvxa=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111458526711585445577/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111458526711585445577/reviews');
SET @user_marijana_senel = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111458526711585445577/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Rakanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVoLWwynmAEXFnBAHSuNGyb1cdN4whdsfm3R9OBfsYiFlssCLRY=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/105214375351862528712/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105214375351862528712/reviews');
SET @user_ana_rakanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105214375351862528712/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Larisa Šipčić', 'https://lh3.googleusercontent.com/a-/ALV-UjUoXg1AolBEhWX5LEt8LIOm5lB2N6LUCKSSHWIjx8FTeJanwt71Lw=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/108743537100747824120/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108743537100747824120/reviews');
SET @user_larisa_ipi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108743537100747824120/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Rakovic', 'https://lh3.googleusercontent.com/a/ACg8ocIDnmpjG4QK6HWDI55IIItwVZFg9vk5PRt4PhjaC3Mbad_PaQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109691567539604424879/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109691567539604424879/reviews');
SET @user_ivana_rakovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109691567539604424879/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Татьяна Иваненко', 'https://lh3.googleusercontent.com/a-/ALV-UjWwtDE16i1aRicDdirYKwaCZjpDeN0ObZ9szpNpYxGcooaPQ_UN=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107204727344827702361/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107204727344827702361/reviews');
SET @user_tatyana_ivanenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107204727344827702361/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dijana Ljutica', 'https://lh3.googleusercontent.com/a-/ALV-UjXJNvVn3_fyPEm7jTVLBltUBim8Sdz9w8ps8UkSuSrk5GJmUpnI=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107931014392211304929/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107931014392211304929/reviews');
SET @user_dijana_ljutica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107931014392211304929/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sonja Perunovic', 'https://lh3.googleusercontent.com/a/ACg8ocLNsdmgiZ9iooWkHxqm78Bl_iVMw81SWP1USuGQ_MJR13I_nw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112008887529773441140/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112008887529773441140/reviews');
SET @user_sonja_perunovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112008887529773441140/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Purlija', 'https://lh3.googleusercontent.com/a/ACg8ocKiAawQ4mqbriNozCEFPgJszadyonVRUWQIm0CdB1CNM6me3Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102888200704757640222/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102888200704757640222/reviews');
SET @user_maja_purlija = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102888200704757640222/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Filip Despotović', 'https://lh3.googleusercontent.com/a-/ALV-UjU7tridZCxae9lRqkv7r0IPTOwT_TcVwwzV5D-kVyjH9IL1I__N=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107250132627445444514/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107250132627445444514/reviews');
SET @user_filip_despotovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107250132627445444514/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'bbhumblefx', 'https://lh3.googleusercontent.com/a/ACg8ocLMpQbu_Dr5HyTnVRF4PLbO9H9VGxPhAlQ0iFu8XYs0eilYNw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102414217124137270145/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102414217124137270145/reviews');
SET @user_bbhumblefx = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102414217124137270145/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andjela Fatic', 'https://lh3.googleusercontent.com/a/ACg8ocLUmbU8uBVMX1-Y5LJywIdH1DaTnhfJeeDxTDsrgbMLhl4PSg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110639350324862036141/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110639350324862036141/reviews');
SET @user_andjela_fatic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110639350324862036141/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_ivana_martinovic, @clinic_id, @doctor_nikola_fatic, 'google_maps',
    'places/ChIJR3tem2HrTRMRa4Lw8UHmfL0/reviews/Ci9DQUlRQUNvZENodHljRjlvT25kS2VEQnBSalUzVVZwa2IyNTFaM2xmWmtwUVYwRRAB',
    5, 'bs', 'Poliklinika Dr Fatić Medical ističe se kao ustanova koja pruža visok nivo medicinske usluge, uz izraženu profesionalnost i posvećenost pacijentima. Prema iskustvu korisnika, osoblje je izuzetno ljubazno, stručno i efikasno, što doprinosi osjećaju sigurnosti i povjerenja tokom cijelog procesa liječenja.

Posebne pohvale upućene su vaskularnom hirurgu Dr.Nikoli Fatiću, koji se opisuje kao vrhunski stručnjak u Crnoj Gori i šire. Njegov pristup pacijentima karakterišu profesionalnost, stručnost i empatija, što je od presudne važnosti u savremenoj medicinskoj praksi.

Na osnovu dostupnih utisaka, može se zaključiti da Poliklinika Dr Fatić Medical uspješno kombinuje visok medicinski standard sa ljudskim pristupom pacijentima, čime se svrstava među vodeće privatne zdravstvene ustanove u regionu.',
    'Medicinska poliklinika Dr Fatić izdvaja se kao ustanova koja pruža visok nivo medicinskih usluga, sa izraženim profesionalizmom i posvećenošću pacijentima. Prema iskustvu korisnika, osoblje je izuzetno ljubazno, profesionalno i efikasno, što doprinosi osećaju sigurnosti i poverenja tokom celog procesa lečenja.

Posebne pohvale idu vaskularnom hirurgu dr Nikoli Fatiću, koji je okarakterisan kao vrhunski stručnjak u Crnoj Gori i šire. Njegov pristup pacijentima karakteriše profesionalnost, stručnost i empatija, što je od presudnog značaja u savremenoj medicinskoj praksi.

Na osnovu dostupnih utisaka, može se zaključiti da Medicinska poliklinika Dr Fatić uspešno kombinuje visoke medicinske standarde sa humanim pristupom pacijentima, što je svrstava među vodeće privatne zdravstvene ustanove u regionu.', 'Медицинска поликлиника Др Фатић издваја се као установа која пружа висок ниво медицинских услуга, са израженим професионализмом и посвећеношћу пацијентима. Према искуству корисника, особље је изузетно љубазно, професионално и ефикасно, што доприноси осећају сигурности и поверења током целог процеса лечења.

Посебне похвале иду васкуларном хирургу др Николи Фатићу, који је окарактерисан као врхунски стручњак у Црној Гори и шире. Његов приступ пацијентима карактерише професионалност, стручност и емпатија, што је од пресудног значаја у савременој медицинској пракси.

На основу доступних утисака, може се закључити да Медицинска поликлиника Др Фатић успешно комбинује високе медицинске стандарде са хуманим приступом пацијентима, што је сврстава међу водеће приватне здравствене установе у региону.', NULL, NULL, NULL, NULL,
    0, '2025-10-31 08:36:05'),

(@user_nani_nanipsy, @clinic_id, NULL, 'google_maps',
    'places/ChIJR3tem2HrTRMRa4Lw8UHmfL0/reviews/ChdDSUhNMG9nS0VJQ0FnSUNEcGVYSy1nRRAB',
    5, 'hr', 'Pošto su doktori iz klinike moju najdražu osobu digli iz postelje za samo mesec dana i precizno i brzo uradili dijagnostiku bolesti ja imam samo reči hvale.. ljubazno osoblje, veliki stručnjaci u svojim oblastima.. a kada probam i estetiku kojom se takođe bave dodaću kakva im je doktorka, jer mislim da će zanimati većinu dama...',
    'Pošto su lekari iz klinike za samo mesec dana izvukli moju najdražu osobu iz kreveta i precizno i brzo dijagnostikovali bolest, imam samo reči hvale... ljubazno osoblje, odlični stručnjaci u svojim oblastima... a kada budem probala i estetiku kojom se bave, dodaću kakvi su lekari, jer mislim da će većina dama biti zainteresovana...', 'Пошто су лекари из клинике за само месец дана извукли моју најдражу особу из кревета и прецизно и брзо дијагностиковали болест, имам само речи хвале... љубазно особље, одлични стручњаци у својим областима... а када будем пробала и естетику којом се баве, додаћу какви су лекари, јер мислим да ће већина дама бити заинтересована...', NULL, NULL, NULL, NULL,
    2, '2024-03-30 16:40:26'),

(@user_marijana_senel, @clinic_id, NULL, 'google_maps',
    'places/ChIJR3tem2HrTRMRa4Lw8UHmfL0/reviews/ChdDSUhNMG9nS0VJQ0FnSUR0NHEyNDN3RRAB',
    5, 'hr', 'Upravo sam izasla iz klinike, SVE POHVALE ZA DOKTORA I OSOBLJE. Hvala!',
    'Upravo sam napustio kliniku, SVE POHVALE ZA DOKTORA I OSOBLjE. Hvala!', 'Управо сам напустио клинику, СВЕ ПОХВАЛЕ ЗА ДОКТОРА И ОСОБЉЕ. Хвала!', NULL, NULL, NULL, NULL,
    0, '2024-02-03 12:14:17'),

(@user_ana_rakanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR3tem2HrTRMRa4Lw8UHmfL0/reviews/ChZDSUhNMG9nS0VJQ0FnTUNRbWRmYkdREAE',
    5, 'hr', 'Svaka cast
Sve pohvale doktoru!',
    'Čestitam
Sve pohvale doktoru!', 'Честитам
Све похвале доктору!', NULL, NULL, NULL, NULL,
    0, '2025-03-05 20:04:22'),

(@user_larisa_ipi, @clinic_id, NULL, 'google_maps',
    'places/ChIJR3tem2HrTRMRa4Lw8UHmfL0/reviews/ChdDSUhNMG9nS0VJQ0FnSUREdGJtbnh3RRAB',
    5, 'hr', 'Najbolji doktor!',
    'Najbolji doktor!', 'Најбољи доктор!', NULL, NULL, NULL, NULL,
    0, '2024-04-12 14:23:58'),

(@user_ivana_rakovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR3tem2HrTRMRa4Lw8UHmfL0/reviews/Ci9DQUlRQUNvZENodHljRjlvT21KR1dFOVVSM2gwT1RaMFQySnRSVlZuVlc1emFGRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_tatyana_ivanenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJR3tem2HrTRMRa4Lw8UHmfL0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwTVFXUk5PRGhETkhWbVZXTm9SRTF3ZFdSSVltYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dijana_ljutica, @clinic_id, NULL, 'google_maps',
    'places/ChIJR3tem2HrTRMRa4Lw8UHmfL0/reviews/Ci9DQUlRQUNvZENodHljRjlvT21wNlkyNVVhRkF0Tm5sNmRYaENPWFJXYW10eGNGRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_sonja_perunovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR3tem2HrTRMRa4Lw8UHmfL0/reviews/ChZDSUhNMG9nS0VJQ0FnSURUMkxYdkt3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_maja_purlija, @clinic_id, NULL, 'google_maps',
    'places/ChIJR3tem2HrTRMRa4Lw8UHmfL0/reviews/ChdDSUhNMG9nS0VJQ0FnSURqX3B2TnVRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_filip_despotovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJR3tem2HrTRMRa4Lw8UHmfL0/reviews/ChdDSUhNMG9nS0VJQ0FnSURodGNlV3lBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_bbhumblefx, @clinic_id, NULL, 'google_maps',
    'places/ChIJR3tem2HrTRMRa4Lw8UHmfL0/reviews/ChdDSUhNMG9nS0VJQ0FnSUNCaDhYaHJnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_andjela_fatic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR3tem2HrTRMRa4Lw8UHmfL0/reviews/ChZDSUhNMG9nS0VJQ0FnSUNCaDhtNGRREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
