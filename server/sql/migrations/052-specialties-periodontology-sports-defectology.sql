SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 052: три новые специальности врачей — пародонтология (95), спортивная медицина (96),
-- дефектология (97). Решение юзера 2026-10-07 после сравнения с конкурентами
-- (data/clinic-teams/BACKLOG.md): у пародонтологии и спортивной медицины — признанные
-- специализации ЧГ (Pravilnik o specijalizacijama 2025), отдельный фильтр у большинства
-- каталогов; дефектолог — немедицинская профессия, но услуги оплачивает FZOCG и у
-- родителей детей с нарушениями развития есть прямой спрос. Судебная медицина и эмбриолог
-- не заводятся (нет пациентского выбора).
--
-- КОД И МИГРАЦИЯ — В ЛЮБОМ ПОРЯДКЕ: enums/specialty.ts и i18n/specialty.ts знают id 95–97,
-- врачи с этими id появятся только после миграции; без кода специальность в БД просто не
-- показывается в фильтре.
--
-- 1. specialties: id задан явно — он же значение enum DoctorSpecialty.
-- 2. Врачи (только с основанием на сайте или в БД):
--    пародонтология — Ana Bulatović (Apolonia, «Specijalista parodontologije»; dentistry был
--      временной заменой — снимается), Tatjana Džarić (КЦЦГ, Odjeljenje parodontologije i
--      oralne medicine), Tihomir Jović (Dukley, «Specijalizovan za parodontologiju i oralnu medicinu»);
--    спортивная медицина — Snežana Mitrović, Dalibor Ćorić, Sašenko Ćeranić (ДЗ Подгорица,
--      «spec. sportske medicine»; general_medicine был заменой — снимается), Jasmina Živković
--      (ДЗ Херцег-Нови, служба спортивной медицины; general_medicine остаётся), Nada Krivokapić
--      (Balans, «Spec. med. sporta»; физикальная медицина была заменой — снимается);
--    дефектология — Senka Živković (Doktorica Mica, «dipl. defektolog – logoped»), Nataša Labović
--      (Moj Lab, раздел «Defektologija»); логопедия у обеих остаётся.
-- 3. Услуги → специальность (medical_services_specialties, только добавление):
--    9 пародонтальных; 4 спортивные (справки спортсменам и судьям, спортивно-медицинский
--    осмотр); 13 дефектологических (двум «defektološki logopedski» — ещё и логопедия).
-- Врачи, услуги, специальности — по slug / name. Повторный прогон ничего не меняет.

-- ═══ 1. Специальности ═══

INSERT IGNORE INTO specialties (id, name) VALUES
	(95, 'periodontology'),
	(96, 'sports_medicine'),
	(97, 'defectology');

SET @perio = (SELECT id FROM specialties WHERE name = 'periodontology');
SET @sport = (SELECT id FROM specialties WHERE name = 'sports_medicine');
SET @defekt = (SELECT id FROM specialties WHERE name = 'defectology');
SET @dentistry = (SELECT id FROM specialties WHERE name = 'dentistry');
SET @general = (SELECT id FROM specialties WHERE name = 'general_medicine');
SET @pmr = (SELECT id FROM specialties WHERE name = 'Physical Medicine and Rehabilitation');
SET @speech = (SELECT id FROM specialties WHERE name = 'speech_therapy');

-- ═══ 2. Врачи ═══

-- пародонтология
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT d.id, @perio FROM doctors d
WHERE d.slug IN ('ana-bulatovic-2', 'tatjana-dzaric', 'tihomir-jovic') AND @perio IS NOT NULL;

DELETE ds FROM doctor_specialties ds JOIN doctors d ON d.id = ds.doctor_id
WHERE d.slug = 'ana-bulatovic-2' AND ds.specialty_id = @dentistry AND @perio IS NOT NULL;

-- спортивная медицина
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT d.id, @sport FROM doctors d
WHERE d.slug IN ('snezana-mitrovic', 'dalibor-coric', 'sasenko-ceranic', 'jasmina-zivkovic', 'nada-krivokapic')
	AND @sport IS NOT NULL;

