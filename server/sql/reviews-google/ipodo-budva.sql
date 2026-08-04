-- Insert Google Maps reviews for iPODO - centar za podologiju (Budva)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/ipodo-budva.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJZZCl95fVTRMReLlhoR499pY' LIMIT 1);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stella Lei', 'https://lh3.googleusercontent.com/a/ACg8ocIn0iV8H6gD4mLOBO57rU5gtNZy3iu-0SpY901s8EJf9C731Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116000917165184605977/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116000917165184605977/reviews');
SET @user_stella_lei = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116000917165184605977/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Екатерина Кокорина', 'https://lh3.googleusercontent.com/a/ACg8ocJ0FuYL1pOGYXLmHaMHO5nmlmIQzkFC05rrUAmiSDeUWuJynA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113449134715659622269/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113449134715659622269/reviews');
SET @user_ekaterina_kokorina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113449134715659622269/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'aanna maslova', 'https://lh3.googleusercontent.com/a/ACg8ocKq6WPcdSXZcGYehxu2tPgrEZTAj1Ximhb1g4Ny4uQgGTR96w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118442127991480727445/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118442127991480727445/reviews');
SET @user_aanna_maslova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118442127991480727445/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Roman Montenegro', 'https://lh3.googleusercontent.com/a-/ALV-UjUS0e_ucrhPpnttgCMy7WolYyx76QWYtu2Qb_mCEffZBNXRBicI=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103610793375881530239/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103610793375881530239/reviews');
SET @user_roman_montenegro = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103610793375881530239/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anna', 'https://lh3.googleusercontent.com/a/ACg8ocJU_sis8Lt_2rHtxs5ptH5uwWPsdX78PQMZ8Ty6icNzOTxq2Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112587366390891852916/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112587366390891852916/reviews');
SET @user_anna = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112587366390891852916/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nata Lia', 'https://lh3.googleusercontent.com/a-/ALV-UjXbyYXuYHV3vsSq2M9H5ngzHh1TY-UrKS3jXNrYDMUPGSDSCiA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104710043421221363430/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104710043421221363430/reviews');
SET @user_nata_lia = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104710043421221363430/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Наталия Ш', 'https://lh3.googleusercontent.com/a/ACg8ocKG6jWiyQjIjE4KrJf96cr5QaffDZI3gIBWo4t5a5WoU2Fw3Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110192427088315232784/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110192427088315232784/reviews');
SET @user_nataliya_sh = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110192427088315232784/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kyrian', 'https://lh3.googleusercontent.com/a/ACg8ocK1Dd2jXpj_pF8u7YIjA3fKaaDorVmP6ns-VGM9OcqYnTOZ2g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108365192287779812138/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108365192287779812138/reviews');
SET @user_kyrian = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108365192287779812138/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Francesca de Gregorio', 'https://lh3.googleusercontent.com/a/ACg8ocKacbOfQQlkdqqdDVy3-6Z2mt8T-QWkjyhyXfx1trSiRxlCEw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114930009572648654178/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114930009572648654178/reviews');
SET @user_francesca_de_gregorio = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114930009572648654178/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Иришка', 'https://lh3.googleusercontent.com/a/ACg8ocLVmf_AgesGsAtNdiJJr30IMWll9kTEoVp_05BDo7VEPNTFIw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110051919677859938138/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110051919677859938138/reviews');
SET @user_irishka = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110051919677859938138/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Олеся Подойникова', 'https://lh3.googleusercontent.com/a/ACg8ocIkRszZE2iFf3zdI8nOVFHdovj2_rbyb3aZU3thBTKYmVH8qw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117045599640124852383/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117045599640124852383/reviews');
SET @user_olesya_podoynikova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117045599640124852383/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'гуль устинова', 'https://lh3.googleusercontent.com/a-/ALV-UjUy4G_JtZ9HV8ew28mm9Hndsgbm6kprEnnvkhjRU-B0mW64FxA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112595289810323694975/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112595289810323694975/reviews');
SET @user_gul_ustinova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112595289810323694975/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ямико вив', 'https://lh3.googleusercontent.com/a/ACg8ocIA1m1sEkzX2rbEmBEqGxrptx7z6GOgFY7XWwKIl1dVCt9Oyg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110348607569422591129/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110348607569422591129/reviews');
SET @user_yamiko_viv = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110348607569422591129/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Дина Грубник', 'https://lh3.googleusercontent.com/a/ACg8ocIbKqhMYjGsK1Cm20aQOzVfTxYnEjUl-En5-Cf-S4PcI5XJVg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107609804445774040302/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107609804445774040302/reviews');
SET @user_dina_grubnik = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107609804445774040302/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Светлана Чумакова', 'https://lh3.googleusercontent.com/a/ACg8ocIvgZOP7zSSvzXrDHypeCW31Cj5KqVRchTHTi5nzFZ3wZiBjw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114494394084760728581/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114494394084760728581/reviews');
SET @user_svetlana_chumakova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114494394084760728581/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dinar', 'https://lh3.googleusercontent.com/a/ACg8ocJFXQTn94boc5LFFUjHMoPtxwNFEqhmlh62Ucpl2cA_92dFUw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104303776871432655793/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104303776871432655793/reviews');
SET @user_dinar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104303776871432655793/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Камила', 'https://lh3.googleusercontent.com/a/ACg8ocKvQCpYazPuSSj_e4805NzBK8_ZCpAx68GMc7Dp6g5Xlu0_Hw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111571842214136340030/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111571842214136340030/reviews');
SET @user_kamila = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111571842214136340030/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Алексей Михайлов', 'https://lh3.googleusercontent.com/a/ACg8ocIIhK5qW07kuMiuHcXwlMkS6k8X5ToVFB8aCT3HrgYW2sTKmA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116099328559551969430/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116099328559551969430/reviews');
SET @user_aleksey_mikhaylov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116099328559551969430/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anne', 'https://lh3.googleusercontent.com/a/ACg8ocLH3IMMqWonJqsD50HVMzO2KYAaFuDze7bVVt8QlOWC1HhnnA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112548809992591385193/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112548809992591385193/reviews');
SET @user_anne = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112548809992591385193/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ольга Бурнашова', 'https://lh3.googleusercontent.com/a-/ALV-UjUhIT-DK8PWr5Y7sPJ31TlzL2hr2uZdg6XyIW-E2v5mRuuCU8oN=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116208867349741206948/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116208867349741206948/reviews');
SET @user_olga_burnashova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116208867349741206948/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olga Trofimova', 'https://lh3.googleusercontent.com/a-/ALV-UjXUxpYBWrew9kQosuNwPJBCCucDumuzq4_ldhEpfKGp_mPAlOQb=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100475687895620666386/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100475687895620666386/reviews');
SET @user_olga_trofimova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100475687895620666386/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Uladzislau Sasnouski', 'https://lh3.googleusercontent.com/a-/ALV-UjW9mn45iAonrQjji-CUlKSawpVoQjNv_oeFTSE2W5Mzr7dSpZI=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109162659839454644086/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109162659839454644086/reviews');
SET @user_uladzislau_sasnouski = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109162659839454644086/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Уляна Ковалевська', 'https://lh3.googleusercontent.com/a/ACg8ocLal78KagwU1SOrmm175APcdGMgMBP2Yt5MgtXNw2vgNsxK=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116456668646367319109/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116456668646367319109/reviews');
SET @user_ulyana_kovalevska = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116456668646367319109/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marina Rabrenovic', 'https://lh3.googleusercontent.com/a/ACg8ocJCputkIU7gTArEBeYWlxJNlH-pvVPHYaE3w3f69uXfPzXpcw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103142861971088076641/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103142861971088076641/reviews');
SET @user_marina_rabrenovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103142861971088076641/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Светлана Золотарева', 'https://lh3.googleusercontent.com/a/ACg8ocLcNzrBtRiuu1spzj2inPTmTjisoybo0UnSDFYGi7ph6tKM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103092640335930693301/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103092640335930693301/reviews');
SET @user_svetlana_zolotareva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103092640335930693301/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tanja Perović', 'https://lh3.googleusercontent.com/a-/ALV-UjWIrT0Hq5fjtfH5cbWD2KAYw8FjshiF5qX2FxEtgMvxLXvb9i2c=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118186653720010841450/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118186653720010841450/reviews');
SET @user_tanja_perovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118186653720010841450/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anastasia Luta', 'https://lh3.googleusercontent.com/a-/ALV-UjUe3kOuK1MlgAm1qq-IWMeT_HbQmyX1XPPG9zUFbuagGLbzVZ4u=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108795398178918790263/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108795398178918790263/reviews');
SET @user_anastasia_luta = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108795398178918790263/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikoletta Petridou', 'https://lh3.googleusercontent.com/a-/ALV-UjX-eKlFYikf_gn13qbWSw2zmu9R6sl6MNoiY5oXjfsVF4c9JSAr=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105512920159440107405/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105512920159440107405/reviews');
SET @user_nikoletta_petridou = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105512920159440107405/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Perovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVNsy0x4yoZhkCzVR5Msx89kSeatpCkCipIY11imBKuHpHmdXKp=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107550931749316048440/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107550931749316048440/reviews');
SET @user_jelena_perovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107550931749316048440/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Екатерина Хотеичева', 'https://lh3.googleusercontent.com/a-/ALV-UjUmpE1_cr3HXVgFBrPY5MTCoIHsDGFWj-blg8xZHwCUeqf1kj61=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115790537615254568028/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115790537615254568028/reviews');
SET @user_ekaterina_khoteicheva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115790537615254568028/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ludmila Levchik', 'https://lh3.googleusercontent.com/a/ACg8ocKX3AkfoOnULAShBjmMHD8j6VDQSZtJH1Ac-edfFj_WkIq1TA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107555481469770213588/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107555481469770213588/reviews');
SET @user_ludmila_levchik = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107555481469770213588/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mila Bejatovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUfH60Aw1vXrxgAnQr-URHN2pk_UaLfrxmx3NPx29NFfiNBmRg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109067782549990688304/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109067782549990688304/reviews');
SET @user_mila_bejatovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109067782549990688304/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra Andric', 'https://lh3.googleusercontent.com/a/ACg8ocLnIvaJaj0VbEYcd2MyNvQA-YqhbrY2pOiBtfagMeEd9kV6ytI=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104958444166397123288/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104958444166397123288/reviews');
SET @user_aleksandra_andric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104958444166397123288/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elena Galuchko', 'https://lh3.googleusercontent.com/a/ACg8ocJHEFcUT2FVFcpYedXurGmJhVe1kpXKuaj-YWfmcaxCBFcCZA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101993141547341347600/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101993141547341347600/reviews');
SET @user_elena_galuchko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101993141547341347600/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ala Drighenici', 'https://lh3.googleusercontent.com/a/ACg8ocJ-Y67ObPATwDHaHqXreC_agszE6MQGiEqmDYkAiJR1L3aDGQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116539358500456164244/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116539358500456164244/reviews');
SET @user_ala_drighenici = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116539358500456164244/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elena', 'https://lh3.googleusercontent.com/a-/ALV-UjX-xb9leYf_BL0GmftA3MzRYZqwzDwTJbnH461gu4Yiw2Zj_7Ou=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109550804450996032749/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109550804450996032749/reviews');
SET @user_elena = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109550804450996032749/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Татьяна Богданова', 'https://lh3.googleusercontent.com/a-/ALV-UjW3z_JvQoTD3nTlTni2GpLwxS_ELJ7koMfnCXUqcaWSaxaI46c=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110738122877170851916/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110738122877170851916/reviews');
SET @user_tatyana_bogdanova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110738122877170851916/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Taisia Kim', 'https://lh3.googleusercontent.com/a-/ALV-UjVOBxQa2a34lV9frMs9CLoBB1fdDCLwUfb0_BMZe0pjaoyE4LoY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115733681288077049024/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115733681288077049024/reviews');
SET @user_taisia_kim = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115733681288077049024/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Евгения Петрович', 'https://lh3.googleusercontent.com/a/ACg8ocKCpvDAH6kiDzlW49DUAAgq9Lq5vIHsgDy48ZnMyjjrf8jjuQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101868350269035339751/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101868350269035339751/reviews');
SET @user_evgeniya_petrovich = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101868350269035339751/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Evgeniya Merkel', 'https://lh3.googleusercontent.com/a-/ALV-UjV4dYPTZ8_btS2h6lzJwuAhqfBZZhit4PvSu0LO7O15y0RPpwnA5w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103371858841166219881/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103371858841166219881/reviews');
SET @user_evgeniya_merkel = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103371858841166219881/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'aini hämäläinen', 'https://lh3.googleusercontent.com/a-/ALV-UjVXISazeFDGTja9lszfSuhUDhCcmDv7BdMA5hMRY7kEeel0qrxp=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104272150692178842366/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104272150692178842366/reviews');
SET @user_aini_hmlinen = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104272150692178842366/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Юрий Мажулин', 'https://lh3.googleusercontent.com/a/ACg8ocIapPB2l_6JEHVu0wtthXR5v3O6UhmKbhynVxGDjrkhv0U5PQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114359184454272883559/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114359184454272883559/reviews');
SET @user_yuriy_mazhulin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114359184454272883559/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Андрей Казанцев', 'https://lh3.googleusercontent.com/a-/ALV-UjUu_rs_XCsLNgD0jjKCIcRJp-bGw5nenH21g_qesGiIW9_l0e0=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110715142489382440676/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110715142489382440676/reviews');
SET @user_andrey_kazantsev = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110715142489382440676/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olga Tadic', 'https://lh3.googleusercontent.com/a-/ALV-UjWmdptuQq4b1TEsZRe5ch2psCkygBq2WnUONx4wC0JqV3vZ7aM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105281266757161111249/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105281266757161111249/reviews');
SET @user_olga_tadic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105281266757161111249/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladimirs Kozlovs', 'https://lh3.googleusercontent.com/a-/ALV-UjWh7thF0-lhZFEguxbnOvYV012cAmGzBKyYTfFGJDkj_-KSGiR2Kw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114620292917985200323/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114620292917985200323/reviews');
SET @user_vladimirs_kozlovs = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114620292917985200323/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Uchiha Sasuke', 'https://lh3.googleusercontent.com/a/ACg8ocKTRy9_VvO_Hp7mSE7CJJHh2L5hS4xXdrRZtR4Si08TR8quwQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112746492672224174200/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112746492672224174200/reviews');
SET @user_uchiha_sasuke = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112746492672224174200/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Олеся Чернявская', 'https://lh3.googleusercontent.com/a/ACg8ocKnvGBAaTto-3lxopt-GVTuVC-rCu46eA5K10B-o8ozsDajZMY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102409482956256822203/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102409482956256822203/reviews');
SET @user_olesya_chernyavskaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102409482956256822203/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Daria', 'https://lh3.googleusercontent.com/a/ACg8ocIbAdr-h0WfGjxeGq1Y1UtG34qSAUsKegLiSjPu3siFiqN-Yg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112289407246012274826/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112289407246012274826/reviews');
SET @user_daria = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112289407246012274826/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dominika Trufan', 'https://lh3.googleusercontent.com/a-/ALV-UjUUdWcNlzjhsvMUlEjmNWVQxXrHJbBXPXdZ1HybOHAaA3kTJ2I=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110699922533883820374/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110699922533883820374/reviews');
SET @user_dominika_trufan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110699922533883820374/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ирина Сергеева', 'https://lh3.googleusercontent.com/a/ACg8ocKNxu5pu2pkYGNawak7iA7muwcmaZpwBZCe1chgrLHHBmb-=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102421186152058159295/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102421186152058159295/reviews');
SET @user_irina_sergeeva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102421186152058159295/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elena Kuzina', 'https://lh3.googleusercontent.com/a/ACg8ocKfIjNNwjF1L0Va2x2WLvwNESJkEr6m5sMaqsOS0m3Zmjippg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107486561032993826834/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107486561032993826834/reviews');
SET @user_elena_kuzina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107486561032993826834/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anna Kutuzova', 'https://lh3.googleusercontent.com/a/ACg8ocKlPsEC4Z3AvV-tCrNIrxFz1Ag4oW1Trc4wld0gyCQAmZR4Yw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104604070768549226114/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104604070768549226114/reviews');
SET @user_anna_kutuzova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104604070768549226114/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'nazli baysak', 'https://lh3.googleusercontent.com/a-/ALV-UjWPxLaqRswSJLMNT2SY7K9zdeDLIQt2PAsef-OP2QdkHly7GGNW=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117389410112314554151/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117389410112314554151/reviews');
SET @user_nazli_baysak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117389410112314554151/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Оксана Лозовицкая', 'https://lh3.googleusercontent.com/a-/ALV-UjV4gBoEdqdiJSIOjrqYhmM51nuiVaNt61-mj58gMmAUwj7BN3o=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104900269152894760784/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104900269152894760784/reviews');
SET @user_oksana_lozovitskaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104900269152894760784/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olga Rododendron', 'https://lh3.googleusercontent.com/a-/ALV-UjVe3myA4jXYqe7tAa4SJLTmWRVmU6kGx7TELiSddz0IUrYw-pQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100905705420701742163/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100905705420701742163/reviews');
SET @user_olga_rododendron = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100905705420701742163/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Александр Вычеров', 'https://lh3.googleusercontent.com/a/ACg8ocK1a66cuva7lvxccmqfuPUqK0rxt7e6aSjq0_2wOGQC9cRQaQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113476526706137573805/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113476526706137573805/reviews');
SET @user_aleksandr_vycherov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113476526706137573805/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Inna Holikova', 'https://lh3.googleusercontent.com/a-/ALV-UjWMQowyXHSGxLJhW9rHhB1MSc2kY3T96WjZbD8PzumPJ4CsJGU=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108126171610908419040/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108126171610908419040/reviews');
SET @user_inna_holikova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108126171610908419040/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Светлана Хрусталева', 'https://lh3.googleusercontent.com/a/ACg8ocK1E8BFNarCpletna3GB-PSwkjh8yeUXYy2f4oXV9UWV5h6=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118079831003512227817/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118079831003512227817/reviews');
SET @user_svetlana_khrustaleva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118079831003512227817/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nataliia Semenova', 'https://lh3.googleusercontent.com/a-/ALV-UjVFGRlV_QxhfMj1mK77WOZdG30KsoVqNs3eNypEmTOi2eAQ39Pv=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116739528731133208116/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116739528731133208116/reviews');
SET @user_nataliia_semenova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116739528731133208116/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Любовь Смирнова', 'https://lh3.googleusercontent.com/a-/ALV-UjW2jxhOq7ZncNNoJSRqdUgOhRRD6cwV_UGrWsXHFGpbUz8T4ms=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107815234110122781837/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107815234110122781837/reviews');
SET @user_lyubov_smirnova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107815234110122781837/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anna Makarova', 'https://lh3.googleusercontent.com/a/ACg8ocL1IhLhpLCcy5COg3fY8tjv6OOH3YISxjzUAOzllzwAXn3nZg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111150776202956214312/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111150776202956214312/reviews');
SET @user_anna_makarova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111150776202956214312/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Виктория Случайная', 'https://lh3.googleusercontent.com/a-/ALV-UjW06QxzKTPTIM-pwDIfF1w72f6vyQP666f5a6rkOoGOnJdSd74lcA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116060433300267417140/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116060433300267417140/reviews');
SET @user_viktoriya_sluchaynaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116060433300267417140/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Милла', 'https://lh3.googleusercontent.com/a/ACg8ocI9LSlStx4Whk1se6y-gSVN7CXQOe8fWzA_PyTX5nJbZeRSkQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114482516869282172602/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114482516869282172602/reviews');
SET @user_milla = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114482516869282172602/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Виктория Лутай', 'https://lh3.googleusercontent.com/a/ACg8ocLADLLSmzemsXi4jiI8vCeY73mIuDDyJ9yBIalCsPot2Shp_g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110367571776824862234/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110367571776824862234/reviews');
SET @user_viktoriya_lutay = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110367571776824862234/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Людмила Гончарова', 'https://lh3.googleusercontent.com/a/ACg8ocJQvtc4yu-8qnLsz4a3otvLLh6CVuPwKc4lxROVTxfwQC46Yw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113290958580338780706/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113290958580338780706/reviews');
SET @user_lyudmila_goncharova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113290958580338780706/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Daniela Medina', 'https://lh3.googleusercontent.com/a-/ALV-UjVg8gDWllJYSA_4sKqLOhIHP7XyeV6BrYgE95Qzf6Hds7xeYUUr=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107578735320616366527/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107578735320616366527/reviews');
SET @user_daniela_medina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107578735320616366527/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Сергей Кожин', 'https://lh3.googleusercontent.com/a-/ALV-UjVtTCN8VGgkCNdiW7ceFOtGtOM6LFRp05r1Pqz099Oy_ebrJLUD=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102548088487959191251/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102548088487959191251/reviews');
SET @user_sergey_kozhin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102548088487959191251/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tatyana Trofimenko', 'https://lh3.googleusercontent.com/a/ACg8ocJurtkFs-kqD9Ca0RA9BImnxA1G-1Cg_Tw9oRL6HuP6XhNNWQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114291175387131579647/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114291175387131579647/reviews');
SET @user_tatyana_trofimenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114291175387131579647/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natalia Migal', 'https://lh3.googleusercontent.com/a-/ALV-UjWaM22ol4qB9fEzbj7STcR8C_WTJQvq4em3oFkgboMKzfcxpJk=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106791273406405170435/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106791273406405170435/reviews');
SET @user_natalia_migal = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106791273406405170435/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ruzanna Manukyan', 'https://lh3.googleusercontent.com/a-/ALV-UjWSgscGO8NIC6JwZDNYLzhv6bHJUmoj4OSysnyaYrk2V4f_qpvz=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104347259629190385134/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104347259629190385134/reviews');
SET @user_ruzanna_manukyan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104347259629190385134/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra Kazachkova', 'https://lh3.googleusercontent.com/a-/ALV-UjVeJBAorJA6xJLw1Bv1-5D-BoCpWO_yz_zGA49yoSxqEzqTxyM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111118088990708502104/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111118088990708502104/reviews');
SET @user_aleksandra_kazachkova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111118088990708502104/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alina Mrakich', 'https://lh3.googleusercontent.com/a/ACg8ocKXTiUBgDYKkp5pRQvRdFisOTfstQn8U-FwlYEdzUGb-r9bTA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104097797786631483254/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104097797786631483254/reviews');
SET @user_alina_mrakich = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104097797786631483254/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elina Tyger', 'https://lh3.googleusercontent.com/a-/ALV-UjWeP7fSVK4Kxtyl2Jio-l8B_sqnnNlHHKLpHia9OrerVEHnc1vVsg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109112728419711179265/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109112728419711179265/reviews');
SET @user_elina_tyger = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109112728419711179265/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Viktor Kram', 'https://lh3.googleusercontent.com/a-/ALV-UjW6pWxoPWoqCefBkeKT9OetfcJvN0o1YRSmBQgzF5cHnwFZ9Dom=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117178867765608212529/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117178867765608212529/reviews');
SET @user_viktor_kram = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117178867765608212529/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Наталья', 'https://lh3.googleusercontent.com/a/ACg8ocJaAPOuZpBokiiIN_2MwG9UxXTe2GP9YFjlYo4tbEC4zrPMDA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109854182108301890780/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109854182108301890780/reviews');
SET @user_natalya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109854182108301890780/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Мария', 'https://lh3.googleusercontent.com/a/ACg8ocIRk7sYKIhdWBs3o6AgnmXlgxXYg2QeO-rLYHY9cCQwxQxbXg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106156782422129561998/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106156782422129561998/reviews');
SET @user_mariya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106156782422129561998/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Yana Boyko', 'https://lh3.googleusercontent.com/a-/ALV-UjX0rh5rF6V4co5pet5HGmZXCvvrjXoZBItOSEifW3eCyiEC_eOR=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114789892074922209108/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114789892074922209108/reviews');
SET @user_yana_boyko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114789892074922209108/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Дана Фёдорова', 'https://lh3.googleusercontent.com/a-/ALV-UjUsqTBUpVLhDxz7VMq5L-OpzJ4QGyS5eHaoLpBFOivhsAnd5TFt=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100880640412537088425/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100880640412537088425/reviews');
SET @user_dana_fyodorova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100880640412537088425/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elina Likar', 'https://lh3.googleusercontent.com/a-/ALV-UjXt_QtnN4PHwJb78kzqHyOIP64BiIFqBwbNsHOyYew1nJ_ERw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109540688500242812080/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109540688500242812080/reviews');
SET @user_elina_likar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109540688500242812080/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Светлана Иванова', 'https://lh3.googleusercontent.com/a/ACg8ocLfO7M9HBBAN24VQEciX7sXYyUUaahEs_Ow2o8dubKiS8Sgiw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116745189730797821437/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116745189730797821437/reviews');
SET @user_svetlana_ivanova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116745189730797821437/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nadezhda Ivanenko', 'https://lh3.googleusercontent.com/a-/ALV-UjVPb0VfUDzoxbCVhxK_zLycfLYWM1ZFwIV97v4UVDUHOV5yjDDHmA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112534594905106115074/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112534594905106115074/reviews');
SET @user_nadezhda_ivanenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112534594905106115074/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Владислава', 'https://lh3.googleusercontent.com/a/ACg8ocInt3apUCBridKHvxEPGIK9YNl0i2VRaEIEIIxMvpdknv_qNA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109674647372395782003/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109674647372395782003/reviews');
SET @user_vladislava = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109674647372395782003/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Кристина Кушнир', 'https://lh3.googleusercontent.com/a-/ALV-UjVCu5SzPMH9i4WjP16FiteO4MvjMZGhiFpp4N85VCEemQAcfYg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103139303969676565135/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103139303969676565135/reviews');
SET @user_kristina_kushnir = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103139303969676565135/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Milosavljevic', 'https://lh3.googleusercontent.com/a/ACg8ocL54mkNGuiSenRntD2_TbLiTn7jbhpeuY4K7J6jl3mFG0-BbYk=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101199560619110723325/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101199560619110723325/reviews');
SET @user_ana_milosavljevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101199560619110723325/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olga Shvets', 'https://lh3.googleusercontent.com/a/ACg8ocKUAgFcHqiyeAhhNv0V8ePuRHN2myCkJItFEpmh-nPZuk-Y0A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103472509186587547045/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103472509186587547045/reviews');
SET @user_olga_shvets = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103472509186587547045/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Инна Чалуева', 'https://lh3.googleusercontent.com/a-/ALV-UjUZk0wp_E37r4Rb827o3et5udCDIIdoFrQbwTwLU8y6EC3KQ9NN=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116536122099481475442/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116536122099481475442/reviews');
SET @user_inna_chalueva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116536122099481475442/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lev Alekseev', 'https://lh3.googleusercontent.com/a/ACg8ocJq6wZyQXetPMswYgv2xxyGaopvZpaUvbrHa-bfcQgpUHGjXY4m=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113539458026271629262/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113539458026271629262/reviews');
SET @user_lev_alekseev = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113539458026271629262/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Анна Логинова', 'https://lh3.googleusercontent.com/a/ACg8ocJ-VNX89BlAq2lcQmWqH9Pa6b6sYXRmotj6P2gGSJK-j6WMJg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104876998541282493600/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104876998541282493600/reviews');
SET @user_anna_loginova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104876998541282493600/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'zhenya zhenya', 'https://lh3.googleusercontent.com/a/ACg8ocKONgBP9KMFiHvjec5xTq6YlYlOTi1TAUJQIQbhqgj81aBYow=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116193927765455554265/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116193927765455554265/reviews');
SET @user_zhenya_zhenya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116193927765455554265/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anna Anna', 'https://lh3.googleusercontent.com/a/ACg8ocLy4UjxVkzg9nUQrztFJdByutj6cS7ayQlhjAh9FArHumXtPA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110587328955103587632/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110587328955103587632/reviews');
SET @user_anna_anna = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110587328955103587632/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ольга Теодорская', 'https://lh3.googleusercontent.com/a-/ALV-UjVsZ5hct2WaGAeq797sCfNZjImjJmrwa1MWjczDXAhc7Wut_Sk=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111345130449821985579/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111345130449821985579/reviews');
SET @user_olga_teodorskaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111345130449821985579/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anastasia Nikiforova', 'https://lh3.googleusercontent.com/a/ACg8ocKGj1ZQdDJMXgfmwq2pbdgLBtElj7XN9m1Vp7i-mG2YBCPNaQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110093275273107445530/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110093275273107445530/reviews');
SET @user_anastasia_nikiforova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110093275273107445530/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Daria Daria', 'https://lh3.googleusercontent.com/a-/ALV-UjUVPxtqBzGICgk3oI9r0slzhlFeQE6ELEH0aG3_1iwkUr0mdSKL=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115246268409875903349/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115246268409875903349/reviews');
SET @user_daria_daria = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115246268409875903349/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Egor Dudkin', 'https://lh3.googleusercontent.com/a-/ALV-UjVXCLYCxvGref7kueavx6sUpU1Ipr9A2QEU1AZki1GWHiq-pj8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110434576926006900271/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110434576926006900271/reviews');
SET @user_egor_dudkin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110434576926006900271/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nedzhe Nedzhe', 'https://lh3.googleusercontent.com/a/ACg8ocJADn72uCI1tzvfZA3seGXufpCxG7nHhgtqh0SMV5sfsOb2zw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113888264345169829141/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113888264345169829141/reviews');
SET @user_nedzhe_nedzhe = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113888264345169829141/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Миша Миша', 'https://lh3.googleusercontent.com/a/ACg8ocK-rgZ1Mzt21IyNTo0kFK0uhHekQ4DGux9_b1HNQMyvtQitwQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103114833324056757177/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103114833324056757177/reviews');
SET @user_misha_misha = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103114833324056757177/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anna Pivovarova', 'https://lh3.googleusercontent.com/a-/ALV-UjWh0zdJi1YActmLKs2TlJk26M-2bQstCfA-9752bG33DoTQSu38=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111815199761363124332/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111815199761363124332/reviews');
SET @user_anna_pivovarova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111815199761363124332/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lana Makarova', 'https://lh3.googleusercontent.com/a/ACg8ocIY2fr8r4x6twJHPfSYUcj8sdl8266SAPKeBpFaqzi4acThOQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116634829311332283450/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116634829311332283450/reviews');
SET @user_lana_makarova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116634829311332283450/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olga Baranova', 'https://lh3.googleusercontent.com/a/ACg8ocKqbPp4feXgYNHLPAX2ykjh-LReWPyAyqtDNUrqOPba6rM10Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103099006597596812184/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103099006597596812184/reviews');
SET @user_olga_baranova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103099006597596812184/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Анна Костерина', 'https://lh3.googleusercontent.com/a/ACg8ocIKeSba4UR5RqOcp2vgG11iiv4UAtoeus9RbWuezHhuHT4V=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117402294214103750193/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117402294214103750193/reviews');
SET @user_anna_kosterina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117402294214103750193/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Talya', 'https://lh3.googleusercontent.com/a/ACg8ocLKAxG8f79QKMISMWCLUGS_TWdP5ROoFCv1ksqpkGB-sQk1OA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110974312992444695785/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110974312992444695785/reviews');
SET @user_talya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110974312992444695785/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ирина М', 'https://lh3.googleusercontent.com/a-/ALV-UjVR73V_I_4e6AoMdT1BaJdqMcYZrH3bW-fZaFjSjh--rVsdSzE2=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106507851500762211609/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106507851500762211609/reviews');
SET @user_irina_m = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106507851500762211609/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olesya Semukhina', 'https://lh3.googleusercontent.com/a-/ALV-UjWFCz8ASZr35qR1sV2bkn_-0SADJm9AbQlaNYVccSNAHhQraRC1=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109815747141938375059/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109815747141938375059/reviews');
SET @user_olesya_semukhina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109815747141938375059/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ольга Наливкина', 'https://lh3.googleusercontent.com/a-/ALV-UjVhHpz0CAHiYbXhsyRpxtAWN1eJMysqmIOWffHG3vje-w_JlD0P=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116849594301399321587/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116849594301399321587/reviews');
SET @user_olga_nalivkina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116849594301399321587/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Helen Godlevska', 'https://lh3.googleusercontent.com/a/ACg8ocI6pkksZBnKBjmfh0DYoB3KedvqD7T1tf9pTDqDEFANrWgVew=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112958744253095950571/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112958744253095950571/reviews');
SET @user_helen_godlevska = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112958744253095950571/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'DIANE', 'https://lh3.googleusercontent.com/a-/ALV-UjW-0p6bgdKdn8ajz0hsn-bMeU7QMoEieg9olUMuhcCu8FLJeSk=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112296457704026947284/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112296457704026947284/reviews');
SET @user_diane = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112296457704026947284/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Oleksandra Neskovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXfE7J8Y92kpK53N-4PEXdYxfDX4IO-xDu4jgor6X_jFHMxcj4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109951022035416209590/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109951022035416209590/reviews');
SET @user_oleksandra_neskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109951022035416209590/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ирина Долженко', 'https://lh3.googleusercontent.com/a-/ALV-UjV5Lyca1h0eYvJ2nUhbicaOos5okO3qi5gtYWL8r7J95u5tG3P0=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110187640621288225700/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110187640621288225700/reviews');
SET @user_irina_dolzhenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110187640621288225700/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Елизавета Ефтифеева', 'https://lh3.googleusercontent.com/a/ACg8ocIVTZjCUCiLkLlkFC4BByZJbwBFA4CVBB-HCvee-ueDUFsGW1E=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109760965513964798822/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109760965513964798822/reviews');
SET @user_elizaveta_eftifeeva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109760965513964798822/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tim Drizhuk', 'https://lh3.googleusercontent.com/a/ACg8ocIv7AWhSUGtAOaSOYNt0AbIVZA1wWSPYEQMXvDMOTPjBBxUQg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109083231173971566938/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109083231173971566938/reviews');
SET @user_tim_drizhuk = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109083231173971566938/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Liza', 'https://lh3.googleusercontent.com/a/ACg8ocL9Rd2SABsJ5lHIIm8XTiKU_aI90lwfhF2Ejn7F-S8R7Ah6sw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103151995668637562568/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103151995668637562568/reviews');
SET @user_liza = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103151995668637562568/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nadya Kuleshova', 'https://lh3.googleusercontent.com/a/ACg8ocKlCgdBc06CggYOJqzlV_1F-F8UjVeK8QVDkvW7I_2jiA-d=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109634557996557979244/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109634557996557979244/reviews');
SET @user_nadya_kuleshova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109634557996557979244/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Румия Ораева', 'https://lh3.googleusercontent.com/a/ACg8ocJx4vr7Kj2w_wOnTI1Z63ptn1SLSAw0qi-Q3hUnfn1SJMs4wQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110974660222043334083/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110974660222043334083/reviews');
SET @user_rumiya_oraeva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110974660222043334083/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Victory Lettering', 'https://lh3.googleusercontent.com/a/ACg8ocLV2cDsnpVLqVXxngoBiv1L1PoTHuUd7laXiHMTk88egFeFOw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101035457332662949308/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101035457332662949308/reviews');
SET @user_victory_lettering = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101035457332662949308/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ольга Шабардина', 'https://lh3.googleusercontent.com/a/ACg8ocLyLXWd70Y4HAzJA6LqJRCRB2bljoxKvEXUDgSJztuNADjTuw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116951597294742416909/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116951597294742416909/reviews');
SET @user_olga_shabardina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116951597294742416909/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Yana Duka', 'https://lh3.googleusercontent.com/a/ACg8ocITEm0ocX-BPJh-FBMo48Nw8KwW88jxN4-qhAmqQ7eM0fmaWg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116241990572683764866/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116241990572683764866/reviews');
SET @user_yana_duka = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116241990572683764866/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anna Belogurova', 'https://lh3.googleusercontent.com/a-/ALV-UjXB1nlBCGziKG6ZWHMjynojfmZ2DVvTRor1rlFFMrWR_v2AdS_vGA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100116226719732210030/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100116226719732210030/reviews');
SET @user_anna_belogurova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100116226719732210030/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danica Zenovic', 'https://lh3.googleusercontent.com/a/ACg8ocLQVNoBoFZlq4O-RocK8mKef1N-tp7ZBRz5R2tfTB575sfqjg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114086042189552619244/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114086042189552619244/reviews');
SET @user_danica_zenovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114086042189552619244/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Григорий', 'https://lh3.googleusercontent.com/a/ACg8ocJNzoqjmobe9A0qOLRNap8c8_nA0QWvoMjzn0a-iccz1sED=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112474932232461098033/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112474932232461098033/reviews');
SET @user_grigoriy = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112474932232461098033/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'An Buf', 'https://lh3.googleusercontent.com/a/ACg8ocKfy08QyI0CHKl7TslREOsKZ-VeRfRAftV4BaOwScxROQVKHw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110275484463421098512/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110275484463421098512/reviews');
SET @user_an_buf = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110275484463421098512/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Матвей Тупарев', 'https://lh3.googleusercontent.com/a/ACg8ocLDpFMtkyfE1ZlhHsIMBjCtN6UamwTnuZ3praky23dyCi-7Xw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111088732509379818425/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111088732509379818425/reviews');
SET @user_matvey_tuparev = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111088732509379818425/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anna Pokusaeva', 'https://lh3.googleusercontent.com/a/ACg8ocLl7qkWKAjPZIvlmdCEtQ_Z3annFOeuAWSgcSP8qzfHYBAv-g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107698617330505618705/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107698617330505618705/reviews');
SET @user_anna_pokusaeva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107698617330505618705/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Артур Артуров', 'https://lh3.googleusercontent.com/a/ACg8ocLArSevCepPKDI04CN4V62wFxbBMmI1Jkuiv32ARABMuvA92A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102870028452797054654/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102870028452797054654/reviews');
SET @user_artur_arturov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102870028452797054654/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Медина Исаева', 'https://lh3.googleusercontent.com/a/ACg8ocJmtcIuV3Az7qls5ua9Z513GZSWltd7NPS8uq6r0Rv8ekKN0A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112191237906501984448/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112191237906501984448/reviews');
SET @user_medina_isaeva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112191237906501984448/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Yuliya', 'https://lh3.googleusercontent.com/a/ACg8ocJ0-V6vaKMvzcvROsZSWs9X25azjnB-FhU25xpLNF6tcvycNg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109540249509398281390/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109540249509398281390/reviews');
SET @user_yuliya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109540249509398281390/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Вика Банцикина', 'https://lh3.googleusercontent.com/a/ACg8ocKt09XTbOAwW75T5acWvk7PBG1jvn4S8vbfF8iyZo_qt1JCHg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101140997856354110269/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101140997856354110269/reviews');
SET @user_vika_bantsikina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101140997856354110269/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natalia Tupareva', 'https://lh3.googleusercontent.com/a/ACg8ocJWRUam0MoGHNuCy1BrWgxMXTPGwnuDyAlIrjAc94gZzD0Lag=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115260939780088039087/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115260939780088039087/reviews');
SET @user_natalia_tupareva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115260939780088039087/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ольга Степанова', 'https://lh3.googleusercontent.com/a-/ALV-UjWnHX0fqWnp5lT4EEQ4WEuEFyxVS57oFMWs9b4MN4mWDsjJVCAb=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111340991831160641057/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111340991831160641057/reviews');
SET @user_olga_stepanova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111340991831160641057/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lera Sklyarova', 'https://lh3.googleusercontent.com/a/ACg8ocL0ACwe8KzX26dX2pNjmgdm7VYp_pmiV1ASNMDex-71qD-mGQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113726874203279154924/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113726874203279154924/reviews');
SET @user_lera_sklyarova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113726874203279154924/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Алина Джус', 'https://lh3.googleusercontent.com/a/ACg8ocJ7nuiGu4BpGFrwP_U_WygeteAwywUBbJzHk9FOmZfM4fsvLw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101660892756716662803/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101660892756716662803/reviews');
SET @user_alina_dzhus = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101660892756716662803/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Евгения Табачникова', 'https://lh3.googleusercontent.com/a/ACg8ocJPSl-xXUfeuLHCRVRXAzUmyoFJvZXJU274dTsmhOWnwmpy1w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118352694283552346266/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118352694283552346266/reviews');
SET @user_evgeniya_tabachnikova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118352694283552346266/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maryia Kalpinskaya', 'https://lh3.googleusercontent.com/a-/ALV-UjUGpqoN44RJP4OsSbw5EgS675nLaKMIQ0sJT-l9IA2gnYavoG6G=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108634701754506364561/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108634701754506364561/reviews');
SET @user_maryia_kalpinskaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108634701754506364561/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alexander Leonov', 'https://lh3.googleusercontent.com/a-/ALV-UjVN9SMKcD2VSZhbfRe3G8JwXFQQmBwXTecgIu79RdHnsMLAahq4tA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110139793894429109067/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110139793894429109067/reviews');
SET @user_alexander_leonov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110139793894429109067/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Nikolic', 'https://lh3.googleusercontent.com/a-/ALV-UjV2ipev7UVp7BWmBTOZawPSAeS1V38qH5E5xSKbwDEzM-TpoxqKug=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103092259015624882672/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103092259015624882672/reviews');
SET @user_ana_nikolic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103092259015624882672/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nur News', 'https://lh3.googleusercontent.com/a/ACg8ocIODsed1mJ85g1erZdbrUuYda9tZRTdv2PySRnUrGlCaEOAEw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104653420570861475072/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104653420570861475072/reviews');
SET @user_nur_news = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104653420570861475072/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, '31spacey', 'https://lh3.googleusercontent.com/a-/ALV-UjUgrREv4gSQt5sikbkKDpgf7DUvu_ZPc92dESE1kdzs7N18-174=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107915822460851470051/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107915822460851470051/reviews');
SET @user_31spacey = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107915822460851470051/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lissa W', 'https://lh3.googleusercontent.com/a/ACg8ocK1j8eDPtIHAbdwQtZY1V0mO7P3MwTRZfm1Ann9mZUN2qWWRPx7=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110952997836982683269/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110952997836982683269/reviews');
SET @user_lissa_w = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110952997836982683269/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ольга', 'https://lh3.googleusercontent.com/a-/ALV-UjURBO7xzsEjsqgGhed-RO66OJuEKY2zDCyPDr1YoeEVS6sD4rs=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104608844796444958625/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104608844796444958625/reviews');
SET @user_olga = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104608844796444958625/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'TOP5 Agency Spain', 'https://lh3.googleusercontent.com/a-/ALV-UjWP3y8r_Dxp2HWxTvBwsdR8Z-ZLDlgMiJxoZBXAwERK0GTj4zhl=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113293689459092421048/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113293689459092421048/reviews');
SET @user_top5_agency_spain = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113293689459092421048/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maria Purtova', 'https://lh3.googleusercontent.com/a-/ALV-UjUGA7a9erF57QhI_wGoDY80QgXrecQ5fHmQKT1ixhDGCp70DA8=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109053591487453002737/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109053591487453002737/reviews');
SET @user_maria_purtova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109053591487453002737/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aunt Cat', 'https://lh3.googleusercontent.com/a-/ALV-UjW21MnSGL5bHSxmU1FkwmgGHaj_hjFQ7pJe745kapphFI17i3Hv=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113916481580753217711/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113916481580753217711/reviews');
SET @user_aunt_cat = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113916481580753217711/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alex Baguzin', 'https://lh3.googleusercontent.com/a-/ALV-UjX7XwG2bZYVGMxHN8Bo-GoH2pcpRlC6FhuA_4Gl53pqlNEMklBVQw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102932013358466647009/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102932013358466647009/reviews');
SET @user_alex_baguzin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102932013358466647009/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Алексей Найденов', 'https://lh3.googleusercontent.com/a-/ALV-UjUveX9pZZbmr5_MHXtwryf4yzyx_QlvYkUVNdOxROyR5f9QRkzT=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117910564616619288213/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117910564616619288213/reviews');
SET @user_aleksey_naydenov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117910564616619288213/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Юлия Черногор', 'https://lh3.googleusercontent.com/a-/ALV-UjVBsTetgtbBAJaP20lw0Rj13RuISi8oCB4zOoGeWxc_1k8Z0LyGiA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115868803521557773675/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115868803521557773675/reviews');
SET @user_yuliya_chernogor = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115868803521557773675/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Yunona Zhupii', 'https://lh3.googleusercontent.com/a/ACg8ocJXEdact7H5iFn5VuPrRcw9mdaIK-NnFDzr3VsscCkGevzN0w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106733721413623009472/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106733721413623009472/reviews');
SET @user_yunona_zhupii = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106733721413623009472/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Евгения Дабижа', 'https://lh3.googleusercontent.com/a/ACg8ocIk1KtsVFdzaCH3gVgC2uJn9GV4k0uSmOVfigsUyDRLeA7DjA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114833920300266729074/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114833920300266729074/reviews');
SET @user_evgeniya_dabizha = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114833920300266729074/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra S', 'https://lh3.googleusercontent.com/a/ACg8ocJNpGFBZ5nJrs5m7r9ylMzdsI3j2VewCwHOqbGTXiy8aDea3w=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106477100688608360167/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106477100688608360167/reviews');
SET @user_aleksandra_s = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106477100688608360167/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danica Obradovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWkkowlEz22kCmYUGfMO3WWcixOSUtKjdK8FcQPNqXBeHFZEX7O=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105887472606761438285/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105887472606761438285/reviews');
SET @user_danica_obradovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105887472606761438285/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Кристина Толпина', 'https://lh3.googleusercontent.com/a/ACg8ocLYrJ0M-cET4i8YW6dZDduGTTG7eJoWxVHsEKkrh8E21-1XNQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117121301687971044803/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117121301687971044803/reviews');
SET @user_kristina_tolpina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117121301687971044803/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Екатерина Драпун', 'https://lh3.googleusercontent.com/a/ACg8ocLn6H48ZEV5sKXkcVTeU00O_c3FARYpCHkFioKO_eGNHhpm3w=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111168019039212866018/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111168019039212866018/reviews');
SET @user_ekaterina_drapun = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111168019039212866018/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Билли Бонса', 'https://lh3.googleusercontent.com/a/ACg8ocLdPDPkTmLSIDj6xmnOgxDS1IHHMCLPWaMtVkjv9BjirsWVuQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113315287319483348130/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113315287319483348130/reviews');
SET @user_billi_bonsa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113315287319483348130/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Татьяна Подлесняк', 'https://lh3.googleusercontent.com/a-/ALV-UjUZSHlBv74UcxjzPlXU3acLB9-6Idj3DypYNOtL1X8VF08iAuSX=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101453062084382614866/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101453062084382614866/reviews');
SET @user_tatyana_podlesnyak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101453062084382614866/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Олександра Харковенко', 'https://lh3.googleusercontent.com/a/ACg8ocLemcCevBliwzz5z8RWXl5EFEhXl1L-xpiezdBubD1zkpvLQw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102304348887805499917/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102304348887805499917/reviews');
SET @user_oleksandra_kharkovenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102304348887805499917/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Маргарита Кандлина', 'https://lh3.googleusercontent.com/a-/ALV-UjX0bQgluIZrFUAc5urfCY4E1KAzIOB8_8O2-K8DwJhwHlvsYiIP=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108410052588207432472/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108410052588207432472/reviews');
SET @user_margarita_kandlina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108410052588207432472/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anna Is', 'https://lh3.googleusercontent.com/a/ACg8ocJfGVjDvtLUvEyAL1FhVn5qvEHTaIFU-hCjD4VsPbVs6HyPPQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117138279514101161395/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117138279514101161395/reviews');
SET @user_anna_is = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117138279514101161395/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Иван Иванов', 'https://lh3.googleusercontent.com/a-/ALV-UjVFZnWGJZlLPZQSHIzN8MORDPGtMW6gBWTq7rbQ7vxh46X3VTyC=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111708308154451009913/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111708308154451009913/reviews');
SET @user_ivan_ivanov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111708308154451009913/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anaïs', 'https://lh3.googleusercontent.com/a/ACg8ocKDp9D6gMaVuuthqAfCqGFhe3rNRhYk19uCw5CVffZSnedPUQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109485433633821962257/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109485433633821962257/reviews');
SET @user_anas = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109485433633821962257/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Yuliia Rakovska', 'https://lh3.googleusercontent.com/a/ACg8ocJTQp-FSI50UOE_RqpQhr29K-Kc0ZErTJ_nMlWaTXAcBp1_SA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103116969433740368827/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103116969433740368827/reviews');
SET @user_yuliia_rakovska = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103116969433740368827/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Polina V', 'https://lh3.googleusercontent.com/a-/ALV-UjUTIgphk6pi1tsqiApRTXZ8VH9A-rTx-TJUnu1gNd9WxohxwOQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116888086287978729676/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116888086287978729676/reviews');
SET @user_polina_v = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116888086287978729676/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ruslan', 'https://lh3.googleusercontent.com/a/ACg8ocLadqyBn_eEjkD2RBoaeBj3IjwlQ5pyNiE7K_NO4u3Xx7jJyg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113282552875776238109/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113282552875776238109/reviews');
SET @user_ruslan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113282552875776238109/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Людмила Бойцова', 'https://lh3.googleusercontent.com/a/ACg8ocLHnsTqTOhPpHsonCoXxkcLn0-Ete3FqAItix34BY_tnJIWfw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101682356311924473095/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101682356311924473095/reviews');
SET @user_lyudmila_boytsova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101682356311924473095/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ekaterina Naryshkina', 'https://lh3.googleusercontent.com/a-/ALV-UjXMkoARF0GZSKR4oQSao6IQnn7W5vsladsB8CseF4qhrvOShzCc=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101682586616771315541/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101682586616771315541/reviews');
SET @user_ekaterina_naryshkina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101682586616771315541/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Имя Фамилия', 'https://lh3.googleusercontent.com/a/ACg8ocJedw7RDchsa-_kA81s-yYeAM1sQRw3ah03e8ZrfvgiB-WF7Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117779819685342636015/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117779819685342636015/reviews');
SET @user_imya_familiya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117779819685342636015/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Claudia Kinomoto', 'https://lh3.googleusercontent.com/a-/ALV-UjUDeiZjR5mLCLBOUsID-rs7DiE2lT-YY5eM3xjBBhS33dy5i_SYAA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116314117889621755660/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116314117889621755660/reviews');
SET @user_claudia_kinomoto = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116314117889621755660/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Екатерина Шабанова', 'https://lh3.googleusercontent.com/a-/ALV-UjXmEYul4Gl-YTvwftNXK8tQ68IFxkDy__PW7-VbsRK29M_GwCs=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117143547962167196358/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117143547962167196358/reviews');
SET @user_ekaterina_shabanova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117143547962167196358/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Елена Николич', 'https://lh3.googleusercontent.com/a/ACg8ocKTKUWgh6Fy-6cVogCBLXLLOYhKF9AOECued-oWPVVuPSH8sw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112746582556735532641/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112746582556735532641/reviews');
SET @user_elena_nikolich = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112746582556735532641/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Наталия В', 'https://lh3.googleusercontent.com/a-/ALV-UjUsnq0iLqPcFmn9ymMhLEOU9jgHO4aYW6lGCmrNK1rtN7pYWwA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101217450857443936606/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101217450857443936606/reviews');
SET @user_nataliya_v = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101217450857443936606/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anastasiia Kovalchuk', 'https://lh3.googleusercontent.com/a-/ALV-UjXiUzmTA3ZpD93j_t9FlBP-8ePJ9h_PQ0kvRe2By9U31kTYib1PRg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104277024058403379607/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104277024058403379607/reviews');
SET @user_anastasiia_kovalchuk = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104277024058403379607/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Марина Халаби', 'https://lh3.googleusercontent.com/a-/ALV-UjXmm8NcyuXElNfj_LF8yJVF8YTfSgWL0jrtxO68rl7TPD7UsXk=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111650651629680368769/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111650651629680368769/reviews');
SET @user_marina_khalabi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111650651629680368769/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ирина Битиева', 'https://lh3.googleusercontent.com/a/ACg8ocL95sovfeCx3N9Dcsvx1iQpb0-JSeTKggIxjMobnllRyqNPUg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117447549969923976815/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117447549969923976815/reviews');
SET @user_irina_bitieva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117447549969923976815/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Яна Соловцова', 'https://lh3.googleusercontent.com/a-/ALV-UjXuS-G9DWr3LieBoz0RiBBlnZUL8NUR7SkU94w6i255NHjuUw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116602101061877703749/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116602101061877703749/reviews');
SET @user_yana_solovtsova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116602101061877703749/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ekaterina Izmaylova', 'https://lh3.googleusercontent.com/a/ACg8ocL75HGoPIPOE46odYqFGLHwroyPhcVLqm7z6APDTR0k05x9Lw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115739662022698934582/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115739662022698934582/reviews');
SET @user_ekaterina_izmaylova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115739662022698934582/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Eva S', 'https://lh3.googleusercontent.com/a-/ALV-UjU8KhyfpH-AsMU07Lflv0KndwsxRxmZ385xi4W24JhFhkqgzODN=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103181115865724305767/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103181115865724305767/reviews');
SET @user_eva_s = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103181115865724305767/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Yulia Kovaleva', 'https://lh3.googleusercontent.com/a-/ALV-UjXUTM-0uYe31tmt9m3-LgYdB3QSKAHFwlui9dv3ygtFiwCd1QeA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102435483135018883398/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102435483135018883398/reviews');
SET @user_yulia_kovaleva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102435483135018883398/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nadya Yuryeva', 'https://lh3.googleusercontent.com/a-/ALV-UjWy6Se4LAZrVn2uJVlSJE4bAofn11lJLwGKAzAKP1pNm2b1EpxD=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112423304691540232599/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112423304691540232599/reviews');
SET @user_nadya_yuryeva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112423304691540232599/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milena', 'https://lh3.googleusercontent.com/a-/ALV-UjXcMJW__Ip6Uljhrn4AsBQR-XG6p5LDSbf6roQ8YeZ3ekelYWWP=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115291183784950244119/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115291183784950244119/reviews');
SET @user_milena = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115291183784950244119/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Софья Раца', 'https://lh3.googleusercontent.com/a-/ALV-UjXH4BOxLZlC4y-DD0DHC_Xoe13wOBzhNbhokTSQdMbfizQGy3N_=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114363803529578066028/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114363803529578066028/reviews');
SET @user_sofya_ratsa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114363803529578066028/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'aleksey mikhailov', 'https://lh3.googleusercontent.com/a/ACg8ocLW2uv67DOlWDlaVoNPoIoB8o3qlSLolDCpkE7-lXq15svZjA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103876619100703854465/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103876619100703854465/reviews');
SET @user_aleksey_mikhailov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103876619100703854465/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Алёна Ремер', 'https://lh3.googleusercontent.com/a-/ALV-UjUEy6qecCEUfzcx4d43CHRasYHMvhiUeurCQ8X_ooXRrvIFhv8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100622780028747364049/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100622780028747364049/reviews');
SET @user_alyona_remer = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100622780028747364049/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Daria', 'https://lh3.googleusercontent.com/a/ACg8ocLXfvxoGBwR2faILBHUYC1EGcfJr2D9Z4a3RLDWn8NiWwX7iw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106936856601272218645/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106936856601272218645/reviews');
SET @user_daria_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106936856601272218645/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Inna Konchits', 'https://lh3.googleusercontent.com/a-/ALV-UjXjNE4J-0Av5ZkfDHS5BG6kJwowAkIcTUhTn34jtWLIVQyzv9A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107938950332047013750/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107938950332047013750/reviews');
SET @user_inna_konchits = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107938950332047013750/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Svetlana Petric', 'https://lh3.googleusercontent.com/a/ACg8ocKZnrawY3IIhl-pIcpwTeLZz7Du7nRAFcwkQzUt1XYS3tFsbg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100731270792321505566/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100731270792321505566/reviews');
SET @user_svetlana_petric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100731270792321505566/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radmila R.', 'https://lh3.googleusercontent.com/a/ACg8ocJdwRIO8PVFbnJexNt82AdlGGn1ch7uhtsU9S_403H10G7aO3Wf=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109241702374634333589/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109241702374634333589/reviews');
SET @user_radmila_r = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109241702374634333589/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sergii Orlov', 'https://lh3.googleusercontent.com/a/ACg8ocI0fTXlqXHibB5G85zz0AUGtEb_C5AVKr_VgNedhjLtoftiVQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114398614719880865356/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114398614719880865356/reviews');
SET @user_sergii_orlov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114398614719880865356/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Lekic', 'https://lh3.googleusercontent.com/a/ACg8ocJKshBRf1Oe8cIJMzell1frMakizi5UeM7p7sD5TpYr_WOtzQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116884983132741598663/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116884983132741598663/reviews');
SET @user_marija_lekic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116884983132741598663/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anton T', 'https://lh3.googleusercontent.com/a/ACg8ocJfrwClaaSmw0eVeLN_Ew0qkufHZyy_zg0XffV_L9ypdPf5cA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102866888802185915308/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102866888802185915308/reviews');
SET @user_anton_t = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102866888802185915308/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ulyana Kharitonchik', 'https://lh3.googleusercontent.com/a-/ALV-UjU_myzpfcolvRw6hjbndidmbIkalKz3I9RXxl8z54cutkB6TiYYeA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112105020866593332985/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112105020866593332985/reviews');
SET @user_ulyana_kharitonchik = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112105020866593332985/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anna Moiseeva', 'https://lh3.googleusercontent.com/a-/ALV-UjWQr0L78kK73VDnWcRvTJBotthGvN9DLZIhaooKITSjlbQJ1FA-=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113994263620040757687/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113994263620040757687/reviews');
SET @user_anna_moiseeva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113994263620040757687/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Mišević', 'https://lh3.googleusercontent.com/a/ACg8ocLsDR-yD7t-esJ_fXYCXMxTivet8MgtBfuW2FxXK2VpimE7WQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106279560091748176245/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106279560091748176245/reviews');
SET @user_ana_mievi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106279560091748176245/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marianna Marianna', 'https://lh3.googleusercontent.com/a-/ALV-UjVw9dFVgxUyly_iCDpJr6kJeIwElVJtlRmHB5aLTL9cphfJeOXv=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115557853206474635859/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115557853206474635859/reviews');
SET @user_marianna_marianna = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115557853206474635859/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Yana Sergeeva', 'https://lh3.googleusercontent.com/a/ACg8ocKmQTNmdtlvEqg2947WK29z196Xeh05B3XLU8xsbi6mio8O9Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105889215460688032914/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105889215460688032914/reviews');
SET @user_yana_sergeeva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105889215460688032914/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Светлана Хрусталёва', 'https://lh3.googleusercontent.com/a-/ALV-UjXM4vtUGswkw7os-totzG7As8hQ7gT1DdLkVdm-b9g_lh04mw0=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102033321601074929646/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102033321601074929646/reviews');
SET @user_svetlana_khrustalyova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102033321601074929646/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lina Temimi', 'https://lh3.googleusercontent.com/a-/ALV-UjUhHTUA7bxJJ0TMyDrj0_Ih_hCWWJp_CrnW0Bh8F5bkPSUIxD0q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112526498587276139705/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112526498587276139705/reviews');
SET @user_lina_temimi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112526498587276139705/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Relja Petric', 'https://lh3.googleusercontent.com/a/ACg8ocJsDrt0sNzf-L_fXL1Tn-_PFz-dL7h08lg6eV4b65h06wcLsg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106371623708490195050/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106371623708490195050/reviews');
SET @user_relja_petric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106371623708490195050/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Сергей Большаков', 'https://lh3.googleusercontent.com/a-/ALV-UjWp7J7RotfztLpGn7MgJva1MWbwvIrmQQs7s1nMjqAZb9ilvupY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110446539720691090567/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110446539720691090567/reviews');
SET @user_sergey_bolshakov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110446539720691090567/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alena Mosina', 'https://lh3.googleusercontent.com/a/ACg8ocLqwL2DY_3Td7uGSwQgAZxR6v8d-zeJLUr7yAWsQ6qUIFjISQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103292849100943627018/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103292849100943627018/reviews');
SET @user_alena_mosina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103292849100943627018/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Екатерина Трипутень', 'https://lh3.googleusercontent.com/a/ACg8ocJKii2Zw-H4WUNDj4Y3a-MNzhWljVCZak7Frt4xca7mxcEbDQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112421928405625471814/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112421928405625471814/reviews');
SET @user_ekaterina_triputen = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112421928405625471814/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Виктория Явецкая', 'https://lh3.googleusercontent.com/a-/ALV-UjWWu23mChk-7ByUk52TlwOy3-j0K79JuwDe0W4MKOAEV1dsHUWu=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109368307600615088846/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109368307600615088846/reviews');
SET @user_viktoriya_yavetskaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109368307600615088846/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Андрей Слепухин', 'https://lh3.googleusercontent.com/a-/ALV-UjXYv9o3Lul082jubNkw_Mre49p4AR5AeoU9jWoRBARm4iJ5yoYN=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100079391032856683416/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100079391032856683416/reviews');
SET @user_andrey_slepukhin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100079391032856683416/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Irina Gracheva', 'https://lh3.googleusercontent.com/a-/ALV-UjUC-bzb9XvdFqhylsFNab6bJXOz49Q0YtNmE3PagUSlX59W6vnbug=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/118440362099282478969/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118440362099282478969/reviews');
SET @user_irina_gracheva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118440362099282478969/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Irinka ITcorp', 'https://lh3.googleusercontent.com/a/ACg8ocLVYcX_md0QHMoOXmFS3_BFOtWuH0K4bKy-Hb40F9EXqsJ9Yg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/118321419682501533754/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118321419682501533754/reviews');
SET @user_irinka_itcorp = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118321419682501533754/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Krystina Borisenko', 'https://lh3.googleusercontent.com/a/ACg8ocK-a-Ihf5cMp7hK3_pg8xoykhYxkBqYZX8YyFPj5q26XevmEg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109964752168013940779/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109964752168013940779/reviews');
SET @user_krystina_borisenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109964752168013940779/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Галина Деньгина', 'https://lh3.googleusercontent.com/a/ACg8ocLlUr1texrmkrcQUXmUAHAvlqoKffvgYdu0nuVXPe-YLTJchQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111176319214429083555/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111176319214429083555/reviews');
SET @user_galina_dengina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111176319214429083555/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'G Khristoforova', 'https://lh3.googleusercontent.com/a-/ALV-UjVUQCC4fL6iLTwDAh1wpVf9iBEzJZVapauYG5-5tUGhifyh-Zk=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110627252979439375823/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110627252979439375823/reviews');
SET @user_g_khristoforova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110627252979439375823/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Гавронина Евгения', 'https://lh3.googleusercontent.com/a-/ALV-UjWekPIB48iDXFMLsOyxP8UGnR7Sk8Rp_RuHtW1Gbr2-Hs69MYWTTA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115558265606237269504/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115558265606237269504/reviews');
SET @user_gavronina_evgeniya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115558265606237269504/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lisa Voronkina', 'https://lh3.googleusercontent.com/a-/ALV-UjUW8fPwjWKsJQxoRGJHcl79QkMOg22FRnY4wiJauBYJ6Mz22X5LLA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114068556795803602488/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114068556795803602488/reviews');
SET @user_lisa_voronkina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114068556795803602488/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Анна Воротникова', 'https://lh3.googleusercontent.com/a-/ALV-UjVRApE0Q-DkYjl2QLQ4Yome7ufMyOsh7UPKHXzbTzZ55YuLWfX-Ww=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113943203826667878331/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113943203826667878331/reviews');
SET @user_anna_vorotnikova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113943203826667878331/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandr Akulshin', 'https://lh3.googleusercontent.com/a-/ALV-UjVKru-oPH9RmU-eWoUkVI_HPTWNobBpY7Bnj9w7JnnxEl4qrPDu=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100566542661867963469/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100566542661867963469/reviews');
SET @user_aleksandr_akulshin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100566542661867963469/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'marko', 'https://lh3.googleusercontent.com/a/ACg8ocKymzlvAs-cSMIlYVH5iC_pWUY_ggNDCArZ9dVwZ99NlZcaRA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113737498929971851883/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113737498929971851883/reviews');
SET @user_marko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113737498929971851883/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anastasia', 'https://lh3.googleusercontent.com/a-/ALV-UjVwSP-DoUBnVv0P9ka-M6wQkzOccgWfsdqPIJWZgNcuIPJhdBUBsw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101016836188376822705/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101016836188376822705/reviews');
SET @user_anastasia = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101016836188376822705/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Svetlana Rutskaya', 'https://lh3.googleusercontent.com/a-/ALV-UjUuU1DLhomanVygMSz5XQOjQTqBjkxYVC9IbYA2dJlCB3lG0_lp=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103590080348121534491/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103590080348121534491/reviews');
SET @user_svetlana_rutskaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103590080348121534491/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Irina Lyubina', 'https://lh3.googleusercontent.com/a-/ALV-UjWXdvWipQw76lwcrYWUTeLOiR1esTIamvTrZLw2iVuGR5mfFLVt=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117885095828287413148/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117885095828287413148/reviews');
SET @user_irina_lyubina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117885095828287413148/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Angelina Evdokimova', 'https://lh3.googleusercontent.com/a/ACg8ocJuh455QqhvB5V6QMh8vkki0sJPxN6J9oZnUY8YwUQckYeuuQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104467256063074997623/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104467256063074997623/reviews');
SET @user_angelina_evdokimova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104467256063074997623/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Валентина Заречнева', 'https://lh3.googleusercontent.com/a/ACg8ocJ0COcUoMHh_0dX3qt0bULGdWnNPg8uZQpsYsPO-5E4bPjiDQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109399661192312562965/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109399661192312562965/reviews');
SET @user_valentina_zarechneva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109399661192312562965/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anna Viktorova', 'https://lh3.googleusercontent.com/a-/ALV-UjW3hnCAQXnoa1VECU8KkMD8PluT0aJc_MVcEVCdEjAYTit3yik=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111242262633088539698/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111242262633088539698/reviews');
SET @user_anna_viktorova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111242262633088539698/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nermin Mujovi', 'https://lh3.googleusercontent.com/a/ACg8ocIv4U6ukKql5HpJg2JCifw77qQ8o0_1K_5k5d9LqKZ5A4ch_w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113601090965382140674/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113601090965382140674/reviews');
SET @user_nermin_mujovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113601090965382140674/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anna Tsvetkova', 'https://lh3.googleusercontent.com/a-/ALV-UjUB4MVep9wPY5K8oUYzzgn9dOnAGDeXeFD42HUFAoPSuv4taLJu=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115935800373877167697/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115935800373877167697/reviews');
SET @user_anna_tsvetkova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115935800373877167697/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ольга', 'https://lh3.googleusercontent.com/a/ACg8ocI6jFsUDOnCn1w-rIes0o1JjRJnNytvj0gkxMzhMy1QucmX8A=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111050187865393926971/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111050187865393926971/reviews');
SET @user_olga_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111050187865393926971/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Katerina Velikaya', 'https://lh3.googleusercontent.com/a/ACg8ocINB3vBNj3cDZWlpoFa0UKBKl-jA612lCm0G9RDrD2QQwkvrQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111054140258586526144/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111054140258586526144/reviews');
SET @user_katerina_velikaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111054140258586526144/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Анастасия Скуратова', 'https://lh3.googleusercontent.com/a-/ALV-UjXUudWt3xdECS1u_F12bkR_13ig9-eA0I6TjTUx2xsLokmMqsvu=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104587334988311746201/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104587334988311746201/reviews');
SET @user_anastasiya_skuratova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104587334988311746201/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Fulya Melisa', 'https://lh3.googleusercontent.com/a-/ALV-UjWWaEkG_NeCqsMZpi9HiKi1XyLesBiE9V-qAbX7bVQb39TFWys=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114957043723941993406/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114957043723941993406/reviews');
SET @user_fulya_melisa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114957043723941993406/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Semyon Tatarinov', 'https://lh3.googleusercontent.com/a-/ALV-UjV-A8Gmr_LhbnxleKgKNedgTVsMj5ODDqMiw1nO6XYkNDQB8KQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101119397406430363484/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101119397406430363484/reviews');
SET @user_semyon_tatarinov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101119397406430363484/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Cosmonauts Day', 'https://lh3.googleusercontent.com/a-/ALV-UjU6n-P-keeIpxXiUJrEr_QMi4N989ql84Q7bcHzLsosz9PMnXXB=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111460685931515261535/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111460685931515261535/reviews');
SET @user_cosmonauts_day = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111460685931515261535/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Елена Л.', 'https://lh3.googleusercontent.com/a-/ALV-UjX65th3Vx-926zZEz5TacI0osELyqNh4JSSfK9hj-TREwIrX7VO=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103288758375905810792/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103288758375905810792/reviews');
SET @user_elena_l = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103288758375905810792/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, '774johan', 'https://lh3.googleusercontent.com/a-/ALV-UjUEdxgn-AmEfmVr6j3x9pr2agOlqq2ZTzsxv15R8vXwmsEwf5Kz=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109286407023928013831/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109286407023928013831/reviews');
SET @user_774johan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109286407023928013831/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marijola Dimitrijevic', 'https://lh3.googleusercontent.com/a-/ALV-UjVeICc_J80ssLhp93TMPErg68BWlZkf6TtA3tfWv8KLt6r8uII=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116044734979508311154/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116044734979508311154/reviews');
SET @user_marijola_dimitrijevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116044734979508311154/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Julia Fridman', 'https://lh3.googleusercontent.com/a-/ALV-UjX5AwymVs5QgtwQvkTrUVBRM_gDDWRS_q9EmDAGHzVJn1GD-smM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115809319225246233474/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115809319225246233474/reviews');
SET @user_julia_fridman = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115809319225246233474/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Šunjerga', 'https://lh3.googleusercontent.com/a/ACg8ocIGZPQnXmk5oM3-RaAhhzYlQzuOdo8CR2ZA7gkPFKlYzgjpkQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112820783052355880058/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112820783052355880058/reviews');
SET @user_ivan_unjerga = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112820783052355880058/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'lana ljubanovic', 'https://lh3.googleusercontent.com/a/ACg8ocIAyud7n3BA0iHLox8mzbzn6buggH9-ajEmL1XJDmiEpPRWuA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103547087982459802643/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103547087982459802643/reviews');
SET @user_lana_ljubanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103547087982459802643/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elena Rozenbaum', 'https://lh3.googleusercontent.com/a/ACg8ocLHWSK16rnGToQCOgG9eGiFM2kiy01PHcF-bm4FMylRpQFq0A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106984197467380548065/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106984197467380548065/reviews');
SET @user_elena_rozenbaum = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106984197467380548065/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Неля Косенко', 'https://lh3.googleusercontent.com/a-/ALV-UjXij87Fai8DC3_vFxSfP_NSrrScv13LjbkRQCU_bF-0UTs5qoMJ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102916030216071991759/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102916030216071991759/reviews');
SET @user_nelya_kosenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102916030216071991759/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Екатерина Резниченко', 'https://lh3.googleusercontent.com/a-/ALV-UjVdLO0Y7KJeDO2eXKNwNuPSD-Km4V168gq6VaByzmETh9-TlnA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102894274694350671201/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102894274694350671201/reviews');
SET @user_ekaterina_reznichenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102894274694350671201/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksa Ljubanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjX8-s1fEg2EKbU2-CF2j46scX0eKqrDhkWciQahgLXA-aYzugXs=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108001643275110575187/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108001643275110575187/reviews');
SET @user_aleksa_ljubanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108001643275110575187/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ангелина Анисимова', 'https://lh3.googleusercontent.com/a-/ALV-UjV3HclCGIt2YwxESZCIB_1pTAf-LTSTPaam4vrX-Gbfg-cYIfWT=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108064535832394949666/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108064535832394949666/reviews');
SET @user_angelina_anisimova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108064535832394949666/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Darya Dievskaya', 'https://lh3.googleusercontent.com/a/ACg8ocLTvsIR2S0WR0V45WCTWKP8EORH_fphDjZMw0WhSuwyHaiZbg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111085495116719959189/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111085495116719959189/reviews');
SET @user_darya_dievskaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111085495116719959189/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, '吉Anton', 'https://lh3.googleusercontent.com/a/ACg8ocIbZBz7l5LMZ-lwdmVTxcRU3xNHpE5HRqXia0VBJTZMOd1gbQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109710053461927011710/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109710053461927011710/reviews');
SET @user_anton = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109710053461927011710/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tetiana Rozghon', 'https://lh3.googleusercontent.com/a/ACg8ocIDMKwTCihpGkKUOVjbST61a9mbkzu5vi0V4c4RQV3wNIzkAg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109120516180694640371/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109120516180694640371/reviews');
SET @user_tetiana_rozghon = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109120516180694640371/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natasha', 'https://lh3.googleusercontent.com/a-/ALV-UjVjg7G3SNvYpIkYzx805ch8e_v3RLwsCcx7BVtfJ8GI_KNDjyHE=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117285777350956343780/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117285777350956343780/reviews');
SET @user_natasha = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117285777350956343780/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alexey Shavrin', 'https://lh3.googleusercontent.com/a/ACg8ocLSTJ7fQoZF3uiAMUHFl_XrT_RdPdRkK-6SpaakuPS_z1o2GQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112061640145911588904/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112061640145911588904/reviews');
SET @user_alexey_shavrin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112061640145911588904/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Veronika Zagorcha', 'https://lh3.googleusercontent.com/a-/ALV-UjU-AHSn_RZw-NeDMQHEwJ8mxukypDLfQkCRFxLr-_b7gyOBdVvE=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113247055302582269715/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113247055302582269715/reviews');
SET @user_veronika_zagorcha = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113247055302582269715/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Yana Bulanchuk', 'https://lh3.googleusercontent.com/a-/ALV-UjUK-sXiDECFLAyjb7VlGwthyj1HOJbne1J7FEMDVbSiak0KxiE=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109406513405796351587/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109406513405796351587/reviews');
SET @user_yana_bulanchuk = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109406513405796351587/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Людмила Поволоцкая', 'https://lh3.googleusercontent.com/a-/ALV-UjWMka0lVHaHljcEohvcthLW6LZsdddFrO4_oQidFSx_GTl8w5Xw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111200432381410441786/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111200432381410441786/reviews');
SET @user_lyudmila_povolotskaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111200432381410441786/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Margarita Riaboshapko', 'https://lh3.googleusercontent.com/a-/ALV-UjW-JeSirJr2hWQV6f8Sh9XK16B7bZfPGIPaTDKeah6Yx7lmExk=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106183926093423662125/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106183926093423662125/reviews');
SET @user_margarita_riaboshapko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106183926093423662125/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Арина Лунева', 'https://lh3.googleusercontent.com/a/ACg8ocKAvbeenCo9Makuy1ClNuPxbdGlVjnfyEePJejrBIJzNUOy3w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117273555052077890157/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117273555052077890157/reviews');
SET @user_arina_luneva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117273555052077890157/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Мария Бердникова', 'https://lh3.googleusercontent.com/a-/ALV-UjVYWtQx-gV6dBhsLF8MTu85Z8IOhtylNB2XQS2_1jJq_-7iQHOw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103455150915551602856/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103455150915551602856/reviews');
SET @user_mariya_berdnikova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103455150915551602856/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luxiar', 'https://lh3.googleusercontent.com/a-/ALV-UjVPCnVx8DaKYPK9CSQVSfF-kG9uWzxT9G4m6N3DlbHfmHzf0Zg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113554897499527086576/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113554897499527086576/reviews');
SET @user_luxiar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113554897499527086576/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maria Kovalik', 'https://lh3.googleusercontent.com/a-/ALV-UjXCjfSWCBCmaq0q_VCL0t8qdbGzxRHdkqLDJxk8qkMv3NlEK6xQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109532583224488826055/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109532583224488826055/reviews');
SET @user_maria_kovalik = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109532583224488826055/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Анатолий П', 'https://lh3.googleusercontent.com/a/ACg8ocLcVX3jjAAimd3bqNFadgzWTW3pI1OeX_h4icCiHI3b91kapg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117467915882884349026/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117467915882884349026/reviews');
SET @user_anatoliy_p = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117467915882884349026/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Елена Ленская', 'https://lh3.googleusercontent.com/a-/ALV-UjVAckHzgNP2ME5Ux4oWPGrbGWW3k4DNXoKYNr21vaQM6OhW4kUy=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103928514752510508699/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103928514752510508699/reviews');
SET @user_elena_lenskaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103928514752510508699/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olga Isay', 'https://lh3.googleusercontent.com/a-/ALV-UjWKZ4mWB7u1MxI-MVCGsfw78RYuITHPDcA-XycxZLX0zaeERSQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111351507907050722730/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111351507907050722730/reviews');
SET @user_olga_isay = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111351507907050722730/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ira V', 'https://lh3.googleusercontent.com/a/ACg8ocL5k1FlBiLbc-syp2CuAIB3iv5k_D2WUXxNQ2J12ABTSUafBw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114025544934239501504/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114025544934239501504/reviews');
SET @user_ira_v = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114025544934239501504/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anastasia Suntsova', 'https://lh3.googleusercontent.com/a-/ALV-UjU2rJkvB03jK-EFEXzx1j1gLpWc-hPsbxevnossQYMUE-EFT0G0=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106791186086821610483/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106791186086821610483/reviews');
SET @user_anastasia_suntsova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106791186086821610483/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Larisa Tolstova', 'https://lh3.googleusercontent.com/a/ACg8ocLI8KELr0WQT7eFyjQ6CHDohb0EHpdngrJ4f8SjFnNHcM2hCw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108317205456444160520/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108317205456444160520/reviews');
SET @user_larisa_tolstova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108317205456444160520/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ieva Deinaraviciute', 'https://lh3.googleusercontent.com/a-/ALV-UjWq5LU8-2JI12rLDFQI-Pvg8wdfqg4ebzYX5CHLGGhONACvfKaV=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104275761582354397787/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104275761582354397787/reviews');
SET @user_ieva_deinaraviciute = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104275761582354397787/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Татьяна Рофина', 'https://lh3.googleusercontent.com/a/ACg8ocLuAq0AnnLdkMFmZXvlWp7YA0JPnvi_0yKt2ypXLkbeFW-ZSA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110474688828747299387/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110474688828747299387/reviews');
SET @user_tatyana_rofina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110474688828747299387/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Елена Берсенева', 'https://lh3.googleusercontent.com/a/ACg8ocL4MizU-3ggOyaMtcqfIAt90RcHVIq48JvftUr0EIWhKnvArA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112349833070017472007/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112349833070017472007/reviews');
SET @user_elena_berseneva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112349833070017472007/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kseniia Nam', 'https://lh3.googleusercontent.com/a-/ALV-UjWvXm96AknqcV_IkmIBWCR_wqHKeqQQVV_5Z3ElMFPu4HTPzC-OJg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111000073348800050015/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111000073348800050015/reviews');
SET @user_kseniia_nam = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111000073348800050015/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'G M', 'https://lh3.googleusercontent.com/a-/ALV-UjU-sAztgSF-xbvZPgZeXPzx4owThpzSTNiA2sTaszMfUx-4acxc=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104003854759953598550/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104003854759953598550/reviews');
SET @user_g_m = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104003854759953598550/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'света михайлова', 'https://lh3.googleusercontent.com/a/ACg8ocIfp36PrD-Hp5tLB-rrmgE9Uxn3xUH7htxbJzxRlmVghRtKbw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107987768968796082259/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107987768968796082259/reviews');
SET @user_sveta_mikhaylova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107987768968796082259/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Garri Garri', 'https://lh3.googleusercontent.com/a/ACg8ocL1d3OZrROoay07pMg5tYcph_m4N7st2uPLmWqb3liaOtCaQg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103077163331900714552/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103077163331900714552/reviews');
SET @user_garri_garri = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103077163331900714552/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anita Lalic', 'https://lh3.googleusercontent.com/a-/ALV-UjWElRUZehfZrRZmMTNDMi7p7LyOz_Jr5uW8MXSU8hwd-KVf9gzL=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106694191579562619402/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106694191579562619402/reviews');
SET @user_anita_lalic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106694191579562619402/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ольга', 'https://lh3.googleusercontent.com/a-/ALV-UjXBKOxNUM259_ZgBuvFwpc_Vb-0jgCqZpYkeJQHisxSn4L_DRE=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107033702572517685967/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107033702572517685967/reviews');
SET @user_olga_3 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107033702572517685967/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Inna Boye', 'https://lh3.googleusercontent.com/a-/ALV-UjV8DvCXWsxY5fNwhXCHpK5aXqtlD4z9R8danbBf2QRvzypA4Ro=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113033724207482664440/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113033724207482664440/reviews');
SET @user_inna_boye = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113033724207482664440/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mary Fetr', 'https://lh3.googleusercontent.com/a/ACg8ocIoYKuX3fyEbHene8g1Fug1Q34R5LlMJEGN0Cfrbne6AFsqzQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113855172856568233366/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113855172856568233366/reviews');
SET @user_mary_fetr = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113855172856568233366/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anja Maja Bogićević', 'https://lh3.googleusercontent.com/a/ACg8ocIyj4R2EtGhUtXIC5EP9_wbITWqCUDbmC9uFqC7cZJahgAbsg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115413723527008965881/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115413723527008965881/reviews');
SET @user_anja_maja_bogievi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115413723527008965881/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dr Elena Leschen', 'https://lh3.googleusercontent.com/a/ACg8ocIyLsdCUU_Vorln4q81eY5rcvbvDU42kxvEVJarZkAovb5gbeRe=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115603364734497552512/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115603364734497552512/reviews');
SET @user_dr_elena_leschen = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115603364734497552512/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Veronica', 'https://lh3.googleusercontent.com/a-/ALV-UjXKelyIGV73eXSpKoQHTwl8DTnPu7EjVXCq7-Q-ALlTyN-oENkXlA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110726657093007652846/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110726657093007652846/reviews');
SET @user_veronica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110726657093007652846/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Вера Киселёва', 'https://lh3.googleusercontent.com/a/ACg8ocIM1ig2n18QPscByi-rxbqOUJolVZuh8lgko2dZ-RNDb7oMTA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100465563616325955690/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100465563616325955690/reviews');
SET @user_vera_kiselyova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100465563616325955690/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Oleh Anokhin', 'https://lh3.googleusercontent.com/a/ACg8ocLBz3-T13h6y7H2DU-W7pPUoZASy3Hm4_KNPxppKozMri-KDg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106563713367497894539/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106563713367497894539/reviews');
SET @user_oleh_anokhin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106563713367497894539/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Katty Pride', 'https://lh3.googleusercontent.com/a-/ALV-UjWtdGIE48HR-6SeD1iKTCU4iTlIdvQSC9Hw3WYE4CIIWDI70EgZ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110253890331013687532/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110253890331013687532/reviews');
SET @user_katty_pride = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110253890331013687532/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anastasia Patlavskaya', 'https://lh3.googleusercontent.com/a-/ALV-UjU7bGkBxkiT3xf1mFcHQfyQVucNpcOjalbCcith_g_l52cRjqTW=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117869214809416814544/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117869214809416814544/reviews');
SET @user_anastasia_patlavskaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117869214809416814544/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Инна Хоронжук', 'https://lh3.googleusercontent.com/a-/ALV-UjVY3l8uhqAzrlJhli8tEgnI7LXPi6spiBeSbY5r_rIxIRQJG5wT=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102505266542964949295/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102505266542964949295/reviews');
SET @user_inna_khoronzhuk = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102505266542964949295/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Varja Delibasic', 'https://lh3.googleusercontent.com/a/ACg8ocJPhCP30L5TQ9-fMOZa8CoJKRTjDh1nF9Jqj6XSELeNYaS2Mg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111195730912281024339/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111195730912281024339/reviews');
SET @user_varja_delibasic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111195730912281024339/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kamill Musaev', 'https://lh3.googleusercontent.com/a/ACg8ocIfQkUegpXloG1JgJE3gIpZg3xgaQ8HUgHR9eV7ApXycKPy_Rw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101468818752022930382/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101468818752022930382/reviews');
SET @user_kamill_musaev = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101468818752022930382/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Kasalo', 'https://lh3.googleusercontent.com/a/ACg8ocKnZhsP5m6hLzikpHxA5i4JyPUN_YMCJtQznpQljLj87YkNpQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102557902715872798411/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102557902715872798411/reviews');
SET @user_milica_kasalo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102557902715872798411/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Виктория Полонская', 'https://lh3.googleusercontent.com/a/ACg8ocJHNjGhgz1-jfAu5h-6LGANQGWSQ92fprEO56VOh3gjGahrqg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101022502182583405839/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101022502182583405839/reviews');
SET @user_viktoriya_polonskaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101022502182583405839/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ольга Сбитнева', 'https://lh3.googleusercontent.com/a-/ALV-UjUefG65sgkXbl417VdQ7yIBEfRT532cl86u1uwubTa5oKrr3Rw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117957424963993589862/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117957424963993589862/reviews');
SET @user_olga_sbitneva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117957424963993589862/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nena Djukic', 'https://lh3.googleusercontent.com/a-/ALV-UjUkAuboeI65ZAU78-dkcnWwf9AfHumIqYDIeaTJRc53XdtcWOA7=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113317976692832664769/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113317976692832664769/reviews');
SET @user_nena_djukic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113317976692832664769/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mela Masta', 'https://lh3.googleusercontent.com/a/ACg8ocIvvEbGEKTN2MuETqu6R8TdVtM0M04KzpxU9877I87R5xB9jQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109334863047509292839/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109334863047509292839/reviews');
SET @user_mela_masta = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109334863047509292839/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Нина Маркина', 'https://lh3.googleusercontent.com/a-/ALV-UjW-9Vv_DlVtUmyJufXdoDFuEJsh4vmvmfWanrcYL-unEXWOqPJF=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108829101682326967484/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108829101682326967484/reviews');
SET @user_nina_markina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108829101682326967484/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alena Koltsova', 'https://lh3.googleusercontent.com/a/ACg8ocLxRE707IzGdK_1NNfS1l4ycdV5TZO39gRvjyLOhlWAdqsVZw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111987013046489176186/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111987013046489176186/reviews');
SET @user_alena_koltsova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111987013046489176186/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anton', 'https://lh3.googleusercontent.com/a-/ALV-UjUjn5XhtD01tnUgiJHM4vaxc7J8vxg889ROnj_d7MSnAhrz0gv4=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112127261968963650578/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112127261968963650578/reviews');
SET @user_anton_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112127261968963650578/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Анна Белая', 'https://lh3.googleusercontent.com/a-/ALV-UjUutTZ3iX3n82Ib1nopxTwibiGIMMLu072N8TWSeL9eSQL_HIYKXw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103987865249844592889/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103987865249844592889/reviews');
SET @user_anna_belaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103987865249844592889/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alexandr Makovskiy', 'https://lh3.googleusercontent.com/a-/ALV-UjWlcBYvl11aVj_mqGbUbiUKcHPhDpKt-3z-EMDxQVyXpa4oOzE=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111840499929699731897/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111840499929699731897/reviews');
SET @user_alexandr_makovskiy = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111840499929699731897/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andjela Bojovic', 'https://lh3.googleusercontent.com/a/ACg8ocI0SlEck77Fu-Sk-0jSFbAJ1-TJza2115t5F8UUCHNgIRJYDA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113563135271374568576/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113563135271374568576/reviews');
SET @user_andjela_bojovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113563135271374568576/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'rina rina', 'https://lh3.googleusercontent.com/a/ACg8ocIzG5qd781ZIxAgXBUU2BBFt9-FUKYh7QKv9PE6iJN3GFA8vg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101618785386168181059/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101618785386168181059/reviews');
SET @user_rina_rina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101618785386168181059/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, '/ Sofiya Patrina \\', 'https://lh3.googleusercontent.com/a-/ALV-UjWO_oS0fd2WfpHWIzC9rbcKT1erFzkWgk9ldtGF51zRAdK9-ELV=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103886114752943164240/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103886114752943164240/reviews');
SET @user_sofiya_patrina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103886114752943164240/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Polina Polina', 'https://lh3.googleusercontent.com/a-/ALV-UjXWB89-Duc5s-4MLCVCsYyvKdeXQQsI1XNpLUCn0hnbFGTLeIt1=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105338859609353698119/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105338859609353698119/reviews');
SET @user_polina_polina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105338859609353698119/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Varvara Koneva', 'https://lh3.googleusercontent.com/a-/ALV-UjWtYLqpcw5sE9DauD3qHWp2ZE5KfsTq9LdeNu6VEO8elgrXZrYY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114920270910262730399/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114920270910262730399/reviews');
SET @user_varvara_koneva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114920270910262730399/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Snap 17', 'https://lh3.googleusercontent.com/a/ACg8ocIKkGiUguzFGfIuA5fjdRuLMAPIPkwNBHM1tfZPG953RF4LWQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109602110649641321479/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109602110649641321479/reviews');
SET @user_snap_17 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109602110649641321479/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Дарья Тушева-Герасименко', 'https://lh3.googleusercontent.com/a-/ALV-UjUwXTAVopg98tE8T57ADgypiTs-a33I-Fy3ta5Q4FL0vT8sZtKp=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101947692749416655685/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101947692749416655685/reviews');
SET @user_darya_tushevagerasimenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101947692749416655685/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Кристина', 'https://lh3.googleusercontent.com/a/ACg8ocK9Gkh63uwcdzGzU5f1Xw69r7-dRzADXFotUW16zekPMgt6=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112764598126986635313/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112764598126986635313/reviews');
SET @user_kristina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112764598126986635313/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elena Shokhova', 'https://lh3.googleusercontent.com/a/ACg8ocJhzJ_TL3RIKgftiQZrHHasi8sT6FcEhQElpBwEN6alWo_5pw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105742685966418181983/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105742685966418181983/reviews');
SET @user_elena_shokhova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105742685966418181983/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ekaterina Bochkareva', 'https://lh3.googleusercontent.com/a/ACg8ocKmsYLVhrmOvCaXSAcu8xjnUksjUSdjvAnnJMOv2j-X0C1KNA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113308084746044940727/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113308084746044940727/reviews');
SET @user_ekaterina_bochkareva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113308084746044940727/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Генетический диетолог Людмила Гончарова', 'https://lh3.googleusercontent.com/a-/ALV-UjXH_b2DV7bs3kaXLFJEgb070-Ga9FmavuK6SAPi5pM6VR8azzTQBA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101174025790804862993/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101174025790804862993/reviews');
SET @user_geneticheskiy_dietolog_lyudmila_goncharova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101174025790804862993/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milja Zenović', 'https://lh3.googleusercontent.com/a-/ALV-UjXcED54XKUNr1ZylkRYc5BPNm_etNbiLtoTb_h0_zyMCevtQtaY=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108021444443710046424/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108021444443710046424/reviews');
SET @user_milja_zenovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108021444443710046424/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Виктория Гаркуша', 'https://lh3.googleusercontent.com/a-/ALV-UjUDJdFFfhAX95VF-iJSi-uT9p5T20QV8jFcGA8y_LZc1bBQbpoE7Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107162590470987624887/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107162590470987624887/reviews');
SET @user_viktoriya_garkusha = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107162590470987624887/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Лилия Калинцева', 'https://lh3.googleusercontent.com/a-/ALV-UjVQQzwZwZDVnjBWiUo_cbQoFXEGB8jvsqh3Y3AlVymdLr9KNGX11g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115242736680695265896/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115242736680695265896/reviews');
SET @user_liliya_kalintseva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115242736680695265896/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anna М', 'https://lh3.googleusercontent.com/a/ACg8ocKVy6Ch6uCj2OCTzD83TwNb6hytH2AO5xTapbXTa996d8-vKg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104685423133306417016/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104685423133306417016/reviews');
SET @user_anna_m = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104685423133306417016/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'анжела шаврина', 'https://lh3.googleusercontent.com/a-/ALV-UjUyky-3RCwlFmk5sE5GsYX2LwbIKZMIPJLOjdGhB1UaU0cU619AIg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103025678304210255329/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103025678304210255329/reviews');
SET @user_anzhela_shavrina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103025678304210255329/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vika Mickey', 'https://lh3.googleusercontent.com/a-/ALV-UjV-4HMvqPR8hANhsf5phZsrRjk4lNO5btdg5uj2rIyeLouRNRg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113275664129059895985/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113275664129059895985/reviews');
SET @user_vika_mickey = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113275664129059895985/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anna Kvasha', 'https://lh3.googleusercontent.com/a-/ALV-UjXPcDHIUi_rnZYn7-fH_8UdjvoacJnqN_0EbxGisZzsDJGlrNgIwA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102707597518012187510/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102707597518012187510/reviews');
SET @user_anna_kvasha = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102707597518012187510/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sofia E', 'https://lh3.googleusercontent.com/a-/ALV-UjVDP4rQcv8k7HrgydwGfnjtAywKIN08YRCN-krXoArl2x9t-2R8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100534877170202755951/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100534877170202755951/reviews');
SET @user_sofia_e = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100534877170202755951/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'AliAniAri', 'https://lh3.googleusercontent.com/a-/ALV-UjXUgF6WwWfu-NPn19ZLFLY4col8SWLQFGu2xP7gzDpJ26rqpmw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117866092457604431648/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117866092457604431648/reviews');
SET @user_alianiari = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117866092457604431648/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Мария Сигитова', 'https://lh3.googleusercontent.com/a-/ALV-UjW4k9bu_sm1drpksoIEq6YT8-YmYzDTgoZahA-vZqCaEg-K-x58HQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110700321938801079943/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110700321938801079943/reviews');
SET @user_mariya_sigitova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110700321938801079943/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anri Bolon', 'https://lh3.googleusercontent.com/a-/ALV-UjXGsJFU33e3qlSKDMFsJZZG3RJyXH9itSz7VMLL48OtvutWO50=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102863369453143562356/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102863369453143562356/reviews');
SET @user_anri_bolon = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102863369453143562356/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Irina Petrishina', 'https://lh3.googleusercontent.com/a-/ALV-UjX8o_hMh9yW_WkYRKSHfh6PofIHrQJaDNGhRqCGo4Yjz_aOFv5Y=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106558549439724048964/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106558549439724048964/reviews');
SET @user_irina_petrishina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106558549439724048964/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Svetlana Ovchinnikova', 'https://lh3.googleusercontent.com/a/ACg8ocJL40CURggkf9YSZvit9Nn1s7lSFvCrTasQXgtUk4JaiT3vTg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103109217133053272878/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103109217133053272878/reviews');
SET @user_svetlana_ovchinnikova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103109217133053272878/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Никита Бондаренко', 'https://lh3.googleusercontent.com/a/ACg8ocK5iK63FzokQfwmCrPnEdlRRn7rYE4SwjG678Z7bmhbBABUmg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116755573077152077550/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116755573077152077550/reviews');
SET @user_nikita_bondarenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116755573077152077550/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Надежда Гордеева', 'https://lh3.googleusercontent.com/a/ACg8ocKBQVSFRhqBx1Ei8LhW5SbWhr8XDnicJCoqeCUbAoBDEyw1iw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103071937969834538219/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103071937969834538219/reviews');
SET @user_nadezhda_gordeeva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103071937969834538219/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pastel de nata', 'https://lh3.googleusercontent.com/a/ACg8ocId_Pus7SoKdDH3fabK4VRlhD1OgbESSaBClLueF1gtADZHwg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113103802273893753601/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113103802273893753601/reviews');
SET @user_pastel_de_nata = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113103802273893753601/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Christina Tkach', 'https://lh3.googleusercontent.com/a/ACg8ocIU-1-yCoAMp3PGkHVVYKfPMQhJwO0KKE01xJxMLqwjBUVoYQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108949797186391699982/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108949797186391699982/reviews');
SET @user_christina_tkach = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108949797186391699982/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tatsiana Mileshko', 'https://lh3.googleusercontent.com/a-/ALV-UjXRmHKdItvZ9ZB-jwNGRYs4MFJfxu51zGDNYBmcxmGYWy1Uzmc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113844251937832562754/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113844251937832562754/reviews');
SET @user_tatsiana_mileshko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113844251937832562754/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Елена Клинова', 'https://lh3.googleusercontent.com/a-/ALV-UjVXY7LF_CrnyVRCyfsOsA699_5UTZTfZb5eH_zDGFdNwVKNB-A0gQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102057913926453861702/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102057913926453861702/reviews');
SET @user_elena_klinova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102057913926453861702/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Анастасия Евдокимович', 'https://lh3.googleusercontent.com/a/ACg8ocLmpUvC_oG_60v3uiFL86xrJNBZPdWy63PlyRDQjK78ZynE7Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108196331659586046861/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108196331659586046861/reviews');
SET @user_anastasiya_evdokimovich = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108196331659586046861/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Василиса Карпова', 'https://lh3.googleusercontent.com/a-/ALV-UjVqCoIOHOriHGD8zHBQZoohyCvJUFgViTcfZpqSvksA4m0Sm0iP=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112681999132234158568/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112681999132234158568/reviews');
SET @user_vasilisa_karpova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112681999132234158568/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ирина Шершнева', 'https://lh3.googleusercontent.com/a/ACg8ocLl--tOne9b-KFeqTxTcazLZoPbBy7N9GOcPWwqWlvmoSfHJA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109900314667508285535/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109900314667508285535/reviews');
SET @user_irina_shershneva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109900314667508285535/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Merrilee Sjolander', 'https://lh3.googleusercontent.com/a/ACg8ocKoYXlzBYYJv1YYj1PZ_KSYhqF1HOvKzQFu8SU4gU6z_cWtSg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100669447082136067941/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100669447082136067941/reviews');
SET @user_merrilee_sjolander = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100669447082136067941/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elisheva G', 'https://lh3.googleusercontent.com/a/ACg8ocLJvqALiIeL-qM1XEHAaZITehYqZT2tuYVM_oc8CFJZM2rTeg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101459838919794503988/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101459838919794503988/reviews');
SET @user_elisheva_g = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101459838919794503988/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kate O\'Hara', 'https://lh3.googleusercontent.com/a-/ALV-UjV-Slq8JNmzTNn9ZoC0hC8_37NzXBdLirB6HxxuF-J8h7Vt_mrtHw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101947387748380443396/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101947387748380443396/reviews');
SET @user_kate_ohara = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101947387748380443396/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Angelika Israfilova', 'https://lh3.googleusercontent.com/a-/ALV-UjUQOgOs8z0q0ts4JwgnhqkqnZ8J0mTVLC3o4MlQkthArA3tAwnZTw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107190195367705766987/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107190195367705766987/reviews');
SET @user_angelika_israfilova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107190195367705766987/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Katya EA', 'https://lh3.googleusercontent.com/a/ACg8ocLvYx51huzSa_tXFxLkPrNjkPjPckJsKv5jOWA-fe2yNVmu9g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104472396399910845337/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104472396399910845337/reviews');
SET @user_katya_ea = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104472396399910845337/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lesia Makfluri', 'https://lh3.googleusercontent.com/a-/ALV-UjVP-MNduHRnYH9bxFM-p46nCzrfYqkLPodBpEFCxI_7yfBLbaBerw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114913796802413562589/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114913796802413562589/reviews');
SET @user_lesia_makfluri = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114913796802413562589/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Елена', 'https://lh3.googleusercontent.com/a-/ALV-UjVQo4yA_GxFfxC06D-hiuUlc5K4Y5azCBVz877c64R_cUK6Vf6tyQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108389631201508769620/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108389631201508769620/reviews');
SET @user_elena_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108389631201508769620/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Svetlana “Seesun”', 'https://lh3.googleusercontent.com/a-/ALV-UjUbOIaa_4yRNqkLAcctXNHrOBokVVwbiH3nCLuHUAyxywf2jptd=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117583903763890903441/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117583903763890903441/reviews');
SET @user_svetlana_seesun = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117583903763890903441/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Svetlana realtor.montenegro (Montenegro)', 'https://lh3.googleusercontent.com/a-/ALV-UjXMjIJJb_7irtQ-AZXiNJc7T9wo1o-nnrtujWhtDM57XEgj-zYR=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117387478817982433830/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117387478817982433830/reviews');
SET @user_svetlana_realtormontenegro_montenegro = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117387478817982433830/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Evgenia Kolesnikova', 'https://lh3.googleusercontent.com/a/ACg8ocKhAi6lRP2RkmZ28utiN4THtLex68t8QiOI8Pnm_ZneaJoZoA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102607298256922655602/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102607298256922655602/reviews');
SET @user_evgenia_kolesnikova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102607298256922655602/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Анна Сигута', 'https://lh3.googleusercontent.com/a/ACg8ocIdLqZ8PrMtCSIC9k5e3y5TyKZ2rtSFUQ2_G0g9sIoGxJv1_A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106330406388505405890/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106330406388505405890/reviews');
SET @user_anna_siguta = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106330406388505405890/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nadiia Imanova', 'https://lh3.googleusercontent.com/a-/ALV-UjVuIBdeitc3LPbuYU35rGsI-Zd0nQ_tZoGKffsBjOjRO9rpbXpc=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106956285298443901871/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106956285298443901871/reviews');
SET @user_nadiia_imanova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106956285298443901871/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Михаил Михайлович', 'https://lh3.googleusercontent.com/a-/ALV-UjU2YUAAT3xyYL1d5fANb-1K1Q0IBeK_ECEtlXwLEfc3clO7N8Hn=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106229987897555421017/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106229987897555421017/reviews');
SET @user_mikhail_mikhaylovich = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106229987897555421017/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marina Antonova', 'https://lh3.googleusercontent.com/a/ACg8ocI9mpi4YRsxDYfpTQX43_8kA75B5-C3WY5IqvR7zvMGBq6xqQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107287387467897922343/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107287387467897922343/reviews');
SET @user_marina_antonova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107287387467897922343/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kejvinaleksa Popova', 'https://lh3.googleusercontent.com/a/ACg8ocIqaN0dTg71C6JRIh9l-qSPAagQWzjbJt4C_aqUCScjnAY1LA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100817740940695137592/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100817740940695137592/reviews');
SET @user_kejvinaleksa_popova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100817740940695137592/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ирина Рукас', 'https://lh3.googleusercontent.com/a-/ALV-UjVGCN3m0g4l1RF18CXY-j7Oq1Gs1w3V-pLkQX9oP__RoR6gR34=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118180003204819844821/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118180003204819844821/reviews');
SET @user_irina_rukas = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118180003204819844821/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tatiana Antipkina', 'https://lh3.googleusercontent.com/a-/ALV-UjU2eYkbp68yhOPKDb2w4xMO4yMV4hja0uebrwJTHSys8xFZsWLDJQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110265908473061978222/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110265908473061978222/reviews');
SET @user_tatiana_antipkina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110265908473061978222/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Liudmila Nesterenko', 'https://lh3.googleusercontent.com/a/ACg8ocISP34h8EjvvHeXWwzY-3uWNsS-tYcAL1yuUEVxiazxtcvQXg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117519922435674730166/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117519922435674730166/reviews');
SET @user_liudmila_nesterenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117519922435674730166/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Юлия Галдина', 'https://lh3.googleusercontent.com/a/ACg8ocLfNXFiVJNJ0bm8NNEqhZ8r1k5S8K2D3AcOCNBUCeziuCJJjQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115456711604258179901/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115456711604258179901/reviews');
SET @user_yuliya_galdina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115456711604258179901/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Джоанитальяра Ливерпульь', 'https://lh3.googleusercontent.com/a-/ALV-UjW5d1DY-YNil-7uF9qoaCE1KwyKx2cFZiClEVcbE-B0Ls42uSQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103087963940373123086/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103087963940373123086/reviews');
SET @user_dzhoanitalyara_liverpul = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103087963940373123086/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lyubov Vereschinskaya', 'https://lh3.googleusercontent.com/a-/ALV-UjUmprCQ-B0QUZLhhX7aikhMy5x9fS56YqLSdXvhfbBPVL4AFeg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112474056807417041933/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112474056807417041933/reviews');
SET @user_lyubov_vereschinskaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112474056807417041933/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, '1 2', 'https://lh3.googleusercontent.com/a-/ALV-UjUvtCl3qhf8Ts58tnEWp0q2RRVsirfcc3pDssCYbaj3bhQlsmvb=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107866506146105597435/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107866506146105597435/reviews');
SET @user_1_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107866506146105597435/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Yulia Prosto', 'https://lh3.googleusercontent.com/a-/ALV-UjXr0y78pSJin0URZdsnHS3b8P6cBoHyHJGS-JHmfsxdtOkeC6Z_=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115387577828169554019/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115387577828169554019/reviews');
SET @user_yulia_prosto = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115387577828169554019/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olga Ovchinnikova', 'https://lh3.googleusercontent.com/a/ACg8ocLD-ihfWTINrErLTtEoJt5JfiaMlg1lRrnROsyd3CDp50drpw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107229047359562636247/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107229047359562636247/reviews');
SET @user_olga_ovchinnikova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107229047359562636247/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_stella_lei, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pCSlJYbEJSblJUVkUxMU56VkxWVFJpTWpSRFpVRRAB',
    5, 'de', 'Wir waren als Notfall wegen eines eingewachsenen Fußnagels im centre of Podology und sind sehr dankbar für die schnelle Hilfe. Trotz unseres spontanen Besuchs haben wir kurzfristig einen Termin erhalten und wurden hervorragend betreut.
Das gesamte Team war überaus freundlich, hilfsbereit und einfühlsam. Die Behandlung war sehr professionell und wir haben uns von Anfang an gut aufgehoben gefühlt.
Vielen Dank für die schnelle und kompetente Unterstützung – wir können iPODO uneingeschränkt weiterempfehlen!',
    'Bili smo kao hitan slučaj zbog uraslog nokta na nozi u centru za podologiju i veoma smo zahvalni na brzoj pomoći. Iako smo došli spontano, dobili smo termin u kratkom roku i o nama su se odlično pobrinuli.
Cijeli tim je bio izuzetno ljubazan, spreman da pomogne i pun razumijevanja. Tretman je bio veoma profesionalan i od prvog trenutka smo se osjećali u dobrim rukama.
Veliko hvala na brzoj i kompetentnoj podršci – iPODO možemo preporučiti bez ikakve rezerve!', 'Били смо као хитан случај због ураслог нокта на нози у центру за подологију и веома смо захвални на брзој помоћи. Иако смо дошли спонтано, добили смо термин у кратком року и о нама су се одлично побринули.
Цијели тим је био изузетно љубазан, спреман да помогне и пун разумијевања. Третман је био веома професионалан и од првог тренутка смо се осјећали у добрим рукама.
Велико хвала на брзој и компетентној подршци – iPODO можемо препоручити без икакве резерве!', 'We came to the centre of Podology as an emergency because of an ingrown toenail and we are very grateful for the quick help. Even though we just dropped in spontaneously, we got an appointment on short notice and were looked after wonderfully.
The whole team was extremely friendly, helpful and understanding. The treatment was very professional and we felt in good hands right from the start.
Many thanks for the fast and competent support – we can recommend iPODO without any reservations!', 'Мы обратились в центр подологии как срочный случай из-за вросшего ногтя на ноге и очень благодарны за быструю помощь. Несмотря на то, что пришли спонтанно, нас записали в кратчайшие сроки и приняли превосходно.
Вся команда была чрезвычайно приветливой, отзывчивой и внимательной. Лечение прошло очень профессионально, и с самого начала мы чувствовали себя в надёжных руках.
Большое спасибо за быструю и компетентную помощь — можем рекомендовать iPODO без каких-либо оговорок!', 'Wir waren als Notfall wegen eines eingewachsenen Fußnagels im centre of Podology und sind sehr dankbar für die schnelle Hilfe. Trotz unseres spontanen Besuchs haben wir kurzfristig einen Termin erhalten und wurden hervorragend betreut.
Das gesamte Team war überaus freundlich, hilfsbereit und einfühlsam. Die Behandlung war sehr professionell und wir haben uns von Anfang an gut aufgehoben gefühlt.
Vielen Dank für die schnelle und kompetente Unterstützung – wir können iPODO uneingeschränkt weiterempfehlen!', 'Batık ayak tırnağı nedeniyle acil olarak podoloji merkezine gittik ve hızlı yardım için çok minnettarız. Aniden gelmemize rağmen kısa sürede randevu aldık ve bizimle mükemmel şekilde ilgilenildi.
Tüm ekip son derece nazik, yardımsever ve anlayışlıydı. Tedavi çok profesyoneldi ve ilk andan itibaren kendimizi emin ellerde hissettik.
Hızlı ve yetkin destek için çok teşekkürler – iPODO\'yu hiç çekinmeden tavsiye edebiliriz!',
    0, NULL),

(@user_ekaterina_kokorina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pGMlR5MTNRa2hhY0RGTWN6Qk1XbGxYZERNeVpFRRAB',
    5, 'ru', 'Всё понравилось. Вежливый персонал и комфортная обстановка. Спасибо!',
    'Sve mi se svidjelo. Ljubazno osoblje i prijatan ambijent. Hvala!', 'Све ми се свидјело. Љубазно особље и пријатан амбијент. Хвала!', 'I liked everything. Polite staff and a comfortable atmosphere. Thank you!', 'Всё понравилось. Вежливый персонал и комфортная обстановка. Спасибо!', 'Mir hat alles gefallen. Höfliches Personal und eine angenehme Atmosphäre. Danke!', 'Her şeyi beğendim. Nazik personel ve rahat bir ortam. Teşekkürler!',
    0, '2026-08-01 00:00:00'),

(@user_aanna_maslova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25OdVVra3hXbWRGZWs5b1IxZE5abU5VTFMxYVgwRRAB',
    5, 'ru', 'Очень приятный салон, всегда аккуратный маникюр, хожу к любому мастеру. Вкусный чай и быстрая запись!',
    'Veoma prijatan salon, manikir je uvijek uredan, idem kod bilo kog majstora. Ukusan čaj i brzo zakazivanje!', 'Веома пријатан салон, маникир је увијек уредан, идем код било ког мајстора. Укусан чај и брзо заказивање!', 'A very pleasant salon, the manicure is always neat, I go to any of the technicians. Tasty tea and quick booking!', 'Очень приятный салон, всегда аккуратный маникюр, хожу к любому мастеру. Вкусный чай и быстрая запись!', 'Ein sehr angenehmes Studio, die Maniküre ist immer sauber gemacht, ich gehe zu jeder Mitarbeiterin. Leckerer Tee und schnelle Terminvergabe!', 'Çok hoş bir salon, manikür her zaman kusursuz, hangi uzmana giderseniz gidin. Lezzetli çay ve hızlı randevu!',
    0, '2026-08-01 00:00:00'),

(@user_roman_montenegro, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUREa2Q3bVhREAE',
    5, 'ru', 'Прихожу на мужской маникюр и педикюр, теперь появились услуги мужской стрижки. Очень советую!',
    'Dolazim na muški manikir i pedikir, a sada su uveli i muško šišanje. Toplo preporučujem!', 'Долазим на мушки маникир и педикир, а сада су увели и мушко шишање. Топло препоручујем!', 'I come for men\'s manicures and pedicures, and now they\'ve added men\'s haircuts too. Highly recommend!', 'Прихожу на мужской маникюр и педикюр, теперь появились услуги мужской стрижки. Очень советую!', 'Ich komme für Männer-Maniküre und -Pediküre, und jetzt gibt es auch Herrenhaarschnitte. Sehr empfehlenswert!', 'Erkek manikür ve pedikürü için geliyorum, artık erkek saç kesimi hizmeti de var. Kesinlikle tavsiye ederim!',
    0, '2026-08-01 00:00:00'),

(@user_anna, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSV05HTlRTMVprTTFGdFZtbDJaMFJRUlhOR2IyYxAB',
    2, 'ru', 'Не нужно писать в комментарии к моей оценке, что я не являюсь клиентом Вашего салона - я получала услуги в вашем салоне. Вижу как вы нападаете на клиентов за другие негативные отзывы, поэтому решила ничего не писать просто поставить оценку - это мое впечатление от посещения вашего салона',
    'Nemojte u komentaru na moju ocjenu pisati da nisam klijent Vašeg salona - koristila sam usluge u vašem salonu. Vidim kako napadate klijente zbog drugih negativnih recenzija, pa sam odlučila da ne pišem ništa, nego samo da dam ocjenu - to je moj doživljaj posjete vašem salonu', 'Немојте у коментару на моју оцјену писати да нисам клијент Вашег салона - користила сам услуге у вашем салону. Видим како нападате клијенте због других негативних рецензија, па сам одлучила да не пишем ништа, него само да дам оцјену - то је мој доживљај посјете вашем салону', 'There\'s no need to write in the comment to my rating that I\'m not a client of your salon - I did receive services at your salon. I see how you attack clients over other negative reviews, so I decided not to write anything and just leave a rating - this is my impression of visiting your salon', 'Не нужно писать в комментарии к моей оценке, что я не являюсь клиентом Вашего салона - я получала услуги в вашем салоне. Вижу как вы нападаете на клиентов за другие негативные отзывы, поэтому решила ничего не писать просто поставить оценку - это мое впечатление от посещения вашего салона', 'Sie brauchen im Kommentar zu meiner Bewertung nicht zu schreiben, dass ich keine Kundin Ihres Salons bin - ich habe in Ihrem Salon Leistungen in Anspruch genommen. Ich sehe, wie Sie Kunden wegen anderer negativer Bewertungen angreifen, deshalb habe ich beschlossen, nichts zu schreiben und einfach nur eine Bewertung abzugeben - das ist mein Eindruck vom Besuch in Ihrem Salon', 'Puanımın altına salonunuzun müşterisi olmadığımı yazmanıza gerek yok - salonunuzda hizmet aldım. Diğer olumsuz yorumlar yüzünden müşterilere nasıl saldırdığınızı görüyorum, bu yüzden hiçbir şey yazmayıp sadece puan vermeye karar verdim - bu benim salonunuza yaptığım ziyaretten kalan izlenimim',
    0, '2026-08-01 00:00:00'),

(@user_nata_lia, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTUNBanRuRlJ3EAE',
    5, 'ru', 'Самые лучшие!!!!',
    'Najbolji su!!!!', 'Најбољи су!!!!', 'Simply the best!!!!', 'Самые лучшие!!!!', 'Die Allerbesten!!!!', 'En iyileri!!!!',
    0, '2026-08-01 00:00:00'),

(@user_nataliya_sh, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT20xWU56ZGZTMmQ2VGxKVE5UWXpObTV1UTNCdE1uYxAB',
    5, 'uk', 'Якісний манікюр, стерильний інструмент, затишна приємна атмосфера центру. Дуже дякую!❤️',
    'Kvalitetan manikir, sterilan instrument, ugodna i prijatna atmosfera centra. Puno hvala!❤️', 'Квалитетан маникир, стерилан инструмент, угодна и пријатна атмосфера центра. Пуно хвала!❤️', 'Quality manicure, sterile instruments, a cosy and pleasant atmosphere at the centre. Thank you so much!❤️', 'Качественный маникюр, стерильный инструмент, уютная приятная атмосфера центра. Большое спасибо!❤️', 'Hochwertige Maniküre, steriles Instrumentarium, gemütliche und angenehme Atmosphäre im Zentrum. Vielen Dank!❤️', 'Kaliteli manikür, steril aletler, merkezde huzurlu ve hoş bir atmosfer. Çok teşekkür ederim!❤️',
    0, '2026-07-30 00:00:00'),

(@user_kyrian, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25FeExWTjNZamhyU2pKVWRtTkdWSHBZTmtaNWVWRRAB',
    5, 'ru', 'Лучший Подолог в Черногории. Решила мою проблему, с которой я мучился несколько месяцев. Сам центр очень современный, чистый, удобная зона ожидания, быстрый ответ на сообщения и звонки.',
    'Najbolji podolog u Crnoj Gori. Riješila je moj problem s kojim sam se mučio nekoliko mjeseci. Sam centar je veoma moderan, čist, udobna čekaonica, brzo odgovaraju na poruke i pozive.', 'Најбољи подолог у Црној Гори. Ријешила је мој проблем с којим сам се мучио неколико мјесеци. Сам центар је веома модеран, чист, удобна чекаоница, брзо одговарају на поруке и позиве.', 'The best podiatrist in Montenegro. She solved the problem I\'d been suffering with for several months. The centre itself is very modern and clean, with a comfortable waiting area, and they answer messages and calls quickly.', 'Лучший Подолог в Черногории. Решила мою проблему, с которой я мучился несколько месяцев. Сам центр очень современный, чистый, удобная зона ожидания, быстрый ответ на сообщения и звонки.', 'Die beste Podologin in Montenegro. Sie hat mein Problem gelöst, mit dem ich mich mehrere Monate gequält habe. Das Zentrum selbst ist sehr modern, sauber, mit einem bequemen Wartebereich, und auf Nachrichten und Anrufe wird schnell geantwortet.', 'Karadağ\'ın en iyi podologu. Aylarca çektiğim sorunumu çözdü. Merkezin kendisi çok modern, temiz, bekleme alanı rahat, mesaj ve aramalara hızlı yanıt veriyorlar.',
    0, '2026-07-29 00:00:00'),

(@user_francesca_de_gregorio, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tGQk4wTkRlRzFKUmpaNWRrRkpRbGREZWtzMVJFRRAB',
    5, 'en', 'I’ve been coming to this beauty and wellness centre for a while now, and I honestly wouldn’t go anywhere else. It’s so convenient to have everything in one place – hair, nails, beauty treatments, and professional podiatry.

The team is always friendly and professional, and the centre is spotless. Every treatment I’ve had has been excellent, and I always leave happy with the results.

What really makes this place special is the attention to detail and the genuine care for every client. I highly recommend it to anyone looking for high-quality service and a welcoming atmosphere.',
    'Već neko vrijeme dolazim u ovaj centar za ljepotu i wellness i iskreno ne bih išla nigdje drugdje. Toliko je praktično imati sve na jednom mjestu – frizura, nokti, tretmani ljepote i profesionalna podologija.

Tim je uvijek ljubazan i profesionalan, a centar besprijekorno čist. Svaki tretman koji sam imala bio je odličan i uvijek odem zadovoljna rezultatom.

Ono što ovo mjesto čini posebnim jeste pažnja na detalje i iskrena briga za svakog klijenta. Toplo ga preporučujem svima koji traže uslugu visokog kvaliteta i gostoljubivu atmosferu.', 'Већ неко вријеме долазим у овај центар за љепоту и wellness и искрено не бих ишла нигдје другдје. Толико је практично имати све на једном мјесту – фризура, нокти, третмани љепоте и професионална подологија.

Тим је увијек љубазан и професионалан, а центар беспријекорно чист. Сваки третман који сам имала био је одличан и увијек одем задовољна резултатом.

Оно што ово мјесто чини посебним јесте пажња на детаље и искрена брига за сваког клијента. Топло га препоручујем свима који траже услугу високог квалитета и гостољубиву атмосферу.', 'I’ve been coming to this beauty and wellness centre for a while now, and I honestly wouldn’t go anywhere else. It’s so convenient to have everything in one place – hair, nails, beauty treatments, and professional podiatry.

The team is always friendly and professional, and the centre is spotless. Every treatment I’ve had has been excellent, and I always leave happy with the results.

What really makes this place special is the attention to detail and the genuine care for every client. I highly recommend it to anyone looking for high-quality service and a welcoming atmosphere.', 'Я хожу в этот центр красоты и wellness уже довольно давно и, честно говоря, никуда больше не пошла бы. Так удобно, когда всё в одном месте — волосы, ногти, косметические процедуры и профессиональная подология.

Команда всегда приветливая и профессиональная, а в центре идеальная чистота. Все процедуры, которые я делала, были отличными, и я всегда ухожу довольная результатом.

Что действительно делает это место особенным — внимание к деталям и искренняя забота о каждом клиенте. Очень рекомендую всем, кто ищет качественный сервис и радушную атмосферу.', 'Ich komme schon eine Weile in dieses Beauty- und Wellnesscenter und würde ehrlich gesagt nirgendwo anders hingehen. Es ist so praktisch, alles an einem Ort zu haben – Haare, Nägel, Beautybehandlungen und professionelle Podologie.

Das Team ist immer freundlich und professionell, und das Zentrum ist blitzsauber. Jede Behandlung, die ich hatte, war ausgezeichnet, und ich gehe immer zufrieden mit dem Ergebnis nach Hause.

Was diesen Ort wirklich besonders macht, ist die Aufmerksamkeit für Details und die echte Fürsorge für jeden Kunden. Ich kann es allen wärmstens empfehlen, die hochwertigen Service und eine herzliche Atmosphäre suchen.', 'Bir süredir bu güzellik ve wellness merkezine geliyorum ve dürüst olmak gerekirse başka hiçbir yere gitmezdim. Her şeyin tek bir yerde olması çok pratik – saç, tırnak, güzellik bakımları ve profesyonel podoloji.

Ekip her zaman güler yüzlü ve profesyonel, merkez ise pırıl pırıl. Yaptırdığım her uygulama mükemmeldi ve her seferinde sonuçtan memnun ayrılıyorum.

Burayı gerçekten özel kılan şey, detaylara verilen önem ve her müşteriye gösterilen samimi ilgi. Yüksek kaliteli hizmet ve sıcak bir ortam arayan herkese gönülden tavsiye ederim.',
    0, '2026-07-29 00:00:00'),

(@user_irishka, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5Nk1IaGFWa2xrUlVsQ2JUbG1kMjVNTjNaVWNWRRAB',
    5, 'ru', 'Спасибо за классный маникюр. Мастер помог подобрать подобрать интересный дизайн, который реализовал быстро и качественно. В салоне очень уютно и чисто, обязательно сюда вернусь за новым маникюром',
    'Hvala za sjajan manikir. Majstor mi je pomogao da izaberem zanimljiv dizajn, koji je izveo brzo i kvalitetno. U salonu je veoma prijatno i čisto, sigurno ću se vratiti za novi manikir', 'Хвала за сјајан маникир. Мајстор ми је помогао да изаберем занимљив дизајн, који је извео брзо и квалитетно. У салону је веома пријатно и чисто, сигурно ћу се вратити за нови маникир', 'Thank you for the great manicure. The technician helped me pick an interesting design and did it quickly and beautifully. The salon is very cosy and clean, I\'ll definitely come back here for another manicure', 'Спасибо за классный маникюр. Мастер помог подобрать подобрать интересный дизайн, который реализовал быстро и качественно. В салоне очень уютно и чисто, обязательно сюда вернусь за новым маникюром', 'Danke für die klasse Maniküre. Die Mitarbeiterin hat mir geholfen, ein interessantes Design auszuwählen, und hat es schnell und hochwertig umgesetzt. Im Salon ist es sehr gemütlich und sauber, ich komme auf jeden Fall für eine neue Maniküre wieder', 'Harika manikür için teşekkürler. Uzman ilginç bir tasarım seçmemde yardımcı oldu ve bunu hızlı ve kaliteli şekilde uyguladı. Salon çok sıcak ve temiz, yeni bir manikür için mutlaka geri geleceğim',
    0, '2026-07-29 00:00:00'),

(@user_olesya_podoynikova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21OS01XWlRUemRGVjJkWVVrZDVUMHRIUVhrMlJGRRAB',
    5, 'ru', 'давно искала хороший салон, все было прекрасно. атмосфера, приятный разговор, быстрая и качественная работа
спасибо большое, вернусь обязательно',
    'dugo sam tražila dobar salon, sve je bilo divno. atmosfera, prijatan razgovor, brz i kvalitetan rad
veliko hvala, sigurno se vraćam', 'дуго сам тражила добар салон, све је било дивно. атмосфера, пријатан разговор, брз и квалитетан рад
велико хвала, сигурно се враћам', 'i\'d been looking for a good salon for ages, everything was wonderful. the atmosphere, the nice conversation, fast and quality work
thank you so much, i\'ll definitely be back', 'давно искала хороший салон, все было прекрасно. атмосфера, приятный разговор, быстрая и качественная работа
спасибо большое, вернусь обязательно', 'ich habe lange nach einem guten salon gesucht, alles war wunderbar. die atmosphäre, das angenehme gespräch, schnelle und hochwertige arbeit
vielen dank, ich komme auf jeden fall wieder', 'uzun zamandır iyi bir salon arıyordum, her şey harikaydı. ortam, keyifli sohbet, hızlı ve kaliteli iş
çok teşekkürler, mutlaka tekrar geleceğim',
    0, '2026-07-29 00:00:00'),

(@user_gul_ustinova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xjNU9VcGZWVlZJY1VKWFZsVnNXVFpaTW1Kb2JrRRAB',
    5, 'ru', 'уже не первый раз записываюсь к мастеру светлане на наращивание, и каждый остаюсь в восторге💔
делает очень быстро, аккуратно и всегда учитывает все пожелания.
обязательно вернусь еще раз, это невероятно, спасибо за такую красоту!',
    'nije mi prvi put da zakazujem kod majstorice svetlane na nadogradnju, i svaki put ostajem oduševljena💔
radi veoma brzo, precizno i uvijek uzme u obzir sve želje.
sigurno ću se vratiti ponovo, ovo je nevjerovatno, hvala na takvoj ljepoti!', 'није ми први пут да заказујем код мајсторице светлане на надоградњу, и сваки пут остајем одушевљена💔
ради веома брзо, прецизно и увијек узме у обзир све жеље.
сигурно ћу се вратити поново, ово је невјероватно, хвала на таквој љепоти!', 'this isn\'t the first time i\'ve booked with svetlana for extensions, and every time i\'m blown away💔
she works very fast, precisely and always takes all my wishes into account.
i\'ll definitely come back again, it\'s incredible, thank you for such beauty!', 'уже не первый раз записываюсь к мастеру светлане на наращивание, и каждый остаюсь в восторге💔
делает очень быстро, аккуратно и всегда учитывает все пожелания.
обязательно вернусь еще раз, это невероятно, спасибо за такую красоту!', 'ich buche schon nicht zum ersten mal bei svetlana für nagelverlängerung, und jedes mal bin ich begeistert💔
sie arbeitet sehr schnell, sorgfältig und berücksichtigt immer alle wünsche.
ich komme auf jeden fall wieder, das ist unglaublich, danke für so viel schönheit!', 'svetlana\'ya protez tırnak için ilk kez gitmiyorum ve her seferinde hayran kalıyorum💔
çok hızlı, özenli çalışıyor ve her zaman bütün isteklerimi dikkate alıyor.
mutlaka tekrar geleceğim, inanılmaz, bu güzellik için teşekkürler!',
    0, '2026-07-29 00:00:00'),

(@user_yamiko_viv, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2poTFkweEhlV3hRVnpBMldtbFROV3h2T1ZWeFluYxAB',
    5, 'ru', 'прекрасная и быстрая работа, педикюр просто бомба, рада что сходила в этот салон',
    'predivan i brz rad, pedikir je prava bomba, sretna sam što sam otišla u ovaj salon', 'предиван и брз рад, педикир је права бомба, сретна сам што сам отишла у овај салон', 'wonderful and fast work, the pedicure is just a bomb, so glad i went to this salon', 'прекрасная и быстрая работа, педикюр просто бомба, рада что сходила в этот салон', 'wunderbare und schnelle arbeit, die pediküre ist einfach der wahnsinn, ich bin froh, dass ich in diesen salon gegangen bin', 'harika ve hızlı bir iş, pedikür tam bomba, bu salona gittiğime çok memnunum',
    0, '2026-07-29 00:00:00'),

(@user_dina_grubnik, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT214blUxaGZjRTVvT0VOd2QxRm5hWFpNU1dkVE5sRRAB',
    5, 'ru', 'Лучший маникюр в Черногории!',
    'Najbolji manikir u Crnoj Gori!', 'Најбољи маникир у Црној Гори!', 'The best manicure in Montenegro!', 'Лучший маникюр в Черногории!', 'Die beste Maniküre in Montenegro!', 'Karadağ\'daki en iyi manikür!',
    0, '2026-07-29 00:00:00'),

(@user_svetlana_chumakova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWd1pscFhWMU5ZVmxVNU5XOUxSVlJJVFhOeFRrRRAB',
    5, 'ru', 'Самый лучший маникюр и лучшее место❤️
Большое спасибо, очень люблю🫶🏻',
    'Najbolji manikir i najbolje mjesto❤️
Veliko hvala, mnogo vas volim🫶🏻', 'Најбољи маникир и најбоље мјесто❤️
Велико хвала, много вас волим🫶🏻', 'The very best manicure and the best place❤️
Thank you so much, I love it so much🫶🏻', 'Самый лучший маникюр и лучшее место❤️
Большое спасибо, очень люблю🫶🏻', 'Die allerbeste Maniküre und der beste Ort❤️
Vielen Dank, ich liebe euch sehr🫶🏻', 'En iyi manikür ve en iyi yer❤️
Çok teşekkürler, çok seviyorum🫶🏻',
    0, '2026-07-29 00:00:00'),

(@user_dinar, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25aMlJESnNSVmRvUVdack5sZHFUVzFpZUZwU1dFRRAB',
    5, 'ru', 'Обращался за помощью с ногтем к Подологу Анюте, пришел по рекомендации. За несколько посещений помогли решить проблему, быстро и профессионально. Особенно впечатлило отношение к чистоте и стерильности, для Черногории это находка. Помимо этого был приятно удивлен атмосфере в центре! Я пришел раньше приема, угостили вкусными напитками. Очень вежливый и внимательный персонал, однозначно рекомендую к посещению! Большое спасибо Камилле за оперативную запись!',
    'Obratio sam se podologu Anjuti zbog problema s noktom, došao sam po preporuci. U nekoliko posjeta pomogli su mi da riješim problem, brzo i profesionalno. Posebno me impresionirao odnos prema čistoći i sterilnosti, za Crnu Goru je to pravo otkriće. Osim toga, bio sam prijatno iznenađen atmosferom u centru! Došao sam prije termina i ponudili su mi ukusne napitke. Veoma ljubazno i pažljivo osoblje, bez razmišljanja preporučujem posjetu! Veliko hvala Kamili na brzom zakazivanju!', 'Обратио сам се подологу Ањути због проблема с ноктом, дошао сам по препоруци. У неколико посјета помогли су ми да ријешим проблем, брзо и професионално. Посебно ме импресионирао однос према чистоћи и стерилности, за Црну Гору је то право откриће. Осим тога, био сам пријатно изненађен атмосфером у центру! Дошао сам прије термина и понудили су ми укусне напитке. Веома љубазно и пажљиво особље, без размишљања препоручујем посјету! Велико хвала Камили на брзом заказивању!', 'I went to podiatrist Anjuta for help with my nail, I came on a recommendation. Over a few visits they helped solve the problem, quickly and professionally. I was especially impressed by the attitude to cleanliness and sterility - for Montenegro that\'s a real find. On top of that I was pleasantly surprised by the atmosphere at the centre! I arrived before my appointment and was treated to tasty drinks. Very polite and attentive staff, I definitely recommend a visit! Many thanks to Kamila for booking me in so promptly!', 'Обращался за помощью с ногтем к Подологу Анюте, пришел по рекомендации. За несколько посещений помогли решить проблему, быстро и профессионально. Особенно впечатлило отношение к чистоте и стерильности, для Черногории это находка. Помимо этого был приятно удивлен атмосфере в центре! Я пришел раньше приема, угостили вкусными напитками. Очень вежливый и внимательный персонал, однозначно рекомендую к посещению! Большое спасибо Камилле за оперативную запись!', 'Ich habe mich mit einem Nagelproblem an die Podologin Anjuta gewandt, ich kam auf Empfehlung. In einigen Sitzungen haben sie geholfen, das Problem zu lösen, schnell und professionell. Besonders beeindruckt hat mich der Umgang mit Reinlichkeit und Sterilität - für Montenegro ist das ein echter Fund. Außerdem war ich von der Atmosphäre im Zentrum angenehm überrascht! Ich kam vor meinem Termin an und wurde mit leckeren Getränken bewirtet. Sehr höfliches und aufmerksames Personal, einen Besuch kann ich absolut empfehlen! Vielen Dank an Kamila für die schnelle Terminvergabe!', 'Tırnağımdaki sorun için podolog Anjuta\'ya başvurdum, tavsiye üzerine gittim. Birkaç seansta sorunu hızlı ve profesyonel şekilde çözmeme yardım ettiler. Özellikle temizlik ve sterilizasyona verilen önem beni etkiledi, Karadağ için bu tam bir keşif. Ayrıca merkezdeki atmosfer beni hoş şekilde şaşırttı! Randevumdan önce geldim, bana lezzetli içecekler ikram ettiler. Çok nazik ve ilgili personel, ziyaret etmenizi kesinlikle tavsiye ederim! Hızlı randevu için Kamila\'ya çok teşekkürler!',
    0, '2026-07-29 00:00:00'),

(@user_kamila, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tzd1NtMW1NbHBUWlRWeVpWSmhTa1pDZFhobU5HYxAB',
    5, 'ru', 'Хожу в центр уже три года. Была на маникюре , педикюре, обращалась к Подологу, делала стельки у Ортопеда. Теперь не могу никуда ходить , после того как побывала в Айподо. Стерильность на высшем уровне, сервис лучше в Черногории не встречала. Рекомендую от всей души, уходить вам отсюда точно не захочется!',
    'Već tri godine dolazim u ovaj centar. Bila sam na manikiru, pedikiru, išla kod podologa, radila uloške kod ortopeda. Sada nigdje drugdje ne mogu da idem, nakon što sam bila u iPODO. Sterilnost je na najvišem nivou, bolju uslugu u Crnoj Gori nisam našla. Preporučujem od srca, odavde sigurno nećete htjeti da odete!', 'Већ три године долазим у овај центар. Била сам на маникиру, педикиру, ишла код подолога, радила улошке код ортопеда. Сада нигдје другдје не могу да идем, након што сам била у iPODO. Стерилност је на највишем нивоу, бољу услугу у Црној Гори нисам нашла. Препоручујем од срца, одавде сигурно нећете хтјети да одете!', 'I\'ve been going to this centre for three years now. I\'ve had manicures, pedicures, seen the podiatrist, had insoles made by the orthopaedist. Now I can\'t go anywhere else after being at iPODO. Sterility is at the highest level, I haven\'t come across better service in Montenegro. I recommend it with all my heart - you definitely won\'t want to leave!', 'Хожу в центр уже три года. Была на маникюре , педикюре, обращалась к Подологу, делала стельки у Ортопеда. Теперь не могу никуда ходить , после того как побывала в Айподо. Стерильность на высшем уровне, сервис лучше в Черногории не встречала. Рекомендую от всей души, уходить вам отсюда точно не захочется!', 'Ich gehe schon seit drei Jahren in dieses Zentrum. Ich war zur Maniküre, zur Pediküre, bei der Podologin und habe beim Orthopäden Einlagen machen lassen. Jetzt kann ich nirgendwo anders mehr hingehen, nachdem ich bei iPODO war. Die Sterilität ist auf höchstem Niveau, besseren Service habe ich in Montenegro nicht erlebt. Ich empfehle es von Herzen, Sie werden hier bestimmt nicht mehr weg wollen!', 'Üç yıldır bu merkeze gidiyorum. Manikür, pedikür yaptırdım, podologa gittim, ortopediste tabanlık yaptırdım. iPODO\'ya gittikten sonra artık başka hiçbir yere gidemiyorum. Sterilizasyon en üst düzeyde, Karadağ\'da daha iyi bir hizmetle karşılaşmadım. Tüm kalbimle tavsiye ederim, buradan ayrılmak istemeyeceksiniz!',
    0, '2026-07-29 00:00:00'),

(@user_aleksey_mikhaylov, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSURqdmRPWU9REAE',
    5, 'ru', 'Все очень понравилось, великолепный сервис и качество услуг, очень доволен маникюром и педикюром👍
Отдельное спасибо Подологу, профессионал своего дела, восстанавливает мои убитые ногти уже пол года, динамика на ура👏',
    'Sve mi se veoma svidjelo, sjajna usluga i kvalitet, veoma sam zadovoljan manikirom i pedikirom👍
Posebno hvala podologu, pravi profesionalac, već pola godine obnavlja moje uništene nokte, napredak je odličan👏', 'Све ми се веома свидјело, сјајна услуга и квалитет, веома сам задовољан маникиром и педикиром👍
Посебно хвала подологу, прави професионалац, већ пола године обнавља моје уништене нокте, напредак је одличан👏', 'I liked everything a lot, superb service and quality of treatments, very happy with the manicure and pedicure👍
Special thanks to the podiatrist, a true professional, she\'s been restoring my wrecked nails for half a year now and the progress is great👏', 'Все очень понравилось, великолепный сервис и качество услуг, очень доволен маникюром и педикюром👍
Отдельное спасибо Подологу, профессионал своего дела, восстанавливает мои убитые ногти уже пол года, динамика на ура👏', 'Mir hat alles sehr gefallen, hervorragender Service und Qualität der Leistungen, ich bin mit Maniküre und Pediküre sehr zufrieden👍
Besonderen Dank an die Podologin, eine echte Profi, sie baut meine ruinierten Nägel schon seit einem halben Jahr wieder auf, die Entwicklung ist top👏', 'Her şeyi çok beğendim, muhteşem hizmet ve kaliteli uygulamalar, manikür ve pedikürden çok memnunum👍
Podologa ayrıca teşekkürler, işinin gerçek bir profesyoneli, yarım yıldır mahvolmuş tırnaklarımı onarıyor, gidişat harika👏',
    0, '2026-07-29 00:00:00'),

(@user_anne, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT210eVZTMUxNMHh1VTFSclgwaFVVa2xIYzA5WmMxRRAB',
    1, 'en', 'Did my nails, air got under so they clipped off after 11 days. I went back. I drove 1 hour to get there, there was a huge amount of traffic so I was 15min late (which is my fault) but they were not willing to help or make an exception. I will never get back as I’d like to get treated right as a customer.',
    'Uradili su mi nokte, ušao je vazduh ispod pa su se odvalili nakon 11 dana. Vratila sam se. Vozila sam sat vremena da stignem tamo, bila je ogromna gužva u saobraćaju pa sam zakasnila 15 minuta (što je moja greška), ali nisu bili spremni da pomognu ni da naprave izuzetak. Nikad se više neću vratiti, jer želim da se prema meni kao klijentu ophode kako treba.', 'Урадили су ми нокте, ушао је ваздух испод па су се одвалили након 11 дана. Вратила сам се. Возила сам сат времена да стигнем тамо, била је огромна гужва у саобраћају па сам закаснила 15 минута (што је моја грешка), али нису били спремни да помогну ни да направе изузетак. Никад се више нећу вратити, јер желим да се према мени као клијенту опходе како треба.', 'Did my nails, air got under so they clipped off after 11 days. I went back. I drove 1 hour to get there, there was a huge amount of traffic so I was 15min late (which is my fault) but they were not willing to help or make an exception. I will never get back as I’d like to get treated right as a customer.', 'Сделали мне ногти, под них попал воздух, и через 11 дней они отвалились. Я приехала снова. Я ехала час, чтобы добраться, были огромные пробки, поэтому я опоздала на 15 минут (это моя вина), но они не захотели ни помочь, ни сделать исключение. Больше никогда туда не вернусь, потому что хочу, чтобы со мной как с клиентом обращались нормально.', 'Sie haben meine Nägel gemacht, es kam Luft darunter, und nach 11 Tagen sind sie abgeplatzt. Ich bin wieder hingefahren. Ich hatte eine Stunde Fahrt, es war enorm viel Verkehr, deshalb war ich 15 Minuten zu spät (was meine Schuld ist), aber sie waren nicht bereit zu helfen oder eine Ausnahme zu machen. Ich komme nie wieder, denn ich möchte als Kundin anständig behandelt werden.', 'Tırnaklarımı yaptılar, altına hava girdi ve 11 gün sonra kalktılar. Tekrar gittim. Oraya varmak için bir saat araba kullandım, trafik çok yoğundu, bu yüzden 15 dakika geciktim (bu benim hatam), ama ne yardım etmeye ne de bir istisna yapmaya niyetliydiler. Bir daha asla gitmem, çünkü müşteri olarak bana doğru şekilde davranılmasını isterim.',
    0, '2026-07-29 00:00:00'),

(@user_olga_burnashova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s1NGVYQmxWVFZOYkhOSVZWRlhNMlZoYW5KaVIyYxAB',
    5, 'ru', 'Хочу выразить огромную благодарность мастеру-технологу Софии! Очень профессиональный и внимательный специалист. Маникюр и педикюр выполнены безупречно — ногти получились красивыми, аккуратными и именно такими, как я хотела.

София не только отлично знает свое дело, но и очень приятный, доброжелательный человек. Во время процедуры чувствовала себя комфортно и спокойно. Отдельное спасибо за полезные рекомендации по уходу за ногтями и кожей, которые помогут сохранить результат надолго.

Очень рада, что попала именно к Софии. Однозначно рекомендую всем, кто ценит качество, профессионализм и душевное отношение к клиентам!',
    'Želim da izrazim ogromnu zahvalnost majstoru-tehnologu Sofiji! Vrlo profesionalan i pažljiv stručnjak. Manikir i pedikir su urađeni besprijekorno — nokti su ispali lijepi, uredni i baš onakvi kakve sam željela.

Sofija ne samo da odlično poznaje svoj posao, već je i vrlo prijatna, ljubazna osoba. Tokom procedure sam se osjećala udobno i mirno. Posebno hvala na korisnim savjetima za njegu noktiju i kože, koji će pomoći da rezultat potraje dugo.

Vrlo sam sretna što sam došla upravo kod Sofije. Bez sumnje preporučujem svima koji cijene kvalitet, profesionalizam i srdačan odnos prema klijentima!', 'Желим да изразим огромну захвалност мајстору-технологу Софији! Врло професионалан и пажљив стручњак. Маникир и педикир су урађени беспријекорно — нокти су испали лијепи, уредни и баш онакви какве сам жељела.

Софија не само да одлично познаје свој посао, већ је и врло пријатна, љубазна особа. Током процедуре сам се осјећала удобно и мирно. Посебно хвала на корисним савјетима за његу ноктију и коже, који ће помоћи да резултат потраје дуго.

Врло сам сретна што сам дошла управо код Софије. Без сумње препоручујем свима који цијене квалитет, професионализам и срдачан однос према клијентима!', 'I want to express my huge gratitude to master technician Sofija! A very professional and attentive specialist. The manicure and pedicure were done flawlessly — my nails turned out beautiful, neat and exactly the way I wanted.

Sofija not only knows her craft perfectly, she is also a very pleasant, kind person. During the procedure I felt comfortable and relaxed. Special thanks for the useful recommendations on nail and skin care that will help keep the result for a long time.

I\'m so glad I ended up with Sofija. I definitely recommend her to everyone who values quality, professionalism and a warm attitude towards clients!', 'Хочу выразить огромную благодарность мастеру-технологу Софии! Очень профессиональный и внимательный специалист. Маникюр и педикюр выполнены безупречно — ногти получились красивыми, аккуратными и именно такими, как я хотела.

София не только отлично знает свое дело, но и очень приятный, доброжелательный человек. Во время процедуры чувствовала себя комфортно и спокойно. Отдельное спасибо за полезные рекомендации по уходу за ногтями и кожей, которые помогут сохранить результат надолго.

Очень рада, что попала именно к Софии. Однозначно рекомендую всем, кто ценит качество, профессионализм и душевное отношение к клиентам!', 'Ich möchte der Meistertechnologin Sofija meinen riesigen Dank aussprechen! Eine sehr professionelle und aufmerksame Fachkraft. Maniküre und Pediküre wurden einwandfrei ausgeführt — die Nägel sind schön, gepflegt und genau so geworden, wie ich es mir gewünscht habe.

Sofija versteht ihr Handwerk nicht nur ausgezeichnet, sie ist auch ein sehr angenehmer, freundlicher Mensch. Während der Behandlung habe ich mich wohl und ruhig gefühlt. Ein besonderes Dankeschön für die hilfreichen Empfehlungen zur Nagel- und Hautpflege, die dabei helfen, das Ergebnis lange zu erhalten.

Ich bin sehr froh, dass ich gerade bei Sofija gelandet bin. Ich empfehle sie absolut allen, die Qualität, Professionalität und eine herzliche Einstellung zu den Kunden schätzen!', 'Uzman teknisyen Sofija\'ya çok büyük teşekkürlerimi sunmak istiyorum! Son derece profesyonel ve özenli bir uzman. Manikür ve pedikür kusursuz yapıldı — tırnaklarım güzel, düzgün ve tam istediğim gibi oldu.

Sofija sadece işini mükemmel bilmiyor, aynı zamanda çok hoş ve güler yüzlü bir insan. İşlem sırasında kendimi rahat ve huzurlu hissettim. Sonucun uzun süre kalmasına yardımcı olacak tırnak ve cilt bakımı önerileri için ayrıca teşekkür ederim.

Tam da Sofija\'ya denk geldiğim için çok memnunum. Kaliteye, profesyonelliğe ve müşterilere içten yaklaşıma değer veren herkese kesinlikle tavsiye ediyorum!',
    0, '2026-07-27 00:00:00'),

(@user_olga_trofimova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ3M29xbExBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-27 00:00:00'),

(@user_uladzislau_sasnouski, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21sQmRUbHJUVFZCV0hwT0xVUXlSbkJOY1MwelQyYxAB',
    1, 'en', 'I visited this center because the nails on my hands had gradually started separating from the nail beds. My first impression was positive: the premises were clean, tidy, and nicely designed. Initially, I believed I had found a serious, specialized podiatry center. However, after three appointments and four months of following their prescribed treatment, my opinion changed completely.

The treatment did not produce any positive results. My condition continued to worsen, and the nail separation became increasingly severe. As I later discovered, the diagnoses and suggested causes provided by the center did not correspond to the actual condition I had.

It was also impossible to undergo a proper examination at the center itself. As far as I was informed, they do not even have a dermatoscope, and fungal tests are sent to an external laboratory. Although such a test normally does not take long, I had to repeatedly request the results for two weeks before finally receiving them.

The main part of the prescribed treatment was essentially a 5 ml bottle of nail oil, which they sold to me for €50. I later found the same product online for approximately €40 for a 30 ml bottle.

In total, I spent around €200 on appointments and followed the center’s recommendations for four months, but the only result was further deterioration. I eventually visited a genuinely specialized podology center in another country. There, a qualified specialist performed the necessary examinations, immediately identified the correct diagnosis, and prescribed appropriate treatment. Within just one month, I began to see the first noticeable improvements.

Based on my personal experience, this place appears to be more of a beauty or manicure salon offering some podiatry-related services than a fully equipped medical center capable of diagnosing and treating complex nail conditions. The cleanliness and interior design are certainly good, but in my case, the quality of the diagnostics and the effectiveness of the prescribed treatment were extremely disappointing.',
    'Došao sam u ovaj centar jer su mi se nokti na rukama postepeno počeli odvajati od nokatnog ležišta. Prvi impresija je bila pozitivna: prostor je bio čist, uredan i lijepo uređen. Na početku sam vjerovao da sam pronašao ozbiljan, specijalizovan podološki centar. Međutim, nakon tri pregleda i četiri mjeseca praćenja liječenja koje su mi propisali, moje mišljenje se potpuno promijenilo.

Liječenje nije dalo nikakve pozitivne rezultate. Moje stanje se i dalje pogoršavalo, a odvajanje nokta je postajalo sve teže. Kako sam kasnije otkrio, dijagnoze i navedeni uzroci koje mi je centar dao nisu odgovarali stvarnom stanju koje sam imao.

Takođe je bilo nemoguće obaviti pravi pregled u samom centru. Prema onome što su mi rekli, oni nemaju ni dermatoskop, a testovi na gljivice se šalju u vanjsku laboratoriju. Iako takav test obično ne traje dugo, morao sam dvije nedjelje uporno tražiti rezultate prije nego što sam ih konačno dobio.

Glavni dio propisanog liječenja bila je u suštini bočica ulja za nokte od 5 ml, koju su mi prodali za 50 €. Isti proizvod sam kasnije našao na internetu za oko 40 € u bočici od 30 ml.

Ukupno sam potrošio oko 200 € na preglede i četiri mjeseca se držao preporuka centra, a jedini rezultat bilo je dalje pogoršanje. Na kraju sam otišao u zaista specijalizovan podološki centar u drugoj zemlji. Tamo je kvalifikovan stručnjak obavio potrebne preglede, odmah postavio ispravnu dijagnozu i propisao odgovarajuće liječenje. Već nakon samo jednog mjeseca počeo sam da vidim prva vidljiva poboljšanja.

Na osnovu mog ličnog iskustva, ovo mjesto izgleda više kao kozmetički ili manikir salon koji nudi neke usluge povezane s podologijom, a ne kao potpuno opremljen medicinski centar sposoban da dijagnostikuje i liječi složena oboljenja noktiju. Čistoća i uređenje interijera su svakako dobri, ali u mom slučaju kvalitet dijagnostike i efikasnost propisanog liječenja bili su izuzetno razočaravajući.', 'Дошао сам у овај центар јер су ми се нокти на рукама постепено почели одвајати од нокатног лежишта. Први импресија је била позитивна: простор је био чист, уредан и лијепо уређен. На почетку сам вјеровао да сам пронашао озбиљан, специјализован подолошки центар. Међутим, након три прегледа и четири мјесеца праћења лијечења које су ми прописали, моје мишљење се потпуно промијенило.

Лијечење није дало никакве позитивне резултате. Моје стање се и даље погоршавало, а одвајање нокта је постајало све теже. Како сам касније открио, дијагнозе и наведени узроци које ми је центар дао нису одговарали стварном стању које сам имао.

Такође је било немогуће обавити прави преглед у самом центру. Према ономе што су ми рекли, они немају ни дерматоскоп, а тестови на гљивице се шаљу у вањску лабораторију. Иако такав тест обично не траје дуго, морао сам двије недјеље упорно тражити резултате прије него што сам их коначно добио.

Главни дио прописаног лијечења била је у суштини бочица уља за нокте од 5 ml, коју су ми продали за 50 €. Исти производ сам касније нашао на интернету за око 40 € у бочици од 30 ml.

Укупно сам потрошио око 200 € на прегледе и четири мјесеца се држао препорука центра, а једини резултат било је даље погоршање. На крају сам отишао у заиста специјализован подолошки центар у другој земљи. Тамо је квалификован стручњак обавио потребне прегледе, одмах поставио исправну дијагнозу и прописао одговарајуће лијечење. Већ након само једног мјесеца почео сам да видим прва видљива побољшања.

На основу мог личног искуства, ово мјесто изгледа више као козметички или маникир салон који нуди неке услуге повезане с подологијом, а не као потпуно опремљен медицински центар способан да дијагностикује и лијечи сложена обољења ноктију. Чистоћа и уређење интеријера су свакако добри, али у мом случају квалитет дијагностике и ефикасност прописаног лијечења били су изузетно разочаравајући.', 'I visited this center because the nails on my hands had gradually started separating from the nail beds. My first impression was positive: the premises were clean, tidy, and nicely designed. Initially, I believed I had found a serious, specialized podiatry center. However, after three appointments and four months of following their prescribed treatment, my opinion changed completely.

The treatment did not produce any positive results. My condition continued to worsen, and the nail separation became increasingly severe. As I later discovered, the diagnoses and suggested causes provided by the center did not correspond to the actual condition I had.

It was also impossible to undergo a proper examination at the center itself. As far as I was informed, they do not even have a dermatoscope, and fungal tests are sent to an external laboratory. Although such a test normally does not take long, I had to repeatedly request the results for two weeks before finally receiving them.

The main part of the prescribed treatment was essentially a 5 ml bottle of nail oil, which they sold to me for €50. I later found the same product online for approximately €40 for a 30 ml bottle.

In total, I spent around €200 on appointments and followed the center’s recommendations for four months, but the only result was further deterioration. I eventually visited a genuinely specialized podology center in another country. There, a qualified specialist performed the necessary examinations, immediately identified the correct diagnosis, and prescribed appropriate treatment. Within just one month, I began to see the first noticeable improvements.

Based on my personal experience, this place appears to be more of a beauty or manicure salon offering some podiatry-related services than a fully equipped medical center capable of diagnosing and treating complex nail conditions. The cleanliness and interior design are certainly good, but in my case, the quality of the diagnostics and the effectiveness of the prescribed treatment were extremely disappointing.', 'Я обратился в этот центр, потому что ногти на руках постепенно начали отслаиваться от ногтевого ложа. Первое впечатление было положительным: помещение чистое, аккуратное и красиво оформленное. Сначала я думал, что нашёл серьёзный, специализированный подологический центр. Однако после трёх приёмов и четырёх месяцев назначенного лечения моё мнение полностью изменилось.

Лечение не дало никаких положительных результатов. Моё состояние продолжало ухудшаться, а отслоение ногтя становилось всё сильнее. Как я позже выяснил, диагнозы и предполагаемые причины, которые назвал центр, не соответствовали моему реальному состоянию.

Пройти нормальное обследование в самом центре тоже было невозможно. Насколько мне сообщили, у них нет даже дерматоскопа, а анализы на грибок отправляются во внешнюю лабораторию. Хотя такой анализ обычно делается недолго, мне приходилось две недели настойчиво требовать результаты, прежде чем я их наконец получил.

Основной частью назначенного лечения была, по сути, бутылочка масла для ногтей объёмом 5 мл, которую мне продали за 50 €. Позже я нашёл тот же продукт в интернете примерно за 40 € за бутылочку 30 мл.

В общей сложности я потратил около 200 € на приёмы и четыре месяца следовал рекомендациям центра, но единственным результатом стало дальнейшее ухудшение. В итоге я обратился в действительно специализированный подологический центр в другой стране. Там квалифицированный специалист провёл необходимые обследования, сразу поставил правильный диагноз и назначил подходящее лечение. Уже через месяц я начал замечать первые ощутимые улучшения.

Исходя из личного опыта, это место больше похоже на салон красоты или маникюрный салон, оказывающий некоторые услуги, связанные с подологией, чем на полностью оснащённый медицинский центр, способный диагностировать и лечить сложные заболевания ногтей. Чистота и оформление интерьера действительно хороши, но в моём случае качество диагностики и эффективность назначенного лечения оказались крайне разочаровывающими.', 'Ich bin in dieses Zentrum gegangen, weil sich meine Fingernägel allmählich vom Nagelbett zu lösen begannen. Der erste Eindruck war positiv: die Räume waren sauber, ordentlich und schön gestaltet. Zunächst glaubte ich, ein seriöses, spezialisiertes Podologie-Zentrum gefunden zu haben. Nach drei Terminen und vier Monaten der von ihnen verordneten Behandlung hat sich meine Meinung jedoch vollständig geändert.

Die Behandlung brachte keinerlei positive Ergebnisse. Mein Zustand verschlechterte sich weiter und die Nagelablösung wurde immer schwerer. Wie ich später herausfand, entsprachen die Diagnosen und die vom Zentrum genannten Ursachen nicht meinem tatsächlichen Zustand.

Eine ordentliche Untersuchung war im Zentrum selbst ebenfalls nicht möglich. Nach den Informationen, die ich erhielt, haben sie nicht einmal ein Dermatoskop, und Pilztests werden an ein externes Labor geschickt. Obwohl ein solcher Test normalerweise nicht lange dauert, musste ich die Ergebnisse zwei Wochen lang immer wieder anfordern, bevor ich sie endlich bekam.

Der Hauptteil der verordneten Behandlung war im Wesentlichen ein 5-ml-Fläschchen Nagelöl, das sie mir für 50 € verkauft haben. Später fand ich dasselbe Produkt online für etwa 40 € in einer 30-ml-Flasche.

Insgesamt habe ich rund 200 € für Termine ausgegeben und vier Monate lang die Empfehlungen des Zentrums befolgt, doch das einzige Ergebnis war eine weitere Verschlechterung. Schließlich war ich in einem wirklich spezialisierten Podologie-Zentrum in einem anderen Land. Dort führte eine qualifizierte Fachkraft die notwendigen Untersuchungen durch, stellte sofort die richtige Diagnose und verordnete eine passende Behandlung. Schon innerhalb eines Monats sah ich die ersten deutlichen Verbesserungen.

Nach meiner persönlichen Erfahrung wirkt dieser Ort mehr wie ein Kosmetik- oder Nagelstudio, das einige podologische Leistungen anbietet, als wie ein vollständig ausgestattetes medizinisches Zentrum, das komplexe Nagelerkrankungen diagnostizieren und behandeln kann. Sauberkeit und Innenausstattung sind sicherlich gut, aber in meinem Fall waren die Qualität der Diagnostik und die Wirksamkeit der verordneten Behandlung äußerst enttäuschend.', 'Bu merkeze, el tırnaklarım giderek tırnak yatağından ayrılmaya başladığı için gittim. İlk izlenimim olumluydu: mekân temiz, düzenli ve hoş tasarlanmıştı. Başlangıçta ciddi, uzmanlaşmış bir podoloji merkezi bulduğuma inanmıştım. Ancak üç randevu ve önerdikleri tedaviyi uyguladığım dört aydan sonra fikrim tamamen değişti.

Tedavi hiçbir olumlu sonuç vermedi. Durumum kötüleşmeye devam etti, tırnak ayrılması giderek ağırlaştı. Sonradan anladığım kadarıyla, merkezin verdiği teşhisler ve öne sürdüğü nedenler gerçek durumumla hiç örtüşmüyordu.

Merkezin kendisinde düzgün bir muayene yapmak da mümkün değildi. Bana söylendiği kadarıyla dermatoskopları bile yok, mantar testleri ise dış laboratuvara gönderiliyor. Böyle bir test normalde uzun sürmemesine rağmen, sonuçları alabilmek için iki hafta boyunca ısrarla istemek zorunda kaldım.

Önerilen tedavinin ana kısmı esasen 5 ml\'lik bir tırnak yağı şişesiydi ve bunu bana 50 €\'ya sattılar. Aynı ürünü daha sonra internette 30 ml\'lik şişesi yaklaşık 40 €\'ya buldum.

Toplamda randevulara yaklaşık 200 € harcadım ve dört ay boyunca merkezin önerilerini uyguladım, ancak tek sonuç durumun daha da kötüleşmesi oldu. Sonunda başka bir ülkedeki gerçekten uzmanlaşmış bir podoloji merkezine gittim. Orada nitelikli bir uzman gerekli muayeneleri yaptı, doğru teşhisi hemen koydu ve uygun tedaviyi verdi. Sadece bir ay içinde ilk belirgin iyileşmeleri görmeye başladım.

Kendi deneyimime dayanarak, bu yer karmaşık tırnak hastalıklarını teşhis ve tedavi edebilecek tam donanımlı bir tıbbi merkezden çok, podolojiyle ilgili bazı hizmetler sunan bir güzellik ya da manikür salonu gibi görünüyor. Temizlik ve iç tasarım kesinlikle iyi, ama benim durumumda teşhisin kalitesi ve önerilen tedavinin etkinliği son derece hayal kırıklığı yarattı.',
    0, '2026-07-27 00:00:00'),

(@user_ulyana_kovalevska, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUREbWZualdREAE',
    5, 'uk', 'Дякую  як завжди все бездоганно, все сподобалось 👍🏻',
    'Hvala, kao i uvijek sve je besprijekorno, sve mi se svidjelo 👍🏻', 'Хвала, као и увијек све је беспријекорно, све ми се свидјело 👍🏻', 'Thank you, as always everything was flawless, I loved it all 👍🏻', 'Спасибо, как всегда всё безупречно, всё понравилось 👍🏻', 'Danke, wie immer alles einwandfrei, mir hat alles gefallen 👍🏻', 'Teşekkürler, her zaman olduğu gibi her şey kusursuz, hepsi çok hoşuma gitti 👍🏻',
    0, '2026-07-27 00:00:00'),

(@user_marina_rabrenovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoU1NtWnNPRFZuY2tscFpFTmhhR2hIWkhKcE9XYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-27 00:00:00'),

(@user_svetlana_zolotareva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pacmFrWnlhR3MzVW5ReVUzaHhkRzgyUjJadVJuYxAB',
    5, 'ru', 'Огромное спасибо Светлане за маникюр и педикюр. Светлана - очень професиональный и внимательный мастер, каких мало. От всей души рекомендую.',
    'Ogromno hvala Svetlani za manikir i pedikir. Svetlana je vrlo profesionalan i pažljiv majstor, kakvih je malo. Od srca preporučujem.', 'Огромно хвала Светлани за маникир и педикир. Светлана је врло професионалан и пажљив мајстор, каквих је мало. Од срца препоручујем.', 'Huge thanks to Svetlana for the manicure and pedicure. Svetlana is a very professional and attentive specialist, and there are few like her. I wholeheartedly recommend her.', 'Огромное спасибо Светлане за маникюр и педикюр. Светлана - очень професиональный и внимательный мастер, каких мало. От всей души рекомендую.', 'Riesigen Dank an Svetlana für Maniküre und Pediküre. Svetlana ist eine sehr professionelle und aufmerksame Fachkraft, wie es nur wenige gibt. Ich empfehle sie von ganzem Herzen.', 'Manikür ve pedikür için Svetlana\'ya çok teşekkür ederim. Svetlana çok profesyonel ve özenli bir uzman, öylesi az bulunur. Tüm kalbimle tavsiye ediyorum.',
    0, '2026-07-27 00:00:00'),

(@user_tanja_perovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURmaDZhbXlBRRAB',
    5, 'en', 'Great service 🧡 …',
    'Odlična usluga 🧡 …', 'Одлична услуга 🧡 …', 'Great service 🧡 …', 'Отличный сервис 🧡 …', 'Toller Service 🧡 …', 'Harika hizmet 🧡 …',
    0, '2026-07-20 00:00:00'),

(@user_anastasia_luta, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUREeElDbjRRRRAB',
    5, 'ru', 'Такой салон уникален в Будве. Высокое качество услуг и великолепный сервис. Вы лучшие❤️',
    'Takav salon je jedinstven u Budvi. Visok kvalitet usluga i sjajan servis. Vi ste najbolji❤️', 'Такав салон је јединствен у Будви. Висок квалитет услуга и сјајан сервис. Ви сте најбољи❤️', 'A salon like this is unique in Budva. High quality treatments and superb service. You\'re the best❤️', 'Такой салон уникален в Будве. Высокое качество услуг и великолепный сервис. Вы лучшие❤️', 'So ein Salon ist einzigartig in Budva. Hohe Qualität der Leistungen und großartiger Service. Ihr seid die Besten❤️', 'Böyle bir salon Budva\'da tek. Hizmet kalitesi yüksek, servis muhteşem. Siz en iyisisiniz❤️',
    0, '2026-07-20 00:00:00'),

(@user_nikoletta_petridou, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkQ1ltOHpVR3haVVU1eFUyTlhVWEV4TFdsb05WRRAB',
    5, 'en', 'Such a great experience, the lady, Maria that did my nails is an expert. The place is so clean and well organised! Thank you so much!',
    'Baš sjajno iskustvo, gospođa Maria, koja mi je radila nokte, prava je stručnjakinja. Mjesto je tako čisto i dobro organizovano! Hvala vam puno!', 'Баш сјајно искуство, госпођа Maria, која ми је радила нокте, права је стручњакиња. Мјесто је тако чисто и добро организовано! Хвала вам пуно!', 'Such a great experience, the lady, Maria that did my nails is an expert. The place is so clean and well organised! Thank you so much!', 'Просто отличный опыт, Maria, которая делала мне ногти, — настоящий профессионал. Место очень чистое и хорошо организованное! Большое спасибо!', 'Was für eine großartige Erfahrung, die Dame, Maria, die meine Nägel gemacht hat, ist eine Expertin. Der Ort ist so sauber und gut organisiert! Vielen Dank!', 'Gerçekten harika bir deneyimdi, tırnaklarımı yapan Maria tam bir uzman. Mekân çok temiz ve düzenli! Çok teşekkür ederim!',
    0, '2026-07-13 00:00:00'),

(@user_jelena_perovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNEajVLdVdBEAE',
    5, 'ru', 'Прекрасный сервис , супер профессионалы,
Невероятная атмосфера релакса',
    'Prekrasan servis , super profesionalci,
Nevjerovatna atmosfera relaksacije', 'Прекрасан сервис , супер професионалци,
Невјероватна атмосфера релаксације', 'Wonderful service , super professionals,
An incredible atmosphere of relaxation', 'Прекрасный сервис , супер профессионалы,
Невероятная атмосфера релакса', 'Wunderbarer Service , super Profis,
Eine unglaubliche Atmosphäre der Entspannung', 'Harika bir servis , süper profesyoneller,
İnanılmaz bir dinlenme atmosferi',
    0, '2026-07-13 00:00:00'),

(@user_ekaterina_khoteicheva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tOeGJFY3dlVzV2TW1sR1lYTTNSR1JpY1dVNGJFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-06 00:00:00'),

(@user_ludmila_levchik, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUM3XzZ5M0hREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-03 00:00:00'),

(@user_mila_bejatovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkVWVrSlhVbGRrZWtSQ2N6WkhiVUpFV2t0TGVsRRAB',
    5, 'en', 'I had a fungal nail infection and Dr.  treated it with great care and professionalism. The doctor explained the treatment clearly, answered all my questions, and I have seen significant improvement in my nail condition. I appreciate the patience and expertise provided throughout the treatment. I highly recommend this location to anyone dealing with nail fungus or similar conditions.',
    'Imao sam gljivičnu infekciju nokta i dr.  je to liječio s velikom pažnjom i profesionalizmom. Ljekar mi je jasno objasnio liječenje, odgovorio na sva moja pitanja, a stanje mojih noktiju se značajno popravilo. Cijenim strpljenje i stručnost koje sam dobio tokom cijelog liječenja. Toplo preporučujem ovo mjesto svima koji imaju gljivice na noktima ili slična stanja.', 'Имао сам гљивичну инфекцију нокта и др.  је то лијечио с великом пажњом и професионализмом. Љекар ми је јасно објаснио лијечење, одговорио на сва моја питања, а стање мојих ноктију се значајно поправило. Цијеним стрпљење и стручност које сам добио током цијелог лијечења. Топло препоручујем ово мјесто свима који имају гљивице на ноктима или слична стања.', 'I had a fungal nail infection and Dr.  treated it with great care and professionalism. The doctor explained the treatment clearly, answered all my questions, and I have seen significant improvement in my nail condition. I appreciate the patience and expertise provided throughout the treatment. I highly recommend this location to anyone dealing with nail fungus or similar conditions.', 'У меня был грибок ногтей, и доктор  лечил его с большой заботой и профессионализмом. Врач понятно объяснил лечение, ответил на все мои вопросы, и состояние ногтей значительно улучшилось. Ценю терпение и профессионализм на протяжении всего лечения. Очень рекомендую это место всем, кто столкнулся с грибком ногтей или похожими проблемами.', 'Ich hatte eine Nagelpilzinfektion, und Dr.  hat sie mit großer Sorgfalt und Professionalität behandelt. Der Arzt hat die Behandlung klar erklärt, alle meine Fragen beantwortet, und der Zustand meiner Nägel hat sich deutlich verbessert. Ich schätze die Geduld und Fachkompetenz, die mir während der gesamten Behandlung zuteilwurden. Ich empfehle diesen Ort allen wärmstens, die mit Nagelpilz oder ähnlichen Beschwerden zu tun haben.', 'Tırnak mantarı enfeksiyonum vardı ve Dr.  bunu büyük bir özenle ve profesyonellikle tedavi etti. Doktor tedaviyi net bir şekilde anlattı, bütün sorularımı yanıtladı ve tırnaklarımın durumunda belirgin bir düzelme gördüm. Tedavi süresince gösterilen sabrı ve uzmanlığı takdir ediyorum. Tırnak mantarı ya da benzer sorunlarla uğraşan herkese burayı gönülden tavsiye ederim.',
    0, '2026-07-03 00:00:00'),

(@user_aleksandra_andric, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tkeGNWQmlZbXBtZWprNVV6WnplRUl6TTNkUlpYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-03 00:00:00'),

(@user_elena_galuchko, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSURfbi1lQWFREAE',
    5, 'ru', 'Светлана отличный мастер и приятный человек. Маникюр красивый и профессиональный',
    'Svetlana je odličan majstor i prijatna osoba. Manikir je lijep i profesionalno urađen', 'Светлана је одличан мајстор и пријатна особа. Маникир је лијеп и професионално урађен', 'Svetlana is an excellent specialist and a lovely person. The manicure is beautiful and professionally done', 'Светлана отличный мастер и приятный человек. Маникюр красивый и профессиональный', 'Svetlana ist eine ausgezeichnete Fachkraft und ein angenehmer Mensch. Die Maniküre ist schön und professionell gemacht', 'Svetlana harika bir uzman ve çok hoş bir insan. Manikür güzel ve profesyonelce yapılmış',
    0, '2026-07-03 00:00:00'),

(@user_ala_drighenici, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4SGJXTTNiMlZRWDFSS2VXZHNlRmw0YkV4SFFVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-03 00:00:00'),

(@user_elena, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGUGEzaFlOVmRJUmxWa1gyMVllVUoyUnpOYVFXYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-03 00:00:00'),

(@user_tatyana_bogdanova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tKRVdsTnBVazVYUm5wWlFYcEVjbmhMVjNodWNGRRAB',
    5, 'ru', 'Спасибо за впечатление!🌟Хороший салон!🎉Очень понравился педикюр, мастер - Наталия, очень обходительна и профессионал своего дела! Посещаю салон 5 лет,  мастера хорошо выполняют маникюр и педикюр. Приятный администратор и весь персонал. Бонус: кофе, чай, вкусняшки!🥰 Желаю салону процветания, развития, благодарных клиентов 💖',
    'Hvala na doživljaju!🌟Dobar salon!🎉Pedikir mi se vrlo svidio, majstorica - Natalija, veoma ljubazna i pravi profesionalac u svom poslu! Dolazim u salon već 5 godina, majstori odlično rade manikir i pedikir. Prijatna administratorka i cijelo osoblje. Bonus: kafa, čaj, slatkiši!🥰 Želim salonu napredak, razvoj i zahvalne klijente 💖', 'Хвала на доживљају!🌟Добар салон!🎉Педикир ми се врло свидио, мајсторица - Наталија, веома љубазна и прави професионалац у свом послу! Долазим у салон већ 5 година, мајстори одлично раде маникир и педикир. Пријатна администраторка и цијело особље. Бонус: кафа, чај, слаткиши!🥰 Желим салону напредак, развој и захвалне клијенте 💖', 'Thank you for the experience!🌟A great salon!🎉I really loved the pedicure, my specialist was Natalija, so courteous and a true professional! I\'ve been coming to this salon for 5 years, the specialists do manicures and pedicures really well. Lovely receptionist and all the staff. Bonus: coffee, tea, treats!🥰 I wish the salon prosperity, growth and grateful clients 💖', 'Спасибо за впечатление!🌟Хороший салон!🎉Очень понравился педикюр, мастер - Наталия, очень обходительна и профессионал своего дела! Посещаю салон 5 лет,  мастера хорошо выполняют маникюр и педикюр. Приятный администратор и весь персонал. Бонус: кофе, чай, вкусняшки!🥰 Желаю салону процветания, развития, благодарных клиентов 💖', 'Danke für das Erlebnis!🌟Ein guter Salon!🎉Die Pediküre hat mir sehr gefallen, meine Fachkraft war Natalija, sehr zuvorkommend und eine echte Profi in ihrem Fach! Ich gehe seit 5 Jahren in diesen Salon, die Fachkräfte machen Maniküre und Pediküre wirklich gut. Angenehme Empfangsdame und das ganze Team. Bonus: Kaffee, Tee, Leckereien!🥰 Ich wünsche dem Salon Erfolg, Wachstum und dankbare Kunden 💖', 'Bu deneyim için teşekkürler!🌟Güzel bir salon!🎉Pedikürü çok sevdim, uzmanım Natalija\'ydı, son derece nazik ve işinin gerçek bir profesyoneli! 5 yıldır bu salona gidiyorum, uzmanlar manikür ve pedikürü çok iyi yapıyor. Hoş bir resepsiyonist ve tüm ekip. Bonus: kahve, çay, tatlı ikramlar!🥰 Salona bereket, gelişme ve minnettar müşteriler diliyorum 💖',
    0, '2026-07-03 00:00:00'),

(@user_taisia_kim, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s0NVRXNUZkRzFLVGxObWRscERPRXhFVkVWRWJtYxAB',
    5, 'ru', 'Прекрасное место, идеальный сервис, мастер Наталья и педикюр, вкуснейший кофе! Рекомендую всем, 10/10',
    'Prekrasno mjesto, savršena usluga, majstorica Natalja i pedikir, najukusnija kafa! Preporučujem svima, 10/10', 'Прекрасно мјесто, савршена услуга, мајсторица Наталја и педикир, најукуснија кафа! Препоручујем свима, 10/10', 'A wonderful place, perfect service, specialist Natalya and the pedicure, and the most delicious coffee! I recommend it to everyone, 10/10', 'Прекрасное место, идеальный сервис, мастер Наталья и педикюр, вкуснейший кофе! Рекомендую всем, 10/10', 'Ein wunderbarer Ort, perfekter Service, die Fachkraft Natalya und die Pediküre, und der leckerste Kaffee! Ich empfehle es allen, 10/10', 'Harika bir yer, kusursuz hizmet, uzman Natalya ve pedikür, bir de nefis kahve! Herkese tavsiye ederim, 10/10',
    0, '2026-07-03 00:00:00'),

(@user_evgeniya_petrovich, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tGWFdGZDVjVkJ6TUZWYVZGaFJUR2xhUldGNFFrRRAB',
    5, 'ru', 'Приходила на прием с воспалением на пальце ноги. Очень переживала, но процедура прошла быстро и практически незаметно. Доктор очень аккуратная, вежливая, всё объясняет по ходу дела. Рекомендую на все 100%.',
    'Došla sam na pregled sa upalom na prstu stopala. Bila sam vrlo zabrinuta, ali procedura je prošla brzo i praktično neprimjetno. Doktorka je veoma pažljiva, ljubazna, sve objašnjava u toku rada. Preporučujem 100%.', 'Дошла сам на преглед са упалом на прсту стопала. Била сам врло забринута, али процедура је прошла брзо и практично непримјетно. Докторка је веома пажљива, љубазна, све објашњава у току рада. Препоручујем 100%.', 'I came in with an inflammation on my toe. I was really worried, but the procedure was quick and almost painless. The doctor is very gentle, polite, and explains everything as she goes. I recommend her 100%.', 'Приходила на прием с воспалением на пальце ноги. Очень переживала, но процедура прошла быстро и практически незаметно. Доктор очень аккуратная, вежливая, всё объясняет по ходу дела. Рекомендую на все 100%.', 'Ich kam mit einer Entzündung am Zeh zum Termin. Ich hatte große Angst, aber die Behandlung ging schnell und war praktisch nicht zu spüren. Die Ärztin ist sehr behutsam, höflich und erklärt alles während der Behandlung. Ich empfehle sie zu 100 %.', 'Ayak parmağımdaki iltihapla randevuya gittim. Çok endişeliydim ama işlem hızlı ve neredeyse hiç fark ettirmeden geçti. Doktor çok özenli, kibar, her şeyi işlem sırasında anlatıyor. %100 tavsiye ederim.',
    0, '2026-07-03 00:00:00'),

(@user_evgeniya_merkel, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT20xTFRIZzBhVVJVY0RCSVJHVkJPWEZpZFZFMGVHYxAB',
    5, 'ru', 'Прекрасное обслуживание ❤️🤝Профессионально ,не навязчиво,вежливо!Очень понравилось ! Я теперь постоянный клиент 👍',
    'Prekrasna usluga ❤️🤝Profesionalno ,bez nametanja,ljubazno!Vrlo mi se svidjelo ! Sad sam stalni klijent 👍', 'Прекрасна услуга ❤️🤝Професионално ,без наметања,љубазно!Врло ми се свидјело ! Сад сам стални клијент 👍', 'Wonderful service ❤️🤝Professional ,no pushiness,polite!I loved it ! I\'m a regular client now 👍', 'Прекрасное обслуживание ❤️🤝Профессионально ,не навязчиво,вежливо!Очень понравилось ! Я теперь постоянный клиент 👍', 'Wunderbare Betreuung ❤️🤝Professionell ,ohne Aufdringlichkeit,höflich!Hat mir sehr gefallen ! Ich bin jetzt Stammkundin 👍', 'Harika bir hizmet ❤️🤝Profesyonel ,hiç ısrarcı değil,kibar!Çok memnun kaldım ! Artık düzenli müşteriyim 👍',
    0, '2026-07-03 00:00:00'),

(@user_aini_hmlinen, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pST1dtSkNabGd6VUhwclZVWkZkRXAwVlZSUGRGRRAB',
    5, 'fi', '🫶 …',
    '🫶 …', '🫶 …', '🫶 …', '🫶 …', '🫶 …', '🫶 …',
    0, '2026-07-03 00:00:00'),

(@user_yuriy_mazhulin, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tVM2F6WllVR3BWWmtrd1lqTXRRbEp0VGxwNU5tYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-03 00:00:00'),

(@user_andrey_kazantsev, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GcWJHcHRjV3hDWTBwSFNVcHRhVEp1VjJkbGFrRRAB',
    5, 'ru', 'Сервис на высшем уровне, все вежливые и приятные люди, Наталья мастер своего дела и делает все идеально.',
    'Usluga na najvišem nivou, svi su ljubazni i prijatni ljudi, Natalja je majstor svog posla i sve radi savršeno.', 'Услуга на највишем нивоу, сви су љубазни и пријатни људи, Наталја је мајстор свог посла и све ради савршено.', 'Top-notch service, everyone is polite and pleasant, Natalya is a master of her craft and does everything perfectly.', 'Сервис на высшем уровне, все вежливые и приятные люди, Наталья мастер своего дела и делает все идеально.', 'Service auf höchstem Niveau, alle sind höflich und angenehm, Natalya ist eine Meisterin ihres Fachs und macht alles perfekt.', 'Hizmet en üst seviyede, herkes kibar ve hoş insanlar, Natalya işinin ustası ve her şeyi kusursuz yapıyor.',
    0, '2026-06-03 00:00:00'),

(@user_olga_tadic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4SWNXRnRZWEkzVjJaemEzTm5OVzR0ZVRWRk5tYxAB',
    5, 'hr', 'Master Natalija je jako stručna i ljubazna kao i djevojka koja radi na recepciji. Sve preporuke!',
    'Master Natalija je jako stručna i ljubazna kao i djevojka koja radi na recepciji. Sve preporuke!', 'Мајсторица Natalija је јако стручна и љубазна као и дјевојка која ради на рецепцији. Све препоруке!', 'Natalija the specialist is very skilled and friendly, and so is the girl at the reception. Highly recommended!', 'Мастер Наталия очень грамотная и приветливая, как и девушка на ресепшене. Всячески рекомендую!', 'Die Fachkraft Natalija ist sehr kompetent und freundlich, genauso wie das Mädchen an der Rezeption. Absolut empfehlenswert!', 'Uzman Natalija çok bilgili ve nazik, resepsiyondaki kız da öyle. Kesinlikle tavsiye ederim!',
    0, '2026-06-03 00:00:00'),

(@user_vladimirs_kozlovs, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pCVmJrdFVUbmhOU0ZaSVdsOUxkVkZWVlZGZlZsRRAB',
    5, 'ru', 'Только положительные эмоции и моменты. Великолепная работа подолога. Мои ногти и я в восторге. Заходите и не раздумывайте. Большое спасибо за за отличное обслуживание.',
    'Samo pozitivne emocije i trenuci. Sjajan rad podologa. Moji nokti i ja smo oduševljeni. Dođite i ne razmišljajte. Veliko hvala za odličnu uslugu.', 'Само позитивне емоције и тренуци. Сјајан рад подолога. Моји нокти и ја смо одушевљени. Дођите и не размишљајте. Велико хвала за одличну услугу.', 'Only positive emotions and moments. Brilliant work by the podiatrist. My nails and I are delighted. Just go, don\'t think twice. Many thanks for the excellent service.', 'Только положительные эмоции и моменты. Великолепная работа подолога. Мои ногти и я в восторге. Заходите и не раздумывайте. Большое спасибо за за отличное обслуживание.', 'Nur positive Emotionen und Momente. Großartige Arbeit der Podologin. Meine Nägel und ich sind begeistert. Geht hin und überlegt nicht lange. Vielen Dank für die ausgezeichnete Betreuung.', 'Sadece olumlu duygular ve anlar. Podologun işi muhteşem. Tırnaklarım da ben de çok memnunuz. Gidin, hiç düşünmeyin. Mükemmel hizmet için çok teşekkürler.',
    0, '2026-06-03 00:00:00'),

(@user_uchiha_sasuke, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT213d2JYQTFZMUpSVUhOalIzZDNhV05ZVlRKelkxRRAB',
    5, 'ru', 'Все было по высшему разряду. Девушки профессионалки своего дела, все аккуратно и безболезненно. Медицинский взгляд и советы  по уходу)  Все максимально френдли. ☺️
Админ наливает кучу напитков на выбор, есть вкуснейшие конфетки из Хорватии и печеньки) Имеется  алкоголь😅.
Приятный разговор и времяпрепровождение 100/10.',
    'Sve je bilo na najvišem nivou. Djevojke su profesionalke u svom poslu, sve pažljivo i bezbolno. Medicinski pristup i savjeti za njegu) Svi su maksimalno friendly. ☺️
Administratorka nudi gomilu napitaka na izbor, ima najukusnijih bombona iz Hrvatske i keksića) Ima i alkohola😅.
Prijatan razgovor i provod 100/10.', 'Све је било на највишем нивоу. Дјевојке су професионалке у свом послу, све пажљиво и безболно. Медицински приступ и савјети за његу) Сви су максимално friendly. ☺️
Администраторка нуди гомилу напитака на избор, има најукуснијих бомбона из Хрватске и кексића) Има и алкохола😅.
Пријатан разговор и провод 100/10.', 'Everything was top class. The girls are true professionals, everything neat and painless. A medical approach and care tips) Everyone is super friendly. ☺️
The receptionist pours you a ton of drinks to choose from, there are the tastiest sweets from Croatia and cookies) There\'s even alcohol😅.
Nice conversation and a great time 100/10.', 'Все было по высшему разряду. Девушки профессионалки своего дела, все аккуратно и безболезненно. Медицинский взгляд и советы  по уходу)  Все максимально френдли. ☺️
Админ наливает кучу напитков на выбор, есть вкуснейшие конфетки из Хорватии и печеньки) Имеется  алкоголь😅.
Приятный разговор и времяпрепровождение 100/10.', 'Alles war erste Klasse. Die Mädchen sind echte Profis, alles sorgfältig und schmerzfrei. Ein medizinischer Blick und Pflegetipps) Alle sind super freundlich. ☺️
Die Empfangsdame schenkt einen Haufen Getränke zur Auswahl ein, es gibt die leckersten Bonbons aus Kroatien und Kekse) Es gibt sogar Alkohol😅.
Angenehmes Gespräch und schöne Zeit 100/10.', 'Her şey birinci sınıftı. Kızlar işinin gerçek profesyonelleri, her şey özenli ve ağrısız. Tıbbi bir bakış ve bakım tavsiyeleri) Herkes son derece samimi. ☺️
Resepsiyondaki kız bir sürü içecek seçeneği ikram ediyor, Hırvatistan\'dan gelen nefis şekerler ve kurabiyeler var) Alkol bile mevcut😅.
Keyifli sohbet ve güzel vakit 100/10.',
    0, '2026-06-03 00:00:00'),

(@user_olesya_chernyavskaya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xOSE1FaElka2xSWTI4d1JIaGxYekpCV2tKTFNXYxAB',
    5, 'ru', 'Прекрасное место, лечение только началось, но уже чувствуется знание и компетентность персонала! Была на приеме у подолога Анны, остались только положительные впечатления. Отдельно порадовала возможность сдать анализ в центре.',
    'Divno mjesto, liječenje je tek počelo, ali se već osjeća znanje i kompetentnost osoblja! Bila sam na pregledu kod podologa Anne, ostali su samo pozitivni utisci. Posebno me obradovala mogućnost da se analiza uradi u samom centru.', 'Дивно мјесто, лијечење је тек почело, али се већ осјећа знање и компетентност особља! Била сам на прегледу код подолога Ане, остали су само позитивни утисци. Посебно ме обрадовала могућност да се анализа уради у самом центру.', 'A wonderful place, the treatment has only just begun, but you can already feel the knowledge and competence of the staff! I had an appointment with podiatrist Anna and came away with nothing but positive impressions. I was especially pleased that you can get lab tests done right at the centre.', 'Прекрасное место, лечение только началось, но уже чувствуется знание и компетентность персонала! Была на приеме у подолога Анны, остались только положительные впечатления. Отдельно порадовала возможность сдать анализ в центре.', 'Ein wunderbarer Ort, die Behandlung hat gerade erst begonnen, aber man spürt schon das Wissen und die Kompetenz des Personals! Ich war bei der Podologin Anna in Behandlung und habe nur positive Eindrücke mitgenommen. Besonders gefreut hat mich, dass man die Laboranalyse direkt im Zentrum machen kann.', 'Harika bir yer, tedavi henüz başladı ama personelin bilgisi ve yetkinliği şimdiden hissediliyor! Podolog Anna\'ya muayeneye gittim, sadece olumlu izlenimlerle ayrıldım. Tahlilin merkezde yapılabilmesi ayrıca çok hoşuma gitti.',
    0, '2026-06-03 00:00:00'),

(@user_daria, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2prelEzSkVkbDlSVjFGWmIxbEZPR2hCVDJKNk1WRRAB',
    5, 'ru', 'Прекрасный сервис, заботливые руки мастеров заставляют меня возвращаться в этот салон снова и снова, не смотря на то, что живу в другом городе.',
    'Divan servis, brižne ruke majstora čine da se vraćam u ovaj salon iznova i iznova, iako živim u drugom gradu.', 'Диван сервис, брижне руке мајстора чине да се враћам у овај салон изнова и изнова, иако живим у другом граду.', 'Wonderful service, the caring hands of the specialists make me come back to this salon again and again, even though I live in another city.', 'Прекрасный сервис, заботливые руки мастеров заставляют меня возвращаться в этот салон снова и снова, не смотря на то, что живу в другом городе.', 'Toller Service, die fürsorglichen Hände der Fachkräfte lassen mich immer wieder in diesen Salon zurückkehren, obwohl ich in einer anderen Stadt wohne.', 'Harika bir hizmet, uzmanların özenli elleri beni bu salona tekrar tekrar getiriyor, başka bir şehirde yaşamama rağmen.',
    0, '2026-06-03 00:00:00'),

(@user_dominika_trufan, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25oa2R5MUVWa0ZHUTNwTFVYb3RObFpPVDJSeFdFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-03 00:00:00'),

(@user_irina_sergeeva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNqci0tdDF3RRAB',
    5, 'ru', 'Превосходно',
    'Izvrsno', 'Изврсно', 'Excellent', 'Превосходно', 'Hervorragend', 'Mükemmel',
    0, '2026-05-03 00:00:00'),

(@user_elena_kuzina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21aRGFVWnFTbGRuZUVaemRsOXNUalZ6U25oV2FuYxAB',
    5, 'ru', 'Очень мне понравилось, теплая атмосфера, сервис 5*, приятный и дружелюбный персонал, все продумано до мелочей. Обязательно приду ещё и буду рекомендовать другим!',
    'Veoma mi se svidjelo, topla atmosfera, servis 5*, prijatno i ljubazno osoblje, sve je osmišljeno do najmanjih detalja. Obavezno ću doći ponovo i preporučivaću drugima!', 'Веома ми се свидјело, топла атмосфера, сервис 5*, пријатно и љубазно особље, све је осмишљено до најмањих детаља. Обавезно ћу доћи поново и препоручиваћу другима!', 'I really liked it: a warm atmosphere, 5* service, pleasant and friendly staff, everything thought out down to the smallest detail. I will definitely come again and will recommend it to others!', 'Очень мне понравилось, теплая атмосфера, сервис 5*, приятный и дружелюбный персонал, все продумано до мелочей. Обязательно приду ещё и буду рекомендовать другим!', 'Es hat mir sehr gefallen: eine warme Atmosphäre, 5*-Service, angenehmes und freundliches Personal, alles bis ins kleinste Detail durchdacht. Ich komme auf jeden Fall wieder und werde es anderen empfehlen!', 'Çok hoşuma gitti, sıcak bir atmosfer, 5* hizmet, hoş ve güler yüzlü personel, her şey en ince ayrıntısına kadar düşünülmüş. Kesinlikle yine geleceğim ve başkalarına da tavsiye edeceğim!',
    0, '2026-05-03 00:00:00'),

(@user_anna_kutuzova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pORVZGOWlOemhvWDJWdWVFSTVTMVZzVEU5WFVsRRAB',
    5, 'ru', '❤️❤️❤️',
    '❤️❤️❤️', '❤️❤️❤️', '❤️❤️❤️', '❤️❤️❤️', '❤️❤️❤️', '❤️❤️❤️',
    0, '2026-05-03 00:00:00'),

(@user_nazli_baysak, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21WclFtbGxObWR0UTBoTE5UY3diV2RFT1Y5VFZVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-03 00:00:00'),

(@user_oksana_lozovitskaya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTUNJZ1lpeXJRRRAB',
    5, 'ru', 'Великолепный центр! Обслуживание и сервис на высшем уровне! Качество 10 из 10. Мастер София профессионал с большой буквы. Теперь за маникюром и педикюром только сюда 🙌🏻',
    'Sjajan centar! Usluga i servis na najvišem nivou! Kvalitet 10 od 10. Majstorica Sofija je profesionalac s velikim P. Sad idem samo ovdje na manikir i pedikir 🙌🏻', 'Сјајан центар! Услуга и сервис на највишем нивоу! Квалитет 10 од 10. Мајсторица Софија је професионалац с великим П. Сад идем само овдје на маникир и педикир 🙌🏻', 'A magnificent centre! Care and service at the highest level! Quality 10 out of 10. Sofija is a professional with a capital P. From now on I\'ll go nowhere else for manicures and pedicures 🙌🏻', 'Великолепный центр! Обслуживание и сервис на высшем уровне! Качество 10 из 10. Мастер София профессионал с большой буквы. Теперь за маникюром и педикюром только сюда 🙌🏻', 'Ein großartiges Zentrum! Betreuung und Service auf höchstem Niveau! Qualität 10 von 10. Sofija ist eine Profi mit großem P. Für Manikür und Pediküre gehe ich jetzt nur noch hierher 🙌🏻', 'Muhteşem bir merkez! İlgi ve hizmet en üst seviyede! Kalite 10 üzerinden 10. Uzman Sofija tam anlamıyla bir profesyonel. Artık manikür ve pedikür için sadece buraya geliyorum 🙌🏻',
    0, '2026-05-03 00:00:00'),

(@user_olga_rododendron, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkM1h6WlpjbTlaZEdKUGVWWXdaMTk2YkhSSVNtYxAB',
    5, 'ru', 'Очень приятное и хорошее место. Внимательные мастера, которые аккуратно делают все процедуры.',
    'Veoma prijatno i dobro mjesto. Pažljivi majstori koji sve tretmane rade precizno.', 'Веома пријатно и добро мјесто. Пажљиви мајстори који све третмане раде прецизно.', 'A very pleasant and good place. Attentive specialists who carry out all the treatments carefully.', 'Очень приятное и хорошее место. Внимательные мастера, которые аккуратно делают все процедуры.', 'Ein sehr angenehmer und guter Ort. Aufmerksame Fachkräfte, die alle Behandlungen sorgfältig durchführen.', 'Çok hoş ve güzel bir yer. Tüm işlemleri özenle yapan ilgili uzmanlar.',
    0, '2026-04-03 00:00:00'),

(@user_aleksandr_vycherov, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tKa2FIQndSRFZ4Y2pNNVVFbHBjbE5mUm1ZM1EwRRAB',
    5, 'ru', 'Профессионально, с хорошим сервисом и доброжелательным отношением, настоятельно рекомендую!!!',
    'Profesionalno, s dobrim servisom i ljubaznim odnosom, toplo preporučujem!!!', 'Професионално, с добрим сервисом и љубазним односом, топло препоручујем!!!', 'Professional, with good service and a friendly attitude, I strongly recommend it!!!', 'Профессионально, с хорошим сервисом и доброжелательным отношением, настоятельно рекомендую!!!', 'Professionell, mit gutem Service und freundlicher Haltung, ich empfehle es wärmstens!!!', 'Profesyonel, iyi hizmet ve güler yüzlü bir yaklaşım, kesinlikle tavsiye ederim!!!',
    0, '2026-04-03 00:00:00'),

(@user_inna_holikova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25aVmRXOVZla3BMUTBrM1pEUnhNV0Z0WVdWWWNYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-03 00:00:00'),

(@user_svetlana_khrustaleva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xjMlVFcHFSalZzU2pCeFMyVjNOR2hUYVdwSVVWRRAB',
    5, 'ru', 'Я долго искала того, кто мне сможет помочь. Проблема с детства - вросший ноготь на ноге. Он мне не давал покоя. Летом, в босоножках (а я всегда любила каблуки), еще куда ни шло. Боль приходила с началом осени, когда мы все ныряем в ботинки, кроссовки. Я уже почти сдалась. Я в Москве не смогла найти специалиста, который бы мне помог, в Риге не нашла…
И однажды случайно пришла сюда. Меня сразу поразила красота  и чистота в салоне. Особенно я порадовалась наличию большого стерилизационного бокса за стеклом. Все на глазах - видно, как маникюрщицы достают чистейшие инструменты. Для меня эта история  важна, потому что я сама имела отношение к медицине. Маникюрщицы - девочки профессиональные. Маникюр мне сделали красивый. Бонус к этому лавандовый чай с печеньками, шампанское на 8 марта!!!
Это все приятно. Это все - эстетика.
Но главное открытием для меня стала Анюта, подолог.
Я наконец нашла своего врача, которая стала кропотливо и настойчиво помогать мне бороться с давней проблемой! Из месяца в месяц. Боль стала уходить уже с первого сеанса. Ноготь постепенно стал выравниваться. И я впервые за долгие годы почувствовала облегчение.
И теперь я могу, образно говоря, счастливо ходить ножками по дорожкам. ❤️
Да, Анюта еще и прекрасная собеседница. Умная, образованная, благожелательная!  Я каждый раз теперь прихожу сюда, как на праздник.)
Желаю Анюте и всем сотрудникам салона чудесного настроения, здоровья, счастья и любви! Спасибо вам!',
    'Dugo sam tražila nekoga ko će moći da mi pomogne. Problem imam još iz djetinjstva – urasli nokat na nozi. Nije mi davao mira. Ljeti, u sandalama (a ja sam uvijek voljela štikle), još je nekako i išlo. Bol je dolazio s početkom jeseni, kad svi zaronimo u čizme i patike. Već sam skoro bila odustala. U Moskvi nisam mogla da nađem specijalistu koji bi mi pomogao, u Rigi ga nisam našla…
I jednog dana sam slučajno došla ovdje. Odmah me je zadivila ljepota i čistoća u salonu. Posebno me obradovalo to što postoji veliki sterilizacioni boks za staklom. Sve je pred očima – vidi se kako manikirke vade besprijekorno čiste instrumente. Meni je to važno, jer sam i sama bila u medicini. Manikirke su prave profesionalke. Manikir su mi napravile prekrasan. Bonus uz to – čaj od lavande s keksićima, šampanjac za 8. mart!!!
Sve je to prijatno. Sve je to estetika.
Ali glavno otkriće za mene bila je Anjuta, podolog.
Napokon sam našla svog ljekara, koja je počela pedantno i uporno da mi pomaže u borbi s dugogodišnjim problemom! Iz mjeseca u mjesec. Bol je počeo da nestaje već od prve seanse. Nokat se postepeno počeo ispravljati. I prvi put nakon toliko godina osjetila sam olakšanje.
I sad mogu, slikovito rečeno, srećno da hodam nožicama po stazama. ❤️
Da, Anjuta je uz to i divna sagovornica. Pametna, obrazovana, dobronamjerna! Sad svaki put dolazim ovdje kao na praznik.)
Želim Anjuti i svim zaposlenima u salonu divno raspoloženje, zdravlje, sreću i ljubav! Hvala vam!', 'Дуго сам тражила некога ко ће моћи да ми помогне. Проблем имам још из дјетињства – урасли нокат на нози. Није ми давао мира. Љети, у сандалама (а ја сам увијек вољела штикле), још је некако и ишло. Бол је долазио с почетком јесени, кад сви заронимо у чизме и патике. Већ сам скоро била одустала. У Москви нисам могла да нађем специјалисту који би ми помогао, у Риги га нисам нашла…
И једног дана сам случајно дошла овдје. Одмах ме је задивила љепота и чистоћа у салону. Посебно ме обрадовало то што постоји велики стерилизациони бокс за стаклом. Све је пред очима – види се како маникирке ваде беспријекорно чисте инструменте. Мени је то важно, јер сам и сама била у медицини. Маникирке су праве професионалке. Маникир су ми направиле прекрасан. Бонус уз то – чај од лаванде с кексићима, шампањац за 8. март!!!
Све је то пријатно. Све је то естетика.
Али главно откриће за мене била је Ањута, подолог.
Напокон сам нашла свог љекара, која је почела педантно и упорно да ми помаже у борби с дугогодишњим проблемом! Из мјесеца у мјесец. Бол је почео да нестаје већ од прве сеансе. Нокат се постепено почео исправљати. И први пут након толико година осјетила сам олакшање.
И сад могу, сликовито речено, срећно да ходам ножицама по стазама. ❤️
Да, Ањута је уз то и дивна саговорница. Паметна, образована, добронамјерна! Сад сваки пут долазим овдје као на празник.)
Желим Ањути и свим запосленима у салону дивно расположење, здравље, срећу и љубав! Хвала вам!', 'For a long time I was looking for someone who could help me. The problem goes back to childhood – an ingrown toenail. It gave me no peace. In summer, in open sandals (and I\'ve always loved heels), it was still bearable. The pain came with the start of autumn, when we all dive into boots and trainers. I had almost given up. In Moscow I couldn\'t find a specialist who could help me, in Riga I didn\'t find one either…
And then one day I came here by chance. I was immediately struck by the beauty and the cleanliness of the salon. I was especially pleased that there is a large sterilisation box behind glass. Everything is in plain sight – you can see the manicurists taking out spotlessly clean instruments. That matters to me, because I used to be connected with medicine myself. The manicurists are true professionals. They gave me a beautiful manicure. And as a bonus – lavender tea with cookies, champagne on 8 March!!!
All of that is lovely. All of that is aesthetics.
But my main discovery was Anjuta, the podiatrist.
I have finally found my doctor, who began painstakingly and persistently helping me fight a long-standing problem! Month after month. The pain started to fade after the very first session. The nail gradually began to straighten out. And for the first time in many years I felt relief.
And now, figuratively speaking, I can walk happily on my own two feet down any path. ❤️
And Anjuta is a wonderful person to talk to as well. Smart, well-educated, kind-hearted! Now every visit here feels like a celebration.)
I wish Anjuta and all the salon\'s staff a wonderful mood, health, happiness and love! Thank you!', 'Я долго искала того, кто мне сможет помочь. Проблема с детства - вросший ноготь на ноге. Он мне не давал покоя. Летом, в босоножках (а я всегда любила каблуки), еще куда ни шло. Боль приходила с началом осени, когда мы все ныряем в ботинки, кроссовки. Я уже почти сдалась. Я в Москве не смогла найти специалиста, который бы мне помог, в Риге не нашла…
И однажды случайно пришла сюда. Меня сразу поразила красота  и чистота в салоне. Особенно я порадовалась наличию большого стерилизационного бокса за стеклом. Все на глазах - видно, как маникюрщицы достают чистейшие инструменты. Для меня эта история  важна, потому что я сама имела отношение к медицине. Маникюрщицы - девочки профессиональные. Маникюр мне сделали красивый. Бонус к этому лавандовый чай с печеньками, шампанское на 8 марта!!!
Это все приятно. Это все - эстетика.
Но главное открытием для меня стала Анюта, подолог.
Я наконец нашла своего врача, которая стала кропотливо и настойчиво помогать мне бороться с давней проблемой! Из месяца в месяц. Боль стала уходить уже с первого сеанса. Ноготь постепенно стал выравниваться. И я впервые за долгие годы почувствовала облегчение.
И теперь я могу, образно говоря, счастливо ходить ножками по дорожкам. ❤️
Да, Анюта еще и прекрасная собеседница. Умная, образованная, благожелательная!  Я каждый раз теперь прихожу сюда, как на праздник.)
Желаю Анюте и всем сотрудникам салона чудесного настроения, здоровья, счастья и любви! Спасибо вам!', 'Ich habe lange nach jemandem gesucht, der mir helfen könnte. Das Problem habe ich seit meiner Kindheit – ein eingewachsener Nagel am Fuß. Er hat mir keine Ruhe gelassen. Im Sommer, in Sandalen (und ich habe immer Absätze geliebt), ging es noch irgendwie. Der Schmerz kam mit dem Herbstbeginn, wenn wir alle in Stiefel und Sneaker steigen. Ich hatte schon fast aufgegeben. In Moskau konnte ich keinen Spezialisten finden, der mir hilft, in Riga habe ich auch keinen gefunden…
Und dann bin ich eines Tages zufällig hierher gekommen. Sofort haben mich die Schönheit und die Sauberkeit im Salon beeindruckt. Besonders gefreut hat mich die große Sterilisationsbox hinter Glas. Alles liegt offen vor den Augen – man sieht, wie die Maniküristinnen makellos saubere Instrumente herausnehmen. Für mich ist das wichtig, denn ich hatte selbst mit der Medizin zu tun. Die Maniküristinnen sind echte Profis. Die Maniküre war wunderschön. Als Bonus obendrauf: Lavendeltee mit Keksen, Champagner zum 8. März!!!
Das alles ist angenehm. Das alles ist Ästhetik.
Aber die wichtigste Entdeckung war für mich Anjuta, die Podologin.
Endlich habe ich meine Ärztin gefunden, die mir sorgfältig und beharrlich geholfen hat, ein altes Problem zu bekämpfen! Monat für Monat. Der Schmerz ließ schon nach der ersten Sitzung nach. Der Nagel begann sich allmählich gerade zu wachsen. Und zum ersten Mal seit vielen Jahren fühlte ich Erleichterung.
Und jetzt kann ich, bildlich gesprochen, glücklich auf meinen eigenen Füßen über jeden Weg laufen. ❤️
Und ja, Anjuta ist außerdem eine wunderbare Gesprächspartnerin. Klug, gebildet, wohlwollend! Jeder Besuch hier ist für mich inzwischen wie ein Fest.)
Ich wünsche Anjuta und allen Mitarbeiterinnen des Salons eine wunderbare Stimmung, Gesundheit, Glück und Liebe! Vielen Dank!', 'Uzun süre bana yardım edebilecek birini aradım. Sorun çocukluğumdan beri var – ayağımda batık tırnak. Bana huzur vermiyordu. Yazın, açık sandaletlerle (ben hep topuklu severdim) yine bir şekilde idare ediyordu. Ağrı sonbaharın başlamasıyla geliyordu, hepimizin botlara ve spor ayakkabılara gömüldüğü zaman. Neredeyse vazgeçmiştim. Moskova\'da bana yardım edecek bir uzman bulamadım, Riga\'da da bulamadım…
Ve bir gün tesadüfen buraya geldim. Salondaki güzellik ve temizlik beni hemen etkiledi. Özellikle cam arkasındaki büyük sterilizasyon kabini beni çok memnun etti. Her şey göz önünde – manikürcülerin tertemiz aletleri nasıl çıkardığı görülüyor. Bu benim için önemli, çünkü ben de bir zamanlar tıpla ilgiliydim. Manikürcü kızlar gerçek profesyonel. Manikürüm çok güzel oldu. Üstüne bonus olarak lavanta çayı ve kurabiyeler, 8 Mart\'ta şampanya!!!
Bunların hepsi hoş. Bunların hepsi estetik.
Ama benim için en büyük keşif podolog Anjuta oldu.
Sonunda kendi doktorumu buldum; yıllardır süren sorunumla mücadele etmemde titizlikle ve sabırla yardım etmeye başladı! Aydan aya. Ağrı ilk seanstan itibaren geçmeye başladı. Tırnak yavaş yavaş düzelmeye başladı. Ve uzun yıllardan sonra ilk kez rahatladığımı hissettim.
Ve artık, mecazi anlamda, ayaklarımla yollarda mutlu mutlu yürüyebiliyorum. ❤️
Evet, Anjuta aynı zamanda harika bir sohbet arkadaşı. Zeki, kültürlü, iyi kalpli! Artık her gelişim bir bayram gibi.)
Anjuta\'ya ve salonun tüm çalışanlarına harika bir ruh hali, sağlık, mutluluk ve sevgi diliyorum! Teşekkür ederim!',
    0, '2026-04-03 00:00:00'),

(@user_nataliia_semenova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21oWVIxWlhaR3BGZDJacFIwcFNXRU5JUzJONVoyYxAB',
    5, 'ru', 'С каждым визитом убеждаюсь, что попала в надёжные, профессиональные руки. Спасибо Вам за ваш труд!
Спасибо Анюте за замечательное отношение к клиенту и помощь! Рада, что попала в надёжные руки. Камилла на ресепшене обаятельная, с очаровательной улыбкой, была рада встрече с таким человеком! Так же осталась довольна визитом к Ортопеду Алексею, очень внимательный и грамотный специалист, изготовил мне игдивидуальные стельки',
    'Sa svakom posjetom se uvjeravam da sam došla u sigurne, profesionalne ruke. Hvala vam na vašem radu!
Hvala Anjuti na divnom odnosu prema klijentu i na pomoći! Radujem se što sam došla u sigurne ruke. Kamilla na recepciji je šarmantna, s očaravajućim osmijehom, bilo mi je drago da sretnem takvog čovjeka! Takođe sam bila zadovoljna posjetom ortopedu Alekseju, veoma pažljiv i stručan specijalista, napravio mi je individualne uloške za obuću', 'Са сваком посјетом се увјеравам да сам дошла у сигурне, професионалне руке. Хвала вам на вашем раду!
Хвала Ањути на дивном односу према клијенту и на помоћи! Радујем се што сам дошла у сигурне руке. Камила на рецепцији је шармантна, с очаравајућим осмијехом, било ми је драго да сретнем таквог човјека! Такође сам била задовољна посјетом ортопеду Алексеју, веома пажљив и стручан специјалиста, направио ми је индивидуалне улошке за обућу', 'With every visit I become more certain that I am in reliable, professional hands. Thank you for your work!
Thank you to Anjuta for her wonderful attitude towards the client and for her help! I\'m glad I ended up in reliable hands. Kamilla at reception is charming, with a lovely smile, it was a pleasure to meet a person like that! I was also happy with my visit to the orthopaedist Aleksej, a very attentive and knowledgeable specialist, he made me custom orthotic insoles', 'С каждым визитом убеждаюсь, что попала в надёжные, профессиональные руки. Спасибо Вам за ваш труд!
Спасибо Анюте за замечательное отношение к клиенту и помощь! Рада, что попала в надёжные руки. Камилла на ресепшене обаятельная, с очаровательной улыбкой, была рада встрече с таким человеком! Так же осталась довольна визитом к Ортопеду Алексею, очень внимательный и грамотный специалист, изготовил мне игдивидуальные стельки', 'Mit jedem Besuch bestätigt sich, dass ich in zuverlässigen, professionellen Händen bin. Danke für Ihre Arbeit!
Danke an Anjuta für den wunderbaren Umgang mit der Kundin und für die Hilfe! Ich bin froh, in zuverlässigen Händen gelandet zu sein. Kamilla am Empfang ist charmant, mit einem bezaubernden Lächeln, ich habe mich gefreut, so einem Menschen zu begegnen! Auch mit dem Besuch beim Orthopäden Aleksej war ich zufrieden, ein sehr aufmerksamer und kompetenter Spezialist, er hat mir individuelle Einlagen angefertigt', 'Her ziyaretimde güvenilir, profesyonel ellerde olduğuma bir kez daha inanıyorum. Emeğiniz için teşekkürler!
Anjuta\'ya müşteriye karşı harika yaklaşımı ve yardımı için teşekkürler! Güvenilir ellere düştüğüme sevindim. Resepsiyondaki Kamilla çok sevimli, büyüleyici bir gülümsemesi var, böyle biriyle tanışmak beni mutlu etti! Ortopedist Aleksej\'e yaptığım ziyaretten de memnun kaldım, çok ilgili ve bilgili bir uzman, bana kişiye özel tabanlık yaptı',
    0, '2026-04-03 00:00:00'),

(@user_lyubov_smirnova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSc1ZIZE5TbXRYT1VObVVua3ljbFJUYW5SNVRVRRAB',
    5, 'ru', 'Очень приятный салон подологии. Идеальная чистота, высокий уровень сервиса, для Черногории это вдвойне радует.
Отдельное спасибо мастеру Софье -  аккуратная, деликатная и внимательная. Всё делает тщательно и спокойно, чувствуется опыт и забота.

Понравилось, что предлагают напиток по меню. Зеленый чай с манго это нечто.
Комфортная атмосфера и всё выглядит стерильно и аккуратно - для таких процедур это особенно важно.

Однозначно рекомендую🫶',
    'Veoma prijatan salon podologije. Besprijekorna čistoća, visok nivo servisa, a za Crnu Goru to dvostruko raduje.
Posebno hvala majstorici Sofiji – precizna, delikatna i pažljiva. Sve radi temeljno i mirno, osjeti se iskustvo i briga.

Svidjelo mi se što nude napitak po meniju. Zeleni čaj s mangom je nešto posebno.
Udobna atmosfera i sve izgleda sterilno i uredno – za takve tretmane to je posebno važno.

Bez sumnje preporučujem🫶', 'Веома пријатан салон подологије. Беспријекорна чистоћа, висок ниво сервиса, а за Црну Гору то двоструко радује.
Посебно хвала мајсторици Софији – прецизна, деликатна и пажљива. Све ради темељно и мирно, осјети се искуство и брига.

Свидјело ми се што нуде напитак по менију. Зелени чај с мангом је нешто посебно.
Удобна атмосфера и све изгледа стерилно и уредно – за такве третмане то је посебно важно.

Без сумње препоручујем🫶', 'A very pleasant podiatry salon. Immaculate cleanliness, a high level of service — for Montenegro that\'s doubly gratifying.
Special thanks to Sofija — precise, gentle and attentive. She does everything thoroughly and calmly, you can feel the experience and the care.

I liked that they offer a drink from a menu. The green tea with mango is something else.
A comfortable atmosphere and everything looks sterile and tidy — for procedures like these that matters especially.

I definitely recommend it🫶', 'Очень приятный салон подологии. Идеальная чистота, высокий уровень сервиса, для Черногории это вдвойне радует.
Отдельное спасибо мастеру Софье -  аккуратная, деликатная и внимательная. Всё делает тщательно и спокойно, чувствуется опыт и забота.

Понравилось, что предлагают напиток по меню. Зеленый чай с манго это нечто.
Комфортная атмосфера и всё выглядит стерильно и аккуратно - для таких процедур это особенно важно.

Однозначно рекомендую🫶', 'Ein sehr angenehmer Podologie-Salon. Perfekte Sauberkeit, hohes Serviceniveau — für Montenegro freut das doppelt.
Besonderen Dank an Sofija — sorgfältig, feinfühlig und aufmerksam. Sie macht alles gründlich und in Ruhe, man spürt Erfahrung und Fürsorge.

Mir hat gefallen, dass ein Getränk nach Karte angeboten wird. Der grüne Tee mit Mango ist der Hammer.
Angenehme Atmosphäre und alles sieht steril und ordentlich aus — bei solchen Behandlungen ist das besonders wichtig.

Eindeutig empfehlenswert🫶', 'Çok hoş bir podoloji salonu. Kusursuz temizlik, yüksek hizmet seviyesi, Karadağ için bu iki kat sevindirici.
Uzman Sofija\'ya ayrıca teşekkürler – özenli, nazik ve ilgili. Her şeyi titizlikle ve sakince yapıyor, deneyim ve özen hissediliyor.

Menüden içecek ikram etmeleri hoşuma gitti. Mangolu yeşil çay bir başka.
Rahat bir atmosfer ve her şey steril ve düzenli görünüyor – böyle işlemler için bu özellikle önemli.

Kesinlikle tavsiye ederim🫶',
    0, '2026-04-03 00:00:00'),

(@user_anna_makarova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KalZXSjZWV1p3ZW1wZmFtVjBOVWRuZW1kVFVFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-03 00:00:00'),

(@user_viktoriya_sluchaynaya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2sxWVYyOTJTbXhGUld4TGNHcFNaMnRYTFhkMVNtYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-03 00:00:00'),

(@user_milla, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WWloxbDZWVVV3ZFVGaVgwOHpZak5IUWxac1RGRRAB',
    5, 'ru', 'Лучший маникюр и педикюр! Перепробовала разные формы ногтей и как всегда все идеально! Девочки все прекрасные, хожу к Светлане, быстро и очень качественно, собираю комплименты благодаря ей 🫶🏻 Огромный выбор цветов, сервис на высоте 🫶🏻 …',
    'Najbolji manikir i pedikir! Isprobala sam različite oblike noktiju i kao i uvijek sve je savršeno! Djevojke su sve divne, idem kod Svetlane, brzo i vrlo kvalitetno, zahvaljujući njoj skupljam komplimente 🫶🏻 Ogroman izbor boja, servis na visini 🫶🏻 …', 'Најбољи маникир и педикир! Испробала сам различите облике ноктију и као и увијек све је савршено! Дјевојке су све дивне, идем код Светлане, брзо и врло квалитетно, захваљујући њој скупљам комплименте 🫶🏻 Огроман избор боја, сервис на висини 🫶🏻 …', 'The best manicure and pedicure! I\'ve tried different nail shapes and, as always, everything is perfect! All the girls are lovely, I go to Svetlana, quick and very high quality, I collect compliments thanks to her 🫶🏻 A huge choice of colours, service is top notch 🫶🏻 …', 'Лучший маникюр и педикюр! Перепробовала разные формы ногтей и как всегда все идеально! Девочки все прекрасные, хожу к Светлане, быстро и очень качественно, собираю комплименты благодаря ей 🫶🏻 Огромный выбор цветов, сервис на высоте 🫶🏻 …', 'Die beste Manikür und Pediküre! Ich habe verschiedene Nagelformen ausprobiert und wie immer ist alles perfekt! Die Mädchen sind alle wunderbar, ich gehe zu Svetlana, schnell und sehr hochwertig, dank ihr sammle ich Komplimente 🫶🏻 Riesige Farbauswahl, der Service ist top 🫶🏻 …', 'En iyi manikür ve pedikür! Farklı tırnak şekilleri denedim ve her zamanki gibi her şey kusursuz! Kızların hepsi harika, Svetlana\'ya gidiyorum, hızlı ve çok kaliteli, onun sayesinde iltifat topluyorum 🫶🏻 Çok geniş renk seçeneği, hizmet mükemmel 🫶🏻 …',
    0, '2026-04-03 00:00:00'),

(@user_viktoriya_lutay, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25CalRuTlNURzVxZEZkS2JHNHdhMHhOWldaVVpGRRAB',
    1, 'ru', 'Ужасные кривые ногти не советую',
    'Užasni, krivi nokti, ne preporučujem', 'Ужасни, криви нокти, не препоручујем', 'Awful crooked nails, I don\'t recommend it', 'Ужасные кривые ногти не советую', 'Furchtbare schiefe Nägel, ich kann es nicht empfehlen', 'Berbat, çarpık tırnaklar, tavsiye etmiyorum',
    0, '2026-04-03 00:00:00'),

(@user_lyudmila_goncharova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tnelZURXpZVzg0WTNsa1VrdFVkbWg0UzBGbk1VRRAB',
    5, 'ru', 'Очень люблю посещать этот салон, уютная атмосфера, чудесный коллектив и профессиональный сервис, спасибо большое всему персоналу',
    'Veoma volim da dolazim u ovaj salon, prijatna atmosfera, divan kolektiv i profesionalna usluga, veliko hvala cijelom osoblju', 'Веома волим да долазим у овај салон, пријатна атмосфера, диван колектив и професионална услуга, велико хвала цијелом особљу', 'I really love visiting this salon — a cosy atmosphere, a wonderful team and professional service, many thanks to all the staff', 'Очень люблю посещать этот салон, уютная атмосфера, чудесный коллектив и профессиональный сервис, спасибо большое всему персоналу', 'Ich besuche diesen Salon sehr gern, gemütliche Atmosphäre, ein wunderbares Team und professioneller Service, vielen Dank an das ganze Personal', 'Bu salona gelmeyi çok seviyorum, samimi bir atmosfer, harika bir ekip ve profesyonel hizmet, tüm personele çok teşekkürler',
    0, '2026-04-03 00:00:00'),

(@user_daniela_medina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tKb2NUbG1WVU5YYVVSUmExOVRiblU1ZGt4U1ZYYxAB',
    5, 'en', 'Honestly. The best attention and emergency service. I had an ingrown toe nail (I was all the way in Tivat) and the same day they made an opening for me at 9PM at night.
After going to several private clinics and public emergency rooms in Tivat and Kotor (where I was told I needed SURGERY), a friend recommended iPODO and they saved me from a complicated situation which was 100% avoidable.

The doctor was SO EFFECTIVE, funny and sweet. We had a translator (a very sweet nurse) and it was lovely. They check on your via WhatsApp daily (you send them pictures, etc).

I just went back for my 4 day follow up and my toe looked like new.

I\'d recommend iPODO a hundred times over.',
    'Iskreno. Najbolja pažnja i hitna usluga. Imao sam urasli nokat na nozi (a bio sam čak u Tivtu) i istog dana su mi našli termin u 9 uveče.
Nakon što sam obišao nekoliko privatnih klinika i državnih urgentnih centara u Tivtu i Kotoru (gdje su mi rekli da mi treba OPERACIJA), prijatelj mi je preporučio iPODO i spasili su me komplikovane situacije koja se 100% mogla izbjeći.

Doktorka je bila TAKO EFIKASNA, duhovita i draga. Imali smo prevodioca (veoma dragu medicinsku sestru) i bilo je super. Svakog dana se jave preko WhatsAppa da provjere kako ste (šaljete im fotografije i tako dalje).

Upravo sam se vratio na kontrolu nakon 4 dana i prst mi je izgledao kao nov.

Preporučio bih iPODO sto puta.', 'Искрено. Најбоља пажња и хитна услуга. Имао сам урасли нокат на нози (а био сам чак у Тивту) и истог дана су ми нашли термин у 9 увече.
Након што сам обишао неколико приватних клиника и државних ургентних центара у Тивту и Котору (гдје су ми рекли да ми треба ОПЕРАЦИЈА), пријатељ ми је препоручио iPODO и спасили су ме компликоване ситуације која се 100% могла избјећи.

Докторка је била ТАКО ЕФИКАСНА, духовита и драга. Имали смо преводиоца (веома драгу медицинску сестру) и било је супер. Сваког дана се јаве преко WhatsAppа да провјере како сте (шаљете им фотографије и тако даље).

Управо сам се вратио на контролу након 4 дана и прст ми је изгледао као нов.

Препоручио бих iPODO сто пута.', 'Honestly. The best attention and emergency service. I had an ingrown toe nail (I was all the way in Tivat) and the same day they made an opening for me at 9PM at night.
After going to several private clinics and public emergency rooms in Tivat and Kotor (where I was told I needed SURGERY), a friend recommended iPODO and they saved me from a complicated situation which was 100% avoidable.

The doctor was SO EFFECTIVE, funny and sweet. We had a translator (a very sweet nurse) and it was lovely. They check on your via WhatsApp daily (you send them pictures, etc).

I just went back for my 4 day follow up and my toe looked like new.

I\'d recommend iPODO a hundred times over.', 'Честно. Лучшее внимание и лучшая экстренная помощь. У меня был вросший ноготь на ноге (а я был вообще в Тивате), и в тот же день мне нашли окошко в 9 вечера.
После того как я обошёл несколько частных клиник и государственных приёмных отделений в Тивате и Которе (где мне сказали, что нужна ОПЕРАЦИЯ), друг посоветовал iPODO — и они спасли меня от осложнений, которых на 100% можно было избежать.

Врач была НАСТОЛЬКО эффективной, весёлой и милой. С нами была переводчица (очень милая медсестра), и всё прошло замечательно. Они каждый день пишут в WhatsApp и спрашивают, как дела (отправляешь им фото и так далее).

Я только что был на контрольном осмотре через 4 дня — палец выглядел как новый.

Я бы рекомендовал iPODO сто раз.', 'Ehrlich. Die beste Betreuung und der beste Notfallservice. Ich hatte einen eingewachsenen Nagel am Zeh (und ich war ganz in Tivat) und am selben Tag haben sie mir noch einen Termin um 21 Uhr abends freigemacht.
Nachdem ich mehrere Privatkliniken und staatliche Notaufnahmen in Tivat und Kotor abgeklappert hatte (wo man mir sagte, ich bräuchte eine OPERATION), hat mir ein Freund iPODO empfohlen, und sie haben mich vor einer komplizierten Situation bewahrt, die zu 100 % vermeidbar war.

Die Ärztin war SO EFFEKTIV, humorvoll und lieb. Wir hatten eine Übersetzerin (eine sehr liebe Krankenschwester) und es war schön. Sie melden sich täglich über WhatsApp und fragen nach (man schickt ihnen Fotos usw.).

Ich war gerade nach 4 Tagen zur Kontrolle und mein Zeh sah wie neu aus.

Ich würde iPODO hundertmal empfehlen.', 'Dürüst olmak gerekirse. En iyi ilgi ve en iyi acil hizmet. Ayak parmağımda batık tırnak vardı (hem de ta Tivat\'taydım) ve aynı gün bana akşam 9 için yer açtılar.
Tivat ve Kotor\'daki birkaç özel kliniği ve devlet acil servislerini dolaştıktan sonra (orada bana AMELİYAT gerektiğini söylediler), bir arkadaşım iPODO\'yu önerdi ve beni %100 önlenebilir olan karmaşık bir durumdan kurtardılar.

Doktor ÇOK ETKİLİYDİ, esprili ve tatlıydı. Bir tercümanımız vardı (çok tatlı bir hemşire) ve harikaydı. Her gün WhatsApp\'tan durumunuzu soruyorlar (onlara fotoğraf gönderiyorsunuz vb.).

4 gün sonraki kontrole yeni gittim ve parmağım yeni gibi görünüyordu.

iPODO\'yu yüz kez tavsiye ederim.',
    0, '2026-04-03 00:00:00'),

(@user_sergey_kozhin, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21wYWVtRkhaM2h2UVdoSlZXVklWSEJqWWt4T1RrRRAB',
    5, 'ru', 'Феноменальный сервис, качество и стерильность, как в хирургическом блоке, решение подологических проблем с грамотным и комплексным подходом, опирающимся на огромный практический опыт и знания высочайшего класса, ничего подобного я еще не встречал, это действительно уровень, спасибо за заботу и помощь в решении моей подологической проблемы, 👌😊🙏❤️.',
    'Fenomenalan servis, kvalitet i sterilnost kao u operacionoj sali, rješavanje podoloških problema stručnim i kompleksnim pristupom, zasnovanim na ogromnom praktičnom iskustvu i znanju najviše klase, ništa slično još nisam sreo, ovo je zaista nivo, hvala vam na brizi i pomoći u rješavanju mog podološkog problema, 👌😊🙏❤️.', 'Феноменалан сервис, квалитет и стерилност као у операционој сали, рјешавање подолошких проблема стручним и комплексним приступом, заснованим на огромном практичном искуству и знању највише класе, ништа слично још нисам срео, ово је заиста ниво, хвала вам на бризи и помоћи у рјешавању мог подолошког проблема, 👌😊🙏❤️.', 'Phenomenal service, quality and sterility like in an operating theatre, podiatry problems solved with a competent and comprehensive approach based on huge practical experience and top-class knowledge. I have never come across anything like it, this really is a whole different level. Thank you for the care and for helping me solve my podiatry problem, 👌😊🙏❤️.', 'Феноменальный сервис, качество и стерильность, как в хирургическом блоке, решение подологических проблем с грамотным и комплексным подходом, опирающимся на огромный практический опыт и знания высочайшего класса, ничего подобного я еще не встречал, это действительно уровень, спасибо за заботу и помощь в решении моей подологической проблемы, 👌😊🙏❤️.', 'Phänomenaler Service, Qualität und Sterilität wie in einem Operationssaal, podologische Probleme werden mit kompetentem und umfassendem Ansatz gelöst, gestützt auf enorme praktische Erfahrung und Wissen der höchsten Klasse. So etwas habe ich noch nie erlebt, das ist wirklich ein anderes Niveau. Danke für die Fürsorge und die Hilfe bei der Lösung meines podologischen Problems, 👌😊🙏❤️.', 'Olağanüstü bir hizmet, ameliyathane gibi kalite ve sterillik, podolojik sorunlara büyük pratik deneyime ve en üst düzey bilgiye dayanan yetkin ve bütüncül bir yaklaşımla çözüm. Böylesine hiç rastlamadım, bu gerçekten bambaşka bir seviye. Podolojik sorunumun çözümündeki ilginiz ve yardımınız için teşekkürler, 👌😊🙏❤️.',
    0, '2026-03-03 00:00:00'),

(@user_tatyana_trofimenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWS0xYTTNOa2htWkRGSFEyNW5VemxyUVhZd2FHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-03 00:00:00'),

(@user_natalia_migal, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25veVVsQlBhMjV5VmtOVmJUVTRTbEJpV0hwZldtYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-02-03 00:00:00'),

(@user_ruzanna_manukyan, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ5Mjk2YmpBRRAB',
    5, 'ru', 'Светлана мой самый любимый мастер. Маникюр носится отлично, минимум 3-4 недели. Она очень деликатная, знает когда можно поболтать, а когда помолчать. Для меня это тоже очень ценно. Это показатель высоко интеллекта. Спасибо большое!',
    'Svetlana je moja najdraža majstorica. Manikir odlično traje, najmanje 3-4 nedjelje. Veoma je delikatna, zna kad se može popričati, a kad treba biti tiho. I to mi je veoma dragocjeno. To je pokazatelj visoke inteligencije. Veliko hvala!', 'Светлана је моја најдража мајсторица. Маникир одлично траје, најмање 3-4 недјеље. Веома је деликатна, зна кад се може попричати, а кад треба бити тихо. И то ми је веома драгоцјено. То је показатељ високе интелигенције. Велико хвала!', 'Svetlana is my absolute favourite. The manicure lasts brilliantly, at least 3-4 weeks. She is very tactful, she knows when you can chat and when to stay quiet. That\'s very valuable to me too. It\'s a sign of high intelligence. Many thanks!', 'Светлана мой самый любимый мастер. Маникюр носится отлично, минимум 3-4 недели. Она очень деликатная, знает когда можно поболтать, а когда помолчать. Для меня это тоже очень ценно. Это показатель высоко интеллекта. Спасибо большое!', 'Svetlana ist meine allerliebste Fachkraft. Die Manikür hält hervorragend, mindestens 3-4 Wochen. Sie ist sehr feinfühlig, sie weiß, wann man plaudern kann und wann man besser schweigt. Das ist mir auch sehr wertvoll. Das ist ein Zeichen hoher Intelligenz. Vielen Dank!', 'Svetlana en sevdiğim uzman. Manikür harika duruyor, en az 3-4 hafta. Çok ince düşünceli, ne zaman sohbet edileceğini, ne zaman susulacağını biliyor. Bu benim için de çok değerli. Bu, yüksek zekânın göstergesi. Çok teşekkürler!',
    0, '2026-02-03 00:00:00'),

(@user_aleksandra_kazachkova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21oRWRFRkxOMnhWWm1zNE5HaG9jMWRxVUhwZlZHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-02-03 00:00:00'),

(@user_alina_mrakich, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21FMFgzbzNhWGd0VVVVMVgzTk5VVEZrV0dKcWFYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-02-03 00:00:00'),

(@user_elina_tyger, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tKS05IbEtWbE00YzJablZUbEhOMFkyTTIxZk5rRRAB',
    5, 'en', 'Best!',
    'Najbolji!', 'Најбољи!', 'Best!', 'Лучшие!', 'Die Besten!', 'En iyisi!',
    0, '2026-01-03 00:00:00'),

(@user_viktor_kram, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twTFduWkZNSE5mYld4Q2NYbGxhbTloTFhCa1RXYxAB',
    5, 'ru', 'Хочу оставить отзыв о прекрасном и высококлассном специалисте по мужскому педикюру — Софье.

Работает аккуратно, профессионально и с большим вниманием к деталям. Дает полезные советы, создает дружескую и ламповую атмосферу — уходить с сеанса не хочется совсем. Результат каждый раз идеальный. Рекомендую всем. 🫰',
    'Želim da ostavim komentar o divnoj i vrhunskoj stručnjakinji za muški pedikir — Sofiji.

Radi precizno, profesionalno i s velikom pažnjom za detalje. Daje korisne savjete, stvara prijateljsku i toplu atmosferu — nakon tretmana uopšte ne želiš da odeš. Rezultat je svaki put savršen. Preporučujem svima. 🫰', 'Желим да оставим коментар о дивној и врхунској стручњакињи за мушки педикир — Софији.

Ради прецизно, професионално и с великом пажњом за детаље. Даје корисне савјете, ствара пријатељску и топлу атмосферу — након третмана уопште не желиш да одеш. Резултат је сваки пут савршен. Препоручујем свима. 🫰', 'I want to leave a review about a wonderful, top-class specialist in men\'s pedicure — Sofija.

She works precisely, professionally and with great attention to detail. She gives useful advice and creates a friendly, cosy atmosphere — you really don\'t want the session to end. The result is perfect every single time. I recommend her to everyone. 🫰', 'Хочу оставить отзыв о прекрасном и высококлассном специалисте по мужскому педикюру — Софье.

Работает аккуратно, профессионально и с большим вниманием к деталям. Дает полезные советы, создает дружескую и ламповую атмосферу — уходить с сеанса не хочется совсем. Результат каждый раз идеальный. Рекомендую всем. 🫰', 'Ich möchte eine Bewertung über eine wunderbare und hochklassige Spezialistin für Herren-Pediküre schreiben — Sofija.

Sie arbeitet sorgfältig, professionell und mit viel Aufmerksamkeit für Details. Sie gibt nützliche Ratschläge und schafft eine freundschaftliche, gemütliche Atmosphäre — man will nach der Sitzung überhaupt nicht gehen. Das Ergebnis ist jedes Mal perfekt. Ich empfehle sie allen. 🫰', 'Erkek pedikürü konusunda harika ve üst düzey bir uzman hakkında yorum bırakmak istiyorum — Sofija.

Özenli, profesyonel ve detaylara büyük dikkatle çalışıyor. Faydalı tavsiyeler veriyor, samimi ve sıcak bir ortam yaratıyor — seanstan hiç ayrılmak istemiyorsunuz. Sonuç her seferinde kusursuz. Herkese tavsiye ederim. 🫰',
    0, '2026-01-03 00:00:00'),

(@user_natalya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2toR1VrZGpSek4zVld0NWJsRkZhMncxYmpsWGNIYxAB',
    5, 'ru', 'Идеально! Однозначно рекомендую! Я мучалась 4 дня с "прибитым"ногтем ( болело очень сильно, в местной больнице предлагали удалить полностью ноготь)
Здесь сделали маленький прокол, все почистили, гематома была большая. Сделали все за 15 минут! Успокаивали, а на самом деле не было так больно.
Персонал, сервис, обслуживание - лучшее в Черногории ( и не только 😉)
На маникюр и педикюр теперь только сюда!',
    'Idealno! Definitivno preporučujem! Mučila sam se 4 dana sa prignječenim noktom ( bolelo je vrlo jako, u lokalnoj bolnici predlagali su da se nokat u potpunosti ukloni)
Ovdje su napravili malu punkciju, sve očistili, hematom je bio veliki. Sve su uradili za 15 minuta! Umirivali su me, a u stvari nije ni bilo tako bolno.
Osoblje, servis, usluga - najbolje u Crnoj Gori ( i ne samo 😉)
Na manikir i pedikir sada samo ovdje!', 'Идеално! Дефинитивно препоручујем! Мучила сам се 4 дана са пригњеченим ноктом ( бољело је врло јако, у локалној болници предлагали су да се нокат у потпуности уклони)
Овдје су направили малу пункцију, све очистили, хематом је био велики. Све су урадили за 15 минута! Умиривали су ме, а у ствари није ни било тако болно.
Особље, сервис, услуга - најбоље у Црној Гори ( и не само 😉)
На маникир и педикир сада само овдје!', 'Perfect! I definitely recommend it! I suffered for 4 days with a smashed nail ( it hurt really badly, at the local hospital they offered to remove the nail completely)
Here they made a tiny puncture, cleaned everything out, the hematoma was large. They did it all in 15 minutes! They kept reassuring me, but actually it didn\'t hurt that much.
The staff, the service, the care - the best in Montenegro ( and not only 😉)
From now on, only here for manicures and pedicures!', 'Идеально! Однозначно рекомендую! Я мучалась 4 дня с "прибитым"ногтем ( болело очень сильно, в местной больнице предлагали удалить полностью ноготь)
Здесь сделали маленький прокол, все почистили, гематома была большая. Сделали все за 15 минут! Успокаивали, а на самом деле не было так больно.
Персонал, сервис, обслуживание - лучшее в Черногории ( и не только 😉)
На маникюр и педикюр теперь только сюда!', 'Perfekt! Ich empfehle es absolut! Ich habe 4 Tage mit einem gequetschten Nagel gelitten ( es tat sehr weh, im örtlichen Krankenhaus wollte man den Nagel komplett entfernen)
Hier haben sie eine kleine Punktion gemacht, alles gereinigt, das Hämatom war groß. Alles in 15 Minuten erledigt! Sie haben mich beruhigt, aber eigentlich war es gar nicht so schmerzhaft.
Personal, Service, Betreuung - das Beste in Montenegro ( und nicht nur dort 😉)
Manikür und Pediküre jetzt nur noch hier!', 'Mükemmel! Kesinlikle tavsiye ediyorum! 4 gün boyunca ezilmiş bir tırnakla acı çektim ( çok fena ağrıyordu, yerel hastanede tırnağı tamamen almayı teklif ettiler)
Burada küçük bir delik açtılar, her şeyi temizlediler, hematom büyüktü. Hepsini 15 dakikada yaptılar! Beni sakinleştirdiler, ama aslında o kadar da acımadı.
Personel, servis, hizmet - Karadağ\'ın en iyisi ( ve sadece orada değil 😉)
Manikür ve pedikür için artık sadece buraya!',
    0, '2026-01-03 00:00:00'),

(@user_mariya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25sbFdtSjRNSFJLUVZZdGVGbExObWhsYTJkaGNYYxAB',
    5, 'ru', 'Лучший сервис в Будве. Для меня очень важна стерильность , тут соблюдают все правила.  Администратор Камилла очень приветливая и доброжелательная.
Мои любимые мастера это София и Светлана.
Всегда быстро и качественно.',
    'Najbolji servis u Budvi. Meni je sterilnost vrlo važna , ovdje se poštuju sva pravila.  Administratorka Kamilla je vrlo ljubazna i srdačna.
Moje omiljene majstorice su Sofija i Svetlana.
Uvijek brzo i kvalitetno.', 'Најбољи сервис у Будви. Мени је стерилност врло важна , овдје се поштују сва правила.  Администраторка Камила је врло љубазна и срдачна.
Моје омиљене мајсторице су Софија и Светлана.
Увијек брзо и квалитетно.', 'The best service in Budva. Sterility matters a lot to me , and here all the rules are followed.  The receptionist Kamilla is very welcoming and kind.
My favourite specialists are Sofija and Svetlana.
Always quick and high quality.', 'Лучший сервис в Будве. Для меня очень важна стерильность , тут соблюдают все правила.  Администратор Камилла очень приветливая и доброжелательная.
Мои любимые мастера это София и Светлана.
Всегда быстро и качественно.', 'Der beste Service in Budva. Sterilität ist mir sehr wichtig , und hier werden alle Regeln eingehalten.  Die Empfangsdame Kamilla ist sehr freundlich und zuvorkommend.
Meine Lieblingsspezialistinnen sind Sofija und Svetlana.
Immer schnell und hochwertig.', 'Budva\'daki en iyi hizmet. Sterillik benim için çok önemli , burada tüm kurallara uyuluyor.  Resepsiyonist Kamilla çok güler yüzlü ve içten.
En sevdiğim uzmanlar Sofija ve Svetlana.
Her zaman hızlı ve kaliteli.',
    0, '2026-01-03 00:00:00'),

(@user_yana_boyko, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21WeldIaDFlV3BuYkRoNmJWTm9aMUExZWpNMVFXYxAB',
    5, 'ru', 'Стерильная чистота,спокойная и комфортная атмосфера.Спасибо 🌸',
    'Sterilna čistoća,mirna i prijatna atmosfera.Hvala 🌸', 'Стерилна чистоћа,мирна и пријатна атмосфера.Хвала 🌸', 'Sterile cleanliness,calm and comfortable atmosphere.Thank you 🌸', 'Стерильная чистота,спокойная и комфортная атмосфера.Спасибо 🌸', 'Sterile Sauberkeit,ruhige und angenehme Atmosphäre.Danke 🌸', 'Steril temizlik,sakin ve rahat bir atmosfer.Teşekkürler 🌸',
    0, '2026-01-03 00:00:00'),

(@user_dana_fyodorova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25BMFIyZEhNSGhpYzFaNU1uUk9NWGxQTFdGbVVYYxAB',
    5, 'ru', 'была сегодня очень счастлива, увидев новые щеточки! они, как перышки лебедя! взамен тех классических жестких, которые используют в большинстве студий! спасибо вам за это обновление! у меня очень тонкая и чувствительная кожа вокруг ногтей, и жесткие щетки создавали дискомфорт! уровень качества и сервиса iPodo - как всегда, на высоте💛',
    'danas sam bila presrećna kad sam vidjela nove četkice! meke su kao labudovo perje! umjesto onih klasičnih tvrdih, koje koristi većina studija! hvala vam na ovoj novini! koža oko mojih noktiju je vrlo tanka i osjetljiva, pa su tvrde četkice stvarale nelagodu! nivo kvaliteta i servisa u iPodo - kao i uvijek, na najvišem nivou💛', 'данас сам била пресрећна кад сам видјела нове четкице! меке су као лабудово перје! умјесто оних класичних тврдих, које користи већина студија! хвала вам на овој новини! кожа око мојих ноктију је врло танка и осјетљива, па су тврде четкице стварале нелагоду! ниво квалитета и сервиса у iPodo - као и увијек, на највишем нивоу💛', 'today I was so happy to see the new brushes! they\'re as soft as swan feathers! instead of those classic stiff ones that most studios use! thank you for this upgrade! the skin around my nails is very thin and sensitive, and the stiff brushes were uncomfortable! the level of quality and service at iPodo - as always, top notch💛', 'была сегодня очень счастлива, увидев новые щеточки! они, как перышки лебедя! взамен тех классических жестких, которые используют в большинстве студий! спасибо вам за это обновление! у меня очень тонкая и чувствительная кожа вокруг ногтей, и жесткие щетки создавали дискомфорт! уровень качества и сервиса iPodo - как всегда, на высоте💛', 'ich war heute überglücklich, als ich die neuen Bürstchen gesehen habe! sie sind weich wie Schwanenfedern! anstelle dieser klassischen harten, die in den meisten Studios benutzt werden! danke für diese Neuerung! die Haut um meine Nägel ist sehr dünn und empfindlich, und die harten Bürsten waren unangenehm! das Qualitäts- und Serviceniveau von iPodo - wie immer erste Klasse💛', 'bugün yeni fırçaları görünce çok mutlu oldum! kuğu tüyü gibi yumuşacık! çoğu stüdyoda kullanılan o klasik sert fırçaların yerine! bu yenilik için teşekkürler! tırnaklarımın çevresindeki cilt çok ince ve hassas, sert fırçalar rahatsızlık veriyordu! iPodo\'nun kalite ve hizmet düzeyi - her zaman olduğu gibi en üst seviyede💛',
    0, '2025-12-03 00:00:00'),

(@user_elina_likar, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSeWJrOXFVMUV4Y0RWcmJVTlJUVjlaTFVGdVpIYxAB',
    5, 'ru', 'Очень довольна — радуюсь, что вернулась к гель-лаку и выбрала iPODO. София — бережный и деликатный мастер, мне никогда в жизни так быстро и так аккуратно при этом не делали маникюр:)
Делала 2 недели назад — выглядит и держится все еще идеально.

И сам салон внутри просто прекрасный — спокойно и уютно.

Вернусь еще 🫶🏽',
    'Vrlo sam zadovoljna — radujem se što sam se vratila gel-laku i izabrala iPODO. Sofija je pažljiva i delikatna majstorica, nikad mi u životu nisu tako brzo i pri tome tako precizno uradili manikir:)
Radila sam ga prije 2 nedjelje — i dalje izgleda i drži se savršeno.

A i sam salon je iznutra prosto prekrasan — mirno i prijatno.

Vratiću se opet 🫶🏽', 'Врло сам задовољна — радујем се што сам се вратила гел-лаку и изабрала iPODO. Софија је пажљива и деликатна мајсторица, никад ми у животу нису тако брзо и при томе тако прецизно урадили маникир:)
Радила сам га прије 2 недјеље — и даље изгледа и држи се савршено.

А и сам салон је изнутра просто прекрасан — мирно и пријатно.

Вратићу се опет 🫶🏽', 'Very happy — I\'m so glad I went back to gel polish and chose iPODO. Sofija is a gentle and careful specialist, never in my life has anyone done my manicure so fast and so neatly at the same time:)
I had it done 2 weeks ago — it still looks and holds up perfectly.

And the salon itself is just lovely inside — calm and cosy.

I\'ll be back 🫶🏽', 'Очень довольна — радуюсь, что вернулась к гель-лаку и выбрала iPODO. София — бережный и деликатный мастер, мне никогда в жизни так быстро и так аккуратно при этом не делали маникюр:)
Делала 2 недели назад — выглядит и держится все еще идеально.

И сам салон внутри просто прекрасный — спокойно и уютно.

Вернусь еще 🫶🏽', 'Sehr zufrieden — ich freue mich, dass ich zum Gel-Lack zurückgekehrt bin und iPODO gewählt habe. Sofija ist eine behutsame und feinfühlige Spezialistin, noch nie in meinem Leben wurde meine Manikür so schnell und dabei so sauber gemacht:)
Ich war vor 2 Wochen dort — es sieht immer noch perfekt aus und hält einwandfrei.

Und das Studio selbst ist innen einfach wunderschön — ruhig und gemütlich.

Ich komme wieder 🫶🏽', 'Çok memnunum — kalıcı ojeye geri döndüğüme ve iPODO\'yu seçtiğime sevindim. Sofija özenli ve nazik bir uzman, hayatım boyunca manikürüm hiç bu kadar hızlı ve bir yandan bu kadar düzgün yapılmamıştı:)
2 hafta önce yaptırdım — hâlâ kusursuz görünüyor ve duruyor.

Salonun içi de gerçekten çok güzel — sakin ve huzurlu.

Yine geleceğim 🫶🏽',
    0, '2025-12-03 00:00:00'),

(@user_svetlana_ivanova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT205eGJYRlJjbXhZUmxwVFZIVlZMVkl4YW14dU5XYxAB',
    5, 'ru', 'Самый лучший профессионал - подолог Анна Геннадьевна ! Нижайший поклон , все самые лучшие эпитеты в ее адрес ! Большое спасибо',
    'Najbolji profesionalac - podolog Anna Gennadjevna ! Duboki poklon , sve najljepše riječi na njenu adresu ! Veliko hvala', 'Најбољи професионалац - подолог Ана Гењадјевна ! Дубоки поклон , све најљепше ријечи на њену адресу ! Велико хвала', 'The very best professional - podiatrist Anna Gennadievna ! My deepest bow , all the finest words for her ! Many thanks', 'Самый лучший профессионал - подолог Анна Геннадьевна ! Нижайший поклон , все самые лучшие эпитеты в ее адрес ! Большое спасибо', 'Die allerbeste Fachkraft - Podologin Anna Gennadjewna ! Tiefste Verbeugung , alle schönsten Worte für sie ! Vielen Dank', 'En iyi profesyonel - podolog Anna Gennadyevna ! Önünde saygıyla eğiliyorum , onun için en güzel sözler ! Çok teşekkürler',
    0, '2025-12-03 00:00:00'),

(@user_nadezhda_ivanenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21KNlFTMDVVR3BpYm0xVVZsbHpiM0ZZY1dGRFJsRRAB',
    5, 'ru', 'Отличный салон, всегда приятный и вежливый сервис. Отличные мастера, делаю педикюр у мастера Натали, настоящий профессионал, спасает меня с моими непростыми ногтями. Вообще атмосфера прекрасная, все с улыбкой. Отдельное спасибо администратору Камиле, помогла с выбором подарка близкому человеку.',
    'Odličan salon, servis je uvijek prijatan i ljubazan. Odlične majstorice, pedikir radim kod Natali, prava profesionalka, spašava me sa mojim komplikovanim noktima. Uopšte, atmosfera je prekrasna, svi su nasmijani. Posebno hvala administratorki Kamili, pomogla mi je da izaberem poklon za dragu osobu.', 'Одличан салон, сервис је увијек пријатан и љубазан. Одличне мајсторице, педикир радим код Натали, права професионалка, спашава ме са мојим компликованим ноктима. Уопште, атмосфера је прекрасна, сви су насмијани. Посебно хвала администраторки Камили, помогла ми је да изаберем поклон за драгу особу.', 'Excellent salon, the service is always pleasant and polite. Excellent specialists, I get my pedicure with Natali, a true professional, she saves me and my tricky nails. The atmosphere is wonderful overall, everyone is smiling. Special thanks to the receptionist Kamila, she helped me pick out a gift for someone close to me.', 'Отличный салон, всегда приятный и вежливый сервис. Отличные мастера, делаю педикюр у мастера Натали, настоящий профессионал, спасает меня с моими непростыми ногтями. Вообще атмосфера прекрасная, все с улыбкой. Отдельное спасибо администратору Камиле, помогла с выбором подарка близкому человеку.', 'Ausgezeichnetes Studio, der Service ist immer angenehm und höflich. Ausgezeichnete Spezialistinnen, meine Pediküre mache ich bei Natali, eine echte Profi, sie rettet mich mit meinen schwierigen Nägeln. Die Atmosphäre ist insgesamt wunderbar, alle lächeln. Besonderen Dank an die Empfangsdame Kamila, sie hat mir bei der Auswahl eines Geschenks für einen lieben Menschen geholfen.', 'Harika bir salon, hizmet her zaman keyifli ve nazik. Uzmanlar harika, pedikürümü Natali\'ye yaptırıyorum, gerçek bir profesyonel, zor tırnaklarımla beni kurtarıyor. Genel olarak atmosfer çok güzel, herkes gülümsüyor. Resepsiyonist Kamila\'ya ayrıca teşekkürler, sevdiğim biri için hediye seçmemde yardımcı oldu.',
    0, '2025-12-03 00:00:00'),

(@user_vladislava, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pJNVNXcFdWWGx1VWxKUWVubGpOVmt3YjNoUGNYYxAB',
    5, 'ru', 'Я в iPodo уже 7 лет делаю маникюр и педикюр. Сначала Анюта была моим мастером, потом она передала меня в бережные руки Софии и Наташи ☺️ - девочки - вы лучшие! спасибо вам за заботу 🤗',
    'Već 7 godina radim manikir i pedikir u iPodo. Prvo je Anjuta bila moja majstorica, a onda me je predala u pažljive ruke Sofije i Nataše ☺️ - djevojke - vi ste najbolje! hvala vam na brizi 🤗', 'Већ 7 година радим маникир и педикир у iPodo. Прво је Ањута била моја мајсторица, а онда ме је предала у пажљиве руке Софије и Наташе ☺️ - дјевојке - ви сте најбоље! хвала вам на бризи 🤗', 'I\'ve been getting my manicures and pedicures at iPodo for 7 years now. At first Anjuta was my specialist, then she handed me over to the gentle hands of Sofija and Natasha ☺️ - girls - you\'re the best! thank you for taking such good care of me 🤗', 'Я в iPodo уже 7 лет делаю маникюр и педикюр. Сначала Анюта была моим мастером, потом она передала меня в бережные руки Софии и Наташи ☺️ - девочки - вы лучшие! спасибо вам за заботу 🤗', 'Ich mache meine Manikür und Pediküre schon seit 7 Jahren bei iPodo. Zuerst war Anjuta meine Spezialistin, dann hat sie mich in die behutsamen Hände von Sofija und Natascha übergeben ☺️ - Mädels - ihr seid die Besten! danke für eure Fürsorge 🤗', '7 yıldır manikür ve pedikürümü iPodo\'da yaptırıyorum. Önce Anjuta benim uzmanımdı, sonra beni Sofija ve Natasha\'nın özenli ellerine teslim etti ☺️ - kızlar - siz harikasınız! ilginiz için teşekkürler 🤗',
    0, '2025-12-03 00:00:00'),

(@user_kristina_kushnir, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xWWmRYTnNhRTlST0RSWmRFMDBlalJIWlVwWFEwRRAB',
    5, 'ru', 'У Софии делаю маникюр и педикюр уже не первый раз - каждый визит одно удовольствие! 🌸 Отличный мастер, работает чисто и внимательно. Рекомендую! Спасибо iPODO за приятную атмосферу и качественную работу! …',
    'Kod Sofije radim manikir i pedikir već više puta - svaka posjeta je pravo zadovoljstvo! 🌸 Odlična majstorica, radi čisto i pažljivo. Preporučujem! Hvala iPODO na prijatnoj atmosferi i kvalitetnom radu! …', 'Код Софије радим маникир и педикир већ више пута - свака посјета је право задовољство! 🌸 Одлична мајсторица, ради чисто и пажљиво. Препоручујем! Хвала iPODO на пријатној атмосфери и квалитетном раду! …', 'This isn\'t my first manicure and pedicure with Sofija - every visit is a pure pleasure! 🌸 Excellent specialist, works cleanly and attentively. I recommend her! Thank you iPODO for the pleasant atmosphere and quality work! …', 'У Софии делаю маникюр и педикюр уже не первый раз - каждый визит одно удовольствие! 🌸 Отличный мастер, работает чисто и внимательно. Рекомендую! Спасибо iPODO за приятную атмосферу и качественную работу! …', 'Ich mache meine Manikür und Pediküre nicht zum ersten Mal bei Sofija - jeder Besuch ist ein reines Vergnügen! 🌸 Ausgezeichnete Spezialistin, arbeitet sauber und aufmerksam. Ich empfehle sie! Danke iPODO für die angenehme Atmosphäre und die hochwertige Arbeit! …', 'Sofija\'ya manikür ve pedikür yaptırmam ilk kez değil - her gelişim tam bir keyif! 🌸 Harika bir uzman, temiz ve özenli çalışıyor. Tavsiye ederim! Hoş atmosfer ve kaliteli iş için iPODO\'ya teşekkürler! …',
    0, '2025-12-03 00:00:00'),

(@user_ana_milosavljevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25ocVRtRTJVMlV6WmxkWFJHWjBSRk5uTmxCVWVFRRAB',
    5, 'bs', 'Aleksandra mi radi pedikir i sve preporuke. Nisu medju jeftinijima ali za tu uslugu i sve sterilisano vredi.',
    'Aleksandra mi radi pedikir i sve preporuke. Nisu medju jeftinijima ali za tu uslugu i sve sterilisano vredi.', 'Александра ми ради педикир и све препоруке. Нису међу јефтинијима али за ту услугу и све стерилисано вриједи.', 'Aleksandra does my pedicure and I highly recommend them. They\'re not among the cheapest, but for that service and everything being sterilised, it\'s worth it.', 'Педикюр мне делает Александра, всячески рекомендую. Они не из самых дешёвых, но за такую услугу и полную стерильность это того стоит.', 'Aleksandra macht meine Pediküre und ich kann es nur empfehlen. Sie gehören nicht zu den günstigsten, aber für diesen Service und alles steril ist es das wert.', 'Pedikürümü Aleksandra yapıyor, kesinlikle tavsiye ederim. En ucuzlardan değiller ama bu hizmet ve her şeyin sterilize olması için buna değer.',
    0, '2025-12-03 00:00:00'),

(@user_olga_shvets, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTUNRMHRucnNRRRAB',
    5, 'ru', 'Очень рекомендую маникюр и педикюр у Софии и Натальи .',
    'Toplo preporučujem manikir i pedikir kod Sofije i Natalije .', 'Топло препоручујем маникир и педикир код Софије и Наталије .', 'I highly recommend a manicure and pedicure with Sofija and Natalija .', 'Очень рекомендую маникюр и педикюр у Софии и Натальи .', 'Ich empfehle Manikür und Pediküre bei Sofija und Natalija sehr .', 'Sofija ve Natalija\'da manikür ve pedikürü kesinlikle tavsiye ederim .',
    0, '2025-12-03 00:00:00'),

(@user_inna_chalueva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT205aloyNXpWbXh3VW1KTWVuRkpVemxpYlVkdWIwRRAB',
    5, 'ru', 'Хожу к Светлане на маникюр и педикюр больше 2х лет и всегда всё идеально 👌 Спасибо! …',
    'Kod Svetlane idem na manikir i pedikir više od 2 godine i uvijek je sve savršeno 👌 Hvala! …', 'Код Светлане идем на маникир и педикир више од 2 године и увијек је све савршено 👌 Хвала! …', 'I\'ve been going to Svetlana for manicures and pedicures for over 2 years and it\'s always perfect 👌 Thank you! …', 'Хожу к Светлане на маникюр и педикюр больше 2х лет и всегда всё идеально 👌 Спасибо! …', 'Ich gehe seit über 2 Jahren zu Svetlana für Manikür und Pediküre und es ist immer perfekt 👌 Danke! …', '2 yıldan fazla bir süredir manikür ve pedikür için Svetlana\'ya gidiyorum ve her zaman her şey kusursuz 👌 Teşekkürler! …',
    0, '2025-12-03 00:00:00'),

(@user_lev_alekseev, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25Gd1VUWlZVRGM1Tm1aVVppMUZjbTlLWVRSb2NsRRAB',
    5, 'ru', 'Был на маникюре в центре. Все очень понравилось, сервис отличный приятные люди. Был у мастера Софии быстро, четко, безболезненно.',
    'Bio sam na manikiru u centru. Sve mi se vrlo dopalo, servis je odličan prijatni ljudi. Bio sam kod Sofije brzo, precizno, bezbolno.', 'Био сам на маникиру у центру. Све ми се врло допало, сервис је одличан пријатни људи. Био сам код Софије брзо, прецизно, безболно.', 'I had a manicure at the centre. I liked everything a lot, great service nice people. I went to Sofija - fast, precise, painless.', 'Был на маникюре в центре. Все очень понравилось, сервис отличный приятные люди. Был у мастера Софии быстро, четко, безболезненно.', 'Ich war zur Manikür im Zentrum. Mir hat alles sehr gefallen, der Service ist ausgezeichnet angenehme Menschen. Ich war bei Sofija - schnell, präzise, schmerzfrei.', 'Merkezde manikür yaptırdım. Her şey çok hoşuma gitti, hizmet harika hoş insanlar. Sofija\'ya gittim - hızlı, düzgün, acısız.',
    0, '2025-12-03 00:00:00'),

(@user_anna_loginova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GRlZFbDBiakZWYldVelpVZzFUSFY0YWswd2VGRRAB',
    5, 'ru', 'Хожу в этот салон на маникюр и педикюр к мастеру Софии уже не первый год. Всегда получается прекрасно - София учитывает все нюансы вроде близких сосудов, высокой чувствительности, тонкой кутикулы и склонных к врастанию ногтей, а также любви к сложносочинённой цветовой гамме. А ещё с ней приятно и интересно разговаривать',
    'U ovaj salon idem na manikir i pedikir kod Sofije već nekoliko godina. Uvijek ispadne prekrasno - Sofija uzima u obzir sve nijanse kao što su blizu smješteni krvni sudovi, visoka osjetljivost, tanka zanoktica i nokti skloni urastanju, a i moju ljubav prema komplikovanim kombinacijama boja. A uz to je s njom prijatno i zanimljivo razgovarati', 'У овај салон идем на маникир и педикир код Софије већ неколико година. Увијек испадне прекрасно - Софија узима у обзир све нијансе као што су близу смјештени крвни судови, висока осјетљивост, танка заноктица и нокти склони урастању, а и моју љубав према компликованим комбинацијама боја. А уз то је с њом пријатно и занимљиво разговарати', 'I\'ve been coming to this salon for manicures and pedicures with Sofija for several years now. It always turns out beautifully - Sofija takes into account every nuance, like blood vessels sitting close to the surface, high sensitivity, thin cuticles and nails prone to ingrowing, as well as my love for elaborate colour combinations. And on top of that, she\'s lovely and interesting to talk to', 'Хожу в этот салон на маникюр и педикюр к мастеру Софии уже не первый год. Всегда получается прекрасно - София учитывает все нюансы вроде близких сосудов, высокой чувствительности, тонкой кутикулы и склонных к врастанию ногтей, а также любви к сложносочинённой цветовой гамме. А ещё с ней приятно и интересно разговаривать', 'Ich komme schon seit mehreren Jahren für Manikür und Pediküre zu Sofija in dieses Studio. Es wird immer wunderschön - Sofija berücksichtigt alle Feinheiten wie oberflächennahe Blutgefäße, hohe Empfindlichkeit, dünne Nagelhaut und zum Einwachsen neigende Nägel, und auch meine Liebe zu aufwendigen Farbkombinationen. Und außerdem ist es angenehm und interessant, sich mit ihr zu unterhalten', 'Bu salona manikür ve pedikür için Sofija\'ya yıllardır gidiyorum. Sonuç her zaman muhteşem oluyor - Sofija yüzeye yakın damarlar, yüksek hassasiyet, ince tırnak eti ve batmaya eğilimli tırnaklar gibi tüm ayrıntıları, ayrıca karmaşık renk kombinasyonlarına olan sevgimi de dikkate alıyor. Üstelik onunla sohbet etmek keyifli ve ilgi çekici',
    0, '2025-12-03 00:00:00'),

(@user_zhenya_zhenya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxMlVERnpZekphVEhBMFRGZFZNSEZDVkZoQ2NXYxAB',
    5, 'ru', 'Отличный маникюр. Мастеру Софии огромное спасибо.',
    'Odličan manikir. Ogromno hvala majstorici Sofiji.', 'Одличан маникир. Огромно хвала мајсторици Софији.', 'Excellent manicure. Huge thanks to Sofija.', 'Отличный маникюр. Мастеру Софии огромное спасибо.', 'Ausgezeichnete Manikür. Riesigen Dank an Sofija.', 'Harika bir manikür. Uzman Sofija\'ya kocaman teşekkürler.',
    0, '2025-12-03 00:00:00'),

(@user_anna_anna, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21Ka1RrRldORVJhTlU4NFYyZFFiR0ptZUdGc05sRRAB',
    5, 'ru', 'София просто чудо мастер, хожу к ней регулярно на маникюр и педикюр, очень чуткая, вежливая и профессиональная.',
    'Sofija je prosto čudo od majstorice, idem kod nje redovno na manikir i pedikir, vrlo je obazriva, ljubazna i profesionalna.', 'Софија је просто чудо од мајсторице, идем код ње редовно на маникир и педикир, врло је обазрива, љубазна и професионална.', 'Sofija is simply a wonder of a specialist, I go to her regularly for manicures and pedicures, she\'s very attentive, polite and professional.', 'София просто чудо мастер, хожу к ней регулярно на маникюр и педикюр, очень чуткая, вежливая и профессиональная.', 'Sofija ist einfach ein Wunder von einer Spezialistin, ich gehe regelmäßig zu ihr für Manikür und Pediküre, sie ist sehr einfühlsam, höflich und professionell.', 'Sofija tam bir harika, düzenli olarak manikür ve pedikür için ona gidiyorum, çok özenli, nazik ve profesyonel.',
    0, '2025-12-03 00:00:00'),

(@user_olga_teodorskaya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT201dFdtWTRjbFZpU1dsRU5GRmhMWHBTTVVWV1VHYxAB',
    5, 'ru', 'Посещаю салон постоянно, огромное спасибо администратору Камиле, она создает теплую атмосферу, что в салоне чувствуешь себя как дома',
    'Salon posjećujem stalno, ogromno hvala administratorki Kamili, ona stvara toplu atmosferu, tako da se u salonu osjećaš kao kod kuće', 'Салон посјећујем стално, огромно хвала администраторки Камили, она ствара топлу атмосферу, тако да се у салону осјећаш као код куће', 'I visit this salon all the time, huge thanks to the receptionist Kamila, she creates such a warm atmosphere that you feel at home in the salon', 'Посещаю салон постоянно, огромное спасибо администратору Камиле, она создает теплую атмосферу, что в салоне чувствуешь себя как дома', 'Ich besuche das Studio regelmäßig, riesigen Dank an die Empfangsdame Kamila, sie schafft eine so warme Atmosphäre, dass man sich im Studio wie zu Hause fühlt', 'Salona sürekli gidiyorum, resepsiyonist Kamila\'ya kocaman teşekkürler, öyle sıcak bir atmosfer yaratıyor ki salonda kendini evinde gibi hissediyorsun',
    0, '2025-12-03 00:00:00'),

(@user_anastasia_nikiforova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSaE9UbFJibHB5T0ZaVlZFcDZZa0ZETW5GdmFXYxAB',
    5, 'ru', 'Отличный салон! Результат превзошел ожидания. Очень уютная атмосфера, приветливый персонал. Особенно хотела бы отметить работу администратора Камиллы ❤️',
    'Odličan salon! Rezultat je nadmašio očekivanja. Vrlo prijatna atmosfera, ljubazno osoblje. Posebno bih željela da istaknem rad administratorke Kamille ❤️', 'Одличан салон! Резултат је надмашио очекивања. Врло пријатна атмосфера, љубазно особље. Посебно бих жељела да истакнем рад администраторке Камиле ❤️', 'Excellent salon! The result exceeded my expectations. Very cosy atmosphere, friendly staff. I\'d especially like to highlight the work of the receptionist Kamilla ❤️', 'Отличный салон! Результат превзошел ожидания. Очень уютная атмосфера, приветливый персонал. Особенно хотела бы отметить работу администратора Камиллы ❤️', 'Ausgezeichnetes Studio! Das Ergebnis hat meine Erwartungen übertroffen. Sehr gemütliche Atmosphäre, freundliches Personal. Besonders hervorheben möchte ich die Arbeit der Empfangsdame Kamilla ❤️', 'Harika bir salon! Sonuç beklentilerimi aştı. Çok huzurlu bir atmosfer, güler yüzlü personel. Özellikle resepsiyonist Kamilla\'nın işini övmek isterim ❤️',
    0, '2025-12-03 00:00:00'),

(@user_daria_daria, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xReGJ6WjBjbWxTYVZWWE5GUkZNbEJOWW1sclVWRRAB',
    5, 'ru', 'Спасибо результатом довольна  . Отдельное спасибо Камилле все объяснила !!',
    'Hvala, zadovoljna sam rezultatom  . Posebno hvala Kamilli, sve mi je objasnila !!', 'Хвала, задовољна сам резултатом  . Посебно хвала Камили, све ми је објаснила !!', 'Thank you, I\'m happy with the result  . Special thanks to Kamilla, she explained everything !!', 'Спасибо результатом довольна  . Отдельное спасибо Камилле все объяснила !!', 'Danke, ich bin mit dem Ergebnis zufrieden  . Besonderen Dank an Kamilla, sie hat mir alles erklärt !!', 'Teşekkürler, sonuçtan memnunum  . Kamilla\'ya ayrıca teşekkürler, her şeyi anlattı !!',
    0, '2025-12-03 00:00:00'),

(@user_egor_dudkin, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25kcFh6TkVXbVZUUzFsT1VVUkdkVzV6ZVd4TGIyYxAB',
    5, 'ru', 'Центр супер, админ Камилла топ!',
    'Centar je super, administratorka Kamila je top!', 'Центар је супер, администраторка Камила је топ!', 'The centre is awesome, the receptionist Kamila is top!', 'Центр супер, админ Камилла топ!', 'Das Zentrum ist super, die Empfangsdame Kamila ist top!', 'Merkez süper, resepsiyonist Kamila harika!',
    0, '2025-12-03 00:00:00'),

(@user_nedzhe_nedzhe, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21vNVJGQmFkekowYWs5bVV6VkdWVWhxYmw5SmFGRRAB',
    5, 'ru', 'Все понравилось, делал педикюр, администратор Камилла была очень любезна:)',
    'Sve mi se svidjelo, radio sam pedikir, administratorka Kamila je bila veoma ljubazna:)', 'Све ми се свидјело, радио сам педикир, администраторка Камила је била веома љубазна:)', 'I liked everything, I had a pedicure done, the receptionist Kamila was very kind:)', 'Все понравилось, делал педикюр, администратор Камилла была очень любезна:)', 'Mir hat alles gefallen, ich habe eine Fußpflege machen lassen, die Empfangsdame Kamila war sehr freundlich:)', 'Her şeyi beğendim, pedikür yaptırdım, resepsiyonist Kamila çok kibardı:)',
    0, '2025-12-03 00:00:00'),

(@user_misha_misha, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xOTlNtNVRWelZoTVcxWVMyeEtVbWt5YWxOdVluYxAB',
    5, 'ru', 'Отправлял жену , вернули на 10 лет моложе , снова влюбился. Спасибо большое менеджеру Камилле, за спасение нашего брака. Супер центр , супер профессионалы, большие мастера своего дела !!!! ❤️❤️❤️',
    'Poslao sam ženu , vratili su mi je 10 godina mlađu , ponovo sam se zaljubio. Veliko hvala menadžerki Kamili, što je spasila naš brak. Super centar , super profesionalci, veliki majstori svog posla !!!! ❤️❤️❤️', 'Послао сам жену , вратили су ми је 10 година млађу , поново сам се заљубио. Велико хвала менаџерки Камили, што је спасила наш брак. Супер центар , супер професионалци, велики мајстори свог посла !!!! ❤️❤️❤️', 'I sent my wife in , they gave her back to me 10 years younger , I fell in love all over again. Huge thanks to the manager Kamila for saving our marriage. Super centre , super professionals, true masters of their craft !!!! ❤️❤️❤️', 'Отправлял жену , вернули на 10 лет моложе , снова влюбился. Спасибо большое менеджеру Камилле, за спасение нашего брака. Супер центр , супер профессионалы, большие мастера своего дела !!!! ❤️❤️❤️', 'Ich habe meine Frau hingeschickt , sie kam 10 Jahre jünger zurück , ich habe mich neu verliebt. Riesiges Dankeschön an die Managerin Kamila für die Rettung unserer Ehe. Super Zentrum , super Profis, große Meister ihres Fachs !!!! ❤️❤️❤️', 'Eşimi gönderdim , bana 10 yaş gençleşmiş halde geri verdiler , yeniden aşık oldum. Evliliğimizi kurtardığı için müdür Kamila\'ya çok teşekkürler. Süper merkez , süper profesyoneller, işinin gerçek ustaları !!!! ❤️❤️❤️',
    0, '2025-12-03 00:00:00'),

(@user_anna_pivovarova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25CRE1qTk5aa1EwT0Y5ME9FcEpkWGRtVGpsb1pXYxAB',
    5, 'ru', 'Работала с подологом Анной, которая буквально спасла мои разрушенные ногти на больших пальцах. Потребовалось время, но результат не может не радовать)',
    'Radila sam sa podologom Anom, koja je bukvalno spasila moje uništene nokte na palcima. Trebalo je vremena, ali rezultat ne može da ne obraduje)', 'Радила сам са подологом Аном, која је буквално спасила моје уништене нокте на палцима. Требало је времена, али резултат не може да не обрадује)', 'I worked with the podiatrist Anna, who literally saved my ruined big toenails. It took time, but the result can\'t help but make you happy)', 'Работала с подологом Анной, которая буквально спасла мои разрушенные ногти на больших пальцах. Потребовалось время, но результат не может не радовать)', 'Ich war bei der Podologin Anna, die meine zerstörten Nägel an den großen Zehen buchstäblich gerettet hat. Es hat Zeit gebraucht, aber über das Ergebnis kann man sich nur freuen)', 'Podolog Anna ile çalıştım, başparmaklarımdaki harap olmuş tırnaklarımı gerçekten kurtardı. Zaman aldı ama sonuç insanı sevindirmekten başka bir şey yapmıyor)',
    0, '2025-12-03 00:00:00'),

(@user_lana_makarova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21wV1RtaE9kREYyUlhnemVtVlNVMmRGV0MxNlRVRRAB',
    5, 'ru', '⭐⭐⭐⭐⭐
Была на приёме у подолога Натальи и хочу оставить искренний отзыв. Наталья работает очень аккуратно и профессионально — чувствуется, что специалист действительно знает своё дело. Все этапы объясняет, интересуется комфортом, делает максимально бережно. Результат превзошёл ожидания:  исчез дискомфорт, а рекомендации по уходу оказались очень полезными.

Отдельно хочу отметить администратора Тамилу. Встречает с улыбкой, всё подскажет, заранее напоминает о записи и создаёт такую доброжелательную атмосферу, что уже с порога чувствуешь себя комфортно.

Большое спасибо за внимание, заботу и высокий уровень сервиса. С удовольствием буду возвращаться и могу смело рекомендовать!',
    '⭐⭐⭐⭐⭐
Bila sam na tretmanu kod podologa Natalije i želim da ostavim iskrenu recenziju. Natalija radi veoma pažljivo i profesionalno — osjeti se da stručnjak stvarno zna svoj posao. Objašnjava svaku fazu, pita da li ti je prijatno, radi maksimalno nježno. Rezultat je nadmašio očekivanja: nelagoda je nestala, a savjeti za njegu su se pokazali veoma korisnim.

Posebno želim da pohvalim administratorku Tamilu. Dočekuje sa osmijehom, sve će ti objasniti, unaprijed podsjeti na termin i stvara toliko prijatnu atmosferu da se već od ulaza osjećaš prijatno.

Veliko hvala za pažnju, brigu i visok nivo usluge. Sa zadovoljstvom ću se vraćati i mogu slobodno da preporučim!', '⭐⭐⭐⭐⭐
Била сам на третману код подолога Наталије и желим да оставим искрену рецензију. Наталија ради веома пажљиво и професионално — осјети се да стручњак стварно зна свој посао. Објашњава сваку фазу, пита да ли ти је пријатно, ради максимално њежно. Резултат је надмашио очекивања: нелагода је нестала, а савјети за његу су се показали веома корисним.

Посебно желим да похвалим администраторку Тамилу. Дочекује са осмијехом, све ће ти објаснити, унапријед подсјети на термин и ствара толико пријатну атмосферу да се већ од улаза осјећаш пријатно.

Велико хвала за пажњу, бригу и висок ниво услуге. Са задовољством ћу се враћати и могу слободно да препоручим!', '⭐⭐⭐⭐⭐
I had an appointment with the podiatrist Natalia and I want to leave an honest review. Natalia works very carefully and professionally — you can tell the specialist really knows her craft. She explains every step, checks that you\'re comfortable, and works as gently as possible. The result exceeded my expectations: the discomfort is gone, and the aftercare advice turned out to be very useful.

I\'d also like to give a special mention to the receptionist Tamila. She greets you with a smile, explains everything, reminds you about your appointment in advance and creates such a warm atmosphere that you feel comfortable the moment you walk in.

Many thanks for the attention, the care and the high level of service. I\'ll be coming back with pleasure and I can confidently recommend it!', '⭐⭐⭐⭐⭐
Была на приёме у подолога Натальи и хочу оставить искренний отзыв. Наталья работает очень аккуратно и профессионально — чувствуется, что специалист действительно знает своё дело. Все этапы объясняет, интересуется комфортом, делает максимально бережно. Результат превзошёл ожидания:  исчез дискомфорт, а рекомендации по уходу оказались очень полезными.

Отдельно хочу отметить администратора Тамилу. Встречает с улыбкой, всё подскажет, заранее напоминает о записи и создаёт такую доброжелательную атмосферу, что уже с порога чувствуешь себя комфортно.

Большое спасибо за внимание, заботу и высокий уровень сервиса. С удовольствием буду возвращаться и могу смело рекомендовать!', '⭐⭐⭐⭐⭐
Ich war bei der Podologin Natalia zur Behandlung und möchte eine ehrliche Bewertung hinterlassen. Natalia arbeitet sehr sorgfältig und professionell — man merkt, dass die Spezialistin ihr Fach wirklich versteht. Sie erklärt jeden Schritt, fragt nach, ob es angenehm ist, und arbeitet so behutsam wie möglich. Das Ergebnis hat meine Erwartungen übertroffen: das unangenehme Gefühl ist verschwunden, und die Pflegetipps waren sehr hilfreich.

Besonders hervorheben möchte ich die Empfangsdame Tamila. Sie begrüßt einen mit einem Lächeln, erklärt alles, erinnert im Voraus an den Termin und schafft eine so freundliche Atmosphäre, dass man sich schon an der Tür wohlfühlt.

Vielen Dank für die Aufmerksamkeit, die Fürsorge und das hohe Serviceniveau. Ich komme mit Freude wieder und kann es guten Gewissens empfehlen!', '⭐⭐⭐⭐⭐
Podolog Natalia\'ya gittim ve içten bir yorum bırakmak istiyorum. Natalia çok özenli ve profesyonel çalışıyor — uzmanın işini gerçekten bildiği hissediliyor. Her aşamayı anlatıyor, rahat olup olmadığınızı soruyor, mümkün olduğunca nazik davranıyor. Sonuç beklentilerimi aştı: rahatsızlık geçti, bakım önerileri de çok işime yaradı.

Ayrıca resepsiyonist Tamila\'yı özellikle belirtmek isterim. Gülümseyerek karşılıyor, her şeyi anlatıyor, randevuyu önceden hatırlatıyor ve öyle sıcak bir ortam yaratıyor ki kapıdan girdiğiniz anda kendinizi rahat hissediyorsunuz.

İlginiz, özeniniz ve yüksek hizmet kaliteniz için çok teşekkürler. Zevkle tekrar geleceğim ve gönül rahatlığıyla tavsiye edebilirim!',
    0, '2025-12-03 00:00:00'),

(@user_olga_baranova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSd1dsZzNNbTF3VTFGcGEwWmxObnBDT0VzMVlWRRAB',
    5, 'ru', 'Потрясающий салон! Очень доброжелательный и ответственный администратор Камилла, безупречный маникюр от Светланы! Учитываются все пожелания клиента, даже лучше! Большое спасибо!',
    'Fantastičan salon! Veoma ljubazna i odgovorna administratorka Kamila, besprijekoran manikir od Svetlane! Uzimaju u obzir sve želje klijenta, čak i bolje od toga! Veliko hvala!', 'Фантастичан салон! Веома љубазна и одговорна администраторка Камила, беспријекоран маникир од Светлане! Узимају у обзир све жеље клијента, чак и боље од тога! Велико хвала!', 'An amazing salon! A very friendly and reliable receptionist, Kamila, and a flawless manicure by Svetlana! They take all the client\'s wishes into account, and even go beyond! Many thanks!', 'Потрясающий салон! Очень доброжелательный и ответственный администратор Камилла, безупречный маникюр от Светланы! Учитываются все пожелания клиента, даже лучше! Большое спасибо!', 'Ein fantastischer Salon! Eine sehr freundliche und zuverlässige Empfangsdame Kamila, eine tadellose Maniküre von Svetlana! Alle Wünsche der Kundin werden berücksichtigt, und sogar mehr! Vielen Dank!', 'Muhteşem bir salon! Çok güler yüzlü ve sorumluluk sahibi resepsiyonist Kamila, Svetlana\'dan kusursuz bir manikür! Müşterinin tüm isteklerini dikkate alıyorlar, hatta fazlasını! Çok teşekkürler!',
    0, '2025-12-03 00:00:00'),

(@user_anna_kosterina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tSQ1JVcGFPSEEwVjFkNFYySk5RMmx5WDI5c1FtYxAB',
    5, 'ru', 'Прекрасный салон, мастер Светлана выше всех похвал, очень приятный администратор Камилла, также очень нравится сервис и чистота',
    'Divan salon, majstorica Svetlana je iznad svake pohvale, veoma prijatna administratorka Kamila, takođe mi se veoma sviđaju usluga i čistoća', 'Диван салон, мајсторица Светлана је изнад сваке похвале, веома пријатна администраторка Камила, такође ми се веома свиђају услуга и чистоћа', 'A wonderful salon, the specialist Svetlana is beyond praise, a very pleasant receptionist Kamila, and I also really like the service and the cleanliness', 'Прекрасный салон, мастер Светлана выше всех похвал, очень приятный администратор Камилла, также очень нравится сервис и чистота', 'Ein wunderbarer Salon, die Fachkraft Svetlana ist über jedes Lob erhaben, eine sehr angenehme Empfangsdame Kamila, und mir gefallen auch der Service und die Sauberkeit sehr', 'Harika bir salon, uzman Svetlana her türlü övgünün üzerinde, resepsiyonist Kamila çok hoş biri, ayrıca hizmeti ve temizliği de çok beğeniyorum',
    0, '2025-12-03 00:00:00'),

(@user_talya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VOYVZ2cDZKc3FHZk1nEAE',
    5, 'en', 'The environment was very clean and attentive, so were the experts working there. Everyone was very interested and smiling , I first went there for a problem with my foot, and it was well-taken care of and resolved. Then I went on to get permanent nail polish, and I still go. I\'d like to thank your specialist for taking care of me, then Camia at the reception, and Alexandra for taking care of my nails.
Talya.',
    'Prostor je bio veoma čist i uredan, kao i stručnjaci koji tamo rade. Svi su bili veoma zainteresovani i nasmijani , prvi put sam došla zbog problema sa stopalom, i sve je bilo odlično riješeno i sanirano. Poslije toga sam počela da radim i trajni lak, i još uvijek idem. Želim da se zahvalim vašoj specijalistkinji što se pobrinula za mene, zatim Camii na recepciji, i Alexandri što se pobrinula za moje nokte.
Talya.', 'Простор је био веома чист и уредан, као и стручњаци који тамо раде. Сви су били веома заинтересовани и насмијани , први пут сам дошла због проблема са стопалом, и све је било одлично ријешено и санирано. Послије тога сам почела да радим и трајни лак, и још увијек идем. Желим да се захвалим вашој специјалисткињи што се побринула за мене, затим Камији на рецепцији, и Александри што се побринула за моје нокте.
Таља.', 'The environment was very clean and attentive, so were the experts working there. Everyone was very interested and smiling , I first went there for a problem with my foot, and it was well-taken care of and resolved. Then I went on to get permanent nail polish, and I still go. I\'d like to thank your specialist for taking care of me, then Camia at the reception, and Alexandra for taking care of my nails.
Talya.', 'Обстановка была очень чистая и ухоженная, и специалисты, которые там работают, тоже. Все были очень внимательные и улыбчивые , сначала я пришла с проблемой со стопой, и с ней прекрасно разобрались и всё решили. Потом стала делать ещё и покрытие гель-лаком, и продолжаю ходить. Хочу поблагодарить вашу специалистку за заботу обо мне, затем Камию на ресепшене и Александру за мои ногти.
Talya.', 'Die Umgebung war sehr sauber und gepflegt, ebenso die Fachkräfte, die dort arbeiten. Alle waren sehr aufmerksam und freundlich , zuerst kam ich mit einem Problem am Fuß, und darum wurde sich gut gekümmert, es wurde behoben. Danach habe ich mir auch noch Permanentlack machen lassen und gehe immer noch hin. Ich möchte Ihrer Spezialistin dafür danken, dass sie sich um mich gekümmert hat, dann Camia am Empfang und Alexandra für die Pflege meiner Nägel.
Talya.', 'Mekân çok temiz ve düzenliydi, orada çalışan uzmanlar da öyle. Herkes çok ilgili ve güler yüzlüydü , ilk olarak ayağımdaki bir sorun için gittim ve sorunla çok iyi ilgilenildi, çözüldü. Sonrasında kalıcı oje de yaptırmaya başladım ve hâlâ gidiyorum. Benimle ilgilendiği için uzmanınıza, sonra resepsiyondaki Camia\'ya ve tırnaklarımla ilgilendiği için Alexandra\'ya teşekkür etmek istiyorum.
Talya.',
    0, '2025-12-03 00:00:00'),

(@user_irina_m, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twaVVqWnVYMXBqVGpOclVWcEhkRGM0UzFkR1ZrRRAB',
    5, 'ru', 'Хочу поблагодарить мастера Софию за отлично сделанный маникюр. В ее работе нравится техника выполнения, всегда внимательное и уважительное отношение.',
    'Želim da se zahvalim majstorici Sofiji za odlično urađen manikir. U njenom radu mi se sviđa tehnika izvođenja, uvijek pažljiv i pun poštovanja odnos.', 'Желим да се захвалим мајсторици Софији за одлично урађен маникир. У њеном раду ми се свиђа техника извођења, увијек пажљив и пун поштовања однос.', 'I want to thank the specialist Sofia for a perfectly done manicure. What I like about her work is her technique, and she is always attentive and respectful.', 'Хочу поблагодарить мастера Софию за отлично сделанный маникюр. В ее работе нравится техника выполнения, всегда внимательное и уважительное отношение.', 'Ich möchte der Nagelspezialistin Sofia für die ausgezeichnete Maniküre danken. An ihrer Arbeit gefällt mir die Technik, und sie ist immer aufmerksam und respektvoll.', 'Kusursuz yaptığı manikür için uzman Sofia\'ya teşekkür etmek istiyorum. Çalışmasında uygulama tekniğini beğeniyorum, ayrıca her zaman ilgili ve saygılı.',
    0, '2025-12-03 00:00:00'),

(@user_olesya_semukhina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURucjdURWxBRRAB',
    5, 'en', 'Dear iPODO, I visit you for 3 years already. And it is always a perfect service, ambient atmosphere and professional masters. I made my manicure just on Tuesday, today I broke my nail (the wall was too hard which I bumped), I called to reception, the staff found me the slot, and my master did it for free, no money was charged. Sofia is always perfect, she advises new products and designs. Thank you ever so much.',
    'Dragi iPODO, dolazim kod vas već 3 godine. I uvijek je usluga savršena, atmosfera prijatna, a majstorice profesionalne. Manikir sam radila tek u utorak, a danas sam slomila nokat (zid u koji sam se udarila bio je previše tvrd), pozvala sam recepciju, osoblje mi je našlo termin, i moja majstorica je to uradila besplatno, nisu mi naplatili ništa. Sofija je uvijek savršena, preporučuje nove proizvode i dizajne. Hvala vam ogromno.', 'Драги iPODO, долазим код вас већ 3 године. И увијек је услуга савршена, атмосфера пријатна, а мајсторице професионалне. Маникир сам радила тек у уторак, а данас сам сломила нокат (зид у који сам се ударила био је превише тврд), позвала сам рецепцију, особље ми је нашло термин, и моја мајсторица је то урадила бесплатно, нису ми наплатили ништа. Софија је увијек савршена, препоручује нове производе и дизајне. Хвала вам огромно.', 'Dear iPODO, I visit you for 3 years already. And it is always a perfect service, ambient atmosphere and professional masters. I made my manicure just on Tuesday, today I broke my nail (the wall was too hard which I bumped), I called to reception, the staff found me the slot, and my master did it for free, no money was charged. Sofia is always perfect, she advises new products and designs. Thank you ever so much.', 'Дорогая iPODO, я хожу к вам уже 3 года. И это всегда идеальный сервис, приятная атмосфера и профессиональные мастера. Маникюр я сделала только во вторник, а сегодня сломала ноготь (стена, о которую я ударилась, оказалась слишком твёрдой), позвонила на ресепшен, персонал нашёл мне окошко, и мой мастер всё сделал бесплатно, денег не взяли. София всегда безупречна, она советует новые продукты и дизайны. Огромное вам спасибо.', 'Liebes iPODO, ich komme schon seit 3 Jahren zu euch. Und es ist immer ein perfekter Service, eine angenehme Atmosphäre und professionelle Fachkräfte. Meine Maniküre habe ich erst am Dienstag machen lassen, heute ist mir ein Nagel abgebrochen (die Wand, gegen die ich gestoßen bin, war zu hart), ich habe den Empfang angerufen, das Personal hat mir einen Termin gefunden, und meine Nagelspezialistin hat es kostenlos gemacht, es wurde nichts berechnet. Sofia ist immer perfekt, sie empfiehlt neue Produkte und Designs. Ganz herzlichen Dank.', 'Sevgili iPODO, 3 yıldır size geliyorum. Ve her zaman kusursuz bir hizmet, hoş bir ortam ve profesyonel uzmanlar var. Manikürümü daha salı günü yaptırmıştım, bugün tırnağımı kırdım (çarptığım duvar fazla sertti), resepsiyonu aradım, ekip bana bir randevu buldu ve uzmanım bunu ücretsiz yaptı, hiç para alınmadı. Sofia her zaman kusursuz, yeni ürünler ve tasarımlar öneriyor. Size çok çok teşekkür ederim.',
    0, '2025-12-03 00:00:00'),

(@user_olga_nalivkina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNWMnBtQUNREAE',
    5, 'ru', 'Крутая слаженная работа всего коллектива создает полное ощущение обслуженного по всем фронтам клиента! Браво! И так уже много лет)) Выбрала себе мастера Софию и довольна этим бесконечно, она великолепно работает: быстро, четко и всегда с постоянным и превосходным результатом ❤️‍🔥',
    'Sjajan usklađen rad cijelog kolektiva stvara potpun osjećaj da je klijent uslužen na svim frontovima! Bravo! I tako je već mnogo godina)) Izabrala sam sebi majstoricu Sofiju i beskrajno sam tim zadovoljna, ona radi veličanstveno: brzo, precizno i uvijek sa stalnim i vrhunskim rezultatom ❤️‍🔥', 'Сјајан усклађен рад цијелог колектива ствара потпун осјећај да је клијент услужен на свим фронтовима! Браво! И тако је већ много година)) Изабрала сам себи мајсторицу Софију и бескрајно сам тим задовољна, она ради величанствено: брзо, прецизно и увијек са сталним и врхунским резултатом ❤️‍🔥', 'The awesome, well-coordinated work of the whole team gives you the complete feeling of a client looked after on every front! Bravo! And it\'s been like this for many years)) I picked Sofia as my specialist and I\'m endlessly happy about it, she works magnificently: fast, precise and always with a consistently excellent result ❤️‍🔥', 'Крутая слаженная работа всего коллектива создает полное ощущение обслуженного по всем фронтам клиента! Браво! И так уже много лет)) Выбрала себе мастера Софию и довольна этим бесконечно, она великолепно работает: быстро, четко и всегда с постоянным и превосходным результатом ❤️‍🔥', 'Die klasse, perfekt abgestimmte Arbeit des ganzen Teams gibt einem das vollkommene Gefühl, als Kundin an allen Fronten betreut zu werden! Bravo! Und das schon seit vielen Jahren)) Ich habe mir Sofia als Spezialistin ausgesucht und bin damit unendlich zufrieden, sie arbeitet großartig: schnell, präzise und immer mit einem konstant hervorragenden Ergebnis ❤️‍🔥', 'Tüm ekibin harika ve uyumlu çalışması, müşteriye her açıdan tam olarak ilgilenildiği hissini veriyor! Bravo! Ve yıllardır böyle)) Kendime uzman olarak Sofia\'yı seçtim ve bundan sonsuz derecede memnunum, muhteşem çalışıyor: hızlı, net ve her zaman istikrarlı, mükemmel bir sonuçla ❤️‍🔥',
    0, '2025-12-03 00:00:00'),

(@user_helen_godlevska, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25NMk1HbEdWRjh4T0hoNWVUQmpTWFpGUlVWT1ltYxAB',
    5, 'ru', 'Хожу в этот салон уже не первый раз — и каждый раз выхожу с идеальным настроением и ещё более идеальными ногтями! Атмосфера уютная, чисто, спокойно, девочки всегда приветливы.

Мои мастера — Светлана и София (пусть простят меня другие 🙈) — это золото! Всё делают аккуратно, красиво и с душой. Покрытие держится долго, уход — на высшем уровне.

Даже если уезжаю за границу, я лучше подожду, чем пойду в другой салон — проверено: потом приходится «лечить и исправлять» 🙈💅

Спасибо за профессионализм, уют и стабильное качество. 💖
Рекомендую всем, кто ценит красоту и заботу!',
    'Dolazim u ovaj salon već više puta — i svaki put izlazim sa savršenim raspoloženjem i još savršenijim noktima! Atmosfera je prijatna, čisto je, mirno je, djevojke su uvijek ljubazne.

Moje majstorice — Svetlana i Sofija (neka mi ostale oproste 🙈) — su zlato! Sve rade pažljivo, lijepo i sa dušom. Lak drži dugo, njega je na najvišem nivou.

Čak i kad odem u inostranstvo, radije ću da sačekam nego da idem u drugi salon — provjereno: poslije toga se mora „liječiti i ispravljati“ 🙈💅

Hvala vam za profesionalizam, prijatnost i stabilan kvalitet. 💖
Preporučujem svima koji cijene ljepotu i brigu!', 'Долазим у овај салон већ више пута — и сваки пут излазим са савршеним расположењем и још савршенијим ноктима! Атмосфера је пријатна, чисто је, мирно је, дјевојке су увијек љубазне.

Моје мајсторице — Светлана и Софија (нека ми остале опросте 🙈) — су злато! Све раде пажљиво, лијепо и са душом. Лак држи дуго, њега је на највишем нивоу.

Чак и кад одем у иностранство, радије ћу да сачекам него да идем у други салон — провјерено: послије тога се мора „лијечити и исправљати“ 🙈💅

Хвала вам за професионализам, пријатност и стабилан квалитет. 💖
Препоручујем свима који цијене љепоту и бригу!', 'This isn\'t my first time at this salon — and every time I leave in a perfect mood and with even more perfect nails! The atmosphere is cosy, it\'s clean, calm, and the girls are always welcoming.

My specialists — Svetlana and Sofia (may the others forgive me 🙈) — are pure gold! They do everything carefully, beautifully and with heart. The polish lasts a long time, and the care is top-notch.

Even when I go abroad, I\'d rather wait than go to another salon — tried and tested: afterwards you have to "treat and fix" everything 🙈💅

Thank you for the professionalism, the cosy vibe and the consistent quality. 💖
I recommend it to everyone who values beauty and care!', 'Хожу в этот салон уже не первый раз — и каждый раз выхожу с идеальным настроением и ещё более идеальными ногтями! Атмосфера уютная, чисто, спокойно, девочки всегда приветливы.

Мои мастера — Светлана и София (пусть простят меня другие 🙈) — это золото! Всё делают аккуратно, красиво и с душой. Покрытие держится долго, уход — на высшем уровне.

Даже если уезжаю за границу, я лучше подожду, чем пойду в другой салон — проверено: потом приходится «лечить и исправлять» 🙈💅

Спасибо за профессионализм, уют и стабильное качество. 💖
Рекомендую всем, кто ценит красоту и заботу!', 'Ich gehe schon nicht zum ersten Mal in diesen Salon — und jedes Mal komme ich mit perfekter Laune und noch perfekteren Nägeln heraus! Die Atmosphäre ist gemütlich, es ist sauber, ruhig, und die Mädels sind immer freundlich.

Meine Spezialistinnen — Svetlana und Sofia (die anderen mögen mir verzeihen 🙈) — sind Gold wert! Sie machen alles sorgfältig, schön und mit Herz. Der Lack hält lange, die Pflege ist auf höchstem Niveau.

Selbst wenn ich ins Ausland fahre, warte ich lieber, als in einen anderen Salon zu gehen — erprobt: danach muss man alles „behandeln und korrigieren“ 🙈💅

Danke für die Professionalität, die Gemütlichkeit und die konstante Qualität. 💖
Ich empfehle es allen, die Schönheit und Fürsorge schätzen!', 'Bu salona ilk kez gitmiyorum — ve her seferinde mükemmel bir ruh haliyle ve daha da mükemmel tırnaklarla çıkıyorum! Ortam çok rahat, temiz, sakin, kızlar her zaman güler yüzlü.

Uzmanlarım — Svetlana ve Sofia (diğerleri beni affetsin 🙈) — birer altın! Her şeyi özenle, güzelce ve gönülden yapıyorlar. Oje uzun süre dayanıyor, bakım en üst düzeyde.

Yurt dışına gitsem bile, başka bir salona gitmek yerine beklemeyi tercih ederim — denenmiş: sonra her şeyi „tedavi edip düzeltmek“ gerekiyor 🙈💅

Profesyonellik, samimi ortam ve istikrarlı kalite için teşekkürler. 💖
Güzelliğe ve özene değer veren herkese tavsiye ederim!',
    0, '2025-12-03 00:00:00'),

(@user_diane, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21NellVMHhNMHBKV1dOSFR6SlBjWEpuTVZCclUzYxAB',
    5, 'ru', 'Скоро два года как хожу к Софие на маникюр и педикюр, каждый раз все идеально🤍

Алексей прекрасный специалист, была на консультации по здоровью и состоянию  моих стоп, все показал, исследовал, объяснил детально 😊 советую

Салон безупречно чистый, прекрасная обстановка, лучшее обслуживание🤍',
    'Skoro dvije godine idem kod Sofije na manikir i pedikir, svaki put je sve savršeno🤍

Aleksej je divan specijalista, bila sam na konsultaciji o zdravlju i stanju mojih stopala, sve mi je pokazao, ispitao, detaljno objasnio 😊 preporučujem

Salon je besprijekorno čist, divan ambijent, najbolja usluga🤍', 'Скоро двије године идем код Софије на маникир и педикир, сваки пут је све савршено🤍

Алексеј је диван специјалиста, била сам на консултацији о здрављу и стању мојих стопала, све ми је показао, испитао, детаљно објаснио 😊 препоручујем

Салон је беспријекорно чист, диван амбијент, најбоља услуга🤍', 'It\'ll soon be two years that I\'ve been going to Sofia for manicures and pedicures, and every time everything is perfect🤍

Aleksei is a wonderful specialist, I had a consultation about the health and condition of my feet, he showed me everything, examined them, explained it all in detail 😊 recommended

The salon is impeccably clean, lovely surroundings, the best service🤍', 'Скоро два года как хожу к Софие на маникюр и педикюр, каждый раз все идеально🤍

Алексей прекрасный специалист, была на консультации по здоровью и состоянию  моих стоп, все показал, исследовал, объяснил детально 😊 советую

Салон безупречно чистый, прекрасная обстановка, лучшее обслуживание🤍', 'Bald sind es zwei Jahre, dass ich zu Sofia für Maniküre und Fußpflege gehe, und jedes Mal ist alles perfekt🤍

Aleksej ist ein wunderbarer Spezialist, ich war zu einer Beratung über die Gesundheit und den Zustand meiner Füße, er hat mir alles gezeigt, untersucht, ausführlich erklärt 😊 sehr empfehlenswert

Der Salon ist tadellos sauber, ein schönes Ambiente, der beste Service🤍', 'Neredeyse iki yıldır manikür ve pedikür için Sofia\'ya gidiyorum, her seferinde her şey kusursuz🤍

Aleksey harika bir uzman, ayaklarımın sağlığı ve durumu hakkında konsültasyona gittim, her şeyi gösterdi, inceledi, ayrıntılı olarak anlattı 😊 tavsiye ederim

Salon kusursuz temiz, harika bir ortam, en iyi hizmet🤍',
    0, '2025-12-03 00:00:00'),

(@user_oleksandra_neskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSURqX2NHN2JnEAE',
    5, 'ru', 'Делаю маникюр в этом центре уже давно, мне очень нравиться удобство расположения, возможность записываться самостоятельно через сервис, эстетика пространства и внимание к деталям. Все мастера профессионалы, аккуратные и внимательные. Я безумно довольна своим мастером Софией - приятный человек и отличный мастер. Сначала делала у нее гель-лак (который прекрасно держался!), а теперь перешла на натуральные ногти и очень довольна качеством ее работы. Ручки выглядят ухоженно и дорого. Также хочу отметить администратора Камиллу - чувствую ее заботу, она уже знает кто что любит - приходишь в салон как в родное место. Безусловно рекомендую.',
    'Već dugo radim manikir u ovom centru, veoma mi se sviđa što je lokacija praktična, što mogu sama da rezervišem termin preko servisa, estetika prostora i pažnja prema detaljima. Sve majstorice su profesionalci, pažljive i predusretljive. Ludo sam zadovoljna svojom majstoricom Sofijom - prijatna osoba i odlična majstorica. Prvo sam kod nje radila gel-lak (koji je savršeno držao!), a sada sam prešla na prirodne nokte i veoma sam zadovoljna kvalitetom njenog rada. Ruke izgledaju njegovano i skupo. Takođe želim da pohvalim administratorku Kamilu - osjećam njenu brigu, ona već zna ko šta voli - u salon dolaziš kao na svoje. Bez ikakve sumnje preporučujem.', 'Већ дуго радим маникир у овом центру, веома ми се свиђа што је локација практична, што могу сама да резервишем термин преко сервиса, естетика простора и пажња према детаљима. Све мајсторице су професионалци, пажљиве и предусретљиве. Лудо сам задовољна својом мајсторицом Софијом - пријатна особа и одлична мајсторица. Прво сам код ње радила гел-лак (који је савршено држао!), а сада сам прешла на природне нокте и веома сам задовољна квалитетом њеног рада. Руке изгледају његовано и скупо. Такође желим да похвалим администраторку Камилу - осјећам њену бригу, она већ зна ко шта воли - у салон долазиш као на своје. Без икакве сумње препоручујем.', 'I\'ve been getting my manicures at this centre for a long time now, and I really like how convenient the location is, the option to book by myself through the online service, the aesthetics of the space and the attention to detail. All the specialists are professionals, precise and attentive. I\'m madly happy with my specialist Sofia - a lovely person and a great professional. At first I had gel polish with her (which held up beautifully!), and now I\'ve switched to natural nails and I\'m very happy with the quality of her work. My hands look well-groomed and expensive. I also want to mention the receptionist Kamila - I can feel her care, she already knows who likes what - you come to the salon as if it were your own place. I absolutely recommend it.', 'Делаю маникюр в этом центре уже давно, мне очень нравиться удобство расположения, возможность записываться самостоятельно через сервис, эстетика пространства и внимание к деталям. Все мастера профессионалы, аккуратные и внимательные. Я безумно довольна своим мастером Софией - приятный человек и отличный мастер. Сначала делала у нее гель-лак (который прекрасно держался!), а теперь перешла на натуральные ногти и очень довольна качеством ее работы. Ручки выглядят ухоженно и дорого. Также хочу отметить администратора Камиллу - чувствую ее заботу, она уже знает кто что любит - приходишь в салон как в родное место. Безусловно рекомендую.', 'Ich mache meine Maniküre schon lange in diesem Zentrum, mir gefällt sehr, wie praktisch die Lage ist, dass ich selbst über das Online-System einen Termin buchen kann, die Ästhetik der Räume und die Aufmerksamkeit für Details. Alle Fachkräfte sind Profis, sorgfältig und aufmerksam. Ich bin wahnsinnig zufrieden mit meiner Spezialistin Sofia - ein angenehmer Mensch und eine ausgezeichnete Fachkraft. Zuerst habe ich bei ihr Gel-Lack machen lassen (der wunderbar gehalten hat!), und jetzt bin ich auf natürliche Nägel umgestiegen und bin mit der Qualität ihrer Arbeit sehr zufrieden. Meine Hände sehen gepflegt und teuer aus. Außerdem möchte ich die Empfangsdame Kamila hervorheben - ich spüre ihre Fürsorge, sie weiß schon, wer was mag - man kommt in den Salon wie nach Hause. Ich empfehle es uneingeschränkt.', 'Uzun zamandır bu merkezde manikür yaptırıyorum, konumunun rahatlığını, online sistemden kendim randevu alabilmeyi, mekânın estetiğini ve detaylara verilen özeni çok seviyorum. Bütün uzmanlar profesyonel, özenli ve ilgili. Uzmanım Sofia\'dan inanılmaz memnunum - hem hoş bir insan hem de harika bir uzman. Önce onda kalıcı oje yaptırdım (mükemmel dayandı!), şimdi natürel tırnaklara geçtim ve işinin kalitesinden çok memnunum. Ellerim bakımlı ve pahalı görünüyor. Ayrıca resepsiyonist Kamila\'yı da belirtmek isterim - onun özenini hissediyorum, kimin neyi sevdiğini artık biliyor - salona kendi evine gelir gibi geliyorsun. Kesinlikle tavsiye ederim.',
    0, '2025-12-03 00:00:00'),

(@user_irina_dolzhenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21WYVkzVlFhalJJVlc5clUzTlpiV0psZVhCRGRtYxAB',
    5, 'ru', 'Очень уютная и приятная атмосфера! К мастеру Софии хожу уже 3 года и за это время ни разу не разочаровалась, всегда идеальный и чистый маникюр.',
    'Veoma prijatna i ugodna atmosfera! Kod majstorice Sofije idem već 3 godine i za to vrijeme nijednom se nisam razočarala, manikir je uvijek savršen i čist.', 'Веома пријатна и угодна атмосфера! Код мајсторице Софије идем већ 3 године и за то вријеме ниједном се нисам разочарала, маникир је увијек савршен и чист.', 'A very cosy and pleasant atmosphere! I\'ve been going to the specialist Sofia for 3 years now and in all that time I\'ve never once been disappointed, the manicure is always perfect and clean.', 'Очень уютная и приятная атмосфера! К мастеру Софии хожу уже 3 года и за это время ни разу не разочаровалась, всегда идеальный и чистый маникюр.', 'Eine sehr gemütliche und angenehme Atmosphäre! Ich gehe schon 3 Jahre zu der Spezialistin Sofia und war in dieser Zeit nicht einmal enttäuscht, die Maniküre ist immer perfekt und saubere Arbeit.', 'Çok rahat ve hoş bir ortam! Uzman Sofia\'ya 3 yıldır gidiyorum ve bu süre içinde bir kez bile hayal kırıklığına uğramadım, manikür her zaman kusursuz ve temiz.',
    0, '2025-12-03 00:00:00'),

(@user_elizaveta_eftifeeva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21vMWFuWndWM0prU1dsSllUSndSM2R5T1dOZlFrRRAB',
    5, 'ru', 'Хожу в этот центр уже 2-ой год, безумно нравится сервис! Всегда приятная атмосфера, стильный дизайн и интерьер, всё чисто и аккуратно, вежливые сотрудники.
К мастеру Софии безграничная любовь и благодарность, настоящий профессионал своего дела ❤️ Ни разу не было никаких нареканий, всегда качественно и аккуратно!',
    'U ovaj centar dolazim već 2. godinu, ludo mi se sviđa usluga! Uvijek prijatna atmosfera, stilski dizajn i interijer, sve je čisto i uredno, osoblje je ljubazno.
Majstorici Sofiji beskrajna ljubav i hvala, pravi profesionalac u svom poslu ❤️ Nijednom nije bilo nikakvih zamjerki, uvijek kvalitetno i pažljivo!', 'У овај центар долазим већ 2. годину, лудо ми се свиђа услуга! Увијек пријатна атмосфера, стилски дизајн и интеријер, све је чисто и уредно, особље је љубазно.
Мајсторици Софији бескрајна љубав и хвала, прави професионалац у свом послу ❤️ Ниједном није било никаквих замјерки, увијек квалитетно и пажљиво!', 'I\'ve been coming to this centre for the 2nd year now, and I\'m crazy about the service! Always a pleasant atmosphere, stylish design and interior, everything is clean and tidy, the staff are polite.
Endless love and gratitude to the specialist Sofia, a true professional at her craft ❤️ Not once has there been anything to complain about, always high quality and precise work!', 'Хожу в этот центр уже 2-ой год, безумно нравится сервис! Всегда приятная атмосфера, стильный дизайн и интерьер, всё чисто и аккуратно, вежливые сотрудники.
К мастеру Софии безграничная любовь и благодарность, настоящий профессионал своего дела ❤️ Ни разу не было никаких нареканий, всегда качественно и аккуратно!', 'Ich komme schon das 2. Jahr in dieses Zentrum und bin absolut begeistert vom Service! Immer eine angenehme Atmosphäre, stilvolles Design und Interieur, alles ist sauber und gepflegt, das Personal ist höflich.
Der Spezialistin Sofia unendliche Liebe und Dankbarkeit, ein echter Profi in ihrem Fach ❤️ Es gab nicht ein einziges Mal etwas zu beanstanden, immer hochwertig und sorgfältig!', 'Bu merkeze 2. yıldır geliyorum, hizmete bayılıyorum! Her zaman hoş bir ortam, şık tasarım ve iç mekân, her şey temiz ve düzenli, çalışanlar kibar.
Uzman Sofia\'ya sonsuz sevgi ve teşekkür, işinin gerçek bir profesyoneli ❤️ Bir kez bile şikâyet edecek bir şey olmadı, her zaman kaliteli ve özenli!',
    0, '2025-12-03 00:00:00'),

(@user_tim_drizhuk, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25keFRqTldaWFJVUmpSak0wZEJRV1ZTT0RGM2JGRRAB',
    5, 'en', 'I came here for a pedicure after noticing that the skin on my feet is getting rough. Everything was super nice and professional. Master Sophia did a magnificent job, the result was great and everything was comfortable and quick. I now go to her on a regular basis for pedicure.',
    'Došla sam ovdje na pedikir nakon što sam primijetila da mi koža na stopalima postaje gruba. Sve je bilo super prijatno i profesionalno. Majstorica Sophia je odradila veličanstven posao, rezultat je bio sjajan i sve je bilo prijatno i brzo. Sada joj redovno idem na pedikir.', 'Дошла сам овдје на педикир након што сам примијетила да ми кожа на стопалима постаје груба. Све је било супер пријатно и професионално. Мајсторица Софија је одрадила величанствен посао, резултат је био сјајан и све је било пријатно и брзо. Сада јој редовно идем на педикир.', 'I came here for a pedicure after noticing that the skin on my feet is getting rough. Everything was super nice and professional. Master Sophia did a magnificent job, the result was great and everything was comfortable and quick. I now go to her on a regular basis for pedicure.', 'Я пришла сюда на педикюр, когда заметила, что кожа на стопах становится грубой. Всё было супер приятно и профессионально. Мастер София сделала великолепную работу, результат отличный, и всё прошло комфортно и быстро. Теперь я хожу к ней на педикюр регулярно.', 'Ich bin hierher zur Fußpflege gekommen, nachdem mir aufgefallen war, dass die Haut an meinen Füßen rau wird. Alles war super angenehm und professionell. Die Spezialistin Sophia hat großartige Arbeit geleistet, das Ergebnis war klasse und alles war bequem und schnell. Jetzt gehe ich regelmäßig zu ihr zur Fußpflege.', 'Ayaklarımdaki derinin sertleştiğini fark ettikten sonra pedikür için buraya geldim. Her şey çok hoş ve profesyoneldi. Uzman Sophia muhteşem bir iş çıkardı, sonuç harikaydı, her şey rahat ve hızlı geçti. Artık düzenli olarak pedikür için ona gidiyorum.',
    0, '2025-12-03 00:00:00'),

(@user_liza, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xKblpUVllWWE4yVGtwQlIxODJVVVZGY1RGSFQxRRAB',
    5, 'en', 'Really like this place, very polite and friendly people.My master Sophia — I’ve been going to her for over a year, and I’m very happy with her work.',
    'Stvarno mi se sviđa ovo mjesto, veoma ljubazni i prijatni ljudi.Moja majstorica Sophia — idem kod nje već više od godinu dana i veoma sam zadovoljna njenim radom.', 'Стварно ми се свиђа ово мјесто, веома љубазни и пријатни људи.Моја мајсторица Софија — идем код ње већ више од годину дана и веома сам задовољна њеним радом.', 'Really like this place, very polite and friendly people.My master Sophia — I’ve been going to her for over a year, and I’m very happy with her work.', 'Мне очень нравится это место, очень вежливые и приветливые люди.Мой мастер София — хожу к ней уже больше года и очень довольна её работой.', 'Mir gefällt dieser Ort wirklich, sehr höfliche und freundliche Menschen.Meine Spezialistin Sophia — ich gehe schon über ein Jahr zu ihr und bin mit ihrer Arbeit sehr zufrieden.', 'Bu yeri gerçekten çok seviyorum, insanlar çok kibar ve güler yüzlü.Uzmanım Sophia — bir yıldan fazla süredir ona gidiyorum ve işinden çok memnunum.',
    0, '2025-12-03 00:00:00'),

(@user_nadya_kuleshova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT214RGNIZEpZak5NWm5odVptODFUSGhhV1RsUFZVRRAB',
    5, 'ru', 'iPodo — мой постоянный салон уже несколько лет. Всегда отличный сервис, всё стерильно, аккуратно и с индивидуальным подходом. Очень рекомендую мастеров Софию и Наталью — у них руки “золотые”!',
    'iPodo je moj stalni salon već nekoliko godina. Uvijek odlična usluga, sve je sterilno, uredno i sa individualnim pristupom. Toplo preporučujem majstorice Sofiju i Nataliju — imaju “zlatne” ruke!', 'iPodo је мој стални салон већ неколико година. Увијек одлична услуга, све је стерилно, уредно и са индивидуалним приступом. Топло препоручујем мајсторице Софију и Наталију — имају “златне” руке!', 'iPodo has been my go-to salon for several years now. Always excellent service, everything is sterile, precise and with an individual approach. I highly recommend the specialists Sofia and Natalia — they have “golden” hands!', 'iPodo — мой постоянный салон уже несколько лет. Всегда отличный сервис, всё стерильно, аккуратно и с индивидуальным подходом. Очень рекомендую мастеров Софию и Наталью — у них руки “золотые”!', 'iPodo ist schon seit einigen Jahren mein Stammsalon. Immer ein ausgezeichneter Service, alles ist steril, sorgfältig und mit individueller Betreuung. Ich empfehle die Spezialistinnen Sofia und Natalia sehr — sie haben “goldene” Hände!', 'iPodo birkaç yıldır benim düzenli gittiğim salon. Her zaman mükemmel hizmet, her şey steril, özenli ve kişiye özel bir yaklaşımla. Uzmanlar Sofia ve Natalia\'yı çok tavsiye ederim — “altın” elleri var!',
    0, '2025-12-03 00:00:00'),

(@user_rumiya_oraeva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGUlRtTmZlRzk2WWpWUGRFZE5VMlJwWW1SMGRIYxAB',
    5, 'ru', 'Потрясающий центр! Подолг Анюта выполнила великолепный подологический педикюр, мои ножки теперь в идеальном состоянии! Очень рада попасть в руки профессионала. Помимо этого делала у девочек маникюр, такого выбора цветов не встречала нигде. На ресепшене администратор Камилла очень приветливая, вежливая и внимательная, угостила вкусным чаем. Я осталась в полном восторге, рекомендую от души!!!',
    'Fantastičan centar! Podolog Anjuta je napravila sjajan podološki pedikir, moja stopala su sada u idealnom stanju! Baš mi je drago što sam došla u ruke profesionalca. Osim toga, radila sam i manikir kod djevojaka, takav izbor boja nisam vidjela nigdje. Na recepciji je administratorka Kamila veoma ljubazna, uljudna i pažljiva, ponudila me ukusnim čajem. Ostala sam potpuno očarana, preporučujem od srca!!!', 'Фантастичан центар! Подолог Ањута је направила сјајан подолошки педикир, моја стопала су сада у идеалном стању! Баш ми је драго што сам дошла у руке професионалца. Осим тога, радила сам и маникир код дјевојака, такав избор боја нисам видјела нигдје. На рецепцији је администраторка Камила веома љубазна, уљудна и пажљива, понудила ме укусним чајем. Остала сам потпуно очарана, препоручујем од срца!!!', 'Amazing centre! Podiatrist Anjuta did a wonderful podiatric pedicure, my feet are now in perfect condition! So glad to be in the hands of a professional. Besides that I had a manicure done by the girls, I\'ve never seen such a choice of colours anywhere. At the reception the administrator Kamila is very welcoming, polite and attentive, she treated me to a delicious tea. I was absolutely delighted, I recommend it wholeheartedly!!!', 'Потрясающий центр! Подолг Анюта выполнила великолепный подологический педикюр, мои ножки теперь в идеальном состоянии! Очень рада попасть в руки профессионала. Помимо этого делала у девочек маникюр, такого выбора цветов не встречала нигде. На ресепшене администратор Камилла очень приветливая, вежливая и внимательная, угостила вкусным чаем. Я осталась в полном восторге, рекомендую от души!!!', 'Ein fantastisches Zentrum! Die Podologin Anjuta hat eine großartige podologische Fußpflege gemacht, meine Füße sind jetzt in perfektem Zustand! Ich bin sehr froh, in die Hände einer Profi geraten zu sein. Außerdem habe ich bei den Mädchen eine Maniküre machen lassen, so eine Farbauswahl habe ich noch nirgendwo gesehen. An der Rezeption ist die Administratorin Kamila sehr freundlich, höflich und aufmerksam, sie hat mir einen leckeren Tee angeboten. Ich war vollkommen begeistert, ich empfehle es von Herzen!!!', 'Muhteşem bir merkez! Podolog Anjuta harika bir podolojik pedikür yaptı, ayaklarım artık mükemmel durumda! Bir profesyonelin ellerine düştüğüm için çok mutluyum. Bunun dışında kızlara manikür de yaptırdım, böyle bir renk seçeneğini hiçbir yerde görmedim. Resepsiyonda yönetici Kamila çok güler yüzlü, nazik ve ilgili, bana lezzetli bir çay ikram etti. Tam anlamıyla hayran kaldım, gönülden tavsiye ederim!!!',
    0, '2025-12-03 00:00:00'),

(@user_victory_lettering, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21ZNVRtNTFZbWR6ZEhVeVNXaFBkbGh4ZVVobWJXYxAB',
    5, 'ru', 'Уже несколько лет являюсь преданным и лояльным клиентом салона IPODO. Для меня это лучший сервис и качество в Черногории!Мастер София прислушивается к моим пожеланиям, а также всегда проконсультирует по состоянию ногтей. 🫶🏻
НО ОСТОРОЖНО! Придя один раз и воспользовавшись услугами, вы влюбитесь навсегда 😁❤️
P.S. Вкусные комплиментарные напитки как в лучших кофейнях города 🙌🏻',
    'Već nekoliko godina sam vjerna i lojalna klijentkinja salona IPODO. Za mene je to najbolji servis i kvalitet u Crnoj Gori! Majstorica Sofija sluša moje želje, a uvijek će i savjetovati u vezi sa stanjem noktiju. 🫶🏻
ALI PAZITE! Kad jednom dođete i iskoristite usluge, zaljubićete se zauvijek 😁❤️
P.S. Ukusni komplimentarni napici kao u najboljim kafeterijama u gradu 🙌🏻', 'Већ неколико година сам вјерна и лојална клијенткиња салона IPODO. За мене је то најбољи сервис и квалитет у Црној Гори! Мајсторица Софија слуша моје жеље, а увијек ће и савјетовати у вези са стањем ноктију. 🫶🏻
АЛИ ПАЗИТЕ! Кад једном дођете и искористите услуге, заљубићете се заувијек 😁❤️
P.S. Укусни комплиментарни напици као у најбољим кафетеријама у граду 🙌🏻', 'For several years now I\'ve been a devoted and loyal client of the IPODO salon. For me it\'s the best service and quality in Montenegro! Sofija listens to my wishes and always gives advice about the condition of my nails. 🫶🏻
BUT BEWARE! Come once and use their services, and you\'ll fall in love forever 😁❤️
P.S. Delicious complimentary drinks, like in the best coffee shops in town 🙌🏻', 'Уже несколько лет являюсь преданным и лояльным клиентом салона IPODO. Для меня это лучший сервис и качество в Черногории!Мастер София прислушивается к моим пожеланиям, а также всегда проконсультирует по состоянию ногтей. 🫶🏻
НО ОСТОРОЖНО! Придя один раз и воспользовавшись услугами, вы влюбитесь навсегда 😁❤️
P.S. Вкусные комплиментарные напитки как в лучших кофейнях города 🙌🏻', 'Seit einigen Jahren bin ich eine treue und loyale Kundin des Salons IPODO. Für mich ist das der beste Service und die beste Qualität in Montenegro! Sofija hört auf meine Wünsche und berät mich immer zum Zustand meiner Nägel. 🫶🏻
ABER ACHTUNG! Wenn man einmal kommt und die Leistungen in Anspruch nimmt, verliebt man sich für immer 😁❤️
P.S. Leckere Getränke aufs Haus wie in den besten Cafés der Stadt 🙌🏻', 'Birkaç yıldır IPODO salonunun sadık ve vazgeçmeyen bir müşterisiyim. Benim için Karadağ\'daki en iyi hizmet ve kalite! Sofija isteklerimi dinliyor, ayrıca tırnaklarımın durumu hakkında her zaman tavsiye veriyor. 🫶🏻
AMA DİKKAT! Bir kez gelip hizmetlerinden yararlanınca, sonsuza dek aşık olacaksınız 😁❤️
P.S. Şehrin en iyi kahvecileri gibi lezzetli ikram içecekler 🙌🏻',
    0, '2025-12-03 00:00:00'),

(@user_olga_shabardina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21sd1dUTTVhV0pPVGt4b2VUYzNlR3AwVWtobFdXYxAB',
    5, 'ru', 'Хожу к девочкам на педикюр и маникюр,очень приятная атмосфера.И качество супер!Особенно рекомендую Софию!',
    'Idem kod djevojaka na pedikir i manikir, veoma prijatna atmosfera. I kvalitet je super! Posebno preporučujem Sofiju!', 'Идем код дјевојака на педикир и маникир, веома пријатна атмосфера. И квалитет је супер! Посебно препоручујем Софију!', 'I go to the girls for pedicures and manicures, the atmosphere is very pleasant. And the quality is super! I especially recommend Sofija!', 'Хожу к девочкам на педикюр и маникюр,очень приятная атмосфера.И качество супер!Особенно рекомендую Софию!', 'Ich gehe zu den Mädchen für Pediküre und Maniküre, die Atmosphäre ist sehr angenehm. Und die Qualität ist super! Ich empfehle besonders Sofija!', 'Kızlara pedikür ve manikür için gidiyorum, atmosfer çok hoş. Kalite de süper! Özellikle Sofija\'yı tavsiye ederim!',
    0, '2025-12-03 00:00:00'),

(@user_yana_duka, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KdVluSmpTMnhKT0dKelJuYzBVR0ZaV1ZSRVkyYxAB',
    5, 'ru', 'Давно делаю здесь маникюр, ходила к многим мастерам - Софии, Светлане и Наталье, с уверенностью скажу, что все супер профессионалы своего дела ❤️❤️
Всё всегда на высшем уровне, советую!',
    'Već dugo radim manikir ovdje, bila sam kod više majstorica - Sofije, Svetlane i Natalije, sa sigurnošću mogu reći da su sve super profesionalke u svom poslu ❤️❤️
Sve je uvijek na najvišem nivou, preporučujem!', 'Већ дуго радим маникир овдје, била сам код више мајсторица - Софије, Светлане и Наталије, са сигурношћу могу рећи да су све супер професионалке у свом послу ❤️❤️
Све је увијек на највишем нивоу, препоручујем!', 'I\'ve been getting my manicures here for a long time, I\'ve been to several technicians - Sofija, Svetlana and Natalija, and I can say with confidence that they are all super professionals at what they do ❤️❤️
Everything is always top notch, I recommend it!', 'Давно делаю здесь маникюр, ходила к многим мастерам - Софии, Светлане и Наталье, с уверенностью скажу, что все супер профессионалы своего дела ❤️❤️
Всё всегда на высшем уровне, советую!', 'Ich mache hier schon lange meine Maniküre, ich war bei mehreren Kosmetikerinnen - Sofija, Svetlana und Natalija, und ich kann mit Sicherheit sagen, dass sie alle absolute Profis in ihrem Fach sind ❤️❤️
Alles ist immer auf höchstem Niveau, ich empfehle es!', 'Uzun zamandır burada manikür yaptırıyorum, birçok ustaya gittim - Sofija, Svetlana ve Natalija, hepsinin işinde süper profesyonel olduğunu güvenle söyleyebilirim ❤️❤️
Her şey her zaman en üst düzeyde, tavsiye ederim!',
    0, '2025-12-03 00:00:00'),

(@user_anna_belogurova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSWVFWOVBSRFIzTFV4YWFqUTNXRXhxU0VoblRYYxAB',
    5, 'ru', 'Хожу второй год к Софии, каждый раз в полном восторге! Мой личный праздничный день! Идеально внимательно, аккуратно, профессионально, любой дизайн. Мой любимый мастер в Черногории! Чудесная общая атмосфера и вкусный гречишный чай 🤍🖤❤️',
    'Drugu godinu idem kod Sofije i svaki put sam potpuno očarana! Moj lični praznik! Savršeno pažljivo, precizno, profesionalno, bilo koji dizajn. Moja najdraža majstorica u Crnoj Gori! Divna atmosfera i ukusan čaj od heljde 🤍🖤❤️', 'Другу годину идем код Софије и сваки пут сам потпуно очарана! Мој лични празник! Савршено пажљиво, прецизно, професионално, било који дизајн. Моја најдража мајсторица у Црној Гори! Дивна атмосфера и укусан чај од хељде 🤍🖤❤️', 'This is my second year going to Sofija and every time I\'m absolutely delighted! My own personal holiday! Perfectly attentive, precise, professional, any design you like. My favourite nail technician in Montenegro! Wonderful atmosphere overall and delicious buckwheat tea 🤍🖤❤️', 'Хожу второй год к Софии, каждый раз в полном восторге! Мой личный праздничный день! Идеально внимательно, аккуратно, профессионально, любой дизайн. Мой любимый мастер в Черногории! Чудесная общая атмосфера и вкусный гречишный чай 🤍🖤❤️', 'Ich gehe im zweiten Jahr zu Sofija und bin jedes Mal vollkommen begeistert! Mein persönlicher Festtag! Perfekt aufmerksam, sorgfältig, professionell, jedes Design. Meine Lieblingskosmetikerin in Montenegro! Wunderbare Atmosphäre und leckerer Buchweizentee 🤍🖤❤️', 'İkinci yıldır Sofija\'ya gidiyorum ve her seferinde hayran kalıyorum! Benim kişisel bayramım! Kusursuz özenli, titiz, profesyonel, her türlü tasarım. Karadağ\'daki en sevdiğim ustam! Harika bir genel atmosfer ve lezzetli karabuğday çayı 🤍🖤❤️',
    0, '2025-12-03 00:00:00'),

(@user_danica_zenovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25aMFRWQTViRlZDV0U1MlkyRjRTMmxDTjNwMldWRRAB',
    5, 'en', 'I get manicure and pedicure from Natalia and Sophia. It is the best place. I really like quality and enjoy every time. Thank you!',
    'Manikir i pedikir radim kod Natalije i Sofije. Ovo je najbolje mjesto. Kvalitet mi se baš mnogo dopada i svaki put uživam. Hvala vam!', 'Маникир и педикир радим код Наталије и Софије. Ово је најбоље мјесто. Квалитет ми се баш много допада и сваки пут уживам. Хвала вам!', 'I get manicure and pedicure from Natalia and Sophia. It is the best place. I really like quality and enjoy every time. Thank you!', 'Маникюр и педикюр делаю у Наталии и Софии. Это лучшее место. Мне очень нравится качество, и я каждый раз получаю удовольствие. Спасибо!', 'Maniküre und Pediküre lasse ich bei Natalia und Sophia machen. Das ist der beste Ort. Die Qualität gefällt mir wirklich sehr und ich genieße es jedes Mal. Vielen Dank!', 'Manikür ve pedikürümü Natalia ve Sophia\'ya yaptırıyorum. Burası en iyi yer. Kaliteyi gerçekten çok seviyorum ve her seferinde keyif alıyorum. Teşekkürler!',
    0, '2025-12-03 00:00:00'),

(@user_grigoriy, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tOMmVsbzJkRWxXV2xkQmRuQk5kRGhRTTBaNFRuYxAB',
    5, 'ru', 'Делал стемпинг с покрытием у Софии, очень понравилось! Получилось очень аккуратно, держалось долго.
Еще и сервис отличный',
    'Radio sam stemping sa lakom kod Sofije, veoma mi se dopalo! Ispalo je vrlo precizno i dugo se držalo.
A i servis je odličan', 'Радио сам стемпинг са лаком код Софије, веома ми се допало! Испало је врло прецизно и дуго се држало.
А и сервис је одличан', 'I had stamping with a coating done by Sofija, I really liked it! It came out very neat and lasted a long time.
And the service is excellent too', 'Делал стемпинг с покрытием у Софии, очень понравилось! Получилось очень аккуратно, держалось долго.
Еще и сервис отличный', 'Ich habe bei Sofija Stamping mit Lack machen lassen, es hat mir sehr gefallen! Es wurde sehr sauber und hat lange gehalten.
Und der Service ist außerdem ausgezeichnet', 'Sofija\'ya kaplamalı stamping yaptırdım, çok beğendim! Çok düzgün oldu ve uzun süre dayandı.
Ayrıca hizmet de harika',
    0, '2025-12-03 00:00:00'),

(@user_an_buf, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21KRU9YRmFhR0ZFTldkYU1HUlVZbUpIYVdRMmRVRRAB',
    5, 'ru', 'Шлю тысячу благодарностей, меня тут просто спасли, все болело так, что я думала - надо ногу отрезать! Подолог Анюта сказала, это вросший ноготь и избавилась от него за 5 минут. На следующий день 0 отека и боли. Спасибо вам огромное 🤗🤗🤗🤗 …',
    'Šaljem hiljadu zahvalnica, ovdje su me prosto spasili, sve me je boljelo toliko da sam mislila - treba mi odrezati nogu! Podolog Anjuta je rekla da je to urasli nokat i riješila ga za 5 minuta. Sljedećeg dana 0 otoka i bola. Hvala vam ogromno 🤗🤗🤗🤗 …', 'Шаљем хиљаду захвалница, овдје су ме просто спасили, све ме је бољело толико да сам мислила - треба ми одрезати ногу! Подолог Ањута је рекла да је то урасли нокат и ријешила га за 5 минута. Сљедећег дана 0 отока и бола. Хвала вам огромно 🤗🤗🤗🤗 …', 'A thousand thanks to you, they literally saved me here, everything hurt so much that I thought I\'d have to have my foot cut off! Podiatrist Anjuta said it was an ingrown toenail and got rid of it in 5 minutes. The next day, zero swelling and zero pain. Thank you so much 🤗🤗🤗🤗 …', 'Шлю тысячу благодарностей, меня тут просто спасли, все болело так, что я думала - надо ногу отрезать! Подолог Анюта сказала, это вросший ноготь и избавилась от него за 5 минут. На следующий день 0 отека и боли. Спасибо вам огромное 🤗🤗🤗🤗 …', 'Tausend Dank, hier haben sie mich einfach gerettet, alles tat so weh, dass ich dachte - der Fuß muss ab! Die Podologin Anjuta sagte, es sei ein eingewachsener Nagel, und hat ihn in 5 Minuten beseitigt. Am nächsten Tag null Schwellung und null Schmerzen. Vielen, vielen Dank 🤗🤗🤗🤗 …', 'Bin kere teşekkür ediyorum, beni burada gerçekten kurtardılar, her yerim öyle ağrıyordu ki ayağımı kesmek gerekir diye düşünüyordum! Podolog Anjuta bunun batık tırnak olduğunu söyledi ve 5 dakikada ondan kurtardı. Ertesi gün sıfır şişlik, sıfır ağrı. Size çok çok teşekkürler 🤗🤗🤗🤗 …',
    0, '2025-12-03 00:00:00'),

(@user_matvey_tuparev, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkRU1URmxja3BPZWxka1dsOUllRFJ4TldKSWIzYxAB',
    5, 'ru', 'Обычно на педикюр не хожу,  но оказалось что не правильно стригу ногти и они начинают болеть. Поэтому попробовал сходить к специалисту. Теперь каждый месяц посещаю. Спасибо мастеру  Софии и другим сотрудникам за их работу и решение проблемы👍🏻 …',
    'Obično ne idem na pedikir, ali se pokazalo da nepravilno sječem nokte i da onda počnu da bole. Zato sam probao da odem kod stručnjaka. Sada dolazim svaki mjesec. Hvala majstorici Sofiji i ostalim zaposlenima na njihovom radu i na tome što su riješili problem👍🏻 …', 'Обично не идем на педикир, али се показало да неправилно сјечем нокте и да онда почну да боле. Зато сам пробао да одем код стручњака. Сада долазим сваки мјесец. Хвала мајсторици Софији и осталим запосленима на њиховом раду и на томе што су ријешили проблем👍🏻 …', 'I don\'t usually go for pedicures, but it turned out I was cutting my nails wrong and they were starting to hurt. So I tried going to a specialist. Now I visit every month. Thanks to Sofija and the rest of the staff for their work and for solving the problem👍🏻 …', 'Обычно на педикюр не хожу,  но оказалось что не правильно стригу ногти и они начинают болеть. Поэтому попробовал сходить к специалисту. Теперь каждый месяц посещаю. Спасибо мастеру  Софии и другим сотрудникам за их работу и решение проблемы👍🏻 …', 'Normalerweise gehe ich nicht zur Fußpflege, aber es stellte sich heraus, dass ich meine Nägel falsch schneide und sie anfangen zu schmerzen. Deshalb habe ich es bei einer Spezialistin versucht. Jetzt komme ich jeden Monat. Danke an Sofija und die anderen Mitarbeiterinnen für ihre Arbeit und dafür, dass sie das Problem gelöst haben👍🏻 …', 'Normalde pedikür yaptırmaya gitmem, ama tırnaklarımı yanlış kestiğim ve bu yüzden ağrımaya başladığı ortaya çıktı. Bu yüzden bir uzmana gitmeyi denedim. Artık her ay gidiyorum. Sofija\'ya ve diğer çalışanlara işleri ve sorunu çözdükleri için teşekkür ederim👍🏻 …',
    0, '2025-12-03 00:00:00'),

(@user_anna_pokusaeva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT210UWFIazBXRk5yY3poMFMwczBOVTVwZEVSdFdVRRAB',
    5, 'ru', 'София делает прекрасный маникюр, очень аккуратно, красиво и быстро ❤️',
    'Sofija radi prekrasan manikir, veoma precizno, lijepo i brzo ❤️', 'Софија ради прекрасан маникир, веома прецизно, лијепо и брзо ❤️', 'Sofija does a beautiful manicure, very neat, pretty and fast ❤️', 'София делает прекрасный маникюр, очень аккуратно, красиво и быстро ❤️', 'Sofija macht eine wunderschöne Maniküre, sehr sauber, schön und schnell ❤️', 'Sofija harika bir manikür yapıyor, çok düzgün, güzel ve hızlı ❤️',
    0, '2025-12-03 00:00:00'),

(@user_artur_arturov, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xaTGIzcHVkekowWTBoU1N6bGxXbVpWVDNnNVNGRRAB',
    5, 'ru', 'Помогли справится с проблемой трещин на пятках. Огромная благодарность администратору Камилле за быструю координацию с записью. Угостила напитками и оставила очень приятное впечатление! Всем рекомендую',
    'Pomogli su mi da riješim problem sa pukotinama na petama. Ogromno hvala administratorki Kamili na brzoj koordinaciji termina. Ponudila me napicima i ostavila veoma prijatan utisak! Svima preporučujem', 'Помогли су ми да ријешим проблем са пукотинама на петама. Огромно хвала администраторки Камили на брзој координацији термина. Понудила ме напицима и оставила веома пријатан утисак! Свима препоручујем', 'They helped me deal with the problem of cracked heels. Huge thanks to the administrator Kamila for quickly sorting out my appointment. She offered me drinks and made a very pleasant impression! I recommend it to everyone', 'Помогли справится с проблемой трещин на пятках. Огромная благодарность администратору Камилле за быструю координацию с записью. Угостила напитками и оставила очень приятное впечатление! Всем рекомендую', 'Sie haben mir geholfen, das Problem mit den rissigen Fersen zu lösen. Ein riesiges Dankeschön an die Administratorin Kamila für die schnelle Terminabstimmung. Sie hat mir Getränke angeboten und einen sehr angenehmen Eindruck gemacht! Ich empfehle es allen', 'Topuklardaki çatlak sorunuyla baş etmeme yardım ettiler. Randevuyu hızlıca ayarladığı için yönetici Kamila\'ya çok teşekkürler. Bana içecek ikram etti ve çok hoş bir izlenim bıraktı! Herkese tavsiye ederim',
    0, '2025-12-03 00:00:00'),

(@user_medina_isaeva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s1b2NrdG9SbVJCTjFrd1JUWklZVzkyT1VoMFUwRRAB',
    5, 'ru', 'Прекрасный центр! Девочки мастера своего дела, выполняют свою работу качественно и аккуратно. Великолепное обслуживание. Отдельную благодарность хочу выразить администратору Камилле за внимательное отношение к клиентам!',
    'Prekrasan centar! Djevojke su majstorice svog posla, rade kvalitetno i precizno. Sjajna usluga. Posebno želim da se zahvalim administratorki Kamili na pažljivom odnosu prema klijentima!', 'Прекрасан центар! Дјевојке су мајсторице свог посла, раде квалитетно и прецизно. Сјајна услуга. Посебно желим да се захвалим администраторки Камили на пажљивом односу према клијентима!', 'A wonderful centre! The girls are true masters of their craft, they do their work with quality and precision. Excellent service. I\'d like to give special thanks to the administrator Kamila for her attentive attitude towards clients!', 'Прекрасный центр! Девочки мастера своего дела, выполняют свою работу качественно и аккуратно. Великолепное обслуживание. Отдельную благодарность хочу выразить администратору Камилле за внимательное отношение к клиентам!', 'Ein wunderbares Zentrum! Die Mädchen sind Meisterinnen ihres Fachs, sie arbeiten hochwertig und sorgfältig. Hervorragender Service. Ein besonderer Dank geht an die Administratorin Kamila für ihren aufmerksamen Umgang mit den Kundinnen!', 'Harika bir merkez! Kızlar işlerinin ustası, işlerini kaliteli ve özenli yapıyorlar. Muhteşem hizmet. Müşterilere gösterdiği ilgi için yönetici Kamila\'ya özellikle teşekkür etmek istiyorum!',
    0, '2025-12-03 00:00:00'),

(@user_yuliya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNEcl8zVF9RRRAB',
    5, 'ru', 'София - мастер с большой буквы! Всегда аккуратно, эстетично и на высшем уровне. Очень приятная, внимательная и деликатная. Маникюр держится идеально, атмосфера уютная. Спасибо за красоту и заботу! Рекомендую от души 💅✨',
    'Sofija je majstorica s velikim M! Uvijek precizno, estetski i na najvišem nivou. Veoma prijatna, pažljiva i delikatna. Manikir se drži idealno, atmosfera je prijatna. Hvala na ljepoti i na brizi! Preporučujem od srca 💅✨', 'Софија је мајсторица с великим М! Увијек прецизно, естетски и на највишем нивоу. Веома пријатна, пажљива и деликатна. Маникир се држи идеално, атмосфера је пријатна. Хвала на љепоти и на бризи! Препоручујем од срца 💅✨', 'Sofija is a master with a capital M! Always neat, aesthetic and top level. Very pleasant, attentive and gentle. The manicure holds perfectly, the atmosphere is cosy. Thank you for the beauty and the care! I recommend her wholeheartedly 💅✨', 'София - мастер с большой буквы! Всегда аккуратно, эстетично и на высшем уровне. Очень приятная, внимательная и деликатная. Маникюр держится идеально, атмосфера уютная. Спасибо за красоту и заботу! Рекомендую от души 💅✨', 'Sofija ist eine Meisterin mit großem M! Immer sauber, ästhetisch und auf höchstem Niveau. Sehr angenehm, aufmerksam und einfühlsam. Die Maniküre hält perfekt, die Atmosphäre ist gemütlich. Danke für die Schönheit und die Fürsorge! Ich empfehle sie von Herzen 💅✨', 'Sofija büyük harfle USTA! Her zaman özenli, estetik ve en üst düzeyde. Çok hoş, ilgili ve nazik. Manikür mükemmel duruyor, atmosfer çok samimi. Güzellik ve ilgi için teşekkürler! Gönülden tavsiye ederim 💅✨',
    0, '2025-12-03 00:00:00'),

(@user_vika_bantsikina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT200eWEyTTNNemMzVDBoTk5IWjVNVFJ2V2toeVdVRRAB',
    5, 'ru', 'Хочу выразить респект мастеру Софии за мастерство и отзывчивость!!!за идеальными ноготочками точно к ней! ну и за атмосферой,конечно же,очень приятно проводить время,то что нужно нам,девочкам!',
    'Želim da izrazim respekt majstorici Sofiji na umješnosti i predusretljivosti!!! za idealne nokte sigurno kod nje! pa i zbog atmosfere, naravno, veoma je prijatno provoditi vrijeme, upravo ono što nama, djevojkama, treba!', 'Желим да изразим респект мајсторици Софији на умјешности и предусретљивости!!! за идеалне нокте сигурно код ње! па и због атмосфере, наравно, веома је пријатно проводити вријеме, управо оно што нама, дјевојкама, треба!', 'I want to give respect to Sofija for her skill and helpfulness!!! for perfect little nails go straight to her! and for the atmosphere too, of course, it\'s so nice to spend time there, exactly what we girls need!', 'Хочу выразить респект мастеру Софии за мастерство и отзывчивость!!!за идеальными ноготочками точно к ней! ну и за атмосферой,конечно же,очень приятно проводить время,то что нужно нам,девочкам!', 'Ich möchte Sofija meinen Respekt für ihr Können und ihre Hilfsbereitschaft aussprechen!!! für perfekte Nägel geht man definitiv zu ihr! und natürlich auch wegen der Atmosphäre, es ist sehr angenehm, dort Zeit zu verbringen, genau das, was wir Mädchen brauchen!', 'Ustalığı ve yardımseverliği için Sofija\'ya saygılarımı sunmak istiyorum!!! kusursuz tırnaklar için kesinlikle ona gidin! bir de atmosfer için, elbette, orada zaman geçirmek çok keyifli, biz kızların ihtiyacı olan tam da bu!',
    0, '2025-12-03 00:00:00'),

(@user_natalia_tupareva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCVmJEVmFlbEpJTldWNmRGZDJaVzgxYTFrM2FXYxAB',
    5, 'ru', 'Приезжали в отпуск в Черногорию и переживали, что некуда будет сходить на маникюр и педикюр. Но теперь можем смело не думать об этом. Очень классное место, такое внимание к деталям, особенно стерилизации и сервису. А мастер София очень приятная в диалоге, аккуратная, и очень быстрая. Спасибо большое❤️',
    'Došli smo na odmor u Crnu Goru i brinuli smo se da nećemo imati gdje da odemo na manikir i pedikir. Ali sada o tome slobodno možemo da ne razmišljamo. Veoma super mjesto, tolika pažnja za detalje, posebno za sterilizaciju i uslugu. A majstorica Sofija je veoma prijatna u razgovoru, precizna i vrlo brza. Hvala vam mnogo❤️', 'Дошли смо на одмор у Црну Гору и бринули смо се да нећемо имати гдје да одемо на маникир и педикир. Али сада о томе слободно можемо да не размишљамо. Веома супер мјесто, толика пажња за детаље, посебно за стерилизацију и услугу. А мајсторица Софија је веома пријатна у разговору, прецизна и врло брза. Хвала вам много❤️', 'We came to Montenegro on holiday and were worried there would be nowhere to go for a manicure and pedicure. But now we can safely stop thinking about that. A really cool place, such attention to detail, especially to sterilisation and service. And Sofija is very pleasant to talk to, precise and very fast. Thank you so much❤️', 'Приезжали в отпуск в Черногорию и переживали, что некуда будет сходить на маникюр и педикюр. Но теперь можем смело не думать об этом. Очень классное место, такое внимание к деталям, особенно стерилизации и сервису. А мастер София очень приятная в диалоге, аккуратная, и очень быстрая. Спасибо большое❤️', 'Wir sind für den Urlaub nach Montenegro gekommen und hatten Sorge, dass es keinen Ort für Maniküre und Pediküre geben würde. Aber darüber müssen wir uns jetzt keine Gedanken mehr machen. Ein sehr toller Ort, so viel Aufmerksamkeit für Details, besonders für Sterilisation und Service. Und Sofija ist im Gespräch sehr angenehm, sorgfältig und sehr schnell. Vielen Dank❤️', 'Tatil için Karadağ\'a geldik ve manikür ile pedikür için gidecek bir yer bulamayacağız diye endişeliydik. Ama artık bunu hiç düşünmeyebiliriz. Çok harika bir yer, detaylara böyle bir özen, özellikle sterilizasyona ve hizmete. Sofija ise sohbeti çok keyifli, özenli ve çok hızlı. Çok teşekkürler❤️',
    0, '2025-12-03 00:00:00'),

(@user_olga_stepanova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNQNVl5bDlRRRAB',
    5, 'ru', 'София замечательный мастер и невероятно чуткий человек ♥️ Как всегда идеальный маникюр, хожу к Софии на маникюр и педикюр  уже 3 года ♥️',
    'Sofija je divna majstorica i nevjerovatno osjećajna osoba ♥️ Kao i uvijek, idealan manikir, kod Sofije idem na manikir i pedikir već 3 godine ♥️', 'Софија је дивна мајсторица и невјероватно осјећајна особа ♥️ Као и увијек, идеалан маникир, код Софије идем на маникир и педикир већ 3 године ♥️', 'Sofija is a wonderful technician and an incredibly caring person ♥️ A perfect manicure as always, I\'ve been going to Sofija for manicures and pedicures for 3 years now ♥️', 'София замечательный мастер и невероятно чуткий человек ♥️ Как всегда идеальный маникюр, хожу к Софии на маникюр и педикюр  уже 3 года ♥️', 'Sofija ist eine wunderbare Kosmetikerin und ein unglaublich einfühlsamer Mensch ♥️ Wie immer eine perfekte Maniküre, ich gehe schon seit 3 Jahren zu Sofija für Maniküre und Pediküre ♥️', 'Sofija harika bir usta ve inanılmaz duyarlı bir insan ♥️ Her zamanki gibi kusursuz bir manikür, 3 yıldır Sofija\'ya manikür ve pedikür için gidiyorum ♥️',
    0, '2025-12-03 00:00:00'),

(@user_lera_sklyarova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWSFlrUkROMlpFVldGcVQyaG5aSGQ2VkRVME1GRRAB',
    5, 'uk', 'Майстер Софія - це найкраще , що зі мною траплялось ❤️ якщо ви ціните якість і швидкість , вам точно до цього майстра !',
    'Majstorica Sofija je najbolje što mi se ikada dogodilo ❤️ ako cijenite kvalitet i brzinu, sigurno idite kod ove majstorice!', 'Мајсторица Софија је најбоље што ми се икада догодило ❤️ ако цијените квалитет и брзину, сигурно идите код ове мајсторице!', 'Sofija is the best thing that has ever happened to me ❤️ if you value quality and speed, she\'s definitely the one to go to!', 'Мастер София - это лучшее, что со мной случалось ❤️ если вы цените качество и скорость, вам точно к этому мастеру!', 'Sofija ist das Beste, was mir je passiert ist ❤️ wenn Sie Qualität und Schnelligkeit schätzen, dann gehen Sie unbedingt zu ihr!', 'Usta Sofija başıma gelen en güzel şey ❤️ kaliteye ve hıza değer veriyorsanız, kesinlikle bu ustaya gidin!',
    0, '2025-12-03 00:00:00'),

(@user_alina_dzhus, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxVWRVOXdVR0p1U25rMmFqUmtPVlV3Um1OUFVIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-03 00:00:00'),

(@user_evgeniya_tabachnikova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTUNvOE1IX2ZnEAE',
    5, 'ru', 'Благодарность подологу Анне за квалифицированную консультацию. Надеюсь на продолжение сотрудничества
Работа Камиллы на рецепшене заслуживает отдельного упоминания- она внимательна и гостеприимнаи всегда угощает нас очень вкусным чаем.',
    'Zahvalnost podologu Ani na kvalifikovanoj konsultaciji. Nadam se nastavku saradnje
Rad Kamile na recepciji zaslužuje posebno pominjanje - pažljiva je i gostoljubiva i uvijek nas ponudi veoma ukusnim čajem.', 'Захвалност подологу Ани на квалификованој консултацији. Надам се настављању сарадње
Рад Камиле на рецепцији заслужује посебно помињање - пажљива је и гостољубива и увијек нас понуди веома укусним чајем.', 'Many thanks to podiatrist Anna for the expert consultation. I hope our cooperation continues
Kamila\'s work at the reception deserves a separate mention - she is attentive and welcoming and always treats us to very tasty tea.', 'Благодарность подологу Анне за квалифицированную консультацию. Надеюсь на продолжение сотрудничества
Работа Камиллы на рецепшене заслуживает отдельного упоминания- она внимательна и гостеприимнаи всегда угощает нас очень вкусным чаем.', 'Dank an die Podologin Anna für die qualifizierte Beratung. Ich hoffe auf eine Fortsetzung der Zusammenarbeit
Die Arbeit von Kamila an der Rezeption verdient eine besondere Erwähnung - sie ist aufmerksam und gastfreundlich und verwöhnt uns immer mit sehr leckerem Tee.', 'Nitelikli danışmanlık için podolog Anna\'ya teşekkürler. İşbirliğimizin devam etmesini umuyorum
Kamila\'nın resepsiyondaki çalışması ayrıca anılmayı hak ediyor - ilgili ve misafirperver, bize her zaman çok lezzetli çay ikram ediyor.',
    0, '2025-12-03 00:00:00'),

(@user_maryia_kalpinskaya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xsZk1VSlpjRTE0Y2pObU1IWTRaV0p3ZFY5WVNFRRAB',
    5, 'ru', 'Прекрасный персонал 👍🏼 отличный сервис …',
    'Prekrasan personal 👍🏼 odlična usluga …', 'Прекрасан персонал 👍🏼 одлична услуга …', 'Wonderful staff 👍🏼 excellent service …', 'Прекрасный персонал 👍🏼 отличный сервис …', 'Wunderbares Personal 👍🏼 ausgezeichneter Service …', 'Harika personel 👍🏼 mükemmel hizmet …',
    0, '2025-11-03 00:00:00'),

(@user_alexander_leonov, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25oRGRXeFpPWGhSVTA1U1FXeEliVGh5Tm5admIzYxAB',
    5, 'ru', 'Хочется выразить благодарность Анне, за помощь с лечением пальчика у ребёнка. Видно, что человек - профессионал своего дела. Здорово, что есть такие люди в Черногории',
    'Želim da izrazim zahvalnost Anni za pomoć u liječenju prstića kod djeteta. Vidi se da je čovjek profesionalac u svom poslu. Sjajno je što u Crnoj Gori ima takvih ljudi', 'Желим да изразим захвалност Ани за помоћ у лијечењу прстића код дјетета. Види се да је човјек професионалац у свом послу. Сјајно је што у Црној Гори има таквих људи', 'I\'d like to thank Anna for helping to treat my child\'s toe. You can tell that this person is a true professional. It\'s great that there are people like this in Montenegro', 'Хочется выразить благодарность Анне, за помощь с лечением пальчика у ребёнка. Видно, что человек - профессионал своего дела. Здорово, что есть такие люди в Черногории', 'Ich möchte Anna für die Hilfe bei der Behandlung des Zehs meines Kindes danken. Man merkt, dass sie ein echter Profi in ihrem Fach ist. Toll, dass es solche Menschen in Montenegro gibt', 'Çocuğumun parmağının tedavisinde yardımcı olduğu için Anna\'ya teşekkür etmek istiyorum. İnsanın işinin gerçek profesyoneli olduğu belli. Karadağ\'da böyle insanların olması harika',
    0, '2025-11-03 00:00:00'),

(@user_ana_nikolic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pndGNuRmZkV2xYTXpFelNtUXpSVUZDY1c4MlFXYxAB',
    5, 'en', 'Aleksei is the best orthopaedic doctor. I am soo grateful that I had the honour to meet him. The pain in my leg already is minimal.',
    'Aleksei je najbolji ortoped. Tako sam zahvalna što sam imala čast da ga upoznam. Bol u nozi mi je već minimalan.', 'Алексеј је најбољи ортопед. Тако сам захвална што сам имала част да га упознам. Бол у нози ми је већ минималан.', 'Aleksei is the best orthopaedic doctor. I am soo grateful that I had the honour to meet him. The pain in my leg already is minimal.', 'Алексей — лучший врач-ортопед. Я так благодарна, что мне посчастливилось с ним познакомиться. Боль в ноге уже почти прошла.', 'Aleksei ist der beste Orthopäde. Ich bin sooo dankbar, dass ich die Ehre hatte, ihn kennenzulernen. Die Schmerzen in meinem Bein sind schon minimal.', 'Aleksei en iyi ortopedi doktoru. Onunla tanışma şerefine eriştiğim için çook minnettarım. Bacağımdaki ağrı şimdiden en aza indi.',
    0, '2025-11-03 00:00:00'),

(@user_nur_news, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xJMk9VeFhVVEZrT0hscmJsZEVhalpNWkZCa1YxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-03 00:00:00'),

(@user_31spacey, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT201dlJtbHpTblV4ZEVsV2MwWXhMVkI0V21wTVpXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-03 00:00:00'),

(@user_lissa_w, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTUNva1oyVGtnRRAB',
    1, 'en', 'We went to Anyuta, but she couldn\'t solve the problem, so we went to another city to see another specialist. You spend a lot of money on extras, etc. Although it\'s possible to cure it in one go, and simply, instead of dragging it out for three or four weeks, leaving the person in pain. You can only get your manicure done by other girls and that\'s it.',
    'Išli smo kod Anyute, ali ona nije mogla da riješi problem, pa smo otišli u drugi grad kod drugog specijaliste. Potrošiš mnogo novca na dodatke i tako dalje. A moguće je izliječiti to iz prve, i to jednostavno, umjesto da se otežava tri-četiri nedjelje i da čovjek sve to vrijeme trpi bolove. Manikir možete raditi samo kod drugih djevojaka i to je sve.', 'Ишли смо код Анјуте, али она није могла да ријеши проблем, па смо отишли у други град код другог специјалисте. Потрошиш много новца на додатке и тако даље. А могуће је излијечити то из прве, и то једноставно, умјесто да се отеже три-четири недјеље и да човјек све то вријеме трпи болове. Маникир можете радити само код других дјевојака и то је све.', 'We went to Anyuta, but she couldn\'t solve the problem, so we went to another city to see another specialist. You spend a lot of money on extras, etc. Although it\'s possible to cure it in one go, and simply, instead of dragging it out for three or four weeks, leaving the person in pain. You can only get your manicure done by other girls and that\'s it.', 'Мы ходили к Анюте, но она не смогла решить проблему, так что мы поехали в другой город к другому специалисту. Тратишь кучу денег на всякие дополнительные процедуры и т.д. Хотя вылечить можно за один раз, и просто, а не тянуть три-четыре недели, оставляя человека с болью. Маникюр можно делать только у других девушек, и всё.', 'Wir waren bei Anyuta, aber sie konnte das Problem nicht lösen, also sind wir in eine andere Stadt zu einem anderen Spezialisten gefahren. Man gibt eine Menge Geld für Zusatzleistungen usw. aus. Obwohl man es in einem einzigen Durchgang heilen kann, und zwar einfach, statt es drei oder vier Wochen hinzuziehen und den Menschen mit Schmerzen sitzen zu lassen. Die Maniküre kann man sich nur bei den anderen Mädchen machen lassen, und das war\'s.', 'Anyuta\'ya gittik ama sorunu çözemedi, biz de başka bir şehre, başka bir uzmana gittik. Ekstralara falan bir sürü para harcıyorsunuz. Oysa tek seferde ve basitçe iyileştirmek mümkün; insanı üç dört hafta ağrı içinde bırakıp işi sürüncemede bırakmak yerine. Sadece diğer kızlara manikür yaptırabilirsiniz, o kadar.',
    0, '2025-11-03 00:00:00'),

(@user_olga, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21rNFpYcEtVbEE0UVVoSlZISm1lblZDU1dkUGVtYxAB',
    5, 'ru', 'Все супер. И сервис и качество услуг! Рада что есть такие спецы в Черногории, даже не смотря на то что приходится ездить из столицы',
    'Sve je super. I servis i kvalitet usluga! Drago mi je što u Crnoj Gori ima takvih stručnjaka, čak i kad moram da dolazim iz glavnog grada', 'Све је супер. И сервис и квалитет услуга! Драго ми је што у Црној Гори има таквих стручњака, чак и кад морам да долазим из главног града', 'Everything is super. Both the service and the quality of the treatments! I\'m glad there are specialists like this in Montenegro, even though I have to travel in from the capital', 'Все супер. И сервис и качество услуг! Рада что есть такие спецы в Черногории, даже не смотря на то что приходится ездить из столицы', 'Alles super. Sowohl der Service als auch die Qualität der Leistungen! Ich bin froh, dass es solche Spezialisten in Montenegro gibt, auch wenn ich aus der Hauptstadt anreisen muss', 'Her şey süper. Hem hizmet hem de işin kalitesi! Başkentten gelmek zorunda olsam bile Karadağ\'da böyle uzmanların olmasına çok sevindim',
    0, '2025-10-03 00:00:00'),

(@user_top5_agency_spain, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2todFVFZFhhVTkxVFdWSVozWnpjakYyV1dvNWRFRRAB',
    5, 'en', 'One of the best places to to medical pedicure. Great service and hospitality',
    'Jedno od najboljih mjesta za medicinski pedikir. Sjajan servis i gostoprimstvo', 'Једно од најбољих мјеста за медицински педикир. Сјајан сервис и гостопримство', 'One of the best places to to medical pedicure. Great service and hospitality', 'Одно из лучших мест для медицинского педикюра. Отличный сервис и гостеприимство', 'Einer der besten Orte für eine medizinische Fußpflege. Toller Service und große Gastfreundschaft', 'Medikal pedikür için en iyi yerlerden biri. Harika hizmet ve misafirperverlik',
    0, '2025-10-03 00:00:00'),

(@user_maria_purtova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25OZmNsTXRZMkZtTVhaM05sOUVRMFpyZGtSR2EzYxAB',
    5, 'ru', 'Ударила ноготь и он отошёл полностью. Анюта - замечательный подолог, настоящий профессионал. Всё быстро, четко и ничего лишнего не выписывает. Аптечные копеечные средства мне выписала. Успокоила, что все будет хорошо и ноготь отрастим снова.',
    'Udarila sam nokat i on je potpuno otpao. Anjuta je divan podolog, pravi profesionalac. Sve brzo, precizno i ne prepisuje ništa nepotrebno. Prepisala mi je sredstva iz apoteke koja koštaju sitnicu. Umirila me je da će sve biti dobro i da će nokat ponovo izrasti.', 'Ударила сам нокат и он је потпуно отпао. Ањута је диван подолог, прави професионалац. Све брзо, прецизно и не прописује ништа непотребно. Прописала ми је средства из апотеке која коштају ситницу. Умирила ме је да ће све бити добро и да ће нокат поново израсти.', 'I banged my toenail and it came off completely. Anjuta is a wonderful podiatrist, a real professional. Everything quick, precise, and she doesn\'t prescribe anything you don\'t need. She prescribed me dirt-cheap products from the pharmacy. She reassured me that everything would be fine and that the nail would grow back.', 'Ударила ноготь и он отошёл полностью. Анюта - замечательный подолог, настоящий профессионал. Всё быстро, четко и ничего лишнего не выписывает. Аптечные копеечные средства мне выписала. Успокоила, что все будет хорошо и ноготь отрастим снова.', 'Ich habe mir den Nagel gestoßen und er ist komplett abgefallen. Anjuta ist eine wunderbare Podologin, ein echter Profi. Alles schnell, präzise, und sie verschreibt nichts Unnötiges. Sie hat mir spottbillige Mittel aus der Apotheke verschrieben. Sie hat mich beruhigt, dass alles gut wird und der Nagel wieder nachwächst.', 'Tırnağımı çarptım ve tamamen çıktı. Anjuta harika bir podolog, gerçek bir profesyonel. Her şey hızlı, net ve gereksiz hiçbir şey yazmıyor. Bana eczaneden alınacak üç kuruşluk ürünler yazdı. Her şeyin yolunda gideceğine ve tırnağın yeniden uzayacağına dair beni rahatlattı.',
    0, '2025-10-03 00:00:00'),

(@user_aunt_cat, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGdlRtUnZXVzlIVG0weVpYWlJjV0poVHpOR2NWRRAB',
    5, 'ru', 'Все было на высоте. Лучший сервис в Будве - точно. Идеальный маникюр. Мастер Светлана - золото 🫶🏼 …',
    'Sve je bilo na visini. Najbolji servis u Budvi - definitivno. Idealan manikir. Majstorica Svetlana je zlato 🫶🏼 …', 'Све је било на висини. Најбољи сервис у Будви - дефинитивно. Идеалан маникир. Мајсторица Светлана је злато 🫶🏼 …', 'Everything was top notch. The best service in Budva - for sure. A perfect manicure. Svetlana, the technician, is pure gold 🫶🏼 …', 'Все было на высоте. Лучший сервис в Будве - точно. Идеальный маникюр. Мастер Светлана - золото 🫶🏼 …', 'Alles war erste Klasse. Der beste Service in Budva - definitiv. Perfekte Maniküre. Die Nageldesignerin Svetlana ist Gold wert 🫶🏼 …', 'Her şey harikaydı. Budva\'daki en iyi hizmet - kesinlikle. Kusursuz manikür. Uzman Svetlana altın gibi 🫶🏼 …',
    0, '2025-10-03 00:00:00'),

(@user_alex_baguzin, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGcVRtNTFkWGxwUW01aU1WVk1TV1pRWkZSdGRuYxAB',
    5, 'ru', 'Пришел 4 месяца назад с многослойным ногтем к подологу Анюте. Она проделала прекрасную работу, без каких-либо крайних мер. Ноготь теперь здоровый, почти отрос. Прекрасный специалист, таких поискать',
    'Došao sam prije 4 mjeseca kod podologa Anjute sa višeslojnim noktom. Odradila je sjajan posao, bez ikakvih drastičnih mjera. Nokat je sada zdrav, skoro je izrastao. Sjajan specijalista, takve treba tražiti', 'Дошао сам прије 4 мјесеца код подолога Ањуте са вишеслојним ноктом. Одрадила је сјајан посао, без икаквих драстичних мјера. Нокат је сада здрав, скоро је израстао. Сјајан специјалиста, такве треба тражити', 'I came to the podiatrist Anjuta 4 months ago with a layered nail. She did a wonderful job, without any drastic measures. The nail is healthy now and has almost fully grown back. A great specialist, you don\'t find many like her', 'Пришел 4 месяца назад с многослойным ногтем к подологу Анюте. Она проделала прекрасную работу, без каких-либо крайних мер. Ноготь теперь здоровый, почти отрос. Прекрасный специалист, таких поискать', 'Ich bin vor 4 Monaten mit einem mehrschichtigen Nagel zur Podologin Anjuta gekommen. Sie hat wunderbare Arbeit geleistet, ohne irgendwelche drastischen Maßnahmen. Der Nagel ist jetzt gesund und fast nachgewachsen. Eine hervorragende Spezialistin, so eine muss man erst finden', '4 ay önce çok katmanlı tırnağımla podolog Anjuta\'ya gittim. Hiçbir aşırı önleme başvurmadan harika bir iş çıkardı. Tırnak artık sağlıklı, neredeyse tamamen uzadı. Mükemmel bir uzman, böylesini bulmak zor',
    0, '2025-10-03 00:00:00'),

(@user_aleksey_naydenov, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT200d2FWaHRaa2cyWDBwQ2F6SXhjRUp4V21wUlpVRRAB',
    1, 'ru', 'Отличный салон — если вы хотите не решить проблему, а узнать, как красиво угрожать клиентам судом.

Мы водили ребёнка три недели подряд, было три приёма. Проблема так и не решилась, зато успели назначить установку скобы и предложить купить крема по цене в несколько раз выше, чем в аптеке.

После этого мы обратились к специалисту в Баре — и там всё устранили за один визит, без “дополнительных процедур”, лишних покупок и обещаний чудес.

На отзыв о реальной ситуации в ответ услышали обвинения в “хейтерстве” и угрозы суда.

В Черногории, между прочим, Zakon o zaštiti potrošača защищает право клиента выражать мнение о качестве услуги. Возможно, стоит хотя бы раз прочитать его, прежде чем размахивать “Krivičnim zakonikom” вместо пилочки.',
    'Odličan salon — ako ne želite da riješite problem, nego da naučite kako se elegantno prijeti klijentima sudom.

Vodili smo dijete tri nedjelje zaredom, bila su tri pregleda. Problem se tako i nije riješio, ali su uspjeli da propišu postavljanje skobe i da nam ponude kreme po cijeni nekoliko puta većoj nego u apoteci.

Nakon toga smo se obratili specijalisti u Baru — i tamo su sve riješili u jednoj posjeti, bez „dodatnih procedura“, nepotrebnih kupovina i obećanja čuda.

Na recenziju o stvarnoj situaciji kao odgovor smo dobili optužbe za „hejtovanje“ i prijetnje sudom.

U Crnoj Gori, uzgred, Zakon o zaštiti potrošača štiti pravo klijenta da izrazi mišljenje o kvalitetu usluge. Možda bi vrijedilo barem ga jednom pročitati, prije nego što se maše „Krivičnim zakonikom“ umjesto turpijicom.', 'Одличан салон — ако не желите да ријешите проблем, него да научите како се елегантно пријети клијентима судом.

Водили смо дијете три недјеље заредом, била су три прегледа. Проблем се тако и није ријешио, али су успјели да пропишу постављање скобе и да нам понуде креме по цијени неколико пута већој него у апотеци.

Након тога смо се обратили специјалисти у Бару — и тамо су све ријешили у једној посјети, без „додатних процедура“, непотребних куповина и обећања чуда.

На рецензију о стварној ситуацији као одговор смо добили оптужбе за „хејтовање“ и пријетње судом.

У Црној Гори, узгред, Закон о заштити потрошача штити право клијента да изрази мишљење о квалитету услуге. Можда би вриједило барем га једном прочитати, прије него што се маше „Кривичним закоником“ умјесто турпијицом.', 'A great salon — if what you want is not to have your problem solved, but to learn how to threaten clients with court in style.

We brought our child in three weeks in a row, three appointments in total. The problem was never solved, but they did manage to prescribe fitting a nail brace and to offer us creams at several times the pharmacy price.

After that we went to a specialist in Bar — and there everything was sorted out in a single visit, with no “additional procedures”, no unnecessary purchases and no promises of miracles.

In response to a review describing the real situation, we got accusations of “hating” and threats of court.

By the way, in Montenegro the Zakon o zaštiti potrošača (Consumer Protection Act) protects a client\'s right to express an opinion about the quality of a service. Perhaps it is worth reading it at least once before waving the “Krivični zakonik” (Criminal Code) around instead of a nail file.', 'Отличный салон — если вы хотите не решить проблему, а узнать, как красиво угрожать клиентам судом.

Мы водили ребёнка три недели подряд, было три приёма. Проблема так и не решилась, зато успели назначить установку скобы и предложить купить крема по цене в несколько раз выше, чем в аптеке.

После этого мы обратились к специалисту в Баре — и там всё устранили за один визит, без “дополнительных процедур”, лишних покупок и обещаний чудес.

На отзыв о реальной ситуации в ответ услышали обвинения в “хейтерстве” и угрозы суда.

В Черногории, между прочим, Zakon o zaštiti potrošača защищает право клиента выражать мнение о качестве услуги. Возможно, стоит хотя бы раз прочитать его, прежде чем размахивать “Krivičnim zakonikom” вместо пилочки.', 'Ein ausgezeichneter Salon — wenn man nicht sein Problem lösen, sondern lernen will, wie man Kunden stilvoll mit Gericht droht.

Wir sind mit unserem Kind drei Wochen hintereinander hingegangen, insgesamt drei Termine. Das Problem wurde nie gelöst, dafür hat man es geschafft, das Anlegen einer Nagelspange zu verordnen und uns Cremes zum mehrfachen Apothekenpreis anzubieten.

Danach haben wir uns an einen Spezialisten in Bar gewandt — und dort wurde alles in einem einzigen Besuch behoben, ohne „zusätzliche Prozeduren“, ohne unnötige Käufe und ohne Wunderversprechen.

Als Antwort auf eine Bewertung, die die tatsächliche Situation beschreibt, bekamen wir Vorwürfe des „Hatens“ und Drohungen mit Gericht zu hören.

In Montenegro schützt übrigens das Verbraucherschutzgesetz (Zakon o zaštiti potrošača) das Recht des Kunden, seine Meinung über die Qualität einer Leistung zu äußern. Vielleicht sollte man es wenigstens einmal lesen, bevor man mit dem „Krivični zakonik“ (Strafgesetzbuch) herumwedelt statt mit der Nagelfeile.', 'Harika bir salon — eğer sorununuzun çözülmesini değil, müşterileri şık bir şekilde mahkemeyle tehdit etmenin yolunu öğrenmek istiyorsanız.

Çocuğumuzu üç hafta üst üste götürdük, toplam üç randevu oldu. Sorun bir türlü çözülmedi, ama tırnak teli takılmasını yazmaya ve eczanedekinin birkaç katı fiyata krem satın almayı teklif etmeye vakit buldular.

Ondan sonra Bar\'daki bir uzmana gittik — ve orada her şey tek bir ziyarette çözüldü; “ek işlemler”, gereksiz alışverişler ve mucize vaatleri olmadan.

Gerçek durumu anlatan bir yoruma karşılık “nefretçilik” suçlamaları ve mahkeme tehditleri duyduk.

Bu arada, Karadağ\'da Zakon o zaštiti potrošača (Tüketicinin Korunması Kanunu) müşterinin hizmet kalitesi hakkında görüş belirtme hakkını korur. Belki de törpü yerine “Krivični zakonik” (Ceza Kanunu) sallamadan önce onu bir kez olsun okumak gerekir.',
    0, '2025-10-03 00:00:00'),

(@user_yuliya_chernogor, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT214RldHTm9NWFZvTUZGSE1tZGZUR2RTZFdwVE1IYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-03 00:00:00'),

(@user_yunona_zhupii, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25jeWFIWllOMmhhU21GVWNFeFVhVlIzVG14RWJuYxAB',
    3, 'ru', 'Замечательный специалист Анна ( подолог). Сервис на высоте , НО!, когда речь идет об уходе , предлагают только свою линейку , в данной ситуации попросила уход ,вне , данного заведения , цитирую : «другого ухода не может быть» , альтернативу доктор не предложила , основываясь только на уход предложенным заведением . То есть кроме предложенного ими средств (возможно которыми являются амбассадором  )ухода другого альтернативы не дано …а это значит , что если мне не подходят их средства , альтернативу предложит не смогли . Педикюр с анализами и средствами обошелся в 270 евро , Вы должны об этом знать',
    'Sjajan specijalista Anna (podolog). Servis na visokom nivou, ALI!, kada je riječ o njezi, nude samo svoju liniju proizvoda; u ovoj situaciji sam zamolila za njegu izvan ovog salona, citiram: „druge njege ne može biti“, alternativu doktorka nije predložila, oslanjajući se isključivo na njegu koju salon nudi. Znači, osim sredstava koja oni nude (a možda su im i ambasadori) druge alternative za njegu nema … a to znači da, ako mi njihova sredstva ne odgovaraju, alternativu nisu umjeli da predlože. Pedikir sa analizama i preparatima došao je 270 eura, treba to da znate', 'Сјајан специјалиста Ана (подолог). Сервис на високом нивоу, АЛИ!, када је ријеч о њези, нуде само своју линију производа; у овој ситуацији сам замолила за његу изван овог салона, цитирам: „друге његе не може бити“, алтернативу докторка није предложила, ослањајући се искључиво на његу коју салон нуди. Значи, осим средстава која они нуде (а можда су им и амбасадори) друге алтернативе за његу нема … а то значи да, ако ми њихова средства не одговарају, алтернативу нису умјели да предложе. Педикир са анализама и препаратима дошао је 270 еура, треба то да знате', 'Anna (the podiatrist) is a wonderful specialist. The service is top notch, BUT!, when it comes to aftercare they only offer their own product line; in this situation I asked for care products from outside this place, and I quote: “there can be no other care”, the doctor offered no alternative, going only by the care the place itself offers. Meaning that apart from the products they offer (which they may well be brand ambassadors for) no other care option is given … and that means that if their products don\'t suit me, they weren\'t able to suggest an alternative. The pedicure with the tests and the products came to 270 euros, you should know this', 'Замечательный специалист Анна ( подолог). Сервис на высоте , НО!, когда речь идет об уходе , предлагают только свою линейку , в данной ситуации попросила уход ,вне , данного заведения , цитирую : «другого ухода не может быть» , альтернативу доктор не предложила , основываясь только на уход предложенным заведением . То есть кроме предложенного ими средств (возможно которыми являются амбассадором  )ухода другого альтернативы не дано …а это значит , что если мне не подходят их средства , альтернативу предложит не смогли . Педикюр с анализами и средствами обошелся в 270 евро , Вы должны об этом знать', 'Anna (die Podologin) ist eine wunderbare Spezialistin. Der Service ist top, ABER!, wenn es um die Pflege geht, wird nur die eigene Produktlinie angeboten; in dieser Situation habe ich um Pflege von außerhalb dieses Salons gebeten, ich zitiere: „eine andere Pflege kann es nicht geben“, eine Alternative hat die Ärztin nicht vorgeschlagen, sie stützte sich einzig auf die vom Salon angebotene Pflege. Das heißt, außer den von ihnen angebotenen Mitteln (für die sie möglicherweise Markenbotschafter sind) wird keine andere Pflegealternative gegeben … und das bedeutet, wenn mir ihre Mittel nicht passen, konnten sie keine Alternative anbieten. Die Fußpflege mit Tests und Produkten hat 270 Euro gekostet, das sollten Sie wissen', 'Anna (podolog) harika bir uzman. Hizmet üst düzeyde, AMA!, bakım konusuna gelince sadece kendi ürün serilerini öneriyorlar; bu durumda ben bu mekânın dışından bir bakım ürünü istedim, aynen aktarıyorum: «başka bir bakım olamaz», doktor alternatif önermedi, yalnızca mekânın önerdiği bakıma dayandı. Yani onların önerdiği ürünlerin (belki de markanın elçisi oldukları ürünlerin) dışında başka bir bakım alternatifi verilmiyor … bu da demek oluyor ki, eğer onların ürünleri bana uymuyorsa, alternatif önerememişler. Analizler ve ürünlerle birlikte pedikür 270 euroya geldi, bunu bilmelisiniz',
    0, '2025-10-03 00:00:00'),

(@user_evgeniya_dabizha, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNYN2JpSDB3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-03 00:00:00'),

(@user_aleksandra_s, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xveVVFaDNTa2RyUWtwWmNHOWZkRk5rY3pacmJHYxAB',
    5, 'it', 'Ottima esperienza, mi hanno offerto un buonissimo cappuccino subito arrivata, personale molto professionale e gentile, ambiente pulito, ho apprezzato che usino i prodotti Rituals come sapone e lozione per le mani in bagno, posto super consigliato.',
    'Odlično iskustvo, ponudili su mi izuzetno dobar cappuccino odmah po dolasku, osoblje veoma profesionalno i ljubazno, prostor čist, cijenila sam to što u kupatilu koriste proizvode Rituals kao sapun i losion za ruke, mjesto koje toplo preporučujem.', 'Одлично искуство, понудили су ми изузетно добар cappuccino одмах по доласку, особље веома професионално и љубазно, простор чист, цијенила сам то што у купатилу користе производе Rituals као сапун и лосион за руке, мјесто које топло препоручујем.', 'A great experience, they offered me a delicious cappuccino as soon as I arrived, very professional and kind staff, clean space, I appreciated that they use Rituals products as hand soap and hand lotion in the bathroom, a place I highly recommend.', 'Отличный опыт, сразу по приходу мне предложили очень вкусный капучино, персонал очень профессиональный и приветливый, чисто, понравилось, что в санузле используют средства Rituals — мыло и лосьон для рук. Место супер, рекомендую.', 'Eine ausgezeichnete Erfahrung, sie haben mir gleich nach meiner Ankunft einen sehr guten Cappuccino angeboten, das Personal sehr professionell und freundlich, alles sauber, mir hat gefallen, dass sie im Bad Produkte von Rituals als Handseife und Handlotion verwenden, ein Ort, den ich absolut empfehle.', 'Harika bir deneyim, gelir gelmez bana çok lezzetli bir cappuccino ikram ettiler, personel çok profesyonel ve nazik, mekân temiz, tuvalette el sabunu ve el losyonu olarak Rituals ürünleri kullanmaları hoşuma gitti, kesinlikle tavsiye ettiğim bir yer.',
    0, '2025-10-03 00:00:00'),

(@user_danica_obradovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2podGExQnZUMkZZWTJ3dExWUlJiRUp3UmtoMmRFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-03 00:00:00'),

(@user_kristina_tolpina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pCbGJuRTVjMUZxZFc5d1NVVXRTRGxKZUc5eFlsRRAB',
    4, 'ru', '🥰 Понравилось:) Сервис хороший, мастер Александра приятная. Много выбора цветов и комплиментарных напитков 🤪 Делала наращивание, покрытие гель лаком и дизайн (2 уровня, как сказали ))) €110. К сожалению, по краям немного неаккуратно вышло, неровно лег тон. А так все хорошо. Спасибо🥰 …',
    '🥰 Svidjelo mi se:) Servis je dobar, majstorica Aleksandra prijatna. Veliki izbor boja i napitaka na račun kuće 🤪 Radila sam nadogradnju, trajni lak i dizajn (2 nivoa, kako su rekli ))) €110. Nažalost, po ivicama je ispalo malo neuredno, ton nije legao ravnomjerno. A inače je sve u redu. Hvala🥰 …', '🥰 Свидјело ми се:) Сервис је добар, мајсторица Александра пријатна. Велики избор боја и напитака на рачун куће 🤪 Радила сам надоградњу, трајни лак и дизајн (2 нивоа, како су рекли ))) €110. Нажалост, по ивицама је испало мало неуредно, тон није легао равномјерно. А иначе је све у реду. Хвала🥰 …', '🥰 I liked it:) Good service, Aleksandra the technician is lovely. Lots of colours to choose from and complimentary drinks 🤪 I had extensions, gel polish and nail art done (2 levels, as they put it ))) €110. Unfortunately it came out a bit untidy along the edges, the colour went on unevenly. Other than that everything is fine. Thank you🥰 …', '🥰 Понравилось:) Сервис хороший, мастер Александра приятная. Много выбора цветов и комплиментарных напитков 🤪 Делала наращивание, покрытие гель лаком и дизайн (2 уровня, как сказали ))) €110. К сожалению, по краям немного неаккуратно вышло, неровно лег тон. А так все хорошо. Спасибо🥰 …', '🥰 Hat mir gefallen:) Der Service ist gut, die Nageldesignerin Aleksandra ist sympathisch. Große Farbauswahl und Getränke aufs Haus 🤪 Ich habe eine Verlängerung, Gellack und Design machen lassen (2 Stufen, wie sie sagten ))) €110. Leider ist es an den Rändern etwas unsauber geworden, der Farbton liegt ungleichmäßig. Ansonsten alles gut. Danke🥰 …', '🥰 Beğendim:) Hizmet iyi, uzman Aleksandra çok hoş biri. Bol renk seçeneği ve ikram içecekler 🤪 Protez tırnak, kalıcı oje ve tasarım yaptırdım (dedikleri gibi 2 seviye ))) €110. Ne yazık ki kenarlarda biraz özensiz oldu, ton eşit yayılmadı. Onun dışında her şey iyi. Teşekkürler🥰 …',
    0, '2025-10-03 00:00:00'),

(@user_ekaterina_drapun, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xWWVNURlRUMFY2WW01cFpFaHpkMHRKVlhoMFpsRRAB',
    5, 'en', 'I tried a pedicure here once and will for sure come back. I can recommend it',
    'Jednom sam ovdje probala pedikir i sigurno ću se vratiti. Mogu da preporučim', 'Једном сам овдје пробала педикир и сигурно ћу се вратити. Могу да препоручим', 'I tried a pedicure here once and will for sure come back. I can recommend it', 'Один раз сделала здесь педикюр и точно вернусь снова. Могу рекомендовать', 'Ich habe hier einmal eine Pediküre ausprobiert und komme auf jeden Fall wieder. Ich kann es empfehlen', 'Burada bir kez pedikür denedim ve kesinlikle tekrar geleceğim. Tavsiye edebilirim',
    0, '2025-10-03 00:00:00'),

(@user_billi_bonsa, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21rM2VUVTJNR05YUTJ4cFFtRnRSazVtT1hCUFQyYxAB',
    5, 'ru', 'Все на высоте. Сервис, комфорт, внимание! Спасибо!',
    'Sve je na visini. Servis, komfor, pažnja! Hvala!', 'Све је на висини. Сервис, комфор, пажња! Хвала!', 'Everything is top notch. The service, the comfort, the attention! Thank you!', 'Все на высоте. Сервис, комфорт, внимание! Спасибо!', 'Alles auf höchstem Niveau. Service, Komfort, Aufmerksamkeit! Danke!', 'Her şey üst düzeyde. Hizmet, konfor, ilgi! Teşekkürler!',
    0, '2025-09-03 00:00:00'),

(@user_tatyana_podlesnyak, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWS1RubFhlVVpLVVhjemVVRm1UR0ZFY2kxU1MyYxAB',
    5, 'ru', 'Все отлично за исключением соблюдения приватности. Мастера никогда  не спрашивают разрешения сделать фото ваших ногтей до и после процедуры. Я каждый раз хочу уклониться , но уже заведен над моими руками/ногами телефон и фото куда-то уходит.   Из этой оперы отсутствие внятной перегородки в зоне, где расположены кресла, где происходит педикюр.  Менеджеру Камилле позволено ходить с конским хвостом и разложенными по всемц одежде упавшими длинными черными волосами, при том,что она готовит и приносит напитки и еду посетителям, в то время как девочки ,чудесные пчёлки -мастера замотаны- обмотаны, как в хирургическом отделении. Не логично, и некорректно,  учитывая концепцию заведения с явно выраженной политикой чистоты и дезинфекции.  Кроме прочего этому сотруднику неплохо было бы объяснить, что устраивать допросы клиента,сидящего в кресле на педикюре, в таком , скажу ,уязвимом положении,  о том : как вы записались, с какого ресурса, а почему у Вас другой номер телефона, а не тот,что вы назвали... , а Вы точно у нас уже были? А ну-ка, вспоминай когда ? Щас проверю))) Просто за гранью )) и по форме и по содержанию.  Словом создатели этого места сделали все идеально. Но ..  кадры решают все. Это ни в коем случае не относится к мастерам. Эти девочки безукоризнены. С уважением, Татьяна',
    'Sve je odlično osim poštovanja privatnosti. Majstorice nikada ne pitaju za dozvolu da fotografišu vaše nokte prije i poslije tretmana. Svaki put želim da se izmaknem, ali telefon je već nad mojim rukama/nogama i fotografija odlazi nekud. Iz istog repertoara je i nepostojanje kakve-takve pregrade u zoni gdje su fotelje, gdje se radi pedikir. Menadžerki Kamili je dozvoljeno da hoda sa konjskim repom i sa opalim dugim crnim vlasima razasutim po cijeloj odjeći, i to dok priprema i donosi napitke i hranu gostima, a djevojke, te divne pčelice - majstorice, umotane su i obmotane kao na hirurškom odjeljenju. Nije logično i nije korektno, ako se ima u vidu koncept salona sa izrazito naglašenom politikom čistoće i dezinfekcije. Uz to, ovoj zaposlenoj ne bi bilo loše objasniti da je ispitivati klijenta koji sjedi u fotelji na pedikiru, u tako, recimo, ranjivom položaju - kako ste se zakazali, sa kog sajta, a zašto imate drugi broj telefona, a ne onaj koji ste rekli..., a da li ste sigurno već bili kod nas? Ajde, sjeti se kad? Sad ću da provjerim))) - prosto preko svake granice )) i po formi i po sadržaju. Ukratko, tvorci ovog mjesta su sve uradili idealno. Ali.. kadrovi su ono što sve odlučuje. Ovo se nikako ne odnosi na majstorice. Te djevojke su besprekorne. S poštovanjem, Tatjana', 'Све је одлично осим поштовања приватности. Мајсторице никада не питају за дозволу да фотографишу ваше нокте прије и послије третмана. Сваки пут желим да се измакнем, али телефон је већ над мојим рукама/ногама и фотографија одлази некуд. Из истог репертоара је и непостојање какве-такве преграде у зони гдје су фотеље, гдје се ради педикир. Менаџерки Камили је дозвољено да хода са коњским репом и са опалим дугим црним власима разасутим по цијелој одјећи, и то док припрема и доноси напитке и храну гостима, а дјевојке, те дивне пчелице - мајсторице, умотане су и обмотане као на хируршком одјељењу. Није логично и није коректно, ако се има у виду концепт салона са изразито наглашеном политиком чистоће и дезинфекције. Уз то, овој запосленој не би било лоше објаснити да је испитивати клијента који сједи у фотељи на педикиру, у тако, рецимо, рањивом положају - како сте се заказали, са ког сајта, а зашто имате други број телефона, а не онај који сте рекли..., а да ли сте сигурно већ били код нас? Ајде, сјети се кад? Сад ћу да провјерим))) - просто преко сваке границе )) и по форми и по садржају. Укратко, творци овог мјеста су све урадили идеално. Али.. кадрови су оно што све одлучује. Ово се никако не односи на мајсторице. Те дјевојке су беспрекорне. С поштовањем, Татјана', 'Everything is excellent except for respecting privacy. The technicians never ask permission to photograph your nails before and after the treatment. Every time I want to dodge it, but the phone is already up over my hands/feet and the photo goes off somewhere. Along the same lines, there is no proper partition in the area where the chairs are, where the pedicure is done. The manager Kamila is allowed to walk around with a ponytail and long black hairs that have fallen out spread all over her clothes, and that while she prepares and brings drinks and food to visitors, whereas the girls, those wonderful little bees - the technicians - are wrapped and bundled up as if in a surgical ward. It isn\'t logical and it isn\'t right, given the concept of a place with an emphatically stated policy of cleanliness and disinfection. Besides that, it wouldn\'t hurt to explain to this employee that interrogating a client who is sitting in the chair having a pedicure, in such a, let\'s say, vulnerable position - how did you book, from which platform, and why do you have a different phone number and not the one you gave..., and are you sure you\'ve been to us before? Come on, remember when? I\'ll check right now))) - is simply beyond the pale )) both in form and in substance. In short, the creators of this place have done everything perfectly. But.. staff are what decides everything. This in no way applies to the technicians. Those girls are impeccable. Respectfully, Tatjana', 'Все отлично за исключением соблюдения приватности. Мастера никогда  не спрашивают разрешения сделать фото ваших ногтей до и после процедуры. Я каждый раз хочу уклониться , но уже заведен над моими руками/ногами телефон и фото куда-то уходит.   Из этой оперы отсутствие внятной перегородки в зоне, где расположены кресла, где происходит педикюр.  Менеджеру Камилле позволено ходить с конским хвостом и разложенными по всемц одежде упавшими длинными черными волосами, при том,что она готовит и приносит напитки и еду посетителям, в то время как девочки ,чудесные пчёлки -мастера замотаны- обмотаны, как в хирургическом отделении. Не логично, и некорректно,  учитывая концепцию заведения с явно выраженной политикой чистоты и дезинфекции.  Кроме прочего этому сотруднику неплохо было бы объяснить, что устраивать допросы клиента,сидящего в кресле на педикюре, в таком , скажу ,уязвимом положении,  о том : как вы записались, с какого ресурса, а почему у Вас другой номер телефона, а не тот,что вы назвали... , а Вы точно у нас уже были? А ну-ка, вспоминай когда ? Щас проверю))) Просто за гранью )) и по форме и по содержанию.  Словом создатели этого места сделали все идеально. Но ..  кадры решают все. Это ни в коем случае не относится к мастерам. Эти девочки безукоризнены. С уважением, Татьяна', 'Alles ist hervorragend, mit Ausnahme der Privatsphäre. Die Nagelspezialistinnen fragen nie um Erlaubnis, Fotos von Ihren Nägeln vor und nach der Behandlung zu machen. Jedes Mal möchte ich ausweichen, aber das Handy ist schon über meinen Händen/Füßen und das Foto wandert irgendwohin. In dieselbe Kategorie gehört das Fehlen einer richtigen Trennwand in dem Bereich, wo die Sessel stehen, wo die Pediküre gemacht wird. Der Managerin Kamila ist es erlaubt, mit Pferdeschwanz und mit ausgefallenen langen schwarzen Haaren, die über ihrer ganzen Kleidung verteilt sind, herumzulaufen, und das, obwohl sie Getränke und Essen für die Gäste zubereitet und bringt, während die Mädchen, diese wunderbaren Bienchen - die Spezialistinnen -, eingewickelt und verhüllt sind wie in einer chirurgischen Abteilung. Das ist nicht logisch und nicht korrekt, wenn man das Konzept eines Salons mit einer ausdrücklich betonten Politik von Sauberkeit und Desinfektion bedenkt. Außerdem wäre es nicht schlecht, dieser Mitarbeiterin zu erklären, dass es einfach jenseits aller Grenzen ist )) - in Form und Inhalt -, eine Kundin, die im Sessel bei der Pediküre sitzt, in einer, sagen wir, verletzlichen Position, zu verhören: Wie haben Sie gebucht, über welches Portal, und warum haben Sie eine andere Telefonnummer als die, die Sie genannt haben..., und waren Sie wirklich schon bei uns? Na los, erinnere dich, wann? Ich prüfe das gleich mal))). Kurzum, die Schöpfer dieses Ortes haben alles perfekt gemacht. Aber.. das Personal entscheidet alles. Das betrifft in keiner Weise die Spezialistinnen. Diese Mädchen sind einwandfrei. Mit freundlichen Grüßen, Tatjana', 'Gizliliğe saygı dışında her şey harika. Uzmanlar, işlemden önce ve sonra tırnaklarınızın fotoğrafını çekmek için asla izin istemiyor. Her seferinde kaçınmak istiyorum ama telefon çoktan ellerimin/ayaklarımın üzerine gelmiş oluyor ve fotoğraf bir yere gidiyor. Aynı hesap: pedikürün yapıldığı, koltukların bulunduğu bölümde düzgün bir bölme yok. Müdür Kamila\'nın atkuyruğuyla ve kıyafetinin her yerine dökülmüş uzun siyah saçlarla dolaşmasına izin veriliyor; hem de misafirlere içecek ve yemek hazırlayıp getirirken. Oysa kızlar, o harika arı gibi uzmanlar, cerrahi servisteymiş gibi sarılıp sarmalanmış durumda. Salonun açıkça vurgulanan temizlik ve dezenfeksiyon politikası düşünülünce bu ne mantıklı ne de doğru. Bunun dışında, bu çalışana şunu anlatmak fena olmazdı: pedikür koltuğunda oturan, deyim yerindeyse savunmasız durumdaki bir müşteriyi sorguya çekmek - nasıl randevu aldınız, hangi siteden, neden söylediğinizden farklı bir telefon numaranız var..., bize daha önce geldiğinizden emin misiniz? Hadi bakalım, hatırla, ne zaman? Şimdi kontrol edeyim))) - hem biçim hem içerik olarak haddi aşıyor )). Kısacası, bu mekânı kuranlar her şeyi kusursuz yapmış. Ama.. her şeyi kadro belirliyor. Bu kesinlikle uzmanlar için geçerli değil. O kızlar kusursuz. Saygılarımla, Tatyana',
    0, '2025-09-03 00:00:00'),

(@user_oleksandra_kharkovenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNMOHBXUWJnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-09-03 00:00:00'),

(@user_margarita_kandlina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tkMlEybHRkRWx0TkVGS1JqRjBXWE0xTm01dlIyYxAB',
    5, 'ru', 'Светлана-прекрасный мастер!
Всегда идеальный маникюр за 1.20-1.30 ч. Никаких тонн гель-лака, только естественность 🩷
Благодарю!',
    'Svetlana je divna majstorica!
Uvijek idealan manikir za 1.20-1.30 h. Nikakve tone trajnog laka, samo prirodnost 🩷
Hvala!', 'Светлана је дивна мајсторица!
Увијек идеалан маникир за 1.20-1.30 ч. Никакве тоне трајног лака, само природност 🩷
Хвала!', 'Svetlana is a wonderful technician!
Always a perfect manicure in 1.20-1.30 h. No tons of gel polish, just a natural look 🩷
Thank you!', 'Светлана-прекрасный мастер!
Всегда идеальный маникюр за 1.20-1.30 ч. Никаких тонн гель-лака, только естественность 🩷
Благодарю!', 'Svetlana ist eine wunderbare Nageldesignerin!
Immer eine perfekte Maniküre in 1.20-1.30 Std. Keine Tonnen Gellack, nur Natürlichkeit 🩷
Danke!', 'Svetlana harika bir uzman!
Her zaman 1.20-1.30 saatte kusursuz manikür. Tonlarca kalıcı oje yok, sadece doğallık 🩷
Teşekkür ederim!',
    0, '2025-09-03 00:00:00'),

(@user_anna_is, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTUNZdWV1WjNBRRAB',
    5, 'ru', 'Идеальное исполнение всех пожеланий, 100% комфорта и безукоризненный сервис. Процветания компании и побольше довольных клиентов!',
    'Idealno ispunjenje svih želja, 100% komfora i besprekoran servis. Želim firmi napredak i još više zadovoljnih klijenata!', 'Идеално испуњење свих жеља, 100% комфора и беспрекоран сервис. Желим фирми напредак и још више задовољних клијената!', 'Every wish carried out perfectly, 100% comfort and impeccable service. Wishing the company prosperity and lots more happy clients!', 'Идеальное исполнение всех пожеланий, 100% комфорта и безукоризненный сервис. Процветания компании и побольше довольных клиентов!', 'Alle Wünsche perfekt erfüllt, 100% Komfort und tadelloser Service. Ich wünsche dem Unternehmen viel Erfolg und noch mehr zufriedene Kunden!', 'Bütün isteklerin kusursuz şekilde yerine getirilmesi, %100 konfor ve mükemmel hizmet. Şirkete bol kazanç ve daha çok memnun müşteri dilerim!',
    0, '2025-09-03 00:00:00'),

(@user_ivan_ivanov, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tRMlpYQkhkRTVOYlhwa04wMWZYMVJhYjBWU1JsRRAB',
    5, 'ru', 'Компетентный врач, помог решить проблему в кратчайшие сроки',
    'Kompetentan ljekar, pomogao je da se problem riješi u najkraćem roku', 'Компетентан љекар, помогао је да се проблем ријеши у најкраћем року', 'A competent doctor, he helped solve the problem in the shortest possible time', 'Компетентный врач, помог решить проблему в кратчайшие сроки', 'Ein kompetenter Arzt, er hat geholfen, das Problem in kürzester Zeit zu lösen', 'Yetkin bir doktor, sorunu en kısa sürede çözmeye yardımcı oldu',
    0, '2025-09-03 00:00:00'),

(@user_anas, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xWd1JXcHZhbTFwZEVsVE1HTlBjVkpSVlVWWlEzYxAB',
    5, 'fr', 'Top ! J’ai été accueilli par Yana, et prise en charge par Svieta, deux perles ! La qualité de leur service est super, elles ont été très gentilles 😍
Je me suis rendue dans ce salon aléatoirement car je suis en vacances et j’avais besoin de refaire mes ongles qui étaient dans un sale état.
J’ai eu un rendez-vous dans la journée, Svieta a pris le temps de me faire une reconstruction de deux ongles cassés en plus de la pose en gel et de la manucure complète avec massage des mains.
Yana vous propose un thé, café ou de l’eau et quelques petites douceurs à manger. Elle a même donner à mon fils des coloriages pour qu’il s’occupe.
J’ai beaucoup apprécié mon expérience dans leur salon qui était au dessus de mes attentes 🤩 tout est parfait, l’ambiance, le service, le salon, les hôtes qui vous reçoivent. Je les recommande à 300 % elles sont TOP TOP TOP !',
    'Top! Primila me je Yana, a o meni se brinula Svieta, dva bisera! Kvalitet njihove usluge je super, bile su veoma ljubazne 😍
U ovaj salon sam došla slučajno jer sam na odmoru i trebalo je da popravim nokte koji su bili u lošem stanju.
Dobila sam termin isti dan, Svieta je odvojila vrijeme da mi rekonstruiše dva slomljena nokta, pored postavljanja gela i kompletnog manikira sa masažom ruku.
Yana vam ponudi čaj, kafu ili vodu i nekoliko malih slatkiša. Mom sinu je čak dala bojanke da se zabavi.
Veoma mi se dopalo iskustvo u njihovom salonu, bilo je iznad mojih očekivanja 🤩 sve je savršeno: atmosfera, usluga, salon, domaćice koje vas primaju. Preporučujem ih 300%, one su TOP TOP TOP!', 'Top! Примила ме је Јана, а о мени се бринула Свјета, два бисера! Квалитет њихове услуге је супер, биле су веома љубазне 😍
У овај салон сам дошла случајно јер сам на одмору и требало је да поправим нокте који су били у лошем стању.
Добила сам термин исти дан, Свјета је одвојила вријеме да ми реконструише два сломљена нокта, поред постављања гела и комплетног маникира са масажом руку.
Јана вам понуди чај, кафу или воду и неколико малих слаткиша. Мом сину је чак дала бојанке да се забави.
Веома ми се допало искуство у њиховом салону, било је изнад мојих очекивања 🤩 све је савршено: атмосфера, услуга, салон, домаћице које вас примају. Препоручујем их 300%, оне су TOP TOP TOP!', 'Top! I was welcomed by Yana and taken care of by Svieta, two gems! The quality of their service is great, they were very kind 😍
I came to this salon at random because I\'m on holiday and needed to redo my nails, which were in a sorry state.
I got an appointment the same day, Svieta took the time to rebuild two broken nails on top of the gel application and a full manicure with a hand massage.
Yana offers you tea, coffee or water and a few little sweets to nibble on. She even gave my son colouring pages to keep him busy.
I really enjoyed my experience in their salon, it was above my expectations 🤩 everything is perfect: the atmosphere, the service, the salon, the hostesses who welcome you. I recommend them 300%, they are TOP TOP TOP!', 'Супер! Меня встретила Яна, а занималась мной Света — две жемчужины! Качество их работы супер, они были очень милые 😍
В этот салон я попала случайно, потому что я в отпуске и мне надо было привести в порядок ногти, которые были в жутком состоянии.
Меня записали в тот же день, Света не пожалела времени и восстановила мне два сломанных ногтя вдобавок к покрытию гелем и полному маникюру с массажем рук.
Яна предлагает вам чай, кофе или воду и немного сладостей. Она даже дала моему сыну раскраски, чтобы ему было чем заняться.
Мне очень понравился опыт в их салоне, всё было выше моих ожиданий 🤩 всё идеально: атмосфера, сервис, сам салон, хозяйки, которые вас принимают. Рекомендую их на 300%, они ТОП ТОП ТОП!', 'Top! Ich wurde von Yana empfangen und von Svieta betreut, zwei Perlen! Die Qualität ihrer Arbeit ist super, sie waren sehr freundlich 😍
Ich bin zufällig in diesen Salon gekommen, denn ich bin im Urlaub und musste meine Nägel machen lassen, die in einem schlimmen Zustand waren.
Ich habe noch am selben Tag einen Termin bekommen, Svieta hat sich die Zeit genommen, mir zwei abgebrochene Nägel zu rekonstruieren, zusätzlich zum Gelaufbau und der kompletten Maniküre mit Handmassage.
Yana bietet Ihnen Tee, Kaffee oder Wasser und ein paar kleine Süßigkeiten an. Sie hat meinem Sohn sogar Malbilder gegeben, damit er sich beschäftigen kann.
Mir hat mein Erlebnis in ihrem Salon sehr gefallen, es lag über meinen Erwartungen 🤩 alles ist perfekt: die Atmosphäre, der Service, der Salon, die Gastgeberinnen, die einen empfangen. Ich empfehle sie zu 300 %, sie sind TOP TOP TOP!', 'Harika! Beni Yana karşıladı, benimle Svieta ilgilendi, ikisi de birer inci! Hizmetlerinin kalitesi süper, çok kibardılar 😍
Bu salona tesadüfen gittim, çünkü tatildeyim ve berbat durumda olan tırnaklarımı yeniletmem gerekiyordu.
Aynı gün içinde randevu aldım; Svieta, jel uygulaması ve el masajlı komple manikürün yanı sıra kırılmış iki tırnağımı yeniden yapmak için de zaman ayırdı.
Yana size çay, kahve ya da su ve birkaç küçük tatlı ikram ediyor. Oğluma oyalanması için boyama sayfaları bile verdi.
Salonlarındaki deneyimden çok memnun kaldım, beklentilerimin üzerindeydi 🤩 her şey kusursuz: atmosfer, hizmet, salonun kendisi, sizi karşılayan ev sahibeleri. Onları %300 tavsiye ediyorum, TOP TOP TOP!',
    0, '2025-09-03 00:00:00'),

(@user_yuliia_rakovska, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT205elgyNVRaMDlSUm1WcFVFWk9kMjlyWldkeUxVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_polina_v, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKSlIwcEtOalJPT1c5eFZtZFJXak5STVZSMlRuYxAB',
    5, 'ru', 'Очень хороший салон с профессиональными мастерами и качественным сервисом. Ходим вместе с мамой и очень довольны. Всем рекомендую!',
    'Vrlo dobar salon sa profesionalnim majstorima i kvalitetnom uslugom. Idemo zajedno sa mamom i vrlo smo zadovoljne. Svima preporučujem!', 'Врло добар салон са професионалним мајсторима и квалитетном услугом. Идемо заједно са мамом и врло смо задовољне. Свима препоручујем!', 'A really good salon with professional specialists and quality service. My mum and I go together and we\'re very happy. I recommend it to everyone!', 'Очень хороший салон с профессиональными мастерами и качественным сервисом. Ходим вместе с мамой и очень довольны. Всем рекомендую!', 'Ein sehr guter Salon mit professionellen Fachkräften und hochwertigem Service. Ich gehe zusammen mit meiner Mama hin und wir sind sehr zufrieden. Ich empfehle es allen!', 'Profesyonel uzmanları ve kaliteli hizmeti olan çok iyi bir salon. Annemle birlikte gidiyoruz ve çok memnunuz. Herkese tavsiye ederim!',
    0, '2025-08-03 00:00:00'),

(@user_ruslan, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNIdHZiZmRBEAE',
    5, 'ru', 'Так держать !',
    'Samo tako nastavite !', 'Само тако настављајте !', 'Keep it up !', 'Так держать !', 'Weiter so !', 'Böyle devam !',
    0, '2025-08-03 00:00:00'),

(@user_lyudmila_boytsova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21wb00ybExObFIzYkhScFltTmhhVVZtUWxCSloxRRAB',
    5, 'ru', 'Огромное спасибо! Все очень понравилось. Очень приятная обстановка, вежливые и квалифицированные специалисты. Спасибо!!!',
    'Ogromno hvala! Sve mi se vrlo dopalo. Vrlo prijatna atmosfera, ljubazni i kvalifikovani stručnjaci. Hvala!!!', 'Огромно хвала! Све ми се врло допало. Врло пријатна атмосфера, љубазни и квалификовани стручњаци. Хвала!!!', 'Thank you so much! I liked everything very much. Very pleasant atmosphere, polite and qualified specialists. Thank you!!!', 'Огромное спасибо! Все очень понравилось. Очень приятная обстановка, вежливые и квалифицированные специалисты. Спасибо!!!', 'Vielen herzlichen Dank! Mir hat alles sehr gut gefallen. Sehr angenehme Atmosphäre, höfliche und qualifizierte Fachkräfte. Danke!!!', 'Çok teşekkür ederim! Her şey çok hoşuma gitti. Çok hoş bir ortam, nazik ve nitelikli uzmanlar. Teşekkürler!!!',
    0, '2025-08-03 00:00:00'),

(@user_ekaterina_naryshkina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNKdV9IRzhnRRAB',
    5, 'ru', 'Самый лучший салон в Будве. Вероятно, и во всей Черногории. Всё всегда на высшем уровне. Мастера, атмосфера, материалы, сервис. Желаю процветания!',
    'Najbolji salon u Budvi. Vjerovatno i u cijeloj Crnoj Gori. Sve je uvijek na najvišem nivou. Majstori, atmosfera, materijali, usluga. Želim vam napredak!', 'Најбољи салон у Будви. Вјероватно и у цијелој Црној Гори. Све је увијек на највишем нивоу. Мајстори, атмосфера, материјали, услуга. Желим вам напредак!', 'The very best salon in Budva. Probably in all of Montenegro. Everything is always top level. The specialists, the atmosphere, the materials, the service. Wishing you prosperity!', 'Самый лучший салон в Будве. Вероятно, и во всей Черногории. Всё всегда на высшем уровне. Мастера, атмосфера, материалы, сервис. Желаю процветания!', 'Der allerbeste Salon in Budva. Wahrscheinlich in ganz Montenegro. Alles ist immer auf höchstem Niveau. Die Fachkräfte, die Atmosphäre, die Materialien, der Service. Ich wünsche euch viel Erfolg!', 'Budva\'daki en iyi salon. Muhtemelen tüm Karadağ\'da da. Her şey her zaman en üst seviyede. Uzmanlar, ortam, malzemeler, hizmet. Bol kazanç dilerim!',
    0, '2025-08-03 00:00:00'),

(@user_imya_familiya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25vMVdtdDJOak5VY0hsUGF6UTVNR294YnpZMmFsRRAB',
    5, 'ru', 'Волшебно!',
    'Čarobno!', 'Чаробно!', 'Magical!', 'Волшебно!', 'Zauberhaft!', 'Büyülü!',
    0, '2025-08-03 00:00:00'),

(@user_claudia_kinomoto, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25sZmNrTnlhakZuYjA0d2NtNVZURzFFVFZkdVltYxAB',
    5, 'ru', 'Я не нашла больше мест с мед педикюром и очень рада, что есть такое приятное место как это. Все от ресепшена до подолога приятно и качественно. Всегда с удовольствием возвращаюсь сюда. Ноги тоже всегда благодарны 😍',
    'Nisam našla druga mjesta sa medicinskim pedikirom i vrlo sam sretna što postoji tako prijatno mjesto kao ovo. Sve, od recepcije do podologa, prijatno je i kvalitetno. Uvijek se sa zadovoljstvom vraćam ovdje. I moja stopala su uvijek zahvalna 😍', 'Нисам нашла друга мјеста са медицинским педикиром и врло сам сретна што постоји тако пријатно мјесто као ово. Све, од рецепције до подолога, пријатно је и квалитетно. Увијек се са задовољством враћам овдје. И моја стопала су увијек захвална 😍', 'I haven\'t found any other places doing medical pedicures and I\'m so glad a place as nice as this one exists. Everything, from the reception desk to the podiatrist, is pleasant and done well. I always come back here with pleasure. My feet are always grateful too 😍', 'Я не нашла больше мест с мед педикюром и очень рада, что есть такое приятное место как это. Все от ресепшена до подолога приятно и качественно. Всегда с удовольствием возвращаюсь сюда. Ноги тоже всегда благодарны 😍', 'Ich habe keine anderen Orte mit medizinischer Fußpflege gefunden und bin sehr froh, dass es so einen angenehmen Ort wie diesen gibt. Alles, vom Empfang bis zum Podologen, ist angenehm und hochwertig. Ich komme immer gerne wieder hierher. Meine Füße sind auch immer dankbar 😍', 'Medikal pedikür yapan başka bir yer bulamadım ve bu kadar hoş bir yerin olmasına çok sevindim. Resepsiyondan podologa kadar her şey hem hoş hem kaliteli. Buraya her zaman zevkle geri dönüyorum. Ayaklarım da her zaman minnettar 😍',
    0, '2025-08-03 00:00:00'),

(@user_ekaterina_shabanova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT205aGRVOHpNMFZ4VlRGeWVVSmpXUzFaTkVWWmRuYxAB',
    5, 'ru', 'Центр высочайшего уровня! Очень профессионально, чисто, быстро, с приятной атмосферой! Благодарю!',
    'Centar najvišeg nivoa! Vrlo profesionalno, čisto, brzo i sa prijatnom atmosferom! Zahvaljujem!', 'Центар највишег нивоа! Врло професионално, чисто, брзо и са пријатном атмосфером! Захваљујем!', 'A top-level centre! Very professional, clean, quick, with a pleasant atmosphere! Thank you!', 'Центр высочайшего уровня! Очень профессионально, чисто, быстро, с приятной атмосферой! Благодарю!', 'Ein Zentrum auf höchstem Niveau! Sehr professionell, sauber, schnell und mit angenehmer Atmosphäre! Ich danke Ihnen!', 'En üst seviyede bir merkez! Çok profesyonel, temiz, hızlı ve hoş bir ortam! Teşekkür ederim!',
    0, '2025-08-03 00:00:00'),

(@user_elena_nikolich, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2taTlpEUldUbEJhVEdob2N6Y3pkVWQ2WDNkamNGRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_nataliya_v, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoa1EybzRlVlJvWWs1a2RHOXNXSE5GVlRKV2RsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_anastasiia_kovalchuk, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTUNvaGRmNmV3EAE',
    5, 'ru', 'Девочки, у меня всегда была проблема с ногтями. Ни одно покрытие не держалось больше недели. Я перепробовала наверное всех специалистов в Будве, но всегда были сколы через 5-7 дней. И отчаявшись, я решила обратиться в iPODO, так как ранее бывала там у подолога и осталась довольна. Изначально меня смущал прайс, но когда я отходила 3,5 недели с идеальными ногтями, без единого скола, с сияющим цветом, я поняла за что плачу. Мне наконец-то подобрали правильный материал и вид укрепления. Так же у них шикарный ассортимент цветов! Просто невероятный выбор! Цвета Люксио особенно стойкие и не выгорают. Сервис шикарный, обслуживание супер. Но самое главное результат!',
    'Djevojke, ja sam uvijek imala problem sa noktima. Nijedan lak nije držao duže od nedjelju dana. Isprobala sam vjerovatno sve majstore u Budvi, ali su se uvijek pojavljivala okrzanja nakon 5-7 dana. I u očaju sam odlučila da se obratim iPODO, jer sam prije toga bila tamo kod podologa i ostala zadovoljna. U početku me je zbunjivao cjenovnik, ali kada sam 3,5 nedjelje prohodala sa savršenim noktima, bez ijednog okrzanja, sa sjajnom bojom, shvatila sam za šta plaćam. Konačno su mi izabrali pravi materijal i vrstu ojačanja. Takođe imaju sjajan asortiman boja! Prosto nevjerovatan izbor! Luxio boje su posebno izdržljive i ne blijede. Servis je sjajan, usluga super. Ali najvažnije je rezultat!', 'Дјевојке, ја сам увијек имала проблем са ноктима. Ниједан лак није држао дуже од недјељу дана. Испробала сам вјероватно све мајсторе у Будви, али су се увијек појављивала окрзања након 5-7 дана. И у очају сам одлучила да се обратим iPODO, јер сам прије тога била тамо код подолога и остала задовољна. У почетку ме је збуњивао цјеновник, али када сам 3,5 недјеље проходала са савршеним ноктима, без иједног окрзања, са сјајном бојом, схватила сам за шта плаћам. Коначно су ми изабрали прави материјал и врсту ојачања. Такође имају сјајан асортиман боја! Просто невјероватан избор! Luxio боје су посебно издржљиве и не блиједе. Сервис је сјајан, услуга супер. Али најважније је резултат!', 'Girls, I\'ve always had a problem with my nails. No coating would last more than a week. I\'ve probably tried every specialist in Budva, but there were always chips after 5-7 days. In despair, I decided to go to iPODO, since I\'d been there before to see the podiatrist and was happy with it. At first the price list put me off, but once I\'d gone 3.5 weeks with perfect nails, not a single chip, with the colour still shining, I understood what I was paying for. They finally picked the right material and type of reinforcement for me. They also have a gorgeous range of colours! Just an incredible selection! The Luxio colours are especially long-lasting and don\'t fade. The service is gorgeous, the care is super. But the main thing is the result!', 'Девочки, у меня всегда была проблема с ногтями. Ни одно покрытие не держалось больше недели. Я перепробовала наверное всех специалистов в Будве, но всегда были сколы через 5-7 дней. И отчаявшись, я решила обратиться в iPODO, так как ранее бывала там у подолога и осталась довольна. Изначально меня смущал прайс, но когда я отходила 3,5 недели с идеальными ногтями, без единого скола, с сияющим цветом, я поняла за что плачу. Мне наконец-то подобрали правильный материал и вид укрепления. Так же у них шикарный ассортимент цветов! Просто невероятный выбор! Цвета Люксио особенно стойкие и не выгорают. Сервис шикарный, обслуживание супер. Но самое главное результат!', 'Mädels, ich hatte immer Probleme mit meinen Nägeln. Kein Lack hielt länger als eine Woche. Ich habe wahrscheinlich alle Spezialistinnen in Budva ausprobiert, aber nach 5-7 Tagen gab es immer Abplatzer. Aus Verzweiflung habe ich mich entschieden, zu iPODO zu gehen, da ich vorher schon beim Podologen dort war und zufrieden war. Anfangs hat mich die Preisliste verunsichert, aber als ich 3,5 Wochen mit perfekten Nägeln herumgelaufen bin, ohne einen einzigen Abplatzer, mit strahlender Farbe, habe ich verstanden, wofür ich bezahle. Endlich hat man für mich das richtige Material und die richtige Art der Verstärkung ausgewählt. Außerdem haben sie ein tolles Farbsortiment! Einfach eine unglaubliche Auswahl! Die Luxio-Farben sind besonders haltbar und bleichen nicht aus. Der Service ist toll, die Betreuung super. Aber das Wichtigste ist das Ergebnis!', 'Kızlar, tırnaklarımla her zaman sorunum vardı. Hiçbir kaplama bir haftadan fazla dayanmıyordu. Budva\'daki neredeyse tüm uzmanları denedim ama 5-7 gün sonra hep çatlaklar oluşuyordu. Çaresizlikten iPODO\'ya gitmeye karar verdim, çünkü daha önce orada podologa gitmiştim ve memnun kalmıştım. Başta fiyat listesi beni tedirgin etmişti, ama 3,5 hafta boyunca kusursuz tırnaklarla, tek bir çatlak olmadan, rengi hâlâ parlarken gezdiğimde ne için para ödediğimi anladım. Sonunda bana doğru malzemeyi ve doğru güçlendirme türünü seçtiler. Ayrıca harika bir renk yelpazesi var! Gerçekten inanılmaz bir seçenek! Luxio renkleri özellikle dayanıklı ve solmuyor. Servis harika, hizmet süper. Ama en önemlisi sonuç!',
    0, '2025-08-03 00:00:00'),

(@user_marina_khalabi, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT205bWVFUXRPR2QzU2tkeE9GVnVjazVPWlhsdVNVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_irina_bitieva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VMRE15SjY5bjRfNzlBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_yana_solovtsova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25SVVQweGxlV2sxV0VoZlFtNVpRMnMwT0U4dGRrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_ekaterina_izmaylova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VOcXN1NldBLTlUWHRBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_eva_s, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VPLXB3S0RmOEx1U2JnEAE',
    5, 'ru', 'Это жемчужина Черногории в прямом смысле слова! Я очень долго искала специалиста-подолога и Анюта невероятная находка. Спасибо огромное!',
    'Ovo je biser Crne Gore u pravom smislu te riječi! Vrlo dugo sam tražila podologa i Anjuta je nevjerovatno otkriće. Ogromno hvala!', 'Ово је бисер Црне Горе у правом смислу те ријечи! Врло дуго сам тражила подолога и Ањута је невјероватно откриће. Огромно хвала!', 'This is a pearl of Montenegro in the literal sense of the word! I was looking for a podiatrist for a very long time and Anjuta is an incredible find. Thank you so much!', 'Это жемчужина Черногории в прямом смысле слова! Я очень долго искала специалиста-подолога и Анюта невероятная находка. Спасибо огромное!', 'Das ist eine Perle Montenegros im wahrsten Sinne des Wortes! Ich habe sehr lange nach einer Podologin gesucht und Anjuta ist ein unglaublicher Fund. Ganz herzlichen Dank!', 'Bu, kelimenin tam anlamıyla Karadağ\'ın incisi! Çok uzun süredir bir podolog arıyordum ve Anjuta inanılmaz bir keşif. Çok teşekkür ederim!',
    0, '2025-08-03 00:00:00'),

(@user_yulia_kovaleva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VMZUxzSUtRbnR6MERnEAE',
    5, 'ru', 'Супер салон и мастера. Качество, стерильность, обслуживание, все изумительно!',
    'Super salon i majstori. Kvalitet, sterilnost, usluga, sve je čudesno!', 'Супер салон и мајстори. Квалитет, стерилност, услуга, све је чудесно!', 'Super salon and super specialists. The quality, the sterility, the service, everything is amazing!', 'Супер салон и мастера. Качество, стерильность, обслуживание, все изумительно!', 'Super Salon und super Fachkräfte. Qualität, Sterilität, Service, alles ist hervorragend!', 'Süper salon ve süper uzmanlar. Kalite, sterilizasyon, hizmet, her şey muhteşem!',
    0, '2025-08-03 00:00:00'),

(@user_nadya_yuryeva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VQZjgyZFNfdTlIaHdBRRAB',
    5, 'ru', 'Была на приеме у доктора Анюты. Отличный врач и непривычно высокий уровень сервиса) Всё прошло идеально, от администратора до финала. Можно сразу на месте сдать посев. Врач очень подробно всё рассказала, объяснила. Рекомендую',
    'Bila sam na pregledu kod doktorke Anjute. Odličan ljekar i neobično visok nivo usluge) Sve je prošlo savršeno, od administratora do samog kraja. Kulturu (bris) možete dati odmah na mjestu. Doktorka je sve vrlo detaljno ispričala i objasnila. Preporučujem', 'Била сам на прегледу код докторке Ањуте. Одличан љекар и необично висок нивоу услуге) Све је прошло савршено, од администратора до самог краја. Културу (брис) можете дати одмах на мјесту. Докторка је све врло детаљно испричала и објаснила. Препоручујем', 'I had an appointment with Dr Anjuta. An excellent doctor and an unusually high level of service) Everything went perfectly, from the receptionist to the very end. You can have a culture test taken right there on the spot. The doctor explained everything in great detail. I recommend it', 'Была на приеме у доктора Анюты. Отличный врач и непривычно высокий уровень сервиса) Всё прошло идеально, от администратора до финала. Можно сразу на месте сдать посев. Врач очень подробно всё рассказала, объяснила. Рекомендую', 'Ich war zur Untersuchung bei Dr. Anjuta. Eine ausgezeichnete Ärztin und ein ungewöhnlich hohes Serviceniveau) Alles lief perfekt, vom Empfang bis zum Schluss. Eine Kultur kann man direkt vor Ort abgeben. Die Ärztin hat alles sehr ausführlich erzählt und erklärt. Ich empfehle es', 'Doktor Anjuta\'ya muayeneye gittim. Mükemmel bir doktor ve alışılmadık derecede yüksek bir hizmet seviyesi) Resepsiyondan sona kadar her şey kusursuz geçti. Kültür testini hemen orada verebiliyorsunuz. Doktor her şeyi çok ayrıntılı anlattı ve açıkladı. Tavsiye ederim',
    0, '2025-08-03 00:00:00'),

(@user_milena, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21ZelYyVjJPREJYVUVSNVRYVjVjekprUjJsRGFXYxAB',
    5, 'hr', 'Svaka čast! Preporučujem od srca!',
    'Svaka čast! Preporučujem od srca!', 'Свака част! Препоручујем од срца!', 'Well done! I recommend it wholeheartedly!', 'Респект! Рекомендую от всего сердца!', 'Alle Achtung! Ich empfehle es von Herzen!', 'Helal olsun! Gönülden tavsiye ederim!',
    0, '2025-08-03 00:00:00'),

(@user_sofya_ratsa, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VLR1kxS3ZSZzRPYXBRRRAB',
    5, 'ru', 'Однозначно лучший ногтевой сервис в Черногории',
    'Bez sumnje najbolji nail servis u Crnoj Gori', 'Без сумње најбољи nail сервис у Црној Гори', 'Hands down the best nail service in Montenegro', 'Однозначно лучший ногтевой сервис в Черногории', 'Ohne Zweifel der beste Nagelservice in Montenegro', 'Kesinlikle Karadağ\'daki en iyi tırnak hizmeti',
    0, '2025-08-03 00:00:00'),

(@user_aleksey_mikhailov, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VKdWxtZUxiMXJpaE5nEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_alyona_remer, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VKU0I4dEt5eFA2UUZ3EAE',
    5, 'ru', 'Супер, я довольна работой мастера Натали, предложили 🍸, сервис на высоком уровне💖🌱 …',
    'Super, zadovoljna sam radom majstorice Natali, ponudili su 🍸, usluga na visokom nivou💖🌱 …', 'Супер, задовољна сам радом мајсторице Натали, понудили су 🍸, услуга на високом нивоу💖🌱 …', 'Super, I\'m happy with the work of Natali, they offered me a 🍸, service at a high level💖🌱 …', 'Супер, я довольна работой мастера Натали, предложили 🍸, сервис на высоком уровне💖🌱 …', 'Super, ich bin mit der Arbeit von Natali zufrieden, man hat mir einen 🍸 angeboten, Service auf hohem Niveau💖🌱 …', 'Süper, uzman Natali\'nin işinden memnunum, bana 🍸 ikram ettiler, hizmet üst düzeyde💖🌱 …',
    0, '2025-08-03 00:00:00'),

(@user_daria_2, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VNLUM1c1RSbHRMVEdREAE',
    5, 'ru', 'Прекрасный сервис, вежливый персонал.',
    'Prekrasna usluga, ljubazno osoblje.', 'Прекрасна услуга, љубазно особље.', 'Wonderful service, polite staff.', 'Прекрасный сервис, вежливый персонал.', 'Wunderbarer Service, höfliches Personal.', 'Harika hizmet, nazik personel.',
    0, '2025-08-03 00:00:00'),

(@user_inna_konchits, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNqMlBiZkV3EAE',
    5, 'ru', 'Безупречно, с заботой и вниманием , как и всегда 💗 Каждое посещение - заряд прекрасного настроения и отличный результат ! Самые теплые рекомендации 💐🌸💖 …',
    'Besprekorno, sa brigom i pažnjom , kao i uvijek 💗 Svaka posjeta - punjenje prekrasnim raspoloženjem i odličan rezultat ! Najtoplije preporuke 💐🌸💖 …', 'Беспрекорно, са бригом и пажњом , као и увијек 💗 Свака посјета - пуњење прекрасним расположењем и одличан резултат ! Најтоплије препоруке 💐🌸💖 …', 'Flawless, with care and attention , as always 💗 Every visit is a boost of great mood and an excellent result ! Warmest recommendations 💐🌸💖 …', 'Безупречно, с заботой и вниманием , как и всегда 💗 Каждое посещение - заряд прекрасного настроения и отличный результат ! Самые теплые рекомендации 💐🌸💖 …', 'Einwandfrei, mit Sorgfalt und Aufmerksamkeit , wie immer 💗 Jeder Besuch ist eine Portion guter Laune und ein hervorragendes Ergebnis ! Wärmste Empfehlungen 💐🌸💖 …', 'Kusursuz, özenle ve ilgiyle , her zamanki gibi 💗 Her ziyaret harika bir moral aşısı ve mükemmel bir sonuç ! En sıcak tavsiyelerimle 💐🌸💖 …',
    0, '2025-08-03 00:00:00'),

(@user_svetlana_petric, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNsdmR1RVJnEAE',
    5, 'bs', 'Imala sam problem sa urastanjem nokta na palcu. Cekajuci termin kod kozmeticara po preporuci, trpila sam bolove skoro mjesec dana. Juce sam se sasvim slučajno, nasla u salonu iPODO na konsultaciji kod gospođe Anjute.
Prvi utisak o salonu i vise nego savršen od cistoce do prijatne i opustajuce atmosfere. Gospođa Anjuta me i to bez unaprijed ugovorenog termina, prima na konsultacije.Tiha i nenametljiva a nadasve stručna, gospođa Anjuta mi je uklonila urasle dijelove nokta, pazljivo i potpuno bezbolno. Dobila sam uputstva i lijek kako dalje da tretiram nokat, naravno uz kontrolu i njen nadzor.
Ja sam vjerovali ili ne, ovu uslugu dobila potpuno GRATIS!!!
Hvala puno gospodji Anjuti kao i kompletnom timu iPODO salona!',
    'Imala sam problem sa urastanjem nokta na palcu. Cekajuci termin kod kozmeticara po preporuci, trpila sam bolove skoro mjesec dana. Juce sam se sasvim slučajno, nasla u salonu iPODO na konsultaciji kod gospođe Anjute.
Prvi utisak o salonu i vise nego savršen od cistoce do prijatne i opustajuce atmosfere. Gospođa Anjuta me i to bez unaprijed ugovorenog termina, prima na konsultacije.Tiha i nenametljiva a nadasve stručna, gospođa Anjuta mi je uklonila urasle dijelove nokta, pazljivo i potpuno bezbolno. Dobila sam uputstva i lijek kako dalje da tretiram nokat, naravno uz kontrolu i njen nadzor.
Ja sam vjerovali ili ne, ovu uslugu dobila potpuno GRATIS!!!
Hvala puno gospodji Anjuti kao i kompletnom timu iPODO salona!', 'Имала сам проблем са урастањем нокта на палцу. Чекајући термин код козметичара по препоруци, трпјела сам болове скоро мјесец дана. Јуче сам се сасвим случајно нашла у салону iPODO на консултацији код госпође Ањуте.
Први утисак о салону и више него савршен, од чистоће до пријатне и опуштајуће атмосфере. Госпођа Ањута ме и то без унапријед уговореног термина прима на консултације. Тиха и ненаметљива, а надасве стручна, госпођа Ањута ми је уклонила урасле дјелове нокта, пажљиво и потпуно безболно. Добила сам упутства и лијек како даље да третирам нокат, наравно уз контролу и њен надзор.
Ја сам, вјеровали или не, ову услугу добила потпуно ГРАТИС!!!
Хвала пуно госпођи Ањути као и комплетном тиму iPODO салона!', 'I had a problem with an ingrown toenail on my big toe. While waiting for an appointment with a beautician someone had recommended, I put up with the pain for almost a month. Yesterday, completely by chance, I ended up at the iPODO salon for a consultation with Mrs Anjuta.
My first impression of the salon was more than perfect, from the cleanliness to the pleasant, relaxing atmosphere. Mrs Anjuta took me in for a consultation even without a pre-booked appointment. Quiet and unobtrusive, but above all expert, Mrs Anjuta removed the ingrown parts of the nail, carefully and completely painlessly. I got instructions and a medicine for how to treat the nail from now on, with follow-ups under her supervision, of course.
Believe it or not, I got this service completely FREE!!!
Many thanks to Mrs Anjuta and to the whole team at the iPODO salon!', 'У меня была проблема с врастанием ногтя на большом пальце. Пока ждала записи к косметологу по рекомендации, терпела боль почти месяц. Вчера совершенно случайно я оказалась в салоне iPODO на консультации у госпожи Анюты.
Первое впечатление от салона — более чем идеальное, от чистоты до приятной и расслабляющей атмосферы. Госпожа Анюта приняла меня на консультацию, причём без заранее назначенной записи. Тихая и деликатная, а прежде всего профессиональная, госпожа Анюта удалила вросшие части ногтя, аккуратно и совершенно безболезненно. Мне дали инструкции и лекарство, как дальше обрабатывать ноготь, разумеется, с контролем и под её наблюдением.
А я, верите или нет, получила эту услугу совершенно БЕСПЛАТНО!!!
Большое спасибо госпоже Анюте, а также всей команде салона iPODO!', 'Ich hatte ein Problem mit einem eingewachsenen Nagel am großen Zeh. Während ich auf einen Termin bei einer empfohlenen Kosmetikerin wartete, habe ich fast einen Monat lang Schmerzen erduldet. Gestern bin ich völlig zufällig im Salon iPODO zu einer Beratung bei Frau Anjuta gelandet.
Der erste Eindruck vom Salon war mehr als perfekt, von der Sauberkeit bis zur angenehmen und entspannenden Atmosphäre. Frau Anjuta hat mich zur Beratung empfangen, und das ohne vorher vereinbarten Termin. Still und unaufdringlich, aber vor allem fachkundig, hat Frau Anjuta die eingewachsenen Nagelteile entfernt, sorgfältig und völlig schmerzfrei. Ich habe Anweisungen und ein Medikament bekommen, wie ich den Nagel weiter behandeln soll, natürlich mit Kontrolle und unter ihrer Aufsicht.
Und ob Sie es glauben oder nicht, diese Leistung habe ich völlig GRATIS erhalten!!!
Vielen Dank an Frau Anjuta sowie an das komplette Team des iPODO-Salons!', 'Baş parmağımda batık tırnak problemim vardı. Tavsiye üzerine bir kozmetikçiden randevu beklerken neredeyse bir ay boyunca ağrıya dayandım. Dün tamamen tesadüfen iPODO salonunda Anjuta Hanım\'a konsültasyona gittim.
Salonla ilgili ilk izlenim mükemmelden de öteydi; temizlikten hoş ve dinlendirici ortama kadar. Anjuta Hanım, önceden alınmış bir randevu olmamasına rağmen beni konsültasyona kabul etti. Sakin ve mütevazı, ama her şeyden önce çok uzman olan Anjuta Hanım, tırnağın batık kısımlarını dikkatlice ve tamamen ağrısız bir şekilde çıkardı. Tırnağı bundan sonra nasıl tedavi edeceğime dair talimatlar ve ilaç aldım, elbette onun kontrolü ve gözetimi altında.
İster inanın ister inanmayın, bu hizmeti tamamen ÜCRETSİZ aldım!!!
Anjuta Hanım\'a ve iPODO salonunun tüm ekibine çok teşekkürler!',
    0, '2025-08-03 00:00:00'),

(@user_radmila_r, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUR6bjkyMll3EAE',
    5, 'hr', 'Natalia je najbolja! Hvala🙏❤️ …',
    'Natalia je najbolja! Hvala🙏❤️ …', 'Natalia је најбоља! Хвала🙏❤️ …', 'Natalia is the best! Thank you🙏❤️ …', 'Наталия лучшая! Спасибо🙏❤️ …', 'Natalia ist die Beste! Danke🙏❤️ …', 'Natalia en iyisi! Teşekkürler🙏❤️ …',
    0, '2025-08-03 00:00:00'),

(@user_sergii_orlov, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VPZmoyZGZncGFHVklnEAE',
    5, 'ru', 'Отличный салон, с очень хорошими специалистами.',
    'Odličan salon, sa vrlo dobrim stručnjacima.', 'Одличан салон, са врло добрим стручњацима.', 'An excellent salon, with very good specialists.', 'Отличный салон, с очень хорошими специалистами.', 'Ein ausgezeichneter Salon mit sehr guten Fachkräften.', 'Çok iyi uzmanlara sahip mükemmel bir salon.',
    0, '2025-08-03 00:00:00'),

(@user_marija_lekic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VKN1N0X2VYNllIMGtnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_anton_t, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VMVEVnLTI1Z29ENDZ3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_ulyana_kharitonchik, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTURvNC1UZ0dnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_anna_moiseeva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNEcnNXRlF3EAE',
    5, 'en', 'Very good and professional service! Highly recommend to everyone!',
    'Veoma dobra i profesionalna usluga! Toplo preporučujem svima!', 'Веома добра и професионална услуга! Топло препоручујем свима!', 'Very good and professional service! Highly recommend to everyone!', 'Очень хороший и профессиональный сервис! Всем очень рекомендую!', 'Sehr gute und professionelle Betreuung! Ich empfehle es allen wärmstens!', 'Çok iyi ve profesyonel hizmet! Herkese gönül rahatlığıyla tavsiye ederim!',
    0, '2025-08-03 00:00:00'),

(@user_ana_mievi, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTUNvcVBlMXRBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_marianna_marianna, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTUNvZ3BEeWZ3EAE',
    5, 'ru', 'Хочу выразить искреннюю благодарность замечательному ортопеду Алексею! Это не просто врач это настоящий профессионал с добрым сердцем и внимательным отношением к каждому пациенту. Алексей с первых минут расположил к себе, всё подробно объяснил, ответил на все вопросы и помог почувствовать себя в надёжных руках. Его чуткость, терпение и внимательность действительно впечатляют. Огромное спасибо за ваш труд и заботу 👌',
    'Želim da izrazim iskrenu zahvalnost divnom ortopedu Alekseju! Ovo nije samo ljekar, ovo je pravi profesionalac sa dobrim srcem i pažljivim odnosom prema svakom pacijentu. Aleksej je od prvih minuta stekao moje povjerenje, sve je detaljno objasnio, odgovorio na sva pitanja i pomogao mi da se osjećam u sigurnim rukama. Njegova osjetljivost, strpljenje i pažljivost zaista impresioniraju. Ogromno hvala za vaš rad i brigu 👌', 'Желим да изразим искрену захвалност дивном ортопеду Алексеју! Ово није само љекар, ово је прави професионалац са добрим срцем и пажљивим односом према сваком пацијенту. Алексеј је од првих минута стекао моје повјерење, све је детаљно објаснио, одговорио на сва питања и помогао ми да се осјећам у сигурним рукама. Његова осјетљивост, стрпљење и пажљивост заиста импресионирају. Огромно хвала за ваш рад и бригу 👌', 'I want to express my sincere gratitude to the wonderful orthopedist Aleksej! This is not just a doctor, this is a true professional with a kind heart and an attentive attitude towards every patient. From the very first minutes Aleksej won me over, explained everything in detail, answered all my questions and helped me feel that I was in safe hands. His sensitivity, patience and attentiveness are truly impressive. Huge thanks for your work and care 👌', 'Хочу выразить искреннюю благодарность замечательному ортопеду Алексею! Это не просто врач это настоящий профессионал с добрым сердцем и внимательным отношением к каждому пациенту. Алексей с первых минут расположил к себе, всё подробно объяснил, ответил на все вопросы и помог почувствовать себя в надёжных руках. Его чуткость, терпение и внимательность действительно впечатляют. Огромное спасибо за ваш труд и заботу 👌', 'Ich möchte dem wunderbaren Orthopäden Aleksej meinen aufrichtigen Dank aussprechen! Das ist nicht einfach nur ein Arzt, das ist ein echter Profi mit einem guten Herzen und einer aufmerksamen Haltung gegenüber jedem Patienten. Aleksej hat mich von den ersten Minuten an für sich gewonnen, hat alles ausführlich erklärt, alle Fragen beantwortet und mir das Gefühl gegeben, in guten Händen zu sein. Sein Einfühlungsvermögen, seine Geduld und seine Aufmerksamkeit sind wirklich beeindruckend. Riesigen Dank für Ihre Arbeit und Ihre Fürsorge 👌', 'Harika ortopedist Aleksej\'e içten şükranlarımı sunmak istiyorum! O sadece bir doktor değil, iyi kalpli ve her hastaya özenle yaklaşan gerçek bir profesyonel. Aleksej ilk dakikalardan itibaren güvenimi kazandı, her şeyi ayrıntılı olarak anlattı, bütün sorularımı yanıtladı ve kendimi emin ellerde hissetmemi sağladı. Duyarlılığı, sabrı ve ilgisi gerçekten etkileyici. Emeğiniz ve özeniniz için çok teşekkürler 👌',
    0, '2025-08-03 00:00:00'),

(@user_yana_sergeeva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTURJazluNmpnRRAB',
    5, 'ru', 'Посетила салон Ipodo и осталась в полном восторге! Очень понравился сервис — всё на высшем уровне. Мастер маникюра Наталья настоящий профессионал своего дела, атмосфера уютная и приятная. Обязательно вернусь снова!)',
    'Posjetila sam salon Ipodo i ostala potpuno očarana! Usluga mi se veoma dopala — sve je na najvišem nivou. Majstorica manikira Natalija je pravi profesionalac u svom poslu, atmosfera je prijatna i ugodna. Obavezno se vraćam ponovo!)', 'Посјетила сам салон Ipodo и остала потпуно очарана! Услуга ми се веома допала — све је на највишем нивоу. Мајсторица маникира Наталија је прави професионалац у свом послу, атмосфера је пријатна и угодна. Обавезно се враћам поново!)', 'I visited the Ipodo salon and was absolutely delighted! I really liked the service — everything is top level. The manicurist Natalija is a true professional at her craft, the atmosphere is cosy and pleasant. I will definitely come back again!)', 'Посетила салон Ipodo и осталась в полном восторге! Очень понравился сервис — всё на высшем уровне. Мастер маникюра Наталья настоящий профессионал своего дела, атмосфера уютная и приятная. Обязательно вернусь снова!)', 'Ich habe den Salon Ipodo besucht und war vollkommen begeistert! Der Service hat mir sehr gefallen — alles auf höchstem Niveau. Die Nagelspezialistin Natalija ist eine echte Profi in ihrem Fach, die Atmosphäre ist gemütlich und angenehm. Ich komme auf jeden Fall wieder!)', 'Ipodo salonuna gittim ve tamamen hayran kaldım! Hizmet çok hoşuma gitti — her şey en üst seviyede. Manikür uzmanı Natalija işinin gerçek bir profesyoneli, ortam sıcak ve keyifli. Kesinlikle yine geleceğim!)',
    0, '2025-08-03 00:00:00'),

(@user_svetlana_khrustalyova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUMzaGZmcHR3RRAB',
    5, 'ru', 'Это очень красивый и полезный для здоровья центр. Долго искала специалиста по ногтям, чтобы врач именно был. И наконец нашла. Это Анюта Еще что важно - чистота  в салоне потрясающая. Есть настоящая стерилизационная. Как в операционной девочки работают - в масках, перчатках, специальной одежде.  Так что риски получить какие-либо неприятности с маникюром или педикюром близки к нулю.',
    'Ovo je veoma lijep i za zdravlje koristan centar. Dugo sam tražila stručnjaka za nokte, i to da bude baš ljekar. I na kraju sam našla. To je Anjuta. Još nešto je važno - čistoća u salonu je zapanjujuća. Postoji prava sterilizaciona prostorija. Djevojke rade kao u operacionoj sali - sa maskama, rukavicama, u specijalnoj odjeći. Tako da su rizici da dobijete bilo kakve neprijatnosti sa manikirom ili pedikirom blizu nule.', 'Ово је веома лијеп и за здравље користан центар. Дуго сам тражила стручњака за нокте, и то да буде баш љекар. И на крају сам нашла. То је Ањута. Још нешто је важно - чистоћа у салону је запањујућа. Постоји права стерилизациона просторија. Дјевојке раде као у операционој сали - са маскама, рукавицама, у специјалној одјећи. Тако да су ризици да добијете било какве непријатности са маникиром или педикиром близу нуле.', 'This is a very beautiful centre that is also good for your health. For a long time I was looking for a nail specialist who would actually be a doctor. And I finally found one. It\'s Anjuta. Another important thing - the cleanliness in the salon is amazing. There is a real sterilisation room. The girls work like in an operating theatre - in masks, gloves, special clothing. So the risk of getting any trouble from a manicure or pedicure is close to zero.', 'Это очень красивый и полезный для здоровья центр. Долго искала специалиста по ногтям, чтобы врач именно был. И наконец нашла. Это Анюта Еще что важно - чистота  в салоне потрясающая. Есть настоящая стерилизационная. Как в операционной девочки работают - в масках, перчатках, специальной одежде.  Так что риски получить какие-либо неприятности с маникюром или педикюром близки к нулю.', 'Das ist ein sehr schönes und für die Gesundheit nützliches Zentrum. Ich habe lange nach einer Nagelspezialistin gesucht, die auch wirklich Ärztin ist. Und endlich habe ich sie gefunden. Das ist Anjuta. Und noch etwas Wichtiges - die Sauberkeit im Salon ist überwältigend. Es gibt einen echten Sterilisationsraum. Die Mädchen arbeiten wie in einem Operationssaal - mit Masken, Handschuhen, spezieller Kleidung. Das Risiko, sich bei einer Manikür oder Pediküre etwas einzufangen, ist also nahezu null.', 'Bu çok güzel ve sağlık için faydalı bir merkez. Uzun süre tırnak uzmanı aradım, hem de gerçekten doktor olsun diye. Ve sonunda buldum. O da Anjuta. Bir başka önemli şey - salondaki temizlik inanılmaz. Gerçek bir sterilizasyon odası var. Kızlar ameliyathanedeymiş gibi çalışıyor - maskeyle, eldivenle, özel kıyafetle. Yani manikür ya da pedikürden herhangi bir sorun yaşama riski neredeyse sıfır.',
    0, '2025-08-03 00:00:00'),

(@user_lina_temimi, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTUNJcjYtb0dnEAE',
    5, 'en', 'Really good !',
    'Zaista dobro !', 'Заиста добро !', 'Really good !', 'Очень хорошо !', 'Wirklich gut !', 'Gerçekten iyi !',
    0, '2025-08-03 00:00:00'),

(@user_relja_petric, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURMNV9iMHhnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_sergey_bolshakov, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTUNJa3N1ZzdBRRAB',
    5, 'ru', 'Очень предупредительный персонал',
    'Veoma predusretljivo osoblje', 'Веома предусретљиво особље', 'Very attentive staff', 'Очень предупредительный персонал', 'Sehr aufmerksames Personal', 'Çok ilgili personel',
    0, '2025-08-03 00:00:00'),

(@user_alena_mosina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTUNJa3RtTmV3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_ekaterina_triputen, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTUNJNHBfcVFnEAE',
    5, 'ru', 'Быстро разрешили мою проблему с травмами ногтей на ногах, с которой стеснялась обратиться! Жалею, что не пришла раньше. Не сидите и не ждите, как я, что все само рассосётся) Спасибо Анюте!',
    'Brzo su riješili moj problem sa povredama noktiju na nogama, zbog kojeg sam se stidjela da se obratim! Žalim što nisam došla ranije. Ne sjedite i ne čekajte, kao ja, da će sve samo proći) Hvala Anjuti!', 'Брзо су ријешили мој проблем са повредама ноктију на ногама, због којег сам се стидјела да се обратим! Жалим што нисам дошла раније. Не сједите и не чекајте, као ја, да ће све само проћи) Хвала Ањути!', 'They quickly solved my problem with injured toenails, which I was too embarrassed to ask about! I regret not coming sooner. Don\'t sit around waiting, like I did, for it all to go away on its own) Thank you, Anjuta!', 'Быстро разрешили мою проблему с травмами ногтей на ногах, с которой стеснялась обратиться! Жалею, что не пришла раньше. Не сидите и не ждите, как я, что все само рассосётся) Спасибо Анюте!', 'Sie haben mein Problem mit den verletzten Fußnägeln schnell gelöst, wegen dem ich mich geschämt habe, überhaupt hinzugehen! Ich bedauere, nicht früher gekommen zu sein. Sitzt nicht herum und wartet, wie ich, dass sich alles von selbst löst) Danke, Anjuta!', 'Utandığım için başvurmaya çekindiğim ayak tırnağı yaralanması problemimi hemen çözdüler! Daha önce gelmediğime pişmanım. Benim gibi oturup her şeyin kendi kendine geçmesini beklemeyin) Anjuta\'ya teşekkürler!',
    0, '2025-08-03 00:00:00'),

(@user_viktoriya_yavetskaya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTUNJNHNQSWRBEAE',
    5, 'ru', 'Анюта потрясающий врач! Очень приятное общение и подробно даны рекомендации',
    'Anjuta je fantastičan ljekar! Veoma prijatna komunikacija i detaljno date preporuke', 'Ањута је фантастичан љекар! Веома пријатна комуникација и детаљно дате препоруке', 'Anjuta is an amazing doctor! Very pleasant communication and detailed recommendations', 'Анюта потрясающий врач! Очень приятное общение и подробно даны рекомендации', 'Anjuta ist eine fantastische Ärztin! Sehr angenehme Kommunikation und ausführliche Empfehlungen', 'Anjuta muhteşem bir doktor! Çok keyifli bir iletişim ve ayrıntılı öneriler',
    0, '2025-08-03 00:00:00'),

(@user_andrey_slepukhin, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTUNJd3Q3VW9BRRAB',
    5, 'ru', 'Все было отлично. Очень внимательный врач. Открыл мне целую вселенную связанную с обувью, проблемами стопы и вообще ходьбой.',
    'Sve je bilo odlično. Veoma pažljiv ljekar. Otkrio mi je cijeli jedan svijet povezan sa obućom, problemima stopala i hodanjem uopšte.', 'Све је било одлично. Веома пажљив љекар. Открио ми је цијели један свијет повезан са обућом, проблемима стопала и ходањем уопште.', 'Everything was excellent. A very attentive doctor. He opened up a whole universe for me related to shoes, foot problems and walking in general.', 'Все было отлично. Очень внимательный врач. Открыл мне целую вселенную связанную с обувью, проблемами стопы и вообще ходьбой.', 'Alles war ausgezeichnet. Ein sehr aufmerksamer Arzt. Er hat mir eine ganze Welt eröffnet, die mit Schuhen, Fußproblemen und dem Gehen überhaupt zu tun hat.', 'Her şey harikaydı. Çok ilgili bir doktor. Bana ayakkabılar, ayak problemleri ve genel olarak yürümeyle ilgili koca bir evren açtı.',
    0, '2025-08-03 00:00:00'),

(@user_irina_gracheva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTUNJbExtOVRBEAE',
    5, 'ru', 'София прекрасный и внимательный мастер. Очень довольна результатом и проведенным в салоне времени!',
    'Sofija je divna i pažljiva majstorica. Veoma sam zadovoljna rezultatom i vremenom provedenim u salonu!', 'Софија је дивна и пажљива мајсторица. Веома сам задовољна резултатом и временом проведеним у салону!', 'Sofija is a wonderful and attentive specialist. I am very happy with the result and with the time spent in the salon!', 'София прекрасный и внимательный мастер. Очень довольна результатом и проведенным в салоне времени!', 'Sofija ist eine wunderbare und aufmerksame Fachkraft. Ich bin sehr zufrieden mit dem Ergebnis und mit der Zeit, die ich im Salon verbracht habe!', 'Sofija harika ve özenli bir uzman. Sonuçtan ve salonda geçirdiğim zamandan çok memnunum!',
    0, '2025-08-03 00:00:00'),

(@user_irinka_itcorp, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTUNJaU5USlZREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_krystina_borisenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTUR3bHQyUkVBEAE',
    5, 'ru', 'Хочу выразить огромную благодарность iPODO /centre of Podology & Safe manicure pedicure / за потрясающий сервис и профессионализм мастера Светланы! Аппаратный педикюр был выполнен безупречно – аккуратно, бережно и с вниманием к каждой детали. Ноги выглядят и чувствуют себя великолепно!
Отдельное спасибо за полезную консультацию по выбору правильной обуви и рекомендации по уходовым средствам, подходящим именно для меня. Было приятно не только получить качественную услугу, но и узнать много нового о здоровье и красоте стоп.
Обязательно вернусь и с радостью порекомендую этот центр своим друзьям!',
    'Želim da izrazim ogromnu zahvalnost salonu iPODO /centre of Podology & Safe manicure pedicure / za fantastičnu uslugu i profesionalnost majstorice Svetlane! Aparatni pedikir je izveden besprijekorno – pažljivo, nježno i sa pažnjom prema svakom detalju. Stopala izgledaju i osjećaju se sjajno!
Posebno hvala za korisnu konsultaciju o izboru prave obuće i za preporuke preparata za njegu koji odgovaraju baš meni. Bilo je prijatno ne samo dobiti kvalitetnu uslugu, nego i naučiti mnogo novog o zdravlju i ljepoti stopala.
Obavezno se vraćam i sa radošću ću preporučiti ovaj centar svojim prijateljima!', 'Желим да изразим огромну захвалност салону iPODO /centre of Podology & Safe manicure pedicure / за фантастичну услугу и професионалност мајсторице Светлане! Апаратни педикир је изведен беспријекорно – пажљиво, њежно и са пажњом према сваком детаљу. Стопала изгледају и осјећају се сјајно!
Посебно хвала за корисну консултацију о избору праве обуће и за препоруке препарата за његу који одговарају баш мени. Било је пријатно не само добити квалитетну услугу, него и научити много новог о здрављу и љепоти стопала.
Обавезно се враћам и са радошћу ћу препоручити овај центар својим пријатељима!', 'I want to express my enormous gratitude to iPODO /centre of Podology & Safe manicure pedicure / for the amazing service and the professionalism of the specialist Svetlana! The machine pedicure was done flawlessly – neatly, gently and with attention to every detail. My feet look and feel wonderful!
Special thanks for the useful consultation on choosing the right shoes and for the recommendations on care products that suit me specifically. It was a pleasure not only to receive a high-quality service, but also to learn a lot of new things about foot health and beauty.
I will definitely come back and will gladly recommend this centre to my friends!', 'Хочу выразить огромную благодарность iPODO /centre of Podology & Safe manicure pedicure / за потрясающий сервис и профессионализм мастера Светланы! Аппаратный педикюр был выполнен безупречно – аккуратно, бережно и с вниманием к каждой детали. Ноги выглядят и чувствуют себя великолепно!
Отдельное спасибо за полезную консультацию по выбору правильной обуви и рекомендации по уходовым средствам, подходящим именно для меня. Было приятно не только получить качественную услугу, но и узнать много нового о здоровье и красоте стоп.
Обязательно вернусь и с радостью порекомендую этот центр своим друзьям!', 'Ich möchte iPODO /centre of Podology & Safe manicure pedicure / meinen riesigen Dank aussprechen für den fantastischen Service und die Professionalität der Fachkraft Svetlana! Die Gerätepediküre wurde tadellos ausgeführt – sorgfältig, schonend und mit Aufmerksamkeit für jedes Detail. Meine Füße sehen wunderbar aus und fühlen sich auch so an!
Besonderen Dank für die nützliche Beratung zur Wahl des richtigen Schuhwerks und für die Empfehlungen zu Pflegeprodukten, die genau zu mir passen. Es war schön, nicht nur eine hochwertige Leistung zu erhalten, sondern auch viel Neues über die Gesundheit und Schönheit der Füße zu erfahren.
Ich komme auf jeden Fall wieder und empfehle dieses Zentrum meinen Freunden mit Freude weiter!', 'iPODO /centre of Podology & Safe manicure pedicure / ekibine muhteşem hizmeti ve uzman Svetlana\'nın profesyonelliği için sonsuz teşekkürlerimi sunmak istiyorum! Makineli pedikür kusursuz yapıldı – özenle, nazikçe ve her ayrıntıya dikkat edilerek. Ayaklarım hem harika görünüyor hem de harika hissediyor!
Doğru ayakkabı seçimi konusundaki faydalı danışmanlık ve tam bana uygun bakım ürünleri önerileri için ayrıca teşekkür ederim. Sadece kaliteli bir hizmet almak değil, ayak sağlığı ve güzelliği hakkında da çok yeni şey öğrenmek çok keyifliydi.
Kesinlikle yine geleceğim ve bu merkezi arkadaşlarıma memnuniyetle tavsiye edeceğim!',
    0, '2025-08-03 00:00:00'),

(@user_galina_dengina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTUR3d3B1b3h3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_g_khristoforova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTUR3b0oybzNBRRAB',
    5, 'ru', 'Всё очень понравилось!
Светлана, Камилла, большое спасибо!
Прекрасные девушки, очень милый и терпеливый ортопед. Рекомендую',
    'Sve mi se veoma dopalo!
Svetlana, Kamila, veliko hvala!
Divne djevojke, veoma drag i strpljiv ortoped. Preporučujem', 'Све ми се веома допало!
Светлана, Камила, велико хвала!
Дивне дјевојке, веома драг и стрпљив ортопед. Препоручујем', 'I liked everything a lot!
Svetlana, Kamila, thank you so much!
Wonderful girls, a very kind and patient orthopedist. Recommended', 'Всё очень понравилось!
Светлана, Камилла, большое спасибо!
Прекрасные девушки, очень милый и терпеливый ортопед. Рекомендую', 'Mir hat alles sehr gut gefallen!
Svetlana, Kamila, vielen Dank!
Wunderbare Mädchen, ein sehr netter und geduldiger Orthopäde. Ich empfehle es', 'Her şey çok hoşuma gitti!
Svetlana, Kamila, çok teşekkürler!
Harika kızlar, çok nazik ve sabırlı bir ortopedist. Tavsiye ederim',
    0, '2025-08-03 00:00:00'),

(@user_gavronina_evgeniya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTUN3djYtRWlnRRAB',
    5, 'ru', 'В таком месте чувствуешь себя принцессой☺️ Спасибо!',
    'Na takvom mjestu se osjećaš kao princeza☺️ Hvala!', 'На таквом мјесту се осјећаш као принцеза☺️ Хвала!', 'In a place like this you feel like a princess☺️ Thank you!', 'В таком месте чувствуешь себя принцессой☺️ Спасибо!', 'An so einem Ort fühlt man sich wie eine Prinzessin☺️ Danke!', 'Böyle bir yerde kendini prenses gibi hissediyorsun☺️ Teşekkürler!',
    0, '2025-08-03 00:00:00'),

(@user_lisa_voronkina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTUNRemUtMzBRRRAB',
    5, 'ru', 'Супер! Как обычно на высоте!',
    'Super! Kao i obično na visini!', 'Супер! Као и обично на висини!', 'Super! On top form as always!', 'Супер! Как обычно на высоте!', 'Super! Wie immer auf höchstem Niveau!', 'Süper! Her zamanki gibi mükemmel!',
    0, '2025-08-03 00:00:00'),

(@user_anna_vorotnikova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTURnOS1iYnZnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_aleksandr_akulshin, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTUNndi1HN0ZnEAE',
    5, 'en', 'best podolog in Montenegro',
    'najbolji podolog u Crnoj Gori', 'најбољи подолог у Црној Гори', 'best podolog in Montenegro', 'лучший подолог в Черногории', 'bester Podologe in Montenegro', 'Karadağ\'daki en iyi podolog',
    0, '2025-08-03 00:00:00'),

(@user_marko, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTUNnbGFlRlR3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_anastasia, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTUNncU83Q0lnEAE',
    5, 'ru', 'Любимое место с самым качественным сервисом и эстетикой на высшем уровне',
    'Najdraže mjesto sa najkvalitetnijom uslugom i estetikom na najvišem nivou', 'Најдраже мјесто са најквалитетнијом услугом и естетиком на највишем нивоу', 'My favourite place, with the highest-quality service and aesthetics at the top level', 'Любимое место с самым качественным сервисом и эстетикой на высшем уровне', 'Mein Lieblingsort mit dem besten Service und Ästhetik auf höchstem Niveau', 'En kaliteli hizmete ve en üst düzeyde estetiğe sahip favori yerim',
    0, '2025-08-03 00:00:00'),

(@user_svetlana_rutskaya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTURBek11VWhnRRAB',
    5, 'ru', 'Благодарю за чудесный педикюр! Самое лучшее место на свете!) Благодарю Анну за невероятное мастерство, внимание и заботу!
До скорой встречи!',
    'Hvala za čudesan pedikir! Najbolje mjesto na svijetu!) Hvala Ani za nevjerovatno majstorstvo, pažnju i brigu!
Do skorog viđenja!', 'Хвала за чудесан педикир! Најбоље мјесто на свијету!) Хвала Ани за невјероватно мајсторство, пажњу и бригу!
До скорог виђења!', 'Thank you for the wonderful pedicure! The best place in the world!) Thank you, Anna, for your incredible skill, attention and care!
See you soon!', 'Благодарю за чудесный педикюр! Самое лучшее место на свете!) Благодарю Анну за невероятное мастерство, внимание и заботу!
До скорой встречи!', 'Danke für die wunderbare Pediküre! Der beste Ort auf der Welt!) Danke, Anna, für dein unglaubliches Können, deine Aufmerksamkeit und deine Fürsorge!
Bis bald!', 'Harika pedikür için teşekkürler! Dünyadaki en iyi yer!) Anna\'ya inanılmaz ustalığı, ilgisi ve özeni için teşekkür ederim!
Yakında görüşmek üzere!',
    0, '2025-08-03 00:00:00'),

(@user_irina_lyubina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTURBbU92bS1BRRAB',
    5, 'ru', 'Анна оказала мне предварительную консультацию дистанционно, представьте насколько это сложно. Была внимательна и корректна, очень надеюсь на очную встречу',
    'Ana mi je pružila preliminarnu konsultaciju na daljinu, zamislite koliko je to komplikovano. Bila je pažljiva i korektna, veoma se nadam susretu uživo', 'Ана ми је пружила прелиминарну консултацију на даљину, замислите колико је то компликовано. Била је пажљива и коректна, веома се надам сусрету уживо', 'Anna gave me a preliminary consultation remotely — imagine how difficult that is. She was attentive and correct, I really hope to meet her in person', 'Анна оказала мне предварительную консультацию дистанционно, представьте насколько это сложно. Была внимательна и корректна, очень надеюсь на очную встречу', 'Anna hat mir eine Vorabberatung aus der Ferne gegeben, stellen Sie sich vor, wie schwierig das ist. Sie war aufmerksam und korrekt, ich hoffe sehr auf ein Treffen vor Ort', 'Anna bana uzaktan ön danışmanlık verdi, bunun ne kadar zor olduğunu düşünün. İlgili ve nazikti, yüz yüze görüşmeyi çok umuyorum',
    0, '2025-08-03 00:00:00'),

(@user_angelina_evdokimova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTURBOFBhS21RRRAB',
    5, 'ru', 'Добрый день!
Извините,  что отзыв с задержкой, никак не могла выкроить времечко.
Мне очень понравилась мастер София! Милая,  аккуратная и всё сделала замечательно!
Понравилось и то, что спрашивала,  уточняла, что и как делать. И видимо,  очень внимательная. Не задавала вопросов,  дала подремать на релаксе 🤩❤️👍🏻👍🏻👍🏻
Про Анечку... Тут вообще не вижу смысла писать. Это врач иэ будущего!
Профессионал  своего дела! Волшебница из другой галактики. К таким врачам хочется ходить со всеми болячками, ведь знаешь,  что она спасёт и поможет!
Благодарности нет предела!🥰🥰🥰
Спасибо Вам огромное!❤️',
    'Dobar dan!
Izvinite što je recenzija sa zakašnjenjem, nikako nisam mogla da nađem malo vremena.
Veoma mi se dopala majstorica Sofija! Draga, pedantna i sve je uradila divno!
Dopalo mi se i to što je pitala, provjeravala šta i kako da radi. I očigledno je veoma pažljiva. Nije me zasipala pitanjima, pustila me je da odrijemam i da se opustim 🤩❤️👍🏻👍🏻👍🏻
A o Anečki... Tu uopšte ne vidim smisla da pišem. To je ljekar iz budućnosti!
Pravi profesionalac! Čarobnica iz druge galaksije. Kod takvih ljekara želiš da ideš sa svim svojim boljkama, jer znaš da će ona spasiti i pomoći!
Zahvalnosti nema granica!🥰🥰🥰
Ogromno vam hvala!❤️', 'Добар дан!
Извините што је рецензија са закашњењем, никако нисам могла да нађем мало времена.
Веома ми се допала мајсторица Софија! Драга, педантна и све је урадила дивно!
Допало ми се и то што је питала, провјеравала шта и како да ради. И очигледно је веома пажљива. Није ме засипала питањима, пустила ме је да одријемам и да се опустим 🤩❤️👍🏻👍🏻👍🏻
А о Анечки... Ту уопште не видим смисла да пишем. То је љекар из будућности!
Прави професионалац! Чаробница из друге галаксије. Код таквих љекара желиш да идеш са свим својим бољкама, јер знаш да ће она спасити и помоћи!
Захвалности нема границе!🥰🥰🥰
Огромно вам хвала!❤️', 'Good afternoon!
Sorry that this review is late, I just couldn\'t find a spare moment.
I really liked the specialist Sofija! Sweet, meticulous, and she did everything wonderfully!
I also liked that she asked and double-checked what to do and how. And she\'s clearly very attentive. She didn\'t pester me with questions, she let me doze off and relax 🤩❤️👍🏻👍🏻👍🏻
As for Anechka... I don\'t even see the point of writing here. She\'s a doctor from the future!
A true professional! A sorceress from another galaxy. You want to go to doctors like her with all your ailments, because you know she\'ll rescue you and help!
My gratitude knows no limits!🥰🥰🥰
Thank you so very much!❤️', 'Добрый день!
Извините,  что отзыв с задержкой, никак не могла выкроить времечко.
Мне очень понравилась мастер София! Милая,  аккуратная и всё сделала замечательно!
Понравилось и то, что спрашивала,  уточняла, что и как делать. И видимо,  очень внимательная. Не задавала вопросов,  дала подремать на релаксе 🤩❤️👍🏻👍🏻👍🏻
Про Анечку... Тут вообще не вижу смысла писать. Это врач иэ будущего!
Профессионал  своего дела! Волшебница из другой галактики. К таким врачам хочется ходить со всеми болячками, ведь знаешь,  что она спасёт и поможет!
Благодарности нет предела!🥰🥰🥰
Спасибо Вам огромное!❤️', 'Guten Tag!
Entschuldigen Sie, dass die Bewertung verspätet kommt, ich habe einfach kein Zeitfenster gefunden.
Die Fachkraft Sofija hat mir sehr gefallen! Lieb, sorgfältig, und sie hat alles wunderbar gemacht!
Mir hat auch gefallen, dass sie gefragt und nachgeprüft hat, was und wie gemacht werden soll. Und offensichtlich ist sie sehr aufmerksam. Sie hat mich nicht mit Fragen bombardiert, sie hat mich einfach entspannt vor mich hin dösen lassen 🤩❤️👍🏻👍🏻👍🏻
Und über Anechka... Da sehe ich überhaupt keinen Sinn darin, etwas zu schreiben. Das ist eine Ärztin aus der Zukunft!
Eine echte Profi! Eine Zauberin aus einer anderen Galaxie. Zu solchen Ärztinnen möchte man mit all seinen Beschwerden gehen, denn man weiß, dass sie einen rettet und hilft!
Meine Dankbarkeit kennt keine Grenzen!🥰🥰🥰
Vielen, vielen Dank!❤️', 'İyi günler!
Yorumun gecikmesi için özür dilerim, bir türlü zaman ayıramadım.
Uzman Sofija\'yı çok sevdim! Tatlı, titiz ve her şeyi harika yaptı!
Neyi nasıl yapacağını sorup teyit etmesi de hoşuma gitti. Ve belli ki çok dikkatli. Beni sorulara boğmadı, rahatça kestirmeme izin verdi 🤩❤️👍🏻👍🏻👍🏻
Anechka\'ya gelince... Burada yazmanın anlamını hiç görmüyorum. O gelecekten gelmiş bir doktor!
İşinin gerçek profesyoneli! Başka bir galaksiden gelmiş bir büyücü. Böyle doktorlara bütün rahatsızlıklarınla gitmek istiyorsun, çünkü seni kurtaracağını ve yardım edeceğini biliyorsun!
Minnettarlığımın sınırı yok!🥰🥰🥰
Çok çok teşekkür ederim!❤️',
    0, '2025-08-03 00:00:00'),

(@user_valentina_zarechneva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTURBMEtPeUh3EAE',
    5, 'ru', 'Очень красивый и уютный салон, сервис - на высоте (всегда предложат на входе взять верхнюю одежду и помогут потом надеть ее, еще можно выпить кофе/чай или посидеть в массажном кресле, пока ждешь прием). Анюта - мастер своего дела, добрая и внимательная. Помогла с проблемной кожей без боли и шрамов.',
    'Vrlo lijep i prijatan salon, usluga - na najvišem nivou (na ulazu će vam uvijek ponuditi da preuzmu garderobu i poslije vam pomognu da je obučete, a možete i popiti kafu/čaj ili sjesti u masažnu fotelju dok čekate termin). Anjuta - majstor svog posla, ljubazna i pažljiva. Pomogla mi je s problematičnom kožom bez bola i ožiljaka.', 'Врло лијеп и пријатан салон, услуга - на највишем нивоу (на улазу ће вам увијек понудити да преузму гардеробу и послије вам помогну да је обучете, а можете и попити кафу/чај или сјести у масажну фотељу док чекате термин). Ањута - мајстор свог посла, љубазна и пажљива. Помогла ми је с проблематичном кожом без бола и ожиљака.', 'A very beautiful and cosy salon, the service is top-notch (they always offer to take your coat at the entrance and then help you put it back on, and you can have a coffee/tea or sit in a massage chair while you wait for your appointment). Anjuta is a true master of her craft, kind and attentive. She helped me with problem skin without any pain or scars.', 'Очень красивый и уютный салон, сервис - на высоте (всегда предложат на входе взять верхнюю одежду и помогут потом надеть ее, еще можно выпить кофе/чай или посидеть в массажном кресле, пока ждешь прием). Анюта - мастер своего дела, добрая и внимательная. Помогла с проблемной кожей без боли и шрамов.', 'Ein sehr schöner und gemütlicher Salon, der Service ist erste Klasse (am Eingang wird immer angeboten, die Jacke abzunehmen, und später hilft man einem beim Anziehen; außerdem kann man einen Kaffee/Tee trinken oder im Massagesessel sitzen, während man auf den Termin wartet). Anjuta ist eine Meisterin ihres Fachs, freundlich und aufmerksam. Sie hat mir bei problematischer Haut geholfen, ohne Schmerzen und ohne Narben.', 'Çok güzel ve huzurlu bir salon, hizmet mükemmel (girişte her zaman paltonuzu almayı teklif ediyorlar, sonra da giymenize yardım ediyorlar; ayrıca randevunuzu beklerken kahve/çay içebilir ya da masaj koltuğunda oturabilirsiniz). Anjuta işinin ustası, nazik ve ilgili. Sorunlu cildime ağrı ve iz kalmadan yardımcı oldu.',
    0, '2025-08-03 00:00:00'),

(@user_anna_viktorova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNybGMtM0VBEAE',
    5, 'ru', 'София очень профессиональный и внимательный мастер!',
    'Sofija je vrlo profesionalan i pažljiv majstor!', 'Софија је врло професионалан и пажљив мајстор!', 'Sofija is a very professional and attentive specialist!', 'София очень профессиональный и внимательный мастер!', 'Sofija ist eine sehr professionelle und aufmerksame Fachkraft!', 'Sofija çok profesyonel ve ilgili bir uzman!',
    0, '2025-08-03 00:00:00'),

(@user_nermin_mujovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTUNBdzRuQmZREAE',
    5, 'hr', 'Prezadovoljni smo uslugom sve pohvale za ovaj salon 😊 …',
    'Prezadovoljni smo uslugom sve pohvale za ovaj salon 😊 …', 'Презадовољни смо услугом све похвале за овај салон 😊 …', 'We\'re more than happy with the service, all praise to this salon 😊 …', 'Мы более чем довольны услугой, все похвалы этому салону 😊 …', 'Wir sind mehr als zufrieden mit dem Service, alles Lob für diesen Salon 😊 …', 'Hizmetten son derece memnun kaldık, bu salona tüm övgüler 😊 …',
    0, '2025-08-03 00:00:00'),

(@user_anna_tsvetkova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTUNBZzhUZXhRRRAB',
    5, 'ru', 'Эстетичная расслабляющая атмосфера в салоне. Педикюр выполняла Наталья, идеальная работа. Сервис на высшем уровне, от встречи и велком-меню до проводов с подарками (акция с купоном на шикарный массаж эндосферой). Хочется возвращаться',
    'Estetska, relaksirajuća atmosfera u salonu. Pedikir je radila Natalija, savršen posao. Usluga na najvišem nivou, od dočeka i welcome menija do ispraćaja s poklonima (akcija s kuponom za sjajnu endosfera masažu). Želi se vratiti', 'Естетска, релаксирајућа атмосфера у салону. Педикир је радила Наталија, савршен посао. Услуга на највишем нивоу, од дочека и welcome менија до испраћаја с поклонима (акција с купоном за сјајну endosfera масажу). Жели се вратити', 'An aesthetic, relaxing atmosphere in the salon. Natalija did the pedicure — perfect work. The service is top-notch, from the welcome and the welcome menu to being seen off with gifts (a promo with a coupon for a gorgeous endosphere massage). You want to come back', 'Эстетичная расслабляющая атмосфера в салоне. Педикюр выполняла Наталья, идеальная работа. Сервис на высшем уровне, от встречи и велком-меню до проводов с подарками (акция с купоном на шикарный массаж эндосферой). Хочется возвращаться', 'Eine ästhetische, entspannende Atmosphäre im Salon. Die Pediküre hat Natalija gemacht, perfekte Arbeit. Der Service ist erste Klasse, vom Empfang und Welcome-Menü bis zur Verabschiedung mit Geschenken (eine Aktion mit Gutschein für eine herrliche Endosphere-Massage). Man möchte wiederkommen', 'Salonda estetik, dinlendirici bir atmosfer var. Pedikürü Natalija yaptı, kusursuz bir iş. Karşılamadan ve welcome menüsünden hediyelerle uğurlamaya kadar hizmet en üst düzeyde (harika bir endosphere masajı kuponuyla kampanya). İnsan tekrar gelmek istiyor',
    0, '2025-08-03 00:00:00'),

(@user_olga_2, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTUNBc1lTaTN3RRAB',
    5, 'ru', 'Осталась очень довольна процедурой и сервисом все на высоте🫶',
    'Ostala sam vrlo zadovoljna tretmanom i uslugom, sve je na najvišem nivou🫶', 'Остала сам врло задовољна третманом и услугом, све је на највишем нивоу🫶', 'I was very pleased with the treatment and the service, everything is top-notch🫶', 'Осталась очень довольна процедурой и сервисом все на высоте🫶', 'Ich war mit der Behandlung und dem Service sehr zufrieden, alles erste Klasse🫶', 'İşlemden ve hizmetten çok memnun kaldım, her şey mükemmel🫶',
    0, '2025-08-03 00:00:00'),

(@user_katerina_velikaya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTUNBdE1ERUR3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_anastasiya_skuratova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnTUNBbE55VkNnEAE',
    5, 'ru', 'Очень стильное и красивое место. Мастер сделал аккуратный маникюр, безболезненно) для меня это очень важно.  Так как часто случалось, что были повреждения. Так как у меня чувствительная кожа. Спасибо).',
    'Vrlo stilsko i lijepo mjesto. Majstor je uradio pedantan manikir, bezbolno) za mene je to vrlo važno. Jer često se dešavalo da bude povreda. Zato što imam osjetljivu kožu. Hvala).', 'Врло стилско и лијепо мјесто. Мајстор је урадио педантан маникир, безболно) за мене је то врло важно. Јер често се дешавало да буде повреда. Зато што имам осјетљиву кожу. Хвала).', 'A very stylish and beautiful place. The specialist did a neat manicure, painlessly) that\'s very important to me. Because it often happened that I got injuries. Since I have sensitive skin. Thank you).', 'Очень стильное и красивое место. Мастер сделал аккуратный маникюр, безболезненно) для меня это очень важно.  Так как часто случалось, что были повреждения. Так как у меня чувствительная кожа. Спасибо).', 'Ein sehr stilvoller und schöner Ort. Die Fachkraft hat eine sorgfältige Maniküre gemacht, schmerzfrei) das ist für mich sehr wichtig. Denn es kam oft vor, dass es Verletzungen gab. Weil ich empfindliche Haut habe. Danke).', 'Çok şık ve güzel bir yer. Uzman özenli bir manikür yaptı, hiç acıtmadan) bu benim için çok önemli. Çünkü sık sık yaralanmalar oluyordu. Cildim hassas olduğu için. Teşekkürler).',
    0, '2025-08-03 00:00:00'),

(@user_fulya_melisa, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNmdHBEU1Z3EAE',
    5, 'en', 'Really great service! Will definitely come back thanks',
    'Zaista sjajna usluga! Definitivno ću se vratiti, hvala', 'Заиста сјајна услуга! Дефинитивно ћу се вратити, хвала', 'Really great service! Will definitely come back thanks', 'Правда отличный сервис! Обязательно вернусь, спасибо', 'Wirklich toller Service! Ich komme auf jeden Fall wieder, danke', 'Gerçekten harika bir hizmet! Kesinlikle tekrar geleceğim, teşekkürler',
    0, '2025-08-03 00:00:00'),

(@user_semyon_tatarinov, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNma3RQS1FBEAE',
    5, 'ru', 'Был на приёме у Алексея. Потрясающий мастер: все рассказал, показал и сделал персональные ортопедические стельки. Только что дошел домой и… как же это приятно ощущать, что обувь комфортна! Спасибо Алексею и всей команде iPODO!',
    'Bio sam na tretmanu kod Alekseja. Fantastičan majstor: sve je objasnio, pokazao i napravio personalizovane ortopedske uloške. Upravo sam stigao kući i… kako je prijatno osjećati da je obuća udobna! Hvala Alekseju i cijelom timu iPODO!', 'Био сам на третману код Алексеја. Фантастичан мајстор: све је објаснио, показао и направио персонализоване ортопедске улошке. Управо сам стигао кући и… како је пријатно осјећати да је обућа удобна! Хвала Алексеју и цијелом тиму iPODO!', 'I had an appointment with Aleksej. An amazing specialist: he explained everything, showed me everything and made custom orthopaedic insoles. I\'ve just walked home and… what a pleasure it is to feel that your shoes are comfortable! Thanks to Aleksej and the whole iPODO team!', 'Был на приёме у Алексея. Потрясающий мастер: все рассказал, показал и сделал персональные ортопедические стельки. Только что дошел домой и… как же это приятно ощущать, что обувь комфортна! Спасибо Алексею и всей команде iPODO!', 'Ich hatte einen Termin bei Aleksej. Ein fantastischer Fachmann: Er hat alles erklärt, alles gezeigt und individuelle orthopädische Einlagen angefertigt. Ich bin gerade nach Hause gelaufen und… wie angenehm ist es zu spüren, dass die Schuhe bequem sind! Danke an Aleksej und das gesamte iPODO-Team!', 'Aleksej\'e randevuya gittim. Muhteşem bir uzman: her şeyi anlattı, gösterdi ve kişiye özel ortopedik tabanlık yaptı. Az önce yürüyerek eve geldim ve… ayakkabının rahat olduğunu hissetmek ne kadar güzel! Aleksej\'e ve tüm iPODO ekibine teşekkürler!',
    0, '2025-08-03 00:00:00'),

(@user_cosmonauts_day, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNma3RPY0dnEAE',
    5, 'en', 'Very nice place with stellar service! Recommend',
    'Vrlo lijepo mjesto sa fenomenalnom uslugom! Preporučujem', 'Врло лијепо мјесто са феноменалном услугом! Препоручујем', 'Very nice place with stellar service! Recommend', 'Очень приятное место с потрясающим сервисом! Рекомендую', 'Ein sehr schöner Ort mit hervorragendem Service! Empfehlenswert', 'Muhteşem hizmet sunan çok güzel bir yer! Tavsiye ederim',
    0, '2025-08-03 00:00:00'),

(@user_elena_l, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUR2LTdmbVRnEAE',
    5, 'ru', 'Быстрая запись, отличная локация и классный сервис! Понравилась мастер, услуга и подарки!',
    'Brzo zakazivanje, odlična lokacija i super usluga! Svidjela mi se majstorica, tretman i pokloni!', 'Брзо заказивање, одлична локација и супер услуга! Свидјела ми се мајсторица, третман и поклони!', 'Quick booking, great location and awesome service! I loved the specialist, the treatment and the gifts!', 'Быстрая запись, отличная локация и классный сервис! Понравилась мастер, услуга и подарки!', 'Schnelle Terminvergabe, super Lage und klasse Service! Die Fachkraft, die Behandlung und die Geschenke haben mir gefallen!', 'Hızlı randevu, harika bir konum ve süper hizmet! Uzmanı, uygulamayı ve hediyeleri çok sevdim!',
    0, '2025-08-03 00:00:00'),

(@user_774johan, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUR2a19YSzh3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_marijola_dimitrijevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNscmV5R0x3EAE',
    5, 'bs', 'Veoma stručni i profesionalni!!!
Usluga na zavidnom nivou. Svaka čest!!!♥️',
    'Veoma stručni i profesionalni!!!
Usluga na zavidnom nivou. Svaka čest!!!♥️', 'Веома стручни и професионални!!!
Услуга на завидном нивоу. Свака част!!!♥️', 'Extremely skilled and professional!!!
The service is at an enviable level. Well done!!!♥️', 'Очень грамотные и профессиональные!!!
Сервис на завидном уровне. Молодцы!!!♥️', 'Sehr fachkundig und professionell!!!
Der Service ist auf beneidenswertem Niveau. Alle Achtung!!!♥️', 'Son derece bilgili ve profesyonel!!!
Hizmet kıskandıracak seviyede. Helal olsun!!!♥️',
    0, '2025-08-03 00:00:00'),

(@user_julia_fridman, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUN2N1lQU1pnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_ivan_unjerga, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURQcjcyZHRRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_lana_ljubanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSURQckpyLWJREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_elena_rozenbaum, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNQN3Rib1lBEAE',
    5, 'en', 'Outstanding service, very courteous and attentive! Podologist Anyuta is higly experienced professional with gentle hands and strong knoweledge who helped me with my terrebly damaged nails. She is not just an expert in the treatment of any nails and foot conditions, but also a very pleasant, friendly and kind person. Strongly recommended!!!',
    'Izuzetna usluga, veoma ljubazni i pažljivi! Podolog Anyuta je vrlo iskusan profesionalac s nježnim rukama i velikim znanjem, koja mi je pomogla s mojim strašno oštećenim noktima. Ona nije samo ekspert za liječenje svih stanja noktiju i stopala, već i vrlo prijatna, druželjubiva i dobra osoba. Toplo preporučujem!!!', 'Изузетна услуга, веома љубазни и пажљиви! Подолог Анјута је врло искусан професионалац с њежним рукама и великим знањем, која ми је помогла с мојим страшно оштећеним ноктима. Она није само експерт за љечење свих стања ноктију и стопала, већ и врло пријатна, дружељубива и добра особа. Топло препоручујем!!!', 'Outstanding service, very courteous and attentive! Podologist Anyuta is higly experienced professional with gentle hands and strong knoweledge who helped me with my terrebly damaged nails. She is not just an expert in the treatment of any nails and foot conditions, but also a very pleasant, friendly and kind person. Strongly recommended!!!', 'Выдающийся сервис, очень вежливые и внимательные! Подолог Анюта — очень опытный профессионал с нежными руками и сильными знаниями, она помогла мне с моими ужасно повреждёнными ногтями. Она не просто эксперт в лечении любых проблем с ногтями и стопами, но и очень приятный, дружелюбный и добрый человек. Настоятельно рекомендую!!!', 'Herausragender Service, sehr höflich und aufmerksam! Die Podologin Anyuta ist eine sehr erfahrene Fachfrau mit sanften Händen und großem Wissen, die mir bei meinen furchtbar geschädigten Nägeln geholfen hat. Sie ist nicht nur Expertin für die Behandlung aller Nagel- und Fußprobleme, sondern auch ein sehr angenehmer, freundlicher und herzlicher Mensch. Sehr empfehlenswert!!!', 'Olağanüstü bir hizmet, çok nazik ve ilgili! Podolog Anyuta çok deneyimli bir profesyonel; hem elleri çok yumuşak hem de bilgisi çok güçlü, berbat durumda olan tırnaklarımda bana yardımcı oldu. Sadece her türlü tırnak ve ayak probleminin tedavisinde uzman değil, aynı zamanda çok hoş, samimi ve iyi kalpli bir insan. Kesinlikle tavsiye ederim!!!',
    0, '2025-08-03 00:00:00'),

(@user_nelya_kosenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUQzXzYtbDJnRRAB',
    5, 'ru', 'Думаю это лучший салон маникюра и педикюра в Черногории. Интерьер, персонал, а главное качество услуг - на высоте! Да, дороговато (я за маникюр и педикюр без покрытия, но со снятием старого лака заплатила 120 евро), но это того стоит. Жаль, что находится в Будве, приходится ездить из Тивата.
Процветания и побольше довольных клиентов!',
    'Mislim da je ovo najbolji salon za manikir i pedikir u Crnoj Gori. Interijer, osoblje, a najvažnije kvalitet usluga - na najvišem nivou! Da, malo je skuplje (za manikir i pedikir bez lakiranja, ali s uklanjanjem starog laka platila sam 120 eura), ali vrijedi toga. Šteta što je u Budvi, moram putovati iz Tivta.
Želim vam napredak i još više zadovoljnih klijenata!', 'Мислим да је ово најбољи салон за маникир и педикир у Црној Гори. Интеријер, особље, а најважније квалитет услуга - на највишем нивоу! Да, мало је скупље (за маникир и педикир без лакирања, али с уклањањем старог лака платила сам 120 еура), али вриједи тога. Штета што је у Будви, морам путовати из Тивта.
Желим вам напредак и још више задовољних клијената!', 'I think this is the best manicure and pedicure salon in Montenegro. The interior, the staff, and most importantly the quality of the services — all top-notch! Yes, it\'s a bit pricey (I paid 120 euros for a manicure and pedicure without polish, but with the old polish removed), but it\'s worth it. It\'s a shame it\'s in Budva, I have to travel from Tivat.
Wishing you prosperity and many more happy clients!', 'Думаю это лучший салон маникюра и педикюра в Черногории. Интерьер, персонал, а главное качество услуг - на высоте! Да, дороговато (я за маникюр и педикюр без покрытия, но со снятием старого лака заплатила 120 евро), но это того стоит. Жаль, что находится в Будве, приходится ездить из Тивата.
Процветания и побольше довольных клиентов!', 'Ich denke, das ist der beste Maniküre- und Pediküre-Salon in Montenegro. Das Interieur, das Personal und vor allem die Qualität der Leistungen — alles erste Klasse! Ja, es ist etwas teuer (ich habe für Maniküre und Pediküre ohne Lack, aber mit Entfernung des alten Lacks 120 Euro bezahlt), aber es ist es wert. Schade, dass es in Budva liegt, ich muss aus Tivat anreisen.
Ich wünsche Ihnen viel Erfolg und noch mehr zufriedene Kunden!', 'Bence Karadağ\'ın en iyi manikür ve pedikür salonu burası. İç mekân, personel ve en önemlisi hizmet kalitesi — hepsi mükemmel! Evet, biraz pahalı (cila olmadan, ama eski cilanın çıkarılmasıyla birlikte manikür ve pedikür için 120 euro ödedim), ama buna değer. Budva\'da olması üzücü, Tivat\'tan gelmek zorunda kalıyorum.
Size bol kazanç ve daha çok memnun müşteri diliyorum!',
    0, '2025-08-03 00:00:00'),

(@user_ekaterina_reznichenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUQzM3VMN2x3RRAB',
    5, 'ru', 'Качественный маникюр 💅 покрытие ношу около 4-х недель - ни единого скола, хоть и форма ногтей квадрат.
Спасибо студии за комфорт и высокое качество услуг🙌',
    'Kvalitetan manikir 💅 lak nosim oko 4 nedjelje - ni jedno okrzano mjesto, iako mi je oblik noktiju kvadratni.
Hvala studiju na komforu i visokom kvalitetu usluga🙌', 'Квалитетан маникир 💅 лак носим око 4 недјеље - ни једно окрзано мјесто, иако ми је облик ноктију квадратни.
Хвала студију на комфору и високом квалитету услуга🙌', 'Quality manicure 💅 the polish has lasted about 4 weeks — not a single chip, even though my nails are squared off.
Thank you to the studio for the comfort and the high quality of the services🙌', 'Качественный маникюр 💅 покрытие ношу около 4-х недель - ни единого скола, хоть и форма ногтей квадрат.
Спасибо студии за комфорт и высокое качество услуг🙌', 'Hochwertige Maniküre 💅 den Lack trage ich schon etwa 4 Wochen — nicht eine einzige abgeplatzte Stelle, obwohl meine Nagelform eckig ist.
Danke an das Studio für den Komfort und die hohe Qualität der Leistungen🙌', 'Kaliteli manikür 💅 cilayı yaklaşık 4 haftadır taşıyorum — tırnak şeklim kare olmasına rağmen tek bir kırık bile yok.
Konfor ve yüksek hizmet kalitesi için stüdyoya teşekkürler🙌',
    0, '2025-08-03 00:00:00'),

(@user_aleksa_ljubanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUMzOGVpbWRBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_angelina_anisimova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUMzc2JTTThBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_darya_dievskaya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURqM01XbDNRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_anton, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURuMjQyTzNnRRAB',
    5, 'ru', 'Хочу выразить огромную благодарность подологу Анне! После похода в горы в неподходящей обуви у меня были серьёзные проблемы с ногтями. Анна провела полное восстановление, и ногти теперь выглядят даже лучше, чем до похода! Очень профессиональный и внимательный подход, рекомендую всем, кто ищет квалифицированного подолога. Уникальный сервис для Черногории',
    'Želim izraziti ogromnu zahvalnost podologu Anni! Nakon planinarenja u neodgovarajućoj obući imao sam ozbiljne probleme s noktima. Anna je izvela potpunu obnovu i nokti sada izgledaju čak i bolje nego prije pohoda! Vrlo profesionalan i pažljiv pristup, preporučujem svima koji traže kvalifikovanog podologa. Jedinstvena usluga za Crnu Goru', 'Желим изразити огромну захвалност подологу Ани! Након планинарења у неодговарајућој обући имао сам озбиљне проблеме с ноктима. Ана је извела потпуну обнову и нокти сада изгледају чак и боље него прије похода! Врло професионалан и пажљив приступ, препоручујем свима који траже квалификованог подолога. Јединствена услуга за Црну Гору', 'I want to express my huge gratitude to the podiatrist Anna! After a mountain hike in unsuitable shoes I had serious problems with my nails. Anna carried out a full restoration, and now my nails look even better than before the hike! A very professional and attentive approach, I recommend her to anyone looking for a qualified podiatrist. A unique service for Montenegro', 'Хочу выразить огромную благодарность подологу Анне! После похода в горы в неподходящей обуви у меня были серьёзные проблемы с ногтями. Анна провела полное восстановление, и ногти теперь выглядят даже лучше, чем до похода! Очень профессиональный и внимательный подход, рекомендую всем, кто ищет квалифицированного подолога. Уникальный сервис для Черногории', 'Ich möchte der Podologin Anna meinen riesigen Dank aussprechen! Nach einer Bergwanderung in ungeeigneten Schuhen hatte ich ernste Probleme mit meinen Nägeln. Anna hat eine vollständige Wiederherstellung durchgeführt, und die Nägel sehen jetzt sogar besser aus als vor der Wanderung! Ein sehr professioneller und aufmerksamer Umgang, ich empfehle sie allen, die eine qualifizierte Podologin suchen. Ein einzigartiges Angebot für Montenegro', 'Podolog Anna\'ya sonsuz teşekkürlerimi sunmak istiyorum! Uygun olmayan ayakkabılarla dağa tırmandıktan sonra tırnaklarımda ciddi sorunlar oluştu. Anna tam bir onarım yaptı ve tırnaklarım şimdi yürüyüşten önceki halinden bile daha iyi görünüyor! Çok profesyonel ve ilgili bir yaklaşım, nitelikli bir podolog arayan herkese tavsiye ederim. Karadağ için eşsiz bir hizmet',
    0, '2025-08-03 00:00:00'),

(@user_tetiana_rozghon, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNINmMtdHRBRRAB',
    5, 'ru', 'Спасибо большое Анюте за ее профессиональный подход и сервис салона на высоте , очень довольна , результаты радуют 🥰',
    'Veliko hvala Anjuti na njenom profesionalnom pristupu, a usluga salona je na najvišem nivou , vrlo sam zadovoljna , rezultati me raduju 🥰', 'Велико хвала Ањути на њеном професионалном приступу, а услуга салона је на највишем нивоу , врло сам задовољна , резултати ме радују 🥰', 'Many thanks to Anjuta for her professional approach, and the salon\'s service is top-notch , I\'m very pleased , the results make me happy 🥰', 'Спасибо большое Анюте за ее профессиональный подход и сервис салона на высоте , очень довольна , результаты радуют 🥰', 'Vielen Dank an Anjuta für ihren professionellen Umgang, und der Service des Salons ist erste Klasse , ich bin sehr zufrieden , die Ergebnisse freuen mich 🥰', 'Profesyonel yaklaşımı için Anjuta\'ya çok teşekkürler, salonun hizmeti de mükemmel , çok memnunum , sonuçlar beni sevindiriyor 🥰',
    0, '2025-08-03 00:00:00'),

(@user_natasha, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNuM3ZxQkFnEAE',
    5, 'ru', 'Замечательные специалисты знающие свое дело. Очень довольна каждым визитом. Чистота, гостеприимство, доброжелательность и профессионализм. Помогли с очень проблемными ногтями. Рекомендую.👍 …',
    'Divni stručnjaci koji znaju svoj posao. Vrlo sam zadovoljna svakim dolaskom. Čistoća, gostoprimstvo, ljubaznost i profesionalizam. Pomogli su mi s vrlo problematičnim noktima. Preporučujem.👍 …', 'Дивни стручњаци који знају свој посао. Врло сам задовољна сваким доласком. Чистоћа, гостопримство, љубазност и професионализам. Помогли су ми с врло проблематичним ноктима. Препоручујем.👍 …', 'Wonderful specialists who know their job. I\'m very pleased with every visit. Cleanliness, hospitality, friendliness and professionalism. They helped me with very problematic nails. I recommend them.👍 …', 'Замечательные специалисты знающие свое дело. Очень довольна каждым визитом. Чистота, гостеприимство, доброжелательность и профессионализм. Помогли с очень проблемными ногтями. Рекомендую.👍 …', 'Wunderbare Fachkräfte, die ihr Handwerk beherrschen. Ich bin mit jedem Besuch sehr zufrieden. Sauberkeit, Gastfreundschaft, Freundlichkeit und Professionalität. Sie haben mir bei sehr problematischen Nägeln geholfen. Ich empfehle sie.👍 …', 'İşini bilen harika uzmanlar. Her gelişimden çok memnun kaldım. Temizlik, misafirperverlik, güler yüz ve profesyonellik. Çok sorunlu tırnaklarımda bana yardımcı oldular. Tavsiye ederim.👍 …',
    0, '2025-08-03 00:00:00'),

(@user_alexey_shavrin, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNubHZ2RzdnRRAB',
    5, 'ru', 'Все было отлично!',
    'Sve je bilo odlično!', 'Све је било одлично!', 'Everything was great!', 'Все было отлично!', 'Alles war ausgezeichnet!', 'Her şey harikaydı!',
    0, '2025-08-03 00:00:00'),

(@user_veronika_zagorcha, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNud0l1N1ZREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_yana_bulanchuk, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURINmNEbjJ3RRAB',
    5, 'ru', 'Маникюр и педикюр с покрытием гель лаком: Очень аккуратно, быстро, качественно и красиво)) Профессионалы своего дела.',
    'Manikir i pedikir s gel lakom: Vrlo pedantno, brzo, kvalitetno i lijepo)) Profesionalci u svom poslu.', 'Маникир и педикир с гел лаком: Врло педантно, брзо, квалитетно и лијепо)) Професионалци у свом послу.', 'Manicure and pedicure with gel polish: Very neat, fast, high quality and beautiful)) True professionals at what they do.', 'Маникюр и педикюр с покрытием гель лаком: Очень аккуратно, быстро, качественно и красиво)) Профессионалы своего дела.', 'Maniküre und Pediküre mit Gellack: Sehr sorgfältig, schnell, hochwertig und schön)) Profis in ihrem Fach.', 'Jel cilalı manikür ve pedikür: Çok özenli, hızlı, kaliteli ve güzel)) İşinin gerçek profesyonelleri.',
    0, '2025-08-03 00:00:00'),

(@user_lyudmila_povolotskaya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNINnRiSjdnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-03 00:00:00'),

(@user_margarita_riaboshapko, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ3M2V1VlNREAE',
    5, 'ru', 'Благодарю за прекрасный сервис и маникюр🤍 …',
    'Hvala vam na prekrasnoj usluzi i manikiru🤍 …', 'Хвала вам на предивној услузи и маникиру🤍 …', 'Thank you for the wonderful service and the manicure🤍 …', 'Благодарю за прекрасный сервис и маникюр🤍 …', 'Danke für den wunderbaren Service und die Maniküre🤍 …', 'Harika hizmet ve manikür için teşekkür ederim🤍 …',
    0, '2025-08-03 00:00:00'),

(@user_arina_luneva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ3eFpYOF93RRAB',
    5, 'ru', 'Прекрасное место и суперский персонал❤️',
    'Prekrasno mjesto i super osoblje❤️', 'Предивно мјесто и супер особље❤️', 'A wonderful place and super staff❤️', 'Прекрасное место и суперский персонал❤️', 'Ein wunderschöner Ort und ein super Team❤️', 'Harika bir yer ve süper bir ekip❤️',
    0, '2025-08-03 00:00:00'),

(@user_mariya_berdnikova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURieTRhenR3RRAB',
    5, 'ru', 'Качество просто на высоте. Очень чисто. Все инструменты в отдельных упаковках для каждого клиента. Большой выбор цветов гель-лаков. Делают, как аппаратный , так и обрезной маникюр. Есть услуги подолога, дерматолога и ортопеда. Ортопед при нас сделал стельки сыну. Лучший салон в Черногории. Хорошее соотношение цена/качество.',
    'Kvalitet je jednostavno na najvišem nivou. Veoma čisto. Svi instrumenti su u pojedinačnim pakovanjima za svakog klijenta. Veliki izbor boja gel-lakova. Rade i aparaturni i klasični rezni manikir. Postoje usluge podologa, dermatologa i ortopeda. Ortoped je pred nama napravio uloške za sina. Najbolji salon u Crnoj Gori. Dobar odnos cijene i kvaliteta.', 'Квалитет је просто на највишем нивоу. Веома чисто. Сви инструменти су у појединачним паковањима за сваког клијента. Велики избор боја гел-лакова. Раде и апаратурни и класични резни маникир. Постоје услуге подолога, дерматолога и ортопеда. Ортопед је пред нама направио улошке за сина. Најбољи салон у Црној Гори. Добар однос цијене и квалитета.', 'The quality is simply top notch. Very clean. All the instruments come in individual packaging for each client. A big choice of gel polish colours. They do both machine and cuticle-cutting manicures. There are podiatrist, dermatologist and orthopaedist services. The orthopaedist made insoles for my son right in front of us. The best salon in Montenegro. Good value for money.', 'Качество просто на высоте. Очень чисто. Все инструменты в отдельных упаковках для каждого клиента. Большой выбор цветов гель-лаков. Делают, как аппаратный , так и обрезной маникюр. Есть услуги подолога, дерматолога и ортопеда. Ортопед при нас сделал стельки сыну. Лучший салон в Черногории. Хорошее соотношение цена/качество.', 'Die Qualität ist einfach top. Sehr sauber. Alle Instrumente sind für jeden Kunden einzeln verpackt. Große Auswahl an Gellack-Farben. Sie machen sowohl Maschinen- als auch Beschneidungsmaniküre. Es gibt Leistungen von Podologe, Dermatologe und Orthopäde. Der Orthopäde hat vor unseren Augen Einlagen für meinen Sohn angefertigt. Der beste Salon in Montenegro. Gutes Preis-Leistungs-Verhältnis.', 'Kalite gerçekten üst düzeyde. Çok temiz. Bütün aletler her müşteri için ayrı ayrı paketlenmiş. Jel oje renk seçeneği çok geniş. Hem makineli hem de makaslı manikür yapıyorlar. Podolog, dermatolog ve ortopedi hizmetleri var. Ortopedist gözümüzün önünde oğluma tabanlık yaptı. Karadağ\'daki en iyi salon. Fiyat/kalite oranı çok iyi.',
    0, '2025-08-03 00:00:00'),

(@user_luxiar, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURiMVpYYTFBRRAB',
    5, 'en', 'Very pleasant experience, and the work is of really high quality. Highly recommend!',
    'Veoma prijatno iskustvo, a rad je zaista visokog kvaliteta. Toplo preporučujem!', 'Веома пријатно искуство, а рад је заиста висококвалитетан. Топло препоручујем!', 'Very pleasant experience, and the work is of really high quality. Highly recommend!', 'Очень приятный опыт, и работа действительно высокого качества. Очень рекомендую!', 'Sehr angenehme Erfahrung, und die Arbeit ist von wirklich hoher Qualität. Sehr empfehlenswert!', 'Çok keyifli bir deneyim ve işçilik gerçekten çok kaliteli. Kesinlikle tavsiye ederim!',
    0, '2025-08-03 00:00:00'),

(@user_maria_kovalik, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSURiNWJUU1dnEAE',
    5, 'ru', 'Очень довольна каждым посещением салона IPODO, приятный интерьер, дружелюбный и внимательный персонал
мастер Катарина - настоящий профессионал своего дела, всегда качественный и быстрый маникюр!',
    'Veoma sam zadovoljna svakom posjetom salonu IPODO, prijatan interijer, ljubazno i pažljivo osoblje
majstorica Katarina je pravi profesionalac u svom poslu, uvijek kvalitetan i brz manikir!', 'Веома сам задовољна сваком посјетом салону IPODO, пријатан интеријер, љубазно и пажљиво особље
мајсторица Катарина је прави професионалац у свом послу, увијек квалитетан и брз маникир!', 'I\'m very happy with every visit to the IPODO salon, pleasant interior, friendly and attentive staff
Katarina is a true professional at what she does, always a quality and quick manicure!', 'Очень довольна каждым посещением салона IPODO, приятный интерьер, дружелюбный и внимательный персонал
мастер Катарина - настоящий профессионал своего дела, всегда качественный и быстрый маникюр!', 'Ich bin mit jedem Besuch im Salon IPODO sehr zufrieden, angenehmes Interieur, freundliches und aufmerksames Personal
Katarina ist ein echter Profi in ihrem Fach, immer eine hochwertige und schnelle Maniküre!', 'IPODO salonuna her gelişimden çok memnunum, hoş bir iç mekân, güler yüzlü ve ilgili bir ekip
ustam Katarina işinin gerçek bir profesyoneli, manikür her zaman kaliteli ve hızlı!',
    0, '2025-08-03 00:00:00'),

(@user_anatoliy_p, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSURic01xaFB3EAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_elena_lenskaya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNicjVLOWNnEAE',
    5, 'ru', 'Великолепный салон! Аккуратная работа, приятная атмосфера, сервис на уровне.',
    'Sjajan salon! Pažljiv rad, prijatna atmosfera, usluga na nivou.', 'Сјајан салон! Пажљив рад, пријатна атмосфера, услуга на нивоу.', 'A magnificent salon! Neat work, pleasant atmosphere, service on point.', 'Великолепный салон! Аккуратная работа, приятная атмосфера, сервис на уровне.', 'Ein großartiger Salon! Sorgfältige Arbeit, angenehme Atmosphäre, Service auf hohem Niveau.', 'Muhteşem bir salon! Özenli işçilik, hoş bir atmosfer, hizmet tam kıvamında.',
    0, '2024-08-03 00:00:00'),

(@user_olga_isay, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNiNTZYdWdBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_ira_v, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNqLXVISjlnRRAB',
    5, 'ru', 'София как всегда на высоте! Благодарность мастеру 5 звезд из 5-ти!',
    'Sofija je kao i uvijek na visini! Hvala majstorici, 5 zvjezdica od 5!', 'Софија је као и увијек на висини! Хвала мајсторици, 5 звјездица од 5!', 'Sofija is on top form as always! Thanks to the technician, 5 stars out of 5!', 'София как всегда на высоте! Благодарность мастеру 5 звезд из 5-ти!', 'Sofija ist wie immer top! Danke an die Meisterin, 5 von 5 Sternen!', 'Sofija her zamanki gibi harika! Ustaya teşekkürler, 5 üzerinden 5 yıldız!',
    0, '2024-08-03 00:00:00'),

(@user_anastasia_suntsova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNieXYzVlF3EAE',
    5, 'ru', 'Очень уютно. Продуманный дизайн. Всегда приятное общение. Все мастера - профессионалы! Анастасия на ресепшн всегда приветливая и готовит вкусный кофе. Приходите, вы не пожалеете!',
    'Veoma je prijatno. Promišljen dizajn. Uvijek prijatna komunikacija. Sve majstorice su profesionalke! Anastasija na recepciji je uvijek ljubazna i pravi ukusnu kafu. Dođite, nećete se pokajati!', 'Веома је пријатно. Промишљен дизајн. Увијек пријатна комуникација. Све мајсторице су професионалке! Анастасија на рецепцији је увијек љубазна и прави укусну кафу. Дођите, нећете се покајати!', 'Very cosy. Thoughtful design. Always pleasant conversation. All the technicians are professionals! Anastasija at reception is always welcoming and makes delicious coffee. Come by, you won\'t regret it!', 'Очень уютно. Продуманный дизайн. Всегда приятное общение. Все мастера - профессионалы! Анастасия на ресепшн всегда приветливая и готовит вкусный кофе. Приходите, вы не пожалеете!', 'Sehr gemütlich. Durchdachtes Design. Immer angenehme Gespräche. Alle Mitarbeiterinnen sind Profis! Anastasija an der Rezeption ist immer freundlich und macht leckeren Kaffee. Kommt vorbei, ihr werdet es nicht bereuen!', 'Çok samimi bir yer. İnce düşünülmüş bir tasarım. Sohbet her zaman keyifli. Bütün ustalar profesyonel! Resepsiyondaki Anastasija her zaman güler yüzlü ve çok lezzetli kahve yapıyor. Gelin, pişman olmayacaksınız!',
    0, '2024-08-03 00:00:00'),

(@user_larisa_tolstova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSURyOXJybVpnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_ieva_deinaraviciute, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNieUxxemVREAE',
    5, 'en', 'Great services! Everything in the highest quality, masters has great knowledge, using good products☺️',
    'Sjajne usluge! Sve u najvišem kvalitetu, majstorice imaju veliko znanje, koriste dobre proizvode☺️', 'Сјајне услуге! Све у највишем квалитету, мајсторице имају велико знање, користе добре производе☺️', 'Great services! Everything in the highest quality, masters has great knowledge, using good products☺️', 'Отличные услуги! Всё высочайшего качества, мастера очень знающие, используют хорошие продукты☺️', 'Großartige Leistungen! Alles in höchster Qualität, die Mitarbeiterinnen haben viel Wissen, verwenden gute Produkte☺️', 'Hizmetler harika! Her şey en yüksek kalitede, ustalar çok bilgili, iyi ürünler kullanıyorlar☺️',
    0, '2024-08-03 00:00:00'),

(@user_tatyana_rofina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUREanNXVWp3RRAB',
    5, 'ru', 'Лучшая студия маникюра. Сервис и качество всегда на все 100😍 …',
    'Najbolji studio za manikir. Usluga i kvalitet uvijek na sto posto😍 …', 'Најбољи студио за маникир. Услуга и квалитет увијек на сто посто😍 …', 'The best manicure studio. Service and quality always a full 100😍 …', 'Лучшая студия маникюра. Сервис и качество всегда на все 100😍 …', 'Das beste Maniküre-Studio. Service und Qualität immer hundertprozentig😍 …', 'En iyi manikür stüdyosu. Hizmet ve kalite her zaman yüzde yüz😍 …',
    0, '2024-08-03 00:00:00'),

(@user_elena_berseneva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSURyMVBtTmVREAE',
    5, 'ru', 'Очень понравилась подолог Анюта, пациентом был мой сын (4 года) с гематомой от удара об стул большого пальца. Ребенок после процедуры вышел счастливый, радостный.
Еще и вкусняшками угостили.
Рекомендации после процедуры дали, будем выполнять, придем еще!
Большое спасибо!',
    'Podolog Anjuta mi se veoma dopala, pacijent je bio moj sin (4 godine) sa hematomom na palcu nakon udarca u stolicu. Dijete je poslije procedure izašlo srećno i veselo.
Čak su ga i slatkišima ugostili.
Dali su nam preporuke poslije procedure, pratićemo ih, dolazimo opet!
Veliko hvala!', 'Подолог Ањута ми се веома допала, пацијент је био мој син (4 године) са хематомом на палцу након ударца у столицу. Дијете је послије третмана изашло срећно и весело.
Чак су га и слаткишима угостили.
Дали су нам препоруке послије третмана, пратићемо их, долазимо опет!
Велико хвала!', 'I really liked the podiatrist Anjuta, the patient was my son (4 years old) with a haematoma on his big toe after banging it on a chair. The child came out of the procedure happy and cheerful.
They even treated him to some sweets.
They gave us aftercare recommendations, we\'ll follow them, we\'ll come again!
Many thanks!', 'Очень понравилась подолог Анюта, пациентом был мой сын (4 года) с гематомой от удара об стул большого пальца. Ребенок после процедуры вышел счастливый, радостный.
Еще и вкусняшками угостили.
Рекомендации после процедуры дали, будем выполнять, придем еще!
Большое спасибо!', 'Die Podologin Anjuta hat mir sehr gefallen, der Patient war mein Sohn (4 Jahre) mit einem Hämatom am großen Zeh, weil er sich an einem Stuhl gestoßen hatte. Das Kind kam nach der Behandlung glücklich und froh heraus.
Und es wurde sogar mit Leckereien verwöhnt.
Wir haben Empfehlungen für die Zeit nach der Behandlung bekommen, wir werden sie befolgen, wir kommen wieder!
Vielen Dank!', 'Podolog Anjuta\'yı çok sevdim, hasta 4 yaşındaki oğlumdu; ayak başparmağını sandalyeye çarpıp hematom oluşmuştu. Çocuk işlemden sonra mutlu ve neşeli çıktı.
Üstüne bir de şekerlemelerle ağırladılar.
İşlem sonrası için öneriler verdiler, uygulayacağız, yine geleceğiz!
Çok teşekkürler!',
    0, '2024-08-03 00:00:00'),

(@user_kseniia_nam, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNyN3JPMlpnEAE',
    5, 'ru', 'Отличный сервис, салон очень красивый и чистый. На ресепшене встречают, я немного заблудилась по пути, позвонила, и мне подсказали куда идти. Мне нравится, что в iPODO при вас вскрывают обработанные инструменты ♥️ все для безопасного маникюра и педикюра, для меня это очень важно.

Отдельное спасибо Светлане, делала маникюр и педикюр без покрытия. Светлана мне даже обработала небольшие воспаления (я натерла во время отпуска тапочками и песком). Чудесный сервис и было приятно поболтать! Еще Светлана мне в придачу дала апельсиновую палочку 🥰🥰🥰

Спасибо, если еще раз буду в Будве обязательно к вам зайду!',
    'Odlična usluga, salon je veoma lijep i čist. Na recepciji vas dočekaju, malo sam se izgubila na putu, pozvala sam i objasnili su mi kuda da idem. Volim što u iPODO pred vama otvaraju sterilisane instrumente ♥️ sve za bezbjedan manikir i pedikir, meni je to veoma važno.

Posebno hvala Svetlani, radila je manikir i pedikir bez lakiranja. Svetlana mi je čak obradila i mala zapaljenja (izranjavala sam noge na odmoru papučama i pijeskom). Divna usluga i bilo je prijatno popričati! Svetlana mi je uz to još dala i drveni štapić za zanoktice 🥰🥰🥰

Hvala, ako budem još jednom u Budvi, svakako ću vam doći!', 'Одлична услуга, салон је веома лијеп и чист. На рецепцији вас дочекају, мало сам се изгубила на путу, позвала сам и објаснили су ми куда да идем. Волим што у iPODO пред вама отварају стерилисане инструменте ♥️ све за безбједан маникир и педикир, мени је то веома важно.

Посебно хвала Светлани, радила је маникир и педикир без лакирања. Светлана ми је чак обрадила и мања запаљења (изранила сам ноге на одмору папучама и пијеском). Дивна услуга и било је пријатно попричати! Светлана ми је уз то још дала и дрвени штапић за заноктице 🥰🥰🥰

Хвала, ако будем још једном у Будви, свакако ћу вам доћи!', 'Excellent service, the salon is very beautiful and clean. They greet you at reception, I got a bit lost on the way, called them and they told me where to go. I like that at iPODO they open the sterilised instruments right in front of you ♥️ everything for a safe manicure and pedicure, that\'s very important to me.

Special thanks to Svetlana, she did my manicure and pedicure without polish. Svetlana even treated some small inflamed spots (I\'d rubbed my feet raw with flip-flops and sand on holiday). Wonderful service and it was lovely to chat! And on top of that Svetlana gave me an orange stick 🥰🥰🥰

Thank you, if I\'m ever in Budva again I\'ll definitely drop by!', 'Отличный сервис, салон очень красивый и чистый. На ресепшене встречают, я немного заблудилась по пути, позвонила, и мне подсказали куда идти. Мне нравится, что в iPODO при вас вскрывают обработанные инструменты ♥️ все для безопасного маникюра и педикюра, для меня это очень важно.

Отдельное спасибо Светлане, делала маникюр и педикюр без покрытия. Светлана мне даже обработала небольшие воспаления (я натерла во время отпуска тапочками и песком). Чудесный сервис и было приятно поболтать! Еще Светлана мне в придачу дала апельсиновую палочку 🥰🥰🥰

Спасибо, если еще раз буду в Будве обязательно к вам зайду!', 'Ausgezeichneter Service, der Salon ist sehr schön und sauber. An der Rezeption wird man empfangen, ich habe mich auf dem Weg etwas verlaufen, habe angerufen und man hat mir erklärt, wo ich hin muss. Mir gefällt, dass bei iPODO die aufbereiteten Instrumente direkt vor deinen Augen geöffnet werden ♥️ alles für eine sichere Maniküre und Pediküre, das ist mir sehr wichtig.

Ein besonderes Dankeschön an Svetlana, sie hat Maniküre und Pediküre ohne Lack gemacht. Svetlana hat mir sogar kleine Entzündungen behandelt (ich hatte mir im Urlaub die Füße mit Flip-Flops und Sand aufgerieben). Wunderbarer Service und es war schön zu plaudern! Und obendrein hat Svetlana mir noch ein Orangenholzstäbchen mitgegeben 🥰🥰🥰

Danke, wenn ich noch einmal in Budva bin, komme ich auf jeden Fall bei euch vorbei!', 'Hizmet mükemmel, salon çok güzel ve temiz. Resepsiyonda karşılıyorlar, yolda biraz kayboldum, aradım ve nereye gideceğimi anlattılar. iPODO\'da sterilize edilmiş aletlerin gözünüzün önünde açılması çok hoşuma gidiyor ♥️ güvenli manikür ve pedikür için her şey var, bu benim için çok önemli.

Svetlana\'ya ayrıca teşekkür ederim, ojesiz manikür ve pedikür yaptı. Svetlana küçük iltihaplı yerlerimi bile tedavi etti (tatilde terlik ve kumdan ayaklarım tahriş olmuştu). Harika bir hizmet, sohbet etmek de çok keyifliydi! Üstüne Svetlana bana bir de portakal ağacından manikür çubuğu verdi 🥰🥰🥰

Teşekkürler, Budva\'ya bir daha gelirsem mutlaka size uğrayacağım!',
    0, '2024-08-03 00:00:00'),

(@user_g_m, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNydXZDbU1BEAE',
    5, 'de', 'Sehr toller Service, sehr aufmerksam, ich wurde freundlich empfangen und umgehend nach einem Getränkewunsch gefragt. Ich spreche leider kein russisch, dennoch waren alle sehr zuvorkommend und aufmerksam, wir erhielten uns dann über Google Translate. Eine sehr große Auswahl an Farben und alle möglichen Trends, jeder Wunsch ist machbar, die Maniküre war sehr sauber und angenehm, alle Utensilien werden extra geöffnet, vorher Luftdicht verpackt und desinfiziert.
Mit dem Ergebnis bin ich sehr zufrieden, die Form und das Cateye ist ein Traum geworden. Vielen lieben Dank Katarina!',
    'Veoma sjajna usluga, veoma pažljivi, ljubazno su me primili i odmah pitali šta bih željela da popijem. Nažalost, ne govorim ruski, ali su svi bili veoma predusretljivi i pažljivi, sporazumijevali smo se preko Google Translate-a. Ogroman izbor boja i svi mogući trendovi, svaka želja je izvodljiva, manikir je bio veoma čist i prijatan, sav pribor se otvara posebno, prethodno hermetički zapakovan i dezinfikovan.
Rezultatom sam veoma zadovoljna, oblik i cat eye su ispali kao iz sna. Puno hvala, Katarina!', 'Веома сјајна услуга, веома пажљиви, љубазно су ме примили и одмах питали шта бих жељела да попијем. Нажалост, не говорим руски, али су сви били веома предусретљиви и пажљиви, споразумијевали смо се преко Google Translate-а. Огроман избор боја и сви могући трендови, свака жеља је изводљива, маникир је био веома чист и пријатан, сав прибор се отвара посебно, претходно херметички запакован и дезинфикован.
Резултатом сам веома задовољна, облик и cat eye испали су као из сна. Пуно хвала, Катарина!', 'Really great service, very attentive, I was greeted warmly and asked right away what I\'d like to drink. Unfortunately I don\'t speak Russian, but everyone was very obliging and attentive, we then got by via Google Translate. A huge choice of colours and every trend you can think of, any wish can be done, the manicure was very clean and pleasant, all the tools are opened specially, sealed airtight and disinfected beforehand.
I\'m very happy with the result, the shape and the cat eye turned out dreamy. Thank you so much, Katarina!', 'Очень классный сервис, очень внимательные, меня приветливо встретили и сразу спросили, что я хочу выпить. Я, к сожалению, не говорю по-русски, но все были очень предупредительны и внимательны, мы объяснялись через Google Translate. Огромный выбор цветов и все возможные тренды, любое желание выполнимо, маникюр был очень чистый и приятный, все инструменты вскрывают отдельно, они заранее герметично упакованы и продезинфицированы.
Результатом я очень довольна, форма и cat eye получились просто мечта. Большое спасибо, Катарина!', 'Sehr toller Service, sehr aufmerksam, ich wurde freundlich empfangen und umgehend nach einem Getränkewunsch gefragt. Ich spreche leider kein russisch, dennoch waren alle sehr zuvorkommend und aufmerksam, wir erhielten uns dann über Google Translate. Eine sehr große Auswahl an Farben und alle möglichen Trends, jeder Wunsch ist machbar, die Maniküre war sehr sauber und angenehm, alle Utensilien werden extra geöffnet, vorher Luftdicht verpackt und desinfiziert.
Mit dem Ergebnis bin ich sehr zufrieden, die Form und das Cateye ist ein Traum geworden. Vielen lieben Dank Katarina!', 'Hizmet çok harika, çok ilgililer, beni güler yüzle karşıladılar ve hemen ne içmek istediğimi sordular. Ne yazık ki Rusça bilmiyorum ama herkes çok nazik ve ilgiliydi, Google Translate üzerinden anlaştık. Renk seçeneği çok geniş ve akla gelen her trend var, her istek yapılabiliyor, manikür çok temiz ve keyifliydi, bütün aletler önceden hava geçirmez şekilde paketlenip dezenfekte edilmiş ve ayrıca açılıyor.
Sonuçtan çok memnunum, form ve cat eye harika oldu. Katarina, çok çok teşekkürler!',
    0, '2024-08-03 00:00:00'),

(@user_sveta_mikhaylova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSURMX1BfV0JnEAE',
    5, 'ru', 'Прекрасный специалист!',
    'Divan stručnjak!', 'Диван стручњак!', 'A wonderful specialist!', 'Прекрасный специалист!', 'Ein wunderbarer Spezialist!', 'Harika bir uzman!',
    0, '2024-08-03 00:00:00'),

(@user_garri_garri, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUN6MlBDWEJBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_anita_lalic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNMLVpTbzhRRRAB',
    5, 'hr', 'Imala sam virusne bradavice na stopalu kojih nikako nisam mogla da se rijesim dok nisam otkrila ovaj salon. Sve preporuke!',
    'Imala sam virusne bradavice na stopalu kojih nikako nisam mogla da se rijesim dok nisam otkrila ovaj salon. Sve preporuke!', 'Имала сам вирусне брадавице на стопалу којих никако нисам могла да се ријешим док нисам открила овај салон. Све препоруке!', 'I had viral warts on my foot that I just couldn\'t get rid of until I discovered this salon. Highly recommended!', 'У меня были вирусные бородавки на стопе, от которых я никак не могла избавиться, пока не нашла этот салон. Всем рекомендую!', 'Ich hatte Viruswarzen am Fuß, die ich einfach nicht loswerden konnte, bis ich diesen Salon entdeckt habe. Absolut empfehlenswert!', 'Ayağımda bir türlü kurtulamadığım virüs kaynaklı siğiller vardı, ta ki bu salonu keşfedene kadar. Kesinlikle tavsiye ederim!',
    0, '2024-08-03 00:00:00'),

(@user_olga_3, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNMeWVMeHNRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_inna_boye, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNMc3BXRmlnRRAB',
    5, 'ru', 'Как всегда все на высоте, качество супер. За милой беседой не замечаешь времени. Комфортно, стильно.
Спасибо , девочки !!!!',
    'Kao i uvijek sve je na visini, kvalitet super. Uz lijep razgovor ni ne primijetiš kako vrijeme prolazi. Komforno, stilski.
Hvala , djevojke !!!!', 'Као и увијек све је на висини, квалитет супер. Уз лијеп разговор ни не примијетиш како вријеме пролази. Комфорно, стилски.
Хвала , дјевојке !!!!', 'As always everything is top notch, the quality is super. With such nice conversation you don\'t even notice the time passing. Comfortable, stylish.
Thank you , girls !!!!', 'Как всегда все на высоте, качество супер. За милой беседой не замечаешь времени. Комфортно, стильно.
Спасибо , девочки !!!!', 'Wie immer ist alles top, die Qualität ist super. Bei so einem netten Gespräch merkt man die Zeit gar nicht. Bequem, stilvoll.
Danke , Mädels !!!!', 'Her zamanki gibi her şey harika, kalite süper. Güzel bir sohbetle zamanın nasıl geçtiğini fark etmiyorsun. Rahat, şık.
Teşekkürler , kızlar !!!!',
    0, '2024-08-03 00:00:00'),

(@user_mary_fetr, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNMbUxMNmdRRRAB',
    5, 'ru', 'Прекрасный салон, мне понравилась мастер Светлана.',
    'Prekrasan salon, meni se dopala majstorica Svetlana.', 'Предиван салон, мени се допала мајсторица Светлана.', 'A lovely salon, I really liked Svetlana.', 'Прекрасный салон, мне понравилась мастер Светлана.', 'Ein wunderschöner Salon, mir hat die Nageldesignerin Svetlana gefallen.', 'Harika bir salon, ustam Svetlana çok hoşuma gitti.',
    0, '2024-08-03 00:00:00'),

(@user_anja_maja_bogievi, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUREdWEyWXdnRRAB',
    5, 'hr', 'Najbolji, najljubazniji i najsigurniji.',
    'Najbolji, najljubazniji i najsigurniji.', 'Најбољи, најљубазнији и најсигурнији.', 'The best, the kindest and the safest.', 'Лучшие, самые любезные и самые безопасные.', 'Die Besten, die Freundlichsten und die Sichersten.', 'En iyisi, en naziği ve en güvenlisi.',
    0, '2024-08-03 00:00:00'),

(@user_dr_elena_leschen, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNUbXFyTDV3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_veronica, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSURqaTdLZGR3EAE',
    5, 'ru', 'Лучший  ногтевой сервис в Черногории!!!! Высококлассные специалисты, стерильность, все на высшем уровне! Спасибо девочкам за заботу о наших ручках и ножках!!!!!!❤️❤️❤️',
    'Najbolji servis za nokte u Crnoj Gori!!!! Vrhunski stručnjaci, sterilnost, sve na najvišem nivou! Hvala djevojkama što se brinu o našim rukicama i nožicama!!!!!!❤️❤️❤️', 'Најбољи сервис за нокте у Црној Гори!!!! Врхунски стручњаци, стерилност, све на највишем нивоу! Хвала дјевојкама што се брину о нашим рукицама и ножицама!!!!!!❤️❤️❤️', 'The best nail service in Montenegro!!!! Top-class specialists, sterility, everything at the highest level! Thank you girls for taking such care of our hands and feet!!!!!!❤️❤️❤️', 'Лучший  ногтевой сервис в Черногории!!!! Высококлассные специалисты, стерильность, все на высшем уровне! Спасибо девочкам за заботу о наших ручках и ножках!!!!!!❤️❤️❤️', 'Der beste Nagelservice in Montenegro!!!! Erstklassige Fachkräfte, Sterilität, alles auf höchstem Niveau! Danke, Mädels, dass ihr euch so um unsere Händchen und Füßchen kümmert!!!!!!❤️❤️❤️', 'Karadağ\'daki en iyi tırnak bakımı!!!! Birinci sınıf uzmanlar, sterilizasyon, her şey en üst düzeyde! Ellerimize ve ayaklarımıza gösterdikleri özen için kızlara teşekkürler!!!!!!❤️❤️❤️',
    0, '2024-08-03 00:00:00'),

(@user_vera_kiselyova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUR6X3JLcGdBRRAB',
    5, 'ru', 'Как обычно все на высоте. Приятный менеджер. Очень хороший мастер Наталья.',
    'Kao i obično sve je na najvišem nivou. Prijatan menadžer. Veoma dobar majstor Natalja.', 'Као и обично све је на највишем нивоу. Пријатан менаџер. Веома добар мајстор Наталја.', 'As usual, everything is top notch. Pleasant manager. Natalya is a very good specialist.', 'Как обычно все на высоте. Приятный менеджер. Очень хороший мастер Наталья.', 'Wie immer alles auf höchstem Niveau. Angenehme Managerin. Natalya ist eine sehr gute Fachkraft.', 'Her zamanki gibi her şey mükemmel. Hoş bir yönetici. Natalya çok iyi bir uzman.',
    0, '2024-08-03 00:00:00'),

(@user_oleh_anokhin, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUR6eXVUUVdnEAE',
    5, 'ru', 'Классные специалисты, уютная атмосфера, все чисто и современно. Если нужен педикюр или услуги подолога - это выглядит лучшим вариантом в Будве и Бечичи :)',
    'Sjajni stručnjaci, prijatna atmosfera, sve je čisto i moderno. Ako vam treba pedikir ili usluge podologa - ovo izgleda kao najbolja opcija u Budvi i Bečićima :)', 'Сјајни стручњаци, пријатна атмосфера, све је чисто и модерно. Ако вам треба педикир или услуге подолога - ово изгледа као најбоља опција у Будви и Бечићима :)', 'Great specialists, cosy atmosphere, everything is clean and modern. If you need a pedicure or podiatrist services, this looks like the best option in Budva and Bečići :)', 'Классные специалисты, уютная атмосфера, все чисто и современно. Если нужен педикюр или услуги подолога - это выглядит лучшим вариантом в Будве и Бечичи :)', 'Klasse Fachleute, gemütliche Atmosphäre, alles sauber und modern. Wenn man eine Fußpflege oder einen Podologen braucht, sieht das nach der besten Option in Budva und Bečići aus :)', 'Harika uzmanlar, samimi bir atmosfer, her şey temiz ve modern. Pedikür ya da podolog hizmetine ihtiyacınız varsa, Budva ve Bečići\'deki en iyi seçenek gibi görünüyor :)',
    0, '2024-08-03 00:00:00'),

(@user_katty_pride, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUR6aFBhWXZ3RRAB',
    5, 'ru', 'Как всегда - все прекрасно!',
    'Kao i uvijek - sve je divno!', 'Као и увијек - све је дивно!', 'As always - everything is wonderful!', 'Как всегда - все прекрасно!', 'Wie immer - alles wunderbar!', 'Her zamanki gibi - her şey harika!',
    0, '2024-08-03 00:00:00'),

(@user_anastasia_patlavskaya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUN6Nm9tbTdBRRAB',
    5, 'ru', 'Катя очень дружелюбная, работает над тем чтобы ногти были обработаны чисто и красиво. Кожа на руках не торчит, ногти в идеальном виде. Мне очень понравилось, атмосфера она легкая.',
    'Katja je veoma ljubazna, radi tako da nokti budu obrađeni čisto i lijepo. Koža na rukama ne visi, nokti su u idealnom stanju. Veoma mi se svidjelo, atmosfera je lagana.', 'Катја је веома љубазна, ради тако да нокти буду обрађени чисто и лијепо. Кожа на рукама не виси, нокти су у идеалном стању. Веома ми се свидјело, атмосфера је лагана.', 'Katya is very friendly, she works so that the nails come out clean and beautiful. No skin sticking out on the hands, the nails are in perfect shape. I really liked it, the atmosphere is relaxed.', 'Катя очень дружелюбная, работает над тем чтобы ногти были обработаны чисто и красиво. Кожа на руках не торчит, ногти в идеальном виде. Мне очень понравилось, атмосфера она легкая.', 'Katya ist sehr freundlich, sie arbeitet so, dass die Nägel sauber und schön werden. Keine abstehende Haut an den Händen, die Nägel sind in perfektem Zustand. Es hat mir sehr gefallen, die Atmosphäre ist entspannt.', 'Katya çok cana yakın, tırnakların temiz ve güzel işlenmesi için çalışıyor. Ellerdeki deri hiç çıkıntı yapmıyor, tırnaklar kusursuz görünüyor. Çok memnun kaldım, atmosfer çok rahat.',
    0, '2024-08-03 00:00:00'),

(@user_inna_khoronzhuk, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUREemZ2TlZREAE',
    5, 'ru', 'Довольна, благодарна..Девочки; вы умницы, красавицы и еще и профи!!!',
    'Zadovoljna sam, zahvalna..Djevojke; vi ste pametne, prelijepe i još k tome profesionalke!!!', 'Задовољна сам, захвална..Дјевојке; ви сте паметне, прелијепе и још к томе професионалке!!!', 'Happy and grateful..Girls; you are clever, gorgeous and pros on top of that!!!', 'Довольна, благодарна..Девочки; вы умницы, красавицы и еще и профи!!!', 'Ich bin zufrieden und dankbar..Mädels; ihr seid klug, schön und obendrein Profis!!!', 'Memnunum, minnettarım..Kızlar; hem akıllısınız, hem çok güzelsiniz, hem de profesyonelsiniz!!!',
    0, '2024-08-03 00:00:00'),

(@user_varja_delibasic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNEc2R1MWhRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_kamill_musaev, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSURUXzh2dU1REAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_milica_kasalo, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURUX3JQc3d3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_viktoriya_polonskaya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSURUanRtbkFREAE',
    5, 'ru', 'Очень приятная атмосфера, ощущение чистоты и надёжности. Отличный мастер Светлана. Квалифицированный и внимательный и качественный подход к выполняемой работе.',
    'Veoma prijatna atmosfera, osjećaj čistoće i sigurnosti. Odličan majstor Svetlana. Kvalifikovan, pažljiv i kvalitetan pristup poslu.', 'Веома пријатна атмосфера, осјећај чистоће и сигурности. Одличан мајстор Светлана. Квалификован, пажљив и квалитетан приступ послу.', 'Very pleasant atmosphere, a feeling of cleanliness and reliability. Svetlana is an excellent specialist. A qualified, attentive and thorough approach to the work.', 'Очень приятная атмосфера, ощущение чистоты и надёжности. Отличный мастер Светлана. Квалифицированный и внимательный и качественный подход к выполняемой работе.', 'Sehr angenehme Atmosphäre, ein Gefühl von Sauberkeit und Zuverlässigkeit. Svetlana ist eine ausgezeichnete Fachkraft. Ein qualifizierter, aufmerksamer und gründlicher Umgang mit der Arbeit.', 'Çok hoş bir atmosfer, temizlik ve güven hissi. Svetlana harika bir uzman. İşine nitelikli, özenli ve kaliteli bir yaklaşım.',
    0, '2024-08-03 00:00:00'),

(@user_olga_sbitneva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSURUcE9HOEFnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_nena_djukic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSURUMEpfcVdREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_mela_masta, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURUd05xYWhnRRAB',
    5, 'ru', 'Спасибо Анне за помощь) Сам центр отличный, инструменты стиральные, помещения чистые, мастера в масках )',
    'Hvala Ani na pomoći) Sam centar je odličan, instrumenti sterilni, prostorije čiste, majstori u maskama )', 'Хвала Ани на помоћи) Сам центар је одличан, инструменти стерилни, просторије чисте, мајстори у маскама )', 'Thanks to Anna for her help) The centre itself is excellent, sterile instruments, clean rooms, the specialists wear masks )', 'Спасибо Анне за помощь) Сам центр отличный, инструменты стиральные, помещения чистые, мастера в масках )', 'Danke an Anna für die Hilfe) Das Zentrum selbst ist ausgezeichnet, sterile Instrumente, saubere Räume, die Fachkräfte tragen Masken )', 'Yardımı için Anna\'ya teşekkürler) Merkezin kendisi harika, aletler steril, odalar temiz, uzmanlar maskeli )',
    0, '2024-08-03 00:00:00'),

(@user_nina_markina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNUZzhHT2FBEAE',
    5, 'ru', 'Все супер, как и всегда!',
    'Sve je super, kao i uvijek!', 'Све је супер, као и увијек!', 'Everything is super, as always!', 'Все супер, как и всегда!', 'Alles super, wie immer!', 'Her şey süper, her zamanki gibi!',
    0, '2024-08-03 00:00:00'),

(@user_alena_koltsova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNUX1plTjJnRRAB',
    5, 'ru', 'Очень довольна посещением центра, результат превзошел все мои ожидания! Очень доброжелательные специалисты, подробные, полезные рекомендации, чистота. Потребовалась консультация и помощь подолога, рекомендации подолога Анны были полезны, помощь эффективна, а также она оказалась очень приятным, доброжелательным человеком. Когда возникли дополнительные вопросы уже после посещения, на них мне ответили максимально быстро и подробно. Кроме того, вызвало уважение к салону, что мне не стали агрессивно навязывать дополнительных дорогостоящих услуг, предложив только рекомендации по улучшениям, если у меня есть желание.',
    'Veoma sam zadovoljna posjetom centru, rezultat je nadmašio sva moja očekivanja! Veoma ljubazni stručnjaci, detaljne i korisne preporuke, čistoća. Bila mi je potrebna konsultacija i pomoć podologa, preporuke podologa Ane bile su korisne, pomoć efikasna, a osim toga pokazala se kao veoma prijatna i ljubazna osoba. Kada su se pojavila dodatna pitanja već nakon posjete, odgovorili su mi maksimalno brzo i detaljno. Osim toga, izazvalo je poštovanje prema salonu to što mi nisu agresivno nametali dodatne skupe usluge, već su samo ponudili preporuke za poboljšanja, ako imam želju.', 'Веома сам задовољна посјетом центру, резултат је надмашио сва моја очекивања! Веома љубазни стручњаци, детаљне и корисне препоруке, чистоћа. Била ми је потребна консултација и помоћ подолога, препоруке подолога Ане биле су корисне, помоћ ефикасна, а осим тога показала се као веома пријатна и љубазна особа. Када су се појавила додатна питања већ након посјете, одговорили су ми максимално брзо и детаљно. Осим тога, изазвало је поштовање према салону то што ми нису агресивно наметали додатне скупе услуге, већ су само понудили препоруке за побољшања, ако имам жељу.', 'I am very happy with my visit to the centre, the result exceeded all my expectations! Very kind specialists, detailed and useful recommendations, cleanliness. I needed a consultation and help from a podiatrist; the recommendations of the podiatrist Anna were useful, the help was effective, and she also turned out to be a very pleasant, kind person. When extra questions came up after the visit, they answered them as quickly and thoroughly as possible. On top of that, it earned the salon my respect that they did not aggressively push extra expensive services on me, but only offered recommendations for improvements, if I felt like it.', 'Очень довольна посещением центра, результат превзошел все мои ожидания! Очень доброжелательные специалисты, подробные, полезные рекомендации, чистота. Потребовалась консультация и помощь подолога, рекомендации подолога Анны были полезны, помощь эффективна, а также она оказалась очень приятным, доброжелательным человеком. Когда возникли дополнительные вопросы уже после посещения, на них мне ответили максимально быстро и подробно. Кроме того, вызвало уважение к салону, что мне не стали агрессивно навязывать дополнительных дорогостоящих услуг, предложив только рекомендации по улучшениям, если у меня есть желание.', 'Ich bin mit meinem Besuch im Zentrum sehr zufrieden, das Ergebnis hat alle meine Erwartungen übertroffen! Sehr freundliche Fachkräfte, ausführliche, hilfreiche Empfehlungen, Sauberkeit. Ich brauchte eine Beratung und Hilfe einer Podologin; die Empfehlungen der Podologin Anna waren hilfreich, die Behandlung wirksam, und sie erwies sich zudem als sehr angenehmer, freundlicher Mensch. Als nach dem Besuch noch weitere Fragen aufkamen, wurden sie mir schnellstmöglich und ausführlich beantwortet. Außerdem hat mir Respekt für den Salon eingebracht, dass man mir keine zusätzlichen teuren Leistungen aggressiv aufgedrängt hat, sondern nur Empfehlungen für Verbesserungen gegeben hat, falls ich Lust darauf habe.', 'Merkeze yaptığım ziyaretten çok memnun kaldım, sonuç bütün beklentilerimi aştı! Çok güler yüzlü uzmanlar, ayrıntılı ve faydalı öneriler, temizlik. Bir podolog konsültasyonuna ve yardımına ihtiyacım vardı; podolog Anna\'nın önerileri faydalı, yardımı etkili oldu, ayrıca kendisi çok hoş ve iyi kalpli bir insan çıktı. Ziyaretten sonra ek sorularım olduğunda bunlara mümkün olan en hızlı ve en ayrıntılı şekilde yanıt verdiler. Bunun dışında, bana ek pahalı hizmetleri agresif bir şekilde dayatmamaları, sadece istersem uygulayabileceğim iyileştirme önerileri sunmaları salona duyduğum saygıyı artırdı.',
    0, '2024-08-03 00:00:00'),

(@user_anton_2, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNUamZpdlNBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_anna_belaya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNUMXVXQzB3RRAB',
    5, 'ru', 'Волшебное место , сервис 10 из 10 , спасибо большое!!😊 …',
    'Čarobno mjesto , servis 10 od 10 , hvala vam puno!!😊 …', 'Чаробно мјесто , сервис 10 од 10 , хвала вам пуно!!😊 …', 'A magical place , service 10 out of 10 , thank you so much!!😊 …', 'Волшебное место , сервис 10 из 10 , спасибо большое!!😊 …', 'Ein zauberhafter Ort , Service 10 von 10 , vielen Dank!!😊 …', 'Büyülü bir yer , servis 10 üzerinden 10 , çok teşekkürler!!😊 …',
    0, '2024-08-03 00:00:00'),

(@user_alexandr_makovskiy, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNUX0l1cHZ3RRAB',
    5, 'ru', 'Отличный салон
Очень вежливые администраторки))
Анюта - подолог от Бога, рекомендую!',
    'Odličan salon
Veoma ljubazne administratorke))
Anjuta - podolog od Boga, preporučujem!', 'Одличан салон
Веома љубазне администраторке))
Ањута - подолог од Бога, препоручујем!', 'Excellent salon
Very polite receptionists))
Anjuta is a God-given podiatrist, highly recommend!', 'Отличный салон
Очень вежливые администраторки))
Анюта - подолог от Бога, рекомендую!', 'Ausgezeichneter Salon
Sehr höfliche Empfangsdamen))
Anjuta ist eine gottbegnadete Podologin, ich empfehle sie!', 'Harika bir salon
Çok nazik resepsiyonistler))
Anjuta Tanrı vergisi bir podolog, tavsiye ederim!',
    0, '2024-08-03 00:00:00'),

(@user_andjela_bojovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUREaEstNmlBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_rina_rina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNqaTRiMEFnEAE',
    5, 'ru', 'Посетила салон педикюра  IPODO сегодня и осталась в полном восторге от проведенного времени! Прекрасные мастера, отличное обслуживание и уютная атмосфера. Мне предложили выбор напитков, что было приятным бонусом. Педикюр выполнен идеально, ноги выглядят прекрасно! Большое спасибо за заботу и профессионализм. Очень рекомендую этот салон!',
    'Danas sam posjetila salon za pedikir IPODO i ostala sam potpuno očarana provedenim vremenom! Divni majstori, odlična usluga i prijatna atmosfera. Ponudili su mi izbor napitaka, što je bio lijep bonus. Pedikir je napravljen savršeno, stopala izgledaju divno! Veliko hvala na brizi i profesionalnosti. Toplo preporučujem ovaj salon!', 'Данас сам посјетила салон за педикир IPODO и остала сам потпуно очарана проведеним временом! Дивни мајстори, одлична услуга и пријатна атмосфера. Понудили су ми избор напитака, што је био лијеп бонус. Педикир је направљен савршено, стопала изгледају дивно! Велико хвала на бризи и професионалности. Топло препоручујем овај салон!', 'I visited the IPODO pedicure salon today and absolutely loved the time I spent there! Wonderful specialists, excellent service and a cosy atmosphere. They offered me a choice of drinks, which was a nice bonus. The pedicure was done perfectly, my feet look great! Many thanks for the care and professionalism. I highly recommend this salon!', 'Посетила салон педикюра  IPODO сегодня и осталась в полном восторге от проведенного времени! Прекрасные мастера, отличное обслуживание и уютная атмосфера. Мне предложили выбор напитков, что было приятным бонусом. Педикюр выполнен идеально, ноги выглядят прекрасно! Большое спасибо за заботу и профессионализм. Очень рекомендую этот салон!', 'Ich habe heute das Fußpflege-Studio IPODO besucht und war von der Zeit dort einfach begeistert! Wunderbare Fachkräfte, ausgezeichneter Service und eine gemütliche Atmosphäre. Man hat mir eine Auswahl an Getränken angeboten, was ein schöner Bonus war. Die Fußpflege wurde perfekt gemacht, meine Füße sehen herrlich aus! Vielen Dank für die Fürsorge und die Professionalität. Ich empfehle diesen Salon sehr!', 'Bugün IPODO pedikür salonunu ziyaret ettim ve geçirdiğim zamandan tam anlamıyla büyülendim! Harika uzmanlar, mükemmel hizmet ve samimi bir atmosfer. Bana içecek seçeneği sundular, bu hoş bir bonus oldu. Pedikür kusursuz yapıldı, ayaklarım harika görünüyor! İlgi ve profesyonellik için çok teşekkürler. Bu salonu kesinlikle tavsiye ederim!',
    0, '2024-08-03 00:00:00'),

(@user_sofiya_patrina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNqb1lXMFR3EAE',
    5, 'ru', 'Идеальный маникюр!',
    'Savršen manikir!', 'Савршен маникир!', 'Perfect manicure!', 'Идеальный маникюр!', 'Perfekte Maniküre!', 'Kusursuz manikür!',
    0, '2024-08-03 00:00:00'),

(@user_polina_polina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNqckptQTNRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_varvara_koneva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNqck43UHVnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_snap_17, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNqalBPRkVREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_darya_tushevagerasimenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUREbzhyOFJREAE',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_kristina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNqZ0xHUXJ3RRAB',
    5, 'ru', 'Очень приятное место, эстетичное и уютное. Была на услуге педикюр с покрытием у мастера Катарины. Осталась очень довольна результатом ❤️',
    'Veoma prijatno mjesto, estetski uređeno i udobno. Bila sam na pedikiru sa lakiranjem kod majstorice Katarine. Ostala sam veoma zadovoljna rezultatom ❤️', 'Веома пријатно мјесто, естетски уређено и удобно. Била сам на педикиру са лакирањем код мајсторице Катарине. Остала сам веома задовољна резултатом ❤️', 'A very pleasant place, aesthetic and cosy. I had a pedicure with polish done by Katarina. I was very happy with the result ❤️', 'Очень приятное место, эстетичное и уютное. Была на услуге педикюр с покрытием у мастера Катарины. Осталась очень довольна результатом ❤️', 'Ein sehr angenehmer Ort, ästhetisch und gemütlich. Ich war zur Fußpflege mit Lack bei Katarina. Mit dem Ergebnis war ich sehr zufrieden ❤️', 'Çok hoş bir yer, estetik ve rahat. Uzman Katarina\'da cilalı pedikür yaptırdım. Sonuçtan çok memnun kaldım ❤️',
    0, '2024-08-03 00:00:00'),

(@user_elena_shokhova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUREai16dE53EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_ekaterina_bochkareva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUREMnRfNkJnEAE',
    5, 'en', 'Everything was wonderful, a beautiful room, friendly staff, amazing coffee and a huge selection of colors in the palette 🤍🥰 …',
    'Sve je bilo divno, prelijep prostor, ljubazno osoblje, fantastična kafa i ogroman izbor boja u paleti 🤍🥰 …', 'Све је било дивно, прелијеп простор, љубазно особље, фантастична кафа и огроман избор боја у палети 🤍🥰 …', 'Everything was wonderful, a beautiful room, friendly staff, amazing coffee and a huge selection of colors in the palette 🤍🥰 …', 'Всё было замечательно, красивое помещение, дружелюбный персонал, восхитительный кофе и огромный выбор цветов в палитре 🤍🥰 …', 'Alles war wunderbar, ein schöner Raum, freundliches Personal, fantastischer Kaffee und eine riesige Farbauswahl in der Palette 🤍🥰 …', 'Her şey harikaydı, çok güzel bir mekan, güler yüzlü personel, mükemmel kahve ve paletinde kocaman bir renk seçeneği 🤍🥰 …',
    0, '2024-08-03 00:00:00'),

(@user_geneticheskiy_dietolog_lyudmila_goncharova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUREcEtIMG5BRRAB',
    5, 'ru', 'Оазис профессиональной команды и руководителя, клиентоориентированность, соблюдения антисептики. Всегда знаю, что все будет на высшем уровне. Сердечная благодарность!',
    'Oaza profesionalnog tima i rukovodioca, orijentisanost na klijenta, poštovanje antiseptike. Uvijek znam da će sve biti na najvišem nivou. Srdačno hvala!', 'Оаза професионалног тима и руководиоца, оријентисаност на клијента, поштовање антисептике. Увијек знам да ће све бити на највишем нивоу. Срдачно хвала!', 'An oasis of a professional team and manager, a client-focused approach, proper antiseptic practice. I always know everything will be top level. My heartfelt thanks!', 'Оазис профессиональной команды и руководителя, клиентоориентированность, соблюдения антисептики. Всегда знаю, что все будет на высшем уровне. Сердечная благодарность!', 'Eine Oase aus einem professionellen Team und einer professionellen Leitung, Kundenorientierung, konsequente Antiseptik. Ich weiß immer, dass alles auf höchstem Niveau sein wird. Herzlichen Dank!', 'Profesyonel bir ekip ve yöneticinin oluşturduğu bir vaha, müşteri odaklılık, antisepsi kurallarına tam uyum. Her şeyin en üst düzeyde olacağını her zaman biliyorum. Yürekten teşekkürler!',
    0, '2024-08-03 00:00:00'),

(@user_milja_zenovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUREdVBIT2hBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_viktoriya_garkusha, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNELThheDFnRRAB',
    5, 'ru', 'Приятная уютная атмосфера,качественные услуги...Все супер😍 …',
    'Prijatna udobna atmosfera,kvalitetne usluge...Sve je super😍 …', 'Пријатна удобна атмосфера,квалитетне услуге...Све је супер😍 …', 'Pleasant cosy atmosphere,quality services...Everything is super😍 …', 'Приятная уютная атмосфера,качественные услуги...Все супер😍 …', 'Angenehme gemütliche Atmosphäre,hochwertige Leistungen...Alles super😍 …', 'Hoş ve samimi bir atmosfer,kaliteli hizmetler...Her şey süper😍 …',
    0, '2024-08-03 00:00:00'),

(@user_liliya_kalintseva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNEczl6OGVnEAE',
    5, 'ru', 'Спасибо за маникюр Софии!',
    'Hvala Sofiji na manikiru!', 'Хвала Софији на маникиру!', 'Thank you to Sofija for the manicure!', 'Спасибо за маникюр Софии!', 'Danke an Sofija für die Maniküre!', 'Manikür için Sofija\'ya teşekkürler!',
    0, '2024-08-03 00:00:00'),

(@user_anna_m, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNEaGFMcHVnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_anzhela_shavrina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNEdnB1bC1nRRAB',
    5, 'ru', 'Спасибо, мастеру маникюра Людмиле! Всё было чудесно в процессе + с волшебным видом на черногорский пейзаж! Результат тоже порадовал!',
    'Hvala majstorici manikira Ljudmili! Sve je bilo čudesno tokom procesa + uz čaroban pogled na crnogorski pejzaž! I rezultat je obradovao!', 'Хвала мајсторици маникира Људмили! Све је било чудесно током процеса + уз чаробан поглед на црногорски пејзаж! И резултат је обрадовао!', 'Thank you to Ljudmila, the manicurist! Everything was lovely during the process + with a magical view of the Montenegrin landscape! The result made me happy too!', 'Спасибо, мастеру маникюра Людмиле! Всё было чудесно в процессе + с волшебным видом на черногорский пейзаж! Результат тоже порадовал!', 'Danke an die Nagelpflegerin Ljudmila! Alles war während der Behandlung wunderschön + mit einem zauberhaften Blick auf die montenegrinische Landschaft! Das Ergebnis hat mich auch gefreut!', 'Manikür uzmanı Ljudmila\'ya teşekkürler! Süreç boyunca her şey harikaydı + üstelik Karadağ manzarasının büyülü görüntüsüyle! Sonuç da beni çok memnun etti!',
    0, '2024-08-03 00:00:00'),

(@user_vika_mickey, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNEcnRMbHBBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_anna_kvasha, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNENW9EWTJRRRAB',
    5, 'en', 'Amazing professional work, high quality service and so kind stuff. Highly recommend!',
    'Sjajan profesionalan rad, kvalitetna usluga i tako ljubazno osoblje. Toplo preporučujem!', 'Сјајан професионалан рад, квалитетна услуга и тако љубазно особље. Топло препоручујем!', 'Amazing professional work, high quality service and so kind stuff. Highly recommend!', 'Потрясающая профессиональная работа, качественный сервис и такой любезный персонал. Очень рекомендую!', 'Fantastische professionelle Arbeit, hochwertiger Service und so freundliches Personal. Sehr empfehlenswert!', 'Harika profesyonel bir iş, kaliteli hizmet ve çok nazik bir ekip. Kesinlikle tavsiye ederim!',
    0, '2024-08-03 00:00:00'),

(@user_sofia_e, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ5NzYtV25nRRAB',
    5, 'ru', 'Хожу в салон IPODO уже несколько лет.
- Почему?
1. Стерильность. В Черногории нет закона, который жестко контролирует стерильность салонов красоты и из-за этого зачастую к этому относятся без особого внимания. В IPODO есть отдельная комната для стерилизации материалов с большим количеством различных аппаратов.
2. Персонал. Все работники салона очень приятные, с вниманием относятся ко всем пожеланиям. Отдельное спасибо мастеру Светлане к которой я записываюсь каждый раз. Идеальная обработка кутикул, ровное покрытие, помощь в выборе цвета и приятные беседы.
3. Кофе!!! Кофе лучше чем во многих ресторанах.',
    'U salon IPODO idem već nekoliko godina.
- Zašto?
1. Sterilnost. U Crnoj Gori ne postoji zakon koji strogo kontroliše sterilnost kozmetičkih salona i zbog toga se tome često ne posvećuje posebna pažnja. IPODO ima posebnu prostoriju za sterilizaciju materijala s velikim brojem različitih aparata.
2. Osoblje. Svi zaposleni u salonu su veoma prijatni i s pažnjom se odnose prema svim željama. Posebno hvala majstorici Svetlani kod koje se zakazujem svaki put. Idealna obrada zanoktica, ravnomjeran lak, pomoć pri izboru boje i prijatni razgovori.
3. Kafa!!! Kafa je bolja nego u mnogim restoranima.', 'У салон IPODO идем већ неколико година.
- Зашто?
1. Стерилност. У Црној Гори не постоји закон који строго контролише стерилност козметичких салона и због тога се томе често не посвећује посебна пажња. IPODO има посебну просторију за стерилизацију материјала с великим бројем различитих апарата.
2. Особље. Сви запослени у салону су веома пријатни и с пажњом се односе према свим жељама. Посебно хвала мајсторици Светлани код које се заказујем сваки пут. Идеална обрада заноктица, равномјеран лак, помоћ при избору боје и пријатни разговори.
3. Кафа!!! Кафа је боља него у многим ресторанима.', 'I\'ve been going to the IPODO salon for several years now.
- Why?
1. Sterility. Montenegro has no law that strictly controls the sterility of beauty salons, and because of that it\'s often treated without much attention. IPODO has a separate room for sterilizing materials, with a large number of different machines.
2. The staff. All the salon\'s employees are very pleasant and attentive to every request. Special thanks to Svetlana, whom I book with every time. Perfect cuticle work, even coating, help choosing the colour and pleasant conversations.
3. The coffee!!! The coffee is better than in many restaurants.', 'Хожу в салон IPODO уже несколько лет.
- Почему?
1. Стерильность. В Черногории нет закона, который жестко контролирует стерильность салонов красоты и из-за этого зачастую к этому относятся без особого внимания. В IPODO есть отдельная комната для стерилизации материалов с большим количеством различных аппаратов.
2. Персонал. Все работники салона очень приятные, с вниманием относятся ко всем пожеланиям. Отдельное спасибо мастеру Светлане к которой я записываюсь каждый раз. Идеальная обработка кутикул, ровное покрытие, помощь в выборе цвета и приятные беседы.
3. Кофе!!! Кофе лучше чем во многих ресторанах.', 'Ich gehe schon seit mehreren Jahren in den Salon IPODO.
- Warum?
1. Sterilität. In Montenegro gibt es kein Gesetz, das die Sterilität von Kosmetiksalons streng kontrolliert, und deshalb wird das oft nicht sonderlich beachtet. IPODO hat einen separaten Raum für die Sterilisation der Materialien mit einer großen Anzahl verschiedener Geräte.
2. Das Personal. Alle Mitarbeiterinnen des Salons sind sehr angenehm und gehen aufmerksam auf jeden Wunsch ein. Besonderen Dank an Svetlana, bei der ich jedes Mal einen Termin nehme. Perfekte Nagelhautbearbeitung, ebenmäßiger Lack, Hilfe bei der Farbauswahl und angenehme Gespräche.
3. Der Kaffee!!! Der Kaffee ist besser als in vielen Restaurants.', 'IPODO salonuna birkaç yıldır gidiyorum.
- Neden?
1. Sterilite. Karadağ\'da güzellik salonlarının steril olmasını sıkı biçimde denetleyen bir yasa yok ve bu yüzden buna çoğu zaman pek dikkat edilmiyor. IPODO\'da malzemelerin sterilizasyonu için çok sayıda farklı cihazın bulunduğu ayrı bir oda var.
2. Ekip. Salondaki tüm çalışanlar çok hoş, her isteğe özenle yaklaşıyorlar. Her seferinde randevu aldığım uzman Svetlana\'ya ayrıca teşekkürler. Kusursuz tırnak eti bakımı, düzgün kaplama, renk seçiminde yardım ve keyifli sohbetler.
3. Kahve!!! Kahve birçok restorandan daha iyi.',
    0, '2024-08-03 00:00:00'),

(@user_alianiari, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ5cjZ1eHBRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_mariya_sigitova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ5czdHZzJ3RRAB',
    5, 'ru', 'Прекрасный специалист- подолог. Отличный сервис и атмосфера',
    'Divan stručnjak - podolog. Odlična usluga i atmosfera', 'Диван стручњак - подолог. Одлична услуга и атмосфера', 'A wonderful specialist - a podiatrist. Excellent service and atmosphere', 'Прекрасный специалист- подолог. Отличный сервис и атмосфера', 'Eine wunderbare Spezialistin - Podologin. Ausgezeichneter Service und Atmosphäre', 'Harika bir uzman - podolog. Mükemmel hizmet ve atmosfer',
    0, '2024-08-03 00:00:00'),

(@user_anri_bolon, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ5dXY3dzZ3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_irina_petrishina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUN0dHF2Z3VRRRAB',
    5, 'ru', 'Мы очень благодарны Анне за ее высокий профессионализм!
У сына в сентябре 2022 появилась проблема вросшего ногтя на большом пальце ноги. Я обратились к подологу в Херцег-Нови, та почистила и прописала ванночки с содой. На следующий день появился гной в уголке, та прописала мазь, от нее гной пошел под ноготь. Пошли к местному хирургу в Дом Здравля - написал мазать йодом,а если не поможет через неделю, то приходить на операцию.
Палец стал весь ужасно облазить от йода и половина ногтя уже безвозвратно утеряна оказалась. Тогда мы решили уже, что пора ехать в Будву.
За первый прием Анна правильно обработала ранку, убрала уже отжитую кожу и обрезала ноготь, сохранив живую половину. Главное, что все было безболезненно для ребенка. А он жутко впечатлительный, но Анне доверился.
Через 2-3 визита ноготь стал прекрасно отростать.
А чего стоит вкусный чай маме с прекрасной подачей сладостей, пока лечит нервы в ожидании сына.
Благодарим Вас за то, что буквально спасли нас! Ваш талант дорогого стоит!
Кстати, педикюр и маникюр в iPODO это особый вид кайфа и любви к себе!',
    'Veoma smo zahvalni Anni na njenom visokom profesionalizmu!
Sin je u septembru 2022. dobio problem s uraslim noktom na velikom prstu noge. Obratili smo se podologu u Herceg Novom, ona je očistila i propisala kupke sa sodom. Sljedećeg dana pojavio se gnoj u uglu, propisala je mast, od koje je gnoj otišao pod nokat. Otišli smo kod lokalnog hirurga u Dom zdravlja - napisao je da mažemo jodom, a ako za nedjelju ne pomogne, da dođemo na operaciju.
Prst je od joda počeo strašno da se guli, a pola nokta je već nepovratno izgubljeno. Tada smo odlučili da je vrijeme da idemo u Budvu.
Na prvom pregledu Anna je pravilno obradila ranu, uklonila već mrtvu kožu i skratila nokat, sačuvavši živu polovinu. Najvažnije je da je sve bilo bezbolno za dijete. A on je strašno osjetljiv, ali Anni se prepustio.
Nakon 2-3 posjete nokat je počeo divno da raste.
A šta reći o ukusnom čaju za mamu, uz divno servirane slatkiše, dok liječi nerve čekajući sina.
Hvala Vam što ste nas bukvalno spasili! Vaš talenat mnogo vrijedi!
Uzgred, pedikir i manikir u iPODO su posebna vrsta uživanja i ljubavi prema sebi!', 'Веома смо захвални Ани на њеном високом професионализму!
Син је у септембру 2022. добио проблем с ураслим ноктом на великом прсту ноге. Обратили смо се подологу у Херцег Новом, она је очистила и прописала купке са содом. Сљедећег дана појавио се гној у углу, прописала је маст, од које је гној отишао под нокат. Отишли смо код локалног хирурга у Дом здравља - написао је да мажемо јодом, а ако за недјељу не помогне, да дођемо на операцију.
Прст је од јода почео страшно да се гули, а пола нокта је већ неповратно изгубљено. Тада смо одлучили да је вријеме да идемо у Будву.
На првом прегледу Ана је правилно обрадила рану, уклонила већ мртву кожу и скратила нокат, сачувавши живу половину. Најважније је да је све било безболно за дијете. А он је страшно осјетљив, али Ани се препустио.
Након 2-3 посјете нокат је почео дивно да расте.
А шта рећи о укусном чају за маму, уз дивно сервиране слаткише, док лијечи нерве чекајући сина.
Хвала Вам што сте нас буквално спасили! Ваш таленат много вриједи!
Узгред, педикир и маникир у iPODO су посебна врста уживања и љубави према себи!', 'We are so grateful to Anna for her high professionalism!
In September 2022 my son had a problem with an ingrown toenail on his big toe. We went to a podiatrist in Herceg Novi, she cleaned it out and prescribed baking soda foot baths. The next day pus appeared in the corner, she prescribed an ointment, and because of it the pus went under the nail. We went to the local surgeon at the Dom Zdravlja - he wrote to dab it with iodine, and if it didn\'t help within a week, to come in for surgery.
The whole toe started peeling horribly from the iodine and half the nail turned out to be lost for good. That\'s when we decided it was time to go to Budva.
In the first appointment Anna treated the wound properly, removed the dead skin and trimmed the nail, saving the living half. The main thing is that it was all painless for the child. And he is terribly sensitive, but he trusted Anna.
After 2-3 visits the nail started growing back beautifully.
And then there\'s the delicious tea for mum with the lovely presentation of sweets, while she calms her nerves waiting for her son.
Thank you for literally saving us! Your talent is worth a great deal!
By the way, the pedicure and manicure at iPODO are a special kind of bliss and self-love!', 'Мы очень благодарны Анне за ее высокий профессионализм!
У сына в сентябре 2022 появилась проблема вросшего ногтя на большом пальце ноги. Я обратились к подологу в Херцег-Нови, та почистила и прописала ванночки с содой. На следующий день появился гной в уголке, та прописала мазь, от нее гной пошел под ноготь. Пошли к местному хирургу в Дом Здравля - написал мазать йодом,а если не поможет через неделю, то приходить на операцию.
Палец стал весь ужасно облазить от йода и половина ногтя уже безвозвратно утеряна оказалась. Тогда мы решили уже, что пора ехать в Будву.
За первый прием Анна правильно обработала ранку, убрала уже отжитую кожу и обрезала ноготь, сохранив живую половину. Главное, что все было безболезненно для ребенка. А он жутко впечатлительный, но Анне доверился.
Через 2-3 визита ноготь стал прекрасно отростать.
А чего стоит вкусный чай маме с прекрасной подачей сладостей, пока лечит нервы в ожидании сына.
Благодарим Вас за то, что буквально спасли нас! Ваш талант дорогого стоит!
Кстати, педикюр и маникюр в iPODO это особый вид кайфа и любви к себе!', 'Wir sind Anna für ihre hohe Professionalität sehr dankbar!
Mein Sohn hatte im September 2022 ein Problem mit einem eingewachsenen Nagel am großen Zeh. Wir gingen zu einer Podologin in Herceg Novi, sie reinigte ihn und verordnete Fußbäder mit Soda. Am nächsten Tag bildete sich Eiter in der Ecke, sie verschrieb eine Salbe, wodurch der Eiter unter den Nagel geriet. Wir gingen zum örtlichen Chirurgen im Dom Zdravlja - er schrieb, wir sollten den Zeh mit Jod einpinseln, und wenn es in einer Woche nicht hilft, zur Operation kommen.
Der ganze Zeh begann durch das Jod schrecklich zu schälen und die Hälfte des Nagels war schon unwiederbringlich verloren. Da entschieden wir, dass es Zeit ist, nach Budva zu fahren.
Beim ersten Termin versorgte Anna die Wunde richtig, entfernte die abgestorbene Haut und kürzte den Nagel, wobei sie die lebende Hälfte erhielt. Die Hauptsache: Für das Kind war alles schmerzlos. Und er ist furchtbar empfindlich, aber Anna hat er vertraut.
Nach 2-3 Besuchen fing der Nagel an wunderbar nachzuwachsen.
Und dann noch der leckere Tee für die Mama mit den wunderschön servierten Süßigkeiten, während sie beim Warten auf den Sohn ihre Nerven beruhigt.
Danke, dass Sie uns buchstäblich gerettet haben! Ihr Talent ist viel wert!
Übrigens sind Pediküre und Maniküre bei iPODO eine besondere Art von Genuss und Selbstliebe!', 'Anna\'ya yüksek profesyonelliği için çok minnettarız!
Oğlumun Eylül 2022\'de ayak başparmağında batık tırnak sorunu çıktı. Herceg Novi\'de bir podologa gittik, o temizledi ve karbonatlı ayak banyosu önerdi. Ertesi gün köşede iltihap oluştu, merhem yazdı, o merhemden iltihap tırnağın altına gitti. Dom Zdravlja\'daki yerel cerraha gittik - tentürdiyot sürmemizi, bir hafta içinde geçmezse ameliyata gelmemizi yazdı.
Parmak tentürdiyottan korkunç şekilde soyulmaya başladı ve tırnağın yarısı geri dönüşü olmayacak şekilde kaybolmuştu. İşte o zaman Budva\'ya gitme vaktinin geldiğine karar verdik.
İlk randevuda Anna yarayı doğru şekilde pansuman etti, ölü deriyi aldı ve canlı yarısını koruyarak tırnağı kesti. En önemlisi, her şeyin çocuk için ağrısız olmasıydı. Kendisi de aşırı hassas biri, ama Anna\'ya güvendi.
2-3 ziyaretten sonra tırnak harika şekilde uzamaya başladı.
Bir de oğlunu beklerken sinirlerini yatıştıran anneye sunulan o nefis çay ve harika servis edilen tatlılar var.
Bizi kelimenin tam anlamıyla kurtardığınız için teşekkür ederiz! Yeteneğiniz çok değerli!
Bu arada, iPODO\'daki pedikür ve manikür ayrı bir keyif ve kendini sevme biçimi!',
    0, '2024-08-03 00:00:00'),

(@user_svetlana_ovchinnikova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUMxckxMSmdnRRAB',
    5, 'ru', 'Мы обращались в «Подологический центр» к подологу Анюте уже несколько раз и каждый раз оставались впечатлены ее профессионализмом.
Анюта всегда готова ответить на все вопросы и разъяснить этапы предстоящей процедуры, что очень убеждает в ее компетентности и профессионализме.
Однако, стоит заметить, что цены в этой клинике кажутся немного высокими. Тем не менее, учитывая высокий уровень сервиса и качество предоставляемых услуг, мы считаем, что они вполне справедливы.
В целом, без колебаний рекомендуем услуги данной клиники всем. И несмотря на цены, при необходимости обратимся вновь за высококачественными услугами.',
    'U „Podološki centar" kod podologa Anjute dolazili smo već nekoliko puta i svaki put nas je impresionirao njen profesionalizam.
Anjuta je uvijek spremna da odgovori na sva pitanja i da objasni faze procedure koja slijedi, što veoma uvjerava u njenu kompetentnost i profesionalizam.
Međutim, treba primijetiti da cijene u ovoj klinici izgledaju malo visoko. Ipak, uzimajući u obzir visok nivo usluge i kvalitet onoga što nude, smatramo da su potpuno opravdane.
Uglavnom, bez oklijevanja preporučujemo usluge ove klinike svima. I bez obzira na cijene, ako bude potrebno, ponovo ćemo se obratiti za visokokvalitetne usluge.', 'У „Подолошки центар" код подолога Ањуте долазили смо већ неколико пута и сваки пут нас је импресионирао њен професионализам.
Ањута је увијек спремна да одговори на сва питања и да објасни фазе процедуре која слиједи, што веома увјерава у њену компетентност и професионализам.
Међутим, треба примијетити да цијене у овој клиници изгледају мало високо. Ипак, узимајући у обзир висок ниво услуге и квалитет онога што нуде, сматрамо да су потпуно оправдане.
Углавном, без оклијевања препоручујемо услуге ове клинике свима. И без обзира на цијене, ако буде потребно, поново ћемо се обратити за висококвалитетне услуге.', 'We have been to the "Podology Centre" to see the podiatrist Anjuta several times now and every time we\'ve been impressed by her professionalism.
Anjuta is always ready to answer all your questions and explain the stages of the upcoming procedure, which is very convincing of her competence and professionalism.
However, it should be noted that the prices at this clinic seem a bit high. Still, given the high level of service and the quality of what they offer, we think they are perfectly fair.
Overall, we recommend this clinic\'s services to everyone without hesitation. And despite the prices, if the need arises we will come back for high-quality service.', 'Мы обращались в «Подологический центр» к подологу Анюте уже несколько раз и каждый раз оставались впечатлены ее профессионализмом.
Анюта всегда готова ответить на все вопросы и разъяснить этапы предстоящей процедуры, что очень убеждает в ее компетентности и профессионализме.
Однако, стоит заметить, что цены в этой клинике кажутся немного высокими. Тем не менее, учитывая высокий уровень сервиса и качество предоставляемых услуг, мы считаем, что они вполне справедливы.
В целом, без колебаний рекомендуем услуги данной клиники всем. И несмотря на цены, при необходимости обратимся вновь за высококачественными услугами.', 'Wir waren schon mehrmals im "Podologiezentrum" bei der Podologin Anjuta und jedes Mal waren wir von ihrer Professionalität beeindruckt.
Anjuta ist immer bereit, alle Fragen zu beantworten und die Schritte der bevorstehenden Behandlung zu erklären, was von ihrer Kompetenz und Professionalität sehr überzeugt.
Allerdings muss man anmerken, dass die Preise in dieser Klinik etwas hoch erscheinen. Dennoch halten wir sie angesichts des hohen Serviceniveaus und der Qualität der Leistungen für durchaus angemessen.
Insgesamt empfehlen wir die Leistungen dieser Klinik ohne Zögern allen weiter. Und trotz der Preise werden wir bei Bedarf wieder für hochwertige Leistungen hierher kommen.', '"Podoloji merkezi"ne podolog Anjuta\'ya birkaç kez gittik ve her seferinde profesyonelliği bizi etkiledi.
Anjuta her zaman tüm soruları yanıtlamaya ve yapılacak işlemin aşamalarını anlatmaya hazır, bu da yetkinliği ve profesyonelliği konusunda insanı çok ikna ediyor.
Ancak bu klinikteki fiyatların biraz yüksek göründüğünü belirtmek gerek. Yine de yüksek hizmet düzeyi ve sunulan hizmetlerin kalitesi göz önüne alındığında bunların gayet adil olduğunu düşünüyoruz.
Genel olarak bu kliniğin hizmetlerini herkese tereddütsüz tavsiye ediyoruz. Fiyatlara rağmen, gerekirse yine yüksek kaliteli hizmet için buraya geleceğiz.',
    0, '2024-08-03 00:00:00'),

(@user_nikita_bondarenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUMxNkxhRlpREAE',
    5, 'ru', 'Хороший сервис, мастер Светлана просто умничка)',
    'Dobra usluga, majstorica Svetlana je pravo zlato)', 'Добра услуга, мајсторица Светлана је право злато)', 'Good service, Svetlana is just a gem)', 'Хороший сервис, мастер Светлана просто умничка)', 'Guter Service, Svetlana ist einfach ein Schatz)', 'Hizmet güzel, uzman Svetlana tam bir cevher)',
    0, '2024-08-03 00:00:00'),

(@user_nadezhda_gordeeva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSURWbzRuclFBEAE',
    5, 'ru', 'Однозначно лучший салон в Черногории.

Такого сервиса нет на всем побережье. Забота о клиенте во всём: от бахилатора на входе до массажного кресла и крема для рук в уборной. Идеально и главное быстро делают маникюр и педикюр. Огромное разнообразие покрытий. Однажды мне сделали аккуратный маникюр со снятием, покрытием и выравниванием за 55 минут. Нигде такого не встречала!  Подолог Анюта - отдельный восторг! Не буду говорить о ее профессионализме: многочисленные дипломы в ее кабинете говорят сами за себя. Скажу, что с ней просто по-человечески приятно общаться, как и со всеми мастерами в салоне.
Придя сюда один раз, больше не захочется «изменять» этому месту.',
    'Bez ikakve sumnje najbolji salon u Crnoj Gori.

Takve usluge nema na cijelom primorju. Briga o klijentu u svemu: od aparata za navlake za obuću na ulazu do masažne fotelje i krema za ruke u toaletu. Manikir i pedikir rade savršeno i, što je najvažnije, brzo. Ogroman izbor lakova. Jednom su mi za 55 minuta uradili uredan manikir sa skidanjem, lakiranjem i izravnavanjem. Nigdje nisam našla nešto takvo! Podolog Anjuta - posebno oduševljenje! Neću govoriti o njenom profesionalizmu: brojne diplome u njenom kabinetu govore same za sebe. Reći ću da je s njom jednostavno prijatno razgovarati, kao i sa svim majstoricama u salonu.
Kad jednom dođete ovdje, više nećete htjeti da „varate" ovo mjesto.', 'Без икакве сумње најбољи салон у Црној Гори.

Такве услуге нема на цијелом приморју. Брига о клијенту у свему: од апарата за навлаке за обућу на улазу до масажне фотеље и крема за руке у тоалету. Маникир и педикир раде савршено и, што је најважније, брзо. Огроман избор лакова. Једном су ми за 55 минута урадили уредан маникир са скидањем, лакирањем и изравнавањем. Нигдје нисам нашла нешто такво! Подолог Ањута - посебно одушевљење! Нећу говорити о њеном професионализму: бројне дипломе у њеном кабинету говоре саме за себе. Рећи ћу да је с њом једноставно пријатно разговарати, као и са свим мајсторицама у салону.
Кад једном дођете овдје, више нећете хтјети да „варате" ово мјесто.', 'Hands down the best salon in Montenegro.

There is no service like this anywhere on the coast. Care for the client in everything: from the shoe-cover dispenser at the entrance to the massage chair and the hand cream in the restroom. They do manicures and pedicures perfectly and, most importantly, fast. A huge variety of coatings. Once they did a neat manicure for me with removal, coating and levelling in 55 minutes. I\'ve never come across that anywhere! The podiatrist Anjuta is a delight all of her own! I won\'t go on about her professionalism: the many diplomas in her office speak for themselves. I\'ll just say that she\'s genuinely lovely to talk to, as are all the technicians in the salon.
Once you come here, you\'ll never want to "cheat" on this place again.', 'Однозначно лучший салон в Черногории.

Такого сервиса нет на всем побережье. Забота о клиенте во всём: от бахилатора на входе до массажного кресла и крема для рук в уборной. Идеально и главное быстро делают маникюр и педикюр. Огромное разнообразие покрытий. Однажды мне сделали аккуратный маникюр со снятием, покрытием и выравниванием за 55 минут. Нигде такого не встречала!  Подолог Анюта - отдельный восторг! Не буду говорить о ее профессионализме: многочисленные дипломы в ее кабинете говорят сами за себя. Скажу, что с ней просто по-человечески приятно общаться, как и со всеми мастерами в салоне.
Придя сюда один раз, больше не захочется «изменять» этому месту.', 'Ohne Zweifel der beste Salon in Montenegro.

So einen Service gibt es an der ganzen Küste nicht. Fürsorge für den Kunden in allem: vom Überschuh-Automaten am Eingang bis zum Massagesessel und der Handcreme in der Toilette. Maniküre und Pediküre machen sie perfekt und, was am wichtigsten ist, schnell. Eine riesige Auswahl an Lacken. Einmal haben sie mir in 55 Minuten eine saubere Maniküre mit Entfernen, Lackieren und Auffüllen gemacht. So etwas habe ich nirgends erlebt! Die Podologin Anjuta ist eine Begeisterung für sich! Über ihre Professionalität will ich gar nicht reden: die zahlreichen Diplome in ihrem Behandlungsraum sprechen für sich. Ich sage nur, dass es einfach menschlich angenehm ist, sich mit ihr zu unterhalten, wie mit allen Mitarbeiterinnen im Salon.
Wenn man einmal hier war, will man diesem Ort nicht mehr "fremdgehen".', 'Karadağ\'daki açık ara en iyi salon.

Böyle bir hizmet tüm kıyı boyunca yok. Her şeyde müşteriye özen: girişteki galoş makinesinden tutun da masaj koltuğuna ve tuvaletteki el kremine kadar. Manikür ve pedikürü kusursuz ve en önemlisi hızlı yapıyorlar. Çok geniş kaplama çeşidi. Bir keresinde bana 55 dakikada sökümüyle, kaplamasıyla ve dolgusuyla tertemiz bir manikür yaptılar. Hiçbir yerde böylesini görmedim! Podolog Anjuta ise başlı başına bir hayranlık konusu! Profesyonelliğinden hiç bahsetmiyorum: odasındaki sayısız diploma kendi adına konuşuyor. Şunu söyleyeyim, onunla sohbet etmek insanca çok keyifli, salondaki tüm uzmanlarla olduğu gibi.
Buraya bir kez geldikten sonra artık bu mekâna "ihanet" etmek istemiyorsunuz.',
    0, '2024-08-03 00:00:00'),

(@user_pastel_de_nata, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURWdy1YQXlnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 00:00:00'),

(@user_christina_tkach, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURseGNqdTl3RRAB',
    5, 'ru', 'Идеальные маникюр, педикюр и покрытие - ради этого стоит потратить время на дорогу из другого города :) И по-настоящему прекрасный сервис - каждый поход в салон прямо в радость. Очень советую!',
    'Savršen manikir, pedikir i lakiranje - zbog toga se vrijedi potruditi i doći iz drugog grada :) I zaista divna usluga - svaki odlazak u salon je pravo zadovoljstvo. Toplo preporučujem!', 'Савршен маникир, педикир и лакирање - због тога се вриједи потрудити и доћи из другог града :) И заиста дивна услуга - сваки одлазак у салон је право задовољство. Топло препоручујем!', 'Perfect manicure, pedicure and coating - it\'s worth spending the time travelling from another town for this :) And truly wonderful service - every trip to the salon is a real joy. Highly recommend!', 'Идеальные маникюр, педикюр и покрытие - ради этого стоит потратить время на дорогу из другого города :) И по-настоящему прекрасный сервис - каждый поход в салон прямо в радость. Очень советую!', 'Perfekte Maniküre, Pediküre und Lackierung - dafür lohnt es sich, die Fahrt aus einer anderen Stadt in Kauf zu nehmen :) Und wirklich herrlicher Service - jeder Besuch im Salon ist eine echte Freude. Sehr empfehlenswert!', 'Kusursuz manikür, pedikür ve kaplama - bunun için başka bir şehirden yol tepmeye değer :) Ve gerçekten harika bir hizmet - salona her gidiş tam bir keyif. Şiddetle tavsiye ederim!',
    0, '2024-08-03 00:00:00'),

(@user_tatsiana_mileshko, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNsNV83OS1BRRAB',
    5, 'ru', 'Посещаю салон IPODO и в частности подолога Анюту уже второй год и могу сказать это единственный подолог от которого я точно вижу результат. Качество, атмосфера и персонал на высшем уровне!!!',
    'U salon IPODO, i konkretno kod podologa Anjute, idem već drugu godinu i mogu reći da je to jedini podolog kod kojeg zaista vidim rezultat. Kvalitet, atmosfera i osoblje na najvišem nivou!!!', 'У салон IPODO, и конкретно код подолога Ањуте, идем већ другу годину и могу рећи да је то једини подолог код којег заиста видим резултат. Квалитет, атмосфера и особље на највишем нивоу!!!', 'I\'ve been going to the IPODO salon, and to the podiatrist Anjuta in particular, for the second year now and I can say she\'s the only podiatrist with whom I definitely see results. Quality, atmosphere and staff are top notch!!!', 'Посещаю салон IPODO и в частности подолога Анюту уже второй год и могу сказать это единственный подолог от которого я точно вижу результат. Качество, атмосфера и персонал на высшем уровне!!!', 'Ich gehe schon das zweite Jahr in den Salon IPODO und speziell zur Podologin Anjuta und kann sagen: Sie ist die einzige Podologin, bei der ich wirklich ein Ergebnis sehe. Qualität, Atmosphäre und Personal auf höchstem Niveau!!!', 'IPODO salonuna ve özellikle podolog Anjuta\'ya ikinci yıldır gidiyorum ve şunu söyleyebilirim: sonucunu gerçekten gördüğüm tek podolog o. Kalite, atmosfer ve ekip en üst düzeyde!!!',
    0, '2024-08-03 00:00:00'),

(@user_elena_klinova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNsNFkzN1J3EAE',
    5, 'ru', 'Были у подолога в центре, он объяснил причину проблемы и назначил лечение, которое помогло.',
    'Bili smo kod podologa u centru, objasnio je uzrok problema i propisao liječenje koje je pomoglo.', 'Били смо код подолога у центру, објаснио је узрок проблема и прописао лијечење које је помогло.', 'We saw the podiatrist at the centre, he explained the cause of the problem and prescribed treatment that helped.', 'Были у подолога в центре, он объяснил причину проблемы и назначил лечение, которое помогло.', 'Wir waren beim Podologen im Zentrum, er hat die Ursache des Problems erklärt und eine Behandlung verordnet, die geholfen hat.', 'Merkezdeki podologa gittik, sorunun nedenini açıkladı ve işe yarayan bir tedavi verdi.',
    0, '2024-08-03 00:00:00'),

(@user_anastasiya_evdokimovich, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNscnNDQ0RnEAE',
    2, 'ru', 'Была разочарована походом к подологу Анне. Прием занял 15 минут и отдала я 200 евро, из которых сам визит стоил 30 евро. Остальное я потратила на средства, которые самые «эффективные» для моей проблемы и сушилки для обуви за 50 евро. Данные сушилки стоят в интернете 10 евро, что-то уж очень большая накрутка выходит в салоне.
То же самое и с Израильскими средствами для ног. Накрутка в 2-3 раза.
Я очень расстроена, что повелась на этот маркетинг, сначала нужно было перепроверить цены и состав продуктов.
Было чувство, что на мне просто сделали деньги. А обойтись я могла одним аптечным кремом из большого списка рекомендуемых средств.
Персонал дружелюбный, салон чистый.
За это и ставлю по звезде.',
    'Bila sam razočarana odlaskom kod podologa Anne. Pregled je trajao 15 minuta, a ostavila sam 200 evra, od kojih je sama posjeta koštala 30 evra. Ostalo sam potrošila na preparate koji su najviše „efikasni" za moj problem i na sušilicu za obuću od 50 evra. Ta sušilica na internetu košta 10 evra, ispada da je marža u salonu previše velika.
Isto je i s izraelskim preparatima za noge. Marža 2-3 puta.
Veoma sam ljuta na sebe što sam pala na taj marketing, prvo je trebalo provjeriti cijene i sastav proizvoda.
Imala sam osjećaj da su na meni samo zaradili. A mogla sam da se izvučem s jednom kremom iz apoteke sa velikog spiska preporučenih preparata.
Osoblje je ljubazno, salon je čist.
Za to i dajem po jednu zvijezdu.', 'Била сам разочарана одласком код подолога Ане. Преглед је трајао 15 минута, а оставила сам 200 евра, од којих је сама посјета коштала 30 евра. Остало сам потрошила на препарате који су највише „ефикасни" за мој проблем и на сушилицу за обућу од 50 евра. Та сушилица на интернету кошта 10 евра, испада да је маржа у салону превише велика.
Исто је и с израелским препаратима за ноге. Маржа 2-3 пута.
Веома сам љута на себе што сам пала на тај маркетинг, прво је требало провјерити цијене и састав производа.
Имала сам осјећај да су на мени само зарадили. А могла сам да се извучем с једном кремом из апотеке са великог списка препоручених препарата.
Особље је љубазно, салон је чист.
За то и дајем по једну звијезду.', 'I was disappointed by my visit to the podiatrist Anna. The appointment took 15 minutes and I handed over 200 euros, of which the visit itself cost 30 euros. The rest I spent on products that are the most "effective" for my problem and on a shoe dryer for 50 euros. That dryer costs 10 euros online, so the markup in the salon turns out to be way too big.
Same story with the Israeli foot products. A 2-3x markup.
I\'m very upset that I fell for this marketing, I should have double-checked the prices and the ingredients first.
It felt like they simply made money off me. And I could have got by with one pharmacy cream from that long list of recommended products.
The staff are friendly, the salon is clean.
That\'s what I\'m giving one star each for.', 'Была разочарована походом к подологу Анне. Прием занял 15 минут и отдала я 200 евро, из которых сам визит стоил 30 евро. Остальное я потратила на средства, которые самые «эффективные» для моей проблемы и сушилки для обуви за 50 евро. Данные сушилки стоят в интернете 10 евро, что-то уж очень большая накрутка выходит в салоне.
То же самое и с Израильскими средствами для ног. Накрутка в 2-3 раза.
Я очень расстроена, что повелась на этот маркетинг, сначала нужно было перепроверить цены и состав продуктов.
Было чувство, что на мне просто сделали деньги. А обойтись я могла одним аптечным кремом из большого списка рекомендуемых средств.
Персонал дружелюбный, салон чистый.
За это и ставлю по звезде.', 'Ich war vom Besuch bei der Podologin Anna enttäuscht. Der Termin dauerte 15 Minuten und ich habe 200 Euro dagelassen, davon kostete der Besuch selbst 30 Euro. Den Rest habe ich für Mittel ausgegeben, die für mein Problem die "wirksamsten" sind, und für einen Schuhtrockner für 50 Euro. Dieser Trockner kostet im Internet 10 Euro, der Aufschlag im Salon ist also wirklich viel zu hoch.
Genauso ist es mit den israelischen Fußpflegemitteln. Aufschlag um das 2- bis 3-Fache.
Es ärgert mich sehr, dass ich auf dieses Marketing hereingefallen bin, ich hätte zuerst die Preise und die Zusammensetzung der Produkte überprüfen sollen.
Ich hatte das Gefühl, dass man an mir einfach Geld verdient hat. Dabei hätte mir eine einzige Creme aus der Apotheke von der langen Liste empfohlener Mittel gereicht.
Das Personal ist freundlich, der Salon ist sauber.
Dafür gebe ich jeweils einen Stern.', 'Podolog Anna\'ya gitmekten hayal kırıklığına uğradım. Muayene 15 dakika sürdü ve 200 euro bıraktım, bunun sadece 30 eurosu ziyaretin kendisiydi. Kalanını benim sorunum için en "etkili" olan ürünlere ve 50 euroluk bir ayakkabı kurutucusuna harcadım. Bu kurutucu internette 10 euro, salonda fiyat farkı fazlasıyla büyük görünüyor.
İsrail menşeli ayak ürünlerinde de durum aynı. 2-3 kat fark.
Bu pazarlamaya kandığım için çok üzgünüm, önce fiyatları ve ürünlerin içeriğini kontrol etmem gerekirdi.
Üzerimden para kazandıkları hissine kapıldım. Oysa önerilen o uzun ürün listesinden eczaneden alınacak tek bir kremle idare edebilirdim.
Ekip güler yüzlü, salon temiz.
Bunlar için birer yıldız veriyorum.',
    0, '2024-08-03 00:00:00'),

(@user_vasilisa_karpova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNseU55UmN3EAE',
    5, 'ru', 'Для нас обращение в центр - это спасение! После первого же визита к подологу мы забыли, что  такое, когда болит пятка. Эффект от процедуры обработки стопы моментальный! Никаких противопоказаний для занятий спортом! Рекомендуем всем, кто еще продолжает лечиться самостоятельно. Спасибо сотрудникам за согласование времени визита, доктору отдельное спасибо за мармелад для ребенка, доброжелательность и безграничный позитив!',
    'Za nas je dolazak u centar pravi spas! Već poslije prve posjete podologu zaboravili smo kako je to kad boli peta. Efekat tretmana stopala je momentalan! Nikakvih kontraindikacija za sport! Preporučujemo svima koji se još uvijek liječe sami. Hvala zaposlenima na usklađivanju termina, a doktorki posebno hvala na bombonama za dijete, na ljubaznosti i bezgraničnom pozitivnom stavu!', 'За нас је долазак у центар прави спас! Већ послије прве посјете подологу заборавили смо како је то кад боли пета. Ефекат третмана стопала је моменталан! Никаквих контраиндикација за спорт! Препоручујемо свима који се још увијек лијече сами. Хвала запосленима на усклађивању термина, а докторки посебно хвала на бомбонама за дијете, на љубазности и безграничном позитивном ставу!', 'For us, coming to this centre was a lifesaver! After the very first visit to the podiatrist we forgot what a sore heel even feels like. The effect of the foot treatment is instant! No restrictions on doing sports at all! We recommend it to everyone who is still trying to treat themselves at home. Thank you to the staff for fitting us into the schedule, and special thanks to the doctor for the fruit jellies for our child, for her kindness and boundless positivity!', 'Для нас обращение в центр - это спасение! После первого же визита к подологу мы забыли, что  такое, когда болит пятка. Эффект от процедуры обработки стопы моментальный! Никаких противопоказаний для занятий спортом! Рекомендуем всем, кто еще продолжает лечиться самостоятельно. Спасибо сотрудникам за согласование времени визита, доктору отдельное спасибо за мармелад для ребенка, доброжелательность и безграничный позитив!', 'Für uns war der Besuch in diesem Zentrum die Rettung! Schon nach dem ersten Besuch bei der Podologin haben wir vergessen, wie es ist, wenn die Ferse schmerzt. Die Wirkung der Fußbehandlung ist sofort da! Keinerlei Einschränkungen beim Sport! Wir empfehlen es allen, die sich noch selbst behandeln. Danke an die Mitarbeiterinnen für die Terminabstimmung, und der Ärztin besonderen Dank für das Fruchtgummi für das Kind, für ihre Freundlichkeit und ihre grenzenlose positive Energie!', 'Bizim için bu merkeze gitmek tam bir kurtuluş oldu! Podologa ilk gidişimizden sonra topuk ağrısının ne olduğunu unuttuk. Ayak bakımı işleminin etkisi anında! Spor yapmaya hiçbir engel yok! Hâlâ kendi kendini tedavi etmeye çalışan herkese tavsiye ediyoruz. Randevu saatini ayarladıkları için çalışanlara, çocuğa verdiği marmelat, güler yüzü ve sınırsız pozitifliği için de doktora ayrıca teşekkürler!',
    0, '2024-08-03 00:00:00'),

(@user_irina_shershneva, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURGNkk3cHpnRRAB',
    5, 'ru', 'Добрый день.Полтора года я с большим удовольствием посещаю этот прекрасное место ,где работают очень квалифицированные специалисты!Могу так точно говорить,потому что пришла с большими проблемами и болями на ногтях ног.Сразу была оказана квалифицированная  на высшем  уровне помощь.Невероятная забота о клиентах,внимание каждому,всегда теплый прием.Цены соответствуют качеству как маникюра так и педекюра,полная ответственность за проделанную работу.Уютно,красиво,чистота и порядок во всем.Хочеться выразить огромную благодарность и пожелать только успехов руководителю этой прекрасной компании и всему замечательному коллективу!Спасибо за ваш труд!',
    'Dobar dan. Godinu i po s velikim zadovoljstvom dolazim u ovo divno mjesto, gdje rade veoma kvalifikovani stručnjaci! Mogu to reći sa sigurnošću, jer sam došla s velikim problemima i bolovima na noktima nogu. Odmah mi je pružena kvalifikovana pomoć na najvišem nivou. Nevjerovatna briga o klijentima, pažnja prema svakome, uvijek topao prijem. Cijene odgovaraju kvalitetu i manikira i pedikira, potpuna odgovornost za obavljeni posao. Prijatno, lijepo, čistoća i red u svemu. Želim da izrazim ogromnu zahvalnost i da poželim samo uspjeh rukovoditeljki ove divne firme i cijelom sjajnom kolektivu! Hvala vam na vašem radu!', 'Добар дан. Годину и по с великим задовољством долазим у ово дивно мјесто, гдје раде веома квалификовани стручњаци! Могу то рећи са сигурношћу, јер сам дошла с великим проблемима и боловима на ноктима ногу. Одмах ми је пружена квалификована помоћ на највишем нивоу. Невјероватна брига о клијентима, пажња према свакоме, увијек топао пријем. Цијене одговарају квалитету и маникира и педикира, потпуна одговорност за обављени посао. Пријатно, лијепо, чистоћа и ред у свему. Желим да изразим огромну захвалност и да пожелим само успјех руководитељки ове дивне фирме и цијелом сјајном колективу! Хвала вам на вашем раду!', 'Good afternoon. For a year and a half I have been coming to this wonderful place with great pleasure, where very well-qualified specialists work! I can say that with confidence, because I came in with serious problems and pain in my toenails. I was given qualified, top-level help right away. Incredible care for the clients, attention to everyone, always a warm welcome. The prices match the quality of both the manicure and the pedicure, and they take full responsibility for the work done. Cosy, beautiful, cleanliness and order in everything. I want to express my enormous gratitude and wish nothing but success to the manager of this wonderful company and to the whole marvellous team! Thank you for your work!', 'Добрый день.Полтора года я с большим удовольствием посещаю этот прекрасное место ,где работают очень квалифицированные специалисты!Могу так точно говорить,потому что пришла с большими проблемами и болями на ногтях ног.Сразу была оказана квалифицированная  на высшем  уровне помощь.Невероятная забота о клиентах,внимание каждому,всегда теплый прием.Цены соответствуют качеству как маникюра так и педекюра,полная ответственность за проделанную работу.Уютно,красиво,чистота и порядок во всем.Хочеться выразить огромную благодарность и пожелать только успехов руководителю этой прекрасной компании и всему замечательному коллективу!Спасибо за ваш труд!', 'Guten Tag. Seit anderthalb Jahren komme ich mit großem Vergnügen an diesen wunderbaren Ort, an dem sehr qualifizierte Fachkräfte arbeiten! Ich kann das mit Bestimmtheit sagen, denn ich kam mit großen Problemen und Schmerzen an den Fußnägeln. Es wurde mir sofort qualifizierte Hilfe auf höchstem Niveau geleistet. Unglaubliche Fürsorge für die Kundinnen, Aufmerksamkeit für jede Einzelne, immer ein herzlicher Empfang. Die Preise entsprechen der Qualität, sowohl bei der Maniküre als auch bei der Pediküre, volle Verantwortung für die geleistete Arbeit. Gemütlich, schön, Sauberkeit und Ordnung in allem. Ich möchte meinen riesigen Dank aussprechen und der Leiterin dieses wunderbaren Unternehmens und dem ganzen großartigen Team nur Erfolg wünschen! Danke für Ihre Arbeit!', 'İyi günler. Bir buçuk yıldır çok nitelikli uzmanların çalıştığı bu harika yere büyük bir keyifle geliyorum! Bunu böyle kesin söyleyebiliyorum, çünkü ayak tırnaklarımdaki büyük sorunlar ve ağrılarla gelmiştim. Hemen en üst düzeyde nitelikli bir yardım aldım. Müşterilere inanılmaz bir özen, herkese ilgi, her zaman sıcak bir karşılama. Fiyatlar hem manikürün hem pedikürün kalitesine uygun, yapılan işin tam sorumluluğunu alıyorlar. Rahat, güzel, her şeyde temizlik ve düzen. Bu harika şirketin yöneticisine ve tüm o muhteşem ekibe kocaman bir teşekkür etmek ve sadece başarı dilemek istiyorum! Emeğiniz için teşekkürler!',
    0, '2024-08-03 00:00:00'),

(@user_merrilee_sjolander, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ1NXIyWklnEAE',
    5, 'en', 'Was able to book a time quickly and easily through messaging.   Wonderful pedicure.',
    'Uspjela sam brzo i lako da zakažem termin preko poruka. Divan pedikir.', 'Успјела сам брзо и лако да закажем термин преко порука. Диван педикир.', 'Was able to book a time quickly and easily through messaging.   Wonderful pedicure.', 'Удалось быстро и легко записаться через сообщения. Прекрасный педикюр.', 'Konnte schnell und einfach per Nachricht einen Termin buchen. Wunderbare Pediküre.', 'Mesajla hızlı ve kolayca randevu alabildim. Harika bir pedikür.',
    0, '2024-08-03 00:00:00'),

(@user_elisheva_g, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUM1d3ByX1JREAE',
    5, 'ru', 'На этапе записи вели прекрасную переписку, старались ответить на все вопросы и пойти навстречу:)
Администраторша на месте попалась очень мрачная, хуже чем в обычном салоне красоты, лениво выполняла обязанности и  даже не предложила чай или воды😕
Врач очень приятная и понимающая женщина, я была рада сходить к ней, я нашла ответы на интересующие меня вопросы ☺️',
    'U fazi zakazivanja prepiska je bila divna, trudili su se da odgovore na sva pitanja i da izađu u susret :)
Ali administratorka na mjestu je bila veoma mrzovoljna, gora nego u običnom kozmetičkom salonu, lijeno je obavljala svoj posao i nije mi ponudila ni čaj ni vodu 😕
Doktorka je veoma prijatna žena koja razumije, bilo mi je drago što sam otišla kod nje, dobila sam odgovore na pitanja koja su me zanimala ☺️', 'У фази заказивања преписка је била дивна, трудили су се да одговоре на сва питања и да изађу у сусрет :)
Али администраторка на мјесту је била веома мрзовољна, гора него у обичном козметичком салону, лијено је обављала свој посао и није ми понудила ни чај ни воду 😕
Докторка је веома пријатна жена која разумије, било ми је драго што сам отишла код ње, добила сам одговоре на питања која су ме занимала ☺️', 'At the booking stage the messaging was lovely, they tried to answer all my questions and accommodate me :)
But the receptionist I got there was very gloomy, worse than in an ordinary beauty salon, she did her job lazily and didn\'t even offer me tea or water 😕
The doctor is a very pleasant and understanding woman, I was glad I went to see her, I got answers to the questions I had ☺️', 'На этапе записи вели прекрасную переписку, старались ответить на все вопросы и пойти навстречу:)
Администраторша на месте попалась очень мрачная, хуже чем в обычном салоне красоты, лениво выполняла обязанности и  даже не предложила чай или воды😕
Врач очень приятная и понимающая женщина, я была рада сходить к ней, я нашла ответы на интересующие меня вопросы ☺️', 'Bei der Terminvereinbarung war der Schriftwechsel wunderbar, sie haben versucht, alle Fragen zu beantworten und mir entgegenzukommen :)
Die Empfangsdame vor Ort war dagegen sehr mürrisch, schlimmer als in einem gewöhnlichen Kosmetiksalon, hat ihre Aufgaben lustlos erledigt und mir nicht einmal Tee oder Wasser angeboten 😕
Die Ärztin ist eine sehr angenehme und verständnisvolle Frau, ich war froh, zu ihr gegangen zu sein, ich habe Antworten auf meine Fragen bekommen ☺️', 'Randevu alma aşamasında yazışma çok güzeldi, tüm sorulara cevap vermeye ve bize uygun olmaya çalıştılar :)
Ama yerdeki resepsiyonist çok asık yüzlüydü, sıradan bir güzellik salonundan da kötüydü, işini üşenerek yaptı ve bana çay ya da su bile ikram etmedi 😕
Doktor çok hoş ve anlayışlı bir kadın, ona gittiğime memnun oldum, merak ettiğim soruların yanıtlarını buldum ☺️',
    0, '2024-08-03 00:00:00'),

(@user_kate_ohara, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURaN1BqWi1BRRAB',
    5, 'en', 'Fabulous service and nails are the best I\'ve ever had done. The only thing was it took over 2 hours and I got a little fed up but well worth it. Thank you all!',
    'Fantastična usluga, a nokti su najbolji koje su mi ikad uradili. Jedino je trajalo više od 2 sata i malo mi je bilo dosta, ali se isplatilo. Hvala vam svima!', 'Фантастична услуга, а нокти су најбољи које су ми икад урадили. Једино је трајало више од 2 сата и мало ми је било доста, али се исплатило. Хвала вам свима!', 'Fabulous service and nails are the best I\'ve ever had done. The only thing was it took over 2 hours and I got a little fed up but well worth it. Thank you all!', 'Потрясающий сервис, а ногти - лучшие из всех, что мне когда-либо делали. Единственное - это заняло больше 2 часов, и я немного устала, но оно того стоило. Спасибо вам всем!', 'Fabelhafter Service und die Nägel sind die besten, die mir je gemacht wurden. Das Einzige war, dass es über 2 Stunden gedauert hat und ich etwas genervt war, aber es hat sich absolut gelohnt. Danke an alle!', 'Muhteşem bir hizmet ve tırnaklar bugüne kadar yaptırdıklarımın en iyisi. Tek şey 2 saatten fazla sürdü ve biraz sıkıldım, ama fazlasıyla değdi. Hepinize teşekkürler!',
    0, '2024-08-03 00:00:00'),

(@user_angelika_israfilova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNadlpLVHdnRRAB',
    5, 'ru', 'Записалась на маникюр с укреплением френч, работу выполнили очень аккуратно. В салоне очень приятная атмосфера, всё светлое и чистое, уровень сервиса самый лучший в будве. Отдельно хочу порекомендовать мастера Наталью! Очень приятная и внимательная мастер.',
    'Zakazala sam manikir s ojačavanjem i French manikirom, posao je odrađen veoma pedantno. U salonu je veoma prijatna atmosfera, sve je svijetlo i čisto, nivo usluge je najbolji u Budvi. Posebno želim da preporučim majstoricu Nataliju! Veoma prijatna i pažljiva majstorica.', 'Заказала сам маникир с ојачавањем и French маникиром, посао је одрађен веома педантно. У салону је веома пријатна атмосфера, све је свијетло и чисто, ниво услуге је најбољи у Будви. Посебно желим да препоручим мајсторицу Наталију! Веома пријатна и пажљива мајсторица.', 'I booked a manicure with strengthening and a French, and the work was done very neatly. The atmosphere in the salon is very pleasant, everything is bright and clean, the level of service is the best in Budva. I especially want to recommend Natalia! A very pleasant and attentive technician.', 'Записалась на маникюр с укреплением френч, работу выполнили очень аккуратно. В салоне очень приятная атмосфера, всё светлое и чистое, уровень сервиса самый лучший в будве. Отдельно хочу порекомендовать мастера Наталью! Очень приятная и внимательная мастер.', 'Ich habe eine Maniküre mit Verstärkung und French gebucht, die Arbeit wurde sehr sauber gemacht. Im Salon ist die Atmosphäre sehr angenehm, alles ist hell und sauber, das Serviceniveau ist das beste in Budva. Besonders empfehlen möchte ich Natalia! Eine sehr angenehme und aufmerksame Nageldesignerin.', 'Güçlendirmeli French manikür için randevu aldım, iş çok özenli yapıldı. Salonun atmosferi çok hoş, her şey aydınlık ve temiz, hizmet düzeyi Budva\'daki en iyisi. Özellikle uzman Natalia\'yı tavsiye etmek istiyorum! Çok hoş ve özenli bir uzman.',
    0, '2024-08-03 00:00:00'),

(@user_katya_ea, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNwb29tdTVBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-08-03 00:00:00'),

(@user_lesia_makfluri, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNKbXBlUlpREAE',
    5, 'ru', 'Были на консультации у ортопеда с болями в ногах у дочери (9л). Врач осмотрел стопы зрительно, пропальпировал, и осмотрела на зеркальной установке. Подтвердил все мои опасения в плане плоскостопия и вальгусной деформации стопы у ребенка. Тут же сделали индивидуальные стельки, поставленная задача была выполнена на 100%. Ножки больше не болят, пойдем в августе на коррекцию стелек! Благодарю!',
    'Bili smo na konsultaciji kod ortopeda zbog bolova u nogama kod kćerke (9 g.). Doktor je pregledao stopala vizuelno, palpirao ih i pregledao na ogledalnoj podoskopiji. Potvrdio je sve moje sumnje u vezi s ravnim stopalima i valgus deformacijom stopala kod djeteta. Tu na mjestu su napravili individualne uloške, postavljeni zadatak je izvršen 100%. Nožice više ne bole, u avgustu idemo na korekciju uložaka! Zahvaljujem!', 'Били смо на консултацији код ортопеда због болова у ногама код кћерке (9 г.). Доктор је прегледао стопала визуелно, палпирао их и прегледао на огледалној подоскопији. Потврдио је све моје сумње у вези с равним стопалима и валгус деформацијом стопала код дјетета. Ту на мјесту су направили индивидуалне улошке, постављени задатак је извршен 100%. Ножице више не боле, у августу идемо на корекцију уложака! Захваљујем!', 'We came for a consultation with the orthopaedist because of pain in my daughter\'s feet (9 y.o.). The doctor examined her feet visually, palpated them and checked them on the mirror podoscope. He confirmed all my concerns about flat feet and valgus deformity of the child\'s foot. They made custom insoles right there, and the task was accomplished 100%. Her feet don\'t hurt anymore, in August we\'ll go for an insole adjustment! Thank you!', 'Были на консультации у ортопеда с болями в ногах у дочери (9л). Врач осмотрел стопы зрительно, пропальпировал, и осмотрела на зеркальной установке. Подтвердил все мои опасения в плане плоскостопия и вальгусной деформации стопы у ребенка. Тут же сделали индивидуальные стельки, поставленная задача была выполнена на 100%. Ножки больше не болят, пойдем в августе на коррекцию стелек! Благодарю!', 'Wir waren wegen Fußschmerzen meiner Tochter (9 J.) zur Beratung beim Orthopäden. Der Arzt hat die Füße visuell untersucht, abgetastet und auf dem Spiegel-Podoskop begutachtet. Er hat alle meine Befürchtungen bezüglich Plattfüßen und Valgusdeformität des Fußes bei dem Kind bestätigt. Gleich vor Ort wurden individuelle Einlagen angefertigt, die gestellte Aufgabe wurde zu 100% erfüllt. Die Füßchen tun nicht mehr weh, im August gehen wir zur Korrektur der Einlagen! Vielen Dank!', 'Kızımın (9 yaş) ayak ağrıları için ortopedi konsültasyonuna gittik. Doktor ayakları gözle inceledi, elle muayene etti ve aynalı podoskopta baktı. Çocuktaki düztabanlık ve ayağın valgus deformitesiyle ilgili tüm endişelerimi doğruladı. Hemen orada kişiye özel tabanlık yaptılar, hedeflenen sonuç %100 elde edildi. Ayakları artık ağrımıyor, ağustosta tabanlık düzeltmesi için gideceğiz! Teşekkür ederim!',
    0, '2023-08-03 00:00:00'),

(@user_elena_2, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNKMHU3S2VBEAE',
    5, 'ru', 'Делали там мужу индивидуальные ортопедические стельки. Прекрасная работа, видимым образом меняется походка и осанка.',
    'Tamo su mužu radili individualne ortopedske uloške. Divan posao, hod i držanje se vidno mijenjaju.', 'Тамо су мужу радили индивидуалне ортопедске улошке. Диван посао, ход и држање се видно мијењају.', 'They made custom orthopaedic insoles for my husband there. Wonderful work, his gait and posture are visibly changing.', 'Делали там мужу индивидуальные ортопедические стельки. Прекрасная работа, видимым образом меняется походка и осанка.', 'Dort wurden für meinen Mann individuelle orthopädische Einlagen angefertigt. Wunderbare Arbeit, Gang und Haltung verändern sich sichtbar.', 'Eşime orada kişiye özel ortopedik tabanlık yaptılar. Harika bir iş, yürüyüşü ve duruşu gözle görülür şekilde değişiyor.',
    0, '2023-08-03 00:00:00'),

(@user_svetlana_seesun, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNKbE9HQ3RBRRAB',
    2, 'ru', 'Дорого, педикюр некачественный, может как и специалист Анна и неплохо делает, но как руководитель, просто  минус 100  процентов, не хочется возвращаться .',
    'Skupo, pedikir nekvalitetan, možda Ana kao majstor i radi solidno, ali kao rukovodilac — prosto minus 100 posto, ne želim da se vraćam.', 'Скупо, педикир неквалитетан, можда Ана као мајстор и ради солидно, али као руководилац — просто минус 100 посто, не желим да се враћам.', 'Expensive, the pedicure was poor quality. Maybe Ana as a specialist does a decent job, but as a manager — just minus 100 percent, I don\'t feel like coming back.', 'Дорого, педикюр некачественный, может как и специалист Анна и неплохо делает, но как руководитель, просто  минус 100  процентов, не хочется возвращаться .', 'Teuer, die Pediküre von schlechter Qualität. Als Fachkraft macht Ana ihre Arbeit vielleicht ganz gut, aber als Chefin — einfach minus 100 Prozent, ich habe keine Lust wiederzukommen.', 'Pahalı, pedikür kalitesizdi. Ana uzman olarak belki fena iş çıkarmıyor ama yönetici olarak tam eksi 100 puan, bir daha gitmek istemiyorum.',
    0, '2023-08-03 00:00:00'),

(@user_svetlana_realtormontenegro_montenegro, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUR4cm9yMVB3EAE',
    5, 'ru', 'Главный минус этой студии, что её не хочется покидать.
Здесь все придумано, все продумано: сервис, дизайн, услуги и пр.',
    'Glavni minus ovog studija je to što ne želiš da ga napustiš.
Ovdje je sve osmišljeno, sve promišljeno: servis, dizajn, usluge i sl.', 'Главни минус овог студија је то што не желиш да га напустиш.
Овдје је све осмишљено, све промишљено: сервис, дизајн, услуге и сл.', 'The main downside of this studio is that you never want to leave.
Everything here has been thought up and thought through: the service, the design, the treatments and so on.', 'Главный минус этой студии, что её не хочется покидать.
Здесь все придумано, все продумано: сервис, дизайн, услуги и пр.', 'Der größte Nachteil dieses Studios ist, dass man es gar nicht verlassen möchte.
Hier ist alles ausgedacht, alles durchdacht: Service, Design, Leistungen usw.', 'Bu stüdyonun en büyük eksisi, oradan ayrılmak istememeniz.
Burada her şey düşünülmüş, her şey ince ince planlanmış: servis, tasarım, hizmetler vs.',
    0, '2023-08-03 00:00:00'),

(@user_evgenia_kolesnikova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUN4dDRDMEl3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-08-03 00:00:00'),

(@user_anna_siguta, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURSMDViOF9RRRAB',
    1, 'ru', 'Подается все замечательно ,нормы дезинфекции и т.д.,компетентные мастера ,но настоятельно рекомендую лечить бородавки в мед учреждениях,особенно если они вызваны спадом иммунной системы а не кислотой за больные деньги ..проходила каждую неделю больше месяца,сделала ортопедические стельки (все как рекомендовала Аннушка ),в итоге место ороговевший кожи стало по радиусу еще больше и теперь из-за величины другими способами их очень сложно удалять .Выкинутые деньги и результата ноль',
    'Sve je predstavljeno divno, norme dezinfekcije i sl., kompetentni majstori, ali toplo preporučujem da bradavice liječite u medicinskim ustanovama, posebno ako su nastale zbog pada imuniteta, a ne kiselinom za bolesne pare ..išla sam svake nedjelje više od mjesec dana, napravila ortopedske uloške (sve kako je preporučila Anuška), na kraju je mjesto sa zadebljanom kožom po radijusu postalo još veće i sada ih je zbog te veličine veoma teško uklanjati drugim metodama. Bačene pare i rezultat nula', 'Све је представљено дивно, норме дезинфекције и сл., компетентни мајстори, али топло препоручујем да брадавице лијечите у медицинским установама, посебно ако су настале због пада имунитета, а не киселином за болесне паре ..ишла сам сваке недјеље више од мјесец дана, направила ортопедске улошке (све како је препоручила Анушка), на крају је мјесто са задебљаном кожом по радијусу постало још веће и сада их је због те величине веома тешко уклањати другим методама. Бачене паре и резултат нула', 'Everything is presented wonderfully, disinfection standards and so on, competent technicians, but I strongly recommend having warts treated at medical facilities, especially if they are caused by a drop in the immune system, and not with acid for insane money.. I went every week for over a month, had orthopaedic insoles made (all exactly as Annushka recommended), and in the end the patch of hardened skin grew even wider in radius, and now, because of the size, it is very hard to remove them by other methods. Money thrown away and zero result', 'Подается все замечательно ,нормы дезинфекции и т.д.,компетентные мастера ,но настоятельно рекомендую лечить бородавки в мед учреждениях,особенно если они вызваны спадом иммунной системы а не кислотой за больные деньги ..проходила каждую неделю больше месяца,сделала ортопедические стельки (все как рекомендовала Аннушка ),в итоге место ороговевший кожи стало по радиусу еще больше и теперь из-за величины другими способами их очень сложно удалять .Выкинутые деньги и результата ноль', 'Alles wird wunderbar präsentiert, Desinfektionsstandards usw., kompetente Fachkräfte, aber ich empfehle dringend, Warzen in medizinischen Einrichtungen behandeln zu lassen, besonders wenn sie durch ein geschwächtes Immunsystem verursacht sind, und nicht mit Säure für krankes Geld.. Ich bin über einen Monat lang jede Woche hingegangen, habe orthopädische Einlagen machen lassen (alles so, wie Annushka es empfohlen hat), am Ende wurde die Stelle mit der verhornten Haut im Radius noch größer und jetzt sind sie wegen dieser Größe mit anderen Methoden sehr schwer zu entfernen. Rausgeworfenes Geld und null Ergebnis', 'Her şey harika sunuluyor, dezenfeksiyon kuralları vs., yetkin uzmanlar, ama siğilleri tıbbi kurumlarda tedavi ettirmenizi ısrarla tavsiye ederim, özellikle bağışıklık sisteminin düşmesinden kaynaklanıyorlarsa, hasta gibi paralar ödeyip asitle değil.. Bir aydan fazla her hafta gittim, ortopedik tabanlık yaptırdım (hepsi Annushka\'nın önerdiği gibi), sonuçta nasırlaşmış cilt bölgesinin çapı daha da büyüdü ve şimdi bu büyüklük yüzünden başka yöntemlerle çıkarmak çok zor. Boşa gitmiş para ve sıfır sonuç',
    0, '2023-08-03 00:00:00'),

(@user_nadiia_imanova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSURSa01fd0pBEAE',
    5, 'ru', 'Я в восторге) прекрасное место) обязательно прийду еще раз)',
    'Presrećna sam) divno mjesto) obavezno ću doći još jednom)', 'Пресрећна сам) дивно мјесто) обавезно ћу доћи још једном)', 'I\'m thrilled) a wonderful place) I\'ll definitely come again)', 'Я в восторге) прекрасное место) обязательно прийду еще раз)', 'Ich bin begeistert) ein wunderbarer Ort) ich komme auf jeden Fall noch einmal)', 'Çok memnun kaldım) harika bir yer) mutlaka bir daha geleceğim)',
    0, '2023-08-03 00:00:00'),

(@user_mikhail_mikhaylovich, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNoX3ZLcU9REAE',
    5, 'en', 'Good!',
    'Dobro!', 'Добро!', 'Good!', 'Хорошо!', 'Gut!', 'İyi!',
    0, '2023-08-03 00:00:00'),

(@user_marina_antonova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURCdy0tTDZnRRAB',
    3, 'ru', 'Делала чистку двух ногтей.
Изначально планировала свой бюджет. Озвучен был ценник 20 евро за один ноготь.
В процессе приема мне допродали капли за 35 евро . Объяснив что без них вся проделанная работа будет зря. Позже я увидела, что их можно купить в интернете за 13-15 евро.
В финале насчитали еще дополнительно за валик, которые положили под кончик ногтя и какую-то мазь.

Итого чек 95 евро. Вместо ожидаемых 40 е.

Я считаю, что корректно при каждом действии, которое выходит за рамки оговоренного бюджета - предупреждать об этом клиента.

Особенно я была тем самым клиентом, который изначально задавал уточняющие вопросы про стоимость. Это не тот случай, когда можно ответить «вы не спрашивали» .
А После того, когда цены озвучены и согласованы, я как клиент расслабляюсь, полностью доверяю мастеру и не хочу напрягать себя мыслями что он там делает с моими ногтями для получения финального результата. И если валики и мази - обязательная часть процедуры ,но по каким-то причинам оплачиваются отдельно , то цены на них тоже должны быть озвучены в начале.

В итоге я получила тот результат за которым шла, но в 2,5 раза дороже.
Ставлю 5 за работу мастера, двойка - за непорядочность.',
    'Radila sam čišćenje dva nokta.
Unaprijed sam isplanirala svoj budžet. Rečena mi je cijena 20 eura za jedan nokat.
U toku tretmana su mi doprodali kapi za 35 eura . Uz objašnjenje da će bez njih sav obavljeni rad biti uzaludan. Kasnije sam vidjela da se mogu kupiti na internetu za 13-15 eura.
Na kraju su naplatili još dodatno i valjak koji su stavili pod vrh nokta i nekakvu mast.

Ukupno račun 95 eura. Umjesto očekivanih 40 e.

Smatram da je korektno da se klijent unaprijed upozori na svaku radnju koja izlazi iz okvira dogovorenog budžeta.

A posebno zato što sam ja bila upravo onaj klijent koji je od početka postavljao dodatna pitanja o cijeni. Ovo nije slučaj u kojem se može odgovoriti «niste pitali» .
A nakon što su cijene izgovorene i usaglašene, ja se kao klijent opustim, potpuno vjerujem majstoru i ne želim da se zamaram time šta on tamo radi sa mojim noktima da bi postigao konačan rezultat. I ako su valjci i masti obavezan dio procedure, ali se iz nekog razloga plaćaju posebno, onda i njihove cijene moraju biti izgovorene na početku.

Na kraju sam dobila onaj rezultat zbog kojeg sam i došla, ali 2,5 puta skuplje.
Dajem 5 za rad majstora, a dvojku - za nekorektnost.', 'Радила сам чишћење два нокта.
Унапријед сам испланирала свој буџет. Речена ми је цијена 20 еура за један нокат.
У току третмана су ми допродали капи за 35 еура . Уз објашњење да ће без њих сав обављени рад бити узалудан. Касније сам видјела да се могу купити на интернету за 13-15 еура.
На крају су наплатили још додатно и ваљак који су ставили под врх нокта и некакву маст.

Укупно рачун 95 еура. Умјесто очекиваних 40 е.

Сматрам да је коректно да се клијент унапријед упозори на сваку радњу која излази из оквира договореног буџета.

А посебно зато што сам ја била управо онај клијент који је од почетка постављао додатна питања о цијени. Ово није случај у којем се може одговорити «нисте питали» .
А након што су цијене изговорене и усаглашене, ја се као клијент опустим, потпуно вјерујем мајстору и не желим да се замарам тиме шта он тамо ради са мојим ноктима да би постигао коначан резултат. И ако су ваљци и масти обавезан дио процедуре, али се из неког разлога плаћају посебно, онда и њихове цијене морају бити изговорене на почетку.

На крају сам добила онај резултат због којег сам и дошла, али 2,5 пута скупље.
Дајем 5 за рад мајстора, а двојку - за некоректност.', 'I had two nails cleaned up.
I had planned my budget in advance. The price quoted was 20 euros per nail.
During the appointment I was upsold drops for 35 euros . With the explanation that without them all the work done would be for nothing. Later I saw that they can be bought online for 13-15 euros.
At the end they also charged extra for the roll they placed under the tip of the nail and for some kind of ointment.

Total bill 95 euros. Instead of the expected 40 e.

I believe the proper thing is to warn the client in advance about every step that goes beyond the agreed budget.

Especially as I was exactly the kind of client who asked clarifying questions about the cost from the very start. This is not a case where you can answer «you didn\'t ask» .
And once the prices have been stated and agreed, I as a client relax, I fully trust the technician and don\'t want to bother myself with thoughts about what she is doing to my nails to get the final result. And if rolls and ointments are a mandatory part of the procedure but for some reason are paid for separately, then their prices have to be stated at the beginning too.

In the end I got the result I came for, but 2.5 times more expensive.
I give a 5 for the technician\'s work, and a two - for the dishonesty.', 'Делала чистку двух ногтей.
Изначально планировала свой бюджет. Озвучен был ценник 20 евро за один ноготь.
В процессе приема мне допродали капли за 35 евро . Объяснив что без них вся проделанная работа будет зря. Позже я увидела, что их можно купить в интернете за 13-15 евро.
В финале насчитали еще дополнительно за валик, которые положили под кончик ногтя и какую-то мазь.

Итого чек 95 евро. Вместо ожидаемых 40 е.

Я считаю, что корректно при каждом действии, которое выходит за рамки оговоренного бюджета - предупреждать об этом клиента.

Особенно я была тем самым клиентом, который изначально задавал уточняющие вопросы про стоимость. Это не тот случай, когда можно ответить «вы не спрашивали» .
А После того, когда цены озвучены и согласованы, я как клиент расслабляюсь, полностью доверяю мастеру и не хочу напрягать себя мыслями что он там делает с моими ногтями для получения финального результата. И если валики и мази - обязательная часть процедуры ,но по каким-то причинам оплачиваются отдельно , то цены на них тоже должны быть озвучены в начале.

В итоге я получила тот результат за которым шла, но в 2,5 раза дороже.
Ставлю 5 за работу мастера, двойка - за непорядочность.', 'Ich habe zwei Nägel reinigen lassen.
Ich hatte mein Budget vorher geplant. Genannt wurde ein Preis von 20 Euro pro Nagel.
Während des Termins hat man mir noch Tropfen für 35 Euro verkauft . Mit der Erklärung, dass ohne sie die ganze geleistete Arbeit umsonst wäre. Später habe ich gesehen, dass man sie im Internet für 13-15 Euro kaufen kann.
Am Ende wurde zusätzlich noch für ein Röllchen abgerechnet, das man unter die Nagelspitze gelegt hat, und für irgendeine Salbe.

Insgesamt eine Rechnung von 95 Euro. Statt der erwarteten 40 E.

Ich finde, es gehört sich, den Kunden bei jedem Schritt, der über das abgesprochene Budget hinausgeht, vorher darauf hinzuweisen.

Zumal ich genau die Kundin war, die von Anfang an nachgefragt hat, was das Ganze kostet. Das ist nicht der Fall, in dem man antworten kann «Sie haben nicht gefragt» .
Und nachdem die Preise genannt und abgestimmt sind, entspanne ich mich als Kundin, vertraue der Fachkraft völlig und will mir nicht den Kopf darüber zerbrechen, was sie da mit meinen Nägeln macht, um das Endergebnis zu erzielen. Und wenn Röllchen und Salben ein zwingender Teil der Behandlung sind, aber aus irgendwelchen Gründen separat bezahlt werden, dann müssen auch ihre Preise am Anfang genannt werden.

Am Ende habe ich das Ergebnis bekommen, für das ich gekommen war, aber 2,5-mal teurer.
Ich gebe eine 5 für die Arbeit der Fachkraft, und eine Zwei - für die Unredlichkeit.', 'İki tırnağımı temizlettim.
Baştan bütçemi planlamıştım. Tırnak başına 20 euro fiyat söylendi.
Seans sırasında bana 35 euroluk damla satıldı . Onlar olmadan yapılan tüm işin boşa gideceği söylenerek. Sonradan bunların internette 13-15 euroya satıldığını gördüm.
Sonunda tırnağın ucuna yerleştirdikleri rulo ve bir merhem için de ayrıca ücret eklediler.

Toplam hesap 95 euro. Beklediğim 40 e yerine.

Bence doğrusu, konuşulan bütçenin dışına çıkan her işlemde müşteriyi önceden uyarmaktır.

Özellikle de ben tam baştan fiyat konusunda ayrıntılı sorular soran müşteriydim. Bu, «sormadınız ki» diye cevap verilebilecek bir durum değil .
Fiyatlar söylenip mutabık kalındıktan sonra ben müşteri olarak rahatlıyorum, uzmana tamamen güveniyorum ve nihai sonuç için tırnaklarıma ne yaptığını düşünerek kendimi yormak istemiyorum. Eğer rulolar ve merhemler prosedürün zorunlu bir parçasıysa ama bir nedenle ayrı ücretlendiriliyorsa, onların fiyatları da başta söylenmeli.

Sonuçta gitmek istediğim sonucu aldım, ama 2,5 kat daha pahalıya.
Uzmanın işine 5 veriyorum, dürüst olmamaya ise iki.',
    0, '2023-08-03 00:00:00'),

(@user_kejvinaleksa_popova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUQtNmJyaVFnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-08-03 00:00:00'),

(@user_irina_rukas, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNldjhDdWRREAE',
    5, 'ru', 'Чудесный салон💛 Прекрасные специалисты🌷Высочайший уровень обслуживания🔥
Здесь продумано все - от самых мелочей комфорта и удобства до идеального качества предоставляемых услуг! Атмосфера расслабленности и уюта и - ДА- такой уровень профессионального подхода не может стоить дёшево! Цены абсолютно соответствуют качеству и получаемому результату!
Сердечная благодарность Анюте 🙏🏻 за то, что уже после первой процедуры я могла безболезненно надевать обувь и ходить (после 15 лет адских мучений). Полностью восстановлена форма ногтей, кожа на подошвах и подобрана уходовая косметика 💃
Счастлива, что попала к таким профессионалам, которые изменили качество моей жизни ⭐💫💥
Удачи вам и благодарных адекватных клиентов 💞',
    'Čudesan salon💛 Divni stručnjaci🌷Najviši nivo usluge🔥
Ovdje je sve promišljeno - od najmanjih detalja komfora i udobnosti do idealnog kvaliteta pruženih usluga! Atmosfera opuštenosti i prijatnosti i - DA - takav nivo profesionalnog pristupa ne može biti jeftin! Cijene apsolutno odgovaraju kvalitetu i rezultatu koji se dobija!
Srdačna hvala Anjuti 🙏🏻 zato što sam već nakon prvog tretmana mogla bezbolno da obujem obuću i hodam (nakon 15 godina paklenih muka). Potpuno je obnovljen oblik noktiju, koža na stopalima i odabrana je kozmetika za njegu 💃
Srećna sam što sam dospjela kod takvih profesionalaca, koji su promijenili kvalitet mog života ⭐💫💥
Sreću vam želim i zahvalne, normalne klijente 💞', 'Чудесан салон💛 Дивни стручњаци🌷Највиши ниво услуге🔥
Овдје је све промишљено - од најмањих детаља комфора и удобности до идеалног квалитета пружених услуга! Атмосфера опуштености и пријатности и - ДА - такав ниво професионалног приступа не може бити јефтин! Цијене апсолутно одговарају квалитету и резултату који се добија!
Срдачна хвала Ањути 🙏🏻 зато што сам већ након првог третмана могла безболно да обујем обућу и ходам (након 15 година паклених мука). Потпуно је обновљен облик ноктију, кожа на стопалима и одабрана је козметика за његу 💃
Срећна сам што сам доспјела код таквих професионалаца, који су промијенили квалитет мог живота ⭐💫💥
Срећу вам желим и захвалне, нормалне клијенте 💞', 'A wonderful salon💛 Wonderful specialists🌷The highest level of service🔥
Everything here has been thought through - from the tiniest details of comfort and convenience to the perfect quality of the services provided! An atmosphere of relaxation and cosiness and - YES - this level of professional approach cannot come cheap! The prices absolutely match the quality and the result you get!
My heartfelt thanks to Anjuta 🙏🏻 for the fact that after the very first procedure I could put on shoes and walk without pain (after 15 years of hellish torment). The shape of my nails and the skin on my soles have been completely restored, and care products were selected for me 💃
I\'m happy that I ended up with such professionals, who changed the quality of my life ⭐💫💥
Good luck to you and grateful, reasonable clients 💞', 'Чудесный салон💛 Прекрасные специалисты🌷Высочайший уровень обслуживания🔥
Здесь продумано все - от самых мелочей комфорта и удобства до идеального качества предоставляемых услуг! Атмосфера расслабленности и уюта и - ДА- такой уровень профессионального подхода не может стоить дёшево! Цены абсолютно соответствуют качеству и получаемому результату!
Сердечная благодарность Анюте 🙏🏻 за то, что уже после первой процедуры я могла безболезненно надевать обувь и ходить (после 15 лет адских мучений). Полностью восстановлена форма ногтей, кожа на подошвах и подобрана уходовая косметика 💃
Счастлива, что попала к таким профессионалам, которые изменили качество моей жизни ⭐💫💥
Удачи вам и благодарных адекватных клиентов 💞', 'Ein wunderbarer Salon💛 Wunderbare Fachkräfte🌷Höchstes Serviceniveau🔥
Hier ist alles durchdacht - von den kleinsten Details an Komfort und Bequemlichkeit bis zur perfekten Qualität der erbrachten Leistungen! Eine Atmosphäre der Entspannung und Gemütlichkeit und - JA - so ein Niveau an professionellem Vorgehen kann nicht billig sein! Die Preise entsprechen absolut der Qualität und dem erzielten Ergebnis!
Herzlichen Dank an Anjuta 🙏🏻 dafür, dass ich schon nach der ersten Behandlung schmerzfrei Schuhe anziehen und gehen konnte (nach 15 Jahren höllischer Qualen). Die Form der Nägel und die Haut an den Fußsohlen sind vollständig wiederhergestellt, und es wurde Pflegekosmetik für mich ausgewählt 💃
Ich bin glücklich, an solche Profis geraten zu sein, die meine Lebensqualität verändert haben ⭐💫💥
Viel Glück für Sie und dankbare, vernünftige Kunden 💞', 'Harika bir salon💛 Muhteşem uzmanlar🌷En üst düzey hizmet🔥
Burada her şey düşünülmüş - konfor ve rahatlığın en küçük ayrıntısından sunulan hizmetlerin kusursuz kalitesine kadar! Rahatlık ve huzur dolu bir atmosfer ve - EVET - böyle bir profesyonel yaklaşım ucuz olamaz! Fiyatlar kaliteye ve alınan sonuca kesinlikle uygun!
Anjuta\'ya candan teşekkürler 🙏🏻 ilk seanstan sonra bile ayakkabımı ağrısız giyip yürüyebildiğim için (15 yıllık cehennem azabından sonra). Tırnaklarımın şekli ve ayak tabanlarımın derisi tamamen düzeldi, bakım kozmetiği de seçildi 💃
Hayat kalitemi değiştiren böyle profesyonellere denk geldiğim için çok mutluyum ⭐💫💥
Size bol şans ve minnettar, aklı başında müşteriler diliyorum 💞',
    0, '2023-08-03 00:00:00'),

(@user_tatiana_antipkina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUR1ajQ2WjZBRRAB',
    5, 'ru', 'Уже больше года хожу к Анюте, это сказка, за 20 лет посещений подологов - никто не мог решить проблему, а Аня решила, чему я очень рада. Искренне рекомендую, Аня большой профессионал, одно удовольствие посещать салон.',
    'Već više od godinu dana idem kod Anjute, to je bajka, za 20 godina obilaženja podologa - niko nije mogao da riješi problem, a Anja je riješila, čemu se veoma radujem. Iskreno preporučujem, Anja je veliki profesionalac, pravo je zadovoljstvo dolaziti u salon.', 'Већ више од годину дана идем код Ањуте, то је бајка, за 20 година обилажења подолога - нико није могао да ријеши проблем, а Ања је ријешила, чему се веома радујем. Искрено препоручујем, Ања је велики професионалац, право је задовољство долазити у салон.', 'I\'ve been going to Anjuta for over a year now, it\'s a fairy tale. In 20 years of visiting podiatrists nobody could solve my problem, but Anja did, and I\'m really glad about it. I sincerely recommend her, Anja is a real professional, visiting the salon is a pure pleasure.', 'Уже больше года хожу к Анюте, это сказка, за 20 лет посещений подологов - никто не мог решить проблему, а Аня решила, чему я очень рада. Искренне рекомендую, Аня большой профессионал, одно удовольствие посещать салон.', 'Ich gehe schon über ein Jahr zu Anjuta, das ist ein Märchen. In 20 Jahren Podologen-Besuchen konnte niemand mein Problem lösen, aber Anja hat es gelöst, worüber ich sehr froh bin. Ich empfehle sie aufrichtig, Anja ist eine große Fachfrau, der Besuch im Salon ist ein reines Vergnügen.', 'Bir yıldan fazla süredir Anjuta\'ya gidiyorum, bu bir masal. 20 yıl boyunca podologlara gittim - kimse problemi çözemedi, ama Anja çözdü, buna çok mutluyum. Yürekten tavsiye ederim, Anja büyük bir profesyonel, salona gitmek tam bir keyif.',
    0, '2023-08-03 00:00:00'),

(@user_liudmila_nesterenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUR1OTdXT25BRRAB',
    5, 'ru', 'Это лучшая студия, в которой я была в принципе. Хотя после студий в СНГ казалось сложно угодить. Но эта студия восторг буквально во всем: топовые мастера, делают просто идеально, палитра огонь, администратор Настя -это вообще сверх внимание, чай, кофе, массаж ног организует, обувь обработает…я такого нигде не видела. Цены для такой комбинации более чем приемлимые. Нравится все на 100%. Спасибо вам!!',
    'Ovo je najbolji studio u kojem sam uopšte bila. Mada je nakon studija u ZND-u izgledalo teško da mi se ugodi. Ali ovaj studio je oduševljenje bukvalno u svemu: top majstori, rade prosto idealno, paleta je vatra, administratorka Nastja - to je već krajnja pažnja, čaj, kafa, masažu stopala organizuje, obuću obradi…nešto takvo nigdje nisam vidjela. Cijene su za takvu kombinaciju više nego prihvatljive. Sve mi se sviđa 100%. Hvala vam!!', 'Ово је најбољи студио у којем сам уопште била. Мада је након студија у ЗНД-у изгледало тешко да ми се угоди. Али овај студио је одушевљење буквално у свему: топ мајстори, раде просто идеално, палета је ватра, администраторка Настја - то је већ крајња пажња, чај, кафа, масажу стопала организује, обућу обради…нешто такво нигдје нисам видјела. Цијене су за такву комбинацију више него прихватљиве. Све ми се свиђа 100%. Хвала вам!!', 'This is the best studio I\'ve been to, period. Although after the studios in the CIS it seemed hard to impress me. But this studio is a delight in literally everything: top technicians, the work is simply perfect, the colour palette is fire, and the receptionist Nastya is just next-level attentive - tea, coffee, she arranges a foot massage, disinfects your shoes…I\'ve never seen anything like it anywhere. For a combination like this the prices are more than acceptable. I like everything 100%. Thank you!!', 'Это лучшая студия, в которой я была в принципе. Хотя после студий в СНГ казалось сложно угодить. Но эта студия восторг буквально во всем: топовые мастера, делают просто идеально, палитра огонь, администратор Настя -это вообще сверх внимание, чай, кофе, массаж ног организует, обувь обработает…я такого нигде не видела. Цены для такой комбинации более чем приемлимые. Нравится все на 100%. Спасибо вам!!', 'Das ist das beste Studio, in dem ich überhaupt je war. Obwohl es nach den Studios in der GUS schwer schien, mich zufriedenzustellen. Aber dieses Studio ist buchstäblich in allem eine Begeisterung: Top-Fachkräfte, die Arbeit ist einfach perfekt, die Farbpalette ist der Hammer, und die Empfangsdame Nastya ist überaufmerksam - Tee, Kaffee, sie organisiert eine Fußmassage, desinfiziert die Schuhe…so etwas habe ich nirgends gesehen. Für so eine Kombination sind die Preise mehr als akzeptabel. Mir gefällt alles zu 100%. Danke euch!!', 'Bu, gittiğim en iyi stüdyo. Oysa BDT ülkelerindeki stüdyolardan sonra beni memnun etmek zor görünüyordu. Ama bu stüdyo kelimenin tam anlamıyla her şeyde mükemmel: en iyi uzmanlar, işi kusursuz yapıyorlar, renk paleti ateş, resepsiyonist Nastya ise ilgi konusunda sınır tanımıyor - çay, kahve, ayak masajı ayarlıyor, ayakkabıyı dezenfekte ediyor…böylesini hiçbir yerde görmedim. Böyle bir kombinasyon için fiyatlar fazlasıyla makul. Her şeyi %100 beğeniyorum. Teşekkürler!!',
    0, '2023-08-03 00:00:00'),

(@user_yuliya_galdina, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUR1aTYtRXFBRRAB',
    5, 'ru', 'Отличный салон, где знают, что такое качество. Радует все: профессионализм персонала, великолепная обстановка, где продумана каждая деталь, стерилизация инструмента, комфортные условия для клиентов (напитки, угощения, массажёры на время основных процедур). Очень довольна, что стала клиентом ☺️',
    'Odličan salon, gdje znaju šta je kvalitet. Sve raduje: profesionalizam osoblja, sjajan ambijent u kojem je promišljen svaki detalj, sterilizacija instrumenata, komforni uslovi za klijente (napici, poslastice, masažeri za vrijeme glavnih tretmana). Veoma sam zadovoljna što sam postala klijent ☺️', 'Одличан салон, гдје знају шта је квалитет. Све радује: професионализам особља, сјајан амбијент у којем је промишљен сваки детаљ, стерилизација инструмената, комфорни услови за клијенте (напици, посластице, масажери за вријеме главних третмана). Веома сам задовољна што сам постала клијент ☺️', 'An excellent salon where they know what quality means. Everything is a pleasure: the professionalism of the staff, the magnificent setting where every detail has been thought through, the sterilisation of the instruments, the comfortable conditions for clients (drinks, treats, massagers during the main procedures). I\'m very glad I became a client ☺️', 'Отличный салон, где знают, что такое качество. Радует все: профессионализм персонала, великолепная обстановка, где продумана каждая деталь, стерилизация инструмента, комфортные условия для клиентов (напитки, угощения, массажёры на время основных процедур). Очень довольна, что стала клиентом ☺️', 'Ein ausgezeichneter Salon, in dem man weiß, was Qualität ist. Alles erfreut: die Professionalität des Personals, das großartige Ambiente, in dem jedes Detail durchdacht ist, die Sterilisation der Instrumente, die komfortablen Bedingungen für die Kunden (Getränke, Naschereien, Massagegeräte während der Hauptbehandlungen). Ich bin sehr froh, Kundin geworden zu sein ☺️', 'Kalitenin ne olduğunu bilen mükemmel bir salon. Her şey insanı memnun ediyor: personelin profesyonelliği, her ayrıntısı düşünülmüş harika bir ortam, aletlerin sterilizasyonu, müşteriler için konforlu koşullar (içecekler, ikramlar, ana işlemler sırasında masaj aletleri). Müşterisi olduğum için çok memnunum ☺️',
    0, '2023-08-03 00:00:00'),

(@user_dzhoanitalyara_liverpul, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUR1eGJ6RkZnEAE',
    5, 'ru', 'Совсем недавно в Черногории и конечно вопрос ногтей встал очень остро. Когда свои уже почти отваливаются надо думать куда идти или снимать вообще😄 безумно боялась идти к местным мастерам, потому что боялась болезней, неаккуратности, не качественного покрытия.  Через инст нашла салон, понаблюдала немного и поняла что хочу пойти, хотя бы попробовать. Все выглядело очень чисто, что самое главное для меня. И тут случилось просто нечто. Я много где ходила в Москве в студии и салоны начиная от среднего и заканчивая высоким ценником, но такого я даже там не видела. Все абсолютно все, что касается работы с клиентом было идеально. Администратор приятный, атмосфера волшебная, напитки такие что в местных кафе тебе не предложат😄 мастер был очень внимательный и аккуратный. Безопасность на высшем уровне, сухожар, уз мойка, крафт пакеты. Даже журналы стерилизации предлагали посмотреть. А клиентоориентированность? Вообще топ, массаж ног на маникюре, Воротниковой зоны на педикюре, музыка фильмы что хочешь. Даже обувь помогли одеть когда делали покрытие и я решила что мне хватит разминать ножки 😄 на педикюре оказалось что у меня есть бородавка, Анюта проконсультировала, начали удалять. Хотя в Москве ее просто спиливали со словами у вас обувь не такая и вообще это мозоль. Покрытие относилось идеально, дольше 3 недель не хожу длина раздражает) выбор дизайнов был богат, мастер все рассказал, показал, предложил. В конце сказали что нужно купить из домашнего ухода, Израильская фирма. Слышала про неё но дома не пользовалась. Тоже восторг, каждый раз теперь что то новое беру. А системы лояльности к клиентам? Карта клиента, акции предложения. Просто безумие, я в восторге от этого места. Как прекрасно что это был мой первый салон в Черногории. Я точно задержусь в нем навсегда 😍 идти сюда значит выбрать качество и безопасность. Смотрю что кто-то отзывался о ценах, но извините меня 40 евро за такое это просто ни что)',
    'Tek sam nedavno u Crnoj Gori i naravno pitanje noktiju se postavilo veoma oštro. Kad ti sopstveni već skoro otpadaju, moraš razmišljati gdje da ideš ili da uopšte sve skineš😄 strašno sam se bojala da idem kod lokalnih majstora, jer sam se bojala bolesti, neurednosti, nekvalitetnog lakiranja.  Preko Instagrama sam našla salon, malo posmatrala i shvatila da želim da odem, da bar probam. Sve je izgledalo veoma čisto, što je za mene najvažnije. I onda se desilo prosto nešto neviđeno. Obišla sam mnogo studija i salona u Moskvi, od onih sa srednjim do onih sa visokim cijenama, ali ovako nešto nisam vidjela ni tamo. Sve, apsolutno sve što se tiče rada sa klijentom bilo je idealno. Administratorka prijatna, atmosfera čarobna, napici takvi da ti ih u lokalnim kafićima neće ponuditi😄 majstor je bio veoma pažljiv i precizan. Bezbjednost na najvišem nivou, suhi sterilizator, ultrazvučna kada, kraft kese. Čak su nudili i da pogledam dnevnike sterilizacije. A orijentisanost na klijenta? Apsolutni top, masaža stopala na manikiru, vratno-ramenog dijela na pedikiru, muzika, filmovi, šta god želiš. Čak su mi pomogli i da obujem obuću kad su radili lakiranje, a ja odlučila da mi je dosta razgibavanja nogica 😄 na pedikiru se pokazalo da imam bradavicu, Anjuta me je konsultovala, počeli smo da je uklanjamo. A u Moskvi su je prosto skidali brusilicom uz riječi da mi obuća nije dobra i da je to uopšte žulj. Lak je stajao idealno, ne nosim ga duže od 3 nedjelje jer me dužina nervira) izbor dizajna je bio bogat, majstor je sve ispričao, pokazao, predložio. Na kraju su rekli šta treba da kupim od kućne njege, izraelska firma. Slušala sam o njoj ali kod kuće je nisam koristila. Takođe oduševljenje, sada svaki put uzmem nešto novo. A sistemi lojalnosti prema klijentima? Klijentska kartica, akcije, ponude. Prosto ludilo, presrećna sam zbog ovog mjesta. Kako je divno što je ovo bio moj prvi salon u Crnoj Gori. Sigurno ću ostati u njemu zauvijek 😍 doći ovdje znači izabrati kvalitet i bezbjednost. Vidim da je neko komentarisao cijene, ali izvinite me, 40 eura za ovako nešto je prosto ništa)', 'Тек сам недавно у Црној Гори и наравно питање ноктију се поставило веома оштро. Кад ти сопствени већ скоро отпадају, мораш размишљати гдје да идеш или да уопште све скинеш😄 страшно сам се бојала да идем код локалних мајстора, јер сам се бојала болести, неуредности, неквалитетног лакирања.  Преко Instagrama сам нашла салон, мало посматрала и схватила да желим да одем, да бар пробам. Све је изгледало веома чисто, што је за мене најважније. И онда се десило просто нешто невиђено. Обишла сам много студија и салона у Москви, од оних са средњим до оних са високим цијенама, али овако нешто нисам видјела ни тамо. Све, апсолутно све што се тиче рада са клијентом било је идеално. Администраторка пријатна, атмосфера чаробна, напици такви да ти их у локалним кафићима неће понудити😄 мајстор је био веома пажљив и прецизан. Безбједност на највишем нивоу, суви стерилизатор, ултразвучна када, крафт кесе. Чак су нудили и да погледам дневнике стерилизације. А оријентисаност на клијента? Апсолутни топ, масажа стопала на маникиру, вратно-раменог дијела на педикиру, музика, филмови, шта год желиш. Чак су ми помогли и да обујем обућу кад су радили лакирање, а ја одлучила да ми је доста разгибавања ногица 😄 на педикиру се показало да имам брадавицу, Ањута ме је консултовала, почели смо да је уклањамо. А у Москви су је просто скидали брусилицом уз ријечи да ми обућа није добра и да је то уопште жуљ. Лак је стајао идеално, не носим га дуже од 3 недјеље јер ме дужина нервира) избор дизајна је био богат, мајстор је све испричао, показао, предложио. На крају су рекли шта треба да купим од кућне његе, израелска фирма. Слушала сам о њој али код куће је нисам користила. Такође одушевљење, сада сваки пут узмем нешто ново. А системи лојалности према клијентима? Клијентска картица, акције, понуде. Просто лудило, пресрећна сам због овог мјеста. Како је дивно што је ово био мој први салон у Црној Гори. Сигурно ћу остати у њему заувијек 😍 доћи овдје значи изабрати квалитет и безбједност. Видим да је неко комeнтарисао цијене, али извините ме, 40 еура за овако нешто је просто ништа)', 'I\'ve only recently moved to Montenegro and of course the nail question became very pressing. When your own are already almost falling off, you have to think about where to go or whether to take it all off😄 I was terrified of going to local technicians, because I was afraid of infections, sloppiness, poor-quality coating.  I found the salon through Insta, watched them for a while and realised I wanted to go, at least to give it a try. Everything looked very clean, which is the most important thing for me. And then something quite extraordinary happened. I\'ve been to plenty of studios and salons in Moscow, from mid-range to high-priced ones, but I hadn\'t seen anything like this even there. Everything, absolutely everything to do with how they treat the client was perfect. The receptionist is lovely, the atmosphere is magical, the drinks are the kind local cafés won\'t offer you😄 the technician was very attentive and precise. Safety at the highest level: dry-heat steriliser, ultrasonic cleaner, kraft pouches. They even offered to let me look at the sterilisation logs. And the customer focus? Absolutely top: a foot massage during the manicure, a neck-and-shoulder massage during the pedicure, music, films, whatever you want. They even helped me put my shoes on while the polish was being applied and I\'d decided I\'d had enough of flexing my little feet 😄 during the pedicure it turned out I have a wart, Anjuta gave me a consultation and we started removing it. Whereas in Moscow they just filed it down, saying my shoes were wrong and that it was just a callus anyway. The polish held up perfectly, I don\'t wear it longer than 3 weeks because the length annoys me) the choice of designs was rich, the technician explained, showed and suggested everything. At the end they told me which home-care products to buy, an Israeli brand. I\'d heard of it but hadn\'t used it back home. Also a delight, now I take something new every time. And the client loyalty schemes? A client card, promotions, special offers. It\'s simply madness, I\'m in love with this place. How wonderful that this was my first salon in Montenegro. I\'m definitely sticking with it forever 😍 coming here means choosing quality and safety. I see someone commented on the prices, but excuse me, 40 euros for this is simply nothing)', 'Совсем недавно в Черногории и конечно вопрос ногтей встал очень остро. Когда свои уже почти отваливаются надо думать куда идти или снимать вообще😄 безумно боялась идти к местным мастерам, потому что боялась болезней, неаккуратности, не качественного покрытия.  Через инст нашла салон, понаблюдала немного и поняла что хочу пойти, хотя бы попробовать. Все выглядело очень чисто, что самое главное для меня. И тут случилось просто нечто. Я много где ходила в Москве в студии и салоны начиная от среднего и заканчивая высоким ценником, но такого я даже там не видела. Все абсолютно все, что касается работы с клиентом было идеально. Администратор приятный, атмосфера волшебная, напитки такие что в местных кафе тебе не предложат😄 мастер был очень внимательный и аккуратный. Безопасность на высшем уровне, сухожар, уз мойка, крафт пакеты. Даже журналы стерилизации предлагали посмотреть. А клиентоориентированность? Вообще топ, массаж ног на маникюре, Воротниковой зоны на педикюре, музыка фильмы что хочешь. Даже обувь помогли одеть когда делали покрытие и я решила что мне хватит разминать ножки 😄 на педикюре оказалось что у меня есть бородавка, Анюта проконсультировала, начали удалять. Хотя в Москве ее просто спиливали со словами у вас обувь не такая и вообще это мозоль. Покрытие относилось идеально, дольше 3 недель не хожу длина раздражает) выбор дизайнов был богат, мастер все рассказал, показал, предложил. В конце сказали что нужно купить из домашнего ухода, Израильская фирма. Слышала про неё но дома не пользовалась. Тоже восторг, каждый раз теперь что то новое беру. А системы лояльности к клиентам? Карта клиента, акции предложения. Просто безумие, я в восторге от этого места. Как прекрасно что это был мой первый салон в Черногории. Я точно задержусь в нем навсегда 😍 идти сюда значит выбрать качество и безопасность. Смотрю что кто-то отзывался о ценах, но извините меня 40 евро за такое это просто ни что)', 'Ich bin erst seit kurzem in Montenegro und natürlich stellte sich die Nagelfrage sehr drängend. Wenn die eigenen schon fast abfallen, muss man überlegen, wohin man geht oder ob man alles abmacht😄 ich hatte wahnsinnige Angst, zu einheimischen Fachkräften zu gehen, weil ich Krankheiten, Schlampigkeit und schlechte Lackqualität befürchtete.  Über Insta habe ich den Salon gefunden, eine Weile beobachtet und gemerkt, dass ich hingehen will, wenigstens zum Ausprobieren. Alles sah sehr sauber aus, was für mich das Wichtigste ist. Und dann passierte einfach etwas Unglaubliches. Ich war in Moskau in vielen Studios und Salons, von mittleren bis zu sehr teuren, aber so etwas habe ich selbst dort nicht gesehen. Alles, absolut alles, was den Umgang mit dem Kunden betrifft, war perfekt. Die Empfangsdame angenehm, die Atmosphäre zauberhaft, Getränke, wie sie dir in den örtlichen Cafés nicht angeboten werden😄 die Fachkraft war sehr aufmerksam und sorgfältig. Sicherheit auf höchstem Niveau: Heißluftsterilisator, Ultraschallreiniger, Kraftpapier-Beutel. Man hat mir sogar angeboten, die Sterilisationsprotokolle anzuschauen. Und die Kundenorientierung? Absolut top: Fußmassage bei der Maniküre, Nacken-Schulter-Massage bei der Pediküre, Musik, Filme, was du willst. Man hat mir sogar die Schuhe angezogen, als der Lack aufgetragen wurde und ich beschlossen hatte, dass ich genug von der Fußgymnastik habe 😄 bei der Pediküre stellte sich heraus, dass ich eine Warze habe, Anjuta hat mich beraten, wir haben angefangen, sie zu entfernen. In Moskau hat man sie dagegen einfach abgeschliffen, mit den Worten, Ihre Schuhe seien nicht die richtigen und das sei sowieso nur ein Hühnerauge. Der Lack hielt perfekt, länger als 3 Wochen trage ich ihn nicht, weil mich die Länge stört) die Auswahl an Designs war reich, die Fachkraft hat alles erklärt, gezeigt, vorgeschlagen. Am Ende sagte man mir, was ich für die Heimpflege kaufen soll, eine israelische Firma. Ich hatte von ihr gehört, aber zu Hause nicht benutzt. Auch eine Begeisterung, jetzt nehme ich jedes Mal etwas Neues. Und die Kundenbindungsprogramme? Kundenkarte, Aktionen, Angebote. Einfach Wahnsinn, ich bin von diesem Ort begeistert. Wie schön, dass das mein erster Salon in Montenegro war. Ich bleibe hier bestimmt für immer 😍 hierher zu gehen heißt, Qualität und Sicherheit zu wählen. Ich sehe, dass jemand die Preise kommentiert hat, aber entschuldigen Sie mal, 40 Euro für so etwas ist einfach nichts)', 'Karadağ\'a geleli çok kısa bir süre oldu ve tabii tırnak meselesi çok acil hale geldi. Kendi tırnaklarınız neredeyse dökülüyorken nereye gideceğinizi ya da hepsini alıp almayacağınızı düşünmek zorundasınız😄 yerel uzmanlara gitmekten ölesiye korkuyordum, çünkü hastalıktan, özensizlikten, kalitesiz kaplamadan korkuyordum.  Salonu Insta üzerinden buldum, bir süre takip ettim ve gitmek, en azından denemek istediğimi anladım. Her şey çok temiz görünüyordu, bu da benim için en önemlisi. Ve sonra tam anlamıyla olağanüstü bir şey oldu. Moskova\'da orta segmentten yüksek fiyatlılara kadar birçok stüdyo ve salona gittim, ama böylesini orada bile görmedim. Müşteriyle çalışmaya dair her şey, kesinlikle her şey kusursuzdu. Resepsiyonist hoş, atmosfer büyülü, içecekler öyle ki yerel kafeler size onları sunmaz😄 uzman çok dikkatli ve özenliydi. Güvenlik en üst düzeyde: kuru hava sterilizatörü, ultrasonik yıkayıcı, kraft poşetler. Hatta sterilizasyon kayıtlarına bakmayı bile teklif ettiler. Müşteri odaklılık mı? Tam anlamıyla zirve: manikürde ayak masajı, pedikürde boyun-omuz masajı, müzik, filmler, ne isterseniz. Oje sürülürken, ben de artık ayaklarımı oynatmaktan bıktığıma karar verince ayakkabılarımı giymeme bile yardım ettiler 😄 pedikürde bir siğilim olduğu ortaya çıktı, Anjuta bana danışmanlık yaptı, almaya başladık. Oysa Moskova\'da onu ayakkabınız uygun değil, hem de bu sadece nasır diyerek öylece törpüleyip geçmişlerdi. Kaplama kusursuz durdu, 3 haftadan fazla taşımıyorum çünkü uzunluk beni rahatsız ediyor) tasarım seçenekleri zengindi, uzman her şeyi anlattı, gösterdi, önerdi. Sonunda ev bakımı için ne almam gerektiğini söylediler, İsrailli bir marka. Onu duymuştum ama ülkemde kullanmamıştım. O da bir harika, artık her seferinde yeni bir şey alıyorum. Müşteri sadakat sistemleri mi? Müşteri kartı, kampanyalar, teklifler. Tam bir çılgınlık, bu mekâna hayran kaldım. Karadağ\'daki ilk salonumun bu olması ne güzel. Kesinlikle sonsuza kadar burada kalacağım 😍 buraya gelmek kaliteyi ve güvenliği seçmek demek. Bakıyorum birileri fiyatlar hakkında yorum yapmış, ama affedersiniz, böyle bir şey için 40 euro hiçbir şey değil)',
    0, '2023-08-03 00:00:00'),

(@user_lyubov_vereschinskaya, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUR1MHBEV0dREAE',
    5, 'ru', 'Правда очень хорошее заведение с качественным сервисом и подходом к клиенту. Про бесплатный кофе и снеки уже писали, я упомяну что салон работает на дорогой израильской косметике, руки вам покроют профессиональными составами и отпустят домой с кремом Rituals на ладошках. Отсюда и цены на услуги, девушки. Я много где бывала и ходила с отлетевшими ногтями не раз, в iPODO покрытие стабильно держится месяц и я прихожу просто уже когда ногти становятся слишком длинными для меня.',
    'Zaista veoma dobra ustanova sa kvalitetnim servisom i pristupom klijentu. O besplatnoj kafi i snekovima su već pisali, ja ću spomenuti da salon radi sa skupom izraelskom kozmetikom, ruke će vam obraditi profesionalnim preparatima i pustiti vas kući sa Rituals kremom na dlanovima. Otuda i cijene usluga, djevojke. Bila sam na mnogo mjesta i ne jednom hodala sa ljuštećim noktima, u iPODO lak stabilno drži mjesec dana i dolazim prosto tek kad mi nokti postanu previše dugi.', 'Заиста веома добра установа са квалитетним сервисом и приступом клијенту. О бесплатној кафи и снековима су већ писали, ја ћу споменути да салон ради са скупом израелском козметиком, руке ће вам обрадити професионалним препаратима и пустити вас кући са Rituals кремом на длановима. Отуда и цијене услуга, дјевојке. Била сам на много мјеста и не једном ходала са љуштећим ноктима, у iPODO лак стабилно држи мјесец дана и долазим просто тек кад ми нокти постану превише дуги.', 'A really very good place with quality service and a good approach to the client. Others have already written about the free coffee and snacks, so I\'ll mention that the salon works with expensive Israeli cosmetics, your hands get treated with professional formulas and you\'re sent home with Rituals cream on your palms. Hence the prices for the services, ladies. I\'ve been to a lot of places and more than once walked around with chipped-off nails, at iPODO the coating consistently lasts a month and I only come back when my nails simply get too long for me.', 'Правда очень хорошее заведение с качественным сервисом и подходом к клиенту. Про бесплатный кофе и снеки уже писали, я упомяну что салон работает на дорогой израильской косметике, руки вам покроют профессиональными составами и отпустят домой с кремом Rituals на ладошках. Отсюда и цены на услуги, девушки. Я много где бывала и ходила с отлетевшими ногтями не раз, в iPODO покрытие стабильно держится месяц и я прихожу просто уже когда ногти становятся слишком длинными для меня.', 'Wirklich ein sehr guter Betrieb mit hochwertigem Service und guter Einstellung zum Kunden. Über den kostenlosen Kaffee und die Snacks wurde schon geschrieben, ich erwähne, dass der Salon mit teurer israelischer Kosmetik arbeitet, die Hände werden mit professionellen Präparaten behandelt und man schickt dich mit Rituals-Creme auf den Handflächen nach Hause. Daher auch die Preise für die Leistungen, meine Damen. Ich war an vielen Orten und lief mehr als einmal mit abgeplatzten Nägeln herum, bei iPODO hält der Lack stabil einen Monat und ich komme einfach erst dann, wenn die Nägel mir zu lang werden.', 'Gerçekten kaliteli servisi ve müşteriye yaklaşımıyla çok iyi bir yer. Ücretsiz kahve ve atıştırmalıklar hakkında zaten yazmışlar, ben salonun pahalı İsrail kozmetiğiyle çalıştığını belirteyim, ellerinizi profesyonel ürünlerle bakıma alıyorlar ve avuçlarınızda Rituals kremiyle eve gönderiyorlar. Hizmet fiyatları da bu yüzden, kızlar. Çok yere gittim ve birçok kez dökülmüş tırnaklarla dolaştım, iPODO\'da kaplama istikrarlı biçimde bir ay duruyor ve ben sadece tırnaklarım bana fazla uzun gelmeye başladığında geliyorum.',
    0, '2023-08-03 00:00:00'),

(@user_1_2, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUR1bkxLdVp3EAE',
    5, 'ru', 'Очень понравилось, педикюр , предложили все напитки мира, очень качественно приняли гостя:)
Про цены , видимо дорого, хотя не уверен, не специалист ;)',
    'Veoma mi se svidjelo, pedikir , ponudili su sve napitke svijeta, gosta su primili veoma kvalitetno:)
Što se cijena tiče , vjerovatno skupo, mada nisam siguran, nisam stručnjak ;)', 'Веома ми се свидјело, педикир , понудили су све напитке свијета, госта су примили веома квалитетно:)
Што се цијена тиче , вјероватно скупо, мада нисам сигуран, нисам стручњак ;)', 'Really liked it, the pedicure, they offered every drink in the world, the guest was looked after really well:)
As for the prices, apparently expensive, though I\'m not sure, I\'m no expert ;)', 'Очень понравилось, педикюр , предложили все напитки мира, очень качественно приняли гостя:)
Про цены , видимо дорого, хотя не уверен, не специалист ;)', 'Hat mir sehr gefallen, die Pediküre, man hat mir alle Getränke der Welt angeboten, der Gast wurde wirklich gut empfangen:)
Zu den Preisen, offenbar teuer, obwohl ich nicht sicher bin, bin kein Fachmann ;)', 'Çok beğendim, pedikür , dünyanın bütün içeceklerini ikram ettiler, misafiri gerçekten çok iyi karşıladılar:)
Fiyatlara gelince , belli ki pahalı, gerçi emin değilim, uzman değilim ;)',
    0, '2023-08-03 00:00:00'),

(@user_yulia_prosto, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUN1cHItT29nRRAB',
    2, 'ru', 'К сожалению, остались неприятные впечатления от посещения Анюты. Было много нехороших моментов, а в общем это выглядело, как клиента хотят получить любой ценой и максимум на нём заработать.  Цены на услуги завышены (возможно, в Черногории во многом так), меня пытались напугать, что в других местах мне "мастерицы наделают", что многие мастера маникюра пользуются китайскими сухожарами, которые ничего не стерилизуют, Анюта хотела продать мазь, которой "аналогов нет" и др. Не рекомендую. Хорошее впечатление осталось от девушки на ресепшн.',
    'Nažalost, od posjete Anjuti ostao je neprijatan osjećaj. Bilo je mnogo loših momenata, a u cjelini je izgledalo kao da klijenta žele da dobiju po svaku cijenu i da na njemu maksimalno zarade.  Cijene usluga su previsoke (možda je u Crnoj Gori u mnogo čemu tako), pokušali su da me uplaše da će mi na drugim mjestima "majstorice sve upropastiti", da mnogi majstori manikira koriste kineske suhe sterilizatore koji ništa ne sterilišu, Anjuta je htjela da mi proda mast kojoj "nema ravne" i sl. Ne preporučujem. Dobar dojam je ostavila djevojka na recepciji.', 'Нажалост, од посјете Ањути остао је непријатан осјећај. Било је много лоших момената, а у цјелини је изгледало као да клијента желе да добију по сваку цијену и да на њему максимално зараде.  Цијене услуга су превисоке (можда је у Црној Гори у много чему тако), покушали су да ме уплаше да ће ми на другим мјестима "мајсторице све упропастити", да многи мајстори маникира користе кинеске суве стерилизаторе који ништа не стерилишу, Ањута је хтјела да ми прода маст којој "нема равне" и сл. Не препоручујем. Добар дојам је оставила дјевојка на рецепцији.', 'Unfortunately, the visit to Anjuta left an unpleasant impression. There were a lot of bad moments, and on the whole it looked like they want to land a client at any cost and make the maximum money out of them.  The prices for the services are inflated (maybe that\'s how it is in Montenegro in many ways), they tried to scare me that at other places "the girls will wreck my nails", that many manicurists use Chinese dry-heat sterilisers that don\'t sterilise anything, Anjuta wanted to sell me an ointment that "has no equivalent" and so on. I don\'t recommend it. The girl at the reception desk left a good impression.', 'К сожалению, остались неприятные впечатления от посещения Анюты. Было много нехороших моментов, а в общем это выглядело, как клиента хотят получить любой ценой и максимум на нём заработать.  Цены на услуги завышены (возможно, в Черногории во многом так), меня пытались напугать, что в других местах мне "мастерицы наделают", что многие мастера маникюра пользуются китайскими сухожарами, которые ничего не стерилизуют, Анюта хотела продать мазь, которой "аналогов нет" и др. Не рекомендую. Хорошее впечатление осталось от девушки на ресепшн.', 'Leider hat der Besuch bei Anjuta einen unangenehmen Eindruck hinterlassen. Es gab viele unschöne Momente, und insgesamt sah es so aus, als wolle man den Kunden um jeden Preis gewinnen und maximal an ihm verdienen.  Die Preise für die Leistungen sind überhöht (vielleicht ist das in Montenegro vielfach so), man hat versucht, mir Angst zu machen, dass mir andernorts "die Damen alles ruinieren", dass viele Nagelfachkräfte chinesische Heißluftsterilisatoren benutzen, die nichts sterilisieren, Anjuta wollte mir eine Salbe verkaufen, zu der es "keine Alternative gibt", usw. Ich empfehle es nicht. Einen guten Eindruck hat die junge Frau am Empfang gemacht.', 'Ne yazık ki Anjuta\'ya yaptığım ziyaretten hoş olmayan bir izlenim kaldı. Pek çok kötü an oldu, genel olarak da müşteriyi ne pahasına olursa olsun elde etmek ve ondan azami kazanç sağlamak istercesine görünüyordu.  Hizmet fiyatları fahiş (belki Karadağ\'da pek çok konuda böyledir), başka yerlerde "kızların her şeyi berbat edeceği", pek çok manikürcünün hiçbir şeyi sterilize etmeyen Çin malı kuru hava sterilizatörü kullandığı söylenerek beni korkutmaya çalıştılar, Anjuta "muadili olmayan" bir merhem satmak istedi vs. Tavsiye etmiyorum. Resepsiyondaki kız iyi bir izlenim bıraktı.',
    0, '2022-08-03 00:00:00'),

(@user_olga_ovchinnikova, @clinic_id, NULL, 'google_maps',
    'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURPNm9ldXZ3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: Insert review replies (owner responses)
-- ═══════════════════════════════════════════════════════════════

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSV05HTlRTMVprTTFGdFZtbDJaMFJRUlhOR2IyYxAB'),
  'clinic', @clinic_id,
  'Анна, благодарим Вас за уточнение!

После публикации Вашей оценки мы подробно разобрали ситуацию: 
подняли историю Ваших записей и посещений, переписку, а также просмотрели внутреннюю видеофиксацию за дни Ваших визитов.

Вы действительно являетесь нашим клиентом: Вы посещали iPODO как минимум, дважды..

Именно поэтому оценка в 2 звезды из 5 вызвала у нас вполне закономерный вопрос.

Человек, который после первого посещения (причём ещё в мае) - в итоге возвращается повторно и продолжает записываться в наш Центр, - безусловно демонстрирует своим поведением положительное отношение к нашим услугам. 

Благодарим за выбор бьюти-лидера индустрии красоты iPODO•centre 

// ..Искренне верим, что Вы клиент, который понимает разницу & ценит своё здоровье!..//

Поэтому нам хотелось бы понять, что именно в качестве нашей работы «вдруг» оценилось Вами в «две звезды»???..

Мы внимательно изучили ситуацию и пока обнаружили только одно обстоятельство, которое вызвало Ваше недовольство во время последней коммуникации, — это первое (!) за 3года увеличение стоимости услуг (в связи с глобальным расширением iPODO до 300кв.м. и просто беспрецедентным обновлением всего оборудования на 100% европейский PREMIUM LUX из Германии, Франции, Испании, Англии, Нидерландов, Японии и тд.
(эксклюзивного! не имеющего аналогов в Черногории)

При этом информация об изменении стоимости была заранее направлена клиентам за сутки до визита - об подтверждении (и, кстати, Вы подтвердили свою запись)

Более того!
Каждый клиент ВСЕГДА помимо 10% кэшбэка имеет уникальную возможность обслуживаться со скидкой -30!% на ВСЕ УСЛУГИ + сейчас в День Визита на любую услугу - мы дополнительно ДАРИМ ещё и WOW! Комплимент-Услугу «УКЛАДКА У HAIR-СТИЛИСТОВ» на новейшем японском оборудовании “TAKARA BELMONT”!!! 

..Если у Вас имеются конкретные претензии к качеству выполненной работы, профессионализму специалиста, стерильности, сервису или результату процедуры — пожалуйста, обозначьте их. Для нас это действительно важно, и каждый такой пункт мы готовы предметно разобрать.

Если же таких замечаний нет, тогда возникает другой вопрос: является ли оценка в две звезды оценкой качества нашей работы или всё-таки эмоциональной реакцией на изменение стоимости услуги?

Иногда непосредственное недовольство конкретным обстоятельством действительно вызывает эмоциональный всплеск, в момент которого общая оценка опыта становится значительно более негативной, чем сам предыдущий опыт человека. Именно поэтому мы и предлагаем отделить эмоцию, возникшую в конкретный момент, от фактов.

В Вашем случае факты достаточно просты: два состоявшихся посещения, последующие повторные записи и отсутствие зафиксированных претензий к качеству оказанных услуг. Единственное зафиксированное недовольство возникло в связи с новой стоимостью.

Поэтому будем признательны, если Вы конкретизируете: за что именно были сняты три звезды???

Нам кажется принципиально важным это уточнение, поскольку люди, читающие отзыв, воспринимают две звезды прежде всего как оценку качества работы iPODO, а не как выражение личного отношения клиента к изменению цены.

Мы с уважением относимся к любому мнению — в том числе негативному. Но считаем, что объективная оценка предполагает способность разделять качество полученной услуги, собственные ожидания и эмоциональную реакцию на обстоятельства, которые человеку не понравились.

Главный приоритет для нас - это Счастливый Клиент и мы в свою очередь приглашаем Вас за счёт iPODO (на Ваш выбор) - Маникюр или Педикюр в формате Призёра Европы 🏆 

С Уважением, Ваш iPODO • DUKLEY', 'ru',
  'Anna, zahvaljujemo Vam na pojašnjenju!

Nakon objave Vaše ocjene detaljno smo analizirali situaciju: 
podigli smo istoriju Vaših zakazivanja i posjeta, prepisku, a pregledali smo i internu video-evidenciju za dane Vaših dolazaka.

Vi zaista jeste naš klijent: iPODO ste posjetili najmanje dva puta..

Upravo zato je ocjena od 2 zvjezdice od 5 kod nas izazvala potpuno logično pitanje.

Osoba koja se nakon prve posjete (i to još u maju) - na kraju vrati ponovo i nastavi da zakazuje termine u našem Centru, - nesumnjivo svojim ponašanjem pokazuje pozitivan odnos prema našim uslugama. 

Hvala Vam što ste izabrali lidera industrije ljepote iPODO•centre 

// ..Iskreno vjerujemo da ste Vi klijent koji razumije razliku & cijeni svoje zdravlje!..//

Zato bismo željeli da razumijemo šta ste to konkretno u kvalitetu našeg rada «odjednom» ocijenili sa «dvije zvjezdice»???..

Pažljivo smo proučili situaciju i za sada smo pronašli samo jednu okolnost koja je izazvala Vaše nezadovoljstvo tokom poslednje komunikacije, — a to je prvo (!) povećanje cijena usluga za 3godine (u vezi sa globalnim širenjem iPODO na 300kv.m. i prosto besprecedentnim obnavljanjem cijele opreme na 100% evropski PREMIUM LUX iz Njemačke, Francuske, Španije, Engleske, Holandije, Japana itd.
(ekskluzivne! bez ikakvog analoga u Crnoj Gori)

Pri tome je informacija o izmjeni cijena klijentima poslata unaprijed, dan prije dolaska - uz potvrdu termina (i, uzgred, Vi ste svoj termin potvrdili)

Štaviše!
Svaki klijent UVIJEK, pored 10% cashback-a, ima jedinstvenu mogućnost da bude uslužen sa popustom od -30!% na SVE USLUGE + sada na Dan Dolaska, na bilo koju uslugu - dodatno POKLANJAMO i WOW! Kompliment-Uslugu «FENIRANJE KOD HAIR-STILISTA» na najnovijoj japanskoj opremi “TAKARA BELMONT”!!! 

..Ako imate konkretne primjedbe na kvalitet obavljenog rada, profesionalnost specijaliste, sterilnost, uslugu ili rezultat procedure — molimo Vas, navedite ih. Za nas je to zaista važno i svaku takvu stavku spremni smo da konkretno razmotrimo.

Ako takvih primjedbi nema, onda se postavlja drugo pitanje: da li je ocjena od dvije zvjezdice ocjena kvaliteta našeg rada ili je ipak emocionalna reakcija na promjenu cijene usluge?

Ponekad neposredno nezadovoljstvo konkretnom okolnošću zaista izazove emocionalni talas, u čijem trenutku ukupna ocjena iskustva postane znatno negativnija od samog prethodnog iskustva te osobe. Upravo zato i predlažemo da se emocija nastala u konkretnom trenutku odvoji od činjenica.

U Vašem slučaju činjenice su prilično jednostavne: dvije obavljene posjete, kasnija ponovna zakazivanja i nepostojanje zabilježenih primjedbi na kvalitet pruženih usluga. Jedino zabilježeno nezadovoljstvo nastalo je u vezi s novom cijenom.

Zato bismo Vam bili zahvalni ako precizirate: zbog čega su konkretno oduzete tri zvjezdice???

Čini nam se principijelno važnim to pojašnjenje, jer ljudi koji čitaju recenziju dvije zvjezdice prije svega shvataju kao ocjenu kvaliteta rada iPODO, a ne kao izraz ličnog stava klijenta prema promjeni cijene.

Sa uvažavanjem se odnosimo prema svakom mišljenju — uključujući i negativno. Ali smatramo da objektivna ocjena podrazumijeva sposobnost da se razdvoje kvalitet dobijene usluge, sopstvena očekivanja i emocionalna reakcija na okolnosti koje se čovjeku nisu svidjele.

Glavni prioritet za nas - to je Sretan Klijent i mi Vas sa svoje strane pozivamo na račun iPODO (po Vašem izboru) - na Manikir ili Pedikir u formatu Evropskog Laureata 🏆 

S Uvažavanjem, Vaš iPODO • DUKLEY', 'Ана, захваљујемо Вам на појашњењу!

Након објаве Ваше оцјене детаљно смо анализирали ситуацију: 
подигли смо историју Ваших заказивања и посјета, преписку, а прегледали смо и интерну видео-евиденцију за дане Ваших долазака.

Ви заиста јесте наш клијент: iPODO сте посјетили најмање два пута..

Управо зато је оцјена од 2 звјездице од 5 код нас изазвала потпуно логично питање.

Особа која се након прве посјете (и то још у мају) - на крају врати поново и настави да заказује термине у нашем Центру, - несумњиво својим понашањем показује позитиван однос према нашим услугама. 

Хвала Вам што сте изабрали лидера индустрије љепоте iPODO•centre 

// ..Искрено вјерујемо да сте Ви клијент који разумије разлику & цијени своје здравље!..//

Зато бисмо жељели да разумијемо шта сте то конкретно у квалитету нашег рада «одједном» оцијенили са «двије звјездице»???..

Пажљиво смо проучили ситуацију и за сада смо пронашли само једну околност која је изазвала Ваше незадовољство током последње комуникације, — а то је прво (!) повећање цијена услуга за 3године (у вези са глобалним ширењем iPODO на 300кв.м. и просто беспрецедентним обнављањем цијеле опреме на 100% европски PREMIUM LUX из Њемачке, Француске, Шпаније, Енглеске, Холандије, Јапана итд.
(ексклузивне! без икаквог аналога у Црној Гори)

При томе је информација о измјени цијена клијентима послата унапријед, дан прије доласка - уз потврду термина (и, узгред, Ви сте свој термин потврдили)

Штавише!
Сваки клијент УВИЈЕК, поред 10% cashback-а, има јединствену могућност да буде услужен са попустом од -30!% на СВЕ УСЛУГЕ + сада на Дан Доласка, на било коју услугу - додатно ПОКЛАЊАМО и WOW! Комплимент-Услугу «ФЕНИРАЊЕ КОД HAIR-СТИЛИСТА» на најновијој јапанској опреми “TAKARA BELMONT”!!! 

..Ако имате конкретне примједбе на квалитет обављеног рада, професионалност специјалисте, стерилност, услугу или резултат процедуре — молимо Вас, наведите их. За нас је то заиста важно и сваку такву ставку спремни смо да конкретно размотримо.

Ако таквих примједби нема, онда се поставља друго питање: да ли је оцјена од двије звјездице оцјена квалитета нашег рада или је ипак емоционална реакција на промјену цијене услуге?

Понекад непосредно незадовољство конкретном околношћу заиста изазове емоционални талас, у чијем тренутку укупна оцјена искуства постане знатно негативнија од самог претходног искуства те особе. Управо зато и предлажемо да се емоција настала у конкретном тренутку одвоји од чињеница.

У Вашем случају чињенице су прилично једноставне: двије обављене посјете, каснија поновна заказивања и непостојање забиљежених примједби на квалитет пружених услуга. Једино забиљежено незадовољство настало је у вези с новом цијеном.

Зато бисмо Вам били захвални ако прецизирате: због чега су конкретно одузете три звјездице???

Чини нам се принципијелно важним то појашњење, јер људи који читају рецензију двије звјездице прије свега схватају као оцјену квалитета рада iPODO, а не као израз личног става клијента према промјени цијене.

Са уважавањем се односимо према сваком мишљењу — укључујући и негативно. Али сматрамо да објективна оцјена подразумијева способност да се раздвоје квалитет добијене услуге, сопствена очекивања и емоционална реакција на околности које се човјеку нису свидјеле.

Главни приоритет за нас - то је Сретан Клијент и ми Вас са своје стране позивамо на рачун iPODO (по Вашем избору) - на Маникир или Педикир у формату Европског Лауреата 🏆 

С Уважавањем, Ваш iPODO • DUKLEY', 'Anna, thank you for the clarification!

After your rating was published we went through the situation in detail: 
we pulled up the history of your bookings and visits, our correspondence, and also reviewed the internal video records for the days of your visits.

You are indeed our client: you have visited iPODO at least twice..

That is exactly why a rating of 2 stars out of 5 raised a perfectly legitimate question for us.

A person who, after a first visit (back in May, no less) - ends up coming back again and keeps booking appointments at our Centre, - is undoubtedly demonstrating through her behaviour a positive attitude towards our services. 

Thank you for choosing the beauty industry leader iPODO•centre 

// ..We sincerely believe that you are a client who understands the difference & values her health!..//

So we would like to understand what exactly about the quality of our work “suddenly” earned “two stars” from you???..

We have studied the situation carefully and so far have found only one circumstance that caused your dissatisfaction during our last exchange, — and that is the first (!) increase in the price of our services in 3 years (in connection with the global expansion of iPODO to 300 sq.m. and the simply unprecedented renewal of all equipment to 100% European PREMIUM LUX from Germany, France, Spain, England, the Netherlands, Japan, etc.
(exclusive! with no equivalent in Montenegro)

And yet the information about the price change was sent to clients in advance, a day before the visit - together with the confirmation (and, by the way, you did confirm your appointment)

What\'s more!
Every client ALWAYS has, on top of 10% cashback, the unique opportunity to be served with a -30!% discount on ALL SERVICES + right now, on the Day of the Visit, with any service - we additionally GIVE a WOW! Compliment-Service “STYLING WITH OUR HAIR STYLISTS” on the very latest Japanese “TAKARA BELMONT” equipment!!! 

..If you have specific complaints about the quality of the work performed, the professionalism of the specialist, the sterility, the service or the result of the procedure — please state them. This genuinely matters to us, and we are ready to go into every such point in substance.

If there are no such remarks, then another question arises: is a two-star rating an assessment of the quality of our work, or is it after all an emotional reaction to a change in the price of a service?

Sometimes immediate dissatisfaction with one particular circumstance really does trigger an emotional surge, and in that moment the overall assessment of the experience becomes considerably more negative than the person\'s actual previous experience. That is precisely why we suggest separating the emotion that arose at a particular moment from the facts.

In your case the facts are quite simple: two visits that took place, subsequent repeat bookings, and no recorded complaints about the quality of the services provided. The only recorded dissatisfaction arose in connection with the new prices.

So we would be grateful if you could be specific: what exactly were the three stars taken off for???

This clarification seems fundamentally important to us, because people reading a review perceive two stars first and foremost as an assessment of the quality of iPODO\'s work, and not as an expression of a client\'s personal attitude to a price change.

We treat every opinion with respect — including a negative one. But we believe that an objective assessment presupposes the ability to separate the quality of the service received, one\'s own expectations, and an emotional reaction to circumstances that a person did not like.

Our top priority is a Happy Client, and we in turn invite you, at iPODO\'s expense (your choice) - to a Manicure or a Pedicure in the format of a European Award Winner 🏆 

With Respect, your iPODO • DUKLEY', 'Анна, благодарим Вас за уточнение!

После публикации Вашей оценки мы подробно разобрали ситуацию: 
подняли историю Ваших записей и посещений, переписку, а также просмотрели внутреннюю видеофиксацию за дни Ваших визитов.

Вы действительно являетесь нашим клиентом: Вы посещали iPODO как минимум, дважды..

Именно поэтому оценка в 2 звезды из 5 вызвала у нас вполне закономерный вопрос.

Человек, который после первого посещения (причём ещё в мае) - в итоге возвращается повторно и продолжает записываться в наш Центр, - безусловно демонстрирует своим поведением положительное отношение к нашим услугам. 

Благодарим за выбор бьюти-лидера индустрии красоты iPODO•centre 

// ..Искренне верим, что Вы клиент, который понимает разницу & ценит своё здоровье!..//

Поэтому нам хотелось бы понять, что именно в качестве нашей работы «вдруг» оценилось Вами в «две звезды»???..

Мы внимательно изучили ситуацию и пока обнаружили только одно обстоятельство, которое вызвало Ваше недовольство во время последней коммуникации, — это первое (!) за 3года увеличение стоимости услуг (в связи с глобальным расширением iPODO до 300кв.м. и просто беспрецедентным обновлением всего оборудования на 100% европейский PREMIUM LUX из Германии, Франции, Испании, Англии, Нидерландов, Японии и тд.
(эксклюзивного! не имеющего аналогов в Черногории)

При этом информация об изменении стоимости была заранее направлена клиентам за сутки до визита - об подтверждении (и, кстати, Вы подтвердили свою запись)

Более того!
Каждый клиент ВСЕГДА помимо 10% кэшбэка имеет уникальную возможность обслуживаться со скидкой -30!% на ВСЕ УСЛУГИ + сейчас в День Визита на любую услугу - мы дополнительно ДАРИМ ещё и WOW! Комплимент-Услугу «УКЛАДКА У HAIR-СТИЛИСТОВ» на новейшем японском оборудовании “TAKARA BELMONT”!!! 

..Если у Вас имеются конкретные претензии к качеству выполненной работы, профессионализму специалиста, стерильности, сервису или результату процедуры — пожалуйста, обозначьте их. Для нас это действительно важно, и каждый такой пункт мы готовы предметно разобрать.

Если же таких замечаний нет, тогда возникает другой вопрос: является ли оценка в две звезды оценкой качества нашей работы или всё-таки эмоциональной реакцией на изменение стоимости услуги?

Иногда непосредственное недовольство конкретным обстоятельством действительно вызывает эмоциональный всплеск, в момент которого общая оценка опыта становится значительно более негативной, чем сам предыдущий опыт человека. Именно поэтому мы и предлагаем отделить эмоцию, возникшую в конкретный момент, от фактов.

В Вашем случае факты достаточно просты: два состоявшихся посещения, последующие повторные записи и отсутствие зафиксированных претензий к качеству оказанных услуг. Единственное зафиксированное недовольство возникло в связи с новой стоимостью.

Поэтому будем признательны, если Вы конкретизируете: за что именно были сняты три звезды???

Нам кажется принципиально важным это уточнение, поскольку люди, читающие отзыв, воспринимают две звезды прежде всего как оценку качества работы iPODO, а не как выражение личного отношения клиента к изменению цены.

Мы с уважением относимся к любому мнению — в том числе негативному. Но считаем, что объективная оценка предполагает способность разделять качество полученной услуги, собственные ожидания и эмоциональную реакцию на обстоятельства, которые человеку не понравились.

Главный приоритет для нас - это Счастливый Клиент и мы в свою очередь приглашаем Вас за счёт iPODO (на Ваш выбор) - Маникюр или Педикюр в формате Призёра Европы 🏆 

С Уважением, Ваш iPODO • DUKLEY', 'Anna, wir danken Ihnen für die Klarstellung!

Nach der Veröffentlichung Ihrer Bewertung haben wir die Situation ausführlich aufgearbeitet: 
wir haben die Historie Ihrer Terminbuchungen und Besuche sowie den Schriftverkehr herangezogen und außerdem die interne Videoaufzeichnung der Tage Ihrer Besuche angesehen.

Sie sind tatsächlich unsere Kundin: Sie waren mindestens zweimal bei iPODO..

Genau deshalb hat die Bewertung von 2 von 5 Sternen bei uns eine völlig berechtigte Frage aufgeworfen.

Ein Mensch, der nach dem ersten Besuch (und zwar noch im Mai) - schließlich erneut zurückkommt und weiterhin Termine in unserem Zentrum bucht, - zeigt mit seinem Verhalten zweifellos eine positive Einstellung zu unseren Leistungen. 

Danke, dass Sie sich für den Beauty-Marktführer der Schönheitsindustrie iPODO•centre entschieden haben 

// ..Wir glauben aufrichtig, dass Sie eine Kundin sind, die den Unterschied versteht & ihre Gesundheit schätzt!..//

Deshalb würden wir gern verstehen, was genau an der Qualität unserer Arbeit von Ihnen „plötzlich“ mit „zwei Sternen“ bewertet wurde???..

Wir haben die Situation aufmerksam geprüft und bisher nur einen einzigen Umstand gefunden, der bei der letzten Kommunikation Ihren Unmut ausgelöst hat, — nämlich die erste (!) Preiserhöhung seit 3Jahren (im Zusammenhang mit der umfassenden Erweiterung von iPODO auf 300qm und der einfach beispiellosen Erneuerung der gesamten Ausstattung auf 100% europäisches PREMIUM LUX aus Deutschland, Frankreich, Spanien, England, den Niederlanden, Japan usw.
(exklusiv! ohne Vergleich in Montenegro)

Dabei wurde die Information über die Preisänderung den Kunden im Voraus, einen Tag vor dem Besuch, zugesandt - zusammen mit der Terminbestätigung (und übrigens haben Sie Ihren Termin bestätigt)

Mehr noch!
Jede Kundin hat IMMER neben 10% Cashback die einmalige Möglichkeit, mit -30!% Rabatt auf ALLE LEISTUNGEN bedient zu werden + jetzt am Tag des Besuchs schenken wir zu jeder Leistung zusätzlich noch eine WOW! Kompliment-Leistung „STYLING BEI DEN HAIR-STYLISTEN“ an der neuesten japanischen Ausstattung “TAKARA BELMONT”!!! 

..Wenn Sie konkrete Beanstandungen an der Qualität der ausgeführten Arbeit, der Professionalität der Fachkraft, der Sterilität, dem Service oder dem Ergebnis der Behandlung haben — bitte benennen Sie sie. Für uns ist das wirklich wichtig, und jeden solchen Punkt sind wir bereit, sachlich zu prüfen.

Wenn es solche Beanstandungen aber nicht gibt, dann stellt sich eine andere Frage: ist eine Bewertung mit zwei Sternen eine Bewertung der Qualität unserer Arbeit oder doch eine emotionale Reaktion auf die Preisänderung?

Manchmal löst unmittelbarer Unmut über einen konkreten Umstand tatsächlich einen emotionalen Ausbruch aus, in dessen Moment die Gesamtbewertung der Erfahrung deutlich negativer wird als die vorherige Erfahrung des Menschen selbst. Genau deshalb schlagen wir vor, die in einem konkreten Moment entstandene Emotion von den Fakten zu trennen.

In Ihrem Fall sind die Fakten recht einfach: zwei stattgefundene Besuche, anschließende weitere Terminbuchungen und keine dokumentierten Beanstandungen an der Qualität der erbrachten Leistungen. Der einzige dokumentierte Unmut entstand im Zusammenhang mit dem neuen Preis.

Deshalb wären wir dankbar, wenn Sie konkretisieren würden: wofür genau wurden drei Sterne abgezogen???

Uns erscheint diese Klarstellung grundlegend wichtig, denn Menschen, die eine Bewertung lesen, verstehen zwei Sterne vor allem als Bewertung der Arbeitsqualität von iPODO und nicht als Ausdruck der persönlichen Haltung einer Kundin zu einer Preisänderung.

Wir respektieren jede Meinung — auch eine negative. Wir sind jedoch der Ansicht, dass eine objektive Bewertung die Fähigkeit voraussetzt, die Qualität der erhaltenen Leistung, die eigenen Erwartungen und die emotionale Reaktion auf Umstände, die einem nicht gefallen haben, voneinander zu trennen.

Oberste Priorität ist für uns ein Glücklicher Kunde, und wir laden Sie unsererseits auf Kosten von iPODO ein (nach Ihrer Wahl) - zu einer Maniküre oder Pediküre im Format eines Europa-Preisträgers 🏆 

Mit Respekt, Ihr iPODO • DUKLEY', 'Anna, açıklamanız için teşekkür ederiz!

Puanınız yayınlandıktan sonra durumu ayrıntılı olarak ele aldık: 
randevu ve ziyaret geçmişinizi, yazışmaları çıkardık, ayrıca ziyaret ettiğiniz günlere ait iç video kayıtlarını izledik.

Gerçekten müşterimizsiniz: iPODO\'yu en az iki kez ziyaret ettiniz..

İşte tam bu yüzden 5 üzerinden 2 yıldızlık puan bizde son derece haklı bir soru uyandırdı.

İlk ziyaretinden sonra (hem de daha mayıs ayında) - sonunda yeniden geri dönen ve Merkezimize randevu almayı sürdüren bir insan, - davranışıyla hizmetlerimize karşı olumlu bir tutum sergilediğini kuşkusuz göstermektedir. 

Güzellik sektörünün beauty lideri iPODO•centre\'ı seçtiğiniz için teşekkür ederiz 

// ..Farkı anlayan & sağlığına değer veren bir müşteri olduğunuza içtenlikle inanıyoruz!..//

Bu yüzden işimizin kalitesinde tam olarak neyin “bir anda” sizin tarafınızdan “iki yıldız” olarak değerlendirildiğini anlamak isterdik???..

Durumu dikkatle inceledik ve şimdilik son iletişimimiz sırasında memnuniyetsizliğinize yol açan tek bir husus bulduk, — o da 3yıl içinde ilk (!) hizmet fiyatı artışı (iPODO\'nun 300m²\'ye kadar kapsamlı büyümesi ve tüm ekipmanın Almanya, Fransa, İspanya, İngiltere, Hollanda, Japonya vb. ülkelerden gelen %100 Avrupa PREMIUM LUX ürünlerle görülmemiş şekilde yenilenmesi nedeniyle
(eşsiz! Karadağ\'da benzeri olmayan)

Ayrıca fiyat değişikliğine ilişkin bilgi müşterilere ziyaretten bir gün önce, randevu onayıyla birlikte önceden gönderildi (ve bu arada, randevunuzu onayladınız)

Dahası!
Her müşteri %10 cashback\'in yanı sıra HER ZAMAN TÜM HİZMETLERDE -30!% indirimle hizmet alma ayrıcalığına sahiptir + şimdi Ziyaret Günü\'nde herhangi bir hizmete ek olarak, en yeni Japon “TAKARA BELMONT” ekipmanıyla yapılan “HAIR-STYLIST\'LERDE SAÇ ŞEKİLLENDİRME” WOW! Kompliman-Hizmetini de HEDİYE EDİYORUZ!!! 

..Yapılan işin kalitesi, uzmanın profesyonelliği, sterilizasyon, hizmet ya da uygulamanın sonucuyla ilgili somut şikâyetleriniz varsa — lütfen bunları belirtin. Bu bizim için gerçekten önemli ve böyle her maddeyi somut olarak ele almaya hazırız.

Eğer böyle bir eleştiriniz yoksa, o zaman başka bir soru ortaya çıkıyor: iki yıldızlık puan işimizin kalitesinin bir değerlendirmesi mi, yoksa yine de hizmet fiyatındaki değişime duygusal bir tepki mi?

Bazen belirli bir duruma yönelik anlık memnuniyetsizlik gerçekten duygusal bir dalgalanmaya yol açar ve o anda deneyimin genel değerlendirmesi, kişinin önceki deneyiminden çok daha olumsuz hâle gelir. İşte tam bu yüzden belirli bir anda doğan duyguyu olgulardan ayırmayı öneriyoruz.

Sizin durumunuzda olgular oldukça basit: gerçekleşmiş iki ziyaret, ardından yeniden alınan randevular ve sunulan hizmetlerin kalitesine dair kayda geçmiş hiçbir şikâyetin olmaması. Kayda geçen tek memnuniyetsizlik yeni fiyatla ilgili olarak ortaya çıktı.

Bu yüzden şunu netleştirirseniz memnun oluruz: üç yıldız tam olarak ne için düşürüldü???

Bu açıklama bize ilkesel olarak önemli görünüyor, çünkü yorumu okuyan insanlar iki yıldızı her şeyden önce iPODO\'nun iş kalitesinin bir değerlendirmesi olarak algılıyor, müşterinin fiyat değişikliğine dair kişisel tutumunun bir ifadesi olarak değil.

Her görüşe — olumsuz olana da — saygıyla yaklaşıyoruz. Ancak objektif bir değerlendirmenin, alınan hizmetin kalitesini, kişinin kendi beklentilerini ve hoşuna gitmeyen durumlara verdiği duygusal tepkiyi birbirinden ayırabilme yeteneğini gerektirdiğini düşünüyoruz.

Bizim için en büyük öncelik Mutlu Müşteridir ve biz de kendi adımıza sizi iPODO\'nun ikramı olarak (seçim sizin) - Avrupa Ödüllü formatta bir Manikür ya da Pedikür\'e davet ediyoruz 🏆 

Saygılarımızla, sizin iPODO • DUKLEY\'iniz',
  'google_maps', NULL)
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT210eVZTMUxNMHh1VTFSclgwaFVVa2xIYzA5WmMxRRAB'),
  'clinic', @clinic_id,
  'Благодарим Вас за отзыв.

Давайте проясним ситуацию -

В нашем Центре для каждой процедуры ведётся фото и видео-фиксация, поэтому мы всегда можем объективно восстановить ход событий, плюс по каждому посещению сохраняется история.

Вы были записаны на маникюр с покрытием (процедура на 1,5 часа), однако по приезду выяснилось, что Вам требуется наращивание ногтей — процедура, занимающая около 3 часов.. При этом, к сожалению, Вы опоздали на 30 минут.. (очевидно, что выполнить трёхчасовую процедуру за оставшийся час физически невозможно)

Несмотря на это - мы предложили все возможные варианты решения: или выполнить услугу, соответствующую записи, или перенести наращивание на ближайшее удобное Вам время. 
К сожалению, ни один из вариантов Вам не подошёл..

Изучив фото-фиксацию состояния ногтей до процедуры, мы также увидели характерные признаки регулярной механической травматизации Вами ногтевой пластины.. - что, как понимаете, однозначно существенно влияет на стойкость любого искусственного материала независимо от квалификации мастера.

Наш центр работает по предварительной записи, и, учитывая высокий кругло-годичный спрос на услуги, мы обязаны соблюдать регламент времени и уважать записи всех наших клиентов. Именно поэтому мы никогда не сокращаем технологию выполнения процедуры в ущерб её качеству.

С Уважением, iPODO • DUKLEY 

// ..для тех, кто понимает разницу & ценит своё здоровье //', 'ru',
  'Zahvaljujemo Vam na recenziji.

Da razjasnimo situaciju -

U našem Centru se za svaku proceduru vodi foto i video-evidencija, tako da uvijek možemo objektivno rekonstruisati tok događaja, a osim toga za svaku posjetu se čuva istorija.

Bili ste zakazani na manikir sa trajnim lakom (procedura od 1,5 sata), ali se po dolasku pokazalo da Vam je potrebna nadogradnja nokata — procedura koja traje oko 3 sata.. Pri tome ste, nažalost, zakasnili 30 minuta.. (očigledno je da je trosatnu proceduru fizički nemoguće izvesti u preostalom satu)

Uprkos tome - ponudili smo sve moguće varijante rješenja: ili da izvedemo uslugu koja odgovara zakazanom terminu, ili da nadogradnju prebacimo na prvo Vama odgovarajuće vrijeme. 
Nažalost, nijedna od varijanti Vam nije odgovarala..

Nakon što smo pregledali foto-evidenciju stanja nokata prije procedure, vidjeli smo i karakteristične znake redovne mehaničke traumatizacije nokatne ploče s Vaše strane.. - što, kako razumijete, nesporno značajno utiče na trajnost bilo kog umjetnog materijala, nezavisno od kvalifikacije majstora.

Naš centar radi po prethodnom zakazivanju i, s obzirom na veliku potražnju za uslugama tokom cijele godine, dužni smo da se držimo vremenskog rasporeda i da uvažavamo termine svih naših klijenata. Upravo zato nikada ne skraćujemo tehnologiju izvođenja procedure na štetu njenog kvaliteta.

S poštovanjem, iPODO • DUKLEY 

// ..za one koji razumiju razliku & cijene svoje zdravlje //', 'Захваљујемо Вам на рецензији.

Да разјаснимо ситуацију -

У нашем Центру се за сваку процедуру води фото и видео-евиденција, тако да увијек можемо објективно реконструисати ток догађаја, а осим тога за сваку посјету се чува историја.

Били сте заказани на маникир са трајним лаком (процедура од 1,5 сата), али се по доласку показало да Вам је потребна надоградња ноката — процедура која траје око 3 сата.. При томе сте, нажалост, закаснили 30 минута.. (очигледно је да је тросатну процедуру физички немогуће извести у преосталом сату)

Упркос томе - понудили смо све могуће варијанте рјешења: или да изведемо услугу која одговара заказаном термину, или да надоградњу пребацимо на прво Вама одговарајуће вријеме. 
Нажалост, ниједна од варијанти Вам није одговарала..

Након што смо прегледали фото-евиденцију стања ноката прије процедуре, видјели смо и карактеристичне знаке редовне механичке трауматизације нокатне плоче с Ваше стране.. - што, како разумијете, неспорно значајно утиче на трајност било ког умјетног материјала, независно од квалификације мајстора.

Наш центар ради по претходном заказивању и, с обзиром на велику потражњу за услугама током цијеле године, дужни смо да се држимо временског распореда и да уважавамо термине свих наших клијената. Управо зато никада не скраћујемо технологију извођења процедуре на штету њеног квалитета.

С поштовањем, iPODO • DUKLEY 

// ..за оне који разумију разлику & цијене своје здравље //', 'Thank you for your review.

Let us clarify the situation -

At our Centre every procedure is documented with photos and video, so we can always objectively reconstruct the course of events, plus a history is kept for every visit.

You were booked for a manicure with gel polish (a 1.5-hour procedure), but on arrival it turned out that you needed nail extensions — a procedure that takes about 3 hours.. On top of that, unfortunately, you were 30 minutes late.. (it is obvious that a three-hour procedure is physically impossible to carry out in the hour that was left)

Despite that - we offered every possible solution: either to perform the service you were actually booked for, or to move the extensions to the next time convenient for you. 
Unfortunately, neither option suited you..

Having studied the photo record of the condition of your nails before the procedure, we also saw the characteristic signs of regular mechanical trauma to the nail plate caused by you.. - which, as you will understand, unquestionably has a significant effect on how well any artificial material holds, regardless of the technician\'s qualifications.

Our centre works by appointment only and, given the high year-round demand for our services, we are obliged to keep to the schedule and to respect the appointments of all our clients. That is precisely why we never cut short the technology of a procedure at the expense of its quality.

With respect, iPODO • DUKLEY 

// ..for those who understand the difference & value their health //', 'Благодарим Вас за отзыв.

Давайте проясним ситуацию -

В нашем Центре для каждой процедуры ведётся фото и видео-фиксация, поэтому мы всегда можем объективно восстановить ход событий, плюс по каждому посещению сохраняется история.

Вы были записаны на маникюр с покрытием (процедура на 1,5 часа), однако по приезду выяснилось, что Вам требуется наращивание ногтей — процедура, занимающая около 3 часов.. При этом, к сожалению, Вы опоздали на 30 минут.. (очевидно, что выполнить трёхчасовую процедуру за оставшийся час физически невозможно)

Несмотря на это - мы предложили все возможные варианты решения: или выполнить услугу, соответствующую записи, или перенести наращивание на ближайшее удобное Вам время. 
К сожалению, ни один из вариантов Вам не подошёл..

Изучив фото-фиксацию состояния ногтей до процедуры, мы также увидели характерные признаки регулярной механической травматизации Вами ногтевой пластины.. - что, как понимаете, однозначно существенно влияет на стойкость любого искусственного материала независимо от квалификации мастера.

Наш центр работает по предварительной записи, и, учитывая высокий кругло-годичный спрос на услуги, мы обязаны соблюдать регламент времени и уважать записи всех наших клиентов. Именно поэтому мы никогда не сокращаем технологию выполнения процедуры в ущерб её качеству.

С Уважением, iPODO • DUKLEY 

// ..для тех, кто понимает разницу & ценит своё здоровье //', 'Wir danken Ihnen für Ihre Bewertung.

Lassen Sie uns die Situation klarstellen -

In unserem Zentrum wird jede Behandlung per Foto und Video dokumentiert, deshalb können wir den Ablauf der Ereignisse jederzeit objektiv rekonstruieren, außerdem wird zu jedem Besuch eine Historie gespeichert.

Sie waren für eine Maniküre mit Lackierung gebucht (eine Behandlung von 1,5 Stunden), bei Ihrer Ankunft stellte sich jedoch heraus, dass Sie eine Nagelverlängerung benötigen — eine Behandlung, die etwa 3 Stunden dauert.. Dabei kamen Sie leider 30 Minuten zu spät.. (es ist offensichtlich, dass eine dreistündige Behandlung in der verbleibenden Stunde physisch unmöglich ist)

Trotzdem haben wir alle möglichen Lösungen angeboten: entweder die Leistung durchzuführen, für die Sie gebucht waren, oder die Verlängerung auf den nächsten für Sie passenden Termin zu verschieben. 
Leider hat Ihnen keine der Varianten zugesagt..

Nachdem wir die Fotodokumentation des Nagelzustands vor der Behandlung geprüft haben, sahen wir außerdem charakteristische Anzeichen einer regelmäßigen mechanischen Traumatisierung der Nagelplatte durch Sie selbst.. - was, wie Sie verstehen, die Haltbarkeit jedes künstlichen Materials eindeutig erheblich beeinflusst, unabhängig von der Qualifikation der Mitarbeiterin.

Unser Zentrum arbeitet nach Terminvereinbarung, und angesichts der hohen ganzjährigen Nachfrage nach unseren Leistungen sind wir verpflichtet, den Zeitplan einzuhalten und die Termine aller unserer Kunden zu respektieren. Genau deshalb verkürzen wir niemals den Behandlungsablauf zu Lasten der Qualität.

Mit Respekt, iPODO • DUKLEY 

// ..für die, die den Unterschied verstehen & ihre Gesundheit schätzen //', 'Yorumunuz için teşekkür ederiz.

Durumu netleştirelim -

Merkezimizde her uygulama için fotoğraf ve video kaydı tutulur, bu nedenle olayların akışını her zaman objektif şekilde ortaya koyabiliriz; ayrıca her ziyaret için geçmiş kaydı saklanır.

Kalıcı ojeli manikür için randevunuz vardı (1,5 saatlik bir uygulama), ancak geldiğinizde protez tırnağa ihtiyacınız olduğu anlaşıldı — yaklaşık 3 saat süren bir uygulama.. Üstelik ne yazık ki 30 dakika geciktiniz.. (kalan bir saatte üç saatlik bir uygulamayı yapmanın fiziksel olarak imkânsız olduğu açık)

Buna rağmen - mümkün olan tüm çözüm seçeneklerini sunduk: ya randevunuza uygun hizmeti yapmak, ya da protez tırnağı sizin için uygun olan en yakın zamana ertelemek. 
Ne yazık ki seçeneklerin hiçbiri size uygun olmadı..

Uygulama öncesi tırnakların durumuna ait fotoğraf kayıtlarını inceledikten sonra, tırnak plağının sizin tarafınızdan düzenli olarak mekanik travmaya maruz bırakıldığına dair karakteristik izleri de gördük.. - bu da, anlayacağınız üzere, uzmanın niteliğinden bağımsız olarak her türlü yapay malzemenin kalıcılığını hiç kuşkusuz önemli ölçüde etkiler.

Merkezimiz ön randevuyla çalışır ve hizmetlere yıl boyu süren yoğun talep göz önüne alındığında, zaman planına uymak ve tüm müşterilerimizin randevularına saygı göstermek zorundayız. İşte bu yüzden bir uygulamanın teknolojisini kalitesinden ödün vererek asla kısaltmayız.

Saygılarımızla, iPODO • DUKLEY 

// ..farkı anlayan & sağlığına değer verenler için //',
  'google_maps', '2026-07-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnTUNva1oyVGtnRRAB'),
  'clinic', @clinic_id,
  'Обвинение в некомпетентности является 100% ложным - так как проблема воспалительного процесса 1-го пальца левой стопы у Вашего сына была решена полностью!

Первичное обращение (16.04.2025):
Пациент поступил с жалобами на болезненность, отёк и гиперемию латерального околоногтевого валика I пальца стопы.
При осмотре: инфильтрация мягких тканей, локальная гиперемия, гнойное отделяемое. Ногтевая пластина частично внедрена в мягкие ткани, что соответствовало картине онихокриптоза с развитием воспалительно-гнойного процесса.

Диагноз: Острый параонихий латерального околоногтевого валика I пальца стопы с гнойным отделяемым на фоне онихокриптоза.

Проведено: первичная обработка очага поражения, санация и установлена тампонада с антисептическим раствором.
Домашний уход: назначены препараты  для приобретения в аптеке: Актинисепт и Изосепт-D с чёткими рекомендациями по применению.

⸻

21.04.2025 — повторный приём:
явился для плановой смены тампонады (рекомендовано для профилактики присоединения вторичной инфекции).
При осмотре: воспалительных изменений не выявлено, гнойного отделяемого нет.
Выполнено: смена тампонады, даны рекомендации по дальнейшему уходу.

⸻

30.04.2025 — третичный приём: произведена плановая повторная смены тампонады.
При осмотре: воспалительный процесс купирован полностью, ногтевая пластина отрастает физиологично.
Рекомендовано: установка коррекционной системы (скобы) для профилактики рецидива онихокриптоза и правильного формирования ногтевой пластины.
Дополнительно: в связи с выраженным гипергидрозом стоп, который мог являться провоцирующим фактором воспалительного процесса - назначена наружная мазь.

⸻

07.05.2025 — плановый (финальный) приём - не состоялся, Пациент на визит не явился, о причине не сообщил и в течении последующих 5(!) МЕСЯЦЕВ ЖАЛОБ НЕ ПОСТУПАЛО.

⸻

Заключение:
Пациенту была оказана профессиональная подологическая  помощь в полном объёме в соответствии с клиническими стандартами. Воспалительный процесс своевременно купирован, проведены необходимые лечебные и профилактические мероприятия. Назначены препараты для домашнего ухода, даны подробные рекомендации, а также назначено лечение гипергидроза для исключения рецидивов, имеются все подтверждающие фото (по-шагово запротоколированы)', 'ru',
  'Optužba za nekompetentnost je 100% lažna - jer je problem upalnog procesa 1. prsta lijeve stope kod Vašeg sina riješen u potpunosti!

Prvi pregled (16.04.2025):
Pacijent je došao sa žalbama na bol, otok i hiperemiju lateralnog nokatnog valjka I prsta stope.
Pri pregledu: infiltracija mekih tkiva, lokalna hiperemija, gnojni iscjedak. Nokatna ploča je djelimično urasla u meka tkiva, što je odgovaralo slici onihokriptoze sa razvojem upalno-gnojnog procesa.

Dijagnoza: Akutni paronihij lateralnog nokatnog valjka I prsta stope sa gnojnim iscjedkom na podlozi onihokriptoze.

Urađeno: primarna obrada žarišta, sanacija i postavljena tamponada sa antiseptičkim rastvorom.
Kućna njega: propisani preparati za kupovinu u apoteci: Aktinisept i Izosept-D sa jasnim uputstvima za primjenu.

⸻

21.04.2025 — kontrolni pregled:
došao je na planiranu zamjenu tamponade (preporučeno radi prevencije sekundarne infekcije).
Pri pregledu: upalne promjene nisu utvrđene, gnojnog iscjedka nema.
Urađeno: zamjena tamponade, date preporuke za dalju njegu.

⸻

30.04.2025 — treći pregled: izvršena planirana ponovna zamjena tamponade.
Pri pregledu: upalni proces potpuno kupiran, nokatna ploča raste fiziološki.
Preporučeno: postavljanje korekcionog sistema (skobe) radi prevencije recidiva onihokriptoze i pravilnog formiranja nokatne ploče.
Dodatno: zbog izražene hiperhidroze stopala, koja je mogla biti provocirajući faktor upalnog procesa - propisana je mast za vanjsku primjenu.

⸻

07.05.2025 — planirani (završni) pregled - nije se održao, Pacijent se nije pojavio na termin, razlog nije saopštio i u toku sljedećih 5(!) MJESECI NIJE BILO NIKAKVIH ŽALBI.

⸻

Zaključak:
Pacijentu je pružena profesionalna podološka pomoć u punom obimu, u skladu sa kliničkim standardima. Upalni proces je na vrijeme kupiran, sprovedene su sve potrebne terapijske i preventivne mjere. Propisani su preparati za kućnu njegu, date su detaljne preporuke, a propisano je i liječenje hiperhidroze radi isključivanja recidiva; postoje sve fotografije koje to potvrđuju (protokolisano korak po korak)', 'Оптужба за некомпетентност је 100% лажна - јер је проблем упалног процеса 1. прста лијеве стопе код Вашег сина ријешен у потпуности!

Први преглед (16.04.2025):
Пацијент је дошао са жалбама на бол, оток и хиперемију латералног нокатног ваљка I прста стопала.
При прегледу: инфилтрација меких ткива, локална хиперемија, гнојни исцједак. Нокатна плоча је дјелимично урасла у мека ткива, што је одговарало слици онихокриптозе са развојем упално-гнојног процеса.

Дијагноза: Акутни паронихија латералног нокатног ваљка I прста стопала са гнојним исцједком на подлози онихокриптозе.

Урађено: примарна обрада жаришта, санација и постављена тампонада са антисептичким раствором.
Кућна њега: прописани препарати за куповину у апотеци: Aktinisept и Izosept-D са јасним упутствима за примјену.

⸻

21.04.2025 — контролни преглед:
дошао је на планирану замјену тампонаде (препоручено ради превенције секундарне инфекције).
При прегледу: упалне промјене нису утврђене, гнојног исцједка нема.
Урађено: замјена тампонаде, дате препоруке за даљу његу.

⸻

30.04.2025 — трећи преглед: извршена планирана поновна замјена тампонаде.
При прегледу: упални процес потпуно купиран, нокатна плоча расте физиолошки.
Препоручено: постављање корекционог система (скобе) ради превенције рецидива онихокриптозе и правилног формирања нокатне плоче.
Додатно: због изражене хиперхидрозе стопала, која је могла бити провоцирајући фактор упалног процеса - прописана је маст за вањску примјену.

⸻

07.05.2025 — планирани (завршни) преглед - није се одржао, Пацијент се није појавио на термин, разлог није саопштио и у току сљедећих 5(!) МЈЕСЕЦИ НИЈЕ БИЛО НИКАКВИХ ЖАЛБИ.

⸻

Закључак:
Пацијенту је пружена професионална подолошка помоћ у пуном обиму, у складу са клиничким стандардима. Упални процес је на вријеме купиран, спроведене су све потребне терапијске и превентивне мјере. Прописани су препарати за кућну његу, дате су детаљне препоруке, а прописано је и лијечење хиперхидрозе ради искључивања рецидива; постоје све фотографије које то потврђују (протоколисано корак по корак)', 'The accusation of incompetence is 100% false - because the problem of the inflammatory process on the 1st toe of your son\'s left foot was resolved completely!

Initial visit (16.04.2025):
The patient presented with complaints of pain, swelling and hyperaemia of the lateral nail fold of the 1st toe.
On examination: infiltration of the soft tissues, local hyperaemia, purulent discharge. The nail plate was partially embedded in the soft tissue, which corresponded to the picture of onychocryptosis with the development of a purulent inflammatory process.

Diagnosis: Acute paronychia of the lateral nail fold of the 1st toe with purulent discharge against a background of onychocryptosis.

Performed: initial treatment of the lesion, debridement, and a tamponade with antiseptic solution was placed.
Home care: medicines prescribed to be purchased at the pharmacy: Aktinisept and Izosept-D, with clear instructions for use.

⸻

21.04.2025 — follow-up visit:
attended for the scheduled change of the tamponade (recommended to prevent secondary infection).
On examination: no inflammatory changes found, no purulent discharge.
Performed: change of the tamponade, recommendations for further care given.

⸻

30.04.2025 — third visit: the scheduled repeat change of the tamponade was carried out.
On examination: the inflammatory process had resolved completely, the nail plate was growing back physiologically.
Recommended: fitting of a correction system (nail brace) to prevent recurrence of onychocryptosis and to ensure correct formation of the nail plate.
In addition: due to pronounced hyperhidrosis of the feet, which could have been a provoking factor of the inflammatory process - a topical ointment was prescribed.

⸻

07.05.2025 — the scheduled (final) appointment did not take place; the Patient did not show up, did not report a reason, and over the following 5(!) MONTHS NO COMPLAINTS WERE RECEIVED.

⸻

Conclusion:
The patient received professional podiatric care in full, in accordance with clinical standards. The inflammatory process was resolved in good time, the necessary therapeutic and preventive measures were carried out. Medicines for home care were prescribed, detailed recommendations were given, and treatment of hyperhidrosis was also prescribed to rule out recurrence; all supporting photos are available (documented step by step)', 'Обвинение в некомпетентности является 100% ложным - так как проблема воспалительного процесса 1-го пальца левой стопы у Вашего сына была решена полностью!

Первичное обращение (16.04.2025):
Пациент поступил с жалобами на болезненность, отёк и гиперемию латерального околоногтевого валика I пальца стопы.
При осмотре: инфильтрация мягких тканей, локальная гиперемия, гнойное отделяемое. Ногтевая пластина частично внедрена в мягкие ткани, что соответствовало картине онихокриптоза с развитием воспалительно-гнойного процесса.

Диагноз: Острый параонихий латерального околоногтевого валика I пальца стопы с гнойным отделяемым на фоне онихокриптоза.

Проведено: первичная обработка очага поражения, санация и установлена тампонада с антисептическим раствором.
Домашний уход: назначены препараты  для приобретения в аптеке: Актинисепт и Изосепт-D с чёткими рекомендациями по применению.

⸻

21.04.2025 — повторный приём:
явился для плановой смены тампонады (рекомендовано для профилактики присоединения вторичной инфекции).
При осмотре: воспалительных изменений не выявлено, гнойного отделяемого нет.
Выполнено: смена тампонады, даны рекомендации по дальнейшему уходу.

⸻

30.04.2025 — третичный приём: произведена плановая повторная смены тампонады.
При осмотре: воспалительный процесс купирован полностью, ногтевая пластина отрастает физиологично.
Рекомендовано: установка коррекционной системы (скобы) для профилактики рецидива онихокриптоза и правильного формирования ногтевой пластины.
Дополнительно: в связи с выраженным гипергидрозом стоп, который мог являться провоцирующим фактором воспалительного процесса - назначена наружная мазь.

⸻

07.05.2025 — плановый (финальный) приём - не состоялся, Пациент на визит не явился, о причине не сообщил и в течении последующих 5(!) МЕСЯЦЕВ ЖАЛОБ НЕ ПОСТУПАЛО.

⸻

Заключение:
Пациенту была оказана профессиональная подологическая  помощь в полном объёме в соответствии с клиническими стандартами. Воспалительный процесс своевременно купирован, проведены необходимые лечебные и профилактические мероприятия. Назначены препараты для домашнего ухода, даны подробные рекомендации, а также назначено лечение гипергидроза для исключения рецидивов, имеются все подтверждающие фото (по-шагово запротоколированы)', 'Der Vorwurf der Inkompetenz ist 100% falsch - denn das Problem des Entzündungsprozesses an der 1. Zehe des linken Fußes Ihres Sohnes wurde vollständig gelöst!

Erstvorstellung (16.04.2025):
Der Patient kam mit Beschwerden über Schmerzen, Schwellung und Hyperämie des lateralen Nagelwalls der I. Zehe.
Bei der Untersuchung: Infiltration des Weichgewebes, lokale Hyperämie, eitriges Sekret. Die Nagelplatte war teilweise in das Weichgewebe eingewachsen, was dem Bild einer Onychokryptose mit Entwicklung eines eitrig-entzündlichen Prozesses entsprach.

Diagnose: Akute Paronychie des lateralen Nagelwalls der I. Zehe mit eitrigem Sekret auf dem Boden einer Onychokryptose.

Durchgeführt: Erstversorgung des Befundes, Sanierung und Anlage einer Tamponade mit antiseptischer Lösung.
Häusliche Pflege: Präparate zum Kauf in der Apotheke verordnet: Aktinisept und Izosept-D mit klaren Anwendungsempfehlungen.

⸻

21.04.2025 — Kontrolltermin:
erschien zum planmäßigen Wechsel der Tamponade (empfohlen zur Vorbeugung einer Sekundärinfektion).
Bei der Untersuchung: keine entzündlichen Veränderungen festgestellt, kein eitriges Sekret.
Durchgeführt: Wechsel der Tamponade, Empfehlungen zur weiteren Pflege gegeben.

⸻

30.04.2025 — dritter Termin: der planmäßige erneute Wechsel der Tamponade wurde durchgeführt.
Bei der Untersuchung: Entzündungsprozess vollständig abgeklungen, die Nagelplatte wächst physiologisch nach.
Empfohlen: Anlage eines Korrektursystems (Nagelspange) zur Vorbeugung eines Rezidivs der Onychokryptose und zur korrekten Ausbildung der Nagelplatte.
Zusätzlich: aufgrund der ausgeprägten Hyperhidrose der Füße, die ein auslösender Faktor des Entzündungsprozesses sein konnte - wurde eine Salbe zur äußeren Anwendung verordnet.

⸻

07.05.2025 — der geplante (abschließende) Termin fand nicht statt, der Patient erschien nicht, teilte keinen Grund mit, und in den folgenden 5(!) MONATEN GINGEN KEINE BESCHWERDEN EIN.

⸻

Fazit:
Dem Patienten wurde eine professionelle podologische Versorgung in vollem Umfang und gemäß den klinischen Standards zuteil. Der Entzündungsprozess wurde rechtzeitig gestoppt, die notwendigen therapeutischen und vorbeugenden Maßnahmen wurden durchgeführt. Es wurden Präparate für die häusliche Pflege verordnet, ausführliche Empfehlungen gegeben sowie eine Behandlung der Hyperhidrose zum Ausschluss von Rezidiven verordnet; es liegen alle belegenden Fotos vor (Schritt für Schritt protokolliert)', 'Yetersizlik suçlaması %100 yalandır - çünkü oğlunuzun sol ayağının 1. parmağındaki iltihabi süreç sorunu tamamen çözülmüştü!

İlk başvuru (16.04.2025):
Hasta, ayak I. parmağının lateral tırnak kıvrımında ağrı, ödem ve hiperemi şikâyetleriyle geldi.
Muayenede: yumuşak dokularda infiltrasyon, lokal hiperemi, pürülan akıntı. Tırnak plağı kısmen yumuşak dokuya gömülmüştü; bu da iltihabi-pürülan sürecin geliştiği onikokriptoz tablosuna uyuyordu.

Teşhis: Onikokriptoz zemininde, ayak I. parmağının lateral tırnak kıvrımının pürülan akıntılı akut paronişisi.

Yapılanlar: lezyon odağının birincil bakımı, sanitasyon ve antiseptik solüsyonlu tamponad yerleştirilmesi.
Evde bakım: eczaneden alınmak üzere ilaçlar reçete edildi: Aktinisept ve Izosept-D, kullanımına dair net önerilerle birlikte.

⸻

21.04.2025 — kontrol muayenesi:
planlı tamponad değişimi için geldi (ikincil enfeksiyonun eklenmesini önlemek amacıyla önerilmişti).
Muayenede: iltihabi değişiklik saptanmadı, pürülan akıntı yok.
Yapılanlar: tamponad değişimi, ileri bakım için öneriler verildi.

⸻

30.04.2025 — üçüncü muayene: planlı tekrar tamponad değişimi yapıldı.
Muayenede: iltihabi süreç tamamen geriledi, tırnak plağı fizyolojik olarak uzuyor.
Önerilen: onikokriptozun nüksünü önlemek ve tırnak plağının doğru şekillenmesi için düzeltici sistem (tırnak teli) takılması.
Ek olarak: iltihabi sürecin tetikleyici faktörü olabilecek belirgin ayak hiperhidrozu nedeniyle - dıştan uygulanan bir merhem reçete edildi.

⸻

07.05.2025 — planlı (son) muayene gerçekleşmedi, Hasta randevuya gelmedi, nedenini bildirmedi ve sonraki 5(!) AY BOYUNCA HİÇBİR ŞİKÂYET GELMEDİ.

⸻

Sonuç:
Hastaya, klinik standartlara uygun olarak tam kapsamlı profesyonel podoloji bakımı verildi. İltihabi süreç zamanında durduruldu, gerekli tedavi ve önleyici işlemler uygulandı. Evde bakım için ilaçlar reçete edildi, ayrıntılı öneriler verildi, ayrıca nüksü dışlamak için hiperhidroz tedavisi de verildi; bunları doğrulayan tüm fotoğraflar mevcut (adım adım kayda geçirilmiş)',
  'google_maps', '2025-10-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT200d2FWaHRaa2cyWDBwQ2F6SXhjRUp4V21wUlpVRRAB'),
  'clinic', @clinic_id,
  'Обвинение в некомпетентности является 100% ложным - так как проблема воспалительного процесса 1-го пальца левой стопы у Вашего сына была решена полностью!

Первичное обращение (16.04.2025):
Пациент поступил с жалобами на болезненность, отёк и гиперемию латерального околоногтевого валика I пальца стопы.
При осмотре: инфильтрация мягких тканей, локальная гиперемия, гнойное отделяемое. Ногтевая пластина частично внедрена в мягкие ткани, что соответствовало картине онихокриптоза с развитием воспалительно-гнойного процесса.

Диагноз: Острый параонихий латерального околоногтевого валика I пальца стопы с гнойным отделяемым на фоне онихокриптоза.

Проведено: первичная обработка очага поражения, санация и установлена тампонада с антисептическим раствором.
Домашний уход: назначены препараты  для приобретения в аптеке: Актинисепт и Изосепт-D с чёткими рекомендациями по применению.

⸻

21.04.2025 — повторный приём:
явился для плановой смены тампонады (рекомендовано для профилактики присоединения вторичной инфекции).
При осмотре: воспалительных изменений не выявлено, гнойного отделяемого нет.
Выполнено: смена тампонады, даны рекомендации по дальнейшему уходу.

⸻

30.04.2025 — третичный приём: произведена плановая повторная смены тампонады.
При осмотре: воспалительный процесс купирован полностью, ногтевая пластина отрастает физиологично.
Рекомендовано: установка коррекционной системы (скобы) для профилактики рецидива онихокриптоза и правильного формирования ногтевой пластины.
Дополнительно: в связи с выраженным гипергидрозом стоп, который мог являться провоцирующим фактором воспалительного процесса - назначена наружная мазь.

⸻

07.05.2025 — плановый (финальный) приём - не состоялся, Пациент на визит не явился, о причине не сообщил и в течении последующих 5(!) МЕСЯЦЕВ ЖАЛОБ НЕ ПОСТУПАЛО.

⸻

Заключение:
Пациенту была оказана профессиональная подологическая  помощь в полном объёме в соответствии с клиническими стандартами. Воспалительный процесс своевременно купирован, проведены необходимые лечебные и профилактические мероприятия. Назначены препараты для домашнего ухода, даны подробные рекомендации, а также назначено лечение гипергидроза для исключения рецидивов, имеются все подтверждающие фото (по-шагово запротоколированы)', 'ru',
  'Optužba za nekompetentnost je 100% lažna - jer je problem upalnog procesa 1. prsta lijeve stope kod Vašeg sina riješen u potpunosti!

Prvi pregled (16.04.2025):
Pacijent je došao sa žalbama na bol, otok i hiperemiju lateralnog nokatnog valjka I prsta stope.
Pri pregledu: infiltracija mekih tkiva, lokalna hiperemija, gnojni iscjedak. Nokatna ploča je djelimično urasla u meka tkiva, što je odgovaralo slici onihokriptoze sa razvojem upalno-gnojnog procesa.

Dijagnoza: Akutni paronihij lateralnog nokatnog valjka I prsta stope sa gnojnim iscjedkom na podlozi onihokriptoze.

Urađeno: primarna obrada žarišta, sanacija i postavljena tamponada sa antiseptičkim rastvorom.
Kućna njega: propisani preparati za kupovinu u apoteci: Aktinisept i Izosept-D sa jasnim uputstvima za primjenu.

⸻

21.04.2025 — kontrolni pregled:
došao je na planiranu zamjenu tamponade (preporučeno radi prevencije sekundarne infekcije).
Pri pregledu: upalne promjene nisu utvrđene, gnojnog iscjedka nema.
Urađeno: zamjena tamponade, date preporuke za dalju njegu.

⸻

30.04.2025 — treći pregled: izvršena planirana ponovna zamjena tamponade.
Pri pregledu: upalni proces potpuno kupiran, nokatna ploča raste fiziološki.
Preporučeno: postavljanje korekcionog sistema (skobe) radi prevencije recidiva onihokriptoze i pravilnog formiranja nokatne ploče.
Dodatno: zbog izražene hiperhidroze stopala, koja je mogla biti provocirajući faktor upalnog procesa - propisana je mast za vanjsku primjenu.

⸻

07.05.2025 — planirani (završni) pregled - nije se održao, Pacijent se nije pojavio na termin, razlog nije saopštio i u toku sljedećih 5(!) MJESECI NIJE BILO NIKAKVIH ŽALBI.

⸻

Zaključak:
Pacijentu je pružena profesionalna podološka pomoć u punom obimu, u skladu sa kliničkim standardima. Upalni proces je na vrijeme kupiran, sprovedene su sve potrebne terapijske i preventivne mjere. Propisani su preparati za kućnu njegu, date su detaljne preporuke, a propisano je i liječenje hiperhidroze radi isključivanja recidiva; postoje sve fotografije koje to potvrđuju (protokolisano korak po korak)', 'Оптужба за некомпетентност је 100% лажна - јер је проблем упалног процеса 1. прста лијеве стопе код Вашег сина ријешен у потпуности!

Први преглед (16.04.2025):
Пацијент је дошао са жалбама на бол, оток и хиперемију латералног нокатног ваљка I прста стопала.
При прегледу: инфилтрација меких ткива, локална хиперемија, гнојни исцједак. Нокатна плоча је дјелимично урасла у мека ткива, што је одговарало слици онихокриптозе са развојем упално-гнојног процеса.

Дијагноза: Акутни паронихија латералног нокатног ваљка I прста стопала са гнојним исцједком на подлози онихокриптозе.

Урађено: примарна обрада жаришта, санација и постављена тампонада са антисептичким раствором.
Кућна њега: прописани препарати за куповину у апотеци: Aktinisept и Izosept-D са јасним упутствима за примјену.

⸻

21.04.2025 — контролни преглед:
дошао је на планирану замјену тампонаде (препоручено ради превенције секундарне инфекције).
При прегледу: упалне промјене нису утврђене, гнојног исцједка нема.
Урађено: замјена тампонаде, дате препоруке за даљу његу.

⸻

30.04.2025 — трећи преглед: извршена планирана поновна замјена тампонаде.
При прегледу: упални процес потпуно купиран, нокатна плоча расте физиолошки.
Препоручено: постављање корекционог система (скобе) ради превенције рецидива онихокриптозе и правилног формирања нокатне плоче.
Додатно: због изражене хиперхидрозе стопала, која је могла бити провоцирајући фактор упалног процеса - прописана је маст за вањску примјену.

⸻

07.05.2025 — планирани (завршни) преглед - није се одржао, Пацијент се није појавио на термин, разлог није саопштио и у току сљедећих 5(!) МЈЕСЕЦИ НИЈЕ БИЛО НИКАКВИХ ЖАЛБИ.

⸻

Закључак:
Пацијенту је пружена професионална подолошка помоћ у пуном обиму, у складу са клиничким стандардима. Упални процес је на вријеме купиран, спроведене су све потребне терапијске и превентивне мјере. Прописани су препарати за кућну његу, дате су детаљне препоруке, а прописано је и лијечење хиперхидрозе ради искључивања рецидива; постоје све фотографије које то потврђују (протоколисано корак по корак)', 'The accusation of incompetence is 100% false - because the problem of the inflammatory process on the 1st toe of your son\'s left foot was resolved completely!

Initial visit (16.04.2025):
The patient presented with complaints of pain, swelling and hyperaemia of the lateral nail fold of the 1st toe.
On examination: infiltration of the soft tissues, local hyperaemia, purulent discharge. The nail plate was partially embedded in the soft tissue, which corresponded to the picture of onychocryptosis with the development of a purulent inflammatory process.

Diagnosis: Acute paronychia of the lateral nail fold of the 1st toe with purulent discharge against a background of onychocryptosis.

Performed: initial treatment of the lesion, debridement, and a tamponade with antiseptic solution was placed.
Home care: medicines prescribed to be purchased at the pharmacy: Aktinisept and Izosept-D, with clear instructions for use.

⸻

21.04.2025 — follow-up visit:
attended for the scheduled change of the tamponade (recommended to prevent secondary infection).
On examination: no inflammatory changes found, no purulent discharge.
Performed: change of the tamponade, recommendations for further care given.

⸻

30.04.2025 — third visit: the scheduled repeat change of the tamponade was carried out.
On examination: the inflammatory process had resolved completely, the nail plate was growing back physiologically.
Recommended: fitting of a correction system (nail brace) to prevent recurrence of onychocryptosis and to ensure correct formation of the nail plate.
In addition: due to pronounced hyperhidrosis of the feet, which could have been a provoking factor of the inflammatory process - a topical ointment was prescribed.

⸻

07.05.2025 — the scheduled (final) appointment did not take place; the Patient did not show up, did not report a reason, and over the following 5(!) MONTHS NO COMPLAINTS WERE RECEIVED.

⸻

Conclusion:
The patient received professional podiatric care in full, in accordance with clinical standards. The inflammatory process was resolved in good time, the necessary therapeutic and preventive measures were carried out. Medicines for home care were prescribed, detailed recommendations were given, and treatment of hyperhidrosis was also prescribed to rule out recurrence; all supporting photos are available (documented step by step)', 'Обвинение в некомпетентности является 100% ложным - так как проблема воспалительного процесса 1-го пальца левой стопы у Вашего сына была решена полностью!

Первичное обращение (16.04.2025):
Пациент поступил с жалобами на болезненность, отёк и гиперемию латерального околоногтевого валика I пальца стопы.
При осмотре: инфильтрация мягких тканей, локальная гиперемия, гнойное отделяемое. Ногтевая пластина частично внедрена в мягкие ткани, что соответствовало картине онихокриптоза с развитием воспалительно-гнойного процесса.

Диагноз: Острый параонихий латерального околоногтевого валика I пальца стопы с гнойным отделяемым на фоне онихокриптоза.

Проведено: первичная обработка очага поражения, санация и установлена тампонада с антисептическим раствором.
Домашний уход: назначены препараты  для приобретения в аптеке: Актинисепт и Изосепт-D с чёткими рекомендациями по применению.

⸻

21.04.2025 — повторный приём:
явился для плановой смены тампонады (рекомендовано для профилактики присоединения вторичной инфекции).
При осмотре: воспалительных изменений не выявлено, гнойного отделяемого нет.
Выполнено: смена тампонады, даны рекомендации по дальнейшему уходу.

⸻

30.04.2025 — третичный приём: произведена плановая повторная смены тампонады.
При осмотре: воспалительный процесс купирован полностью, ногтевая пластина отрастает физиологично.
Рекомендовано: установка коррекционной системы (скобы) для профилактики рецидива онихокриптоза и правильного формирования ногтевой пластины.
Дополнительно: в связи с выраженным гипергидрозом стоп, который мог являться провоцирующим фактором воспалительного процесса - назначена наружная мазь.

⸻

07.05.2025 — плановый (финальный) приём - не состоялся, Пациент на визит не явился, о причине не сообщил и в течении последующих 5(!) МЕСЯЦЕВ ЖАЛОБ НЕ ПОСТУПАЛО.

⸻

Заключение:
Пациенту была оказана профессиональная подологическая  помощь в полном объёме в соответствии с клиническими стандартами. Воспалительный процесс своевременно купирован, проведены необходимые лечебные и профилактические мероприятия. Назначены препараты для домашнего ухода, даны подробные рекомендации, а также назначено лечение гипергидроза для исключения рецидивов, имеются все подтверждающие фото (по-шагово запротоколированы)', 'Der Vorwurf der Inkompetenz ist 100% falsch - denn das Problem des Entzündungsprozesses an der 1. Zehe des linken Fußes Ihres Sohnes wurde vollständig gelöst!

Erstvorstellung (16.04.2025):
Der Patient kam mit Beschwerden über Schmerzen, Schwellung und Hyperämie des lateralen Nagelwalls der I. Zehe.
Bei der Untersuchung: Infiltration des Weichgewebes, lokale Hyperämie, eitriges Sekret. Die Nagelplatte war teilweise in das Weichgewebe eingewachsen, was dem Bild einer Onychokryptose mit Entwicklung eines eitrig-entzündlichen Prozesses entsprach.

Diagnose: Akute Paronychie des lateralen Nagelwalls der I. Zehe mit eitrigem Sekret auf dem Boden einer Onychokryptose.

Durchgeführt: Erstversorgung des Befundes, Sanierung und Anlage einer Tamponade mit antiseptischer Lösung.
Häusliche Pflege: Präparate zum Kauf in der Apotheke verordnet: Aktinisept und Izosept-D mit klaren Anwendungsempfehlungen.

⸻

21.04.2025 — Kontrolltermin:
erschien zum planmäßigen Wechsel der Tamponade (empfohlen zur Vorbeugung einer Sekundärinfektion).
Bei der Untersuchung: keine entzündlichen Veränderungen festgestellt, kein eitriges Sekret.
Durchgeführt: Wechsel der Tamponade, Empfehlungen zur weiteren Pflege gegeben.

⸻

30.04.2025 — dritter Termin: der planmäßige erneute Wechsel der Tamponade wurde durchgeführt.
Bei der Untersuchung: Entzündungsprozess vollständig abgeklungen, die Nagelplatte wächst physiologisch nach.
Empfohlen: Anlage eines Korrektursystems (Nagelspange) zur Vorbeugung eines Rezidivs der Onychokryptose und zur korrekten Ausbildung der Nagelplatte.
Zusätzlich: aufgrund der ausgeprägten Hyperhidrose der Füße, die ein auslösender Faktor des Entzündungsprozesses sein konnte - wurde eine Salbe zur äußeren Anwendung verordnet.

⸻

07.05.2025 — der geplante (abschließende) Termin fand nicht statt, der Patient erschien nicht, teilte keinen Grund mit, und in den folgenden 5(!) MONATEN GINGEN KEINE BESCHWERDEN EIN.

⸻

Fazit:
Dem Patienten wurde eine professionelle podologische Versorgung in vollem Umfang und gemäß den klinischen Standards zuteil. Der Entzündungsprozess wurde rechtzeitig gestoppt, die notwendigen therapeutischen und vorbeugenden Maßnahmen wurden durchgeführt. Es wurden Präparate für die häusliche Pflege verordnet, ausführliche Empfehlungen gegeben sowie eine Behandlung der Hyperhidrose zum Ausschluss von Rezidiven verordnet; es liegen alle belegenden Fotos vor (Schritt für Schritt protokolliert)', 'Yetersizlik suçlaması %100 yalandır - çünkü oğlunuzun sol ayağının 1. parmağındaki iltihabi süreç sorunu tamamen çözülmüştü!

İlk başvuru (16.04.2025):
Hasta, ayak I. parmağının lateral tırnak kıvrımında ağrı, ödem ve hiperemi şikâyetleriyle geldi.
Muayenede: yumuşak dokularda infiltrasyon, lokal hiperemi, pürülan akıntı. Tırnak plağı kısmen yumuşak dokuya gömülmüştü; bu da iltihabi-pürülan sürecin geliştiği onikokriptoz tablosuna uyuyordu.

Teşhis: Onikokriptoz zemininde, ayak I. parmağının lateral tırnak kıvrımının pürülan akıntılı akut paronişisi.

Yapılanlar: lezyon odağının birincil bakımı, sanitasyon ve antiseptik solüsyonlu tamponad yerleştirilmesi.
Evde bakım: eczaneden alınmak üzere ilaçlar reçete edildi: Aktinisept ve Izosept-D, kullanımına dair net önerilerle birlikte.

⸻

21.04.2025 — kontrol muayenesi:
planlı tamponad değişimi için geldi (ikincil enfeksiyonun eklenmesini önlemek amacıyla önerilmişti).
Muayenede: iltihabi değişiklik saptanmadı, pürülan akıntı yok.
Yapılanlar: tamponad değişimi, ileri bakım için öneriler verildi.

⸻

30.04.2025 — üçüncü muayene: planlı tekrar tamponad değişimi yapıldı.
Muayenede: iltihabi süreç tamamen geriledi, tırnak plağı fizyolojik olarak uzuyor.
Önerilen: onikokriptozun nüksünü önlemek ve tırnak plağının doğru şekillenmesi için düzeltici sistem (tırnak teli) takılması.
Ek olarak: iltihabi sürecin tetikleyici faktörü olabilecek belirgin ayak hiperhidrozu nedeniyle - dıştan uygulanan bir merhem reçete edildi.

⸻

07.05.2025 — planlı (son) muayene gerçekleşmedi, Hasta randevuya gelmedi, nedenini bildirmedi ve sonraki 5(!) AY BOYUNCA HİÇBİR ŞİKÂYET GELMEDİ.

⸻

Sonuç:
Hastaya, klinik standartlara uygun olarak tam kapsamlı profesyonel podoloji bakımı verildi. İltihabi süreç zamanında durduruldu, gerekli tedavi ve önleyici işlemler uygulandı. Evde bakım için ilaçlar reçete edildi, ayrıntılı öneriler verildi, ayrıca nüksü dışlamak için hiperhidroz tedavisi de verildi; bunları doğrulayan tüm fotoğraflar mevcut (adım adım kayda geçirilmiş)',
  'google_maps', '2025-10-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25jeWFIWllOMmhhU21GVWNFeFVhVlIzVG14RWJuYxAB'),
  'clinic', @clinic_id,
  'Здравствуйте, Юнона! 

Благодарим Вас за выбор по итогу именно нашего Единственного в Черногории Специализированного Подологического Центра - 
iPODO • centre of Podology • Safe manicure pedicure и за ваш отзыв!

iPODO - это не имеющие аналогов Стерильность. Сервис. Качество. Более 100! Отличий & Преимуществ. 
А основатель - самый известный в ЧГ Подолог Призёр Европы 🏆 

Так как мы ведём медицинские карты на каждого клиента, - мы открыли Вашу электронную карту и видим всю историю посещений и все назначения.

Изначально Вам были рекомендованы препараты исходя из того, что доступно в аптеках Черногории. Мы также уточняли у Вас, - планируете ли вы поездку в ближайшее время в Украину или Россию, чтобы приобрести там необходимые средства.

Более того, мы подняли запись нашего диалога: мы предлагали вам возможность купить препараты у себя в стране или где у Вас есть родственники. На это Вы несколько раз ответили «нет и нет» и сказали: «Я возьму у вас».. 
Это были Ваши слова, и мы лишь предоставили Вам возможность приобрести у нас те профессиональные препараты, в эффективности которых мы уверены на основании клинического опыта.

Важно подчеркнуть, что препараты были именно рекомендованы, а не навязаны. Вы их приняли, и уже через месяц получили выраженный результат, которого, как Вы сами отмечали, долго не удавалось достичь в других местах!..

Мы искренне рады, что смогли помочь Вам добиться этого положительного результата. 
В то-же время мы всегда за объективную оценку: Вы пришли именно за результатом — и мы его вам предоставили. 

С уважением и заботой о Вашем здоровье, Ваш центр подологии и безопасного маникюра педикюра 

iPODO .. для тех, кто понимает разницу & ценит своё здоровье //', 'ru',
  'Zdravo, Junona!

Hvala Vam što ste na kraju izabrali baš naš Jedini specijalizovani Podološki centar u Crnoj Gori - 
iPODO • centre of Podology • Safe manicure pedicure i hvala na Vašoj recenziji!

iPODO - to je Sterilnost bez premca. Servis. Kvalitet. Više od 100! Razlika & Prednosti.
A osnivač je najpoznatiji Podolog u CG, Osvajač nagrade u Evropi 🏆

Kako vodimo medicinski karton za svakog klijenta, - otvorili smo Vaš elektronski karton i vidimo cijelu istoriju posjeta i sve preporuke.

Prvobitno su Vam preporučeni preparati polazeći od onoga što je dostupno u apotekama u Crnoj Gori. Takođe smo Vas pitali - planirate li u skorije vrijeme put u Ukrajinu ili Rusiju, da tamo kupite potrebna sredstva.

Štaviše, podigli smo zapis našeg razgovora: nudili smo Vam mogućnost da preparate kupite u svojoj zemlji ili tamo gdje imate rodbinu. Na to ste nekoliko puta odgovorili „ne i ne“ i rekli: „Uzeću kod vas“..
To su bile Vaše riječi, a mi smo Vam samo omogućili da kod nas kupite one profesionalne preparate u čiju efikasnost smo uvjereni na osnovu kliničkog iskustva.

Važno je podvući da su preparati bili preporučeni, a ne nametnuti. Vi ste ih prihvatili i već nakon mjesec dana dobili izražen rezultat koji, kao što ste i sami primijetili, dugo nije bilo moguće postići na drugim mjestima!..

Iskreno nam je drago što smo Vam pomogli da postignete taj pozitivan rezultat.
U isto vrijeme, mi smo uvijek za objektivnu ocjenu: došli ste upravo zbog rezultata — i mi smo Vam ga pružili.

S poštovanjem i brigom za Vaše zdravlje, Vaš centar podologije i bezbjednog manikira i pedikira

iPODO .. za one koji razumiju razliku & cijene svoje zdravlje //', 'Здраво, Јунона!

Хвала Вам што сте на крају изабрали баш наш Једини специјализовани Подолошки центар у Црној Гори - 
iPODO • centre of Podology • Safe manicure pedicure и хвала на Вашој рецензији!

iPODO - то је Стерилност без премца. Сервис. Квалитет. Више од 100! Разлика & Предности.
А оснивач је најпознатији Подолог у ЦГ, Освајач награде у Европи 🏆

Како водимо медицински картон за сваког клијента, - отворили смо Ваш електронски картон и видимо цијелу историју посјета и све препоруке.

Првобитно су Вам препоручени препарати полазећи од онога што је доступно у апотекама у Црној Гори. Такође смо Вас питали - планирате ли у скорије вријеме пут у Украјину или Русију, да тамо купите потребна средства.

Штавише, подигли смо запис нашег разговора: нудили смо Вам могућност да препарате купите у својој земљи или тамо гдје имате родбину. На то сте неколико пута одговорили „не и не“ и рекли: „Узећу код вас“..
То су биле Ваше ријечи, а ми смо Вам само омогућили да код нас купите оне професионалне препарате у чију ефикасност смо увјерени на основу клиничког искуства.

Важно је подвући да су препарати били препоручени, а не наметнути. Ви сте их прихватили и већ након мјесец дана добили изражен резултат који, као што сте и сами примијетили, дуго није било могуће постићи на другим мјестима!..

Искрено нам је драго што смо Вам помогли да постигнете тај позитиван резултат.
У исто вријеме, ми смо увијек за објективну оцјену: дошли сте управо због резултата — и ми смо Вам га пружили.

С поштовањем и бригом за Ваше здравље, Ваш центар подологије и безбједног маникира и педикира

iPODO .. за оне који разумију разлику & цијене своје здравље //', 'Hello, Junona!

Thank you for ultimately choosing our Centre - the only Specialised Podology Centre in Montenegro - 
iPODO • centre of Podology • Safe manicure pedicure, and thank you for your review!

iPODO means unrivalled Sterility. Service. Quality. More than 100! Differences & Advantages.
And the founder is the best-known Podiatrist in Montenegro, a European prize winner 🏆

Since we keep a medical record for every client, we opened your electronic file and can see the entire history of visits and all the prescriptions.

Initially you were recommended products based on what is available in Montenegrin pharmacies. We also asked you whether you were planning a trip to Ukraine or Russia any time soon, so that you could buy the necessary products there.

What is more, we pulled up the recording of our conversation: we offered you the option of buying the products in your own country or wherever you have relatives. To that you replied “no and no” several times and said: “I\'ll take them from you”..
Those were your words, and all we did was give you the opportunity to buy from us the professional products whose effectiveness we are confident in on the basis of clinical experience.

It is important to stress that the products were recommended, not forced on you. You accepted them, and within a month you got a pronounced result which, as you noted yourself, you had long been unable to achieve elsewhere!..

We are sincerely glad that we were able to help you achieve this positive result.
At the same time, we are always in favour of an objective assessment: you came precisely for a result — and we delivered it to you.

With respect and care for your health, your centre of podology and safe manicure & pedicure

iPODO .. for those who understand the difference & value their health //', 'Здравствуйте, Юнона! 

Благодарим Вас за выбор по итогу именно нашего Единственного в Черногории Специализированного Подологического Центра - 
iPODO • centre of Podology • Safe manicure pedicure и за ваш отзыв!

iPODO - это не имеющие аналогов Стерильность. Сервис. Качество. Более 100! Отличий & Преимуществ. 
А основатель - самый известный в ЧГ Подолог Призёр Европы 🏆 

Так как мы ведём медицинские карты на каждого клиента, - мы открыли Вашу электронную карту и видим всю историю посещений и все назначения.

Изначально Вам были рекомендованы препараты исходя из того, что доступно в аптеках Черногории. Мы также уточняли у Вас, - планируете ли вы поездку в ближайшее время в Украину или Россию, чтобы приобрести там необходимые средства.

Более того, мы подняли запись нашего диалога: мы предлагали вам возможность купить препараты у себя в стране или где у Вас есть родственники. На это Вы несколько раз ответили «нет и нет» и сказали: «Я возьму у вас».. 
Это были Ваши слова, и мы лишь предоставили Вам возможность приобрести у нас те профессиональные препараты, в эффективности которых мы уверены на основании клинического опыта.

Важно подчеркнуть, что препараты были именно рекомендованы, а не навязаны. Вы их приняли, и уже через месяц получили выраженный результат, которого, как Вы сами отмечали, долго не удавалось достичь в других местах!..

Мы искренне рады, что смогли помочь Вам добиться этого положительного результата. 
В то-же время мы всегда за объективную оценку: Вы пришли именно за результатом — и мы его вам предоставили. 

С уважением и заботой о Вашем здоровье, Ваш центр подологии и безопасного маникюра педикюра 

iPODO .. для тех, кто понимает разницу & ценит своё здоровье //', 'Guten Tag, Junona!

Wir danken Ihnen, dass Sie sich letztlich für genau unser Zentrum entschieden haben - das einzige spezialisierte Podologie-Zentrum in Montenegro - 
iPODO • centre of Podology • Safe manicure pedicure, und danke für Ihre Bewertung!

iPODO - das bedeutet Sterilität ohne Vergleich. Service. Qualität. Über 100! Unterschiede & Vorteile.
Und die Gründerin ist die bekannteste Podologin in Montenegro, Preisträgerin auf europäischer Ebene 🏆

Da wir für jeden Kunden eine Krankenakte führen, haben wir Ihre elektronische Akte geöffnet und sehen die gesamte Besuchsgeschichte und alle Verordnungen.

Ursprünglich wurden Ihnen Präparate auf der Grundlage dessen empfohlen, was in montenegrinischen Apotheken verfügbar ist. Wir haben Sie außerdem gefragt, ob Sie in nächster Zeit eine Reise in die Ukraine oder nach Russland planen, um die notwendigen Mittel dort zu kaufen.

Mehr noch, wir haben die Aufzeichnung unseres Gesprächs herausgeholt: Wir haben Ihnen angeboten, die Präparate in Ihrem Heimatland oder dort zu kaufen, wo Sie Verwandte haben. Darauf haben Sie mehrmals „nein und nein“ geantwortet und gesagt: „Ich nehme sie bei Ihnen“..
Das waren Ihre Worte, und wir haben Ihnen lediglich die Möglichkeit gegeben, bei uns jene professionellen Präparate zu kaufen, von deren Wirksamkeit wir aufgrund klinischer Erfahrung überzeugt sind.

Es ist wichtig zu betonen, dass die Präparate empfohlen und nicht aufgedrängt wurden. Sie haben sie angenommen und bereits nach einem Monat ein deutliches Ergebnis erzielt, das Sie, wie Sie selbst anmerkten, an anderen Stellen lange nicht erreichen konnten!..

Wir freuen uns aufrichtig, dass wir Ihnen zu diesem positiven Ergebnis verhelfen konnten.
Gleichzeitig sind wir immer für eine objektive Bewertung: Sie kamen genau wegen des Ergebnisses — und wir haben es Ihnen geliefert.

Mit Respekt und Sorge um Ihre Gesundheit, Ihr Zentrum für Podologie und sichere Maniküre & Pediküre

iPODO .. für die, die den Unterschied verstehen & ihre Gesundheit schätzen //', 'Merhaba Junona!

Sonuçta tam da bizim merkezimizi - Karadağ\'daki Tek Uzmanlaşmış Podoloji Merkezi\'ni - 
iPODO • centre of Podology • Safe manicure pedicure seçtiğiniz ve yorumunuz için teşekkür ederiz!

iPODO - eşi benzeri olmayan Sterilite demektir. Servis. Kalite. 100\'den fazla! Fark & Avantaj.
Kurucusu ise Karadağ\'ın en tanınmış Podologu, Avrupa\'da ödül sahibi 🏆

Her müşteri için tıbbi kayıt tuttuğumuz için, - elektronik dosyanızı açtık ve tüm ziyaret geçmişinizi ve bütün önerileri görüyoruz.

Başlangıçta size Karadağ eczanelerinde bulunabilen ürünlerden yola çıkılarak öneriler yapıldı. Ayrıca size sormuştuk - yakın zamanda Ukrayna ya da Rusya\'ya bir yolculuk planlıyor musunuz, gerekli ürünleri orada almanız için.

Dahası, görüşmemizin kaydını çıkardık: ürünleri kendi ülkenizden ya da akrabalarınızın bulunduğu yerden almanız için size imkân sunmuştuk. Buna birkaç kez «hayır ve hayır» diye cevap verip şöyle dediniz: «Sizden alacağım»..
Bunlar sizin sözlerinizdi ve biz yalnızca, klinik deneyime dayanarak etkinliğinden emin olduğumuz profesyonel ürünleri bizden satın alma olanağını size sunduk.

Ürünlerin dayatılmadığını, önerildiğini vurgulamak önemli. Onları kabul ettiniz ve bir ay içinde, kendinizin de belirttiği gibi başka yerlerde uzun süre elde edilemeyen belirgin bir sonuç aldınız!..

Bu olumlu sonuca ulaşmanıza yardımcı olabildiğimiz için içtenlikle mutluyuz.
Aynı zamanda biz her zaman nesnel değerlendirmenin yanındayız: siz tam olarak sonuç için geldiniz — ve biz onu size sunduk.

Saygılarımızla ve sağlığınıza duyduğumuz özenle, podoloji ve güvenli manikür-pedikür merkeziniz

iPODO .. farkı anlayanlar & sağlığına değer verenler için //',
  'google_maps', '2025-10-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNKdV9IRzhnRRAB'),
  'clinic', @clinic_id,
  'Спасибо Вам!', 'ru',
  'Hvala Vama!', 'Хвала Вама!', 'Thank you!', 'Спасибо Вам!', 'Wir danken Ihnen!', 'Biz size teşekkür ederiz!',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSURic01xaFB3EAE'),
  'clinic', @clinic_id,
  'Вас действительно что-то не устроило?.. С удовольствием воспримем Вашу критику (только, пожалуйста, конструктивную), С Уважением', 'ru',
  'Da li Vam se zaista nešto nije svidjelo?.. Sa zadovoljstvom ćemo prihvatiti Vašu kritiku (samo, molimo Vas, konstruktivnu), S Uvažavanjem', 'Да ли Вам се заиста нешто није свидјело?.. Са задовољством ћемо прихватити Вашу критику (само, молимо Вас, конструктивну), С Уважавањем', 'Was there really something you were not happy with?.. We will gladly take your criticism on board (only, please, constructive), With Respect', 'Вас действительно что-то не устроило?.. С удовольствием воспримем Вашу критику (только, пожалуйста, конструктивную), С Уважением', 'Hat Ihnen wirklich etwas nicht gefallen?.. Wir nehmen Ihre Kritik gerne an (nur bitte konstruktiv), Mit Hochachtung', 'Gerçekten memnun kalmadığınız bir şey mi oldu?.. Eleştirinizi memnuniyetle dikkate alırız (ama lütfen yapıcı olsun), Saygılarımızla',
  'google_maps', '2025-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNsNFkzN1J3EAE'),
  'clinic', @clinic_id,
  'Спасибо! Благодарим Вас за правдивый отзыв! Здоровья Вам!!!

 С Уважением,
______

iPODO • centre of Podology •
Safe manicure & pediсure

| ВЫСШИЙ НОГТЕВОЙ СЕРВИС & решение проблем рук и ног _

Budva • Dukley
______ 

// ..для тех, кто понимает разницу & ценить своё здоровье //', 'ru',
  'Hvala! Zahvaljujemo Vam na iskrenoj recenziji! Želimo Vam zdravlje!!!

 S poštovanjem,
______

iPODO • centre of Podology •
Safe manicure & pediсure

| NAJVIŠI NIVO USLUGE ZA NOKTE & rješavanje problema ruku i stopala _

Budva • Dukley
______ 

// ..za one koji razumiju razliku & cijene svoje zdravlje //', 'Хвала! Захваљујемо Вам на искреној рецензији! Желимо Вам здравље!!!

 С поштовањем,
______

iPODO • centre of Podology •
Safe manicure & pediсure

| НАЈВИШИ НИВО УСЛУГЕ ЗА НОКТЕ & рјешавање проблема руку и стопала _

Budva • Dukley
______ 

// ..за оне који разумију разлику & цијене своје здравље //', 'Thank you! We thank you for your truthful review! Good health to you!!!

 Sincerely,
______

iPODO • centre of Podology •
Safe manicure & pediсure

| TOP-TIER NAIL SERVICE & solving hand and foot problems _

Budva • Dukley
______ 

// ..for those who understand the difference & value their health //', 'Спасибо! Благодарим Вас за правдивый отзыв! Здоровья Вам!!!

 С Уважением,
______

iPODO • centre of Podology •
Safe manicure & pediсure

| ВЫСШИЙ НОГТЕВОЙ СЕРВИС & решение проблем рук и ног _

Budva • Dukley
______ 

// ..для тех, кто понимает разницу & ценить своё здоровье //', 'Danke! Wir danken Ihnen für Ihre wahrheitsgemäße Bewertung! Bleiben Sie gesund!!!

 Mit freundlichen Grüßen,
______

iPODO • centre of Podology •
Safe manicure & pediсure

| HÖCHSTER NAGELSERVICE & Lösung von Hand- und Fußproblemen _

Budva • Dukley
______ 

// ..für die, die den Unterschied verstehen & ihre Gesundheit schätzen //', 'Teşekkürler! Dürüst yorumunuz için minnettarız! Sağlıklar dileriz!!!

 Saygılarımızla,
______

iPODO • centre of Podology •
Safe manicure & pediсure

| EN ÜST DÜZEY TIRNAK HİZMETİ & el ve ayak problemlerinin çözümü _

Budva • Dukley
______ 

// ..farkı anlayan & sağlığına değer verenler için //',
  'google_maps', '2024-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNscnNDQ0RnEAE'),
  'clinic', @clinic_id,
  'Благодарим за обратную связь и Отвечаем по существу:

1. iPODO | centre of Podology принял данного Клиента ещё 25 октября (никак не 2-3дня назад..), - который пришёл на Первичный приём с подозрением на проблемы онихомикозов и дерматомикозов и жалобой на то, что ранее полного выздоровления альтернативными методами никогда достигнуто не было.. (в том числе и лекарственными препаратами..)
2. На первичном приёме самым известным в Черногории Подологом - был осуществлён Комплексный осмотр, с тщательным детальным и подробнейшим разбором причин вследствие чего эти проблемы не были ранее решены полностью, и, как следствие постоянно рецедировали, - а именно:
3. Начиная - от элементарной обязательной регулярной гигиены обуви, правильной её обработки, проф.замера стопы и (внутреннего) замера носимой обуви.
4. Также был дан полный комплекс рекомендаций по решению выше-описанных проблем, исключающих само-заражение (здесь, как понимаете, одним универсальном кремом, к сожалению, никак не обойтись)
5. Все мероприятия носители исключительно рекомендательный характер и не обязывали Клиента приобретать рекомендуемые средства и препараты (и уж тем более обвинять в последующем в «насильственной» реализации…)

Для справки: iPODO | centre of Podology & Безопасного маникюра педикюра - является Единственным Официальным представителем в Черногории “Kart Professional” (Израиль) и продаёт всем своим ПОСТОЯННЫМ КЛИЕНТАМ ТОЛЬКО (!) ОРИГИНАЛЬНЫЕ ТОВАРЫ со скидкой до -40!%!!! Вся продукция ввозится ОФИЦИАЛЬНО (!) с уплатой всех необходимых таможенных платежей и налоговых сборов.

 С Уважением,
______

iPODO • centre of Podology •
Safe manicure & pediсure

| ВЫСШИЙ НОГТЕВОЙ СЕРВИС & решение проблем рук и ног _

Budva • Dukley
______ 

// ..для тех, кто понимает разницу & ценить своё здоровье //', 'ru',
  'Zahvaljujemo na povratnoj informaciji i Odgovaramo suštinski:

1. iPODO | centre of Podology primio je ovog Klijenta još 25. oktobra (nikako ne 2-3 dana ranije..), - koji je došao na Prvi pregled sa sumnjom na probleme onihomikoza i dermatomikoza i sa žalbom da ranije potpuno izlječenje alternativnim metodama nikada nije bilo postignuto.. (uključujući i lijekovima..)
2. Na prvom pregledu najpoznatiji Podolog u Crnoj Gori - izvršio je Kompleksan pregled, sa temeljnom, detaljnom i najpodrobnijom analizom uzroka zbog kojih ovi problemi ranije nisu bili riješeni do kraja i, kao posljedica, stalno su se vraćali, - a to su:
3. Počevši - od elementarne obavezne redovne higijene obuće, njene pravilne obrade, prof. mjerenja stopala i (unutrašnjeg) mjerenja obuće koja se nosi.
4. Takođe je dat kompletan set preporuka za rješavanje gore opisanih problema, koje isključuju samo-zarazu (ovdje se, kao što razumijete, s jednom univerzalnom kremom, nažalost, nikako ne može izaći na kraj)
5. Sve mjere imale su isključivo karakter preporuke i nisu obavezivale Klijenta da kupuje preporučena sredstva i preparate (a još manje da nas kasnije okrivljuje za „prisilnu“ prodaju…)

Za informaciju: iPODO | centre of Podology & Bezbjednog manikira i pedikira - jedini je Zvanični predstavnik “Kart Professional” (Izrael) u Crnoj Gori i svojim STALNIM KLIJENTIMA prodaje SAMO (!) ORIGINALNE PROIZVODE sa popustom do -40!%!!! Sva roba se uvozi ZVANIČNO (!) uz plaćanje svih potrebnih carinskih i poreskih obaveza.

 S poštovanjem,
______

iPODO • centre of Podology •
Safe manicure & pediсure

| NAJVIŠI NIVO USLUGE ZA NOKTE & rješavanje problema ruku i stopala _

Budva • Dukley
______ 

// ..za one koji razumiju razliku & cijene svoje zdravlje //', 'Захваљујемо на повратној информацији и Одговарамо суштински:

1. iPODO | centre of Podology примио је овог Клијента још 25. октобра (никако не 2-3 дана раније..), - који је дошао на Први преглед са сумњом на проблеме онихомикоза и дерматомикоза и са жалбом да раније потпуно излјечење алтернативним методама никада није било постигнуто.. (укључујући и лијековима..)
2. На првом прегледу најпознатији Подолог у Црној Гори - извршио је Комплексан преглед, са темељном, детаљном и најподробнијом анализом узрока због којих ови проблеми раније нису били ријешени до краја и, као посљедица, стално су се враћали, - а то су:
3. Почевши - од елементарне обавезне редовне хигијене обуће, њене правилне обраде, проф. мјерења стопала и (унутрашњег) мјерења обуће која се носи.
4. Такође је дат комплетан сет препорука за рјешавање горе описаних проблема, које искључују само-заразу (овдје се, као што разумијете, с једном универзалном кремом, нажалост, никако не може изаћи на крај)
5. Све мјере имале су искључиво карактер препоруке и нису обавезивале Клијента да купује препоручена средства и препарате (а још мање да нас касније окривљује за „присилну“ продају…)

За информацију: iPODO | centre of Podology & Безбједног маникира и педикира - једини је Званични представник “Kart Professional” (Израел) у Црној Гори и својим СТАЛНИМ КЛИЈЕНТИМА продаје САМО (!) ОРИГИНАЛНЕ ПРОИЗВОДЕ са попустом до -40!%!!! Сва роба се увози ЗВАНИЧНО (!) уз плаћање свих потребних царинских и пореских обавеза.

 С поштовањем,
______

iPODO • centre of Podology •
Safe manicure & pediсure

| НАЈВИШИ НИВО УСЛУГЕ ЗА НОКТЕ & рјешавање проблема руку и стопала _

Budva • Dukley
______ 

// ..за оне који разумију разлику & цијене своје здравље //', 'Thank you for the feedback and We Reply on the merits:

1. iPODO | centre of Podology received this Client back on October 25 (by no means 2-3 days ago..), - who came in for an Initial appointment with suspected onychomycosis and dermatomycosis problems and with a complaint that a full recovery had never previously been achieved by alternative methods.. (including with medications..)
2. At the initial appointment the most renowned Podiatrist in Montenegro carried out a Comprehensive examination, with a thorough, detailed and most exhaustive analysis of the reasons why these problems had not been fully resolved before and, as a consequence, kept recurring, - namely:
3. Starting - from elementary mandatory regular shoe hygiene, its correct treatment, professional measuring of the foot and (internal) measuring of the shoes being worn.
4. A full set of recommendations was also given for solving the problems described above, ruling out self-reinfection (here, as you will understand, one universal cream unfortunately will not do the job)
5. All the measures were exclusively of a recommendatory nature and did not oblige the Client to purchase the recommended products and preparations (much less to accuse us afterwards of “forced” selling…)

For your information: iPODO | centre of Podology & Safe manicure and pedicure - is the Only Official representative of “Kart Professional” (Israel) in Montenegro and sells all its REGULAR CLIENTS ONLY (!) ORIGINAL GOODS at a discount of up to -40!%!!! All products are imported OFFICIALLY (!) with payment of all the required customs duties and taxes.

 Sincerely,
______

iPODO • centre of Podology •
Safe manicure & pediсure

| TOP-TIER NAIL SERVICE & solving hand and foot problems _

Budva • Dukley
______ 

// ..for those who understand the difference & value their health //', 'Благодарим за обратную связь и Отвечаем по существу:

1. iPODO | centre of Podology принял данного Клиента ещё 25 октября (никак не 2-3дня назад..), - который пришёл на Первичный приём с подозрением на проблемы онихомикозов и дерматомикозов и жалобой на то, что ранее полного выздоровления альтернативными методами никогда достигнуто не было.. (в том числе и лекарственными препаратами..)
2. На первичном приёме самым известным в Черногории Подологом - был осуществлён Комплексный осмотр, с тщательным детальным и подробнейшим разбором причин вследствие чего эти проблемы не были ранее решены полностью, и, как следствие постоянно рецедировали, - а именно:
3. Начиная - от элементарной обязательной регулярной гигиены обуви, правильной её обработки, проф.замера стопы и (внутреннего) замера носимой обуви.
4. Также был дан полный комплекс рекомендаций по решению выше-описанных проблем, исключающих само-заражение (здесь, как понимаете, одним универсальном кремом, к сожалению, никак не обойтись)
5. Все мероприятия носители исключительно рекомендательный характер и не обязывали Клиента приобретать рекомендуемые средства и препараты (и уж тем более обвинять в последующем в «насильственной» реализации…)

Для справки: iPODO | centre of Podology & Безопасного маникюра педикюра - является Единственным Официальным представителем в Черногории “Kart Professional” (Израиль) и продаёт всем своим ПОСТОЯННЫМ КЛИЕНТАМ ТОЛЬКО (!) ОРИГИНАЛЬНЫЕ ТОВАРЫ со скидкой до -40!%!!! Вся продукция ввозится ОФИЦИАЛЬНО (!) с уплатой всех необходимых таможенных платежей и налоговых сборов.

 С Уважением,
______

iPODO • centre of Podology •
Safe manicure & pediсure

| ВЫСШИЙ НОГТЕВОЙ СЕРВИС & решение проблем рук и ног _

Budva • Dukley
______ 

// ..для тех, кто понимает разницу & ценить своё здоровье //', 'Wir danken für die Rückmeldung und Antworten zur Sache:

1. iPODO | centre of Podology hat diese Kundin bereits am 25. Oktober empfangen (keineswegs vor 2-3 Tagen..), - sie kam zum Ersttermin mit Verdacht auf Onychomykose- und Dermatomykose-Probleme und mit der Klage, dass eine vollständige Heilung mit alternativen Methoden früher nie erreicht worden sei.. (auch nicht mit Medikamenten..)
2. Beim Ersttermin wurde von der bekanntesten Podologin Montenegros eine Komplexuntersuchung durchgeführt, mit einer gründlichen, detaillierten und ausführlichsten Analyse der Ursachen, weshalb diese Probleme früher nicht vollständig gelöst worden waren und infolgedessen ständig wiederkehrten, - und zwar:
3. Angefangen - bei der elementaren, verpflichtenden regelmäßigen Schuhhygiene, deren korrekter Behandlung, der professionellen Vermessung des Fußes und der (Innen-)Vermessung der getragenen Schuhe.
4. Ebenso wurde ein komplettes Paket an Empfehlungen zur Lösung der oben beschriebenen Probleme gegeben, die eine Selbstansteckung ausschließen (hier kommt man, wie Sie verstehen, mit einer einzigen Universalcreme leider keineswegs aus)
5. Alle Maßnahmen hatten ausschließlich empfehlenden Charakter und verpflichteten die Kundin nicht, die empfohlenen Mittel und Präparate zu kaufen (und schon gar nicht, uns anschließend eines „erzwungenen“ Verkaufs zu beschuldigen…)

Zur Information: iPODO | centre of Podology & der sicheren Manikür und Pediküre - ist der Einzige Offizielle Vertreter von “Kart Professional” (Israel) in Montenegro und verkauft allen seinen STAMMKUNDEN AUSSCHLIESSLICH (!) ORIGINALWARE mit einem Rabatt von bis zu -40!%!!! Die gesamte Ware wird OFFIZIELL (!) eingeführt, unter Zahlung aller erforderlichen Zoll- und Steuerabgaben.

 Mit freundlichen Grüßen,
______

iPODO • centre of Podology •
Safe manicure & pediсure

| HÖCHSTER NAGELSERVICE & Lösung von Hand- und Fußproblemen _

Budva • Dukley
______ 

// ..für die, die den Unterschied verstehen & ihre Gesundheit schätzen //', 'Geri bildirim için teşekkür ederiz ve Esasa ilişkin Yanıtlıyoruz:

1. iPODO | centre of Podology bu Müşteriyi daha 25 Ekim\'de kabul etti (kesinlikle 2-3 gün önce değil..), - kendisi onikomikoz ve dermatomikoz şüphesiyle ve daha önce alternatif yöntemlerle (ilaçlar dahil..) hiçbir zaman tam bir iyileşme sağlanamadığı şikâyetiyle İlk muayeneye geldi.
2. İlk muayenede Karadağ\'ın en tanınmış Podologu tarafından Kapsamlı bir muayene yapıldı; bu problemlerin daha önce neden tam olarak çözülmediğinin ve sonuç olarak neden sürekli nüksettiğinin titiz, ayrıntılı ve en detaylı analizi yapıldı, - yani:
3. En temel düzeyden başlayarak - ayakkabının zorunlu düzenli hijyeninden, doğru şekilde dezenfekte edilmesinden, ayağın profesyonel ölçümünden ve giyilen ayakkabının (iç) ölçümünden.
4. Ayrıca yukarıda anlatılan problemlerin çözümü için, yeniden kendi kendine bulaşmayı önleyen eksiksiz bir öneri paketi verildi (burada, anlayacağınız üzere, ne yazık ki tek bir üniversal kremle iş bitmiyor)
5. Tüm bu işlemler yalnızca öneri niteliğindeydi ve Müşteriyi önerilen ürün ve preparatları satın almaya mecbur bırakmıyordu (kaldı ki sonradan bizi „zorla“ satış yapmakla suçlamak…)

Bilginize: iPODO | centre of Podology & Güvenli manikür ve pedikür - Karadağ\'da “Kart Professional” (İsrail) markasının Tek Resmî temsilcisidir ve tüm DÜZENLİ MÜŞTERİLERİNE SADECE (!) ORİJİNAL ÜRÜNLER satar, hem de -40!%\'e varan indirimle!!! Tüm ürünler, gereken tüm gümrük ve vergi ödemeleri yapılarak RESMÎ (!) yolla ithal edilir.

 Saygılarımızla,
______

iPODO • centre of Podology •
Safe manicure & pediсure

| EN ÜST DÜZEY TIRNAK HİZMETİ & el ve ayak problemlerinin çözümü _

Budva • Dukley
______ 

// ..farkı anlayan & sağlığına değer verenler için //',
  'google_maps', '2024-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ1NXIyWklnEAE'),
  'clinic', @clinic_id,
  'Спасибо Вам!', 'ru',
  'Hvala Vama!', 'Хвала Вама!', 'Thank you!', 'Спасибо Вам!', 'Vielen Dank Ihnen!', 'Size teşekkür ederiz!',
  'google_maps', '2024-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUM1d3ByX1JREAE'),
  'clinic', @clinic_id,
  'Благодарим Вас за высокую оценку! Приносим Вам свои извинения за нетипичную для нашего Образцового по СТЕРИЛЬНОСТИ & СЕРВИСУ & КАЧЕСТВУ - PODO-Центра ситуацию (наш ежедневный клиенто-поток порядка 100чел./день, а также - согласно стандартизации бизнес-процессов - Комплиментарные напитки предлагаются и подаются Клиентам уже на месте обслуживания, непосредственно после Размещения Клиента). Спасибо!!!', 'ru',
  'Zahvaljujemo Vam na visokoj ocjeni! Izvinjavamo Vam se zbog situacije netipične za naš PODO-Centar, koji je Uzoran po STERILNOSTI & USLUZI & KVALITETU (naš dnevni protok klijenata je oko 100 osoba/dan, a takođe - u skladu sa standardizacijom poslovnih procesa - Komplimentarni napici se nude i služe Klijentima već na samom mjestu tretmana, neposredno nakon što se Klijent smjesti). Hvala!!!', 'Захваљујемо Вам на високој оцјени! Извињавамо Вам се због ситуације нетипичне за наш PODO-Центар, који је Узоран по СТЕРИЛНОСТИ & УСЛУЗИ & КВАЛИТЕТУ (наш дневни проток клијената је око 100 особа/дан, а такође - у складу са стандардизацијом пословних процеса - Комплиментарни напици се нуде и служе Клијентима већ на самом мјесту третмана, непосредно након што се Клијент смјести). Хвала!!!', 'We thank you for the high rating! We apologise to you for a situation untypical of our PODO-Centre, which is Exemplary in STERILITY & SERVICE & QUALITY (our daily client flow is around 100 people/day, and also - in accordance with the standardisation of our business processes - Complimentary drinks are offered and served to Clients right at the treatment station, immediately after the Client has been seated). Thank you!!!', 'Благодарим Вас за высокую оценку! Приносим Вам свои извинения за нетипичную для нашего Образцового по СТЕРИЛЬНОСТИ & СЕРВИСУ & КАЧЕСТВУ - PODO-Центра ситуацию (наш ежедневный клиенто-поток порядка 100чел./день, а также - согласно стандартизации бизнес-процессов - Комплиментарные напитки предлагаются и подаются Клиентам уже на месте обслуживания, непосредственно после Размещения Клиента). Спасибо!!!', 'Wir danken Ihnen für die hohe Bewertung! Wir entschuldigen uns bei Ihnen für eine Situation, die für unser in STERILITÄT & SERVICE & QUALITÄT Vorbildliches PODO-Zentrum untypisch ist (unser täglicher Kundenstrom liegt bei etwa 100 Personen/Tag, und außerdem werden - gemäß der Standardisierung unserer Geschäftsprozesse - Komplimentärgetränke den Kunden bereits direkt am Behandlungsplatz angeboten und serviert, unmittelbar nachdem der Kunde Platz genommen hat). Danke!!!', 'Yüksek puanınız için teşekkür ederiz! STERİLİTE & HİZMET & KALİTE bakımından Örnek olan PODO-Merkezimiz için hiç tipik olmayan bu durum için sizden özür dileriz (günlük müşteri akışımız yaklaşık 100 kişi/gün, ayrıca - iş süreçlerimizin standardizasyonu gereği - İkram içecekler Müşterilere doğrudan hizmet noktasında, Müşteri yerine yerleştirildikten hemen sonra sunulur ve servis edilir). Teşekkürler!!!',
  'google_maps', '2024-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURaN1BqWi1BRRAB'),
  'clinic', @clinic_id,
  'Благодарим Вас!!!', 'ru',
  'Zahvaljujemo Vam!!!', 'Захваљујемо Вам!!!', 'Thank you very much!!!', 'Благодарим Вас!!!', 'Wir danken Ihnen!!!', 'Size teşekkür ederiz!!!',
  'google_maps', '2024-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNadlpLVHdnRRAB'),
  'clinic', @clinic_id,
  'Спасибо Вам! Вы - именно тот Клиент, который действительно понимает разницу & ценит своё здоровье - Клиент, Ради которого мы и работаем вот уже более 25лет! Будем ждать Вас снова!!!', 'ru',
  'Hvala Vama! Vi ste upravo onaj Klijent koji zaista razumije razliku & cijeni svoje zdravlje - Klijent, Zbog kojeg i radimo već više od 25 godina! Čekaćemo Vas ponovo!!!', 'Хвала Вама! Ви сте управо онај Клијент који заиста разумије разлику & цијени своје здравље - Клијент, Због којег и радимо већ више од 25 година! Чекаћемо Вас поново!!!', 'Thank you! You are exactly the kind of Client who truly understands the difference & values their health - the Client For whom we have been working for more than 25 years now! We\'ll be waiting for you again!!!', 'Спасибо Вам! Вы - именно тот Клиент, который действительно понимает разницу & ценит своё здоровье - Клиент, Ради которого мы и работаем вот уже более 25лет! Будем ждать Вас снова!!!', 'Vielen Dank Ihnen! Sie sind genau die Kundin, die den Unterschied wirklich versteht & ihre Gesundheit schätzt - die Kundin, Für die wir schon seit über 25 Jahren arbeiten! Wir warten wieder auf Sie!!!', 'Size teşekkür ederiz! Siz tam da farkı gerçekten anlayan & sağlığına değer veren o Müşterisiniz - Uğruna 25 yıldan fazla süredir çalıştığımız Müşteri! Sizi yine bekliyor olacağız!!!',
  'google_maps', '2024-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNwb29tdTVBRRAB'),
  'clinic', @clinic_id,
  'Благодарим Вас за высокую оценку!!!', 'ru',
  'Zahvaljujemo Vam na visokoj ocjeni!!!', 'Захваљујемо Вам на високој оцјени!!!', 'Thank you for the high rating!!!', 'Благодарим Вас за высокую оценку!!!', 'Wir danken Ihnen für die hohe Bewertung!!!', 'Yüksek puanınız için teşekkür ederiz!!!',
  'google_maps', '2024-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNKbXBlUlpREAE'),
  'clinic', @clinic_id,
  'Благодарим Вас! Очень рады, что проблема успешно решена нашим Ортопедом, Спасибо!!!', 'ru',
  'Zahvaljujemo Vam! Veoma nam je drago što je problem uspješno riješen od strane našeg Ortopeda, Hvala!!!', 'Захваљујемо Вам! Веома нам је драго што је проблем успјешно ријешен од стране нашег Ортопеда, Хвала!!!', 'Thank you! We are very glad that the problem was successfully solved by our Orthopaedist, Thank you!!!', 'Благодарим Вас! Очень рады, что проблема успешно решена нашим Ортопедом, Спасибо!!!', 'Wir danken Ihnen! Wir freuen uns sehr, dass das Problem von unserem Orthopäden erfolgreich gelöst wurde, Danke!!!', 'Size teşekkür ederiz! Sorunun Ortopedimiz tarafından başarıyla çözülmesine çok memnun olduk, Teşekkürler!!!',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNKMHU3S2VBEAE'),
  'clinic', @clinic_id,
  'Благодарим Вас!!! Рады стараться! Спасибо что выбрали -
iPODO | Центр Подологии & Безопасного маникюра педикюра', 'ru',
  'Zahvaljujemo Vam!!! Rado se trudimo! Hvala što ste izabrali -
iPODO | Centar Podologije & Bezbjednog manikira i pedikira', 'Захваљујемо Вам!!! Радо се трудимо! Хвала што сте изабрали -
iPODO | Центар Подологије & Безбједног маникира и педикира', 'Thank you!!! Happy to be of service! Thank you for choosing -
iPODO | Centre of Podology & Safe manicure and pedicure', 'Благодарим Вас!!! Рады стараться! Спасибо что выбрали -
iPODO | Центр Подологии & Безопасного маникюра педикюра', 'Wir danken Ihnen!!! Wir geben gern unser Bestes! Danke, dass Sie sich entschieden haben für -
iPODO | Zentrum für Podologie & sichere Maniküre und Pediküre', 'Size teşekkür ederiz!!! Hizmetinizde olmak bizim için mutluluk! Bizi seçtiğiniz için teşekkürler -
iPODO | Podoloji & Güvenli manikür pedikür Merkezi',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNKbE9HQ3RBRRAB'),
  'clinic', @clinic_id,
  'iPODO | Центр Подологии & Безопасного маникюра педикюра _
ответ на входящую «рекламацию»:

1.Благодарим Вас и за «такой отзыв» (ибо жалоба как подарок)) -
хотя, к сожалению, - конкретно этот случай является лишь нелепой попыткой дискредитации нашего -

!Образцово-Показательного Центра, не имеющего аналогов в ЧГ! - и по уровню оснащения, и по Качеству, и по Сервису, и комплексной системной Стерилизации & Дезинфекции /в 15!ЭТАПОВ/

2.Напоминаем, что Мы ВСЕГДА отвечаем за свою работу - ведь качество АБСОЛЮТНО ВСЕХ РАБОТ наших Мастеров-Технологов (а это самый высокий уровень в Бьюти-индустрии) - курирует Лично(!) Призёр Чемпионата Европы, Подолог, PODO-expert с 25-летним стажем - основатель iPODO АнютаПризёрЕвропы //

| А теперь - давайте конкретизируем по данной «претензии»:

3.Клиент пришёл к нам на действительно эффективный, признанный во всем мире препаратный педикюр Kart (Израиль) с последующим покрытием лаком - 
ВНИМАНИЕ (!) ..В УЗКОЙ ЗАКРЫТОЙ ОБУВИ..🤷‍♂️ (что априори некорректно..)

4.Администратор мгновенно - после того, как Клиент сообщил о возникшей у него проблеме - предложил перекрыть ноготок в !ЛЮБОЕ ВРЕМЯ И БЕЗ ОПЛАТЫ! - для решения этого вопроса (но токсичным людям видимо нужен не результат - а что-то другое🤔)

5.Технология максимально качественного и эффективного Препаратного педикюра KART - просто исключает (!!!) шершавые пятки (..если конечно Клиент не ходит босиком.., по песку.., по гальке.. и тд.)...

6.И, наконец, для справки (из историй посещений): этот Клиент ранее обратился в наш iPODO Центр с проблемой Онихолизис 70% ногтевой пластины - в результате чего проблема была УСПЕШНО (!) решена нашим ПОДОЛОГОМ (хотя никто и нигде не мог ранее её решить..) //

..И было-бы здорово научиться Быть Благодарными и написать лучше об этом ПОЛОЖИТЕЛЬНЫЙ ОТЗЫВ!!!, а не...

(..Хотя, видимо, кому что ближе;))..
_____

С Уважением,

iPODO • Центр Подологии & Безопасного маникюра педикюра 

| ВЫСШИЙ НОГТЕВОЙ СЕРВИС & решение проблем рук и ног _ 

* Стерильность.
* Сервис.
* Качество.

/ Более 100 Отличий & Преимуществ /

-1995- основан Призёром Европы

_________

iPODO • centre of Podology •
Safe manicure & pediсure

Budva • Dukley

// ..для тех, кто понимает разницу & ценит своё здоровье //

+382(69)295111

https://instagram.com/ipodo_azh?igshid=ZDg1NjBiNjg=


Итак, По правилам iPODO | Центр Подологии & Безопасного маникюра педикюра - ВСЕГДА действует 100% Гарантия на услуги (и, если действительно в чём-то неправы, - решаем, и абсолютно Бесплатно!); 2.Качество ВСЕХ Услуг априори ВЫШЕ (!) любых других мастеров и салонов в ЧГ, - благодаря наличию более 100 Отличий & Преимуществ + Комплексному и Системному подходу + Приём осуществляется в Специализированном Подологическом Центре, не имеющем по уровню Оснащения, Оборудования, Стерилизации и Дезинфекции - как Лично (!) Призёром Европы, так и Мастерами-Технологами; 3.У нас действительно ДОСТУПНО - всего от 30евро!', 'ru',
  'iPODO | Centar Podologije & Bezbjednog manikira pedikira _
odgovor na pristiglu «reklamaciju»:

1.Hvala Vam i na «takvoj recenziji» (jer je žalba kao poklon)) -
mada je, nažalost, - konkretno ovaj slučaj samo nakaradan pokušaj diskreditacije našeg -

!Uzorno-Pokaznog Centra, koji nema sebi ravnog u CG! - ni po nivou opremljenosti, ni po Kvalitetu, ni po Servisu, ni po kompleksnoj sistemskoj Sterilizaciji & Dezinfekciji /u 15!FAZA/

2.Podsjećamo da Mi UVIJEK odgovaramo za svoj rad - jer kvalitet APSOLUTNO SVIH RADOVA naših Majstora-Tehnologa (a to je najviši nivo u Beauty industriji) - nadgleda Lično(!) osvajačica nagrade na Evropskom prvenstvu, Podolog, PODO-expert sa 25 godina iskustva - osnivačica iPODO AnjutaPrizerEvrope //

| A sada - da konkretizujemo ovu «pritužbu»:

3.Klijent je došao kod nas na zaista efikasan, u cijelom svijetu priznat preparatni pedikir Kart (Izrael) sa naknadnim lakiranjem - 
PAŽNJA (!) ..U USKOJ ZATVORENOJ OBUĆI..🤷‍♂️ (što je apriori nekorektno..)

4.Administrator je momentalno - nakon što je Klijent prijavio problem koji mu se pojavio - predložio da se nokat prelakira u !BILO KOJE VRIJEME I BEZ PLAĆANJA! - kako bi se to pitanje riješilo (ali toksičnim ljudima očigledno nije potreban rezultat - nego nešto drugo🤔)

5.Tehnologija maksimalno kvalitetnog i efikasnog Preparatnog pedikira KART - prosto isključuje (!!!) rapave pete (..ako, naravno, Klijent ne hoda bos.., po pijesku.., po šljunku.. itd.)...

6.I, na kraju, informacije radi (iz istorije posjeta): ovaj Klijent nam se ranije obratio u naš iPODO Centar sa problemom Oniholize 70% nokatne ploče - i taj problem je USPJEŠNO (!) riješio naš PODOLOG (mada ga niko i nigdje ranije nije mogao riješiti..) //

..I bilo bi sjajno naučiti Biti Zahvalan i napisati radije o tome POZITIVNU RECENZIJU!!!, a ne...

(..Mada je, očigledno, kome šta bliže;))..
_____

S Poštovanjem,

iPODO • Centar Podologije & Bezbjednog manikira pedikira 

| NAJVIŠI NOKATNI SERVIS & rješavanje problema ruku i nogu _ 

* Sterilnost.
* Servis.
* Kvalitet.

/ Više od 100 Razlika & Prednosti /

-1995- osnovala Osvajačica nagrade Evrope

_________

iPODO • centre of Podology •
Safe manicure & pediсure

Budva • Dukley

// ..za one koji razumiju razliku & cijene svoje zdravlje //

+382(69)295111

https://instagram.com/ipodo_azh?igshid=ZDg1NjBiNjg=


Dakle, Po pravilima iPODO | Centar Podologije & Bezbjednog manikira pedikira - UVIJEK važi 100% Garancija na usluge (i, ako smo zaista u nečemu u krivu, - rješavamo, i to apsolutno Besplatno!); 2.Kvalitet SVIH Usluga je apriori VIŠI (!) od bilo kojih drugih majstora i salona u CG, - zahvaljujući tome što imamo više od 100 Razlika & Prednosti + Kompleksnom i Sistemskom pristupu + Prijem se vrši u Specijalizovanom Podološkom Centru koji nema sebi ravnog po nivou Opremljenosti, Aparata, Sterilizacije i Dezinfekcije - kako Lično (!) Osvajačica nagrade Evrope, tako i Majstori-Tehnolozi; 3.Kod nas je zaista PRISTUPAČNO - već od 30 eura!', 'iPODO | Центар Подологије & Безбједног маникира педикира _
одговор на приспјелу «рекламацију»:

1.Хвала Вам и на «таквој рецензији» (јер је жалба као поклон)) -
мада је, нажалост, - конкретно овај случај само накарадан покушај дискредитације нашег -

!Узорно-Показног Центра, који нема себи равног у ЦГ! - ни по нивоу опремљености, ни по Квалитету, ни по Сервису, ни по комплексној системској Стерилизацији & Дезинфекцији /у 15!ФАЗА/

2.Подсјећамо да Ми УВИЈЕК одговарамо за свој рад - јер квалитет АПСОЛУТНО СВИХ РАДОВА наших Мајстора-Технолога (а то је највиши ниво у Beauty индустрији) - надгледа Лично(!) освајачица награде на Европском првенству, Подолог, PODO-expert са 25 година искуства - оснивачица iPODO АњутаПризерЕвропе //

| А сада - да конкретизујемо ову «притужбу»:

3.Клијент је дошао код нас на заиста ефикасан, у цијелом свијету признат препаратни педикир Kart (Израел) са накнадним лакирањем - 
ПАЖЊА (!) ..У УСКОЈ ЗАТВОРЕНОЈ ОБУЋИ..🤷‍♂️ (што је априори некоректно..)

4.Администратор је моментално - након што је Клијент пријавио проблем који му се појавио - предложио да се нокат прелакира у !БИЛО КОЈЕ ВРИЈЕМЕ И БЕЗ ПЛАЋАЊА! - како би се то питање ријешило (али токсичним људима очигледно није потребан резултат - него нешто друго🤔)

5.Технологија максимално квалитетног и ефикасног Препаратног педикира KART - просто искључује (!!!) рапаве пете (..ако, наравно, Клијент не хода бос.., по пијеску.., по шљунку.. итд.)...

6.И, на крају, информације ради (из историје посјета): овај Клијент нам се раније обратио у наш iPODO Центар са проблемом Онихолизе 70% нокатне плоче - и тај проблем је УСПЈЕШНО (!) ријешио наш ПОДОЛОГ (мада га нико и нигдје раније није могао ријешити..) //

..И било би сјајно научити Бити Захвалан и написати радије о томе ПОЗИТИВНУ РЕЦЕНЗИЈУ!!!, а не...

(..Мада је, очигледно, коме шта ближе;))..
_____

С Поштовањем,

iPODO • Центар Подологије & Безбједног маникира педикира 

| НАЈВИШИ НОКАТНИ СЕРВИС & рјешавање проблема руку и ногу _ 

* Стерилност.
* Сервис.
* Квалитет.

/ Више од 100 Разлика & Предности /

-1995- основала Освајачица награде Европе

_________

iPODO • centre of Podology •
Safe manicure & pediсure

Budva • Dukley

// ..за оне који разумију разлику & цијене своје здравље //

+382(69)295111

https://instagram.com/ipodo_azh?igshid=ZDg1NjBiNjg=


Дакле, По правилима iPODO | Центар Подологије & Безбједног маникира педикира - УВИЈЕК важи 100% Гаранција на услуге (и, ако смо заиста у нечему у криву, - рјешавамо, и то апсолутно Бесплатно!); 2.Квалитет СВИХ Услуга је априори ВИШИ (!) од било којих других мајстора и салона у ЦГ, - захваљујући томе што имамо више од 100 Разлика & Предности + Комплексном и Системском приступу + Пријем се врши у Специјализованом Подолошком Центру који нема себи равног по нивоу Опремљености, Апарата, Стерилизације и Дезинфекције - како Лично (!) Освајачица награде Европе, тако и Мајстори-Технолози; 3.Код нас је заиста ПРИСТУПАЧНО - већ од 30 еура!', 'iPODO | Centre of Podology & Safe manicure pedicure _
response to the incoming «complaint»:

1.We thank you even for «a review like this» (since a complaint is a gift)) -
although, unfortunately, - this particular case is nothing but a ludicrous attempt to discredit our -

!Model Showcase Centre, which has no equal in Montenegro! - neither in the level of equipment, nor in Quality, nor in Service, nor in the comprehensive systemic Sterilisation & Disinfection /in 15!STAGES/

2.We remind you that We ALWAYS stand behind our work - because the quality of ABSOLUTELY ALL THE WORK of our Master Technologists (and that is the highest level in the Beauty industry) - is supervised Personally(!) by a European Championship Prize Winner, Podiatrist, PODO-expert with 25 years of experience - the founder of iPODO AnjutaEuropeanPrizeWinner //

| And now - let\'s get specific about this «claim»:

3.The client came to us for the genuinely effective, world-renowned Kart (Israel) product-based pedicure with a subsequent polish coating - 
ATTENTION (!) ..IN TIGHT CLOSED SHOES..🤷‍♂️ (which is a priori incorrect..)

4.The administrator instantly - as soon as the Client reported the problem that had come up - offered to recoat the nail at !ANY TIME AND FREE OF CHARGE! - to settle the matter (but toxic people apparently don\'t need a result - they need something else🤔)

5.The technology of the top-quality and most effective KART Product-based pedicure - simply rules out (!!!) rough heels (..unless, of course, the Client walks barefoot.., on sand.., on pebbles.. etc.)...

6.And finally, for the record (from the visit history): this Client came to our iPODO Centre earlier with onycholysis of 70% of the nail plate - and that problem was SUCCESSFULLY (!) solved by our PODIATRIST (although no one anywhere had been able to solve it before..) //

..And it would be great to learn to Be Grateful and to write a POSITIVE REVIEW about that instead!!!, rather than...

(..Although, apparently, to each their own;))..
_____

Best regards,

iPODO • Centre of Podology & Safe manicure pedicure 

| TOP NAIL SERVICE & solving hand and foot problems _ 

* Sterility.
* Service.
* Quality.

/ More than 100 Differences & Advantages /

-1995- founded by a European Prize Winner

_________

iPODO • centre of Podology •
Safe manicure & pediсure

Budva • Dukley

// ..for those who understand the difference & value their health //

+382(69)295111

https://instagram.com/ipodo_azh?igshid=ZDg1NjBiNjg=


So, under the rules of iPODO | Centre of Podology & Safe manicure pedicure - a 100% Guarantee on services ALWAYS applies (and if we really are wrong about something, - we sort it out, and absolutely Free of charge!); 2.The quality of ALL Services is a priori HIGHER (!) than that of any other technicians and salons in Montenegro, - thanks to more than 100 Differences & Advantages + a Comprehensive and Systemic approach + Appointments take place in a Specialised Podology Centre that has no equal in its level of Equipment, Machinery, Sterilisation and Disinfection - both by the European Prize Winner Personally (!) and by the Master Technologists; 3.We really are AFFORDABLE - from just 30 euros!', 'iPODO | Центр Подологии & Безопасного маникюра педикюра _
ответ на входящую «рекламацию»:

1.Благодарим Вас и за «такой отзыв» (ибо жалоба как подарок)) -
хотя, к сожалению, - конкретно этот случай является лишь нелепой попыткой дискредитации нашего -

!Образцово-Показательного Центра, не имеющего аналогов в ЧГ! - и по уровню оснащения, и по Качеству, и по Сервису, и комплексной системной Стерилизации & Дезинфекции /в 15!ЭТАПОВ/

2.Напоминаем, что Мы ВСЕГДА отвечаем за свою работу - ведь качество АБСОЛЮТНО ВСЕХ РАБОТ наших Мастеров-Технологов (а это самый высокий уровень в Бьюти-индустрии) - курирует Лично(!) Призёр Чемпионата Европы, Подолог, PODO-expert с 25-летним стажем - основатель iPODO АнютаПризёрЕвропы //

| А теперь - давайте конкретизируем по данной «претензии»:

3.Клиент пришёл к нам на действительно эффективный, признанный во всем мире препаратный педикюр Kart (Израиль) с последующим покрытием лаком - 
ВНИМАНИЕ (!) ..В УЗКОЙ ЗАКРЫТОЙ ОБУВИ..🤷‍♂️ (что априори некорректно..)

4.Администратор мгновенно - после того, как Клиент сообщил о возникшей у него проблеме - предложил перекрыть ноготок в !ЛЮБОЕ ВРЕМЯ И БЕЗ ОПЛАТЫ! - для решения этого вопроса (но токсичным людям видимо нужен не результат - а что-то другое🤔)

5.Технология максимально качественного и эффективного Препаратного педикюра KART - просто исключает (!!!) шершавые пятки (..если конечно Клиент не ходит босиком.., по песку.., по гальке.. и тд.)...

6.И, наконец, для справки (из историй посещений): этот Клиент ранее обратился в наш iPODO Центр с проблемой Онихолизис 70% ногтевой пластины - в результате чего проблема была УСПЕШНО (!) решена нашим ПОДОЛОГОМ (хотя никто и нигде не мог ранее её решить..) //

..И было-бы здорово научиться Быть Благодарными и написать лучше об этом ПОЛОЖИТЕЛЬНЫЙ ОТЗЫВ!!!, а не...

(..Хотя, видимо, кому что ближе;))..
_____

С Уважением,

iPODO • Центр Подологии & Безопасного маникюра педикюра 

| ВЫСШИЙ НОГТЕВОЙ СЕРВИС & решение проблем рук и ног _ 

* Стерильность.
* Сервис.
* Качество.

/ Более 100 Отличий & Преимуществ /

-1995- основан Призёром Европы

_________

iPODO • centre of Podology •
Safe manicure & pediсure

Budva • Dukley

// ..для тех, кто понимает разницу & ценит своё здоровье //

+382(69)295111

https://instagram.com/ipodo_azh?igshid=ZDg1NjBiNjg=


Итак, По правилам iPODO | Центр Подологии & Безопасного маникюра педикюра - ВСЕГДА действует 100% Гарантия на услуги (и, если действительно в чём-то неправы, - решаем, и абсолютно Бесплатно!); 2.Качество ВСЕХ Услуг априори ВЫШЕ (!) любых других мастеров и салонов в ЧГ, - благодаря наличию более 100 Отличий & Преимуществ + Комплексному и Системному подходу + Приём осуществляется в Специализированном Подологическом Центре, не имеющем по уровню Оснащения, Оборудования, Стерилизации и Дезинфекции - как Лично (!) Призёром Европы, так и Мастерами-Технологами; 3.У нас действительно ДОСТУПНО - всего от 30евро!', 'iPODO | Zentrum für Podologie & sichere Maniküre Pediküre _
Antwort auf die eingegangene «Reklamation»:

1.Wir danken Ihnen auch für «so eine Bewertung» (denn eine Beschwerde ist wie ein Geschenk)) -
auch wenn dieser konkrete Fall leider - nur ein lächerlicher Versuch ist, unser -

!Vorzeige-Musterzentrum zu diskreditieren, das in Montenegro nicht seinesgleichen hat! - weder beim Ausstattungsniveau, noch bei der Qualität, noch beim Service, noch bei der komplexen systemischen Sterilisation & Desinfektion /in 15!STUFEN/

2.Wir erinnern daran, dass Wir IMMER für unsere Arbeit haften - denn die Qualität ABSOLUT ALLER ARBEITEN unserer Meister-Technologen (und das ist das höchste Niveau in der Beauty-Branche) - wird Persönlich(!) von einer Preisträgerin der Europameisterschaft, Podologin, PODO-Expertin mit 25 Jahren Erfahrung betreut - der Gründerin von iPODO, AnjutaEuropaPreisträgerin //

| Und jetzt - werden wir bei dieser «Beanstandung» konkret:

3.Der Kunde kam zu uns für die wirklich wirksame, weltweit anerkannte Präparate-Pediküre Kart (Israel) mit anschließender Lackierung - 
ACHTUNG (!) ..IN ENGEN GESCHLOSSENEN SCHUHEN..🤷‍♂️ (was von vornherein falsch ist..)

4.Die Administratorin hat sofort - nachdem der Kunde das aufgetretene Problem gemeldet hatte - angeboten, den Nagel zu !JEDER ZEIT UND KOSTENLOS! neu zu lackieren - um die Sache zu klären (aber toxische Menschen brauchen offenbar kein Ergebnis - sondern etwas anderes🤔)

5.Die Technologie der höchstwertigen und wirksamsten Präparate-Pediküre KART - schließt raue Hacken einfach aus (!!!) (..sofern der Kunde natürlich nicht barfuß läuft.., über Sand.., über Kiesel.. usw.)...

6.Und schließlich, zur Information (aus der Besuchshistorie): dieser Kunde hat sich früher an unser iPODO Zentrum mit einer Onycholyse von 70% der Nagelplatte gewandt - und dieses Problem wurde von unserem PODOLOGEN ERFOLGREICH (!) gelöst (obwohl es vorher niemand und nirgends lösen konnte..) //

..Und es wäre großartig, zu lernen, Dankbar zu Sein und lieber darüber eine POSITIVE BEWERTUNG zu schreiben!!!, und nicht...

(..Wobei offenbar jedem das Seine;))..
_____

Mit freundlichen Grüßen,

iPODO • Zentrum für Podologie & sichere Maniküre Pediküre 

| HÖCHSTER NAGELSERVICE & Lösung von Hand- und Fußproblemen _ 

* Sterilität.
* Service.
* Qualität.

/ Mehr als 100 Unterschiede & Vorteile /

-1995- gegründet von einer Europa-Preisträgerin

_________

iPODO • centre of Podology •
Safe manicure & pediсure

Budva • Dukley

// ..für die, die den Unterschied verstehen & ihre Gesundheit schätzen //

+382(69)295111

https://instagram.com/ipodo_azh?igshid=ZDg1NjBiNjg=


Also, Nach den Regeln von iPODO | Zentrum für Podologie & sichere Maniküre Pediküre - gilt IMMER eine 100% Garantie auf die Leistungen (und wenn wir in etwas wirklich im Unrecht sind, - klären wir das, und zwar absolut Kostenlos!); 2.Die Qualität ALLER Leistungen ist von vornherein HÖHER (!) als bei allen anderen Fachkräften und Salons in Montenegro, - dank mehr als 100 Unterschieden & Vorteilen + dem Komplexen und Systemischen Ansatz + die Behandlung erfolgt in einem Spezialisierten Podologie-Zentrum, das beim Niveau der Ausstattung, der Geräte, der Sterilisation und Desinfektion nicht seinesgleichen hat - sowohl durch die Europa-Preisträgerin Persönlich (!) als auch durch die Meister-Technologen; 3.Bei uns ist es wirklich ERSCHWINGLICH - schon ab 30 Euro!', 'iPODO | Podoloji & Güvenli manikür pedikür Merkezi _
gelen «şikâyete» cevap:

1.«Böyle bir yorum» için de size teşekkür ederiz (çünkü şikâyet bir armağandır)) -
ne yazık ki bu somut vaka - sadece bizim -

!Karadağ\'da eşi benzeri olmayan Örnek-Model Merkezimizi! itibarsızlaştırmaya yönelik saçma bir girişimden başka bir şey değil - ne donanım düzeyinde, ne Kalitede, ne Servisde, ne de kapsamlı sistemli Sterilizasyon & Dezenfeksiyonda /15!AŞAMADA/

2.Hatırlatıyoruz: Biz HER ZAMAN yaptığımız işin arkasındayız - çünkü Master-Teknologlarımızın MUTLAK OLARAK TÜM İŞLERİNİN kalitesini (ve bu Beauty sektöründeki en yüksek seviyedir) - Bizzat(!) Avrupa Şampiyonası derece sahibi, Podolog, 25 yıllık deneyime sahip PODO-expert - iPODO\'nun kurucusu AnjutaAvrupaÖdüllü denetliyor //

| Şimdi de - bu «iddiayı» somutlaştıralım:

3.Müşteri bize gerçekten etkili, tüm dünyada kabul görmüş Kart (İsrail) preparatlı pedikürü ve ardından oje uygulaması için geldi - 
DİKKAT (!) ..DAR KAPALI AYAKKABIYLA..🤷‍♂️ (ki bu baştan yanlış..)

4.Yönetici anında - Müşteri ortaya çıkan sorunu bildirdikten sonra - tırnağın !HERHANGİ BİR ZAMANDA VE ÜCRETSİZ! yeniden kapatılmasını önerdi - meseleyi çözmek için (ama toksik insanlara galiba sonuç değil - başka bir şey gerekiyor🤔)

5.Azami kalitede ve etkili KART Preparatlı pedikür teknolojisi - pürüzlü topukları basitçe imkânsız kılar (!!!) (..elbette Müşteri yalınayak.., kumda.., çakılda.. vs. yürümüyorsa)...

6.Ve son olarak, bilgi olsun diye (ziyaret geçmişinden): bu Müşteri daha önce iPODO Merkezimize tırnak plağının %70\'inde Onikoliz sorunuyla başvurdu - ve bu sorun PODOLOGUMUZ tarafından BAŞARIYLA (!) çözüldü (oysa daha önce kimse hiçbir yerde çözememişti..) //

..Ve Minnettar Olmayı öğrenip bunun hakkında POZİTİF BİR YORUM yazmak çok güzel olurdu!!!, bunun yerine değil...

(..Gerçi herkese kendi yakın olan;))..
_____

Saygılarımızla,

iPODO • Podoloji & Güvenli manikür pedikür Merkezi 

| EN ÜST DÜZEY TIRNAK SERVİSİ & el ve ayak problemlerinin çözümü _ 

* Sterillik.
* Servis.
* Kalite.

/ 100\'den fazla Fark & Avantaj /

-1995- Avrupa ödül sahibi tarafından kuruldu

_________

iPODO • centre of Podology •
Safe manicure & pediсure

Budva • Dukley

// ..farkı anlayanlar & sağlığına değer verenler için //

+382(69)295111

https://instagram.com/ipodo_azh?igshid=ZDg1NjBiNjg=


Yani, iPODO | Podoloji & Güvenli manikür pedikür Merkezi kurallarına göre - hizmetler için HER ZAMAN %100 Garanti geçerlidir (ve gerçekten bir konuda hatalıysak, - çözeriz, hem de tamamen Ücretsiz!); 2.TÜM Hizmetlerin kalitesi Karadağ\'daki diğer tüm uzman ve salonlardan baştan DAHA YÜKSEKTİR (!), - 100\'den fazla Fark & Avantajın varlığı + Kapsamlı ve Sistemli yaklaşım + Kabulün, Donanım, Cihaz, Sterilizasyon ve Dezenfeksiyon düzeyi bakımından eşi olmayan Özel bir Podoloji Merkezinde yapılması sayesinde - hem Bizzat (!) Avrupa ödül sahibi hem de Master-Teknologlar tarafından; 3.Bizde gerçekten ERİŞİLEBİLİR - sadece 30 eurodan başlayan fiyatlarla!',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUR4cm9yMVB3EAE'),
  'clinic', @clinic_id,
  'Благодарим Вас! На самом деле всё действительно не случайно (и МЕДИЦИНСКАЯ СТЕРИЛЬНОСТЬ и ПОКАЗАТЕЛЬНЫЙ СЕРВИС и ЧЕМПИОНСКОЕ КАЧЕСТВО) - поскольку основатель настоящий ПРОФЕССИОНАЛ: АнютаПризёрЕвропы (Подолог, PODO-expert c (!)25-летним стажем) в сфере Индустрии красоты с 1995года! - как говорится: "Легко быть скромным, когда ты - лучший))" 

СПАСИБО ВАМ ОГРОМНОЕ!!! ИМЕННО РАДИ ТАКИХ БЛАГОДАРНЫХ КЛИЕНТОВ, действительно понимающих разницу (!!!) мы и работаем, БУДЕМ РАДЫ ВИДЕТЬ ВАС СНОВА и СНОВА !!!

С Уважением, 

iPODO | Центр Подологии & Безопасного маникюра педикюра

| ВЫСШИЙ НОГТЕВОЙ СЕРВИС & решение проблем рук и ног _

Стерильность. Сервис. Качество. 

/ Более 100 Отличий & Преимуществ /

BUDVA (DUKLEY)', 'ru',
  'Hvala Vam! Zaista ništa nije slučajno (i MEDICINSKA STERILNOST i UZORAN SERVIS i ŠAMPIONSKI KVALITET) - jer je osnivačica pravi PROFESIONALAC: AnjutaPrizerEvrope (Podolog, PODO-expert sa (!)25 godina iskustva) u sferi Industrije ljepote od 1995.godine! - kako se kaže: "Lako je biti skroman kad si najbolji))" 

OGROMNO VAM HVALA!!! UPRAVO ZBOG TAKVIH ZAHVALNIH KLIJENATA, koji zaista razumiju razliku (!!!) i radimo, BIĆE NAM DRAGO DA VAS VIDIMO PONOVO i PONOVO !!!

S Poštovanjem, 

iPODO | Centar Podologije & Bezbjednog manikira pedikira

| NAJVIŠI NOKATNI SERVIS & rješavanje problema ruku i nogu _

Sterilnost. Servis. Kvalitet. 

/ Više od 100 Razlika & Prednosti /

BUDVA (DUKLEY)', 'Хвала Вам! Заиста ништа није случајно (и МЕДИЦИНСКА СТЕРИЛНОСТ и УЗОРАН СЕРВИС и ШАМПИОНСКИ КВАЛИТЕТ) - јер је оснивачица прави ПРОФЕСИОНАЛАЦ: АњутаПризерЕвропе (Подолог, PODO-expert са (!)25 година искуства) у сфери Индустрије љепоте од 1995.године! - како се каже: "Лако је бити скроман кад си најбољи))" 

ОГРОМНО ВАМ ХВАЛА!!! УПРАВО ЗБОГ ТАКВИХ ЗАХВАЛНИХ КЛИЈЕНАТА, који заиста разумију разлику (!!!) и радимо, БИЋЕ НАМ ДРАГО ДА ВАС ВИДИМО ПОНОВО и ПОНОВО !!!

С Поштовањем, 

iPODO | Центар Подологије & Безбједног маникира педикира

| НАЈВИШИ НОКАТНИ СЕРВИС & рјешавање проблема руку и ногу _

Стерилност. Сервис. Квалитет. 

/ Више од 100 Разлика & Предности /

BUDVA (DUKLEY)', 'Thank you! In fact, nothing here is by chance (the MEDICAL STERILITY, the EXEMPLARY SERVICE and the CHAMPION-LEVEL QUALITY) - because the founder is a true PROFESSIONAL: AnjutaEuropeanPrizeWinner (Podiatrist, PODO-expert with (!)25 years of experience) in the Beauty Industry since 1995! - as they say: "It\'s easy to be modest when you\'re the best))" 

THANK YOU SO VERY MUCH!!! IT IS EXACTLY FOR SUCH GRATEFUL CLIENTS, who truly understand the difference (!!!), that we work. WE\'LL BE HAPPY TO SEE YOU AGAIN and AGAIN !!!

Best regards, 

iPODO | Centre of Podology & Safe manicure pedicure

| TOP NAIL SERVICE & solving hand and foot problems _

Sterility. Service. Quality. 

/ More than 100 Differences & Advantages /

BUDVA (DUKLEY)', 'Благодарим Вас! На самом деле всё действительно не случайно (и МЕДИЦИНСКАЯ СТЕРИЛЬНОСТЬ и ПОКАЗАТЕЛЬНЫЙ СЕРВИС и ЧЕМПИОНСКОЕ КАЧЕСТВО) - поскольку основатель настоящий ПРОФЕССИОНАЛ: АнютаПризёрЕвропы (Подолог, PODO-expert c (!)25-летним стажем) в сфере Индустрии красоты с 1995года! - как говорится: "Легко быть скромным, когда ты - лучший))" 

СПАСИБО ВАМ ОГРОМНОЕ!!! ИМЕННО РАДИ ТАКИХ БЛАГОДАРНЫХ КЛИЕНТОВ, действительно понимающих разницу (!!!) мы и работаем, БУДЕМ РАДЫ ВИДЕТЬ ВАС СНОВА и СНОВА !!!

С Уважением, 

iPODO | Центр Подологии & Безопасного маникюра педикюра

| ВЫСШИЙ НОГТЕВОЙ СЕРВИС & решение проблем рук и ног _

Стерильность. Сервис. Качество. 

/ Более 100 Отличий & Преимуществ /

BUDVA (DUKLEY)', 'Wir danken Ihnen! Tatsächlich ist wirklich nichts davon Zufall (die MEDIZINISCHE STERILITÄT, der VORBILDLICHE SERVICE und die MEISTERLICHE QUALITÄT) - denn die Gründerin ist eine echte PROFI: AnjutaEuropaPreisträgerin (Podologin, PODO-Expertin mit (!)25 Jahren Erfahrung) in der Beauty-Branche seit 1995! - wie man sagt: "Es ist leicht, bescheiden zu sein, wenn man die Beste ist))" 

GANZ HERZLICHEN DANK!!! GENAU FÜR SOLCHE DANKBAREN KUNDEN, die den Unterschied wirklich verstehen (!!!), arbeiten wir. WIR FREUEN UNS, SIE IMMER und IMMER WIEDER ZU SEHEN !!!

Mit freundlichen Grüßen, 

iPODO | Zentrum für Podologie & sichere Maniküre Pediküre

| HÖCHSTER NAGELSERVICE & Lösung von Hand- und Fußproblemen _

Sterilität. Service. Qualität. 

/ Mehr als 100 Unterschiede & Vorteile /

BUDVA (DUKLEY)', 'Size teşekkür ederiz! Aslında hiçbir şey tesadüf değil (hem MEDİKAL STERİLLİK hem ÖRNEK SERVİS hem de ŞAMPİYON KALİTESİ) - çünkü kurucu gerçek bir PROFESYONEL: AnjutaAvrupaÖdüllü (Podolog, (!)25 yıllık deneyime sahip PODO-expert) 1995 yılından beri Güzellik Sektöründe! - dedikleri gibi: "En iyi olduğunda alçakgönüllü olmak kolaydır))" 

ÇOK ÇOK TEŞEKKÜR EDERİZ!!! TAM DA BÖYLE MİNNETTAR MÜŞTERİLER İÇİN, farkı gerçekten anlayanlar için (!!!) çalışıyoruz, SİZİ TEKRAR ve TEKRAR GÖRMEKTEN MUTLU OLACAĞIZ !!!

Saygılarımızla, 

iPODO | Podoloji & Güvenli manikür pedikür Merkezi

| EN ÜST DÜZEY TIRNAK SERVİSİ & el ve ayak problemlerinin çözümü _

Sterillik. Servis. Kalite. 

/ 100\'den fazla Fark & Avantaj /

BUDVA (DUKLEY)',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUN4dDRDMEl3EAE'),
  'clinic', @clinic_id,
  'Благодарим, что ВЫСОКО оценили нашу работу, Спасибо Вам! Будем стараться для Вас и ВСЕХ НАШИХ КЛИЕНТОВ (Дюклей обязывает;))) 

С Уважением, 
iPODO • Центр Подологии & Безопасного маникюра педикюра 

| ВЫСШИЙ НОГТЕВОЙ СЕРВИС & 
решение проблем рук и ног _ 

• Стерильность. 
• Сервис. 
• Качество. 

/ Более 100 Отличий & Преимуществ / 

-1995- основан Призёром Европы 
_________ 

iPODO • centre of Podology • Safe manicure & pediсure 

Budva • Dukley 

+382(69)295111 

https://instagram.com/ipodo_azh?igshid=ZDg1NjBiNjg=', 'ru',
  'Zahvaljujemo što ste VISOKO ocijenili naš rad, Hvala Vam! Trudićemo se za Vas i SVE NAŠE KLIJENTE (Dukley obavezuje;))) 

S Uvažavanjem, 
iPODO • Centar Podologije & Bezbjednog manikira pedikira 

| VRHUNSKI SERVIS ZA NOKTE & 
rješavanje problema ruku i stopala _ 

• Sterilnost. 
• Servis. 
• Kvalitet. 

/ Više od 100 Razlika & Prednosti / 

-1995- osnovao Evropski Laureat 
_________ 

iPODO • centre of Podology • Safe manicure & pediсure 

Budva • Dukley 

+382(69)295111 

https://instagram.com/ipodo_azh?igshid=ZDg1NjBiNjg=', 'Захваљујемо што сте ВИСОКО оцијенили наш рад, Хвала Вам! Трудићемо се за Вас и СВЕ НАШЕ КЛИЈЕНТЕ (Dukley обавезује;))) 

С Уважавањем, 
iPODO • Центар Подологије & Безбједног маникира педикира 

| ВРХУНСКИ СЕРВИС ЗА НОКТЕ & 
рјешавање проблема руку и стопала _ 

• Стерилност. 
• Сервис. 
• Квалитет. 

/ Више од 100 Разлика & Предности / 

-1995- основао Европски Лауреат 
_________ 

iPODO • centre of Podology • Safe manicure & pediсure 

Budva • Dukley 

+382(69)295111 

https://instagram.com/ipodo_azh?igshid=ZDg1NjBiNjg=', 'Thank you for rating our work so HIGHLY, Thank You! We will keep doing our best for You and ALL OUR CLIENTS (Dukley sets the bar;))) 

With Respect, 
iPODO • Centre of Podology & Safe manicure pedicure 

| TOP-TIER NAIL SERVICE & 
solving problems of hands and feet _ 

• Sterility. 
• Service. 
• Quality. 

/ More than 100 Differences & Advantages / 

-1995- founded by a European Award Winner 
_________ 

iPODO • centre of Podology • Safe manicure & pediсure 

Budva • Dukley 

+382(69)295111 

https://instagram.com/ipodo_azh?igshid=ZDg1NjBiNjg=', 'Благодарим, что ВЫСОКО оценили нашу работу, Спасибо Вам! Будем стараться для Вас и ВСЕХ НАШИХ КЛИЕНТОВ (Дюклей обязывает;))) 

С Уважением, 
iPODO • Центр Подологии & Безопасного маникюра педикюра 

| ВЫСШИЙ НОГТЕВОЙ СЕРВИС & 
решение проблем рук и ног _ 

• Стерильность. 
• Сервис. 
• Качество. 

/ Более 100 Отличий & Преимуществ / 

-1995- основан Призёром Европы 
_________ 

iPODO • centre of Podology • Safe manicure & pediсure 

Budva • Dukley 

+382(69)295111 

https://instagram.com/ipodo_azh?igshid=ZDg1NjBiNjg=', 'Wir danken Ihnen, dass Sie unsere Arbeit so HOCH bewertet haben, Vielen Dank! Wir werden uns weiter für Sie und ALLE UNSERE KUNDEN einsetzen (Dukley verpflichtet;))) 

Mit Hochachtung, 
iPODO • Zentrum für Podologie & sichere Manikür-Pediküre 

| HÖCHSTER NAGEL-SERVICE & 
Lösung von Hand- und Fußproblemen _ 

• Sterilität. 
• Service. 
• Qualität. 

/ Mehr als 100 Unterschiede & Vorteile / 

-1995- gegründet von einer Europa-Preisträgerin 
_________ 

iPODO • centre of Podology • Safe manicure & pediсure 

Budva • Dukley 

+382(69)295111 

https://instagram.com/ipodo_azh?igshid=ZDg1NjBiNjg=', 'Çalışmamızı bu kadar YÜKSEK değerlendirdiğiniz için teşekkür ederiz, Size teşekkürler! Sizin ve TÜM MÜŞTERİLERİMİZ için elimizden geleni yapmaya devam edeceğiz (Dukley bunu gerektiriyor;))) 

Saygılarımızla, 
iPODO • Podoloji & Güvenli manikür pedikür Merkezi 

| EN ÜST DÜZEY TIRNAK HİZMETİ & 
el ve ayak sorunlarının çözümü _ 

• Sterilite. 
• Hizmet. 
• Kalite. 

/ 100\'den fazla Fark & Avantaj / 

-1995- Avrupa Ödüllü tarafından kuruldu 
_________ 

iPODO • centre of Podology • Safe manicure & pediсure 

Budva • Dukley 

+382(69)295111 

https://instagram.com/ipodo_azh?igshid=ZDg1NjBiNjg=',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURSMDViOF9RRRAB'),
  'clinic', @clinic_id,
  '1.Да! у нас Образцово СТЕРИЛЬНО. /комплексная и системная СТЕРИЛИЗАЦИЯ & ДЕЗИНФЕКЦИЯ - все все все 15(!) ЭТАПОВ/  

2.Да! у нас Действительно ПОКАЗАТЕЛЬНЫЙ СЕРВИС. /более 100(!) ОТЛИЧИЙ & ПРЕИМУЩЕСТВ (не имеет аналогов в ЧГ) //

3.Да! КАЧЕСТВО - ЧЕМПИОНСКОЕ. /качество ВСЕХ работ под Личным (!) патронажем Призёра Чемпионата Европы, Мастера-Инструктора международного класса, Подолога, PODO-expert с 25-летним СТАЖЕМ !

P/S/ только вот Вы, автор этого отзыва у нас , к сожалению, ещё не были - так как Абсолютно ВСЕ НАШИ КЛИЕНТЫ уходят со 100% результатом или (как минимум) ПОЛОЖИТЕЛЬНОЙ ДИНАМИКОЙ.

И - ДА!!! У нас действительно Успешный, Быстрый и Эффективный, плюс абсолютно Безболезненный метод удаления бородавок!

Для справки: я никогда не советую Ортопедические стельки при бородавках)) и никто из моих Клиентов не приходит ко мне за удалением больше 1-3раз, и точно не каждую неделю))) да и кератоз от "кислоты" не разрастается))), и, главное - в нашей Автоматизированной Клиентской базе мы не видим от Вас ни обращений, ни посещений))... 

(..Если-же Вы написали этот отзыв от чужого имени - пожалуйста назовите своё настоящее имя и мы благодаря нашей Уникальной специализированной картотеке (с фото) - поднимем всю "историю" и сможем Детально разобраться, Спасибо!)

С Уважением, АнютаПризёрЕвропы
 
основатель -
____________

iPODO * centre of Podology *
Safe manicure & pedicure

ВЫСШИЙ НОГТЕВОЙ СЕРВИС &
решение проблем рук ног _

Budva * DUKLEY

/..для тех, кто понимает разницу &
ценит своё здоровье //', 'ru',
  '1.Da! Kod nas je Uzorno STERILNO. /kompleksna i sistemska STERILIZACIJA & DEZINFEKCIJA - sve sve sve 15(!) FAZA/  

2.Da! Kod nas je Zaista UZORAN SERVIS. /više od 100(!) RAZLIKA & PREDNOSTI (nema sebi ravnog u CG) //

3.Da! KVALITET - ŠAMPIONSKI. /kvalitet SVIH radova pod Ličnim (!) patronatom Osvajačice nagrade na Evropskom prvenstvu, Majstora-Instruktora međunarodne klase, Podologa, PODO-expert sa 25 godina ISKUSTVA !

P/S/ samo što Vi, autor ove recenzije, kod nas, na žalost, još niste bili - jer Apsolutno SVI NAŠI KLIJENTI odlaze sa 100% rezultatom ili (u najmanju ruku) POZITIVNOM DINAMIKOM.

I - DA!!! Kod nas je zaista Uspješan, Brz i Efikasan, plus apsolutno Bezbolan metod uklanjanja bradavica!

Informacije radi: ja nikada ne savjetujem Ortopedske uloške kod bradavica)) i nijedan moj Klijent ne dolazi kod mene na uklanjanje više od 1-3 puta, a sigurno ne svake nedjelje))) a i keratoza se od "kiseline" ne širi))), i, što je najvažnije - u našoj Automatizovanoj Bazi Klijenata ne vidimo od Vas ni upite, ni posjete))... 

(..Ako ste pak ovu recenziju napisali pod tuđim imenom - molimo Vas navedite svoje pravo ime pa ćemo zahvaljujući našoj Jedinstvenoj specijalizovanoj kartoteci (sa fotografijama) - izvući cijelu "istoriju" i moći ćemo Detaljno da raščistimo stvar, Hvala!)

S Poštovanjem, AnjutaPrizerEvrope
 
osnivačica -
____________

iPODO * centre of Podology *
Safe manicure & pedicure

NAJVIŠI NOKATNI SERVIS &
rješavanje problema ruku nogu _

Budva * DUKLEY

/..za one koji razumiju razliku &
cijene svoje zdravlje //', '1.Да! Код нас је Узорно СТЕРИЛНО. /комплексна и системска СТЕРИЛИЗАЦИЈА & ДЕЗИНФЕКЦИЈА - све све све 15(!) ФАЗА/  

2.Да! Код нас је Заиста УЗОРАН СЕРВИС. /више од 100(!) РАЗЛИКА & ПРЕДНОСТИ (нема себи равног у ЦГ) //

3.Да! КВАЛИТЕТ - ШАМПИОНСКИ. /квалитет СВИХ радова под Личним (!) патронатом Освајачице награде на Европском првенству, Мајстора-Инструктора међународне класе, Подолога, PODO-expert са 25 година ИСКУСТВА !

P/S/ само што Ви, аутор ове рецензије, код нас, на жалост, још нисте били - јер Апсолутно СВИ НАШИ КЛИЈЕНТИ одлазе са 100% резултатом или (у најмању руку) ПОЗИТИВНОМ ДИНАМИКОМ.

И - ДА!!! Код нас је заиста Успјешан, Брз и Ефикасан, плус апсолутно Безболан метод уклањања брадавица!

Информације ради: ја никада не савјетујем Ортопедске улошке код брадавица)) и ниједан мој Клијент не долази код мене на уклањање више од 1-3 пута, а сигурно не сваке недјеље))) а и кератоза се од "киселине" не шири))), и, што је најважније - у нашој Аутоматизованој Бази Клијената не видимо од Вас ни упите, ни посјете))... 

(..Ако сте пак ову рецензију написали под туђим именом - молимо Вас наведите своје право име па ћемо захваљујући нашој Јединственој специјализованој картотеци (са фотографијама) - извући цијелу "историју" и моћи ћемо Детаљно да рашчистимо ствар, Хвала!)

С Поштовањем, АњутаПризерЕвропе
 
оснивачица -
____________

iPODO * centre of Podology *
Safe manicure & pedicure

НАЈВИШИ НОКАТНИ СЕРВИС &
рјешавање проблема руку ногу _

Budva * DUKLEY

/..за оне који разумију разлику &
цијене своје здравље //', '1.Yes! Our place is Exemplarily STERILE. /comprehensive and systemic STERILISATION & DISINFECTION - all all all 15(!) STAGES/  

2.Yes! Our SERVICE really is EXEMPLARY. /more than 100(!) DIFFERENCES & ADVANTAGES (no equal in Montenegro) //

3.Yes! The QUALITY is CHAMPION-LEVEL. /the quality of ALL the work is under the Personal (!) patronage of a European Championship Prize Winner, an international-class Master-Instructor, a Podiatrist, a PODO-expert with 25 years of EXPERIENCE !

P/S/ except that you, the author of this review, have unfortunately never been to us - because Absolutely ALL OUR CLIENTS leave with a 100% result or (at the very least) POSITIVE PROGRESS.

And - YES!!! Our method of removing warts really is Successful, Fast and Effective, plus absolutely Painless!

For the record: I never recommend Orthopaedic insoles for warts)) and none of my Clients comes to me for removal more than 1-3 times, and certainly not every week))) and keratosis does not spread from "acid" either))), and, most importantly - in our Automated Client database we see neither enquiries nor visits from you))... 

(..And if you wrote this review under someone else\'s name - please give your real name and, thanks to our Unique specialised card index (with photos), we will pull up the whole "history" and be able to sort it out in Detail, Thank you!)

Best regards, AnjutaEuropeanPrizeWinner
 
founder -
____________

iPODO * centre of Podology *
Safe manicure & pedicure

TOP NAIL SERVICE &
solving hand and foot problems _

Budva * DUKLEY

/..for those who understand the difference &
value their health //', '1.Да! у нас Образцово СТЕРИЛЬНО. /комплексная и системная СТЕРИЛИЗАЦИЯ & ДЕЗИНФЕКЦИЯ - все все все 15(!) ЭТАПОВ/  

2.Да! у нас Действительно ПОКАЗАТЕЛЬНЫЙ СЕРВИС. /более 100(!) ОТЛИЧИЙ & ПРЕИМУЩЕСТВ (не имеет аналогов в ЧГ) //

3.Да! КАЧЕСТВО - ЧЕМПИОНСКОЕ. /качество ВСЕХ работ под Личным (!) патронажем Призёра Чемпионата Европы, Мастера-Инструктора международного класса, Подолога, PODO-expert с 25-летним СТАЖЕМ !

P/S/ только вот Вы, автор этого отзыва у нас , к сожалению, ещё не были - так как Абсолютно ВСЕ НАШИ КЛИЕНТЫ уходят со 100% результатом или (как минимум) ПОЛОЖИТЕЛЬНОЙ ДИНАМИКОЙ.

И - ДА!!! У нас действительно Успешный, Быстрый и Эффективный, плюс абсолютно Безболезненный метод удаления бородавок!

Для справки: я никогда не советую Ортопедические стельки при бородавках)) и никто из моих Клиентов не приходит ко мне за удалением больше 1-3раз, и точно не каждую неделю))) да и кератоз от "кислоты" не разрастается))), и, главное - в нашей Автоматизированной Клиентской базе мы не видим от Вас ни обращений, ни посещений))... 

(..Если-же Вы написали этот отзыв от чужого имени - пожалуйста назовите своё настоящее имя и мы благодаря нашей Уникальной специализированной картотеке (с фото) - поднимем всю "историю" и сможем Детально разобраться, Спасибо!)

С Уважением, АнютаПризёрЕвропы
 
основатель -
____________

iPODO * centre of Podology *
Safe manicure & pedicure

ВЫСШИЙ НОГТЕВОЙ СЕРВИС &
решение проблем рук ног _

Budva * DUKLEY

/..для тех, кто понимает разницу &
ценит своё здоровье //', '1.Ja! Bei uns ist es Vorbildlich STERIL. /komplexe und systemische STERILISATION & DESINFEKTION - alle alle alle 15(!) STUFEN/  

2.Ja! Bei uns gibt es Wirklich VORBILDLICHEN SERVICE. /mehr als 100(!) UNTERSCHIEDE & VORTEILE (ohne Vergleich in Montenegro) //

3.Ja! Die QUALITÄT ist MEISTERLICH. /die Qualität ALLER Arbeiten steht unter der Persönlichen (!) Schirmherrschaft einer Preisträgerin der Europameisterschaft, einer Meister-Instruktorin internationaler Klasse, einer Podologin, PODO-Expertin mit 25 Jahren BERUFSERFAHRUNG !

P/S/ nur waren Sie, die Autorin dieser Bewertung, leider noch gar nicht bei uns - denn Absolut ALLE UNSERE KUNDEN gehen mit einem 100% Ergebnis oder (mindestens) einer POSITIVEN ENTWICKLUNG.

Und - JA!!! Wir haben wirklich eine Erfolgreiche, Schnelle und Wirksame plus absolut Schmerzfreie Methode zur Entfernung von Warzen!

Zur Information: ich empfehle bei Warzen niemals Orthopädische Einlagen)) und keiner meiner Kunden kommt mehr als 1-3 Mal zur Entfernung zu mir, und ganz sicher nicht jede Woche))) und Keratose breitet sich durch "Säure" auch nicht aus))), und, vor allem - in unserer Automatisierten Kundendatenbank sehen wir von Ihnen weder Anfragen noch Besuche))... 

(..Sollten Sie diese Bewertung aber unter fremdem Namen geschrieben haben - nennen Sie bitte Ihren echten Namen und wir holen dank unserer Einzigartigen spezialisierten Kartei (mit Fotos) die gesamte "Geschichte" hervor und können die Sache im Detail klären, Danke!)

Mit freundlichen Grüßen, AnjutaEuropaPreisträgerin
 
Gründerin -
____________

iPODO * centre of Podology *
Safe manicure & pedicure

HÖCHSTER NAGELSERVICE &
Lösung von Hand- und Fußproblemen _

Budva * DUKLEY

/..für die, die den Unterschied verstehen &
ihre Gesundheit schätzen //', '1.Evet! Bizde Örnek biçimde STERİL. /kapsamlı ve sistemli STERİLİZASYON & DEZENFEKSİYON - hepsi hepsi hepsi 15(!) AŞAMA/  

2.Evet! Bizde Gerçekten ÖRNEK SERVİS var. /100\'den(!) fazla FARK & AVANTAJ (Karadağ\'da eşi yok) //

3.Evet! KALİTE - ŞAMPİYON KALİTESİ. /TÜM işlerin kalitesi Avrupa Şampiyonası derece sahibinin, uluslararası sınıf Master-Eğitmenin, Podologun, 25 yıllık DENEYİME sahip PODO-expert\'in Bizzat (!) himayesi altında !

P/S/ ne var ki siz, bu yorumun yazarı, ne yazık ki bize hiç gelmediniz - çünkü Mutlak olarak TÜM MÜŞTERİLERİMİZ %100 sonuçla ya da (en azından) POZİTİF GELİŞMEYLE ayrılır.

Ve - EVET!!! Bizde gerçekten Başarılı, Hızlı ve Etkili, ayrıca tamamen Ağrısız bir siğil alma yöntemi var!

Bilgi olsun diye: siğillerde asla Ortopedik tabanlık önermem)) ve Müşterilerimin hiçbiri bana aldırmak için 1-3 kereden fazla gelmez, kesinlikle her hafta da gelmez))) ayrıca keratoz "asitten" yayılmaz da))), ve en önemlisi - Otomatikleştirilmiş Müşteri veritabanımızda sizden ne bir başvuru ne de bir ziyaret görüyoruz))... 

(..Eğer bu yorumu başkasının adıyla yazdıysanız - lütfen gerçek adınızı söyleyin, Eşsiz özel kartotekimiz (fotoğraflı) sayesinde tüm "geçmişi" çıkarır ve meseleyi Detaylı şekilde açıklığa kavuşturabiliriz, Teşekkürler!)

Saygılarımla, AnjutaAvrupaÖdüllü
 
kurucu -
____________

iPODO * centre of Podology *
Safe manicure & pedicure

EN ÜST DÜZEY TIRNAK SERVİSİ &
el ayak problemlerinin çözümü _

Budva * DUKLEY

/..farkı anlayanlar &
sağlığına değer verenler için //',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSURSa01fd0pBEAE'),
  'clinic', @clinic_id,
  'Спасибо Вам!!!

Качество &
Сервис &
Безопасность - для Всех Наших Постоянных и Новых Клиентов - 
на Премиум уровне!

С Уважением, 
______

iPODO • centre of Podology •
Safe manicure & pediсure

| ВЫСШИЙ НОГТЕВОЙ СЕРВИС & решение проблем рук и ног _

Budva • Dukley', 'ru',
  'Hvala Vam!!!

Kvalitet &
Servis &
Bezbjednost - za Sve Naše Stalne i Nove Klijente - 
na Premium nivou!

S Poštovanjem, 
______

iPODO • centre of Podology •
Safe manicure & pediсure

| NAJVIŠI NOKATNI SERVIS & rješavanje problema ruku i nogu _

Budva • Dukley', 'Хвала Вам!!!

Квалитет &
Сервис &
Безбједност - за Све Наше Сталне и Нове Клијенте - 
на Premium нивоу!

С Поштовањем, 
______

iPODO • centre of Podology •
Safe manicure & pediсure

| НАЈВИШИ НОКАТНИ СЕРВИС & рјешавање проблема руку и ногу _

Budva • Dukley', 'Thank you!!!

Quality &
Service &
Safety - for All Our Regular and New Clients - 
at a Premium level!

Best regards, 
______

iPODO • centre of Podology •
Safe manicure & pediсure

| TOP NAIL SERVICE & solving hand and foot problems _

Budva • Dukley', 'Спасибо Вам!!!

Качество &
Сервис &
Безопасность - для Всех Наших Постоянных и Новых Клиентов - 
на Премиум уровне!

С Уважением, 
______

iPODO • centre of Podology •
Safe manicure & pediсure

| ВЫСШИЙ НОГТЕВОЙ СЕРВИС & решение проблем рук и ног _

Budva • Dukley', 'Wir danken Ihnen!!!

Qualität &
Service &
Sicherheit - für Alle Unsere Stamm- und Neukunden - 
auf Premium-Niveau!

Mit freundlichen Grüßen, 
______

iPODO • centre of Podology •
Safe manicure & pediсure

| HÖCHSTER NAGELSERVICE & Lösung von Hand- und Fußproblemen _

Budva • Dukley', 'Size teşekkür ederiz!!!

Kalite &
Servis &
Güvenlik - Tüm Düzenli ve Yeni Müşterilerimiz için - 
Premium seviyede!

Saygılarımızla, 
______

iPODO • centre of Podology •
Safe manicure & pediсure

| EN ÜST DÜZEY TIRNAK SERVİSİ & el ve ayak problemlerinin çözümü _

Budva • Dukley',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNoX3ZLcU9REAE'),
  'clinic', @clinic_id,
  'Благодарим Вас! Рады стараться!!!', 'ru',
  'Hvala Vam! Sa zadovoljstvom se trudimo!!!', 'Хвала Вам! Са задовољством се трудимо!!!', 'Thank you! Happy to do our best!!!', 'Благодарим Вас! Рады стараться!!!', 'Wir danken Ihnen! Wir geben gern unser Bestes!!!', 'Size teşekkür ederiz! Elimizden geleni yapmaktan mutluyuz!!!',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURCdy0tTDZnRRAB'),
  'clinic', @clinic_id,
  'Мы ИСКРЕННЕ РАДЫ, что Вы (как и все в Чг) для действительно Качественного и Эффективного решении проблем рук и ног - выбрали ИМЕННО НАШ PODO-формат! Благодарим Вас за ПРАВИЛЬНЫЙ ВЫБОР!!! Ваша проблема решена - и это ГЛАВНОЕ (!!!)

Итак, все работы производила Лично(!) АнютаПризёрЕвропы | ПОДОЛОГ, podo-expert с 25-летним стажем в Специализированном PODO-кабинете (не имеющем аналогов в ЧГ!) и по уровню оснащения, и технологиям, и стерилизации & дезинфекции, - с применением всех самых современных Оригинальных Инструментов и Материалов. 

Все работы были выполнены, согласно Протоколу: ПРИЁМ+ОСМОТР+КОНСУЛЬТАЦИЯ+ОПРЕДЕЛЕНИЕ ПРОБЛЕМЫ+НЕПОСРЕДСТВЕННО САМО РЕШЕНИЕ ВАШЕЙ ПРОБЛЕМЫ (была произведена грамотная зачистка с установкой спец.тампонад - и всё это ИСКЛЮЧИТЕЛЬНО с применением специализированных оригинальных проф.материалов) + Разработаны и назначены Индивидуальный, персонализированный для решения именно Вашей проблемы РЕКОМЕНДАЦИИ + КОМПЛЕКСНЫЙ ДОМАШНИЙ УХОД (в том числе назначено и многофункциональное масло с комплексным воздействием, которое в том числе отвечает за эластичность ногтя и регенерацию тканей) = что в ИТОГЕ и ГАРАНТИРОВАЛО 100% ПОЛОЖИТЕЛЬНЫЙ РЕЗУЛЬТАТ (!) И МЫ ЭТОГО ДОБИЛИСЬ - ПОЗДРАВЛЯЕМ (!!!)

P/S. ..ВАМ ДОРОГО КАЧЕСТВО??  -Мы всегда оставляем за Клиентом право Выбора, в том числе и покупки назначенных препаратов и материалов (но в этом случае, естественно, результат гарантировать не сможем!!!)

С Уважением,

iPODO | praxis prizer europa
/by AнютаПризёрЕвропы/

| ВЫСШИЙ НОГТЕВОЙ СЕРВИС 
& решение проблем рук и ног _

//..для тех, кто понимает разницу & ценит своё здоровье //', 'ru',
  'ISKRENO NAM JE DRAGO što ste Vi (kao i svi u CG) za zaista Kvalitetno i Efikasno rješavanje problema ruku i nogu - izabrali UPRAVO NAŠ PODO-format! Hvala Vam na PRAVILNOM IZBORU!!! Vaš problem je riješen - i to je NAJVAŽNIJE (!!!)

Dakle, sve radove je izvodila Lično(!) AnjutaPrizerEvrope | PODOLOG, podo-expert sa 25 godina iskustva u Specijalizovanom PODO-kabinetu (koji nema sebi ravnog u CG!) i po nivou opremljenosti, i po tehnologijama, i po sterilizaciji & dezinfekciji, - uz primjenu svih najsavremenijih Originalnih Instrumenata i Materijala. 

Svi radovi su izvedeni prema Protokolu: PRIJEM+PREGLED+KONSULTACIJA+ODREĐIVANJE PROBLEMA+NEPOSREDNO SAMO RJEŠAVANJE VAŠEG PROBLEMA (izvršeno je stručno čišćenje sa postavljanjem spec.tamponada - i sve to ISKLJUČIVO uz primjenu specijalizovanih originalnih prof.materijala) + Razrađene i propisane Individualne, personalizovane PREPORUKE upravo za rješavanje Vašeg problema + KOMPLEKSNA KUĆNA NJEGA (između ostalog propisano je i multifunkcionalno ulje kompleksnog djelovanja, koje je odgovorno i za elastičnost nokta i regeneraciju tkiva) = što je NA KRAJU i GARANTOVALO 100% POZITIVAN REZULTAT (!) I MI SMO TO POSTIGLI - ČESTITAMO (!!!)

P/S. ..KVALITET VAM JE SKUP??  -Mi Klijentu uvijek ostavljamo pravo Izbora, uključujući i kupovinu propisanih preparata i materijala (ali u tom slučaju, naravno, rezultat nećemo moći da garantujemo!!!)

S Poštovanjem,

iPODO | praxis prizer europa
/by AnjutaPrizerEvrope/

| NAJVIŠI NOKATNI SERVIS 
& rješavanje problema ruku i nogu _

//..za one koji razumiju razliku & cijene svoje zdravlje //', 'ИСКРЕНО НАМ ЈЕ ДРАГО што сте Ви (као и сви у ЦГ) за заиста Квалитетно и Ефикасно рјешавање проблема руку и ногу - изабрали УПРАВО НАШ PODO-формат! Хвала Вам на ПРАВИЛНОМ ИЗБОРУ!!! Ваш проблем је ријешен - и то је НАЈВАЖНИЈЕ (!!!)

Дакле, све радове је изводила Лично(!) АњутаПризерЕвропе | ПОДОЛОГ, podo-expert са 25 година искуства у Специјализованом PODO-кабинету (који нема себи равног у ЦГ!) и по нивоу опремљености, и по технологијама, и по стерилизацији & дезинфекцији, - уз примјену свих најсавременијих Оригиналних Инструмената и Материјала. 

Сви радови су изведени према Протоколу: ПРИЈЕМ+ПРЕГЛЕД+КОНСУЛТАЦИЈА+ОДРЕЂИВАЊЕ ПРОБЛЕМА+НЕПОСРЕДНО САМО РЈЕШАВАЊЕ ВАШЕГ ПРОБЛЕМА (извршено је стручно чишћење са постављањем спец.тампонада - и све то ИСКЉУЧИВО уз примјену специјализованих оригиналних проф.материјала) + Разрађене и прописане Индивидуалне, персонализоване ПРЕПОРУКЕ управо за рјешавање Вашег проблема + КОМПЛЕКСНА КУЋНА ЊЕГА (између осталог прописано је и мултифункционално уље комплексног дјеловања, које је одговорно и за еластичност нокта и регенерацију тканива) = што је НА КРАЈУ и ГАРАНТОВАЛО 100% ПОЗИТИВАН РЕЗУЛТАТ (!) И МИ СМО ТО ПОСТИГЛИ - ЧЕСТИТАМО (!!!)

P/S. ..КВАЛИТЕТ ВАМ ЈЕ СКУП??  -Ми Клијенту увијек остављамо право Избора, укључујући и куповину прописаних препарата и материјала (али у том случају, наравно, резултат нећемо моћи да гарантујемо!!!)

С Поштовањем,

iPODO | praxis prizer europa
/by AnjutaPrizerEvrope/

| НАЈВИШИ НОКАТНИ СЕРВИС 
& рјешавање проблема руку и ногу _

//..за оне који разумију разлику & цијене своје здравље //', 'We are SINCERELY GLAD that you (like everyone in Montenegro) chose EXACTLY OUR PODO-format for a truly High-Quality and Effective solution to hand and foot problems! Thank you for the RIGHT CHOICE!!! Your problem has been solved - and that is the MAIN THING (!!!)

So, all the work was performed Personally(!) by AnjutaEuropeanPrizeWinner | PODIATRIST, podo-expert with 25 years of experience, in a Specialised PODO-office (with no equal in Montenegro!) in terms of equipment, technologies, and sterilisation & disinfection, - using all the most modern Original Instruments and Materials. 

All the work was carried out according to the Protocol: ADMISSION+EXAMINATION+CONSULTATION+IDENTIFYING THE PROBLEM+SOLVING YOUR PROBLEM ITSELF (a competent clean-up was performed with the placement of special tamponades - and all of it EXCLUSIVELY using specialised original professional materials) + Individual RECOMMENDATIONS were developed and prescribed, personalised precisely for solving your problem + COMPREHENSIVE HOME CARE (including a prescribed multifunctional oil with complex action, which among other things is responsible for nail elasticity and tissue regeneration) = which is what ULTIMATELY GUARANTEED a 100% POSITIVE RESULT (!) AND WE ACHIEVED IT - CONGRATULATIONS (!!!)

P/S. ..IS QUALITY TOO EXPENSIVE FOR YOU??  -We always leave the Client the right of Choice, including whether to buy the prescribed preparations and materials (but in that case, naturally, we will not be able to guarantee the result!!!)

Best regards,

iPODO | praxis prizer europa
/by AnjutaEuropeanPrizeWinner/

| TOP NAIL SERVICE 
& solving hand and foot problems _

//..for those who understand the difference & value their health //', 'Мы ИСКРЕННЕ РАДЫ, что Вы (как и все в Чг) для действительно Качественного и Эффективного решении проблем рук и ног - выбрали ИМЕННО НАШ PODO-формат! Благодарим Вас за ПРАВИЛЬНЫЙ ВЫБОР!!! Ваша проблема решена - и это ГЛАВНОЕ (!!!)

Итак, все работы производила Лично(!) АнютаПризёрЕвропы | ПОДОЛОГ, podo-expert с 25-летним стажем в Специализированном PODO-кабинете (не имеющем аналогов в ЧГ!) и по уровню оснащения, и технологиям, и стерилизации & дезинфекции, - с применением всех самых современных Оригинальных Инструментов и Материалов. 

Все работы были выполнены, согласно Протоколу: ПРИЁМ+ОСМОТР+КОНСУЛЬТАЦИЯ+ОПРЕДЕЛЕНИЕ ПРОБЛЕМЫ+НЕПОСРЕДСТВЕННО САМО РЕШЕНИЕ ВАШЕЙ ПРОБЛЕМЫ (была произведена грамотная зачистка с установкой спец.тампонад - и всё это ИСКЛЮЧИТЕЛЬНО с применением специализированных оригинальных проф.материалов) + Разработаны и назначены Индивидуальный, персонализированный для решения именно Вашей проблемы РЕКОМЕНДАЦИИ + КОМПЛЕКСНЫЙ ДОМАШНИЙ УХОД (в том числе назначено и многофункциональное масло с комплексным воздействием, которое в том числе отвечает за эластичность ногтя и регенерацию тканей) = что в ИТОГЕ и ГАРАНТИРОВАЛО 100% ПОЛОЖИТЕЛЬНЫЙ РЕЗУЛЬТАТ (!) И МЫ ЭТОГО ДОБИЛИСЬ - ПОЗДРАВЛЯЕМ (!!!)

P/S. ..ВАМ ДОРОГО КАЧЕСТВО??  -Мы всегда оставляем за Клиентом право Выбора, в том числе и покупки назначенных препаратов и материалов (но в этом случае, естественно, результат гарантировать не сможем!!!)

С Уважением,

iPODO | praxis prizer europa
/by AнютаПризёрЕвропы/

| ВЫСШИЙ НОГТЕВОЙ СЕРВИС 
& решение проблем рук и ног _

//..для тех, кто понимает разницу & ценит своё здоровье //', 'Wir FREUEN UNS AUFRICHTIG, dass Sie (wie alle in Montenegro) für eine wirklich Hochwertige und Wirksame Lösung von Hand- und Fußproblemen - GENAU UNSER PODO-Format gewählt haben! Wir danken Ihnen für die RICHTIGE WAHL!!! Ihr Problem ist gelöst - und das ist die HAUPTSACHE (!!!)

Also, alle Arbeiten hat Persönlich(!) AnjutaEuropaPreisträgerin | PODOLOGIN, podo-Expertin mit 25 Jahren Erfahrung, in einem Spezialisierten PODO-Kabinett ausgeführt (das in Montenegro nicht seinesgleichen hat!) - weder beim Ausstattungsniveau, noch bei den Technologien, noch bei Sterilisation & Desinfektion, - unter Einsatz aller modernsten Original-Instrumente und -Materialien. 

Alle Arbeiten wurden gemäß Protokoll ausgeführt: AUFNAHME+UNTERSUCHUNG+BERATUNG+PROBLEMBESTIMMUNG+UNMITTELBAR DIE LÖSUNG IHRES PROBLEMS SELBST (es wurde eine fachgerechte Reinigung mit dem Einsetzen spezieller Tamponaden durchgeführt - und all das AUSSCHLIESSLICH unter Verwendung spezialisierter Original-Profimaterialien) + Es wurden Individuelle, genau auf die Lösung Ihres Problems zugeschnittene EMPFEHLUNGEN erarbeitet und verordnet + KOMPLEXE HEIMPFLEGE (unter anderem wurde auch ein multifunktionales Öl mit komplexer Wirkung verordnet, das unter anderem für die Elastizität des Nagels und die Geweberegeneration zuständig ist) = was IM ERGEBNIS ein 100% POSITIVES ERGEBNIS GARANTIERT HAT (!) UND WIR HABEN DAS ERREICHT - HERZLICHEN GLÜCKWUNSCH (!!!)

P/S. ..IST IHNEN QUALITÄT ZU TEUER??  -Wir lassen dem Kunden immer das Recht der Wahl, auch beim Kauf der verordneten Präparate und Materialien (aber in diesem Fall können wir natürlich das Ergebnis nicht garantieren!!!)

Mit freundlichen Grüßen,

iPODO | praxis prizer europa
/by AnjutaEuropaPreisträgerin/

| HÖCHSTER NAGELSERVICE 
& Lösung von Hand- und Fußproblemen _

//..für die, die den Unterschied verstehen & ihre Gesundheit schätzen //', 'El ve ayak problemlerinin gerçekten Kaliteli ve Etkili çözümü için (Karadağ\'daki herkes gibi) TAM DA BİZİM PODO-formatımızı seçmiş olmanıza SAMİMİYETLE SEVİNDİK! DOĞRU SEÇİM için size teşekkür ederiz!!! Probleminiz çözüldü - ve EN ÖNEMLİSİ bu (!!!)

Dolayısıyla, tüm işlemleri Bizzat(!) AnjutaAvrupaÖdüllü | PODOLOG, 25 yıllık deneyime sahip podo-expert, hem donanım düzeyi, hem teknolojiler, hem de sterilizasyon & dezenfeksiyon bakımından (Karadağ\'da eşi olmayan!) Özel bir PODO-kabinde yaptı, - en modern Orijinal Aletlerin ve Malzemelerin tümü kullanılarak. 

Tüm işlemler Protokole uygun yapıldı: KABUL+MUAYENE+KONSÜLTASYON+PROBLEMİN BELİRLENMESİ+DOĞRUDAN PROBLEMİNİZİN ÇÖZÜMÜ (özel tamponların yerleştirilmesiyle usulüne uygun temizlik yapıldı - ve bunların hepsi SADECE özel orijinal profesyonel malzemelerle) + Tam da sizin probleminizin çözümü için Bireysel, kişiselleştirilmiş ÖNERİLER hazırlandı ve verildi + KAPSAMLI EV BAKIMI (bu arada, tırnağın esnekliğinden ve doku yenilenmesinden de sorumlu olan, kompleks etkili multifonksiyonel bir yağ da reçete edildi) = SONUÇTA %100 POZİTİF SONUCU GARANTİ EDEN de buydu (!) VE BUNU BAŞARDIK - TEBRİKLER (!!!)

P/S. ..KALİTE SİZE PAHALI MI GELİYOR??  -Müşteriye her zaman Seçme hakkı bırakırız, verilen preparatları ve malzemeleri satın alma konusunda da (ama bu durumda, doğal olarak, sonucu garanti edemeyiz!!!)

Saygılarımızla,

iPODO | praxis prizer europa
/by AnjutaAvrupaÖdüllü/

| EN ÜST DÜZEY TIRNAK SERVİSİ 
& el ve ayak problemlerinin çözümü _

//..farkı anlayanlar & sağlığına değer verenler için //',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUQtNmJyaVFnEAE'),
  'clinic', @clinic_id,
  'БЛАГОДАРИМ, что выбрали НАС! Ждём Вас !!!', 'ru',
  'ZAHVALJUJEMO što ste izabrali NAS! Čekamo Vas !!!', 'ЗАХВАЉУЈЕМО што сте изабрали НАС! Чекамо Вас !!!', 'THANK YOU for choosing US! We are waiting for you !!!', 'БЛАГОДАРИМ, что выбрали НАС! Ждём Вас !!!', 'WIR DANKEN Ihnen, dass Sie UNS gewählt haben! Wir warten auf Sie !!!', 'BİZİ seçtiğiniz için TEŞEKKÜR EDERİZ! Sizi bekliyoruz !!!',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNldjhDdWRREAE'),
  'clinic', @clinic_id,
  'Спасибо Вам!!!!!', 'ru',
  'Hvala Vam!!!!!', 'Хвала Вам!!!!!', 'Thank you!!!!!', 'Спасибо Вам!!!!!', 'Wir danken Ihnen!!!!!', 'Size teşekkür ederiz!!!!!',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUR1ajQ2WjZBRRAB'),
  'clinic', @clinic_id,
  'Спасибо Вам за искренний Отзыв!!! Всегда Рада Помочь!!!!!

С Уважением, Ваша

АнютаПризёрЕвропы
(Подолог, PODO-expert)

основатель -

iPODO | praxis prizer europa
/by АнютаПризёрЕвропы/

ВЫСШИЙ НОГТЕВОЙ СЕРВИС &
решение проблем рук и ног _

//..для тех, кто понимает разницу &
ценит своё здоровье //', 'ru',
  'Hvala Vam na iskrenoj Recenziji!!! Uvijek Mi Je Drago Da Pomognem!!!!!

S Poštovanjem, Vaša

AnjutaPrizerEvrope
(Podolog, PODO-expert)

osnivačica -

iPODO | praxis prizer europa
/by AnjutaPrizerEvrope/

NAJVIŠI NOKATNI SERVIS &
rješavanje problema ruku i nogu _

//..za one koji razumiju razliku &
cijene svoje zdravlje //', 'Хвала Вам на искреној Рецензији!!! Увијек Ми Је Драго Да Помогнем!!!!!

С Поштовањем, Ваша

АњутаПризерЕвропе
(Подолог, PODO-expert)

оснивачица -

iPODO | praxis prizer europa
/by AnjutaPrizerEvrope/

НАЈВИШИ НОКАТНИ СЕРВИС &
рјешавање проблема руку и ногу _

//..за оне који разумију разлику &
цијене своје здравље //', 'Thank you for your sincere Review!!! Always Happy to Help!!!!!

Best regards, Yours

AnjutaEuropeanPrizeWinner
(Podiatrist, PODO-expert)

founder -

iPODO | praxis prizer europa
/by AnjutaEuropeanPrizeWinner/

TOP NAIL SERVICE &
solving hand and foot problems _

//..for those who understand the difference &
value their health //', 'Спасибо Вам за искренний Отзыв!!! Всегда Рада Помочь!!!!!

С Уважением, Ваша

АнютаПризёрЕвропы
(Подолог, PODO-expert)

основатель -

iPODO | praxis prizer europa
/by АнютаПризёрЕвропы/

ВЫСШИЙ НОГТЕВОЙ СЕРВИС &
решение проблем рук и ног _

//..для тех, кто понимает разницу &
ценит своё здоровье //', 'Vielen Dank für Ihre aufrichtige Bewertung!!! Immer Gern Geholfen!!!!!

Mit freundlichen Grüßen, Ihre

AnjutaEuropaPreisträgerin
(Podologin, PODO-Expertin)

Gründerin -

iPODO | praxis prizer europa
/by AnjutaEuropaPreisträgerin/

HÖCHSTER NAGELSERVICE &
Lösung von Hand- und Fußproblemen _

//..für die, die den Unterschied verstehen &
ihre Gesundheit schätzen //', 'Samimi Yorumunuz için teşekkür ederim!!! Yardım Etmek Her Zaman Benim İçin Bir Mutluluk!!!!!

Saygılarımla, Sizin

AnjutaAvrupaÖdüllü
(Podolog, PODO-expert)

kurucu -

iPODO | praxis prizer europa
/by AnjutaAvrupaÖdüllü/

EN ÜST DÜZEY TIRNAK SERVİSİ &
el ve ayak problemlerinin çözümü _

//..farkı anlayanlar &
sağlığına değer verenler için //',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUR1OTdXT25BRRAB'),
  'clinic', @clinic_id,
  'Очень Приятно! Благодарим Вас за столь ВЫСОКУЮ ОЦЕНКУ нашего PODO-формата!!!

Всегда, как и все наши 25 лет опыта в сфере Индустрии Красоты - максимально стараемся Улучшать и Совершенствовать наши предприятия для Вас!!!

P/S/ ..и синергия протекающих у нас бизнес-процессов - отнюдь не случайна (работает Стандартизация) - так что смело посещайте нас в любое время, в любую смену - и Мастера, и Администраторы - всегда Будут на ВЫСОТЕ!

Спасибо, что Вы выбрали - ИМЕННО НАС!!!

С Уважением, Ваша

АнютаПризёрЕвропы
(Подолог, PODO-exprt)

основатель -

iPODO | praxis prizer europa
/by АнютаПризёрЕвропы/

ВЫСШИЙ НОГТЕВОЙ СЕРВИС &
решение проблем рук и ног _

//..для тех, кто понимает разницу &
ценит своё здоровье //', 'ru',
  'Veoma nam je Prijatno! Hvala Vam na tako VISOKOJ OCJENI našeg PODO-formata!!!

Uvijek, kao i svih naših 25 godina iskustva u sferi Industrije Ljepote - maksimalno se trudimo da Poboljšavamo i Usavršavamo naše objekte za Vas!!!

P/S/ ..i sinergija poslovnih procesa koji se kod nas odvijaju - nikako nije slučajna (radi Standardizacija) - tako da nas slobodno posjećujte u bilo koje vrijeme, u bilo kojoj smjeni - i Majstori, i Administratori - uvijek Će Biti na VISINI ZADATKA!

Hvala što ste izabrali - UPRAVO NAS!!!

S Poštovanjem, Vaša

AnjutaPrizerEvrope
(Podolog, PODO-exprt)

osnivačica -

iPODO | praxis prizer europa
/by AnjutaPrizerEvrope/

NAJVIŠI NOKATNI SERVIS &
rješavanje problema ruku i nogu _

//..za one koji razumiju razliku &
cijene svoje zdravlje //', 'Веома нам је Пријатно! Хвала Вам на тако ВИСОКОЈ ОЦЈЕНИ нашег PODO-формата!!!

Увијек, као и свих наших 25 година искуства у сфери Индустрије Љепоте - максимално се трудимо да Побољшавамо и Усавршавамо наше објекте за Вас!!!

P/S/ ..и синергија пословних процеса који се код нас одвијају - никако није случајна (ради Стандардизација) - тако да нас слободно посјећујте у било које вријеме, у било којој смјени - и Мајстори, и Администратори - увијек Ће Бити на ВИСИНИ ЗАДАТКА!

Хвала што сте изабрали - УПРАВО НАС!!!

С Поштовањем, Ваша

АњутаПризерЕвропе
(Подолог, PODO-exprt)

оснивачица -

iPODO | praxis prizer europa
/by AnjutaPrizerEvrope/

НАЈВИШИ НОКАТНИ СЕРВИС &
рјешавање проблема руку и ногу _

//..за оне који разумију разлику &
цијене своје здравље //', 'Very Nice to hear! Thank you for such a HIGH RATING of our PODO-format!!!

As always, just as in all our 25 years of experience in the Beauty Industry - we do our utmost to Improve and Perfect our establishments for you!!!

P/S/ ..and the synergy of the business processes running here is by no means accidental (Standardisation is at work) - so feel free to visit us at any time, on any shift - both the Technicians and the Receptionists will always Be at their BEST!

Thank you for choosing - EXACTLY US!!!

Best regards, Yours

AnjutaEuropeanPrizeWinner
(Podiatrist, PODO-exprt)

founder -

iPODO | praxis prizer europa
/by AnjutaEuropeanPrizeWinner/

TOP NAIL SERVICE &
solving hand and foot problems _

//..for those who understand the difference &
value their health //', 'Очень Приятно! Благодарим Вас за столь ВЫСОКУЮ ОЦЕНКУ нашего PODO-формата!!!

Всегда, как и все наши 25 лет опыта в сфере Индустрии Красоты - максимально стараемся Улучшать и Совершенствовать наши предприятия для Вас!!!

P/S/ ..и синергия протекающих у нас бизнес-процессов - отнюдь не случайна (работает Стандартизация) - так что смело посещайте нас в любое время, в любую смену - и Мастера, и Администраторы - всегда Будут на ВЫСОТЕ!

Спасибо, что Вы выбрали - ИМЕННО НАС!!!

С Уважением, Ваша

АнютаПризёрЕвропы
(Подолог, PODO-exprt)

основатель -

iPODO | praxis prizer europa
/by АнютаПризёрЕвропы/

ВЫСШИЙ НОГТЕВОЙ СЕРВИС &
решение проблем рук и ног _

//..для тех, кто понимает разницу &
ценит своё здоровье //', 'Sehr Erfreulich! Wir danken Ihnen für eine so HOHE BEWERTUNG unseres PODO-Formats!!!

Wie immer, so wie in all unseren 25 Jahren Erfahrung in der Beauty-Industrie - geben wir unser Äußerstes, um unsere Betriebe für Sie zu Verbessern und zu Perfektionieren!!!

P/S/ ..und die Synergie der bei uns ablaufenden Geschäftsprozesse ist keineswegs zufällig (die Standardisierung wirkt) - besuchen Sie uns also ruhig zu jeder Zeit, in jeder Schicht - sowohl die Fachkräfte als auch die Empfangskräfte werden immer auf HÖCHSTEM NIVEAU sein!

Danke, dass Sie - GENAU UNS gewählt haben!!!

Mit freundlichen Grüßen, Ihre

AnjutaEuropaPreisträgerin
(Podologin, PODO-exprt)

Gründerin -

iPODO | praxis prizer europa
/by AnjutaEuropaPreisträgerin/

HÖCHSTER NAGELSERVICE &
Lösung von Hand- und Fußproblemen _

//..für die, die den Unterschied verstehen &
ihre Gesundheit schätzen //', 'Çok Memnun Olduk! PODO-formatımıza verdiğiniz bu YÜKSEK NOT için teşekkür ederiz!!!

Her zaman, Güzellik Sektöründeki 25 yıllık deneyimimiz boyunca olduğu gibi - işletmelerimizi sizin için Geliştirmek ve Mükemmelleştirmek adına elimizden gelenin en fazlasını yapıyoruz!!!

P/S/ ..ve bizde yürüyen iş süreçlerinin sinerjisi hiç de tesadüf değil (Standardizasyon işliyor) - dolayısıyla bize gönül rahatlığıyla her zaman, her vardiyada gelin - hem Uzmanlar hem Yöneticiler her zaman EN İYİ SEVİYEDE Olacak!

TAM DA BİZİ seçtiğiniz için teşekkürler!!!

Saygılarımla, Sizin

AnjutaAvrupaÖdüllü
(Podolog, PODO-exprt)

kurucu -

iPODO | praxis prizer europa
/by AnjutaAvrupaÖdüllü/

EN ÜST DÜZEY TIRNAK SERVİSİ &
el ve ayak problemlerinin çözümü _

//..farkı anlayanlar &
sağlığına değer verenler için //',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUR1aTYtRXFBRRAB'),
  'clinic', @clinic_id,
  'Спасибо Вам!!!

С Безграничной Благодарностью ко Всем Нашим Клиентам, действительно понимающим разницу и ценящим своё здоровье!!!

С Уважением,
Ваш iPODO | praxis prizer europa

ВЫСШИЙ НОГТЕВОЙ СЕРВИС & решение проблем рук и ног _', 'ru',
  'Hvala Vam!!!

Sa Bezgraničnom Zahvalnošću prema Svim Našim Klijentima, koji zaista razumiju razliku i cijene svoje zdravlje!!!

S Poštovanjem,
Vaš iPODO | praxis prizer europa

NAJVIŠI NOKATNI SERVIS & rješavanje problema ruku i nogu _', 'Хвала Вам!!!

Са Безграничном Захвалношћу према Свим Нашим Клијентима, који заиста разумију разлику и цијене своје здравље!!!

С Поштовањем,
Ваш iPODO | praxis prizer europa

НАЈВИШИ НОКАТНИ СЕРВИС & рјешавање проблема руку и ногу _', 'Thank you!!!

With Boundless Gratitude to All Our Clients who truly understand the difference and value their health!!!

Best regards,
Your iPODO | praxis prizer europa

TOP NAIL SERVICE & solving hand and foot problems _', 'Спасибо Вам!!!

С Безграничной Благодарностью ко Всем Нашим Клиентам, действительно понимающим разницу и ценящим своё здоровье!!!

С Уважением,
Ваш iPODO | praxis prizer europa

ВЫСШИЙ НОГТЕВОЙ СЕРВИС & решение проблем рук и ног _', 'Wir danken Ihnen!!!

Mit Grenzenloser Dankbarkeit an Alle Unsere Kunden, die den Unterschied wirklich verstehen und ihre Gesundheit schätzen!!!

Mit freundlichen Grüßen,
Ihr iPODO | praxis prizer europa

HÖCHSTER NAGELSERVICE & Lösung von Hand- und Fußproblemen _', 'Size teşekkür ederiz!!!

Farkı gerçekten anlayan ve sağlığına değer veren Tüm Müşterilerimize Sınırsız Şükranla!!!

Saygılarımızla,
Sizin iPODO | praxis prizer europa

EN ÜST DÜZEY TIRNAK SERVİSİ & el ve ayak problemlerinin çözümü _',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUR1eGJ6RkZnEAE'),
  'clinic', @clinic_id,
  'СПАСИБО Вам Огромное! Мы ИСКРЕННЕ Рады, что Вы нас ТАК ВЫСОКО Оценили!!! Очень приятно получать ТАКИЕ НАСТОЯЩИЕ ПРОФЕССИОНАЛЬНЫЕ отзывы от Наших Клиентов (тех, кто действительно понимает разницу и ценит своё здоровье!!!)

..А со своей стороны, несмотря на более чем 25-летний опыт работы в Ногтевой индустрии - мы будем продолжать усовершенствоваться: и в ЧЕМПИОНСКОМ КАЧЕСТВЕ /ведь качество всех работ под Личным (!) Патронажем АнютыПризёраЕвропы, подолога, PODO-expertа/ + МЕДИЦИНСКОЙ БЕЗОПАСНОСТИ /т.к. Стерилизация & Дезинфекция в нашем PODO-формате - ИСКЛЮЧИТЕЛЬНО! ОБРАЗЦОВАЯ Комплексная и Системная, состоящая из более чем 15-ти (!) Этапов../ + ПОКАЗАТЕЛЬНОМ КЛИЕНТСКОМ СЕРВИСЕ /у нас действительно более 100! Отличий & Преимуществ ///

НАШ PODO-формат - это ЦЕЛЫЙ КОМПЛЕКС (как в Стоматологии) -

КАЧЕСТВО+БЕЗОПАСНОСТЬ+СЕРВИС=
ВЫСШИЙ НОГТЕВОЙ СЕРВИС!

| Советуем - Попробуйте ЛУЧШЕЕ!

Доступность Услуг: от19!$ | ..или даже БЕСПЛАТНО (!) -  по проходящей Акции "Услуга за 0!" ВОСПОЛЬЗУЙТЕСЬ!

С Уважением, Ваш

iPODO | praxis prizer europa
/by АнютаПризёрЕвропы/

ВЫСШИЙ НОГТЕВОЙ СЕРВИС &
решение проблем рук и ног _

//..для тех, кто понимает разницу & ценит своё здоровье//', 'ru',
  'OGROMNO Vam HVALA! ISKRENO nam je Drago što ste nas TAKO VISOKO Ocijenili!!! Veoma je prijatno dobijati TAKVE PRAVE PROFESIONALNE recenzije od Naših Klijenata (onih koji zaista razumiju razliku i cijene svoje zdravlje!!!)

..A sa naše strane, i pored više od 25 godina iskustva u Nokatnoj industriji - nastavićemo da se usavršavamo: i u ŠAMPIONSKOM KVALITETU /jer je kvalitet svih radova pod Ličnim (!) Patronatom AnjutePrizeraEvrope, podologa, PODO-experta/ + MEDICINSKOJ BEZBJEDNOSTI /jer su Sterilizacija & Dezinfekcija u našem PODO-formatu - ISKLJUČIVO! UZORNE, Kompleksne i Sistemske, sastavljene od više od 15 (!) Faza../ + UZORNOM KLIJENTSKOM SERVISU /kod nas zaista postoji više od 100! Razlika & Prednosti ///

NAŠ PODO-format - to je CIJELI KOMPLEKS (kao u Stomatologiji) -

KVALITET+BEZBJEDNOST+SERVIS=
NAJVIŠI NOKATNI SERVIS!

| Savjetujemo - Probajte NAJBOLJE!

Pristupačnost Usluga: od19!$ | ..ili čak BESPLATNO (!) -  po Akciji koja je u toku "Usluga za 0!" ISKORISTITE!

S Poštovanjem, Vaš

iPODO | praxis prizer europa
/by AnjutaPrizerEvrope/

NAJVIŠI NOKATNI SERVIS &
rješavanje problema ruku i nogu _

//..za one koji razumiju razliku & cijene svoje zdravlje//', 'ОГРОМНО Вам ХВАЛА! ИСКРЕНО нам је Драго што сте нас ТАКО ВИСОКО Оцијенили!!! Веома је пријатно добијати ТАКВЕ ПРАВЕ ПРОФЕСИОНАЛНЕ рецензије од Наших Клијената (оних који заиста разумију разлику и цијене своје здравље!!!)

..А са наше стране, и поред више од 25 година искуства у Нокатној индустрији - настављамо да се усавршавамо: и у ШАМПИОНСКОМ КВАЛИТЕТУ /јер је квалитет свих радова под Личним (!) Патронатом АњутеПризераЕвропе, подолога, PODO-experta/ + МЕДИЦИНСКОЈ БЕЗБЈЕДНОСТИ /јер су Стерилизација & Дезинфекција у нашем PODO-формату - ИСКЉУЧИВО! УЗОРНЕ, Комплексне и Системске, састављене од више од 15 (!) Фаза../ + УЗОРНОМ КЛИЈЕНТСКОМ СЕРВИСУ /код нас заиста постоји више од 100! Разлика & Предности ///

НАШ PODO-формат - то је ЦИЈЕЛИ КОМПЛЕКС (као у Стоматологији) -

КВАЛИТЕТ+БЕЗБЈЕДНОСТ+СЕРВИС=
НАЈВИШИ НОКАТНИ СЕРВИС!

| Савјетујемо - Пробајте НАЈБОЉЕ!

Приступачност Услуга: од19!$ | ..или чак БЕСПЛАТНО (!) -  по Акцији која је у току "Услуга за 0!" ИСКОРИСТИТЕ!

С Поштовањем, Ваш

iPODO | praxis prizer europa
/by AnjutaPrizerEvrope/

НАЈВИШИ НОКАТНИ СЕРВИС &
рјешавање проблема руку и ногу _

//..за оне који разумију разлику & цијене своје здравље//', 'THANK YOU so very much! We are SINCERELY Glad that you rated us SO HIGHLY!!! It is a great pleasure to receive SUCH GENUINELY PROFESSIONAL reviews from Our Clients (those who truly understand the difference and value their health!!!)

..And for our part, despite more than 25 years of experience in the Nail industry - we will keep on improving: in CHAMPION-LEVEL QUALITY /after all, the quality of all the work is under the Personal (!) Patronage of AnjutaEuropeanPrizeWinner, podiatrist, PODO-expert/ + MEDICAL SAFETY /because Sterilisation & Disinfection in our PODO-format is EXCLUSIVELY! EXEMPLARY, Comprehensive and Systemic, consisting of more than 15 (!) Stages../ + EXEMPLARY CLIENT SERVICE /we really do have more than 100! Differences & Advantages ///

OUR PODO-format is a WHOLE COMPLEX (like in Dentistry) -

QUALITY+SAFETY+SERVICE=
TOP NAIL SERVICE!

| Our advice - Try THE BEST!

Affordability of Services: from19!$ | ..or even FREE (!) -  under the ongoing promo "A Service for 0!" TAKE ADVANTAGE OF IT!

Best regards, Your

iPODO | praxis prizer europa
/by AnjutaEuropeanPrizeWinner/

TOP NAIL SERVICE &
solving hand and foot problems _

//..for those who understand the difference & value their health//', 'СПАСИБО Вам Огромное! Мы ИСКРЕННЕ Рады, что Вы нас ТАК ВЫСОКО Оценили!!! Очень приятно получать ТАКИЕ НАСТОЯЩИЕ ПРОФЕССИОНАЛЬНЫЕ отзывы от Наших Клиентов (тех, кто действительно понимает разницу и ценит своё здоровье!!!)

..А со своей стороны, несмотря на более чем 25-летний опыт работы в Ногтевой индустрии - мы будем продолжать усовершенствоваться: и в ЧЕМПИОНСКОМ КАЧЕСТВЕ /ведь качество всех работ под Личным (!) Патронажем АнютыПризёраЕвропы, подолога, PODO-expertа/ + МЕДИЦИНСКОЙ БЕЗОПАСНОСТИ /т.к. Стерилизация & Дезинфекция в нашем PODO-формате - ИСКЛЮЧИТЕЛЬНО! ОБРАЗЦОВАЯ Комплексная и Системная, состоящая из более чем 15-ти (!) Этапов../ + ПОКАЗАТЕЛЬНОМ КЛИЕНТСКОМ СЕРВИСЕ /у нас действительно более 100! Отличий & Преимуществ ///

НАШ PODO-формат - это ЦЕЛЫЙ КОМПЛЕКС (как в Стоматологии) -

КАЧЕСТВО+БЕЗОПАСНОСТЬ+СЕРВИС=
ВЫСШИЙ НОГТЕВОЙ СЕРВИС!

| Советуем - Попробуйте ЛУЧШЕЕ!

Доступность Услуг: от19!$ | ..или даже БЕСПЛАТНО (!) -  по проходящей Акции "Услуга за 0!" ВОСПОЛЬЗУЙТЕСЬ!

С Уважением, Ваш

iPODO | praxis prizer europa
/by АнютаПризёрЕвропы/

ВЫСШИЙ НОГТЕВОЙ СЕРВИС &
решение проблем рук и ног _

//..для тех, кто понимает разницу & ценит своё здоровье//', 'GANZ herzlichen DANK! Wir freuen uns AUFRICHTIG, dass Sie uns SO HOCH Bewertet haben!!! Es ist sehr erfreulich, SOLCHE ECHTEN PROFESSIONELLEN Bewertungen von Unseren Kunden zu erhalten (von denen, die den Unterschied wirklich verstehen und ihre Gesundheit schätzen!!!)

..Und unsererseits werden wir uns, trotz mehr als 25 Jahren Erfahrung in der Nagelbranche - weiter perfektionieren: sowohl in der MEISTERLICHEN QUALITÄT /denn die Qualität aller Arbeiten steht unter der Persönlichen (!) Schirmherrschaft von AnjutaEuropaPreisträgerin, Podologin, PODO-Expertin/ + MEDIZINISCHER SICHERHEIT /denn Sterilisation & Desinfektion in unserem PODO-Format sind AUSSCHLIESSLICH! VORBILDLICH, Komplex und Systemisch, bestehend aus mehr als 15 (!) Stufen../ + VORBILDLICHEM KUNDENSERVICE /wir haben wirklich mehr als 100! Unterschiede & Vorteile ///

UNSER PODO-Format ist ein GANZER KOMPLEX (wie in der Zahnmedizin) -

QUALITÄT+SICHERHEIT+SERVICE=
HÖCHSTER NAGELSERVICE!

| Unser Rat - Probieren Sie DAS BESTE!

Erschwinglichkeit der Leistungen: ab19!$ | ..oder sogar KOSTENLOS (!) -  im Rahmen der laufenden Aktion "Eine Leistung für 0!" NUTZEN SIE DAS!

Mit freundlichen Grüßen, Ihr

iPODO | praxis prizer europa
/by AnjutaEuropaPreisträgerin/

HÖCHSTER NAGELSERVICE &
Lösung von Hand- und Fußproblemen _

//..für die, die den Unterschied verstehen & ihre Gesundheit schätzen//', 'Size ÇOK ÇOK TEŞEKKÜR EDERİZ! Bizi BU KADAR YÜKSEK Değerlendirmenize SAMİMİYETLE Sevindik!!! Müşterilerimizden (farkı gerçekten anlayan ve sağlığına değer verenlerden!!!) BÖYLE GERÇEK PROFESYONEL yorumlar almak çok keyifli

..Bize düşen ise, Tırnak sektöründe 25 yıldan fazla deneyimimize rağmen - kendimizi geliştirmeye devam etmek: hem ŞAMPİYON KALİTESİNDE /çünkü tüm işlerin kalitesi podolog, PODO-expert AnjutaAvrupaÖdüllü\'nün Bizzat (!) Himayesi altında/ + MEDİKAL GÜVENLİKTE /çünkü PODO-formatımızda Sterilizasyon & Dezenfeksiyon SADECE! ÖRNEK niteliğinde, Kapsamlı ve Sistemli, 15\'ten (!) fazla Aşamadan oluşuyor../ + ÖRNEK MÜŞTERİ SERVİSİNDE /bizde gerçekten 100\'den! fazla Fark & Avantaj var ///

BİZİM PODO-formatımız BÜTÜN BİR KOMPLEKS (Diş Hekimliğinde olduğu gibi) -

KALİTE+GÜVENLİK+SERVİS=
EN ÜST DÜZEY TIRNAK SERVİSİ!

| Tavsiyemiz - EN İYİSİNİ Deneyin!

Hizmetlerin Erişilebilirliği: 19!$\'dan | ..ya da hatta ÜCRETSİZ (!) -  devam eden "0\'a Hizmet!" Kampanyası kapsamında FAYDALANIN!

Saygılarımızla, Sizin

iPODO | praxis prizer europa
/by AnjutaAvrupaÖdüllü/

EN ÜST DÜZEY TIRNAK SERVİSİ &
el ve ayak problemlerinin çözümü _

//..farkı anlayanlar & sağlığına değer verenler için//',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUR1MHBEV0dREAE'),
  'clinic', @clinic_id,
  'СПАСИБО! Будем, благодаря Вам - ЕЩЁ ВЫШЕ! ///

| СЕКРЕТ НАШЕГО УСПЕХА?.. ВСЁ ПРОСТО!

ЧЕМПИОНСКОЕ КАЧЕСТВО + МЕДИЦИНСКАЯ БЕЗОПАСНОСТЬ = ВЫСШИЙ НОГТЕВОЙ СЕРВИС !!!

!Стоимость Услуг от19!$ ..или даже БЕСПЛАТНО(!) - согласно проходящей Акции "УСЛУГА за 0!"
ВОСПОЛЬЗУЙТЕСЬ!!!
__

С Уважением, Ваш

iPODO | praxis prizer europa
/by АнютаПризёрЕвропы/

ВЫСШИЙ НОГТЕВОЙ СЕРВИС &
решение проблем рук и ног _

// ..для тех, кто понимает разницу & ценит своё здоровье//', 'ru',
  'HVALA! Bićemo, zahvaljujući Vama - JOŠ VIŠI! ///

| TAJNA NAŠEG USPJEHA?.. SVE JE PROSTO!

ŠAMPIONSKI KVALITET + MEDICINSKA BEZBJEDNOST = NAJVIŠI NOKATNI SERVIS !!!

!Cijena Usluga od19!$ ..ili čak BESPLATNO(!) - po Akciji koja je u toku "USLUGA za 0!"
ISKORISTITE!!!
__

S Poštovanjem, Vaš

iPODO | praxis prizer europa
/by AnjutaPrizerEvrope/

NAJVIŠI NOKATNI SERVIS &
rješavanje problema ruku i nogu _

// ..za one koji razumiju razliku & cijene svoje zdravlje//', 'ХВАЛА! Бићемо, захваљујући Вама - ЈОШ ВИШИ! ///

| ТАЈНА НАШЕГ УСПЈЕХА?.. СВЕ ЈЕ ПРОСТО!

ШАМПИОНСКИ КВАЛИТЕТ + МЕДИЦИНСКА БЕЗБЈЕДНОСТ = НАЈВИШИ НОКАТНИ СЕРВИС !!!

!Цијена Услуга од19!$ ..или чак БЕСПЛАТНО(!) - по Акцији која је у току "УСЛУГА за 0!"
ИСКОРИСТИТЕ!!!
__

С Поштовањем, Ваш

iPODO | praxis prizer europa
/by AnjutaPrizerEvrope/

НАЈВИШИ НОКАТНИ СЕРВИС &
рјешавање проблема руку и ногу _

// ..за оне који разумију разлику & цијене своје здравље//', 'THANK YOU! Thanks to you - we\'ll be EVEN HIGHER! ///

| THE SECRET OF OUR SUCCESS?.. IT\'S ALL SIMPLE!

CHAMPION-LEVEL QUALITY + MEDICAL SAFETY = TOP NAIL SERVICE !!!

!Price of Services from19!$ ..or even FREE(!) - under the ongoing promo "A SERVICE for 0!"
TAKE ADVANTAGE OF IT!!!
__

Best regards, Your

iPODO | praxis prizer europa
/by AnjutaEuropeanPrizeWinner/

TOP NAIL SERVICE &
solving hand and foot problems _

// ..for those who understand the difference & value their health//', 'СПАСИБО! Будем, благодаря Вам - ЕЩЁ ВЫШЕ! ///

| СЕКРЕТ НАШЕГО УСПЕХА?.. ВСЁ ПРОСТО!

ЧЕМПИОНСКОЕ КАЧЕСТВО + МЕДИЦИНСКАЯ БЕЗОПАСНОСТЬ = ВЫСШИЙ НОГТЕВОЙ СЕРВИС !!!

!Стоимость Услуг от19!$ ..или даже БЕСПЛАТНО(!) - согласно проходящей Акции "УСЛУГА за 0!"
ВОСПОЛЬЗУЙТЕСЬ!!!
__

С Уважением, Ваш

iPODO | praxis prizer europa
/by АнютаПризёрЕвропы/

ВЫСШИЙ НОГТЕВОЙ СЕРВИС &
решение проблем рук и ног _

// ..для тех, кто понимает разницу & ценит своё здоровье//', 'DANKE! Dank Ihnen werden wir - NOCH BESSER! ///

| DAS GEHEIMNIS UNSERES ERFOLGS?.. GANZ EINFACH!

MEISTERLICHE QUALITÄT + MEDIZINISCHE SICHERHEIT = HÖCHSTER NAGELSERVICE !!!

!Preis der Leistungen ab19!$ ..oder sogar KOSTENLOS(!) - im Rahmen der laufenden Aktion "EINE LEISTUNG für 0!"
NUTZEN SIE DAS!!!
__

Mit freundlichen Grüßen, Ihr

iPODO | praxis prizer europa
/by AnjutaEuropaPreisträgerin/

HÖCHSTER NAGELSERVICE &
Lösung von Hand- und Fußproblemen _

// ..für die, die den Unterschied verstehen & ihre Gesundheit schätzen//', 'TEŞEKKÜRLER! Sizin sayenizde - DAHA DA YÜKSEKTE olacağız! ///

| BAŞARIMIZIN SIRRI?.. HER ŞEY ÇOK BASİT!

ŞAMPİYON KALİTESİ + MEDİKAL GÜVENLİK = EN ÜST DÜZEY TIRNAK SERVİSİ !!!

!Hizmet Ücreti 19!$\'dan ..ya da hatta ÜCRETSİZ(!) - devam eden "0\'a HİZMET!" Kampanyası kapsamında
FAYDALANIN!!!
__

Saygılarımızla, Sizin

iPODO | praxis prizer europa
/by AnjutaAvrupaÖdüllü/

EN ÜST DÜZEY TIRNAK SERVİSİ &
el ve ayak problemlerinin çözümü _

// ..farkı anlayanlar & sağlığına değer verenler için//',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChZDSUhNMG9nS0VJQ0FnSUR1bkxLdVp3EAE'),
  'clinic', @clinic_id,
  'Благодарим Вас за Отзыв!!!

Будем рады видеть Вас снова и снова!!!

Тем более, что у нас несколько разновидностей Педикюра:

| ..наш PODO-формат по уровню оснащённости Специализированным Профессиональным (GERMANY) Оборудованием & Оснащением не имеет аналогов в ЧГ -

| СОВЕТУЕМ - ПОПРОБУЙТЕ ЛУЧШЕЕ !!!

Нужен педикюр?..

в нашем iPODO | praxis prizer europa
действительно ПРОФЕССИОНАЛЬНЫЙ
(выбирайте любой из 3-х видов):

Вы можете записаться:
на «аппаратный педикюр (GERMANY)»:
к нашему ТОП-мастеру _

или на «препаратный педикюр» KART (Израиль)

или (при наличии проблем ног) -

непосредственно именно лично (!) у самой АнютаПризёрЕвропы (подолога) на пара-медицинский Подологический PODO-Педикюр /в Специализированном кабинете, не имеющем аналогов в ЧГ - (по обязательной предварительной записи)

——

С Уважением,
iPODO | praxis prizer europa
/by АнютаПризёрЕвропы/

ВЫСШИЙ НОГТЕВОЙ СЕРВИС &
решение проблем рук и ног _

// ..для тех, кто понимает разницу & ценит своё здоровье //', 'ru',
  'Hvala Vam na Recenziji!!!

Biće nam drago da Vas vidimo ponovo i ponovo!!!

Tim više što kod nas ima nekoliko vrsta Pedikira:

| ..naš PODO-format po nivou opremljenosti Specijalizovanom Profesionalnom (GERMANY) Aparaturom & Opremom nema sebi ravnog u CG -

| SAVJETUJEMO - PROBAJTE NAJBOLJE !!!

Treba Vam pedikir?..

u našem iPODO | praxis prizer europa
zaista PROFESIONALAN
(izaberite bilo koji od 3 vrste):

Možete se zakazati:
za «aparatni pedikir (GERMANY)»:
kod našeg TOP-majstora _

ili za «preparatni pedikir» KART (Izrael)

ili (ako imate problema sa nogama) -

neposredno upravo lično (!) kod same AnjutePrizeraEvrope (podologa) na para-medicinski Podološki PODO-Pedikir /u Specijalizovanom kabinetu koji nema sebi ravnog u CG - (uz obavezno prethodno zakazivanje)

——

S Poštovanjem,
iPODO | praxis prizer europa
/by AnjutaPrizerEvrope/

NAJVIŠI NOKATNI SERVIS &
rješavanje problema ruku i nogu _

// ..za one koji razumiju razliku & cijene svoje zdravlje //', 'Хвала Вам на Рецензији!!!

Биће нам драго да Вас видимо поново и поново!!!

Тим више што код нас има неколико врста Педикира:

| ..наш PODO-формат по нивоу опремљености Специјализованом Професионалном (GERMANY) Апаратуром & Опремом нема себи равног у ЦГ -

| САВЈЕТУЈЕМО - ПРОБАЈТЕ НАЈБОЉЕ !!!

Треба Вам педикир?..

у нашем iPODO | praxis prizer europa
заиста ПРОФЕСИОНАЛАН
(изаберите било који од 3 врсте):

Можете се заказати:
за «апаратни педикир (GERMANY)»:
код нашег ТОП-мајстора _

или за «препаратни педикир» KART (Израел)

или (ако имате проблема са ногама) -

непосредно управо лично (!) код саме АњутеПризераЕвропе (подолога) на пара-медицински Подолошки PODO-Педикир /у Специјализованом кабинету који нема себи равног у ЦГ - (уз обавезно претходно заказивање)

——

С Поштовањем,
iPODO | praxis prizer europa
/by AnjutaPrizerEvrope/

НАЈВИШИ НОКАТНИ СЕРВИС &
рјешавање проблема руку и ногу _

// ..за оне који разумију разлику & цијене своје здравље //', 'Thank you for your Review!!!

We\'ll be happy to see you again and again!!!

All the more so since we have several kinds of Pedicure:

| ..in terms of being equipped with Specialised Professional (GERMANY) Machinery & Equipment our PODO-format has no equal in Montenegro -

| OUR ADVICE - TRY THE BEST !!!

Need a pedicure?..

at our iPODO | praxis prizer europa
a truly PROFESSIONAL one
(choose any of the 3 kinds):

You can book:
a «machine pedicure (GERMANY)»:
with our TOP technician _

or a «product-based pedicure» KART (Israel)

or (if you have foot problems) -

directly and personally (!) with AnjutaEuropeanPrizeWinner herself (a podiatrist) for a para-medical Podological PODO-Pedicure /in a Specialised office with no equal in Montenegro - (by mandatory prior appointment)

——

Best regards,
iPODO | praxis prizer europa
/by AnjutaEuropeanPrizeWinner/

TOP NAIL SERVICE &
solving hand and foot problems _

// ..for those who understand the difference & value their health //', 'Благодарим Вас за Отзыв!!!

Будем рады видеть Вас снова и снова!!!

Тем более, что у нас несколько разновидностей Педикюра:

| ..наш PODO-формат по уровню оснащённости Специализированным Профессиональным (GERMANY) Оборудованием & Оснащением не имеет аналогов в ЧГ -

| СОВЕТУЕМ - ПОПРОБУЙТЕ ЛУЧШЕЕ !!!

Нужен педикюр?..

в нашем iPODO | praxis prizer europa
действительно ПРОФЕССИОНАЛЬНЫЙ
(выбирайте любой из 3-х видов):

Вы можете записаться:
на «аппаратный педикюр (GERMANY)»:
к нашему ТОП-мастеру _

или на «препаратный педикюр» KART (Израиль)

или (при наличии проблем ног) -

непосредственно именно лично (!) у самой АнютаПризёрЕвропы (подолога) на пара-медицинский Подологический PODO-Педикюр /в Специализированном кабинете, не имеющем аналогов в ЧГ - (по обязательной предварительной записи)

——

С Уважением,
iPODO | praxis prizer europa
/by АнютаПризёрЕвропы/

ВЫСШИЙ НОГТЕВОЙ СЕРВИС &
решение проблем рук и ног _

// ..для тех, кто понимает разницу & ценит своё здоровье //', 'Wir danken Ihnen für die Bewertung!!!

Wir freuen uns, Sie immer und immer wieder zu sehen!!!

Zumal es bei uns mehrere Arten der Pediküre gibt:

| ..unser PODO-Format hat bei der Ausstattung mit Spezialisierten Professionellen (GERMANY) Geräten & Equipment in Montenegro nicht seinesgleichen -

| UNSER RAT - PROBIEREN SIE DAS BESTE !!!

Sie brauchen eine Pediküre?..

in unserem iPODO | praxis prizer europa
eine wirklich PROFESSIONELLE
(wählen Sie eine der 3 Arten):

Sie können buchen:
eine «Geräte-Pediküre (GERMANY)»:
bei unserer TOP-Fachkraft _

oder eine «Präparate-Pediküre» KART (Israel)

oder (bei Fußproblemen) -

direkt und ganz persönlich (!) bei AnjutaEuropaPreisträgerin selbst (Podologin) eine para-medizinische Podologische PODO-Pediküre /in einem Spezialisierten Kabinett, das in Montenegro nicht seinesgleichen hat - (nur mit verbindlicher Voranmeldung)

——

Mit freundlichen Grüßen,
iPODO | praxis prizer europa
/by AnjutaEuropaPreisträgerin/

HÖCHSTER NAGELSERVICE &
Lösung von Hand- und Fußproblemen _

// ..für die, die den Unterschied verstehen & ihre Gesundheit schätzen //', 'Yorumunuz için teşekkür ederiz!!!

Sizi tekrar ve tekrar görmekten mutlu olacağız!!!

Hele ki bizde birkaç çeşit Pedikür var:

| ..PODO-formatımız, Özel Profesyonel (GERMANY) Cihaz & Donanım düzeyi bakımından Karadağ\'da eşsizdir -

| TAVSİYEMİZ - EN İYİSİNİ DENEYİN !!!

Pedikür mü gerekiyor?..

bizim iPODO | praxis prizer europa\'da
gerçekten PROFESYONEL olanı
(3 çeşitten herhangi birini seçin):

Randevu alabilirsiniz:
«aletli pedikür (GERMANY)» için:
TOP-uzmanımıza _

ya da «preparatlı pedikür» KART (İsrail) için

ya da (ayak problemleriniz varsa) -

doğrudan bizzat (!) AnjutaAvrupaÖdüllü\'nün kendisinde (podolog) para-medikal Podolojik PODO-Pedikür için /Karadağ\'da eşi olmayan Özel bir kabinde - (zorunlu ön randevu ile)

——

Saygılarımızla,
iPODO | praxis prizer europa
/by AnjutaAvrupaÖdüllü/

EN ÜST DÜZEY TIRNAK SERVİSİ &
el ve ayak problemlerinin çözümü _

// ..farkı anlayanlar & sağlığına değer verenler için //',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSUN1cHItT29nRRAB'),
  'clinic', @clinic_id,
  'Благодарим Вас за Ваш отзыв (и даже за негативный;)) - ведь как известно, что Жалоба - КАК ПОДАРОК!)))  ..НО(!) ЕСЛИ - ДЕЙСТВИТЕЛЬНО ОНА КОНСТРУКТИВНАЯ (а не, мягко говоря, надуманная..)

!Именно конструктивное обращение - также помогает нам, несмотря на сверх-популярность нашего PODO-формата, становиться ЕЩЁ и и ЕЩЁ и ЕЩЁ - ВЫШЕ!!!

..Итак, давайте по существу (а не голословно):
Основатель _ iPODO | praxis prizer europa - это не просто "Анюта", а со всеми ВНИМАНИЕ! ОФИЦИАЛЬНЫМИ (!!!) регалиями и достижениями за 25(!)лет своей практики - ВЫСОЧАЙШИЙ ДИПЛОМИРОВАННЫЙ СПЕЦИАЛИСТ и PROFESSIONAL в Ногтевой Индустрии /и ПОДОЛОГИИ/:

-АнютаПризёрЕвропы (PARIS, FRANCE)
-Мастер-Преподаватель Международного класса (USA)
-Международный Сертифицированный Инструктор (IZRAIL)
-Ногтевой ЭКС-судья Международной Категории (ОМС, Академии Долорес)
-ПОДОЛОГ, PODO-expert | c опытом работы Более 25!лет _

..Исходя из выше-перечисленного - априори очевидно, что Цена не будет "как у Маши/Глаши" - надомниц или а-ля "хороших"))) мастеров или в других "псевдо-салонах" - это естественно, что у АнютыПризёраЕвропы - как Профессионала ТАКОГО УРОВНЯ - цена Услуг будет ВЫШЕ (и это, как минимум, нормально)..

?ВАМ ДОРОГО - КАЧЕСТВО? - тогда делайте недорого... и некачественно... да ещё и с риском для своего здоровья)))

P/S/ ..и, к слову: У НАС ДОСТУПНО! .. ВСЕГО от19!$ или БЕСПЛАТНО (!) Акция "Услуга за0!" ВОСПОЛЬЗУЙТЕСЬ!

..Кстати, а что касается БЕЗОПАСНОСТИ - Стерилизация & Дезинфекция - у нас ДЕЙСТВИТЕЛЬНО ! ОБРАЗЦОВО-ПОКАЗАТЕЛЬНАЯ: Комплексная + Системная (по-шаговая системная в 15!этапов) - и здесь МЫ тоже - ВЫШЕ!!!))))))

У нас Более
100 ОТЛИЧИЙ & ПРЕИМУЩЕСТВ //

Наш PODO-формат - это ЦЕЛЫЙ (!) КОМПЛЕКС (как в Стоматологии)) -

/Качество+Безопасность+Сервис/=
ВЫСШИЙ НОГТЕВОЙ СЕРВИС //
__

ПОЧЕМУ ? МЫ - ВЫШЕ !

!ВЫСОКОЕ КАЧЕСТВО // - курирует - Лично (!) Призёр Чемпионата Европы, Мастер-Инструктор Международного Класса, Подолог, PODO-expert/АнютаПризёрЕвропы

!ВЫСОКАЯ БЕЗОПАСНОСТЬ //
Исключительно Комплексный подход к Стерилизации и Дезинфекции - как инструментов, так и материалов по всем канонам, правилам и требованиям СанПиН - у нас РЕАЛЬНЫЙ ! ОБРАЗЕЦ

!ВЫСОКИЙ УРОВЕНЬ СЕРВИСА //
У нас Более 100!принципиальных NEW!правил для Комфорта Наших Клиентов;)

iPODO praxis prizer europa |
Чемпионское (!) качество
Медицинская (!) безопасность
Показательный (!) сервис

| Советуем - Попробуйте Лучшее (!)

___

iPODO | praxis prizer europa
/by АнютаПризёрЕвропы/

ВЫСШИЙ НОГТЕВОЙ СЕРВИС & решение проблем рук и ног _

// ..для тех, кто понимает разницу & ценит своё здоровье //', 'ru',
  'Hvala Vam na Vašoj recenziji (pa i na negativnoj;)) - jer kao što je poznato, Žalba je - KAO POKLON!)))  ..ALI(!) SAMO AKO - JE ONA ZAISTA KONSTRUKTIVNA (a ne, blago rečeno, izmišljena..)

!Upravo konstruktivno obraćanje - takođe nam pomaže da, uprkos super-popularnosti našeg PODO-formata, postajemo JOŠ i i JOŠ i JOŠ - VIŠI!!!

..Dakle, da pređemo na suštinu (a ne na priče bez osnova):
Osnivačica _ iPODO | praxis prizer europa - to nije prosto "Anjuta", nego sa svim PAŽNJA! ZVANIČNIM (!!!) titulama i postignućima za 25(!) godina svoje prakse - NAJVIŠI DIPLOMIRANI STRUČNJAK i PROFESSIONAL u Nokatnoj Industriji /i PODOLOGIJI/:

-AnjutaPrizerEvrope (PARIS, FRANCE)
-Majstor-Predavač Međunarodne klase (USA)
-Međunarodni Sertifikovani Instruktor (IZRAIL)
-EKS-sudija za nokte Međunarodne Kategorije (OMC, Akademije Dolores)
-PODOLOG, PODO-expert | sa radnim iskustvom Više od 25! godina _

..Na osnovu gore navedenog - apriori je očigledno da Cijena neće biti "kao kod Maše/Glaše" - koje rade od kuće, ili kod a-la "dobrih"))) majstora ili u drugim "pseudo-salonima" - prirodno je da će kod AnjutePrizeraEvrope - kao Profesionalca TAKVOG NIVOA - cijena Usluga biti VIŠA (i to je, u najmanju ruku, normalno)..

?KVALITET VAM JE SKUP? - onda radite jeftino... i nekvalitetno... i to još uz rizik za svoje zdravlje)))

P/S/ ..i, uzgred: KOD NAS JE PRISTUPAČNO! .. SVEGA od19!$ ili BESPLATNO (!) Akcija "Usluga za0!" ISKORISTITE!

..Kad smo kod BEZBJEDNOSTI - Sterilizacija & Dezinfekcija - kod nas je ZAISTA ! UZORNO-POKAZNA: Kompleksna + Sistemska (korak-po-korak sistemska u 15! faza) - i tu smo MI takođe - VIŠI!!!))))))

Kod nas ima Više od
100 RAZLIKA & PREDNOSTI //

Naš PODO-format - to je CIJELI (!) KOMPLEKS (kao u Stomatologiji)) -

/Kvalitet+Bezbjednost+Servis/=
NAJVIŠI NOKATNI SERVIS //
__

ZAŠTO ? SMO MI - VIŠI !

!VISOK KVALITET // - nadgleda - Lično (!) Osvajačica nagrade na Evropskom prvenstvu, Majstor-Instruktor Međunarodne Klase, Podolog, PODO-expert/AnjutaPrizerEvrope

!VISOKA BEZBJEDNOST //
Isključivo Kompleksan pristup Sterilizaciji i Dezinfekciji - kako instrumenata, tako i materijala, po svim kanonima, pravilima i zahtjevima SanPiN-a - kod nas je to REALAN ! UZOR

!VISOK NIVO SERVISA //
Kod nas postoji Više od 100! principijelnih NEW! pravila za Komfor Naših Klijenata;)

iPODO praxis prizer europa |
Šampionski (!) kvalitet
Medicinska (!) bezbjednost
Uzoran (!) servis

| Savjetujemo - Probajte Najbolje (!)

___

iPODO | praxis prizer europa
/by AnjutaPrizerEvrope/

NAJVIŠI NOKATNI SERVIS & rješavanje problema ruku i nogu _

// ..za one koji razumiju razliku & cijene svoje zdravlje //', 'Хвала Вам на Вашој рецензији (па и на негативној;)) - јер као што је познато, Жалба је - КАО ПОКЛОН!)))  ..АЛИ(!) САМО АКО - је она заиста КОНСТРУКТИВНА (а не, благо речено, измишљена..)

!Управо конструктивно обраћање - такође нам помаже да, упркос супер-популарности нашег PODO-формата, постајемо ЈОШ и и ЈОШ и ЈОШ - ВИШИ!!!

..Дакле, да пређемо на суштину (а не на приче без основа):
Оснивачица _ iPODO | praxis prizer europa - то није просто "Ањута", него са свим ПАЖЊА! ЗВАНИЧНИМ (!!!) титулама и постигнућима за 25(!) година своје праксе - НАЈВИШИ ДИПЛОМИРАНИ СТРУЧЊАК и PROFESSIONAL у Нокатној Индустрији /и ПОДОЛОГИЈИ/:

-АњутаПризерЕвропе (PARIS, FRANCE)
-Мајстор-Предавач Међународне класе (USA)
-Међународни Сертификовани Инструктор (IZRAIL)
-ЕКС-судија за нокте Међународне Категорије (OMC, Академије Dolores)
-ПОДОЛОГ, PODO-expert | са радним искуством Више од 25! година _

..На основу горе наведеног - априори је очигледно да Цијена неће бити "као код Маше/Глаше" - које раде од куће, или код а-ла "добрих"))) мајстора или у другим "псеудо-салонима" - природно је да ће код АњутеПризераЕвропе - као Професионалца ТАКВОГ НИВОА - цијена Услуга бити ВИША (и то је, у најмању руку, нормално)..

?КВАЛИТЕТ ВАМ ЈЕ СКУП? - онда радите јефтино... и неквалитетно... и то још уз риск за своје здравље)))

P/S/ ..и, узгред: КОД НАС ЈЕ ПРИСТУПАЧНО! .. СВЕГА од19!$ или БЕСПЛАТНО (!) Акција "Услуга за0!" ИСКОРИСТИТЕ!

..Кад смо код БЕЗБЈЕДНОСТИ - Стерилизација & Дезинфекција - код нас је ЗАИСТА ! УЗОРНО-ПОКАЗНА: Комплексна + Системска (корак-по-корак системска у 15! фаза) - и ту смо МИ такође - ВИШИ!!!))))))

Код нас има Више од
100 РАЗЛИКА & ПРЕДНОСТИ //

Наш PODO-формат - то је ЦИЈЕЛИ (!) КОМПЛЕКС (као у Стоматологији)) -

/Квалитет+Безбједност+Сервис/=
НАЈВИШИ НОКАТНИ СЕРВИС //
__

ЗАШТО ? СМО МИ - ВИШИ !

!ВИСОК КВАЛИТЕТ // - надгледа - Лично (!) Освајачица награде на Европском првенству, Мајстор-Инструктор Међународне Класе, Подолог, PODO-expert/АњутаПризерЕвропе

!ВИСОКА БЕЗБЈЕДНОСТ //
Искључиво Комплексан приступ Стерилизацији и Дезинфекцији - како инструмената, тако и материјала, по свим канонима, правилима и захтјевима SanPiN-а - код нас је то РЕАЛАН ! УЗОР

!ВИСОК НИВО СЕРВИСА //
Код нас постоји Више од 100! принципијелних NEW! правила за Комфор Наших Клијената;)

iPODO praxis prizer europa |
Шампионски (!) квалитет
Медицинска (!) безбједност
Узоран (!) сервис

| Савјетујемо - Пробајте Најбоље (!)

___

iPODO | praxis prizer europa
/by AnjutaPrizerEvrope/

НАЈВИШИ НОКАТНИ СЕРВИС & рјешавање проблема руку и ногу _

// ..за оне који разумију разлику & цијене своје здравље //', 'Thank you for your review (even for a negative one;)) - because, as everyone knows, a Complaint is LIKE A GIFT!)))  ..BUT(!) ONLY IF - IT REALLY IS CONSTRUCTIVE (and not, to put it mildly, made up..)

!It is precisely constructive feedback that also helps us, despite the super-popularity of our PODO-format, to become EVEN and and EVEN and EVEN - HIGHER!!!

..So, let\'s get down to the substance (and not to empty claims):
The founder _ iPODO | praxis prizer europa - is not just "Anjuta", but, with all her ATTENTION! OFFICIAL (!!!) titles and achievements over 25(!) years of practice - the HIGHEST CERTIFIED SPECIALIST and PROFESSIONAL in the Nail Industry /and PODOLOGY/:

-AnjutaEuropeanPrizeWinner (PARIS, FRANCE)
-International-class Master-Teacher (USA)
-International Certified Instructor (IZRAIL)
-FORMER International Category nail competition judge (OMC, Dolores Academy)
-PODIATRIST, PODO-expert | with More than 25! years of experience _

..Given the above - it is a priori obvious that the Price will not be "the same as at Masha\'s/Glasha\'s" - women working from home, or at the a-la "good"))) technicians, or in other "pseudo-salons" - it is natural that with AnjutaEuropeanPrizeWinner - a Professional of THIS LEVEL - the price of the Services will be HIGHER (and that is, at the very least, normal)..

?IS QUALITY TOO EXPENSIVE FOR YOU? - then get it done cheap... and badly... and with a risk to your health on top of that)))

P/S/ ..and, by the way: WE ARE AFFORDABLE! .. ONLY from19!$ or FREE (!) The promo "A Service for0!" TAKE ADVANTAGE OF IT!

..By the way, as for SAFETY - Sterilisation & Disinfection - ours REALLY IS ! A MODEL SHOWCASE: Comprehensive + Systemic (step-by-step systemic, in 15! stages) - and here too WE are - HIGHER!!!))))))

We have More than
100 DIFFERENCES & ADVANTAGES //

Our PODO-format is a WHOLE (!) COMPLEX (like in Dentistry)) -

/Quality+Safety+Service/=
TOP NAIL SERVICE //
__

WHY ? ARE WE - HIGHER !

!HIGH QUALITY // - supervised - Personally (!) by a European Championship Prize Winner, an International-Class Master-Instructor, a Podiatrist, PODO-expert/AnjutaEuropeanPrizeWinner

!HIGH SAFETY //
An exclusively Comprehensive approach to the Sterilisation and Disinfection of both instruments and materials, following all the canons, rules and requirements of SanPiN - ours is a REAL ! MODEL

!HIGH LEVEL OF SERVICE //
We have More than 100! matter-of-principle NEW! rules for the Comfort of Our Clients;)

iPODO praxis prizer europa |
Champion-level (!) quality
Medical (!) safety
Exemplary (!) service

| Our advice - Try the Best (!)

___

iPODO | praxis prizer europa
/by AnjutaEuropeanPrizeWinner/

TOP NAIL SERVICE & solving hand and foot problems _

// ..for those who understand the difference & value their health //', 'Благодарим Вас за Ваш отзыв (и даже за негативный;)) - ведь как известно, что Жалоба - КАК ПОДАРОК!)))  ..НО(!) ЕСЛИ - ДЕЙСТВИТЕЛЬНО ОНА КОНСТРУКТИВНАЯ (а не, мягко говоря, надуманная..)

!Именно конструктивное обращение - также помогает нам, несмотря на сверх-популярность нашего PODO-формата, становиться ЕЩЁ и и ЕЩЁ и ЕЩЁ - ВЫШЕ!!!

..Итак, давайте по существу (а не голословно):
Основатель _ iPODO | praxis prizer europa - это не просто "Анюта", а со всеми ВНИМАНИЕ! ОФИЦИАЛЬНЫМИ (!!!) регалиями и достижениями за 25(!)лет своей практики - ВЫСОЧАЙШИЙ ДИПЛОМИРОВАННЫЙ СПЕЦИАЛИСТ и PROFESSIONAL в Ногтевой Индустрии /и ПОДОЛОГИИ/:

-АнютаПризёрЕвропы (PARIS, FRANCE)
-Мастер-Преподаватель Международного класса (USA)
-Международный Сертифицированный Инструктор (IZRAIL)
-Ногтевой ЭКС-судья Международной Категории (ОМС, Академии Долорес)
-ПОДОЛОГ, PODO-expert | c опытом работы Более 25!лет _

..Исходя из выше-перечисленного - априори очевидно, что Цена не будет "как у Маши/Глаши" - надомниц или а-ля "хороших"))) мастеров или в других "псевдо-салонах" - это естественно, что у АнютыПризёраЕвропы - как Профессионала ТАКОГО УРОВНЯ - цена Услуг будет ВЫШЕ (и это, как минимум, нормально)..

?ВАМ ДОРОГО - КАЧЕСТВО? - тогда делайте недорого... и некачественно... да ещё и с риском для своего здоровья)))

P/S/ ..и, к слову: У НАС ДОСТУПНО! .. ВСЕГО от19!$ или БЕСПЛАТНО (!) Акция "Услуга за0!" ВОСПОЛЬЗУЙТЕСЬ!

..Кстати, а что касается БЕЗОПАСНОСТИ - Стерилизация & Дезинфекция - у нас ДЕЙСТВИТЕЛЬНО ! ОБРАЗЦОВО-ПОКАЗАТЕЛЬНАЯ: Комплексная + Системная (по-шаговая системная в 15!этапов) - и здесь МЫ тоже - ВЫШЕ!!!))))))

У нас Более
100 ОТЛИЧИЙ & ПРЕИМУЩЕСТВ //

Наш PODO-формат - это ЦЕЛЫЙ (!) КОМПЛЕКС (как в Стоматологии)) -

/Качество+Безопасность+Сервис/=
ВЫСШИЙ НОГТЕВОЙ СЕРВИС //
__

ПОЧЕМУ ? МЫ - ВЫШЕ !

!ВЫСОКОЕ КАЧЕСТВО // - курирует - Лично (!) Призёр Чемпионата Европы, Мастер-Инструктор Международного Класса, Подолог, PODO-expert/АнютаПризёрЕвропы

!ВЫСОКАЯ БЕЗОПАСНОСТЬ //
Исключительно Комплексный подход к Стерилизации и Дезинфекции - как инструментов, так и материалов по всем канонам, правилам и требованиям СанПиН - у нас РЕАЛЬНЫЙ ! ОБРАЗЕЦ

!ВЫСОКИЙ УРОВЕНЬ СЕРВИСА //
У нас Более 100!принципиальных NEW!правил для Комфорта Наших Клиентов;)

iPODO praxis prizer europa |
Чемпионское (!) качество
Медицинская (!) безопасность
Показательный (!) сервис

| Советуем - Попробуйте Лучшее (!)

___

iPODO | praxis prizer europa
/by АнютаПризёрЕвропы/

ВЫСШИЙ НОГТЕВОЙ СЕРВИС & решение проблем рук и ног _

// ..для тех, кто понимает разницу & ценит своё здоровье //', 'Wir danken Ihnen für Ihre Bewertung (sogar für eine negative;)) - denn wie bekannt ist eine Beschwerde WIE EIN GESCHENK!)))  ..ABER(!) NUR WENN - sie WIRKLICH KONSTRUKTIV IST (und nicht, milde gesagt, erfunden..)

!Genau konstruktive Rückmeldung hilft uns auch, trotz der Über-Popularität unseres PODO-Formats, IMMER und und IMMER und IMMER - BESSER zu werden!!!

..Also, kommen wir zur Sache (und nicht zu leeren Behauptungen):
Die Gründerin _ iPODO | praxis prizer europa - ist nicht einfach "Anjuta", sondern, mit all ihren ACHTUNG! OFFIZIELLEN (!!!) Auszeichnungen und Erfolgen aus 25(!) Jahren Praxis - die HÖCHSTQUALIFIZIERTE DIPLOMIERTE FACHFRAU und PROFESSIONAL in der Nagelbranche /und der PODOLOGIE/:

-AnjutaEuropaPreisträgerin (PARIS, FRANCE)
-Meister-Lehrerin internationaler Klasse (USA)
-Internationale Zertifizierte Instruktorin (IZRAIL)
-EHEMALIGE Nagel-Wettkampfrichterin der Internationalen Kategorie (OMC, Dolores-Akademie)
-PODOLOGIN, PODO-Expertin | mit Mehr als 25! Jahren Berufserfahrung _

..Aus dem oben Genannten - ist von vornherein klar, dass der Preis nicht "wie bei Masha/Glasha" sein wird - bei Heimarbeiterinnen oder bei a-la "guten"))) Fachkräften oder in anderen "Pseudo-Salons" - es ist natürlich, dass bei AnjutaEuropaPreisträgerin - als Profi DIESES NIVEAUS - der Preis der Leistungen HÖHER ist (und das ist zumindest normal)..

?IST IHNEN QUALITÄT ZU TEUER? - dann lassen Sie es billig machen... und schlecht... und dazu noch mit einem Risiko für Ihre Gesundheit)))

P/S/ ..und, übrigens: BEI UNS IST ES ERSCHWINGLICH! .. NUR ab19!$ oder KOSTENLOS (!) Aktion "Eine Leistung für0!" NUTZEN SIE DAS!

..Übrigens, was die SICHERHEIT betrifft - Sterilisation & Desinfektion - bei uns ist sie WIRKLICH ! VORBILDLICH: Komplex + Systemisch (Schritt-für-Schritt systemisch, in 15! Stufen) - und auch hier sind WIR - BESSER!!!))))))

Bei uns gibt es Mehr als
100 UNTERSCHIEDE & VORTEILE //

Unser PODO-Format ist ein GANZER (!) KOMPLEX (wie in der Zahnmedizin)) -

/Qualität+Sicherheit+Service/=
HÖCHSTER NAGELSERVICE //
__

WARUM ? SIND WIR - BESSER !

!HOHE QUALITÄT // - betreut - Persönlich (!) von einer Preisträgerin der Europameisterschaft, einer Meister-Instruktorin Internationaler Klasse, einer Podologin, PODO-Expertin/AnjutaEuropaPreisträgerin

!HOHE SICHERHEIT //
Ein ausschließlich Komplexer Ansatz bei der Sterilisation und Desinfektion - sowohl der Instrumente als auch der Materialien, nach allen Kanons, Regeln und Anforderungen von SanPiN - bei uns ist das ein ECHTES ! MUSTERBEISPIEL

!HOHES SERVICENIVEAU //
Bei uns gibt es Mehr als 100! grundsätzliche NEW! Regeln für den Komfort Unserer Kunden;)

iPODO praxis prizer europa |
Meisterliche (!) Qualität
Medizinische (!) Sicherheit
Vorbildlicher (!) Service

| Unser Rat - Probieren Sie das Beste (!)

___

iPODO | praxis prizer europa
/by AnjutaEuropaPreisträgerin/

HÖCHSTER NAGELSERVICE & Lösung von Hand- und Fußproblemen _

// ..für die, die den Unterschied verstehen & ihre Gesundheit schätzen //', 'Yorumunuz için teşekkür ederiz (hatta olumsuz olduğu için de;)) - çünkü bilindiği gibi Şikâyet BİR ARMAĞAN GİBİDİR!)))  ..AMA(!) EĞER - GERÇEKTEN YAPICIYSA (hafif tabirle uydurma değilse..)

!Tam da yapıcı geri bildirim, PODO-formatımızın aşırı popülerliğine rağmen, DAHA ve ve DAHA ve DAHA - YÜKSEĞE çıkmamıza yardım eder!!!

..O halde, esasa geçelim (kuru laf değil):
Kurucu _ iPODO | praxis prizer europa - sadece "Anjuta" değil, 25(!) yıllık pratiğinin tüm DİKKAT! RESMİ (!!!) unvan ve başarılarıyla - Tırnak Sektöründe /ve PODOLOJİDE/ EN ÜST DÜZEY DİPLOMALI UZMAN ve PROFESSIONAL:

-AnjutaAvrupaÖdüllü (PARIS, FRANCE)
-Uluslararası sınıf Master-Eğitmen (USA)
-Uluslararası Sertifikalı Eğitmen (IZRAIL)
-Uluslararası Kategoride ESKİ tırnak yarışması jüri üyesi (OMC, Dolores Akademisi)
-PODOLOG, PODO-expert | 25! yıldan fazla iş deneyimiyle _

..Yukarıda sayılanlardan - baştan bellidir ki Fiyat "Masha/Glasha\'daki gibi" olmayacak - evden çalışanlar ya da sözde "iyi"))) uzmanlar ya da diğer "sözde salonlar" gibi - BU DÜZEYDE bir Profesyonel olan AnjutaAvrupaÖdüllü\'de Hizmet fiyatının DAHA YÜKSEK olması doğaldır (ve bu, en azından, normaldir)..

?KALİTE SİZE PAHALI MI GELİYOR? - o zaman ucuza yaptırın... ve kalitesiz... üstelik sağlığınızı da riske atarak)))

P/S/ ..ve bu arada: BİZDE ERİŞİLEBİLİR! .. SADECE 19!$\'dan ya da ÜCRETSİZ (!) "0\'a Hizmet!" Kampanyası FAYDALANIN!

..Sırası gelmişken, GÜVENLİK konusuna gelince - Sterilizasyon & Dezenfeksiyon - bizde GERÇEKTEN ! ÖRNEK NİTELİĞİNDE: Kapsamlı + Sistemli (adım adım sistemli, 15! aşamada) - ve burada da BİZ - DAHA YÜKSEKTEYİZ!!!))))))

Bizde 100\'den fazla
FARK & AVANTAJ var //

Bizim PODO-formatımız BÜTÜN (!) BİR KOMPLEKS (Diş Hekimliğinde olduğu gibi)) -

/Kalite+Güvenlik+Servis/=
EN ÜST DÜZEY TIRNAK SERVİSİ //
__

NEDEN ? BİZ - DAHA YÜKSEKTEYİZ !

!YÜKSEK KALİTE // - Bizzat (!) Avrupa Şampiyonası derece sahibi, Uluslararası Sınıf Master-Eğitmen, Podolog, PODO-expert/AnjutaAvrupaÖdüllü denetliyor

!YÜKSEK GÜVENLİK //
Hem aletlerin hem malzemelerin Sterilizasyonuna ve Dezenfeksiyonuna, tüm kurallara, kaidelere ve SanPiN gerekliliklerine uygun, yalnızca Kapsamlı bir yaklaşım - bizde bu GERÇEK bir ! ÖRNEK

!YÜKSEK SERVİS DÜZEYİ //
Bizde Müşterilerimizin Konforu için 100\'den! fazla ilkesel NEW! kural var;)

iPODO praxis prizer europa |
Şampiyon (!) kalitesi
Medikal (!) güvenlik
Örnek (!) servis

| Tavsiyemiz - En İyisini Deneyin (!)

___

iPODO | praxis prizer europa
/by AnjutaAvrupaÖdüllü/

EN ÜST DÜZEY TIRNAK SERVİSİ & el ve ayak problemlerinin çözümü _

// ..farkı anlayanlar & sağlığına değer verenler için //',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJZZCl95fVTRMReLlhoR499pY/reviews/ChdDSUhNMG9nS0VJQ0FnSURPNm9ldXZ3RRAB'),
  'clinic', @clinic_id,
  'СПАСИБО!!!!!!!!

У нас Более
100 ОТЛИЧИЙ & ПРЕИМУЩЕСТВ //

Наш PODO-формат - это ЦЕЛЫЙ (!) КОМПЛЕКС (как в Стоматологии)) -
/Качество+Безопасность+Сервис/=ВЫСШИЙ НОГТЕВОЙ СЕРВИС //
__

ПОЧЕМУ ? МЫ - ВЫШЕ !

!ВЫСОКОЕ КАЧЕСТВО // - курирует - Лично (!) Призёр Чемпионата Европы, Мастер-Инструктор Международного Класса, Подолог, PODO-expert/АнютаПризёрЕвропы

!ВЫСОКАЯ БЕЗОПАСНОСТЬ //
Исключительно Комплексный подход к Стерилизации и Дезинфекции - как инструментов, так и материалов по всем канонам, правилам и требованиям СанПиН - у нас РЕАЛЬНЫЙ ! ОБРАЗЕЦ

!ВЫСОКИЙ УРОВЕНЬ СЕРВИСА //
У нас Более 100!принципиальных NEW!правил для Комфорта Наших Клиентов;)

iPODO praxis prizer europa |
Чемпионское (!) качество
Медицинская (!) безопасность
Показательный (!) сервис

| Советуем - Попробуйте Лучшее (!)

___

iPODO | praxis prizer europa
/by АнютаПризёрЕвропы/

ВЫСШИЙ НОГТЕВОЙ СЕРВИС & решение проблем рук и ног _

// ..для тех, кто понимает разницу & ценит своё здоровье //', 'ru',
  'HVALA!!!!!!!!

Kod nas je Više od
100 RAZLIKA & PREDNOSTI //

Naš PODO-format - to je CIJELI (!) KOMPLEKS (kao u Stomatologiji)) -
/Kvalitet+Bezbjednost+Servis/=VRHUNSKI SERVIS ZA NOKTE //
__

ZAŠTO ? MI - SMO IZNAD !

!VISOK KVALITET // - vodi - Lično (!) Laureat Evropskog Šampionata, Master-Instruktor Međunarodne Klase, Podolog, PODO-expert/AnjutaPrizerEvrope

!VISOKA BEZBJEDNOST //
Isključivo Kompleksan pristup Sterilizaciji i Dezinfekciji - i instrumenata i materijala, po svim kanonima, pravilima i zahtjevima SanPiN - kod nas je REALAN ! PRIMJER

!VISOK NIVO SERVISA //
Kod nas je Više od 100!principijelnih NEW!pravila za Komfor Naših Klijenata;)

iPODO praxis prizer europa |
Šampionski (!) kvalitet
Medicinska (!) bezbjednost
Uzoran (!) servis

| Savjetujemo - Probajte Najbolje (!)

___

iPODO | praxis prizer europa
/by AnjutaPrizerEvrope/

VRHUNSKI SERVIS ZA NOKTE & rješavanje problema ruku i stopala _

// ..za one koji razumiju razliku & cijene svoje zdravlje //', 'ХВАЛА!!!!!!!!

Код нас је Више од
100 РАЗЛИКА & ПРЕДНОСТИ //

Наш PODO-формат - то је ЦИЈЕЛИ (!) КОМПЛЕКС (као у Стоматологији)) -
/Квалитет+Безбједност+Сервис/=ВРХУНСКИ СЕРВИС ЗА НОКТЕ //
__

ЗАШТО ? МИ - СМО ИЗНАД !

!ВИСОК КВАЛИТЕТ // - води - Лично (!) Лауреат Европског Шампионата, Мастер-Инструктор Међународне Класе, Подолог, PODO-expert/АњутаПризерЕвропе

!ВИСОКА БЕЗБЈЕДНОСТ //
Исклучиво Комплексан приступ Стерилизацији и Дезинфекцији - и инструмената и материјала, по свим канонима, правилима и захтјевима SanPiN - код нас је РЕАЛАН ! ПРИМЈЕР

!ВИСОК НИВО СЕРВИСА //
Код нас је Више од 100!принципијелних NEW!правила за Комфор Наших Клијената;)

iPODO praxis prizer europa |
Шампионски (!) квалитет
Медицинска (!) безбједност
Узоран (!) сервис

| Савјетујемо - Пробајте Најбоље (!)

___

iPODO | praxis prizer europa
/by АњутаПризерЕвропе/

ВРХУНСКИ СЕРВИС ЗА НОКТЕ & рјешавање проблема руку и стопала _

// ..за оне који разумију разлику & цијене своје здравље //', 'THANK YOU!!!!!!!!

We have More than
100 DIFFERENCES & ADVANTAGES //

Our PODO-format is a WHOLE (!) COMPLEX (like in Dentistry)) -
/Quality+Safety+Service/=TOP-TIER NAIL SERVICE //
__

WHY ? WE - ARE ABOVE !

!HIGH QUALITY // - is supervised - Personally (!) by a European Championship Award Winner, Master Instructor of International Class, Podologist, PODO-expert/AnjutaEuropeanPrizeWinner

!HIGH SAFETY //
An exclusively Comprehensive approach to Sterilisation and Disinfection - of both instruments and materials, by all the canons, rules and requirements of SanPiN - with us it is a REAL ! BENCHMARK

!HIGH LEVEL OF SERVICE //
We have More than 100!matters-of-principle NEW!rules for the Comfort of Our Clients;)

iPODO praxis prizer europa |
Championship (!) quality
Medical (!) safety
Exemplary (!) service

| Our advice - Try the Best (!)

___

iPODO | praxis prizer europa
/by AnjutaEuropeanPrizeWinner/

TOP-TIER NAIL SERVICE & solving problems of hands and feet _

// ..for those who understand the difference & value their health //', 'СПАСИБО!!!!!!!!

У нас Более
100 ОТЛИЧИЙ & ПРЕИМУЩЕСТВ //

Наш PODO-формат - это ЦЕЛЫЙ (!) КОМПЛЕКС (как в Стоматологии)) -
/Качество+Безопасность+Сервис/=ВЫСШИЙ НОГТЕВОЙ СЕРВИС //
__

ПОЧЕМУ ? МЫ - ВЫШЕ !

!ВЫСОКОЕ КАЧЕСТВО // - курирует - Лично (!) Призёр Чемпионата Европы, Мастер-Инструктор Международного Класса, Подолог, PODO-expert/АнютаПризёрЕвропы

!ВЫСОКАЯ БЕЗОПАСНОСТЬ //
Исключительно Комплексный подход к Стерилизации и Дезинфекции - как инструментов, так и материалов по всем канонам, правилам и требованиям СанПиН - у нас РЕАЛЬНЫЙ ! ОБРАЗЕЦ

!ВЫСОКИЙ УРОВЕНЬ СЕРВИСА //
У нас Более 100!принципиальных NEW!правил для Комфорта Наших Клиентов;)

iPODO praxis prizer europa |
Чемпионское (!) качество
Медицинская (!) безопасность
Показательный (!) сервис

| Советуем - Попробуйте Лучшее (!)

___

iPODO | praxis prizer europa
/by АнютаПризёрЕвропы/

ВЫСШИЙ НОГТЕВОЙ СЕРВИС & решение проблем рук и ног _

// ..для тех, кто понимает разницу & ценит своё здоровье //', 'DANKE!!!!!!!!

Bei uns gibt es Mehr als
100 UNTERSCHIEDE & VORTEILE //

Unser PODO-Format ist ein GANZER (!) KOMPLEX (wie in der Zahnmedizin)) -
/Qualität+Sicherheit+Service/=HÖCHSTER NAGEL-SERVICE //
__

WARUM ? WIR - SIND DARÜBER !

!HOHE QUALITÄT // - wird betreut - Persönlich (!) von einer Preisträgerin der Europameisterschaft, Master-Instruktorin internationaler Klasse, Podologin, PODO-expert/AnjutaEuropaPreisträgerin

!HOHE SICHERHEIT //
Ein ausschließlich Umfassender Ansatz bei Sterilisation und Desinfektion - sowohl der Instrumente als auch der Materialien, nach allen Kanons, Regeln und Anforderungen von SanPiN - bei uns ein ECHTES ! VORBILD

!HOHES SERVICENIVEAU //
Bei uns gibt es Mehr als 100!grundsätzliche NEUE!Regeln für den Komfort Unserer Kunden;)

iPODO praxis prizer europa |
Meisterliche (!) Qualität
Medizinische (!) Sicherheit
Vorbildlicher (!) Service

| Unser Rat - Probieren Sie das Beste (!)

___

iPODO | praxis prizer europa
/by AnjutaEuropaPreisträgerin/

HÖCHSTER NAGEL-SERVICE & Lösung von Hand- und Fußproblemen _

// ..für die, die den Unterschied verstehen & ihre Gesundheit schätzen //', 'TEŞEKKÜRLER!!!!!!!!

Bizde 100\'den fazla
FARK & AVANTAJ var //

Bizim PODO-formatımız BÜTÜN (!) BİR KOMPLEKS (Diş Hekimliğinde olduğu gibi)) -
/Kalite+Güvenlik+Hizmet/=EN ÜST DÜZEY TIRNAK HİZMETİ //
__

NEDEN ? BİZ - DAHA ÜSTÜNÜZ !

!YÜKSEK KALİTE // - yürütülüyor - Bizzat (!) Avrupa Şampiyonası Ödüllüsü, Uluslararası Sınıf Master-Eğitmen, Podolog, PODO-expert/AnjutaAvrupaÖdüllü tarafından

!YÜKSEK GÜVENLİK //
Sterilizasyon ve Dezenfeksiyona istisnasız Kapsamlı bir yaklaşım - hem aletler hem malzemeler için, tüm kurallara, ilkelere ve SanPiN gerekliliklerine uygun - bizde GERÇEK ! BİR ÖRNEK

!YÜKSEK HİZMET SEVİYESİ //
Bizde Müşterilerimizin Konforu için 100\'den fazla!ilkesel YENİ!kural var;)

iPODO praxis prizer europa |
Şampiyon (!) kalite
Tıbbi (!) güvenlik
Örnek (!) hizmet

| Tavsiyemiz - En İyisini Deneyin (!)

___

iPODO | praxis prizer europa
/by AnjutaAvrupaÖdüllü/

EN ÜST DÜZEY TIRNAK HİZMETİ & el ve ayak sorunlarının çözümü _

// ..farkı anlayan & sağlığına değer verenler için //',
  'google_maps', '2023-08-03 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
