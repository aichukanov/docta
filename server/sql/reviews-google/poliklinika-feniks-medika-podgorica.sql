-- Insert Google Maps reviews for Klinika Podgorica | Feniks Medika
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/poliklinika-feniks-medika-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'poliklinika-feniks-medika-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Blue Sky', 'https://lh3.googleusercontent.com/a-/ALV-UjXBVQUDIgql3ovCreernolHqmHm9V_gsLqm_Iiccy0oySYVPhtH=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/102059193567255252238/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102059193567255252238/reviews');
SET @user_blue_sky = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102059193567255252238/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Yuliia Horycheva', 'https://lh3.googleusercontent.com/a-/ALV-UjWYZhIR4TXz2ThU4H-BgXZT3C8y3SdPOQsdPK0A0PFgi0ICXG3y=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/106128918187880930316/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106128918187880930316/reviews');
SET @user_yuliia_horycheva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106128918187880930316/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Oleksandr Horychev', 'https://lh3.googleusercontent.com/a/ACg8ocK8OZlualDOz8ZR9tYIYsSuN8H1FrrY4-y-BXpIoJdKDwGZwA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/116653373975425175820/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116653373975425175820/reviews');
SET @user_oleksandr_horychev = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116653373975425175820/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Inna Belopolskaia', 'https://lh3.googleusercontent.com/a-/ALV-UjX4VbJePw_64PZIq06_sGQsZxHH-Dmpzk0_tkgTn_ttc2ZuP2fd=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111753269975687545088/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111753269975687545088/reviews');
SET @user_inna_belopolskaia = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111753269975687545088/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Katlin Huhle', 'https://lh3.googleusercontent.com/a-/ALV-UjUw4zuS-Fna4mKiwbm1T8cPDYvJeWnoY1aULR8HfttOeOyf5W8=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101912817611481471100/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101912817611481471100/reviews');
SET @user_katlin_huhle = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101912817611481471100/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Radulovic', 'https://lh3.googleusercontent.com/a/ACg8ocLJ31MrbqFDczst4bvuMYL4F8ynDb_k9dRV-yBUSXGbeUUWmg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110524231178471235299/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110524231178471235299/reviews');
SET @user_ivana_radulovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110524231178471235299/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'vlado tatar', 'https://lh3.googleusercontent.com/a/ACg8ocI292oWd0jZxBJu3ruaexWopV2NBY9VggUdBzKfKhfNhidO8A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100670226654521699246/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100670226654521699246/reviews');
SET @user_vlado_tatar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100670226654521699246/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Djordjije Radovic', 'https://lh3.googleusercontent.com/a/ACg8ocLCktlO_I73BnuRXk-_9bBbTImCz0aOuDZnPEumRw9Zc0Nt5cQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111913299704744909612/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111913299704744909612/reviews');
SET @user_djordjije_radovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111913299704744909612/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radmila Pesic', 'https://lh3.googleusercontent.com/a-/ALV-UjX5jvHtk0mRGxUgRTrGml6K_p3PpwIRYTOw3AytLTfM-HEpme-q1w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110144003098586739866/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110144003098586739866/reviews');
SET @user_radmila_pesic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110144003098586739866/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dražen Zarubica', 'https://lh3.googleusercontent.com/a-/ALV-UjXxaREbxfzFlzJ9YLOyEHanMb_FwG3QX8X3POVZ5ApTPDLHHAmv-g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118026854891919566902/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118026854891919566902/reviews');
SET @user_draen_zarubica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118026854891919566902/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anja Vujosevic', 'https://lh3.googleusercontent.com/a/ACg8ocI2C8-LRNiN6mSLfjB_IyGtoWg1cqOaPOJqjbq56ks58yFzC27E=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105196247495655615550/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105196247495655615550/reviews');
SET @user_anja_vujosevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105196247495655615550/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sterne', 'https://lh3.googleusercontent.com/a/ACg8ocInZckn023WUJ7Sx-7OKceI-9YS3fPSi6U8yuW-zAWM3zntng=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111000346178924889891/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111000346178924889891/reviews');
SET @user_sterne = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111000346178924889891/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Happy Little Misery', 'https://lh3.googleusercontent.com/a-/ALV-UjUDj0eunV-GuGtYtGEj4dZP-TL3y0W61CbczjpAjD3baOzUd4MY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107845707427366304240/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107845707427366304240/reviews');
SET @user_happy_little_misery = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107845707427366304240/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Foka Raspala', 'https://lh3.googleusercontent.com/a/ACg8ocKrPzVphN4XLkc9J-FYgG7WJQBZr-2qu46Jyxu0C_oh4_vC2w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107632683169322530158/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107632683169322530158/reviews');
SET @user_foka_raspala = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107632683169322530158/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dusica Femic', 'https://lh3.googleusercontent.com/a-/ALV-UjXF0UjygNFU5TiML5XczuB4ED9da6f7x1L-GLkjKtW5K2eESKz2=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118154599379923319137/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118154599379923319137/reviews');
SET @user_dusica_femic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118154599379923319137/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nusha Malysheva', 'https://lh3.googleusercontent.com/a-/ALV-UjXWQthJo3VEo-YSYqnoZ1e6f4kCbJPrY67HcvUg1AdwJok8sF9k=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105812744334811062931/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105812744334811062931/reviews');
SET @user_nusha_malysheva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105812744334811062931/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ena Ena', 'https://lh3.googleusercontent.com/a/ACg8ocLug7JOAjJyGcft5a5cOnb_FxFM-qiFnYyZ0zipgLRIoEaKlQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103251933980654601460/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103251933980654601460/reviews');
SET @user_ena_ena = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103251933980654601460/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mila Mil', 'https://lh3.googleusercontent.com/a/ACg8ocL8GPSN1jMpCtT7pAzwKm_gxVsLIgX-ZI8PrLRl9Aeth8knYw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105989316267912796610/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105989316267912796610/reviews');
SET @user_mila_mil = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105989316267912796610/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Predrag Mijajlovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVpx-o9bBL8JIQPj5xRcikoFYTZ3DeOeQo5efT-C0F5Ez0F7ci-=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114444239754966792699/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114444239754966792699/reviews');
SET @user_predrag_mijajlovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114444239754966792699/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tatjana Dragas', 'https://lh3.googleusercontent.com/a/ACg8ocLVW2RwGJ_Zn0A3qWf_FWwE32W06ixYUnRYkUTP4I7FnI70Kg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113627795482130660128/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113627795482130660128/reviews');
SET @user_tatjana_dragas = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113627795482130660128/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Buba 989', 'https://lh3.googleusercontent.com/a-/ALV-UjXf3epw7ZrHRYmpuYVgP8uDNGGY-Ov7In95h-eHsUTa64GhgCc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103466722521830080502/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103466722521830080502/reviews');
SET @user_buba_989 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103466722521830080502/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovanka Nina Radovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXNg7NoGRhMvu7yZjnIiB17RBKNHPGZ0KR0aafBmhskpqp1gOij=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116915713436542864753/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116915713436542864753/reviews');
SET @user_jovanka_nina_radovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116915713436542864753/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lena Kozlova', 'https://lh3.googleusercontent.com/a-/ALV-UjVArPGo-3lQOmcNXUWX3l6TAzzV5raXeEzBlaIuR9uqBRadCct7=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102773254495541284589/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102773254495541284589/reviews');
SET @user_lena_kozlova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102773254495541284589/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Volsebnik', 'https://lh3.googleusercontent.com/a/ACg8ocK4LofUAaNm59gSK2oONb9wiEO1FQk8LqozcUd47Q0baBHW3g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116339670490811894947/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116339670490811894947/reviews');
SET @user_volsebnik = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116339670490811894947/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andjela Ruza', 'https://lh3.googleusercontent.com/a/ACg8ocID9KjFZGVAobndiyeqdYxgrPlsNsoPGR-sp-JRnM_7sfvXkA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117549119621031775370/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117549119621031775370/reviews');
SET @user_andjela_ruza = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117549119621031775370/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sokrat', 'https://lh3.googleusercontent.com/a-/ALV-UjWthzRfIF0tl0-i1RQfHJFU_fw2__o7tGn07kxNwBrrh36mYGsb=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110543121254141316273/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110543121254141316273/reviews');
SET @user_sokrat = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110543121254141316273/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_blue_sky, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNBbXFHYUR3EAE',
    1, 'sr', 'нељубазност,некултура,безобразлук,неодговорност су само неке од одлика које описују ово мјест. Искуство са овим људима је било јако лоше и непријатно тога 26 септ. 2017 године,када сам покушао да закажем вађење љекарског увјерења. НЕ ТРОШИТЕ СВОЈЕ ВРИЈЕМЕ И ЖИВЦЕ НА FENIKS MEDIKA',
    'neljubaznost,nekultura,bezobrazluk,neodgovornost su samo neke od odlika koje opisuju ovo mjest. Iskustvo sa ovim ljudima je bilo jako loše i neprijatno toga 26 sept. 2017 godine,kada sam pokušao da zakažem vađenje ljekarskog uvjerenja. NE TROŠITE SVOJE VRIJEME I ŽIVCE NA FENIKS MEDIKA', 'нељубазност,некултура,безобразлук,неодговорност су само неке од одлика које описују ово мјест. Искуство са овим људима је било јако лоше и непријатно тога 26 септ. 2017 године,када сам покушао да закажем вађење љекарског увјерења. НЕ ТРОШИТЕ СВОЈЕ ВРИЈЕМЕ И ЖИВЦЕ НА FENIKS MEDIKA', NULL, NULL, NULL, NULL,
    3, '2017-09-25 12:40:01'),

