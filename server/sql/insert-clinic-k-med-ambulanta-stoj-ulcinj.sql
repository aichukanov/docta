-- ═══════════════════════════════════════════════════════════════════════════
-- K-med Ambulanta Štoj (Ulcinj) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-k-med-ambulanta-stoj-ulcinj.sql
-- Затем: server/sql/insert-clinic-k-med-ambulanta-stoj-ulcinj-services.sql
-- Запись импорта: data/clinic-imports/k-med-ambulanta-stoj-ulcinj.json. Подволна 2d, агент T.
-- 
-- Источники (собрано 2026-10-09, curl с браузерным UA): https://kmed.me/ (одностраничник, modified 2025-11-26),
-- точка «K - Med Štoj — Donji Štoj, Centar Ulcinj, 08 - 21 h, +382 63 207 706», «O nama»: «… i Štoju (na Velikoj plaži) u Ulcinju».
-- data/google-places/ulcinj/k-med-ambulanta-shtoj.json — place_id, координаты 41.9036969 / 19.3029368 (сайт даёт
-- 41.903601, 19.302872 — та же точка), телефон +382 63 207 706, «Centar, Donji Štoj 85360».
-- Филиал другой общины (Ульцинь) → отдельная карточка, решение юзера. Врачи — общие с барской карточкой.
-- 
-- Идемпотентно и самоисправляюще (см. insert-clinic-k-med-ambulanta-bar.sql).
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJqZQJIAkXThMRqZz8bZpOss0';
SET @clinic_slug = 'k-med-ambulanta-stoj-ulcinj';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('K-med Ambulanta Štoj', 'K med Ambulanta Shtoj', 'K-Med Štoj') AND city_id = 5 LIMIT 1));

