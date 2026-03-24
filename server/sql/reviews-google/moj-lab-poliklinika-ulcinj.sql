-- Insert Google Maps reviews for Moj Lab Poliklinika Ulcinj
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/moj-lab-poliklinika-ulcinj.sql

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = 8;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mehmet Oral Alp', 'https://lh3.googleusercontent.com/a/ACg8ocKfwgZg-Py3SQa9ccedcZoqJpEknXEoA1_d2UnrHItnFRIK=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/108634038796767774949/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108634038796767774949/reviews');
SET @user_mehmet_oral_alp = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108634038796767774949/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Minga Oida', 'https://lh3.googleusercontent.com/a/ACg8ocL1e_DYZesqSIl1rTPz-LyLLFUPOXs09Ium8BMG2hRnuWakPg=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/118333835332348137563/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118333835332348137563/reviews');
SET @user_minga_oida = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118333835332348137563/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sladjana Medenica', 'https://lh3.googleusercontent.com/a/ACg8ocKUfe-X9zyG9ZtaRM5uM-g_2dpVFoBvFHT7T9BCHebP228Wzw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106778419991912359195/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106778419991912359195/reviews');
SET @user_sladjana_medenica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106778419991912359195/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mevlida Hrapovic', 'https://lh3.googleusercontent.com/a/ACg8ocLRlloldPLCIIM4EUKhweqXAYWUBb3VAkzxssUkXXhqvBIxsw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113765842762380723907/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113765842762380723907/reviews');
SET @user_mevlida_hrapovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113765842762380723907/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Linda Marniković', 'https://lh3.googleusercontent.com/a-/ALV-UjXUzjW9b07MX81tIN1TE1N8Mdr2vEbpA3HYgahHq_RsJp285NrB9A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106518358377599423164/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106518358377599423164/reviews');
SET @user_linda_marnikovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106518358377599423164/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Ivana', 'https://lh3.googleusercontent.com/a/ACg8ocKejZfBzDR0LPu7LI7tXHib7YBsBi5fgwFpgKWI1ZE-gNMZMw=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/107861321493539505181/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107861321493539505181/reviews');
SET @user_ivana_ivana = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107861321493539505181/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Samra Erzanova', 'https://lh3.googleusercontent.com/a-/ALV-UjXmDwDVHMAfW9CPYjwo3M0aDbvi-EfRmH2Awpheqc0mJofDTIY=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/100494265708238918086/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100494265708238918086/reviews');
SET @user_samra_erzanova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100494265708238918086/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Selver Armani', 'https://lh3.googleusercontent.com/a/ACg8ocJfHzkHSD9rOnc76XVdkFUVOobZ5U7Ni-BzPPVUA8hezKa_Jg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110784637941519701019/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110784637941519701019/reviews');
SET @user_selver_armani = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110784637941519701019/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_mehmet_oral_alp, @clinic_id, NULL, 'google_maps',
    'places/ChIJwT5VzoQTThMRvDr3HmXNgKg/reviews/ChZDSUhNMG9nS0VJQ0FnSURuamVLYkt3EAE',
    1, 'en', 'Another so called clinic without a doctor, of even have intention to call a doctor in. Instead of that sending the patient to useless government hospital.
I wonder how do you make money, I came there for attention to pay for your services, hoping to get some attention but been suggested to go local hospital.',
    'Još jedna takozvana klinika bez doktora, koji čak nemaju namjeru da pozovu doktora. Umjesto toga šalju pacijenta u beskorisnu državnu bolnicu.