(@user_yuliia_horycheva, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWb2JFVjBSRFZvWDNCTllqUTBTbU5yYURGb1YxRRAB',
    2, 'en', 'Concern Regarding Today’s Pediatric Appointment

Dear Administration of Feniks Medika

Today I attended a pediatric appointment with my daughter and encountered the following situation:

My husband scheduled the appointment at your clinic three days in advance. He was informed that the doctor would see us at 9:00, and that the visit would cost €25. We arrived punctually at 9:00; however, the reception staff had no record of our appointment, questioned whether it had been arranged at all, and informed us that the doctor was not present. When I asked for clarification, the response was simply, “I don’t know.”

Subsequently, the staff contacted the doctor, who explained that she was working at another hospital but would arrive within 20 minutes. The doctor did eventually attend and saw us, but after the consultation we were billed €40 instead of the €25 previously communicated by phone. When I inquired about the discrepancy, the response given was, “Because the doctor decided so.”

I find this situation very unsatisfactory and unfair. It highlights a serious issue with communication between the clinic’s administrative staff and its doctors, which directly impacts patients and their trust in the clinic’s services.

I kindly ask you to review this matter and provide clarification.

I would also like to note that the doctor was very kind and friendly with us. She examined the child, measured weight and height, checked the throat, and issued a certificate for the school stating that the child is fit to attend and everything is in order.

But could you please provide us with an explanation as to why we were charged twice the originally stated amount for this doctor’s visit, and why we were not informed about this in advance?

Sincerely, Yuliia Horycheva',
    'Zabrinutost u vezi sa današnjim pedijatrijskim pregledom

Poštovana uprava Feniks Medika

Danas sam sa ćerkom bila na pedijatrijskom pregledu i naišla na sledeću situaciju:

Moj muž je zakazao pregled u vašoj klinici tri dana unapred. Obavešten je da će nas doktor primiti u 9:00 i da će poseta koštati 25€. Stigli smo tačno u 9:00; međutim, osoblje na recepciji nije imalo zapisnik o našem terminu, pitalo je da li je to uopšte dogovoreno i obavestilo nas da lekar nije prisutan. Kada sam zatražio pojašnjenje, odgovor je bio jednostavno: „Ne znam“.

Nakon toga, osoblje je kontaktiralo doktora, koji je objasnio da ona radi u drugoj bolnici, ali da će stići u roku od 20 minuta. Doktor je na kraju došao i pregledao nas, ali posle konsultacija nam je naplaćeno 40 evra umesto 25 evra koliko smo prethodno komunicirali telefonom. Kada sam se raspitivao o neskladu, odgovor je bio: „Zato što je doktor tako odlučio.

Smatram da je ova situacija veoma nezadovoljavajuća i nepravedna. Ističe ozbiljan problem u komunikaciji između administrativnog osoblja klinike i njenih lekara, što direktno utiče na pacijente i njihovo poverenje u usluge klinike.

Ljubazno vas molim da razmotrite ovo pitanje i date pojašnjenje.

Takođe bih želeo da napomenem da je doktor bio veoma ljubazan i prijateljski prema nama. Pregledala je dete, izmerila težinu i visinu, proverila grlo i izdala potvrdu za školu da je dete sposobno za pohađanje i da je sve u redu.

Ali da li biste mogli da nam date objašnjenje zašto nam je za posetu ovom lekaru naplaćena duplo veća od prvobitno navedena suma i zašto o tome nismo obavešteni unapred?

S poštovanjem, Iuliia Horicheva', 'Забринутост у вези са данашњим педијатријским прегледом

Поштована управа Феникс Медика

Данас сам са ћерком била на педијатријском прегледу и наишла на следећу ситуацију:

Мој муж је заказао преглед у вашој клиници три дана унапред. Обавештен је да ће нас доктор примити у 9:00 и да ће посета коштати 25€. Стигли смо тачно у 9:00; међутим, особље на рецепцији није имало записник о нашем термину, питало је да ли је то уопште договорено и обавестило нас да лекар није присутан. Када сам затражио појашњење, одговор је био једноставно: „Не знам“.

Након тога, особље је контактирало доктора, који је објаснио да она ради у другој болници, али да ће стићи у року од 20 минута. Доктор је на крају дошао и прегледао нас, али после консултација нам је наплаћено 40 евра уместо 25 евра колико смо претходно комуницирали телефоном. Када сам се распитивао о нескладу, одговор је био: „Зато што је доктор тако одлучио.

Сматрам да је ова ситуација веома незадовољавајућа и неправедна. Истиче озбиљан проблем у комуникацији између административног особља клинике и њених лекара, што директно утиче на пацијенте и њихово поверење у услуге клинике.

Љубазно вас молим да размотрите ово питање и дате појашњење.

Такође бих желео да напоменем да је доктор био веома љубазан и пријатељски према нама. Прегледала је дете, измерила тежину и висину, проверила грло и издала потврду за школу да је дете способно за похађање и да је све у реду.

Али да ли бисте могли да нам дате објашњење зашто нам је за посету овом лекару наплаћена дупло већа од првобитно наведена сума и зашто о томе нисмо обавештени унапред?

С поштовањем, Иулииа Хорицхева', 'Concern Regarding Today’s Pediatric Appointment

Dear Administration of Feniks Medika

Today I attended a pediatric appointment with my daughter and encountered the following situation:

My husband scheduled the appointment at your clinic three days in advance. He was informed that the doctor would see us at 9:00, and that the visit would cost €25. We arrived punctually at 9:00; however, the reception staff had no record of our appointment, questioned whether it had been arranged at all, and informed us that the doctor was not present. When I asked for clarification, the response was simply, “I don’t know.”

Subsequently, the staff contacted the doctor, who explained that she was working at another hospital but would arrive within 20 minutes. The doctor did eventually attend and saw us, but after the consultation we were billed €40 instead of the €25 previously communicated by phone. When I inquired about the discrepancy, the response given was, “Because the doctor decided so.”

I find this situation very unsatisfactory and unfair. It highlights a serious issue with communication between the clinic’s administrative staff and its doctors, which directly impacts patients and their trust in the clinic’s services.

I kindly ask you to review this matter and provide clarification.

I would also like to note that the doctor was very kind and friendly with us. She examined the child, measured weight and height, checked the throat, and issued a certificate for the school stating that the child is fit to attend and everything is in order.

But could you please provide us with an explanation as to why we were charged twice the originally stated amount for this doctor’s visit, and why we were not informed about this in advance?

Sincerely, Yuliia Horycheva', NULL, NULL, NULL,
    0, '2025-10-27 10:13:38'),

