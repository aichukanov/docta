-- Insert Google Maps reviews for DentArt
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dentart-tivat.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dentart-tivat');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_sandra_stanisic = (SELECT id FROM doctors WHERE slug = 'sandra-stanisic');
SET @doctor_zorica_popovic = (SELECT id FROM doctors WHERE slug = 'zorica-popovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'MasaNikola Vukasovic', 'https://lh3.googleusercontent.com/a/ACg8ocKqoIM9obpMh4cwtobmfMKNtdi_NwPAZ4QicwlZ2lh1wQ3ghg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/112979287615419797926/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112979287615419797926/reviews');
SET @user_masanikola_vukasovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112979287615419797926/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Татьяна Недзвецкая', 'https://lh3.googleusercontent.com/a/ACg8ocJVvgbmAR8837Y_Xtate7YT46FGPo_41fqxo7t0Gb4OYawNHQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/113372490453065059904/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113372490453065059904/reviews');
SET @user_tatyana_nedzvetskaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113372490453065059904/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Essens', 'https://lh3.googleusercontent.com/a-/ALV-UjVgKTK7pYNMRYZQ1Jli_DUqca_PvgXqg6RCdAHAgXcRy6LZ98s=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107782451962496922493/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107782451962496922493/reviews');
SET @user_essens = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107782451962496922493/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zarema Bakytzhan', 'https://lh3.googleusercontent.com/a-/ALV-UjWbn8K2LKrxA7HXG28bleZ92MgIo5fi6u305mJ5W4fNZ5haeI8=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/102265945376417388476/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102265945376417388476/reviews');
SET @user_zarema_bakytzhan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102265945376417388476/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Antonio Bolanca', 'https://lh3.googleusercontent.com/a/ACg8ocLo6CvtePSgb2a7Go9tSB1_Wi4IL1RPCo3t9TymjjLrMBnoUw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/103669982919858496380/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103669982919858496380/reviews');
SET @user_antonio_bolanca = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103669982919858496380/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alon Fux', 'https://lh3.googleusercontent.com/a-/ALV-UjXeQGxVFCweHvOAOwr_fnTuGJDXNaar3eww6FB0wUvX2iFL4sU7=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107837599184601395675/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107837599184601395675/reviews');
SET @user_alon_fux = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107837599184601395675/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Veljko Tanić', 'https://lh3.googleusercontent.com/a/ACg8ocLZsuMkv8Pj1BOcmVMNTL95xw7weY6L8lsB42c0foo7gtvB4Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101191584669181450595/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101191584669181450595/reviews');
SET @user_veljko_tani = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101191584669181450595/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Yacht Monty B', 'https://lh3.googleusercontent.com/a-/ALV-UjU6ILot2RS9El71Q1Y9O7GKRBmpYVgjWe7sWohRZoVNqpr_RIGy=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100040980852538877139/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100040980852538877139/reviews');
SET @user_yacht_monty_b = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100040980852538877139/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lena Kovacevic', 'https://lh3.googleusercontent.com/a/ACg8ocJzGN4k5eo7uJWGfelGph252VA7fw3mSNdwLdEt9QrIHB2Pig=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102574094851609554028/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102574094851609554028/reviews');
SET @user_lena_kovacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102574094851609554028/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Matija Pantovic', 'https://lh3.googleusercontent.com/a/ACg8ocLYBygh8C1b5PKkr9zoTPZVLsJDq5Y7kqnCrsjHEZ7Sccfc7g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107751322115372812602/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107751322115372812602/reviews');
SET @user_matija_pantovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107751322115372812602/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sasha', 'https://lh3.googleusercontent.com/a/ACg8ocKvfE1iWTux8VgrI5WaT1bwq4wx51CwKBaN9wh84_9svT4Fyw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106531692606323306406/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106531692606323306406/reviews');
SET @user_sasha = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106531692606323306406/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Paula Petkovic', 'https://lh3.googleusercontent.com/a/ACg8ocKLirlw_RsXfmlJ3zbb6Ch_7PdHcWzfaXWxIT-ORTRdfTAxzw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100622926354400695763/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100622926354400695763/reviews');
SET @user_paula_petkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100622926354400695763/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Konatar', 'https://lh3.googleusercontent.com/a-/ALV-UjX2l_qbIrmszMbZfgZbNRgpnyfJVefwQeVdgCYeRdFWWiE0mHzFRw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104059054886940474433/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104059054886940474433/reviews');
SET @user_milica_konatar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104059054886940474433/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Narek Gevorkian', 'https://lh3.googleusercontent.com/a/ACg8ocJaO9G3O9tZbTarssOPThiecT9dJXg8tdivU5_VcisyHHmyaw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100778901793839104105/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100778901793839104105/reviews');
SET @user_narek_gevorkian = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100778901793839104105/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stari Vujadin', 'https://lh3.googleusercontent.com/a-/ALV-UjVAByHrxap-codkcaKjYeu3e00RlNKddiWoXmfmggLu-Nrs9qrs=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107893272299083277866/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107893272299083277866/reviews');
SET @user_stari_vujadin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107893272299083277866/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Masha Miller', 'https://lh3.googleusercontent.com/a-/ALV-UjUHyuM9RLS0rrM88ck63QEo63LTujHQBu3c4G5wpvjdK7274zif=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101306493747419365675/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101306493747419365675/reviews');
SET @user_masha_miller = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101306493747419365675/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Varvar PG', 'https://lh3.googleusercontent.com/a/ACg8ocL4sIQM2fgl6bb1IrlT-b63Ag53zUlcFFWj5rbh0Ga53DLnmw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117584208506717612996/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117584208506717612996/reviews');
SET @user_varvar_pg = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117584208506717612996/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mladen Savuljic', 'https://lh3.googleusercontent.com/a/ACg8ocLhucxbp07jJVxvRBbcrCom4V0uuWxxTqGL7VTyxlrW9utWwA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103754267443729081826/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103754267443729081826/reviews');
SET @user_mladen_savuljic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103754267443729081826/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anita Kravas', 'https://lh3.googleusercontent.com/a/ACg8ocLXyRJl4Ehwwe0X7NG-sXH46d3PFKg6cUx6ByDUXKTotFYSeg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110923153739446988570/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110923153739446988570/reviews');
SET @user_anita_kravas = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110923153739446988570/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Moja Polisa', 'https://lh3.googleusercontent.com/a-/ALV-UjXtfbK4f94W6GXI57hUZxTEBB-b9Q13t4CkuOJb5YkisVYloOY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102204231020990799837/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102204231020990799837/reviews');
SET @user_moja_polisa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102204231020990799837/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Igor Kisic', 'https://lh3.googleusercontent.com/a-/ALV-UjWleqYngqBJ7C1wsHGdxtXbdj0XokAzkd7IORsrOHf3gytWiVTj=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116623617379371952271/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116623617379371952271/reviews');
SET @user_igor_kisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116623617379371952271/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tatjana Kisic', 'https://lh3.googleusercontent.com/a-/ALV-UjU6ule-TkSxXf-HD1dbD0X2oknKSRPDAsMuLV3xT4ICq0IBUnN0sQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108048059102333283858/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108048059102333283858/reviews');
SET @user_tatjana_kisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108048059102333283858/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nada Djukovic', 'https://lh3.googleusercontent.com/a/ACg8ocJ1PDXM1XkFRy07zWOdcPXCDZdKDHQOaJXwwxs1lbe67b8hLA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116069050707898696384/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116069050707898696384/reviews');
SET @user_nada_djukovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116069050707898696384/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rada Ostojic', 'https://lh3.googleusercontent.com/a/ACg8ocJUWTrSC1NgRjkRVDRekQ5N8tn3F51yvcl70etZ1XcU8a8qMw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102881701230478640724/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102881701230478640724/reviews');
SET @user_rada_ostojic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102881701230478640724/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Djordjina Lukateli', 'https://lh3.googleusercontent.com/a/ACg8ocJvBa4MoyMnmhLK9hUyZoLNoF6ktIk_j3sqIC5lRQdFD0hKJg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118151959969066718824/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118151959969066718824/reviews');
SET @user_djordjina_lukateli = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118151959969066718824/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nada Vukotic', 'https://lh3.googleusercontent.com/a-/ALV-UjUDaNO2zG5C5agMwSQ6UFs5ZjU1yUoWI9gWhlDQRHz6EcDvWFbe=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108166729483602182897/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108166729483602182897/reviews');
SET @user_nada_vukotic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108166729483602182897/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olga M', 'https://lh3.googleusercontent.com/a-/ALV-UjW2HCws78lKQhCfzo8w0a2Gf1hGehOaTDHHZWX0R_uOAR8ZNIov=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110463258012391760905/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110463258012391760905/reviews');
SET @user_olga_m = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110463258012391760905/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_masanikola_vukasovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/ChZDSUhNMG9nS0VPdW9vdnVnMk9LUkpBEAE',
    5, 'sr', '🙂',
    '🙂', '🙂', NULL, NULL, NULL, NULL,
    0, '2025-05-07 21:56:11'),