Pitam se kako zarađujete novac, došao sam tamo da platim vaše usluge, nadajući se da ću dobiti pažnju, ali mi je predloženo da odem u lokalnu bolnicu.', 'Још једна такозвана клиника без доктора, који чак немају намјеру да позову доктора. Умјесто тога шаљу пацијента у безбројну државну болницу.
Питам се kako зарађујете новац, дошао сам тамо да платим ваше услуге, надајући се да ћу добити пажњу, али ми је предложено да одем у локалну болницу.', 'Another so called clinic without a doctor, of even have intention to call a doctor in. Instead of that sending the patient to useless government hospital.
I wonder how do you make money, I came there for attention to pay for your services, hoping to get some attention but been suggested to go local hospital.', 'Ещё одна так называемая клиника без врача, которые даже не намерены вызвать врача. Вместо этого отправляют пациента в бесполезную государственную больницу.
Интересно, как вы зарабатываете деньги — я пришёл туда, чтобы заплатить за ваши услуги, надеясь получить помощь, но мне предложили обратиться в местную больницу.', 'Noch eine sogenannte Klinik ohne Arzt, die nicht einmal beabsichtigt, einen Arzt hinzuzurufen. Stattdessen schicken sie den Patienten ins nutzlose staatliche Krankenhaus.
Ich frage mich, wie Sie Geld verdienen — ich kam dorthin, um für Ihre Dienste zu bezahlen, in der Hoffnung, Aufmerksamkeit zu bekommen, aber mir wurde empfohlen, ins örtliche Krankenhaus zu gehen.', 'Doktor çağırmaya bile niyetleri olmayan, sözde bir klinik daha. Bunun yerine hastayı işe yaramaz devlet hastanesine gönderiyorlar.
Paranızı nasıl kazandığınızı merak ediyorum — hizmetleriniz için ödeme yapmak amacıyla oraya gittim, biraz ilgi görmeyi umdum ama yerel hastaneye gitmem önerildi.',
    0, '2025-03-24 00:00:00'),

(@user_minga_oida, @clinic_id, NULL, 'google_maps',
    'places/ChIJwT5VzoQTThMRvDr3HmXNgKg/reviews/ChdDSUhNMG9nS0VJQ0FnSUNIME11cjlRRRAB',
    5, 'de', 'Super Ärzte, super nette Mitarbeiter. Wir kamen mit hohem Fieber und Husten. Bekamen telefonisch sofort einen Termin, waren dann gleich dran ohne Wartezeit. Der Kinderarzt hat uns nach der Untersuchung dringlich empfohlen in eine Klinik mit Röntgengerät zu fahren. Super wichtig, wir sind so dankbar. Wie sich herausstellte hatte er eine schwere Lungenentzündung. Die Klinik wo er uns hingeschickt hat und empfohlen hat, war ebenfalls ein super Tip. Kein Fokus auf Geld verdienen, sondern auf das Wohl des Kindes! Danke dafür! Alles sehr sauber und neu dort. Absolute Empfehlung',
    'Odlični doktori, super ljubazno osoblje. Došli smo sa visokom temperaturom i kašljem. Odmah smo telefonom dobili termin i ušli bez čekanja. Pedijatar nam je nakon pregleda hitno preporučio da odemo u kliniku sa rentgenskim aparatom. Izuzetno važno, toliko smo zahvalni. Ispostavilo se da je imao tešku upalu pluća. Klinika u koju nas je uputio bila je odličan savjet. Bez fokusa na zaradu, već na dobrobit djeteta! Hvala za to! Sve je veoma čisto i novo tamo. Apsolutna preporuka.', 'Одлични доктори, супер љубазно особље. Дошли смо са високом температуром и кашљем. Одмах смо телефоном добили термин и ушли без чекања. Педијатар нам је након прегледа хитно препоручио да одемо у клинику са рентгенским апаратом. Изузетно важно, толико смо захвални. Испоставило се да је имао тешку упалу плућа. Клиника у коју нас је упутио била је одличан савјет. Без фокуса на зараду, него на добробит дјетета! Хвала за то! Све је веома чисто и ново тамо. Апсолутна препорука.', 'Great doctors, super friendly staff. We came with high fever and cough. We immediately got an appointment by phone and were seen right away without waiting. After the examination, the pediatrician urgently recommended that we go to a clinic with an X-ray machine. Super important, we are so grateful. It turned out he had severe pneumonia. The clinic he sent us to was also a great tip. No focus on making money, but on the well-being of the child! Thank you for that! Everything very clean and new there. Absolute recommendation.', 'Отличные врачи, очень дружелюбный персонал. Мы пришли с высокой температурой и кашлем. Сразу получили запись по телефону и вошли без очереди. Педиатр после осмотра срочно рекомендовал поехать в клинику с рентгеновским аппаратом. Очень важно, мы так благодарны. Оказалось, у него была тяжёлая пневмония. Клиника, в которую он нас направил, тоже оказалась отличным советом. Без акцента на заработок, а на благополучие ребёнка! Спасибо за это! Всё очень чисто и ново там. Абсолютная рекомендация.', 'Super Ärzte, super nette Mitarbeiter. Wir kamen mit hohem Fieber und Husten. Bekamen telefonisch sofort einen Termin, waren dann gleich dran ohne Wartezeit. Der Kinderarzt hat uns nach der Untersuchung dringlich empfohlen in eine Klinik mit Röntgengerät zu fahren. Super wichtig, wir sind so dankbar. Wie sich herausstellte hatte er eine schwere Lungenentzündung. Die Klinik wo er uns hingeschickt hat und empfohlen hat, war ebenfalls ein super Tip. Kein Fokus auf Geld verdienen, sondern auf das Wohl des Kindes! Danke dafür! Alles sehr sauber und neu dort. Absolute Empfehlung', 'Harika doktorlar, süper güler yüzlü personel. Yüksek ateş ve öksürükle geldik. Telefonla hemen randevu aldık ve beklemeden içeri girdik. Çocuk doktoru muayeneden sonra röntgen cihazı olan bir kliniğe gitmemizi acilen tavsiye etti. Çok önemli, çok minnetarız. Meğer ağır zatürre geçiriyormuş. Bizi gönderdiği klinik de harika bir tavsiyeydi. Para kazanmaya değil, çocuğun iyiliğine odaklanma! Bunun için teşekkürler! Her şey çok temiz ve yeni. Kesinlikle tavsiye edilir.',
    0, '2025-03-24 00:00:00'),

