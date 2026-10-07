SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Nova Medic Poliklinika: отвязка ушедших врачей + специальность у записи 2311.
--
-- 1. 2026-09-30 клиника перешла на дерматологию и эстетику и убрала из «Naš tim»
--    (https://novamedic.me/nas-tim/) шестерых — всех, кто вёл снятые разделы прайса
--    (см. insert-clinic-prices-nova-medic-poliklinika.sql и
--    data/clinic-imports/nova-medic-poliklinika-prices-2026-10.md). В мае они в «Naš tim»
--    были: data/clinic-pricelists/sources/nova-medic-poliklinika/nas-tim-2026-05-14.wayback.html
--    (web.archive.org/web/20260514105852/https://novamedic.me/nas-tim/).
--      borislav-mandic        — терапевт, эндокринолог (3 отзыва)
--      dragana-radunovic      — физиатр
--      marina-delic           — физиатр, пульмолог
--      mapp-milos-kuzmanovic  — физиотерапевт (7 отзывов)
--      milena-markovic        — физиотерапевт
--      anja-asanovic          — физиотерапевт
--    Других клиник у них в БД нет. По решению юзера только отвязываем: профили
--    остаются публичными, без места работы, отзывы видны. Ни у кого нет
--    user_id и строк в clinic_medical_service_doctors по этой клинике.
--    Остаются привязаны: dragan-lagator, vladan-boskovic, dejan-biro.
--
-- 2. dermatologist-examination-with-dermatoscopy (2311) была привязана к
--    специальности 14 (pulmonology) вместо 7 (dermatovenerology) — у всех
--    остальных записей дерматоскопии специальность 7.
--
-- Врачи, клиника и услуга — по slug. Повторный прогон безопасен.

-- ═══ 1. Отвязка врачей ═══

DELETE x
  FROM clinic_medical_service_doctors x
  JOIN doctors d ON d.id = x.doctor_id
  JOIN clinics c ON c.id = x.clinic_id AND c.slug = 'nova-medic-poliklinika'
 WHERE d.slug IN ('borislav-mandic', 'dragana-radunovic', 'marina-delic',
                  'mapp-milos-kuzmanovic', 'milena-markovic', 'anja-asanovic');

DELETE dc
  FROM doctor_clinics dc
  JOIN doctors d ON d.id = dc.doctor_id
  JOIN clinics c ON c.id = dc.clinic_id AND c.slug = 'nova-medic-poliklinika'
 WHERE d.slug IN ('borislav-mandic', 'dragana-radunovic', 'marina-delic',
                  'mapp-milos-kuzmanovic', 'milena-markovic', 'anja-asanovic');

-- ═══ 2. Специальность записи 2311 ═══

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 7 FROM medical_services WHERE slug = 'dermatologist-examination-with-dermatoscopy';

DELETE s
  FROM medical_services_specialties s
  JOIN medical_services ms ON ms.id = s.medical_service_id AND ms.slug = 'dermatologist-examination-with-dermatoscopy'
 WHERE s.specialty_id = 14;

-- ═══ VERIFICATION ═══

-- Ожидается 3 строки: dejan-biro, dragan-lagator, vladan-boskovic.
SELECT d.slug
  FROM doctor_clinics dc
  JOIN doctors d ON d.id = dc.doctor_id
  JOIN clinics c ON c.id = dc.clinic_id
 WHERE c.slug = 'nova-medic-poliklinika'
 ORDER BY d.slug;

-- Ожидается 6 строк, у всех clinics = 0.
SELECT d.slug, (SELECT COUNT(*) FROM doctor_clinics x WHERE x.doctor_id = d.id) AS clinics
  FROM doctors d
 WHERE d.slug IN ('borislav-mandic', 'dragana-radunovic', 'marina-delic',
                  'mapp-milos-kuzmanovic', 'milena-markovic', 'anja-asanovic')
 ORDER BY d.slug;

-- Ожидается specialties = 7.
SELECT ms.slug, GROUP_CONCAT(s.specialty_id ORDER BY s.specialty_id) AS specialties
  FROM medical_services ms
  LEFT JOIN medical_services_specialties s ON s.medical_service_id = ms.id
 WHERE ms.slug = 'dermatologist-examination-with-dermatoscopy'
 GROUP BY ms.slug;
