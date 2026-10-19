-- ═══════════════════════════════════════════════════════════════════════════
-- JZU Dom zdravlja "Dr Nika Labović" Berane — услуги и цены
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dom-zdravlja-berane-services.sql
--
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-dom-zdravlja-berane.sql.
-- Клиника — по google_place_id/slug, услуги — по slug, литеральных id нет.
-- Новых записей каталога НЕТ (правило подволны 2b для домов здоровья).
--
-- Источники цен (собрано 2026-10-08; страницы без даты правки):
--   * /index.php/ljekarska-uvjerenja — «Cjenovnik zdravstvenih usluga koje JZU Dom
--     zdravlja "Dr Nika Labović" Berane pruža trećim licima», на основании акта
--     Ministarstva zdravlja br. 404-220/2015 od 01.10.2015; подпись «Broj: 1623/2,
--     Berane, 07.06.2016». 20 строк «Usluge Medicine rada» (п. 1, 2a–c, 3a–c, 4–8, 9a–b, 10–15).
--     П. 1 (20 €) — «besplatno uz priloženu potvrdu da se lice nalazi na evidenciji
--     Zavoda za zapošljavanje Crne Gore»: записана цена 20 €.
--     П. 3b («C,D i E kategorije, specijalnim vozilima i taxi») — две записи каталога с
--     одним кодом, как у ДЗ Подгорица (taxi отдельной справкой в каталоге).
--   * /index.php/sanitarne-knjizice — «Cjenovnik za zdravstvene preglede … u okviru
--     sanitarnih pregleda», акт МЗ br. 404-220/2015 od 22.06.2016; «Broj: 1727/2,
--     Berane, 29.06.2016». 3 строки (32 / 20 / 15).
--   Сопоставление — по ДЗ Котор / Мойковац / Тиват, у которых тот же министерский шаблон.
--   is_price_outdated не ставится (решение юзера 2026-10-08), дата прайса — в записи импорта.
--
-- Без цены (5) — только то, что сайт называет конкретно: ординации избранных
-- врачей для взрослых, детей и женщин, Internistička ambulanta, вакцинация детей по
-- календарю (пост 2026-05-13). Организационные единицы (Centar za plućne bolesti i TBC,
-- Centar za mentalno zdravlje, Centar za djecu sa smetnjama u razvoju, mikrobiologija,
-- HES, patronaža, fizikalna terapija, sanitetski prevoz, savjetovališta) — не услуги.
-- Тарифы ФЗОЦГ ценами клиники не ставятся.
--
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, цены пишутся
-- ON DUPLICATE KEY UPDATE, лишнее от прошлых прогонов удаляется. ⚠️ Услуги,
-- добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJ6bOlY8KTUhMR1jGc6dKoOkM' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-berane' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-dom-zdravlja-berane.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_dzberane_services;
CREATE TEMPORARY TABLE tmp_dzberane_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	code VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_dzberane_services (slug, price, code) VALUES
-- ── Usluge Medicine rada (ljekarska uvjerenja), 2015/2016 ──────────────────
('pre-employment-medical-certificate', 20.00, 'BE_MR_01'), -- Ljekarsko uvjerenje o sposobnosti za rad, prilikom zasnivanja radnog odnosa (radna mjesta bez povećanih rizika) — 20,00 € (besplatno*)
('medical-certificate-for-general-work', 35.00, 'BE_MR_02a'), -- Ljekarsko uvjerenje o: - sposobnosti za rad pri zapošljavanju i radu na radnim mjestima bez povećanih rizika i otežanim uslovima rada – prethodni /periodični /vanredni — 35,00 €
('medical-certificate-for-high-risk-and-difficult-working-conditions', 70.00, 'BE_MR_02b'), -- Ljekarsko uvjerenje o: - sposobnosti za rad pri zapošljavanju i radu na radnim mjestima sa povećanim rizikom i otežanim uslovima rada – prethodni /periodični /vanredni /sistematski — 70,00 €
('medical-certificate-for-difficult-working-conditions-without-high-risk', 50.00, 'BE_MR_02c'), -- Ljekarsko uvjerenje o: - sposobnosti za rad pri zapošljavanju i radu na radnim mjestima sa otežanim uslovima rada – prethodni /periodični /vanredni — 50,00 €
('medical-certificate-for-class-a-and-b-drivers', 35.00, 'BE_MR_03a'), -- Ljekarsko uvjerenje o - sposobnosti/kontrolni zdravstveni pregled, za upravljanje motornim vozilom u drumskom saobraćaju, A i B kategorije — 35,00 €
('driver-class-c-d-e-health-examination', 50.00, 'BE_MR_03b'), -- Ljekarsko uvjerenje o - sposobnosti/kontrolni zdravstveni pregled, za upravljanje motornim vozilom u drumskom saobraćaju, C,D i E kategorije, specijalnim vozilima i taxi — 50,00 €
('medical-certificate-for-taxi-driver', 50.00, 'BE_MR_03b'), -- та же строка 3b («… specijalnim vozilima i taxi») — 50,00 €; вторая запись каталога по схеме ДЗ Подгорица (одна строка прайса → две справки, один код)
('medical-certificate-for-driving-instructor-category-b-c-d-e', 60.00, 'BE_MR_03c'), -- Ljekarsko uvjerenje o - sposobnosti /kontrolni zdravstveni pregled, za posao instruktora B, C, D i E kategorije — 60,00 €
('medical-certificate-for-firearms-possession', 70.00, 'BE_MR_04'), -- Ljekarsko uvjerenje o podobnosti za posjedovanje vatrenog oružja — 70,00 €
('medical-certificate-for-military-service', 60.00, 'BE_MR_05'), -- Ljekarsko uvjerenje o sposobnosti za obavljanje službe u Vojsci Crne Gore — 60,00 €
('medical-certificate-for-underage-marriage', 25.00, 'BE_MR_06'), -- Ljekarsko uvjerenje za sklapanje braka za maloljetne osobe — 25,00 €
('medical-certificate-for-child-adoption', 25.00, 'BE_MR_07'), -- Ljekarsko uvjerenje za podobnost za usvajanje djeteta — 25,00 €
('medical-certificate-for-study-abroad-and-visa', 25.00, 'BE_MR_08'), -- Ljekarsko uvjerenje za dalji nastavak školovanja i boravak u inostranstvu/viza — 25,00 €
('medical-certificate-for-maritime-workers', 110.00, 'BE_MR_09a'), -- Ljekarsko uvjerenje za: - rad u vodenom saobraćaju (pomorci) — 110,00 €
('medical-certificate-for-lifeguards-divers-and-boat-operators', 35.00, 'BE_MR_09b'), -- Ljekarsko uvjerenje za: - spasioce /ronioce /upravljanje čamcem — 35,00 €
('medical-certificate-for-ionizing-radiation-workers', 85.00, 'BE_MR_10'), -- Ljekarsko uvjerenje – prethodni i periodični pregledi radnika profesionalno izloženih jonizirajućim zračenjem — 85,00 €
('medical-certificate-for-court-expert', 35.00, 'BE_MR_11'), -- Ljekarsko uvjerenje za posao sudskog vještaka — 35,00 €
('medical-certificate-for-life-insurance', 40.00, 'BE_MR_12'), -- Ljekarsko uvjerenje radi životnog osiguranja — 40,00 €
('medical-certificate-for-collective-accommodation', 5.00, 'BE_MR_13'), -- Ljekarsko uvjerenje za kolektivni smještaj — 5,00 €
('medical-certificate-for-athletes', 50.00, 'BE_MR_14'), -- Ljekarsko uvjerenje za utvrđivanje zdravstvene sposobnosti sportiste — 50,00 €
('medical-certificate-for-sports-referees-and-other-purposes', 60.00, 'BE_MR_15'), -- Ljekarsko uvjerenje za druge potrebe (sportske sudije i dr.) — 60,00 €
-- ── Sanitarni pregledi, 2016 ─────────────────────────────────────────────
('sanitary-examination-for-food-industry-and-water-supply-workers', 32.00, 'BE_SAN_1'), -- Sanitarni pregled za zaposlene u proizvodnji, pripremi i prometu hrane (ugostitelji, trgovci i druga lica u vezi sa hranom), kao i na poslovima snadbijevanja građana vodom za piće. — 32,00
('sanitary-examination-for-healthcare-and-educational-workers', 20.00, 'BE_SAN_2'), -- Sanitarni pregled za zaposlene koji rade u zdravstvenim ustanovama u kojima se vrše zdravstveni pregledi, njega, ishrana, u odjeljenjima sa povećanim rizikom, u predškolskim, školskim i drugim ustanovama, ustanovama za stara lica, u proizvodnji i prometu ljekova i prevozu hrane. — 20,00
('sanitary-examination-for-hairdressers-and-service-personnel', 15.00, 'BE_SAN_3'), -- Sanitarni pregled za zaposlene koji rade na zdravstvenim pregledima u ambulantama i laboratorijama, na održavanju higijene u odjeljenjima sa povećanim rizikom i na poslovima higijenske njege građana (frizerski i kozmetički saloni). — 15,00
-- ── Без цены ──────────────────────────────────────────────────────────────
('general-practitioner-examination', NULL, NULL), -- /brojevi-telefona-u-ordinacijama «Izabrani doktori za odrasle» (ordinacije 1–6, «telefon za zakazivanje») + /radno-vrijeme-izabranih-doktora «prije dolaska kod izabranog doktora zakažu pregled»
('pediatric-examination', NULL, NULL), -- /brojevi-telefona-u-ordinacijama «Izabrani doktori za djecu» (ordinacije 1–3); пост 2026-05-13 называет их «Pedijatri»
('gynecological-specialist-examination', NULL, NULL), -- /brojevi-telefona-u-ordinacijama «Izabrani doktori za žene» (ordinacije 1–2); /radno-vrijeme-izabranih-doktora «mijenjaju specijaliste ginekologije iz KBC Berane»
('internist-examination', NULL, NULL), -- /brojevi-telefona-u-ordinacijama «Specijalističke ambulante Doma zdravlja — Internistička ambulanta 069-350-184»
('pediatric-vaccination-and-revaccination-by-schedule', NULL, NULL); -- пост 2026-05-13 «Apel roditeljima…»: «izabrani doktori za djecu … dovedu dijecu u Dom zdravlja … radi vakcinacije propuštenim dozama iz Kalendara obavezne vakcinacije»

-- Страховка: slug, не найденные в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_service
FROM tmp_dzberane_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, NULL, NULL, t.code
FROM tmp_dzberane_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = VALUES(price), price_min = VALUES(price_min), price_max = VALUES(price_max), code = VALUES(code);

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_dzberane_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 29 услуг, с ценой 24, без цены 5, outdated 0, сумма 1062.00.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL) AS with_price, SUM(price IS NULL) AS without_price,
	SUM(is_price_outdated) AS outdated, SUM(price) AS price_sum
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT cms.code, ms.slug, ms.name_sr, cms.price
FROM clinic_medical_services cms JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY cms.code IS NULL, cms.code, ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_dzberane_services;