(@user_tatyana_nedzvetskaya, @clinic_id, @doctor_sandra_stanisic, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/Ci9DQUlRQUNvZENodHljRjlvT21oelJGbE1MVFpaUVZsR1UxWlZjMDlpZURCTlNIYxAB',
    1, 'en', 'My treatment at the DentArt clinic from May to August 2025 left an extremely negative impression. I went there to get a dental bridge installed but encountered a number of serious problems. The process was drawn out for more than three months, and I was not provided with temporary crowns, despite the doctor\'s promises, which led to complications.

The installed dental bridge caused severe pain, inflammation, and infection. When I asked to have it removed, Dr. Bojana Petrović prescribed antibiotics and suggested treating a healthy tooth, refusing to remove the bridge. Ultimately, after two months of suffering, I had to seek help at a clinic in Podgorica, where the bridge was filed off. An independent expert confirmed the poor quality of the work: tooth 5 under the crown had secondary decay, the crown on tooth 3 was filed down to the metal, and the clinic\'s diagnosis turned out to be incorrect.

The staff, including doctors Bojana Petrović and Sanda Stanišić, ignored my complaints and offered no adequate solution. My request for a refund and the return of my old, removed crown went unanswered, despite an official letter with proof of delivery. I was not given a refund; instead, the clinic suggested I take the matter to court. As a result, I was left without a prosthesis, without my money, without my good, removed crown, with additional treatment expenses, and two months of suffering.

I chose the clinic based on good reviews and modern equipment, but it seems the reviews are written by the clinic owners and doctors themselves to attract clients. I strongly advise everyone not to go to this clinic due to their incompetence and lack of responsibility.
It\'s a pity that I have to give 1 star instead of -100.',
    'Moje lečenje na klinici DentArt od maja do avgusta 2025. ostavilo je izuzetno negativan utisak. Otišao sam tamo da ugradim zubni most, ali naišao sam na niz ozbiljnih problema. Proces je bio razvučen više od tri meseca, a privremene krune mi nisu date, uprkos obećanjima lekara, što je dovelo do komplikacija.

Postavljeni zubni most je izazvao jak bol, upalu i infekciju. Kada sam zatražila da mi se ukloni, dr Bojana Petrović mi je prepisala antibiotike i predložila lečenje zdravog zuba, odbila da se ukloni most. Na kraju, nakon dva mjeseca patnje, morao sam da potražim pomoć na klinici u Podgorici, gdje je most otkinut. Nezavisni veštak je potvrdio loš kvalitet rada: zub 5 ispod krunice je imao sekundarni karijes, kruna na zubu 3 je bila oplepljena do metala, a dijagnoza klinike se pokazala netačnom.

Osoblje, među kojima su bile i doktorke Bojana Petrović i Sanda Stanišić, ignorisalo je moje pritužbe i nije ponudilo adekvatno rešenje. Moj zahtev za povraćaj novca i vraćanje moje stare, uklonjene krune ostao je bez odgovora, uprkos zvaničnom pismu sa dokazom o isporuci. Nije mi vraćen novac; umesto toga, klinika mi je predložila da tu stvar predam sudu. Kao rezultat toga, ostao sam bez proteze, bez svog novca, bez moje dobre, uklonjene krune, sa dodatnim troškovima lečenja i dva meseca muke.

Odabrao sam kliniku na osnovu dobrih kritika i moderne opreme, ali izgleda da recenzije pišu vlasnici klinike i sami lekari kako bi privukli klijente. Toplo savetujem svima da ne idu u ovu kliniku zbog svoje nekompetentnosti i neodgovornosti.
Šteta što moram da dam 1 zvezdicu umesto -100.', 'Моје лечење на клиници ДентАрт од маја до августа 2025. оставило је изузетно негативан утисак. Отишао сам тамо да уградим зубни мост, али наишао сам на низ озбиљних проблема. Процес је био развучен више од три месеца, а привремене круне ми нису дате, упркос обећањима лекара, што је довело до компликација.

Постављени зубни мост је изазвао јак бол, упалу и инфекцију. Када сам затражила да ми се уклони, др Бојана Петровић ми је преписала антибиотике и предложила лечење здравог зуба, одбила да се уклони мост. На крају, након два мјесеца патње, морао сам да потражим помоћ на клиници у Подгорици, гдје је мост откинут. Независни вештак је потврдио лош квалитет рада: зуб 5 испод крунице је имао секундарни каријес, круна на зубу 3 је била оплепљена до метала, а дијагноза клинике се показала нетачном.

Особље, међу којима су биле и докторке Бојана Петровић и Санда Станишић, игнорисало је моје притужбе и није понудило адекватно решење. Мој захтев за повраћај новца и враћање моје старе, уклоњене круне остао је без одговора, упркос званичном писму са доказом о испоруци. Није ми враћен новац; уместо тога, клиника ми је предложила да ту ствар предам суду. Као резултат тога, остао сам без протезе, без свог новца, без моје добре, уклоњене круне, са додатним трошковима лечења и два месеца муке.

Одабрао сам клинику на основу добрих критика и модерне опреме, али изгледа да рецензије пишу власници клинике и сами лекари како би привукли клијенте. Топло саветујем свима да не иду у ову клинику због своје некомпетентности и неодговорности.
Штета што морам да дам 1 звездицу уместо -100.', 'My treatment at the DentArt clinic from May to August 2025 left an extremely negative impression. I went there to get a dental bridge installed but encountered a number of serious problems. The process was drawn out for more than three months, and I was not provided with temporary crowns, despite the doctor\'s promises, which led to complications.

The installed dental bridge caused severe pain, inflammation, and infection. When I asked to have it removed, Dr. Bojana Petrović prescribed antibiotics and suggested treating a healthy tooth, refusing to remove the bridge. Ultimately, after two months of suffering, I had to seek help at a clinic in Podgorica, where the bridge was filed off. An independent expert confirmed the poor quality of the work: tooth 5 under the crown had secondary decay, the crown on tooth 3 was filed down to the metal, and the clinic\'s diagnosis turned out to be incorrect.

The staff, including doctors Bojana Petrović and Sanda Stanišić, ignored my complaints and offered no adequate solution. My request for a refund and the return of my old, removed crown went unanswered, despite an official letter with proof of delivery. I was not given a refund; instead, the clinic suggested I take the matter to court. As a result, I was left without a prosthesis, without my money, without my good, removed crown, with additional treatment expenses, and two months of suffering.

I chose the clinic based on good reviews and modern equipment, but it seems the reviews are written by the clinic owners and doctors themselves to attract clients. I strongly advise everyone not to go to this clinic due to their incompetence and lack of responsibility.
It\'s a pity that I have to give 1 star instead of -100.', NULL, NULL, NULL,
    1, '2025-10-02 21:03:03'),

