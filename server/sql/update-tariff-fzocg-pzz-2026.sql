-- FZOCG PZZ (cjenovnik od 01.05.2026): fixes against the PDF, 2026-10-02
-- Not a new edition. The PZZ pricelist DZ Podgorica posted in 2026-04
-- (dzpg.me/.../Cijenovnik-PZZ-2026-1.pdf) is byte-identical to the one already
-- loaded (SHA-256 4f006d7a...2808). What this file fixes is our own import of it:
--   * H01 block (psychiatrist, page 13): PaddleOCR put each price on the row
--     above, and merge_to_final.py preferred the OCR price over the correct LLM
--     one. 19 of 23 prices are wrong (H01006/09/21/23 match by coincidence).
--   * D17003 (page 11): LLM-only row, it took the price of D17004.
--   * 5 LLM-only names that do not match the PDF.
-- Each UPDATE is guarded by the old value: re-running it is a no-op, and a row
-- that already differs from what we expect is left alone.
-- Expected: 20 + 5 rows changed. Codes are unchanged, no relink needed.
-- Report: data/fzocg/pzz-2026-diff.md. The same edits are in the PZZ FINAL.json.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- prices (20)
UPDATE `medical_service_tariffs` SET `price_eur` = 32.50 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'D17003' AND `price_eur` = 38.15;
UPDATE `medical_service_tariffs` SET `price_eur` = 28.15 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01001' AND `price_eur` = 18.77;
UPDATE `medical_service_tariffs` SET `price_eur` = 18.77 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01002' AND `price_eur` = 9.38;
UPDATE `medical_service_tariffs` SET `price_eur` = 9.38 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01003' AND `price_eur` = 18.77;
UPDATE `medical_service_tariffs` SET `price_eur` = 18.77 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01004' AND `price_eur` = 28.15;
UPDATE `medical_service_tariffs` SET `price_eur` = 28.15 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01005' AND `price_eur` = 75.07;
UPDATE `medical_service_tariffs` SET `price_eur` = 75.07 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01007' AND `price_eur` = 56.30;
UPDATE `medical_service_tariffs` SET `price_eur` = 56.30 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01008' AND `price_eur` = 37.54;
UPDATE `medical_service_tariffs` SET `price_eur` = 37.54 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01010' AND `price_eur` = 31.28;
UPDATE `medical_service_tariffs` SET `price_eur` = 31.28 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01011' AND `price_eur` = 9.38;
UPDATE `medical_service_tariffs` SET `price_eur` = 9.38 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01012' AND `price_eur` = 56.30;
UPDATE `medical_service_tariffs` SET `price_eur` = 56.30 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01013' AND `price_eur` = 28.15;
UPDATE `medical_service_tariffs` SET `price_eur` = 28.15 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01014' AND `price_eur` = 18.77;
UPDATE `medical_service_tariffs` SET `price_eur` = 18.77 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01015' AND `price_eur` = 50.05;
UPDATE `medical_service_tariffs` SET `price_eur` = 50.05 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01016' AND `price_eur` = 31.28;
UPDATE `medical_service_tariffs` SET `price_eur` = 31.28 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01017' AND `price_eur` = 15.64;
UPDATE `medical_service_tariffs` SET `price_eur` = 15.64 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01018' AND `price_eur` = 8.83;
UPDATE `medical_service_tariffs` SET `price_eur` = 8.83 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01019' AND `price_eur` = 75.07;
UPDATE `medical_service_tariffs` SET `price_eur` = 75.07 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01020' AND `price_eur` = 9.38;
UPDATE `medical_service_tariffs` SET `price_eur` = 9.38 WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'H01022' AND `price_eur` = 18.77;

-- names (5)
UPDATE `medical_service_tariffs` SET `name_sr_latin` = 'Laboratorijska izrada mobilnog ortodontskog aparata sa pet ili više elemenata pored baze izrađenog bez konstrukc. zagriza' WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'D17005' AND `name_sr_latin` = 'Laboratorijska izrada mobilnog ortodontskog aparata bez konstr. zagriza sa pet ili više elemenata pored baze izrađenog na podlozi konstr. zagriza';
UPDATE `medical_service_tariffs` SET `name_sr_latin` = 'Laboratorijska izrada livene nadogradnje' WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'D18001' AND `name_sr_latin` = 'Laboratorijska izrada livene metalne krunice';
UPDATE `medical_service_tariffs` SET `name_sr_latin` = 'Laboratorijska izrada fasetiranog međučlana' WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'D18005' AND `name_sr_latin` = 'Laboratorijska izrada livene fasetiranog međučlana';
UPDATE `medical_service_tariffs` SET `name_sr_latin` = 'Laboratorijska izrada totalne zubne proteze s metalnom bazom' WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'D18010' AND `name_sr_latin` = 'Laboratorijska izrada totalne polimer proteze s metalnom bazom';
UPDATE `medical_service_tariffs` SET `name_sr_latin` = 'Mikroskopski pregled perianalnog otiska (ljepljivim celofanom)' WHERE `tariff_source` = 'fzocg-pzz' AND `code` = 'K01051' AND `name_sr_latin` = 'Mikroskopski pregled stolice na helminte (ljepljivim celofanom)';

SELECT `code`, `price_eur`, `name_sr_latin` FROM `medical_service_tariffs`
WHERE `tariff_source` = 'fzocg-pzz'
  AND (`code` LIKE 'H01%' OR `code` IN ('D17003', 'D17005', 'D18001', 'D18005', 'D18010', 'K01051'))
ORDER BY `code`;
