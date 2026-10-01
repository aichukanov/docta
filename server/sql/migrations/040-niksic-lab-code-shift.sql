-- 040: анализы Opšta bolnica Nikšić, привязанные к соседней позиции прайса.
--
-- Клиники адресуются по slug: id Никшича локально 137, на проде 141 (а 137 на
-- проде — Беране). Первая версия файла писала id литералом и на проде попала
-- в Беране — ремонт этого в 042.
--
-- ЧТО СЛОМАНО. Импорт Никшича (data/clinic-services-import/opsta-bolnica-niksic)
-- связывал строки прайса с каталогом не по названию из PDF клиники
-- (name_extracted), а по имени того же кода в FINAL.json (name_verified). В
-- FINAL имена части блоков съехали на соседний код — их чинит 038 (раздел 1).
-- Код и цена у строк Никшича верные, а анализ, на котором они висят, — соседний.
-- На сайте это видно так: на странице «Инсулин» у Никшича стоит цена CEA,
-- на «ЛДГ» — клиренс креатинина, на «CA-125» — инсулин.
--
-- ДОКАЗАТЕЛЬСТВА. Для каждой строки ниже: тот же код у клиники 88 (Данило)
-- стоит на другой записи каталога, и название этой записи совпадает с
-- названием в PDF Никшича И в прайсе Данило дословно. Цены Никшича — ровно
-- прайс Данило / 1,2. Двадцать строк, блоки K03, Z01, Z02.
--
-- Плюс две строки, которые импорт по той же причине потерял, — LDH (Z01104)
-- и CA-125 (Z02081): в PDF Никшича они есть, но «свои» анализы были заняты
-- сдвинутыми строками. Цены из PDF совпадают с ценами клиники 88.
--
-- Плюс клиника 88: Z02071 в её собственном прайсе — «BNP», а строка висела на
-- pro-bnp. Это открытый вопрос из шапки 030 («название 183 стоит перепроверить
-- по прайсу клиники») — прайс отвечает: BNP.
--
-- ЧТО НЕ ВОШЛО. Строки Никшича с кодами K03101, K03123, K03126, K03135, K03140,
-- K03143 лежат в каталоге УСЛУГ (anti-hanta-virus-igg-antibodies-elisa на коде
-- K03126 «Anti HBc» и т.п.) — тот же сдвиг, но лечится переносом между
-- каталогами (как 029), отдельной задачей.
--
-- Порядок важен: на (clinic_id, lab_test_id) стоит UNIQUE, поэтому строка
-- переезжает только после того, как цель освободила предыдущая. В цепочке
-- K03091–K03100 это порядок по возрастанию кода, в парах K03127/K03128 и
-- K03136/K03137 — по убыванию. UPDATE IGNORE + условие на текущий анализ:
-- повторный прогон и расхождения прода ничего не ломают — строка, которую
-- не удалось перенести, видна в проверочном SELECT в конце.
--
-- Независима от 038/039: ни один анализ отсюда там не сливается.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @niksic = (SELECT id FROM clinics WHERE slug = 'opsta-bolnica-niksic');
SET @danilo = (SELECT id FROM clinics WHERE slug = 'bolnica-danilo-i-cetinje');

START TRANSACTION;

-- ── K03091–K03100: цепочка, каждая строка на месте следующей

-- K03091 «Bakteriološko ispitivanje sadržaja drena - anaerobno» (20,53 €)
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'drain-content-culture-anaerobic')
 WHERE clinic_id = @niksic AND code = 'K03091' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'echinococcus-detection-stained-preparation');
-- K03092 «Ispitivanje prisustva Echinococcus spp. - bojeni preparat» (10,78 €)
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'echinococcus-detection-stained-preparation')
 WHERE clinic_id = @niksic AND code = 'K03092' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'echinococcus-detection-native-preparation');
-- K03093 «Ispitivanje prisustva Echinococcus spp. - nativni preparat» (10,78 €)
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'echinococcus-detection-native-preparation')
 WHERE clinic_id = @niksic AND code = 'K03093' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'babesia-detection-stained-thick-drop-preparation');
-- K03094 «Babesia spp. - bojeni preparat guste kapi» (27,75 €)
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'babesia-detection-stained-thick-drop-preparation')
 WHERE clinic_id = @niksic AND code = 'K03094' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'babesia-detection-stained-blood-smear');
-- K03095 «Babesia spp. - bojeni preparat krvnog razmaza» (27,75 €)
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'babesia-detection-stained-blood-smear')
 WHERE clinic_id = @niksic AND code = 'K03095' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'cryptococcus-detection-cultivation');
-- K03096 «Cryptococcus spp. - kultivacija» (11,10 €)
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'cryptococcus-detection-cultivation')
 WHERE clinic_id = @niksic AND code = 'K03096' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'cryptococcus-detection-stained-preparation');
-- K03097 «Cryptococcus spp. - bojeni preparat» (11,10 €)
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'cryptococcus-detection-stained-preparation')
 WHERE clinic_id = @niksic AND code = 'K03097' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'cryptococcus-detection-india-ink-preparation');
