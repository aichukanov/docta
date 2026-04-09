-- Countries with translations (55 entries, 6 languages)
-- Generated: 2026-04-09T11:27:36.854Z
-- Source: data/med-translations/

SET NAMES utf8mb4;

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Austrija', 'Austria', 'Austrija', 'Аустрија', 'Австрия', 'Österreich', 'Avusturya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Belgija', 'Belgium', 'Belgija', 'Белгија', 'Бельгия', 'Belgien', 'Belçika')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('BiH', 'Bosnia and Herzegovina', 'BiH', 'БиХ', 'Босния и Герцеговина', 'Bosnien und Herzegowina', 'Bosna Hersek')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Bosna i Hercegovina', 'Bosnia and Herzegovina', 'Bosna i Hercegovina', 'Босна и Херцеговина', 'Босния и Герцеговина', 'Bosnien und Herzegowina', 'Bosna Hersek')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Bugarska', 'Bulgaria', 'Bugarska', 'Бугарска', 'Болгария', 'Bulgarien', 'Bulgaristan')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Crna Gora', 'Montenegro', 'Crna Gora', 'Црна Гора', 'Черногория', 'Montenegro', 'Karadağ')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Danska', 'Denmark', 'Danska', 'Данска', 'Дания', 'Dänemark', 'Danimarka')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Finska', 'Finland', 'Finska', 'Финска', 'Финляндия', 'Finnland', 'Finlandiya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Francuska', 'France', 'Francuska', 'Француска', 'Франция', 'Frankreich', 'Fransa')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Grčka', 'Greece', 'Grčka', 'Грчка', 'Греция', 'Griechenland', 'Yunanistan')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Holandija', 'Netherlands', 'Holandija', 'Холандија', 'Нидерланды', 'Niederlande', 'Hollanda')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Hrvatska', 'Croatia', 'Hrvatska', 'Хрватска', 'Хорватия', 'Kroatien', 'Hırvatistan')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Irska', 'Ireland', 'Irska', 'Ирска', 'Ирландия', 'Irland', 'İrlanda')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Island', 'Iceland', 'Island', 'Исланд', 'Исландия', 'Island', 'İzlanda')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Italija', 'Italy', 'Italija', 'Италија', 'Италия', 'Italien', 'İtalya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Italija.', 'Italy', 'Italija', 'Италија', 'Италия', 'Italien', 'İtalya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Izrael', 'Israel', 'Izrael', 'Израел', 'Израиль', 'Israel', 'İsrail')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Kanada', 'Canada', 'Kanada', 'Канада', 'Канада', 'Kanada', 'Kanada')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Kipar', 'Cyprus', 'Kipar', 'Кипар', 'Кипр', 'Zypern', 'Kıbrıs')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Koreja', 'South Korea', 'Koreja', 'Кореја', 'Южная Корея', 'Südkorea', 'Güney Kore')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Letonija', 'Latvia', 'Letonija', 'Летонија', 'Латвия', 'Lettland', 'Letonya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Litvanija', 'Lithuania', 'Litvanija', 'Литванија', 'Литва', 'Litauen', 'Litvanya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Madjarska', 'Hungary', 'Mađarska', 'Мађарска', 'Венгрия', 'Ungarn', 'Macaristan')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Makedonija', 'North Macedonia', 'Makedonija', 'Македонија', 'Северная Македония', 'Nordmazedonien', 'Kuzey Makedonya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Malta', 'Malta', 'Malta', 'Малта', 'Мальта', 'Malta', 'Malta')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Mađarska', 'Hungary', 'Mađarska', 'Мађарска', 'Венгрия', 'Ungarn', 'Macaristan')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Njemačka', 'Germany', 'Njemačka', 'Њемачка', 'Германия', 'Deutschland', 'Almanya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Njemačka.', 'Germany', 'Njemačka', 'Њемачка', 'Германия', 'Deutschland', 'Almanya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Norveška', 'Norway', 'Norveška', 'Норвешка', 'Норвегия', 'Norwegen', 'Norveç')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Poljska', 'Poland', 'Poljska', 'Пољска', 'Польша', 'Polen', 'Polonya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Portugalija', 'Portugal', 'Portugalija', 'Португалија', 'Португалия', 'Portugal', 'Portekiz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Republika Severna Makedonija', 'North Macedonia', 'Republika Severna Makedonija', 'Република Северна Македонија', 'Северная Македония', 'Nordmazedonien', 'Kuzey Makedonya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Republika Sjeverna Makedonija', 'North Macedonia', 'Republika Sjeverna Makedonija', 'Република Сјеверна Македонија', 'Северная Македония', 'Nordmazedonien', 'Kuzey Makedonya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rumunija', 'Romania', 'Rumunija', 'Румунија', 'Румыния', 'Rumänien', 'Romanya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Ruska Federacija', 'Russian Federation', 'Ruska Federacija', 'Руска Федерација', 'Российская Федерация', 'Russische Föderation', 'Rusya Federasyonu')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('SAD', 'United States', 'SAD', 'САД', 'США', 'Vereinigte Staaten', 'ABD')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Severna Makedonija', 'North Macedonia', 'Severna Makedonija', 'Северна Македонија', 'Северная Македония', 'Nordmazedonien', 'Kuzey Makedonya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Slovačka', 'Slovakia', 'Slovačka', 'Словачка', 'Словакия', 'Slowakei', 'Slovakya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Slovenija', 'Slovenia', 'Slovenija', 'Словенија', 'Словения', 'Slowenien', 'Slovenya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Srbija', 'Serbia', 'Srbija', 'Србија', 'Сербия', 'Serbien', 'Sırbistan')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Srbija.', 'Serbia', 'Srbija', 'Србија', 'Сербия', 'Serbien', 'Sırbistan')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Svedska', 'Sweden', 'Švedska', 'Шведска', 'Швеция', 'Schweden', 'İsveç')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Turska', 'Turkey', 'Turska', 'Турска', 'Турция', 'Türkei', 'Türkiye')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('UK', 'United Kingdom', 'Velika Britanija', 'Велика Британија', 'Великобритания', 'Vereinigtes Königreich', 'Birleşik Krallık')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Velika Britanija', 'United Kingdom', 'Velika Britanija', 'Велика Британија', 'Великобритания', 'Vereinigtes Königreich', 'Birleşik Krallık')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Češka', 'Czech Republic', 'Češka', 'Чешка', 'Чехия', 'Tschechien', 'Çekya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Češka Republika', 'Czech Republic', 'Češka Republika', 'Чешка Република', 'Чехия', 'Tschechien', 'Çekya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Španija', 'Spain', 'Španija', 'Шпанија', 'Испания', 'Spanien', 'İspanya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Švajcarska', 'Switzerland', 'Švajcarska', 'Швајцарска', 'Швейцария', 'Schweiz', 'İsviçre')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Švedska', 'Sweden', 'Švedska', 'Шведска', 'Швеция', 'Schweden', 'İsveç')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('HEMOMONT d.o.o. Crna Gora', 'Montenegro', 'Crna Gora', 'Црна Гора', 'Черногория', 'Montenegro', 'Karadağ')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('KG Njemačka', 'Germany', 'Njemačka', 'Њемачка', 'Германия', 'Deutschland', 'Almanya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Sanofi-Aventis Deutschland GmbH Njemačka', 'Germany', 'Njemačka', 'Њемачка', 'Германия', 'Deutschland', 'Almanya')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Vršac', 'Serbia', 'Srbija', 'Србија', 'Сербия', 'Serbien', 'Sırbistan')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_countries` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Zdravlje A.D. Leskovac', 'Serbia', 'Srbija', 'Србија', 'Сербия', 'Serbien', 'Sırbistan')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);