DELETE ds FROM doctor_specialties ds JOIN doctors d ON d.id = ds.doctor_id
WHERE d.slug IN ('snezana-mitrovic', 'dalibor-coric', 'sasenko-ceranic')
	AND ds.specialty_id = @general AND @sport IS NOT NULL;

DELETE ds FROM doctor_specialties ds JOIN doctors d ON d.id = ds.doctor_id
WHERE d.slug = 'nada-krivokapic' AND ds.specialty_id = @pmr AND @sport IS NOT NULL;

-- дефектология
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
SELECT d.id, @defekt FROM doctors d
WHERE d.slug IN ('senka-zivkovic', 'natasa-labovic') AND @defekt IS NOT NULL;

-- ═══ 3. Услуги ═══

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT m.id, @perio FROM medical_services m
WHERE m.slug IN (
	'periodontal-scaling-root-planing',
	'flap-surgery-periodontal',
	'periodontal-surgical-therapy-flap-surgery-per-tooth',
	'periodontal-flap-surgery-with-bone-graft-per-tooth',
	'periodontal-splint',
	'periodontal-pocket-treatment',
	'surgical-treatment-of-recurrent-periodontal-abscess',
	'periodontal-abscess-incision-and-drainage',
	'periodontal-dressing-application'
) AND @perio IS NOT NULL;

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT m.id, @sport FROM medical_services m
WHERE m.slug IN (
	'medical-certificate-for-athletes',
	'medical-certificate-for-sports-referees',
	'medical-certificate-for-sports-referees-and-other-purposes',
	'sports-medical-examination'
) AND @sport IS NOT NULL;

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT m.id, @defekt FROM medical_services m
WHERE m.slug IN (
	'developmental-defectology-assessment-small-child',
	'developmental-defectology-assessment-school-child',
	'psychomotor-instability-defectology-treatment',
	'group-defectology-treatment-school-child',
	'defectologist-parental-counseling',
	'defectology-multidisciplinary-patient-workup',
	'learning-disorder-defectology-speech-therapy',
	'individual-defectology-speech-therapy-treatment-for-spp',
	'group-defectology-work-with-parent-and-children',
	'individual-defectology-treatment-small-child',
	'group-defectology-treatment-small-child',
	'individual-defectology-treatment-school-child',
	'defectologists-findings-and-opinion'
) AND @defekt IS NOT NULL;

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT m.id, @speech FROM medical_services m
WHERE m.slug IN ('learning-disorder-defectology-speech-therapy', 'individual-defectology-speech-therapy-treatment-for-spp')
	AND @speech IS NOT NULL;

-- ═══ VERIFICATION ═══

SELECT id, name FROM specialties WHERE id IN (95, 96, 97);
-- ожидание: 95 periodontology, 96 sports_medicine, 97 defectology

SELECT s.name AS specialty, GROUP_CONCAT(d.slug ORDER BY d.slug) AS doctors
FROM doctor_specialties ds JOIN specialties s ON s.id = ds.specialty_id JOIN doctors d ON d.id = ds.doctor_id
WHERE s.id IN (95, 96, 97) GROUP BY s.name;
-- ожидание: periodontology 3, sports_medicine 5, defectology 2

SELECT s.name AS specialty, COUNT(*) AS services
FROM medical_services_specialties mss JOIN specialties s ON s.id = mss.specialty_id
WHERE s.id IN (95, 96, 97) GROUP BY s.name;
-- ожидание: periodontology 9, sports_medicine 4, defectology 13

SELECT d.slug, GROUP_CONCAT(s.name ORDER BY s.name) AS specialties
FROM doctors d JOIN doctor_specialties ds ON ds.doctor_id = d.id JOIN specialties s ON s.id = ds.specialty_id
WHERE d.slug IN ('ana-bulatovic-2', 'snezana-mitrovic', 'dalibor-coric', 'sasenko-ceranic', 'nada-krivokapic')
GROUP BY d.slug;
-- ожидание: у пяти не осталось временной замены (dentistry / general_medicine / физикальная медицина)
