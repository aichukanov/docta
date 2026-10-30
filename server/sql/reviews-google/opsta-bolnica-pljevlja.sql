-- Insert Google Maps reviews for General Hospital
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/opsta-bolnica-pljevlja.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'opsta-bolnica-pljevlja');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_mirko_terzic = (SELECT id FROM doctors WHERE slug = 'mirko-terzic');
SET @doctor_vladimir_djukovic = (SELECT id FROM doctors WHERE slug = 'vladimir-djukovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jennifer DB', 'https://lh3.googleusercontent.com/a/ACg8ocIIH5ff2k6GxAlqOBRJnzt8adndBZd6c3BlU9LaXVaGjZy6gg=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/115085500824150474604/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115085500824150474604/reviews');
SET @user_jennifer_db = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115085500824150474604/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zorica Starcevic Radujko', 'https://lh3.googleusercontent.com/a/ACg8ocIIAPvCe-UIPKMYzGkh83Fy2KrswAOQeWBwVZPCE-rr9NgwzA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/117755739846376198921/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117755739846376198921/reviews');
SET @user_zorica_starcevic_radujko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117755739846376198921/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vasko V', 'https://lh3.googleusercontent.com/a-/ALV-UjVSs0nruG0I0RPZtuzCxnPHZPC7vAoQXCVxJ0ZssLhT6tl08kIe3w=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/109582958627299470032/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109582958627299470032/reviews');
SET @user_vasko_v = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109582958627299470032/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milorad kotlaja', 'https://lh3.googleusercontent.com/a-/ALV-UjWPmykzSVLh5LD3m2pZf6CjM1iQrlqCaoegF9b0quiwB6JKAcc=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106951399646663274787/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106951399646663274787/reviews');
SET @user_milorad_kotlaja = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106951399646663274787/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sandra Ljubojević', 'https://lh3.googleusercontent.com/a-/ALV-UjXHYti9UPehmghiHtaAPn9yIETZjOlgX3HPx_v2AxSKIHfiY9_4iQ=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/113533400209154996753/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113533400209154996753/reviews');
SET @user_sandra_ljubojevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113533400209154996753/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_jennifer_db, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0ZnjOUwIWEcRT9kSLJHCxEY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNadnRhRGVnEAE',
    2, 'nl', 'Spoed: 1 klein kamertje waarin de hygiëne te wensen over liet. Er lagen mysterieuze plassen op de grond en er werd binnen gerookt door de dokter. Bovendien werd de bank waarop je moest gaan liggen, niet ontsmet tussen 2 patiënten. Oh en de tafel lag vol bloed van mezelf, maar ik mocht mooi in mijn eigen bloed blijven liggen.

We hebben er uren moeten doorbrengen, omdat de dokter aan het opereren was en er niet efficiënt werd gewerkt (eerst de behandeling, daarna lang wachten op de rekening, enkel cash te betalen + ze hadden geen wisselgeld).

Heel weinig personeel sprak Engels, maar wie Engels kon, was heel vriendelijk + de hechting lijkt goed te zijn gebeurd (daarom toch nog 2 sterren).',
    'Hitna pomoć: jedna mala soba sa lošom higijenom. Na podu su bile misteriozne lokve, a doktor je pušio unutra. Štaviše, kauč na kome je trebalo da ležite nije bio dezinfikovan između dva pacijenta. Oh, i sto je bio prekriven mojom krvlju, ali mi je bilo dozvoljeno da ležim tamo u svojoj krvi.

Morali smo da provodimo sate tamo jer je doktor operisao i rad nije bio efikasan (prvo tretman, zatim dugo čekanje na račun, samo gotovina i bez kusura).

Vrlo malo zaposlenih je govorilo engleski, ali oni koji jesu bili su veoma ljubazni, a šavovi su izgleda urađeni kako treba (otuda i 2 zvezdice).', 'Хитна помоћ: једна мала соба са лошом хигијеном. На поду су биле мистериозне локве, а доктор је пушио унутра. Штавише, кауч на коме је требало да лежите није био дезинфикован између два пацијента. Ох, и сто је био прекривен мојом крвљу, али ми је било дозвољено да лежим тамо у својој крви.

Морали смо да проводимо сате тамо јер је доктор оперисао и рад није био ефикасан (прво третман, затим дуго чекање на рачун, само готовина и без кусурa).

Врло мало запослених је говорило енглески, али они који јесу били су веома љубазни, а шавови су изгледа урађени како треба (отуда и 2 звездице).', NULL, NULL, NULL, NULL,
    0, '2023-09-11 11:37:53'),

(@user_zorica_starcevic_radujko, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0ZnjOUwIWEcRT9kSLJHCxEY/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ5OXI2UU9nEAE',
    4, 'bs', 'Sve pohvale za dr.Mirka  Terzica i dr.Vladimira Djukovica.Ljubaznost,strucnost,profesionalnost,posvecenost.Sa ovakvim mladim lekarima ima nade za Pljevlja i zdravstveni sistem Crne Gore',
    'Sve pohvale za dr Mirka Terzića i dr Vladimira Đukovića. Ljubaznost, stručnost, profesionalizam, posvećenost. Sa ovako mladim lekarima, ima nade za Pljevlja i crnogorski zdravstveni sistem.', 'Све похвале за др Мирка Терзића и др Владимира Ђуковића. Љубазност, стручност, професионализам, посвећеност. Са овако младим лекарима, има наде за Пљевља и црногорски здравствени систем.', NULL, NULL, NULL, NULL,
    0, '2024-03-16 15:37:30'),

(@user_vasko_v, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0ZnjOUwIWEcRT9kSLJHCxEY/reviews/ChdDSUhNMG9nS0VJQ0FnSUN1OU1HUnZRRRAB',
    1, 'bs', 'Dao bih nulu da moze ... ovdje covjek izgubi pola dana cekajuci',
    'Dao bih mu nulu kad bih mogao... ovde gubiš pola dana čekajući.', 'Дао бих му нулу кад бих могао... овде губиш пола дана чекајући.', NULL, NULL, NULL, NULL,
    0, '2022-07-22 09:21:58'),

(@user_milorad_kotlaja, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0ZnjOUwIWEcRT9kSLJHCxEY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNncThQbHp3RRAB',
    5, 'bs', 'Lokacija super',
    'Lokacija je odlična.', 'Локација је одлична.', NULL, NULL, NULL, NULL,
    0, '2015-06-15 19:22:08'),

(@user_sandra_ljubojevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0ZnjOUwIWEcRT9kSLJHCxEY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25aR1NUSlplWGxoWjNWc1VYbzFNbTh4UlRGM1NsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-07 22:14:47')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