(@user_essens, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twQmRFUnJhV1V3VkZCdFlqbGhUMGhDVFRoTFMwRRAB',
    1, 'ru', '(Переведено Google) Этим летом мне пломбировал зуб в клинике «ДентАрт» доктор Боян (пломба — 50, анестезия — 20). Я очень разочарован качеством лечения. Цемент был плохо очищен — я несколько дней сплевывал остатки. Пломбу не выровняли и не откорректировали, и язык потом болел ещё два дня. За такую ​​цену такой уровень лечения неприемлем. Не рекомендую эту клинику.

(Оригинал)
I had a tooth filling done at DentArt this summer by Dr. Boyana (filling — 50, anesthesia — 20). I’m very disappointed with the quality of the treatment. The cement wasn’t cleaned properly — I kept spitting out leftover pieces for several days. The filling wasn’t smoothed or adjusted, and my tongue hurt for two days afterward. For the price I paid, this level of care is unacceptable. I wouldn’t recommend this clinic.',
    '(Preveo Gugl) Letos sam uradio plombiranje zuba u klinici DentArt kod dr Bojane (plomba - 50, anestezija - 20). Veoma sam razočaran kvalitetom tretmana. Cement nije dobro očišćen - nekoliko dana sam ispljuvao ostatke. Ispuna se nije izravnala niti namjestila, a jezik me je bolio dva dana nakon toga. Za cenu, ovaj nivo tretmana je neprihvatljiv. Ne preporučujem ovu kliniku.

(Original)
Ovog leta sam uradila plombiranje zuba u DentArtu kod dr Bojane (plomba - 50, anestezija - 20). Veoma sam razočaran kvalitetom tretmana. Cement nije bio dobro očišćen - nekoliko dana sam pljuvao ostatke. Ispuna nije bila zaglađena niti podešena, a jezik me je boleo dva dana nakon toga. Za cenu koju sam platio, ovakav nivo nege je neprihvatljiv. Ne bih preporučio ovu kliniku.', '(Превео Гугл) Летос сам урадио пломбирање зуба у клиници ДентАрт код др Бојане (пломба - 50, анестезија - 20). Веома сам разочаран квалитетом третмана. Цемент није добро очишћен - неколико дана сам испљувао остатке. Испуна се није изравнала нити намјестила, а језик ме је болио два дана након тога. За цену, овај ниво третмана је неприхватљив. Не препоручујем ову клинику.

(Оригинал)
Овог лета сам урадила пломбирање зуба у ДентАрту код др Бојане (пломба - 50, анестезија - 20). Веома сам разочаран квалитетом третмана. Цемент није био добро очишћен - неколико дана сам пљувао остатке. Испуна није била заглађена нити подешена, а језик ме је болео два дана након тога. За цену коју сам платио, овакав ниво неге је неприхватљив. Не бих препоручио ову клинику.', NULL, '(Переведено Google) Этим летом мне пломбировал зуб в клинике «ДентАрт» доктор Боян (пломба — 50, анестезия — 20). Я очень разочарован качеством лечения. Цемент был плохо очищен — я несколько дней сплевывал остатки. Пломбу не выровняли и не откорректировали, и язык потом болел ещё два дня. За такую ​​цену такой уровень лечения неприемлем. Не рекомендую эту клинику.

(Оригинал)
I had a tooth filling done at DentArt this summer by Dr. Boyana (filling — 50, anesthesia — 20). I’m very disappointed with the quality of the treatment. The cement wasn’t cleaned properly — I kept spitting out leftover pieces for several days. The filling wasn’t smoothed or adjusted, and my tongue hurt for two days afterward. For the price I paid, this level of care is unacceptable. I wouldn’t recommend this clinic.', NULL, NULL,
    1, '2025-11-05 09:24:28'),