(@user_oleksandr_horychev, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/Ci9DQUlRQUNvZENodHljRjlvT21waVRHSlZRbTFpWm14WFpVVXRRekI0ZEVaNFJHYxAB',
    1, 'en', 'they changing their prices on the go. By phone they told that school chek for kid is 25 euro but eventually charged 40',
    'menjaju cene u hodu. Telefonom su rekli da je školski ček za dete 25 evra, ali su na kraju naplatili 40', 'мењају цене у ходу. Телефоном су рекли да је школски чек за дете 25 евра, али су на крају наплатили 40', 'they changing their prices on the go. By phone they told that school chek for kid is 25 euro but eventually charged 40', NULL, NULL, NULL,
    0, '2025-10-27 09:48:00'),

(@user_inna_belopolskaia, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNMbnY2aDNnRRAB',
    2, 'en', 'I don\'t recommend, unfortunately. Just bare minimum - tests and appointments, nothing positive.

Administrators don\'t speak English and when you try to ask something they don\'t seem to be willing to help - so that\'s your problem you don\'t speak Montenegrin.
The gynecologist came 20 minutes later and no one even thought to tell me anything - I waited for 15 minutes and then had to ask administrators myself what was going on. So, according to the personnel\'s behavior, I guess, it\'s normal for doctors to be late.
I texted all my appointments requests and questions via Viber so that translate could help in our communication - my messages were read but I could get replies only after texting one more time - never got reply after my initial query.
Disappointed.
Switched to Life clinic.',
    'Ne preporučujem, nažalost. Samo minimum - testovi i zakazivanje, ništa pozitivno.

Administratori ne govore engleski i kada pokušate nešto da pitate oni ne žele da pomognu - pa to je vaš problem da ne govorite crnogorski.
Ginekolog je došao 20 minuta kasnije i niko nije ni pomislio da mi nešto kaže – čekala sam 15 minuta i onda sam morala da pitam administratore šta se dešava. Dakle, po ponašanju osoblja, valjda je normalno da doktori kasne.
Poslao sam sve svoje zahteve za termine i pitanja preko Vibera kako bi prevodilac mogao da pomogne u našoj komunikaciji - moje poruke su pročitane, ali sam mogao da dobijem odgovore samo nakon što sam još jednom poslao SMS - nikada nisam dobio odgovor nakon svog prvobitnog upita.
Razočaran.
Prešao na kliniku Life.', 'Не препоручујем, нажалост. Само минимум - тестови и заказивање, ништа позитивно.

Администратори не говоре енглески и када покушате нешто да питате они не желе да помогну - па то је ваш проблем да не говорите црногорски.
Гинеколог је дошао 20 минута касније и нико није ни помислио да ми нешто каже – чекала сам 15 минута и онда сам морала да питам администраторе шта се дешава. Дакле, по понашању особља, ваљда је нормално да доктори касне.
Послао сам све своје захтеве за термине и питања преко Вибера како би преводилац могао да помогне у нашој комуникацији - моје поруке су прочитане, али сам могао да добијем одговоре само након што сам још једном послао СМС - никада нисам добио одговор након свог првобитног упита.
Разочаран.
Прешао на клинику Лифе.', 'I don\'t recommend, unfortunately. Just bare minimum - tests and appointments, nothing positive.

Administrators don\'t speak English and when you try to ask something they don\'t seem to be willing to help - so that\'s your problem you don\'t speak Montenegrin.
The gynecologist came 20 minutes later and no one even thought to tell me anything - I waited for 15 minutes and then had to ask administrators myself what was going on. So, according to the personnel\'s behavior, I guess, it\'s normal for doctors to be late.
I texted all my appointments requests and questions via Viber so that translate could help in our communication - my messages were read but I could get replies only after texting one more time - never got reply after my initial query.
Disappointed.
Switched to Life clinic.', NULL, NULL, NULL,
    0, '2024-06-19 12:15:29'),

