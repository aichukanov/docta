-- Moj Lab: подпись «Poliklinika» в названиях и чистка категорий (2026-10-02).
-- Применять ПОСЛЕ insert-clinics-moj-lab-network-2026-10.sql.
--
-- Названия: у четырёх поликлиник сети тип не был подписан («Moj Lab Budva»),
-- а рядом теперь стоят «Moj Lab Laboratorija Budva» и «Moj Lab Pedijatrija Budva»
-- по тому же адресу. Подпись — как у Google («Moj Lab Poliklinika Ulcinj») и на
-- сайте сети («Poliklinika Podgorica (Dalmatinska)», «Poliklinika Donja Gorica (IVF)»).
-- Слаги не меняются.
--
-- Категории — по конвенции каталога:
--   * многопрофильная поликлиника — только 1 (как milmedika-*, hipokrat-*):
--     у Dalmatinska, Budva, Ulcinj снимается 4 «лаборатория» — лаборатории сети
--     теперь отдельными карточками;
--   * Donja Gorica — IVF-центр: 1 + 7 (как humana-reprodukcija-budva — 7), без 4;
--   * педиатрия Podgorica — 1 + 12, как новые педиатрии Budva/Ulcinj, без 4
--     (лаборатория City kvart в том же здании — отдельная карточка).
-- Остальные 12 карточек сети уже типизированы правильно: лаборатории — 4,
-- педиатрии — 1+12, больница — 1+3.
--
-- Идемпотентно: переименование — с условием на старое название, типы — DELETE по
-- паре и INSERT по отсутствию пары. Клиники только по slug.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

START TRANSACTION;

-- ── Названия ──
UPDATE clinics SET name_sr = 'Moj Lab Poliklinika Podgorica Dalmatinska', name_sr_cyrl = 'Мој Лаб Поликлиника (Подгорица, Далматинска)'
WHERE slug = 'moj-lab-podgorica-1' AND name_sr = 'Moj Lab Podgorica 1';

UPDATE clinics SET name_sr = 'Moj Lab Poliklinika Podgorica Donja Gorica', name_sr_cyrl = 'Мој Лаб Поликлиника (Подгорица, Доња Горица)'
WHERE slug = 'moj-lab-podgorica-2' AND name_sr = 'Moj Lab Podgorica 2';

UPDATE clinics SET name_sr = 'Moj Lab Poliklinika Budva', name_sr_cyrl = 'Мој Лаб Поликлиника (Будва)'
WHERE slug = 'moj-lab-budva' AND name_sr = 'Moj Lab Budva';

UPDATE clinics SET name_sr = 'Moj Lab Poliklinika Ulcinj', name_sr_cyrl = 'Мој Лаб Поликлиника (Улцињ)'
WHERE slug = 'moj-lab-ulcinj' AND name_sr = 'Moj Lab Ulcinj';

-- ── Категории: снять «лабораторию» (4) ──
DELETE ct FROM clinic_clinic_types ct
JOIN clinics c ON c.id = ct.clinic_id
WHERE ct.clinic_type_id = 4
	AND c.slug IN ('moj-lab-podgorica-1', 'moj-lab-podgorica-2', 'moj-lab-budva', 'moj-lab-ulcinj', 'moj-lab-pedijatrija-podgorica');

-- ── Категории: добавить гинекологию (7) IVF-центру и педиатрию (12) педиатрии ──
INSERT INTO clinic_clinic_types (clinic_id, clinic_type_id)
SELECT c.id, x.type_id
FROM (
	SELECT 'moj-lab-podgorica-2' AS slug, 7 AS type_id
	UNION ALL SELECT 'moj-lab-pedijatrija-podgorica', 12
) AS x
JOIN clinics c ON c.slug = x.slug
WHERE NOT EXISTS (
	SELECT 1 FROM clinic_clinic_types e WHERE e.clinic_id = c.id AND e.clinic_type_id = x.type_id
);

COMMIT;

-- ── VERIFICATION: 17 карточек сети с типами ──
SELECT c.slug, c.name_sr, c.name_sr_cyrl,
	(SELECT GROUP_CONCAT(ct.clinic_type_id ORDER BY ct.clinic_type_id) FROM clinic_clinic_types ct WHERE ct.clinic_id = c.id) AS types
FROM clinics c
WHERE c.slug LIKE 'moj-lab-%'
ORDER BY c.city_id, c.name_sr;