(@user_sladjana_medenica, @clinic_id, NULL, 'google_maps',
    'places/ChIJwT5VzoQTThMRvDr3HmXNgKg/reviews/ChdDSUhNMG9nS0VJQ0FnSUM3bHRTUzJBRRAB',
    5, 'hr', 'Sve preporuke!',
    'Sve preporuke!', 'Све препоруке!', 'Highly recommended!', 'Всячески рекомендую!', 'Absolute Empfehlung!', 'Kesinlikle tavsiye edilir!',
    0, '2025-03-24 00:00:00'),

(@user_mevlida_hrapovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJwT5VzoQTThMRvDr3HmXNgKg/reviews/ChdDSUhNMG9nS0VJQ0FnSURibl9DZGhBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_linda_marnikovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJwT5VzoQTThMRvDr3HmXNgKg/reviews/ChZDSUhNMG9nS0VJQ0FnSUREbm83d0tnEAE',
    5, 'hr', 'Odlican pedijatar, sve preporuke.',
    'Odlican pedijatar, sve preporuke.', 'Одличан педијатар, све препоруке.', 'Excellent pediatrician, highly recommended.', 'Отличный педиатр, всячески рекомендую.', 'Ausgezeichneter Kinderarzt, absolute Empfehlung.', 'Mükemmel çocuk doktoru, kesinlikle tavsiye edilir.',
    0, '2025-03-24 00:00:00'),

(@user_ivana_ivana, @clinic_id, NULL, 'google_maps',
    'places/ChIJwT5VzoQTThMRvDr3HmXNgKg/reviews/ChZDSUhNMG9nS0VJQ0FnSURwbXFtQ2VnEAE',
    5, 'hr', 'Mnogo hvala pedijatru i sestri na strucnosti, ljubaznosti i strpljenju. Klinika za svaku preporuku.',
    'Mnogo hvala pedijatru i sestri na strucnosti, ljubaznosti i strpljenju. Klinika za svaku preporuku.', 'Много хвала педијатру и сестри на стручности, љубазности и стрпљењу. Клиника за сваку препоруку.', 'Many thanks to the pediatrician and nurse for their professionalism, kindness and patience. A clinic to be highly recommended.', 'Большое спасибо педиатру и медсестре за профессионализм, любезность и терпение. Клиника, достойная всяческих рекомендаций.', 'Vielen Dank an den Kinderarzt und die Schwester für ihre Fachkompetenz, Freundlichkeit und Geduld. Eine Klinik, die uneingeschränkt empfohlen werden kann.', 'Uzmanlıkları, nezaketleri ve sabırları için çocuk doktoruna ve hemşireye çok teşekkürler. Her anlamda tavsiye edilen bir klinik.',
    0, '2024-03-24 00:00:00'),

