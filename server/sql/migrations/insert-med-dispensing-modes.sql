-- Dispensing modes with translations (9 modes, 6 languages)
-- Generated: 2026-04-09T17:12:25.355Z
-- Source: data/med-translations/

SET NAMES utf8mb4;

INSERT INTO `med_dispensing_modes` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Lijek se izdaje samo na ljekarski recept', 'Prescription only', 'Lijek se izdaje samo na ljekarski recept', 'Лијек се издаје само на љекарски рецепт', 'Только по рецепту врача', 'Verschreibungspflichtig', 'Yalnızca reçete ile')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_dispensing_modes` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Lijek se može izdavati bez ljekarskog recepta', 'Over-the-counter (OTC)', 'Lijek se može izdavati bez ljekarskog recepta', 'Лијек се може издавати без љекарског рецепта', 'Без рецепта', 'Rezeptfrei', 'Reçetesiz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_dispensing_modes` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Lijek se može upotrebljavati samo u stacionarnoj zdravstvenoj ustanovi', 'Hospital use only (inpatient)', 'Lijek se može upotrebljavati samo u stacionarnoj zdravstvenoj ustanovi', 'Лијек се може употребљавати само у стационарној здравственој установи', 'Только в условиях стационара', 'Nur für den stationären Gebrauch', 'Yalnızca yataklı tedavi kurumlarında')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_dispensing_modes` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Lijek se može upotrebljavati u stacionarnoj zdravstvenoj ustanovi; Izuzetno na recept', 'Hospital use; exceptionally by prescription', 'Lijek se može upotrebljavati u stacionarnoj zdravstvenoj ustanovi; Izuzetno na recept', 'Лијек се може употребљавати у стационарној здравственој установи; Изузетно на рецепт', 'В условиях стационара; в исключительных случаях — по рецепту', 'Stationär; ausnahmsweise auf Rezept', 'Yataklı tedavi kurumlarında; istisnai olarak reçete ile')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_dispensing_modes` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Lijek se može upotrebljavati u zdravstvenoj ustanovi', 'Healthcare facility use only', 'Lijek se može upotrebljavati u zdravstvenoj ustanovi', 'Лијек се може употребљавати у здравственој установи', 'Только в медицинском учреждении', 'Nur in Gesundheitseinrichtungen', 'Yalnızca sağlık kuruluşlarında')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_dispensing_modes` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Neobnovljiv (jednokratni) recept', 'Non-renewable (single-use) prescription', 'Neobnovljiv (jednokratni) recept', 'Необновљив (једнократни) рецепт', 'Однократный рецепт (без продления)', 'Nicht verlängerbares Rezept (einmalig)', 'Yenilenemez (tek kullanımlık) reçete')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_dispensing_modes` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Obnovljiv (višekratni) recept', 'Renewable (repeat) prescription', 'Obnovljiv (višekratni) recept', 'Обновљив (вишекратни) рецепт', 'Многократный рецепт (с продлением)', 'Verlängerbares Rezept (wiederholbar)', 'Yenilenebilir (tekrarlı) reçete')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_dispensing_modes` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Ograničen recept', 'Restricted prescription', 'Ograničen recept', 'Ограничен рецепт', 'Рецепт ограниченного отпуска', 'Eingeschränktes Rezept', 'Kısıtlı reçete')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_dispensing_modes` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Poseban recept', 'Special prescription', 'Poseban recept', 'Посебан рецепт', 'Специальный рецепт', 'Sonderrezept', 'Özel reçete')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);
