-- Insert Google Maps reviews for Poliklinika DaVinci
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/poliklinika-da-vinci-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'poliklinika-da-vinci-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_vladimir_vuceljic = (SELECT id FROM doctors WHERE slug = 'vladimir-vuceljic');
SET @doctor_predrag_aleksic = (SELECT id FROM doctors WHERE slug = 'predrag-aleksic');
SET @doctor_mihajlo_bezmarevic = (SELECT id FROM doctors WHERE slug = 'mihajlo-bezmarevic');
SET @doctor_neven_vavic = (SELECT id FROM doctors WHERE slug = 'neven-vavic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mary K.', 'https://lh3.googleusercontent.com/a-/ALV-UjV5fX7NAUJBtKZA3pDOBxufmikrdAq80Y1cUixNVFdt72SPgScq=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106866448340985692286/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106866448340985692286/reviews');
SET @user_mary_k = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106866448340985692286/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Glogovac', 'https://lh3.googleusercontent.com/a/ACg8ocIE4MPlK3Yu5b_7TyDde0LUH3HCBSOyuLugj8j8TdeqPb9zGQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/108606907517738177947/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108606907517738177947/reviews');
SET @user_jelena_glogovac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108606907517738177947/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mladen Maljukanovic', 'https://lh3.googleusercontent.com/a/ACg8ocIp9MmDpwthph44hXfDpuL-w_gt0t8PU10hMbWbv9kNBTDbFg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/117675729955265648587/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117675729955265648587/reviews');
SET @user_mladen_maljukanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117675729955265648587/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Stanisic', 'https://lh3.googleusercontent.com/a-/ALV-UjWrXYvIg5utpIBYC2KIdUqMglmGpTe_7CoQrAICU8Eko8Pu3EFZ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/116267573951209135008/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116267573951209135008/reviews');
SET @user_jelena_stanisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116267573951209135008/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milos Rakocevic', 'https://lh3.googleusercontent.com/a-/ALV-UjUhRTswMHCKodJoVY2BpZ888uKE5asJQOzBGgw7Nc9CQ3Svzv12bA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107662330513207434504/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107662330513207434504/reviews');
SET @user_milos_rakocevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107662330513207434504/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radmila Vlajic', 'https://lh3.googleusercontent.com/a-/ALV-UjXVfcn56YAHt1FFFQoWaTiWGP3D1TGOEW8Rc94HCwWa7Vj0GPV8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100038661833896670199/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100038661833896670199/reviews');
SET @user_radmila_vlajic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100038661833896670199/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danilo Knezevic', 'https://lh3.googleusercontent.com/a-/ALV-UjV-sdJiVne1G88G2M4J6jGL7X9G3lhLBfR0rcuDR1gCsVOfntEY=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113998314377361420352/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113998314377361420352/reviews');
SET @user_danilo_knezevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113998314377361420352/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'İsmet Canpolat', 'https://lh3.googleusercontent.com/a-/ALV-UjUAh8B39e_QX3WtjDDehP6yoF78bapfZ1APVuM14cjCzuAyUVyT=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100808179851474712066/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100808179851474712066/reviews');
SET @user_smet_canpolat = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100808179851474712066/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natasa', 'https://lh3.googleusercontent.com/a-/ALV-UjUpdTQTEz8YwHp9RN9kMC4qVASZNyHoaRU3GIF1w9QJOIcnWjM=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113162818075291182007/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113162818075291182007/reviews');
SET @user_natasa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113162818075291182007/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milanka Mrvaljević', 'https://lh3.googleusercontent.com/a/ACg8ocInEZiMBfToLSXjOplCGgL9Y4SYfxXSBPHm67BazDCTIkq-WA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117210105257689689744/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117210105257689689744/reviews');
SET @user_milanka_mrvaljevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117210105257689689744/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mili Chili', 'https://lh3.googleusercontent.com/a/ACg8ocLyfJbOUsAINagJK54U3rl6xtyarL3ZR6WyWC9wBRuucxox4A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116353798316069569167/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116353798316069569167/reviews');
SET @user_mili_chili = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116353798316069569167/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Bulatovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWnhdtqp9v1j5N3UaDvMS6gt9bM2Jef_C5Ip3_tvkI3VlTh3mqP=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102030978267959904708/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102030978267959904708/reviews');
SET @user_marko_bulatovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102030978267959904708/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Butua_Connect', 'https://lh3.googleusercontent.com/a-/ALV-UjVCPpq6N5CljcJ_rMMEFKHXfiAWRpUZicyByVBPowPW5ISXLjc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108920308426762222356/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108920308426762222356/reviews');
SET @user_butuaconnect = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108920308426762222356/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljubomir Djukanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVqzIakCX9VboFer2oyBanW1O8ADN22utjNASyADD3t-Pl9XVeH=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106983816801851448952/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106983816801851448952/reviews');
SET @user_ljubomir_djukanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106983816801851448952/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_mary_k, @clinic_id, NULL, 'google_maps',
    'places/ChIJkc08ut3rTRMRWn6Gc02KfjM/reviews/ChdDSUhNMG9nS0VJQ0FnSUNEN0tqYzBRRRAB',
    5, 'sr', '🙏🩷',
    '🙏🩷', '🙏🩷', NULL, NULL, NULL, NULL,
    0, '2024-03-25 11:59:50'),

