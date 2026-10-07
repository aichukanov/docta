SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Dom zdravlja Glavnog grada (slug dom-zdravlja-podgorica): sinhronizacija ljekara sa sajtom dzpg.me.
-- U bazi klinika nema ni jednog ljekara, pa ovdje ima samo vezivanja i dodavanja; odvezivanja nema.
-- Izvor: mjesečni PDF rasporedi službi sa https://www.dzpg.me/rasporedi-rada-zs/ (stranica izmijenjena
-- 2026-10-06, preuzeto 2026-10-06). Po službi uzet najsvježiji objavljeni spisak:
--   IDO (doktori)        — jul 2026 (IDO-doktori-jul-2026.pdf; avgust–oktobar ima samo vikend-raspored)
--   IDO vikend/praznici  — oktobar 2026 (+ jul–septembar za zamjene)
--   IDD                  — 27–30.04.2026 (posljednji puni spisak) + noćne smjene jun–avgust 2026
--                          + Dopunski rad zaposlenih januar–april 2026 (Šebek, Milović, Dervišević)
--   IDŽ                  — oktobar 2026
--   Centar za mentalno zdravlje — oktobar 2026; RTG i UZ (radiolozi) — oktobar/novembar 2026
--   Internistička ambulanta, Medicina rada, Sportska medicina — oktobar 2026
--   Oftalmološka ambulanta, Laboratorija (biohemičari) — septembar 2026
--   Centar za plućne bolesti i TBC — jun 2026; CDPP — maj 2026; Fizikalna terapija — maj 2026
-- Klinika, ljekari i specijalnosti — samo po slug / name (id lokalno i na produ se razlikuju).
-- Novi ljekar: "nađi ili napravi" po slug-u; jezik — srpski; photo_url NULL (u PDF-ovima nema fotografija).
-- Idempotentno: drugi prolaz ne mijenja ništa.
-- Odluke: data/clinic-teams/decisions/dz-podgorica.md

SET @clinic = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-podgorica');

-- ═══════════════════════════════════════════════════════════════
-- 1. Postojeći ljekari (već u bazi kod drugih klinika) — samo vezivanje (35)
-- ═══════════════════════════════════════════════════════════════