(@user_zarema_bakytzhan, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/Ci9DQUlRQUNvZENodHljRjlvT25JdFFrdHFjMjVvWW1FMGEzSXpSREk1ZFRKcE5tYxAB',
    5, 'ru', 'Врачи очень дружелюбные и ассистент тоже очень милая и образованная. Я очень рада, что наконец-то нашла образованного и отзывчивого стоматолога. И большое спасибо, рекомендую всем.🥹🥹🥹',
    'Doktori su veoma ljubazni, a asistent je takođe veoma fin i obrazovan. Tako mi je drago što sam konačno pronašao obrazovanog i brižnog zubara. Hvala vam puno, preporučujem ga svima.🥹🥹🥹', 'Доктори су веома љубазни, а асистент је такође веома фин и образован. Тако ми је драго што сам коначно пронашао образованог и брижног зубара. Хвала вам пуно, препоручујем га свима.🥹🥹🥹', NULL, 'Врачи очень дружелюбные и ассистент тоже очень милая и образованная. Я очень рада, что наконец-то нашла образованного и отзывчивого стоматолога. И большое спасибо, рекомендую всем.🥹🥹🥹', NULL, NULL,
    0, '2025-11-04 19:12:47'),

(@user_antonio_bolanca, @clinic_id, @doctor_zorica_popovic, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xocWJFVndXak5OVUhaUGVYcE1WRmhaUWpSblVsRRAB',
    5, 'hr', 'Moram se javno zahvaliti dr.Zorici Popović na izrazito velikoj razini strucnosti i strpljenja. Hvala puno na svemu! Odličan ste tim i predivni ljudi.',
    'Moram javno da se zahvalim dr Zorici Popović na izuzetno visokom nivou stručnosti i strpljenja. Hvala vam puno na svemu! Vi ste sjajan tim i divni ljudi.', 'Морам јавно да се захвалим др Зорици Поповић на изузетно високом нивоу стручности и стрпљења. Хвала вам пуно на свему! Ви сте сјајан тим и дивни људи.', NULL, NULL, NULL, NULL,
    0, '2025-08-17 15:10:48'),