(@user_katlin_huhle, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChdDSUhNMG9nS0VJQ0FnSURVaHF2Qm1BRRAB',
    1, 'de', 'Das erste Mal war ich 2018 dort und fühlte mich gut aufgehoben. Dieses Mal, gestern, fühlte ich mich verarscht und abgezockt. Ich wollte Ultraschall bezüglich der korrekten Lage der Spirale und wegen einer Zyste. Es wurde eine gynäkologische Untersuchung gemacht, bei der angeblich die korrekte Lage der Spirale festgestellt wurde. Bisher hat dies jeder Arzt NUR über einen Ultraschall feststellen können. Die Untersuchung wurde sicherlich gemacht, um mehr Geld abzukassieren.
2018 wollte ich genau dasselbe kontrollieren lassen und habe 40 Euro bezahlt, dieses Mal gleich 70 Euro ! Laut Preis auf der Internetseite kostet der Ultraschall aber nur 30 Euro. Deutsche werden hier wahrscheinlich gleich doppelt abkassiert. Zudem sind die Schwestern an der Rezeption sehr schnippisch und die Quittung wurde auch erst \'angeblich\' vergessen zu übergeben.
Ich bin wieder einmal sehr enttäuscht über die Abzocke in diesem Land.',
    'Bio sam tamo prvi put 2018. i osećao sam se dobro zbrinutim. Ovaj put, juče, osećao sam se opljačkano i maltretirano. Hteo sam ultrazvukom da proverim pravilan položaj spirale i zbog ciste. Obavili su ginekološki pregled, koji je navodno utvrdio pravilan položaj spirale. Do sada je svaki lekar to mogao da utvrdi samo ultrazvukom. Ispitivanje je svakako urađeno da bi se zaradilo više.
U 2018. želeo sam na potpuno isti pregled i platio sam 40 evra, ali ovaj put je bilo 70 evra! Prema ceni na sajtu, ultrazvuk košta samo 30 evra. Nemci su ovde verovatno dva puta optuženi. Štaviše, medicinske sestre na recepciji su veoma oštre, a račun je \'navodno\' zaboravljen da se preda.
Još jednom sam veoma razočaran pljačkama u ovoj zemlji.', 'Био сам тамо први пут 2018. и осећао сам се добро збринутим. Овај пут, јуче, осећао сам се опљачкано и малтретирано. Хтео сам ултразвуком да проверим правилан положај спирале и због цисте. Обавили су гинеколошки преглед, који је наводно утврдио правилан положај спирале. До сада је сваки лекар то могао да утврди само ултразвуком. Испитивање је свакако урађено да би се зарадило више.
У 2018. желео сам на потпуно исти преглед и платио сам 40 евра, али овај пут је било 70 евра! Према цени на сајту, ултразвук кошта само 30 евра. Немци су овде вероватно два пута оптужени. Штавише, медицинске сестре на рецепцији су веома оштре, а рачун је \'наводно\' заборављен да се преда.
Још једном сам веома разочаран пљачкама у овој земљи.', NULL, NULL, 'Das erste Mal war ich 2018 dort und fühlte mich gut aufgehoben. Dieses Mal, gestern, fühlte ich mich verarscht und abgezockt. Ich wollte Ultraschall bezüglich der korrekten Lage der Spirale und wegen einer Zyste. Es wurde eine gynäkologische Untersuchung gemacht, bei der angeblich die korrekte Lage der Spirale festgestellt wurde. Bisher hat dies jeder Arzt NUR über einen Ultraschall feststellen können. Die Untersuchung wurde sicherlich gemacht, um mehr Geld abzukassieren.
2018 wollte ich genau dasselbe kontrollieren lassen und habe 40 Euro bezahlt, dieses Mal gleich 70 Euro ! Laut Preis auf der Internetseite kostet der Ultraschall aber nur 30 Euro. Deutsche werden hier wahrscheinlich gleich doppelt abkassiert. Zudem sind die Schwestern an der Rezeption sehr schnippisch und die Quittung wurde auch erst \'angeblich\' vergessen zu übergeben.
Ich bin wieder einmal sehr enttäuscht über die Abzocke in diesem Land.', NULL,
    2, '2019-08-21 14:55:10'),

