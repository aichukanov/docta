-- ═══════════════════════════════════════════════════════════════════════════
-- Moj Lab: спорные позиции перечня анализов → 9 лабораторий, по правилам A–F (2026-10-02)
-- Применять ПОСЛЕ insert-clinic-lab-tests-moj-lab-2026-10.sql и
-- migrations/050-labtest-dedup-moj-lab.sql (ни одна цель здесь не сливается в 050,
-- так что порядок между ними не критичен, но так файл проверялся).
--
-- Правила утверждены юзером 2026-10-02:
--   A — материал не указан → металлы в крови/сыворотке, моча → существующая запись по моче
--   B — дубль каталога → основная запись пары
--   C — каталог детальнее сайта → все составляющие
--   D — класс/метод не указан, в каталоге одна запись → она
--   E — огрех разметки сайта
--   F — генетика без объёма, исключение: STD-панель из 6 возбудителей
--
-- 65 строк сайта → 64 записей lab_tests. Новые записи (26 шт.)
-- и отброшенные огрехи (4 шт.) — в data/clinic-imports/moj-lab-labtests-2026-10.md.
-- Цен нет — price NULL. Идемпотентно (INSERT IGNORE по UNIQUE). Только по slug.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

START TRANSACTION;

DROP TEMPORARY TABLE IF EXISTS tmp_mojlab_labs;
CREATE TEMPORARY TABLE tmp_mojlab_labs (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY
);
INSERT INTO tmp_mojlab_labs VALUES
('moj-lab-laboratorija-podgorica-moskovska'),
('moj-lab-laboratorija-city-kvart'),
('moj-lab-laboratorija-budva'),
('moj-lab-laboratorija-ulcinj'),
('moj-lab-laboratorija-cetinje'),
('moj-lab-laboratorija-herceg-novi'),
('moj-lab-laboratorija-kotor'),
('moj-lab-laboratorija-niksic'),
('moj-lab-laboratorija-tivat');

