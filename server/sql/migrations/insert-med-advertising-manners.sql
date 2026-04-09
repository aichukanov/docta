-- Advertising manners with translations (2 entries, 6 languages)
-- Generated: 2026-04-09T11:27:36.856Z
-- Source: data/med-translations/

SET NAMES utf8mb4;

INSERT INTO `med_advertising_manners` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Promocija namijenjena opštoj javnosti', 'Advertising to general public', 'Promocija namijenjena opštoj javnosti', 'Промоција намијењена општој јавности', 'Реклама для широкой публики', 'Werbung für die Allgemeinheit', 'Halka açık tanıtım')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_advertising_manners` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Promocija namijenjena stručnoj javnosti', 'Advertising to healthcare professionals', 'Promocija namijenjena stručnoj javnosti', 'Промоција намијењена стручној јавности', 'Реклама для специалистов здравоохранения', 'Werbung für Fachkreise', 'Sağlık profesyonellerine yönelik tanıtım')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);