INSERT INTO clinics (
	slug, google_place_id, status, city_id,
	name_sr, name_sr_cyrl, name_ru,
	address_sr, address_sr_cyrl, town_sr, town_sr_cyrl, postal_code,
	latitude, longitude,
	phone, email, website, facebook, instagram, telegram, whatsapp, viber,
	logo_url, created_at
)
SELECT
	@clinic_slug,
	@google_place_id,
	'published',
	5, -- CityId.ULCINJ (Donji Štoj — opština Ulcinj)
	'K-med Ambulanta Štoj',
	'K-med Амбуланта Штој',
	'Амбулатория K-med (Штой)',
	'Centar, Donji Štoj',
	'Центар, Доњи Штој',
	'Štoj',
	'Штој',
	'85360',
	41.90369690,
	19.30293680,
	'+38263207706',
	'kmed.montenegro@gmail.com',
	'https://kmed.me/',
	'',
	'',
	'',
	'',
	'',
	'https://kmed.me/wp-content/uploads/2024/05/k-medvector.svg',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 41.90369690, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.30293680, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'K-med Амбуланта Штој', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Амбулатория K-med (Штой)', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Centar, Donji Štoj', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Центар, Доњи Штој', address_sr_cyrl),
	town_sr = IF(town_sr IS NULL OR town_sr = '', 'Štoj', town_sr),
	town_sr_cyrl = IF(town_sr_cyrl IS NULL OR town_sr_cyrl = '', 'Штој', town_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85360', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38263207706', phone),
	email = IF(email IS NULL OR email = '', 'kmed.montenegro@gmail.com', email),
	website = IF(website IS NULL OR website = '', 'https://kmed.me/', website),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://kmed.me/wp-content/uploads/2024/05/k-medvector.svg', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Ambulanta zdravstvenog sistema za turiste K-med u Donjem Štoju, na Velikoj plaži u Ulcinju. K-med pruža usluge primarne zdravstvene zaštite potrebne turistima na samostalnom ili porodičnom ljetovanju, i djeci i odraslima: preglede u ambulanti ili na lokaciji pacijenta, posjete hotelskoj sobi uz mogućnost infuzione terapije na smještaju, injekcionu, inhalacionu i infuzionu terapiju (uključujući rehidrataciju kod ljetnjih gastrointestinalnih tegoba, sunčanice i iscrpljenosti), savjetovanje i putem telefona, uzimanje uzoraka za laboratorijske analize sa slanjem rezultata SMS-om ili mejlom, glukometriju, oksimetriju, EKG te obradu i previjanje rana. Ako se ne radi o hitnom slučaju, ljekar dolazi na adresu u roku od sat vremena. Direktor i vlasnik sistema je pedijatar prof. dr Nebojša Kavarić; svi ljekari govore engleski jezik. Izvještaji se izdaju na našem i na engleskom jeziku, uz fiskalni račun, za refundaciju kod zdravstvenog ili putnog osiguranja. Radno vrijeme je od 8 do 21 h, uz mogućnost konsultacija telefonom. Gosti hotela i apartmana partnera uz kupon sa recepcije dobijaju 10% popusta. K-med ima ambulante i u opštini Bar — u Baru (Mila Boškovića 4A), Dobroj Vodi i Čanju.',
	description_sr_cyrl = 'Амбуланта здравственог система за туристе K-med у Доњем Штоју, на Великој плажи у Улцињу. K-med пружа услуге примарне здравствене заштите потребне туристима на самосталном или породичном љетовању, и дјеци и одраслима: прегледе у амбуланти или на локацији пацијента, посјете хотелској соби уз могућност инфузионе терапије на смјештају, ињекциону, инхалациону и инфузиону терапију (укључујући рехидратацију код љетњих гастроинтестиналних тегоба, сунчанице и исцрпљености), савјетовање и путем телефона, узимање узорака за лабораторијске анализе са слањем резултата SMS-ом или мејлом, глукометрију, оксиметрију, EKG те обраду и превијање рана. Ако се не ради о хитном случају, љекар долази на адресу у року од сат времена. Директор и власник система је педијатар проф. др Небојша Каварић; сви љекари говоре енглески језик. Извјештаји се издају на нашем и на енглеском језику, уз фискални рачун, за рефундацију код здравственог или путног осигурања. Радно вријеме је од 8 до 21 х, уз могућност консултација телефоном. Гости хотела и апартмана партнера уз купон са рецепције добијају 10% попуста. K-med има амбуланте и у општини Бар — у Бару (Мила Бошковића 4А), Доброј Води и Чању.',
	description_ru = 'Амбулатория туристической медицинской сети K-med в Доньем Штое, на Велика-Плаже в Ульцине. K-med оказывает первичную медицинскую помощь, которая может понадобиться туристам в самостоятельном или семейном отпуске, — и детям, и взрослым: осмотры в амбулатории или по месту нахождения пациента, визиты в гостиничный номер с возможностью поставить капельницу прямо на месте, уколы, ингаляции и капельницы (в том числе регидратация при летних кишечных расстройствах, солнечном ударе и истощении), консультации, в том числе по телефону, забор анализов с отправкой результатов по SMS или электронной почте, измерение глюкозы и сатурации, ЭКГ, обработка и перевязка ран. Если случай не экстренный, врач приезжает по адресу в течение часа. Директор и владелец сети — педиатр профессор Небойша Каварич; все врачи говорят по-английски. Заключения выдаются на местном и английском языках вместе с фискальным чеком — для возмещения расходов по медицинской или туристической страховке. Часы работы — с 8 до 21, возможны консультации по телефону. Гости отелей и апартаментов-партнёров по купону со стойки регистрации получают скидку 10%. Амбулатории K-med есть и в общине Бар — в Баре (Mila Boškovića, 4A), Добра-Воде и Чане.',
	description_en = 'The clinic of K-med, a healthcare network for tourists, in Donji Štoj on Velika Plaža beach in Ulcinj. K-med provides the primary care that tourists on holiday on their own or with family may need, for children and adults alike: examinations at the clinic or at the patient''s location, visits to hotel rooms with the option of infusion therapy on site, injection, inhalation and infusion therapy (including rehydration for summer gastrointestinal problems, sunstroke and exhaustion), advice including by phone, collection of samples for laboratory tests with results sent by SMS or email, blood glucose and pulse oximetry measurement, ECG, and wound care and dressing. For non-emergency calls a doctor comes to the address within an hour. The network''s director and owner is the paediatrician Prof. Dr Nebojša Kavarić, and all doctors speak English. Medical reports are issued in the local language and in English together with a fiscal receipt, for reimbursement by health or travel insurance. Opening hours are 8:00–21:00, with phone consultations available. Guests of partner hotels and apartments get a 10% discount with a coupon from reception. K-med also runs clinics in the Bar municipality — in Bar (Mila Boškovića 4A), Dobra Voda and Čanj.',
	description_de = 'Ambulanz von K-med, einem Gesundheitsnetz für Touristen, in Donji Štoj an der Velika Plaža in Ulcinj. K-med bietet die medizinische Grundversorgung, die Touristen im Einzel- oder Familienurlaub brauchen können, für Kinder und Erwachsene: Untersuchungen in der Ambulanz oder am Aufenthaltsort des Patienten, Besuche im Hotelzimmer mit der Möglichkeit einer Infusionstherapie vor Ort, Injektions-, Inhalations- und Infusionstherapie (auch Rehydrierung bei sommerlichen Magen-Darm-Beschwerden, Sonnenstich und Erschöpfung), Beratung auch telefonisch, Probenentnahme für Laboranalysen mit Ergebnisversand per SMS oder E-Mail, Blutzucker- und Sauerstoffsättigungsmessung, EKG sowie Wundversorgung und Verbandswechsel. In nicht dringenden Fällen kommt ein Arzt innerhalb einer Stunde zur Adresse. Direktor und Inhaber des Netzes ist der Kinderarzt Prof. Dr. Nebojša Kavarić, alle Ärzte sprechen Englisch. Befunde werden in der Landessprache und auf Englisch zusammen mit einer Fiskalquittung ausgestellt – zur Erstattung durch die Kranken- oder Reiseversicherung. Öffnungszeiten 8–21 Uhr, telefonische Beratung möglich. Gäste von Partnerhotels und -apartments erhalten mit einem Gutschein von der Rezeption 10 % Rabatt. Weitere Ambulanzen von K-med gibt es in der Gemeinde Bar – in Bar (Mila Boškovića 4A), Dobra Voda und Čanj.',
	description_tr = 'Turistlere yönelik sağlık ağı K-med''in Ulcinj''deki Velika Plaža plajında, Donji Štoj''daki polikliniği. K-med, tek başına ya da ailesiyle tatil yapan turistlerin ihtiyaç duyabileceği birinci basamak sağlık hizmetlerini çocuk ve yetişkinlere sunar: poliklinikte ya da hastanın bulunduğu yerde muayene, otel odası ziyareti ve yerinde serum tedavisi imkânı, enjeksiyon, inhalasyon ve serum tedavisi (yaz dönemi mide-bağırsak şikâyetleri, güneş çarpması ve bitkinlikte sıvı takviyesi dahil), telefonla da danışmanlık, laboratuvar tahlilleri için numune alma ve sonuçların SMS veya e-postayla gönderilmesi, kan şekeri ve oksijen satürasyonu ölçümü, EKG, yara bakımı ve pansuman. Acil olmayan durumlarda doktor bir saat içinde adrese gelir. Ağın direktörü ve sahibi çocuk doktoru Prof. Dr. Nebojša Kavarić''tir, tüm doktorlar İngilizce konuşur. Raporlar yerel dilde ve İngilizce olarak, sağlık veya seyahat sigortasından geri ödeme için mali fişle birlikte verilir. Çalışma saatleri 8:00–21:00, telefonla danışma mümkündür. Partner otel ve apart misafirleri resepsiyondan alınan kuponla %10 indirim alır. K-med''in Bar belediyesinde de — Bar (Mila Boškovića 4A), Dobra Voda ve Čanj''da — poliklinikleri vardır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- POLYCLINIC = 1 (первичная помощь детям и взрослым). PEDIATRIC_CLINIC не ставится: «Pedijatrijska» — только в названии барской точки в Google.
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт: «Svi naši ljekari govore engleski jezik što umnogome olakšava komunikaciju turistima» → SR (1) + EN (3).
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
SET @keep_lang_3 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 3);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1 OR id <=> @keep_lang_3);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 3 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 3);