(@user_alon_fux, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KSFNHaE1TbmRoY1dKYWFrUnVZMWxuVUVGd1JGRRAB',
    5, 'he', 'מקצועי. נהדר',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_veljko_tani, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pGR1l6aFJMWE5tVUU4Mk1rcFFVMU15TFhOeVVWRRAB',
    5, 'hr', 'Ljubazno osoblje i kvalitetna usluga.
Za svaku preporuku.',
    'Ljubazno osoblje i kvalitetna usluga.
Za svaku preporuku.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_yacht_monty_b, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/Ci9DQUlRQUNvZENodHljRjlvT20xaGJFWlNNbUZ0VmtFNE1YRmtkV2hGZUdkVlJuYxAB',
    5, 'en', 'I\'ve been coming here for 12 years and have had extensive work done. All the work has been fantastic and great value, there is no way I could have afforded all that in my home country so I am very grateful. The staff are always friendly and professional, so I am surprised to see any negative reviews. I recommend them to all the other sailors in the marina without hesitation.',
    NULL, NULL, 'I\'ve been coming here for 12 years and have had extensive work done. All the work has been fantastic and great value, there is no way I could have afforded all that in my home country so I am very grateful. The staff are always friendly and professional, so I am surprised to see any negative reviews. I recommend them to all the other sailors in the marina without hesitation.', NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_lena_kovacevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tJdFoyVjJVSFUyYmxrM2RHTTBlamRuWjFGWFIyYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_matija_pantovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/Ci9DQUlRQUNvZENodHljRjlvT25obFdUSktObUZqWWxKbWJqZFhRa1Z1YUhka1YwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_sasha, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2sxM0xWVjNXbVZLYzJwWFQxcGxjek5hVEdNMFZtYxAB',
    5, 'en', 'Thank you so much for all your help. No more pain, no more switching doctors thank you.',
    NULL, NULL, 'Thank you so much for all your help. No more pain, no more switching doctors thank you.', NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_paula_petkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/Ci9DQUlRQUNvZENodHljRjlvT205dlkyRm1MVkZ3ZVU1bmJGSjFPVUl4ZDJSTFZHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_milica_konatar, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pnMWNFTlZWRlU1Vm5CTGRsazRPWFpXZGtkMlkxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_narek_gevorkian, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/Ci9DQUlRQUNvZENodHljRjlvT21SaWRUSkRVRnBTYkU5aFVGbzBVa0ZWZG1kV05XYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_stari_vujadin, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/ChZDSUhNMG9nS0VJQ0FnTUNZb2NLUkNREAE',
    1, 'bs', 'Vrlo neprofesionalno, 10 puta pozivani u dva dana da zakažemo, niko se nije udostojio da se javi. Na poruke isto ništa. Sramotno od jedne zdravstvene ustanove.',
    'Vrlo neprofesionalno, 10 puta pozivani u dva dana da zakažemo, niko se nije udostojio da se javi. Na poruke isto ništa. Sramotno od jedne zdravstvene ustanove.', NULL, NULL, NULL, NULL, NULL,
    1, '2025-10-29 00:00:00'),