(@user_jelena_glogovac, @clinic_id, @doctor_mihajlo_bezmarevic, 'google_maps',
    'places/ChIJkc08ut3rTRMRWn6Gc02KfjM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5YVkwTTNTMkZGTUZkdWRFMTBVV1JMVG14RGNtYxAB',
    5, 'hr', 'Najbolji tim stručnjaka u svome poslu. Iznenađenja sam koliko sam lijepo i ljubazno primljena na odeljenje. Doktor Mihajlo me je dobro operisao da već sutra dan mogu da idem kući,a sestra Nataša je toliko ljubazna i dobra da nemam riječi kojim se mogu opisati njena pažnja i dobrota. Hvala vam dobri ljudi,svako dobro vam želim u daljem radu...♡♡♡♡♡♡',
    'Najbolji tim stručnjaka u svojoj oblasti. Iznenadio sam se kako sam lepo i ljubazno primljen u odeljenju. Doktor Mihajlo me je tako dobro operisao da sutradan mogu da idem kući, a medicinska sestra Nataša je toliko ljubazna i dobra da nemam reči da opišem njenu pažnju i ljubaznost. Hvala vam, dobri ljudi, želim vam sve najbolje u daljem radu...♡♡♡♡♡♡', 'Најбољи тим стручњака у својој области. Изненадио сам се како сам лепо и љубазно примљен у одељењу. Доктор Михајло ме је тако добро оперисао да сутрадан могу да идем кући, а медицинска сестра Наташа је толико љубазна и добра да немам речи да опишем њену пажњу и љубазност. Хвала вам, добри људи, желим вам све најбоље у даљем раду...♡♡♡♡♡♡', NULL, NULL, NULL, NULL,
    0, '2025-10-20 05:31:07'),

(@user_mladen_maljukanovic, @clinic_id, @doctor_predrag_aleksic, 'google_maps',
    'places/ChIJkc08ut3rTRMRWn6Gc02KfjM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tZelVWWk9TRW8xUlZsaFoyUkNhV0pGU1RCZlkyYxAB',
    5, 'en', 'Courtesy and above all professionalism, are the first thought when you come into contact with the staff that make up this institution. Great praise to the team of doctors of the Urology department headed bay Professors Predrag Aleksic and Aleksandar Magdalenic, and especially Dr. LJubica Radunovic,top anesthesiologist, for the excellent job of BHP operation. Medical staff services at a very enviable level. I would to take this opportunity to thank them for their professional work during my post-operative days at the Polyclinic. Thank you Natasa, Rado i Sladjana!',
    'Ljubaznost i iznad svega profesionalizam, prva su pomisao kada dođete u kontakt sa osobljem koje čine ovu instituciju. Velike pohvale timu lekara Odeljenja urologije na čelu sa profesorima Predragom Aleksićem i Aleksandrom Magdalenićem, a posebno dr Ljubici Radunović, vrhunskom anesteziologu, za odlično obavljenu operaciju BHP. Usluge medicinskog osoblja na veoma zavidnom nivou. Iskoristio bih priliku da im se zahvalim na profesionalnom radu tokom mojih postoperativnih dana u Poliklinici. Hvala Nataša, Rado i Slađana!', 'Љубазност и изнад свега професионализам, прва су помисао када дођете у контакт са особљем које чине ову институцију. Велике похвале тиму лекара Одељења урологије на челу са професорима Предрагом Алексићем и Александром Магдаленићем, а посебно др Љубици Радуновић, врхунском анестезиологу, за одлично обављену операцију БХП. Услуге медицинског особља на веома завидном нивоу. Искористио бих прилику да им се захвалим на професионалном раду током мојих постоперативних дана у Поликлиници. Хвала Наташа, Радо и Слађана!', 'Courtesy and above all professionalism, are the first thought when you come into contact with the staff that make up this institution. Great praise to the team of doctors of the Urology department headed bay Professors Predrag Aleksic and Aleksandar Magdalenic, and especially Dr. LJubica Radunovic,top anesthesiologist, for the excellent job of BHP operation. Medical staff services at a very enviable level. I would to take this opportunity to thank them for their professional work during my post-operative days at the Polyclinic. Thank you Natasa, Rado i Sladjana!', NULL, NULL, NULL,
    0, '2025-10-05 17:05:00'),