-- Часы НЕ заполняются: сайт даёт «08 - 21 h» у каждой точки и FAQ «Od 8h do 21h» без дней недели, а сеть работает для туристов «na ljetovanju» — круглый ли год, сайт не говорит. Вопрос юзеру в записи импорта. Часы упомянуты в описании.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (3)
-- ═══════════════════════════════════════════════════════════════
-- Источник: https://kmed.me/ блок «Naš tim — Upoznajte K-Med ljekare». Сайт не делит команду по точкам → все три
-- врача привязаны к обеим карточкам (Бар и Штой), правило координатора «если не разделяет — к обоим».
-- НЕ заводятся: Sestra Almira Marisenović, Sestra Marina Raković, Tehničar Veljko Raković — медсёстры/техник.
-- Фото — внешние URL сайта (200, image/jpeg).

-- ───────────────────────────────────────────────────────────────
-- Prof. Dr. Nebojša Kavarić — «pedijatar sa više od 30 godina iskustva … Specijalista je pedijatrije», direktor i vlasnik.
-- В БД не найден (локаль и прод-API 204 по nebojsa-kavaric / kavaric-nebojsa) — новый. 4 = PEDIATRICS.
-- Языки 1 SR + 3 EN: «Svi naši ljekari govore engleski jezik».
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Nebojša Kavarić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Kavarić Nebojša' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'nebojsa-kavaric' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nebojsa-kavaric', 'Nebojša Kavarić', 'Небојша Каварић', 'Небойша Каварич', 'Nebojsa Kavaric', 'Prof. dr',
	'https://kmed.me/wp-content/uploads/2024/06/Nebojsa-ZA-NASLOVNU-UMJESTO-ONE-ZENE-1024x1024.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://kmed.me/wp-content/uploads/2024/06/Nebojsa-ZA-NASLOVNU-UMJESTO-ONE-ZENE-1024x1024.jpg', photo_url) WHERE id = @doctor_id;

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Pedijatar, specijalista pedijatrije, sa više od 30 godina iskustva. Direktor i vlasnik zdravstvenog, turističkog sistema K-med. Bio je višedecenijski rukovodilac u velikim institucijama u Crnoj Gori.',
	description_sr_cyrl = 'Педијатар, специјалиста педијатрије, са више од 30 година искуства. Директор и власник здравственог, туристичког система K-med. Био је вишедеценијски руководилац у великим институцијама у Црној Гори.',
	description_ru = 'Педиатр, специалист по педиатрии с опытом более 30 лет. Директор и владелец медицинской туристической сети K-med. Десятилетиями руководил крупными учреждениями в Черногории.',
	description_en = 'A paediatrician (specialist in paediatrics) with more than 30 years of experience. Director and owner of the K-med healthcare and tourist network. For decades he held senior management positions in major institutions in Montenegro.',
	description_de = 'Kinderarzt (Facharzt für Pädiatrie) mit mehr als 30 Jahren Erfahrung. Direktor und Inhaber des Gesundheits- und Tourismusnetzes K-med. Über Jahrzehnte leitete er große Einrichtungen in Montenegro.',
	description_tr = '30 yılı aşkın deneyime sahip çocuk doktoru (pediatri uzmanı). K-med sağlık ve turizm ağının direktörü ve sahibidir. Onlarca yıl Karadağ''daki büyük kurumlarda yöneticilik yapmıştır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 4);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1), (@doctor_id, 3);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Direktor, specijalista pedijatrije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr. Igor Kavarić — специальность на сайте не указана, «iskustvo … stečeno u Zavodu za Hitnu medicinsku pomoć Crne Gore».
