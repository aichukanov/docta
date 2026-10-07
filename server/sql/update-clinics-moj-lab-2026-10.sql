-- Moj Lab: website и phone по новому сайту (Webflow), проверка 2026-10-02.
-- Старые URL вида https://www.mojlab.me/poliklinika/<город> отдают 404;
-- новые — https://mojlab.me/lokacije/<локация> (из sitemap.xml, отвечают 200).
-- Телефон: у всех пяти в БД пусто, на каждой странице локации — call-центр 19989
-- (короткий номер; прецедент формата — smartmed-kotor, 19808).
-- Соответствие клиника ↔ локация подтверждено адресом, email и часами работы.
-- Адреса и часы НЕ меняются: адреса совпадают, расхождение часов у moj-lab-ulcinj
-- вынесено в отчёт как вопрос.
-- Клиники только по slug (id локально и на проде расходятся); каждое UPDATE — с условием
-- на старое значение, повторный прогон ничего не меняет.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

START TRANSACTION;

UPDATE clinics SET website = 'https://mojlab.me/lokacije/poliklinika-podgorica'
WHERE slug = 'moj-lab-podgorica-1' AND website = 'https://www.mojlab.me/poliklinika/podgorica';

-- Bulevar 21. maj, Donja Gorica: по этому адресу две локации — Bolnica (24/7) и
-- Poliklinika Donja Gorica (IVF). Наши часы (пн–пт 07–21, сб 08–21, вс закрыто) и email
-- poliklinika@mojlab.me совпадают с поликлиникой, не с больницей.
UPDATE clinics SET website = 'https://mojlab.me/lokacije/poliklinika-donja-gorica'
WHERE slug = 'moj-lab-podgorica-2' AND (website = '' OR website IS NULL);

UPDATE clinics SET website = 'https://mojlab.me/lokacije/poliklinika-budva'
WHERE slug = 'moj-lab-budva' AND website = 'https://www.mojlab.me/poliklinika/budva';

UPDATE clinics SET website = 'https://mojlab.me/lokacije/poliklinika-ulcinj'
WHERE slug = 'moj-lab-ulcinj' AND website = 'https://www.mojlab.me/poliklinika/ulcinj';

UPDATE clinics SET website = 'https://mojlab.me/lokacije/pedijatrija-podgorica'
WHERE slug = 'moj-lab-pedijatria-podgorica' AND website = 'https://www.mojlab.me/pedijatrijska-poliklinika/podgorica';

UPDATE clinics SET phone = '19989'
WHERE slug IN ('moj-lab-podgorica-1', 'moj-lab-podgorica-2', 'moj-lab-budva', 'moj-lab-ulcinj', 'moj-lab-pedijatria-podgorica')
  AND (phone = '' OR phone IS NULL);

COMMIT;

SELECT slug, phone, website FROM clinics
WHERE slug IN ('moj-lab-podgorica-1', 'moj-lab-podgorica-2', 'moj-lab-budva', 'moj-lab-ulcinj', 'moj-lab-pedijatria-podgorica')
ORDER BY slug;