DROP TEMPORARY TABLE IF EXISTS tmp_mojlab_tests;
CREATE TEMPORARY TABLE tmp_mojlab_tests (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	source_name VARCHAR(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	rule_applied VARCHAR(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
);
-- (lab_tests.slug, дословная строка сайта, правило)
INSERT INTO tmp_mojlab_tests VALUES
('allergies', 'Alergen (pojedinačno)', 'D'),
('allergies-20-allergens', 'Nutritivni panel 20 alergena ; Inhalatorni panel 20 alergena', 'D'),
('anti-gad-antibodies', 'Anti GAD (glitamat dekarboksilaza) antitijela', 'B'),
('aquaporin-4-antibodies', 'Anti aquaporin IgG', 'D'),
('arsenic-in-serum', 'Arsen', 'A'),
('bordetella-pertussis-igg', 'Bordetella pertussis tokson IgG', 'D'),
('c1-inactivator', 'Anti C1q esteraza inhibitor', 'D'),
('c1-inhibitor', 'C1q esteraza, koncentracija', 'D'),
('campylobacter-culture', 'Campylobacter spp', 'D'),
('candida-igm-antibodies', 'Candida albicans IgM', 'D'),
('catecholamines-in-24h-urine', 'Kateholamini u urinu', 'A'),
('chromium-in-blood', 'Hrom', 'A'),
('citrate-in-24h-urine', 'Citrati u urinu', 'A'),
('clostridium-difficile-toxin-a-and-b', 'Clostridium difficile Toxin A/B (imunohromatografija)', 'B'),
('cobalt-in-serum', 'Kobalt', 'A'),
('complete-urinalysis', 'Fizičko-hemijski pregled urina', 'D'),
('copper-in-serum', 'Bakar', 'A'),
('coproporphyrins', 'Koproporfirin u urinu', 'A'),
('creatinine', 'Kreatinin (GFR)', 'C'),
('diamine-oxidase', 'Diamino oksidaza (DAO)', 'D'),
('drug-panel-10', 'Panel 10 (kokain, amfetamin, metamfetamin, kanabinoidi, metadon, extazi, barbiturati, benzodiazempin, TCA)', 'D'),
('egfr-glomerular-filtration-rate', 'Kreatinin (GFR)', 'C'),
('free-estriol', 'Estriol (E3)', 'D'),
('free-kappa-light-chains-in-urine', 'Slobodni kapa/lambda lanci u urinu', 'C'),
('free-lambda-light-chains-in-urine', 'Slobodni kapa/lambda lanci u urinu', 'C'),
('hcv-pcr-rna-quantitative', 'Hepatitis C virus RNK', 'D'),
('her2-estrogen-progesterone-receptors', 'Komplet receptori za dojku', 'D'),
('histopathology-conization-specimen', 'Pregled LOOP ekscizije', 'D'),
('histopathology-endoscopic-biopsy', 'Endoskopska biopsija 1 uzorak (jednjak, želudac, duodenum, tanko i debelo crijevo)', 'C'),
('histopathology-tur-bladder', 'Pregled tumora mokraćne bešike', 'D'),
('hla-dq2-dq8-typing', 'HLA DQ', 'B'),
('homovanillic-acid-in-urine', 'Homovanilična kisjelina (HVA)', 'A'),
('iodine-in-serum', 'Jod', 'A'),
('kappa-lambda-light-chain-index', 'Slobodni kapa/lambda lanci u serumu', 'C'),
('kappa-light-chain', 'Slobodni kapa/lambda lanci u serumu', 'C'),
('lambda-light-chain', 'Slobodni kapa/lambda lanci u serumu', 'C'),
('lead-in-blood', 'Olovo', 'A'),
('leishmania-igg-igm', 'Leishmania antitijela srining', 'D'),
('manganese-in-blood', 'Mangan', 'A'),
('mercury-in-blood', 'Živa', 'A'),
('nail-scraping-fungi', 'Strugotina nokta', 'D'),
('neuronal-antibodies', 'Neuronalna antitijela osnovni panel (Hu, Ri, Yo, Ma-2, CV-2, Amfifizin1) Neuralna antitijela panel (Amphiphysin 1, ANNA-III, CV-2, Ri antigen, Yo, Hu Dantigen, Ma2 (Ta), PCA-2, Tr ) u serumu', 'D'),
('nickel-in-serum', 'Nikl', 'A'),
('nmdar-antibodies-in-serum', 'Anti NMDA receptor IgG', 'D'),
('omega-6-omega-3-fatty-acids', 'LDH Izoenzimi Omega3/6 index u eritrocitima', 'E'),
('oxalate-in-24h-urine', 'Oksalati u urinu', 'A'),
('porphyrins-in-urine', 'Porfirin', 'A'),
('potassium-in-24h-urine', 'Urin - Kalijum', 'A'),
('rectal-swab-bacteria', 'Bris čmara na bakterije', 'D'),
('rectal-swab-fungi', 'Bris čmara na gljivice', 'D'),
('skin-scraping-fungi', 'Strugotina kože', 'D'),
('sodium-in-24h-urine', 'Urin - Natrijum', 'A'),
('spermatozoa-antibodies-asa', 'Anti spermatozoidna (ASA) IgG', 'D'),
('std-multiplex-6', 'STD panel (Mycoplasma hominis, Neisseria gonorrhoeae, Trichomonas vaginalis, Ureaplasma urealyticum, Ureaplasma parvum, Chlamydia trachomatis', 'F'),
('stool-culture', 'Koprokultura (Salmonela spp, Shigela spp, E. coli O157, Campylobacter spp)', 'D'),
('stool-parasites', 'Stolica na helminte', 'D'),
('tb-test', 'TBC (imunohromatografija)', 'D'),
('toxocara-canis-igm-antibodies', 'Toxocara canis-IgM, blot', 'D'),
('tracheoflex-swab-culture-aerobic', 'Bris traheostome na bakterije', 'D'),
('trichomonas-test', 'Bris na Trichomonas vaginalis', 'D'),
('vaginal-discharge-dmp', 'Vaginalni stepen', 'B'),
('vitamin-k1-level', 'Vitamin K', 'D'),
('vma-in-urine', 'VMA (24h sa konzervansom)', 'A'),
('zinc-in-serum', 'Cink', 'A');

-- Контроль: каждый slug анализа должен найтись (ожидается пусто)
SELECT t.slug AS missing_lab_test FROM tmp_mojlab_tests t LEFT JOIN lab_tests lt ON lt.slug = t.slug WHERE lt.id IS NULL;
-- Контроль: все 9 лабораторий должны найтись (ожидается пусто)
SELECT l.slug AS missing_clinic FROM tmp_mojlab_labs l LEFT JOIN clinics c ON c.slug = l.slug WHERE c.id IS NULL;

INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price)
SELECT c.id, lt.id, NULL
FROM tmp_mojlab_labs l
JOIN clinics c ON c.slug = l.slug
CROSS JOIN tmp_mojlab_tests t
JOIN lab_tests lt ON lt.slug = t.slug;

DROP TEMPORARY TABLE tmp_mojlab_tests;
DROP TEMPORARY TABLE tmp_mojlab_labs;

COMMIT;

-- ═══ VERIFICATION: число анализов у каждой из 9 лабораторий, with_price = 0 ═══
SELECT c.slug, COUNT(clt.id) AS lab_tests, SUM(clt.price IS NOT NULL) AS with_price
FROM clinics c
LEFT JOIN clinic_lab_tests clt ON clt.clinic_id = c.id
WHERE c.slug LIKE 'moj-lab-laboratorija-%'
GROUP BY c.slug
ORDER BY c.slug;