-- Новый (локаль и прод-API 204). 45 = GENERAL_MEDICINE: «Dr.» без специализации в амбулатории первичной помощи.
-- Альтернатива 48 EMERGENCY_MEDICINE — в спорных записи импорта (специализация ургентной медицины сайтом не заявлена).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Igor Kavarić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Kavarić Igor' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'igor-kavaric' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'igor-kavaric', 'Igor Kavarić', 'Игор Каварић', 'Игорь Каварич', 'Igor Kavaric', 'Dr',
	'https://kmed.me/wp-content/uploads/2024/06/Image-2-1024x1024.jpeg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://kmed.me/wp-content/uploads/2024/06/Image-2-1024x1024.jpeg', photo_url) WHERE id = @doctor_id;

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Ljekar sa bogatim iskustvom u rješavanju najsloženijih hitnih zdravstvenih problema, stečenim u Zavodu za hitnu medicinsku pomoć Crne Gore.',
	description_sr_cyrl = 'Љекар са богатим искуством у рјешавању најсложенијих хитних здравствених проблема, стеченим у Заводу за хитну медицинску помоћ Црне Горе.',
	description_ru = 'Врач с большим опытом решения самых сложных неотложных проблем со здоровьем, полученным в Службе скорой медицинской помощи Черногории.',
	description_en = 'A doctor with extensive experience in handling the most complex medical emergencies, gained at the Emergency Medical Service of Montenegro.',
	description_de = 'Arzt mit umfangreicher Erfahrung in der Behandlung schwierigster medizinischer Notfälle, die er beim Rettungsdienst Montenegros gesammelt hat.',
	description_tr = 'Karadağ Acil Tıbbi Yardım Kurumu''nda edindiği, en karmaşık acil sağlık sorunlarını çözme konusunda geniş deneyime sahip doktor.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 45);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1), (@doctor_id, 3);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Ljekar')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr. Ardian Djeka — специальность не указана, «radio je u Zavodu za Hitnu Medicinsku pomoć … cio svoj radni vijek proveo u turističkom mjestu u Ulcinju».