-- K03098 «Cryptococcus spp. - tuš preparat» (11,10 €)
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'cryptococcus-detection-india-ink-preparation')
 WHERE clinic_id = @niksic AND code = 'K03098' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'blood-and-tissue-parasite-detection-stained-thick-drop');
-- K03099 «Krvni i tkivni paraziti - bojeni preparat guste kapi» (27,75 €)
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'blood-and-tissue-parasite-detection-stained-thick-drop')
 WHERE clinic_id = @niksic AND code = 'K03099' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'blood-and-tissue-parasite-detection-stained-blood-smear');
-- K03100 «Krvni i tkivni paraziti - bojeni preparat krvnog razmaza» (27,75 €)
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'blood-and-tissue-parasite-detection-stained-blood-smear')
 WHERE clinic_id = @niksic AND code = 'K03100' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'blood-and-tissue-parasite-detection-native-preparation');

-- ── K03124–K03144: одиночные сдвиги и две пары

-- K03124 «Anti Hanta virus IgM antitijela - ELISA» (11,90 €)
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'hantavirus-igm-elisa')
 WHERE clinic_id = @niksic AND code = 'K03124' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'echinococcus-granulosus-antibodies-indirect-hemagglutination');
-- K03128 «Anti HBeAg antitijela - ELISA» (11,90 €) — раньше K03127: освобождает anti-hbc-igm-elisa
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'anti-hbe-elisa')
 WHERE clinic_id = @niksic AND code = 'K03128' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'anti-hbc-igm-elisa');
-- K03127 «Anti HBc IgM antitijela - ELISA» (11,90 €)
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'anti-hbc-igm-elisa')
 WHERE clinic_id = @niksic AND code = 'K03127' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'anti-hbc-total-elisa');
-- K03137 «Anti influenza B virus IgM antitijela - ELISA» (11,90 €) — раньше K03136: освобождает anti-hiv-2
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'influenza-b-virus-igm-elisa')
 WHERE clinic_id = @niksic AND code = 'K03137' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'anti-hiv-2-western-blot-confirmation');
-- K03136 «Anti HIV 2 antitijela - potvrdni test - Western blot» (35,20 €)
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'anti-hiv-2-western-blot-confirmation')
 WHERE clinic_id = @niksic AND code = 'K03136' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'anti-hiv-1-western-blot-confirmation');
-- K03141 «Anti Legionella pneumophila IgM antitijela - ELISA» (11,90 €)
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'legionella-pneumophila-igm')
 WHERE clinic_id = @niksic AND code = 'K03141' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'influenza-a-virus-igg-elisa');
-- K03144 «Anti Leishmania donovani IgG antitijela - ELISA» (11,90 €)
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'leishmania-donovani-igg-elisa')
 WHERE clinic_id = @niksic AND code = 'K03144' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'legionella-pneumophila-iga-elisa');

-- ── Z01, Z02: биохимия и онкомаркеры

-- Z01100 «Određivanje klirensa kreatinina» (3,50 €) — висела на ЛДГ
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'creatinine-clearance')
 WHERE clinic_id = @niksic AND code = 'Z01100' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'ldh');
-- Z02021 «CEA (karcinoembrionalni antigen)» (19,40 €) — висела на инсулине
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'cea')
 WHERE clinic_id = @niksic AND code = 'Z02021' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'insulin');
-- Z02031 «Insulin» (23,60 €) — висела на CA-125
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'insulin')
 WHERE clinic_id = @niksic AND code = 'Z02031' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'ca-125');

-- ── Потерянные строки: ЛДГ и CA-125 освободились выше

-- Z01104 «Određivanje aktivnosti laktat dehidrogenaze (LDH)» — 3,18 € в PDF (у 88 та же цена)
INSERT IGNORE INTO clinic_lab_tests (lab_test_id, clinic_id, code, price)
SELECT id, @niksic, 'Z01104', 3.18 FROM lab_tests WHERE slug = 'ldh' AND @niksic IS NOT NULL;
-- Z02081 «CA-125» — 23,73 € в PDF (у 88 та же цена)
INSERT IGNORE INTO clinic_lab_tests (lab_test_id, clinic_id, code, price)
SELECT id, @niksic, 'Z02081', 23.73 FROM lab_tests WHERE slug = 'ca-125' AND @niksic IS NOT NULL;

-- ── Клиника 88: Z02071 в её прайсе — «BNP»

UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'bnp')
 WHERE clinic_id = @danilo AND code = 'Z02071' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'pro-bnp');

COMMIT;

-- ── Проверка: каждая строка — на анализе из правой колонки (23 строки)
SELECT c.clinic_id, c.code, c.price, l.slug
  FROM clinic_lab_tests c JOIN lab_tests l ON l.id = c.lab_test_id
 WHERE (c.clinic_id = @niksic AND c.code IN ('K03091', 'K03092', 'K03093', 'K03094', 'K03095', 'K03096', 'K03097', 'K03098', 'K03099', 'K03100',
                                         'K03124', 'K03127', 'K03128', 'K03136', 'K03137', 'K03141', 'K03144',
                                         'Z01100', 'Z01104', 'Z02021', 'Z02031', 'Z02081'))
    OR (c.clinic_id = @danilo AND c.code = 'Z02071')
 ORDER BY c.clinic_id, c.code;
