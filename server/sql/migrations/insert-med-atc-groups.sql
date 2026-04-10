-- ATC therapeutic groups with translations (14 groups, 6 languages)
-- Generated: 2026-04-09T17:12:25.356Z
-- Source: data/med-translations/atc-groups.json

SET NAMES utf8mb4;

INSERT INTO `med_atc_groups` (code, name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('A', 'Alimentary tract and metabolism', 'Alimentary tract and metabolism', 'Alimentarni trakt i metabolizam', 'Алиментарни тракт и метаболизам', 'Пищеварительный тракт и обмен веществ', 'Alimentäres System und Stoffwechsel', 'Sindirim sistemi ve metabolizma')
ON DUPLICATE KEY UPDATE name=VALUES(name), name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_atc_groups` (code, name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('B', 'Blood and blood forming organs', 'Blood and blood forming organs', 'Krv i krvotvorni organi', 'Крв и крвотворни органи', 'Кроветворная система и кровь', 'Blut und blutbildende Organe', 'Kan ve kan yapıcı organlar')
ON DUPLICATE KEY UPDATE name=VALUES(name), name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_atc_groups` (code, name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('C', 'Cardiovascular system', 'Cardiovascular system', 'Kardiovaskularni sistem', 'Кардиоваскуларни систем', 'Сердечно-сосудистая система', 'Kardiovaskuläres System', 'Kardiyovasküler sistem')
ON DUPLICATE KEY UPDATE name=VALUES(name), name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_atc_groups` (code, name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('D', 'Dermatologicals', 'Dermatologicals', 'Dermatološki lijekovi', 'Дерматолошки лијекови', 'Дерматологические препараты', 'Dermatika', 'Dermatolojik ilaçlar')
ON DUPLICATE KEY UPDATE name=VALUES(name), name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_atc_groups` (code, name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('G', 'Genito-urinary system and sex hormones', 'Genito-urinary system and sex hormones', 'Genitourinarni sistem i polni hormoni', 'Генитоуринарни систем и полни хормони', 'Мочеполовая система и половые гормоны', 'Urogenitalsystem und Sexualhormone', 'Genitoüriner sistem ve cinsiyet hormonları')
ON DUPLICATE KEY UPDATE name=VALUES(name), name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_atc_groups` (code, name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('H', 'Systemic hormonal preparations', 'Systemic hormonal preparations', 'Sistemski hormonski preparati', 'Системски хормонски препарати', 'Гормональные препараты системного действия', 'Systemische Hormonpräparate', 'Sistemik hormonal preparatlar')
ON DUPLICATE KEY UPDATE name=VALUES(name), name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_atc_groups` (code, name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('J', 'Anti-infectives for systemic use', 'Anti-infectives for systemic use', 'Antiinfektivi za sistemsku primjenu', 'Антиинфективи за системску примјену', 'Противомикробные препараты для системного применения', 'Antiinfektiva zur systemischen Anwendung', 'Sistemik antiinfektifler')
ON DUPLICATE KEY UPDATE name=VALUES(name), name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_atc_groups` (code, name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('L', 'Antineoplastic and immunomodulating agents', 'Antineoplastic and immunomodulating agents', 'Antineoplastici i imunomodulatori', 'Антинеопластици и имуномодулатори', 'Противоопухолевые и иммуномодулирующие препараты', 'Antineoplastische und immunmodulierende Mittel', 'Antineoplastik ve immünomodülatör ajanlar')
ON DUPLICATE KEY UPDATE name=VALUES(name), name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_atc_groups` (code, name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('M', 'Musculo-skeletal system', 'Musculo-skeletal system', 'Mišićno-koštani sistem', 'Мишићно-коштани систем', 'Костно-мышечная система', 'Muskel- und Skelettsystem', 'Kas-iskelet sistemi')
ON DUPLICATE KEY UPDATE name=VALUES(name), name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_atc_groups` (code, name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('N', 'Nervous system', 'Nervous system', 'Nervni sistem', 'Нервни систем', 'Нервная система', 'Nervensystem', 'Sinir sistemi')
ON DUPLICATE KEY UPDATE name=VALUES(name), name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_atc_groups` (code, name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('P', 'Antiparasitic products', 'Antiparasitic products', 'Antiparazitici', 'Антипаразитици', 'Противопаразитарные препараты', 'Antiparasitäre Mittel', 'Antiparaziter ürünler')
ON DUPLICATE KEY UPDATE name=VALUES(name), name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_atc_groups` (code, name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('R', 'Respiratory system', 'Respiratory system', 'Respiratorni sistem', 'Респираторни систем', 'Дыхательная система', 'Respirationstrakt', 'Solunum sistemi')
ON DUPLICATE KEY UPDATE name=VALUES(name), name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_atc_groups` (code, name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('S', 'Sensory organs', 'Sensory organs', 'Čulni organi', 'Чулни органи', 'Органы чувств', 'Sinnesorgane', 'Duyu organları')
ON DUPLICATE KEY UPDATE name=VALUES(name), name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_atc_groups` (code, name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('V', 'Various', 'Various', 'Razni', 'Разни', 'Прочие препараты', 'Verschiedene', 'Çeşitli')
ON DUPLICATE KEY UPDATE name=VALUES(name), name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);