-- Новый (локаль и прод-API 204). 45 = GENERAL_MEDICINE (как у Igor Kavarić). Кириллица: Dj → Ђ (сербская запись Đ).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Ardian Djeka' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Djeka Ardian' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'ardian-djeka' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ardian-djeka', 'Ardian Djeka', 'Ардиан Ђека', 'Ардиан Джека', 'Ardian Djeka', 'Dr',
	'https://kmed.me/wp-content/uploads/2024/06/Image-3-1024x1024.jpeg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://kmed.me/wp-content/uploads/2024/06/Image-3-1024x1024.jpeg', photo_url) WHERE id = @doctor_id;

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Ljekar koji je radio u Zavodu za hitnu medicinsku pomoć. Ima višegodišnje iskustvo u zbrinjavanju pacijenata-turista, jer je cio radni vijek proveo u turističkom mjestu — Ulcinju.',
	description_sr_cyrl = 'Љекар који је радио у Заводу за хитну медицинску помоћ. Има вишегодишње искуство у збрињавању пацијената-туриста, јер је цио радни вијек провео у туристичком мјесту — Улцињу.',
	description_ru = 'Врач, работавший в Службе скорой медицинской помощи. Имеет многолетний опыт помощи пациентам-туристам: вся его карьера прошла в курортном Ульцине.',
	description_en = 'A doctor who worked at the Emergency Medical Service. He has many years of experience in caring for patients who are tourists, having spent his entire career in the resort town of Ulcinj.',
	description_de = 'Arzt, der beim Rettungsdienst tätig war. Er hat langjährige Erfahrung in der Versorgung von Patienten, die Touristen sind, da er sein ganzes Berufsleben im Urlaubsort Ulcinj verbracht hat.',
	description_tr = 'Acil Tıbbi Yardım Kurumu''nda çalışmış doktor. Tüm meslek hayatını turistik Ulcinj kasabasında geçirdiği için turist hastaların tedavisinde uzun yıllara dayanan deneyime sahiptir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 45);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1), (@doctor_id, 3);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Ljekar')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 5, status = published, clinic_languages = '1,3', clinic_types = '1', hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 3: nebojsa-kavaric (4), igor-kavaric (45), ardian-djeka (45).
-- Если created_at нового врача старше даты прогона — запись уже была: проверить, тот ли человек.
SELECT d.id, d.slug, d.name_sr, d.professional_title,
	GROUP_CONCAT(DISTINCT ds.specialty_id ORDER BY ds.specialty_id) AS specialties,
	GROUP_CONCAT(DISTINCT dl.language_id ORDER BY dl.language_id) AS languages,
	IF(d.photo_url IS NULL OR d.photo_url = '', 'NO PHOTO', 'ok') AS photo,
	d.created_at
FROM doctors d
JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
LEFT JOIN doctor_languages dl ON dl.doctor_id = d.id
GROUP BY d.id
ORDER BY d.name_sr;