-- Sanela Muminović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'sanela-muminovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Ivana Novović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'ivana-novovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Zlatica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Dušica Gojković (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'dusica-gojkovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Ivana Lakićević (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'ivana-lakicevic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Stara Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Anja Đurović (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'anja-djurovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Stara Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Rajka Pajović (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'rajka-pajovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Stara Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Biljana Raičević-Fuštar (IDD apr + noćna avg)
SET @d = (SELECT id FROM doctors WHERE slug = 'biljana-raicevic-fustar');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Načelnica OC Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Ana Vukčević (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'ana-vukcevic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Stara Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Edita Bašović (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'edita-basovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Stari Aerodrom' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Saida Zejnilović (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'saida-zejnilovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Snežana Perazić (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'snezana-perazic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Zlatica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Snežana Šebek (dopunski jan-apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'snezana-sebek');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Alma Dervišević (dopunski jan-apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'alma-dervisevic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Željka Ralević (IDZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'zeljka-ralevic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za žene, ZO Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Milovan Jovanović (IDZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'milovan-jovanovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za žene, ZO Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Jelena Miranović (IDZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-terzic-miranovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za žene, ZO Stari Aerodrom' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Aleksandar Boljević (IDZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'aleksandar-boljevic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za žene, ZO Stari Aerodrom' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Željka Stevović (IDZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'zeljka-stevovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za žene, ZO Studentska ambulanta' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Nataša Tomašević (IDZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'natasa-tomasevic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za žene, ZO Studentska ambulanta' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Ersan Bašović (IDZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'ersan-basovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za žene, ZO Tuzi' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Milica Gazivoda (IDZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'milica-gazivoda');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za žene, ZO Golubovci' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Maida Burdžović (CMZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'maida-burdzovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za mentalno zdravlje' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Branka Purlija (CMZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'branka-purlija');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za mentalno zdravlje' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Anđa Bulajić Vuković (CMZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'andja-bulajic-vukovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za mentalno zdravlje' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Danilo Đurić (CMZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'djuric-danilo');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za mentalno zdravlje (psiholog)' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Alma Crnovršanin (RTG okt-nov)
SET @d = (SELECT id FROM doctors WHERE slug = 'alma-crnovrsanin');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za RTG i ultrazvučnu dijagnostiku' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Ana Ičević (RTG okt-nov)
SET @d = (SELECT id FROM doctors WHERE slug = 'ana-icevic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za RTG i ultrazvučnu dijagnostiku' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Katarina Kalezić (RTG okt-nov)
SET @d = (SELECT id FROM doctors WHERE slug = 'katarina-kalezic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za RTG i ultrazvučnu dijagnostiku' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Jelena Obadović (RTG okt-nov)
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-obadovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za RTG i ultrazvučnu dijagnostiku' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Enisa Pupović (INT okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'enisa-pupovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Internistička ambulanta' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Milenka Ušćumlić (MR okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'milenka-uscumlic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Šef Centra za medicinu rada' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Dubravka Lopičić Mirković (TBC jun)
SET @d = (SELECT id FROM doctors WHERE slug = 'dubravka-lopicic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Šef Centra za plućne bolesti i TBC' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Amer Halilović (TBC jun)
SET @d = (SELECT id FROM doctors WHERE slug = 'amer-halilovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za plućne bolesti i TBC' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Dragana Radunović (FIZ maj)
SET @d = (SELECT id FROM doctors WHERE slug = 'dragana-radunovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Jedinica za fizikalnu terapiju primarnog nivoa' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Danica Vešović (LAB sep)
SET @d = (SELECT id FROM doctors WHERE slug = 'danica-vesovic');
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za laboratorijsku dijagnostiku' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- ═══════════════════════════════════════════════════════════════
-- 2. Novi ljekari (142)
-- ═══════════════════════════════════════════════════════════════

-- ─── Izabrani doktor za odrasle (IDO) — general_medicine (96) ───

-- Marina Bugarin (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'marina-bugarin');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marina-bugarin', 'Marina Bugarin', 'Марина Бугарин', 'Марина Бугарин', 'Marina Bugarin', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'marina-bugarin');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Veselin Kandić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'veselin-kandic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'veselin-kandic', 'Veselin Kandić', 'Веселин Кандић', 'Веселин Кандич', 'Veselin Kandic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'veselin-kandic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Ivana Jovanović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'ivana-jovanovic-2');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivana-jovanovic-2', 'Ivana Jovanović', 'Ивана Јовановић', 'Ивана Йованович', 'Ivana Jovanovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ivana-jovanovic-2');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Jasmina Kajabegović Martinović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'jasmina-kajabegovic-martinovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jasmina-kajabegovic-martinovic', 'Jasmina Kajabegović Martinović', 'Јасмина Кајабеговић Мартиновић', 'Ясмина Каябегович Мартинович', 'Jasmina Kajabegovic Martinovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'jasmina-kajabegovic-martinovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Aldijana Zeković (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'aldijana-zekovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aldijana-zekovic', 'Aldijana Zeković', 'Алдијана Зековић', 'Алдияна Зекович', 'Aldijana Zekovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'aldijana-zekovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Slobodanka Marojević (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'slobodanka-marojevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'slobodanka-marojevic', 'Slobodanka Marojević', 'Слободанка Маројевић', 'Слободанка Мароевич', 'Slobodanka Marojevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'slobodanka-marojevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Nela Sekulić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'nela-sekulic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nela-sekulic', 'Nela Sekulić', 'Нела Секулић', 'Нела Секулич', 'Nela Sekulic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'nela-sekulic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Zorica Boričić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'zorica-boricic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zorica-boricic', 'Zorica Boričić', 'Зорица Боричић', 'Зорица Боричич', 'Zorica Boricic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'zorica-boricic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Milena Cojić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'milena-cojic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milena-cojic', 'Milena Cojić', 'Милена Цојић', 'Милена Цойич', 'Milena Cojic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'milena-cojic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Ana Tmušić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'ana-tmusic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ana-tmusic', 'Ana Tmušić', 'Ана Тмушић', 'Ана Тмушич', 'Ana Tmusic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ana-tmusic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Amina Šahmanović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'amina-sahmanovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'amina-sahmanovic', 'Amina Šahmanović', 'Амина Шахмановић', 'Амина Шахманович', 'Amina Sahmanovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'amina-sahmanovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Jelena Stojović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-stojovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jelena-stojovic', 'Jelena Stojović', 'Јелена Стојовић', 'Елена Стойович', 'Jelena Stojovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-stojovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Tijana Petrić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'tijana-petric');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tijana-petric', 'Tijana Petrić', 'Тијана Петрић', 'Тияна Петрич', 'Tijana Petric', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'tijana-petric');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Vesko Kovijanić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'vesko-kovijanic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vesko-kovijanic', 'Vesko Kovijanić', 'Веско Ковијанић', 'Веско Ковиянич', 'Vesko Kovijanic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'vesko-kovijanic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Gordana Babić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'gordana-babic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'gordana-babic', 'Gordana Babić', 'Гордана Бабић', 'Гордана Бабич', 'Gordana Babic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'gordana-babic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Stara Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Ivana Despotović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'ivana-despotovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivana-despotovic', 'Ivana Despotović', 'Ивана Деспотовић', 'Ивана Деспотович', 'Ivana Despotovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ivana-despotovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Stara Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Milijana Vujović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'milijana-vujovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milijana-vujovic', 'Milijana Vujović', 'Милијана Вујовић', 'Милияна Вуйович', 'Milijana Vujovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'milijana-vujovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Stara Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Jelena Stanković (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-stankovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jelena-stankovic', 'Jelena Stanković', 'Јелена Станковић', 'Елена Станкович', 'Jelena Stankovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-stankovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Stara Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Radmila Bojić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'radmila-bojic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'radmila-bojic', 'Radmila Bojić', 'Радмила Бојић', 'Радмила Бойич', 'Radmila Bojic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'radmila-bojic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Stara Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Snežana Mikavica (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'snezana-mikavica');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'snezana-mikavica', 'Snežana Mikavica', 'Снежана Микавица', 'Снежана Микавица', 'Snezana Mikavica', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'snezana-mikavica');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Stara Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Marija Vuković (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'marija-vukovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marija-vukovic', 'Marija Vuković', 'Марија Вуковић', 'Мария Вукович', 'Marija Vukovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'marija-vukovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Stara Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Marijana Simonović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'marijana-simonovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marijana-simonovic', 'Marijana Simonović', 'Маријана Симоновић', 'Марияна Симонович', 'Marijana Simonovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'marijana-simonovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Stara Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Dragana Perović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'dragana-perovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dragana-perovic', 'Dragana Perović', 'Драгана Перовић', 'Драгана Перович', 'Dragana Perovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'dragana-perovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Stara Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Jelena Radusinović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-radusinovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jelena-radusinovic', 'Jelena Radusinović', 'Јелена Радусиновић', 'Елена Радусинович', 'Jelena Radusinovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-radusinovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Stara Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Stefan Praščević (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'stefan-prascevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'stefan-prascevic', 'Stefan Praščević', 'Стефан Прашчевић', 'Стефан Прашчевич', 'Stefan Prascevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'stefan-prascevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Stari Aerodrom' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Rosa Brinić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'rosa-brinic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'rosa-brinic', 'Rosa Brinić', 'Роса Бринић', 'Роса Бринич', 'Rosa Brinic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'rosa-brinic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Stari Aerodrom' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Dragoslava Ćipranić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'dragoslava-cipranic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dragoslava-cipranic', 'Dragoslava Ćipranić', 'Драгослава Ћипранић', 'Драгослава Чипранич', 'Dragoslava Cipranic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'dragoslava-cipranic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Stari Aerodrom' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Nataša Radonjić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'natasa-radonjic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'natasa-radonjic', 'Nataša Radonjić', 'Наташа Радоњић', 'Наташа Радонич', 'Natasa Radonjic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'natasa-radonjic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Stari Aerodrom' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Denisa Frljučkić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'denisa-frljuckic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'denisa-frljuckic', 'Denisa Frljučkić', 'Дениса Фрључкић', 'Дениса Фрлючкич', 'Denisa Frljuckic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'denisa-frljuckic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Stari Aerodrom' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Liridon Dushaj (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'liridon-dushaj');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'liridon-dushaj', 'Liridon Dushaj', 'Лиридон Душај', 'Лиридон Душай', 'Liridon Dushaj', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'liridon-dushaj');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Stari Aerodrom' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Radojka Lekić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'radojka-lekic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'radojka-lekic', 'Radojka Lekić', 'Радојка Лекић', 'Радойка Лекич', 'Radojka Lekic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'radojka-lekic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Adela Dizdarević (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'adela-dizdarevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'adela-dizdarevic', 'Adela Dizdarević', 'Адела Диздаревић', 'Адела Диздаревич', 'Adela Dizdarevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'adela-dizdarevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Selena Kenić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'selena-kenic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'selena-kenic', 'Selena Kenić', 'Селена Кенић', 'Селена Кенич', 'Selena Kenic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'selena-kenic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Snežana Mićanović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'snezana-micanovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'snezana-micanovic', 'Snežana Mićanović', 'Снежана Мићановић', 'Снежана Мичанович', 'Snezana Micanovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'snezana-micanovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Merzika Hodžić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'merzika-hodzic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'merzika-hodzic', 'Merzika Hodžić', 'Мерзика Хоџић', 'Мерзика Ходжич', 'Merzika Hodzic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'merzika-hodzic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Jasna Kalač-Čekić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'jasna-kalac-cekic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jasna-kalac-cekic', 'Jasna Kalač-Čekić', 'Јасна Калач-Чекић', 'Ясна Калач-Чекич', 'Jasna Kalac-Cekic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'jasna-kalac-cekic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Branka Grujević (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'branka-grujevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'branka-grujevic', 'Branka Grujević', 'Бранка Грујевић', 'Бранка Груевич', 'Branka Grujevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'branka-grujevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Anela Omeragić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'anela-omeragic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'anela-omeragic', 'Anela Omeragić', 'Анела Омерагић', 'Анела Омерагич', 'Anela Omeragic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'anela-omeragic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Natalija Popović-Petrić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'natalija-popovic-petric');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'natalija-popovic-petric', 'Natalija Popović-Petrić', 'Наталија Поповић-Петрић', 'Наталия Попович-Петрич', 'Natalija Popovic-Petric', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'natalija-popovic-petric');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Marija Bulatović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'marija-bulatovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marija-bulatovic', 'Marija Bulatović', 'Марија Булатовић', 'Мария Булатович', 'Marija Bulatovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'marija-bulatovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Miljana Janjušević (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'miljana-janjusevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'miljana-janjusevic', 'Miljana Janjušević', 'Миљана Јањушевић', 'Миляна Янюшевич', 'Miljana Janjusevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'miljana-janjusevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Biljana Danaj (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'biljana-danaj');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'biljana-danaj', 'Biljana Danaj', 'Биљана Данај', 'Биляна Данай', 'Biljana Danaj', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'biljana-danaj');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Novak Praščević (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'novak-prascevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'novak-prascevic', 'Novak Praščević', 'Новак Прашчевић', 'Новак Прашчевич', 'Novak Prascevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'novak-prascevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Jelena Ćetković (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-cetkovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jelena-cetkovic', 'Jelena Ćetković', 'Јелена Ћетковић', 'Елена Четкович', 'Jelena Cetkovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-cetkovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Jelena Ivanović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-ivanovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jelena-ivanovic', 'Jelena Ivanović', 'Јелена Ивановић', 'Елена Иванович', 'Jelena Ivanovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-ivanovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Maja Laličić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'maja-lalicic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'maja-lalicic', 'Maja Laličić', 'Маја Лаличић', 'Мая Лаличич', 'Maja Lalicic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'maja-lalicic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Elvidina Numanović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'elvidina-numanovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'elvidina-numanovic', 'Elvidina Numanović', 'Елвидина Нумановић', 'Элвидина Нуманович', 'Elvidina Numanovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'elvidina-numanovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Studentski centar' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Ena Vešović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'ena-vesovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ena-vesovic', 'Ena Vešović', 'Ена Вешовић', 'Эна Вешович', 'Ena Vesovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ena-vesovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Studentski centar' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Jadranka Papić-Radunović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'jadranka-papic-radunovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jadranka-papic-radunovic', 'Jadranka Papić-Radunović', 'Јадранка Папић-Радуновић', 'Ядранка Папич-Радунович', 'Jadranka Papic-Radunovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'jadranka-papic-radunovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Studentski centar' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Rade Vlahović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'rade-vlahovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'rade-vlahovic', 'Rade Vlahović', 'Раде Влаховић', 'Раде Влахович', 'Rade Vlahovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'rade-vlahovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Studentski centar' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Mirjana Dobrović-Milošević (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'mirjana-dobrovic-milosevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mirjana-dobrovic-milosevic', 'Mirjana Dobrović-Milošević', 'Мирјана Добровић-Милошевић', 'Мирьяна Добрович-Милошевич', 'Mirjana Dobrovic-Milosevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'mirjana-dobrovic-milosevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Studentski centar' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Branko Popadić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'branko-popadic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'branko-popadic', 'Branko Popadić', 'Бранко Попадић', 'Бранко Попадич', 'Branko Popadic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'branko-popadic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Studentski centar' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Nataša Nišavić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'natasa-nisavic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'natasa-nisavic', 'Nataša Nišavić', 'Наташа Нишавић', 'Наташа Нишавич', 'Natasa Nisavic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'natasa-nisavic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Konik' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Melisa Spahić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'melisa-spahic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'melisa-spahic', 'Melisa Spahić', 'Мелиса Спахић', 'Мелиса Спахич', 'Melisa Spahic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'melisa-spahic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Konik' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Danica Knežević (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'danica-knezevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'danica-knezevic', 'Danica Knežević', 'Даница Кнежевић', 'Даница Кнежевич', 'Danica Knezevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'danica-knezevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Konik' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Milena Peličić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'milena-pelicic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milena-pelicic', 'Milena Peličić', 'Милена Пеличић', 'Милена Пеличич', 'Milena Pelicic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'milena-pelicic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Konik' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Nedžmija Beriša (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'nedzmija-berisa');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nedzmija-berisa', 'Nedžmija Beriša', 'Неџмија Бериша', 'Неджмия Бериша', 'Nedzmija Berisa', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'nedzmija-berisa');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Konik' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Tereze Dreshaj (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'tereze-dreshaj');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tereze-dreshaj', 'Tereze Dreshaj', 'Терезе Дрешај', 'Терезе Дрешай', 'Tereze Dreshaj', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'tereze-dreshaj');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Konik' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Halil Duković (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'halil-dukovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'halil-dukovic', 'Halil Duković', 'Халил Дуковић', 'Халил Дукович', 'Halil Dukovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'halil-dukovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Tuzi' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Šejla Batilović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'sejla-batilovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sejla-batilovic', 'Šejla Batilović', 'Шејла Батиловић', 'Шейла Батилович', 'Sejla Batilovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'sejla-batilovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Tuzi' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Marina Radović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'marina-radovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marina-radovic', 'Marina Radović', 'Марина Радовић', 'Марина Радович', 'Marina Radovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'marina-radovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Golubovci' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Anita Vujičić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'anita-vujicic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'anita-vujicic', 'Anita Vujičić', 'Анита Вујичић', 'Анита Вуйичич', 'Anita Vujicic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'anita-vujicic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Golubovci' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Dušica Knežević (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'dusica-knezevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dusica-knezevic', 'Dušica Knežević', 'Душица Кнежевић', 'Душица Кнежевич', 'Dusica Knezevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'dusica-knezevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Golubovci' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Vesna Đuretić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'vesna-djuretic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vesna-djuretic', 'Vesna Đuretić', 'Весна Ђуретић', 'Весна Джуретич', 'Vesna Djuretic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'vesna-djuretic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Golubovci' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Marina Jaćimović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'marina-jacimovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marina-jacimovic', 'Marina Jaćimović', 'Марина Јаћимовић', 'Марина Ячимович', 'Marina Jacimovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'marina-jacimovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, ZS Golubovci' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Ljiljana Đurović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'ljiljana-djurovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ljiljana-djurovic', 'Ljiljana Đurović', 'Љиљана Ђуровић', 'Лиляна Джурович', 'Ljiljana Djurovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ljiljana-djurovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Zabjelo – Jerevanska' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Svetlana Terzić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'svetlana-terzic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'svetlana-terzic', 'Svetlana Terzić', 'Светлана Терзић', 'Светлана Терзич', 'Svetlana Terzic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'svetlana-terzic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Zabjelo – Jerevanska' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Danijela Šiljković (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'danijela-siljkovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'danijela-siljkovic', 'Danijela Šiljković', 'Данијела Шиљковић', 'Даниела Шилькович', 'Danijela Siljkovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'danijela-siljkovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Zabjelo – Jerevanska' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Lidija Samardžić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'lidija-samardzic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'lidija-samardzic', 'Lidija Samardžić', 'Лидија Самарџић', 'Лидия Самарджич', 'Lidija Samardzic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'lidija-samardzic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Zabjelo – Jerevanska' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Branka Đurišić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'branka-djurisic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'branka-djurisic', 'Branka Đurišić', 'Бранка Ђуришић', 'Бранка Джуришич', 'Branka Djurisic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'branka-djurisic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Zlatica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Ljiljana Marković (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'ljiljana-markovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ljiljana-markovic', 'Ljiljana Marković', 'Љиљана Марковић', 'Лиляна Маркович', 'Ljiljana Markovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ljiljana-markovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Zlatica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Vesna Milićević (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'vesna-milicevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vesna-milicevic', 'Vesna Milićević', 'Весна Милићевић', 'Весна Миличевич', 'Vesna Milicevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'vesna-milicevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Zlatica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Mihajlo Vukanić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'mihajlo-vukanic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mihajlo-vukanic', 'Mihajlo Vukanić', 'Михајло Вуканић', 'Михайло Вуканич', 'Mihajlo Vukanic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'mihajlo-vukanic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Zlatica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Jasminka Zec-Saveljić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'jasminka-zec-saveljic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jasminka-zec-saveljic', 'Jasminka Zec-Saveljić', 'Јасминка Зец-Савељић', 'Ясминка Зец-Савелич', 'Jasminka Zec-Saveljic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'jasminka-zec-saveljic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Zlatica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Erna Hot (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'erna-hot');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'erna-hot', 'Erna Hot', 'Ерна Хот', 'Эрна Хот', 'Erna Hot', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'erna-hot');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Zlatica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Anđela Aletić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'andjela-aletic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'andjela-aletic', 'Anđela Aletić', 'Анђела Алетић', 'Анджела Алетич', 'Andjela Aletic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'andjela-aletic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Zlatica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Jasna Furtula (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'jasna-furtula');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jasna-furtula', 'Jasna Furtula', 'Јасна Фуртула', 'Ясна Фуртула', 'Jasna Furtula', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'jasna-furtula');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Zlatica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Jelena Damjanović (IDO jul + IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-damjanovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jelena-damjanovic', 'Jelena Damjanović', 'Јелена Дамјановић', 'Елена Дамьянович', 'Jelena Damjanovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-damjanovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Donja Gorica; izabrani doktor za djecu, ZO Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Marija Međedović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'marija-medjedovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marija-medjedovic', 'Marija Međedović', 'Марија Међедовић', 'Мария Меджедович', 'Marija Medjedovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'marija-medjedovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Donja Gorica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Stojan Terzić (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'stojan-terzic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'stojan-terzic', 'Stojan Terzić', 'Стојан Терзић', 'Стоян Терзич', 'Stojan Terzic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'stojan-terzic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Donja Gorica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Elenora Vujošević (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'elenora-vujosevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'elenora-vujosevic', 'Elenora Vujošević', 'Еленора Вујошевић', 'Эленора Вуйошевич', 'Elenora Vujosevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'elenora-vujosevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Donja Gorica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Dušan Popović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'dusan-popovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dusan-popovic', 'Dušan Popović', 'Душан Поповић', 'Душан Попович', 'Dusan Popovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'dusan-popovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Gornja Gorica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Ljirim Đokaj (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'ljirim-djokaj');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ljirim-djokaj', 'Ljirim Đokaj', 'Љирим Ђокај', 'Лирим Джокай', 'Ljirim Djokaj', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ljirim-djokaj');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta Gornja Gorica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Bogdan Zogović (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'bogdan-zogovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'bogdan-zogovic', 'Bogdan Zogović', 'Богдан Зоговић', 'Богдан Зогович', 'Bogdan Zogovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'bogdan-zogovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, Ambulanta KAP-a' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Kenan Katana (IDO jul)
SET @d = (SELECT id FROM doctors WHERE slug = 'kenan-katana');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'kenan-katana', 'Kenan Katana', 'Кенан Катана', 'Кенан Катана', 'Kenan Katana', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'kenan-katana');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle, terenske (seoske) ambulante' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Božica Ostojić (IDO maj + vikend okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'bozica-ostojic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'bozica-ostojic', 'Božica Ostojić', 'Божица Остојић', 'Божица Остойич', 'Bozica Ostojic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'bozica-ostojic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Marija Žujović (IDO maj + vikend okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'marija-zujovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marija-zujovic', 'Marija Žujović', 'Марија Жујовић', 'Мария Жуйович', 'Marija Zujovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'marija-zujovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Milena Dragović (IDO maj + vikend sep)
SET @d = (SELECT id FROM doctors WHERE slug = 'milena-dragovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milena-dragovic', 'Milena Dragović', 'Милена Драговић', 'Милена Драгович', 'Milena Dragovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'milena-dragovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Sanja Šarić (IDO jun + vikend sep)
SET @d = (SELECT id FROM doctors WHERE slug = 'sanja-saric');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sanja-saric', 'Sanja Šarić', 'Сања Шарић', 'Саня Шарич', 'Sanja Saric', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'sanja-saric');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Đeneta Kuč (IDO maj + vikend okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'djeneta-kuc');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'djeneta-kuc', 'Đeneta Kuč', 'Ђенета Куч', 'Дженета Куч', 'Djeneta Kuc', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'djeneta-kuc');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Ajla Murić (IDO vikend sep-okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'ajla-muric');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ajla-muric', 'Ajla Murić', 'Ајла Мурић', 'Айла Мурич', 'Ajla Muric', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ajla-muric');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Andrej Bakalbašić (IDO vikend jul-okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'andrej-bakalbasic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'andrej-bakalbasic', 'Andrej Bakalbašić', 'Андреј Бакалбашић', 'Андрей Бакалбашич', 'Andrej Bakalbasic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'andrej-bakalbasic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Lida Ademović (IDO vikend avg-okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'lida-ademovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'lida-ademovic', 'Lida Ademović', 'Лида Адемовић', 'Лида Адемович', 'Lida Ademovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'lida-ademovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Nikola Zelović (IDO vikend okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'nikola-zelovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nikola-zelovic', 'Nikola Zelović', 'Никола Зеловић', 'Никола Зелович', 'Nikola Zelovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'nikola-zelovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Nikolina Boljević (IDO vikend okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'nikolina-boljevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nikolina-boljevic', 'Nikolina Boljević', 'Николина Бољевић', 'Николина Болевич', 'Nikolina Boljevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'nikolina-boljevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Tamara Bešović (IDO vikend jul-okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'tamara-besovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tamara-besovic', 'Tamara Bešović', 'Тамара Бешовић', 'Тамара Бешович', 'Tamara Besovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'tamara-besovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- ─── Izabrani doktor za djecu (IDD) — pediatrics (16) ───

-- Gordana Bijelić (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'gordana-bijelic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'gordana-bijelic', 'Gordana Bijelić', 'Гордана Бијелић', 'Гордана Биелич', 'Gordana Bijelic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'gordana-bijelic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Haki Mavrić (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'haki-mavric');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'haki-mavric', 'Haki Mavrić', 'Хаки Маврић', 'Хаки Маврич', 'Haki Mavric', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'haki-mavric');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Gordana Marojević (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'gordana-marojevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'gordana-marojevic', 'Gordana Marojević', 'Гордана Маројевић', 'Гордана Мароевич', 'Gordana Marojevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'gordana-marojevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Stara Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Aida Perizović-Osmanović (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'aida-perizovic-osmanovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aida-perizovic-osmanovic', 'Aida Perizović-Osmanović', 'Аида Перизовић-Османовић', 'Аида Перизович-Османович', 'Aida Perizovic-Osmanovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'aida-perizovic-osmanovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Stari Aerodrom' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Alma Drešević (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'alma-dresevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'alma-dresevic', 'Alma Drešević', 'Алма Дрешевић', 'Алма Дрешевич', 'Alma Dresevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'alma-dresevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Stari Aerodrom' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Ljiljana Plamenac (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'ljiljana-plamenac');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ljiljana-plamenac', 'Ljiljana Plamenac', 'Љиљана Пламенац', 'Лиляна Пламенац', 'Ljiljana Plamenac', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ljiljana-plamenac');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Stari Aerodrom' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Mirjana Tijanić Malidžan (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'mirjana-tijanic-malidzan');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mirjana-tijanic-malidzan', 'Mirjana Tijanić Malidžan', 'Мирјана Тијанић Малиџан', 'Мирьяна Тиянич Малиджан', 'Mirjana Tijanic Malidzan', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'mirjana-tijanic-malidzan');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Milutinka Grgur (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'milutinka-grgur');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milutinka-grgur', 'Milutinka Grgur', 'Милутинка Гргур', 'Милутинка Гргур', 'Milutinka Grgur', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'milutinka-grgur');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Jela Knežević (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'jela-knezevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jela-knezevic', 'Jela Knežević', 'Јела Кнежевић', 'Ела Кнежевич', 'Jela Knezevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'jela-knezevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Nova Varoš' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Šućuri Hodžić (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'sucuri-hodzic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sucuri-hodzic', 'Šućuri Hodžić', 'Шућури Хоџић', 'Шучури Ходжич', 'Sucuri Hodzic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'sucuri-hodzic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Konik' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Merica Ademović (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'merica-ademovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'merica-ademovic', 'Merica Ademović', 'Мерица Адемовић', 'Мерица Адемович', 'Merica Ademovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'merica-ademovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Tuzi' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Nikoleta Badnjar (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'nikoleta-badnjar');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nikoleta-badnjar', 'Nikoleta Badnjar', 'Николета Бадњар', 'Николета Бадняр', 'Nikoleta Badnjar', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'nikoleta-badnjar');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Golubovci' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Slobodan Vukotić (IDD apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'slobodan-vukotic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'slobodan-vukotic', 'Slobodan Vukotić', 'Слободан Вукотић', 'Слободан Вукотич', 'Slobodan Vukotic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'slobodan-vukotic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu, ZO Zlatica' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Mirela Hodžić (IDD noćna jun-avg)
SET @d = (SELECT id FROM doctors WHERE slug = 'mirela-hodzic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mirela-hodzic', 'Mirela Hodžić', 'Мирела Хоџић', 'Мирела Ходжич', 'Mirela Hodzic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'mirela-hodzic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Ivan Vukčević (IDD noćna jul-avg)
SET @d = (SELECT id FROM doctors WHERE slug = 'ivan-vukcevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivan-vukcevic', 'Ivan Vukčević', 'Иван Вукчевић', 'Иван Вукчевич', 'Ivan Vukcevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ivan-vukcevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Tamara Milović (dopunski jan-apr)
SET @d = (SELECT id FROM doctors WHERE slug = 'tamara-milovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tamara-milovic', 'Tamara Milović', 'Тамара Миловић', 'Тамара Милович', 'Tamara Milovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'tamara-milovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- ─── Izabrani doktor za žene (IDŽ) — gynecology_obstetrics (4) ───

-- Vanja Popović (IDZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'vanja-popovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vanja-popovic', 'Vanja Popović', 'Вања Поповић', 'Ваня Попович', 'Vanja Popovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'vanja-popovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'gynecology_obstetrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za žene, ZO Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Mersiha Frljučkić (IDZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'mersiha-frljuckic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mersiha-frljuckic', 'Mersiha Frljučkić', 'Мерсиха Фрључкић', 'Мерсиха Фрлючкич', 'Mersiha Frljuckic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'mersiha-frljuckic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'gynecology_obstetrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za žene, ZO Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Biljana Dakić-Poltiković (IDZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'biljana-dakic-poltikovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'biljana-dakic-poltikovic', 'Biljana Dakić-Poltiković', 'Биљана Дакић-Полтиковић', 'Биляна Дакич-Полтикович', 'Biljana Dakic-Poltikovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'biljana-dakic-poltikovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'gynecology_obstetrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za žene, ZO Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Mitra Mugoša (IDZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'mitra-mugosa');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mitra-mugosa', 'Mitra Mugoša', 'Митра Мугоша', 'Митра Мугоша', 'Mitra Mugosa', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'mitra-mugosa');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'gynecology_obstetrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Izabrani doktor za žene, ZO Blok V' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- ─── Centri i ambulante (26) ───

-- Ljiljana Vučeljić (CMZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'ljiljana-vuceljic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ljiljana-vuceljic', 'Ljiljana Vučeljić', 'Љиљана Вучељић', 'Лиляна Вучелич', 'Ljiljana Vuceljic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ljiljana-vuceljic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'psychiatry' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za mentalno zdravlje' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Ljubinko Kaluđerović (CMZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'ljubinko-kaludjerovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ljubinko-kaludjerovic', 'Ljubinko Kaluđerović', 'Љубинко Калуђеровић', 'Любинко Калуджерович', 'Ljubinko Kaludjerovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ljubinko-kaludjerovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'psychiatry' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za mentalno zdravlje' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Ivana Šiljak (CMZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'ivana-siljak');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivana-siljak', 'Ivana Šiljak', 'Ивана Шиљак', 'Ивана Шиляк', 'Ivana Siljak', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ivana-siljak');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'psychiatry' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za mentalno zdravlje' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Milena Slovinić (CMZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'milena-slovinic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milena-slovinic', 'Milena Slovinić', 'Милена Словинић', 'Милена Словинич', 'Milena Slovinic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'milena-slovinic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'psychiatry' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za mentalno zdravlje' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Marko Đurđić (CMZ okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'marko-djurdjic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marko-djurdjic', 'Marko Đurđić', 'Марко Ђурђић', 'Марко Джурджич', 'Marko Djurdjic', NULL, NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'marko-djurdjic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'psychology' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za mentalno zdravlje (spec. medicinske psihologije)' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Bojan Medojević (RTG okt-nov)
SET @d = (SELECT id FROM doctors WHERE slug = 'bojan-medojevic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'bojan-medojevic', 'Bojan Medojević', 'Бојан Медојевић', 'Боян Медоевич', 'Bojan Medojevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'bojan-medojevic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'radiology' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za RTG i ultrazvučnu dijagnostiku' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Nikola Pejović (RTG okt-nov)
SET @d = (SELECT id FROM doctors WHERE slug = 'nikola-pejovic-2');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nikola-pejovic-2', 'Nikola Pejović', 'Никола Пејовић', 'Никола Пейович', 'Nikola Pejovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'nikola-pejovic-2');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'radiology' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za RTG i ultrazvučnu dijagnostiku' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Srđan Perazić (INT okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'srdjan-perazic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'srdjan-perazic', 'Srđan Perazić', 'Срђан Перазић', 'Срджан Перазич', 'Srdjan Perazic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'srdjan-perazic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'internal_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Internistička ambulanta' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Maraš Nikpreljaj (INT okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'maras-nikpreljaj');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'maras-nikpreljaj', 'Maraš Nikpreljaj', 'Мараш Никпрељај', 'Мараш Никпреляй', 'Maras Nikpreljaj', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'maras-nikpreljaj');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'internal_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Internistička ambulanta' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Vesna Braunović (INT okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'vesna-braunovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vesna-braunovic', 'Vesna Braunović', 'Весна Брауновић', 'Весна Браунович', 'Vesna Braunovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'vesna-braunovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'internal_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Internistička ambulanta' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Svetlana Keković (MR okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'svetlana-kekovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'svetlana-kekovic', 'Svetlana Keković', 'Светлана Кековић', 'Светлана Кекович', 'Svetlana Kekovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'svetlana-kekovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'occupational_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za medicinu rada' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Savica Mićković (MR okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'savica-mickovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'savica-mickovic', 'Savica Mićković', 'Савица Мићковић', 'Савица Мичкович', 'Savica Mickovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'savica-mickovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'occupational_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za medicinu rada' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Cvetana Vukajlović (MR okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'cvetana-vukajlovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'cvetana-vukajlovic', 'Cvetana Vukajlović', 'Цветана Вукајловић', 'Цветана Вукайлович', 'Cvetana Vukajlovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'cvetana-vukajlovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'occupational_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za medicinu rada' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Andrea Pejović Jelenković (MR okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'andrea-pejovic-jelenkovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'andrea-pejovic-jelenkovic', 'Andrea Pejović Jelenković', 'Андреа Пејовић Јеленковић', 'Андреа Пейович Еленкович', 'Andrea Pejovic Jelenkovic', NULL, NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'andrea-pejovic-jelenkovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'psychology' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za medicinu rada (psiholog)' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Tomislav Šimun (OFT sep)
SET @d = (SELECT id FROM doctors WHERE slug = 'tomislav-simun');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tomislav-simun', 'Tomislav Šimun', 'Томислав Шимун', 'Томислав Шимун', 'Tomislav Simun', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'tomislav-simun');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'ophthalmology' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Šef Oftalmološke ambulante' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Mirela Hadrović (OFT sep)
SET @d = (SELECT id FROM doctors WHERE slug = 'mirela-hadrovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mirela-hadrovic', 'Mirela Hadrović', 'Мирела Хадровић', 'Мирела Хадрович', 'Mirela Hadrovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'mirela-hadrovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'ophthalmology' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Oftalmološka ambulanta' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Snežana Mitrović (SPORT okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'snezana-mitrovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'snezana-mitrovic', 'Snežana Mitrović', 'Снежана Митровић', 'Снежана Митрович', 'Snezana Mitrovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'snezana-mitrovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za sportsku medicinu (spec. sportske medicine)' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Dalibor Ćorić (SPORT okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'dalibor-coric');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dalibor-coric', 'Dalibor Ćorić', 'Далибор Ћорић', 'Далибор Чорич', 'Dalibor Coric', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'dalibor-coric');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za sportsku medicinu (spec. sportske medicine)' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Sašenko Ćeranić (SPORT okt)
SET @d = (SELECT id FROM doctors WHERE slug = 'sasenko-ceranic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sasenko-ceranic', 'Sašenko Ćeranić', 'Сашенко Ћеранић', 'Сашенко Черанич', 'Sasenko Ceranic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'sasenko-ceranic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za sportsku medicinu (spec. sportske medicine)' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Stanka Mrdak (CDPP maj)
SET @d = (SELECT id FROM doctors WHERE slug = 'stanka-mrdak');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'stanka-mrdak', 'Stanka Mrdak', 'Станка Мрдак', 'Станка Мрдак', 'Stanka Mrdak', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'stanka-mrdak');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za djecu sa posebnim potrebama' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Duško Džiknić (CDPP maj)
SET @d = (SELECT id FROM doctors WHERE slug = 'dusko-dziknic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dusko-dziknic', 'Duško Džiknić', 'Душко Џикнић', 'Душко Джикнич', 'Dusko Dziknic', NULL, NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'dusko-dziknic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'speech_therapy' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za djecu sa posebnim potrebama (logoped)' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Dubravka Lazarević-Terzić (CDPP maj)
SET @d = (SELECT id FROM doctors WHERE slug = 'dubravka-lazarevic-terzic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dubravka-lazarevic-terzic', 'Dubravka Lazarević-Terzić', 'Дубравка Лазаревић-Терзић', 'Дубравка Лазаревич-Терзич', 'Dubravka Lazarevic-Terzic', NULL, NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'dubravka-lazarevic-terzic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'psychology' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za djecu sa posebnim potrebama (psiholog)' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Aleksandra Klisić (LAB sep)
SET @d = (SELECT id FROM doctors WHERE slug = 'aleksandra-klisic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aleksandra-klisic', 'Aleksandra Klisić', 'Александра Клисић', 'Александра Клисич', 'Aleksandra Klisic', 'Doc. dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'aleksandra-klisic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'clinical_biochemistry' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Šefica Centra za laboratorijsku dijagnostiku' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Ozrenka Kurgaš (LAB sep)
SET @d = (SELECT id FROM doctors WHERE slug = 'ozrenka-kurgas');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ozrenka-kurgas', 'Ozrenka Kurgaš', 'Озренка Кургаш', 'Озренка Кургаш', 'Ozrenka Kurgas', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'ozrenka-kurgas');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'clinical_biochemistry' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za laboratorijsku dijagnostiku' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Mirela Šebek (LAB sep)
SET @d = (SELECT id FROM doctors WHERE slug = 'mirela-sebek');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mirela-sebek', 'Mirela Šebek', 'Мирела Шебек', 'Мирела Шебек', 'Mirela Sebek', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'mirela-sebek');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'clinical_biochemistry' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za laboratorijsku dijagnostiku' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- Andrea Ivanović (LAB sep)
SET @d = (SELECT id FROM doctors WHERE slug = 'andrea-ivanovic');
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'andrea-ivanovic', 'Andrea Ivanović', 'Андреа Ивановић', 'Андреа Иванович', 'Andrea Ivanovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = (SELECT id FROM doctors WHERE slug = 'andrea-ivanovic');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'clinical_biochemistry' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic, 'Centar za laboratorijsku dijagnostiku' FROM dual WHERE @d IS NOT NULL AND @clinic IS NOT NULL;

-- ═══ VERIFICATION ═══

SELECT COUNT(*) AS doctors_at_clinic FROM doctor_clinics dc JOIN clinics c ON c.id = dc.clinic_id
WHERE c.slug = 'dom-zdravlja-podgorica';
-- očekivano: 177

SELECT s.name AS specialty, COUNT(*) AS n FROM doctor_clinics dc
JOIN clinics c ON c.id = dc.clinic_id
JOIN doctor_specialties ds ON ds.doctor_id = dc.doctor_id
JOIN specialties s ON s.id = ds.specialty_id
WHERE c.slug = 'dom-zdravlja-podgorica' GROUP BY s.name ORDER BY n DESC;

-- novi ljekari bez specijalnosti / jezika (očekivano: prazno)
SELECT d.slug FROM doctors d
WHERE d.slug IN ('marina-bugarin', 'veselin-kandic', 'ivana-jovanovic-2', 'jasmina-kajabegovic-martinovic', 'aldijana-zekovic', 'slobodanka-marojevic', 'nela-sekulic', 'zorica-boricic', 'milena-cojic', 'ana-tmusic', 'amina-sahmanovic', 'jelena-stojovic', 'tijana-petric', 'vesko-kovijanic', 'gordana-babic', 'ivana-despotovic', 'milijana-vujovic', 'jelena-stankovic', 'radmila-bojic', 'snezana-mikavica', 'marija-vukovic', 'marijana-simonovic', 'dragana-perovic', 'jelena-radusinovic', 'stefan-prascevic', 'rosa-brinic', 'dragoslava-cipranic', 'natasa-radonjic', 'denisa-frljuckic', 'liridon-dushaj', 'radojka-lekic', 'adela-dizdarevic', 'selena-kenic', 'snezana-micanovic', 'merzika-hodzic', 'jasna-kalac-cekic', 'branka-grujevic', 'anela-omeragic', 'natalija-popovic-petric', 'marija-bulatovic', 'miljana-janjusevic', 'biljana-danaj', 'novak-prascevic', 'jelena-cetkovic', 'jelena-ivanovic', 'maja-lalicic', 'elvidina-numanovic', 'ena-vesovic', 'jadranka-papic-radunovic', 'rade-vlahovic', 'mirjana-dobrovic-milosevic', 'branko-popadic', 'natasa-nisavic', 'melisa-spahic', 'danica-knezevic', 'milena-pelicic', 'nedzmija-berisa', 'tereze-dreshaj', 'halil-dukovic', 'sejla-batilovic', 'marina-radovic', 'anita-vujicic', 'dusica-knezevic', 'vesna-djuretic', 'marina-jacimovic', 'ljiljana-djurovic', 'svetlana-terzic', 'danijela-siljkovic', 'lidija-samardzic', 'branka-djurisic', 'ljiljana-markovic', 'vesna-milicevic', 'mihajlo-vukanic', 'jasminka-zec-saveljic', 'erna-hot', 'andjela-aletic', 'jasna-furtula', 'jelena-damjanovic', 'marija-medjedovic', 'stojan-terzic', 'elenora-vujosevic', 'dusan-popovic', 'ljirim-djokaj', 'bogdan-zogovic', 'kenan-katana', 'bozica-ostojic', 'marija-zujovic', 'milena-dragovic', 'sanja-saric', 'djeneta-kuc', 'ajla-muric', 'andrej-bakalbasic', 'lida-ademovic', 'nikola-zelovic', 'nikolina-boljevic', 'tamara-besovic', 'gordana-bijelic', 'haki-mavric', 'gordana-marojevic', 'aida-perizovic-osmanovic', 'alma-dresevic', 'ljiljana-plamenac', 'mirjana-tijanic-malidzan', 'milutinka-grgur', 'jela-knezevic', 'sucuri-hodzic', 'merica-ademovic', 'nikoleta-badnjar', 'slobodan-vukotic', 'mirela-hodzic', 'ivan-vukcevic', 'tamara-milovic', 'vanja-popovic', 'mersiha-frljuckic', 'biljana-dakic-poltikovic', 'mitra-mugosa', 'ljiljana-vuceljic', 'ljubinko-kaludjerovic', 'ivana-siljak', 'milena-slovinic', 'marko-djurdjic', 'bojan-medojevic', 'nikola-pejovic-2', 'srdjan-perazic', 'maras-nikpreljaj', 'vesna-braunovic', 'svetlana-kekovic', 'savica-mickovic', 'cvetana-vukajlovic', 'andrea-pejovic-jelenkovic', 'tomislav-simun', 'mirela-hadrovic', 'snezana-mitrovic', 'dalibor-coric', 'sasenko-ceranic', 'stanka-mrdak', 'dusko-dziknic', 'dubravka-lazarevic-terzic', 'aleksandra-klisic', 'ozrenka-kurgas', 'mirela-sebek', 'andrea-ivanovic')
  AND (NOT EXISTS (SELECT 1 FROM doctor_specialties ds WHERE ds.doctor_id = d.id)
       OR NOT EXISTS (SELECT 1 FROM doctor_languages dl WHERE dl.doctor_id = d.id));

-- postojeći ljekari koji nisu nađeni po slug-u (očekivano: prazno)
SELECT x.slug FROM (SELECT 'sanela-muminovic' AS slug UNION ALL SELECT 'ivana-novovic' AS slug UNION ALL SELECT 'dusica-gojkovic' AS slug UNION ALL SELECT 'ivana-lakicevic' AS slug UNION ALL SELECT 'anja-djurovic' AS slug UNION ALL SELECT 'rajka-pajovic' AS slug UNION ALL SELECT 'biljana-raicevic-fustar' AS slug UNION ALL SELECT 'ana-vukcevic' AS slug UNION ALL SELECT 'edita-basovic' AS slug UNION ALL SELECT 'saida-zejnilovic' AS slug UNION ALL SELECT 'snezana-perazic' AS slug UNION ALL SELECT 'snezana-sebek' AS slug UNION ALL SELECT 'alma-dervisevic' AS slug UNION ALL SELECT 'zeljka-ralevic' AS slug UNION ALL SELECT 'milovan-jovanovic' AS slug UNION ALL SELECT 'jelena-terzic-miranovic' AS slug UNION ALL SELECT 'aleksandar-boljevic' AS slug UNION ALL SELECT 'zeljka-stevovic' AS slug UNION ALL SELECT 'natasa-tomasevic' AS slug UNION ALL SELECT 'ersan-basovic' AS slug UNION ALL SELECT 'milica-gazivoda' AS slug UNION ALL SELECT 'maida-burdzovic' AS slug UNION ALL SELECT 'branka-purlija' AS slug UNION ALL SELECT 'andja-bulajic-vukovic' AS slug UNION ALL SELECT 'djuric-danilo' AS slug UNION ALL SELECT 'alma-crnovrsanin' AS slug UNION ALL SELECT 'ana-icevic' AS slug UNION ALL SELECT 'katarina-kalezic' AS slug UNION ALL SELECT 'jelena-obadovic' AS slug UNION ALL SELECT 'enisa-pupovic' AS slug UNION ALL SELECT 'milenka-uscumlic' AS slug UNION ALL SELECT 'dubravka-lopicic' AS slug UNION ALL SELECT 'amer-halilovic' AS slug UNION ALL SELECT 'dragana-radunovic' AS slug UNION ALL SELECT 'danica-vesovic' AS slug) x
LEFT JOIN doctors d ON d.slug = x.slug WHERE d.id IS NULL;
