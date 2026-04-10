-- Pharmaceutical forms with translations (148 forms, 6 languages)
-- Generated: 2026-04-10T07:24:41.430Z
-- Source: data/med-translations/

SET NAMES utf8mb4;

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('BEZ ŠEĆERA', 'Sugar-free', 'Bez šećera', 'Без шећера', 'Без сахара', 'Zuckerfrei', 'Şekersiz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Disperzibilna tableta', 'Dispersible tablet', 'Disperzibilna tableta', 'Дисперзибилна таблета', 'Диспергируемая таблетка', 'Dispergierbare Tablette', 'Dağılabilir tablet')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Disperzija za injekciju', 'Dispersion for injection', 'Disperzija za injekciju', 'Дисперзија за ињекцију', 'Дисперсия для инъекций', 'Dispersion zur Injektion', 'Enjeksiyonluk dispersiyon')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Emulzija za infuziju', 'Emulsion for infusion', 'Emulzija za infuziju', 'Емулзија за инфузију', 'Эмульсия для инфузий', 'Emulsion zur Infusion', 'İnfüzyonluk emülsiyon')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Emulzija za injekciju/infuziju', 'Emulsion for injection/infusion', 'Emulzija za injekciju/infuziju', 'Емулзија за ињекцију/инфузију', 'Эмульсия для инъекций/инфузий', 'Emulsion zur Injektion/Infusion', 'Enjeksiyon/infüzyonluk emülsiyon')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Film tableta', 'Film-coated tablet', 'Film tableta', 'Филм таблета', 'Таблетка, покрытая плёночной оболочкой', 'Filmtablette', 'Film kaplı tablet')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Film tableta sa modifikovanim oslobađanjem', 'Modified-release film-coated tablet', 'Film tableta sa modifikovanim oslobađanjem', 'Филм таблета са модификованим ослобађањем', 'Таблетка, покрытая плёночной оболочкой, с модифицированным высвобождением', 'Filmtablette mit veränderter Wirkstofffreisetzung', 'Değiştirilmiş salımlı film kaplı tablet')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Gastrorezistentna kapsula, tvrda', 'Gastro-resistant capsule, hard', 'Gastrorezistentna kapsula, tvrda', 'Гастрорезистентна капсула, тврда', 'Капсула кишечнорастворимая, твёрдая', 'Magensaftresistente Hartkapsel', 'Mide asidine dayanıklı sert kapsül')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Gastrorezistentna tableta', 'Gastro-resistant tablet', 'Gastrorezistentna tableta', 'Гастрорезистентна таблета', 'Таблетка кишечнорастворимая', 'Magensaftresistente Tablette', 'Mide asidine dayanıklı tablet')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Gel', 'Gel', 'Gel', 'Гел', 'Гель', 'Gel', 'Jel')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Gel za oči', 'Eye gel', 'Gel za oči', 'Гел за очи', 'Гель для глаз', 'Augengel', 'Göz jeli')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Granule', 'Granules', 'Granule', 'Грануле', 'Гранулы', 'Granulat', 'Granül')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Granule u kapsulama za otvaranje', 'Granules in capsules for opening', 'Granule u kapsulama za otvaranje', 'Грануле у капсулама за отварање', 'Гранулы в капсулах для вскрытия', 'Granulat in Kapseln zum Öffnen', 'Açılabilir kapsüllerde granül')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Granule za oralni rastvor', 'Granules for oral solution', 'Granule za oralni rastvor', 'Грануле за орални раствор', 'Гранулы для приготовления раствора для приёма внутрь', 'Granulat zur Herstellung einer Lösung zum Einnehmen', 'Oral çözelti için granül')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Granule za oralnu suspenziju', 'Granules for oral suspension', 'Granule za oralnu suspenziju', 'Грануле за оралну суспензију', 'Гранулы для приготовления суспензии для приёма внутрь', 'Granulat zur Herstellung einer Suspension zum Einnehmen', 'Oral süspansiyon için granül')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Implant u napunjenom injekcionom špricu', 'Implant in pre-filled syringe', 'Implant u napunjenom injekcionom špricu', 'Имплант у напуњеном ињекционом шприцу', 'Имплантат в предварительно заполненном шприце', 'Implantat in einer Fertigspritze', 'Önceden doldurulmuş enjektörde implant')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Intrauterini dostavni sistem', 'Intrauterine delivery system', 'Intrauterini dostavni sistem', 'Интраутерини доставни систем', 'Внутриматочная терапевтическая система', 'Intrauterines Wirkstofffreisetzungssystem', 'Rahim içi ilaç salım sistemi')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Kapi za nos, rastvor', 'Nasal drops, solution', 'Kapi za nos, rastvor', 'Капи за нос, раствор', 'Капли назальные, раствор', 'Nasentropfen, Lösung', 'Burun damlası, çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Kapi za oči, rastvor', 'Eye drops, solution', 'Kapi za oči, rastvor', 'Капи за очи, раствор', 'Капли глазные, раствор', 'Augentropfen, Lösung', 'Göz damlası, çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Kapi za oči, suspenzija', 'Eye drops, suspension', 'Kapi za oči, suspenzija', 'Капи за очи, суспензија', 'Капли глазные, суспензия', 'Augentropfen, Suspension', 'Göz damlası, süspansiyon')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Kapi za uši, rastvor', 'Ear drops, solution', 'Kapi za uši, rastvor', 'Капи за уши, раствор', 'Капли ушные, раствор', 'Ohrentropfen, Lösung', 'Kulak damlası, çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Kapi za uši, rastvor u jednodoznom kontejneru', 'Ear drops, solution in single-dose container', 'Kapi za uši, rastvor u jednodoznom kontejneru', 'Капи за уши, раствор у једнодозном контејнеру', 'Капли ушные, раствор в однодозовом контейнере', 'Ohrentropfen, Lösung im Einzeldosisbehältnis', 'Tek dozluk kapta kulak damlası, çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Kapi za uši/oči, rastvor', 'Ear/eye drops, solution', 'Kapi za uši/oči, rastvor', 'Капи за уши/очи, раствор', 'Капли ушные/глазные, раствор', 'Ohren-/Augentropfen, Lösung', 'Kulak/göz damlası, çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Kapsula', 'Capsule', 'Kapsula', 'Капсула', 'Капсула', 'Kapsel', 'Kapsül')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Kapsula sa modifikovanim oslobađanjem, tvrda', 'Modified-release capsule, hard', 'Kapsula sa modifikovanim oslobađanjem, tvrda', 'Капсула са модификованим ослобађањем, тврда', 'Капсула с модифицированным высвобождением, твёрдая', 'Hartkapsel mit veränderter Wirkstofffreisetzung', 'Değiştirilmiş salımlı sert kapsül')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Kapsula sa produženim oslobađanjem, tvrda', 'Prolonged-release capsule, hard', 'Kapsula sa produženim oslobađanjem, tvrda', 'Капсула са продуженим ослобађањем, тврда', 'Капсула с пролонгированным высвобождением, твёрдая', 'Hartkapsel mit verlängerter Wirkstofffreisetzung', 'Uzatılmış salımlı sert kapsül')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Kapsula, meka', 'Capsule, soft', 'Kapsula, meka', 'Капсула, мека', 'Капсула мягкая', 'Weichkapsel', 'Yumuşak kapsül')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Kapsula, tvrda', 'Capsule, hard', 'Kapsula, tvrda', 'Капсула, тврда', 'Капсула твёрдая', 'Hartkapsel', 'Sert kapsül')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Komprimovana lozenga', 'Compressed lozenge', 'Komprimovana lozenga', 'Компримована лозенга', 'Пастилка прессованная', 'Lutschtablette', 'Sıkıştırılmış pastil')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Koncentrat i rastvarač za rastvor za infuziju', 'Concentrate and solvent for solution for infusion', 'Koncentrat i rastvarač za rastvor za infuziju', 'Концентрат и растварач за раствор за инфузију', 'Концентрат и растворитель для приготовления раствора для инфузий', 'Konzentrat und Lösungsmittel zur Herstellung einer Infusionslösung', 'İnfüzyonluk çözelti için konsantre ve çözücü')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Koncentrat za disperziju za infuziju', 'Concentrate for dispersion for infusion', 'Koncentrat za disperziju za infuziju', 'Концентрат за дисперзију за инфузију', 'Концентрат для приготовления дисперсии для инфузий', 'Konzentrat zur Herstellung einer Infusionsdispersion', 'İnfüzyonluk dispersiyon için konsantre')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Koncentrat za disperziju za injekciju', 'Concentrate for dispersion for injection', 'Koncentrat za disperziju za injekciju', 'Концентрат за дисперзију за ињекцију', 'Концентрат для приготовления дисперсии для инъекций', 'Konzentrat zur Herstellung einer Injektionsdispersion', 'Enjeksiyonluk dispersiyon için konsantre')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Koncentrat za oralni rastvor', 'Concentrate for oral solution', 'Koncentrat za oralni rastvor', 'Концентрат за орални раствор', 'Концентрат для приготовления раствора для приёма внутрь', 'Konzentrat zur Herstellung einer Lösung zum Einnehmen', 'Oral çözelti için konsantre')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Koncentrat za rastvor za infuziju', 'Concentrate for solution for infusion', 'Koncentrat za rastvor za infuziju', 'Концентрат за раствор за инфузију', 'Концентрат для приготовления раствора для инфузий', 'Konzentrat zur Herstellung einer Infusionslösung', 'İnfüzyonluk çözelti için konsantre')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Koncentrat za rastvor za injekciju/infuziju', 'Concentrate for solution for injection/infusion', 'Koncentrat za rastvor za injekciju/infuziju', 'Концентрат за раствор за ињекцију/инфузију', 'Концентрат для приготовления раствора для инъекций/инфузий', 'Konzentrat zur Herstellung einer Injektions-/Infusionslösung', 'Enjeksiyon/infüzyonluk çözelti için konsantre')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Krem', 'Cream', 'Krem', 'Крем', 'Крем', 'Creme', 'Krem')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Liofilizat za rastvor za infuziju', 'Powder (lyophilisate) for solution for infusion', 'Liofilizat za rastvor za infuziju', 'Лиофилизат за раствор за инфузију', 'Лиофилизат для приготовления раствора для инфузий', 'Lyophilisat zur Herstellung einer Infusionslösung', 'İnfüzyonluk çözelti için liyofilizat')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Liofilizat za rastvor za injekciju sa rastvaračem za parenteralnu upotrebu', 'Lyophilisate for solution for injection with solvent for parenteral use', 'Liofilizat za rastvor za injekciju sa rastvaračem za parenteralnu upotrebu', 'Лиофилизат за раствор за ињекцију са растварачем за парентералну употребу', 'Лиофилизат для приготовления раствора для инъекций с растворителем для парентерального применения', 'Lyophilisat zur Herstellung einer Injektionslösung mit Lösungsmittel zur parenteralen Anwendung', 'Parenteral kullanım için çözücülü enjeksiyonluk çözelti liyofilizatı')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Ljekovita guma za žvakanje', 'Medicated chewing gum', 'Ljekovita guma za žvakanje', 'Љековита гума за жвакање', 'Жевательная резинка лекарственная', 'Medizinisches Kaugummi', 'Tıbbi çiklet')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Ljekoviti lak za nokte', 'Medicated nail lacquer', 'Ljekoviti lak za nokte', 'Љековити лак за нокте', 'Лак лекарственный для ногтей', 'Medizinischer Nagellack', 'Tıbbi tırnak cilası')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Lozenga', 'Lozenge', 'Lozenga', 'Лозенга', 'Пастилка', 'Lutschtablette', 'Pastil')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Mast', 'Ointment', 'Mast', 'Маст', 'Мазь', 'Salbe', 'Merhem')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Mast za oči', 'Eye ointment', 'Mast za oči', 'Маст за очи', 'Мазь глазная', 'Augensalbe', 'Göz merhemi')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Matriks sa lijepkom za tkivo', 'Matrix with tissue adhesive', 'Matriks sa lijepkom za tkivo', 'Матрикс са лијепком за ткиво', 'Матрица с тканевым клеем', 'Matrix mit Gewebekleber', 'Doku yapıştırıcılı matriks')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Medicinski gas, djelimično tečni', 'Medicinal gas, partly liquefied', 'Medicinski gas, djelimično tečni', 'Медицински гас, дјелимично течни', 'Газ медицинский, частично сжиженный', 'Medizinisches Gas, teilverflüssigt', 'Tıbbi gaz, kısmen sıvılaştırılmış')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Medicinski gas, komprimovani', 'Medicinal gas, compressed', 'Medicinski gas, komprimovani', 'Медицински гас, компримовани', 'Газ медицинский, сжатый', 'Medizinisches Gas, druckverdichtet', 'Tıbbi gaz, basınçlı')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Obložena tableta', 'Coated tablet', 'Obložena tableta', 'Обложена таблета', 'Таблетка, покрытая оболочкой', 'Überzogene Tablette', 'Kaplı tablet')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Oralna disperzibilna tableta', 'Orodispersible tablet', 'Oralna disperzibilna tableta', 'Орална дисперзибилна таблета', 'Таблетка диспергируемая в полости рта', 'Schmelztablette', 'Ağızda dağılan tablet')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Oralna suspenzija', 'Oral suspension', 'Oralna suspenzija', 'Орална суспензија', 'Суспензия для приёма внутрь', 'Suspension zum Einnehmen', 'Oral süspansiyon')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Oralne kapi, emulzija', 'Oral drops, emulsion', 'Oralne kapi, emulzija', 'Оралне капи, емулзија', 'Капли для приёма внутрь, эмульсия', 'Tropfen zum Einnehmen, Emulsion', 'Oral damla, emülsiyon')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Oralne kapi, rastvor', 'Oral drops, solution', 'Oralne kapi, rastvor', 'Оралне капи, раствор', 'Капли для приёма внутрь, раствор', 'Tropfen zum Einnehmen, Lösung', 'Oral damla, çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Oralni gel', 'Oromucosal gel', 'Oralni gel', 'Орални гел', 'Гель для полости рта', 'Gel zur Anwendung in der Mundhöhle', 'Oral jel')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Oralni liofilizat', 'Oral lyophilisate', 'Oralni liofilizat', 'Орални лиофилизат', 'Лиофилизат для приёма внутрь', 'Lyophilisat zum Einnehmen', 'Oral liyofilizat')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Oralni prašak', 'Oral powder', 'Oralni prašak', 'Орални прашак', 'Порошок для приёма внутрь', 'Pulver zum Einnehmen', 'Oral toz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Oralni rastvor', 'Oral solution', 'Oralni rastvor', 'Орални раствор', 'Раствор для приёма внутрь', 'Lösung zum Einnehmen', 'Oral çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Oralni rastvor/koncentrat za rastvor za raspršivanje', 'Oral solution/concentrate for nebuliser solution', 'Oralni rastvor/koncentrat za rastvor za raspršivanje', 'Орални раствор/концентрат за раствор за распршивање', 'Раствор для приёма внутрь/концентрат для приготовления раствора для ингаляций', 'Lösung zum Einnehmen/Konzentrat zur Herstellung einer Lösung für einen Vernebler', 'Oral çözelti/nebülizatör çözeltisi için konsantre')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Para za inhalaciju, tečnost', 'Vapour for inhalation, liquid', 'Para za inhalaciju, tečnost', 'Пара за инхалацију, течност', 'Пар для ингаляций, жидкость', 'Dampf zur Inhalation, Flüssigkeit', 'İnhalasyon buharı, sıvı')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Pastila', 'Pastille', 'Pastila', 'Пастила', 'Пастилка', 'Pastille', 'Pastil')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Pjena za kožu', 'Cutaneous foam', 'Pjena za kožu', 'Пјена за кожу', 'Пена для наружного применения', 'Schaum zur Anwendung auf der Haut', 'Deri köpüğü')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak i rastvarac za koncentrat za rastvor za infuziju', 'Powder and solvent for concentrate for solution for infusion', 'Prašak i rastvarač za koncentrat za rastvor za infuziju', 'Прашак и растварач за концентрат за раствор за инфузију', 'Порошок и растворитель для приготовления концентрата для раствора для инфузий', 'Pulver und Lösungsmittel zur Herstellung eines Konzentrats für eine Infusionslösung', 'İnfüzyonluk çözelti konsantresi için toz ve çözücü')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak i rastvarač za rastvor za infuziju', 'Powder and solvent for solution for infusion', 'Prašak i rastvarač za rastvor za infuziju', 'Прашак и растварач за раствор за инфузију', 'Порошок и растворитель для приготовления раствора для инфузий', 'Pulver und Lösungsmittel zur Herstellung einer Infusionslösung', 'İnfüzyonluk çözelti için toz ve çözücü')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak i rastvarač za rastvor za injekciju', 'Powder and solvent for solution for injection', 'Prašak i rastvarač za rastvor za injekciju', 'Прашак и растварач за раствор за ињекцију', 'Порошок и растворитель для приготовления раствора для инъекций', 'Pulver und Lösungsmittel zur Herstellung einer Injektionslösung', 'Enjeksiyonluk çözelti için toz ve çözücü')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak i rastvarač za rastvor za injekciju u napunjenom injekcionom penu', 'Powder and solvent for solution for injection in pre-filled pen', 'Prašak i rastvarač za rastvor za injekciju u napunjenom injekcionom penu', 'Прашак и растварач за раствор за ињекцију у напуњеном ињекционом пену', 'Порошок и растворитель для приготовления раствора для инъекций в предварительно заполненной шприц-ручке', 'Pulver und Lösungsmittel zur Herstellung einer Injektionslösung im Fertigpen', 'Önceden doldurulmuş kaleme enjeksiyonluk çözelti için toz ve çözücü')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak i rastvarač za rastvor za injekciju u penu sa uloškom', 'Powder and solvent for solution for injection in cartridge pen', 'Prašak i rastvarač za rastvor za injekciju u penu sa uloškom', 'Прашак и растварач за раствор за ињекцију у пену са улошком', 'Порошок и растворитель для приготовления раствора для инъекций в шприц-ручке с картриджем', 'Pulver und Lösungsmittel zur Herstellung einer Injektionslösung im Pen mit Patrone', 'Kartuşlu kalemde enjeksiyonluk çözelti için toz ve çözücü')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak i rastvarač za rastvor za injekciju/infuziju', 'Powder and solvent for solution for injection/infusion', 'Prašak i rastvarač za rastvor za injekciju/infuziju', 'Прашак и растварач за раствор за ињекцију/инфузију', 'Порошок и растворитель для приготовления раствора для инъекций/инфузий', 'Pulver und Lösungsmittel zur Herstellung einer Injektions-/Infusionslösung', 'Enjeksiyon/infüzyonluk çözelti için toz ve çözücü')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak i rastvarač za rastvor za kožu', 'Powder and solvent for cutaneous solution', 'Prašak i rastvarač za rastvor za kožu', 'Прашак и растварач за раствор за кожу', 'Порошок и растворитель для приготовления раствора для наружного применения', 'Pulver und Lösungsmittel zur Herstellung einer Lösung zur Anwendung auf der Haut', 'Deri çözeltisi için toz ve çözücü')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak i rastvarač za suspenziju za injekciju', 'Powder and solvent for suspension for injection', 'Prašak i rastvarač za suspenziju za injekciju', 'Прашак и растварач за суспензију за ињекцију', 'Порошок и растворитель для приготовления суспензии для инъекций', 'Pulver und Lösungsmittel zur Herstellung einer Injektionssuspension', 'Enjeksiyonluk süspansiyon için toz ve çözücü')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak i rastvarač za suspenziju za injekciju sa produženim oslobađanjem', 'Powder and solvent for prolonged-release suspension for injection', 'Prašak i rastvarač za suspenziju za injekciju sa produženim oslobađanjem', 'Прашак и растварач за суспензију за ињекцију са продуженим ослобађањем', 'Порошок и растворитель для приготовления суспензии для инъекций пролонгированного действия', 'Pulver und Lösungsmittel zur Herstellung einer Depot-Injektionssuspension', 'Uzatılmış salımlı enjeksiyonluk süspansiyon için toz ve çözücü')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak i rastvarač za suspenziju za injekciju u napunjenom injekcionom špricu', 'Powder and solvent for suspension for injection in pre-filled syringe', 'Prašak i rastvarač za suspenziju za injekciju u napunjenom injekcionom špricu', 'Прашак и растварач за суспензију за ињекцију у напуњеном ињекционом шприцу', 'Порошок и растворитель для приготовления суспензии для инъекций в предварительно заполненном шприце', 'Pulver und Lösungsmittel zur Herstellung einer Injektionssuspension in einer Fertigspritze', 'Önceden doldurulmuş enjektörde enjeksiyonluk süspansiyon için toz ve çözücü')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak i suspenzija za suspenziju za injekciju', 'Powder and suspension for suspension for injection', 'Prašak i suspenzija za suspenziju za injekciju', 'Прашак и суспензија за суспензију за ињекцију', 'Порошок и суспензия для приготовления суспензии для инъекций', 'Pulver und Suspension zur Herstellung einer Injektionssuspension', 'Enjeksiyonluk süspansiyon için toz ve süspansiyon')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak i suspenzija za suspenziju za injekciju u napunjenom injekcionom špricu', 'Powder and suspension for suspension for injection in pre-filled syringe', 'Prašak i suspenzija za suspenziju za injekciju u napunjenom injekcionom špricu', 'Прашак и суспензија за суспензију за ињекцију у напуњеном ињекционом шприцу', 'Порошок и суспензия для приготовления суспензии для инъекций в предварительно заполненном шприце', 'Pulver und Suspension zur Herstellung einer Injektionssuspension in einer Fertigspritze', 'Önceden doldurulmuş enjektörde enjeksiyonluk süspansiyon için toz ve süspansiyon')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak za disperziju za infuziju', 'Powder for dispersion for infusion', 'Prašak za disperziju za infuziju', 'Прашак за дисперзију за инфузију', 'Порошок для приготовления дисперсии для инфузий', 'Pulver zur Herstellung einer Infusionsdispersion', 'İnfüzyonluk dispersiyon için toz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak za inhalaciju', 'Inhalation powder', 'Prašak za inhalaciju', 'Прашак за инхалацију', 'Порошок для ингаляций', 'Pulver zur Inhalation', 'İnhalasyon tozu')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak za inhalaciju, podijeljen', 'Inhalation powder, pre-dispensed', 'Prašak za inhalaciju, podijeljen', 'Прашак за инхалацију, подијељен', 'Порошок для ингаляций дозированный', 'Einzeldosiertes Pulver zur Inhalation', 'Önceden bölünmüş inhalasyon tozu')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak za inhalaciju, tvrda kapsula', 'Inhalation powder, hard capsule', 'Prašak za inhalaciju, tvrda kapsula', 'Прашак за инхалацију, тврда капсула', 'Порошок для ингаляций в твёрдых капсулах', 'Hartkapsel mit Pulver zur Inhalation', 'Sert kapsülde inhalasyon tozu')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak za injekciju', 'Powder for injection', 'Prašak za injekciju', 'Прашак за ињекцију', 'Порошок для инъекций', 'Pulver zur Injektion', 'Enjeksiyonluk toz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak za intravezikalni rastvor', 'Powder for intravesical solution', 'Prašak za intravezikalni rastvor', 'Прашак за интравезикални раствор', 'Порошок для приготовления внутрипузырного раствора', 'Pulver zur Herstellung einer intravesikalen Lösung', 'İntravezikal çözelti için toz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak za koncentrat za rastvor za infuziju', 'Powder for concentrate for solution for infusion', 'Prašak za koncentrat za rastvor za infuziju', 'Прашак за концентрат за раствор за инфузију', 'Порошок для приготовления концентрата для раствора для инфузий', 'Pulver zur Herstellung eines Konzentrats für eine Infusionslösung', 'İnfüzyonluk çözelti konsantresi için toz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak za koncentrat za rastvor za injekciju/infuziju', 'Powder for concentrate for solution for injection/infusion', 'Prašak za koncentrat za rastvor za injekciju/infuziju', 'Прашак за концентрат за раствор за ињекцију/инфузију', 'Порошок для приготовления концентрата для раствора для инъекций/инфузий', 'Pulver zur Herstellung eines Konzentrats für eine Injektions-/Infusionslösung', 'Enjeksiyon/infüzyonluk çözelti konsantresi için toz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak za kožu', 'Cutaneous powder', 'Prašak za kožu', 'Прашак за кожу', 'Порошок для наружного применения', 'Pulver zur Anwendung auf der Haut', 'Deri tozu')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak za oralni rastvor', 'Powder for oral solution', 'Prašak za oralni rastvor', 'Прашак за орални раствор', 'Порошок для приготовления раствора для приёма внутрь', 'Pulver zur Herstellung einer Lösung zum Einnehmen', 'Oral çözelti için toz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak za oralni rastvor u kesici', 'Powder for oral solution in sachet', 'Prašak za oralni rastvor u kesici', 'Прашак за орални раствор у кесици', 'Порошок для приготовления раствора для приёма внутрь в саше', 'Pulver im Beutel zur Herstellung einer Lösung zum Einnehmen', 'Saşede oral çözelti için toz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak za oralnu suspenziju', 'Powder for oral suspension', 'Prašak za oralnu suspenziju', 'Прашак за оралну суспензију', 'Порошок для приготовления суспензии для приёма внутрь', 'Pulver zur Herstellung einer Suspension zum Einnehmen', 'Oral süspansiyon için toz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak za rastvor za infuziju', 'Powder for solution for infusion', 'Prašak za rastvor za infuziju', 'Прашак за раствор за инфузију', 'Порошок для приготовления раствора для инфузий', 'Pulver zur Herstellung einer Infusionslösung', 'İnfüzyonluk çözelti için toz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak za rastvor za injekciju', 'Powder for solution for injection', 'Prašak za rastvor za injekciju', 'Прашак за раствор за ињекцију', 'Порошок для приготовления раствора для инъекций', 'Pulver zur Herstellung einer Injektionslösung', 'Enjeksiyonluk çözelti için toz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak za rastvor za injekciju ili infuziju', 'Powder for solution for injection or infusion', 'Prašak za rastvor za injekciju ili infuziju', 'Прашак за раствор за ињекцију или инфузију', 'Порошок для приготовления раствора для инъекций или инфузий', 'Pulver zur Herstellung einer Injektions- oder Infusionslösung', 'Enjeksiyon veya infüzyonluk çözelti için toz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak za rastvor za injekciju/infuziju', 'Powder for solution for injection/infusion', 'Prašak za rastvor za injekciju/infuziju', 'Прашак за раствор за ињекцију/инфузију', 'Порошок для приготовления раствора для инъекций/инфузий', 'Pulver zur Herstellung einer Injektions-/Infusionslösung', 'Enjeksiyon/infüzyonluk çözelti için toz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Prašak za suspenziju za injekciju', 'Powder for suspension for injection', 'Prašak za suspenziju za injekciju', 'Прашак за суспензију за ињекцију', 'Порошок для приготовления суспензии для инъекций', 'Pulver zur Herstellung einer Injektionssuspension', 'Enjeksiyonluk süspansiyon için toz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rastvarač za parenteralnu upotrebu', 'Solvent for parenteral use', 'Rastvarač za parenteralnu upotrebu', 'Растварач за парентералну употребу', 'Растворитель для парентерального применения', 'Lösungsmittel zur parenteralen Anwendung', 'Parenteral kullanım için çözücü')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rastvor za grgljanje/ispiranje usta', 'Gargle/mouthwash', 'Rastvor za grgljanje/ispiranje usta', 'Раствор за гргљање/испирање уста', 'Раствор для полоскания горла/полости рта', 'Gurgellösung/Mundspülung', 'Gargara/ağız çalkalama çözeltisi')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rastvor za infuziju', 'Solution for infusion', 'Rastvor za infuziju', 'Раствор за инфузију', 'Раствор для инфузий', 'Infusionslösung', 'İnfüzyonluk çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rastvor za inhalaciju', 'Nebuliser solution', 'Rastvor za inhalaciju', 'Раствор за инхалацију', 'Раствор для ингаляций', 'Lösung für einen Vernebler', 'Nebülizatör çözeltisi')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rastvor za inhalaciju pod pritiskom', 'Pressurised inhalation solution', 'Rastvor za inhalaciju pod pritiskom', 'Раствор за инхалацију под притиском', 'Раствор для ингаляций под давлением', 'Druckgasinhalation, Lösung', 'Basınçlı inhalasyon çözeltisi')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rastvor za injekciju', 'Solution for injection', 'Rastvor za injekciju', 'Раствор за ињекцију', 'Раствор для инъекций', 'Injektionslösung', 'Enjeksiyonluk çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rastvor za injekciju u napunjenom injekcionom penu', 'Solution for injection in pre-filled pen', 'Rastvor za injekciju u napunjenom injekcionom penu', 'Раствор за ињекцију у напуњеном ињекционом пену', 'Раствор для инъекций в предварительно заполненной шприц-ручке', 'Injektionslösung im Fertigpen', 'Önceden doldurulmuş kalemde enjeksiyonluk çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rastvor za injekciju u napunjenom injekcionom špricu', 'Solution for injection in pre-filled syringe', 'Rastvor za injekciju u napunjenom injekcionom špricu', 'Раствор за ињекцију у напуњеном ињекционом шприцу', 'Раствор для инъекций в предварительно заполненном шприце', 'Injektionslösung in einer Fertigspritze', 'Önceden doldurulmuş enjektörde enjeksiyonluk çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rastvor za injekciju u penu sa uloškom', 'Solution for injection in cartridge pen', 'Rastvor za injekciju u penu sa uloškom', 'Раствор за ињекцију у пену са улошком', 'Раствор для инъекций в шприц-ручке с картриджем', 'Injektionslösung im Pen mit Patrone', 'Kartuşlu kalemde enjeksiyonluk çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rastvor za injekciju u ulošku', 'Solution for injection in cartridge', 'Rastvor za injekciju u ulošku', 'Раствор за ињекцију у улошку', 'Раствор для инъекций в картридже', 'Injektionslösung in einer Patrone', 'Kartuşta enjeksiyonluk çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rastvor za injekciju/infuziju', 'Solution for injection/infusion', 'Rastvor za injekciju/infuziju', 'Раствор за ињекцију/инфузију', 'Раствор для инъекций/инфузий', 'Injektions-/Infusionslösung', 'Enjeksiyon/infüzyonluk çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rastvor za injekciju/infuziju u napunjenom injekcionom špricu', 'Solution for injection/infusion in pre-filled syringe', 'Rastvor za injekciju/infuziju u napunjenom injekcionom špricu', 'Раствор за ињекцију/инфузију у напуњеном ињекционом шприцу', 'Раствор для инъекций/инфузий в предварительно заполненном шприце', 'Injektions-/Infusionslösung in einer Fertigspritze', 'Önceden doldurulmuş enjektörde enjeksiyon/infüzyonluk çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rastvor za ispiranje bešike', 'Bladder irrigation solution', 'Rastvor za ispiranje bešike', 'Раствор за испирање бешике', 'Раствор для промывания мочевого пузыря', 'Blasenspüllösung', 'Mesane yıkama çözeltisi')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rastvor za ispiranje usta', 'Mouthwash', 'Rastvor za ispiranje usta', 'Раствор за испирање уста', 'Раствор для полоскания полости рта', 'Mundspülung', 'Ağız çalkalama çözeltisi')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rastvor za kožu', 'Cutaneous solution', 'Rastvor za kožu', 'Раствор за кожу', 'Раствор для наружного применения', 'Lösung zur Anwendung auf der Haut', 'Deri çözeltisi')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rastvor za peritonealnu dijalizu', 'Peritoneal dialysis solution', 'Rastvor za peritonealnu dijalizu', 'Раствор за перитонеалну дијализу', 'Раствор для перитонеального диализа', 'Peritonealdialyselösung', 'Periton diyaliz çözeltisi')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rastvor za raspršivanje', 'Nebuliser solution', 'Rastvor za raspršivanje', 'Раствор за распршивање', 'Раствор для распыления', 'Lösung für einen Vernebler', 'Nebülizatör çözeltisi')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rastvor za usnu sluznicu', 'Oromucosal solution', 'Rastvor za usnu sluznicu', 'Раствор за усну слузницу', 'Раствор для слизистой оболочки полости рта', 'Lösung zur Anwendung in der Mundhöhle', 'Ağız mukozası çözeltisi')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rektalna mast', 'Rectal ointment', 'Rektalna mast', 'Ректална маст', 'Мазь ректальная', 'Rektalsalbe', 'Rektal merhem')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Rektalna suspenzija', 'Rectal suspension', 'Rektalna suspenzija', 'Ректална суспензија', 'Суспензия ректальная', 'Rektalsuspension', 'Rektal süspansiyon')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Sirup', 'Syrup', 'Sirup', 'Сируп', 'Сироп', 'Sirup', 'Şurup')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Sprej za kožu, prašak', 'Cutaneous spray, powder', 'Sprej za kožu, prašak', 'Спреј за кожу, прашак', 'Спрей для наружного применения, порошок', 'Spray zur Anwendung auf der Haut, Pulver', 'Deri spreyi, toz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Sprej za kožu, rastvor', 'Cutaneous spray, solution', 'Sprej za kožu, rastvor', 'Спреј за кожу, раствор', 'Спрей для наружного применения, раствор', 'Spray zur Anwendung auf der Haut, Lösung', 'Deri spreyi, çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Sprej za nos, rastvor', 'Nasal spray, solution', 'Sprej za nos, rastvor', 'Спреј за нос, раствор', 'Спрей назальный, раствор', 'Nasenspray, Lösung', 'Burun spreyi, çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Sprej za nos, suspenzija', 'Nasal spray, suspension', 'Sprej za nos, suspenzija', 'Спреј за нос, суспензија', 'Спрей назальный, суспензия', 'Nasenspray, Suspension', 'Burun spreyi, süspansiyon')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Sprej za usnu sluznicu, rastvor', 'Oromucosal spray, solution', 'Sprej za usnu sluznicu, rastvor', 'Спреј за усну слузницу, раствор', 'Спрей для слизистой оболочки полости рта, раствор', 'Spray zur Anwendung in der Mundhöhle, Lösung', 'Ağız mukozası spreyi, çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Sublingvalna tableta', 'Sublingual tablet', 'Sublingvalna tableta', 'Сублингвална таблета', 'Таблетка подъязычная', 'Sublingualtablette', 'Dilaltı tablet')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Sublingvalni sprej, rastvor', 'Sublingual spray, solution', 'Sublingvalni sprej, rastvor', 'Сублингвални спреј, раствор', 'Спрей подъязычный, раствор', 'Sublingualspray, Lösung', 'Dilaltı sprey, çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Supozitorija', 'Suppository', 'Supozitorija', 'Супозиторија', 'Суппозиторий', 'Suppositorium', 'Supozituvar')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Suspenzija za inhalaciju pod pritiskom', 'Pressurised inhalation, suspension', 'Suspenzija za inhalaciju pod pritiskom', 'Суспензија за инхалацију под притиском', 'Суспензия для ингаляций под давлением', 'Druckgasinhalation, Suspension', 'Basınçlı inhalasyon süspansiyonu')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Suspenzija za injekciju', 'Suspension for injection', 'Suspenzija za injekciju', 'Суспензија за ињекцију', 'Суспензия для инъекций', 'Injektionssuspension', 'Enjeksiyonluk süspansiyon')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Suspenzija za injekciju sa produženim oslobađanjem', 'Prolonged-release suspension for injection', 'Suspenzija za injekciju sa produženim oslobađanjem', 'Суспензија за ињекцију са продуженим ослобађањем', 'Суспензия для инъекций пролонгированного действия', 'Depot-Injektionssuspension', 'Uzatılmış salımlı enjeksiyonluk süspansiyon')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Suspenzija za injekciju sa produženim oslobađanjem u napunjenom injekcionom špricu', 'Prolonged-release suspension for injection in pre-filled syringe', 'Suspenzija za injekciju sa produženim oslobađanjem u napunjenom injekcionom špricu', 'Суспензија за ињекцију са продуженим ослобађањем у напуњеном ињекционом шприцу', 'Суспензия для инъекций пролонгированного действия в предварительно заполненном шприце', 'Depot-Injektionssuspension in einer Fertigspritze', 'Önceden doldurulmuş enjektörde uzatılmış salımlı enjeksiyonluk süspansiyon')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Suspenzija za injekciju u napunjenom injekcionom špricu', 'Suspension for injection in pre-filled syringe', 'Suspenzija za injekciju u napunjenom injekcionom špricu', 'Суспензија за ињекцију у напуњеном ињекционом шприцу', 'Суспензия для инъекций в предварительно заполненном шприце', 'Injektionssuspension in einer Fertigspritze', 'Önceden doldurulmuş enjektörde enjeksiyonluk süspansiyon')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Suspenzija za injekciju u ulošku', 'Suspension for injection in cartridge', 'Suspenzija za injekciju u ulošku', 'Суспензија за ињекцију у улошку', 'Суспензия для инъекций в картридже', 'Injektionssuspension in einer Patrone', 'Kartuşta enjeksiyonluk süspansiyon')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Suspenzija za raspršivanje', 'Nebuliser suspension', 'Suspenzija za raspršivanje', 'Суспензија за распршивање', 'Суспензия для распыления', 'Suspension für einen Vernebler', 'Nebülizatör süspansiyonu')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Tableta', 'Tablet', 'Tableta', 'Таблета', 'Таблетка', 'Tablette', 'Tablet')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Tableta sa modifikovanim oslobađanjem', 'Modified-release tablet', 'Tableta sa modifikovanim oslobađanjem', 'Таблета са модификованим ослобађањем', 'Таблетка с модифицированным высвобождением', 'Tablette mit veränderter Wirkstofffreisetzung', 'Değiştirilmiş salımlı tablet')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Tableta sa produženim oslobađanjem', 'Prolonged-release tablet', 'Tableta sa produženim oslobađanjem', 'Таблета са продуженим ослобађањем', 'Таблетка с пролонгированным высвобождением', 'Retardtablette', 'Uzatılmış salımlı tablet')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Tableta za oralnu suspenziju', 'Tablet for oral suspension', 'Tableta za oralnu suspenziju', 'Таблета за оралну суспензију', 'Таблетка для приготовления суспензии для приёма внутрь', 'Tablette zur Herstellung einer Suspension zum Einnehmen', 'Oral süspansiyon tableti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Tableta za žvakanje', 'Chewable tablet', 'Tableta za žvakanje', 'Таблета за жвакање', 'Таблетка жевательная', 'Kautablette', 'Çiğneme tableti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Tableta za žvakanje/oralnu disperziju', 'Chewable/orodispersible tablet', 'Tableta za žvakanje/oralnu disperziju', 'Таблета за жвакање/оралну дисперзију', 'Таблетка жевательная/диспергируемая в полости рта', 'Kau-/Schmelztablette', 'Çiğneme/ağızda dağılan tablet')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Transdermalni flaster', 'Transdermal patch', 'Transdermalni flaster', 'Трансдермални фластер', 'Пластырь трансдермальный', 'Transdermales Pflaster', 'Transdermal flaster')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Transdermalni sprej, rastvor', 'Transdermal spray, solution', 'Transdermalni sprej, rastvor', 'Трансдермални спреј, раствор', 'Спрей трансдермальный, раствор', 'Transdermales Spray, Lösung', 'Transdermal sprey, çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Vaginalna kapsula, meka', 'Vaginal capsule, soft', 'Vaginalna kapsula, meka', 'Вагинална капсула, мека', 'Капсула вагинальная мягкая', 'Vaginalkapsel, weich', 'Vajinal yumuşak kapsül')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Vaginalna kapsula, tvrda', 'Vaginal capsule, hard', 'Vaginalna kapsula, tvrda', 'Вагинална капсула, тврда', 'Капсула вагинальная твёрдая', 'Vaginalkapsel, hart', 'Vajinal sert kapsül')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Vaginalna tableta', 'Vaginal tablet', 'Vaginalna tableta', 'Вагинална таблета', 'Таблетка вагинальная', 'Vaginaltablette', 'Vajinal tablet')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Vaginalni krem', 'Vaginal cream', 'Vaginalni krem', 'Вагинални крем', 'Крем вагинальный', 'Vaginalcreme', 'Vajinal krem')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Vagitorija', 'Pessary', 'Vagitorija', 'Вагиторија', 'Суппозиторий вагинальный', 'Vaginalsuppositorium', 'Vajinal supozituvar')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('blister', 'Blister', 'Blister', 'Блистер', 'Блистер', 'Blister', 'Blister')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('kapsula tvrda', 'Capsule, hard', 'Kapsula, tvrda', 'Капсула, тврда', 'Капсула твёрдая', 'Hartkapsel', 'Sert kapsül')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('prašak za koncentrat za rastvor za injekciju', 'Powder for concentrate for solution for injection', 'Prašak za koncentrat za rastvor za injekciju', 'Прашак за концентрат за раствор за ињекцију', 'Порошок для приготовления концентрата для раствора для инъекций', 'Pulver zur Herstellung eines Konzentrats für eine Injektionslösung', 'Enjeksiyonluk çözelti konsantresi için toz')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('rastvor za injekciju u napunjenom injekcijonom špricu', 'Solution for injection in pre-filled syringe', 'Rastvor za injekciju u napunjenom injekcionom špricu', 'Раствор за ињекцију у напуњеном ињекционом шприцу', 'Раствор для инъекций в предварительно заполненном шприце', 'Injektionslösung in einer Fertigspritze', 'Önceden doldurulmuş enjektörde enjeksiyonluk çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('rastvor za injekciju u penu sa uloškom', 'Solution for injection in cartridge pen', 'Rastvor za injekciju u penu sa uloškom', 'Раствор за ињекцију у пену са улошком', 'Раствор для инъекций в шприц-ручке с картриджем', 'Injektionslösung im Pen mit Patrone', 'Kartuşlu kalemde enjeksiyonluk çözelti')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('sprej za kožu', 'Cutaneous spray', 'Sprej za kožu', 'Спреј за кожу', 'Спрей для наружного применения', 'Spray zur Anwendung auf der Haut', 'Deri spreyi')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('suspenzija za injekciju u penu sa uloškom', 'Suspension for injection in cartridge pen', 'Suspenzija za injekciju u penu sa uloškom', 'Суспензија за ињекцију у пену са улошком', 'Суспензия для инъекций в шприц-ручке с картриджем', 'Injektionssuspension im Pen mit Patrone', 'Kartuşlu kalemde enjeksiyonluk süspansiyon')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('tvrda', 'Hard', 'Tvrda', 'Тврда', 'Твёрдая', 'Hart', 'Sert')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Šampon', 'Shampoo', 'Šampon', 'Шампон', 'Шампунь', 'Shampoo', 'Şampuan')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Šumeća tableta', 'Effervescent tablet', 'Šumeća tableta', 'Шумећа таблета', 'Таблетка шипучая', 'Brausetablette', 'Efervesan tablet')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);

INSERT INTO `med_pharma_forms` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
VALUES ('Šumeće granule', 'Effervescent granules', 'Šumeće granule', 'Шумеће грануле', 'Гранулы шипучие', 'Brausegranulat', 'Efervesan granül')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);