(@user_samra_erzanova, @clinic_id, NULL, 'google_maps',
    'places/ChIJwT5VzoQTThMRvDr3HmXNgKg/reviews/ChZDSUhNMG9nS0VJQ0FnSUNwN1plcVhnEAE',
    5, 'de', 'Ich war heute hier in dieser Polyklinik wegen Ohrenschmerzen.
Der Anruf wurde rasch entgegengenommen und die Mitarbeiterin wahr sehr freundlich und gab mir sofort einen Termin.
Ich ging hin und wurde sehr freundlich empfangen, durfte nach der Aufnahme sofort zur Ärztin. Diese war sehr kompetent und freundlich und verschrieb mir die nötigen Medikamente. Sehr empfehlenswert. Bravo.',
    'Danas sam bio u ovoj poliklinici zbog bolova u ušima.
Poziv je brzo primljen i radnica je bila veoma ljubazna i odmah mi dala termin.
Otišao sam tamo i bio sam veoma ljubazno dočekan, mogao sam odmah nakon prijema da vidim doktorku. Ona je bila veoma kompetentna i ljubazna i propisala mi je potrebne lijekove. Veoma preporučujem. Bravo.', 'Данас сам био у овој поликлиници zbog болова у ушима.
Позив је брзо примљен и раднице је биле веома љубазне и одмах ми дале термин.
Отишао сам тамо и дочекан сам веома љубазно, могао сам одмах након пријема да видим докторку. Она је веома компетентна и љубазна и прописала ми је потребне лијекове. Веома препоручујем. Браво.', 'I was here today at this polyclinic due to ear pain.
The call was answered quickly and the staff member was very friendly and immediately gave me an appointment.
I went there and was welcomed very warmly, I was able to see the doctor immediately after registration. She was very competent and friendly and prescribed me the necessary medication. Highly recommended. Bravo.', 'Сегодня я был в этой поликлинике из-за боли в ушах.
Звонок был быстро принят, и сотрудница была очень дружелюбна и сразу же назначила мне приём.
Я пришёл туда и был очень тепло принят, сразу после регистрации смог попасть к врачу. Она была очень компетентна и дружелюбна и выписала мне необходимые лекарства. Очень рекомендую. Браво.', 'Ich war heute hier in dieser Polyklinik wegen Ohrenschmerzen.
Der Anruf wurde rasch entgegengenommen und die Mitarbeiterin wahr sehr freundlich und gab mir sofort einen Termin.
Ich ging hin und wurde sehr freundlich empfangen, durfte nach der Aufnahme sofort zur Ärztin. Diese war sehr kompetent und freundlich und verschrieb mir die nötigen Medikamente. Sehr empfehlenswert. Bravo.', 'Bugün kulak ağrısı nedeniyle bu poliklinikteyim.
Arama hızla yanıtlandı ve çalışan çok güler yüzlüydü ve hemen bir randevu verdi.
Oraya gittim ve çok sıcak karşılandım, kayıt sonrası hemen doktora geçebildim. O çok yetkin ve dostaneydi ve gerekli ilaçları yazdı. Çok tavsiye edilir. Bravo.',
    0, '2024-03-24 00:00:00'),

(@user_selver_armani, @clinic_id, NULL, 'google_maps',
    'places/ChIJwT5VzoQTThMRvDr3HmXNgKg/reviews/ChZDSUhNMG9nS0VJQ0FnSUNwMXR1UlJBEAE',
    5, 'hr', 'Jako ljubazno osoblje i pristupačne cijene
Sve preporuke',
    'Jako ljubazno osoblje i pristupačne cijene
Sve preporuke', 'Веома љубазно особље и приступачне цијене
Све препоруке', 'Very friendly staff and affordable prices
Highly recommended', 'Очень дружелюбный персонал и доступные цены
Всячески рекомендую', 'Sehr freundliches Personal und günstige Preise
Absolut empfehlenswert', 'Çok güler yüzlü personel ve uygun fiyatlar
Kesinlikle tavsiye edilir',
    0, '2024-03-24 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