(@user_ivana_radulovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s0emVqaDBYMjkwZVhCM2FqUlRTMHA0U0MxRVJYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-22 00:00:00'),

(@user_vlado_tatar, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/Ci9DQUlRQUNvZENodHljRjlvT20xUFJFTjVTMHhXTmtGTFVGRXliSEpFUldGV1JXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_djordjije_radovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChZDSUhNMG9nS0VJQ0FnTUR3dGZteENBEAE',
    5, 'hr', 'Hvala dolični ste!! spasili ste me <3',
    'Hvala dolični ste!! spasili ste me <3', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_radmila_pesic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChZDSUhNMG9nS0VJQ0FnTUNRZ28tSkZBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_draen_zarubica, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChdDSUhNMG9nS0VJQ0FnSURQN2JhUnNBRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_anja_vujosevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNaNjRiTFB3EAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_sterne, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChdDSUhNMG9nS0VJQ0FnSURXbGVmNXJ3RRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_happy_little_misery, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChdDSUhNMG9nS0VJQ0FnSURtcDk3WTBBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_foka_raspala, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNHcjZfUXN3RRAB',
    1, 'hr', 'Osoblje dozvoljava da ljudi u kasnijim terminima udju prije vas. Nakon što sam kazao da je red na mene i da su ostali došli kasnije medicinska radnica se nasmijala i kazala da sjednem. Ne preporučujem.',
    'Osoblje dozvoljava da ljudi u kasnijim terminima udju prije vas. Nakon što sam kazao da je red na mene i da su ostali došli kasnije medicinska radnica se nasmijala i kazala da sjednem. Ne preporučujem.', NULL, NULL, NULL, NULL, NULL,
    5, '2022-10-29 00:00:00'),

(@user_dusica_femic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNHci12SVRnEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_nusha_malysheva, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChdDSUhNMG9nS0VJQ0FnSUM2bllUOW9BRRAB',
    5, 'en', 'Doctors and the staff speak English or Russian except for a few of them. The service is great. A special thanks to Dr Rade Boricic, super friendly and helpful, prescribed only the necessary medicine. Good-quality European approach',
    NULL, NULL, 'Doctors and the staff speak English or Russian except for a few of them. The service is great. A special thanks to Dr Rade Boricic, super friendly and helpful, prescribed only the necessary medicine. Good-quality European approach', NULL, NULL, NULL,
    4, '2021-10-29 00:00:00'),

(@user_ena_ena, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNhX0lPanpBRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_mila_mil, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNxOGJqbFVnEAE',
    5, 'hr', '5 stars samo za doktorku Vericu Skerovic, medicinske tehnicare ne bih spominjala',
    '5 stars samo za doktorku Vericu Skerovic, medicinske tehnicare ne bih spominjala', NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_predrag_mijajlovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChZDSUhNMG9nS0VJQ0FnSURDbUlINUN3EAE',
    1, 'bs', 'Ne rade rengen osobama koje imaju pozitivan trst na koronu.
Imali jos nekih uslova.Boja koze nacija jezik itd.
Vi ste hipokratovu zakletvu dali.
Ili primate samo zdrave.
Dno dna',
    'Ne rade rengen osobama koje imaju pozitivan trst na koronu.
Imali jos nekih uslova.Boja koze nacija jezik itd.
Vi ste hipokratovu zakletvu dali.
Ili primate samo zdrave.
Dno dna', NULL, NULL, NULL, NULL, NULL,
    4, '2020-10-29 00:00:00'),

(@user_tatjana_dragas, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNFdTVEN1NnEAE',
    4, 'ru', 'Очень понравилось, все быстро. Очень приятные девочки - медсестры)) Отличный персонал.',
    NULL, NULL, NULL, 'Очень понравилось, все быстро. Очень приятные девочки - медсестры)) Отличный персонал.', NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_buba_989, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChZDSUhNMG9nS0VJQ0FnSURBcVlTVURnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_jovanka_nina_radovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChdDSUhNMG9nS0VJQ0FnSURRcDhhX3p3RRAB',
    5, 'hr', 'Savremena oprema I sve vrste usluga. Sve preporuke, bravo!',
    'Savremena oprema I sve vrste usluga. Sve preporuke, bravo!', NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_lena_kozlova, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChdDSUhNMG9nS0VJQ0FnSURBX2NYUXZ3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_volsebnik, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChdDSUhNMG9nS0VJQ0FnSURnZ1BteTB3RRAB',
    5, 'bs', 'Savremeni aparati, odlicno osoblje.. ma fantasticno!',
    'Savremeni aparati, odlicno osoblje.. ma fantasticno!', NULL, NULL, NULL, NULL, NULL,
    1, '2018-10-29 00:00:00'),

(@user_andjela_ruza, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChdDSUhNMG9nS0VJQ0FnSURRaTVTLTdRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2017-10-29 00:00:00'),

(@user_sokrat, @clinic_id, NULL, 'google_maps',
    'places/ChIJGyTHrE7rTRMRgB1yl3q_vK8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNRdktUalJnEAE',
    5, 'hr', 'Sve najbolje o njima !   Fenix vas dize iz pepela !  Dodite uvjerite se !',
    'Sve najbolje o njima !   Fenix vas dize iz pepela !  Dodite uvjerite se !', NULL, NULL, NULL, NULL, NULL,
    1, '2017-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