(@user_masha_miller, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNsemFiV29RRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_varvar_pg, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/ChdDSUhNMG9nS0VJQ0FnSURhOHBEVHFBRRAB',
    1, 'hr', 'Ako zubarka ima zadah iz usta onda vam to dovoljno govori koliko zna o higijeni i o tome kako se vodi racuna o zubima.

Ukratko receno, nestrucno, nekulturno i neobrazovano osoblje.

Stay away!',
    'Ako zubarka ima zadah iz usta onda vam to dovoljno govori koliko zna o higijeni i o tome kako se vodi racuna o zubima.

Ukratko receno, nestrucno, nekulturno i neobrazovano osoblje.

Stay away!', NULL, NULL, NULL, NULL, NULL,
    2, '2021-10-29 00:00:00'),

(@user_mladen_savuljic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNhMWZidlpBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_anita_kravas, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/ChdDSUhNMG9nS0VJQ0FnSUN3MDdleml3RRAB',
    5, 'en', 'Wow! That’s the best way to describe how satisfied I was after having my 6 front teeth restored . I would like to thank the most wonderful doctor Natalia Samarina ( the Russian lady) for her professionalism.

I always had bad teeth, but after having my son 2,5 years ago they have deteriorated rapidly and I started loosing my enamel , it was literally flaking  away :(

I went to my dentist in the UK and she said the only option was to go for veneers.... but boy they are expensive:(

I found Natalia online since I already booked my holidays in Montenegro, so combining dental work with holidays was very attractive idea.

She gave me initial quote based on the pictures and said she can do a cosmetic restoration instead of veneers and I went for it .

I’ve gained my confidence back, I can smile widely now, you really made the difference Natalia !

Thank you so much and hope to see you again next year :)

Regards
Anita',
    NULL, NULL, 'Wow! That’s the best way to describe how satisfied I was after having my 6 front teeth restored . I would like to thank the most wonderful doctor Natalia Samarina ( the Russian lady) for her professionalism.

I always had bad teeth, but after having my son 2,5 years ago they have deteriorated rapidly and I started loosing my enamel , it was literally flaking  away :(

I went to my dentist in the UK and she said the only option was to go for veneers.... but boy they are expensive:(

I found Natalia online since I already booked my holidays in Montenegro, so combining dental work with holidays was very attractive idea.

She gave me initial quote based on the pictures and said she can do a cosmetic restoration instead of veneers and I went for it .

I’ve gained my confidence back, I can smile widely now, you really made the difference Natalia !

Thank you so much and hope to see you again next year :)

Regards
Anita', NULL, NULL, NULL,
    2, '2018-10-29 00:00:00'),

(@user_moja_polisa, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNRNjl1dTJRRRAB',
    5, 'en', 'Place to go for perfect smile! :-)',
    NULL, NULL, 'Place to go for perfect smile! :-)', NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_igor_kisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNnb05lRkx3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_tatjana_kisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/ChZDSUhNMG9nS0VJQ0FnSURRdDQ2Mld3EAE',
    5, 'hr', 'Devojke, super ste!!!',
    'Devojke, super ste!!!', NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_nada_djukovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNnX0pDQjJnRRAB',
    5, 'bs', 'Divni su... kvalitet na nivou😊 Sve pohvale...',
    'Divni su... kvalitet na nivou😊 Sve pohvale...', NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_rada_ostojic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/ChZDSUhNMG9nS0VJQ0FnSURnblB5RUpREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_djordjina_lukateli, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNBMUltdWt3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_nada_vukotic, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNRX3RYanNRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_olga_m, @clinic_id, NULL, 'google_maps',
    'places/ChIJFyjGiygyTBMROATKetg5SU8/reviews/ChZDSUhNMG9nS0VJQ0FnSURBdm9yd013EAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