(@user_jelena_stanisic, @clinic_id, @doctor_vladimir_vuceljic, 'google_maps',
    'places/ChIJkc08ut3rTRMRWn6Gc02KfjM/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GR2JFdFRWalZFUzJacmVWWkRUbUpXTkRjMVNFRRAB',
    5, 'bs', 'Velike pohvale za doktora Vladimira Vuceljica i cijelom timu.Profesionalni, ljubazni i uvijek spremni da pomognu.Klinika je cista, moderna i prijatna, a cijeli tim uliva povjerenje od samog ulaska. Preporučujem od srca!',
    'Velike pohvale za dr Vladimira Vučeljića i ceo tim. Profesionalni, ljubazni i uvek spremni da pomognu. Klinika je čista, moderna i prijatna, a ceo tim uliva poverenje od trenutka kada uđete. Preporučujem ga od sveg srca!', 'Велике похвале за др Владимира Вучељића и цео тим. Професионални, љубазни и увек спремни да помогну. Клиника је чиста, модерна и пријатна, а цео тим улива поверење од тренутка када уђете. Препоручујем га од свег срца!', NULL, NULL, NULL, NULL,
    0, '2025-11-26 06:04:58'),

(@user_milos_rakocevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJkc08ut3rTRMRWn6Gc02KfjM/reviews/ChZDSUhNMG9nS0VJQ0FnTURvNlpUYlJ3EAE',
    1, 'bs', 'Prije nego što pređem na konkretne detalje žalbe, želim istaći da smo u Vašoj klinici imali i veoma pozitivna iskustva sa pojedinim članovima osoblja. Mlada recepcionerka (čije ime, nažalost, nijesam zapamtio) pokazala je izuzetnu profesionalnost, ljubaznost i empatiju, i zaslužuje svaku pohvalu. Takođe, sestra koja je pacijentu postavila infuziju bila je izuzetno stručna i ljubazna – upravo su to osobine koje bi trebalo da budu uzor svakom zdravstvenom radniku, uključujući i njihovu nadređenu.

Nažalost, iskustvo sa glavnom sestrom Marinom bilo je potpuno suprotno.Prilikom dolaska u ordinaciju radi primanja terapije, kao prevodilac i pratnja stranom pacijentu, naišli smo na krajnje nepristojan pristup. Sestra Marina je, bez da mi se obrati, stala pored mene i imperativnim tonom rekla svojoj koleginici:"Zašto je on ovdje? U čekaonicu! Možemo se mi sporazumjeti."

Takav ton, neprikladan i za veterinarske ordinacije, a kamoli za zdravstvenu ustanovu koja njeguje visok nivo usluge, izazvao je osjećaj poniženja i nelagode.

Moram naglasiti da ovakav tretman nije bio usmjeren prema lokalnim pacijentima, već isključivo prema stranom pacijentu i meni kao njegovoj pratnji. Ukoliko glavna sestra gaji određene predrasude prema strancima, bilo bi profesionalno i civilizacijski minimum da ih na radnom mjestu ne ispoljava.

Neprofesionalno ponašanje se nastavilo i prilikom naplate usluga. Ispred prepunog čekaonice, sestra Marina je komentarisala obračun cijena sa koleginicom neprimjerenim replikama poput:"Vidi šta si mi ovdje napravila", "Sačekajte...", stvarajući atmosferu nervoze i haosa.

Pacijenti u Vašu ustanovu dolaze sa svojim zdravstvenim problemima, a osnovni nivo poštovanja i smirenosti je nešto što im se mora obezbijediti. Umjesto toga, sestra Marina je odbijala da uspostavi direktnu komunikaciju sa mnom i pacijentom, nastavljajući da o nama govori u trećem licu, pred nama, kao da nismo prisutni. Na moje upozorenje da može da mi se obrati direktno, njeno ponašanje postalo je još neprijatnije.Pored svega, i kada se ispostavilo da postoji razlika u cijeni administracije terapije (10 umjesto 20 eura), sestra Marina je situaciju predstavila na način koji je implicirao da nam ona lično "poklanja" razliku, uz komentar pred svim prisutnima da "više neće moći tako". Kada sam ponudio da odmah platim razliku, upitala me je:

"Zašto vi ne idete u Codru kad ste njihovi pacijenti, nego ste došli ovdje?"

Smisao ove žalbe nije samo u ličnom nezadovoljstvu.
Ovakav nivo (ne)profesionalizma nanosi ozbiljnu štetu ugledu Vaše ustanove.Ovo iskustvo ću pretočiti u javnu Google recenziju, smatrajući da drugi potencijalni pacijenti imaju pravo da budu informisani.

Iskreno se nadam da ćete ubuduće prilikom kadrovskih odluka više pažnje posvetiti ljudskim kvalitetima osoblja, a ne samo formalnim stručnim kvalifikacijama. Takođe, nadam se da ćete prepoznati vrijedne članove Vašeg tima i adekvatno ih nagraditi. Nadam se, takođe, da ćete pronaći kurs iz Vladanja i Osnovnog Vaspitanja na koji ćete upisati Marinu.',
    'Prije nego što pređem na konkretne detalje žalbe, želim istaći da smo u Vašoj klinici imali i veoma pozitivna iskustva sa pojedinim članovima osoblja. Mlada recepcionerka (čije ime, nažalost, nijesam zapamtio) pokazala je izuzetnu profesionalnost, ljubaznost i empatiju, i zaslužuje svaku pohvalu. Takođe, sestra koja je pacijentu postavila infuziju bila je izuzetno stručna i ljubazna – upravo su to osobine koje bi trebalo da budu uzor svakom zdravstvenom radniku, uključujući i njihovu nadređenu.

Nažalost, iskustvo sa glavnom sestrom Marinom bilo je potpuno suprotno.Prilikom dolaska u ordinaciju radi primanja terapije, kao prevodilac i pratnja stranom pacijentu, naišli smo na krajnje nepristojan pristup. Sestra Marina je, bez da mi se obrati, stala pored mene i imperativnim tonom rekla svojoj koleginici:"Zašto je on ovdje? U čekaonicu! Možemo se mi sporazumjeti."

Takav ton, neprikladan i za veterinarske ordinacije, a kamoli za zdravstvenu ustanovu koja njeguje visok nivo usluge, izazvao je osjećaj poniženja i nelagode.

Moram naglasiti da ovakav tretman nije bio usmjeren prema lokalnim pacijentima, već isključivo prema stranom pacijentu i meni kao njegovoj pratnji. Ukoliko glavna sestra gaji određene predrasude prema strancima, bilo bi profesionalno i civilizacijski minimum da ih na radnom mjestu ne ispoljava.

Neprofesionalno ponašanje se nastavilo i prilikom naplate usluga. Ispred prepunog čekaonice, sestra Marina je komentarisala obračun cijena sa koleginicom neprimjerenim replikama poput:"Vidi šta si mi ovdje napravila", "Sačekajte...", stvarajući atmosferu nervoze i haosa.

Pacijenti u Vašu ustanovu dolaze sa svojim zdravstvenim problemima, a osnovni nivo poštovanja i smirenosti je nešto što im se mora obezbijediti. Umjesto toga, sestra Marina je odbijala da uspostavi direktnu komunikaciju sa mnom i pacijentom, nastavljajući da o nama govori u trećem licu, pred nama, kao da nismo prisutni. Na moje upozorenje da može da mi se obrati direktno, njeno ponašanje postalo je još neprijatnije.Pored svega, i kada se ispostavilo da postoji razlika u cijeni administracije terapije (10 umjesto 20 eura), sestra Marina je situaciju predstavila na način koji je implicirao da nam ona lično "poklanja" razliku, uz komentar pred svim prisutnima da "više neće moći tako". Kada sam ponudio da odmah platim razliku, upitala me je:

"Zašto vi ne idete u Codru kad ste njihovi pacijenti, nego ste došli ovdje?"

Smisao ove žalbe nije samo u ličnom nezadovoljstvu.
Ovakav nivo (ne)profesionalizma nanosi ozbiljnu štetu ugledu Vaše ustanove.Ovo iskustvo ću pretočiti u javnu Google recenziju, smatrajući da drugi potencijalni pacijenti imaju pravo da budu informisani.

Iskreno se nadam da ćete ubuduće prilikom kadrovskih odluka više pažnje posvetiti ljudskim kvalitetima osoblja, a ne samo formalnim stručnim kvalifikacijama. Takođe, nadam se da ćete prepoznati vrijedne članove Vašeg tima i adekvatno ih nagraditi. Nadam se, takođe, da ćete pronaći kurs iz Vladanja i Osnovnog Vaspitanja na koji ćete upisati Marinu.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-04-26 10:42:44'),

(@user_radmila_vlajic, @clinic_id, NULL, 'google_maps',
    'places/ChIJkc08ut3rTRMRWn6Gc02KfjM/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WeWVWQkpYMUU0VFhGalFVTlRlVk5RVDJkb1gwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_danilo_knezevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJkc08ut3rTRMRWn6Gc02KfjM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5UFJrNW5ZbGgwWkZGUlIwNVpVRFJYTmxKak9GRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_smet_canpolat, @clinic_id, NULL, 'google_maps',
    'places/ChIJkc08ut3rTRMRWn6Gc02KfjM/reviews/ChdDSUhNMG9nS0VJQ0FnTUNZMUszTGx3RRAB',
    1, 'en', 'I am writing this review to share a deeply negative experience I had at Davinci Clinic today. I went to the clinic solely to have an asthma serum administered, which had been prescribed to me by a doctor at Codra Hospital.
Unfortunately, my interaction with the head nurse was extremely unpleasant. She was incredibly rude, not just to me but also to my companion who was with me. She questioned why we came to Davinci Clinic instead of going back to Codra Hospital, making comments like, "Why didn\'t you go to Codra then?". This attitude was completely unprofessional and unwelcoming, especially for someone seeking a simple medical service.
Furthermore, I witnessed her treating other staff members in a very poor manner, which appeared to be workplace mobbing. Her behaviour towards both patients and her own colleagues was shocking and created a very uncomfortable and hostile atmosphere.
The level of disrespect was unacceptable. I felt extremely uncomfortable and unwelcome during my short time there. Based on this terrible experience with the head nurse\'s unprofessionalism and poor treatment, I strongly advise potential patients to avoid this clinic. No one should be subjected to such rudeness and unprofessional conduct when seeking medical care. Find another clinic where you will be treated with basic respect and professionalism.',
    NULL, NULL, 'I am writing this review to share a deeply negative experience I had at Davinci Clinic today. I went to the clinic solely to have an asthma serum administered, which had been prescribed to me by a doctor at Codra Hospital.
Unfortunately, my interaction with the head nurse was extremely unpleasant. She was incredibly rude, not just to me but also to my companion who was with me. She questioned why we came to Davinci Clinic instead of going back to Codra Hospital, making comments like, "Why didn\'t you go to Codra then?". This attitude was completely unprofessional and unwelcoming, especially for someone seeking a simple medical service.
Furthermore, I witnessed her treating other staff members in a very poor manner, which appeared to be workplace mobbing. Her behaviour towards both patients and her own colleagues was shocking and created a very uncomfortable and hostile atmosphere.
The level of disrespect was unacceptable. I felt extremely uncomfortable and unwelcome during my short time there. Based on this terrible experience with the head nurse\'s unprofessionalism and poor treatment, I strongly advise potential patients to avoid this clinic. No one should be subjected to such rudeness and unprofessional conduct when seeking medical care. Find another clinic where you will be treated with basic respect and professionalism.', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_natasa, @clinic_id, NULL, 'google_maps',
    'places/ChIJkc08ut3rTRMRWn6Gc02KfjM/reviews/ChdDSUhNMG9nS0VJQ0FnSUNmbkxydXBnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_milanka_mrvaljevi, @clinic_id, @doctor_neven_vavic, 'google_maps',
    'places/ChIJkc08ut3rTRMRWn6Gc02KfjM/reviews/ChdDSUhNMG9nS0VJQ0FnSUN2cWR2b3hnRRAB',
    5, 'bs', 'Najbolji u Podgorici.
Posebne pohvale za dr Nevena Vavića  načelnika Nefroligije na VMA. VRHUNSKI STRUČNJAK.
Iskreno preporučujem svim građanima Crne Gore.
Milanka Mrvaljević,dipl. ecc',
    'Najbolji u Podgorici.
Posebne pohvale za dr Nevena Vavića  načelnika Nefroligije na VMA. VRHUNSKI STRUČNJAK.
Iskreno preporučujem svim građanima Crne Gore.
Milanka Mrvaljević,dipl. ecc', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_mili_chili, @clinic_id, @doctor_vladimir_vuceljic, 'google_maps',
    'places/ChIJkc08ut3rTRMRWn6Gc02KfjM/reviews/ChZDSUhNMG9nS0VJQ0FnSUQzMDZUc013EAE',
    5, 'bs', 'Od svih privatnih klinika, poliklinika, bolnica, nigdje nijesmo naišli na takvu profesionalnost i ljudskost.
Ono čemu smo svjedoci u CG je da platiti zdravstvenu uslugu nije uvijek garancija da ćete u najmanju ruku biti ispoštovani za vaš novac.
Kada pišem ispoštovani, mislim na to da , kad  dođete zbog određenog problema, jasno je u startu mogu li, ili Vam ne mogu pomoći;
Jasno je da ne izmišljaju ništa više od onoga što vam je potrebno- zbog čega ste došli,  kako bi vam uzeli više novca.
Nama se čak i desilo to,  da su nam saopštili kako  postoji mogućnost da se vrati dio novca , a to opet zavisi od toka operacije i postoperativnog oporavka.
Pozdrav za divnog dr Vučeljica, divnog čovjeka / stručnjaka i komplet osoblje poliklinike " DaVinci" ( moramo izdvojiti sestru Dijanu najsjajnije  🌞 sa kojom se prvo susretnete) sa željom da nam budu zdravi, uspješni, kao i da u zdravlju i veselju troše svoj pošteno zarađeni novac🙏🏻❤️!
Poljubac od "male - velike" Mihaele i njene porodice ☺️!',
    'Od svih privatnih klinika, poliklinika, bolnica, nigdje nijesmo naišli na takvu profesionalnost i ljudskost.
Ono čemu smo svjedoci u CG je da platiti zdravstvenu uslugu nije uvijek garancija da ćete u najmanju ruku biti ispoštovani za vaš novac.
Kada pišem ispoštovani, mislim na to da , kad  dođete zbog određenog problema, jasno je u startu mogu li, ili Vam ne mogu pomoći;
Jasno je da ne izmišljaju ništa više od onoga što vam je potrebno- zbog čega ste došli,  kako bi vam uzeli više novca.
Nama se čak i desilo to,  da su nam saopštili kako  postoji mogućnost da se vrati dio novca , a to opet zavisi od toka operacije i postoperativnog oporavka.
Pozdrav za divnog dr Vučeljica, divnog čovjeka / stručnjaka i komplet osoblje poliklinike " DaVinci" ( moramo izdvojiti sestru Dijanu najsjajnije  🌞 sa kojom se prvo susretnete) sa željom da nam budu zdravi, uspješni, kao i da u zdravlju i veselju troše svoj pošteno zarađeni novac🙏🏻❤️!
Poljubac od "male - velike" Mihaele i njene porodice ☺️!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_marko_bulatovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJkc08ut3rTRMRWn6Gc02KfjM/reviews/ChdDSUhNMG9nS0VJQ0FnSUNYcXZIMTFBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_butuaconnect, @clinic_id, NULL, 'google_maps',
    'places/ChIJkc08ut3rTRMRWn6Gc02KfjM/reviews/ChdDSUhNMG9nS0VJQ0FnSUMtejlLcTNBRRAB',
    2, 'bs', 'Preko volje dr pogledao par minuta i rekao sve u redu, a bolovi koje imam su se nastavili. Ne bih se bez razloga obratio ljekaru.',
    'Preko volje dr pogledao par minuta i rekao sve u redu, a bolovi koje imam su se nastavili. Ne bih se bez razloga obratio ljekaru.', NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_ljubomir_djukanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJkc08ut3rTRMRWn6Gc02KfjM/reviews/ChdDSUhNMG9nS0VJQ0FnSUMycUo3dnlRRRAB',
    5, 'bs', 'Iskrena i od srca preporuka. Izuzetno sam prijatno iznenadjen od pazljivog i ljubaznog medicinskog osoblja do doktorske strucnosti i posvecenosti poslu. Posebno bih pohvalio hirurga dr Ostojica ciju strucnost i entuzijazam je tesko rijecima opisati.',
    'Iskrena i od srca preporuka. Izuzetno sam prijatno iznenadjen od pazljivog i ljubaznog medicinskog osoblja do doktorske strucnosti i posvecenosti poslu. Posebno bih pohvalio hirurga dr Ostojica ciju strucnost i entuzijazam je tesko rijecima opisati.', NULL, NULL, NULL, NULL, NULL,
    3, '2022-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
